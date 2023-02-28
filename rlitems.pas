unit rlitems;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils;

  TItem = class
  private
  _name: string;
  public
  constructor create(name: string)
  end;

  TWeapon = class (TItem)
  private
  _damage: integer;
  end;

      TAxe = class (TWeapon)
      TKnife = class (TWeapon)
      TBow = class (TWeapon)
      TClub = class (TWeapon)
      TSword = class (TWeapon)

  TArmor = class (TItem)
  private
  _health: integer;
  end;

      TMetal = class (TArmor)
      THardmetal = class (TArmor)

  TPotion = class (TItem)
  private
  _damage: integer;
  _health: integer;
  _max_health: integer;
  end;

      THealthp = class (TPotion)
      TStrongp = class (TPotion)
      TMaxp = class (TPotion)


implementation

end.

