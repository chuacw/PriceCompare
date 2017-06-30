unit PriceCompare.ComparisonFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Edit, FMX.ListBox, System.StdConvs,
  System.Generics.Collections;

type
  TPriceCompareFrame = class(TFrame)
    cbMeasurement: TComboBox;
    Edit1: TEdit;
    cbCurrency: TComboBox;
    Edit2: TEdit;
    Label1: TLabel;
    btnRemoveFrame: TButton;
    procedure cbMeasurementChange(Sender: TObject);
    procedure cbCurrencyChange(Sender: TObject);
    procedure Edit2Change(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure btnRemoveFrameClick(Sender: TObject);
  private
    FValue: Double;
    OldType1, OldType2: string;
    function GetValue1: Double;
    function GetValue2: Double;
    procedure SetValue3(const Value: Double);
    { Private declarations }
    procedure Recalculate;
    procedure SetValue1(const Value: Double);
    procedure SetValue2(const Value: Double);

    procedure SetupComboBox<T: class>(const ComboBox: TComboBox;
      const AList: TList<T>);
  public
    { Public declarations }
    procedure RepopulateLists;
    property Value1: Double read GetValue1 write SetValue1;
    property Value2: Double read GetValue2 write SetValue2;
    property Value3: Double write SetValue3;
  end;

implementation
uses PriceCompare.MeasurementMappings, System.ConvUtils,
  PriceCompare.ConvCurrency, PriceCompare.CurrencyTypes;

{$R *.fmx}

procedure TPriceCompareFrame.btnRemoveFrameClick(Sender: TObject);
begin
  TThread.Queue(nil, procedure begin
    Parent.RemoveObject(Self);
  end);
end;

procedure TPriceCompareFrame.cbMeasurementChange(Sender: TObject);
var
  SValue1: string;
  LGroceryUnit: TMeasurementUnit;
  LOldFound, LNewFound: Boolean;
  LOldType, LNewType: TConvType;
  LNewValue: Double;
  LList: TList<TMeasurementUnit>;
begin
  if cbMeasurement.Count = 0 then Exit;
  SValue1 := cbMeasurement.Items[cbMeasurement.ItemIndex];

// The following code converts the old value to the new value, if the measure type is the same
// For example, 500 g is 0.5kg. So if you have 500 in the edit, and g in the ComboBox,
// and the user selected kg from the ComboBox, then 500 is converted into 0.5 in the edit.
  if OldType1 <> '' then
    begin
      LOldType := 0; LNewType := 0;
      LOldFound := False; LNewFound := False;
      LList := MeasurementList;
      for LGroceryUnit in LList do
        begin
          if (LGroceryUnit.ToString = OldType1) and not LOldFound then
            begin
              LOldType := LGroceryUnit.UnitType;
              LOldFound := True;
            end;
          if (LGroceryUnit.ToString = SValue1) and not LNewFound then // Get the new type
            begin
              LNewType := LGroceryUnit.UnitType;
              LNewFound := True;
            end;

          // Ensure that the old type and the new type are compatible types
          // eg, converting mg and g works, but not mg and L.
          if LOldFound and LNewFound and CompatibleConversionTypes(LOldType, LNewType) then
            begin
              LNewValue := Convert(Value1, LOldType, LNewType);
              Value1 := LNewValue;
              Break;
            end;
        end;
    end;

  OldType1 := SValue1; // Update/Keep track of the old type for comparison
  Recalculate;
end;

procedure TPriceCompareFrame.cbCurrencyChange(Sender: TObject);
var
  SValue1: string;
  LCurrencyUnit: TCurrencyUnit;
  LOldType, LNewType: TConvType;
  LOldFound, LNewFound: Boolean;
  LNewValue: Double;
  LList: TList<TCurrencyUnit>;
begin
  if cbCurrency.Count = 0 then Exit;
  SValue1 := cbCurrency.Items[cbCurrency.ItemIndex];

  if OldType2 <> '' then
    begin
      LOldType := 0; LNewType := 0;
      LOldFound := False; LNewFound := False;
      LList := CurrencyList;
      for LCurrencyUnit in LList do
        begin
          if LCurrencyUnit.ToString = OldType2 then
            begin
              LOldType := LCurrencyUnit.UnitType;
              LOldFound := True;
            end;
          if LCurrencyUnit.ToString = SValue1 then // Get the new type
            begin
              LNewType := LCurrencyUnit.UnitType;
              LNewFound := True;
            end;
          // Ensure that the old type and the new type are compatible types
          // eg, converting mg and g works, but not mg and L.
          if LOldFound and LNewFound and CompatibleConversionTypes(LOldType, LNewType) then
            begin
              LNewValue := Convert(Value2, LOldType, LNewType);
              Value2 := LNewValue;
              Break;
            end;
        end;
    end;

  OldType2 := SValue1; // Update/Keep track of the old type for comparison
  Recalculate;
end;

procedure TPriceCompareFrame.Edit1Change(Sender: TObject);
begin
  Recalculate;
end;

procedure TPriceCompareFrame.Edit2Change(Sender: TObject);
begin
  Recalculate;
end;

function TPriceCompareFrame.GetValue1: Double;
begin
  Result := StrToFloatDef(Edit1.Text, 0.0);
end;

function TPriceCompareFrame.GetValue2: Double;
begin
  Result := StrToFloatDef(Edit2.Text, 0.0);
end;

procedure TPriceCompareFrame.Recalculate;
var
  SValue1, SValue2: string;
  LValue1, LValue2, LValue3: Double;
begin
  if (cbMeasurement.Count = 0) or (cbCurrency.Count = 0) or (cbMeasurement.ItemIndex=-1) or
    (cbCurrency.ItemIndex=-1) then Exit;
  SValue1 := cbMeasurement.Items[cbMeasurement.ItemIndex];
  SValue2 := cbCurrency.Items[cbCurrency.ItemIndex];

//  OldType := SValue1;

  LValue1 := Value1;
  LValue2 := Value2;
  if (LValue1 > 0.0) and (LValue2 > 0.0) then
    begin
      LValue3 := LValue2 / LValue1;
      FValue := LValue3;
    end;

  Label1.Text := Format('%.g %s per %s', [FValue, SValue2, SValue1]);
end;

procedure TPriceCompareFrame.RepopulateLists;
begin
  SetupComboBox<TMeasurementUnit>(cbMeasurement, MeasurementList);

  SetupComboBox<TCurrencyUnit>(cbCurrency, CurrencyList);
end;

procedure TPriceCompareFrame.SetupComboBox<T>(const ComboBox: TComboBox;
  const AList: TList<T>);
var
  LUnit: T;
begin
  ComboBox.Items.Clear;
  for LUnit in AList do
    begin
      ComboBox.Items.Add(LUnit.ToString);
    end;
  ComboBox.ItemIndex := 0;
end;

procedure TPriceCompareFrame.SetValue1(const Value: Double);
begin
  Edit1.Text := FloatToStr(Value);
end;

procedure TPriceCompareFrame.SetValue2(const Value: Double);
begin
  LFormatSettings := TFormatSettings.Create;
  Edit2.Text := FloatToStr(Value, LFormatSettings);
end;

procedure TPriceCompareFrame.SetValue3(const Value: Double);
begin
  FValue := Value;
  Recalculate;
end;

end.
