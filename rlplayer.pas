unit rlplayer;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Math, rlinventory;

type
  TEntity = class
  private
    _name: string;
    _health: integer;
    _max_health: integer;
    _damage: integer;
    _is_alive: boolean;
    _inventory: TInventory;
    procedure _set_health(ahealth: integer);
  public
    constructor Create(aname: string; ahealth, adamage: integer);
    property health: integer read _health write _set_health;
    property is_alive: boolean read _is_alive;
    property Name: string read _name;
    property damage: integer read _damage;
    procedure attack(aenemy: tentity);
  end;

  TPlayer = class(TEntity)
  private
    _klasse: string;
  public
    constructor Create(aname, aklasse: string; ahealth, adamage: integer);
    property klasse: string read _klasse;
  end;

  TEnemy = class(TEntity)
  public
    procedure print_description;
  end;

  TSnake = class(TEnemy)
  public
    constructor Create;
  end;

  TOrk = class(TEnemy)
  public
    constructor Create;
  end;

  TFrog = class(TEnemy)
  public
    constructor Create;
  end;

  TViking = class(TEnemy)
  public
    constructor Create;
  end;

  TBoss = class(TEnemy)
  public
    constructor Create;
  end;

implementation

constructor TEntity.Create(aname: string; ahealth, adamage: integer);
  begin
    _name := aname;
    _health := max(1, ahealth);
    _max_health := _health;
    _damage := max(1, adamage);
    _is_alive := True;
  end;

procedure TEntity.attack(aenemy: TEntity);
  begin
    aenemy.health := aenemy.health-_damage;
  end;

procedure TEntity._set_health(ahealth: integer);
  begin
    _health := max(0, min(ahealth, _max_health));
    if _health = 0 then
      _is_alive := False;
  end;

constructor TPlayer.Create(aname, aklasse: string; ahealth, adamage: integer);
  begin
    inherited Create(aname, ahealth, adamage);
    _klasse := aklasse;
  end;

procedure TEnemy.print_description;
  begin
    if not is_alive then
      exit;
    writeln(format('I am %s. I gonna destroy you!!!', [_name]));
  end;

constructor TSnake.Create;
  var
    i: integer;
  begin
    randomize;
    _health := random(111)+130;
    _damage := random(6)+25;
    i := random(3);
    case i of
      0: begin
        _name := 'Fliegender Schlangenclown';
      end;
      1: begin
        _name := 'Äskul';
      end;
      2: begin
        _name := 'Hydrohis';
      end;
    end;
  end;

constructor TOrk.Create;
  var
    i: integer;
  begin
    randomize;
    _health := random(191)+160;
    _damage := random(11)+35;
    i := random(3);
    case i of
      0: begin
        _name := 'Infizierter Ork';
      end;
      1: begin
        _name := 'Grakkarr';
      end;
      2: begin
        _name := 'Hurghaash der Zungensammler';
      end;
    end;
  end;

constructor TFrog.Create;
  var
    i: integer;
  begin
    randomize;
    _health := random(61)+120;
    _damage := random(16)+35;
    i := random(3);
    case i of
      0: begin
        _name := 'Gelber Giftfrosch';
      end;
      1: begin
        _name := 'Dentrobaterkröte';
      end;
      2: begin
        _name := 'Phyllobatermolch';
      end;
    end;
  end;

constructor TViking.Create;
  var
    i: integer;
  begin
    randomize;
    _health := random(121)+80;
    _damage := random(41)+20;
    i := random(3);
    case i of
      0: begin
        _name := 'Verfluchter Wikinger';
      end;
      1: begin
        _name := 'Mannnfred';
      end;
      2: begin
        _name := 'Sven';
      end;
    end;
  end;

constructor TBoss.Create;
  var
    i: integer;
  begin
    randomize;
    _health := random(181)+370;
    _damage := random(31)+50;
    i := random(3);
    case i of
      0: begin
        _name := 'Voit';
      end;
      1: begin
        _name := 'Yogg-Saron';
      end;
      2: begin
        _name := 'Blutritter';
      end;
    end;
  end;

end.
