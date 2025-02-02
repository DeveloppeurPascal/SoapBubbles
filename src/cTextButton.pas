unit cTextButton;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  FMX.Types,
  FMX.Graphics,
  FMX.Controls,
  FMX.Forms,
  FMX.Dialogs,
  FMX.StdCtrls,
  _ButtonsAncestor,
  FMX.Objects,
  FMX.Effects;

type
  TTextButton = class(T__ButtonAncestor)
    rFocused: TRectangle;
    rDown: TRectangle;
    rUp: TRectangle;
    Text1: TText;
  private
  protected
  public
    procedure Repaint; override;
    procedure AfterConstruction; override;
  end;

implementation

{$R *.fmx}

procedure TTextButton.AfterConstruction;
begin
  inherited;
  Text1.TextSettings.Font.Size := Text1.TextSettings.Font.Size * 2;
end;

procedure TTextButton.Repaint;
begin
  rFocused.Visible := IsFocused;
  rDown.Visible := IsDown;
  rUp.Visible := IsUp;
  Text1.Text := Text;
end;

end.
