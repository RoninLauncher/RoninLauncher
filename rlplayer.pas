unit rlplayer;

{$mode ObjFPC}{$H+}
{$interfaces corba}

interface

uses
  Classes, SysUtils, Math;

type
  {$I rlplaceable.inc}

  TEntity = class
  private
    _name: string;
    _health: integer;
    _max_health: integer;
    _damage: integer;
    _is_alive: boolean;
    procedure _set_health(ahealth: integer);
  public
    constructor Create(aname: string; ahealth, adamage: integer);
    property health: integer read _health write _set_health;
    property is_alive: boolean read _is_alive;
    property Name: string read _name;

    procedure attack(aenemy: tentity);
  end;

  TPlayer = class(TEntity)
  private
    _klasse: string;
  public
    constructor Create(aname, aklasse: string; ahealth, adamage: integer);
    property klasse: string read _klasse;
  end;

  TEnemy = class(TEntity, IPlaceable)
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

end.
