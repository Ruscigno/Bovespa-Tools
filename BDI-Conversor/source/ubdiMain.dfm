object fbdiMain: TfbdiMain
  Left = 578
  Top = 423
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'DBI Conversor'
  ClientHeight = 369
  ClientWidth = 340
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  DesignSize = (
    340
    369)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 6
    Top = 8
    Width = 42
    Height = 13
    Caption = 'Arquivo :'
  end
  object edFile: TEdit
    Left = 54
    Top = 6
    Width = 277
    Height = 21
    TabOrder = 0
    Text = 'Z:\Bin\Win32\Debug\cotahist_a2010.txt'
  end
  object btParser: TButton
    Left = 8
    Top = 304
    Width = 75
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'Parser'
    TabOrder = 1
    OnClick = btParserClick
  end
  object pbParser: TProgressBar
    Left = 0
    Top = 335
    Width = 340
    Height = 17
    Align = alBottom
    Step = 1
    TabOrder = 2
  end
  object lbArquivos: TListBox
    Left = 8
    Top = 63
    Width = 323
    Height = 233
    ItemHeight = 13
    Items.Strings = (
      'Z:\Bin\Win32\Debug\cotahist_a2010.txt'
      'Z:\Bin\Win32\Debug\cotahist_a2011.txt'
      'Z:\Bin\Win32\Debug\cotahist_a2012.txt'
      'Z:\Bin\Win32\Debug\cotahist_a2013.txt'
      'Z:\Bin\Win32\Debug\cotahist_a2014.txt'
      'Z:\Bin\Win32\Debug\cotahist_a2015.txt')
    TabOrder = 3
  end
  object btAdicionar: TButton
    Left = 256
    Top = 32
    Width = 75
    Height = 25
    Caption = 'Adicionar'
    TabOrder = 4
    OnClick = btAdicionarClick
  end
  object btLimpar: TButton
    Left = 4
    Top = 32
    Width = 75
    Height = 25
    Caption = 'Limpar'
    TabOrder = 5
    OnClick = btLimparClick
  end
  object pbTotal: TProgressBar
    Left = 0
    Top = 352
    Width = 340
    Height = 17
    Align = alBottom
    Step = 1
    TabOrder = 6
  end
  object Button1: TButton
    Left = 224
    Top = 304
    Width = 108
    Height = 25
    Caption = 'Apagar inv'#225'lidas'
    TabOrder = 7
    OnClick = Button1Click
  end
  object OpenDialog1: TOpenDialog
    Filter = 'CSV Files|*.csv'
    Options = [ofHideReadOnly, ofAllowMultiSelect, ofEnableSizing]
    Left = 160
    Top = 184
  end
end
