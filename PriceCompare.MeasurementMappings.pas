unit PriceCompare.MeasurementMappings;

interface
uses System.StdConvs, System.ConvUtils, System.Generics.Collections,
  PriceCompare.MappingBase;

type
  TMeasurementUnit = class(TMappingBase)  // ConvUtils StdConvs
  protected
    class constructor Create;
    class destructor Destroy;
  end;

  Tg   = class;
  TOz  = class;
  Tkg = class;
  Tmg  = class;
  Tl   = class;
  Tml  = class;

  Tg  = class(TMeasurementUnit)
  public
    function ToString: string; override;
    function UnitType: TConvType; override;
  end;

  TOz = class(TMeasurementUnit)
  public
    function ToString: string; override;
    function UnitType: TConvType; override;
  end;

  Tmg = class(TMeasurementUnit)
  public
    function ToString: string; override;
    function UnitType: TConvType; override;
  end;

  Tkg = class(TMeasurementUnit)
  public
    function ToString: string; override;
    function UnitType: TConvType; override;
  end;

  Tl = class(TMeasurementUnit)
  public
    function ToString: string; override;
    function UnitType: TConvType; override;
  end;

  Tml = class(TMeasurementUnit)
  public
    function ToString: string; override;
    function UnitType: TConvType; override;
  end;

procedure RegisterMeasurementTypes;
//procedure UnregisterMeasurementTypes;
function MeasurementList: TList<TMeasurementUnit>;

implementation

var
  MeasurementRegistry: TList<TMeasurementUnit>;

function MeasurementList: TList<TMeasurementUnit>;
begin
  Result := MeasurementRegistry;
end;

{ TMeasurementUnit }

class constructor TMeasurementUnit.Create;
begin
  MeasurementRegistry := TObjectList<TMeasurementUnit>.Create;
end;

class destructor TMeasurementUnit.Destroy;
begin
  MeasurementRegistry.Free;
end;

{ Tg }

function Tg.ToString: string;
begin
  Result := 'g';
end;

function Tg.UnitType: TConvType;
begin
  Result := muGrams;
end;

{ TOz }

function TOz.ToString: string;
begin
  Result := 'oz';
end;

function TOz.UnitType: TConvType;
begin
  Result := muOunces;
end;

{ Tmg }

function Tmg.ToString: string;
begin
  Result := 'mg';
end;

function Tmg.UnitType: TConvType;
begin
  Result := muMilligrams;
end;

{ Tkg }

function Tkg.ToString: string;
begin
  Result := 'kg';
end;

function Tkg.UnitType: TConvType;
begin
  Result := muKilograms;
end;

{ Tl }

function Tl.ToString: string;
begin
  Result := 'l';
end;

function Tl.UnitType: TConvType;
begin
  Result := vuLiters;
end;

{ Tml }

function Tml.ToString: string;
begin
  Result := 'ml';
end;

function Tml.UnitType: TConvType;
begin
  Result := vuMilliLiters;
end;

procedure RegisterMeasurementTypes;
begin
  MeasurementRegistry.Add(Tg.Create);
  MeasurementRegistry.Add(Tmg.Create);
  MeasurementRegistry.Add(Tkg.Create);
  MeasurementRegistry.Add(Tl.Create);
  MeasurementRegistry.Add(Tml.Create);
  MeasurementRegistry.Add(TOz.Create);
end;

//procedure UnregisterMeasurementTypes;
//var
//  LMeasurementUnit: TMeasurementUnit;
//begin
//  for LMeasurementUnit in MeasurementRegistry do
//    LMeasurementUnit.Free;
//
//end;

initialization
  RegisterMeasurementTypes;
//finalization
//  UnregisterMeasurementTypes;
end.
