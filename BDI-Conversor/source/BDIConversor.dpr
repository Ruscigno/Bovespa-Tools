program BDIConversor;

uses
  Vcl.Forms,
  ubdiMain in 'ubdiMain.pas' {fbdiMain},
  useZipFiles in '..\..\3rdParty\SuperEstruturas\class\useZipFiles.pas',
  ubdiParser in 'ubdiParser.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'DBI Conversor';
  Application.CreateForm(TfbdiMain, fbdiMain);
  Application.Run;
end.
