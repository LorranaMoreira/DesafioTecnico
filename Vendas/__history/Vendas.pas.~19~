unit Vendas;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.ComCtrls, Vcl.Grids,
  Vcl.DBGrids, Vcl.StdCtrls, Vcl.ExtCtrls, Banco;

type
  TTelaVendas = class(TForm)
    PnlFundo: TPanel;
    PnlDivisao: TPanel;
    PnlCupom: TPanel;
    PnlTotalVendas: TPanel;
    LbData: TLabel;
    LbNomeCliente: TLabel;
    LbNumVenda: TLabel;
    EdNomeCliente: TEdit;
    EdNumVenda: TEdit;
    EdVlrUnit: TEdit;
    EdQuantidade: TEdit;
    EdProduto: TEdit;
    EdDescItem: TEdit;
    EdVlrTotalItem: TEdit;
    LbProduto: TLabel;
    LbQuantidade: TLabel;
    LbVlrUnit: TLabel;
    LbDescItem: TLabel;
    LbVlrTotalItem: TLabel;
    BtnAdicionar: TButton;
    BtnLimpar: TButton;
    BtnFinalizar: TButton;
    LbCupom: TLabel;
    GridVendas: TDBGrid;
    EdTotalVenda: TEdit;
    EdTotalVendas: TLabel;
    DTPData: TDateTimePicker;
    DSVendas: TDataSource;
    Label1: TLabel;
    Label2: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure BtnAdicionarClick(Sender: TObject);
    procedure BtnLimparClick(Sender: TObject);
    procedure BtnFinalizarClick(Sender: TObject);
    procedure EdNomeClienteKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure EdProdutoKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure GridVendasDblClick(Sender: TObject);
    procedure BloquearFocoEdit(Sender: TObject);
    procedure BloquearCliqueEdit(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure EdQuantidadeChange(Sender: TObject);
    procedure EdDescItemChange(Sender: TObject);
  private
    FIDProdutoAtual: Integer;
    procedure CalcularTotalItem;
    procedure AtualizarTotalVenda;
    function ValidarItem: Boolean;
    procedure GerarVendaInicial;
    procedure AtualizarStatusFinalizar;
    procedure CarregarItens;
    procedure ConfigurarGrid;
    procedure LimparTela;
    function VerificarEstoque: Boolean;
    procedure BaixarEstoque;
    procedure DevolverEstoque(Qtd: Integer; IDProduto: Integer);
  public
  end;

var
  TelaVendas: TTelaVendas;

implementation

{$R *.dfm}

uses PesqClientes, PesqProdutos;

{ ================= ESTOQUE ================= }

function TTelaVendas.VerificarEstoque: Boolean;
var
  EstoqueAtual, QtdSolicitada: Integer;
begin
  Result := False;

  QtdSolicitada := StrToIntDef(EdQuantidade.Text, 0);

  if FIDProdutoAtual <= 0 then
  begin
    ShowMessage('Selecione um produto válido.');
    Exit;
  end;

  with DataModule1.QryProdutos do
  begin
    Close;
    SQL.Text := 'SELECT ESTOQUE FROM PRODUTOS WHERE ID = :ID';
    ParamByName('ID').AsInteger := FIDProdutoAtual;
    Open;

    if IsEmpty then
    begin
      ShowMessage('Produto não encontrado.');
      Close;
      Exit;
    end;

    EstoqueAtual := FieldByName('ESTOQUE').AsInteger;
    Close;

    if EstoqueAtual < QtdSolicitada then
    begin
      ShowMessage('Estoque insuficiente. Disponível: ' + IntToStr(EstoqueAtual));
      Exit;
    end;
  end;

  Result := True;
end;

procedure TTelaVendas.BaixarEstoque;
begin
  with DataModule1.QryProdutos do
  begin
    Close;
    SQL.Text :=
      'UPDATE PRODUTOS SET ESTOQUE = ESTOQUE - :QTD WHERE ID = :ID';
    ParamByName('QTD').AsInteger := StrToIntDef(EdQuantidade.Text, 0);
    ParamByName('ID').AsInteger  := FIDProdutoAtual;
    ExecSQL;
  end;
end;

procedure TTelaVendas.DevolverEstoque(Qtd: Integer; IDProduto: Integer);
begin
  with DataModule1.QryProdutos do
  begin
    Close;
    SQL.Text :=
      'UPDATE PRODUTOS SET ESTOQUE = ESTOQUE + :QTD WHERE ID = :ID';
    ParamByName('QTD').AsInteger := Qtd;
    ParamByName('ID').AsInteger  := IDProduto;
    ExecSQL;
  end;
end;

{ ================= FORM ================= }

procedure TTelaVendas.FormCreate(Sender: TObject);
begin
  DTPData.Date         := Date;
  EdTotalVenda.Text    := '0,00';
  BtnFinalizar.Enabled := False;
  FIDProdutoAtual      := 0;

  DSVendas.DataSet      := DataModule1.QryItensVenda;
  GridVendas.DataSource := DSVendas;

  ConfigurarGrid;
end;

procedure TTelaVendas.LimparTela;
begin
  EdNomeCliente.Clear;
  EdNumVenda.Clear;
  EdProduto.Clear;
  EdQuantidade.Clear;
  EdVlrUnit.Clear;
  EdDescItem.Clear;
  EdVlrTotalItem.Clear;
  EdTotalVenda.Text    := '0,00';
  DTPData.Date         := Date;
  BtnFinalizar.Enabled := False;
  FIDProdutoAtual      := 0;

  DataModule1.QryItensVenda.Close;
end;

procedure TTelaVendas.GerarVendaInicial;
begin
  with DataModule1.QryVendas do
  begin
    Close;
    SQL.Text := 'SELECT COALESCE(MAX(ID),0)+1 AS PROXIMO FROM VENDAS';
    Open;
    EdNumVenda.Text := FieldByName('PROXIMO').AsString;

    Close;
    SQL.Text :=
      'INSERT INTO VENDAS (ID, DATA, CLIENTE, TOTAL) ' +
      'VALUES (:ID, :DATA, :CLI, :TOTAL)';
    ParamByName('ID').AsInteger  := StrToIntDef(EdNumVenda.Text, 0);
    ParamByName('DATA').AsDate   := DTPData.Date;
    ParamByName('CLI').AsString  := EdNomeCliente.Text;
    ParamByName('TOTAL').AsFloat := 0;
    ExecSQL;
  end;
end;

procedure TTelaVendas.CarregarItens;
begin
  with DataModule1.QryItensVenda do
  begin
    Close;
    SQL.Text :=
      'SELECT ID, PRODUTO, QTD, VL_UNIT, DESC_ITEM, VL_TOTAL ' +
      'FROM ITENS_VENDA WHERE NUM_VENDA = :ID';
    ParamByName('ID').AsInteger := StrToIntDef(EdNumVenda.Text, 0);
    Open;
  end;
end;

procedure TTelaVendas.CalcularTotalItem;
var
  Qtd: Integer;
  VlrUnit, Desc, Total: Double;
begin
  Qtd     := StrToIntDef(EdQuantidade.Text, 0);
  VlrUnit := StrToFloatDef(EdVlrUnit.Text, 0);
  Desc    := StrToFloatDef(EdDescItem.Text, 0);

  if Desc < 0    then Desc    := 0;
  if VlrUnit < 0 then VlrUnit := 0;
  if Qtd < 0     then Qtd     := 0;

  Total := Qtd * (VlrUnit - Desc);
  if Total < 0 then Total := 0;

  EdVlrTotalItem.Text := FormatFloat('0.00', Total);
end;

procedure TTelaVendas.EdQuantidadeChange(Sender: TObject);
begin
  CalcularTotalItem;
end;

procedure TTelaVendas.EdDescItemChange(Sender: TObject);
begin
  CalcularTotalItem;
end;

function TTelaVendas.ValidarItem: Boolean;
var
  Qtd: Integer;
  Desc, VlrUnit: Double;
begin
  Result := False;

  if Trim(EdNomeCliente.Text) = '' then
  begin
    ShowMessage('Selecione um cliente.');
    Exit;
  end;

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
  if VlrUnit < 0 then
  begin
    ShowMessage('Valor unitário inválido.');
    Exit;
  end;

  Desc := StrToFloatDef(EdDescItem.Text, -1);
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

procedure TTelaVendas.BtnAdicionarClick(Sender: TObject);
begin
  if not ValidarItem then Exit;
  if not VerificarEstoque then Exit;

  if Trim(EdNumVenda.Text) = '' then
    GerarVendaInicial;

  CalcularTotalItem;
  BaixarEstoque;

  with DataModule1.QryItensVenda do
  begin
    Close;
    SQL.Text :=
      'INSERT INTO ITENS_VENDA (NUM_VENDA, PRODUTO, QTD, VL_UNIT, DESC_ITEM, VL_TOTAL) ' +
      'VALUES (:ID, :PROD, :QTD, :UNIT, :DESC, :TOTAL)';
    ParamByName('ID').AsInteger  := StrToIntDef(EdNumVenda.Text, 0);
    ParamByName('PROD').AsString := EdProduto.Text;
    ParamByName('QTD').AsInteger := StrToIntDef(EdQuantidade.Text, 0);
    ParamByName('UNIT').AsFloat  := StrToFloatDef(EdVlrUnit.Text, 0);
    ParamByName('DESC').AsFloat  := StrToFloatDef(EdDescItem.Text, 0);
    ParamByName('TOTAL').AsFloat := StrToFloatDef(EdVlrTotalItem.Text, 0);
    ExecSQL;
  end;

  CarregarItens;
  AtualizarTotalVenda;
  AtualizarStatusFinalizar;
  BtnLimparClick(nil);
end;

procedure TTelaVendas.AtualizarTotalVenda;
begin
  with DataModule1.QryVendas do
  begin
    Close;
    SQL.Text :=
      'SELECT COALESCE(SUM(VL_TOTAL),0) AS TOTAL ' +
      'FROM ITENS_VENDA WHERE NUM_VENDA = :NUM_VENDA';
    ParamByName('NUM_VENDA').AsInteger := StrToIntDef(EdNumVenda.Text, 0);
    Open;
    EdTotalVenda.Text := FormatFloat('0.00', FieldByName('TOTAL').AsFloat);
  end;
end;

procedure TTelaVendas.AtualizarStatusFinalizar;
begin
  BtnFinalizar.Enabled := (StrToFloatDef(EdTotalVenda.Text, 0) > 0);
end;

procedure TTelaVendas.BtnLimparClick(Sender: TObject);
begin
  EdProduto.Clear;
  EdQuantidade.Clear;
  EdVlrUnit.Clear;
  EdDescItem.Clear;
  EdVlrTotalItem.Clear;
  FIDProdutoAtual := 0;
end;

procedure TTelaVendas.BtnFinalizarClick(Sender: TObject);
begin
  if not BtnFinalizar.Enabled then Exit;

  with DataModule1.QryVendas do
  begin
    Close;
    SQL.Text :=
      'UPDATE VENDAS SET DATA = :DATA, CLIENTE = :CLI, TOTAL = :TOTAL ' +
      'WHERE ID = :ID';
    ParamByName('ID').AsInteger  := StrToIntDef(EdNumVenda.Text, 0);
    ParamByName('DATA').AsDate   := DTPData.Date;
    ParamByName('CLI').AsString  := EdNomeCliente.Text;
    ParamByName('TOTAL').AsFloat := StrToFloatDef(EdTotalVenda.Text, 0);
    ExecSQL;
  end;

  ShowMessage('Venda finalizada!');
  LimparTela;
end;

procedure TTelaVendas.GridVendasDblClick(Sender: TObject);
var
  IDItem, QtdItem, IDProduto: Integer;
begin
  if DataModule1.QryItensVenda.IsEmpty then Exit;

  if MessageDlg('Excluir item?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    IDItem  := DataModule1.QryItensVenda.FieldByName('ID').AsInteger;
    QtdItem := DataModule1.QryItensVenda.FieldByName('QTD').AsInteger;

    with DataModule1.QryProdutos do
    begin
      Close;
      SQL.Text := 'SELECT ID FROM PRODUTOS WHERE DESCRICAO = :PROD';
      ParamByName('PROD').AsString :=
        DataModule1.QryItensVenda.FieldByName('PRODUTO').AsString;
      Open;
      IDProduto := FieldByName('ID').AsInteger;
      Close;
    end;

    DevolverEstoque(QtdItem, IDProduto);

    with DataModule1.QryItensVenda do
    begin
      Close;
      SQL.Text := 'DELETE FROM ITENS_VENDA WHERE ID = :ID';
      ParamByName('ID').AsInteger := IDItem;
      ExecSQL;
    end;

    CarregarItens;
    AtualizarTotalVenda;
    AtualizarStatusFinalizar;
  end;
end;

procedure TTelaVendas.ConfigurarGrid;
begin
  GridVendas.Columns.Clear;

  with GridVendas.Columns.Add do
  begin
    FieldName     := 'PRODUTO';
    Title.Caption := 'Produto';
    Width         := 200;
  end;

  with GridVendas.Columns.Add do
  begin
    FieldName     := 'QTD';
    Title.Caption := 'Quant.';
    Width         := 60;
  end;

  with GridVendas.Columns.Add do
  begin
    FieldName     := 'VL_UNIT';
    Title.Caption := 'Vlr Unit.';
    Width         := 80;
  end;

  with GridVendas.Columns.Add do
  begin
    FieldName     := 'DESC_ITEM';
    Title.Caption := 'Desc.';
    Width         := 60;
  end;

  with GridVendas.Columns.Add do
  begin
    FieldName     := 'VL_TOTAL';
    Title.Caption := 'Total';
    Width         := 80;
  end;
end;

procedure TTelaVendas.EdNomeClienteKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_F2 then
  begin
    if PesqsCliente = nil then
      PesqsCliente := TPesqsCliente.Create(Application);

    if PesqsCliente.ShowModal = mrOk then
      if not DataModule1.QryClientes.IsEmpty then
        EdNomeCliente.Text := DataModule1.QryClientes.FieldByName('NOME').AsString;

    FreeAndNil(PesqsCliente);
  end;
end;

procedure TTelaVendas.EdProdutoKeyDown(Sender: TObject; var Key: Word;
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

procedure TTelaVendas.BloquearFocoEdit(Sender: TObject);
begin
  ActiveControl := nil;
end;

procedure TTelaVendas.BloquearCliqueEdit(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  ActiveControl := nil;
end;

end.
