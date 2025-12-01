; STEP 1: Screenshot Capture on Click
; This script captures a screenshot every time you click
; Use this ONCE to capture all your buttons
;
; HOW TO USE:
; 1. Run this script
; 2. Press F1 to START recording
; 3. Click each button you want to automate (one by one)
; 4. Press ESC to STOP recording
; 5. Screenshots are saved and ready for the automation script!

#SingleInstance Force
SetWorkingDir %A_ScriptDir%
FileCreateDir, button_images

; Variables
isRecording := false
clickCount := 0
positions := []

; Press F1 to start recording clicks
F1::
    global isRecording, clickCount
    
    if (isRecording) {
        MsgBox, Already recording! Press ESC to stop.
        return
    }
    
    isRecording := true
    clickCount := 0
    
    MsgBox, 4, Start Recording?, 
    (
    CLICK RECORDING MODE
    
    The script will now:
    1. Capture a screenshot after each click you make
    2. Save the button position
    3. Save the screenshot as button1.png, button2.png, etc.
    
    Click YES to start recording.
    Then click each button you want to automate.
    Press ESC when done.
    )
    
    IfMsgBox No
    {
        isRecording := false
        return
    }
    
    ToolTip, 🔴 RECORDING - Click your buttons - ESC to stop
    
    ; Enable click monitoring
    Hotkey, ~LButton, OnLeftClick, On
return

; This triggers when you left-click anywhere
OnLeftClick:
    global isRecording, clickCount, positions
    
    if (!isRecording)
        return
    
    ; Wait for click to complete
    Sleep, 100
    
    ; Get click position
    MouseGetPos, mouseX, mouseY
    
    ; Increment counter
    clickCount++
    
    ; Save position
    positions[clickCount] := {x: mouseX, y: mouseY}
    
    ; Show feedback
    ToolTip, 📸 Captured button %clickCount% at (%mouseX%, %mouseY%)
    SoundBeep, 1000, 100
    
    ; Wait a moment
    Sleep, 500
    
    ; Capture screenshot of the button area
    CaptureButtonArea(mouseX, mouseY, clickCount)
    
    ; Save position to file
    IniWrite, %mouseX%, button_positions.ini, Positions, Button%clickCount%_X
    IniWrite, %mouseY%, button_positions.ini, Positions, Button%clickCount%_Y
    
    ; Update tooltip
    ToolTip, 🔴 RECORDING - Button %clickCount% saved - ESC to stop
return

; Capture a screenshot of the button area
CaptureButtonArea(centerX, centerY, buttonNum)
{
    ; Size of area to capture around click point
    width := 150
    height := 50
    
    ; Calculate capture area (centered on click)
    x := centerX - (width // 2)
    y := centerY - (height // 2)
    
    ; Ensure coordinates are not negative
    if (x < 0)
        x := 0
    if (y < 0)
        y := 0
    
    ; Filename
    filename := A_ScriptDir . "\button_images\button" . buttonNum . ".png"
    
    ; Take screenshot using PrintScreen method (simple and reliable)
    ; Capture full screen first
    Send {PrintScreen}
    Sleep, 200
    
    ; Try GDI+ capture for better quality
    CaptureScreenRegion(x, y, width, height, filename)
    
    return
}

; Simple screen capture function
CaptureScreenRegion(x, y, w, h, filename)
{
    ; Get screen DC
    hDC := DllCall("GetDC", "Ptr", 0, "Ptr")
    hDC2 := DllCall("CreateCompatibleDC", "Ptr", hDC, "Ptr")
    hBM := DllCall("CreateCompatibleBitmap", "Ptr", hDC, "Int", w, "Int", h, "Ptr")
    
    ; Select bitmap into DC
    DllCall("SelectObject", "Ptr", hDC2, "Ptr", hBM)
    
    ; Copy screen region to bitmap
    DllCall("BitBlt", "Ptr", hDC2, "Int", 0, "Int", 0, "Int", w, "Int", h, "Ptr", hDC, "Int", x, "Int", y, "UInt", 0x00CC0020)
    
    ; Save to clipboard as backup
    DllCall("OpenClipboard", "Ptr", 0)
    DllCall("EmptyClipboard")
    DllCall("SetClipboardData", "UInt", 2, "Ptr", hBM)
    DllCall("CloseClipboard")
    
    ; Save to file using simple method
    ; Since we have it in clipboard, we can paste it
    SaveClipboardImage(filename)
    
    ; Cleanup
    DllCall("DeleteDC", "Ptr", hDC2)
    DllCall("ReleaseDC", "Ptr", 0, "Ptr", hDC)
    
    return
}

; Save clipboard image to file
SaveClipboardImage(filename)
{
    ; Use PowerShell to save clipboard image
    psCommand := "Add-Type -AssemblyName System.Windows.Forms; $img = [Windows.Forms.Clipboard]::GetImage(); if ($img) { $img.Save('" . filename . "', [System.Drawing.Imaging.ImageFormat]::Png) }"
    
    RunWait, powershell.exe -WindowStyle Hidden -Command "%psCommand%", , Hide
}

; Press ESC to stop recording
Esc::
    global isRecording, clickCount
    
    if (!isRecording) {
        ExitApp
        return
    }
    
    isRecording := false
    
    ; Disable click monitoring
    Hotkey, ~LButton, OnLeftClick, Off
    
    ToolTip
    
    MsgBox, 
    (
    ✅ RECORDING COMPLETE!
    
    Captured %clickCount% button(s).
    
    Files saved:
    - button_positions.ini (button coordinates)
    - button_images\button1.png, button2.png, etc.
    
    Next step:
    Run the AUTOMATION script to automatically click these buttons!
    
    Press OK to exit.
    )
    
    ExitApp
return

; Ctrl+Esc to force exit
^Esc::ExitApp

; Startup message
MsgBox, 
(
🎯 BUTTON CAPTURE SCRIPT

This script will capture screenshots when you click.

INSTRUCTIONS:
1. Press F1 to START recording
2. Click each button you want to automate
3. After each click, a screenshot is saved
4. Press ESC when finished

Ready? Press F1 to begin!
)
