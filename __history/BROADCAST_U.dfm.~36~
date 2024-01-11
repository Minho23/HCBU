object BROADCAST_F: TBROADCAST_F
  Left = 0
  Top = 0
  BorderStyle = bsSizeToolWin
  Caption = 'Broadcast channel'
  ClientHeight = 405
  ClientWidth = 788
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poDesktopCenter
  OnShow = FormShow
  TextHeight = 15
  object gb_message: TGroupBox
    AlignWithMargins = True
    Left = 303
    Top = 3
    Width = 227
    Height = 225
    Align = alClient
    Caption = 'Broadcast message'
    TabOrder = 0
    ExplicitWidth = 221
    ExplicitHeight = 211
    object sbt_connect: TSpeedButton
      AlignWithMargins = True
      Left = 62
      Top = 28
      Width = 89
      Height = 21
      Caption = 'Connect'
      OnClick = sbt_connectClick
    end
    object bb_send_message: TBitBtn
      Left = 45
      Top = 168
      Width = 123
      Height = 33
      Caption = 'Send'
      TabOrder = 0
      OnClick = bb_send_messageClick
    end
    object e_message: TMemo
      AlignWithMargins = True
      Left = 34
      Top = 98
      Width = 145
      Height = 64
      ScrollBars = ssVertical
      TabOrder = 1
    end
  end
  object gb_aero: TGroupBox
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 294
    Height = 225
    Align = alLeft
    Caption = 'Registrations'
    TabOrder = 1
    ExplicitHeight = 211
    object clb_aircraft: TCheckListBox
      AlignWithMargins = True
      Left = 5
      Top = 20
      Width = 284
      Height = 200
      Align = alClient
      ItemHeight = 15
      TabOrder = 0
      ExplicitLeft = 3
      ExplicitTop = 22
    end
  end
  object gb_ack: TGroupBox
    AlignWithMargins = True
    Left = 536
    Top = 3
    Width = 249
    Height = 225
    Align = alRight
    Caption = 'Acknowledge'
    TabOrder = 2
    ExplicitLeft = 530
    ExplicitHeight = 211
    object list_ack: TListView
      AlignWithMargins = True
      Left = 5
      Top = 20
      Width = 239
      Height = 200
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
      ExplicitHeight = 186
    end
  end
  object qr_history: TGroupBox
    AlignWithMargins = True
    Left = 3
    Top = 234
    Width = 782
    Height = 141
    Align = alBottom
    Caption = 'Message history'
    TabOrder = 3
    ExplicitTop = 220
    ExplicitWidth = 776
    object m_history: TMemo
      AlignWithMargins = True
      Left = 5
      Top = 20
      Width = 772
      Height = 116
      Align = alClient
      ScrollBars = ssVertical
      TabOrder = 0
      ExplicitWidth = 766
    end
  end
  object sb1: TStatusBar
    AlignWithMargins = True
    Left = 3
    Top = 381
    Width = 782
    Height = 21
    Panels = <
      item
        Style = psOwnerDraw
        Text = 'Status connection '
        Width = 50
      end>
    OnDrawPanel = sb1DrawPanel
    ExplicitTop = 367
    ExplicitWidth = 776
  end
  object q_get_aero_with_bb: TFDQuery
    Connection = PRINCIPALE.cn1
    SQL.Strings = (
      'SELECT MARCHE'
      'FROM ANA.ANAAERO'
      'WHERE EXISTS ('
      '    SELECT 1'
      '    FROM ETL.ETL_MQTT_MESSAGE'
      '    WHERE ETL.ETL_MQTT_MESSAGE.MARCHE = ANA.ANAAERO.MARCHE'
      ');')
    Left = 40
    Top = 32
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
    Left = 640
    Top = 256
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
