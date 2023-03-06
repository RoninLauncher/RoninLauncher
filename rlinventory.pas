(*
  The unit responsible for defining the inventory
  a player has whilst playing.
*)
unit rlinventory;

{$mode ObjFPC}{$H+}

interface

uses
  rlitems,
  Classes, SysUtils;

type
  (*
    A class defining and implementing the functionality of
    the players inventory.

    @member weapon Object-property representing the slot a player can put his weapon in.
    @member armor Object-property representing the slot a player can put his armor in.
  *)
  TInventory = class
  private
    _weapon_slot: TWeapon;
    _armor_slot: TArmor;
    _inventory_slot: array [0..9] of TItem;
  public
    property weapon: TWeapon read _weapon_slot write _weapon_slot;
    property armor: TArmor read _armor_slot write _armor_slot;
  end;

implementation

end.
