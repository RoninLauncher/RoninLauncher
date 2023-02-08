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
  public
    function get_weapon(weapon_slot);
    function drop_weapon(weapon_slot);
  end;

implementation



end.

