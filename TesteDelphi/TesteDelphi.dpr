program TesteDelphi;

uses
  Vcl.Forms,
  principal in 'principal.pas' {frm_principal},
  data_module in 'data_module.pas' {dm_principal: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(Tfrm_principal, frm_principal);
  Application.CreateForm(Tdm_principal, dm_principal);
  Application.Run;
end.
