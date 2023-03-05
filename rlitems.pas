unit rlitems;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils;

type

  TItem = class
  private
    _name: string;
  public
    property name: string read _name;
  end;

  TWeapon = class(TItem)
  private
    _damage: integer;
  end;

  TAxe = class(TWeapon)
  public
    constructor Create;
  end;

  TKnife = class(TWeapon)
  public
    constructor Create;
  end;

  TBow = class(TWeapon)
  public
    constructor Create;
  end;

  TClub = class(TWeapon)
  public
    constructor Create;
  end;

  TSword = class(TWeapon)
  public
    constructor Create;
  end;

  TArmor = class(TItem)
  private
    _max_health: integer;
  end;

  TMetal = class(TArmor)
  public
    constructor Create;
  end;

  THardmetal = class(TArmor)
  public
    constructor Create;
  end;

(* not a good idea yet
  TPotion = class(TItem)
  private
    _damage: integer;
    _health: integer;
    _max_health: integer;
  end;

  THealthp = class(TPotion)
  public
    constructor Create;
  end;

  TStrongp = class(TPotion)
  public
    constructor Create;
  end;

  TMaxp = class(TPotion)
  public
    constructor Create;
  end;
*)
implementation

//WAFFEN:
constructor TAxe.Create;
  var
    i: integer;
  begin
    randomize;
    _damage := random(26)+85;
    i := random(3);
    case i of
      0: _name := 'Headcutter axe';
      1: _name := 'Baber Battleaxe';
      2: _name := 'Viking axe';
    end;

  end;

constructor TKnife.Create;
  var
    i: integer;
  begin
    randomize;
    _damage := random(21)+25;
    i := random(3);
    case i of
      0: _name := 'Butcher Knife';
      1: _name := 'Night Knife';
      2: _name := 'Hallow Fade';
    end;

  end;

constructor TBow.Create;
  var
    i: integer;
  begin
    randomize;
    _damage := random(71)+50;
    i := random(3);
    case i of
      0: _name := 'Bullseye Arc';
      1: _name := 'Bone Repeater';
      2: _name := 'Iron flatbow';
    end;

  end;

constructor TClub.Create;
  var
    i: integer;
  begin
    randomize;
    _damage := random(36)+60;
    i := random(3);
    case i of
      0: _name := 'Smasherclub';
      1: _name := 'Shake';
      2: _name := 'Spank';
    end;

  end;

constructor TSword.Create;
  var
    i: integer;
  begin
    randomize;
    _damage := random(86)+75;
    i := random(3);
    case i of
      0: _name := 'Slashing Sword';
      1: _name := 'Excalibur';
      2: _name := 'Kusanagi';
    end;

  end;

//RÜSTUNG:
constructor TMetal.Create;
  begin
    randomize;
    _max_health := random(201);
    _name := 'Metallrüstung';
  end;

constructor THardmetal.Create;
  begin
    randomize;
    _max_health := random(201)+100;
    _name := 'Hartmetallrüstung';
  end;

//TRÄNKE:
(*
constructor THealthp.Create;
  begin
    _name := 'Heiltrank';
    _health := 20;
  end;

constructor TStrongp.Create;
  begin
    _name := 'Stärketrank';
    _damage := 10;
  end;

constructor TMaxp.Create;
  begin
    _name := 'Maxtrank';
    _max_health := 10;
  end;
*)
end.
