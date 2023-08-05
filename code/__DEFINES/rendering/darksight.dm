#define SOFT_DARKSIGHT_15X15_ICON 'icons/screen/rendering/darksight_15x15.dmi'

#define SOFT_DARKSIGHT_RANGE_DEFAULT (WORLD_ICON_SIZE * 2.5)
#define SOFT_DARKSIGHT_RANGE_TIER_1 (WORLD_ICON_SIZE * 3.5)
#define SOFT_DARKSIGHT_RANGE_TIER_2 (WORLD_ICON_SIZE * 5)
#define SOFT_DARKSIGHT_RANGE_TIER_3 (WORLD_ICON_SIZE * 13)
#define SOFT_DARKSIGHT_RANGE_NVGS INFINITY
#define SOFT_DARKSIGHT_RANGE_SUPER INFINITY

/// above this, we give them a full screen overlay instead of trying to transform an atom.
#define SOFT_DARKSIGHT_UNLIMITED_THRESHOLD (WORLD_ICON_SIZE * 20)

#define SOFT_DARKSIGHT_ALPHA_DEFAULT 25
#define SOFT_DARKSIGHT_ALPHA_TIER_1 45
#define SOFT_DARKSIGHT_ALPHA_TIER_2 60
#define SOFT_DARKSIGHT_ALPHA_TIER_3 75
#define SOFT_DARKSIGHT_ALPHA_NVGS 100
#define SOFT_DARKSIGHT_ALPHA_SUPER 120

#define SOFT_DARKSIGHT_FOV_90 90
#define SOFT_DARKSIGHT_FOV_180 180
#define SOFT_DARKSIGHT_FOV_270 270
#define SOFT_DARKSIGHT_FOV_OMNI 360

#define SOFT_DARKSIGHT_FOV_DEFAULT SOFT_DARKSIGHT_FOV_90
#define SOFT_DARKSIGHT_FOV_TIER_1 SOFT_DARKSIGHT_FOV_90
#define SOFT_DARKSIGHT_FOV_TIER_2 SOFT_DARKSIGHT_FOV_180
#define SOFT_DARKSIGHT_FOV_TIER_3 SOFT_DARKSIGHT_FOV_270
#define SOFT_DARKSIGHT_FOV_NVGS SOFT_DARKSIGHT_FOV_90
#define SOFT_DARKSIGHT_FOV_SUPER SOFT_DARKSIGHT_FOV_OMNI

#define DARKSIGHT_PRIORITY_INNATE -1000
#define DARKSIGHT_PRIORITY_EYES 0
#define DARKSIGHT_PRIORITY_ABILITY 200
#define DARKSIGHT_PRIORITY_MODIFIER 250
#define DARKSIGHT_PRIORITY_GLASSES 500
#define DARKSIGHT_PRIORITY_VISOR 750
#define DARKSIGHT_PRIORITY_DEFAULT 1000
