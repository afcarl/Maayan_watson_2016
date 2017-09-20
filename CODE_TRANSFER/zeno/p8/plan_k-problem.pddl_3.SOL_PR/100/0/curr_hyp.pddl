(define (problem ZTRAVEL-3-6) (:domain zeno-travel)
(:objects
	fl1 - flevel
	fl0 - flevel
	fl3 - flevel
	fl2 - flevel
	fl5 - flevel
	fl4 - flevel
	fl6 - flevel
	person2 - person
	person3 - person
	person1 - person
	person6 - person
	plane1 - aircraft
	person4 - person
	person5 - person
	city2 - city
	city3 - city
	city0 - city
	city1 - city
	city4 - city
)
(:init
	(at plane1 city0)
	(fuel-level plane1 fl6)
	(at person1 city1)
	(at person2 city0)
	(at person3 city2)
	(at person4 city0)
	(at person5 city3)
	(at person6 city4)
	(next fl0 fl1)
	(next fl1 fl2)
	(next fl2 fl3)
	(next fl3 fl4)
	(next fl4 fl5)
	(next fl5 fl6)
	(K-obj plane1 person2)
	(K-obj plane1 person3)
	(K-obj plane1 person1)
	(K-obj plane1 person6)
	(K-obj plane1 person4)
	(K-obj plane1 person5)
	(K-obj plane1 city2)
	(K-obj plane1 city3)
	(K-obj plane1 city0)
	(K-obj plane1 city1)
	(K-obj plane1 city4)
	(K-obj plane1 fl1)
	(K-obj plane1 fl0)
	(K-obj plane1 fl3)
	(K-obj plane1 fl2)
	(K-obj plane1 fl5)
	(K-obj plane1 fl4)
	(K-obj plane1 fl6)
	(K-obj plane1 plane1)
	(K-ag-pred plane1 pred--fuel-level)
	(K-ag-pred plane1 pred--in)
	(K-ag-pred plane1 pred--at)
	(K-pred plane1 pred--at)
	(K-ag-pred plane1 pred--next)
	(K-pred plane1 pred--next)
)
(:goal	(and
(at person1 city0) (at person2 city0) (at person3 city1) (at person4 city0)
)
)
(:metric minimize (total-time))
)
