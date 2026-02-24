unit PesqProdutos;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.StdCtrls,
  Vcl.Grids, Vcl.DBGrids, Vcl.ExtCtrls, Banco;

type
  TPesqsProdutos = class(TForm)
    PnlFundo: TPanel;
    LbProdutos: TLabel;
    GridProdutos: TDBGrid;
    BtnSelecionar: TButton;
    DataSource1: TDataSource;
    procedure FormShow(Sender: TObject);
    procedure BtnSelecionarClick(Sender: TObject);
    procedure GridProdutosDblClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    FCadOrigem: TForm;
    procedure PreencherCadastro;
    procedure ConfigurarGrid;
  public
    property CadOrigem: TForm write FCadOrigem;
  end;

var
  PesqsProdutos: TPesqsProdutos;

implementation

uses CadsProdutos;

{$R *.dfm}

procedure TPesqsProdutos.ConfigurarGrid;
begin
  GridProdutos.Columns.Clear;

  with GridProdutos.Columns.Add do
  begin
    FieldName     := 'ID';
    Title.Caption := 'Cód.';
    Width         := 50;
  end;

  with GridProdutos.Columns.Add do
  begin
    FieldName     := 'DESCRICAO';
    Title.Caption := 'Descrição';
    Width         := 200;
  end;

  with GridProdutos.Columns.Add do
  begin
    FieldName     := 'MARCA';
    Title.Caption := 'Marca';
    Width         := 100;
  end;

  with GridProdutos.Columns.Add do
  begin
    FieldName     := 'ESTOQUE';
    Title.Caption := 'Estoque';
    Width         := 70;
  end;

  with GridProdutos.Columns.Add do
  begin
    FieldName     := 'VALOR_UNITARIO';
    Title.Caption := 'Vlr Unit.';
    Width         := 80;
  end;
end;

procedure TPesqsProdutos.FormShow(Sender: TObject);
begin
  DataSource1.DataSet     := DataModule1.QryProdutos;
  GridProdutos.DataSource := DataSource1;

  with DataModule1.QryProdutos do
  begin
    Close;
    SQL.Clear;
    SQL.Text :=
      'SELECT ID, DESCRICAO, MARCA, ESTOQUE, VALOR_UNITARIO, FOTO ' +
      'FROM PRODUTOS ORDER BY DESCRICAO';
    Open;
  end;

  ConfigurarGrid;
end;

procedure TPesqsProdutos.PreencherCadastro;
var
  Stream: TMemoryStream;
  Blob: TBlobField;
  Cad: TCadProdutos;
begin
  if DataModule1.QryProdutos.IsEmpty then Exit;

  if Assigned(FCadOrigem) and (FCadOrigem is TCadProdutos) then
    Cad := TCadProdutos(FCadOrigem)
  else if Assigned(CadProdutos) then
    Cad := CadProdutos
  else
    Exit;

  Cad.EDCodigo.Text    := DataModule1.QryProdutos.FieldByName('ID').AsString;
  Cad.EdDescricao.Text := DataModule1.QryProdutos.FieldByName('DESCRICAO').AsString;
  Cad.EditMarca.Text   := DataModule1.QryProdutos.FieldByName('MARCA').AsString;
  Cad.EDEstoque.Text   := DataModule1.QryProdutos.FieldByName('ESTOQUE').AsString;
  Cad.EDVlrUnit.Text   := FormatFloat('0.00',
    DataModule1.QryProdutos.FieldByName('VALOR_UNITARIO').AsFloat);

  Cad.ImgFoto.Picture := nil;
  Blob := DataModule1.QryProdutos.FieldByName('FOTO') as TBlobField;
  if (Blob <> nil) and (not Blob.IsNull) then
  begin
    Stream := TMemoryStream.Create;
    try
      Blob.SaveToStream(Stream);
      Stream.Position := 0;
      Cad.ImgFoto.Picture.LoadFromStream(Stream);
      Cad.ImgFoto.Stretch := True;
    finally
      Stream.Free;
    end;
  end;

  Cad.BtnSalvar.Enabled := False;
  Cad.BtnEditar.Enabled := True;
  Cad.HabilitarCampos(False);
end;

procedure TPesqsProdutos.BtnSelecionarClick(Sender: TObject);
begin
  PreencherCadastro;
  ModalResult := mrOk;
end;

procedure TPesqsProdutos.GridProdutosDblClick(Sender: TObject);
begin
  BtnSelecionarClick(Sender);
end;

procedure TPesqsProdutos.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  GridProdutos.DataSource := nil;
  DataSource1.DataSet     := nil;
  DataModule1.QryProdutos.Close;
  Action          := caFree;
  PesqsProdutos   := nil;
end;

end.
