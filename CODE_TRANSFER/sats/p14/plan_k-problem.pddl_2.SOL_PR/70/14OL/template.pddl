(define (problem strips-sat-x-1) (:domain satellite)
(:objects
	planet15 - direction
	planet17 - direction
	planet16 - direction
	instrument9 - instrument
	satellite3 - satellite
	satellite2 - satellite
	satellite1 - satellite
	satellite0 - satellite
	satellite5 - satellite
	satellite4 - satellite
	phenomenon18 - direction
	star14 - direction
	star10 - direction
	thermograph0 - mode
	phenomenon12 - direction
	phenomenon13 - direction
	star19 - direction
	thermograph4 - mode
	instrument3 - instrument
	groundstation4 - direction
	groundstation3 - direction
	groundstation2 - direction
	groundstation1 - direction
	groundstation0 - direction
	instrument8 - instrument
	instrument1 - instrument
	instrument2 - instrument
	planet21 - direction
	instrument0 - instrument
	planet23 - direction
	instrument6 - instrument
	instrument7 - instrument
	instrument4 - instrument
	instrument5 - instrument
	phenomenon6 - direction
	phenomenon7 - direction
	phenomenon5 - direction
	image2 - mode
	image1 - mode
	planet8 - direction
	star20 - direction
	star22 - direction
	star24 - direction
	instrument10 - instrument
	instrument11 - instrument
	phenomenon11 - direction
	star9 - direction
	thermograph3 - mode
)
(:init
	(supports instrument0 thermograph0)
	(supports instrument0 image1)
	(calibration_target instrument0 groundstation2)
	(supports instrument1 image2)
	(supports instrument1 thermograph3)
	(calibration_target instrument1 groundstation0)
	(supports instrument2 image1)
	(supports instrument2 thermograph3)
	(supports instrument2 thermograph4)
	(calibration_target instrument2 groundstation2)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(on_board instrument2 satellite0)
	(power_avail satellite0)
	(pointing satellite0 phenomenon12)
	(supports instrument3 thermograph0)
	(supports instrument3 thermograph4)
	(supports instrument3 image2)
	(calibration_target instrument3 groundstation2)
	(on_board instrument3 satellite1)
	(power_avail satellite1)
	(pointing satellite1 groundstation1)
	(supports instrument4 thermograph4)
	(supports instrument4 image1)
	(supports instrument4 thermograph0)
	(calibration_target instrument4 groundstation1)
	(supports instrument5 thermograph4)
	(calibration_target instrument5 groundstation4)
	(supports instrument6 thermograph3)
	(supports instrument6 image1)
	(calibration_target instrument6 groundstation0)
	(on_board instrument4 satellite2)
	(on_board instrument5 satellite2)
	(on_board instrument6 satellite2)
	(power_avail satellite2)
	(pointing satellite2 groundstation2)
	(supports instrument7 image2)
	(supports instrument7 thermograph3)
	(calibration_target instrument7 groundstation4)
	(supports instrument8 thermograph4)
	(supports instrument8 thermograph0)
	(calibration_target instrument8 groundstation2)
	(on_board instrument7 satellite3)
	(on_board instrument8 satellite3)
	(power_avail satellite3)
	(pointing satellite3 groundstation4)
	(supports instrument9 thermograph0)
	(supports instrument9 image2)
	(supports instrument9 image1)
	(calibration_target instrument9 groundstation2)
	(supports instrument10 thermograph3)
	(supports instrument10 image1)
	(calibration_target instrument10 groundstation0)
	(on_board instrument9 satellite4)
	(on_board instrument10 satellite4)
	(power_avail satellite4)
	(pointing satellite4 planet15)
	(supports instrument11 thermograph0)
	(supports instrument11 image2)
	(calibration_target instrument11 groundstation1)
	(on_board instrument11 satellite5)
	(power_avail satellite5)
	(pointing satellite5 phenomenon11)
	(K-obj satellite3 planet15)
	(K-obj satellite3 planet17)
	(K-obj satellite3 planet16)
	(K-obj satellite3 phenomenon18)
	(K-obj satellite3 star14)
	(K-obj satellite3 star10)
	(K-obj satellite3 thermograph0)
	(K-obj satellite3 phenomenon12)
	(K-obj satellite3 phenomenon13)
	(K-obj satellite3 star19)
	(K-obj satellite3 thermograph4)
	(K-obj satellite3 groundstation4)
	(K-obj satellite3 groundstation3)
	(K-obj satellite3 groundstation2)
	(K-obj satellite3 groundstation1)
	(K-obj satellite3 groundstation0)
	(K-obj satellite3 planet21)
	(K-obj satellite3 planet23)
	(K-obj satellite3 phenomenon6)
	(K-obj satellite3 phenomenon7)
	(K-obj satellite3 phenomenon5)
	(K-obj satellite3 image2)
	(K-obj satellite3 image1)
	(K-obj satellite3 planet8)
	(K-obj satellite3 star20)
	(K-obj satellite3 star22)
	(K-obj satellite3 star24)
	(K-obj satellite3 phenomenon11)
	(K-obj satellite3 star9)
	(K-obj satellite3 thermograph3)
	(K-obj satellite2 planet15)
	(K-obj satellite2 planet17)
	(K-obj satellite2 planet16)
	(K-obj satellite2 phenomenon18)
	(K-obj satellite2 star14)
	(K-obj satellite2 star10)
	(K-obj satellite2 thermograph0)
	(K-obj satellite2 phenomenon12)
	(K-obj satellite2 phenomenon13)
	(K-obj satellite2 star19)
	(K-obj satellite2 thermograph4)
	(K-obj satellite2 groundstation4)
	(K-obj satellite2 groundstation3)
	(K-obj satellite2 groundstation2)
	(K-obj satellite2 groundstation1)
	(K-obj satellite2 groundstation0)
	(K-obj satellite2 planet21)
	(K-obj satellite2 planet23)
	(K-obj satellite2 phenomenon6)
	(K-obj satellite2 phenomenon7)
	(K-obj satellite2 phenomenon5)
	(K-obj satellite2 image2)
	(K-obj satellite2 image1)
	(K-obj satellite2 planet8)
	(K-obj satellite2 star20)
	(K-obj satellite2 star22)
	(K-obj satellite2 star24)
	(K-obj satellite2 phenomenon11)
	(K-obj satellite2 star9)
	(K-obj satellite2 thermograph3)
	(K-obj satellite1 planet15)
	(K-obj satellite1 planet17)
	(K-obj satellite1 planet16)
	(K-obj satellite1 phenomenon18)
	(K-obj satellite1 star14)
	(K-obj satellite1 star10)
	(K-obj satellite1 thermograph0)
	(K-obj satellite1 phenomenon12)
	(K-obj satellite1 phenomenon13)
	(K-obj satellite1 star19)
	(K-obj satellite1 thermograph4)
	(K-obj satellite1 groundstation4)
	(K-obj satellite1 groundstation3)
	(K-obj satellite1 groundstation2)
	(K-obj satellite1 groundstation1)
	(K-obj satellite1 groundstation0)
	(K-obj satellite1 planet21)
	(K-obj satellite1 planet23)
	(K-obj satellite1 phenomenon6)
	(K-obj satellite1 phenomenon7)
	(K-obj satellite1 phenomenon5)
	(K-obj satellite1 image2)
	(K-obj satellite1 image1)
	(K-obj satellite1 planet8)
	(K-obj satellite1 star20)
	(K-obj satellite1 star22)
	(K-obj satellite1 star24)
	(K-obj satellite1 phenomenon11)
	(K-obj satellite1 star9)
	(K-obj satellite1 thermograph3)
	(K-obj satellite0 planet15)
	(K-obj satellite0 planet17)
	(K-obj satellite0 planet16)
	(K-obj satellite0 phenomenon18)
	(K-obj satellite0 star14)
	(K-obj satellite0 star10)
	(K-obj satellite0 thermograph0)
	(K-obj satellite0 phenomenon12)
	(K-obj satellite0 phenomenon13)
	(K-obj satellite0 star19)
	(K-obj satellite0 thermograph4)
	(K-obj satellite0 groundstation4)
	(K-obj satellite0 groundstation3)
	(K-obj satellite0 groundstation2)
	(K-obj satellite0 groundstation1)
	(K-obj satellite0 groundstation0)
	(K-obj satellite0 planet21)
	(K-obj satellite0 planet23)
	(K-obj satellite0 phenomenon6)
	(K-obj satellite0 phenomenon7)
	(K-obj satellite0 phenomenon5)
	(K-obj satellite0 image2)
	(K-obj satellite0 image1)
	(K-obj satellite0 planet8)
	(K-obj satellite0 star20)
	(K-obj satellite0 star22)
	(K-obj satellite0 star24)
	(K-obj satellite0 phenomenon11)
	(K-obj satellite0 star9)
	(K-obj satellite0 thermograph3)
	(K-obj satellite5 planet15)
	(K-obj satellite5 planet17)
	(K-obj satellite5 planet16)
	(K-obj satellite5 phenomenon18)
	(K-obj satellite5 star14)
	(K-obj satellite5 star10)
	(K-obj satellite5 thermograph0)
	(K-obj satellite5 phenomenon12)
	(K-obj satellite5 phenomenon13)
	(K-obj satellite5 star19)
	(K-obj satellite5 thermograph4)
	(K-obj satellite5 groundstation4)
	(K-obj satellite5 groundstation3)
	(K-obj satellite5 groundstation2)
	(K-obj satellite5 groundstation1)
	(K-obj satellite5 groundstation0)
	(K-obj satellite5 planet21)
	(K-obj satellite5 planet23)
	(K-obj satellite5 phenomenon6)
	(K-obj satellite5 phenomenon7)
	(K-obj satellite5 phenomenon5)
	(K-obj satellite5 image2)
	(K-obj satellite5 image1)
	(K-obj satellite5 planet8)
	(K-obj satellite5 star20)
	(K-obj satellite5 star22)
	(K-obj satellite5 star24)
	(K-obj satellite5 phenomenon11)
	(K-obj satellite5 star9)
	(K-obj satellite5 thermograph3)
	(K-obj satellite4 planet15)
	(K-obj satellite4 planet17)
	(K-obj satellite4 planet16)
	(K-obj satellite4 phenomenon18)
	(K-obj satellite4 star14)
	(K-obj satellite4 star10)
	(K-obj satellite4 thermograph0)
	(K-obj satellite4 phenomenon12)
	(K-obj satellite4 phenomenon13)
	(K-obj satellite4 star19)
	(K-obj satellite4 thermograph4)
	(K-obj satellite4 groundstation4)
	(K-obj satellite4 groundstation3)
	(K-obj satellite4 groundstation2)
	(K-obj satellite4 groundstation1)
	(K-obj satellite4 groundstation0)
	(K-obj satellite4 planet21)
	(K-obj satellite4 planet23)
	(K-obj satellite4 phenomenon6)
	(K-obj satellite4 phenomenon7)
	(K-obj satellite4 phenomenon5)
	(K-obj satellite4 image2)
	(K-obj satellite4 image1)
	(K-obj satellite4 planet8)
	(K-obj satellite4 star20)
	(K-obj satellite4 star22)
	(K-obj satellite4 star24)
	(K-obj satellite4 phenomenon11)
	(K-obj satellite4 star9)
	(K-obj satellite4 thermograph3)
	(K-obj satellite3 satellite3)
	(K-obj satellite3 instrument8)
	(K-obj satellite3 instrument7)
	(K-obj satellite2 satellite2)
	(K-obj satellite2 instrument6)
	(K-obj satellite2 instrument4)
	(K-obj satellite2 instrument5)
	(K-obj satellite1 instrument3)
	(K-obj satellite1 satellite1)
	(K-obj satellite0 satellite0)
	(K-obj satellite0 instrument2)
	(K-obj satellite0 instrument0)
	(K-obj satellite0 instrument1)
	(K-obj satellite5 satellite5)
	(K-obj satellite5 instrument11)
	(K-obj satellite4 instrument9)
	(K-obj satellite4 instrument10)
	(K-obj satellite4 satellite4)
	(K-ag-pred satellite3 pred--pointing)
	(K-pred satellite3 pred--pointing)
	(K-ag-pred satellite2 pred--pointing)
	(K-pred satellite2 pred--pointing)
	(K-ag-pred satellite1 pred--pointing)
	(K-pred satellite1 pred--pointing)
	(K-ag-pred satellite0 pred--pointing)
	(K-pred satellite0 pred--pointing)
	(K-ag-pred satellite5 pred--pointing)
	(K-pred satellite5 pred--pointing)
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
	(K-ag-pred satellite5 pred--have_image)
	(K-pred satellite5 pred--have_image)
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
	(K-ag-pred satellite5 pred--calibrated)
	(K-pred satellite5 pred--calibrated)
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
	(K-ag-pred satellite5 pred--supports)
	(K-pred satellite5 pred--supports)
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
	(K-ag-pred satellite5 pred--on_board)
	(K-pred satellite5 pred--on_board)
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
	(K-ag-pred satellite5 pred--calibration_target)
	(K-pred satellite5 pred--calibration_target)
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
	(K-ag-pred satellite5 pred--power_avail)
	(K-pred satellite5 pred--power_avail)
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
	(K-ag-pred satellite5 pred--power_on)
	(K-pred satellite5 pred--power_on)
	(K-ag-pred satellite4 pred--power_on)
	(K-pred satellite4 pred--power_on)
)
(:goal	(and
		<HYPOTHESIS>
)
)
(:metric minimize (total-time))
)
