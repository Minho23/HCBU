object ANAAERO_F: TANAAERO_F
  Left = 0
  Top = 0
  Caption = 'HCBU - Aircraft manager'
  ClientHeight = 444
  ClientWidth = 907
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnClose = FormClose
  OnShow = FormShow
  TextHeight = 15
  object p_title: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 901
    Height = 41
    Align = alTop
    Caption = 'Aircraft manager'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    ExplicitWidth = 899
  end
  object grb_aircraft: TGroupBox
    AlignWithMargins = True
    Left = 3
    Top = 50
    Width = 457
    Height = 391
    Align = alLeft
    Caption = 'Aircraft list'
    TabOrder = 1
    ExplicitHeight = 387
    object rDBGrid1: TrDBGrid
      AlignWithMargins = True
      Left = 5
      Top = 20
      Width = 447
      Height = 366
      Align = alClient
      DataSource = ds_aero
      Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
      PopupMenu = PopupMenu1
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -12
      TitleFont.Name = 'Segoe UI'
      TitleFont.Style = []
      OnDblClick = rDBGrid1DblClick
      OptionsEx2.Appearance.SkipCellHighlight = True
      ColumnWidth = cwAutoWidth
      Columns = <
        item
          Expanded = False
          FieldName = 'MARCHE'
          Title.Caption = 'Registration'
          Width = 205
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'DESCRIZIONE'
          Title.Caption = 'Description'
          Width = 205
          Visible = True
        end>
    end
  end
  object grb_aircraft_details: TGroupBox
    AlignWithMargins = True
    Left = 466
    Top = 50
    Width = 438
    Height = 391
    Align = alClient
    Caption = 'Aircraft details'
    TabOrder = 2
    ExplicitWidth = 436
    ExplicitHeight = 387
    object l_reg: TLabel
      Left = 120
      Top = 68
      Width = 73
      Height = 17
      Caption = 'Registration'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI Semibold'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object l_description: TLabel
      Left = 120
      Top = 140
      Width = 72
      Height = 17
      Caption = 'Description '
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI Semibold'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object bb_save: TBitBtn
      Left = 304
      Top = 279
      Width = 75
      Height = 25
      Caption = 'Save'
      TabOrder = 0
      OnClick = bb_saveClick
    end
    object e_reg: TEdit
      Left = 114
      Top = 89
      Width = 183
      Height = 23
      TabOrder = 1
    end
    object e_desc: TEdit
      Left = 114
      Top = 161
      Width = 185
      Height = 23
      TabOrder = 2
    end
    object bb_update: TBitBtn
      Left = 56
      Top = 279
      Width = 75
      Height = 25
      Caption = 'Update'
      TabOrder = 3
      OnClick = bb_updateClick
    end
  end
  object ds_aero: TDataSource
    DataSet = PRINCIPALE.q_aero_only_hcbu
    Left = 155
    Top = 146
  end
  object q_insert_aero: TFDQuery
    Connection = PRINCIPALE.cn1
    SQL.Strings = (
      'INSERT'
      'INTO ETL.ANAAERO'
      'VALUES'
      '(:MARCHE,:DESCRIZIONE)')
    Left = 59
    Top = 234
    ParamData = <
      item
        Name = 'MARCHE'
        ParamType = ptInput
      end
      item
        Name = 'DESCRIZIONE'
        ParamType = ptInput
      end>
  end
  object q_update_aero: TFDQuery
    Connection = PRINCIPALE.cn1
    SQL.Strings = (
      'UPDATE ETL.ANAAERO'
      'SET DESCRIZIONE = :DESCRIZIONE'
      'WHERE MARCHE = :MARCHE')
    Left = 139
    Top = 234
    ParamData = <
      item
        Name = 'DESCRIZIONE'
        ParamType = ptInput
      end
      item
        Name = 'MARCHE'
        ParamType = ptInput
      end>
  end
  object PopupMenu1: TPopupMenu
    Left = 227
    Top = 146
    object q_del: TMenuItem
      Caption = 'Delete'
      OnClick = q_delClick
    end
  end
  object q_delete_aero: TFDQuery
    Connection = PRINCIPALE.cn1
    SQL.Strings = (
      'DELETE'
      'FROM ETL.ANAAERO'
      'WHERE MARCHE = :MARCHE')
    Left = 227
    Top = 234
    ParamData = <
      item
        Name = 'MARCHE'
        ParamType = ptInput
      end>
  end
end
