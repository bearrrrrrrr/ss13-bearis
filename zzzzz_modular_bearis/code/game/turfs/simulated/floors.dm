// We aren't doing the thing where we split up declarations and turfs into seperate files. God, that's so fucking stupid.


/decl/flooring/tiling/bear/dirt
	name = "dirt"
	desc = "Solid ground."
	icon = 'zzzzz_modular_bearis/icons/turf/beardirt.dmi'
	icon_base = "dirtdebug"
	has_damage_range = 2 //RECHECK THIS. MAYBE MISTAKE
	damage_temperature = T0C+1400
	footstep_sound = "gravel"
	flags = TURF_HIDES_THINGS
	build_type = /obj/item/stack/tile/floor

/turf/simulated/floor/bear/dirt
	name = "dirt"
	icon = 'zzzzz_modular_bearis/icons/turf/beardirt.dmi'
	icon_state = "dirtdebug"
	initial_flooring = /decl/flooring/tiling/bear/dirt


/decl/flooring/tiling/bear/dirt/onetwo
	name = "dirt"
	desc = "Scuffed from the passage of countless greyshirts."
	icon = 'zzzzz_modular_bearis/icons/turf/beardirt.dmi'
	icon_base = "1,2"
	has_damage_range = 2 //RECHECK THIS. MAYBE MISTAKE
	damage_temperature = T0C+1400
	footstep_sound = "gravel"
	flags = TURF_HIDES_THINGS
	build_type = /obj/item/stack/tile/floor


/turf/simulated/floor/bear/dirtonetwo
	name = "dirt"
	icon = 'zzzzz_modular_bearis/icons/turf/beardirt.dmi'
	icon_state = "1,2"
	initial_flooring = /decl/flooring/tiling/bear/dirt/onetwo


/turf/simulated/floor/bear/mud
	name = "mud"
	icon = 'zzzzz_modular_bearis/icons/turf/beardirt.dmi'
	icon_state = "mud"
	initial_flooring = /decl/flooring/tiling/bear/dirt/mud


/decl/flooring/tiling/bear/dirt/mud
	name = "mud"
	desc = "Wet dirt."
	icon = 'zzzzz_modular_bearis/icons/turf/beardirt.dmi'
	icon_base = "mud"
	flags = TURF_HIDES_THINGS
	footstep_sounds = list(
		'zzzzzz_modular_bearis/sound/mud1',
		'zzzzzz_modular_bearis/sound/mud2',
		'zzzzzz_modular_bearis/sound/mud3',
		'zzzzzz_modular_bearis/sound/mud4',
		'zzzzzz_modular_bearis/sound/mud5')
