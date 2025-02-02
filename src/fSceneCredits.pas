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
/// File last update : 2025-02-02T20:34:38.000+01:00
/// Signature : 204c6832c0c4127c133b61144e56ba0d83da1b65
/// ***************************************************************************
/// </summary>

unit fSceneCredits;

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
  _ScenesAncestor,
  FMX.Effects,
  Olf.FMX.TextImageFrame,
  FMX.Objects,
  FMX.Layouts,
  _ButtonsAncestor,
  cTextButton;

type
  TCreditsScene = class(T__SceneAncestor)
    zFooter: TLayout;
    btnExit: TTextButton;
    VertScrollBox1: TVertScrollBox;
    Text1: TText;
    zHeader: TLayout;
    tiTitle: TOlfFMXTextImageFrame;
    ShadowEffect1: TShadowEffect;
    Rectangle1: TRectangle;
    zContent: TLayout;
    ShadowEffect2: TShadowEffect;
    procedure btnExitClick(Sender: TObject);
    procedure FrameResized(Sender: TObject);
  private
  public
    procedure ShowScene; override;
    procedure HideScene; override;
    procedure TranslateTexts(const Language: string); override;
    procedure AfterConstruction; override;
  end;

implementation

{$R *.fmx}

uses
  udmAdobeStock_101337396,
  uUIElements,
  uConsts,
  uScene,
  System.Messaging,
  uTxtAboutDescription,
  uTxtAboutLicense;

{ TCreditsScene }

procedure TCreditsScene.AfterConstruction;
begin
  inherited;
  Text1.TextSettings.Font.Size := Text1.TextSettings.Font.Size * 2;
end;

procedure TCreditsScene.btnExitClick(Sender: TObject);
begin
  tscene.Current := tscenetype.Home;
end;

procedure TCreditsScene.FrameResized(Sender: TObject);
var
  w: single;
begin
  w := width * 1 / 2;
  if (w < 600) then
    w := 600;
  if (w > width) then
    w := width - 20 * 2;
  zContent.Margins.left := (width - w) / 2;
  zContent.Margins.right := zContent.Margins.left;
end;

procedure TCreditsScene.HideScene;
begin
  inherited;
  TUIItemsList.Current.RemoveLayout;
end;

procedure TCreditsScene.ShowScene;
begin
  inherited;
  TUIItemsList.Current.NewLayout;
  TUIItemsList.Current.AddControl(btnExit, nil, nil, nil, nil, true, true);
  tiTitle.Font := dmAdobeStock_101337396.ImageList;
end;

procedure TCreditsScene.TranslateTexts(const Language: string);
begin
  inherited;
  if Language = 'fr' then
  begin
    tiTitle.Text := 'Fin de partie'.ToUpper;
    btnExit.Text := 'Fermer';
  end
  else
  begin
    tiTitle.Text := 'Game Over'.ToUpper;
    btnExit.Text := 'Close';
  end;

  Text1.Text := GetTxtAboutDescription(Language).trim + sLineBreak + sLineBreak
    + '**********' + sLineBreak + '* License' + sLineBreak + sLineBreak +
    GetTxtAboutLicense(Language).trim + sLineBreak + sLineBreak +
    application.MainForm.Caption + ' ' + CAboutCopyright + sLineBreak;
end;

initialization

TMessageManager.DefaultManager.SubscribeToMessage(TSceneFactory,
  procedure(const Sender: TObject; const Msg: TMessage)
  var
    NewScene: TCreditsScene;
  begin
    if (Msg is TSceneFactory) and
      ((Msg as TSceneFactory).SceneType = tscenetype.Credits) then
    begin
      NewScene := TCreditsScene.Create(application.MainForm);
      NewScene.Parent := application.MainForm;
      tscene.RegisterScene(tscenetype.Credits, NewScene);
    end;
  end);

end.
