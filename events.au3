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
#EndRegion

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
	_GDIPlus_Shutdown()

	; save window position in ini file
	If NOT BITAND(WinGetState($hgui), $WIN_STATE_MINIMIZED) Then
		$currentWinPos = WinGetPos($hgui)
		Options_SetValue($options, $OPTIONS_PositionX, $currentWinPos[0])
		Options_SetValue($options, $OPTIONS_PositionY, $currentWinPos[1])
		IniWriteSection($sProfileName, "options", $options, 0)
	EndIf

	Exit
EndFunc

Func _onCreateLink()
	_CreateLink()
EndFunc

;------------------------------------------------------------------------------
; Title........: _onExitChild
; Description..: Close any child window
; Events.......: child window GUI_EVENT_CLOSE, OK/Cancel button
;------------------------------------------------------------------------------
Func _onExitChild()
	_ExitChild(@GUI_WinHandle)
EndFunc

;------------------------------------------------------------------------------
; Title........: _onExitBlacklistOk
; Description..: save the the Blacklist child window data,
;                then call the exit function
; Events.......: Blacklist window 'Save' button
;------------------------------------------------------------------------------
Func _onExitBlacklistOk()
	$guiState = WinGetState( $hgui )
	$newBlacklist = ""
	$itemCount = _GUICtrlListView_GetItemCount($blacklistLV)

	For $i = 0 To $itemCount-1
		If _GUICtrlListView_GetItemChecked($blacklistLV, $i) Then
			$newBlacklist &= _GUICtrlListView_GetItemTextString($blacklistLV, $i) & "|"
		EndIf
	Next
	$newBlacklist = StringLeft($newBlacklist, StringLen($newBlacklist)-1)

	$newBlacklist = iniNameEncode($newBlacklist)
	Options_SetValue($options, $OPTIONS_AdapterBlacklist, $newBlacklist)
	$keyname = Options_GetName($options, $OPTIONS_AdapterBlacklist)
	$keyvalue = Options_GetValue($options, $OPTIONS_AdapterBlacklist)
	IniWrite($sProfileName, "options", $keyname, $keyvalue)

	_ExitChild(@GUI_WinHandle)
	_updateCombo()
EndFunc

;------------------------------------------------------------------------------
; Title........: _OnTrayClick
; Description..: Restore or hide program to system tray
; Events.......: single left-click on tray icon
;------------------------------------------------------------------------------
Func _OnTrayClick()
	If TrayItemGetText( $RestoreItem ) = "Restore" Then
		_maximize()
	Else
		_SendToTray()
	EndIf
EndFunc

;------------------------------------------------------------------------------
; Title........: _OnRestore
; Description..: Restore or hide program to system tray
; Events.......: 'Restore' item in tray right-click menu
;------------------------------------------------------------------------------
Func _OnRestore()
	If TrayItemGetText( $RestoreItem ) = "Restore" Then
		_maximize()
	Else
		_SendToTray()
	EndIf
EndFunc

;------------------------------------------------------------------------------
; Title........: _onBlacklist
; Description..: Create the 'Hide adapters' child window
; Events.......: 'Hide adapters' item in the 'View' menu
;------------------------------------------------------------------------------
Func _onBlacklist()
	_blacklist()
EndFunc

;------------------------------------------------------------------------------
; Title........: _onBlacklistAdd
; Description..: Add selected adapter to the hide adapters list
; Events.......: 'Add Selected Adapter' button
;------------------------------------------------------------------------------
;~ Func _onBlacklistAdd()
;~ 	_blacklistAdd()
;~ EndFunc

;------------------------------------------------------------------------------
; Title........: _onRadio
; Description..: Update radio button selections and states
; Events.......: Any radio button state changed
;------------------------------------------------------------------------------
Func _onRadio()
	_radios()
EndFunc

;------------------------------------------------------------------------------
; Title........: _onSelect
; Description..: Set IP address information from profile
; Events.......: Click on profile list item
;------------------------------------------------------------------------------
Func _onSelect()
	_setProperties()
EndFunc

;------------------------------------------------------------------------------
; Title........: _onApply
; Description..: Apply the selected profile
; Events.......: File menu 'Apply profile' button, toolbar 'Apply' button
;------------------------------------------------------------------------------
Func _onApply()
	_apply_GUI()
EndFunc

;------------------------------------------------------------------------------
; Title........: _onArrangeAz
; Description..: Arrange profiles in alphabetical order
; Events.......: Profiles listview context menu item
;------------------------------------------------------------------------------
Func _onArrangeAz()
	_arrange()
EndFunc

;------------------------------------------------------------------------------
; Title........: _onArrangeZa
; Description..: Arrange profiles in reverse alphabetical order
; Events.......: Profiles listview context menu item
;------------------------------------------------------------------------------
Func _onArrangeZa()
	_arrange(1)
EndFunc

;------------------------------------------------------------------------------
; Title........: _onRename
; Description..: Start editing profile name for the selected listview item
; Events.......: Profiles listview context menu item, F2 accelerator,
;                File menu 'Rename' item
;------------------------------------------------------------------------------
Func _onRename()
	If NOT _ctrlHasFocus($list_profiles) Then
		Return
	EndIf
	$Index = _GUICtrlListView_GetSelectedIndices ($list_profiles)
	_GUICtrlListView_EditLabel( ControlGetHandle($hgui, "", $list_profiles), $Index )
EndFunc

;------------------------------------------------------------------------------
; Title........: _onNewItem
; Description..: Create new listview item and start editing the name
; Events.......: Toolbar button, File menu 'New' item
;------------------------------------------------------------------------------
Func _onNewItem()
	$newname = "New Item"
	;Local $profileNames = _getNames()
	Local $profileNames = Profiles_GetNames($profiles)
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
	ControlListView ( $hgui, "", $list_profiles, "Select", $index-1 )
	_GUICtrlListView_EditLabel( ControlGetHandle($hgui, "", $list_profiles), $index-1 )
EndFunc

;------------------------------------------------------------------------------
; Title........: _onSave
; Description..: Save the current settings to the selected profile
; Events.......: Toolbar button, File menu 'Save' item, Ctrl+s accelerator
;------------------------------------------------------------------------------
Func _onSave()
	_save()
EndFunc

;------------------------------------------------------------------------------
; Title........: _onDelete
; Description..: Delete the selected profile
; Events.......: Toolbar button, Del accelerator
;------------------------------------------------------------------------------
Func _onDelete()
	_delete()
EndFunc

;------------------------------------------------------------------------------
; Title........: _onClear
; Description..: Clear the current address fields
; Events.......: Toolbar button, File menu 'Clear' item
;------------------------------------------------------------------------------
Func _onClear()
	_clear()
EndFunc

;------------------------------------------------------------------------------
; Title........: _onRefresh
; Description..: Refresh the profiles list and current IP info
; Events.......: Toolbar button, View menu 'Refresh' item
;------------------------------------------------------------------------------
Func _onRefresh()
	$showWarning = 0
	$index = ControlListView($hgui, "", $list_profiles, "GetSelected")
	_refresh()
	ControlListView($hgui, "", $list_profiles, "Select", $index)
EndFunc

;------------------------------------------------------------------------------
; Title........: _onLvDel
; Description..: Delete the selected listview item
; Events.......: File menu Delete item, listview context menu Delete item
;------------------------------------------------------------------------------
Func _onLvDel()
	if _ctrlHasFocus($list_profiles) Then
		_delete()
	Else
		GUISetAccelerators(0)
		Send("{DEL}")
		GUISetAccelerators($aAccelKeys)
	EndIf
EndFunc

;------------------------------------------------------------------------------
; Title........: _onLvUp
; Description..: Move listview selection up 1 index and get the profile info
; Events.......: UP key accelerator
;------------------------------------------------------------------------------
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

;------------------------------------------------------------------------------
; Title........: _onLvDown
; Description..: Move listview selection down 1 index and get the profile info
; Events.......: DOWN key accelerator
;------------------------------------------------------------------------------
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

;------------------------------------------------------------------------------
; Title........: _onLvEnter
; Description..: Apply the selected profile
; Events.......: Enter key on listview item
;------------------------------------------------------------------------------
Func _onLvEnter()
	If Not $lv_editing Then
		_apply_GUI()
	Else
		GUISetAccelerators(0)
		Send("{ENTER}")
		GUISetAccelerators($aAccelKeys)
	EndIf
EndFunc

;------------------------------------------------------------------------------
; Title........: _onTray
; Description..: Hide or show main GUI window
; Events.......: Toolbar button, View menu "Send to tray" item
;------------------------------------------------------------------------------
Func _onTray()
	_SendToTray()
EndFunc

;------------------------------------------------------------------------------
; Title........: _onPull
; Description..: Get current IP information from adapter
; Events.......: Tools menu "Pull from adapter" item
;------------------------------------------------------------------------------
Func _onPull()
	_Pull()
EndFunc

;------------------------------------------------------------------------------
; Title........: _onDisable
; Description..: Disable / Enable the selected adapter
; Events.......: Tools menu "Disable adapter" item
;------------------------------------------------------------------------------
Func _onDisable()
	_disable()
EndFunc

;------------------------------------------------------------------------------
; Title........: _onRelease
; Description..: Release DHCP for the selected adapter
; Events.......: Tools menu "Release DHCP" item
;------------------------------------------------------------------------------
Func _onRelease()
	_releaseDhcp()
EndFunc

;------------------------------------------------------------------------------
; Title........: _onRenew
; Description..: Renew DHCP for the selected adapter
; Events.......: Tools menu "Renew DHCP" item
;------------------------------------------------------------------------------
Func _onRenew()
	_renewDhcp()
EndFunc

;------------------------------------------------------------------------------
; Title........: _onCycle
; Description..: Release DHCP followed by Renew DHCP for the selected adapter
; Events.......: Tools menu "Release/renew cycle" item
;------------------------------------------------------------------------------
Func _onCycle()
	_cycleDhcp()
EndFunc

;------------------------------------------------------------------------------
; Title........: _onSettings
; Description..: Create the settings child window
; Events.......: Tools menu "Settings" item
;------------------------------------------------------------------------------
Func _onSettings()
	_settings()
EndFunc

;------------------------------------------------------------------------------
; Title........: _onHelp
; Description..: Navigate to documentation link <-- needs to be created!
; Events.......: Help menu "Online Documentation" item
;------------------------------------------------------------------------------
Func _onHelp()
	ShellExecute('https://github.com/KurtisLiggett/Simple-IP-Config/wiki')
EndFunc

Func _onUpdateCheckItem()
	_checksSICUpdate(1)
EndFunc

;------------------------------------------------------------------------------
; Title........: _onDebugItem
; Description..: Create debug child window
; Events.......: Help menu "Debug Information" item
;------------------------------------------------------------------------------
Func _onDebugItem()
	_debugWindow()
EndFunc

;------------------------------------------------------------------------------
; Title........: _onChangelog
; Description..: Create change log child window
; Events.......: Help menu "Show Change Log" item
;------------------------------------------------------------------------------
Func _onChangelog()
	_changeLog()
EndFunc

;------------------------------------------------------------------------------
; Title........: _onAbout
; Description..: Create the About child window
; Events.......: Help menu "About Simple IP Config" item, tray right-click menu
;------------------------------------------------------------------------------
Func _onAbout()
	_about()
EndFunc

;------------------------------------------------------------------------------
; Title........: _onFilter
; Description..: Filter the profiles listview
; Events.......: Filter input text change
;------------------------------------------------------------------------------
Func _onFilter()
	_filterProfiles()
EndFunc

;------------------------------------------------------------------------------
; Title........: _OnCombo
; Description..: Update adapter information, save last used adapter to profiles.ini
; Events.......: Combobox selection change
;------------------------------------------------------------------------------
Func _OnCombo()
	_updateCurrent()
	$adap = GUICtrlRead($combo_adapters)
	$iniAdap = iniNameEncode($adap)
	$keyname = Options_GetName($options, $OPTIONS_StartupAdapter)
	$ret = IniWrite( $sProfileName, "options", $keyname, $iniAdap )
	If $ret = 0 Then
		_setStatus("An error occurred while saving the selected adapter", 1)
	Else
		Options_SetValue($options, $OPTIONS_StartupAdapter, $adap)
	EndIf
EndFunc

;------------------------------------------------------------------------------
; Title........: _OnToolbarButton
; Description..: Check to see which toolbar button was clicked
; Events.......: Any toolbar button click
;------------------------------------------------------------------------------
Func _OnToolbarButton()
	$ID = GUICtrlRead($ToolbarIDs)
	Switch $ID
		Case $tb_apply ; Button 1
			_apply_GUI()
		Case $tb_refresh ; Button 2
			_onRefresh()
		Case $tb_add ; Button 3
			_onNewItem()
		Case $tb_save ; Button 4
			_onSave()
		Case $tb_delete ; Button 5
			_onDelete()
		Case $tb_clear ; Button 5
			_onClear()
		Case Else

	EndSwitch
EndFunc

;------------------------------------------------------------------------------
; Title........: _OnToolbar2Button
; Description..: Check to see which right toolbar button was clicked
; Events.......: Any right toolbar button click
;------------------------------------------------------------------------------
Func _OnToolbar2Button()
	$ID = GUICtrlRead($Toolbar2IDs)
	Switch $ID
		Case $tb_settings ; Button 5
			_onSettings()
		Case $tb_tray ; Button 5
			_onTray()
		Case Else

	EndSwitch
EndFunc

;------------------------------------------------------------------------------
; Title........: _iconLink
; Description..: Open browser and go to icon website
; Events.......: Click on link in About window
;------------------------------------------------------------------------------
Func _iconLink()
	ShellExecute('http://www.aha-soft.com/')
	GUICtrlSetColor(@GUI_CtrlId,0x551A8B)
EndFunc

;------------------------------------------------------------------------------
; Title........: _updateLink
; Description..: Open browser and go to latest version
; Events.......: Click on link in update window
;------------------------------------------------------------------------------
Func _updateLink()
	$sURL = "https://github.com/KurtisLiggett/Simple-IP-Config/releases/latest"
	ShellExecute($sURL)
	GUICtrlSetColor(@GUI_CtrlId,0x551A8B)
EndFunc

;------------------------------------------------------------------------------
; Title........: _onOpenProfiles
; Description..: Open a custom profiles.ini file
; Events.......: File menu
;------------------------------------------------------------------------------
Func _onOpenProfiles()
	$OpenFileFlag = 1
EndFunc

;------------------------------------------------------------------------------
; Title........: _onImportProfiles
; Description..: Import profiles from a file
; Events.......: File menu
;------------------------------------------------------------------------------
Func _onImportProfiles()
	$ImportFileFlag = 1
EndFunc

;------------------------------------------------------------------------------
; Title........: _onExportProfiles
; Description..: export profiles to a file
; Events.......: File menu
;------------------------------------------------------------------------------
Func _onExportProfiles()
	$ExportFileFlag = 1
EndFunc

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
        Case $hTool
            Switch $ID
                Case $tb_apply To $tb_clear ; Button 1 - Button 8
                    GUICtrlSendToDummy($ToolbarIDs, $ID)
                Case Else

            EndSwitch
        Case $hTool2
			Switch $ID
				Case $tb_settings To $tb_tray ; Button 1 - Button 8
                    GUICtrlSendToDummy($Toolbar2IDs, $ID)
                Case Else

            EndSwitch
		Case Else
			If $iCode = $EN_CHANGE Then
				Switch $iIDFrom
					Case $input_filter
						GUICtrlSendToDummy($filter_dummy)
				EndSwitch
			ElseIf $iCode = $CBN_CLOSEUP Then	; check if combo was closed
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

;~                          Local $tNMTBGIT = DllStructCreate($tagNMTBGETINFOTIP, $lParam)
                            Local $tNMTBGIT = DllStructCreate($tagNMHDR & ';ptr Text;int TextMax;int Item;lparam lParam;', $lParam)
                            Local $Item = DllStructGetData($tNMTBGIT, 'Item')
                            Local $Text = ''

                            Switch $Item
                                Case $tb_apply ; Button 1
                                    $Text = 'Apply'
                                Case $tb_refresh ; Button 2
                                    $Text = 'Refresh'
                                Case $tb_add ; Button 3
                                    $Text = 'Create new profile'
                                Case $tb_save ; Button 4
                                    $Text = 'Save profile'
                                Case $tb_delete ; Button 5
                                    $Text = 'Delete profile'
                                Case $tb_clear ; Button 6
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

;~                          Local $tNMTBGIT = DllStructCreate($tagNMTBGETINFOTIP, $lParam)
                            Local $tNMTBGIT = DllStructCreate($tagNMHDR & ';ptr Text;int TextMax;int Item;lparam lParam;', $lParam)
                            Local $Item = DllStructGetData($tNMTBGIT, 'Item')
                            Local $Text = ''

                            Switch $Item
                                Case $tb_settings ; Button 1
                                    $Text = 'Settings'
                                Case $tb_tray ; Button 2
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
						Case $LVN_BEGINLABELEDITA, $LVN_BEGINLABELEDITW ; Start of label editing for an item
							$lv_editIndex = _GUICtrlListView_GetSelectedIndices ($list_profiles)
							$lv_oldName = ControlListView ( $hgui, "", $list_profiles, "GetText", $lv_editIndex )
							$lv_editing = 1
							$lv_startEditing = 0
							$lv_aboutEditing = 0
							Return False
						Case $LVN_ENDLABELEDITA, $LVN_ENDLABELEDITW ; The end of label editing for an item
							$lv_doneEditing = 1
							$lv_editing = 0
							$tInfo = DllStructCreate($tagNMLVDISPINFO, $lParam)
							If _WinAPI_GetAsyncKeyState($VK_RETURN) == 1 Then	;enter key was pressed
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
						Case $IPN_FIELDCHANGED ; Sent when the user changes a field in the control or moves from one field to another
;~ 							$tInfo = DllStructCreate($tagNMIPADDRESS, $lParam)
;~ 							$movetosubnet = DllStructGetData($tInfo, "hWndFrom")
							$movetosubnet = 1
					EndSwitch
			EndSwitch
    EndSwitch
    Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_NOTIFY
