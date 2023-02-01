unit rlplayer;

{$mode ObjFPC}{$H+}
{$interfaces corba}

interface

uses
  Classes, SysUtils, Math;

type
  {$I rlplaceable.inc}

  Tentity = class //Spieler
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

  tplayer = class(tentity)
  end;

  Tenemy = class(tentity, iplaceable)
  end;

implementation

constructor tentity.Create(aname: string; ahealth, adamage: integer);
  begin
    _name := aname;
    _health := max(1, ahealth);
    _max_health := _health;
    _damage := max(1, adamage);
    _is_alive := True;
  end;

procedure tentity.attack(aenemy: tentity);
  begin
    aenemy.health := aenemy.health-_damage;
  end;

procedure tentity._set_health(ahealth: integer);
  begin
    if _health = -1 then
    begin
      _health := max(1, ahealth);
      _max_health := _health;
      exit();
    end;
    _health := max(0, min(ahealth, _max_health));
    if _health = 0 then
      _is_alive := False;
  end;

end.
