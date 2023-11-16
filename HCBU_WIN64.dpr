program HCBU_WIN64;

uses
  Vcl.Forms,
  Main in 'Main.pas' {PRINCIPALE} ,
  LOGIN_U in 'LOGIN_U.pas' {LOGIN_F} ,
  FLIGHT_SELECT_U in 'FLIGHT_SELECT_U.pas' {FLIGHT_SELECT_F} ,
  CHART_U in 'CHART_U.pas' {CHART_F} ,
  Vcl.Themes,
  Vcl.Styles,
  SPLASH_U in 'SPLASH_U.pas' {SPLASH_F};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Luna');

  Splash_F := TSplash_f.Create(nil);
  Splash_F.Show;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Luna');
  Application.Title := 'HCBU';

  LOGIN_F := TLOGIN_F.Create(nil);
  LOGIN_F.ShowModal;

  if SPLASH_U.LOGIN_PERFORMED = True then
  begin

    Application.CreateForm(TPRINCIPALE, PRINCIPALE);
    PRINCIPALE.AlphaBlend := True;
    PRINCIPALE.AlphaBlendValue := 0;
    Application.ProcessMessages;
    Application.CreateForm(TFLIGHT_SELECT_F, FLIGHT_SELECT_F);
    Application.CreateForm(TCHART_F, CHART_F);

    Splash_F.Hide;
    Splash_F.Close;
    Splash_F.Free;
    PRINCIPALE.AlphaBlendValue := 255;
    Application.Run;
  end;

end.
