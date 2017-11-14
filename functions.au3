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

Func MyErrFunc($oError)
  SetError(1)
    ; Do anything here.
	MsgBox(1,"COM Error","Simple IP Config COM Error!" & @CRLF & "Error Number: " & Hex($oError.number))
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
		ElseIf StringInStr($sStdOut, "exists") Then
			_setStatus(StringReplace($sStdOut, @CRLF, " "), 1)
			_GUICtrlToolbar_EnableButton($hToolbar, $tb_apply, True)
			_asyncRun_Clear()
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

Func _CreateLink()
	$profileName = StringReplace( GUICtrlRead(GUICtrlRead($list_profiles)), "|", "")
	$iniName = StringReplace($profileName, "[", "{lb}")
	$iniName = StringReplace($iniName, "]", "{rb}")

	$dir = FileSaveDialog( "Choose a filename", @ScriptDir, "Shortcuts (*.lnk)", 0, "Simple IP Config - " & $profileName)
	If @error Then	Return

	$res = FileCreateShortcut ( @ScriptFullPath, $dir, @ScriptDir, '/set-config "' & $iniName & '"', "desc", @ScriptFullPath )
	If $res = -1 Then _setStatus("Could not save to the selected location!", 1)
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

  $github_releases = "https://api.github.com/repos/KurtisLiggett/Simple-IP-Config/releases"

  Local $oHTTP = ObjCreate("WinHttp.WinHttpRequest.5.1")
  $oHTTP.Open("GET", $github_releases, False)
  If (@error) Then SetError(1, 0, 0)

  $oHTTP.Send()
  If (@error) Then SetError(2, 0, 0)

  If ($oHTTP.Status <> 200) Then SetError(3, 0, 0)

  $cleanedJSON = StringReplace($oHTTP.ResponseText, '"', "")
  $info = StringRegExp($cleanedJSON, '(?:name:v|browser_download_url:)([^\{,}]+)', 3)

;~   If (@error) Then
;~     MsgBox(16, "Error", "We encountered an error retrieving the update. Check your internet connection.")
;~   Else
	$updateText = "Your version is: " & $winVersion & @CRLF & _
		"Latest version is: " & $info[0] & @CRLF & @CRLF
    If ($winVersion <> $info[0]) Then
		$updateText &= "A newer version is available. Press ok to download it."

		If MsgBox(1, "Simple IP Config Update available", $updateText) = 1 Then ShellExecute($info[1])
	Else
		$updateText &= "No update is available."
		if $manualCheck Then MsgBox(0, "Simple IP Config Update", $updateText)
    EndIf
;~   Endif

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
	_loadAdapters()
	Local $adapterNames = Adapter_GetNames($adapters)
	_GUICtrlComboBox_ResetContent (GUICtrlGetHandle($combo_adapters))

	If NOT IsArray( $adapters ) Then
		MsgBox( 16, "Error", "There was a problem retrieving the adapters." )
	Else
		Adapter_Sort($adapters)	; connections sort ascending
		$defaultitem = $adapterNames[0]
		$sStartupAdapter = Options_GetValue($options, $OPTIONS_StartupAdapter)
		$index = _ArraySearch( $adapters, $sStartupAdapter, 1 )
		If ($index <> -1) Then
			$defaultitem = $adapters[$index][0]
		EndIf
		$sBlacklist = Options_GetValue($options, $OPTIONS_AdapterBlacklist)
		$aBlacklist = StringSplit($sBlacklist, "|")
		For $i=0 to UBound($adapterNames)-1
			$indexBlacklist = _ArraySearch($aBlacklist, $adapterNames[$i], 1)
			if $indexBlacklist <> -1 Then ContinueLoop
			GUICtrlSetData( $combo_adapters, $adapterNames[$i], $defaultitem )
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

	Profiles_Sort($profiles, $desc)
	For $i=0 to Profiles_GetSize($profiles)-1
		$sProfileName = Profiles_GetValueByIndex($profiles, $i, $PROFILES_Name)
		$iniName = iniNameEncode($sProfileName)
		$newfile &= "[" & $iniName & "]" & @CRLF
		$newfile &= Profiles_GetKeyName($profiles, $PROFILES_IpAuto) & "=" & Profiles_GetValueByIndex($profiles, $i, $PROFILES_IpAuto) & @CRLF
		$newfile &= Profiles_GetKeyName($profiles, $PROFILES_IpAddress) & "=" & Profiles_GetValueByIndex($profiles, $i, $PROFILES_IpAddress) & @CRLF
		$newfile &= Profiles_GetKeyName($profiles, $PROFILES_IpSubnet) & "=" & Profiles_GetValueByIndex($profiles, $i, $PROFILES_IpSubnet) & @CRLF
		$newfile &= Profiles_GetKeyName($profiles, $PROFILES_IpGateway) & "=" & Profiles_GetValueByIndex($profiles, $i, $PROFILES_IpGateway) & @CRLF
		$newfile &= Profiles_GetKeyName($profiles, $PROFILES_DnsAuto) & "=" & Profiles_GetValueByIndex($profiles, $i, $PROFILES_DnsAuto) & @CRLF
		$newfile &= Profiles_GetKeyName($profiles, $PROFILES_DnsPref) & "=" & Profiles_GetValueByIndex($profiles, $i, $PROFILES_DnsPref) & @CRLF
		$newfile &= Profiles_GetKeyName($profiles, $PROFILES_DnsAlt) & "=" & Profiles_GetValueByIndex($profiles, $i, $PROFILES_DnsAlt) & @CRLF
		$newfile &= Profiles_GetKeyName($profiles, $PROFILES_RegisterDns) & "=" & Profiles_GetValueByIndex($profiles, $i, $PROFILES_RegisterDns) & @CRLF
		$newfile &= Profiles_GetKeyName($profiles, $PROFILES_AdapterName) & "=" & Profiles_GetValueByIndex($profiles, $i, $PROFILES_AdapterName) & @CRLF
	Next

	Local $hFileOpen = FileOpen(@ScriptDir & "/profiles.ini", 2)
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
	Static $dragItemPrev
	$dragitem = ControlListView($hgui, "", $list_profiles, "GetSelected")

    if _checkMouse($list_profiles) and $dragitem <> "" Then
		; -- check for double click --
		$mdblTimerDiff = TimerDiff( $mdblTimerInit )
		If $mdblTimerDiff <= $mDblClickTime Then
			if $dragItemPrev == $dragitem Then
				$mdblClick = 1
			EndIf
		Else
			$mdblClick = 0
		EndIf
		$mdblTimerInit = TimerInit()

		; -- check for dragging --
		if $dragitem <> "" and $mdblClick <> 1 Then
			$dragging = True
		Else
			$dragging = False
		EndIf
    Else
        $dragging = False
		$mdblClick = 0
    EndIf

	$dragItemPrev = $dragitem

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
		MouseClick($MOUSE_CLICK_PRIMARY)
		If $mdblClick Then
			_apply_GUI()
			$mdblClick = 0
		Else
			If $dragging Then
				$newitem = ControlListView($hgui, "", $list_profiles, "GetSelected")
				$dragtext = ControlListView($hgui, "", $list_profiles, "GetText", $dragitem)
				$newtext = ControlListView($hgui, "", $list_profiles, "GetText", $newitem)
				if $newitem <> "" and $dragtext <> $newtext Then
					$ret = _iniMove(@ScriptDir & "/profiles.ini", $dragtext, $newtext)
					If not $ret Then
						$dragProfile = Profiles_GetProfile($profiles, $dragtext)
						Profiles_Delete($profiles, $dragtext)
						Profiles_InsertProfile($profiles, $newitem, $dragtext, $dragProfile)
						_updateProfileList()
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

	$inifromName = iniNameEncode($fromName)
	$initoName = iniNameEncode($toName)

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

Func _apply_GUI()
	$dhcp = (GUICtrlRead($radio_IpAuto) = $GUI_CHECKED)?"true":"false"
	$ip = _ctrlGetIP( $ip_Ip )
	$subnet = _ctrlGetIP( $ip_Subnet )
	$gateway = _ctrlGetIP( $ip_Gateway )
	$dnsdhcp = (GUICtrlRead($radio_DnsAuto) = $GUI_CHECKED)?"true":"false"
	$dnsp = _ctrlGetIP( $ip_DnsPri )
	$dnsa = _ctrlGetIP( $ip_DnsAlt )
	$dnsreg = (BitAND(GUICtrlRead($ck_dnsReg), $GUI_CHECKED) = $GUI_CHECKED)?"true":"false"
	$adapter = GUICtrlRead($combo_adapters)

	_apply($dhcp, $ip, $subnet, $gateway, $dnsdhcp, $dnsp, $dnsa, $dnsreg, $adapter, RunCallback)
EndFunc


;------------------------------------------------------------------------------
; Title...........: _apply
; Description.....: Apply the selected profile to the selected adapter
;
; Parameters......:
; Return value....: 0  -success
;                   1  -no adapter is selected
;------------------------------------------------------------------------------
; MUST BE TESTED VERY CAREFULLY
Func _apply($dhcp, $ip, $subnet, $gateway, $dnsDhcp, $dnsp, $dnsa, $dnsreg, $adapter, $Callback)
	If $adapter = "" Then
		_setStatus("Please select an adapter and try again", 1)
		Return 1
	Endif

	$cmd1 = 'netsh interface ip set address '
	$cmd2 = '"' & $adapter & '"'
	$cmd3 = ""
	$message = ""
	if ($dhcp = "true") Then
		$cmd3 = " dhcp"
		$message = "Setting DHCP..."
	Else
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
	asyncRun($cmd1&$cmd2&$cmd3, $Callback, $message)

	$cmd1 = ''
	$cmd1_1 = 'netsh interface ip set dns '
	$cmd1_2 = 'netsh interface ip add dns '
	$cmd1_3 = 'netsh interface ip delete dns '
	$cmd2 = '"' & $adapter & '"'
	$cmd3 = ""
	$cmdend = ""
	$message = ""
	$cmdReg = ""
	if ($dnsDhcp = "true") Then
		$cmd1 = $cmd1_1
		$cmd3 = " dhcp"
		$message = "Setting DNS DHCP..."
		;_asyncNewCmd($cmd1&$cmd2&$cmd3, $message, 1)
		;(cmd, callback, description)
		asyncRun($cmd1&$cmd2&$cmd3, $Callback, $message)
	Else
		If $dnsreg = "true" Then
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
			asyncRun($cmd1&$cmd2&$cmd3&$cmdend, $Callback, $message)
			If $dnsa <> "" Then
				$cmd1 = $cmd1_2
				$cmd3 = " " & $dnsa
				$message = "Setting alternate DNS server..."
				$cmdend = (_OSVersion() >= 6)?" 2 no":""
				;_asyncNewCmd($cmd1&$cmd2&$cmd3&$cmdend, $message, 1)
				;(cmd, callback, description)
				asyncRun($cmd1&$cmd2&$cmd3&$cmdend, $Callback, $message)
			EndIf
		ElseIf $dnsa <> "" Then
			$cmd1 = $cmd1_1
			$cmd3 = " static " & $dnsp
			$message = "Setting preferred DNS server..."
			$cmdend = (_OSVersion() >= 6)?" " & $cmdReg & " no":"$cmdReg"
			;_asyncNewCmd($cmd1&$cmd2&$cmd3&$cmdend, $message, 1)
			;(cmd, callback, description)
			asyncRun($cmd1&$cmd2&$cmd3&$cmdend, $Callback, $message)
		Else
			$cmd1 = $cmd1_3
			$cmd3 = " all"
			$message = "Deleting DNS servers..."
			;_asyncNewCmd($cmd1&$cmd2&$cmd3, $message, 1)
			;(cmd, callback, description)
			asyncRun($cmd1&$cmd2&$cmd3, $Callback, $message)
		EndIf
	EndIf
EndFunc

;Func _OLDapply()
;	$selected_adapter = GUICtrlRead($combo_adapters)
;	If $selected_adapter = "" Then
;		_setStatus("Please select an adapter and try again", 1)
;		Return 1
;	Endif
;
;	$ip = ""
;	$subnet = ""
;	$gateway = ""
;
;	$dhcp = (GUICtrlRead($radio_IpAuto) = $GUI_CHECKED)?1:0
;	$cmd1 = 'netsh interface ip set address '
;	$cmd2 = '"' & $selected_adapter & '"'
;	$cmd3 = ""
;	$message = ""
;	if $dhcp Then
;		$cmd3 = " dhcp"
;		$message = "Setting DHCP..."
;	Else
;		$ip = _ctrlGetIP( $ip_Ip )
;		$subnet = _ctrlGetIP( $ip_Subnet )
;		$gateway = _ctrlGetIP( $ip_Gateway )
;		If $ip = "" Then
;			_setStatus("Please enter an IP address", 1)
;			Return 1
;		ElseIf $subnet = "" Then
;			_setStatus("Please enter a subnet mask", 1)
;			Return 1
;		Else
;			If $gateway = "" Then
;				$cmd3 = " static " & $ip & " " & $subnet & " none"
;			Else
;				$cmd3 = " static " & $ip & " " & $subnet & " " & $gateway & " 1"
;			EndIf
;			$message = "Setting static IP address..."
;		EndIf
;	EndIf
;	_asyncNewCmd($cmd1&$cmd2&$cmd3, $message)
;
;	$dnsp = ""
;	$dnsa = ""
;
;	$dnsDhcp = (GUICtrlRead($radio_DnsAuto) = $GUI_CHECKED)?1:0
;	$cmd1 = ''
;	$cmd1_1 = 'netsh interface ip set dns '
;	$cmd1_2 = 'netsh interface ip add dns '
;	$cmd1_3 = 'netsh interface ip delete dns '
;	$cmd2 = '"' & $selected_adapter & '"'
;	$cmd3 = ""
;	$cmdend = ""
;	$message = ""
;	$cmdReg = ""
;	if $dnsDhcp Then
;		$cmd1 = $cmd1_1
;		$cmd3 = " dhcp"
;		$message = "Setting DNS DHCP..."
;		_asyncNewCmd($cmd1&$cmd2&$cmd3, $message, 1)
;	Else
;		$dnsp = _ctrlGetIP( $ip_DnsPri )
;		$dnsa = _ctrlGetIP( $ip_DnsAlt )
;		If BitAND(GUICtrlRead($ck_dnsReg), $GUI_CHECKED) = $GUI_CHECKED Then
;			$cmdReg = "both"
;		Else
;			$cmdReg = "none"
;		EndIf
;		If $dnsp <> "" Then
;			$cmd1 = $cmd1_1
;			$cmd3 = " static " & $dnsp
;			$message = "Setting preferred DNS server..."
;			$cmdend = (_OSVersion() >= 6)?" " & $cmdReg & " no":"$cmdReg"
;			_asyncNewCmd($cmd1&$cmd2&$cmd3&$cmdend, $message, 1)
;			If $dnsa <> "" Then
;				$cmd1 = $cmd1_2
;				$cmd3 = " " & $dnsa
;				$message = "Setting alternate DNS server..."
;				$cmdend = (_OSVersion() >= 6)?" 2 no":""
;				_asyncNewCmd($cmd1&$cmd2&$cmd3&$cmdend, $message, 1)
;			EndIf
;		ElseIf $dnsa <> "" Then
;			$cmd1 = $cmd1_1
;			$cmd3 = " static " & $dnsp
;			$message = "Setting preferred DNS server..."
;			$cmdend = (_OSVersion() >= 6)?" " & $cmdReg & " no":"$cmdReg"
;			_asyncNewCmd($cmd1&$cmd2&$cmd3&$cmdend, $message, 1)
;		Else
;			$cmd1 = $cmd1_3
;			$cmd3 = " all"
;			$message = "Deleting DNS servers..."
;			_asyncNewCmd($cmd1&$cmd2&$cmd3, $message, 1)
;		EndIf
;	EndIf
;EndFunc

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
		GUICtrlSetData($disableitem, "En&able adapter")
	Else
		_AdapterMod($selected_adapter, 1)
		GUICtrlSetData($disableitem, "Dis&able adapter")
		_setStatus("Updating Adapter List...")
		_loadAdapters()
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
		Options_SetValue($options, $OPTIONS_Version, $sVersion)
		$sVersionName = Options_GetName($options, $OPTIONS_Version)
		IniWrite(@ScriptDir & "/profiles.ini", "options", $sVersionName, $sVersion)
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

	$ret = _iniRename(@ScriptDir & "/profiles.ini", $lv_oldName, $lv_newName)
	If $ret = 2 Then
		MsgBox($MB_ICONWARNING,"Warning!","The profile name already exists!")
		_GUICtrlListView_SetItemText ( $list_profiles, $lv_editIndex, $lv_oldName )
	ElseIf $ret = 1 or $ret = 3 Then
		_setStatus("An error occurred while saving the profile name", 1)
	Else
		Profiles_SetValue($profiles, $lv_oldName, $PROFILES_Name, $lv_newName)
	EndIf
EndFunc


;------------------------------------------------------------------------------
; Title...........: _delete
; Description.....: Delete a profile
;
; Parameters......:
; Return value....:
;------------------------------------------------------------------------------
Func _delete($name="")
	;check to make sure a profile is selected
	If ControlListView($hgui, "", $list_profiles, "GetSelectedCount") = 0 Then
		_setStatus("No profile is selected!", 1)
		Return 1
	EndIf
	$selIndex = ControlListView($hgui, "", $list_profiles, "GetSelected")

	If not $lv_editing Then
		$profileName = StringReplace( GUICtrlRead(GUICtrlRead($list_profiles)), "|", "")
		$iniName = iniNameEncode($profileName)
		$ret = IniDelete( @ScriptDir & "/profiles.ini", $iniName )
		If $ret = 0 Then
			_setStatus("An error occurred while deleting the profile", 1)
		EndIf

		Profiles_Delete($profiles, $profileName)
	Else
		_GUICtrlListView_CancelEditLabel ( ControlGetHandle($hgui, "", $list_profiles) )
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

	If not Profiles_isNewName($profiles, $profileName) Then
		MsgBox($MB_ICONWARNING, "Warning!", "Profile name already exists!")
		$lv_startEditing = 1
		Return
	EndIf

	Local $aSection = Profiles_CreateSection()
	Profiles_SectionSetValue( $aSection, $PROFILES_IpAuto, _StateToStr( $radio_IpAuto ) )
	Profiles_SectionSetValue( $aSection, $PROFILES_IpAddress,  _ctrlGetIP( $ip_Ip ) )
	Profiles_SectionSetValue( $aSection, $PROFILES_IpSubnet,  _ctrlGetIP( $ip_Subnet ) )
	Profiles_SectionSetValue( $aSection, $PROFILES_IpGateway,  _ctrlGetIP( $ip_Gateway ) )
	Profiles_SectionSetValue( $aSection, $PROFILES_DnsAuto, _StateToStr( $radio_DnsAuto ) )
	Profiles_SectionSetValue( $aSection, $PROFILES_DnsPref,  _ctrlGetIP( $ip_DnsPri ) )
	Profiles_SectionSetValue( $aSection, $PROFILES_DnsAlt,  _ctrlGetIP( $ip_DnsAlt ) )
	Profiles_SectionSetValue( $aSection, $PROFILES_RegisterDns, _StateToStr( $ck_dnsReg ) )
	$adapName = iniNameEncode(GUICtrlRead($combo_adapters))
	Profiles_SectionSetValue( $aSection, $PROFILES_AdapterName, $adapName )
	$iniName = iniNameEncode($profileName)
	$lv_newItem = 0
	$ret = IniWriteSection( @ScriptDir & "/profiles.ini", $iniName, $aSection, 0 )
	If $ret = 0 Then
		_setStatus("An error occurred while saving the profile properties", 1)
	EndIf

	Profiles_AddSection($profiles, $profileName, $aSection)
	_updateProfileList()
EndFunc

;------------------------------------------------------------------------------
; Title...........: _save
; Description.....: Save the selected profile
;
; Parameters......:
; Return value....:
;------------------------------------------------------------------------------
Func _save()
	;check to make sure a profile is selected
	If ControlListView($hgui, "", $list_profiles, "GetSelectedCount") = 0 Then
		_setStatus("No profile is selected!", 1)
		Return 1
	EndIf

	If $lv_editing Then
		Send("{ENTER}")
		Return
	EndIf

	$profileName = StringReplace( GUICtrlRead(GUICtrlRead($list_profiles)), "|", "")

	Local $aSection = Profiles_CreateSection()
	Profiles_SectionSetValue( $aSection, $PROFILES_IpAuto, _StateToStr( $radio_IpAuto ) )
	Profiles_SectionSetValue( $aSection, $PROFILES_IpAddress,  _ctrlGetIP( $ip_Ip ) )
	Profiles_SectionSetValue( $aSection, $PROFILES_IpSubnet,  _ctrlGetIP( $ip_Subnet ) )
	Profiles_SectionSetValue( $aSection, $PROFILES_IpGateway,  _ctrlGetIP( $ip_Gateway ) )
	Profiles_SectionSetValue( $aSection, $PROFILES_DnsAuto, _StateToStr( $radio_DnsAuto ) )
	Profiles_SectionSetValue( $aSection, $PROFILES_DnsPref,  _ctrlGetIP( $ip_DnsPri ) )
	Profiles_SectionSetValue( $aSection, $PROFILES_DnsAlt,  _ctrlGetIP( $ip_DnsAlt ) )
	Profiles_SectionSetValue( $aSection, $PROFILES_RegisterDns, _StateToStr( $ck_dnsReg ) )
	$adapName = iniNameEncode(GUICtrlRead($combo_adapters))
	Profiles_SectionSetValue( $aSection, $PROFILES_AdapterName, $adapName )
	$iniName = iniNameEncode($profileName)
	$ret = IniWriteSection( @ScriptDir & "/profiles.ini", $iniName, $aSection, 0 )
	If $ret = 0 Then
		_setStatus("An error occurred while saving the profile properties", 1)
	EndIf

	Profiles_AddSection($profiles, $profileName, $aSection)
EndFunc

;------------------------------------------------------------------------------
; Title...........: _refresh
; Description.....: Load profiles from ini file and update current adapter info
;
; Parameters......: $init  -1=initial refresh don't change status bar text
; Return value....:
;------------------------------------------------------------------------------
Func _refresh($init=0)
	If $lv_editing Then
		_GUICtrlListView_CancelEditLabel ( ControlGetHandle($hgui, "", $list_profiles) )
	EndIf

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
	if NOT $init Then
		$profileName = StringReplace( GUICtrlRead(GUICtrlRead($list_profiles)), "|", "")
	EndIf

;~ 	_ArrayDisplay($profiles)
	If Not Profiles_isNewName($profiles, $profileName) Then
		$ipAuto = Profiles_GetValue($profiles, $profileName, $PROFILES_IpAuto)
		$ipAddress = Profiles_GetValue($profiles, $profileName, $PROFILES_IpAddress)
		$ipSubnet = Profiles_GetValue($profiles, $profileName, $PROFILES_IpSubnet)
		$ipGateway = Profiles_GetValue($profiles, $profileName, $PROFILES_IpGateway)
		GUICtrlSetState( $radio_IpMan, $GUI_CHECKED )
		GUICtrlSetState( $radio_IpAuto, _StrToState( $ipAuto ) )
		_ctrlSetIP($ip_Ip, $ipAddress )
		_ctrlSetIP($ip_Subnet, $ipSubnet )
		_ctrlSetIP($ip_Gateway, $ipGateway )

		$dnsAuto = Profiles_GetValue($profiles, $profileName, $PROFILES_DnsAuto)
		$dnsPref = Profiles_GetValue($profiles, $profileName, $PROFILES_DnsPref)
		$dnsAlt = Profiles_GetValue($profiles, $profileName, $PROFILES_DnsAlt)
		$dnsReg = Profiles_GetValue($profiles, $profileName, $PROFILES_RegisterDns)
		GUICtrlSetState( $radio_DnsMan, $GUI_CHECKED )
		GUICtrlSetState( $radio_DnsAuto, _StrToState( $dnsAuto ) )
		_ctrlSetIP($ip_DnsPri, $dnsPref )
		_ctrlSetIP($ip_DnsAlt, $dnsAlt )
		GUICtrlSetState( $ck_dnsReg, _StrToState( $dnsReg ) )

		$sSaveAdapter = Options_GetValue($options, $OPTIONS_SaveAdapterToProfile)
		$profileAdapter = Profiles_GetValue($profiles, $profileName, $PROFILES_AdapterName)
		If $profileAdapter <> "" and ($sSaveAdapter = 1 OR $sSaveAdapter = "true") Then
			If Not Profiles_isNewName($profiles, $profileAdapter) Then
				ControlCommand ( $hgui, "", $combo_adapters, "SelectString", $profileAdapter )
			EndIf
		EndIf

		_radios()
	Else
		_setStatus("An error occurred while setting the profile properties", 1)
		Return 1
	EndIf
EndFunc


Func _saveOptions()
	Options_SetValue( $options, $OPTIONS_StartupMode, _StateToStr($ck_startinTray) )
	Options_SetValue( $options, $OPTIONS_MinToTray, _StateToStr($ck_mintoTray) )
	Options_SetValue( $options, $OPTIONS_SaveAdapterToProfile, _StateToStr($ck_saveAdapter) )
	Options_SetValue( $options, $OPTIONS_AutoUpdate, _StateToStr($ck_autoUpdate) )

	IniWriteSection(@ScriptDir & "/profiles.ini", "options", $options, 0)
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
	Local $pname = @ScriptDir & "/profiles.ini"

	If Not FileExists( $pname ) Then
		_setStatus("Profiles.ini file not found - A new file will be created", 1)
		Return 1
	EndIf

	$names = IniReadSectionNames( $pname )
	If @error Then
		_setStatus("Error reading profiles.ini", 1)
		Return 1
	EndIf

	Profiles_DeleteAll($profiles)
	For $i = 1 to $names[0]
		$thisName = iniNameDecode($names[$i])
		$thisSection = IniReadSection($pname, $names[$i])
		If @error Then
            ContinueLoop
        EndIf

		Local $aSection = Profiles_CreateSection()
		For $j = 1 to $thisSection[0][0]
			If $thisName = "Options" or $thisName = "options" Then
				Switch $thisSection[$j][0]
					Case Options_GetName($options, $OPTIONS_Version)
						Options_SetValue( $options, $OPTIONS_Version, $thisSection[$j][1])
					Case Options_GetName($options, $OPTIONS_MinToTray)
						Options_SetValue( $options, $OPTIONS_MinToTray, $thisSection[$j][1])
					Case Options_GetName($options, $OPTIONS_StartupMode)
						Options_SetValue( $options, $OPTIONS_StartupMode, $thisSection[$j][1])
					Case Options_GetName($options, $OPTIONS_Language)
						Options_SetValue( $options, $OPTIONS_Language, $thisSection[$j][1])
					Case Options_GetName($options, $OPTIONS_StartupAdapter)
						$newName = iniNameDecode($thisSection[$j][1])
						Options_SetValue( $options, $OPTIONS_StartupAdapter, $newName)
					Case Options_GetName($options, $OPTIONS_Theme)
						Options_SetValue( $options, $OPTIONS_Theme, $thisSection[$j][1])
					Case Options_GetName($options, $OPTIONS_SaveAdapterToProfile)
						Options_SetValue( $options, $OPTIONS_SaveAdapterToProfile, $thisSection[$j][1])
					Case Options_GetName($options, $OPTIONS_AdapterBlacklist)
						Options_SetValue( $options, $OPTIONS_AdapterBlacklist, $thisSection[$j][1])
					Case Options_GetName($options, $OPTIONS_PositionX)
						Options_SetValue( $options, $OPTIONS_PositionX, $thisSection[$j][1])
					Case Options_GetName($options, $OPTIONS_PositionY)
						Options_SetValue( $options, $OPTIONS_PositionY, $thisSection[$j][1])
					Case Options_GetName($options, $OPTIONS_AutoUpdate)
						Options_SetValue( $options, $OPTIONS_AutoUpdate, $thisSection[$j][1])
				EndSwitch
			Else
				Switch $thisSection[$j][0]
					Case Profiles_GetKeyName($profiles, $PROFILES_IpAuto)
						Profiles_SectionSetValue( $aSection, $PROFILES_IpAuto, $thisSection[$j][1])
					Case Profiles_GetKeyName($profiles, $PROFILES_IpAddress)
						Profiles_SectionSetValue( $aSection, $PROFILES_IpAddress, $thisSection[$j][1])
					Case Profiles_GetKeyName($profiles, $PROFILES_IpSubnet)
						Profiles_SectionSetValue( $aSection, $PROFILES_IpSubnet, $thisSection[$j][1])
					Case Profiles_GetKeyName($profiles, $PROFILES_IpGateway)
						Profiles_SectionSetValue( $aSection, $PROFILES_IpGateway, $thisSection[$j][1])
					Case Profiles_GetKeyName($profiles, $PROFILES_DnsAuto)
						Profiles_SectionSetValue( $aSection, $PROFILES_DnsAuto, $thisSection[$j][1])
					Case Profiles_GetKeyName($profiles, $PROFILES_DnsPref)
						Profiles_SectionSetValue( $aSection, $PROFILES_DnsPref, $thisSection[$j][1])
					Case Profiles_GetKeyName($profiles, $PROFILES_DnsAlt)
						Profiles_SectionSetValue( $aSection, $PROFILES_DnsAlt, $thisSection[$j][1])
					Case Profiles_GetKeyName($profiles, $PROFILES_RegisterDns)
						Profiles_SectionSetValue( $aSection, $PROFILES_RegisterDns, $thisSection[$j][1])
					Case Profiles_GetKeyName($profiles, $PROFILES_AdapterName)
						$adapName = iniNameEncode($thisSection[$j][1])
						Profiles_SectionSetValue( $aSection, $PROFILES_AdapterName, $adapName)
				EndSwitch
			EndIf
		Next
		If $thisName <> "Options" Then
			Profiles_AddSection($profiles, $thisName, $aSection)
		EndIf
	Next

EndFunc

Func _updateProfileList()
	$ap_names = Profiles_GetNames($profiles)
	$lv_count = ControlListView( $hgui, "", $list_profiles, "GetItemCount" )

	Local $diff = 0
	If UBound($ap_names) <> $lv_count Then $diff = 1

	If not $diff then
		For $i=0 to $lv_count-1
;~ 			ConsoleWrite($ap_names[$i] & " " & ControlListView( $hgui, "", $list_profiles, "GetText", $i ) & @CRLF)
			If $ap_names[$i] <> ControlListView( $hgui, "", $list_profiles, "GetText", $i ) Then
				$diff = 1
				ExitLoop
			EndIf
		Next
	EndIf

	If not $diff Then Return

	$selItem = ControlListView($hgui, "", $list_profiles, "GetSelected")
	_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($list_profiles))
	If IsArray($ap_names) Then
		For $i=0 to UBound($ap_names)-1
			GUICtrlCreateListViewItem( $ap_names[$i], $list_profiles )
			GUICtrlSetOnEvent( -1, "_onSelect" )
		Next
	Else
		_setStatus("An error occurred while building the profile list", 1)
		Return 1
	EndIf
	If $selItem < UBound($ap_names) Then
		ControlListView($hgui, "", $list_profiles, "Select", $selItem)
	Else
		ControlListView($hgui, "", $list_profiles, "Select", UBound($ap_names)-1)
	EndIf
EndFunc


Func _updateCurrent($init=0, $selected_adapter="")
	If $cmdLine Then Return
	If NOT $init Then
		$selected_adapter = GUICtrlRead($combo_adapters)
	EndIf

	If Adapter_Exists($adapters, $selected_adapter) Then
		GUICtrlSetData( $lDescription, Adapter_GetDescription($adapters, $selected_adapter) )
		If $screenshot Then
			GUICtrlSetData( $lMac, "MAC Address: " & "XX-XX-XX-XX-XX-XX" )
		Else
			GUICtrlSetData( $lMac, "MAC Address: " & Adapter_GetMAC($adapters, $selected_adapter) )
		EndIf
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
		GUICtrlSetData($disableitem, "En&able adapter")
	Else
		GUICtrlSetData($disableitem, "Dis&able adapter")
	EndIf
EndFunc


Func _filterProfiles()
	Local $aArray[1] = [0]
	_ArrayDelete( $aArray, 0 )
	$strPattern = GUICtrlRead( $input_filter )
	_GUICtrlListView_DeleteAllItems( $list_profiles )

	$aNames = Profiles_GetNames($profiles)
	if $strPattern <> "" Then
		$pattern = '(?i)(?U)' & StringReplace( $strPattern, "*", ".*")
		;MsgBox(0,"",$pattern)
		for $k=0 to UBound($aNames)-1
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

Func _setStatus($sMessage, $bError=0, $bTiming=0)
	if $cmdLine Then Return
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
	"BUG FIXES:" & @CRLF & _
	"   #44   	Help menu link to documentation." & @CRLF & _
	"   #45   	Added menu mnemonics (access keys)." & @CRLF & _
	@CRLF & _
	"v2.9 Beta 2" & @CRLF & _
	"BUG FIXES:" & @CRLF & _
	"   #35   	Hide adapters broken." & @CRLF & _
	"   #39/40  Sort profiles broken." & @CRLF & _
	@CRLF & _
	"v2.9 Beta 1" & @CRLF & _
	"NEW FEATURES:" & @CRLF & _
	"   #15  Automatic Updates" & @CRLF & _
	"   #4   Create desktop shortcuts to profiles" & @CRLF & _
	"MAJOR CHANGES:" & @CRLF & _
	"   Major code improvements" & @CRLF & _
	"MINOR CHANGES:" & @CRLF & _
	"   #7   Added Debug item to Help menu for troubleshooting issues." & @CRLF & _
	"BUG FIXES:" & @CRLF & _
	"   #3   Setting profiles when profiles.ini is out of order." & @CRLF & _
	"   #3   Setting profiles after drag-and-drop to rearrange." & @CRLF & _
	"   #13  Issue opening the program two times." & @CRLF & _
	"   #19  Program starts off screen with dual screens." & @CRLF & _
	"   #22  Program crashes on Delete." & @CRLF & _
	"   #23  Profile '0' created unintentionally." & @CRLF & _
	"   #24  Double-clicking profiles behavior." & @CRLF & _
	"   #25  Adapters not showing up with underscore." & @CRLF & _
	"   #26  Left-handed mouse could not select profiles." & @CRLF & _
	@CRLF & _
	"v2.8.1" & @CRLF & _
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

#Region -- INI related --
Func iniNameDecode($sName)
	$thisName = StringReplace($sName, "{lb}", "[")
	$thisName = StringReplace($thisName, "{rb}", "]")
	Return $thisName
EndFunc

Func iniNameEncode($sName)
	$iniName = StringReplace($sName, "[", "{lb}")
	$iniName = StringReplace($iniName, "]", "{rb}")
	Return $iniName
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

	$iniOldName = iniNameEncode($oldName)
	$iniNewName = iniNameEncode($newName)

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
#EndRegion