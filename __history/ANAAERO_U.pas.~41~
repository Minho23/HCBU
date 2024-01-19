unit ANAAERO_U;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Buttons,
  Data.DB, Vcl.Grids, Vcl.DBGrids, rDBGrid, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.Menus, rdlg;

type
  TANAAERO_F = class(TForm)
    p_title: TPanel;
    e_reg: TEdit;
    e_desc: TEdit;
    bb_save: TBitBtn;
    rDBGrid1: TrDBGrid;
    grb_aircraft: TGroupBox;
    grb_aircraft_details: TGroupBox;
    l_reg: TLabel;
    l_description: TLabel;
    bb_update: TBitBtn;
    ds_aero: TDataSource;
    q_insert_aero: TFDQuery;
    q_update_aero: TFDQuery;
    PopupMenu1: TPopupMenu;
    q_del: TMenuItem;
    q_delete_aero: TFDQuery;
    procedure bb_saveClick(Sender: TObject);
    procedure bb_updateClick(Sender: TObject);
    procedure q_delClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure rDBGrid1DblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ANAAERO_F: TANAAERO_F;

implementation

uses
  Main;

{$R *.dfm}

procedure AZZERA_CAMPI();
begin
  with ANAAERO_F do
  begin
    e_reg.Text := '';
    e_desc.Text := '';
    bb_save.Enabled := true;
    bb_update.Enabled := false;
    e_reg.Enabled := true;
    e_desc.Enabled := true;
  end;
end;

procedure TANAAERO_F.bb_saveClick(Sender: TObject);
begin
  if e_reg.Text <> '' then
  begin
    if e_desc.Text <> '' then
    begin
      with q_insert_aero do
      begin
        ParamByName('MARCHE').asString := trim(e_reg.Text);
        ParamByName('DESCRIZIONE').asString := trim(e_desc.Text);
      end;
      q_insert_aero.ExecSQL;

      // PRINCIPALE.etopic.Items.add(trim(e_reg.Text));

      dlgi('Insert success!');
    end;
  end;

  // PRINCIPALE.q_aero_only_hcbu.Refresh();
  AZZERA_CAMPI;
  Main.refresh_aero_list;

end;

procedure TANAAERO_F.bb_updateClick(Sender: TObject);
begin
  if e_reg.Text <> '' then
  begin
    if e_desc.Text <> '' then
    begin

      with q_update_aero do
      begin
        ParamByName('MARCHE').asString := trim(e_reg.Text);
        ParamByName('DESCRIZIONE').asString := trim(e_desc.Text);
      end;
      q_update_aero.ExecSQL;

      PRINCIPALE.q_aero_only_hcbu.Refresh;

    end;
  end;

  dlgi('Update success!');
  AZZERA_CAMPI;

end;

procedure TANAAERO_F.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  PRINCIPALE.q_aero_only_hcbu.Close();
end;

procedure TANAAERO_F.FormShow(Sender: TObject);
begin
  AZZERA_CAMPI;
  PRINCIPALE.q_aero_only_hcbu.Open();

end;

procedure TANAAERO_F.q_delClick(Sender: TObject);
begin

  with q_delete_aero do
  begin
    ParamByName('MARCHE').asString := rDBGrid1.DataSource.DataSet.FieldByName
      ('MARCHE').asString;

    // PRINCIPALE.etopic.Items.Delete
    // (PRINCIPALE.etopic.Items.IndexOf(rDBGrid1.DataSource.DataSet.FieldByName
    // ('MARCHE').asString));
  end;
  q_delete_aero.ExecSQL;
  // PRINCIPALE.q_aero_only_hcbu.Refresh;
  dlgi('Delete success!');
  AZZERA_CAMPI;

  Main.refresh_aero_list;

end;

procedure TANAAERO_F.rDBGrid1DblClick(Sender: TObject);
begin
  e_reg.Text := rDBGrid1.DataSource.DataSet.FieldByName('MARCHE').asString;
  e_desc.Text := rDBGrid1.DataSource.DataSet.FieldByName('DESCRIZIONE')
    .asString;
  bb_save.Enabled := false;
  bb_update.Enabled := true;
  e_reg.Enabled := false;
end;

end.
