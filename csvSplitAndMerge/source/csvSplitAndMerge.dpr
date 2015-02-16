program csvSplitAndMerge;

uses
  Vcl.Forms,
  usamMainForm in 'usamMainForm.pas' {fsamMainForm},
  ubdiSplitAndMerge in 'ubdiSplitAndMerge.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfsamMainForm, fsamMainForm);
  Application.Run;
end.
