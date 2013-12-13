program Gofy;

uses
  Forms,
  uMainForm in 'uMainForm.pas' {frmMain},
  uChsLok in 'uChsLok.pas' {frmChsLok},
  uPlayer in 'uPlayer.pas',
  uCardDeck in 'uCardDeck.pas',
  Choise in 'Choise.pas' {ChoiseForm},
  uInvChsForm in 'uInvChsForm.pas' {frmInv},
  uCommon in 'uCommon.pas',
  uInvestigator in 'uInvestigator.pas',
  uCardForm in 'uCardForm.pas' {frmCard},
  uTradeForm in 'uTradeForm.pas' {frmTrade};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Gofy';
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmChsLok, frmChsLok);
  Application.CreateForm(TChoiseForm, ChoiseForm);
  Application.CreateForm(TfrmInv, frmInv);
  Application.CreateForm(TfrmCard, frmCard);
  Application.CreateForm(TfrmTrade, frmTrade);
  Application.Run;
end.
