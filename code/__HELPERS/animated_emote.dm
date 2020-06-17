// this entire file is the physical embodiment of a shitpost.

/**
  * Prepares a human mob for an animated emote by generating a list(head, body, larm, rarm, lleg, rleg) of effects using alpha masking.
  * Only works on north/south.
  */
/proc/prepare_animated_pose_parts(mob/living/carbon/human/H)
	if(H.dir & (EAST|WEST))
		return "Invalid directions"
	var/list/returned = list()
	var/static/icon/maskfile = 'icons/effects/animated_emotes.dmi'
	// appearance clones!
	var/obj/effect/overlay/head = new(null)
	var/obj/effect/overlay/body = new(null)
	var/obj/effect/overlay/larm = new(null)
	var/obj/effect/overlay/rarm = new(null)
	var/obj/effect/overlay/lleg = new(null)
	var/obj/effect/overlay/rleg = new(null)
	head.appearance = H
	body.appearance = H
	larm.appearance = H
	rarm.appearance = H
	lleg.appearance = H
	rleg.appearance = H
	head.layer += 0.1
	body.layer += 0.1
	larm.layer += 0.1
	rarm.layer += 0.1
	lleg.layer += 0.1
	rleg.layer += 0.1
	returned = list(head, body, larm, rarm, lleg, rleg)
	head.filters += filter(type = "alpha", icon = icon(maskfile, "mask_head"))
	body.filters += filter(type = "alpha", icon = icon(maskfile, "mask_body"))
	larm.filters += filter(type = "alpha", icon = icon(maskfile, "mask_larm"))
	rarm.filters += filter(type = "alpha", icon = icon(maskfile, "mask_rarm"))
	lleg.filters += filter(type = "alpha", icon = icon(maskfile, "mask_lleg"))
	rleg.filters += filter(type = "alpha", icon = icon(maskfile, "mask_rleg"))
	return returned

/proc/t_pose(mob/living/carbon/human/H)
	if(H.dir & (EAST|WEST))
		return
	var/list/obj/effect/overlay/effects = prepare_animated_pose_parts(H)
	// we want to hide their arms
	var/static/icon/maskfile = 'icons/effects/animated_emotes.dmi'
	var/flarms = filter(type = "alpha", icon = icon(maskfile, "mask_arms"), flags = MASK_INVERSE)
	H.filters += flarms
	// 10 ds total
	var/obj/effect/overlay/larm = effects[3]
	var/obj/effect/overlay/rarm = effects[4]
	H.vis_contents += larm
	H.vis_contents += rarm
	var/matrix/ltransform = matrix()
	var/matrix/rtransform = matrix()
	ltransform.Turn(90)
	rtransform.Turn(-90)
	animate(larm, ltransform, time = 2)
	animate(rarm, rtransform, time = 2)
	sleep(8)
	animate(larm, transform = matrix(), time = 2)
	animate(rarm, transform = matrix(), time = 2)
	sleep(2)
	H.vis_contents -= flarms
	H.filters -= flarm
	H.filters -= frarm
	QDEL_LIST(effects)
