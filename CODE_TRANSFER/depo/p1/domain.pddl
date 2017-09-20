(define (domain depot)
	(:requirements :typing :multi-agent :durative-actions :unfactored-privacy)
(:types
	place locatable driver - object
	depot distributor - place
	truck hoist surface - locatable
	pallet crate - surface
)
(:predicates
	(at ?x - locatable ?y - place)
	(on ?x - crate ?y - surface)
	(in ?x - crate ?y - truck)
	(clear ?x - surface)
	(free ?x - truck)

	(:private ?agent - place
		(lifting ?agent - place ?x - hoist ?y - crate)
		(available ?agent - place ?x - hoist)
	)

	(:private ?agent - driver
		(driving ?agent - driver ?t - truck)
	)

)

(:durative-action drive
	:agent ?a - driver
	:parameters (?x - truck ?y - place ?z - place)
	:duration (= ?duration 10)
	:condition 
		(and (at start (at ?x ?y)) (over all (driving ?a ?x)))
	:effect (and
		(at end (at ?x ?z))
		(at start (not (at ?x ?y)))
	)
)


(:durative-action lift
	:agent ?p - place
	:parameters (?x - hoist ?y - crate ?z - surface)
	:duration (= ?duration 1)
	:condition (and
		(over all (at ?x ?p))
		(at start (available ?p ?x))
		(at start (at ?y ?p))
		(at start (on ?y ?z))
		(at start (clear ?y))
	)
	:effect (and
		(at start (lifting ?p ?x ?y))
		(at start (clear ?z))
		(at start (not (at ?y ?p)))
		(at start (not (clear ?y)))
		(at start (not (available ?p ?x)))
		(at start (not (on ?y ?z)))
	)
)


(:durative-action drop
	:agent ?p - place
	:parameters (?x - hoist ?y - crate ?z - surface)
	:duration (= ?duration 1)
	:condition (and
		(over all (at ?x ?p))
		(over all (at ?z ?p))
		(over all (clear ?z))
		(over all (lifting ?p ?x ?y))
	)
	:effect (and
		(at end (available ?p ?x))
		(at end (at ?y ?p))
		(at end (clear ?y))
		(at end (on ?y ?z))
		(at end (not (lifting ?p ?x ?y)))
		(at end (not (clear ?z)))
	)
)


(:durative-action load
	:agent ?p - place
	:parameters (?x - hoist ?y - crate ?z - truck)
	:duration (= ?duration 3)
	:condition (and
		(at start (free ?z))
		(over all (at ?x ?p))
		(over all (at ?z ?p))
		(over all (lifting ?p ?x ?y))
	)
	:effect (and
		(at end (not (free ?w ?z)))
		(at end (in ?y ?z))
		(at end (available ?p ?x))
		(at end (not (lifting ?p ?x ?y)))
	)
)


(:durative-action unload
	:agent ?p - place
	:parameters (?x - hoist ?y - crate ?z - truck)
	:duration (= ?duration 4)
	:condition (and
		(over all(at ?x ?p))
		(over all (at ?z ?p))
		(at start (available ?p ?x))
		(at start (in ?y ?z))
	)
	:effect (and
		(at end (free ?z))
		(at end (lifting ?p ?x ?y))
		(at start (not (in ?y ?z)))
		(at start (not (available ?p ?x)))
	)
)

)


