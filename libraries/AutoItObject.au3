; #INDEX# =======================================================================================================================
; Title .........: AutoItObject v1.2.8.3
; AutoIt Version : 3.3
; Language ......: English (language independent)
; Description ...: Brings Objects to AutoIt.
; Author(s) .....: monoceres, trancexx, Kip, Prog@ndy
; Copyright .....: Copyright (C) The AutoItObject-Team. All rights reserved.
; License .......: Artistic License 2.0, see Artistic.txt
;
; This file is part of AutoItObject.
;
; AutoItObject is free software; you can redistribute it and/or modify
; it under the terms of the Artistic License as published by Larry Wall,
; either version 2.0, or (at your option) any later version.
;
; This program is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
; See the Artistic License for more details.
;
; You should have received a copy of the Artistic License with this Kit,
; in the file named "Artistic.txt".  If not, you can get a copy from
; <http://www.perlfoundation.org/artistic_license_2_0> OR
; <http://www.opensource.org/licenses/artistic-license-2.0.php>
;
; ------------------------ AutoItObject CREDITS: ------------------------
; Copyright (C) by:
; The AutoItObject-Team:
; 	Andreas Karlsson (monoceres)
; 	Dragana R. (trancexx)
; 	Dave Bakker (Kip)
; 	Andreas Bosch (progandy, Prog@ndy)
;
; ===============================================================================================================================
#include-once
#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6


; #CURRENT# =====================================================================================================================
;_AutoItObject_AddDestructor
;_AutoItObject_AddEnum
;_AutoItObject_AddMethod
;_AutoItObject_AddProperty
;_AutoItObject_Class
;_AutoItObject_CLSIDFromString
;_AutoItObject_CoCreateInstance
;_AutoItObject_Create
;_AutoItObject_DllOpen
;_AutoItObject_DllStructCreate
;_AutoItObject_IDispatchToPtr
;_AutoItObject_IUnknownAddRef
;_AutoItObject_IUnknownRelease
;_AutoItObject_ObjCreate
;_AutoItObject_ObjCreateEx
;_AutoItObject_ObjectFromDtag
;_AutoItObject_PtrToIDispatch
;_AutoItObject_RegisterObject
;_AutoItObject_RemoveMember
;_AutoItObject_Shutdown
;_AutoItObject_Startup
;_AutoItObject_UnregisterObject
;_AutoItObject_VariantClear
;_AutoItObject_VariantCopy
;_AutoItObject_VariantFree
;_AutoItObject_VariantInit
;_AutoItObject_VariantRead
;_AutoItObject_VariantSet
;_AutoItObject_WrapperAddMethod
;_AutoItObject_WrapperCreate
; ===============================================================================================================================

; #INTERNAL_NO_DOC# =============================================================================================================
;__Au3Obj_OleUninitialize
;__Au3Obj_IUnknown_AddRef
;__Au3Obj_IUnknown_Release
;__Au3Obj_GetMethods
;__Au3Obj_SafeArrayCreate
;__Au3Obj_SafeArrayDestroy
;__Au3Obj_SafeArrayAccessData
;__Au3Obj_SafeArrayUnaccessData
;__Au3Obj_SafeArrayGetUBound
;__Au3Obj_SafeArrayGetLBound
;__Au3Obj_SafeArrayGetDim
;__Au3Obj_CreateSafeArrayVariant
;__Au3Obj_ReadSafeArrayVariant
;__Au3Obj_CoTaskMemAlloc
;__Au3Obj_CoTaskMemFree
;__Au3Obj_CoTaskMemRealloc
;__Au3Obj_GlobalAlloc
;__Au3Obj_GlobalFree
;__Au3Obj_SysAllocString
;__Au3Obj_SysCopyString
;__Au3Obj_SysReAllocString
;__Au3Obj_SysFreeString
;__Au3Obj_SysStringLen
;__Au3Obj_SysReadString
;__Au3Obj_PtrStringLen
;__Au3Obj_PtrStringRead
;__Au3Obj_FunctionProxy
;__Au3Obj_EnumFunctionProxy
;__Au3Obj_ObjStructGetElements
;__Au3Obj_ObjStructMethod
;__Au3Obj_ObjStructDestructor
;__Au3Obj_ObjStructPointer
;__Au3Obj_PointerCall
;__Au3Obj_Mem_DllOpen
;__Au3Obj_Mem_FixReloc
;__Au3Obj_Mem_FixImports
;__Au3Obj_Mem_LoadLibraryEx
;__Au3Obj_Mem_FreeLibrary
;__Au3Obj_Mem_GetAddress
;__Au3Obj_Mem_VirtualProtect
;__Au3Obj_Mem_Base64Decode
;__Au3Obj_Mem_BinDll
;__Au3Obj_Mem_BinDll_X64
; ===============================================================================================================================

; #DATATYPES# =====================================================================================================================
; none - no value (only valid for return type, equivalent to void in C)
; byte - an unsigned 8 bit integer
; boolean - an unsigned 8 bit integer
; short - a 16 bit integer
; word, ushort - an unsigned 16 bit integer
; int, long - a 32 bit integer
; bool - a 32 bit integer
; dword, ulong, uint - an unsigned 32 bit integer
; hresult - an unsigned 32 bit integer
; int64 - a 64 bit integer
; uint64 - an unsigned 64 bit integer
; ptr - a general pointer (void *)
; hwnd - a window handle (pointer wide)
; handle - an handle (pointer wide)
; float - a single precision floating point number
; double - a double precision floating point number
; int_ptr, long_ptr, lresult, lparam - an integer big enough to hold a pointer when running on x86 or x64 versions of AutoIt
; uint_ptr, ulong_ptr, dword_ptr, wparam - an unsigned integer big enough to hold a pointer when running on x86 or x64 versions of AutoIt
; str - an ANSI string (a minimum of 65536 chars is allocated)
; wstr - a UNICODE wide character string (a minimum of 65536 chars is allocated)
; bstr - a composite data type that consists of a length prefix, a data string and a terminator
; variant - a tagged union that can be used to represent any other data type
; idispatch, object - a composite data type that represents object with IDispatch interface
; ===============================================================================================================================

;--------------------------------------------------------------------------------------------------------------------------------------
#Region Variable definitions

Global Const $gh_AU3Obj_kernel32dll = DllOpen("kernel32.dll")
Global Const $gh_AU3Obj_oleautdll = DllOpen("oleaut32.dll")
Global Const $gh_AU3Obj_ole32dll = DllOpen("ole32.dll")

Global Const $__Au3Obj_X64 = @AutoItX64

Global Const $__Au3Obj_VT_EMPTY = 0
Global Const $__Au3Obj_VT_NULL = 1
Global Const $__Au3Obj_VT_I2 = 2
Global Const $__Au3Obj_VT_I4 = 3
Global Const $__Au3Obj_VT_R4 = 4
Global Const $__Au3Obj_VT_R8 = 5
Global Const $__Au3Obj_VT_CY = 6
Global Const $__Au3Obj_VT_DATE = 7
Global Const $__Au3Obj_VT_BSTR = 8
Global Const $__Au3Obj_VT_DISPATCH = 9
Global Const $__Au3Obj_VT_ERROR = 10
Global Const $__Au3Obj_VT_BOOL = 11
Global Const $__Au3Obj_VT_VARIANT = 12
Global Const $__Au3Obj_VT_UNKNOWN = 13
Global Const $__Au3Obj_VT_DECIMAL = 14
Global Const $__Au3Obj_VT_I1 = 16
Global Const $__Au3Obj_VT_UI1 = 17
Global Const $__Au3Obj_VT_UI2 = 18
Global Const $__Au3Obj_VT_UI4 = 19
Global Const $__Au3Obj_VT_I8 = 20
Global Const $__Au3Obj_VT_UI8 = 21
Global Const $__Au3Obj_VT_INT = 22
Global Const $__Au3Obj_VT_UINT = 23
Global Const $__Au3Obj_VT_VOID = 24
Global Const $__Au3Obj_VT_HRESULT = 25
Global Const $__Au3Obj_VT_PTR = 26
Global Const $__Au3Obj_VT_SAFEARRAY = 27
Global Const $__Au3Obj_VT_CARRAY = 28
Global Const $__Au3Obj_VT_USERDEFINED = 29
Global Const $__Au3Obj_VT_LPSTR = 30
Global Const $__Au3Obj_VT_LPWSTR = 31
Global Const $__Au3Obj_VT_RECORD = 36
Global Const $__Au3Obj_VT_INT_PTR = 37
Global Const $__Au3Obj_VT_UINT_PTR = 38
Global Const $__Au3Obj_VT_FILETIME = 64
Global Const $__Au3Obj_VT_BLOB = 65
Global Const $__Au3Obj_VT_STREAM = 66
Global Const $__Au3Obj_VT_STORAGE = 67
Global Const $__Au3Obj_VT_STREAMED_OBJECT = 68
Global Const $__Au3Obj_VT_STORED_OBJECT = 69
Global Const $__Au3Obj_VT_BLOB_OBJECT = 70
Global Const $__Au3Obj_VT_CF = 71
Global Const $__Au3Obj_VT_CLSID = 72
Global Const $__Au3Obj_VT_VERSIONED_STREAM = 73
Global Const $__Au3Obj_VT_BSTR_BLOB = 0xfff
Global Const $__Au3Obj_VT_VECTOR = 0x1000
Global Const $__Au3Obj_VT_ARRAY = 0x2000
Global Const $__Au3Obj_VT_BYREF = 0x4000
Global Const $__Au3Obj_VT_RESERVED = 0x8000
Global Const $__Au3Obj_VT_ILLEGAL = 0xffff
Global Const $__Au3Obj_VT_ILLEGALMASKED = 0xfff
Global Const $__Au3Obj_VT_TYPEMASK = 0xfff

Global Const $__Au3Obj_tagVARIANT = "word vt;word r1;word r2;word r3;ptr data; ptr"

Global Const $__Au3Obj_VARIANT_SIZE = DllStructGetSize(DllStructCreate($__Au3Obj_tagVARIANT, 1))
Global Const $__Au3Obj_PTR_SIZE = DllStructGetSize(DllStructCreate('ptr', 1))
Global Const $__Au3Obj_tagSAFEARRAYBOUND = "ulong cElements; long lLbound;"

Global $ghAutoItObjectDLL = -1, $giAutoItObjectDLLRef = 0

;===============================================================================
#interface "IUnknown"
Global Const $sIID_IUnknown = "{00000000-0000-0000-C000-000000000046}"
; Definition
Global $dtagIUnknown = "QueryInterface hresult(ptr;ptr*);" & _
		"AddRef dword();" & _
		"Release dword();"
; List
Global $ltagIUnknown = "QueryInterface;" & _
		"AddRef;" & _
		"Release;"
;===============================================================================
;===============================================================================
#interface "IDispatch"
Global Const $sIID_IDispatch = "{00020400-0000-0000-C000-000000000046}"
; Definition
Global $dtagIDispatch = $dtagIUnknown & _
		"GetTypeInfoCount hresult(dword*);" & _
		"GetTypeInfo hresult(dword;dword;ptr*);" & _
		"GetIDsOfNames hresult(ptr;ptr;dword;dword;ptr);" & _
		"Invoke hresult(dword;ptr;dword;word;ptr;ptr;ptr;ptr);"
; List
Global $ltagIDispatch = $ltagIUnknown & _
		"GetTypeInfoCount;" & _
		"GetTypeInfo;" & _
		"GetIDsOfNames;" & _
		"Invoke;"
;===============================================================================

#EndRegion Variable definitions
;--------------------------------------------------------------------------------------------------------------------------------------


;--------------------------------------------------------------------------------------------------------------------------------------
#Region Misc

DllCall($gh_AU3Obj_ole32dll, 'long', 'OleInitialize', 'ptr', 0)
OnAutoItExitRegister("__Au3Obj_OleUninitialize")
Func __Au3Obj_OleUninitialize()
	; Author: Prog@ndy
	DllCall($gh_AU3Obj_ole32dll, 'long', 'OleUninitialize')
	_AutoItObject_Shutdown(True)
EndFunc   ;==>__Au3Obj_OleUninitialize

Func __Au3Obj_IUnknown_AddRef($vObj)
	Local $sType = "ptr"
	If IsObj($vObj) Then $sType = "idispatch"
	Local $tVARIANT = DllStructCreate($__Au3Obj_tagVARIANT)
	; Actual call
	Local $aCall = DllCall($gh_AU3Obj_oleautdll, "long", "DispCallFunc", _
			$sType, $vObj, _
			"dword", $__Au3Obj_PTR_SIZE, _ ; offset (4 for x86, 8 for x64)
			"dword", 4, _ ; CC_STDCALL
			"dword", $__Au3Obj_VT_UINT, _
			"dword", 0, _ ; number of function parameters
			"ptr", 0, _ ; parameters related
			"ptr", 0, _ ; parameters related
			"ptr", DllStructGetPtr($tVARIANT))
	If @error Or $aCall[0] Then Return SetError(1, 0, 0)
	; Collect returned
	Return DllStructGetData(DllStructCreate("dword", DllStructGetPtr($tVARIANT, "data")), 1)
EndFunc   ;==>__Au3Obj_IUnknown_AddRef

Func __Au3Obj_IUnknown_Release($vObj)
	Local $sType = "ptr"
	If IsObj($vObj) Then $sType = "idispatch"
	Local $tVARIANT = DllStructCreate($__Au3Obj_tagVARIANT)
	; Actual call
	Local $aCall = DllCall($gh_AU3Obj_oleautdll, "long", "DispCallFunc", _
			$sType, $vObj, _
			"dword", 2 * $__Au3Obj_PTR_SIZE, _ ; offset (8 for x86, 16 for x64)
			"dword", 4, _ ; CC_STDCALL
			"dword", $__Au3Obj_VT_UINT, _
			"dword", 0, _ ; number of function parameters
			"ptr", 0, _ ; parameters related
			"ptr", 0, _ ; parameters related
			"ptr", DllStructGetPtr($tVARIANT))
	If @error Or $aCall[0] Then Return SetError(1, 0, 0)
	; Collect returned
	Return DllStructGetData(DllStructCreate("dword", DllStructGetPtr($tVARIANT, "data")), 1)
EndFunc   ;==>__Au3Obj_IUnknown_Release

Func __Au3Obj_GetMethods($tagInterface)
	Local $sMethods = StringReplace(StringRegExpReplace($tagInterface, "\h*(\w+)\h*(\w+\*?)\h*(\((.*?)\))\h*(;|;*\z)", "$1\|$2;$4" & @LF), ";" & @LF, @LF)
	If $sMethods = $tagInterface Then $sMethods = StringReplace(StringRegExpReplace($tagInterface, "\h*(\w+)\h*(;|;*\z)", "$1\|" & @LF), ";" & @LF, @LF)
	Return StringTrimRight($sMethods, 1)
EndFunc   ;==>__Au3Obj_GetMethods

Func __Au3Obj_ObjStructGetElements($sTag, ByRef $sAlign)
	Local $sAlignment = StringRegExpReplace($sTag, "\h*(align\h+\d+)\h*;.*", "$1")
	If $sAlignment <> $sTag Then
		$sAlign = $sAlignment
		$sTag = StringRegExpReplace($sTag, "\h*(align\h+\d+)\h*;", "")
	EndIf
	; Return StringRegExp($sTag, "\h*\w+\h*(\w+)\h*", 3) ; DO NOT REMOVE THIS LINE
	Return StringTrimRight(StringRegExpReplace($sTag, "\h*\w+\h*(\w+)\h*(\[\d+\])*\h*(;|;*\z)\h*", "$1;"), 1)
EndFunc   ;==>__Au3Obj_ObjStructGetElements

#EndRegion Misc
;--------------------------------------------------------------------------------------------------------------------------------------


;--------------------------------------------------------------------------------------------------------------------------------------
#Region SafeArray
Func __Au3Obj_SafeArrayCreate($vType, $cDims, $rgsabound)
	; Author: Prog@ndy
	Local $aCall = DllCall($gh_AU3Obj_oleautdll, "ptr", "SafeArrayCreate", "dword", $vType, "uint", $cDims, 'ptr', $rgsabound)
	If @error Then Return SetError(1, 0, 0)
	Return $aCall[0]
EndFunc   ;==>__Au3Obj_SafeArrayCreate

Func __Au3Obj_SafeArrayDestroy($pSafeArray)
	; Author: Prog@ndy
	Local $aCall = DllCall($gh_AU3Obj_oleautdll, "int", "SafeArrayDestroy", "ptr", $pSafeArray)
	If @error Then Return SetError(1, 0, 1)
	Return $aCall[0]
EndFunc   ;==>__Au3Obj_SafeArrayDestroy

Func __Au3Obj_SafeArrayAccessData($pSafeArray, ByRef $pArrayData)
	; Author: Prog@ndy
	Local $aCall = DllCall($gh_AU3Obj_oleautdll, "int", "SafeArrayAccessData", "ptr", $pSafeArray, 'ptr*', 0)
	If @error Then Return SetError(1, 0, 1)
	$pArrayData = $aCall[2]
	Return $aCall[0]
EndFunc   ;==>__Au3Obj_SafeArrayAccessData

Func __Au3Obj_SafeArrayUnaccessData($pSafeArray)
	; Author: Prog@ndy
	Local $aCall = DllCall($gh_AU3Obj_oleautdll, "int", "SafeArrayUnaccessData", "ptr", $pSafeArray)
	If @error Then Return SetError(1, 0, 1)
	Return $aCall[0]
EndFunc   ;==>__Au3Obj_SafeArrayUnaccessData

Func __Au3Obj_SafeArrayGetUBound($pSafeArray, $iDim, ByRef $iBound)
	; Author: Prog@ndy
	Local $aCall = DllCall($gh_AU3Obj_oleautdll, "int", "SafeArrayGetUBound", "ptr", $pSafeArray, 'uint', $iDim, 'long*', 0)
	If @error Then Return SetError(1, 0, 1)
	$iBound = $aCall[3]
	Return $aCall[0]
EndFunc   ;==>__Au3Obj_SafeArrayGetUBound

Func __Au3Obj_SafeArrayGetLBound($pSafeArray, $iDim, ByRef $iBound)
	; Author: Prog@ndy
	Local $aCall = DllCall($gh_AU3Obj_oleautdll, "int", "SafeArrayGetLBound", "ptr", $pSafeArray, 'uint', $iDim, 'long*', 0)
	If @error Then Return SetError(1, 0, 1)
	$iBound = $aCall[3]
	Return $aCall[0]
EndFunc   ;==>__Au3Obj_SafeArrayGetLBound

Func __Au3Obj_SafeArrayGetDim($pSafeArray)
	Local $aResult = DllCall($gh_AU3Obj_oleautdll, "uint", "SafeArrayGetDim", "ptr", $pSafeArray)
	If @error Then Return SetError(1, 0, 0)
	Return $aResult[0]
EndFunc   ;==>__Au3Obj_SafeArrayGetDim

Func __Au3Obj_CreateSafeArrayVariant(ByRef Const $aArray)
	; Author: Prog@ndy
	Local $iDim = UBound($aArray, 0), $pData, $pSafeArray, $bound, $subBound, $tBound
	Switch $iDim
		Case 1
			$bound = UBound($aArray) - 1
			$tBound = DllStructCreate($__Au3Obj_tagSAFEARRAYBOUND)
			DllStructSetData($tBound, 1, $bound + 1)
			$pSafeArray = __Au3Obj_SafeArrayCreate($__Au3Obj_VT_VARIANT, 1, DllStructGetPtr($tBound))
			If 0 = __Au3Obj_SafeArrayAccessData($pSafeArray, $pData) Then
				For $i = 0 To $bound
					_AutoItObject_VariantInit($pData + $i * $__Au3Obj_VARIANT_SIZE)
					_AutoItObject_VariantSet($pData + $i * $__Au3Obj_VARIANT_SIZE, $aArray[$i])
				Next
				__Au3Obj_SafeArrayUnaccessData($pSafeArray)
			EndIf
			Return $pSafeArray
		Case 2
			$bound = UBound($aArray, 1) - 1
			$subBound = UBound($aArray, 2) - 1
			$tBound = DllStructCreate($__Au3Obj_tagSAFEARRAYBOUND & $__Au3Obj_tagSAFEARRAYBOUND)
			DllStructSetData($tBound, 3, $bound + 1)
			DllStructSetData($tBound, 1, $subBound + 1)
			$pSafeArray = __Au3Obj_SafeArrayCreate($__Au3Obj_VT_VARIANT, 2, DllStructGetPtr($tBound))
			If 0 = __Au3Obj_SafeArrayAccessData($pSafeArray, $pData) Then
				For $i = 0 To $bound
					For $j = 0 To $subBound
						_AutoItObject_VariantInit($pData + ($j + $i * ($subBound + 1)) * $__Au3Obj_VARIANT_SIZE)
						_AutoItObject_VariantSet($pData + ($j + $i * ($subBound + 1)) * $__Au3Obj_VARIANT_SIZE, $aArray[$i][$j])
					Next
				Next
				__Au3Obj_SafeArrayUnaccessData($pSafeArray)
			EndIf
			Return $pSafeArray
		Case Else
			Return 0
	EndSwitch
EndFunc   ;==>__Au3Obj_CreateSafeArrayVariant

Func __Au3Obj_ReadSafeArrayVariant($pSafeArray)
	; Author: Prog@ndy
	Local $iDim = __Au3Obj_SafeArrayGetDim($pSafeArray), $pData, $lbound, $bound, $subBound
	Switch $iDim
		Case 1
			__Au3Obj_SafeArrayGetLBound($pSafeArray, 1, $lbound)
			__Au3Obj_SafeArrayGetUBound($pSafeArray, 1, $bound)
			$bound -= $lbound
			Local $array[$bound + 1]
			If 0 = __Au3Obj_SafeArrayAccessData($pSafeArray, $pData) Then
				For $i = 0 To $bound
					$array[$i] = _AutoItObject_VariantRead($pData + $i * $__Au3Obj_VARIANT_SIZE)
				Next
				__Au3Obj_SafeArrayUnaccessData($pSafeArray)
			EndIf
			Return $array
		Case 2
			__Au3Obj_SafeArrayGetLBound($pSafeArray, 2, $lbound)
			__Au3Obj_SafeArrayGetUBound($pSafeArray, 2, $bound)
			$bound -= $lbound
			__Au3Obj_SafeArrayGetLBound($pSafeArray, 1, $lbound)
			__Au3Obj_SafeArrayGetUBound($pSafeArray, 1, $subBound)
			$subBound -= $lbound
			Local $array[$bound + 1][$subBound + 1]
			If 0 = __Au3Obj_SafeArrayAccessData($pSafeArray, $pData) Then
				For $i = 0 To $bound
					For $j = 0 To $subBound
						$array[$i][$j] = _AutoItObject_VariantRead($pData + ($j + $i * ($subBound + 1)) * $__Au3Obj_VARIANT_SIZE)
					Next
				Next
				__Au3Obj_SafeArrayUnaccessData($pSafeArray)
			EndIf
			Return $array
		Case Else
			Return 0
	EndSwitch
EndFunc   ;==>__Au3Obj_ReadSafeArrayVariant

#EndRegion SafeArray
;--------------------------------------------------------------------------------------------------------------------------------------


;--------------------------------------------------------------------------------------------------------------------------------------
#Region Memory

Func __Au3Obj_CoTaskMemAlloc($iSize)
	; Author: Prog@ndy
	Local $aCall = DllCall($gh_AU3Obj_ole32dll, "ptr", "CoTaskMemAlloc", "uint_ptr", $iSize)
	If @error Then Return SetError(1, 0, 0)
	Return $aCall[0]
EndFunc   ;==>__Au3Obj_CoTaskMemAlloc

Func __Au3Obj_CoTaskMemFree($pCoMem)
	; Author: Prog@ndy
	DllCall($gh_AU3Obj_ole32dll, "none", "CoTaskMemFree", "ptr", $pCoMem)
	If @error Then Return SetError(1, 0, 0)
EndFunc   ;==>__Au3Obj_CoTaskMemFree

Func __Au3Obj_CoTaskMemRealloc($pCoMem, $iSize)
	; Author: Prog@ndy
	Local $aCall = DllCall($gh_AU3Obj_ole32dll, "ptr", "CoTaskMemRealloc", 'ptr', $pCoMem, "uint_ptr", $iSize)
	If @error Then Return SetError(1, 0, 0)
	Return $aCall[0]
EndFunc   ;==>__Au3Obj_CoTaskMemRealloc

Func __Au3Obj_GlobalAlloc($iSize, $iFlag)
	Local $aCall = DllCall($gh_AU3Obj_kernel32dll, "ptr", "GlobalAlloc", "dword", $iFlag, "dword_ptr", $iSize)
	If @error Or Not $aCall[0] Then Return SetError(1, 0, 0)
	Return $aCall[0]
EndFunc   ;==>__Au3Obj_GlobalAlloc

Func __Au3Obj_GlobalFree($pPointer)
	Local $aCall = DllCall($gh_AU3Obj_kernel32dll, "ptr", "GlobalFree", "ptr", $pPointer)
	If @error Or $aCall[0] Then Return SetError(1, 0, 0)
	Return 1
EndFunc   ;==>__Au3Obj_GlobalFree

#EndRegion Memory
;--------------------------------------------------------------------------------------------------------------------------------------


;--------------------------------------------------------------------------------------------------------------------------------------
#Region SysString

Func __Au3Obj_SysAllocString($str)
	; Author: monoceres
	Local $aCall = DllCall($gh_AU3Obj_oleautdll, "ptr", "SysAllocString", "wstr", $str)
	If @error Then Return SetError(1, 0, 0)
	Return $aCall[0]
EndFunc   ;==>__Au3Obj_SysAllocString
Func __Au3Obj_SysCopyString($pBSTR)
	; Author: Prog@ndy
	If Not $pBSTR Then Return SetError(2, 0, 0)
	Local $aCall = DllCall($gh_AU3Obj_oleautdll, "ptr", "SysAllocStringLen", "ptr", $pBSTR, "uint", __Au3Obj_SysStringLen($pBSTR))
	If @error Then Return SetError(1, 0, 0)
	Return $aCall[0]
EndFunc   ;==>__Au3Obj_SysCopyString

Func __Au3Obj_SysReAllocString(ByRef $pBSTR, $str)
	; Author: Prog@ndy
	If Not $pBSTR Then Return SetError(2, 0, 0)
	Local $aCall = DllCall($gh_AU3Obj_oleautdll, "int", "SysReAllocString", 'ptr*', $pBSTR, "wstr", $str)
	If @error Then Return SetError(1, 0, 0)
	$pBSTR = $aCall[1]
	Return $aCall[0]
EndFunc   ;==>__Au3Obj_SysReAllocString

Func __Au3Obj_SysFreeString($pBSTR)
	; Author: Prog@ndy
	If Not $pBSTR Then Return SetError(2, 0, 0)
	DllCall($gh_AU3Obj_oleautdll, "none", "SysFreeString", "ptr", $pBSTR)
	If @error Then Return SetError(1, 0, 0)
EndFunc   ;==>__Au3Obj_SysFreeString

Func __Au3Obj_SysStringLen($pBSTR)
	; Author: Prog@ndy
	If Not $pBSTR Then Return SetError(2, 0, 0)
	Local $aCall = DllCall($gh_AU3Obj_oleautdll, "uint", "SysStringLen", "ptr", $pBSTR)
	If @error Then Return SetError(1, 0, 0)
	Return $aCall[0]
EndFunc   ;==>__Au3Obj_SysStringLen

Func __Au3Obj_SysReadString($pBSTR, $iLen = -1)
	; Author: Prog@ndy
	If Not $pBSTR Then Return SetError(2, 0, '')
	If $iLen < 1 Then $iLen = __Au3Obj_SysStringLen($pBSTR)
	If $iLen < 1 Then Return SetError(1, 0, '')
	Return DllStructGetData(DllStructCreate("wchar[" & $iLen & "]", $pBSTR), 1)
EndFunc   ;==>__Au3Obj_SysReadString

Func __Au3Obj_PtrStringLen($pStr)
	; Author: Prog@ndy
	Local $aResult = DllCall($gh_AU3Obj_kernel32dll, 'int', 'lstrlenW', 'ptr', $pStr)
	If @error Then Return SetError(1, 0, 0)
	Return $aResult[0]
EndFunc   ;==>__Au3Obj_PtrStringLen

Func __Au3Obj_PtrStringRead($pStr, $iLen = -1)
	; Author: Prog@ndy
	If $iLen < 1 Then $iLen = __Au3Obj_PtrStringLen($pStr)
	If $iLen < 1 Then Return SetError(1, 0, '')
	Return DllStructGetData(DllStructCreate("wchar[" & $iLen & "]", $pStr), 1)
EndFunc   ;==>__Au3Obj_PtrStringRead

#EndRegion SysString
;--------------------------------------------------------------------------------------------------------------------------------------


;--------------------------------------------------------------------------------------------------------------------------------------
#Region Proxy Functions

Func __Au3Obj_FunctionProxy($FuncName, $oSelf) ; allows binary code to call autoit functions
	Local $arg = $oSelf.__params__ ; fetch params
	If IsArray($arg) Then
		Local $ret = Call($FuncName, $arg) ; Call
		If @error = 0xDEAD And @extended = 0xBEEF Then Return 0
		$oSelf.__error__ = @error ; set error
		$oSelf.__result__ = $ret ; set result
		Return 1
	EndIf
	; return error when params-array could not be created
EndFunc   ;==>__Au3Obj_FunctionProxy

Func __Au3Obj_EnumFunctionProxy($iAction, $FuncName, $oSelf, $pVarCurrent, $pVarResult)
	Local $Current, $ret
	Switch $iAction
		Case 0 ; Next
			$Current = $oSelf.__bridge__(Number($pVarCurrent))
			$ret = Execute($FuncName & "($oSelf, $Current)")
			If @error Then Return False
			$oSelf.__bridge__(Number($pVarCurrent)) = $Current
			$oSelf.__bridge__(Number($pVarResult)) = $ret
			Return 1
		Case 1 ;Skip
			Return False
		Case 2 ; Reset
			$Current = $oSelf.__bridge__(Number($pVarCurrent))
			$ret = Execute($FuncName & "($oSelf, $Current)")
			If @error Or Not $ret Then Return False
			$oSelf.__bridge__(Number($pVarCurrent)) = $Current
			Return True
	EndSwitch
EndFunc   ;==>__Au3Obj_EnumFunctionProxy

#EndRegion Proxy Functions
;--------------------------------------------------------------------------------------------------------------------------------------


;--------------------------------------------------------------------------------------------------------------------------------------
#Region Call Pointer

Func __Au3Obj_PointerCall($sRetType, $pAddress, $sType1 = "", $vParam1 = 0, $sType2 = "", $vParam2 = 0, $sType3 = "", $vParam3 = 0, $sType4 = "", $vParam4 = 0, $sType5 = "", $vParam5 = 0, $sType6 = "", $vParam6 = 0, $sType7 = "", $vParam7 = 0, $sType8 = "", $vParam8 = 0, $sType9 = "", $vParam9 = 0, $sType10 = "", $vParam10 = 0, $sType11 = "", $vParam11 = 0, $sType12 = "", $vParam12 = 0, $sType13 = "", $vParam13 = 0, $sType14 = "", $vParam14 = 0, $sType15 = "", $vParam15 = 0, $sType16 = "", $vParam16 = 0, $sType17 = "", $vParam17 = 0, $sType18 = "", $vParam18 = 0, $sType19 = "", $vParam19 = 0, $sType20 = "", $vParam20 = 0)
	; Author: Ward, Prog@ndy, trancexx
	Local Static $pHook, $hPseudo, $tPtr, $sFuncName = "MemoryCallEntry"
	If $pAddress Then
		If Not $pHook Then
			Local $sDll = "AutoItObject.dll"
			If $__Au3Obj_X64 Then $sDll = "AutoItObject_X64.dll"
			$hPseudo = DllOpen($sDll)
			If $hPseudo = -1 Then
				$sDll = "kernel32.dll"
				$sFuncName = "GlobalFix"
				$hPseudo = DllOpen($sDll)
			EndIf
			Local $aCall = DllCall($gh_AU3Obj_kernel32dll, "ptr", "GetModuleHandleW", "wstr", $sDll)
			If @error Or Not $aCall[0] Then Return SetError(7, @error, 0) ; Couldn't get dll handle
			Local $hModuleHandle = $aCall[0]
			$aCall = DllCall($gh_AU3Obj_kernel32dll, "ptr", "GetProcAddress", "ptr", $hModuleHandle, "str", $sFuncName)
			If @error Then Return SetError(8, @error, 0) ; Wanted function not found
			$pHook = $aCall[0]
			$aCall = DllCall($gh_AU3Obj_kernel32dll, "bool", "VirtualProtect", "ptr", $pHook, "dword", 7 + 5 * $__Au3Obj_X64, "dword", 64, "dword*", 0)
			If @error Or Not $aCall[0] Then Return SetError(9, @error, 0) ; Unable to set MEM_EXECUTE_READWRITE
			If $__Au3Obj_X64 Then
				DllStructSetData(DllStructCreate("word", $pHook), 1, 0xB848)
				DllStructSetData(DllStructCreate("word", $pHook + 10), 1, 0xE0FF)
			Else
				DllStructSetData(DllStructCreate("byte", $pHook), 1, 0xB8)
				DllStructSetData(DllStructCreate("word", $pHook + 5), 1, 0xE0FF)
			EndIf
			$tPtr = DllStructCreate("ptr", $pHook + 1 + $__Au3Obj_X64)
		EndIf
		DllStructSetData($tPtr, 1, $pAddress)
		Local $aRet
		Switch @NumParams
			Case 2
				$aRet = DllCall($hPseudo, $sRetType, $sFuncName)
			Case 4
				$aRet = DllCall($hPseudo, $sRetType, $sFuncName, $sType1, $vParam1)
			Case 6
				$aRet = DllCall($hPseudo, $sRetType, $sFuncName, $sType1, $vParam1, $sType2, $vParam2)
			Case 8
				$aRet = DllCall($hPseudo, $sRetType, $sFuncName, $sType1, $vParam1, $sType2, $vParam2, $sType3, $vParam3)
			Case 10
				$aRet = DllCall($hPseudo, $sRetType, $sFuncName, $sType1, $vParam1, $sType2, $vParam2, $sType3, $vParam3, $sType4, $vParam4)
			Case 12
				$aRet = DllCall($hPseudo, $sRetType, $sFuncName, $sType1, $vParam1, $sType2, $vParam2, $sType3, $vParam3, $sType4, $vParam4, $sType5, $vParam5)
			Case 14
				$aRet = DllCall($hPseudo, $sRetType, $sFuncName, $sType1, $vParam1, $sType2, $vParam2, $sType3, $vParam3, $sType4, $vParam4, $sType5, $vParam5, $sType6, $vParam6)
			Case 16
				$aRet = DllCall($hPseudo, $sRetType, $sFuncName, $sType1, $vParam1, $sType2, $vParam2, $sType3, $vParam3, $sType4, $vParam4, $sType5, $vParam5, $sType6, $vParam6, $sType7, $vParam7)
			Case 18
				$aRet = DllCall($hPseudo, $sRetType, $sFuncName, $sType1, $vParam1, $sType2, $vParam2, $sType3, $vParam3, $sType4, $vParam4, $sType5, $vParam5, $sType6, $vParam6, $sType7, $vParam7, $sType8, $vParam8)
			Case 20
				$aRet = DllCall($hPseudo, $sRetType, $sFuncName, $sType1, $vParam1, $sType2, $vParam2, $sType3, $vParam3, $sType4, $vParam4, $sType5, $vParam5, $sType6, $vParam6, $sType7, $vParam7, $sType8, $vParam8, $sType9, $vParam9)
			Case 22
				$aRet = DllCall($hPseudo, $sRetType, $sFuncName, $sType1, $vParam1, $sType2, $vParam2, $sType3, $vParam3, $sType4, $vParam4, $sType5, $vParam5, $sType6, $vParam6, $sType7, $vParam7, $sType8, $vParam8, $sType9, $vParam9, $sType10, $vParam10)
			Case 24
				$aRet = DllCall($hPseudo, $sRetType, $sFuncName, $sType1, $vParam1, $sType2, $vParam2, $sType3, $vParam3, $sType4, $vParam4, $sType5, $vParam5, $sType6, $vParam6, $sType7, $vParam7, $sType8, $vParam8, $sType9, $vParam9, $sType10, $vParam10, $sType11, $vParam11)
			Case 26
				$aRet = DllCall($hPseudo, $sRetType, $sFuncName, $sType1, $vParam1, $sType2, $vParam2, $sType3, $vParam3, $sType4, $vParam4, $sType5, $vParam5, $sType6, $vParam6, $sType7, $vParam7, $sType8, $vParam8, $sType9, $vParam9, $sType10, $vParam10, $sType11, $vParam11, $sType12, $vParam12)
			Case 28
				$aRet = DllCall($hPseudo, $sRetType, $sFuncName, $sType1, $vParam1, $sType2, $vParam2, $sType3, $vParam3, $sType4, $vParam4, $sType5, $vParam5, $sType6, $vParam6, $sType7, $vParam7, $sType8, $vParam8, $sType9, $vParam9, $sType10, $vParam10, $sType11, $vParam11, $sType12, $vParam12, $sType13, $vParam13)
			Case 30
				$aRet = DllCall($hPseudo, $sRetType, $sFuncName, $sType1, $vParam1, $sType2, $vParam2, $sType3, $vParam3, $sType4, $vParam4, $sType5, $vParam5, $sType6, $vParam6, $sType7, $vParam7, $sType8, $vParam8, $sType9, $vParam9, $sType10, $vParam10, $sType11, $vParam11, $sType12, $vParam12, $sType13, $vParam13, $sType14, $vParam14)
			Case 32
				$aRet = DllCall($hPseudo, $sRetType, $sFuncName, $sType1, $vParam1, $sType2, $vParam2, $sType3, $vParam3, $sType4, $vParam4, $sType5, $vParam5, $sType6, $vParam6, $sType7, $vParam7, $sType8, $vParam8, $sType9, $vParam9, $sType10, $vParam10, $sType11, $vParam11, $sType12, $vParam12, $sType13, $vParam13, $sType14, $vParam14, $sType15, $vParam15)
			Case 34
				$aRet = DllCall($hPseudo, $sRetType, $sFuncName, $sType1, $vParam1, $sType2, $vParam2, $sType3, $vParam3, $sType4, $vParam4, $sType5, $vParam5, $sType6, $vParam6, $sType7, $vParam7, $sType8, $vParam8, $sType9, $vParam9, $sType10, $vParam10, $sType11, $vParam11, $sType12, $vParam12, $sType13, $vParam13, $sType14, $vParam14, $sType15, $vParam15, $sType16, $vParam16)
			Case 36
				$aRet = DllCall($hPseudo, $sRetType, $sFuncName, $sType1, $vParam1, $sType2, $vParam2, $sType3, $vParam3, $sType4, $vParam4, $sType5, $vParam5, $sType6, $vParam6, $sType7, $vParam7, $sType8, $vParam8, $sType9, $vParam9, $sType10, $vParam10, $sType11, $vParam11, $sType12, $vParam12, $sType13, $vParam13, $sType14, $vParam14, $sType15, $vParam15, $sType16, $vParam16, $sType17, $vParam17)
			Case 38
				$aRet = DllCall($hPseudo, $sRetType, $sFuncName, $sType1, $vParam1, $sType2, $vParam2, $sType3, $vParam3, $sType4, $vParam4, $sType5, $vParam5, $sType6, $vParam6, $sType7, $vParam7, $sType8, $vParam8, $sType9, $vParam9, $sType10, $vParam10, $sType11, $vParam11, $sType12, $vParam12, $sType13, $vParam13, $sType14, $vParam14, $sType15, $vParam15, $sType16, $vParam16, $sType17, $vParam17, $sType18, $vParam18)
			Case 40
				$aRet = DllCall($hPseudo, $sRetType, $sFuncName, $sType1, $vParam1, $sType2, $vParam2, $sType3, $vParam3, $sType4, $vParam4, $sType5, $vParam5, $sType6, $vParam6, $sType7, $vParam7, $sType8, $vParam8, $sType9, $vParam9, $sType10, $vParam10, $sType11, $vParam11, $sType12, $vParam12, $sType13, $vParam13, $sType14, $vParam14, $sType15, $vParam15, $sType16, $vParam16, $sType17, $vParam17, $sType18, $vParam18, $sType19, $vParam19)
			Case 42
				$aRet = DllCall($hPseudo, $sRetType, $sFuncName, $sType1, $vParam1, $sType2, $vParam2, $sType3, $vParam3, $sType4, $vParam4, $sType5, $vParam5, $sType6, $vParam6, $sType7, $vParam7, $sType8, $vParam8, $sType9, $vParam9, $sType10, $vParam10, $sType11, $vParam11, $sType12, $vParam12, $sType13, $vParam13, $sType14, $vParam14, $sType15, $vParam15, $sType16, $vParam16, $sType17, $vParam17, $sType18, $vParam18, $sType19, $vParam19, $sType20, $vParam20)
			Case Else
				If Mod(@NumParams, 2) Then Return SetError(4, 0, 0) ; Bad number of parameters
				Return SetError(5, 0, 0) ; Max number of parameters exceeded
		EndSwitch
		Return SetError(@error, @extended, $aRet) ; All went well. Error description and return values like with DllCall()
	EndIf
	Return SetError(6, 0, 0) ; Null address specified
EndFunc   ;==>__Au3Obj_PointerCall

#EndRegion Call Pointer
;--------------------------------------------------------------------------------------------------------------------------------------


;--------------------------------------------------------------------------------------------------------------------------------------
#Region Embedded DLL

Func __Au3Obj_Mem_DllOpen($bBinaryImage = 0, $sSubrogor = "cmd.exe")
	If Not $bBinaryImage Then
		If $__Au3Obj_X64 Then
			$bBinaryImage = __Au3Obj_Mem_BinDll_X64()
		Else
			$bBinaryImage = __Au3Obj_Mem_BinDll()
		EndIf
	EndIf
	; Make structure out of binary data that was passed
	Local $tBinary = DllStructCreate("byte[" & BinaryLen($bBinaryImage) & "]")
	DllStructSetData($tBinary, 1, $bBinaryImage) ; fill the structure
	; Get pointer to it
	Local $pPointer = DllStructGetPtr($tBinary)
	; Start processing passed binary data. 'Reading' PE format follows.
	Local $tIMAGE_DOS_HEADER = DllStructCreate("char Magic[2];" & _
			"word BytesOnLastPage;" & _
			"word Pages;" & _
			"word Relocations;" & _
			"word SizeofHeader;" & _
			"word MinimumExtra;" & _
			"word MaximumExtra;" & _
			"word SS;" & _
			"word SP;" & _
			"word Checksum;" & _
			"word IP;" & _
			"word CS;" & _
			"word Relocation;" & _
			"word Overlay;" & _
			"char Reserved[8];" & _
			"word OEMIdentifier;" & _
			"word OEMInformation;" & _
			"char Reserved2[20];" & _
			"dword AddressOfNewExeHeader", _
			$pPointer)
	; Move pointer
	$pPointer += DllStructGetData($tIMAGE_DOS_HEADER, "AddressOfNewExeHeader") ; move to PE file header
	$pPointer += 4 ; size of skipped $tIMAGE_NT_SIGNATURE structure
	; In place of IMAGE_FILE_HEADER structure
	Local $tIMAGE_FILE_HEADER = DllStructCreate("word Machine;" & _
			"word NumberOfSections;" & _
			"dword TimeDateStamp;" & _
			"dword PointerToSymbolTable;" & _
			"dword NumberOfSymbols;" & _
			"word SizeOfOptionalHeader;" & _
			"word Characteristics", _
			$pPointer)
	; Get number of sections
	Local $iNumberOfSections = DllStructGetData($tIMAGE_FILE_HEADER, "NumberOfSections")
	; Move pointer
	$pPointer += 20 ; size of $tIMAGE_FILE_HEADER structure
	; Determine the type
	Local $tMagic = DllStructCreate("word Magic;", $pPointer)
	Local $iMagic = DllStructGetData($tMagic, 1)
	Local $tIMAGE_OPTIONAL_HEADER
	If $iMagic = 267 Then ; x86 version
		If $__Au3Obj_X64 Then Return SetError(1, 0, -1) ; incompatible versions
		$tIMAGE_OPTIONAL_HEADER = DllStructCreate("word Magic;" & _
				"byte MajorLinkerVersion;" & _
				"byte MinorLinkerVersion;" & _
				"dword SizeOfCode;" & _
				"dword SizeOfInitializedData;" & _
				"dword SizeOfUninitializedData;" & _
				"dword AddressOfEntryPoint;" & _
				"dword BaseOfCode;" & _
				"dword BaseOfData;" & _
				"dword ImageBase;" & _
				"dword SectionAlignment;" & _
				"dword FileAlignment;" & _
				"word MajorOperatingSystemVersion;" & _
				"word MinorOperatingSystemVersion;" & _
				"word MajorImageVersion;" & _
				"word MinorImageVersion;" & _
				"word MajorSubsystemVersion;" & _
				"word MinorSubsystemVersion;" & _
				"dword Win32VersionValue;" & _
				"dword SizeOfImage;" & _
				"dword SizeOfHeaders;" & _
				"dword CheckSum;" & _
				"word Subsystem;" & _
				"word DllCharacteristics;" & _
				"dword SizeOfStackReserve;" & _
				"dword SizeOfStackCommit;" & _
				"dword SizeOfHeapReserve;" & _
				"dword SizeOfHeapCommit;" & _
				"dword LoaderFlags;" & _
				"dword NumberOfRvaAndSizes", _
				$pPointer)
		; Move pointer
		$pPointer += 96 ; size of $tIMAGE_OPTIONAL_HEADER
	ElseIf $iMagic = 523 Then ; x64 version
		If Not $__Au3Obj_X64 Then Return SetError(1, 0, -1) ; incompatible versions
		$tIMAGE_OPTIONAL_HEADER = DllStructCreate("word Magic;" & _
				"byte MajorLinkerVersion;" & _
				"byte MinorLinkerVersion;" & _
				"dword SizeOfCode;" & _
				"dword SizeOfInitializedData;" & _
				"dword SizeOfUninitializedData;" & _
				"dword AddressOfEntryPoint;" & _
				"dword BaseOfCode;" & _
				"uint64 ImageBase;" & _
				"dword SectionAlignment;" & _
				"dword FileAlignment;" & _
				"word MajorOperatingSystemVersion;" & _
				"word MinorOperatingSystemVersion;" & _
				"word MajorImageVersion;" & _
				"word MinorImageVersion;" & _
				"word MajorSubsystemVersion;" & _
				"word MinorSubsystemVersion;" & _
				"dword Win32VersionValue;" & _
				"dword SizeOfImage;" & _
				"dword SizeOfHeaders;" & _
				"dword CheckSum;" & _
				"word Subsystem;" & _
				"word DllCharacteristics;" & _
				"uint64 SizeOfStackReserve;" & _
				"uint64 SizeOfStackCommit;" & _
				"uint64 SizeOfHeapReserve;" & _
				"uint64 SizeOfHeapCommit;" & _
				"dword LoaderFlags;" & _
				"dword NumberOfRvaAndSizes", _
				$pPointer)
		; Move pointer
		$pPointer += 112 ; size of $tIMAGE_OPTIONAL_HEADER
	Else
		Return SetError(1, 0, -1) ; incompatible versions
	EndIf
	; Extract data
	Local $iEntryPoint = DllStructGetData($tIMAGE_OPTIONAL_HEADER, "AddressOfEntryPoint") ; if loaded binary image would start executing at this address
	Local $pOptionalHeaderImageBase = DllStructGetData($tIMAGE_OPTIONAL_HEADER, "ImageBase") ; address of the first byte of the image when it's loaded in memory
	$pPointer += 8 ; skipping IMAGE_DIRECTORY_ENTRY_EXPORT
	; Import Directory
	Local $tIMAGE_DIRECTORY_ENTRY_IMPORT = DllStructCreate("dword VirtualAddress; dword Size", $pPointer)
	; Collect data
	Local $pAddressImport = DllStructGetData($tIMAGE_DIRECTORY_ENTRY_IMPORT, "VirtualAddress")
;~ 	Local $iSizeImport = DllStructGetData($tIMAGE_DIRECTORY_ENTRY_IMPORT, "Size")
	$pPointer += 8 ; size of $tIMAGE_DIRECTORY_ENTRY_IMPORT
	$pPointer += 24 ; skipping IMAGE_DIRECTORY_ENTRY_RESOURCE, IMAGE_DIRECTORY_ENTRY_EXCEPTION, IMAGE_DIRECTORY_ENTRY_SECURITY
	; Base Relocation Directory
	Local $tIMAGE_DIRECTORY_ENTRY_BASERELOC = DllStructCreate("dword VirtualAddress; dword Size", $pPointer)
	; Collect data
	Local $pAddressNewBaseReloc = DllStructGetData($tIMAGE_DIRECTORY_ENTRY_BASERELOC, "VirtualAddress")
	Local $iSizeBaseReloc = DllStructGetData($tIMAGE_DIRECTORY_ENTRY_BASERELOC, "Size")
	$pPointer += 8 ; size of IMAGE_DIRECTORY_ENTRY_BASERELOC
	$pPointer += 40 ; skipping IMAGE_DIRECTORY_ENTRY_DEBUG, IMAGE_DIRECTORY_ENTRY_COPYRIGHT, IMAGE_DIRECTORY_ENTRY_GLOBALPTR, IMAGE_DIRECTORY_ENTRY_TLS, IMAGE_DIRECTORY_ENTRY_LOAD_CONFIG
	$pPointer += 40 ; five more generally unused data directories
	; Load the victim
	Local $pBaseAddress = __Au3Obj_Mem_LoadLibraryEx($sSubrogor, 1) ; "lighter" loading, DONT_RESOLVE_DLL_REFERENCES
	If @error Then Return SetError(2, 0, -1) ; Couldn't load subrogor
	Local $pHeadersNew = DllStructGetPtr($tIMAGE_DOS_HEADER) ; starting address of binary image headers
	Local $iOptionalHeaderSizeOfHeaders = DllStructGetData($tIMAGE_OPTIONAL_HEADER, "SizeOfHeaders") ; the size of the MS-DOS stub, the PE header, and the section headers
	; Set proper memory protection for writting headers (PAGE_READWRITE)
	If Not __Au3Obj_Mem_VirtualProtect($pBaseAddress, $iOptionalHeaderSizeOfHeaders, 4) Then Return SetError(3, 0, -1) ; Couldn't set proper protection for headers
	; Write NEW headers
	DllStructSetData(DllStructCreate("byte[" & $iOptionalHeaderSizeOfHeaders & "]", $pBaseAddress), 1, DllStructGetData(DllStructCreate("byte[" & $iOptionalHeaderSizeOfHeaders & "]", $pHeadersNew), 1))
	; Dealing with sections. Will write them.
	Local $tIMAGE_SECTION_HEADER
	Local $iSizeOfRawData, $pPointerToRawData
	Local $iVirtualSize, $iVirtualAddress
	Local $pRelocRaw
	For $i = 1 To $iNumberOfSections
		$tIMAGE_SECTION_HEADER = DllStructCreate("char Name[8];" & _
				"dword UnionOfVirtualSizeAndPhysicalAddress;" & _
				"dword VirtualAddress;" & _
				"dword SizeOfRawData;" & _
				"dword PointerToRawData;" & _
				"dword PointerToRelocations;" & _
				"dword PointerToLinenumbers;" & _
				"word NumberOfRelocations;" & _
				"word NumberOfLinenumbers;" & _
				"dword Characteristics", _
				$pPointer)
		; Collect data
		$iSizeOfRawData = DllStructGetData($tIMAGE_SECTION_HEADER, "SizeOfRawData")
		$pPointerToRawData = $pHeadersNew + DllStructGetData($tIMAGE_SECTION_HEADER, "PointerToRawData")
		$iVirtualAddress = DllStructGetData($tIMAGE_SECTION_HEADER, "VirtualAddress")
		$iVirtualSize = DllStructGetData($tIMAGE_SECTION_HEADER, "UnionOfVirtualSizeAndPhysicalAddress")
		If $iVirtualSize And $iVirtualSize < $iSizeOfRawData Then $iSizeOfRawData = $iVirtualSize
		; Set MEM_EXECUTE_READWRITE for sections (PAGE_EXECUTE_READWRITE for all for simplicity)
		If Not __Au3Obj_Mem_VirtualProtect($pBaseAddress + $iVirtualAddress, $iVirtualSize, 64) Then
			$pPointer += 40 ; size of $tIMAGE_SECTION_HEADER structure
			ContinueLoop
		EndIf
		; Clean the space
		DllStructSetData(DllStructCreate("byte[" & $iVirtualSize & "]", $pBaseAddress + $iVirtualAddress), 1, DllStructGetData(DllStructCreate("byte[" & $iVirtualSize & "]"), 1))
		; If there is data to write, write it
		If $iSizeOfRawData Then DllStructSetData(DllStructCreate("byte[" & $iSizeOfRawData & "]", $pBaseAddress + $iVirtualAddress), 1, DllStructGetData(DllStructCreate("byte[" & $iSizeOfRawData & "]", $pPointerToRawData), 1))
		; Relocations
		If $iVirtualAddress <= $pAddressNewBaseReloc And $iVirtualAddress + $iSizeOfRawData > $pAddressNewBaseReloc Then $pRelocRaw = $pPointerToRawData + ($pAddressNewBaseReloc - $iVirtualAddress)
		; Imports
		If $iVirtualAddress <= $pAddressImport And $iVirtualAddress + $iSizeOfRawData > $pAddressImport Then __Au3Obj_Mem_FixImports($pPointerToRawData + ($pAddressImport - $iVirtualAddress), $pBaseAddress) ; fix imports in place
		; Move pointer
		$pPointer += 40 ; size of $tIMAGE_SECTION_HEADER structure
	Next
	; Fix relocations
	If $pAddressNewBaseReloc And $iSizeBaseReloc Then __Au3Obj_Mem_FixReloc($pRelocRaw, $iSizeBaseReloc, $pBaseAddress, $pOptionalHeaderImageBase, $iMagic = 523)
	; Entry point address
	Local $pEntryFunc = $pBaseAddress + $iEntryPoint
	; DllMain simulation
	__Au3Obj_PointerCall("bool", $pEntryFunc, "ptr", $pBaseAddress, "dword", 1, "ptr", 0) ; DLL_PROCESS_ATTACH
	; Get pseudo-handle
	Local $hPseudo = DllOpen($sSubrogor)
	__Au3Obj_Mem_FreeLibrary($pBaseAddress) ; decrement reference count
	Return $hPseudo
EndFunc   ;==>__Au3Obj_Mem_DllOpen

Func __Au3Obj_Mem_FixReloc($pData, $iSize, $pAddressNew, $pAddressOld, $fImageX64)
	Local $iDelta = $pAddressNew - $pAddressOld ; dislocation value
	Local $tIMAGE_BASE_RELOCATION, $iRelativeMove
	Local $iVirtualAddress, $iSizeofBlock, $iNumberOfEntries
	Local $tEnries, $iData, $tAddress
	Local $iFlag = 3 + 7 * $fImageX64 ; IMAGE_REL_BASED_HIGHLOW = 3 or IMAGE_REL_BASED_DIR64 = 10
	While $iRelativeMove < $iSize ; for all data available
		$tIMAGE_BASE_RELOCATION = DllStructCreate("dword VirtualAddress; dword SizeOfBlock", $pData + $iRelativeMove)
		$iVirtualAddress = DllStructGetData($tIMAGE_BASE_RELOCATION, "VirtualAddress")
		$iSizeofBlock = DllStructGetData($tIMAGE_BASE_RELOCATION, "SizeOfBlock")
		$iNumberOfEntries = ($iSizeofBlock - 8) / 2
		$tEnries = DllStructCreate("word[" & $iNumberOfEntries & "]", DllStructGetPtr($tIMAGE_BASE_RELOCATION) + 8)
		; Go through all entries
		For $i = 1 To $iNumberOfEntries
			$iData = DllStructGetData($tEnries, 1, $i)
			If BitShift($iData, 12) = $iFlag Then ; check type
				$tAddress = DllStructCreate("ptr", $pAddressNew + $iVirtualAddress + BitAND($iData, 0xFFF)) ; the rest of $iData is offset
				DllStructSetData($tAddress, 1, DllStructGetData($tAddress, 1) + $iDelta) ; this is what's this all about
			EndIf
		Next
		$iRelativeMove += $iSizeofBlock
	WEnd
	Return 1 ; all OK!
EndFunc   ;==>__Au3Obj_Mem_FixReloc

Func __Au3Obj_Mem_FixImports($pImportDirectory, $hInstance)
	Local $hModule, $tFuncName, $sFuncName, $pFuncAddress
	Local $tIMAGE_IMPORT_MODULE_DIRECTORY, $tModuleName
	Local $tBufferOffset2, $iBufferOffset2
	Local $iInitialOffset, $iInitialOffset2, $iOffset
	While 1
		$tIMAGE_IMPORT_MODULE_DIRECTORY = DllStructCreate("dword RVAOriginalFirstThunk;" & _
				"dword TimeDateStamp;" & _
				"dword ForwarderChain;" & _
				"dword RVAModuleName;" & _
				"dword RVAFirstThunk", _
				$pImportDirectory)
		If Not DllStructGetData($tIMAGE_IMPORT_MODULE_DIRECTORY, "RVAFirstThunk") Then ExitLoop ; the end
		$tModuleName = DllStructCreate("char Name[64]", $hInstance + DllStructGetData($tIMAGE_IMPORT_MODULE_DIRECTORY, "RVAModuleName"))
		$hModule = __Au3Obj_Mem_LoadLibraryEx(DllStructGetData($tModuleName, "Name")) ; load the module, full load
		$iInitialOffset = $hInstance + DllStructGetData($tIMAGE_IMPORT_MODULE_DIRECTORY, "RVAFirstThunk")
		$iInitialOffset2 = $hInstance + DllStructGetData($tIMAGE_IMPORT_MODULE_DIRECTORY, "RVAOriginalFirstThunk")
		If $iInitialOffset2 = $hInstance Then $iInitialOffset2 = $iInitialOffset
		$iOffset = 0 ; back to 0
		While 1
			$tBufferOffset2 = DllStructCreate("ptr", $iInitialOffset2 + $iOffset)
			$iBufferOffset2 = DllStructGetData($tBufferOffset2, 1) ; value at that address
			If Not $iBufferOffset2 Then ExitLoop ; zero value is the end
			If BitShift(BinaryMid($iBufferOffset2, $__Au3Obj_PTR_SIZE, 1), 7) Then ; MSB is set for imports by ordinal, otherwise not
				$pFuncAddress = __Au3Obj_Mem_GetAddress($hModule, BitAND($iBufferOffset2, 0xFFFFFF)) ; the rest is ordinal value
			Else
				$tFuncName = DllStructCreate("word Ordinal; char Name[64]", $hInstance + $iBufferOffset2)
				$sFuncName = DllStructGetData($tFuncName, "Name")
				$pFuncAddress = __Au3Obj_Mem_GetAddress($hModule, $sFuncName)
			EndIf
			DllStructSetData(DllStructCreate("ptr", $iInitialOffset + $iOffset), 1, $pFuncAddress) ; and this is what's this all about
			$iOffset += $__Au3Obj_PTR_SIZE ; size of $tBufferOffset2
		WEnd
		$pImportDirectory += 20 ; size of $tIMAGE_IMPORT_MODULE_DIRECTORY
	WEnd
	Return 1 ; all OK!
EndFunc   ;==>__Au3Obj_Mem_FixImports

Func __Au3Obj_Mem_Base64Decode($sData) ; Ward
	Local $bOpcode
	If $__Au3Obj_X64 Then
		$bOpcode = Binary("0x4156415541544D89CC555756534C89C34883EC20410FB64104418800418B3183FE010F84AB00000073434863D24D89C54889CE488D3C114839FE0F84A50100000FB62E4883C601E8B501000083ED2B4080FD5077E2480FBEED0FB6042884C00FBED078D3C1E20241885500EB7383FE020F841C01000031C083FE03740F4883C4205B5E5F5D415C415D415EC34863D24D89C54889CE488D3C114839FE0F84CA0000000FB62E4883C601E85301000083ED2B4080FD5077E2480FBEED0FB6042884C078D683E03F410845004983C501E964FFFFFF4863D24D89C54889CE488D3C114839FE0F84E00000000FB62E4883C601E80C01000083ED2B4080FD5077E2480FBEED0FB6042884C00FBED078D389D04D8D7501C1E20483E03041885501C1F804410845004839FE747B0FB62E4883C601E8CC00000083ED2B4080FD5077E6480FBEED0FB6042884C00FBED078D789D0C1E2064D8D6E0183E03C41885601C1F8024108064839FE0F8536FFFFFF41C7042403000000410FB6450041884424044489E84883C42029D85B5E5F5D415C415D415EC34863D24889CE4D89C6488D3C114839FE758541C7042402000000410FB60641884424044489F04883C42029D85B5E5F5D415C415D415EC341C7042401000000410FB6450041884424044489E829D8E998FEFFFF41C7042400000000410FB6450041884424044489E829D8E97CFEFFFFE8500000003EFFFFFF3F3435363738393A3B3C3DFFFFFFFEFFFFFF000102030405060708090A0B0C0D0E0F10111213141516171819FFFFFFFFFFFF1A1B1C1D1E1F202122232425262728292A2B2C2D2E2F3031323358C3")
	Else
		$bOpcode = Binary("0x5557565383EC1C8B6C243C8B5424388B5C24308B7424340FB6450488028B550083FA010F84A1000000733F8B5424388D34338954240C39F30F848B0100000FB63B83C301E8890100008D57D580FA5077E50FBED20FB6041084C00FBED078D78B44240CC1E2028810EB6B83FA020F841201000031C083FA03740A83C41C5B5E5F5DC210008B4C24388D3433894C240C39F30F84CD0000000FB63B83C301E8300100008D57D580FA5077E50FBED20FB6041084C078DA8B54240C83E03F080283C2018954240CE96CFFFFFF8B4424388D34338944240C39F30F84D00000000FB63B83C301E8EA0000008D57D580FA5077E50FBED20FB6141084D20FBEC278D78B4C240C89C283E230C1FA04C1E004081189CF83C70188410139F374750FB60383C3018844240CE8A80000000FB654240C83EA2B80FA5077E00FBED20FB6141084D20FBEC278D289C283E23CC1FA02C1E006081739F38D57018954240C8847010F8533FFFFFFC74500030000008B4C240C0FB60188450489C82B44243883C41C5B5E5F5DC210008D34338B7C243839F3758BC74500020000000FB60788450489F82B44243883C41C5B5E5F5DC210008B54240CC74500010000000FB60288450489D02B442438E9B1FEFFFFC7450000000000EB99E8500000003EFFFFFF3F3435363738393A3B3C3DFFFFFFFEFFFFFF000102030405060708090A0B0C0D0E0F10111213141516171819FFFFFFFFFFFF1A1B1C1D1E1F202122232425262728292A2B2C2D2E2F3031323358C3")
	EndIf
	Local $tCodeBuffer = DllStructCreate("byte[" & BinaryLen($bOpcode) & "]")
	DllStructSetData($tCodeBuffer, 1, $bOpcode)
	__Au3Obj_Mem_VirtualProtect(DllStructGetPtr($tCodeBuffer), DllStructGetSize($tCodeBuffer), 64)
	If @error Then Return SetError(1, 0, "")
	Local $iLen = StringLen($sData)
	Local $tOut = DllStructCreate("byte[" & $iLen & "]")
	Local $tState = DllStructCreate("byte[16]")
	Local $Call = __Au3Obj_PointerCall("int", DllStructGetPtr($tCodeBuffer), "str", $sData, "dword", $iLen, "ptr", DllStructGetPtr($tOut), "ptr", DllStructGetPtr($tState))
	If @error Then Return SetError(2, 0, "")
	Return BinaryMid(DllStructGetData($tOut, 1), 1, $Call[0])
EndFunc   ;==>__Au3Obj_Mem_Base64Decode

Func __Au3Obj_Mem_LoadLibraryEx($sModule, $iFlag = 0)
	Local $aCall = DllCall($gh_AU3Obj_kernel32dll, "handle", "LoadLibraryExW", "wstr", $sModule, "handle", 0, "dword", $iFlag)
	If @error Or Not $aCall[0] Then Return SetError(1, 0, 0)
	Return $aCall[0]
EndFunc   ;==>__Au3Obj_Mem_LoadLibraryEx

Func __Au3Obj_Mem_FreeLibrary($hModule)
	Local $aCall = DllCall($gh_AU3Obj_kernel32dll, "bool", "FreeLibrary", "handle", $hModule)
	If @error Or Not $aCall[0] Then Return SetError(1, 0, 0)
	Return 1
EndFunc   ;==>__Au3Obj_Mem_FreeLibrary

Func __Au3Obj_Mem_GetAddress($hModule, $vFuncName)
	Local $sType = "str"
	If IsNumber($vFuncName) Then $sType = "int" ; if ordinal value passed
	Local $aCall = DllCall($gh_AU3Obj_kernel32dll, "ptr", "GetProcAddress", "handle", $hModule, $sType, $vFuncName)
	If @error Or Not $aCall[0] Then Return SetError(1, 0, 0)
	Return $aCall[0]
EndFunc   ;==>__Au3Obj_Mem_GetAddress

Func __Au3Obj_Mem_VirtualProtect($pAddress, $iSize, $iProtection)
	Local $aCall = DllCall($gh_AU3Obj_kernel32dll, "bool", "VirtualProtect", "ptr", $pAddress, "dword_ptr", $iSize, "dword", $iProtection, "dword*", 0)
	If @error Or Not $aCall[0] Then Return SetError(1, 0, 0)
	Return 1
EndFunc   ;==>__Au3Obj_Mem_VirtualProtect

Func __Au3Obj_Mem_BinDll()
    Local $sData = "TVpAAAEAAAACAAAA//8AALgAAAAAAAAACgAAAAAAAAAOH7oOALQJzSG4AUzNIVdpbjMyIC5ETEwuDQokQAAAAFBFAABMAQMA5krtTQAAAAAAAAAA4AACIwsBCgAAOgAAABgAAAAAAABbkwAAABAAAABQAAAAAAAQABAAAAACAAAFAAEAAAAAAAUAAQAAAAAAALAAAAACAAAAAAAAAgAABQAAEAAAEAAAAAAQAAAQAAAAAAAAEAAAAACQAABUAgAAVJIAAAgBAAAAoAAAcAMAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAALiSAAAgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAALk1QUkVTUzEAgAAAABAAAAAqAAAAAgAAAAAAAAAAAAAAAAAA4AAA4C5NUFJFU1MyFgYAAACQAAAACAAAACwAAAAAAAAAAAAAAAAAAOAAAOAucnNyYwAAAHADAAAAoAAAAAQAAAA0AAAAAAAAAAAAAAAAAABAAADAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAdjIuMTkIAMspAABVAIvs/3UIagj/ABVYUAAQUP8VSlQM0DXMQgAsBgXIUoPsIIPk8NkAwNlUJBjffCQCEN9sJBCLFrAIQEQCUQhMx+MNkF4oneeRzUECsMhAEhgPAAAAABgY/P///zcIAg3ABBSD0gDraCw65DLYLqMNsI5EARH3wipRh5sNwUWCYRDJw1aLAPGDJgCDZhgAFI1GCBUAgBUAi8ZIXi6xaEAOB1DoQBPOkDVojGD1D1JBqANew4sBwwGNQQjDi0EYZxAAi0UIiUEYXcIFBACLQRwgxgESgBhgdbWY33iHIGA26ANAdyBIaiAIWP8AZokG/xVBiByQeATx5cVF" & _
            "gC4wGIwQ9V/BGw8DhFUBbAT/FQQ+ADCTrCYApHUvDvAAGXyfvYAcRYDO6P//zxOJBriTAABXEIRUAjBKDQacHIEJjUYYUMcGCDxRABAdMItGCECL9QBRCINmCABAXg1CVot1DFczAckzwGaJTfQGAECuRpDV2Ac/AyCdWAR/XGQPAAAADJBYpG92DFDkD2A0f3pcBABOQCAAcFxkDgoz6jDgDmBEtwGsCHACPiM9f0oHwLDYBJEYgCtwAAQAuA5xAsAh9gJAMAP85ZUszAB8EGMTjUgYUf9wDAj/cAxRE3kQi00AFIkBM8mFwA8BlMGLwV3CELNAImoAVkahFmA19wHYG8BAXcIIRA8AAaEmQKQEALgB4B8AVLMOgPDvRLAIYkRwAOCM/hgAYAJglR4zA3wZmDZhhkIAkBiT2BdEsFg0wJBoxLBYJAKBAA4UiUYU0xGlY2Fwo2TYFSLew3AVFPALQmXVKQBcFIAxFvMLAQpSB11RdQiLBlYi/1DMAJEI0xXRBd4Vww45AwODIAAzUcDjQFNlE0YYV2mzJIs9aRP/123jVfwN//+LHV8TTJGYBqEwvWjEoacMbh/QUewGNJFoxCEmIGKqKf0C6/tiMhQAIgZfMl5bhxBZAP82ajITAJyVaJBoRFAaAPhA8p9EsBhEsAhQhbADPYewmCCwSBCYSBDZIDEF2FoQP/N/bMAiBQAAkeMHYeexCDgfwIFbuE3nsEixjH5rCVMPMEc7AX4QcuKNXgwsICBCAACw2FNO0QhghAL1f91ohMSrIDgK0BWwB7gPu2iXAVJov2egMf8zDoO8B7BtUoUxIDDIjgEwtag8GB5gdQXxUCjMA/bCAg8ghbkQwvBAOCKAAADQw9cVUNe2SFDHMeiHgAMoB4AbAEYEM9uDOP0AD5TDM8CF2w8AlcCL+IsGwecABAPHD7cIg/kAFXQZg/kUdBQAg/kadBuD+RMAdBaD+QN0EekA6wUAAGoTagBUUL0DrL0TNnxCCQwQDE4wYAz1T1fgg5Ce" & _
            "YGAOeuYBGASAMIiHAPBACERrAoPAOItNHAH/MVDrbT15PKDxUFjYTEBkkUSChLO+/QUzRPAFEfBQuIQHA4sGLUAeLRA3ABgadCAtEDcAA3QWALgFAAKA6UoMpDfABu8VdSCnODPAl0DSs4cbXakEuKAOSBu40FjUOGAH8x9SgeoEhcB1OU0Ak1UJaBDHAmaJsQZZGZAmkBgUd8ChloAFYZYYFF3AkQiHAT1TgyekSDBojGJFs86YDxNigFAOAJVeZfARgUcSEtlgpI8BAYPAWOvhPXcwIeCy2Icw+AcTi4wwsFgHEqa3pXFHgnwA00OQ/tAUgc9fR8VUCIJBBlhk0QcCdEVGDVhqKGaJDAfo+PjlBJkDE/8AdiCLyP92HP8EdhhW6M4hA+sCDDPAiUd5R6Ays02wM/zA+GAvCIsAfhBHO8cPjQCAHOHHsMhzmNgXgGC2s/xQeIQHtL8jPhDyO8A9S/GMDrb+PUANCTleCA8ohMgmo20CSA+EQl/HAkgPhbMoUbfEUa4wiA8IgThgBELWDJDLAAIwp8AxYJaD8FCYoQVrEisVoJsR+PsCByKwRYGUvEWgNjCgMAO8JVKYHEaQ2ARyRmZGsINBtzDVQptTFATyQtZIdIMANSYgSiucQJD+pJA1MKC01Q5QWHoBDnIB0mgMAheAAnV/D1ALAIsR+YvHkRqD4ALEIWQwAG4wCAyRFS9QCPTfHjAAvEhkjABtpAA8BAQ0998b/wKD5/6DxwJVAokARfQD/o1F8FeG4QEg6RQI2QY5KymW7QT/NsEBK2UD9SX/jCIH8Iw+nSEhCSCJRmAkngDZLbCIhTBYBsAO0DgkkFiEDtBYhA6lFqDGAPFfgWkUEE0MUVAQiUX49WpThdt+EUaLw1UCx0X0OQMAAIld/Itd9IlMRboAMTDshVBRAACLA00YjUQI8IEBYAPYyTHYhgExOAwR8N/EX/f8X5cFANi1segFtliEfxxiBJYcAJBevhB46ZUXeCOZJVCC1EqRgtOHDhXVR+kC"
    $sData &= "hqV1i/i4ga0VZjkHD4US0RdWd9GXANEXBn0GWfUCCASDOP91I5F8Zol1HpIUYeAADRCUqglh0EXDVid7AEwByQSxFiUJ1J4AFaGiGaFfIBh+TbeoYbDYkw9RFHRQFHONHXkGZDapAlkHi3YYAIl19IP+/3Un4J1xShNRGjHYBy9g9Rx9UaSUXtOi0BrQekBUYUlEEEBAp4DrUBwVkNMF8kB4ry/MACZNCMkh6YdeBNHezFCdQpGDH8Ofg6+An4Mvgp+DMZwFkIPGP2gGhgzaDwAEk3KiNmCWaITigmVFAViBIgklxhIxKNAHApDoBZZXQBfX0CDidFBZkv9OCBEBgZUm/f/9fwUD4QMY6wW4GCHMAMnCJOxSHGTvAN4OAeLtAGoSwYBrWDoChW42o9YAvgTxQGjuIOCDyP9yHLN4HLNurzYhuBGPHtVSELCIPbj/7zeSACBwtciDWfjv/gDPoO4PcmXoMFONTgzofznGAyAaIToeVl4RC0ILGSBI8IUHdDNYZTaIA+BHV7J4xDC1iMMBKxTxAGBQO8EAuwWyvpAS0PjEgH5JppEI4SUhM9s2E3C1CNYTU2EnMYleBIleAwiJXgyJXiyghAEAKFCJXhiJXhwDiV4giV4k/hHlIlFBWBSgBoIuKG+NAAA7w3QLi8jon8qdLbYI8D9VHOBNA2pTAiDwDgJoWAIawAJVP70IV8IasJwj8OWaAZxmEhIVlRNPI8UA7gGQ8yUBYddXFoAeXxbDAFgWlFiEsD6Q2AWE0DXCv8iAmNi0hu8UIJUDULUhi0DgCiD/QGFLEECRuwEkGRJAEboSDxQtEo0WNTL/RfyNCQA7RxByg4tHGIDdAA7/dyCLzv8CdxxQ6HEDtULJkXE2UVH+HvdQaKkwEEQ94RkAdH0xDYNlQPyNA34QQE/HRVH4QgMAIJoBdE5T4hgBXI9UblGH0+iFMsVY+tNYhJ/UGLhllgg1wDxWebtPdbRb9XYZ1WJTtdGz8JUiUFWRAG4Scr1BtQEQ/zZocOIN" & _
            "Bt1q7iPBcQxgIwH/pcohgiGZAGiEhLpAKJZ2FrHODQeccB9gVxHrWb9wQAv3AVoUsS4KB2XIcB9ghBHrhXAADqdiDnBiTxHpeg/iC4Hmx8/3ARIVwUc1HHEsvhYQkDKIb5kBLUkCuAYeBAHGRwgtLWogi/noNJfvghSTqgafqmCvdhdQPVB/YYMSzpUnUTd5N1cMJMDPBFbxCtEqNiSVGgUkFAVPIBAFNNgXdcCnkAZTlBEEEwmbBjuYR8AAcBzAX8BQlwDuJBLCLOL/IU0Ii0EIf0BSGuCSIrImgQtOKSN8IpVGaEjo0DvNmTSQTiGx2kOCxfcBm3yIxqexNUqafLAuBwd8cB+QqQoXVXBACfcBmHCBowoHsHAfcAkXG3AA/AqnDXBiWZaiZAApFoEpgBEjDIP5nHUQ9gJFGAJ1ELh+DhIYRCGnAUUYAevuOioAWUVgxKC3EXQPg/lVm0IMAIEYf4hwBR5LLmkAOVjODpCc9yHRcbKOH3FQ46DJAcdGUgwBIJNexwwJAHVBZQg5UlnIYIkFO8NVBUaCVUVqaOhD7ZIBk9CZb9DSoNpBfOQvAAwVQACadWGLfRyLdwAIg/4CdAmD/ggDD4VIAREHi84AA8kz0maDfMgA8AiNTv4PlcKAPLBtNsiDjPAQUDm8MP1Q+MIJgBIa4D9Ql2CWgwSAQDegJpC1aB0QNSD9TweNzgBA+HozgUSw3jeYL5FZ5+TVEEgI7h5AGIRej5E/8HD4XZVBALEYPACcCSAMDxoiwI0mAXYEi1wIwugz/5RQJ7AIoL/oRHA19U9HIIyPzgqRL4ZZt/eSBOAwApIV4CkQi+4BkQBAlMkSTgRTUgGAxq0aX3HFfJexkgXlEV+HofIQdUq54B0AnTKJACN1Oh0CUYvWndIuBRKwjjSYb1l3VBbUbC4D1hOxzhMXgwMIOBHQsoiHcIVGXoaadGCOIusSrRLojM0M3YEozg/U5fxAagaSgYBQ3UJzEKFm01I2gqDyAwwACGpoxwapHeg76+AZ" & _
            "Px33A5o/sRg8iAQB8D+TnIiQiESQkohEAQzqP2JE4P6ThO4+IPFvx0Aj/3ZTCFSTRQ9BBBY3A8yThj6PoKpu6ENGBIo+aQAAyCEQWjOU45MLL7DYhQAwk2yWs/BAGAtaaTEcRbBT92A2CIAnAEA3cLReEJhhkAgR1EiwBAYAAHXhhcl0AUeSViNAOEgLjUHiPKCmJFASk+jTEuPREjE1B+WsAyUxhECgpVMCtXEk/OmEsOgkeAMIiUAIHDADPPNvliMRQGcDGk4MmQcBETt1Fr0HiRwBPADQSBQgsOiEkEhAoDAoTMADR40gBD+MgABQJ70+NmBZBBoVtBgEoUlkjkPFakEgBBYEQCA9ZGY8XEcyGHCQYwRDV6FqAwFG6SBgEBS1B1TCBLLeZM/DPHUe0FT3AF0SPbduTCgCIzAAdBAqBwGE0a1xEJAQEY/gYRCKPUih2IOJGj+VGERjaIRGQLo9nDFoBiQuBBX3A6ToFTc6i/iiApBOQQ4IZQl+DkBA6wnyGWT4M3kggSDsAPoPMQMMBYUGTRIKR9Bo+BBRav//K3ZATiXBYA0RhUxhUAMKNP8VCGEYyUlYfWEImQAhEY10R/4mShCgUqczA3ylZqAUOeiFDS1qRWBYA2oqmjMxgfv/L3QSAXRSBaBcACZDiYYgAHHcDRGNsB600ZDxQCexeJyJcKFDNxGM8BSM4tACfSYAEACNNE+NRgIYaGBTbk/Q6DKznUU1lOlRUE2B4U8Cg34l/ir9AHUpkiDgnxAPgGLk3xCmKlUUGOuGsqnhOqlh3Qo5AeIBsJggnL6CIQYxM/bRAgAMOXUIfg//NEC3PSRGWTt1CHx18XE0tQYcRMFBGBxkxMEhg8QU8RRqChIlFqVxIWIP8V+B7kgi+BGLVfzKGNVYxB9VkC0iBYREq1syUgdQxC+HAijrEVQCW3Gyg7xRAHyPfY/NXt2WSxBQ9A8VFdXNYZYDQLjkU6BY9L+OYIkG6CpZAMlCR4M6/KaoBYY6BmZqG8D6DsC1rJ9B"
    $sData &= "nBCE+hHIqJSNCkAJaJDdxZBdxIDL+gTMWfAJ4Q4BFhF0KgOLwVeDfQxaFZCDIMBSB6Hmsm5NBTgALnUGaixfZokEOEKNBFGhKNpfwJZLpE0wjUgBO04IIHZGslKgRtBIBKAsKUChPDvloi2Ar5UEOQBGBHYOiw6LDACBiQyHQDtGBDBy8s5JlACQ1cgEoCCQ6JOo2hEOtkmQSEAR+G9EUM8VNcMAjFMEodQUZkpzbIDHVqZgPQCaT+D4BIlGNBWJRkCKO3Al+AGNXksBaNJCCItdDINlCICaIIDxYFtEMVgGRYECOCiAMZVoxMGT2GVNAHEvRlXAn0hQhdFIMOVWJHx1QQ6JDIkIjURTWi8AgLBONpivQFdgYFaYXKdVKNCugKCBXkZupTAKJeHt5gCJAUUQ6wSDZRAaGmLQBIEOUuGhMSiQdooiFChhZRGu4rQSwikBsFiE8V9E0UiEKg8TDBJLINQQsFPFn/FgOCdoAVYkRAHg2VT2yRK+LeI7IqJNJl8PINqkW/N5EJ5NUTIjYRGDfoIE4E9gogIOQOM5IP8VEO5ZAoQpypB+OKggSAT/FRT4elrhsECqTaDJIO4tcQexPqahigLOLwKLzpEn4PySV04mLvDn/ILGzi/i7EKwEinlAYcc4jjxX9eg34Iv6yeBBvAOKuHsYm2Czi5m47UVj1B1YxXsYhIDXO74kOFR8Qnd4qgJAkog0W/vFgDiJgXfCgBLXdxJ/x/YtvS/wp3aCP8f4PDfQP8MjLBGADhBf05EkFjF/63Shp8Bf4CfAcqXAdRNUoSfAb8wA2w3AzhdfwxdDvENUU5yMxvkoOkQ/S0GEFeJXjjdDVIgAHKgRoEuDi4IcgkdYhjBB5XGVfHXwWKWUm5h679h7Rb2Aa4ncSVOAhgxAXobF2ErTiLcdg4g9TAYiiPgKQU8EwB0IgZKEnKhDhQWHNDpTRLr3bUZtTpJC82EkpysYdJSdbrqJbJeK69FgOolwM40KB5gVSdkoF8SdCiB+akQdVkg/lM4" & _
            "YcsQSgIBhGEwAJgOV+AIo4wlCQQ5WDwAdQk7y3wQO0gCEH0LZjvTFiekAOnfIemNoAHFsEgBpNgPsJiEMKCQKFCFvRgdKO4/AoAAiU3QeQVKg8o4/kK4oEgkuPEPhADQGPSfuSK8CC9xFe3vnSGLxuYZUzfE7WUwY9///2JOYJwx1WwDNkpgwgD2ADFgUoUPBhBgiwEm/GAPAPLv7X4AddCJReQQjUb+OiVATJHYh0CdWAQuIxOOAwmQ/RLgJRUSeQVIgwLI/kAPhOFyULAI0ISdk1MntlhnBC5LEgcD9gIbIGcS8Yxs8E8H7/JAbklxsAhDBC+ZBCYYwL84H2xgTtDIY6BZAdUXAzZ15OEEFgiDrawA5RNFCeB0MEhNA9H4nlNBELC+gl4WaLCIfLBovFIEziV2ZCAQBWDsVggTCLBuupgwMADcSBQMD1UD4FkUCItN8IuAUMfeSEKE5HEBOCqU8FCodWGEEU36FSB0EQGWFLIIUAWflaWmkvVAcgtsLgFXV1kAZolgCupOVBzQRN8AAJRqshMEiGCgsQL4CC5WAGA22McOkNgED/FASBAywm42mA8QUXejFoBO203y/6/LBABZIQB0DchKIqBTEBQd2QsPahEaagBWfQFpEIrGS9AkwI4YkF5eItMT+ScLdaIggH4Hn04HAC8lGxleKmA3ojIEC/yH8/Ar5gVQwQ4CdSIKagLoO+HwAo/hEDgIagLrJpwgUZeDygkTnC8QxRkQahK1gXBmqnTRJZCYGDaRCaBAgE7Njf8Bzfhxg6I2kQky0DFAgM56yfkCCh4dIwOZcJUwkXBFDJEAEOhv8JBVaBOddpH6wN5llB5uwilwFEJjEJRAAhUPhLaqJEMQDjITDi9wFA5DEBoOlx0OUMSejREOJVQADwjo9tvwH+CoCj8F8NcNL93w5oFTB9Z1IG4TlRrrKmrkFnbAWrYBMLEYAqIWgGCVWMduYiDrB8cYRewo5gKgYwABAOhOf9kAWYtdCdYiAQRWmLYiUMduK1LN" & _
            "Uh91U6GV8CEslTACAOgZlRCcXQCL8NCgUhJhUAh1UkphEAUBAOslVcAQx1VgSTAFvjBBAHxghyYGRcyNRcxiZ6EeAjwYmOkDthrQA6DxQCi2W8oQuVFSV5FF8AmknUVXx6FGsf6yyBYmdUJsMMhGaMCRRVeRTKShEF0niVEGBOtNahXBh9JUwY6s2CIaMrAeEwKR8FDY1tcLEG9gEwNgbQIJoSD39isQh5MgIDUHBjorpeATzQEQiTyZMk2QSJCZvqSQHYBG45GgYxUAqfQfTDxBZq7ZQfYKjm2g5lGyfkYEaEDVoHPV8CJdTIFmONUQgZahEB8KAqBuHxB6QJJZcBcugClmAok1NJjhIhURUBWhRRUhuTX3FVzoUAigDScEWY0AmYEA6TpZCz4GVEQvURAAPFh0BGoI6w/gbgZgaBCyBfBwSxAMRe6pMtBgTwBZuSIrshNc8UB4rRwFZu6DQOgeFYgxEQ+Fy7Y+gpDYJMA+iL9QlyLbQA8+twfSBdAXVS7hO0BiLIAQkd6fIq8REXUotK8wqlYQiLBWUOeB+AD9Hi3dXohFgPgCfgCRjWi5lnLgqhQAmA+QpZEezlhsiowbLHGHBJoIYDX4gD9Q55dx0x4vQANhEgEIikXs6fgnORBxEppC4LAWKhvAnq6MJFATikrBHjJHUIewrQkHPiihMjCyASMVgkJHgE/xUJgfSVE0wp6ZGFTwUKh6FbICANHdhZ4Rn1DRXYQ+ExXVJ2CwAuhXtgnRFFRLtoJkkRYjQLauZFc1QbbaZEEdGUJAtmsF+QgtQgNkG0MWzENUUTVBUUeCB+hJYdbyElBEYMWwThEjLyDatkETtjFIgmkAB9AAQzP//03gg30C4P8Pj/32fhNQxICd2Adt/xhNAzk4MnRmOhvgFSEYU2UKask+KSGtAXX0wl1QR+6NFgZ1+FPosMEGJkaAu3ICKGwBjMIW4EsS7ikCzhqkbIkB/0gIi8aopENgnhHUmmoyYL8IwAWP/3BLBA/PNxW90wrQvOCX"
    $sData &= "Bl43kpWF6FADHHVEWoHRWAS+yADQUFPiHMBruzESYGFstQi9gP913MUgOSHrBIc5fdB0KgDAURFoKhGDfRwedAcYQfBR5/BwKx0IRdTIbOFGFEW0th6U48cDQAez6DyzjQ5o2Aiwc1wX44UljfADL7DxEoCqACB8AYteGOhAUnYtEAwusNjHrdDYRBtVFnPlkwP/FHXgUDphgCfCEmXIoLEAxEphcKTGkNh3RWz6VhjieAFv+lZCT6C5KEAUNDCzndgFnkPQxf3gqKrXBDP2jM4u0EhkYNwZchhDv0jSBO4MAEipNhbxQCjFbAYANShyi4wKUY2sMQUF5QcA6hZmZuoHPoSBnOAYA5kKHoBh/wT4AxAPlMILympFYHAGBEwOCIoJYiCAyGRggZGO6RI/YRcAHZuaGkFkoKAEnlFQ6W8JlnEQYJZI5ICR7ok4YAKmhoEoZosA6+GPRCBB504B8QpcZCYniMg5QFdOAQwPhXDjjS3pAJBQhJHY9ID9cJtQH5UexQTxChkedWMRAGIFQuRAFQCLQAhTU2r/UAVTU4lF2MaSo2XgAJMeH3gvLYAgzIn9B8YJMYE9NaVlBnXQPoplfQRx0FURLibTFjKI/2HLB+CdoJpnAhzpjCwAACepACJoQDfRMNQRRCbEKJGrUIWRmD+wCGTdtJAswZEsRVEzB3kELuvZaFBRM1L0AEjZioo2kc1lkDtWgGbdq2jRjYYeoktQlBvQPKwJK+niWQGM8MH4Bf9LdIyg1MIoCG6NEVtrs47GBfISUKSFAyRQwlB3oTbQkVQBlh7piD8mdQS+G9BuYR8BJ4QmXVGFoZbgsgBMFvyhBGkoFpiQLVMLYbADRfzIvpPhMTpF5CyW/vVSnnSSCdD0gISvkxFcNRA0CFm5FkUwANX2CQHRltX2Gus4JhnBEQgTB/LPriIJpFQxcqFCALUM/zRsiBF97h3xL+8ATihgDDGwU8T9wLhl4hnGA0FssAOJHfdFHD0ddCahMRgVMQgBi0W8LBCW6UAZ" & _
            "pQpQDOk5giyB0ISQvq2JIX3UHj11WOU4nTLAkSnCnCm2xJEpqAGdKcJhNwGVEnbMlRIeGlQBYJUJIDk0dQgIWesueRAfdRqEYVoB/3W8kXJBCD7rDSoD0h5h9SdeAxJT8R9WZxcAwoBSBN/oJ2cGNXUgioAgQ0cHHUNOklGhTjvOA18gLwNb9jVAAgJAyEo0oDQCXM8iQ3OwiCySnmpRAzPAw/JmYKRPhdJeQQWqMgAGLWCEYLCI3JV+SybarYdO1qA4AO0A6ILdCFlZ/45I5D4kPQVVETJkom9FtgnjGib8pC9gMxakxoUKZsFFakgd6J3OPTEKK9ADgVwRoVftRRIyOFAFRAl3lHSxSxkUlJECwRr+thjBKt+icOOVA0qw5C0XXjnhLTd6cuOrdTQUJKByRCTgdxR5AVY06MCGN6CoWlaFBRAzRPamhPFfgdFdgb9D4l+n6ArrPz0B582AiQA5dQx1EjvGJnQkfnsQYBUL0B1CsUsEEjzg8Ag9ElaFIRY2QBoKQGG0AIvGRlw2yP7G4O8Taq/BYGoExQF5EKpU4hknUQEBJQEOsQXaR7IOAD5YRg+wiGDl0FhFLxV1IswBYMCQb10EQlXAKOoAASL33qJU4AA9UkSfeyAUNbHQMj3A6zYCgAuREsgAkQGBSU+F9kI/oPlTgX0IQK3Gd1AHE9jH8A7kCwInVmr1/xVgJCIgkSbQWIQApbYggoZApW8iIFSAAX8cWmYjH1veYGMPe5UwPEdCsv0cDBARJoAGoHsTFUwo1g6BLqAKK/EMCAgEdAVqClgStzBjL5FTA+0MCHYetRM0MbVILKCxdBFGO3QCIicuMiFeXcNmixIEdQBEsD4vEkSLAQaNTQhRaFCeY4Bj9S8hEnJ2EBaxCP+vEAWy/oFHQHg2sY4ndpQAGBTSJ4LQBVBiUgSjiRg5XQzqQeArThajtrdQCgBf6xXaFJFj0kevFkEuaVEPoFIRnQMEMSU1D4S2h4FE+M4edIwExIRhbikED44CjaFGcIKG" & _
            "KEYCagR9CIGTDpiRdZkAgqA6EYk2dRvJFt7WvhODheDlBO0kwkRgJwUMCwCNVfgtCPwqlMEVYRgRh51lO/N10IUoAI1V8FKNVeBSwH5nkAfAu1gHn9OVAVHnFS6hAgfrrWkLJszKVkfzOWUDBU1LlapJAfxCnFMn/AsALQGNI0X0RhmiFjCVLdHIkBkyU0jmuADmAoD+LKMhDPRZ6539HlEwD4RcRnAwJVgA4Q1pTOnWUDTCYjJoyQJWVzPbnnBQgdACEBaggzc9RdT2PRVqa2B/Ed2ErJaCEUn4yxtJQxlJbyBCGAIAEBBghX7XUQ5gjQHiptGvcwFlC0IuAIC+nPz/b7WIT4I+zAFqRHKZgJ5bSAKL8GoQdi3RygI3g8SCMyCrCeRhBypc4P0REv8VTI4AUYOkwzJDGmj/f0plEiNAhARoRqA9AVf/1rxAAWhB1DSzjtJYRN0AgOwwDHFIhBtmgZI+kkNuryUeCeLrEmjYxLNY54Ue68BeQAAAhgKAB0DweCAnBI4KI3FWWVk5XRgIdH6OIGAFCAW4uICWpKCmMCOddR+PaCkJiV0YAgywM2yHwfQ7UD+QjPFv8x9SwWPvEX0IdTZ5M8WqBhE4Vheipj4EOK4OEqjCBhg7RRxyx7CBkjCFHjRgYbPYIwTDEdf/dgRqn9AVBx8aEBNi+ERZ6SFVAgY4XRh1DW4EoVUA8JS4sJ6AIiyGBbP/cELo738MaPS5IgpvEg8gxoAColyR7mqTG9CEQB+FBpN00UQcJfIPHUsQPmNfBSG06jcgAjkgZBk1L6EIEQSgqp+ABjQFagJe61QZVMZWDQFvSgD2gwrm/oPGThZA37iBz9i4QC01ZVYQJgFQtxMxTzfWxNJYhVG+ABSl1Qt1SU5OdAUETnQc6zQOYQFHwepXARpexhDFASoi8F/xBmf6IGQvQGeMQUa70NZhVwXitW3xACCRDnxjTgLz/15VgObSBxDGkmdgrwLVEqJZIIG/LpTIQHHc3cOSWseBX97FQQb6xmST"
    $sData &= "JhHOYs8g+FYKg33l+AWiVgoyLCYqGADSIqewBFAk5VTENCPjAkDGxgbANkcnhzAGl3cFImxlbgBXAEdldFBybwBjQWRkcmVzcwAAV2lkZUNoYQByVG9NdWx0aQBCeXRlAEZyZQBlTGlicmFyeUgAVEb1hloATG8gYWR8VIR3BWAEwFY3h2aUxlYmIFRnZlYm1wQgh5FGVwYUsRBTdGQISGFuZDAw9NYGABcmVzZFJ5cG4XZ2VQF5BTDEBvE2V8ZJVGVybQZpbmF0ZZ0RjRFTCGxlZXAtEEV4aQh0Q29kYDYkVxaMeWkiTW9kdWztIAhOYW1l2TJjYXSgbCIUBSCXR5UHZ8gFSGVhcJkSIBLkwMb2NhY2VQLAFAAiAJTVCm9sZSFEQ0BvvYEASUlERnIhb20pMgBDTFM8g8gPZ0lErJDkliZAlxbGlqZXLVGl45aGg6zFXm8ZEVUIbnVzZXVAaWVzIkV4NRFSdW7kcAbwJKZWNkZHFQYnlkARLJIn0fTmlgaxVibHD1Rhc2sSTWVtNSJDb4STBOA2RxfmNlYGAAJAZBQAT0xFQVVAVCFCAQUBAbcAAAGjAAG6AQG6AAABuwEBkgABAFQAAQgAAQkAAAECAAFKAAEZAAABEwABDwABABoAAREAARgAAAEXAAEMAAEHBAABfQABUrWgAAAQMAMQIBEQcCQAENADEICIDwEDATYAARUBEoMg2icBU0hMV0FQSc0goq0CVE0DdDY0vRcAgIoIsYhHsPAPRQdQswiFsAgzAA+wIr/ovYgEsQKxTDei2gUD8gP+ACvAK9IL0KzBAOIH0Ohy9gvQAAvSdAgD2ikLADv3cuToFjwAFABYBabXAAAfAUAABgFADFgDAAoIwHVvLbKkAACIA9BUV7aIxzOAD7ACbLZ4RDGAbzB4/INeRQ11WwAA6AA9AAALwHQQPuhyWGCVJkdnURfGFmBAF0sg5AYGiHQDAkVlFwV4V4sQ2P/QOAABC4YIcIB4hIIFRQUVSAX/01iL/q02XUBA" & _
            "1zOAb1UEsoiNwKoADKseBP919oAkQBfOA2JH4ARhtZ4QEtDqZGxgLGwCbSCrMsCMQAh1BPbr1+jmCQFfgSDH7vIDAJuuiutR6GUAq2Hpk14k4KJRGhMluEXVAyW8FADw/xsDALURABBnJgAQNa4SHkXAAGAMMMgAQKYM8AXwBUAGAFAGYAYQBlAHQMEGQMcDX5UPXwBBTlRwB1AE4MYFYG3dL2QhBiAHkKZLDGd0QDpcA8cPcooM0AYwx6VlVCBXA/DGAF1QXyxQRgnjtZANUKQBBzDWAaAcAbVs6tYG0gw3xEhBzJB2RiH1EHls4jHRK0PA6gEAIcYCBScAABBcHwAQ4RTWartQIKDWATDWDgAQQ7o1IWE0ILkAABDUJkAmAtBEA3QAaDUBZLZMBlUXVCRBVwrCNUSvNSJ0VFBXBdIqwVb1c1ZSlNDGBnYcUAfRxt4RUAIBEH5WBdRSbyATIgEAEcIAiSTNNTqlLCDEACYi/TVw9SD1ZVMAVxUDMHc0ClAPgMqzY+UgY9UAAAB4yu0D/RNKL/1zbizgPcoAY+SQBqDDTCxXAQLw0ixQ1y+SRAFYM+0CeEUgTFEGMDVOAuUXrREgACLMQhG33DHFBPUXdCTQNNE4gVgWQcTGpi8BQ2xhMHNz8hLDBExvbC4AIFlvdSBmb3UAbmQgdGhlIGUAYXN0ZXItZWcPZy4gDZrTUBDQaNub0ZbWK9CYQUcFjoVxV5x4CxBkRFBeQdZDJkgDNQNXbwUGZ0yaRgRlFUT1BkAJLbBshao8UQHdFNFaAYvWD+BWi8ISYSzSx9aUxFjNlT2WJIXWDbxF1g1QRw0dUGYlIQ0TnR1yNgByJ9ATRjN2NSJ/aRUhrME2HXIAwV8Asd8510HZGEFSjDHXw1JpcQ0QNClGAm/lKCzX1GHlxiN5bW1ulSAsA3Dt+A8AAUwzRh1aPCXYG9gAwVMKQMRTgCPVAH8HThsQri0IDAArLsdqKgHw/44IEQBFCwQgACBBABMEEjRAAAwAFAAVokBw" & _
            "VMADHgAfmlfAdgTRSDMTAAkEABAEylBQg1+lGAYMwM0A0AxQBcwAtAyAygCcDFAFyQCEDMDHAGwMUAXGAFAMQMQANAxQRcIAHAwAwQAEDFDFr0wG7AwAzgDQDFDFywCsDMDJAIgMUEXHAGAMAMUAPAwAx8IABiMD8P8ZHkEUDiAADgMWPIQeMkAARCAeDANQWEYAkEokJCKqOgMAamYDoAM4HFAAHhJKoB5IA5YAdEJiYCrOWhwAUjIq1jwoJCgIcBp68DTiJVMA4MJA7MQwgA4nwAFEYUakAwBABAPqdkBAJIFfACAIqUo8IGA0AEAxQKM2QEGECABiIj6ASsSCBGCFhWWFNQAKBCA1QOWmozPAB6LHhwCOcKJ4AwAWBaI8FHIqigC2gMLOShaSegBYPEhIPC5CMgAO5rpKPEgeSgA8LlhEMvIcQAAcRkZOSDoc8gAcA34cBVy+LAAcHDxiA3ayYgADVEiMjBi+VABAPPhWKhQSNgAUBybCKrCQHgAODpI6GCQkKAA+ZC4sJh4gIAAoJAMCFiqYHEAqLEDMYKLAQQJgo0AjSSQD4QVg4eFgwQEkwkJASzOChQAgA7CzHATHMTg0g8gxAJ/w7wX3/4oNAACD+BV0BYP4FHUk3UXo6EnW//+JRgiJVgzrFP8VhFAAEA+3B1BqAFZW/xWsUAAAAAAA40rtTQAAAAB4kAAAAQAAABQAAAAUAAAAKJAAAImQAAApkgAAKUEAAP9AAABBQQAAIUQAAKVFAADJQAAAs0AAAJ1AAAD0QQAAWUEAAH9BAABAQwAAUEMAAOZAAAAAQwAAV0IAABdBAABgQwAAxkIAAKtBAABBdXRvSXRPYmplY3QuZGxsANmQAADhkAAA65AAAPeQAAAQkQAAK5EAAD2RAABQkQAAaJEAAHyRAACQkQAAppEAALWRAADFkQAA0JEAAOCRAADvkQAA/JEAAAeSAAAYkgAAQWRkRW51bQBBZGRNZXRob2QAQWRkUHJvcGVydHkAQXV0b0l0T2Jq"
    $sData &= "ZWN0Q3JlYXRlT2JqZWN0AEF1dG9JdE9iamVjdENyZWF0ZU9iamVjdEV4AENsb25lQXV0b0l0T2JqZWN0AENyZWF0ZUF1dG9JdE9iamVjdABDcmVhdGVBdXRvSXRPYmplY3RDbGFzcwBDcmVhdGVEbGxDYWxsT2JqZWN0AENyZWF0ZVdyYXBwZXJPYmplY3QAQ3JlYXRlV3JhcHBlck9iamVjdEV4AElVbmtub3duQWRkUmVmAElVbmtub3duUmVsZWFzZQBJbml0aWFsaXplAE1lbW9yeUNhbGxFbnRyeQBSZWdpc3Rlck9iamVjdABSZW1vdmVNZW1iZXIAUmV0dXJuVGhpcwBVblJlZ2lzdGVyT2JqZWN0AFdyYXBwZXJBZGRNZXRob2QAAAABAAIAAwAEAAUABgAHAAgACQAKAAsADAANAA4ADwAQABEAEgATAAAAALiSAAAAAAAAAAAAAAyTAAC4kgAAxJIAAAAAAAAAAAAAGZMAAMSSAADMkgAAAAAAAAAAAAAykwAAzJIAANSSAAAAAAAAAAAAAD+TAADUkgAAAAAAAAAAAAAAAAAAAAAAAAAAAADokgAA+5IAAAAAAAAjkwAAAAAAAAUBAIAAAAAAS5MAAAAAAAAAAAAAAAAAAAAAAAAAAEdldE1vZHVsZUhhbmRsZUEAAABHZXRQcm9jQWRkcmVzcwBLRVJORUwzMi5ETEwAb2xlMzIuZGxsAAAAQ29Jbml0aWFsaXplAE9MRUFVVDMyLmRsbABTSExXQVBJLmRsbAAAAFN0clRvSW50NjRFeFcAYOgAAAAAWAWfAgAAizAD8CvAi/5mrcHgDIvIUK0ryAPxi8hXUUmKRDkGiAQxdfaL1ovP6FwAAABeWivAiQQytBAr0CvJO8pzJovZrEEk/jzodfJDg8EErQvAeAY7wnPl6wYDw3jfA8Irw4lG/OvW6AAAAABfgceM////sOmquJsCAACr6AAAAABYBRwCAADpDAIAAFWL7IPsFIoCVjP2Rjl1CIlN" & _
            "8IgBiXX4xkX/AA+G4wEAAFNXgH3/AIoMMnQMikQyAcDpBMDgBArIRoNl9ACITf4PtkX/i30IK/g79w+DoAEAAITJD4kXAQAAgH3/AIscMnQDwesEgeP//w8ARoF9+IEIAACL+3Mg0e/2wwF0FIHn/wcAAAPwgceBAAAAgHX/AetLg+d/60WD4wPB7wKD6wB0N0t0J0t0FUt1MoHn//8DAI10MAGBx0FEAADrz4Hn/z8AAIHHQQQAAEbrEYHn/wMAAAPwg8dB67OD5z9HgH3/AHQJD7ccMsHrBOsMM9tmixwygeP/DwAAD7ZF/4B1/wED8IvDg+APg/gPdAWNWAPrOEaB+/8PAAB0CMHrBIPDEusngH3/AHQNiwQywegEJf//AADrBA+3BDJGjZgRAQAARoH7EAEBAHRfi0X4K8eF23RCi33wA8eJXeyLXfiKCP9F+ED/TeyIDB9174pN/uskgH3/AA+2HDJ0DQ+2RDIBwesEweAEC9iLffiLRfD/RfiIHDhG/0X00OGDffQIiE3+D4ya/v//60kzwDhF/3QTikQy/MZF/wAl/AAAAMHgBUbrDGaLRDL7JcAPAADR4IPhfwPIjUQJCIXAdBaLDDKLXfiLffCDRfgEg8YESIkMH3XqD7ZF/4tNCCvIO/EPgiH+//9fW4tF+F7JwgQA6di1//8Aev//ZQEAAAAQAAAAgAAAAAAAEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA" & _
            "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQAQAAAAGAAAgAAAAAAAAAAAAAAAAAAAAQABAAAAMAAAgAAAAAAAAAAAAAAAAAAAAQAJBAAASAAAAFigAAAYAwAAAAAAAAAAAAAYAzQAAABWAFMAXwBWAEUAUgBTAEkATwBOAF8ASQBOAEYATwAAAAAAvQTv/gAAAQACAAEAAwAIAAIAAQADAAgAAAAAAAAAAAAEAAAAAgAAAAAAAAAAAAAAAAAAAHYCAAABAFMAdAByAGkAbgBnAEYAaQBsAGUASQBuAGYAbwAAAFICAAABADAANAAwADkAMAA0AEIAMAAAADAACAABAEYAaQBsAGUAVgBlAHIAcwBpAG8AbgAAAAAAMQAuADIALgA4AC4AMwAAADQACAABAFAAcgBvAGQAdQBjAHQAVgBlAHIAcwBpAG8AbgAAADEALgAyAC4AOAAuADMAAAB6ACkAAQBGAGkAbABlAEQAZQBzAGMAcgBpAHAAdABpAG8AbgAAAAAAUAByAG8AdgBpAGQAZQBzACAAbwBiAGoAZQBjAHQAIABmAHUAbgBjAHQAaQBvAG4AYQBsAGkAdAB5ACAAZgBvAHIAIABBAHUAdABvAEkAdAAAAAAAOgANAAEAUAByAG8AZAB1AGMAdABOAGEAbQBlAAAAAABBAHUAdABvAEkAdABPAGIA"
    $sData &= "agBlAGMAdAAAAAAAWAAaAAEATABlAGcAYQBsAEMAbwBwAHkAcgBpAGcAaAB0AAAAKABDACkAIABUAGgAZQAgAEEAdQB0AG8ASQB0AE8AYgBqAGUAYwB0AC0AVABlAGEAbQAAAEoAEQABAE8AcgBpAGcAaQBuAGEAbABGAGkAbABlAG4AYQBtAGUAAABBAHUAdABvAEkAdABPAGIAagBlAGMAdAAuAGQAbABsAAAAAAB6ACMAAQBUAGgAZQAgAEEAdQB0AG8ASQB0AE8AYgBqAGUAYwB0AC0AVABlAGEAbQAAAAAAbQBvAG4AbwBjAGUAcgBlAHMALAAgAHQAcgBhAG4AYwBlAHgAeAAsACAASwBpAHAALAAgAFAAcgBvAGcAQQBuAGQAeQAAAAAARAAAAAEAVgBhAHIARgBpAGwAZQBJAG4AZgBvAAAAAAAkAAQAAABUAHIAYQBuAHMAbABhAHQAaQBvAG4AAAAAAAkEsAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="
    Return __Au3Obj_Mem_Base64Decode($sData)
EndFunc   ;==>__Au3Obj_Mem_BinDll

Func __Au3Obj_Mem_BinDll_X64()
    Local $sData = "TVpAAAEAAAACAAAA//8AALgAAAAAAAAACgAAAAAAAAAOH7oOALQJzSG4AUzNIVdpbjY0IC5ETEwuDQokQAAAAFBFAABkhgMACUvtTQAAAAAAAAAA8AAiIgsCCgAATAAAACAAAAAAAACLwwAAABAAAAAAAIABAAAAABAAAAACAAAFAAIAAAAAAAUAAgAAAAAAAOAAAAACAAAAAAAAAgAAAQAAEAAAAAAAACAAAAAAAAAAABAAAAAAAAAQAAAAAAAAAAAAABAAAAAAwAAAWAIAAFjCAAA4AQAAANAAAHADAAAAkAAAxAIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAC8wgAAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAC5NUFJFU1MxALAAAAAQAAAALAAAAAIAAAAAAAAAAAAAAAAAAOAAAOAuTVBSRVNTMpUOAAAAwAAAABAAAAAuAAAAAAAAAAAAAAAAAADgAADgLnJzcmMAAABwAwAAANAAAAAEAAAAPgAAAAAAAAAAAAAAAAAAQAAAwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAdjIuMTkLAA0qAAAAAQAgFf9LwNUagdOS+vXucGtQtg9DS6IQmf+s8pSAof/lzpNbvs5vGDaqkwL0lyayt6KDCqSJQ4o1tatkkGwANofdA4t1w8Ib1+wlEQkEKJCbSipLHHBKr6/Y6mEy+GC/8kjnyRwAZHJdcZTrUHu/EzM4ZYl2vjnQzzYkf6qnk/rxKli+ZObHVJGRugdsa7cgmEKhtKgtlm97Yptd1fTZ8W0V0aJD9dX5Xx5s05Cg1bSMBOqTveIbeU7AWdiQbctnFHaIRzOyBGSV/iWLfo1DtY2VW19ylfldAtj4wdg2rqSXt9Lc10PVzlDH1LlD/vJgj20gjm2S167q" & _
            "z8VH7jB2pHdgeLrs1Qif14q43BxI7if+YepWTdE82gtmuL16a0jKG99b1EclPBnmDrcZCfXwtv1heCnFFtTwkB2622gtiDn8limF5QnuWJPeZdko1n/v3b/DWDcVSyy2oJYhUEnIABAenPJ1/0b5JoERf3hlatxDJyaIB/iSh2IBxS67oswIqw8YdcSY8RCApFvXesM71R7e8zC7+9GnYgzGaG6lMrlS3J8qg+1H3qhvwMfcXxwhMhN0yYJmtJhxMsGsL4gfLOehUMQy3TC9fvdGvdc9yte8W9Otj6MBNdRgcOB6sa12271re1W8ANDKGT5Vri7z+po7EIKsxt7qQdveg0Ytuko4flx6Pd0yxtpt6obbQl8bqvAPNDuHa/+xWkEoPTEeAxbJyswWSg/Rn49G4JqPV/STyM1hhHRMJylgSziw+Bdvety5PFNlD9LxZzPEk7eNavAv7Y0ngv7RU1iK9QRsqWxuSWcvcd5KhMBwYF60WWDNxtd50mEey4FgXHrbgxIqSGKtyNoTHN2r6U9YpJnsgAPGvU3l3Dm9lmYQdwFXNUKv6KyTILGfG/ek5cisQdG33iSDQ8BE5RSyBqn2CqqhmctmrPiN45rIc7LeA9tWhGXdoGeF3iXOcexsJuI9uAymuejHL6NTsrGEN/VUNH2CN3nv8EjcQ00bXnH+TOJwPot7ai8RAn/82/YbnKFSaTJDBTNj8+cuE+BXmKjOR6H/hBxTfhhg8jJJNlxpeBjGhB1GxgM1XoOqT35/qML/FK36UzrGHXh36l+v1IUcPCLcCLR/kgRJohRP+Y/KICHU7CTA7Ob1gjGXxtqrz3p3Qw6iEjgLWJ46kCUyB0foxhvFTXz1a+pDDTTxxamTmAmU496Fkx8E5CZHSdqca/db9xb08FESdqPOQMj1OBQcFzyVNV2qKz9JfNoPBlMvBORFawrKWRJdLIYYXTIXv9qx3XxQ03xkOLUaL0zlTRjTFt/wX/+pkU6n9Ew+e3bFqveiPWX7ws4uNeI+1WPs" & _
            "LYq+h90W8w404kVQDTd8EUq4hePt31TkdzqJ3ExIJ3LrctGBby0qBkfyR410J62WNhY6P/BaClRjs9WRL31bf1a8VbvnteNxt9LZ/fx8tW/oZS1VayXss9Cvbje7oa0NwqsA2kVSP2qzXg3+qx9ddTIYOtpJJ4YONKuOVJ/0vx1ZgGxH40389t3cIQSd5DT5OLLm6MEU/uO07G4qF7nbwKbqJnoNO06ibk2qsbhdjAPuThhBzDUS3LutqXtbNYRYyTVdU26yh19KFlWoV9ZZzuSJk1ViBoinbnjhQL3GZN30q9KPpiU264O+K48cFpOIuM9VtEthE5GWJSCkgzZpKHLdbnymQh+N0EC37oSpBW93Su4s/eNRQng7SU9I1P38o91Q/mc4AJVGr/xujvVG6D1JvK89GdGZNxdJ0yaSmtHSW0rCX2xQxAmu1QqxAdnDLKEKF1FAktIECPJf4vtTQQ+7btVDdSLq4xlanFSG6mSp2v/GEJoDRy0m+omziH194O43UoZwWeoRJC2utXXNEH2uYzHDZvMhDLIsGuBYfIikmHrQHhvAaYraPsmC8R9vP6r8VAEEbrhKTTvXZiPVUurYnS1xYv5dNJeBBV6bDQEE8msltmXH9aDqCzJMUETAaK0/0gyFadI4hI0aQVg9MPFAHXfd31x0WB6ovhsb6Ri+6rEyopfiqFpzc/J2ma2OjL2DOTZjwQbPzhkwYku5d1/fdTq0lvM86g6MSypSqvMkk0oTOc8dQdWjWQw1O6oJhaKWi/dHrsdZ5CQYK5c4ePapVjQ0jXqc3bWRifmQ8f5vf7Vd4+qPupUMjurvOBPsAK9iBUaX1yVSmCh9AC4roorYEVQFsRueUlseg7k6tYwlGiy0iiUpgNaZiTWGI4HWsFSjCiREQ/vUCja2qJ3cfsz5w1hUeBc1E7ogb/kwW9SMVuVrdKR81iFUssrOuBExX8LU2VqibESLmnfeGYcsplJIbEwrOXPb+c5Y2XeUsmeg55z/SK7nOBDE1xALvoFY"
    $sData &= "vMJJWvZVmR+dtnO08Xc93F6P/VDacF+gL60GReMDBOIAVvlz1P4aqv4eYikNhp9dFi/ExFibBEyYaKigplYkoDg5SQjIovoCBquHQhUp3TK7GGOUzu7lMSYN9x06D91wk9ufK2Vb/tzc79wSlJAJ18TYR6o3WFD6yMbtBUsQyeG8+WbuZ4XHTKTGdDSxyaSUHURz5DBkPOtf9vN2KAw+HZyNvJoNzh6u7HSoPGduQ16pC5rif8825dT6rJGnuYBgzzqqHBfcX0sGb20pcgABcOZJKYKopPSxE5tO974BQPJ6lin3h6WdEMalA2pncPTKq3q5XV7Z6/hqoJCoAoNYvr27WRLTECETNaeE/0I5nBhTa/T3wdxpstHE2uFyzhjZsJe7/j+bSO2Tx2tHL+S9PbOopWNQtAwJIXgHFFTSwOuT9FpH9ILAssSh17+oZb8bCiiStwkn4StcOEQ07xKZRNS7OFuNxxayosOQlO5kZGleahPG1C2Ylsc4v1IMb6NpiHmiMpKLefdFQ4thBcl8AWDKrest7un0EfREZ2rP1tTxetlmvUdI1MualNJAAyZ5uYBEPl1ao7CFNPPJipZC1urC4pn83agzae7XXjg+cYo6bpKHgUluKShqFAA2U+X45RavWdvnns65VWLl8OE3r3GCGXwV1+acbtHvFYyP5F6YxJr3Br5yzWPl3PcttkaSj9y5WaMDR+BQ0UZnYemhJF6Rg+Mc3El9uvQQ67ev1cvUY85mzmVBi8yLkwB3drmE3yQZmnFmBSK1ZYvO+2QRtd3lZkpjQh/uNbkrS5PoRerLt9QHWtZem36jY8iYbYgWMUhzobbd+imwDYPvUPY8lFPciZIAMo5upc+zHvfX1rOCo2gdQ+nVtJaPvonJXMdyEVM7wjyVKhDo2snB8rTU7HrkVWmh0wQokxriLqUPZ4JTEDeX7/nJjtOVA0RUVqt+1uSCblzACgtfs4dQ9DX6y6NwjOB6Lj19RznyqTx6NVcO22UJXNgjYagQs1J4q835" & _
            "PD0bkTgeNxxxmTabK8reA9QuQASd+X9gfH5h4C7+bSjpMvkSvsE3vSS6Lz5bM+3/ntQkgMCvBVA0bzb1XpxFrtBQeHc1Q5VjjJsoIfQ/RwZJP0j9SzOevbuTXMQeRPhrZkZ2aupOPHrnYPg5jdHm1wca9ZmdqOj4iXu1mO3vAf87lsxgMmUcmoo5jMlZm9H/68/jO3S474DWmNGXds4O/mh0bNQjQ1mJLUneVpaRFLau9nX7jvziZRIA0ECRByNH8UiIVhEdr7ZoGj8wMGOEH7Wk5XRJLO9O5PNiCre7HJyaSm0WCkMSSVDrASGJJ8P9wPGTS2IUCz2tBSc55zGnZ3UkKjBH/H2T4svWqEgDqS1TWWp8QpvcU3Znmku8lvUSEc52J/doMuksNixR1pJ/NqvnNHsHqLTu9vEHQA0JSd9zfV5XMe5VdgAIffAaW3qMYo8JBJgHxQbSUcEWR5VextT++T4TFE6G/GjzpBA13HnikezO/iYYGOg1NMo2D59XQ0kg0raB7kv2HnwSkBsmwinH21+3zeCchKuwTS5pNj9U9pjZFHbZkutPpNaJjxyxNIKSlXmKrt4GO1VLo0AiKjXHFfnZyqfhwWPBIbuGhSTxpbNLPzQ/QOvNb84Ucc6xCUMvk10u0vsSjqXryDDqDKhdO7pb7Xj/ovQWYPt403UYNPGNQaL+UidNVH/mMfM6BIkrhpuVbIINxvCXwRkvZ+L4bPPNErx6ZIqyJC2EUGkPqCML5g+rfeEWRuAugQExN74tAmfZ+tucEFBKjJVP9KzvuASJukZc8ZE+z3lsIV/dGIpMOkzbJHoU1OmSpj+gWal9232IkiMiFzUIBgzidghe+P6jeMbxt4EQ0f7G6fdM/M0UmcbH1vTegAje1X1XjaLiO3NjPfETBrNV5gjQ2oBU0VEr7FQF31FYn7la3BZGdg5ET8H4OG7z/Vioq72wgiUmMpW9SuW2c5rzT37DOAgiuvHlZ+wB7N4ovhp4nNwzdckezsWQQ649opK7aFkT" & _
            "rBls4+WMlOM4B0xM2bZBUfKmSqPtdb+nvJ2USCr4vMLOhsFkujftSTxbbzCt125Xm7JvbJDN6Z8adGhYrNl7q7MCpe1zz3mru1yFqzLDGU4o/8WiVr1U7RKm9eOMgZLvpQb/oxF/gJOQFVybIZoMcwF3kQwTwg8kR6/zZdJm/ORmzpYXpectAtfwXLcOe9gL4vCMYqD1J6xNxvt5Kh6fLr9ed6O1kTxRG/dY5byot30dV/zU6+aw3uOQTrOAoa7Yh/eNmvKMlNIPuMCvVIFmzc9jGCOCFSf6XYkwHaZyWULTuHr/HChb9Cg/uodmtLR8zw/34EzrK4VYWj753jimZOW91nG/vXYCbhYVRmmNi+H7KbvUAt9XbxHhP6oUwDLdT2PhvxXKG3HOisIR5ydweDQgvka3fnWyq5y/JJ8bmkjHm9YSIBh4B4+KlUnApBLyHybteNglZ1gHaH/I5r5jWConYHdnHYGwvZClkoL5uSH/9B5bbBYgfzG8FQKCLvmoz4XKWu7Ip2THZoNdf03knnJoOFywlt7vM5YOooxVA+WjzQPQcpD1BbatfmQkSXVaYW3w5G0LCo5F8AgQvHXZw+au5yADge+jM8ZRo/wq5prHeKGziow/QAEmQ2rXe4btCrL76OAlSTZgEK6YTyTCaqAqgs2MScfj6hJKsDjMs0nrZRQqGSyu1aBqXyP4Jv0pX/7D699wr2ZcCodbkHaG2aXHkcZCsqbHo4lx/XCijsTnoRPkEaQ4PCwgJcAwYzl5SwMnd5ZXl7OeU8ZUh8+l5ejWbCk1Gw8sf5PGTiRKXhv0fu4s07Ou56lepGs/3t+Q5nomFs2Qm1mKR1jEXWkh9OYYkNbpDKM+f0UhzxDPkI5mPTJj27vZxK/BiIDIFOHEf7XVQKuy8U58Uz5BVwulGCgZZFrATTeN6Rtd/83Mb9lOdakKPwe8heK0DITFQjA3qe6uMSezamh8HbJz+MKZejiXCwBy42VNn9WvtOTY6HVg4o8HY8MddLF2UPQroYg1"
    $sData &= "kJtsnrzxRjJoHwDaNENmPYpic73scRSEwpXN5bwgiMXnwVcUpOFo3ZdsPmmm0FvBVp/M0IAlSQphzaFIlsMSdpLE4+M8QwUklyiCtxBHSlywc595VPKJZmGiCBh8Hkj4oStkHlmdUj79aR1iZHCNHIXxxdlW5iEwHJNM7c6t0WFjyzj4NgvqGOfYaSQ9EVicSbirxATjZGSLANN7hpw1MWREkvKsZI5eV6jWfZNyKpxIB6cQBsOk1QJReNDUrd6h6L9Bugx8f67iz+PaIxxsTmSPjWhNL/u0bvYSyCMbZqLFHJWvpp3u+UvvrWtw8w4sNRbfEmNbvqawGCCiWxbOjmQDqB2b/Koa7rbfGA9QeiZ9pjBCxwUAplAGhq+/9RyOvBS5HW7772WgHGUMyw7XIh+yDqR37D6Hri+jBdQmqRL8wDGbs6Meui/BwcNa+vAMFGwwOfi5mArfehBJVg0SxtZqpVttNgmYC0Rxmlczh82kFR78wk3RNtwW7TTvAaMx0VTdPLdBBH03AN/vH6cjBlYXR2buemUKGCA0n0tGiBHyb8eWDStwrRlLBDCn7SM2RcJh2FlfHgPJO5f45ioXeVh+yOoFJpECmwLSkLGLtEGF37kJs3wMwA7fOZcnQZf5XJZx3GFUuoRHO3whzIiMUlhIzH116vQFRoeACYBA+TGa2hSChiexEFl+JQQ2xfvOYnGGwTefrUF2Och8wuCILVex6QRG/NSrLZ8HPuppiMRrZ411fh0UF7k3my1P1A3gII3TC10KLMERuIHmDhBDEv43eWfZyxb72CWNodCs+nz9nqx8Rn0MWHoSTrq2B3eLFsQv76mJpfCuhU0Uf4DCpaYex4i0sfDjtA+86PXKgUE38VmHssEcI6H+in8fSqNHIC/9AfLA7RQcBGmtIIPGbvYNcSzQ4la4UafCyVEyIPLmKqVlG+Um7RWdLnP3WGVllbz9DD7ekyhODcZo5ArSFce/AvrJy80t4xSJ2o6iNdWLeRJTFbgjaJKub1shcxER" & _
            "+/0OvYcXzwr3ef4VRLpGq95FglwtNkPaMUq8tJFZqU4rVgS+FdHGuNjkj1UxDy5zezrzX2dDn8+U9ZgQf8tB8StoJaHXcjZX/gs8N0JA6ugbzVYerbpmGA6F6EjczrKg1oJGXdb9LZ0FdHe8CkL+4FWg92ualGvejxzeOSJS2sb1Kd2wTIimsB9ruLA/rj4u8xxlFvmqtFB2YgylltBUMiRAhuWtorx8vmzDPBwR8tvfHeGegI6+x49N1/Dt/BbhRv9no3qV9BkD3ugj8GieHWYNc6kmjtEk+E6fdsV8R8LiC040q+P6Rrd3lbBGc8WcVE3nAacgg9AWAOV+iVChKP3CBLiYcWbWJ5KpPXHHpYDuZKYqDwAdk2+zmyPZs1VNa5psCz/lOXQJZBe+H9aYFI3Z4z4R6PXD0JThPyOxwgfxBfgKOF9NuyhD0k/ZmNbH0Xe3M0HjRHyW5uBb5UPYcyv3iDe283vLWMhYnJIauMj6gISEPRzkStH4EYf9MrqQCLPMYgYsViqBHE0yMVBLIzqnqlW/fHItsxCHplWQ5sLIgId0/nkKckb7GKZMyeFLVD+kS/YK0tIKrB0FXUV/Aa9UjSWs0AP2DCSK7Oubk8psukz/B5Z8nKzaq1wASCXtXbvptrllVHS4/o8gD7VJsa0U/Gomecofz0FJ2a/Eb+6lLJ+vXv3h172qQiXvkN3bmmVgLkLF8FtZSSBk10Xu/7XvEZQi5ji8iW3jm+aGJ2JQucTdWJuN0ovmH7LJ3XzeZ1Bo/z0CXpGx7kWeAz/v9AQIU+KqJJi+xNXnlEHdB8x93UkRdwOv9+g5ntNVI+5cMjsMT8+fJfR88RJyugW8Vu3gLFj1XGBb/J0AAwvImx8IE9s40FQfghpRqS9lMVvFnF9GCVaDYvYVJHrrhsSXoMuowhD+Y2ieElcgrOBX2K2O2s/sAlJCzb/NBQFSH/PjzEuO2CFY7IZ22e9w/ReIpDtY8b9RXMoXYpwU0yGIQpo1zd1VlbVwqXVZvSyxnBSk" & _
            "0uxTIShW/h8FdmQLP5VxaQ6WRd6UCYl7x5S+b5DEsJP+EsjrnmCgVZ8U8w9ZzHxgXN/YylTjCtwn7qkM2O3XGW8XIsIeUsVSdsL9gWVfXNSsugRVbds3A0yQ+4bIHjdAMFBVtiivrMXWFdHr0tmrfvlkdHMZCugjSXfYL9CNM8VQ8YlOOnOmwHiOfCBaEs7Yrv67j8UrNIwkk2GNRveUul821y8kqlmVafMEZapsA1Ax9VHEUB6h+193TuWGgqd6d3lxZJAlpkkpK/gnwI9osmPu+cPc+jsCjSWndhmnPJSXcgCuM51NylJFnYrbX/bBHuO4auZcA8jvetkXTOqAsAsl3UcEt9vbukfKiCgDdnTnRUFmNKGzIYPW+BEer5D1ZdHNCX2Gbyi5UpLp4OsiV4k9d0aqHpKDFlFD+ofyvuJSh6apY3QQ8bnOgg2zCHOb27nc/cIL14jgBuHvDY/0NW2cpYjp3SFXT0+hyOyAQtHmMdujnPMlNGdQ1igKV0nlgtIL/z4asIMpa88IsqTeKVi6bkYuAR3P3282woQXhJWL4IoqQAwBy6KcOr0qUlLLQ+wqQQWhWYojzUmDR2BIw8rT+bLCxvw/6779/5+QdEn+HWS9ejTuO11AdhhRcTeiOWbqcPTOcpxrSTuRxy8P6SMstQZT+fnWWs5Ja+xUM6VMzF4N7Bh4GYROkT4cbpUsN6utaeflBqV4BUBQXIfBI1e4FfVjF/78fU0IoGnZn2U/lj8fafv3JZDF4VP9GYik+W0znl2xmn8AD7SN+U08Of55T1zgZ0f72mHbpp3QvZ8pVDe+KoR2HUKUTsOqww18higkWhE6+OIPSBD3KyAznOVy0pRfATMpxduM70c68PJGoHHML1YcyxSmOcAS4+P24t2YXfQ1U3fMAMcW2GWZNGhomRxM5itw8EA0wlUV68udXfzegZ5ZYoeE0BSMXRz7hVRhW54OXx6xcUKbhNNuB+zMarzeM+j7MZwfkLd1ihVtLw4Q7i5FeH4KhvAKsKdD"
    $sData &= "JSDJ6NHtbQOjuJuLE5Eq8EnGvCP8ewU7NrVgy4Wbz4DkUGDn/owJvcfvKfyrJCeqGK+B2GWkLt9T6bT1HyPlKJXduZ3eMzAlbTCxlVeiOTf1MQKh2b5XLy+10tjb6KVBfn1W/9Vaa96c7nwdvki3skZ1a78r45JXIGSrfy0ItjcKEj4TzoB5+5OtrcviK23aTMWBC85zVgHQPPtpb8zWkKK92l4OigooVB97AhP2EnOTDZ/TE1whGQe6Myd/H8tadY5n50H/JZEFOCDmhR0eLYU7InV/kvGyTIjwocztnVuwykXH3+i8f6WveZqgiGl2mbp1HPfFg26+FezfRWehZ7QQlvSbqFAvkt1Np7Xa+7ERGipE5M3HW4JtBrJ1lEzTzZCNJuzX6tFh0hPWSm1qOzfq9MfxlCzlt09ilrbEYtgjfhFBnpM82f8GK8DP4hbk34FC9xxbZUK2ARF9X1SCSCG37hVI8WeqG06oaVgY3A027r4rm8ICREFlJ5mgjbZqeqf12ENXQ1EF3kSCsQ25EY3OHrOWmzBjNzijlYDXMpkLXc7cFIk3DV9qcDFyie6zkZtkFpLVssZ8i+i4CrxPMoFjHij7smWvugtlxkCQp86kziF+zAAQRmv9DurEVCLjvMmFx+qGrU8CsJ1pHbHVgHjQ0IhQboYol50fcx38RyPrn1kciGvDsjFI/+ufxPE8w7JyzDDwf9eaWhBEGsuXcdECakUSKsMEENlXTANwNr2bAPEbse3d1xupb+Lr3P6O91rPlAt0lhSMCbacrkXNbYGdSeiPCb5ERMhP5ysdrmbZSgyZpiLpvKPNCqImysnm1RuZhUhR4qODC9CxwYgyJeO2OSo+sKmqXY1nHLaPBQZolJ02gT8v6hU0GxR/5d6xjfBkL+7UOpyLS9T/zo+TRA3AydayzSfXKtTV2c2cf4mGpZNPrGKUDfMj4jmYNQigpmrZ7uoGW6apQmG2lYYX21HmB5SDT28ogUFX6riHzDl/UyFXlGQIKzAs1XJv3e/S" & _
            "WDoSzMZqSgknJkHRl2DkkG9BRcolNOxWKotH+nylfPzq2PT1FLiJWMdohpLZt9LasiaJnCkxRke83FhiSx9IZ6ZtGrzmLRRXeT0MIf1MMA7n58cy9egaNQcqPT1m5TIRrHQ8B+QC9DLj6AaIYQl5D083X6l1/hNaeY+OKEsOL/4EaDVxIcZPtE6yM52yN+fs3QtfDITsz7x3rUWKPwv7zlgWwgN3jbqaae64P7VPRv0mSh99j94scvvaiCu4Gjacbyv5lvJYBWdFDsZTVpLrv563P7xTha+R3GkqdpjNeCxndo4Hh0/CBhpbm+jHkkAiUS+BIcOlGfWDSYlmJXVu8ukYRwFyskQptNz68Qjw/vzSWtubAO8ejMoRsmwu+44Z3+tAPPsz95kqrDUNYd5W9uJ3Xs9yFi3hkpBRh83a9k0LJxxrRxLk8vofkYir3s4FvR9vg3BU7wbSsAM13w3yshGekbKH4JdT0HNddd+8hUYTklTKQkm/Qpx4BwuVahYsPb8arejMisgWD5hgItfu2+V0xjJCjijn+WuFUhZbsRW9FTtvOc5/f4Cl0yEt+yj4wMXUzwDJuvyCIZvaFEOkXtl/nWC0S9wf4IZOWUz1rKf8uJhPBWmglwAfiWHF5ZuPoymN0/PFSMjCVyuEgyMa0x3VPQymN5km6eF6m7prtghT/3ega0rOfhCWB2mKdjNV+vUbHgvSSiKgSbbB1NOnZyz9i3KO495urLrFBKtjzDMXUKFg5OzIcfRwKUCzc9y69X2v4rhvgiNcfoA48SjKsZO6oHE5Evb7kYwy5iNz0546+6LmludPIGSL5A5ZKyldbIM2HGSaWon8uM2BKJHnH3ZilGjBwvAQ1wXe0cVdTcJydJ+S55MalqG/lSEUVBVo4SfLG5+ddQUl9U63SW6DeMHYrfXevUCgLylAldpPtDurOb/PxWnuIEws8ecQFO3HPhs9mtvUl//phGKhOjfE6DJ0fRq4XkzRbT/nlVfOvBorrmnyYyyBGEYpZJEtnnDm" & _
            "zbz39jW7bRDxS69VNBkcACuw5vBDpzxZNLJmYkaSYwfR7+aGmoJlQsZD5lp6jAs4l3FWPvXry1HsAcMI+HeQoCfaY9Jd6mUf02MDAxZ4X9iSf9t6fFIzax1zgQeiz8Nn/S2+mWY25Gu95MDdT3FV3Z8W6HVxmqfLdpJndCbaiERYTHFDtHvZRvUyVttupiagXSV1/0vBb+DPRW8WFLM9qe+hz0cRex5VwUYQXr6glGPsRH9SxGT0tD8p1AKSmvc9Bb6HuGUvz1WVh0cPUFvsQs1NzTXf0CX/4jpYAm020P1Fibf2z3hEAiFTCIRI5oppUANDJ1xDW41rhOgq1Cxp2CfBktvV0A1jgfQCMA2J/ORIfVSL7dgAZOA7taV9xxMpsxTw2Xy9q3YhFgSoa7iCzBqeVTXrKFd7kON0ahe1+IUfGPRrt+axdTza6uZvZl86YT6WBoKgmm7JwggoA8XiDmbMYBslP6uxboJL09fF3PrzFdM+wO+3jGh7M1feg2HNMfY5/Pe8Gms51arF/SQGK8Sr0pOu5ctBho7L9+ZmHYI/AJ01Xy/t+wDD9xYz2qKT7liwff07xr5tlthTjwUjC/orEpMkrQ+Im+7nh4ptmpDGw0buJwrXo5JyPAFA2cgXxLlohjn1xCs89bQO9EDP4ky0hx0aKZjt5+r6fbLE/EbNY4FjrVjRJv/hZQzkpAAyjxRumU/xzbB7W8srK3plTBBSQCnvwzdSK1xQ1GQ19Ll74o2PIqmKVwfS/XT62Nq2l5TwohJbP8ESAJwrtIIp8kpG5g4UgQVAC11OGAzGKML13Ig3WK7hJ8tFjtrAm4g9MhIdo5yqq5DOBlkcdecO58kWicCib/MqyKfOGbl2GgJIgg8Y2D0HOLLRCqHzC4d50zcO9LQ0/dqyXRoxf77EB53lxyUGhaIBftan2rDREG01fQP+XZnOzpBU0MW7srgodjwCjxdPJ3xCyPqX6mP2yGvh0aEqr9BkQEAGYplqKCl0ceAyE6iQnK0eaf2uiO/U"
    $sData &= "IyhDFFJ+oZoZ7z3NR8ESCHszTVBnrTir/H8+UbYG+sr+J9fGhmsmMwPP0c1Wx6TRgwQF7h9T8Vdn9w5Tan06fY2n7nMmJcNSt8cFdFka9yV/NZ3zrsCbO5QhEWNRAlvDMtRMz2oAxkNqGz/h4RUoUXkJwZD4WHIXiCEg5jZ8B3pVAtJD6vOQl/7c8jT+v68hQr9KMZ1pWrzllla3sQVw0Or6p1Pr9/zvm94bBp7+30080FDD5a91C7V8eYbJUcONLdnIrm9On01FnM6a5UAM97nDQDOuZbbIduBR05zX6TbxOu3tR4u4+2N0tNSExypeLUCQThYR21wjptihtvfLz6G28XPdKDaVMFeV4WOMP1gCuQ3bGQ4PovrIXGwJPYelNe5mMpfx9eOwdFQ2/13rzTiLiCAfG6m5k/grOkdaD/AvGX21w9WDjqjqX4N/+ZhDGXZaplZpF7ebGRBV+TdKg99aT83l49KFBroANz99aJ5o3Vy3vwPSG2zJQWcDVx6IZun53rfJyV2d5yqIy+KBdNyF34fszHzpLhow9j72uAoTOfXlQ7vcwv+hGOHZsydc6644aoa9tZAP/ugmlbY2TUnE0n4hac0Juco64PSGFRF28p5/7xaxRMbO1w+KxB8yRYqEDjoHPHttP5mGg0q/k9iGI29Fz5386vki4ipBI56a30MSSFZnB7/+LbNtlkXxrHSBAR1zq7jJ/bWnTI2x7bWnKkgQO+qHd4NIKzEkTdQ5uI+I3NqA9vjQn0PvfsUcYR/EywGqXErhaHgn2PQt1WLFSUNR7Kwp4TuDg979Y1oClBIuDHyY3dV490MpWzlGq1aSpt0kVhdLQRCBrMTUQY1jjGCVi+FnqwOjjkomRbLX7o8zwmWwQdlWp8e3SyGhCcbG5tebN4I7eD836u8ekbhwO3VSlPSCLM1ZWPC/glD+n+iQEXBWn3K7MZccUNmUe90zVx130BLjlVbl7BDx0MSgwl9xJev263obnV3i8zEOelcr931r7f4jrSk4+ZJ7" & _
            "L4/ap2bG/lPmyE75W2fmFtcKcC4ew136QdTUheTsg0j/kbxkFbbrahrtWKkfYVW/+VfXHsBNfyoTM7TB5i9DniUwdkfRrURnLAMgl49kdJzvzxcZKf1F1j5qac5oBBFVHxH8ivTrXdVWMlT8GdJVa1R+rsjdDndqg8Q5EEsfw4kMiXcMVZ6DnrnmY8lkv0lRt6nK1gKAwHOBYYY6RO3L1/SL8fAR6KvSVegGHuSCjlHhP1S2I4ce84OmSGGa7Dzj9Nx6vZ5Ojiu9QkaCH8U3ZruLqRKpOheznok5+gV/EIcwKoMvZdjYtkoktXXfbRqKK1oy9Rpj69szlCKkersPsKMoo8urymVvGHXWXyPUi3CT8QaauepY7/PhV2qcSwO27bUPPvKc8Drrx9QqprC/NSz/PJ5GViC8Y1XFGaLnKcH0S55/mGzukFZMFToepRNzD0s6qOb2ZrydY62Qr8R9hx/MfKGZ6lI0nu1Gqvr5xQ4USeyYxZengdLga63I/Cxsik1hKjCb76JCKmIuMg9I5kzY3jSoHcGESIHpLHQshFJ5XkC3DNgeBC0gdYrpe4YCoYzfIiNLMUCFw67MdgNs+eX5eKVgVHqoKloAZduoTmd+3A6WctOyh7EI9JIJIc5i43FwwLCXPC+gQgDXscGKyeaCe/RKMFqBCk8DLKN/t24GJhYdmEkoi+ex7PEfq566VhBIk6SQjPeR5aqwFdqTyIBNmzyt+PvUjj1KQ8tUX09TubwSvPjLswoGvoz++LdKXbhwsz4X5S7Jj8cGO/nF9dp1ciTgeQ7Tcg8gKdXuLiKlORMG7xe5v5zmi5LHz4d7edNBMNUs5bO8x+xZt6kR8mJU1jI2W5i9EkHsiwsljx08GTmgDmUe059YVMHGRg3u4IM6YvyeiFlpWfP8CVpC7m3bQqhb39oUZbuod8Q+wauUSg34OCJJd73m7NX5eqowSimG4vey+SUULD1k3bCCnIh72W47+zb6jfkBSIsy2P+VVjXe3J1AsNTkNUrIUghd" & _
            "w275yLdGm3/qwaehdjIte9l8K1iJvUOGxyyk3NfF3jL6F7bxYGoQMvrzYbu3Xd77SG4aPbh5b459NO/qSi/jtXR8f3k2vzv83WufGZ+EAnfb+9PYEYEetChX5zy8Q7iGxBA6eDE2GMCa01NErBvIhh8KKLVNVNYLP2qgddG7Ln5kWBbLDQdHw1cFhMHe6FmLl9zvWRJ/a6XnkJwhCVLrDNM3aVC2ky5tEOkdq6hr87nq9va9C4sepTmtfmfKDNldi6v4i4Z6O2gfq3hFJT8s9+wFI3yuMzWyQ5kEdSI2uM/dYbgHrFnJX322wq0E9Z41RF0H6uCShVqV0dFQzrdd9QysiMwWqYO83ZC9g8cxQI2cff7++KRUfoJhCi7j//Gk3lBwTlSWD7vkYCODsgx3PSZZN6Ftnch0OT/AsdyzHjq8K0fEm2c13bHsUQu2Q7qVutQf9ieyujzALbchFL2USEZtyqe81uEREySo3LeVm+ZuxfQAVL8lihvszwRdS/nIh+6nR+HgdpM59QZiiu28115tZnbFfxD1WacAwg2tRC1bsran3BhtrjYWT51PW2vhCFJKLQxXArH0O/KXzF/ilyLID0Cox3IPfuor4QGY2dkCUfiPINWeMSCanZ7PBxqtcG6WZoWhZnZMPozQr6XqBl8cOLBZNayPe8k1x61rOhE/jYUckBwlkHo24NXpm/1FG1kA5UgPQMFIi8jo4NX//0jHwf////9Mi/i4GAAAAEn35UgPQMFIi8jowtX//0UzwEyL6EGNRCT+ZkSJRCRwRYvgRY1QBEhjyEiJTY+JRCRgg/j/D44FDQAAJQEAAIB9B//Ig8j+/8CFwA+EXgwAAEQ5B3U2SItFZ0iNPElIiwi4CAAAAGY5BPkPhU0MAABIi0z5CP8VXFEAAIlFX0iLRWdIiwBIi3z4COsqSIvP6AAbAABMi9iLRYcrRCRgmSvC0fhIY8hJizzLSIvP/xUEUAAAiUVfSGNEJGRIjRxASY0E30iLyEiJRCRY/xX8UAAA"
    $sData &= "SY103QBIi87/FfxQAABIi12fM8A5A4tEJGB0Cf/ImSvC0fjrAv/ISGPISItFZ0iLAEiNFElIi85IjRTQ/xV0UQAAi0VfuSoAAAD/yEiL10iJRfdmOQxHD4VVBQAAM8lmiQxHuQgAAADoPEMAALkqAAAARTPAD7fYSItF92aJDEdIi0QkWEQPt8tIi9BIi8j/FVRRAABIi1QkaEUzwA+3w7kAQAAAS408ZGYLwUWNSAhmQokEYkEPt0z9AEGLwGZBO8kPlMCJRV9mhdsPhE8LAABBjUARZjvYdUiNSPDoHtT//0iL2DPAOUVfdBRJi1T9CEmLzuhQJQAAiAPp7TEAAAAAAAAIS+1NAAAAAHjAAAABAAAAFAAAABQAAAAowAAAjcAAAC3CAAAIUAAA+E8AABBQAAAkVAAAHFYAALBPAACMTwAAaE8AADxRAAAYUAAAVFAAAABTAAAIUwAA3E8AAKxSAADIUQAAAFAAABBTAABoUgAAtFAAAEF1dG9JdE9iamVjdF9YNjQuZGxsAN3AAADlwAAA78AAAPvAAAAUwQAAL8EAAEHBAABUwQAAbMEAAIDBAACUwQAAqsEAALnBAADJwQAA1MEAAOTBAADzwQAAAMIAAAvCAAAcwgAAQWRkRW51bQBBZGRNZXRob2QAQWRkUHJvcGVydHkAQXV0b0l0T2JqZWN0Q3JlYXRlT2JqZWN0AEF1dG9JdE9iamVjdENyZWF0ZU9iamVjdEV4AENsb25lQXV0b0l0T2JqZWN0AENyZWF0ZUF1dG9JdE9iamVjdABDcmVhdGVBdXRvSXRPYmplY3RDbGFzcwBDcmVhdGVEbGxDYWxsT2JqZWN0AENyZWF0ZVdyYXBwZXJPYmplY3QAQ3JlYXRlV3JhcHBlck9iamVjdEV4AElVbmtub3duQWRkUmVmAElVbmtub3duUmVsZWFzZQBJbml0aWFsaXplAE1lbW9yeUNhbGxFbnRyeQBSZWdpc3Rlck9iamVjdABSZW1vdmVNZW1iZXIA" & _
            "UmV0dXJuVGhpcwBVblJlZ2lzdGVyT2JqZWN0AFdyYXBwZXJBZGRNZXRob2QAAAABAAIAAwAEAAUABgAHAAgACQAKAAsADAANAA4ADwAQABEAEgATAAAAALzCAAAAAAAAAAAAAEDDAAC8wgAA1MIAAAAAAAAAAAAAScMAANTCAADkwgAAAAAAAAAAAABiwwAA5MIAAPTCAAAAAAAAAAAAAG/DAAD0wgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAcwwAAAAAAAC/DAAAAAAAAAAAAAAAAAABTwwAAAAAAAAAAAAAAAAAABQEAAAAAAIAAAAAAAAAAAHvDAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEdldE1vZHVsZUhhbmRsZUEAAABHZXRQcm9jQWRkcmVzcwBLRVJORUwzMgBvbGUzMi5kbGwAAABDb0luaXRpYWxpemUAT0xFQVVUMzIuZGxsAFNITFdBUEkuZGxsAAAAU3RyVG9JbnQ2NEV4VwBXVlNRUkFQSI0F3goAAEiLMEgD8EgrwEiL/matweAMSIvIUK0ryEgD8YvIV0SLwf/JikQ5BogEMXX1QVFVK8Csi8jB6QRRJA9QrIvIAgwkUEjHxQD9//9I0+VZWEjB4CBIA8hYSIvcSI2kbJDx//9QUUgryVFRSIvMUWaLF8HiDFJXTI1JCEmNSQhWWkiD7CDoyAAAAEiL411BWV5ageoAEAAAK8k7ynNKi9ms/8E8/3UNigYk/TwVdeus/8HrFzyNdQ2KBiTHPAV12qz/wesGJP486HXPUVuDwQStC8B4BjvCc8HrBgPDeLsDwivDiUb867JIjT0G////sOmquOIKAACrSI0F4gkAAItQDIt4CAv/dD1IizBIA/BIK/JIi95Ii0gUSCvLdCiLUBBIA/JIA/4rwCvSC9CsweIH0Ohy9gvQC9J0C0gD2kgpC0g793LhSI0FlAkAAOmKCQAATIlMJCBIiVQkEFNVVldBVEFVQVZBV0iD" & _
            "7Cgz9kyL8kiLwY1eAUyNaQyLSQhEi9OL00yL/kHT4otIBESK3tPiSIuMJKAAAABEK9Mr04vuRIvjiVQkDIsQSYkxiVQkCEiJMYtIBAPKugADAABEiVQkENPiiZwkgAAAAIlcJHCBwjYHAACJXCQEdA2LykmL/bgABAAA82arTYvOTQPwi/5Bg8j/i85NO84PhMoIAABBD7YBwecIA8sL+EwDy4P5BXzkSDm0JJgAAAAPhooIAACLxUGL97oIAAAAweAEQSPyQboAAAABSGPYSGPGSAPYRTvCcxpNO84PhD8IAABBD7YBwecIQcHgCAv4SYPBAUEPt0xdAEGLwMHoCw+vwTv4D4O1AQAARIvAuAAIAABBugEAAAArwcH4BWYDwYvKQQ+202ZBiURdAItcJAiLRCQMSSPHKstI0+qLy0jT4EgD0EiNBFJIweAJg/0HSY20BWwOAAAPjLsAAABBi8RJi89IK8hIi4QkkAAAAA+2HAgD20ljwkSL20GB4wABAABJY9NIA9BBgfgAAAABcxpNO84PhIgHAABBD7YBwecIQcHgCAv4SYPBAQ+3jFYAAgAAQYvAwegLD6/BO/hzKESLwLgACAAARQPSK8HB+AVmA8FmiYRWAAIAADPARDvYD4WbAAAA6yNEK8Ar+A+3wWbB6AVHjVQSAWYryDPARDvYZomMVgACAAB0dkGB+gABAAB9dula////QYH4AAAAAUlj0nMaTTvOD4T0BgAAQQ+2AcHnCEHB4AgL+EmDwQEPtwxWQYvAwegLD6/BO/hzGUSLwLgACAAAK8HB+AVmA8FFA9JmiQRW6xhEK8Ar+A+3wWbB6AVHjVQSAWYryGaJDFZBgfoAAQAAfI9Ii4QkkAAAAEWK2kaIFDhJg8cBg/0EfQkzwIvo6WMGAACD/Qp9CIPtA+lWBgAAg+0G6U4GAABEK8Ar+A+3wWbB6AVIY9VmK8hFO8JmQYlMXQBzIU07zg+EPAYAAEEPtgHB5whBuwEAAAAL+EHB4AhNA8vrBkG7"
    $sData &= "AQAAAEEPt4xVgAEAAEGLwMHoCw+vwTv4c1FEi8C4AAgAACvBwfgFZgPBg/0HZkGJhFWAAQAAi0QkcEmNlWQGAACJRCQEi4QkgAAAAESJpCSAAAAAiUQkcLgDAAAAjVj9D0zDjWsI6U4CAABEK8Ar+A+3wWbB6AVmK8hFO8JmQYmMVYABAABzGU07zg+EmAUAAEEPtgHB5whBweAIC/hNA8tFD7eUVZgBAABBi8jB6QtBD6/KO/kPg8gAAAC4AAgAAESLwUErwsH4BWZBA8JBugAAAAFBO8pmQYmEVZgBAABzGU07zg+EPgUAAEEPtgHB5whBweAIC/hNA8tBD7eMXeABAABBi8DB6AsPr8E7+HNWRIvAuAAIAAArwcH4BWYDwWZBiYRd4AEAADPATDv4D4T0BAAASIuUJJAAAAC4CwAAAIP9B41I/g9MwUmLz4voQYvESCvIRIocCkaIHDpJg8cB6acEAABEK8Ar+A+3wWbB6AVmK8hmQYmMXeABAADpHgEAAEEPt8JEK8Er+WbB6AVmRCvQZkWJlFWYAQAAQboAAAABRTvCcxlNO84PhHcEAABBD7YBwecIQcHgCAv4TQPLQQ+3jFWwAQAAQYvAwegLD6/BO/hzJUSLwLgACAAAK8HB+AVmA8FmQYmEVbABAACLhCSAAAAA6ZoAAABEK8Ar+A+3wWbB6AVmK8hFO8JmQYmMVbABAABzGU07zg+EBgQAAEEPtgHB5whBweAIC/hNA8tBD7eMVcgBAABBi8DB6AsPr8E7+HMfRIvAuAAIAAArwcH4BWYDwWZBiYRVyAEAAItEJHDrJEQrwCv4D7fBZsHoBWYryItEJARmQYmMVcgBAACLTCRwiUwkBIuMJIAAAACJTCRwRImkJIAAAABEi+CD/Qe4CwAAAEmNlWgKAACNaP0PTMUz20U7wokEJHMZTTvOD4RfAwAAQQ+2AcHnCEHB4AgL+E0Dyw+3CkGLwMHoCw+vwTv4cyVEi8C4AAgAAESL0yvBwfgFZgPBZokC" & _
            "i8bB4ANIY8hMjVxKBOtoRCvAK/gPt8FmwegFZivIRTvCZokKcxlNO84PhPoCAABBD7YBwecIQcHgCAv4TQPLD7dKAkGLwMHoCw+vwTv4cy5Ei8C4AAgAAESL1SvBwfgFZgPBZolCAovGweADSGPITI2cSgQBAAC7AwAAAOsiRCvAK/gPt8FmwegFTI2aBAIAAEG6EAAAAGYryIvdZolKAovzvQEAAABBgfgAAAABSGPVcxpNO84PhGYCAABBD7YBwecIQcHgCAv4SYPBAUEPtwxTQYvAwegLD6/BO/hzGUSLwLgACAAAK8HB+AVmA8ED7WZBiQRT6xhEK8Ar+A+3wWbB6AWNbC0BZivIZkGJDFOD7gF1ko1GAYvL0+BEK9CLBCRBA+qD+AQPjaABAACDwAeD/QSNXgaJBCSNRgONVgEPTMXB4AZImE2NnEVgAwAAQYH4AAAAAUxj0nMaTTvOD4S9AQAAQQ+2AcHnCEHB4AgL+EmDwQFDD7cMU0GLwMHoCw+vwTv4cxlEi8C4AAgAACvBwfgFZgPBA9JmQ4kEU+sYRCvAK/gPt8FmwegFjVQSAWYryGZDiQxTg+sBdZKD6kCD+gREi+IPjPsAAABBg+QBRIvSQdH6QYPMAkGD6gGD+g59GUGLykhjwkHT5EGLzEgryEmNnE1eBQAA61BBg+oEQYH4AAAAAXMaTTvOD4QPAQAAQQ+2AcHnCEHB4AgL+EmDwQFB0ehFA+RBO/hyB0Er+EGDzAFBg+oBdcVJjZ1EBgAAQcHkBEG6BAAAAL4BAAAAi9ZBgfgAAAABTGPacxpNO84PhLkAAABBD7YBwecIQcHgCAv4SYPBAUIPtwxbQYvAwegLD6/BO/hzGUSLwLgACAAAK8HB+AVmA8ED0mZCiQRb6xtEK8Ar+A+3wWbB6AWNVBIBZivIRAvmZkKJDFsD9kGD6gF1jEGDxAF0YEGLxIPFAkljzEk7x3dGSIuUJJAAAABJi8dIK8FIA8JEihhIg8ABRogcOkmDxwGD7QF0" & _
            "Ckw7vCSYAAAAcuKLLCRMO7wkmAAAAHMWRItUJBDplPf//7gBAAAA6zhBi8PrM0GB+AAAAAFzCU07znTmSYPBAUiLhCSIAAAATCtMJHhMiQhIi4QkoAAAAEyJODPA6wKLw0iDxChBX0FeQV1BXF9eXVvD6e6O//+JQf///////0MAAAAAEAAAALAAAAAAAIABAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEAEAAAABgAAIAAAAAAAAAAAAAAAAAAAAEAAQAAADAAAIAAAAAAAAAAAAAAAAAAAAEACQQAAEgAAABY0AAAGAMAAAAAAAAAAAAAGAM0AAAAVgBTAF8AVgBFAFIAUwBJAE8ATgBfAEkATgBGAE8AAAAAAL0E7/4AAAEAAgABAAMACAACAAEAAwAIAAAAAAAAAAAABAAAAAIAAAAAAAAAAAAAAAAAAAB2AgAAAQBTAHQAcgBpAG4AZwBGAGkAbABlAEkAbgBmAG8AAABSAgAAAQAwADQAMAA5ADAANABCADAAAAAwAAgAAQBGAGkAbABlAFYA"
    $sData &= "ZQByAHMAaQBvAG4AAAAAADEALgAyAC4AOAAuADMAAAA0AAgAAQBQAHIAbwBkAHUAYwB0AFYAZQByAHMAaQBvAG4AAAAxAC4AMgAuADgALgAzAAAAegApAAEARgBpAGwAZQBEAGUAcwBjAHIAaQBwAHQAaQBvAG4AAAAAAFAAcgBvAHYAaQBkAGUAcwAgAG8AYgBqAGUAYwB0ACAAZgB1AG4AYwB0AGkAbwBuAGEAbABpAHQAeQAgAGYAbwByACAAQQB1AHQAbwBJAHQAAAAAADoADQABAFAAcgBvAGQAdQBjAHQATgBhAG0AZQAAAAAAQQB1AHQAbwBJAHQATwBiAGoAZQBjAHQAAAAAAFgAGgABAEwAZQBnAGEAbABDAG8AcAB5AHIAaQBnAGgAdAAAACgAQwApACAAVABoAGUAIABBAHUAdABvAEkAdABPAGIAagBlAGMAdAAtAFQAZQBhAG0AAABKABEAAQBPAHIAaQBnAGkAbgBhAGwARgBpAGwAZQBuAGEAbQBlAAAAQQB1AHQAbwBJAHQATwBiAGoAZQBjAHQALgBkAGwAbAAAAAAAegAjAAEAVABoAGUAIABBAHUAdABvAEkAdABPAGIAagBlAGMAdAAtAFQAZQBhAG0AAAAAAG0AbwBuAG8AYwBlAHIAZQBzACwAIAB0AHIAYQBuAGMAZQB4AHgALAAgAEsAaQBwACwAIABQAHIAbwBnAEEAbgBkAHkAAAAAAEQAAAABAFYAYQByAEYAaQBsAGUASQBuAGYAbwAAAAAAJAAEAAAAVAByAGEAbgBzAGwAYQB0AGkAbwBuAAAAAAAJBLAEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
    Return __Au3Obj_Mem_Base64Decode($sData)
EndFunc   ;==>__Au3Obj_Mem_BinDll_X64

#EndRegion Embedded DLL
;--------------------------------------------------------------------------------------------------------------------------------------


;--------------------------------------------------------------------------------------------------------------------------------------
#Region DllStructCreate Wrapper

Func __Au3Obj_ObjStructMethod(ByRef $oSelf, $vParam1 = 0, $vParam2 = 0)
	Local $sMethod = $oSelf.__name__
	Local $tStructure = DllStructCreate($oSelf.__tag__, $oSelf.__pointer__)
	Local $vOut
	Switch @NumParams
		Case 1
			$vOut = DllStructGetData($tStructure, $sMethod)
		Case 2
			If $oSelf.__propcall__ Then
				$vOut = DllStructSetData($tStructure, $sMethod, $vParam1)
			Else
				$vOut = DllStructGetData($tStructure, $sMethod, $vParam1)
			EndIf
		Case 3
			$vOut = DllStructSetData($tStructure, $sMethod, $vParam2, $vParam1)
	EndSwitch
	If IsPtr($vOut) Then Return Number($vOut)
	Return $vOut
EndFunc   ;==>__Au3Obj_ObjStructMethod

Func __Au3Obj_ObjStructDestructor(ByRef $oSelf)
	If $oSelf.__new__ Then __Au3Obj_GlobalFree($oSelf.__pointer__)
EndFunc   ;==>__Au3Obj_ObjStructDestructor

Func __Au3Obj_ObjStructPointer(ByRef $oSelf, $vParam = Default)
	If $oSelf.__propcall__ Then Return SetError(1, 0, 0)
	If @NumParams = 1 Or IsKeyword($vParam) Then Return $oSelf.__pointer__
	Return Number(DllStructGetPtr(DllStructCreate($oSelf.__tag__, $oSelf.__pointer__), $vParam))
EndFunc   ;==>__Au3Obj_ObjStructPointer

#EndRegion DllStructCreate Wrapper
;--------------------------------------------------------------------------------------------------------------------------------------


;--------------------------------------------------------------------------------------------------------------------------------------
#Region Public UDFs

Global Enum $ELTYPE_NOTHING, $ELTYPE_METHOD, $ELTYPE_PROPERTY
Global Enum $ELSCOPE_PUBLIC, $ELSCOPE_READONLY, $ELSCOPE_PRIVATE

; #FUNCTION# ====================================================================================================================
; Name...........: _AutoItObject_AddDestructor
; Description ...: Adds a destructor to an AutoIt-object
; Syntax.........: _AutoItObject_AddDestructor(ByRef $oObject, $sAutoItFunc)
; Parameters ....: $oObject     - the object to modify
;                  $sAutoItFunc - the AutoIt-function wich represents this destructor.
; Return values .: Success      - True
;                  Failure      - 0
; Author ........: monoceres (Andreas Karlsson)
; Modified.......:
; Remarks .......: Adding a method that will be called on object destruction. Can be called multiple times.
; Related .......: _AutoItObject_AddProperty, _AutoItObject_AddEnum, _AutoItObject_RemoveMember, _AutoItObject_AddMethod
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _AutoItObject_AddDestructor(ByRef $oObject, $sAutoItFunc)
	Return _AutoItObject_AddMethod($oObject, "~", $sAutoItFunc, True)
EndFunc   ;==>_AutoItObject_AddDestructor

; #FUNCTION# ====================================================================================================================
; Name...........: _AutoItObject_AddEnum
; Description ...: Adds an Enum to an AutoIt-object
; Syntax.........: _AutoItObject_AddEnum(ByRef $oObject, $sNextFunc, $sResetFunc [, $sSkipFunc = ''])
; Parameters ....: $oObject     - the object to modify
;                  $sNextFunc   - The function to be called to get the next entry
;                  $sResetFunc  - The function to be called to reset the enum
;                  $sSkipFunc   - [optional] The function to be called to skip elements (not supported by AutoIt)
; Return values .: Success      - True
;                  Failure      - 0
; Author ........: Prog@ndy
; Modified.......:
; Remarks .......:
; Related .......: _AutoItObject_AddMethod, _AutoItObject_AddProperty, _AutoItObject_RemoveMember
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _AutoItObject_AddEnum(ByRef $oObject, $sNextFunc, $sResetFunc, $sSkipFunc = '')
	; Author: Prog@ndy
	If Not IsObj($oObject) Then Return SetError(2, 0, 0)
	DllCall($ghAutoItObjectDLL, "none", "AddEnum", "idispatch", $oObject, "wstr", $sNextFunc, "wstr", $sResetFunc, "wstr", $sSkipFunc)
	If @error Then Return SetError(1, @error, 0)
	Return True
EndFunc   ;==>_AutoItObject_AddEnum

; #FUNCTION# ====================================================================================================================
; Name...........: _AutoItObject_AddMethod
; Description ...: Adds a method to an AutoIt-object
; Syntax.........: _AutoItObject_AddMethod(ByRef $oObject, $sName, $sAutoItFunc [, $fPrivate = False])
; Parameters ....: $oObject     - the object to modify
;                  $sName       - the name of the method to add
;                  $sAutoItFunc - the AutoIt-function wich represents this method.
;                  $fPrivate    - [optional] Specifies whether the function can only be called from within the object. (default: False)
; Return values .: Success      - True
;                  Failure      - 0
; Author ........: Prog@ndy
; Modified.......:
; Remarks .......: The first parameter of the AutoIt-function is always a reference to the object. ($oSelf)
;                  This parameter will automatically be added and must not be given in the call.
;                  The function called '__default__' is accesible without a name using brackets ($return = $oObject())
; Related .......: _AutoItObject_AddProperty, _AutoItObject_AddEnum, _AutoItObject_RemoveMember
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _AutoItObject_AddMethod(ByRef $oObject, $sName, $sAutoItFunc, $fPrivate = False)
	; Author: Prog@ndy
	If Not IsObj($oObject) Then Return SetError(2, 0, 0)
	Local $iFlags = 0
	If $fPrivate Then $iFlags = $ELSCOPE_PRIVATE
	DllCall($ghAutoItObjectDLL, "none", "AddMethod", "idispatch", $oObject, "wstr", $sName, "wstr", $sAutoItFunc, 'dword', $iFlags)
	If @error Then Return SetError(1, @error, 0)
	Return True
EndFunc   ;==>_AutoItObject_AddMethod

; #FUNCTION# ====================================================================================================================
; Name...........: _AutoItObject_AddProperty
; Description ...: Adds a property to an AutoIt-object
; Syntax.........: _AutoItObject_AddProperty(ByRef $oObject, $sName [, $iFlags = $ELSCOPE_PUBLIC [, $vData = ""]])
; Parameters ....: $oObject     - the object to modify
;                  $sName       - the name of the property to add
;                  $iFlags      - [optional] Specifies the access to the property
;                  $vData       - [optional] Initial data for the property
; Return values .: Success      - True
;                  Failure      - 0
; Author ........: Prog@ndy
; Modified.......:
; Remarks .......: The property called '__default__' is accesible without a name using brackets ($value = $oObject())
;                  + $iFlags can be:
;                  |$ELSCOPE_PUBLIC   - The Property has public access.
;                  |$ELSCOPE_READONLY - The property is read-only and can only be changed from within the object.
;                  |$ELSCOPE_PRIVATE  - The property is private and can only be accessed from within the object.
;                  +
;                  + Initial default value for every new property is nothing (no value).
; Related .......: _AutoItObject_AddMethod, _AutoItObject_AddEnum, _AutoItObject_RemoveMember
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _AutoItObject_AddProperty(ByRef $oObject, $sName, $iFlags = $ELSCOPE_PUBLIC, $vData = "")
	; Author: Prog@ndy
	Local Static $tStruct = DllStructCreate($__Au3Obj_tagVARIANT)
	If Not IsObj($oObject) Then Return SetError(2, 0, 0)
	Local $pData = 0
	If @NumParams = 4 Then
		$pData = DllStructGetPtr($tStruct)
		_AutoItObject_VariantInit($pData)
		$oObject.__bridge__(Number($pData)) = $vData
	EndIf
	DllCall($ghAutoItObjectDLL, "none", "AddProperty", "idispatch", $oObject, "wstr", $sName, 'dword', $iFlags, 'ptr', $pData)
	Local $error = @error
	If $pData Then _AutoItObject_VariantClear($pData)
	If $error Then Return SetError(1, $error, 0)
	Return True
EndFunc   ;==>_AutoItObject_AddProperty

; #FUNCTION# ====================================================================================================================
; Name...........: _AutoItObject_Class
; Description ...: AutoItObject COM wrapper function
; Syntax.........: _AutoItObject_Class()
; Parameters ....:
; Return values .: Success      - object with defined:
;                   -methods:
;                  |	Create([$oParent = 0]) - creates AutoItObject object
;                  |	AddMethod($sName, $sAutoItFunc [, $fPrivate = False]) - adds new method
;                  |	AddProperty($sName, $iFlags = $ELSCOPE_PUBLIC, $vData = 0) - adds new property
;                  |	AddDestructor($sAutoItFunc) - adds destructor
;                  |	AddEnum($sNextFunc, $sResetFunc [, $sSkipFunc = '']) - adds enum
;                  |	RemoveMember($sMember) - removes member
;                   -properties:
;                  |	Object - readonly property representing the last created AutoItObject object
; Author ........: trancexx
; Modified.......:
; Remarks .......: "Object" propery can be accessed only once for one object. After that new AutoItObject object is created.
;                  +Method "Create" will discharge previous AutoItObject object and create a new one.
; Related .......: _AutoItObject_Create
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _AutoItObject_Class()
	Local $aCall = DllCall($ghAutoItObjectDLL, "idispatch", "CreateAutoItObjectClass")
	If @error Then Return SetError(1, @error, 0)
	Return $aCall[0]
EndFunc   ;==>_AutoItObject_Class

; #FUNCTION# ====================================================================================================================
; Name...........: _AutoItObject_CLSIDFromString
; Description ...: Converts a string to a CLSID-Struct (GUID-Struct)
; Syntax.........: _AutoItObject_CLSIDFromString($sString)
; Parameters ....: $sString     - The string to convert
; Return values .: Success      - DLLStruct in format $tagGUID
;                  Failure      - 0
; Author ........: Prog@ndy
; Modified.......:
; Remarks .......:
; Related .......: _AutoItObject_CoCreateInstance
; Link ..........: http://msdn.microsoft.com/en-us/library/ms680589(VS.85).aspx
; Example .......:
; ===============================================================================================================================
Func _AutoItObject_CLSIDFromString($sString)
	Local $tCLSID = DllStructCreate("dword;word;word;byte[8]")
	Local $aResult = DllCall($gh_AU3Obj_ole32dll, 'long', 'CLSIDFromString', 'wstr', $sString, 'ptr', DllStructGetPtr($tCLSID))
	If @error Then Return SetError(1, @error, 0)
	If $aResult[0] <> 0 Then Return SetError(2, $aResult[0], 0)
	Return $tCLSID
EndFunc   ;==>_AutoItObject_CLSIDFromString

; #FUNCTION# ====================================================================================================================
; Name...........: _AutoItObject_CoCreateInstance
; Description ...: Creates a single uninitialized object of the class associated with a specified CLSID.
; Syntax.........: _AutoItObject_CoCreateInstance($rclsid, $pUnkOuter, $dwClsContext, $riid, ByRef $ppv)
; Parameters ....: $rclsid       - The CLSID associated with the data and code that will be used to create the object.
;                  $pUnkOuter    - If NULL, indicates that the object is not being created as part of an aggregate.
;                  +If non-NULL, pointer to the aggregate object's IUnknown interface (the controlling IUnknown).
;                  $dwClsContext - Context in which the code that manages the newly created object will run.
;                  +The values are taken from the enumeration CLSCTX.
;                  $riid         - A reference to the identifier of the interface to be used to communicate with the object.
;                  $ppv          - [out byref] Variable that receives the interface pointer requested in riid.
;                  +Upon successful return, *ppv contains the requested interface pointer. Upon failure, *ppv contains NULL.
; Return values .: Success      - True
;                  Failure      - 0
; Author ........: Prog@ndy
; Modified.......:
; Remarks .......:
; Related .......: _AutoItObject_ObjCreate, _AutoItObject_CLSIDFromString
; Link ..........: http://msdn.microsoft.com/en-us/library/ms686615(VS.85).aspx
; Example .......:
; ===============================================================================================================================
Func _AutoItObject_CoCreateInstance($rclsid, $pUnkOuter, $dwClsContext, $riid, ByRef $ppv)
	$ppv = 0
	Local $aResult = DllCall($gh_AU3Obj_ole32dll, 'long', 'CoCreateInstance', 'ptr', $rclsid, 'ptr', $pUnkOuter, 'dword', $dwClsContext, 'ptr', $riid, 'ptr*', 0)
	If @error Then Return SetError(1, @error, 0)
	$ppv = $aResult[5]
	Return SetError($aResult[0], 0, $aResult[0] = 0)
EndFunc   ;==>_AutoItObject_CoCreateInstance

; #FUNCTION# ====================================================================================================================
; Name...........: _AutoItObject_Create
; Description ...: Creates an AutoIt-object
; Syntax.........: _AutoItObject_Create( [$oParent = 0] )
; Parameters ....: $oParent     - [optional] an AutoItObject whose methods & properties are copied. (default: 0)
; Return values .: Success      - AutoIt-Object
;                  Failure      - 0
; Author ........: Prog@ndy
; Modified.......:
; Remarks .......:
; Related .......: _AutoItObject_Class
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _AutoItObject_Create($oParent = 0)
	; Author: Prog@ndy
	Local $aResult
	Switch IsObj($oParent)
		Case True
			$aResult = DllCall($ghAutoItObjectDLL, "idispatch", "CloneAutoItObject", 'idispatch', $oParent)
		Case Else
			$aResult = DllCall($ghAutoItObjectDLL, "idispatch", "CreateAutoItObject")
	EndSwitch
	If @error Then Return SetError(1, @error, 0)
	Return $aResult[0]
EndFunc   ;==>_AutoItObject_Create

; #FUNCTION# ====================================================================================================================
; Name...........: _AutoItObject_DllOpen
; Description ...: Creates an object associated with specified dll
; Syntax.........: _AutoItObject_DllOpen($sDll [, $sTag = "" [, $iFlag = 0]])
; Parameters ....: $sDll - Dll for which to create an object
;                  $sTag - [optional] String representing function return value and parameters.
;                  $iFlag - [optional] Flag specifying the level of loading. See MSDN about LoadLibraryEx function for details. Default is 0.
; Return values .: Success      - Dispatch-Object
;                  Failure      - 0
; Author ........: trancexx
; Modified.......:
; Remarks .......:
; Related .......: _AutoItObject_WrapperCreate
; Link ..........: http://msdn.microsoft.com/en-us/library/ms684179(VS.85).aspx
; Example .......:
; ===============================================================================================================================
Func _AutoItObject_DllOpen($sDll, $sTag = "", $iFlag = 0)
	Local $sTypeTag = "wstr"
	If $sTag = Default Or Not $sTag Then $sTypeTag = "ptr"
	Local $aCall = DllCall($ghAutoItObjectDLL, "idispatch", "CreateDllCallObject", "wstr", $sDll, $sTypeTag, __Au3Obj_GetMethods($sTag), "dword", $iFlag)
	If @error Or Not IsObj($aCall[0]) Then Return SetError(1, 0, 0)
	Return $aCall[0]
EndFunc   ;==>_AutoItObject_DllOpen

; #FUNCTION# ====================================================================================================================
; Name...........: _AutoItObject_DllStructCreate
; Description ...: Object wrapper for DllStructCreate and related functions
; Syntax.........: _AutoItObject_DllStructCreate($sTag [, $vParam = 0])
; Parameters ....: $sTag     - A string representing the structure to create (same as with DllStructCreate)
;                  $vParam   - [optional] If this parameter is DLLStruct type then it will be copied to newly allocated space and maintained during lifetime of the object. If this parameter is not suplied needed memory allocation is done but content is initialized to zero. In all other cases function will not allocate memory but use parameter supplied as the pointer (same as DllStructCreate)
; Return values .: Success      - Object-structure
;                  Failure      - 0, @error is set to error value of DllStructCreate() function.
; Author ........: trancexx
; Modified.......:
; Remarks .......: AutoIt can't handle pointers properly when passed to or returned from object methods. Use Number() function on pointers before using them with this function.
;                  +Every element of structure must be named. Values are accessed through their names.
;                  +Created object exposes:
;                  +  - set of dynamic methods in names of elements of the structure
;                  +  - readonly properties:
;                  |	__tag__ - a string representing the object-structure
;                  |	__size__ - the size of the struct in bytes
;                  |	__alignment__ - alignment string (e.g. "align 2")
;                  |	__count__ - number of elements of structure
;                  |	__elements__ - string made of element names separated by semicolon (;)
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _AutoItObject_DllStructCreate($sTag, $vParam = 0)
	Local $fNew = False
	Local $tSubStructure = DllStructCreate($sTag)
	If @error Then Return SetError(@error, 0, 0)
	Local $iSize = DllStructGetSize($tSubStructure)
	Local $pPointer = $vParam
	Select
		Case @NumParams = 1
			; Will allocate fixed 128 extra bytes due to possible misalignment and other issues
			$pPointer = __Au3Obj_GlobalAlloc($iSize + 128, 64) ; GPTR
			If @error Then Return SetError(3, 0, 0)
			$fNew = True
		Case IsDllStruct($vParam)
			$pPointer = __Au3Obj_GlobalAlloc($iSize, 64) ; GPTR
			If @error Then Return SetError(3, 0, 0)
			$fNew = True
			DllStructSetData(DllStructCreate("byte[" & $iSize & "]", $pPointer), 1, DllStructGetData(DllStructCreate("byte[" & $iSize & "]", DllStructGetPtr($vParam)), 1))
		Case @NumParams = 2 And $vParam = 0
			Return SetError(3, 0, 0)
	EndSelect
	Local $sAlignment
	Local $sNamesString = __Au3Obj_ObjStructGetElements($sTag, $sAlignment)
	Local $aElements = StringSplit($sNamesString, ";", 2)
	Local $oObj = _AutoItObject_Class()
	For $i = 0 To UBound($aElements) - 1
		$oObj.AddMethod($aElements[$i], "__Au3Obj_ObjStructMethod")
	Next
	$oObj.AddProperty("__tag__", $ELSCOPE_READONLY, $sTag)
	$oObj.AddProperty("__size__", $ELSCOPE_READONLY, $iSize)
	$oObj.AddProperty("__alignment__", $ELSCOPE_READONLY, $sAlignment)
	$oObj.AddProperty("__count__", $ELSCOPE_READONLY, UBound($aElements))
	$oObj.AddProperty("__elements__", $ELSCOPE_READONLY, $sNamesString)
	$oObj.AddProperty("__new__", $ELSCOPE_PRIVATE, $fNew)
	$oObj.AddProperty("__pointer__", $ELSCOPE_READONLY, Number($pPointer))
	$oObj.AddMethod("__default__", "__Au3Obj_ObjStructPointer")
	$oObj.AddDestructor("__Au3Obj_ObjStructDestructor")
	Return $oObj.Object
EndFunc   ;==>_AutoItObject_DllStructCreate

; #FUNCTION# ====================================================================================================================
; Name...........: _AutoItObject_IDispatchToPtr
; Description ...: Returns pointer to AutoIt's object type
; Syntax.........: _AutoItObject_IDispatchToPtr(ByRef $oIDispatch)
; Parameters ....: $oIDispatch  - Object
; Return values .: Success      - Pointer to object
;                  Failure      - 0
; Author ........: monoceres, trancexx
; Modified.......:
; Remarks .......:
; Related .......: _AutoItObject_PtrToIDispatch, _AutoItObject_CoCreateInstance, _AutoItObject_ObjCreate
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _AutoItObject_IDispatchToPtr($oIDispatch)
	Local $aCall = DllCall($ghAutoItObjectDLL, "ptr", "ReturnThis", "idispatch", $oIDispatch)
	If @error Then Return SetError(1, 0, 0)
	Return $aCall[0]
EndFunc   ;==>_AutoItObject_IDispatchToPtr

; #FUNCTION# ====================================================================================================================
; Name...........: _AutoItObject_IUnknownAddRef
; Description ...: Increments the refrence count of an IUnknown-Object
; Syntax.........: _AutoItObject_IUnknownAddRef($vUnknown)
; Parameters ....: $vUnknown    - IUnkown-pointer or object itself
; Return values .: Success      - New reference count.
;                  Failure      - 0, @error is set.
; Author ........: Prog@ndy
; Modified.......:
; Remarks .......:
; Related .......: _AutoItObject_IUnknownRelease
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _AutoItObject_IUnknownAddRef(Const $vUnknown)
	; Author: Prog@ndy
	Local $sType = "ptr"
	If IsObj($vUnknown) Then $sType = "idispatch"
	Local $aCall = DllCall($ghAutoItObjectDLL, "dword", "IUnknownAddRef", $sType, $vUnknown)
	If @error Then Return SetError(1, @error, 0)
	Return $aCall[0]
EndFunc   ;==>_AutoItObject_IUnknownAddRef

; #FUNCTION# ====================================================================================================================
; Name...........: _AutoItObject_IUnknownRelease
; Description ...: Decrements the refrence count of an IUnknown-Object
; Syntax.........: _AutoItObject_IUnknownRelease($vUnknown)
; Parameters ....: $vUnknown    - IUnkown-pointer or object itself
; Return values .: Success      - New reference count.
;                  Failure      - 0, @error is set.
; Author ........: trancexx
; Modified.......:
; Remarks .......:
; Related .......: _AutoItObject_IUnknownAddRef
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _AutoItObject_IUnknownRelease(Const $vUnknown)
	Local $sType = "ptr"
	If IsObj($vUnknown) Then $sType = "idispatch"
	Local $aCall = DllCall($ghAutoItObjectDLL, "dword", "IUnknownRelease", $sType, $vUnknown)
	If @error Then Return SetError(1, @error, 0)
	Return $aCall[0]
EndFunc   ;==>_AutoItObject_IUnknownRelease

; #FUNCTION# ====================================================================================================================
; Name...........: _AutoItObject_ObjCreate
; Description ...: Creates a reference to a COM object
; Syntax.........: _AutoItObject_ObjCreate($sID [, $sRefId = Default [, $tagInterface = Default ]] )
; Parameters ....: $sID - Object identifier. Either string representation of CLSID or ProgID
;                  $sRefId - [optional] String representation of the identifier of the interface to be used to communicate with the object. Default is the value of IDispatch
;                  $tagInterface - [optional] String defining the methods of the Interface, see Remarks for _AutoItObject_WrapperCreate function for details
; Return values .: Success      - Dispatch-Object
;                  Failure      - 0
; Author ........: trancexx
; Modified.......:
; Remarks .......: Prefix object identifier with "cbi:" to create object from ROT.
; Related .......: _AutoItObject_ObjCreateEx, _AutoItObject_WrapperCreate
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _AutoItObject_ObjCreate($sID, $sRefId = Default, $tagInterface = Default)
	Local $sTypeRef = "wstr"
	If $sRefId = Default Or Not $sRefId Then $sTypeRef = "ptr"
	Local $sTypeTag = "wstr"
	If $tagInterface = Default Or Not $tagInterface Then $sTypeTag = "ptr"
	Local $aCall = DllCall($ghAutoItObjectDLL, "idispatch", "AutoItObjectCreateObject", "wstr", $sID, $sTypeRef, $sRefId, $sTypeTag, __Au3Obj_GetMethods($tagInterface))
	If @error Or Not IsObj($aCall[0]) Then Return SetError(1, 0, 0)
	If $sTypeRef = "ptr" And $sTypeTag = "ptr" Then _AutoItObject_IUnknownRelease($aCall[0])
	Return $aCall[0]
EndFunc   ;==>_AutoItObject_ObjCreate

; #FUNCTION# ====================================================================================================================
; Name...........: _AutoItObject_ObjCreateEx
; Description ...: Creates a reference to a COM object
; Syntax.........: _AutoItObject_ObjCreateEx($sModule, $sCLSID [, $sRefId = Default [, $tagInterface = Default [, $fWrapp = False]]] )
; Parameters ....: $sModule - Full path to the module with class (object)
;                  $sCLSID - Object identifier. String representation of CLSID.
;                  $sRefId - [optional] String representation of the identifier of the interface to be used to communicate with the object. Default is the value of IDispatch
;                  $tagInterface - [optional] String defining the methods of the Interface, see Remarks for _AutoItObject_WrapperCreate function for details
;                  $fWrapped - [optional] Specifies whether to wrapp created object.
; Return values .: Success      - Dispatch-Object
;                  Failure      - 0
; Author ........: trancexx
; Modified.......:
; Remarks .......: This function doesn't require any additional registration of the classes and interaces supported in the server module.
;                 +In case $tagInterface is specified $fWrapp parameter is ignored.
;                 +If $sRefId is left default then first supported interface by the coclass is returned (the default dispatch).
;                 +
;                 +If used to for ROT objects $sModule parameter represents the full path to the server (any form: exe, a3x or au3). Default time-out value for the function is 3000ms in that case. If required object isn't created in that time function will return failure.
;                 +This function sends "/StartServer" command to the server to initialize it.
; Related .......: _AutoItObject_ObjCreate, _AutoItObject_WrapperCreate
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _AutoItObject_ObjCreateEx($sModule, $sID, $sRefId = Default, $tagInterface = Default, $fWrapp = False, $iTimeOut = Default)
	Local $sTypeRef = "wstr"
	If $sRefId = Default Or Not $sRefId Then $sTypeRef = "ptr"
	Local $sTypeTag = "wstr"
	If $tagInterface = Default Or Not $tagInterface Then
		$sTypeTag = "ptr"
	Else
		$fWrapp = True
	EndIf
	If $iTimeOut = Default Then $iTimeOut = 0
	Local $aCall = DllCall($ghAutoItObjectDLL, "idispatch", "AutoItObjectCreateObjectEx", "wstr", $sModule, "wstr", $sID, $sTypeRef, $sRefId, $sTypeTag, __Au3Obj_GetMethods($tagInterface), "bool", $fWrapp, "dword", $iTimeOut)
	If @error Or Not IsObj($aCall[0]) Then Return SetError(1, 0, 0)
	If Not $fWrapp Then _AutoItObject_IUnknownRelease($aCall[0])
	Return $aCall[0]
EndFunc   ;==>_AutoItObject_ObjCreateEx

; #FUNCTION# ====================================================================================================================
; Name...........: _AutoItObject_ObjectFromDtag
; Description ...: Creates custom object defined with "dtag" interface description string
; Syntax.........: _AutoItObject_ObjectFromDtag($sFunctionPrefix, $dtagInterface [, $fNoUnknown = False])
; Parameters ....: $sFunctionPrefix  - The prefix of the functions you define as object methods
;                  $dtagInterface - string describing the interface (dtag)
;                  $fNoUnknown - [optional] NOT an IUnkown-Interface. Do not call "Release" method when out of scope (Default: False, meaining to call Release method)
; Return values .: Success      - object type
;                  Failure      - 0
; Author ........: trancexx
; Modified.......:
; Remarks .......: Main purpose of this function is to create custom objects that serve as event handlers for other objects.
;                  +Registered callback functions (defined methods) are left for AutoIt to free at its convenience on exit.
; Related .......: _AutoItObject_ObjCreate, _AutoItObject_ObjCreateEx, _AutoItObject_WrapperCreate
; Link ..........: http://msdn.microsoft.com/en-us/library/ms692727(VS.85).aspx
; Example .......:
; ===============================================================================================================================
Func _AutoItObject_ObjectFromDtag($sFunctionPrefix, $dtagInterface, $fNoUnknown = False)
	Local $sMethods = __Au3Obj_GetMethods($dtagInterface)
	$sMethods = StringReplace(StringReplace(StringReplace(StringReplace($sMethods, "object", "idispatch"), "variant*", "ptr"), "hresult", "long"), "bstr", "ptr")
	Local $aMethods = StringSplit($sMethods, @LF, 3)
	Local $iUbound = UBound($aMethods)
	Local $sMethod, $aSplit, $sNamePart, $aTagPart, $sTagPart, $sRet, $sParams
	; Allocation. Read http://msdn.microsoft.com/en-us/library/ms810466.aspx to see why like this (object + methods):
	Local $tInterface = DllStructCreate("ptr[" & $iUbound + 1 & "]", __Au3Obj_CoTaskMemAlloc($__Au3Obj_PTR_SIZE * ($iUbound + 1)))
	If @error Then Return SetError(1, 0, 0)
	For $i = 0 To $iUbound - 1
		$aSplit = StringSplit($aMethods[$i], "|", 2)
		If UBound($aSplit) <> 2 Then ReDim $aSplit[2]
		$sNamePart = $aSplit[0]
		$sTagPart = $aSplit[1]
		$sMethod = $sFunctionPrefix & $sNamePart
		$aTagPart = StringSplit($sTagPart, ";", 2)
		$sRet = $aTagPart[0]
		$sParams = StringReplace($sTagPart, $sRet, "", 1)
		$sParams = "ptr" & $sParams
		DllStructSetData($tInterface, 1, DllCallbackGetPtr(DllCallbackRegister($sMethod, $sRet, $sParams)), $i + 2) ; Freeing is left to AutoIt.
	Next
	DllStructSetData($tInterface, 1, DllStructGetPtr($tInterface) + $__Au3Obj_PTR_SIZE) ; Interface method pointers are actually pointer size away
	Return _AutoItObject_WrapperCreate(DllStructGetPtr($tInterface), $dtagInterface, $fNoUnknown, True) ; and first pointer is object pointer that's wrapped
EndFunc   ;==>_AutoItObject_ObjectFromDtag

; #FUNCTION# ====================================================================================================================
; Name...........: _AutoItObject_PtrToIDispatch
; Description ...: Converts IDispatch pointer to AutoIt's object type
; Syntax.........: _AutoItObject_PtrToIDispatch($pIDispatch)
; Parameters ....: $pIDispatch  - IDispatch pointer
; Return values .: Success      - object type
;                  Failure      - 0
; Author ........: monoceres, trancexx
; Modified.......:
; Remarks .......:
; Related .......: _AutoItObject_IDispatchToPtr, _AutoItObject_WrapperCreate
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _AutoItObject_PtrToIDispatch($pIDispatch)
	Local $aCall = DllCall($ghAutoItObjectDLL, "idispatch", "ReturnThis", "ptr", $pIDispatch)
	If @error Then Return SetError(1, 0, 0)
	Return $aCall[0]
EndFunc   ;==>_AutoItObject_PtrToIDispatch

; #FUNCTION# ====================================================================================================================
; Name...........: _AutoItObject_RegisterObject
; Description ...: Registers the object to ROT
; Syntax.........: _AutoItObject_RegisterObject($vObject, $sID)
; Parameters ....: $vObject - Object or object pointer.
;                  $sID - Object's desired identifier.
; Return values .: Success      - Handle of the ROT object.
;                  Failure      - 0
; Author ........: trancexx
; Modified.......:
; Remarks .......:
; Related .......: _AutoItObject_UnregisterObject
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _AutoItObject_RegisterObject($vObject, $sID)
	Local $sTypeObj = "ptr"
	If IsObj($vObject) Then $sTypeObj = "idispatch"
	Local $aCall = DllCall($ghAutoItObjectDLL, "dword", "RegisterObject", $sTypeObj, $vObject, "wstr", $sID)
	If @error Or Not $aCall[0] Then Return SetError(1, 0, 0)
	Return $aCall[0]
EndFunc   ;==>_AutoItObject_RegisterObject

; #FUNCTION# ====================================================================================================================
; Name...........: _AutoItObject_RemoveMember
; Description ...: Removes a property or a function from an AutoIt-object
; Syntax.........: _AutoItObject_RemoveMember(ByRef $oObject, $sMember)
; Parameters ....: $oObject     - the object to modify
;                  $sMember     - the name of the member to remove
; Return values .: Success      - True
;                  Failure      - 0
; Author ........: Prog@ndy
; Modified.......:
; Remarks .......:
; Related .......: _AutoItObject_AddMethod, _AutoItObject_AddProperty, _AutoItObject_AddEnum
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _AutoItObject_RemoveMember(ByRef $oObject, $sMember)
	; Author: Prog@ndy
	If Not IsObj($oObject) Then Return SetError(2, 0, 0)
	If $sMember = '__default__' Then Return SetError(3, 0, 0)
	DllCall($ghAutoItObjectDLL, "none", "RemoveMember", "idispatch", $oObject, "wstr", $sMember)
	If @error Then Return SetError(1, @error, 0)
	Return True
EndFunc   ;==>_AutoItObject_RemoveMember

; #FUNCTION# ====================================================================================================================
; Name...........: _AutoItObject_Shutdown
; Description ...: frees the AutoItObject DLL
; Syntax.........: _AutoItObject_Shutdown()
; Parameters ....: $fFinal    - [optional] Force shutdown of the library? (Default: False)
; Return values .: Remaining reference count (one for each call to _AutoItObject_Startup)
; Author ........: Prog@ndy
; Modified.......:
; Remarks .......: Usage of this function is optonal. The World wouldn't end without it.
; Related .......: _AutoItObject_Startup
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _AutoItObject_Shutdown($fFinal = False)
	; Author: Prog@ndy
	If $giAutoItObjectDLLRef <= 0 Then Return 0
	$giAutoItObjectDLLRef -= 1
	If $fFinal Then $giAutoItObjectDLLRef = 0
	If $giAutoItObjectDLLRef = 0 Then DllCall($ghAutoItObjectDLL, "ptr", "Initialize", "ptr", 0, "ptr", 0)
	Return $giAutoItObjectDLLRef
EndFunc   ;==>_AutoItObject_Shutdown

; #FUNCTION# ====================================================================================================================
; Name...........: _AutoItObject_Startup
; Description ...: Initializes AutoItObject
; Syntax.........: _AutoItObject_Startup( [$fLoadDLL = False [, $sDll = "AutoitObject.dll"]] )
; Parameters ....: $fLoadDLL    - [optional] specifies whether an external DLL-file should be used (default: False)
;                  $sDLL        - [optional] the path to the external DLL (default: AutoitObject.dll or AutoitObject_X64.dll)
; Return values .: Success      - True
;                  Failure      - False
; Author ........: trancexx, Prog@ndy
; Modified.......:
; Remarks .......: Automatically switches between 32bit and 64bit mode if no special DLL is specified.
; Related .......: _AutoItObject_Shutdown
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _AutoItObject_Startup($fLoadDLL = False, $sDll = "AutoitObject.dll")
	Local Static $__Au3Obj_FunctionProxy = DllCallbackGetPtr(DllCallbackRegister("__Au3Obj_FunctionProxy", "int", "wstr;idispatch"))
	Local Static $__Au3Obj_EnumFunctionProxy = DllCallbackGetPtr(DllCallbackRegister("__Au3Obj_EnumFunctionProxy", "int", "dword;wstr;idispatch;ptr;ptr"))
	If $ghAutoItObjectDLL = -1 Then
		If $fLoadDLL Then
			If $__Au3Obj_X64 And @NumParams = 1 Then $sDll = "AutoItObject_X64.dll"
			$ghAutoItObjectDLL = DllOpen($sDll)
		Else
			$ghAutoItObjectDLL = __Au3Obj_Mem_DllOpen()
		EndIf
		If $ghAutoItObjectDLL = -1 Then Return SetError(1, 0, False)
	EndIf
	If $giAutoItObjectDLLRef <= 0 Then
		$giAutoItObjectDLLRef = 0
		DllCall($ghAutoItObjectDLL, "ptr", "Initialize", "ptr", $__Au3Obj_FunctionProxy, "ptr", $__Au3Obj_EnumFunctionProxy)
		If @error Then
			DllClose($ghAutoItObjectDLL)
			$ghAutoItObjectDLL = -1
			Return SetError(2, 0, False)
		EndIf
	EndIf
	$giAutoItObjectDLLRef += 1
	Return True
EndFunc   ;==>_AutoItObject_Startup

; #FUNCTION# ====================================================================================================================
; Name...........: _AutoItObject_UnregisterObject
; Description ...: Unregisters the object from ROT
; Syntax.........: _AutoItObject_UnregisterObject($iHandle)
; Parameters ....: $iHandle - Object's ROT handle as returned by _AutoItObject_RegisterObject function.
; Return values .: Success      - 1
;                  Failure      - 0
; Author ........: trancexx
; Modified.......:
; Remarks .......:
; Related .......: _AutoItObject_RegisterObject
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _AutoItObject_UnregisterObject($iHandle)
	Local $aCall = DllCall($ghAutoItObjectDLL, "dword", "UnRegisterObject", "dword", $iHandle)
	If @error Or Not $aCall[0] Then Return SetError(1, 0, 0)
	Return 1
EndFunc   ;==>_AutoItObject_UnregisterObject

; #FUNCTION# ====================================================================================================================
; Name...........: _AutoItObject_VariantClear
; Description ...: Clears the value of a variant
; Syntax.........: _AutoItObject_VariantClear($pvarg)
; Parameters ....: $pvarg       - the VARIANT to clear
; Return values .: Success      - 0
;                  Failure      - nonzero
; Author ........: Prog@ndy
; Modified.......:
; Remarks .......:
; Related .......: _AutoItObject_VariantFree
; Link ..........: http://msdn.microsoft.com/en-us/library/ms221165.aspx
; Example .......:
; ===============================================================================================================================
Func _AutoItObject_VariantClear($pvarg)
	; Author: Prog@ndy
	Local $aCall = DllCall($gh_AU3Obj_oleautdll, "long", "VariantClear", "ptr", $pvarg)
	If @error Then Return SetError(1, 0, 1)
	Return $aCall[0]
EndFunc   ;==>_AutoItObject_VariantClear

; #FUNCTION# ====================================================================================================================
; Name...........: _AutoItObject_VariantCopy
; Description ...: Copies a VARIANT to another
; Syntax.........: _AutoItObject_VariantCopy($pvargDest, $pvargSrc)
; Parameters ....: $pvargDest   - Destionation variant
;                  $pvargSrc    - Source variant
; Return values .: Success      - 0
;                  Failure      - nonzero
; Author ........: Prog@ndy
; Modified.......:
; Remarks .......:
; Related .......: _AutoItObject_VariantRead
; Link ..........: http://msdn.microsoft.com/en-us/library/ms221697.aspx
; Example .......:
; ===============================================================================================================================
Func _AutoItObject_VariantCopy($pvargDest, $pvargSrc)
	; Author: Prog@ndy
	Local $aCall = DllCall($gh_AU3Obj_oleautdll, "long", "VariantCopy", "ptr", $pvargDest, 'ptr', $pvargSrc)
	If @error Then Return SetError(1, 0, 1)
	Return $aCall[0]
EndFunc   ;==>_AutoItObject_VariantCopy

; #FUNCTION# ====================================================================================================================
; Name...........: _AutoItObject_VariantFree
; Description ...: Frees a variant created by _AutoItObject_VariantSet
; Syntax.........: _AutoItObject_VariantFree($pvarg)
; Parameters ....: $pvarg       - the VARIANT to free
; Return values .: Success      - 0
;                  Failure      - nonzero
; Author ........: Prog@ndy
; Modified.......:
; Remarks .......: Use this function on variants created with _AutoItObject_VariantSet function (when first parameter for that function is 0).
; Related .......: _AutoItObject_VariantClear
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _AutoItObject_VariantFree($pvarg)
	; Author: Prog@ndy
	Local $aCall = DllCall($gh_AU3Obj_oleautdll, "long", "VariantClear", "ptr", $pvarg)
	If @error Then Return SetError(1, 0, 1)
	If $aCall[0] = 0 Then __Au3Obj_CoTaskMemFree($pvarg)
	Return $aCall[0]
EndFunc   ;==>_AutoItObject_VariantFree

; #FUNCTION# ====================================================================================================================
; Name...........: _AutoItObject_VariantInit
; Description ...: Initializes a variant.
; Syntax.........: _AutoItObject_VariantInit($pvarg)
; Parameters ....: $pvarg       - the VARIANT to initialize
; Return values .: Success      - 0
;                  Failure      - nonzero
; Author ........: Prog@ndy
; Modified.......:
; Remarks .......:
; Related .......: _AutoItObject_VariantClear
; Link ..........: http://msdn.microsoft.com/en-us/library/ms221402.aspx
; Example .......:
; ===============================================================================================================================
Func _AutoItObject_VariantInit($pvarg)
	; Author: Prog@ndy
	Local $aCall = DllCall($gh_AU3Obj_oleautdll, "long", "VariantInit", "ptr", $pvarg)
	If @error Then Return SetError(1, 0, 1)
	Return $aCall[0]
EndFunc   ;==>_AutoItObject_VariantInit

; #FUNCTION# ====================================================================================================================
; Name...........: _AutoItObject_VariantRead
; Description ...: Reads the value of a VARIANT
; Syntax.........: _AutoItObject_VariantRead($pVariant)
; Parameters ....: $pVariant    - Pointer to VARaINT-structure
; Return values .: Success      - value of the VARIANT
;                  Failure      - 0
; Author ........: monoceres, Prog@ndy
; Modified.......:
; Remarks .......:
; Related .......: _AutoItObject_VariantSet
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _AutoItObject_VariantRead($pVariant)
	; Author: monoceres, Prog@ndy
	Local $var = DllStructCreate($__Au3Obj_tagVARIANT, $pVariant), $data
	; Translate the vt id to a autoit dllcall type
	Local $VT = DllStructGetData($var, "vt"), $type
	Switch $VT
		Case $__Au3Obj_VT_I1, $__Au3Obj_VT_UI1
			$type = "byte"
		Case $__Au3Obj_VT_I2
			$type = "short"
		Case $__Au3Obj_VT_I4
			$type = "int"
		Case $__Au3Obj_VT_I8
			$type = "int64"
		Case $__Au3Obj_VT_R4
			$type = "float"
		Case $__Au3Obj_VT_R8
			$type = "double"
		Case $__Au3Obj_VT_UI2
			$type = 'word'
		Case $__Au3Obj_VT_UI4
			$type = 'uint'
		Case $__Au3Obj_VT_UI8
			$type = 'uint64'
		Case $__Au3Obj_VT_BSTR
			Return __Au3Obj_SysReadString(DllStructGetData($var, "data"))
		Case $__Au3Obj_VT_BOOL
			$type = 'short'
		Case BitOR($__Au3Obj_VT_ARRAY, $__Au3Obj_VT_UI1)
			Local $pSafeArray = DllStructGetData($var, "data")
			Local $bound, $pData, $lbound
			If 0 = __Au3Obj_SafeArrayGetUBound($pSafeArray, 1, $bound) Then
				__Au3Obj_SafeArrayGetLBound($pSafeArray, 1, $lbound)
				$bound += 1 - $lbound
				If 0 = __Au3Obj_SafeArrayAccessData($pSafeArray, $pData) Then
					Local $tData = DllStructCreate("byte[" & $bound & "]", $pData)
					$data = DllStructGetData($tData, 1)
					__Au3Obj_SafeArrayUnaccessData($pSafeArray)
				EndIf
			EndIf
			Return $data
		Case BitOR($__Au3Obj_VT_ARRAY, $__Au3Obj_VT_VARIANT)
			Return __Au3Obj_ReadSafeArrayVariant(DllStructGetData($var, "data"))
		Case $__Au3Obj_VT_DISPATCH
			Return _AutoItObject_PtrToIDispatch(DllStructGetData($var, "data"))
		Case $__Au3Obj_VT_PTR
			Return DllStructGetData($var, "data")
		Case $__Au3Obj_VT_ERROR
			Return Default
		Case Else
			Return SetError(1, 0, '')
	EndSwitch

	$data = DllStructCreate($type, DllStructGetPtr($var, "data"))

	Switch $VT
		Case $__Au3Obj_VT_BOOL
			Return DllStructGetData($data, 1) <> 0
	EndSwitch
	Return DllStructGetData($data, 1)

EndFunc   ;==>_AutoItObject_VariantRead

; #FUNCTION# ====================================================================================================================
; Name...........: _AutoItObject_VariantSet
; Description ...: sets the value of a varaint or creates a new one.
; Syntax.........: _AutoItObject_VariantSet($pVar, $vVal, $iSpecialType = 0)
; Parameters ....: $pVar        - Pointer to the VARIANT to modify (0 if you want to create it new)
;                  $vVal        - Value of the VARIANT
;                  $iSpecialType - [optional] Modify the automatic type. NOT FOR GENERAL USE!
; Return values .: Success      - Pointer to the VARIANT
;                  Failure      - 0
; Author ........: monoceres, Prog@ndy
; Modified.......:
; Remarks .......:
; Related .......: _AutoItObject_VariantRead
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _AutoItObject_VariantSet($pVar, $vVal, $iSpecialType = 0)
	; Author: monoceres, Prog@ndy
	If Not $pVar Then
		$pVar = __Au3Obj_CoTaskMemAlloc($__Au3Obj_VARIANT_SIZE)
		_AutoItObject_VariantInit($pVar)
	Else
		_AutoItObject_VariantClear($pVar)
	EndIf
	Local $tVar = DllStructCreate($__Au3Obj_tagVARIANT, $pVar)
	Local $iType = $__Au3Obj_VT_EMPTY, $vDataType = ''

	Switch VarGetType($vVal)
		Case "Int32"
			$iType = $__Au3Obj_VT_I4
			$vDataType = 'int'
		Case "Int64"
			$iType = $__Au3Obj_VT_I8
			$vDataType = 'int64'
		Case "String", 'Text'
			$iType = $__Au3Obj_VT_BSTR
			$vDataType = 'ptr'
			$vVal = __Au3Obj_SysAllocString($vVal)
		Case "Double"
			$vDataType = 'double'
			$iType = $__Au3Obj_VT_R8
		Case "Float"
			$vDataType = 'float'
			$iType = $__Au3Obj_VT_R4
		Case "Bool"
			$vDataType = 'short'
			$iType = $__Au3Obj_VT_BOOL
			If $vVal Then
				$vVal = 0xffff
			Else
				$vVal = 0
			EndIf
		Case 'Ptr'
			If $__Au3Obj_X64 Then
				$iType = $__Au3Obj_VT_UI8
			Else
				$iType = $__Au3Obj_VT_UI4
			EndIf
			$vDataType = 'ptr'
		Case 'Object'
			_AutoItObject_IUnknownAddRef($vVal)
			$vDataType = 'ptr'
			$iType = $__Au3Obj_VT_DISPATCH
		Case "Binary"
			; ARRAY OF BYTES !
			Local $tSafeArrayBound = DllStructCreate($__Au3Obj_tagSAFEARRAYBOUND)
			DllStructSetData($tSafeArrayBound, 1, BinaryLen($vVal))
			Local $pSafeArray = __Au3Obj_SafeArrayCreate($__Au3Obj_VT_UI1, 1, DllStructGetPtr($tSafeArrayBound))
			Local $pData
			If 0 = __Au3Obj_SafeArrayAccessData($pSafeArray, $pData) Then
				Local $tData = DllStructCreate("byte[" & BinaryLen($vVal) & "]", $pData)
				DllStructSetData($tData, 1, $vVal)
				__Au3Obj_SafeArrayUnaccessData($pSafeArray)
				$vVal = $pSafeArray
				$vDataType = 'ptr'
				$iType = BitOR($__Au3Obj_VT_ARRAY, $__Au3Obj_VT_UI1)
			EndIf
		Case "Array"
			$vDataType = 'ptr'
			$vVal = __Au3Obj_CreateSafeArrayVariant($vVal)
			$iType = BitOR($__Au3Obj_VT_ARRAY, $__Au3Obj_VT_VARIANT)
		Case Else ;"Keyword" ; all keywords and unknown Vartypes will be handled as "default"
			$iType = $__Au3Obj_VT_ERROR
			$vDataType = 'int'
	EndSwitch
	If $vDataType Then
		DllStructSetData(DllStructCreate($vDataType, DllStructGetPtr($tVar, 'data')), 1, $vVal)

		If @NumParams = 3 Then $iType = $iSpecialType
		DllStructSetData($tVar, 'vt', $iType)
	EndIf
	Return $pVar
EndFunc   ;==>_AutoItObject_VariantSet

; #FUNCTION# ====================================================================================================================
; Name...........: _AutoItObject_WrapperAddMethod
; Description ...: Adds additional methods to the Wrapper-Object, e.g if you want alternative parameter types
; Syntax.........: _AutoItObject_WrapperAddMethod(ByRef $oWrapper, $sReturnType, $sName, $sParamTypes, $ivtableIndex)
; Parameters ....: $oWrapper     - The Object you want to modify
;                  $sReturnType  - the return type of the function
;                  $sName        - The name of the function
;                  $sParamTypes  - the parameter types
;                  $ivTableIndex - Index of the function in the object's vTable
; Return values .: Success      - True
;                  Failure      - 0
; Author ........: Prog@ndy
; Modified.......:
; Remarks .......:
; Related .......: _AutoItObject_WrapperCreate
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _AutoItObject_WrapperAddMethod(ByRef $oWrapper, $sReturnType, $sName, $sParamTypes, $ivtableIndex)
	; Author: Prog@ndy
	If Not IsObj($oWrapper) Then Return SetError(2, 0, 0)
	DllCall($ghAutoItObjectDLL, "none", "WrapperAddMethod", 'idispatch', $oWrapper, 'wstr', $sName, "wstr", StringRegExpReplace($sReturnType & ';' & $sParamTypes, "\s|(;+\Z)", ''), 'dword', $ivtableIndex)
	If @error Then Return SetError(1, @error, 0)
	Return True
EndFunc   ;==>_AutoItObject_WrapperAddMethod

; #FUNCTION# ====================================================================================================================
; Name...........: _AutoItObject_WrapperCreate
; Description ...: Creates an IDispatch-Object for COM-Interfaces normally not supporting it.
; Syntax.........: _AutoItObject_WrapperCreate($pUnknown, $tagInterface [, $fNoUnknown = False [, $fCallFree = False]])
; Parameters ....: $pUnknown     - Pointer to an IUnknown-Interface not supporting IDispatch
;                  $tagInterface - String defining the methods of the Interface, see Remarks for details
;                  $fNoUnknown   - [optional] $pUnknown is NOT an IUnkown-Interface. Do not release when out of scope (Default: False)
;                  $fCallFree   - [optional] Internal parameter. Do not use.
; Return values .: Success      - Dispatch-Object
;                  Failure      - 0, @error set
; Author ........: Prog@ndy
; Modified.......:
; Remarks .......: $tagInterface can be a string in the following format (dtag):
;                  +  "FunctionName ReturnType(ParamType1;ParamType2);FunctionName2 ..."
;                  +    - FunctionName is the name of the function you want to call later
;                  +    - ReturnType is the return type (like DLLCall)
;                  +    - ParamType is the type of the parameter (like DLLCall) [do not include the THIS-param]
;                  +
;                  +Alternative Format where only method names are listed (ltag) results in different format for calling the functions/methods later. You must specify the datatypes in the call then:
;                  +  $oObject.function("returntype", "1stparamtype", $1stparam, "2ndparamtype", $2ndparam, ...)
;                  +
;                  +The reuturn value of a call is always an array (except an error occured, then it's 0):
;                  +  - $array[0] - containts the return value
;                  +  - $array[n] - containts the n-th parameter
; Related .......: _AutoItObject_WrapperAddMethod
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _AutoItObject_WrapperCreate($pUnknown, $tagInterface, $fNoUnknown = False, $fCallFree = False)
	If Not $pUnknown Then Return SetError(1, 0, 0)
	Local $sMethods = __Au3Obj_GetMethods($tagInterface)
	Local $aResult
	If $sMethods Then
		$aResult = DllCall($ghAutoItObjectDLL, "idispatch", "CreateWrapperObjectEx", 'ptr', $pUnknown, 'wstr', $sMethods, "bool", $fNoUnknown, "bool", $fCallFree)
	Else
		$aResult = DllCall($ghAutoItObjectDLL, "idispatch", "CreateWrapperObject", 'ptr', $pUnknown, "bool", $fNoUnknown)
	EndIf
	If @error Then Return SetError(2, @error, 0)
	Return $aResult[0]
EndFunc   ;==>_AutoItObject_WrapperCreate

#EndRegion Public UDFs
;--------------------------------------------------------------------------------------------------------------------------------------