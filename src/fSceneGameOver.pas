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
/// File last update : 2025-02-02T20:34:42.000+01:00
/// Signature : d4b2b88e0a505048ebba5869389aa786b44c45ce
/// ***************************************************************************
/// </summary>

unit fSceneGameOver;

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
  FMX.Layouts,
  _ButtonsAncestor,
  cTextButton,
  FMX.Objects;

type
  TGameOverScene = class(T__SceneAncestor)
    zHeader: TLayout;
    tiTitle: TOlfFMXTextImageFrame;
    ShadowEffect1: TShadowEffect;
    zFooter: TLayout;
    btnExit: TTextButton;
    zContent: TLayout;
    Rectangle1: TRectangle;
    VertScrollBox1: TVertScrollBox;
    Text1: TText;
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
  uGameData;

{ TGameOverScene }

procedure TGameOverScene.AfterConstruction;
begin
  inherited;
  Text1.TextSettings.Font.Size := Text1.TextSettings.Font.Size * 2;
end;

procedure TGameOverScene.btnExitClick(Sender: TObject);
begin
  tscene.Current := tscenetype.Home;
end;

procedure TGameOverScene.FrameResized(Sender: TObject);
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

procedure TGameOverScene.HideScene;
begin
  inherited;
  TUIItemsList.Current.RemoveLayout;
end;

procedure TGameOverScene.ShowScene;
begin
  inherited;
  TUIItemsList.Current.NewLayout;
  TUIItemsList.Current.AddControl(btnExit, nil, nil, nil, nil, true, true);
  tiTitle.Font := dmAdobeStock_101337396.ImageList;
end;

procedure TGameOverScene.TranslateTexts(const Language: string);
begin
  inherited;

  if Language = 'fr' then
  begin
    tiTitle.Text := 'Fin de partie'.ToUpper;
    if (TGameData.DefaultGameData.Score > 1) then
      Text1.Text := 'Vous finissez cette partie avec un score de ' +
        TGameData.DefaultGameData.Score.ToString + ' points.'
    else
      Text1.Text := 'Vous finissez cette partie avec un score de ' +
        TGameData.DefaultGameData.Score.ToString + ' point.';
    btnExit.Text := 'Fermer';
  end
  else
  begin
    tiTitle.Text := 'Game Over'.ToUpper;
    if (TGameData.DefaultGameData.Score > 1) then
      Text1.Text := 'You finish this game with a score of ' +
        TGameData.DefaultGameData.Score.ToString + ' points.'
    else
      Text1.Text := 'You finish this game with a score of ' +
        TGameData.DefaultGameData.Score.ToString + ' point.';
    btnExit.Text := 'Close';
  end;
end;

initialization

TMessageManager.DefaultManager.SubscribeToMessage(TSceneFactory,
  procedure(const Sender: TObject; const Msg: TMessage)
  var
    NewScene: TGameOverScene;
  begin
    if (Msg is TSceneFactory) and
      ((Msg as TSceneFactory).SceneType = tscenetype.GameOver) then
    begin
      NewScene := TGameOverScene.Create(application.mainform);
      NewScene.Parent := application.mainform;
      tscene.RegisterScene(tscenetype.GameOver, NewScene);
    end;
  end);

end.
