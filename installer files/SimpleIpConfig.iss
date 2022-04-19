#define MyAppName "Simple IP Config"
#define MyAppVersion "2.9.4"
#define MyAppRevision "0"
#define MyAppAuthor "Kurtis Ligget"
#define MyAppCopyright "(c) 2011 Kurtis Ligget"

[Setup]
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppVerName={#MyAppName} {#MyAppVersion}
AppCopyright={#MyAppCopyright}
VersionInfoVersion={#MyAppVersion}.{#MyAppRevision}
VersionInfoDescription={#MyAppName} - installer
VersionInfoProductName={#MyAppName} {#MyAppVersion}
DefaultDirName={autopf}\{#MyAppName}
DefaultGroupName={#MyAppName}
UninstallDisplayName={#MyAppName}
UninstallDisplayIcon={app}\{#MyAppName}.exe
Compression=lzma2
SolidCompression=yes
OutputBaseFilename={#MyAppName} Setup {#MyAppVersion}

[Dirs]
Name: "{localappdata}\{#MyAppName}"

[Files]
Source: "Simple-IP-Config\{#MyAppName} {#MyAppVersion}.exe"; DestDir: "{app}"; DestName: "{#MyAppName}.exe"
Source: "Simple-IP-Config\lang\*.json"; DestDir: "{app}\lang";

[Icons]
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppName}.exe"

[UninstallDelete]
Type: files; Name: "{autopf}\{#MyAppName}\{#MyAppName}.exe"
Type: files; Name: "{autopf}\{#MyAppName}\lang\*.json"
Type: dirifempty; Name: "{autopf}\{#MyAppName}\lang"
Type: dirifempty; Name: "{autopf}\{#MyAppName}"
Type: dirifempty; Name: "{localappdata}\{#MyAppName}"


[Run]
Filename: {app}\{cm:AppName}.exe; Description: {cm:LaunchProgram,{cm:AppName}}; Flags: nowait postinstall skipifsilent

[CustomMessages]
AppName={#MyAppName}

[Languages]
Name: "english"; MessagesFile: "compiler:default.isl"; 
Name: "italian"; MessagesFile: "compiler:Languages\Italian.isl"; 
Name: "russian"; MessagesFile: "compiler:Languages\Russian.isl"; 
Name: "spanish"; MessagesFile: "compiler:Languages\Spanish.isl"; 

[Code]
procedure CurStepChanged(CurStep: TSetupStep);
begin

  case CurStep of
    ssInstall:
    begin
      { will be executed just before the actual installation starts }
    end; 

   ssPostInstall:
    begin
      { will be executed just after the actual installation finishes }
      if FileExists(ExpandConstant('{autopf}\{#MyAppName}\profiles.ini')) then
      begin
        { if file exists, copy it to new location }
        if FileCopy(ExpandConstant('{autopf}\{#MyAppName}\profiles.ini'), ExpandConstant('{localappdata}\{#MyAppName}\profiles.ini'), false) then
        begin
          { delete file after copying to AppData }
          DeleteFile(ExpandConstant('{autopf}\{#MyAppName}\profiles.ini'))
        end;
      end; 
    end; 
  end;

end;