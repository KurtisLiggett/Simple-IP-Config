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

[Files]
Source: "Simple-IP-Config\{#MyAppName} {#MyAppVersion}.exe"; DestDir: "{app}"; DestName: "{#MyAppName}.exe"; Flags: ignoreversion
Source: "Simple-IP-Config\lang\*.json"; DestDir: "{app}\lang"; Flags: ignoreversion

[Icons]
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppName}.exe"

[UninstallDelete]
Type: files; Name: "{autopf}\{#MyAppName}\{#MyAppName}.exe"
Type: files; Name: "{autopf}\{#MyAppName}\lang\*.json"
Type: dirifempty; Name: "{autopf}\{#MyAppName}\lang"
Type: dirifempty; Name: "{autopf}\{#MyAppName}"

[Run]
Filename: {app}\{cm:AppName}.exe; Description: {cm:LaunchProgram,{cm:AppName}}; Flags: nowait postinstall skipifsilent

[CustomMessages]
AppName={#MyAppName}

[Languages]
Name: "english"; MessagesFile: "compiler:default.isl"; 
Name: "italian"; MessagesFile: "compiler:Languages\Italian.isl"; 
Name: "russian"; MessagesFile: "compiler:Languages\Russian.isl"; 
Name: "spanish"; MessagesFile: "compiler:Languages\Spanish.isl"; 