; On pressing media stop switch between speakers and various headphones
; New line braces required for function
Media_Stop::
#InstallKeybdHook
	gui, add, button, Default x20 y10 h20 w80 gSetSpeaker, Speakers ;g-labels define which subroutine
	gui, add, button, x20 y40 h20 w80 gSetVAC, Virtual Cable
	gui, add, button, x20 y70 h20 w80 gsetG930, G930
	gui, show, w120
return

SetSpeaker: ; Speakers & Webcam mic
	selectDevices(2,2)
return

SetVAC: ; VAC
	selectDevices(3,0) ;
return

setG930: ; G930 Headset & mic
	selectDevices(1,1)
return

; Set speaker and mic repectively - the number is how far down in the sound options list it is (1 being the top)
; Use a 0 arguement to avoid changes
selectDevices(outNum, inNum)
{
	Run, mmsys.cpl
	WinWait,Sound
	ControlSend,SysListView321,{Down %outNum%}
	ControlClick,&Set Default
	WinWait,Sound

	send, ^{Tab}

	ControlSend,SysListView321,{Down %inNum%}
	ControlClick,&Set Default

	ControlClick,OK
	GUI, Destroy
}
