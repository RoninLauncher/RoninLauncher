unit rlmap;

{$mode ObjFPC}{$H+}
{$interfaces corba}

interface

uses
  Classes, SysUtils, fgl, rlplayer;

type
  TDirection = (NORTH, EAST, SOUTH, WEST)
  TRoomConnections = array[NORTH..WEST] of integer;

  {$I rlplaceable.inc}  

  TField = class
  private
    _description: string;
    _content: IPlaceable;
  public
    constructor create(adescription: string; acontent: IPlaceable);
    property description: string read _description;  
  end;

  TFields = array[0..2,0..2] of TField;

  TRoom = class
  private
    _id: integer;
    _connections: troom_connections;
    _fields: tfields;
    _description: string;
    class var
      _id_count: integer;
  public
    constructor Create(aconnections: troom_connections; afields: tfields; adescription: string);
	  property description: string read _description;
	  property fields: string read _fields;
	  procedure connect(adir: tdirection; aroom_id: integer);
    function get_connection(adir: tdirection): integer;
  end;
  
  TRoomList = specialize TFPGList<Troom>;

  TMap = class
  private
    _rooms: TRoomList;
    _player: TPlayer;
    _current_room: integer; // index in rooms
    _current_field: integer; // index on 2d room map
    function _get_current_room: TRoom;
    function _get_current_field: TField;
  public
    constructor Create(aplayer: TPlayer; astart_room: integer = 0);
    property current_room: TRoom read _get_current_room;
    property current_field: TField read _get_current_field;
    procedure add_room(aroom: TRoom);
    function move_player(adir: string): boolean; // returns if player walked into new room;
    procedure print_room_description;
  end;

implementation

{ TRoom }
constructor TRoom.Create(aconnections: TRoomConnections; afields: TFields; adescription: string);
  begin
    _id := _id_count;
    _connections := aconnections;
    _fields := afields;
    _description := adescription;
		Inc(_id_count);
  end;


procedure TRoom.connect(adir: TDirection; aroom_id: integer);
  begin
    _connections[adir] := aroom_id;
  end;

function TRoom.get_connection(adir: tdirection): integer;
  begin
    exit(_connecions[adir]);
  end;

function TRoom.get_current_field(aid: integer): IPlaceable;
  begin
    exit(_fields[aid]);
  end;

{ TMap }
constructor TMap.Create(aplayer: TPlayer; astart_room: integer = 0);
  begin
    _player := aplayer;
    _current_room := astart_room;
    _current_field := 4;
  end;


procedure tmap.add_room(aroom: TRoom);
  begin
    _rooms.Add(aroom);
  end;

function TMap.move_player(adir: string): boolean;
  begin
    case adir of
    'norden', 'Norden', 'NORDEN':
      begin
        _current_field := _current_field - 3;
        if _current_field = -2 then
          begin
            _current_room := _current_room.get_connection(NORTH);
            _current_field := 7;
            exit(true);
          end;
        exit(false);
      end;
    'sueden', 'Sueden', 'SUEDEN':
      begin
        _current_field := _current_field + 3;
        if _current_field = 9 then
          begin
            _current_room := _current_room.get_connection(SOUTH);
            _current_field := 1;
          exit(true);
          end;
        exit(false);
      end;
    'osten', 'Osten', 'OSTEN':
      begin		  
        _current_field := _current_field + 1;
        if _current_field = 6 then
          begin
            _current_room := _current_room.get_connection(EAST);
            _current_field := 3;
            exit(true);
          end;
        exit(false);
      end;
    'westen', 'Westen', 'WESTEN':
      begin
        _current_field := _current_field - 1;
          if _current_field = 2 then
            begin
              _current_room := _current_room.get_connection(WEST);
              _current_field := 5;
              exit(true);
            end;
          exit(false);
        end;
      else
        raise Exception.Create('invalid direction');
      end;
  end;

function TMap._get_current_room: TRoom;
  begin
    exit(_rooms[_current_room])
  end;

function TMap._get_current_field: TField;
  var
    row, col: integer;
  begin
    row := _current_field div 3
    col := _current_field mod 3
    exit(_rooms[_current_room].fields[row,col])
  end;

{ TField }
constructor TField.create(adescription: string; acontent: IPlaceable);
  begin
    _description := adescription;
    _content := acontent;
  end;


end.
