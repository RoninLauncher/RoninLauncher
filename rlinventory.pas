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
    @member(slots Array-property representing the rest of the 
      slots the player can put in whatever he wants.)
  *)
  TInventory = class
  private
    _weapon_slot: TWeapon;
    _armor_slot: TArmor;
    _inventory_slots: array [0..9] of TItem;
    procedure _setInventorySlot(idx: integer; aitem: TItem);
    function _getInventorySlot(idx: integer);
  public
    property weapon: TWeapon read _weapon_slot write _weapon_slot;
    property armor: TArmor read _armor_slot write _armor_slot;
    property slots: TItem read _getInventorySlot write _setInventorySlot;
  end;

implementation

procedure TInventory._setInventorySlot(idx: integer; aitem: TItem);
  begin
    _inventory_slots[idx] := aitem;
  end;

function Tinventory._getInventorySlot(idx: integer);
  begin
    exit(_inventory_slot[idx]);
  end;

end.
