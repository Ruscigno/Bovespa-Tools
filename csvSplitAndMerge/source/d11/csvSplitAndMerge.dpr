program csvSplitAndMerge;

uses
  Forms,
  usamMainForm in '..\usamMainForm.pas' {fsamMainForm},
  ubdiSplitAndMerge in '..\ubdiSplitAndMerge.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'CSV Split & Merge';
  Application.CreateForm(TfsamMainForm, fsamMainForm);
  Application.Run;
end.
