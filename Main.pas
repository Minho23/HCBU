unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Types,
  System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, rImprovedComps,
  Vcl.ExtCtrls, Vcl.OleCtrls, SHDocVw, SG.ScriptGate, DateUtils,
  TMS.MQTT.Global,
  TMS.MQTT.Client, Vcl.Buttons, Vcl.ComCtrls, rdlg, StrUtils, Vcl.Grids,
  System.Win.Registry, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, rStringGridEd, Vcl.Menus, Vcl.Mask,
  FireDAC.UI.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Phys,
  FireDAC.VCLUI.Wait;

function GetRegistryValue(KeyName: string): string;

type
  TPRINCIPALE = class(TForm)
    db0: TFDTransaction;
    cn1: TFDConnection;
    q_read_aero: TFDQuery;
    wb1: TWebBrowser;
    wb2: TWebBrowser;
    wb3: TWebBrowser;
    rGroupBox1: TrGroupBox;
    etopic: TrComboBoxEx;
    Label1: TLabel;
    mqc: TTMSMQTTClient;
    bt_connect: TBitBtn;
    memo_send: TMemo;
    bt_send: TBitBtn;
    rg_channel: TRadioGroup;
    cb_server: TCheckBox;
    sb1: TStatusBar;
    r: TrMemoEx;
    SG: TStringGrid;
    rGroupBox2: TrGroupBox;
    rGroupBox3: TrGroupBox;
    rGroupBox4: TrGroupBox;
    rGroupBox5: TrGroupBox;
    bt_replay: TBitBtn;
    bt_chart: TBitBtn;
    rg_vcr: TrGroupBox;
    bt_fast_rewind: TBitBtn;
    bt_rewind: TBitBtn;
    bt_play_pause: TBitBtn;
    bt_forward: TBitBtn;
    bt_fast_forward: TBitBtn;
    bt_stop: TBitBtn;
    tb_delay: TTrackBar;
    pb1: TProgressBar;
    bt_disconnect: TBitBtn;
    bt_cursor: TBitBtn;
    MainMenu1: TMainMenu;
    ListALarmEvent1: TMenuItem;
    ManageAlarmParameters1: TMenuItem;
    Abput1: TMenuItem;
    q_get_alarms: TFDQuery;
    bt_update_conn: TBitBtn;
    N1: TMenuItem;
    N2: TMenuItem;
    Visualize1: TMenuItem;
    N3: TMenuItem;
    wb_efis: TWebBrowser;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure sb1DrawPanel(StatusBar: TStatusBar; Panel: TStatusPanel;
      const Rect: TRect);
    procedure bt_connectClick(Sender: TObject);
    procedure mqcConnectedStatusChanged(ASender: TObject;
      const AConnected: Boolean; AStatus: TTMSMQTTConnectionStatus);
    procedure bt_sendClick(Sender: TObject);
    procedure mqcPublishReceivedEx(ASender: TObject; APacketID: Word;
      ATopic: string; APayload: TTMSMQTTBytes);
    procedure bt_replayClick(Sender: TObject);
    procedure bt_chartClick(Sender: TObject);
    procedure bt_stopClick(Sender: TObject);
    procedure bt_rewindClick(Sender: TObject);
    procedure bt_fast_rewindClick(Sender: TObject);
    procedure bt_fast_forwardClick(Sender: TObject);
    procedure tb_delayChange(Sender: TObject);
    procedure bt_forwardClick(Sender: TObject);
    procedure bt_play_pauseClick(Sender: TObject);
    procedure bt_disconnectClick(Sender: TObject);
    procedure sgDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect;
      State: TGridDrawState);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure bt_cursorClick(Sender: TObject);
    procedure bt_update_connClick(Sender: TObject);
    procedure Visualize1Click(Sender: TObject);

  private
  var
    FScriptGate: TScriptGate;
    FScriptGate2: TScriptGate;
    FScriptGate3: TScriptGate;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  PRINCIPALE: TPRINCIPALE;
  box_connected: Boolean;
  old_box_connected: String;
  tx, ty: string;
  pp: string;
  gps_msg: TStringDynArray;
  gyro_msg: array [0 .. 6] of string;
  baro_msg: TStringDynArray;
  vsi_msg: TStringDynArray;
  appo_single: single;
  slat_s, slon_s: string;
  vsi_index: Integer;
  vsi_alt: array [1 .. 2] of Integer;
  vsi_time: array [1 .. 2] of tdatetime;
  h_x_baro_s: string;
  panelcolor0, panelcolor1, panelcolor2: tcolor;
  g_max, g_min: double;
  ddelay: Integer;
  play_or_pause: string;
  REP_OR_CHART: string;
  Xgps_ias: array of double;
  Ygps_ias: array of double;
  Count_gps_ias, index_gps_ias: Integer;
  Xgps_ALT: array of double;
  Ygps_ALT: array of double;
  Count_gps_ALT, index_gps_ALT: Integer;
  Xgps_VSI: array [1 .. 10000] of double;
  Ygps_VSI: array [1 .. 10000] of double;
  Count_gps_VSI, index_gps_VSI: Integer;
  Xc_pitch: array [1 .. 10000] of double;
  Yc_pitch: array [1 .. 10000] of double;
  Count_c_pitch, index_c_pitch: Integer;
  Xc_roll: array of double;
  Yc_roll: array of double;
  Count_c_roll, index_c_roll: Integer;
  Xc_g: array of double;
  Yc_g: array of double;
  Count_c_g, index_c_g: Integer;
  elevation, height_i: Integer;
  date_X: tdate;
  time_x: ttime;
  subtopic: string;

  datetime_x, datetime_gps: tdatetime;
  fs: TFormatSettings;

  EXEPATH: string;
  launcher_ok: bool;

  connected: string;
  LastRow, LastCol: Integer;

var
  VCC_MIN, VCC_MAX, ICC_MIN, ICC_MAX, TINT_MIN, TINT_MAX, GTOT_MIN, GTOT_MAX,
    IAS_MAX, VSI_MAX, PITCH_MAX, ROLL_MAX, HEIGHT_MIN, ALTITUDE_MAX: double;

  alarm_table_present: bool;
  red_color: bool;
  vcc_alarm, icc_alarm, tint_alarm, gtot_alarm, ias_alarm, vsi_alarm,
    pitch_alarm, roll_alarm, height_alarm, altitude_alarm: bool;

const
  Komma: TFormatSettings = (DecimalSeparator: ',');
  Dot: TFormatSettings = (DecimalSeparator: '.');
  vcc_col = 1;
  vcc_row = 1;
  icc_col = 2;
  icc_row = 1;
  tint_col = 1;
  tint_row = 2;
  test_col = 2;
  test_row = 2;
  hdg_col = 1;
  hdg_row = 3;
  gtot_col = 1;
  gtot_row = 4;
  gmin_col = 2;
  gmin_row = 4;
  gmax_col = 3;
  gmax_row = 4;
  gs_col = 1;
  gs_row = 5;
  vsi_col = 1;
  vsi_row = 6;
  mbar_col = 1;
  mbar_row = 7;
  baro_ft_col = 1;
  baro_ft_row = 8;
  gps_ft_col = 2;
  gps_ft_row = 8;
  utc_date_col = 1;
  utc_date_row = 9;
  utc_time_col = 1;
  utc_time_row = 9;
  dbm_col = 1;
  dbm_row = 10;
  signal_col = 2;
  signal_row = 10;
  pitch_col = 1;
  pitch_row = 11;
  roll_col = 2;
  roll_row = 11;
  gacc_row = 12;
  height_col = 1;
  height_row = 13;
  connected_col = 1;
  connected_row = 14;
  turnrate_col = 1;
  turnrate_row = 15;
  co_col = 1;
  co_row = 16;
  take_land_col = 1;
  take_land_row = 17;
  alarm_col = 4;

var // EDIT DANIELE
  eclient_id: string;
  done_landing, done_takeoff: bool;
  old_sec_land, cont_for_land: Integer;
  first_ele_minor: Integer;
  takeoff_past, landing_past: bool;
  ias_kts_int: Integer;

const // EDIT DANIELE

  theshold_ele_to = 40; // ft
  theshold_speed_to = 50; // kts
  theshold_sec_land = 15; // secondi
  theshold_ele_land = 40; // ft

implementation

uses login_u, FLIGHT_SELECT_U, CHART_U, SPLASH_U;

{$R *.dfm}

procedure RESET_ALARM;
begin
  vcc_alarm := false;
  icc_alarm := false;
  tint_alarm := false;
  gtot_alarm := false;

  ias_alarm := false;
  vsi_alarm := false;
  pitch_alarm := false;
  roll_alarm := false;
  height_alarm := false;
  altitude_alarm := false;
end;

function is_landing(ele: Integer): Boolean;

var
  now_sec_land: Integer;

begin
  Result := false;

  if (ele < theshold_ele_land) then
  begin

    // ShowMessage('ELEVATION TROPPO BASSA');
    if (first_ele_minor = 0) then
    begin
      // ShowMessage('PRIMO ELE BASSO');
      first_ele_minor := 1;
      old_sec_land := DateTimeToUnix(now());

      exit;

    end;
    now_sec_land := DateTimeToUnix(now());

    cont_for_land := cont_for_land + (now_sec_land - old_sec_land);

    // ShowMessage('cont for land: ' + inttostr(cont_for_land));
    if (cont_for_land > theshold_sec_land) then
    begin

      // ShowMessage('done landing');

      done_landing := true;

      cont_for_land := 0;
      first_ele_minor := 0;
    end
    else
    begin
      done_landing := false;
      old_sec_land := now_sec_land;

    end;

    Result := done_landing;
  end
  else
    exit;

end;

function is_takeoff(ele, speed: Integer): Boolean;
begin

  // ShowMessage('ele take off: ' + inttostr(ele));

  if (ele > theshold_ele_to) and (speed > theshold_speed_to) then
  begin
    done_takeoff := true;

  end
  else
    done_takeoff := false;

  Result := done_takeoff;

end;

function check_if_is_alarm(dato: double; typeof_data: Integer): Boolean;

begin
  // DATI GLI ALLARMI SALVATI IN MEMORIA VERIFICA CHE IL DATO SIA NEL RANGE D'ALLARME O NO
  { A PARTIRE DAL CODICE DATO IN ARRIVO DA MQTT, VERIFICO SE IL DATO SIA ALL'INTERNO O NO DEL RANGE RELATIVO
  }

  with PRINCIPALE do
  begin

    Result := false;

    case typeof_data of

      0: // VCC

        if ((dato < VCC_MIN) or (dato > VCC_MAX)) then
          vcc_alarm := true
        else
          vcc_alarm := false;

      1: // ICC

        if ((dato < ICC_MIN) or (dato > ICC_MAX)) then

          icc_alarm := true
        else
          icc_alarm := false;

      2: // TINT

        if ((dato < TINT_MIN) or (dato > TINT_MAX)) then

          tint_alarm := true
        else
          tint_alarm := false;

      3: // PITCH
        if (abs(dato) > PITCH_MAX) then
          pitch_alarm := true
        else
          pitch_alarm := false;
      4: // ROLL

        if (abs(dato) > ROLL_MAX) then

          roll_alarm := true
        else
          roll_alarm := false;

      5: // ACC TOT

        if ((dato < GTOT_MIN) or (dato > GTOT_MAX)) then

          gtot_alarm := true
        else
          gtot_alarm := false;

      6: // GPS : ALTITUDE

        if (dato > ALTITUDE_MAX) then // ALT

          altitude_alarm := true
        else
          altitude_alarm := false;

      7: // GPS :  IAS

        if (dato > IAS_MAX) then // IAS

          ias_alarm := true
        else
          ias_alarm := false;

      8: // HEIGHT

        if (dato < HEIGHT_MIN) then

          height_alarm := true
        else
          height_alarm := false;

      9: // VSI

        if (abs(dato) > VSI_MAX) then

          vsi_alarm := true
        else
          vsi_alarm := false;

    else
      begin
        Dlge('Type of data not valid.');
        exit;
      end;
    end;

  end;

end;

procedure get_alarm(marche_param: String);
begin

  // AVVIA QUERY SUL DB PER PRENDERE TUTTI GLI ALLARMI E SALVARLI IN MEMORIA
  // DATI: VARIABILI GLOBALI PER OGNI TIPOLOGIA D'ALLARME
  // SELECT DAL DB PER SALVARE NELLE VARIABILI GLOBALI

  with PRINCIPALE do
  begin
    with q_get_alarms do
    begin
      close;
      ParamByName('MARCHE').AsString := trim(marche_param);
      open;
    end;

    alarm_table_present := false;
    if q_get_alarms.RecordCount = 1 then
    begin
      alarm_table_present := true;
      VCC_MIN := q_get_alarms['VCC_MIN'];
      VCC_MAX := q_get_alarms['VCC_MAX'];
      ICC_MIN := q_get_alarms['ICC_MIN'];
      ICC_MAX := q_get_alarms['ICC_MAX'];
      TINT_MIN := q_get_alarms['TINT_MIN'];
      TINT_MAX := q_get_alarms['TINT_MAX'];
      GTOT_MIN := q_get_alarms['GTOT_MIN'];
      GTOT_MAX := q_get_alarms['GTOT_MAX'];
      IAS_MAX := q_get_alarms['IAS_MAX'];
      VSI_MAX := q_get_alarms['VSI_MAX'];
      PITCH_MAX := q_get_alarms['PITCH_MAX'];
      ROLL_MAX := q_get_alarms['ROLL_MAX'];
      HEIGHT_MIN := q_get_alarms['HEIGHT_MIN'];
      ALTITUDE_MAX := q_get_alarms['ALTITUDE_MAX'];
    end
    else
    begin
      Dlge('Alarm data for ' + marche_param + ' not present.');

    end;
    q_get_alarms.close;

  end;
end;

procedure check_alarm(value_s: string; alarm_index: Integer);
var
  value_f: double;
begin
  if alarm_table_present then
  begin

    try
      value_s := StringReplace(value_s, '.', ',', [rfReplaceAll]);

      value_f := strtofloat(value_s);
    except
      on e: exception do
      begin
        value_f := 0;
        // showmessage(e.Message);
      end;
    end;

    if alarm_index in [3, 4] then
    begin
      value_f := abs(value_f);
    end;
    try

      if check_if_is_alarm(value_f, alarm_index) then
      begin
        red_color := true;
      end
      else
        red_color := false;

    except
      on e: exception do
        // showmessage('check alarm error');
    end;
  end;
end;

procedure UnselectGridCell(aGrid: TStringGrid);
var
  GridSel: TGridRect;
begin
  GridSel.Top := -1;
  GridSel.Left := -1;
  GridSel.Bottom := -1;
  GridSel.Right := -1;
  aGrid.Selection := GridSel;
end; { UnselectGridCell }

procedure AFTER_CONNECT;
begin
  with PRINCIPALE do
  begin
    bt_connect.Enabled := false;
    bt_replay.Enabled := false;
    bt_chart.Enabled := false;
    bt_send.Enabled := true;
    bt_disconnect.Enabled := true;
    etopic.Enabled := false;
    r.Lines.Clear();

    FScriptGate.CallScript('reset_map()',
      procedure(const iResult: String)
      begin
        // showmessage(iResult);

      end);

  end;
end;

procedure AFTER_DISCONNECT;
begin
  with PRINCIPALE do
  begin
    bt_connect.Enabled := true;
    bt_replay.Enabled := true;
    bt_chart.Enabled := true;
    bt_send.Enabled := false;
    bt_disconnect.Enabled := false;

    etopic.Enabled := true;

    sb1.Panels[1].Text := '----';
    sb1.Panels[2].Text := '----';

  end;
end;

procedure AFTER_REPLAY;
begin
  with PRINCIPALE do
  begin
    bt_connect.Enabled := false;
    bt_replay.Enabled := false;
    bt_chart.Enabled := false;
    bt_send.Enabled := false;
    bt_disconnect.Enabled := false;

    etopic.Enabled := false;

    r.Lines.Clear();

    FScriptGate.CallScript('reset_map()',
      procedure(const iResult: String)
      begin
        // showmessage(iResult);

      end);

  end;
end;

procedure AFTER_CHART;
begin
  with PRINCIPALE do
  begin
    bt_connect.Enabled := false;
    bt_replay.Enabled := false;
    bt_chart.Enabled := false;
    bt_send.Enabled := false;
    bt_disconnect.Enabled := false;
  end;
end;

function GetRegistryValue(KeyName: string): string;
var
  Registry: TRegistry;
begin
  Registry := TRegistry.Create(KEY_READ);
  try
    Registry.RootKey := HKEY_LOCAL_MACHINE;

    // False because we do not want to create it if it doesn't exist
    Registry.OpenKey(KeyName, false);

    Result := Registry.ReadString('MachineGuid');
  finally
    Registry.Free;
  end;
end;

procedure AZZERA_SG;
var
  col, row: Integer;
begin
  LastRow := -1;
  with PRINCIPALE do

  begin
    for col := 1 to SG.ColCount - 1 do
    begin
      for row := 1 to SG.RowCount do
        SG.Cells[col, row] := '';

    end;
  end;
end;

procedure vsi(m: string);
var
  vsi_feet: single;
begin

  // if pos('@',m)>0 then begin
  {
    vsi_msg:=SplitString(m,'@');  // deltafeet , deltatime in millseconds
    vsi_msg[0]:=StringReplace(vsi_msg[0],'.',',',[rfReplaceAll]);
    vsi_msg[1]:=StringReplace(vsi_msg[1],'.',',',[rfReplaceAll]);

    try
    delta_feet:= strtofloat(vsi_msg[0],dot) ;
    except
    on e:Exception do
    delta_feet:=0;
    end;

    try
    delta_seconds:= strtofloat(vsi_msg[1],dot) ;
    except
    on e:Exception do
    delta_seconds:=1; // 1000 millisecondi, ovvero un secondo
    end;




    try
    vsi_feet:=(delta_feet/delta_seconds)*-60; // piedi al minuto
    except
    on e:Exception do
    vsi_feet:=0; // 1000 millisecondi, ovvero un secondo
    end;

  }

  try
    vsi_feet := strtofloat(m, Dot) * 60;
  except
    on e: exception do
      vsi_feet := 1;
  end;

  vsi_feet := round(vsi_feet);
  /// // if vsi_feet>1000 then showmessage(floattostr(vsi_feet));

  if REP_OR_CHART = 'CHART' then
  begin

    Xgps_VSI[index_gps_VSI] := datetime_x;

    Ygps_VSI[index_gps_VSI] := vsi_feet;
    /// / showmessage(inttostr(index_gps_VSI)+'   -   '+    floattostr(main.Xgps_VSI[index_gps_VSI])+'  -  '+floattostr(main.Ygps_VSI[index_gps_VSI]));
    inc(index_gps_VSI);

  end
  else
  begin

    check_alarm(inttostr(round(vsi_feet)), 9);
    PRINCIPALE.SG.Cells[vsi_col, vsi_row] := inttostr(round(vsi_feet));
    if vsi_alarm then
      PRINCIPALE.SG.Cells[alarm_col, vsi_row] := inttostr(round(vsi_feet));

    PRINCIPALE.FScriptGate2.CallScript('GetVsi(' + Formatfloat('#####0.0',
      (vsi_feet / 100)) + ')',
      procedure(const iResult: String)
      var
        gg: string;
      begin
        gg := iResult;
        /// ////////// principale.memo_send.lines.append(gg);

      end);
  end;



  // end;

end;

procedure hdg(m: string);

var
  hdg_s: Integer;
begin
  with PRINCIPALE do
  begin
    if length(m) >= 2 then
    begin

      appo_single := strtofloat(m, Dot);

      hdg_s := (round(appo_single));
      PRINCIPALE.FScriptGate2.CallScript('GetHdg(' + inttostr(hdg_s) + ')',
        procedure(const iResult: String)
        var
          gg: string;
        begin
          gg := iResult;
          /// //principale.memo_send.lines.append(gg);

        end);
      if box_connected = true then
        connected := '1'
      else
        connected := '0';

      PRINCIPALE.FScriptGate.CallScript('rot_marker(' + inttostr(hdg_s) + ',' +
        connected + ')',
        procedure(const iResult: String)
        var
          gg: string;
        begin
          gg := iResult;
          /// // principale.r.lines.append('hdg '+gg);

        end);

    end;

  end;
end;

procedure baro_altitude(m: string);
begin
  with PRINCIPALE do
  begin
    m := StringReplace(m, '.', ',', [rfReplaceAll]);
    try
      appo_single := strtofloat(m) * 3.28084;
    except
      appo_single := 0;
    end;

  end;
end;

procedure baro_pressure(m: string);
var
  baro_hpa_s, baro_alt_s, qnh_s: string;

begin
  with PRINCIPALE do
  begin

    baro_msg := SplitString(m, ',');
    try
      baro_alt_s := StringReplace(baro_msg[1], '.', ',', [rfReplaceAll]);
      appo_single := strtofloat(baro_alt_s); // * 3.28084;
      SG.Cells[1, 8] := inttostr(round(appo_single));
      LastRow := 8;
      LastCol := 1;
    except

    end;

    baro_hpa_s := baro_msg[0];
    SG.Cells[1, 7] := baro_hpa_s;
    LastRow := 7;
    LastCol := 1;
    baro_alt_s := h_x_baro_s; // altezza in metri preso dal altitude
    baro_hpa_s := StringReplace(baro_hpa_s, '.', ',', [rfReplaceAll]);

    appo_single := strtofloat(baro_hpa_s) + strtofloat(baro_alt_s) / 8.4;
    qnh_s := floattostr(appo_single, Dot);
    if REP_OR_CHART <> 'CHART' then
    begin

      FScriptGate3.CallScript('Getbaro_hpa(' + baro_hpa_s + ')',
        procedure(const iResult: String)
        var
          gg: string;
        begin
          gg := iResult;
          /// ///principale.memo_send.Lines.Append(gg);
        end);

    end;

  end;
end;

procedure magn_heading(m: string);
var
  magn_s, delta_s: string;
var
  appo_int: Integer;
begin
  with PRINCIPALE do
  begin
    delta_s := m;
    magn_s := StringReplace(m, '.', ',', [rfReplaceAll]);
    try
      appo_single := strtofloat(magn_s);
    except
      appo_single := 0;
    end;
    appo_int := round(appo_single);

    LastRow := 3;
    LastCol := 1;

    if (appo_int >= -180) and (appo_int <= 0) then
    begin
      appo_int := abs(appo_int);
    end
    else
    begin
      appo_int := 360 - appo_int;
    end;

    if (appo_int >= 0) and (appo_int <= 360) then
      appo_int := appo_int + 180
    else
      appo_int := 0;
    magn_s := inttostr(appo_int);
    // SG.Cells[2, 3] :=magn_s;
    FScriptGate3.CallScript('GetHdg_magn(' + magn_s + ')',
      procedure(const iResult: String)
      var
        gg: string;
      begin
        gg := iResult;
        /// //////// principale.r.Lines.Append(gg);
      end);
    SG.Cells[2, 3] := inttostr(appo_int - 180);
  end;
end;

procedure signal_strength(m: string);
var
  signal, dbm: string;
var
  appo_int: Integer;
begin
  with PRINCIPALE do
  begin

    signal := trim(m);


    // if pos(',',signal)>0 then
    // signal:=LeftStr(signal,1);

    try
      appo_int := strtoint(signal);
    except
      on e: exception do
        appo_int := 0;
    end;

    appo_int := -113 + (2 * appo_int);
    dbm := inttostr(appo_int);
    SG.Cells[1, 10] := '    ';
    SG.Cells[1, 10] := dbm;
    LastRow := 10;
    LastCol := 1;
    SG.Cells[2, 10] := signal;
    LastRow := 10;
    LastCol := 2;
    FScriptGate3.CallScript('GetSignal(' + signal + ',' + dbm + ')',
      procedure(const iResult: String)
      var
        gg: string;
      begin
        gg := iResult;
        /// //////// principale.r.Lines.Append(gg);
      end);

  end;
end;

procedure vcc(m: string);
var
  vcc_s: string;

begin
  with PRINCIPALE do
  begin

    vcc_s := m;

    check_alarm(vcc_s, 0);
    SG.Cells[vcc_col, vcc_row] := vcc_s;
    if vcc_alarm then
      SG.Cells[alarm_col, vcc_row] := vcc_s + 'V';
    application.ProcessMessages;
    FScriptGate3.CallScript('GetVcc(' + vcc_s + ')',
      procedure(const iResult: String)
      var
        gg: string;
      begin
        gg := iResult;

      end);

  end;
end;

procedure Ia(m: string);
var
  ia_s: string;

begin
  with PRINCIPALE do
  begin

    ia_s := m;
    check_alarm(ia_s, 1);
    SG.Cells[icc_col, icc_row] := ia_s;
    if icc_alarm then
      SG.Cells[alarm_col, icc_row] := ia_s + 'mA';
    FScriptGate3.CallScript('GetIa(' + ia_s + ')',
      procedure(const iResult: String)
      var
        gg: string;
      begin
        gg := iResult;

      end);

  end;
end;

procedure gps_altitude(m: string);
var
  ft_amsl_s: string;
begin

  with PRINCIPALE do
  begin
    m := StringReplace(m, '.', ',', [rfReplaceAll]);
    h_x_baro_s := m;
    /// appo_single:= strtofloat(m)*3.28084;
    appo_single := strtofloat(m);

    if (elevation < 0) then
      elevation := 0;

    height_i := round(appo_single - elevation);

    if (height_i < 0) then
      height_i := 0;

    if Not(takeoff_past) then
    begin

      if (is_takeoff(height_i, ias_kts_int)) then
      begin

        // scrivere nella cella se decollato

        SG.Cells[take_land_col, take_land_row] := 'TAKEOFF';
        takeoff_past := true;
        landing_past := false;

      end;
    end;

    if (takeoff_past) then
    begin

      // ShowMessage('takeoff gi� fatto');
      if Not(landing_past) then
      begin
        // ShowMessage('landing ancora non fatto');

        // ShowMessage('height: ' + inttostr(height_i));
        if (is_landing(height_i)) then
        begin
          // ShowMessage('LANDING');
          SG.Cells[take_land_col, take_land_row] := 'LANDING';
          landing_past := true;
          takeoff_past := false;
        end;
      end;
    end;

    ft_amsl_s := inttostr(round(appo_single));

    if REP_OR_CHART = 'CHART' then
    begin

      Xgps_ALT[index_gps_ALT] := datetime_x;

      Ygps_ALT[index_gps_ALT] := round((appo_single));
      inc(index_gps_ALT);

    end;
    check_alarm(ft_amsl_s, 6);
    SG.Cells[gps_ft_col, gps_ft_row] := ft_amsl_s;

    check_alarm(inttostr(height_i), 8);
    SG.Cells[height_col, height_row] := inttostr(height_i);

    /// //////// showmessage(ft_amsl_s);
    FScriptGate2.CallScript('dammi_quota(' + ft_amsl_s + ')',
      procedure(const iResult: String)
      var
        gg: string;
      begin
        gg := iResult;
        /// /principale.memo_send.Lines.Append(gg);
      end);

  end;
end;

procedure gps_ias(m: string);
var
  ias_kts: string;
begin
  with PRINCIPALE do
  begin
    m := StringReplace(m, '.', ',', [rfReplaceAll]);
    if length(m) > 2 then
    begin

      appo_single := strtofloat(m);

      if REP_OR_CHART = 'CHART' then
      begin
        Xgps_ias[index_gps_ias] := datetime_x;
        Ygps_ias[index_gps_ias] := round((appo_single));
        inc(index_gps_ias);

      end
      else if (REP_OR_CHART = 'CONNECT') or (REP_OR_CHART = 'REPLAY') then
      begin

        ias_kts_int := round(appo_single);
        ias_kts := inttostr(round(appo_single));

        check_alarm(ias_kts, 7);
        SG.Cells[gs_col, gs_row] := ias_kts;
        if ias_alarm then
          PRINCIPALE.SG.Cells[alarm_col, gs_row] := ias_kts;

        LastRow := 5;
        LastCol := 1;
        FScriptGate2.CallScript('GetIAS(' + ias_kts + ')',
          procedure(const iResult: String)
          var
            gg: string;
          begin
            gg := iResult;
            /// /principale.memo_send.Lines.Append(gg);
          end);
      end;

    end;

  end;
end;

procedure gyro(m: string);
var
  pitch_s, roll_s: string;
  appoint: Integer;
  acc_x_s, acc_y_s, acc_z_s: string;
  accX: string;
  g_tot, acc_x, acc_y, acc_z: double;

begin
  // dopo modifica
  // gyro_msg:= SplitString(m, ',');
  //
  gyro_msg[0] := copy(m, 1, 4); // pitch
  gyro_msg[1] := copy(m, 5, 4); // roll
  gyro_msg[2] := copy(m, 9, 5); // acc x
  gyro_msg[3] := copy(m, 14, 5); // acc y
  gyro_msg[4] := copy(m, 19, 5); // acc z
  gyro_msg[5] := copy(m, 24, 4); // turnrate
  gyro_msg[6] := copy(m, 28, 4); // gyro global status

  pitch_s := gyro_msg[0];

  try
    appoint := strtoint(pitch_s);
    appoint := appoint * -1;
  except
    on e: exception do
    begin
      appoint := 0;
      PRINCIPALE.r.Lines.add('Pitch Error: ' + pitch_s);
    end;
  end;
  if abs(appoint) > 180 then
    appoint := 0;

  pitch_s := inttostr(appoint);
  // principale.r.Lines.Add('Pitch: '+pitch_s);
  check_alarm(pitch_s, 3);
  PRINCIPALE.SG.Cells[pitch_col, pitch_row] := pitch_s;
  if pitch_alarm then
    PRINCIPALE.SG.Cells[alarm_col, pitch_row] := pitch_s + ' Ptch';

  if REP_OR_CHART = 'CHART' then
  begin

    Xc_pitch[index_c_pitch] := datetime_x;
    Yc_pitch[index_c_pitch] := round(appoint);
    // showmessage(floattostr(main.Xc_pitch[index_c_pitch])+'  -  '+floattostr(main.Yc_pitch[index_c_pitch]));
    inc(index_c_pitch);
  end
  else
  begin
    PRINCIPALE.FScriptGate2.CallScript('GetPitch(' + pitch_s + ')',
      procedure(const iResult: String)
      var
        gg: string;
      begin
        gg := iResult;
        /// / principale.memo_send.Lines.Append(gg);
      end);
  end;

  roll_s := gyro_msg[1];

  try
    appoint := strtoint(roll_s);
  except
    on e: exception do
    begin
      appoint := 0;
      PRINCIPALE.r.Lines.add('Roll Error: ' + roll_s);
    end;
  end;
  if abs(appoint) > 180 then
    appoint := 0;

  check_alarm(roll_s, 4);
  roll_s := inttostr(appoint); // rimosso * -1

  PRINCIPALE.SG.Cells[roll_col, roll_row] := roll_s;
  if roll_alarm then
    PRINCIPALE.SG.Cells[alarm_col, roll_row] := roll_s + ' Roll';
  LastRow := 11;
  LastCol := 2;
  if REP_OR_CHART = 'CHART' then
  begin
    Xc_roll[index_c_roll] := datetime_x;
    Yc_roll[index_c_roll] := round(appoint);
    inc(index_c_roll);
  end
  else
  begin

    PRINCIPALE.FScriptGate2.CallScript('GetRoll(' + roll_s + ')',
      procedure(const iResult: String)
      var
        gg: string;

      begin

        gg := iResult;
        // principale.r.Lines.Append(gg);
      end);
  end;

  acc_x_s := gyro_msg[2];
  accX := acc_x_s;

  acc_x_s := StringReplace(acc_x_s, '.', ',', [rfReplaceAll]);

  acc_y_s := gyro_msg[3];
  acc_y_s := StringReplace(acc_y_s, '.', ',', [rfReplaceAll]);

  acc_z_s := gyro_msg[4];
  acc_z_s := StringReplace(acc_z_s, '.', ',', [rfReplaceAll]);

  try
    acc_x := strtofloat(acc_x_s);
    acc_y := strtofloat(acc_y_s);
    acc_z := strtofloat(acc_z_s);
    g_tot := sqrt(sqr(acc_x) + sqr(acc_y) + sqr(acc_z));

    check_alarm(floattostr(g_tot), 5);
  except
    on e: exception do
    begin
      acc_x := 0.0;
      acc_x_s := '0.0';
      accX := '0.0';
      acc_y := 0.0;
      acc_y_s := '0.0';
      acc_z := 0.0;
      acc_z_s := '0.0';
      g_tot := 0.0;
    end;
  end;

  PRINCIPALE.FScriptGate2.CallScript('GetSlip(' + accX + ')',
    procedure(const iResult: String)
    var
      gg: string;
    begin
      gg := iResult;
      /// //principale.memo_send.Lines.Append(gg);
    end);

  PRINCIPALE.FScriptGate2.CallScript('GetTurn(' + gyro_msg[5] + ')',
    procedure(const iResult: String)
    var
      gg: string;
    begin
      gg := iResult;
      /// //principale.memo_send.Lines.Append(gg);
    end);

  {
    // accendi e spegni i led
    // sulla base dello status di calbirazione
    // sono 4 byte con valore da '0' a '3'
    // 3 = verde   altrimenti rosso


    // system
    if copy(gyro_msg[6],1,1)='3' then
    led_color:='green' else
    if copy(gyro_msg[6],1,1)='2' then
    led_color:='blue' else
    if copy(gyro_msg[6],1,1)='1' then
    led_color:='purple' else
    if copy(gyro_msg[6],1,1)='0' then
    led_color:='red';

    principale.FScriptGate3.CallScript('updateLed(' + 'system,'+led_color + ')',
    procedure(const iResult: String)
    var
    gg: string;
    begin
    gg := iResult;
    /// ///principale.memo_send.Lines.Append(gg);
    end);

    // gyro
    if copy(gyro_msg[6],2,1)='3' then
    led_color:='green' else
    if copy(gyro_msg[6],2,1)='2' then
    led_color:='blue' else
    if copy(gyro_msg[6],2,1)='1' then
    led_color:='purple' else
    if copy(gyro_msg[6],2,1)='0' then
    led_color:='red';
    principale.FScriptGate3.CallScript('updateLed(' + 'gyro,'+led_color + ')',
    procedure(const iResult: String)
    var
    gg: string;
    begin
    gg := iResult;
    /// ///principale.memo_send.Lines.Append(gg);
    end);

    // accel
    if copy(gyro_msg[6],3,1)='3' then
    led_color:='green' else
    if copy(gyro_msg[6],3,1)='2' then
    led_color:='blue' else
    if copy(gyro_msg[6],3,1)='1' then
    led_color:='purple' else
    if copy(gyro_msg[6],3,1)='0' then
    led_color:='red';

    principale.FScriptGate3.CallScript('updateLed(' + 'accel,'+led_color + ')',
    procedure(const iResult: String)
    var
    gg: string;
    begin
    gg := iResult;
    /// ///principale.memo_send.Lines.Append(gg);
    end);

    // mag
    if copy(gyro_msg[6],4,1)='3' then
    led_color:='green' else
    if copy(gyro_msg[6],4,1)='2' then
    led_color:='blue' else
    if copy(gyro_msg[6],4,1)='1' then
    led_color:='purple' else
    if copy(gyro_msg[6],4,1)='0' then
    led_color:='red';
    principale.FScriptGate3.CallScript('updateLed(' + 'mag,'+led_color + ')',
    procedure(const iResult: String)
    var
    gg: string;
    begin
    gg := iResult;
    /// ///principale.memo_send.Lines.Append(gg);
    end);

  }

  if REP_OR_CHART <> 'CHART' then
  begin

    if g_tot > g_max then
      g_max := g_tot;
    if g_tot < g_min then
      g_min := g_tot;

    PRINCIPALE.SG.Cells[2, gtot_row] := Formatfloat('0.0', g_min);
    LastCol := 2;
    LastRow := 4;
    PRINCIPALE.SG.Cells[3, gtot_row] := Formatfloat('0.0', g_max);
    LastCol := 3;
    LastRow := 4;

    PRINCIPALE.SG.Cells[1, gacc_row] := Formatfloat('0.00', acc_x);
    LastCol := 1;
    LastRow := 12;
    PRINCIPALE.SG.Cells[2, gacc_row] := Formatfloat('0.00', acc_y);
    LastCol := 2;
    LastRow := 12;
    PRINCIPALE.SG.Cells[3, gacc_row] := Formatfloat('0.00', acc_z);
    LastCol := 3;
    LastRow := 12;
    application.ProcessMessages;

    check_alarm(floattostr(g_tot), 5);
    PRINCIPALE.SG.Cells[gtot_col, gtot_row] := Formatfloat('0.0', g_tot);
    LastCol := 1;
    LastRow := 4;
    application.ProcessMessages;
  end
  else
  begin
    Xc_g[index_c_g] := datetime_x;
    Yc_g[index_c_g] := g_tot;
    inc(index_c_g);

  end;

end;

procedure gps(m: string);

var
  slat, slon: single;

  minute: single;
  appo: string;
begin
  gps_msg := SplitString(m, ',');
  {
    0 = LAT

    1 = LONG

    2 = ALT (FT)
    3 = SPD (KT)
    4 = HDG
    5 = DATA VALID (0/1)
  }

  if gps_msg[5] > '0' then
  begin
    panelcolor2 := clGreen;

    PRINCIPALE.sb1.Panels[2].Text := ' GPS Data OK';

    { appo:=gps_msg[1]; // UTC Time
      if length(appo)=9 then begin // lunghezza corretta
      datetime_gps:= encodetime(strtoint(copy(appo,1,2)), strtoint(copy(appo,3,2)),
      strtoint(copy(appo,5,2)),0) ;

      end else datetime_gps:=now;
    }

    // retrieve altitude  and process elevation and height
    gps_altitude(gps_msg[2]);

    // retrieve latitude
    appo := gps_msg[0];

    {
      //  calc lat & long
      slat:=strtoint(copy(appo,1,2)); // pick degree
      minute:=StrToFloat(copy(appo,3,999),dot)/60;
      slat:=slat+minute;
      ////// if gps_msg[1]='S' then slat:=slat*-1;

      // retrieve longitude
      appo:=gps_msg[2];

      slon:=strtoint(copy(appo,1,3)); // pick degree
      minute:=StrToFloat(copy(appo,4,999),dot)/60;
      slon:=slon+minute;
      if gps_msg[3]='W' then slon:=slon*-1;

      slat_s:=floattostr(slat,dot);
      slon_s:=floattostr(slon,dot);
    }
    slat_s := gps_msg[0];

    slon_s := gps_msg[1];
    if (pos('Release', pp) = 0) and (REP_OR_CHART <> 'CHART') then
    begin
      // ShowMessage('old_box_connected: ' + old_box_connected);

      PRINCIPALE.FScriptGate.CallScript('latlong(' + slat_s + ',' + slon_s + ','
        + inttostr(height_i) + ',' + old_box_connected + ')',
        procedure(const iResult: String)
        var
          gg: string;
        begin
          gg := iResult;
          /// principale.memo_send.lines.append('Latitude & Longitude '+gg);

        end);
    end;

    gps_ias(gps_msg[3]);

    hdg(gps_msg[4]);

  end
  else
  begin // fix not valid
    panelcolor2 := clRed;
    PRINCIPALE.sb1.Panels[2].Text := ' Invalid GPS Data';

  end;

  if gps_msg[0] = 'xxx$GPRMC' then
  begin

    if gps_msg[2] = 'A' then
    begin
      // principale.Panel3.TextSettings.FontColor:=TAlphaColors.Green;
      // principale.Panel3.Text:=' GPS Data OK';
      // retrieve latitude
      appo := gps_msg[3];

      slat := strtoint(copy(appo, 1, 2)); // pick degree
      minute := strtofloat(copy(appo, 3, 999), Dot) / 60;
      slat := slat + minute;
      if gps_msg[4] = 'S' then
        slat := slat * -1;

      // retrieve longitude
      appo := gps_msg[5];

      slon := strtoint(copy(appo, 1, 3)); // pick degree
      minute := strtofloat(copy(appo, 4, 999), Dot) / 60;
      slon := slon + minute;
      if gps_msg[6] = 'W' then
        slon := slon * -1;

      slat_s := floattostr(slat, Dot);
      slon_s := floattostr(slon, Dot);
      /// // principale.wb1.URL:='https://www.openstreetmap.org/?mlat='+slat_s+'&mlon='+slon_s+'#map=';

    end
    else
    begin // fix not valid
      // principale.Panel3.TextSettings.FontColor:=TAlphaColors.Red;
      // p/rincipale.Panel3.Text:=' Invalid GPS Data';
    end;
  end;

  if (gps_msg[0] = '$GPVTG') and (gps_msg[6] > '0') then
  begin
    gps_ias(gps_msg[5]);
    hdg(gps_msg[1]);
  end;

end;

procedure Decode(ATopic, msg: string);
var
  appo: string;
  time_mex, mex: string;

begin
  with PRINCIPALE do
  begin
    if REP_OR_CHART <> 'CHART' then
    begin

      if cb_server.Checked = true then
      begin // se debug
        r.Font.Color := clBlack;
        r.Lines.Append(ATopic + ' ' + msg);
      end;
    end;

    if pos('/', ATopic) > 0 then
    begin
      red_color := false;
      // subtopic := copy(ATopic, pos('/', ATopic), 2);

      subtopic := copy(ATopic, pos('/', ATopic));

      // MODIFICA RECENTE
      case AnsiIndexStr(subtopic, ['/Z', '/N', '/T', '/S', '/E', '/O', '/W',
        '/R', '/OFFLINE']) of

        0:
          begin
            /// /// Z
            case strtoint(trim(msg)) of
              0:
                begin

                  box_connected := false;
                  signal_strength('0');
                  if REP_OR_CHART <> 'CHART' then
                  begin
                    panelcolor1 := clRed;
                    sb1.Panels[1].Text := ' Not Connected to the box';
                    panelcolor2 := clRed;
                    sb1.Panels[2].Text := ' Invalid GPS Data';
                    SG.Cells[1, 14] := 'NO';
                    LastRow := 14;
                    LastCol := 1;
                  end;

                end;

              1:
                begin

                  if REP_OR_CHART <> 'CHART' then
                  begin
                    box_connected := true;

                    panelcolor1 := clGreen;
                    sb1.Panels[1].Text := 'Connected to the box';
                    SG.Cells[1, 14] := 'YES';
                    LastRow := 14;
                    LastCol := 1;
                  end;
                end;

            end;

            if (box_connected) then
              old_box_connected := '1'
            else
              old_box_connected := '0';

          end;

        1:
          begin
            /// ///  N

            msg := trim(msg);

            if (copy(msg, 1, 1) = '0') and (REP_OR_CHART <> 'CHART') then
            begin // Vcc

              msg := copy(msg, 2, 999);

              vcc(msg);
              exit;
            end;

            if (copy(msg, 1, 1) = '1') and (REP_OR_CHART <> 'CHART') then
            begin // Icc

              msg := copy(trim(msg), 2, 999);

              Ia(msg);
              exit;
            end;

            if (copy(msg, 1, 1) = '2') and (REP_OR_CHART <> 'CHART') then
            begin
              // TEMPERATURA INTERNA
              appo := trim(copy(msg, 2, 999));
              check_alarm(appo, 2);
              SG.Cells[tint_col, tint_row] := appo;
              exit;
            end;

            if (copy(msg, 1, 1) = '3') and (REP_OR_CHART <> 'CHART') then
            begin
              // TEMPERATURA esterna
              appo := trim(copy(msg, 2, 999));
              if appo <> '-127' then
                SG.Cells[test_col, test_row] := appo
              else
                SG.Cells[test_col, test_row] := 'NC';
              LastRow := 2;
              LastCol := 2;
              exit;
            end;

            if (copy(msg, 1, 1) = '5') and (REP_OR_CHART <> 'CHART') then
            begin
              // magn heading

              msg := copy(msg, 2, 999);
              // l_heading.Text:='Mag Hdg: '+trim(msg);
              magn_heading(msg);
              exit;
            end;

            if (copy(msg, 1, 1) = '6') then
            begin // gyro  (horizontal)

              msg := copy(msg, 2, 999);

              gyro(msg);
              exit;
            end;

            if copy(msg, 1, 1) = '7' then
            begin // gps

              msg := copy(msg, 2, 999);
              gps(msg);
              exit;
            end;

            if copy(msg, 1, 1) = '8' then
            begin

              // SENSORE DI CO
              exit;
            end;

            if (copy(msg, 1, 1) = '9') and (REP_OR_CHART <> 'CHART') then
            begin
              // baro pressure  + altitude

              msg := copy(msg, 2, 999);
              baro_pressure(msg);

              exit;
            end;

            if copy(msg, 1, 1) = 'V' then
            begin // vsi

              msg := copy(msg, 2, 999);
              vsi(msg);

              exit;
            end;

          end;

        2:
          begin
            /// /// T

            /// l_timestamp.Text:='UTC Tmestamp: '+msg;

            FormatDateTime('dd/mm/yyyy hh:nn:ss', datetime_x);
            if REP_OR_CHART = 'CONNECT' then
            begin
              msg := copy(trim(msg), 1, 999);
              SG.Cells[utc_date_col, utc_date_row] := copy(msg, 1, 10);
              SG.Cells[utc_time_col + 1, utc_time_row] := copy(msg, 12, 8);

            end;

          end;

        3:
          begin
            /// /// S

            /// l_signal.Text:='Sign: '+msg;
            signal_strength(msg);

          end;

        4:
          begin
            /// / E

            elevation := 0;
            // msg:=trim(copy(msg,2,999));
            try
              elevation := strtoint(msg);

            except
              on e: exception do
                elevation := 0;
            end;

          end;

        5:
          begin

            // exit;
            // messaggi from WEBUNIT
            time_mex := copy(msg, 1, pos(';', msg) - 1);
            mex := copy(msg, pos(';', msg) + 1);
            r.Lines.Append(time_mex);
            r.Lines.Append('<--- WebUnit : ' + mex);

          end;

        6:
          begin
            // messaggi from 1TO1
            time_mex := copy(msg, 1, pos(';', msg) - 1);
            mex := copy(msg, pos(';', msg) + 1);
            r.Lines.Append(time_mex);
            r.Lines.Append('---> ' + mex);

          end;

        7:
          begin
            // messaggi from BLACKBOX

            // time_mex := copy(msg, 1, pos(';', msg) - 1);
            // mex := copy(msg, pos(';', msg) + 1);
            // r.Lines.Append(time_mex);
            r.Lines.Append('<--- BlackBox : ' + msg);

          end;

        8:
          begin

            // DATI OFFLINE DA NON CONSIDERARE
          end;

      end; // case

    end
    else
    begin
      r.Lines.Append(msg);

    end;

  end;

  /// //////////////////////////////
end;

procedure TPRINCIPALE.bt_replayClick(Sender: TObject);
var
  ss1, ss2: string;

begin
  // serve per i test
  { etopic.Text := 'I-RACC';
    WITH FLIGHT_SELECT_F do
    begin
    rg_flight_type.ItemIndex := 1;
    edata1.Date := strtodate('20/07/2023');
    edata2.Date := strtodate('20/07/2023');
    etime1.Time := strtotime('16:20:00');
    etime2.Time := strtotime('16:31:00');

    end;
  }

  /// ///////////
  RESET_ALARM;
  REP_OR_CHART := 'REPLAY';
  SG.Cells[0, 14] := 'Connection';
  datetime_gps := now;
  if etopic.Text <> '' then
  begin
    get_alarm(etopic.Text);
    AZZERA_SG;
    // FLIGHT_SELECT_U.azzera_campi;

    FLIGHT_SELECT_F.Caption := 'HCBU - Select Flight for ' + etopic.Text;
    FLIGHT_SELECT_F.ShowModal;
  end
  else
  begin
    Dlge('You must choose an aircraft before Replay a flight!');
    exit;
  end;
  g_max := 0;
  g_min := 0;
  h_x_baro_s := '0';
  vsi_index := 0;
  ddelay := 100;
  play_or_pause := 'PLAY';
  pb1.Position := 0;
  play_or_pause := 'PAUSE';
  application.ProcessMessages;
  if FLIGHT_SELECT_F.q_select.RecordCount > 0 then
  begin
    AFTER_REPLAY;
    rg_vcr.Visible := true;
    rg_vcr.Top := 429;
    rg_vcr.Left := 239;

    bt_cursor.Enabled := true;

    pb1.Max := FLIGHT_SELECT_F.q_select.RecordCount;
    // decode messages
    wb1.Navigate(ExtractFilePath(ParamStr(0)) + 'mapjs.html');
    while not FLIGHT_SELECT_F.q_select.Eof do
    begin
      if play_or_pause = 'PLAY' then
      begin

        date_X := (FLIGHT_SELECT_F.q_select['DATETIME_MESSAGE']);
        time_x := (FLIGHT_SELECT_F.q_select['DATETIME_MESSAGE']);
        LastRow := 9;
        LastCol := 2;
        SG.Cells[1, 9] := datetostr(date_X);
        SG.Cells[2, 9] := timetostr(time_x);
        datetime_x := FLIGHT_SELECT_F.q_select['DATETIME_MESSAGE'];
        if FLIGHT_SELECT_F.q_select['payload_alfa'] <> 'NOT-VALID' then
        begin
          ss1 := etopic.Text + '/' +
            trim(FLIGHT_SELECT_F.q_select['MQTT_CHANNEL']);
          ss2 := '';
          if (FLIGHT_SELECT_F.q_select['MQTT_CHANNEL'] = 'N') then
            ss2 := FLIGHT_SELECT_F.q_select['MQTT_SUBTOPIC'];
          ss2 := ss2 + (FLIGHT_SELECT_F.q_select['payload_alfa']);
          // showmessage(ss1 + ' ' + ss2);
          Decode(ss1, ss2);
        end;
        if FLIGHT_SELECT_F.q_select['FLAG_Z'] = '1' then
        begin
          SG.Cells[1, 14] := 'YES';
          box_connected := true;
        end
        else
        begin
          SG.Cells[1, 14] := 'NO';
          box_connected := false;
          signal_strength('0');
        end;

        // ShowMessage('bc: ' + BoolToStr(box_connected));
        if (box_connected) then
          old_box_connected := '1'
        else
          old_box_connected := '0';

        pb1.Position := FLIGHT_SELECT_F.q_select.RecNo;
        application.ProcessMessages;
        if play_or_pause = 'PLAY' then
        begin
          Sleep(ddelay);
          FLIGHT_SELECT_F.q_select.Next;
        end;
      end
      else
        application.ProcessMessages;
    end;
    FLIGHT_SELECT_F.q_select.close;
    DlgI('Flight replay terminated');
    pb1.Position := 0;
    bt_cursor.Enabled := false;
    rg_vcr.Visible := false;
    AFTER_DISCONNECT;

  end
  else
    DlgW2('No Telemery data found',
      'The flight selected does not have any telemetry data recorded!');

end;

procedure TPRINCIPALE.bt_chartClick(Sender: TObject);
var
  i: Integer;
begin
  REP_OR_CHART := 'CHART';
  SG.Cells[0, 14] := '';
  datetime_gps := now;
  if etopic.Text <> '' then
  begin
    FLIGHT_SELECT_U.azzera_campi;
    FLIGHT_SELECT_F.Caption := 'HCBU - Select Flight for ' + etopic.Text;
    FLIGHT_SELECT_F.ShowModal;
  end
  else
  begin
    Dlge('You must choose an aircraft before Replay a flight!');
    exit;
  end;
  // DA QUI SI FA IL CHARTING
  g_max := 0;
  g_min := 0;
  h_x_baro_s := '0';
  vsi_index := 0;
  if FLIGHT_SELECT_F.q_select.RecordCount > 0 then
  begin
    AFTER_CHART;
    /// ////  gps ias
    with FLIGHT_SELECT_F.q_select do
    begin
      Filter := 'MQTT_SUBTOPIC=' + quotedstr('7');
      // + ' AND PAYLOAD_ALFA LIKE ' + QuotedStr('%VTG%');
      Filtered := true;
      Count_gps_ias := FLIGHT_SELECT_F.q_select.RecordCount;
      Count_gps_ALT := FLIGHT_SELECT_F.q_select.RecordCount;
      Count_gps_VSI := Count_gps_ALT;
      Filtered := false;
    end;

    SetLength(Xgps_ias, Count_gps_ias);
    SetLength(Ygps_ias, Count_gps_ias);
    index_gps_ias := 1;

    // end gps ias
    // start gps altitude

    {
      with FLIGHT_SELECT_F.q_select do
      begin
      Filter := 'MQTT_SUBTOPIC=' + QuotedStr('7'); // + ' AND PAYLOAD_ALFA LIKE ' +   QuotedStr('%GGA%');
      Filtered := true;
      Count_gps_ALT := FLIGHT_SELECT_F.q_select.RecordCount;
      Count_gps_VSI := Count_gps_ALT;

      Filtered := false;
      end; }

    SetLength(Xgps_ALT, Count_gps_ALT);
    SetLength(Ygps_ALT, Count_gps_ALT);
    index_gps_ALT := 1;

    // SetLength(Xgps_VSI, Count_gps_VSI);
    // SetLength(Ygps_VSI, Count_gps_VSI);
    index_gps_VSI := 1;

    for i := 1 to 10000 do
    BEGIN
      Ygps_VSI[i] := 0;
      Xgps_VSI[i] := 0;
    END;

    // end gps altitude

    // start pitch & Roll
    with FLIGHT_SELECT_F.q_select do
    begin
      Filter := 'MQTT_SUBTOPIC=' + quotedstr('6');
      Filtered := true;
      Count_c_pitch := FLIGHT_SELECT_F.q_select.RecordCount;
      Count_c_roll := Count_c_pitch;
      Count_c_g := Count_c_pitch;
      Filtered := false;
    end;
    // SetLength(Xc_pitch, Count_c_pitch);
    // SetLength(Yc_pitch, Count_c_pitch);
    index_c_pitch := 1;

    SetLength(Xc_roll, Count_c_roll);
    SetLength(Yc_roll, Count_c_roll);
    index_c_roll := 1;

    SetLength(Xc_g, Count_c_g);
    SetLength(Yc_g, Count_c_g);
    index_c_g := 1;



    // end gps altitude

    FLIGHT_SELECT_F.q_select.First;

    while not FLIGHT_SELECT_F.q_select.Eof do
    begin
      if (FLIGHT_SELECT_F.q_select['payload_alfa'] <> 'NOT-VALID') then
      begin
        Main.datetime_x := FLIGHT_SELECT_F.q_select['DATETIME_MESSAGE'];
        Decode(etopic.Text + '/' + trim(FLIGHT_SELECT_F.q_select['MQTT_CHANNEL']
          ), trim(FLIGHT_SELECT_F.q_select['MQTT_SUBTOPIC']) +
          trim(FLIGHT_SELECT_F.q_select['payload_alfa']));

      end;

      FLIGHT_SELECT_F.q_select.Next;
    end;

    CHART_F.ShowModal;
    FLIGHT_SELECT_F.q_select.close;
    AFTER_DISCONNECT;

    if Assigned(FScriptGate) then

      try

        begin

          PRINCIPALE.FScriptGate.CallScript('reset_map()',
            procedure(const iResult: String)
            begin
              // showmessage(iResult);

            end)
        end

      except
        // showmessage('cazzi');
      end

    else
      // showmessage('not assigned');

  end
  else
    DlgW2('No Telemery data found',
      'The flight selected does not have any telemetry data recorded!');

end;

procedure TPRINCIPALE.bt_connectClick(Sender: TObject);
var
  Hour, Min, Sec, MSec: Word;
begin

  RESET_ALARM;

  DecodeTime(now, Hour, Min, Sec, MSec);
  REP_OR_CHART := 'CONNECT';
  // SG.Cells[0, 14] := '';
  datetime_gps := now;

  if etopic.ItemIndex >= 0 then
  begin
    AZZERA_SG;
    mqc.ClientID := eclient_id + inttostr(Hour) + inttostr(Sec) +
      inttostr(MSec);
    mqc.Connect();
    g_max := 0;
    g_min := 0;
    h_x_baro_s := '0';
    vsi_index := 0;

    get_alarm(etopic.Text);

    AFTER_CONNECT;
  end
  else
  begin
    Dlge('You must choose an aircraft before Connect!');
  end;
end;

procedure TPRINCIPALE.bt_cursorClick(Sender: TObject);
begin
  if (rg_vcr.Visible) then

    rg_vcr.Visible := false
  else
    rg_vcr.Visible := true;
end;

procedure TPRINCIPALE.bt_disconnectClick(Sender: TObject);
begin
  mqc.Disconnect;
  AFTER_DISCONNECT;

end;

procedure TPRINCIPALE.bt_fast_forwardClick(Sender: TObject);
begin
  FLIGHT_SELECT_F.q_select.RecNo := round(FLIGHT_SELECT_F.q_select.RecNo * 1.6);
end;

procedure TPRINCIPALE.bt_fast_rewindClick(Sender: TObject);
begin
  FLIGHT_SELECT_F.q_select.RecNo := round(FLIGHT_SELECT_F.q_select.RecNo * 0.6);
end;

procedure TPRINCIPALE.bt_forwardClick(Sender: TObject);
begin
  FLIGHT_SELECT_F.q_select.RecNo := round(FLIGHT_SELECT_F.q_select.RecNo * 1.3);
end;

procedure TPRINCIPALE.bt_rewindClick(Sender: TObject);
begin
  FLIGHT_SELECT_F.q_select.RecNo := round(FLIGHT_SELECT_F.q_select.RecNo * 0.3);
end;

procedure TPRINCIPALE.bt_play_pauseClick(Sender: TObject);
begin
  if play_or_pause = 'PLAY' then
    play_or_pause := 'PAUSE'
  else
    play_or_pause := 'PLAY';

end;

procedure TPRINCIPALE.bt_sendClick(Sender: TObject);

begin
  case rg_channel.ItemIndex of
    // 2:
    // mqc.Publish(etopic.Text + '/N', memo_send.lines.Text);

    0:
      begin
        // mqc.Publish(etopic.Text + '/W', FormatDateTime('yyyy-mm-dd hh:nn:ss',
        // now()) + ';' + memo_send.Lines.Text);

        mqc.Publish(etopic.Text + '/W', memo_send.Lines.Text);
      end;

    // 1:
    // BROADCAST
    // mqc.Publish(etopic.Text + '/B', memo_send.lines.Text);

  end;

  memo_send.Lines.Clear;
end;

procedure TPRINCIPALE.bt_stopClick(Sender: TObject);
begin
  FLIGHT_SELECT_F.q_select.Last;

end;

procedure TPRINCIPALE.bt_update_connClick(Sender: TObject);
var
  Hour, Min, Sec, MSec: Word;

begin
  mqc.Disconnect;
  DecodeTime(now, Hour, Min, Sec, MSec);
  mqc.ClientID := eclient_id + inttostr(Hour) + inttostr(Sec) + inttostr(MSec);
  mqc.Connect();
end;

procedure TPRINCIPALE.FormCreate(Sender: TObject);

begin
  pp := ExtractFilePath(ParamStr(0));
  FScriptGate := TScriptGate.Create(Self, wb1, 'intuos');
  FScriptGate2 := TScriptGate.Create(Self, wb2, 'intuos2');
  FScriptGate3 := TScriptGate.Create(Self, wb3, 'intuos3');
  FScriptGate3 := TScriptGate.Create(Self, wb_efis, 'intuos3');
  if pos('Release', pp) = 0 then
    wb1.Navigate(ExtractFilePath(ParamStr(0)) + 'mapJS.html');

  wb2.Navigate(ExtractFilePath(ParamStr(0)) + 'sixPack0.2/sixPack0.2.html');
  wb3.Navigate(ExtractFilePath(ParamStr(0)) + 'gauge/hcbu/wb3.html');
  // wb3.Navigate(ExtractFilePath(ParamStr(0)) + 'gauge/hcbu/wb3.html');
  vsi_index := 0;
  eclient_id := '1to1';
  done_landing := false;
  done_takeoff := false;
  old_sec_land := 0;
  cont_for_land := 0;
  first_ele_minor := 0;
  takeoff_past := false;
  landing_past := false;

end;

procedure TPRINCIPALE.FormKeyUp(Sender: TObject; var Key: Word;
Shift: TShiftState);
begin
  if (Shift = [ssShift, ssCtrl]) and (Key = VK_F12) then
  begin
    if (cb_server.Checked) then
      cb_server.Checked := false
    else
      cb_server.Checked := true;

  end;
end;

procedure TPRINCIPALE.FormShow(Sender: TObject);
begin

  EXEPATH := ExtractFilePath(ParamStr(0));
  if FileExists(EXEPATH + 'HCBU_Start.exe3') then
  begin
    launcher_ok := true;
    DeleteFile(EXEPATH + 'HCBU_Start.exe');
    Sleep(5);
    RenameFile(EXEPATH + 'HCBU_Start.exe3', EXEPATH + 'HCBU_Start.exe');
    Sleep(5);
  end
  else
    launcher_ok := false;

  if SPLASH_U.LOGIN_PERFORMED = true then
  begin

    cn1.Params.UserName := SPLASH_U.USER;
    cn1.Params.Password := SPLASH_U.Password;
    db0.Connection.Params.UserName := SPLASH_U.USER;
    db0.Connection.Params.Password := SPLASH_U.Password;

    cn1.connected := true;

    q_read_aero.open();
    PRINCIPALE.etopic.Items.Clear;
    while not q_read_aero.Eof do
    begin
      PRINCIPALE.etopic.Items.add(q_read_aero['MARCHE']);
      q_read_aero.Next;
    end;

    rg_channel.ItemIndex := 0;
    /// CANALE W
    with SG do
    begin
      ColWidths[0] := 120;
      ColWidths[1] := 60;
      ColWidths[2] := 60;
      ColWidths[3] := 40;
      ColWidths[4] := 100;
      Cells[0, vcc_row] := 'Vcc(V) / I(mA)';
      Cells[0, tint_row] := 'Tint / Text (C)';
      Cells[0, hdg_row] := 'Magn. Heading (deg)';
      Cells[0, gtot_row] := 'G acc. tot,min,max (G)';
      Cells[0, gs_row] := 'GPS GS (Kts)';
      Cells[0, vsi_row] := 'VSI (ft/min)';
      Cells[0, mbar_row] := 'Baro Pressure (mBar)';
      Cells[0, baro_ft_row] := 'Baro / GPS Altitude (ft)';
      Cells[0, utc_date_row] := 'UTC Timestamp';
      Cells[0, dbm_row] := 'GPRS Signal (dbm)';
      Cells[0, pitch_row] := 'Pitch / Roll (Deg)';
      Cells[0, gacc_row] := 'G acc. x,y,z (G)';
      Cells[0, height_row] := 'Height (ft)';
      Cells[0, connected_row] := 'Connected';
      Cells[0, turnrate_row] := 'TurnRate (deg/sec) ';
      Cells[0, co_row] := 'Carbon Monoxide (ppm) ';
      Cells[0, take_land_row] := 'Take-off/Landing';

      // header
      Cells[alarm_col, 0] := 'Last Alrm';
    end;
    UnselectGridCell(SG);

    elevation := 2200;

    AFTER_DISCONNECT;

    rg_vcr.Visible := false;
    bt_cursor.Enabled := false;
    fs := TFormatSettings.Create;
    fs.DateSeparator := '/';
    fs.ShortDateFormat := 'dd/mm/yyyy';
    fs.TimeSeparator := ':';
    fs.ShortTimeFormat := 'hh:mm';
    fs.LongTimeFormat := 'hh:mm:ss';

    with sb1 do
    begin
      panelcolor0 := clRed;
      Panels[0].Text := 'Offline';

      panelcolor1 := clBlue;
      Panels[1].Text := ' ------';

      panelcolor2 := clBlue;
      Panels[2].Text := ' ------';

    end;
  end
  else
  begin

  end;
end;

procedure TPRINCIPALE.mqcConnectedStatusChanged(ASender: TObject;
const AConnected: Boolean; AStatus: TTMSMQTTConnectionStatus);
begin
  if AConnected then
  begin

    mqc.Subscribe(etopic.Text + '/#');
    panelcolor0 := clGreen;
    sb1.Panels[0].Text := 'Online';

  end
  else
  begin
    // The client is NOT connected and any interaction with the broker will
    // result in an exception.
    panelcolor0 := clRed;
    case AStatus of
      csConnectionRejected_InvalidProtocolVersion:
        sb1.Panels[0].Text := 'Invalid Protocol Version';
      csConnectionRejected_InvalidIdentifier:
        sb1.Panels[0].Text := 'Invalid Protocol Version';
      csConnectionRejected_ServerUnavailable:
        sb1.Panels[0].Text := 'Server Unavailable';
      csConnectionRejected_InvalidCredentials:
        sb1.Panels[0].Text := 'Invalid Credentials';
      csConnectionRejected_ClientNotAuthorized:

        sb1.Panels[0].Text := 'Client Not Authorized';
      csConnectionLost:
        // the connection with the broker is lost
        sb1.Panels[0].Text := 'Connection Lost!';
      // csConnecting:
      // sb1.Panels[0].Text:='Connecting.....';
      csReconnecting:
        sb1.Panels[0].Text := 'Reconnecting.....';
    end;
  end;
end;

procedure TPRINCIPALE.mqcPublishReceivedEx(ASender: TObject; APacketID: Word;
ATopic: string; APayload: TTMSMQTTBytes);
var
  msg: string;

begin
  msg := TEncoding.UTF8.GetString(APayload);
  Decode(ATopic, msg);

  /// //////////////////////////////
end;

procedure TPRINCIPALE.sb1DrawPanel(StatusBar: TStatusBar; Panel: TStatusPanel;
const Rect: TRect);
begin
  if (Panel = StatusBar.Panels[0]) then
  begin
    with sb1 do
    begin
      Canvas.Font.Color := panelcolor0;
      Canvas.TextOut(Rect.Left + 5, Rect.Top - 2, Panel.Text);
    end;
  end;
  if (Panel = StatusBar.Panels[1]) then
  begin
    with sb1 do
    begin
      Canvas.Font.Color := panelcolor1;
      Canvas.TextOut(Rect.Left + 5, Rect.Top - 2, Panel.Text);
    end;
  end;
  if (Panel = StatusBar.Panels[2]) then
  begin
    with sb1 do
    begin
      Canvas.Font.Color := panelcolor2;
      Canvas.TextOut(Rect.Left + 5, Rect.Top - 2, Panel.Text);
    end;
  end;
end;

procedure TPRINCIPALE.sgDrawCell(Sender: TObject; ACol, ARow: Integer;
Rect: TRect; State: TGridDrawState);
var
  S: string;
  RectForText: TRect;
begin
  if ACol = 0 then
    exit;

  if SG.Cells[ACol, ARow] = '' then
    exit;

  // colora le celle a seconda se � Normale o Allarme
  S := SG.Cells[ACol, ARow];
  if subtopic = '/N' then
  begin
    SG.Canvas.Brush.Color := clWhite;
    SG.Canvas.FillRect(Rect);
    if ACol = alarm_col then
      SG.Canvas.Font.Color := clRed // solo per la colonna allarmi
    else
      SG.Canvas.Font.Color := clBlack;
    if (ACol = vcc_col) and (ARow = vcc_row) then
    begin // Vcc
      if vcc_alarm then
        SG.Canvas.Font.Color := clRed
      else
        SG.Canvas.Font.Color := clBlue;
    end;
    if (ACol = icc_col) and (ARow = icc_row) then
    begin // Icc
      if icc_alarm then
        SG.Canvas.Font.Color := clRed
      else
        SG.Canvas.Font.Color := clBlue;
    end;
    if (ACol = gtot_col) and (ARow = gtot_row) then
    begin // Gtot
      if gtot_alarm then
        SG.Canvas.Font.Color := clRed
      else
        SG.Canvas.Font.Color := clBlue;
    end;
    if (ACol = gps_ft_col) and (ARow = gps_ft_row) then
    begin
      // GPS Altitude
      if altitude_alarm then
        SG.Canvas.Font.Color := clRed
      else
        SG.Canvas.Font.Color := clBlue;
    end;
    if (ACol = gs_col) and (ARow = gs_row) then
    begin // GPS GS
      if ias_alarm then
        SG.Canvas.Font.Color := clRed
      else
        SG.Canvas.Font.Color := clBlue;
    end;
    if (ACol = vsi_col) and (ARow = vsi_row) then
    begin // VSI
      if vsi_alarm then
        SG.Canvas.Font.Color := clRed
      else
        SG.Canvas.Font.Color := clBlue;
    end;
    if (ACol = pitch_col) and (ARow = pitch_row) then
    begin
      // PITCH
      if pitch_alarm then
        SG.Canvas.Font.Color := clRed
      else
        SG.Canvas.Font.Color := clBlue;
    end;
    if (ACol = roll_col) and (ARow = roll_row) then
    begin // ROLL
      if roll_alarm then
        SG.Canvas.Font.Color := clRed
      else
        SG.Canvas.Font.Color := clBlue;
    end;
    if (ACol = height_col) and (ARow = height_row) then
    begin
      // HEIGHT
      if height_alarm then
        SG.Canvas.Font.Color := clRed
      else
        SG.Canvas.Font.Color := clBlue;
    end;

  end
  else
  begin

    SG.Canvas.Brush.Color := clWhite;
    SG.Canvas.FillRect(Rect);
    SG.Canvas.Font.Color := clBlack;
  end;
  RectForText := Rect;
  InflateRect(RectForText, -2, -2);
  // Edit: using TextRect instead of TextOut to prevent overflowing of text
  SG.Canvas.TextRect(RectForText, S);

  application.ProcessMessages;

end;

procedure TPRINCIPALE.tb_delayChange(Sender: TObject);
begin
  ddelay := tb_delay.Position;
end;

procedure TPRINCIPALE.Visualize1Click(Sender: TObject);
begin
  wb2.Visible := false;
  wb_efis.Visible := true;

end;

end.
