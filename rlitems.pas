(*
  Defines all items the game has.
  They will be placed randomly across the map.
*)
unit rlitems;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils;

type
  (*
    The base class for all items.
    It defines the interface and functionality that all items need.

    @member Name Read-only string-properts containing the name of the item.

    @warning(This is an "abstract" class and shouldn't be used directly,
      but instead through one of its subclasses)
  *)
  TItem = class
  private
    _name: string;
  public
    property Name: string read _name;
  end;

  (*
    The base class for all weapons.
    It inherits most of its interface from its parent: @inherited.

    Additionaly some fields described in the following get added:
    @member damage Read-only Integer-property containing the damage the weapon adds.

    @warning(This is an "abstract" class and shouldn't be used directly,
      but intead through one of its subclasses)
  *)
  TWeapon = class(TItem)
  private
    _damage: integer;
  public
    property damage: integer read _damage;
  end;

  (*
    A class defining axe weapons.
    It inherits most of its interface from its parent: @inherited.

    Additionaly some fields described in the following get added:
    @member(Create constructor for an axe.
      @returns(A new @classname instance.)
    )
  *)
  TAxe = class(TWeapon)
  public
    constructor Create;
  end;

  (*
    A class defining knife weapons.
    It inherits most of its interface from its parent: @inherited.

    Additionaly some fields described in the following get added:
    @member(Create constructor for a knife.
      @returns(A new @classname instance.)
    )
  *)
  TKnife = class(TWeapon)
  public
    constructor Create;
  end;

  (*
    A class defining bow weapons.
    It inherits most of its interface from its parent: @inherited.

    Additionaly some fields described in the following get added:
    @member(Create constructor for a bow.
      @returns(A new @classname instance.)
    )
  *)
  TBow = class(TWeapon)
  public
    constructor Create;
  end;

  (*
    A class defining club weapons.
    It inherits most of its interface from its parent: @inherited.

    Additionaly some fields described in the following get added:
    @member(Create constructor for a club.
      @returns(A new @classname instance.)
    )
  *)
  TClub = class(TWeapon)
  public
    constructor Create;
  end;

  (*
    A class defining sword weapons.
    It inherits most of its interface from its parent: @inherited.

    Additionaly some fields described in the following get added:
    @member(Create constructor for a sword.
      @returns(A new @classname instance.)
    )
  *)
  TSword = class(TWeapon)
  public
    constructor Create;
  end;

  (*
    The base class for all armors.
    It inherits most of its interface from its parent: @inherited.

    Additionaly some fields described in the following get added:
    @member health Read-only Integer-property containing the health that can be added to the player.

    @warning(This is an "abstract" class and shouldn't be used directly,
      but instead through one of its subclasses.)
  *)
  TArmor = class(TItem)
  private
    _health: integer;
  public
    property health: integer read _health;
  end;

  (*
    A class defining metal armors.
    It inherits most of its interface from its parent: @inherited.

    Additionaly some fields described in the following get added:
    @member(Create constructor for a metal armor.
      @returns(A new @classname instance.)
    )
  *)
  TMetal = class(TArmor)
  public
    constructor Create;
  end;

  (*
    A class defining hard metal armors.
    It inherits most of its interface from its parent: @inherited.

    Additionaly some fields described in the following get added:
    @member(Create constructor for a hard metal armor.
      @returns(A new @classname instance.)
    )
  *)
  THardmetal = class(TArmor)
  public
    constructor Create;
  end;

(* TODO not a good idea yet
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
