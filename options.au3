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

Func _Options()
	Local $oObject = _AutoItObject_Create()

	;object properties
	_AutoItObject_AddProperty($oObject, "Version")
	_AutoItObject_AddProperty($oObject, "MinToTray")
	_AutoItObject_AddProperty($oObject, "StartupMode")
	_AutoItObject_AddProperty($oObject, "Language")
	_AutoItObject_AddProperty($oObject, "StartupAdapter")
	_AutoItObject_AddProperty($oObject, "Theme")
	_AutoItObject_AddProperty($oObject, "SaveAdapterToProfile")
	_AutoItObject_AddProperty($oObject, "AdapterBlacklist")
	_AutoItObject_AddProperty($oObject, "PositionX")
	_AutoItObject_AddProperty($oObject, "PositionY")
	_AutoItObject_AddProperty($oObject, "AutoUpdate")
	_AutoItObject_AddProperty($oObject, "LastUpdateCheck")
	_AutoItObject_AddProperty($oObject, "count", $ELSCOPE_PRIVATE, 12)

	;object methods
	_AutoItObject_AddMethod($oObject, "getSection", "_Options_getSection")
	_AutoItObject_AddMethod($oObject, "getSectionStr", "_Options_getSectionStr")

	Return $oObject
EndFunc   ;==>_Options

Func _Options_getSectionStr($oSelf)
	Local $sSection = "[Options]" & @CRLF
	$sSection &= "Version=" & $oSelf.Version & @CRLF
	$sSection &= "MinToTray=" & $oSelf.MinToTray & @CRLF
	$sSection &= "StartupMode=" & $oSelf.StartupMode & @CRLF
	$sSection &= "Language=" & $oSelf.Language & @CRLF
	$sSection &= "StartupAdapter=" & $oSelf.StartupAdapter & @CRLF
	$sSection &= "Theme=" & $oSelf.Theme & @CRLF
	$sSection &= "SaveAdapterToProfile=" & $oSelf.SaveAdapterToProfile & @CRLF
	$sSection &= "AdapterBlacklist=" & $oSelf.AdapterBlacklist & @CRLF
	$sSection &= "PositionX=" & $oSelf.PositionX & @CRLF
	$sSection &= "PositionY=" & $oSelf.PositionY & @CRLF
	$sSection &= "AutoUpdate=" & $oSelf.AutoUpdate & @CRLF
	$sSection &= "LastUpdateCheck=" & $oSelf.LastUpdateCheck & @CRLF
	Return $sSection
EndFunc   ;==>_Options_getSectionStr

Func _Options_getSection($oSelf)
	#forceref $oSelf
	Local $aObject[$oSelf.count][2]
	$aObject[0][0] = "Version"
	$aObject[0][1] = $oSelf.Version
	$aObject[1][0] = "MinToTray"
	$aObject[1][1] = $oSelf.MinToTray
	$aObject[2][0] = "StartupMode"
	$aObject[2][1] = $oSelf.StartupMode
	$aObject[3][0] = "Language"
	$aObject[3][1] = $oSelf.Language
	$aObject[4][0] = "StartupAdapter"
	$aObject[4][1] = $oSelf.StartupAdapter
	$aObject[5][0] = "Theme"
	$aObject[5][1] = $oSelf.Theme
	$aObject[6][0] = "SaveAdapterToProfile"
	$aObject[6][1] = $oSelf.SaveAdapterToProfile
	$aObject[7][0] = "AdapterBlacklist"
	$aObject[7][1] = $oSelf.AdapterBlacklist
	$aObject[8][0] = "PositionX"
	$aObject[8][1] = $oSelf.PositionX
	$aObject[9][0] = "PositionY"
	$aObject[9][1] = $oSelf.PositionY
	$aObject[10][0] = "AutoUpdate"
	$aObject[10][1] = $oSelf.AutoUpdate
	$aObject[11][0] = "LastUpdateCheck"
	$aObject[11][1] = $oSelf.LastUpdateCheck
	Return $aObject
EndFunc   ;==>_Options_getSection
