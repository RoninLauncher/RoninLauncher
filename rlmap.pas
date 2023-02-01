unit rlmap;

{$mode ObjFPC}{$H+}
{$interfaces corba}

interface

uses
  Classes, SysUtils, fgl, rlplayer;

type
  tdirection = (NORTH, EAST, SOUTH, WEST);
  troom_list = specialize TFPGList<Troom>;
  tfields = array[0..2] of array[0..2] of IPlaceable; // integer is a placeholder
  troom_connections = array[NORTH..WEST] of integer;

  Iplaceable = interface
  end;

  Tmap = class
  private
    _rooms: troom_list;
    _player: TPlayer;
    // Navigation
    _current_room: integer;
    _current_field: integer;
  public
    constructor Create(aplayer: TPlayer);
    procedure add_room(aroom: troom);
  end;

  Troom = class
  private
    _id: integer;
    _connections: troom_connections;
    _fields: tfields;
  class var
    _id_count: integer;
  public
    constructor Create(aconnections: troom_connections; afields: tfields);
    procedure connect(adir: tdirections; aroom_id: integer);
  end;

implementation

{ TRoom }

constructor TRoom.Create(aconnections: troom_connections; afields: tfields);
  begin
    _id := _id_count;
    Inc(_id_count);
    _connections := aconnections;
    _fields := afields;
  end;


procedure troom.connect(adir: tdirections; aroom_id: integer);
  begin
    _connections[adir] := aroom_id;
  end;

{ TMap }
constructor tmap.Create(aplayer: tplayer; astart_room: integer = 0);
  begin
    _player := aplayer;
    _current_room := astart_room;
    _current_field := 4;
  end;


procedure tmap.add_room(aroom: troom);
  begin
    _rooms.Add(aroom);
  end;


end.
