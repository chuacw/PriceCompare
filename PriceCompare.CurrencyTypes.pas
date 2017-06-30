unit PriceCompare.CurrencyTypes;

interface
uses System.StdConvs, System.ConvUtils, System.Generics.Collections,
  PriceCompare.MappingBase;

type
  TCurrencyUnit = class(TMappingBase)  // ConvUtils StdConvs
  protected
    class constructor Create;
    class destructor Destroy;
  end;

  TCurrencyCents = class(TCurrencyUnit)
  public
    function UnitType: TConvType; override;
    function ToString: string; override;
  end;

  TCurrencyDollars = class(TCurrencyUnit)
  public
    function UnitType: TConvType; override;
    function ToString: string; override;
  end;

procedure RegisterCurrencyTypes;
function CurrencyList: TList<TCurrencyUnit>;

implementation
uses PriceCompare.ConvCurrency;

var
  CurrencyRegistry: TList<TCurrencyUnit>;

function CurrencyList: TList<TCurrencyUnit>;
begin
  Result := CurrencyRegistry;
end;

{ TCurrencyUnit }

class constructor TCurrencyUnit.Create;
begin
  CurrencyRegistry := TObjectList<TCurrencyUnit>.Create;
end;

class destructor TCurrencyUnit.Destroy;
begin
  CurrencyRegistry.Free;
end;

procedure RegisterCurrencyTypes;
begin
  CurrencyRegistry.Add(TCurrencyCents.Create);
  CurrencyRegistry.Add(TCurrencyDollars.Create);
end;

{ TCurrencyCents }

function TCurrencyCents.ToString: string;
begin
  Result := '¢'; // #162; // cents symbol
end;

function TCurrencyCents.UnitType: TConvType;
begin
  Result := vuCents;
end;

{ TCurrencyDollars }

function TCurrencyDollars.ToString: string;
begin
  Result := '$';
end;

function TCurrencyDollars.UnitType: TConvType;
begin
  Result := vuDollars;
end;

initialization
  RegisterCurrencyTypes;
end.
