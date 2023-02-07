unit rlattack;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils;


implementation

function attack (Player: TPlayer; Enemy: TEnemy)
begin
     player.attack(enemy);
     enemy.attack(player);
     ClrScr;
     writeln('Dein Leben ['+inttostr(Player.health)+' LP]');
     writeln('Das Leben des Gegners ['+inttostr(TEnemy.health)+' LP]');
end;

end.

