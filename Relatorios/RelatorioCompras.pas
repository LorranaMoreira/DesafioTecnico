unit RelatorioCompras;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls,
  Data.DB, Banco, frxClass, frxDBSet, frxExportPDF, frxExportBaseDialog, ShellAPI;

type
  TRelatCompras = class(TForm)
    PnlFundo: TPanel;
    LbDataInicio: TLabel;
    LbDataFim: TLabel;
    LbExportar: TLabel;
    DTPDataInicio: TDateTimePicker;
    DTPDataFim: TDateTimePicker;
    PnlRodape: TPanel;
    BtnGerar: TButton;
    CbExportar: TComboBox;
    frxReport1: TfrxReport;
    frxDBDataset1: TfrxDBDataset;
    frxPDFExport1: TfrxPDFExport;
    BtnLimpar: TButton;

    procedure FormCreate(Sender: TObject);
    procedure BtnGerarClick(Sender: TObject);
    procedure BtnLimparClick(Sender: TObject);
  private
    procedure VisualizarRelatorio;
    procedure ExportarPDF;
    function ValidarDatas: Boolean;
    procedure CarregarDados;
  public
    { Public declarations }
  end;

var
  RelatCompras: TRelatCompras;

implementation

{$R *.dfm}

procedure TRelatCompras.FormCreate(Sender: TObject);
begin
  // Configura datas padrão (último mês)
  DTPDataFim.Date := Date;
  DTPDataInicio.Date := Date - 30;

  // Configura ComboBox de exportação
  CbExportar.Items.Clear;
  CbExportar.Items.Add('Visualizar na Tela');
  CbExportar.Items.Add('Exportar PDF');
  CbExportar.ItemIndex := 0;
end;

function TRelatCompras.ValidarDatas: Boolean;
begin
  Result := False;

  if DTPDataInicio.Date > DTPDataFim.Date then
  begin
    ShowMessage('A data inicial não pode ser maior que a data final.');
    DTPDataInicio.SetFocus;
    Exit;
  end;

  Result := True;
end;

procedure TRelatCompras.CarregarDados;
begin
  try
    with DataModule1.QryRelatorios do
    begin
      Close;
      SQL.Clear;
      SQL.Text :=
        'SELECT C.ID, C.DATA, C.TOTAL, ' +
        '       IC.PRODUTO, IC.QTD, IC.VL_UNIT, IC.DESC_ITEM, IC.VL_TOTAL ' +
        'FROM COMPRAS C ' +
        'LEFT JOIN ITENS_COMPRA IC ON C.ID = IC.NUM_COMPRA ' +
        'WHERE C.DATA BETWEEN :DTINI AND :DTFIM ' +
        'ORDER BY C.DATA DESC, C.ID, IC.ID';
      ParamByName('DTINI').AsDate := DTPDataInicio.Date;
      ParamByName('DTFIM').AsDate := DTPDataFim.Date;
      Open;
    end;

    if DataModule1.QryRelatorios.IsEmpty then
    begin
      ShowMessage('Nenhuma compra encontrada no período selecionado.');
      Exit;
    end;

    // Configura o dataset do FastReport
    frxDBDataset1.DataSet := DataModule1.QryRelatorios;

  except
    on E: Exception do
      ShowMessage('Erro ao carregar dados: ' + E.Message);
  end;
end;

procedure TRelatCompras.BtnGerarClick(Sender: TObject);
begin
  if not ValidarDatas then Exit;

  CarregarDados;

  if DataModule1.QryRelatorios.IsEmpty then
    Exit;

  // Executa conforme opção selecionada
  case CbExportar.ItemIndex of
    0: VisualizarRelatorio;
    1: ExportarPDF;
  end;
end;

procedure TRelatCompras.VisualizarRelatorio;
var
  CaminhoRelatorio: string;
begin
  try
    CaminhoRelatorio := ExtractFilePath(Application.ExeName) + 'Relatorios\RelCompras.fr3';

    // Verifica se o arquivo existe
    if not FileExists(CaminhoRelatorio) then
    begin
      ShowMessage('Arquivo de relatório não encontrado!' + #13#10 +
                  'Caminho: ' + CaminhoRelatorio + #13#10#13#10 +
                  'Certifique-se de que o arquivo RelCompras.fr3 existe na pasta Relatorios.');
      Exit;
    end;

    // Carrega e visualiza o relatório
    frxReport1.LoadFromFile(CaminhoRelatorio);
    frxReport1.ShowReport;

  except
    on E: Exception do
      ShowMessage('Erro ao visualizar relatório: ' + E.Message);
  end;
end;

procedure TRelatCompras.ExportarPDF;
var
  SaveDialog: TSaveDialog;
  CaminhoArquivo: string;
  CaminhoRelatorio: string;
begin
  SaveDialog := TSaveDialog.Create(nil);
  try
    SaveDialog.Title := 'Salvar Relatório de Compras';
    SaveDialog.Filter := 'Arquivo PDF|*.pdf';
    SaveDialog.DefaultExt := 'pdf';
    SaveDialog.FileName := 'RelatorioCompras_' + FormatDateTime('ddmmyyyy', Date) + '.pdf';

    if SaveDialog.Execute then
    begin
      CaminhoArquivo := SaveDialog.FileName;
      CaminhoRelatorio := ExtractFilePath(Application.ExeName) + 'Relatorios\RelCompras.fr3';

      try
        // Verifica se o arquivo existe
        if not FileExists(CaminhoRelatorio) then
        begin
          ShowMessage('Arquivo de relatório não encontrado!' + #13#10 +
                      'Caminho: ' + CaminhoRelatorio + #13#10#13#10 +
                      'Certifique-se de que o arquivo RelCompras.fr3 existe na pasta Relatorios.');
          Exit;
        end;

        // Configura exportação PDF
        frxPDFExport1.FileName := CaminhoArquivo;
        frxPDFExport1.ShowDialog := False;
        frxPDFExport1.ShowProgress := True;

        // Carrega e processa o relatório
        frxReport1.LoadFromFile(CaminhoRelatorio);
        frxReport1.PrepareReport;
        frxReport1.Export(frxPDFExport1);

        ShowMessage('Relatório exportado com sucesso!' + #13#10 + CaminhoArquivo);

        // Pergunta se deseja abrir o arquivo
        if MessageDlg('Deseja abrir o arquivo agora?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
          ShellExecute(0, 'open', PChar(CaminhoArquivo), nil, nil, SW_SHOWNORMAL);

      except
        on E: Exception do
          ShowMessage('Erro ao exportar PDF: ' + E.Message);
      end;
    end;
  finally
    SaveDialog.Free;
  end;
end;

procedure TRelatCompras.BtnLimparClick(Sender: TObject);
begin
  DTPDataFim.Date := Date;
  DTPDataInicio.Date := Date - 30;
  CbExportar.ItemIndex := 0;

  DataModule1.QryRelatorios.Close;
end;

end.
