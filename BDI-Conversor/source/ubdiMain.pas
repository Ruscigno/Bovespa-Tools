unit ubdiMain;

interface

uses
  ubdiParser, Vcl.Forms, Vcl.Controls, Vcl.StdCtrls, Vcl.ComCtrls,
  System.Classes;

type
  TfbdiMain = class(TForm)
    Label1: TLabel;
    edFile: TEdit;
    btParser: TButton;
    pbParser: TProgressBar;
    lbArquivos: TListBox;
    btAdicionar: TButton;
    btLimpar: TButton;
    pbTotal: TProgressBar;
    procedure btParserClick(Sender: TObject);
    procedure btLimparClick(Sender: TObject);
    procedure btAdicionarClick(Sender: TObject);
  private
    { Private declarations }
    bdi : TbdiParser;
    procedure OnProgress(Sender : TObject);
  public
    { Public declarations }
  end;

var
  fbdiMain: TfbdiMain;

implementation

{$R *.dfm}

procedure TfbdiMain.btParserClick(Sender: TObject);
var
  i : Integer;
begin
  pbTotal.Position := 1;
  pbTotal.Max := lbArquivos.Items.Count;
  for i := 0 to lbArquivos.Items.Count - 1 do
  begin
    pbParser.Position := 0;
    bdi := TbdiParser.Create(lbArquivos.Items[i]);
    try
      bdi.OnProgress := OnProgress;
      bdi.InverseOrder := True;
      bdi.Parser;
    finally
      bdi.Free;
    end;
    pbTotal.StepIt;
  end;
end;

procedure TfbdiMain.OnProgress(Sender: TObject);
begin
  pbParser.Max := bdi.ProgMax;
  pbParser.StepIt;
  Application.ProcessMessages;
end;

procedure TfbdiMain.btLimparClick(Sender: TObject);
begin
  lbArquivos.Items.Clear;
end;

procedure TfbdiMain.btAdicionarClick(Sender: TObject);
begin
  lbArquivos.Items.Add(edFile.Text);
end;

end.
