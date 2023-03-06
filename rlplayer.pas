unit rlplayer;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Math, rlinventory;

type
  (*
    Class to represent living things on the map (entities).

    @member(Create - Base constructor for new entities
      @param(aname: String - The name of the entity.)
      @param(ahealth: Integer - The initial and therefore maximum health of the entity.)
      @param(adamage: Integer - The initial damage the entity should make.)
      @returns(A new instance of @classname.)
    )
    @member(health: Integer - Integer-Property representing the entities current health.)
    @member(is_alive: Boolean - Read-only Boolean-Property
      indicating if the entity is still alive.)
    @member(Name: String - Read-only String-Property
      containing the name of the entity.)
    @member(damage: Integer - Read-only Integer-property
      representing the damage the entity makes without weapons.)
    @member(attack - Procedure to attack other entities.
      @param(aenemy: TEntity - The entity to attack.)
    )

    @warning(This is an "abstract" class and shouldn't be used directly,
      but instead through one of its subclasses)
  *)
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

  (*
    A class representing the Player.

    It inherits most of its interface from its parent: @inherited.
    Additionally the following fields are defined:
    @member(klasse: String - Read-only String-property representing the players "league".)

    The following fields are redefined:
    @member(Create - constructor for the player
      @param(aname: String - The name of the player.)
      @param(aklasse: String - The "league" of the player.)
      @param(ahealth: Integer - The initial and therefore maximum health of the player.)
      @param(adamage: Integer - The initial damage the player should make.)
      @returns(A new instance of @classname.)
    )
  *)
  TPlayer = class(TEntity)
  private
    _klasse: string;
  public
    constructor Create(aname, aklasse: string; ahealth, adamage: integer);
    property klasse: string read _klasse;
  end;

  (*
    A base class representing all enemies on the map.

    It inherits most of its interface from its parent: @inherited.
    Additionally the following fields are defined:
    @member(print_description - Procedure to print the description of the enemy.)

    @warning(This is an "abstract" class and shouldn't be used directly,
      but instead through one of its subclasses)
  *)
  TEnemy = class(TEntity)
  public
    procedure print_description;
  end;

  (*
    A class defining snakes.
    It inherits most of its interface from its parent: @inherited.

    Additionaly the following fields get added:
    @member(Create - constructor for a snake.
      @returns(A new @classname instance.)
    )
  *)
  TSnake = class(TEnemy)
  public
    constructor Create;
  end;

  (*
    A class defining orks.
    It inherits most of its interface from its parent: @inherited.

    Additionaly the following fields get added:
    @member(Create - constructor for an ork.
      @returns(A new @classname instance.)
    )
  *)
  TOrk = class(TEnemy)
  public
    constructor Create;
  end;

  (*
    A class defining frogs.
    It inherits most of its interface from its parent: @inherited.

    Additionaly the following fields get added:
    @member(Create - constructor for a frog.
      @returns(A new @classname instance.)
    )
  *)
  TFrog = class(TEnemy)
  public
    constructor Create;
  end;

  (*
    A class defining vikings.
    It inherits most of its interface from its parent: @inherited.

    Additionaly the following fields get added:
    @member(Create - constructor for a viking.
      @returns(A new @classname instance.)
    )
  *)
  TViking = class(TEnemy)
  public
    constructor Create;
  end;

  (*
    A class defining boss enemies.
    It inherits most of its interface from its parent: @inherited.

    Additionaly the following fields get added:
    @member(Create - constructor for a boss enemy.
      @returns(A new @classname instance.)
    )
  *)
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
    _is_alive := TRUE;
  end;

procedure TEntity.attack(aenemy: TEntity);
  begin
    aenemy.health := aenemy.health-_damage;
  end;

procedure TEntity._set_health(ahealth: integer);
  begin
    _health := max(0, min(ahealth, _max_health));
    if _health = 0 then
      _is_alive := FALSE;
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
      0: _name := 'Fliegender Schlangenclown';
      1: _name := 'Äskul';
      2: _name := 'Hydrohis';
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
      0: _name := 'Infizierter Ork';
      1: _name := 'Grakkarr';
      2: _name := 'Hurghaash der Zungensammler';
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
      0: _name := 'Gelber Giftfrosch';
      1: _name := 'Dentrobaterkröte';
      2: _name := 'Phyllobatermolch';
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
      0: _name := 'Verfluchter Wikinger';
      1: _name := 'Mannnfred';
      2: _name := 'Sven';
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
      0: _name := 'Voit';
      1: _name := 'Yogg-Saron';
      2: _name := 'Blutritter';
    end;
  end;

end.
