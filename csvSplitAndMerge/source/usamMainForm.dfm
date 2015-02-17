object fsamMainForm: TfsamMainForm
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = 'CSV Split & Merge'
  ClientHeight = 370
  ClientWidth = 424
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pbParser: TProgressBar
    Left = 0
    Top = 336
    Width = 424
    Height = 17
    Align = alBottom
    Step = 1
    TabOrder = 0
  end
  object pbTotal: TProgressBar
    Left = 0
    Top = 353
    Width = 424
    Height = 17
    Align = alBottom
    Step = 1
    TabOrder = 1
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 424
    Height = 336
    ActivePage = tsArquivos
    Align = alClient
    TabOrder = 2
    object tsArquivos: TTabSheet
      Caption = 'Arquivos'
      object lbArquivos: TListBox
        Left = 0
        Top = 65
        Width = 416
        Height = 243
        Align = alClient
        ItemHeight = 13
        TabOrder = 0
      end
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 416
        Height = 65
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 1
        DesignSize = (
          416
          65)
        object Label1: TLabel
          Left = 6
          Top = 8
          Width = 44
          Height = 13
          Caption = 'Arquivo :'
        end
        object edFile: TEdit
          Left = 56
          Top = 5
          Width = 354
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 0
          Text = 'Z:\Bin\Win32\Debug\KROT3.csv'
        end
        object btAdicionar: TButton
          Left = 254
          Top = 32
          Width = 75
          Height = 25
          Anchors = [akTop, akRight]
          Caption = 'Adicionar'
          TabOrder = 1
          OnClick = btAdicionarClick
        end
        object btLimpar: TButton
          Left = 4
          Top = 32
          Width = 75
          Height = 25
          Caption = 'Limpar'
          TabOrder = 2
          OnClick = btLimparClick
        end
        object btLocalizar: TButton
          Left = 85
          Top = 32
          Width = 75
          Height = 25
          Anchors = [akLeft, akBottom]
          Caption = 'Localizar'
          TabOrder = 3
          OnClick = btLocalizarClick
        end
        object btAdPasta: TButton
          Left = 335
          Top = 32
          Width = 75
          Height = 25
          Anchors = [akTop, akRight]
          Caption = 'Ad. Pasta'
          TabOrder = 4
          OnClick = btAdPastaClick
        end
      end
    end
    object tsResultado: TTabSheet
      Caption = 'Resultado'
      ImageIndex = 1
      object clbSplitMerge: TCheckListBox
        Left = 0
        Top = 17
        Width = 416
        Height = 266
        Align = alClient
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Lucida Console'
        Font.Style = []
        ItemHeight = 13
        ParentFont = False
        TabOrder = 0
      end
      object ckTodos: TCheckBox
        Left = 0
        Top = 0
        Width = 416
        Height = 17
        Align = alTop
        Caption = 'Selecionar todos'
        TabOrder = 1
        OnClick = ckTodosClick
      end
      object btExecute: TButton
        Left = 0
        Top = 283
        Width = 416
        Height = 25
        Align = alBottom
        Caption = 'Executar altera'#231#245'es'
        TabOrder = 2
        OnClick = btExecuteClick
      end
    end
  end
  object OpenDialog1: TOpenDialog
    Filter = 'Arquivos CSV|*.csv'
    Options = [ofHideReadOnly, ofAllowMultiSelect, ofEnableSizing]
    Left = 160
    Top = 184
  end
end
