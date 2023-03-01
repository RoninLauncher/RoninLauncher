unit rlitems;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, rlplaceable;

type

  TItem = class(IPlaceable)
  private
    _name: string;
  public
    procedure print_description; virtual; abstract;
    function get_type: string;
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

implementation

function TItem.get_type: string;
  begin
    exit('item');
  end;

//WAFFEN:
constructor TAxe.Create;
  var
    i: integer;
  begin
    randomize;
    _damage := random(26)+85;
    i := random(3);
    case i of
      0: begin
        _name := 'Headcutter axe';
      end;
      1: begin
        _name := 'Baber Battleaxe';
      end;
      2: begin
        _name := 'Viking axe';
      end;
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
      0: begin
        _name := 'Butcher Knife';
      end;
      1: begin
        _name := 'Night Knife';
      end;
      2: begin
        _name := 'Hallow Fade';
      end;
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
      0: begin
        _name := 'Bullseye Arc';
      end;
      1: begin
        _name := 'Bone Repeater';
      end;
      2: begin
        _name := 'Iron flatbow';
      end;
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
      0: begin
        _name := 'Smasherclub';
      end;
      1: begin
        _name := 'Shake';
      end;
      2: begin
        _name := 'Spank';
      end;
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
      0: begin
        _name := 'Slashing Sword';
      end;
      1: begin
        _name := 'Excalibur';
      end;
      2: begin
        _name := 'Kusanagi';
      end;
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

end.
