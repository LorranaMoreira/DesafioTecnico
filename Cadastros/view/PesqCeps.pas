unit PesqCeps;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Data.DB, Vcl.StdCtrls,
  Vcl.Grids, Vcl.DBGrids, Banco;

type
  TPesqsCeps = class(TForm)
    PnlFundo: TPanel;
    BtnSelecionar: TButton;
    GridCeps: TDBGrid;
    DataSource1: TDataSource;
    LbCeps: TLabel;
    procedure FormShow(Sender: TObject);
    procedure BtnSelecionarClick(Sender: TObject);
    procedure GridCepsDblClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    procedure PreencherCadastro;
  public
    { Public declarations }
  end;

var
  PesqsCeps: TPesqsCeps;

implementation

uses
  CadsCep;

{$R *.dfm}

procedure TPesqsCeps.FormShow(Sender: TObject);
begin
  try
    DataSource1.DataSet := DataModule1.QryCep;
    GridCeps.DataSource := DataSource1;

    with DataModule1.QryCep do
    begin
      Close;
      SQL.Clear;
      SQL.Text :=
        'SELECT ID, CEP, LOGRADOURO, CIDADE, UF ' +
        'FROM CEP ' +
        'ORDER BY CEP';
      Open;
    end;
  except
    on E: Exception do
      ShowMessage('Erro ao carregar CEPs: ' + E.Message);
  end;
end;

procedure TPesqsCeps.PreencherCadastro;
begin
  if not DataModule1.QryCep.IsEmpty then
  begin
    CadastroCep.EdCEP.Text        := DataModule1.QryCep.FieldByName('CEP').AsString;
    CadastroCep.EdLogradouro.Text := DataModule1.QryCep.FieldByName('LOGRADOURO').AsString;
    CadastroCep.EdCidade.Text     := DataModule1.QryCep.FieldByName('CIDADE').AsString;
    CadastroCep.EdUF.Text         := DataModule1.QryCep.FieldByName('UF').AsString;
  end
  else
    ShowMessage('Nenhum CEP selecionado.');
end;

procedure TPesqsCeps.BtnSelecionarClick(Sender: TObject);
begin
  PreencherCadastro;
end;

procedure TPesqsCeps.GridCepsDblClick(Sender: TObject);
begin
  BtnSelecionarClick(Sender);
end;

procedure TPesqsCeps.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  PesqsCeps := nil;
end;

end.
