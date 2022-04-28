#include "GuiFlatButton.au3"
#include <StaticConstants.au3>

;~ Opt("GUIOnEventMode", 1)

Global $GFTB_TOP = 1, $GFTB_BOTTOM = 2, $GFTB_LEFT = 4, $GFTB_RIGHT = 8, $GFTB_VERTICAL = 16, $GFTB_EXTEND = 32
;~ Global $label1

;set up toolbar button colors
;~ Global $aColorsEx = _
;~ 		[0x666666, 0xFFFFFF, 0x666666, _	 ; normal 	: Background, Text, Border
;~ 		0x636363, 0xFFFFFF, 0x757575, _	 	 ; focus 	: Background, Text, Border
;~ 		0x888888, 0xFFFFFF, 0x999999, _	 	 ; hover 	: Background, Text, Border
;~ 		0x555555, 0xFFFFFF, 0x444444] ; selected 	: Background, Text, Border

;~ Example()

;buttons with Icon images
;event mode demonstration
;~ Func Example()
;~ 	;get icons for demonstration
;~ 	Local $hIcon1 = _WinAPI_ShellExtractIcon(@SystemDir & '\shell32.dll', 47, 16, 16)
;~ 	Local $hIcon2 = _WinAPI_ShellExtractIcon(@SystemDir & '\shell32.dll', 258, 16, 16)
;~ 	Local $hIcon3 = _WinAPI_ShellExtractIcon(@SystemDir & '\shell32.dll', 62, 16, 16)
;~ 	Local $hIcon4 = _WinAPI_ShellExtractIcon(@SystemDir & '\shell32.dll', 208, 16, 16)
;~ 	;get icons for demonstration
;~ 	Local $hIcon5 = _WinAPI_ShellExtractIcon(@SystemDir & '\shell32.dll', 47, 16, 16)
;~ 	Local $hIcon6 = _WinAPI_ShellExtractIcon(@SystemDir & '\shell32.dll', 258, 16, 16)
;~ 	Local $hIcon7 = _WinAPI_ShellExtractIcon(@SystemDir & '\shell32.dll', 62, 16, 16)
;~ 	Local $hIcon8 = _WinAPI_ShellExtractIcon(@SystemDir & '\shell32.dll', 208, 16, 16)


;~ 	;create GUI
;~ 	Local $hGUI = GUICreate("GuiFlatButton Ex5", 500, 400, -1, -1)
;~ 	GUISetOnEvent($GUI_EVENT_CLOSE, "_onExit")
;~ 	GUISetBkColor(0xBDBDBD)
;~ 	$label1 = GUICtrlCreateLabel("Click a button", 5, 75)
;~ 	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)

;~ 	;create horizontal toolbar and add buttons
;~ 	$oToolbar = _GuiFlatToolbarCreate(-1, 0, 0, 48, 38, $aColorsEx) ;create a new toolbar and extend
;~ 	_GuiFlatToolbar_SetBkColor($oToolbar, 0x444444) ;add a new button and associate an icon
;~ 	$tbLock = _GuiFlatToolbar_AddButton($oToolbar, "Lock", $hIcon1)
;~ 	GUICtrlSetTip(-1, "Lock Button")
;~ 	GUICtrlSetOnEvent(-1, "tbEvent")
;~ 	$GFTBave = _GuiFlatToolbar_AddButton($oToolbar, "Save", $hIcon2)
;~ 	GUICtrlSetTip(-1, "Save Button")
;~ 	GUICtrlSetOnEvent(-1, "tbEvent")
;~ 	$tbDel = _GuiFlatToolbar_AddButton($oToolbar, "Delete", $hIcon3)
;~ 	GUICtrlSetTip(-1, "Delete Button")
;~ 	GUICtrlSetOnEvent(-1, "tbEvent")
;~ 	$tbFav = _GuiFlatToolbar_AddButton($oToolbar, "Favorite", $hIcon4)
;~ 	GUICtrlSetTip(-1, "Favorite Button")
;~ 	GUICtrlSetOnEvent(-1, "tbEvent")

;~ 	;create vertical toolbar and add buttons
;~ 	$oToolbar2 = _GuiFlatToolbarCreate(BitOR($GFTB_VERTICAL, $GFTB_RIGHT), 0, 0, 20, 20, $aColorsEx) ;create a new vertical toolbar
;~ 	$tb1 = _GuiFlatToolbar_AddButton($oToolbar2, "", $hIcon1)
;~ 	GUICtrlSetTip(-1, "Lock Button")
;~ 	$tb2 = _GuiFlatToolbar_AddButton($oToolbar2, "", $hIcon2)
;~ 	GUICtrlSetTip(-1, "Save Button")
;~ 	$tb3 = _GuiFlatToolbar_AddButton($oToolbar2, "", $hIcon3)
;~ 	GUICtrlSetTip(-1, "Delete Button")
;~ 	$tb4 = _GuiFlatToolbar_AddButton($oToolbar2, "", $hIcon4)
;~ 	GUICtrlSetTip(-1, "Favorite Button")

;~ 	;clean up the icons because we do not need them anymore
;~ 	_WinAPI_DestroyIcon($hIcon1)
;~ 	_WinAPI_DestroyIcon($hIcon2)
;~ 	_WinAPI_DestroyIcon($hIcon3)
;~ 	_WinAPI_DestroyIcon($hIcon4)

;~ 	GUISetState(@SW_SHOW, $hGUI)
;~ 	While 1
;~ 		Sleep(10)
;~ 	WEnd
;~ EndFunc   ;==>Example

;~ Func tbEvent()
;~ 	GUICtrlSetData($label1, GUICtrlRead(@GUI_CtrlId))
;~ EndFunc   ;==>tbEvent

;~ Func _onExit()
;~ 	GUIDelete()
;~ 	Exit
;~ EndFunc   ;==>_onExit

;default style is horizontal, extend, top
Func _GuiFlatToolbarCreate($iStyle = -1, $iOffsetX = 0, $iOffsetY = 0, $iButtonWidth = 50, $iButtonHeight = 50, $aColorsEx = 0)
	If $iStyle = -1 Then
		$iStyle = 33
	EndIf

	Local $aToolBar[1][12]

	Local $bExtend = (BitAND($iStyle, $GFTB_EXTEND) = $GFTB_EXTEND)
	Local $bVertical = (BitAND($iStyle, $GFTB_VERTICAL) = $GFTB_VERTICAL)
	Local $bTop = (BitAND($iStyle, $GFTB_TOP) = $GFTB_TOP)
	Local $bBottom = (BitAND($iStyle, $GFTB_BOTTOM) = $GFTB_BOTTOM)
	Local $bLeft = (BitAND($iStyle, $GFTB_LEFT) = $GFTB_LEFT)
	Local $bRight = (BitAND($iStyle, $GFTB_RIGHT) = $GFTB_RIGHT)
	Local $x, $y, $w, $h

	$aToolBar[0][0] = 0
	$aToolBar[0][1] = Toolbar_getParent()
	;$aToolBar[0][2] child gui set below
	$aToolBar[0][3] = $iStyle
	$aToolBar[0][4] = $iOffsetX
	$aToolBar[0][5] = $iOffsetY
	$aToolBar[0][6] = $iButtonWidth
	$aToolBar[0][7] = $iButtonHeight
	$aToolBar[0][8] = $aColorsEx

	If $bExtend Then
		Local $aClientSize = WinGetClientSize($aToolBar[0][1])
		If IsArray($aClientSize) Then
			If $bVertical Then
				$w = $iButtonWidth
				$h = $aClientSize[1] - $iOffsetY
				If $bRight Then
					$x = $aClientSize[0] - $iButtonWidth - $iOffsetX
				Else
					$x = $iOffsetX
				EndIf

				If $bBottom Then
					$y = 0
				Else
					$y = $iOffsetY
				EndIf
			Else
				$w = $aClientSize[0] - $iOffsetX
				$h = $iButtonHeight
				If $bRight Then
					$x = 0
				Else
					$x = $iOffsetX
				EndIf

				If $bBottom Then
					$y = $aClientSize[1] - $iButtonHeight - $iOffsetY
				Else
					$y = $iOffsetY
				EndIf
			EndIf
		EndIf
	Else
		Local $aClientSize = WinGetClientSize($aToolBar[0][1])
		If IsArray($aClientSize) Then
			If $bVertical Then
				$w = $iButtonWidth
				$h = 0
				If $bRight Then
					$x = $aClientSize[0] - $iButtonWidth - $iOffsetX
				Else
					$x = $iOffsetX
				EndIf

				If $bBottom Then
					$y = $aClientSize[1] - $iOffsetY
				Else
					$y = $iOffsetY
				EndIf
			Else
				$w = 0
				$h = $iButtonHeight
				If $bRight Then
					$x = $aClientSize[0] - $iOffsetX
				Else
					$x = $iOffsetX
				EndIf

				If $bBottom Then
					$y = $aClientSize[1] - $iButtonHeight - $iOffsetY
				Else
					$y = $iOffsetY
				EndIf
			EndIf
		EndIf
	EndIf

	$aToolBar[0][2] = GUICreate("", $w, $h, $x, $y, BitOR($WS_CHILD, $WS_CLIPCHILDREN, $WS_CLIPSIBLINGS), -1, $aToolBar[0][1])
	_WinAPI_SetWindowPos($aToolBar[0][2], $HWND_TOP, 0, 0, 0, 0, BitOR($SWP_NOMOVE, $SWP_NOSIZE))
	GUISetState(@SW_SHOWNOACTIVATE)
	Return $aToolBar
EndFunc   ;==>_GuiFlatToolbarCreate

Func _GuiFlatToolbar_AddButton(ByRef $aToolBar, $sText = "", $hIcon = Null, $iPadding=0)
	Local $TB_BUTTON = 0, $TB_BUTTONSEP = 1

	Local $hWnd = $aToolBar[0][1]
	Local $hWndChild = $aToolBar[0][2]
	Local $iStyle = $aToolBar[0][3]
	Local $iOffsetX = $aToolBar[0][4]
	Local $iOffsetY = $aToolBar[0][5]
	Local $iButtonWidth = $aToolBar[0][6]
	Local $iButtonHeight = $aToolBar[0][7]
	Local $aColorsEx = $aToolBar[0][8]

	Local $bExtend = (BitAND($iStyle, $GFTB_EXTEND) = $GFTB_EXTEND)
	Local $bVertical = (BitAND($iStyle, $GFTB_VERTICAL) = $GFTB_VERTICAL)
	Local $bTop = (BitAND($iStyle, $GFTB_TOP) = $GFTB_TOP)
	Local $bBottom = (BitAND($iStyle, $GFTB_BOTTOM) = $GFTB_BOTTOM)
	Local $bLeft = (BitAND($iStyle, $GFTB_LEFT) = $GFTB_LEFT)
	Local $bRight = (BitAND($iStyle, $GFTB_RIGHT) = $GFTB_RIGHT)
	Local $x, $y, $w, $h, $xWnd, $yWnd

	; See if there is a blank line available in the array
	Local $iIndex = 0
	For $i = 1 To $aToolBar[0][0]
		If $aToolBar[$i][0] = 0 Then
			$iIndex = $i
			ExitLoop
		EndIf
	Next
	; If no blank line found then increase array size
	If $iIndex == 0 Then
		$aToolBar[0][0] += 1
		ReDim $aToolBar[$aToolBar[0][0] + 1][UBound($aToolBar, 2)]
	EndIf
	Local $count = $aToolBar[0][0]

	$flags = 0
	If $bExtend Then
		Local $aClientSize = WinGetClientSize($aToolBar[0][1])
		If IsArray($aClientSize) Then
			If $bVertical Then
				$x = 0
				If $bBottom Then
					$y = $aClientSize[1] - $iButtonHeight
				Else
					$y = ($count - 1) * $iButtonHeight
				EndIf
			Else
				If $bRight Then
					$x = $aClientSize[0] - $iButtonWidth
				Else
					$x = ($count - 1) * $iButtonWidth
				EndIf
				$y = 0
			EndIf
		EndIf
		$flags = BitOR($SWP_NOMOVE, $SWP_NOSIZE)
	Else
		Local $aClientSize = WinGetClientSize($aToolBar[0][1])
		If IsArray($aClientSize) Then
			If $bVertical Then
				$w = $iButtonWidth
				$h = $count * $iButtonHeight
				$x = 0
				$y = ($count - 1) * $iButtonHeight

				If $bRight Then
					$xWnd = $aClientSize[0] - $iButtonWidth - $iOffsetX
				Else
					$xWnd = $iOffsetX
				EndIf

				If $bBottom Then
					$yWnd = $aClientSize[1] - ($count - 1) * $iButtonHeight - $iOffsetY
				Else
					$yWnd = $iOffsetY
				EndIf
			Else
				$w = $count * $iButtonWidth
				$h = $iButtonHeight
				$x = ($count - 1) * $iButtonHeight
				$y = 0

				If $bRight Then
					$xWnd = $aClientSize[0] - ($count - 1) * $iButtonWidth - $iOffsetX
				Else
					$xWnd = $iOffsetX
				EndIf

				If $bBottom Then
					$yWnd = $aClientSize[1] - $iButtonHeight - $iOffsetY
				Else
					$yWnd = $iOffsetY
				EndIf
			EndIf
		EndIf
	EndIf

	GUISwitch($hWndChild)

	$aToolBar[$i][0] = GuiFlatButton_Create($sText, $x, $y, $iButtonWidth, $iButtonHeight, BitOR($BS_TOOLBUTTON, $BS_BOTTOM))
	$aToolBar[$i][1] = $TB_BUTTON
	Local $parentWnd = _WinAPI_GetParent(GUICtrlGetHandle($aToolBar[$i][0]))
	GUISetStyle(-1, 0, $parentWnd) ;remove $WS_EX_CONTROLPARENT style to prevent dragging of the toolbar
	If IsArray($aColorsEx) Then
		GuiFlatButton_SetColorsEx($aToolBar[$i][0], $aColorsEx)
	EndIf
	If $hIcon <> Null Then
		_WinAPI_DeleteObject(_SendMessage(GUICtrlGetHandle($aToolBar[$i][0]), $BM_SETIMAGE, $IMAGE_ICON, $hIcon))
	EndIf

	GUISwitch($hWnd)

	If Not $bExtend Then
		_WinAPI_SetWindowPos($hWndChild, $HWND_TOP, $xWnd, $yWnd, $w, $h, 0)
	EndIf

	If $bExtend And $bVertical And $bBottom Then
		For $j = 1 To $count - 1
;~ 			GUICtrlSetPos($aToolBar[$j][0], $x, ($j-1)*$iButtonHeight)
			GuiFlatButton_SetPos($aToolBar[$j][0], $x, $aClientSize[1] - $count * $iButtonHeight + ($j - 1) * $iButtonHeight)
		Next
	ElseIf $bExtend And Not $bVertical And $bRight Then
		For $j = 1 To $count - 1
;~ 			GUICtrlSetPos($aToolBar[$j][0], $aClientSize[0] - $count*$iButtonWidth + ($j-1)*$iButtonWidth, $y)
			GuiFlatButton_SetPos($aToolBar[$j][0], $aClientSize[0] - $count * $iButtonWidth + ($j - 1) * $iButtonWidth, $y)
			ConsoleWrite($aClientSize[0] - $count * $iButtonWidth + ($j - 1) * $iButtonWidth & @CRLF)
		Next
	EndIf


	Return $aToolBar[$i][0]
EndFunc   ;==>_GuiFlatToolbar_AddButton

Func _GuiFlatToolbar_SetAutoWidth(ByRef $aToolBar)
	If Not IsArray($aToolBar) Then Return -1
	Local $stringsize, $string, $maxWidth
	For $i = 1 To $aToolBar[0][0]
		$string = GUICtrlRead($aToolBar[$i][0])
		$stringsize = _StringSize($string, $MyGlobalFontSize, 400, 0, $MyGlobalFontName)
		If $stringsize[2] > $maxWidth Then
			$maxWidth = $stringsize[2]
		EndIf
	Next
	Local $padding = 10
	$aToolBar[0][6] = $maxWidth + $padding

;~ 	Local $athisPos = GuiFlatButton_GetPos($aToolBar[1][0])
;~ 	Local $athisPos2 = ControlGetPos(GUICtrlGetHandle($aToolBar[1][0]),"",0)
	Local $thisX = 0
;~ 	ConsoleWrite($athisPos[3] & @CRLF)
	For $i = 1 To $aToolBar[0][0]
		GuiFlatButton_SetPos($aToolBar[$i][0], $thisX, 0, $aToolBar[0][6], $aToolBar[0][7])
		$thisX += $aToolBar[0][6]
	Next

EndFunc   ;==>_GuiFlatToolbar_SetAutoWidth

Func _GuiFlatToolbar_SetBkColor(ByRef $aToolBar, $bkColor)
	If Not IsArray($aToolBar) Then Return -1

	GUISetBkColor($bkColor, $aToolBar[0][2])

	Return 0
EndFunc   ;==>_GuiFlatToolbar_SetBkColor

Func _GuiFlatToolbar_SetIcon(ByRef $aToolBar, $bkColor)
	If Not IsArray($aToolBar) Then Return -1

	GUISetBkColor($bkColor, $aToolBar[0][2])

	Return 0
EndFunc   ;==>_GuiFlatToolbar_SetIcon

Func _GuiFlatToolbar_DeleteAll(ByRef $aToolBar)
	For $i = 1 To $aToolBar[0][0]
		GuiFlatButton_Delete($aToolBar[$i][0])
	Next
EndFunc


; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: GuiFlatButton_getParent
; Description ...: Get handle to parent window
; Author ........: kurtykurtyboy
; Modified ......:
; ===============================================================================================================================
Func Toolbar_getParent()
	;create temporary label so we can get a handle to its parent
	Local $templabel = GUICtrlCreateLabel("", 0, 0, 0, 0)
	Local $parentHWND = _WinAPI_GetParent(GUICtrlGetHandle($templabel))
	GUICtrlDelete($templabel)
	Return $parentHWND
EndFunc   ;==>Toolbar_getParent
