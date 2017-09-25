(define (problem strips-sat-x-1) (:domain satellite)
(:objects
	planet15 - direction
	planet17 - direction
	satellite3 - satellite
	satellite2 - satellite
	satellite1 - satellite
	satellite0 - satellite
	instrument22 - instrument
	satellite4 - satellite
	star14 - direction
	instrument20 - instrument
	star16 - direction
	star10 - direction
	star12 - direction
	thermograph1 - mode
	phenomenon11 - direction
	phenomenon13 - direction
	star19 - direction
	star18 - direction
	instrument24 - instrument
	spectrograph0 - mode
	instrument21 - instrument
	phenomenon8 - direction
	instrument23 - instrument
	instrument3 - instrument
	instrument18 - instrument
	groundstation4 - direction
	instrument0 - instrument
	groundstation0 - direction
	instrument8 - instrument
	instrument9 - instrument
	instrument19 - instrument
	instrument2 - instrument
	planet21 - direction
	planet22 - direction
	instrument1 - instrument
	instrument6 - instrument
	instrument7 - instrument
	instrument4 - instrument
	instrument5 - instrument
	phenomenon7 - direction
	phenomenon5 - direction
	planet9 - direction
	image5 - mode
	image4 - mode
	phenomenon20 - direction
	star23 - direction
	phenomenon24 - direction
	infrared7 - mode
	infrared2 - mode
	infrared3 - mode
	star6 - direction
	star1 - direction
	spectrograph6 - mode
	star3 - direction
	star2 - direction
	instrument14 - instrument
	instrument15 - instrument
	instrument16 - instrument
	instrument17 - instrument
	instrument10 - instrument
	instrument11 - instrument
	instrument12 - instrument
	instrument13 - instrument
)
(:init
	(supports instrument0 infrared2)
	(supports instrument0 image4)
	(calibration_target instrument0 groundstation0)
	(supports instrument1 spectrograph0)
	(calibration_target instrument1 star3)
	(supports instrument2 infrared3)
	(supports instrument2 thermograph1)
	(supports instrument2 spectrograph0)
	(calibration_target instrument2 star1)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(on_board instrument2 satellite0)
	(power_avail satellite0)
	(pointing satellite0 planet21)
	(supports instrument3 thermograph1)
	(supports instrument3 image5)
	(calibration_target instrument3 star1)
	(supports instrument4 spectrograph0)
	(calibration_target instrument4 star3)
	(supports instrument5 thermograph1)
	(supports instrument5 spectrograph0)
	(supports instrument5 spectrograph6)
	(calibration_target instrument5 groundstation4)
	(supports instrument6 image5)
	(supports instrument6 infrared7)
	(calibration_target instrument6 star3)
	(supports instrument7 spectrograph6)
	(supports instrument7 thermograph1)
	(supports instrument7 spectrograph0)
	(calibration_target instrument7 star2)
	(on_board instrument3 satellite1)
	(on_board instrument4 satellite1)
	(on_board instrument5 satellite1)
	(on_board instrument6 satellite1)
	(on_board instrument7 satellite1)
	(power_avail satellite1)
	(pointing satellite1 planet21)
	(supports instrument8 infrared3)
	(supports instrument8 infrared7)
	(calibration_target instrument8 star1)
	(supports instrument9 spectrograph0)
	(calibration_target instrument9 star3)
	(supports instrument10 image4)
	(supports instrument10 infrared7)
	(supports instrument10 image5)
	(calibration_target instrument10 groundstation4)
	(supports instrument11 infrared2)
	(calibration_target instrument11 star2)
	(supports instrument12 thermograph1)
	(calibration_target instrument12 star3)
	(supports instrument13 infrared3)
	(calibration_target instrument13 star2)
	(on_board instrument8 satellite2)
	(on_board instrument9 satellite2)
	(on_board instrument10 satellite2)
	(on_board instrument11 satellite2)
	(on_board instrument12 satellite2)
	(on_board instrument13 satellite2)
	(power_avail satellite2)
	(pointing satellite2 phenomenon5)
	(supports instrument14 thermograph1)
	(supports instrument14 infrared2)
	(calibration_target instrument14 groundstation4)
	(supports instrument15 infrared2)
	(calibration_target instrument15 star1)
	(supports instrument16 image4)
	(supports instrument16 spectrograph6)
	(calibration_target instrument16 star2)
	(supports instrument17 image4)
	(supports instrument17 infrared7)
	(supports instrument17 image5)
	(calibration_target instrument17 groundstation0)
	(supports instrument18 image4)
	(supports instrument18 spectrograph6)
	(calibration_target instrument18 star2)
	(supports instrument19 infrared3)
	(supports instrument19 infrared7)
	(supports instrument19 spectrograph6)
	(calibration_target instrument19 star3)
	(supports instrument20 infrared3)
	(supports instrument20 infrared2)
	(calibration_target instrument20 star2)
	(supports instrument21 infrared2)
	(supports instrument21 thermograph1)
	(calibration_target instrument21 groundstation4)
	(on_board instrument14 satellite3)
	(on_board instrument15 satellite3)
	(on_board instrument16 satellite3)
	(on_board instrument17 satellite3)
	(on_board instrument18 satellite3)
	(on_board instrument19 satellite3)
	(on_board instrument20 satellite3)
	(on_board instrument21 satellite3)
	(power_avail satellite3)
	(pointing satellite3 phenomenon20)
	(supports instrument22 thermograph1)
	(supports instrument22 image5)
	(calibration_target instrument22 star2)
	(supports instrument23 infrared7)
	(supports instrument23 thermograph1)
	(calibration_target instrument23 star3)
	(supports instrument24 infrared3)
	(supports instrument24 spectrograph0)
	(calibration_target instrument24 groundstation0)
	(on_board instrument22 satellite4)
	(on_board instrument23 satellite4)
	(on_board instrument24 satellite4)
	(power_avail satellite4)
	(pointing satellite4 star14)
	(K-obj satellite3 planet15)
	(K-obj satellite3 planet17)
	(K-obj satellite3 star14)
	(K-obj satellite3 star16)
	(K-obj satellite3 star10)
	(K-obj satellite3 star12)
	(K-obj satellite3 thermograph1)
	(K-obj satellite3 phenomenon11)
	(K-obj satellite3 phenomenon13)
	(K-obj satellite3 star19)
	(K-obj satellite3 star18)
	(K-obj satellite3 star6)
	(K-obj satellite3 phenomenon8)
	(K-obj satellite3 groundstation4)
	(K-obj satellite3 groundstation0)
	(K-obj satellite3 planet21)
	(K-obj satellite3 planet22)
	(K-obj satellite3 phenomenon7)
	(K-obj satellite3 phenomenon5)
	(K-obj satellite3 planet9)
	(K-obj satellite3 image5)
	(K-obj satellite3 image4)
	(K-obj satellite3 phenomenon20)
	(K-obj satellite3 star23)
	(K-obj satellite3 phenomenon24)
	(K-obj satellite3 infrared7)
	(K-obj satellite3 infrared2)
	(K-obj satellite3 infrared3)
	(K-obj satellite3 spectrograph0)
	(K-obj satellite3 star1)
	(K-obj satellite3 spectrograph6)
	(K-obj satellite3 star3)
	(K-obj satellite3 star2)
	(K-obj satellite2 planet15)
	(K-obj satellite2 planet17)
	(K-obj satellite2 star14)
	(K-obj satellite2 star16)
	(K-obj satellite2 star10)
	(K-obj satellite2 star12)
	(K-obj satellite2 thermograph1)
	(K-obj satellite2 phenomenon11)
	(K-obj satellite2 phenomenon13)
	(K-obj satellite2 star19)
	(K-obj satellite2 star18)
	(K-obj satellite2 star6)
	(K-obj satellite2 phenomenon8)
	(K-obj satellite2 groundstation4)
	(K-obj satellite2 groundstation0)
	(K-obj satellite2 planet21)
	(K-obj satellite2 planet22)
	(K-obj satellite2 phenomenon7)
	(K-obj satellite2 phenomenon5)
	(K-obj satellite2 planet9)
	(K-obj satellite2 image5)
	(K-obj satellite2 image4)
	(K-obj satellite2 phenomenon20)
	(K-obj satellite2 star23)
	(K-obj satellite2 phenomenon24)
	(K-obj satellite2 infrared7)
	(K-obj satellite2 infrared2)
	(K-obj satellite2 infrared3)
	(K-obj satellite2 spectrograph0)
	(K-obj satellite2 star1)
	(K-obj satellite2 spectrograph6)
	(K-obj satellite2 star3)
	(K-obj satellite2 star2)
	(K-obj satellite1 planet15)
	(K-obj satellite1 planet17)
	(K-obj satellite1 star14)
	(K-obj satellite1 star16)
	(K-obj satellite1 star10)
	(K-obj satellite1 star12)
	(K-obj satellite1 thermograph1)
	(K-obj satellite1 phenomenon11)
	(K-obj satellite1 phenomenon13)
	(K-obj satellite1 star19)
	(K-obj satellite1 star18)
	(K-obj satellite1 star6)
	(K-obj satellite1 phenomenon8)
	(K-obj satellite1 groundstation4)
	(K-obj satellite1 groundstation0)
	(K-obj satellite1 planet21)
	(K-obj satellite1 planet22)
	(K-obj satellite1 phenomenon7)
	(K-obj satellite1 phenomenon5)
	(K-obj satellite1 planet9)
	(K-obj satellite1 image5)
	(K-obj satellite1 image4)
	(K-obj satellite1 phenomenon20)
	(K-obj satellite1 star23)
	(K-obj satellite1 phenomenon24)
	(K-obj satellite1 infrared7)
	(K-obj satellite1 infrared2)
	(K-obj satellite1 infrared3)
	(K-obj satellite1 spectrograph0)
	(K-obj satellite1 star1)
	(K-obj satellite1 spectrograph6)
	(K-obj satellite1 star3)
	(K-obj satellite1 star2)
	(K-obj satellite0 planet15)
	(K-obj satellite0 planet17)
	(K-obj satellite0 star14)
	(K-obj satellite0 star16)
	(K-obj satellite0 star10)
	(K-obj satellite0 star12)
	(K-obj satellite0 thermograph1)
	(K-obj satellite0 phenomenon11)
	(K-obj satellite0 phenomenon13)
	(K-obj satellite0 star19)
	(K-obj satellite0 star18)
	(K-obj satellite0 star6)
	(K-obj satellite0 phenomenon8)
	(K-obj satellite0 groundstation4)
	(K-obj satellite0 groundstation0)
	(K-obj satellite0 planet21)
	(K-obj satellite0 planet22)
	(K-obj satellite0 phenomenon7)
	(K-obj satellite0 phenomenon5)
	(K-obj satellite0 planet9)
	(K-obj satellite0 image5)
	(K-obj satellite0 image4)
	(K-obj satellite0 phenomenon20)
	(K-obj satellite0 star23)
	(K-obj satellite0 phenomenon24)
	(K-obj satellite0 infrared7)
	(K-obj satellite0 infrared2)
	(K-obj satellite0 infrared3)
	(K-obj satellite0 spectrograph0)
	(K-obj satellite0 star1)
	(K-obj satellite0 spectrograph6)
	(K-obj satellite0 star3)
	(K-obj satellite0 star2)
	(K-obj satellite4 planet15)
	(K-obj satellite4 planet17)
	(K-obj satellite4 star14)
	(K-obj satellite4 star16)
	(K-obj satellite4 star10)
	(K-obj satellite4 star12)
	(K-obj satellite4 thermograph1)
	(K-obj satellite4 phenomenon11)
	(K-obj satellite4 phenomenon13)
	(K-obj satellite4 star19)
	(K-obj satellite4 star18)
	(K-obj satellite4 star6)
	(K-obj satellite4 phenomenon8)
	(K-obj satellite4 groundstation4)
	(K-obj satellite4 groundstation0)
	(K-obj satellite4 planet21)
	(K-obj satellite4 planet22)
	(K-obj satellite4 phenomenon7)
	(K-obj satellite4 phenomenon5)
	(K-obj satellite4 planet9)
	(K-obj satellite4 image5)
	(K-obj satellite4 image4)
	(K-obj satellite4 phenomenon20)
	(K-obj satellite4 star23)
	(K-obj satellite4 phenomenon24)
	(K-obj satellite4 infrared7)
	(K-obj satellite4 infrared2)
	(K-obj satellite4 infrared3)
	(K-obj satellite4 spectrograph0)
	(K-obj satellite4 star1)
	(K-obj satellite4 spectrograph6)
	(K-obj satellite4 star3)
	(K-obj satellite4 star2)
	(K-obj satellite3 satellite3)
	(K-obj satellite3 instrument21)
	(K-obj satellite3 instrument20)
	(K-obj satellite3 instrument15)
	(K-obj satellite3 instrument14)
	(K-obj satellite3 instrument18)
	(K-obj satellite3 instrument16)
	(K-obj satellite3 instrument17)
	(K-obj satellite3 instrument19)
	(K-obj satellite2 instrument8)
	(K-obj satellite2 instrument9)
	(K-obj satellite2 satellite2)
	(K-obj satellite2 instrument10)
	(K-obj satellite2 instrument11)
	(K-obj satellite2 instrument12)
	(K-obj satellite2 instrument13)
	(K-obj satellite1 instrument3)
	(K-obj satellite1 instrument6)
	(K-obj satellite1 instrument7)
	(K-obj satellite1 instrument4)
	(K-obj satellite1 instrument5)
	(K-obj satellite1 satellite1)
	(K-obj satellite0 satellite0)
	(K-obj satellite0 instrument2)
	(K-obj satellite0 instrument0)
	(K-obj satellite0 instrument1)
	(K-obj satellite4 instrument24)
	(K-obj satellite4 instrument22)
	(K-obj satellite4 instrument23)
	(K-obj satellite4 satellite4)
	(K-ag-pred satellite3 pred--pointing)
	(K-pred satellite3 pred--pointing)
	(K-ag-pred satellite2 pred--pointing)
	(K-pred satellite2 pred--pointing)
	(K-ag-pred satellite1 pred--pointing)
	(K-pred satellite1 pred--pointing)
	(K-ag-pred satellite0 pred--pointing)
	(K-pred satellite0 pred--pointing)
	(K-ag-pred satellite4 pred--pointing)
	(K-pred satellite4 pred--pointing)
	(K-ag-pred satellite3 pred--have_image)
	(K-pred satellite3 pred--have_image)
	(K-ag-pred satellite2 pred--have_image)
	(K-pred satellite2 pred--have_image)
	(K-ag-pred satellite1 pred--have_image)
	(K-pred satellite1 pred--have_image)
	(K-ag-pred satellite0 pred--have_image)
	(K-pred satellite0 pred--have_image)
	(K-ag-pred satellite4 pred--have_image)
	(K-pred satellite4 pred--have_image)
	(K-ag-pred satellite3 pred--calibrated)
	(K-pred satellite3 pred--calibrated)
	(K-ag-pred satellite2 pred--calibrated)
	(K-pred satellite2 pred--calibrated)
	(K-ag-pred satellite1 pred--calibrated)
	(K-pred satellite1 pred--calibrated)
	(K-ag-pred satellite0 pred--calibrated)
	(K-pred satellite0 pred--calibrated)
	(K-ag-pred satellite4 pred--calibrated)
	(K-pred satellite4 pred--calibrated)
	(K-ag-pred satellite3 pred--supports)
	(K-pred satellite3 pred--supports)
	(K-ag-pred satellite2 pred--supports)
	(K-pred satellite2 pred--supports)
	(K-ag-pred satellite1 pred--supports)
	(K-pred satellite1 pred--supports)
	(K-ag-pred satellite0 pred--supports)
	(K-pred satellite0 pred--supports)
	(K-ag-pred satellite4 pred--supports)
	(K-pred satellite4 pred--supports)
	(K-ag-pred satellite3 pred--on_board)
	(K-pred satellite3 pred--on_board)
	(K-ag-pred satellite2 pred--on_board)
	(K-pred satellite2 pred--on_board)
	(K-ag-pred satellite1 pred--on_board)
	(K-pred satellite1 pred--on_board)
	(K-ag-pred satellite0 pred--on_board)
	(K-pred satellite0 pred--on_board)
	(K-ag-pred satellite4 pred--on_board)
	(K-pred satellite4 pred--on_board)
	(K-ag-pred satellite3 pred--calibration_target)
	(K-pred satellite3 pred--calibration_target)
	(K-ag-pred satellite2 pred--calibration_target)
	(K-pred satellite2 pred--calibration_target)
	(K-ag-pred satellite1 pred--calibration_target)
	(K-pred satellite1 pred--calibration_target)
	(K-ag-pred satellite0 pred--calibration_target)
	(K-pred satellite0 pred--calibration_target)
	(K-ag-pred satellite4 pred--calibration_target)
	(K-pred satellite4 pred--calibration_target)
	(K-ag-pred satellite3 pred--power_avail)
	(K-pred satellite3 pred--power_avail)
	(K-ag-pred satellite2 pred--power_avail)
	(K-pred satellite2 pred--power_avail)
	(K-ag-pred satellite1 pred--power_avail)
	(K-pred satellite1 pred--power_avail)
	(K-ag-pred satellite0 pred--power_avail)
	(K-pred satellite0 pred--power_avail)
	(K-ag-pred satellite4 pred--power_avail)
	(K-pred satellite4 pred--power_avail)
	(K-ag-pred satellite3 pred--power_on)
	(K-pred satellite3 pred--power_on)
	(K-ag-pred satellite2 pred--power_on)
	(K-pred satellite2 pred--power_on)
	(K-ag-pred satellite1 pred--power_on)
	(K-pred satellite1 pred--power_on)
	(K-ag-pred satellite0 pred--power_on)
	(K-pred satellite0 pred--power_on)
	(K-ag-pred satellite4 pred--power_on)
	(K-pred satellite4 pred--power_on)
)
(:goal	(and
		<HYPOTHESIS>
)
)
(:metric minimize (total-time))
)
