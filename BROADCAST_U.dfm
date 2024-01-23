object BROADCAST_F: TBROADCAST_F
  Left = 0
  Top = 0
  BorderStyle = bsSizeToolWin
  Caption = 'HCBU - Broadcast channel'
  ClientHeight = 434
  ClientWidth = 806
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
  object gb_message: TGroupBox
    AlignWithMargins = True
    Left = 247
    Top = 50
    Width = 315
    Height = 207
    Align = alClient
    Caption = 'Broadcast message'
    TabOrder = 0
    ExplicitWidth = 309
    ExplicitHeight = 193
    object sbt_connect: TSpeedButton
      AlignWithMargins = True
      Left = 118
      Top = 44
      Width = 89
      Height = 21
      Caption = 'Connect'
      OnClick = sbt_connectClick
    end
    object bb_send_message: TBitBtn
      Left = 231
      Top = 128
      Width = 65
      Height = 34
      Caption = 'Send'
      TabOrder = 0
      OnClick = bb_send_messageClick
    end
    object e_message: TMemo
      AlignWithMargins = True
      Left = 16
      Top = 104
      Width = 209
      Height = 81
      ScrollBars = ssVertical
      TabOrder = 1
    end
  end
  object gb_aero: TGroupBox
    AlignWithMargins = True
    Left = 3
    Top = 50
    Width = 238
    Height = 207
    Align = alLeft
    Caption = 'Registrations'
    TabOrder = 1
    ExplicitHeight = 193
    object clb_aircraft: TCheckListBox
      AlignWithMargins = True
      Left = 5
      Top = 20
      Width = 228
      Height = 182
      Align = alClient
      ItemHeight = 15
      TabOrder = 0
      ExplicitHeight = 168
    end
  end
  object gb_ack: TGroupBox
    AlignWithMargins = True
    Left = 568
    Top = 50
    Width = 235
    Height = 207
    Align = alRight
    Caption = 'Acknowledge'
    TabOrder = 2
    ExplicitLeft = 562
    ExplicitHeight = 193
    object list_ack: TListView
      AlignWithMargins = True
      Left = 5
      Top = 20
      Width = 225
      Height = 182
      Align = alClient
      Columns = <
        item
          AutoSize = True
          Caption = 'Registrations'
        end
        item
          Alignment = taCenter
          AutoSize = True
          Caption = 'ACK'
        end>
      TabOrder = 0
      ViewStyle = vsReport
      ExplicitHeight = 168
    end
  end
  object qr_history: TGroupBox
    AlignWithMargins = True
    Left = 3
    Top = 263
    Width = 800
    Height = 141
    Align = alBottom
    Caption = 'Message history'
    TabOrder = 3
    ExplicitTop = 249
    ExplicitWidth = 794
    object m_history: TMemo
      AlignWithMargins = True
      Left = 5
      Top = 20
      Width = 790
      Height = 116
      Align = alClient
      ScrollBars = ssVertical
      TabOrder = 0
      ExplicitWidth = 784
    end
  end
  object sb1: TStatusBar
    AlignWithMargins = True
    Left = 3
    Top = 410
    Width = 800
    Height = 21
    Panels = <
      item
        Style = psOwnerDraw
        Text = 'Status connection '
        Width = 50
      end>
    OnDrawPanel = sb1DrawPanel
    ExplicitTop = 396
    ExplicitWidth = 794
  end
  object p_title: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 800
    Height = 41
    Align = alTop
    Caption = 'Broadcast channel'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    TabOrder = 5
    ExplicitWidth = 794
  end
  object q_get_history_message: TFDQuery
    Connection = PRINCIPALE.cn1
    SQL.Strings = (
      'SELECT * '
      'FROM ETL.ETL_MQTT_MESSAGE '
      'WHERE '
      'DAY(DATETIME_MESSAGE) = :DAY'
      'AND MONTH(DATETIME_MESSAGE) = :MONTH'
      'AND YEAR(DATETIME_MESSAGE) = :YEAR'
      'AND MQTT_CHANNEL  = '#39'B'#39
      'ORDER BY DATETIME_MESSAGE;')
    Left = 88
    Top = 320
    ParamData = <
      item
        Name = 'DAY'
        DataType = ftWord
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'MONTH'
        DataType = ftWord
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'YEAR'
        DataType = ftWord
        ParamType = ptInput
        Value = Null
      end>
  end
end
