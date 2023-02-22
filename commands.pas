unit commands;

{$mode objfpc}

interface

uses
  regexpr,
  rlmap;

type
  TCommand = class
  private
    _map: TMap;
  public
    constructor Create(amap: TMap);
    procedure Execute(command: string); virtual; abstract;
  end;

  TMoveCommand = class(Tcommand)
  public
    procedure Execute(command: string); override;
  end;

implementation

constructor TCommand.Create(amap: TMap);
  begin
    _map := amap;
  end;

procedure TMoveCommand.Execute(command: string);
  var
    re: tregexpr;
  begin
    re := tregexpr.Create('(?i)gehe nach (norden|sueden|osten|westen)');
    re.Exec(command);
    if re.match[1] <> '' then
      writeln('move player to '+re.match[1])
    else
      writeln('direction not possible');
  end;

end.
