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

Func _form_blacklist()
	$sBlacklist = $options.AdapterBlacklist
	Local $aBlacklist = StringSplit($sBlacklist, "|", 2)

	$w = 275 * $dScale
	$h = 300 * $dScale

	$currentWinPos = WinGetPos($hgui)
	$x = $currentWinPos[0] + $guiWidth * $dscale / 2 - $w / 2
	$y = $currentWinPos[1] + $guiHeight * $dscale / 2 - $h / 2

	$blacklistChild = GUICreate($oLangStrings.blacklist.title, $w, $h, $x, $y, $WS_CAPTION, -1, $hgui)
	GUISetOnEvent($GUI_EVENT_CLOSE, "_onExitChild")
	GUISetFont($MyGlobalFontSize, -1, -1, $MyGlobalFontName)

	GUICtrlCreateLabel("", 0, 0, $w, $h - 32 * $dscale)
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlSetBkColor(-1, 0xFFFFFF)

	GUICtrlCreateLabel("", 0, $h - 32 * $dscale, $w, 1)
	GUICtrlSetBkColor(-1, 0x000000)

	$labelTitle = GUICtrlCreateLabel($oLangStrings.blacklist.heading, 5, 5, $w - 10, 20 * $dscale)
;~ 	GUICtrlSetColor(-1, 0x0000FF)
	GUICtrlSetBkColor(-1, 0xFFFFFF)
	GUICtrlSetFont(-1, 12)

;~ 	$labelTitleLine = GUICtrlCreateLabel("", 2, 20*$dscale+5+3, $w-4, 1)
;~ 	GUICtrlSetBkColor (-1, 0x999999)

	$blacklistLV = GUICtrlCreateListView("Adapter Name", 5, 35 * $dscale, $w - 10, $h - 35 * $dscale - 35 * $dscale, BitOR($GUI_SS_DEFAULT_LISTVIEW, $LVS_NOCOLUMNHEADER), $LVS_EX_CHECKBOXES)
	GUICtrlSetBkColor($blacklistLV, 0xFFFFFF)
	_GUICtrlListView_SetColumnWidth($blacklistLV, 0, $w - 20 * $dscale)    ; sets column width
	Local $aAdapters = Adapter_GetNames($adapters)
	$numAdapters = UBound($aAdapters)
	If $numAdapters > 0 Then
		For $i = 0 To $numAdapters - 1
			GUICtrlCreateListViewItem($aAdapters[$i], $blacklistLV)
			If _ArraySearch($aBlacklist, $aAdapters[$i]) <> -1 Then
				_GUICtrlListView_SetItemChecked($blacklistLV, $i)
			EndIf
		Next
	EndIf

	$bt_Ok = GUICtrlCreateButton($oLangStrings.buttonSave, $w - 20 * $dScale - 75 * $dScale, $h - 27 * $dScale, 75 * $dScale, 22 * $dScale)
	GUICtrlSetOnEvent(-1, "_onExitBlacklistOk")
	$bt_Cancel = GUICtrlCreateButton($oLangStrings.buttonCancel, $w - 20 * $dScale - 75 * $dScale * 2 - 5, $h - 27 * $dScale, 75 * $dScale, 22 * $dScale)
	GUICtrlSetOnEvent(-1, "_onExitChild")

	GUICtrlSetState($bt_Cancel, $GUI_FOCUS)

	GUISetState(@SW_DISABLE, $hgui)
	GUISetState(@SW_SHOW, $blacklistChild)

	Send("{END}")
EndFunc   ;==>_form_blacklist


;------------------------------------------------------------------------------
; Title........: _onExitBlacklistOk
; Description..: save the the Blacklist child window data,
;                then call the exit function
; Events.......: Blacklist window 'Save' button
;------------------------------------------------------------------------------
Func _onExitBlacklistOk()
	$guiState = WinGetState($hgui)
	$newBlacklist = ""
	$itemCount = _GUICtrlListView_GetItemCount($blacklistLV)

	For $i = 0 To $itemCount - 1
		If _GUICtrlListView_GetItemChecked($blacklistLV, $i) Then
			$newBlacklist &= _GUICtrlListView_GetItemTextString($blacklistLV, $i) & "|"
		EndIf
	Next
	$newBlacklist = StringLeft($newBlacklist, StringLen($newBlacklist) - 1)

	$newBlacklist = iniNameEncode($newBlacklist)
	$options.AdapterBlacklist = $newBlacklist
	IniWrite($sProfileName, "options", "AdapterBlacklist", $options.AdapterBlacklist)

	_ExitChild(@GUI_WinHandle)
	_updateCombo()
EndFunc   ;==>_onExitBlacklistOk
