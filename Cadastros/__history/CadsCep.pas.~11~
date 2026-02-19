unit CadsCep;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Banco, FireDAC.Comp.Client, FireDAC.Stan.Param, Data.DB,
  dxGDIPlusClasses;

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
    EdUF: TEdit;
    ImgCep: TImage;
    BtnBuscar: TButton;

    procedure FormCreate(Sender: TObject);
    procedure BtnSalvarClick(Sender: TObject);
    procedure BtnLimparClick(Sender: TObject);
    procedure BtnBuscarClick(Sender: TObject);
  private
    procedure LimparCampos;
    function ValidarCampos: Boolean;
  public
    { Public declarations }
  end;

var
  CadastroCep: TCadastroCep;

implementation

{$R *.dfm}

uses PesqCeps;

procedure TCadastroCep.FormCreate(Sender: TObject);
begin
  LimparCampos;
end;

procedure TCadastroCep.LimparCampos;
begin
  EdCEP.Clear;
  EdUF.Clear;
  EdCidade.Clear;
  EdLogradouro.Clear;
  ImgCep.Picture := nil;
  EdCEP.SetFocus;
end;

function TCadastroCep.ValidarCampos: Boolean;
begin
  Result := False;

  if Trim(EdCEP.Text) = '' then
  begin
    ShowMessage('Informe o CEP.');
    EdCEP.SetFocus;
    Exit;
  end;

  Result := True;
end;

procedure TCadastroCep.BtnSalvarClick(Sender: TObject);
begin
  if not ValidarCampos then Exit;

  try
    with DataModule1.QryCep do
    begin
      Close;
      SQL.Clear;
      SQL.Text :=
        'INSERT INTO CEP (CEP, LOGRADOURO, CIDADE, UF) ' +
        'VALUES (:CEP, :LOG, :CID, :UF)';
      ParamByName('CEP').AsString := Trim(EdCEP.Text);
      ParamByName('LOG').AsString := Trim(EdLogradouro.Text);
      ParamByName('CID').AsString := Trim(EdCidade.Text);
      ParamByName('UF').AsString := Trim(EdUF.Text);
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
  LimparCampos;
end;

procedure TCadastroCep.BtnBuscarClick(Sender: TObject);
begin
  if not Assigned(PesqsCeps) then
    PesqsCeps := TPesqsCeps.Create(Application);

  PesqsCeps.ShowModal;
end;

end.
