unit ubovConstants;

interface

type
  TOperacoesBancoEnum = (obTruncarTabela, obManterHistorico, obNaoSeAplica);

const

{Nomes para arquivos}
  sSQL_LOG_EXECUCAO    = '-Log-Execucao.log';

  nCDINDICE_TODOS   = 0;
  TIPO_DIA          = 'DIA';
  TIPO_SEMANA       = 'SEM';
  TIPO_MES          = 'MES';
  TIPO_INTERNET     = 'NET';
  iMME04 = 4;
  iMME05 = 5;
  iMME09 = 9;
  iMME12 = 12;
  iMM13 = 13;
  iMME18 = 18;
  iMME21 = 21;
  iMME26 = 26;
  iMME36 = 36;
  iMME49 = 49;
  MME_VOLMME_RAP    = 3; //Rápido
  MME_VOLMME_LEN    = 9; //Lento
  MME_MACDSinal     = 9;
  MME_MACDHist      = 3;
  MME_ADX_PER       = 14;
  MME_ADX_MME       = 14;
  MME_OBV           = 13;
  MME_AcumDistr     = 13;
  MME_BearBull      = 3;
  MME_ForceIndex    = 13;
  MMA_Stoc_PER      = 14;
  MMA_Stoc_MA       = 3;
  MMA_Stoc2_PER      = 2;
  MMA_Stoc2_MA       = 3;
  DIR_TEND_ALTA     = 'C';
  DIR_TEND_BAIXA    = 'B';
  DIR_TEND_INDEF    = 'I';
  MMA_RSI_02        = 2;
  MMA_RSI_14        = 14;
  iMMA_HILO_ACTV     = 6;

  sBOV_DOWN_YEAR  = 'cotahist_a%s.zip';
  sBOV_DOWN_MONTH = 'cotahist_m%s.zip';
  sBOV_DOWN_DAY = 'cotahist_d%s.zip';
  sBOV_DOWN_URL   = 'http://www.bmfbovespa.com.br/instdados/serhist/';
  sBOV_HISTORICO  = sBOV_DOWN_URL + sBOV_DOWN_YEAR;

//  YAHOO_URL = 'http://br.rd.yahoo.com/finance/quotes/internal/summary/download/*http://br.finance.yahoo.com/d/quotes.csv?s=%s.SA&f=sl1d1t1c1ohgv&e=.csv';
  YAHOO_URL = 'http://download.finance.yahoo.com/d/quotes.csv?s=%s.SA&f=sl1d1t1c1ohgv&e=.csv';
  YAHOO_URL_QUOTES_HISTORICAL_FROM = 'http://ichart.yahoo.com/table.csv?s=%s&a=%s&b=%s&c=%s';
  TPATU_INTERNET = 'I';
  TPATU_YAHOO = 'Y';
  TPATU_BOVESPA  = 'B';
  TPATU_REALTIME  = 'R';
  TPATU_CALCULADO = 'C';
  TPATU_METASTOCK = 'M';

//Situações dos desdobramento
  sSPLIT_NEED_UPDATE = 'N'; //Update
  sSPLIT_UPDATED = 'D'; //Done
  sSPLIT_CALCULADO = 'C'; //Calculado, não precisa mais pegar
  sSPLIT_PROCESSAR = 'P'; //Precisa ser verificado

//Seções de configação
  sAJUSTE_DIAS = 'AjustaDiasFaltantes';
  sBVMF_DOWNLOAD = 'BVMFDownload';
  sDATAWORK_CONFIG = 'DataWork-Config';
  sDATAWORK_THREAD = 'DataWork-Thread';
  sDEFINE_PERIODOS = 'DefinePeriodos';
  sDESDOBRAMENTOS = 'Desdobramentos';
  sIMPORTFROMACESS = 'ImportFromAcess';
  sEXCLUI_ANTIGOS = 'ExcluiAntigos';
  sGEN_INIDICADORES = 'GenIndicadores';
  sYAHOO_DOWNLOAD = 'YahooDwn';
  sREALTIME_DOWNLOAD = 'RealTimeDown';
  sEXEC_RIGHTTOLEFT = 'ExecRightToLeft';
  sRIGHTTOLEFT = 'RightToLeft';
  sALARME_IFR = 'Alarme-IFR';

implementation

end.

