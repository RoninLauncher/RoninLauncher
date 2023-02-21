unit rlinventory;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils;

type

  TInventory = class
  private
    weapon_slot:=string; //Platzhalter für weapon
    armor_slot:=string;  //Platzhalter für armor
    life_potion:=string; //Platzhalter für life_potion
    inventory_slot: array [0..9] of string; //Inventar für alle items
  public
    function get_item(inventory_slot);
    function drop_item(inventory_slot);
    function equip_weapon
  end;

implementation

procedure inventory_set(inventory_slot)
var i:= byte;
begin
  for i:= 0 to 9 do
      inventory_slot(i) = nil
end;

function get_item(inventory_slot)
var i:= byte;
begin
  for i:= 0 to 9 do
      begin
        if inventory_slot(i) = nil
             begin
                  inventory_slot(i):= item; //da müssten wir noch die Klassen erstellen
                  break;
             end;

      end;
end.

