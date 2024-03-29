(*
  A unit reponsible for handling the map the player is on
  and many other things around it.
*)
unit rlmap;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, fgl, rlplayer, rlplaceable;

type
  (*
    The direction a player can move in.

    @value NORTH walk in direction north
    @value EAST walk in direction east
    @value SOUTH walk in direction south
    @value WEST walk in direction west
  *)
  TDirection = (NORTH, EAST, SOUTH, WEST);

  (*
    Array representing the directions in which the player can leave a room.
    Each field contains an id which room the player then should enter.
    If there is no room on the connection, it stores -1.
  *)
  TRoomConnections = array[TDirection] of integer;

  (*
    Class representing a single field inside of a room (with 9 fields).

    @member(Create constructor for a field.
      @param(adescription description of the field, enables better story telling.)
      @param(acontent an item or enemy that is placed on the field.)
      @returns(A new instance of @classname.)
    )
    @member(description Read-only String-property containing
      the description of the field.)
    @member(content Object-property containing the enemy/item on the field.)
  *)
  TField = class
  private
    _description: string;
    _content: TPlaceable;
  public
    constructor Create(adescription: string; acontent: TPlaceable);
    property description: string read _description;
    property content: TPlaceable read _content write _content;
  end;

  (*
    2D-array representing the fields in a room.
  *)
  TFields = array[0..2, 0..2] of TField;

  // disposable
  (*@exclude*)
  TEmptyField = class(TField)
    constructor Create;
  end;

  // end

  (*
    Class representing a room on the map.

    @member(Create constructor for a new room on the map.
      @param(aconnections The connection one room has with others.)
      @param(afields The fields (especially its contents) a room has.)
      @param(adescription The description prompted when entering the room.)
      @returns(A new instance of @classname.)
    )
    @member description Read-only String-property containing the room description.
    @member fields Read-only Array-property containing the fields in the room.
    @member(connect Prcoedure to connect an other room to on of the direction from the room.
      @param(adir The direction the new room should be connected to.)
      @param(aroom_id The id of the room that should be connected.)
    )
    @member(get_connection Function returning the connection
        that exists in the specified direction.
      @param(adir The direction to get the connection from.)
      @returns(Integer The id of the room that lays in that direction.
        Returns -1 if no room is connected.)
    )
  *)
  TRoom = class
  private
    _id: integer;
    _connections: TRoomConnections;
    _fields: tfields;
    _description: string;
  class var
    _id_count: integer;
  public
    constructor Create(aconnections: TRoomConnections; afields: tfields;
      adescription: string);
    property description: string read _description;
    property fields: tfields read _fields;
    procedure connect(adir: tdirection; aroom_id: integer);
    function get_connection(adir: tdirection): integer;
  end;

  (*
    List of rooms, basically the map.
  *)
  TRoomList = specialize TFPGList<Troom>;

  (*
    Class representing the map and all object placed on it.

    @member(Create constructor for a new map
      @param(aplayer The player instance (should preferably be the only one/Singleton))
      @param(astart_room The room id in which the player starts.)
      @returns(A new instance of @classname.)
    )
    @member(current_room Read-only Object-property representing
      the room the player currently is in.)
    @member(current_field Read-only Object-property representing
      the field the player currently is on.)
    @member(current_field_idx Read-only Integer-property representing the
      1d-index of the field the player is currently on.)
    @member(player Read-only Object-property
      that represents the player on the map.)
    @member(add_room Procedure to add a new room to the map.
      @param(aroom the room that should get added to the map.)
    )
    @member(move_player Function that moves the player on the map.
      @param(adir the direction as a string in which the player should walk.)
      @returns(Indicates if the player walked into another room.)
    )
    @member(Free procedure to clean up memory after use.)
  *)
  TMap = class
  private
    _rooms: TRoomList;
    _player: TPlayer;
    _current_room: integer; // index in rooms
    _current_field: integer; // index on 2d room map
    _start_room: integer;
    function _get_current_room: TRoom;
    function _get_current_field: TField;
  public
    constructor Create(aplayer: TPlayer; astart_room: integer = 0);
    property current_room: TRoom read _get_current_room;
    property current_field: TField read _get_current_field;
    property current_field_idx: integer read _current_field;
    property current_room_idx: integer read _current_room;
    property start_room: integer read _start_room;
    property player: TPlayer read _player;
    procedure add_room(aroom: TRoom);
    function move_player(adir: string): boolean;
    procedure Free;
  end;

implementation

{ TRoom }
constructor TRoom.Create(aconnections: TRoomConnections; afields: TFields;
  adescription: string);
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

function TRoom.get_connection(adir: TDirection): integer;
  begin
    exit(_connections[adir]);
  end;

{ TMap }
constructor TMap.Create(aplayer: TPlayer; astart_room: integer = 0);
  begin
    _player := aplayer;
    _current_room := astart_room;
    _current_field := 4;
    _rooms := TRoomList.Create;
    _start_room := astart_room;
  end;


procedure tmap.add_room(aroom: TRoom);
  begin
    _rooms.Add(aroom);
  end;

function TMap.move_player(adir: string): boolean;
  begin
    case adir of
      'norden':
      begin
        _current_field := _current_field-3;
        if _current_field = -2 then
        begin
          if _rooms[_current_room].get_connection(NORTH) = -1 then
          begin
            _current_field := _current_field+3;
            exit(False);
          end;
          _current_room := _rooms[_current_room].get_connection(NORTH);
          _current_field := 7;
          exit(True);
        end;
        exit(False);
      end;
      'sueden':
      begin
        _current_field := _current_field+3;
        if _current_field = 10 then
        begin
          if _rooms[_current_room].get_connection(SOUTH) = -1 then
          begin
            _current_field := _current_field-3;
            exit(False);
          end;
          _current_room := _rooms[_current_room].get_connection(SOUTH);
          _current_field := 1;
          exit(True);
        end;
        exit(False);
      end;
      'osten':
      begin
        _current_field := _current_field+1;
        if _current_field = 6 then
        begin
          if _rooms[_current_room].get_connection(EAST) = -1 then
          begin
            _current_field := _current_field-1;
            exit(False);
          end;
          _current_room := _rooms[_current_room].get_connection(EAST);
          _current_field := 3;
          exit(True);
        end;
        exit(False);
      end;
      'westen':
      begin
        _current_field := _current_field-1;
        if _current_field = 2 then
        begin
          if _rooms[_current_room].get_connection(WEST) = -1 then
          begin
            _current_field := _current_field+1;
            exit(False);
          end;
          _current_room := _rooms[_current_room].get_connection(WEST);
          _current_field := 5;
          exit(True);
        end;
        exit(False);
      end;
      else
        writeln('invalid direction');
    end;
  end;

function TMap._get_current_room: TRoom;
  begin
    exit(_rooms[_current_room]);
  end;

function TMap._get_current_field: TField;
  var
    row, col: integer;
  begin
    row := _current_field div 3;
    col := _current_field mod 3;
    exit(_rooms[_current_room].fields[row, col]);
  end;

procedure TMap.Free;
  begin
    _rooms.Free;
  end;

{ TField }
constructor TField.Create(adescription: string; acontent: TPlaceable);
  begin
    _description := adescription;
    _content := acontent;
  end;

// disposable
constructor TEmptyField.Create;
  var
    wtf_content: TPlaceable;
  begin
    wtf_content.isempty := True;
    inherited Create('some desc...', wtf_content);
  end;

//end


end.
