(define (problem strips-sat-x-1) (:domain satellite)
(:objects
	planet13 - direction
	planet15 - direction
	planet17 - direction
	planet18 - direction
	instrument26 - instrument
	satellite3 - satellite
	satellite2 - satellite
	satellite1 - satellite
	satellite0 - satellite
	satellite4 - satellite
	phenomenon19 - direction
	star16 - direction
	star11 - direction
	star10 - direction
	phenomenon12 - direction
	instrument19 - instrument
	phenomenon14 - direction
	thermograph7 - mode
	instrument25 - instrument
	instrument24 - instrument
	instrument27 - instrument
	spectrograph0 - mode
	instrument21 - instrument
	instrument20 - instrument
	instrument23 - instrument
	instrument22 - instrument
	groundstation3 - direction
	instrument0 - instrument
	groundstation1 - direction
	spectrograph6 - mode
	star20 - direction
	instrument8 - instrument
	instrument9 - instrument
	thermograph8 - mode
	instrument2 - instrument
	instrument3 - instrument
	planet22 - direction
	instrument1 - instrument
	instrument6 - instrument
	instrument7 - instrument
	instrument4 - instrument
	instrument5 - instrument
	planet7 - direction
	phenomenon5 - direction
	image3 - mode
	image2 - mode
	planet9 - direction
	phenomenon8 - direction
	image4 - mode
	phenomenon21 - direction
	star23 - direction
	star24 - direction
	infrared9 - mode
	infrared5 - mode
	infrared1 - mode
	instrument28 - instrument
	star4 - direction
	star6 - direction
	instrument18 - instrument
	star0 - direction
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
	(supports instrument0 image3)
	(calibration_target instrument0 star2)
	(supports instrument1 infrared9)
	(calibration_target instrument1 star4)
	(supports instrument2 thermograph8)
	(supports instrument2 image2)
	(supports instrument2 image4)
	(calibration_target instrument2 star4)
	(supports instrument3 infrared9)
	(calibration_target instrument3 star0)
	(supports instrument4 image3)
	(supports instrument4 thermograph8)
	(calibration_target instrument4 groundstation3)
	(supports instrument5 infrared9)
	(supports instrument5 image4)
	(calibration_target instrument5 groundstation3)
	(supports instrument6 infrared1)
	(calibration_target instrument6 groundstation3)
	(supports instrument7 thermograph8)
	(supports instrument7 spectrograph6)
	(calibration_target instrument7 groundstation1)
	(supports instrument8 spectrograph0)
	(supports instrument8 infrared9)
	(supports instrument8 thermograph7)
	(calibration_target instrument8 star2)
	(supports instrument9 thermograph7)
	(calibration_target instrument9 star4)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(on_board instrument2 satellite0)
	(on_board instrument3 satellite0)
	(on_board instrument4 satellite0)
	(on_board instrument5 satellite0)
	(on_board instrument6 satellite0)
	(on_board instrument7 satellite0)
	(on_board instrument8 satellite0)
	(on_board instrument9 satellite0)
	(power_avail satellite0)
	(pointing satellite0 groundstation1)
	(supports instrument10 infrared1)
	(supports instrument10 thermograph8)
	(supports instrument10 spectrograph6)
	(calibration_target instrument10 star4)
	(supports instrument11 image4)
	(supports instrument11 thermograph7)
	(supports instrument11 infrared1)
	(calibration_target instrument11 groundstation3)
	(supports instrument12 infrared9)
	(supports instrument12 thermograph8)
	(supports instrument12 infrared5)
	(calibration_target instrument12 groundstation3)
	(supports instrument13 image2)
	(supports instrument13 infrared1)
	(calibration_target instrument13 star4)
	(supports instrument14 image3)
	(calibration_target instrument14 groundstation3)
	(supports instrument15 thermograph7)
	(calibration_target instrument15 star2)
	(on_board instrument10 satellite1)
	(on_board instrument11 satellite1)
	(on_board instrument12 satellite1)
	(on_board instrument13 satellite1)
	(on_board instrument14 satellite1)
	(on_board instrument15 satellite1)
	(power_avail satellite1)
	(pointing satellite1 phenomenon19)
	(supports instrument16 infrared9)
	(supports instrument16 image2)
	(calibration_target instrument16 star4)
	(supports instrument17 infrared5)
	(calibration_target instrument17 star0)
	(supports instrument18 infrared9)
	(calibration_target instrument18 groundstation1)
	(supports instrument19 infrared5)
	(supports instrument19 image2)
	(calibration_target instrument19 groundstation3)
	(on_board instrument16 satellite2)
	(on_board instrument17 satellite2)
	(on_board instrument18 satellite2)
	(on_board instrument19 satellite2)
	(power_avail satellite2)
	(pointing satellite2 phenomenon14)
	(supports instrument20 image2)
	(supports instrument20 image3)
	(supports instrument20 image4)
	(calibration_target instrument20 groundstation1)
	(supports instrument21 image3)
	(supports instrument21 thermograph8)
	(supports instrument21 infrared5)
	(calibration_target instrument21 star2)
	(on_board instrument20 satellite3)
	(on_board instrument21 satellite3)
	(power_avail satellite3)
	(pointing satellite3 star10)
	(supports instrument22 thermograph8)
	(supports instrument22 infrared5)
	(calibration_target instrument22 star4)
	(supports instrument23 thermograph8)
	(supports instrument23 image3)
	(calibration_target instrument23 star2)
	(supports instrument24 thermograph8)
	(calibration_target instrument24 star2)
	(supports instrument25 infrared5)
	(calibration_target instrument25 star2)
	(supports instrument26 image3)
	(calibration_target instrument26 star4)
	(supports instrument27 image2)
	(supports instrument27 infrared9)
	(calibration_target instrument27 groundstation3)
	(supports instrument28 spectrograph0)
	(supports instrument28 image4)
	(supports instrument28 thermograph7)
	(calibration_target instrument28 groundstation1)
	(on_board instrument22 satellite4)
	(on_board instrument23 satellite4)
	(on_board instrument24 satellite4)
	(on_board instrument25 satellite4)
	(on_board instrument26 satellite4)
	(on_board instrument27 satellite4)
	(on_board instrument28 satellite4)
	(power_avail satellite4)
	(pointing satellite4 star16)
	(K-obj satellite3 planet13)
	(K-obj satellite3 planet15)
	(K-obj satellite3 planet17)
	(K-obj satellite3 planet18)
	(K-obj satellite3 phenomenon19)
	(K-obj satellite3 star16)
	(K-obj satellite3 star11)
	(K-obj satellite3 star10)
	(K-obj satellite3 phenomenon12)
	(K-obj satellite3 phenomenon14)
	(K-obj satellite3 thermograph7)
	(K-obj satellite3 star6)
	(K-obj satellite3 groundstation3)
	(K-obj satellite3 groundstation1)
	(K-obj satellite3 star0)
	(K-obj satellite3 phenomenon21)
	(K-obj satellite3 thermograph8)
	(K-obj satellite3 planet22)
	(K-obj satellite3 planet7)
	(K-obj satellite3 phenomenon5)
	(K-obj satellite3 image3)
	(K-obj satellite3 image2)
	(K-obj satellite3 planet9)
	(K-obj satellite3 phenomenon8)
	(K-obj satellite3 image4)
	(K-obj satellite3 star20)
	(K-obj satellite3 star23)
	(K-obj satellite3 star24)
	(K-obj satellite3 infrared9)
	(K-obj satellite3 infrared5)
	(K-obj satellite3 infrared1)
	(K-obj satellite3 star4)
	(K-obj satellite3 spectrograph0)
	(K-obj satellite3 spectrograph6)
	(K-obj satellite3 star2)
	(K-obj satellite2 planet13)
	(K-obj satellite2 planet15)
	(K-obj satellite2 planet17)
	(K-obj satellite2 planet18)
	(K-obj satellite2 phenomenon19)
	(K-obj satellite2 star16)
	(K-obj satellite2 star11)
	(K-obj satellite2 star10)
	(K-obj satellite2 phenomenon12)
	(K-obj satellite2 phenomenon14)
	(K-obj satellite2 thermograph7)
	(K-obj satellite2 star6)
	(K-obj satellite2 groundstation3)
	(K-obj satellite2 groundstation1)
	(K-obj satellite2 star0)
	(K-obj satellite2 phenomenon21)
	(K-obj satellite2 thermograph8)
	(K-obj satellite2 planet22)
	(K-obj satellite2 planet7)
	(K-obj satellite2 phenomenon5)
	(K-obj satellite2 image3)
	(K-obj satellite2 image2)
	(K-obj satellite2 planet9)
	(K-obj satellite2 phenomenon8)
	(K-obj satellite2 image4)
	(K-obj satellite2 star20)
	(K-obj satellite2 star23)
	(K-obj satellite2 star24)
	(K-obj satellite2 infrared9)
	(K-obj satellite2 infrared5)
	(K-obj satellite2 infrared1)
	(K-obj satellite2 star4)
	(K-obj satellite2 spectrograph0)
	(K-obj satellite2 spectrograph6)
	(K-obj satellite2 star2)
	(K-obj satellite1 planet13)
	(K-obj satellite1 planet15)
	(K-obj satellite1 planet17)
	(K-obj satellite1 planet18)
	(K-obj satellite1 phenomenon19)
	(K-obj satellite1 star16)
	(K-obj satellite1 star11)
	(K-obj satellite1 star10)
	(K-obj satellite1 phenomenon12)
	(K-obj satellite1 phenomenon14)
	(K-obj satellite1 thermograph7)
	(K-obj satellite1 star6)
	(K-obj satellite1 groundstation3)
	(K-obj satellite1 groundstation1)
	(K-obj satellite1 star0)
	(K-obj satellite1 phenomenon21)
	(K-obj satellite1 thermograph8)
	(K-obj satellite1 planet22)
	(K-obj satellite1 planet7)
	(K-obj satellite1 phenomenon5)
	(K-obj satellite1 image3)
	(K-obj satellite1 image2)
	(K-obj satellite1 planet9)
	(K-obj satellite1 phenomenon8)
	(K-obj satellite1 image4)
	(K-obj satellite1 star20)
	(K-obj satellite1 star23)
	(K-obj satellite1 star24)
	(K-obj satellite1 infrared9)
	(K-obj satellite1 infrared5)
	(K-obj satellite1 infrared1)
	(K-obj satellite1 star4)
	(K-obj satellite1 spectrograph0)
	(K-obj satellite1 spectrograph6)
	(K-obj satellite1 star2)
	(K-obj satellite0 planet13)
	(K-obj satellite0 planet15)
	(K-obj satellite0 planet17)
	(K-obj satellite0 planet18)
	(K-obj satellite0 phenomenon19)
	(K-obj satellite0 star16)
	(K-obj satellite0 star11)
	(K-obj satellite0 star10)
	(K-obj satellite0 phenomenon12)
	(K-obj satellite0 phenomenon14)
	(K-obj satellite0 thermograph7)
	(K-obj satellite0 star6)
	(K-obj satellite0 groundstation3)
	(K-obj satellite0 groundstation1)
	(K-obj satellite0 star0)
	(K-obj satellite0 phenomenon21)
	(K-obj satellite0 thermograph8)
	(K-obj satellite0 planet22)
	(K-obj satellite0 planet7)
	(K-obj satellite0 phenomenon5)
	(K-obj satellite0 image3)
	(K-obj satellite0 image2)
	(K-obj satellite0 planet9)
	(K-obj satellite0 phenomenon8)
	(K-obj satellite0 image4)
	(K-obj satellite0 star20)
	(K-obj satellite0 star23)
	(K-obj satellite0 star24)
	(K-obj satellite0 infrared9)
	(K-obj satellite0 infrared5)
	(K-obj satellite0 infrared1)
	(K-obj satellite0 star4)
	(K-obj satellite0 spectrograph0)
	(K-obj satellite0 spectrograph6)
	(K-obj satellite0 star2)
	(K-obj satellite4 planet13)
	(K-obj satellite4 planet15)
	(K-obj satellite4 planet17)
	(K-obj satellite4 planet18)
	(K-obj satellite4 phenomenon19)
	(K-obj satellite4 star16)
	(K-obj satellite4 star11)
	(K-obj satellite4 star10)
	(K-obj satellite4 phenomenon12)
	(K-obj satellite4 phenomenon14)
	(K-obj satellite4 thermograph7)
	(K-obj satellite4 star6)
	(K-obj satellite4 groundstation3)
	(K-obj satellite4 groundstation1)
	(K-obj satellite4 star0)
	(K-obj satellite4 phenomenon21)
	(K-obj satellite4 thermograph8)
	(K-obj satellite4 planet22)
	(K-obj satellite4 planet7)
	(K-obj satellite4 phenomenon5)
	(K-obj satellite4 image3)
	(K-obj satellite4 image2)
	(K-obj satellite4 planet9)
	(K-obj satellite4 phenomenon8)
	(K-obj satellite4 image4)
	(K-obj satellite4 star20)
	(K-obj satellite4 star23)
	(K-obj satellite4 star24)
	(K-obj satellite4 infrared9)
	(K-obj satellite4 infrared5)
	(K-obj satellite4 infrared1)
	(K-obj satellite4 star4)
	(K-obj satellite4 spectrograph0)
	(K-obj satellite4 spectrograph6)
	(K-obj satellite4 star2)
	(K-obj satellite3 satellite3)
	(K-obj satellite3 instrument21)
	(K-obj satellite3 instrument20)
	(K-obj satellite2 satellite2)
	(K-obj satellite2 instrument16)
	(K-obj satellite2 instrument17)
	(K-obj satellite2 instrument18)
	(K-obj satellite2 instrument19)
	(K-obj satellite1 satellite1)
	(K-obj satellite1 instrument14)
	(K-obj satellite1 instrument15)
	(K-obj satellite1 instrument10)
	(K-obj satellite1 instrument11)
	(K-obj satellite1 instrument12)
	(K-obj satellite1 instrument13)
	(K-obj satellite0 instrument8)
	(K-obj satellite0 instrument9)
	(K-obj satellite0 instrument2)
	(K-obj satellite0 instrument3)
	(K-obj satellite0 instrument0)
	(K-obj satellite0 instrument1)
	(K-obj satellite0 instrument6)
	(K-obj satellite0 instrument7)
	(K-obj satellite0 instrument4)
	(K-obj satellite0 instrument5)
	(K-obj satellite0 satellite0)
	(K-obj satellite4 instrument25)
	(K-obj satellite4 instrument24)
	(K-obj satellite4 instrument27)
	(K-obj satellite4 instrument26)
	(K-obj satellite4 instrument23)
	(K-obj satellite4 instrument22)
	(K-obj satellite4 instrument28)
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
