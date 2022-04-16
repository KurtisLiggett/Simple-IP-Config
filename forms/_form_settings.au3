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

Func _formm_settings()
	$w = 335 * $dScale
	$h = 200 * $dScale

	$currentWinPos = WinGetPos($hgui)
	$x = $currentWinPos[0] + $guiWidth * $dscale / 2 - $w / 2
	$y = $currentWinPos[1] + $guiHeight * $dscale / 2 - $h / 2

	$settingsChild = GUICreate($oLangStrings.settings.title, $w, $h, $x, $y, $WS_CAPTION, -1, $hgui)
	GUISetOnEvent($GUI_EVENT_CLOSE, "_onExitChild")
	GUISetFont($MyGlobalFontSize, -1, -1, $MyGlobalFontName)

	GUICtrlCreateLabel("", 0, 0, $w, $h - 32 * $dscale)
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlSetBkColor(-1, 0xFFFFFF)

	GUICtrlCreateLabel("", 0, $h - 32 * $dscale, $w, 1)
	GUICtrlSetBkColor(-1, 0x000000)

	$lb_language = GUICtrlCreateLabel($oLangStrings.settings.lang, 10 * $dScale, 10 * $dScale)
	GUICtrlSetBkColor(-1, 0xFFFFFF)

	Local $strOptionsLang = $options.Language
	Local $aLangsAvailable = _getLangsAvailable()
	Local $langNameStr
	For $i = 0 To UBound($aLangsAvailable) - 1
		If $aLangsAvailable[$i] <> "" Then
			If StringInStr($aLangsAvailable[$i], $strOptionsLang) Then
				$strOptionsLang = $aLangsAvailable[$i]
			EndIf
			If Not StringInStr($langNameStr, $aLangsAvailable[$i]) And $aLangsAvailable[$i] <> "English   (en-US)" Then
				$langNameStr &= $aLangsAvailable[$i] & "|"
			EndIf
		Else
			ExitLoop
		EndIf
	Next
	$cmb_langSelect = GUICtrlCreateCombo("English   (en-US)", 10 * $dScale, 28 * $dScale, $w - 20 * $dScale, -1, BitOR($CBS_DROPDOWNlist, $CBS_AUTOHSCROLL, $WS_VSCROLL))
	If $langNameStr <> "" Then
		GUICtrlSetData(-1, $langNameStr)
	EndIf
	ControlCommand($settingsChild, "", $cmb_langSelect, "SelectString", $strOptionsLang)

	$ck_startinTray = GUICtrlCreateCheckbox($oLangStrings.settings.opt1, 10 * $dScale, 60 * $dScale, $w - 50 * $dScale, 20 * $dScale)
	GUICtrlSetBkColor(-1, 0xFFFFFF)
	GUICtrlSetState($ck_startinTray, _StrToState($options.StartupMode))
	$ck_mintoTray = GUICtrlCreateCheckbox($oLangStrings.settings.opt2, 10 * $dScale, 80 * $dScale, $w - 50 * $dScale, 20 * $dScale)
	GUICtrlSetBkColor(-1, 0xFFFFFF)
	GUICtrlSetState($ck_mintoTray, _StrToState($options.MinToTray))
	$ck_saveAdapter = GUICtrlCreateCheckbox($oLangStrings.settings.opt3, 10 * $dScale, 100 * $dScale, $w - 50 * $dScale, 20 * $dScale)
	GUICtrlSetBkColor(-1, 0xFFFFFF)
	GUICtrlSetState($ck_saveAdapter, _StrToState($options.SaveAdapterToProfile))

	$ck_autoUpdate = GUICtrlCreateCheckbox($oLangStrings.settings.opt4, 10 * $dScale, 120 * $dScale, $w - 50 * $dScale, 20 * $dScale)
	GUICtrlSetBkColor(-1, 0xFFFFFF)
	GUICtrlSetState($ck_autoUpdate, _StrToState($options.AutoUpdate))

	$bt_optSave = GUICtrlCreateButton($oLangStrings.buttonSave, $w - 20 * $dScale - 75 * $dScale, $h - 27 * $dScale, 75 * $dScale, 22 * $dScale)
	GUICtrlSetOnEvent($bt_optSave, "_saveOptions")
	$bt_optCancel = GUICtrlCreateButton($oLangStrings.buttonCancel, $w - 20 * $dScale - 75 * $dScale * 2 - 5, $h - 27 * $dScale, 75 * $dScale, 22 * $dScale)
	GUICtrlSetOnEvent($bt_optCancel, "_onExitChild")

	GUISetState(@SW_DISABLE, $hgui)
	GUISetState(@SW_SHOW, $settingsChild)
EndFunc   ;==>_formm_settings


Func _saveOptions()
	Local $updateGUI = 0
	$options.StartupMode = _StateToStr($ck_startinTray)
	$options.MinToTray = _StateToStr($ck_mintoTray)
	$options.SaveAdapterToProfile = _StateToStr($ck_saveAdapter)
	$options.AutoUpdate = _StateToStr($ck_autoUpdate)

	Local $langRet = StringLeft(StringRight(GUICtrlRead($cmb_langSelect), 6), 5)
	If $langRet <> -1 Then
		If $langRet <> $oLangStrings.OSLang Then
			$updateGUI = 1
			$oLangStrings.OSLang = $langRet
			$options.Language = $oLangStrings.OSLang
		EndIf
	EndIf

	IniWriteSection($sProfileName, "options", $options.getSection(), 0)
	_ExitChild(@GUI_WinHandle)

	If $updateGUI Then
		GUIDelete($hgui)
		Local $restartGUI = _form_restart($oLangStrings.OSLang, $options.PositionX, $options.PositionY)
		_setLangStrings($oLangStrings.OSLang)
		_makeGUI()
;~ 		_updateLang()
		_loadAdapters()
		GUIDelete($restartGUI)

		;Add adapters the the combobox
		If Not IsArray($adapters) Then
			MsgBox(16, $oLangStrings.message.error, $oLangStrings.message.errorRetrieving)
		Else
			Adapter_Sort($adapters)    ; connections sort ascending
			$defaultitem = Adapter_GetName($adapters, 0)
			$sStartupAdapter = $options.StartupAdapter
			If Adapter_Exists($adapters, $sStartupAdapter) Then
				$defaultitem = $sStartupAdapter
			EndIf

			$sAdapterBlacklist = $options.AdapterBlacklist
			$aBlacklist = StringSplit($sAdapterBlacklist, "|")
			If IsArray($aBlacklist) Then
				Local $adapterNames = Adapter_GetNames($adapters)
				For $i = 0 To UBound($adapterNames) - 1
					$indexBlacklist = _ArraySearch($aBlacklist, $adapterNames[$i], 1)
					If $indexBlacklist <> -1 Then ContinueLoop
					GUICtrlSetData($combo_adapters, $adapterNames[$i], $defaultitem)
				Next
			EndIf
		EndIf

		_refresh(1)
		ControlListView($hgui, "", $list_profiles, "Select", 0)
	EndIf
EndFunc   ;==>_saveOptions
