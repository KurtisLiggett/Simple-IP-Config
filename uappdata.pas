unit uAppData;

{$mode ObjFPC}{$H+}{$modeswitch advancedrecords}

interface

uses
  Classes, SysUtils, uTypes, fpjson, jsonparser,
  Clipbrd, LazLogger;

type
  TAppData = record

  type
    SettingsType = record
      Language: string;
      StartupAdapter: string;
      StartInTray: boolean;
      CloseToTray: boolean;
      CheckForUpdates: boolean;
    end;
    //type
    //TMapProfiles = specialize TObjectDictionary<string, TProfile>;

  private

  public
    Version: string;
    Date: string;
    UpdateDate: string;
    UpdateVersion: string;
    PositionX: integer;
    PositionY: integer;
    PositionW: integer;
    PositionH: integer;
    AdapterBlacklist: string;
    Settings: SettingsType;
    Profiles: TProfileList;
    procedure Init();
    procedure Save();
  end;

var
  AppData: TAppData;

implementation

uses
  uFunctions;

var
  FIn: TextFile;
  s: string;
  val: TJSONData;
  val2: TJSONData;
  sData: string;
  J: TJSONData;
  r: TJSONData;
  p: TJSONData;
  i: integer;
  NewProfile: TProfile;
  ThisProfile: TProfile;
  FileNotFOund: boolean;
  i2: integer;

procedure TAppData.Init();
begin
  {set initial values}
  AppData.Version := '2.0.0';
  AppData.Date := '11/6/2023';
  AppData.UpdateDate := '';
  AppData.UpdateVersion := '';
  AppData.AdapterBlacklist := '';
  AppData.PositionX := -1;
  AppData.Positiony := -1;
  AppData.PositionW := -1;
  AppData.PositionH := -1;
  AppData.Settings.Language := 'en';
  AppData.Settings.StartInTray := False;
  AppData.Settings.CloseToTray := False;
  AppData.Settings.CheckForUpdates := False;
  AppData.Settings.StartupAdapter := '';
  //if assigned(AppData.Profiles) then
  //AppData.Profiles.Free;
  //AppData.Profiles := TMapProfiles.Create;
  //re-initialize the array
  AppData.Profiles.Clear;
  FileNotFOund := False;

  {read profiles.json file}
  try
    AssignFile(FIn, 'profiles.json');
    reset(FIn);
    try
      while not EOF(FIn) do
      begin
        readln(FIn, s);
        sData := sData + s;
      end;
    finally
      Close(FIn);
    end;
  except
    SetStatusMessage('Error: profiles.json file not found!');
    FileNotFOund := True;
  end;

  if not (FileNotFOund) then
  begin
    try
      {parse json string}
      try
        J := GetJSON(sData);

        {get JSON settings}
        val := J.FindPath('App.Version');
        if (val = nil) then
          AppData.UpdateVersion := ''
        else
          AppData.UpdateVersion := val.AsString;

        val := J.FindPath('App.LastUpdateCheck');
        if (val = nil) then
          AppData.UpdateDate := ''
        else
          AppData.UpdateDate := val.AsString;

        val := J.FindPath('App.AdapterBlacklist');
        if (val = nil) then
          AppData.AdapterBlacklist := ''
        else
          AppData.AdapterBlacklist := val.AsString;

        val := J.FindPath('App.PositionX');
        if (val = nil) or (val.AsString = '') then
          AppData.PositionX := -1
        else
          AppData.PositionX := val.AsInteger;

        val := J.FindPath('App.PositionY');
        if (val = nil) or (val.AsString = '') then
          AppData.PositionY := -1
        else
          AppData.PositionY := val.AsInteger;

        val := J.FindPath('App.PositionW');
        if (val = nil) or (val.AsString = '') then
          AppData.PositionW := -1
        else
          AppData.PositionW := val.AsInteger;

        val := J.FindPath('App.PositionH');
        if (val = nil) or (val.AsString = '') then
          AppData.PositionH := -1
        else
          AppData.PositionH := val.AsInteger;

        val := J.FindPath('Settings.Language');
        if (val = nil) or (val.AsString = '') then
        begin
          //debugln('nil');
          AppData.Settings.Language := 'en';
        end
        else
        begin
          AppData.Settings.Language := val.AsString;
        end;

        val := J.FindPath('Settings.StartupAdapter');
        if (val = nil) then
          AppData.Settings.StartupAdapter := ''
        else
          AppData.Settings.StartupAdapter := val.AsString;

        val := J.FindPath('Settings.StartupMode');
        if (val = nil) then
          AppData.Settings.StartInTray := False
        else
          AppData.Settings.StartInTray := val.AsBoolean;

        val := J.FindPath('Settings.MinToTray');
        if (val = nil) then
          AppData.Settings.CloseToTray := False
        else
          AppData.Settings.CloseToTray := val.AsBoolean;

        val := J.FindPath('Settings.AutoUpdate');
        if (val = nil) then
          AppData.Settings.CheckForUpdates := False
        else
          AppData.Settings.CheckForUpdates := val.AsBoolean;

      except
        SetStatusMessage('Error: Malformatted profiles.json file!');
        J := nil;
        FileNotFOund := True;
      end;

      if not (FileNotFOund) then
      begin
        {get list of profiles and properties}
        r := J.FindPath('Profiles');
        if r <> nil then
        begin
          AppData.Profiles.SetSize(r.Count);
          //setLength(ProfileNames, r.Count);
          //AppData.ProfileNames := ProfileNames;
          for i := 0 to r.Count - 1 do
          begin
            try
              ThisProfile := NewProfile;

              val := r.Items[i].FindPath('Name');
              if (val = nil) then
                ThisProfile.Name := ''
              else
                ThisProfile.Name := val.AsString;

              val := r.Items[i].FindPath('AdapterName');
              if (val = nil) then
                ThisProfile.AdapterName := ''
              else
                ThisProfile.AdapterName := val.AsString;

              val := r.Items[i].FindPath('IpAuto');
              if (val = nil) then
                ThisProfile.IpAuto := True
              else
                ThisProfile.IpAuto := val.AsBoolean;

              val := r.Items[i].FindPath('IpAddress');
              if (val = nil) then
              begin
                ThisProfile.IpAddress := '';
                ThisProfile.IpSubnet := '';
              end
              else
                for i2 := 0 to val.Count - 1 do
                begin
                  val2 := val.Items[i2].FindPath('Address');
                  if (val2 = nil) then
                    ThisProfile.IpAddress := ''
                  else
                    ThisProfile.IpAddress := val2.AsString;

                  val2 := val.Items[i2].FindPath('Subnet');
                  if (val2 = nil) then
                    ThisProfile.IpSubnet := ''
                  else
                    ThisProfile.IpSubnet := val2.AsString;
                end;

              val := r.Items[i].FindPath('Gateway');
              if (val = nil) then
                ThisProfile.IpGateway := ''
              else
                for i2 := 0 to val.Count - 1 do
                begin
                  val2 := val.Items[i2].FindPath('Address');
                  if (val2 = nil) then
                    ThisProfile.IpGateway := ''
                  else
                    ThisProfile.IpGateway := val2.AsString;
                end;

              //val := r.Items[i].FindPath('IpGateway');
              //if (val = nil) then
              //  ThisProfile.IpGateway := ''
              //else
              //  ThisProfile.IpGateway := val.AsString;

              val := r.Items[i].FindPath('DnsAuto');
              if (val = nil) then
                ThisProfile.DnsAuto := True
              else
                ThisProfile.DnsAuto := val.AsBoolean;

              val := r.Items[i].FindPath('IpDnsPref');
              if (val = nil) then
                ThisProfile.DnsPref := ''
              else
                ThisProfile.DnsPref := val.AsString;

              val := r.Items[i].FindPath('IpDnsAlt');
              if (val = nil) then
                ThisProfile.DnsAlt := ''
              else
                ThisProfile.DnsAlt := val.AsString;

              val := r.Items[i].FindPath('RegisterDns');
              if (val = nil) then
                ThisProfile.RegisterDns := True
              else
                ThisProfile.RegisterDns := val.AsBoolean;

              val := r.Items[i].FindPath('Memo');
              if (val = nil) then
                ThisProfile.Memo := ''
              else
                ThisProfile.Memo := val.AsString;

              //debugln(r.Items[i].FindPath('Name').AsString);
              AppData.Profiles.Add(ThisProfile);
              //AppData.ProfileNames[i] := r.Items[i].FindPath('Name').AsString;
            except
              debugln('oops');
            end;
          end;
        end;
        SetStatusMessage('');
      end;
    finally
      {free the memory}
      val := nil;
      r := nil;
      sData := '';
      if assigned(J) then
        J.Free;
    end;
  end;

end;

procedure TAppData.Save();
var
  JOut: TJSONObject;
  FOut: TextFile;
  JsonObj: TJSONObject;
  JsonProfile: TJSONObject;
  JsonArr: TJSONArray;
  JsonAddrArr: TJSONArray;
  JsonAddrObj: TJSONObject;
  ProfileItem: TProfile;
begin
  {create new JSON object for output}
  JOut := TJSONObject.Create;

  {add App data}
  JsonObj := TJSONObject.Create;
  JsonObj.Add('Version', AppData.UpdateVersion);
  JsonObj.Add('LastUpdateCheck', AppData.UpdateDate);
  JsonObj.Add('PositionX', AppData.PositionX);
  JsonObj.Add('PositionY', AppData.PositionY);
  JsonObj.Add('PositionH', AppData.PositionW);
  JsonObj.Add('PositionW', AppData.PositionH);
  JsonObj.Add('AdapterBlacklist', AppData.AdapterBlacklist);
  JOut.Add('App', JsonObj);

  {add Settings}
  JsonObj := TJSONObject.Create;
  JsonObj.Add('Language', AppData.Settings.Language);
  JsonObj.Add('MinToTray', AppData.Settings.CloseToTray);
  JsonObj.Add('StartupMode', AppData.Settings.StartInTray);
  JsonObj.Add('StartupAdapter', AppData.Settings.StartupAdapter);
  JsonObj.Add('AutoUpdate', AppData.Settings.CheckForUpdates);
  JOut.Add('Settings', JsonObj);
  (*Clipboard.AsText := JOut.FormatJSON;*)

  {add profiles}
  JsonArr := TJSONArray.Create;
  for ProfileItem in AppData.Profiles.Items do
  begin
    JsonProfile := TJSONObject.Create;
    JsonProfile.Add('Name', ProfileItem.Name);
    JsonProfile.Add('AdapterName', ProfileItem.AdapterName);
    JsonProfile.Add('IpAuto', ProfileItem.IpAuto);
    JsonAddrArr := TJSONArray.Create;
    //fill the array with IP's
    JsonAddrObj := TJSONObject.Create;
    JsonAddrObj.Add('Address', ProfileItem.IpAddress);
    JsonAddrObj.Add('Subnet', ProfileItem.IpSubnet);
    JsonAddrArr.Add(JsonAddrObj);
    //---
    JsonProfile.Add('IpAddress', JsonAddrArr);
    JsonAddrArr := TJSONArray.Create;
    //fill the array with Gateway's
    JsonAddrObj := TJSONObject.Create;
    JsonAddrObj.Add('Address', ProfileItem.IpGateway);
    JsonAddrObj.Add('Metric', 0);
    JsonAddrArr.Add(JsonAddrObj);
    //---
    JsonProfile.Add('Gateway', JsonAddrArr);
    JsonProfile.Add('DnsAuto', ProfileItem.DnsAuto);
    JsonProfile.Add('IpDnsPref', ProfileItem.DnsPref);
    JsonProfile.Add('IpDnsAlt', ProfileItem.DnsAlt);
    JsonProfile.Add('RegisterDns', ProfileItem.RegisterDns);
    JsonProfile.Add('Memo', ProfileItem.Memo);
    JsonArr.Add(JsonProfile);
  end;
  JOut.Add('Profiles', JsonArr);

  {write out the file}
  AssignFile(FOut, 'profiles.json');
  try
    try
      ReWrite(FOut);
      Write(FOut, JOut.FormatJSON);
    except
      raise Exception.Create('error saving file');
    end;
  finally
    CloseFile(FOut);
  end;

  {free the memory}
  JOut.Free;
end;


end.
