unit ubdiParser;

interface

uses
  Classes;

type
  TbdiParser = class(TObject)
  private
    FsFile : string;
    FsLine : string;
    FLines : TStringList;
    FEmpresa : TStringList;
    FsBDI, FsEmpresa : string;
    FnData : TDateTime;
    FnAbre, FnMax, FnMin, FnFecha, FnVol : Real;
    FnProgMax: Integer;
    FOnProgress: TNotifyEvent;
    FbInverseOrder: Boolean;
    procedure LeiaRegistro;
    function PegaTexto(sBuffer, sTipo: String; iStart, iStop: integer): string;
    procedure SaveToFile;
  public
    constructor Create(psFile : string);
    procedure Parser;
    procedure DeleteInvalidFiles(pFileList : TStrings);
    property ProgMax : Integer read FnProgMax write FnProgMax;
    property OnProgress : TNotifyEvent read FOnProgress write FOnProgress;
    property InverseOrder : Boolean read FbInverseOrder write FbInverseOrder;
  end;

implementation

uses
  System.SysUtils;

{ TbdiParser }

constructor TbdiParser.Create(psFile: string);
begin
  FsFile := psFile;
  FbInverseOrder := False;
end;


procedure TbdiParser.Parser;
var
  i : Integer;
begin
  FormatSettings.DecimalSeparator := '.';
  if not Assigned(FLines) then
    FLines := TStringList.Create;
  if not Assigned(FEmpresa) then
    FEmpresa := TStringList.Create;

  try
    FLines.LoadFromFile(FsFile);
    FLines.Delete(0);
    FLines.Delete(FLines.Count - 1);
    FnProgMax := FLines.Count;
    for i :=  0 to FnProgMax - 1 do
    begin
      FsLine := FLines[i];
      LeiaRegistro;
      if ((FsBDI = '02') {or (FsBDI = '96') or (FsBDI = '12') or (FsBDI = '14')}) then
        SaveToFile;
      if Assigned(FOnProgress) then
        FOnProgress(Self);
    end;
  finally
    FLines.Free;
    FEmpresa.Free;
  end;
end;

procedure TbdiParser.DeleteInvalidFiles(pFileList: TStrings);
var
  I: Integer;
  aFile : TStringList;
begin
  aFile := TStringList.Create;
  try
    for I := 0 to pFileList.Count - 1 do
    begin
      aFile.LoadFromFile(pFileList[I]);
      if (aFile.Count > 0) then
      begin
        FnData := StrToDate(Trim(Copy(aFile[0], 1, 10)));
        if (Now - 30 > FnData) then
          DeleteFile(pFileList[I]);
      end
      else
        DeleteFile(pFileList[I]);
    end;
  finally
    aFile.Free;
  end;
end;

procedure TbdiParser.LeiaRegistro;
begin
  FnData     := StrToDate(PegaTexto(FsLine, 'D',   3, 10));
  FsEmpresa  := PegaTexto(FsLine, 'C',  13, 24);
  FsBDI      := PegaTexto(FsLine, 'C',  11, 12);
  FnAbre     := StrToFloat(PegaTexto(FsLine, 'F',  57, 69));
  FnMax      := StrToFloat(PegaTexto(FsLine, 'F',  70, 82));
  FnMin      := StrToFloat(PegaTexto(FsLine, 'F',  83, 95));
  FnFecha    := StrToFloat(PegaTexto(FsLine, 'F', 109,121));
  FnVol      := StrToFloat(PegaTexto(FsLine, 'F', 171,188));
end;

function TbdiParser.PegaTexto(sBuffer: String; sTipo: String; iStart,iStop: integer): string;
begin
  Result := Trim(Copy(sBuffer, iStart, (iStop-iStart)+1));
  //Tipos:
  //C: caracter
  //N: número
  //D: Data
  if (sTipo = 'D') then
  begin
    if (Result = '99991231') then
      Result := ''
    else
      Result := Copy(Result,7,2) + '/' + Copy(Result,5,2) + '/' + Copy(Result,1,4);
  end
  else if (sTipo = 'F') then
  begin
    Result := Copy(Result,1, Length(Result)-2)+'.'+Copy(Result,Length(Result)-1, 2);
  end;
  //NUMERO_INDEFINIDO
  if (Result = '') and ((sTipo = 'F') or (sTipo = 'N')) then
    Result := '-999';
end;

procedure TbdiParser.SaveToFile;
var
  oFile : TStringList;
  sFileCSV : string;
  sAdd : string;
begin
  oFile := TStringList.Create;
  sFileCSV := IncludeTrailingPathDelimiter(ExtractFilePath(FsFile));
  sFileCSV := sFileCSV + FsEmpresa + '.csv';
  try
    if FileExists(sFileCSV) then
      oFile.LoadFromFile(sFileCSV);

    sAdd := DateToStr(FnData) + ';' +
            FloatToStr(FnAbre) + ';' +
            FloatToStr(FnMax) + ';' +
            FloatToStr(FnMin) + ';' +
            FloatToStr(FnFecha) + ';' +
            FloatToStr(FnVol);
    if not FbInverseOrder then
      oFile.Add(sAdd)
    else
      oFile.Insert(0, sAdd);
    oFile.SaveToFile(sFileCSV);
  finally
    oFile.Free;
  end;
end;

end.
