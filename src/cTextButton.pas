/// <summary>
/// ***************************************************************************
///
/// Soap Bubbles
///
/// Copyright 2021-2025 Patrick Prémartin under AGPL 3.0 license.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
/// THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
/// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
/// DEALINGS IN THE SOFTWARE.
///
/// ***************************************************************************
///
/// A game with bubbles to explode before they explode on their own on the
/// screen.
///
/// ***************************************************************************
///
/// Author(s) :
/// Patrick PREMARTIN
///
/// Site :
/// https://soapbubbles.gamolf.fr/
///
/// Project site :
/// https://github.com/DeveloppeurPascal/SoapBubbles
///
/// ***************************************************************************
/// File last update : 2025-02-02T17:59:22.000+01:00
/// Signature : b4427f5e838c7a27705228e1151e73223f68a495
/// ***************************************************************************
/// </summary>

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
