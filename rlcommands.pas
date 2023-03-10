(*
  A unit responsible for defining all possible commands
  the player can execute.
*)
unit rlcommands;

{$mode objfpc}

interface

uses
  regexpr,
  SysUtils,
  TypInfo,
  rlmap,
  rlplayer;

type
  (*
    The base class for all commands. Defines some helpful functionality
    and the interface all commands must follow.

    @member(Create Base constructor for a command.
      @param(amap The current map instance, used to gather all informations in one place.)
      @param(ahelp The help string that gets printed when running @code(help).)
      @returns(A new instance of @classname.)
    )
    @member help Read-only string-property that contains the help message.
    @member(Execute Procedure that executes the logic for the command.
      @param(acommand The command the user entered.
        Needed for specificating the command further.)
    )

    @warning(This is an "abstract" class and shouldn't be used directly,
      but instead through one of its subclasses)
  *)
  TCommand = class
  private
    _map: TMap;
    _help: string;
  public
    constructor Create(amap: TMap; ahelp: string);
    property help: string read _help;
    procedure Execute(acommand: string); virtual; abstract;
  end;

  (*
    The implementation of the @code(move) command.
    It inherits the interface(members, etc.) from its parent: @inherited.
  *)
  TMoveCommand = class(Tcommand)
  public
    procedure Execute(acommand: string); override;
  end;

  (*
    The implementation of the @code(attack) command.
    It inherits the interface(members, etc.) from its parent: @inherited.
  *)
  TAttackCommand = class(TCommand)
  public
    (* @seealso(TCommand.Execute) *)
    procedure Execute(acommand: string); override;
  end;

implementation

constructor TCommand.Create(amap: TMap; ahelp: string);
  begin
    _map := amap;
    _help := ahelp;
  end;

procedure TMoveCommand.Execute(acommand: string);
  // Erfasst eingaben wie: "gehe/laufe/... nach <richtung>"
  var
    re: tregexpr;
    room_change: boolean;
  begin
    re := tregexpr.Create(
      '(?i)(?:gehe|laufe) nach (norden|sueden|osten|westen)');
    re.Exec(acommand);
    room_change := _map.move_player(lowercase(re.match[1]));
    if room_change then
      writeln(_map.current_room.description);
    writeln(format('You are on field (y=%d, x=%d)',
      [_map.current_field_idx div 3, _map.current_field_idx mod 3]));
    writeln(_map.current_field.description);
    if not _map.current_field.content.isempty then
      if _map.current_field.content.isitem then
        writeln(_map.current_field.content.item.name)
      else
        _map.current_field.content.enemy.print_description;
  end;

procedure TAttackCommand.Execute(acommand: string);
  // Erfasst eingaben wie: "greife an"
  var
    player: TPlayer;
    enemy: TEnemy;
  begin
    if _map.current_field.content.isitem or
      _map.current_field.content.isempty then
    begin
      writeln('There is no enemy to attack');
      exit;
    end;

    player := _map.player;
    enemy := _map.current_field.content.enemy;

    if not enemy.is_alive then
      exit;

    player.attack(enemy);
    writeln(format(
      'Du hast %d Schaden gemacht. Dein Gegner hat jetzt noch %d Leben',
      [player.damage, enemy.health]));
    enemy.attack(player);
    writeln(format(
      'Dein Gegner hat %d Schaden gemacht. Du hast jetzt noch %d Leben',
      [enemy.damage, player.health]));

    if not enemy.is_alive then
      writeln(format('Enemy %s died, you succeeded :)', [enemy.name]));
  end;

end.
