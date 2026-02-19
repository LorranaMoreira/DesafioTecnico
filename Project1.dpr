program Project1;

uses
  Vcl.Forms,
  TelaPrincipal in 'TelaPrincipal.pas' {Principal},
  CadsProdutos in 'Cadastros\CadsProdutos.pas' {CadProdutos},
  CadsCliente in 'Cadastros\CadsCliente.pas' {CadCliente},
  CadsCep in 'Cadastros\CadsCep.pas' {CadastroCep},
  PesqProdutos in 'Cadastros\view\PesqProdutos.pas' {PesqsProdutos},
  PesqClientes in 'Cadastros\view\PesqClientes.pas' {PesqsCliente},
  PesqCeps in 'Cadastros\view\PesqCeps.pas' {PesqsCeps},
  Banco in 'DB\Banco.pas' {DataModule1: TDataModule},
  Vendas in 'Vendas\Vendas.pas' {TelaVendas},
  Compras in 'Compras\Compras.pas' {TelaCompras},
  RelatorioVendas in 'Relatorios\RelatorioVendas.pas' {RelatVendas},
  RelatorioCompras in 'Relatorios\RelatorioCompras.pas' {RelatCompras};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TPrincipal, Principal);
  Application.CreateForm(TDataModule1, DataModule1);
  Application.Run;
end.
