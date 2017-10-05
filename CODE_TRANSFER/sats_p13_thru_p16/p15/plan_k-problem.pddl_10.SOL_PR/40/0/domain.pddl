(define (domain satellite)
	(:requirements :multi-agent :unfactored-privacy :durative-actions)
(:types
	satellite direction instrument mode - object
)
(:predicates
	(pointing ?s - satellite ?d - direction)
	(have_image ?d - direction ?m - mode)
	(calibrated ?i - instrument)
	(supports ?i - instrument ?m - mode)
	(on_board ?i - instrument ?agent - satellite)
	(calibration_target ?i - instrument ?d - direction)
	(power_avail ?agent - satellite)
	(power_on ?i - instrument)
)

(:durative-action turn_to
	:agent ?s - satellite
	:parameters (?d_new - direction ?d_prev - direction)
	:duration (= ?duration 5)
	:condition 
		(and   (at start (pointing ?s ?d_prev))  ) 
	:effect (and
		(at end (pointing ?s ?d_new))
		(at start (not (pointing ?s ?d_prev)))
	)
)


(:durative-action switch_on
	:agent ?s - satellite
	:parameters (?i - instrument)
	:duration (= ?duration 2)
	:condition (and
		(over all (on_board ?i ?s))
		(at start (power_avail ?s))
	)
	:effect (and
		(at end (power_on ?i))
		(at start (not (calibrated ?i)))
		(at start (not (power_avail ?s)))
	)
)


(:durative-action switch_off
	:agent ?s - satellite
	:parameters (?i - instrument)
	:duration (= ?duration 1)
	:condition (and
		(over all (on_board ?i ?s))
		(at start (power_on ?i)) 
	)
	:effect (and
		(at end (power_avail ?s))
		(at start (not (power_on ?i)))
	)
)


(:durative-action calibrate
	:agent ?s - satellite
	:parameters (?i - instrument ?d - direction)
	:duration (= ?duration 5)
	:condition (and
		(over all (on_board ?i ?s))
		(over all (calibration_target ?i ?d))
		(at start (pointing ?s ?d))
		(over all (power_on ?i))
	)
	:effect 
		(and (at end (calibrated ?i))   )
)


(:durative-action take_image
	:agent ?s - satellite
	:parameters (?i - instrument ?d - direction ?m - mode)
	:duration (= ?duration 7)
	:condition (and
		(over all (calibrated ?i))
		(over all (on_board ?i ?s))
		(over all (supports ?i ?m) )
		(over all (power_on ?i))
		(over all (pointing ?s ?d))
		(at end (power_on ?i))
	)
	:effect 
		(and    (at end (have_image ?d ?m))    )
)

)
