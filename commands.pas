unit commands;

{$mode objfpc}

uses
	rlmap;

interface

type
	TCommand = class
	private
		_map: TMap;
	public
		constructor Create(amap: TMap);
		procedure execute; virtual; abstract;
	end;

implementation

constructor TCommand.Create(amap: TMap);
	begin
		_map := amap;
	end;
