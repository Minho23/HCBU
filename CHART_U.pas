unit CHART_U;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, VclTee.TeeGDIPlus, Data.DB,
  VclTee.TeEngine, Vcl.ExtCtrls, VclTee.TeeProcs, VclTee.Chart, VclTee.DBChart,
  VclTee.Series, Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls;

type
  TCHART_F = class(TForm)
    Button1: TButton;
    gps_ias: TChart;
    Series1: TLineSeries;
    ias_marks: TCheckBox;
    ias_smothed: TCheckBox;
    gps_alt: TChart;
    elev_marks: TCheckBox;
    alt_smoothed: TCheckBox;
    pitch_marks: TCheckBox;
    vsi_smoothed: TCheckBox;
    Panel1: TPanel;
    c_g: TChart;
    Series3: TLineSeries;
    c_pitch: TChart;
    Series5: TLineSeries;
    Series4: TLineSeries;
    Series2: TLineSeries;
    Series6: TLineSeries;
    Series7: TLineSeries;
    alt_marks: TCheckBox;
    ScrollBox1: TScrollBox;
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure ias_marksClick(Sender: TObject);
    procedure ias_smothedClick(Sender: TObject);
    procedure elev_marksClick(Sender: TObject);
    procedure alt_smoothedClick(Sender: TObject);
    procedure pitch_marksClick(Sender: TObject);
    procedure vsi_smoothedClick(Sender: TObject);
    procedure alt_marksClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  CHART_F: TCHART_F;
  ias: TLineSeries;

implementation

uses login_u, Main, FLIGHT_SELECT_U;

{$R *.dfm}

procedure TCHART_F.alt_marksClick(Sender: TObject);
begin
  if alt_marks.Checked = true then
    gps_alt.Series[0].Marks.Visible := true
  else
    gps_alt.Series[0].Marks.Visible := false;
end;

procedure TCHART_F.alt_smoothedClick(Sender: TObject);
begin
  if alt_smoothed.Checked = true then
    (gps_alt.Series[0] as TLineSeries).Smoothed := true
  else
    (gps_alt.Series[0] as TLineSeries).Smoothed := false;

end;

procedure TCHART_F.Button1Click(Sender: TObject);
var
  i: integer;

begin
  gps_ias.Axes.Bottom.DateTimeFormat := 'hh:nn:ss';
  gps_alt.Axes.Bottom.DateTimeFormat := 'hh:nn:ss';
  c_pitch.Axes.Bottom.DateTimeFormat := 'hh:nn:ss';
  c_g.Axes.Bottom.DateTimeFormat := 'hh:nn:ss';

  gps_ias.Series[0].Clear;
  gps_ias.Series[1].Clear;

  for i := 1 to Main.Count_gps_ias do
  begin
    if Xgps_ias[i] > 0 then
    begin
      gps_ias.Series[0].AddXY(Main.Xgps_ias[i], Main.Ygps_ias[i], '',
        clTeeColor);
      gps_ias.Series[1].AddXY(Main.Xgps_ias[i], Main.Ygps_VSI[i], '',
        clTeeColor);
    end;
  end;
  gps_ias.Series[0].Repaint;
  gps_ias.Series[1].Repaint;

  gps_alt.Series[0].Clear;
  gps_alt.Series[1].Clear;
  for i := 1 to Main.Count_gps_ALT do
  begin
    if Main.Xgps_ALT[i] > 0 then
    begin
      gps_alt.Series[0].AddXY(Main.Xgps_ALT[i], Main.Ygps_ALT[i], '',
        clTeeColor);
      gps_alt.Series[1].AddXY(Main.Xgps_ALT[i], Main.Ygps_HGT[i], '',
        clTeeColor);

    end;
  end;
  gps_alt.Series[0].Repaint;
  gps_alt.Series[1].Repaint;

  c_pitch.Series[0].Clear;
  c_pitch.Series[1].Clear;
  for i := 1 to Main.Count_c_pitch do
  begin

    if Xc_pitch[i] > 0 then
    begin
      c_pitch.Series[0].AddXY(Main.Xc_pitch[i], Main.Yc_pitch[i], '',
        clTeeColor);
      c_pitch.Series[1].AddXY(Main.Xc_pitch[i], Main.Yc_roll[i], '',
        clTeeColor);

    end;
  end;
  c_pitch.Series[0].Repaint;
  c_pitch.Series[1].Repaint;

  c_g.Series[0].Clear;

  for i := 1 to Main.Count_c_g do
  begin
    if Xc_g[i] > 0 then
    begin
      c_g.Series[0].AddXY(Main.Xc_g[i], Main.Yc_g[i], '', clTeeColor);

      { if main.Xc_g[i]<c_g.BottomAxis.Minimum then
        c_g.BottomAxis.Minimum:=Main.Xc_g[i];
        if main.Xc_g[i]>c_g.BottomAxis.Maximum then
        c_g.BottomAxis.Maximum:=Main.Xc_g[i];
      }
      // c_g.Series[1].AddXY(main.Xc_g[i],main.Yc_roll[i],'',clTeeColor);
    end;
  end;
  c_g.Series[0].Repaint;

end;

procedure TCHART_F.elev_marksClick(Sender: TObject);
begin
  if elev_marks.Checked = true then
    gps_alt.Series[1].Marks.Visible := true
  else
    gps_alt.Series[1].Marks.Visible := false;

end;

procedure TCHART_F.FormShow(Sender: TObject);
begin

  CHART_F.Caption := 'Charting for: ' + principale.etopic.Text;
  Panel1.Caption := 'FlightTime Interval: ' +
    datetimetostr(FLIGHT_SELECT_U.start_datetime) + ' ' +
    datetimetostr(FLIGHT_SELECT_U.end_datetime);
  gps_ias.Series[0].Clear;
  gps_alt.Series[0].Clear;
  gps_alt.Series[1].Clear;
  c_pitch.Series[0].Clear;
  c_pitch.Series[1].Clear;
  c_g.Series[0].Clear;

  ias_marks.Checked := false;
  ias_marksClick(ias_marks);
  ias_smothed.Checked := false;
  ias_smothedClick(ias_smothed);
  alt_marks.Checked := false;
  alt_marksClick(alt_marks);
  alt_smoothed.Checked := false;
  alt_smoothedClick(alt_smoothed);
  pitch_marks.Checked := false;
  pitch_marksClick(pitch_marks);
  c_g.Series[0].Marks.Visible := false;

  Button1Click(Button1);

end;

procedure TCHART_F.ias_marksClick(Sender: TObject);
begin
  if ias_marks.Checked = true then
    gps_ias.Series[0].Marks.Visible := true
  else
    gps_ias.Series[0].Marks.Visible := false;

end;

procedure TCHART_F.ias_smothedClick(Sender: TObject);
begin
  if ias_smothed.Checked = true then
    (gps_ias.Series[0] as TLineSeries).Smoothed := true
  else
    (gps_ias.Series[0] as TLineSeries).Smoothed := false;
end;

procedure TCHART_F.pitch_marksClick(Sender: TObject);
begin
  if pitch_marks.Checked = true then
    c_pitch.Series[0].Marks.Visible := true
  else
    c_pitch.Series[0].Marks.Visible := false;
end;

procedure TCHART_F.vsi_smoothedClick(Sender: TObject);
begin
  if vsi_smoothed.Checked = true then
    (c_pitch.Series[0] as TLineSeries).Smoothed := true
  else
    (c_pitch.Series[0] as TLineSeries).Smoothed := false;
  c_pitch.Series[0].XValues.datetime := true;

end;

end.
