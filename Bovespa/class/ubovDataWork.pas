unit ubovDataWork;

interface

uses
  System.SysUtils, System.Classes, ubovConstants;

type
  TbovDataWork = class;

  TbovDataWorkClass = class of TbovDataWork;

  TbovDataWorkProgress = procedure(var Terminate : boolean; piMin, piMax, piPos : integer; psMsg : string; Sender : TObject) of object;
  TbovDataWorkError = procedure(Sender: TObject; E : Exception) of object;

  TbovDataWork = class(TObject)
  private
    { Privated declarations }
//    FsqlExecs : TmpgSQLProcessor;
    FbTerminated : Boolean;
    FdtPregao: TDateTime;
    FnBVMFIndex: integer;
    FnStatusPanel : integer;
    FOnDone: TNotifyEvent;
    FOnProgress: TbovDataWorkProgress;
    FOnStart: TNotifyEvent;
    FOnStop: TNotifyEvent;
    FscdEmpresa : string;
    FsConfigFile: string;
    FsConfigSection: string;
    FsflTipo: string;
    FsProgressMessage: string;
//    FZConnection : TmpgConnection;
    FOnError: TbovDataWorkError;
    function GetConfigFile: string;
    procedure InternalStatusBar;
    procedure SetProgressMessage(const Value: string);
  protected
    { Protected declarations }
    FnMax, FnMin, FnPos: Integer;
    FOperacoesBanco: TOperacoesBancoEnum;
    function ClearDataSets : boolean; dynamic;
    function DoWork : boolean; dynamic;
    procedure CheckBoundsProgress(var pnMin, pnMax, pnPos : Integer);
    procedure ClearProgress;
    procedure CreateDataSets; dynamic;
    procedure DestroyDataSets; dynamic;
    procedure InternalDone; dynamic;
    procedure InternalProgress;
    procedure InternalStart;
//    procedure SetConnection(const Value: TmpgConnection); virtual;
    procedure SetOperacoesBanco(const Value: TOperacoesBancoEnum); virtual;
    procedure StatusBarText(pText : String; iPanel : Integer = 0);
    procedure StepIt(pnInc : Integer = 1);
  public
    constructor Create; virtual;
    destructor Destroy; override;
    function Execute : boolean; dynamic;
    procedure LoadConfig; dynamic;
    procedure SaveConfig; dynamic;
    procedure Stop; virtual;
    property BVMFIndex : integer read FnBVMFIndex write FnBVMFIndex;
    property cdEmpresa : string read FscdEmpresa write FscdEmpresa;
    property ConfigFile : string read GetConfigFile write FsConfigFile;
    property ConfigSection : string read FsConfigSection write FsConfigSection;
//    property Connection : TmpgConnection read FZConnection write SetConnection;
    property dtPregao : TDateTime read FdtPregao write FdtPregao;
    property flTipo : string read FsflTipo write FsflTipo;
    property OnDone : TNotifyEvent read FOnDone write FOnDone;
    property OnProgress : TbovDataWorkProgress read FOnProgress write FOnProgress;
    property OnStart : TNotifyEvent read FOnStart write FOnStart;
    property OnStop : TNotifyEvent read FOnStop write FOnStop;
    property OnError : TbovDataWorkError read FOnError write FOnError;
    property OperacoesBanco : TOperacoesBancoEnum read FOperacoesBanco write SetOperacoesBanco default obManterHistorico;
    property ProgressMessage : string read FsProgressMessage write SetProgressMessage;
    property Terminated : Boolean read FbTerminated write FbTerminated;
//    property sqlExecs : TmpgSQLProcessor read FsqlExecs write FsqlExecs;
  end;

implementation

uses
  System.IniFiles, useConstants, useAplicacao, useFunctions;

{ TbovDataWork }

procedure TbovDataWork.CheckBoundsProgress(var pnMin, pnMax, pnPos: Integer);
begin
  if (pnMin > pnMax) then
    pnMin := pnMax;
  if (pnPos > pnMax) then
    pnPos := pnMax
  else if (pnPos < pnMin) then
    pnPos := pnMin;
end;

constructor TbovDataWork.Create;
begin
  inherited;
//  FsqlExecs := TmpgSQLProcessor.Create(nil);
  FOnProgress := nil;
  FOnDone := nil;
  FOnStart := nil;
  FsProgressMessage := STRING_INDEFINIDO;
  FnPos := 0;
  FnMax := 0;
  FnMin := 0;
  FnStatusPanel := 0;
  FsConfigSection := ClassName;

  LoadConfig;
end;

destructor TbovDataWork.Destroy;
begin
  SaveConfig;
//  FsqlExecs.Free;
  inherited;
end;

function TbovDataWork.DoWork : boolean;
begin
  result := True;
  if not Terminated then
  begin
    ClearProgress;
    InternalStart;
  end;
end;

function TbovDataWork.Execute : boolean;
begin
  result := False;
  if (Terminated) then
    Exit;
  CreateDataSets;
  ClearDataSets;
  try
    oAplicacao.AddLog(Self.ClassName, 'Execute: Begin [' + FscdEmpresa + '-' + FsflTipo + ']');
    result := DoWork;
    oAplicacao.AddLog(Self.ClassName, 'Execute: End');
  except
    on E: Exception do
    begin
      oAplicacao.AddLog(Self.ClassName, 'Execute: Error: ' + E.Message);
      if Assigned(FOnError) then
        FOnError(Self, E);
    end;
  end;
  DestroyDataSets;
  InternalDone;
end;

procedure TbovDataWork.InternalDone;
begin
  FsProgressMessage := 'Feito';
  if Assigned(FOnProgress) then
    FOnProgress(FbTerminated, 0, 0, 0, FsProgressMessage, Self);
  if Assigned(FOnDone) then
    FOnDone(Self);
end;

procedure TbovDataWork.InternalProgress;
begin
  if Assigned(FOnProgress) then
    FOnProgress(FbTerminated, FnMin, FnMax, FnPos, FsProgressMessage, Self);
end;

procedure TbovDataWork.InternalStart;
begin
  if Assigned(FOnStart) then
    FOnStart(Self);
end;

procedure TbovDataWork.StatusBarText(pText: String; iPanel: Integer);
begin
  FsProgressMessage := pText;
  FnStatusPanel := iPanel;
  InternalStatusBar;
end;


procedure TbovDataWork.InternalStatusBar;
begin
  try
    useFunctions.StatusBarText(FsProgressMessage, FnStatusPanel);
  except
  end;
end;

procedure TbovDataWork.StepIt(pnInc: Integer);
begin
  FnPos := FnPos + pnInc;
  InternalProgress;
end;

procedure TbovDataWork.Stop;
begin
  if Assigned(FOnStop) then
    FOnStop(Self);
end;

function TbovDataWork.GetConfigFile: string;
begin
  FsConfigFile := useFunctions.GetConfigFile;
  Result := FsConfigFile;
end;

procedure TbovDataWork.SaveConfig;
var
  FFile : TIniFile;
begin
  FFile := TIniFile.Create(ConfigFile);
  try
    FFile.WriteInteger(sDATAWORK_CONFIG,'BVMFIndex', FnBVMFIndex);
  finally
    FFile.Free;
  end;
end;

procedure TbovDataWork.LoadConfig;
var
  FFile : TIniFile;
begin
  inherited;
  FFile := TIniFile.Create(ConfigFile);
  try
    FnBVMFIndex := FFile.ReadInteger(sDATAWORK_CONFIG, 'BVMFIndex', 1);
  finally
    FFile.Free;
  end;
end;

function TbovDataWork.ClearDataSets: boolean;
begin
  Result := True;
end;

procedure TbovDataWork.CreateDataSets;
begin

end;

procedure TbovDataWork.DestroyDataSets;
begin

end;

//procedure TbovDataWork.SetConnection(const Value: TmpgConnection);
//begin
//  FZConnection := Value;
//  FsqlExecs.Connection := FZConnection;
//end;

procedure TbovDataWork.SetOperacoesBanco(const Value: TOperacoesBancoEnum);
begin
  FOperacoesBanco := Value;
end;

procedure TbovDataWork.SetProgressMessage(const Value: string);
begin
  FsProgressMessage := Value;
  StepIt(0);
end;

procedure TbovDataWork.ClearProgress;
begin
  FnMin := 0;
  FnMax := 0;
  FnPos := 0;
  ProgressMessage := 'Inicializando';
end;

end.

