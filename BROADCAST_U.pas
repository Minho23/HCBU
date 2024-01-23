unit BROADCAST_U;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.AnsiStrings,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.CheckLst,
  Vcl.ControlList, Vcl.Buttons, Vcl.ComCtrls, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.ExtCtrls, Vcl.Grids,
  rdlg;

procedure check_mqtt();
procedure decode_mqtt_msg(ATopic, msg: string);
procedure AggiungiElemento(const MarcaAereo: string);

type
  TBROADCAST_F = class(TForm)
    gb_message: TGroupBox;
    gb_aero: TGroupBox;
    gb_ack: TGroupBox;
    clb_aircraft: TCheckListBox;
    bb_send_message: TBitBtn;
    list_ack: TListView;
    qr_history: TGroupBox;
    m_history: TMemo;
    q_get_history_message: TFDQuery;
    sb1: TStatusBar;
    sbt_connect: TSpeedButton;
    e_message: TMemo;
    p_title: TPanel;
    procedure FormShow(Sender: TObject);
    procedure bb_send_messageClick(Sender: TObject);
    procedure sbt_connectClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure sb1DrawPanel(StatusBar: TStatusBar; Panel: TStatusPanel;
      const Rect: TRect);

  private
    { Private declarations }
  public
    { Public declarations }

  end;

var
  BROADCAST_F: TBROADCAST_F;
  panelcolor_sb: tcolor;

implementation

uses Main;

{$R *.dfm}

procedure set_ack(marca: string);
var
  ListItem: TListItem;

begin

  ListItem := BROADCAST_F.list_ack.FindCaption(0, marca, False, True, False);
  ListItem.SubItems[0] := 'ACK';
end;

procedure decode_mqtt_msg(ATopic, msg: string);
var
  ind_sep: Integer;
  last_let, marca: String;

begin

  ind_sep := Pos('/', ATopic);

  if ind_sep > 0 then
  begin
    msg := trim(msg);
    marca := Copy(ATopic, 1, ind_sep - 1);
    last_let := Copy(ATopic, ind_sep + 1, 1);

    case IndexStr(last_let, ['Z', 'B']) of

      // TOPIC Z
      0:
        begin
          case strtoint(msg) of

            // NON CONNESSO
            0:
              begin
                // ShowMessage('RICEVUTO Z 0 PER: ' + marca);
                // ShowMessage
                // (inttostr(BROADCAST_F.clb_aircraft.Items.IndexOf(marca)));
                BROADCAST_F.clb_aircraft.ItemEnabled
                  [BROADCAST_F.clb_aircraft.Items.IndexOf(marca)] := False;

              end;

            // CONNESSO
            1:
              BROADCAST_F.clb_aircraft.ItemEnabled
                [BROADCAST_F.clb_aircraft.Items.IndexOf(marca)] := True;
          end;
        end;

      // TOPIC B
      1:
        begin

          if msg = '$1' then
          begin

            BROADCAST_U.set_ack(marca);
          end;

        end;

    end;
  end;

end;

// SCROLLO COMPLETAMENTE IL MEMO HISTORY
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
    BROADCAST_F.bb_send_message.Enabled := False;
    BROADCAST_F.sbt_connect.Enabled := True;
    BROADCAST_F.sb1.Panels[0].Text := 'Offline';

    panelcolor_sb := clRed;
    BROADCAST_F.sb1.Canvas.Font.Color := panelcolor_sb;

  end
  else
  begin
    BROADCAST_F.bb_send_message.Enabled := True;
    BROADCAST_F.sbt_connect.Enabled := False;
    BROADCAST_F.sb1.Panels[0].Text := 'Online';

    panelcolor_sb := clGreen;
    BROADCAST_F.sb1.Canvas.Font.Color := panelcolor_sb;
  end;
end;

procedure ClearAll();
begin
  with BROADCAST_F do
  begin
    BROADCAST_F.sb1.Panels[0].Text := 'Status connection';

    panelcolor_sb := clBlack;
    BROADCAST_F.sb1.Canvas.Font.Color := panelcolor_sb;

    // clb_aircraft.Items.Clear;
    // list_ack.Items.Clear;
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
    NuovoElemento.SubItems.Add('');
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
    b := False;

    for i := 0 to clb_aircraft.Items.Count - 1 do
    begin

      // INVIO A TUTTE LE MARCHE CHECKATE E ONLINE
      if clb_aircraft.Checked[i] and clb_aircraft.ItemEnabled[i] then
      begin
        mqc.Publish(clb_aircraft.Items[i] + '/B', e_message.Text);
        b := True;

        // INSERISCO NEL MEMO DELLA HISTORY IL CAMPO MESSAGGIO
        m_history.Lines.Append(Datetimetostr(now));
        m_history.Lines.Append(clb_aircraft.Items[i]);
        m_history.Lines.Append(e_message.Text);
        m_history.Lines.Append('');

      end;

    end;

    if b then
    begin
      DlgI('Sent broadcast message to checked aircrafts.');
      // CANCELLO TESTO DEL MESSAGGIO
      e_message.Clear;

      // AZZERO CAMPO ACK NELLA TLISTVIEW
      for i := 0 to list_ack.Items.Count - 1 do
      begin
        // Azzera il valore nella seconda colonna (indice 1)
        list_ack.Items[i].SubItems[0] := '';
      end;
    end
    else
      DlgI('No aircraft selected.');

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

  // q_get_aero_with_bb.open();
  // while not q_get_aero_with_bb.Eof do
  // begin
  // clb_aircraft.Items.Add(q_get_aero_with_bb['MARCHE']);
  // AggiungiElemento(q_get_aero_with_bb['MARCHE']);
  // q_get_aero_with_bb.Next;
  // end;
  // q_get_aero_with_bb.close();

  DataOdiernaUTC := GetUTCNow;

  // Estrai giorno, mese, anno, ora, minuto, secondo e millisecondo dalla data UTC
  DecodeDate(DataOdiernaUTC, Anno, Mese, Giorno);

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

  // GET DELLO STORICO MESSAGGI BROADCAST DELLA GIORNATA ODIERNA
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

procedure TBROADCAST_F.sb1DrawPanel(StatusBar: TStatusBar; Panel: TStatusPanel;
  const Rect: TRect);
begin
  if (Panel = StatusBar.Panels[0]) then
  begin
    with sb1 do
    begin
      Canvas.Font.Color := panelcolor_sb;
      Canvas.TextOut(Rect.Left + 5, Rect.Top - 2, Panel.Text);
    end;
  end;
end;

procedure TBROADCAST_F.sbt_connectClick(Sender: TObject);
begin
  // SET DELLA VARIABILE GLOBALE CONDIVISA CON UNIT MAIN PER GESTIRE DIFFERENTEMENTE LE CALLBACK
  // MQTT A SECONDA DEL TIPO DI CONNESSIONE
  // CONNESSIONE 1: CONNESSIONE ONE TO ONE SELEZIONANDO LA MARCA NELLA FORM PRINCIPALE
  // CONNESSIONE 2: CONNESSIONE GENERICA DIRETTAMENTE NELLA FORM DEL CANALE BROADCAST
  TYPE_OF_CONNECTION := 2;
  connect_mqtt;

end;

end.
