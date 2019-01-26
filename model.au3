#Region license
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
#EndRegion license

#Region description
;==============================================================================
; Filename:		model.au3
; Description:	The model defines and stores the data. It does not know
;               where it comes from or where it is used.
;==============================================================================
#EndRegion description

#include-once

#Region -- options --
Global Enum $OPTIONS_Version, $OPTIONS_MinToTray, $OPTIONS_StartupMode, $OPTIONS_Language, _
	$OPTIONS_StartupAdapter, $OPTIONS_Theme, $OPTIONS_SaveAdapterToProfile, $OPTIONS_AdapterBlacklist, _
	$OPTIONS_PositionX, $OPTIONS_PositionY, $OPTIONS_AutoUpdate, $OPTIONS_MAX

; Constructor
Func Options()
    Local $hObject[$OPTIONS_MAX][2]
		$hObject[$OPTIONS_Version][0] = "Version"
		$hObject[$OPTIONS_MinToTray][0] = "MinToTray"
		$hObject[$OPTIONS_StartupMode][0] = "StartupMode"
		$hObject[$OPTIONS_Language][0] = "Language"
		$hObject[$OPTIONS_StartupAdapter][0] = "StartupAdapter"
		$hObject[$OPTIONS_Theme][0] = "Theme"
		$hObject[$OPTIONS_SaveAdapterToProfile][0] = "SaveAdapterToProfile"
		$hObject[$OPTIONS_AdapterBlacklist][0] = "AdapterBlacklist"
		$hObject[$OPTIONS_PositionX][0] = "PositionX"
		$hObject[$OPTIONS_PositionY][0] = "PositionY"
		$hObject[$OPTIONS_AutoUpdate][0] = "AutoUpdate"

    ; Return the 'object'
    Return $hObject
EndFunc

; property Getter
Func Options_GetValue(ByRef $hObject, $iproperty)
	Return _Options_IsObject($hObject) ? $hObject[$iproperty][1] : Null
EndFunc

; property name Getter
Func Options_GetName(ByRef $hObject, $iproperty)
	Return _Options_IsObject($hObject) ? $hObject[$iproperty][0] : Null
EndFunc

; property Setter
Func Options_SetValue(ByRef $hObject, $iproperty, $sData)
    ; If not a valid 'object' then return
    If Not _Options_IsObject($hObject) Then Return

    $hObject[$iproperty][1] = $sData	;set the property
EndFunc   ;==>Options_SetName

; Check if it's a valid 'object'. INTERNAL ONLY!
Func _Options_IsObject(ByRef $hObject)
    Return UBound($hObject) = $Options_MAX
EndFunc   ;==>_Options_IsObject

#EndRegion -- options --

#Region -- profiles --
Global Enum $PROFILES_Name, $PROFILES_AdapterName, $PROFILES_IpAuto, $PROFILES_IpAddress, $PROFILES_IpSubnet, $PROFILES_IpGateway, _
			$PROFILES_DnsAuto, $PROFILES_DnsPref, $PROFILES_DnsAlt, $PROFILES_RegisterDns, $PROFILES_MAX

; Constructor
Func Profiles()
    Local $hObject[1][$PROFILES_MAX]
		$hObject[0][$PROFILES_Name] = "ProfileName"
		$hObject[0][$PROFILES_AdapterName] = "AdapterName"
		$hObject[0][$PROFILES_IpAuto] = "IpAuto"
		$hObject[0][$PROFILES_IpAddress] = "IpAddress"
		$hObject[0][$PROFILES_IpSubnet] = "IpSubnet"
		$hObject[0][$PROFILES_IpGateway] = "IpGateway"
		$hObject[0][$PROFILES_DnsAuto] = "DnsAuto"
		$hObject[0][$PROFILES_DnsPref] = "IpDnsPref"
		$hObject[0][$PROFILES_DnsAlt] = "IpDnsAlt"
		$hObject[0][$PROFILES_RegisterDns] = "RegisterDns"

    ; Return the 'object'
    Return $hObject
EndFunc

; sort profiles
Func Profiles_Sort(ByRef $hObject, $desc=0)
	If Not _Profiles_IsObject($hObject) Then Return Null

	_ArraySort($hObject, $desc, 1)
EndFunc

; get size
Func Profiles_GetSize(ByRef $hObject)
	If Not _Profiles_IsObject($hObject) Then Return Null

	Return UBound($hObject)-1
EndFunc

; Check if name does not exist
Func Profiles_isNewName(ByRef $hObject, $sName)
	If Not _Profiles_IsObject($hObject) Then Return Null

	$profIndex = _ArraySearch($hObject, $sName)
	Return $profIndex = -1 ? 1 : 0
EndFunc

; property Getter by index
Func Profiles_GetValueByIndex(ByRef $hObject, $iIndex, $iproperty)
	If Not _Profiles_IsObject($hObject) Then Return Null

	Return $hObject[$iIndex+1][$iproperty]
EndFunc

; property Getter by name
Func Profiles_GetValue(ByRef $hObject, $sName, $iproperty)
	If Not _Profiles_IsObject($hObject) Then Return Null

	$profIndex = _ArraySearch($hObject, $sName)
	Return $profIndex <> -1 ? $hObject[$profIndex][$iproperty] : Null
EndFunc

; property name Getter
Func Profiles_GetKeyName(ByRef $hObject, $iproperty)
	Return _Profiles_IsObject($hObject) ? $hObject[0][$iproperty] : Null
EndFunc

; property Setter
Func Profiles_SetValue(ByRef $hObject, $sName, $iproperty, $sData)
    ; If not a valid 'object' then return
    If Not _Profiles_IsObject($hObject) Then Return

	$profIndex = _ArraySearch($hObject, $sName)
	If $profIndex = -1 Then Return

    $hObject[$profIndex][$iproperty] = $sData	;set the property
EndFunc

; Get entire profile
Func Profiles_GetProfile(ByRef $hObject, $sName)
	If Not _Profiles_IsObject($hObject) Then Return

	Local $aProfile[$PROFILES_MAX]
	For $i = 0 to $PROFILES_MAX-1
		$aProfile[$i] = Profiles_GetValue($hObject, $sName, $i)
	Next

	Return $aProfile
EndFunc

; insert entire profile
Func Profiles_InsertProfile(ByRef $hObject, $index, $sName, ByRef $aProfile)
	If Not _Profiles_IsObject($hObject) Then Return
	If Not Profiles_isNewName($hObject, $sName) Then Return

	If $index+1 < UBound($hObject) Then
		_ArrayInsert($hObject, $index+1, $sName)
	Else
		_ArrayAdd($hObject, $sName)
	EndIf

	For $i = 0 to $PROFILES_MAX-1
		Profiles_SetValue($hObject, $sName, $i, $aProfile[$i])
	Next
EndFunc

; add profile
Func Profiles_Add(ByRef $hObject, $sName)
	If Not _Profiles_IsObject($hObject) Then Return
    _ArrayAdd($hObject, $sName)
EndFunc


; delete profile
Func Profiles_Delete(ByRef $hObject, $sName)
	If Not _Profiles_IsObject($hObject) Then Return

	$profIndex = _ArraySearch($hObject, $sName)
	If $profIndex = -1 Then Return

    _ArrayDelete($hObject, $profIndex)
EndFunc

; delete all profiles
Func Profiles_DeleteAll(ByRef $hObject)
	If Not _Profiles_IsObject($hObject) Then Return

    _ArrayDelete($hObject, "1-"&UBound($hObject))
EndFunc

; Check if it's a valid 'object'. INTERNAL ONLY!
Func _Profiles_IsObject(ByRef $hObject)
    Return UBound($hObject, 2) = $PROFILES_MAX
EndFunc

; Create new profile array
Func Profiles_CreateSection()
	Local $section[$PROFILES_MAX-1][2]
	Local $tempProfiles = Profiles()
	For $i = 1 to $PROFILES_MAX-1
		$section[$i-1][0] = Profiles_GetKeyName($tempProfiles, $i)
	Next
	Return $section
EndFunc

; Add property to the section
Func Profiles_SectionSetValue(ByRef $aSection, $iproperty, $sData)
	$aSection[$iproperty-1][1] = $sData
EndFunc

; Add section to profiles object
Func Profiles_AddSection(ByRef $hObject, $sName, ByRef $aSection)
	If Not _Profiles_IsObject($hObject) Then Return

	If Profiles_isNewName($hObject, $sName) Then ;profile does not exist
		Profiles_Add($hObject, $sName)		;create new, otherwise update
	EndIf

	For $i = 0 to UBound($aSection)-1
		Profiles_SetValue($hObject, $sName, $i+1, $aSection[$i][1])
	Next
EndFunc

; Get array of profile names
Func Profiles_GetNames(ByRef $hObject)
	If Not _Profiles_IsObject($hObject) Then Return

	$size = UBound($hObject)-1
    Local $aNames[$size]
	For $i = 0 to $size-1
		$aNames[$i] = $hObject[$i+1][0]
	Next
	Return $aNames
EndFunc

#EndRegion -- profiles --

#Region -- adapters --
Global Enum $ADAPTER_Name, $ADAPTER_Description, $ADAPTER_MAC, $ADAPTER_MAX

; Constructor
Func Adapter()
	Local $hObject[1][3] = [[0,0,0]]	; [0]-name, [1]-mac, [2]-description, [3]-GUID

    ; Return the 'object'
    Return $hObject
EndFunc

; Check if name exists
Func Adapter_Exists(ByRef $hObject, $sName)
	If Not _Adapter_IsObject($hObject) Then Return Null

	$iIndex = _ArraySearch($hObject, $sName)
	Return $iIndex = -1 ? 0 : 1
EndFunc

; sort Adapter
Func Adapter_Sort(ByRef $hObject, $desc=0)
	If Not _Adapter_IsObject($hObject) Then Return Null

	_ArraySort($hObject, $desc)
EndFunc

; get size
Func Adapter_GetSize(ByRef $hObject)
	If Not _Adapter_IsObject($hObject) Then Return Null

	Return UBound($hObject)
EndFunc

; property Getters
Func Adapter_GetName(ByRef $hObject, $iIndex)
	If Not _Adapter_IsObject($hObject) Then Return Null

	Return $iIndex <> -1 ? $hObject[$iIndex][0] : Null
EndFunc

Func Adapter_GetMAC(ByRef $hObject, $sName)
	If Not _Adapter_IsObject($hObject) Then Return Null

	$iIndex = _ArraySearch($hObject, $sName)
	Return $iIndex <> -1 ? $hObject[$iIndex][1] : Null
EndFunc

Func Adapter_GetDescription(ByRef $hObject, $sName)
	If Not _Adapter_IsObject($hObject) Then Return Null

	$iIndex = _ArraySearch($hObject, $sName)
	Return $iIndex <> -1 ? $hObject[$iIndex][2] : Null
EndFunc

; add adapter
Func Adapter_Add(ByRef $hObject, $sName, $sMAC, $sDescription)
	If Not _Adapter_IsObject($hObject) Then Return

	If UBound($hObject) = 1 and $hObject[0][0] = "" Then
		$hObject[0][0] = $sName
		$hObject[0][1] = $sMAC
		$hObject[0][2] = $sDescription
	Else
		_ArrayAdd($hObject, $sName & "|" & $sMAC & "|" & $sDescription)
	EndIf
EndFunc

; delete profile
Func Adapter_Delete(ByRef $hObject, $sName)
	If Not _Adapter_IsObject($hObject) Then Return

	$profIndex = _ArraySearch($hObject, $sName)
	If $profIndex = -1 Then Return

    _ArrayDelete($hObject, $profIndex)
EndFunc

; delete all Adapters
Func Adapter_DeleteAll(ByRef $hObject)
	If Not _Adapter_IsObject($hObject) Then Return

    _ArrayDelete($hObject, "0-"&UBound($hObject)-1)
EndFunc

; Check if it's a valid 'object'. INTERNAL ONLY!
Func _Adapter_IsObject(ByRef $hObject)
    Return UBound($hObject, 2) = $ADAPTER_MAX
EndFunc

; Get array of profile names
Func Adapter_GetNames(ByRef $hObject)
	If Not _Adapter_IsObject($hObject) Then Return

	$size = UBound($hObject)
    Local $aNames[$size]
	For $i = 0 to $size-1
		$aNames[$i] = $hObject[$i][0]
	Next
	Return $aNames
EndFunc
#EndRegion -- adapters --