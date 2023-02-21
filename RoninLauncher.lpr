program RoninLauncher;

uses
  crt,
  fgl,
  rlmap,
  rlplayer, unit1, commands;

  function create_player(aname, aklasse: string): tplayer;
    var
      health: integer = 1;
      damage: integer = 1;
    begin
      case aklasse of
        'Warlord': begin
          health := 90;
          damage := 100;
        end;
        'Ork': begin
          health := 130;
          damage := 70;
        end;
        'Mensch': begin
          health := 100;
          damage := 100;
        end;
      end;
      exit(Tplayer.Create(aName, health, damage));
    end;

var
  map: Tmap;
  player: Tplayer;
  Name, klasse, command: string;
  global_actions: specialize TFPGMap<string, TCommand>;

begin
	global_actions := specialize TFPGMap<string, TCommand>.create;
	global_actions.add('gehe nach', TMoveCommand(map));
  // Intro, get name
  Write('Hallo Abenteurer. Bitte sag mir deinen Namen'#10#13'> ');
  //Einleitung grob
  readln(Name);
  ClrScr;
  Write('Willkommen '+Name+', welche Klasse bist du? [Warlord/Ork/Mensch]'#10#13'> ');
  readln(klasse);
  // player creation
  player := create_player(Name, klasse);
  ClrScr;
  writeln('Also gut '+Name+'. Du bist also ein '+klasse+'.');
  writeln('Dann lass uns dein Abenteuer beginnen.');
  //Charaktererstellung abgeschlossen. Abenteuer beginnt.
  ClrScr;
  // gameloop
  while True do
  begin
    // Raumausgabe/Feldausgabe
    writeln('Du befindest am Rande eines dunklen Waldes.');
    writeln('Es führt nur ein Weg hinein.');
    writeln('Du folgst ihm und kommst an eine Kreuzung.');
    // Kommandoeingabe
    write('> ');
    readln(command);
    if command='Angreifen' then attack() //noch nicht ganz sicher was da rein kommt
    // Kommandoverarbeitung
  end;

end.
