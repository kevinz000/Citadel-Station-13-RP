//Returns 1 if the turf is dense, or if there's dense objects on it, unless told to ignore them.
/turf/proc/check_density(var/ignore_objs = 0)
	if(density)
		return 1
	if(!ignore_objs)
		for(var/atom/movable/stuff in contents)
			if(stuff.density)
				return 1
	return 0

// Used to distinguish friend from foe.
/obj/item/weapon/spell/proc/is_ally(var/mob/living/L)
	if(L == owner) // The best ally is ourselves.
		return 1
	if(L.mind && technomancers.is_antagonist(L.mind)) // This should be done better since we might want opposing technomancers later.
		return 1
	if(istype(L, /mob/living/simple_animal/hostile)) // Mind controlled simple mobs count as allies too.
		var/mob/living/simple_animal/SA = L
		if(owner in SA.friends)
			return 1
	return 0

/obj/item/weapon/spell/proc/allowed_to_teleport()
	if(owner)
		if(owner.z in using_map.admin_levels)
			return FALSE

		var/turf/T = get_turf(owner)
		if(T.block_tele)
			return FALSE
	return TRUE

/obj/item/weapon/spell/proc/within_range(var/atom/target, var/max_range = 7) // Beyond 7 is off the screen.
	if(target in view(max_range, owner))
		return TRUE
	return FALSE

/obj/item/weapon/spell/proc/calculate_spell_power(var/amount)
	if(core)
		return round(amount * core.spell_power_modifier, 1)

// Returns a 'target' mob from a radius around T.
/obj/item/weapon/spell/proc/targeting_assist(var/turf/T, radius = 5)
	var/chosen_target = null
	var/potential_targets = view(T,radius)
	for(var/mob/living/L in potential_targets)
		if(is_ally(L)) // Don't shoot our friends.
			continue
		if(L.invisibility > owner.see_invisible) // Don't target ourselves or people we can't see.
			continue
		if(!L in viewers(owner)) // So we don't shoot at walls if someone is hiding behind one.
			continue
		if(!L.stat) // Don't want to target dead people or SSDs.
			chosen_target = L
			break
	return chosen_target