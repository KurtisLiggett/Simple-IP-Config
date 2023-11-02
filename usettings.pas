unit uSettings;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  Buttons, uAppData, StrUtils, LCLTranslator;

type

  { TFormSettings }

  TFormSettings = class(TForm)
    Button_Save: TButton;
    Button_Cancel: TButton;
    Check_StartInTray: TCheckBox;
    Check_CloseToTray: TCheckBox;
    Check_CheckForUpdates: TCheckBox;
    Combo_Language: TComboBox;
    Label_Language: TLabel;
    Label_Background: TLabel;
    Label_BackgroundLine: TLabel;
    procedure Button_CancelClick(Sender: TObject);
    procedure Button_SaveClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    function getLangCode(lang: string): string;
    function getLangFromCode(langCode: string): string;

  public

  end;

var
  FormSettings: TFormSettings;

implementation

{$R *.lfm}

{ TFormSettings }

procedure TFormSettings.Button_SaveClick(Sender: TObject);
var
  LangCode: string;
begin
  LangCode := getLangCode(Combo_Language.Text);
  AppData.Settings.Language := LangCode;
  SetDefaultLang(AppData.Settings.Language);

  if Check_StartInTray.State = cbChecked then
    AppData.Settings.StartInTray := True
  else
    AppData.Settings.StartInTray := False;

  if Check_CloseToTray.State = cbChecked then
    AppData.Settings.CloseToTray := True
  else
    AppData.Settings.CloseToTray := False;

  if Check_CheckForUpdates.State = cbChecked then
    AppData.Settings.CheckForUpdates := True
  else
    AppData.Settings.CheckForUpdates := False;

  AppData.Save;
  Close;
end;

procedure TFormSettings.FormClose(Sender: TObject; var CloseAction: TCloseAction
  );
begin
  CloseAction := caFree;
end;

procedure TFormSettings.FormCreate(Sender: TObject);
begin

end;

procedure TFormSettings.FormShow(Sender: TObject);
var
  lang: string;
begin
  lang := getLangFromCode(AppData.Settings.Language);
  if lang = '' then
     Combo_Language.Text := 'English  (en)'
  else
    Combo_Language.Text := lang;

  if AppData.Settings.StartInTray then
    Check_StartInTray.State := cbChecked
  else
    Check_StartInTray.State := cbUnchecked;

  if AppData.Settings.CloseToTray then
    Check_CloseToTray.State := cbChecked
  else
    Check_CloseToTray.State := cbUnchecked;

  if AppData.Settings.CheckForUpdates then
    Check_CheckForUpdates.State := cbChecked
  else
    Check_CheckForUpdates.State := cbUnchecked;

end;

procedure TFormSettings.Button_CancelClick(Sender: TObject);
begin
  Close;
end;


function TFormSettings.getLangCode(lang: string): string;
var
  posLeft: integer;
  posRight: integer;

begin
  posLeft := pos('(', lang) + 1;
  posRight := pos(')', lang);
  Result := MidStr(lang, posLeft, posRight - posLeft);
end;

function TFormSettings.getLangFromCode(langCode: string): string;
var
  i: integer;

begin
  Result := '';
  for i := 0 to Combo_Language.Items.Count - 1 do
  begin
    if pos('(' + langCode + ')', Combo_Language.Items[i]) <> 0 then
    begin
      Result := Combo_Language.Items[i];
      break;
    end;
  end;
end;

end.
