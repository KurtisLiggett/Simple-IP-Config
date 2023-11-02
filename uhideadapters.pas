unit uHideAdapters;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  Buttons, uAppData, StrUtils, LCLTranslator, ComCtrls, uNetwork, uFunctions;

type

  { TFormHideAdapters }

  TFormHideAdapters = class(TForm)
    Button_Save: TButton;
    Button_Cancel: TButton;
    Label_Title: TLabel;
    Label_Background: TLabel;
    Label_BackgroundLine: TLabel;
    ListView_Adapters: TListView;
    procedure Button_CancelClick(Sender: TObject);
    procedure Button_SaveClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private


  public

  end;

var
  FormHideAdapters: TFormHideAdapters;

implementation

{$R *.lfm}

uses
  uMain;

{ TFormHideAdapters }

procedure TFormHideAdapters.Button_SaveClick(Sender: TObject);
var
  AdapterList: string;
  i: integer;
begin
  AdapterList := '';
  for i := 0 to ListView_Adapters.Items.Count - 1 do
  begin
    if ListView_Adapters.Items[i].Checked then
      if AdapterList = '' then
        AdapterList := ListView_Adapters.Items[i].Caption
      else
        AdapterList := AdapterList + '|' + ListView_Adapters.Items[i].Caption;
  end;
  AppData.AdapterBlacklist := AdapterList;
  BuildAdapterList();
  AppData.Save;

  Close;
end;

procedure TFormHideAdapters.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  CloseAction := caFree;
end;

procedure TFormHideAdapters.FormCreate(Sender: TObject);
var
  adapterName: string;
  Item: TListItem;
  HideAdapterNames: array of string;
  thisName: string;
begin
  HideAdapterNames := SplitString(AppData.AdapterBlacklist, '|');
  for adapterName in GetAdapterList() do
  begin
    begin
      Item := ListView_Adapters.Items.Add;
      Item.Caption := adapterName;
      for thisName in HideAdapterNames do
      begin
        if thisName = adapterName then
        begin
          Item.Checked := True;
          break;
        end;
      end;
    end;
  end;
end;

procedure TFormHideAdapters.Button_CancelClick(Sender: TObject);
begin
  Close;
end;


end.
