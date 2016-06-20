{
 This is free programm under GPLv2 (or later - as option) license.
 Authors: Anton Gladyshev
 version 1.0.0.2 date 2016-06-17
                     (YYYY-MM-DD)
}
unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, IBConnection, sqldb, db, FileUtil, Forms, Controls,
  Graphics, Dialogs, StdCtrls, ExtCtrls, ComCtrls, DBGrids, LazUtils,
  LConvEncoding;


type

  { TForm1 }

  TForm1 = class(TForm)
    btRead: TButton;
    btSearch: TButton;
    Button1: TButton;
    DataSource1: TDataSource;

    DBConnection: TIBConnection;
    DBGrid1: TDBGrid;
    Edit1: TEdit;
    editFile: TEdit;
    Goodies: TRadioButton;
    Goodies1: TRadioButton;
    Jobs: TRadioButton;
    Jobs1: TRadioButton;
    labelSearchQuery: TLabel;
    labelFilename: TLabel;
    Memo1: TMemo;
    PageControl1: TPageControl;
    AllRecords1: TRadioButton;
    ReadnInsert: TGroupBox;
    gbSearch: TGroupBox;
    Services: TRadioButton;
    Services1: TRadioButton;
    tsOptions: TTabSheet;
    tsInsert: TTabSheet;
    tsSearch: TTabSheet;
    SQLQuery1: TSQLQuery;
    SQLTransaction1: TSQLTransaction;
    editSearchQuery: TEdit;
    procedure btReadClick(Sender: TObject);
    procedure btSearchClick(Sender: TObject);


    procedure reading();
    procedure inserting();
    procedure FormCreate(Sender: TObject);

  private
    { private declarations }
  public

    { public declarations }
  end;

var
  Form1: TForm1;
//  f:             text;
  f_code:        text;
  f_groupr:      text;
  f_descrr:      text;
  f_uomr:        text;
  LongString:    widestring;
  records_code:  array of widestring;
  records_groupr:array of ansistring;
  records_descrr:array of ansistring;
  records_uomr:  array of ansistring;
  i:             integer; //array of records size
  serv_i1:       integer;
  serv_i2:       integer;
  f2:            text;//settings are there
 // f3:            text;
  role:          widestring;
  lang:          widestring;
  HostNameDB:    widestring;
  DBName:        widestring;
  DBUsername:    widestring;
  DBPassword:    widestring;
  FileForRead:   widestring;
  ins_type:      integer;
implementation

{$R *.lfm}
procedure TForm1.reading();
begin
  FileForRead := editFile.Text;
  AssignFile(f_code,   FileForRead+'-1-code.txt');
  AssignFile(f_groupr, FileForRead+'-2-groupr.txt');
  AssignFile(f_descrr, FileForRead+'-3-descrr.txt');
  AssignFile(f_uomr,   FileForRead+'-4-uomr.txt');
//AssignFile(f_type,   FileForRead+'-5-type.txt');

  i:=0;
  SetLength(records_code,   i+1);
  SetLength(records_groupr, i+1);
  SetLength(records_descrr, i+1);
  SetLength(records_uomr,   i+1);

  i:=0;
  Try
    // try to open file, read variables and close file
    reset(f_code);
    While Not EOF(f_code) Do
      begin
      readln(f_code,LongString);
      records_code[i]:=LongString;
      i:=i+1;
      SetLength(records_code,   i+1);
      end;
    CloseFile(f_code);
  Except
    //Halt;
  end;
  //ShowMessage(IntToStr(i)+' codes');

  i:=0;
  Try
    // try to open file, read variables and close file
    reset(f_groupr);
    While Not EOF(f_groupr) Do
      begin
      readln(f_groupr,LongString);
      records_groupr[i]:=LongString;
      i:=i+1;
      SetLength(records_groupr,   i+1);
      end;
    CloseFile(f_groupr);
  Except
    //Halt;
  end;
  //ShowMessage(IntToStr(i)+' groupr');

  i:=0;
  Try
    // try to open file, read variables and close file
    reset(f_descrr);
    While Not EOF(f_descrr) Do
      begin
      readln(f_descrr,LongString);
      records_descrr[i]:=LongString;
      i:=i+1;
      SetLength(records_descrr,   i+1);
      end;
    CloseFile(f_descrr);
  Except
    //Halt;
  end;
  //ShowMessage(IntToStr(i)+' descrr');

  i:=0;
  Try
    // try to open file, read variables and close file
    reset(f_uomr);
    While Not EOF(f_uomr) Do
      begin
      readln(f_uomr,LongString);
      records_uomr[i]:=LongString;
      i:=i+1;
      SetLength(records_uomr,   i+1);
      end;
    CloseFile(f_uomr);
  Except
    //Halt;
  end;
  //ShowMessage(IntToStr(i)+' uomr');
  ShowMessage('reading success!');
  //ShowMessage(records_code[8]+records_groupr[8]+records_descrr[8]+records_uomr[8]);
end;

procedure TForm1.btReadClick(Sender: TObject);
begin
  reading();
  inserting();
end;

procedure TForm1.btSearchClick(Sender: TObject);
begin
  SQLQuery1.Close;
  SQLQuery1.SQL.Clear;

  If Goodies1.Checked Then
    ins_type:=0;
  If Jobs1.Checked Then
    ins_type:=1;
  If Services1.Checked Then
    ins_type:=2;
  If AllRecords1.Checked Then
    ins_type:=3;

  SQLQuery1.SQL.Text := ' SELECT * FROM MAIN WHERE GROUPR LIKE '
    +'''%'+editSearchQuery.Text+'%'''+' UNION ' +
    ' SELECT * FROM MAIN WHERE DESCRR LIKE '
    +'''%'+editSearchQuery.Text+'%''';
  edit1.text:=                   SQLQuery1.SQL.Text;
  //ShowMessage(SQLQuery1.SQL.Text);
    DBConnection.Connected  := True;
    // IF DataSet is open then transaction should be Commit and started again
    If SQLTransaction1.Active Then SQLTransaction1.Commit;
    SQLTransaction1.StartTransaction;
    Try
      //// try open DataSet
      SQLQuery1.Open;
    Except
      // somthing goes wrong, get out of here and rollback transaction
      SQLTransaction1.Rollback;
    end;
end;



procedure TForm1.inserting();
var
  inn: integer;
  txtt: widestring;
begin
  SQLQuery1.Close;
  SQLQuery1.SQL.Clear;
  //SQLQuery1.SQL.Text := 'execute block as begin ';
  //SQLQuery1.SQL.Text := SQLQuery1.SQL.Text + ' end';

  If Goodies.Checked Then
    ins_type:=0;
  If Jobs.Checked Then
    ins_type:=1;
  If Services.Checked Then
    ins_type:=2;

  inn:=0;
  for inn:=0 to i-1 do
  begin
    SQLQuery1.SQL.Text := ' INSERT INTO MAIN (CODE,GROUPR,DESCRR,UOMR,INS_TYPE) VALUES ('
   // +IntToStr(inn)+','
    +''''+records_code[inn]+''''+','
    +''''+records_groupr[inn]+''''+','
    +''''+records_descrr[inn]+''''+','
    +''''+records_uomr[inn]+''''+','
    +IntToStr(ins_type)+');';

    DBConnection.Connected  := True;
    // IF DataSet is open then transaction should be Commit and started again
    If SQLTransaction1.Active Then SQLTransaction1.Commit;
    SQLTransaction1.StartTransaction;
    Try
      //// try open DataSet
      SQLQuery1.ExecSQL;
      SQLTransaction1.Commit;
    Except
      // somthing goes wrong, get out of here and rollback transaction
      SQLTransaction1.Rollback;
      Memo1.Text:= Memo1.Text + ' error on record of ' + IntToStr(inn);
      //ShowMessage('error on record of '+IntToStr(inn));
    end;
  end;
  ShowMessage('writing to DB success!');
end;

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
  AssignFile(f2,'settings.txt');
  Try
    reset(f2);
    readln(f2, role); //now we keep calm and load our role
    role := UTF8BOMToUTF8(role);
    readln(f2, lang);
    readln(f2, HostNameDB);
    readln(f2, DBName);
    readln(f2, DBUsername);
    readln(f2, DBPassword);
  Except
    //HALT
  end;
  DBConnection.HostName       := HostNameDB;
  DBConnection.DatabaseName   := DBName;
  DBConnection.UserName       := DBUsername;
  DBConnection.Password       := DBPassword;

End;

end.

