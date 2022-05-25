#include-once

; #INDEX# =======================================================================================================================
; Title .........: GuiFlatButton
; AutoIt Version : 3.3.16.0
; Description ...: Create flat buttons with custom colors
;
; Remarks .......: - The control ID returned by this function can be used with GUIGetMsg or GUICtrlSetOnEvent
;				   - For button manipulation, use the UDF functions GuiFlatButton_SetState, etc...
;						Any button functions not wrapped in this UDF may or may not work as intended as they were not tested.
;				   - Uses subclassing to handle windows messages:
;						- WM_DRAWITEM:  	Custom button drawing
;						- WM_MOUSEMOVE:  	Detect mouse hover
;						- WM_MOUSELEAVE:  	Detect mouse leave (end hover)
;						- WM_LBUTTONDBLCLK:	Disable double-clicking (allows rapid clicking)
;						- BM_SETIMAGE:		Icons on button
;						- WM_NCHITTEST:		Disable dragging of buttons
;						- WM_DESTROY:		Handle GUI deleted before exiting script
;				   - Any message handlers used elsewhere in the script will not interfere with the functionality of this UDF.
;
; Author(s) .....: kurtykurtyboy
;
; Credits .......: Melba23 (UDF template), LarsJ (general subclassing code), funkey (_WinAPI_DrawState),
;				   4ggr35510n (TrackMouseEvent example), binhnx (disable dragging with $WS_EX_CONTROLPARENT)
;
; Revisions
;  05/24/2022 ...: - Fixed issue releasing subclassing when GUI is deleted but program is not closed
;				   - Fixed occassional white background flicker
;                  - Added function GuiFlatButton_GetPos
;  01/02/2021 ...: - Fixed bug, not working after deleting a GUI with buttons on it
;                  - Fixed bug, changing default colors
;  04/12/2019 ...: - Fixed bug, not showing pressed down state when clicking rapidly
;				   - Added Icon/Bitmap support
;				   - Added function GuiFlatButton_SetPos to change the position and/or size of a button
;  02/09/2019 ...: - Added GuiFlatButton_SetDefaultColors and GuiFlatButton_SetDefaultColorsEx to set the button colors globally for all future buttons.
;
; Functions
;  GuiFlatButton_Create ................: Create a new flat button
;  GuiFlatButton_Remove ................: Remove the control from the array only
;  GuiFlatButton_Read ..................: Read the display text of the button
;  GuiFlatButton_SetData ...............: Set the display text of the button
;  GuiFlatButton_SetBkColor ............: Set button background color
;  GuiFlatButton_SetColor ..............: Set button foreground/text color
;  GuiFlatButton_SetColors .............: Set background, foreground, border colors at the same time
;  GuiFlatButton_SetColorsEx ...........: Set background, foreground, border colors for ALL states at the same time
;  GuiFlatButton_SetDefaultColors ......: Set background, foreground, border colors to be used for all future buttons
;  GuiFlatButton_SetDefaultColorsEx ....: Set background, foreground, border colors for ALL states to be used for all future buttons
;  GuiFlatButton_GetState ..............: Get the state of the button
;  GuiFlatButton_SetState ..............: Set the state of the button
;  GuiFlatButton_Delete ................: Remove subclasses and delete the control
;  GuiFlatButton_SetPos ................: Changes the position of a control
;  GuiFlatButton_GetPos ................: Get the position of a control
;
; Functions [INTERNAL USE ONLY]
;  GuiFlatButton_ButtonHandler .........: Handle button-specific messages
;  GuiFlatButton_ChildHandler ..........: Handle button window messages
;  GuiFlatButton_DrawButton ............: Actual drawing of the button
;  _WinAPI_DrawState ...................: Windows API DrawState function
;  GuiFlatButton_Exit ..................: Release any subclasses and delete unused objects
;  GuiFlatButton_getParent .............: Get parent window handle
;  GuiFlatButton_getSize ...............: Get size of the new button
;  GuiFlatButton_prevControlId .........: Get controlID of the previously created control
;  GuiFlatButton_FindControlId .........; Get array index from ControlId
; ===============================================================================================================================

; #INCLUDES# =========================================================================================================
#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <WinAPI.au3>
#include <WindowsConstants.au3>

OnAutoItExitRegister("GuiFlatButton_Exit")

; #GLOBAL VARIABLES# =================================================================================================
Global Const $BS_TOOLBUTTON = 4096

Global Const $DST_ICON = 0x03
Global Const $DST_BITMAP = 0x04
Global Const $DSS_NORMAL = 0x00
Global Const $DSS_UNION = 0x10
Global Const $DSS_DISABLED = 0x20
Global Const $DSS_MONO = 0x80

Global $aGuiFlatButton[1][21]
$aGuiFlatButton[0][0] = 0
$aGuiFlatButton[0][1] = DllCallbackRegister("GuiFlatButton_ButtonHandler", "lresult", "hwnd;uint;wparam;lparam;uint_ptr;dword_ptr")
$aGuiFlatButton[0][2] = DllCallbackRegister("GuiFlatButton_ChildHandler", "lresult", "hwnd;uint;wparam;lparam;uint_ptr;dword_ptr")
; [0][0]  = Number of subclassed buttons	   			 [n][0]   = Index in $aGuiFlatButton array
; [0][1]  = Handle to button callback function      	 [n][1]   = Control ID
; [0][2]  = Handle to button window callback function    [n][2]   = pointer to button callback
; [0][3]  = Default button colors	           			 [n][3]   = pointer to button window callback
;                       				       			 [n][4]   = mouse tracking status bit
;				                               			 [n][5]   = background color
;				                               			 [n][6]   = text color
;				                               			 [n][7]   = border color
;				                               			 [n][8]   = background color (focus)
;				                               			 [n][9]   = text color (focus)
;				                               			 [n][10]  = border color (focus)
;				                               			 [n][11]  = background color (hover)
;				                               			 [n][12]  = text color (hover)
;				                               			 [n][13]  = border color (hover)
;				                               			 [n][14]  = background color (selected/pressed)
;				                               			 [n][15]  = text color (selected/pressed)
;				                               			 [n][16]  = border color (selected/pressed)
;				                               			 [n][17]  = text data
;				                               			 [n][18]  = icon Type ($IMAGE_ICON or $IMAGE_BITMAP)
;				                               			 [n][19]  = handle to icon/bitmap
;				                               			 [n][20]  = button style


; #FUNCTION# =========================================================================================================
; Name...........: GuiFlatButton_Create
; Description ...: Create a new flat button
; Syntax.........: GuiFlatButton_Create( $text, $x, $y [, $w [, $h ]] )
; Parameters ....: $text     	  - The text of the button control.
;                  $x     	  	  - The left side of the control. If -1 is used then left will be computed according to GUICoordMode.
;                  $y     	  	  - The top of the control. If -1 is used then top will be computed according to GUICoordMode.
;                  $w     	  	  - The width of the control (default text autofit in width).
;                  $h     	  	  - The height of the control (default text autofit in height).
; Return values .: Control ID of the button
; Author ........: kurtykurtyboy
; Modified ......:
; Remarks .......: - The control ID returned by this function can be used with GUIGetMsg or GUICtrlSetOnEvent
;				   - For button manipulation, use the UDF functions GuiFlatButton_SetState, etc...
;=====================================================================================================================
Func GuiFlatButton_Create($sText, $x, $y, $w = -1, $h = -1, $style = 0)

	If Not IsArray($aGuiFlatButton[0][3]) Then
		Local $aColors[12] = [-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1]
		$aGuiFlatButton[0][3] = $aColors
	EndIf


	;get parent window handle
	Local $parentHWND = GuiFlatButton_getParent()

	Local $aCalcSize = GuiFlatButton_getSize($sText)
	If $x == Default Or $x == -1 Then
		$x = $aCalcSize[0]
	EndIf
	If $y == Default Or $y == -1 Then
		$y = $aCalcSize[1]
	EndIf

	If $w == Default Or $w == -1 Then
		$w = $aCalcSize[2]
	EndIf
	If $h == Default Or $h == -1 Then
		$h = $aCalcSize[3]
	EndIf

	;create child gui to hold the button (for subclassing)
	Local $childHWND = GUICreate("", $w, $h, $x, $y, BitOR($WS_CHILD, $WS_CLIPCHILDREN, $WS_CLIPSIBLINGS), $WS_EX_CONTROLPARENT, $parentHWND)
	_WinAPI_SetWindowPos($childHWND, $HWND_TOP, 0, 0, 0, 0, BitOR($SWP_NOMOVE, $SWP_NOSIZE))
	GUISetState(@SW_SHOWNOACTIVATE)
	;create the new button
	$buttonID = GUICtrlCreateButton("", 0, 0, $w, $h)
	GUICtrlSetStyle($buttonID, BitOR($WS_TABSTOP, $BS_NOTIFY, $BS_OWNERDRAW)) ; Set the ownerdrawn flag
	GUICtrlSetData($buttonID, $sText)

	;check to see if control ID exists (which means it has been deleted outside of this UDF)
	$idIndex = GuiFlatButton_FindControlId($buttonID)
	If $idIndex <> -1 Then
		GuiFlatButton_Remove($idIndex)
	EndIf

	; See if there is a blank line available in the array
	Local $iIndex = 0
	For $i = 1 To $aGuiFlatButton[0][0]
		If $aGuiFlatButton[$i][0] == 0 Then
			$iIndex = $i
			ExitLoop
		EndIf
	Next
	; If no blank line found then increase array size
	If $iIndex == 0 Then
		$aGuiFlatButton[0][0] += 1
		ReDim $aGuiFlatButton[$aGuiFlatButton[0][0] + 1][UBound($aGuiFlatButton, 2)]
	EndIf

	;set default parameters
	;fill the array with the default values
	$aGuiFlatButton[$i][0] = $i
	$aGuiFlatButton[$i][4] = False
	$aGuiFlatButton[$i][17] = $sText
	$aColors = $aGuiFlatButton[0][3]
	For $j = 5 To 16
		$aGuiFlatButton[$i][$j] = $aColors[$j - 5]
	Next
	$aGuiFlatButton[$i][18] = Null
	$aGuiFlatButton[$i][19] = Null
	$aGuiFlatButton[$i][20] = $style


	$aGuiFlatButton[$i][1] = $buttonID

	;subclass the button for WM_MOUSEMOVE, WM_MOUSELEAVE, and WM_MOUSELEAVE events
	$aGuiFlatButton[$i][2] = DllCallbackGetPtr($aGuiFlatButton[0][1])
	DllCall("comctl32.dll", "bool", "SetWindowSubclass", "hwnd", GUICtrlGetHandle($aGuiFlatButton[$i][1]), "ptr", $aGuiFlatButton[$i][2], "uint_ptr", $i, "dword_ptr", 0)

	;subclass the child window (button parent) to handle WM_DRAWITEM event
	$aGuiFlatButton[$i][3] = DllCallbackGetPtr($aGuiFlatButton[0][2])
	DllCall("comctl32.dll", "bool", "SetWindowSubclass", "hwnd", $childHWND, "ptr", $aGuiFlatButton[$i][3], "uint_ptr", $i, "dword_ptr", 0) ; $iSubclassId = $i, $pData = 0

	_WinAPI_InvalidateRect($childHWND)
	GUISwitch($parentHWND)

	If GUICtrlGetState($aGuiFlatButton[$i][1]) == $GUI_FOCUS Then GUICtrlSetState($aGuiFlatButton[$i][1], $GUI_FOCUS)
	Return $aGuiFlatButton[$i][1] ;button control ID
EndFunc   ;==>GuiFlatButton_Create

; #FUNCTION# =========================================================================================================
; Name...........: GuiFlatButton_Remove
; Description ...: Remove the control from array only
; Syntax.........: GuiFlatButton_Remove( $ControlIndex )
; Parameters ....: $ControlIndex     - The index of the control to be removed
; Return values .: 1 - Success
;				   0 - Failure
; Author ........: kurtykurtyboy
; Modified ......:
;=====================================================================================================================
Func GuiFlatButton_Remove($ControlIndex)
	For $j = 0 To UBound($aGuiFlatButton, 2) - 1
		$aGuiFlatButton[$ControlIndex][$j] = 0
	Next

	Return 1
EndFunc   ;==>GuiFlatButton_Remove

; #FUNCTION# =========================================================================================================
; Name...........: GuiFlatButton_Read
; Description ...: Read the display text of the button
; Syntax.........: GuiFlatButton_Read( $controlID )
; Parameters ....: $controlID     - The controlID as returned by GuiFlatButton_Create
; Return values .: Display text of the button
; Author ........: kurtykurtyboy
; Modified ......:
;=====================================================================================================================
Func GuiFlatButton_Read($controlID)
	If Not $aGuiFlatButton[0][0] Then Return 0
	$controlID = GuiFlatButton_prevControlId($controlID)

	Local $sText = GUICtrlRead($controlID)

	Return $sText
EndFunc   ;==>GuiFlatButton_Read

; #FUNCTION# =========================================================================================================
; Name...........: GuiFlatButton_SetData
; Description ...: Set the button display text
; Syntax.........: GuiFlatButton_SetData($controlID, $sText)
; Parameters ....: $controlID     - The controlID as returned by GuiFlatButton_Create
;				   $sText		  - Replaces the text
; Return values .: 1 - Success
;				   0 - Failure
; Author ........: kurtykurtyboy
; Modified ......:
;=====================================================================================================================
Func GuiFlatButton_SetData($controlID, $sText)
	If Not $aGuiFlatButton[0][0] Then Return 0
	$controlID = GuiFlatButton_prevControlId($controlID)

	Local $ControlIndex = GuiFlatButton_FindControlId($controlID)
	If $ControlIndex = -1 Then Return -1

	GUICtrlSetData($controlID, $sText)
	$aGuiFlatButton[$ControlIndex][17] = $sText

	_WinAPI_InvalidateRect(GUICtrlGetHandle($controlID), False)

	Return 1
EndFunc   ;==>GuiFlatButton_SetData

; #FUNCTION# =========================================================================================================
; Name...........: GuiFlatButton_SetBkColor
; Description ...: Set the background color
; Syntax.........: GuiFlatButton_SetBkColor($controlID, $color)
; Parameters ....: $controlID     - The controlID as returned by GuiFlatButton_Create
;				   $color		  - background color
; Return values .: 1 - Success
;				   0 - controlID not found
; Author ........: kurtykurtyboy
; Modified ......:
;=====================================================================================================================
Func GuiFlatButton_SetBkColor($controlID, $color)
	If Not $aGuiFlatButton[0][0] Then Return 0
	$controlID = GuiFlatButton_prevControlId($controlID)

	Local $ControlIndex = GuiFlatButton_FindControlId($controlID)
	If $ControlIndex = -1 Then Return -1

	If $color == Default Or $color == -1 Then
		$aGuiFlatButton[$ControlIndex][5] = -1
	Else
		$aGuiFlatButton[$ControlIndex][5] = _WinAPI_SwitchColor($color)
	EndIf

	_WinAPI_InvalidateRect(GUICtrlGetHandle($controlID))

	Return 1
EndFunc   ;==>GuiFlatButton_SetBkColor

; #FUNCTION# =========================================================================================================
; Name...........: GuiFlatButton_SetColor
; Description ...: Set the foreground (text) color
; Syntax.........: GuiFlatButton_SetColor($controlID, $color)
; Parameters ....: $controlID     - The controlID as returned by GuiFlatButton_Create
;				   $color		  - foreground color
; Return values .: 1 - Success
;				   0 - controlID not found
; Author ........: kurtykurtyboy
; Modified ......:
;=====================================================================================================================
Func GuiFlatButton_SetColor($controlID, $color)
	If Not $aGuiFlatButton[0][0] Then Return 0
	$controlID = GuiFlatButton_prevControlId($controlID)

	Local $ControlIndex = GuiFlatButton_FindControlId($controlID)
	If $ControlIndex = -1 Then Return -1

	If $color == Default Or $color == -1 Then
		$aGuiFlatButton[$ControlIndex][6] = -1
	Else
		$aGuiFlatButton[$ControlIndex][6] = _WinAPI_SwitchColor($color)
	EndIf

	_WinAPI_InvalidateRect(GUICtrlGetHandle($controlID))

	Return 1
EndFunc   ;==>GuiFlatButton_SetColor

; #FUNCTION# =========================================================================================================
; Name...........: GuiFlatButton_SetColors
; Description ...: Set the base button colors
; Syntax.........: GuiFlatButton_SetColors($controlID [, $bkColor = -1 [, $foreColor = -1 [, $borderColor = -1 ]]])
; Parameters ....: $controlID     - The controlID as returned by GuiFlatButton_Create
;				   $bkColor		  - background color (-1 for auto)
;				   $foreColor	  - text color (-1 for auto)
;				   $borderColor	  - border color (-1 for auto)
; Return values .: 1 - Success
;				   0 - controlID not found
; Author ........: kurtykurtyboy
; Modified ......:
;=====================================================================================================================
Func GuiFlatButton_SetColors($controlID, $bkColor = -1, $foreColor = -1, $borderColor = -1)
	If Not $aGuiFlatButton[0][0] Then Return 0
	$controlID = GuiFlatButton_prevControlId($controlID)

	Local $ControlIndex = GuiFlatButton_FindControlId($controlID)
	If $ControlIndex = -1 Then Return -1

	If $bkColor == Default Or $bkColor == -1 Then
		$aGuiFlatButton[$ControlIndex][5] = -1
	Else
		$aGuiFlatButton[$ControlIndex][5] = _WinAPI_SwitchColor($bkColor)
	EndIf

	If $foreColor == Default Or $foreColor == -1 Then
		$aGuiFlatButton[$ControlIndex][6] = -1
	Else
		$aGuiFlatButton[$ControlIndex][6] = _WinAPI_SwitchColor($foreColor)
	EndIf

	If $borderColor == Default Or $borderColor == -1 Then
		$aGuiFlatButton[$ControlIndex][7] = -1
	ElseIf $borderColor == $GUI_BKCOLOR_TRANSPARENT Then
		$aGuiFlatButton[$ControlIndex][7] = -2
	Else
		$aGuiFlatButton[$ControlIndex][7] = _WinAPI_SwitchColor($borderColor)
	EndIf

	For $j = 8 To 16
		$aGuiFlatButton[$ControlIndex][$j] = -1
	Next

	_WinAPI_InvalidateRect(GUICtrlGetHandle($controlID))

	Return 1
EndFunc   ;==>GuiFlatButton_SetColors

; #FUNCTION# =========================================================================================================
; Name...........: GuiFlatButton_SetColorsEx
; Description ...: Set colors of all of the button states
; Syntax.........: GuiFlatButton_SetColorsEx($controlID, $aClrs)
; Parameters ....: $controlID     - The controlID as returned by GuiFlatButton_Create
;				   $aClrs		  - Array containing all button colors
;									 [0]   = background color
;									 [1]   = text color
;									 [2]   = border color
;									 [3]   = background color (focus)
;									 [4]  = text color (focus)
;									 [5]   = border color (focus)
;									 [6]  = background color (hover)
;									 [7]  = text color (hover)
;									 [8]  = border color (hover)
;									 [9]  = background color (selected/pressed)
;									 [10]  = text color (selected/pressed)
;									 [11]  = border color (selected/pressed)
; Return values .: 1 - Success
;				   0 - controlID not found
; Author ........: kurtykurtyboy
; Modified ......:
;=====================================================================================================================
Func GuiFlatButton_SetColorsEx($controlID, ByRef $aClrs)
	If Not $aGuiFlatButton[0][0] Then Return 0
	$controlID = GuiFlatButton_prevControlId($controlID)

	Local $ControlIndex = GuiFlatButton_FindControlId($controlID)
	If $ControlIndex = -1 Then Return -1

	If IsArray($aClrs) Then
		If UBound($aClrs) == 12 Then
			Local $ret = GuiFlatButton_SetColors($controlID, $aClrs[0], $aClrs[1], $aClrs[2])
			If $ret == 0 Then Return 0

			For $j = 3 To UBound($aClrs) - 1
				If $aClrs[$j] == Default Or $aClrs[$j] == -1 Then
					$aGuiFlatButton[$ControlIndex][$j + 5] = -1
				ElseIf $aClrs[$j] == $GUI_BKCOLOR_TRANSPARENT Then
					$aGuiFlatButton[$ControlIndex][$j + 5] = -2
				Else
					$aGuiFlatButton[$ControlIndex][$j + 5] = _WinAPI_SwitchColor($aClrs[$j])
				EndIf
			Next

		Else
			Return 0
		EndIf
	Else
		Return 0
	EndIf

	_WinAPI_InvalidateRect(GUICtrlGetHandle($controlID))


	Return 1
EndFunc   ;==>GuiFlatButton_SetColorsEx

; #FUNCTION# =========================================================================================================
; Name...........: GuiFlatButton_SetDefaultColors
; Description ...: Set the default button colors for each future GuiFlatButton_Create
; Syntax.........: GuiFlatButton_SetDefaultColors($bkColor = -1 [, $foreColor = -1 [, $borderColor = -1 ]]])
; Parameters ....: $bkColor		  - background color (-1 for auto)
;				   $foreColor	  - text color (-1 for auto)
;				   $borderColor	  - border color (-1 for auto)
; Return values .: 1 - Success
;				   0 - controlID not found
; Author ........: kurtykurtyboy
; Modified ......:
;=====================================================================================================================
Func GuiFlatButton_SetDefaultColors($bkColor = -1, $foreColor = -1, $borderColor = -1)
	Local $aColors[12] = [-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1]
	If Not IsArray($aGuiFlatButton[0][3]) Then
		$aGuiFlatButton[0][3] = $aColors
	Else
		$aColors = $aGuiFlatButton[0][3]
	EndIf

	If $bkColor <> Default And $bkColor <> -1 Then
		$aColors[0] = _WinAPI_SwitchColor($bkColor)
	EndIf

	If $foreColor <> Default And $foreColor <> -1 Then
		$aColors[1] = _WinAPI_SwitchColor($foreColor)
	EndIf

	If $borderColor <> Default And $borderColor <> -1 Then
		If $borderColor == $GUI_BKCOLOR_TRANSPARENT Then
			$aColors[2] = -2
		Else
			$aColors[2] = _WinAPI_SwitchColor($borderColor)
		EndIf
	EndIf

	$aGuiFlatButton[0][3] = $aColors
	Return 1
EndFunc   ;==>GuiFlatButton_SetDefaultColors

; #FUNCTION# =========================================================================================================
; Name...........: GuiFlatButton_SetDefaultColorsEx
; Description ...: Set all of the default button colors for each future GuiFlatButton_Create
; Syntax.........: GuiFlatButton_SetDefaultColorsEx($aClrs)
; Parameters ....: $aClrs		  - Array containing all button colors
;									 [0]   = background color
;									 [1]   = text color
;									 [2]   = border color
;									 [3]   = background color (focus)
;									 [4]  = text color (focus)
;									 [5]   = border color (focus)
;									 [6]  = background color (hover)
;									 [7]  = text color (hover)
;									 [8]  = border color (hover)
;									 [9]  = background color (selected/pressed)
;									 [10]  = text color (selected/pressed)
;									 [11]  = border color (selected/pressed)
; Return values .: 1 - Success
;				   0 - controlID not found
; Author ........: kurtykurtyboy
; Modified ......:
;=====================================================================================================================
Func GuiFlatButton_SetDefaultColorsEx(ByRef $aClrs)
	If IsArray($aClrs) Then
		If UBound($aClrs) == 12 Then
			Local $ret = GuiFlatButton_SetDefaultColors($aClrs[0], $aClrs[1], $aClrs[2])
			If $ret == 0 Then Return -3

			Local $aColors = $aGuiFlatButton[0][3]
			For $j = 3 To UBound($aClrs) - 1
				If $aClrs[$j] == Default Or $aClrs[$j] == -1 Then
					$aColors[$j] = -1
				ElseIf $aClrs[$j] == $GUI_BKCOLOR_TRANSPARENT Then
					$aColors[$j] = -2
				Else
					$aColors[$j] = _WinAPI_SwitchColor($aClrs[$j])
				EndIf
			Next

		Else
			Return -2
		EndIf
	Else
		Return -1
	EndIf

	$aGuiFlatButton[0][3] = $aColors

	Return 1
EndFunc   ;==>GuiFlatButton_SetDefaultColorsEx

; #FUNCTION# =========================================================================================================
; Name...........: GuiFlatButton_GetState
; Description ...: Get the state of the button
; Syntax.........: GuiFlatButton_GetState( $controlID )
; Parameters ....: $controlID     - The controlID as returned by GuiFlatButton_Create
;				   $state		  - The state. See GUICtrlSetState() for values.
; Return values .: Success:  The state. See GUICtrlSetState() for values.
;				   Failure:  0
; Author ........: kurtykurtyboy
; Modified ......:
;=====================================================================================================================
Func GuiFlatButton_GetState($controlID)
	If Not $aGuiFlatButton[0][0] Then Return 0
	$controlID = GuiFlatButton_prevControlId($controlID)

	Local $ctrlState
	$ctrlState = GUICtrlGetState($controlID)
	Return $ctrlState

EndFunc   ;==>GuiFlatButton_GetState

; #FUNCTION# =========================================================================================================
; Name...........: GuiFlatButton_SetState
; Description ...: Set the state of the button
; Syntax.........: GuiFlatButton_SetState( $controlID, $state )
; Parameters ....: $controlID     - The controlID as returned by GuiFlatButton_Create
;				   $state		  - The state. See GUICtrlSetState() for values.
; Return values .: 1 - Success
;				   0 - Failure
; Author ........: kurtykurtyboy
; Modified ......:
;=====================================================================================================================
Func GuiFlatButton_SetState($controlID, $state)
	If Not $aGuiFlatButton[0][0] Then Return 0
	$controlID = GuiFlatButton_prevControlId($controlID)

	Local $ControlIndex = GuiFlatButton_FindControlId($controlID)
	If $ControlIndex = -1 Then Return -1

	Local $bHide, $bShow, $newState, $SW_State
	$bHide = BitAND($state, $GUI_HIDE) = $GUI_HIDE
	$bShow = BitAND($state, $GUI_SHOW) = $GUI_SHOW

	If $bHide Or $bShow Then
		If $bHide Then
			$SW_State = @SW_HIDE
		ElseIf $bShow Then
			$SW_State = @SW_SHOWNOACTIVATE
		EndIf

		Local $controlHWND, $childHWND, $parentHWND
		$controlHWND = GUICtrlGetHandle($aGuiFlatButton[$ControlIndex][1])
		$childHWND = _WinAPI_GetParent($controlHWND)
		$parentHWND = _WinAPI_GetParent($childHWND)
		GUISetState($SW_State, $childHWND)
		GUISwitch($parentHWND)
	EndIf
	GUICtrlSetState($controlID, $state)

	Return 1
EndFunc   ;==>GuiFlatButton_SetState

; #FUNCTION# =========================================================================================================
; Name...........: GuiFlatButton_Delete
; Description ...: Remove subclasses and delete the control
; Syntax.........: GuiFlatButton_Delete( $controlID )
; Parameters ....: $controlID     - The controlID as returned by GuiFlatButton_Create
; Return values .: 1 - Success
;				   0 - Failure
; Author ........: kurtykurtyboy
; Modified ......:
;=====================================================================================================================
Func GuiFlatButton_Delete($controlID, $isDestroy = False)
	If Not $aGuiFlatButton[0][0] Then Return 0
	$controlID = GuiFlatButton_prevControlId($controlID)

	Local $ControlIndex = GuiFlatButton_FindControlId($controlID)
	If $ControlIndex = -1 Then Return -1

	Local $controlHWND, $childHWND, $parentHWND
	$controlHWND = GUICtrlGetHandle($aGuiFlatButton[$ControlIndex][1])
	$childHWND = _WinAPI_GetParent($controlHWND)
	$parentHWND = _WinAPI_GetParent($childHWND)
	If $parentHWND <> 0 Then
		DllCall("comctl32.dll", "bool", "RemoveWindowSubclass", "hwnd", $controlHWND, "ptr", $aGuiFlatButton[$ControlIndex][2], "uint_ptr", $ControlIndex)

		If $childHWND <> 0 Then
			DllCall("comctl32.dll", "bool", "RemoveWindowSubclass", "hwnd", $childHWND, "ptr", $aGuiFlatButton[$ControlIndex][3], "uint_ptr", $ControlIndex)
		EndIf

		;if window is being destroyed by GUIDelete, then let it be destroyed
		If Not $isDestroy Then
			GUIDelete($childHWND)
		EndIf

		GUISwitch($parentHWND)
	EndIf

	For $j = 0 To UBound($aGuiFlatButton, 2) - 1
		$aGuiFlatButton[$ControlIndex][$j] = 0
	Next

	Return 1
EndFunc   ;==>GuiFlatButton_Delete

; #FUNCTION# =========================================================================================================
; Name...........: GuiFlatButton_SetPos
; Description ...: Changes the position of a control
; Syntax.........: GuiFlatButton_SetPos( $controlID, $iLeft, $iTop, $iWidth, $iHeight )
; Parameters ....: $controlID     - The controlID as returned by GuiFlatButton_Create
;				   $iLeft		  - The left side of the control
;				   $iTop		  - The top of the control
;				   $iWidth		  - The width of the control
;				   $iHeight		  - The height of the control
; Return values .: 1 - Success
;				   0 - Failure
; Author ........: kurtykurtyboy
; Modified ......:
;=====================================================================================================================
Func GuiFlatButton_SetPos($controlID, $iLeft, $iTop = Default, $iWidth = Default, $iHeight = Default)
	If Not $aGuiFlatButton[0][0] Then Return 0
	$controlID = GuiFlatButton_prevControlId($controlID)

	Local $ControlIndex = GuiFlatButton_FindControlId($controlID)
	If $ControlIndex = -1 Then Return -1

	Local $controlHWND, $childHWND, $parentHWND
	$controlHWND = GUICtrlGetHandle($aGuiFlatButton[$ControlIndex][1])
	$childHWND = _WinAPI_GetParent($controlHWND)
	WinMove($childHWND, "", $iLeft, $iTop, $iWidth, $iHeight)
	GUICtrlSetPos($aGuiFlatButton[$ControlIndex][1], 0, 0, $iWidth, $iHeight)

	Return 1
EndFunc   ;==>GuiFlatButton_SetPos


; #FUNCTION# =========================================================================================================
; Name...........: GuiFlatButton_GetPos
; Description ...: Get the position of a control
; Syntax.........: GuiFlatButton_GetPos( $controlID )
; Parameters ....: $controlID     - The controlID as returned by GuiFlatButton_Create
; Return values .: Success - Array of WinGetPos
;				   Failure - -1
; Author ........: kurtykurtyboy
; Modified ......:
;=====================================================================================================================
Func GuiFlatButton_GetPos($controlID)
	If Not $aGuiFlatButton[0][0] Then Return 0
	$controlID = GuiFlatButton_prevControlId($controlID)

	For $i = 1 To $aGuiFlatButton[0][0]
		If Not $aGuiFlatButton[$i][0] Then ContinueLoop
		If $aGuiFlatButton[$i][1] == $controlID Then
			Local $controlHWND, $childHWND, $parentHWND, $aWinPos
			$controlHWND = GUICtrlGetHandle($aGuiFlatButton[$i][1])
			$childHWND = _WinAPI_GetParent($controlHWND)
			$aWinPos = WinGetPos($childHWND)
			ExitLoop
		EndIf
	Next

	If IsArray($aWinPos) Then
		Return $aWinPos
	Else
		Return -1
	EndIf
EndFunc   ;==>GuiFlatButton_GetPos


; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: GuiFlatButton_ButtonHandler
; Description ...: Handles WM_MOUSEMOVE, WM_MOUSELEAVE, and WM_MOUSELEAVE events to track mouse hover and double click
; Author ........: kurtykurtyboy
; Modified ......:
; ===============================================================================================================================
Func GuiFlatButton_ButtonHandler($hwnd, $iMsg, $wParam, $lParam, $idx, $pData)
	If $iMsg <> $WM_MOUSEMOVE And $iMsg <> $WM_MOUSELEAVE And $iMsg <> $WM_LBUTTONDBLCLK And $iMsg <> $BM_SETIMAGE And $iMsg <> $WM_ERASEBKGND Then Return DllCall("comctl32.dll", "lresult", "DefSubclassProc", "hwnd", $hwnd, "uint", $iMsg, "wparam", $wParam, "lparam", $lParam)[0]
	Local $sTrackMouseEvent = DllStructCreate('dword;dword;hwnd;dword') ; Creating TRACKMOUSEEVENT Structure
	Local $sTME_size = DllStructGetSize($sTrackMouseEvent) ; getting size of structure - need for 1st argument

	Switch $iMsg
		;because the BS_OWNERDRAW style uses the CS_DBLCLKS window class style, we must handle this case to allow faster repeated clicking
		Case $WM_LBUTTONDBLCLK
			_SendMessage($hwnd, $WM_LBUTTONDOWN, 0, 0) ;replace double-click with single-click
			Return 0

		Case $WM_MOUSEMOVE
			DllStructSetData($sTrackMouseEvent, 1, $sTME_size) ; Size of a structure
			DllStructSetData($sTrackMouseEvent, 2, 0x00000002) ; TME_LEAVE
			DllStructSetData($sTrackMouseEvent, 3, $hwnd) ; HWND of our GUI
			DllStructSetData($sTrackMouseEvent, 4, 0xFFFFFFFF) ; HOVER_DEFAULT

			;TrackMouseEvent must be called for each new WM_MOUSEMOVE, but not repeatedly; this is why we have our tracking bit
			If Not $aGuiFlatButton[$idx][4] Then
				$aGuiFlatButton[$idx][4] = True
				DllCall('user32.dll', 'bool', 'TrackMouseEvent', 'ptr', DllStructGetPtr($sTrackMouseEvent))
				_WinAPI_InvalidateRect($hwnd, 0, False)
			EndIf

		Case $WM_MOUSELEAVE
			$aGuiFlatButton[$idx][4] = False
			_WinAPI_InvalidateRect($hwnd, 0, False)

		Case $BM_SETIMAGE
			$aGuiFlatButton[$idx][18] = $wParam
			If $wParam = $IMAGE_BITMAP Then
				$aGuiFlatButton[$idx][19] = _WinAPI_CopyBitmap($lParam)
			ElseIf $wParam = $IMAGE_ICON Then
				$aGuiFlatButton[$idx][19] = _WinAPI_CopyImage($lParam, $IMAGE_ICON)
			EndIf

		Case $WM_ERASEBKGND    ; prevent white background flicker
			Return False

	EndSwitch

	Return DllCall("comctl32.dll", "lresult", "DefSubclassProc", "hwnd", $hwnd, "uint", $iMsg, "wparam", $wParam, "lparam", $lParam)[0]
EndFunc   ;==>GuiFlatButton_ButtonHandler

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: GuiFlatButton_ChildHandler
; Description ...: Handles WM_DRAWITEM
; Author ........: kurtykurtyboy
; Modified ......:
; ===============================================================================================================================
Func GuiFlatButton_ChildHandler($hwnd, $iMsg, $wParam, $lParam, $idx, $pData)
	If $iMsg <> $WM_DRAWITEM And $iMsg <> $WM_NCHITTEST And $iMsg <> $WM_DESTROY Then Return DllCall("comctl32.dll", "lresult", "DefSubclassProc", "hwnd", $hwnd, "uint", $iMsg, "wparam", $wParam, "lparam", $lParam)[0]
	#forceref $iMsg, $wParam, $lParam

	Switch $iMsg
		Case $WM_DRAWITEM
			Local Const $tagDRAWITEMSTRUCT = "uint;uint;uint;uint;uint;hwnd;handle;long[4];ulong_ptr"
			Local $tDrawItem = DllStructCreate($tagDRAWITEMSTRUCT, $lParam)
			Local Const $ODT_BUTTON = 4

			Local $nCtlType = DllStructGetData($tDrawItem, 1)
			If $nCtlType = $ODT_BUTTON Then
				; Local $idControl = DllStructGetData($tDrawItem, 2)
				Local $nItemState = DllStructGetData($tDrawItem, 5)
				Local $hCtrl = DllStructGetData($tDrawItem, 6)
				Local $hDC = DllStructGetData($tDrawItem, 7)
				Local $iLeft = DllStructGetData($tDrawItem, 8, 1)
				Local $iTop = DllStructGetData($tDrawItem, 8, 2)
				Local $iRight = DllStructGetData($tDrawItem, 8, 3)
				Local $iBottom = DllStructGetData($tDrawItem, 8, 4)

				Local $retVal = GuiFlatButton_DrawButton($hwnd, $hCtrl, $hDC, $iLeft, $iTop, $iRight, $iBottom, $nItemState, $idx)
				$tDrawItem = 0
				Return $retVal
			EndIf

			$tDrawItem = 0

		Case $WM_NCHITTEST ;prevent dragging disabled buttons
			Return 1

			;if this child is being destroyed, remove the subclassing
		Case $WM_DESTROY
			GuiFlatButton_Delete($aGuiFlatButton[$idx][1], True)

	EndSwitch
	Return DllCall("comctl32.dll", "lresult", "DefSubclassProc", "hwnd", $hwnd, "uint", $iMsg, "wparam", $wParam, "lparam", $lParam)[0]
EndFunc   ;==>GuiFlatButton_ChildHandler

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: GuiFlatButton_DrawButton
; Description ...: Do the button drawing
; Author ........: kurtykurtyboy
; Modified ......:
; ===============================================================================================================================
Func GuiFlatButton_DrawButton($hwnd, $hCtrl, $hDC, $iLeft, $iTop, $iRight, $iBottom, $nItemState, $idx)
	#forceref $hwnd
	Local $bHover = $aGuiFlatButton[$idx][4]
	Local $sText = $aGuiFlatButton[$idx][17]

	Local Const $ODS_SELECTED = 0x0001
	Local Const $ODS_GRAYED = 0x0002
	Local Const $ODS_DISABLED = 0x0004
	Local Const $ODS_FOCUS = 0x0010

	Local $bFocused = BitAND($nItemState, $ODS_FOCUS)
	Local $bGrayed = BitAND($nItemState, BitOR($ODS_GRAYED, $ODS_DISABLED))
	Local $bSelected = BitAND($nItemState, $ODS_SELECTED)

	;get text rect
	Local $iFlags = $DT_CALCRECT
	Local $tTextRect = _WinAPI_CreateRect($iLeft, $iTop, $iRight, $iBottom)
	_WinAPI_DrawText($hDC, $sText, $tTextRect, $iFlags)
	Local $iTextWidth = DllStructGetData($tTextRect, "Right") - DllStructGetData($tTextRect, "Left")
	Local $iTextHeight = DllStructGetData($tTextRect, "Bottom") - DllStructGetData($tTextRect, "Top")

	;get button style
	Local $bTop = BitAND($aGuiFlatButton[$idx][20], $BS_TOP) = $BS_TOP
	Local $bBottom = BitAND($aGuiFlatButton[$idx][20], $BS_BOTTOM) = $BS_BOTTOM
	Local $bToolButton = BitAND($aGuiFlatButton[$idx][20], $BS_TOOLBUTTON) = $BS_TOOLBUTTON
	Local $bLeft = BitAND($aGuiFlatButton[$idx][20], $BS_LEFT) = $BS_LEFT
	Local $bRight = BitAND($aGuiFlatButton[$idx][20], $BS_RIGHT) = $BS_RIGHT
	If ($bTop And $bBottom) Or $bToolButton Then
		$bTop = 0
		$bBottom = 0
	EndIf
	If ($bLeft And $bRight) Or $bToolButton Then
		$bLeft = 0
		$bRight = 0
	EndIf

;~ 	If $bToolButton Then
;~ 		$iRight = $iLeft + $iTextWidth + 20
;~ 	EndIf

	Local $tRECT = DllStructCreate($tagRECT)
	DllStructSetData($tRECT, 'Left', $iLeft)
	DllStructSetData($tRECT, 'Top', $iTop)
	DllStructSetData($tRECT, 'Right', $iRight)
	DllStructSetData($tRECT, 'Bottom', $iBottom)

	Local $nClrFrame, $nClrButton, $nClrTxt
	Local $nClrButton_focus, $nClrFrame_focus, $nClrTxt_focus
	Local $nClrButton_Hover, $nClrFrame_Hover, $nClrTxt_Hover
	Local $nClrButton_select, $nClrFrame_select, $nClrTxt_select

	;set default colors
	Local $defClrButton = (($aGuiFlatButton[0][3])[0] == -1) ? _WinAPI_GetSysColor($COLOR_BTNFACE) : ($aGuiFlatButton[0][3])[0]
	Local $defClrTxt = (($aGuiFlatButton[0][3])[1] == -1) ? _WinAPI_GetSysColor($COLOR_BTNTEXT) : ($aGuiFlatButton[0][3])[1]
	Local $defClrFrame = (($aGuiFlatButton[0][3])[2] == -1) ? 0x333333 : ($aGuiFlatButton[0][3])[2]

	If $aGuiFlatButton[$idx][5] == -1 Then
		$nClrButton = $defClrButton
	Else
		$nClrButton = $aGuiFlatButton[$idx][5]
	EndIf
	If $aGuiFlatButton[$idx][7] == -1 And $defClrFrame <> -2 Then
		If $aGuiFlatButton[$idx][5] == -1 Then
			$nClrFrame = $defClrFrame
		Else
			$nClrFrame = _WinAPI_ColorAdjustLuma($nClrButton, 50)
		EndIf
	ElseIf $aGuiFlatButton[$idx][7] == -2 Or $defClrFrame == -2 Then
		$nClrFrame = $nClrButton
	Else
		$nClrFrame = $aGuiFlatButton[$idx][7]
	EndIf
	If $aGuiFlatButton[$idx][6] == -1 Then
		$nClrTxt = $defClrTxt
	Else
		$nClrTxt = $aGuiFlatButton[$idx][6]
	EndIf


	;set default colors - focus
	Local $defClrButton_focus = (($aGuiFlatButton[0][3])[3] == -1) ? $nClrButton : ($aGuiFlatButton[0][3])[3]
	Local $defClrTxt_focus = (($aGuiFlatButton[0][3])[4] == -1) ? $nClrTxt : ($aGuiFlatButton[0][3])[4]
	Local $defClrFrame_focus = (($aGuiFlatButton[0][3])[5] == -1) ? _WinAPI_ColorAdjustLuma($nClrFrame, 50) : ($aGuiFlatButton[0][3])[5]

	If $aGuiFlatButton[$idx][8] == -1 Then
		$nClrButton_focus = $defClrButton_focus
	Else
		$nClrButton_focus = $aGuiFlatButton[$idx][8]
	EndIf
	If $aGuiFlatButton[$idx][10] == -1 And $defClrFrame_focus <> -2 Then
		$nClrFrame_focus = $defClrFrame_focus
	ElseIf $aGuiFlatButton[$idx][10] == -2 Or $defClrFrame_focus == -2 Then
		$nClrFrame_focus = $nClrButton_focus
	Else
		$nClrFrame_focus = $aGuiFlatButton[$idx][10]
	EndIf
	If $aGuiFlatButton[$idx][9] == -1 Then
		$nClrTxt_focus = $defClrTxt_focus
	Else
		$nClrTxt_focus = $aGuiFlatButton[$idx][9]
	EndIf

	;set default colors - hover
	Local $defClrButton_hover = (($aGuiFlatButton[0][3])[6] == -1) ? _WinAPI_ColorAdjustLuma($nClrButton, 10) : ($aGuiFlatButton[0][3])[6]
	Local $defClrTxt_hover = (($aGuiFlatButton[0][3])[7] == -1) ? $nClrTxt_focus : ($aGuiFlatButton[0][3])[7]
	Local $defClrFrame_hover = (($aGuiFlatButton[0][3])[8] == -1) ? _WinAPI_ColorAdjustLuma($nClrFrame, 85) : ($aGuiFlatButton[0][3])[8]

	If $aGuiFlatButton[$idx][11] == -1 Then
		$nClrButton_Hover = $defClrButton_hover
	Else
		$nClrButton_Hover = $aGuiFlatButton[$idx][11]
	EndIf
	If $aGuiFlatButton[$idx][13] == -1 And $defClrFrame_hover <> -2 Then
		$nClrFrame_Hover = $defClrFrame_hover
	ElseIf $aGuiFlatButton[$idx][13] == -2 Or $defClrFrame_hover == -2 Then
		$nClrFrame_Hover = $nClrButton_Hover
	Else
		$nClrFrame_Hover = $aGuiFlatButton[$idx][13]
	EndIf
	If $aGuiFlatButton[$idx][12] == -1 Then
		$nClrTxt_Hover = $defClrTxt_hover
	Else
		$nClrTxt_Hover = $aGuiFlatButton[$idx][12]
	EndIf

	;set default colors - select
	Local $defClrButton_select = (($aGuiFlatButton[0][3])[9] == -1) ? _WinAPI_ColorAdjustLuma($nClrButton, -3) : ($aGuiFlatButton[0][3])[9]
	Local $defClrTxt_select = (($aGuiFlatButton[0][3])[10] == -1) ? $nClrTxt : ($aGuiFlatButton[0][3])[10]
	Local $defClrFrame_select = (($aGuiFlatButton[0][3])[11] == -1) ? _WinAPI_ColorAdjustLuma($nClrFrame, 50) : ($aGuiFlatButton[0][3])[11]

	If $aGuiFlatButton[$idx][14] == -1 Then
		$nClrButton_select = $defClrButton_select
	Else
		$nClrButton_select = $aGuiFlatButton[$idx][14]
	EndIf
	If $aGuiFlatButton[$idx][16] == -1 And $defClrFrame_select <> -2 Then
		$nClrFrame_select = $defClrFrame_select
	ElseIf $aGuiFlatButton[$idx][16] == -2 Or $defClrFrame_select == -2 Then
		$nClrFrame_select = $nClrButton_select
	Else
		$nClrFrame_select = $aGuiFlatButton[$idx][16]
	EndIf
	If $aGuiFlatButton[$idx][15] == -1 Then
		$nClrTxt_select = $defClrTxt_select
	Else
		$nClrTxt_select = $aGuiFlatButton[$idx][15]
	EndIf

	;check button state and select the colors
	Local $hBrush, $hBrushFrame
	Local $colorButton, $colorFrame, $colorText
	If $bSelected Then
		$colorButton = $nClrButton_select
		$colorFrame = $nClrFrame_select
		$colorText = $nClrTxt_select
	ElseIf $bHover Then
		$colorButton = $nClrButton_Hover
		$colorFrame = $nClrFrame_Hover
		$colorText = $nClrTxt_Hover
	ElseIf $bFocused Then
		$colorButton = $nClrButton_focus
		$colorFrame = $nClrFrame_focus
		$colorText = $nClrTxt_focus
	Else
		$colorButton = $nClrButton
		$colorFrame = $nClrFrame
		$colorText = $nClrTxt
	EndIf

	$hBrush = _WinAPI_CreateSolidBrush($colorButton)
	$hBrushFrame = _WinAPI_CreateSolidBrush($colorFrame)
	If $bGrayed Then
		If $aGuiFlatButton[$idx][7] > 0x999999 Then
			$colorText = 0xBBBBBB
		Else
			$colorText = 0x5E5E5E
		EndIf
	EndIf
	Local $nOldClrTxt = _WinAPI_SetTextColor($hDC, $colorText)

	Local $nClrBk = _WinAPI_SetBkColor($hDC, $colorButton) ;text background
	Local $hOldBrush = _WinAPI_SelectObject($hDC, $hBrushFrame)

	;draw the frame (border)
	_WinAPI_FrameRect($hDC, $tRECT, $hBrushFrame)

	;fill the background
	_WinAPI_InflateRect($tRECT, -1, -1)
	_WinAPI_FillRect($hDC, $tRECT, $hBrush)

	;uncomment the next 4 lines for gradient example
;~ 	Local $aVertex[6][3] = [[1, 1, 0x777777], [$iRight-1, $iTop+($iBottom/5*3), 0x888888], [1, $iTop+($iBottom/5*3), 0x888888], [$iRight-1, $iTop+($iBottom/5*4), 0xAAAAAA], [1, $iTop+($iBottom/5*4), 0xAAAAAA], [$iRight-1, $iBottom-1, 0x777777]]
;~ 	_WinAPI_GradientFill($hDC, $aVertex, 0, 1)
;~ 	_WinAPI_GradientFill($hDC, $aVertex, 2, 3)
;~ 	_WinAPI_GradientFill($hDC, $aVertex, 4, 5)


	;draw the icon
	Local $iconOffsetX, $iconOffsetY
	If $bSelected Then
		$iconOffsetX = 1
;~ 		$iconOffsetY = 2
	EndIf
	Local $bmWidth, $bmHeight
	Local $useTextHeight = 0
	If $aGuiFlatButton[$idx][19] <> Null Then
		Local $iButtonW = $iRight - $iLeft
		Local $iButtonH = $iBottom - $iTop
		Local $iIconX, $iIconY
		If $aGuiFlatButton[$idx][18] = $IMAGE_BITMAP Then
			Local $bm = DllStructCreate($tagBITMAP)
			Local $Ptr = DllStructGetPtr($bm)
			Local $Size = DllStructGetSize($bm)

			_WinAPI_GetObject($aGuiFlatButton[$idx][19], $Size, $Ptr)
			$bmWidth = DllStructGetData($bm, "bmWidth")
			$bmHeight = DllStructGetData($bm, "bmHeight")

			$useTextHeight = 0
			If $iTextHeight > $bmHeight Then
				$useTextHeight = 1
			EndIf

			If $bBottom Then
				If $bLeft Then
					$iIconX = 2
				ElseIf $bRight Then
					$iIconX = $iRight - $bmWidth - 2
				Else
					$iIconX = ($iRight - $iLeft) / 2 - $bmWidth / 2
				EndIf

				If $useTextHeight Then
					$iIconY = $iBottom - 2 - $iTextHeight / 2 - $bmHeight / 2
				Else
					$iIconY = $iBottom - $bmHeight - 2
				EndIf
			ElseIf $bTop Then
				If $bLeft Then
					$iIconX = 2
				ElseIf $bRight Then
					$iIconX = $iRight - $bmWidth - 2
				Else
					$iIconX = ($iRight - $iLeft) / 2 - $bmWidth / 2
				EndIf

				If $useTextHeight Then
					$iIconY = 2 + $iTextHeight / 2 - $bmHeight / 2
				Else
					$iIconY = 2
				EndIf
			ElseIf $bLeft Then
				$iIconX = 2
				$iIconY = $iButtonH / 2 - $bmHeight / 2
			ElseIf $bRight Then
				$iIconX = $iRight - $bmWidth - 2
				$iIconY = $iButtonH / 2 - $bmHeight / 2
			ElseIf $bToolButton Then
				$iIconX = ($iRight - $iLeft) / 2 - $bmWidth / 2
				$iIconY = ($iBottom - $iTop) / 2 - ($iTextHeight + $bmHeight) / 2
			Else
				$iIconX = ($iRight - $iLeft) / 2 - ($iTextWidth + $bmWidth + 2) / 2 - 1
				$iIconY = $iButtonH / 2 - $bmHeight / 2
			EndIf

			$iIconX += $iconOffsetX
			$iIconY += $iconOffsetY

			If BitAND($nItemState, $ODS_DISABLED) <> $ODS_DISABLED Then
				Local $hSrcDC = _WinAPI_CreateCompatibleDC($hDC)
				Local $hSrcSv = _WinAPI_SelectObject($hSrcDC, $aGuiFlatButton[$idx][19])
				_WinAPI_AlphaBlend($hDC, $iIconX, $iIconY, $bmWidth, $bmHeight, $hSrcDC, 0, 0, $bmWidth, $bmHeight, 255, True)
				_WinAPI_SelectObject($hSrcDC, $hSrcSv)
				_WinAPI_DeleteDC($hSrcDC)
			Else
				Local $hDestDC = _WinAPI_CreateCompatibleDC($hDC)
				Local $hDestBmp = _WinAPI_CreateCompatibleBitmapEx($hDestDC, 24, 24, 0xFFFFFF)
				Local $hDestSv = _WinAPI_SelectObject($hDestDC, $hDestBmp)
				Local $hSrcDC = _WinAPI_CreateCompatibleDC($hDC)
				Local $hSrcSv = _WinAPI_SelectObject($hSrcDC, $aGuiFlatButton[$idx][19])
				_WinAPI_AlphaBlend($hDestDC, 0, 0, $bmWidth, $bmHeight, $hSrcDC, 0, 0, $bmWidth, $bmHeight, 255, True)
				_WinAPI_SelectObject($hDestDC, $hDestSv)
				_WinAPI_DeleteDC($hDestDC)
				_WinAPI_SelectObject($hSrcDC, $hSrcSv)
				_WinAPI_DeleteDC($hSrcDC)
				_WinAPI_DrawState($hDC, 0, $hDestBmp, $iIconX, $iIconY, 0, 0, BitOR($DST_BITMAP, $DSS_DISABLED))
				_WinAPI_DeleteObject($hDestBmp)
			EndIf
		ElseIf $aGuiFlatButton[$idx][18] = $IMAGE_ICON Then
			Local $aIconInfo = _WinAPI_GetIconInfo($aGuiFlatButton[$idx][19])

			If IsArray($aIconInfo) Then
				Local $bm = DllStructCreate($tagBITMAP)
				Local $Ptr = DllStructGetPtr($bm)
				Local $Size = DllStructGetSize($bm)

				_WinAPI_GetObject($aIconInfo[5], $Size, $Ptr)
				$bmWidth = DllStructGetData($bm, "bmWidth")
				$bmHeight = DllStructGetData($bm, "bmHeight")

				$useTextHeight = 0
				If $iTextHeight > $bmHeight Then
					$useTextHeight = 1
				EndIf

				If $bBottom Then
					If $bLeft Then
						$iIconX = 2
					ElseIf $bRight Then
						$iIconX = $iRight - $bmWidth - 2
					Else
						$iIconX = ($iRight - $iLeft) / 2 - $bmWidth / 2
					EndIf

					If $useTextHeight Then
						$iIconY = $iBottom - 2 - $iTextHeight / 2 - $bmHeight / 2
					Else
						$iIconY = $iBottom - $bmHeight - 2
					EndIf
				ElseIf $bTop Then
					If $bLeft Then
						$iIconX = 2
					ElseIf $bRight Then
						$iIconX = $iRight - $bmWidth - 2
					Else
						$iIconX = ($iRight - $iLeft) / 2 - $bmWidth / 2
					EndIf

					If $useTextHeight Then
						$iIconY = 2 + $iTextHeight / 2 - $bmHeight / 2
					Else
						$iIconY = 2
					EndIf
				ElseIf $bLeft Then
					$iIconX = 2
					$iIconY = $iButtonH / 2 - $bmHeight / 2
				ElseIf $bRight Then
					$iIconX = $iRight - $bmWidth - 2
					$iIconY = $iButtonH / 2 - $bmHeight / 2
				ElseIf $bToolButton Then
					$iIconX = ($iRight - $iLeft) / 2 - $bmWidth / 2
					$iIconY = ($iBottom - $iTop) / 2 - ($iTextHeight + $bmHeight) / 2
				Else
					$iIconX = ($iRight - $iLeft) / 2 - ($iTextWidth + $bmWidth + 2) / 2 - 1
					$iIconY = $iButtonH / 2 - $bmHeight / 2
				EndIf

				$iIconX += $iconOffsetX
				$iIconY += $iconOffsetY

				Local $iState
				If BitAND($nItemState, $ODS_DISABLED) <> $ODS_DISABLED Then
;~ 					_WinAPI_DrawIconEx($hDC, $iIconX, $iIconY, $aGuiFlatButton[$idx][19], $bmWidth, $bmHeight)
					$iState = $DSS_NORMAL
				Else
					$iState = $DSS_DISABLED
				EndIf
				_WinAPI_DrawState($hDC, 0, $aGuiFlatButton[$idx][19], $iIconX, $iIconY, 0, 0, BitOR($DST_ICON, $iState))
			EndIf
		Else
			Return -1
		EndIf

	EndIf

	;text position setup
	Local $nTmpLeft, $nTmpTop, $nTmpRight, $nTmpBottom
	$useTextHeight = 0
	If $iTextHeight > $bmHeight Then
		$useTextHeight = 1
	EndIf
	If $bBottom Then
		If $bLeft Then
			$nTmpLeft = $bmWidth + 2 + 1
			$nTmpRight = $iRight - ($nTmpLeft - $iLeft)
			If $useTextHeight Then
				$nTmpTop = $iBottom - $iTextHeight - 2
			Else
				$nTmpTop = $iBottom - 2 - $bmHeight / 2 - $iTextHeight / 2
			EndIf
			$nTmpBottom = $nTmpTop + $iTextHeight
		ElseIf $bRight Then
			$iIconX = $iRight - $bmWidth - 2
			$nTmpLeft = $iRight - $iTextWidth - $bmWidth - 2 - 1
			$nTmpRight = $iRight
			If $useTextHeight Then
				$nTmpTop = $iBottom - $iTextHeight - 2
			Else
				$nTmpTop = $iBottom - 2 - $bmHeight / 2 - $iTextHeight / 2
			EndIf
			$nTmpBottom = $nTmpTop + $iTextHeight
		Else
			$nTmpLeft = ($iRight - $iLeft) / 2 - ($iTextWidth) / 2
			$nTmpRight = $iRight - ($nTmpLeft - $iLeft)
			$nTmpTop = $iBottom - $bmHeight - 2 - $iTextHeight - 1
			$nTmpBottom = $nTmpTop + $iTextHeight
		EndIf
	ElseIf $bTop Then
		If $bLeft Then
			$nTmpLeft = $bmWidth + 2 + 1
			$nTmpRight = $iRight - ($nTmpLeft - $iLeft)
			If $useTextHeight Then
				$nTmpTop = $iTop + 2
			Else
				$nTmpTop = $iTop + 2 + $bmHeight / 2 - $iTextHeight / 2
			EndIf
			$nTmpBottom = $nTmpTop + $iTextHeight
		ElseIf $bRight Then
			$iIconX = $iRight - $bmWidth - 2
			$nTmpLeft = $iRight - $iTextWidth - $bmWidth - 2 - 1
			$nTmpRight = $iRight
			If $useTextHeight Then
				$nTmpTop = $iTop + 2
			Else
				$nTmpTop = $iTop + 2 + $bmHeight / 2 - $iTextHeight / 2
			EndIf
			$nTmpBottom = $nTmpTop + $iTextHeight
		Else
			$nTmpLeft = ($iRight - $iLeft) / 2 - ($iTextWidth) / 2
			$nTmpRight = $iRight - ($nTmpLeft - $iLeft)
			$nTmpTop = $iTop + $bmHeight + 2 + 1
			$nTmpBottom = $nTmpTop + $iTextHeight
		EndIf
	ElseIf $bLeft Then
		$nTmpLeft = $bmWidth + 2 + 1
		$nTmpRight = $iRight - ($nTmpLeft - $iLeft)
		$nTmpTop = $iTop
		$nTmpBottom = $iBottom
	ElseIf $bRight Then
		$nTmpLeft = $iRight - $bmWidth - 2 - $iTextWidth - 1
		$nTmpRight = $iRight - ($nTmpLeft - $iLeft)
		$nTmpTop = $iTop
		$nTmpBottom = $iBottom
	ElseIf $bToolButton Then
		$nTmpLeft = $iLeft + ($iRight - $iLeft) / 2 - $iTextWidth / 2
		$nTmpRight = $iRight - ($nTmpLeft - $iLeft)
		$nTmpTop = ($iBottom - $iTop) / 2 - ($iTextHeight + $bmHeight) / 2 + $bmHeight + 1
		$nTmpBottom = $nTmpTop + $iTextHeight
	Else
		$nTmpLeft = $iLeft + ($iRight - $iLeft) / 2 - ($iTextWidth + $bmWidth + 2) / 2 + $bmWidth + 1
		$nTmpRight = $iRight - ($nTmpLeft - $iLeft)
		$nTmpTop = $iTop
		$nTmpBottom = $iBottom
	EndIf

	If $bSelected Then
		$nTmpLeft = $nTmpLeft + 1
;~ 		$nTmpTop = $nTmpTop + 2
	EndIf

	;draw the text
	Local $iFlags = BitOR($DT_NOCLIP, $DT_VCENTER)
	If Not BitAND(_WinAPI_GetWindowLong($hCtrl, $GWL_STYLE), $BS_MULTILINE) Then $iFlags = BitOR($iFlags, $DT_SINGLELINE)
	Local $tTextRect = _WinAPI_CreateRect($nTmpLeft, $nTmpTop, $nTmpRight, $nTmpBottom)
	Local $oldBkMode = _WinAPI_SetBkMode($hDC, $TRANSPARENT)
	_WinAPI_DrawText($hDC, $sText, $tTextRect, $iFlags)
	_WinAPI_SetBkMode($hDC, $oldBkMode)

	;cleanup resources
	_WinAPI_SelectObject($hDC, $hOldBrush)
	_WinAPI_DeleteObject($hBrush)
	_WinAPI_DeleteObject($hBrushFrame)
	_WinAPI_SetTextColor($hDC, $nOldClrTxt)
	_WinAPI_SetBkColor($hDC, $nClrBk)
	Return 1 ; The internal AutoIt message handler will not run
;~ 	Return $gui_rundefmsg
EndFunc   ;==>GuiFlatButton_DrawButton

;extracted from post by funkey
Func _WinAPI_DrawState($hDC, $hBrush, $lData, $x, $y, $w, $h, $iFlags)
	Local $aRet = DllCall("User32.dll", "BOOL", "DrawState", "handle", $hDC, "handle", $hBrush, "ptr", 0, "long", $lData, "long", 0, _
			"int", $x, "int", $y, "int", $w, "int", $h, "UINT", $iFlags)

	If @error Then Return SetError(@error, @extended, False)
	Return $aRet[0]
EndFunc   ;==>_WinAPI_DrawState

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: GuiFlatButton_Exit
; Description ...: Release any subclasses
; Author ........: kurtykurtyboy
; Modified ......:
; ===============================================================================================================================
Func GuiFlatButton_Exit()
	If Not $aGuiFlatButton[0][0] Then Return

	;remove subclasses
	For $i = 1 To $aGuiFlatButton[0][0]
		If Not $aGuiFlatButton[$i][0] Then ContinueLoop
		DllCall("comctl32.dll", "bool", "RemoveWindowSubclass", "hwnd", GUICtrlGetHandle($aGuiFlatButton[$i][1]), "ptr", $aGuiFlatButton[$i][2], "uint_ptr", $i) ; $iSubclassId = $i
		DllCall("comctl32.dll", "bool", "RemoveWindowSubclass", "hwnd", _WinAPI_GetParent(GUICtrlGetHandle($aGuiFlatButton[$i][1])), "ptr", $aGuiFlatButton[$i][3], "uint_ptr", $i) ; $iSubclassId = $i
		_WinAPI_DeleteObject($aGuiFlatButton[$i][19])
	Next

	;release the callback function handles
	DllCallbackFree($aGuiFlatButton[0][1])
	DllCallbackFree($aGuiFlatButton[0][2])
EndFunc   ;==>GuiFlatButton_Exit

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: GuiFlatButton_getParent
; Description ...: Get handle to parent window
; Author ........: kurtykurtyboy
; Modified ......:
; ===============================================================================================================================
Func GuiFlatButton_getParent()
	;create temporary label so we can get a handle to its parent
	Local $templabel = GUICtrlCreateLabel("", 0, 0, 0, 0)
	Local $parentHWND = _WinAPI_GetParent(GUICtrlGetHandle($templabel))
	GUICtrlDelete($templabel)
	Return $parentHWND
EndFunc   ;==>GuiFlatButton_getParent

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: GuiFlatButton_getSize
; Description ...: Really bad/lazy way to get the calculated button position/size
; Author ........: kurtykurtyboy
; Modified ......:
; ===============================================================================================================================
Func GuiFlatButton_getSize($text)
	;create temporary button so we can get the calculated size
	Local $tempButton = GUICtrlCreateButton($text, 0, 0)
	Local $parentHWND = _WinAPI_GetParent(GUICtrlGetHandle($tempButton))
	Local $aControlPos = ControlGetPos($parentHWND, "", $tempButton)
	GUICtrlDelete($tempButton)
	Return $aControlPos
EndFunc   ;==>GuiFlatButton_getSize

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: GuiFlatButton_prevControlId
; Description ...: Get controlID of previously created control
; Author ........: kurtykurtyboy
; Modified ......:
; ===============================================================================================================================
Func GuiFlatButton_prevControlId($controlID)
	If $controlID == -1 Then
		Return _WinAPI_GetDlgCtrlID(GUICtrlGetHandle(-1))
	Else
		Return $controlID
	EndIf
EndFunc   ;==>GuiFlatButton_prevControlId

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: GuiFlatButton_FindControlId
; Description ...: Get array index from controlID
; Author ........: kurtykurtyboy
; Modified ......:
; ===============================================================================================================================
Func GuiFlatButton_FindControlId($controlID)
	For $i = 1 To $aGuiFlatButton[0][0]
		If Not $aGuiFlatButton[$i][0] Then ContinueLoop
		If $aGuiFlatButton[$i][1] == $controlID Then
			Return $i
		EndIf
	Next

	Return -1
EndFunc   ;==>GuiFlatButton_FindControlId
