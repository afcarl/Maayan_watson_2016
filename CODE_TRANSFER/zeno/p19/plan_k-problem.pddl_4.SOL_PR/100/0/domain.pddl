(define (domain zeno-travel)
	(:requirements :typing :multi-agent :unfactored-privacy :durative-actions)
(:types
	locatable city flevel - object
	aircraft person - locatable
)
(:predicates
	(at ?x - locatable ?c - city)
	(next ?l1 - flevel ?l2 - flevel)

	(:private ?agent - aircraft
		(fuel-level ?agent - aircraft ?l - flevel)
		(in ?p - person ?agent - aircraft)
	)
)

(:durative-action board
	:agent ?a - aircraft
	:parameters (?p - person ?c - city)
	:duration (= ?duration 20)
	:condition (and
		(at start (at ?p ?c))
		(over all (at ?a ?c))
	)
	:effect (and
		(at end (in ?p ?a))
		(at start (not (at ?p ?c)))
	)
)


(:durative-action debark
	:agent ?a - aircraft
	:parameters (?p - person ?c - city)
	:duration (= ?duration 30)
	:condition (and
		(at start (in ?p ?a))
		(over all (at ?a ?c))
	)
	:effect (and
		(at end (at ?p ?c))
		(at start (not (in ?p ?a)))
	)
)


(:durative-action fly
	:agent ?a - aircraft
	:parameters (?c1 - city ?c2 - city ?l1 - flevel ?l2 - flevel)
	:duration (= ?duration 180)
	:condition (and
		(at start (at ?a ?c1))
		(at start (fuel-level ?a ?l1))
		(at start (next ?l2 ?l1))
	)
	:effect (and
		(at end (at ?a ?c2))
		(at end (fuel-level ?a ?l2))
		(at start (not (at ?a ?c1)))
		(at end (not (fuel-level ?a ?l1)))
	)
)


(:durative-action zoom
	:agent ?a - aircraft
	:parameters (?c1 - city ?c2 - city ?l1 - flevel ?l2 - flevel ?l3 - flevel)
	:duration (= ?duration 100)
	:condition (and
		(at start (at ?a ?c1))
		(at start (fuel-level ?a ?l1))
		(at start (next ?l2 ?l1))
		(at start (next ?l3 ?l2))
	)
	:effect (and
		(at end (at ?a ?c2))
		(at end (fuel-level ?a ?l3))
		(at start (not (at ?a ?c1)))
		(at end (not (fuel-level ?a ?l1)))
	)
)


(:durative-action refuel
	:agent ?a - aircraft
	:parameters (?c - city ?l - flevel ?l1 - flevel)
	:duration (= ?duration 73)
	:condition (and
		(at start (fuel-level ?a ?l))
		(at start (next ?l ?l1))
		(over all (at ?a ?c))
	)
	:effect (and
		(at end (fuel-level ?a ?l1))
		(at end (not (fuel-level ?a ?l)))
	)
)

)