unit uCheckForUpdates;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  fpjson, jsonparser, LazLogger, opensslsockets, uAppData,
  ShellApi, WinINet;

type

  { TFormCheckForUpdates }

  TFormCheckForUpdates = class(TForm)
    Button_OK: TButton;
    Image_Logo: TImage;
    Label_Background: TLabel;
    Label_BackgroundLine: TLabel;
    Label_BackgroundLine1: TLabel;
    Label_DownloadLink: TLabel;
    Label_LatestVersion: TLabel;
    Label_LatestVersionTitle: TLabel;
    Label_Info: TLabel;
    Label_Title: TLabel;
    Label_ThisVersion: TLabel;
    Label_ThisVersionTitle: TLabel;
    procedure Button_OKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Label_DownloadLinkClick(Sender: TObject);
  private

  public
    procedure UpdateStrings(isNewer: boolean; version: string);

  end;

procedure CheckForUpdates(ManualCheck: boolean = False);
function GetWebPage(const Url: string): string;

var
  FormCheckForUpdates: TFormCheckForUpdates;

implementation

{$R *.lfm}

resourcestring
  VersionIsCurrent = 'You have the latest version.';
  VersionAvailable = 'A newer version is available:';

procedure CheckForUpdates(ManualCheck: boolean = False);
var
  Content: string;
  Json: TJSONData;
  val: TJSONData;
  valStr: string;
  errStr: string;
  errFlag: boolean;
  major1, minor1, revision1: integer;
  major2, minor2, revision2: integer;
  isNewer: boolean;
begin
  errStr := '';
  errFlag := False;
  try
    try
      Content := GetWebPage('https://api.github.com/repos/KurtisLiggett/Simple-IP-Config/releases/latest');
      JSON := GetJSON(Content);
      try
        val := JSON.FindPath('tag_name');
        if val <> nil then
        begin
          debugln(val.AsString);
          valStr := val.AsString;
        end
        else
        begin
          errStr := 'Error getting data form the update server.';
          errFlag := True;
          if ManualCheck then
            ShowMessage(errStr);
        end;
      finally
        JSON.Free;
      end;
    except
      errStr := 'Error connecting to the update server.';
      errFlag := True;
      if ManualCheck then
        ShowMessage(errStr);
    end;
  finally

  end;

  if not errFlag then
  begin
    // Split the version strings into major, minor, and revision components
    sscanf(valStr, '%d.%d.%d', [@major1, @minor1, @revision1]);
    sscanf(AppData.Version, '%d.%d.%d', [@major2, @minor2, @revision2]);

    // Compare the major version
    if major1 > major2 then
      isNewer := True
    else
    begin
      if major1 < major2 then
        isNewer := False
      else
      begin
        // If major versions are equal, compare the minor version
        if minor1 > minor2 then
          isNewer := True
        else if minor1 < minor2 then
          isNewer := False
        else
        begin
          // If minor versions are equal, compare the revision version
          if revision1 > revision2 then
            isNewer := True
          else if revision1 < revision2 then
            isNewer := False
          else
            isNewer := False; // Versions are equal
        end;
      end;
    end;

    //if isNewer then
    //  ShowMessage('new version available')
    //else
    //  ShowMessage('current');

    if ManualCheck or isNewer then
    begin
      FormCheckForUpdates := TFormCheckForUpdates.Create(Application);
      FormCheckForUpdates.UpdateStrings(isNewer, valStr);
      FormCheckForUpdates.ShowModal;
    end;
  end;

end;

{ TFormCheckForUpdates }
procedure TFormCheckForUpdates.UpdateStrings(isNewer: boolean; version: string);
begin
  Label_ThisVersion.Caption := AppData.Version;
  Label_LatestVersion.Caption := version;
  if isNewer then
  begin
    Label_Info.Caption := VersionAvailable;
  end
  else
  begin
    Label_Info.Caption := VersionIsCurrent;
  end;
end;

procedure TFormCheckForUpdates.Button_OKClick(Sender: TObject);
begin
  Close;
end;

procedure TFormCheckForUpdates.FormCreate(Sender: TObject);
begin
  Label_ThisVersion.Caption := AppData.Version;
end;

procedure TFormCheckForUpdates.Label_DownloadLinkClick(Sender: TObject);
begin
  if ShellExecute(0, 'open', PChar('https://github.com/KurtisLiggett/Simple-IP-Config/releases/latest'), nil, nil, 1) = 0 then;
end;

function GetWebPage(const Url: string): string;
var
  NetHandle: HINTERNET;
  UrlHandle: HINTERNET;
  Buffer: array[0..1023] of byte;
  BytesRead: dWord;
  StrBuffer: utf8string;
begin
  Result := '';
  BytesRead := Default(dWord);
  NetHandle := InternetOpen('Mozilla/5.0(compatible; WinInet)', INTERNET_OPEN_TYPE_PRECONFIG, nil, nil, 0);

  // NetHandle valid?
  if Assigned(NetHandle) then
    try
      UrlHandle := InternetOpenUrl(NetHandle, PChar(Url), nil, 0, INTERNET_FLAG_RELOAD, 0);

      // UrlHandle valid?
      if Assigned(UrlHandle) then
        try
          repeat
            InternetReadFile(UrlHandle, @Buffer, SizeOf(Buffer), BytesRead);
            SetString(StrBuffer, pansichar(@Buffer[0]), BytesRead);
            Result := Result + StrBuffer;
          until BytesRead = 0;
        finally
          InternetCloseHandle(UrlHandle);
        end
      // o/w UrlHandle invalid
      else
          begin
        raise Exception.Create('');
          end;
    finally
      InternetCloseHandle(NetHandle);
    end
  // NetHandle invalid
  else
    raise Exception.Create('');

end;

end.
