unit uAbout;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  Buttons, uAppData;

type

  { TFormAbout }

  TFormAbout = class(TForm)
    Button_OK: TButton;
    Image_Logo: TImage;
    Label_Description: TLabel;
    Label_Title: TLabel;
    Label_VersionTitle: TLabel;
    Label_DateTitle: TLabel;
    Label_DeveloperTitle: TLabel;
    Label_LicenseTitle: TLabel;
    Label_Version: TLabel;
    Label_Date: TLabel;
    Label_Developer: TLabel;
    Label_License: TLabel;
    Label_Background: TLabel;
    Label_BackgroundLine: TLabel;
    procedure Button_OKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private

  public

  end;

var
  FormAbout: TFormAbout;

implementation

{$R *.lfm}

resourcestring
  AboutStr = 'About';

{ TFormAbout }

procedure TFormAbout.Button_OKClick(Sender: TObject);
begin
  Close;
end;

procedure TFormAbout.FormCreate(Sender: TObject);
begin
  Caption := AboutStr + ' Simple IP Config';
  Label_Version.Caption := AppData.Version;
  Label_Date.Caption := AppData.Date;
end;

procedure TFormAbout.FormShow(Sender: TObject);
begin

end;

end.
