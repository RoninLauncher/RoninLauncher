unit rlinventory;

{$mode ObjFPC}{$H+}

interface

uses
  rlitems,
  Classes, SysUtils;

type

  TInventory = class
  private
    _weapon_slot: TWeapon; //Platzhalter für weapon  TAxe, TKnife TBow TClub TSword
    _armor_slot: TArmor;  //Platzhalter für armor   TMetal, THardmetal
//    _potion: TPotion; //Platzhalter für potion       THealthp, TStrodngp, TMaxp
    _inventory_slot: array [0..9] of TItem;
    //Inventar für alle items  TWeapon, TArmor, TPotion
  public
  end;

implementation

end.
