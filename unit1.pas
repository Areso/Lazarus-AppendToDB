unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs;

type

  { TForm1 }

  TForm1 = class(TForm)
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
var
  f: text;
  LongString:    widestring;
  records_code:  array of widestring;
  records_group: array of widestring;
  records_descr: array of widestring;
  i:             integer; //array of records size
  serv_i1:       integer;
  serv_i2:       integer;
begin
  i:=0;
  AssignFile(f,'sample.csv');
  SetLength(records_code,  i+1);
  SetLength(records_group, i+1);
  SetLength(records_descr, i+1);
  Try
    // try to open file, read variables and close file
    reset(f);
    While Not EOF(f) Do
      begin
      readln(f,LongString);
      //ShowMessage(LongString);
      i:=i+1;
      serv_i1:=Pos(',',LongString);
      serv_i2:=Length(LongString);
      records_code[0]:=Copy(LongString,0,serv_i1);
      LongString:=Copy(LongString,serv_i1,serv_i2);

      SetLength(records_code,  i+1);
      SetLength(records_group, i+1);
      SetLength(records_descr, i+1);
      ShowMessage(IntToStr(serv_i1)+records_code[0]);
      end;
    CloseFile(f);
  Except
    //Halt;
  end;
End;

end.

