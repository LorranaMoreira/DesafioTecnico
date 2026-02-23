unit CadsCep;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Banco, FireDAC.Comp.Client,
  FireDAC.Stan.Param, Data.DB, dxGDIPlusClasses,
  REST.Client, REST.Types, System.JSON, System.UITypes, Data.Bind.Components,
  Data.Bind.ObjectScope, Vcl.Buttons;

type
  TCadastroCep = class(TForm)
    PnlFundo: TPanel;
    LbCEP: TLabel;
    LbUF: TLabel;
    LbCidade: TLabel;
    LbLogradouro: TLabel;
    BtnSalvar: TButton;
    BtnLimpar: TButton;
    PnlEnunciado: TPanel;
    EdCEP: TEdit;
    EdLogradouro: TEdit;
    EdCidade: TEdit;
    ImgLogo: TImage;
    BtnBuscar: TButton;
    CbUF: TComboBox;
    TRESTClient: TRESTClient;
    RESTRequest1: TRESTRequest;
    RESTResponse1: TRESTResponse;
    BtnPesqCep: TButton;
    EdBairro: TEdit;
    EdNumero: TEdit;
    LbBairros: TLabel;
    LbNumero: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure BtnSalvarClick(Sender: TObject);
    procedure BtnLimparClick(Sender: TObject);
    procedure BtnBuscarClick(Sender: TObject);
    procedure ImgCepClick(Sender: TObject);
    procedure BtnPesqCepClick(Sender: TObject);
  private
    procedure LimparCampos;
    procedure BuscarCEP(const CEP: string);
  public
  end;

var
  CadastroCep: TCadastroCep;

implementation

{$R *.dfm}

uses PesqCeps;

procedure TCadastroCep.FormCreate(Sender: TObject);
begin
  CbUF.Items.Clear;
  CbUF.Items.Add('AC');
  CbUF.Items.Add('AL');
  CbUF.Items.Add('AP');
  CbUF.Items.Add('AM');
  CbUF.Items.Add('BA');
  CbUF.Items.Add('CE');
  CbUF.Items.Add('DF');
  CbUF.Items.Add('ES');
  CbUF.Items.Add('GO');
  CbUF.Items.Add('MA');
  CbUF.Items.Add('MT');
  CbUF.Items.Add('MS');
  CbUF.Items.Add('MG');
  CbUF.Items.Add('PA');
  CbUF.Items.Add('PB');
  CbUF.Items.Add('PR');
  CbUF.Items.Add('PE');
  CbUF.Items.Add('PI');
  CbUF.Items.Add('RJ');
  CbUF.Items.Add('RN');
  CbUF.Items.Add('RS');
  CbUF.Items.Add('RO');
  CbUF.Items.Add('RR');
  CbUF.Items.Add('SC');
  CbUF.Items.Add('SP');
  CbUF.Items.Add('SE');
  CbUF.Items.Add('TO');

  LimparCampos;
end;

procedure TCadastroCep.LimparCampos;
begin
  EdCEP.Clear;
  CbUF.ItemIndex := -1;
  EdCidade.Clear;
  EdLogradouro.Clear;
  EdBairro.Clear;
  EdNumero.Clear;
end;

procedure TCadastroCep.BuscarCEP(const CEP: string);
var
  JSONObj: TJSONObject;
  UF: string;
  Idx: Integer;
begin
  try
    TRESTClient.BaseURL   := 'https://viacep.com.br/ws/';
    RESTRequest1.Client   := TRESTClient;
    RESTRequest1.Response := RESTResponse1;
    RESTRequest1.Resource := CEP + '/json';
    RESTRequest1.Method   := rmGET;

    RESTRequest1.Execute;

    JSONObj := TJSONObject.ParseJSONValue(RESTResponse1.Content) as TJSONObject;
    try
      if Assigned(JSONObj) then
      begin
        if JSONObj.GetValue('erro') <> nil then
        begin
          ShowMessage('CEP não encontrado.');
          Exit;
        end;

        EdLogradouro.Text := JSONObj.GetValue<string>('logradouro');
        EdCidade.Text     := JSONObj.GetValue<string>('localidade');
        EdBairro.Text     := JSONObj.GetValue<string>('bairro');

        UF  := JSONObj.GetValue<string>('uf');
        Idx := CbUF.Items.IndexOf(UF);
        if Idx >= 0 then
          CbUF.ItemIndex := Idx
        else
          CbUF.Text := UF;
      end
      else
        ShowMessage('Não foi possível interpretar a resposta da API.');
    finally
      JSONObj.Free;
    end;

  except
    on E: Exception do
      ShowMessage('Erro ao consultar CEP: ' + E.Message);
  end;
end;

procedure TCadastroCep.BtnSalvarClick(Sender: TObject);
var
  CEP: string;
begin
  CEP := Trim(EdCEP.Text);

  if CEP = '' then
  begin
    ShowMessage('Digite um CEP válido.');
    Exit;
  end;

  try
    with DataModule1.QryCep do
    begin
      Close;
      SQL.Clear;
      SQL.Text := 'SELECT ID FROM CEP WHERE CEP = :CEP';
      ParamByName('CEP').AsString := CEP;
      Open;

      if not IsEmpty then
      begin
        ShowMessage('Este CEP já foi salvo anteriormente.');
        Close;
        Exit;
      end;

      Close;

      SQL.Clear;
      SQL.Text :=
        'INSERT INTO CEP (CEP, LOGRADOURO, CIDADE, UF, BAIRRO, NUMERO) ' +
        'VALUES (:CEP, :LOG, :CID, :UF, :BAIRRO, :NUM)';
      ParamByName('CEP').AsString    := CEP;
      ParamByName('LOG').AsString    := Trim(EdLogradouro.Text);
      ParamByName('CID').AsString    := Trim(EdCidade.Text);
      ParamByName('UF').AsString     := Trim(CbUF.Text);
      ParamByName('BAIRRO').AsString := Trim(EdBairro.Text);
      ParamByName('NUM').AsInteger   := StrToIntDef(Trim(EdNumero.Text), 0);
      ExecSQL;
    end;

    ShowMessage('CEP cadastrado com sucesso!');
    LimparCampos;

  except
    on E: Exception do
      ShowMessage('Erro ao cadastrar CEP: ' + E.Message);
  end;
end;

procedure TCadastroCep.BtnLimparClick(Sender: TObject);
begin
  if MessageDlg('Limpar todos os campos?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    LimparCampos;
end;

procedure TCadastroCep.BtnBuscarClick(Sender: TObject);
begin
  if not Assigned(PesqsCeps) then
    PesqsCeps := TPesqsCeps.Create(Application);
  PesqsCeps.ShowModal;
  FreeAndNil(PesqsCeps);
end;

procedure TCadastroCep.ImgCepClick(Sender: TObject);
var
  CEP: string;
begin
  CEP := Trim(EdCEP.Text);
  if CEP = '' then
  begin
    ShowMessage('Digite um CEP válido.');
    Exit;
  end;
  BuscarCEP(CEP);
end;

procedure TCadastroCep.BtnPesqCepClick(Sender: TObject);
var
  CEP: string;
begin
  CEP := Trim(EdCEP.Text);
  if CEP = '' then
  begin
    ShowMessage('Digite um CEP válido.');
    Exit;
  end;
  BuscarCEP(CEP);
end;

end.
