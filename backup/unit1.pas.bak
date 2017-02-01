{
 This is free programm under GPLv2 (or later - as option) license.
 Authors: Anton Gladyshev
 version 1.0.0.8, date 2017-01-07
                      (YYYY-MM-DD)
}
unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, IBConnection, sqldb, sqlite3conn, db, FileUtil, Forms,
  Controls, Graphics, Dialogs, StdCtrls, ExtCtrls, ComCtrls, DBGrids, LazUtils,
  LConvEncoding, LCLType, types;


type

  { TForm1 }

  TForm1 = class(TForm)
    btRead: TButton;
    btSearch: TButton;
    btClearDB: TButton;
    btSaveSettings: TButton;
    Button1: TButton;
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    Edit1: TEdit;
    editHeight: TEdit;
    editWidth: TEdit;
    editLang: TEdit;
    editFile: TEdit;
    gbFields: TGroupBox;
    Goodies: TRadioButton;
    labelSymb: TLabel;
    labelStatus: TLabel;
    rbAnywhere: TRadioButton;
    rbSGoodies: TRadioButton;
    gbScreenSize: TGroupBox;
    gbLanguage: TGroupBox;
    Jobs: TRadioButton;
    rbGROUPR: TRadioButton;
    rbSJobs: TRadioButton;
    labelSearchQuery: TLabel;
    labelFilename: TLabel;
    Memo1: TMemo;
    PageControl1: TPageControl;
    rbSAllRecords: TRadioButton;
    rbLangRU: TRadioButton;
    rbLangEN: TRadioButton;
    rbLangKZ: TRadioButton;
    rbLangOther: TRadioButton;
    rbDESCRR: TRadioButton;
    rbSZ5: TRadioButton;
    rbSZ1: TRadioButton;
    rbSZ2: TRadioButton;
    rbSZ3: TRadioButton;
    rbSZ4: TRadioButton;
    gbReadnInsert: TGroupBox;
    gbCategories: TGroupBox;
    Services: TRadioButton;
    rbSServices: TRadioButton;
    DBConnection: TSQLite3Connection;
    tsOptions: TTabSheet;
    tsInsert: TTabSheet;
    tsSearch: TTabSheet;
    SQLQuery1: TSQLQuery;
    SQLTransaction1: TSQLTransaction;
    editSearchQuery: TEdit;
    procedure btClearDBClick(Sender: TObject);
    procedure btReadClick(Sender: TObject);
    procedure btSaveSettingsClick(Sender: TObject);
    procedure btSearchClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure rbLangENChange(Sender: TObject);
    procedure rbLangKZChange(Sender: TObject);
    procedure rbLangOtherChange(Sender: TObject);
    procedure rbLangRUChange(Sender: TObject);
    procedure rbSZ1Change(Sender: TObject);
    procedure rbSZ2Change(Sender: TObject);
    procedure rbSZ3Change(Sender: TObject);
    procedure rbSZ4Change(Sender: TObject);
    procedure rbSZ5Change(Sender: TObject);
    procedure reading();
    procedure inserting();
    procedure FormCreate(Sender: TObject);
    procedure tsInsertContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);

  private
    { private declarations }
  public
    procedure load_translation();
    procedure form_resize();
    procedure save_settings();
    procedure set_visible();
    { public declarations }
  end;

var
  Form1:          TForm1;
  f_code:         text;
  f_groupr:       text;
  f_descrr:       text;
  f_uomr:         text;
  LongString:     widestring;
  records_code:   array of widestring;
  records_groupr: array of ansistring;
  records_descrr: array of ansistring;
  records_uomr:   array of ansistring;
  i:              integer; //array of records size
  cnt:            integer; //counts of translated captions
  serv_i1:        integer;
  serv_i2:        integer;
  f2:             text;//settings are there
  f_lang:         text;//translations are there
  role:           widestring;
  HostNameDB:     widestring;
  DBName:         widestring;
  DBUsername:     widestring;
  DBPassword:     widestring;
  FileForRead:    widestring;
  screen_res:     integer;
  screen_res_width:  integer;
  screen_res_height: integer;
  language_rb:    integer;
  language_str:   widestring;
  lang:           widestring;
  warning:        widestring;
  ins_type:       integer;
  captions_local: array[0..26] of widestring; //total 26+1 lines
  statusvisible:  boolean;
  queryGroup:     widestring;
  queryDescr:     widestring;
implementation

{$R *.lfm}
procedure TForm1.set_visible();
begin
  if statusvisible = True then
    labelStatus.Visible := True;
  if statusvisible = False then
    labelStatus.Visible := False;
end;

procedure TForm1.form_resize();
var
  form_w:         integer;
  form_h:         integer;
  pc_w:           integer;
  pc_h:           integer;
  dbgrid_w:       integer;
  dbgrid_h:       integer;
  dbgrid_group_w: integer;
  dbgrid_descr_w: integer;
begin
  if screen_res = 1 then
  begin
    //1024x768
    //sizes
    form_w          := 1024-20;
    form_h          := 768-40;      //768 - 40=728
    pc_w            := form_w;
    pc_h            := form_h;
    dbgrid_w        := form_w;
    dbgrid_h        := pc_h - 144;  //728 -104=584 //28 rows+1 field name, 29 total
    Showmessage(IntToStr(dbgrid_h));
    //code width 132, grouprr 256, descrr 445, uomr 150 = 983 //1024-40 v.scrollbar
    //dbgrid_descr_w  := 445;
    dbgrid_group_w  := 256;
    dbgrid_descr_w  := form_w - 132 - dbgrid_group_w - 150 - 40;

    //objects
    Form1.Width                      := form_w;
    Form1.Height                     := form_h;
    Form1.PageControl1.Width         := pc_w;
    Form1.PageControl1.Height        := pc_h;
    DBGrid1.Width                    := dbgrid_w;
    DBGrid1.Height                   := dbgrid_h;
    DBGrid1.Columns.Items[1].Width   := dbgrid_group_w;
    DBGrid1.Columns.Items[2].Width   := dbgrid_descr_w;
  end;

  if screen_res = 2 then
  begin
    //1280х800
    //sizes
    form_w          := 1280-20;
    form_h          := 800-40;
    pc_w            := form_w;
    pc_h            := form_h;
    dbgrid_w        := form_w;
    dbgrid_h        := pc_h - 144;  //800-
    //code width 132, grouprr 256, descrr 445, uomr 150 = 983 //1024-40 v.scrollbar
    //dbgrid_descr_w  := 445;
    dbgrid_group_w  := 256;
    dbgrid_descr_w  := form_w - 132 - dbgrid_group_w - 150 - 40;

    //objects
    Form1.Width                      := form_w;
    Form1.Height                     := form_h;
    Form1.PageControl1.Width         := pc_w;
    Form1.PageControl1.Height        := pc_h;
    DBGrid1.Width                    := dbgrid_w;
    DBGrid1.Height                   := dbgrid_h;
    DBGrid1.Columns.Items[1].Width   := dbgrid_group_w;
    DBGrid1.Columns.Items[2].Width   := dbgrid_descr_w;
  end;

  if screen_res = 3 then
  begin
    //1366х768
    //sizes
    form_w          := 1366-20;
    form_h          := 768-40;
    pc_w            := form_w;
    pc_h            := form_h;
    dbgrid_w        := form_w;
    dbgrid_h        := pc_h - 144;  //800-
    //code width 132, grouprr 256, descrr 445, uomr 150 = 983 //1024-40 v.scrollbar
    //dbgrid_descr_w  := 445;
    dbgrid_group_w  := 256;
    dbgrid_descr_w  := form_w - 132 - dbgrid_group_w - 150 - 40;

    //objects
    Form1.Width                      := form_w;
    Form1.Height                     := form_h;
    Form1.PageControl1.Width         := pc_w;
    Form1.PageControl1.Height        := pc_h;
    DBGrid1.Width                    := dbgrid_w;
    DBGrid1.Height                   := dbgrid_h;
    DBGrid1.Columns.Items[1].Width   := dbgrid_group_w;
    DBGrid1.Columns.Items[2].Width   := dbgrid_descr_w;
  end;

  if screen_res = 4 then
  begin
    //1366х768
    //sizes
    form_w          := 1920-20;
    form_h          := 1080-40;
    pc_w            := form_w;
    pc_h            := form_h;
    dbgrid_w        := form_w;
    dbgrid_h        := pc_h - 144;  //800-
    //code width 132, grouprr 256, descrr 445, uomr 150 = 983 //1024-40 v.scrollbar
    //dbgrid_descr_w  := 445;
    dbgrid_group_w  := 256;
    dbgrid_descr_w  := form_w - 132 - dbgrid_group_w - 150 - 40;

    //objects
    Form1.Width                      := form_w;
    Form1.Height                     := form_h;
    Form1.PageControl1.Width         := pc_w;
    Form1.PageControl1.Height        := pc_h;
    DBGrid1.Width                    := dbgrid_w;
    DBGrid1.Height                   := dbgrid_h;
    DBGrid1.Columns.Items[1].Width   := dbgrid_group_w;
    DBGrid1.Columns.Items[2].Width   := dbgrid_descr_w;
  end;

  if screen_res = 5 then
  begin
    //1366х768
    //sizes
    form_w          := screen_res_width -20;
    form_h          := screen_res_height -40;
    pc_w            := form_w;
    pc_h            := form_h;
    dbgrid_w        := form_w;
    dbgrid_h        := pc_h - 144;  //800-
    //code width 132, grouprr 256, descrr 445, uomr 150 = 983 //1024-40 v.scrollbar
    //dbgrid_descr_w  := 445;
    dbgrid_group_w  := 256;
    dbgrid_descr_w  := form_w - 132 - dbgrid_group_w - 150 - 40;

    //objects
    Form1.Width                      := form_w;
    Form1.Height                     := form_h;
    Form1.PageControl1.Width         := pc_w;
    Form1.PageControl1.Height        := pc_h;
    DBGrid1.Width                    := dbgrid_w;
    DBGrid1.Height                   := dbgrid_h;
    DBGrid1.Columns.Items[1].Width   := dbgrid_group_w;
    DBGrid1.Columns.Items[2].Width   := dbgrid_descr_w;
  end;

  Form1.Position:=poScreenCenter;
end;

procedure TForm1.load_translation();
begin
  cnt:=0;

  AssignFile(f_lang, lang+'.txt');
  Try
    reset(f_lang);
    While cnt<29 Do //total lines count(27+1) + 1
    begin
      readln(f_lang,captions_local[cnt]);
      cnt:=cnt+1;
    end;
  Except
    Showmessage('error while reading translation');
  end;
  CloseFile(f_lang);

  Form1.Caption                           :=  captions_local[0];
  Form1.PageControl1.Page[1].caption      :=  captions_local[1];
  Form1.labelFilename.Caption             :=  captions_local[2];
  Form1.Goodies.Caption                   :=  captions_local[3];
  Form1.Jobs.Caption                      :=  captions_local[4];
  Form1.Services.Caption                  :=  captions_local[5];
  Form1.btRead.Caption                    :=  captions_local[6];
  Form1.btClearDB.Caption                 :=  captions_local[7];
  warning                                 :=  captions_local[8];
  Form1.PageControl1.Page[0].Caption      :=  captions_local[9];
  Form1.labelSearchQuery.Caption          :=  captions_local[10];
  Form1.btSearch.Caption                  :=  captions_local[11];
  Form1.labelStatus.Caption               :=  captions_local[12];
  Form1.gbCategories.Caption              :=  captions_local[13];
  Form1.rbSGoodies.Caption                :=  captions_local[3];
  Form1.rbSJobs.Caption                   :=  captions_local[4];
  Form1.rbSServices.Caption               :=  captions_local[5];
  Form1.rbSAllRecords.Caption             :=  captions_local[14];
  Form1.gbFields.Caption                  :=  captions_local[15];
  Form1.rbAnywhere.Caption                :=  captions_local[14];
  Form1.rbGROUPR.Caption                  :=  captions_local[16];
  Form1.rbDESCRR.Caption                  :=  captions_local[17];
  Form1.PageControl1.Page[2].Caption      :=  captions_local[18];
  Form1.gbScreenSize.Caption              :=  captions_local[19];
  Form1.rbSZ5.Caption                     :=  captions_local[20];
  Form1.gbLanguage.Caption                :=  captions_local[21];
  Form1.rbLangRU.Caption                  :=  captions_local[22];
  Form1.rbLangEN.Caption                  :=  captions_local[23];
  Form1.rbLangKZ.Caption                  :=  captions_local[24];
  Form1.rbLangOther.Caption               :=  captions_local[25];
  Form1.btSaveSettings.Caption            :=  captions_local[26];
end;

procedure TForm1.save_settings();
begin
  Try
    rewrite(f2);
    //DB settings
    writeln(f2, role); //now we keep calm and load our role
    //role := UTF8BOMToUTF8(role);
    writeln(f2, HostNameDB);
    writeln(f2, DBName);
    writeln(f2, DBUsername);
    writeln(f2, DBPassword);
    //program options
    writeln(f2, screen_res);
    writeln(f2, screen_res_width);
    writeln(f2, screen_res_height);
    writeln(f2, language_rb);
    writeln(f2, language_str);
  Except
    //HALT
  end;
  CloseFile(f2);
end;

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
  if role = 'admin' then
  begin
    reading();
    inserting();
  end
  else
  begin
    ShowMessage(captions_local[8]);
  end;
end;

procedure TForm1.btClearDBClick(Sender: TObject);
var
  t_caption:  widestring;
  t_question: PChar;
begin
  if role = 'admin' then
  begin
    //t_question:= PWideChar(captions_local[8]);
    //t_caption := captions_local[0];
    //If Application.MessageBox('ыгорка', t_caption, MB_ICONQUESTION + MB_YESNO)=IDYES then
    //begin
        SQLQuery1.SQL.Text := 'DELETE FROM MAIN';
        DBConnection.Connected  := True;
        // IF DataSet is open then transaction should be Commit and started again
        If SQLTransaction1.Active Then SQLTransaction1.Commit;
        SQLTransaction1.StartTransaction;
        Try
          //// try open DataSet
          SQLQuery1.ExecSQL;
        Except
          // somthing goes wrong, get out of here and rollback transaction
          SQLTransaction1.Rollback;
        end;
    //end;
  end
  else
  begin
    ShowMessage(captions_local[8]);
  end;
end;

procedure TForm1.btSaveSettingsClick(Sender: TObject);
begin
  //form resize
  if rbSZ1.Checked = true then
  begin
    screen_res := 1;
  end;
  if rbSZ2.Checked = true then
  begin
    screen_res := 2;
  end;
  if rbSZ3.Checked = true then
  begin
    screen_res := 3;
  end;
  if rbSZ4.Checked = true then
  begin
    screen_res := 4;
  end;
  if rbSZ5.Checked = true then
  begin
    screen_res := 5;
  end;
  screen_res_width  := StrToInt(editWidth.text);
  screen_res_height := StrToInt(editHeight.text);
  form_resize();

  //translations
  if rbLangRU.checked = true then
  begin
    language_rb := 1;
    lang        := 'ru';
  end;
  if rbLangEN.checked = true then
  begin
    language_rb := 2;
    lang        := 'en';
  end;
  if rbLangKZ.checked = true then
  begin
    language_rb := 3;
    lang        := 'kz';
  end;
  if rbLangOther.checked = true then
  begin
    language_rb := 4;
    lang        := editLang.text;
  end;
  language_str  := editLang.text;
  load_translation();

  save_settings();
end;

procedure TForm1.btSearchClick(Sender: TObject);
begin
  If EditSearchQuery.Text <> '' then
  begin


  statusvisible := True;
  set_visible();

  SQLQuery1.Close;
  SQLQuery1.SQL.Clear;

  If rbSGoodies.Checked Then
    ins_type:=0;
  If rbSJobs.Checked Then
    ins_type:=1;
  If rbSServices.Checked Then
    ins_type:=2;
  If rbSAllRecords.Checked Then
    ins_type:=3;

  If rbAnywhere.Checked = True Then
  begin
    queryGroup := ' SELECT * FROM MAIN WHERE GROUPR LIKE '
      +'''%'+editSearchQuery.Text+'%''';
    queryDescr := ' SELECT * FROM MAIN WHERE DESCRR LIKE '
      +'''%'+editSearchQuery.Text+'%''';
    If rbSGoodies.Checked = True Then
    begin
      queryGroup := queryGroup +' AND INS_TYPE = 0';
      queryDescr := queryDescr +' AND INS_TYPE = 0';
    end;
    If rbSJobs.Checked = True Then
    begin
      queryGroup := queryGroup +' AND INS_TYPE = 1';
      queryDescr := queryDescr +' AND INS_TYPE = 1';
    end;
    If rbSServices.Checked = True Then
    begin
      queryGroup := queryGroup +' AND INS_TYPE = 2';
      queryDescr := queryDescr +' AND INS_TYPE = 2';
    end;
    SQLQuery1.SQL.Text :=queryGroup +' UNION ' + queryDescr;
  end;
  If rbGROUPR.Checked = True Then
  begin
    queryGroup  := ' SELECT * FROM MAIN WHERE GROUPR LIKE '
      +'''%'+editSearchQuery.Text+'%''';
    If rbSGoodies.Checked = True Then
    begin
      queryGroup := queryGroup +' AND INS_TYPE = 0';
    end;
    If rbSJobs.Checked = True Then
    begin
      queryGroup := queryGroup +' AND INS_TYPE = 1';
    end;
    If rbSServices.Checked = True Then
    begin
      queryGroup := queryGroup +' AND INS_TYPE = 2';
    end;
    SQLQuery1.SQL.Text := queryGroup;
  end;
  If rbDESCRR.Checked = True Then
  begin
    queryDescr := ' SELECT * FROM MAIN WHERE DESCRR LIKE '
      +'''%'+editSearchQuery.Text+'%''';
    If rbSGoodies.Checked = True Then
    begin
      queryDescr := queryDescr +' AND INS_TYPE = 0';
    end;
    If rbSJobs.Checked = True Then
    begin
      queryDescr := queryDescr +' AND INS_TYPE = 1';
    end;
    If rbSServices.Checked = True Then
    begin
      queryDescr := queryDescr +' AND INS_TYPE = 2';
    end;
    SQLQuery1.SQL.Text := queryDescr;
  end;

   edit1.text:=                   SQLQuery1.SQL.Text;

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

  statusvisible := False;
  set_visible();

  end
  else
  begin
    ShowMessage(captions_local[27]);
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  ShowMessage(DBConnection.Hostname);
  ShowMessage(DBConnection.DatabaseName);
  ShowMessage(DBConnection.Username);
  ShowMessage(DBConnection.Password);
end;

procedure TForm1.rbLangENChange(Sender: TObject);
begin
  if rbLangOther.Checked = False then
  begin
    editLang.Enabled := False;
    lang:='en';
  end;
end;

procedure TForm1.rbLangKZChange(Sender: TObject);
begin
  if rbLangOther.Checked = False then
  begin
    editLang.Enabled := False;
    lang:='kz';
  end;
end;

procedure TForm1.rbLangOtherChange(Sender: TObject);
begin
  if rbLangOther.Checked = True then
  begin
    editLang.Enabled := True;
    lang:=editLang.Text;
  end;
end;

procedure TForm1.rbLangRUChange(Sender: TObject);
begin
  if rbLangOther.Checked = False then
  begin
    editLang.Enabled := False;
    lang:='ru';
  end;
end;

procedure TForm1.rbSZ1Change(Sender: TObject);
begin
  if rbSZ5.Checked = False then
  begin
    editWidth.Enabled  := False;
    editHeight.Enabled := False;
  end;
end;

procedure TForm1.rbSZ2Change(Sender: TObject);
begin
  if rbSZ5.Checked = False then
  begin
    editWidth.Enabled  := False;
    editHeight.Enabled := False;
  end;
end;

procedure TForm1.rbSZ3Change(Sender: TObject);
begin
  if rbSZ5.Checked = False then
  begin
    editWidth.Enabled  := False;
    editHeight.Enabled := False;
  end;
end;

procedure TForm1.rbSZ4Change(Sender: TObject);
begin
  if rbSZ5.Checked = False then
  begin
    editWidth.Enabled  := False;
    editHeight.Enabled := False;
  end;
end;

procedure TForm1.rbSZ5Change(Sender: TObject);
begin
  if rbSZ5.Checked = True then
  begin
    editWidth.Enabled  := True;
    editHeight.Enabled := True;
  end;
end;



procedure TForm1.inserting();
var
  inn: integer;
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
  //read settings
  AssignFile(f2,'settings.txt');
  Try
    reset(f2);
    //DB settings
    readln(f2, role); //now we keep calm and load our role
    //role := UTF8BOMToUTF8(role);
    readln(f2, HostNameDB);
    readln(f2, DBName);
    readln(f2, DBUsername);
    readln(f2, DBPassword);
    //program options
    readln(f2, screen_res);
    readln(f2, screen_res_width);
    readln(f2, screen_res_height);
    readln(f2, language_rb);
    readln(f2, language_str);
  Except
    //HALT
  end;
  CloseFile(f2);

  if role <> 'admin' then
  begin

    PageControl1.Pages[1].TabVisible:=False;
  end;

  DBConnection.HostName       := HostNameDB;
  DBConnection.DatabaseName   := DBName;
  DBConnection.UserName       := DBUsername;
  DBConnection.Password       := DBPassword;

  if screen_res = 1 then
  begin
    rbSZ1.Checked := True;
    rbSZ2.Checked := False;
    rbSZ3.Checked := False;
    rbSZ4.Checked := False;
    rbSZ5.Checked := False;
  end;
  if screen_res = 2 then
  begin
    rbSZ1.Checked := False;
    rbSZ2.Checked := True;
    rbSZ3.Checked := False;
    rbSZ4.Checked := False;
    rbSZ5.Checked := False;
  end;
  if screen_res = 3 then
  begin
    rbSZ1.Checked := False;
    rbSZ2.Checked := False;
    rbSZ3.Checked := True;
    rbSZ4.Checked := False;
    rbSZ5.Checked := False;
  end;
  if screen_res = 4 then
  begin
    rbSZ1.Checked := False;
    rbSZ2.Checked := False;
    rbSZ3.Checked := False;
    rbSZ4.Checked := True;
    rbSZ5.Checked := False;
  end;
  if screen_res = 5 then
  begin
    rbSZ1.Checked := False;
    rbSZ2.Checked := False;
    rbSZ3.Checked := False;
    rbSZ4.Checked := False;
    rbSZ5.Checked := True;
    editWidth.Enabled  := True;
    editHeight.Enabled := True;
  end;

  editWidth.Text   := IntToStr(screen_res_width);
  editHeight.Text  := IntToStr(screen_res_height);

  if language_rb = 1 then
  begin
    rbLangRU.Checked    := True;
    rbLangEN.Checked    := False;
    rbLangKZ.Checked    := False;
    rbLangOther.Checked := False;
    lang:='ru';
  end;
  if language_rb = 2 then
  begin
    rbLangRU.Checked    := False;
    rbLangEN.Checked    := True;
    rbLangKZ.Checked    := False;
    rbLangOther.Checked := False;
    lang:='en';
  end;
  if language_rb = 3 then
  begin
    rbLangRU.Checked    := False;
    rbLangEN.Checked    := False;
    rbLangKZ.Checked    := True;
    rbLangOther.Checked := False;
    lang:='kz';
  end;
  if language_rb = 4 then
  begin
    rbLangRU.Checked    := False;
    rbLangEN.Checked    := False;
    rbLangKZ.Checked    := False;
    rbLangOther.Checked := True;
    lang:=language_str;
  end;
  editLang.Text := language_str;

  //debug
  //ShowMessage(IntToStr(language_rb));
  //ShowMessage(lang);

  load_translation();
  form_resize();
End;

procedure TForm1.tsInsertContextPopup(Sender: TObject; MousePos: TPoint;
  var Handled: Boolean);
begin

end;

end.

