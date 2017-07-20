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

Func _onExit()
	_GDIPlus_Shutdown()

	; save window position in ini file
	If NOT BITAND(WinGetState($hgui), $WIN_STATE_MINIMIZED) Then
		ConsoleWrite("saving..."&@CRLF)
		$currentWinPos = WinGetPos($winName & " " & $winVersion)
		$options[8][1] = $currentWinPos[0]
		$options[9][1] = $currentWinPos[1]
		IniWriteSection("profiles.ini", "options", $options, 0)
	EndIf

	Exit
EndFunc

Func _onTab()
	ConsoleWrite(_WinAPI_GetFocus() & " | " & ControlGetHandle("","", $ip_Ip) & " | " & $ip_Ip & " | " & ControlGetFocus("","") & @CRLF)
	If _WinAPI_GetFocus() = ControlGetHandle("","", $ip_Ip) Then

	Else
		GUISetAccelerators(0)
		Send("{TAB}")
		GUISetAccelerators($aAccelKeys)
	EndIf
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

Func _onExitDebug()
	_ExitChild($debugChild)
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
	_apply_GUI()
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
	$Index = _GUICtrlListView_GetSelectedIndices ($list_profiles)
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
	ControlListView ( $hgui, "", $list_profiles, "Select", $index-1 )
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
		_apply_GUI()
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

Func _onUpdateCheckItem()
	_checksSICUpdate(1)
EndFunc

Func _onDebugItem()
	_debugWindow()
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

Func _iconLink()
	ShellExecute('http://www.aha-soft.com/')
	GUICtrlSetColor(@GUI_CtrlId,0x551A8B)
EndFunc


; ---- WINDOWS MESSAGES

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


