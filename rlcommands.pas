unit commands;

{$mode objfpc}

interface

uses
  regexpr,
  SysUtils,
  TypInfo,
  rlmap,
  rlplayer;

type
  TCommand = class
  private
    _map: TMap;
    _help: string;
  public
    constructor Create(amap: TMap; ahelp: string);
    property help: string read _help;
    procedure Execute(acommand: string); virtual; abstract;
  end;

  TMoveCommand = class(Tcommand)
  public
    procedure Execute(acommand: string); override;
  end;

  TAttackCommand = class(TCommand)
  public
    procedure Execute(acommand: string); override;
  end;

implementation

constructor TCommand.Create(amap: TMap; ahelp: string);
  begin
    _map := amap;
    _help := ahelp;
  end;

procedure TMoveCommand.Execute(acommand: string);
  (* Erfasst eingaben wie: "gehe/laufe/... nach <richtung>" *)
  var
    re: tregexpr;
    room_change: boolean;
  begin
    re := tregexpr.Create('(?i)(?:gehe|laufe) nach (norden|sueden|osten|westen)');
    re.Exec(acommand);
    room_change := _map.move_player(lowercase(re.match[1]));
    if room_change then
      writeln(_map.current_room.description);
    writeln(format('You are on field (y=%d, x=%d)',
      [_map.current_field_idx div 3, _map.current_field_idx mod 3]));
    writeln(_map.current_field.description);
    if _map.current_field.content<>nil then
      _map.current_field.content.print_description;
  end;

procedure TAttackCommand.Execute(acommand: string);
  begin
    if typinfo.getpropinfo(_map.current_field.content, 'health') = nil then
    begin
      writeln('There is no enemy to attack you silly.');
      exit();
    end;
    writeln('attacking...');
    (*
    player.attack(enemy);
     enemy.attack(player);
     ClrScr;
     writeln('Dein Leben ['+inttostr(Player.health)+' LP]');
     writeln('Das Leben des Gegners ['+inttostr(TEnemy.health)+' LP]')
    *)
    //_map.player.attack(_map.current_field.content);
  end;

end.
