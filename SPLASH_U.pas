unit SPLASH_U;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.Imaging.jpeg;

type
  TSPLASH_F = class(TForm)
    l_load: TLabel;
    L_LICENSE: TLabel;
    Panel1: TPanel;
    Image1: TImage;
  private
    { Private declarations }
  public
    { Public declarations }

  end;

var
  SPLASH_F: TSPLASH_F;
  LOGIN_PERFORMED:bool;
  USER,PASSWORD:string;

implementation

{$R *.dfm}

end.
