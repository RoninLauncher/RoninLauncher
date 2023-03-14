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
  rlplayer,
  rlitems,
  rlplaceable,
  rlinventory;

type
  (*
    The base class for all commands. Defines some helpful functionality
    and the interface all commands must follow.

    @member(Create Base constructor for a command.
      @param(amap The current map instance, used to gather all informations in one place.)
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
    constructor Create(amap: TMap);
    property help: string read _help;
    procedure Execute(acommand: string); virtual; abstract;
  end;

  (*
    The implementation of the @code(move) command.

    It inherits the interface from its parent @inherited and just changes inside logic.
  *)
  TMoveCommand = class(Tcommand)
  public
    (* @seealso(TCommand.Create) *)
    constructor Create(amap: TMap);
    (* @seealso(TCommand.Execute) *)
    procedure Execute(acommand: string); override;
  end;

  (*
    The implementation of the @code(attack) command.

    It inherits the interface from its parent @inherited and just changes inside logic.
  *)
  TAttackCommand = class(TCommand)
  public
    (* @seealso(TCommand.Create) *)
    constructor Create(amap: Tmap);
    (* @seealso(TCommand.Execute) *)
    procedure Execute(acommand: string); override;
  end;

  (*
    The implementation of the @code(take) command.

    It inherits the interface from its parent @inherited and just changes inside logic.
  *)
  TTakeCommand = class(TCommand)
  public
    (* @seealso(TCommand.Create) *)
    constructor Create(amap: Tmap);
    (* @seealso(TCommand.Execute) *)
    procedure Execute(acommand: string); override;
  end;

implementation

constructor TCommand.Create(amap: TMap);
  begin
    _map := amap;
  end;

constructor TMoveCommand.Create(amap: TMap);
  begin
    inherited;
    _help := 'Bewege Spieler nach Norden, Osten, Sueden oder Westen. [gehe/laufe nach RICHTUNG]';
  end;

constructor TAttackCommand.Create(amap: TMap);
  begin
    inherited;
    _help := 'Greife einen Gegner auf deinem derzeitigen Feld an. [greife an]';
  end;

constructor TTakeCommand.Create(amap: TMap);
  begin
    inherited;
    _help :=
      'Nehme einen Gegenstand von deinem derzeitigen Feld auf. [nehme/nimm in slot waffe/ruestung/SLOT]';
  end;

procedure TMoveCommand.Execute(acommand: string);
  // Erfasst eingaben wie: "gehe/laufe/... nach <richtung>"
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
    if not _map.current_field.content.isempty then
      if _map.current_field.content.isitem then
        writeln(_map.current_field.content.item.Name)
      else
        _map.current_field.content.enemy.print_description;
  end;

procedure TAttackCommand.Execute(acommand: string);
  // Erfasst eingaben wie: "greife an"
  var
    player: TPlayer;
    enemy: TEnemy;
  begin
    if _map.current_field.content.isitem or  _map.current_field.content.isempty or
      (not _map.current_field.content.enemy.is_alive) then
    begin
      writeln('Du kannst dich nicht selber angreifen. :)');
      exit;
    end;

    player := _map.player;
    enemy := _map.current_field.content.enemy;

    player.attack(enemy);
    writeln(format('Du hast %d Schaden gemacht. Dein Gegner hat jetzt noch %d Leben',
      [player.damage, enemy.health]));

    if not enemy.is_alive then
    begin
      writeln(format('Enemy %s died, you succeeded :)', [enemy.Name]));
      exit;
    end;

    enemy.attack(player);
    writeln(format('Dein Gegner hat %d Schaden gemacht. Du hast jetzt noch %d Leben',
      [enemy.damage, player.health]));

  end;

procedure TTakeCommand.Execute(acommand: string);
  // Erfasst eingaben wie: "nehme/nimm (gegenstand)? in slot SLOT (auf)?) "
  var
    re: TRegExpr;
    idx: integer;
  begin
    re := TRegExpr.Create(
      '(?i)(?:nehme|nimm)(?: gegenstand)? in slot (waffe|ruestung|[0123456789])(?: auf)?');
    if not re.Exec(acommand) then
      begin
        writeln('Ungültiger Befehl, schau doch nochmal nach. :)');
        exit;
      end;

    if _map.current_field.content.isempty or (not _map.current_field.content.isitem) then
      begin
        writeln('Du kannst nicht Nichts in dein Inventar packen. :)');
        exit;
      end;

    if re.Match[1] = 'waffe' then
      _map.player.inventory.weapon := TWeapon(_map.current_field.content.item)
    else if re.Match[1] = 'ruestung' then
      _map.player.inventory.armor := TArmor(_map.current_field.content.item)
    else
      begin
        idx := StrToInt(re.Match[1]) - 1;
        _map.player.inventory.slots[idx] := _map.current_field.content.item;
      end;
    _map.player.inventory.print;
  end;

end.
