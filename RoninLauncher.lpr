program RoninLauncher;

uses rlmap,rlplayer, unit1;

var
  map: Tmap;
  player: Tplayer
  eingabe: string;
begin
  writeln('Hallo Abenteurer. Bitte sag mir deinen Namen');                      //Einleitung grob
  readln(eingabe);
  ClrScr;
  writeln('Willkommen'+eingabe);
  player.create                                                                 //Spielercharakter erstellen und benennen
  writeln('Welche Klasse bist du?');
  writeln('Warlord/Ork/Mensch');
  readln(eingabe);
  if (eingabe = 'Warlord') or (eingabe = 'Ork') or (eingabe = 'Mensch') then    //Spieler Klasse zuweisen
     begin
       if (eingabe ='Warlord') then
          player.warlord;
       else if (eingabe ='Ork') then
          player.ork;
       else if (eingabe ='Mensch') then
          player.mensch;
     end;
  else writln('Falsche Eingabe! Bitte wiederholen');
  ClrScr;
  writeln('Also gut 'tplayer.name+'. Du bist also ein '+player.species+'.');
  writeln('Dann lass uns dein Abenteuer beginnen.');                            //Charaktererstellung abgeschlossen. Abenteuer beginnt.
  ClrScr;
  writeln('Du befindest am Rande eines dunklen Waldes.');
  writeln('Es führt nur ein Weg hinein.');
  writeln('Du folgst ihm und kommst an eine Kreuzung.');
end;

procedure player.create
begin
     player:tplayer.create;
     player.name:= (eingabe);
end

procedure player.warlord
begin
     with player do
     begin
       health:=90;
       damage:=110;
       species:='Warlord';
     end;
end;

procedure player.ork
begin
     with player do
     begin
       health:=130;
       damage:=70;
       species:='Ork';
     end;
end;

procedure player.mensch
begin
     with player do
     begin
       health:=100;
       damage:=100;
       species:='Mensch';
     end;
end;
end.

