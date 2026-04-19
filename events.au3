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

;==============================================================================
; Filename:		events.au3
; Description:	- functions called in response to events (button clicks, etc...)
;				- 'onFunctionName' naming convention
;				- also includes WM_COMMAND and WM_NOTIFY
;==============================================================================


;------------------------------------------------------------------------------
; Title........: _onExit
; Description..: Clean up and exit the program
; Events.......: GUI_EVENT_CLOSE, tray item 'Exit', File menu 'Exit'
;------------------------------------------------------------------------------
Func _onExit()
	$sMinToTray = $options.MinToTray
	If $sMinToTray = 1 Or $sMinToTray = "true" Then
		_SendToTray()
	Else
		_Exit()
	EndIf
EndFunc   ;==>_onExit

;------------------------------------------------------------------------------
; Title........: _onMenuExit
; Description..: Clean up and exit the program
; Events.......: GUI_EVENT_CLOSE, tray item 'Exit', File menu 'Exit'
;------------------------------------------------------------------------------
Func _onMenuExit()
	_Exit()
EndFunc   ;==>_onMenuExit

;------------------------------------------------------------------------------
; Title........: _Exit
; Description..: Clean up and exit the program
; Events.......: GUI_EVENT_CLOSE, tray item 'Exit', File menu 'Exit'
;------------------------------------------------------------------------------
Func _Exit()
	_GDIPlus_Shutdown()

	; save window position in ini file
	If BitAND(WinGetState($hgui), $WIN_STATE_MAXIMIZED) Then
		ConsoleWrite("maximized" & @CRLF)
		$options.PositionW = -1
		$options.PositionH = -1

		IniWriteSection($sProfileName, "options", $options.getSection, 0)
	ElseIf Not BitAND(WinGetState($hgui), $WIN_STATE_MINIMIZED) Then
		ConsoleWrite("not minimized" & @CRLF)
		$currentWinPos = WinGetPos($hgui)
		$options.PositionX = $currentWinPos[0]
		$options.PositionY = $currentWinPos[1]

		$currentWinPos = WinGetClientSize($hgui)
		Local $captionH = _WinAPI_GetSystemMetrics($SM_CYCAPTION)
		Local $borderW = _WinAPI_GetSystemMetrics($SM_CXBORDER)
		Local $borderH = _WinAPI_GetSystemMetrics($SM_CYBORDER)

		$options.PositionW = $currentWinPos[0]
		$options.PositionH = $currentWinPos[1] + $captionH - 2 * $borderH - 1

		IniWriteSection($sProfileName, "options", $options.getSection, 0)
	EndIf

	Exit
EndFunc   ;==>_Exit

Func _onCreateLink()
	_CreateLink()
EndFunc   ;==>_onCreateLink

;------------------------------------------------------------------------------
; Title........: _onExitChild
; Description..: Close any child window
; Events.......: child window GUI_EVENT_CLOSE, OK/Cancel button
;------------------------------------------------------------------------------
Func _onExitChild()
	_ExitChild(@GUI_WinHandle)

	If @GUI_WinHandle = $statusChild Then
		$statusChild = 0
	EndIf
EndFunc   ;==>_onExitChild

Func _onExitAddIP()
	 If $hMultiIPWindow <> 0 Then
        GUISetState(@SW_ENABLE, $hMultiIPWindow)
        WinActivate($hMultiIPWindow)
    EndIf
    
    ; Chiudi la finestra Add IP
    GUIDelete(@GUI_WinHandle)
    
    ; Resetta le variabili
    $g_addIPWindow = 0
    $g_ip_Ip = 0
    $g_ip_Subnet = 0
EndFunc   ;==>_onExitAddIP

Func _onExitAddIP_profile()
	 If $hMultiIP_ProfileWindow <> 0 Then
        GUISetState(@SW_ENABLE, $hMultiIP_ProfileWindow)
        WinActivate($hMultiIP_ProfileWindow)
    EndIf
    
    ; Chiudi la finestra Add IP profile
    GUIDelete(@GUI_WinHandle)
    
    
EndFunc   ;==>_onExitAddIP

; =============================================================================
; FUNCTION: _onExitEditIP()
; Closes the Edit IP window and re-enables Multi IP window
; =============================================================================
Func _onExitEditIP()
    ; Re-enable Multi IP window
    If $hMultiIPWindow <> 0 Then
        GUISetState(@SW_ENABLE, $hMultiIPWindow)
        WinActivate($hMultiIPWindow)
    EndIf
    
    ; Close edit window
    If $g_editIPWindow <> 0 Then
        GUIDelete($g_editIPWindow)
        $g_editIPWindow = 0
    EndIf
EndFunc

;------------------------------------------------------------------------------
; Title........: _OnTrayClick
; Description..: Restore or hide program to system tray
; Events.......: single left-click on tray icon
;------------------------------------------------------------------------------
Func _OnTrayClick()
	If TrayItemGetText($RestoreItem) = $oLangStrings.traymenu.restore Then
		_maximize()
	Else
		_SendToTray()
	EndIf
EndFunc   ;==>_OnTrayClick

;------------------------------------------------------------------------------
; Title........: _OnRestore
; Description..: Restore or hide program to system tray
; Events.......: 'Restore' item in tray right-click menu
;------------------------------------------------------------------------------
Func _OnRestore()
	If TrayItemGetText($RestoreItem) = $oLangStrings.traymenu.restore Then
		_maximize()
	Else
		_SendToTray()
	EndIf
EndFunc   ;==>_OnRestore

;------------------------------------------------------------------------------
; Title........: _onBlacklist
; Description..: Create the 'Hide adapters' child window
; Events.......: 'Hide adapters' item in the 'View' menu
;------------------------------------------------------------------------------
Func _onBlacklist()
	_form_blacklist()
EndFunc   ;==>_onBlacklist

;------------------------------------------------------------------------------
; Title........: _onRadio
; Description..: Update radio button selections and states
; Events.......: Any radio button state changed
;------------------------------------------------------------------------------
Func _onRadio()
	ConsoleWrite("click" & @CRLF)
	_radios()
EndFunc   ;==>_onRadio

;------------------------------------------------------------------------------
; Title........: _onRadioIpAuto
; Description..: Update radio button selections and states
; Events.......: radio button or text clicked
;------------------------------------------------------------------------------
Func _onRadioIpAuto()
	GUICtrlSetState($radio_IpMan, $GUI_UNCHECKED)
	GUICtrlSetState($radio_IpAuto, $GUI_CHECKED)
	If GUICtrlRead($radio_DnsMan) = $GUI_CHECKED Then
		GUICtrlSetState($radio_DnsAuto, $GUI_UNCHECKED)
	EndIf
	_radios()
EndFunc   ;==>_onRadioIpAuto

;------------------------------------------------------------------------------
; Title........: _onRadioIpMan
; Description..: Update radio button selections and states
; Events.......: radio button or text clicked
;------------------------------------------------------------------------------
Func _onRadioIpMan()
	GUICtrlSetState($radio_IpAuto, $GUI_UNCHECKED)
	GUICtrlSetState($radio_IpMan, $GUI_CHECKED)
	GUICtrlSetState($radio_DnsMan, $GUI_CHECKED)
	GUICtrlSetState($radio_DnsAuto, $GUI_UNCHECKED)
	_radios()
EndFunc   ;==>_onRadioIpMan

;------------------------------------------------------------------------------
; Title........: _onRadioDnsAuto
; Description..: Update radio button selections and states
; Events.......: radio button or text clicked
;------------------------------------------------------------------------------
Func _onRadioDnsAuto()
	if GUICtrlRead($radio_IpMan) = $GUI_CHECKED Then
		GUICtrlSetState($radio_DnsMan, $GUI_CHECKED)
		GUICtrlSetState($radio_DnsAuto, $GUI_UNCHECKED)
	EndIf
	if GUICtrlRead($radio_IpAuto) = $GUI_CHECKED Then
		GUICtrlSetState($radio_DnsMan, $GUI_UNCHECKED)
		GUICtrlSetState($radio_DnsAuto, $GUI_CHECKED)
		_radios()
	EndIf
	
EndFunc   ;==>_onRadioDnsAuto

;------------------------------------------------------------------------------
; Title........: _onRadioDnsMan
; Description..: Update radio button selections and states
; Events.......: radio button or text clicked
;------------------------------------------------------------------------------
Func _onRadioDnsMan()
	GUICtrlSetState($radio_DnsAuto, $GUI_UNCHECKED)
	GUICtrlSetState($radio_DnsMan, $GUI_CHECKED)
	_radios()
EndFunc   ;==>_onRadioDnsMan

;------------------------------------------------------------------------------
; Title........: _onCheckboxRegDns
; Description..: Set checkbox state
; Events.......: click checkbox text
;------------------------------------------------------------------------------
Func _onCheckboxRegDns()
	If GUICtrlRead($ck_dnsReg) = $GUI_CHECKED Then
		GUICtrlSetState($ck_dnsReg, $GUI_UNCHECKED)
	Else
		GUICtrlSetState($ck_dnsReg, $GUI_CHECKED)
	EndIf
EndFunc   ;==>_onCheckboxRegDns _onCheckboxMultiIP_profile

;------------------------------------------------------------------------------
; Title........: _onCheckboxMultiIP_profile
; Description..: Set checkbox state
; Events.......: click checkbox text
;------------------------------------------------------------------------------
Func _onCheckboxMultiIP_profile()
	If GUICtrlRead($ck_MultiIP_profile) = $GUI_CHECKED Then
		GUICtrlSetState($ck_MultiIP_profile, $GUI_UNCHECKED)
		GUICtrlSetState($buttonMultiIP_profile, $GUI_DISABLE)
	Else
		GUICtrlSetState($ck_MultiIP_profile, $GUI_CHECKED)
		GUICtrlSetState($buttonMultiIP_profile, $GUI_ENABLE)
	EndIf
EndFunc   ;==>_onCheckboxMultiIP_profile

;------------------------------------------------------------------------------
; Title........: _onCheckboxMultiIP_profile
; Description..: Set checkbox state
; Events.......: click checkbox text
;------------------------------------------------------------------------------
Func _onCheckboxMultiIP_profile2()
	If GUICtrlRead($ck_MultiIP_profile) = $GUI_CHECKED Then
		GUICtrlSetState($buttonMultiIP_profile, $GUI_ENABLE)
	Else
		GUICtrlSetState($buttonMultiIP_profile, $GUI_DISABLE)
	EndIf
EndFunc   ;==>_onCheckboxMultiIP_profile

;------------------------------------------------------------------------------
; Title........: _onSelect
; Description..: Set IP address information from profile
; Events.......: Click on profile list item
;------------------------------------------------------------------------------
Func _onSelect()
	ConsoleWrite("enter list view profile" & @CRLF)
	_setProperties()
EndFunc   ;==>_onSelect

;------------------------------------------------------------------------------
; Title........: _onApply
; Description..: Apply the selected profile
; Events.......: File menu 'Apply profile' button, toolbar 'Apply' button
;------------------------------------------------------------------------------
Func _onApply()
	_apply_GUI()
EndFunc   ;==>_onApply

;------------------------------------------------------------------------------
; Title........: _onArrangeAz
; Description..: Arrange profiles in alphabetical order
; Events.......: Profiles listview context menu item
;------------------------------------------------------------------------------
Func _onArrangeAz()
	_arrange()
EndFunc   ;==>_onArrangeAz

;------------------------------------------------------------------------------
; Title........: _onArrangeZa
; Description..: Arrange profiles in reverse alphabetical order
; Events.......: Profiles listview context menu item
;------------------------------------------------------------------------------
Func _onArrangeZa()
	_arrange(1)
EndFunc   ;==>_onArrangeZa

;------------------------------------------------------------------------------
; Title........: _onRename
; Description..: Start editing profile name for the selected listview item
; Events.......: Profiles listview context menu item, F2 accelerator,
;                File menu 'Rename' item
;------------------------------------------------------------------------------
Func _onRename()
	If Not _ctrlHasFocus($list_profiles) Then
		Return
	EndIf
	$Index = _GUICtrlListView_GetSelectedIndices($list_profiles)
	$lvEditHandle = _GUICtrlListView_EditLabel(ControlGetHandle($hgui, "", $list_profiles), $Index)
EndFunc   ;==>_onRename


;------------------------------------------------------------------------------
; Title........: _onTabKey
; Description..: Cancel editing listview item - prevents system from tabbing
;					through listview items while editing
; Events.......: TAB key (while editing)
;------------------------------------------------------------------------------
Func _onTabKey()
	If IsHWnd(_GUICtrlListView_GetEditControl(ControlGetHandle($hgui, "", $list_profiles))) Then
		$lvTabKey = True
		Send("{ENTER}")
	Else
		GUISetAccelerators(0)
		Send("{TAB}")
		GUISetAccelerators($aAccelKeys)
	EndIf
EndFunc   ;==>_onTabKey


;------------------------------------------------------------------------------
; Title........: _onNewItem
; Description..: Create new listview item and start editing the name
; Events.......: Toolbar button, File menu 'New' item
;------------------------------------------------------------------------------
Func _onNewItem()
	$newname = $oLangStrings.message.newItem
	;Local $profileNames = _getNames()
	Local $profileNames = $profiles.getNames()
	Local $i = 1
	While _ArraySearch($profileNames, $newname) <> -1
		$newname = "New Item " & $i
		$i = $i + 1
	WEnd

	GUISwitch($hgui)
	ControlFocus($hgui, "", $list_profiles)
	GUICtrlCreateListViewItem($newname, $list_profiles)
	GUICtrlSetOnEvent(-1, "_onSelect")
	$lv_newItem = 1
	$Index = ControlListView($hgui, "", $list_profiles, "GetItemCount")
	ControlListView($hgui, "", $list_profiles, "Select", $Index - 1)
	_GUICtrlListView_EditLabel(ControlGetHandle($hgui, "", $list_profiles), $Index - 1)
EndFunc   ;==>_onNewItem

;------------------------------------------------------------------------------
; Title........: _onSave
; Description..: Save the current settings to the selected profile
; Events.......: Toolbar button, File menu 'Save' item, Ctrl+s accelerator
;------------------------------------------------------------------------------
Func _onSave()
	_save()
EndFunc   ;==>_onSave

;------------------------------------------------------------------------------
; Title........: _onDelete
; Description..: Delete the selected profile
; Events.......: Toolbar button, Del accelerator
;------------------------------------------------------------------------------
Func _onDelete()
	_delete()
EndFunc   ;==>_onDelete

;------------------------------------------------------------------------------
; Title........: _onClear
; Description..: Clear the current address fields
; Events.......: Toolbar button, File menu 'Clear' item
;------------------------------------------------------------------------------
Func _onClear()
	_clear()
EndFunc   ;==>_onClear

;------------------------------------------------------------------------------
; Title........: _onRefresh
; Description..: Refresh the profiles list and current IP info
; Events.......: Toolbar button, View menu 'Refresh' item
;------------------------------------------------------------------------------
Func _onRefresh()
	$showWarning = 0
	$Index = ControlListView($hgui, "", $list_profiles, "GetSelected")
	_refresh()
	ControlListView($hgui, "", $list_profiles, "Select", $Index)
EndFunc   ;==>_onRefresh

;------------------------------------------------------------------------------
; Title........: _onLvDel
; Description..: Delete the selected listview item
; Events.......: File menu Delete item, listview context menu Delete item
;------------------------------------------------------------------------------
Func _onLvDel()
	If _ctrlHasFocus($list_profiles) Then
		_delete()
	Else
		GUISetAccelerators(0)
		Send("{DEL}")
		GUISetAccelerators($aAccelKeys)
	EndIf
EndFunc   ;==>_onLvDel

;------------------------------------------------------------------------------
; Title........: _onLvUp
; Description..: Move listview selection up 1 index and get the profile info
; Events.......: UP key accelerator
;------------------------------------------------------------------------------
Func _onLvUp()
	If _ctrlHasFocus($list_profiles) Then
		$Index = ControlListView($hgui, "", $list_profiles, "GetSelected")
		ControlListView($hgui, "", $list_profiles, "Select", $Index - 1)
		_setProperties()
	Else
		GUISetAccelerators(0)
		Send("{Up}")
		GUISetAccelerators($aAccelKeys)
	EndIf
EndFunc   ;==>_onLvUp

;------------------------------------------------------------------------------
; Title........: _onLvDown
; Description..: Move listview selection down 1 index and get the profile info
; Events.......: DOWN key accelerator
;------------------------------------------------------------------------------
Func _onLvDown()
	If _ctrlHasFocus($list_profiles) Then
		$Index = ControlListView($hgui, "", $list_profiles, "GetSelected")
		ControlListView($hgui, "", $list_profiles, "Select", $Index + 1)
		_setProperties()
	Else
		GUISetAccelerators(0)
		Send("{Down}")
		GUISetAccelerators($aAccelKeys)
	EndIf
EndFunc   ;==>_onLvDown

;------------------------------------------------------------------------------
; Title........: _onLvEnter
; Description..: Apply the selected profile
; Events.......: Enter key on listview item
;------------------------------------------------------------------------------
Func _onLvEnter()
	If _ctrlHasFocus($memo) Then
		GUISetAccelerators(0)
		Send("{ENTER}")
		GUISetAccelerators($aAccelKeys)
		Return
	EndIf

	If Not $lv_editing Then
		_apply_GUI()
	Else
		GUISetAccelerators(0)
		Send("{ENTER}")
		GUISetAccelerators($aAccelKeys)
	EndIf
EndFunc   ;==>_onLvEnter

;------------------------------------------------------------------------------
; Title........: _onTray
; Description..: Hide or show main GUI window
; Events.......: Toolbar button, View menu "Send to tray" item
;------------------------------------------------------------------------------
Func _onTray()
	_SendToTray()
EndFunc   ;==>_onTray

;------------------------------------------------------------------------------
; Title........: _onLightMode
; Description..: Set light mode
; Events.......: View menu -> Appearance
;------------------------------------------------------------------------------
Func _onLightMode()
	_setTheme(True)
	GUICtrlSetState($lightmodeitem, $GUI_CHECKED)
	GUICtrlSetState($darkmodeitem, $GUI_UNCHECKED)

	$options.Theme = "Light"
	IniWrite($sProfileName, "options", "Theme", "Light")
EndFunc   ;==>_onLightMode

;------------------------------------------------------------------------------
; Title........: _onDarkMode
; Description..: Set dark mode
; Events.......: View menu -> Appearance
;------------------------------------------------------------------------------
Func _onDarkMode()
	_setTheme(False)
	GUICtrlSetState($lightmodeitem, $GUI_UNCHECKED)
	GUICtrlSetState($darkmodeitem, $GUI_CHECKED)

	$options.Theme = "Dark"
	IniWrite($sProfileName, "options", "Theme", "Dark")
EndFunc   ;==>_onDarkMode

;------------------------------------------------------------------------------
; Title........: _onPull
; Description..: Get current IP information from adapter
; Events.......: Tools menu "Pull from adapter" item
;------------------------------------------------------------------------------
Func _onPull()
	_Pull()
EndFunc   ;==>_onPull

;------------------------------------------------------------------------------
; Title........: _onDisable
; Description..: Disable / Enable the selected adapter
; Events.......: Tools menu "Disable adapter" item
;------------------------------------------------------------------------------
Func _onDisable()
	_disable()
EndFunc   ;==>_onDisable

;------------------------------------------------------------------------------
; Title........: _onRelease
; Description..: Release DHCP for the selected adapter
; Events.......: Tools menu "Release DHCP" item
;------------------------------------------------------------------------------
Func _onRelease()
	_releaseDhcp()
EndFunc   ;==>_onRelease

;------------------------------------------------------------------------------
; Title........: _onRenew
; Description..: Renew DHCP for the selected adapter
; Events.......: Tools menu "Renew DHCP" item
;------------------------------------------------------------------------------
Func _onRenew()
	_renewDhcp()
EndFunc   ;==>_onRenew

;------------------------------------------------------------------------------
; Title........: _onCycle
; Description..: Release DHCP followed by Renew DHCP for the selected adapter
; Events.......: Tools menu "Release/renew cycle" item
;------------------------------------------------------------------------------
Func _onCycle()
	_cycleDhcp()
EndFunc   ;==>_onCycle

;------------------------------------------------------------------------------
; Title........: _onSettings
; Description..: Create the settings child window
; Events.......: Tools menu "Settings" item
;------------------------------------------------------------------------------
Func _onSettings()
	_formm_settings()
EndFunc   ;==>_onSettings

;------------------------------------------------------------------------------
; Title........: _onMultiIp
; Description..: Create the multi-IP settings child window
; Events.......: Tools menu "Multi-IP Settings" item
;------------------------------------------------------------------------------
Func _onMultiIp()
	Global $listIP=_GetAllIPv4ForSelectedAdapter()
	_print("get IP info")
	_form_multi_ip()
EndFunc   ;==>_onMultiIp

;------------------------------------------------------------------------------
; Title........: _onMultiIp_profile
; Description..: Create the multi-IP settings child window
; Events.......: Tools menu "Multi-IP Settings" item
;------------------------------------------------------------------------------
Func _onMultiIP_profile()
	_print("set multi IP table for profile")
	_form_multi_ip_profile()
EndFunc   ;==>_onMultiIp_profile

;------------------------------------------------------------------------------
Func _onAddIP()
	GUISetState(@SW_DISABLE, $hMultiIPWindow)
	_form_add_ip()	
EndFunc

;------------------------------------------------------------------------------
Func _onAddIP_profile()
	GUISetState(@SW_DISABLE, $hMultiIP_ProfileWindow)
	_form_add_ip_profile()	
EndFunc

;------------------------------------------------------------------------------
Func _onEditIP_profile()
	GUISetState(@SW_DISABLE, $hMultiIP_ProfileWindow)
	Local $iSelected = _GUICtrlListView_GetSelectedIndices($lbox_MultiIP_profile)
    $g_iEditIndexProfile = $iSelected
	 If $iSelected = "" Then
		ConsoleWrite("No IP profile selected for editing" & @CRLF)
		Return
	EndIf
	$g_ip_profile_editIp = $listIP_profile[$iSelected+1][0]
	$g_ip_profile_editSubnet = $listIP_profile[$iSelected+1][1]
	_form_edit_ip_profile()	
EndFunc

;------------------------------------------------------------------------------
Func _onEditIP()
	Local $iSelected = _GUICtrlListView_GetSelectedIndices($lbox_MultiIP)
	 If $iSelected = "" Then
        ConsoleWrite("No IP selected for editing" & @CRLF)
        Return
    EndIf
	; Get current IP and Subnet from selected row
    Local $sCurrentIP = _GUICtrlListView_GetItemText($lbox_MultiIP, Number($iSelected), 0)
    Local $sCurrentSubnet = _GUICtrlListView_GetItemText($lbox_MultiIP, Number($iSelected), 1)

	ConsoleWrite("=== Edit IP ===" & @CRLF)
    ConsoleWrite("Current IP: " & $sCurrentIP & @CRLF)
    ConsoleWrite("Current Subnet: " & $sCurrentSubnet & @CRLF)

	; Save selected index for later use
    Global $g_iEditIndex = $iSelected
    Global $g_sOldIP = $sCurrentIP

	GUISetState(@SW_DISABLE, $hMultiIPWindow)
	_form_edit_ip($sCurrentIP, $sCurrentSubnet)	
EndFunc



Func _onDeleteIP()
    ; Get the index of the selected item
    Local $iSelected = _GUICtrlListView_GetSelectedIndices($lbox_MultiIP)
    
    If $iSelected = "" Then
        MsgBox(48, $oLangStrings.message.warning, "Please select an IP address to delete")
        Return
    EndIf
    
    Local $sIPToDelete = _GUICtrlListView_GetItemText($lbox_MultiIP, Number($iSelected), 0)
    ConsoleWrite("IP to delete: " & $sIPToDelete & @CRLF)
    
    ; === DISABILITA LA FINESTRA (diventa grigia e non cliccabile) ===
    GUISetState(@SW_DISABLE, $hMultiIPWindow)
    
    ; Opzionale: cambia il cursore del mouse per indicare "occupato"
    GUISetCursor(15, 1, $hMultiIPWindow)  ; 15 = cursore "attesa" (a clessidra)
    
    ; Esegui l'eliminazione
    _DeleteSelectedIP($sIPToDelete)
    
    ; Attendi che l'operazione completi
    Sleep(1500)  ; 1.5 secondi di attesa per assicurarsi che l'IP sia stato eliminato
    
    ; Refresh the ListView with updated data
    _RefreshMultiIPList()
    
    ; === RIABILITA LA FINESTRA ===
    GUISetState(@SW_ENABLE, $hMultiIPWindow)
    
    ; Ripristina il cursore normale
    GUISetCursor(2, 1, $hMultiIPWindow)  ; 2 = cursore standard
    
    ; Riporta la finestra in primo piano
    WinActivate($hMultiIPWindow)
EndFunc

; =============================================================================
; FUNCTION: _onAddIPConfirm()
; Confirms and adds the new IP address to the selected adapter
; =============================================================================
Func _onAddIPConfirm()
    ; Read IP and Subnet from controls
    Local $sIP = _GUICtrlIpAddress_Get($g_ip_Ip)
    Local $sSubnet = _GUICtrlIpAddress_Get($g_ip_Subnet)
    
    ConsoleWrite("=== Add IP Confirmation ===" & @CRLF)
    ConsoleWrite("IP to add: " & $sIP & @CRLF)
    ConsoleWrite("Subnet mask: " & $sSubnet & @CRLF)
    
    ; Validation
    If $sIP = "0.0.0.0" Or $sIP = "" Then
        ConsoleWrite("ERROR: Invalid IP address" & @CRLF)
        Return
    EndIf
    
    If $sSubnet = "0.0.0.0" Or $sSubnet = "" Then
        ConsoleWrite("WARNING: Invalid subnet mask, using default 255.255.255.0" & @CRLF)
        $sSubnet = "255.255.255.0"
    EndIf
    
    ; Get selected adapter from main combo box
    Local $sAdapterName = GUICtrlRead($combo_adapters)
    If $sAdapterName = "" Then
        ConsoleWrite("ERROR: No adapter selected" & @CRLF)
        Return
    EndIf
    
    ConsoleWrite("Target adapter: " & $sAdapterName & @CRLF)
    
    ; Disable window during operation
    GUISetState(@SW_DISABLE, $g_addIPWindow)
    GUISetCursor(15, 1, $g_addIPWindow)
    ConsoleWrite("Add IP window disabled" & @CRLF)
    
    ; Add the IP address
    Local $bResult = _AddIPToAdapter($sAdapterName, $sIP, $sSubnet)
    
    Sleep(1000)
    
    ; Re-enable window
    GUISetState(@SW_ENABLE, $g_addIPWindow)
    GUISetCursor(2, 1, $g_addIPWindow)
    ConsoleWrite("Add IP window re-enabled" & @CRLF)
    
    If $bResult Then
        ConsoleWrite("SUCCESS: IP added successfully" & @CRLF)
        _onExitAddIP()
        _RefreshMultiIPList()
        ConsoleWrite("Multi IP list refreshed" & @CRLF)
    Else
        ConsoleWrite("ERROR: Failed to add IP" & @CRLF)
    EndIf
    
    ConsoleWrite("=== Add IP Confirmation Complete ===" & @CRLF & @CRLF)
EndFunc

; =============================================================================
; FUNCTION: _onAddIPConfirm_profile()
; Adds IP/subnet to global $listIP_profile table if not already present
; and if different from current primary IP ($ip_Ip)
; =============================================================================
Func _onAddIPConfirm_profile()
    ; Read IP and Subnet from controls
    Local $sNewIP = _GUICtrlIpAddress_Get($g_ip_profile_Ip)
    Local $sNewSubnet = _GUICtrlIpAddress_Get($g_ip_profile_Subnet)
    
    ConsoleWrite("=== Add IP Profile ===" & @CRLF)
    ConsoleWrite("IP to add: " & $sNewIP & @CRLF)
    ConsoleWrite("Subnet: " & $sNewSubnet & @CRLF)
    
    ; Validation - check if IP is valid
    If $sNewIP = "0.0.0.0" Or $sNewIP = "" Then
        ConsoleWrite("ERROR: Invalid IP address" & @CRLF)
        Return
    EndIf
    
    ; Set default subnet if invalid
    If $sNewSubnet = "0.0.0.0" Or $sNewSubnet = "" Then
        ConsoleWrite("WARNING: Invalid subnet, using 255.255.255.0" & @CRLF)
        $sNewSubnet = "255.255.255.0"
    EndIf
    
    
    ; Initialize global table if not already initialized
    If Not IsArray($listIP_profile) Then
        Global $listIP_profile[1][2]
        $listIP_profile[0][0] = 0
        ConsoleWrite("Initialized global $listIP_profile array" & @CRLF)
    EndIf
    
    ; Check if IP already exists in the table
    For $i = 1 To $listIP_profile[0][0]
        If $listIP_profile[$i][0] = $sNewIP Then
            ConsoleWrite("ERROR: IP " & $sNewIP & " already exists in profile table" & @CRLF)
            Return
        EndIf
    Next
    
    ; Add the new IP to the global table
    Local $iCurrentCount = $listIP_profile[0][0]
    $iCurrentCount += 1
    ReDim $listIP_profile[$iCurrentCount + 1][2]
    $listIP_profile[$iCurrentCount][0] = $sNewIP
    $listIP_profile[$iCurrentCount][1] = $sNewSubnet
    $listIP_profile[0][0] = $iCurrentCount
    
    ConsoleWrite("SUCCESS: IP added to profile table. Total IPs: " & $iCurrentCount & @CRLF)
    ; REFRESH THE LISTVIEW
    _RefreshMultiIPProfileList()
    ; Close the window
    _onExitAddIP_profile()
    
    ConsoleWrite("=== Add IP Profile Complete ===" & @CRLF & @CRLF)
EndFunc

; =============================================================================
	; FUNCTION: _onEditIPConfirm_profile()
	; Adds IP/subnet to global $listIP_profile table if not already present
; and if different from current primary IP ($ip_Ip)
; =============================================================================
Func _onEditIPConfirm_profile()
    ; Read IP and Subnet from controls
    Local $sNewIP = _GUICtrlIpAddress_Get($g_ip_profile_editIp)
    Local $sNewSubnet = _GUICtrlIpAddress_Get($g_ip_profile_editSubnet)
    
    ConsoleWrite("=== Edit IP Profile ===" & @CRLF)
    ConsoleWrite("IP to edit: " & $sNewIP & @CRLF)
    ConsoleWrite("Subnet: " & $sNewSubnet & @CRLF)
	ConsoleWrite("Editing index: " & Number($g_iEditIndexProfile) & @CRLF)
    
    ; Validation - check if IP is valid
    If $sNewIP = "0.0.0.0" Or $sNewIP = "" Then
        ConsoleWrite("ERROR: Invalid IP address" & @CRLF)
        Return
    EndIf
    
    ; Set default subnet if invalid
    If $sNewSubnet = "0.0.0.0" Or $sNewSubnet = "" Then
        ConsoleWrite("WARNING: Invalid subnet, using 255.255.255.0" & @CRLF)
        $sNewSubnet = "255.255.255.0"
    EndIf
    
    
    ; Check if IP already exists in the table
    For $i = 1 To $listIP_profile[0][0]
        If $listIP_profile[$i][0] = $sNewIP AND NOT($g_iEditIndexProfile + 1 = $i) Then
            ConsoleWrite("ERROR: IP " & $sNewIP & " already exists in profile table" & @CRLF)
            Return
        EndIf
    Next
    
    $listIP_profile[$g_iEditIndexProfile+1][0] = $sNewIP
	$listIP_profile[$g_iEditIndexProfile+1][1] = $sNewSubnet
    
    ConsoleWrite("SUCCESS: IP edited." & @CRLF)
    ; REFRESH THE LISTVIEW
    _RefreshMultiIPProfileList()
    ; Close the window
    _onExitAddIP_profile()
    
    ConsoleWrite("=== Edit IP Profile Complete ===" & @CRLF & @CRLF)
EndFunc

; =============================================================================
; FUNCTION: _RefreshMultiIPProfileList()
; Refreshes the ListView with data from global $listIP_profile
; =============================================================================
Func _RefreshMultiIPProfileList()
    ; Clear existing items
    _GUICtrlListView_DeleteAllItems($lbox_MultiIP_profile)
    
    ; Check if profile table exists and has data
    If Not IsArray($listIP_profile) Or $listIP_profile[0][0] = 0 Then
        GUICtrlCreateListViewItem("No IPs in profile|", $lbox_MultiIP_profile)
        Return
    EndIf
    
    ; Populate ListView with all IPs from profile table
    For $i = 1 To $listIP_profile[0][0]
        GUICtrlCreateListViewItem($listIP_profile[$i][0] & "|" & $listIP_profile[$i][1], $lbox_MultiIP_profile)
    Next
    
    ; Select first item if available
    If $listIP_profile[0][0] > 0 Then
        _GUICtrlListView_SetItemSelected($lbox_MultiIP_profile, 0)
    EndIf
    
    ConsoleWrite("Refreshed Multi IP Profile ListView. Total IPs: " & $listIP_profile[0][0] & @CRLF)
EndFunc

; =============================================================================
; FUNCTION: _onDeleteIP_profile()
; Deletes the selected IP from the ListView and from global $listIP_profile table
; =============================================================================
Func _onDeleteIP_profile()
    ; Get the selected item index from ListView
    Local $iSelected = _GUICtrlListView_GetSelectedIndices($lbox_MultiIP_profile)
    
    ; Check if an item is selected
    If $iSelected = "" Then
        ConsoleWrite("ERROR: No IP selected to delete" & @CRLF)
        Return
    EndIf
    
    ; Get the IP address from the selected row (first column)
    Local $sIPToDelete = _GUICtrlListView_GetItemText($lbox_MultiIP_profile, Number($iSelected), 0)
    
    ConsoleWrite("=== Delete IP from Profile ===" & @CRLF)
    ConsoleWrite("IP to delete: " & $sIPToDelete & @CRLF)
    
    ; Check if profile table exists and has data
    If Not IsArray($listIP_profile) Or $listIP_profile[0][0] = 0 Then
        ConsoleWrite("ERROR: Profile table is empty" & @CRLF)
        Return
    EndIf
    
    ; Find and remove the IP from the global array
    Local $iNewCount = 0
    Local $aNewList[1][2]
    $aNewList[0][0] = 0
    
    For $i = 1 To $listIP_profile[0][0]
        If $listIP_profile[$i][0] <> $sIPToDelete Then
            $iNewCount += 1
            ReDim $aNewList[$iNewCount + 1][2]
            $aNewList[$iNewCount][0] = $listIP_profile[$i][0]
            $aNewList[$iNewCount][1] = $listIP_profile[$i][1]
            $aNewList[0][0] = $iNewCount
        EndIf
    Next
    
    ; Update the global table
    $listIP_profile = $aNewList
    
    ConsoleWrite("SUCCESS: IP removed from profile table. Remaining IPs: " & $listIP_profile[0][0] & @CRLF)
    
    ; Refresh the ListView
    _RefreshMultiIPProfileList()
    
    ConsoleWrite("=== Delete IP Complete ===" & @CRLF & @CRLF)
EndFunc

;------------------------------------------------------------------------------
; Title........: _onHelp
; Description..: Navigate to documentation link <-- needs to be created!
; Events.......: Help menu "Online Documentation" item
;------------------------------------------------------------------------------
Func _onHelp()
	ShellExecute('https://github.com/KurtisLiggett/Simple-IP-Config/wiki')
EndFunc   ;==>_onHelp

Func _onUpdateCheckItem()
	$suppressComError = 1
	_checksSICUpdate(1)
	$suppressComError = 0
EndFunc   ;==>_onUpdateCheckItem

;------------------------------------------------------------------------------
; Title........: _onDebugItem
; Description..: Create debug child window
; Events.......: Help menu "Debug Information" item
;------------------------------------------------------------------------------
Func _onDebugItem()
	_form_debug()
EndFunc   ;==>_onDebugItem

;------------------------------------------------------------------------------
; Title........: _onChangelog
; Description..: Create change log child window
; Events.......: Help menu "Show Change Log" item
;------------------------------------------------------------------------------
Func _onChangelog()
	_form_changelog()
EndFunc   ;==>_onChangelog

;------------------------------------------------------------------------------
; Title........: _onAbout
; Description..: Create the About child window
; Events.......: Help menu "About Simple IP Config" item, tray right-click menu
;------------------------------------------------------------------------------
Func _onAbout()
	_form_about()
EndFunc   ;==>_onAbout

;------------------------------------------------------------------------------
; Title........: _onFilter
; Description..: Filter the profiles listview
; Events.......: Filter input text change
;------------------------------------------------------------------------------
Func _onFilter()
	_filterProfiles()
EndFunc   ;==>_onFilter

;------------------------------------------------------------------------------
; Title........: _OnCombo
; Description..: Update adapter information, save last used adapter to profiles.ini
; Events.......: Combobox selection change
;------------------------------------------------------------------------------
Func _OnCombo()
	_updateCurrent()
	$adap = GUICtrlRead($combo_adapters)
	$iniAdap = iniNameEncode($adap)
	$ret = IniWrite($sProfileName, "options", "StartupAdapter", $iniAdap)
	If $ret = 0 Then
		_setStatus("An error occurred while saving the selected adapter", 1)
	Else
		$options.StartupAdapter = $adap
	EndIf
EndFunc   ;==>_OnCombo

;------------------------------------------------------------------------------
; Title........: _iconLink
; Description..: Open browser and go to icon website
; Events.......: Click on link in About window
;------------------------------------------------------------------------------
Func _iconLink()
	ShellExecute('http://www.aha-soft.com/')
	GUICtrlSetColor(@GUI_CtrlId, 0x551A8B)
EndFunc   ;==>_iconLink

;------------------------------------------------------------------------------
; Title........: _updateLink
; Description..: Open browser and go to latest version
; Events.......: Click on link in update window
;------------------------------------------------------------------------------
Func _updateLink()
	$sURL = "https://github.com/KurtisLiggett/Simple-IP-Config/releases/latest"
	ShellExecute($sURL)
	GUICtrlSetColor(@GUI_CtrlId, 0x551A8B)
EndFunc   ;==>_updateLink

;------------------------------------------------------------------------------
; Title........: _onOpenProfiles
; Description..: Open a custom profiles.ini file
; Events.......: File menu
;------------------------------------------------------------------------------
Func _onOpenProfiles()
	$OpenFileFlag = 1
EndFunc   ;==>_onOpenProfiles

;------------------------------------------------------------------------------
; Title........: _onImportProfiles
; Description..: Import profiles from a file
; Events.......: File menu
;------------------------------------------------------------------------------
Func _onImportProfiles()
	$ImportFileFlag = 1
EndFunc   ;==>_onImportProfiles

;------------------------------------------------------------------------------
; Title........: _onExportProfiles
; Description..: export profiles to a file
; Events.......: File menu
;------------------------------------------------------------------------------
Func _onExportProfiles()
	$ExportFileFlag = 1
EndFunc   ;==>_onExportProfiles

;------------------------------------------------------------------------------
; Title........: _onOpenProfLoc
; Description..: open folder containing profiles.ini file
; Events.......: Tools menu
;------------------------------------------------------------------------------
Func _onOpenProfLoc()
;~ 	Local $path = StringRegExp($sProfileName, "(.*)\\", $STR_REGEXPARRAYGLOBALMATCH)
	Local $path = $sProfileName
	Run("explorer.exe /n,/e,/select," & $path)
EndFunc   ;==>_onOpenProfLoc

;------------------------------------------------------------------------------
; Title........: _onOpenNetConnections
; Description..: open the network connections dialog
; Events.......: Tools menu
;------------------------------------------------------------------------------
Func _onOpenNetConnections()
	ShellExecute("ncpa.cpl")
EndFunc   ;==>_onOpenNetConnections

;------------------------------------------------------------------------------
; Title........: _onCopyIp
; Description..: Copy the IP address into clipboard
; Events.......: button click
;------------------------------------------------------------------------------
Func _onCopyIp()
	ClipPut(_GUICtrlIpAddress_Get($ip_Ip))
EndFunc   ;==>_onCopyIp

;------------------------------------------------------------------------------
; Title........: _onPasteIp
; Description..: Paste the IP address from clipboard into the IP box
; Events.......: button click
;------------------------------------------------------------------------------
Func _onPasteIp()
	$sIpString = _GUICtrlIpAddress_Set($ip_Ip, ClipGet())
EndFunc   ;==>_onPasteIp

;------------------------------------------------------------------------------
; Title........: _onCopySubnet
; Description..: Copy the Subnet address into clipboard
; Events.......: button click
;------------------------------------------------------------------------------
Func _onCopySubnet()
	ClipPut(_GUICtrlIpAddress_Get($ip_Subnet))
EndFunc   ;==>_onCopySubnet

;------------------------------------------------------------------------------
; Title........: _onPasteSubnet
; Description..: Paste the Subnet address from clipboard into the IP box
; Events.......: button click
;------------------------------------------------------------------------------
Func _onPasteSubnet()
	$sIpString = _GUICtrlIpAddress_Set($ip_Subnet, ClipGet())
EndFunc   ;==>_onPasteSubnet

;------------------------------------------------------------------------------
; Title........: _onCopyGateway
; Description..: Copy the Gateway address into clipboard
; Events.......: button click
;------------------------------------------------------------------------------
Func _onCopyGateway()
	ClipPut(_GUICtrlIpAddress_Get($ip_Gateway))
EndFunc   ;==>_onCopyGateway

;------------------------------------------------------------------------------
; Title........: _onPasteGateway
; Description..: Paste the Gateway address from clipboard into the IP box
; Events.......: button click
;------------------------------------------------------------------------------
Func _onPasteGateway()
	$sIpString = _GUICtrlIpAddress_Set($ip_Gateway, ClipGet())
EndFunc   ;==>_onPasteGateway

;------------------------------------------------------------------------------
; Title........: _onCopyDnsPri
; Description..: Copy the Gateway address into clipboard
; Events.......: button click
;------------------------------------------------------------------------------
Func _onCopyDnsPri()
	ClipPut(_GUICtrlIpAddress_Get($ip_DnsPri))
EndFunc   ;==>_onCopyDnsPri

;------------------------------------------------------------------------------
; Title........: _onPasteDnsPri
; Description..: Paste the Gateway address from clipboard into the IP box
; Events.......: button click
;------------------------------------------------------------------------------
Func _onPasteDnsPri()
	$sIpString = _GUICtrlIpAddress_Set($ip_DnsPri, ClipGet())
EndFunc   ;==>_onPasteDnsPri

;------------------------------------------------------------------------------
; Title........: _onCopyDnsAlt
; Description..: Copy the Gateway address into clipboard
; Events.......: button click
;------------------------------------------------------------------------------
Func _onCopyDnsAlt()
	ClipPut(_GUICtrlIpAddress_Get($ip_DnsAlt))
EndFunc   ;==>_onCopyDnsAlt

;------------------------------------------------------------------------------
; Title........: _onPasteDnsAlt
; Description..: Paste the Gateway address from clipboard into the IP box
; Events.......: button click
;------------------------------------------------------------------------------
Func _onPasteDnsAlt()
	$sIpString = _GUICtrlIpAddress_Set($ip_DnsAlt, ClipGet())
EndFunc   ;==>_onPasteDnsAlt

;------------------------------------------------------------------------------
; Title........: WM_COMMAND
; Description..: Process WM_COMMAND messages
;                - Toolbar buttons
;                - Listview filter
;                - Combobox selection changed
;------------------------------------------------------------------------------
Func WM_COMMAND($hWnd, $iMsg, $wParam, $lParam)

	Local $ID = BitAND($wParam, 0xFFFF)

	Local $iIDFrom = BitAND($wParam, 0x0000FFFF) ; LoWord - this gives the control which sent the message
	Local $iCode = BitShift($wParam, 16)     ; HiWord - this gives the message that was sent
	Local $tempstring, $iDot1Pos, $iDot2Pos, $iDot3Pos, $SplitString, $temp, $tip

	Switch $hWnd
		Case $hgui
			If $iCode = $EN_CHANGE Then
				Switch $iIDFrom
					Case $input_filter
						GUICtrlSendToDummy($filter_dummy)
				EndSwitch
			ElseIf $iCode = $CBN_CLOSEUP Then    ; check if combo was closed
				Switch $iIDFrom
					Case $combo_adapters
						GUICtrlSendToDummy($combo_dummy)
				EndSwitch
			EndIf
	EndSwitch
	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_COMMAND

;------------------------------------------------------------------------------
; Title........: WM_NOTIFY
; Description..: Process WM_NOTIFY messages
;                - Toolbar tooltips
;                - Listview begin/end label edit
;                - Detect moving from IP address to Subnet mask
;------------------------------------------------------------------------------
Func WM_NOTIFY($hWnd, $iMsg, $wParam, $lParam)
	Local $tNMIA = DllStructCreate($tagNMITEMACTIVATE, $lParam)
	Local $hTarget = DllStructGetData($tNMIA, 'hWndFrom')
	Local $ID = DllStructGetData($tNMIA, 'Code')

	$hWndListView = $list_profiles
	If Not IsHWnd($hWndListView) Then $hWndListView = GUICtrlGetHandle($hWndListView)

	$tNMHDR = DllStructCreate($tagNMHDR, $lParam)
	$hWndFrom = HWnd(DllStructGetData($tNMHDR, "hWndFrom"))
	$iIDFrom = DllStructGetData($tNMHDR, "IDFrom")
	$iCode = DllStructGetData($tNMHDR, "Code")

	Switch $hWnd
		Case $hgui
			Switch $hWndFrom
				Case $hWndListView
					Switch $iCode
						Case $LVN_BEGINLABELEDITA, $LVN_BEGINLABELEDITW ; Start of label editing for an item
							$lv_editIndex = _GUICtrlListView_GetSelectedIndices($list_profiles)
							$lv_oldName = ControlListView($hgui, "", $list_profiles, "GetText", $lv_editIndex)
							$lv_editing = 1
							$lv_startEditing = 0
							$lv_aboutEditing = 0
							Return False
						Case $LVN_ENDLABELEDITA, $LVN_ENDLABELEDITW ; The end of label editing for an item
							$lv_doneEditing = 1
							$lv_editing = 0
							$tInfo = DllStructCreate($tagNMLVDISPINFO, $lParam)
							If _WinAPI_GetAsyncKeyState($VK_RETURN) == 1 Then    ;enter key was pressed
								Local $tBuffer = DllStructCreate("char Text[" & DllStructGetData($tInfo, "TextMax") & "]", DllStructGetData($tInfo, "Text"))
								If StringLen(DllStructGetData($tBuffer, "Text")) Then
									Return True
								Else
									If $lv_newItem = 1 Then
										_GUICtrlListView_DeleteItem(ControlGetHandle($hgui, "", $list_profiles), $lv_editIndex)
										$lv_newItem = 0
									EndIf
									$lv_aboutEditing = 1
								EndIf
							Else
								If $lv_newItem = 1 Then
									_GUICtrlListView_DeleteItem(ControlGetHandle($hgui, "", $list_profiles), $lv_editIndex)
									$lv_newItem = 0
								EndIf
								$lv_aboutEditing = 1
							EndIf
					EndSwitch
				Case $ip_Ip
					Switch $iCode
						Case $IPN_FIELDCHANGED ; Sent when the user changes a field in the control or moves from one field to another
;~ 							$tInfo = DllStructCreate($tagNMIPADDRESS, $lParam)
;~ 							$movetosubnet = DllStructGetData($tInfo, "hWndFrom")
							$movetosubnet = 1
					EndSwitch
			EndSwitch
	EndSwitch
	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_NOTIFY

;~ Global $resizing
;------------------------------------------------------------------------------
; Title........: WM_SIZE
; Description..: Process WM_SIZE messages
;                - Reposition custom buttons
;------------------------------------------------------------------------------
Func WM_SIZE($hWnd, $iMsg, $wParam, $lParam)
	If $hWnd <> $hgui Then
		Return $GUI_RUNDEFMSG
	EndIf

	Local $clientWidth = BitAND($lParam, 0xFFFF)
	Local $clientHeight = BitShift($lParam, 16)

	WinMove($ip_Ip, "", $clientWidth - $IpAddressOffset, Default)
	WinMove($ip_Subnet, "", $clientWidth - $IpAddressOffset, Default)
	WinMove($ip_Gateway, "", $clientWidth - $IpAddressOffset, Default)
	WinMove($ip_DnsPri, "", $clientWidth - $IpAddressOffset, Default)
	WinMove($ip_DnsAlt, "", $clientWidth - $IpAddressOffset, Default)

	GuiFlatButton_SetPos($buttonCopyIp, $clientWidth - $buttonCopyOffset)
	GuiFlatButton_SetPos($buttonCopySubnet, $clientWidth - $buttonCopyOffset)
	GuiFlatButton_SetPos($buttonCopyGateway, $clientWidth - $buttonCopyOffset)
	GuiFlatButton_SetPos($buttonCopyDnsPri, $clientWidth - $buttonCopyOffset)
	GuiFlatButton_SetPos($buttonCopyDnsAlt, $clientWidth - $buttonCopyOffset)

	GuiFlatButton_SetPos($buttonPasteIp, $clientWidth - $buttonPasteOffset)
	GuiFlatButton_SetPos($buttonPasteSubnet, $clientWidth - $buttonPasteOffset)
	GuiFlatButton_SetPos($buttonPasteGateway, $clientWidth - $buttonPasteOffset)
	GuiFlatButton_SetPos($buttonPasteDnsPri, $clientWidth - $buttonPasteOffset)
	GuiFlatButton_SetPos($buttonPasteDnsAlt, $clientWidth - $buttonPasteOffset)

	GuiFlatButton_SetPos($buttonRefresh, $clientWidth - $buttonRefreshOffset)
	GuiFlatButton_SetPos($tbButtonApply, $clientWidth - $buttonApplyOffset)

	_GUICtrlListView_SetColumnWidth($list_profiles, 0, $clientWidth - $guiRightWidth - 24 * $dscale)  ; sets column width
EndFunc   ;==>WM_SIZE

Func _initSize()
	Local $aClientSize = WinGetClientSize($hgui)
	Local $clientWidth = $aClientSize[0]
	Local $clientHeight = $aClientSize[1]

	WinMove($ip_Ip, "", $clientWidth - $IpAddressOffset, Default)
	WinMove($ip_Subnet, "", $clientWidth - $IpAddressOffset, Default)
	WinMove($ip_Gateway, "", $clientWidth - $IpAddressOffset, Default)
	WinMove($ip_DnsPri, "", $clientWidth - $IpAddressOffset, Default)
	WinMove($ip_DnsAlt, "", $clientWidth - $IpAddressOffset, Default)

	GuiFlatButton_SetPos($buttonCopyIp, $clientWidth - $buttonCopyOffset)
	GuiFlatButton_SetPos($buttonCopySubnet, $clientWidth - $buttonCopyOffset)
	GuiFlatButton_SetPos($buttonCopyGateway, $clientWidth - $buttonCopyOffset)
	GuiFlatButton_SetPos($buttonCopyDnsPri, $clientWidth - $buttonCopyOffset)
	GuiFlatButton_SetPos($buttonCopyDnsAlt, $clientWidth - $buttonCopyOffset)

	GuiFlatButton_SetPos($buttonPasteIp, $clientWidth - $buttonPasteOffset)
	GuiFlatButton_SetPos($buttonPasteSubnet, $clientWidth - $buttonPasteOffset)
	GuiFlatButton_SetPos($buttonPasteGateway, $clientWidth - $buttonPasteOffset)
	GuiFlatButton_SetPos($buttonPasteDnsPri, $clientWidth - $buttonPasteOffset)
	GuiFlatButton_SetPos($buttonPasteDnsAlt, $clientWidth - $buttonPasteOffset)

	GuiFlatButton_SetPos($buttonRefresh, $clientWidth - $buttonRefreshOffset)
	GuiFlatButton_SetPos($tbButtonApply, $clientWidth - $buttonApplyOffset)

	_GUICtrlListView_SetColumnWidth($list_profiles, 0, $clientWidth - $guiRightWidth - 24 * $dscale)  ; sets column width
EndFunc

;------------------------------------------------------------------------
; Title........: WM_GETMINMAXINFO
; Description..: Process WM_GETMINMAXINFO messages
;------------------------------------------------------------------------------
Func WM_GETMINMAXINFO($hWnd, $iMsg, $wParam, $lParam)
	If $hWnd <> $hgui Then
		Return $GUI_RUNDEFMSG
	EndIf

	$tagMaxinfo = DllStructCreate("int;int;int;int;int;int;int;int;int;int", $lParam)
	DllStructSetData($tagMaxinfo, 7, $guiMinWidth) ; min X
	DllStructSetData($tagMaxinfo, 8, $guiMinHeight) ; min Y
	DllStructSetData($tagMaxinfo, 9, $guiMaxWidth) ; max X
	DllStructSetData($tagMaxinfo, 10, $guiMaxHeight)  ; max Y
	Return 0
EndFunc   ;==>WM_GETMINMAXINFO
