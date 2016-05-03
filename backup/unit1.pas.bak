unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, LazUtils, LConvEncoding;

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
  f:             text;
  LongString:    widestring;
  records_code:  array of widestring;
  records_group: array of widestring;
  records_descr: array of widestring;
  i:             integer; //array of records size
  serv_i1:       integer;
  serv_i2:       integer;
  f2:            text;
  role:          widestring;
  lang:          widestring;
  HostNameDB:    widestring;
  DBName:        widestring;
  DBUsername:    widestring;
  DBPassword:    widestring;
implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);

begin
  i:=0;
  AssignFile(f,'sample.csv');

  AssignFile(f2,'settings.txt');
  Try
    reset(f2);
    readln(f, role); //now we keep calm and load our role
    role := UTF8BOMToUTF8(role);
    readln(f, lang);
    readln(f, HostNameDB);
    readln(f, DBName);
    readln(f, DBUsername);
    readln(f, DBPassword);
  Except
    //HALT
  end;
  DBConnection.HostName       := HostNameDB;
  DBConnection.DatabaseName   := DBName;
  DBConnection.UserName       := DBUsername;
  DBConnection.Password       := DBPassword;
  SetLength(records_code,  i+1);
  SetLength(records_group, i+1);
  SetLength(records_descr, i+1);
  Try
    // try to open file, read variables and close file
    reset(f);
    While Not EOF(f) Do
      begin
      readln(f,LongString);
      //looking for code
      serv_i1:=Pos(',',LongString);
      serv_i2:=Length(LongString);
      records_code[i]:=Copy(LongString,0,serv_i1);
      LongString:=Copy(LongString,serv_i1+1,serv_i2);
      //looking for group
      serv_i1:=Pos(',',LongString);
      serv_i2:=Length(LongString);
      records_group[i]:=Copy(LongString,0,serv_i1);
      LongString:=Copy(LongString,serv_i1+1,serv_i2);
      //looking for descryption
      serv_i2:=Length(LongString);
      records_descr[i]:=Copy(LongString,0,serv_i2);
      ShowMessage(records_code[i]+records_group[i]+records_descr[i]);
      i:=i+1;
      SetLength(records_code,  i+1);
      SetLength(records_group, i+1);
      SetLength(records_descr, i+1);
      end;
    CloseFile(f);
  Except
    //Halt;
  end;

End;

end.

