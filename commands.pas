unit commands;

{$mode objfpc}

interface

uses
  regexpr,
  sysutils,
  rlmap;

type
  TCommand = class
  private
    _map: TMap;
  public
    constructor Create(amap: TMap);
    procedure Execute(acommand: string); virtual; abstract;
  end;

  TMoveCommand = class(Tcommand)
  public
    procedure Execute(acommand: string); override;
  end;

implementation

constructor TCommand.Create(amap: TMap);
  begin
    _map := amap;
  end;

procedure TMoveCommand.Execute(acommand: string);
    (* Erfasst eingaben wie: "gehe/laufe/... nach <richtung>" *)
(*    dir := splitstring(eingabe)[2];
    room_change := amap.move_player(player);
    if room_change then
      write(amap.current_room.description);
    else
      write(amap.current_field.description);
    end;
  end;
*)

  var
    re: tregexpr;
    room_change: boolean;
  begin
    re := tregexpr.Create('(?i)gehe nach (norden|sueden|osten|westen)');
    re.Exec(acommand);
    room_change := _map.move_player(lowercase(re.match[1]));
    if room_change then
      writeln(_map.current_room.description);
    writeln(_map.current_field.description);
  end;

end.
