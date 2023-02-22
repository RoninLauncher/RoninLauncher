program RoninLauncher;

uses
  crt,
  fgl,
  regexpr,
  SysUtils,
  strutils,
  rlmap,
  rlplayer,
  commands;

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
      exit(Tplayer.Create(aName, upcasefirstchar(re.match[1]), health, damage));
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

var
  map: Tmap;
  player: Tplayer;
  Name, klasse, command: string;
  global_actions: specialize TFPGMap<string, TCommand>;
  command_cls: TCommand;

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
  global_actions.add('gehe nach', TMoveCommand.Create(map));
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
    writeln('Du befindest am Rande eines dunklen Waldes.');
    writeln('Es führt nur ein Weg hinein.');
    writeln('Du folgst ihm und kommst an eine Kreuzung.');
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

    //if command='Angreifen' then attack() //noch nicht ganz sicher was da rein kommt
    // Kommandoverarbeitung
  end;
  global_actions.Free;
end.
