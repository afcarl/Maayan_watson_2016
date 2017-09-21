(define (domain satellite)
	(:requirements :durative-actions)
(:types
	satellite - superduperagent
	satellite direction instrument mode - object
	satellite object direction superduperpred instrument superduperagent superduperobject mode - superduperobject
)
(:constants
	pred--pointing pred--have_image pred--calibrated pred--supports pred--on_board pred--calibration_target pred--power_avail pred--power_on  - superduperpred
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
	(K-obj ?ag - superduperagent ?obj - superduperobject)
	(K-pred ?ag - superduperagent ?pr - superduperpred)
	(K-ag-pred ?ag - superduperagent ?pr - superduperpred)
)

(:durative-action turn_to
	:parameters (?s - satellite ?d_new - direction ?d_prev - direction)
	:duration (= ?duration 5)
	:condition (and
		(at start(pointing ?s ?d_prev ))
		(at start(K-ag-pred ?s pred--pointing))
		(at start(K-obj ?s ?d_new))
		(at start(K-obj ?s ?d_prev))
	)
	:effect (and
		(at end(pointing ?s ?d_new ))
		(at start(not (pointing ?s ?d_prev )))
	)
)


(:durative-action switch_on
	:parameters (?s - satellite ?i - instrument)
	:duration (= ?duration 2)
	:condition (and
		(over all(on_board ?i ?s ))
		(at start(power_avail ?s ))
		(at start(K-pred ?s pred--calibrated))
		(at start(K-ag-pred ?s pred--power_avail))
		(at start(K-pred ?s pred--power_on))
		(at start(K-ag-pred ?s pred--on_board))
		(at start(K-obj ?s ?i))
	)
	:effect (and
		(at end(power_on ?i ))
		(at start(not (calibrated ?i )))
		(at start(not (power_avail ?s )))
	)
)


(:durative-action switch_off
	:parameters (?s - satellite ?i - instrument)
	:duration (= ?duration 1)
	:condition (and
		(over all(on_board ?i ?s ))
		(at start(power_on ?i ))
		(at start(K-ag-pred ?s pred--power_avail))
		(at start(K-pred ?s pred--power_on))
		(at start(K-ag-pred ?s pred--on_board))
		(at start(K-obj ?s ?i))
	)
	:effect (and
		(at end(power_avail ?s ))
		(at start(not (power_on ?i )))
	)
)


(:durative-action calibrate
	:parameters (?s - satellite ?i - instrument ?d - direction)
	:duration (= ?duration 5)
	:condition (and
		(over all(on_board ?i ?s ))
		(over all(calibration_target ?i ?d ))
		(at start(pointing ?s ?d ))
		(over all(power_on ?i ))
		(at start(K-pred ?s pred--calibrated))
		(at start(K-pred ?s pred--power_on))
		(at start(K-ag-pred ?s pred--on_board))
		(at start(K-ag-pred ?s pred--pointing))
		(at start(K-pred ?s pred--calibration_target))
		(at start(K-obj ?s ?i))
		(at start(K-obj ?s ?d))
	)
	:effect 
		(at end(calibrated ?i ))
)


(:durative-action take_image
	:parameters (?s - satellite ?i - instrument ?d - direction ?m - mode)
	:duration (= ?duration 7)
	:condition (and
		(over all(calibrated ?i ))
		(over all(on_board ?i ?s ))
		(over all(supports ?i ?m ))
		(over all(power_on ?i ))
		(over all(pointing ?s ?d ))
		(at end(power_on ?i ))
		(at start(K-pred ?s pred--have_image))
		(at start(K-ag-pred ?s pred--pointing))
		(at start(K-pred ?s pred--calibrated))
		(at start(K-pred ?s pred--power_on))
		(at start(K-pred ?s pred--supports))
		(at start(K-ag-pred ?s pred--on_board))
		(at start(K-obj ?s ?i))
		(at start(K-obj ?s ?d))
		(at start(K-obj ?s ?m))
	)
	:effect 
		(at end(have_image ?d ?m ))
)

)