object LOGIN_F: TLOGIN_F
  Left = 0
  Top = 0
  Caption = 'HCBU - Login Form'
  ClientHeight = 282
  ClientWidth = 594
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Position = poScreenCenter
  OnShow = FormShow
  TextHeight = 13
  object Label1: TLabel
    Left = 0
    Top = 269
    Width = 594
    Height = 13
    Align = alBottom
    Caption = 'HyperConnected Base Unit   by Intuos Srl - Italy'
    Color = 8454143
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    Transparent = False
    ExplicitWidth = 231
  end
  object euser: TLabeledEdit
    Left = 129
    Top = 30
    Width = 264
    Height = 24
    EditLabel.Width = 26
    EditLabel.Height = 13
    EditLabel.Caption = 'User:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    Text = ''
    OnChange = euserChange
  end
  object epassword: TLabeledEdit
    Left = 129
    Top = 86
    Width = 264
    Height = 24
    EditLabel.Width = 50
    EditLabel.Height = 13
    EditLabel.Caption = 'Password:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    PasswordChar = #9632
    TabOrder = 1
    Text = ''
    OnKeyPress = epasswordKeyPress
  end
  object btnlogin: TBitBtn
    Left = 129
    Top = 134
    Width = 112
    Height = 33
    Caption = '&Login'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    OnClick = btnloginClick
  end
  object btncancel: TBitBtn
    Left = 273
    Top = 134
    Width = 120
    Height = 33
    Caption = '&Cancel'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ModalResult = 8
    ParentFont = False
    TabOrder = 3
    OnClick = btncancelClick
  end
  object emg: TLabeledEdit
    Left = 296
    Top = 242
    Width = 290
    Height = 21
    Alignment = taRightJustify
    EditLabel.Width = 46
    EditLabel.Height = 13
    EditLabel.Caption = 'Device ID'
    TabOrder = 4
    Text = ''
    Visible = False
  end
  object cn_test: TFDConnection
    Params.Strings = (
      'ConnectionDef=MGR')
    LoginPrompt = False
    Left = 448
    Top = 152
  end
end
