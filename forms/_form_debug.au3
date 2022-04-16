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

Func _form_debug()
	$w = 305 * $dScale
	$h = 410 * $dScale

	$currentWinPos = WinGetPos($hgui)
	$x = $currentWinPos[0] + $guiWidth * $dscale / 2 - $w / 2
	$y = $currentWinPos[1] + $guiHeight * $dscale / 2 - $h / 2

	$debugChild = GUICreate("Debug Information", $w, $h, $x, $y, $WS_CAPTION, -1, $hgui)
	GUISetOnEvent($GUI_EVENT_CLOSE, "_onExitChild")
	GUISetFont($MyGlobalFontSize, -1, -1, $MyGlobalFontName)

	GUICtrlCreateLabel("", 0, 0, $w, $h - 32 * $dscale)
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlSetBkColor(-1, 0xFFFFFF)

	GUICtrlCreateLabel("", 0, $h - 32 * $dscale, $w, 1)
	GUICtrlSetBkColor(-1, 0x000000)

	$debuginfo = ""
	$debuginfo &= "OS Version:" & @TAB & @OSVersion & @CRLF
	$debuginfo &= "OS Service Pack:" & @TAB & @OSServicePack & @CRLF
	$debuginfo &= "OS Build:" & @TAB & @TAB & @OSBuild & @CRLF
	$debuginfo &= "OS Lang Code:" & @TAB & @OSLang & @CRLF
	$debuginfo &= "OS Architecture:" & @TAB & @OSArch & @CRLF
	$debuginfo &= "CPU Architecture:" & @TAB & @CPUArch & @CRLF
	$debuginfo &= "Resolution:" & @TAB & _WinAPI_GetSystemMetrics($SM_CXSCREEN) & "x" & _WinAPI_GetSystemMetrics($SM_CYSCREEN) & @CRLF
	$debuginfo &= "DPI:" & @TAB & @TAB & $iDPI & @CRLF

	$edit = GUICtrlCreateEdit($debuginfo, 5, 5, $w - 10, $h - 37 * $dscale - 5, BitOR($ES_READONLY, $WS_VSCROLL, $ES_AUTOVSCROLL), $WS_EX_TRANSPARENT)
	GUICtrlSetBkColor($edit, 0xFFFFFF)
	GUICtrlSetFont(-1, 8.5)

	$bt_Ok = GUICtrlCreateButton("OK", $w - 55 * $dScale, $h - 27 * $dScale, 50 * $dScale, 22 * $dScale)
	GUICtrlSetOnEvent(-1, "_onExitChild")

	GUISetState(@SW_DISABLE, $hgui)
	GUISetState(@SW_SHOW, $debugChild)

	Send("^{HOME}")
EndFunc   ;==>_debugWindow
