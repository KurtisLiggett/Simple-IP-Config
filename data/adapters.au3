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

#Region -- adapters --
Global Enum $ADAPTER_Name, $ADAPTER_Description, $ADAPTER_MAC, $ADAPTER_MAX

; Constructor
Func Adapter()
	Local $hObject[1][3] = [[0, 0, 0]]  ; [0]-name, [1]-mac, [2]-description, [3]-GUID

	; Return the 'object'
	Return $hObject
EndFunc   ;==>Adapter

; Check if name exists
Func Adapter_Exists(ByRef $hObject, $sName)
	If Not _Adapter_IsObject($hObject) Then Return Null

	Local $iIndex = _ArraySearch($hObject, $sName)
	Return $iIndex = -1 ? 0 : 1
EndFunc   ;==>Adapter_Exists

; sort Adapter
Func Adapter_Sort(ByRef $hObject, $desc = 0)
	If Not _Adapter_IsObject($hObject) Then Return Null

	_ArraySort($hObject, $desc)
EndFunc   ;==>Adapter_Sort

; get size
Func Adapter_GetSize(ByRef $hObject)
	If Not _Adapter_IsObject($hObject) Then Return Null

	Return UBound($hObject)
EndFunc   ;==>Adapter_GetSize

; property Getters
Func Adapter_GetName(ByRef $hObject, $iIndex)
	If Not _Adapter_IsObject($hObject) Then Return Null

	Return $iIndex <> -1 ? $hObject[$iIndex][0] : Null
EndFunc   ;==>Adapter_GetName

Func Adapter_GetMAC(ByRef $hObject, $sName)
	If Not _Adapter_IsObject($hObject) Then Return Null

	Local $iIndex = _ArraySearch($hObject, $sName)
	Return $iIndex <> -1 ? $hObject[$iIndex][1] : Null
EndFunc   ;==>Adapter_GetMAC

Func Adapter_GetDescription(ByRef $hObject, $sName)
	If Not _Adapter_IsObject($hObject) Then Return Null

	Local $iIndex = _ArraySearch($hObject, $sName)
	Return $iIndex <> -1 ? $hObject[$iIndex][2] : Null
EndFunc   ;==>Adapter_GetDescription

; add adapter
Func Adapter_Add(ByRef $hObject, $sName, $sMAC, $sDescription)
	If Not _Adapter_IsObject($hObject) Then Return

	If UBound($hObject) = 1 And $hObject[0][0] = "" Then
		$hObject[0][0] = $sName
		$hObject[0][1] = $sMAC
		$hObject[0][2] = $sDescription
	Else
;~ 		$ret = _ArrayAdd($hObject, $sName & "|" & $sMAC & "|" & $sDescription, 0, "|")
		Local $size = UBound($hObject)
		ReDim $hObject[$size+1][3]
		$hObject[$size][0] = $sName
		$hObject[$size][1] = $sMAC
		$hObject[$size][2] = $sDescription
	EndIf

EndFunc   ;==>Adapter_Add

; delete profile
Func Adapter_Delete(ByRef $hObject, $sName)
	If Not _Adapter_IsObject($hObject) Then Return

	Local $profIndex = _ArraySearch($hObject, $sName)
	If $profIndex = -1 Then Return

	_ArrayDelete($hObject, $profIndex)
EndFunc   ;==>Adapter_Delete

; delete all Adapters
Func Adapter_DeleteAll(ByRef $hObject)
	If Not _Adapter_IsObject($hObject) Then Return

	_ArrayDelete($hObject, "0-" & UBound($hObject) - 1)
EndFunc   ;==>Adapter_DeleteAll

; Check if it's a valid 'object'. INTERNAL ONLY!
Func _Adapter_IsObject(ByRef $hObject)
	Return UBound($hObject, 2) = $ADAPTER_MAX
EndFunc   ;==>_Adapter_IsObject

; Get array of profile names
Func Adapter_GetNames(ByRef $hObject)
	If Not _Adapter_IsObject($hObject) Then Return

	Local $size = UBound($hObject)
	Local $aNames[$size]
	For $i = 0 To $size - 1
		$aNames[$i] = $hObject[$i][0]
	Next
	Return $aNames
EndFunc   ;==>Adapter_GetNames
#EndRegion -- adapters --
