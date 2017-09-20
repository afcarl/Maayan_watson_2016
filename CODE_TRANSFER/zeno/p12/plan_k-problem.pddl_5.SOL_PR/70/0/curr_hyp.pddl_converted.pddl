(define (problem ZTRAVEL-3-8) (:domain zeno-travel)
(:objects
person2 - person
person3 - person
person1 - person
person6 - person
person7 - person
person4 - person
person5 - person
city2 - city
city3 - city
person8 - person
city1 - city
city0 - city
city4 - city
city5 - city
fl1 - flevel
fl0 - flevel
fl3 - flevel
fl2 - flevel
fl5 - flevel
fl4 - flevel
fl6 - flevel
plane3 - aircraft
)
(:init (= (total-cost) 0) (considered_occur_init)
(at plane3 city5)
(fuel-level plane3 fl2)
(at person1 city4)
(at person2 city4)
(at person3 city0)
(at person4 city4)
(at person5 city1)
(at person6 city2)
(at person7 city5)
(at person8 city5)
(next fl0 fl1)
(next fl1 fl2)
(next fl2 fl3)
(next fl3 fl4)
(next fl4 fl5)
(next fl5 fl6)
(K-obj plane3 person2)
(K-obj plane3 person3)
(K-obj plane3 person1)
(K-obj plane3 person6)
(K-obj plane3 person7)
(K-obj plane3 person4)
(K-obj plane3 person5)
(K-obj plane3 city2)
(K-obj plane3 city3)
(K-obj plane3 person8)
(K-obj plane3 city1)
(K-obj plane3 city0)
(K-obj plane3 city4)
(K-obj plane3 city5)
(K-obj plane3 fl1)
(K-obj plane3 fl0)
(K-obj plane3 fl3)
(K-obj plane3 fl2)
(K-obj plane3 fl5)
(K-obj plane3 fl4)
(K-obj plane3 fl6)
(K-obj plane3 plane3)
(K-ag-pred plane3 pred--fuel-level)
(K-ag-pred plane3 pred--in)
(K-ag-pred plane3 pred--at)
(K-pred plane3 pred--at)
(K-ag-pred plane3 pred--next)
(K-pred plane3 pred--next)
)
(:goal	(and (considered__at_PERSON5_CITY4__10)
(at person2 city1)
)
)
(:metric minimize (total-time))
)
