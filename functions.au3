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

Func _ExitChild($childwin)
	$guiState = WinGetState( $hgui )
	GUISetState(@SW_ENABLE, $hGUI)
	Local $a_ret = DllCall("user32.dll", "int", "DestroyWindow", "hwnd", $childwin)
	;GUIDelete( $childwin )
	If NOT (BitAND($guiState,$WIN_STATE_VISIBLE)) OR BitAND($guiState,$WIN_STATE_MINIMIZED) Then Return
	If BitAND($guiState,$WIN_STATE_EXISTS) AND NOT (BitAND($guiState,$WIN_STATE_ACTIVE)) Then
		_maximize()
	EndIf
EndFunc

Func _checksSICUpdate()
  ; This function checks if there are new releases
  ; on github and request the user to download it

  ; Actual version $options[0][1]

  $github_releases = "https://api.github.com/repos/KurtisLiggett/Simple-IP-Config/releases/latest"

  Local $oHTTP = ObjCreate("WinHttp.WinHttpRequest.5.1")

  $oHTTP.Open("GET", $github_releases, False)
  If (@error) Then
    SetError(1, 0, 0)
  EndIf

  $oHTTP.Send()
  If (@error) Then
    SetError(2, 0, 0)
  EndIf

  If ($oHTTP.Status <> 200) Then
    SetError(3, 0, 0)
  EndIf

  ; Do we wanna add a json parsing lib for the response?
  $cleanedJSON = StringReplace($oHTTP.ResponseText, '"', "")
  $info = StringRegExp($cleanedJSON, '(?:tag_name|browser_download_url):([^\{,}]+)', 3)

  If ($options[0][1] <> $info[0]) Then
    If MsgBox(1, "Simple-IP-Config Update available", "A new version of Simple-IP-Config has been made publicly available. Press ok to download it.") = 1 Then
      ShellExecute($info[1])
    EndIf
  EndIf

EndFunc

Func _updateCombo()
	_setStatus("Updating Adapter List...")
	_loadAdapters()
	_GUICtrlComboBox_ResetContent (GUICtrlGetHandle($combo_adapters))

	If NOT IsArray( $adapters ) Then
		MsgBox( 16, "Error", "There was a problem retrieving the adapters." )
	Else
		_ArraySort($adapters, 0)	; connections sort ascending
		$defaultitem = $adapters[1][0]
		$index = _ArraySearch( $adapters, $options[4][1], 1 )
		If ($index <> -1) Then
			$defaultitem = $adapters[$index][0]
		EndIf
		$aBlacklist = StringSplit($options[7][1], "|")
		For $i=1 to $adapters[0][0]
			$indexBlacklist = _ArraySearch($aBlacklist, $adapters[$i][0], 1)
			if $indexBlacklist <> -1 Then ContinueLoop
			GUICtrlSetData( $combo_adapters, $adapters[$i][0], $defaultitem )
		Next
	EndIf
	ControlSend ($hgui, "", $combo_adapters, "{END}")
	_setStatus("Ready")
EndFunc

Func _blacklistAdd()
	$selected_adapter = GUICtrlRead($combo_adapters)
	$list = GUICtrlRead($blacklistEdit)
;~ 	_ArrayDisplay(StringToASCIIArray ($list))
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
			$newfile &= $propertyFormat[0] & "=" & ($profilelist[$index][1])[0] & @CRLF
			$newfile &= $propertyFormat[1] & "=" & ($profilelist[$index][1])[1] & @CRLF
			$newfile &= $propertyFormat[2] & "=" & ($profilelist[$index][1])[2] & @CRLF
			$newfile &= $propertyFormat[3] & "=" & ($profilelist[$index][1])[3] & @CRLF
			$newfile &= $propertyFormat[4] & "=" & ($profilelist[$index][1])[4] & @CRLF
			$newfile &= $propertyFormat[5] & "=" & ($profilelist[$index][1])[5] & @CRLF
			$newfile &= $propertyFormat[6] & "=" & ($profilelist[$index][1])[6] & @CRLF
			$newfile &= $propertyFormat[7] & "=" & ($profilelist[$index][1])[7] & @CRLF
			$newfile &= $propertyFormat[8] & "=" & ($profilelist[$index][1])[8] & @CRLF
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
	; -- check for double click --
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
								_GUICtrlListView_DeleteItem (GUICtrlGetHandle($list_profiles), $dragitem)
								_GUICtrlListView_InsertItem (GUICtrlGetHandle($list_profiles), $dragtext, $newitem)
							Case $dragitem > $newitem
								_GUICtrlListView_DeleteItem (GUICtrlGetHandle($list_profiles), $dragitem)
								_GUICtrlListView_InsertItem (GUICtrlGetHandle($list_profiles), $dragtext, $newitem)
						EndSelect
						$newtext = ControlListView($hgui, "", $list_profiles, "Select", $newitem)
					EndIf
				EndIf
			EndIf
		EndIf
    EndIf
	$dragging = False

EndFunc


;helper -
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
		$aToSplit = StringSplit ($sFileRead, "["&$initoName&"]", 1)
		if @error Then
			Return 1
		EndIf
		$sLeft = $aToSplit[1]

		$aFromSplit = StringSplit ($aToSplit[2], "["&$inifromName&"]", 1)
		if @error Then
			Return 1
		EndIf
		$sMid = "["&$initoName&"]" & $aFromSplit[1]

		$strNextPos = StringInStr ($aFromSplit[2], "[")
		If $strNextPos = 0 Then
			$sSection = "["&$inifromName&"]" & $aFromSplit[2]
			$sRight = ""
		Else
			$sSection = "["&$inifromName&"]" & StringLeft($aFromSplit[2], $strNextPos-1)
			$sRight = StringRight( $aFromSplit[2], StringLen($aFromSplit[2])-$strNextPos+1 )
		EndIf
		$sNewFile = $sLeft & $sSection & $sMid & $sRight

	ElseIf $strFromPos < $strToPos Then
		$aFromSplit = StringSplit ($sFileRead, "["&$inifromName&"]", 1)
		if @error Then
			Return 1
		EndIf
		$sBeforeFrom = $aFromSplit[1]

		$strNextPos = StringInStr ($aFromSplit[2], "[")
		$sSection = "["&$inifromName&"]" & StringLeft($aFromSplit[2], $strNextPos-1)

		$sAfterFrom = StringRight($aFromSplit[2], StringLen($aFromSplit[2])-$strNextPos+1)
		$strToPos = StringInStr ($sAfterFrom, "["&$initoName&"]")
		$strNextPos = StringInStr ($sAfterFrom, "[", 0, 1, $strToPos+1)
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

	$dhcp = (GUICtrlRead($radio_IpAuto) = $GUI_CHECKED)?1:0
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

	$dnsDhcp = (GUICtrlRead($radio_DnsAuto) = $GUI_CHECKED)?1:0
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
			$cmdend = (_OSVersion() >= 6)?" " & $cmdReg & " no":"$cmdReg"
			_asyncNewCmd($cmd1&$cmd2&$cmd3&$cmdend, $message, 1)
			If $dnsa <> "" Then
				$cmd1 = $cmd1_2
				$cmd3 = " " & $dnsa
				$message = "Setting alternate DNS server..."
				$cmdend = (_OSVersion() >= 6)?" 2 no":""
				_asyncNewCmd($cmd1&$cmd2&$cmd3&$cmdend, $message, 1)
			EndIf
		ElseIf $dnsa <> "" Then
			$cmd1 = $cmd1_1
			$cmd3 = " static " & $dnsp
			$message = "Setting preferred DNS server..."
			$cmdend = (_OSVersion() >= 6)?" " & $cmdReg & " no":"$cmdReg"
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
EndFunc   ;==>_OSVersion


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
	$lv_newName = ControlListView ( $hgui, "", $list_profiles, "GetText", $lv_editIndex )
	;ConsoleWrite( $lv_oldName & " " & $lv_newName )
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
		_GUICtrlListView_SetItemText ( $list_profiles, $lv_editIndex, $lv_oldName )
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

;helper - the built-in inirenamesection function moves the section to the end of the file.
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
		ControlListView ( $hgui, "", $list_profiles, "Select", $selIndex-1 )
	Else
		ControlListView ( $hgui, "", $list_profiles, "Select", $selIndex )
	EndIf
EndFunc


Func _new()
;	$yesno = MsgBox($MB_YESNO,"Warning!","The profile name already exists!" & @CRLF & "Do you wish to overwrite the profile?")
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
	;$yesno = MsgBox($MB_YESNO,"Warning!","The profile name already exists!" & @CRLF & "Do you wish to overwrite the profile?")
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
		IF not $init OR ($init and not $showWarning) Then
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
			;ConsoleWrite($index&@CRLF)
			GUICtrlSetState( $radio_IpMan, $GUI_CHECKED )
			GUICtrlSetState( $radio_IpAuto, _StrToState( ($profilelist[$index][1])[0] ) )
			_ctrlSetIP($ip_Ip, ($profilelist[$index][1])[1])
			_ctrlSetIP($ip_Subnet, ($profilelist[$index][1])[2])
			_ctrlSetIP($ip_Gateway, ($profilelist[$index][1])[3])

			GUICtrlSetState( $radio_DnsMan, $GUI_CHECKED )
			GUICtrlSetState( $radio_DnsAuto, _StrToState( ($profilelist[$index][1])[4] ) )
			_ctrlSetIP($ip_DnsPri, ($profilelist[$index][1])[5])
			_ctrlSetIP($ip_DnsAlt, ($profilelist[$index][1])[6])

			GUICtrlSetState( $ck_dnsReg, _StrToState( ($profilelist[$index][1])[7] ) )

			If ($profilelist[$index][1])[8] <> "" and ($options[6][1] = 1 OR $options[6][1] = "true") Then
				$adapterIndex = _ArraySearch($adapters, ($profilelist[$index][1])[8])
				IF $adapterIndex <> -1 Then
					ControlCommand ( $hgui, "", $combo_adapters, "SelectString", ($profilelist[$index][1])[8] )
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

;helper
Func _ctrlGetIP($id)
	$ret = _GUICtrlIpAddress_Get( $id )
	If $ret = "0.0.0.0" Then
		$ret = ""
	EndIf

	Return $ret
EndFunc

;helper
Func _ctrlSetIP($id, $ip)
	If $ip <> "" Then
		_GUICtrlIpAddress_Set( $id, $ip )
	Else
		_GUICtrlIpAddress_ClearAddress( $id )
	EndIf
EndFunc

;helper
Func _StrToState($str)
	If $str = "true" or $str = "1" Then
		return $GUI_CHECKED
	Else
		return $GUI_UNCHECKED
	EndIf
EndFunc

;helper
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
	;_ArrayDisplay($profilelist)
	Local $aArray[1] = [0]
	_ArrayDelete( $aArray, 0 )
	$strPattern = GUICtrlRead( $input_filter )
	_GUICtrlListView_DeleteAllItems( $list_profiles )

	$aNames = _getNames()
	if $strPattern <> "" Then
		$pattern = '(?i)(?U)' & StringReplace( $strPattern, "*", ".*")
		;MsgBox(0,"",$pattern)
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

	;_ArrayDisplay($aArray)
EndFunc


Func _SendToTray()
	GUISetState(@SW_MINIMIZE, $hGUI)
	GUISetState(@SW_HIDE, $hGUI)
	TrayItemSetText ( $RestoreItem, "Restore" )
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



; -- asynchronous Processes - keep track of running commands, but don't block the program
Func _asyncNewCmd($sCmd, $sMessage="", $addToQueue=-1)
	If not ProcessExists ( $iPID ) Then
		$sStdOut = ""
		$sStdErr = ""
		_GUICtrlToolbar_EnableButton($hToolbar, $tb_apply, False)
		ConsoleWrite($sCmd&@CRLF)
		$showWarning = 0
;~ 		$iPID = Run(@ComSpec & " /k " & $sCmd & "& pause", "", @SW_HIDE, $STDIN_CHILD+$STDERR_MERGED)
		$iPID = Run(@ComSpec & " /k " & $sCmd & "& echo simple ip config cmd done", "", @SW_HIDE, $STDIN_CHILD+$STDERR_MERGED)
		$pRuntime = TimerInit()
		$pIdle = 0
		If $sMessage <> "" Then
			_setStatus($sMessage)
		EndIf
		;Sleep(500)
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
	$pExists = ProcessExists ( $iPID )
	If $pExists Then
		$sStdOut = $sStdOut & StdoutRead($iPID)
		$sStdErr = $sStdErr & StderrRead ($iPID)

;~ 		ConsoleWrite($sStdOut&@CRLF)
		if StringInStr($sStdOut, "simple ip config cmd done") Then	;look for our unique phrase to signal we're done
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
	;~ 		ConsoleWrite($sStdOut&@CRLF)
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
    ; Generated by AutoIt Scriptomatic
    $Domain = ''

	If $screenshot Then
		$Domain = "Domain: ________"
		return $Domain
	EndIf

    ;$objWMIService = ObjGet("winmgmts:\\" & $strComputer & "\root\CIMV2")
    If Not IsObj($objWMI) Then Return SetError(1, 0, '')
    $colItems = $objWMI.ExecQuery("SELECT * FROM Win32_ComputerSystem", "WQL", _
                                            $wbemFlagReturnImmediately + $wbemFlagForwardOnly)

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
	if WinActive($hgui) and _WinAPI_GetAncestor (_WinAPI_GetFocus(),$GA_PARENT ) = ControlGetHandle($hgui,"", $ip_Subnet) Then
		If _GUICtrlIpAddress_Get($ip_Subnet) = "0.0.0.0" Then
			_GUICtrlIpAddress_Set($ip_Subnet, "255.255.255.0")
		EndIf
	EndIf
	$movetosubnet = 0
EndFunc

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified By....: Kurtis Liggett
; ===============================================================================================================================
Func _GUICtrlIpAddress_SetFontByHeight($hWnd, $sFaceName = "Arial", $iFontSize = 12, $iFontWeight = 400, $bFontItalic = False)
	Local $hDC = _WinAPI_GetDC(0)
	;Local $iHeight = Round(($iFontSize * _WinAPI_GetDeviceCaps($hDC, $__IPADDRESSCONSTANT_LOGPIXELSX)) / 72, 0)
	Local $iHeight = $iFontSize
	_WinAPI_ReleaseDC(0, $hDC)

	Local $tFont = DllStructCreate($tagLOGFONT)
	DllStructSetData($tFont, "Height", $iHeight)
	DllStructSetData($tFont, "Weight", $iFontWeight)
	DllStructSetData($tFont, "Italic", $bFontItalic)
	DllStructSetData($tFont, "Underline", False) ; font underline
	DllStructSetData($tFont, "Strikeout", False) ; font strikethru
	DllStructSetData($tFont, "Quality", $__IPADDRESSCONSTANT_PROOF_QUALITY)
	DllStructSetData($tFont, "FaceName", $sFaceName)

	Local $hFont = _WinAPI_CreateFontIndirect($tFont)
	_WinAPI_SetFont($hWnd, $hFont)
EndFunc   ;==>_GUICtrlIpAddress_SetFont
