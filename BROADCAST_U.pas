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
    procedure FormShow(Sender: TObject);
    procedure bb_send_messageClick(Sender: TObject);

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

procedure ClearAll();
begin
  with BROADCAST_F do
  begin
    clb_aircraft.Items.Clear;
    list_ack.Items.Clear;
    e_message.Clear;
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
        b := true;
      end;

    end;

    if b then
      DlgI('Sent broadcast message to checked aircrafts.')
    else
      DlgI('No aircraft selected.');

    e_message.Clear;

  end;

end;

procedure TBROADCAST_F.FormShow(Sender: TObject);
begin

  ClearAll;
  q_read_aero.open();
  while not q_read_aero.Eof do
  begin
    clb_aircraft.Items.Add(q_read_aero['MARCHE']);
    AggiungiElemento(q_read_aero['MARCHE']);
    q_read_aero.Next;
  end;
  q_read_aero.close();
end;

end.