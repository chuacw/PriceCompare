unit PriceCompare.MainForm;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.StdCtrls, FMX.Controls.Presentation,
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
  DebugUtils.Log, PriceCompare.ComparisonFrame;

{$R *.fmx}
{$R *.LgXhdpiPh.fmx ANDROID}
{$R *.NmXhdpiPh.fmx ANDROID}

procedure TfrmPriceCompare.acAddExecute(Sender: TObject);
var
  LFrame: TPriceCompareFrame; // SysInit
begin
  LFrame := TPriceCompareFrame.Create(Self);

// Update the name so that multiple frames can exist on the same form
  LFrame.Name := LFrame.Name + IntToStr(FNamedInstance);
  Inc(FNamedInstance);

  LFrame.RepopulateLists;

  panelMain.AddObject(LFrame);

  LFrame.edMeasurement.SetFocus;
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
