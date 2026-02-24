unit Compras;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Data.DB, Vcl.ComCtrls, Vcl.StdCtrls, Vcl.Grids, Vcl.DBGrids,
  Vcl.ExtCtrls, Banco;

type
  TTelaCompras = class(TForm)
    PnlFundo: TPanel;
    EbData: TLabel;
    LbNumCompra: TLabel;
    LbProduto: TLabel;
    LbQuantidade: TLabel;
    LbValorUnit: TLabel;
    LbDescItem: TLabel;
    LbValorTotal: TLabel;
    PnlDivisao: TPanel;
    PnlGrid: TPanel;
    LbItensCompras: TLabel;
    GridCompras: TDBGrid;
    PnlTotalCompra: TPanel;
    LbTotalCompra: TLabel;
    EdNumCompra: TEdit;
    EdVlrUnit: TEdit;
    EdQuantidade: TEdit;
    EdProduto: TEdit;
    EdDesconto: TEdit;
    EdValorTotal: TEdit;
    BtnAdicionar: TButton;
    BtnLimpar: TButton;
    BtnFinalizar: TButton;
    EdTotalCompra: TEdit;
    DTPData: TDateTimePicker;
    DataSource1: TDataSource;
    LbInformacao: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure BtnAdicionarClick(Sender: TObject);
    procedure BtnLimparClick(Sender: TObject);
    procedure BtnFinalizarClick(Sender: TObject);
    procedure EdProdutoKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure GridComprasDblClick(Sender: TObject);
    procedure EdQuantidadeChange(Sender: TObject);
    procedure EdVlrUnitChange(Sender: TObject);
    procedure EdDescontoChange(Sender: TObject);
    procedure BloquearFocoEdit(Sender: TObject);
    procedure BloquearCliqueEdit(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    FIDProdutoAtual: Integer;
    procedure ConfigurarGrid;
    procedure GerarNumeroCompra;
    procedure CalcularTotalItem;
    procedure AtualizarTotalCompra;
    procedure AtualizarStatusFinalizar;
    function ValidarItem: Boolean;
    procedure LimparCamposProduto;
    procedure LimparTodaTela;
    procedure CarregarItens;
    procedure AumentarEstoque;
    procedure DevolverEstoque(Qtd: Integer; IDProduto: Integer);
  public
  end;

var
  TelaCompras: TTelaCompras;

implementation

{$R *.dfm}

uses PesqProdutos;

procedure TTelaCompras.FormCreate(Sender: TObject);
begin
  DTPData.Date         := Date;
  EdTotalCompra.Text   := '0,00';
  EdNumCompra.Text     := '';
  BtnFinalizar.Enabled := False;
  FIDProdutoAtual      := 0;

  DataSource1.DataSet      := DataModule1.QryItensCompra;
  GridCompras.DataSource   := DataSource1;

  ConfigurarGrid;
end;

procedure TTelaCompras.ConfigurarGrid;
begin
  GridCompras.Columns.Clear;

  with GridCompras.Columns.Add do
  begin
    FieldName     := 'PRODUTO';
    Title.Caption := 'Produto';
    Width         := 200;
  end;

  with GridCompras.Columns.Add do
  begin
    FieldName     := 'QTD';
    Title.Caption := 'Quant.';
    Width         := 60;
  end;

  with GridCompras.Columns.Add do
  begin
    FieldName     := 'VL_UNIT';
    Title.Caption := 'Vlr Unit.';
    Width         := 80;
  end;

  with GridCompras.Columns.Add do
  begin
    FieldName     := 'DESC_ITEM';
    Title.Caption := 'Desc.';
    Width         := 60;
  end;

  with GridCompras.Columns.Add do
  begin
    FieldName     := 'VL_TOTAL';
    Title.Caption := 'Total';
    Width         := 80;
  end;
end;

procedure TTelaCompras.GerarNumeroCompra;
begin
  with DataModule1.QryCompras do
  begin
    Close;
    SQL.Text := 'SELECT COALESCE(MAX(ID),0)+1 AS PROXIMO FROM COMPRAS';
    Open;
    EdNumCompra.Text := FieldByName('PROXIMO').AsString;

    Close;
    SQL.Text :=
      'INSERT INTO COMPRAS (ID, DATA, TOTAL) ' +
      'VALUES (:ID, :DATA, :TOTAL)';
    ParamByName('ID').AsInteger  := StrToIntDef(EdNumCompra.Text, 0);
    ParamByName('DATA').AsDate   := DTPData.Date;
    ParamByName('TOTAL').AsFloat := 0;
    ExecSQL;
  end;
end;

procedure TTelaCompras.CarregarItens;
begin
  with DataModule1.QryItensCompra do
  begin
    Close;
    SQL.Text :=
      'SELECT ID, PRODUTO, QTD, VL_UNIT, DESC_ITEM, VL_TOTAL ' +
      'FROM ITENS_COMPRA WHERE NUM_COMPRA = :ID';
    ParamByName('ID').AsInteger := StrToIntDef(EdNumCompra.Text, 0);
    Open;
  end;
end;

procedure TTelaCompras.CalcularTotalItem;
var
  Qtd: Integer;
  VlrUnit, Desc, Total: Double;
begin
  Qtd     := StrToIntDef(EdQuantidade.Text, 0);
  VlrUnit := StrToFloatDef(EdVlrUnit.Text, 0);
  Desc    := StrToFloatDef(EdDesconto.Text, 0);

  if Desc < 0    then Desc    := 0;
  if VlrUnit < 0 then VlrUnit := 0;
  if Qtd < 0     then Qtd     := 0;

  Total := Qtd * (VlrUnit - Desc);
  if Total < 0 then Total := 0;

  EdValorTotal.Text := FormatFloat('0.00', Total);
end;

procedure TTelaCompras.EdQuantidadeChange(Sender: TObject);
begin
  CalcularTotalItem;
end;

procedure TTelaCompras.EdVlrUnitChange(Sender: TObject);
begin
  CalcularTotalItem;
end;

procedure TTelaCompras.EdDescontoChange(Sender: TObject);
begin
  CalcularTotalItem;
end;

procedure TTelaCompras.AtualizarTotalCompra;
begin
  with DataModule1.QryCompras do
  begin
    Close;
    SQL.Text :=
      'SELECT COALESCE(SUM(VL_TOTAL),0) AS TOTAL ' +
      'FROM ITENS_COMPRA WHERE NUM_COMPRA = :ID';
    ParamByName('ID').AsInteger := StrToIntDef(EdNumCompra.Text, 0);
    Open;
    EdTotalCompra.Text := FormatFloat('0.00', FieldByName('TOTAL').AsFloat);
  end;
end;

procedure TTelaCompras.AtualizarStatusFinalizar;
begin
  BtnFinalizar.Enabled := (StrToFloatDef(EdTotalCompra.Text, 0) > 0);
end;

function TTelaCompras.ValidarItem: Boolean;
var
  Qtd: Integer;
  Desc, VlrUnit: Double;
begin
  Result := False;

  if Trim(EdProduto.Text) = '' then
  begin
    ShowMessage('Selecione um produto.');
    Exit;
  end;

  Qtd := StrToIntDef(EdQuantidade.Text, -1);
  if Qtd <= 0 then
  begin
    ShowMessage('Quantidade deve ser maior que zero.');
    Exit;
  end;

  VlrUnit := StrToFloatDef(EdVlrUnit.Text, -1);
  if VlrUnit <= 0 then
  begin
    ShowMessage('Valor unitário deve ser maior que zero.');
    Exit;
  end;

  Desc := StrToFloatDef(EdDesconto.Text, -1);
  if Desc < 0 then
  begin
    ShowMessage('Desconto não pode ser negativo.');
    Exit;
  end;

  if Desc > VlrUnit then
  begin
    ShowMessage('Desconto não pode ser maior que o valor unitário.');
    Exit;
  end;

  Result := True;
end;

procedure TTelaCompras.AumentarEstoque;
begin
  with DataModule1.QryProdutos do
  begin
    Close;
    SQL.Text :=
      'UPDATE PRODUTOS SET ESTOQUE = ESTOQUE + :QTD WHERE ID = :ID';
    ParamByName('QTD').AsInteger := StrToIntDef(EdQuantidade.Text, 0);
    ParamByName('ID').AsInteger  := FIDProdutoAtual;
    ExecSQL;
  end;
end;

procedure TTelaCompras.DevolverEstoque(Qtd: Integer; IDProduto: Integer);
begin
  with DataModule1.QryProdutos do
  begin
    Close;
    SQL.Text :=
      'UPDATE PRODUTOS SET ESTOQUE = ESTOQUE - :QTD WHERE ID = :ID';
    ParamByName('QTD').AsInteger := Qtd;
    ParamByName('ID').AsInteger  := IDProduto;
    ExecSQL;
  end;
end;

procedure TTelaCompras.BtnAdicionarClick(Sender: TObject);
begin
  if not ValidarItem then Exit;

  if Trim(EdNumCompra.Text) = '' then
    GerarNumeroCompra;

  CalcularTotalItem;
  AumentarEstoque;

  with DataModule1.QryItensCompra do
  begin
    Close;
    SQL.Text :=
      'INSERT INTO ITENS_COMPRA (NUM_COMPRA, PRODUTO, QTD, VL_UNIT, DESC_ITEM, VL_TOTAL) ' +
      'VALUES (:NUM, :PROD, :QTD, :UNIT, :DESC, :TOTAL)';
    ParamByName('NUM').AsInteger  := StrToIntDef(EdNumCompra.Text, 0);
    ParamByName('PROD').AsString  := EdProduto.Text;
    ParamByName('QTD').AsInteger  := StrToIntDef(EdQuantidade.Text, 0);
    ParamByName('UNIT').AsFloat   := StrToFloatDef(EdVlrUnit.Text, 0);
    ParamByName('DESC').AsFloat   := StrToFloatDef(EdDesconto.Text, 0);
    ParamByName('TOTAL').AsFloat  := StrToFloatDef(EdValorTotal.Text, 0);
    ExecSQL;
  end;

  CarregarItens;
  AtualizarTotalCompra;
  AtualizarStatusFinalizar;
  LimparCamposProduto;
end;

procedure TTelaCompras.BtnLimparClick(Sender: TObject);
begin
  LimparCamposProduto;
end;

procedure TTelaCompras.LimparCamposProduto;
begin
  EdProduto.Clear;
  EdQuantidade.Clear;
  EdVlrUnit.Clear;
  EdDesconto.Clear;
  EdValorTotal.Clear;
  FIDProdutoAtual := 0;
end;

procedure TTelaCompras.LimparTodaTela;
begin
  EdNumCompra.Clear;
  LimparCamposProduto;
  EdTotalCompra.Text   := '0,00';
  DTPData.Date         := Date;
  BtnFinalizar.Enabled := False;
  FIDProdutoAtual      := 0;
  DataModule1.QryItensCompra.Close;
end;

procedure TTelaCompras.BtnFinalizarClick(Sender: TObject);
begin
  if not BtnFinalizar.Enabled then Exit;

  with DataModule1.QryCompras do
  begin
    Close;
    SQL.Text :=
      'UPDATE COMPRAS SET DATA = :DATA, TOTAL = :TOTAL WHERE ID = :ID';
    ParamByName('ID').AsInteger  := StrToIntDef(EdNumCompra.Text, 0);
    ParamByName('DATA').AsDate   := DTPData.Date;
    ParamByName('TOTAL').AsFloat := StrToFloatDef(EdTotalCompra.Text, 0);
    ExecSQL;
  end;

  ShowMessage('Compra finalizada com sucesso!');
  LimparTodaTela;
end;

procedure TTelaCompras.GridComprasDblClick(Sender: TObject);
var
  IDItem, QtdItem, IDProduto: Integer;
begin
  if DataModule1.QryItensCompra.IsEmpty then Exit;

  if MessageDlg('Excluir item?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    IDItem  := DataModule1.QryItensCompra.FieldByName('ID').AsInteger;
    QtdItem := DataModule1.QryItensCompra.FieldByName('QTD').AsInteger;

    with DataModule1.QryProdutos do
    begin
      Close;
      SQL.Text := 'SELECT ID FROM PRODUTOS WHERE DESCRICAO = :PROD';
      ParamByName('PROD').AsString :=
        DataModule1.QryItensCompra.FieldByName('PRODUTO').AsString;
      Open;
      IDProduto := FieldByName('ID').AsInteger;
      Close;
    end;

    DevolverEstoque(QtdItem, IDProduto);

    with DataModule1.QryItensCompra do
    begin
      Close;
      SQL.Text := 'DELETE FROM ITENS_COMPRA WHERE ID = :ID';
      ParamByName('ID').AsInteger := IDItem;
      ExecSQL;
    end;

    CarregarItens;
    AtualizarTotalCompra;
    AtualizarStatusFinalizar;
  end;
end;

procedure TTelaCompras.EdProdutoKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_F2 then
  begin
    if PesqsProdutos = nil then
      PesqsProdutos := TPesqsProdutos.Create(Application);

    if PesqsProdutos.ShowModal = mrOk then
      if not DataModule1.QryProdutos.IsEmpty then
      begin
        EdProduto.Text  := DataModule1.QryProdutos.FieldByName('DESCRICAO').AsString;
        EdVlrUnit.Text  := FormatFloat('0.00',
          DataModule1.QryProdutos.FieldByName('VALOR_UNITARIO').AsFloat);
        FIDProdutoAtual := DataModule1.QryProdutos.FieldByName('ID').AsInteger;
        EdQuantidade.SetFocus;
      end;

    FreeAndNil(PesqsProdutos);
  end;
end;

procedure TTelaCompras.BloquearFocoEdit(Sender: TObject);
begin
  ActiveControl := nil;
end;

procedure TTelaCompras.BloquearCliqueEdit(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  ActiveControl := nil;
end;

end.
