var/global/list/body_modifications = list()
var/global/list/modifications_types = list(
	BP_CHEST = "",  "chest2" = "", BP_HEAD = "",   BP_GROIN = "",
	BP_L_ARM  = "", BP_R_ARM  = "", BP_L_HAND = "", BP_R_HAND = "",
	BP_L_LEG  = "", BP_R_LEG  = "", BP_L_FOOT = "", BP_R_FOOT = "",
	BP_HEART  = "", BP_LUNGS  = "", BP_LIVER  = "", BP_EYES   = ""
)

/proc/generate_body_modification_lists()
	for(var/mod_type in typesof(/datum/body_modification))
		var/datum/body_modification/BM = new mod_type()
		if(!BM.id)
			continue
		body_modifications[BM.id] = BM
		var/class = ""
		if(BM.allowed_species && BM.allowed_species.len)
			class = " limited [BM.allowed_species.Join(" ")]"
		for(var/part in BM.body_parts)
			modifications_types[part] += "<div style = 'padding:2px' onclick=\"set('body_modification', '[BM.id]');\" class='block[class]'><b>[BM.name]</b><br>[BM.desc]</div>"

/proc/get_default_modificaton(var/nature = MODIFICATION_ORGANIC)
	switch(nature)
		if(MODIFICATION_ORGANIC)
			return body_modifications["nothing"]
		if(MODIFICATION_SILICON)
			return body_modifications["prosthesis_basic"]
		if(MODIFICATION_REMOVED)
			return body_modifications["amputated"]

/datum/body_modification
	var/name = ""
	var/short_name = ""
	var/id = ""								// For savefile. Must be unique.
	var/desc = ""							// Description.
	var/list/body_parts = list(				// For sorting'n'selection optimization.
		BP_CHEST, "chest2", BP_HEAD, BP_GROIN, BP_L_ARM, BP_R_ARM, BP_L_HAND, BP_R_HAND, BP_L_LEG, BP_R_LEG,\
		BP_L_FOOT, BP_R_FOOT, BP_HEART, BP_LUNGS, BP_LIVER, BP_BRAIN, BP_EYES)
	var/list/allowed_species = list("Human")// Species restriction.
	var/replace_limb = null					// To draw usual limb or not.
	var/mob_icon = ""
	var/icon/icon = 'icons/mob/human_races/body_modification.dmi'
	var/nature = MODIFICATION_ORGANIC
	var/hascolor = FALSE
	var/allow_nt = TRUE

/datum/body_modification/proc/get_mob_icon(organ, color="#ffffff", gender = MALE, species)	//Use in setup character only
	return new/icon('icons/mob/human.dmi', "blank")

/datum/body_modification/proc/is_allowed(organ = "", datum/preferences/P, mob/living/carbon/human/H)
	if(!organ || !(organ in body_parts))
		//usr << "[name] isn't useable for [organ]"
		return FALSE
	var/list/organ_data = organ_structure[organ]
	if(organ_data)
		var/parent_organ = organ_data["parent"]
		if(parent_organ)
			var/datum/body_modification/parent = P.get_modification(parent_organ)
			if(parent.nature == MODIFICATION_REMOVED)
				to_chat(usr, "[name] can't be attached to [parent.name]")
				return FALSE


	if(!allow_nt)
		if(H?.mind?.assigned_job.department == DEPARTMENT_CHURCH)
			return FALSE
		if(H?.get_core_implant(/obj/item/weapon/implant/core_implant/cruciform))
			return FALSE

	return TRUE

/datum/body_modification/proc/create_organ(var/mob/living/carbon/holder, var/organ, var/color)
	return null

/datum/body_modification/none
	name = "Unmodified organ"
	id = "nothing"
	short_name = "Nothing"
	desc = "Normal organ."
	allowed_species = null

/datum/body_modification/none/create_organ(var/mob/living/carbon/holder, var/datum/organ_description/OD, var/color)
	if(istype(OD))
		return OD.create_organ(holder,OD)
	else if(ispath(OD))
		return new OD(holder)
	else
		return null


/datum/body_modification/limb/create_organ(var/mob/living/carbon/holder, var/datum/organ_description/OD, var/color)
	if(replace_limb)
		return new replace_limb(holder,OD)
	else
		return new OD.default_type(holder,OD)

/datum/body_modification/limb/amputation
	name = "Amputated"
	short_name = "Amputated"
	id = "amputated"
	desc = "Organ was removed."
	body_parts = list(BP_L_ARM, BP_R_ARM, BP_L_HAND, BP_R_HAND, BP_L_LEG, BP_R_LEG, BP_L_FOOT, BP_R_FOOT)
	replace_limb = 1
	nature = MODIFICATION_REMOVED

/datum/body_modification/limb/amputation/create_organ()
	return null

/datum/body_modification/limb/prosthesis
	name = "Unbranded prosthesis"
	id = "prosthesis_basic"
	desc = "Simple, brutal and reliable prosthesis"
	body_parts = list(BP_L_ARM, BP_R_ARM, BP_L_LEG, BP_R_LEG) //
	replace_limb = /obj/item/organ/external/robotic
	icon = 'icons/mob/human_races/cyberlimbs/unbranded/unbranded_alt1.dmi'
	nature = MODIFICATION_SILICON
	allow_nt = FALSE
	var/prosthetic_model

/datum/body_modification/limb/prosthesis/New()
	var/obj/item/organ/external/robotic/R = replace_limb
	name = initial(R.name)
	icon = initial(R.force_icon)
	desc = initial(R.desc)

/datum/body_modification/limb/prosthesis/get_mob_icon(organ, color, gender, species)
	return new/icon(icon, "[organ][gender == FEMALE ? "_f" : "_m"]")

/datum/body_modification/limb/prosthesis/asters
	id = "prosthesis_asters"
	replace_limb = /obj/item/organ/external/robotic/asters
	icon = 'icons/mob/human_races/cyberlimbs/asters.dmi'

/datum/body_modification/limb/prosthesis/serbian
	id = "prosthesis_serbian"
	replace_limb = /obj/item/organ/external/robotic/serbian
	icon = 'icons/mob/human_races/cyberlimbs/serbian.dmi'

/datum/body_modification/limb/prosthesis/frozen_star
	id = "prosthesis_frozen_star"
	replace_limb = /obj/item/organ/external/robotic/frozen_star
	icon = 'icons/mob/human_races/cyberlimbs/frozen_star.dmi'

/datum/body_modification/limb/prosthesis/technomancer
	id = "prosthesis_technomancer"
	replace_limb = /obj/item/organ/external/robotic/technomancer
	icon = 'icons/mob/human_races/cyberlimbs/technomancer.dmi'

/datum/body_modification/limb/mutation/New()
	short_name = "M: [name]"
	name = "Mutation: [name]"

////Organ Modules////
/datum/body_modification/limb/organ_module
	replace_limb = null
	allow_nt = FALSE
	var/module_type = null

/datum/body_modification/limb/organ_module/create_organ(var/mob/living/carbon/holder, var/datum/organ_description/OD, var/color)
	var/obj/item/organ/external/E = ..()
	if(module_type)
		var/obj/item/organ_module/OM = new module_type()
		OM.install(E)
	return E

////Internals////
/datum/body_modification/organ/create_organ(var/mob/living/carbon/holder, var/organ, var/color)
	if(replace_limb)
		return new replace_limb(holder)
	else
		return new organ(holder)

/datum/body_modification/organ/assisted
	name = "Assisted organ"
	short_name = "P: assisted"
	id = "assisted"
	desc = "Assisted organ."
	body_parts = list(BP_HEART, BP_LUNGS, BP_LIVER, BP_EYES)
	allow_nt = FALSE

/datum/body_modification/organ/assisted/create_organ(var/mob/living/carbon/holder, var/O, var/color)
	var/obj/item/organ/I = ..(holder,O,color)
	I.nature = MODIFICATION_ASSISTED
	I.min_bruised_damage = 15
	I.min_broken_damage = 35
	return I


/datum/body_modification/organ/robotize_organ
	name = "Robotic organ"
	short_name = "P: prosthesis"
	id = "robotize_organ"
	desc = "Robotic organ."
	body_parts = list(BP_HEART, BP_LUNGS, BP_LIVER, BP_EYES)
	allow_nt = FALSE

/datum/body_modification/organ/robotize_organ/create_organ(var/mob/living/carbon/holder, O, color)
	var/obj/item/organ/I = ..(holder,O,color)
	I.nature = MODIFICATION_SILICON
	if(istype(I, /obj/item/organ/internal/eyes))
		var/obj/item/organ/internal/eyes/E = I
		E.robo_color = iscolor(color) ? color : "#FFFFFF"
	return I

////Eyes////

/datum/body_modification/organ/oneeye
	name = "One eye (left)"
	short_name = "M: One eye (l)"
	id = "missed_eye"
	desc = "One of your eyes is missing."
	body_parts = list(BP_EYES)
	hascolor = TRUE
	replace_limb = /obj/item/organ/internal/eyes/oneeye

/datum/body_modification/organ/oneeye/get_mob_icon(organ, color, gender, species)
	var/datum/species/S = all_species[species]
	var/icon/I = new/icon(S.faceicobase, "eye_l")
	I.Blend(color, ICON_ADD)
	return I

/datum/body_modification/organ/oneeye/create_organ(var/mob/living/carbon/human/holder, var/organ, var/color)
	var/obj/item/organ/internal/eyes/E = ..(holder,organ,color)
	E.eyes_color = color
	return E

/datum/body_modification/organ/oneeye/right
	name = "One eye (right)"
	short_name = "M: One eye (r)"
	id = "missed_eye_right"
	replace_limb = /obj/item/organ/internal/eyes/oneeye/right

/datum/body_modification/organ/oneeye/right/get_mob_icon(organ, color, gender, species)
	var/datum/species/S = all_species[species]
	var/icon/I = new/icon(S.faceicobase, "eye_r")
	I.Blend(color, ICON_ADD)
	return I

/datum/body_modification/organ/heterochromia
	name = "Heterochromia"
	short_name = "M: Heterochromia"
	id = "mutation_heterochromia"
	desc = "Special color for left eye."
	body_parts = list(BP_EYES)
	hascolor = TRUE

/datum/body_modification/organ/heterochromia/get_mob_icon(organ, color, gender, species)
	var/datum/species/S = all_species[species]
	var/icon/I = new/icon(S.faceicobase, "eye_l")
	I.Blend(color, ICON_ADD)
	return I

/datum/body_modification/organ/heterochromia/create_organ(var/mob/living/carbon/holder, organ_type, color)
	var/obj/item/organ/internal/eyes/heterohromia/E = new(holder,organ_type,color)
	E.second_color = color
	return E