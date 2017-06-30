unit PriceCompare.ConvCurrency;

interface
uses System.ConvUtils;

var
  cbCurrency: TConvFamily;

  vuCents: TConvType;
  vuDollars: TConvType;

implementation

initialization
  { Currency's family type }
  cbCurrency := RegisterConversionFamily('Currency');
  vuCents    := RegisterConversionType(cbCurrency, 'cents', 0.01);
  vuDollars  := RegisterConversionType(cbCurrency, 'dollars', 1);
finalization
  UnregisterConversionFamily(cbCurrency);
end.
