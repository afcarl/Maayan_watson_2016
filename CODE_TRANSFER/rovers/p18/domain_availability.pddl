(define (domain rover)
	(:requirements :typing :multi-agent :unfactored-privacy :durative-actions)
(:types
	rover waypoint store camera mode lander objective - object
)
(:predicates
	;;public
	(visible ?w - waypoint ?p - waypoint)
	(visible_from ?o - objective ?w - waypoint)

	;;public because public in some problems
	(at_rock_sample ?w - waypoint)
	(at_soil_sample ?w - waypoint)
	(at_lander ?x - lander ?y - waypoint)
	(communicated_image_data ?o - objective ?m - mode)
        (communicated_rock_data ?w - waypoint)
	(communicated_soil_data ?w - waypoint)

	;;public because shared among all agents without reference to an agent
	(empty ?s - store)
	(full ?s - store)
	(supports ?c - camera ?m - mode)
	(calibration_target ?i - camera ?o - objective)
	(channel_free ?l - lander)

	(:private ?agent - rover
		(at ?agent - rover ?y - waypoint)
		(can_traverse ?agent - rover ?x - waypoint ?y - waypoint)
		(equipped_for_soil_analysis ?agent - rover)
		(equipped_for_rock_analysis ?agent - rover)
		(equipped_for_imaging ?agent - rover)
		(have_rock_analysis ?agent - rover ?w - waypoint)
		(have_soil_analysis ?agent - rover ?w - waypoint)
		(calibrated ?c - camera ?agent - rover)
		(available ?agent - rover)
		(have_image ?agent - rover ?o - objective ?m - mode)
		(store_of ?s - store ?agent - rover)
		(on_board ?i - camera ?agent - rover)
	)
)

(:durative-action navigate
	:agent ?x - rover
	:parameters (?y - waypoint ?z - waypoint)
	:duration (= ?duration 5)
	:condition (and
		(over all (can_traverse ?x ?y ?z))
		(at start (available ?x))
		(at start (at ?x ?y)) 
		(over all (visible ?y ?z))
		(at start (available ?x))
	)
	:effect (and
		(at start (not (at ?x ?y)))
		(at end (at ?x ?z))
		(at start (not (available ?x)))
		(at end (available ?x))
	)
)


(:durative-action sample_soil
	:agent ?x - rover
	:parameters (?s - store ?p - waypoint)
	:duration (= ?duration 10)
	:condition (and
		(over all (at ?x ?p))
		(at start (at_soil_sample ?p))
		(at start (equipped_for_soil_analysis ?x))
		(at start (store_of ?s ?x))
		(at start (empty ?s))
		(at start (available ?x))
	)
	:effect (and
		(at start (not (empty ?s)))
		(at end (full ?s))
		(at end (have_soil_analysis ?x ?p))
		(at end (not (at_soil_sample ?p)))
		(at start (not (available ?x)))
		(at end (available ?x))
	)
)


(:durative-action sample_rock
	:agent ?x - rover
	:parameters (?s - store ?p - waypoint)
	:duration (= ?duration 8)
	:condition (and
		(over all (at ?x ?p))
		(at start (at_rock_sample ?p))
		(at start (equipped_for_rock_analysis ?x))
		(at start (store_of ?s ?x))
		(at start (empty ?s))
		(at start (available ?x))
	)
	:effect (and
		(at start (not (empty ?s)))
		(at end (full ?s))
		(at end (have_rock_analysis ?x ?p))
		(at end (not (at_rock_sample ?p)))
		(at start (not (available ?x)))
		(at end (available ?x))
	)
)


(:durative-action drop
	:agent ?x - rover
	:parameters (?y - store)
	:duration (= ?duration 1)
	:condition (and
		(at start (store_of ?y ?x))
		(at start (full ?y))
		(at start (available ?x))
	)
	:effect (and
		(at end (not (full ?y)))
		(at end (empty ?y))
		(at start (not (available ?x)))
		(at end (available ?x))
	)
)


(:durative-action calibrate
	:agent ?r - rover
	:parameters (?i - camera ?t - objective ?w - waypoint)
	:duration (= ?duration 7)
	:condition (and
		(at start (equipped_for_imaging ?r))
		(at start (calibration_target ?i ?t))
		(over all (at ?r ?w))
		(at start (visible_from ?t ?w))
		(at start (on_board ?i ?r))
		(at start (available ?r))
	)
	:effect (and 
		(at end (calibrated ?i ?r)) 
		(at start (not (available ?r)))
		(at end (available ?r))
	)
)


(:durative-action take_image
	:agent ?r - rover
	:parameters (?p - waypoint ?o - objective ?i - camera ?m - mode)
	:duration (= ?duration 7)
	:condition (and
		(over all (calibrated ?i ?r))
		(at start (on_board ?i ?r))
		(over all (equipped_for_imaging ?r))
		(over all (supports ?i ?m) )
		(over all (visible_from ?o ?p))
		(over all (at ?r ?p))
		(at start (available ?r))
	)
	:effect (and
		(at end (have_image ?r ?o ?m))
		(at end (not (calibrated ?i ?r)))
		(at start (not (available ?r)))
		(at end (available ?r))
	)
)


(:durative-action communicate_soil_data
	:agent ?r - rover
	:parameters (?l - lander ?p - waypoint ?x - waypoint ?y - waypoint)
	:duration (= ?duration 10)
	:condition (and
		(over all (at ?r ?x))
		(over all (at_lander ?l ?y))
		(at start (have_soil_analysis ?r ?p))
		(at start (visible ?x ?y))
		(at start (available ?r))
		(at start (channel_free ?l))
		(at start (available ?r))
	)
	:effect (and
		(at start (not (available ?r)))
		(at start (not (channel_free ?l)))
		(at end (channel_free ?l))
		(at end (communicated_soil_data ?p))
		(at end (available ?r))
		(at start (not (available ?r)))
		(at end (available ?r))
	)
)


(:durative-action communicate_rock_data
	:agent ?r - rover
	:parameters (?l - lander ?p - waypoint ?x - waypoint ?y - waypoint)
	:duration (= ?duration 10)
	:condition (and
		(over all (at ?r ?x))
		(over all (at_lander ?l ?y))
		(at start (have_rock_analysis ?r ?p)) 
		(at start (visible ?x ?y))
		(at start (available ?r))
		(at start (channel_free ?l))
		(at start (available ?r))
	)
	:effect (and
		(at start (not (available ?r)))
		(at start (not (channel_free ?l)))
		(at end (channel_free ?l))
		(at end (communicated_rock_data ?p))
		(at end (available ?r))
		(at start (not (available ?r)))
		(at end (available ?r))
	)
)


(:durative-action communicate_image_data
	:agent ?r - rover
	:parameters (?l - lander ?o - objective ?m - mode ?x - waypoint ?y - waypoint)
	:duration (= ?duration 15)
	:condition (and
		(over all (at ?r ?x))
		(over all (at_lander ?l ?y))
		(at start (have_image ?r ?o ?m))
		(at start (visible ?x ?y))
		(at start (available ?r))
		(at start (channel_free ?l))
		(at start (available ?r))
	)
	:effect (and
		(at start (not (available ?r)))
		(at start (not (channel_free ?l)))
		(at end (channel_free ?l))
		(at end (communicated_image_data ?o ?m))
		(at end (available ?r))
		(at start (not (available ?r)))
		(at end (available ?r))
	)
)

)
