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

#Region -- options --
Global Enum $OPTIONS_Version, $OPTIONS_MinToTray, $OPTIONS_StartupMode, $OPTIONS_Language, _
	$OPTIONS_StartupAdapter, $OPTIONS_Theme, $OPTIONS_SaveAdapterToProfile, $OPTIONS_AdapterBlacklist, _
	$OPTIONS_PositionX, $OPTIONS_PositionY, $OPTIONS_AutoUpdate, $OPTIONS_MAX

; Constructor
Func Options()
    Local $hObject[$OPTIONS_MAX][2]
		$hObject[0][0] = "Version"
		$hObject[1][0] = "MinToTray"
		$hObject[2][0] = "StartupMode"
		$hObject[3][0] = "Language"
		$hObject[4][0] = "StartupAdapter"
		$hObject[5][0] = "Theme"
		$hObject[6][0] = "SaveAdapterToProfile"
		$hObject[7][0] = "AdapterBlacklist"
		$hObject[8][0] = "PositionX"
		$hObject[9][0] = "PositionY"
		$hObject[10][0] = "AutoUpdate"

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

#Region -- profile --

#EndRegion -- profile --

#Region -- adapters --

#EndRegion -- adapters --