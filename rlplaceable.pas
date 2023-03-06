unit rlplaceable;

{$mode ObjFPC}{$H+}
{$interfaces corba}

interface

uses
  rlplayer, rlitems;

type
  (*
    Record type that acts as a "union".
    Needed to differentiate the things that can be placed onto fields.

    @member isempty: Boolean - Indicates if the field is empty (@true) or not (@false).
    @member(isitem: Boolean - Indicates if the field
      contains an item (@true) or an enemy (@false).)
    @member(item/enemy: TItem/TEnemy - The actual content,
      depending on @code(isitem) it is of type @code(TItem) or @code(TEnemy).)
  *)
  TPlaceable = record
    isempty: boolean;
    case isitem: boolean of
      TRUE: (item: TItem);
      FALSE: (enemy: TEnemy);
  end;

implementation

end.
