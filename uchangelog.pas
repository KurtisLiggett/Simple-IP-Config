unit uChangelog;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  Buttons, RichMemo, uAppData;

type

  { TFormChangelog }

  TFormChangelog = class(TForm)
    Button_OK: TButton;
    Label_Background: TLabel;
    Label_BackgroundLine: TLabel;
    RichMemo1: TRichMemo;
    procedure Button_OKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    function RichEdit_Begin(): string;
    function RichEdit_End(): string;
    function RichEdit_AddVersion(sData: string): string;
    function RichEdit_AddHeading(sData: string): string;
    function RichEdit_AddItem(sData: string): string;
  public

  end;

var
  FormChangelog: TFormChangelog;

implementation

{$R *.lfm}

{ TFormChangelog }

procedure TFormChangelog.Button_OKClick(Sender: TObject);
begin
  Close;
end;

procedure TFormChangelog.FormCreate(Sender: TObject);
var
  sText: string;
begin
  sText := RichEdit_Begin();

  sText := sText + RichEdit_AddVersion('3.0.0');
  sText := sText + RichEdit_AddHeading('New Codebase:');
  sText := sText + RichEdit_AddItem('No more anti-virus false positives.');
  sText := sText + RichEdit_AddItem('Lower memory usage.');
  sText := sText + RichEdit_AddItem('Improved performance.');
  sText := sText + RichEdit_AddItem('Faster development.');

  sText := sText + RichEdit_AddVersion('2.9.8');
  sText := sText + RichEdit_AddHeading('BUG FIXES:');
  sText := sText + RichEdit_AddItem('#178  Error running from shortcut.');
  sText := sText + RichEdit_AddItem('#186  Wrong adapter selected.');
  sText := sText + RichEdit_AddItem('Domain name not updated after selecting language.');
  sText := sText + RichEdit_AddItem('Miscellaneous DPI scaling bugs.');
  sText := sText + RichEdit_AddHeading('NEW FEATURES:');
  sText := sText + RichEdit_AddItem(
    '#118  Added memo field to store notes per profile.');
  sText := sText + RichEdit_AddItem('#171  Added ability to resize the window.');
  sText := sText + RichEdit_AddItem('Dark');

  sText := sText + RichEdit_AddVersion('2.9.7');
  sText := sText + RichEdit_AddHeading('BUG FIXES:');
  sText := sText + RichEdit_AddItem('#141  Behavior when adapter does not exist.');
  sText := sText + RichEdit_AddItem(
    '#157  Save profiles in portable directory (auto-detect).');
  sText := sText + RichEdit_AddItem('#166  Workgroup incorrect text.');
  sText := sText + RichEdit_AddItem('#167  Refresh button does nothing.');
  sText := sText + RichEdit_AddItem('#169  Error reading language file.');
  sText := sText + RichEdit_AddHeading('NEW FEATURES:');
  sText := sText + RichEdit_AddItem('#123  Added copy/paste buttons to IP addresses.');
  sText := sText + RichEdit_AddItem('#163  Close to system tray.');
  sText := sText + RichEdit_AddItem('#164  Auto expand larger error popup messages.');

  sText := sText + RichEdit_AddVersion('v2.9.6');
  sText := sText + RichEdit_AddHeading('BUG FIXES:');
  sText := sText + RichEdit_AddItem(
    'Internal issues with array handling. (affected lots of things).');
  sText := sText + RichEdit_AddItem('#152  Program antivirus false-positive.');

  sText := sText + RichEdit_AddVersion('v2.9.5');
  sText := sText + RichEdit_AddHeading('BUG FIXES:');
  sText := sText + RichEdit_AddItem(
    '#150  Fixed issue - Sort profiles crashed and deleted all profiles.');
  sText := sText + RichEdit_AddItem('#148  Fixed issue - Apply button text language.');

  sText := sText + RichEdit_AddVersion('v2.9.4');
  sText := sText + RichEdit_AddHeading('BUG FIXES:');
  sText := sText + RichEdit_AddItem(
    '#143  Fixed issue - crash on TAB key while renaming.');
  sText := sText + RichEdit_AddItem('#103  COM Error 80020009 checking for updates.');
  sText := sText + RichEdit_AddItem('Bug creating new profiles from scratch.');
  sText := sText + RichEdit_AddHeading('NEW FEATURES:');
  sText := sText + RichEdit_AddItem('#117  Added multi-language support.');
  sText := sText + RichEdit_AddItem(
    '#99  Added ability to open, import, and export profiles.');
  sText := sText + RichEdit_AddItem('Added menu item to open network connections.');
  sText := sText + RichEdit_AddItem('Added menu item to go to profiles.ini location.');
  sText := sText + RichEdit_AddItem('Select subnet when tabbing from IP.');
  sText := sText + RichEdit_AddItem('#43  Escape key will no longer close the program.');
  sText := sText + RichEdit_AddItem('#104  Bring to foreground if already running.');
  sText := sText + RichEdit_AddHeading('MAINT:');
  sText := sText + RichEdit_AddItem('Updated layout.');
  sText := sText + RichEdit_AddItem('New toolbar icons.');
  sText := sText + RichEdit_AddItem('Updated check for updates functionality.');
  sText := sText + RichEdit_AddItem('Moved profiles.ini to local AppData');
  sText := sText + RichEdit_AddItem(
    'Removed shortcut Ctrl+c to prevent accidental clear');
  sText := sText + RichEdit_AddItem('Code redesigned.');

  sText := sText + RichEdit_AddVersion('v2.9.3');
  sText := sText + RichEdit_AddHeading('BUG FIXES:');
  sText := sText + RichEdit_AddItem('#80  Bad automatic update behavior.');
  sText := sText + RichEdit_AddHeading('NEW FEATURES:');
  sText := sText + RichEdit_AddItem('#80 Better update handling / new dialog.');

  sText := sText + RichEdit_AddVersion('v2.9.2');
  sText := sText + RichEdit_AddHeading('BUG FIXES:');
  sText := sText + RichEdit_AddItem('#75  After search, profiles don''t load.');
  sText := sText + RichEdit_AddHeading('NEW FEATURES:');
  sText := sText + RichEdit_AddItem('#36  Better hide adapters popup selection.');

  sText := sText + RichEdit_AddVersion('v2.9.1');
  sText := sText + RichEdit_AddHeading('BUG FIXES:');
  sText := sText + RichEdit_AddItem('#71  COM error when no internet connection.');

  sText := sText + RichEdit_AddVersion('v2.9');
  sText := sText + RichEdit_AddHeading('NEW FEATURES:');
  sText := sText + RichEdit_AddItem('#4  Create desktop shortcuts to profiles');
  sText := sText + RichEdit_AddItem('#15  Automatic Updates');
  sText := sText + RichEdit_AddItem(
    '#7  Added Debug item to Help menu for troubleshooting issues.');
  sText := sText + RichEdit_AddHeading('MAJOR CHANGES:');
  sText := sText + RichEdit_AddItem('Major code improvements');
  sText := sText + RichEdit_AddHeading('BUG FIXES:');
  sText := sText + RichEdit_AddItem(
    '#3  Setting profiles when profiles.ini is out of order.');
  sText := sText + RichEdit_AddItem(
    '#3  Setting profiles after drag-and-drop to rearrange.');
  sText := sText + RichEdit_AddItem('#13  Issue opening the program two times.');
  sText := sText + RichEdit_AddItem('#19  Program starts off screen with dual screens.');
  sText := sText + RichEdit_AddItem('#22  Program crashes on Delete.');
  sText := sText + RichEdit_AddItem('#23  Profile ''0'' created unintentionally.');
  sText := sText + RichEdit_AddItem('#24  Double-clicking profiles behavior.');
  sText := sText + RichEdit_AddItem('#25  Adapters not showing up with underscore.');
  sText := sText + RichEdit_AddItem('#26  Left-handed mouse could not select profiles.');
  sText := sText + RichEdit_AddItem('#35  Hide adapters broken.');
  sText := sText + RichEdit_AddItem('#39/40  Sort profiles broken.');
  sText := sText + RichEdit_AddItem('#42  Issue with checking for updates.');
  sText := sText + RichEdit_AddItem('#44  Help menu link to documentation.');
  sText := sText + RichEdit_AddItem('#45  Added menu mnemonics (access keys).');
  sText := sText + RichEdit_AddItem('#47  Fixed message on duplicate IP address.');

  sText := sText + RichEdit_AddVersion('v2.8.1');
  sText := sText + RichEdit_AddHeading('BUG FIXES:');
  sText := sText + RichEdit_AddItem('IP address entry text scaling');

  sText := sText + RichEdit_AddVersion('v2.8');
  sText := sText + RichEdit_AddHeading('MAJOR CHANGES:');
  sText := sText + RichEdit_AddItem(
    'Now using IP Helper API (Iphlpapi.dll) instead of WMI');
  sText := sText + RichEdit_AddItem('Speed improvements -> 2x faster!');
  sText := sText + RichEdit_AddHeading('MINOR CHANGES:');
  sText := sText + RichEdit_AddItem('Automatically fill in 255.255.255.0 for subnet');
  sText := sText + RichEdit_AddItem('Save last window position on exit');
  sText := sText + RichEdit_AddItem(
    'Tray message when an trying to start a new instance');
  sText := sText + RichEdit_AddItem('Smaller exe file size');
  sText := sText + RichEdit_AddItem('Popup window positioning follows main window');
  sText := sText + RichEdit_AddItem('Allow more space for current properties');
  sText := sText + RichEdit_AddItem('Smoother startup process');
  sText := sText + RichEdit_AddItem(
    'Get current information from disconnected adapters');
  sText := sText + RichEdit_AddHeading('BUG FIXES:');
  sText := sText + RichEdit_AddItem('IP address entry text scaling');
  sText := sText + RichEdit_AddItem('Fixed ''start in system tray'' setting');
  sText := sText + RichEdit_AddItem('Fixed starting without toolbar icons');
  sText := sText + RichEdit_AddItem('Display disabled adapters');
  sText := sText + RichEdit_AddItem('Get current properties from disabled adapters');
  sText := sText + RichEdit_AddItem('Disabled adapters behavior');
  sText := sText + RichEdit_AddItem('Fixed hanging on setting profiles');
  sText := sText + RichEdit_AddItem('Fixed renaming/creating profiles issues');
  sText := sText + RichEdit_AddItem('Fixed additional DPI scaling issues');

  sText := sText + RichEdit_AddVersion('v2.7');
  sText := sText + RichEdit_AddHeading('MAJOR CHANGES:');
  sText := sText + RichEdit_AddItem('Code switched back to AutoIt');
  sText := sText + RichEdit_AddItem('Proper DPI scaling');
  sText := sText + RichEdit_AddHeading('NEW FEATURES:');
  sText := sText + RichEdit_AddItem('Enable DNS address registration');
  sText := sText + RichEdit_AddItem('Hide unused adapters');
  sText := sText + RichEdit_AddItem('Display computer name and domain address');
  sText := sText + RichEdit_AddHeading('OTHER CHANGES:');
  sText := sText + RichEdit_AddItem('Single click to restore from system tray');
  sText := sText + RichEdit_AddItem('Improved status bar');
  sText := sText + RichEdit_AddItem('Allow only 1 instance to run');
  sText := sText + RichEdit_AddHeading('BUG FIXES:');
  sText := sText + RichEdit_AddItem('Proper scaling with larger/smaller screen fonts');
  sText := sText + RichEdit_AddItem('Fixed tooltip in system tray');

  sText := sText + RichEdit_AddVersion('v2.6');
  sText := sText + RichEdit_AddHeading('NEW FEATURES:');
  sText := sText + RichEdit_AddItem('Filter Profiles!');
  sText := sText + RichEdit_AddItem('''Start in System Tray'' setting');
  sText := sText + RichEdit_AddItem('Release / renew DHCP tool');
  sText := sText + RichEdit_AddItem('''Saveas'' button is now ''New'' button');
  sText := sText + RichEdit_AddHeading('OTHER CHANGES:');
  sText := sText + RichEdit_AddItem('Enhanced ''Rename'' interface');
  sText := sText + RichEdit_AddItem('New layout to show more profiles');
  sText := sText + RichEdit_AddItem('Other GUI enhancements');
  sText := sText + RichEdit_AddHeading('BUG FIXES:');
  sText := sText + RichEdit_AddItem('Detect no IP address / subnet input');
  sText := sText + RichEdit_AddItem('Fix DNS error occurring on some systems');
  sText := sText + RichEdit_AddItem('Better detection of duplicate profile names');

  sText := sText + RichEdit_End();
  RichMemo1.Rtf := sText;
end;

function TFormChangelog.RichEdit_Begin(): string;
begin
  Result :=
    '{\rtf1\ansi\ansicpg1252\deff0\nouicompat\deflang1033{\fonttbl{\f0\fnil\fcharset0 Calibri;}}{\colortbl ;\red51\green51\blue51;}{\*\generator Riched20 10.0.22621}\viewkind4\uc1\lang9\f0' + sLineBreak;
end;

function TFormChangelog.RichEdit_End(): string;
begin
  Result := '}';
end;

function TFormChangelog.RichEdit_AddVersion(sData: string): string;
begin
  Result := '\pard\sb250\sl276\slmult1\cf1\b\f0\fs22\lang9 ' + sData +
    '\par' + sLineBreak;
end;

function TFormChangelog.RichEdit_AddHeading(sData: string): string;
begin
  Result := '\pard\sb100\sa50\cf0\b0\fs20 ' + sData + '\par' + sLineBreak;
end;

function TFormChangelog.RichEdit_AddItem(sData: string): string;
begin
  Result := '\pard\li270\sl240\slmult1 ' + sData + '\par' + sLineBreak;
end;

end.
