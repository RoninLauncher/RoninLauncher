unit rlplayer;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils;

type
  Tplayer=class //Spieler
    private
      name: string;
      health: integer;
      damage: integer;
      species: string;
      procedure move (room: Troom);
      procedure attack (a: integer);
  end;
  Tenemy=class(Tplayer) //Gegner
    private

  end;

implementation

procedure
end.

