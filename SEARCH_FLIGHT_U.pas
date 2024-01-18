unit SEARCH_FLIGHT_U;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.DateUtils,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, Vcl.DBGrids,
  rDBGrid, Vcl.StdCtrls, Vcl.Buttons, Vcl.WinXPickers, Vcl.ExtCtrls,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  rdlg;

type
  TSEARCH_FLIGHT_F = class(TForm)
    p_title: TPanel;
    grb_date: TGroupBox;
    grb_list: TGroupBox;
    dp1: TDatePicker;
    bt_search: TBitBtn;
    rDBGrid1: TrDBGrid;
    q_get_flight: TFDQuery;
    l_aero: TLabel;
    ds_flight: TDataSource;
    procedure bt_searchClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure rDBGrid1DblClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SEARCH_FLIGHT_F: TSEARCH_FLIGHT_F;

implementation

{$R *.dfm}

uses
  Main, FLIGHT_SELECT_U;

procedure TSEARCH_FLIGHT_F.bt_searchClick(Sender: TObject);
var
  selectedDate: TDate;
  day: Word;
begin

  selectedDate := dp1.Date;

  with q_get_flight do
  begin
    Close;
    ParamByName('MARCA_P').AsString := PRINCIPALE.etopic.Text;
    ParamByName('DAY_P').AsInteger := dayof(selectedDate);
    ParamByName('MONTH_P').AsInteger := monthof(selectedDate);
    ParamByName('YEAR_P').AsInteger := yearof(selectedDate);
    Open;
  end;

  if (q_get_flight.RecordCount = 0) then
  begin
    dlgi('No flights available for the selected day.');

  end;
end;

procedure TSEARCH_FLIGHT_F.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  q_get_flight.Close;
end;

procedure TSEARCH_FLIGHT_F.FormShow(Sender: TObject);
begin
  dp1.Date := now;
  l_aero.Caption := PRINCIPALE.etopic.Text;
end;

procedure TSEARCH_FLIGHT_F.rDBGrid1DblClick(Sender: TObject);
begin

  CLICK_FOR_REPLAY := true;
  with FLIGHT_SELECT_F.q_select do
  begin
    Close;
    ParamByName('DATE_START').AsDatetime := ds_flight.DataSet.FieldByName
      ('min_datetime').AsDatetime;

    ParamByName('DATE_END').AsDatetime := ds_flight.DataSet.FieldByName
      ('max_datetime').AsDatetime;

    ParamByName('MARCHE').AsString := PRINCIPALE.etopic.Text;
    Open;
  end;

  SEARCH_FLIGHT_F.Close;

end;

end.