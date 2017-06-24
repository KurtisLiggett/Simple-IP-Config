#include-once
; ========================================================================================================
; <_NetworkStatistics.au3>
;
; UDF Module for Network Interface Information, as well as Network Statistics.
; IPv4 and IPv6 information is returned wherever possible.
;
; Version 3.2013.07.11
;
; NOTES
; - Gateway, DHCP, DNS and WINS server info can all be retrieved via one of 2 methods:
;	1. If the O/S is Vista+, use _Network_IPAllAddressTable()
;	2. If the O/S is XP, use _Network_IPv4AdaptersInfoEx() for Gateway, DHCP and WINS servers,
;	   and _Network_IPAllAddressTable() for DNS Server info.
;
; - WSAStartup is called on XP O/S's, and WSACleanup on exit.  This is a requirement in order to
;   decode IPv6 addresses.  Hopefully this doesn't interfere with other program elements you are combining
;	the code with.  If so, however.. perhaps its best to have a global variable to indicate if WSAStartup
;	has already been called (see commented out $g_NetStats_WSA_Startup)
;
; * TCP stats doesn't return the # of TCP Packets, but rather the # of Segments
;   See "What's the difference between a TCP segment and a TCP packet?" @
;    http://superuser.com/questions/298087/whats-the-difference-between-a-tcp-segment-and-a-tcp-packet
;   and "Whats the difference between a Packet, Segment and Frame?"
;    http://answers.yahoo.com/question/index?qid=20081211114645AA3VyOK
;
; ** Interface Readings don't align with 'netstat -e'.  I'm not sure of the method that program uses
;    However, the readings are about as accurate as one can get without using Performance Counters,
;    DeviceIOControl (which gives 64-bit totals), and possibly WMI (slower and can be potentially disabled).
;
; TO-DO:
;	_Network_IPAllAddressTable():
;	- Include FULL Interface IP info? (IP Adapter Prefix [XP SP1+], Anycast, Multicast, DNS Suffix [Vista SP1/2008+])
;   - Filtering? Include/Exclude lists for adapter types?
;
; To Look Into:
; - DeviceIOControl for adapter(s) device-level info:
;	 hDevice = CreateFile("\\.\{ADAPTER-GUID-#}", GENERIC_READ | GENERIC_WRITE, 0, 0, OPEN_EXISTING, 0, NULL);
;    pInData = OID_GEN_STATISTICS struct [must initialize a few members] - Vista+ O/S only
;	         = OID_GEN_DIRECTED_BYTES_XMIT / OID_GEN_DIRECTED_BYTES_RCV - Windows XP
;	 DeviceIoControl(hDevice, IOCTL_NDIS_QUERY_GLOBAL_STATS, pInData, nInBufsize, pOutBuffer, nOutBufsize, pdwBytesRecvd, 0)
;
; - WSAEnumProtocols - general Protocol info that can't really be used with IP Helper
; - Winsock/WSA stuff in general - more ways to work with IP addresses and whatnot
;   although nothing I can see regarding the stats we are looking for
;
; Protocol Statistics Functions:
;	_Network_IPStatistics()		; (GetIpStatisticsEx)
;	_Network_TCPStatistics()	; (GetTcpStatisticsEx)
;	_Network_UDPStatistics()	; (GetUdpStatisticsEx)
;	_Network_ICMPStatistics()	; (GetIcmpStatistics/Ex)
;
; Network Adapter & Interface Functions:
;	_Network_IPv4AdaptersInfo()		; IPv4 *Physical Adapters* Info (GetInterfaceInfo)
;									; This retrieves index and Device Name (typically \DEVICE\TCPIP_{GUID#})
;	_Network_IPv4AdaptersInfoEx()	; IPv4 *Physical Adapters* Extended Info (GetAdaptersInfo)
;									; This also retrieves type, name, description, MAC Address,
;									; and Adapter IP, Gateway IP, DHCP IP, and WINS IP addresses
;	_Network_IPv4AddressTable()		; IPv4 Interface Info Table (GetIpAddrTable) -
;									;  full info on logical & physical devices
;	_Network_IPAllAddressTable()	; IPv4/IPv6 Interface Info table (GetAdaptersAddresses) -
;									;  full info on logical & physical devices
;
; Network Statistics for a Given Interface:
;	_Network_InterfaceEntryInfo()	; Interface Entry info (GetIfEntry) -
;									;  Updated info regarding the indexed device (req's index)
;
; INTERNAL:
;	_Network_IP_Long_To_String()
;	_Network_IP_In_Addr_To_String()		; IPv4/IPv6 structure to String
;	_Network_IP_In_Addr_To_StringWSA()	; '' WSA variant, for 'display' type strings
;	_Network_IP_In_Addr_To_StringV() 	; IPv4/IPv6 structure to String on Vista+, WSAStartup not req'd
;	__Network_WSA_Startup()				; Required in order to use _Network_IP_In_Addr_To_String/WSA
;	__Network_WSA_Cleanup()				; Done at shutdown if __Network_WSA_Startup() was called
;	_StringA_FromPtr()
;	_StringW_FromPtr()
;	__Network_Pull_IPFromSocket()		; Pulls IP address from a SOCKET_ADDRESS structure
;	__Network_Pull_IPAdapterAddresses()	; Pulls IP addresses from various 'Anycast-type structures'
;	__Network_Pull_IPFromAddrString()	; Pulls IP addresses from IP_ADDR_STRING structure
;
; Removed [see Older versions]:
;	_Network_InterfaceEntryTable()	; Complete Entry Info for all Interfaces (all indexes) -
;									;  This returns a whole slew of interfaces [for me, 33!]
;
; See also:
;  Registry holds adapter information under this key:
;	HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\NetworkCards
;
; See also - UDF's:
;  <NetworkStatsExample.au3>		; Example usage of this UDF module
;  <NetworkStatistics_Verbose.au3>  ; Extra functions, extra output
;	Performance Counters UDF
;
; Author: Ascend4nt
; ========================================================================================================


;   --------------------    GLOBAL VARIABLES --------------------

; Load DLL so it doesn't get loaded/unloaded each call (handle is also used in DLLCall's)
Global $g_NetStats_hIPHLPAPI_DLL = DllOpen("Iphlpapi.dll")
; Speed up Calls to ws2_32.dll (DLL is loaded with AutoIt anyway)
Global $g_NetStats_hWS2_32_DLL = DllOpen("ws2_32.dll")

; If WSAStartup should be shared with other programs..
;~ Global $g_NetStats_WSA_Startup = False


;   --------------------    UDF's --------------------

; ==============================================================================================
; Func _Network_IPStatistics($bIPv6 = False)
;
; Gets IP Statistics
;
; $bIPv6 = If True/non-zero, return stats for IPv6 Protocol
;
; Returns:
;  Success: Array of IP Stats:
;   [0]  = IP Forwarding Status: [1 = Enabled, 2 = Disabled]
;   [1]  = Default initial time-to-live (TTL) for datagrams
;   [2]  = # Received Datagrams
;   [3]  = # Received Datagrams w/Header errors
;   [4]  = # Received Datagrams w/Address errors
;   [5]  = # Forwarded Datagrams
;   [6]  = # Received Datagrams w/Unknown Protocol
;   [7]  = # Received Datagrams Discarded
;   [8]  = # Received Datagrams Delivered
;   [9]  = # Requested Outgoing Datagrams
;   [10] = # Outgoing Datagrams Discarded
;   [11] = # Transmitted Datagrams Discarded
;   [12] = # Datagrams w/o Routes that were Discarded
;   [13] = TimeOut for Reassembling Incoming Fragmented Datagrams
;   [14] = # Datagrams Requiring Reassembly
;   [15] = # Datagrams Successfully Reassembled
;   [16] = # Datagrams that Failed to be Reassembled
;   [17] = # Datagrams that were Fragmented Successfully
;   [18] = # Datagrams that weren't Fragmented and Discarded
;   [19] = # Fragments created (for Datagrams)
;   [20] = # of Interfaces
;   [21] = # of IP addresses associated with PC
;   [22] = # of Routes in the Routing table
;
;  Failure: Same length array above, with undefined elements, but with @error set:
;	 @error = 2: DLLCall error, @extended = error returned from DLLCall
;    @error = 3: API call returned failure, @extended = API error code
;		Common On Pre XP SP1 Systems: ERROR_NOT_SUPPORTED (50)
;
; Author: Ascend4nt
; ==============================================================================================

Func _Network_IPStatistics($bIPv6 = False)
	Local $aRet, $aIPRet[23], $nProtocol, $stMIB_IPStats

	; AF_INET = 2, AF_INET6 = 23	; <ws2def.h>
	If $bIPv6 Then
		$nProtocol = 23
	Else
		$nProtocol = 2
	EndIf

	$stMIB_IPStats = DllStructCreate("DWORD dwForwarding;DWORD dwDefaultTTL;DWORD dwInReceives;DWORD dwInHdrErrors;" & _
		"DWORD dwInAddrErrors;DWORD dwForwDatagrams;DWORD dwInUnknownProtos;DWORD dwInDiscards;DWORD dwInDelivers;" & _
		"DWORD dwOutRequests;DWORD dwRoutingDiscards;DWORD dwOutDiscards;DWORD dwOutNoRoutes;DWORD dwReasmTimeout;" & _
		"DWORD dwReasmReqds;DWORD dwReasmOks;DWORD dwReasmFails;DWORD dwFragOks;DWORD dwFragFails;DWORD dwFragCreates;" & _
		"DWORD dwNumIf;DWORD dwNumAddr;DWORD dwNumRoutes;")

	$aRet = DllCall($g_NetStats_hIPHLPAPI_DLL, "dword", "GetIpStatisticsEx", "ptr", DllStructGetPtr($stMIB_IPStats), "dword", $nProtocol)
	If @error Then Return SetError(2, @error, $aIPRet)
	; Something other than NO_ERROR returned is an error code
	If $aRet[0] Then Return SetError(3, $aRet[0], $aIPRet)

	For $i = 1 To 23
		$aIPRet[$i - 1] = DllStructGetData($stMIB_IPStats, $i)
	Next

	Return $aIPRet
EndFunc


; ==============================================================================================
; Func _Network_TCPStatistics($bIPv6 = False)
;
; Gets TCP Statistics
;  NOTE: this doesn't return the # of TCP Packets, but rather the # of Segments
;   See "What's the difference between a TCP segment and a TCP packet?" @
;    http://superuser.com/questions/298087/whats-the-difference-between-a-tcp-segment-and-a-tcp-packet
;   and "Whats the difference between a Packet, Segment and Frame?"
;    http://answers.yahoo.com/question/index?qid=20081211114645AA3VyOK
;
; $bIPv6 = If True/non-zero, return stats for IPv6 Protocol
;
; Returns:
;  Success: Array of TCP Stats:
;   [0]  = Rto Algorithm [Other = 1, Constant Time-out = 2,
;                        MIL-STD-1778 Appendix B = 3, Van Jacobson's Algorithm = 4]
;   [1]  = Min. Rto Value in milliseconds
;   [2]  = Max. Rto Value in milliseconds
;   [3]  = Max # of Connections. If -1 (4294967295 unsigned), it is variable
;   [4]  = # Active Opens  [client initiating connection w/server]
;   [5]  = # Passive Opens [server listening for connection request]
;   [6]  = # Failed Connection Attempts
;   [7]  = # Established Connections that were Reset
;   [8]  = # Currently Established Connections
;   [9]  = # Received Segments
;   [10] = # Sent Segments
;   [11] = # Retransmitted Segments
;   [12] = # Receive Errors
;   [13] = # Sent Segments w/Reset Flag set
;   [14] = # Connections (except Listening Connections)
;
;  Failure: Same length array above, with undefined elements, but with @error set:
;	 @error = 2: DLLCall error, @extended = error returned from DLLCall
;    @error = 3: API call returned failure, @extended = API error code
;		Common On Pre XP SP1 Systems: ERROR_NOT_SUPPORTED (50)
;
; Author: Ascend4nt
; ==============================================================================================

Func _Network_TCPStatistics($bIPv6 = False)
	Local $aRet, $aTCPRet[15], $nProtocol, $stMIB_TCPStats

	; AF_INET = 2, AF_INET6 = 23	; <ws2def.h>
	If $bIPv6 Then
		$nProtocol = 23
	Else
		$nProtocol = 2
	EndIf

	$stMIB_TCPStats = DllStructCreate("DWORD dwRtoAlgorithm;DWORD dwRtoMin;DWORD dwRtoMax;DWORD dwMaxConn;" & _
		"DWORD dwActiveOpens;DWORD dwPassiveOpens;DWORD dwAttemptFails;DWORD dwEstabResets;DWORD dwCurrEstab;" & _
		"DWORD dwInSegs;DWORD dwOutSegs;DWORD dwRetransSegs;DWORD dwInErrs;DWORD dwOutRsts;DWORD dwNumConns;")

	$aRet = DllCall($g_NetStats_hIPHLPAPI_DLL, "dword", "GetTcpStatisticsEx", "ptr", DllStructGetPtr($stMIB_TCPStats), "dword", $nProtocol)
	If @error Then Return SetError(2, @error, $aTCPRet)
	; Something other than NO_ERROR returned is an error code
	If $aRet[0] Then Return SetError(3, $aRet[0], $aTCPRet)

	For $i = 1 To 15
		$aTCPRet[$i - 1] = DllStructGetData($stMIB_TCPStats, $i)
	Next

	Return $aTCPRet
EndFunc


; ==============================================================================================
; Func _Network_UDPStatistics($bIPv6 = False)
;
; Gets UDP Statistics
;
; $bIPv6 = If True/non-zero, return stats for IPv6 Protocol
;
; Returns:
;  Success: Array of UDP Stats:
;   [0] = # of Received Datagrams
;   [1] = # Discarded Datagrams due to invalid port specified
;   [2] = # of Received Erroneous Datagrams (doesn't include invalid port datagrams)
;   [3] = # of Sent Datagrams
;   [4] = # of entries in UDP listener Table
;
;  Failure: Same length array above, with undefined elements, but with @error set:
;	 @error = 2: DLLCall error, @extended = error returned from DLLCall
;    @error = 3: API call returned failure, @extended = API error code
;		Common On Pre XP SP1 Systems: ERROR_NOT_SUPPORTED (50)
;
; Author: Ascend4nt
; ==============================================================================================

Func _Network_UDPStatistics($bIPv6 = False)
	Local $aRet, $aUDPRet[5], $nProtocol, $stMIB_UDPStats

	; AF_INET = 2, AF_INET6 = 23	; <ws2def.h>
	If $bIPv6 Then
		$nProtocol = 23
	Else
		$nProtocol = 2
	EndIf

	$stMIB_UDPStats = DllStructCreate("dword dwInDatagrams;dword dwNoPorts;dword dwInErrors;dword dwOutDatagrams;dword dwNumAddrs;")

	$aRet = DllCall($g_NetStats_hIPHLPAPI_DLL, "dword", "GetUdpStatisticsEx", "ptr", DllStructGetPtr($stMIB_UDPStats), "dword", $nProtocol)
	If @error Then Return SetError(2, @error, $aUDPRet)
	; Something other than NO_ERROR returned is an error code
	If $aRet[0] Then Return SetError(3, $aRet[0], $aUDPRet)

	For $i = 1 To 5
		$aUDPRet[$i - 1] = DllStructGetData($stMIB_UDPStats, $i)
	Next

	Return $aUDPRet
EndFunc


; ==============================================================================================
; Func _Network_ICMPStatistics($bIPv6 = False)
;
; Gets ICMP Statistics
; These values don't change as often as others. To 'force' a change, do a
; 'ping www.google.com' from the command prompt to see the numbers increase.
;
; $bIPv6 = If True/non-zero, return stats for IPv6 Protocol
;
; Returns:
;  Success: Array of ICMP Stats:
;   [0] = # Incoming ICMP Messages
;   [1] = # Incoming ICMP Errors
;   [2] = # Outgoing ICMP Messages
;   [3] = # Outgoing ICMP Errors
;  ----- The following was removed for better XP RTM compatibility ---
;   [4] = 256-element Array for Incoming 'Type Counts' - MSDN is unclear
;   [5] = 256-element Array for Outgoing 'Type Counts' - MSDN is unclear
;
;  Failure: Same length array above, with undefined elements, but with @error set:
;	 @error = 2: DLLCall error, @extended = error returned from DLLCall
;    @error = 3: API call returned failure, @extended = API error code
;		Common On Pre XP SP1 Systems: ERROR_NOT_SUPPORTED (50)
;
; Author: Ascend4nt
; ==============================================================================================

Func _Network_ICMPStatistics($bIPv6 = False)
	Local $aRet, $aICMPRet[4], $nProtocol, $stMIB_ICMPStats

	; AF_INET = 2, AF_INET6 = 23	; <ws2def.h>
	If $bIPv6 Then
		$nProtocol = 23
	Else
		$nProtocol = 2
	EndIf

	$stMIB_ICMPStats = DllStructCreate("DWORD dwInMsgs;DWORD dwInErrors;DWORD rgdwInTypeCount[256];" & _
		"DWORD dwOutMsgs;DWORD dwOutErrors;DWORD rgdwOutTypeCount[256];")

	$aRet = DllCall($g_NetStats_hIPHLPAPI_DLL, "dword", "GetIcmpStatisticsEx", "ptr", DllStructGetPtr($stMIB_ICMPStats), "dword", $nProtocol)
	If @error Then
		; API not found? Requires XP SP 1
		If @error = 3 Then
			; Provide a consistent return for IPv6 requests on pre-XP SP1 O/S - ERROR_NOT_SUPPORTED [50]
			If $bIPv6 Then Return SetError(3, 50, $aICMPRet)

			; Pre-'Ex' struct had more elements defined!:
			$stMIB_ICMPStats = DllStructCreate("DWORD dwInMsgs;DWORD dwInErrors;DWORD dwInDestUnreachs;DWORD dwInTimeExcds;DWORD dwInParmProbs;DWORD dwInSrcQuenchs;" & _
			"DWORD dwInRedirects;DWORD dwInEchos;DWORD dwInEchoReps;DWORD dwInTimestamps;DWORD dwInTimestampReps;DWORD dwInAddrMasks;DWORD dwInAddrMaskReps;" & _
			"DWORD dwOutMsgs;DWORD dwOutErrors;DWORD dwOutDestUnreachs;DWORD dwOutTimeExcds;DWORD dwOutParmProbs;DWORD dwOutSrcQuenchs;" & _
			"DWORD dwOutRedirects;DWORD dwOutEchos;DWORD dwOutEchoReps;DWORD dwOutTimestamps;DWORD dwOutTimestampReps;DWORD dwOutAddrMasks;DWORD dwOutAddrMaskReps;")

			$aRet = DllCall($g_NetStats_hIPHLPAPI_DLL, "dword", "GetIcmpStatistics", "ptr", DllStructGetPtr($stMIB_ICMPStats))
			If @error Then Return SetError(2, @error, $aICMPRet)
		Else
			Return SetError(2, @error, $aICMPRet)
		EndIf
	EndIf

	; Something other than NO_ERROR returned is an error code
	If $aRet[0] Then Return SetError(3, $aRet[0], $aICMPRet)

	$aICMPRet[0] = DllStructGetData($stMIB_ICMPStats, 1)
	$aICMPRet[1] = DllStructGetData($stMIB_ICMPStats, 2)
	; By name since their location varies depending on which DLLCall was successful
	$aICMPRet[2] = DllStructGetData($stMIB_ICMPStats, "dwOutMsgs")
	$aICMPRet[3] = DllStructGetData($stMIB_ICMPStats, "dwOutErrors")
#cs
	; rgdwInTypeCount
	Dim $aTmp[256]
	For $i = 1 To 256
		$aTmp[$i - 1] = DllStructGetData($stMIB_ICMPStats, 3, $i)
	Next
	$aICMPRet[4] = $aTmp

	; rgdwOutTypeCount
	For $i = 1 To 256
		$aTmp[$i - 1] = DllStructGetData($stMIB_ICMPStats, 6, $i)
	Next
	$aICMPRet[5] = $aTmp
#ce
	Return $aICMPRet
EndFunc


; ==============================================================================================
; Func _Network_IPv4AddressTable()
;
; Gets the interface-to-IPv4 address Mapping Table
;
; For XP+, MSDN recommends using 'GetAdaptersAddresses' to get both IPv4 and IPv6,
; though its very complicated
;
; Returns:
;  Success: Array of Interfaces info, @extended = # of Interfaces
;   [$i][0] = Interface Index #
;   [$i][1] = IPv4 Address
;   [$i][2] = Subnet Mask #
;   [$i][3] = Broadcast Address #
;   [$i][4] = Max Reassembly Size for Recvd Datagrams
;   [$i][5] = Address Type/State
;		MIB_IPADDR_PRIMARY      = 0x01
;		MIB_IPADDR_DYNAMIC      = 0x04
;		MIB_IPADDR_DISCONNECTED = 0x08
;		MIB_IPADDR_DELETED      = 0x40
;		MIB_IPADDR_TRANSIENT    = 0x80
;
;  Failure: "" with @error set:
;	 @error = 2: DLLCall error, @extended = error returned from DLLCall
;    @error = 3: API call returned failure, @extended = API error code
;
; Author: Ascend4nt
; ==============================================================================================

Func _Network_IPv4AddressTable()
	Local Const $tagMIB_IPADDRROW = "DWORD dwAddr;DWORD dwIndex;DWORD dwMask;DWORD dwBCastAddr;" & _
		"DWORD dwReasmSize;ushort unused1;ushort wType;"

	Local $aRet, $nBufSize, $stTemp, $stMIB_IPADDRROW, $nEntries, $pIPAddrRow, $aIPv4Entries, $nIndex

	; 1st Call - Get required buffer size
	$aRet = DllCall($g_NetStats_hIPHLPAPI_DLL, "dword", "GetIpAddrTable", "ptr", 0, "ulong*", 0, "bool", False)

	If @error Then Return SetError(2, @error, "")

	; Something other than NO_ERROR returned is an error code - hopefully the one we want
	If $aRet[0] Then
		; Anything other than ERROR_INSUFFICIENT_BUFFER (122)? Or is buffer size 0?
		If $aRet[0] <> 122 Or Not $aRet[2] Then Return SetError(3, $aRet[0], "")
;~ 		ConsoleWrite("ERROR_INSUFFICIENT_BUFFER returned. Bufsize = " & DllStructGetSize($stTemp) & ", Required Size = " & $aRet[2] & @CRLF)
	EndIf

	$nBufSize = $aRet[2]
	$stTemp = DllStructCreate("byte [" & $nBufSize & "];")

	; 2nd Call - Now collect the data
	$aRet = DllCall($g_NetStats_hIPHLPAPI_DLL, "dword", "GetIpAddrTable", "ptr", DllStructGetPtr($stTemp), "ulong*", $nBufSize, "bool", True)
	If @error Then Return SetError(2, @error, "")
	; Something other than NO_ERROR returned is an error code
	If $aRet[0] Then Return SetError(3, $aRet[0], "")

	$nEntries = DllStructGetData(DllStructCreate("dword NumEntries;", DllStructGetPtr($stTemp)), 1)

	ConsoleWrite("# of IP Address Table Entries: " & $nEntries & @CRLF)

	; Offset to 1st row
	$pIPAddrRow = DllStructGetPtr($stTemp) + 4

	Dim $aIPv4Entries[$nEntries][6]
	$nIndex = 0

	For $i = 1 To $nEntries
		$stMIB_IPADDRROW = DllStructCreate($tagMIB_IPADDRROW, $pIPAddrRow)

		$aIPv4Entries[$nIndex][0] = DllStructGetData($stMIB_IPADDRROW, "dwIndex")
		$aIPv4Entries[$nIndex][1] = _Network_IP_Long_To_String(DllStructGetData($stMIB_IPADDRROW, "dwAddr"))
		$aIPv4Entries[$nIndex][2] = _Network_IP_Long_To_String(DllStructGetData($stMIB_IPADDRROW, "dwMask"))
		$aIPv4Entries[$nIndex][3] = _Network_IP_Long_To_String(DllStructGetData($stMIB_IPADDRROW, "dwBCastAddr"))
		$aIPv4Entries[$nIndex][4] = DllStructGetData($stMIB_IPADDRROW, "dwReasmSize")
		$aIPv4Entries[$nIndex][5] = DllStructGetData($stMIB_IPADDRROW, "wType")

		; 127.0.0.1 [localhost] Loopback - Ignore it
		If $aIPv4Entries[$nIndex][1] = "127.0.0.1" Then
			; [Localhost] Misc: Subnet Mask = 255.0.0.0, Broadcast = 1.0.0.0, Reassembly = 65535, Type = 1 ('PRIMARY')
			ConsoleWrite("- Found Local Host 127.0.0.1. Skipping index #"&$aIPv4Entries[$nIndex][1]&@CRLF)
		Else
			ConsoleWrite("+ Added Adapter (index #"&$aIPv4Entries[$nIndex][0]&"), IPv4 "&$aIPv4Entries[$nIndex][1]&@CRLF)
			$nIndex += 1
		EndIf

		; Next MIB_IPADDRROW structure in array
		$pIPAddrRow += 24
	Next

	If $nIndex < $nEntries Then
		; NO matches?
		If $nIndex = 0 Then Return SetError(-1, 0, "")

		ReDim $aIPv4Entries[$nIndex][6]
	EndIf

	Return SetExtended($nIndex, $aIPv4Entries)
EndFunc


; ==============================================================================================
; Func _Network_IPAllAddressTable($nIPvFlag = 0, $bGetAllIPs = 0, $bGetDownIntfc = 0)
;
; Gets Info for Network Interface Adapters for both IPv4 and IPv6 protocol types
;
; $nIPvFlag = One of the following:
;		0: IPv4 AND IPv6 Adapters [AF_UNSPEC], 1 = IPv4 Only, 2 = IPv6 Adapters Only
; $bGetAllIPs = If non-zero, All the [Unicast] IP addresses will be retrieved for each
;	protocol - IPv4 and IPv6. Otherwise, at most one of each protocol will be retrieved.
; $bGetDownIntfc = If non-zero, returns interfaces with a status of IfOperStatusDown
;	Default (0) is to skip those interfaces
;
; Returns:
;  Success: 2D Array of Interfaces Info, @extended = # of interfaces returned:
;   $arr[$i][0]  = Interface Index
;   $arr[$i][1]  = Interface Type. Common ones:
;		IF_TYPE_OTHER              = 1
;		IF_TYPE_ETHERNET_CSMACD    = 6   [Ethernet Network]
;		IF_TYPE_ISO88025_TOKENRING = 9   [Token Ring Network]
;		IF_TYPE_FDDI               = 15  [FDDI - Fiber Distributed Data Interface]
;		IF_TYPE_PPP                = 23  [PPP Network]
;		IF_TYPE_SOFTWARE_LOOPBACK  = 24  [Software Loopback]
;		IF_TYPE_ATM                = 37  [ATM Network]
;		IF_TYPE_IEEE80211          = 71  [IEEE 802.11 Wireless]
;		IF_TYPE_TUNNEL             = 131 [Tunnel Interface]
;		IF_TYPE_IEEE1394           = 144 [IEEE 1394 Firewire]
;   $arr[$i][2]  = Operational Status
;		IfOperStatusUp             = 1 - Up and Working
;		IfOperStatusDown           = 2 - Down - Depends on AdminStatus member [see GetIfEntry/Table]
;		IfOperStatusTesting        = 3 - In Testing Mode
;		IfOperStatusUnknown        = 4 - Unknown Status
;		IfOperStatusDormant        = 5 - Pending State, waiting on External event
;		IfOperStatusNotPresent     = 6 (IfOperStatusDown - a component is not present)
;		IfOperStatusLowerLayerDown = 7 (IfOperStatusDown - one of lower layers down)
;   $arr[$i][3]  = Flags
;   $arr[$i][4]  = Physical [MAC] Address in "##-##-##" format
;   $arr[$i][5]  = MTU [Max Trans. Unit] in bytes
;   $arr[$i][6]  = Interface Description/Name
;   $arr[$i][7]  = Interface Friendly Name
;   $arr[$i][8]  = Adapter/Service Name (GUID string, in practice)
;   $arr[$i][9]  = Max Receive Speed [Vista+]
;   $arr[$i][10] = Max Transmit Speed [Vista+]
;   $arr[$i][11] = IPv4 Address(es)
;   $arr[$i][12] = IPv6 Address(es)
;	$arr[$i][13] = DNS IPv4 Address(es)
;	$arr[$i][14] = DNS IPv6 Address(es)
;	$arr[$i][15] = Gateway IPv4 Address(es) [Vista+]
;	$arr[$i][16] = Gateway IPv6 Address(es) [Vista+]
;	$arr[$i][17] = DHCP IPv4 Address(es) [Vista+]
;	$arr[$i][18] = DHCP IPv6 Address(es) [Vista+]
;	$arr[$i][19] = WINS IPv4 Address(es) [Vista+]
;	$arr[$i][20] = WINS IPv6 Address(es) [Vista+]
;   $arr[$i][21] = Connection Type [Vista+]
;		NET_IF_CONNECTION_DEDICATED = 1
;		NET_IF_CONNECTION_PASSIVE   = 2
;		NET_IF_CONNECTION_DEMAND    = 3
;		NET_IF_CONNECTION_MAXIMUM   = 4
;   $arr[$i][22] = Tunnel Type [Vista+]
;		TUNNEL_TYPE_NONE    = 0
;		TUNNEL_TYPE_OTHER   = 1
;		TUNNEL_TYPE_DIRECT  = 2
;		TUNNEL_TYPE_6TO4    = 11
;		TUNNEL_TYPE_ISATAP  = 13
;		TUNNEL_TYPE_TEREDO  = 14
;		TUNNEL_TYPE_IPHTTPS = 15
;
;  Failure: "" with @error set:
;	 @error = 2: DLLCall error, @extended = error returned from DLLCall
;    @error = 3: API call returned failure, @extended = API error code
;
; Author: Ascend4nt
; ==============================================================================================

Func _Network_IPAllAddressTable($nIPvFlag = 0, $bGetAllIPs = 0, $bGetDownIntfc = 0)
	Local Const $tagIP_ADAPTER_ADDRESSES = "ulong Length;dword IfIndex;ptr Next;ptr AdapterName;ptr FirstUnicastAddress;" & _
		"ptr FirstAnycastAddress;ptr FirstMulticastAddress;ptr FirstDnsServerAddress;ptr DnsSuffix;ptr Description;" & _
		"ptr FriendlyName;byte PhysicalAddress[8];dword PhysicalAddressLength;dword Flags;dword Mtu;dword IfType;int OperStatus;" & _
		"dword Ipv6IfIndex;dword ZoneIndices[16];ptr FirstPrefix;" & _		; These are XP SP1 +
		"uint64 TransmitLinkSpeed;uint64 ReceiveLinkSpeed;ptr FirstWinsServerAddress;ptr FirstGatewayAddress;" & _	; Vista+
		"ulong Ipv4Metric;ulong Ipv6Metric;uint64 Luid;STRUCT;ptr Dhcpv4ServerSockAddr;int Dhcpv4ServerSockAddrLen;ENDSTRUCT;" & _	; Alignment fix
		"ulong CompartmentId;STRUCT;ulong NetworkGuidData1;word NetworkGuidData2;word NetworkGuidData3;byte NetworkGuidData4[8];ENDSTRUCT;" & _	;
		"int ConnectionType;int TunnelType;STRUCT;ptr Dhcpv6ServerSockAddr;int Dhcpv6ServerSockAddrLen;ENDSTRUCT;byte Dhcpv6ClientDuid[130];" & _
		"ulong Dhcpv6ClientDuidLength;ulong Dhcpv6Iaid;ptr FirstDnsSuffix;"	; FirstDnsSuffix [last item] is Vista SP1+ / 2008+
;~ 	Local Const $tagIP_ADAPTER_DNS_SUFFIX = "ptr Next;wchar String[256];"
;~ 	Local $stIP_AdapterDNSSuffix
	Local $aRet, $nBufSize, $stBuffer, $stIP_ADAPTER_ADDRESSES, $pIPAAStruct, $nIPAAStSize
	Local $pTemp, $nTemp, $sPhsyicalAddr
	Local $nEntries, $aIPs, $aIPAddrEntries

	If $nIPvFlag = 1 Then
		; AF_INET = 2
		$nIPvFlag = 2
	ElseIf $nIPvFlag = 2 Then
		; AF_INET6 = 23
		$nIPvFlag = 23
	Else
		; AF_UNSPEC = 0
		$nIPvFlag = 0
	EndIf

	; 1st Call - Get required buffer size
	;	Flags used:  GAA_FLAG_SKIP_ANYCAST (0x02) | GAA_FLAG_SKIP_MULTICAST (0x04) | GAA_FLAG_INCLUDE_GATEWAYS (0x80)
	;	We are ONLY interested in UNICAST addresses [other addresses can be obtained, but this keeps it simple]
	$aRet = DllCall($g_NetStats_hIPHLPAPI_DLL, "ulong", "GetAdaptersAddresses", "ulong", $nIPvFlag, "ulong", 0x86 , "ptr", 0, _
					"ptr", 0, "ulong*", 0)
	If @error Then Return SetError(2, @error, "")

	; Something other than ERROR_SUCCESS returned is an error code - hopefully the one we want
	If $aRet[0] Then
		; Anything other than ERROR_BUFFER_OVERFLOW (111)? Or is buffer size 0?
		If $aRet[0] <> 111 Or Not $aRet[5] Then Return SetError(3, $aRet[0], "")
;~ 		ConsoleWrite("ERROR_BUFFER_OVERFLOW returned. Bufsize = " & DllStructGetSize($stTemp) & ", Required Size = " & $aRet[2] & @CRLF)
	EndIf

	$nBufSize = $aRet[5]
	; There's a union in the original definition for the first 2 members which is used for 64-bit alignment,
	; hence the int64 in this definition: (could adjust bufsize to be -8, but its fine to have extra padding)
	$stBuffer = DllStructCreate("int64;byte [" & $nBufSize & "];")

	; 2nd Call - Now collect the data
	$aRet = DllCall($g_NetStats_hIPHLPAPI_DLL, "ulong", "GetAdaptersAddresses", "ulong", $nIPvFlag, "ulong", 0x86, "ptr", 0, _
					"ptr", DllStructGetPtr($stBuffer), "ulong*", $nBufSize)
	If @error Then Return SetError(2, @error, "")
	; Something other than ERROR_SUCCESS returned is an error code
	If $aRet[0] Then Return SetError(3, $aRet[0], "")

;~ 	ConsoleWrite(@CRLF & "Bufsize = " &$nBufSize &", / 448 = " & Floor($nBufSize / 448) & @CRLF)
;~ 	ConsoleWrite(@CRLF & "Bufsize = " &$nBufSize &", / 72 = " & Floor($nBufSize / 72) & @CRLF)

	; Oversize the array to prevent resizes (until the final shrink)
	;	Struct size: XP RTM (32-bit) is 72 and 108 (64-bit), Win7 is 376 (32-bit) and 448 (64bit)
	Dim $aIPAddrEntries[Floor($nBufSize / 72) ][24]

	$nEntries = 0

	; Initial Read location
	$pIPAAStruct = DllStructGetPtr($stBuffer)

	While $pIPAAStruct <> 0
		$stIP_ADAPTER_ADDRESSES = DllStructCreate($tagIP_ADAPTER_ADDRESSES, $pIPAAStruct)

		$nIPAAStSize = DllStructGetData($stIP_ADAPTER_ADDRESSES, "Length")
#cs
		; Little bit of DEBUG
		ConsoleWrite("Structure size:" & $nIPAAStSize & _
			" vs. DLLStructSize: " & DllStructGetSize($stIP_ADAPTER_ADDRESSES) & _
			" pre-XP SP1 size: " & Int(DllStructGetPtr($stIP_ADAPTER_ADDRESSES, "Ipv6IfIndex") - DllStructGetPtr($stIP_ADAPTER_ADDRESSES)) & _
			" Vista+ minimum size: " & Int(DllStructGetPtr($stIP_ADAPTER_ADDRESSES, "TransmitLinkSpeed") - DllStructGetPtr($stIP_ADAPTER_ADDRESSES)) & _
			" Vista pre-SP1 size: "& Int(DllStructGetPtr($stIP_ADAPTER_ADDRESSES, "FirstDnsSuffix") - DllStructGetPtr($stIP_ADAPTER_ADDRESSES)) & @CRLF)
#ce
		$nTemp = DllStructGetData($stIP_ADAPTER_ADDRESSES, "OperStatus")

		; Ignore if Operational Status is 'IfOperStatusDown' or IfType is IF_TYPE_SOFTWARE_LOOPBACK
		;  (possibly IF_TYPE_TUNNEL  too, but this does report transmit/receive data..)
		If ($nTemp = 2 And Not $bGetDownIntfc) Or DllStructGetData($stIP_ADAPTER_ADDRESSES, "IfType") = 24 Then
;~ 			ConsoleWrite("IfOperStatusDown or IF_TYPE_SOFTWARE_LOOPBACK - Excluding this Interface!"&@CRLF)
		Else

			; We require UnicastAddress[es] in order to consider the adapter
			$pTemp = DllStructGetData($stIP_ADAPTER_ADDRESSES, "FirstUnicastAddress")
			If $pTemp <> 0 Then
			; Add a new element to the interface array
				$aIPAddrEntries[$nEntries][0] = DllStructGetData($stIP_ADAPTER_ADDRESSES, "IfIndex")
				$aIPAddrEntries[$nEntries][1] = DllStructGetData($stIP_ADAPTER_ADDRESSES, "IfType")
				; Store Operational Status before $nTemp is modified
				$aIPAddrEntries[$nEntries][2] = $nTemp


			; XP SP1+ Specific Members
				If (Not @AutoItX64 And $nIPAAStSize > 72) Or (@AutoItX64 And $nIPAAStSize > 108) Then	; XP SP1+ O/S Structure?
					; Index extra check - if there's an IPv6 index (XP SP1+ O/S), and it's different, use that
					; instead. A zero value indicates that one of the interfaces isn't available
					$nTemp = DllStructGetData($stIP_ADAPTER_ADDRESSES, "Ipv6IfIndex")

					If $nTemp And $nTemp <> $aIPAddrEntries[$nEntries][0] Then
						$aIPAddrEntries[$nEntries][0] = $nTemp
					EndIf

					; Get all IP Adapter Prefixes [XP SP1+] - must be requested via flag GAA_FLAG_INCLUDE_PREFIX (0x10)
					;$aIPs = __Network_Pull_IPAdapterAddresses(DllStructGetData($stIP_ADAPTER_ADDRESSES, "FirstPrefix"), $bGetAllIPs)
					; ...
				EndIf

				$aIPAddrEntries[$nEntries][3] = DllStructGetData($stIP_ADAPTER_ADDRESSES, "Flags")

			; Physical [MAC] address assembly:
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
				;  **In practice, 'AdapterName' is really a GUID string {GUID-xxx...}
				$aIPAddrEntries[$nEntries][8] = _StringA_FromPtr(DllStructGetData($stIP_ADAPTER_ADDRESSES, "AdapterName"))

				; Get all Unicast IPv4 and IPv6 Addresses - not included if flag GAA_FLAG_SKIP_UNICAST (0x01) is set
				;	$pTemp set to "FirstUnicastAddress" above
				$aIPs = __Network_Pull_IPAdapterAddresses($pTemp, $bGetAllIPs)
				$aIPAddrEntries[$nEntries][11] = $aIPs[2]
				$aIPAddrEntries[$nEntries][12] = $aIPs[3]

				; Get all Anycast Addresses - not included if flag GAA_FLAG_SKIP_ANYCAST (0x02) is set
				;$aIPs = __Network_Pull_IPAdapterAddresses(DllStructGetData($stIP_ADAPTER_ADDRESSES, "FirstAnycastAddress"), $bGetAllIPs)
				; ...
				; Get all Multicast Addresses - not included if flag GAA_FLAG_SKIP_MULTICAST (0x04) is set
				;$aIPs = __Network_Pull_IPAdapterAddresses(DllStructGetData($stIP_ADAPTER_ADDRESSES, "FirstMulticastAddress"), $bGetAllIPs)
				; ...

				; Get all DNS Server Addresses - not included if flag GAA_FLAG_SKIP_DNS_SERVER (0x08) is set
				$aIPs = __Network_Pull_IPAdapterAddresses(DllStructGetData($stIP_ADAPTER_ADDRESSES, "FirstDnsServerAddress"), 1)
				$aIPAddrEntries[$nEntries][13] = $aIPs[2]
				$aIPAddrEntries[$nEntries][14] = $aIPs[3]

			; Vista+ specific members
				If (Not @AutoItX64 And $nIPAAStSize > 144) Or (@AutoItX64 And $nIPAAStSize > 184) Then	; Vista+ O/S Structure
					$aIPAddrEntries[$nEntries][9] = DllStructGetData($stIP_ADAPTER_ADDRESSES, "ReceiveLinkSpeed")
					$aIPAddrEntries[$nEntries][10] = DllStructGetData($stIP_ADAPTER_ADDRESSES, "TransmitLinkSpeed")
					$aIPAddrEntries[$nEntries][21] = DllStructGetData($stIP_ADAPTER_ADDRESSES, "ConnectionType")
					$aIPAddrEntries[$nEntries][22] = DllStructGetData($stIP_ADAPTER_ADDRESSES, "TunnelType")

					; Get all Gateway Addresses [Vista+] - must be requested via flag GAA_FLAG_INCLUDE_GATEWAYS (0x80)
					$aIPs = __Network_Pull_IPAdapterAddresses(DllStructGetData($stIP_ADAPTER_ADDRESSES, "FirstGatewayAddress"), $bGetAllIPs)
					$aIPAddrEntries[$nEntries][15] = $aIPs[2]
					$aIPAddrEntries[$nEntries][16] = $aIPs[3]

					; Dhcpv4Server & Dhcpv6Server, In-struct SOCKET_ADDRESS's:
					$aIPAddrEntries[$nEntries][17] = __Network_Pull_IPFromSocket(DllStructGetPtr($stIP_ADAPTER_ADDRESSES, "Dhcpv4ServerSockAddr"))
					$aIPAddrEntries[$nEntries][18] = __Network_Pull_IPFromSocket(DllStructGetPtr($stIP_ADAPTER_ADDRESSES, "Dhcpv6ServerSockAddr"))

					; Get all WINS Addresses [Vista+] - must be requested via flag GAA_FLAG_INCLUDE_WINS_INFO (0x40)
					$aIPs = __Network_Pull_IPAdapterAddresses(DllStructGetData($stIP_ADAPTER_ADDRESSES, "FirstWinsServerAddress"), $bGetAllIPs)
					$aIPAddrEntries[$nEntries][19] = $aIPs[2]
					$aIPAddrEntries[$nEntries][20] = $aIPs[3]
#cs
				; Vista SP1+/Server 2008+ Specific Members
					If (Not @AutoItX64 And $nIPAAStSize > 368) Or (@AutoItX64 And $nIPAAStSize > 440) Then	; Vista SP1+ O/S Structure
						; Get DNS Suffixes - [Vista SP1+/Server 2008+]
						$pTemp = DllStructGetData($stIP_ADAPTER_ADDRESSES, "FirstDnsSuffix")
						If $pTemp <> 0 Then
							; Cycle through until "Next" is null..
							$stIP_AdapterDNSSuffix = DllStructCreate($tagIP_ADAPTER_DNS_SUFFIX, $pTemp)
							ConsoleWrite("DNS Suffix = " & DllStructGetData($stIP_AdapterDNSSuffix, "String") & @CRLF)
							$pTemp = DllStructGetData($stIP_AdapterDNSSuffix, "Next")
						Else
							ConsoleWrite("DNS Suffix - not available" & @CRLF)
						EndIf
					EndIf
#ce

				;Else
					;$aIPAddrEntries[$nEntries][9, 10, 13, 14] = undefined
				EndIf

;~ 				ConsoleWrite("+ Added Interface (index #"&$aIPAddrEntries[$nEntries][0] & "), " & $aIPAddrEntries[$nEntries][6] & @CRLF)
				$nEntries += 1
			EndIf

		EndIf

		; Next structure in linked list
		$pIPAAStruct = DllStructGetData($stIP_ADAPTER_ADDRESSES, "Next")
	WEnd

	If $nEntries = 0 Then Return SetError(-1, 0, "")

	ReDim $aIPAddrEntries[$nEntries][24]

	Return SetExtended($nEntries, $aIPAddrEntries)
EndFunc


; ==============================================================================================
; Func _Network_IPv4AdaptersInfo()
;
; Gets Info for Network Interface Adapters which have IPv4 Enabled
;
; Returns:
;  Success: 2D Array of Stats, @extended = # of adapters.
;   [$i][0] = Index of Adapter
;   [$i][1] = Name of Adapter in format "\DEVICE\TCPIP_{GUID#}"
;
;  Failure: "" with @error set:
;	 @error = 2: DLLCall error, @extended = error returned from DLLCall
;    @error = 3: API call returned failure, @extended = API error code
;
; Author: Ascend4nt
; ==============================================================================================

Func _Network_IPv4AdaptersInfo()
	Local Const $tagIP_ADAPTER_INDEX_MAP = "ulong Index;wchar Name[128];"

	Local $aRet, $nBufSize, $stTemp, $stIP_ADAPTER_INDEX_MAP, $nNumAdapters, $pIPAIMRow, $aAdapterInfo

	; 1st Call - Get required buffer size
	$aRet = DllCall($g_NetStats_hIPHLPAPI_DLL, "dword", "GetInterfaceInfo", "ptr", 0, "ulong*", 0)

	If @error Then Return SetError(2, @error, "")

	; Something other than NO_ERROR returned is an error code - hopefully the one we want
	If $aRet[0] Then
		; Anything other than ERROR_INSUFFICIENT_BUFFER (122)? Or is buffer size 0?
		If $aRet[0] <> 122 Or Not $aRet[2] Then Return SetError(3, $aRet[0], "")
;~ 		ConsoleWrite("ERROR_INSUFFICIENT_BUFFER returned. Bufsize = " & DllStructGetSize($stTemp) & ", Required Size = " & $aRet[2] & @CRLF)
	EndIf

	$nBufSize = $aRet[2]
	$stTemp = DllStructCreate("byte [" & $nBufSize & "];")

	; 2nd Call - Now collect the data
	$aRet = DllCall($g_NetStats_hIPHLPAPI_DLL, "dword", "GetInterfaceInfo", "ptr", DllStructGetPtr($stTemp), "ulong*", $nBufSize)
	If @error Then Return SetError(2, @error, "")
	; Something other than NO_ERROR returned is an error code
	If $aRet[0] Then Return SetError(3, $aRet[0], "")

	$nNumAdapters = DllStructGetData(DllStructCreate("long NumAdapters;", DllStructGetPtr($stTemp)), 1)

	ConsoleWrite("# of adapters: " & $nNumAdapters & @CRLF)

	; Offset to 1st row
	$pIPAIMRow = DllStructGetPtr($stTemp) + 4

	Dim $aAdapterInfo[$nNumAdapters][2]
	For $i = 0 To $nNumAdapters - 1
		$stIP_ADAPTER_INDEX_MAP = DllStructCreate($tagIP_ADAPTER_INDEX_MAP, $pIPAIMRow)

		$aAdapterInfo[$i][0] = DllStructGetData($stIP_ADAPTER_INDEX_MAP, 1)
		$aAdapterInfo[$i][1] = DllStructGetData($stIP_ADAPTER_INDEX_MAP, 2)

		ConsoleWrite("Adapter Index #" & $aAdapterInfo[$i][0] & ", Name = " & $aAdapterInfo[$i][1] & @CRLF)

		; Next IP_ADAPTER_INDEX_MAP structure in array
		$pIPAIMRow += 260
	Next

	Return SetExtended($nNumAdapters, $aAdapterInfo)
EndFunc


; ==============================================================================================
; Func _Network_IPv4AdaptersInfoEx($bGetAllIPs = 0)
;
; Gets Info for Network Interface Adapters for both IPv4 and IPv6 protocol types
;
; IMPORTANT: Some items without an IP will show up as "0.0.0.0"
;	This is due to how they are represented in the Windows structure as strings,
;	rather than values.
;
; $bGetAllIPs = If non-zero, All IP addresses will be retrieved for each interface:
;	IPv4 Address(es), Gateway Address(es), DHCP Address(es), WINS Secondary Address(es)
;
; Returns:
;  Success: 2D Array of Interfaces Info, @extended = # of interfaces returned:
;   $arr[$i][0]  = Interface Index
;   $arr[$i][1]  = Interface Type. Common ones:
;		IF_TYPE_OTHER              = 1
;		IF_TYPE_ETHERNET_CSMACD    = 6   [Ethernet Network]
;		IF_TYPE_ISO88025_TOKENRING = 9   [Token Ring Network]
;		IF_TYPE_FDDI               = 15  [FDDI - Fiber Distributed Data Interface]
;		IF_TYPE_PPP                = 23  [PPP Network]
;		IF_TYPE_SOFTWARE_LOOPBACK  = 24  [Software Loopback]
;		IF_TYPE_ATM                = 37  [ATM Network]
;		IF_TYPE_IEEE80211          = 71  [IEEE 802.11 Wireless]
;		IF_TYPE_TUNNEL             = 131 [Tunnel Interface]
;		IF_TYPE_IEEE1394           = 144 [IEEE 1394 Firewire]
;   $arr[$i][2]  = DHCP Enabled Flag - If non-zero, elements [$i][13, 14, 15] are valid
;   $arr[$i][3]  = WINS Enabled Flag - If non-zero, elements [$i][9, 10] are valid
;   $arr[$i][4]  = Physical [MAC] Address in "##-##-##" format
;   $arr[$i][5]  = 0 [for common interface]
;   $arr[$i][6]  = Interface Description/Name
;	$arr[$i][7]  = "" (Empty String) [for common interface]
;   $arr[$i][8]  = Adapter/Service Name (GUID string, in practice)
;   $arr[$i][9]  = 0 [for common interface] Primary WINS Server IPv4 Address [Windows Internet Name Service]
;   $arr[$i][10] = 0 [for common interface] Secondary WINS Server IPv4 Address(es)
;   $arr[$i][11] = IPv4 Address(es)
;	$arr[$i][12] = IP Address Mask(s)
;   $arr[$i][13] = Gateway IPv4 Address(es)
;	$arr[$i][14] = Gateway Address Mask(s)
;   $arr[$i][15] = DHCP IPv4 Address(es)	; 255.255.255.255 means DHCP has not yet been reached
;	$arr[$i][16] = DHCP Address Mask(s)
;   $arr[$i][17] = DHCP LeaseObtained Time (as time_t)
;   $arr[$i][18] = DHCP LeaseExpires Time (as time_t)
;   $arr[$i][19] = Primary WINS Server IPv4 Address [Windows Internet Name Service]
;	$arr[$i][20] = Primary WINS Server Address Mask
;	$arr[$i][21] = Secondary WINS Server IPv4 Address(es)
;	$arr[$i][22] = Secondary WINS Server Address Mask(s)
;
;  Failure: "" with @error set:
;	 @error = 2: DLLCall error, @extended = error returned from DLLCall
;    @error = 3: API call returned failure, @extended = API error code
;
; Author: Ascend4nt
; ==============================================================================================

Func _Network_IPv4AdaptersInfoEx($bGetAllIPs = 0)
	Local Const $tagIP_ADAPTER_INFO = "ptr Next;DWORD ComboIndex;char AdapterName[260];char Description[132];" & _
		"UINT AddressLength;BYTE Address[8];DWORD Index;UINT Type;UINT DhcpEnabled;ptr CurrentIpAddress;" & _
		"STRUCT;ptr IpAddressListNext;char IpAddressListIpAddress[16];char IpAddressListIpMask[16];DWORD IpAddressListContext;ENDSTRUCT;" & _
		"STRUCT;ptr GatewayListNext;char GatewayListIpAddress[16];char GatewayListIpMask[16];DWORD GatewayListContext;ENDSTRUCT;" & _
		"STRUCT;ptr DhcpServerNext;char DhcpServerIpAddress[16];char DhcpServerIpMask[16];DWORD DhcpServerContext;ENDSTRUCT;" & _
		"BOOL HaveWins;" & _
		"STRUCT;ptr PrimaryWinsServerNext;char PrimaryWinsServerIpAddress[16];char PrimaryWinsServerIpMask[16];DWORD PrimaryWinsServerContext;ENDSTRUCT;" & _
		"STRUCT;ptr SecondaryWinsServerNext;char SecondaryWinsServerIpAddress[16];char SecondaryWinsServerIpMask[16];DWORD SecondaryWinsServerContext;ENDSTRUCT;" & _
		"long_ptr LeaseObtained;long_ptr LeaseExpires;"

	Local $aRet, $nBufSize, $stBuffer, $pIPAIStruct, $stIP_ADAPTER_INFO, $aAdapterInfo
	Local $nTemp, $sPhsyicalAddr, $nEntries, $aIPs

	; 1st Call - Get required buffer size
	$aRet = DllCall($g_NetStats_hIPHLPAPI_DLL, "dword", "GetAdaptersInfo", "ptr", 0, "ulong*", 0)

	If @error Then Return SetError(2, @error, "")

	; Something other than NO_ERROR returned is an error code - hopefully the one we want
	If $aRet[0] Then
		; Anything other than ERROR_BUFFER_OVERFLOW (111? Or is buffer size 0?
		If $aRet[0] <> 111 Or Not $aRet[2] Then Return SetError(3, $aRet[0], "")
;~ 		ConsoleWrite("ERROR_BUFFER_OVERFLOW returned. Buf Required Size = " & $aRet[2] & @CRLF)
	EndIf

	$nBufSize = $aRet[2]
	$stBuffer = DllStructCreate("byte [" & $nBufSize & "];")

	; 2nd Call - Now collect the data
	$aRet = DllCall($g_NetStats_hIPHLPAPI_DLL, "dword", "GetAdaptersInfo", "ptr", DllStructGetPtr($stBuffer), "ulong*", $nBufSize)
	If @error Then Return SetError(2, @error, "")
	; Something other than NO_ERROR returned is an error code
	If $aRet[0] Then Return SetError(3, $aRet[0], "")

;~ 	ConsoleWrite(@CRLF & "Bufsize = " &$nBufSize &", / 640 = " & Floor($nBufSize / 640) & @CRLF)

	; Oversize the array to prevent resizes (until the final shrink)
	;	Struct size: 640 (32-bit) and 704 (64-bit)
	Dim $aAdapterInfo[Floor($nBufSize / 640) ][23]

	$nEntries = 0

	; Initial Read location
	$pIPAIStruct = DllStructGetPtr($stBuffer)

	While $pIPAIStruct <> 0

		$stIP_ADAPTER_INFO = DllStructCreate($tagIP_ADAPTER_INFO, $pIPAIStruct)
		$aAdapterInfo[$nEntries][0] = DllStructGetData($stIP_ADAPTER_INFO, "Index")
		$aAdapterInfo[$nEntries][1] = DllStructGetData($stIP_ADAPTER_INFO, "Type")
		$aAdapterInfo[$nEntries][2] = DllStructGetData($stIP_ADAPTER_INFO, "DhcpEnabled")
		;   $arr[$i][2]  = DHCP Enabled Flag - If non-zero, elements [$i][13, 14, 15] are valid
		$aAdapterInfo[$nEntries][3] = DllStructGetData($stIP_ADAPTER_INFO, "HaveWins")
		;   $arr[$i][3]  = WINS Enabled Flag - If non-zero, elements [$i][9, 10] are valid

		; Physical [MAC] address assembly:
		$nTemp = DllStructGetData($stIP_ADAPTER_INFO, "AddressLength")
		$sPhsyicalAddr = ""
		For $i = 1 To $nTemp
			$sPhsyicalAddr &= Hex(DllStructGetData($stIP_ADAPTER_INFO, "Address", $i),2) & "-"
		Next
		If $nTemp Then $sPhsyicalAddr = StringTrimRight($sPhsyicalAddr, 1)

		$aAdapterInfo[$nEntries][4] = $sPhsyicalAddr

		$aAdapterInfo[$nEntries][5] = 0		; [for common interface]
		$aAdapterInfo[$nEntries][6] = DllStructGetData($stIP_ADAPTER_INFO, "Description")
;~ 		$aAdapterInfo[$nEntries][7] = ""	; [for common interface]
		$aAdapterInfo[$nEntries][8] = DllStructGetData($stIP_ADAPTER_INFO, "AdapterName")
;~ 		$aAdapterInfo[$nEntries][9] = 0		; [for common interface]
;~ 		$aAdapterInfo[$nEntries][10] = 0	; [for common interface]

		;$aAdapterInfo[$nEntries][11] = DllStructGetData($stIP_ADAPTER_INFO, "IpAddressListIpAddress")
		$aIPs = __Network_Pull_IPFromAddrString(DllStructGetPtr($stIP_ADAPTER_INFO, "IpAddressListNext"), $bGetAllIPs)
		$aAdapterInfo[$nEntries][11] = $aIPs[1]
		$aAdapterInfo[$nEntries][12] = $aIPs[2]
		;$aAdapterInfo[$nEntries][12] = DllStructGetData($stIP_ADAPTER_INFO, "GatewayListIpAddress")
		$aIPs = __Network_Pull_IPFromAddrString(DllStructGetPtr($stIP_ADAPTER_INFO, "GatewayListNext"), $bGetAllIPs)
		$aAdapterInfo[$nEntries][13] = $aIPs[1]
		$aAdapterInfo[$nEntries][14] = $aIPs[2]

	; DhcpEnabled?
		If $aAdapterInfo[$nEntries][2] Then
			;$aAdapterInfo[$nEntries][13] = DllStructGetData($stIP_ADAPTER_INFO, "DhcpServerIpAddress")
			$aIPs = __Network_Pull_IPFromAddrString(DllStructGetPtr($stIP_ADAPTER_INFO, "DhcpServerNext"), $bGetAllIPs)
			$aAdapterInfo[$nEntries][15] = $aIPs[1]
			$aAdapterInfo[$nEntries][16] = $aIPs[2]
			$aAdapterInfo[$nEntries][17] = DllStructGetData($stIP_ADAPTER_INFO, "LeaseObtained")
			$aAdapterInfo[$nEntries][18] = DllStructGetData($stIP_ADAPTER_INFO, "LeaseExpires")
		EndIf

	; HaveWins?
		If $aAdapterInfo[$nEntries][3] Then
			;$aAdapterInfo[$nEntries][9] = DllStructGetData($stIP_ADAPTER_INFO, "PrimaryWinsServerIpAddress")
			$aIPs = __Network_Pull_IPFromAddrString(DllStructGetPtr($stIP_ADAPTER_INFO, "PrimaryWinsServerNext"), $bGetAllIPs)
			$aAdapterInfo[$nEntries][19] = $aIPs[1]
			$aAdapterInfo[$nEntries][20] = $aIPs[2]

			;$aAdapterInfo[$nEntries][10] = DllStructGetData($stIP_ADAPTER_INFO, "SecondaryWinsServerIpAddress")
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


; ==============================================================================================
; Func _Network_InterfaceEntryInfo($nIndex)
;
; Gets Interface Entry Info for a given index
;
; $nIndex = Interface Index for a given Network Adapter
;  This index can be retrieved via a call to one of these functions:
;   GetIfTable/2/2Ex, GetInterfaceInfo, GetIpAddrTable, GetAdaptersAddresses, or GetIfTable
;
; Returns:
;  Success: Array of Interface Entry Info:
;   [0] = Interface Index
;   [1] = Interface Type. Common ones:
;		IF_TYPE_OTHER              = 1
;		IF_TYPE_ETHERNET_CSMACD    = 6   [Ethernet Network]
;		IF_TYPE_ISO88025_TOKENRING = 9   [Token Ring Network]
;		IF_TYPE_FDDI               = 15  [FDDI - Fiber Distributed Data Interface]
;		IF_TYPE_PPP                = 23  [PPP Network]
;		IF_TYPE_SOFTWARE_LOOPBACK  = 24  [Software Loopback]
;		IF_TYPE_ATM                = 37  [ATM Network]
;		IF_TYPE_IEEE80211          = 71  [IEEE 802.11 Wireless]
;		IF_TYPE_TUNNEL             = 131 [Tunnel Interface]
;		IF_TYPE_IEEE1394           = 144 [IEEE 1394 Firewire]
;   [2] = Operational Status
;		IF_OPER_STATUS_NON_OPERATIONAL = 0,
;		IF_OPER_STATUS_UNREACHABLE     = 1,
;		IF_OPER_STATUS_DISCONNECTED    = 2,
;		IF_OPER_STATUS_CONNECTING      = 3,
;		IF_OPER_STATUS_CONNECTED       = 4,
;		IF_OPER_STATUS_OPERATIONAL     = 5
;   [3] = Admin Status
;   [4] = Physical [MAC] Address in "##-##-##" format
;   [5] = MTU [Max Trans. Unit] in bytes
;   [6] = Interface Description
;   [7] = Interface Name in format "\DEVICE\TCPIP_{GUID#}"
;   [8] = Last change [1/100th second]
;   [9] = Interface Speed [bps]
;   [10] = # Recvd Data [in Octets]
;   [11] = # Recvd Unicast Packets
;   [12] = # Recvd Non-Unicast Packets
;   [13] = # Recvd Packets Discarded [no error]
;   [14] = # Recvd Packets Discarded [error]
;   [15] = # Recvd Packets Discarded [unk. protocol]
;   [16] = # Sent Data [in Octets]
;   [17] = # Sent Unicast Packets
;   [18] = # Sent Non-Unicast Packets
;   [19] = # Sent Packets Discarded [no error]
;   [20] = # Sent Packets Discarded [error]
;   [21] = Transmit Queue Length [n/a]
;
;  Failure: "" with @error set:
;	 @error = 2: DLLCall error, @extended = error returned from DLLCall
;    @error = 3: API call returned failure, @extended = API error code
;
; Author: Ascend4nt
; ==============================================================================================

Func _Network_InterfaceEntryInfo($nIndex)
	Local Const $tagMIB_IFROW = "wchar wszName[256];DWORD dwIndex;DWORD dwType;DWORD dwMtu;DWORD dwSpeed;" & _
		"DWORD dwPhysAddrLen;BYTE bPhysAddr[8];DWORD dwAdminStatus;DWORD dwOperStatus;DWORD dwLastChange;" & _
		"DWORD dwInOctets;DWORD dwInUcastPkts;DWORD dwInNUcastPkts;DWORD dwInDiscards;DWORD dwInErrors;" & _
		"DWORD dwInUnknownProtos;DWORD dwOutOctets;DWORD dwOutUcastPkts;DWORD dwOutNUcastPkts;" & _
		"DWORD dwOutDiscards;DWORD dwOutErrors;DWORD dwOutQLen;DWORD dwDescrLen;char bDescr[256];"

	Local $aRet, $stMIB_IFROW, $aIFRow[22], $sPhsyicalAddr, $nTemp

	$stMIB_IFROW = DllStructCreate($tagMIB_IFROW)

	; Set the index we want info on
	DllStructSetData($stMIB_IFROW, "dwIndex", $nIndex)

	$aRet = DllCall($g_NetStats_hIPHLPAPI_DLL, "dword", "GetIfEntry", "ptr", DllStructGetPtr($stMIB_IFROW))
	If @error Then Return SetError(2, @error, "")

	; Something other than NO_ERROR returned is an error code
	If $aRet[0] Then Return SetError(3, $aRet[0], "")

; Get 1st 10 elements in a format compatible with _Network_IPAllAddressTable()'s return
	$aIFRow[0] = DllStructGetData($stMIB_IFROW, "dwIndex")
	$aIFRow[1] = DllStructGetData($stMIB_IFROW, "dwType")
	$aIFRow[2] = DllStructGetData($stMIB_IFROW, "dwOperStatus")
	$aIFRow[3] = DllStructGetData($stMIB_IFROW, "dwAdminStatus")
;~ 	$aIFRow[4] = DllStructGetData($stMIB_IFROW, "bPhysAddr")	; Assembled below
	$aIFRow[5] = DllStructGetData($stMIB_IFROW, "dwMtu")
	$aIFRow[6] = DllStructGetData($stMIB_IFROW, "bDescr")
	$aIFRow[7] = DllStructGetData($stMIB_IFROW, "wszName")
	$aIFRow[8] = DllStructGetData($stMIB_IFROW, "dwLastChange")
	$aIFRow[9] = DllStructGetData($stMIB_IFROW, "dwSpeed")

; Get the rest of useful info

	For $i = 11 To 22
		$aIFRow[$i - 1] = DllStructGetData($stMIB_IFROW, $i)
	Next
	; Physical [MAC] address assembly:
	$nTemp = DllStructGetData($stMIB_IFROW, "dwPhysAddrLen")
	$sPhsyicalAddr = ""
	For $i = 1 To $nTemp
		$sPhsyicalAddr &= Hex(DllStructGetData($stMIB_IFROW, "bPhysAddr", $i),2) & "-"
	Next
	If $nTemp Then $sPhsyicalAddr = StringTrimRight($sPhsyicalAddr, 1)
	$aIFRow[4] = $sPhsyicalAddr

	Return $aIFRow
EndFunc


;   --------------------    INTERNAL FUNCTIONS --------------------


; ==============================================================================================
; Func __Network_WSA_Startup()
;
;  INTERNAL Function - Startup req'd for _Network_IP_In_Addr_To_String/WSA()
;	(WSAAddressToStringA and getnameinfo)
;
; Author: Ascend4nt
; ==============================================================================================

Func __Network_WSA_Startup()
	Static Local $bWSAStartedUp = False
	If Not $bWSAStartedUp Then
		; Must have initialized WSA in order to use WSAAddressToStringA and getnameinfo, and the socket services
		; (inet_ntop and inet_ntoa don't have these req's)
		;	Note that 'str' isn't the 2nd parameter - it's a ptr-to-struct. But we know DLLCall allocates 64K for string buffers..
		Local $aRet = DllCall($g_NetStats_hWS2_32_DLL, "int", "WSAStartup", "word", 0x0202, "str", "")
		If @error Then Return SetError(2, @error, "")
		If $aRet[0] Then Return SetError(3, $aRet[0], "")
		$bWSAStartedUp = True
		OnAutoItExitRegister("__Network_WSA_Cleanup")
	EndIf
	Return True
EndFunc


; ==============================================================================================
; Func __Network_WSA_Startup()
;
;  INTERNAL use - registered as an exit routine by __Network_WSA_Startup()
;
; Author: Ascend4nt
; ==============================================================================================

Func __Network_WSA_Cleanup()
	DllCall($g_NetStats_hWS2_32_DLL, "int", "WSACleanup")
EndFunc

; ==============================================================================================
; Func _StringA_FromPtr(), _StringW_FromPtr
;
;  INTERNAL Functions - Gets an ansi/wide string from a pointer
;
; Author: Ascend4nt
; ==============================================================================================

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

; ==============================================================================================
; Func _Network_IP_Long_To_String()
;
; Converts an IPv4 Address from a Long value into a string (e.g. "127.0.0.1")
;  Technically this takes an in_addr structure, but since that structure is long-sized,
;  we can simply pass a long parameter.
;
; Returns:
;  Success: IP Address String
;  Failure: "" with @error set
;	 @error = 2: DLLCall error, @extended = error returned from DLLCall
;
; Author: Ascend4nt
; ==============================================================================================

Func _Network_IP_Long_To_String($nLong)
	Local $aRet = DllCall($g_NetStats_hWS2_32_DLL, "str", "inet_ntoa", "ulong", $nLong)
	If @error Then Return SetError(2, @error, "")
	Return $aRet[0]
EndFunc

; ==============================================================================================
; Func _Network_IP_In_Addr_To_String($stInAddr, $nSize = 0)
; Func _Network_IP_In_Addr_To_StringWSA($stSockAddrIn, $nSize = 0)
; Func _Network_IP_In_Addr_To_StringV($stSockAddrIn, $nSize = 0)
;
; Convert either an sockaddr, sockaddr_in, sockaddr_in6 or sockaddr_in6_old to
; an IPv4 or IPv6 string.
;
; There's 3 different versions of this function - one which uses WSAAddressToString
; and one that uses getnameinfo.  These 2 more or less return the same info, although
; comments on MSDN suggest that WSAAddressToString doesn't format the string correctly
; for use in comparisons.
;
; Additionally, there's the Vista+ function inet_ntop which is simpler and doesn't require
; a prior call to WSAStartup.  It works on in_addr and in_add6 structures typically,
; so a quick pointer calculation is used to get offsets to those within the sockaddr/6_in structures
;
; $stInAddr = A DLLStruct of type sockaddr, sockaddr_in, sockaddr_in6 or sockaddr_in6_old
;  A simplification of the structures is:
;   sockaddr_in  = "short sin_family;ushort sin_port;ulong sin_addr;char sin_zero[8];"
;   sockaddr_in6 = "short sin6_family;ushort sin6_port;ulong sin6_flowinfo;STRUCT;ushort sin6_addr[8];ENDSTRUCT;ulong sin6_scope_id;"
;   NOTE: sockaddr_in6_old is 4 bytes shorter
;
; $nSize = 0 [default] - use DllStructGetSize, otherwise the actual structure size
;  This is useful if a DllStruct is passed that is a larger size than the part we need
;  (as is typical with sockaddr_in6 being created for sockaddr_in6_old)
;
; IPv4 is of the format "127.0.0.1"	; (4*3) + 3 dots = 15 + null-term = 16
; IPv6 is of the format "2001:0db8:85a3:0042:1000:8a2e:0370:7334" or
;   "0000:0000:0000:0000:0000:0000:192.168.0.1"
;  (8*4) + 7 colons = 39, (6*4) + 6 colons + (4*3) + 3 dots = 45 + 1 null-term = 46
; "The last 32 bits are represented in IPv4-style dotted-octet notation
;  if the address is a IPv4-compatible address." - InetNtop
; Also on StackOverflow "Maximum length of the textual representation of an IPv6 address?"
;  @ http://stackoverflow.com/a/166157
;  [IPv4 Tunneling support]
;
; Returns:
; Success: IPv4 or IPv6 String.
;	NOTE that the loopback address is represented as:
;		IPv4: 127.0.0.1 [localhost], IPv6: ::1
;
;  Failure: "" with @error set:
;	 @error = 2: DLLCall error, @extended = error returned from DLLCall
;    @error = 3: API call returned failure, @extended = API error code
;
; Author: Ascend4nt
; ==============================================================================================

Func _Network_IP_In_Addr_To_StringWSA($stSockAddrIn, $nSize = 0)
	If Not IsDllStruct($stSockAddrIn) Then Return SetError(1,0,"")

	If Not __Network_WSA_Startup() Then Return SetError(@error, @extended, "")

	; Size adjustment - see UDF header
	If Int($nSize) = 0 Then
		$nSize = DllStructGetSize($stSockAddrIn)
	Else
		; Only valid structure sizes!
		If $nSize <> 16 And $nSize <> 28 And $nSize <> 32 Then Return SetError(1,0,"")
	EndIf

;~ 	ConsoleWrite("_Network_IP_In_Addr_To_StringWSA - ptr = " & DllStructGetPtr($stSockAddrIn) & ", Size = " &$nSize & @CRLF)

	Local $aRet = DllCall($g_NetStats_hWS2_32_DLL, "int", "WSAAddressToStringA", "ptr", DllStructGetPtr($stSockAddrIn), "dword", _
		$nSize, "ptr", 0, "str", "", "dword*", 46)
	If @error Then Return SetError(2,@error,"")
	; Non-zero means error [SOCKET_ERROR (-1) should be returned, and WSAGetLastError called for more info]
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

	; Replace '%xx' that shows up at the end of certain addresses - this is the Interface Index #
	Local $nPos = StringInStr($aRet[4], "%", 1, 1)
	If $nPos Then
		$aRet[4] = StringLeft($aRet[4], $nPos - 1)
	EndIf
	Return $aRet[4]
EndFunc

; - getnameinfo variant -

Func _Network_IP_In_Addr_To_String($stSockAddrIn, $nSize = 0)
	If Not IsDllStruct($stSockAddrIn) Then Return SetError(1,0,"")

	If Not __Network_WSA_Startup() Then Return SetError(@error, @extended, "")

	; Size adjustment - see UDF header
	If Int($nSize) = 0 Then
		$nSize = DllStructGetSize($stSockAddrIn)
	Else
		; Only valid structure sizes!
		If $nSize <> 16 And $nSize <> 28 And $nSize <> 32 Then Return SetError(1,0,"")
	EndIf

;~ 	ConsoleWrite("_Network_IP_In_Addr_To_String - ptr = " & DllStructGetPtr($stSockAddrIn) & ", Size = " &$nSize & @CRLF)
	; NI_NUMERICHOST = 0x02
	Local $aRet = DllCall($g_NetStats_hWS2_32_DLL, "int", "getnameinfo", "ptr", DllStructGetPtr($stSockAddrIn), "dword", _
		$nSize, "str", "", "dword", 46, "ptr", 0, "dword", 0, "int", 0x02)
	If @error Then Return SetError(2,@error,"")
	; Non-zero means error [Code is in IETF format, and WSAGetLastError should be called for local format]
	If $aRet[0] Then
		ConsoleWrite("Error from getnameinfo: " & $aRet[0] & @CRLF)
		$aRet = DllCall($g_NetStats_hWS2_32_DLL, "int", "WSAGetLastError")
		If Not @error Then
			ConsoleWrite("WSAGetLastError = " & $aRet[0] & @CRLF)
			Return SetError(3,$aRet[0],"")
		Else
			Return SetError(2,@error,"")
		EndIf
	EndIf

	; Replace '%xx' that shows up at the end of certain addresses - this is the Interface Index #
	Local $nPos = StringInStr($aRet[3], "%", 1, 1)
	If $nPos Then
		$aRet[3] = StringLeft($aRet[3], $nPos - 1)
	EndIf

	Return $aRet[3]
EndFunc

; -- inet_ntop variant --  [Vista+]

Func _Network_IP_In_Addr_To_StringV($stSockAddrIn, $nSize = 0)
	If Not IsDllStruct($stSockAddrIn) Then Return SetError(1,0,"")

	; Size adjustment - see UDF header
	If Int($nSize) = 0 Then
		$nSize = DllStructGetSize($stSockAddrIn)
	Else
		; Only valid structure sizes!
		If $nSize <> 16 And $nSize <> 28 And $nSize <> 32 Then Return SetError(1,0,"")
	EndIf

	Local $nType, $pInAddr

	; Set up pointer and type based on whether its IPv4 or IPv6
	;	NOTE: Could just use inet_ntoa for IPv4 (_Network_IP_Long_To_String)
	If $nSize = 16 Then
		$nType = 2	; AF_INET
		$pInAddr = DllStructGetPtr($stSockAddrIn, 3)	; "sin_addr"
	Else
		$nType = 23	; AF_INET6
		$pInAddr = DllStructGetPtr($stSockAddrIn, 4)	; "sin6_addr"
	EndIf

;~ 	ConsoleWrite("_Network_IP_In_Addr_To_StringV - ptr = " & $pInAddr & ", Size = " & $nSize)

	Local $aRet = DllCall($g_NetStats_hWS2_32_DLL, "ptr", "inet_ntop", "int", $nType, "ptr", $pInAddr, "str", "", "ulong_ptr", 46)
	If @error Then Return SetError(2,@error,"")
	; NULL return? Error
	If $aRet[0] = 0 Then Return SetError(3,0,"")

;~ 	ConsoleWrite(" - Return: " & $aRet[3] & @CRLF)

	Return $aRet[3]
EndFunc

; ==============================================================================================
; Func __Network_Pull_IPFromSocket($pSocketAddress)
;
; INTERNAL function to get IP addreses from a SOCKET_ADDRESS structure
;
; Returns:
;  Success: String representing IP Address, @extended is the type:
;	@extended = 4 means IPv4 address of type "192.168.1.1"
;	@extended = 6 means IPv6 address of type "ead:10c:2b:4f1a:30fd"
;
;  Failure: @error set, and empty string ""
;
; Author: Ascend4nt
; ==============================================================================================

Func __Network_Pull_IPFromSocket($pSocketAddress)
	; XP, XPe, 2000, or 2003? - Affects call to _Network_IP_In_Addr_To_String
	Static Local $b_OS_PreVista = StringRegExp(@OSVersion,"_(XP|200(0|3))")
	; SOCKET_ADDRESS structure
	Local Const $tagSOCKET_ADDRESS = "ptr lpSockaddr;int iSockaddrLength;"
	; 16 bytes long (size stored in SOCKET_ADDRESS structures as iSockaddrLength)
	Local Const $tagSOCKADDR_IN  = "short sin_family;ushort sin_port;ulong sin_addr;char sin_zero[8];"
	; Note sockaddr_in6_old is 28 bytes long and doesn't contain 'sin6_scope_id', whereas the 'new' version is 32 bytes.
	; Use the iSockaddrLength field in a SOCKET_ADDRESS structure to determine whether 'sin6_scope_id' is present and can be accessed.
	; It's safe to use DLLStructCreate with $tagSOCKADDR_IN6 in both cases, so long as 'sin6_scope_id' is *ONLY* accessed if size = 32
	Local Const $tagSOCKADDR_IN6 = "short sin6_family;ushort sin6_port;ulong sin6_flowinfo;STRUCT;ushort sin6_addr[8];ENDSTRUCT;ulong sin6_scope_id;"

	If Not IsPtr($pSocketAddress) Or $pSocketAddress = 0 Then Return SetError(1,0,"")

	Local $stSocketAddress, $stSockAddrIn, $pSockAddrIn, $nSockAddrLen

	$stSocketAddress = DllStructCreate($tagSOCKET_ADDRESS, $pSocketAddress)
	$pSockAddrIn = DllStructGetData($stSocketAddress, "lpSockaddr")

	; null pointer?
	If $pSockAddrIn = 0 Then Return SetError(-1,0,"")

	$nSockAddrLen = DllStructGetData($stSocketAddress, "iSockaddrLength")

	; IPv4 Address? [verified by using a short at lpSockAddr, comparing to AF_INET [2])
	If $nSockAddrLen = 16 Then
		$stSockAddrIn = DllStructCreate($tagSOCKADDR_IN, $pSockAddrIn)
;~ 		ConsoleWrite("  sockaddr_in found: sin_family = " & DllStructGetData($stSockAddrIn, "sin_family") & @CRLF)
;~ 		ConsoleWrite("  --> IPv4 Address: 32-bit #: " &DllStructGetData($stSockAddrIn, "sin_addr")& _
;~ 			", as string: " & _Network_IP_Long_To_String(DllStructGetData($stSockAddrIn,"sin_addr")) & @CRLF)

		Return SetExtended(4, _Network_IP_Long_To_String(DllStructGetData($stSockAddrIn, "sin_addr")) )

	; IPv6 Address [verified by using a short at lpSockAddr, comparing to AF_INET6 [23])
	ElseIf $nSockAddrLen >= 28 Then
		$stSockAddrIn = DllStructCreate($tagSOCKADDR_IN6, $pSockAddrIn)
;~ 		ConsoleWrite("  sockaddr_in6[_old] found: sin6_family = " & DllStructGetData($stSockAddrIn, "sin6_family")&@CRLF)
;~ 		ConsoleWrite("  --> IPv6 Address: 16b-bit pairs: ")
;~ 		For $i = 1 To 8
;~ 			ConsoleWrite(Hex(DllStructGetData($stSockAddrIn, "sin6_addr", $i), 4) & "-")
;~ 		Next
;~ 		ConsoleWrite(", as string: " &	_Network_IP_In_Addr_To_StringWSA($stSockAddrIn, $nSockAddrLen) &@CRLF)

		If $b_OS_PreVista Then
			Return SetExtended(6, _Network_IP_In_Addr_To_StringWSA($stSockAddrIn, $nSockAddrLen))
		Else
			Return SetExtended(6, _Network_IP_In_Addr_To_StringV($stSockAddrIn, $nSockAddrLen))
		EndIf
	EndIf
	Return SetError(-1,0,"")
EndFunc

; ==============================================================================================
; Func __Network_Pull_IPAdapterAddresses($pAnyCastStart, $bGetAllIPs = 0)
;
; INTERNAL function to get IP addresses from 'AnyCast-type structures'  This includes:
; IP_ADAPTER_ANYCAST_ADDRESS, IP_ADAPTER_UNICAST_ADDRESS,  IP_ADAPTER_MULTICAST_ADDRESS,
; IP_ADAPTER_DNS_SERVER_ADDRESS, IP_ADAPTER_PREFIX, IP_ADAPTER_WINS_SERVER_ADDRESS,
; and IP_ADAPTER_GATEWAY_ADDRESS structures
;
; While they are all different structures, the initial part of all of them is the same
; right up to the last member of IP_ADAPTER_ANYCAST_ADDRESS.  If $bGetAllIPs is non-zero,
; the entire linked-list of structures is traversed and all IP's retrieved.
;
; $bGetAllIPs = If non-zero, All the [Unicast] IP addresses will be retrieved for each
;	protocol - IPv4 and IPv6. Otherwise, at most one of each protocol will be retrieved.
;
; Returns:
;  Success: Array of IP Info:
;	[0] = # of IPv4 addresses found/retrieved
;   [1] = # of IPv6 Addresses found/retrieved
;	[2] = IPv4 Addresses - If more than one, they are separated with "|"
;	[3] = IPv6 Addresses - If more than one, they are separated with "|"
;
;  Failure: Same array, but with @error set:
;	 @error = 1: Either the 1st parameter is null, or not a pointer
;
; Author: Ascend4nt
; ==============================================================================================

Func __Network_Pull_IPAdapterAddresses($pAnyCastStart, $bGetAllIPs = 0)
	Local Const $tagIP_ADAPTER_ANYCAST_ADDRESS = "ulong Length;dword Flags;ptr Next;STRUCT;ptr AddressSockAddr;int AddressSockAddrLen;ENDSTRUCT;"
;~ 	Local Const $tagIP_ADAPTER_UNICAST_ADDRESS = $tagIP_ADAPTER_ANYCAST_ADDRESS & "int PrefixOrigin;int SuffixOrigin;" & _
;~ 		"int DadState;ulong ValidLifetime;ulong PreferredLifetime;ulong LeaseLifetime;byte OnLinkPrefixLength;"	; OnLinkPrefixLength is Vista+ only

	; Guaranteed array return
	Local $aIPs[4] = [0, 0, "", ""]

	; No judgments, just return empty arrays for invalid parameters (null ptr is 'sorta' valid)
	If Not IsPtr($pAnyCastStart) Or $pAnyCastStart = 0 Then Return SetError(1,0,$aIPs)

	Local $sIPStr, $nIPv4s = 0, $nIPv6s = 0
	Local $pIPAAAddress, $stAnyCastAddress

	$pIPAAAddress = $pAnyCastStart
	; Now Move through all Anycast-type structures and collect IPv4 and IPv6 addresses
	Do
		$stAnyCastAddress = DllStructCreate($tagIP_ADAPTER_ANYCAST_ADDRESS, $pIPAAAddress)

		$sIPStr = __Network_Pull_IPFromSocket(DllStructGetPtr($stAnyCastAddress, "AddressSockAddr"))
		; IPv4?
		If @extended = 4 Then
			If $bGetAllIPs Or Not $nIPv4s Then
				If $nIPv4s Then
					$aIPs[2] &= "|"
				EndIf
				$aIPs[2] &=  $sIPStr
				$nIPv4s += 1
			EndIf
		; IPv6
		ElseIf @extended = 6 Then
			If $bGetAllIPs Or Not $nIPv6s Then
				If $nIPv6s Then
					$aIPs[3] &= "|"
				EndIf
				$aIPs[3] &=  $sIPStr
				$nIPv6s += 1
			EndIf
		EndIf

		$pIPAAAddress = DllStructGetData($stAnyCastAddress, "Next")
	Until $pIPAAAddress = 0

	$aIPs[0] = $nIPv4s
	$aIPs[1] = $nIPv6s

	Return $aIPs
EndFunc

; ==============================================================================================
; Func __Network_Pull_IPFromAddrString($pIPAddrStr, $bGetAllIPs = 0)
;
; INTERNAL function to get IP Addresses and IP Masks from IP_ADDR_STRING structures.
; (called by _Network_IPv4AdaptersInfoEx())
;
; NOTE: Should we check for and erase "0.0.0.0" IP addresses?
;
; $bGetAllIPs = If non-zero, All the IP addresses will be retrieved
;
; Returns:
;  Success: Array of IP Info:
;	[0] = # of IPv4 addresses/masks found/retrieved
;	[1] = IPv4 Addresses - If more than one, they are separated with "|"
;	[2] = IPv4 Masks - If more than one, they are separated with "|"
;
;  Failure: Same array, but with @error set:
;	 @error = 1: Either the 1st parameter is null, or not a pointer
;
; Author: Ascend4nt
; ==============================================================================================

Func __Network_Pull_IPFromAddrString($pIPAddrStr, $bGetAllIPs = 0)
	Local Const $tagIP_ADDR_STRING = "ptr Next;char IpAddress[16];char IpMask[16];DWORD Context;"

	; Guaranteed array return
	Local $aIPs[4] = [0, "", ""]

	; Return empty arrays even for invalid parameters (null ptr is 'sorta' valid)
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

	;ConsoleWrite("__Network_Pull_IPFromAddrString: IPv4s: " & $aIPs[1] & ", IPv4 Masks: " & $aIPs[2] & @CRLF)

	Return $aIPs
EndFunc
