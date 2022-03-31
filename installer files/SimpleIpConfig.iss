#define MyAppName "Simple IP Config"
#define MyFileVer "2.9.4"
#define MyFriendlyVer "2.9.4"
#define MyAppVer "2.9.4.0"
#define MyPath ""

[Setup]
AppName={#MyAppName}
AppVersion={#MyAppVer}
AppVerName={#MyAppName} {#MyAppVer}
VersionInfoVersion={#MyAppVer}
DefaultDirName={pf}\{#MyAppName}
DefaultGroupName={#MyAppName}
UninstallDisplayName={#MyAppName} {#MyAppVer}
UninstallDisplayIcon={app}\{#MyAppName}.exe
;DisableDirPage=no
Compression=lzma2
SolidCompression=yes
;OutputDir=
OutputBaseFilename=Simple Ip Config Setup {#MyFileVer}

[Files]
Source: "Simple-IP-Config\{#MyAppName} {#MyFileVer}.exe"; DestDir: "{app}"; DestName: "{#MyAppName}.exe"
;Source: "MyProg.chm"; DestDir: "{app}"
;Source: "Readme.txt"; DestDir: "{app}"; Flags: isreadme

[Icons]
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppName}.exe"

[UninstallDelete]
Type: files; Name: "{pf}\{#MyAppName}\profiles.ini"

[Run]
Filename: {app}\{cm:AppName}.exe; Description: {cm:LaunchProgram,{cm:AppName}}; Flags: nowait postinstall skipifsilent

[Messages]
SetupAppTitle = Setup {#MyAppName}
SetupWindowTitle = Setup - {#MyAppName} v{#MyFriendlyVer}

[CustomMessages]
english.AppName={#MyAppName}

english.Program=Start {#MyAppName} after finishing installation?
italian.Program=Vuoi avviare {#MyAppName} al termine dell'installazione?

[Languages]
Name: "englisg"; MessagesFile: "compiler:default.isl"; 
Name: "italian"; MessagesFile: "compiler:Languages\Italian.isl"; 
