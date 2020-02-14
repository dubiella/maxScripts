-- Diogo Dubiella
-- www.dubiella.com
-- CameraRig v1.1 - 04/16/2018
--v1.1 - Main dummy resizeses properly

rollout CamRig "Camera Rig 1.1" (
	
	group "" (
		editText txName "Camera Name:" text:"Camera01"
		spinner spDistance "Distance:" range:[0,9999999,200]
		button btCreate "Create"
	)
	hyperLink lkDubi "dubiella.com" color:white hoverColor:white visitedColor:white address:"http://www.dubiella.com" align:#left  across:2
	hyperLink lkDona "donate" color:white hoverColor:white visitedColor:white address:"https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=UETNEKYUQEU46" align:#right 

		
		on btCreate pressed do (
			
			NewCamName = txName.text
			NewCam = Physical targeted:on name:NewCamName pos:[0,-200,0] isSelected:on 
			NewDummy01 = Dummy name:(NewCamName + "_Dummy_Base") boxsize:[(spDistance.value/2), (spDistance.value/2),(spDistance.value/2)]
			NewDummy02 = Dummy name:(NewCamName + "_Dummy_Cam") boxsize:[10, 10,10] pos:[0,-(spDistance.value),0]

			NewDummy01
			NewDummy02
			NewCam.targeted = on
			NewCam.target.pos = [0,0,0]
			
			ca = attributes CameraControl (
				parameters AttParameters rollout:FocusPar (
					Focus type:#float ui:(spFocus)
				)
				rollout FocusPar "Focus" (
					spinner spFocus range:[-10000,10000,0]
				)
			)
			Modf = EmptyModifier()
			addModifier NewDummy01 Modf
			CustAttributes.add NewDummy01.modifiers[#Attribute_Holder] ca

			CamPosCtrl = Position_Constraint()
			CamPosCtrlInterface = CamPosCtrl.constraints
			CamTargetPosCtrl = Position_Constraint()
			CamTargetPosCtrlInterface = CamTargetPosCtrl.constraints

			NewCam.pos.controller = CamPosCtrl
			CamPosCtrlInterface.appendTarget NewDummy02 100

			NewCam.target.pos.controller = CamTargetPosCtrl
			CamTargetPosCtrlInterface.appendTarget NewDummy01 100
			
			NewCam.specify_focus = 1
			NewCam.show_camera_cone = 1
			
			fs = float_script()
			NewCam.focus_distance.controller = fs
			fs.addTarget "Me" NewCam[#transform][#position]
			fs.addTarget "Target" NewDummy01[#transform][#position]
			fs.addTarget "Focus" NewDummy01[#Modified_Object][#Attribute_Holder].CameraControl[#Focus]
			fs.script = "Focus + (distance Target Me)"

			NewDummy02.parent = NewDummy01
			
			Select NewDummy01
			print txName.text
			
		)
	
	
) createdialog CamRig
