program BDIConversor;

uses
  Vcl.Forms,
  ubdiMain in '..\ubdiMain.pas' {fbdiMain},
  ubdiParser in '..\ubdiParser.pas',
  useZipFiles in '..\..\..\3rdParty\Super-Estruturas\source\class\useZipFiles.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'DBI Conversor';
  Application.CreateForm(TfbdiMain, fbdiMain);
  Application.Run;
end.
