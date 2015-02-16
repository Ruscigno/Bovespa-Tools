unit ubdiSplitAndMerge;

interface

uses
  Classes;

type
  TbdiSplitAndMerge = class(TObject)
  private
    FsFileName : string;
    FSymbol : TStringList;
    FSplitMerge : TStringList;
    FnAlphaMax: Integer;
    FOnProgress: TNotifyEvent;
    FLast, FLine : TStringList;
    FsSymbol : String;
    FFileList: TStringList;
    FnBetaMax: Integer;
    FnAlphaPos: Integer;
    FnBetaPos: Integer;
    FOnDone: TNotifyEvent;
    procedure DoMergeSplit(pnPosition : Integer; pSplit : TStringList);
    procedure ProcessFile;
  public
    constructor Create;
    destructor Destroy; override;
    procedure SearchForSplitMerge;
    procedure DoSplit;
    property AlphaMax : Integer read FnAlphaMax write FnAlphaMax;
    property BetaMax : Integer read FnBetaMax write FnBetaMax;
    property AlphaPos : Integer read FnAlphaPos write FnAlphaPos;
    property BetaPos : Integer read FnBetaPos write FnBetaPos;
    property OnProgress : TNotifyEvent read FOnProgress write FOnProgress;
    property OnDone : TNotifyEvent read FOnDone write FOnDone;
    property SplitMerge : TStringList read FSplitMerge write FSplitMerge;
    property FileName : string read FsFileName write FsFileName;
    property FileList : TStringList read FFileList write FFileList;
  end;

implementation

uses
  System.SysUtils, System.Math;

const
  nDATE = 0;
  nOPEN = 1;
  nPMAX = 2;
  nPMIN = 3;
  nCLOS = 4;
  NVOLU = 6;

{ TbdiSplitAndMerge }

constructor TbdiSplitAndMerge.Create;
begin
  FSplitMerge := TStringList.Create;
  FFileList := TStringList.Create;
end;

destructor TbdiSplitAndMerge.Destroy;
begin
  FSplitMerge.Free;
  FFileList.Free;
  FLast.Free;
  FSymbol.Free;
end;


procedure TbdiSplitAndMerge.SearchForSplitMerge;
var
  i : Integer;
begin
  if (FFileList.Count < 1) then
    FFileList.Add(FsFileName);

  FSplitMerge.Clear;
  FnAlphaMax := FFileList.Count;
  FnAlphaPos := 0;
  FnBetaPos := 0;
  for I := 0 to FFileList.Count - 1 do
  begin
    FsFileName := FFileList[i];
    ProcessFile;
    Inc(FnAlphaPos);
    if Assigned(FOnProgress) then
      FOnProgress(Self);
  end;
  if Assigned(FOnDone) then
    FOnDone(Self);
end;

procedure TbdiSplitAndMerge.DoMergeSplit(pnPosition: Integer; pSplit : TStringList);
var
  nFator, anOpen, anClose : Real;
  sType : string;
  I: Integer;
  nValMax, nValMin, nValOpe, nValClo : Real;
begin
  System.Math.SetRoundMode(rmTruncate);
  anOpen  := StrToFloat(pSplit[6]);
  anClose := StrToFloat(pSplit[4]);
  nFator := Round(StrToFloat(pSplit[8]));
  if (nFator >= 2) then
    sType := 'S'
  else if (nFator < 1) then
  begin
    nFator := 1 / Round(anOpen / anClose);
    sType := 'M'
  end;
  FLine := TStringList.Create;
  try
    FLine.Delimiter := ';';
    for I := pnPosition to FSymbol.Count - 1 do
    begin
      FLine.DelimitedText := Trim(FSymbol[i]);
      FLine[nOPEN] := FloatToStr(RoundTo(StrToFloat(FLine[nOPEN]) * nFator, 2));
      FLine[nCLOS] := FloatToStr(RoundTo(StrToFloat(FLine[nCLOS]) * nFator, 2));
      FLine[nPMAX] := FloatToStr(RoundTo(StrToFloat(FLine[nPMAX]) * nFator, 2));
      FLine[nPMIN] := FloatToStr(RoundTo(StrToFloat(FLine[nPMIN]) * nFator, 2));
      FSymbol[i] := FLine.DelimitedText;
    end;
    FSymbol.SaveToFile(FsFileName);
  finally
    FreeAndNil(FLine);
  end;
end;

procedure TbdiSplitAndMerge.DoSplit;
var
  aSplit : TStringList;
  I: Integer;
  sSymbol, sData : string;
  A: Integer;
begin
  aSplit := TStringList.Create;
  try
    aSplit.Delimiter := ':';
    FnAlphaPos := 0;
    FnAlphaMax := FSplitMerge.Count;
    FnBetaPos := 0;
    for I := 0 to FnAlphaMax - 1 do
    begin
      aSplit.DelimitedText := FSplitMerge[i];
      if (aSplit.Count > 0) then
      begin
        FsFileName := Trim(aSplit[10] + ':' + aSplit[11]);
        FSymbol.LoadFromFile(FsFileName);
        sSymbol := Trim(aSplit[1]);
        sData := Trim(aSplit[2]);
        for A := 0 to FSymbol.Count - 1 do
        begin
          if (Copy(FSymbol[A], 0, 10) = sData) then
            DoMergeSplit(A, aSplit);
        end;
      end;
    end;
  finally
    aSplit.Free;
  end;
end;

procedure TbdiSplitAndMerge.ProcessFile;
var
  sAdd : string;
  i : Integer;
//  nValMax, nValMin, nGapMax, nGapMin : Real;
  nLValClo, nValOpe, nValClo : Real;
//  nLValOpe, nLValMax, nLValMin : Real;
begin
  FormatSettings.DecimalSeparator := '.';
  if not Assigned(FSymbol) then
    FSymbol := TStringList.Create;
  if not Assigned(FLast) then
    FLast := TStringList.Create;

  FSymbol.Clear;
  FLast.Clear;
  FsSymbol := ChangeFileExt(ExtractFileName(FsFileName), '');
  FLine := TStringList.Create;
  FLast := TStringList.Create;
  try
    FLine.Delimiter := ';';
    FLast.Delimiter := ';';
    FSymbol.LoadFromFile(FsFileName);
    FnBetaMax := FSymbol.Count;
    for i :=  0 to FnBetaMax - 1 do
    begin
      FLine.DelimitedText := Trim(FSymbol[i]);
      nValOpe := StrToFloat(FLine[nOPEN]);
      nValClo := StrToFloat(FLine[nCLOS]);
//      nValMax := StrToFloat(FLine[nPMAX]);
//      nValMin := StrToFloat(FLine[nPMIN]);
      if (FLine[nDATE] <> '') and (FLast.Count > 0)
        and (nValOpe > 0.1) and (nValClo > 0.1) then
      begin
//        nGapMax := nValOpe * 1.8; //80% de GAP
//        nGapMin := nValOpe * 0.6; //40% de GAP
//        nLValOpe := StrToFloat(FLast[nOPEN]);
        nLValClo := StrToFloat(FLast[nCLOS]);
//        nLValMax := StrToFloat(FLast[nPMAX]);
//        nLValMin := StrToFloat(FLast[nPMIN]);
        sAdd := FsSymbol + ':' + FLine[nDATE] +
        ':Close: ' + FloatToStr(nLValClo) +
        ':Open:' + FloatToStr(nValOpe) +
        ':Fator:' + FloatToStr(RoundTo(nLValClo / nValOpe, -2)) +
        ':File:' + FsFileName;
        if (nLValClo / nValOpe <= 0.5) then //Merge
          FSplitMerge.Add('M:' + sAdd)
        else if (nLValClo / nValOpe >= 2) then //Split
          FSplitMerge.Add('S:' + sAdd);
      end;
      FLast.DelimitedText := FLine.DelimitedText;
      Inc(FnBetaPos);
      if Assigned(FOnProgress) then
        FOnProgress(Self);
    end;
  finally
    FLine.Free;
  end;
end;

end.

