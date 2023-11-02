unit uFunctions;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, uNetwork, LazLogger, uAppData, uTypes, ComCtrls,
  StrUtils, Dialogs, StdCtrls, Forms, LCLType;

procedure RefreshFunc();
procedure BuildAdapterList();
procedure RefreshAdapterInfo();
procedure SetStatusMessage(message: string);
procedure DeleteProfile();
procedure NewProfile();
procedure SaveProfile();
procedure PullFromAdapter();
procedure SetProfile(ProfileName: string);
procedure SetIP();

implementation

uses
  uMain;

procedure RefreshFunc();
var
  LvItemText: string;
  LvItemIndex: integer;
  i: integer;
  Item: TListItem;
  ProfileItem: TProfile;
begin
  {get data from profiles.json}
  AppData.Init();

  {rebuild profiles list}
  FormMain.Edit_Filter.Text := '*';
  //record the currently selected item
  LvItemIndex := FormMain.List_Profiles.ItemIndex;
  LvItemText := '';
  if LvItemIndex >= 0 then
    LvItemText := FormMain.List_Profiles.Items[LvItemIndex].Caption;
  //build the list
  FormMain.List_Profiles.Items.Clear();
  for ProfileItem in AppData.Profiles.Items do
  begin
    //debugln(ProfileItem.Name);
    Item := FormMain.List_Profiles.Items.Add;
    Item.Caption := ProfileItem.Name;
  end;

  //select the previously selected item
  for i := 0 to FormMain.List_Profiles.Items.Count - 1 do
  begin
    if FormMain.List_Profiles.Items[i].Caption = LvItemText then
      FormMain.List_Profiles.Selected := FormMain.List_Profiles.Items[i];
  end;

  {get adapters and build combobox}
  BuildAdapterList();

  {get IP information for selected adapter}
  RefreshAdapterInfo();

end;

procedure BuildAdapterList();
var
  Name: string;
  prevSelected: string;
  FoundSelected: boolean;
  HideAdapterNames: array of string;
  thisName: string;
  HideThis: boolean;
begin
  prevSelected := FormMain.Combo_Adapters.Text;
  FormMain.Combo_Adapters.Items.Clear;
  FoundSelected := False;

  HideAdapterNames := SplitString(AppData.AdapterBlacklist, '|');
  for Name in GetAdapterList() do
  begin
    //check if in the hide list
    HideThis := False;
    for thisName in HideAdapterNames do
    begin
      if thisName = Name then
      begin
        HideThis := True;
        break;
      end;
    end;

    if not HideThis then
    begin
      FormMain.Combo_Adapters.Items.Add(Name);
      if Name = prevSelected then
        FoundSelected := True;
    end;
  end;

  if FoundSelected then
    FormMain.Combo_Adapters.Text := prevSelected
  else
    FormMain.Combo_Adapters.Text := '';
end;

procedure RefreshAdapterInfo();
var
  adapter: TAdapter;
begin
  {get IP information for selected adapter}
  adapter := GetIpInfo(FormMain.Combo_Adapters.Text);
  FormMain.Label_AdapterDescription.Caption := adapter.Description;
  FormMain.Label_Mac.Caption := adapter.Mac;
  FormMain.Label_IpAddressInfo.Caption := adapter.IpAddress;
  FormMain.Label_IpSubnetInfo.Caption := adapter.IpSubnet;
  FormMain.Label_IpGatewayInfo.Caption := adapter.IpGateway;
  FormMain.Label_DnsPrefInfo.Caption := adapter.DnsPref;
  FormMain.Label_DnsAltInfo.Caption := adapter.DnsAlt;
  FormMain.Label_DhcpInfo.Caption := adapter.DhcpServer;
  FormMain.Label_AdapterStateInfo.Caption := adapter.State;
end;

procedure SetStatusMessage(message: string);
begin
  FormMain.StatusBar1.SimpleText := message;
  if message <> '' then
  begin
    debugln(message);
    FormMain.StatusTimer.Enabled := False;
    FormMain.StatusTimer.Enabled := True;
  end
  else
  begin
    FormMain.StatusTimer.Enabled := False;
  end;
end;

procedure DeleteProfile();
var
  LvItemIndex: integer;
  LvItemText: string;
  i: integer;
  Item: TListItem;
begin
  if FormMain.ActiveControl=FormMain.List_Profiles then
  begin
    LvItemIndex := FormMain.List_Profiles.ItemIndex;
    LvItemText := '';
    if LvItemIndex >= 0 then
      LvItemText := FormMain.List_Profiles.Items[LvItemIndex].Caption
    else
      exit;

    if LvItemText <> '' then
    begin
      FormMain.List_Profiles.Items.Delete(LvItemIndex);
      AppData.Profiles.Remove(LvItemText);
      AppData.Save;
    end;
  end
  else
  begin
    //send delete;
  end;

end;

procedure NewProfile();
var
  NewName: string;
  Item: TListItem;
  NewProfile: TProfile;
  ThisProfile: TProfile;
begin
  //get the new profile name
  NewName := InputBox('Profile Name', 'Enter a new profile name', '');
  if NewName = '' then exit;
  //check if profile name already exists
  for ThisProfile in AppData.Profiles.Items do
  begin
    if NewName = ThisProfile.Name then
    begin
      Application.MessageBox('Profile name already exists!', 'Error', MB_OK + MB_ICONERROR);
      exit;
    end;
  end;

  //create the listview item
  Item := FormMain.List_Profiles.Items.Add;
  Item.Caption := NewName;

  //create a new profile record
  NewProfile.Name := NewName;
  NewProfile.AdapterName := FormMain.Combo_Adapters.Text;
  NewProfile.IpAuto := (FormMain.Radio_IpAuto.State = cbChecked);
  NewProfile.IpAddress := FormMain.Edit_IpAddress.Text;
  NewProfile.IpSubnet := FormMain.Edit_IpSubnet.Text;
  NewProfile.IpGateway := FormMain.Edit_IpGateway.Text;
  NewProfile.DnsAuto := (FormMain.Radio_DnsAuto.State = cbChecked);
  NewProfile.DnsPref := FormMain.Edit_DnsPref.Text;
  NewProfile.DnsAlt := FormMain.Edit_DnsAlt.Text;
  NewProfile.RegisterDns := (FormMain.Check_RegisterDns.State = cbChecked);
  NewProfile.Memo := '';

  //add the new profile to the AppData object
  AppData.Profiles.Add(NewProfile);
  AppData.Save;

  //select the new item
  FormMain.List_Profiles.Selected := Item;
end;

procedure SaveProfile();
var
  LvItemIndex: integer;
  LvItemText: string;
  ThisProfile: TProfile;
begin
  LvItemIndex := FormMain.List_Profiles.ItemIndex;
  LvItemText := '';
  if LvItemIndex >= 0 then
    LvItemText := FormMain.List_Profiles.Items[LvItemIndex].Caption
  else
    exit;

  if LvItemText <> '' then
  begin
    ThisProfile.Name := LvItemText;
    ThisProfile.AdapterName := FormMain.Combo_Adapters.Text;
    ThisProfile.IpAuto := (FormMain.Radio_IpAuto.State = cbChecked);
    ThisProfile.IpAddress := FormMain.Edit_IpAddress.Text;
    ThisProfile.IpSubnet := FormMain.Edit_IpSubnet.Text;
    ThisProfile.IpGateway := FormMain.Edit_IpGateway.Text;
    ThisProfile.DnsAuto := (FormMain.Radio_DnsAuto.State = cbChecked);
    ThisProfile.DnsPref := FormMain.Edit_DnsPref.Text;
    ThisProfile.DnsAlt := FormMain.Edit_DnsAlt.Text;
    ThisProfile.RegisterDns := (FormMain.Check_RegisterDns.State = cbChecked);
    ThisProfile.Memo := '';

    AppData.Profiles.Save(ThisProfile);

    try
      AppData.Save;
      SetStatusMessage('Profile saved.');
    except
      SetStatusMessage('Error saving profile.');
    end;
  end;
end;

procedure PullFromAdapter();
begin
  RefreshAdapterInfo();

  FormMain.Radio_IpManual.State := cbChecked;
  FormMain.Edit_IpAddress.Text := FormMain.Label_IpAddressInfo.Caption;
  FormMain.Edit_IpSubnet.Text := FormMain.Label_IpSubnetInfo.Caption;
  FormMain.Edit_IpGateway.Text := FormMain.Label_IpGatewayInfo.Caption;
  FormMain.Radio_DnsManual.State := cbChecked;
  FormMain.Edit_DnsPref.Text := FormMain.Label_DnsPrefInfo.Caption;
  FormMain.Edit_DnsAlt.Text := FormMain.Label_DnsAltInfo.Caption;
end;

procedure SetProfile(ProfileName: string);
var
  profile: TProfile;
  adapterName: string;
  NameFound: boolean;

begin
  //debugln('item click' + ProfileName);
  try
    profile := AppData.Profiles.Get(ProfileName);

    if profile.IpAuto then
      FormMain.Radio_IpAuto.State := cbChecked
    else
      FormMain.Radio_IpManual.State := cbChecked;
    FormMain.Edit_IpAddress.Text := profile.IpAddress;
    FormMain.Edit_IpSubnet.Text := profile.IpSubnet;
    FormMain.Edit_IpGateway.Text := profile.IpGateway;
    if profile.DnsAuto then
      FormMain.Radio_DnsAuto.State := cbChecked
    else
      FormMain.Radio_DnsManual.State := cbChecked;
    FormMain.Edit_DnsPref.Text := profile.DnsPref;
    FormMain.Edit_DnsAlt.Text := profile.DnsAlt;
    if profile.RegisterDns then
      FormMain.Check_RegisterDns.State := cbChecked
    else
      FormMain.Check_RegisterDns.State := cbUnchecked;

    NameFound := False;
    for adapterName in FormMain.Combo_Adapters.Items do
    begin
      if adapterName = profile.AdapterName then
      begin
        FormMain.Combo_Adapters.Text := profile.AdapterName;
        NameFound := True;
        break;
      end;
    end;

    if not NameFound then
      FormMain.Combo_Adapters.Text := '';

  except
    debugln('Selected profile not found!');
  end;
end;

procedure SetIP();
var
  res: boolean;
  startTime: longword;
  timeout: longword;
  adapter: TAdapter;
begin
  //function SetNetworkSettings(const adapterName, ipAddress, subnetMask, gateway: string): boolean;
  Formmain.Button_Apply.Enabled := False;
  try
    res := SetIpAddresses('Ethernet 2', FormMain.Edit_IpAddress.Caption, FormMain.Edit_IpSubnet.Caption, FormMain.Edit_IpGateway.Caption);
    if res then
      debugln('Set IP succeeded.')
    else
    begin
      debugln('Set IP failed.');
    end;
  except
    // Handle exceptions here
    on E: Exception do
    begin
      // Log the exception message using DebugLn
      DebugLn('Exception: ' + E.Message);
      debugln('Set IP failed.');
    end;
  end;

  //try checking that gateway is updated, up to timeout
  startTime := GetTickCount;
  timeout := 5000;
  writeln('start timer');
  repeat
    writeln('try...');
    adapter := GetIpInfo('Ethernet 2');
    writeln(IntToStr(GetTickCount - startTime));
    Application.ProcessMessages;
  until (adapter.IpAddress <> adapter.IpGateway) or ((GetTickCount - startTime) > timeout);
  Formmain.Button_Apply.Enabled := True;
  writeln('done timer');


  SetDnsAddresses('Ethernet 2', FormMain.Edit_DnsPref.Caption, FormMain.Edit_DnsAlt.Caption);

  RefreshAdapterInfo();

  //GetNetworkAdapterInfo();
end;

end.
