/obj/structure/table/bench
	name = "bench frame"
	icon = 'icons/obj/bench.dmi'
	icon_state = "frame"
	desc = "It's a bench, for putting things on. Or standing on, if you really want to."
	can_reinforce = FALSE
	flipped = -1
	density = FALSE

/obj/structure/table/bench/CanPass(atom/movable/mover)
	return 1
