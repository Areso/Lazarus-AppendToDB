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
  LongString: widestring;
  records:array of widestring;
begin
  AssignFile(f,'sample.csv');
  SetLength(records, 3000000);
  Try
    // try to open file, read variables and close file
    reset(f);
    readln(LongString);
    CloseFile(f);
  Except
    //Halt;
  end;
End;

end.

