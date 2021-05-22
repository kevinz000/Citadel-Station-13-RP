// Use this define to register something as a purchasable!
// * n — The proper name of the purchasable
// * o — The object type path of the purchasable to spawn
// * p — The price of the purchasable in mining points
#define EQUIPMENT(n, o, p) n = new /datum/data/mining_equipment(n, o, p)

/**********************Mining Equipment Locker**************************/

/obj/machinery/mineral/equipment_vendor
	name = "mining equipment vendor"
	desc = "An equipment vendor for miners, points collected at an ore redemption machine can be spent here."
	icon = 'icons/obj/vending.dmi'
	icon_state = "adh-tool"
	density = TRUE
	anchored = TRUE
	var/icon_deny = "adh-tool-deny"
	var/icon_vend = "adh-tool-vend"
	circuit = /obj/item/circuitboard/mining_equipment_vendor
	var/obj/item/card/id/inserted_id
	//VOREStation Edit Start - Heavily modified list
	var/list/prize_list = list(
		"UNSORTED" = list(
			new /datum/data/mining_equipment("1 Marker Beacon",				/obj/item/stack/marker_beacon,										10),
			new /datum/data/mining_equipment("10 Marker Beacons",			/obj/item/stack/marker_beacon/ten,									100),
			new /datum/data/mining_equipment("30 Marker Beacons",			/obj/item/stack/marker_beacon/thirty,								300),
			new /datum/data/mining_equipment("Whiskey",						/obj/item/reagent_containers/food/drinks/bottle/whiskey,		125),
			new /datum/data/mining_equipment("Absinthe",					/obj/item/reagent_containers/food/drinks/bottle/absinthe,	125),
			new /datum/data/mining_equipment("Special Blend Whiskey",						/obj/item/reagent_containers/food/drinks/bottle/specialwhiskey,		250),
			new /datum/data/mining_equipment("Random Booze",						/obj/random/alcohol,		125),
			new /datum/data/mining_equipment("Cigar",						/obj/item/clothing/mask/smokable/cigarette/cigar/havana,			150),
			new /datum/data/mining_equipment("Soap",						/obj/item/soap/nanotrasen,									200),
			new /datum/data/mining_equipment("Laser Pointer",				/obj/item/laser_pointer,										900),
			new /datum/data/mining_equipment("Geiger Counter",				/obj/item/geiger,											750),
			new /datum/data/mining_equipment("Plush Toy",					/obj/random/plushie,												300),
			new /datum/data/mining_equipment("GPS Device",					/obj/item/gps/mining,										100),
			// TODO new /datum/data/mining_equipment("Advanced Scanner",	/obj/item/t_scanner/adv_mining_scanner,						800),
			new /datum/data/mining_equipment("Fulton Beacon",				/obj/item/fulton_core,												500),
			new /datum/data/mining_equipment("Shelter Capsule",				/obj/item/survivalcapsule,									500),
			// TODO new /datum/data/mining_equipment("Explorer's Webbing",	/obj/item/storage/belt/mining,										500),
			new /datum/data/mining_equipment("500 Point Transfer Card",			/obj/item/card/mining_point_card,							500),
			new /datum/data/mining_equipment("1000 Point Transfer Card",			/obj/item/card/mining_point_card/onethou,							1000),
			new /datum/data/mining_equipment("2000 Point Transfer Card",			/obj/item/card/mining_point_card/twothou,							2000),
			new /datum/data/mining_equipment("3000 Point Transfer Card",			/obj/item/card/mining_point_card/threethou,							3000),
			new /datum/data/mining_equipment("Umbrella",					/obj/item/melee/umbrella/random,								200),
			new /datum/data/mining_equipment("Survival Medipen",			/obj/item/reagent_containers/hypospray/autoinjector/miner,	500),
			new /datum/data/mining_equipment("Mini-Translocator",			/obj/item/perfect_tele/one_beacon,							1200),
			// new /datum/data/mining_equipment("Kinetic Crusher",			/obj/item/twohanded/required/kinetic_crusher,						750),
			new /datum/data/mining_equipment("Kinetic Accelerator",			/obj/item/gun/energy/kinetic_accelerator,					900),
			new /datum/data/mining_equipment("Resonator",					/obj/item/resonator,												900),
			new /datum/data/mining_equipment("Fulton Pack",					/obj/item/extraction_pack,											1200),
			new /datum/data/mining_equipment("Wormhole Fulton Pack",					/obj/item/extraction_pack/wormhole,											1750),
			new /datum/data/mining_equipment("Silver Pickaxe",				/obj/item/pickaxe/silver,									1200),
			new /datum/data/mining_equipment("Climbing Pick",				/obj/item/pickaxe/icepick,									2200),
			//new /datum/data/mining_equipment("Mining Conscription Kit",	/obj/item/storage/backpack/duffelbag/mining_conscript,				1000),
			new /datum/data/mining_equipment("Diamond Pickaxe",				/obj/item/pickaxe/diamond,									2000),
			new /datum/data/mining_equipment("Advanced Ore Scanner",				/obj/item/mining_scanner/advanced,										2000),
			new /datum/data/mining_equipment("Space Cash",					/obj/item/spacecash/c100,									1000),
			new /datum/data/mining_equipment("Hardsuit - Control Module",	/obj/item/rig/industrial,									2000),
			new /datum/data/mining_equipment("Hardsuit - Plasma Cutter",		/obj/item/rig_module/device/plasmacutter,						800),
			new /datum/data/mining_equipment("Hardsuit - Drill",				/obj/item/rig_module/device/drill,								5000),
			new /datum/data/mining_equipment("Hardsuit - Ore Scanner",		/obj/item/rig_module/device/orescanner,								1000),
			new /datum/data/mining_equipment("Hardsuit - Material Scanner",	/obj/item/rig_module/vision/material,								500),
			new /datum/data/mining_equipment("Hardsuit - Maneuvering Jets",	/obj/item/rig_module/maneuvering_jets,								1250),
			new /datum/data/mining_equipment("Hardsuit - Intelligence Storage",	/obj/item/rig_module/ai_container,								2500),
			new /datum/data/mining_equipment("Hardsuit - Smoke Bomb Deployer",	/obj/item/rig_module/grenade_launcher/smoke,					2000),
			new /datum/data/mining_equipment("Industrial Equipment - Phoron Bore",	/obj/item/gun/magnetic/matfed,						3000),
			new /datum/data/mining_equipment("Industrial Equipment - Sheet-Snatcher",/obj/item/storage/bag/sheetsnatcher,				500),
			new /datum/data/mining_equipment("Digital Tablet - Standard",	/obj/item/modular_computer/tablet/preset/custom_loadout/standard,	500),
			new /datum/data/mining_equipment("Digital Tablet - Advanced",	/obj/item/modular_computer/tablet/preset/custom_loadout/advanced,	1000),
			new /datum/data/mining_equipment("Super Resonator",				/obj/item/resonator/upgraded,										2500),
			new /datum/data/mining_equipment("Jump Boots",					/obj/item/clothing/shoes/bhop,										2500),
			new /datum/data/mining_equipment("Luxury Shelter Capsule",		/obj/item/survivalcapsule/luxury,							3100),
			new /datum/data/mining_equipment("KA White Tracer Rounds",		/obj/item/borg/upgrade/modkit/tracer,								125),
			new /datum/data/mining_equipment("KA Adjustable Tracer Rounds",	/obj/item/borg/upgrade/modkit/tracer/adjustable,					175),
			new /datum/data/mining_equipment("KA Super Chassis",			/obj/item/borg/upgrade/modkit/chassis_mod,							250),
			new /datum/data/mining_equipment("KA Hyper Chassis",			/obj/item/borg/upgrade/modkit/chassis_mod/orange,					300),
			new /datum/data/mining_equipment("KA Range Increase",			/obj/item/borg/upgrade/modkit/range,								1000),
			new /datum/data/mining_equipment("KA Damage Increase",			/obj/item/borg/upgrade/modkit/damage,								1000),
			new /datum/data/mining_equipment("KA Efficiency Increase",		/obj/item/borg/upgrade/modkit/efficiency,							1200),
			new /datum/data/mining_equipment("KA AoE Damage",				/obj/item/borg/upgrade/modkit/aoe/mobs,								2000),
			new /datum/data/mining_equipment("KA Holster",				/obj/item/clothing/accessory/holster/waist/kinetic_accelerator,			350),
			new /datum/data/mining_equipment("Fine Excavation Kit - Chisels",/obj/item/storage/excavation,								500),
			new /datum/data/mining_equipment("Fine Excavation Kit - Measuring Tape",/obj/item/measuring_tape,							125),
			new /datum/data/mining_equipment("Fine Excavation Kit - Hand Pick",/obj/item/pickaxe/hand,									375),
			new /datum/data/mining_equipment("Explosive Excavation Kit - Plastic Charge",/obj/item/plastique/seismic/locked,					1500),
			new /datum/data/mining_equipment("Injector (L) - Glucose",/obj/item/reagent_containers/hypospray/autoinjector/biginjector/glucose,	500),
			new /datum/data/mining_equipment("Injector (L) - Panacea",/obj/item/reagent_containers/hypospray/autoinjector/biginjector/purity,	500),
			new /datum/data/mining_equipment("Injector (L) - Trauma",/obj/item/reagent_containers/hypospray/autoinjector/biginjector/brute,	500),
			new /datum/data/mining_equipment("Nanopaste Tube",				/obj/item/stack/nanopaste,											1000),
			new /datum/data/mining_equipment("Defense Equipment - Smoke Bomb",/obj/item/grenade/smokebomb,								100),
			new /datum/data/mining_equipment("Defense Equipment - Razor Drone Deployer",/obj/item/grenade/spawnergrenade/manhacks/station/locked,	1000),
			new /datum/data/mining_equipment("Defense Equipment - Sentry Drone Deployer",/obj/item/grenade/spawnergrenade/ward,			1500),
			new /datum/data/mining_equipment("Defense Equipment - Plasteel Machete",	/obj/item/clothing/accessory/holster/machete/occupied,				500),
			new /datum/data/mining_equipment("Fishing Net",					/obj/item/material/fishing_net,								500),
			new /datum/data/mining_equipment("Titanium Fishing Rod",		/obj/item/material/fishing_rod/modern,						1000),
			new /datum/data/mining_equipment("Durasteel Fishing Rod",		/obj/item/material/fishing_rod/modern/strong,				7500),
			new /datum/data/mining_equipment("Bar Shelter Capsule",		/obj/item/survivalcapsule/luxurybar,							10000)
		)
	)
	var/dirty_items = FALSE // Used to refresh the static/redundant data in case the machine gets VV'd

/datum/data/mining_equipment
	var/equipment_name = "generic"
	var/equipment_path = null
	var/cost = 0

/datum/data/mining_equipment/New(name, path, cost)
	src.equipment_name = name
	src.equipment_path = path
	src.cost = cost

/obj/machinery/power/quantumpad/Initialize(mapload)
	. = ..()
	default_apply_parts()

/obj/machinery/mineral/equipment_vendor/power_change()
	var/old_stat = stat
	..()
	if(old_stat != stat)
		update_icon()
	if(inserted_id && !powered())
		visible_message("<span class='notice'>The ID slot indicator light flickers on \the [src] as it spits out a card before powering down.</span>")
		inserted_id.forceMove(get_turf(src))

/obj/machinery/mineral/equipment_vendor/update_icon()
	if(panel_open)
		add_overlay("[initial(icon_state)]-panel")
	else
		cut_overlay("[initial(icon_state)]-panel")

	if(stat & BROKEN)
		icon_state = "[initial(icon_state)]-broken"
	else if(powered())
		icon_state = initial(icon_state)
	else
		icon_state = "[initial(icon_state)]-off"

/obj/machinery/mineral/equipment_vendor/attack_hand(mob/user)
	if(..())
		return
	ui_interact(user)

/obj/machinery/mineral/equipment_vendor/attack_ghost(mob/user)
	ui_interact(user)

/obj/machinery/mineral/equipment_vendor/ui_data(mob/user)
	var/list/data = ..()

	// ID
	if(inserted_id)
		data["has_id"] = TRUE
		data["id"] = list()
		data["id"]["name"] = inserted_id.registered_name
		data["id"]["points"] = get_points(inserted_id)
	else
		data["has_id"] = FALSE

	return data

/obj/machinery/mineral/equipment_vendor/proc/get_points(obj/item/card/id/target)
	if(!istype(target))
		return 0
	return target.mining_points

/obj/machinery/mineral/equipment_vendor/proc/remove_points(obj/item/card/id/target, amt)
	target.mining_points -= amt

/obj/machinery/mineral/equipment_vendor/ui_static_data(mob/user)
	var/list/static_data[0]

	// Available items - in static data because we don't wanna compute this list every time! It hardly changes.
	static_data["items"] = list()
	for(var/cat in prize_list)
		var/list/cat_items = list()
		for(var/prize_name in prize_list[cat])
			var/datum/data/mining_equipment/prize = prize_list[cat][prize_name]
			cat_items[prize_name] = list("name" = prize_name, "price" = prize.cost)
		static_data["items"][cat] = cat_items

	return static_data

/obj/machinery/mineral/equipment_vendor/vv_edit_var(var_name, var_value)
	// Gotta update the static data in case an admin VV's the items for some reason..!
	if(var_name == "prize_list")
		dirty_items = TRUE
	return ..()

/obj/machinery/mineral/equipment_vendor/ui_interact(mob/user, datum/tgui/ui = null)
	// Update static data if need be
	if(dirty_items)
		update_ui_static_data(user, ui)
		dirty_items = FALSE

	// Open the window
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "MiningVendor", name)
		ui.open()
		ui.set_autoupdate(FALSE)


/obj/machinery/mineral/equipment_vendor/ui_act(action, params)
	if(..())
		return

	. = TRUE
	switch(action)
		if("logoff")
			if(!inserted_id)
				return
			usr.put_in_hands(inserted_id)
			inserted_id = null
		if("purchase")
			if(!inserted_id)
				flick(icon_deny, src) //VOREStation Add
				return
			var/category = params["cat"] // meow
			var/name = params["name"]
			if(!(category in prize_list) || !(name in prize_list[category])) // Not trying something that's not in the list, are you?
				flick(icon_deny, src) //VOREStation Add
				return
			var/datum/data/mining_equipment/prize = prize_list[category][name]
			if(prize.cost > get_points(inserted_id)) // shouldn't be able to access this since the button is greyed out, but..
				to_chat(usr, "<span class='danger'>You have insufficient points.</span>")
				flick(icon_deny, src) //VOREStation Add
				return

			remove_points(inserted_id, prize.cost)
			new prize.equipment_path(loc)
			flick(icon_vend, src) //VOREStation Add
		else
			flick(icon_deny, src) //VOREStation Add
			return FALSE
	add_fingerprint()


/obj/machinery/mineral/equipment_vendor/attackby(obj/item/I, mob/user, params)
	if(default_deconstruction_screwdriver(user, I))
		return
	if(default_part_replacement(user, I))
		return
	if(default_deconstruction_crowbar(user, I))
		return
	if(istype(I, /obj/item/mining_voucher))
		if(!powered())
			return
		redeem_voucher(I, user)
		return
	if(istype(I,/obj/item/card/id))
		if(!powered())
			return
		else if(!inserted_id && user.unEquip(I))
			I.forceMove(src)
			inserted_id = I
			ui_interact(user)
		return
	return ..()

/obj/machinery/mineral/equipment_vendor/dismantle()
	if(inserted_id)
		inserted_id.forceMove(loc) //Prevents deconstructing the ORM from deleting whatever ID was inside it.
	. = ..()

/**
  * Called when someone slaps the machine with a mining voucher
  *
  * Arguments:
  * * voucher - The voucher card item
  * * redeemer - The person holding it
  */
/obj/machinery/mineral/equipment_vendor/proc/redeem_voucher(obj/item/mining_voucher/voucher, mob/redeemer)
	var/selection = input(redeemer, "Pick your equipment", "Mining Voucher Redemption") as null|anything in list("Kinetic Accelerator", "Resonator", "Mining Drone", "Advanced Scanner", "Crusher")
	if(!selection || !Adjacent(redeemer) || voucher.loc != redeemer)
		return
	//VOREStation Edit Start - Uncommented these
	var/drop_location = drop_location()
	switch(selection)
		if("Kinetic Accelerator")
			new /obj/item/gun/energy/kinetic_accelerator(drop_location)
		if("Resonator")
			new /obj/item/resonator(drop_location)
	//VOREStation Edit End
		// if("Mining Drone")
		// 	new /obj/item/storage/box/drone_kit(drop_location)
		// if("Advanced Scanner")
		// 	new /obj/item/t_scanner/adv_mining_scanner(drop_location)
		// if("Crusher")
		// 	new /obj/item/twohanded/required/mining_hammer(drop_location)
	qdel(voucher)

/obj/machinery/mineral/equipment_vendor/proc/new_prize(var/name, var/path, var/cost) // Generic proc for adding new entries. Good for abusing for FUN and PROFIT.
	if(!cost)
		cost = 100
	if(!path)
		path = /obj/item/stack/marker_beacon
	if(!name)
		name = "Generic Entry"
	prize_list += new /datum/data/mining_equipment(name, path, cost)

/obj/machinery/mineral/equipment_vendor/ex_act(severity, target)
	var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
	s.set_up(5, 1, src)
	s.start()
	if(prob(50 / severity) && severity < 3)
		qdel(src)
