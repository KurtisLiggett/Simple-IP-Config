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


;==============================================================================
; Filename:		functions.au3
; Description:	- most functions related to doing something in the program
;==============================================================================
Global $oMyError = ObjEvent("AutoIt.Error","MyErrFunc")

Func MyErrFunc()
  SetError(1)
EndFunc

;------------------------------------------------------------------------------
; Title...........: RunCallback
; Description.....: Callback function that runs after a command is finished
;                    *commands set IP address info through a hidden command
;                     prompt. They run without blocking the program, so
;                     we need a callback function to decide how to proceed
;                     when the command is done running.
;
; Parameters......: $sDescription  		-Command description
;                   $sNextDescription	-Next command description
;                   $sStdOut       		-STD output string from command prompt
; Return value....:
;------------------------------------------------------------------------------
Func RunCallback($sDescription, $sNextDescription, $sStdOut)

	If $sStdOut = "Command timeout" Then
		_setStatus("Action timed out!  Command Aborted.", 1)
		If asyncRun_isIdle() Then
			_GUICtrlToolbar_EnableButton($hToolbar, $tb_apply, True)
		Else
			_GUICtrlToolbar_EnableButton($hToolbar, $tb_apply, False)
		EndIf
	Else
		If StringInStr($sStdOut, "failed") Then
			_setStatus(StringReplace($sStdOut, @CRLF, " "), 1)
			IF asyncRun_isIdle() Then
				_GUICtrlToolbar_EnableButton($hToolbar, $tb_apply, True)
			EndIf
		Else
			If $sDescription = $sNextDescription Then
				If not $showWarning Then _setStatus($sNextDescription)
				_GUICtrlToolbar_EnableButton($hToolbar, $tb_apply, False)
			ElseIf asyncRun_isIdle() Then
				_GUICtrlToolbar_EnableButton($hToolbar, $tb_apply, True)
				If not $showWarning Then _setStatus("Ready")
				_GUICtrlToolbar_EnableButton($hToolbar, $tb_apply, True)
			Else
				If not $showWarning Then _setStatus($sNextDescription)
				_GUICtrlToolbar_EnableButton($hToolbar, $tb_apply, False)
			EndIf
		EndIf
	EndIf

	_updateCurrent()
EndFunc

;------------------------------------------------------------------------------
; Title...........: _ExitChild
; Description.....: Destroy the child window and enable the main GUI
;
; Parameters......: $childwin  -child window handle
; Return value....:
;------------------------------------------------------------------------------
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

;------------------------------------------------------------------------------
; Title...........: _checksSICUpdate
; Description.....: Check for updates/ask to download
;
; Parameters......: $manualCheck  -manually run check from menu item
; Return value....:
;------------------------------------------------------------------------------
Func _checksSICUpdate($manualCheck=0)
  ; This function checks if there are new releases on github and request the user to download it

  $github_releases = "https://api.github.com/repos/KurtisLiggett/Simple-IP-Config/releases/latest"

  Local $oHTTP = ObjCreate("WinHttp.WinHttpRequest.5.1")
  $oHTTP.Open("GET", $github_releases, False)
  If (@error) Then SetError(1, 0, 0)

  $oHTTP.Send()
  If (@error) Then SetError(2, 0, 0)

  If ($oHTTP.Status <> 200) Then SetError(3, 0, 0)

  $cleanedJSON = StringReplace($oHTTP.ResponseText, '"', "")
  $info = StringRegExp($cleanedJSON, '(?:tag_name|browser_download_url):([^\{,}]+)', 3)

  If (@error) Then
    MsgBox(16, "Error", "We encountered an error retrieving the update. Check your internet connection.")
  Else
	$updateText = "Your version is: " & $winVersion & @CRLF & _
		"Current version is: " & $info[0] & @CRLF & @CRLF
    If ($winVersion <> $info[0]) Then
		$updateText &= "A newer version is available. Press ok to download it."

		If MsgBox(1, "Simple IP Config Update available", $updateText) = 1 Then ShellExecute($info[1])
	Else
		$updateText &= "No update is available."
		if $manualCheck Then MsgBox(0, "Simple IP Config Update", $updateText)
    EndIf
  Endif

;  $newFilename = "Simple.IP.Config."&$info[0]&".exe"
;  If ($winVersion <> $info[0]) Then
;    If MsgBox(1, "Simple-IP-Config Update available", "A new version of Simple-IP-Config has been made publicly available. Press ok to download and install it.") = 1 Then
;	  $res = InetGet ($info[1], $newFilename)
;  		If $res > 0 Then
;  			_DoUpdate($newFilename)
;  		EndIf
;    EndIf
;  Else
;  	If FileExists('simple_ip_config_updater.cmd') Then
;  		FileDelete('simple_ip_config_updater.cmd')  ; delete updater
;  	EndIf
;  EndIf

EndFunc

Func _DoUpdate($newFilename)
	$fileStr = '@echo off' & @CRLF & _
				'taskkill /pid ' & WinGetProcess($hgui) & @CRLF & _	; kill running instance
				'del /Q "' & @ScriptFullPath & '"' & @CRLF & _ ; delete old version
				'start "" "' & $newFilename & '"' ; start new version
	$filename = 'simple_ip_config_updater.cmd'
	$file = FileOpen($filename, 2) ; open/overwrite
	FileWrite($file, $fileStr)
	FileClose($file)

	$iPID = Run(@ComSpec & " /k " & $filename, "", @SW_HIDE, $STDIN_CHILD+$STDERR_MERGED)
EndFunc

;------------------------------------------------------------------------------
; Title...........: _updateCombo
; Description.....: UpdateUpdate the adapters list
;
; Parameters......:
; Return value....:
;------------------------------------------------------------------------------
Func _updateCombo()
	_setStatus("Updating Adapter List...")
	$adapters = _loadAdapters()
	_GUICtrlComboBox_ResetContent (GUICtrlGetHandle($combo_adapters))

	If NOT IsArray( $adapters ) Then
		MsgBox( 16, "Error", "There was a problem retrieving the adapters." )
	Else
		_ArraySort($adapters, 0)	; connections sort ascending
		$defaultitem = $adapters[1][0]
		$sStartupAdapter = Options_GetValue($options, $OPTIONS_StartupAdapter)
		$index = _ArraySearch( $adapters, $sStartupAdapter, 1 )
		If ($index <> -1) Then
			$defaultitem = $adapters[$index][0]
		EndIf
		$sBlacklist = Options_GetValue($options, $OPTIONS_AdapterBlacklist)
		$aBlacklist = StringSplit($sBlacklist, "|")
		For $i=1 to $adapters[0][0]
			$indexBlacklist = _ArraySearch($aBlacklist, $adapters[$i][0], 1)
			if $indexBlacklist <> -1 Then ContinueLoop
			GUICtrlSetData( $combo_adapters, $adapters[$i][0], $defaultitem )
		Next
	EndIf
	ControlSend ($hgui, "", $combo_adapters, "{END}")
	_setStatus("Ready")
EndFunc

;------------------------------------------------------------------------------
; Title...........: _blacklistAdd
; Description.....: Add selected adapter to the edit box in the
;				    hide adapters window
;
; Parameters......:
; Return value....:
;------------------------------------------------------------------------------
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

;------------------------------------------------------------------------------
; Title...........: _arrange
; Description.....: Arrange profiles in asc/desc order
;
; Parameters......: $desc  - 0=ascending order; 1=descending order
; Return value....: 0  -success
;				    1  -could not open file
;				    3  -error writing to file
;------------------------------------------------------------------------------
Func _arrange($desc=0)
	_loadProfiles()

	Local $newfile = ""
	$newfile &= "[Options]" & @CRLF
	$newfile &= Options_GetName($options, $OPTIONS_Version) & "=" & Options_GetValue($options, $OPTIONS_Version) & @CRLF
	$newfile &= Options_GetName($options, $OPTIONS_MinToTray) & "=" & Options_GetValue($options, $OPTIONS_MinToTray) & @CRLF
	$newfile &= Options_GetName($options, $OPTIONS_StartupMode) & "=" & Options_GetValue($options, $OPTIONS_StartupMode) & @CRLF
	$newfile &= Options_GetName($options, $OPTIONS_Language) & "=" & Options_GetValue($options, $OPTIONS_Language) & @CRLF
	$newfile &= Options_GetName($options, $OPTIONS_StartupAdapter) & "=" & Options_GetValue($options, $OPTIONS_StartupAdapter) & @CRLF
	$newfile &= Options_GetName($options, $OPTIONS_Theme) & "=" & Options_GetValue($options, $OPTIONS_Theme) & @CRLF
	$newfile &= Options_GetName($options, $OPTIONS_SaveAdapterToProfile) & "=" & Options_GetValue($options, $OPTIONS_SaveAdapterToProfile) & @CRLF
	$newfile &= Options_GetName($options, $OPTIONS_AdapterBlacklist) & "=" & Options_GetValue($options, $OPTIONS_AdapterBlacklist) & @CRLF
	$newfile &= Options_GetName($options, $OPTIONS_PositionX) & "=" & Options_GetValue($options, $OPTIONS_PositionX) & @CRLF
	$newfile &= Options_GetName($options, $OPTIONS_PositionY) & "=" & Options_GetValue($options, $OPTIONS_PositionY) & @CRLF
	$newfile &= Options_GetName($options, $OPTIONS_AutoUpdate) & "=" & Options_GetValue($options, $OPTIONS_AutoUpdate) & @CRLF

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

;------------------------------------------------------------------------------
; Title...........: _checkMouse
; Description.....: Check if mouse is over a particular control
;
; Parameters......: $Id  -controlID
; Return value....: 0  -mouse is NOT over the control
;				    1  -mouse IS over the control
;------------------------------------------------------------------------------
Func _checkMouse($Id)
	$idPos = ControlGetPos($hgui, "", $Id)
	$mPos = MouseGetPos()

	If $mPos[0] > $idPos[0] and $mPos[0] < $idPos[0]+$idPos[2] and $mPos[1] > $idPos[1] and $mPos[1] < $idPos[1]+$idPos[3] Then
		return 1
	Else
		return 0
	EndIf
EndFunc

;------------------------------------------------------------------------------
; Title...........: _clickDn
; Description.....: Check if started dragging a listview item
;
; Parameters......:
; Return value....:
;------------------------------------------------------------------------------
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

;------------------------------------------------------------------------------
; Title...........: _clickUp
; Description.....: On mouse click release:
;                   if double-clicked, apply the selected profile.
;                   if item was dragged, rearrange the items in the listview
;                     and profiles.ini file.
;
; Parameters......:
; Return value....:
;------------------------------------------------------------------------------
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


;------------------------------------------------------------------------------
; Title...........: _iniMove
; Description.....:
;
; Parameters......: $file      -filename
;                   $fromName  -source profile name
;                   $toName    -destination profile name
; Return value....: 0  -success
;                   1  -file read error or string error
;                   2  -string error
;                   3  -file write error
;
; Notes...........: need to make these return errors more descriptive
;------------------------------------------------------------------------------
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

;------------------------------------------------------------------------------
; Title...........: _radios
; Description.....: Check/set radio button interlocks
;
; Parameters......:
; Return value....:
;------------------------------------------------------------------------------
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

;------------------------------------------------------------------------------
; Title...........: _apply
; Description.....: Apply the selected profile to the selected adapter
;
; Parameters......:
; Return value....: 0  -success
;                   1  -no adapter is selected
;------------------------------------------------------------------------------
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
	;_asyncNewCmd($cmd1&$cmd2&$cmd3, $message)
	;(cmd, callback, description)
	asyncRun($cmd1&$cmd2&$cmd3, RunCallback, $message)

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
		;_asyncNewCmd($cmd1&$cmd2&$cmd3, $message, 1)
		;(cmd, callback, description)
		asyncRun($cmd1&$cmd2&$cmd3, RunCallback, $message)
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
			;_asyncNewCmd($cmd1&$cmd2&$cmd3&$cmdend, $message, 1)
			;(cmd, callback, description)
			asyncRun($cmd1&$cmd2&$cmd3&$cmdend, RunCallback, $message)
			If $dnsa <> "" Then
				$cmd1 = $cmd1_2
				$cmd3 = " " & $dnsa
				$message = "Setting alternate DNS server..."
				$cmdend = (_OSVersion() >= 6)?" 2 no":""
				;_asyncNewCmd($cmd1&$cmd2&$cmd3&$cmdend, $message, 1)
				;(cmd, callback, description)
				asyncRun($cmd1&$cmd2&$cmd3&$cmdend, RunCallback, $message)
			EndIf
		ElseIf $dnsa <> "" Then
			$cmd1 = $cmd1_1
			$cmd3 = " static " & $dnsp
			$message = "Setting preferred DNS server..."
			$cmdend = (_OSVersion() >= 6)?" " & $cmdReg & " no":"$cmdReg"
			;_asyncNewCmd($cmd1&$cmd2&$cmd3&$cmdend, $message, 1)
			;(cmd, callback, description)
			asyncRun($cmd1&$cmd2&$cmd3&$cmdend, RunCallback, $message)
		Else
			$cmd1 = $cmd1_3
			$cmd3 = " all"
			$message = "Deleting DNS servers..."
			;_asyncNewCmd($cmd1&$cmd2&$cmd3, $message, 1)
			;(cmd, callback, description)
			asyncRun($cmd1&$cmd2&$cmd3, RunCallback, $message)
		EndIf
	EndIf
EndFunc

;------------------------------------------------------------------------------
; Title...........: _OSVersion
; Description.....: Get the OS version number from the registry
;
; Parameters......:
; Return value....: Version number
;------------------------------------------------------------------------------
Func _OSVersion()
    Return RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\", "CurrentVersion")
EndFunc   ;==>_OSVersion

;------------------------------------------------------------------------------
; Title...........: _pull
; Description.....: Get current IP information from adapter and update display
;
; Parameters......:
; Return value....:
;------------------------------------------------------------------------------
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

;------------------------------------------------------------------------------
; Title...........: _ctrlHasFocus
; Description.....: Check if control currently has focus
;
; Parameters......: $id  -controlID
; Return value....: 0  -control does NOT have focus
;                   1  -control has focus
;------------------------------------------------------------------------------
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

;------------------------------------------------------------------------------
; Title...........: _disable
; Description.....: Disable/enable selected adapter based on current state
;
; Parameters......:
; Return value....:
;------------------------------------------------------------------------------
Func _disable()
	$selected_adapter = GUICtrlRead($combo_adapters)
	if _GUICtrlMenu_GetItemText( GUICtrlGetHandle($toolsmenu), $disableitem, 0 ) = "Disable adapter" Then
		_AdapterMod($selected_adapter, 0)
		GUICtrlSetData($disableitem, "Enable adapter")
	Else
		_AdapterMod($selected_adapter, 1)
		GUICtrlSetData($disableitem, "Disable adapter")
		_setStatus("Updating Adapter List...")
		$adapters = _loadAdapters()
		_setStatus("Ready")
	EndIf
EndFunc

;------------------------------------------------------------------------------
; Title...........: _onLvDoneEdit
; Description.....: When done editing listview item, rename the profile
;
; Parameters......:
; Return value....:
;------------------------------------------------------------------------------
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

;------------------------------------------------------------------------------
; Title...........: _clear
; Description.....: Clears the IP address entry fields
;
; Parameters......:
; Return value....:
;------------------------------------------------------------------------------
Func _clear()
	_ctrlSetIP($ip_Ip, "")
	_ctrlSetIP($ip_Subnet, "")
	_ctrlSetIP($ip_Gateway, "")
	_ctrlSetIP($ip_DnsPri, "")
	_ctrlSetIP($ip_DnsAlt, "")
EndFunc

;------------------------------------------------------------------------------
; Title...........: _checkChangelog
; Description.....: Check if new version and change log needs to be displayed.
;                   Then write new version to profiles.ini file.
;
; Parameters......:
; Return value....:
;------------------------------------------------------------------------------
Func _checkChangelog()
	$sVersion = Options_GetValue($options, $OPTIONS_Version)
	if $sVersion <> $winVersion Then
		_changeLog()
		$sVersion = $winVersion
		$sVersionName = Options_GetName($options, $OPTIONS_Version)
		IniWrite("profiles.ini", "options", $sVersionName, $sVersion)
	EndIf
EndFunc

;------------------------------------------------------------------------------
; Title...........: _rename
; Description.....: Call the ini file rename function and modify the listview
;
; Parameters......:
; Return value....:
;------------------------------------------------------------------------------
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

;------------------------------------------------------------------------------
; Title...........: _iniRename
; Description.....: Rename a section of an INI file in-place.
;                   The built-in IniRenameSection function moves the section
;                   to the end of the file.
;
; Parameters......: $file     -filename
;                   $oldName  -section name to be replaced
;                   $newName  -new section name
; Return value....: 0  -success
;                   1  -file read/open error
;                   2  -new name already exists
;                   3  -file write error
;------------------------------------------------------------------------------
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

;------------------------------------------------------------------------------
; Title...........: _iniRename
; Description.....: Rename a section of an INI file in-place.
;                   The built-in IniRenameSection function moves the section
;                   to the end of the file.
;
; Parameters......:
; Return value....:
;------------------------------------------------------------------------------
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

;------------------------------------------------------------------------------
; Title...........: _new
; Description.....: Create a new profile
;
; Parameters......:
; Return value....:
;------------------------------------------------------------------------------
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

;------------------------------------------------------------------------------
; Title...........: _save
; Description.....: Save the selected profile
;
; Parameters......:
; Return value....:
;------------------------------------------------------------------------------
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

;------------------------------------------------------------------------------
; Title...........: _refresh
; Description.....: Load profiles from ini file and update current adapter info
;
; Parameters......: $init  -1=initial refresh don't change status bar text
; Return value....:
;------------------------------------------------------------------------------
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

;------------------------------------------------------------------------------
; Title...........: _setProperties
; Description.....: Set fields from profile properties
;
; Parameters......:
; Return value....:
;------------------------------------------------------------------------------
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

			$sSaveAdapter = Options_GetValue($options, $OPTIONS_SaveAdapterToProfile)
			If ($profilelist[$index][1])[8] <> "" and ($sSaveAdapter = 1 OR $sSaveAdapter = "true") Then
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
	Options_SetValue( $options, $OPTIONS_StartupMode, _StateToStr($ck_startinTray) )
	Options_SetValue( $options, $OPTIONS_MinToTray, _StateToStr($ck_mintoTray) )
	Options_SetValue( $options, $OPTIONS_SaveAdapterToProfile, _StateToStr($ck_saveAdapter) )
	Options_SetValue( $options, $OPTIONS_AutoUpdate, _StateToStr($ck_autoUpdate) )

	IniWriteSection("profiles.ini", "options", $options, 0)
	_ExitChild(@GUI_WinHandle)
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
					If $thisSection[$j][0] = Options_GetName( $options, $OPTIONS_StartupAdapter) Then
						$newName = StringReplace($thisSection[$j][1], "{lb}", "[")
						$newName = StringReplace($newName, "{rb}", "]")
						Options_SetValue( $options, $OPTIONS_StartupAdapter, $newName)
					Else
						Options_SetValue( $options, $index, $thisSection[$j][1])
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
	Static $tray_tip

	GUISetState(@SW_MINIMIZE, $hGUI)
	GUISetState(@SW_HIDE, $hGUI)
	TrayItemSetText ( $RestoreItem, "Restore" )
	if $tray_tip = 0 Then
		TrayTip("", "Simple IP Config is still running.", 1)
		$tray_tip = 1
	EndIf
EndFunc

Func _minimize()
	$sMinToTray = Options_GetValue( $options, $OPTIONS_MinToTray)
	If $sMinToTray = 1 OR $sMinToTray = "true" Then
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
		_ExitChild($statusChild)
	EndIf
EndFunc


Func _DomainComputerBelongs($strComputer = "localhost")
    ; Generated by AutoIt Scriptomatic
    $Domain = ''

	If $screenshot Then
		$Domain = "Domain: ________"
		return $Domain
	EndIf

	Local $objWMI = ObjGet("winmgmts:{impersonationLevel = impersonate}!\\" & "." & "\root\cimv2")
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

;------------------------------------------------------------------------------
; Title...........: GetChangeLogData
; Description.....: Get the change log string data
;
; Parameters......:
; Return value....: change log string array
;------------------------------------------------------------------------------
Func GetChangeLogData()
	Local $sChangeLog[2]
	$sChangeLog[0] = "Changelog - " & $winVersion
	$sChangeLog[1] = @CRLF & _
	"v"&$winVersion & @CRLF & _
	"MINOR CHANGES:" & @CRLF & _
	"   Added Debug item to Help menu to help troubleshoot issues." & @CRLF & _
	@CRLF & _
	"v2.8" & @CRLF & _
	"BUG FIXES:" & @CRLF & _
	"   IP address entry text scaling" & @CRLF & _
	@CRLF & _
	"v2.8" & @CRLF & _
	"MAJOR CHANGES:" & @CRLF & _
	"   Now using IP Helper API (Iphlpapi.dll) instead of WMI" & @CRLF & _
	"   Speed improvements -> 2x faster!" & @CRLF & _
	@CRLF & _
	"MINOR CHANGES:" & @CRLF & _
	"   Automatically fill in 255.255.255.0 for subnet" & @CRLF & _
	"   Save last window position on exit" & @CRLF & _
	"   Tray message when an trying to start a new instance" & @CRLF & _
	"   Smaller exe file size" & @CRLF & _
	"   Popup window positioning follows main window" & @CRLF & _
	"   Allow more space for current properties" & @CRLF & _
	"   Smoother startup process" & @CRLF & _
	"   Get current information from disconnected adapters" & @CRLF & _
	@CRLF & _
	"BUG FIXES:" & @CRLF & _
	"   IP address entry text scaling" & @CRLF & _
	"   Fixed 'start in system tray' setting" & @CRLF & _
	"   Fixed starting without toolbar icons" & @CRLF & _
	"   Display disabled adapters" & @CRLF & _
	"   Get current properties from disabled adapters" & @CRLF & _
	"   Disabled adapters behavior" & @CRLF & _
	"   Fixed hanging on setting profiles" & @CRLF & _
	"   Fixed renaming/creating profiles issues" & @CRLF & _
	"   Fixed additional DPI scaling issues" & @CRLF & _
	@CRLF & _
	"v2.7" & @CRLF & _
	"MAJOR CHANGES:" & @CRLF & _
	"   Code switched back to AutoIt" & @CRLF & _
	"   Proper DPI scaling" & @CRLF & _
	@CRLF & _
	"NEW FEATURES:" & @CRLF & _
	"   Enable DNS address registration" & @CRLF & _
	"   Hide unused adapters" & "(View->Hide adapters)" & @CRLF & _
	"   Display computer name and domain address" & @CRLF & _
	@CRLF & _
	"OTHER CHANGES:" & @CRLF & _
	"   Single click to restore from system tray" & @CRLF & _
	"   Improved status bar" & @CRLF & _
	"   Allow only 1 instance to run" & @CRLF & _
	@CRLF & _
	"BUG FIXES:" & @CRLF & _
	"   Proper scaling with larger/smaller screen fonts" & @CRLF & _
	"   Fixed tooltip in system tray" & @CRLF & _
	@CRLF & _
	"v2.6" & @CRLF & _
	"NEW FEATURES:" & @CRLF & _
	"   Filter Profiles!" & @CRLF & _
	"   'Start in System Tray' setting" & @CRLF & _
	"   Release / renew DHCP tool" & @CRLF & _
	"   'Saveas' button is now 'New' button" & @CRLF & _
	@CRLF & _
	"OTHER CHANGES:" & @CRLF & _
	"   Enhanced 'Rename' interface" & @CRLF & _
	"   New layout to show more profiles" & @CRLF & _
	"   Other GUI enhancements" & @CRLF & _
	@CRLF & _
	"BUG FIXES:" & @CRLF & _
	"   Detect no IP address / subnet input" & @CRLF & _
	"   Fix DNS error occurring on some systems" & @CRLF & _
	"   Better detection of duplicate profile names" & @CRLF

	Return $sChangeLog
EndFunc
