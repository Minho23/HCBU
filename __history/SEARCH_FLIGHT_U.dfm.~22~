object SEARCH_FLIGHT_F: TSEARCH_FLIGHT_F
  Left = 0
  Top = 0
  BorderStyle = bsSizeToolWin
  Caption = 'HCBU - Search by flight'
  ClientHeight = 455
  ClientWidth = 630
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
    Width = 624
    Height = 41
    Align = alTop
    Caption = 'Search by flight'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    ExplicitWidth = 618
  end
  object grb_date: TGroupBox
    AlignWithMargins = True
    Left = 3
    Top = 50
    Width = 624
    Height = 128
    Align = alTop
    Caption = 'Select Flight Date'
    TabOrder = 1
    ExplicitLeft = -2
    object l_aero: TLabel
      AlignWithMargins = True
      Left = 144
      Top = 52
      Width = 62
      Height = 25
      Caption = 'Aircraft'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
    end
    object dp1: TDatePicker
      AlignWithMargins = True
      Left = 260
      Top = 52
      Date = 45308.000000000000000000
      DateFormat = 'dd/mm/yyyy'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = []
      TabOrder = 0
    end
    object bt_search: TBitBtn
      AlignWithMargins = True
      Left = 500
      Top = 84
      Width = 97
      Height = 33
      Caption = 'Search'
      TabOrder = 1
      OnClick = bt_searchClick
    end
  end
  object grb_list: TGroupBox
    AlignWithMargins = True
    Left = 3
    Top = 184
    Width = 624
    Height = 268
    Align = alClient
    Caption = 'Flights List'
    TabOrder = 2
    ExplicitWidth = 618
    ExplicitHeight = 254
    object rDBGrid1: TrDBGrid
      AlignWithMargins = True
      Left = 5
      Top = 20
      Width = 614
      Height = 243
      Align = alClient
      DataSource = ds_flight
      Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -12
      TitleFont.Name = 'Segoe UI'
      TitleFont.Style = []
      OnDblClick = rDBGrid1DblClick
      OptionsEx2.Appearance.SkipCellHighlight = True
      OptionsEx2.Appearance.DrawColoredRow = True
      ColorOddRow = 15658734
      ColorActiveRow = 8454143
      ColumnWidth = cwAutoWidth
      Columns = <
        item
          Expanded = False
          FieldName = 'min_datetime'
          Title.Alignment = taCenter
          Title.Caption = 'TAKEOFF'
          Width = 289
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'max_datetime'
          Title.Alignment = taCenter
          Title.Caption = 'LANDING'
          Width = 289
          Visible = True
        end>
    end
  end
  object q_get_flight: TFDQuery
    Connection = PRINCIPALE.cn1
    SQL.Strings = (
      'SELECT'
      '    MIN(DATETIME_MESSAGE) AS min_datetime,'
      '    MAX(DATETIME_MESSAGE) AS max_datetime'
      'FROM ('
      '    SELECT'
      '        DATETIME_MESSAGE,'
      '        DATA_FLIGHT,'
      
        '        (ROW_NUMBER() OVER (PARTITION BY DATA_FLIGHT ORDER BY DA' +
        'TETIME_MESSAGE DESC)) AS ORD_PARTITION,'
      
        '        (ROW_NUMBER() OVER (ORDER BY DATETIME_MESSAGE DESC)) AS ' +
        'ORD_TOT,    '
      
        '        (ROW_NUMBER() OVER (PARTITION BY DATA_FLIGHT ORDER BY DA' +
        'TETIME_MESSAGE DESC)) -'
      
        '        (ROW_NUMBER() OVER (ORDER BY DATETIME_MESSAGE DESC)) AS ' +
        'diff'
      '    FROM'
      '        ETL.ETL_MQTT_MESSAGE'
      '    WHERE'
      '        MARCHE = :MARCA_P'
      ''
      '    AND DAY(DATETIME_MESSAGE) = :DAY_P'
      '    AND MONTH(DATETIME_MESSAGE) = :MONTH_P'
      '    AND YEAR(DATETIME_MESSAGE) = :YEAR_P'
      ''
      ') AS RESULT'
      'WHERE DATA_FLIGHT = 1'
      'GROUP BY diff'
      'ORDER BY min_datetime DESC;')
    Left = 123
    Top = 282
    ParamData = <
      item
        Name = 'MARCA_P'
        DataType = ftString
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'DAY_P'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'MONTH_P'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'YEAR_P'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
  end
  object ds_flight: TDataSource
    DataSet = q_get_flight
    Left = 64
    Top = 272
  end
end
