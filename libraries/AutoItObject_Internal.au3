#cs
# AutoItObject Internal
# @author genius257
# @version 2.0.0
#ce

#include-once
#include <Memory.au3>
#include <WinAPISys.au3>

If Not IsDeclared("IID_IUnknown") Then Global Const $IID_IUnknown = "{00000000-0000-0000-C000-000000000046}"
If Not IsDeclared("IID_IDispatch") Then Global Const $IID_IDispatch = "{00020400-0000-0000-C000-000000000046}"
If Not IsDeclared("IID_IConnectionPointContainer") Then Global Const $IID_IConnectionPointContainer = "{B196B284-BAB4-101A-B69C-00AA00341D07}"

If Not IsDeclared("DISPATCH_METHOD") Then Global Const $DISPATCH_METHOD =               1
If Not IsDeclared("DISPATCH_PROPERTYGET") Then Global Const $DISPATCH_PROPERTYGET =          2
If Not IsDeclared("DISPATCH_PROPERTYPUT") Then Global Const $DISPATCH_PROPERTYPUT =          4
If Not IsDeclared("DISPATCH_PROPERTYPUTREF") Then Global Const $DISPATCH_PROPERTYPUTREF =       8

;~ If Not IsDeclared("S_OK") Then Global Const $S_OK = 0x00000000
;~ If Not IsDeclared("E_NOTIMPL") Then Global Const $E_NOTIMPL = 0x80004001
;~ If Not IsDeclared("E_NOINTERFACE") Then Global Const $E_NOINTERFACE = 0x80004002
;~ If Not IsDeclared("E_POINTER") Then Global Const $E_POINTER = 0x80004003
;~ If Not IsDeclared("E_ABORT") Then Global Const $E_ABORT = 0x80004004
;~ If Not IsDeclared("E_FAIL") Then Global Const $E_FAIL = 0x80004005
;~ If Not IsDeclared("E_ACCESSDENIED") Then Global Const $E_ACCESSDENIED = 0x80070005
;~ If Not IsDeclared("E_HANDLE") Then Global Const $E_HANDLE = 0x80070006
;~ If Not IsDeclared("E_OUTOFMEMORY") Then Global Const $E_OUTOFMEMORY = 0x8007000E
;~ If Not IsDeclared("E_INVALIDARG") Then Global Const $E_INVALIDARG = 0x80070057
;~ If Not IsDeclared("E_UNEXPECTED") Then Global Const $E_UNEXPECTED = 0x8000FFFF

If Not IsDeclared("DISP_E_UNKNOWNINTERFACE") Then Global Const $DISP_E_UNKNOWNINTERFACE = 0x80020001
If Not IsDeclared("DISP_E_MEMBERNOTFOUND") Then Global Const $DISP_E_MEMBERNOTFOUND = 0x80020003
If Not IsDeclared("DISP_E_PARAMNOTFOUND") Then Global Const $DISP_E_PARAMNOTFOUND = 0x80020004
If Not IsDeclared("DISP_E_TYPEMISMATCH") Then Global Const $DISP_E_TYPEMISMATCH = 0x80020005
If Not IsDeclared("DISP_E_UNKNOWNNAME") Then Global Const $DISP_E_UNKNOWNNAME = 0x80020006
If Not IsDeclared("DISP_E_NONAMEDARGS") Then Global Const $DISP_E_NONAMEDARGS = 0x80020007
If Not IsDeclared("DISP_E_BADVARTYPE") Then Global Const $DISP_E_BADVARTYPE = 0x80020008
If Not IsDeclared("DISP_E_EXCEPTION") Then Global Const $DISP_E_EXCEPTION = 0x80020009
If Not IsDeclared("DISP_E_OVERFLOW") Then Global Const $DISP_E_OVERFLOW = 0x8002000A
If Not IsDeclared("DISP_E_BADINDEX") Then Global Const $DISP_E_BADINDEX = 0x8002000B
If Not IsDeclared("DISP_E_UNKNOWNLCID") Then Global Const $DISP_E_UNKNOWNLCID = 0x8002000C
If Not IsDeclared("DISP_E_ARRAYISLOCKED") Then Global Const $DISP_E_ARRAYISLOCKED = 0x8002000D
If Not IsDeclared("DISP_E_BADPARAMCOUNT") Then Global Const $DISP_E_BADPARAMCOUNT = 0x8002000E
If Not IsDeclared("DISP_E_PARAMNOTOPTIONAL") Then Global Const $DISP_E_PARAMNOTOPTIONAL = 0x8002000F
If Not IsDeclared("DISP_E_BADCALLEE") Then Global Const $DISP_E_BADCALLEE = 0x80020010
If Not IsDeclared("DISP_E_NOTACOLLECTION") Then Global Const $DISP_E_NOTACOLLECTION = 0x80020011

Global Const $tagVARIANT = "ushort vt;ushort r1;ushort r2;ushort r3;PTR data;PTR data2"
Global Const $tagDISPPARAMS = "ptr rgvargs;ptr rgdispidNamedArgs;dword cArgs;dword cNamedArgs;"

Global Const $__AOI_LOCK_CREATE = 1
Global Const $__AOI_LOCK_UPDATE = 2
Global Const $__AOI_LOCK_DELETE = 4
Global Const $__AOI_LOCK_CASE = 8

Global Enum $VT_EMPTY,$VT_NULL,$VT_I2,$VT_I4,$VT_R4,$VT_R8,$VT_CY,$VT_DATE,$VT_BSTR,$VT_DISPATCH, _
	$VT_ERROR,$VT_BOOL,$VT_VARIANT,$VT_UNKNOWN,$VT_DECIMAL,$VT_I1=16,$VT_UI1,$VT_UI2,$VT_UI4,$VT_I8, _
	$VT_UI8,$VT_INT,$VT_UINT,$VT_VOID,$VT_HRESULT,$VT_PTR,$VT_SAFEARRAY,$VT_CARRAY,$VT_USERDEFINED, _
	$VT_LPSTR,$VT_LPWSTR,$VT_RECORD=36,$VT_FILETIME=64,$VT_BLOB,$VT_STREAM,$VT_STORAGE,$VT_STREAMED_OBJECT, _
	$VT_STORED_OBJECT,$VT_BLOB_OBJECT,$VT_CF,$VT_CLSID,$VT_BSTR_BLOB=0xfff,$VT_VECTOR=0x1000, _
	$VT_ARRAY=0x2000,$VT_BYREF=0x4000,$VT_RESERVED=0x8000,$VT_ILLEGAL=0xffff,$VT_ILLEGALMASKED=0xfff, _
	$VT_TYPEMASK=0xfff

Global Const $tagProperty = "ptr Name;ptr Variant;ptr __getter;ptr __setter;ptr Next"

Func IDispatch($QueryInterface=QueryInterface, $AddRef=AddRef, $Release=Release, $GetTypeInfoCount=GetTypeInfoCount, $GetTypeInfo=GetTypeInfo, $GetIDsOfNames=GetIDsOfNames, $Invoke=Invoke)
	Local $tagObject = "int RefCount;int Size;ptr Object;ptr Methods[7];int_ptr Callbacks[7];ptr Properties;BYTE lock;PTR __destructor"
	Local $tObject = DllStructCreate($tagObject)

	$QueryInterface = DllCallbackRegister($QueryInterface, "LONG", "ptr;ptr;ptr")
	DllStructSetData($tObject, "Methods", DllCallbackGetPtr($QueryInterface), 1)
	DllStructSetData($tObject, "Callbacks", $QueryInterface, 1)

	$AddRef = DllCallbackRegister($AddRef, "dword", "PTR")
	DllStructSetData($tObject, "Methods", DllCallbackGetPtr($AddRef), 2)
	DllStructSetData($tObject, "Callbacks", $AddRef, 2)

	$Release = DllCallbackRegister($Release, "dword", "PTR")
	DllStructSetData($tObject, "Methods", DllCallbackGetPtr($Release), 3)
	DllStructSetData($tObject, "Callbacks", $Release, 3)

	$GetTypeInfoCount = DllCallbackRegister($GetTypeInfoCount, "long", "ptr;ptr")
	DllStructSetData($tObject, "Methods", DllCallbackGetPtr($GetTypeInfoCount), 4)
	DllStructSetData($tObject, "Callbacks", $GetTypeInfoCount, 4)

	$GetTypeInfo = DllCallbackRegister($GetTypeInfo, "long", "ptr;uint;int;ptr")
	DllStructSetData($tObject, "Methods", DllCallbackGetPtr($GetTypeInfo), 5)
	DllStructSetData($tObject, "Callbacks", $GetTypeInfo, 5)

	$GetIDsOfNames = DllCallbackRegister($GetIDsOfNames, "long", "ptr;ptr;ptr;uint;int;ptr")
	DllStructSetData($tObject, "Methods", DllCallbackGetPtr($GetIDsOfNames), 6)
	DllStructSetData($tObject, "Callbacks", $GetIDsOfNames, 6)

	$Invoke = DllCallbackRegister($Invoke, "long", "ptr;int;ptr;int;ushort;ptr;ptr;ptr;ptr")
	DllStructSetData($tObject, "Methods", DllCallbackGetPtr($Invoke), 7)
	DllStructSetData($tObject, "Callbacks", $Invoke, 7)

	DllStructSetData($tObject, "RefCount", 1) ; initial ref count is 1
	DllStructSetData($tObject, "Size", 7) ; number of interface methods

	Local $pData = MemCloneGlob($tObject)

	Local $tObject = DllStructCreate($tagObject, $pData)

	DllStructSetData($tObject, "Object", DllStructGetPtr($tObject, "Methods")) ; Interface method pointers
	Return ObjCreateInterface(DllStructGetPtr($tObject, "Object"), $IID_IDispatch, Default, True) ; pointer that's wrapped into object
EndFunc

#cs
# @internal
#ce
Func QueryInterface($pSelf, $pRIID, $pObj)
	If $pObj=0 Then Return $E_POINTER
	Local $sGUID=DllCall("ole32.dll", "int", "StringFromGUID2", "PTR", $pRIID, "wstr", "", "int", 40)[2]
	If (Not ($sGUID=$IID_IDispatch)) And (Not ($sGUID=$IID_IUnknown)) Then Return $E_NOINTERFACE
	Local $tStruct = DllStructCreate("ptr", $pObj)
	DllStructSetData($tStruct, 1, $pSelf)
	AddRef($pSelf)
	Return $S_OK
EndFunc

#cs
# @internal
#ce
Func AddRef($pSelf)
   Local $tStruct = DllStructCreate("int Ref", $pSelf-8)
   $tStruct.Ref += 1
   Return $tStruct.Ref
EndFunc

#cs
# @internal
#ce
Func Release($pSelf)
	Local $i
	Local $tStruct = DllStructCreate("int Ref", $pSelf-8)
	$tStruct.Ref -= 1
	If $tStruct.Ref = 0 Then; initiate garbage collection
		Local $pDescructor = DllStructGetData(DllStructCreate("PTR", $pSelf + __AOI_GetPtrOffset("__destructor")),1)
		If Not ($pDescructor=0) Then;TODO
			Local $tVARIANT = DllStructCreate($tagVARIANT, $pDescructor)
			DllStructSetData(DllStructCreate("PTR", $pSelf + __AOI_GetPtrOffset("__destructor")),1,0)
			Local $IDispatch = IDispatch()
			$IDispatch.a=0
			Local $pProperty = DllStructGetData(DllStructCreate("PTR", Ptr($IDispatch) + (@AutoItX64?8:4) + (@AutoItX64?8:4)*7*2),1)
			Local $pVARIANT = DllStructGetData(DllStructCreate($tagProperty, $pProperty),"Variant")
			VariantClear($pVARIANT)
			VariantCopy($pVARIANT, $tVARIANT)
			Local $f__destructor = $IDispatch.a
			VariantClear($pVARIANT)
			DllStructSetData(DllStructCreate("INT", $pSelf-4-4), 1, DllStructGetData(DllStructCreate("INT", $pSelf-4-4), 1)+1)
			Local $tVARIANT = DllStructCreate($tagVARIANT, $pVARIANT)
			$tVARIANT.vt = $VT_DISPATCH
			$tVARIANT.data = $pSelf
			Call($f__destructor, $IDispatch.a)
			VariantClear($pVARIANT)
			$IDispatch=0
		EndIf
		DllStructSetData(DllStructCreate("BYTE", $pSelf + (@AutoItX64?8:4) + (@AutoItX64?8:4)*7*2 + (@AutoItX64?8:4)),1,1);lock
		Local $pProperty = DllStructGetData(DllStructCreate("ptr", $pSelf + (@AutoItX64?8:4) + (@AutoItX64?8:4)*7*2),1);get first property
		DllStructSetData(DllStructCreate("ptr", $pSelf + (@AutoItX64?8:4) + (@AutoItX64?8:4)*7*2),1,0);detatch properties from object
		While 1;releases all properties
			If $pProperty=0 Then ExitLoop
			Local $tProperty = DllStructCreate($tagProperty, $pProperty)
			Local $_pProperty = $pProperty
			$pProperty = $tProperty.Next
			If Not ($tProperty.__getter=0) Then
				VariantClear($tProperty.__getter)
				_MemGlobalFree(GlobalHandle($tProperty.__getter))
			EndIf
			If Not ($tProperty.__setter=0) Then
				VariantClear($tProperty.__setter)
				_MemGlobalFree(GlobalHandle($tProperty.__setter))
			EndIf
			VariantClear($tProperty.Variant)
			_MemGlobalFree(GlobalHandle($tProperty.Variant))
			_WinAPI_FreeMemory($tProperty.Name)
			$tProperty=0
			_MemGlobalFree(GlobalHandle($_pProperty))
		WEnd
		Local $pMethods = $pSelf + (@AutoItX64?8:4)
		_MemGlobalFree(GlobalHandle($pSelf-8))
		Return 0
	EndIf
	Return $tStruct.Ref
EndFunc

#cs
# @internal
#ce
Func GetIDsOfNames($pSelf, $riid, $rgszNames, $cNames, $lcid, $rgDispId)
	Local $tIds = DllStructCreate("long", $rgDispId); 2,147,483,647 properties available to define, per object. And 2,147,483,647 private properties to set in the negative space, per object.
	Local $pProperty = DllStructGetData(DllStructCreate("ptr", $pSelf + __AOI_GetPtrOffset("Properties")),1)
	Local $tProperty = 0
	Local $iSize2

	Local $pStr = DllStructGetData(DllStructCreate("ptr", $rgszNames), 1)
	Local $iSize = _WinAPI_StrLen($pStr, True)
	If $iSize = 0 Then
		$iSize = 1
	EndIf
	Local $t_rgszNames = DllStructCreate("WCHAR["&$iSize&"]", $pStr)
	Local $s_rgszName = DllStructGetData($t_rgszNames, 1)

	Switch $s_rgszName
		Case "__assign"
			DllStructSetData($tIds, 1, -2)
		Case "__isExtensible"
			DllStructSetData($tIds, 1, -3)
		Case "__case"
			DllStructSetData($tIds, 1, -4)
		Case "__freeze"
			DllStructSetData($tIds, 1, -5)
		Case "__isFrozen"
			DllStructSetData($tIds, 1, -6)
		Case "__isSealed"
			DllStructSetData($tIds, 1, -7)
		Case "__keys"
			DllStructSetData($tIds, 1, -8)
		Case "__preventExtensions"
			DllStructSetData($tIds, 1, -9)
		Case "__defineGetter"
			DllStructSetData($tIds, 1, -10)
		Case "__defineSetter"
			DllStructSetData($tIds, 1, -11)
		Case "__lookupGetter"
			DllStructSetData($tIds, 1, -12)
		Case "__lookupSetter"
			DllStructSetData($tIds, 1, -13)
		Case "__seal"
			DllStructSetData($tIds, 1, -14)
		Case "__destructor"
			DllStructSetData($tIds, 1, -16)
		Case "__unset"
			DllStructSetData($tIds, 1, -17)
		Case "__get"
			DllStructSetData($tIds, 1, -18)
		Case "__set"
			DllStructSetData($tIds, 1, -19)
		Case "__exists"
			DllStructSetData($tIds, 1, -20)
		Case Else
			DllStructSetData($tIds, 1, -1)
	EndSwitch
	If DllStructGetData($tIds, 1) <> -1 Then Return $S_OK

	Local $iLock = __AOI_GetPtrValue($pSelf + __AOI_GetPtrOffset("lock"), "BYTE")
	Local $bCase = Not (BitAND($iLock, $__AOI_LOCK_CASE)>0)
	Local $pProperty = __AOI_PropertyGetFromName(__AOI_GetPtrValue($pSelf + __AOI_GetPtrOffset("Properties"), "ptr"), DllStructGetData($t_rgszNames, 1), $bCase)
	Local $iID = @error<>0?-1:@extended
	Local $iIndex = @extended

	If ($iID=-1) And BitAND($iLock, $__AOI_LOCK_CREATE)=0 Then
		Local $pData = __AOI_PropertyCreate(DllStructGetData($t_rgszNames, 1))
		If $iIndex = -1 Then;first item in list
			DllStructSetData(DllStructCreate("ptr", $pSelf + __AOI_GetPtrOffset("Properties")), 1, $pData)
		Else
			$tProperty = DllStructCreate($tagProperty, $pProperty)
			$tProperty.next = $pData
		EndIf
		$iID = $iIndex+1
	EndIf

	If $iID=-1 Then Return $DISP_E_UNKNOWNNAME
	$iID += 1
	DllStructSetData($tIds, 1, $iID)
	Return $S_OK
EndFunc

#cs
# @internal
#ce
Func GetTypeInfo($pSelf, $iTInfo, $lcid, $ppTInfo)
	If $iTInfo<>0 Then Return $DISP_E_BADINDEX
	If $ppTInfo=0 Then Return $E_INVALIDARG
	Return $S_OK
EndFunc

#cs
# @internal
#ce
Func GetTypeInfoCount($pSelf, $pctinfo)
	DllStructSetData(DllStructCreate("UINT",$pctinfo),1, 0)
	Return $S_OK
EndFunc

#cs
# @internal
#ce
Func Invoke($pSelf, $dispIdMember, $riid, $lcid, $wFlags, $pDispParams, $pVarResult, $pExcepInfo, $puArgErr)
	If $dispIdMember = 0 Then
		Local $iLock = __AOI_GetPtrValue($pSelf + __AOI_GetPtrOffset("lock"), "BYTE")
		Local $bCase = Not (BitAND($iLock, $__AOI_LOCK_CASE)>0)
		__AOI_PropertyGetFromName(__AOI_GetPtrValue($pSelf + __AOI_GetPtrOffset("Properties"), "ptr"), "", $bCase)
		$dispIdMember = @error<>0?-1:(@extended + 1)
	EndIf
	If $dispIdMember=-1 Then Return $DISP_E_MEMBERNOTFOUND
	Local $tVARIANT, $_tVARIANT, $tDISPPARAMS
	Local $t
	Local $i

	Local $pProperty = DllStructGetData(DllStructCreate("ptr", $pSelf + __AOI_GetPtrOffset("Properties")),1)
	Local $tProperty = DllStructCreate($tagProperty, $pProperty)

	If $dispIdMember<-1 Then
		If $dispIdMember=-3 Then;__isExtensible
			Local $iLock = __AOI_GetPtrValue($pSelf + __AOI_GetPtrOffset("lock"), "BYTE")
			Local $iExtensible = $__AOI_LOCK_CREATE
			$tVARIANT = DllStructCreate($tagVARIANT, $pVarResult)
			$tVARIANT.vt = $VT_BOOL
			$tVARIANT.data = (BitAND($iLock, $iExtensible) = $iExtensible)?1:0
			Return $S_OK
		EndIf

		If $dispIdMember=-4 Then;__case
			$tDISPPARAMS = DllStructCreate($tagDISPPARAMS, $pDispParams)
			If (Not(BitAND($wFlags, $DISPATCH_PROPERTYGET)=0)) Then
				If $tDISPPARAMS.cArgs<>0 Then Return $DISP_E_BADPARAMCOUNT
				$tVARIANT=DllStructCreate($tagVARIANT, $pVarResult)
				$tVARIANT.vt = $VT_BOOL
				Local $iLock = __AOI_GetPtrValue($pSelf + __AOI_GetPtrOffset("lock"), "BYTE")
				$tVARIANT.data = (BitAND($iLock, $__AOI_LOCK_CASE)>0)?0:1
			Else; $DISPATCH_PROPERTYPUT
				If $tDISPPARAMS.cArgs<>1 Then Return $DISP_E_BADPARAMCOUNT
				$tVARIANT=DllStructCreate($tagVARIANT, $tDISPPARAMS.rgvargs)
				If $tVARIANT.vt<>$VT_BOOL Then Return $DISP_E_BADVARTYPE
				Local $iLock = __AOI_GetPtrValue($pSelf + __AOI_GetPtrOffset("lock"), "BYTE")
				If BitAND($iLock, $__AOI_LOCK_UPDATE)>0 Then Return $DISP_E_EXCEPTION
				Local $tLock = DllStructCreate("BYTE", $pSelf + __AOI_GetPtrOffset("lock"))
				$b = DllStructGetData(DllStructCreate($tagVARIANT, $tDISPPARAMS.rgvargs), "data")
				DllStructSetData($tLock, 1, _
					(Not $b) ? BitOR(DllStructGetData($tLock, 1), $__AOI_LOCK_CASE) : BitAND(DllStructGetData($tLock, 1), BitNOT(BitShift(1 , 0-(Log($__AOI_LOCK_CASE)/log(2))))) _
				)

			EndIf
			Return $S_OK
		EndIf

		If $dispIdMember=-13 Then;__lookupSetter
			$tDISPPARAMS = DllStructCreate($tagDISPPARAMS, $pDispParams)
			If $tDISPPARAMS.cArgs<>1 Then Return $DISP_E_BADPARAMCOUNT

			$t = DllStructCreate("ptr id_ptr;long id;ptr str_ptr_ptr;ptr str_ptr")
			DllStructSetData($t, "id_ptr", DllStructGetPtr($t, 2))
			DllStructSetData($t, "str_ptr", $tDISPPARAMS.rgvargs)
			$t.str_ptr = DllStructGetData(DllStructCreate($tagVARIANT, $tDISPPARAMS.rgvargs), "data")
			$t.str_ptr_ptr = DllStructGetPtr($t, "str_ptr")
			If Not GetIDsOfNames($pSelf, $riid, $t.str_ptr_ptr, 1, $lcid, DllStructGetPtr($t, "id")) = $S_OK Then Return $DISP_E_EXCEPTION

			$pProperty = DllStructGetData(DllStructCreate("ptr", $pSelf + __AOI_GetPtrOffset("Properties")),1)
			$tProperty = __AOI_PropertyGetFromId($pProperty, $t.id - 1)
			If Not $tProperty.__setter=0 Then
				VariantClear($pVarResult)
				VariantCopy($pVarResult, $tProperty.__setter)
			EndIf
			Return $S_OK
		EndIf

		If $dispIdMember=-12 Then;__lookupGetter
			$tDISPPARAMS = DllStructCreate($tagDISPPARAMS, $pDispParams)
			If $tDISPPARAMS.cArgs<>1 Then Return $DISP_E_BADPARAMCOUNT

			$t = DllStructCreate("ptr id_ptr;long id;ptr str_ptr_ptr;ptr str_ptr")
			DllStructSetData($t, "id_ptr", DllStructGetPtr($t, 2))
			DllStructSetData($t, "str_ptr", $tDISPPARAMS.rgvargs)
			$t.str_ptr = DllStructGetData(DllStructCreate($tagVARIANT, $tDISPPARAMS.rgvargs), "data")
			$t.str_ptr_ptr = DllStructGetPtr($t, "str_ptr")
			If Not GetIDsOfNames($pSelf, $riid, $t.str_ptr_ptr, 1, $lcid, DllStructGetPtr($t, "id")) = $S_OK Then Return $DISP_E_EXCEPTION

			$pProperty = DllStructGetData(DllStructCreate("ptr", $pSelf + __AOI_GetPtrOffset("Properties")),1)
			$tProperty = __AOI_PropertyGetFromId($pProperty, $t.id - 1)
			If Not $tProperty.__getter=0 Then
				VariantClear($pVarResult)
				VariantCopy($pVarResult, $tProperty.__getter)
			EndIf
			Return $S_OK
		EndIf

		If $dispIdMember=-2 Then;__assign
			Local $iLock = __AOI_GetPtrValue($pSelf + __AOI_GetPtrOffset("lock"), "BYTE")
			If BitAND($iLock, $__AOI_LOCK_CREATE)>0 Then Return $DISP_E_EXCEPTION


			$tDISPPARAMS = DllStructCreate($tagDISPPARAMS, $pDispParams)
			If $tDISPPARAMS.cArgs=0 Then Return $DISP_E_BADPARAMCOUNT

			Local $tVARIANT = DllStructCreate($tagVARIANT)
			Local $iVARIANT = DllStructGetSize($tVARIANT)
			Local $i
			Local $pExternalProperty, $tExternalProperty
			Local $pProperty, $tProperty
			Local $iID, $iIndex, $pData
			For $i=$tDISPPARAMS.cArgs-1 To 0 Step -1
				$tVARIANT=DllStructCreate($tagVARIANT, $tDISPPARAMS.rgvargs+$iVARIANT*$i)
				If Not (DllStructGetData($tVARIANT, "vt")=$VT_DISPATCH) Then Return $DISP_E_BADVARTYPE
				$pExternalProperty = __AOI_GetPtrValue(DllStructGetData($tVARIANT, "data") + __AOI_GetPtrOffset("Properties"), "ptr")
				While 1
					If $pExternalProperty = 0 Then ExitLoop
					$tExternalProperty = DllStructCreate($tagProperty, $pExternalProperty)

					$pProperty = __AOI_PropertyGetFromName(__AOI_GetPtrValue($pSelf + __AOI_GetPtrOffset("Properties"), "ptr"), _WinAPI_GetString($tExternalProperty.Name), False)
					$iID = @error<>0?-1:@extended
					$iIndex = @extended

					If ($iID=-1) Then
						$pData = __AOI_PropertyCreate(_WinAPI_GetString($tExternalProperty.Name))
						$tProperty = DllStructCreate($tagProperty, $pData)
						VariantClear($tProperty.Variant)
						VariantCopy($tProperty.Variant, $tExternalProperty.Variant)

						If $iIndex=-1 Then;first item in list
							DllStructSetData(DllStructCreate("ptr", $pSelf + __AOI_GetPtrOffset("Properties")), 1, $pData)
						Else
							$tProperty = DllStructCreate($tagProperty, $pProperty)
							$tProperty.Next = $pData
						EndIf
					Else
						$tProperty = DllStructCreate($tagProperty, $pProperty)
						VariantClear($tProperty.Variant)
						VariantCopy($tProperty.Variant, $tExternalProperty.Variant)
					EndIf

					$pExternalProperty = $tExternalProperty.Next
				WEnd
			Next
			Return $S_OK
		EndIf

		If $dispIdMember=-7 Then;__isSealed
			Local $iLock = __AOI_GetPtrValue($pSelf + __AOI_GetPtrOffset("lock"), "BYTE")
			Local $iSeal = $__AOI_LOCK_CREATE + $__AOI_LOCK_DELETE
			$tVARIANT = DllStructCreate($tagVARIANT, $pVarResult)
			$tVARIANT.vt = $VT_BOOL
			$tVARIANT.data = (BitAND($iLock, $iSeal) = $iSeal)?1:0
			Return $S_OK
		EndIf

		If $dispIdMember=-6 Then;__isFrozen
			Local $iLock = __AOI_GetPtrValue($pSelf + __AOI_GetPtrOffset("lock"), "BYTE")
			Local $iFreeze = $__AOI_LOCK_CREATE + $__AOI_LOCK_UPDATE + $__AOI_LOCK_DELETE
			$tVARIANT = DllStructCreate($tagVARIANT, $pVarResult)
			$tVARIANT.vt = $VT_BOOL
			$tVARIANT.data = (BitAND($iLock, $iFreeze) = $iFreeze)?1:0
			Return $S_OK
		EndIf

		If $dispIdMember=-18 Then;__get
			$tDISPPARAMS = DllStructCreate($tagDISPPARAMS, $pDispParams)
			If $tDISPPARAMS.cArgs<>1 Then Return $DISP_E_BADPARAMCOUNT
			$tVARIANT = DllStructCreate($tagVARIANT, $tDISPPARAMS.rgvargs)
			If $tVARIANT.vt<>$VT_BSTR Then Return $DISP_E_BADVARTYPE
			$t = DllStructCreate("ptr id_ptr;long id;ptr str_ptr_ptr;ptr str_ptr")
			DllStructSetData($t, "id_ptr", DllStructGetPtr($t, 2))
			DllStructSetData($t, "str_ptr", $tDISPPARAMS.rgvargs)
			$t.str_ptr = DllStructGetData($tVARIANT, "data")
			$t.str_ptr_ptr = DllStructGetPtr($t, "str_ptr")
			If Not GetIDsOfNames($pSelf, 0, $t.str_ptr_ptr, 1, $lcid, DllStructGetPtr($t, "id")) = $S_OK Then Return $DISP_E_EXCEPTION
			Return Invoke($pSelf, $t.id, $riid, $lcid, $DISPATCH_PROPERTYGET, $pDispParams, $pVarResult, $pExcepInfo, $puArgErr)
		EndIf

		If $dispIdMember=-19 Then;__set
			$tDISPPARAMS = DllStructCreate($tagDISPPARAMS, $pDispParams)
			If $tDISPPARAMS.cArgs<>2 Then Return $DISP_E_BADPARAMCOUNT
			$tVARIANT = DllStructCreate($tagVARIANT, $tDISPPARAMS.rgvargs+DllStructGetSize(DllStructCreate($tagVARIANT)))
			If $tVARIANT.vt<>$VT_BSTR Then Return $DISP_E_BADVARTYPE
			$t = DllStructCreate("ptr id_ptr;long id;ptr str_ptr_ptr;ptr str_ptr")
			DllStructSetData($t, "id_ptr", DllStructGetPtr($t, 2))
			$t.str_ptr = DllStructGetData($tVARIANT, "data")
			$t.str_ptr_ptr = DllStructGetPtr($t, "str_ptr")
			If Not GetIDsOfNames($pSelf, 0, $t.str_ptr_ptr, 1, $lcid, DllStructGetPtr($t, "id")) = $S_OK Then Return $DISP_E_EXCEPTION
			$tDISPPARAMS.cArgs=1
			Return Invoke($pSelf, $t.id, $riid, $lcid, $DISPATCH_PROPERTYPUT, $pDispParams, $pVarResult, $pExcepInfo, $puArgErr)
		EndIf

		If $dispIdMember=-20 Then;__exists
			$tDISPPARAMS = DllStructCreate($tagDISPPARAMS, $pDispParams)
			If $tDISPPARAMS.cArgs<>1 Then Return $DISP_E_BADPARAMCOUNT
			$tVARIANT = DllStructCreate($tagVARIANT, $tDISPPARAMS.rgvargs)
			If $tVARIANT.vt<>$VT_BSTR Then Return $DISP_E_BADVARTYPE
			Local $sProperty = _WinAPI_GetString($tVARIANT.data);the string to search for
			$tVARIANT = DllStructCreate($tagVARIANT, $pVarResult)
			$tVARIANT.vt = $VT_BOOL
			Local $iLock = __AOI_GetPtrValue($pSelf + __AOI_GetPtrOffset("lock"), "BYTE")
			Local $bCase = Not (BitAND($iLock, $__AOI_LOCK_CASE)>0)
			Local $pProperty = __AOI_PropertyGetFromName(__AOI_GetPtrValue($pSelf + __AOI_GetPtrOffset("Properties"), "ptr"), $sProperty, $bCase)
			$tVARIANT.data = @error<>0?0:1
			Return $S_OK
		EndIf

		If $dispIdMember=-16 Then;__destructor
			Local $iLock = __AOI_GetPtrValue($pSelf + __AOI_GetPtrOffset("lock"), "BYTE")
			If BitAND($iLock, $__AOI_LOCK_CREATE)>0 Then Return $DISP_E_EXCEPTION
			$tDISPPARAMS = DllStructCreate($tagDISPPARAMS, $pDispParams)
			If $tDISPPARAMS.cArgs<>1 Then Return $DISP_E_BADPARAMCOUNT
			If (Not (DllStructGetData(DllStructCreate($tagVARIANT, $tDISPPARAMS.rgvargs),"vt")=$VT_RECORD)) And (Not (DllStructGetData(DllStructCreate($tagVARIANT, $tDISPPARAMS.rgvargs),"vt")=$VT_BSTR)) Then Return $DISP_E_BADVARTYPE
			Local $tVARIANT = DllStructCreate($tagVARIANT)
			Local $pVARIANT = MemCloneGlob($tVARIANT)
			$tVARIANT = DllStructCreate($tagVARIANT, $pVARIANT)
			VariantInit($pVARIANT)
			VariantCopy($pVARIANT, $tDISPPARAMS.rgvargs)
			DllStructSetData(DllStructCreate("PTR", $pSelf + __AOI_GetPtrOffset("__destructor")),1,$pVARIANT)
			Return $S_OK
		EndIf

		If $dispIdMember=-5 Then;__freeze
			$tDISPPARAMS = DllStructCreate($tagDISPPARAMS, $pDispParams)
			If $tDISPPARAMS.cArgs<>0 Then Return $DISP_E_BADPARAMCOUNT
			Local $tLock = DllStructCreate("BYTE", $pSelf + __AOI_GetPtrOffset("lock"))
			DllStructSetData($tLock, 1, BitOR(DllStructGetData($tLock, 1), $__AOI_LOCK_CREATE + $__AOI_LOCK_DELETE + $__AOI_LOCK_UPDATE))
			Return $S_OK
		EndIf

		If $dispIdMember=-14 Then;__seal
			$tDISPPARAMS = DllStructCreate($tagDISPPARAMS, $pDispParams)
			If $tDISPPARAMS.cArgs<>0 Then Return $DISP_E_BADPARAMCOUNT
			Local $tLock = DllStructCreate("BYTE", $pSelf + __AOI_GetPtrOffset("lock"))
			DllStructSetData($tLock, 1, BitOR(DllStructGetData($tLock, 1), $__AOI_LOCK_CREATE + $__AOI_LOCK_DELETE))
			Return $S_OK
		EndIf

		If $dispIdMember=-9 Then;__preventExtensions
			$tDISPPARAMS = DllStructCreate($tagDISPPARAMS, $pDispParams)
			If $tDISPPARAMS.cArgs<>0 Then Return $DISP_E_BADPARAMCOUNT
			Local $tLock = DllStructCreate("BYTE", $pSelf + __AOI_GetPtrOffset("lock"))
			DllStructSetData($tLock, 1, BitOR(DllStructGetData($tLock, 1), $__AOI_LOCK_CREATE))
			Return $S_OK
		EndIf

		If $dispIdMember=-17 Then;__unset
			Local $iLock = __AOI_GetPtrValue($pSelf + __AOI_GetPtrOffset("lock"), "BYTE")
			If BitAND($iLock, $__AOI_LOCK_DELETE)>0 Then Return $DISP_E_EXCEPTION

			$tDISPPARAMS = DllStructCreate($tagDISPPARAMS, $pDispParams)
			If $tDISPPARAMS.cArgs<>1 Then Return $DISP_E_BADPARAMCOUNT
			$tVARIANT = DllStructCreate($tagVARIANT, $tDISPPARAMS.rgvargs)
			If Not($VT_BSTR=$tVARIANT.vt) Then Return $DISP_E_BADVARTYPE
			Local $sProperty = _WinAPI_GetString($tVARIANT.data);the string to search for
			Local $tProperty=0,$tProperty_Prev
			While 1
				If $pProperty=0 Then ExitLoop
				$tProperty_Prev = $tProperty
				$tProperty = DllStructCreate($tagProperty, $pProperty)
				Local $bCase = Not (BitAND($iLock, $__AOI_LOCK_CASE)>0)
				If ($bCase And _WinAPI_GetString($tProperty.Name)==$sProperty) Or ((Not $bCase) And _WinAPI_GetString($tProperty.Name)=$sProperty) Then
					If $tProperty_Prev=0 Then
						DllStructSetData(DllStructCreate("ptr", $pSelf + __AOI_GetPtrOffset("Properties")), 1, $tProperty.Next)
					Else
						$tProperty_Prev.Next = $tProperty.next
					EndIf
					VariantClear($tProperty.Variant)
					_MemGlobalFree(GlobalHandle($tProperty.Variant))
					$tProperty = 0
					_MemGlobalFree(GlobalHandle($pProperty))
					Return $S_OK
				EndIf
				$pProperty = $tProperty.Next
			WEnd
			Return $DISP_E_MEMBERNOTFOUND
		EndIf

		If ($dispIdMember=-8) Then;__keys
			Local $aKeys[0]
			Local $pProperty = DllStructGetData(DllStructCreate("ptr", $pSelf + __AOI_GetPtrOffset("Properties")),1)
			While 1
				If $pProperty=0 Then ExitLoop
				Local $tProperty = DllStructCreate($tagProperty, $pProperty)
				ReDim $aKeys[UBound($aKeys,1)+1]
				$aKeys[UBound($aKeys,1)-1] = DllStructGetData(DllStructCreate("WCHAR["&_WinAPI_StrLen($tProperty.Name)&"]", $tProperty.Name), 1)
				If $tProperty.next=0 Then ExitLoop
				$pProperty = $tProperty.next
			WEnd
			Local $oIDispatch = IDispatch()
			$oIDispatch.a=$aKeys
			VariantClear($pVarResult)
			VariantCopy($pVarResult, DllStructGetData(DllStructCreate($tagProperty, DllStructGetData(DllStructCreate("ptr", Ptr($oIDispatch) + __AOI_GetPtrOffset("Properties")),1)), "Variant"))
			$oIDispatch=0
			Return $S_OK
		EndIf

		If ($dispIdMember=-10) Then;__defineGetter
			Local $iLock = __AOI_GetPtrValue($pSelf + __AOI_GetPtrOffset("lock"), "BYTE")
			If BitAND($iLock, $__AOI_LOCK_CREATE)>0 Then Return $DISP_E_EXCEPTION

			$tDISPPARAMS = DllStructCreate($tagDISPPARAMS, $pDispParams)
			If $tDISPPARAMS.cArgs<>2 Then Return $DISP_E_BADPARAMCOUNT
			$tVARIANT = DllStructCreate($tagVARIANT, $tDISPPARAMS.rgvargs)
			If Not (($tVARIANT.vt=$VT_RECORD) Or ($tVARIANT.vt=$VT_BSTR)) Then Return $DISP_E_BADVARTYPE
			Local $tVARIANT2 = DllStructCreate($tagVARIANT, $tDISPPARAMS.rgvargs+DllStructGetSize($tVARIANT))
			If Not ($tVARIANT2.vt=$VT_BSTR) Then Return $DISP_E_BADVARTYPE

			$tDISPPARAMS = DllStructCreate($tagDISPPARAMS, $pDispParams)
			$t = DllStructCreate("ptr id_ptr;long id;ptr str_ptr_ptr;ptr str_ptr")
			DllStructSetData($t, "id_ptr", DllStructGetPtr($t, 2))
			DllStructSetData($t, "str_ptr", $tDISPPARAMS.rgvargs+DllStructGetSize(DllStructCreate($tagVARIANT)))
			$t.str_ptr = DllStructGetData(DllStructCreate($tagVARIANT, $tDISPPARAMS.rgvargs+DllStructGetSize(DllStructCreate($tagVARIANT))), "data")
			$t.str_ptr_ptr = DllStructGetPtr($t, "str_ptr")
			GetIDsOfNames($pSelf, 0, $t.str_ptr_ptr, 1, $lcid, DllStructGetPtr($t, "id"))

			$pProperty = DllStructGetData(DllStructCreate("ptr", $pSelf + __AOI_GetPtrOffset("Properties")),1)
			$tProperty = __AOI_PropertyGetFromId($pProperty, $t.id - 1)

			If ($tProperty.__getter=0) Then
				Local $tVARIANT_Getter = DllStructCreate($tagVARIANT)
				$pVARIANT_Getter = MemCloneGlob($tVARIANT_Getter)
				VariantInit($pVARIANT_Getter)
			Else
				Local $pVARIANT_Getter = $tProperty.__getter
				VariantClear($pVARIANT_Getter)
			EndIf
			$tVARIANT = DllStructCreate($tagVARIANT, $tDISPPARAMS.rgvargs)
			VariantCopy($pVARIANT_Getter, $tVARIANT)
			$tProperty.__getter = $pVARIANT_Getter
			Return $S_OK
		ElseIf ($dispIdMember=-11) Then;defineSetter
			Local $iLock = __AOI_GetPtrValue($pSelf + __AOI_GetPtrOffset("lock"), "BYTE")
			If BitAND($iLock, $__AOI_LOCK_CREATE)>0 Then Return $DISP_E_EXCEPTION

			$tDISPPARAMS = DllStructCreate($tagDISPPARAMS, $pDispParams)
			If $tDISPPARAMS.cArgs<>2 Then Return $DISP_E_BADPARAMCOUNT
			$tVARIANT = DllStructCreate($tagVARIANT, $tDISPPARAMS.rgvargs)
			If Not (($tVARIANT.vt=$VT_RECORD) Or ($tVARIANT.vt=$VT_BSTR)) Then Return $DISP_E_BADVARTYPE
			Local $tVARIANT2 = DllStructCreate($tagVARIANT, $tDISPPARAMS.rgvargs+DllStructGetSize($tVARIANT))
			If Not ($tVARIANT2.vt=$VT_BSTR) Then Return $DISP_E_BADVARTYPE

			$tDISPPARAMS = DllStructCreate($tagDISPPARAMS, $pDispParams)
			$t = DllStructCreate("ptr id_ptr;long id;ptr str_ptr_ptr;ptr str_ptr")
			DllStructSetData($t, "id_ptr", DllStructGetPtr($t, 2))
			DllStructSetData($t, "str_ptr", $tDISPPARAMS.rgvargs+DllStructGetSize(DllStructCreate($tagVARIANT)))
			$t.str_ptr = DllStructGetData(DllStructCreate($tagVARIANT, $tDISPPARAMS.rgvargs+DllStructGetSize(DllStructCreate($tagVARIANT))), "data")
			$t.str_ptr_ptr = DllStructGetPtr($t, "str_ptr")
			GetIDsOfNames($pSelf, 0, $t.str_ptr_ptr, 1, $lcid, DllStructGetPtr($t, "id"))

			$pProperty = DllStructGetData(DllStructCreate("ptr", $pSelf + __AOI_GetPtrOffset("Properties")),1)
			$tProperty = DllStructCreate($tagProperty, $pProperty)

			$tVARIANT = DllStructCreate($tagVARIANT, $tDISPPARAMS.rgvargs)
			For $i=1 To $t.id - 1
				$pProperty = $tProperty.Next
				$tProperty = DllStructCreate($tagProperty, $pProperty)
			Next
			If ($tProperty.__setter=0) Then
				Local $tVARIANT_Setter = DllStructCreate($tagVARIANT)
				Local $pVARIANT_Setter = MemCloneGlob($tVARIANT_Setter)
				VariantInit($pVARIANT_Setter)
			Else
				Local $pVARIANT_Setter = $tProperty.__setter
				VariantClear($pVARIANT_Setter)
			EndIf
			VariantCopy($pVARIANT_Setter, $tVARIANT)
			$tProperty.__setter = $pVARIANT_Setter
			Return $S_OK
		EndIf
		Return $DISP_E_EXCEPTION
	EndIf

	For $i=1 To $dispIdMember-1
		$pProperty = $tProperty.Next
		$tProperty = DllStructCreate($tagProperty, $pProperty)
	Next

	$tVARIANT = DllStructCreate($tagVARIANT, $tProperty.Variant)

	If (Not(BitAND($wFlags, $DISPATCH_PROPERTYGET)=0)) Then
		$_tVARIANT = DllStructCreate($tagVARIANT, $pVarResult)
		If Not($tProperty.__getter = 0) Then
			$tDISPPARAMS = DllStructCreate($tagDISPPARAMS, $pDispParams)
			Local $oIDispatch = IDispatch()
			$oIDispatch.val = 0
			$oIDispatch.ret = 0
			DllStructSetData(DllStructCreate("INT", $pSelf-4-4), 1, DllStructGetData(DllStructCreate("INT", $pSelf-4-4), 1)+1)
			$oIDispatch.parent = 0
			Local $tProperty02 = DllStructCreate($tagProperty, DllStructGetData(DllStructCreate("ptr", ptr($oIDispatch) + __AOI_GetPtrOffset("Properties")),1))
			$tProperty02=DllStructCreate($tagProperty, $tProperty02.Next)
			$tProperty02=DllStructCreate($tagProperty, $tProperty02.Next)
			$tVARIANT = DllStructCreate($tagVARIANT, $tProperty02.Variant)
			$tVARIANT.vt = $VT_DISPATCH
			$tVARIANT.data = $pSelf
			$oIDispatch.arguments = IDispatch();
			$oIDispatch.arguments.length=$tDISPPARAMS.cArgs
			Local $aArguments[$tDISPPARAMS.cArgs], $iArguments=$tDISPPARAMS.cArgs-1
			Local $_pProperty = DllStructGetData(DllStructCreate("ptr", Ptr($oIDispatch) + __AOI_GetPtrOffset("Properties")),1)
			Local $_tProperty = DllStructCreate($tagProperty, $_pProperty)
			For $i=0 To $iArguments
				VariantClear($_tProperty.Variant)
				VariantCopy($_tProperty.Variant, $tDISPPARAMS.rgvargs+(($iArguments-$i)*DllStructGetSize($_tVARIANT)))
				$aArguments[$i]=$oIDispatch.val
			Next
			$oIDispatch.arguments.values=$aArguments
			$oIDispatch.arguments.__seal()
			$oIDispatch.__defineSetter("parent", PrivateProperty)
			VariantClear($_tProperty.Variant)
			VariantCopy($_tProperty.Variant, $tProperty.__getter)
			Local $fGetter = $oIDispatch.val
			VariantClear($_tProperty.Variant)
			VariantCopy($_tProperty.Variant, $tProperty.Variant)
			$oIDispatch.__seal()
			Local $mRet = Call($fGetter, $oIDispatch)
			Local $iError = @error, $iExtended = @extended
			VariantClear($tProperty.Variant)
			VariantCopy($tProperty.Variant, $_tProperty.Variant)
			$oIDispatch.ret = $mRet
			$_tProperty = DllStructCreate($tagProperty, $_tProperty.Next)
			VariantCopy($pVarResult, $_tProperty.Variant)
			$oIDispatch=0
			Return ($iError<>0)?$DISP_E_EXCEPTION:$S_OK
			Return $S_OK
		EndIf

		VariantCopy($pVarResult, $tVARIANT)
		Return $S_OK
	Else; ~ $DISPATCH_PROPERTYPUT
		$tDISPPARAMS = DllStructCreate($tagDISPPARAMS, $pDispParams)
		If Not ($tProperty.__setter=0) Then
			Local $oIDispatch = IDispatch()
			$oIDispatch.val = 0
			$oIDispatch.ret = 0
			DllStructSetData(DllStructCreate("INT", $pSelf-4-4), 1, DllStructGetData(DllStructCreate("INT", $pSelf-4-4), 1)+1)
			$oIDispatch.parent = 0
			Local $tProperty02 = DllStructCreate($tagProperty, DllStructGetData(DllStructCreate("ptr", ptr($oIDispatch) + __AOI_GetPtrOffset("Properties")),1))
			$tProperty02=DllStructCreate($tagProperty, $tProperty02.Next)
			$tProperty02=DllStructCreate($tagProperty, $tProperty02.Next)
			$tVARIANT = DllStructCreate($tagVARIANT, $tProperty02.Variant)
			$tVARIANT.vt = $VT_DISPATCH
			$tVARIANT.data = $pSelf
			Local $_pProperty = DllStructGetData(DllStructCreate("ptr", Ptr($oIDispatch) + __AOI_GetPtrOffset("Properties")),1)
			Local $_tProperty = DllStructCreate($tagProperty, $_pProperty)
			Local $_tProperty2 = DllStructCreate($tagProperty, $_tProperty.Next)
			VariantClear($_tProperty.Variant)
			VariantCopy($_tProperty.Variant, $tProperty.__setter)
			VariantClear($_tProperty2.Variant)
			VariantCopy($_tProperty2.Variant, $tDISPPARAMS.rgvargs)
			Local $fSetter = $oIDispatch.val
			VariantClear($_tProperty.Variant)
			VariantCopy($_tProperty.Variant, $tProperty.Variant)
			$oIDispatch.__seal()
			Local $mRet = Call($fSetter, $oIDispatch)
			Local $iError = @error, $iExtended = @extended
			VariantClear($tProperty.Variant)
			VariantCopy($tProperty.Variant, $_tProperty.Variant)
			$oIDispatch.ret = $mRet
			$_tProperty = DllStructCreate($tagProperty, $_tProperty.Next)
			VariantCopy($pVarResult, $_tProperty.Variant)
			$oIDispatch=0
			Return ($iError<>0)?$DISP_E_EXCEPTION:$S_OK
			Return $S_OK
		EndIf

		Local $iLock = __AOI_GetPtrValue($pSelf + __AOI_GetPtrOffset("lock"), "BYTE")
		If BitAND($iLock, $__AOI_LOCK_UPDATE)>0 Then Return $DISP_E_EXCEPTION

		$_tVARIANT = DllStructCreate($tagVARIANT, $tDISPPARAMS.rgvargs)
		VariantClear($tVARIANT)
		VariantCopy($tVARIANT, $_tVARIANT)
	EndIf
	Return $S_OK
EndFunc

Func MemCloneGlob($tObject);clones DllStruct to Global memory and return pointer to new allocated memory
   Local $iSize = DllStructGetSize($tObject)
   Local $hData = _MemGlobalAlloc($iSize, $GMEM_MOVEABLE)
   Local $pData = _MemGlobalLock($hData)
   _MemMoveMemory(DllStructGetPtr($tObject), $pData, $iSize)
   Return $pData
EndFunc

Func GlobalHandle($pMem)
   Local $aRet = DllCall("Kernel32.dll", "ptr", "GlobalHandle", "ptr", $pMem)
   If @error<>0 Then Return SetError(@error, @extended, 0)
   If $aRet[0]=0 Then Return SetError(-1, @extended, 0)
   Return $aRet[0]
EndFunc

Func LocalSize($hMem)
	Local $aRet = DllCall("Kernel32.dll", "UINT", "LocalSize", "handle", $hMem)
	If @error<>0 Then Return SetError(@error, @extended, 0)
	If $aRet[0]=0 Then Return SetError(-1, @extended, 0)
	Return $aRet[0]
EndFunc

Func LocalHandle($pMem)
	Local $aRet = DllCall("Kernel32.dll", "handle", "LocalHandle", "ptr", $pMem)
	If @error<>0 Then Return SetError(@error, @extended, 0)
	If $aRet[0]=0 Then Return SetError(-1, @extended, 0)
	Return $aRet[0]
EndFunc

Func HeapSize($hHeap, $dwFlags, $lpMem)
	Local $aRet = DllCall("Kernel32.dll", "ULONG_PTR", "HeapSize", "handle", $hHeap, "dword", $dwFlags, "LONG_PTR", $lpMem)
	If @error<>0 Then Return SetError(@error, @extended, 0)
	If $aRet[0]=0 Then Return SetError(-1, @extended, 0)
	Return $aRet[0]
EndFunc

Func GetProcessHeap()
	Local $aRet = DllCall("Kernel32.dll", "handle", "GetProcessHeap")
	If @error<>0 Then Return SetError(@error, @extended, 0)
	If $aRet[0]=0 Then Return SetError(-1, @extended, 0)
	Return $aRet[0]
EndFunc

Func VariantInit($tVARIANT)
	Local $aRet=DllCall("OleAut32.dll","LONG","VariantInit",IsDllStruct($tVARIANT)?"struct*":"PTR",$tVARIANT)
	If @error<>0 Then Return SetError(-1, @error, 0)
	If $aRet[0]<>$S_OK Then SetError($aRet, 0, $tVARIANT)
	Return 1
EndFunc

Func VariantCopy($tVARIANT_Dest,$tVARIANT_Src)
	Local $aRet=DllCall("OleAut32.dll","LONG","VariantCopy",IsDllStruct($tVARIANT_Dest)?"struct*":"PTR",$tVARIANT_Dest, IsDllStruct($tVARIANT_Src)?"struct*":"PTR", $tVARIANT_Src)
	If @error<>0 Then Return SetError(-1, @error, 0)
	If $aRet[0]<>$S_OK Then SetError($aRet, 0, 0)
	Return 1
EndFunc

Func VariantClear($tVARIANT)
	Local $aRet=DllCall("OleAut32.dll","LONG","VariantClear",IsDllStruct($tVARIANT)?"struct*":"PTR",$tVARIANT)
	If @error<>0 Then Return SetError(-1, @error, 0)
	If $aRet[0]<>$S_OK Then SetError($aRet, 0, $tVARIANT)
	Return 1
EndFunc

Func VariantChangeType()
	;TODO
EndFunc

Func VariantChangeTypeEx()
	;TODO
EndFunc

Func PrivateProperty()
	Return SetError(1, 1, 0)
EndFunc

#cs
# @internal
#ce
Func __AOI_PropertyGetFromName($pProperty, $sName, $bCase = True)
	Local $iID = -1
	Local $iIndex=-1
	Local $iName = StringLen($sName)
	Local $iPropertyName
	While 1
		If $pProperty=0 Then ExitLoop
		$iIndex+=1
		$tProperty = DllStructCreate($tagProperty, $pProperty)
		$iPropertyName = _WinAPI_StrLen($tProperty.Name, True)
		$sPropertyName = $iPropertyName = 0 ? "" : DllStructGetData(DllStructCreate("WCHAR["&$iPropertyName&"]", $tProperty.Name), 1)
		If ($iPropertyName=$iName) And ( ($bCase And $sPropertyName==$sName) Or ((Not $bCase) And $sPropertyName=$sName) ) Then
			$iID = $iIndex
			ExitLoop
		EndIf
		If $tProperty.next=0 Then ExitLoop
		$pProperty = $tProperty.next
	WEnd
	If $iID=-1 Then Return SetError(1, $iIndex, $pProperty)
	Return SetError(0, $iID, $pProperty)
EndFunc

#cs
# @internal
#ce
Func __AOI_PropertyGetFromId($pProperty, $iID)
	Local $tProperty = DllStructCreate($tagProperty, $pProperty)
	Local $i
	For $i=1 To $iID
		$pProperty = $tProperty.Next
		$tProperty = DllStructCreate($tagProperty, $pProperty)
	Next
	Return $tProperty
EndFunc

#cs
# Create new empty named property
# @internal
# @param String $sName new property name
# @return Pointer new empty property
#ce
Func __AOI_PropertyCreate($sName)
	$tProp = DllStructCreate($tagProperty)
	$pData = MemCloneGlob($tProp)
	$tProp = DllStructCreate($tagProperty, $pData)
		$tProp.Name = _WinAPI_CreateString($sName)
			$tVARIANT = DllStructCreate($tagVARIANT)
			$pVARIANT = MemCloneGlob($tVARIANT)
			$tVARIANT = DllStructCreate($tagVARIANT, $pVARIANT)
			$tVARIANT.vt = $VT_EMPTY
			VariantInit($tVARIANT)
		$tProp.Variant = $pVARIANT
	Return $pData
EndFunc

#cs
# Get IDispatch property pointer offset from Object property in bytes
# @internal
# @param String $sElement struct element name
# @return Integer offset
#ce
Func __AOI_GetPtrOffset($sElement)
	Local Static $tObject = DllStructCreate("int RefCount;int Size;ptr Object;ptr Methods[7];int_ptr Callbacks[7];ptr Properties;BYTE lock;PTR __destructor")
	Local Static $iObject = Int(DllStructGetPtr($tObject, "Object"), @AutoItX64?2:1)
	Return DllStructGetPtr($tObject, $sElement) - $iObject
EndFunc

#cs
# Gets single value from pointer
# @internal
# @param Pointer $pPointer the struct element pointer
# @param String $sElementType struct element specification
# @return Mixed the value of the pointer of type specified by $sElementType
#ce
Func __AOI_GetPtrValue($pPointer, $sElementType)
	Return DllStructGetData(DllStructCreate($sElementType, $pPointer), 1)
EndFunc
