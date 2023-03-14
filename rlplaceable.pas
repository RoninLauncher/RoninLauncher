(*
  An important unit, still a utils unit which contains just a record
  that is needed to be able to place either an item or an enemy on a field
  and still be able to differentiate between them.
*)
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

    @member isempty Indicates if the field is empty (@true) or not (@false).
    @member(isitem Indicates if the field
      contains an item (@true) or an enemy (@false).)
    @member item The content, if @link(isitem) is @true.
    @member enemy The content, if @link(isitem) is @false.
  *)
  TPlaceable = record
    isempty: boolean;
    case isitem: boolean of
      True: (item: TItem);
      False: (enemy: TEnemy);
  end;

implementation

end.
