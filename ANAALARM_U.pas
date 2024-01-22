unit ANAALARM_U;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Data.DB,
  Vcl.Grids, Vcl.DBGrids, rDBGrid, Vcl.Buttons, Vcl.Mask, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, rImprovedComps;

type
  TANAALARM_F = class(TForm)
    p_title: TPanel;
    gb_registrations: TGroupBox;
    gb_params: TGroupBox;
    rDBGrid1: TrDBGrid;
    l_ias_max: TLabeledEdit;
    l_vsi_max: TLabeledEdit;
    l_pitch_max: TLabeledEdit;
    l_roll_max: TLabeledEdit;
    l_height_min: TLabeledEdit;
    l_alt_max: TLabeledEdit;
    l_gtot_min: TLabeledEdit;
    l_gtot_max: TLabeledEdit;
    bb_update: TBitBtn;
    ds_aero_alarm: TDataSource;
    q_get_alarm_only_hcbu: TFDQuery;
    q_update_alarm: TFDQuery;
    bb_insert: TBitBtn;
    q_insert_alarm: TFDQuery;
    cbe_registrations: TrComboBoxEx;
    l_reg: TLabel;
    procedure FormShow(Sender: TObject);
    procedure rDBGrid1DblClick(Sender: TObject);
    procedure bb_updateClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure bb_insertClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ANAALARM_F: TANAALARM_F;
  MARCHE_SELECTED: String;

implementation

{$R *.dfm}

uses

  Main;

procedure AZZERA_TUTTO;
begin
  with ANAALARM_F do
  begin
    bb_update.Enabled := false;
    bb_insert.Enabled := true;
    l_ias_max.Text := '';
    l_vsi_max.Text := '';
    l_pitch_max.Text := '';
    l_roll_max.Text := '';
    l_gtot_min.Text := '';
    l_gtot_max.Text := '';
    l_alt_max.Text := '';
    l_height_min.Text := '';
  end;

end;

procedure TANAALARM_F.bb_insertClick(Sender: TObject);
begin

  // CONTROLLO PER VERIFICARE CHE NON SIANO VUOTI I CAMPI

  with q_insert_alarm do
  begin
    ParamByName('MARCHE').AsString := cbe_registrations.Text;
    ParamByName('GTOT_MIN').AsFloat := StrToFloat(l_gtot_min.Text);
    ParamByName('GTOT_MAX').AsFloat := StrToFloat(l_gtot_max.Text);
    ParamByName('IAS_MAX').AsFloat := StrToFloat(l_ias_max.Text);
    ParamByName('VSI_MAX').AsFloat := StrToFloat(l_vsi_max.Text);
    ParamByName('PITCH_MAX').AsFloat := StrToFloat(l_pitch_max.Text);
    ParamByName('ROLL_MAX').AsFloat := StrToFloat(l_roll_max.Text);
    ParamByName('HEIGHT_MIN').AsFloat := StrToFloat(l_height_min.Text);
    ParamByName('ALTITUDE_MAX').AsFloat := StrToFloat(l_alt_max.Text);
  end;

  q_insert_alarm.ExecSQL;
  q_get_alarm_only_hcbu.Refresh();

  AZZERA_TUTTO;

end;

procedure TANAALARM_F.bb_updateClick(Sender: TObject);
begin
  // aggiorna parametri UPDATE QUERY

  with q_update_alarm do
  begin
    ParamByName('MARCHE').AsString := MARCHE_SELECTED;
    ParamByName('GTOT_MIN').AsFloat := StrToFloat(l_gtot_min.Text);
    ParamByName('GTOT_MAX').AsFloat := StrToFloat(l_gtot_max.Text);
    ParamByName('IAS_MAX').AsFloat := StrToFloat(l_ias_max.Text);
    ParamByName('VSI_MAX').AsFloat := StrToFloat(l_vsi_max.Text);
    ParamByName('PITCH_MAX').AsFloat := StrToFloat(l_pitch_max.Text);
    ParamByName('ROLL_MAX').AsFloat := StrToFloat(l_roll_max.Text);
    ParamByName('HEIGHT_MIN').AsFloat := StrToFloat(l_height_min.Text);
    ParamByName('ALTITUDE_MAX').AsFloat := StrToFloat(l_alt_max.Text);
  end;
  q_update_alarm.ExecSQL;

  q_get_alarm_only_hcbu.Refresh();

  AZZERA_TUTTO;
end;

procedure TANAALARM_F.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  q_get_alarm_only_hcbu.close();
end;

procedure TANAALARM_F.FormShow(Sender: TObject);
begin
  q_get_alarm_only_hcbu.Open();
end;

procedure TANAALARM_F.rDBGrid1DblClick(Sender: TObject);
begin
  // CARICA TUTTI I PARAMETRI D'ALLARME NEI CAMPI EDIT

  bb_update.Enabled := true;
  bb_insert.Enabled := false;
  l_ias_max.Text := rDBGrid1.DataSource.DataSet.FieldByName('IAS_MAX').AsString;
  l_vsi_max.Text := rDBGrid1.DataSource.DataSet.FieldByName('VSI_MAX').AsString;
  l_pitch_max.Text := rDBGrid1.DataSource.DataSet.FieldByName
    ('PITCH_MAX').AsString;
  l_roll_max.Text := rDBGrid1.DataSource.DataSet.FieldByName
    ('ROLL_MAX').AsString;
  l_gtot_min.Text := rDBGrid1.DataSource.DataSet.FieldByName
    ('GTOT_MIN').AsString;
  l_gtot_max.Text := rDBGrid1.DataSource.DataSet.FieldByName
    ('GTOT_MAX').AsString;
  l_alt_max.Text := rDBGrid1.DataSource.DataSet.FieldByName
    ('ALTITUDE_MAX').AsString;
  l_height_min.Text := rDBGrid1.DataSource.DataSet.FieldByName
    ('HEIGHT_MIN').AsString;
  MARCHE_SELECTED := rDBGrid1.DataSource.DataSet.FieldByName('MARCHE').AsString;

end;

end.
