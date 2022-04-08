#define MyAppName "Simple IP Config"
#define MyAppVersion "2.9.3"
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

[Files]
Source: "Simple-IP-Config\{#MyAppName} {#MyAppVersion}.exe"; DestDir: "{app}"; DestName: "{#MyAppName}.exe"

[Icons]
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppName}.exe"

[UninstallDelete]
Type: files; Name: "{autopf}\{#MyAppName}\profiles.ini"
Type: files; Name: "{autopf}\{#MyAppName}\{#MyAppName}.exe"

[Run]
Filename: {app}\{cm:AppName}.exe; Description: {cm:LaunchProgram,{cm:AppName}}; Flags: nowait postinstall skipifsilent

[CustomMessages]
AppName={#MyAppName}
english.Program=Start {#MyAppName} after finishing installation?
italian.Program=Vuoi avviare {#MyAppName} al termine dell'installazione?
russian.Program=Запустите {#MyAppName} после завершения установки?

[Languages]
Name: "english"; MessagesFile: "compiler:default.isl"; 
Name: "italian"; MessagesFile: "compiler:Languages\Italian.isl"; 
Name: "russian"; MessagesFile: "compiler:Languages\Russian.isl"; 