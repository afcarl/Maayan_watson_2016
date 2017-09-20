(define (domain depot)
	(:requirements :durative-actions :typing)
(:types
	place locatable driver - object
	truck hoist surface - locatable
	pallet crate - surface
	place driver - superduperagent
	superduperobject superduperpred hoist locatable object driver surface pallet superduperagent place crate distributor truck depot - superduperobject
	depot distributor - place
)
(:constants
	pred--at pred--on pred--in pred--clear pred--lifting pred--available pred--driving  - superduperpred
)
(:predicates
	(at ?x - locatable ?y - place)
	(on ?x - crate ?y - surface)
	(in ?x - crate ?y - truck)
	(clear ?x - surface)
	(lifting ?agent - place ?x - hoist ?y - crate)
	(available ?agent - place ?x - hoist)
	(driving ?agent - driver ?t - truck)
	(K-obj ?ag - superduperagent ?obj - superduperobject)
	(K-pred ?ag - superduperagent ?pr - superduperpred)
	(K-ag-pred ?ag - superduperagent ?pr - superduperpred)
)

(:durative-action drive
	:parameters (?a - driver ?x - truck ?y - place ?z - place)
	:duration (= ?duration 20)
	:condition (and
		(at start(at ?x ?y ))
		(over all(driving ?a ?x ))
		(at start(K-ag-pred ?a pred--driving))
		(at start(K-pred ?a pred--at))
		(at start(K-obj ?a ?x))
		(at start(K-obj ?a ?y))
		(at start(K-obj ?a ?z))
	)
	:effect (and
		(at end(at ?x ?z ))
		(at start(not (at ?x ?y )))
	)
)


(:durative-action lift
	:parameters (?p - place ?x - hoist ?y - crate ?z - surface)
	:duration (= ?duration 11)
	:condition (and
		(over all(at ?x ?p ))
		(at start(available ?p ?x ))
		(at start(at ?y ?p ))
		(at start(on ?y ?z ))
		(at start(clear ?y ))
		(at start(K-pred ?p pred--clear))
		(at start(K-pred ?p pred--on))
		(at start(K-ag-pred ?p pred--lifting))
		(at start(K-ag-pred ?p pred--available))
		(at start(K-ag-pred ?p pred--at))
		(at start(K-obj ?p ?x))
		(at start(K-obj ?p ?y))
		(at start(K-obj ?p ?z))
	)
	:effect (and
		(at start(lifting ?p ?x ?y ))
		(at start(clear ?z ))
		(at start(not (at ?y ?p )))
		(at start(not (clear ?y )))
		(at start(not (available ?p ?x )))
		(at start(not (on ?y ?z )))
	)
)


(:durative-action drop
	:parameters (?p - place ?x - hoist ?y - crate ?z - surface)
	:duration (= ?duration 11)
	:condition (and
		(over all(at ?x ?p ))
		(over all(at ?z ?p ))
		(over all(clear ?z ))
		(over all(lifting ?p ?x ?y ))
		(at start(K-pred ?p pred--clear))
		(at start(K-pred ?p pred--on))
		(at start(K-ag-pred ?p pred--lifting))
		(at start(K-ag-pred ?p pred--available))
		(at start(K-ag-pred ?p pred--at))
		(at start(K-obj ?p ?x))
		(at start(K-obj ?p ?y))
		(at start(K-obj ?p ?z))
	)
	:effect (and
		(at end(available ?p ?x ))
		(at end(at ?y ?p ))
		(at end(clear ?y ))
		(at end(on ?y ?z ))
		(at end(not (lifting ?p ?x ?y )))
		(at end(not (clear ?z )))
	)
)


(:durative-action load
	:parameters (?p - place ?x - hoist ?y - crate ?z - truck)
	:duration (= ?duration 13)
	:condition (and
		(over all(at ?x ?p ))
		(over all(at ?z ?p ))
		(over all(lifting ?p ?x ?y ))
		(at start(K-pred ?p pred--in))
		(at start(K-ag-pred ?p pred--lifting))
		(at start(K-ag-pred ?p pred--available))
		(at start(K-ag-pred ?p pred--at))
		(at start(K-obj ?p ?x))
		(at start(K-obj ?p ?y))
		(at start(K-obj ?p ?z))
	)
	:effect (and
		(at end(in ?y ?z ))
		(at end(available ?p ?x ))
		(at end(not (lifting ?p ?x ?y )))
	)
)


(:durative-action unload
	:parameters (?p - place ?x - hoist ?y - crate ?z - truck)
	:duration (= ?duration 14)
	:condition (and
		(over all(at ?x ?p ))
		(over all(at ?z ?p ))
		(at start(available ?p ?x ))
		(at start(in ?y ?z ))
		(at start(K-pred ?p pred--in))
		(at start(K-ag-pred ?p pred--lifting))
		(at start(K-ag-pred ?p pred--available))
		(at start(K-ag-pred ?p pred--at))
		(at start(K-obj ?p ?x))
		(at start(K-obj ?p ?y))
		(at start(K-obj ?p ?z))
	)
	:effect (and
		(at end(lifting ?p ?x ?y ))
		(at start(not (in ?y ?z )))
		(at start(not (available ?p ?x )))
	)
)

)