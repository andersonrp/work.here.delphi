object frm_principal: Tfrm_principal
  Left = 0
  Top = 0
  Caption = 'Lan'#231'amento de Nota Fiscal'
  ClientHeight = 542
  ClientWidth = 659
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  PixelsPerInch = 96
  TextHeight = 13
  object lbl_cliente: TLabel
    Left = 16
    Top = 21
    Width = 37
    Height = 13
    Caption = 'Cliente:'
  end
  object dbl_cliente: TDBLookupComboBox
    Left = 56
    Top = 18
    Width = 359
    Height = 21
    KeyField = 'CODIGO'
    ListField = 'NOME'
    ListSource = dm_principal.ds_cliente
    TabOrder = 0
    OnCloseUp = dbl_clienteCloseUp
  end
  object btn_lancar: TButton
    Left = 431
    Top = 16
    Width = 75
    Height = 25
    Caption = 'Lan'#231'ar'
    Enabled = False
    TabOrder = 1
    OnClick = btn_lancarClick
  end
  object grp_lancamentos: TGroupBox
    Left = 16
    Top = 40
    Width = 625
    Height = 449
    Caption = 'Lan'#231'amentos'
    TabOrder = 2
    object grp_nota_fiscal: TGroupBox
      Left = 15
      Top = 106
      Width = 594
      Height = 327
      Caption = 'Detalhes'
      TabOrder = 0
      object grp_produtos: TGroupBox
        Left = 11
        Top = 14
        Width = 566
        Height = 163
        Caption = 'Produtos'
        TabOrder = 0
        object Label1: TLabel
          Left = 16
          Top = 123
          Width = 28
          Height = 13
          Caption = 'Total:'
        end
        object DBText1: TDBText
          Left = 50
          Top = 123
          Width = 65
          Height = 17
          DataField = 'VALOR_TOTAL_PRODUTOS'
          DataSource = dm_principal.ds_nota_fiscal
          Transparent = True
        end
        object dbg_produtos: TDBGrid
          Left = 15
          Top = 17
          Width = 538
          Height = 97
          DataSource = dm_principal.ds_nota_fiscal_produto
          TabOrder = 0
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'Tahoma'
          TitleFont.Style = []
          Columns = <
            item
              Expanded = False
              FieldName = 'COD_PRODUTO'
              ReadOnly = True
              Title.Caption = 'C'#243'digo'
              Width = 40
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'lkp_produto'
              Title.Caption = 'Nome'
              Width = 240
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'lkp_valor_unitario'
              ReadOnly = True
              Title.Caption = 'Valor unit'#225'rio'
              Width = 80
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'QUANTIDADE'
              Title.Caption = 'Qtde'
              Width = 50
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'VALOR_TOTAL'
              Title.Caption = 'Valor total'
              Width = 80
              Visible = True
            end>
        end
        object dbn_produtos: TDBNavigator
          Left = 457
          Top = 120
          Width = 96
          Height = 25
          DataSource = dm_principal.ds_nota_fiscal_produto
          VisibleButtons = [nbInsert, nbDelete, nbPost, nbCancel]
          Hints.Strings = (
            'First record'
            'Prior record'
            'Next record'
            'Last record'
            'Adicionar produto'
            'Remover produto'
            'Edit record'
            'Post edit'
            'Cancelar adi'#231#227'o'
            'Refresh data'
            'Apply updates'
            'Cancel updates')
          TabOrder = 1
          OnClick = dbn_produtosClick
        end
        object GroupBox1: TGroupBox
          Left = 152
          Top = -112
          Width = 185
          Height = 105
          Caption = 'GroupBox1'
          TabOrder = 2
        end
        object GroupBox2: TGroupBox
          Left = 8
          Top = -120
          Width = 185
          Height = 105
          Caption = 'GroupBox2'
          TabOrder = 3
        end
      end
      object grp_servicos: TGroupBox
        Left = 11
        Top = 183
        Width = 566
        Height = 133
        Caption = 'Servi'#231'os'
        TabOrder = 1
        object Label2: TLabel
          Left = 15
          Top = 98
          Width = 28
          Height = 13
          Caption = 'Total:'
        end
        object DBText2: TDBText
          Left = 49
          Top = 98
          Width = 65
          Height = 17
          DataField = 'VALOR_TOTAL_SERVICOS'
          DataSource = dm_principal.ds_nota_fiscal
        end
        object dbg_servicos: TDBGrid
          Left = 15
          Top = 17
          Width = 538
          Height = 75
          DataSource = dm_principal.ds_nota_fiscal_servico
          TabOrder = 0
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'Tahoma'
          TitleFont.Style = []
          Columns = <
            item
              Expanded = False
              FieldName = 'COD_SERVICO'
              ReadOnly = True
              Title.Caption = 'C'#243'digo'
              Width = 40
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'lkp_servico'
              Title.Caption = 'Nome'
              Width = 240
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'lkp_valor_unitario'
              Title.Caption = 'Valor unit'#225'rio'
              Width = 80
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'QUANTIDADE'
              Title.Caption = 'Qtde'
              Width = 50
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'VALOR_TOTAL'
              Title.Caption = 'Valor total'
              Width = 80
              Visible = True
            end>
        end
        object dbn_servicos: TDBNavigator
          Left = 457
          Top = 98
          Width = 96
          Height = 25
          DataSource = dm_principal.ds_nota_fiscal_servico
          VisibleButtons = [nbInsert, nbDelete, nbPost, nbCancel]
          Hints.Strings = (
            'First record'
            'Prior record'
            'Next record'
            'Last record'
            'Adicionar servi'#231'o'
            'Remover servi'#231'o'
            'Edit record'
            'Post edit'
            'Cancelar adi'#231#227'o'
            'Refresh data'
            'Apply updates'
            'Cancel updates')
          TabOrder = 1
          OnClick = dbn_servicosClick
        end
        object GroupBox3: TGroupBox
          Left = 640
          Top = -104
          Width = 185
          Height = 105
          Caption = 'GroupBox3'
          TabOrder = 2
        end
      end
    end
    object dbg_nota_fiscal: TDBGrid
      Left = 14
      Top = 27
      Width = 595
      Height = 73
      DataSource = dm_principal.ds_nota_fiscal
      Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
      ReadOnly = True
      TabOrder = 1
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
      Columns = <
        item
          Expanded = False
          FieldName = 'DATA'
          Title.Caption = 'Data'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'NUMERO'
          Title.Caption = 'N'#250'mero'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'lkp_cliente'
          Title.Caption = 'Cliente'
          Width = 280
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'calc_valor_total'
          Title.Caption = 'Valor total'
          Width = 100
          Visible = True
        end>
    end
  end
  object btn_emitir_nfe: TButton
    Left = 566
    Top = 495
    Width = 75
    Height = 25
    Caption = 'Emitir NFe'
    TabOrder = 3
    OnClick = btn_emitir_nfeClick
  end
  object ACBrNFe1: TACBrNFe
    Configuracoes.Geral.SSLLib = libNone
    Configuracoes.Geral.SSLCryptLib = cryNone
    Configuracoes.Geral.SSLHttpLib = httpNone
    Configuracoes.Geral.SSLXmlSignLib = xsNone
    Configuracoes.Geral.FormatoAlerta = 'TAG:%TAGNIVEL% ID:%ID%/%TAG%(%DESCRICAO%) - %MSG%.'
    Configuracoes.Geral.VersaoQRCode = veqr000
    Configuracoes.Arquivos.OrdenacaoPath = <>
    Configuracoes.WebServices.UF = 'SP'
    Configuracoes.WebServices.AguardarConsultaRet = 0
    Configuracoes.WebServices.QuebradeLinha = '|'
    DANFE = ACBrNFeDANFeRL1
    Left = 32
    Top = 496
  end
  object ACBrNFeDANFeRL1: TACBrNFeDANFeRL
    ACBrNFe = ACBrNFe1
    MostrarPreview = True
    MostrarStatus = True
    TipoDANFE = tiRetrato
    NumCopias = 1
    AgruparNumCopias = False
    ImprimeNomeFantasia = False
    ImprimirDescPorc = False
    ImprimirTotalLiquido = True
    MargemInferior = 0.700000000000000000
    MargemSuperior = 0.700000000000000000
    MargemEsquerda = 0.700000000000000000
    MargemDireita = 0.700000000000000000
    CasasDecimais.Formato = tdetInteger
    CasasDecimais._qCom = 4
    CasasDecimais._vUnCom = 4
    CasasDecimais._Mask_qCom = ',0.00'
    CasasDecimais._Mask_vUnCom = ',0.00'
    ExibirResumoCanhoto = False
    FormularioContinuo = False
    TamanhoFonte_DemaisCampos = 8
    ProdutosPorPagina = 0
    ImprimirDetalhamentoEspecifico = True
    NFeCancelada = False
    ImprimirItens = True
    ViaConsumidor = True
    TamanhoLogoHeight = 0
    TamanhoLogoWidth = 0
    RecuoEndereco = 0
    RecuoEmpresa = 0
    LogoemCima = False
    TamanhoFonteEndereco = 0
    RecuoLogo = 0
    LarguraCodProd = 54
    ExibirEAN = False
    QuebraLinhaEmDetalhamentoEspecifico = True
    ExibeCampoFatura = False
    ImprimirUnQtVlComercial = iuComercial
    ImprimirDadosDocReferenciados = True
    Left = 112
    Top = 496
  end
  object ACBrNFeDANFCeFortes1: TACBrNFeDANFCeFortes
    MostrarPreview = True
    MostrarStatus = True
    TipoDANFE = tiSemGeracao
    NumCopias = 1
    AgruparNumCopias = False
    ImprimeNomeFantasia = False
    ImprimirDescPorc = False
    ImprimirTotalLiquido = True
    MargemInferior = 0.800000000000000000
    MargemSuperior = 0.800000000000000000
    MargemEsquerda = 0.600000000000000000
    MargemDireita = 0.510000000000000000
    CasasDecimais.Formato = tdetInteger
    CasasDecimais._qCom = 2
    CasasDecimais._vUnCom = 2
    CasasDecimais._Mask_qCom = ',0.00'
    CasasDecimais._Mask_vUnCom = ',0.00'
    ExibirResumoCanhoto = False
    FormularioContinuo = False
    TamanhoFonte_DemaisCampos = 8
    ProdutosPorPagina = 0
    ImprimirDetalhamentoEspecifico = True
    NFeCancelada = False
    ImprimirItens = True
    ViaConsumidor = True
    TamanhoLogoHeight = 0
    TamanhoLogoWidth = 0
    RecuoEndereco = 0
    RecuoEmpresa = 0
    LogoemCima = False
    TamanhoFonteEndereco = 0
    RecuoLogo = 0
    Left = 216
    Top = 496
  end
  object ACBrNFeDANFeESCPOS1: TACBrNFeDANFeESCPOS
    MostrarPreview = True
    MostrarStatus = True
    TipoDANFE = tiSemGeracao
    NumCopias = 1
    AgruparNumCopias = False
    ImprimeNomeFantasia = False
    ImprimirDescPorc = False
    ImprimirTotalLiquido = True
    MargemInferior = 0.800000000000000000
    MargemSuperior = 0.800000000000000000
    MargemEsquerda = 0.600000000000000000
    MargemDireita = 0.510000000000000000
    CasasDecimais.Formato = tdetInteger
    CasasDecimais._qCom = 2
    CasasDecimais._vUnCom = 2
    CasasDecimais._Mask_qCom = ',0.00'
    CasasDecimais._Mask_vUnCom = ',0.00'
    ExibirResumoCanhoto = False
    FormularioContinuo = False
    TamanhoFonte_DemaisCampos = 8
    ProdutosPorPagina = 0
    ImprimirDetalhamentoEspecifico = True
    NFeCancelada = False
    ImprimirItens = True
    ViaConsumidor = True
    TamanhoLogoHeight = 0
    TamanhoLogoWidth = 0
    RecuoEndereco = 0
    RecuoEmpresa = 0
    LogoemCima = False
    TamanhoFonteEndereco = 0
    RecuoLogo = 0
    Left = 344
    Top = 496
  end
end
