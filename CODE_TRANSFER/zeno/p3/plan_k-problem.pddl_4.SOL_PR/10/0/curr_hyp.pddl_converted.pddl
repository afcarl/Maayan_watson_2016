(define (problem ZTRAVEL-2-4) (:domain zeno-travel)
(:objects
plane2 - aircraft
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
plane1 - aircraft
person4 - person
city2 - city
city0 - city
city1 - city
)
(:init (= (total-cost) 0) (considered_occur_init)
(at plane1 city0)
(fuel-level plane1 fl4)
(at plane2 city2)
(fuel-level plane2 fl5)
(at person1 city0)
(at person2 city0)
(at person3 city1)
(at person4 city1)
(next fl0 fl1)
(next fl1 fl2)
(next fl2 fl3)
(next fl3 fl4)
(next fl4 fl5)
(next fl5 fl6)
(K-obj plane1 fl1)
(K-obj plane1 fl0)
(K-obj plane1 fl3)
(K-obj plane1 fl2)
(K-obj plane1 fl5)
(K-obj plane1 fl4)
(K-obj plane1 fl6)
(K-obj plane1 person2)
(K-obj plane1 person3)
(K-obj plane1 person1)
(K-obj plane1 person4)
(K-obj plane1 city2)
(K-obj plane1 city0)
(K-obj plane1 city1)
(K-obj plane2 fl1)
(K-obj plane2 fl0)
(K-obj plane2 fl3)
(K-obj plane2 fl2)
(K-obj plane2 fl5)
(K-obj plane2 fl4)
(K-obj plane2 fl6)
(K-obj plane2 person2)
(K-obj plane2 person3)
(K-obj plane2 person1)
(K-obj plane2 person4)
(K-obj plane2 city2)
(K-obj plane2 city0)
(K-obj plane2 city1)
(K-obj plane1 plane1)
(K-obj plane2 plane2)
(K-ag-pred plane1 pred--fuel-level)
(K-ag-pred plane1 pred--in)
(K-ag-pred plane2 pred--fuel-level)
(K-ag-pred plane2 pred--in)
(K-ag-pred plane1 pred--at)
(K-pred plane1 pred--at)
(K-ag-pred plane2 pred--at)
(K-pred plane2 pred--at)
(K-ag-pred plane1 pred--next)
(K-pred plane1 pred--next)
(K-ag-pred plane2 pred--next)
(K-pred plane2 pred--next)
)
(:goal	(and (considered__fuel-level_PLANE1_FL0__1)
(at person1 city1) (at person2 city0) (at person3 city0) (at person4 city1)
)
)
(:metric minimize (total-time))
)
