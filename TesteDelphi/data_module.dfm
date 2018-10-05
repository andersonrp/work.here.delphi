object dm_principal: Tdm_principal
  OldCreateOrder = False
  Height = 398
  Width = 741
  object FDConnection1: TFDConnection
    Params.Strings = (
      'Database=C:\TesteDelphi\db\db_testedelphi.fdb'
      'Password=masterkey'
      'User_Name=sysdba'
      'DriverID=FB')
    Connected = True
    LoginPrompt = False
    Left = 40
    Top = 16
  end
  object FDPhysFBDriverLink1: TFDPhysFBDriverLink
    VendorLib = 'C:\Program Files (x86)\Firebird\Firebird_2_5\bin\fbclient.dll'
    Embedded = True
    Left = 240
    Top = 16
  end
  object ds_cliente: TDataSource
    DataSet = fdq_cliente
    Left = 48
    Top = 160
  end
  object FDTransaction1: TFDTransaction
    Connection = FDConnection1
    Left = 136
    Top = 16
  end
  object fdq_cliente: TFDQuery
    Active = True
    Connection = FDConnection1
    SQL.Strings = (
      'Select * from cliente')
    Left = 48
    Top = 104
    object fdq_clienteCODIGO: TIntegerField
      FieldName = 'CODIGO'
      Origin = 'CODIGO'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object fdq_clienteNOME: TStringField
      FieldName = 'NOME'
      Origin = 'NOME'
      Required = True
      Size = 100
    end
  end
  object fdu_nota_fiscal: TFDUpdateSQL
    Connection = FDConnection1
    InsertSQL.Strings = (
      'INSERT INTO NOTA_FISCAL'
      '(COD_CLIENTE, "DATA", NUMERO)'
      'VALUES (:NEW_COD_CLIENTE, :NEW_DATA, :NEW_NUMERO)')
    ModifySQL.Strings = (
      'UPDATE NOTA_FISCAL'
      
        'SET COD_CLIENTE = :NEW_COD_CLIENTE, "DATA" = :NEW_DATA, NUMERO =' +
        ' :NEW_NUMERO'
      'WHERE CODIGO = :OLD_CODIGO')
    DeleteSQL.Strings = (
      'DELETE FROM NOTA_FISCAL'
      'WHERE CODIGO = :OLD_CODIGO')
    FetchRowSQL.Strings = (
      'SELECT CODIGO, COD_CLIENTE, "DATA" AS "DATA", NUMERO'
      'FROM NOTA_FISCAL'
      'WHERE CODIGO = :CODIGO')
    Left = 368
    Top = 96
  end
  object ds_nota_fiscal: TDataSource
    DataSet = fdq_nota_fiscal
    Left = 368
    Top = 192
  end
  object fdq_nota_fiscal: TFDQuery
    Active = True
    AfterPost = fdq_nota_fiscalAfterPost
    OnCalcFields = fdq_nota_fiscalCalcFields
    Connection = FDConnection1
    UpdateObject = fdu_nota_fiscal
    SQL.Strings = (
      'select'
      '  nf.codigo, nf.cod_cliente, nf.data, nf.numero,'
      
        '  sum(nfp.quantidade * p.valor_unitario) as valor_total_produtos' +
        ','
      '  sum(nfs.quantidade * s.valor_unitario) as valor_total_servicos'
      'from'
      '  nota_fiscal nf'
      '  left join nota_fiscal_produto nfp'
      '    on nfp.cod_nota_fiscal=nf.codigo'
      '  left join produto p'
      '    on p.codigo=nfp.cod_produto'
      '  left join nota_fiscal_servico nfs'
      '    on nfs.cod_nota_fiscal=nf.codigo'
      '  left join servico s'
      '    on s.codigo=nfs.cod_servico'
      'group by 1,2,3,4'
      'order by'
      '  codigo desc')
    Left = 368
    Top = 144
    object fdq_nota_fiscalCODIGO: TIntegerField
      FieldName = 'CODIGO'
      Origin = 'CODIGO'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
    end
    object fdq_nota_fiscalCOD_CLIENTE: TIntegerField
      FieldName = 'COD_CLIENTE'
      Origin = 'COD_CLIENTE'
      Required = True
    end
    object fdq_nota_fiscalDATA: TDateField
      FieldName = 'DATA'
      Origin = '"DATA"'
      Required = True
    end
    object fdq_nota_fiscalNUMERO: TIntegerField
      FieldName = 'NUMERO'
      Origin = 'NUMERO'
      Required = True
    end
    object fdq_nota_fiscallkp_cliente: TStringField
      FieldKind = fkLookup
      FieldName = 'lkp_cliente'
      LookupDataSet = fdq_cliente
      LookupKeyFields = 'CODIGO'
      LookupResultField = 'NOME'
      KeyFields = 'COD_CLIENTE'
      Size = 100
      Lookup = True
    end
    object fdq_nota_fiscalcalc_valor_total: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'calc_valor_total'
      DisplayFormat = '###,###,##0.00'
      Calculated = True
    end
    object fdq_nota_fiscalVALOR_TOTAL_PRODUTOS: TBCDField
      AutoGenerateValue = arDefault
      FieldName = 'VALOR_TOTAL_PRODUTOS'
      Origin = 'VALOR_TOTAL_PRODUTOS'
      ProviderFlags = []
      ReadOnly = True
      DisplayFormat = '###,###,##0.00'
      Precision = 18
      Size = 2
    end
    object fdq_nota_fiscalVALOR_TOTAL_SERVICOS: TBCDField
      AutoGenerateValue = arDefault
      FieldName = 'VALOR_TOTAL_SERVICOS'
      Origin = 'VALOR_TOTAL_SERVICOS'
      ProviderFlags = []
      ReadOnly = True
      DisplayFormat = '###,###,##0.00'
      Precision = 18
      Size = 2
    end
  end
  object fdq_produto: TFDQuery
    Active = True
    Connection = FDConnection1
    SQL.Strings = (
      'select * from produto')
    Left = 144
    Top = 104
  end
  object ds_produto: TDataSource
    DataSet = fdq_produto
    Left = 144
    Top = 160
  end
  object fdq_nota_fiscal_produto: TFDQuery
    Active = True
    BeforePost = fdq_nota_fiscal_produtoBeforePost
    AfterPost = fdq_nota_fiscal_produtoAfterPost
    IndexFieldNames = 'COD_NOTA_FISCAL'
    MasterSource = ds_nota_fiscal
    MasterFields = 'CODIGO'
    DetailFields = 'COD_NOTA_FISCAL'
    Connection = FDConnection1
    FetchOptions.AssignedValues = [evCache]
    FetchOptions.Cache = [fiBlobs, fiMeta]
    UpdateObject = fdu_nota_fiscal_produto
    SQL.Strings = (
      'select'
      '  nfp.codigo, '
      '  nfp.cod_nota_fiscal,'
      '  nfp.cod_produto,'
      '  nfp.quantidade,'
      '  p.valor_unitario,'
      '  (nfp.quantidade * p.valor_unitario) as valor_total'
      'from'
      '  nota_fiscal_produto nfp'
      '  join produto p'
      '    on p.codigo=nfp.cod_produto'
      'where'
      '  cod_nota_fiscal = :codigo'
      'order by codigo desc')
    Left = 488
    Top = 144
    ParamData = <
      item
        Name = 'CODIGO'
        DataType = ftInteger
        ParamType = ptInput
        Value = 7
      end>
    object fdq_nota_fiscal_produtoCODIGO: TIntegerField
      FieldName = 'CODIGO'
      Origin = 'CODIGO'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
    end
    object fdq_nota_fiscal_produtoCOD_NOTA_FISCAL: TIntegerField
      FieldName = 'COD_NOTA_FISCAL'
      Origin = 'COD_NOTA_FISCAL'
      Required = True
    end
    object fdq_nota_fiscal_produtoCOD_PRODUTO: TIntegerField
      FieldName = 'COD_PRODUTO'
      Origin = 'COD_PRODUTO'
      Required = True
    end
    object fdq_nota_fiscal_produtoVALOR_UNITARIO: TBCDField
      AutoGenerateValue = arDefault
      FieldName = 'VALOR_UNITARIO'
      Origin = 'VALOR_UNITARIO'
      ProviderFlags = []
      ReadOnly = True
      DisplayFormat = '###,###,##0.00'
      Precision = 18
      Size = 2
    end
    object fdq_nota_fiscal_produtoQUANTIDADE: TIntegerField
      FieldName = 'QUANTIDADE'
      Origin = 'QUANTIDADE'
      Required = True
    end
    object fdq_nota_fiscal_produtoVALOR_TOTAL: TBCDField
      AutoGenerateValue = arDefault
      FieldName = 'VALOR_TOTAL'
      Origin = 'VALOR_TOTAL'
      ProviderFlags = []
      ReadOnly = True
      DisplayFormat = '###,###,##0.00'
      currency = True
      Precision = 18
      Size = 2
    end
    object fdq_nota_fiscal_produtolkp_produto: TStringField
      FieldKind = fkLookup
      FieldName = 'lkp_produto'
      LookupDataSet = fdq_produto
      LookupKeyFields = 'CODIGO'
      LookupResultField = 'NOME'
      KeyFields = 'COD_PRODUTO'
      Size = 60
      Lookup = True
    end
    object fdq_nota_fiscal_produtolkp_valor_unitario: TCurrencyField
      FieldKind = fkLookup
      FieldName = 'lkp_valor_unitario'
      LookupDataSet = fdq_produto
      LookupKeyFields = 'CODIGO'
      LookupResultField = 'VALOR_UNITARIO'
      KeyFields = 'COD_PRODUTO'
      DisplayFormat = '###,###,##0.00'
      Lookup = True
    end
  end
  object fdu_nota_fiscal_produto: TFDUpdateSQL
    Connection = FDConnection1
    InsertSQL.Strings = (
      'INSERT INTO NOTA_FISCAL_PRODUTO'
      '(COD_NOTA_FISCAL, COD_PRODUTO, QUANTIDADE)'
      'VALUES (:NEW_COD_NOTA_FISCAL, :NEW_COD_PRODUTO, :NEW_QUANTIDADE)')
    ModifySQL.Strings = (
      'UPDATE NOTA_FISCAL_PRODUTO'
      
        'SET COD_NOTA_FISCAL = :NEW_COD_NOTA_FISCAL, COD_PRODUTO = :NEW_C' +
        'OD_PRODUTO, '
      '  QUANTIDADE = :NEW_QUANTIDADE'
      'WHERE CODIGO = :OLD_CODIGO')
    DeleteSQL.Strings = (
      'DELETE FROM NOTA_FISCAL_PRODUTO'
      'WHERE CODIGO = :OLD_CODIGO')
    FetchRowSQL.Strings = (
      'SELECT CODIGO, COD_NOTA_FISCAL, COD_PRODUTO, QUANTIDADE'
      'FROM NOTA_FISCAL_PRODUTO'
      'WHERE CODIGO = :CODIGO')
    Left = 488
    Top = 96
  end
  object ds_nota_fiscal_produto: TDataSource
    DataSet = fdq_nota_fiscal_produto
    Left = 488
    Top = 192
  end
  object fdq_nota_fiscal_servico: TFDQuery
    Active = True
    AfterPost = fdq_nota_fiscal_servicoAfterPost
    IndexFieldNames = 'COD_NOTA_FISCAL'
    Aggregates = <
      item
        Active = True
      end>
    MasterSource = ds_nota_fiscal
    MasterFields = 'CODIGO'
    DetailFields = 'COD_NOTA_FISCAL'
    Connection = FDConnection1
    SQL.Strings = (
      'select'
      '  nfs.codigo,'
      '  nfs.cod_nota_fiscal,'
      '  nfs.cod_servico,'
      '  nfs.quantidade,'
      '  s.valor_unitario,'
      '  (nfs.quantidade * s.valor_unitario) as valor_total'
      'from'
      '  nota_fiscal_servico nfs'
      '  join servico s'
      '    on s.codigo=nfs.cod_servico'
      'where cod_nota_fiscal = :codigo'
      'order by codigo desc')
    Left = 624
    Top = 144
    ParamData = <
      item
        Name = 'CODIGO'
        DataType = ftInteger
        ParamType = ptInput
        Value = 7
      end>
    object fdq_nota_fiscal_servicoCODIGO: TIntegerField
      FieldName = 'CODIGO'
      Origin = 'CODIGO'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
    end
    object fdq_nota_fiscal_servicoCOD_NOTA_FISCAL: TIntegerField
      FieldName = 'COD_NOTA_FISCAL'
      Origin = 'COD_NOTA_FISCAL'
      Required = True
    end
    object fdq_nota_fiscal_servicoCOD_SERVICO: TIntegerField
      FieldName = 'COD_SERVICO'
      Origin = 'COD_SERVICO'
      Required = True
    end
    object fdq_nota_fiscal_servicoVALOR_UNITARIO: TBCDField
      AutoGenerateValue = arDefault
      FieldName = 'VALOR_UNITARIO'
      Origin = 'VALOR_UNITARIO'
      ProviderFlags = []
      ReadOnly = True
      DisplayFormat = '###,###,##0.00'
      Precision = 18
      Size = 2
    end
    object fdq_nota_fiscal_servicoQUANTIDADE: TIntegerField
      FieldName = 'QUANTIDADE'
      Origin = 'QUANTIDADE'
      Required = True
    end
    object fdq_nota_fiscal_servicoVALOR_TOTAL: TBCDField
      AutoGenerateValue = arDefault
      FieldName = 'VALOR_TOTAL'
      Origin = 'VALOR_TOTAL'
      ProviderFlags = []
      ReadOnly = True
      DisplayFormat = '###,###,##0.00'
      currency = True
      Precision = 18
      Size = 2
    end
    object fdq_nota_fiscal_servicolkp_servico: TStringField
      FieldKind = fkLookup
      FieldName = 'lkp_servico'
      LookupDataSet = fdq_servico
      LookupKeyFields = 'CODIGO'
      LookupResultField = 'NOME'
      KeyFields = 'COD_SERVICO'
      Size = 60
      Lookup = True
    end
    object fdq_nota_fiscal_servicolkp_valor_unitario: TCurrencyField
      FieldKind = fkLookup
      FieldName = 'lkp_valor_unitario'
      LookupDataSet = fdq_servico
      LookupKeyFields = 'CODIGO'
      LookupResultField = 'VALOR_UNITARIO'
      KeyFields = 'COD_SERVICO'
      DisplayFormat = '###,###,##0.00'
      Lookup = True
    end
  end
  object fdu_nota_fiscal_servico: TFDUpdateSQL
    Connection = FDConnection1
    InsertSQL.Strings = (
      'INSERT INTO NOTA_FISCAL_SERVICO'
      '(COD_NOTA_FISCAL, COD_SERVICO, QUANTIDADE)'
      'VALUES (:NEW_COD_NOTA_FISCAL, :NEW_COD_SERVICO, :NEW_QUANTIDADE)')
    ModifySQL.Strings = (
      'UPDATE NOTA_FISCAL_SERVICO'
      
        'SET COD_NOTA_FISCAL = :NEW_COD_NOTA_FISCAL, COD_SERVICO = :NEW_C' +
        'OD_SERVICO, '
      '  QUANTIDADE = :NEW_QUANTIDADE'
      'WHERE CODIGO = :OLD_CODIGO')
    DeleteSQL.Strings = (
      'DELETE FROM NOTA_FISCAL_SERVICO'
      'WHERE CODIGO = :OLD_CODIGO')
    FetchRowSQL.Strings = (
      'SELECT CODIGO, COD_NOTA_FISCAL, COD_SERVICO, QUANTIDADE'
      'FROM NOTA_FISCAL_SERVICO'
      'WHERE CODIGO = :CODIGO')
    Left = 624
    Top = 96
  end
  object ds_nota_fiscal_servico: TDataSource
    DataSet = fdq_nota_fiscal_servico
    Left = 624
    Top = 192
  end
  object fdq_servico: TFDQuery
    Active = True
    Connection = FDConnection1
    SQL.Strings = (
      'select * from servico')
    Left = 224
    Top = 104
  end
  object ds_servico: TDataSource
    DataSet = fdq_servico
    Left = 224
    Top = 160
  end
  object fdq_max_numero_nota: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      'select max(numero)as ultimo_numero from nota_fiscal')
    Left = 488
    Top = 16
    object fdq_max_numero_notaULTIMO_NUMERO: TIntegerField
      AutoGenerateValue = arDefault
      FieldName = 'ULTIMO_NUMERO'
      Origin = 'ULTIMO_NUMERO'
      ProviderFlags = []
      ReadOnly = True
    end
  end
  object FDGUIxWaitCursor1: TFDGUIxWaitCursor
    Provider = 'Forms'
    Left = 360
    Top = 16
  end
end
