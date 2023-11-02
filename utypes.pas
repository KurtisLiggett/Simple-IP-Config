unit uTypes;

{$mode ObjFPC}{$H+}{$modeswitch advancedrecords}

interface

uses
  Classes, SysUtils;

type
  TProfile = record

    Name: string;
    AdapterName: string;
    IpAuto: boolean;
    IpAddress: string;
    IpSubnet: string;
    IpGateway: string;
    DnsAuto: boolean;
    DnsPref: string;
    DnsAlt: string;
    RegisterDns: boolean;
    Memo: string;
  end;

type
  TAdapter = record

    Guid: string;
    Name: string;
    Mac: string;
    Description: string;
    IpAddress: string;
    IpSubnet: string;
    IpGateway: string;
    DnsPref: string;
    DnsAlt: string;
    DhcpServer: string;
    State: string;
  end;

type
  TProfileList = record

    Items: array of TProfile;
    Count: integer;
    procedure Clear();
    procedure Add(profile: TProfile);
    procedure Remove(Profilename: string);
    procedure SetSize(length: integer);
    procedure Save(Profile: TProfile);
    function Get(Profilename: string): TProfile;
    procedure Rename(OldName: string; NewName: string);
    //function get(): TProfile;
  end;


implementation

procedure TProfileList.Clear();
begin
  Items := nil;
  Count := 0;
end;

procedure TProfileList.SetSize(length: integer);
begin
  SetLength(Items, length);
end;

procedure TProfileList.add(profile: TProfile);
begin
  if Count + 1 > Length(Items) then
  begin
    SetLength(Items, Length(Items) + 1);
  end;
  Items[Count] := profile;
  Count := Count + 1;
end;

procedure TProfileList.Remove(Profilename: string);
var
  i: integer;
  StartShift: boolean;
begin
  StartShift := False;
  for i := 0 to Length(Items) - 1 do
  begin
       if StartShift then
       begin
         Items[i-1] := Items[i];
       end;

       if Items[i].Name = Profilename then
       begin
         StartShift := true;
         //Items[i] := 0;
       end;
  end;
  Count := Count - 1;
  SetLength(Items, Count)
end;

procedure TProfileList.Save(Profile: TProfile);
var
  i: integer;
begin
  for i := 0 to Count - 1 do
  begin
       if Items[i].Name = Profile.Name then
       begin
         Items[i].AdapterName := Profile.AdapterName;
         Items[i].IpAuto := Profile.IpAuto;
         Items[i].IpAddress := Profile.IpAddress;
         Items[i].IpSubnet := Profile.IpSubnet;
         Items[i].IpGateway := Profile.IpGateway;
         Items[i].DnsAuto := Profile.DnsAuto;
         Items[i].DnsPref := Profile.DnsPref;
         Items[i].DnsAlt := Profile.DnsAlt;
         Items[i].RegisterDns := Profile.RegisterDns;
         Items[i].Memo := Profile.Memo;
         break;
       end;
  end;
end;

function TProfileList.Get(Profilename: string): TProfile;
var
  i: integer;
begin
  for i := 0 to Length(Items) - 1 do
  begin
       if Items[i].Name = Profilename then
       begin
         Result := Items[i];
         Exit;
       end;
  end;
  raise Exception.Create('Profile not found!');
end;

procedure TProfileList.Rename(OldName: string; NewName: string);
var
  i: integer;
begin
  for i := 0 to Count - 1 do
  begin
       if Items[i].Name = OldName then
       begin
         Items[i].Name := NewName;
         break;
       end;
  end;
end;

end.
