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
Global $oMyError = ObjEvent("AutoIt.Error", "MyErrFunc")
Global $suppressComError = 0

Func MyErrFunc($oError)
	If Not $suppressComError Then
		SetError(1)
		; Do anything here.
		MsgBox(1, "COM " & $oLangStrings.message.error, "Simple IP Config COM " & $oLangStrings.message.error & @CRLF & "Error Number: " & Hex($oError.number) & @CRLF & $oError.windescription)
	EndIf
EndFunc   ;==>MyErrFunc

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
	If $sStdOut = $oLangStrings.message.commandTimeout Then

		_setStatus($oLangStrings.message.timedout, 1)
		If asyncRun_isIdle() Then
;~ 			_GUICtrlToolbar_EnableButton($hToolbar, $tb_apply, True)
			GuiFlatButton_SetState($tbButtonApply, $GUI_ENABLE)
		Else
;~ 			_GUICtrlToolbar_EnableButton($hToolbar, $tb_apply, False)
			GuiFlatButton_SetState($tbButtonApply, $GUI_DISABLE)
		EndIf
	Else
		If StringInStr($sStdOut, "failed") Then
			_setStatus(StringReplace($sStdOut, @CRLF, " "), 1)
			If asyncRun_isIdle() Then
;~ 				_GUICtrlToolbar_EnableButton($hToolbar, $tb_apply, True)
				GuiFlatButton_SetState($tbButtonApply, $GUI_ENABLE)
			EndIf
		ElseIf StringInStr($sStdOut, "exists") Then
			_setStatus(StringReplace($sStdOut, @CRLF, " "), 1)
;~ 			_GUICtrlToolbar_EnableButton($hToolbar, $tb_apply, True)
			GuiFlatButton_SetState($tbButtonApply, $GUI_ENABLE)
			_asyncRun_Clear()
		Else
			If $sDescription = $sNextDescription Then
				If Not $showWarning Then _setStatus($sNextDescription)
;~ 				_GUICtrlToolbar_EnableButton($hToolbar, $tb_apply, False)
				GuiFlatButton_SetState($tbButtonApply, $GUI_DISABLE)
			ElseIf asyncRun_isIdle() Then
;~ 				_GUICtrlToolbar_EnableButton($hToolbar, $tb_apply, True)
				GuiFlatButton_SetState($tbButtonApply, $GUI_ENABLE)
				If Not $showWarning Then _setStatus($oLangStrings.message.ready)
;~ 				_GUICtrlToolbar_EnableButton($hToolbar, $tb_apply, True)
				GuiFlatButton_SetState($tbButtonApply, $GUI_ENABLE)
			Else
				If Not $showWarning Then _setStatus($sNextDescription)
;~ 				_GUICtrlToolbar_EnableButton($hToolbar, $tb_apply, False)
				GuiFlatButton_SetState($tbButtonApply, $GUI_DISABLE)
			EndIf
		EndIf
	EndIf

	_updateCurrent()
EndFunc   ;==>RunCallback

;------------------------------------------------------------------------------
; Title...........: _ExitChild
; Description.....: Destroy the child window and enable the main GUI
;
; Parameters......: $childwin  -child window handle
; Return value....:
;------------------------------------------------------------------------------
Func _ExitChild($childwin)
	Local $guiState = WinGetState($hgui)
	GUISetState(@SW_ENABLE, $hGUI)
	Local $a_ret = DllCall("user32.dll", "int", "DestroyWindow", "hwnd", $childwin)
	;GUIDelete( $childwin )
	If Not (BitAND($guiState, $WIN_STATE_VISIBLE)) Or BitAND($guiState, $WIN_STATE_MINIMIZED) Then Return
	If BitAND($guiState, $WIN_STATE_EXISTS) And Not (BitAND($guiState, $WIN_STATE_ACTIVE)) Then
		_maximize()
	EndIf
EndFunc   ;==>_ExitChild

Func _CreateLink()
	Local $profileName = StringReplace(GUICtrlRead(GUICtrlRead($list_profiles)), "|", "")
	Local $iniName = StringReplace($profileName, "[", "{lb}")
	$iniName = StringReplace($iniName, "]", "{rb}")

	Local $dir = FileSaveDialog("Choose a filename", @ScriptDir, "Shortcuts (*.lnk)", 0, "Simple IP Config - " & $profileName)
	If @error Then Return

	Local $res = FileCreateShortcut(@ScriptFullPath, $dir, @ScriptDir, '/set-config "' & $iniName & '"', "desc", @ScriptFullPath)
	If $res = -1 Then
		_setStatus($oLangStrings.message.couldNotSave, 1)
	EndIf
EndFunc   ;==>_CreateLink

;------------------------------------------------------------------------------
; Title...........: _checksSICUpdate
; Description.....: Check for updates/ask to download
;
; Parameters......: $manualCheck  -manually run check from menu item and display errors on failure
; Return value....:
;------------------------------------------------------------------------------
Func _checksSICUpdate($manualCheck = 0)
	Local $sGithubReleasesURL = "https://api.github.com/repos/KurtisLiggett/Simple-IP-Config/releases/latest"

	Local $sResponseJSON = _INetGetSource($sGithubReleasesURL)
	If (@error) Then
		SetError(1001, 0, 0)
		If $manualCheck Then
			MsgBox(16, $oLangStrings.message.error, $oLangStrings.message.updateCheckError & @CRLF & $oLangStrings.message.checkConnect & @CRLF & $oLangStrings.message.errorCode & ": " & @error)
		EndIf
		Return
	EndIf

	Local $oJsonData = json_decode($sResponseJSON)
	If (@error) Then
		If $manualCheck Then
			SetError(1001, 0, 0)
			MsgBox(16, "JSON Error", "Error parsing JSON data." & @CRLF & $oLangStrings.message.errorCode & ": " & @error)
		EndIf
		Return
	EndIf
	Local $scurrentVersion = json_get($oJsonData, ".tag_name")
	If (@error) Then
		If $manualCheck Then
			SetError(1002, 0, 0)
			MsgBox(16, "JSON Error", "Error parsing JSON data." & @CRLF & $oLangStrings.message.errorCode & ": " & @error)
		EndIf
		Return
	EndIf

	Local $currentVersiontokens = StringSplit($scurrentVersion, ".")
	If (@error) Then
		If $manualCheck Then
			SetError(1004, 0, 0)
			MsgBox(16, $oLangStrings.message.error, $oLangStrings.message.updateCheckError & @CRLF & $oLangStrings.message.errorCode & ": " & @error)
		EndIf
		Return
	EndIf

	Local $thisVersion = $winVersion
	Local $thisVersiontokens = StringSplit($thisVersion, ".")
	If (@error) Then
		If $manualCheck Then
			SetError(1004, 0, 0)
			MsgBox(16, $oLangStrings.message.error, $oLangStrings.message.updateCheckError & @CRLF & $oLangStrings.message.errorCode & ": " & @error)
		EndIf
		Return
	EndIf

	;compare current version to running version ->  -1 = current < running, 0 = same, 1 = current > running
	Local $result = 0
	If $currentVersiontokens[0] > 1 And $thisVersiontokens[0] > 1 Then
		If Int($currentVersiontokens[1]) > Int($thisVersiontokens[1]) Then ;newer major version
			$result = 1
		ElseIf Int($currentVersiontokens[1]) == Int($thisVersiontokens[1]) Then ;same major version
			If Int($currentVersiontokens[2]) > Int($thisVersiontokens[2]) Then ;newer minor version
				$result = 1
			ElseIf Int($currentVersiontokens[2]) == Int($thisVersiontokens[2]) Then ;same minor
				If $currentVersiontokens[0] > 2 And $thisVersiontokens[0] > 2 Then
					If StringLeft($thisVersiontokens[3], 1) == 'b' Then
						$result = 1
					Else
						If Int($currentVersiontokens[3]) > Int($thisVersiontokens[3]) Then ;newer revision
							$result = 1
						Else ;same revision
							$result = 0
						EndIf
					EndIf
				ElseIf $currentVersiontokens[0] > 2 And $thisVersiontokens[0] == 2 Then
					$result = 1
				ElseIf $currentVersiontokens[0] == 2 And $thisVersiontokens[0] > 2 Then
					If StringLeft($thisVersiontokens[3], 1) == 'b' Then
						$result = 1
					Else
						$result = -1
					EndIf
				Else
					$result = -1
				EndIf
			Else
				$result = -1
			EndIf
		Else
			$result = -1
		EndIf
	Else
		If $manualCheck Then
			SetError(1004, 0, 0)
			MsgBox(16, $oLangStrings.message.error, $oLangStrings.message.updateCheckError & @CRLF & $oLangStrings.message.errorCode & ": " & @error)
		EndIf
	EndIf

	Local $dateNow, $updateText, $isNew = 0
	If $result == 1 Then
		$isNew = 1
		$dateNow = _NowCalcDate()
		$dateLastCheck = $options.LastUpdateCheck

		$updateText = $oLangStrings.message.yourVersion & ": " & $thisVersion & @CRLF & _
				$oLangStrings.message.latestVersion & ": " & $scurrentVersion & @CRLF & @CRLF & _
				$oLangStrings.message.newVersion
		If $manualCheck Or _DateDiff('D', $dateLastCheck, $dateNow) >= 7 Or $dateLastCheck = '' Then
			_form_update($thisVersion, $scurrentVersion, $isNew)

			$options.LastUpdateCheck = $dateNow
			IniWrite($sProfileName, "options", "LastUpdateCheck", $dateNow)
		EndIf
	Else
		$updateText = $oLangStrings.message.yourVersion & ": " & $thisVersion & @CRLF & _
				$oLangStrings.message.latestVersion & ": " & $scurrentVersion & @CRLF & @CRLF & _
				$oLangStrings.message.currentVersion
		If $manualCheck Then _form_update($thisVersion, $scurrentVersion, $isNew)
	EndIf

EndFunc   ;==>_checksSICUpdate

Func _DoUpdate($newFilename)
	$fileStr = '@echo off' & @CRLF & _
			'taskkill /pid ' & WinGetProcess($hgui) & @CRLF & _     ; kill running instance
			'del /Q "' & @ScriptFullPath & '"' & @CRLF & _ ; delete old version
			'start "" "' & $newFilename & '"' ; start new version
	$filename = 'simple_ip_config_updater.cmd'
	$file = FileOpen($filename, 2) ; open/overwrite
	FileWrite($file, $fileStr)
	FileClose($file)

	$iPID = Run(@ComSpec & " /k " & $filename, "", @SW_HIDE, $STDIN_CHILD + $STDERR_MERGED)
EndFunc   ;==>_DoUpdate

;------------------------------------------------------------------------------
; Title...........: _updateCombo
; Description.....: UpdateUpdate the adapters list
;
; Parameters......:
; Return value....:
;------------------------------------------------------------------------------
Func _updateCombo()
	_setStatus($oLangStrings.message.updatingList)
	_loadAdapters()
	Local $adapterNames = Adapter_GetNames($adapters)
	_GUICtrlComboBox_ResetContent(GUICtrlGetHandle($combo_adapters))

	If Not IsArray($adapters) Then
		MsgBox(16, $oLangStrings.message.error, $oLangStrings.message.errorRetrieving)
	Else
		Adapter_Sort($adapters) ; connections sort ascending
;~ 		$defaultitem = Adapter_GetName($adapters, 0)
		$defaultitem = ""
		$sStartupAdapter = $options.StartupAdapter
		$index = _ArraySearch($adapters, $sStartupAdapter, 1)
		If ($index <> -1) Then
			$defaultitem = $sStartupAdapter
		EndIf
		$sBlacklist = $options.AdapterBlacklist
		$aBlacklist = StringSplit($sBlacklist, "|")
		For $i = 0 To UBound($adapterNames) - 1
			$indexBlacklist = _ArraySearch($aBlacklist, $adapterNames[$i], 1)
			If $indexBlacklist <> -1 Then ContinueLoop
			GUICtrlSetData($combo_adapters, $adapterNames[$i], $defaultitem)
		Next
	EndIf
	ControlSend($hgui, "", $combo_adapters, "{END}")
	_setStatus($oLangStrings.message.ready)
EndFunc   ;==>_updateCombo

;------------------------------------------------------------------------------
; Title...........: _arrange
; Description.....: Arrange profiles in asc/desc order
;
; Parameters......: $desc  - 0=ascending order; 1=descending order
; Return value....: 0  -success
;				    1  -could not open file
;				    3  -error writing to file
;------------------------------------------------------------------------------
Func _arrange($desc = 0)
	_loadProfiles()

	$profiles.sort($desc)

	Local $newfile = ""
	$newfile &= $options.getSectionStr()

	For $oProfile In $profiles.Profiles
		$newfile &= $oProfile.getSectionStr()
	Next

	Local $hFileOpen = FileOpen($sProfileName, 2)
	If $hFileOpen = -1 Then
		Return 1
	EndIf

	Local $sFileWrite = FileWrite($hFileOpen, $newfile)
	If @error <> 0 Then
		FileClose($hFileOpen)
		Return 3
	EndIf

	FileClose($hFileOpen)

	_updateProfileList()
	Return 0
EndFunc   ;==>_arrange

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

	If $mPos[0] > $idPos[0] And $mPos[0] < $idPos[0] + $idPos[2] And $mPos[1] > $idPos[1] And $mPos[1] < $idPos[1] + $idPos[3] Then
		Return 1
	Else
		Return 0
	EndIf
EndFunc   ;==>_checkMouse

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

	If _checkMouse($list_profiles) And $dragitem <> "" Then
		; -- check for double click --
		$mdblTimerDiff = TimerDiff($mdblTimerInit)
		If $mdblTimerDiff <= $mDblClickTime Then
			If $dragItemPrev == $dragitem Then
				$mdblClick = 1
			EndIf
		Else
			$mdblClick = 0
		EndIf
		$mdblTimerInit = TimerInit()

		; -- check for dragging --
		If $dragitem <> "" And $mdblClick <> 1 Then
			$dragging = True
		Else
			$dragging = False
		EndIf
	Else
		$dragging = False
		$mdblClick = 0
	EndIf

	$dragItemPrev = $dragitem

EndFunc   ;==>_clickDn

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
	If _checkMouse($list_profiles) And _ctrlHasFocus($list_profiles) Then
		MouseClick($MOUSE_CLICK_PRIMARY)
		If $mdblClick Then
			_apply_GUI()
			$mdblClick = 0
		Else
			If $dragging Then
				$newitem = ControlListView($hgui, "", $list_profiles, "GetSelected")
				$dragtext = ControlListView($hgui, "", $list_profiles, "GetText", $dragitem)
				$newtext = ControlListView($hgui, "", $list_profiles, "GetText", $newitem)
				If $newitem <> "" And $dragtext <> $newtext Then
					$ret = _iniMove($sProfileName, $dragtext, $newtext)
					If Not $ret Then
						$profiles.move($dragtext, $newitem)
						_updateProfileList()
					EndIf
				EndIf
			EndIf
		EndIf
	EndIf
	$dragging = False
EndFunc   ;==>_clickUp


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

	$strToPos = StringInStr($sFileRead, "[" & $initoName & "]")
	If $strToPos = 0 Then
		Return 2
	EndIf

	$strFromPos = StringInStr($sFileRead, "[" & $inifromName & "]")
	If $strFromPos = 0 Then
		Return 2
	EndIf

	If $strFromPos > $strToPos Then
		$aToSplit = StringSplit($sFileRead, "[" & $initoName & "]", 1)
		If @error Then
			Return 1
		EndIf
		$sLeft = $aToSplit[1]

		$aFromSplit = StringSplit($aToSplit[2], "[" & $inifromName & "]", 1)
		If @error Then
			Return 1
		EndIf
		$sMid = "[" & $initoName & "]" & $aFromSplit[1]

		$strNextPos = StringInStr($aFromSplit[2], "[")
		If $strNextPos = 0 Then
			$sSection = "[" & $inifromName & "]" & $aFromSplit[2]
			$sRight = ""
		Else
			$sSection = "[" & $inifromName & "]" & StringLeft($aFromSplit[2], $strNextPos - 1)
			$sRight = StringRight($aFromSplit[2], StringLen($aFromSplit[2]) - $strNextPos + 1)
		EndIf
		$sNewFile = $sLeft & $sSection & $sMid & $sRight

	ElseIf $strFromPos < $strToPos Then
		$aFromSplit = StringSplit($sFileRead, "[" & $inifromName & "]", 1)
		If @error Then
			Return 1
		EndIf
		$sBeforeFrom = $aFromSplit[1]

		$strNextPos = StringInStr($aFromSplit[2], "[")
		$sSection = "[" & $inifromName & "]" & StringLeft($aFromSplit[2], $strNextPos - 1)

		$sAfterFrom = StringRight($aFromSplit[2], StringLen($aFromSplit[2]) - $strNextPos + 1)
		$strToPos = StringInStr($sAfterFrom, "[" & $initoName & "]")
		$strNextPos = StringInStr($sAfterFrom, "[", 0, 1, $strToPos + 1)
		If $strNextPos = 0 Then
			$sMid = $sAfterFrom
			$sAfterTo = ""
		Else
			$sMid = StringLeft($sAfterFrom, $strNextPos - 1)
			$sAfterTo = StringRight($sAfterFrom, StringLen($sAfterFrom) - $strNextPos + 1)
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
	If @error <> 0 Then
		FileClose($hFileOpen)
		Return 3
	EndIf

	FileClose($hFileOpen)

	Return 0
EndFunc   ;==>_iniMove

;------------------------------------------------------------------------------
; Title...........: _radios
; Description.....: Check/set radio button interlocks
;
; Parameters......:
; Return value....:
;------------------------------------------------------------------------------
Func _radios()
	If GUICtrlRead($radio_IpAuto) = $GUI_CHECKED Then
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

	If GUICtrlRead($radio_DnsAuto) = $GUI_CHECKED Then
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
EndFunc   ;==>_radios

Func _apply_GUI()
	$dhcp = (GUICtrlRead($radio_IpAuto) = $GUI_CHECKED) ? "true" : "false"
	$ip = _ctrlGetIP($ip_Ip)
	$subnet = _ctrlGetIP($ip_Subnet)
	$gateway = _ctrlGetIP($ip_Gateway)
	$dnsDhcp = (GUICtrlRead($radio_DnsAuto) = $GUI_CHECKED) ? "true" : "false"
	$dnsp = _ctrlGetIP($ip_DnsPri)
	$dnsa = _ctrlGetIP($ip_DnsAlt)
	$dnsreg = (BitAND(GUICtrlRead($ck_dnsReg), $GUI_CHECKED) = $GUI_CHECKED) ? "true" : "false"
	$adapter = GUICtrlRead($combo_adapters)

	_apply($dhcp, $ip, $subnet, $gateway, $dnsDhcp, $dnsp, $dnsa, $dnsreg, $adapter, RunCallback)
EndFunc   ;==>_apply_GUI


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
		_setStatus($oLangStrings.message.selectAdapter, 1)
		Return 1
	EndIf

	$cmd1 = 'netsh interface ip set address '
	$cmd2 = '"' & $adapter & '"'
	$cmd3 = ""
	$message = ""
	If ($dhcp = "true") Then
		$cmd3 = " dhcp"
		$message = "Setting DHCP..."
	Else
		If $ip = "" Then
			_setStatus($oLangStrings.message.enterIP, 1)
			Return 1
		ElseIf $subnet = "" Then
			_setStatus($oLangStrings.message.enterSubnet, 1)
			Return 1
		Else
			If $gateway = "" Then
				$cmd3 = " static " & $ip & " " & $subnet & " none"
			Else
				$cmd3 = " static " & $ip & " " & $subnet & " " & $gateway & " 1"
			EndIf
			$message = $oLangStrings.message.settingIP
		EndIf
	EndIf
	;_asyncNewCmd($cmd1&$cmd2&$cmd3, $message)
	;(cmd, callback, description)
	asyncRun($cmd1 & $cmd2 & $cmd3, $Callback, $message)

	$cmd1 = ''
	$cmd1_1 = 'netsh interface ip set dns '
	$cmd1_2 = 'netsh interface ip add dns '
	$cmd1_3 = 'netsh interface ip delete dns '
	$cmd2 = '"' & $adapter & '"'
	$cmd3 = ""
	$cmdend = ""
	$message = ""
	$cmdReg = ""
	If ($dnsDhcp = "true") Then
		$cmd1 = $cmd1_1
		$cmd3 = " dhcp"
		$message = $oLangStrings.message.settingDnsDhcp
		;_asyncNewCmd($cmd1&$cmd2&$cmd3, $message, 1)
		;(cmd, callback, description)
		asyncRun($cmd1 & $cmd2 & $cmd3, $Callback, $message)
	Else
		If $dnsreg = "true" Then
			$cmdReg = "both"
		Else
			$cmdReg = "none"
		EndIf
		If $dnsp <> "" Then
			$cmd1 = $cmd1_1
			$cmd3 = " static " & $dnsp
			$message = $oLangStrings.message.settingDnsPref
			$cmdend = (_OSVersion() >= 6) ? " " & $cmdReg & " no" : "$cmdReg"
			;_asyncNewCmd($cmd1&$cmd2&$cmd3&$cmdend, $message, 1)
			;(cmd, callback, description)
			asyncRun($cmd1 & $cmd2 & $cmd3 & $cmdend, $Callback, $message)
			If $dnsa <> "" Then
				$cmd1 = $cmd1_2
				$cmd3 = " " & $dnsa
				$message = $oLangStrings.message.settingDnsAlt
				$cmdend = (_OSVersion() >= 6) ? " 2 no" : ""
				;_asyncNewCmd($cmd1&$cmd2&$cmd3&$cmdend, $message, 1)
				;(cmd, callback, description)
				asyncRun($cmd1 & $cmd2 & $cmd3 & $cmdend, $Callback, $message)
			EndIf
		ElseIf $dnsa <> "" Then
			$cmd1 = $cmd1_1
			$cmd3 = " static " & $dnsp
			$message = $oLangStrings.message.settingDnsPref
			$cmdend = (_OSVersion() >= 6) ? " " & $cmdReg & " no" : "$cmdReg"
			;_asyncNewCmd($cmd1&$cmd2&$cmd3&$cmdend, $message, 1)
			;(cmd, callback, description)
			asyncRun($cmd1 & $cmd2 & $cmd3 & $cmdend, $Callback, $message)
		Else
			$cmd1 = $cmd1_3
			$cmd3 = " all"
			$message = "Deleting DNS servers..."
			;_asyncNewCmd($cmd1&$cmd2&$cmd3, $message, 1)
			;(cmd, callback, description)
			asyncRun($cmd1 & $cmd2 & $cmd3, $Callback, $message)
		EndIf
	EndIf

EndFunc   ;==>_apply

;Func _OLDapply()
;	$selected_adapter = GUICtrlRead($combo_adapters)
;	If $selected_adapter = "" Then
;		_setStatus($oLangStrings.message.selectAdapter, 1)
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
;			$message = $oLangStrings.message.settingIP
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
	GUICtrlSetState($radio_IpMan, $GUI_CHECKED)
	_ctrlSetIP($ip_Ip, GUICtrlRead($label_CurrentIp))
	_ctrlSetIP($ip_Subnet, GUICtrlRead($label_CurrentSubnet))
	_ctrlSetIP($ip_Gateway, GUICtrlRead($label_CurrentGateway))
	GUICtrlSetState($radio_DnsMan, $GUI_CHECKED)
	_ctrlSetIP($ip_DnsPri, GUICtrlRead($label_CurrentDnsPri))
	_ctrlSetIP($ip_DnsAlt, GUICtrlRead($label_CurrentDnsAlt))
	_radios()
EndFunc   ;==>_pull

;------------------------------------------------------------------------------
; Title...........: _ctrlHasFocus
; Description.....: Check if control currently has focus
;
; Parameters......: $id  -controlID
; Return value....: 0  -control does NOT have focus
;                   1  -control has focus
;------------------------------------------------------------------------------
Func _ctrlHasFocus($Id)
	$idFocus = ControlGetFocus($hgui)
	$hFocus = ControlGetHandle($hgui, "", $idFocus)
	$hCtrl = ControlGetHandle($hgui, "", $Id)
	If $hFocus = $hCtrl Then
		Return 1
	Else
		Return 0
	EndIf
EndFunc   ;==>_ctrlHasFocus

;------------------------------------------------------------------------------
; Title...........: _disable
; Description.....: Disable/enable selected adapter based on current state
;
; Parameters......:
; Return value....:
;------------------------------------------------------------------------------
Func _disable()
	$selected_adapter = GUICtrlRead($combo_adapters)
	If _GUICtrlMenu_GetItemText(GUICtrlGetHandle($toolsmenu), $disableitem, 0) = $oLangStrings.menu.tools.disable Then
		_AdapterMod($selected_adapter, 0)
		GUICtrlSetData($disableitem, $oLangStrings.menu.tools.enable)
	Else
		_AdapterMod($selected_adapter, 1)
		GUICtrlSetData($disableitem, $oLangStrings.menu.tools.disable)
		_setStatus($oLangStrings.message.updatingList)
		_loadAdapters()
		_setStatus($oLangStrings.message.ready)
	EndIf
EndFunc   ;==>_disable

;------------------------------------------------------------------------------
; Title...........: _onLvDoneEdit
; Description.....: When done editing listview item, rename the profile
;
; Parameters......:
; Return value....:
;------------------------------------------------------------------------------
Func _onLvDoneEdit()
	$lv_newName = ControlListView($hgui, "", $list_profiles, "GetText", $lv_editIndex)
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
EndFunc   ;==>_onLvDoneEdit

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
EndFunc   ;==>_clear

;------------------------------------------------------------------------------
; Title...........: _checkChangelog
; Description.....: Check if new version and change log needs to be displayed.
;                   Then write new version to profiles.ini file.
;
; Parameters......:
; Return value....:
;------------------------------------------------------------------------------
Func _checkChangelog()
	$sVersion = $options.Version
	If $sVersion <> $winVersion Then
		_form_changelog()
		$sVersion = $winVersion
		$options.Version = $sVersion
		IniWrite($sProfileName, "options", "Version", $sVersion)
	EndIf
EndFunc   ;==>_checkChangelog

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

	$ret = _iniRename($sProfileName, $lv_oldName, $lv_newName)
	If $ret = 2 Then
		MsgBox($MB_ICONWARNING, $oLangStrings.message.warning & "!", $oLangStrings.message.profileNameExists)
		_GUICtrlListView_SetItemText($list_profiles, $lv_editIndex, $lv_oldName)
	ElseIf $ret = 1 Or $ret = 3 Then
		_setStatus($oLangStrings.message.errorOccurred, 1)
	Else
		Local $oProfile = $profiles.get($lv_oldName)
		$oProfile.ProfileName = $lv_newName
	EndIf
EndFunc   ;==>_rename


;------------------------------------------------------------------------------
; Title...........: _delete
; Description.....: Delete a profile
;
; Parameters......:
; Return value....:
;------------------------------------------------------------------------------
Func _delete($name = "")
	;check to make sure a profile is selected
	If ControlListView($hgui, "", $list_profiles, "GetSelectedCount") = 0 Then
		_setStatus("No profile is selected!", 1)
		Return 1
	EndIf
	$selIndex = ControlListView($hgui, "", $list_profiles, "GetSelected")

	If Not $lv_editing Then
		$profileName = StringReplace(GUICtrlRead(GUICtrlRead($list_profiles)), "|", "")
		$iniName = iniNameEncode($profileName)
		$ret = IniDelete($sProfileName, $iniName)
		If $ret = 0 Then
			_setStatus($oLangStrings.message.errorOccurred, 1)
		EndIf

		$profiles.remove($profileName)
	Else
		_GUICtrlListView_CancelEditLabel(ControlGetHandle($hgui, "", $list_profiles))
	EndIf

	_updateProfileList()
	If $selIndex = ControlListView($hgui, "", $list_profiles, "GetItemCount") Then
		ControlListView($hgui, "", $list_profiles, "Select", $selIndex - 1)
	Else
		ControlListView($hgui, "", $list_profiles, "Select", $selIndex)
	EndIf
EndFunc   ;==>_delete

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

	If $profiles.exists($profileName) Then
		MsgBox($MB_ICONWARNING, "Warning!", $oLangStrings.message.profileNameExists)
		$lv_startEditing = 1
		Return
	EndIf

	Local $oNewProfile = $profiles.create($profileName)
	Local $adapName = iniNameEncode(GUICtrlRead($combo_adapters))

	$oNewProfile.IpAuto = _StateToStr($radio_IpAuto)
	$oNewProfile.IpAddress = _ctrlGetIP($ip_Ip)
	$oNewProfile.IpSubnet = _ctrlGetIP($ip_Subnet)
	$oNewProfile.IpGateway = _ctrlGetIP($ip_Gateway)
	$oNewProfile.DnsAuto = _StateToStr($radio_DnsAuto)
	$oNewProfile.IpDnsPref = _ctrlGetIP($ip_DnsPri)
	$oNewProfile.IpDnsAlt = _ctrlGetIP($ip_DnsAlt)
	$oNewProfile.RegisterDns = _StateToStr($ck_dnsReg)
	$oNewProfile.AdapterName = $adapName

	$iniName = iniNameEncode($profileName)
	$lv_newItem = 0
	$ret = IniWriteSection($sProfileName, $iniName, $oNewProfile.getSection(), 0)
	If $ret = 0 Then
		_setStatus($oLangStrings.message.errorOccurred, 1)
	EndIf

	$profiles.add($oNewProfile)

	_updateProfileList()
EndFunc   ;==>_new

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
		_setStatus($oLangStrings.message.noProfileSel, 1)
		Return 1
	EndIf

	If $lv_editing Then
		Send("{ENTER}")
		Return
	EndIf

	$profileName = StringReplace(GUICtrlRead(GUICtrlRead($list_profiles)), "|", "")

	Local $oProfile = $profiles.get($profileName)
	Local $adapName = iniNameEncode(GUICtrlRead($combo_adapters))

	$oProfile.IpAuto = _StateToStr($radio_IpAuto)
	$oProfile.IpAddress = _ctrlGetIP($ip_Ip)
	$oProfile.IpSubnet = _ctrlGetIP($ip_Subnet)
	$oProfile.IpGateway = _ctrlGetIP($ip_Gateway)
	$oProfile.DnsAuto = _StateToStr($radio_DnsAuto)
	$oProfile.IpDnsPref = _ctrlGetIP($ip_DnsPri)
	$oProfile.IpDnsAlt = _ctrlGetIP($ip_DnsAlt)
	$oProfile.RegisterDns = _StateToStr($ck_dnsReg)
	$oProfile.AdapterName = $adapName
	$oProfile.Memo = iniNameEncode(GUICtrlRead($memo))

	$iniName = iniNameEncode($profileName)
	$ret = IniWriteSection($sProfileName, $iniName, $oProfile.getSection(), 0)
	If $ret = 0 Then
		_setStatus($oLangStrings.message.errorOccurred, 1)
	EndIf
EndFunc   ;==>_save

;------------------------------------------------------------------------------
; Title...........: _refresh
; Description.....: Load profiles from ini file and update current adapter info
;
; Parameters......: $init  -1=initial refresh don't change status bar text
; Return value....:
;------------------------------------------------------------------------------
Func _refresh($init = 0)
	If $lv_editing Then
		_GUICtrlListView_CancelEditLabel(ControlGetHandle($hgui, "", $list_profiles))
	EndIf

	_updateCombo()
	_loadProfiles()
	_updateProfileList()
	_updateCurrent()
	If $pIdle Then
		If Not $init Or ($init And Not $showWarning) Then
			_setStatus($oLangStrings.message.ready)
		EndIf
;~ 		_GUICtrlToolbar_EnableButton($hToolbar, $tb_apply, True)
		GuiFlatButton_SetState($tbButtonApply, $GUI_ENABLE)
	EndIf
EndFunc   ;==>_refresh

;------------------------------------------------------------------------------
; Title...........: _setProperties
; Description.....: Set fields from profile properties
;
; Parameters......:
; Return value....:
;------------------------------------------------------------------------------
Func _setProperties($init = 0, $profileName = "")
	If Not $init Then
		$profileName = StringReplace(GUICtrlRead(GUICtrlRead($list_profiles)), "|", "")
	EndIf

	If $profiles.exists($profileName) Then
		Local $oProfile = $profiles.get($profileName)
		$ipAuto = $oProfile.IpAuto
		$ipAddress = $oProfile.IpAddress
		$ipSubnet = $oProfile.IpSubnet
		$ipGateway = $oProfile.IpGateway
		GUICtrlSetState($radio_IpMan, $GUI_CHECKED)
		GUICtrlSetState($radio_IpAuto, _StrToState($ipAuto))
		_ctrlSetIP($ip_Ip, $ipAddress)
		_ctrlSetIP($ip_Subnet, $ipSubnet)
		_ctrlSetIP($ip_Gateway, $ipGateway)

		$dnsAuto = $oProfile.DnsAuto
		$dnsPref = $oProfile.IpDnsPref
		$dnsAlt = $oProfile.IpDnsAlt
		$dnsreg = $oProfile.RegisterDns

		GUICtrlSetState($radio_DnsMan, $GUI_CHECKED)
		GUICtrlSetState($radio_DnsAuto, _StrToState($dnsAuto))
		_ctrlSetIP($ip_DnsPri, $dnsPref)
		_ctrlSetIP($ip_DnsAlt, $dnsAlt)
		GUICtrlSetState($ck_dnsReg, _StrToState($dnsreg))

		$memoStr = iniNameDecode($oProfile.Memo)
		GUICtrlSetData($memo, $memoStr)

		$sSaveAdapter = $options.SaveAdapterToProfile
		$profileAdapter = $oProfile.AdapterName
		If ($sSaveAdapter = 1 Or $sSaveAdapter = "true") Then
			$index = _ArraySearch($adapters, $profileAdapter, 1)
			If ($index <> -1) Then
				Local $selection = ControlCommand($hgui, "", $combo_adapters, "FindString", $profileAdapter)
				ControlCommand($hgui, "", $combo_adapters, "SetCurrentSelection", $selection)
			Else
				_GUICtrlComboBox_SetCurSel($combo_adapters, -1)
				_updateCurrent()
			EndIf
		EndIf

		_radios()
	Else
		_setStatus($oLangStrings.message.errorOccurred, 1)
		Return 1
	EndIf
EndFunc   ;==>_setProperties


;helper
Func _ctrlGetIP($Id)
	$ret = _GUICtrlIpAddress_Get($Id)
	If $ret = "0.0.0.0" Then
		$ret = ""
	EndIf

	Return $ret
EndFunc   ;==>_ctrlGetIP

;helper
Func _ctrlSetIP($Id, $ip)
	If $ip <> "" Then
		_GUICtrlIpAddress_Set($Id, $ip)
	Else
		_GUICtrlIpAddress_ClearAddress($Id)
	EndIf
EndFunc   ;==>_ctrlSetIP

;helper
Func _StrToState($str)
	If $str = "true" Or $str = "1" Then
		Return $GUI_CHECKED
	Else
		Return $GUI_UNCHECKED
	EndIf
EndFunc   ;==>_StrToState

;helper
Func _StateToStr($Id)
	$ret = GUICtrlRead($Id)
	If $ret = $GUI_CHECKED Then
		Return "true"
	Else
		Return "false"
	EndIf
EndFunc   ;==>_StateToStr

Func _loadProfiles()
	Local $pname = $sProfileName

	If Not FileExists($pname) Then
		_setStatus($oLangStrings.message.profilesNotFound, 1)
		Return 1
	EndIf

	$names = IniReadSectionNames($pname)
	If @error Then
		_setStatus($oLangStrings.message.errorReadingProf, 1)
		Return 1
	EndIf

	$profiles.removeAll()
	Local $oNewProfile = 0
	For $i = 1 To $names[0]
		$thisName = iniNameDecode($names[$i])
		$thisSection = IniReadSection($pname, $names[$i])
		If @error Then
			ContinueLoop
		EndIf

		$oNewProfile = $profiles.create($thisName)
		For $j = 1 To $thisSection[0][0]
			If $thisName = "Options" Or $thisName = "options" Then
				Switch $thisSection[$j][0]
					Case "Version"
						$options.Version = $thisSection[$j][1]
					Case "MinToTray"
						$options.MinToTray = $thisSection[$j][1]
					Case "StartupMode"
						$options.StartupMode = $thisSection[$j][1]
					Case "Language"
						$options.Language = $thisSection[$j][1]
					Case "StartupAdapter"
						$newName = iniNameDecode($thisSection[$j][1])
						$options.StartupAdapter = $newName
					Case "Theme"
						$options.Theme = $thisSection[$j][1]
					Case "SaveAdapterToProfile"
						$options.SaveAdapterToProfile = $thisSection[$j][1]
					Case "AdapterBlacklist"
						$options.AdapterBlacklist = $thisSection[$j][1]
					Case "PositionX"
						$options.PositionX = $thisSection[$j][1]
					Case "PositionY"
						$options.PositionY = $thisSection[$j][1]
					Case "PositionW"
						$options.PositionW = $thisSection[$j][1]
					Case "PositionH"
						$options.PositionH = $thisSection[$j][1]
					Case "AutoUpdate"
						$options.AutoUpdate = $thisSection[$j][1]
					Case "LastUpdateCheck"
						$options.LastUpdateCheck = $thisSection[$j][1]
				EndSwitch
			Else
				Switch $thisSection[$j][0]
					Case "IpAuto"
						$oNewProfile.IpAuto = $thisSection[$j][1]
					Case "IpAddress"
						$oNewProfile.IpAddress = $thisSection[$j][1]
					Case "IpSubnet"
						$oNewProfile.IpSubnet = $thisSection[$j][1]
					Case "IpGateway"
						$oNewProfile.IpGateway = $thisSection[$j][1]
					Case "DnsAuto"
						$oNewProfile.DnsAuto = $thisSection[$j][1]
					Case "IpDnsPref"
						$oNewProfile.IpDnsPref = $thisSection[$j][1]
					Case "IpDnsAlt"
						$oNewProfile.IpDnsAlt = $thisSection[$j][1]
					Case "RegisterDns"
						$oNewProfile.RegisterDns = $thisSection[$j][1]
					Case "AdapterName"
						$adapName = iniNameEncode($thisSection[$j][1])
						$oNewProfile.AdapterName = $adapName
					Case "Memo"
						$oNewProfile.Memo = $thisSection[$j][1]
				EndSwitch
			EndIf
		Next
		If $thisName <> "Options" Then
			$profiles.add($oNewProfile)
		EndIf
	Next

EndFunc   ;==>_loadProfiles

Func _ImportProfiles($pname)
	If Not FileExists($pname) Then
		_setStatus($oLangStrings.message.profilesNotFound, 1)
		Return 1
	EndIf

	$names = IniReadSectionNames($pname)
	If @error Then
		_setStatus($oLangStrings.message.errorReadingProf, 1)
		Return 1
	EndIf

	Local $oNewProfile = 0
	For $i = 1 To $names[0]
		$thisName = iniNameDecode($names[$i])
		$thisSection = IniReadSection($pname, $names[$i])
		If @error Then
			ContinueLoop
		EndIf

		$oNewProfile = $profiles.create($thisName)
		For $j = 1 To $thisSection[0][0]
			If $thisName <> "Options" And $thisName <> "options" Then
				Switch $thisSection[$j][0]
					Case "IpAuto"
						$oNewProfile.IpAuto = $thisSection[$j][1]
					Case "IpAddress"
						$oNewProfile.IpAddress = $thisSection[$j][1]
					Case "IpSubnet"
						$oNewProfile.IpSubnet = $thisSection[$j][1]
					Case "IpGateway"
						$oNewProfile.IpGateway = $thisSection[$j][1]
					Case "DnsAuto"
						$oNewProfile.DnsAuto = $thisSection[$j][1]
					Case "IpDnsPref"
						$oNewProfile.IpDnsPref = $thisSection[$j][1]
					Case "IpDnsAlt"
						$oNewProfile.IpDnsAlt = $thisSection[$j][1]
					Case "RegisterDns"
						$oNewProfile.RegisterDns = $thisSection[$j][1]
					Case "AdapterName"
						$adapName = iniNameEncode($thisSection[$j][1])
						$oNewProfile.AdapterName = $adapName
					Case "Memo"
						$oNewProfile.Memo = $thisSection[$j][1]
				EndSwitch
			EndIf
		Next
		If $thisName <> "Options" Then
			If $profiles.exists($thisName) Then
				$profiles.set($thisName, $oNewProfile)
			Else
				$profiles.add($oNewProfile)
			EndIf
			$ret = IniWriteSection($sProfileName, $thisName, $oNewProfile.getSection(), 0)
		EndIf
	Next

EndFunc   ;==>_ImportProfiles

Func _updateProfileList()
	$ap_names = $profiles.getNames()
	$lv_count = ControlListView($hgui, "", $list_profiles, "GetItemCount")

	Local $diff = 0
	If UBound($ap_names) <> $lv_count Then $diff = 1

	If Not $diff Then
		For $i = 0 To $lv_count - 1
;~ 			ConsoleWrite($ap_names[$i] & " " & ControlListView( $hgui, "", $list_profiles, "GetText", $i ) & @CRLF)
			If $ap_names[$i] <> ControlListView($hgui, "", $list_profiles, "GetText", $i) Then
				$diff = 1
				ExitLoop
			EndIf
		Next
	EndIf

	If Not $diff Then Return

	$selItem = ControlListView($hgui, "", $list_profiles, "GetSelected")
	_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($list_profiles))
	If IsArray($ap_names) Then
		For $i = 0 To UBound($ap_names) - 1
			GUICtrlCreateListViewItem($ap_names[$i], $list_profiles)
			GUICtrlSetOnEvent(-1, "_onSelect")
		Next
	Else
		_setStatus($oLangStrings.message.errorOccurred, 1)
		Return 1
	EndIf
	If $selItem < UBound($ap_names) Then
		ControlListView($hgui, "", $list_profiles, "Select", $selItem)
	Else
		ControlListView($hgui, "", $list_profiles, "Select", UBound($ap_names) - 1)
	EndIf
EndFunc   ;==>_updateProfileList


Func _updateCurrent($init = 0, $selected_adapter = "")
	If $cmdLine Then Return
	If Not $init Then
		$selected_adapter = GUICtrlRead($combo_adapters)
	EndIf

	If Adapter_Exists($adapters, $selected_adapter) Then
		Local $newDesc = Adapter_GetDescription($adapters, $selected_adapter)
		If GUICtrlRead($lDescription) <> $newDesc Then
			GUICtrlSetData($lDescription, $newDesc)
		EndIf
		If $screenshot Then
			GUICtrlSetData($lMac, $oLangStrings.interface.mac & ": " & "XX-XX-XX-XX-XX-XX")
		Else
			Local $newMAC = $oLangStrings.interface.mac & ": " & Adapter_GetMAC($adapters, $selected_adapter)
			If GUICtrlRead($lMac) <> $newMAC Then
				GUICtrlSetData($lMac, $newMAC)
			EndIf
		EndIf
	Else
		GUICtrlSetData($lDescription, "! " & $oLangStrings.message.adapterNotFound & " !")
		GUICtrlSetData($lMac, "")
	EndIf


	$props = _getIPs($selected_adapter)
	ControlSetText($hgui, "", $label_CurrentIp, $props[0])
	ControlSetText($hgui, "", $label_CurrentSubnet, $props[1])
	ControlSetText($hgui, "", $label_CurrentGateway, $props[2])
	ControlSetText($hgui, "", $label_CurrentDnsPri, $props[3])
	ControlSetText($hgui, "", $label_CurrentDnsAlt, $props[4])
	ControlSetText($hgui, "", $label_CurrentDhcp, $props[5])
	ControlSetText($hgui, "", $label_CurrentAdapterState, $props[6])
	If $props[6] = $oLangStrings.interface.props.adapterStateDisabled Then
		GUICtrlSetData($disableitem, $oLangStrings.menu.tools.enable)
	Else
		GUICtrlSetData($disableitem, $oLangStrings.menu.tools.disable)
	EndIf
EndFunc   ;==>_updateCurrent


Func _filterProfiles()
	Local $aArray[1] = [0]
	_ArrayDelete($aArray, 0)
	$strPattern = GUICtrlRead($input_filter)
	_GUICtrlListView_DeleteAllItems($list_profiles)

	$aNames = $profiles.getNames()
	If $strPattern <> "" Then
		$pattern = '(?i)(?U)' & StringReplace($strPattern, "*", ".*")
		;MsgBox(0,"",$pattern)
		For $k = 0 To UBound($aNames) - 1
			$matched = StringRegExp($aNames[$k], $pattern, $STR_REGEXPMATCH)
			If $matched = 1 Then
				_ArrayAdd($aArray, $aNames[$k])
			EndIf
		Next
	Else
		$aArray = $aNames
	EndIf

	For $i = 0 To UBound($aArray) - 1
		GUICtrlCreateListViewItem($aArray[$i], $list_profiles)
		GUICtrlSetOnEvent(-1, "_onSelect")
	Next
EndFunc   ;==>_filterProfiles


Func _SendToTray()
	Static $tray_tip

	GUISetState(@SW_MINIMIZE, $hGUI)
	GUISetState(@SW_HIDE, $hGUI)
	TrayItemSetText($RestoreItem, $oLangStrings.traymenu.restore)
	If $tray_tip = 0 Then
;~ 		TrayTip("", "Simple IP Config is still running.", 1)
		$tray_tip = 1
	EndIf
EndFunc   ;==>_SendToTray

Func _minimize()
	$sMinToTray = $options.MinToTray
	If $sMinToTray = 1 Or $sMinToTray = "true" Then
		_SendToTray()
	Else
		GUISetState(@SW_MINIMIZE, $hGUI)
	EndIf
EndFunc   ;==>_minimize

Func _maximize()
	GUISetState(@SW_RESTORE, $hGUI)
	GUISetState(@SW_SHOW, $hGUI)
	GUISetState(@SW_RESTORE, $hGUI)

	TrayItemSetText($RestoreItem, $oLangStrings.traymenu.hide)
EndFunc   ;==>_maximize

Func _setStatus($sMessage, $bError = 0, $bTiming = 0)
	If $cmdLine Then Return
	If Not $bTiming Then
		$sStatusMessage = $sMessage
	EndIf

	If $bError Then
		$showWarning = 1
		GUICtrlSetData($statuserror, $sMessage)
		GUICtrlSetState($statuserror, $GUI_SHOW)
		GUICtrlSetState($statustext, $GUI_HIDE)
		GUICtrlSetState($wgraphic, $GUI_SHOW)
		_statusPopup()
	Else
		GUICtrlSetData($statustext, $sMessage)
		GUICtrlSetState($statustext, $GUI_SHOW)
		GUICtrlSetState($statuserror, $GUI_HIDE)
		GUICtrlSetState($wgraphic, $GUI_HIDE)
		_ExitChild($statusChild)
	EndIf
EndFunc   ;==>_setStatus


Func _DomainComputerBelongs($strComputer = "localhost")
	; Generated by AutoIt Scriptomatic
	$Domain = ''

	If $screenshot Then
		$Domain = $oLangStrings.interface.domain & ": ________"
		Return $Domain
	EndIf

	Local $objWMI = ObjGet("winmgmts:{impersonationLevel = impersonate}!\\" & "." & "\root\cimv2")
	If Not IsObj($objWMI) Then Return SetError(1, 0, '')
	$colItems = $objWMI.ExecQuery("SELECT * FROM Win32_ComputerSystem", "WQL", _
			$wbemFlagReturnImmediately + $wbemFlagForwardOnly)

	If IsObj($colItems) Then
		For $objItem In $colItems
			If $objItem.PartOfDomain Then
				$Domain = $oLangStrings.interface.domain & ": " & $objItem.Domain
			Else
				$Domain = $oLangStrings.interface.workgroup & ": " & $objItem.Domain
			EndIf

		Next
	EndIf
	Return $Domain
EndFunc   ;==>_DomainComputerBelongs

Func _MoveToSubnet()
	If WinActive($hgui) And _WinAPI_GetAncestor(_WinAPI_GetFocus(), $GA_PARENT) = ControlGetHandle($hgui, "", $ip_Subnet) Then
		If _GUICtrlIpAddress_Get($ip_Subnet) = "0.0.0.0" Then
			_GUICtrlIpAddress_Set($ip_Subnet, "255.255.255.0")
			_GUICtrlIpAddress_SetFocus($ip_Subnet, 0)
		EndIf
	EndIf
	$movetosubnet = 0
EndFunc   ;==>_MoveToSubnet

#Region -- INI related --
Func iniNameDecode($sName)
	$thisName = StringReplace($sName, "{lb}", "[")
	$thisName = StringReplace($thisName, "{rb}", "]")
	$thisName = StringReplace($thisName, "{crlf}", @CRLF)
	Return $thisName
EndFunc   ;==>iniNameDecode

Func iniNameEncode($sName)
	$iniName = StringReplace($sName, "[", "{lb}")
	$iniName = StringReplace($iniName, "]", "{rb}")
	$iniName = StringReplace($iniName, @CRLF, "{crlf}")
	Return $iniName
EndFunc   ;==>iniNameEncode

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

	$strPos = StringInStr($sFileRead, "[" & $iniNewName & "]")
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
	If @error <> 0 Then
		FileClose($hFileOpen)
		Return 3
	EndIf

	FileClose($hFileOpen)

	Return 0
EndFunc   ;==>_iniRename
#EndRegion -- INI related --

;------------------------------------------------------------------------------
; Title...........: _print
; Description.....: Print message to console with date and time formatting
;
; Parameters......: $message -string to print
;------------------------------------------------------------------------------
Func _print($message = "")
	Static $tTimer = TimerInit(), $iPrev
	Local $iTime = Floor(TimerDiff($tTimer))
	Local $sTime = StringFormat("%d:%.2d:%06.3f", (Floor($iTime / 3600000)), (Floor(Mod($iTime, 3600000) / 60000)), (Mod(Mod($iTime, 3600000), 60000) / 1000))
	Local $iDiff = $iTime - $iPrev
	Local $sDiff = StringFormat("%d:%.2d:%06.3f", (Floor($iDiff / 3600000)), (Floor(Mod($iDiff, 3600000) / 60000)), (Mod(Mod($iDiff, 3600000), 60000) / 1000))

	If $message == "" Then
		ConsoleWrite(@CRLF)
	Else
		ConsoleWrite($sTime & "(" & $sDiff & "):  " & $message & @CRLF)
	EndIf

	$iPrev = $iTime
EndFunc   ;==>_print

Func _regex_stringLiteralEncode($sString)
	Local $sNewString = StringReplace($sString, "\E", "\E\\E\Q", 0, 1)
	Return $sNewString
EndFunc   ;==>_regex_stringLiteralEncode

Func _regex_stringLiteralDecode($sString)
	Local $sNewString = StringReplace($sString, "\E\\E\Q", "\E", 0, 1)
;~ 	$sNewString = StringLeft($sNewString, StringLen($sNewString)-2)
;~ 	$sNewString = StringRight($sNewString, StringLen($sNewString)-2)
	Return $sNewString
EndFunc   ;==>_regex_stringLiteralDecode



;------------------------------------------------------------------------------
; Title...........: _setTheme
; Description.....: set the theme colors
; Parameters......: $bLightTheme: use light theme, otherwise dark
;------------------------------------------------------------------------------
Func _setTheme($bLightTheme = True)
	Local $iState = WinGetState($hgui)
	If BitAND($iState, $WIN_STATE_VISIBLE) Then
		_SendMessage($hgui, $WM_SETREDRAW, False)
	EndIf

	Local $cTheme_Back
	Local $cTheme_Name
	Local $cTheme_Menu, $cTheme_MenuLine, $cTheme_MenuText
	Local $cTheme_ProfileList
	Local $cTheme_ProfileText
	Local $cTheme_SearchBox
	Local $cTheme_SearchText
	Local $cTheme_InfoBox
	Local $cTheme_InfoBoxText
	Local $searchIcon, $copyIcon, $pasteIcon
	Local $ipBack
	Local $cTheme_MemoLabelBackground

	If $bLightTheme Then
		$cTheme_Back = 0xCCCCCC
		$cTheme_Name = 0x555555
		$cTheme_Menu = _WinAPI_GetSysColor($COLOR_MENUBAR)
		$cTheme_ProfileList = 0xFFFFFF
		$cTheme_ProfileText = 0x000000
		$cTheme_SearchBox = 0xFFFFFF
		$cTheme_SearchText = 0x000000
		$cTheme_InfoBox = 0xFFFFFF
		$cTheme_InfoBoxText = 0x000000
		$searchIcon = $pngSearch
		$copyIcon = $pngCopy16
		$pasteIcon = $pngPaste16
		$cTheme_MenuLine = 0x888888
		$cTheme_MenuText = 0x000000
		$ipBack = 0xFFFFFF
		$cTheme_MemoLabelBackground = 0xEEEEEE
	Else
		$cTheme_Back = 0x111111
		$cTheme_Name = 0xB7B7B7
		$cTheme_Menu = 0x373737
		$cTheme_ProfileList = 0x1D1D1D
		$cTheme_ProfileText = 0xE5E5E5
		$cTheme_SearchBox = 0x1D2125
		$cTheme_SearchText = 0xE5E5E5
		$cTheme_InfoBox = 0x373737
		$cTheme_InfoBoxText = 0xE5E5E5
		$searchIcon = $pngSearchDarkmode
		$copyIcon = $pngCopyDarkMode16
		$pasteIcon = $pngPasteDarkMode16
		$cTheme_MenuLine = 0x555555
		$cTheme_MenuText = 0xE5E5E5
		$ipBack = 0xAAAAAA
		$cTheme_MemoLabelBackground = 0x282828
	EndIf

	GUICtrlSetBkColor($menuLineSep, $cTheme_MenuLine)
	GUICtrlSetBkColor($menuLineRight, $cTheme_MenuLine)
	GUICtrlSetBkColor($menuLineBottom, $cTheme_MenuLine)
	GUICtrlSetBkColor($filter_border, $cTheme_MenuLine)

	GUICtrlSetBkColor($ip_Ip, $ipBack)

	Local $aColorsToolsEx = _
			[$cTheme_Menu, 0xFCFCFC, $cTheme_Menu, _     ; normal 	: Background, Text, Border
			$cTheme_Menu, 0xFCFCFC, $cTheme_Menu, _     ; focus 	: Background, Text, Border
			$cTheme_Menu, 0xFCFCFC, $cTheme_Menu, _      ; hover 	: Background, Text, Border
			$cTheme_Menu, 0xFCFCFC, $cTheme_Menu]        ; selected 	: Background, Text, Border

	GuiFlatButton_SetColorsEx($button_New, $aColorsToolsEx)
	GuiFlatButton_SetColorsEx($button_Save, $aColorsToolsEx)
	GuiFlatButton_SetColorsEx($button_Delete, $aColorsToolsEx)

	Local $aColorsEx = _
			[$cTheme_InfoBox, 0xFCFCFC, $cTheme_InfoBox, _ ; normal 	: Background, Text, Border
			$cTheme_InfoBox, 0xFCFCFC, $cTheme_InfoBox, _ ; focus 	: Background, Text, Border
			$cTheme_InfoBox, 0xFCFCFC, $cTheme_InfoBox, _  ; hover 	: Background, Text, Border
			$cTheme_InfoBox, 0xFCFCFC, $cTheme_InfoBox]    ; selected 	: Background, Text, Border

	GUISetBkColor($cTheme_Back, $hgui)
	GUICtrlSetColor($statustext, $cTheme_MenuText)
	GUICtrlSetBkColor($statusbar_background, $cTheme_Menu)
	GUICtrlSetColor($computerName, $cTheme_Name)
	GUICtrlSetColor($domainName, $cTheme_Name)
	GUICtrlSetBkColor($profilebuttons_background, $cTheme_Menu)
	GUICtrlSetBkColor($input_filter, $cTheme_SearchBox)
	GUICtrlSetColor($input_filter, $cTheme_SearchText)
	GUICtrlSetBkColor($filter_background, $cTheme_SearchBox)
	_memoryToPic($searchgraphic, GetIconData($searchIcon))
	GUICtrlSetBkColor($list_profiles, $cTheme_ProfileList)
	GUICtrlSetColor($list_profiles, $cTheme_ProfileText)
	GUICtrlSetBkColor($lvBackground, $cTheme_ProfileList)
	GUICtrlSetColor($lDescription, $cTheme_InfoBoxText)
;~ 	GUICtrlSetBkColor($lDescription, $cTheme_InfoBox)
	GUICtrlSetColor($lMac, $cTheme_InfoBoxText)
;~ 	GUICtrlSetBkColor($lMac, $cTheme_InfoBox)

	GUICtrlSetBkColor($memo, $cTheme_ProfileList)
	GUICtrlSetColor($memo, $cTheme_ProfileText)
	GUICtrlSetColor($memoLabel, $cTheme_ProfileText)
	GUICtrlSetBkColor($memoBackground, $cTheme_ProfileList)
	GUICtrlSetBkColor($memoLabelBackground, $cTheme_MemoLabelBackground)

	GUICtrlSetBkColor($currentInfoBox[0], $cTheme_InfoBox)
	GUICtrlSetBkColor($setInfoBox[0], $cTheme_InfoBox)
	GUICtrlSetBkColor($label_CurrentAdapterState, $cTheme_InfoBox)

	GuiFlatButton_SetColorsEx($buttonRefresh, $aColorsEx)

	GUICtrlSetColor($label_CurrIp, $cTheme_InfoBoxText)
	GUICtrlSetColor($label_CurrSubnet, $cTheme_InfoBoxText)
	GUICtrlSetColor($label_CurrGateway, $cTheme_InfoBoxText)
	GUICtrlSetColor($label_CurrDnsPri, $cTheme_InfoBoxText)
	GUICtrlSetColor($label_CurrDnsAlt, $cTheme_InfoBoxText)
	GUICtrlSetColor($label_CurrDhcp, $cTheme_InfoBoxText)
	GUICtrlSetColor($label_CurrAdapterState, $cTheme_InfoBoxText)

	GUICtrlSetColor($label_CurrentIp, $cTheme_InfoBoxText)
	GUICtrlSetColor($label_CurrentSubnet, $cTheme_InfoBoxText)
	GUICtrlSetColor($label_CurrentGateway, $cTheme_InfoBoxText)
	GUICtrlSetColor($label_CurrentDnsPri, $cTheme_InfoBoxText)
	GUICtrlSetColor($label_CurrentDnsAlt, $cTheme_InfoBoxText)
	GUICtrlSetColor($label_CurrentDhcp, $cTheme_InfoBoxText)
	GUICtrlSetColor($label_CurrentAdapterState, $cTheme_InfoBoxText)

	GUICtrlSetBkColor($label_CurrentIp, $cTheme_InfoBox)
	GUICtrlSetBkColor($label_CurrentSubnet, $cTheme_InfoBox)
	GUICtrlSetBkColor($label_CurrentGateway, $cTheme_InfoBox)
	GUICtrlSetBkColor($label_CurrentDnsPri, $cTheme_InfoBox)
	GUICtrlSetBkColor($label_CurrentDnsAlt, $cTheme_InfoBox)
	GUICtrlSetBkColor($label_CurrentDhcp, $cTheme_InfoBox)

	GUICtrlSetColor($label_ip, $cTheme_InfoBoxText)
	GUICtrlSetColor($label_subnet, $cTheme_InfoBoxText)
	GUICtrlSetColor($label_gateway, $cTheme_InfoBoxText)
	GUICtrlSetColor($label_dnsPri, $cTheme_InfoBoxText)
	GUICtrlSetColor($label_dnsAlt, $cTheme_InfoBoxText)

	GUICtrlSetBkColor($label_ip, $cTheme_InfoBox)
	GUICtrlSetBkColor($label_subnet, $cTheme_InfoBox)
	GUICtrlSetBkColor($label_gateway, $cTheme_InfoBox)
	GUICtrlSetBkColor($label_dnsPri, $cTheme_InfoBox)
	GUICtrlSetBkColor($label_dnsAlt, $cTheme_InfoBox)


	GUICtrlSetBkColor($radio_IpAuto, $cTheme_InfoBox)
	GUICtrlSetBkColor($radio_IpAutoLabel, $cTheme_InfoBox)
	GUICtrlSetColor($radio_IpAutoLabel, $cTheme_InfoBoxText)
	GUICtrlSetBkColor($radio_IpMan, $cTheme_InfoBox)
	GUICtrlSetBkColor($radio_IpManLabel, $cTheme_InfoBox)
	GUICtrlSetColor($radio_IpManLabel, $cTheme_InfoBoxText)

	GUICtrlSetBkColor($radio_DnsAuto, $cTheme_InfoBox)
	GUICtrlSetBkColor($radio_DnsAutoLabel, $cTheme_InfoBox)
	GUICtrlSetColor($radio_DnsAutoLabel, $cTheme_InfoBoxText)
	GUICtrlSetBkColor($radio_DnsMan, $cTheme_InfoBox)
	GUICtrlSetBkColor($radio_DnsManLabel, $cTheme_InfoBox)
	GUICtrlSetColor($radio_DnsManLabel, $cTheme_InfoBoxText)

	GUICtrlSetBkColor($ck_dnsReg, $cTheme_InfoBox)
	GUICtrlSetColor($ck_dnsRegLabel, $cTheme_InfoBoxText)
	GUICtrlSetBkColor($ck_dnsRegLabel, $cTheme_InfoBox)

	GuiFlatButton_SetColorsEx($buttonCopyIp, $aColorsEx)
	GuiFlatButton_SetColorsEx($buttonCopySubnet, $aColorsEx)
	GuiFlatButton_SetColorsEx($buttonCopyGateway, $aColorsEx)
	GuiFlatButton_SetColorsEx($buttonCopyDnsPri, $aColorsEx)
	GuiFlatButton_SetColorsEx($buttonCopyDnsAlt, $aColorsEx)
	GuiFlatButton_SetColorsEx($buttonPasteIp, $aColorsEx)
	GuiFlatButton_SetColorsEx($buttonPasteSubnet, $aColorsEx)
	GuiFlatButton_SetColorsEx($buttonPasteGateway, $aColorsEx)
	GuiFlatButton_SetColorsEx($buttonPasteDnsPri, $aColorsEx)
	GuiFlatButton_SetColorsEx($buttonPasteDnsAlt, $aColorsEx)

	_WinAPI_DeleteObject(_SendMessage(GUICtrlGetHandle($buttonCopyIp), $BM_SETIMAGE, $IMAGE_ICON, _getMemoryAsIcon(GetIconData($copyIcon))))
	_WinAPI_DeleteObject(_SendMessage(GUICtrlGetHandle($buttonCopySubnet), $BM_SETIMAGE, $IMAGE_ICON, _getMemoryAsIcon(GetIconData($copyIcon))))
	_WinAPI_DeleteObject(_SendMessage(GUICtrlGetHandle($buttonCopyGateway), $BM_SETIMAGE, $IMAGE_ICON, _getMemoryAsIcon(GetIconData($copyIcon))))
	_WinAPI_DeleteObject(_SendMessage(GUICtrlGetHandle($buttonCopyDnsPri), $BM_SETIMAGE, $IMAGE_ICON, _getMemoryAsIcon(GetIconData($copyIcon))))
	_WinAPI_DeleteObject(_SendMessage(GUICtrlGetHandle($buttonCopyDnsAlt), $BM_SETIMAGE, $IMAGE_ICON, _getMemoryAsIcon(GetIconData($copyIcon))))

	_WinAPI_DeleteObject(_SendMessage(GUICtrlGetHandle($buttonPasteIp), $BM_SETIMAGE, $IMAGE_ICON, _getMemoryAsIcon(GetIconData($pasteIcon))))
	_WinAPI_DeleteObject(_SendMessage(GUICtrlGetHandle($buttonPasteSubnet), $BM_SETIMAGE, $IMAGE_ICON, _getMemoryAsIcon(GetIconData($pasteIcon))))
	_WinAPI_DeleteObject(_SendMessage(GUICtrlGetHandle($buttonPasteGateway), $BM_SETIMAGE, $IMAGE_ICON, _getMemoryAsIcon(GetIconData($pasteIcon))))
	_WinAPI_DeleteObject(_SendMessage(GUICtrlGetHandle($buttonPasteDnsPri), $BM_SETIMAGE, $IMAGE_ICON, _getMemoryAsIcon(GetIconData($pasteIcon))))
	_WinAPI_DeleteObject(_SendMessage(GUICtrlGetHandle($buttonPasteDnsAlt), $BM_SETIMAGE, $IMAGE_ICON, _getMemoryAsIcon(GetIconData($pasteIcon))))

	If BitAND($iState, $WIN_STATE_VISIBLE) Then
		_SendMessage($hgui, $WM_SETREDRAW, True)
		_WinAPI_RedrawWindow($hgui)
	EndIf
EndFunc   ;==>_setTheme

