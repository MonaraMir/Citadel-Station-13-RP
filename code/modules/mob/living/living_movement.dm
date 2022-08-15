/mob/living/Moved()
	. = ..()
	//update_turf_movespeed(loc)
	if(is_shifted)
		is_shifted = FALSE
		pixel_x = get_standard_pixel_x_offset(lying)
		pixel_y = get_standard_pixel_y_offset(lying)

/mob/living/movement_delay()
	. = ..()
	switch(m_intent)
		if(MOVE_INTENT_RUN)
			if(drowsyness > 0)
				. += 6
			. += config_legacy.run_speed
		if(MOVE_INTENT_WALK)
			. += config_legacy.walk_speed

/mob/living/Move(NewLoc, Dir)
	// what the hell does this do i don't know fine we'll keep it for now..
	if (buckled && buckled.loc != NewLoc) //not updating position
		if(istype(buckled, /mob))	//If you're buckled to a mob, a la slime things, keep on rolling.
			return buckled.Move(NewLoc, Dir)
		else	//Otherwise, no running around for you.
			return 0
	// end

	. = ..()

	if (s_active && !( s_active in contents ) && !(s_active.Adjacent(src)))	//check !( s_active in contents ) first so we hopefully don't have to call get_turf() so much.
		s_active.close(src)

///Checks mobility move as well as parent checks
/mob/living/canface()
/*
	if(!(mobility_flags & MOBILITY_MOVE))
		return FALSE
*/
	if(stat != CONSCIOUS)
		return FALSE
	return ..()

/mob/living/Bump(atom/movable/AM)
	if(now_pushing || !loc)
		return
	now_pushing = 1
	var/old_pulling = pulling
	if (istype(AM, /mob/living))
		var/mob/living/tmob = AM

		//Even if we don't push/swap places, we "touched" them, so spread fire
		spread_fire(tmob)

		for(var/mob/living/M in range(tmob, 1))
			if(tmob.pinned.len ||  ((M.pulling == tmob && ( tmob.restrained() && !( M.restrained() ) && M.stat == 0)) || locate(/obj/item/grab, tmob.grabbed_by.len)) )
				if ( !(world.time % 5) )
					to_chat(src, "<span class='warning'>[tmob] is restrained, you cannot push past</span>")
				now_pushing = 0
				return
			if( tmob.pulling == M && ( M.restrained() && !( tmob.restrained() ) && tmob.stat == 0) )
				if ( !(world.time % 5) )
					to_chat(src, "<span class='warning'>[tmob] is restraining [M], you cannot push past</span>")
				now_pushing = 0
				return

		//BubbleWrap: people in handcuffs are always switched around as if they were on 'help' intent to prevent a person being pulled from being seperated from their puller
		var/can_swap = 1
		if(loc.density || tmob.loc.density)
			can_swap = 0
		if(can_swap)
			for(var/atom/movable/A in loc)
				if(A == src)
					continue
				if(!A.CanPass(tmob, loc))
					can_swap = 0
				if(!can_swap) break
		if(can_swap)
			for(var/atom/movable/A in tmob.loc)
				if(A == tmob)
					continue
				if(!A.CanPass(src, tmob.loc))
					can_swap = 0
				if(!can_swap) break

		//Leaping mobs just land on the tile, no pushing, no anything.
		if(status_flags & LEAPING)
			forceMove(tmob.loc)
			status_flags &= ~LEAPING
			now_pushing = 0
			return

		if((tmob.mob_always_swap || (tmob.a_intent == INTENT_HELP || tmob.restrained()) && (a_intent == INTENT_HELP || src.restrained())) && tmob.canmove && canmove && !tmob.buckled && !buckled && can_swap && can_move_mob(tmob, 1, 0)) // mutual brohugs all around!
			var/turf/oldloc = loc
			forceMove(tmob.loc)

			if (istype(tmob, /mob/living/simple_mob)) //check bumpnom chance, if it's a simplemob that's bumped
				tmob.Bumped(src)
			else if(istype(src, /mob/living/simple_mob)) //otherwise, if it's a simplemob doing the bumping. Simplemob on simplemob doesn't seem to trigger but that's fine.
				Bumped(tmob)
			if (tmob.loc == src) //check if they got ate, and if so skip the forcemove
				now_pushing = 0
				return

			// In case of micros, we don't swap positions; instead occupying the same square!
			if (handle_micro_bump_helping(tmob))
				now_pushing = 0
				return
			// TODO - Check if we need to do something about the slime.UpdateFeed() we are skipping below.

			tmob.forceMove(oldloc)
			if(old_pulling)
				start_pulling(old_pulling, supress_message = TRUE)
			now_pushing = 0
			return

		else if((tmob.mob_always_swap || (tmob.a_intent == INTENT_HELP || tmob.restrained()) && (a_intent == INTENT_HELP || src.restrained())) && canmove && can_swap && handle_micro_bump_helping(tmob))
			forceMove(tmob.loc)
			now_pushing = 0
			if(old_pulling)
				start_pulling(old_pulling, supress_message = TRUE)
			return


		if(!can_move_mob(tmob, 0, 0))
			now_pushing = 0
			return
		if(a_intent == INTENT_HELP || src.restrained())
			now_pushing = 0
			return

		// Plow that nerd.
		if(ishuman(tmob))
			var/mob/living/carbon/human/H = tmob
			if(H.species.lightweight == 1 && prob(50))
				H.visible_message("<span class='warning'>[src] bumps into [H], knocking them off balance!</span>")
				H.Weaken(5)
				now_pushing = 0
				return
		// Handle grabbing, stomping, and such of micros!
		if(handle_micro_bump_other(tmob)) return

		if(istype(tmob, /mob/living/carbon/human) && (FAT in tmob.mutations))
			if(prob(40) && !(FAT in src.mutations))
				to_chat(src, "<span class='danger'>You fail to push [tmob]'s fat ass out of the way.</span>")
				now_pushing = 0
				return
		if(tmob.r_hand && istype(tmob.r_hand, /obj/item/shield/riot))
			if(prob(99))
				now_pushing = 0
				return

		if(tmob.l_hand && istype(tmob.l_hand, /obj/item/shield/riot))
			if(prob(99))
				now_pushing = 0
				return
		if(!(tmob.status_flags & CANPUSH))
			now_pushing = 0
			return

		tmob.LAssailant = src

	now_pushing = 0
	. = ..()
	if (!istype(AM, /atom/movable) || AM.anchored)
		// Object-specific proc for running into things
		if(((confused || is_blind()) && stat == CONSCIOUS && prob(50) && m_intent=="run") || flying && !SPECIES_ADHERENT)
			AM.stumble_into(src)
		return
	if (!now_pushing)
		if(isobj(AM))
			var/obj/I = AM
			if(!can_pull_size || can_pull_size < I.w_class)
				return
		now_pushing = 1

		var/t = get_dir(src, AM)
		if (istype(AM, /obj/structure/window))
			for(var/obj/structure/window/win in get_step(AM,t))
				now_pushing = 0
				return
		step(AM, t)
		if(ishuman(AM) && AM:grabbed_by)
			for(var/obj/item/grab/G in AM:grabbed_by)
				step(G:assailant, get_dir(G:assailant, AM))
				G.adjust_position()
		now_pushing = 0

/mob/living/CanAllowThrough(atom/movable/mover, turf/target)
	if(istype(mover, /obj/structure/blob) && faction == "blob") //Blobs should ignore things on their faction.
		return TRUE
	return ..()

//Called when something steps onto us. This allows for mulebots and vehicles to run things over. <3
/mob/living/Crossed(var/atom/movable/AM) // Transplanting this from /mob/living/carbon/human/Crossed()
	if(AM == src || AM.is_incorporeal()) // We're not going to run over ourselves or ghosts
		return

	if(istype(AM, /mob/living/bot/mulebot))
		var/mob/living/bot/mulebot/MB = AM
		MB.runOver(src)

	if(istype(AM, /obj/vehicle))
		var/obj/vehicle/V = AM
		V.RunOver(src)
	return ..()
