// this example shows how to incorporate WinGraph in a Delphi application
program palettes;

uses
  Forms,
  mainform in 'mainform.pas' {DelphiForm},
  maincode in 'maincode.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Palettes Example';
  Application.CreateForm(TDelphiForm, DelphiForm);
  Application.Run;
end.
