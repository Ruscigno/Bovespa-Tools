unit usamMainForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs, StdCtrls, ComCtrls, CheckLst,
  ExtCtrls, ubdiSplitAndMerge;

type
  TfsamMainForm = class(TForm)
    pbParser: TProgressBar;
    pbTotal: TProgressBar;
    PageControl1: TPageControl;
    tsArquivos: TTabSheet;
    tsResultado: TTabSheet;
    lbArquivos: TListBox;
    clbSplitMerge: TCheckListBox;
    ckTodos: TCheckBox;
    Panel1: TPanel;
    Label1: TLabel;
    edFile: TEdit;
    btAdicionar: TButton;
    btLimpar: TButton;
    btLocalizar: TButton;
    btAdPasta: TButton;
    OpenDialog1: TOpenDialog;
    btExecute: TButton;
    procedure btAdicionarClick(Sender: TObject);
    procedure btLimparClick(Sender: TObject);
    procedure btLocalizarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btAdPastaClick(Sender: TObject);
    procedure ckTodosClick(Sender: TObject);
    procedure btExecuteClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    Fbdi : TbdiSplitAndMerge;
  public
    { Public declarations }
    procedure OnProgress(Sender : TObject);
    procedure OnDone(Sender : TObject);
  end;

var
  fsamMainForm: TfsamMainForm;

implementation

{$R *.dfm}

procedure TfsamMainForm.btAdicionarClick(Sender: TObject);
begin
  lbArquivos.Items.Add(edFile.Text);
end;

procedure TfsamMainForm.btAdPastaClick(Sender: TObject);
begin
  if (OpenDialog1.Execute) then
    lbArquivos.Items.Text := OpenDialog1.Files.Text;
end;

procedure TfsamMainForm.btExecuteClick(Sender: TObject);
var
  i : integer;
begin
  Fbdi.SplitMerge.Clear;
  for I := 0 to clbSplitMerge.Count - 1 do
  begin
    if (clbSplitMerge.Checked[i]) then
      Fbdi.SplitMerge.Add(clbSplitMerge.Items[i]);
  end;
  Fbdi.DoSplit;
end;

procedure TfsamMainForm.btLimparClick(Sender: TObject);
begin
  lbArquivos.Items.Clear;
end;

procedure TfsamMainForm.btLocalizarClick(Sender: TObject);
begin
  if (lbArquivos.Count > 0) then
  begin
    clbSplitMerge.Clear;
    pbTotal.Position := 0;
    pbParser.Position := 0;
    Fbdi.FileList.Text := lbArquivos.Items.Text;
    Fbdi.SearchForSplitMerge;
    PageControl1.ActivePageIndex := 1;
  end
  else
    ShowMessage('A lista esta vazia!');
end;

procedure TfsamMainForm.ckTodosClick(Sender: TObject);
  procedure CheckAll(State : TCheckBoxState);
  var
    i : integer;
  begin
    //retro compatibility
    for I := 0 to clbSplitMerge.Count - 1 do
    begin
      if (State = cbChecked) then
        clbSplitMerge.Checked[i] := True
      else
        clbSplitMerge.Checked[i] := False;
    end;
  end;

begin
  if ckTodos.Checked then
    CheckAll(cbChecked)
  else
    CheckAll(cbUnchecked);
end;

procedure TfsamMainForm.FormCreate(Sender: TObject);
begin
  Fbdi := TbdiSplitAndMerge.Create;
  Fbdi.OnProgress := OnProgress;
  Fbdi.OnDone := OnDone;
end;

procedure TfsamMainForm.FormDestroy(Sender: TObject);
begin
  Fbdi.Free;
end;

procedure TfsamMainForm.FormShow(Sender: TObject);
begin
  PageControl1.ActivePageIndex := 0;
  edFile.Text := IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName)) + 'POMO3.csv'; 
end;

procedure TfsamMainForm.OnDone(Sender: TObject);
begin
  clbSplitMerge.Items.Text := Fbdi.SplitMerge.Text;
end;

procedure TfsamMainForm.OnProgress(Sender: TObject);
begin
  pbParser.Max := Fbdi.BetaMax;
  pbParser.Position := Fbdi.BetaPos;
  pbTotal.Max := Fbdi.AlphaMax;
  pbTotal.Position := Fbdi.AlphaPos;
  Application.ProcessMessages;
end;

end.
