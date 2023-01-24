unit rlmap;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, fgl;

type
  tdirection = (NORTH, EAST, SOUTH, WEST);
  tdir_room_map = specialize TFPGMap<tdirection, integer>;

  Tmap = class
  private
    _rooms: specialize TFPGList<TRoom>;
  public
    constructor Create;
    procedure Free;
    procedure add_room(aroom: troom);
  end;

  Troom = class
  private
    _id: integer;
    _move_dirs: tdir_room_map;
  class var
    _id_count: integer;
  public
    constructor Create(adir_room_map: tdir_room_map);
    procedure Free;
    procedure add_dir(adir: tdirection; aroom: integer);

  end;

implementation

{ TRoom }

constructor TRoom.Create(adir_room_map: tdir_room_map);
  begin
    _id := _id_count;
    Inc(_id_count);
    if _move_dirs<>nil then
      _move_dirs := adir_room_map
    else
      _move_dirs := tdir_room_map.Create;
  end;

procedure troom.Free;
  begin
    _move_dirs.Free;
    self := nil;
  end;

procedure troom.add_dir(adir: tdirection; aroom: integer);
  begin
    if aroom>=_id_count then
      raise Exception('you want to add a non-existing room');
    _move_dirs.AddOrSetData(adir, aroom);
  end;

{ TMap }
constructor tmap.Create;
  begin
    _rooms := specialize TFPGList<Troom>.Create;
  end;

procedure tmap.Free;
  begin
    _rooms.Free;
    self := nil;
  end;

procedure tmap.add_room(aroom: troom);
  begin
    _rooms.Add(aroom);
  end;


end.
