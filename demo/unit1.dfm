object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 283
  ClientWidth = 506
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 120
  TextHeight = 16
  object mArray: TMemo
    Left = 4
    Top = 12
    Width = 481
    Height = 149
    Lines.Strings = (
      'Array Memo:')
    TabOrder = 0
  end
  object bLargeArrayAddTo: TButton
    Left = 308
    Top = 250
    Width = 171
    Height = 25
    Caption = 'Fast Large Array'
    TabOrder = 1
    OnClick = bLargeArrayAddToClick
  end
  object bSlower: TButton
    Left = 46
    Top = 250
    Width = 217
    Height = 25
    Caption = 'Compare to Regular Slower Method'
    TabOrder = 2
    OnClick = bSlowerClick
  end
end
