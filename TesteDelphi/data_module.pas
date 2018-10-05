unit data_module;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.FB,
  FireDAC.Phys.FBDef, FireDAC.VCLUI.Wait, FireDAC.Phys.IBBase, Data.DB,
  FireDAC.Comp.Client, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.UI;

type
  Tdm_principal = class(TDataModule)
    FDConnection1: TFDConnection;
    FDPhysFBDriverLink1: TFDPhysFBDriverLink;
    ds_cliente: TDataSource;
    FDTransaction1: TFDTransaction;
    fdq_cliente: TFDQuery;
    fdq_clienteCODIGO: TIntegerField;
    fdq_clienteNOME: TStringField;
    fdu_nota_fiscal: TFDUpdateSQL;
    ds_nota_fiscal: TDataSource;
    fdq_nota_fiscal: TFDQuery;
    fdq_nota_fiscalCODIGO: TIntegerField;
    fdq_nota_fiscalCOD_CLIENTE: TIntegerField;
    fdq_nota_fiscalDATA: TDateField;
    fdq_nota_fiscalNUMERO: TIntegerField;
    fdq_produto: TFDQuery;
    ds_produto: TDataSource;
    fdq_nota_fiscal_produto: TFDQuery;
    fdu_nota_fiscal_produto: TFDUpdateSQL;
    ds_nota_fiscal_produto: TDataSource;
    fdq_nota_fiscal_servico: TFDQuery;
    fdu_nota_fiscal_servico: TFDUpdateSQL;
    ds_nota_fiscal_servico: TDataSource;
    fdq_servico: TFDQuery;
    ds_servico: TDataSource;
    fdq_nota_fiscallkp_cliente: TStringField;
    fdq_nota_fiscal_produtoCODIGO: TIntegerField;
    fdq_nota_fiscal_produtoCOD_NOTA_FISCAL: TIntegerField;
    fdq_nota_fiscal_produtoCOD_PRODUTO: TIntegerField;
    fdq_nota_fiscal_produtoQUANTIDADE: TIntegerField;
    fdq_nota_fiscal_servicoCODIGO: TIntegerField;
    fdq_nota_fiscal_servicoCOD_NOTA_FISCAL: TIntegerField;
    fdq_nota_fiscal_servicoCOD_SERVICO: TIntegerField;
    fdq_nota_fiscal_servicoQUANTIDADE: TIntegerField;
    fdq_nota_fiscal_servicolkp_servico: TStringField;
    fdq_max_numero_nota: TFDQuery;
    fdq_max_numero_notaULTIMO_NUMERO: TIntegerField;
    fdq_nota_fiscal_produtolkp_produto: TStringField;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    fdq_nota_fiscalcalc_valor_total: TCurrencyField;
    fdq_nota_fiscalVALOR_TOTAL_PRODUTOS: TBCDField;
    fdq_nota_fiscalVALOR_TOTAL_SERVICOS: TBCDField;
    fdq_nota_fiscal_produtoVALOR_TOTAL: TBCDField;
    fdq_nota_fiscal_servicoVALOR_TOTAL: TBCDField;
    fdq_nota_fiscal_produtoVALOR_UNITARIO: TBCDField;
    fdq_nota_fiscal_servicoVALOR_UNITARIO: TBCDField;
    fdq_nota_fiscal_produtolkp_valor_unitario: TCurrencyField;
    fdq_nota_fiscal_servicolkp_valor_unitario: TCurrencyField;
    procedure fdq_nota_fiscal_produtoBeforePost(DataSet: TDataSet);
    procedure fdq_nota_fiscalCalcFields(DataSet: TDataSet);
    procedure fdq_nota_fiscalAfterPost(DataSet: TDataSet);
    procedure fdq_nota_fiscal_produtoAfterPost(DataSet: TDataSet);
    procedure fdq_nota_fiscal_servicoAfterPost(DataSet: TDataSet);
  private
    { Private declarations }
    procedure atualiza_tela;
  public
    { Public declarations }
  end;

var
  dm_principal: Tdm_principal;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}


{$R *.dfm}

procedure Tdm_principal.atualiza_tela;
begin
   with dm_principal do
   begin
    fdq_nota_fiscal.Close;
    fdq_nota_fiscal_produto.Close;
    fdq_nota_fiscal_servico.Close;
    fdq_nota_fiscal_servico.Open;
    fdq_nota_fiscal_produto.Open;
    fdq_nota_fiscal.Open;
   end;
end;

procedure Tdm_principal.fdq_nota_fiscalAfterPost(DataSet: TDataSet);
begin
  atualiza_tela;
end;

procedure Tdm_principal.fdq_nota_fiscalCalcFields(DataSet: TDataSet);
var
  soma_valor_produtos, soma_valor_servicos:Currency;
begin
  with DataSet do
  begin
    soma_valor_produtos := FieldByName('valor_total_produtos').AsCurrency;
    soma_valor_servicos := FieldByName('valor_total_servicos').AsCurrency;
    FieldByName('calc_valor_total').AsCurrency := soma_valor_produtos + soma_valor_servicos;
  end;
end;

procedure Tdm_principal.fdq_nota_fiscal_produtoAfterPost(DataSet: TDataSet);
begin
  atualiza_tela;
end;

procedure Tdm_principal.fdq_nota_fiscal_produtoBeforePost(DataSet: TDataSet);
begin
  with dm_principal do
  begin
    fdq_nota_fiscal_produto.FieldByName('cod_nota_fiscal').AsInteger := fdq_nota_fiscal.FieldByName('codigo').AsInteger;
  end;
end;

procedure Tdm_principal.fdq_nota_fiscal_servicoAfterPost(DataSet: TDataSet);
begin
  atualiza_tela;
end;

end.
