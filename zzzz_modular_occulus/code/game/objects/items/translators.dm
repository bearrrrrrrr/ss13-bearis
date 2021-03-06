// Port of Polaris Universal Translators go here

//Universal translator
/obj/item/device/universal_translator
	name = "handheld translator"
	desc = "This handy device appears to translate the languages it hears into onscreen text for a user."
	icon = 'zzzz_modular_occulus/icons/obj/translators.dmi'
	icon_state = "translator"
	w_class = ITEM_SIZE_TINY
	matter = list(MATERIAL_PLASTIC = 1, MATERIAL_GLASS = 1, MATERIAL_STEEL = 1)
	origin_tech = list(TECH_DATA = 3, TECH_ENGINEERING = 3)
	var/mult_icons = 1	//Changes sprite when it translates
	var/visual = 1		//If you need to see to get the message
	var/audio = 0		//If you need to hear to get the message
	var/listening = 0
	var/datum/language/langset

/obj/item/device/universal_translator/attack_self(mob/user)
	if(!listening) //Turning ON
		langset = input(user,"Translate to which of your languages?","Language Selection") as null|anything in user.languages
		if(langset)
			if(langset && ((langset.flags & NONVERBAL) || (langset.flags & HIVEMIND) || (!langset.machine_understands)))
				//Nonverbal means no spoken words to translate, so I didn't see the need to remove it.
				to_chat(user, "<span class='warning'>\The [src] cannot output that language.</span>")
				return
			else
				listening = 1
				add_hearing()
				if(mult_icons)
					icon_state = "[initial(icon_state)]1"
				to_chat(user, "<span class='notice'>You enable \the [src], translating into [langset.name].</span>")
	else	//Turning OFF
		listening = 0
		remove_hearing()
		langset = null
		icon_state = "[initial(icon_state)]"
		to_chat(user, "<span class='notice'>You disable \the [src].</span>")

/obj/item/device/universal_translator/hear_talk(var/mob/speaker, var/message, var/vrb, var/datum/language/language)
	if(!listening || !istype(speaker))
		return

	//Show the "I heard something" animation.
	if(mult_icons)
		flick("[initial(icon_state)]2",src)

	//Handheld or pocket only.
	if(!isliving(loc))
		return

	if(!language)
		return //Borgs were causing runtimes when passing language=null

	if (language && (language.flags & NONVERBAL))
		return //Not gonna translate sign language

	if (!language.machine_understands)
		return //Any other languages that it can't translate.

	var/mob/living/L = loc

	if(visual && ((L.sdisabilities & BLIND) || L.eye_blind))
		return

	if(audio && ((L.sdisabilities & DEAF) || L.ear_deaf))
		return

	//Only translate if they can't understand, otherwise pointlessly spammy
	//I'll just assume they don't look at the screen in that case

	//They don't understand the spoken language we're translating FROM
	if(!L.say_understands(speaker,language))
		//They understand the output language
		if(L.say_understands(null,langset))
			to_chat(L, "<i><b>[src]</b> translates, </i>\"<span class='[langset.colour]'>[message]</span>\"")

		//They don't understand the output language
		else
			to_chat(L, "<i><b>[src]</b> translates, </i>\"<span class='[langset.colour]'>[langset.scramble(message)]</span>\"")

//Let's try an ear-worn version
/obj/item/device/universal_translator/ear
	name = "translator earpiece"
	desc = "This handy device appears to translate the languages it hears into another language for a user."
	icon_state = "earpiece"
	w_class = ITEM_SIZE_TINY
	slot_flags = SLOT_EARS
	visual = 0
	audio = 1

/datum/design/research/item/translator
	name = "Handheld Translator"
	build_path = /obj/item/device/universal_translator
	category = "Telecoms | Bluespace"

/datum/design/research/item/translator/ear
	name = "Translator Earpiece"
	build_path = /obj/item/device/universal_translator/ear
