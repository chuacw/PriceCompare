unit DebugUtils.Log;

interface

{$IF DEFINED(ANDROID)}
type
  android_LogPriority = (
    ANDROID_LOG_UNKNOWN,
    ANDROID_LOG_DEFAULT,
    ANDROID_LOG_VERBOSE,
    ANDROID_LOG_DEBUG,
    ANDROID_LOG_INFO,
    ANDROID_LOG_WARN,
    ANDROID_LOG_ERROR,
    ANDROID_LOG_FATAL,
    ANDROID_LOG_SILENT
 );
{$ELSEIF DEFINED(MSWINDOWS) OR DEFINED(LINUX)}
type
  TLogPriority = (
    UNKNOWN,
    DEFAULT,
    VERBOSE,
    DEBUG,
    INFO,
    WARN,
    ERROR,
    FATAL,
    SILENT
 );
{$ENDIF}

function LOGE(const Msg: MarshaledAString): Integer;
function LOGW(const Msg: string): Integer;
function LOGI(const Msg: MarshaledAString): Integer;
function LOGV(const Msg: string): Integer;

{$IF DEFINED(ANDROID)}
const
  DefaultDelphiTag: MarshaledAString = 'DELPHI';

function Log(const Msg: MarshaledAString; const Tag: MarshaledAString; Priority: android_LogPriority = ANDROID_LOG_DEBUG): Integer;
{$ELSE}
function Log(const Msg: string; const Tag: string = 'DELPHI'; Priority: TLogPriority = TLogPriority.DEBUG): Integer;
{$ENDIF}

implementation
uses
{$IF DEFINED(MSWINDOWS)}
  Winapi.Windows,
{$ENDIF}
  System.SysUtils;

const
  DefaultTag: string = 'DELPHI';

{$IF DEFINED(ANDROID)}
function __android_log_print(Priority: android_LogPriority; const Tag, Text: MarshaledAString): Integer; cdecl;
 external 'liblog.so' name '__android_log_print';
{$ENDIF}

function LOGE(const Msg: MarshaledAString): Integer;
var
  LTag: MarshaledAString;
begin
{$IF DEFINED(ANDROID)}
  LTag := 'DELPHI';
  Result := Log(Msg, LTag, ANDROID_LOG_ERROR);
{$ELSE}
  Result := Log(string(Msg), DefaultTag, TLogPriority.ERROR);
{$ENDIF}
end;

function LOGW(const Msg: string): Integer;
begin
{$IF DEFINED(ANDROID)}
  Result := Log(MarshaledAString(UTF8String(Msg)),
    MarshaledAString(UTF8String(DefaultTag)), ANDROID_LOG_WARN);
{$ELSE}
  Result := Log(Msg, DefaultTag, TLogPriority.WARN);
{$ENDIF}
end;

function LOGI(const Msg: MarshaledAString): Integer;
var
  LTag: MarshaledAString;
begin
{$IF DEFINED(ANDROID)}
  LTag := 'DELPHI';
  Result := Log(Msg,
    LTag, ANDROID_LOG_INFO);
{$ELSE}
  Result := Log(string(Msg), DefaultTag, TLogPriority.INFO);
{$ENDIF}
end;

function LOGV(const Msg: string): Integer;
begin
{$IF DEFINED(ANDROID)}
  Result := Log(MarshaledAString(UTF8String(Msg)),
    MarshaledAString(UTF8String(DefaultTag)), ANDROID_LOG_VERBOSE);
{$ELSE}
  Result := Log(Msg, DefaultTag, TLogPriority.VERBOSE);
{$ENDIF}
end;

{$IF DEFINED(ANDROID)}
function Log(const Msg: MarshaledAString; const Tag: MarshaledAString; Priority: android_LogPriority = ANDROID_LOG_DEBUG): Integer;
{$ELSE}
function Log(const Msg: string; const Tag: string = 'DELPHI'; Priority: TLogPriority = TLogPriority.DEBUG): Integer;
{$WRITEABLECONST ON}
const
  FEventLog: THandle = 0;
{$ENDIF}
var
  LTag, LMsg: MarshaledAString;
begin
  {$IF DEFINED(ANDROID)}
    LTag := Tag;
    LMsg := Msg;
    Result := __android_log_print(Priority, LTag, LMsg);
  {$ELSE}
    Result := Log(Msg, DefaultTag, TLogPriority.VERBOSE);
  {$ENDIF}
end;

//{$IF DEFINED(ANDROID)}
//initialization
//  LOGI('Delphi unit DebugUtils.Log initialization');
//{$ENDIF}

end.
