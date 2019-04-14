object DelphiForm: TDelphiForm
  Left = 240
  Top = 45
  Width = 394
  Height = 305
  Caption = 'Palettes Example'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnDestroy = Button2Click
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 369
    Height = 137
    Caption = 'WinGraph settings'
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    TabOrder = 0
    object Label1: TLabel
      Left = 8
      Top = 24
      Width = 87
      Height = 13
      Caption = 'Graphics driver'
    end
    object Label2: TLabel
      Left = 112
      Top = 24
      Width = 85
      Height = 13
      Caption = 'Graphics mode'
    end
    object Label3: TLabel
      Left = 248
      Top = 24
      Width = 72
      Height = 13
      Caption = 'Palette used'
    end
    object Label5: TLabel
      Left = 88
      Top = 80
      Width = 180
      Height = 13
      Caption = 'Custom width      Custom heigth'
    end
    object ComboBox1: TComboBox
      Left = 8
      Top = 48
      Width = 81
      Height = 21
      Color = clBlack
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ItemHeight = 13
      ItemIndex = 0
      ParentFont = False
      TabOrder = 0
      Text = 'Detect'
      OnChange = ComboBox1Change
      Items.Strings = (
        'Detect'
        'D1bit'
        'D4bit'
        'D8bit'
        'NoPalette')
    end
    object ComboBox2: TComboBox
      Left = 104
      Top = 48
      Width = 97
      Height = 21
      Color = clBlack
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ItemHeight = 13
      ItemIndex = 3
      ParentFont = False
      TabOrder = 1
      Text = 'm640x480'
      OnChange = ComboBox2Change
      Items.Strings = (
        'm320x200'
        'm640x200'
        'm640x350'
        'm640x480'
        'm720x350'
        'm800x600'
        'm1024x768'
        'm1280x1024'
        'mDefault'
        'mMaximized'
        'mFullScr'
        'mCustom')
    end
    object ComboBox3: TComboBox
      Left = 216
      Top = 48
      Width = 137
      Height = 21
      Color = clBlack
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ItemHeight = 13
      ItemIndex = 0
      ParentFont = False
      TabOrder = 2
      Text = 'DefaultPalette'
      Items.Strings = (
        'DefaultPalette'
        'NamesPalette'
        'SystemPalette'
        'MonoPalette (user)')
    end
    object SpinEdit1: TSpinEdit
      Left = 96
      Top = 104
      Width = 57
      Height = 22
      Color = clBlack
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      Increment = 10
      MaxLength = 4
      MaxValue = 0
      MinValue = 0
      ParentFont = False
      TabOrder = 3
      Value = 100
    end
    object SpinEdit2: TSpinEdit
      Left = 200
      Top = 104
      Width = 57
      Height = 22
      Color = clBlack
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      Increment = 10
      MaxLength = 4
      MaxValue = 0
      MinValue = 0
      ParentFont = False
      TabOrder = 4
      Value = 100
    end
  end
  object Button1: TButton
    Left = 8
    Top = 152
    Width = 89
    Height = 25
    Caption = 'Start WinGraph'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 8
    Top = 184
    Width = 89
    Height = 25
    Caption = 'Stop WinGraph'
    Enabled = False
    TabOrder = 2
    OnClick = Button2Click
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 216
    Width = 369
    Height = 57
    Caption = 'WinGraph error'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 3
    object Label4: TLabel
      Left = 24
      Top = 24
      Width = 321
      Height = 17
      AutoSize = False
      Caption = ' '
      Color = clBlack
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clYellow
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentColor = False
      ParentFont = False
    end
  end
  object Button3: TButton
    Left = 304
    Top = 152
    Width = 75
    Height = 25
    Caption = 'Help'
    TabOrder = 4
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 304
    Top = 184
    Width = 75
    Height = 25
    Caption = 'Close'
    TabOrder = 5
    OnClick = Button4Click
  end
end
