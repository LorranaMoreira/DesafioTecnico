object CadCliente: TCadCliente
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Cadastro de Clientes'
  ClientHeight = 352
  ClientWidth = 675
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object PnlDadosPessoais: TPanel
    Left = 0
    Top = 0
    Width = 675
    Height = 353
    Align = alTop
    Color = clInactiveCaption
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentBackground = False
    ParentFont = False
    TabOrder = 0
    object LbCod: TLabel
      Left = 16
      Top = 40
      Width = 33
      Height = 16
      Caption = 'Cod.:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object LbNome: TLabel
      Left = 141
      Top = 39
      Width = 40
      Height = 16
      Caption = 'Nome:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object LbCPFCNPJ: TLabel
      Left = 15
      Top = 86
      Width = 65
      Height = 16
      Caption = 'CPF/CNPJ:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object LbTelefone: TLabel
      Left = 246
      Top = 86
      Width = 60
      Height = 16
      Caption = 'Telefone:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object LbEmail: TLabel
      Left = 16
      Top = 137
      Width = 43
      Height = 16
      Caption = 'E-mail:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object LbEndereco: TLabel
      Left = 15
      Top = 271
      Width = 65
      Height = 16
      Caption = 'Endere'#231'o:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object LbNumero: TLabel
      Left = 384
      Top = 271
      Width = 20
      Height = 16
      Caption = 'N'#186':'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object LbCidade: TLabel
      Left = 290
      Top = 223
      Width = 48
      Height = 16
      Caption = 'Cidade:'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object LbUF: TLabel
      Left = 194
      Top = 222
      Width = 19
      Height = 16
      Caption = 'UF:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object LbCep: TLabel
      Left = 16
      Top = 224
      Width = 28
      Height = 16
      Caption = 'CEP:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object ImgFotoCliente: TImage
      Left = 512
      Top = 56
      Width = 129
      Height = 125
      Center = True
      Proportional = True
      Stretch = True
    end
    object PnlDadosCliente: TPanel
      Left = 1
      Top = 1
      Width = 673
      Height = 24
      Align = alTop
      Color = clGradientInactiveCaption
      ParentBackground = False
      TabOrder = 0
      object LbDadosPessoais: TLabel
        Left = 166
        Top = 3
        Width = 144
        Height = 18
        Caption = 'Dados pessoais do Cliente:'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Trebuchet MS'
        Font.Style = [fsItalic]
        ParentFont = False
      end
    end
    object EdtCod: TEdit
      Left = 53
      Top = 39
      Width = 66
      Height = 22
      TabOrder = 1
    end
    object EdtNome: TEdit
      Left = 185
      Top = 39
      Width = 291
      Height = 22
      TabOrder = 2
      OnChange = CampoAlterado
    end
    object EdtCPFCNPJ: TEdit
      Left = 86
      Top = 86
      Width = 154
      Height = 22
      TabOrder = 3
      OnChange = CampoAlterado
    end
    object EdtTelefone: TEdit
      Left = 312
      Top = 84
      Width = 159
      Height = 22
      TabOrder = 4
      OnChange = CampoAlterado
    end
    object EdtEmail: TEdit
      Left = 65
      Top = 132
      Width = 288
      Height = 22
      TabOrder = 5
      OnChange = CampoAlterado
    end
    object EdtUF: TEdit
      Left = 218
      Top = 219
      Width = 49
      Height = 22
      TabOrder = 6
      OnChange = CampoAlterado
    end
    object PnlRodape: TPanel
      Left = 1
      Top = 320
      Width = 673
      Height = 32
      Align = alBottom
      Color = clGradientInactiveCaption
      ParentBackground = False
      TabOrder = 7
      object BtnSalvar: TButton
        Left = 531
        Top = 3
        Width = 109
        Height = 25
        Cursor = crHandPoint
        Caption = 'Salvar'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        OnClick = BtnSalvarClick
      end
      object BtnEditar: TButton
        Left = 408
        Top = 3
        Width = 109
        Height = 25
        Cursor = crHandPoint
        Caption = 'Editar'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 1
        OnClick = BtnEditarClick
      end
      object BtnLimpar: TButton
        Left = 15
        Top = 3
        Width = 116
        Height = 25
        Cursor = crHandPoint
        Caption = 'Limpar'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 2
        OnClick = BtnLimparClick
      end
    end
    object EdtEndereco: TEdit
      Left = 86
      Top = 269
      Width = 283
      Height = 22
      TabOrder = 8
      OnChange = CampoAlterado
    end
    object EdtNumero: TEdit
      Left = 409
      Top = 269
      Width = 68
      Height = 22
      TabOrder = 9
      OnChange = CampoAlterado
    end
    object EdtCidade: TEdit
      Left = 342
      Top = 219
      Width = 134
      Height = 22
      TabOrder = 10
      OnChange = CampoAlterado
    end
    object EdtCep: TEdit
      Left = 50
      Top = 219
      Width = 112
      Height = 22
      TabOrder = 11
      OnChange = CampoAlterado
    end
    object PnlEnunciadoEndereco: TPanel
      Left = 1
      Top = 172
      Width = 475
      Height = 25
      Color = clGradientInactiveCaption
      ParentBackground = False
      TabOrder = 12
      object LbEnderecoCliente: TLabel
        Left = 184
        Top = 3
        Width = 113
        Height = 18
        Alignment = taCenter
        Caption = 'Endere'#231'o do Cliente:'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Trebuchet MS'
        Font.Style = [fsItalic]
        ParentFont = False
      end
    end
    object BtnBuscar: TButton
      Left = 368
      Top = 131
      Width = 109
      Height = 25
      Cursor = crHandPoint
      Caption = 'Buscar'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 13
      OnClick = BtnBuscarClick
    end
    object BtnCarregarFoto: TButton
      Left = 528
      Top = 224
      Width = 105
      Height = 27
      Cursor = crHandPoint
      Caption = 'Carregar foto'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 14
      OnClick = BtnCarregarFotoClick
    end
  end
end
