unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, FileCtrl, Buttons, ExtCtrls, ExtDlgs,shellapi;

type
  TForm1 = class(TForm)
    LabeledEdit1: TLabeledEdit;
    LabeledEdit2: TLabeledEdit;
    ok_bt: TBitBtn;
    Button1: TButton;
    Button2: TButton;
    DirectoryListBox1: TDirectoryListBox;
    OpenTextFileDialog1: TOpenTextFileDialog;
    BitBtn1: TBitBtn;
    procedure BitBtn1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ok_btClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure DirectoryListBox1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;  sf:string;

implementation

{$R *.dfm}

procedure TForm1.BitBtn1Click(Sender: TObject);
begin
ShellExecute(handle, 'explorer', pchar(GetCurrentDir+'\dist\'), nil, nil, SW_SHOWNORMAL);
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  if button1.Caption='->'
    then
      begin
        form1.Width:=553;
        button1.Caption:='<-';
        ok_bt.Enabled:=false;
      end
    else
      begin
        LabeledEdit1.Text:=DirectoryListBox1.Directory;
          if FileExists(DirectoryListBox1.Directory+'\python.exe') and FileExists(DirectoryListBox1.Directory+'\Lib\site-packages\py2exe\py2exe_util.pyd') then
            begin
              form1.Width:=342;
              button1.Caption:='->';
              ok_bt.Enabled:=true;
            end else begin
              MessageBox(Handle,'This folder dosn''t consist Python 2.6,'+#13+' or you dosn''t install Py2Exe component', 'Python or py2exe not here!', MB_ICONERROR+MB_OK);
            end;
    end;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
if OpenTextFileDialog1.Execute then
begin
LabeledEdit2.Text:=OpenTextFileDialog1.FileName;
sf:=OpenTextFileDialog1.Files[0];
end;
end;

procedure TForm1.DirectoryListBox1Click(Sender: TObject);
begin
LabeledEdit1.Text:=DirectoryListBox1.Directory;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
DeleteFile(GetEnvironmentVariable('homedrive')+'\setup.py');
DeleteFile('Compile.bat');
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
form1.width:=342;
end;

procedure TForm1.ok_btClick(Sender: TObject);
{var se, sc:textfile;}
var f:textfile; fs:string;
begin

if FileExists(LabeledEdit2.Text) then begin

if FileExists(GetEnvironmentVariable('homedrive')+'\setup.py') then
DeleteFile(GetEnvironmentVariable('homedrive')+'\setup.py');

AssignFile(f,GetEnvironmentVariable('homedrive')+'\setup.py');
rewrite(f);
writeln(f,'from distutils.core import setup'+#13+
'import py2exe'+#13+
#13+
'setup(console=['''+LabeledEdit2.Text+'''])');
closefile(f);



if FileExists('Compile.bat') then
DeleteFile('Compile.bat');

AssignFile(f,'Compile.bat');
rewrite(f);
writeln(f,LabeledEdit1.Text+'\python '+
GetEnvironmentVariable('homedrive')+
'\setup.py py2exe');
writeln(f,'del Compile.bat');
closefile(f);


winexec('Compile.bat',SW_NORMAL);
Application.MessageBox(pchar('Compiled FILE placed in folder:'+#13+GetCurrentDir+'\dist\'),'Log');
end else
  MessageBox(Handle,'Couldn''t find your source *.PY file.'+#13+'Recheck path to it.', 'Target PY not found!', MB_ICONEXCLAMATION+MB_OK);
end;

end.
