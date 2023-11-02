program SimpleIpConfig;

{$mode objfpc}{$H+}

uses
 {$IFDEF UNIX}
  cthreads,
     {$ENDIF} {$IFDEF HASAMIGA}
  athreads,
     {$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms,
  uMain,
  uAbout,
  uChangelog,
  uAppData,
  uTypes,
  LazLogger,
  uNetwork,
  uFunctions,
  uSettings,
  uHideAdapters { you can add units after this };

{$R *.res}

begin
  RequireDerivedFormResource := True;
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(TFormMain, FormMain);
  RefreshFunc();

  if (FormMain.List_Profiles.Items.Count > 0) then
      //FormMain.List_Profiles.ItemIndex := 0;
      FormMain.List_Profiles.Selected := FormMain.List_Profiles.Items[0];

  Application.Run;
end.
