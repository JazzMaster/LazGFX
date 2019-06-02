// main form code; it does not manage directly WinGraph routines
unit mainform;

interface

uses
   Windows, Classes, Controls, Forms, StdCtrls, maincode, Spin;

type
  TDelphiForm = class(TForm)
    GroupBox1: TGroupBox;
    Button1: TButton;
    Button2: TButton;
    GroupBox2: TGroupBox;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    ComboBox3: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Button3: TButton;
    Button4: TButton;
    Label5: TLabel;
    SpinEdit1: TSpinEdit;
    SpinEdit2: TSpinEdit;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DelphiForm: TDelphiForm;

implementation

{$R *.dfm}

procedure UpdateDelphiForm(mess:string);
begin
  with DelphiForm do if Visible then 
  begin
    Label4.Caption:=mess;
    Button1.Enabled:=true; Button2.Enabled:=false;
  end;
end;

procedure TDelphiForm.Button1Click(Sender: TObject);
begin
  Button1.Enabled:=false; Button2.Enabled:=true;
  GraphThread:=TGraphThread.Create(ComboBox1.ItemIndex,ComboBox2.ItemIndex,
               ComboBox3.ItemIndex,SpinEdit1.Value,SpinEdit2.Value);
  with GraphThread do
  begin
    SignalMain:=@UpdateDelphiForm;
    Resume;
  end;
end;

procedure TDelphiForm.Button2Click(Sender: TObject);
begin
  with GraphThread do if Assigned(GraphThread) then
  begin
    Terminate;
    WaitFor;
  end;
end;

procedure TDelphiForm.ComboBox1Change(Sender: TObject);
begin
  if (ComboBox1.ItemIndex = 0) then
  begin
    ComboBox2.Enabled:=false;
    if (ComboBox2.ItemIndex = 11) then begin
                                         SpinEdit1.Enabled:=false;
                                         SpinEdit2.Enabled:=false;
                                       end;
  end                          else
  begin
    ComboBox2.Enabled:=true;
    if (ComboBox2.ItemIndex = 11) then begin
                                         SpinEdit1.Enabled:=true;
                                         SpinEdit2.Enabled:=true;
                                       end;
  end;
  if (ComboBox1.ItemIndex = 0) or (ComboBox1.ItemIndex = 4) then
    ComboBox3.Enabled:=false else ComboBox3.Enabled:=true;
end;

procedure TDelphiForm.ComboBox2Change(Sender: TObject);
begin
  if (ComboBox2.ItemIndex = 11) then
  begin
    SpinEdit1.Enabled:=true; SpinEdit2.Enabled:=true;
  end                           else
  begin
    SpinEdit1.Enabled:=false; SpinEdit2.Enabled:=false;
  end;
end;

procedure TDelphiForm.Button4Click(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TDelphiForm.Button3Click(Sender: TObject);
const mes: pchar = 'The canvas of the WinGraph window is yours now.'+#10#13+
                   'Remember yourself some old BP7 graph routines'+#10#13+
                   'and bring back onto your computer the old glory'+#10#13+
                   'of DOS graphics programming. But not only...';
begin
  Application.MessageBox(mes,'Help',MB_OK);
end;

end.
