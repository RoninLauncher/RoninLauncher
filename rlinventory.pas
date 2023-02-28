unit rlinventory;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils;

type

  TInventory = class
  private
    _weapon_slot:=TWeapon; //Platzhalter für weapon  TAxe, TKnife TBow TClub TSword
    _armor_slot:=TArmor;  //Platzhalter für armor   TMetal, THardmetal
    _potion:=TPotion; //Platzhalter für potion       THealthp, TStrongp, TMaxp
    _inventory_slot: array [0..9] of TItem; //Inventar für alle items  TWeapon, TArmor, TPotion
  public
    function get_item(inventory_slot);
    function drop_item(inventory_slot);
    function equip_weapon;
  end;

implementation

procedure inventory_set(inventory_slot);
var i:= byte;
begin
  for i:= 0 to 9 do
      inventory_slot(i) = nil
end;

function get_item(inventory_slot: string);
var i:= byte;
begin
  for i:= 0 to 9 do
      begin
        if inventory_slot(i) = nil
             begin
                  inventory_slot(i):= ; //geht vermutlich erst beim Zusammenfügen
                  break;
             end;

      end;
end.

