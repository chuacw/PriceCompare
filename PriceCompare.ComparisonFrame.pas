unit PriceCompare.ComparisonFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Edit, FMX.ListBox, System.StdConvs,
  System.Generics.Collections, PriceCompare.MappingBase;

type
  TPriceCompareFrame = class(TFrame)
    cbMeasurement: TComboBox;
    edMeasurement: TEdit;
    cbCurrency: TComboBox;
    edCurrency: TEdit;
    Label1: TLabel;
    btnRemoveFrame: TButton;
    procedure cbMeasurementChange(Sender: TObject);
    procedure cbCurrencyChange(Sender: TObject);
    procedure Edit2Change(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure btnRemoveFrameClick(Sender: TObject);

  private
  type TUpdateProc = reference to procedure (ANewValue: Double);
  var
    FValue: Double;
    FOldMeasurementType, FOldCurrencyType: string;
    function GetMeasurementValue: Double;
    function GetCurrencyValue: Double;
//    procedure SetValue3(const AValue: Double);
    { Private declarations }
    procedure Recalculate;
    procedure SetMeasurementValue(const AValue: Double);
    procedure SetCurrencyValue(const AValue: Double);

    /// <summary> Converts the value in AEdit to the base specified in ComboBox by updating the existing
    ///  value in AEdit to a newer one. If ComboBox changed from g to kg, and AEdit used to contain 500
    ///  then the new value in AEdit would then be 0.5
    /// </summary>
    procedure ConvertOldValueToNewValue<T: TMappingBase>(const ComboBox: TComboBox;
      const AEdit: TEdit; const AList: TList<T>; var AOldType: string;
      AExistingValue: Double; UpdateNewValueProc: TUpdateProc);

    ///<summary> Populates the specified ComboBox's Items with the values in AList</summary>
    procedure SetupComboBox<T: class>(const ComboBox: TComboBox;
      const AList: TList<T>);

    property MeasurementValue: Double read GetMeasurementValue write SetMeasurementValue;
    property CurrencyValue: Double read GetCurrencyValue write SetCurrencyValue;
//    property Value3: Double write SetValue3;
  public
    { Public declarations }
    procedure RepopulateLists;
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
//var
//  SValue1: string;
//  LMeasurementUnit: TMeasurementUnit;
//  LOldFound, LNewFound: Boolean;
//  LOldType, LNewType: TConvType;
//  LNewValue: Double;
//  LList: TList<TMeasurementUnit>;
begin
  ConvertOldValueToNewValue<TMeasurementUnit>(cbMeasurement, edMeasurement,
    MeasurementList, FOldMeasurementType, MeasurementValue,
    procedure (ANewValue: Double)
    begin
      MeasurementValue := ANewValue;
    end);

//  if cbMeasurement.Count = 0 then Exit;
//  SValue1 := cbMeasurement.Items[cbMeasurement.ItemIndex];
//
//// The following code converts the old value to the new value, if the measure type is the same
//// For example, 500 g is 0.5kg. So if you have 500 in the edit, and g in the ComboBox,
//// and the user selected kg from the ComboBox, then 500 is converted into 0.5 in the edit.
//  if FOldMeasurementType <> '' then
//    begin
//      LOldType := 0; LNewType := 0;
//      LOldFound := False; LNewFound := False;
//      LList := MeasurementList;
//      for LMeasurementUnit in LList do
//        begin
//          if (LMeasurementUnit.ToString = FOldMeasurementType) and not LOldFound then
//            begin
//              LOldType := LMeasurementUnit.UnitType;
//              LOldFound := True;
//            end;
//          if (LMeasurementUnit.ToString = SValue1) and not LNewFound then // Get the new type
//            begin
//              LNewType := LMeasurementUnit.UnitType;
//              LNewFound := True;
//            end;
//
//          // Ensure that the old type and the new type are compatible types
//          // eg, converting mg and g works, but not mg and L.
//          if LOldFound and LNewFound and CompatibleConversionTypes(LOldType, LNewType) then
//            begin
//              LNewValue := Convert(Value1, LOldType, LNewType);
//              Value1 := LNewValue;
//              Break;
//            end;
//        end;
//    end;
//
//  FOldMeasurementType := SValue1; // Update/Keep track of the old type for comparison
//  Recalculate;
end;

procedure TPriceCompareFrame.ConvertOldValueToNewValue<T>(
  const ComboBox: TComboBox; const AEdit: TEdit; const AList: TList<T>;
  var AOldType: string; AExistingValue: Double; UpdateNewValueProc: TUpdateProc);
var
  SValue1: string;
  LUnit: T;
  LOldType, LNewType: TConvType;
  LOldFound, LNewFound: Boolean;
  LNewValue: Double;
  LList: TList<T>;
begin
  if ComboBox.Count = 0 then Exit;
  SValue1 := ComboBox.Items[ComboBox.ItemIndex];

  if (AOldType <> '') and (AEdit.Text <> '') then
    begin
      LOldType := 0; LNewType := 0;
      LOldFound := False; LNewFound := False;
      LList := AList;
      for LUnit in LList do
        begin
          if LUnit.ToString = AOldType then
            begin
              LOldType := LUnit.UnitType;
              LOldFound := True;
            end;
          if LUnit.ToString = SValue1 then // Get the new type
            begin
              LNewType := LUnit.UnitType;
              LNewFound := True;
            end;
          // Ensure that the old type and the new type are compatible types
          // eg, converting mg and g works, but not mg and L.
          if LOldFound and LNewFound and CompatibleConversionTypes(LOldType, LNewType) then
            begin
              LNewValue := Convert(AExistingValue, LOldType, LNewType);
              UpdateNewValueProc(LNewValue);
              Break;
            end;
        end;
    end;

  AOldType := SValue1; // Update/Keep track of the old type for comparison
  Recalculate;

end;

procedure TPriceCompareFrame.cbCurrencyChange(Sender: TObject);
//var
//  SValue1: string;
//  LCurrencyUnit: TCurrencyUnit;
//  LOldType, LNewType: TConvType;
//  LOldFound, LNewFound: Boolean;
//  LNewValue: Double;
//  LList: TList<TCurrencyUnit>;
begin

  ConvertOldValueToNewValue<TCurrencyUnit>(cbCurrency, edCurrency,
    CurrencyList, FOldCurrencyType, CurrencyValue,
    procedure (ANewValue: Double)
    begin
      CurrencyValue := ANewValue;
    end);

//  if cbCurrency.Count = 0 then Exit;
//  SValue1 := cbCurrency.Items[cbCurrency.ItemIndex];
//
//  if (FOldCurrencyType <> '') and (edCurrency.Text <> '') then
//    begin
//      LOldType := 0; LNewType := 0;
//      LOldFound := False; LNewFound := False;
//      LList := CurrencyList;
//      for LCurrencyUnit in LList do
//        begin
//          if LCurrencyUnit.ToString = FOldCurrencyType then
//            begin
//              LOldType := LCurrencyUnit.UnitType;
//              LOldFound := True;
//            end;
//          if LCurrencyUnit.ToString = SValue1 then // Get the new type
//            begin
//              LNewType := LCurrencyUnit.UnitType;
//              LNewFound := True;
//            end;
//          // Ensure that the old type and the new type are compatible types
//          // eg, converting mg and g works, but not mg and L.
//          if LOldFound and LNewFound and CompatibleConversionTypes(LOldType, LNewType) then
//            begin
//              LNewValue := Convert(Value2, LOldType, LNewType);
//              Value2 := LNewValue;
//              Break;
//            end;
//        end;
//    end;
//
//  FOldCurrencyType := SValue1; // Update/Keep track of the old type for comparison
//  Recalculate;
end;

procedure TPriceCompareFrame.Edit1Change(Sender: TObject);
begin
  Recalculate;
end;

procedure TPriceCompareFrame.Edit2Change(Sender: TObject);
begin
  Recalculate;
end;

function TPriceCompareFrame.GetMeasurementValue: Double;
begin
  Result := StrToFloatDef(edMeasurement.Text, 0.0);
end;

function TPriceCompareFrame.GetCurrencyValue: Double;
begin
  Result := StrToFloatDef(edCurrency.Text, 0.0);
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

  LValue1 := MeasurementValue;
  LValue2 := CurrencyValue;
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

procedure TPriceCompareFrame.SetMeasurementValue(const AValue: Double);
begin
  edMeasurement.Text := FloatToStr(AValue);
end;

procedure TPriceCompareFrame.SetCurrencyValue(const AValue: Double);
begin
  edCurrency.Text := FloatToStr(AValue);
end;

//procedure TPriceCompareFrame.SetValue3(const AValue: Double);
//begin
//  FValue := AValue;
//  Recalculate;
//end;

end.
