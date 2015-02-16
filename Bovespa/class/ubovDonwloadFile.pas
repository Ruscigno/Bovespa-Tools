unit ubovDonwloadFile;

interface

uses
  System.SysUtils, System.Classes, IdHTTP, IdComponent, ubovDataWork;

type
  TbovDonwloadBase = class(TbovDataWork)
  private
    FnValidTime : integer;
    FhrLastTime : real;
    FhrNextTime : real;
    procedure SetValidTime(const Value: integer);
  public
    property ValidTime : integer read FnValidTime write SetValidTime; //Tempo que o arquivo vai ser válido
  end;

  TbovDonwloadFile = class(TbovDonwloadBase)
  private
    FbExecOnce: boolean;
    FbSaveToFile: boolean;
    FFileURL: string;
    FnPercent: integer;
    FoFileStream : TMemoryStream;
    FOnDone: TNotifyEvent;
    FOnProgress: TNotifyEvent;
    FsIdent: string;
    FsLastError: string;
    FsOutputFile: string;
    FsSection: string;
    procedure HttpWork(ASender: TObject; AWorkMode: TWorkMode; AWorkCount: Int64);
    procedure SetFileURL(const Value: string);
    function GetMemoryStream: TMemoryStream;
    function GetFileString: string;
  protected
    function DownloadValido : boolean;
    function DoWork : boolean; override;
  public
    constructor Create; override;
    destructor Destroy; override;
    function DownloadFile : boolean;
    function Save(psFile : string) : boolean;
    property ExecOnce : boolean read FbExecOnce write FbExecOnce default True;
    property FileStream : TMemoryStream read GetMemoryStream;
    property FileString : string read GetFileString;
    property FileURL : string read FFileURL write SetFileURL;
    property Ident : string read FsIdent write FsIdent;
    property OnProgress : TNotifyEvent read FOnProgress write FOnProgress;
    property OnDone : TNotifyEvent read FOnDone write FOnDone;
    property OutputFile : string read FsOutputFile write FsOutputFile;
    property Percent : integer read FnPercent write FnPercent;
    property SaveToFile : boolean read FbSaveToFile write FbSaveToFile;
    property Section : string read FsSection write FsSection;
    property LastError : string read FsLastError write FsLastError;
  end;

  TbovDownloadFileList = class;
  TbovDonwloadFileListEvent = procedure(psKey : string; psFile : string; Sender: TbovDownloadFileList) of object;

  TbovDownloadFileList = class(TbovDonwloadBase)
  private
    FnIndex : integer;
    FoDwnFile : TbovDonwloadFile;
    FoKeyList: TStringList;
    FOnFileDone: TbovDonwloadFileListEvent;
    FoOutputList: TStringList;
    FoURLList: TStringList;
    FOnDone: TNotifyEvent;
    FnSleepTimeList: integer;
    function DownloadFile(pnIndex: integer) : TMemoryStream;
  protected
    function DoWork : boolean; override;
    procedure InternalOnDone;
    procedure InternalOnFileDone;
  public
    constructor Create; override;
    destructor Destroy; override;
    function GetFileStream(psKey : string) : TMemoryStream;
    procedure Add(psKey, psURLFile, psOutputFile : string);
    procedure Remove(psKey : string);
    property KeyList : TStringList read FoKeyList write FoKeyList;
    property OnFileDone : TbovDonwloadFileListEvent read FOnFileDone write FOnFileDone;
    property OnDone : TNotifyEvent read FOnDone write FOnDone;
    property OutputList : TStringList read FoOutputList write FoOutputList;
    property URLList : TStringList read FoURLList write FoURLList;
    property SleepTime : integer read FnSleepTimeList write FnSleepTimeList;
  end;

implementation

uses
  System.DateUtils, System.IniFiles, useConstants, useAplicacao;

procedure TbovDonwloadBase.SetValidTime(const Value: integer);
begin
  if (FnValidTime <> Value) then
  begin
    if (FhrLastTime <> 0) then
      FhrNextTime := IncMinute(FhrLastTime, Value);
  end;
end;

{ TbovDonwloadFile }

constructor TbovDonwloadFile.Create;
begin
  inherited;
  FFileURL := STRING_INDEFINIDO;
  FsOutputFile := STRING_INDEFINIDO;
  LoadConfig;
//  FnSleepTime := 24 * 60;
  FhrLastTime := 0;
  FhrNextTime := 0;
  FsSection := 'Download';
  FsIdent := 'Data';
  FbSaveToFile := True;
  FnPercent := 0;
end;

destructor TbovDonwloadFile.Destroy;
begin
  FreeAndNil(FoFileStream);
  inherited;
end;

procedure TbovDonwloadFile.HttpWork(ASender: TObject; AWorkMode: TWorkMode; AWorkCount: Int64);
var
  Http: TIdHTTP;
  ContentLength: Int64;
begin
  Http := TIdHTTP(ASender);
  ContentLength := Http.Response.ContentLength;

  if (Pos('chunked', LowerCase(Http.Response.TransferEncoding)) = 0) and
     (ContentLength > 0) then
  begin
    FnPercent := 100*AWorkCount div ContentLength;
  end;
  if Assigned(FOnProgress) then
    FOnProgress(Self);
end;

function TbovDonwloadFile.DownloadFile: boolean;
var
  aFile : TIniFile;
  nData : TDateTime;
  nResult : integer;

  function InternalDownload : integer;
  var
    Http: TIdHTTP;
  begin
    oAplicacao.AddLog(Self.ClassName, 'Begin [Download]');
    oAplicacao.AddLog(Self.ClassName, FileURL);
    Result := 0;
    if Assigned(FoFileStream) then
      FreeAndNil(FoFileStream);

    FoFileStream := TMemoryStream.Create;

    //Se o arquivo já existir e ainda for válido, apenos o carrego...
    if FileExists(FsOutputFile) and (IncMinute(FileDateToDateTime(FileAge(FsOutputFile)), FnValidTime) >= Now) then
    begin
      FoFileStream.LoadFromFile(FsOutputFile);
      if (FoFileStream.Size > 0) then
      begin
        Result := 1;
        Exit;
      end;
    end;

    Http := TIdHTTP.Create(nil);
    try
      try
        Http.OnWork:= HttpWork;
        Http.Get(PChar(FileURL), FoFileStream);
        if (FbSaveToFile) then
          Save(FsOutputFile);
        Result := 2;
      except
        On E: Exception do
        begin
          oAplicacao.AddLog(Self.ClassName, E.Message);
          FsLastError := E.Message;
        end;
      end;
    finally
      Http.Free;
    end;
    oAplicacao.AddLog(Self.ClassName, 'End [Download]');
  end;

begin
  nResult := 0;
  if (FbSaveToFile) then
  begin
    aFile := TIniFile.Create(ConfigFile);
    try
      nData := aFile.ReadDate(FsSection, FsIdent, 0);
      if (Trunc(nData) < Trunc(Now)) or not Assigned(FoFileStream) or (FoFileStream.Size = 0) then
      begin
        try
          nResult := InternalDownload;
          if (nResult <> 1) then
            aFile.WriteDate(FsSection,FsIdent, Now);
        except
          on E: Exception do
            oAplicacao.AddLog(Self.ClassName, E.Message);
        end;
      end;
      result := (nResult > 0);
    finally
      aFile.Free;
    end;
  end
  else
    result := Boolean(InternalDownload);
  if Assigned(FOnDone) then
    FOnDone(Self);
end;

function TbovDonwloadFile.DownloadValido : boolean;
begin
  if (FFileURL <> '') and (FnValidTime >= 0) then
  begin
    Result := DownloadFile;
    if (Result) then
    begin
      FhrLastTime := Now;
      FhrNextTime := IncHour(FhrLastTime, FnValidTime);
      InternalDone;
    end;
  end
  else
    Result := False;
end;

function TbovDonwloadFile.DoWork : boolean;
begin
  Result := inherited DoWork;
  if not(Result) then
    Exit;

  while (result) and not (Terminated) do
  begin
    //Tá na hora
    if (FhrNextTime <= Now) and not(DownloadValido) then
    begin
      Result := False;
      Break;
    end;
    if (FbExecOnce) then
      result := False
    else
      Sleep(3000);
  end;
end;

procedure TbovDonwloadFile.SetFileURL(const Value: string);
begin
  //Faz mais alguma coisa...
  if (FFileURL <> Value) then
    FFileURL := Value;
end;

function TbovDonwloadFile.GetMemoryStream: TMemoryStream;
var
  bSave : boolean;
begin
  bSave := FbSaveToFile;
  FbSaveToFile := False;
  if not Assigned(FoFileStream) then
    DownloadFile;
  FbSaveToFile := bSave;
  Result := FoFileStream;
end;

function TbovDonwloadFile.GetFileString: string;
begin
  SetString(Result, PChar(FoFileStream.Memory), FoFileStream.Size div SizeOf(Char));
end;

function TbovDonwloadFile.Save(psFile: string) : boolean;
var
  sPath : string;
begin
  Result := False;
  if (psFile <> STRING_INDEFINIDO) then
  begin
    sPath := ExtractFilePath(psFile);
    if (sPath <> '') and not DirectoryExists(sPath) then
      if not (CreateDir(sPath)) then
        Exit;
    FoFileStream.SaveToFile(psFile);
    Result := True;
  end;
end;

{ TbovDownloadFileList }

constructor TbovDownloadFileList.Create;
begin
  inherited Create;
  FnSleepTimeList := 24 * 60;
  FoURLList := TStringList.Create;
  FoOutputList := TStringList.Create;
  FoKeyList := TStringList.Create;
end;

destructor TbovDownloadFileList.Destroy;
begin
  FoURLList.Free;
  FoOutputList.Free;
  FoKeyList.Free;
  inherited;
end;

function TbovDownloadFileList.DoWork : boolean;
var
  nLoop : integer;
begin
  Result := inherited DoWork;
  if not(Result) then
    Exit;

  nLoop := 0;
  while (nLoop <= FoKeyList.Count - 1)and not(Terminated) do
  begin
    DownloadFile(nLoop);
    inc(nLoop);
  end;
end;

procedure TbovDownloadFileList.Add(psKey, psURLFile, psOutputFile: string);
begin
  FoKeyList.Add(psKey);
  FoURLList.Add(psURLFile);
  FoOutputList.Add(psOutputFile);
end;

procedure TbovDownloadFileList.Remove(psKey: string);
var
  nKey : integer;
begin
  nKey := FoKeyList.IndexOf(psKey);
  if (nKey > -1) then
  begin
    FoKeyList.Delete(nKey);
    FoURLList.Delete(nKey);
    FoOutputList.Delete(nKey);
  end;
end;

function TbovDownloadFileList.DownloadFile(pnIndex : integer) : TMemoryStream;
//var
//  ebovEmpresa : TebovEmpresa;
begin
  FnIndex := pnIndex;
  result := nil;
  FoDwnFile := TbovDonwloadFile.Create;
//  ebovEmpresa := TebovEmpresa(CriaDataset(TebovEmpresa,'SelectPadrao', False));
  try
//    ebovEmpresa.ParamByName('CDEMPRESA').AsString := Copy(FoKeyList[pnIndex], 1, 12);
//    ebovEmpresa.Open;
    FoDwnFile.SaveToFile := True;
    FoDwnFile.FileURL := FoURLList[pnIndex];
    FoDwnFile.OutputFile := FoOutputList[pnIndex];
    FoDwnFile.Ident := FoKeyList[pnIndex];
    try
      FoDwnFile.DownloadFile;
      InternalOnFileDone;
      Result := FoDwnFile.FoFileStream;
    except
//      On E: EIdHTTPProtocolException do
//      begin
//        //Não encontrou
//        if (E.ErrorCode = 404) then
//          ebovEmpresa.RegistraErroEmpresa(E.ErrorCode, E.Message)
//        else
//        begin
//          ebovEmpresa.RegistraErroEmpresa(E.ErrorCode, E.Message, 'E');
//          raise;
//        end
//      end;
      On E: Exception do
      begin
//        ebovEmpresa.RegistraErroEmpresa(NUMERO_INDEFINIDO, E.Message, 'E');
        raise;
      end
    end;
  finally
    FoDwnFile.Free;
//    if (ebovEmpresa.UpdatesPending) then
//      ebovEmpresa.ApplyUpdates;
//    ebovEmpresa.Free;
  end;
end;

function TbovDownloadFileList.GetFileStream(psKey: string): TMemoryStream;
var
  nIndex : integer;
begin
  nIndex := FoKeyList.IndexOf(psKey);
  if (nIndex > -1) then
    Result := DownloadFile(nIndex)
  else
    Result := nil;
end;

procedure TbovDownloadFileList.InternalOnFileDone;
begin
  if Assigned(FOnFileDone) then
    FOnFileDone(FoKeyList[FnIndex], FoDwnFile.OutputFile, Self);
end;

procedure TbovDownloadFileList.InternalOnDone;
begin

end;

end.

