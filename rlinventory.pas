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

    @member(Create Constructor for a new inventory
      @returns(A new @classname instance)
    )
    @member weapon Object-property representing the slot a player can put his weapon in.
    @member armor Object-property representing the slot a player can put his armor in.
    @member(slots Array-property representing the rest of the
      slots the player can put in whatever he wants.)
    @member(print Procedure to print out the inventory.)
  *)
  TInventory = class
  private
    _weapon_slot: TWeapon;
    _armor_slot: TArmor;
    _inventory_slots: array [0..9] of TItem;
    procedure _setInventorySlot(idx: integer; aitem: TItem);
    function _getInventorySlot(idx: integer): TItem;
  public
    constructor Create;
    property weapon: TWeapon read _weapon_slot write _weapon_slot;
    property armor: TArmor read _armor_slot write _armor_slot;
    property slots[idx: integer]: TItem read _getInventorySlot write _setInventorySlot;
    procedure print;
  end;

implementation

constructor TInventory.Create;
  var
    i: integer;
  begin
    _weapon_slot := nil;
    _armor_slot := nil;
    for i := low(_inventory_slots) to high(_inventory_slots) do
      _inventory_slots[i] := nil;
  end;

procedure TInventory._setInventorySlot(idx: integer; aitem: TItem);
  begin
    _inventory_slots[idx] := aitem;
  end;

function Tinventory._getInventorySlot(idx: integer): TItem;
  begin
    exit(_inventory_slots[idx]);
  end;

procedure TInventory.print;
  var
    i: integer;
  begin
    if _weapon_slot = nil then
      writeln('Weapon: empty')
    else
      writeln(format('Weapon: %s (Damage: %d)', [_weapon_slot.name, _weapon_slot.damage]));

    if _armor_slot = nil then
      writeln('Armor: empty')
    else
      writeln(format('Armor: %s', [_armor_slot.name]));

    for i := low(_inventory_slots) to high(_inventory_slots) do
      if _inventory_slots[i] = nil then
        writeln(format('Slot %d: empty', [i+1]))
      else
        writeln(format('Slot %d: %s', [i+1, _inventory_slots[i].name]));
  end;

end.
