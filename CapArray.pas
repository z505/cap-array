{ An array with capacity, grows in chunks. Like CapString. Much more efficient
  than regular dynamic arrays for large adds.

  To change to an array other than array of "byte" just copy this unit into
  another file and change byte to the other type.

  Copyright 2020 Lars Olson
  http://z505.com
}

unit CapArray; {$IFDEF fpc} {$MODE objfpc} {$H+} {$ENDIF}

interface

uses
  SysUtils, Dialogs;  // DEBUG

type
  PCapArray = ^TCapArray;
  TCapArray = record
    ArrayLen: integer; // array length, not actual setlengthed buffer size
    GrowBy: integer;   // grow the array in chunks of what size
    Data: array of byte;  // array data
  end;

procedure ResetBuf(buf: PCapArray); overload;
procedure ResetBuf(buf: PCapArray; GrowBy: integer); overload;
procedure AddByte(b: byte; buf: PCapArray);
procedure AddArray(const a: array of byte; buf: PCapArray);
procedure EndUpdate(buf: PCapArray);
procedure Delete(buf: PCapArray; startat: integer; count: integer);
function CapArrayToAnsistring(buf: PCapArray): ansistring;

{
function EndsChar(b: byte; buf: PCapArray): boolean;
function EndsArray(a: array of byte; buf: PCapArray): boolean;
}

const
  DEFAULT_CHUNK_SIZE = 1024;

implementation


//*done checks whether ends with specified byte (in string area, not in extra buffer zone)
function EndsByte(b: byte; buf: PCapArray): boolean;
begin
  result:= false;
  if buf^.arraylen < 1 then exit;
  if buf^.data[buf^.ArrayLen-1] = b then result:= true;
end;

//*done checks whether ends with specified array (in bytes area, not in extra buffer zone)
function EndsArray(a: array of byte; buf: PCapArray): boolean;
var
  StartAt: integer;
  slen: integer;
  cnt: integer;
  i: integer;
begin
  result:= false;
  if buf^.arraylen < 1 then exit;
  slen:= length(a);
  if slen < 1 then exit;
  // get end piece of capstring to analyze
  StartAt:= (buf^.ArrayLen - slen) + 1; // i.e. find "ing" in "testing".. ing is at position 5   7-3 = 4 + 1 = 5
  cnt:= 0;
  result:= true; // string matches unless found otherwise in char by char check
  for i:= StartAt to buf^.ArrayLen do
  begin
    inc(cnt);
    if buf^.data[i-1] <> a[cnt-1] then result:= false;
  end;
end;

{*done }
procedure Delete(buf: PCapArray; StartAt: integer; count: integer);
begin
  if buf^.arraylen < 1 then exit;
  // if buf^.data = '' then exit;
  system.delete(buf^.data, startat, count);
  buf^.ArrayLen:= buf^.ArrayLen - count;
end;

{*done call this to reset the data structure to zero and the default growby value }
procedure ResetBuf(buf: PCapArray);
begin
  // buf^.Data:= '';
  buf^.ArrayLen:= 0;
  buf^.GrowBy:= DEFAULT_CHUNK_SIZE;
end;

{*done same as above but with custom growby }
procedure ResetBuf(buf: PCapArray; GrowBy: integer);
begin
  // buf^.data:= '';
  buf^.ArrayLen:= 0;
  if buf^.GrowBy < 1 then
    buf^.GrowBy := DEFAULT_CHUNK_SIZE
  else
    buf^.GrowBy := GrowBy;
end;

{*done private function, grows in chunks automatically only when absolutely needs
  to }
procedure Grow(buf: PCapArray; AddLen: integer);
var
  growmult: integer;
begin
  if addlen <= buf^.GrowBy then // only grow one chunk if there is room for data incoming
    setlength(buf^.Data, length(buf^.Data) + buf^.growby)
  else
  begin // must grow in more than one chunk since data is too large to fit
    growmult:= (addlen div buf^.GrowBy) + 1;   // div discards the remainder so we must add 1 to make room for that extra remainder
    setlength(buf^.data, length(buf^.Data) + growmult);
  end;
end;

{ add single byte to caparray }
procedure AddByte(b: byte; buf: PCapArray);
var
  newlen: integer;
const
  clen = 1;
begin
  newlen:= buf^.ArrayLen + clen;
  if newlen > length(buf^.Data) then Grow(buf, clen);
  buf^.Data[newlen]:= b; // concat
  buf^.ArrayLen:= newlen; // string length stored, but not actual buffer length
end;

{*done add existing string to capstring }
procedure AddArray(const a: array of byte; buf: PCapArray);
var
  newlen: integer;
  slen: integer;
  oldlen: integer;
begin
  slen:= length(a);
  if slen = 0 then exit; // do nothing
  oldlen:= length(buf^.Data);
  newlen:= buf^.ArrayLen + slen;
  if newlen > oldlen then Grow(buf, slen);
  //  debugln('debug: wslen: ' + inttostr(wslen) );
{  for i:= 1 to slen do
    buf^.data[(buf^.strlen + i)]:= s[i]; }

  Move(a[0], buf^.Data[buf^.ArrayLen], slen * SizeOf(a[0]));

  buf^.ArrayLen:= newlen; // string length stored, but not actual buffer length
end;

{*done endupdate MUST be called after doing your work with the string, this
  sets the string to the correct length (trims extra buffer spacing at end) }
procedure EndUpdate(buf: PCapArray);
begin
  if buf^.ArrayLen < 1 then exit;
  // if buf^.Data = '' then exit;
  SetLength(buf^.Data, buf^.ArrayLen);
end;

function CapArrayToAnsistring(buf: PCapArray): ansistring;
var
  len: integer;
begin
  result := '';
  len := buf^.ArrayLen;
  setlength(result, len);
  // showmessage('Array Length: '+inttostr(buf^.ArrayLen));
  Move(buf^.Data[0], result[1], len);
end;

end.
