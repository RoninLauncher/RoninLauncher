program RoninLauncher;

uses
  crt,
  fgl,
  regexpr,
  SysUtils,
  strutils,
  math,
  rlmap,
  rlplayer,
  rlcommands,
  rlitems,
  rlplaceable;

type
  TDescList1 = array of string;

var
  i: integer;
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
      content1, content2: TPlaceable;
    begin
      //      if (length(adescs) <> 3) or (length(adescs[0]) <> 3) then
      //        raise Exception.Create('not the right shape of descriptions');
      for i := low(res) to high(res) do
        for j := low(res) to high(res) do
          res[i, j] := TEmptyField.Create;
      exit(res);
    end;

  //Generierungsalgorithmus
  procedure create_content(aroom: TRoom);
    type
      twtf = class of TItem;
      twtf2 = class of TEnemy;
    var
      i,j,k,l: integer;
      row, col: integer;
      content: TPlaceable;
      iklassen: array[0..4] of twtf = (TClub, TSword, TBow, TAxe, TKnife);
      eklassen: array[0..4] of twtf2 = (TSnake, TBoss, TFrog, TOrk, TViking);
    begin
      randomize;
      i:= random(9);
      j:= random(10);
      //Feld i wird ausgewählt
      content.isempty:=false;
      divmod(i, 3, row, col);
      if j>3 then
        begin
          content.isitem:= TRUE;
          content.item:= iklassen[random(5)].create;
        end
      else
        begin
          content.isitem:= FALSE;
          content.enemy:=eklassen[random(5)].create;
        end;
      aroom.fields[row, col].content := content;
      k:= i;
      repeat
        i:= random(9);
      until i<>k;
      j:= random(10);
      //Feld i wird ausgewählt
      divmod(i, 3, row, col);
      content.isempty:=false;
      divmod(i, 3, row, col);
      if j>3 then
        begin
          content.isitem:= TRUE;
          content.item:= iklassen[random(5)].create;
        end
      else
        begin
          content.isitem:= FALSE;
          content.enemy:=eklassen[random(5)].create;
        end;
      aroom.fields[row, col].content := content;
      l:= i;
      repeat
        i:= random(9);
      until (i<>k) and (i<>l);
      j:= random(10);
      //Feld i wird ausgewählt
      divmod(i, 3, row, col);
      content.isempty:=false;
      divmod(i, 3, row, col);
      if j>3 then
        begin
          content.isitem:= TRUE;
          content.item:= iklassen[random(5)].create;
        end
      else
        begin
          content.isitem:= FALSE;
          content.enemy:=eklassen[random(5)].create;
        end;
      aroom.fields[row, col].content := content;
    end;

  procedure fill_map(map_obj: Tmap);
    var
      empty_fields: TFields;
      i, j: integer;
      room: TRoom;
    begin
      for i := low(empty_fields) to high(empty_fields) do
        for j := low(empty_fields) to high(empty_fields) do
          empty_fields[i, j] := TEmptyField.Create;

      room := TRoom.Create(create_connections(2, 5, 7, 4),
        create_fields, 'room 0');
      create_content(room);
      room := TRoom.Create(create_connections(-1, 2, 4, -1),
        empty_fields, 'room 1');
      map_obj.add_room(room);
      create_content(room);
      room := TRoom.Create(create_connections(-1, 3, 0, 1),
        empty_fields, 'room 2');
      map_obj.add_room(room);
      create_content(room);
      room := TRoom.Create(create_connections(-1, -1, 5, 2),
        empty_fields, 'room 3');
      map_obj.add_room(room);
      create_content(room);
      room := TRoom.Create(create_connections(1, 0, 6, -1),
        empty_fields, 'room 4');
      map_obj.add_room(room);
      create_content(room);
      room := TRoom.Create(create_connections(3, -1, 8, 0),
        empty_fields, 'room 5');
      map_obj.add_room(room);
      create_content(room);
      room := TRoom.Create(create_connections(4, 7, -1, -1),
        empty_fields, 'room 6');
      map_obj.add_room(room);
      create_content(room);
      room := TRoom.Create(create_connections(0, 8, -1, 6),
        empty_fields, 'room 7');
      map_obj.add_room(room);
      create_content(room);
      room := TRoom.Create(create_connections(5, -1, -1, 7),
        empty_fields, 'room 8');
      map_obj.add_room(room);
    end;

  procedure print_text(aname: string);
    var
      fIn: TextFile;
      s: string;
      filename: string;
    begin
      filename := format('writings/%s.txt', [aname]);
      assignfile(fIn, filename);
      try
        reset(fIn);
        while not eof(fIn) do
          begin
            readln(fIn, s);
            writeln(s);
            sleep(1000);
          end;
      except
        on E: EInOutError do
          writeln('An filehandling error occured: ', E.Message, '  ', filename);
      end;
    end;

begin
  global_actions := specialize TFPGMap<string, TCommand>.Create;
  // Intro, get name
  print_text('intro');
  write('>');
  //Einleitung grob
  readln(Name);
  ClrScr;

  print_text('intro2');
  sleep(2000);
  clrscr;


  print_text('species');
  Write('> ');
  readln(klasse);
  // player creation
  player := create_player(Name, klasse);
  map := TMap.Create(player);
  fill_map(map);

  // register commands
  global_actions.add('gehe nach', TMoveCommand.Create(map));
  global_actions.add('laufe nach', TMoveCommand.Create(map));
  global_actions.add('greife an', TAttackCommand.Create(map));
  global_actions.add('nehme', TTakeCommand.Create(map));
  global_actions.add('nimm', TTakeCommand.Create(map));
  global_actions.add('stats', TStatsCommand.Create(map));
  global_actions.add('gebe', TGiveCommand.Create(map));
  global_actions.add('gib', TGiveCommand.Create(map));

  ClrScr;
  writeln('Also gut '+player.Name+'. Du bist also ein '+player.klasse+'.');
  writeln('Dann lass uns dein Abenteuer beginnen.');
  //Charaktererstellung abgeschlossen. Abenteuer beginnt.
  sleep(4000);
  ClrScr;
  // gameloop
  while True do
  begin
    // Raumausgabe/Feldausgabe
    //writeln('Du befindest am Rande eines dunklen Waldes.');
    //writeln('Es führt nur ein Weg hinein.');
    //writeln('Du folgst ihm und kommst an eine Kreuzung.');
    // Kommandoeingabe
    // skjghksj alwfg wueigskjdfiuwg
    Write('> ');
    readln(command);
    // rudimentäre commands
    if command = 'help' then
      begin
        writeln('Befehle:');
        for i:=1 to global_actions.count - 1 do
          writeln(global_actions.keys[i], #9'=> ', global_actions.data[i].help);
      end;
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
