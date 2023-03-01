unit rlplaceable;

{$mode ObjFPC}{$H+}
{$interfaces corba}

interface

type
  IPlaceable = interface
    procedure print_description;
    function get_type: string;
  end;

implementation

end.
