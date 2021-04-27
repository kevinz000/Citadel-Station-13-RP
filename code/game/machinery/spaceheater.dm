/obj/machinery/space_heater
	anchored = 0
	density = 1
	icon = 'icons/obj/atmos.dmi'
	icon_state = "sheater0"
	name = "space heater"
	desc = "Made by Space Amish using traditional space techniques, this heater is guaranteed not to set the station on fire."
	var/obj/item/cell/cell
	var/cell_type = /obj/item/cell/high
	var/on = 0
	var/set_temperature = T0C + 20	//K
	var/heating_power = 40000
	clicksound = "switch"
	interact_offline = TRUE

/obj/machinery/space_heater/Initialize(mapload, newdir)
	. = ..()
	if(cell_type)
		cell = new cell_type(src)
	update_icon()

/obj/machinery/space_heater/update_icon()
	overlays.Cut()
	icon_state = "sheater[on]"
	if(panel_open)
		overlays  += "sheater-open"
	if(on)
		set_light(3, 3, "#FFCC00")
	else
		set_light(0)

/obj/machinery/space_heater/examine(mob/user)
	. = ..()

	. += "The heater is [on ? "on" : "off"] and the hatch is [panel_open ? "open" : "closed"]."
	if(panel_open)
		. += "The power cell is [cell ? "installed" : "missing"]."
	else
		. += "The charge meter reads [cell ? round(cell.percent(),1) : 0]%"
	return

/obj/machinery/space_heater/powered()
	if(cell && cell.charge)
		return 1
	return 0

/obj/machinery/space_heater/emp_act(severity)
	if(stat & (BROKEN|NOPOWER))
		..(severity)
		return
	if(cell)
		cell.emp_act(severity)
	..(severity)

/obj/machinery/space_heater/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/cell))
		if(panel_open)
			if(cell)
				to_chat(user, "There is already a power cell inside.")
				return
			else
				// insert cell
				var/obj/item/cell/C = usr.get_active_hand()
				if(istype(C))
					user.drop_item()
					cell = C
					C.loc = src
					C.add_fingerprint(usr)

					user.visible_message("<span class='notice'>[user] inserts a power cell into [src].</span>", "<span class='notice'>You insert the power cell into [src].</span>")
					power_change()
		else
			to_chat(user, "The hatch must be open to insert a power cell.")
			return
	else if(I.is_screwdriver())
		panel_open = !panel_open
		playsound(src, I.usesound, 50, 1)
		user.visible_message("<span class='notice'>[user] [panel_open ? "opens" : "closes"] the hatch on the [src].</span>", "<span class='notice'>You [panel_open ? "open" : "close"] the hatch on the [src].</span>")
		update_icon()
		if(!panel_open && user.machine == src)
			user << browse(null, "window=spaceheater")
			user.unset_machine()
	else
		..()
	return

/obj/machinery/space_heater/attack_hand(mob/user as mob)
	add_fingerprint(user)
	interact(user)

/obj/machinery/space_heater/interact(mob/user as mob)
	if(panel_open)
		tgui_interact(user)
	else
		on = !on
		user.visible_message("<span class='notice'>[user] switches [on ? "on" : "off"] the [src].</span>","<span class='notice'>You switch [on ? "on" : "off"] the [src].</span>")
		update_icon()
	return

/obj/machinery/space_heater/tgui_state(mob/user)
	return GLOB.tgui_physical_state

/obj/machinery/space_heater/tgui_status(mob/user)
	if(!panel_open)
		return UI_CLOSE
	return ..()

/obj/machinery/space_heater/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "SpaceHeater", name)
		ui.open()

/obj/machinery/space_heater/ui_data(mob/user)
	var/list/data = list()

	data["cell"] = !!cell
	data["power"] = round(cell?.percent(), 1)
	data["temp"] = set_temperature
	data["minTemp"] = T0C
	data["maxTemp"] = T0C + 90

	return data

/obj/machinery/space_heater/ui_act(action, params)
	if(..())
		return TRUE

	if(!panel_open)
		return FALSE

	switch(action)
		if("temp")
			// limit to 0-90 degC
			set_temperature = clamp(text2num(params["newtemp"]), T0C, T0C + 90)
			. = TRUE

		if("cellremove")
			if(cell && !usr.get_active_hand())
				usr.visible_message("<span class='notice'>[usr] removes [cell] from [src].</span>", "<span class='notice'>You remove [cell] from [src].</span>")
				cell.update_icon()
				usr.put_in_hands(cell)
				cell.add_fingerprint(usr)
				cell = null
				power_change()
				. = TRUE


		if("cellinstall")
			if(!cell)
				var/obj/item/cell/C = usr.get_active_hand()
				if(istype(C))
					usr.drop_item()
					cell = C
					C.loc = src
					C.add_fingerprint(usr)
					power_change()
					usr.visible_message("<span class='notice'>[usr] inserts \the [C] into \the [src].</span>", "<span class='notice'>You insert \the [C] into \the [src].</span>")
				. = TRUE

/obj/machinery/space_heater/process()
	if(on)
		if(cell && cell.charge)
			var/datum/gas_mixture/env = loc.return_air()
			if(env && abs(env.temperature - set_temperature) > 0.1)
				var/transfer_moles = 0.25 * env.total_moles
				var/datum/gas_mixture/removed = env.remove(transfer_moles)

				if(removed)
					var/heat_transfer = removed.get_thermal_energy_change(set_temperature)
					if(heat_transfer > 0)	//heating air
						heat_transfer = min(heat_transfer , heating_power) //limit by the power rating of the heater

						removed.add_thermal_energy(heat_transfer)
						cell.use(heat_transfer*CELLRATE)
					else	//cooling air
						heat_transfer = abs(heat_transfer)

						//Assume the heat is being pumped into the hull which is fixed at 20 C
						var/cop = removed.temperature/T20C	//coefficient of performance from thermodynamics -> power used = heat_transfer/cop
						heat_transfer = min(heat_transfer, cop * heating_power)	//limit heat transfer by available power

						heat_transfer = removed.add_thermal_energy(-heat_transfer)	//get the actual heat transfer

						var/power_used = abs(heat_transfer)/cop
						cell.use(power_used*CELLRATE)

				env.merge(removed)
		else
			on = 0
			power_change()
			update_icon()

#define MODE_IDLE 0
#define MODE_HEATING 1
#define MODE_COOLING 2

/obj/machinery/power/thermoregulator
	name = "thermal regulator"
	desc = "A massive machine that can either add or remove thermal energy from the surrounding environment. Must be secured onto a powered wire node to function."
	icon = 'icons/obj/machines/thermoregulator_vr.dmi'
	icon_state = "lasergen"
	density = 1
	anchored = 0

	use_power = USE_POWER_OFF //is powered directly from cables
	active_power_usage = 150 KILOWATTS  //BIG POWER
	idle_power_usage = 500

	circuit = /obj/item/circuitboard/thermoregulator

	var/on = 0
	var/target_temp = T20C
	var/mode = MODE_IDLE

/obj/machinery/power/thermoregulator/Initialize()
	.=..()
	default_apply_parts()

/obj/machinery/power/thermoregulator/examine(mob/user)
	. = ..()
	. += "<span class = 'notice'>There is a small display that reads [target_temp]K.</span>"

/obj/machinery/power/thermoregulator/attackby(obj/item/I, mob/user)
	if(I.is_screwdriver())
		if(default_deconstruction_screwdriver(user,I))
			return
	if(I.is_crowbar())
		if(default_deconstruction_crowbar(user,I))
			return
	if(I.is_wrench())
		anchored = !anchored
		visible_message("<span class='notice'>\The [src] has been [anchored ? "bolted to the floor" : "unbolted from the floor"] by [user].</span>")
		playsound(src, I.usesound, 75, 1)
		if(anchored)
			connect_to_network()
		else
			disconnect_from_network()
			turn_off()
		return
	if(istype(I, /obj/item/multitool))
		var/new_temp = input("Input a new target temperature, in degrees C.","Target Temperature", 20) as num
		if(!Adjacent(user) || user.incapacitated())
			return
		new_temp = convert_c2k(new_temp)
		target_temp = max(new_temp, TCMB)
		return
	..()

/obj/machinery/power/thermoregulator/attack_hand(mob/user)
	add_fingerprint(user)
	interact(user)

/obj/machinery/power/thermoregulator/interact(mob/user)
	if(!anchored)
		return
	on = !on
	user.visible_message("<span class='notice'>[user] [on ? "activates" : "deactivates"] \the [src].</span>","<span class='notice'>You [on ? "activate" : "deactivate"] \the [src].</span>")
	if(!on)
		change_mode(MODE_IDLE)
	update_icon()

/obj/machinery/power/thermoregulator/process()
	if(!on)
		return
	if(!powernet)
		turn_off()
		return

	if(draw_power(idle_power_usage) < idle_power_usage)
		visible_message("<span class='notice'>\The [src] shuts down.</span>")
		turn_off()
		return

	var/datum/gas_mixture/env = loc.return_air()
	if(!env || abs(env.temperature - target_temp) < 1)
		change_mode(MODE_IDLE)
		return

	var/datum/gas_mixture/removed = env.remove_ratio(0.99)
	if(!removed)
		change_mode(MODE_IDLE)
		return

	var/heat_transfer = removed.get_thermal_energy_change(target_temp)
	var/power_avail
	if(heat_transfer == 0) //just in case
		change_mode(MODE_IDLE)
	else if(heat_transfer > 0)
		change_mode(MODE_HEATING)
		power_avail = draw_power(min(heat_transfer, active_power_usage))
		removed.add_thermal_energy(min(power_avail*5,heat_transfer))
	else
		change_mode(MODE_COOLING)
		heat_transfer = abs(heat_transfer)
		var/cop = removed.temperature/TN60C
		var/actual_heat_transfer = heat_transfer
		heat_transfer = min(heat_transfer, active_power_usage*cop)
		power_avail = draw_power(heat_transfer/cop)
		removed.add_thermal_energy(-min(power_avail*5*cop,actual_heat_transfer))
	env.merge(removed)

/obj/machinery/power/thermoregulator/update_icon()
	overlays.Cut()
	if(on)
		overlays += "lasergen-on"
		switch(mode)
			if(MODE_HEATING)
				overlays += "lasergen-heat"
			if(MODE_COOLING)
				overlays += "lasergen-cool"

/obj/machinery/power/thermoregulator/proc/turn_off()
	on = 0
	change_mode(MODE_IDLE)
	update_icon()

/obj/machinery/power/thermoregulator/proc/change_mode(new_mode = MODE_IDLE)
	if(mode == new_mode)
		return
	mode = new_mode
	update_icon()

/obj/machinery/power/thermoregulator/emp_act(severity)
	if(!on)
		on = 1
	target_temp += rand(0, 1000)
	update_icon()
	..(severity)

/obj/machinery/power/thermoregulator/overload(var/obj/machinery/power/source)
	if(!anchored || !powernet)
		return
	var/power_avail = draw_power(active_power_usage*10)
	var/datum/gas_mixture/env = loc.return_air()
	if(env)
		var/datum/gas_mixture/removed = env.remove_ratio(0.99)
		if(removed)
			removed.add_thermal_energy(power_avail*5)
			env.merge(removed)
	var/turf/T = get_turf(src)
	new /obj/effect/decal/cleanable/liquid_fuel(T, 5)
	T.assume_gas(/datum/gas/volatile_fuel, 5, T20C)
	T.hotspot_expose(700,400)
	var/datum/effect_system/spark_spread/s = new
	s.set_up(5, 0, T)
	s.start()
	visible_message("<span class='warning'>\The [src] bursts into flame!</span>")

#undef MODE_IDLE
#undef MODE_HEATING
#undef MODE_COOLING
