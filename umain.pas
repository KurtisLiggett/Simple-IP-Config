unit uMain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Menus,
  DefaultTranslator, LCLTranslator, lclintf, ComCtrls, Buttons, ExtCtrls,
  MaskEdit, Calendar, StrUtils, uAppData, uAbout, uChangelog,
  LazLogger, ShellApi, uFunctions, uSettings, uTypes, LCLType,
  uHideAdapters;

type

  { TFormMain }

  TFormMain = class(TForm)
    Button_Apply: TButton;
    Check_RegisterDns: TCheckBox;
    Combo_Adapters: TComboBox;
    Label_DnsAltInfo: TEdit;
    Label_DhcpInfo: TEdit;
    Label_IpAddressInfo: TEdit;
    Edit_Filter: TEdit;
    Edit_DnsPref: TEdit;
    Edit_IpGateway: TEdit;
    Edit_IpSubnet: TEdit;
    Edit_DnsAlt: TEdit;
    Edit_IpAddress: TEdit;
    Image1: TImage;
    ImageList1: TImageList;
    Label_AdapterDescription: TLabel;
    Label_AdapterStateInfo: TLabel;
    Label_DnsPrefInfo: TEdit;
    Label_IpSubnetInfo: TEdit;
    Label_IpGatewayInfo: TEdit;
    Label_IpSubnetInfoTitle: TLabel;
    Label_IpGatewayInfoTitle: TLabel;
    Label_DnsPrefInfoTitle: TLabel;
    Label_DnsAltInfoTitle: TLabel;
    Label_DhcpInfoTitle: TLabel;
    Label_AdapterStateInfoTitle: TLabel;
    Label_MacTitle: TLabel;
    Label_Domain: TLabel;
    Label_IpAddress: TLabel;
    Label_ComputerName: TLabel;
    Label_DnsPref: TLabel;
    Label_IpSubnet: TLabel;
    Label_IpGateway: TLabel;
    Label_DnsAlt: TLabel;
    Label_Mac: TLabel;
    Label_IpAddressInfoTitle: TLabel;
    List_Profiles: TListView;
    MainMenu1: TMainMenu;
    MaskEdit1: TMaskEdit;
    MenuFile: TMenuItem;
    MenuFile_Apply: TMenuItem;
    MenuFile_Sep1: TMenuItem;
    MenuFile_Rename: TMenuItem;
    MenuFile_New: TMenuItem;
    MenuFile_Save: TMenuItem;
    MenuFile_Delete: TMenuItem;
    MenuFile_Clear: TMenuItem;
    MenuFile_CreateShortcut: TMenuItem;
    MenuFile_Sep2: TMenuItem;
    MenuFile_Open: TMenuItem;
    MenuFile_Import: TMenuItem;
    MenuFile_Export: TMenuItem;
    MenuFile_Sep3: TMenuItem;
    MenuFile_Exit: TMenuItem;
    MenuHelp_OnlineDoc: TMenuItem;
    MenuHelp_Sep1: TMenuItem;
    MenuHelp_ChangeLog: TMenuItem;
    MenuHelp_CheckForUpdates: TMenuItem;
    MenuHelp_About: TMenuItem;
    MenuTray_Hide: TMenuItem;
    MenuTray_About: TMenuItem;
    MenuTray_Sep1: TMenuItem;
    MenuTray_Exit: TMenuItem;
    MenuTools_OpenNetworkConnections: TMenuItem;
    MenuTools_Settings: TMenuItem;
    MenuTools_Pull: TMenuItem;
    MenuTools_Sep1: TMenuItem;
    MenuTools_Release: TMenuItem;
    MenuTools_Renew: TMenuItem;
    MenuTools_ReleaseRenew: TMenuItem;
    MenuTools_Sep2: TMenuItem;
    MenuTools_GoToProfiles: TMenuItem;
    MenuView_Refresh: TMenuItem;
    MenuView_SendToTray: TMenuItem;
    MenuView_Sep1: TMenuItem;
    MenuView_HideAdapters: TMenuItem;
    MenuView: TMenuItem;
    MenuTools: TMenuItem;
    MenuHelp: TMenuItem;
    Panel_RadioIpAuto: TPanel;
    Panel_RadioDnsAuto: TPanel;
    SysTrayMenu: TPopupMenu;
    Radio_IpAuto: TRadioButton;
    Radio_DnsAuto: TRadioButton;
    Radio_IpManual: TRadioButton;
    Radio_DnsManual: TRadioButton;
    Shape_InfoBackground: TShape;
    Shape_InfoDiv1: TShape;
    Shape_InfoBackground1: TShape;
    Shape_InfoDiv2: TShape;
    Shape_InfoDiv3: TShape;
    Shape_IpBackground: TShape;
    Shape_FilterBackground: TShape;
    Shape_DnsBackground: TShape;
    Shape_ProfilesBackground: TShape;
    Button_Refresh: TSpeedButton;
    StatusBar1: TStatusBar;
    StatusTimer: TTimer;
    ToolBar1: TToolBar;
    ToolButton_New: TToolButton;
    ToolButton_Save: TToolButton;
    ToolButton_Sep: TToolButton;
    ToolButton_Delete: TToolButton;
    SystrayIcon: TTrayIcon;
    procedure Button_ApplyClick(Sender: TObject);
    procedure Combo_AdaptersChange(Sender: TObject);
    procedure Edit_FilterChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Label_ProfilesBackgroundClick(Sender: TObject);
    procedure List_ProfilesEdited(Sender: TObject; Item: TListItem; var AValue: string);
    procedure List_ProfilesSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure MaskEdit1Change(Sender: TObject);
    procedure MenuFile_ClearClick(Sender: TObject);
    procedure MenuFile_DeleteClick(Sender: TObject);
    procedure MenuFile_ExitClick(Sender: TObject);
    procedure MenuFile_NewClick(Sender: TObject);
    procedure MenuFile_RenameClick(Sender: TObject);
    procedure MenuFile_SaveClick(Sender: TObject);
    procedure MenuHelp_AboutClick(Sender: TObject);
    procedure MenuHelp_ChangeLogClick(Sender: TObject);
    procedure MenuHelp_OnlineDocClick(Sender: TObject);
    procedure MenuTools_OpenNetworkConnectionsClick(Sender: TObject);
    procedure Button_RefreshClick(Sender: TObject);
    procedure MenuTools_PullClick(Sender: TObject);
    procedure MenuTools_SettingsClick(Sender: TObject);
    procedure MenuTray_AboutClick(Sender: TObject);
    procedure MenuTray_ExitClick(Sender: TObject);
    procedure MenuTray_HideClick(Sender: TObject);
    procedure MenuView_HideAdaptersClick(Sender: TObject);
    procedure MenuView_RefreshClick(Sender: TObject);
    procedure MenuView_SendToTrayClick(Sender: TObject);
    procedure StatusTimerTimer(Sender: TObject);
    procedure SystrayIconClick(Sender: TObject);
    procedure ToolButton_DeleteClick(Sender: TObject);
    procedure ToolButton_NewClick(Sender: TObject);
    procedure ToolButton_SaveClick(Sender: TObject);
  private

  public

  end;

var
  FormMain: TFormMain;

resourcestring
  rsTrayMenu_Hide = 'Hide';
  rsTrayMenu_Show = 'Show';

implementation

{$R *.lfm}

{ TFormMain }

procedure TFormMain.Label_ProfilesBackgroundClick(Sender: TObject);
begin

end;


procedure TFormMain.List_ProfilesEdited(Sender: TObject; Item: TListItem; var AValue: string);
var
  exists: boolean;
  i: integer;
begin
  //debugln(AppData.ProfileListEditingName);
  debugln(Item.Caption);
  debugln(AValue);
  debugln('');

  //check if new name exists
  exists := False;
  for i := 0 to List_Profiles.Items.Count - 1 do
  begin
    if (List_Profiles.Items[i].Caption = AValue) and (List_Profiles.Items[i].Caption <> Item.Caption) then
    begin
      exists := True;
      break;
    end;
  end;

  if exists then
  begin
    Application.MessageBox('Profile name already exists!', 'Error', MB_OK + MB_ICONERROR);
    AValue := Item.Caption;
  end
  else if (AValue = '') then
  begin
    AValue := Item.Caption;
  end
  else
  begin
    if AValue <> '' then
    begin
      AppData.Profiles.Rename(Item.Caption, AValue);
      AppData.Save;
    end;
  end;

end;

procedure TFormMain.List_ProfilesSelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
var
  s: string;
begin
  if Selected then
  begin
    if (List_Profiles.ItemIndex > -1) then
    begin
      s := List_Profiles.Items[List_Profiles.ItemIndex].Caption;
      if s <> '' then
        SetProfile(s);
        RefreshAdapterInfo();
    end;
  end;
end;

procedure TFormMain.MaskEdit1Change(Sender: TObject);
begin

end;

procedure TFormMain.MenuFile_ClearClick(Sender: TObject);
begin
  FormMain.Edit_IpAddress.Text := '';
  FormMain.Edit_IpSubnet.Text := '';
  FormMain.Edit_IpGateway.Text := '';
  FormMain.Edit_DnsPref.Text := '';
  FormMain.Edit_DnsAlt.Text := '';
  FormMain.Check_RegisterDns.State := cbUnchecked;
end;

procedure TFormMain.MenuFile_DeleteClick(Sender: TObject);
begin
  DeleteProfile();
end;

procedure TFormMain.MenuFile_ExitClick(Sender: TObject);
begin
  Close;
end;

procedure TFormMain.MenuFile_NewClick(Sender: TObject);
begin
  NewProfile();
end;

procedure TFormMain.MenuFile_RenameClick(Sender: TObject);
var
  s: string;

begin
  if (List_Profiles.ItemIndex > -1) then
  begin
    s := List_Profiles.Items[List_Profiles.ItemIndex].Caption;
    if s <> '' then
      List_Profiles.Items[List_Profiles.ItemIndex].EditCaption();
  end;
end;

procedure TFormMain.MenuFile_SaveClick(Sender: TObject);
begin
  SaveProfile();
end;

procedure TFormMain.MenuHelp_AboutClick(Sender: TObject);
var
  FormAbout: TFormAbout;
begin
  FormAbout := TFormAbout.Create(Application);
  FormAbout.ShowModal;
end;

procedure TFormMain.MenuHelp_ChangeLogClick(Sender: TObject);
var
  FormChangelog: TFormChangelog;
begin
  FormChangelog := TFormChangelog.Create(Application);
  FormChangelog.ShowModal;
end;

procedure TFormMain.Edit_FilterChange(Sender: TObject);
begin

end;

procedure TFormMain.Combo_AdaptersChange(Sender: TObject);
begin
  RefreshAdapterInfo();
end;

procedure TFormMain.Button_ApplyClick(Sender: TObject);
begin
  SetIP();
end;

procedure TFormMain.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  debugln('closing time');
end;

procedure TFormMain.FormCreate(Sender: TObject);
begin
  FormMain.MenuTray_Hide.Caption := rsTrayMenu_Hide;
end;

procedure TFormMain.FormShow(Sender: TObject);
var
  s: string;
begin
  //FormMain.Label_AdapterDescription.Caption := '';
  //FormMain.Label_Mac.Caption := '';
  //FormMain.Label_IpAddressInfo.Caption := '';
  //FormMain.Label_IpSubnetInfo.Caption := '';
  //FormMain.Label_IpGatewayInfo.Caption := '';
  //FormMain.Label_DnsPrefInfo.Caption := '';
  //FormMain.Label_DnsAltInfo.Caption := '';
  //FormMain.Label_DhcpInfo.Caption := '';
  //FormMain.Label_AdapterStateInfo.Caption := '';

  if (AppData.PositionX <> -1) and (AppData.PositionY <> -1) then
  begin
    FormMain.Left := AppData.PositionX;
    FormMain.Top := AppData.PositionY;
  end;
  SystrayIcon.Show;
end;

procedure TFormMain.MenuHelp_OnlineDocClick(Sender: TObject);
begin
  OpenURL('https://github.com/KurtisLiggett/Simple-IP-Config');
end;

procedure TFormMain.MenuTools_OpenNetworkConnectionsClick(Sender: TObject);
begin
  ShellExecute(0, nil, PChar('ncpa.cpl'), PChar(''), nil, 1);
end;

procedure TFormMain.Button_RefreshClick(Sender: TObject);
begin
  RefreshFunc();
end;

procedure TFormMain.MenuTools_PullClick(Sender: TObject);
begin
  PullFromAdapter();
end;

procedure TFormMain.MenuTools_SettingsClick(Sender: TObject);
var
  FormSettings: TFormSettings;
begin
  FormSettings := TFormSettings.Create(Application);
  FormSettings.ShowModal;
end;

procedure TFormMain.MenuTray_AboutClick(Sender: TObject);
var
  FormAbout: TFormAbout;
begin
  FormAbout := TFormAbout.Create(Application);
  FormAbout.ShowModal;
end;

procedure TFormMain.MenuTray_ExitClick(Sender: TObject);
begin
  Close;
end;

procedure TFormMain.MenuTray_HideClick(Sender: TObject);
begin
  if FormMain.Visible then
  begin
    FormMain.Hide;
    FormMain.MenuTray_Hide.Caption := rsTrayMenu_Show;
  end
  else
  begin
    FormMain.Show;
    FormMain.MenuTray_Hide.Caption := rsTrayMenu_Hide;
  end;
end;

procedure TFormMain.MenuView_HideAdaptersClick(Sender: TObject);
var
  FormHideAdapters: TFormHideAdapters;
begin
  FormHideAdapters := TFormHideAdapters.Create(Application);
  FormHideAdapters.ShowModal;
end;

procedure TFormMain.MenuView_RefreshClick(Sender: TObject);
begin
  RefreshFunc();
end;

procedure TFormMain.MenuView_SendToTrayClick(Sender: TObject);
begin
  FormMain.Hide;
  FormMain.MenuTray_Hide.Caption := rsTrayMenu_Show;
end;

procedure TFormMain.StatusTimerTimer(Sender: TObject);
begin
  StatusBar1.SimpleText := '';
  StatusTimer.Enabled := False;
end;

procedure TFormMain.SystrayIconClick(Sender: TObject);
begin
  if FormMain.Visible then
  begin
    FormMain.Hide;
    FormMain.MenuTray_Hide.Caption := rsTrayMenu_Show;
  end
  else
  begin
    FormMain.Show;
    FormMain.MenuTray_Hide.Caption := rsTrayMenu_Hide;
  end;

end;

procedure TFormMain.ToolButton_NewClick(Sender: TObject);
begin
  NewProfile();
end;

procedure TFormMain.ToolButton_SaveClick(Sender: TObject);
begin
  SaveProfile();
end;

procedure TFormMain.ToolButton_DeleteClick(Sender: TObject);
begin
  DeleteProfile();
end;


end.
