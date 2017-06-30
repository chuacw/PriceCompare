unit PriceCompare.MainForm;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  PriceCompare.ComparisonFrame, FMX.StdCtrls, FMX.Controls.Presentation,
  System.Actions, FMX.ActnList;

type
  TfrmPriceCompare = class(TForm)
    Panel1: TPanel;
    btnPlus: TButton;
    panelMain: TPanel;
    ActionList1: TActionList;
    acAdd: TAction;
    procedure btnPlusClick(Sender: TObject);
    procedure acAddExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FNamedInstance: Integer;
  public
    { Public declarations }
  end;

var
  frmPriceCompare: TfrmPriceCompare;

implementation
uses
  DebugUtils.Log;

{$R *.fmx}
{$R *.LgXhdpiPh.fmx ANDROID}
{$R *.NmXhdpiPh.fmx ANDROID}

procedure TfrmPriceCompare.acAddExecute(Sender: TObject);
var
  LFrame: TPriceCompareFrame; // SysInit
begin
  LFrame := TPriceCompareFrame.Create(Self);

  LFrame.Name := LFrame.Name + IntToStr(FNamedInstance);
//  LFrame.cbMeasurement.OnChange := LFrame.cbMeasurementChange;
//  LFrame.cbCurrency.OnChange := LFrame.cbCurrencyChange;
//  LFrame.Edit1.OnChangeTracking := LFrame.Edit1Change;
//  LFrame.Edit2.OnChangeTracking := LFrame.Edit2Change;
  LFrame.Edit1.KeyboardType := TVirtualKeyboardType.DecimalNumberPad;
  LFrame.Edit2.KeyboardType := TVirtualKeyboardType.DecimalNumberPad;

  LFrame.RepopulateLists;

  Inc(FNamedInstance);
  panelMain.AddObject(LFrame);

  LFrame.Edit1.SetFocus;
end;

procedure TfrmPriceCompare.btnPlusClick(Sender: TObject);
begin
  acAdd.Execute;
end;

procedure TfrmPriceCompare.FormCreate(Sender: TObject);
begin
  acAdd.Execute;
end;

end.
