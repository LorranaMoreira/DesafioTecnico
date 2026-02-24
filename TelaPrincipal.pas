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
  public
  end;

var
  Principal: TPrincipal;

implementation

{$R *.dfm}

procedure TPrincipal.BtnProdutosClick(Sender: TObject);
begin
  CadProdutos := TCadProdutos.Create(Application);
  try
    CadProdutos.ShowModal;
  finally
    FreeAndNil(CadProdutos);
  end;
end;

procedure TPrincipal.BtnClientesClick(Sender: TObject);
begin
  CadCliente := TCadCliente.Create(Application);
  try
    CadCliente.ShowModal;
  finally
    FreeAndNil(CadCliente);
  end;
end;

procedure TPrincipal.BtnCepClick(Sender: TObject);
begin
  CadastroCep := TCadastroCep.Create(Application);
  try
    CadastroCep.ShowModal;
  finally
    FreeAndNil(CadastroCep);
  end;
end;

procedure TPrincipal.BtnVendasClick(Sender: TObject);
begin
  TelaVendas := TTelaVendas.Create(Application);
  try
    TelaVendas.ShowModal;
  finally
    FreeAndNil(TelaVendas);
  end;
end;

procedure TPrincipal.BtnComprasClick(Sender: TObject);
begin
  TelaCompras := TTelaCompras.Create(Application);
  try
    TelaCompras.ShowModal;
  finally
    FreeAndNil(TelaCompras);
  end;
end;

procedure TPrincipal.BtnRelatVendasClick(Sender: TObject);
begin
  RelatVendas := TRelatVendas.Create(Application);
  try
    RelatVendas.ShowModal;
  finally
    FreeAndNil(RelatVendas);
  end;
end;

procedure TPrincipal.BtnRelatComprasClick(Sender: TObject);
begin
  RelatCompras := TRelatCompras.Create(Application);
  try
    RelatCompras.ShowModal;
  finally
    FreeAndNil(RelatCompras);
  end;
end;

end.
