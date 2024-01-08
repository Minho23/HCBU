unit BROADCAST_U;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.CheckLst,
  Vcl.ControlList, Vcl.Buttons, Vcl.ComCtrls, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.ExtCtrls, Vcl.Grids,
  rdlg;

procedure check_mqtt();
procedure decode_mqtt_msg(ATopic, msg: string);

type
  TBROADCAST_F = class(TForm)
    gb_message: TGroupBox;
    gb_aero: TGroupBox;
    gb_ack: TGroupBox;
    clb_aircraft: TCheckListBox;
    e_message: TEdit;
    bb_send_message: TBitBtn;
    q_read_aero: TFDQuery;
    list_ack: TListView;
    qr_history: TGroupBox;
    m_history: TMemo;
    q_get_history_message: TFDQuery;
    sb1: TStatusBar;
    sbt_connect: TSpeedButton;
    procedure FormShow(Sender: TObject);
    procedure bb_send_messageClick(Sender: TObject);
    procedure sbt_connectClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);

  private
    { Private declarations }
  public
    { Public declarations }

  end;

var
  BROADCAST_F: TBROADCAST_F;

implementation

uses Main;

{$R *.dfm}

procedure decode_mqtt_msg(ATopic, msg: string);
begin
  BROADCAST_F.m_history.Lines.Append('MESSAGGIO IN ARRIVO');
  BROADCAST_F.m_history.Lines.Append(msg);
  BROADCAST_F.m_history.Lines.Append('');
end;

procedure ScrollToBottom(Memo: TMemo);
begin
  if Memo.Lines.Count > 0 then
  begin
    Memo.Perform(EM_LINESCROLL, 0, Memo.Lines.Count);
  end;
end;

procedure check_mqtt();
begin

  if not PRINCIPALE.mqc.IsConnected then
  begin
    BROADCAST_F.bb_send_message.Enabled := false;
    BROADCAST_F.sbt_connect.Enabled := True;
    BROADCAST_F.sb1.Panels[0].Text := 'Offline';
  end
  else
  begin
    BROADCAST_F.bb_send_message.Enabled := True;
    BROADCAST_F.sbt_connect.Enabled := false;
    BROADCAST_F.sb1.Panels[0].Text := 'Online';
  end;
end;

procedure ClearAll();
begin
  with BROADCAST_F do
  begin
    BROADCAST_F.sb1.Panels[0].Text := 'Status connection';
    clb_aircraft.Items.Clear;
    list_ack.Items.Clear;
    e_message.Clear;
    m_history.Clear;
  end;
end;

procedure AggiungiElemento(const MarcaAereo: string);
var
  NuovoElemento: TListItem;
begin
  with BROADCAST_F do
  begin

    NuovoElemento := list_ack.Items.Add;
    NuovoElemento.Caption := MarcaAereo;
    // Puoi aggiungere ulteriori sottocolonne se necessario:
    // NuovoElemento.SubItems.Add('AltroDato');
  end;

end;

procedure TBROADCAST_F.bb_send_messageClick(Sender: TObject);
var
  i: Integer;
  b: Boolean;

begin

  if PRINCIPALE.mqc.IsConnected then

    if e_message.Text = '' then

    begin
      DlgE('Input text message is empty.');
      exit;
    end;

  with PRINCIPALE do
  begin
    b := false;

    for i := 0 to clb_aircraft.Items.Count - 1 do
    begin

      // Se ci sono sottocolonne, puoi accedere a esse utilizzando SubItems
      if clb_aircraft.Checked[i] then
      begin
        mqc.Publish(clb_aircraft.Items[i] + '/B', e_message.Text);
        b := True;

        m_history.Lines.Append(datetimetostr(now));
        m_history.Lines.Append(clb_aircraft.Items[i]);
        m_history.Lines.Append(e_message.Text);
        m_history.Lines.Append('');

      end;

    end;

    if b then
      DlgI('Sent broadcast message to checked aircrafts.')
    else
      DlgI('No aircraft selected.');

    e_message.Clear;

  end;

end;

function GetUTCNow: TDateTime;
var
  SystemTime: TSystemTime;
begin
  GetSystemTime(SystemTime);
  Result := SystemTimeToDateTime(SystemTime);
end;

procedure TBROADCAST_F.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  PRINCIPALE.mqc.Disconnect;
end;

procedure TBROADCAST_F.FormShow(Sender: TObject);
var
  DataOdiernaUTC: TDateTime;
  Giorno: Word;
  Mese: Word;
  Anno: Word;
begin

  ClearAll;
  check_mqtt;

  q_read_aero.open();
  while not q_read_aero.Eof do
  begin
    clb_aircraft.Items.Add(q_read_aero['MARCHE']);
    AggiungiElemento(q_read_aero['MARCHE']);
    q_read_aero.Next;
  end;
  q_read_aero.close();

  DataOdiernaUTC := GetUTCNow;

  // Estrai giorno, mese, anno, ora, minuto, secondo e millisecondo dalla data UTC
  DecodeDate(DataOdiernaUTC, Anno, Mese, Giorno);

  // ShowMessage('DATA: ' + DateToStr(DataOdiernaUTC));

  with q_get_history_message do
  begin
    close;
    ParamByName('DAY').AsInteger := Giorno;
    ParamByName('MONTH').AsInteger := Mese;
    ParamByName('YEAR').AsInteger := Anno;
    open;

  end;

  if q_get_history_message.RecordCount = 0 then
    exit;

  // ShowMessage('record count: ' + inttostr(q_get_history_message.RecordCount));

  while not q_get_history_message.Eof do
  begin

    m_history.Lines.Add(q_get_history_message['DATETIME_MESSAGE']);
    m_history.Lines.Append(q_get_history_message['MARCHE']);
    m_history.Lines.Append(q_get_history_message['PAYLOAD_ALFA']);
    m_history.Lines.Append('');
    q_get_history_message.Next;
  end;
  q_get_history_message.close();

  ScrollToBottom(m_history);

end;

procedure TBROADCAST_F.sbt_connectClick(Sender: TObject);
begin
  TYPE_OF_CONNECTION := 2;
  connect_mqtt;

end;

end.
