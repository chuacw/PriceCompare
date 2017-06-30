program PriceCompare;

uses
  System.StartUpCopy,
  FMX.Forms,
  DebugUtils.Log in 'DebugUtils.Log.pas',
  PriceCompare.ComparisonFrame in 'PriceCompare.ComparisonFrame.pas' {PriceCompareFrame: TFrame},
  PriceCompare.ConvCurrency in 'PriceCompare.ConvCurrency.pas',
  PriceCompare.CurrencyTypes in 'PriceCompare.CurrencyTypes.pas',
  PriceCompare.MainForm in 'PriceCompare.MainForm.pas' {frmPriceCompare},
  PriceCompare.MeasurementMappings in 'PriceCompare.MeasurementMappings.pas',
  PriceCompare.MappingBase in 'PriceCompare.MappingBase.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmPriceCompare, frmPriceCompare);
  Application.Run;
end.
