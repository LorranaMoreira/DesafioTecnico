unit PesqClientes;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.StdCtrls,
  Vcl.Grids, Vcl.DBGrids, Vcl.ExtCtrls, Banco;

type
  TPesqsCliente = class(TForm)
    PnlFundo: TPanel;
    LbClientes: TLabel;
    GridClientes: TDBGrid;
    PnlRodape: TPanel;
    BntSelecionar: TButton;
    DataSource1: TDataSource;
    procedure FormShow(Sender: TObject);
    procedure BntSelecionarClick(Sender: TObject);
    procedure GridClientesDblClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    FCadOrigem: TForm;
    procedure PreencherCadastro;
    procedure ConfigurarGrid;
  public
    property CadOrigem: TForm write FCadOrigem;
  end;

var
  PesqsCliente: TPesqsCliente;

implementation

uses CadsCliente;

{$R *.dfm}

procedure TPesqsCliente.ConfigurarGrid;
begin
  GridClientes.Columns.Clear;

  with GridClientes.Columns.Add do
  begin
    FieldName     := 'ID';
    Title.Caption := 'Cód.';
    Width         := 50;
  end;

  with GridClientes.Columns.Add do
  begin
    FieldName     := 'NOME';
    Title.Caption := 'Nome';
    Width         := 200;
  end;

  with GridClientes.Columns.Add do
  begin
    FieldName     := 'CPF_CNPJ';
    Title.Caption := 'CPF/CNPJ';
    Width         := 120;
  end;

  with GridClientes.Columns.Add do
  begin
    FieldName     := 'TELEFONE';
    Title.Caption := 'Telefone';
    Width         := 100;
  end;

  with GridClientes.Columns.Add do
  begin
    FieldName     := 'CIDADE';
    Title.Caption := 'Cidade';
    Width         := 130;
  end;

  with GridClientes.Columns.Add do
  begin
    FieldName     := 'UF';
    Title.Caption := 'UF';
    Width         := 40;
  end;
end;

procedure TPesqsCliente.FormShow(Sender: TObject);
begin
  try
    DataSource1.DataSet     := DataModule1.QryClientes;
    GridClientes.DataSource := DataSource1;

    with DataModule1.QryClientes do
    begin
      Close;
      SQL.Clear;
      SQL.Text :=
        'SELECT ID, NOME, CPF_CNPJ, TELEFONE, EMAIL, ENDERECO, NUMERO, ' +
        'CIDADE, UF, CEP, FOTO ' +
        'FROM CLIENTES ORDER BY NOME';
      Open;
    end;

    ConfigurarGrid;
  except
    on E: Exception do
      ShowMessage('Erro ao carregar clientes: ' + E.Message);
  end;
end;

procedure TPesqsCliente.PreencherCadastro;
begin
  if DataModule1.QryClientes.IsEmpty then
  begin
    ShowMessage('Nenhum cliente selecionado.');
    Exit;
  end;

  if not (Assigned(FCadOrigem) and (FCadOrigem is TCadCliente)) then
    Exit;

  with TCadCliente(FCadOrigem) do
  begin
    EdtCod.Text      := DataModule1.QryClientes.FieldByName('ID').AsString;
    EdtNome.Text     := DataModule1.QryClientes.FieldByName('NOME').AsString;
    EdtCPFCNPJ.Text  := DataModule1.QryClientes.FieldByName('CPF_CNPJ').AsString;
    EdtTelefone.Text := DataModule1.QryClientes.FieldByName('TELEFONE').AsString;
    EdtEmail.Text    := DataModule1.QryClientes.FieldByName('EMAIL').AsString;
    EdtCep.Text      := DataModule1.QryClientes.FieldByName('CEP').AsString;
    EdtUF.Text       := DataModule1.QryClientes.FieldByName('UF').AsString;
    EdtCidade.Text   := DataModule1.QryClientes.FieldByName('CIDADE').AsString;
    EdtEndereco.Text := DataModule1.QryClientes.FieldByName('ENDERECO').AsString;
    EdtNumero.Text   := DataModule1.QryClientes.FieldByName('NUMERO').AsString;

    if Trim(DataModule1.QryClientes.FieldByName('FOTO').AsString) <> '' then
    begin
      try
        ImgFotoCliente.Picture.LoadFromFile(
          DataModule1.QryClientes.FieldByName('FOTO').AsString);
        ImgFotoCliente.Stretch := True;
      except
        on E: Exception do
          ShowMessage('Não foi possível carregar a foto: ' + E.Message);
      end;
    end;

    FEditando := False;
  end;
end;

procedure TPesqsCliente.BntSelecionarClick(Sender: TObject);
begin
  PreencherCadastro;
  ModalResult := mrOk;
end;

procedure TPesqsCliente.GridClientesDblClick(Sender: TObject);
begin
  BntSelecionarClick(Sender);
end;

procedure TPesqsCliente.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  GridClientes.DataSource := nil;
  DataSource1.DataSet     := nil;
  DataModule1.QryClientes.Close;
  Action := caHide;
end;

end.
