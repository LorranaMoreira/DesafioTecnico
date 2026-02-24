unit TelaPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vendas, Compras, PesqProdutos, PesqClientes, PesqCeps,
  CadsProdutos, CadsCliente, CadsCep, Banco, RelatorioVendas, RelatorioCompras,
  dxGDIPlusClasses;

type
  TPrincipal = class(TForm)
    PnlFundo: TPanel;
    ImgLogo: TImage;
    BtnProdutos: TButton;
    BtnClientes: TButton;
    BtnCep: TButton;
    BtnVendas: TButton;
    BtnCompras: TButton;
    BtnRelatVendas: TButton;
    BtnRelatCompras: TButton;
    procedure BtnProdutosClick(Sender: TObject);
    procedure BtnClientesClick(Sender: TObject);
    procedure BtnCepClick(Sender: TObject);
    procedure BtnVendasClick(Sender: TObject);
    procedure BtnComprasClick(Sender: TObject);
    procedure BtnRelatVendasClick(Sender: TObject);
    procedure BtnRelatComprasClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Principal: TPrincipal;

implementation

{$R *.dfm}

procedure TPrincipal.BtnProdutosClick(Sender: TObject);
begin
  CadProdutos := TCadProdutos.Create(Self);
  try
    CadProdutos.ShowModal;
  finally
    CadProdutos.Free;
  end;
end;

procedure TPrincipal.BtnClientesClick(Sender: TObject);
begin
  CadCliente := TCadCliente.Create(Self);
  try
    CadCliente.ShowModal;
  finally
    CadCliente.Free;
  end;
end;

procedure TPrincipal.BtnCepClick(Sender: TObject);
begin
  CadastroCep := TCadastroCep.Create(Self);
  try
    CadastroCep.ShowModal;
  finally
    CadastroCep.Free;
  end;
end;

procedure TPrincipal.BtnVendasClick(Sender: TObject);
begin
  TelaVendas := TTelaVendas.Create(Self);
  try
    TelaVendas.ShowModal;
  finally
    TelaVendas.Free;
  end;
end;

procedure TPrincipal.BtnComprasClick(Sender: TObject);
begin
  TelaCompras := TTelaCompras.Create(Self);
  try
    TelaCompras.ShowModal;
  finally
    TelaCompras.Free;
  end;
end;

procedure TPrincipal.BtnRelatVendasClick(Sender: TObject);
begin
  RelatVendas := TRelatVendas.Create(Self);
  try
    RelatVendas.ShowModal;
  finally
    RelatVendas.Free;
  end;
end;

procedure TPrincipal.BtnRelatComprasClick(Sender: TObject);
begin
  RelatCompras := TRelatCompras.Create(Self);
  try
    RelatCompras.ShowModal;
  finally
    RelatCompras.Free;
  end;
end;

end.
