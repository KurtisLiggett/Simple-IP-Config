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

Func _form_changelog()
	$w = 400 * $dScale
	$h = 410 * $dScale

	$currentWinPos = WinGetPos($hgui)
	$x = $currentWinPos[0] + $guiWidth * $dscale / 2 - $w / 2
	$y = $currentWinPos[1] + $guiHeight * $dscale / 2 - $h / 2

	$changeLogChild = GUICreate($oLangStrings.changelog.changelog, $w, $h, $x, $y, $WS_CAPTION, -1, $hgui)
	GUISetOnEvent($GUI_EVENT_CLOSE, "_onExitChild")
	GUISetFont($MyGlobalFontSize, -1, -1, $MyGlobalFontName)

	GUICtrlCreateLabel("", 0, 0, $w, $h - 32 * $dscale)
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlSetBkColor(-1, 0xFFFFFF)

	GUICtrlCreateLabel("", 0, $h - 32 * $dscale, $w, 1)
	GUICtrlSetBkColor(-1, 0x000000)

	Local $sChangelog = GetChangeLogData()
	$labelTitle = GUICtrlCreateLabel($sChangelog[0], 5, 5, $w - 10, 20 * $dscale)
	GUICtrlSetColor(-1, 0x0000FF)
	GUICtrlSetBkColor(-1, 0xFFFFFF)
	GUICtrlSetFont(-1, 11)

	$edit = GUICtrlCreateEdit($sChangelog[1], 5, 25, $w - 10, $h - 37 * $dscale - 25, BitOR($ES_READONLY, $WS_VSCROLL, $ES_AUTOVSCROLL), $WS_EX_TRANSPARENT)
	GUICtrlSetBkColor($edit, 0xFFFFFF)
	GUICtrlSetFont(-1, 8.5)

	$bt_Ok = GUICtrlCreateButton($oLangStrings.buttonOK, $w - 55 * $dScale, $h - 27 * $dScale, 50 * $dScale, 22 * $dScale)
	GUICtrlSetOnEvent(-1, "_onExitChild")

	GUISetState(@SW_DISABLE, $hgui)
	GUISetState(@SW_SHOW, $changeLogChild)

	Send("^{HOME}")
EndFunc   ;==>_form_changelog
