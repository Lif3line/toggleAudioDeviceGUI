; On pressing media stop bring up a simple GUI for fast switching of audio/comms devices
#SingleInstance force

guiOption1Name := "Speakers"
audio1Name := "Realtek High Definition Audio"
record1Name := "HD Pro Webcam C920"

guiOption2Name := "Vive"
audio2Name := "USB Audio Device"
record2Name := "USB Audio Device"

guiOption3Name := "G930"
audio3Name := "3- Logitech G930 Gaming Headset"
record3Name := "3- Logitech G930 Gaming Headset"

Media_Stop::
#InstallKeybdHook
    gui, add, button, Default x20 y10 h20 w80 gSetOption1, %guiOption1Name% ;g-labels define which subroutine
    gui, add, button, x20 y40 h20 w80 gSetOption2, %guiOption2Name%
    gui, add, button, x20 y70 h20 w80 gSetOption3, %guiOption3Name%
    gui, show, w120
return

; Options for GUI - comments for my own system
SetOption1:
    selectAudioDevices(audio1Name,record1Name)
    gui, Destroy
return

SetOption2:
    selectAudioDevices(audio2Name,record2Name)
    gui, Destroy
return

SetOption3: ; G930 Headset & mic
    selectAudioDevices(audio3Name,record3Name)
    gui, Destroy
return

selectAudioDevices(audioOut, audioIn)
{
    SetBatchLines -1
    DetectHiddenWindows On

    Run rundll32.exe shell32.dll`,Control_RunDLL mmsys.cpl`,`,0

    WinWait,Sound
    WinHide

    if audioOut
    {
        selectDeviceInSoundMenus(audioOut)
    }

    if audioIn
    {
        WinWait,Sound
        send, ^{Tab}
        selectDeviceInSoundMenus(audioIn)
    }

    ControlSend OK, {Enter}
    Return
}

selectDeviceInSoundMenus(deviceName)
{
    ControlGet List, List,, SysListView321
    StringReplace List, List, `t, %A_Space%, A

    IfNotInString List, %deviceName%
    {
        msgBox, 0, Warning, %deviceName% not found
        ControlSend Cancel, {Enter}
        Return
    }

    Loop Parse, List, `n
    {
        IfInString A_LoopField, %deviceName%
        {
            If RegExMatch(A_LoopField, "(Disabled$|Disconnected$|Not plugged in$)")
            {
                msgBox, 0, Warning, %deviceName% not available
                ControlSend Cancel, {Enter}
                Return
            }

            DeviceNumber := A_Index

            Break
        }
    }

    numDownCommands := DeviceNumber - 1
    ControlSend SysListView321, {Home}{Down %numDownCommands%}
    ControlSend &Set Default, {Space}
}
