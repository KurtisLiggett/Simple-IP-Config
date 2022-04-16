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

Func _form_restart($langCode, $x, $y)
	$w = 275 * $dScale
	$h = 170 * $dScale
	$x = $x + $guiWidth / 2 - $w / 2
	$y = $y + $guiHeight / 2 - $h / 2

	$RestartChild = GUICreate("", $w, $h, $x, $y, $WS_CAPTION)
	GUISetOnEvent($GUI_EVENT_CLOSE, "_onExitChild")
	GUISetFont($MyGlobalFontSize, -1, -1, $MyGlobalFontName)

	; top section

	GUICtrlCreateLabel("", 0, 0, $w, $h)
	GUICtrlSetBkColor(-1, 0xFFFFFF)
	GUICtrlSetState(-1, $GUI_DISABLE)

	Local $fileData
	Local $hFile = FileOpen(@ScriptDir & "\lang\lang-" & $langCode & ".json", $FO_READ)
	If $hFile = -1 Then
		If $langCode = "en-US" Then
			$fileData = _getEnglish()
		Else
			MsgBox(1, "Error", "Error reading language file")
		EndIf
	Else
		If $hFile = -1 Then
			MsgBox(1, "Error", "Error reading language file")
		EndIf
		$fileData = FileRead($hFile)
		FileClose($hFile)
	EndIf
	Local $jsonData = Json_Decode($fileData)

	GUICtrlCreateLabel(Json_Get($jsonData, ".strings.interface.restarting") & " Simple IP Config", 0, 0, $w, $h, BitOR($SS_CENTER, $SS_CENTERIMAGE))
	GUICtrlSetFont(-1, 13, 800)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)

	GUISetState(@SW_SHOW, $RestartChild)
	Return $RestartChild
EndFunc   ;==>_ShowRestart
