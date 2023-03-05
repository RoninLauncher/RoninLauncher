unit rlmap;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, fgl, rlplayer, rlplaceable;

type
  TDirection = (NORTH, EAST, SOUTH, WEST);
  TRoomConnections = array[TDirection] of integer;

  TField = class
  private
    _description: string;
    _content: TPlaceable;
  public
    constructor Create(adescription: string; acontent: TPlaceable);
    property description: string read _description;
    property content: TPlaceable read _content write _content;
  end;

  TFields = array[0..2, 0..2] of TField;

  // disposable
  TEmptyField = class(TField)
    constructor Create;
  end;

  // end

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
    property current_field_idx: integer read _current_field;
    property player: TPlayer read _player;
    procedure add_room(aroom: TRoom);
    function move_player(adir: string): boolean;
    // returns if player walked into new room;
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
