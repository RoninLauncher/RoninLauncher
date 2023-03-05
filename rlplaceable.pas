unit rlplaceable;

{$mode ObjFPC}{$H+}
{$interfaces corba}

interface

uses
  rlplayer, rlitems;

type
  TPlaceable = record
    isempty: boolean;
    case isitem: boolean of
      True: (item: TItem);
      False: (enemy: TEnemy);
  end;

implementation

end.
