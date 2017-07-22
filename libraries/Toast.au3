#include-once

; #INDEX# ============================================================================================================
; Title .........: Toast
; AutoIt Version : 3.3.2.0 - uses AdlibRegister/Unregister
; Language ......: English
; Description ...: Show and hides slice messages from the systray in user defined colours and fonts
; Author(s) .....: Melba23 - using some code from guinness and MilesAhead in __Toast_Locate
; ====================================================================================================================

;#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w- 4 -w 5 -w 6 -w- 7

; #INCLUDES# =========================================================================================================
#include <StringSize.au3>
#include <GDIPlus.au3>

; #GLOBAL VARIABLES# =================================================================================================
Global $iDef_Toast_Font_Size = __Toast_GetDefFont(0)
Global $sDef_Toast_Font_Name = __Toast_GetDefFont(1)

Global $hToast_Handle = 0
Global $hToast_Close_X = 9999
Global $iToast_Move = 0
Global $iToast_Style = 1 ; $SS_CENTER
Global $aRet = DllCall("User32.dll", "int", "GetSysColor", "int", 8) ; $COLOR_WINDOWTEXT = 8
Global $iToast_Header_BkCol = $aRet[0]
$aRet = DllCall("User32.dll", "int", "GetSysColor", "int", 5) ; $COLOR_WINDOW = 5
Global $iToast_Header_Col = $aRet[0]
Global $iToast_Header_Bold = 0
Global $iToast_Message_BkCol = $iToast_Header_Col
Global $iToast_Message_Col = $iToast_Header_BkCol
Global $iToast_Font_Size = $iDef_Toast_Font_Size
Global $sToast_Font_Name = $sDef_Toast_Font_Name
Global $iToast_Time_Out = 1000
Global $iToast_Time_In = 500
Global $iToast_Timer = 0
Global $iToast_Start = 0
Global $fToast_Close = False
Global $fToast_Retracting = False

Global $vIcon_Retraction, $sTitle_Retraction, $sMessage_Retraction, $iDelay_Retraction, $fWait_Retraction, $fRaw_Retraction

; #CURRENT# ==========================================================================================================
; _Toast_Set:  Sets text justification and optionally colours and font, for _Toast_Show function calls
; _Toast_Show: Shows a slice message from the systray
; _Toast_Hide: Hides a slice message from the systray
; ====================================================================================================================

; #INTERNAL_USE_ONLY#=================================================================================================
; __Toast_Locate:           Find Systray and determine Toast start position and movement direction
; __Toast_Timer_Check:      Checks whether Toast has timed out or closure [X] clicked
; __Toast_Retraction_Check: Checks for completion if _Toast_Show called while previous retraction in progress
; __Toast_WM_EVENTS:        Message handler to check if closure [X] clicked
; __Toast_GetDefFont:       Determine system default MsgBox font and size
; __Toast_ShowPNG:          Set PNG as image
; __Toast_BitmapCreateDIB:  Create bitmap
; ====================================================================================================================

; #FUNCTION# =========================================================================================================
; Name...........: _Toast_Set
; Description ...: Sets text justification and optionally colours and font, for _Toast_Show function calls
; Syntax.........: _Toast_Set($vJust, [$iHdr_BkCol, [$iHdr_Col, [$iMsg_BkCol, [$iMsg_Col, [$sFont_Size, [$iFont_Name, [$iTime_Out, [$iTime_In ]]]]]]]])
; Parameters ....: $vJust     - 0 = Left justified, 1 = Centred (Default), 2 = Right justified
;                                Can use $SS_LEFT, $SS_CENTER, $SS_RIGHT
;                                + 4 = Header text in bold
;                       >>>>>    Setting this parameter to' Default' will reset ALL parameters to default values     <<<<<
;                       >>>>>    All optional parameters default to system MsgBox default values                     <<<<<
;                  $iHdr_BkCol - [Optional] The colour for the title bar background
;                  $iHdr_Col   - [Optional] The colour for the title bar text
;                  $iMsg_BkCol - [Optional] The colour for the message background
;                  $iMsg_Col   - [Optional] The colour for the message text
;                                Omitting a colour parameter or setting it to -1 leaves it unchanged
;                                Setting a colour parameter to Default resets the system colour
;                  $iFont_Size - [Optional] The font size in points to use for the Toast
;                  $sFont_Name - [Optional] The font to use for the Toast
;                       >>>>>    Omitting a font parameter, setting size to -1 or name to "" leaves it unchanged     <<<<<
;                       >>>>>    Setting a font parameter to Default resets the system message box font or size      <<<<<
;                  $iTime_Out  - [Optional] Time in ms for Toast to extend (default 1000ms)
;                  $iTime_In   - [Optional] Time in ms for Toast to retract (default 500ms)
; Requirement(s).: v3.3.2.0 or higher - AdlibRegister/Unregister used in _Toast_Show
; Return values .: Success - Returns 1
;                  Failure - Returns 0 and sets @error to 1 with @extended set to parameter index number
; Author ........: Melba23
; Example........; Yes
;=====================================================================================================================
Func _Toast_Set($vJust, $iHdr_BkCol = -1, $iHdr_Col = -1, $iMsg_BkCol = -1, $iMsg_Col = -1, $iFont_Size = -1, $sFont_Name = "", $iTime_Out = 1000, $iTime_In = 500)

	; Set parameters
	Switch $vJust
		Case Default
			$iToast_Style = 1; $SS_CENTER
			$aRet = DllCall("User32.dll", "int", "GetSysColor", "int", 8) ; $COLOR_WINDOWTEXT = 8
			$iToast_Header_BkCol = $aRet[0]
			$aRet = DllCall("User32.dll", "int", "GetSysColor", "int", 5) ; $COLOR_WINDOW = 5
			$iToast_Header_Col = $aRet[0]
			$iToast_Message_BkCol = $iToast_Header_Col
			$iToast_Message_Col = $iToast_Header_BkCol
			$sToast_Font_Name = $sDef_Toast_Font_Name
			$iToast_Font_Size = $iDef_Toast_Font_Size
			$iToast_Time_Out = 1000
			$iToast_Time_In = 500
			Return
		Case 0, 1, 2, 4, 5, 6
			$iToast_Style = $vJust
		Case -1
			; Do nothing
		Case Else
			Return SetError(1, 1, 0)
	EndSwitch

	Switch $iHdr_BkCol
		Case Default
			$aRet = DllCall("User32.dll", "int", "GetSysColor", "int", 8) ; $COLOR_WINDOWTEXT = 8
			$iToast_Header_BkCol = $aRet[0]
		Case 0 To 0xFFFFFF
			$iToast_Header_BkCol = Int($iHdr_BkCol)
		Case -1
			; Do nothing
		Case Else
			Return SetError(1, 2, 0)
	EndSwitch

	Switch $iHdr_Col
		Case Default
			$aRet = DllCall("User32.dll", "int", "GetSysColor", "int", 5) ; $COLOR_WINDOW = 5
			$iToast_Header_Col = $aRet[0]
		Case 0 To 0xFFFFFF
			$iToast_Header_Col = Int($iHdr_Col)
		Case -1
			; Do nothing
		Case Else
			Return SetError(1, 3, 0)
	EndSwitch

	Switch $iMsg_BkCol
		Case Default
			$aRet = DllCall("User32.dll", "int", "GetSysColor", "int", 5) ; $COLOR_WINDOW = 5
			$iToast_Message_BkCol = $aRet[0]
		Case 0 To 0xFFFFFF
			$iToast_Message_BkCol = Int($iMsg_BkCol)
		Case -1
			; Do nothing
		Case Else
			Return SetError(1, 4, 0)
	EndSwitch

	Switch $iMsg_Col
		Case Default
			$aRet = DllCall("User32.dll", "int", "GetSysColor", "int", 8) ; $COLOR_WINDOWTEXT = 8
			$iToast_Message_Col = $aRet[0]
		Case 0 To 0xFFFFFF
			$iToast_Message_Col = Int($iMsg_Col)
		Case -1
			; Do nothing
		Case Else
			Return SetError(1, 5, 0)
	EndSwitch

	Switch $iFont_Size
		Case Default
			$iToast_Font_Size = $iDef_Toast_Font_Size
		Case 8 To 72
			$iToast_Font_Size = Int($iFont_Size)
		Case -1
			; Do nothing
		Case Else
			Return SetError(1, 6, 0)
	EndSwitch

	Switch $sFont_Name
		Case Default
			$sToast_Font_Name = $sDef_Toast_Font_Name
		Case ""
			; Do nothing
		Case Else
			If IsString($sFont_Name) Then
				$sToast_Font_Name = $sFont_Name
			Else
				Return SetError(1, 7, 0)
			EndIf
	EndSwitch

	If Number($iTime_Out) Then
		$iToast_Time_Out = Int($iTime_Out)
	EndIf

	If Number($iTime_In) Then
		$iToast_Time_In = Int($iTime_In)
	EndIf

	Return 1

EndFunc   ;==>_Toast_Set

; #FUNCTION# =========================================================================================================
; Name...........: _Toast_Show
; Description ...: Shows a slice message from the systray
; Syntax.........: _Toast_Show($vIcon, $sTitle, $sMessage, [$iDelay [, $fWait [, $fRaw ]]])
; Parameters ....: $vIcon    - 0 - No icon, 8 - UAC, 16 - Stop, 32 - Query, 48 - Exclamation, 64 - Information
;                              The $MB_ICON constant can also be used for the last 4 above
;                              If set to the name of an exe, the main icon of that exe will be displayed
;                              If set to the name of an image file, that image will be displayed
;                              Any other value returns -1, error 1
;                  $sTitle   - Text to display on Title bar
;                  $sMessage - Text to display in Toast body
;                  $iDelay   - The delay in seconds before the Toast retracts or script continues (Default = 0)
;                              If negative, an [X] is added to the title bar. Clicking [X] retracts/continues immediately
;                  $fWait    - True  - Script waits for delay time before continuing and Toast remains visible
;                              False - Script continues and Toast retracts automatically after delay time
;                  $fRaw     - True  - Message is not wrapped and Toast expands to show full width
;                            - False - Message is wrapped if over max preset Toast width
; Requirement(s).: v3.3.1.5 or higher - AdlibRegister/Unregister used in _Toast_Show
; Return values .: Success:      Returns 3-element array: [Toast width, Toast height, Text line height]
;                  Intermediate: Returns 0 New Toast with previous Toast retracting
;                  Failure:	     Returns -1 and sets @error as follows:
;                                       1 = Toast GUI creation failed
;                                       2 = Taskbar not found
;                                       3 = StringSize error
;                                       4 = When using Raw, the Toast is too wide for the display
; Author ........: Melba23, based on some original code by GioVit for the Toast
; Notes .........; Any visible Toast is retracted by a subsequent _Toast_Hide or _Toast_Show, or clicking a visible [X].
;                  If previous Toast is retracting then new Toast creation delayed until retraction complete
; Example........; Yes
;=====================================================================================================================
Func _Toast_Show($vIcon, $sTitle, $sMessage, $iDelay = 0, $fWait = True, $fRaw = False)

	; If previous Toast retracting must wait until process is completed
	If $fToast_Retracting Then
		; Store parameters
		$vIcon_Retraction = $vIcon
		$sTitle_Retraction = $sTitle
		$sMessage_Retraction = $sMessage
		$iDelay_Retraction = $iDelay
		$fWait_Retraction = $fWait
		$fRaw_Retraction = $fRaw
		; Keep looking to see if previous Toast retracted
		AdlibRegister("__Toast_Retraction_Check", 100)
		; Explain situation to user
		Return SetError(5, 0, -1)
	EndIf

	; Store current GUI mode and set Message mode
	Local $nOldOpt = Opt('GUIOnEventMode', 0)

	; Retract any Toast already in place
	If $hToast_Handle <> 0 Then _Toast_Hide()

	; Reset non-reacting Close [X] ControlID
	$hToast_Close_X = 9999

	; Set default auto-sizing Toast widths
	Local $iToast_Width_max = 500
	Local $iToast_Width_min = 150

	; Check for icon
	Local $iIcon_Style = 0
	Local $iIcon_Reduction = 36
	Local $sDLL = "user32.dll"
	Local $sImg = ""
	If StringIsDigit($vIcon) Then
		Switch $vIcon
			Case 0
				$iIcon_Reduction = 0
			Case 8
				$sDLL = "imageres.dll"
				$iIcon_Style = 78
			Case 16 ; Stop
				$iIcon_Style = -4
			Case 32 ; Query
				$iIcon_Style = -3
			Case 48 ; Exclam
				$iIcon_Style = -2
			Case 64 ; Info
				$iIcon_Style = -5
			Case Else
				Return SetError(1, 0, -1)
		EndSwitch
	Else
		Switch StringLower(StringRight($vIcon, 3))
			Case "exe", "ico"
				$sDLL = $vIcon
				$iIcon_Style = 0
			Case "bmp", "jpg", "gif", "png"
				$sImg = $vIcon
		EndSwitch
	EndIf

	; Determine max message width
	Local $iMax_Label_Width = $iToast_Width_max - 20 - $iIcon_Reduction
	If $fRaw = True Then $iMax_Label_Width = 0

	; Get message label size
	Local $aLabel_Pos = _StringSize($sMessage, $iToast_Font_Size, Default, Default, $sToast_Font_Name, $iMax_Label_Width)
	If @error Then
		$nOldOpt = Opt('GUIOnEventMode', $nOldOpt)
		Return SetError(3, 0, -1)
	EndIf

	; Reset text to match rectangle
	$sMessage = $aLabel_Pos[0]

	;Set line height for this font
	Local $iLine_Height = $aLabel_Pos[1]

	; Set label size
	Local $iLabelwidth = $aLabel_Pos[2]
	Local $iLabelheight = $aLabel_Pos[3]

	; Set Toast size
	Local $iToast_Width = $iLabelwidth + 20 + $iIcon_Reduction
	; Check if Toast will fit on screen
	If $iToast_Width > @DesktopWidth - 20 Then
		$nOldOpt = Opt('GUIOnEventMode', $nOldOpt)
		Return SetError(4, 0, -1)
	EndIf
	; Increase if below min size
	If $iToast_Width < $iToast_Width_min + $iIcon_Reduction Then
		$iToast_Width = $iToast_Width_min + $iIcon_Reduction
		$iLabelwidth = $iToast_Width_min - 20
	EndIf

	; Set title bar height - with minimum for [X]
	Local $iTitle_Height = 0
	If $sTitle = "" Then
		If $iDelay < 0 Then $iTitle_Height = 6
	Else
		$iTitle_Height = $iLine_Height + 2
		If $iDelay < 0 Then
			If $iTitle_Height < 17 Then $iTitle_Height = 17
		EndIf
	EndIf

	; Set Toast height as label height + title bar + bottom margin
	Local $iToast_Height = $iLabelheight + $iTitle_Height + 20
	; Ensure enough room for icon if displayed
	If $iIcon_Reduction Then
		If $iToast_Height < $iTitle_Height + 42 Then $iToast_Height = $iTitle_Height + 47
	EndIf

	; Get Toast starting position and direction
	Local $aToast_Data = __Toast_Locate($iToast_Width, $iToast_Height)

	; Create Toast slice with $WS_POPUPWINDOW, $WS_EX_TOOLWINDOW style and $WS_EX_TOPMOST extended style
	$hToast_Handle = GUICreate("", $iToast_Width, $iToast_Height, $aToast_Data[0], $aToast_Data[1], 0x80880000, BitOR(0x00000080, 0x00000008))
	If @error Then
		$nOldOpt = Opt('GUIOnEventMode', $nOldOpt)
		Return SetError(1, 0, -1)
	EndIf
	GUISetFont($iToast_Font_Size, Default, Default, $sToast_Font_Name)
	GUISetBkColor($iToast_Message_BkCol)

	; Set centring parameter
	Local $iLabel_Style = 0 ; $SS_LEFT
	If BitAND($iToast_Style, 1) = 1 Then
		$iLabel_Style = 1 ; $SS_CENTER
	ElseIf BitAND($iToast_Style, 2) = 2 Then
		$iLabel_Style = 2 ; $SS_RIGHT
	EndIf

	; Check installed fonts
	Local $sX_Font = "WingDings"
	Local $sX_Char = "x"
	Local $i = 1
	While 1
		Local $sInstalled_Font = RegEnumVal("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts", $i)
		If @error Then ExitLoop
		If StringInStr($sInstalled_Font, "WingDings 2") Then
			$sX_Font = "WingDings 2"
			$sX_Char = "T"
		EndIf
		$i += 1
	WEnd

	; Create title bar if required
	If $sTitle <> "" Then

		; Create disabled background strip
		GUICtrlCreateLabel("", 0, 0, $iToast_Width, $iTitle_Height)
		GUICtrlSetBkColor(-1, $iToast_Header_BkCol)
		GUICtrlSetState(-1, 128) ; $GUI_DISABLE

		; Set title bar width to offset text
		Local $iTitle_Width = $iToast_Width - 10

		; Create closure [X] if needed
		If $iDelay < 0 Then
			; Create [X]
			Local $iX_YCoord = Int(($iTitle_Height - 17) / 2)
			$hToast_Close_X = GUICtrlCreateLabel($sX_Char, $iToast_Width - 18, $iX_YCoord, 17, 17)
			GUICtrlSetFont(-1, 14, Default, Default, $sX_Font)
			GUICtrlSetBkColor(-1, -2) ; $GUI_BKCOLOR_TRANSPARENT
			GUICtrlSetColor(-1, $iToast_Header_Col)
			; Reduce title bar width to allow [X] to activate
			$iTitle_Width -= 18
		EndIf

		; Create Title label with bold text, centred vertically in case bar is higher than line
		GUICtrlCreateLabel($sTitle, 10, 0, $iTitle_Width, $iTitle_Height, 0x0200) ; $SS_CENTERIMAGE
		GUICtrlSetBkColor(-1, $iToast_Header_BkCol)
		GUICtrlSetColor(-1, $iToast_Header_Col)
		If BitAND($iToast_Style, 4) = 4 Then GUICtrlSetFont(-1, $iToast_Font_Size, 600)

	Else

		If $iDelay < 0 Then
			; Only need [X]
			$hToast_Close_X = GUICtrlCreateLabel($sX_Char, $iToast_Width - 18, 0, 17, 17)
			GUICtrlSetFont(-1, 14, Default, Default, $sX_Font)
			GUICtrlSetBkColor(-1, -2) ; $GUI_BKCOLOR_TRANSPARENT
			GUICtrlSetColor(-1, $iToast_Message_Col)
		EndIf

	EndIf

	; Create icon
	If $iIcon_Reduction Then
		Switch StringLower(StringRight($sImg, 3))
			Case "bmp", "jpg", "gif"
				GUICtrlCreatePic($sImg, 10, 10 + $iTitle_Height, 32, 32)
			Case "png"
				__Toast_ShowPNG($sImg, $iTitle_Height)
			Case Else
				GUICtrlCreateIcon($sDLL, $iIcon_Style, 10, 10 + $iTitle_Height)
		EndSwitch
	EndIf

	; Create Message label
	GUICtrlCreateLabel($sMessage, 10 + $iIcon_Reduction, 10 + $iTitle_Height, $iLabelwidth, $iLabelheight)
	GUICtrlSetStyle(-1, $iLabel_Style)
	If $iToast_Message_Col <> Default Then GUICtrlSetColor(-1, $iToast_Message_Col)

	; Slide Toast Slice into view from behind systray and activate
	DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $hToast_Handle, "int", $iToast_Time_Out, "long", $aToast_Data[2])

	; Activate Toast without stealing focus
	GUISetState(@SW_SHOWNOACTIVATE, $hToast_Handle)

	; If script is to pause
	If $fWait = True Then

	; Clear message queue
		Do
		Until GUIGetMsg() = 0

		; Begin timeout counter
		Local $iTimeout_Begin = TimerInit()

		; Wait for timeout or closure
		While 1
			If GUIGetMsg() = $hToast_Close_X Or TimerDiff($iTimeout_Begin) / 1000 >= Abs($iDelay) Then ExitLoop
		WEnd

		; If script is to continue and delay has been set
	ElseIf Abs($iDelay) > 0 Then

		; Store timer info
		$iToast_Timer = Abs($iDelay * 1000)
		$iToast_Start = TimerInit()

		; Register Adlib function to run timer
		AdlibRegister("__Toast_Timer_Check", 100)
		; Register message handler to check for [X] click
		GUIRegisterMsg(0x0021, "__Toast_WM_EVENTS") ; $WM_MOUSEACTIVATE

	EndIf

	; Reset original mode
	$nOldOpt = Opt('GUIOnEventMode', $nOldOpt)

	; Create array to return Toast dimensions
	Local $aToast_Data[3] = [$iToast_Width, $iToast_Height, $iLine_Height]

	Return $aToast_Data

EndFunc   ;==>_Toast_Show

; #FUNCTION# ========================================================================================================
; Name...........: _Toast_Hide
; Description ...: Hides a slice message from the systray
; Syntax.........: _Toast_Hide()
; Requirement(s).: v3.3.1.5 or higher - AdlibRegister used in _Toast_Show
; Return values .: Success: Returns 0
;                  Failure:	If Toast does not exist returns -1 and sets @error to 1
; Author ........: Melba23
; Example........; Yes
;=====================================================================================================================
Func _Toast_Hide()

	; If no Toast to hide, return
	If $hToast_Handle = 0 Then Return SetError(1, 0, -1)

	; Set retracting flag in case next Toast called during process
	$fToast_Retracting = True

	; Slide Toast back behind systray
	DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $hToast_Handle, "int", $iToast_Time_In, "long", $iToast_Move)
	; Delete Toast slice
	GUIDelete($hToast_Handle)
	; Set flag for "no Toast"
	$hToast_Handle = 0
	; Unregister a possible message handler
	GUIRegisterMsg(0x0021, "") ; $WM_MOUSEACTIVATE
	; Unregister a possible Adlib function
	AdlibUnRegister("__Toast_Timer_Check")
	; Clear flags
	$fToast_Close = False
	$fToast_Retracting = False

EndFunc   ;==>_Toast_Hide

; #INTERNAL_USE_ONLY#============================================================================================================
; Name...........: __Toast_Locate
; Author ........: Melba23 - using some code from guinness and MilesAhead
; Modified.......:
; Remarks .......: This function is used internally by _Toast_Show
; ===============================================================================================================================
Func __Toast_Locate($iToast_Width, $iToast_Height)

	Local $tWorkArea

	; Define return array
	Local $aToast_Data[3]
	; Determine which struct syntax to use to use
	If @AutoItVersion < "3.3.8.0" Then
		$tWorkArea = DllStructCreate("long Left;long Top;long Right;long Bottom")
	Else
		$tWorkArea = DllStructCreate("struct;long Left;long Top;long Right;long Bottom;endstruct")
	EndIf

	; Check if Taskbar is hidden
	Local $aRet = DllCall("shell32.dll", "uint", "SHAppBarMessage", "dword", 0x00000004, "ptr*", 0) ; $ABM_GETSTATE
	If BitAND($aRet[0], 0x01) Then

		; Find hidden taskbar
		Local $iPrevMode = Opt("WinTitleMatchMode", 4)
		Local $aTray_Pos = WinGetPos("[CLASS:Shell_TrayWnd]")
		Opt("WinTitleMatchMode", $iPrevMode)
		; If error in finding systray
		If Not IsArray($aTray_Pos) Then Return SetError(2, 0, -1)

		; Determine direction of Toast motion and starting position
		If $aTray_Pos[1] > 0 Then
			$iToast_Move = 0x00050004 ; $AW_SLIDE_OUT_BOTTOM
			$aToast_Data[0] = @DesktopWidth - $iToast_Width - 10
			$aToast_Data[1] = $aTray_Pos[1] - $iToast_Height - 2
			$aToast_Data[2] = 0x00040008 ; $AW_SLIDE_IN_BOTTOM
		ElseIf $aTray_Pos[0] > 0 Then
			$iToast_Move = 0x00050001 ; $AW_SLIDE_OUT_RIGHT
			$aToast_Data[0] = $aTray_Pos[0] - $iToast_Width - 2
			$aToast_Data[1] = @DesktopHeight - $iToast_Height - 10
			$aToast_Data[2] = 0x00040002 ; $AW_SLIDE_IN_RIGHT
		ElseIf $aTray_Pos[2] > @DesktopWidth - 70 Then
			$iToast_Move = 0x00050008 ; $AW_SLIDE_OUT_TOP
			$aToast_Data[0] = @DesktopWidth - $iToast_Width - 10
			$aToast_Data[1] = $aTray_Pos[1] + $aTray_Pos[3]
			$aToast_Data[2] = 0x00040004 ; $AW_SLIDE_IN_TOP
		ElseIf $aTray_Pos[3] >= @DesktopHeight Then
			$iToast_Move = 0x00050002 ; $AW_SLIDE_OUT_LEFT
			$aToast_Data[0] = $aTray_Pos[0] + $aTray_Pos[2]
			$aToast_Data[1] = @DesktopHeight - $iToast_Height - 10
			$aToast_Data[2] = 0x00040001 ; $AW_SLIDE_IN_LEFT
		EndIf

	Else

		; Determine available work area ; $SPI_GETWORKAREA = 48
		DllCall("user32.dll", "bool", "SystemParametersInfoW", "uint", 48, "uint", 0, "ptr", DllStructGetPtr($tWorkArea), "uint", 0)
		If @error Then Return SetError(2, 0, -1)
		Local $aWorkArea[4] = [DllStructGetData($tWorkArea, "Left"), DllStructGetData($tWorkArea, "Top"), _
				DllStructGetData($tWorkArea, "Right"), DllStructGetData($tWorkArea, "Bottom")]

		; Determine direction of Toast motion and starting position
		If $aWorkArea[3] <> @DesktopHeight Then
			$iToast_Move = 0x00050004 ; $AW_SLIDE_OUT_BOTTOM
			$aToast_Data[0] = @DesktopWidth - $iToast_Width - 10
			$aToast_Data[1] = $aWorkArea[3] - $iToast_Height - 2
			$aToast_Data[2] = 0x00040008 ; $AW_SLIDE_IN_BOTTOM
		ElseIf $aWorkArea[2] <> @DesktopWidth Then
			$iToast_Move = 0x00050001 ; $AW_SLIDE_OUT_RIGHT
			$aToast_Data[0] = $aWorkArea[2] - $iToast_Width - 2
			$aToast_Data[1] = @DesktopHeight - $iToast_Height - 10
			$aToast_Data[2] = 0x00040002 ; $AW_SLIDE_IN_RIGHT
		ElseIf $aWorkArea[1] <> 0 Then
			$iToast_Move = 0x00050008 ; $AW_SLIDE_OUT_TOP
			$aToast_Data[0] = @DesktopWidth - $iToast_Width - 10
			$aToast_Data[1] = $aWorkArea[1]
			$aToast_Data[2] = 0x00040004 ; $AW_SLIDE_IN_TOP
		ElseIf $aWorkArea[0] <> 0 Then
			$iToast_Move = 0x00050002 ; $AW_SLIDE_OUT_LEFT
			$aToast_Data[0] = $aWorkArea[0]
			$aToast_Data[1] = @DesktopHeight - $iToast_Height - 10
			$aToast_Data[2] = 0x00040001 ; $AW_SLIDE_IN_LEFT
		EndIf

	EndIf

	Return $aToast_Data

EndFunc   ;==>__Toast_Locate

; #INTERNAL_USE_ONLY#============================================================================================================
; Name...........: __Toast_Timer_Check
; Author ........: Melba23
; Modified.......:
; Remarks .......: This function is used internally by _Toast_Show if the Wait parameter is set to False
; ===============================================================================================================================
Func __Toast_Timer_Check()

	; Check if timeout elapsed or [X] clicked
	If TimerDiff($iToast_Start) >= $iToast_Timer Or $fToast_Close Then
		; Retract slice
		_Toast_Hide()
	EndIf

EndFunc   ;==>__Toast_Timer_Check

; #INTERNAL_USE_ONLY#============================================================================================================
; Name...........: __Toast_Retraction_Check
; Author ........: Melba23
; Modified.......:
; Remarks .......: This function is used internally by _Toast_Show if retraction of previous Toast was in progress
; ===============================================================================================================================
Func __Toast_Retraction_Check()

	If Not $fToast_Retracting Then
		AdlibUnRegister("__Toast_Retraction_Check")
		_Toast_Show($vIcon_Retraction, $sTitle_Retraction, $sMessage_Retraction, $iDelay_Retraction, $fWait_Retraction, $fRaw_Retraction)
	EndIf

EndFunc

; #INTERNAL_USE_ONLY#============================================================================================================
; Name...........: __Toast_WM_EVENTS
; Description ...: Message handler to check if closure [X] clicked
; Author ........: Melba23
; Modified.......:
; Remarks .......: This function is used internally by _Toast_Show if the Wait parameter is set to False
; ===============================================================================================================================
Func __Toast_WM_EVENTS($hWnd, $Msg, $wParam, $lParam)

	#forceref $wParam, $lParam
	If $hWnd = $hToast_Handle Then
		If $Msg = 0x0021 Then ; $WM_MOUSEACTIVATE
			; Check mouse position
			Local $aPos = GUIGetCursorInfo($hToast_Handle)
			If $aPos[4] = $hToast_Close_X Then $fToast_Close = True
		EndIf
	EndIf
	Return 'GUI_RUNDEFMSG'

EndFunc   ;==>__Toast_WM_EVENTS

; #INTERNAL_USE_ONLY#============================================================================================================
; Name...........: __Toast_GetDefFont
; Author ........: Melba23
; Modified.......:
; Remarks .......: This function is used internally by _Toast functions
; ===============================================================================================================================
Func __Toast_GetDefFont($iData)

	; Get default system font data
	Local $tNONCLIENTMETRICS = DllStructCreate("uint;int;int;int;int;int;byte[60];int;int;byte[60];int;int;byte[60];byte[60];byte[60]")
	DllStructSetData($tNONCLIENTMETRICS, 1, DllStructGetSize($tNONCLIENTMETRICS))
	DllCall("user32.dll", "int", "SystemParametersInfo", "int", 41, "int", DllStructGetSize($tNONCLIENTMETRICS), "ptr", DllStructGetPtr($tNONCLIENTMETRICS), "int", 0)
	; Read font data for MsgBox font
	Local $tLOGFONT = DllStructCreate("long;long;long;long;long;byte;byte;byte;byte;byte;byte;byte;byte;char[32]", DllStructGetPtr($tNONCLIENTMETRICS, 15))
	Switch $iData
		Case 0
			; Font size as integer
			Return Int((Abs(DllStructGetData($tLOGFONT, 1)) + 1) * .75)
		Case 1
			; Font name
			Return DllStructGetData($tLOGFONT, 14)
	EndSwitch

EndFunc   ;==>__Toast_GetDefFont

; #INTERNAL_USE_ONLY#============================================================================================================
; Name...........: __Toast_ShowPNG
; Author ........: UEZ
; Modified.......: Melba23, guinness
; Remarks .......:
; ===============================================================================================================================
Func __Toast_ShowPNG($sImg, $iTitle_Height)

	_GDIPlus_Startup()
	Local $hPic = GUICtrlCreatePic("", 10, 10 + $iTitle_Height, 32, 32)
	Local $hBitmap = _GDIPlus_BitmapCreateFromFile($sImg)
    Local $hBitmap_Resized = _GDIPlus_BitmapCreateFromScan0(32, 32)
	Local $hBMP_Ctxt = _GDIPlus_ImageGetGraphicsContext($hBitmap_Resized)
	_GDIPlus_GraphicsSetInterpolationMode($hBMP_Ctxt, 7)
    _GDIPlus_GraphicsDrawImageRect($hBMP_Ctxt, $hBitmap, 0, 0, 32, 32)
    Local $hHBitmap = __Toast_BitmapCreateDIB($hBitmap_Resized)
    _WinAPI_DeleteObject(GUICtrlSendMsg($hPic, 0x0172, 0, $hHBitmap)) ; $STM_SETIMAGE
    _GDIPlus_BitmapDispose($hBitmap)
    _GDIPlus_BitmapDispose($hBitmap_Resized)
    _GDIPlus_GraphicsDispose($hBMP_Ctxt)
    _WinAPI_DeleteObject($hHBitmap)
    _GDIPlus_Shutdown()

EndFunc   ;==>__Toast_ShowPNG

; #INTERNAL_USE_ONLY#============================================================================================================
; Name...........: __Toast_BitmapCreateDIB
; Author ........: UEZ
; Modified.......:
; Remarks .......:
; ===============================================================================================================================
Func __Toast_BitmapCreateDIB($hBitmap)

	Local $hRet = 0

	Local $aRet1 = DllCall($__g_hGDIPDll, "uint", "GdipGetImageDimension", "ptr", $hBitmap, "float*", 0, "float*", 0)
	If (@error) Or ($aRet1[0]) Then Return 0
	Local $tData = _GDIPlus_BitmapLockBits($hBitmap, 0, 0, $aRet1[2], $aRet1[3], $GDIP_ILMREAD, $GDIP_PXF32ARGB)
	Local $pBits = DllStructGetData($tData, "Scan0")
	If Not $pBits Then Return 0
	Local $tBIHDR = DllStructCreate("dword;long;long;ushort;ushort;dword;dword;long;long;dword;dword")
	DllStructSetData($tBIHDR, 1, DllStructGetSize($tBIHDR))
	DllStructSetData($tBIHDR, 2, $aRet1[2])
	DllStructSetData($tBIHDR, 3, $aRet1[3])
	DllStructSetData($tBIHDR, 4, 1)
	DllStructSetData($tBIHDR, 5, 32)
	DllStructSetData($tBIHDR, 6, 0)
	Local $aRet2 = DllCall("gdi32.dll", "ptr", "CreateDIBSection", "hwnd", 0, "ptr", DllStructGetPtr($tBIHDR), "uint", 0, "ptr*", 0, "ptr", 0, "dword", 0)
	If (Not @error) And ($aRet2[0]) Then
		DllCall("gdi32.dll", "dword", "SetBitmapBits", "ptr", $aRet2[0], "dword", $aRet1[2] * $aRet1[3] * 4, "ptr", DllStructGetData($tData, "Scan0"))
		$hRet = $aRet2[0]
	EndIf
	_GDIPlus_BitmapUnlockBits($hBitmap, $tData)
	Return $hRet
EndFunc   ;==>__Toast_BitmapCreateDIB