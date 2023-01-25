program RoninLauncher;

uses rlmap,rlplayer, unit1;

var
  map: Tmap;
  eingabe: string;
begin
  writeln('Hallo Abenteurer. Bitte sag mir deinen Namen');
  readln(eingabe);
  ClrScr;
  writeln('Willkommen'+eingabe);
  writeln('Du befindest dich vor einer Tür.');
  wrtieln('Gehst du nach links oder rechts?');
  readln(eingabe);
  if (eingabe = 'links') or (eingabe = 'rechts') then
     begin

     end;
  else writeln('Falsche Eingabe! Bitte wiederholen!')
end.

