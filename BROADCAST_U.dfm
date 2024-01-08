object BROADCAST_F: TBROADCAST_F
  Left = 0
  Top = 0
  BorderStyle = bsSizeToolWin
  Caption = 'Broadcast channel'
  ClientHeight = 400
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
    Height = 247
    Align = alClient
    Caption = 'Broadcast message'
    TabOrder = 0
    ExplicitWidth = 221
    ExplicitHeight = 296
    DesignSize = (
      227
      247)
    object e_message: TEdit
      Left = 16
      Top = 72
      Width = 182
      Height = 30
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 0
    end
    object bb_send_message: TBitBtn
      Left = 45
      Top = 160
      Width = 123
      Height = 33
      Caption = 'Send'
      TabOrder = 1
      OnClick = bb_send_messageClick
    end
  end
  object gb_aero: TGroupBox
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 294
    Height = 247
    Align = alLeft
    Caption = 'Registrations'
    TabOrder = 1
    ExplicitHeight = 296
    object clb_aircraft: TCheckListBox
      AlignWithMargins = True
      Left = 5
      Top = 20
      Width = 284
      Height = 222
      Align = alClient
      AllowGrayed = True
      ItemHeight = 15
      TabOrder = 0
      ExplicitLeft = 3
      ExplicitTop = 22
      ExplicitHeight = 285
    end
  end
  object gb_ack: TGroupBox
    AlignWithMargins = True
    Left = 536
    Top = 3
    Width = 249
    Height = 247
    Align = alRight
    Caption = 'Acknowledge'
    TabOrder = 2
    ExplicitLeft = 530
    ExplicitHeight = 296
    object list_ack: TListView
      AlignWithMargins = True
      Left = 5
      Top = 20
      Width = 239
      Height = 222
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
      ExplicitHeight = 271
    end
  end
  object qr_history: TGroupBox
    AlignWithMargins = True
    Left = 3
    Top = 256
    Width = 782
    Height = 141
    Align = alBottom
    Caption = 'Message history'
    TabOrder = 3
    object m_history: TMemo
      AlignWithMargins = True
      Left = 5
      Top = 20
      Width = 772
      Height = 116
      Align = alClient
      TabOrder = 0
      ExplicitLeft = 240
      ExplicitTop = 80
      ExplicitWidth = 185
      ExplicitHeight = 89
    end
  end
  object q_read_aero: TFDQuery
    Connection = PRINCIPALE.cn1
    SQL.Strings = (
      'SELECT MARCHE'
      'FROM ANA.ANAAERO')
    Left = 16
    Top = 32
  end
  object q_get_history_message: TFDQuery
    Connection = PRINCIPALE.cn1
    SQL.Strings = (
      'SELECT * '
      'FROM ETL.ETL_MQTT_MESSAGE '
      'WHERE DAY(DATETIME_MESSAGE) = :DAY'
      'AND MONTH(DATETIME_MESSAGE) = :MONTH'
      'AND YEAR(DATETIME_MESSAGE) = :YEAR'
      'AND MQTT_CHANNEL  = '#39'B'#39
      'ORDER BY DATETIME_MESSAGE DESC;')
    Left = 88
    Top = 288
    ParamData = <
      item
        Name = 'DAY'
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'MONTH'
        ParamType = ptInput
      end
      item
        Name = 'YEAR'
        ParamType = ptInput
      end>
  end
end
