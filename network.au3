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

Func _loadAdapters()

	Local $aIPAllAddrTable = _Network_IPAllAddressTable(0, 0, 1)	; get info about all adapters
    Local $nInterfaces = @extended

	Local $tadapters = _GetAdapters()	; get list of adapter names from 'network connections'
	Local $ladapters[1][3] = [[0,0,0]]
	for $i=0 to UBound($tadapters)-1
		$index = _ArraySearch( $aIPAllAddrTable, $tadapters[$i], 0 )
		$mac = ""
		$desc = ""
		If ($index <> -1) Then
			$mac = $aIPAllAddrTable[$index][4]
			$desc = $aIPAllAddrTable[$index][6]
		EndIf
		$ladapters[0][0] = $ladapters[0][0]+1
		_ArrayAdd($ladapters, $tadapters[$i] & "|" & $mac & "|" & $desc)
	Next
	$adapters = $ladapters

EndFunc

Func _loadAdapters_old2()

	Local $aIPAllAddrTable = _Network_IPAllAddressTable(0, 0, 1)	; get info about all adapters
    Local $nInterfaces = @extended

	Local $tadapters = _GetAdapters()	; get list of adapter names from 'network connections'
	Local $ladapters[1][3] = [[0,0,0]]
	for $i=0 to $nInterfaces-1	; keep only names of type ethernet or wifi that also exist in network connections
		$index = _ArraySearch( $tadapters, $aIPAllAddrTable[$i][7], 0 )
		If ($index <> -1) Then
			if $aIPAllAddrTable[$i][1] = 6 or $aIPAllAddrTable[$i][1] = 71 Then
				$ladapters[0][0] = $ladapters[0][0]+1
				_ArrayAdd($ladapters, $aIPAllAddrTable[$i][7] & "|" & $aIPAllAddrTable[$i][4] & "|" & $aIPAllAddrTable[$i][6])
			EndIf
		EndIf
	Next
	$adapters = $ladapters

EndFunc


Func _loadAdapters_old()
;~ 	MsgBox(0,"","hold")
	$timerstart = TimerInit()
	Local $colItems = $objWMI.ExecQuery("SELECT MACAddress, NetConnectionID, Description FROM Win32_NetworkAdapter WHERE NetConnectionID != Null", "WQL")
	Local $i=0
	Local $ladapters[1][3] = [[0,0,0]]
	$timervalue = TimerDiff($timerstart)
	for $objItem in $colItems
		$netID = $objItem.NetConnectionID
;~ 		IF $netID <> Null Then
			$i = $i+1
			$ladapters[0][0] = $i
			_ArrayAdd($ladapters, $netID & "|" & $objItem.MACAddress & "|" & $objItem.Description)
;~ 		EndIf
	Next
	$timervalue = TimerDiff($timerstart)
	;MsgBox(0,"","Query: " & $timervalue/1000 & @CRLF & "Loop: " & TimerDiff($timerstart)/1000 & @CRLF & "Count: " & $colItems.count)

	$adapters = $ladapters
	;_ArrayDisplay($adapters)
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
	_asyncNewCmd($cmd, "Releasing DHCP...")	; run release command
	$cmd = 'ipconfig /renew "' & $adaptername & '"'
	_asyncNewCmd($cmd, "Renewing DHCP...", 1) ; run renew command. Add to queue if not ready
EndFunc

Func _getIPs($adaptername)
	Local $props[7]
	Local $colItems, $thismac
	Local $ip, $subnet, $gateway, $dnspri, $dnsalt, $dnsServer, $dhcpServer, $dhcpEnabled, $sDNS

	Local $aIPAllAddrTable = _Network_IPAllAddressTable(1, 0, 1)	; get info about all adapters (Vista+)
	Local $nInterfaces = @extended
	Local $aIPv4AdaptersInfoEx = _Network_IPv4AdaptersInfoEx()	; get info about all adapters (XP)
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
						$ip = ($aIPv4AdaptersInfoEx[$j][11]="0.0.0.0") ? ("") : ($aIPv4AdaptersInfoEx[$j][11])
						$subnet = ($aIPv4AdaptersInfoEx[$j][12]="0.0.0.0") ? ("") : ($aIPv4AdaptersInfoEx[$j][12])
						$gateway = ($aIPv4AdaptersInfoEx[$j][13]="0.0.0.0") ? ("") : ($aIPv4AdaptersInfoEx[$j][13])
						$sDNS = ($aIPAllAddrTable[$i][13]="0.0.0.0") ? ("") : ($aIPAllAddrTable[$i][13])
						$dhcpServer = ($aIPv4AdaptersInfoEx[$j][15]="0.0.0.0") ? ("") : ($aIPv4AdaptersInfoEx[$j][15])
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
	; Get IP Information if adapter is unplugged

	Local $adapGUID = _doRegGetGUID($adaptername)
;~ 	ConsoleWrite($adapGUID&@CRLF)
	$keyname = "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\Tcpip\Parameters\Interfaces";
	Local $sSubKey, $sSubKeyName, $sGuids, $i=0

	while 1
	  $i += 1
	  $sSubKey=RegEnumKey($keyname,$i)
	  If @error <> 0 then ExitLoop
;~ 	  ConsoleWrite($adapGUID&@CRLF)
	  If $sSubKey <> $adapGUID Then ContinueLoop

	  $sSubKeyValue=RegRead($keyname &"\"& $sSubKey,$ItemName)
;~ 	  ConsoleWrite($sSubKeyValue & @CRLF)
	  return $sSubKeyValue
	Wend

EndFunc

Func _doRegGetGUID($adaptername)
	; Get IP Information if adapter is unplugged

	$keyname = "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Network\{4D36E972-E325-11CE-BFC1-08002BE10318}";
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

Func _getIPs_old($adaptername)
	Local $props[7]
	Local $colItems, $Adapter_caption, $thismac
	Local $ip, $subnet, $gateway, $dnspri, $dnsalt, $dnsServer, $dhcpServer, $dhcpEnabled
	$Adapter_caption = $adaptername
	$thismac = $adapters[_ArraySearch($adapters, $Adapter_caption)][1]
	$colItems = $objWMI.ExecQuery("SELECT IPAddress, IPSubnet, DefaultIPGateway, DNSServerSearchOrder, DHCPEnabled, DHCPServer FROM Win32_NetworkAdapterConfiguration WHERE MACAddress =""" & $thismac & """", "WQL", $wbemFlagReturnImmediately + $wbemFlagForwardOnly)
	For $objItem In $colItems
		$ip = $objItem.IPAddress(0)
		$subnet = $objItem.IPSubnet(0)
		$gateway = $objItem.DefaultIPGateway(0)

		$dnsbound = UBound($objItem.DNSServerSearchOrder())
		$dnsServer = $objItem.DNSServerSearchOrder(0)
		If $dnsbound = 0 Then
			$dnspri = ""
			$dnsalt = ""
		ElseIf $dnsbound = 1 Then
			$dnspri = $objItem.DNSServerSearchOrder(0)
			$dnsalt = ""
		Else ; $dnsbound = 2
			$dnspri = $objItem.DNSServerSearchOrder(0)
			$dnsalt = $objItem.DNSServerSearchOrder(1)
		EndIf

		$dhcpEnabled = $objItem.DHCPEnabled
		If $dhcpEnabled <> 0 Then
			$dhcpServer = $objItem.DHCPServer
		Else
			$dhcpServer = "Static"
		EndIf

		;MsgBox(0,"",$ip & @CRLF & $subnet & @CRLF & $gateway & @CRLF & $dnspri & @CRLF & $dnsalt & @CRLF & $dhcpServer)
		$props[0] = $ip
		$props[1] = $subnet
		$props[2] = $gateway
		$props[3] = $dnspri
		$props[4] = $dnsalt
		$props[5] = $dhcpServer
		ExitLoop
	Next

	$props[6] = _AdapterMod($Adapter_caption, 2)
	Return $props
EndFunc

Func _WMIArrayToString($aArray, $sDelimeter = "|")
    If IsArray($aArray) = 0 Then
        Return SetError(1, 0, "")
    EndIf
    Local $iUbound = UBound($aArray) - 1, $sString
    For $A = 0 To $iUbound
        $sString &= $aArray[$A] & $sDelimeter
    Next
    Return StringTrimRight($sString, StringLen($sDelimeter))
EndFunc   ;==>_WMIArrayToString


;===================================================================================================
; Name            	: _AdapterMod
; Description      	: Activate, deactivate, or get current state of a network adapter
; Syntax            : _AdapterMod($oLanConnection[, $bEnable])
; Parameter(s)    	: $oLanConnection - The name of the Lan connection.
;                     $bEnable        - The state to set the NIC.
;										- 1 for activate : Default
;										- 0 for disable
;										- 2 to get current state
; Requirement(s)   	: WinXP or greater (Windows 2000 untested)
; Return value(s)   : 0 - Success
;					  1 - Could not find Network Connections folder
;					  2 - Could not find the selected Connection name
;					  3 - Enable adapter failed
;					  4 - Disable adapter failed
; Author            : SnappyDog
; Note(s)          	: Much of this code was modified from works by the following:
;					  SvenP and Tlem on the Autoit forums
;					  http://www.autoitscript.com/forum/index.php?showtopic=12645&view=findpost&p=87000
; ====================================================================================================

; ===== Example - input name of connection =====
;~ $ret = _AdapterMod("Local Area Connection", 1)
;~ MsgBox( 0, "", $ret )
;~ $ret = _AdapterMod("Local Area Connection", 2)
;~ MsgBox( 0, "", $ret )
; ===== end Example =====

Func _AdapterMod($oLanConnection, $bEnable = 1)
	Local $strEnableVerb, $strDisableVerb, $ShellApp, $oNetConnections, $oEnableVerb, $oDisableVerb
	Local $begin, $dif, $Res, $temp
; Langage selection.
    Select
		; English (United States)
        Case StringInStr("0409,0809,0c09,1009,1409,1809,1c09,2009,2409,2809,2c09,3009,3409", @OSLang)
            $strEnableVerb = "En&able"
            $strDisableVerb = "Disa&ble"

        ; Français (France)
        Case StringInStr("040c,080c,0c0c,100c,140c,180c", @OSLang)
            $strEnableVerb = "&Activer"
            $strDisableVerb = "&Désactiver"
    EndSelect

; Create virtual folder for Network Connections
    Const $ssfCONTROLS = 49
    $ShellApp = ObjCreate("Shell.Application")				; create shell object
    $oNetConnections = $ShellApp.Namespace($ssfCONTROLS)	; get Network Connections Namespace object

; If no 'Network connections' folder then return error.
    If Not IsObj($oNetConnections) Then
;~         MsgBox( 48, "Error", "Network Connections not found.")
        Return 1
    EndIf

; Find the collection of the network connection name.
    For $FolderItem In $oNetConnections.Items
        If StringLower($FolderItem.Name) = StringLower($oLanConnection) Then
            $oLanConnection = $FolderItem
            ExitLoop
        EndIf
    Next

; If no network connection name then return error.
    If Not IsObj($oLanConnection) Then
;~         MsgBox( 48, "Error", "Could not find " & $oLanConnection)
        Return 2
    EndIf

    $oEnableVerb  = ""
    $oDisableVerb = ""

; Find the state of the network connection.
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
;~         MsgBox(0,"",$Verb.Name)
    Next

If IsObj($temp) Then
	$temp = $temp.DoIt
	$ShellApp.explore($temp)
EndIf

; Enable NIC
    If $bEnable = 1 Then
        If IsObj($oEnableVerb) Then $oEnableVerb.DoIt
    EndIf

; Disable NIC
    If $bEnable = 0 Then
        If IsObj($oDisableVerb) Then $oDisableVerb.DoIt
	EndIf

; Get State
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
			ExitLoop	; 10 second maximum waiting time
		EndIf
		; Control the state of the NIC to exit before the end of waiting time.
        If $bEnable = 1 And _GetNicState($oLanConnection, $strEnableVerb, $strDisableVerb) = 1 Then ExitLoop
        If $bEnable = 0 And _GetNicState($oLanConnection, $strEnableVerb, $strDisableVerb) = 0 Then ExitLoop
        Sleep(100)
    WEnd

; Set the return value of the function.
    $Res = _GetNicState($oLanConnection, $strEnableVerb, $strDisableVerb)
    If $bEnable = 1 And $Res = 0 Then
        Return 3
    ElseIf $bEnable = 0 And $Res = 1 Then
        Return 4
    Else
        Return 0
    EndIf
EndFunc

; Helper Function that give the state of the lan connection (1 = Active  0 = Not Active).
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


;===================================================================================================
; Name            	: _GetAdapters
; Description      	: Retrieve list of all network adapters shown in "Network Connections"
; Syntax            : _GetAdapters()
; Requirement(s)   	: WinXP or greater (Windows 2000 untested)
; Return value(s)   : On Success - Return array containing connection names
;                     On Failure - Return 1
; Author            : SnappyDog
; ====================================================================================================

; ===== Example =====
;~ #include "Array.au3"
;~ $ret = _GetAdapters()
;~ _ArrayDisplay( $ret )
; ===== end Example =====

Func _GetAdapters()
	Local $ShellApp, $oNetConnections, $FolderItem
	Local $myadapters[1] = [0], $iPlaceHolder = 0

; Create virtual folder for Network Connections
    Const $ssfCONTROLS = 49
    $ShellApp = ObjCreate("Shell.Application")				; create shell object
    $oNetConnections = $ShellApp.Namespace($ssfCONTROLS)	; get Network Connections Namespace object

; If no 'Network connections' folder then return error.
    If Not IsObj($oNetConnections) Then
;~         MsgBox( 48, "Error", "Network Connections not found.")
        Return 1
    EndIf

; Find the network adapters
    For $FolderItem In $oNetConnections.Items
		If $iPlaceHolder=0 Then
			$myadapters[$iPlaceHolder] = $FolderItem.name
			$iPlaceHolder += 1
		Else
			ReDim $myadapters[$iPlaceHolder+1]				; expand the array
			$myadapters[$iPlaceHolder] = $FolderItem.name
			$iPlaceHolder += 1
		EndIf
    Next

	Return $myadapters
EndFunc