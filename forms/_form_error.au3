; -----------------------------------------------------------------------------
; This file is part of Simple IP Config.
;
; Simple IP Config is free software: you can redistribute it and/or modify
; it under the terms of the GNU General Public License as published by
; the Free Software Foundation, either version 3 of the License, or
; (at your option) any later version.
;
; Simple IP Config is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; GNU General Public License for more details.
;
; You should have received a copy of the GNU General Public License
; along with Simple IP Config.  If not, see <http://www.gnu.org/licenses/>.
; -----------------------------------------------------------------------------

Func _form_error($errMessage, $errNumber = 0)
	Local $w = 275 * $dScale
	Local $h = 200 * $dScale

	Local $x = @DesktopWidth / 2 - $w / 2
	Local $y = @DesktopHeight / 2 - $h / 2

	If Not BitAND(WinGetState($hgui), $WIN_STATE_MINIMIZED) Then
		$currentWinPos = WinGetPos($hgui)
		$x = $currentWinPos[0] + $guiWidth * $dscale / 2 - $w / 2
		$y = $currentWinPos[1] + $guiHeight * $dscale / 2 - $h / 2
	EndIf

	Local $hChild = GUICreate($oLangStrings.message.error, $w, $h, $x, $y, $WS_CAPTION, -1, $hgui)
	GUISetOnEvent($GUI_EVENT_CLOSE, "_onExitChild")
	GUISetFont($MyGlobalFontSize, -1, -1, $MyGlobalFontName)

	; top section

	GUICtrlCreateLabel("", 0, 0, $w, $h - 32 * $dscale)
	GUICtrlSetBkColor(-1, 0xFFFFFF)
	GUICtrlSetState(-1, $GUI_DISABLE)

	GUICtrlCreateLabel("", 0, $h - 32 * $dscale, $w, 1)
	GUICtrlSetBkColor(-1, 0x000000)

	$pic = GUICtrlCreatePic("", 5 * $dScale, 6 * $dScale, 16, 16)
	_memoryToPic($pic, GetIconData($pngWarning))

	GUICtrlCreateLabel($oLangStrings.message.errorOccurred, 30 * $dscale, 5 * $dscale, 200 * $dscale)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	GUICtrlSetFont(-1, 13)

	If $errNumber <> 0 Then
		GUICtrlCreateLabel($oLangStrings.message.errorCode & ":", 5 * $dscale, 35 * $dscale, 75 * $dscale)
		GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
		GUICtrlCreateLabel($errNumber, 80 * $dscale, 35 * $dscale, 75 * $dscale)
		GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	EndIf

	GUICtrlCreateLabel($errMessage, 5 * $dscale, 53 * $dscale, $w - 10 * $dscale, $h - 53 * $dscale - 32 * $dscale - 5 * $dscale)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)


	; bottom section

	Local $bt_Ok = GUICtrlCreateButton($oLangStrings.buttonOK, $w - 55 * $dScale, $h - 27 * $dScale, 50 * $dScale, 22 * $dScale)
	GUICtrlSetOnEvent(-1, "_onExitChild")

	GUISetState(@SW_DISABLE, $hgui)
	GUISetState(@SW_SHOW, $hChild)
EndFunc   ;==>_form_error2
