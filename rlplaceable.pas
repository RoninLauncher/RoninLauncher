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
      TRUE: (item: TItem);
      FALSE: (enemy: TEnemy);
  end;

implementation

end.
