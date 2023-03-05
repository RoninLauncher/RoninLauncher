program RoninLauncher;

uses
  crt,
  fgl,
  regexpr,
  SysUtils,
  strutils,
  rlmap,
  rlplayer,
  rlcommands,
  rlitems,
  rlplaceable;

type
  TDescList1 = array of string;
  TDescList2 = array of TDescList1;

var
  map: Tmap;
  player: Tplayer;
  Name, klasse, command: string;
  global_actions: specialize TFPGMap<string, TCommand>;
  command_cls: TCommand;

  function UpCaseFirstChar(const s: string): string;
    begin
      if Length(s) = 0 then
        exit(s)
      else
      begin
        Result := LowerCase(S);
        Result[1] := UpCase(Result[1]);
      end;
    end;

  function create_player(aname, aklasse: string): tplayer;
    var
      health: integer = 1;
      damage: integer = 1;
      re: TRegexpr;
    begin
      re := TRegExpr.Create('(?i)(mensch|ork|warlord)');
      re.exec(aklasse);
      case re.match[1] of
        'warlord': begin
          health := 90;
          damage := 100;
        end;
        'ork': begin
          health := 130;
          damage := 70;
        end;
        'mensch': begin
          health := 100;
          damage := 100;
        end;
      end;
      re.Free;
      exit(Tplayer.Create(upcasefirstchar(aName), upcasefirstchar(re.match[1]),
        health, damage));
    end;

  function parse_commands(actions_map: specialize TFPGMap<string, TCommand>;
    command: string): TCommand;
    var
      i: integer;
      key: string;
    begin
      for i := 0 to actions_map.Count-1 do
      begin
        key := actions_map.keys[i];
        if startsstr(key, LowerCase(command)) then
          exit(actions_map.keydata[key]);
      end;
      exit(nil);
    end;


  function create_connections(anorth, aeast, asouth, awest: integer):
  TRoomConnections;
    var
      res: TRoomConnections;
    begin
      res[NORTH] := anorth;
      res[EAST] := aeast;
      res[SOUTH] := asouth;
      res[WEST] := awest;
      exit(res);
    end;

  //function create_fields(adescs: TDescList2): TFields;
  function create_fields: TFields;
    var
      res: TFields;
      i, j: integer;
      content: TPlaceable;
    begin
      //      if (length(adescs) <> 3) or (length(adescs[0]) <> 3) then
      //        raise Exception.Create('not the right shape of descriptions');
      for i := low(res) to high(res) do
        for j := low(res) to high(res) do
          res[i, j] := TEmptyField.Create;
      content.isempty := False;
      content.isitem := False;
      content.enemy := TEnemy.Create('foo', 100, 10);
      res[0, 1].content := content;
      exit(res);
    end;

  procedure fill_map(map_obj: Tmap);
    var
      empty_fields: TFields;
      i, j: integer;
    begin
      for i := low(empty_fields) to high(empty_fields) do
        for j := low(empty_fields) to high(empty_fields) do
          empty_fields[i, j] := TEmptyField.Create;

      map_obj.add_room(TRoom.Create(create_connections(2, 5, 7, 4),
        create_fields, 'room 0'));
      map_obj.add_room(TRoom.Create(create_connections(-1, 2, 4, -1),
        empty_fields, 'room 1'));
      map_obj.add_room(TRoom.Create(create_connections(-1, 3, 0, 1),
        empty_fields, 'room 2'));
      map_obj.add_room(TRoom.Create(create_connections(-1, -1, 5, 2),
        empty_fields, 'room 3'));
      map_obj.add_room(TRoom.Create(create_connections(1, 0, 6, -1),
        empty_fields, 'room 4'));
      map_obj.add_room(TRoom.Create(create_connections(3, -1, 8, 0),
        empty_fields, 'room 5'));
      map_obj.add_room(TRoom.Create(create_connections(4, 7, -1, -1),
        empty_fields, 'room 6'));
      map_obj.add_room(TRoom.Create(create_connections(0, 8, -1, 6),
        empty_fields, 'room 7'));
      map_obj.add_room(TRoom.Create(create_connections(5, -1, -1, 7),
        empty_fields, 'room 8'));
    end;

begin
  global_actions := specialize TFPGMap<string, TCommand>.Create;
  // Intro, get name
  Write('Hallo Abenteurer. Bitte sag mir deinen Namen'#10#13'> ');
  //Einleitung grob
  readln(Name);
  ClrScr;
  Writeln('Willkommen, welche Klasse möchtest du sein? [Warlord/Ork/Mensch]');
  Write('> ');
  readln(klasse);
  // player creation
  player := create_player(Name, klasse);
  map := TMap.Create(player);
  fill_map(map);

  // register commands
  global_actions.add('gehe nach', TMoveCommand.Create(map,
    'bewege spieler nach norden, osten, sueden oder westen'));
  global_actions.add('laufe nach', TMoveCommand.Create(map,
    'bewege spieler nach norden, osten, sueden oder westen'));
  global_Actions.add('greife an', TAttackCommand.Create(map,
    'greife einen gegner auf dem derzeitigen feld an'));

  ClrScr;
  writeln('Also gut '+player.Name+'. Du bist also ein '+player.klasse+'.');
  writeln('Dann lass uns dein Abenteuer beginnen.');
  //Charaktererstellung abgeschlossen. Abenteuer beginnt.
  sleep(2000);
  ClrScr;
  // gameloop
  while True do
  begin
    // Raumausgabe/Feldausgabe
    //writeln('Du befindest am Rande eines dunklen Waldes.');
    //writeln('Es führt nur ein Weg hinein.');
    //writeln('Du folgst ihm und kommst an eine Kreuzung.');
    // Kommandoeingabe
    Write('> ');
    readln(command);
    // rudimentäre commands
    if command = 'quit' then
      break;
    command_cls := parse_commands(global_actions, command);
    if command_cls = nil then
    begin
      writeln('command not found...');
      continue;
    end;
    command_cls.Execute(command);

    if not player.is_alive then
      begin
        writeln('Game over. You are dead :(');
        break;
      end;

    //if command='Angreifen' then attack() //noch nicht ganz sicher was da rein kommt
    // Kommandoverarbeitung
  end;
  global_actions.Free;
  map.Free;
end.
