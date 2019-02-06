{
  A basic thread based timer component. Can be used in GUI and non-GUI apps.
  Author:  Graeme Geldenhuys
}
unit ThreadTimer;

{$mode objfpc}{$H+}

interface

uses
  Classes;

type
  TFPTimer = class; // forward declaration


  TFPTimerThread = class(TThread)
  private
    FTimer: TFPTimer;
  protected
    procedure   DoExecute;
    procedure   Execute; override;
  public
    constructor CreateTimerThread(Timer: TFPTimer);
  end;


  TFPTimer = class(TComponent)
  private
    FInterval: Integer;
    FPriority: TThreadPriority;
    FOnTimer: TNotifyEvent;
    FContinue: Boolean;
    FRunning: Boolean;
    FEnabled: Boolean;
    procedure   SetEnabled(Value: Boolean );
  protected
    procedure   StartTimer;
    procedure   StopTimer;
    property    Continue: Boolean read FContinue write FContinue;
  public
    constructor Create(AOwner: TComponent); override;
    procedure   On;
    procedure   Off;
  published
    property    Enabled: Boolean read FEnabled write SetEnabled;
    property    Interval: Integer read FInterval write FInterval;
    property    ThreadPriority: TThreadPriority read FPriority write FPriority default tpNormal;
    property    OnTimer: TNotifyEvent read FOnTimer write FOnTimer;
  end;


implementation

uses
  SysUtils;
  
{ No need to pull in the Windows unit. Also this works on all platforms. }
function _GetTickCount: Cardinal;
begin
  Result := Cardinal(Trunc(Now * 24 * 60 * 60 * 1000));
end;


{ TFPTimerThread }

constructor TFPTimerThread.CreateTimerThread(Timer: TFPTimer);
begin
  inherited Create(True);
  FTimer := Timer;
  FreeOnTerminate := True;
end;

procedure TFPTimerThread.Execute;
var
  SleepTime: Integer;
  Last: Cardinal;
begin
  while FTimer.Continue do
  begin
    Last := _GetTickCount;
    Synchronize(@DoExecute);
    SleepTime := FTimer.FInterval - (_GetTickCount - Last);
    if SleepTime < 10 then
      SleepTime := 10;
    Sleep(SleepTime);
  end;
end;

procedure TFPTimerThread.DoExecute;
begin
  if Assigned(FTimer.OnTimer) then FTimer.OnTimer(FTimer);
end;


{ TFPTimer }

constructor TFPTimer.Create(AOwner: TComponent);
begin
  inherited;
  FPriority := tpNormal;
end;

procedure TFPTimer.SetEnabled(Value: Boolean);
begin
  if Value <> FEnabled then
  begin
    FEnabled := Value;
    if FEnabled then
      StartTimer
    else
      StopTimer;
  end;
end;

procedure TFPTimer.StartTimer;
begin
  if FRunning then
    Exit; //==>
  FContinue := True;
  if not (csDesigning in ComponentState) then
  begin
    with TFPTimerThread.CreateTimerThread(Self) do
    begin
      Priority := FPriority;
      Resume;
    end;
  end;
  FRunning := True;
end;

procedure TFPTimer.StopTimer;
begin
  FContinue := False;
  FRunning  := False;
end;

procedure TFPTimer.On;
begin
  StartTimer;
end;

procedure TFPTimer.Off;
begin
  StopTimer;
end;

end.

