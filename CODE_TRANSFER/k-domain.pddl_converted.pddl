(define (domain zeno-travel)
(:requirements :durative-actions :typing)
(:types
city superduperpred flevel object locatable person aircraft superduperagent superduperobject - superduperobject
aircraft - superduperagent
locatable city flevel - object
aircraft person - locatable
)
(:constants
pred--at pred--next pred--fuel-level pred--in  - superduperpred
)
(:functions (total-cost)) 
 (:predicates (considered_occur_init) (freeze)(considered__in_PERSON9_PLANE3__0)
(considered__in_PERSON4_PLANE5__1)
(considered__at_PLANE2_CITY0__2)
(considered__fuel-level_PLANE2_FL4__3)
(considered_not__fuel-level_PLANE2_FL6__4_4)
(considered__at_PLANE1_CITY6__5)
(considered__fuel-level_PLANE1_FL0__6)
(considered_not__fuel-level_PLANE1_FL2__7_7)
(considered__in_PERSON6_PLANE2__8)
(considered__in_PERSON8_PLANE1__9)
(considered__at_PLANE3_CITY1__10)
(considered__in_PERSON5_PLANE1__11)
(considered__fuel-level_PLANE3_FL4__12)
(considered_not__fuel-level_PLANE3_FL6__13_13)
(considered__at_PLANE5_CITY7__14)
(considered__fuel-level_PLANE5_FL2__15)
(considered_not__fuel-level_PLANE5_FL4__16_16)
(considered__in_PERSON2_PLANE3__17)
(considered__in_PERSON10_PLANE5__18)
(considered__fuel-level_PLANE1_FL1__19)
(considered_not__fuel-level_PLANE1_FL0__20_20)
(considered__at_PLANE4_CITY4__21)
(considered__fuel-level_PLANE4_FL2__22)
(considered_not__fuel-level_PLANE4_FL3__23_23)
(considered__at_PLANE2_CITY6__24)
(considered__fuel-level_PLANE2_FL2__25)
(considered_not__fuel-level_PLANE2_FL4__26_26)
(considered__at_PLANE3_CITY8__27)
(considered__fuel-level_PLANE3_FL2__28)
(considered_not__fuel-level_PLANE3_FL4__29_29)
(considered__at_PLANE5_CITY9__30)
(considered__fuel-level_PLANE5_FL0__31)
(considered_not__fuel-level_PLANE5_FL2__32_32)
(considered__at_PERSON6_CITY6__33)
(considered__at_PERSON2_CITY8__34)
(considered__at_PERSON10_CITY9__35)
(considered__fuel-level_PLANE5_FL1__36)
(considered_not__fuel-level_PLANE5_FL0__37_37)
(considered__at_PLANE2_CITY7__38)
(considered__fuel-level_PLANE2_FL0__39)
(considered_not__fuel-level_PLANE2_FL2__40_40)
(considered__at_PLANE1_CITY1__41)
(considered__fuel-level_PLANE1_FL0__42)
(considered_not__fuel-level_PLANE1_FL1__43_43)
(considered__at_PLANE4_CITY0__44)
(considered__fuel-level_PLANE4_FL1__45)
(considered_not__fuel-level_PLANE4_FL2__46_46)
(considered__in_PERSON7_PLANE2__47)
(considered__at_PLANE3_CITY5__48)
(considered__fuel-level_PLANE3_FL0__49)
(considered_not__fuel-level_PLANE3_FL2__50_50)
(considered__in_PERSON3_PLANE4__51)
(considered__at_PERSON5_CITY1__52)
(considered__at_PERSON8_CITY1__53)
(considered__at_PERSON9_CITY5__54)
(considered__fuel-level_PLANE2_FL1__55)
(considered_not__fuel-level_PLANE2_FL0__56_56)
(considered__at_PLANE5_CITY7__57)
(considered__fuel-level_PLANE5_FL0__58)
(considered_not__fuel-level_PLANE5_FL1__59_59)
(considered__at_PERSON4_CITY7__60)
(considered__at_PLANE4_CITY2__61)
(considered__fuel-level_PLANE4_FL0__62)
(considered_not__fuel-level_PLANE4_FL1__63_63)
(considered__at_PERSON3_CITY2__64)
(considered__at_PLANE2_CITY5__65)
(considered__fuel-level_PLANE2_FL0__66)
(considered_not__fuel-level_PLANE2_FL1__67_67)
(considered__at_PERSON7_CITY5__68)

(at ?x - locatable ?c - city)
(next ?l1 - flevel ?l2 - flevel)
(fuel-level ?agent - aircraft ?l - flevel)
(in ?p - person ?agent - aircraft)
(K-obj ?ag - superduperagent ?obj - superduperobject)
(K-pred ?ag - superduperagent ?pr - superduperpred)
(K-ag-pred ?ag - superduperagent ?pr - superduperpred)
)
(:durative-action board
:parameters (?a - aircraft ?p - person ?c - city)
:duration (= ?duration 20)
:condition (and
(at start(at ?p ?c ))
(over all(at ?a ?c ))
(at start(K-ag-pred ?a pred--at))
(at start(K-ag-pred ?a pred--in))
(at start(K-pred ?a pred--at))
(at start(K-obj ?a ?p))
(at start(K-obj ?a ?c))
)
:effect (and (at start (increase (total-cost) 10))
(at end(in ?p ?a ))
(at start(not (at ?p ?c )))
)
)
(:durative-action debark
:parameters (?a - aircraft ?p - person ?c - city)
:duration (= ?duration 30)
:condition (and
(at start(in ?p ?a ))
(over all(at ?a ?c ))
(at start(K-pred ?a pred--at))
(at start(K-ag-pred ?a pred--in))
(at start(K-ag-pred ?a pred--at))
(at start(K-obj ?a ?p))
(at start(K-obj ?a ?c))
)
:effect (and (at start (increase (total-cost) 10))
(at end(at ?p ?c ))
(at start(not (in ?p ?a )))
)
)
(:durative-action fly
:parameters (?a - aircraft ?c1 - city ?c2 - city ?l1 - flevel ?l2 - flevel)
:duration (= ?duration 180)
:condition (and
(at start(at ?a ?c1 ))
(at start(fuel-level ?a ?l1 ))
(at start(next ?l2 ?l1 ))
(at start(K-pred ?a pred--next))
(at start(K-ag-pred ?a pred--at))
(at start(K-ag-pred ?a pred--fuel-level))
(at start(K-obj ?a ?c1))
(at start(K-obj ?a ?c2))
(at start(K-obj ?a ?l1))
(at start(K-obj ?a ?l2))
)
:effect (and (at start (increase (total-cost) 10))
(at end(at ?a ?c2 ))
(at end(fuel-level ?a ?l2 ))
(at start(not (at ?a ?c1 )))
(at end(not (fuel-level ?a ?l1 )))
)
)
(:durative-action zoom
:parameters (?a - aircraft ?c1 - city ?c2 - city ?l1 - flevel ?l2 - flevel ?l3 - flevel)
:duration (= ?duration 100)
:condition (and
(at start(at ?a ?c1 ))
(at start(fuel-level ?a ?l1 ))
(at start(next ?l2 ?l1 ))
(at start(next ?l3 ?l2 ))
(at start(K-pred ?a pred--next))
(at start(K-ag-pred ?a pred--at))
(at start(K-ag-pred ?a pred--fuel-level))
(at start(K-obj ?a ?c1))
(at start(K-obj ?a ?c2))
(at start(K-obj ?a ?l1))
(at start(K-obj ?a ?l2))
(at start(K-obj ?a ?l3))
)
:effect (and (at start (increase (total-cost) 10))
(at end(at ?a ?c2 ))
(at end(fuel-level ?a ?l3 ))
(at start(not (at ?a ?c1 )))
(at end(not (fuel-level ?a ?l1 )))
)
)
(:durative-action refuel
:parameters (?a - aircraft ?c - city ?l - flevel ?l1 - flevel)
:duration (= ?duration 73)
:condition (and
(at start(fuel-level ?a ?l ))
(at start(next ?l ?l1 ))
(over all(at ?a ?c ))
(at start(K-pred ?a pred--next))
(at start(K-ag-pred ?a pred--at))
(at start(K-ag-pred ?a pred--fuel-level))
(at start(K-obj ?a ?c))
(at start(K-obj ?a ?l))
(at start(K-obj ?a ?l1))
)
:effect (and (at start (increase (total-cost) 10))
(at end(fuel-level ?a ?l1 ))
(at end(not (fuel-level ?a ?l )))
)
)

(:durative-action hidden-explain-obs-_in_PERSON9_PLANE3__0
     :parameters ()

     :duration (= ?duration 0.0000001)
     :condition (and  (at start (not (freeze))) (at start (considered_occur_init)) (over all ( in PERSON9 PLANE3 )))
     :effect (and (at start (not  (considered_occur_init))) (at end (considered__in_PERSON9_PLANE3__0)) (at start (increase (total-cost) 1))))  

(:durative-action hidden-explain-obs-_in_PERSON4_PLANE5__1
     :parameters ()

     :duration (= ?duration 0.0000001)
     :condition (and (at start (not (freeze))) ( at start (considered__in_PERSON9_PLANE3__0) ) (over all ( in PERSON4 PLANE5 ) ))
     :effect (and (at start (not (considered__in_PERSON9_PLANE3__0)) ) (at end (considered__in_PERSON4_PLANE5__1)) (at start (increase (total-cost) 1))))  

(:durative-action hidden-explain-obs-_at_PLANE2_CITY0__2
     :parameters ()

     :duration (= ?duration 0.0000001)
     :condition (and (at start (not (freeze))) ( at start (considered__in_PERSON4_PLANE5__1) ) (over all ( at PLANE2 CITY0 ) ))
     :effect (and (at start (not (considered__in_PERSON4_PLANE5__1)) ) (at end (considered__at_PLANE2_CITY0__2)) (at start (increase (total-cost) 1))))  

(:durative-action hidden-explain-obs-_fuel-level_PLANE2_FL4__3
     :parameters ()

     :duration (= ?duration 0.0000001)
     :condition (and (at start (not (freeze))) ( at start (considered__at_PLANE2_CITY0__2) ) (over all ( fuel-level PLANE2 FL4 ) ))
     :effect (and (at start (not (considered__at_PLANE2_CITY0__2)) ) (at end (considered__fuel-level_PLANE2_FL4__3)) (at start (increase (total-cost) 1))))  

(:durative-action hidden-explain-obs-not__fuel-level_PLANE2_FL6__4_4
     :parameters ()

     :duration (= ?duration 0.0000001)
     :condition (and (at start (not (freeze))) ( at start (considered__fuel-level_PLANE2_FL4__3) ) (over all (not ( fuel-level PLANE2 FL6 )) ))
     :effect (and (at start (not (considered__fuel-level_PLANE2_FL4__3)) ) (at end (considered_not__fuel-level_PLANE2_FL6__4_4)) (at start (increase (total-cost) 1))))  

(:durative-action hidden-explain-obs-_at_PLANE1_CITY6__5
     :parameters ()

     :duration (= ?duration 0.0000001)
     :condition (and (at start (not (freeze))) ( at start (considered_not__fuel-level_PLANE2_FL6__4_4) ) (over all ( at PLANE1 CITY6 ) ))
     :effect (and (at start (not (considered_not__fuel-level_PLANE2_FL6__4_4)) ) (at end (considered__at_PLANE1_CITY6__5)) (at start (increase (total-cost) 1))))  

(:durative-action hidden-explain-obs-_fuel-level_PLANE1_FL0__6
     :parameters ()

     :duration (= ?duration 0.0000001)
     :condition (and (at start (not (freeze))) ( at start (considered__at_PLANE1_CITY6__5) ) (over all ( fuel-level PLANE1 FL0 ) ))
     :effect (and (at start (not (considered__at_PLANE1_CITY6__5)) ) (at end (considered__fuel-level_PLANE1_FL0__6)) (at start (increase (total-cost) 1))))  

(:durative-action hidden-explain-obs-not__fuel-level_PLANE1_FL2__7_7
     :parameters ()

     :duration (= ?duration 0.0000001)
     :condition (and (at start (not (freeze))) ( at start (considered__fuel-level_PLANE1_FL0__6) ) (over all (not ( fuel-level PLANE1 FL2 )) ))
     :effect (and (at start (not (considered__fuel-level_PLANE1_FL0__6)) ) (at end (considered_not__fuel-level_PLANE1_FL2__7_7)) (at start (increase (total-cost) 1))))  

(:durative-action hidden-explain-obs-_in_PERSON6_PLANE2__8
     :parameters ()

     :duration (= ?duration 0.0000001)
     :condition (and (at start (not (freeze))) ( at start (considered_not__fuel-level_PLANE1_FL2__7_7) ) (over all ( in PERSON6 PLANE2 ) ))
     :effect (and (at start (not (considered_not__fuel-level_PLANE1_FL2__7_7)) ) (at end (considered__in_PERSON6_PLANE2__8)) (at start (increase (total-cost) 1))))  

(:durative-action hidden-explain-obs-_in_PERSON8_PLANE1__9
     :parameters ()

     :duration (= ?duration 0.0000001)
     :condition (and (at start (not (freeze))) ( at start (considered__in_PERSON6_PLANE2__8) ) (over all ( in PERSON8 PLANE1 ) ))
     :effect (and (at start (not (considered__in_PERSON6_PLANE2__8)) ) (at end (considered__in_PERSON8_PLANE1__9)) (at start (increase (total-cost) 1))))  

(:durative-action hidden-explain-obs-_at_PLANE3_CITY1__10
     :parameters ()

     :duration (= ?duration 0.0000001)
     :condition (and (at start (not (freeze))) ( at start (considered__in_PERSON8_PLANE1__9) ) (over all ( at PLANE3 CITY1 ) ))
     :effect (and (at start (not (considered__in_PERSON8_PLANE1__9)) ) (at end (considered__at_PLANE3_CITY1__10)) (at start (increase (total-cost) 1))))  

(:durative-action hidden-explain-obs-_in_PERSON5_PLANE1__11
     :parameters ()

     :duration (= ?duration 0.0000001)
     :condition (and (at start (not (freeze))) ( at start (considered__at_PLANE3_CITY1__10) ) (over all ( in PERSON5 PLANE1 ) ))
     :effect (and (at start (not (considered__at_PLANE3_CITY1__10)) ) (at end (considered__in_PERSON5_PLANE1__11)) (at start (increase (total-cost) 1))))  

(:durative-action hidden-explain-obs-_fuel-level_PLANE3_FL4__12
     :parameters ()

     :duration (= ?duration 0.0000001)
     :condition (and (at start (not (freeze))) ( at start (considered__in_PERSON5_PLANE1__11) ) (over all ( fuel-level PLANE3 FL4 ) ))
     :effect (and (at start (not (considered__in_PERSON5_PLANE1__11)) ) (at end (considered__fuel-level_PLANE3_FL4__12)) (at start (increase (total-cost) 1))))  

(:durative-action hidden-explain-obs-not__fuel-level_PLANE3_FL6__13_13
     :parameters ()

     :duration (= ?duration 0.0000001)
     :condition (and (at start (not (freeze))) ( at start (considered__fuel-level_PLANE3_FL4__12) ) (over all (not ( fuel-level PLANE3 FL6 )) ))
     :effect (and (at start (not (considered__fuel-level_PLANE3_FL4__12)) ) (at end (considered_not__fuel-level_PLANE3_FL6__13_13)) (at start (increase (total-cost) 1))))  

(:durative-action hidden-explain-obs-_at_PLANE5_CITY7__14
     :parameters ()

     :duration (= ?duration 0.0000001)
     :condition (and (at start (not (freeze))) ( at start (considered_not__fuel-level_PLANE3_FL6__13_13) ) (over all ( at PLANE5 CITY7 ) ))
     :effect (and (at start (not (considered_not__fuel-level_PLANE3_FL6__13_13)) ) (at end (considered__at_PLANE5_CITY7__14)) (at start (increase (total-cost) 1))))  

(:durative-action hidden-explain-obs-_fuel-level_PLANE5_FL2__15
     :parameters ()

     :duration (= ?duration 0.0000001)
     :condition (and (at start (not (freeze))) ( at start (considered__at_PLANE5_CITY7__14) ) (over all ( fuel-level PLANE5 FL2 ) ))
     :effect (and (at start (not (considered__at_PLANE5_CITY7__14)) ) (at end (considered__fuel-level_PLANE5_FL2__15)) (at start (increase (total-cost) 1))))  

(:durative-action hidden-explain-obs-not__fuel-level_PLANE5_FL4__16_16
     :parameters ()

     :duration (= ?duration 0.0000001)
     :condition (and (at start (not (freeze))) ( at start (considered__fuel-level_PLANE5_FL2__15) ) (over all (not ( fuel-level PLANE5 FL4 )) ))
     :effect (and (at start (not (considered__fuel-level_PLANE5_FL2__15)) ) (at end (considered_not__fuel-level_PLANE5_FL4__16_16)) (at start (increase (total-cost) 1))))  

(:durative-action hidden-explain-obs-_in_PERSON2_PLANE3__17
     :parameters ()

     :duration (= ?duration 0.0000001)
     :condition (and (at start (not (freeze))) ( at start (considered_not__fuel-level_PLANE5_FL4__16_16) ) (over all ( in PERSON2 PLANE3 ) ))
     :effect (and (at start (not (considered_not__fuel-level_PLANE5_FL4__16_16)) ) (at end (considered__in_PERSON2_PLANE3__17)) (at start (increase (total-cost) 1))))  

(:durative-action hidden-explain-obs-_in_PERSON10_PLANE5__18
     :parameters ()

     :duration (= ?duration 0.0000001)
     :condition (and (at start (not (freeze))) ( at start (considered__in_PERSON2_PLANE3__17) ) (over all ( in PERSON10 PLANE5 ) ))
     :effect (and (at start (not (considered__in_PERSON2_PLANE3__17)) ) (at end (considered__in_PERSON10_PLANE5__18)) (at start (increase (total-cost) 1))))  

(:durative-action hidden-explain-obs-_fuel-level_PLANE1_FL1__19
     :parameters ()

     :duration (= ?duration 0.0000001)
     :condition (and (at start (not (freeze))) ( at start (considered__in_PERSON10_PLANE5__18) ) (over all ( fuel-level PLANE1 FL1 ) ))
     :effect (and (at start (not (considered__in_PERSON10_PLANE5__18)) ) (at end (considered__fuel-level_PLANE1_FL1__19)) (at start (increase (total-cost) 1))))  

(:durative-action hidden-explain-obs-not__fuel-level_PLANE1_FL0__20_20
     :parameters ()

     :duration (= ?duration 0.0000001)
     :condition (and (at start (not (freeze))) ( at start (considered__fuel-level_PLANE1_FL1__19) ) (over all (not ( fuel-level PLANE1 FL0 )) ))
     :effect (and (at start (not (considered__fuel-level_PLANE1_FL1__19)) ) (at end (considered_not__fuel-level_PLANE1_FL0__20_20)) (at start (increase (total-cost) 1))))  

(:durative-action hidden-explain-obs-_at_PLANE4_CITY4__21
     :parameters ()

     :duration (= ?duration 0.0000001)
     :condition (and (at start (not (freeze))) ( at start (considered_not__fuel-level_PLANE1_FL0__20_20) ) (over all ( at PLANE4 CITY4 ) ))
     :effect (and (at start (not (considered_not__fuel-level_PLANE1_FL0__20_20)) ) (at end (considered__at_PLANE4_CITY4__21)) (at start (increase (total-cost) 1))))  

(:durative-action hidden-explain-obs-_fuel-level_PLANE4_FL2__22
     :parameters ()

     :duration (= ?duration 0.0000001)
     :condition (and (at start (not (freeze))) ( at start (considered__at_PLANE4_CITY4__21) ) (over all ( fuel-level PLANE4 FL2 ) ))
     :effect (and (at start (not (considered__at_PLANE4_CITY4__21)) ) (at end (considered__fuel-level_PLANE4_FL2__22)) (at start (increase (total-cost) 1))))  

(:durative-action hidden-explain-obs-not__fuel-level_PLANE4_FL3__23_23
     :parameters ()

     :duration (= ?duration 0.0000001)
     :condition (and (at start (not (freeze))) ( at start (considered__fuel-level_PLANE4_FL2__22) ) (over all (not ( fuel-level PLANE4 FL3 )) ))
     :effect (and (at start (not (considered__fuel-level_PLANE4_FL2__22)) ) (at end (considered_not__fuel-level_PLANE4_FL3__23_23)) (at start (increase (total-cost) 1))))  

(:durative-action hidden-explain-obs-_at_PLANE2_CITY6__24
     :parameters ()

     :duration (= ?duration 0.0000001)
     :condition (and (at start (not (freeze))) ( at start (considered_not__fuel-level_PLANE4_FL3__23_23) ) (over all ( at PLANE2 CITY6 ) ))
     :effect (and (at start (not (considered_not__fuel-level_PLANE4_FL3__23_23)) ) (at end (considered__at_PLANE2_CITY6__24)) (at start (increase (total-cost) 1))))  

(:durative-action hidden-explain-obs-_fuel-level_PLANE2_FL2__25
     :parameters ()

     :duration (= ?duration 0.0000001)
     :condition (and (at start (not (freeze))) ( at start (considered__at_PLANE2_CITY6__24) ) (over all ( fuel-level PLANE2 FL2 ) ))
     :effect (and (at start (not (considered__at_PLANE2_CITY6__24)) ) (at end (considered__fuel-level_PLANE2_FL2__25)) (at start (increase (total-cost) 1))))  

(:durative-action hidden-explain-obs-not__fuel-level_PLANE2_FL4__26_26
     :parameters ()

     :duration (= ?duration 0.0000001)
     :condition (and (at start (not (freeze))) ( at start (considered__fuel-level_PLANE2_FL2__25) ) (over all (not ( fuel-level PLANE2 FL4 )) ))
     :effect (and (at start (not (considered__fuel-level_PLANE2_FL2__25)) ) (at end (considered_not__fuel-level_PLANE2_FL4__26_26)) (at start (increase (total-cost) 1))))  

(:durative-action hidden-explain-obs-_at_PLANE3_CITY8__27
     :parameters ()

     :duration (= ?duration 0.0000001)
     :condition (and (at start (not (freeze))) ( at start (considered_not__fuel-level_PLANE2_FL4__26_26) ) (over all ( at PLANE3 CITY8 ) ))
     :effect (and (at start (not (considered_not__fuel-level_PLANE2_FL4__26_26)) ) (at end (considered__at_PLANE3_CITY8__27)) (at start (increase (total-cost) 1))))  

(:durative-action hidden-explain-obs-_fuel-level_PLANE3_FL2__28
     :parameters ()

     :duration (= ?duration 0.0000001)
     :condition (and (at start (not (freeze))) ( at start (considered__at_PLANE3_CITY8__27) ) (over all ( fuel-level PLANE3 FL2 ) ))
     :effect (and (at start (not (considered__at_PLANE3_CITY8__27)) ) (at end (considered__fuel-level_PLANE3_FL2__28)) (at start (increase (total-cost) 1))))  

(:durative-action hidden-explain-obs-not__fuel-level_PLANE3_FL4__29_29
     :parameters ()

     :duration (= ?duration 0.0000001)
     :condition (and (at start (not (freeze))) ( at start (considered__fuel-level_PLANE3_FL2__28) ) (over all (not ( fuel-level PLANE3 FL4 )) ))
     :effect (and (at start (not (considered__fuel-level_PLANE3_FL2__28)) ) (at end (considered_not__fuel-level_PLANE3_FL4__29_29)) (at start (increase (total-cost) 1))))  

(:durative-action hidden-explain-obs-_at_PLANE5_CITY9__30
     :parameters ()

     :duration (= ?duration 0.0000001)
     :condition (and (at start (not (freeze))) ( at start (considered_not__fuel-level_PLANE3_FL4__29_29) ) (over all ( at PLANE5 CITY9 ) ))
     :effect (and (at start (not (considered_not__fuel-level_PLANE3_FL4__29_29)) ) (at end (considered__at_PLANE5_CITY9__30)) (at start (increase (total-cost) 1))))  

(:durative-action hidden-explain-obs-_fuel-level_PLANE5_FL0__31
     :parameters ()

     :duration (= ?duration 0.0000001)
     :condition (and (at start (not (freeze))) ( at start (considered__at_PLANE5_CITY9__30) ) (over all ( fuel-level PLANE5 FL0 ) ))
     :effect (and (at start (not (considered__at_PLANE5_CITY9__30)) ) (at end (considered__fuel-level_PLANE5_FL0__31)) (at start (increase (total-cost) 1))))  

(:durative-action hidden-explain-obs-not__fuel-level_PLANE5_FL2__32_32
     :parameters ()

     :duration (= ?duration 0.0000001)
     :condition (and (at start (not (freeze))) ( at start (considered__fuel-level_PLANE5_FL0__31) ) (over all (not ( fuel-level PLANE5 FL2 )) ))
     :effect (and (at start (not (considered__fuel-level_PLANE5_FL0__31)) ) (at end (considered_not__fuel-level_PLANE5_FL2__32_32)) (at start (increase (total-cost) 1))))  

(:durative-action hidden-explain-obs-_at_PERSON6_CITY6__33
     :parameters ()

     :duration (= ?duration 0.0000001)
     :condition (and (at start (not (freeze))) ( at start (considered_not__fuel-level_PLANE5_FL2__32_32) ) (over all ( at PERSON6 CITY6 ) ))
     :effect (and (at start (not (considered_not__fuel-level_PLANE5_FL2__32_32)) ) (at end (considered__at_PERSON6_CITY6__33)) (at start (increase (total-cost) 1))))  

(:durative-action hidden-explain-obs-_at_PERSON2_CITY8__34
     :parameters ()

     :duration (= ?duration 0.0000001)
     :condition (and (at start (not (freeze))) ( at start (considered__at_PERSON6_CITY6__33) ) (over all ( at PERSON2 CITY8 ) ))
     :effect (and (at start (not (considered__at_PERSON6_CITY6__33)) ) (at end (considered__at_PERSON2_CITY8__34)) (at start (increase (total-cost) 1))))  

(:durative-action hidden-explain-obs-_at_PERSON10_CITY9__35
     :parameters ()

     :duration (= ?duration 0.0000001)
     :condition (and (at start (not (freeze))) ( at start (considered__at_PERSON2_CITY8__34) ) (over all ( at PERSON10 CITY9 ) ))
     :effect (and (at start (not (considered__at_PERSON2_CITY8__34)) ) (at end (considered__at_PERSON10_CITY9__35)) (at start (increase (total-cost) 1))))  

(:durative-action hidden-explain-obs-_fuel-level_PLANE5_FL1__36
     :parameters ()

     :duration (= ?duration 0.0000001)
     :condition (and (at start (not (freeze))) ( at start (considered__at_PERSON10_CITY9__35) ) (over all ( fuel-level PLANE5 FL1 ) ))
     :effect (and (at start (not (considered__at_PERSON10_CITY9__35)) ) (at end (considered__fuel-level_PLANE5_FL1__36)) (at start (increase (total-cost) 1))))  

(:durative-action hidden-explain-obs-not__fuel-level_PLANE5_FL0__37_37
     :parameters ()

     :duration (= ?duration 0.0000001)
     :condition (and (at start (not (freeze))) ( at start (considered__fuel-level_PLANE5_FL1__36) ) (over all (not ( fuel-level PLANE5 FL0 )) ))
     :effect (and (at start (not (considered__fuel-level_PLANE5_FL1__36)) ) (at end (considered_not__fuel-level_PLANE5_FL0__37_37)) (at start (increase (total-cost) 1))))  

(:durative-action hidden-explain-obs-_at_PLANE2_CITY7__38
     :parameters ()

     :duration (= ?duration 0.0000001)
     :condition (and (at start (not (freeze))) ( at start (considered_not__fuel-level_PLANE5_FL0__37_37) ) (over all ( at PLANE2 CITY7 ) ))
     :effect (and (at start (not (considered_not__fuel-level_PLANE5_FL0__37_37)) ) (at end (considered__at_PLANE2_CITY7__38)) (at start (increase (total-cost) 1))))  

(:durative-action hidden-explain-obs-_fuel-level_PLANE2_FL0__39
     :parameters ()

     :duration (= ?duration 0.0000001)
     :condition (and (at start (not (freeze))) ( at start (considered__at_PLANE2_CITY7__38) ) (over all ( fuel-level PLANE2 FL0 ) ))
     :effect (and (at start (not (considered__at_PLANE2_CITY7__38)) ) (at end (considered__fuel-level_PLANE2_FL0__39)) (at start (increase (total-cost) 1))))  

(:durative-action hidden-explain-obs-not__fuel-level_PLANE2_FL2__40_40
     :parameters ()

     :duration (= ?duration 0.0000001)
     :condition (and (at start (not (freeze))) ( at start (considered__fuel-level_PLANE2_FL0__39) ) (over all (not ( fuel-level PLANE2 FL2 )) ))
     :effect (and (at start (not (considered__fuel-level_PLANE2_FL0__39)) ) (at end (considered_not__fuel-level_PLANE2_FL2__40_40)) (at start (increase (total-cost) 1))))  

(:durative-action hidden-explain-obs-_at_PLANE1_CITY1__41
     :parameters ()

     :duration (= ?duration 0.0000001)
     :condition (and (at start (not (freeze))) ( at start (considered_not__fuel-level_PLANE2_FL2__40_40) ) (over all ( at PLANE1 CITY1 ) ))
     :effect (and (at start (not (considered_not__fuel-level_PLANE2_FL2__40_40)) ) (at end (considered__at_PLANE1_CITY1__41)) (at start (increase (total-cost) 1))))  

(:durative-action hidden-explain-obs-_fuel-level_PLANE1_FL0__42
     :parameters ()

     :duration (= ?duration 0.0000001)
     :condition (and (at start (not (freeze))) ( at start (considered__at_PLANE1_CITY1__41) ) (over all ( fuel-level PLANE1 FL0 ) ))
     :effect (and (at start (not (considered__at_PLANE1_CITY1__41)) ) (at end (considered__fuel-level_PLANE1_FL0__42)) (at start (increase (total-cost) 1))))  

(:durative-action hidden-explain-obs-not__fuel-level_PLANE1_FL1__43_43
     :parameters ()

     :duration (= ?duration 0.0000001)
     :condition (and (at start (not (freeze))) ( at start (considered__fuel-level_PLANE1_FL0__42) ) (over all (not ( fuel-level PLANE1 FL1 )) ))
     :effect (and (at start (not (considered__fuel-level_PLANE1_FL0__42)) ) (at end (considered_not__fuel-level_PLANE1_FL1__43_43)) (at start (increase (total-cost) 1))))  

(:durative-action hidden-explain-obs-_at_PLANE4_CITY0__44
     :parameters ()

     :duration (= ?duration 0.0000001)
     :condition (and (at start (not (freeze))) ( at start (considered_not__fuel-level_PLANE1_FL1__43_43) ) (over all ( at PLANE4 CITY0 ) ))
     :effect (and (at start (not (considered_not__fuel-level_PLANE1_FL1__43_43)) ) (at end (considered__at_PLANE4_CITY0__44)) (at start (increase (total-cost) 1))))  

(:durative-action hidden-explain-obs-_fuel-level_PLANE4_FL1__45
     :parameters ()

     :duration (= ?duration 0.0000001)
     :condition (and (at start (not (freeze))) ( at start (considered__at_PLANE4_CITY0__44) ) (over all ( fuel-level PLANE4 FL1 ) ))
     :effect (and (at start (not (considered__at_PLANE4_CITY0__44)) ) (at end (considered__fuel-level_PLANE4_FL1__45)) (at start (increase (total-cost) 1))))  

(:durative-action hidden-explain-obs-not__fuel-level_PLANE4_FL2__46_46
     :parameters ()

     :duration (= ?duration 0.0000001)
     :condition (and (at start (not (freeze))) ( at start (considered__fuel-level_PLANE4_FL1__45) ) (over all (not ( fuel-level PLANE4 FL2 )) ))
     :effect (and (at start (not (considered__fuel-level_PLANE4_FL1__45)) ) (at end (considered_not__fuel-level_PLANE4_FL2__46_46)) (at start (increase (total-cost) 1))))  

(:durative-action hidden-explain-obs-_in_PERSON7_PLANE2__47
     :parameters ()

     :duration (= ?duration 0.0000001)
     :condition (and (at start (not (freeze))) ( at start (considered_not__fuel-level_PLANE4_FL2__46_46) ) (over all ( in PERSON7 PLANE2 ) ))
     :effect (and (at start (not (considered_not__fuel-level_PLANE4_FL2__46_46)) ) (at end (considered__in_PERSON7_PLANE2__47)) (at start (increase (total-cost) 1))))  

(:durative-action hidden-explain-obs-_at_PLANE3_CITY5__48
     :parameters ()

     :duration (= ?duration 0.0000001)
     :condition (and (at start (not (freeze))) ( at start (considered__in_PERSON7_PLANE2__47) ) (over all ( at PLANE3 CITY5 ) ))
     :effect (and (at start (not (considered__in_PERSON7_PLANE2__47)) ) (at end (considered__at_PLANE3_CITY5__48)) (at start (increase (total-cost) 1))))  

(:durative-action hidden-explain-obs-_fuel-level_PLANE3_FL0__49
     :parameters ()

     :duration (= ?duration 0.0000001)
     :condition (and (at start (not (freeze))) ( at start (considered__at_PLANE3_CITY5__48) ) (over all ( fuel-level PLANE3 FL0 ) ))
     :effect (and (at start (not (considered__at_PLANE3_CITY5__48)) ) (at end (considered__fuel-level_PLANE3_FL0__49)) (at start (increase (total-cost) 1))))  

(:durative-action hidden-explain-obs-not__fuel-level_PLANE3_FL2__50_50
     :parameters ()

     :duration (= ?duration 0.0000001)
     :condition (and (at start (not (freeze))) ( at start (considered__fuel-level_PLANE3_FL0__49) ) (over all (not ( fuel-level PLANE3 FL2 )) ))
     :effect (and (at start (not (considered__fuel-level_PLANE3_FL0__49)) ) (at end (considered_not__fuel-level_PLANE3_FL2__50_50)) (at start (increase (total-cost) 1))))  

(:durative-action hidden-explain-obs-_in_PERSON3_PLANE4__51
     :parameters ()

     :duration (= ?duration 0.0000001)
     :condition (and (at start (not (freeze))) ( at start (considered_not__fuel-level_PLANE3_FL2__50_50) ) (over all ( in PERSON3 PLANE4 ) ))
     :effect (and (at start (not (considered_not__fuel-level_PLANE3_FL2__50_50)) ) (at end (considered__in_PERSON3_PLANE4__51)) (at start (increase (total-cost) 1))))  

(:durative-action hidden-explain-obs-_at_PERSON5_CITY1__52
     :parameters ()

     :duration (= ?duration 0.0000001)
     :condition (and (at start (not (freeze))) ( at start (considered__in_PERSON3_PLANE4__51) ) (over all ( at PERSON5 CITY1 ) ))
     :effect (and (at start (not (considered__in_PERSON3_PLANE4__51)) ) (at end (considered__at_PERSON5_CITY1__52)) (at start (increase (total-cost) 1))))  

(:durative-action hidden-explain-obs-_at_PERSON8_CITY1__53
     :parameters ()

     :duration (= ?duration 0.0000001)
     :condition (and (at start (not (freeze))) ( at start (considered__at_PERSON5_CITY1__52) ) (over all ( at PERSON8 CITY1 ) ))
     :effect (and (at start (not (considered__at_PERSON5_CITY1__52)) ) (at end (considered__at_PERSON8_CITY1__53)) (at start (increase (total-cost) 1))))  

(:durative-action hidden-explain-obs-_at_PERSON9_CITY5__54
     :parameters ()

     :duration (= ?duration 0.0000001)
     :condition (and (at start (not (freeze))) ( at start (considered__at_PERSON8_CITY1__53) ) (over all ( at PERSON9 CITY5 ) ))
     :effect (and (at start (not (considered__at_PERSON8_CITY1__53)) ) (at end (considered__at_PERSON9_CITY5__54)) (at start (increase (total-cost) 1))))  

(:durative-action hidden-explain-obs-_fuel-level_PLANE2_FL1__55
     :parameters ()

     :duration (= ?duration 0.0000001)
     :condition (and (at start (not (freeze))) ( at start (considered__at_PERSON9_CITY5__54) ) (over all ( fuel-level PLANE2 FL1 ) ))
     :effect (and (at start (not (considered__at_PERSON9_CITY5__54)) ) (at end (considered__fuel-level_PLANE2_FL1__55)) (at start (increase (total-cost) 1))))  

(:durative-action hidden-explain-obs-not__fuel-level_PLANE2_FL0__56_56
     :parameters ()

     :duration (= ?duration 0.0000001)
     :condition (and (at start (not (freeze))) ( at start (considered__fuel-level_PLANE2_FL1__55) ) (over all (not ( fuel-level PLANE2 FL0 )) ))
     :effect (and (at start (not (considered__fuel-level_PLANE2_FL1__55)) ) (at end (considered_not__fuel-level_PLANE2_FL0__56_56)) (at start (increase (total-cost) 1))))  

(:durative-action hidden-explain-obs-_at_PLANE5_CITY7__57
     :parameters ()

     :duration (= ?duration 0.0000001)
     :condition (and (at start (not (freeze))) ( at start (considered_not__fuel-level_PLANE2_FL0__56_56) ) (over all ( at PLANE5 CITY7 ) ))
     :effect (and (at start (not (considered_not__fuel-level_PLANE2_FL0__56_56)) ) (at end (considered__at_PLANE5_CITY7__57)) (at start (increase (total-cost) 1))))  

(:durative-action hidden-explain-obs-_fuel-level_PLANE5_FL0__58
     :parameters ()

     :duration (= ?duration 0.0000001)
     :condition (and (at start (not (freeze))) ( at start (considered__at_PLANE5_CITY7__57) ) (over all ( fuel-level PLANE5 FL0 ) ))
     :effect (and (at start (not (considered__at_PLANE5_CITY7__57)) ) (at end (considered__fuel-level_PLANE5_FL0__58)) (at start (increase (total-cost) 1))))  

(:durative-action hidden-explain-obs-not__fuel-level_PLANE5_FL1__59_59
     :parameters ()

     :duration (= ?duration 0.0000001)
     :condition (and (at start (not (freeze))) ( at start (considered__fuel-level_PLANE5_FL0__58) ) (over all (not ( fuel-level PLANE5 FL1 )) ))
     :effect (and (at start (not (considered__fuel-level_PLANE5_FL0__58)) ) (at end (considered_not__fuel-level_PLANE5_FL1__59_59)) (at start (increase (total-cost) 1))))  

(:durative-action hidden-explain-obs-_at_PERSON4_CITY7__60
     :parameters ()

     :duration (= ?duration 0.0000001)
     :condition (and (at start (not (freeze))) ( at start (considered_not__fuel-level_PLANE5_FL1__59_59) ) (over all ( at PERSON4 CITY7 ) ))
     :effect (and (at start (not (considered_not__fuel-level_PLANE5_FL1__59_59)) ) (at end (considered__at_PERSON4_CITY7__60)) (at start (increase (total-cost) 1))))  

(:durative-action hidden-explain-obs-_at_PLANE4_CITY2__61
     :parameters ()

     :duration (= ?duration 0.0000001)
     :condition (and (at start (not (freeze))) ( at start (considered__at_PERSON4_CITY7__60) ) (over all ( at PLANE4 CITY2 ) ))
     :effect (and (at start (not (considered__at_PERSON4_CITY7__60)) ) (at end (considered__at_PLANE4_CITY2__61)) (at start (increase (total-cost) 1))))  

(:durative-action hidden-explain-obs-_fuel-level_PLANE4_FL0__62
     :parameters ()

     :duration (= ?duration 0.0000001)
     :condition (and (at start (not (freeze))) ( at start (considered__at_PLANE4_CITY2__61) ) (over all ( fuel-level PLANE4 FL0 ) ))
     :effect (and (at start (not (considered__at_PLANE4_CITY2__61)) ) (at end (considered__fuel-level_PLANE4_FL0__62)) (at start (increase (total-cost) 1))))  

(:durative-action hidden-explain-obs-not__fuel-level_PLANE4_FL1__63_63
     :parameters ()

     :duration (= ?duration 0.0000001)
     :condition (and (at start (not (freeze))) ( at start (considered__fuel-level_PLANE4_FL0__62) ) (over all (not ( fuel-level PLANE4 FL1 )) ))
     :effect (and (at start (not (considered__fuel-level_PLANE4_FL0__62)) ) (at end (considered_not__fuel-level_PLANE4_FL1__63_63)) (at start (increase (total-cost) 1))))  

(:durative-action hidden-explain-obs-_at_PERSON3_CITY2__64
     :parameters ()

     :duration (= ?duration 0.0000001)
     :condition (and (at start (not (freeze))) ( at start (considered_not__fuel-level_PLANE4_FL1__63_63) ) (over all ( at PERSON3 CITY2 ) ))
     :effect (and (at start (not (considered_not__fuel-level_PLANE4_FL1__63_63)) ) (at end (considered__at_PERSON3_CITY2__64)) (at start (increase (total-cost) 1))))  

(:durative-action hidden-explain-obs-_at_PLANE2_CITY5__65
     :parameters ()

     :duration (= ?duration 0.0000001)
     :condition (and (at start (not (freeze))) ( at start (considered__at_PERSON3_CITY2__64) ) (over all ( at PLANE2 CITY5 ) ))
     :effect (and (at start (not (considered__at_PERSON3_CITY2__64)) ) (at end (considered__at_PLANE2_CITY5__65)) (at start (increase (total-cost) 1))))  

(:durative-action hidden-explain-obs-_fuel-level_PLANE2_FL0__66
     :parameters ()

     :duration (= ?duration 0.0000001)
     :condition (and (at start (not (freeze))) ( at start (considered__at_PLANE2_CITY5__65) ) (over all ( fuel-level PLANE2 FL0 ) ))
     :effect (and (at start (not (considered__at_PLANE2_CITY5__65)) ) (at end (considered__fuel-level_PLANE2_FL0__66)) (at start (increase (total-cost) 1))))  

(:durative-action hidden-explain-obs-not__fuel-level_PLANE2_FL1__67_67
     :parameters ()

     :duration (= ?duration 0.0000001)
     :condition (and (at start (not (freeze))) ( at start (considered__fuel-level_PLANE2_FL0__66) ) (over all (not ( fuel-level PLANE2 FL1 )) ))
     :effect (and (at start (not (considered__fuel-level_PLANE2_FL0__66)) ) (at end (considered_not__fuel-level_PLANE2_FL1__67_67)) (at start (increase (total-cost) 1))))  

(:durative-action hidden-explain-obs-_at_PERSON7_CITY5__68
     :parameters ()

     :duration (= ?duration 0.0000001)
     :condition (and (at start (not (freeze))) ( at start (considered_not__fuel-level_PLANE2_FL1__67_67) ) (over all ( at PERSON7 CITY5 ) ))
     :effect (and (at start (not (considered_not__fuel-level_PLANE2_FL1__67_67)) ) (at end (considered__at_PERSON7_CITY5__68)) (at start (increase (total-cost) 1))))  


 )
