(define (problem depotprob7512) (:domain depot)
(:objects
	truck1 - truck
	truck0 - truck
	depot0 - depot
	crate1 - crate
	crate0 - crate
	crate3 - crate
	crate2 - crate
	pallet1 - pallet
	pallet0 - pallet
	pallet2 - pallet
	distributor1 - distributor
	distributor0 - distributor





)
(:init
	(clear crate0)
	(clear crate3)
	(clear crate2)
	(on crate0 pallet0)
	(on crate1 pallet2)
	(on crate2 crate1)
	(on crate3 pallet1)
)
(:goal
	(and
		(on crate0 pallet2)
		(on crate1 crate3)
		(on crate2 pallet0)
		(on crate3 pallet1)
	)
)
)
