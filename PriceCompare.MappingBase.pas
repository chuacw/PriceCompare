unit PriceCompare.MappingBase;

interface
uses System.ConvUtils;

type
  TMappingBase = class abstract
  public
    function UnitType: TConvType; virtual; abstract;
  end;

implementation

end.
