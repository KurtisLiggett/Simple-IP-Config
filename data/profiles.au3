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

Func _Profiles()
	Local $oObject = _AutoItObject_Create()

	Local $aNames[0]
	;object properties
	_AutoItObject_AddProperty($oObject, "count", $ELSCOPE_PUBLIC, 0)
	_AutoItObject_AddProperty($oObject, "names", $ELSCOPE_PUBLIC, $aNames)
	_AutoItObject_AddProperty($oObject, "Profiles", $ELSCOPE_PUBLIC, LinkedList())

	;object methods
	_AutoItObject_AddMethod($oObject, "create", "_Profiles_createProfile")
	_AutoItObject_AddMethod($oObject, "add", "_Profiles_addProfile")
	_AutoItObject_AddMethod($oObject, "move", "_Profiles_moveProfile")
	_AutoItObject_AddMethod($oObject, "remove", "_Profiles_removeProfile")
	_AutoItObject_AddMethod($oObject, "removeAll", "_Profiles_removeAllProfiles")
	_AutoItObject_AddMethod($oObject, "get", "_Profiles_getProfile")
	_AutoItObject_AddMethod($oObject, "set", "_Profiles_setProfile")
	_AutoItObject_AddMethod($oObject, "getNames", "_Profiles_getNames")
	_AutoItObject_AddMethod($oObject, "exists", "_Profiles_exists")
	_AutoItObject_AddMethod($oObject, "sort", "_Profiles_sort")
	_AutoItObject_AddMethod($oObject, "getAsSectionStr", "_Profiles_getAsSectionStr")

	Return $oObject
EndFunc   ;==>_Profiles

Func _Profiles_createProfile($oSelf, $sName)
	#forceref $oSelf
	Local $oObject = _AutoItObject_Create()

	;object properties
	_AutoItObject_AddProperty($oObject, "ProfileName", $ELSCOPE_PUBLIC, $sName)
	_AutoItObject_AddProperty($oObject, "AdapterName")
	_AutoItObject_AddProperty($oObject, "IpAuto")
	_AutoItObject_AddProperty($oObject, "IpAddress")
	_AutoItObject_AddProperty($oObject, "IpSubnet")
	_AutoItObject_AddProperty($oObject, "IpGateway")
	_AutoItObject_AddProperty($oObject, "DnsAuto")
	_AutoItObject_AddProperty($oObject, "IpDnsPref")
	_AutoItObject_AddProperty($oObject, "IpDnsAlt")
	_AutoItObject_AddProperty($oObject, "RegisterDns")
	_AutoItObject_AddProperty($oObject, "count", $ELSCOPE_PUBLIC, 10)
	_AutoItObject_AddMethod($oObject, "getSection", "_Profile_getSection")
	_AutoItObject_AddMethod($oObject, "getSectionStr", "_Profile_getSectionStr")

	Return $oObject
EndFunc   ;==>_Profiles_createProfile

Func _Profiles_addProfile($oSelf, $oProfile)
	#forceref $oSelf

	$oSelf.Profiles.add($oProfile)
	$oSelf.count = $oSelf.count + 1

	Local $aNames = $oSelf.names
	If $oSelf.count > UBound($oSelf.names) Then
		ReDim $aNames[$oSelf.count]
	EndIf

	$aNames[$oSelf.count-1] = $oProfile.ProfileName
	$oSelf.names = $aNames
EndFunc   ;==>_Profiles_addProfile

Func _Profiles_moveProfile($oSelf, $sName, $indexTo)
	Local $oProfileMove = $oSelf.get($sName)
	Local $oProfilesTemp = LinkedList()

	;remove from profile name list
	$oSelf.remove($sName)

	;add name at selected position
	Local $aNames = $oSelf.names

	If $indexTo < UBound($aNames) Then
		_ArrayInsert($aNames, $indexTo, $sName)
	Else
		_ArrayAdd($aNames, $sName)
	EndIf

	Local $i = 0
	For $oProfile in $oSelf.Profiles
		If $i = $indexTo Then
			$oProfilesTemp.add($oProfileMove)
			$oProfilesTemp.add($oProfile)
		Else
			$oProfilesTemp.add($oProfile)
		EndIf
		$i += 1
	Next

	If $indexTo = UBound($aNames)-1 Then
		$oProfilesTemp.add($oProfileMove)
	EndIf

	$oSelf.Profiles = 0
	$oSelf.Profiles = $oProfilesTemp
	$oSelf.names = $aNames

	Return 0
EndFunc   ;==>_Profiles_moveProfile

Func _Profiles_getNames($oSelf)
	#forceref $oSelf

	Return $oSelf.names
EndFunc   ;==>_Profiles_getNames

Func _Profiles_exists($oSelf, $sName)
	#forceref $oSelf

	Local $bMatch = False

	For $oProfile in $oSelf.Profiles
		If $oProfile.ProfileName = $sName Then
			$bMatch = True
			ExitLoop
		EndIf
	Next

	Return $bMatch
EndFunc   ;==>_Profiles_exists

Func _Profiles_removeProfile($oSelf, $sName)
	Local $index = 0
	For $oProfile In $oSelf.Profiles
		If $oProfile.ProfileName = $sName Then
			$oSelf.Profiles.remove($index)
			ExitLoop
		EndIf
		$index += 1
	Next

	$index = 0
	Local $aNames = $oSelf.names
	For $name In $aNames
		If $name = $sName Then
			_ArrayDelete($aNames, $index)
			ExitLoop
		EndIf
		$index += 1
	Next
	$oSelf.names = $aNames

	$oSelf.count = $oSelf.count - 1
EndFunc   ;==>_Profiles_removeProfile

Func _Profiles_removeAllProfiles($oSelf)
	$oSelf.Profiles = 0
	$oSelf.Profiles = LinkedList()
	$oSelf.names = 0
	Local $aNames[0]
	$oSelf.names = $aNames
	$oSelf.count = 0
EndFunc   ;==>_Profiles_removeAllProfiles

Func _Profiles_getProfile($oSelf, $sName)
	For $oProfile In $oSelf.Profiles
		If $oProfile.ProfileName = $sName Then
			Return $oProfile
		EndIf
	Next

	Return -1
EndFunc   ;==>_Profiles_getProfile

Func _Profiles_setProfile($oSelf, $sName, $oNewProfile)
	For $oProfile In $oSelf.Profiles
		If $oProfile.ProfileName = $sName Then
			$oProfile = $oNewProfile
		EndIf
	Next

	Return -1
EndFunc   ;==>_Profiles_setProfile

Func _Profiles_sort($oSelf, $iDescending = 0)
	#forceref $oSelf
	Local $oProfilesTemp = LinkedList()
	Local $aNames = $oSelf.names

	;sort the names first
	If Not IsArray($aNames) Then Return 1
	_ArraySort($aNames, $iDescending)

	;recreate the list
	For $i=0 to $oSelf.count-1
		$oProfilesTemp.add($oSelf.get($aNames[$i]))
	Next

	$oSelf.Profiles = 0
	$oSelf.Profiles = $oProfilesTemp
	$oSelf.names = $aNames

	Return 0
EndFunc   ;==>_Profiles_sort

Func _Profiles_getAsSectionStr($oSelf, $sName)
	Local $oProfile = $oSelf.get($sName)
	If IsObj($oProfile) Then
		Local $sSection = $oProfile.getSectionStr()
		Return $sSection
	Else
		Return 1
	EndIf
EndFunc   ;==>_Profiles_getAsSectionStr

Func _Profile_getSectionStr($oSelf)
	Local $sSection = "[" & iniNameEncode($oSelf.ProfileName) & "]" & @CRLF
	$sSection &= "IpAuto=" & $oSelf.IpAuto & @CRLF
	$sSection &= "IpAddress=" & $oSelf.IpAddress & @CRLF
	$sSection &= "IpSubnet=" & $oSelf.IpSubnet & @CRLF
	$sSection &= "IpGateway=" & $oSelf.IpGateway & @CRLF
	$sSection &= "DnsAuto=" & $oSelf.DnsAuto & @CRLF
	$sSection &= "IpDnsPref=" & $oSelf.IpDnsPref & @CRLF
	$sSection &= "IpDnsAlt=" & $oSelf.IpDnsAlt & @CRLF
	$sSection &= "RegisterDns=" & $oSelf.RegisterDns & @CRLF
	$sSection &= "AdapterName=" & $oSelf.AdapterName & @CRLF

	Return $sSection
EndFunc   ;==>_Profile_getSectionStr

Func _Profile_getSection($oSelf)
	#forceref $oSelf
	Local $aObject[$oSelf.count - 1][2]
	$aObject[0][0] = "AdapterName"
	$aObject[0][1] = $oSelf.AdapterName
	$aObject[1][0] = "IpAuto"
	$aObject[1][1] = $oSelf.IpAuto
	$aObject[2][0] = "IpAddress"
	$aObject[2][1] = $oSelf.IpAddress
	$aObject[3][0] = "IpSubnet"
	$aObject[3][1] = $oSelf.IpSubnet
	$aObject[4][0] = "IpGateway"
	$aObject[4][1] = $oSelf.IpGateway
	$aObject[5][0] = "DnsAuto"
	$aObject[5][1] = $oSelf.DnsAuto
	$aObject[6][0] = "IpDnsPref"
	$aObject[6][1] = $oSelf.IpDnsPref
	$aObject[7][0] = "IpDnsAlt"
	$aObject[7][1] = $oSelf.IpDnsAlt
	$aObject[8][0] = "RegisterDns"
	$aObject[8][1] = $oSelf.RegisterDns
	Return $aObject
EndFunc   ;==>_Profile_getSection
