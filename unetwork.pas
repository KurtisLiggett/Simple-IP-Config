unit uNetwork;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, ShlObj, Windows, ActiveX, ComObj, LazLogger,
  JwaIpHlpApi, JwaIpTypes, JwaWinsock2, uTypes, Variants, comserv;

type
  TStringArray = array of string;

function GetAdapterList(): TStringArray;
function GetIpInfo(AdapterName: string): TAdapter;
function SetIpAddresses(const adapterName, ipAddress, subnetMask, gateway: string): boolean;
function SetDnsAddresses(const adapterName, preferredDNS, alternateDNS: string): Boolean;
procedure GetNetworkAdapterInfo;
function ValidateIpAddress(IpAddress: string): integer;
function GetNetworkAdapterStatus(const AdapterName: string): string;

implementation

{ Functions for getting network info }

function GetAdapterList(): TStringArray;
var
  Shell: variant;
  oNetConnections: olevariant;
  OleFolder: olevariant;
  OleFolderItem: olevariant;
  oEnum: IEnumvariant;
  ssfCONTROLS: olevariant;
  pCeltFetched: longword;
  i: integer;

begin
  ssfCONTROLS := 49;
  Shell := CreateOleObject('Shell.Application');
  oNetConnections := Shell.NameSpace(ssfCONTROLS);
  oEnum := IUnknown(oNetConnections.Items._NewEnum) as IEnumVariant;

  SetLength(Result, oNetConnections.Items.Count);
  i := 0;

  pCeltFetched := 0;
  while oEnum.Next(1, OleFolderItem, pCeltFetched) = 0 do
  begin
    Result[i] := OleFolderItem.Name;
    Inc(i);
  end;
end;

function GetIpInfo(AdapterName: string): TAdapter;
const
  WORKING_BUFFER_SIZE = 15000;
  MAX_TRIES = 3;

  { Family }
  AF_UNSPEC: DWORD = 0;
  AF_INET: DWORD = 2;
  AF_INET6: DWORD = 23;

  { Flags }
  GAA_FLAG_SKIP_UNICAST = $1;
  GAA_FLAG_SKIP_ANYCAST = $2;
  GAA_FLAG_SKIP_MULTICAST = $4;
  GAA_FLAG_SKIP_DNS_SERVER = $8;
  GAA_FLAG_INCLUDE_PREFIX = $10;
  GAA_FLAG_SKIP_FRIENDLY_NAME = $20;
  GAA_FLAG_INCLUDE_WINS_INFO = $40;
  GAA_FLAG_INCLUDE_GATEWAYS = $80;
  GAA_FLAG_INCLUDE_ALL_INTERFACES = $100;
  GAA_FLAG_INCLUDE_ALL_COMPARTMENTS = $200;
  GAA_FLAG_INCLUDE_TUNNEL_BINDINGORDER = $400;

var
  // Adapters
  pAdapterInfo: PIP_ADAPTER_INFO;
  pAdapter: PIP_ADAPTER_INFO;

  // Vars
  dwRetVal: DWORD;
  outBufLen: ULONG;
  i: integer;
  Mac: string;
  ThisAddress: string;

  // Adapters
  pAddresses: PIP_ADAPTER_ADDRESSES;
  pCurrAddresses: PIP_ADAPTER_ADDRESSES;
  pUnicast: PIP_ADAPTER_UNICAST_ADDRESS;
  pDnServer: PIP_ADAPTER_DNS_SERVER_ADDRESS;
  pThisSocket: sockaddr_in;
  DnsCount: integer;

  // Vars
  PhysicalAddress: string;

begin
  //====================================================================== //
  // first get the friendly name and DNS servers with GetAdaptersAddresses //
  //====================================================================== //

  // initialize
  pAddresses := nil;
  pCurrAddresses := nil;
  pUnicast := nil;
  pDnServer := nil;
  dwRetVal := 0;
  i := 0;
  outBufLen := 0;
  DnsCount := 0;

  Result.Guid := '';
  Result.Name := '';
  Result.Mac := '';
  Result.Description := '';
  Result.IpAddress := '';
  Result.IpSubnet := '';
  Result.IpGateway := '';
  Result.DnsPref := '';
  Result.DnsAlt := '';
  Result.DhcpServer := '';
  Result.State := '';

  // -
  outBufLen := WORKING_BUFFER_SIZE;
  repeat
    if Assigned(pAddresses) then
      FreeMem(pAddresses);

    GetMem(pAddresses, outBufLen);
    if not Assigned(pAddresses) then
      raise Exception.Create('Memory allocation failed for IP_ADAPTER_ADDRESSES struct');

    dwRetVal := GetAdaptersAddresses(2, $86, nil, pAddresses, @outBufLen);
    Inc(i);
  until (dwRetVal <> ERROR_BUFFER_OVERFLOW) or (i = MAX_TRIES);

  // --
  try
    if NO_ERROR <> dwRetVal then
    begin
      if ERROR_NO_DATA = dwRetVal then
      begin
        raise Exception.Create('Error no data');
        Exit;
      end
      else
        raise Exception.Create(SysErrorMessage(dwRetVal));
    end;

    pCurrAddresses := pAddresses;
    while Assigned(pCurrAddresses) do
    begin
      if pCurrAddresses^.PhysicalAddressLength > 0 then
      begin
        if pCurrAddresses^.FriendlyName = AdapterName then
        begin
          // AdapterName
          Result.Guid := pCurrAddresses^.AdapterName;
          Result.Name := pCurrAddresses^.FriendlyName;

          // DNS
          pDnServer := pCurrAddresses^.FirstDnsServerAddress;
          if (pDnServer <> nil) then
          begin
            while (pDnServer <> nil) do
            begin
              //we must cast the sockaddr to sockaddr_in to access the sin_addr
              if DnsCount = 0 then
              begin
                Result.DnsPref := inet_ntoa(PSockAddrIn(pDnServer^.Address.lpSockaddr)^.sin_addr);
                if Result.DnsPref = '0.0.0.0' then Result.DnsPref := '';
                DnsCount := DnsCount + 1;
              end
              else
              begin
                Result.DnsAlt := inet_ntoa(PSockAddrIn(pDnServer^.Address.lpSockaddr)^.sin_addr);
                if Result.DnsAlt = '0.0.0.0' then Result.DnsAlt := '';
              end;
              pDnServer := pDnServer^.Next;
            end;
          end;

          //we got what we needed, break here
          break;
        end;
      end;
      pCurrAddresses := pCurrAddresses^.Next;
    end;

  finally
    if Assigned(pAddresses) then
      FreeMem(pAddresses);
  end;



  //====================================================================== //
  // next get the rest of the IP info with GetAdaptersInfo                 //
  //====================================================================== //

  // initialize
  pAdapterInfo := nil;
  pAdapter := nil;
  dwRetVal := 0;
  i := 0;
  outBufLen := 0;

  outBufLen := sizeof(IP_ADAPTER_INFO);
  GetMem(pAdapterInfo, outBufLen);
  if not Assigned(pAdapterInfo) then
  begin
    raise Exception.Create('Memory allocation failed for IP_ADAPTER_INFO struct');
  end;

  // Make an initial call to GetAdaptersInfo to get
  // the necessary size into the ulOutBufLen variable
  dwRetVal := GetAdaptersInfo(pAdapterInfo, outBufLen);
  if dwRetVal = ERROR_BUFFER_OVERFLOW then
  begin
    FreeMem(pAdapterInfo);
    GetMem(pAdapterInfo, outBufLen);
    if not Assigned(pAdapterInfo) then
    begin
      raise Exception.Create('Error allocating memory needed to call GetAdaptersinfo');
    end;
  end;

  // Make the 2nd call to GetAdaptersInfo to get the info
  dwRetVal := GetAdaptersInfo(pAdapterInfo, outBufLen);
  try
    if dwRetVal = NO_ERROR then
    begin
      pAdapter := pAdapterInfo;
      while Assigned(pAdapter) do
      begin
        if pAdapter^.AdapterName = Result.Guid then
        begin
          Result.Description := pAdapter^.Description;

          Mac := '';
          for i := 0 to pAdapter^.AddressLength - 1 do
          begin
            if Mac <> '' then Mac := Mac + '-';
            Mac := Mac + IntToHex(pAdapter^.Address[i]);
          end;
          Result.Mac := Mac;

          Result.IpAddress := pAdapter^.IpAddressList.IpAddress.S;
          if Result.IpAddress = '0.0.0.0' then Result.IpAddress := '';
          Result.IpSubnet := pAdapter^.IpAddressList.IpMask.S;
          if Result.IpSubnet = '0.0.0.0' then Result.IpSubnet := '';
          Result.IpGateway := pAdapter^.GatewayList.IpAddress.S;
          if (Result.IpGateway = '0.0.0.0') or (Result.IpAddress = '') then
             Result.IpGateway := '';

          if (pAdapter^.DhcpEnabled) <> 0 then
            Result.DhcpServer := pAdapter^.DhcpServer.IpAddress.S;

          break;
        end;
        pAdapter := pAdapter^.Next;
      end;


      //check to see if IP was found, otherwise assume cable is unplugged
      if Result.IpAddress <> '' then
      begin
        //Result.State := GetNetworkAdapterStatus(AdapterName);
      end
      else
      begin
        Result.State := 'Unplugged';
      end;

    end
    else
    begin
      raise Exception.Create('GetAdaptersInfo failed with error: ' + IntToStr(dwRetVal));
    end;

  finally
    FreeMem(pAdapterInfo);
  end;

end;


function GetNetworkAdapterStatus(const AdapterName: string): string;
var
  WMILocator: OleVariant;
  WMIService: OleVariant;
  WMIQuery: string;
  WMIFilter: string;
  WMIServices: OleVariant;
  WMIServiceItem: OleVariant;
  I: Integer;
begin
  Result := '';
  WMILocator := CreateOleObject('WbemScripting.SWbemLocator');
  WMIService := WMILocator.ConnectServer('localhost', 'root\CIMV2');
  WMIService.Security_.ImpersonationLevel := 3; // set impersonation level to "Impersonate"
  WMIQuery := 'SELECT * FROM Win32_NetworkAdapter WHERE Name="' + AdapterName + '"';
  WMIFilter := 'Disabled';
  WMIServices := WMIService.ExecQuery(WMIQuery, 'WQL', 0);
  for I := 0 to WMIServices.Count - 1 do
  begin
    WMIServiceItem := WMIServices.ItemIndex(I);
    if not VarIsNull(WMIServiceItem.NetEnabled) then
    begin
      if WMIServiceItem.NetEnabled then
        Result := 'Enabled'
      else
        Result := 'Disabled';
    end;
  end;
end;


//function GetAdapterState(const adapterName): integer;
//var
//  FSWbemLocator, FWMIService, FWbemObjectSet: olevariant;
//  objNetworkAdapter: olevariant;
//  ipArray, subnetArray, gatewayArray: variant;
//  objIndex: integer;
//  adapter: TAdapter;
//begin
//  Result := 0;
//
//  // Initialize COM library
//  CoInitialize(nil);
//
//  try
//    // Create SWbemLocator and connect to WMI service
//    FSWbemLocator := CreateOleObject('WbemScripting.SWbemLocator');
//    FWMIService := FSWbemLocator.ConnectServer('localhost', 'root\CIMV2', '', '');
//
//    // Query for network adapters with IPEnabled=True
//    FWbemObjectSet := FWMIService.ExecQuery('SELECT * FROM Win32_NetworkAdapterConfiguration WHERE IPEnabled=True', 'WQL');
//
//    // Prepare SafeArrays for IP addresses, subnet masks, and gateways
//    ipArray := VarArrayCreate([0, 0], varOleStr);
//    ipArray[0] := ipAddress;
//
//    subnetArray := VarArrayCreate([0, 0], varOleStr);
//    subnetArray[0] := subnetMask;
//
//    gatewayArray := VarArrayCreate([0, 0], varOleStr);
//    writeln(gateway);
//    if (gateway <> '') and (gateway <> '0.0.0.0') then
//      gatewayArray[0] := gateway
//    else
//      gatewayArray[0] := ipAddress;
//
//    if not VarIsNull(FWbemObjectSet) then
//    begin
//      adapter := GetIpInfo(adapterName);
//
//      // Iterate through network adapters and configure the one with a matching name
//      for objIndex := 0 to FWbemObjectSet.Count - 1 do
//      begin
//        objNetworkAdapter := FWbemObjectSet.ItemIndex(objIndex);
//
//        // Check if the adapter name exactly matches the provided name
//        if SameText(adapter.Mac, StringReplace(objNetworkAdapter.MACAddress, ':', '-', [rfReplaceAll, rfIgnoreCase])) then
//        begin
//          // Set the IP address and subnet mask
//          objNetworkAdapter.EnableStatic(ipArray, subnetArray);
//          // Set the gateway
//          objNetworkAdapter.SetGateways(gatewayArray);
//
//          Result := True;
//          Break; // Exit the loop once we've found and configured the adapter
//        end;
//      end;
//    end
//    else
//    begin
//      raise Exception.Create('FWbemObjectSet is nil.');
//    end;
//
//  except
//    // Handle exceptions here
//    on E: Exception do
//    begin
//      // Log the exception message using DebugLn
//      //DebugLn('Exception: ' + E.Message);
//      raise Exception.Create(E.Message);
//    end;
//  end;
//
//  // Release COM resources
//  CoUninitialize;
//end;



{ Functions for setting network settings }
function SetIpAddresses(const adapterName, ipAddress, subnetMask, gateway: string): boolean;
var
  FSWbemLocator, FWMIService, FWbemObjectSet: olevariant;
  objNetworkAdapter: olevariant;
  ipArray, subnetArray, gatewayArray: variant;
  objIndex: integer;
  adapter: TAdapter;
begin
  Result := False;

  // Initialize COM library
  CoInitialize(nil);

  try
    // Create SWbemLocator and connect to WMI service
    FSWbemLocator := CreateOleObject('WbemScripting.SWbemLocator');
    FWMIService := FSWbemLocator.ConnectServer('localhost', 'root\CIMV2', '', '');

    // Query for network adapters with IPEnabled=True
    FWbemObjectSet := FWMIService.ExecQuery('SELECT * FROM Win32_NetworkAdapterConfiguration WHERE IPEnabled=True', 'WQL');

    // Prepare SafeArrays for IP addresses, subnet masks, and gateways
    ipArray := VarArrayCreate([0, 0], varOleStr);
    ipArray[0] := ipAddress;

    subnetArray := VarArrayCreate([0, 0], varOleStr);
    subnetArray[0] := subnetMask;

    gatewayArray := VarArrayCreate([0, 0], varOleStr);
    writeln(gateway);
    if (gateway <> '') and (gateway <> '0.0.0.0') then
      gatewayArray[0] := gateway
    else
      gatewayArray[0] := ipAddress;

    if not VarIsNull(FWbemObjectSet) then
    begin
      adapter := GetIpInfo(adapterName);

      // Iterate through network adapters and configure the one with a matching name
      for objIndex := 0 to FWbemObjectSet.Count - 1 do
      begin
        objNetworkAdapter := FWbemObjectSet.ItemIndex(objIndex);

        // Check if the adapter name exactly matches the provided name
        if SameText(adapter.Mac, StringReplace(objNetworkAdapter.MACAddress, ':', '-', [rfReplaceAll, rfIgnoreCase])) then
        begin
          // Set the IP address and subnet mask
          objNetworkAdapter.EnableStatic(ipArray, subnetArray);
          // Set the gateway
          objNetworkAdapter.SetGateways(gatewayArray);

          Result := True;
          Break; // Exit the loop once we've found and configured the adapter
        end;
      end;
    end
    else
    begin
      raise Exception.Create('FWbemObjectSet is nil.');
    end;

  except
    // Handle exceptions here
    on E: Exception do
    begin
      // Log the exception message using DebugLn
      //DebugLn('Exception: ' + E.Message);
      raise Exception.Create(E.Message);
    end;
  end;

  // Release COM resources
  CoUninitialize;
end;

function SetDnsAddresses(const adapterName, preferredDNS, alternateDNS: string): Boolean;
var
  FSWbemLocator, FWMIService, FWbemObjectSet: OLEVariant;
  objNetworkAdapter: OLEVariant;
  i: Integer;
  dnsArray: Variant; // Array to hold DNS addresses
    adapter: TAdapter;
begin
  // Initialize COM library
  CoInitialize(nil);

  Result := False;

  try
    // Create SWbemLocator and connect to WMI service
    FSWbemLocator := CreateOleObject('WbemScripting.SWbemLocator');
    FWMIService := FSWbemLocator.ConnectServer('localhost', 'root\CIMV2', '', '');

    // Query for network adapters
    FWbemObjectSet := FWMIService.ExecQuery('SELECT * FROM Win32_NetworkAdapterConfiguration WHERE IPEnabled=True', 'WQL');

    adapter := GetIpInfo(adapterName);

    // Iterate through network adapters to find the one with the specified name
    for i := 0 to FWbemObjectSet.Count - 1 do
    begin
      objNetworkAdapter := FWbemObjectSet.ItemIndex(i);

      // Check if the adapter name exactly matches the provided name
      if SameText(adapter.Mac, StringReplace(objNetworkAdapter.MACAddress, ':', '-', [rfReplaceAll, rfIgnoreCase])) then
      begin
        // Create an array of DNS addresses
        dnsArray := VarArrayCreate([0, 1], varOleStr);
        dnsArray[0] := preferredDNS;
        dnsArray[1] := alternateDNS;

        // Set the DNS addresses using the array
        objNetworkAdapter.SetDNSServerSearchOrder(dnsArray);

        // Commit the changes
        objNetworkAdapter.Put_();

        Result := True;
        Break; // Exit the loop once we've found and configured the adapter
      end;
    end;

  except
    // Handle exceptions here
    on E: Exception do
    begin
      // Log the exception message using DebugLn
      DebugLn('Exception: ' + E.Message);
    end;
  end;

  // Release COM resources
  CoUninitialize;
end;

procedure GetNetworkAdapterInfo;
var
  FSWbemLocator, FWMIService, FWbemObjectSet: olevariant;
  objNetworkAdapter: olevariant;
  i: integer;
begin
  // Initialize COM library
  CoInitialize(nil);

  try
    // Create SWbemLocator and connect to WMI service
    FSWbemLocator := CreateOleObject('WbemScripting.SWbemLocator');
    FWMIService := FSWbemLocator.ConnectServer('localhost', 'root\CIMV2', '', '');

    // Query for network adapters
    FWbemObjectSet := FWMIService.ExecQuery('SELECT * FROM Win32_NetworkAdapterConfiguration', 'WQL');

    // Iterate through network adapters using an index-based loop
    for i := 0 to FWbemObjectSet.Count - 1 do
    begin
      objNetworkAdapter := FWbemObjectSet.ItemIndex(i);

      // Check if Description is not null before converting it to a string
      if not VarIsNull(objNetworkAdapter.Description) then
        DebugLn('Adapter Description: ' + objNetworkAdapter.Description);

      // Check if MACAddress is not null before converting it to a string
      if not VarIsNull(objNetworkAdapter.MACAddress) then
        DebugLn('MAC Address: ' + objNetworkAdapter.MACAddress);

      // Check if IPEnabled is not null before converting it to a string
      if not VarIsNull(objNetworkAdapter.IPEnabled) then
        DebugLn('IP Enabled: ' + BoolToStr(objNetworkAdapter.IPEnabled, True));

      // You can access more properties here based on your needs

      // Separate entries with a line break
      DebugLn('---------------------------------------');
    end;

  except
    // Handle exceptions here
    on E: Exception do
    begin
      // Log the exception message using DebugLn
      DebugLn('Exception: ' + E.Message);
    end;
  end;

  // Release COM resources
  CoUninitialize;
end;

function ValidateIpAddress(IpAddress: string): integer;
begin
  //if
end;

end.
