unit unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  CapArray;

type
  TForm1 = class(TForm)
    mArray: TMemo;
    bLargeArrayAddTo: TButton;
    bSlower: TButton;
    procedure bLargeArrayAddToClick(Sender: TObject);
    procedure bSlowerClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

type
  TByteArr = array of byte;

var
  Form1: TForm1;

implementation

{$R *.dfm}

const
  MAX = 1000000; // change to lower if out of memory

procedure TForm1.bLargeArrayAddToClick(Sender: TObject);
var
  SomeData: array of byte;
  i: integer;
  CapArr: TCapArray;
  s: ansistring;
begin
  s := '';
  setlength(SomeData, 10);
  SomeData[0] := byte('t');
  SomeData[1] := byte('e');
  SomeData[2] := byte('s');
  SomeData[3] := byte('t');
  SomeData[4] := byte('i');
  SomeData[5] := byte('n');
  SomeData[6] := byte('g');
  SomeData[7] := byte('1');
  SomeData[8] := byte('2');
  SomeData[9] := byte('3');

  ResetBuf(@CapArr);
  for i := 1 to MAX do begin
    AddArray(SomeData, @CapArr);
  end;
  EndUpdate(@CapArr);

 s := CapArrayToAnsistring(@CapArr);
// mArray.Lines.Add(s);
  mArray.Lines.Add('Done fast method');
end;

procedure AddDataToArray(data: array of byte; var dest: TByteArr);
var
  i: integer;
  olddestlen, datalen: integer;
begin
  datalen := length(data);
  olddestlen := length(dest);
  for i := 0 to datalen do begin
    setlength(dest, length(dest)+datalen);
    move(data[0], dest[olddestlen], datalen);
  end;
end;

procedure TForm1.bSlowerClick(Sender: TObject);
var
  SomeData: array of byte;
  i: integer;
  s: string;
  LargeArray: TByteArr;
begin
  s := '';
  setlength(SomeData, 10);
  SomeData[0] := byte('t');
  SomeData[1] := byte('e');
  SomeData[2] := byte('s');
  SomeData[3] := byte('t');
  SomeData[4] := byte('i');
  SomeData[5] := byte('n');
  SomeData[6] := byte('g');
  SomeData[7] := byte('1');
  SomeData[8] := byte('2');
  SomeData[9] := byte('3');

  for i := 1 to MAX do begin
    AddDataToArray(SomeData, LargeArray);
  end;

  mArray.Lines.Add('Done slow method');
end;

end.
