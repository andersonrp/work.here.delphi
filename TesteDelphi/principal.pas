unit principal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.DBCtrls, Data.DB,
  Vcl.Grids, Vcl.DBGrids, Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.Mask,
  ACBrNFeDANFeESCPOS, ACBrDANFCeFortesFr, ACBrNFeDANFEClass,
  ACBrNFeDANFeRLClass, ACBrBase, ACBrDFe, ACBrNFe, ACBrNFeNotasFiscais, pcnNFe, pcnConversao,pcnConversaoNFe,
  Vcl.OleCtrls, SHDocVw,ACBrUtil, Winapi.ShellAPI;

type
  Tfrm_principal = class(TForm)
    lbl_cliente: TLabel;
    dbl_cliente: TDBLookupComboBox;
    btn_lancar: TButton;
    grp_lancamentos: TGroupBox;
    grp_nota_fiscal: TGroupBox;
    grp_produtos: TGroupBox;
    dbg_produtos: TDBGrid;
    dbn_produtos: TDBNavigator;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    grp_servicos: TGroupBox;
    dbg_servicos: TDBGrid;
    dbn_servicos: TDBNavigator;
    GroupBox3: TGroupBox;
    dbg_nota_fiscal: TDBGrid;
    Label1: TLabel;
    DBText1: TDBText;
    Label2: TLabel;
    DBText2: TDBText;
    ACBrNFe1: TACBrNFe;
    ACBrNFeDANFeRL1: TACBrNFeDANFeRL;
    ACBrNFeDANFCeFortes1: TACBrNFeDANFCeFortes;
    ACBrNFeDANFeESCPOS1: TACBrNFeDANFeESCPOS;
    btn_emitir_nfe: TButton;
    procedure btn_lancarClick(Sender: TObject);
    procedure btn_cancelarClick(Sender: TObject);
    procedure dbl_clienteCloseUp(Sender: TObject);
    procedure dbn_produtosClick(Sender: TObject; Button: TNavigateBtn);
    procedure dbn_servicosClick(Sender: TObject; Button: TNavigateBtn);
    procedure btn_emitir_nfeClick(Sender: TObject);
  private
    { Private declarations }
    procedure gerar_nota_fiscal(NumNFe : String);
    procedure abrirPdf(aFile : TFileName; TypeForm : Integer = SW_NORMAL);
  public
    { Public declarations }
  end;

var
  frm_principal: Tfrm_principal;
  ultimo_num_nf :integer;

implementation

{$R *.dfm}

uses data_module;

procedure Tfrm_principal.abrirPdf(aFile : TFileName; TypeForm : Integer = SW_NORMAL);
var
  Pdir: PChar;
begin
  GetMem(pDir, 256);
  StrPCopy(pDir, aFile);
  ShellExecute(0, nil, Pchar(aFile), nil, Pdir, TypeForm);
  FreeMem(pdir, 256);
end;

procedure Tfrm_principal.btn_cancelarClick(Sender: TObject);
begin
  TButton(Sender).Enabled := false;
  dbg_nota_fiscal.Enabled := false;
  dm_principal.fdq_nota_fiscal.Cancel;
end;

procedure Tfrm_principal.btn_emitir_nfeClick(Sender: TObject);
var
  path_arquivo:String;
begin

  ACBrNFe1.NotasFiscais.Clear;
  gerar_nota_fiscal(dm_principal.fdq_nota_fiscal.FieldByName('numero').AsString);
  ACBrNFe1.NotasFiscais.Items[0].GravarXML();
  ACBrNFe1.NotasFiscais.LoadFromFile(ACBrNFe1.NotasFiscais.Items[0].NomeArq);
  ACBrNFe1.NotasFiscais.ImprimirPDF;
  //Alterando nome da extensão do arquivo.
  path_arquivo := StringReplace(ACBrNFe1.NotasFiscais.Items[0].NomeArq, 'xml', 'pdf',
   [rfReplaceAll, rfIgnoreCase]);
  //Alterando nome da pasta.
  path_arquivo := StringReplace(path_arquivo, 'Docs', 'pdf',[rfReplaceAll, rfIgnoreCase]);
  abrirPdf(path_arquivo);
end;

procedure Tfrm_principal.btn_lancarClick(Sender: TObject);
begin

  with dm_principal.fdq_max_numero_nota do
  begin
    Close; Open;
    ultimo_num_nf := FieldByName('ultimo_numero').AsInteger;
  end;

  with dm_principal.fdq_nota_fiscal do
  begin
    Insert;
    FieldByName('data').AsDateTime := Date;
    FieldByName('numero').AsInteger := ultimo_num_nf + 1;
    FieldByName('cod_cliente').AsInteger := dbl_cliente.KeyValue;
    Post;
  end;
  dbg_nota_fiscal.SelectedIndex := 0;

end;

procedure Tfrm_principal.dbl_clienteCloseUp(Sender: TObject);
begin
  if(TDBLookupComboBox(Sender).KeyValue <> null)then
  begin
    btn_lancar.Enabled := true;
  end;
end;

procedure Tfrm_principal.dbn_produtosClick(Sender: TObject; Button: TNavigateBtn);
begin
  dbg_produtos.Fields[1].FocusControl;
end;

procedure Tfrm_principal.dbn_servicosClick(Sender: TObject; Button: TNavigateBtn);
begin
  dbg_servicos.Fields[1].FocusControl;
end;



procedure Tfrm_principal.gerar_nota_fiscal(NumNFe : String);
Var NotaF: NotaFiscal;
    Produto: TDetCollectionItem;
    Servico: TDetCollectionItem;
    Volume: TVolCollectionItem;
    Duplicata: TDupCollectionItem;
    ObsComplementar: TobsContCollectionItem;
    ObsFisco: TobsFiscoCollectionItem;
    Referenciada: TNFrefCollectionItem;
    DI: TDICollectionItem;
    Adicao: TAdiCollectionItem;
    Rastro: TrastroCollectionItem;
    Medicamento: TMedCollectionItem;
    Arma: TArmaCollectionItem;
    Reboque: TreboqueCollectionItem;
    Lacre: TLacresCollectionItem;
    ProcReferenciado: TprocRefCollectionItem;
    InfoPgto: TpagCollectionItem;
    numItemProd, numItemServ :integer;
begin
  NotaF := ACBrNFe1.NotasFiscais.Add;
  NotaF.NFe.Ide.cNF       := StrToInt(NumNFe); //Caso não seja preenchido será gerado um número aleatório pelo componente
  NotaF.NFe.Ide.natOp     := 'VENDA PRODUCAO DO ESTAB.';
  NotaF.NFe.Ide.indPag    := ipVista;
  NotaF.NFe.Ide.modelo    := 55;
  NotaF.NFe.Ide.serie     := 1;
  NotaF.NFe.Ide.nNF       := StrToInt(NumNFe);
  NotaF.NFe.Ide.dEmi      := Date;
  NotaF.NFe.Ide.dSaiEnt   := Date;
  NotaF.NFe.Ide.hSaiEnt   := Now;
  NotaF.NFe.Ide.tpNF      := tnSaida;
  NotaF.NFe.Ide.tpEmis    := TpcnTipoEmissao(0);;
  NotaF.NFe.Ide.tpAmb     := taHomologacao;  //Lembre-se de trocar esta variável quando for para ambiente de produção
  NotaF.NFe.Ide.verProc   := '1.0.0.0'; //Versão do seu sistema
  NotaF.NFe.Ide.cUF       := UFtoCUF('PR');
  NotaF.NFe.Ide.cMunFG    := StrToInt('75353');
  NotaF.NFe.Ide.finNFe    := fnNormal;
  if  Assigned( ACBrNFe1.DANFE ) then
    NotaF.NFe.Ide.tpImp     := ACBrNFe1.DANFE.TipoDANFE;

  NotaF.NFe.Emit.CNPJCPF           := '00.000.000/0001-76';
  NotaF.NFe.Emit.IE                := '0000000000-00';
  NotaF.NFe.Emit.xNome             := 'Teste Delphi Ltda';
  NotaF.NFe.Emit.xFant             := 'Teste do Delphi';

  NotaF.NFe.Emit.EnderEmit.fone    := '41 9999-9999';
  NotaF.NFe.Emit.EnderEmit.CEP     := StrToInt('80000000');
  NotaF.NFe.Emit.EnderEmit.xLgr    := 'Rua de Teste';
  NotaF.NFe.Emit.EnderEmit.nro     := '1000';
  NotaF.NFe.Emit.EnderEmit.xCpl    := 'Apto 001';
  NotaF.NFe.Emit.EnderEmit.xBairro := 'Centro';
  NotaF.NFe.Emit.EnderEmit.cMun    := StrToInt('75353');
  NotaF.NFe.Emit.EnderEmit.xMun    := 'Curitiba';
  NotaF.NFe.Emit.EnderEmit.UF      := 'PR';
  NotaF.NFe.Emit.enderEmit.cPais   := 1058;
  NotaF.NFe.Emit.enderEmit.xPais   := 'BRASIL';

  NotaF.NFe.Emit.IEST              := '';
  NotaF.NFe.Emit.IM                := '2648800'; // Preencher no caso de existir serviços na nota
  NotaF.NFe.Emit.CNAE              := '6201500'; // Verifique na cidade do emissor da NFe se é permitido
                                // a inclusão de serviços na NFe
  NotaF.NFe.Emit.CRT               := crtRegimeNormal;// (1-crtSimplesNacional, 2-crtSimplesExcessoReceita, 3-crtRegimeNormal)

  NotaF.NFe.Dest.CNPJCPF           := '05481336000137';
  NotaF.NFe.Dest.IE                := '687138770110';
  NotaF.NFe.Dest.ISUF              := '';
  NotaF.NFe.Dest.xNome             := 'D.J. COM. E LOCAÇÃO DE SOFTWARES LTDA - ME';

  NotaF.NFe.Dest.EnderDest.Fone    := '1532599600';
  NotaF.NFe.Dest.EnderDest.CEP     := 18270170;
  NotaF.NFe.Dest.EnderDest.xLgr    := 'Rua Coronel Aureliano de Camargo';
  NotaF.NFe.Dest.EnderDest.nro     := '973';
  NotaF.NFe.Dest.EnderDest.xCpl    := '';
  NotaF.NFe.Dest.EnderDest.xBairro := 'Centro';
  NotaF.NFe.Dest.EnderDest.cMun    := 3554003;
  NotaF.NFe.Dest.EnderDest.xMun    := 'Tatui';
  NotaF.NFe.Dest.EnderDest.UF      := 'SP';
  NotaF.NFe.Dest.EnderDest.cPais   := 1058;
  NotaF.NFe.Dest.EnderDest.xPais   := 'BRASIL';
//Adicionando Produtos
  with dm_principal.fdq_nota_fiscal_produto do
  begin
    First;
    numItemProd := 0;

    while not Eof do
    begin
      Inc(numItemProd);
      Produto := NotaF.NFe.Det.Add;
      Produto.Prod.nItem    := numItemProd; // Número sequencial, para cada item deve ser incrementado
      Produto.Prod.cProd    := FieldByName('cod_produto').AsString;
      Produto.Prod.cEAN     := '7896523206646';
      Produto.Prod.xProd    := FieldByName('lkp_produto').AsString;
      Produto.Prod.NCM      := '94051010'; // Tabela NCM disponível em  http://www.receita.fazenda.gov.br/Aliquotas/DownloadArqTIPI.htm
      Produto.Prod.EXTIPI   := '';
      Produto.Prod.CFOP     := '5101';
      Produto.Prod.uCom     := 'UN';
      Produto.Prod.qCom     := FieldByName('quantidade').AsInteger;
      Produto.Prod.vUnCom   := FieldByName('valor_unitario').AsCurrency;
      Produto.Prod.vProd    := FieldByName('valor_total').AsCurrency;

      Produto.Prod.cEANTrib  := '7896523206646';
      Produto.Prod.uTrib     := 'UN';
      Produto.Prod.qTrib     := 1;
      Produto.Prod.vUnTrib   := 100;

      Produto.Prod.vOutro    := 0;
      Produto.Prod.vFrete    := 0;
      Produto.Prod.vSeg      := 0;
      Produto.Prod.vDesc     := 0;

      Produto.Prod.CEST := '1111111';

      //Produto.infAdProd := 'Informacao Adicional do Produto';


      // lei da transparencia nos impostos
      Produto.Imposto.vTotTrib := 0;
      Produto.Imposto.ICMS.CST     := cst00;
      Produto.Imposto.ICMS.orig    := oeNacional;
      Produto.Imposto.ICMS.modBC   := dbiValorOperacao;
      Produto.Imposto.ICMS.vBC     := 100;
      Produto.Imposto.ICMS.pICMS   := 18;
      Produto.Imposto.ICMS.vICMS   := 18;
      Produto.Imposto.ICMS.modBCST := dbisMargemValorAgregado;
      Produto.Imposto.ICMS.pMVAST  := 0;
      Produto.Imposto.ICMS.pRedBCST:= 0;
      Produto.Imposto.ICMS.vBCST   := 0;
      Produto.Imposto.ICMS.pICMSST := 0;
      Produto.Imposto.ICMS.vICMSST := 0;
      Produto.Imposto.ICMS.pRedBC  := 0;

       // partilha do ICMS e fundo de probreza
      Produto.Imposto.ICMSUFDest.vBCUFDest      := 0.00;
      Produto.Imposto.ICMSUFDest.pFCPUFDest     := 0.00;
      Produto.Imposto.ICMSUFDest.pICMSUFDest    := 0.00;
      Produto.Imposto.ICMSUFDest.pICMSInter     := 0.00;
      Produto.Imposto.ICMSUFDest.pICMSInterPart := 0.00;
      Produto.Imposto.ICMSUFDest.vFCPUFDest     := 0.00;
      Produto.Imposto.ICMSUFDest.vICMSUFDest    := 0.00;
      Produto.Imposto.ICMSUFDest.vICMSUFRemet   := 0.00;

      Next;
    end;
  end;

  with dm_principal.fdq_nota_fiscal_servico do
  begin
    First;
    numItemServ := 0;

    while not Eof do
    begin
      inc(numItemServ);
      //Adicionando Serviços
      Servico := NotaF.Nfe.Det.Add;
      Servico.Prod.nItem    := numItemServ; // Número sequencial, para cada item deve ser incrementado
      Servico.Prod.cProd    := FieldByName('cod_servico').AsString;
      Servico.Prod.cEAN     := '';
      Servico.Prod.xProd    := FieldByName('lkp_servico').AsString;
      Servico.Prod.NCM      := '99';
      Servico.Prod.EXTIPI   := '';
      Servico.Prod.CFOP     := '5933';
      Servico.Prod.uCom     := 'UN';
      Servico.Prod.qCom     := FieldByName('quantidade').AsInteger;
      Servico.Prod.vUnCom   := FieldByName('valor_unitario').AsCurrency;
      Servico.Prod.vProd    := FieldByName('valor_total').AsCurrency;

      Servico.Prod.cEANTrib  := '';
      Servico.Prod.uTrib     := 'UN';
      Servico.Prod.qTrib     := 1;
      Servico.Prod.vUnTrib   := 100;

      Servico.Prod.vFrete    := 0;
      Servico.Prod.vSeg      := 0;
      Servico.Prod.vDesc     := 0;

      //Servico.infAdProd      := 'Informação Adicional do Serviço';

      dm_principal.fdq_nota_fiscal_servico.Next;
    end;
  end;

  with dm_principal.fdq_nota_fiscal do
  begin
    NotaF.NFe.Total.ICMSTot.vBC     := FieldByName('calc_valor_total').AsCurrency;
    NotaF.NFe.Total.ICMSTot.vICMS   := 18;
    NotaF.NFe.Total.ICMSTot.vBCST   := 0;
    NotaF.NFe.Total.ICMSTot.vST     := 0;
    NotaF.NFe.Total.ICMSTot.vProd   := FieldByName('calc_valor_total').AsCurrency;
    NotaF.NFe.Total.ICMSTot.vFrete  := 0;
    NotaF.NFe.Total.ICMSTot.vSeg    := 0;
    NotaF.NFe.Total.ICMSTot.vDesc   := 0;
    NotaF.NFe.Total.ICMSTot.vII     := 0;
    NotaF.NFe.Total.ICMSTot.vIPI    := 0;
    NotaF.NFe.Total.ICMSTot.vPIS    := 0;
    NotaF.NFe.Total.ICMSTot.vCOFINS := 0;
    NotaF.NFe.Total.ICMSTot.vOutro  := 0;
    NotaF.NFe.Total.ICMSTot.vNF     := FieldByName('calc_valor_total').AsCurrency;
  end;

  // lei da transparencia de impostos
  NotaF.NFe.Total.ICMSTot.vTotTrib := 0;

  // partilha do icms e fundo de probreza
  NotaF.NFe.Total.ICMSTot.vFCPUFDest   := 0.00;
  NotaF.NFe.Total.ICMSTot.vICMSUFDest  := 0.00;
  NotaF.NFe.Total.ICMSTot.vICMSUFRemet := 0.00;


  NotaF.NFe.Transp.modFrete := mfContaEmitente;
  NotaF.NFe.Transp.Transporta.CNPJCPF  := '';
  NotaF.NFe.Transp.Transporta.xNome    := '';
  NotaF.NFe.Transp.Transporta.IE       := '';
  NotaF.NFe.Transp.Transporta.xEnder   := '';
  NotaF.NFe.Transp.Transporta.xMun     := '';
  NotaF.NFe.Transp.Transporta.UF       := '';

  NotaF.NFe.Transp.veicTransp.placa := '';
  NotaF.NFe.Transp.veicTransp.UF    := '';
  NotaF.NFe.Transp.veicTransp.RNTC  := '';

  Volume := NotaF.NFe.Transp.Vol.Add;
  Volume.qVol  := 1;
  Volume.esp   := 'Especie';
  Volume.marca := 'Marca';
  Volume.nVol  := 'Numero';
  Volume.pesoL := 100;
  Volume.pesoB := 110;

  NotaF.NFe.Cobr.Fat.nFat  := 'Numero da Fatura';
  NotaF.NFe.Cobr.Fat.vOrig := 100;
  NotaF.NFe.Cobr.Fat.vDesc := 0;
  NotaF.NFe.Cobr.Fat.vLiq  := 100;

  Duplicata := NotaF.NFe.Cobr.Dup.Add;
  Duplicata.nDup  := '1234';
  Duplicata.dVenc := now+10;
  Duplicata.vDup  := 50;

  Duplicata := NotaF.NFe.Cobr.Dup.Add;
  Duplicata.nDup  := '1235';
  Duplicata.dVenc := now+10;
  Duplicata.vDup  := 50;


  NotaF.NFe.InfAdic.infCpl     :=  '';
  NotaF.NFe.InfAdic.infAdFisco :=  '';

  ObsComplementar := NotaF.NFe.InfAdic.obsCont.Add;
  ObsComplementar.xCampo := 'ObsCont';
  ObsComplementar.xTexto := 'Texto';

  ObsFisco := NotaF.NFe.InfAdic.obsFisco.Add;
  ObsFisco.xCampo := 'ObsFisco';
  ObsFisco.xTexto := 'Texto';

//Processo referenciado

  NotaF.NFe.exporta.UFembarq   := '';;
  NotaF.NFe.exporta.xLocEmbarq := '';

  NotaF.NFe.compra.xNEmp := '';
  NotaF.NFe.compra.xPed  := '';
  NotaF.NFe.compra.xCont := '';

// YA. Informações de pagamento

  InfoPgto := NotaF.NFe.pag.Add;
  InfoPgto.indPag := ipVista;
  InfoPgto.tPag   := fpDinheiro;
  InfoPgto.vPag   := 100;

  ACBrNFe1.NotasFiscais.GerarNFe;
end;



end.
