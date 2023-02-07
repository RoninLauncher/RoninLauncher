unit rlmap;

{$mode ObjFPC}{$H+}
{$interfaces corba}

interface

uses
  Classes, SysUtils, strutils, rlplayer, rlmap;

implementation

procedure _move(amap: TMap, eingabe: string);
	var
		dir: string;
		room_change: boolean;
	begin
		dir := splitstring(eingabe)[2];
		room_change := amap.move_player(player);
		if room_change then
		  write(amap.current_room.description);
		else
		  write(amap.current_field.description);
		end;
	end;

end.
