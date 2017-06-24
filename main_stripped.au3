#requireadmin
#NoTrayIcon	;prevent double icon for singleton check
Global $iMsg = _WinAPI_RegisterWindowMessage('newinstance_message')
If _Singleton("Simple IP Config", 1) = 0 Then
_WinAPI_PostMessage(0xffff, $iMsg, 0x101, 0)
Exit
EndIf
Global Const $WS_MINIMIZEBOX = 0x00020000
Global Const $WS_SYSMENU = 0x00080000
Global Const $WS_VSCROLL = 0x00200000
Global Const $WS_CAPTION = 0x00C00000
Global Const $WS_CLIPCHILDREN = 0x02000000
Global Const $WS_CHILD = 0x40000000
Global Const $WS_POPUP = 0x80000000
Global Const $WS_EX_COMPOSITED = 0x02000000
Global Const $WS_EX_TOOLWINDOW = 0x00000080
Global Const $WS_EX_TRANSPARENT = 0x00000020
Global Const $WM_NOTIFY = 0x004E
Global Const $WM_COMMAND = 0x0111
Global Const $GA_PARENT = 1
Global Const $SM_CYMENU = 15
Global Const $SM_CYSIZE = 31
Global Const $COLOR_MENUBAR = 30
Global Const $GUI_SS_DEFAULT_GUI = BitOR($WS_MINIMIZEBOX, $WS_CAPTION, $WS_POPUP, $WS_SYSMENU)
Global Const $GUI_EVENT_CLOSE = -3
Global Const $GUI_EVENT_MINIMIZE = -4
Global Const $GUI_EVENT_RESTORE = -5
Global Const $GUI_EVENT_PRIMARYDOWN = -7
Global Const $GUI_EVENT_PRIMARYUP = -8
Global Const $GUI_RUNDEFMSG = 'GUI_RUNDEFMSG'
Global Const $GUI_CHECKED = 1
Global Const $GUI_UNCHECKED = 4
Global Const $GUI_SHOW = 16
Global Const $GUI_HIDE = 32
Global Const $GUI_ENABLE = 64
Global Const $GUI_DISABLE = 128
Global Const $GUI_FONTUNDER = 4
Global Const $GUI_DOCKALL = 0x0322
Global Const $GUI_BKCOLOR_TRANSPARENT = -2
Global Const $STDIN_CHILD = 1
Global Const $STDERR_MERGED = 8
Global Const $UBOUND_DIMENSIONS = 0
Global Const $UBOUND_ROWS = 1
Global Const $UBOUND_COLUMNS = 2
Global Const $MB_ICONWARNING = 48
Global Const $PROCESS_VM_OPERATION = 0x00000008
Global Const $PROCESS_VM_READ = 0x00000010
Global Const $PROCESS_VM_WRITE = 0x00000020
Global Const $STR_ENTIRESPLIT = 1
Global Const $STR_NOCOUNT = 2
Global Const $STR_REGEXPMATCH = 0
Global Const $TRAY_EVENT_PRIMARYDOWN = -7
Global Const $BS_MULTILINE = 0x2000
Global Const $CBS_AUTOHSCROLL = 0x40
Global Const $CBS_DROPDOWNLIST = 0x3
Global Const $CB_RESETCONTENT = 0x14B
Global Const $CBN_CLOSEUP = 8
Global Const $ES_MULTILINE = 4
Global Const $ES_AUTOVSCROLL = 64
Global Const $ES_NOHIDESEL = 256
Global Const $ES_READONLY = 2048
Global Const $ES_WANTRETURN = 4096
Global Const $EM_SCROLL = 0xB5
Global Const $EM_SCROLLCARET = 0x00B7
Global Const $EM_SETSEL = 0xB1
Global Const $EN_CHANGE = 0x300
Global Const $LVIF_IMAGE = 0x00000002
Global Const $LVIF_PARAM = 0x00000004
Global Const $LVIF_TEXT = 0x00000001
Global Const $LVIS_SELECTED = 0x0002
Global Const $LVS_EDITLABELS = 0x0200
Global Const $LVS_NOCOLUMNHEADER = 0x4000
Global Const $LVS_SHOWSELALWAYS = 0x0008
Global Const $LVS_SINGLESEL = 0x0004
Global Const $GUI_SS_DEFAULT_LISTVIEW = BitOR($LVS_SHOWSELALWAYS, $LVS_SINGLESEL)
Global Const $LVM_FIRST = 0x1000
Global Const $LVM_DELETEALLITEMS =($LVM_FIRST + 9)
Global Const $LVM_DELETEITEM =($LVM_FIRST + 8)
Global Const $LVM_EDITLABELA =($LVM_FIRST + 23)
Global Const $LVM_EDITLABELW =($LVM_FIRST + 118)
Global Const $LVM_EDITLABEL = $LVM_EDITLABELA
Global Const $LVM_GETHEADER =($LVM_FIRST + 31)
Global Const $LVM_GETITEMA =($LVM_FIRST + 5)
Global Const $LVM_GETITEMW =($LVM_FIRST + 75)
Global Const $LVM_GETITEMCOUNT =($LVM_FIRST + 4)
Global Const $LVM_GETITEMSTATE =($LVM_FIRST + 44)
Global Const $LVM_GETUNICODEFORMAT = 0x2000 + 6
Global Const $LVM_INSERTITEMA =($LVM_FIRST + 7)
Global Const $LVM_INSERTITEMW =($LVM_FIRST + 77)
Global Const $LVM_SETCOLUMNWIDTH =($LVM_FIRST + 30)
Global Const $LVM_SETITEMA =($LVM_FIRST + 6)
Global Const $LVM_SETITEMW =($LVM_FIRST + 76)
Global Const $LVN_FIRST = -100
Global Const $LVN_BEGINLABELEDITA =($LVN_FIRST - 5)
Global Const $LVN_BEGINLABELEDITW =($LVN_FIRST - 75)
Global Const $LVN_ENDLABELEDITA =($LVN_FIRST - 6)
Global Const $LVN_ENDLABELEDITW =($LVN_FIRST - 76)
Global Const $SS_CENTER = 0x1
Global Const $SS_RIGHT = 0x2
Global Const $SS_LEFTNOWORDWRAP = 0xC
Global Const $MEM_COMMIT = 0x00001000
Global Const $MEM_RESERVE = 0x00002000
Global Const $PAGE_READWRITE = 0x00000004
Global Const $MEM_RELEASE = 0x00008000
Global Const $MF_BYPOSITION = 0x00000400
Global Const $SE_PRIVILEGE_ENABLED = 0x00000002
Global Enum $SECURITYANONYMOUS = 0, $SECURITYIDENTIFICATION, $SECURITYIMPERSONATION, $SECURITYDELEGATION
Global Const $TOKEN_QUERY = 0x00000008
Global Const $TOKEN_ADJUST_PRIVILEGES = 0x00000020
Global Const $HGDI_ERROR = Ptr(-1)
Global Const $INVALID_HANDLE_VALUE = Ptr(-1)
Global Const $KF_EXTENDED = 0x0100
Global Const $KF_ALTDOWN = 0x2000
Global Const $KF_UP = 0x8000
Global Const $LLKHF_EXTENDED = BitShift($KF_EXTENDED, 8)
Global Const $LLKHF_ALTDOWN = BitShift($KF_ALTDOWN, 8)
Global Const $LLKHF_UP = BitShift($KF_UP, 8)
Global Const $VK_RETURN = 0x0D
Func _WinAPI_GetLastError(Const $_iCurrentError = @error, Const $_iCurrentExtended = @extended)
Local $aResult = DllCall("kernel32.dll", "dword", "GetLastError")
Return SetError($_iCurrentError, $_iCurrentExtended, $aResult[0])
EndFunc
Func _Security__AdjustTokenPrivileges($hToken, $bDisableAll, $tNewState, $iBufferLen, $tPrevState = 0, $pRequired = 0)
Local $aCall = DllCall("advapi32.dll", "bool", "AdjustTokenPrivileges", "handle", $hToken, "bool", $bDisableAll, "struct*", $tNewState, "dword", $iBufferLen, "struct*", $tPrevState, "struct*", $pRequired)
If @error Then Return SetError(@error, @extended, False)
Return Not($aCall[0] = 0)
EndFunc
Func _Security__ImpersonateSelf($iLevel = $SECURITYIMPERSONATION)
Local $aCall = DllCall("advapi32.dll", "bool", "ImpersonateSelf", "int", $iLevel)
If @error Then Return SetError(@error, @extended, False)
Return Not($aCall[0] = 0)
EndFunc
Func _Security__LookupPrivilegeValue($sSystem, $sName)
Local $aCall = DllCall("advapi32.dll", "bool", "LookupPrivilegeValueW", "wstr", $sSystem, "wstr", $sName, "int64*", 0)
If @error Or Not $aCall[0] Then Return SetError(@error, @extended, 0)
Return $aCall[3]
EndFunc
Func _Security__OpenThreadToken($iAccess, $hThread = 0, $bOpenAsSelf = False)
If $hThread = 0 Then
Local $aResult = DllCall("kernel32.dll", "handle", "GetCurrentThread")
If @error Then Return SetError(@error + 10, @extended, 0)
$hThread = $aResult[0]
EndIf
Local $aCall = DllCall("advapi32.dll", "bool", "OpenThreadToken", "handle", $hThread, "dword", $iAccess, "bool", $bOpenAsSelf, "handle*", 0)
If @error Or Not $aCall[0] Then Return SetError(@error, @extended, 0)
Return $aCall[4]
EndFunc
Func _Security__OpenThreadTokenEx($iAccess, $hThread = 0, $bOpenAsSelf = False)
Local $hToken = _Security__OpenThreadToken($iAccess, $hThread, $bOpenAsSelf)
If $hToken = 0 Then
Local Const $ERROR_NO_TOKEN = 1008
If _WinAPI_GetLastError() <> $ERROR_NO_TOKEN Then Return SetError(20, _WinAPI_GetLastError(), 0)
If Not _Security__ImpersonateSelf() Then Return SetError(@error + 10, _WinAPI_GetLastError(), 0)
$hToken = _Security__OpenThreadToken($iAccess, $hThread, $bOpenAsSelf)
If $hToken = 0 Then Return SetError(@error, _WinAPI_GetLastError(), 0)
EndIf
Return $hToken
EndFunc
Func _Security__SetPrivilege($hToken, $sPrivilege, $bEnable)
Local $iLUID = _Security__LookupPrivilegeValue("", $sPrivilege)
If $iLUID = 0 Then Return SetError(@error + 10, @extended, False)
Local Const $tagTOKEN_PRIVILEGES = "dword Count;align 4;int64 LUID;dword Attributes"
Local $tCurrState = DllStructCreate($tagTOKEN_PRIVILEGES)
Local $iCurrState = DllStructGetSize($tCurrState)
Local $tPrevState = DllStructCreate($tagTOKEN_PRIVILEGES)
Local $iPrevState = DllStructGetSize($tPrevState)
Local $tRequired = DllStructCreate("int Data")
DllStructSetData($tCurrState, "Count", 1)
DllStructSetData($tCurrState, "LUID", $iLUID)
If Not _Security__AdjustTokenPrivileges($hToken, False, $tCurrState, $iCurrState, $tPrevState, $tRequired) Then Return SetError(2, @error, False)
DllStructSetData($tPrevState, "Count", 1)
DllStructSetData($tPrevState, "LUID", $iLUID)
Local $iAttributes = DllStructGetData($tPrevState, "Attributes")
If $bEnable Then
$iAttributes = BitOR($iAttributes, $SE_PRIVILEGE_ENABLED)
Else
$iAttributes = BitAND($iAttributes, BitNOT($SE_PRIVILEGE_ENABLED))
EndIf
DllStructSetData($tPrevState, "Attributes", $iAttributes)
If Not _Security__AdjustTokenPrivileges($hToken, False, $tPrevState, $iPrevState, $tCurrState, $tRequired) Then Return SetError(3, @error, False)
Return True
EndFunc
Func _SendMessage($hWnd, $iMsg, $wParam = 0, $lParam = 0, $iReturn = 0, $wParamType = "wparam", $lParamType = "lparam", $sReturnType = "lresult")
Local $aResult = DllCall("user32.dll", $sReturnType, "SendMessageW", "hwnd", $hWnd, "uint", $iMsg, $wParamType, $wParam, $lParamType, $lParam)
If @error Then Return SetError(@error, @extended, "")
If $iReturn >= 0 And $iReturn <= 4 Then Return $aResult[$iReturn]
Return $aResult
EndFunc
Global Const $tagPOINT = "struct;long X;long Y;endstruct"
Global Const $tagRECT = "struct;long Left;long Top;long Right;long Bottom;endstruct"
Global Const $tagNMHDR = "struct;hwnd hWndFrom;uint_ptr IDFrom;INT Code;endstruct"
Global Const $tagGDIPBITMAPDATA = "uint Width;uint Height;int Stride;int Format;ptr Scan0;uint_ptr Reserved"
Global Const $tagGDIPSTARTUPINPUT = "uint Version;ptr Callback;bool NoThread;bool NoCodecs"
Global Const $tagGETIPAddress = "byte Field4;byte Field3;byte Field2;byte Field1"
Global Const $tagLVITEM = "struct;uint Mask;int Item;int SubItem;uint State;uint StateMask;ptr Text;int TextMax;int Image;lparam Param;" & "int Indent;int GroupID;uint Columns;ptr pColumns;ptr piColFmt;int iGroup;endstruct"
Global Const $tagNMLVDISPINFO = $tagNMHDR & ";" & $tagLVITEM
Global Const $tagNMITEMACTIVATE = $tagNMHDR & ";int Index;int SubItem;uint NewState;uint OldState;uint Changed;" & $tagPOINT & ";lparam lParam;uint KeyFlags"
Global Const $tagREBARBANDINFO = "uint cbSize;uint fMask;uint fStyle;dword clrFore;dword clrBack;ptr lpText;uint cch;" & "int iImage;hwnd hwndChild;uint cxMinChild;uint cyMinChild;uint cx;handle hbmBack;uint wID;uint cyChild;uint cyMaxChild;" & "uint cyIntegral;uint cxIdeal;lparam lParam;uint cxHeader" &((@OSVersion = "WIN_XP") ? "" : ";" & $tagRECT & ";uint uChevronState")
Global Const $tagTBBUTTON = "int Bitmap;int Command;byte State;byte Style;dword_ptr Param;int_ptr String"
Global Const $tagLOGFONT = "struct;long Height;long Width;long Escapement;long Orientation;long Weight;byte Italic;byte Underline;" & "byte Strikeout;byte CharSet;byte OutPrecision;byte ClipPrecision;byte Quality;byte PitchAndFamily;wchar FaceName[32];endstruct"
Global Const $tagSECURITY_ATTRIBUTES = "dword Length;ptr Descriptor;bool InheritHandle"
Global $__g_aInProcess_WinAPI[64][2] = [[0, 0]]
Global Const $__WINAPICONSTANT_WM_SETFONT = 0x0030
Func _WinAPI_CreateCompatibleBitmap($hDC, $iWidth, $iHeight)
Local $aResult = DllCall("gdi32.dll", "handle", "CreateCompatibleBitmap", "handle", $hDC, "int", $iWidth, "int", $iHeight)
If @error Then Return SetError(@error, @extended, 0)
Return $aResult[0]
EndFunc
Func _WinAPI_CreateCompatibleDC($hDC)
Local $aResult = DllCall("gdi32.dll", "handle", "CreateCompatibleDC", "handle", $hDC)
If @error Then Return SetError(@error, @extended, 0)
Return $aResult[0]
EndFunc
Func _WinAPI_CreateFontIndirect($tLogFont)
Local $aResult = DllCall("gdi32.dll", "handle", "CreateFontIndirectW", "struct*", $tLogFont)
If @error Then Return SetError(@error, @extended, 0)
Return $aResult[0]
EndFunc
Func _WinAPI_CreateWindowEx($iExStyle, $sClass, $sName, $iStyle, $iX, $iY, $iWidth, $iHeight, $hParent, $hMenu = 0, $hInstance = 0, $pParam = 0)
If $hInstance = 0 Then $hInstance = _WinAPI_GetModuleHandle("")
Local $aResult = DllCall("user32.dll", "hwnd", "CreateWindowExW", "dword", $iExStyle, "wstr", $sClass, "wstr", $sName, "dword", $iStyle, "int", $iX, "int", $iY, "int", $iWidth, "int", $iHeight, "hwnd", $hParent, "handle", $hMenu, "handle", $hInstance, "struct*", $pParam)
If @error Then Return SetError(@error, @extended, 0)
Return $aResult[0]
EndFunc
Func _WinAPI_DeleteDC($hDC)
Local $aResult = DllCall("gdi32.dll", "bool", "DeleteDC", "handle", $hDC)
If @error Then Return SetError(@error, @extended, False)
Return $aResult[0]
EndFunc
Func _WinAPI_DeleteObject($hObject)
Local $aResult = DllCall("gdi32.dll", "bool", "DeleteObject", "handle", $hObject)
If @error Then Return SetError(@error, @extended, False)
Return $aResult[0]
EndFunc
Func _WinAPI_GetAncestor($hWnd, $iFlags = 1)
Local $aResult = DllCall("user32.dll", "hwnd", "GetAncestor", "hwnd", $hWnd, "uint", $iFlags)
If @error Then Return SetError(@error, @extended, 0)
Return $aResult[0]
EndFunc
Func _WinAPI_GetAsyncKeyState($iKey)
Local $aResult = DllCall("user32.dll", "short", "GetAsyncKeyState", "int", $iKey)
If @error Then Return SetError(@error, @extended, 0)
Return $aResult[0]
EndFunc
Func _WinAPI_GetDC($hWnd)
Local $aResult = DllCall("user32.dll", "handle", "GetDC", "hwnd", $hWnd)
If @error Then Return SetError(@error, @extended, 0)
Return $aResult[0]
EndFunc
Func _WinAPI_GetDlgCtrlID($hWnd)
Local $aResult = DllCall("user32.dll", "int", "GetDlgCtrlID", "hwnd", $hWnd)
If @error Then Return SetError(@error, @extended, 0)
Return $aResult[0]
EndFunc
Func _WinAPI_GetFocus()
Local $aResult = DllCall("user32.dll", "hwnd", "GetFocus")
If @error Then Return SetError(@error, @extended, 0)
Return $aResult[0]
EndFunc
Func _WinAPI_GetModuleHandle($sModuleName)
Local $sModuleNameType = "wstr"
If $sModuleName = "" Then
$sModuleName = 0
$sModuleNameType = "ptr"
EndIf
Local $aResult = DllCall("kernel32.dll", "handle", "GetModuleHandleW", $sModuleNameType, $sModuleName)
If @error Then Return SetError(@error, @extended, 0)
Return $aResult[0]
EndFunc
Func _WinAPI_GetStockObject($iObject)
Local $aResult = DllCall("gdi32.dll", "handle", "GetStockObject", "int", $iObject)
If @error Then Return SetError(@error, @extended, 0)
Return $aResult[0]
EndFunc
Func _WinAPI_GetSysColor($iIndex)
Local $aResult = DllCall("user32.dll", "INT", "GetSysColor", "int", $iIndex)
If @error Then Return SetError(@error, @extended, 0)
Return $aResult[0]
EndFunc
Func _WinAPI_GetSystemMetrics($iIndex)
Local $aResult = DllCall("user32.dll", "int", "GetSystemMetrics", "int", $iIndex)
If @error Then Return SetError(@error, @extended, 0)
Return $aResult[0]
EndFunc
Func _WinAPI_GetWindowThreadProcessId($hWnd, ByRef $iPID)
Local $aResult = DllCall("user32.dll", "dword", "GetWindowThreadProcessId", "hwnd", $hWnd, "dword*", 0)
If @error Then Return SetError(@error, @extended, 0)
$iPID = $aResult[2]
Return $aResult[0]
EndFunc
Func _WinAPI_HiWord($iLong)
Return BitShift($iLong, 16)
EndFunc
Func _WinAPI_InProcess($hWnd, ByRef $hLastWnd)
If $hWnd = $hLastWnd Then Return True
For $iI = $__g_aInProcess_WinAPI[0][0] To 1 Step -1
If $hWnd = $__g_aInProcess_WinAPI[$iI][0] Then
If $__g_aInProcess_WinAPI[$iI][1] Then
$hLastWnd = $hWnd
Return True
Else
Return False
EndIf
EndIf
Next
Local $iPID
_WinAPI_GetWindowThreadProcessId($hWnd, $iPID)
Local $iCount = $__g_aInProcess_WinAPI[0][0] + 1
If $iCount >= 64 Then $iCount = 1
$__g_aInProcess_WinAPI[0][0] = $iCount
$__g_aInProcess_WinAPI[$iCount][0] = $hWnd
$__g_aInProcess_WinAPI[$iCount][1] =($iPID = @AutoItPID)
Return $__g_aInProcess_WinAPI[$iCount][1]
EndFunc
Func _WinAPI_LoWord($iLong)
Return BitAND($iLong, 0xFFFF)
EndFunc
Func _WinAPI_MakeLong($iLo, $iHi)
Return BitOR(BitShift($iHi, -16), BitAND($iLo, 0xFFFF))
EndFunc
Func _WinAPI_PostMessage($hWnd, $iMsg, $wParam, $lParam)
Local $aResult = DllCall("user32.dll", "bool", "PostMessage", "hwnd", $hWnd, "uint", $iMsg, "wparam", $wParam, "lparam", $lParam)
If @error Then Return SetError(@error, @extended, False)
Return $aResult[0]
EndFunc
Func _WinAPI_RegisterWindowMessage($sMessage)
Local $aResult = DllCall("user32.dll", "uint", "RegisterWindowMessageW", "wstr", $sMessage)
If @error Then Return SetError(@error, @extended, 0)
Return $aResult[0]
EndFunc
Func _WinAPI_ReleaseDC($hWnd, $hDC)
Local $aResult = DllCall("user32.dll", "int", "ReleaseDC", "hwnd", $hWnd, "handle", $hDC)
If @error Then Return SetError(@error, @extended, False)
Return $aResult[0]
EndFunc
Func _WinAPI_SelectObject($hDC, $hGDIObj)
Local $aResult = DllCall("gdi32.dll", "handle", "SelectObject", "handle", $hDC, "handle", $hGDIObj)
If @error Then Return SetError(@error, @extended, False)
Return $aResult[0]
EndFunc
Func _WinAPI_SetFont($hWnd, $hFont, $bRedraw = True)
_SendMessage($hWnd, $__WINAPICONSTANT_WM_SETFONT, $hFont, $bRedraw, 0, "hwnd")
EndFunc
Func _WinAPI_SetParent($hWndChild, $hWndParent)
Local $aResult = DllCall("user32.dll", "hwnd", "SetParent", "hwnd", $hWndChild, "hwnd", $hWndParent)
If @error Then Return SetError(@error, @extended, 0)
Return $aResult[0]
EndFunc
Global $__g_hHeap = 0, $__g_iRGBMode = 1
Global Const $tagOSVERSIONINFO = 'struct;dword OSVersionInfoSize;dword MajorVersion;dword MinorVersion;dword BuildNumber;dword PlatformId;wchar CSDVersion[128];endstruct'
Global Const $__WINVER = __WINVER()
Func _WinAPI_SwitchColor($iColor)
If $iColor = -1 Then Return $iColor
Return BitOR(BitAND($iColor, 0x00FF00), BitShift(BitAND($iColor, 0x0000FF), -16), BitShift(BitAND($iColor, 0xFF0000), 16))
EndFunc
Func __CheckErrorArrayBounds(Const ByRef $aData, ByRef $iStart, ByRef $iEnd, $nDim = 1, $iDim = $UBOUND_DIMENSIONS)
If Not IsArray($aData) Then Return SetError(1, 0, 1)
If UBound($aData, $iDim) <> $nDim Then Return SetError(2, 0, 1)
If $iStart < 0 Then $iStart = 0
Local $iUBound = UBound($aData) - 1
If $iEnd < 1 Or $iEnd > $iUBound Then $iEnd = $iUBound
If $iStart > $iEnd Then Return SetError(4, 0, 1)
Return 0
EndFunc
Func __Iif($bTest, $vTrue, $vFalse)
Return $bTest ? $vTrue : $vFalse
EndFunc
Func __RGB($iColor)
If $__g_iRGBMode Then
$iColor = _WinAPI_SwitchColor($iColor)
EndIf
Return $iColor
EndFunc
Func __WINVER()
Local $tOSVI = DllStructCreate($tagOSVERSIONINFO)
DllStructSetData($tOSVI, 1, DllStructGetSize($tOSVI))
Local $aRet = DllCall('kernel32.dll', 'bool', 'GetVersionExW', 'struct*', $tOSVI)
If @error Or Not $aRet[0] Then Return SetError(@error, @extended, 0)
Return BitOR(BitShift(DllStructGetData($tOSVI, 2), -8), DllStructGetData($tOSVI, 3))
EndFunc
Func _WinAPI_CreateStreamOnHGlobal($hGlobal = 0, $bDeleteOnRelease = True)
Local $aReturn = DllCall('ole32.dll', 'long', 'CreateStreamOnHGlobal', 'handle', $hGlobal, 'bool', $bDeleteOnRelease, 'ptr*', 0)
If @error Then Return SetError(@error, @extended, 0)
If $aReturn[0] Then Return SetError(10, $aReturn[0], 0)
Return $aReturn[3]
EndFunc
Global Const $tagPRINTDLG = __Iif(@AutoItX64, '', 'align 2;') & 'dword Size;hwnd hOwner;handle hDevMode;handle hDevNames;handle hDC;dword Flags;word FromPage;word ToPage;word MinPage;word MaxPage;word Copies;handle hInstance;lparam lParam;ptr PrintHook;ptr SetupHook;ptr PrintTemplateName;ptr SetupTemplateName;handle hPrintTemplate;handle hSetupTemplate'
Global Const $tagBITMAPV5HEADER = 'struct;dword bV5Size;long bV5Width;long bV5Height;ushort bV5Planes;ushort bV5BitCount;dword bV5Compression;dword bV5SizeImage;long bV5XPelsPerMeter;long bV5YPelsPerMeter;dword bV5ClrUsed;dword bV5ClrImportant;dword bV5RedMask;dword bV5GreenMask;dword bV5BlueMask;dword bV5AlphaMask;dword bV5CSType;int bV5Endpoints[9];dword bV5GammaRed;dword bV5GammaGreen;dword bV5GammaBlue;dword bV5Intent;dword bV5ProfileData;dword bV5ProfileSize;dword bV5Reserved;endstruct'
Func _WinAPI_GetBValue($iRGB)
Return BitShift(BitAND(__RGB($iRGB), 0xFF0000), 16)
EndFunc
Func _WinAPI_GetGValue($iRGB)
Return BitShift(BitAND(__RGB($iRGB), 0x00FF00), 8)
EndFunc
Func _WinAPI_GetRValue($iRGB)
Return BitAND(__RGB($iRGB), 0x0000FF)
EndFunc
Func _WinAPI_GradientFill($hDC, Const ByRef $aVertex, $iStart = 0, $iEnd = -1, $bRotate = False)
If __CheckErrorArrayBounds($aVertex, $iStart, $iEnd, 2) Then Return SetError(@error + 10, @extended, 0)
If UBound($aVertex, $UBOUND_COLUMNS) < 3 Then Return SetError(13, 0, 0)
Local $iPoint = $iEnd - $iStart + 1
If $iPoint > 3 Then
$iEnd = $iStart + 2
$iPoint = 3
EndIf
Local $iMode
Switch $iPoint
Case 2
$iMode = Number(Not $bRotate)
Case 3
$iMode = 2
Case Else
Return SetError(15, 0, 0)
EndSwitch
Local $tagStruct = ''
For $i = $iStart To $iEnd
$tagStruct &= 'ushort[8];'
Next
Local $tVertex = DllStructCreate($tagStruct)
Local $iCount = 1
Local $tGradient = DllStructCreate('ulong[' & $iPoint & ']')
For $i = $iStart To $iEnd
DllStructSetData($tGradient, 1, $iCount - 1, $iCount)
DllStructSetData($tVertex, $iCount, _WinAPI_LoWord($aVertex[$i][0]), 1)
DllStructSetData($tVertex, $iCount, _WinAPI_HiWord($aVertex[$i][0]), 2)
DllStructSetData($tVertex, $iCount, _WinAPI_LoWord($aVertex[$i][1]), 3)
DllStructSetData($tVertex, $iCount, _WinAPI_HiWord($aVertex[$i][1]), 4)
DllStructSetData($tVertex, $iCount, BitShift(_WinAPI_GetRValue($aVertex[$i][2]), -8), 5)
DllStructSetData($tVertex, $iCount, BitShift(_WinAPI_GetGValue($aVertex[$i][2]), -8), 6)
DllStructSetData($tVertex, $iCount, BitShift(_WinAPI_GetBValue($aVertex[$i][2]), -8), 7)
DllStructSetData($tVertex, $iCount, 0, 8)
$iCount += 1
Next
Local $aRet = DllCall('gdi32.dll', 'bool', 'GdiGradientFill', 'handle', $hDC, 'struct*', $tVertex, 'ulong', $iPoint, 'struct*', $tGradient, 'ulong', 1, 'ulong', $iMode)
If @error Then Return SetError(@error, @extended, 0)
Return $aRet[0]
EndFunc
Global Const $GDIP_ILMREAD = 0x0001
Global Const $GDIP_PXF32RGB = 0x00022009
Global Const $GDIP_PXF32ARGB = 0x0026200A
Global $__g_hGDIPDll = 0
Global $__g_iGDIPRef = 0
Global $__g_iGDIPToken = 0
Global $__g_bGDIP_V1_0 = True
Func _GDIPlus_BitmapCreateDIBFromBitmap($hBitmap)
Local $aRet = DllCall($__g_hGDIPDll, "uint", "GdipGetImageDimension", "handle", $hBitmap, "float*", 0, "float*", 0)
If @error Or $aRet[0] Then Return SetError(@error + 10, $aRet[0], 0)
Local $tData = _GDIPlus_BitmapLockBits($hBitmap, 0, 0, $aRet[2], $aRet[3], $GDIP_ILMREAD, $GDIP_PXF32ARGB)
Local $pBits = DllStructGetData($tData, "Scan0")
If Not $pBits Then Return 0
Local $tBIHDR = DllStructCreate($tagBITMAPV5HEADER)
DllStructSetData($tBIHDR, "bV5Size", DllStructGetSize($tBIHDR))
DllStructSetData($tBIHDR, "bV5Width", $aRet[2])
DllStructSetData($tBIHDR, "bV5Height", $aRet[3])
DllStructSetData($tBIHDR, "bV5Planes", 1)
DllStructSetData($tBIHDR, "bV5BitCount", 32)
DllStructSetData($tBIHDR, "bV5Compression", 0)
DllStructSetData($tBIHDR, "bV5SizeImage", $aRet[3] * DllStructGetData($tData, "Stride"))
DllStructSetData($tBIHDR, "bV5AlphaMask", 0xFF000000)
DllStructSetData($tBIHDR, "bV5RedMask", 0x00FF0000)
DllStructSetData($tBIHDR, "bV5GreenMask", 0x0000FF00)
DllStructSetData($tBIHDR, "bV5BlueMask", 0x000000FF)
DllStructSetData($tBIHDR, "bV5CSType", 2)
DllStructSetData($tBIHDR, "bV5Intent", 4)
Local $hHBitmapv5 = DllCall("gdi32.dll", "ptr", "CreateDIBSection", "hwnd", 0, "struct*", $tBIHDR, "uint", 0, "ptr*", 0, "ptr", 0, "dword", 0)
If Not @error And $hHBitmapv5[0] Then
DllCall("gdi32.dll", "dword", "SetBitmapBits", "ptr", $hHBitmapv5[0], "dword", $aRet[2] * $aRet[3] * 4, "ptr", DllStructGetData($tData, "Scan0"))
$hHBitmapv5 = $hHBitmapv5[0]
Else
$hHBitmapv5 = 0
EndIf
_GDIPlus_BitmapUnlockBits($hBitmap, $tData)
$tData = 0
$tBIHDR = 0
Return $hHBitmapv5
EndFunc
Func _GDIPlus_BitmapCreateFromMemory($dImage, $bHBITMAP = False)
If Not IsBinary($dImage) Then Return SetError(1, 0, 0)
Local $aResult = 0
Local Const $dMemBitmap = Binary($dImage)
Local Const $iLen = BinaryLen($dMemBitmap)
Local Const $GMEM_MOVEABLE = 0x0002
$aResult = DllCall("kernel32.dll", "handle", "GlobalAlloc", "uint", $GMEM_MOVEABLE, "ulong_ptr", $iLen)
If @error Then Return SetError(4, 0, 0)
Local Const $hData = $aResult[0]
$aResult = DllCall("kernel32.dll", "ptr", "GlobalLock", "handle", $hData)
If @error Then Return SetError(5, 0, 0)
Local $tMem = DllStructCreate("byte[" & $iLen & "]", $aResult[0])
DllStructSetData($tMem, 1, $dMemBitmap)
DllCall("kernel32.dll", "bool", "GlobalUnlock", "handle", $hData)
If @error Then Return SetError(6, 0, 0)
Local Const $hStream = _WinAPI_CreateStreamOnHGlobal($hData)
If @error Then Return SetError(2, 0, 0)
Local Const $hBitmap = _GDIPlus_BitmapCreateFromStream($hStream)
If @error Then Return SetError(3, 0, 0)
DllCall("oleaut32.dll", "long", "DispCallFunc", "ptr", $hStream, "ulong_ptr", 8 *(1 + @AutoItX64), "uint", 4, "ushort", 23, "uint", 0, "ptr", 0, "ptr", 0, "str", "")
If $bHBITMAP Then
Local Const $hHBmp = _GDIPlus_BitmapCreateDIBFromBitmap($hBitmap)
_GDIPlus_BitmapDispose($hBitmap)
Return $hHBmp
EndIf
Return $hBitmap
EndFunc
Func _GDIPlus_BitmapCreateFromStream($pStream)
Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipCreateBitmapFromStream", "ptr", $pStream, "handle*", 0)
If @error Then Return SetError(@error, @extended, 0)
If $aResult[0] Then Return SetError(10, $aResult[0], 0)
Return $aResult[2]
EndFunc
Func _GDIPlus_BitmapDispose($hBitmap)
Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipDisposeImage", "handle", $hBitmap)
If @error Then Return SetError(@error, @extended, False)
If $aResult[0] Then Return SetError(10, $aResult[0], False)
Return True
EndFunc
Func _GDIPlus_BitmapLockBits($hBitmap, $iLeft, $iTop, $iWidth, $iHeight, $iFlags = $GDIP_ILMREAD, $iFormat = $GDIP_PXF32RGB)
Local $tData = DllStructCreate($tagGDIPBITMAPDATA)
Local $tRECT = DllStructCreate($tagRECT)
DllStructSetData($tRECT, "Left", $iLeft)
DllStructSetData($tRECT, "Top", $iTop)
DllStructSetData($tRECT, "Right", $iWidth)
DllStructSetData($tRECT, "Bottom", $iHeight)
Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipBitmapLockBits", "handle", $hBitmap, "struct*", $tRECT, "uint", $iFlags, "int", $iFormat, "struct*", $tData)
If @error Then Return SetError(@error, @extended, 0)
If $aResult[0] Then Return SetError(10, $aResult[0], 0)
Return $tData
EndFunc
Func _GDIPlus_BitmapUnlockBits($hBitmap, $tBitmapData)
Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipBitmapUnlockBits", "handle", $hBitmap, "struct*", $tBitmapData)
If @error Then Return SetError(@error, @extended, False)
If $aResult[0] Then Return SetError(10, $aResult[0], False)
Return True
EndFunc
Func _GDIPlus_GraphicsCreateFromHWND($hWnd)
Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipCreateFromHWND", "hwnd", $hWnd, "handle*", 0)
If @error Then Return SetError(@error, @extended, 0)
If $aResult[0] Then Return SetError(10, $aResult[0], 0)
Return $aResult[2]
EndFunc
Func _GDIPlus_GraphicsDispose($hGraphics)
Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipDeleteGraphics", "handle", $hGraphics)
If @error Then Return SetError(@error, @extended, False)
If $aResult[0] Then Return SetError(10, $aResult[0], False)
Return True
EndFunc
Func _GDIPlus_HICONCreateFromBitmap($hBitmap)
Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipCreateHICONFromBitmap", "handle", $hBitmap, "handle*", 0)
If @error Then Return SetError(@error, @extended, 0)
If $aResult[0] Then Return SetError(10, $aResult[0], 0)
Return $aResult[2]
EndFunc
Func _GDIPlus_ImageDispose($hImage)
Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipDisposeImage", "handle", $hImage)
If @error Then Return SetError(@error, @extended, False)
If $aResult[0] Then Return SetError(10, $aResult[0], False)
Return True
EndFunc
Func _GDIPlus_Shutdown()
If $__g_hGDIPDll = 0 Then Return SetError(-1, -1, False)
$__g_iGDIPRef -= 1
If $__g_iGDIPRef = 0 Then
DllCall($__g_hGDIPDll, "none", "GdiplusShutdown", "ulong_ptr", $__g_iGDIPToken)
DllClose($__g_hGDIPDll)
$__g_hGDIPDll = 0
EndIf
Return True
EndFunc
Func _GDIPlus_Startup($sGDIPDLL = Default, $bRetDllHandle = False)
$__g_iGDIPRef += 1
If $__g_iGDIPRef > 1 Then Return True
If $sGDIPDLL = Default Then $sGDIPDLL = "gdiplus.dll"
$__g_hGDIPDll = DllOpen($sGDIPDLL)
If $__g_hGDIPDll = -1 Then
$__g_iGDIPRef = 0
Return SetError(1, 2, False)
EndIf
Local $sVer = FileGetVersion($sGDIPDLL)
$sVer = StringSplit($sVer, ".")
If $sVer[1] > 5 Then $__g_bGDIP_V1_0 = False
Local $tInput = DllStructCreate($tagGDIPSTARTUPINPUT)
Local $tToken = DllStructCreate("ulong_ptr Data")
DllStructSetData($tInput, "Version", 1)
Local $aResult = DllCall($__g_hGDIPDll, "int", "GdiplusStartup", "struct*", $tToken, "struct*", $tInput, "ptr", 0)
If @error Then Return SetError(@error, @extended, False)
If $aResult[0] Then Return SetError(10, $aResult[0], False)
$__g_iGDIPToken = DllStructGetData($tToken, "Data")
If $bRetDllHandle Then Return $__g_hGDIPDll
Return SetExtended($sVer[1], True)
EndFunc
Global Const $ILC_MASK = 0x00000001
Global Const $ILC_COLOR = 0x00000000
Global Const $ILC_COLORDDB = 0x000000FE
Global Const $ILC_COLOR4 = 0x00000004
Global Const $ILC_COLOR8 = 0x00000008
Global Const $ILC_COLOR16 = 0x00000010
Global Const $ILC_COLOR24 = 0x00000018
Global Const $ILC_COLOR32 = 0x00000020
Global Const $ILC_MIRROR = 0x00002000
Global Const $ILC_PERITEMMIRROR = 0x00008000
Func _GUIImageList_Create($iCX = 16, $iCY = 16, $iColor = 4, $iOptions = 0, $iInitial = 4, $iGrow = 4)
Local Const $aColor[7] = [$ILC_COLOR, $ILC_COLOR4, $ILC_COLOR8, $ILC_COLOR16, $ILC_COLOR24, $ILC_COLOR32, $ILC_COLORDDB]
Local $iFlags = 0
If BitAND($iOptions, 1) <> 0 Then $iFlags = BitOR($iFlags, $ILC_MASK)
If BitAND($iOptions, 2) <> 0 Then $iFlags = BitOR($iFlags, $ILC_MIRROR)
If BitAND($iOptions, 4) <> 0 Then $iFlags = BitOR($iFlags, $ILC_PERITEMMIRROR)
$iFlags = BitOR($iFlags, $aColor[$iColor])
Local $aResult = DllCall("comctl32.dll", "handle", "ImageList_Create", "int", $iCX, "int", $iCY, "uint", $iFlags, "int", $iInitial, "int", $iGrow)
If @error Then Return SetError(@error, @extended, 0)
Return $aResult[0]
EndFunc
Func _GUIImageList_ReplaceIcon($hWnd, $iIndex, $hIcon)
Local $aResult = DllCall("comctl32.dll", "int", "ImageList_ReplaceIcon", "handle", $hWnd, "int", $iIndex, "handle", $hIcon)
If @error Then Return SetError(@error, @extended, -1)
Return $aResult[0]
EndFunc
Global Const $tagMEMMAP = "handle hProc;ulong_ptr Size;ptr Mem"
Func _MemFree(ByRef $tMemMap)
Local $pMemory = DllStructGetData($tMemMap, "Mem")
Local $hProcess = DllStructGetData($tMemMap, "hProc")
Local $bResult = _MemVirtualFreeEx($hProcess, $pMemory, 0, $MEM_RELEASE)
DllCall("kernel32.dll", "bool", "CloseHandle", "handle", $hProcess)
If @error Then Return SetError(@error, @extended, False)
Return $bResult
EndFunc
Func _MemInit($hWnd, $iSize, ByRef $tMemMap)
Local $aResult = DllCall("user32.dll", "dword", "GetWindowThreadProcessId", "hwnd", $hWnd, "dword*", 0)
If @error Then Return SetError(@error + 10, @extended, 0)
Local $iProcessID = $aResult[2]
If $iProcessID = 0 Then Return SetError(1, 0, 0)
Local $iAccess = BitOR($PROCESS_VM_OPERATION, $PROCESS_VM_READ, $PROCESS_VM_WRITE)
Local $hProcess = __Mem_OpenProcess($iAccess, False, $iProcessID, True)
Local $iAlloc = BitOR($MEM_RESERVE, $MEM_COMMIT)
Local $pMemory = _MemVirtualAllocEx($hProcess, 0, $iSize, $iAlloc, $PAGE_READWRITE)
If $pMemory = 0 Then Return SetError(2, 0, 0)
$tMemMap = DllStructCreate($tagMEMMAP)
DllStructSetData($tMemMap, "hProc", $hProcess)
DllStructSetData($tMemMap, "Size", $iSize)
DllStructSetData($tMemMap, "Mem", $pMemory)
Return $pMemory
EndFunc
Func _MemRead(ByRef $tMemMap, $pSrce, $pDest, $iSize)
Local $aResult = DllCall("kernel32.dll", "bool", "ReadProcessMemory", "handle", DllStructGetData($tMemMap, "hProc"), "ptr", $pSrce, "struct*", $pDest, "ulong_ptr", $iSize, "ulong_ptr*", 0)
If @error Then Return SetError(@error, @extended, False)
Return $aResult[0]
EndFunc
Func _MemWrite(ByRef $tMemMap, $pSrce, $pDest = 0, $iSize = 0, $sSrce = "struct*")
If $pDest = 0 Then $pDest = DllStructGetData($tMemMap, "Mem")
If $iSize = 0 Then $iSize = DllStructGetData($tMemMap, "Size")
Local $aResult = DllCall("kernel32.dll", "bool", "WriteProcessMemory", "handle", DllStructGetData($tMemMap, "hProc"), "ptr", $pDest, $sSrce, $pSrce, "ulong_ptr", $iSize, "ulong_ptr*", 0)
If @error Then Return SetError(@error, @extended, False)
Return $aResult[0]
EndFunc
Func _MemVirtualAllocEx($hProcess, $pAddress, $iSize, $iAllocation, $iProtect)
Local $aResult = DllCall("kernel32.dll", "ptr", "VirtualAllocEx", "handle", $hProcess, "ptr", $pAddress, "ulong_ptr", $iSize, "dword", $iAllocation, "dword", $iProtect)
If @error Then Return SetError(@error, @extended, 0)
Return $aResult[0]
EndFunc
Func _MemVirtualFreeEx($hProcess, $pAddress, $iSize, $iFreeType)
Local $aResult = DllCall("kernel32.dll", "bool", "VirtualFreeEx", "handle", $hProcess, "ptr", $pAddress, "ulong_ptr", $iSize, "dword", $iFreeType)
If @error Then Return SetError(@error, @extended, False)
Return $aResult[0]
EndFunc
Func __Mem_OpenProcess($iAccess, $bInherit, $iProcessID, $bDebugPriv = False)
Local $aResult = DllCall("kernel32.dll", "handle", "OpenProcess", "dword", $iAccess, "bool", $bInherit, "dword", $iProcessID)
If @error Then Return SetError(@error + 10, @extended, 0)
If $aResult[0] Then Return $aResult[0]
If Not $bDebugPriv Then Return 0
Local $hToken = _Security__OpenThreadTokenEx(BitOR($TOKEN_ADJUST_PRIVILEGES, $TOKEN_QUERY))
If @error Then Return SetError(@error + 20, @extended, 0)
_Security__SetPrivilege($hToken, "SeDebugPrivilege", True)
Local $iError = @error
Local $iLastError = @extended
Local $iRet = 0
If Not @error Then
$aResult = DllCall("kernel32.dll", "handle", "OpenProcess", "dword", $iAccess, "bool", $bInherit, "dword", $iProcessID)
$iError = @error
$iLastError = @extended
If $aResult[0] Then $iRet = $aResult[0]
_Security__SetPrivilege($hToken, "SeDebugPrivilege", False)
If @error Then
$iError = @error + 30
$iLastError = @extended
EndIf
Else
$iError = @error + 40
EndIf
DllCall("kernel32.dll", "bool", "CloseHandle", "handle", $hToken)
Return SetError($iError, $iLastError, $iRet)
EndFunc
Global Const $TBMF_PAD = 0x00000001
Global Const $TBMF_BUTTONSPACING = 0x00000004
Global Const $__TOOLBARCONSTANTS_WM_USER = 0X400
Global Const $TB_ENABLEBUTTON = $__TOOLBARCONSTANTS_WM_USER + 1
Global Const $TB_ADDBUTTONSA = $__TOOLBARCONSTANTS_WM_USER + 20
Global Const $TB_ADDSTRINGA = $__TOOLBARCONSTANTS_WM_USER + 28
Global Const $TB_ADDSTRINGW = $__TOOLBARCONSTANTS_WM_USER + 77
Global Const $TB_BUTTONSTRUCTSIZE = $__TOOLBARCONSTANTS_WM_USER + 30
Global Const $TB_SETBUTTONSIZE = $__TOOLBARCONSTANTS_WM_USER + 31
Global Const $TB_AUTOSIZE = $__TOOLBARCONSTANTS_WM_USER + 33
Global Const $TB_SETROWS = $__TOOLBARCONSTANTS_WM_USER + 39
Global Const $TB_SETINDENT = $__TOOLBARCONSTANTS_WM_USER + 47
Global Const $TB_SETIMAGELIST = $__TOOLBARCONSTANTS_WM_USER + 48
Global Const $TB_SETBUTTONWIDTH = $__TOOLBARCONSTANTS_WM_USER + 59
Global Const $TB_ADDBUTTONSW = $__TOOLBARCONSTANTS_WM_USER + 68
Global Const $TB_SETMETRICS = $__TOOLBARCONSTANTS_WM_USER + 102
Global Const $TB_GETUNICODEFORMAT = 0x2000 + 6
Global Const $TBN_FIRST = -700
Global Const $TBN_GETINFOTIPW = $TBN_FIRST - 19
Global Const $BTNS_BUTTON = 0x00000000
Global Const $BTNS_SEP = 0x00000001
Global Const $BTNS_SHOWTEXT = 0x00000040
Global Const $TBSTYLE_TOOLTIPS = 0x00000100
Global Const $TBSTYLE_FLAT = 0x00000800
Global Const $TBSTYLE_EX_DOUBLEBUFFER = 0x00000080
Global Const $_UDF_GlobalIDs_OFFSET = 2
Global Const $_UDF_GlobalID_MAX_WIN = 16
Global Const $_UDF_STARTID = 10000
Global Const $_UDF_GlobalID_MAX_IDS = 55535
Global Const $__UDFGUICONSTANT_WS_TABSTOP = 0x00010000
Global Const $__UDFGUICONSTANT_WS_VISIBLE = 0x10000000
Global Const $__UDFGUICONSTANT_WS_CHILD = 0x40000000
Global $__g_aUDF_GlobalIDs_Used[$_UDF_GlobalID_MAX_WIN][$_UDF_GlobalID_MAX_IDS + $_UDF_GlobalIDs_OFFSET + 1]
Func __UDF_GetNextGlobalID($hWnd)
Local $nCtrlID, $iUsedIndex = -1, $bAllUsed = True
If Not WinExists($hWnd) Then Return SetError(-1, -1, 0)
For $iIndex = 0 To $_UDF_GlobalID_MAX_WIN - 1
If $__g_aUDF_GlobalIDs_Used[$iIndex][0] <> 0 Then
If Not WinExists($__g_aUDF_GlobalIDs_Used[$iIndex][0]) Then
For $x = 0 To UBound($__g_aUDF_GlobalIDs_Used, $UBOUND_COLUMNS) - 1
$__g_aUDF_GlobalIDs_Used[$iIndex][$x] = 0
Next
$__g_aUDF_GlobalIDs_Used[$iIndex][1] = $_UDF_STARTID
$bAllUsed = False
EndIf
EndIf
Next
For $iIndex = 0 To $_UDF_GlobalID_MAX_WIN - 1
If $__g_aUDF_GlobalIDs_Used[$iIndex][0] = $hWnd Then
$iUsedIndex = $iIndex
ExitLoop
EndIf
Next
If $iUsedIndex = -1 Then
For $iIndex = 0 To $_UDF_GlobalID_MAX_WIN - 1
If $__g_aUDF_GlobalIDs_Used[$iIndex][0] = 0 Then
$__g_aUDF_GlobalIDs_Used[$iIndex][0] = $hWnd
$__g_aUDF_GlobalIDs_Used[$iIndex][1] = $_UDF_STARTID
$bAllUsed = False
$iUsedIndex = $iIndex
ExitLoop
EndIf
Next
EndIf
If $iUsedIndex = -1 And $bAllUsed Then Return SetError(16, 0, 0)
If $__g_aUDF_GlobalIDs_Used[$iUsedIndex][1] = $_UDF_STARTID + $_UDF_GlobalID_MAX_IDS Then
For $iIDIndex = $_UDF_GlobalIDs_OFFSET To UBound($__g_aUDF_GlobalIDs_Used, $UBOUND_COLUMNS) - 1
If $__g_aUDF_GlobalIDs_Used[$iUsedIndex][$iIDIndex] = 0 Then
$nCtrlID =($iIDIndex - $_UDF_GlobalIDs_OFFSET) + 10000
$__g_aUDF_GlobalIDs_Used[$iUsedIndex][$iIDIndex] = $nCtrlID
Return $nCtrlID
EndIf
Next
Return SetError(-1, $_UDF_GlobalID_MAX_IDS, 0)
EndIf
$nCtrlID = $__g_aUDF_GlobalIDs_Used[$iUsedIndex][1]
$__g_aUDF_GlobalIDs_Used[$iUsedIndex][1] += 1
$__g_aUDF_GlobalIDs_Used[$iUsedIndex][($nCtrlID - 10000) + $_UDF_GlobalIDs_OFFSET] = $nCtrlID
Return $nCtrlID
EndFunc
Global $__g_hTBLastWnd
Global Const $__TOOLBARCONSTANT_ClassName = "ToolbarWindow32"
Global Const $__TOOLBARCONSTANT_WS_CLIPSIBLINGS = 0x04000000
Global Const $tagTBMETRICS = "uint Size;dword Mask;int XPad;int YPad;int XBarPad;int YBarPad;int XSpacing;int YSpacing"
Func _GUICtrlToolbar_AddButton($hWnd, $iID, $iImage, $iString = 0, $iStyle = 0, $iState = 4, $iParam = 0)
Local $bUnicode = _GUICtrlToolbar_GetUnicodeFormat($hWnd)
Local $tButton = DllStructCreate($tagTBBUTTON)
DllStructSetData($tButton, "Bitmap", $iImage)
DllStructSetData($tButton, "Command", $iID)
DllStructSetData($tButton, "State", $iState)
DllStructSetData($tButton, "Style", $iStyle)
DllStructSetData($tButton, "Param", $iParam)
DllStructSetData($tButton, "String", $iString)
Local $iRet
If _WinAPI_InProcess($hWnd, $__g_hTBLastWnd) Then
$iRet = _SendMessage($hWnd, $TB_ADDBUTTONSW, 1, $tButton, 0, "wparam", "struct*")
Else
Local $iButton = DllStructGetSize($tButton)
Local $tMemMap
Local $pMemory = _MemInit($hWnd, $iButton, $tMemMap)
_MemWrite($tMemMap, $tButton, $pMemory, $iButton)
If $bUnicode Then
$iRet = _SendMessage($hWnd, $TB_ADDBUTTONSW, 1, $pMemory, 0, "wparam", "ptr")
Else
$iRet = _SendMessage($hWnd, $TB_ADDBUTTONSA, 1, $pMemory, 0, "wparam", "ptr")
EndIf
_MemFree($tMemMap)
EndIf
__GUICtrlToolbar_AutoSize($hWnd)
Return $iRet <> 0
EndFunc
Func _GUICtrlToolbar_AddButtonSep($hWnd, $iWidth = 6)
_GUICtrlToolbar_AddButton($hWnd, 0, $iWidth, 0, $BTNS_SEP)
EndFunc
Func _GUICtrlToolbar_AddString($hWnd, $sString)
Local $bUnicode = _GUICtrlToolbar_GetUnicodeFormat($hWnd)
Local $iBuffer = StringLen($sString) + 2
Local $tBuffer
If $bUnicode Then
$tBuffer = DllStructCreate("wchar Text[" & $iBuffer & "]")
$iBuffer *= 2
Else
$tBuffer = DllStructCreate("char Text[" & $iBuffer & "]")
EndIf
DllStructSetData($tBuffer, "Text", $sString)
Local $iRet
If _WinAPI_InProcess($hWnd, $__g_hTBLastWnd) Then
$iRet = _SendMessage($hWnd, $TB_ADDSTRINGW, 0, $tBuffer, 0, "wparam", "struct*")
Else
Local $tMemMap
Local $pMemory = _MemInit($hWnd, $iBuffer, $tMemMap)
_MemWrite($tMemMap, $tBuffer, $pMemory, $iBuffer)
If $bUnicode Then
$iRet = _SendMessage($hWnd, $TB_ADDSTRINGW, 0, $pMemory, 0, "wparam", "ptr")
Else
$iRet = _SendMessage($hWnd, $TB_ADDSTRINGA, 0, $pMemory, 0, "wparam", "ptr")
EndIf
_MemFree($tMemMap)
EndIf
Return $iRet
EndFunc
Func __GUICtrlToolbar_AutoSize($hWnd)
_SendMessage($hWnd, $TB_AUTOSIZE)
EndFunc
Func __GUICtrlToolbar_ButtonStructSize($hWnd)
Local $tButton = DllStructCreate($tagTBBUTTON)
_SendMessage($hWnd, $TB_BUTTONSTRUCTSIZE, DllStructGetSize($tButton), 0, 0, "wparam", "ptr")
EndFunc
Func _GUICtrlToolbar_Create($hWnd, $iStyle = 0x00000800, $iExStyle = 0x00000000)
$iStyle = BitOR($iStyle, $__UDFGUICONSTANT_WS_CHILD, $__TOOLBARCONSTANT_WS_CLIPSIBLINGS, $__UDFGUICONSTANT_WS_VISIBLE)
Local $nCtrlID = __UDF_GetNextGlobalID($hWnd)
If @error Then Return SetError(@error, @extended, 0)
Local $hTool = _WinAPI_CreateWindowEx($iExStyle, $__TOOLBARCONSTANT_ClassName, "", $iStyle, 0, 0, 0, 0, $hWnd, $nCtrlID)
__GUICtrlToolbar_ButtonStructSize($hTool)
Return $hTool
EndFunc
Func _GUICtrlToolbar_EnableButton($hWnd, $iCommandID, $bEnable = True)
Return _SendMessage($hWnd, $TB_ENABLEBUTTON, $iCommandID, $bEnable) <> 0
EndFunc
Func _GUICtrlToolbar_GetUnicodeFormat($hWnd)
Return _SendMessage($hWnd, $TB_GETUNICODEFORMAT) <> 0
EndFunc
Func _GUICtrlToolbar_SetButtonSize($hWnd, $iHeight, $iWidth)
Return _SendMessage($hWnd, $TB_SETBUTTONSIZE, 0, _WinAPI_MakeLong($iWidth, $iHeight), 0, "wparam", "long") <> 0
EndFunc
Func _GUICtrlToolbar_SetButtonWidth($hWnd, $iMin, $iMax)
Return _SendMessage($hWnd, $TB_SETBUTTONWIDTH, 0, _WinAPI_MakeLong($iMin, $iMax), 0, "wparam", "long") <> 0
EndFunc
Func _GUICtrlToolbar_SetImageList($hWnd, $hImageList)
Return _SendMessage($hWnd, $TB_SETIMAGELIST, 0, $hImageList, 0, "wparam", "handle", "handle")
EndFunc
Func _GUICtrlToolbar_SetIndent($hWnd, $iIndent)
Return _SendMessage($hWnd, $TB_SETINDENT, $iIndent) <> 0
EndFunc
Func _GUICtrlToolbar_SetMetrics($hWnd, $iXPad, $iYPad, $iXSpacing, $iYSpacing)
Local $tMetrics = DllStructCreate($tagTBMETRICS)
Local $iMetrics = DllStructGetSize($tMetrics)
Local $iMask = BitOR($TBMF_PAD, $TBMF_BUTTONSPACING)
DllStructSetData($tMetrics, "Size", $iMetrics)
DllStructSetData($tMetrics, "Mask", $iMask)
DllStructSetData($tMetrics, "XPad", $iXPad)
DllStructSetData($tMetrics, "YPad", $iYPad)
DllStructSetData($tMetrics, "XSpacing", $iXSpacing)
DllStructSetData($tMetrics, "YSpacing", $iYSpacing)
If _WinAPI_InProcess($hWnd, $__g_hTBLastWnd) Then
_SendMessage($hWnd, $TB_SETMETRICS, 0, $tMetrics, 0, "wparam", "struct*")
Else
Local $tMemMap
Local $pMemory = _MemInit($hWnd, $iMetrics, $tMemMap)
_MemWrite($tMemMap, $tMetrics, $pMemory, $iMetrics)
_SendMessage($hWnd, $TB_SETMETRICS, 0, $pMemory, 0, "wparam", "ptr")
_MemFree($tMemMap)
EndIf
EndFunc
Func _GUICtrlToolbar_SetRows($hWnd, $iRows, $bLarger = True)
Local $tRECT = DllStructCreate($tagRECT)
If _WinAPI_InProcess($hWnd, $__g_hTBLastWnd) Then
_SendMessage($hWnd, $TB_SETROWS, _WinAPI_MakeLong($iRows, $bLarger), $tRECT, 0, "long", "struct*")
Else
Local $iRect = DllStructGetSize($tRECT)
Local $tMemMap
Local $pMemory = _MemInit($hWnd, $iRect, $tMemMap)
_SendMessage($hWnd, $TB_SETROWS, _WinAPI_MakeLong($iRows, $bLarger), $pMemory, 0, "long", "ptr")
_MemRead($tMemMap, $pMemory, $tRECT, $iRect)
_MemFree($tMemMap)
EndIf
Local $aRect[4]
$aRect[0] = DllStructGetData($tRECT, "Left")
$aRect[1] = DllStructGetData($tRECT, "Top")
$aRect[2] = DllStructGetData($tRECT, "Right")
$aRect[3] = DllStructGetData($tRECT, "Bottom")
Return $aRect
EndFunc
Global Enum $ARRAYFILL_FORCE_DEFAULT, $ARRAYFILL_FORCE_SINGLEITEM, $ARRAYFILL_FORCE_INT, $ARRAYFILL_FORCE_NUMBER, $ARRAYFILL_FORCE_PTR, $ARRAYFILL_FORCE_HWND, $ARRAYFILL_FORCE_STRING
Func _ArrayAdd(ByRef $aArray, $vValue, $iStart = 0, $sDelim_Item = "|", $sDelim_Row = @CRLF, $iForce = $ARRAYFILL_FORCE_DEFAULT)
If $iStart = Default Then $iStart = 0
If $sDelim_Item = Default Then $sDelim_Item = "|"
If $sDelim_Row = Default Then $sDelim_Row = @CRLF
If $iForce = Default Then $iForce = $ARRAYFILL_FORCE_DEFAULT
If Not IsArray($aArray) Then Return SetError(1, 0, -1)
Local $iDim_1 = UBound($aArray, $UBOUND_ROWS)
Local $hDataType = 0
Switch $iForce
Case $ARRAYFILL_FORCE_INT
$hDataType = Int
Case $ARRAYFILL_FORCE_NUMBER
$hDataType = Number
Case $ARRAYFILL_FORCE_PTR
$hDataType = Ptr
Case $ARRAYFILL_FORCE_HWND
$hDataType = Hwnd
Case $ARRAYFILL_FORCE_STRING
$hDataType = String
EndSwitch
Switch UBound($aArray, $UBOUND_DIMENSIONS)
Case 1
If $iForce = $ARRAYFILL_FORCE_SINGLEITEM Then
ReDim $aArray[$iDim_1 + 1]
$aArray[$iDim_1] = $vValue
Return $iDim_1
EndIf
If IsArray($vValue) Then
If UBound($vValue, $UBOUND_DIMENSIONS) <> 1 Then Return SetError(5, 0, -1)
$hDataType = 0
Else
Local $aTmp = StringSplit($vValue, $sDelim_Item, $STR_NOCOUNT + $STR_ENTIRESPLIT)
If UBound($aTmp, $UBOUND_ROWS) = 1 Then
$aTmp[0] = $vValue
EndIf
$vValue = $aTmp
EndIf
Local $iAdd = UBound($vValue, $UBOUND_ROWS)
ReDim $aArray[$iDim_1 + $iAdd]
For $i = 0 To $iAdd - 1
If IsFunc($hDataType) Then
$aArray[$iDim_1 + $i] = $hDataType($vValue[$i])
Else
$aArray[$iDim_1 + $i] = $vValue[$i]
EndIf
Next
Return $iDim_1 + $iAdd - 1
Case 2
Local $iDim_2 = UBound($aArray, $UBOUND_COLUMNS)
If $iStart < 0 Or $iStart > $iDim_2 - 1 Then Return SetError(4, 0, -1)
Local $iValDim_1, $iValDim_2 = 0, $iColCount
If IsArray($vValue) Then
If UBound($vValue, $UBOUND_DIMENSIONS) <> 2 Then Return SetError(5, 0, -1)
$iValDim_1 = UBound($vValue, $UBOUND_ROWS)
$iValDim_2 = UBound($vValue, $UBOUND_COLUMNS)
$hDataType = 0
Else
Local $aSplit_1 = StringSplit($vValue, $sDelim_Row, $STR_NOCOUNT + $STR_ENTIRESPLIT)
$iValDim_1 = UBound($aSplit_1, $UBOUND_ROWS)
Local $aTmp[$iValDim_1][0], $aSplit_2
For $i = 0 To $iValDim_1 - 1
$aSplit_2 = StringSplit($aSplit_1[$i], $sDelim_Item, $STR_NOCOUNT + $STR_ENTIRESPLIT)
$iColCount = UBound($aSplit_2)
If $iColCount > $iValDim_2 Then
$iValDim_2 = $iColCount
ReDim $aTmp[$iValDim_1][$iValDim_2]
EndIf
For $j = 0 To $iColCount - 1
$aTmp[$i][$j] = $aSplit_2[$j]
Next
Next
$vValue = $aTmp
EndIf
If UBound($vValue, $UBOUND_COLUMNS) + $iStart > UBound($aArray, $UBOUND_COLUMNS) Then Return SetError(3, 0, -1)
ReDim $aArray[$iDim_1 + $iValDim_1][$iDim_2]
For $iWriteTo_Index = 0 To $iValDim_1 - 1
For $j = 0 To $iDim_2 - 1
If $j < $iStart Then
$aArray[$iWriteTo_Index + $iDim_1][$j] = ""
ElseIf $j - $iStart > $iValDim_2 - 1 Then
$aArray[$iWriteTo_Index + $iDim_1][$j] = ""
Else
If IsFunc($hDataType) Then
$aArray[$iWriteTo_Index + $iDim_1][$j] = $hDataType($vValue[$iWriteTo_Index][$j - $iStart])
Else
$aArray[$iWriteTo_Index + $iDim_1][$j] = $vValue[$iWriteTo_Index][$j - $iStart]
EndIf
EndIf
Next
Next
Case Else
Return SetError(2, 0, -1)
EndSwitch
Return UBound($aArray, $UBOUND_ROWS) - 1
EndFunc
Func _ArrayDelete(ByRef $aArray, $vRange)
If Not IsArray($aArray) Then Return SetError(1, 0, -1)
Local $iDim_1 = UBound($aArray, $UBOUND_ROWS) - 1
If IsArray($vRange) Then
If UBound($vRange, $UBOUND_DIMENSIONS) <> 1 Or UBound($vRange, $UBOUND_ROWS) < 2 Then Return SetError(4, 0, -1)
Else
Local $iNumber, $aSplit_1, $aSplit_2
$vRange = StringStripWS($vRange, 8)
$aSplit_1 = StringSplit($vRange, ";")
$vRange = ""
For $i = 1 To $aSplit_1[0]
If Not StringRegExp($aSplit_1[$i], "^\d+(-\d+)?$") Then Return SetError(3, 0, -1)
$aSplit_2 = StringSplit($aSplit_1[$i], "-")
Switch $aSplit_2[0]
Case 1
$vRange &= $aSplit_2[1] & ";"
Case 2
If Number($aSplit_2[2]) >= Number($aSplit_2[1]) Then
$iNumber = $aSplit_2[1] - 1
Do
$iNumber += 1
$vRange &= $iNumber & ";"
Until $iNumber = $aSplit_2[2]
EndIf
EndSwitch
Next
$vRange = StringSplit(StringTrimRight($vRange, 1), ";")
EndIf
If $vRange[1] < 0 Or $vRange[$vRange[0]] > $iDim_1 Then Return SetError(5, 0, -1)
Local $iCopyTo_Index = 0
Switch UBound($aArray, $UBOUND_DIMENSIONS)
Case 1
For $i = 1 To $vRange[0]
$aArray[$vRange[$i]] = ChrW(0xFAB1)
Next
For $iReadFrom_Index = 0 To $iDim_1
If $aArray[$iReadFrom_Index] == ChrW(0xFAB1) Then
ContinueLoop
Else
If $iReadFrom_Index <> $iCopyTo_Index Then
$aArray[$iCopyTo_Index] = $aArray[$iReadFrom_Index]
EndIf
$iCopyTo_Index += 1
EndIf
Next
ReDim $aArray[$iDim_1 - $vRange[0] + 1]
Case 2
Local $iDim_2 = UBound($aArray, $UBOUND_COLUMNS) - 1
For $i = 1 To $vRange[0]
$aArray[$vRange[$i]][0] = ChrW(0xFAB1)
Next
For $iReadFrom_Index = 0 To $iDim_1
If $aArray[$iReadFrom_Index][0] == ChrW(0xFAB1) Then
ContinueLoop
Else
If $iReadFrom_Index <> $iCopyTo_Index Then
For $j = 0 To $iDim_2
$aArray[$iCopyTo_Index][$j] = $aArray[$iReadFrom_Index][$j]
Next
EndIf
$iCopyTo_Index += 1
EndIf
Next
ReDim $aArray[$iDim_1 - $vRange[0] + 1][$iDim_2 + 1]
Case Else
Return SetError(2, 0, False)
EndSwitch
Return UBound($aArray, $UBOUND_ROWS)
EndFunc
Func _ArrayReverse(ByRef $aArray, $iStart = 0, $iEnd = 0)
If $iStart = Default Then $iStart = 0
If $iEnd = Default Then $iEnd = 0
If Not IsArray($aArray) Then Return SetError(1, 0, 0)
If UBound($aArray, $UBOUND_DIMENSIONS) <> 1 Then Return SetError(3, 0, 0)
If Not UBound($aArray) Then Return SetError(4, 0, 0)
Local $vTmp, $iUBound = UBound($aArray) - 1
If $iEnd < 1 Or $iEnd > $iUBound Then $iEnd = $iUBound
If $iStart < 0 Then $iStart = 0
If $iStart > $iEnd Then Return SetError(2, 0, 0)
For $i = $iStart To Int(($iStart + $iEnd - 1) / 2)
$vTmp = $aArray[$i]
$aArray[$i] = $aArray[$iEnd]
$aArray[$iEnd] = $vTmp
$iEnd -= 1
Next
Return 1
EndFunc
Func _ArraySearch(Const ByRef $aArray, $vValue, $iStart = 0, $iEnd = 0, $iCase = 0, $iCompare = 0, $iForward = 1, $iSubItem = -1, $bRow = False)
If $iStart = Default Then $iStart = 0
If $iEnd = Default Then $iEnd = 0
If $iCase = Default Then $iCase = 0
If $iCompare = Default Then $iCompare = 0
If $iForward = Default Then $iForward = 1
If $iSubItem = Default Then $iSubItem = -1
If $bRow = Default Then $bRow = False
If Not IsArray($aArray) Then Return SetError(1, 0, -1)
Local $iDim_1 = UBound($aArray) - 1
If $iDim_1 = -1 Then Return SetError(3, 0, -1)
Local $iDim_2 = UBound($aArray, $UBOUND_COLUMNS) - 1
Local $bCompType = False
If $iCompare = 2 Then
$iCompare = 0
$bCompType = True
EndIf
If $bRow Then
If UBound($aArray, $UBOUND_DIMENSIONS) = 1 Then Return SetError(5, 0, -1)
If $iEnd < 1 Or $iEnd > $iDim_2 Then $iEnd = $iDim_2
If $iStart < 0 Then $iStart = 0
If $iStart > $iEnd Then Return SetError(4, 0, -1)
Else
If $iEnd < 1 Or $iEnd > $iDim_1 Then $iEnd = $iDim_1
If $iStart < 0 Then $iStart = 0
If $iStart > $iEnd Then Return SetError(4, 0, -1)
EndIf
Local $iStep = 1
If Not $iForward Then
Local $iTmp = $iStart
$iStart = $iEnd
$iEnd = $iTmp
$iStep = -1
EndIf
Switch UBound($aArray, $UBOUND_DIMENSIONS)
Case 1
If Not $iCompare Then
If Not $iCase Then
For $i = $iStart To $iEnd Step $iStep
If $bCompType And VarGetType($aArray[$i]) <> VarGetType($vValue) Then ContinueLoop
If $aArray[$i] = $vValue Then Return $i
Next
Else
For $i = $iStart To $iEnd Step $iStep
If $bCompType And VarGetType($aArray[$i]) <> VarGetType($vValue) Then ContinueLoop
If $aArray[$i] == $vValue Then Return $i
Next
EndIf
Else
For $i = $iStart To $iEnd Step $iStep
If $iCompare = 3 Then
If StringRegExp($aArray[$i], $vValue) Then Return $i
Else
If StringInStr($aArray[$i], $vValue, $iCase) > 0 Then Return $i
EndIf
Next
EndIf
Case 2
Local $iDim_Sub
If $bRow Then
$iDim_Sub = $iDim_1
If $iSubItem > $iDim_Sub Then $iSubItem = $iDim_Sub
If $iSubItem < 0 Then
$iSubItem = 0
Else
$iDim_Sub = $iSubItem
EndIf
Else
$iDim_Sub = $iDim_2
If $iSubItem > $iDim_Sub Then $iSubItem = $iDim_Sub
If $iSubItem < 0 Then
$iSubItem = 0
Else
$iDim_Sub = $iSubItem
EndIf
EndIf
For $j = $iSubItem To $iDim_Sub
If Not $iCompare Then
If Not $iCase Then
For $i = $iStart To $iEnd Step $iStep
If $bRow Then
If $bCompType And VarGetType($aArray[$j][$j]) <> VarGetType($vValue) Then ContinueLoop
If $aArray[$j][$i] = $vValue Then Return $i
Else
If $bCompType And VarGetType($aArray[$i][$j]) <> VarGetType($vValue) Then ContinueLoop
If $aArray[$i][$j] = $vValue Then Return $i
EndIf
Next
Else
For $i = $iStart To $iEnd Step $iStep
If $bRow Then
If $bCompType And VarGetType($aArray[$j][$i]) <> VarGetType($vValue) Then ContinueLoop
If $aArray[$j][$i] == $vValue Then Return $i
Else
If $bCompType And VarGetType($aArray[$i][$j]) <> VarGetType($vValue) Then ContinueLoop
If $aArray[$i][$j] == $vValue Then Return $i
EndIf
Next
EndIf
Else
For $i = $iStart To $iEnd Step $iStep
If $iCompare = 3 Then
If $bRow Then
If StringRegExp($aArray[$j][$i], $vValue) Then Return $i
Else
If StringRegExp($aArray[$i][$j], $vValue) Then Return $i
EndIf
Else
If $bRow Then
If StringInStr($aArray[$j][$i], $vValue, $iCase) > 0 Then Return $i
Else
If StringInStr($aArray[$i][$j], $vValue, $iCase) > 0 Then Return $i
EndIf
EndIf
Next
EndIf
Next
Case Else
Return SetError(2, 0, -1)
EndSwitch
Return SetError(6, 0, -1)
EndFunc
Func _ArraySort(ByRef $aArray, $iDescending = 0, $iStart = 0, $iEnd = 0, $iSubItem = 0, $iPivot = 0)
If $iDescending = Default Then $iDescending = 0
If $iStart = Default Then $iStart = 0
If $iEnd = Default Then $iEnd = 0
If $iSubItem = Default Then $iSubItem = 0
If $iPivot = Default Then $iPivot = 0
If Not IsArray($aArray) Then Return SetError(1, 0, 0)
Local $iUBound = UBound($aArray) - 1
If $iUBound = -1 Then Return SetError(5, 0, 0)
If $iEnd = Default Then $iEnd = 0
If $iEnd < 1 Or $iEnd > $iUBound Or $iEnd = Default Then $iEnd = $iUBound
If $iStart < 0 Or $iStart = Default Then $iStart = 0
If $iStart > $iEnd Then Return SetError(2, 0, 0)
If $iDescending = Default Then $iDescending = 0
If $iPivot = Default Then $iPivot = 0
If $iSubItem = Default Then $iSubItem = 0
Switch UBound($aArray, $UBOUND_DIMENSIONS)
Case 1
If $iPivot Then
__ArrayDualPivotSort($aArray, $iStart, $iEnd)
Else
__ArrayQuickSort1D($aArray, $iStart, $iEnd)
EndIf
If $iDescending Then _ArrayReverse($aArray, $iStart, $iEnd)
Case 2
If $iPivot Then Return SetError(6, 0, 0)
Local $iSubMax = UBound($aArray, $UBOUND_COLUMNS) - 1
If $iSubItem > $iSubMax Then Return SetError(3, 0, 0)
If $iDescending Then
$iDescending = -1
Else
$iDescending = 1
EndIf
__ArrayQuickSort2D($aArray, $iDescending, $iStart, $iEnd, $iSubItem, $iSubMax)
Case Else
Return SetError(4, 0, 0)
EndSwitch
Return 1
EndFunc
Func __ArrayQuickSort1D(ByRef $aArray, Const ByRef $iStart, Const ByRef $iEnd)
If $iEnd <= $iStart Then Return
Local $vTmp
If($iEnd - $iStart) < 15 Then
Local $vCur
For $i = $iStart + 1 To $iEnd
$vTmp = $aArray[$i]
If IsNumber($vTmp) Then
For $j = $i - 1 To $iStart Step -1
$vCur = $aArray[$j]
If($vTmp >= $vCur And IsNumber($vCur)) Or(Not IsNumber($vCur) And StringCompare($vTmp, $vCur) >= 0) Then ExitLoop
$aArray[$j + 1] = $vCur
Next
Else
For $j = $i - 1 To $iStart Step -1
If(StringCompare($vTmp, $aArray[$j]) >= 0) Then ExitLoop
$aArray[$j + 1] = $aArray[$j]
Next
EndIf
$aArray[$j + 1] = $vTmp
Next
Return
EndIf
Local $L = $iStart, $R = $iEnd, $vPivot = $aArray[Int(($iStart + $iEnd) / 2)], $bNum = IsNumber($vPivot)
Do
If $bNum Then
While($aArray[$L] < $vPivot And IsNumber($aArray[$L])) Or(Not IsNumber($aArray[$L]) And StringCompare($aArray[$L], $vPivot) < 0)
$L += 1
WEnd
While($aArray[$R] > $vPivot And IsNumber($aArray[$R])) Or(Not IsNumber($aArray[$R]) And StringCompare($aArray[$R], $vPivot) > 0)
$R -= 1
WEnd
Else
While(StringCompare($aArray[$L], $vPivot) < 0)
$L += 1
WEnd
While(StringCompare($aArray[$R], $vPivot) > 0)
$R -= 1
WEnd
EndIf
If $L <= $R Then
$vTmp = $aArray[$L]
$aArray[$L] = $aArray[$R]
$aArray[$R] = $vTmp
$L += 1
$R -= 1
EndIf
Until $L > $R
__ArrayQuickSort1D($aArray, $iStart, $R)
__ArrayQuickSort1D($aArray, $L, $iEnd)
EndFunc
Func __ArrayQuickSort2D(ByRef $aArray, Const ByRef $iStep, Const ByRef $iStart, Const ByRef $iEnd, Const ByRef $iSubItem, Const ByRef $iSubMax)
If $iEnd <= $iStart Then Return
Local $vTmp, $L = $iStart, $R = $iEnd, $vPivot = $aArray[Int(($iStart + $iEnd) / 2)][$iSubItem], $bNum = IsNumber($vPivot)
Do
If $bNum Then
While($iStep *($aArray[$L][$iSubItem] - $vPivot) < 0 And IsNumber($aArray[$L][$iSubItem])) Or(Not IsNumber($aArray[$L][$iSubItem]) And $iStep * StringCompare($aArray[$L][$iSubItem], $vPivot) < 0)
$L += 1
WEnd
While($iStep *($aArray[$R][$iSubItem] - $vPivot) > 0 And IsNumber($aArray[$R][$iSubItem])) Or(Not IsNumber($aArray[$R][$iSubItem]) And $iStep * StringCompare($aArray[$R][$iSubItem], $vPivot) > 0)
$R -= 1
WEnd
Else
While($iStep * StringCompare($aArray[$L][$iSubItem], $vPivot) < 0)
$L += 1
WEnd
While($iStep * StringCompare($aArray[$R][$iSubItem], $vPivot) > 0)
$R -= 1
WEnd
EndIf
If $L <= $R Then
For $i = 0 To $iSubMax
$vTmp = $aArray[$L][$i]
$aArray[$L][$i] = $aArray[$R][$i]
$aArray[$R][$i] = $vTmp
Next
$L += 1
$R -= 1
EndIf
Until $L > $R
__ArrayQuickSort2D($aArray, $iStep, $iStart, $R, $iSubItem, $iSubMax)
__ArrayQuickSort2D($aArray, $iStep, $L, $iEnd, $iSubItem, $iSubMax)
EndFunc
Func __ArrayDualPivotSort(ByRef $aArray, $iPivot_Left, $iPivot_Right, $bLeftMost = True)
If $iPivot_Left > $iPivot_Right Then Return
Local $iLength = $iPivot_Right - $iPivot_Left + 1
Local $i, $j, $k, $iAi, $iAk, $iA1, $iA2, $iLast
If $iLength < 45 Then
If $bLeftMost Then
$i = $iPivot_Left
While $i < $iPivot_Right
$j = $i
$iAi = $aArray[$i + 1]
While $iAi < $aArray[$j]
$aArray[$j + 1] = $aArray[$j]
$j -= 1
If $j + 1 = $iPivot_Left Then ExitLoop
WEnd
$aArray[$j + 1] = $iAi
$i += 1
WEnd
Else
While 1
If $iPivot_Left >= $iPivot_Right Then Return 1
$iPivot_Left += 1
If $aArray[$iPivot_Left] < $aArray[$iPivot_Left - 1] Then ExitLoop
WEnd
While 1
$k = $iPivot_Left
$iPivot_Left += 1
If $iPivot_Left > $iPivot_Right Then ExitLoop
$iA1 = $aArray[$k]
$iA2 = $aArray[$iPivot_Left]
If $iA1 < $iA2 Then
$iA2 = $iA1
$iA1 = $aArray[$iPivot_Left]
EndIf
$k -= 1
While $iA1 < $aArray[$k]
$aArray[$k + 2] = $aArray[$k]
$k -= 1
WEnd
$aArray[$k + 2] = $iA1
While $iA2 < $aArray[$k]
$aArray[$k + 1] = $aArray[$k]
$k -= 1
WEnd
$aArray[$k + 1] = $iA2
$iPivot_Left += 1
WEnd
$iLast = $aArray[$iPivot_Right]
$iPivot_Right -= 1
While $iLast < $aArray[$iPivot_Right]
$aArray[$iPivot_Right + 1] = $aArray[$iPivot_Right]
$iPivot_Right -= 1
WEnd
$aArray[$iPivot_Right + 1] = $iLast
EndIf
Return 1
EndIf
Local $iSeventh = BitShift($iLength, 3) + BitShift($iLength, 6) + 1
Local $iE1, $iE2, $iE3, $iE4, $iE5, $t
$iE3 = Ceiling(($iPivot_Left + $iPivot_Right) / 2)
$iE2 = $iE3 - $iSeventh
$iE1 = $iE2 - $iSeventh
$iE4 = $iE3 + $iSeventh
$iE5 = $iE4 + $iSeventh
If $aArray[$iE2] < $aArray[$iE1] Then
$t = $aArray[$iE2]
$aArray[$iE2] = $aArray[$iE1]
$aArray[$iE1] = $t
EndIf
If $aArray[$iE3] < $aArray[$iE2] Then
$t = $aArray[$iE3]
$aArray[$iE3] = $aArray[$iE2]
$aArray[$iE2] = $t
If $t < $aArray[$iE1] Then
$aArray[$iE2] = $aArray[$iE1]
$aArray[$iE1] = $t
EndIf
EndIf
If $aArray[$iE4] < $aArray[$iE3] Then
$t = $aArray[$iE4]
$aArray[$iE4] = $aArray[$iE3]
$aArray[$iE3] = $t
If $t < $aArray[$iE2] Then
$aArray[$iE3] = $aArray[$iE2]
$aArray[$iE2] = $t
If $t < $aArray[$iE1] Then
$aArray[$iE2] = $aArray[$iE1]
$aArray[$iE1] = $t
EndIf
EndIf
EndIf
If $aArray[$iE5] < $aArray[$iE4] Then
$t = $aArray[$iE5]
$aArray[$iE5] = $aArray[$iE4]
$aArray[$iE4] = $t
If $t < $aArray[$iE3] Then
$aArray[$iE4] = $aArray[$iE3]
$aArray[$iE3] = $t
If $t < $aArray[$iE2] Then
$aArray[$iE3] = $aArray[$iE2]
$aArray[$iE2] = $t
If $t < $aArray[$iE1] Then
$aArray[$iE2] = $aArray[$iE1]
$aArray[$iE1] = $t
EndIf
EndIf
EndIf
EndIf
Local $iLess = $iPivot_Left
Local $iGreater = $iPivot_Right
If(($aArray[$iE1] <> $aArray[$iE2]) And($aArray[$iE2] <> $aArray[$iE3]) And($aArray[$iE3] <> $aArray[$iE4]) And($aArray[$iE4] <> $aArray[$iE5])) Then
Local $iPivot_1 = $aArray[$iE2]
Local $iPivot_2 = $aArray[$iE4]
$aArray[$iE2] = $aArray[$iPivot_Left]
$aArray[$iE4] = $aArray[$iPivot_Right]
Do
$iLess += 1
Until $aArray[$iLess] >= $iPivot_1
Do
$iGreater -= 1
Until $aArray[$iGreater] <= $iPivot_2
$k = $iLess
While $k <= $iGreater
$iAk = $aArray[$k]
If $iAk < $iPivot_1 Then
$aArray[$k] = $aArray[$iLess]
$aArray[$iLess] = $iAk
$iLess += 1
ElseIf $iAk > $iPivot_2 Then
While $aArray[$iGreater] > $iPivot_2
$iGreater -= 1
If $iGreater + 1 = $k Then ExitLoop 2
WEnd
If $aArray[$iGreater] < $iPivot_1 Then
$aArray[$k] = $aArray[$iLess]
$aArray[$iLess] = $aArray[$iGreater]
$iLess += 1
Else
$aArray[$k] = $aArray[$iGreater]
EndIf
$aArray[$iGreater] = $iAk
$iGreater -= 1
EndIf
$k += 1
WEnd
$aArray[$iPivot_Left] = $aArray[$iLess - 1]
$aArray[$iLess - 1] = $iPivot_1
$aArray[$iPivot_Right] = $aArray[$iGreater + 1]
$aArray[$iGreater + 1] = $iPivot_2
__ArrayDualPivotSort($aArray, $iPivot_Left, $iLess - 2, True)
__ArrayDualPivotSort($aArray, $iGreater + 2, $iPivot_Right, False)
If($iLess < $iE1) And($iE5 < $iGreater) Then
While $aArray[$iLess] = $iPivot_1
$iLess += 1
WEnd
While $aArray[$iGreater] = $iPivot_2
$iGreater -= 1
WEnd
$k = $iLess
While $k <= $iGreater
$iAk = $aArray[$k]
If $iAk = $iPivot_1 Then
$aArray[$k] = $aArray[$iLess]
$aArray[$iLess] = $iAk
$iLess += 1
ElseIf $iAk = $iPivot_2 Then
While $aArray[$iGreater] = $iPivot_2
$iGreater -= 1
If $iGreater + 1 = $k Then ExitLoop 2
WEnd
If $aArray[$iGreater] = $iPivot_1 Then
$aArray[$k] = $aArray[$iLess]
$aArray[$iLess] = $iPivot_1
$iLess += 1
Else
$aArray[$k] = $aArray[$iGreater]
EndIf
$aArray[$iGreater] = $iAk
$iGreater -= 1
EndIf
$k += 1
WEnd
EndIf
__ArrayDualPivotSort($aArray, $iLess, $iGreater, False)
Else
Local $iPivot = $aArray[$iE3]
$k = $iLess
While $k <= $iGreater
If $aArray[$k] = $iPivot Then
$k += 1
ContinueLoop
EndIf
$iAk = $aArray[$k]
If $iAk < $iPivot Then
$aArray[$k] = $aArray[$iLess]
$aArray[$iLess] = $iAk
$iLess += 1
Else
While $aArray[$iGreater] > $iPivot
$iGreater -= 1
WEnd
If $aArray[$iGreater] < $iPivot Then
$aArray[$k] = $aArray[$iLess]
$aArray[$iLess] = $aArray[$iGreater]
$iLess += 1
Else
$aArray[$k] = $iPivot
EndIf
$aArray[$iGreater] = $iAk
$iGreater -= 1
EndIf
$k += 1
WEnd
__ArrayDualPivotSort($aArray, $iPivot_Left, $iLess - 1, True)
__ArrayDualPivotSort($aArray, $iGreater + 1, $iPivot_Right, False)
EndIf
EndFunc
Global $__g_hLVLastWnd
Func _GUICtrlListView_AddItem($hWnd, $sText, $iImage = -1, $iParam = 0)
Return _GUICtrlListView_InsertItem($hWnd, $sText, -1, $iImage, $iParam)
EndFunc
Func _GUICtrlListView_DeleteAllItems($hWnd)
If _GUICtrlListView_GetItemCount($hWnd) = 0 Then Return True
Local $vCID = 0
If IsHWnd($hWnd) Then
$vCID = _WinAPI_GetDlgCtrlID($hWnd)
Else
$vCID = $hWnd
$hWnd = GUICtrlGetHandle($hWnd)
EndIf
If $vCID < $_UDF_STARTID Then
Local $iParam = 0
For $iIndex = _GUICtrlListView_GetItemCount($hWnd) - 1 To 0 Step -1
$iParam = _GUICtrlListView_GetItemParam($hWnd, $iIndex)
If GUICtrlGetState($iParam) > 0 And GUICtrlGetHandle($iParam) = 0 Then
GUICtrlDelete($iParam)
EndIf
Next
If _GUICtrlListView_GetItemCount($hWnd) = 0 Then Return True
EndIf
Return _SendMessage($hWnd, $LVM_DELETEALLITEMS) <> 0
EndFunc
Func _GUICtrlListView_DeleteItem($hWnd, $iIndex)
Local $vCID = 0
If IsHWnd($hWnd) Then
$vCID = _WinAPI_GetDlgCtrlID($hWnd)
Else
$vCID = $hWnd
$hWnd = GUICtrlGetHandle($hWnd)
EndIf
If $vCID < $_UDF_STARTID Then
Local $iParam = _GUICtrlListView_GetItemParam($hWnd, $iIndex)
If GUICtrlGetState($iParam) > 0 And GUICtrlGetHandle($iParam) = 0 Then
If GUICtrlDelete($iParam) Then
Return True
EndIf
EndIf
EndIf
Return _SendMessage($hWnd, $LVM_DELETEITEM, $iIndex) <> 0
EndFunc
Func _GUICtrlListView_EditLabel($hWnd, $iIndex)
Local $bUnicode = _GUICtrlListView_GetUnicodeFormat($hWnd)
Local $aResult
If IsHWnd($hWnd) Then
$aResult = DllCall("user32.dll", "hwnd", "SetFocus", "hwnd", $hWnd)
If @error Then Return SetError(@error, @extended, 0)
If $aResult = 0 Then Return 0
If $bUnicode Then
Return _SendMessage($hWnd, $LVM_EDITLABELW, $iIndex, 0, 0, "wparam", "lparam", "hwnd")
Else
Return _SendMessage($hWnd, $LVM_EDITLABEL, $iIndex, 0, 0, "wparam", "lparam", "hwnd")
EndIf
Else
$aResult = DllCall("user32.dll", "hwnd", "SetFocus", "hwnd", GUICtrlGetHandle($hWnd))
If @error Then Return SetError(@error, @extended, 0)
If $aResult = 0 Then Return 0
If $bUnicode Then
Return HWnd(GUICtrlSendMsg($hWnd, $LVM_EDITLABELW, $iIndex, 0))
Else
Return HWnd(GUICtrlSendMsg($hWnd, $LVM_EDITLABEL, $iIndex, 0))
EndIf
EndIf
EndFunc
Func _GUICtrlListView_GetColumnCount($hWnd)
Return _SendMessage(_GUICtrlListView_GetHeader($hWnd), 0x1200)
EndFunc
Func _GUICtrlListView_GetHeader($hWnd)
If IsHWnd($hWnd) Then
Return HWnd(_SendMessage($hWnd, $LVM_GETHEADER))
Else
Return HWnd(GUICtrlSendMsg($hWnd, $LVM_GETHEADER, 0, 0))
EndIf
EndFunc
Func _GUICtrlListView_GetItemCount($hWnd)
If IsHWnd($hWnd) Then
Return _SendMessage($hWnd, $LVM_GETITEMCOUNT)
Else
Return GUICtrlSendMsg($hWnd, $LVM_GETITEMCOUNT, 0, 0)
EndIf
EndFunc
Func _GUICtrlListView_GetItemEx($hWnd, ByRef $tItem)
Local $bUnicode = _GUICtrlListView_GetUnicodeFormat($hWnd)
Local $iRet
If IsHWnd($hWnd) Then
If _WinAPI_InProcess($hWnd, $__g_hLVLastWnd) Then
$iRet = _SendMessage($hWnd, $LVM_GETITEMW, 0, $tItem, 0, "wparam", "struct*")
Else
Local $iItem = DllStructGetSize($tItem)
Local $tMemMap
Local $pMemory = _MemInit($hWnd, $iItem, $tMemMap)
_MemWrite($tMemMap, $tItem)
If $bUnicode Then
_SendMessage($hWnd, $LVM_GETITEMW, 0, $pMemory, 0, "wparam", "ptr")
Else
_SendMessage($hWnd, $LVM_GETITEMA, 0, $pMemory, 0, "wparam", "ptr")
EndIf
_MemRead($tMemMap, $pMemory, $tItem, $iItem)
_MemFree($tMemMap)
EndIf
Else
Local $pItem = DllStructGetPtr($tItem)
If $bUnicode Then
$iRet = GUICtrlSendMsg($hWnd, $LVM_GETITEMW, 0, $pItem)
Else
$iRet = GUICtrlSendMsg($hWnd, $LVM_GETITEMA, 0, $pItem)
EndIf
EndIf
Return $iRet <> 0
EndFunc
Func _GUICtrlListView_GetItemParam($hWnd, $iIndex)
Local $tItem = DllStructCreate($tagLVITEM)
DllStructSetData($tItem, "Mask", $LVIF_PARAM)
DllStructSetData($tItem, "Item", $iIndex)
_GUICtrlListView_GetItemEx($hWnd, $tItem)
Return DllStructGetData($tItem, "Param")
EndFunc
Func _GUICtrlListView_GetSelectedIndices($hWnd, $bArray = False)
Local $sIndices, $aIndices[1] = [0]
Local $iRet, $iCount = _GUICtrlListView_GetItemCount($hWnd)
For $iItem = 0 To $iCount
If IsHWnd($hWnd) Then
$iRet = _SendMessage($hWnd, $LVM_GETITEMSTATE, $iItem, $LVIS_SELECTED)
Else
$iRet = GUICtrlSendMsg($hWnd, $LVM_GETITEMSTATE, $iItem, $LVIS_SELECTED)
EndIf
If $iRet Then
If(Not $bArray) Then
If StringLen($sIndices) Then
$sIndices &= "|" & $iItem
Else
$sIndices = $iItem
EndIf
Else
ReDim $aIndices[UBound($aIndices) + 1]
$aIndices[0] = UBound($aIndices) - 1
$aIndices[UBound($aIndices) - 1] = $iItem
EndIf
EndIf
Next
If(Not $bArray) Then
Return String($sIndices)
Else
Return $aIndices
EndIf
EndFunc
Func _GUICtrlListView_GetUnicodeFormat($hWnd)
If IsHWnd($hWnd) Then
Return _SendMessage($hWnd, $LVM_GETUNICODEFORMAT) <> 0
Else
Return GUICtrlSendMsg($hWnd, $LVM_GETUNICODEFORMAT, 0, 0) <> 0
EndIf
EndFunc
Func _GUICtrlListView_InsertItem($hWnd, $sText, $iIndex = -1, $iImage = -1, $iParam = 0)
Local $bUnicode = _GUICtrlListView_GetUnicodeFormat($hWnd)
Local $iBuffer, $tBuffer, $iRet
If $iIndex = -1 Then $iIndex = 999999999
Local $tItem = DllStructCreate($tagLVITEM)
DllStructSetData($tItem, "Param", $iParam)
$iBuffer = StringLen($sText) + 1
If $bUnicode Then
$tBuffer = DllStructCreate("wchar Text[" & $iBuffer & "]")
$iBuffer *= 2
Else
$tBuffer = DllStructCreate("char Text[" & $iBuffer & "]")
EndIf
DllStructSetData($tBuffer, "Text", $sText)
DllStructSetData($tItem, "Text", DllStructGetPtr($tBuffer))
DllStructSetData($tItem, "TextMax", $iBuffer)
Local $iMask = BitOR($LVIF_TEXT, $LVIF_PARAM)
If $iImage >= 0 Then $iMask = BitOR($iMask, $LVIF_IMAGE)
DllStructSetData($tItem, "Mask", $iMask)
DllStructSetData($tItem, "Item", $iIndex)
DllStructSetData($tItem, "Image", $iImage)
If IsHWnd($hWnd) Then
If _WinAPI_InProcess($hWnd, $__g_hLVLastWnd) Or($sText = -1) Then
$iRet = _SendMessage($hWnd, $LVM_INSERTITEMW, 0, $tItem, 0, "wparam", "struct*")
Else
Local $iItem = DllStructGetSize($tItem)
Local $tMemMap
Local $pMemory = _MemInit($hWnd, $iItem + $iBuffer, $tMemMap)
Local $pText = $pMemory + $iItem
DllStructSetData($tItem, "Text", $pText)
_MemWrite($tMemMap, $tItem, $pMemory, $iItem)
_MemWrite($tMemMap, $tBuffer, $pText, $iBuffer)
If $bUnicode Then
$iRet = _SendMessage($hWnd, $LVM_INSERTITEMW, 0, $pMemory, 0, "wparam", "ptr")
Else
$iRet = _SendMessage($hWnd, $LVM_INSERTITEMA, 0, $pMemory, 0, "wparam", "ptr")
EndIf
_MemFree($tMemMap)
EndIf
Else
Local $pItem = DllStructGetPtr($tItem)
If $bUnicode Then
$iRet = GUICtrlSendMsg($hWnd, $LVM_INSERTITEMW, 0, $pItem)
Else
$iRet = GUICtrlSendMsg($hWnd, $LVM_INSERTITEMA, 0, $pItem)
EndIf
EndIf
Return $iRet
EndFunc
Func _GUICtrlListView_SetColumnWidth($hWnd, $iCol, $iWidth)
If IsHWnd($hWnd) Then
Return _SendMessage($hWnd, $LVM_SETCOLUMNWIDTH, $iCol, $iWidth)
Else
Return GUICtrlSendMsg($hWnd, $LVM_SETCOLUMNWIDTH, $iCol, $iWidth)
EndIf
EndFunc
Func _GUICtrlListView_SetItemText($hWnd, $iIndex, $sText, $iSubItem = 0)
Local $bUnicode = _GUICtrlListView_GetUnicodeFormat($hWnd)
Local $iRet
If $iSubItem = -1 Then
Local $sSeparatorChar = Opt('GUIDataSeparatorChar')
Local $i_Cols = _GUICtrlListView_GetColumnCount($hWnd)
Local $a_Text = StringSplit($sText, $sSeparatorChar)
If $i_Cols > $a_Text[0] Then $i_Cols = $a_Text[0]
For $i = 1 To $i_Cols
$iRet = _GUICtrlListView_SetItemText($hWnd, $iIndex, $a_Text[$i], $i - 1)
If Not $iRet Then ExitLoop
Next
Return $iRet
EndIf
Local $iBuffer = StringLen($sText) + 1
Local $tBuffer
If $bUnicode Then
$tBuffer = DllStructCreate("wchar Text[" & $iBuffer & "]")
$iBuffer *= 2
Else
$tBuffer = DllStructCreate("char Text[" & $iBuffer & "]")
EndIf
Local $pBuffer = DllStructGetPtr($tBuffer)
Local $tItem = DllStructCreate($tagLVITEM)
DllStructSetData($tBuffer, "Text", $sText)
DllStructSetData($tItem, "Mask", $LVIF_TEXT)
DllStructSetData($tItem, "item", $iIndex)
DllStructSetData($tItem, "SubItem", $iSubItem)
If IsHWnd($hWnd) Then
If _WinAPI_InProcess($hWnd, $__g_hLVLastWnd) Then
DllStructSetData($tItem, "Text", $pBuffer)
$iRet = _SendMessage($hWnd, $LVM_SETITEMW, 0, $tItem, 0, "wparam", "struct*")
Else
Local $iItem = DllStructGetSize($tItem)
Local $tMemMap
Local $pMemory = _MemInit($hWnd, $iItem + $iBuffer, $tMemMap)
Local $pText = $pMemory + $iItem
DllStructSetData($tItem, "Text", $pText)
_MemWrite($tMemMap, $tItem, $pMemory, $iItem)
_MemWrite($tMemMap, $tBuffer, $pText, $iBuffer)
If $bUnicode Then
$iRet = _SendMessage($hWnd, $LVM_SETITEMW, 0, $pMemory, 0, "wparam", "ptr")
Else
$iRet = _SendMessage($hWnd, $LVM_SETITEMA, 0, $pMemory, 0, "wparam", "ptr")
EndIf
_MemFree($tMemMap)
EndIf
Else
Local $pItem = DllStructGetPtr($tItem)
DllStructSetData($tItem, "Text", $pBuffer)
If $bUnicode Then
$iRet = GUICtrlSendMsg($hWnd, $LVM_SETITEMW, 0, $pItem)
Else
$iRet = GUICtrlSendMsg($hWnd, $LVM_SETITEMA, 0, $pItem)
EndIf
EndIf
Return $iRet <> 0
EndFunc
Global Const $__IPADDRESSCONSTANT_WM_USER = 0X400
Global Const $IPM_CLEARADDRESS =($__IPADDRESSCONSTANT_WM_USER + 100)
Global Const $IPM_SETADDRESS =($__IPADDRESSCONSTANT_WM_USER + 101)
Global Const $IPM_GETADDRESS =($__IPADDRESSCONSTANT_WM_USER + 102)
Global Const $IPN_FIRST =(-860)
Global Const $IPN_FIELDCHANGED =($IPN_FIRST - 0)
Global $__g_hIPLastWnd
Global Const $__IPADDRESSCONSTANT_ClassName = "SysIPAddress32"
Global Const $__IPADDRESSCONSTANT_DEFAULT_GUI_FONT = 17
Global Const $__IPADDRESSCONSTANT_PROOF_QUALITY = 2
Func _GUICtrlIpAddress_Create($hWnd, $iX, $iY, $iWidth = 125, $iHeight = 25, $iStyles = 0x00000000, $iExstyles = 0x00000000)
If Not IsHWnd($hWnd) Then Return SetError(1, 0, 0)
If $iStyles = -1 Then $iStyles = 0x00000000
If $iExstyles = -1 Then $iExstyles = 0x00000000
Local $iStyle = BitOR($__UDFGUICONSTANT_WS_CHILD, $__UDFGUICONSTANT_WS_VISIBLE, $__UDFGUICONSTANT_WS_TABSTOP, $iStyles)
Local Const $ICC_INTERNET_CLASSES = 0x0800
Local $tICCE = DllStructCreate('dword dwSize;dword dwICC')
DllStructSetData($tICCE, "dwSize", DllStructGetSize($tICCE))
DllStructSetData($tICCE, "dwICC", $ICC_INTERNET_CLASSES)
DllCall('comctl32.dll', 'bool', 'InitCommonControlsEx', 'struct*', $tICCE)
If @error Then Return SetError(@error, @extended, 0)
Local $nCtrlID = __UDF_GetNextGlobalID($hWnd)
If @error Then Return SetError(@error, @extended, 0)
Local $hIPAddress = _WinAPI_CreateWindowEx($iExstyles, $__IPADDRESSCONSTANT_ClassName, "", $iStyle, $iX, $iY, $iWidth, $iHeight, $hWnd, $nCtrlID)
_WinAPI_SetFont($hIPAddress, _WinAPI_GetStockObject($__IPADDRESSCONSTANT_DEFAULT_GUI_FONT))
Return $hIPAddress
EndFunc
Func _GUICtrlIpAddress_ClearAddress($hWnd)
_SendMessage($hWnd, $IPM_CLEARADDRESS)
EndFunc
Func _GUICtrlIpAddress_Get($hWnd)
Local $tIP = _GUICtrlIpAddress_GetEx($hWnd)
If @error Then Return SetError(2, 2, "")
Return StringFormat("%d.%d.%d.%d", DllStructGetData($tIP, "Field1"), DllStructGetData($tIP, "Field2"), DllStructGetData($tIP, "Field3"), DllStructGetData($tIP, "Field4"))
EndFunc
Func _GUICtrlIpAddress_GetEx($hWnd)
Local $tIP = DllStructCreate($tagGETIPAddress)
If @error Then Return SetError(1, 1, "")
If _WinAPI_InProcess($hWnd, $__g_hIPLastWnd) Then
_SendMessage($hWnd, $IPM_GETADDRESS, 0, $tIP, 0, "wparam", "struct*")
Else
Local $iIP = DllStructGetSize($tIP)
Local $tMemMap
Local $pMemory = _MemInit($hWnd, $iIP, $tMemMap)
_SendMessage($hWnd, $IPM_GETADDRESS, 0, $pMemory, 0, "wparam", "ptr")
_MemRead($tMemMap, $pMemory, $tIP, $iIP)
_MemFree($tMemMap)
EndIf
Return $tIP
EndFunc
Func _GUICtrlIpAddress_Set($hWnd, $sAddress)
Local $aAddress = StringSplit($sAddress, ".")
If $aAddress[0] = 4 Then
Local $tIP = DllStructCreate($tagGETIPAddress)
For $x = 1 To 4
DllStructSetData($tIP, "Field" & $x, $aAddress[$x])
Next
_GUICtrlIpAddress_SetEx($hWnd, $tIP)
EndIf
EndFunc
Func _GUICtrlIpAddress_SetEx($hWnd, $tIP)
_SendMessage($hWnd, $IPM_SETADDRESS, 0,  _WinAPI_MakeLong(BitOR(DllStructGetData($tIP, "Field4"), 0x100 * DllStructGetData($tIP, "Field3")), BitOR(DllStructGetData($tIP, "Field2"), 0x100 * DllStructGetData($tIP, "Field1"))))
EndFunc
Func _GUICtrlMenu_GetItemText($hMenu, $iItem, $bByPos = True)
Local $iByPos = 0
If $bByPos Then $iByPos = $MF_BYPOSITION
Local $aResult = DllCall("user32.dll", "int", "GetMenuStringW", "handle", $hMenu, "uint", $iItem, "wstr", "", "int", 4096, "uint", $iByPos)
If @error Then Return SetError(@error, @extended, 0)
Return SetExtended($aResult[0], $aResult[3])
EndFunc
Func _Singleton($sOccurrenceName, $iFlag = 0)
Local Const $ERROR_ALREADY_EXISTS = 183
Local Const $SECURITY_DESCRIPTOR_REVISION = 1
Local $tSecurityAttributes = 0
If BitAND($iFlag, 2) Then
Local $tSecurityDescriptor = DllStructCreate("byte;byte;word;ptr[4]")
Local $aRet = DllCall("advapi32.dll", "bool", "InitializeSecurityDescriptor", "struct*", $tSecurityDescriptor, "dword", $SECURITY_DESCRIPTOR_REVISION)
If @error Then Return SetError(@error, @extended, 0)
If $aRet[0] Then
$aRet = DllCall("advapi32.dll", "bool", "SetSecurityDescriptorDacl", "struct*", $tSecurityDescriptor, "bool", 1, "ptr", 0, "bool", 0)
If @error Then Return SetError(@error, @extended, 0)
If $aRet[0] Then
$tSecurityAttributes = DllStructCreate($tagSECURITY_ATTRIBUTES)
DllStructSetData($tSecurityAttributes, 1, DllStructGetSize($tSecurityAttributes))
DllStructSetData($tSecurityAttributes, 2, DllStructGetPtr($tSecurityDescriptor))
DllStructSetData($tSecurityAttributes, 3, 0)
EndIf
EndIf
EndIf
Local $aHandle = DllCall("kernel32.dll", "handle", "CreateMutexW", "struct*", $tSecurityAttributes, "bool", 1, "wstr", $sOccurrenceName)
If @error Then Return SetError(@error, @extended, 0)
Local $aLastError = DllCall("kernel32.dll", "dword", "GetLastError")
If @error Then Return SetError(@error, @extended, 0)
If $aLastError[0] = $ERROR_ALREADY_EXISTS Then
If BitAND($iFlag, 1) Then
DllCall("kernel32.dll", "bool", "CloseHandle", "handle", $aHandle[0])
If @error Then Return SetError(@error, @extended, 0)
Return SetError($aLastError[0], $aLastError[0], 0)
Else
Exit -1
EndIf
EndIf
Return $aHandle[0]
EndFunc
Global Const $__COLORCONSTANTS_HSLMAX = 240
Global Const $__COLORCONSTANTS_RGBMAX = 255
Func _ColorConvertHSLtoRGB($aArray)
If UBound($aArray) <> 3 Or UBound($aArray, $UBOUND_DIMENSIONS) <> 1 Then Return SetError(1, 0, 0)
Local $nR, $nG, $nB
Local $nH = Number($aArray[0]) / $__COLORCONSTANTS_HSLMAX
Local $nS = Number($aArray[1]) / $__COLORCONSTANTS_HSLMAX
Local $nL = Number($aArray[2]) / $__COLORCONSTANTS_HSLMAX
If $nS = 0 Then
$nR = $nL
$nG = $nL
$nB = $nL
Else
Local $nValA, $nValB
If $nL <= 0.5 Then
$nValB = $nL *($nS + 1)
Else
$nValB =($nL + $nS) -($nL * $nS)
EndIf
$nValA = 2 * $nL - $nValB
$nR = __ColorConvertHueToRGB($nValA, $nValB, $nH + 1 / 3)
$nG = __ColorConvertHueToRGB($nValA, $nValB, $nH)
$nB = __ColorConvertHueToRGB($nValA, $nValB, $nH - 1 / 3)
EndIf
$aArray[0] = $nR * $__COLORCONSTANTS_RGBMAX
$aArray[1] = $nG * $__COLORCONSTANTS_RGBMAX
$aArray[2] = $nB * $__COLORCONSTANTS_RGBMAX
Return $aArray
EndFunc
Func __ColorConvertHueToRGB($nA, $nB, $nH)
If $nH < 0 Then $nH += 1
If $nH > 1 Then $nH -= 1
If(6 * $nH) < 1 Then Return $nA +($nB - $nA) * 6 * $nH
If(2 * $nH) < 1 Then Return $nB
If(3 * $nH) < 2 Then Return $nA +($nB - $nA) * 6 *(2 / 3 - $nH)
Return $nA
EndFunc
Func _ColorConvertRGBtoHSL($aArray)
If UBound($aArray) <> 3 Or UBound($aArray, $UBOUND_DIMENSIONS) <> 1 Then Return SetError(1, 0, 0)
Local $nH, $nS, $nL
Local $nR = Number($aArray[0]) / $__COLORCONSTANTS_RGBMAX
Local $nG = Number($aArray[1]) / $__COLORCONSTANTS_RGBMAX
Local $nB = Number($aArray[2]) / $__COLORCONSTANTS_RGBMAX
Local $nMax = $nR
If $nMax < $nG Then $nMax = $nG
If $nMax < $nB Then $nMax = $nB
Local $nMin = $nR
If $nMin > $nG Then $nMin = $nG
If $nMin > $nB Then $nMin = $nB
Local $nMinMaxSum =($nMax + $nMin)
Local $nMinMaxDiff =($nMax - $nMin)
$nL = $nMinMaxSum / 2
If $nMinMaxDiff = 0 Then
$nH = 0
$nS = 0
Else
If $nL < 0.5 Then
$nS = $nMinMaxDiff / $nMinMaxSum
Else
$nS = $nMinMaxDiff /(2 - $nMinMaxSum)
EndIf
Switch $nMax
Case $nR
$nH =($nG - $nB) /(6 * $nMinMaxDiff)
Case $nG
$nH =($nB - $nR) /(6 * $nMinMaxDiff) + 1 / 3
Case $nB
$nH =($nR - $nG) /(6 * $nMinMaxDiff) + 2 / 3
EndSwitch
If $nH < 0 Then $nH += 1
If $nH > 1 Then $nH -= 1
EndIf
$aArray[0] = $nH * $__COLORCONSTANTS_HSLMAX
$aArray[1] = $nS * $__COLORCONSTANTS_HSLMAX
$aArray[2] = $nL * $__COLORCONSTANTS_HSLMAX
Return $aArray
EndFunc
Func _ColorGetRGB($iColor, Const $_iCurrentExtended = @extended)
If BitAND($iColor, 0xFF000000) Then Return SetError(1, 0, 0)
Local $aColor[3]
$aColor[0] = BitAND(BitShift($iColor, 16), 0xFF)
$aColor[1] = BitAND(BitShift($iColor, 8), 0xFF)
$aColor[2] = BitAND($iColor, 0xFF)
Return SetExtended($_iCurrentExtended, $aColor)
EndFunc
Func _ColorSetRGB($aColor, Const $_iCurrentExtended = @extended)
If UBound($aColor) <> 3 Then Return SetError(1, 0, -1)
Local $iColor = 0, $iColorI
For $i = 0 To 2
$iColor = BitShift($iColor, -8)
$iColorI = $aColor[$i]
If $iColorI < 0 Or $iColorI > 255 Then Return SetError(2, 0, -1)
$iColor += $iColorI
Next
Return SetExtended($_iCurrentExtended, $iColor)
EndFunc
Global Const $__EDITCONSTANT_SB_LINEUP = 0
Global Const $__EDITCONSTANT_SB_LINEDOWN = 1
Global Const $__EDITCONSTANT_SB_PAGEDOWN = 3
Global Const $__EDITCONSTANT_SB_PAGEUP = 2
Global Const $__EDITCONSTANT_SB_SCROLLCARET = 4
Func _GUICtrlEdit_Scroll($hWnd, $iDirection)
If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)
If BitAND($iDirection, $__EDITCONSTANT_SB_LINEDOWN) <> $__EDITCONSTANT_SB_LINEDOWN And BitAND($iDirection, $__EDITCONSTANT_SB_LINEUP) <> $__EDITCONSTANT_SB_LINEUP And BitAND($iDirection, $__EDITCONSTANT_SB_PAGEDOWN) <> $__EDITCONSTANT_SB_PAGEDOWN And BitAND($iDirection, $__EDITCONSTANT_SB_PAGEUP) <> $__EDITCONSTANT_SB_PAGEUP And BitAND($iDirection, $__EDITCONSTANT_SB_SCROLLCARET) <> $__EDITCONSTANT_SB_SCROLLCARET Then Return 0
If $iDirection == $__EDITCONSTANT_SB_SCROLLCARET Then
Return _SendMessage($hWnd, $EM_SCROLLCARET)
Else
Return _SendMessage($hWnd, $EM_SCROLL, $iDirection)
EndIf
EndFunc
Func _GUICtrlEdit_SetSel($hWnd, $iStart, $iEnd)
If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)
_SendMessage($hWnd, $EM_SETSEL, $iStart, $iEnd)
EndFunc
Func _GUICtrlComboBox_ResetContent($hWnd)
If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)
_SendMessage($hWnd, $CB_RESETCONTENT)
EndFunc
Global $screenshot=0
Global Const $WIN_STATE_EXISTS = 1
Global Const $WIN_STATE_VISIBLE = 2
Global Const $WIN_STATE_ACTIVE = 8
Global Const $WIN_STATE_MINIMIZED = 16
Global $winName = "Simple IP Config"
Global $winVersion = "2.8.1 b1"
Global $winDate = "06/24/2017"
Global $hgui
Global $guiWidth = 550
Global $guiHeight = 550
Global $footerHeight = 16
Global $tbarHeight = 49
Global $dscale = 1
Global $AboutChild, $changeLogChild, $statusChild, $blacklistChild
Global $statusbarHeight = 20
Global $statustext, $statuserror, $sStatusMessage
Global $menuHeight, $captionHeight
Global $MinToTray, $RestoreItem
Global $toolsmenu, $disableitem, $refreshitem, $renameitem, $deleteitem, $clearitem, $saveitem, $newitem, $pullitem, $send2trayitem, $helpitem
Global $tray_tip
Global $settingsChild, $ck_mintoTray, $ck_startinTray, $ck_saveAdapter
Global $aAccelKeys[12][2], $movetosubnet
Global $wgraphic, $showWarning
Global $iPID = -1, $pRuntime
Global $pRunning, $pDone, $sStdOut, $sStdErr, $pIdle=1
Global $pQueue[1][2]=[[0,0]]
Global $mdblTimerInit=0, $mdblTimerDiff=1000, $mdblcheck=0, $mdblClick = 0
Global $dragging = False, $dragitem = 0, $contextSelect = 0
Global $prevWinPos, $winPosTimer, $writePos
Global $MyGlobalFontName = "Arial"
Global $MyGlobalFontSize = 9.5
Global $MyGlobalFontBKColor = $GUI_BKCOLOR_TRANSPARENT
Global $MyGlobalFontHeight = 0
Global $combo_adapters, $combo_dummy, $selected_adapter, $lDescription, $lMac
Global $list_profiles, $input_filter, $filter_dummy, $dummyUp, $dummyDown
Global $lv_oldName, $lv_newName, $lv_editIndex, $lv_doneEditing, $lv_newItem, $lv_startEditing, $lv_editing, $lv_aboutEditing
Global $radio_IpAuto, $radio_IpMan, $ip_Ip, $ip_Subnet, $ip_Gateway, $dummyTab
Global $label_ip, $label_subnet, $label_gateway
Global $radio_DnsAuto, $radio_DnsMan, $ip_DnsPri, $ip_DnsAlt, $ck_dnsReg
Global $label_DnsPri, $label_DnsAlt
Global $label_CurrentIp, $label_CurrentSubnet, $label_CurrentGateway
Global $label_CurrentDnsPri, $label_CurrentDnsAlt
Global $label_CurrentDhcp, $label_CurrentAdapterState, $domain
Global $link
Global $blacklistEdit, $bt_BlacklistAdd
Global $hTool, $hTool2
Global $hToolbar, $hToolbar2
Global $ToolbarIDs, $Toolbar2IDs
Global Enum $tb_apply = 1000, $tb_refresh, $tb_add, $tb_save, $tb_delete, $tb_clear
Global Enum $tb_settings = 2000, $tb_tray
Global $objWMI
Global Const $wbemFlagReturnImmediately = 0x10
Global Const $wbemFlagForwardOnly = 0x20
Global $adapters[1][4] = [[0,0,0]]
Global $profilelist[1][2]
Global $options[10][2]
$options[0][0] = "Version"
$options[1][0] = "MinToTray"
$options[2][0] = "StartupMode"
$options[3][0] = "Language"
$options[4][0] = "StartupAdapter"
$options[5][0] = "Theme"
$options[6][0] = "SaveAdapterToProfile"
$options[7][0] = "AdapterBlacklist"
$options[8][0] = "PositionX"
$options[8][1] = ""
$options[9][0] = "PositionY"
$options[9][1] = ""
Global $propertyFormat[9]
$propertyFormat[0] = "IpAuto"
$propertyFormat[1] = "IpAddress"
$propertyFormat[2] = "IpSubnet"
$propertyFormat[3] = "IpGateway"
$propertyFormat[4] = "DnsAuto"
$propertyFormat[5] = "IpDnsPref"
$propertyFormat[6] = "IpDnsAlt"
$propertyFormat[7] = "RegisterDns"
$propertyFormat[8] = "AdapterName"
Global $sChangeLog[2]
$sChangeLog[0] = "Changelog - " & $winVersion
$sChangeLog[1] = @CRLF & "v"&$winVersion & @CRLF & "BUG FIXES:" & @CRLF & "   IP address entry text scaling" & @CRLF & "v2.8" & @CRLF & "MAJOR CHANGES:" & @CRLF & "   Now using IP Helper API (Iphlpapi.dll) instead of WMI" & @CRLF & "   Speed improvements -> 2x faster!" & @CRLF & @CRLF & "MINOR CHANGES:" & @CRLF & "   Automatically fill in 255.255.255.0 for subnet" & @CRLF & "   Save last window position on exit" & @CRLF & "   Tray message when an trying to start a new instance" & @CRLF & "   Smaller exe file size" & @CRLF & "   Popup window positioning follows main window" & @CRLF & "   Allow more space for current properties" & @CRLF & "   Smoother startup process" & @CRLF & "   Get current information from disconnected adapters" & @CRLF & @CRLF & "BUG FIXES:" & @CRLF & "   IP address entry text scaling" & @CRLF & "   Fixed 'start in system tray' setting" & @CRLF & "   Fixed starting without toolbar icons" & @CRLF & "   Display disabled adapters" & @CRLF & "   Get current properties from disabled adapters" & @CRLF & "   Disabled adapters behavior" & @CRLF & "   Fixed hanging on setting profiles" & @CRLF & "   Fixed renaming/creating profiles issues" & @CRLF & "   Fixed additional DPI scaling issues" & @CRLF & @CRLF & "v2.7" & @CRLF & "MAJOR CHANGES:" & @CRLF & "   Code switched back to AutoIt" & @CRLF & "   Proper DPI scaling" & @CRLF & @CRLF & "NEW FEATURES:" & @CRLF & "   Enable DNS address registration" & @CRLF & "   Hide unused adapters" & "(View->Hide adapters)" & @CRLF & "   Display computer name and domain address" & @CRLF & @CRLF & "OTHER CHANGES:" & @CRLF & "   Single click to restore from system tray" & @CRLF & "   Improved status bar" & @CRLF & "   Allow only 1 instance to run" & @CRLF & @CRLF & "BUG FIXES:" & @CRLF & "   Proper scaling with larger/smaller screen fonts" & @CRLF & "   Fixed tooltip in system tray" & @CRLF & @CRLF & "v2.6" & @CRLF & "NEW FEATURES:" & @CRLF & "   Filter Profiles!" & @CRLF & "   'Start in System Tray' setting" & @CRLF & "   Release / renew DHCP tool" & @CRLF & "   'Saveas' button is now 'New' button" & @CRLF & @CRLF & "OTHER CHANGES:" & @CRLF & "   Enhanced 'Rename' interface" & @CRLF & "   New layout to show more profiles" & @CRLF & "   Other GUI enhancements" & @CRLF & @CRLF & "BUG FIXES:" & @CRLF & "   Detect no IP address / subnet input" & @CRLF & "   Fix DNS error occurring on some systems" & @CRLF & "   Better detection of duplicate profile names" & @CRLF
Global $pngAccept = '0x89504E470D0A1A0A0000000D4948445200000018000000180803000000D7A9CDCA000000AE504C544500000043961018850F398E10157C0E16800E1A8B1192C750CDE5AF9BCC60A8D27396C95793C851D3E7B8C8E2A7C6E1A4C3E09EB9DB8FAED67D9FCE66529F11D0E6B5B3D885A5D16E62B12245830E45870D4A960B448C07C4E1A1BFDD99B5D989AAD378A2D06BA2CF6A9ECE6399CB5B91C74F65B4255FAD1F5CA91B58A417478A0F4D980E498F0CD6E9BEBCDC95B0D78094C8535BA31D5AA81A519C114C900E4D9B0C4793073A79053D82044391025A5D84990000000774524E5300132519382D1E044BF1A8000000B64944415428CFC58D571682301444634DE8100248176982D8FBFE37667228EA816FBD7F73279307FE0321C37E9D1CDC21BFE02014BD269C8ACE6731645CEBB12A93F67DC4744AE62C143E42CAB1F6BC005308CF63169E1A322443660773CC0922841BEA19375FDA4A4871416E46B410A96FA864C9404A9085FC8A16DE0C74780A92D55D88799D132E53F081A3AA81662E2D3DA946E08B87A69998FE54B6FEBDD9633A2827A087CD5BBAC37CBF89ED1118E44EFD6F79019F910D1E3FF30E0C0000000049454E44AE426082'
Global $pngAdd = '0x89504E470D0A1A0A0000000D4948445200000018000000180803000000D7A9CDCA00000084504C54450000006AA053679E50639B4D5E984A5A95465591426EA25671A458C0DF99B8DC8CBCDD93C4E1A0CAE6A79DBD85DCECC9A4D369BFDE98A0C975D9EAC3D6E9BED3E8B9D0E6B3CCE5ADBADB92ABD088B4DA85B0D87EACD678A8D5729DC8729FD1629DD05E6EA256508E3EAED18DB1D584A8CD83A4CB7EA1CB79B2D394A8D17DB7D59EB5D49B7E99191D0000000874524E5300FEFEFEFEFEFEFDCBEAF8AC000000B74944415428CF6DD2D90E8230104051BAD216518B1BB8A0ECA0FFFF7F4E2B84C4E9799AE4BE4C9B89166A16FD8B53AF4281243BF0262850EBC287A2C0F4018C0C05AE8F60E428087B028D4041E66750C875FF8A50C685ACCD054CB5149C5112AB48A589D5DAE6A64DC1A47FF3D6854D800F3AC08724C00713E043566643DF15CD152CB30BF1BCAEBD81625EB752EB03F51D74127F897E805EA0C0ED1E0C1C0596BB903114A8798292A240DA1728090AF1D643C780CEE70B1BB1129F28293BAB0000000049454E44AE426082'
Global $pngBigicon = '0x89504E470D0A1A0A0000000D49484452000000400000004008030000009DB781EC0000014D504C5445000000000000020100000000000000000000000000000000000000000000000000000000000000000000020202000000000000000000000000040300000000000000000000CBA21FF5E86ED4FEFE010100FFFFD60C0B030B0C0C1B190B1311061214131E1804EFE26ABAB05324200C919179C69E1E373418CFF7F7CABF5AAFA54EA6841833332B4D4821181A172D2B13DBCF61A59D4A575749272A26C29B1DAE8B1A8D7014868671C2B7566D6730BD971C7D6412BCE2E293B0B07D9595A7A78C9C9C836073736D6D5C6666566161529E96468C843E3F3F35756F341E201D403D1C947616765E116E5710624E0E50400BB4D7D7E4E4C0DDDDBAD3D3B1B6B699556565D4C95F958D42837C3A293131635D2CB5901B9E7E173D3008C5ECECF5F5CE8BA6A6849F9F7086867C7C684957573E4A4A4D4D4056522659470D48390B342907ABCCCCEDEDC79EBDBDE8DB68B3D3263F0000001774524E5300F1FAA75C2FE23F0A1FB04E9C1385D8C763D177BF936D9F6065B1000003F44944415458C3B596F76FDA4014C76D0306CA2603F37C5EEC0D8184991DC24820BB69769B66A7E3FFFFB11E2C35E5C048FD484887F0F7C3BDF7742713181CE645FB3C4D020045CF2F181D842E4C4E3785DE5F3BC59BE4CA4AB2D839942883'
$pngBigicon &= '69EAB463D10BB79D64C4374AF290724E19779252ADEAFBC88D609F266FA3A57DDFBF5941C6C97927EAF8C652A327C58D0694F48D67194CF8EADDC22D7A8B600C12BE06F7EDB2EF5A3AC408DE3DB8FCA250553A7588D98264C309E89A0F4F5200276E7E28324110D92FE20669D78AC753738D17B88A5308AA601D97B7502BBE51AE6F92CBFF3008E671022B8C3E5F948003F45AD53107138CF4F000B68E62776B0549DBD5F27E6DBFA747981D1C0C0E5187FBE557883D4A55B9F907886B73A8ABFCC10A35FE6221E1A65F3EBAF76BC40AAFBEC86DE65BCC1FBB17DFE49FBA6ECC18A5410197FE3E6B503DC8ACAACB23B19B2C221BE6244A115FA4D8AD2597A5F58120267661ADB7FE061439478CC742BF5DBF83CA0FFF8027743990B5E5380EEB3CC8A45200AB43C167D81AAE0DC404CC4E2ECCB29B7034143CC2B09EEFA447FE1BFC6D2EB232EDB5A1E0725400B4D10B9839380813F79565BF8A9F079955688F940090096F8E3F0D468AF6780BA9D20EC70D9AB0952A15064DCCE4B74FF27219E330D437336466B300DBCDA79896F90567C75CBFA07BF127DB9CC7F4C04CD68F77E0E458848DCCD3AA3A79EE81654BA2D6D31F4A830B36EC1CDDCF6CFD549E42E134C53D7EDFBA9423327971FDCE7FB7CEE5E5F664B002C29852021BD9689E3DDB693E978E5995B00822F0696E27DCF41258CCA2FA7C34C797D851EAE94439C0'
$pngBigicon &= '04AFF6600E2F7050A7F2E3A90B268836FAE19F0FEC298A332A5F680781E7539D3DC9877E33CCD2C0504AB1CD172D7F2ED88809586911D23986510C61B59C1DEE6C1B826A3E10B51313710A714623C83F9FC8826D39CF332A2D9765B2C0462598BE01201FDE786867A31546A14C4DF58E63447D43806FB442A1F46E800FAA5FB353BEE178D06ECF50493395508E89A3803A81D102F055902D35C1E450220DA15C634FDB8F71FA573C57F45C3534041E20B4D752D6099A981E8BBD378B0A282C29CBAB05420F0BF2B6D518C8A8DB891A7509AC544E9B440840EB216F2674E1ED8DA20190656611D82B9A2007F0329360718FD1C84265268199EF095EA03193C00ABF35C18536454630E91358C8DEA95C82204680C1B5D43F939A09E9157CBA0A96E3F17879177613894430A85B304783202041E0F9908C00A45E0161A1CE990117F3847EC8A0160EC89FF4DC0C8285A876956703B8A3847DE551065156AFB8A8477FDE6C2051B455FE92BD486743C86DB4E81D23FC05A9EF46F1C007485D7BF0C207285D023B7CC0A56F0473864F1A861E7613F13FF8031026DF7AFD490E9B0000000049454E44AE426082'
Global $pngDelete = '0x89504E470D0A1A0A0000000D4948445200000018000000180803000000D7A9CDCA0000003C504C5445000000F3635BF96C62DF4036F16057E2453AE14238F76960E85047FE7C73EA544DFB7067FE8D83FE8176FE746BFD7269FE877EFE857BFE766DE34A42CCE6314E0000000174524E530040E6D8660000008B4944415428CF9D914916C4200805E30F48D04433DCFFAEFD340E9B661376543D9161F916CCFF1306FC483CC09D939EF0839F4AAFF141F2B1C337BE1F59424DD68D908A693C81B675798D43D64B7861B934C315DE8DC45B1327BDA374DEAA39418C11E26A9D699E40AE0485A7F26986687C9A260A375FD87FD85DD97398939BBB32B76BDDC3BEA07D733B7EDD2106FC84FFBB280000000049454E44AE426082'
Global $pngEdit = '0x89504E470D0A1A0A0000000D4948445200000018000000180803000000D7A9CDCA000001F8504C5445000000E99916A25061FEE4AF9F5672FFD280FFD484FFD3839A506DA7546CD1D2D29E8886FFCF7BE59E2AE89915090F0FDC5E66B8B8B9857C5AD2606DEB9618C5A666F0AF40FFAC4AE19839F7C061ECB873C25D6FF2D081464646A95972A79B9EC6A074FCC07CD6D7D8FFDB94D05356EFD292001116FFDF9CFFDF97A05671B2576CCDC1ADFFD0802B2C2CFFCF7E4E4632995069FFCC77EA9713E99917E79915E49409FDD88DDBBD74EFB44AFFD6899D5671323335FFDF87DAB873FFC974FFCB77FFCF7E837C73FEBC60FFD986FEBC608D826DFFA542FB9D30F59B27FCDB8EFE9F38EE9A1EFFF1C7FFEFB4FFAD4EFFEEBBFEDB8CF7D179F7C164FBB758FFA947FFFADDFFF8D7FFF6CFFFF0C0B0ADADB0A8A7FFE298FFD998949192FEDC90B26784F5CF77F6CB70F6C96E6F6D6DF6C56AF6C467616060F9BC5EF9BA5BFDB15147474BFFA13C393939FD9F35F89D2DF39B24F0991EF6ECEEF4EAE4CDCACAFFF3C9FFF5C6C3C3C3FFF5C0FFF2BCBEBABACAB1BAFAECB9B4B1B1D899AEFFEBA4CFC4A2FFE3A1FDDDA1DB889ABF7B97E4D195C3B995878B94939393CC7792B96E8D8C8C8C878889A29B88F8D684F8D683D46E83828181BE6780D96F7DF7D37C9D6C7CFDC8797A7A78A15874F6C86BF9BE61797460FCB85E8C5A'
$pngEdit &= '5DFCB859FCB455FCB254FFA33E3C3D3DFEA33BF3A330FC9C2C2B2B2BF69824F09716344AD2D20000004674524E53007D0CFEF9CAC1B6382B22150A070606FEFDFBFAF9F8F8F7F1EEEDE9E7E2E1E0DFDDDBD3D2D1CCCBB9B6AFACA7A39C97968787736A605F58574F4D3C3B3B332C241F1B19130B9A5C1CD5000001274944415428CF6360E0E767C00EAC73D4F4CD6D9C7930241CBBB366B5D445475BA24B70B74D6BF50502653B3409D79EFAEA0AFF888806567B3419D5F2529F92707FCF00560754090DFFF0B0309F98A4044F36271409759FD0509F98D919A9819E6C2EC81266CCCC8D53DDDC3233521302D8515C6D21B678997B7648667A4AA0273B8A61A622F979B9D921F341323A283226DE40990521F366CE981CA7872263ECEDE1EEE5E6171C94D417678822C3089349EC0DB0C5212323A48B2A530096992B299AB554960949820F22232E159596B350850145C6DB63C922C5A2C8E4E439022886F11A2D9750A8898CAD8C9A24CC802AA32DD89536A1B8B0A95F1A2D06B894CADA63AB6A3B266A31A0CBC84F896FEE8C97E364C088680396E92C9A08710460E2B0E200F9020074C9507E216EB0ED0000000049454E44AE426082'
Global $pngRefresh = '0x89504E470D0A1A0A0000000D4948445200000018000000180803000000D7A9CDCA000001BF504C544500000032820E34830E5BA128539B233C860E39850F35830C408E18448B13448F1740850C4089103C840C489118347B0A4D98203C860E49951D34830D38820A37840C36830C36830C34800A3E8C15337E0B2F800B35820C2C810C2D7B092F810D287D0A32841067A92E62A62C4D96203F8E173F830C4D9720287D0A347A093D871049931A287D0A3B8B154F9820347B0B358510559F263D870F509A2131780A36810B63A92D44911B45911B327C0A287D0A3B881330790A3C86102E810D3E8A1343911A287D0A3F8D17307C09307B0A418F1933810D36850F337D0A7EB73C34820E2D790A3B8A158CC54388BF4374AD2E80B9397DB53583BB3C7AB33385BD3E7EB63778B1315D9D2187BF4079B83975B43976AF2F70AA2A6FA72796CD528EC6488BC6478EC74688C2458CC44489C2417FB7376CAE3372AC2A6CA526679F21669F1D5A96175691175391124B8B0E44870D9FD95595CE4C8FCC4A90CA4A89C34585C24388C14074B4366FB33668AB3265A92E68A427589F2761A2265EA12669A22565A2246BA5236AA3215A9A1F5F991C56971B519419478D11377C0999D45194CD4B85BF4578B33760A52C5C971C4991184A8E1451921349850D287D0A3278091B4E5F970000004F74524E5300210CFEFDF1BC7966FDFC'
$pngRefresh &= 'FCFAF8EFEFE9E7E2D6D1C8B3A09391706B67604D3F271806FEFEFDF2F1EAEAE7E6E4E3E2E0D9D1D0CDC5C2BDBAB5B5B1B0A8A6A6A5979188817F724D4B4932322E1C130C099A40E3000001764944415428CF6DD0638F03511886E1B75EDBB66DDB1A776A9B6BD5EE9A3F789B4C67BB69F7FE7472AEE424CF01B6B685AFF50EC88E0BADC3A69B490EE4D4DC7D7B7A3E9E0BCD05D287D3F399E3ECB77607A5678F679ADB7B1EBF62FB2F9448F5D706835EABBDB8B83295E565C08762461445719C24AFB5572F6BBF104710442E1713048661142EE9DC6061DA65555A94C14884F6281084781E6965EEF7EA6ADD76ABD52E10560BF263010BE2AF67A0B298DB9074461D55A91D0735F9AF017A9581226735B4F47FBAAA5A4A4BB760A7DCE158662061FBA881C3A9EFA526B7BD701E1A7BDCB50CBC9943B1011117A02961B3B946A12E294AEFBB319B83F1A272E1C47B281C760A449B1C06EAEF51B158AEF0D034AD502895D1C206F6D32BA4122385610491F2D4564B31A4E394C9340612C751D44851184115005BFB9C5776A9B9D4E92524894B7C42C87434DBCBE7DDC9D46AB5CEBF08599DEC9B542A1D6F0C72CABB533DF12BE11FF0CABA56A03D17DA86FA1AD9F30F23745D40ED8B55A20000000049454E44AE426082'
Global $pngSave = '0x89504E470D0A1A0A0000000D4948445200000018000000180803000000D7A9CDCA000000ED504C54450000003030303131312D2D2D3A3A3A1F1F1F2E2E2E3D3D3DFFFFFFB5BDCE484848F4F4F4F7A525F38B122F2F2FFBFBFBF0F0F0888888353535404040212121E7E7E78080804F4F4F8585855454543D3D3D8D8D8D5B5B5B4C4C4C454545434343373737ECECECEAEAEA787878585858333333F6F6F6E3E3E3BABABAA5A5A5626262606060C7C7C7B1B1B1A2A2A29D9D9D8282827D7D7D6666665E5E5E3A3A3A262626C3C3C3B5B5B5AEAEAEA8A8A89A9A9A9191918A8A8A7A7A7A7070706B6B6B6969695151512C2C2CF8F8F8F1F1F1DCDCDCD5D5D5CFCFCFBEBEBEA1A1A1999999757575C2C2C293939373737339F33E980000000874524E5300A68769EAC89D87954601D9000001514944415428CF95D0C7768240148061A32966488071547A07A58380BD1BBB49DEFF713228F1E8228BFCCBFB71873353FA3B96152546667BBEDD0F064E1846CD547CC86102E515591F57ABB4A6EF46A1EF7F990C934B1C03D2EA0A04D56837FACBC4FE14380948183A1D40D6BA42EB0CC0B57B1306C800C374AA905601763ADBF7A0A42019C3E9842EFF586BFA360876BE0010AF60987D7300F086BD0F0643E7101D8539E2558461315BB8A9287A9E68721CC7002553558BC7E0CE1789EBE1099015C467998AE7AB0C439A780914'
$pngSave &= '20CBC671F39CC1585D1583E89950A788DF5A55BD49D66B184C919BD0D59B68B6007309E9D79BB462835B32F0BA4151F8A29D0B30927405EA835813ED022400EE8FDA4C2F001405D2C5E7047E7A6D6314C023963E9F9E8FF14B6E0B902B2FECDB5D46B992032A3FC2F7BB8CE7272BDFE0D1DC190C878E131EA268741C8D5DBE864AFFEF07003032D766ABE1530000000049454E44AE426082'
Global $pngSearch = '0x89504E470D0A1A0A0000000D4948445200000010000000100803000000282D0F5300000111504C54450000009B420F955536747289BA5A122E202D83351175606E8E7C859C521C6382A05E7D9CE0A640D7A24070717E8B899F4A4C5B718491495B6C888598616276C76412BB9E81CD6613726772A34D12675762473B45835B4E3E30394D3B47352731838395717183573F4B7C7A8854525E987E8538252D77412FAA7857503B4265506253373BD6EBFFA3CBFE93BDF3EC962BD8F1FF85B0E673A0D96D9AD4FCE379EAFEFFE3F9FFD6F9FFDAF5FFD2EDFFDDEBFFCFE6FFBEDDFFB4D6FF97C1F88DB8F089B4EE6694CF5F8CC0D89235F8FFFFDFFFFFD2FCFFCFF8FFE2EFFFBDECFFCFE9FFC4DFFFA9CFFF7DAAE3D3DDD57BA6D596C2D46F9ACA729CB29091A79EA49D8A96939D888CD2AD60584C5251444CC78A36C0AF254B0000002C74524E53004518FBE5664934300FFBFBFBFBF9F6F4F0EDEAE9E5DED9D8D8D4D3D2D0CAC7A4A48F89878484756E2A2818C2E6BA72000000AA4944415418D355CDE50E82601886E1CF16BBBB3B681014A4EDEE3AFF0351076C70FF7BAFBDDB0300F0D7A2D764D309CCDA0195A2F6C7B8CFB8FD4105455052462306D45589E75001114E0D1D5C8AC8AD7630BF59160CA0640281611C67733AA44812D9C238C3CC2B3AB4CE84349D8C47B39B4787618210FF707899BBFDD865CD2EEEEF4726'
$pngSearch &= '0B19D42917AB1ED0D3B0B41358726834E6866C12FA89FDE743637960CD1B7E96805DBA832FB1D517CA6A3934EE0000000049454E44AE426082'
Global $pngSettings = '0x89504E470D0A1A0A0000000D4948445200000010000000100803000000282D0F5300000060504C54450000007276768B8C8F82828686888AFEFEFEEAEBECE6E6EA8E9296D8DADEC0C3C6EEEEF2B9BCBEAAAEB2999A9E7B7C7F7171756A6C6F575A5AD6D6D9D2D4D6C6C7CBA7AAAE9E9EA2F5F6F7CED0D4AFB1B594969A6565694A4A4E4242423A3E3E2DBD79A90000000174524E530040E6D866000000A24944415418D3654F451203310C73E230274B5DFEFF2F1B98E9A53AD91A0B0C03A4027E5095B096B4A183F20D05E70237AEC62E3F32DC77101FC969634E21AEF23CE5B2E2EC92A851B17AA950C7EE6F1C63402930E6969A454CF02B50AD29781F4C251C7A0F6C59181C076B04C96647A82ADC4DEEF5C83A3B044037AF64142B494A6BA54CA5D7C099BCA135DDDE3861BFD02AA69C5354356968AACF34913EC0DFFB5F8D8706B88D1C1D3A0000000049454E44AE426082'
Global $pngTray = '0x89504E470D0A1A0A0000000D4948445200000010000000100803000000282D0F530000003C504C5445000000977E2FFFE696FFE48EFFD95CFFD854FFE17EFFDB65FFE89EFFDD6DFFE286FFEAA6FFDE76FFEEB9FFDF75FFECAFFFEAA7FFE89FFFE386FFEBAFDD4C73490000000174524E530040E6D8660000005B4944415418D35D8D890E80200C43ADF70108FAFFFF6AD9387D0B4D69D26D1030F4C0E2F7B75D82FBE5402CA25C8207ADA722845D01E8623CB648676AD055E7C32114E89DB58074D918E7E4E5E0C8A4CA56D0A5734583A5922A0D1F155A0412DB2A4C500000000049454E44AE426082'
Global $pngWarning = '0x89504E470D0A1A0A0000000D4948445200000010000000100803000000282D0F530000011D504C54450000001B08031C0A05D6A93FBF7D18D8A21AE2A525A17308E2A929F1B41F532E097D4307CC9235794900765107985726AC6D36EEB5307E5600D69A37D09237512C080803025135003C1E05482408EAAB27F4B934000000AE692C341F00BF8236E2A633000000B6855FF2BB442D1200F8DA30F8DD39F9DF3ED8A622D4A219FEEB71FDE662FADE5CF9E051F8DC4ACFBB44F8DC40CAB639F6D735504B2EF6D42DDDAB25DAA81B3D3718141518DDAC1105050BFFEE89B3AD83928E77FAE366827D66DACA65F8DD63CEBD62F8DA57FCE356F3CF56EDD648F8DF45F4D345FEE444FAD044E8BC448D8143F7D8405B5740F4DB3FE2CA3FFDE23ADCC537F8DD34F4CC34F5C434F9DC32DBAC31BA8525191A20E7BA17C99016A26B15C69A14CB970FE1CF6FE50000002574524E53009699F8F5F1ECE6DED3D1C7C0BDB4AB9E999886805F57554F45393129231F1B19110E0A0A9A6B6B00000000A14944415418D363C00594F855500504224451F8B2CC5A318AC8023C8ED6AEBC487C616F1B5B877071385F814DCBDEC249871D2E20E8AC6D6CA16FE72504E54B87EAB8985B19EA6AB3CA81F9CA9CBA7A9E7E56FAEE7A1E7C6001A9105F7575B7007F750383681990008791915AA071A4A19A9A9A0937902F126512AC1AE6631EA4'
$pngWarning &= '0A04B1920CF22C969666661AA6A61A1A9A9A9A715C0C0C124C8C08C02486E16D00D4ED16C6BC5BFE6E0000000049454E44AE426082'
Func _loadAdapters()
Local $aIPAllAddrTable = _Network_IPAllAddressTable(0, 0, 1)
Local $tadapters = _GetAdapters()
Local $ladapters[1][3] = [[0,0,0]]
for $i=0 to UBound($tadapters)-1
$index = _ArraySearch( $aIPAllAddrTable, $tadapters[$i], 0 )
$mac = ""
$desc = ""
If($index <> -1) Then
$mac = $aIPAllAddrTable[$index][4]
$desc = $aIPAllAddrTable[$index][6]
EndIf
$ladapters[0][0] = $ladapters[0][0]+1
_ArrayAdd($ladapters, $tadapters[$i] & "|" & $mac & "|" & $desc)
Next
$adapters = $ladapters
EndFunc
Func _releaseDhcp()
$adaptername = GUICtrlRead($combo_adapters)
$cmd = 'ipconfig /release "' & $adaptername & '"'
_asyncNewCmd($cmd, "Releasing DHCP...")
EndFunc
Func _renewDhcp()
$adaptername = GUICtrlRead($combo_adapters)
$cmd = 'ipconfig /renew "' & $adaptername & '"'
_asyncNewCmd($cmd, "Renewing DHCP...")
EndFunc
Func _cycleDhcp()
$adaptername = GUICtrlRead($combo_adapters)
$cmd = 'ipconfig /release "' & $adaptername & '"'
_asyncNewCmd($cmd, "Releasing DHCP...")
$cmd = 'ipconfig /renew "' & $adaptername & '"'
_asyncNewCmd($cmd, "Renewing DHCP...", 1)
EndFunc
Func _getIPs($adaptername)
Local $props[7]
Local $ip, $subnet, $gateway, $dnspri, $dnsalt, $dnsServer, $dhcpServer, $dhcpEnabled, $sDNS
Local $aIPAllAddrTable = _Network_IPAllAddressTable(1, 0, 1)
Local $nInterfaces = @extended
Local $aIPv4AdaptersInfoEx = _Network_IPv4AdaptersInfoEx()
Local $nAdapters = @extended
Local $adapstate = _AdapterMod($adaptername, 2)
Local $tadapters = _GetAdapters()
If $adapstate = "Disabled" Then
$props[6] = $adapstate
$DhcpEn = _doRegGetValue($adaptername, "EnableDHCP")
$DhcpDis = _doRegGetValue($adaptername, "DisableDhcpOnConnect")
if $DhcpEn = 0 Or $DhcpDis = 1 Then
$ip = _doRegGetValue($adaptername, "IPAddress")
$subnet = _doRegGetValue($adaptername, "SubnetMask")
$gateway = _doRegGetValue($adaptername, "DefaultGateway")
$sDNS = StringReplace(_doRegGetValue($adaptername, "NameServer"), ",", "|")
Else
$dhcpIP = _doRegGetValue($adaptername, "DhcpIPAddress")
If $dhcpIP <> "0.0.0.0" Then
$ip = $dhcpIP
$subnet = _doRegGetValue($adaptername, "DhcpSubnetMask")
$gateway = _doRegGetValue($adaptername, "DefaultGateway")
Else
$ip = ""
$subnet = ""
$gateway = ""
EndIf
$sDNS = StringReplace(_doRegGetValue($adaptername, "DhcpNameServer"), " ", "|")
EndIf
$aDNS = StringSplit($sDNS,"|")
If $sDNS = "0.0.0.0" Then
$dnspri = ""
$dnsalt = ""
ElseIf $aDNS[0] > 1 Then
$dnspri = $aDNS[1]
$dnsalt = $aDNS[2]
Else
$dnspri = $sDNS
$dnsalt = ""
EndIf
$props[0] = $ip
$props[1] = $subnet
$props[2] = $gateway
$props[3] = $dnspri
$props[4] = $dnsalt
$props[5] = $dhcpServer
Else
for $i=0 to $nInterfaces-1
If $aIPAllAddrTable[$i][7] = $adaptername Then
For $j = 0 To $nAdapters - 1
If $aIPv4AdaptersInfoEx[$j][4] = $aIPAllAddrTable[$i][4] Then
$ip =($aIPv4AdaptersInfoEx[$j][11]="0.0.0.0") ?("") :($aIPv4AdaptersInfoEx[$j][11])
$subnet =($aIPv4AdaptersInfoEx[$j][12]="0.0.0.0") ?("") :($aIPv4AdaptersInfoEx[$j][12])
$gateway =($aIPv4AdaptersInfoEx[$j][13]="0.0.0.0") ?("") :($aIPv4AdaptersInfoEx[$j][13])
$sDNS =($aIPAllAddrTable[$i][13]="0.0.0.0") ?("") :($aIPAllAddrTable[$i][13])
$dhcpServer =($aIPv4AdaptersInfoEx[$j][15]="0.0.0.0") ?("") :($aIPv4AdaptersInfoEx[$j][15])
ExitLoop
EndIf
Next
if $ip = "" Then
$props[6] = "Unplugged"
$DhcpEn = _doRegGetValue($adaptername, "EnableDHCP")
$DhcpDis = _doRegGetValue($adaptername, "DisableDhcpOnConnect")
if $DhcpEn = 0 Or $DhcpDis = 1 Then
$ip = _doRegGetValue($adaptername, "IPAddress")
$subnet = _doRegGetValue($adaptername, "SubnetMask")
$gateway = _doRegGetValue($adaptername, "DefaultGateway")
$sDNS = StringReplace(_doRegGetValue($adaptername, "NameServer"), ",", "|")
Else
$dhcpIP = _doRegGetValue($adaptername, "DhcpIPAddress")
If $dhcpIP <> "0.0.0.0" Then
$ip = $dhcpIP
$subnet = _doRegGetValue($adaptername, "DhcpSubnetMask")
$gateway = _doRegGetValue($adaptername, "DefaultGateway")
Else
$ip = ""
$subnet = ""
$gateway = ""
EndIf
$sDNS = StringReplace(_doRegGetValue($adaptername, "DhcpNameServer"), " ", "|")
EndIf
Else
$props[6] = $adapstate
EndIf
$aDNS = StringSplit($sDNS,"|")
If $sDNS = "0.0.0.0" Then
$dnspri = ""
$dnsalt = ""
ElseIf $aDNS[0] > 1 Then
$dnspri = $aDNS[1]
$dnsalt = $aDNS[2]
Else
$dnspri = $sDNS
$dnsalt = ""
EndIf
$props[0] = $ip
$props[1] = $subnet
$props[2] = $gateway
$props[3] = $dnspri
$props[4] = $dnsalt
$props[5] = $dhcpServer
ExitLoop
EndIf
Next
EndIf
Return $props
EndFunc
Func _doRegGetValue($adaptername, $ItemName)
Local $adapGUID = _doRegGetGUID($adaptername)
$keyname = "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\Tcpip\Parameters\Interfaces"
Local $sSubKey, $sSubKeyName, $sGuids, $i=0
while 1
$i += 1
$sSubKey=RegEnumKey($keyname,$i)
If @error <> 0 then ExitLoop
If $sSubKey <> $adapGUID Then ContinueLoop
$sSubKeyValue=RegRead($keyname &"\"& $sSubKey,$ItemName)
return $sSubKeyValue
Wend
EndFunc
Func _doRegGetGUID($adaptername)
$keyname = "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Network\{4D36E972-E325-11CE-BFC1-08002BE10318}"
Local $sSubKey, $sSubKeyName, $sGuids, $i=0
while 1
$i += 1
$sSubKey=RegEnumKey($keyname,$i)
If @error <> 0 then ExitLoop
$sSubKeyName=RegRead($keyname &"\"& $sSubKey & "\Connection","Name")
If $sSubKeyName = $adaptername Then
Return $sSubKey
EndIf
Wend
return ""
EndFunc
Func _AdapterMod($oLanConnection, $bEnable = 1)
Local $strEnableVerb, $strDisableVerb, $ShellApp, $oNetConnections, $oEnableVerb, $oDisableVerb
Local $begin, $dif, $Res, $temp
Select
Case StringInStr("0409,0809,0c09,1009,1409,1809,1c09,2009,2409,2809,2c09,3009,3409", @OSLang)
$strEnableVerb = "En&able"
$strDisableVerb = "Disa&ble"
Case StringInStr("040c,080c,0c0c,100c,140c,180c", @OSLang)
$strEnableVerb = "&Activer"
$strDisableVerb = "&Désactiver"
EndSelect
Const $ssfCONTROLS = 49
$ShellApp = ObjCreate("Shell.Application")
$oNetConnections = $ShellApp.Namespace($ssfCONTROLS)
If Not IsObj($oNetConnections) Then
Return 1
EndIf
For $FolderItem In $oNetConnections.Items
If StringLower($FolderItem.Name) = StringLower($oLanConnection) Then
$oLanConnection = $FolderItem
ExitLoop
EndIf
Next
If Not IsObj($oLanConnection) Then
Return 2
EndIf
$oEnableVerb = ""
$oDisableVerb = ""
For $Verb In $oLanConnection.Verbs
If $Verb.Name = $strEnableVerb Then
$oEnableVerb = $Verb
EndIf
If $Verb.Name = $strDisableVerb Then
$oDisableVerb = $Verb
EndIf
If $Verb.Name = "p$roperties" Then
$temp = $Verb
EndIf
Next
If IsObj($temp) Then
$temp = $temp.DoIt
$ShellApp.explore($temp)
EndIf
If $bEnable = 1 Then
If IsObj($oEnableVerb) Then $oEnableVerb.DoIt
EndIf
If $bEnable = 0 Then
If IsObj($oDisableVerb) Then $oDisableVerb.DoIt
EndIf
If $bEnable = 2 Then
$Res = _GetNicState($oLanConnection, $strEnableVerb, $strDisableVerb)
If $Res = 1 Then
Return "Enabled"
Else
Return "Disabled"
EndIf
EndIf
$begin = TimerInit()
While 1
$dif = Int(TimerDiff($begin) / 1000)
If $dif > 10 Then
MsgBox( 0, "", "Timeout Error:" & @CRLF & "The command was issued, but the adapter took too long to check the state.")
ExitLoop
EndIf
If $bEnable = 1 And _GetNicState($oLanConnection, $strEnableVerb, $strDisableVerb) = 1 Then ExitLoop
If $bEnable = 0 And _GetNicState($oLanConnection, $strEnableVerb, $strDisableVerb) = 0 Then ExitLoop
Sleep(100)
WEnd
$Res = _GetNicState($oLanConnection, $strEnableVerb, $strDisableVerb)
If $bEnable = 1 And $Res = 0 Then
Return 3
ElseIf $bEnable = 0 And $Res = 1 Then
Return 4
Else
Return 0
EndIf
EndFunc
Func _GetNicState($oLanConnection, $strEnableVerb="En&able", $strDisableVerb="Disa&ble")
Local $Verb
For $Verb In $oLanConnection.Verbs
If $Verb.Name = $strEnableVerb Then
Return 0
Else
Return 1
EndIf
Next
EndFunc
Func _GetAdapters()
Local $ShellApp, $oNetConnections, $FolderItem
Local $myadapters[1] = [0], $iPlaceHolder = 0
Const $ssfCONTROLS = 49
$ShellApp = ObjCreate("Shell.Application")
$oNetConnections = $ShellApp.Namespace($ssfCONTROLS)
If Not IsObj($oNetConnections) Then
Return 1
EndIf
For $FolderItem In $oNetConnections.Items
If $iPlaceHolder=0 Then
$myadapters[$iPlaceHolder] = $FolderItem.name
$iPlaceHolder += 1
Else
ReDim $myadapters[$iPlaceHolder+1]
$myadapters[$iPlaceHolder] = $FolderItem.name
$iPlaceHolder += 1
EndIf
Next
Return $myadapters
EndFunc
Func _StringSize($sText, $iSize = 8.5, $iWeight = 400, $iAttrib = 0, $sName = "", $iMaxWidth = 0, $hWnd = 0)
If $iSize = Default Then $iSize = 8.5
If $iWeight = Default Then $iWeight = 400
If $iAttrib = Default Then $iAttrib = 0
If $sName = "" Or $sName = Default Then $sName = _StringSize_DefaultFontName()
If Not IsString($sText) Then Return SetError(1, 1, 0)
If Not IsNumber($iSize) Then Return SetError(1, 2, 0)
If Not IsInt($iWeight) Then Return SetError(1, 3, 0)
If Not IsInt($iAttrib) Then Return SetError(1, 4, 0)
If Not IsString($sName) Then Return SetError(1, 5, 0)
If Not IsNumber($iMaxWidth) Then Return SetError(1, 6, 0)
If Not IsHwnd($hWnd) And $hWnd <> 0 Then Return SetError(1, 7, 0)
Local $aRet, $hDC, $hFont, $hLabel = 0, $hLabel_Handle
Local $iExpTab = BitAnd($iAttrib, 1)
$iAttrib = BitAnd($iAttrib, BitNot(1))
If IsHWnd($hWnd) Then
$hLabel = GUICtrlCreateLabel("", -10, -10, 10, 10)
$hLabel_Handle = GUICtrlGetHandle(-1)
GUICtrlSetFont(-1, $iSize, $iWeight, $iAttrib, $sName)
$aRet = DllCall("user32.dll", "handle", "GetDC", "hwnd", $hLabel_Handle)
If @error Or $aRet[0] = 0 Then
GUICtrlDelete($hLabel)
Return SetError(2, 1, 0)
EndIf
$hDC = $aRet[0]
$aRet = DllCall("user32.dll", "lparam", "SendMessage", "hwnd", $hLabel_Handle, "int", 0x0031, "wparam", 0, "lparam", 0)
If @error Or $aRet[0] = 0 Then
GUICtrlDelete($hLabel)
Return SetError(2, _StringSize_Error_Close(2, $hDC), 0)
EndIf
$hFont = $aRet[0]
Else
$aRet = DllCall("user32.dll", "handle", "GetDC", "hwnd", $hWnd)
If @error Or $aRet[0] = 0 Then Return SetError(2, 1, 0)
$hDC = $aRet[0]
$aRet = DllCall("gdi32.dll", "int", "GetDeviceCaps", "handle", $hDC, "int", 90)
If @error Or $aRet[0] = 0 Then Return SetError(2, _StringSize_Error_Close(3, $hDC), 0)
Local $iInfo = $aRet[0]
$aRet = DllCall("gdi32.dll", "handle", "CreateFontW", "int", -$iInfo * $iSize / 72, "int", 0, "int", 0, "int", 0, "int", $iWeight, "dword", BitAND($iAttrib, 2), "dword", BitAND($iAttrib, 4), "dword", BitAND($iAttrib, 8), "dword", 0, "dword", 0, "dword", 0, "dword", 5, "dword", 0, "wstr", $sName)
If @error Or $aRet[0] = 0 Then Return SetError(2, _StringSize_Error_Close(4, $hDC), 0)
$hFont = $aRet[0]
EndIf
$aRet = DllCall("gdi32.dll", "handle", "SelectObject", "handle", $hDC, "handle", $hFont)
If @error Or $aRet[0] = 0 Then Return SetError(2, _StringSize_Error_Close(5, $hDC, $hFont, $hLabel), 0)
Local $hPrevFont = $aRet[0]
Local $avSize_Info[4], $iLine_Length, $iLine_Height = 0, $iLine_Count = 0, $iLine_Width = 0, $iWrap_Count, $iLast_Word, $sTest_Line
Local $tSize = DllStructCreate("int X;int Y")
DllStructSetData($tSize, "X", 0)
DllStructSetData($tSize, "Y", 0)
$sText = StringRegExpReplace($sText, "((?<!\x0d)\x0a|\x0d(?!\x0a))", @CRLF)
Local $asLines = StringSplit($sText, @CRLF, 1)
For $i = 1 To $asLines[0]
If $iExpTab Then
$asLines[$i] = StringReplace($asLines[$i], @TAB, " XXXXXXXX")
EndIf
$iLine_Length = StringLen($asLines[$i])
DllCall("gdi32.dll", "bool", "GetTextExtentPoint32W", "handle", $hDC, "wstr", $asLines[$i], "int", $iLine_Length, "ptr", DllStructGetPtr($tSize))
If @error Then Return SetError(2, _StringSize_Error_Close(6, $hDC, $hFont, $hLabel), 0)
If DllStructGetData($tSize, "X") > $iLine_Width Then $iLine_Width = DllStructGetData($tSize, "X")
If DllStructGetData($tSize, "Y") > $iLine_Height Then $iLine_Height = DllStructGetData($tSize, "Y")
Next
If $iMaxWidth <> 0 And $iLine_Width > $iMaxWidth Then
For $j = 1 To $asLines[0]
$iLine_Length = StringLen($asLines[$j])
DllCall("gdi32.dll", "bool", "GetTextExtentPoint32W", "handle", $hDC, "wstr", $asLines[$j], "int", $iLine_Length, "ptr", DllStructGetPtr($tSize))
If @error Then Return SetError(2, _StringSize_Error_Close(6, $hDC, $hFont, $hLabel), 0)
If DllStructGetData($tSize, "X") < $iMaxWidth - 4 Then
$iLine_Count += 1
$avSize_Info[0] &= $asLines[$j] & @CRLF
Else
$iWrap_Count = 0
While 1
$iLine_Width = 0
$iLast_Word = 0
For $i = 1 To StringLen($asLines[$j])
If StringMid($asLines[$j], $i, 1) = " " Then $iLast_Word = $i - 1
$sTest_Line = StringMid($asLines[$j], 1, $i)
$iLine_Length = StringLen($sTest_Line)
DllCall("gdi32.dll", "bool", "GetTextExtentPoint32W", "handle", $hDC, "wstr", $sTest_Line, "int", $iLine_Length, "ptr", DllStructGetPtr($tSize))
If @error Then Return SetError(2, _StringSize_Error_Close(6, $hDC, $hFont, $hLabel), 0)
$iLine_Width = DllStructGetData($tSize, "X")
If $iLine_Width >= $iMaxWidth - 4 Then ExitLoop
Next
If $i > StringLen($asLines[$j]) Then
$iWrap_Count += 1
$avSize_Info[0] &= $sTest_Line & @CRLF
ExitLoop
Else
$iWrap_Count += 1
If $iLast_Word = 0 Then Return SetError(3, _StringSize_Error_Close(0, $hDC, $hFont, $hLabel), 0)
$avSize_Info[0] &= StringLeft($sTest_Line, $iLast_Word) & @CRLF
$asLines[$j] = StringTrimLeft($asLines[$j], $iLast_Word)
$asLines[$j] = StringStripWS($asLines[$j], 1)
EndIf
WEnd
$iLine_Count += $iWrap_Count
EndIf
Next
If $iExpTab Then
$avSize_Info[0] = StringRegExpReplace($avSize_Info[0], "\x20?XXXXXXXX", @TAB)
EndIf
$avSize_Info[1] = $iLine_Height
$avSize_Info[2] = $iMaxWidth
$avSize_Info[3] =($iLine_Count * $iLine_Height) + 4
Else
Local $avSize_Info[4] = [$sText, $iLine_Height, $iLine_Width,($asLines[0] * $iLine_Height) + 4]
EndIf
DllCall("gdi32.dll", "handle", "SelectObject", "handle", $hDC, "handle", $hPrevFont)
DllCall("gdi32.dll", "bool", "DeleteObject", "handle", $hFont)
DllCall("user32.dll", "int", "ReleaseDC", "hwnd", 0, "handle", $hDC)
If $hLabel Then GUICtrlDelete($hLabel)
Return $avSize_Info
EndFunc
Func _StringSize_Error_Close($iExtCode, $hDC = 0, $hFont = 0, $hLabel = 0)
If $hFont <> 0 Then DllCall("gdi32.dll", "bool", "DeleteObject", "handle", $hFont)
If $hDC <> 0 Then DllCall("user32.dll", "int", "ReleaseDC", "hwnd", 0, "handle", $hDC)
If $hLabel Then GUICtrlDelete($hLabel)
Return $iExtCode
EndFunc
Func _StringSize_DefaultFontName()
Local $tNONCLIENTMETRICS = DllStructCreate("uint;int;int;int;int;int;byte[60];int;int;byte[60];int;int;byte[60];byte[60];byte[60]")
DLLStructSetData($tNONCLIENTMETRICS, 1, DllStructGetSize($tNONCLIENTMETRICS))
DLLCall("user32.dll", "int", "SystemParametersInfo", "int", 41, "int", DllStructGetSize($tNONCLIENTMETRICS), "ptr", DllStructGetPtr($tNONCLIENTMETRICS), "int", 0)
Local $tLOGFONT = DllStructCreate("long;long;long;long;long;byte;byte;byte;byte;byte;byte;byte;byte;char[32]", DLLStructGetPtr($tNONCLIENTMETRICS, 13))
If IsString(DllStructGetData($tLOGFONT, 14)) Then
Return DllStructGetData($tLOGFONT, 14)
Else
Return "Tahoma"
EndIf
EndFunc
Global $g_NetStats_hIPHLPAPI_DLL = DllOpen("Iphlpapi.dll")
Global $g_NetStats_hWS2_32_DLL = DllOpen("ws2_32.dll")
Func _Network_IPAllAddressTable($nIPvFlag = 0, $bGetAllIPs = 0, $bGetDownIntfc = 0)
Local Const $tagIP_ADAPTER_ADDRESSES = "ulong Length;dword IfIndex;ptr Next;ptr AdapterName;ptr FirstUnicastAddress;" & "ptr FirstAnycastAddress;ptr FirstMulticastAddress;ptr FirstDnsServerAddress;ptr DnsSuffix;ptr Description;" & "ptr FriendlyName;byte PhysicalAddress[8];dword PhysicalAddressLength;dword Flags;dword Mtu;dword IfType;int OperStatus;" & "dword Ipv6IfIndex;dword ZoneIndices[16];ptr FirstPrefix;" & "uint64 TransmitLinkSpeed;uint64 ReceiveLinkSpeed;ptr FirstWinsServerAddress;ptr FirstGatewayAddress;" & "ulong Ipv4Metric;ulong Ipv6Metric;uint64 Luid;STRUCT;ptr Dhcpv4ServerSockAddr;int Dhcpv4ServerSockAddrLen;ENDSTRUCT;" & "ulong CompartmentId;STRUCT;ulong NetworkGuidData1;word NetworkGuidData2;word NetworkGuidData3;byte NetworkGuidData4[8];ENDSTRUCT;" & "int ConnectionType;int TunnelType;STRUCT;ptr Dhcpv6ServerSockAddr;int Dhcpv6ServerSockAddrLen;ENDSTRUCT;byte Dhcpv6ClientDuid[130];" & "ulong Dhcpv6ClientDuidLength;ulong Dhcpv6Iaid;ptr FirstDnsSuffix;"
Local $aRet, $nBufSize, $stBuffer, $stIP_ADAPTER_ADDRESSES, $pIPAAStruct, $nIPAAStSize
Local $pTemp, $nTemp, $sPhsyicalAddr
Local $nEntries, $aIPs, $aIPAddrEntries
If $nIPvFlag = 1 Then
$nIPvFlag = 2
ElseIf $nIPvFlag = 2 Then
$nIPvFlag = 23
Else
$nIPvFlag = 0
EndIf
$aRet = DllCall($g_NetStats_hIPHLPAPI_DLL, "ulong", "GetAdaptersAddresses", "ulong", $nIPvFlag, "ulong", 0x86 , "ptr", 0, "ptr", 0, "ulong*", 0)
If @error Then Return SetError(2, @error, "")
If $aRet[0] Then
If $aRet[0] <> 111 Or Not $aRet[5] Then Return SetError(3, $aRet[0], "")
EndIf
$nBufSize = $aRet[5]
$stBuffer = DllStructCreate("int64;byte [" & $nBufSize & "];")
$aRet = DllCall($g_NetStats_hIPHLPAPI_DLL, "ulong", "GetAdaptersAddresses", "ulong", $nIPvFlag, "ulong", 0x86, "ptr", 0, "ptr", DllStructGetPtr($stBuffer), "ulong*", $nBufSize)
If @error Then Return SetError(2, @error, "")
If $aRet[0] Then Return SetError(3, $aRet[0], "")
Dim $aIPAddrEntries[Floor($nBufSize / 72) ][24]
$nEntries = 0
$pIPAAStruct = DllStructGetPtr($stBuffer)
While $pIPAAStruct <> 0
$stIP_ADAPTER_ADDRESSES = DllStructCreate($tagIP_ADAPTER_ADDRESSES, $pIPAAStruct)
$nIPAAStSize = DllStructGetData($stIP_ADAPTER_ADDRESSES, "Length")
$nTemp = DllStructGetData($stIP_ADAPTER_ADDRESSES, "OperStatus")
If($nTemp = 2 And Not $bGetDownIntfc) Or DllStructGetData($stIP_ADAPTER_ADDRESSES, "IfType") = 24 Then
Else
$pTemp = DllStructGetData($stIP_ADAPTER_ADDRESSES, "FirstUnicastAddress")
If $pTemp <> 0 Then
$aIPAddrEntries[$nEntries][0] = DllStructGetData($stIP_ADAPTER_ADDRESSES, "IfIndex")
$aIPAddrEntries[$nEntries][1] = DllStructGetData($stIP_ADAPTER_ADDRESSES, "IfType")
$aIPAddrEntries[$nEntries][2] = $nTemp
If(Not @AutoItX64 And $nIPAAStSize > 72) Or(@AutoItX64 And $nIPAAStSize > 108) Then
$nTemp = DllStructGetData($stIP_ADAPTER_ADDRESSES, "Ipv6IfIndex")
If $nTemp And $nTemp <> $aIPAddrEntries[$nEntries][0] Then
$aIPAddrEntries[$nEntries][0] = $nTemp
EndIf
EndIf
$aIPAddrEntries[$nEntries][3] = DllStructGetData($stIP_ADAPTER_ADDRESSES, "Flags")
$nTemp = DllStructGetData($stIP_ADAPTER_ADDRESSES, "PhysicalAddressLength")
$sPhsyicalAddr = ""
For $i = 1 To $nTemp
$sPhsyicalAddr &= Hex(DllStructGetData($stIP_ADAPTER_ADDRESSES, "PhysicalAddress", $i),2) & "-"
Next
If $nTemp Then $sPhsyicalAddr = StringTrimRight($sPhsyicalAddr, 1)
$aIPAddrEntries[$nEntries][4] = $sPhsyicalAddr
$aIPAddrEntries[$nEntries][5] = DllStructGetData($stIP_ADAPTER_ADDRESSES, "Mtu")
$aIPAddrEntries[$nEntries][6] = _StringW_FromPtr(DllStructGetData($stIP_ADAPTER_ADDRESSES, "Description"))
$aIPAddrEntries[$nEntries][7] = _StringW_FromPtr(DllStructGetData($stIP_ADAPTER_ADDRESSES, "FriendlyName"))
$aIPAddrEntries[$nEntries][8] = _StringA_FromPtr(DllStructGetData($stIP_ADAPTER_ADDRESSES, "AdapterName"))
$aIPs = __Network_Pull_IPAdapterAddresses($pTemp, $bGetAllIPs)
$aIPAddrEntries[$nEntries][11] = $aIPs[2]
$aIPAddrEntries[$nEntries][12] = $aIPs[3]
$aIPs = __Network_Pull_IPAdapterAddresses(DllStructGetData($stIP_ADAPTER_ADDRESSES, "FirstDnsServerAddress"), 1)
$aIPAddrEntries[$nEntries][13] = $aIPs[2]
$aIPAddrEntries[$nEntries][14] = $aIPs[3]
If(Not @AutoItX64 And $nIPAAStSize > 144) Or(@AutoItX64 And $nIPAAStSize > 184) Then
$aIPAddrEntries[$nEntries][9] = DllStructGetData($stIP_ADAPTER_ADDRESSES, "ReceiveLinkSpeed")
$aIPAddrEntries[$nEntries][10] = DllStructGetData($stIP_ADAPTER_ADDRESSES, "TransmitLinkSpeed")
$aIPAddrEntries[$nEntries][21] = DllStructGetData($stIP_ADAPTER_ADDRESSES, "ConnectionType")
$aIPAddrEntries[$nEntries][22] = DllStructGetData($stIP_ADAPTER_ADDRESSES, "TunnelType")
$aIPs = __Network_Pull_IPAdapterAddresses(DllStructGetData($stIP_ADAPTER_ADDRESSES, "FirstGatewayAddress"), $bGetAllIPs)
$aIPAddrEntries[$nEntries][15] = $aIPs[2]
$aIPAddrEntries[$nEntries][16] = $aIPs[3]
$aIPAddrEntries[$nEntries][17] = __Network_Pull_IPFromSocket(DllStructGetPtr($stIP_ADAPTER_ADDRESSES, "Dhcpv4ServerSockAddr"))
$aIPAddrEntries[$nEntries][18] = __Network_Pull_IPFromSocket(DllStructGetPtr($stIP_ADAPTER_ADDRESSES, "Dhcpv6ServerSockAddr"))
$aIPs = __Network_Pull_IPAdapterAddresses(DllStructGetData($stIP_ADAPTER_ADDRESSES, "FirstWinsServerAddress"), $bGetAllIPs)
$aIPAddrEntries[$nEntries][19] = $aIPs[2]
$aIPAddrEntries[$nEntries][20] = $aIPs[3]
EndIf
$nEntries += 1
EndIf
EndIf
$pIPAAStruct = DllStructGetData($stIP_ADAPTER_ADDRESSES, "Next")
WEnd
If $nEntries = 0 Then Return SetError(-1, 0, "")
ReDim $aIPAddrEntries[$nEntries][24]
Return SetExtended($nEntries, $aIPAddrEntries)
EndFunc
Func _Network_IPv4AdaptersInfoEx($bGetAllIPs = 0)
Local Const $tagIP_ADAPTER_INFO = "ptr Next;DWORD ComboIndex;char AdapterName[260];char Description[132];" & "UINT AddressLength;BYTE Address[8];DWORD Index;UINT Type;UINT DhcpEnabled;ptr CurrentIpAddress;" & "STRUCT;ptr IpAddressListNext;char IpAddressListIpAddress[16];char IpAddressListIpMask[16];DWORD IpAddressListContext;ENDSTRUCT;" & "STRUCT;ptr GatewayListNext;char GatewayListIpAddress[16];char GatewayListIpMask[16];DWORD GatewayListContext;ENDSTRUCT;" & "STRUCT;ptr DhcpServerNext;char DhcpServerIpAddress[16];char DhcpServerIpMask[16];DWORD DhcpServerContext;ENDSTRUCT;" & "BOOL HaveWins;" & "STRUCT;ptr PrimaryWinsServerNext;char PrimaryWinsServerIpAddress[16];char PrimaryWinsServerIpMask[16];DWORD PrimaryWinsServerContext;ENDSTRUCT;" & "STRUCT;ptr SecondaryWinsServerNext;char SecondaryWinsServerIpAddress[16];char SecondaryWinsServerIpMask[16];DWORD SecondaryWinsServerContext;ENDSTRUCT;" & "long_ptr LeaseObtained;long_ptr LeaseExpires;"
Local $aRet, $nBufSize, $stBuffer, $pIPAIStruct, $stIP_ADAPTER_INFO, $aAdapterInfo
Local $nTemp, $sPhsyicalAddr, $nEntries, $aIPs
$aRet = DllCall($g_NetStats_hIPHLPAPI_DLL, "dword", "GetAdaptersInfo", "ptr", 0, "ulong*", 0)
If @error Then Return SetError(2, @error, "")
If $aRet[0] Then
If $aRet[0] <> 111 Or Not $aRet[2] Then Return SetError(3, $aRet[0], "")
EndIf
$nBufSize = $aRet[2]
$stBuffer = DllStructCreate("byte [" & $nBufSize & "];")
$aRet = DllCall($g_NetStats_hIPHLPAPI_DLL, "dword", "GetAdaptersInfo", "ptr", DllStructGetPtr($stBuffer), "ulong*", $nBufSize)
If @error Then Return SetError(2, @error, "")
If $aRet[0] Then Return SetError(3, $aRet[0], "")
Dim $aAdapterInfo[Floor($nBufSize / 640) ][23]
$nEntries = 0
$pIPAIStruct = DllStructGetPtr($stBuffer)
While $pIPAIStruct <> 0
$stIP_ADAPTER_INFO = DllStructCreate($tagIP_ADAPTER_INFO, $pIPAIStruct)
$aAdapterInfo[$nEntries][0] = DllStructGetData($stIP_ADAPTER_INFO, "Index")
$aAdapterInfo[$nEntries][1] = DllStructGetData($stIP_ADAPTER_INFO, "Type")
$aAdapterInfo[$nEntries][2] = DllStructGetData($stIP_ADAPTER_INFO, "DhcpEnabled")
$aAdapterInfo[$nEntries][3] = DllStructGetData($stIP_ADAPTER_INFO, "HaveWins")
$nTemp = DllStructGetData($stIP_ADAPTER_INFO, "AddressLength")
$sPhsyicalAddr = ""
For $i = 1 To $nTemp
$sPhsyicalAddr &= Hex(DllStructGetData($stIP_ADAPTER_INFO, "Address", $i),2) & "-"
Next
If $nTemp Then $sPhsyicalAddr = StringTrimRight($sPhsyicalAddr, 1)
$aAdapterInfo[$nEntries][4] = $sPhsyicalAddr
$aAdapterInfo[$nEntries][5] = 0
$aAdapterInfo[$nEntries][6] = DllStructGetData($stIP_ADAPTER_INFO, "Description")
$aAdapterInfo[$nEntries][8] = DllStructGetData($stIP_ADAPTER_INFO, "AdapterName")
$aIPs = __Network_Pull_IPFromAddrString(DllStructGetPtr($stIP_ADAPTER_INFO, "IpAddressListNext"), $bGetAllIPs)
$aAdapterInfo[$nEntries][11] = $aIPs[1]
$aAdapterInfo[$nEntries][12] = $aIPs[2]
$aIPs = __Network_Pull_IPFromAddrString(DllStructGetPtr($stIP_ADAPTER_INFO, "GatewayListNext"), $bGetAllIPs)
$aAdapterInfo[$nEntries][13] = $aIPs[1]
$aAdapterInfo[$nEntries][14] = $aIPs[2]
If $aAdapterInfo[$nEntries][2] Then
$aIPs = __Network_Pull_IPFromAddrString(DllStructGetPtr($stIP_ADAPTER_INFO, "DhcpServerNext"), $bGetAllIPs)
$aAdapterInfo[$nEntries][15] = $aIPs[1]
$aAdapterInfo[$nEntries][16] = $aIPs[2]
$aAdapterInfo[$nEntries][17] = DllStructGetData($stIP_ADAPTER_INFO, "LeaseObtained")
$aAdapterInfo[$nEntries][18] = DllStructGetData($stIP_ADAPTER_INFO, "LeaseExpires")
EndIf
If $aAdapterInfo[$nEntries][3] Then
$aIPs = __Network_Pull_IPFromAddrString(DllStructGetPtr($stIP_ADAPTER_INFO, "PrimaryWinsServerNext"), $bGetAllIPs)
$aAdapterInfo[$nEntries][19] = $aIPs[1]
$aAdapterInfo[$nEntries][20] = $aIPs[2]
$aIPs = __Network_Pull_IPFromAddrString(DllStructGetPtr($stIP_ADAPTER_INFO, "SecondaryWinsServerNext"), $bGetAllIPs)
$aAdapterInfo[$nEntries][21] = $aIPs[1]
$aAdapterInfo[$nEntries][22] = $aIPs[2]
EndIf
$nEntries += 1
$pIPAIStruct = DllStructGetData($stIP_ADAPTER_INFO, "Next")
WEnd
If $nEntries = 0 Then Return SetError(-1, 0, "")
ReDim $aAdapterInfo[$nEntries][23]
Return SetExtended($nEntries, $aAdapterInfo)
Return
EndFunc
Func __Network_WSA_Startup()
Static Local $bWSAStartedUp = False
If Not $bWSAStartedUp Then
Local $aRet = DllCall($g_NetStats_hWS2_32_DLL, "int", "WSAStartup", "word", 0x0202, "str", "")
If @error Then Return SetError(2, @error, "")
If $aRet[0] Then Return SetError(3, $aRet[0], "")
$bWSAStartedUp = True
OnAutoItExitRegister("__Network_WSA_Cleanup")
EndIf
Return True
EndFunc
Func __Network_WSA_Cleanup()
DllCall($g_NetStats_hWS2_32_DLL, "int", "WSACleanup")
EndFunc
Func _StringA_FromPtr($pStr)
If Not IsPtr($pStr) Or $pStr = 0 Then Return SetError(1,0,"")
Local $aRet = DllCall("kernel32.dll", "ptr", "lstrcpynA", "str", "", "ptr", $pStr, "int", 32767)
If @error Or Not $aRet[0] Then Return SetError(@error,0,"")
Return $aRet[1]
EndFunc
Func _StringW_FromPtr($pStr)
If Not IsPtr($pStr) Or $pStr = 0 Then Return SetError(1,0,"")
Local $aRet = DllCall("kernel32.dll", "ptr", "lstrcpynW", "wstr", "", "ptr", $pStr, "int", 32767)
If @error Or Not $aRet[0] Then Return SetError(@error,0,"")
Return $aRet[1]
EndFunc
Func _Network_IP_Long_To_String($nLong)
Local $aRet = DllCall($g_NetStats_hWS2_32_DLL, "str", "inet_ntoa", "ulong", $nLong)
If @error Then Return SetError(2, @error, "")
Return $aRet[0]
EndFunc
Func _Network_IP_In_Addr_To_StringWSA($stSockAddrIn, $nSize = 0)
If Not IsDllStruct($stSockAddrIn) Then Return SetError(1,0,"")
If Not __Network_WSA_Startup() Then Return SetError(@error, @extended, "")
If Int($nSize) = 0 Then
$nSize = DllStructGetSize($stSockAddrIn)
Else
If $nSize <> 16 And $nSize <> 28 And $nSize <> 32 Then Return SetError(1,0,"")
EndIf
Local $aRet = DllCall($g_NetStats_hWS2_32_DLL, "int", "WSAAddressToStringA", "ptr", DllStructGetPtr($stSockAddrIn), "dword", $nSize, "ptr", 0, "str", "", "dword*", 46)
If @error Then Return SetError(2,@error,"")
If $aRet[0] Then
ConsoleWrite("Error from WSAAddressToStringA: " & $aRet[0] & @CRLF)
$aRet = DllCall($g_NetStats_hWS2_32_DLL, "int", "WSAGetLastError")
If Not @error Then
ConsoleWrite("WSAGetLastError = " & $aRet[0] & @CRLF)
Return SetError(3,$aRet[0],"")
Else
Return SetError(2,@error,"")
EndIf
EndIf
Local $nPos = StringInStr($aRet[4], "%", 1, 1)
If $nPos Then
$aRet[4] = StringLeft($aRet[4], $nPos - 1)
EndIf
Return $aRet[4]
EndFunc
Func _Network_IP_In_Addr_To_StringV($stSockAddrIn, $nSize = 0)
If Not IsDllStruct($stSockAddrIn) Then Return SetError(1,0,"")
If Int($nSize) = 0 Then
$nSize = DllStructGetSize($stSockAddrIn)
Else
If $nSize <> 16 And $nSize <> 28 And $nSize <> 32 Then Return SetError(1,0,"")
EndIf
Local $nType, $pInAddr
If $nSize = 16 Then
$nType = 2
$pInAddr = DllStructGetPtr($stSockAddrIn, 3)
Else
$nType = 23
$pInAddr = DllStructGetPtr($stSockAddrIn, 4)
EndIf
Local $aRet = DllCall($g_NetStats_hWS2_32_DLL, "ptr", "inet_ntop", "int", $nType, "ptr", $pInAddr, "str", "", "ulong_ptr", 46)
If @error Then Return SetError(2,@error,"")
If $aRet[0] = 0 Then Return SetError(3,0,"")
Return $aRet[3]
EndFunc
Func __Network_Pull_IPFromSocket($pSocketAddress)
Static Local $b_OS_PreVista = StringRegExp(@OSVersion,"_(XP|200(0|3))")
Local Const $tagSOCKET_ADDRESS = "ptr lpSockaddr;int iSockaddrLength;"
Local Const $tagSOCKADDR_IN = "short sin_family;ushort sin_port;ulong sin_addr;char sin_zero[8];"
Local Const $tagSOCKADDR_IN6 = "short sin6_family;ushort sin6_port;ulong sin6_flowinfo;STRUCT;ushort sin6_addr[8];ENDSTRUCT;ulong sin6_scope_id;"
If Not IsPtr($pSocketAddress) Or $pSocketAddress = 0 Then Return SetError(1,0,"")
Local $stSocketAddress, $stSockAddrIn, $pSockAddrIn, $nSockAddrLen
$stSocketAddress = DllStructCreate($tagSOCKET_ADDRESS, $pSocketAddress)
$pSockAddrIn = DllStructGetData($stSocketAddress, "lpSockaddr")
If $pSockAddrIn = 0 Then Return SetError(-1,0,"")
$nSockAddrLen = DllStructGetData($stSocketAddress, "iSockaddrLength")
If $nSockAddrLen = 16 Then
$stSockAddrIn = DllStructCreate($tagSOCKADDR_IN, $pSockAddrIn)
Return SetExtended(4, _Network_IP_Long_To_String(DllStructGetData($stSockAddrIn, "sin_addr")) )
ElseIf $nSockAddrLen >= 28 Then
$stSockAddrIn = DllStructCreate($tagSOCKADDR_IN6, $pSockAddrIn)
If $b_OS_PreVista Then
Return SetExtended(6, _Network_IP_In_Addr_To_StringWSA($stSockAddrIn, $nSockAddrLen))
Else
Return SetExtended(6, _Network_IP_In_Addr_To_StringV($stSockAddrIn, $nSockAddrLen))
EndIf
EndIf
Return SetError(-1,0,"")
EndFunc
Func __Network_Pull_IPAdapterAddresses($pAnyCastStart, $bGetAllIPs = 0)
Local Const $tagIP_ADAPTER_ANYCAST_ADDRESS = "ulong Length;dword Flags;ptr Next;STRUCT;ptr AddressSockAddr;int AddressSockAddrLen;ENDSTRUCT;"
Local $aIPs[4] = [0, 0, "", ""]
If Not IsPtr($pAnyCastStart) Or $pAnyCastStart = 0 Then Return SetError(1,0,$aIPs)
Local $sIPStr, $nIPv4s = 0, $nIPv6s = 0
Local $pIPAAAddress, $stAnyCastAddress
$pIPAAAddress = $pAnyCastStart
Do
$stAnyCastAddress = DllStructCreate($tagIP_ADAPTER_ANYCAST_ADDRESS, $pIPAAAddress)
$sIPStr = __Network_Pull_IPFromSocket(DllStructGetPtr($stAnyCastAddress, "AddressSockAddr"))
If @extended = 4 Then
If $bGetAllIPs Or Not $nIPv4s Then
If $nIPv4s Then
$aIPs[2] &= "|"
EndIf
$aIPs[2] &= $sIPStr
$nIPv4s += 1
EndIf
ElseIf @extended = 6 Then
If $bGetAllIPs Or Not $nIPv6s Then
If $nIPv6s Then
$aIPs[3] &= "|"
EndIf
$aIPs[3] &= $sIPStr
$nIPv6s += 1
EndIf
EndIf
$pIPAAAddress = DllStructGetData($stAnyCastAddress, "Next")
Until $pIPAAAddress = 0
$aIPs[0] = $nIPv4s
$aIPs[1] = $nIPv6s
Return $aIPs
EndFunc
Func __Network_Pull_IPFromAddrString($pIPAddrStr, $bGetAllIPs = 0)
Local Const $tagIP_ADDR_STRING = "ptr Next;char IpAddress[16];char IpMask[16];DWORD Context;"
Local $aIPs[4] = [0, "", ""]
If Not IsPtr($pIPAddrStr) Or $pIPAddrStr = 0 Then Return SetError(1,0,$aIPs)
Local $stIPAddrString, $sIPAddr = "", $sIPMask = ""
Do
$stIPAddrString = DllStructCreate($tagIP_ADDR_STRING, $pIPAddrStr)
$sIPMask = DllStructGetData($stIPAddrString, "IpMask")
$sIPAddr = DllStructGetData($stIPAddrString, "IpAddress")
If $sIPAddr<>"" And $sIPMask<>"" Then
If $aIPs[0] Then
$aIPs[1] &= '|'
$aIPs[2] &= '|'
EndIf
$aIPs[0] += 1
$aIPs[1] &= $sIPAddr
$aIPs[2] &= $sIPMask
If Not $bGetAllIPs Then ExitLoop
EndIf
$pIPAddrStr = DllStructGetData($stIPAddrString, "Next")
Until $pIPAddrStr = 0
Return $aIPs
EndFunc
Func _ExitChild($childwin)
$guiState = WinGetState( $hgui )
GUISetState(@SW_ENABLE, $hGUI)
Local $a_ret = DllCall("user32.dll", "int", "DestroyWindow", "hwnd", $childwin)
If NOT(BitAND($guiState,$WIN_STATE_VISIBLE)) OR BitAND($guiState,$WIN_STATE_MINIMIZED) Then Return
If BitAND($guiState,$WIN_STATE_EXISTS) AND NOT(BitAND($guiState,$WIN_STATE_ACTIVE)) Then
_maximize()
EndIf
EndFunc
Func _updateCombo()
_setStatus("Updating Adapter List...")
_loadAdapters()
_GUICtrlComboBox_ResetContent(GUICtrlGetHandle($combo_adapters))
If NOT IsArray( $adapters ) Then
MsgBox( 16, "Error", "There was a problem retrieving the adapters." )
Else
_ArraySort($adapters, 0)
$defaultitem = $adapters[1][0]
$index = _ArraySearch( $adapters, $options[4][1], 1 )
If($index <> -1) Then
$defaultitem = $adapters[$index][0]
EndIf
$aBlacklist = StringSplit($options[7][1], "|")
For $i=1 to $adapters[0][0]
$indexBlacklist = _ArraySearch($aBlacklist, $adapters[$i][0], 1)
if $indexBlacklist <> -1 Then ContinueLoop
GUICtrlSetData( $combo_adapters, $adapters[$i][0], $defaultitem )
Next
EndIf
ControlSend($hgui, "", $combo_adapters, "{END}")
_setStatus("Ready")
EndFunc
Func _blacklistAdd()
$selected_adapter = GUICtrlRead($combo_adapters)
$list = GUICtrlRead($blacklistEdit)
If $list = "" OR StringRight($list, 1) = @CR OR StringRight($list, 1) = @LF Then
$newString = $selected_adapter
Else
$newString = @CRLF&$selected_adapter
EndIf
$iEnd = StringLen($list & $newString)
_GUICtrlEdit_SetSel($blacklistEdit, $iEnd, $iEnd)
_GUICtrlEdit_Scroll($blacklistEdit, 4)
GUICtrlSetData($blacklistEdit, $newString, 1)
EndFunc
Func _arrange($desc=0)
_loadProfiles()
Local $newfile = ""
$newfile &= "[Options]" & @CRLF
$newfile &= $options[0][0] & "=" & $options[0][1] & @CRLF
$newfile &= $options[1][0] & "=" & $options[1][1] & @CRLF
$newfile &= $options[2][0] & "=" & $options[2][1] & @CRLF
$newfile &= $options[3][0] & "=" & $options[3][1] & @CRLF
$newfile &= $options[4][0] & "=" & $options[4][1] & @CRLF
$newfile &= $options[5][0] & "=" & $options[5][1] & @CRLF
$newfile &= $options[6][0] & "=" & $options[6][1] & @CRLF
$newfile &= $options[7][0] & "=" & $options[7][1] & @CRLF
Local $profileNames = _getNames()
$profileNamesSorted = $profileNames
_ArraySort($profileNamesSorted, $desc)
For $i=0 to UBound($profileNames)-1
$index = _ArraySearch($profileNames, $profileNamesSorted[$i])
If $index <> -1 Then
$iniName = StringReplace($profileNamesSorted[$i], "[", "{lb}")
$iniName = StringReplace($iniName, "]", "{rb}")
$newfile &= "[" & $iniName & "]" & @CRLF
$newfile &= $propertyFormat[0] & "=" &($profilelist[$index][1])[0] & @CRLF
$newfile &= $propertyFormat[1] & "=" &($profilelist[$index][1])[1] & @CRLF
$newfile &= $propertyFormat[2] & "=" &($profilelist[$index][1])[2] & @CRLF
$newfile &= $propertyFormat[3] & "=" &($profilelist[$index][1])[3] & @CRLF
$newfile &= $propertyFormat[4] & "=" &($profilelist[$index][1])[4] & @CRLF
$newfile &= $propertyFormat[5] & "=" &($profilelist[$index][1])[5] & @CRLF
$newfile &= $propertyFormat[6] & "=" &($profilelist[$index][1])[6] & @CRLF
$newfile &= $propertyFormat[7] & "=" &($profilelist[$index][1])[7] & @CRLF
$newfile &= $propertyFormat[8] & "=" &($profilelist[$index][1])[8] & @CRLF
EndIf
Next
For $i=1 to UBound($profileNamesSorted)
$profilelist[$i][0] = $profileNamesSorted[$i-1]
Next
Local $hFileOpen = FileOpen("profiles.ini", 2)
If $hFileOpen = -1 Then
Return 1
EndIf
Local $sFileWrite = FileWrite($hFileOpen, $newfile)
if @error <> 0 Then
FileClose($hFileOpen)
Return 3
EndIf
FileClose($hFileOpen)
_updateProfileList()
Return 0
EndFunc
Func _checkMouse($Id)
$idPos = ControlGetPos($hgui, "", $Id)
$mPos = MouseGetPos()
If $mPos[0] > $idPos[0] and $mPos[0] < $idPos[0]+$idPos[2] and $mPos[1] > $idPos[1] and $mPos[1] < $idPos[1]+$idPos[3] Then
return 1
Else
return 0
EndIf
EndFunc
Func _clickDn()
If $mdblcheck = 1 Then
$mdblTimerDiff = TimerDiff( $mdblTimerInit )
EndIf
If $mdblTimerDiff <= 500 Then
$mdblTimerInit = TimerInit()
$mdblClick = 1
Return
Else
$mdblTimerInit = TimerInit()
$mdblcheck = 1
$mdblClick = 0
EndIf
if _checkMouse($list_profiles) Then
$dragitem = ControlListView($hgui, "", $list_profiles, "GetSelected")
if $dragitem <> "" Then
$dragging = True
Else
$dragging = False
EndIf
Else
$dragging = False
EndIf
EndFunc
Func _clickUp()
If _checkMouse($list_profiles) and _ctrlHasFocus($list_profiles) Then
MouseClick("left")
If $mdblClick Then
_apply()
$mdblClick = 0
Else
If $dragging Then
$newitem = ControlListView($hgui, "", $list_profiles, "GetSelected")
$dragtext = ControlListView($hgui, "", $list_profiles, "GetText", $dragitem)
$newtext = ControlListView($hgui, "", $list_profiles, "GetText", $newitem)
if $newitem <> "" Then
$ret = _iniMove("profiles.ini", $dragtext, $newtext)
If not $ret Then
Select
Case $dragitem < $newitem
_GUICtrlListView_DeleteItem(GUICtrlGetHandle($list_profiles), $dragitem)
_GUICtrlListView_InsertItem(GUICtrlGetHandle($list_profiles), $dragtext, $newitem)
Case $dragitem > $newitem
_GUICtrlListView_DeleteItem(GUICtrlGetHandle($list_profiles), $dragitem)
_GUICtrlListView_InsertItem(GUICtrlGetHandle($list_profiles), $dragtext, $newitem)
EndSelect
$newtext = ControlListView($hgui, "", $list_profiles, "Select", $newitem)
EndIf
EndIf
EndIf
EndIf
EndIf
$dragging = False
EndFunc
Func _iniMove($file, $fromName, $toName)
Local $sNewFile = ""
Local $sLeft = ""
Local $sSection = ""
Local $sMid = ""
Local $sRight = ""
Local $sAfterTo = ""
$inifromName = StringReplace($fromName, "[", "{lb}")
$inifromName = StringReplace($inifromName, "]", "{rb}")
$initoName = StringReplace($toName, "[", "{lb}")
$initoName = StringReplace($initoName, "]", "{rb}")
Local $sFileRead = FileRead($file)
If @error <> 0 Then
Return 1
EndIf
$strToPos = StringInStr($sFileRead, "["&$initoName&"]")
If $strToPos = 0 Then
Return 2
EndIf
$strFromPos = StringInStr($sFileRead, "["&$inifromName&"]")
If $strFromPos = 0 Then
Return 2
EndIf
If $strFromPos > $strToPos Then
$aToSplit = StringSplit($sFileRead, "["&$initoName&"]", 1)
if @error Then
Return 1
EndIf
$sLeft = $aToSplit[1]
$aFromSplit = StringSplit($aToSplit[2], "["&$inifromName&"]", 1)
if @error Then
Return 1
EndIf
$sMid = "["&$initoName&"]" & $aFromSplit[1]
$strNextPos = StringInStr($aFromSplit[2], "[")
If $strNextPos = 0 Then
$sSection = "["&$inifromName&"]" & $aFromSplit[2]
$sRight = ""
Else
$sSection = "["&$inifromName&"]" & StringLeft($aFromSplit[2], $strNextPos-1)
$sRight = StringRight( $aFromSplit[2], StringLen($aFromSplit[2])-$strNextPos+1 )
EndIf
$sNewFile = $sLeft & $sSection & $sMid & $sRight
ElseIf $strFromPos < $strToPos Then
$aFromSplit = StringSplit($sFileRead, "["&$inifromName&"]", 1)
if @error Then
Return 1
EndIf
$sBeforeFrom = $aFromSplit[1]
$strNextPos = StringInStr($aFromSplit[2], "[")
$sSection = "["&$inifromName&"]" & StringLeft($aFromSplit[2], $strNextPos-1)
$sAfterFrom = StringRight($aFromSplit[2], StringLen($aFromSplit[2])-$strNextPos+1)
$strToPos = StringInStr($sAfterFrom, "["&$initoName&"]")
$strNextPos = StringInStr($sAfterFrom, "[", 0, 1, $strToPos+1)
If $strNextPos = 0 Then
$sMid = $sAfterFrom
$sAfterTo = ""
Else
$sMid = StringLeft( $sAfterFrom, $strNextPos-1 )
$sAfterTo = StringRight( $sAfterFrom, StringLen($sAfterFrom)-$strNextPos+1 )
EndIf
$sNewFile = $sBeforeFrom & $sMid & $sSection & $sAfterTo
Else
Return 0
EndIf
Local $hFileOpen = FileOpen($file, 2)
If $hFileOpen = -1 Then
Return 1
EndIf
Local $sFileWrite = FileWrite($hFileOpen, $sNewFile)
if @error <> 0 Then
FileClose($hFileOpen)
Return 3
EndIf
FileClose($hFileOpen)
Return 0
EndFunc
Func _radios()
if GUICtrlRead($radio_IpAuto) = $GUI_CHECKED Then
GUICtrlSetState($radio_DnsAuto, $GUI_ENABLE)
WinSetState($ip_Ip, "", @SW_DISABLE)
WinSetState($ip_Subnet, "", @SW_DISABLE)
WinSetState($ip_Gateway, "", @SW_DISABLE)
GUICtrlSetState($label_ip, $GUI_DISABLE)
GUICtrlSetState($label_subnet, $GUI_DISABLE)
GUICtrlSetState($label_gateway, $GUI_DISABLE)
Else
GUICtrlSetState($radio_DnsMan, $GUI_CHECKED)
GUICtrlSetState($radio_DnsAuto, $GUI_DISABLE)
WinSetState($ip_Ip, "", @SW_ENABLE)
WinSetState($ip_Subnet, "", @SW_ENABLE)
WinSetState($ip_Gateway, "", @SW_ENABLE)
GUICtrlSetState($label_ip, $GUI_ENABLE)
GUICtrlSetState($label_subnet, $GUI_ENABLE)
GUICtrlSetState($label_gateway, $GUI_ENABLE)
EndIf
if GUICtrlRead($radio_DnsAuto) = $GUI_CHECKED Then
WinSetState($ip_DnsPri, "", @SW_DISABLE)
WinSetState($ip_DnsAlt, "", @SW_DISABLE)
GUICtrlSetState($label_dnsPri, $GUI_DISABLE)
GUICtrlSetState($label_dnsAlt, $GUI_DISABLE)
GUICtrlSetState($ck_dnsReg, $GUI_DISABLE)
Else
WinSetState($ip_DnsPri, "", @SW_ENABLE)
WinSetState($ip_DnsAlt, "", @SW_ENABLE)
GUICtrlSetState($label_dnsPri, $GUI_ENABLE)
GUICtrlSetState($label_dnsAlt, $GUI_ENABLE)
GUICtrlSetState($ck_dnsReg, $GUI_ENABLE)
EndIf
EndFunc
Func _apply()
$selected_adapter = GUICtrlRead($combo_adapters)
If $selected_adapter = "" Then
_setStatus("Please select an adapter and try again", 1)
Return 1
Endif
$ip = ""
$subnet = ""
$gateway = ""
$dhcp =(GUICtrlRead($radio_IpAuto) = $GUI_CHECKED)?1:0
$cmd1 = 'netsh interface ip set address '
$cmd2 = '"' & $selected_adapter & '"'
$cmd3 = ""
$message = ""
if $dhcp Then
$cmd3 = " dhcp"
$message = "Setting DHCP..."
Else
$ip = _ctrlGetIP( $ip_Ip )
$subnet = _ctrlGetIP( $ip_Subnet )
$gateway = _ctrlGetIP( $ip_Gateway )
If $ip = "" Then
_setStatus("Please enter an IP address", 1)
Return 1
ElseIf $subnet = "" Then
_setStatus("Please enter a subnet mask", 1)
Return 1
Else
If $gateway = "" Then
$cmd3 = " static " & $ip & " " & $subnet & " none"
Else
$cmd3 = " static " & $ip & " " & $subnet & " " & $gateway & " 1"
EndIf
$message = "Setting static IP address..."
EndIf
EndIf
_asyncNewCmd($cmd1&$cmd2&$cmd3, $message)
$dnsp = ""
$dnsa = ""
$dnsDhcp =(GUICtrlRead($radio_DnsAuto) = $GUI_CHECKED)?1:0
$cmd1 = ''
$cmd1_1 = 'netsh interface ip set dns '
$cmd1_2 = 'netsh interface ip add dns '
$cmd1_3 = 'netsh interface ip delete dns '
$cmd2 = '"' & $selected_adapter & '"'
$cmd3 = ""
$cmdend = ""
$message = ""
$cmdReg = ""
if $dnsDhcp Then
$cmd1 = $cmd1_1
$cmd3 = " dhcp"
$message = "Setting DNS DHCP..."
_asyncNewCmd($cmd1&$cmd2&$cmd3, $message, 1)
Else
$dnsp = _ctrlGetIP( $ip_DnsPri )
$dnsa = _ctrlGetIP( $ip_DnsAlt )
If BitAND(GUICtrlRead($ck_dnsReg), $GUI_CHECKED) = $GUI_CHECKED Then
$cmdReg = "both"
Else
$cmdReg = "none"
EndIf
If $dnsp <> "" Then
$cmd1 = $cmd1_1
$cmd3 = " static " & $dnsp
$message = "Setting preferred DNS server..."
$cmdend =(_OSVersion() >= 6)?" " & $cmdReg & " no":"$cmdReg"
_asyncNewCmd($cmd1&$cmd2&$cmd3&$cmdend, $message, 1)
If $dnsa <> "" Then
$cmd1 = $cmd1_2
$cmd3 = " " & $dnsa
$message = "Setting alternate DNS server..."
$cmdend =(_OSVersion() >= 6)?" 2 no":""
_asyncNewCmd($cmd1&$cmd2&$cmd3&$cmdend, $message, 1)
EndIf
ElseIf $dnsa <> "" Then
$cmd1 = $cmd1_1
$cmd3 = " static " & $dnsp
$message = "Setting preferred DNS server..."
$cmdend =(_OSVersion() >= 6)?" " & $cmdReg & " no":"$cmdReg"
_asyncNewCmd($cmd1&$cmd2&$cmd3&$cmdend, $message, 1)
Else
$cmd1 = $cmd1_3
$cmd3 = " all"
$message = "Deleting DNS servers..."
_asyncNewCmd($cmd1&$cmd2&$cmd3, $message, 1)
EndIf
EndIf
EndFunc
Func _OSVersion()
Return RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\", "CurrentVersion")
EndFunc
Func _pull()
GUICtrlSetState( $radio_IpMan, $GUI_CHECKED )
_ctrlSetIP($ip_Ip, GUICtrlRead($label_CurrentIp) )
_ctrlSetIP($ip_Subnet, GUICtrlRead($label_CurrentSubnet) )
_ctrlSetIP($ip_Gateway, GUICtrlRead($label_CurrentGateway) )
GUICtrlSetState( $radio_DnsMan, $GUI_CHECKED )
_ctrlSetIP($ip_DnsPri, GUICtrlRead($label_CurrentDnsPri) )
_ctrlSetIP($ip_DnsAlt, GUICtrlRead($label_CurrentDnsAlt) )
_radios()
EndFunc
Func _ctrlHasFocus($id)
$idFocus = ControlGetFocus($hgui)
$hFocus = ControlGetHandle($hgui, "", $idFocus)
$hCtrl = ControlGetHandle($hgui, "", $id)
If $hFocus = $hCtrl Then
Return 1
Else
Return 0
EndIf
EndFunc
Func _disable()
$selected_adapter = GUICtrlRead($combo_adapters)
if _GUICtrlMenu_GetItemText( GUICtrlGetHandle($toolsmenu), $disableitem, 0 ) = "Disable adapter" Then
_AdapterMod($selected_adapter, 0)
GUICtrlSetData($disableitem, "Enable adapter")
Else
_AdapterMod($selected_adapter, 1)
GUICtrlSetData($disableitem, "Disable adapter")
_setStatus("Updating Adapter List...")
_loadAdapters()
_setStatus("Ready")
EndIf
EndFunc
Func _onLvDoneEdit()
$lv_newName = ControlListView($hgui, "", $list_profiles, "GetText", $lv_editIndex )
$lv_doneEditing = 0
If $lv_aboutEditing Then
Return
EndIf
If $lv_newItem = 0 Then
_rename()
Else
_new()
EndIf
EndFunc
Func _clear()
_ctrlSetIP($ip_Ip, "")
_ctrlSetIP($ip_Subnet, "")
_ctrlSetIP($ip_Gateway, "")
_ctrlSetIP($ip_DnsPri, "")
_ctrlSetIP($ip_DnsAlt, "")
EndFunc
Func _checkChangelog()
if $options[0][1] <> $winVersion Then
_changeLog()
$options[0][1] = $winVersion
IniWrite("profiles.ini", "options", $options[0][0], $options[0][1])
EndIf
EndFunc
Func _rename()
If $lv_oldName = $lv_newName Then
Return
EndIf
$ret = _iniRename("profiles.ini", $lv_oldName, $lv_newName)
If $ret = 2 Then
MsgBox($MB_ICONWARNING,"Warning!","The profile name already exists!")
_GUICtrlListView_SetItemText($list_profiles, $lv_editIndex, $lv_oldName )
ElseIf $ret = 1 or $ret = 3 Then
_setStatus("An error occurred while saving the profile name", 1)
Else
Local $profileNames[1]
_ArrayDelete($profileNames, 0)
If IsArray($profilelist) Then
For $i=1 to $profilelist[0][0]
_ArrayAdd($profileNames, $profilelist[$i][0])
Next
$index = _ArraySearch($profileNames, $lv_oldName)+1
If $index <> -1 Then
$profilelist[$index][0] = $lv_newName
EndIf
Else
_setStatus("An error occurred while renaming the profile", 1)
Return 1
EndIf
EndIf
EndFunc
Func _iniRename($file, $oldName, $newName)
Local $sNewFile = ""
$iniOldName = StringReplace($oldName, "[", "{lb}")
$iniOldName = StringReplace($iniOldName, "]", "{rb}")
$iniNewName = StringReplace($newName, "[", "{lb}")
$iniNewName = StringReplace($iniNewName, "]", "{rb}")
Local $sFileRead = FileRead($file)
If @error <> 0 Then
Return 1
EndIf
$strPos = StringInStr($sFileRead, "["&$iniNewName&"]")
If $strPos <> 0 Then
Return 2
Else
$sNewFile = StringReplace($sFileRead, $iniOldName, $iniNewName, 1)
EndIf
Local $hFileOpen = FileOpen($file, 2)
If $hFileOpen = -1 Then
Return 1
EndIf
Local $sFileWrite = FileWrite($hFileOpen, $sNewFile)
if @error <> 0 Then
FileClose($hFileOpen)
Return 3
EndIf
FileClose($hFileOpen)
Return 0
EndFunc
Func _delete($name="")
$profileName = StringReplace( GUICtrlRead(GUICtrlRead($list_profiles)), "|", "")
$selIndex = ControlListView($hgui, "", $list_profiles, "GetSelected")
$iniName = StringReplace($profileName, "[", "{lb}")
$iniName = StringReplace($iniName, "]", "{rb}")
$ret = IniDelete( "profiles.ini", $iniName )
If $ret = 0 Then
_setStatus("An error occurred while deleting the profile", 1)
EndIf
Local $profileNames[1]
_ArrayDelete($profileNames, 0)
If IsArray($profilelist) Then
For $i=1 to $profilelist[0][0]
_ArrayAdd($profileNames, $profilelist[$i][0])
Next
$index = _ArraySearch($profileNames, $profileName)+1
If $index <> -1 Then
_ArrayDelete( $profilelist, $index )
$profilelist[0][0] = $profilelist[0][0] - 1
EndIf
Else
Return 1
EndIf
_updateProfileList()
If $selIndex = ControlListView($hgui, "", $list_profiles, "GetItemCount") Then
ControlListView($hgui, "", $list_profiles, "Select", $selIndex-1 )
Else
ControlListView($hgui, "", $list_profiles, "Select", $selIndex )
EndIf
EndFunc
Func _new()
$index = ControlListView($hgui, "", $list_profiles, "GetSelected")
$text = ControlListView($hgui, "", $list_profiles, "GetText", $index)
$profileName = $text
Local $section[9][2]
$section[0][0] = $propertyFormat[0]
$section[0][1] = _StateToStr( $radio_IpAuto )
$section[1][0] = $propertyFormat[1]
$section[1][1] = _ctrlGetIP( $ip_Ip )
$section[2][0] = $propertyFormat[2]
$section[2][1] = _ctrlGetIP( $ip_Subnet )
$section[3][0] = $propertyFormat[3]
$section[3][1] = _ctrlGetIP( $ip_Gateway )
$section[4][0] = $propertyFormat[4]
$section[4][1] = _StateToStr( $radio_DnsAuto )
$section[5][0] = $propertyFormat[5]
$section[5][1] = _ctrlGetIP( $ip_DnsPri )
$section[6][0] = $propertyFormat[6]
$section[6][1] = _ctrlGetIP( $ip_DnsAlt )
$adapName = StringReplace(GUICtrlRead($combo_adapters), "[", "{lb}")
$adapName = StringReplace($adapName, "]", "{rb}")
$section[7][0] = $propertyFormat[7]
$section[7][1] = _StateToStr( $ck_dnsReg )
$section[8][0] = $propertyFormat[7]
$section[8][1] = $adapName
$iniName = StringReplace($profileName, "[", "{lb}")
$iniName = StringReplace($iniName, "]", "{rb}")
Local $sectionValues[9]
for $i=0 to 8
$sectionValues[$i] = $section[$i][1]
Next
Local $profileNames = _getNames()
$index = _ArraySearch($profileNames, $profileName)
If $index <> -1 Then
MsgBox($MB_ICONWARNING, "Warning!", "Profile name already exists!")
$lv_startEditing = 1
Return
EndIf
$lv_newItem = 0
$ret = IniWriteSection( "profiles.ini", $iniName, $section, 0 )
If $ret = 0 Then
_setStatus("An error occurred while saving the profile properties", 1)
EndIf
$profilelist[0][0] = $profilelist[0][0]+1
_ArrayAdd( $profilelist, $profileName )
$profilelist[$profilelist[0][0]][1] = $sectionValues
EndFunc
Func _save()
$profileName = StringReplace( GUICtrlRead(GUICtrlRead($list_profiles)), "|", "")
Local $section[9][2]
$section[0][0] = $propertyFormat[0]
$section[0][1] = _StateToStr( $radio_IpAuto )
$section[1][0] = $propertyFormat[1]
$section[1][1] = _ctrlGetIP( $ip_Ip )
$section[2][0] = $propertyFormat[2]
$section[2][1] = _ctrlGetIP( $ip_Subnet )
$section[3][0] = $propertyFormat[3]
$section[3][1] = _ctrlGetIP( $ip_Gateway )
$section[4][0] = $propertyFormat[4]
$section[4][1] = _StateToStr( $radio_DnsAuto )
$section[5][0] = $propertyFormat[5]
$section[5][1] = _ctrlGetIP( $ip_DnsPri )
$section[6][0] = $propertyFormat[6]
$section[6][1] = _ctrlGetIP( $ip_DnsAlt )
$adapName = StringReplace(GUICtrlRead($combo_adapters), "[", "{lb}")
$adapName = StringReplace($adapName, "]", "{rb}")
$section[7][0] = $propertyFormat[7]
$section[7][1] = _StateToStr( $ck_dnsReg )
$section[8][0] = $propertyFormat[8]
$section[8][1] = $adapName
$iniName = StringReplace($profileName, "[", "{lb}")
$iniName = StringReplace($iniName, "]", "{rb}")
$ret = IniWriteSection( "profiles.ini", $iniName, $section, 0 )
If $ret = 0 Then
_setStatus("An error occurred while saving the profile properties", 1)
EndIf
Local $sectionValues[9]
for $i=0 to 8
$sectionValues[$i] = $section[$i][1]
Next
Local $profileNames[1]
_ArrayDelete($profileNames, 0)
If IsArray($profilelist) Then
For $i=1 to $profilelist[0][0]
_ArrayAdd($profileNames, $profilelist[$i][0])
Next
$index = _ArraySearch($profileNames, $profileName)+1
If $index <> -1 Then
$profilelist[$index][1] = $sectionValues
Else
$profilelist[0][0] = $profilelist[0][0]+1
_ArrayAdd( $profilelist, $profileName )
$profilelist[$profilelist[0][0]][1] = $sectionValues
EndIf
Else
_setStatus("An error occurred while saving the profile", 1)
Return 1
EndIf
EndFunc
Func _refresh($init=0)
_loadProfiles()
_updateProfileList()
_updateCurrent()
If $pIdle Then
IF not $init OR($init and not $showWarning) Then
_setStatus("Ready")
EndIf
_GUICtrlToolbar_EnableButton($hToolbar, $tb_apply, True)
EndIf
EndFunc
Func _setProperties($init=0, $profileName="")
Local $profileNames[1]
_ArrayDelete($profileNames, 0)
If IsArray($profilelist) Then
if NOT $init Then
$profileName = StringReplace( GUICtrlRead(GUICtrlRead($list_profiles)), "|", "")
EndIf
For $i=1 to $profilelist[0][0]
_ArrayAdd($profileNames, $profilelist[$i][0])
Next
$index = _ArraySearch($profileNames, $profileName)+1
If $index <> -1 Then
GUICtrlSetState( $radio_IpMan, $GUI_CHECKED )
GUICtrlSetState( $radio_IpAuto, _StrToState(($profilelist[$index][1])[0] ) )
_ctrlSetIP($ip_Ip,($profilelist[$index][1])[1])
_ctrlSetIP($ip_Subnet,($profilelist[$index][1])[2])
_ctrlSetIP($ip_Gateway,($profilelist[$index][1])[3])
GUICtrlSetState( $radio_DnsMan, $GUI_CHECKED )
GUICtrlSetState( $radio_DnsAuto, _StrToState(($profilelist[$index][1])[4] ) )
_ctrlSetIP($ip_DnsPri,($profilelist[$index][1])[5])
_ctrlSetIP($ip_DnsAlt,($profilelist[$index][1])[6])
GUICtrlSetState( $ck_dnsReg, _StrToState(($profilelist[$index][1])[7] ) )
If($profilelist[$index][1])[8] <> "" and($options[6][1] = 1 OR $options[6][1] = "true") Then
$adapterIndex = _ArraySearch($adapters,($profilelist[$index][1])[8])
IF $adapterIndex <> -1 Then
ControlCommand($hgui, "", $combo_adapters, "SelectString",($profilelist[$index][1])[8] )
EndIf
EndIf
_radios()
Else
_setStatus("An error occurred while setting the profile properties", 1)
Return 1
EndIf
Else
_setStatus("An error occurred while retrieving the profile properties", 1)
Return 1
EndIf
EndFunc
Func _saveOptions()
$options[2][1] = _StateToStr($ck_startinTray)
$options[1][1] = _StateToStr($ck_mintoTray)
$options[6][1] = _StateToStr($ck_saveAdapter)
IniWriteSection("profiles.ini", "options", $options, 0)
_onExitSettings()
EndFunc
Func _ctrlGetIP($id)
$ret = _GUICtrlIpAddress_Get( $id )
If $ret = "0.0.0.0" Then
$ret = ""
EndIf
Return $ret
EndFunc
Func _ctrlSetIP($id, $ip)
If $ip <> "" Then
_GUICtrlIpAddress_Set( $id, $ip )
Else
_GUICtrlIpAddress_ClearAddress( $id )
EndIf
EndFunc
Func _StrToState($str)
If $str = "true" or $str = "1" Then
return $GUI_CHECKED
Else
return $GUI_UNCHECKED
EndIf
EndFunc
Func _StateToStr($id)
$ret = GUICtrlRead($id)
If $ret = $GUI_CHECKED Then
return "true"
Else
return "false"
EndIf
EndFunc
Func _loadProfiles()
Local $pname = "profiles.ini"
Local $aArray[1][2] = [[0,0]]
$profilelist = $aArray
If Not FileExists( $pname ) Then
_setStatus("Profiles.ini file not found - A new file will be created", 1)
Return 1
EndIf
$names = IniReadSectionNames( $pname )
If @error Then
_setStatus("Error reading profiles.ini", 1)
Return 1
EndIf
$currentindex = 0
For $i = 1 to $names[0]
$thisName = StringReplace($names[$i], "{lb}", "[")
$thisName = StringReplace($thisName, "{rb}", "]")
$thisSection = IniReadSection($pname, $names[$i])
If @error Then
ContinueLoop
EndIf
If $thisName <> "Options" Then
$profilelist[0][0] = $profilelist[0][0]+1
$currentindex = $profilelist[0][0]
_ArrayAdd( $profilelist, $thisName & "|")
EndIf
Local $thisProfile[9]
For $j = 1 to $thisSection[0][0]
If $thisName = "Options" Then
$index = _ArraySearch($options, $thisSection[$j][0])
If $index <> -1 Then
If $thisSection[$j][0] = "StartupAdapter" Then
$newName = StringReplace($thisSection[$j][1], "{lb}", "[")
$newName = StringReplace($newName, "{rb}", "]")
$options[$index][1] = $newName
Else
$options[$index][1] = $thisSection[$j][1]
EndIf
EndIf
Else
$index = _ArraySearch($propertyFormat, $thisSection[$j][0])
If $index <> -1 Then
$thisProfile[$index] = $thisSection[$j][1]
EndIf
EndIf
Next
$profilelist[$currentindex][1] = $thisProfile
Next
EndFunc
Func _updateProfileList()
$ap_names = _getNames()
$lv_count = ControlListView( $hgui, "", $list_profiles, "GetItemCount" )
Local $diff = 0
If UBound($ap_names) <> $lv_count Then $diff = 1
If not $diff then
For $i=0 to $lv_count-1
If $ap_names[$i] <> ControlListView( $hgui, "", $list_profiles, "GetText", $i ) Then
$diff = 1
ExitLoop
EndIf
Next
EndIf
If not $diff Then Return
_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($list_profiles))
If IsArray($profilelist) Then
For $i=1 to $profilelist[0][0]
GUICtrlCreateListViewItem( $profilelist[$i][0], $list_profiles )
GUICtrlSetOnEvent( -1, "_onSelect" )
Next
Else
_setStatus("An error occurred while building the profile list", 1)
Return 1
EndIf
EndFunc
Func _updateCurrent($init=0, $selected_adapter="")
If NOT $init Then
$selected_adapter = GUICtrlRead($combo_adapters)
EndIf
Local $index = _ArraySearch($adapters, $selected_adapter)
If $index <> -1 Then
GUICtrlSetData( $lDescription, $adapters[$index][2] )
GUICtrlSetData( $lMac, "MAC Address: " & $adapters[$index][1] )
Else
GUICtrlSetData( $lDescription, "! Adapter not found !" )
GUICtrlSetData( $lMac, "" )
EndIf
$props = _getIPs($selected_adapter)
ControlSetText($hgui, "", $label_CurrentIp, $props[0] )
ControlSetText($hgui, "", $label_CurrentSubnet, $props[1] )
ControlSetText($hgui, "", $label_CurrentGateway, $props[2] )
ControlSetText($hgui, "", $label_CurrentDnsPri, $props[3] )
ControlSetText($hgui, "", $label_CurrentDnsAlt, $props[4] )
ControlSetText($hgui, "", $label_CurrentDhcp, $props[5] )
ControlSetText($hgui, "", $label_CurrentAdapterState, $props[6] )
If $props[6] = "Disabled" Then
GUICtrlSetData($disableitem, "Enable adapter")
Else
GUICtrlSetData($disableitem, "Disable adapter")
EndIf
EndFunc
Func _filterProfiles()
Local $aArray[1] = [0]
_ArrayDelete( $aArray, 0 )
$strPattern = GUICtrlRead( $input_filter )
_GUICtrlListView_DeleteAllItems( $list_profiles )
$aNames = _getNames()
if $strPattern <> "" Then
$pattern = '(?i)(?U)' & StringReplace( $strPattern, "*", ".*")
for $k=0 to $profilelist[0][0]-1
$matched = StringRegExp($aNames[$k], $pattern, $STR_REGEXPMATCH )
If $matched = 1 Then
_ArrayAdd( $aArray, $aNames[$k] )
EndIf
Next
Else
$aArray = $aNames
EndIf
For $i=0 to UBound($aArray)-1
_GUICtrlListView_AddItem( $list_profiles, $aArray[$i] )
Next
EndFunc
Func _SendToTray()
GUISetState(@SW_MINIMIZE, $hGUI)
GUISetState(@SW_HIDE, $hGUI)
TrayItemSetText($RestoreItem, "Restore" )
if $tray_tip = 0 Then
TrayTip("", "Simple IP Config is still running.", 1)
$tray_tip = 1
EndIf
EndFunc
Func _minimize()
If $options[1][1] = 1 OR $options[1][1] = "true" Then
_SendToTray()
Else
GUISetState(@SW_MINIMIZE, $hGUI)
EndIf
EndFunc
Func _maximize()
GUISetState(@SW_RESTORE, $hGUI)
GUISetState(@SW_SHOW, $hGUI)
GUISetState(@SW_RESTORE, $hGUI)
GUISetState(@SW_SHOWNOACTIVATE, $hTool)
GUISetState(@SW_SHOWNOACTIVATE, $hTool2)
TrayItemSetText( $RestoreItem, "Hide" )
EndFunc
Func _getNames()
Local $profileNames[1]
If IsArray($profilelist) Then
_ArrayDelete($profileNames, 0)
For $i=1 to $profilelist[0][0]
_ArrayAdd($profileNames, $profilelist[$i][0])
Next
EndIf
Return $profileNames
EndFunc
Func _setStatus($sMessage, $bError=0, $bTiming=0)
If NOT $bTiming Then
$sStatusMessage = $sMessage
EndIf
IF $bError Then
$showWarning = 1
GUICtrlSetData($statuserror, $sMessage)
GUICtrlSetState($statuserror, $GUI_SHOW)
GUICtrlSetState($statustext, $GUI_HIDE)
GUICtrlSetState($wgraphic, $GUI_SHOW)
Else
GUICtrlSetData($statustext, $sMessage)
GUICtrlSetState($statustext, $GUI_SHOW)
GUICtrlSetState($statuserror, $GUI_HIDE)
GUICtrlSetState($wgraphic, $GUI_HIDE)
_onExitStatus()
EndIf
EndFunc
Func _asyncNewCmd($sCmd, $sMessage="", $addToQueue=-1)
If not ProcessExists($iPID ) Then
$sStdOut = ""
$sStdErr = ""
_GUICtrlToolbar_EnableButton($hToolbar, $tb_apply, False)
ConsoleWrite($sCmd&@CRLF)
$showWarning = 0
$iPID = Run(@ComSpec & " /k " & $sCmd & "& echo simple ip config cmd done", "", @SW_HIDE, $STDIN_CHILD+$STDERR_MERGED)
$pRuntime = TimerInit()
$pIdle = 0
If $sMessage <> "" Then
_setStatus($sMessage)
EndIf
ElseIf $addToQueue Then
_asyncAddToQueue($sCmd, $sMessage)
EndIf
EndFunc
Func _asyncAddToQueue($sCmd, $sMessage)
$pQueue[0][0] = $pQueue[0][0] + 1
_ArrayAdd($pQueue, $sCmd&"|"&$sMessage)
EndFunc
Func _asyncCheckQueue()
If $pQueue[0][0] > 0 Then
_asyncNewCmd($pQueue[1][0], $pQueue[1][1])
_ArrayDelete($pQueue, 1)
$pQueue[0][0] = $pQueue[0][0] -1
EndIf
EndFunc
Func _asyncClearQueue()
If $pQueue[0][0] > 0 Then
_ArrayDelete($pQueue, "1-"&$pQueue[0][0])
$pQueue[0][0] = 0
EndIf
EndFunc
Func _asyncProcess()
Local $dTimeout
$pExists = ProcessExists($iPID )
If $pExists Then
$sStdOut = $sStdOut & StdoutRead($iPID)
$sStdErr = $sStdErr & StderrRead($iPID)
if StringInStr($sStdOut, "simple ip config cmd done") Then
$sStdOut = StringLeft($sStdOut, StringLen($sStdOut)-33)
ProcessClose($iPID)
$pDone = 1
$iPID = -1
ElseIf TimerDiff($pRuntime) > 10000 Then
$dTimeout = 1
$sStdOut = ""
ProcessClose($iPID)
$pDone = 1
$iPID = -1
ConsoleWrite("Timeout" & @CRLF)
Else
$countdown = 10 - Round(TimerDiff($pRuntime)/1000)
if $countdown <=5 Then
_setStatus($sStatusMessage & "  " & "Timeout in " & $countdown & " seconds",0,1)
EndIf
EndIf
Else
$pIdle = 1
EndIf
If $pDone Then
$pDone = 0
If $dTimeout Then
$dTimeout = 0
_setStatus("Action timed out!  Command Aborted.", 1)
_asyncClearQueue()
_GUICtrlToolbar_EnableButton($hToolbar, $tb_apply, True)
Else
If StringInStr($sStdOut, "failed") Then
_setStatus(StringReplace($sStdOut, @CRLF, " "), 1)
IF $pQueue[0][0] = 0 Then
_GUICtrlToolbar_EnableButton($hToolbar, $tb_apply, True)
EndIf
Else
IF $pQueue[0][0] = 0 Then
_GUICtrlToolbar_EnableButton($hToolbar, $tb_apply, True)
If not $showWarning Then _setStatus("Ready")
EndIf
EndIf
EndIf
_updateCurrent()
_asyncCheckQueue()
EndIf
EndFunc
Func _DomainComputerBelongs($strComputer = "localhost")
$Domain = ''
If $screenshot Then
$Domain = "Domain: ________"
return $Domain
EndIf
If Not IsObj($objWMI) Then Return SetError(1, 0, '')
$colItems = $objWMI.ExecQuery("SELECT * FROM Win32_ComputerSystem", "WQL", $wbemFlagReturnImmediately + $wbemFlagForwardOnly)
If IsObj($colItems) then
For $objItem In $colItems
If $objItem.PartOfDomain Then
$Domain = "Domain: " & $objItem.Domain
Else
$Domain = "Workgroup: " & $objItem.Domain
EndIf
Next
Endif
Return $Domain
EndFunc
Func _MoveToSubnet()
if WinActive($hgui) and _WinAPI_GetAncestor(_WinAPI_GetFocus(),$GA_PARENT ) = ControlGetHandle($hgui,"", $ip_Subnet) Then
If _GUICtrlIpAddress_Get($ip_Subnet) = "0.0.0.0" Then
_GUICtrlIpAddress_Set($ip_Subnet, "255.255.255.0")
EndIf
EndIf
$movetosubnet = 0
EndFunc
Func _GUICtrlIpAddress_SetFontByHeight($hWnd, $sFaceName = "Arial", $iFontSize = 12, $iFontWeight = 400, $bFontItalic = False)
Local $hDC = _WinAPI_GetDC(0)
Local $iHeight = $iFontSize
_WinAPI_ReleaseDC(0, $hDC)
Local $tFont = DllStructCreate($tagLOGFONT)
DllStructSetData($tFont, "Height", $iHeight)
DllStructSetData($tFont, "Weight", $iFontWeight)
DllStructSetData($tFont, "Italic", $bFontItalic)
DllStructSetData($tFont, "Underline", False)
DllStructSetData($tFont, "Strikeout", False)
DllStructSetData($tFont, "Quality", $__IPADDRESSCONSTANT_PROOF_QUALITY)
DllStructSetData($tFont, "FaceName", $sFaceName)
Local $hFont = _WinAPI_CreateFontIndirect($tFont)
_WinAPI_SetFont($hWnd, $hFont)
EndFunc
Func _onExit()
_GDIPlus_Shutdown()
If NOT BITAND(WinGetState($hgui), $WIN_STATE_MINIMIZED) Then
ConsoleWrite("saving..."&@CRLF)
$currentWinPos = WinGetPos($winName & " " & $winVersion)
$options[8][1] = $currentWinPos[0]
$options[9][1] = $currentWinPos[1]
IniWriteSection("profiles.ini", "options", $options, 0)
EndIf
Exit
EndFunc
Func _onExitAbout()
_ExitChild($AboutChild)
EndFunc
Func _onExitSettings()
_ExitChild($settingsChild)
EndFunc
Func _onExitChangelog()
_ExitChild($changeLogChild)
EndFunc
Func _onExitBlacklist()
_ExitChild($blacklistChild)
EndFunc
Func _onExitBlacklistOk()
$guiState = WinGetState( $winname & " " & $winversion )
$newBlacklist = StringReplace(GUICtrlRead($blacklistEdit), @CRLF, "|")
$newBlacklist = StringReplace($newBlacklist, "[", "{lb}")
$newBlacklist = StringReplace($newBlacklist, "]", "{rb}")
$options[7][1] = $newBlacklist
IniWrite("profiles.ini", "options", $options[7][0], $options[7][1])
_onExitBlacklist()
_updateCombo()
EndFunc
Func _onExitStatus()
_ExitChild($statusChild)
EndFunc
Func _OnTrayClick()
If TrayItemGetText( $RestoreItem ) = "Restore" Then
_maximize()
Else
_SendToTray()
EndIf
EndFunc
Func _OnRestore()
If TrayItemGetText( $RestoreItem ) = "Restore" Then
_maximize()
Else
_SendToTray()
EndIf
EndFunc
Func _onBlacklist()
_blacklist()
EndFunc
Func _onBlacklistAdd()
_blacklistAdd()
EndFunc
Func _onRadio()
_radios()
EndFunc
Func _onSelect()
_setProperties()
EndFunc
Func _onApply()
_apply()
EndFunc
Func _onArrangeAz()
_arrange()
EndFunc
Func _onArrangeZa()
_arrange(1)
EndFunc
Func _onRename()
If NOT _ctrlHasFocus($list_profiles) Then
Return
EndIf
$Index = _GUICtrlListView_GetSelectedIndices($list_profiles)
_GUICtrlListView_EditLabel( ControlGetHandle($hgui, "", $list_profiles), $Index )
EndFunc
Func _onNewItem()
$newname = "New Item"
Local $profileNames = _getNames()
Local $i = 1
while _ArraySearch($profileNames, $newname) <> -1
$newname = "New Item " & $i
$i = $i + 1
WEnd
ControlFocus( $hgui, "", $list_profiles)
GUICtrlCreateListViewItem( $newname, $list_profiles )
GUICtrlSetOnEvent( -1, "_onSelect" )
$lv_newItem = 1
$index = ControlListView($hgui, "", $list_profiles, "GetItemCount")
ControlListView($hgui, "", $list_profiles, "Select", $index-1 )
_GUICtrlListView_EditLabel( ControlGetHandle($hgui, "", $list_profiles), $index-1 )
EndFunc
Func _onSave()
_save()
EndFunc
Func _onDelete()
_delete()
EndFunc
Func _onClear()
_clear()
EndFunc
Func _onRefresh()
$showWarning = 0
$index = ControlListView($hgui, "", $list_profiles, "GetSelected")
_refresh()
ControlListView($hgui, "", $list_profiles, "Select", $index)
EndFunc
Func _onLvDel()
if _ctrlHasFocus($list_profiles) Then
_delete()
Else
GUISetAccelerators(0)
Send("{DEL}")
GUISetAccelerators($aAccelKeys)
EndIf
EndFunc
Func _onLvUp()
if _ctrlHasFocus($list_profiles) Then
$index = ControlListView($hgui, "", $list_profiles, "GetSelected")
ControlListView($hgui, "", $list_profiles, "Select", $index-1)
_setProperties()
Else
GUISetAccelerators(0)
Send("{Up}")
GUISetAccelerators($aAccelKeys)
EndIf
EndFunc
Func _onLvDown()
if _ctrlHasFocus($list_profiles) Then
$index = ControlListView($hgui, "", $list_profiles, "GetSelected")
ControlListView($hgui, "", $list_profiles, "Select", $index+1)
_setProperties()
Else
GUISetAccelerators(0)
Send("{Down}")
GUISetAccelerators($aAccelKeys)
EndIf
EndFunc
Func _onLvEnter()
If Not $lv_editing Then
_apply()
Else
GUISetAccelerators(0)
Send("{ENTER}")
GUISetAccelerators($aAccelKeys)
EndIf
EndFunc
Func _onTray()
_SendToTray()
EndFunc
Func _onPull()
_Pull()
EndFunc
Func _onDisable()
_disable()
EndFunc
Func _onRelease()
_releaseDhcp()
EndFunc
Func _onRenew()
_renewDhcp()
EndFunc
Func _onCycle()
_cycleDhcp()
EndFunc
Func _onSettings()
_settings()
EndFunc
Func _onHelp()
EndFunc
Func _onChangelog()
_changeLog()
EndFunc
Func _onAbout()
_about()
EndFunc
Func _onFilter()
_filterProfiles()
EndFunc
Func _OnCombo()
_updateCurrent()
$adap = GUICtrlRead($combo_adapters)
$iniAdap = StringReplace($adap, "[", "{lb}")
$iniAdap = StringReplace($iniAdap, "]", "{rb}")
$ret = IniWrite( "profiles.ini", "options", $options[4][0], $iniAdap )
If $ret = 0 Then
_setStatus("An error occurred while saving the selected adapter", 1)
Else
$options[4][1] = $adap
EndIf
EndFunc
Func _OnToolbarButton()
$ID = GUICtrlRead($ToolbarIDs)
Switch $ID
Case $tb_apply
_onApply()
Case $tb_refresh
_onRefresh()
Case $tb_add
_onNewItem()
Case $tb_save
_onSave()
Case $tb_delete
_onDelete()
Case $tb_clear
_onClear()
Case Else
EndSwitch
EndFunc
Func _OnToolbar2Button()
$ID = GUICtrlRead($Toolbar2IDs)
Switch $ID
Case $tb_settings
_onSettings()
Case $tb_tray
_onTray()
Case Else
EndSwitch
EndFunc
Func _iconLink()
ShellExecute('http://www.aha-soft.com/')
GUICtrlSetColor(@GUI_CtrlId,0x551A8B)
EndFunc
Func WM_COMMAND($hWnd, $iMsg, $wParam, $lParam)
Local $ID = BitAND($wParam, 0xFFFF)
Local $iIDFrom = BitAND($wParam, 0x0000FFFF)
Local $iCode = BitShift($wParam, 16)
Switch $hWnd
Case $hTool
Switch $ID
Case $tb_apply To $tb_clear
GUICtrlSendToDummy($ToolbarIDs, $ID)
Case Else
EndSwitch
Case $hTool2
Switch $ID
Case $tb_settings To $tb_tray
GUICtrlSendToDummy($Toolbar2IDs, $ID)
Case Else
EndSwitch
Case Else
If $iCode = $EN_CHANGE Then
Switch $iIDFrom
Case $input_filter
GUICtrlSendToDummy($filter_dummy)
EndSwitch
ElseIf $iCode = $CBN_CLOSEUP Then
Switch $iIDFrom
Case $combo_adapters
GUICtrlSendToDummy($combo_dummy)
EndSwitch
EndIf
EndSwitch
Return $GUI_RUNDEFMSG
EndFunc
Func WM_NOTIFY($hWnd, $iMsg, $wParam, $lParam)
Local $tNMIA = DllStructCreate($tagNMITEMACTIVATE, $lParam)
Local $hTarget = DllStructGetData($tNMIA, 'hWndFrom')
Local $ID = DllStructGetData($tNMIA, 'Code')
$hWndListView = $list_profiles
If Not IsHWnd($list_profiles) Then $hWndListView = GUICtrlGetHandle($list_profiles)
$tNMHDR = DllStructCreate($tagNMHDR, $lParam)
$hWndFrom = HWnd(DllStructGetData($tNMHDR, "hWndFrom"))
$iIDFrom = DllStructGetData($tNMHDR, "IDFrom")
$iCode = DllStructGetData($tNMHDR, "Code")
Switch $hWnd
Case $hTool
Switch $hTarget
Case $hToolbar
Switch $ID
Case $TBN_GETINFOTIPW
Local $tNMTBGIT = DllStructCreate($tagNMHDR & ';ptr Text;int TextMax;int Item;lparam lParam;', $lParam)
Local $Item = DllStructGetData($tNMTBGIT, 'Item')
Local $Text = ''
Switch $Item
Case $tb_apply
$Text = 'Apply'
Case $tb_refresh
$Text = 'Refresh'
Case $tb_add
$Text = 'Create new profile'
Case $tb_save
$Text = 'Save profile'
Case $tb_delete
$Text = 'Delete profile'
Case $tb_clear
$Text = 'Clear entries'
Case Else
EndSwitch
If $Text Then
DllStructSetData(DllStructCreate('wchar[' & DllStructGetData($tNMTBGIT, 'TextMax') & ']', DllStructGetData($tNMTBGIT, 'Text')), 1, $Text)
EndIf
EndSwitch
EndSwitch
Case $hTool2
Switch $hTarget
Case $hToolbar2
Switch $ID
Case $TBN_GETINFOTIPW
Local $tNMTBGIT = DllStructCreate($tagNMHDR & ';ptr Text;int TextMax;int Item;lparam lParam;', $lParam)
Local $Item = DllStructGetData($tNMTBGIT, 'Item')
Local $Text = ''
Switch $Item
Case $tb_settings
$Text = 'Settings'
Case $tb_tray
$Text = 'Send to tray'
Case Else
EndSwitch
If $Text Then
DllStructSetData(DllStructCreate('wchar[' & DllStructGetData($tNMTBGIT, 'TextMax') & ']', DllStructGetData($tNMTBGIT, 'Text')), 1, $Text)
EndIf
EndSwitch
EndSwitch
Case Else
Switch $hWndFrom
Case $hWndListView
Switch $iCode
Case $LVN_BEGINLABELEDITA, $LVN_BEGINLABELEDITW
$lv_editIndex = _GUICtrlListView_GetSelectedIndices($list_profiles)
$lv_oldName = ControlListView($hgui, "", $list_profiles, "GetText", $lv_editIndex )
$lv_editing = 1
$lv_startEditing = 0
$lv_aboutEditing = 0
Return False
Case $LVN_ENDLABELEDITA, $LVN_ENDLABELEDITW
$lv_doneEditing = 1
$lv_editing = 0
$tInfo = DllStructCreate($tagNMLVDISPINFO, $lParam)
If _WinAPI_GetAsyncKeyState($VK_RETURN) == 1 Then
Local $tBuffer = DllStructCreate("char Text[" & DllStructGetData($tInfo, "TextMax") & "]", DllStructGetData($tInfo, "Text"))
If StringLen(DllStructGetData($tBuffer, "Text")) Then
Return True
Else
if $lv_newItem = 1 Then
_GUICtrlListView_DeleteItem(ControlGetHandle($hgui, "", $list_profiles), $lv_editIndex)
$lv_newItem = 0
EndIf
$lv_aboutEditing = 1
EndIf
Else
if $lv_newItem = 1 Then
_GUICtrlListView_DeleteItem(ControlGetHandle($hgui, "", $list_profiles), $lv_editIndex)
$lv_newItem = 0
EndIf
$lv_aboutEditing = 1
EndIf
EndSwitch
Case $ip_Ip
Switch $iCode
Case $IPN_FIELDCHANGED
$movetosubnet = 1
EndSwitch
EndSwitch
EndSwitch
Return $GUI_RUNDEFMSG
EndFunc
Func _GDIPlus_GraphicsGetDPIRatio($iDPIDef = 96)
_GDIPlus_Startup()
Local $hGfx = _GDIPlus_GraphicsCreateFromHWND(0)
If @error Then Return SetError(1, @extended, 0)
Local $aResult
#forcedef $__g_hGDIPDll, $ghGDIPDll
$aResult = DllCall($__g_hGDIPDll, "int", "GdipGetDpiX", "handle", $hGfx, "float*", 0)
If @error Then Return SetError(2, @extended, 0)
Local $iDPI = $aResult[2]
Local $aresults[2] = [$iDPIDef / $iDPI, $iDPI / $iDPIDef]
_GDIPlus_GraphicsDispose($hGfx)
_GDIPlus_Shutdown()
Return $aresults[1]
EndFunc
Func _makeGUI()
$ixCoordMin = _WinAPI_GetSystemMetrics(76)
$iyCoordMin = _WinAPI_GetSystemMetrics(77)
$iFullDesktopWidth = _WinAPI_GetSystemMetrics(78)
$iFullDesktopHeight = _WinAPI_GetSystemMetrics(79)
If $options[8][1] <> "" Then
$xpos = $options[8][1]
If $xpos >($ixCoordMin+$iFullDesktopWidth) Then
$xpos = $iFullDesktopWidth-($guiWidth*$dscale)
ElseIf $xpos < $ixCoordMin Then
$xpos = 1
EndIf
Else
$xpos = @DesktopWidth/2-$guiWidth*$dscale/2
EndIf
If $options[9][1] <> "" Then
$ypos = $options[9][1]
If $ypos >($iyCoordMin+$iFullDesktopHeight) Then
$ypos = $iFullDesktopHeight-($guiHeight*$dscale)
ElseIf $ypos < $iyCoordMin Then
$ypos = 1
EndIf
Else
$ypos = @DesktopHeight/2-$guiHeight*$dscale/2
EndIf
$hgui = GUICreate( $winName & " " & $winVersion, $guiWidth*$dscale, $guiHeight*$dscale, $xpos, $ypos, BITOR($GUI_SS_DEFAULT_GUI,$WS_CLIPCHILDREN), $WS_EX_COMPOSITED )
GUISetBkColor( 0xFFFFFF)
GUISetFont($MyGlobalFontSize, -1, -1, $MyGlobalFontName )
_GDIPlus_Startup()
$strSize = _StringSize("{", $MyGlobalFontSize, 400, 0 , $MyGlobalFontName)
$MyGlobalFontHeight = $strSize[1]
_makeMenu()
_makeToolbar()
_makeStatusbar()
Local $guiSpacer = 0
Local $y = 0
Local $xLeft = $guiSpacer
Local $wLeft = 230*$dscale
Local $xRight = $xLeft + $wLeft
Local $wRight = $guiWidth*$dscale - $wLeft - 2*$guiSpacer
_makeComboSelect("Select Adapter", $xLeft, $tbarHeight*$dscale + $guiSpacer+$y, $wLeft, 88*$dscale)
$hLeft = $tbarHeight*$dscale + $guiSpacer + 88*$dscale+$y
_makeProfileSelect("Profiles", $xLeft, $tbarHeight*$dscale + $guiSpacer + 87*$dscale+$y, $wLeft, $guiHeight*$dscale-$hLeft-$menuHeight-$statusbarHeight*$dscale-$guiSpacer-$footerHeight*$dscale+1*$dscale)
_makeIpProps("Profile IP Properties", $xRight, $tbarHeight*$dscale + $guiSpacer+$y, $wRight, 148*$dscale)
_makeDnsProps("", $xRight, $tbarHeight*$dscale + $guiSpacer + 147*$dscale+$y, $wRight, 130*$dscale)
$hRight = $tbarHeight*$dscale + $guiSpacer + 148*$dscale + 130*$dscale
_makeCurrentProps("Current Adapter Properties", $xRight, $tbarHeight*$dscale + $guiSpacer + 148*$dscale + 129*$dscale, $wRight, $guiHeight*$dscale-$hRight-$menuHeight-$statusbarHeight*$dscale-$guiSpacer-$footerHeight*$dscale+1*$dscale)
_makeFooter()
GUISetOnEvent( $GUI_EVENT_CLOSE, "_onExit")
GUISetOnEvent( $GUI_EVENT_MINIMIZE, "_minimize")
GUISetOnEvent( $GUI_EVENT_RESTORE, "_maximize")
GUISetOnEvent($GUI_EVENT_PRIMARYDOWN, "_clickDn")
GUISetOnEvent($GUI_EVENT_PRIMARYUP, "_clickUp")
GUIRegisterMsg($WM_COMMAND, 'WM_COMMAND')
GUIRegisterMsg($WM_NOTIFY, 'WM_NOTIFY')
$deletedummy = GUICtrlCreateDummy()
GUICtrlSetOnEvent(-1, "_onLvDel")
$aAccelKeys[0][0] = '{ENTER}'
$aAccelKeys[0][1] = $list_profiles
$aAccelKeys[1][0] = '^r'
$aAccelKeys[1][1] = $refreshitem
$aAccelKeys[2][0] = '{F2}'
$aAccelKeys[2][1] = $renameitem
$aAccelKeys[3][0] = '{DEL}'
$aAccelKeys[3][1] = $deletedummy
$aAccelKeys[4][0] = '^s'
$aAccelKeys[4][1] = $saveitem
$aAccelKeys[5][0] = '^n'
$aAccelKeys[5][1] = $newitem
$aAccelKeys[6][0] = '^p'
$aAccelKeys[6][1] = $pullitem
$aAccelKeys[7][0] = '^t'
$aAccelKeys[7][1] = $send2trayitem
$aAccelKeys[8][0] = '{F1}'
$aAccelKeys[8][1] = $helpitem
$aAccelKeys[9][0] = '^c'
$aAccelKeys[9][1] = $clearitem
$aAccelKeys[10][0] = '{UP}'
$aAccelKeys[10][1] = $dummyUp
$aAccelKeys[11][0] = '{DOWN}'
$aAccelKeys[11][1] = $dummyDown
GUISetAccelerators($aAccelKeys)
$RestoreItem = TrayCreateItem("Hide")
TrayItemSetOnEvent(-1, "_OnRestore")
$aboutitem = TrayCreateItem("About")
TrayItemSetOnEvent(-1, "_onAbout")
TrayCreateItem("")
$exititem = TrayCreateItem("Exit")
TrayItemSetOnEvent(-1, "_onExit")
TraySetOnEvent($TRAY_EVENT_PRIMARYDOWN, "_OnTrayClick")
TraySetToolTip($winName )
GUICtrlCreateLabel("",0,0,$guiWidth*$dscale,$guiHeight*$dscale)
GUICtrlSetBkColor(-1,0x666666)
If IsArray($profilelist) Then
If $profilelist[0][0] > 0 Then
$profileName = $profilelist[1][0]
_setProperties(1,$profileName)
EndIf
EndIf
If $options[2][1] <> "1" and $options[2][1] <> "true" Then
GUISetState(@SW_SHOW, $hgui)
GUISetState(@SW_SHOWNOACTIVATE, $hTool)
GUISetState(@SW_SHOWNOACTIVATE, $hTool2)
GUISetState(@SW_SHOW, $hgui)
GUISetState(@SW_SHOWNOACTIVATE, $hTool)
GUISetState(@SW_SHOWNOACTIVATE, $hTool2)
Else
TrayItemSetText( $RestoreItem, "Restore" )
EndIf
$prevWinPos = WinGetPos($winName & " " & $winVersion)
EndFunc
Func _makeFooter()
$x = 0
$y = $guiheight*$dscale - $statusbarHeight*$dscale - $footerHeight*$dscale - $menuHeight
$w = $guiWidth*$dscale
$h = $footerHeight*$dscale
GUICtrlCreateLabel("", $x, $y, $w, 1)
GUICtrlSetBkColor(-1, 0x404040)
If $screenshot Then
$computer = GUICtrlCreateLabel("Computer Name: ________", $x+3, $y+2, $w, $h)
Else
$computer = GUICtrlCreateLabel("Computer Name: " & @ComputerName, $x+3, $y+2, $w, $h)
EndIf
GUICtrlSetBkColor($computer, $GUI_BKCOLOR_TRANSPARENT)
_setFont($computer, 8, -1, 0xFFFFFF)
If @LogonDomain <> "" Then
$domain = GUICtrlCreateLabel("", $x, $y+2, $w-3, $h, $SS_RIGHT)
GUICtrlSetBkColor($domain, $GUI_BKCOLOR_TRANSPARENT)
_setFont($domain, 8, -1, 0xFFFFFF)
EndIf
EndFunc
Func _makeStatusbar()
$y = $guiHeight*$dscale - $statusbarHeight*$dscale - $menuHeight
$x = 0
$w = $guiWidth*$dscale
$h = $statusbarHeight*$dscale
$wgraphic = GUICtrlCreatePic("", $w-20, $y+2*$dscale, 16, 16)
_memoryToPic($wgraphic, $pngWarning)
GUICtrlSetOnEvent(-1, "_statusPopup")
GUICtrlSetState($wgraphic, $GUI_HIDE)
GUICtrlSetCursor($wgraphic, 0)
$statustext = GUICtrlCreateLabel("Ready", $x+3, $y+3, $w-2, $h-2)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
$statuserror = GUICtrlCreateLabel("", $x+3, $y+3, $w-2, $h-2)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
GUICtrlSetOnEvent(-1, "_statusPopup")
GUICtrlSetCursor(-1, 0)
GUICtrlSetState($statuserror, $GUI_HIDE)
GUICtrlCreateLabel("", $x, $y+1, $w, 1)
GUICtrlSetBkColor(-1, 0xFFFFFF)
GUICtrlCreateLabel("", $x, $y, $w, 1)
GUICtrlSetBkColor(-1, 0x404040)
GUICtrlCreateLabel("", $x, $y, $w, $h)
GUICtrlSetBkColor(-1, _WinAPI_GetSysColor($COLOR_MENUBAR ) )
EndFunc
Func _makeMenu()
$filemenu = GUICtrlCreateMenu("&File")
$saveitem = GUICtrlCreateMenuItem("Apply profile" & @TAB & "Enter", $filemenu)
GUICtrlSetOnEvent(-1, "_onApply")
GUICtrlCreateMenuItem("", $filemenu)
$renameitem = GUICtrlCreateMenuItem("Rename" & @TAB & "F2", $filemenu)
GUICtrlSetOnEvent(-1, "_onRename")
$newitem = GUICtrlCreateMenuItem("New" & @TAB & "Ctrl+n", $filemenu)
GUICtrlSetOnEvent(-1, "_onNewItem")
$saveitem = GUICtrlCreateMenuItem("Save" & @TAB & "Ctrl+s", $filemenu)
GUICtrlSetOnEvent(-1, "_onSave")
$deleteitem = GUICtrlCreateMenuItem("Delete" & @TAB & "Del", $filemenu)
GUICtrlSetOnEvent(-1, "_onDelete")
$clearitem = GUICtrlCreateMenuItem("Clear entries" & @TAB & "Ctrl+c", $filemenu)
GUICtrlSetOnEvent(-1, "_onClear")
GUICtrlCreateMenuItem("", $filemenu)
$exititem = GUICtrlCreateMenuItem("Exit" & @TAB & "Esc", $filemenu)
GUICtrlSetOnEvent(-1, "_onExit")
$viewmenu = GUICtrlCreateMenu("View")
$refreshitem = GUICtrlCreateMenuItem("Refresh" & @TAB & "Ctrl+r", $viewmenu)
GUICtrlSetOnEvent(-1, "_onRefresh")
$send2trayitem = GUICtrlCreateMenuItem("Send to tray" & @TAB & "Ctrl+t", $viewmenu)
GUICtrlSetOnEvent(-1, "_onTray")
GUICtrlCreateMenuItem("", $viewmenu)
$blacklistitem = GUICtrlCreateMenuItem("Hide adapters", $viewmenu)
GUICtrlSetOnEvent(-1, "_onBlacklist")
$toolsmenu = GUICtrlCreateMenu("Tools")
$pullitem = GUICtrlCreateMenuItem("Pull from adapter" & @TAB & "Ctrl+p", $toolsmenu)
GUICtrlSetOnEvent(-1, "_onPull")
$disableitem = GUICtrlCreateMenuItem("Disable adapter", $toolsmenu)
GUICtrlSetOnEvent(-1, "_onDisable")
GUICtrlCreateMenuItem("", $toolsmenu)
$releaseitem = GUICtrlCreateMenuItem("Release DHCP", $toolsmenu)
GUICtrlSetOnEvent(-1, "_onRelease")
$renewitem = GUICtrlCreateMenuItem("Renew DHCP", $toolsmenu)
GUICtrlSetOnEvent(-1, "_onRenew")
$cycleitem = GUICtrlCreateMenuItem("Release/renew cycle", $toolsmenu)
GUICtrlSetOnEvent(-1, "_onCycle")
GUICtrlCreateMenuItem("", $toolsmenu)
$settingsitem = GUICtrlCreateMenuItem("Settings", $toolsmenu)
GUICtrlSetOnEvent(-1, "_onSettings")
$helpmenu = GUICtrlCreateMenu("Help")
$helpitem = GUICtrlCreateMenuItem("Online Documentation" & @TAB & "F1", $helpmenu)
GUICtrlSetOnEvent(-1, "_onHelp")
GUICtrlCreateMenuItem("", $helpmenu)
$changelogitem = GUICtrlCreateMenuItem("Show Change Log", $helpmenu)
GUICtrlSetOnEvent(-1, "_onChangelog")
$infoitem = GUICtrlCreateMenuItem("About Simple IP Config", $helpmenu)
GUICtrlSetOnEvent(-1, "_onAbout")
$menuHeight = _WinAPI_GetSystemMetrics($SM_CYMENU)
$LCaptionBorder = WinGetPos( $hGUI )
$captionHeight = _WinAPI_GetSystemMetrics($SM_CYSIZE)
EndFunc
Func _makeCurrentProps($label, $x, $y, $w, $h)
Local $headingHeight = _makeHeading($label, $x+1, $y+1, $w-2, -1, 0x0782FD, 0.95)
Local $bkcolor = 0xEEEEEE
$label_CurrIp = GUICtrlCreateLabel( "IP Address:", $x+8*$dscale, $y+$headingHeight+8*$dscale)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
GUICtrlSetColor(-1, 0x444444)
$label_CurrentIp = GUICtrlCreateInput( "000.000.000.000", $x+$w-125*$dscale-8*$dscale, $y+$headingHeight+8*$dscale, 125*$dscale, 15*$dscale, BITOR($ES_READONLY,$SS_CENTER), $WS_EX_TOOLWINDOW)
GUICtrlSetBkColor(-1, $bkcolor)
GUICtrlSetColor(-1, 0x444444)
$label_CurrSubnet = GUICtrlCreateLabel( "Subnet Mask:", $x+8*$dscale, $y+$headingHeight+25*$dscale)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
GUICtrlSetColor(-1, 0x444444)
$label_CurrentSubnet = GUICtrlCreateInput( "000.000.000.000", $x+$w-125*$dscale-8*$dscale, $y+$headingHeight+25*$dscale, 125*$dscale, 15*$dscale, BITOR($ES_READONLY,$SS_CENTER), $WS_EX_TOOLWINDOW)
GUICtrlSetBkColor(-1, $bkcolor)
GUICtrlSetColor(-1, 0x444444)
$label_CurrGateway = GUICtrlCreateLabel( "Gateway:", $x+8*$dscale, $y+$headingHeight+42*$dscale)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
GUICtrlSetColor(-1, 0x444444)
$label_CurrentGateway = GUICtrlCreateInput( "000.000.000.000", $x+$w-125*$dscale-8*$dscale, $y+$headingHeight+42*$dscale, 125*$dscale, 15*$dscale, BITOR($ES_READONLY,$SS_CENTER), $WS_EX_TOOLWINDOW)
GUICtrlSetBkColor(-1, $bkcolor)
GUICtrlSetColor(-1, 0x444444)
$label_sep1 = GUICtrlCreateLabel( "", $x+1, $y+$headingHeight+62*$dscale, $w-2, 1)
GUICtrlSetBkColor(-1, 0x404040)
$label_CurrDnsPri = GUICtrlCreateLabel( "Preferred DNS Server:", $x+8*$dscale, $y+$headingHeight+67*$dscale)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
GUICtrlSetColor(-1, 0x444444)
$label_CurrentDnsPri = GUICtrlCreateInput( "000.000.000.000", $x+$w-125*$dscale-8*$dscale, $y+$headingHeight+67*$dscale, 125*$dscale, 15*$dscale, BITOR($ES_READONLY,$SS_CENTER), $WS_EX_TOOLWINDOW)
GUICtrlSetBkColor(-1, $bkcolor)
GUICtrlSetColor(-1, 0x444444)
$label_CurrDnsAlt = GUICtrlCreateLabel( "Alternate DNS Server:", $x+8*$dscale, $y+$headingHeight+84*$dscale)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
GUICtrlSetColor(-1, 0x444444)
$label_CurrentDnsAlt = GUICtrlCreateInput( "000.000.000.000", $x+$w-125*$dscale-8*$dscale, $y+$headingHeight+84*$dscale, 125*$dscale, 15*$dscale, BITOR($ES_READONLY,$SS_CENTER), $WS_EX_TOOLWINDOW)
GUICtrlSetBkColor(-1, $bkcolor)
GUICtrlSetColor(-1, 0x444444)
$label_sep2 = GUICtrlCreateLabel( "", $x+1, $y+$headingHeight+105*$dscale, $w-2, 1)
GUICtrlSetBkColor(-1, 0x404040)
$label_CurrDhcp = GUICtrlCreateLabel( "DHCP Server:", $x+8*$dscale, $y+$headingHeight+112*$dscale)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
GUICtrlSetColor(-1, 0x444444)
$label_CurrentDhcp = GUICtrlCreateInput( "000.000.000.000", $x+$w-125*$dscale-8*$dscale, $y+$headingHeight+112*$dscale, 125*$dscale, 15*$dscale, BITOR($ES_READONLY,$SS_CENTER), $WS_EX_TOOLWINDOW)
GUICtrlSetBkColor(-1, $bkcolor)
GUICtrlSetColor(-1, 0x444444)
$label_CurrAdapterState = GUICtrlCreateLabel( "Adapter State:", $x+8*$dscale, $y+$headingHeight+129*$dscale)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
GUICtrlSetColor(-1, 0x444444)
$label_CurrentAdapterState = GUICtrlCreateInput( "000.000.000.000", $x+$w-125*$dscale-8*$dscale, $y+$headingHeight+129*$dscale, 125*$dscale, 15*$dscale, BITOR($ES_READONLY,$SS_CENTER), $WS_EX_TOOLWINDOW)
GUICtrlSetBkColor(-1, $bkcolor)
GUICtrlSetColor(-1, 0x444444)
_makeBox($x, $y, $w, $h, $bkcolor)
EndFunc
Func _makeDnsProps($label, $x, $y, $w, $h)
Local $headingHeight = _makeHeading($label, $x+1, $y+1, $w-2, 5, 0x0782FD, 0.95)
GUIStartGroup()
$radio_DnsAuto = GUICtrlCreateRadio( "Automatically Set DNS Address", $x+8*$dscale, $y+$headingHeight+4*$dscale, $w-16*$dscale, 20*$dscale)
GUICtrlSetBkColor(-1, 0xFFFFFF)
GUICtrlSetOnEvent(-1, "_onRadio")
$radio_DnsMan = GUICtrlCreateRadio( "Manually Set DNS Address", $x+8*$dscale, $y+$headingHeight+23*$dscale, $w-16*$dscale, 20*$dscale)
GUICtrlSetBkColor(-1, 0xFFFFFF)
GUICtrlSetOnEvent(-1, "_onRadio")
GUICtrlSetState(-1, $GUI_CHECKED)
$label_DnsPri = GUICtrlCreateLabel( "Preferred DNS Server:", $x+8*$dscale, $y+$headingHeight+51*$dscale)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
$ip_DnsPri = _GUICtrlIpAddress_Create( $hGUI, $x+$w-135*$dscale-8*$dscale, $y+$headingHeight+48*$dscale, 135*$dscale, 22*$dscale )
_GUICtrlIpAddress_SetFontByHeight( $ip_DnsPri, $MyGlobalFontName, $MyGlobalFontHeight)
$label_DnsAlt = GUICtrlCreateLabel( "Alternate DNS Server:", $x+8*$dscale, $y+$headingHeight+77*$dscale)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
$ip_DnsAlt = _GUICtrlIpAddress_Create( $hGUI, $x+$w-135*$dscale-8*$dscale, $y+$headingHeight+74*$dscale, 135*$dscale, 22*$dscale )
_GUICtrlIpAddress_SetFontByHeight( $ip_DnsAlt, $MyGlobalFontName, $MyGlobalFontHeight)
$ck_dnsReg = GUICtrlCreateCheckbox("Register Addresses", $x+8*$dscale, $y+$h-19*$dscale, -1, 15*$dscale)
GUICtrlSetBkColor(-1,0xFFFFFF)
GUICtrlSetFont(-1, 8.5)
_makeBox($x, $y, $w, $h)
EndFunc
Func _makeIpProps($label, $x, $y, $w, $h)
Local $headingHeight = _makeHeading($label, $x+1, $y+1, $w-2, -1, 0x0782FD, 0.95)
GUIStartGroup()
$radio_IpAuto = GUICtrlCreateRadio( "Automatically Set IP Address", $x+8*$dscale, $y+$headingHeight+4*$dscale, $w-16*$dscale, 20*$dscale)
GUICtrlSetBkColor(-1, 0xFFFFFF)
GUICtrlSetOnEvent(-1, "_onRadio")
$radio_IpMan = GUICtrlCreateRadio( "Manually Set IP Address", $x+8*$dscale, $y+$headingHeight+23*$dscale, $w-16*$dscale, 20*$dscale)
GUICtrlSetBkColor(-1, 0xFFFFFF)
GUICtrlSetOnEvent(-1, "_onRadio")
GUICtrlSetState(-1, $GUI_CHECKED)
$label_ip = GUICtrlCreateLabel( "IP Address:", $x+8*$dscale, $y+$headingHeight+51*$dscale)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
$ip_Ip = _GUICtrlIpAddress_Create( $hGUI, $x+$w-135*$dscale-8*$dscale, $y+$headingHeight+48*$dscale, 135*$dscale, 22*$dscale )
_GUICtrlIpAddress_SetFontByHeight( $ip_Ip, $MyGlobalFontName, $MyGlobalFontHeight)
$label_subnet = GUICtrlCreateLabel( "Subnet Mask:", $x+8*$dscale, $y+$headingHeight+77*$dscale)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
$ip_Subnet = _GUICtrlIpAddress_Create( $hGUI, $x+$w-135*$dscale-8*$dscale, $y+$headingHeight+74*$dscale, 135*$dscale, 22*$dscale )
_GUICtrlIpAddress_SetFontByHeight( $ip_Subnet, $MyGlobalFontName, $MyGlobalFontHeight)
$label_gateway = GUICtrlCreateLabel( "Gateway:", $x+8*$dscale, $y+$headingHeight+103*$dscale)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
$ip_Gateway = _GUICtrlIpAddress_Create( $hGUI, $x+$w-135*$dscale-8*$dscale, $y+$headingHeight+100*$dscale, 135*$dscale, 22*$dscale )
_GUICtrlIpAddress_SetFontByHeight( $ip_Gateway, $MyGlobalFontName, $MyGlobalFontHeight)
_makeBox($x, $y, $w, $h)
EndFunc
Func _makeProfileSelect($label, $x, $y, $w, $h)
Local $headingHeight = _makeHeading($label, $x+1, $y+1, $w-2, -1, 0x0782FD, 0.95)
$searchgraphic = GUICtrlCreatePic("", $x+5, $y+$headingHeight+3+2*$dscale, 16, 16)
_memoryToPic($searchgraphic, $pngSearch)
$input_filter = GUICtrlCreateInput( "*", $x+12+11, $y+$headingHeight+3+2*$dscale, $w-12-18, 15*$dscale, -1, $WS_EX_TOOLWINDOW)
GUICtrlCreateLabel( "", $x+3, $y+$headingHeight+3, $w-6, 20*$dscale)
GUICtrlSetBkColor(-1, 0xFFFFFF )
GUICtrlCreateLabel( "", $x+2, $y+$headingHeight+2, $w-4, 20*$dscale+2)
GUICtrlSetBkColor(-1, 0x777777 )
$filter_dummy = GUICtrlCreateDummy()
GUICtrlSetOnEvent($filter_dummy, "_onFilter")
$list_profiles = GUICtrlCreateListView( $label, $x+1, $y+$headingHeight+2+20*$dscale+3, $w-2, $h-$headingHeight-3-20*$dscale-3-1, BitOR($GUI_SS_DEFAULT_LISTVIEW, $LVS_NOCOLUMNHEADER, $LVS_EDITLABELS), $WS_EX_TRANSPARENT)
_GUICtrlListView_SetColumnWidth($list_profiles, 0, $w-2-20*$dscale)
_GUICtrlListView_AddItem($list_profiles, "Item1")
GUICtrlSetOnEvent($list_profiles, "_onLvEnter")
$lvcontext = GUICtrlCreateContextMenu($list_profiles)
$lvcon_rename = GUICtrlCreateMenuItem("Rename", $lvcontext)
GUICtrlSetOnEvent( -1, "_onRename")
$lvcon_delete = GUICtrlCreateMenuItem("Delete", $lvcontext)
GUICtrlSetOnEvent( -1, "_onDelete")
GUICtrlCreateMenuItem("", $lvcontext)
$lvcon_arrAz = GUICtrlCreateMenuItem("Sort A->Z", $lvcontext)
GUICtrlSetOnEvent( -1, "_onArrangeAz")
$lvcon_arrZa = GUICtrlCreateMenuItem("Sort Z->A", $lvcontext)
GUICtrlSetOnEvent( -1, "_onArrangeZa")
$dummyUp = GUICtrlCreateDummy()
GUICtrlSetOnEvent(-1, "_onLvUp")
$dummyDown = GUICtrlCreateDummy()
GUICtrlSetOnEvent(-1, "_onLvDown")
_makeBox($x, $y, $w, $h)
EndFunc
Func _makeComboSelect($label, $x, $y, $w, $h)
Local $headingHeight = _makeHeading($label, $x+1, $y+1, $w-2, -1, 0x0782FD, 0.95)
$combo_adapters = GUICtrlCreateCombo( "", $x+8*$dscale, $y + $headingHeight + 8*$dscale, $w-16*$dscale, -1, BitOR($CBS_DROPDOWNlist, $CBS_AUTOHSCROLL, $WS_VSCROLL))
GUICtrlSetOnEvent($combo_adapters, "_OnCombo")
_setFont($combo_adapters, $MyGlobalFontSize)
$lDescription = GUICtrlCreateLabel( "Description", $x+8*$dscale, $y + $headingHeight + 9*$dscale + 26*$dscale, $w-16*$dscale, -1, $SS_LEFTNOWORDWRAP )
_setFont($lDescription, 8.5, $MyGlobalFontBKColor)
$lMac = GUICtrlCreateLabel( "MAC Address: ", $x+8*$dscale, $y + $headingHeight + 9*$dscale + 41*$dscale, $w-16*$dscale, -1, $SS_LEFTNOWORDWRAP )
_setFont($lMac, 8.5, $MyGlobalFontBKColor)
$combo_dummy = GUICtrlCreateDummy()
GUICtrlSetOnEvent(-1, "_onCombo")
_makeBox($x, $y, $w, $h)
EndFunc
Func _makeToolbar()
$tb2_width = $tbarHeight*$dscale / 2 - 4*$dscale
$hTool = GUICreate('', $guiWidth*$dscale-18*$dscale-6,$tbarHeight*$dscale-1, 0, 0, $WS_CHILD, 0, $hGUI)
$hToolbar = _GUICtrlToolbar_Create($hTool, BitOR($BTNS_BUTTON, $BTNS_SHOWTEXT, $TBSTYLE_FLAT, $TBSTYLE_TOOLTIPS), $TBSTYLE_EX_DOUBLEBUFFER)
GUICtrlSetBkColor(-1,GUISetBkColor( 0x888889))
$ToolbarIDs = GUICtrlCreateDummy()
GUICtrlSetOnEvent(-1, "_OnToolbarButton")
$hImageList = _GUIImageList_Create(24, 24, 5, 1, 5)
_GUIImageList_ReplaceIcon($hImageList, -1, _getMemoryAsIcon($pngAccept))
_GUIImageList_ReplaceIcon($hImageList, -1, _getMemoryAsIcon($pngRefresh))
_GUIImageList_ReplaceIcon($hImageList, -1, _getMemoryAsIcon($pngAdd))
_GUIImageList_ReplaceIcon($hImageList, -1, _getMemoryAsIcon($pngSave))
_GUIImageList_ReplaceIcon($hImageList, -1, _getMemoryAsIcon($pngDelete))
_GUIImageList_ReplaceIcon($hImageList, -1, _getMemoryAsIcon($pngEdit))
_GUICtrlToolbar_SetImageList($hToolbar, $hImageList)
_GUICtrlToolbar_AddString($hToolbar, 'Apply')
_GUICtrlToolbar_AddString($hToolbar, 'Refresh')
_GUICtrlToolbar_AddString($hToolbar, 'New')
_GUICtrlToolbar_AddString($hToolbar, 'Save')
_GUICtrlToolbar_AddString($hToolbar, 'Delete')
_GUICtrlToolbar_AddString($hToolbar, 'Clear')
$bbutton = _GUICtrlToolbar_AddButton($hToolbar, $tb_apply, 0, 0)
$bbutton = _GUICtrlToolbar_AddButton($hToolbar, $tb_refresh, 1, 1)
$bbutton = _GUICtrlToolbar_AddButtonSep($hToolbar, 5)
$bbutton = _GUICtrlToolbar_AddButton($hToolbar, $tb_add, 2, 2)
$bbutton = _GUICtrlToolbar_AddButton($hToolbar, $tb_save, 3, 3)
$bbutton = _GUICtrlToolbar_AddButton($hToolbar, $tb_delete, 4, 4)
$bbutton = _GUICtrlToolbar_AddButtonSep($hToolbar, 5)
$bbutton = _GUICtrlToolbar_AddButton($hToolbar, $tb_clear, 5, 5)
_GUICtrlToolbar_SetButtonWidth($hToolbar, 35*$dscale, 65*$dscale)
_GUICtrlToolbar_SetMetrics($hToolbar, 0, 0, 1, 0)
_GUICtrlToolbar_SetIndent($hToolbar, 1)
_GUICtrlToolbar_SetButtonSize($hToolbar, $tbarHeight*$dscale-4*$dscale, 50*$dscale)
GUISwitch($hgui)
$hTool2 = GUICreate('',18*$dscale+6,$tbarHeight*$dscale-1, $guiWidth*$dscale-18*$dscale-6, 0, $WS_CHILD, 0, $hGUI)
$hToolbar2 = _GUICtrlToolbar_Create($hTool2, BitOR($BTNS_BUTTON, $BTNS_SHOWTEXT, $TBSTYLE_FLAT, $TBSTYLE_TOOLTIPS), $TBSTYLE_EX_DOUBLEBUFFER)
GUICtrlSetBkColor(-1,GUISetBkColor( 0x888889))
$Toolbar2IDs = GUICtrlCreateDummy()
GUICtrlSetOnEvent(-1, "_OnToolbar2Button")
$hImageList2 = _GUIImageList_Create(16, 16, 5, 1, 2)
_GUIImageList_ReplaceIcon($hImageList2, -1,_getMemoryAsIcon($pngSettings))
_GUIImageList_ReplaceIcon($hImageList2, -1, _getMemoryAsIcon($pngTray))
_GUICtrlToolbar_SetImageList($hToolbar2, $hImageList2)
_GUICtrlToolbar_SetButtonSize($hToolbar2, 18*$dscale, 18*$dscale)
$bbutton = _GUICtrlToolbar_AddButton($hToolbar2, $tb_settings, 0, 0)
$bbutton = _GUICtrlToolbar_AddButton($hToolbar2, $tb_tray, 1, 1)
_GUICtrlToolbar_SetRows($hToolbar2, 2)
GUISwitch($hgui)
GUICtrlCreateLabel('', 0, $tbarHeight*$dscale, $guiWidth*$dscale, 1)
GUICtrlSetBkColor(-1, 0x101010)
EndFunc
Func _memoryToPic($idPic, $name)
$hBmp = _GDIPlus_BitmapCreateFromMemory(Binary($name),1)
_WinAPI_DeleteObject(GUICtrlSendMsg($idPic, 0x0172, 0, $hBmp))
_WinAPI_DeleteObject($hBmp)
Return 0
EndFunc
Func _getMemoryAsIcon($name)
$Bmp = _GDIPlus_BitmapCreateFromMemory(Binary($name))
$hIcon = _GDIPlus_HICONCreateFromBitmap($Bmp)
_GDIPlus_ImageDispose($Bmp)
Return $hIcon
EndFunc
Func _makeHeading($sLabel, $x, $y, $w, $height=-1, $color=-1, $lightness=-1)
$strSize = _StringSize($sLabel, 8.5, 400, 0 , "Segoe UI")
$labelX =($w-$strSize[2]*$dscale)/2 + $x
$h = $strSize[3]-2
if $height <> -1 Then
$h = $height
EndIf
$labelY = $y
Local $heading = GUICtrlCreateLabel( $sLabel, $labelX, $labelY )
_setFont($heading, 8.5)
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
Local $idPic = GUICtrlCreatePic('', $x, $y, $w, $h)
GUICtrlSetState(-1, $GUI_DISABLE)
Local $hPic = GUICtrlGetHandle($idPic)
Local $hDC = _WinAPI_GetDC($hPic)
Local $hDestDC = _WinAPI_CreateCompatibleDC($hDC)
Local $hBitmap = _WinAPI_CreateCompatibleBitmap($hDC, $w, $h)
Local $hDestSv = _WinAPI_SelectObject($hDestDC, $hBitmap)
Local $baseColor = 0x0782FD
Local $lightFactor = 0.75
If $color <> -1 Then
$baseColor = $color
$lightFactor = $lightness
EndIf
$baseRGB = _ColorGetRGB($baseColor)
$baseHSL = _ColorConvertRGBtoHSL($baseRGB)
$newL = $lightFactor * $baseHSL[2]
If $newL < 0 Then $newL = 0
Local $darkenHSL[3] = [$baseHSL[0], $baseHSL[1], $newL]
$darkenRGB = _ColorConvertHSLtoRGB($darkenHSL)
$darkenColor = _ColorSetRGB($darkenRGB)
Local $aVertex[6][3] = [[0,0, $baseColor], [$w, $h, $darkenColor], [0,0, $baseColor], [$w, $h-$h/4, $darkenColor], [0, $h-$h/4, $darkenColor], [$w,$h, $baseColor]]
If $color = -1 Then
_WinAPI_GradientFill($hDestDC, $aVertex, 0, 1)
Else
_WinAPI_GradientFill($hDestDC, $aVertex, 2, 3)
_WinAPI_GradientFill($hDestDC, $aVertex, 4, 5)
EndIf
_WinAPI_ReleaseDC($hPic, $hDC)
_WinAPI_SelectObject($hDestDC, $hDestSv)
_WinAPI_DeleteDC($hDestDC)
_SendMessage($hPic, 0x0172, 0, $hBitmap)
Local $hObj = _SendMessage($hPic, 0x0173)
If $hObj <> $hBitmap Then
_WinAPI_DeleteObject($hBitmap)
EndIf
Return $h
EndFunc
Func _makeBox($x, $y, $w, $h, $bkcolor=0xFFFFFF)
Local $bg = GUICtrlCreateLabel( "", $x+1, $y+1, $w-2, $h-2 )
GUICtrlSetBkColor(-1, $bkcolor)
Local $border = GUICtrlCreateLabel( "", $x, $y, $w, $h )
GUICtrlSetBkColor(-1, 0x003973)
EndFunc
Func _setFont($ControlID, $size, $bkcolor=-1, $color=0x000000)
Local $LControlID
If $ControlID = -1 Then
$LControlID = _GUIGetLastCtrlID()
Else
$LControlID = $ControlID
EndIf
GUICtrlSetFont( $LControlID, $size)
GUICtrlSetColor( -1, $color )
If $bkcolor <> -1 Then
GUICtrlSetBkColor( -1, $bkcolor )
EndIf
EndFunc
Func _GUIGetLastCtrlID()
Local $aRet = DllCall("user32.dll", "int", "GetDlgCtrlID", "hwnd", GUICtrlGetHandle(-1))
Return $aRet[0]
EndFunc
Func _about()
Local $bt_AboutOk, $lb_Heading, $lb_date, $lb_version, $lb_info, $lb_sig, $pic, $lb_license, $GFLine
$w = 275 * $dScale
$h = 230 * $dScale
If NOT BITAND(WinGetState($hgui), $WIN_STATE_MINIMIZED) Then
$currentWinPos = WinGetPos($winName)
$x = $currentWinPos[0] + $guiWidth * $dscale / 2 - $w / 2
$y = $currentWinPos[1] + $guiHeight * $dscale / 2 - $h / 2
Else
$x = @DesktopWidth / 2 - $w / 2
$y = @DesktopHeight / 2 - $h / 2
EndIf
$AboutChild = GUICreate("About Simple IP Config", $w, $h, $x, $y, $WS_CAPTION, -1, $hgui)
GUISetOnEvent($GUI_EVENT_CLOSE, "_onExitAbout")
GUISetFont($MyGlobalFontSize, -1, -1, $MyGlobalFontName)
GUICtrlCreateLabel("", 0, 0, $w, $h - 32 * $dscale)
GUICtrlSetBkColor(-1, 0xFFFFFF)
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlCreateLabel("", 0, $h - 32 * $dscale, $w, 1)
GUICtrlSetBkColor(-1, 0x000000)
$pic = GUICtrlCreatePic("", 17 * $dScale, 22 * $dScale, 64, 64)
_memoryToPic($pic, $pngBigicon)
GUICtrlCreateLabel("Simple IP Config", 75 * $dscale, 10 * $dscale, 200 * $dscale, -1, $SS_CENTER)
GUICtrlSetFont(-1, 13, 800)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
GUICtrlCreateLabel("Version:", 95 * $dscale, 38 * $dscale, 75 * $dscale, -1, $SS_RIGHT)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
GUICtrlCreateLabel("Date:", 95 * $dscale, 53 * $dscale, 75 * $dscale, -1, $SS_RIGHT)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
GUICtrlCreateLabel("Developer:", 95 * $dscale, 69 * $dscale, 75 * $dscale, -1, $SS_RIGHT)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
GUICtrlCreateLabel($winVersion, 174 * $dscale, 38 * $dscale, 75 * $dscale, -1)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
GUICtrlCreateLabel($winDate, 174 * $dscale, 53 * $dscale, 75 * $dscale, -1)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
GUICtrlCreateLabel("Kurtis Liggett", 174 * $dscale, 69 * $dscale, 75 * $dscale, -1)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
GUICtrlCreateLabel("License:", 95 * $dscale, 84 * $dscale, 75 * $dscale, -1, $SS_RIGHT)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
GUICtrlCreateLabel("GNU GPL v3", 174 * $dscale, 84 * $dscale, 75 * $dscale, -1)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
$desc = "The portable ip changer utility that allows a user to quickly and easily change the most common network settings for any connection."
GUICtrlCreateLabel($desc, 8, 110 * $dscale, $w - 16, 50 * $dscale)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
GUICtrlCreateLabel("", 0, 165 * $dscale, $w, 1)
GUICtrlSetBkColor(-1, 0x000000)
$link = GUICtrlCreateLabel("Aha-Soft", 180 * $dscale, 175 * $dscale, -1, 20 * $dscale)
GUICtrlSetOnEvent(-1, "_iconLink")
GUICtrlSetColor(-1,0x0000FF)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
GUICtrlSetFont(-1, -1, -1, $GUI_FONTUNDER)
GUICtrlSetTip(-1, 'Visit: aha-soft.com')
GUICtrlSetCursor(-1, 0)
$desc = "Program icons are from "
GUICtrlCreateLabel($desc, 45 * $dscale, 175 * $dscale, $w - 20, 20 * $dscale)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
$bt_AboutOk = GUICtrlCreateButton("OK", $w - 55 * $dScale, $h - 27 * $dScale, 50 * $dScale, 22 * $dScale)
GUICtrlSetOnEvent(-1, "_onExitAbout")
GUISetState(@SW_DISABLE, $hgui)
GUISetState(@SW_SHOW, $AboutChild)
EndFunc
Func _changeLog()
$w = 305*$dScale
$h = 410*$dScale
$currentWinPos = WinGetPos($winName & " " & $winVersion)
$x = $currentWinPos[0] + $guiWidth*$dscale/2 - $w/2
$y = $currentWinPos[1] + $guiHeight*$dscale/2 - $h/2
$changeLogChild = GUICreate( "Change Log", $w, $h, $x, $y, $WS_CAPTION, -1, $hgui)
GUISetOnEvent( $GUI_EVENT_CLOSE, "_onExitChangelog")
GUISetFont($MyGlobalFontSize, -1, -1, $MyGlobalFontName )
GUICtrlCreateLabel("", 0, 0, $w, $h-32*$dscale)
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetBkColor(-1, 0xFFFFFF)
GUICtrlCreateLabel("", 0, $h-32*$dscale, $w, 1)
GUICtrlSetBkColor(-1, 0x000000)
$labelTitle = GUICtrlCreateLabel($sChangelog[0], 5, 5, $w-10, 20*$dscale)
GUICtrlSetColor(-1, 0x0000FF)
GUICtrlSetBkColor(-1, 0xFFFFFF)
GUICtrlSetFont(-1, 11)
$edit = GUICtrlCreateEdit($sChangelog[1], 5, 25, $w-10, $h-37*$dscale-25, BitOR($ES_READONLY, $WS_VSCROLL, $ES_AUTOVSCROLL), $WS_EX_TRANSPARENT)
GUICtrlSetBkColor($edit, 0xFFFFFF)
GUICtrlSetFont(-1, 8.5)
$bt_Ok = GUICtrlCreateButton( "OK", $w-55*$dScale, $h - 27*$dScale, 50*$dScale, 22*$dScale)
GUICtrlSetOnEvent( -1, "_onExitChangelog")
GUISetState(@SW_DISABLE, $hGUI)
GUISetState(@SW_SHOW, $changeLogChild)
Send("^{HOME}")
EndFunc
Func _Settings()
$w = 200*$dScale
$h = 150*$dScale
$currentWinPos = WinGetPos($winName & " " & $winVersion)
$x = $currentWinPos[0] + $guiWidth*$dscale/2 - $w/2
$y = $currentWinPos[1] + $guiHeight*$dscale/2 - $h/2
$settingsChild = GUICreate( "Settings", $w, $h, $x, $y, $WS_CAPTION, -1, $hgui)
GUISetOnEvent( $GUI_EVENT_CLOSE, "_onExitSettings")
GUISetFont($MyGlobalFontSize, -1, -1, $MyGlobalFontName )
GUICtrlCreateLabel("", 0, 0, $w, $h-32*$dscale)
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetBkColor(-1, 0xFFFFFF)
GUICtrlCreateLabel("", 0, $h-32*$dscale, $w, 1)
GUICtrlSetBkColor(-1, 0x000000)
$ck_startinTray = GUICtrlCreateCheckbox( "Startup in the system tray.", 10*$dScale, 10*$dScale, 230*$dScale, 20*$dScale)
GUICtrlSetBkColor(-1, 0xFFFFFF)
GUICtrlSetState($ck_startinTray, _StrToState($options[2][1]))
$ck_mintoTray = GUICtrlCreateCheckbox( "Minimize to the system tray.", 10*$dScale, 30*$dScale, 230*$dScale, 20*$dScale)
GUICtrlSetBkColor(-1, 0xFFFFFF)
GUICtrlSetState($ck_mintoTray, _StrToState($options[1][1]))
$ck_saveAdapter = GUICtrlCreateCheckbox( "Save adapter to profile.", 10*$dScale, 50*$dScale, 230*$dScale, 20*$dScale)
GUICtrlSetBkColor(-1, 0xFFFFFF)
GUICtrlSetState($ck_saveAdapter, _StrToState($options[6][1]))
$bt_optSave = GUICtrlCreateButton( "Save", $w-25*$dScale-50*$dScale, $h - 27*$dScale, 50*$dScale, 22*$dScale)
GUICtrlSetOnEvent( $bt_optSave, "_saveOptions")
$bt_optCancel = GUICtrlCreateButton( "Cancel", 25*$dScale, $h - 27*$dScale, 50*$dScale, 22*$dScale)
GUICtrlSetOnEvent( $bt_optCancel, "_onExitSettings")
GUISetState(@SW_DISABLE, $hGUI)
GUISetState(@SW_SHOW, $settingsChild)
EndFunc
Func _statusPopup()
$wPos = WinGetPos($hgui)
$w = $guiWidth*$dScale
$h = 63*$dScale
$x = 0
$y = $guiheight*$dscale-$h-$menuHeight
$statusChild = GUICreate( "StatusMessage", $w, $h, $x, $y, $WS_POPUP, $WS_EX_TOOLWINDOW)
_WinAPI_SetParent($statusChild, $hGUI)
GUISetOnEvent( $GUI_EVENT_CLOSE, "_onExitStatus")
GUISetFont($MyGlobalFontSize, -1, -1, $MyGlobalFontName )
GUISetBkColor(_WinAPI_GetSysColor($COLOR_MENUBAR),$statusChild)
$edit = GUICtrlCreateEdit( GUICtrlRead($statuserror), 5, 8, $w-10, $h-37*$dscale, BitOR($ES_MULTILINE, $WS_VSCROLL, $ES_NOHIDESEL, $ES_READONLY ), $WS_EX_TRANSPARENT )
GUICtrlSetFont(-1, 8.5)
Send("^{HOME}")
GUICtrlCreateLabel("", 0, 1, $w, 1)
GUICtrlSetBkColor(-1, 0xFFFFFF)
GUICtrlCreateLabel("", 0, 0, $w, 1)
GUICtrlSetBkColor(-1, 0x404040)
$bt_Ok = GUICtrlCreateButton( "OK", $w-55*$dScale, $h - 27*$dScale, 50*$dScale, 22*$dScale)
GUICtrlSetOnEvent( -1, "_onExitStatus")
GUISetState(@SW_SHOW, $statusChild)
GUISwitch($hgui)
EndFunc
Func _blacklist()
Local $blacklist = StringReplace( $options[7][1], "|", @CRLF)
$w = 275*$dScale
$h = 300*$dScale
$currentWinPos = WinGetPos($winName & " " & $winVersion)
$x = $currentWinPos[0] + $guiWidth*$dscale/2 - $w/2
$y = $currentWinPos[1] + $guiHeight*$dscale/2 - $h/2
$blacklistChild = GUICreate( "Adapter Blacklist", $w, $h, $x, $y, $WS_CAPTION, -1, $hgui)
GUISetOnEvent( $GUI_EVENT_CLOSE, "_onExitBlacklist")
GUISetFont($MyGlobalFontSize, -1, -1, $MyGlobalFontName )
$label = GUICtrlCreateLabel("Hide the following adapters", 5, 5, $w-10)
GUICtrlSetBkColor($blacklistEdit, 0xFFFFFF)
$blacklistEdit = GUICtrlCreateEdit($blacklist, 5, 25*$dscale, $w-10, $h-60*$dscale-25*$dscale, BitOR($ES_WANTRETURN, $WS_VSCROLL, $ES_AUTOVSCROLL))
GUICtrlSetBkColor($blacklistEdit, 0xFFFFFF)
$bt_BlacklistAdd = GUICtrlCreateButton( "Add Selected Adapter", 10*$dScale, $h - 50*$dScale, 110*$dScale, 40*$dScale, $BS_MULTILINE)
GUICtrlSetOnEvent( -1, "_onBlacklistAdd")
$bt_Cancel = GUICtrlCreateButton( "Cancel", $w-117*$dScale, $h - 50*$dScale, 52*$dScale, 40*$dScale)
GUICtrlSetOnEvent( -1, "_onExitBlacklist")
$bt_Ok = GUICtrlCreateButton( "Save", $w-60*$dScale, $h - 50*$dScale, 50*$dScale, 40*$dScale)
GUICtrlSetOnEvent( -1, "_onExitBlacklistOk")
GUISetState(@SW_DISABLE, $hGUI)
GUISetState(@SW_SHOW, $blacklistChild)
Send("{END}")
EndFunc
Opt("TrayIconHide", 0)
Opt("GUIOnEventMode",1)
Opt("TrayAutoPause",0)
Opt("TrayOnEventMode",1)
Opt("TrayMenuMode",3)
Opt("MouseCoordMode", 2)
Opt("GUIResizeMode", $GUI_DOCKALL)
Opt("WinSearchChildren",1)
TraySetClick(16)
_main()
Func _main()
$objWMI = ObjGet("winmgmts:{impersonationLevel = impersonate}!\\" & "." & "\root\cimv2")
$dScale = _GDIPlus_GraphicsGetDPIRatio()
_loadProfiles()
_makeGUI()
_loadAdapters()
GUIRegisterMsg($iMsg, '_NewInstance')
If NOT IsArray( $adapters ) Then
MsgBox( 16, "Error", "There was a problem retrieving the adapters." )
Else
_ArraySort($adapters, 0)
$defaultitem = $adapters[1][0]
$index = _ArraySearch( $adapters, $options[4][1], 1 )
If($index <> -1) Then
$defaultitem = $adapters[$index][0]
EndIf
$aBlacklist = StringSplit($options[7][1], "|")
For $i=1 to $adapters[0][0]
$indexBlacklist = _ArraySearch($aBlacklist, $adapters[$i][0], 1)
if $indexBlacklist <> -1 Then ContinueLoop
GUICtrlSetData( $combo_adapters, $adapters[$i][0], $defaultitem )
Next
EndIf
_refresh(1)
ControlListView( $hgui, "", $list_profiles, "Select", 0 )
_checkChangelog()
GUICtrlSetData($domain, _DomainComputerBelongs())
While 1
If Not $pIdle Then _asyncProcess()
Switch GUIGetMsg()
Case $GUI_EVENT_CLOSE
_onExit()
EndSwitch
If $lv_doneEditing Then
_onLvDoneEdit()
EndIf
If $lv_startEditing and Not $lv_editing Then
_onRename()
EndIf
If $movetosubnet Then
_MoveToSubnet()
EndIf
Sleep(100)
WEnd
EndFunc
Func _NewInstance($hWnd, $iMsg, $iwParam, $ilParam)
MsgBox(0,"",$iwParam)
if $iwParam == 101 Then
TrayTip("", "Simple IP Config is already running", 1)
EndIf
EndFunc
