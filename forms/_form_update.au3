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

Func _form_update($thisVersion, $currentVersion, $isNew = 0)
	Local $bt_UpdateOk, $lb_Heading, $lb_date, $lb_version, $lb_info, $lb_sig, $pic, $lb_license, $GFLine
	$w = 275 * $dScale
	$h = 170 * $dScale

	If Not BitAND(WinGetState($hgui), $WIN_STATE_MINIMIZED) Then
		$currentWinPos = WinGetPos($hgui)
		$x = $currentWinPos[0] + $guiWidth * $dscale / 2 - $w / 2
		$y = $currentWinPos[1] + $guiHeight * $dscale / 2 - $h / 2
	Else
		$x = @DesktopWidth / 2 - $w / 2
		$y = @DesktopHeight / 2 - $h / 2
	EndIf

	$UpdateChild = GUICreate($oLangStrings.updates.title, $w, $h, $x, $y, $WS_CAPTION, -1, $hgui)
	GUISetOnEvent($GUI_EVENT_CLOSE, "_onExitChild")
	GUISetFont($MyGlobalFontSize, -1, -1, $MyGlobalFontName)

	; top section

	GUICtrlCreateLabel("", 0, 0, $w, $h - 32 * $dscale)
	GUICtrlSetBkColor(-1, 0xFFFFFF)
	GUICtrlSetState(-1, $GUI_DISABLE)

	GUICtrlCreateLabel("", 0, $h - 32 * $dscale, $w, 1)
	GUICtrlSetBkColor(-1, 0x000000)

	$pic = GUICtrlCreatePic("", 17 * $dScale, 22 * $dScale, 64, 64)
	_memoryToPic($pic, GetIconData($pngBigicon))

	GUICtrlCreateLabel("Simple IP Config", 75 * $dscale, 10 * $dscale, 200 * $dscale, -1, $SS_CENTER)
	GUICtrlSetFont(-1, 13, 800)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	GUICtrlCreateLabel($oLangStrings.updates.thisVersion & ":", 50 * $dscale, 38 * $dscale, 120 * $dscale, -1, $SS_RIGHT)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	GUICtrlCreateLabel($oLangStrings.updates.latestVersion & ":", 50 * $dscale, 53 * $dscale, 120 * $dscale, -1, $SS_RIGHT)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	GUICtrlCreateLabel($thisVersion, 175 * $dscale, 38 * $dscale, 75 * $dscale, -1)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	GUICtrlCreateLabel($currentVersion, 175 * $dscale, 53 * $dscale, 75 * $dscale, -1)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)

	GUICtrlCreateLabel("", 0, 100 * $dscale, $w, 1)
	GUICtrlSetBkColor(-1, 0x000000)

	Local $descX
	If $isNew Then
		$desc = $oLangStrings.updates.newMessage
		$descX = 45

		$link = GUICtrlCreateLabel("here", 199 * $dscale, 110 * $dscale, -1, 20 * $dscale)
		GUICtrlSetOnEvent(-1, "_updateLink")
		GUICtrlSetColor(-1, 0x0000FF)
		GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
		GUICtrlSetFont(-1, -1, -1, $GUI_FONTUNDER)
		GUICtrlSetTip(-1, 'Visit: https://github.com/KurtisLiggett/Simple-IP-Config/releases/latest')
		GUICtrlSetCursor(-1, 0)
	Else
		$desc = $oLangStrings.updates.latestMessage
		$descX = 60
	EndIf
	GUICtrlCreateLabel($desc, $descX * $dscale, 110 * $dscale, $w - 20, 20 * $dscale)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)

	; bottom section
	$bt_UpdateOk = GUICtrlCreateButton($oLangStrings.buttonOK, $w - 55 * $dScale, $h - 27 * $dScale, 50 * $dScale, 22 * $dScale)
	GUICtrlSetOnEvent(-1, "_onExitChild")

	GUISetState(@SW_DISABLE, $hgui)
	GUISetState(@SW_SHOW, $UpdateChild)
EndFunc   ;==>_form_update
