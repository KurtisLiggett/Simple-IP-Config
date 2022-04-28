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

Func _form_about()
	Local $bt_AboutOk, $lb_Heading, $lb_date, $lb_version, $lb_info, $lb_sig, $pic, $lb_license, $GFLine
	$w = 275 * $dScale
	$h = 200 * $dScale

	If Not BitAND(WinGetState($hgui), $WIN_STATE_MINIMIZED) Then
		$currentWinPos = WinGetPos($hgui)
		$x = $currentWinPos[0] + $guiWidth * $dscale / 2 - $w / 2
		$y = $currentWinPos[1] + $guiHeight * $dscale / 2 - $h / 2
	Else
		$x = @DesktopWidth / 2 - $w / 2
		$y = @DesktopHeight / 2 - $h / 2
	EndIf

	$AboutChild = GUICreate($oLangStrings.about.title & " Simple IP Config", $w, $h, $x, $y, $WS_CAPTION, -1, $hgui)
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
	GUICtrlCreateLabel($oLangStrings.about.version & ":", 95 * $dscale, 38 * $dscale, 75 * $dscale, -1, $SS_RIGHT)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	GUICtrlCreateLabel($oLangStrings.about.date & ":", 95 * $dscale, 53 * $dscale, 75 * $dscale, -1, $SS_RIGHT)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	GUICtrlCreateLabel($oLangStrings.about.dev & ":", 95 * $dscale, 69 * $dscale, 75 * $dscale, -1, $SS_RIGHT)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	GUICtrlCreateLabel($winVersion, 174 * $dscale, 38 * $dscale, 75 * $dscale, -1)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	GUICtrlCreateLabel($winDate, 174 * $dscale, 53 * $dscale, 75 * $dscale, -1)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	GUICtrlCreateLabel("Kurtis Liggett", 174 * $dscale, 69 * $dscale, 75 * $dscale, -1)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)

	GUICtrlCreateLabel($oLangStrings.about.lic & ":", 95 * $dscale, 84 * $dscale, 75 * $dscale, -1, $SS_RIGHT)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	GUICtrlCreateLabel("GNU GPL v3", 174 * $dscale, 84 * $dscale, 75 * $dscale, -1)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)

	$desc = $oLangStrings.about.desc
	GUICtrlCreateLabel($desc, 8, 110 * $dscale, $w - 16, 50 * $dscale)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)

	; bottom section

	$bt_AboutOk = GUICtrlCreateButton($oLangStrings.buttonOK, $w - 55 * $dScale, $h - 27 * $dScale, 50 * $dScale, 22 * $dScale)
	GUICtrlSetOnEvent(-1, "_onExitChild")

	GUISetState(@SW_DISABLE, $hgui)
	GUISetState(@SW_SHOW, $AboutChild)
EndFunc   ;==>_form_about
