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
/// File last update : 2025-02-02T19:29:02.000+01:00
/// Signature : 9a79a17db335ed22abbf2d6112ad7d759891fab7
/// ***************************************************************************
/// </summary>

unit fSceneHome;

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
  Olf.FMX.TextImageFrame,
  FMX.Layouts,
  _ButtonsAncestor,
  cTextButton,
  FMX.Effects;

type
  THomeScene = class(T__SceneAncestor)
    zTitle: TLayout;
    tiTitle: TOlfFMXTextImageFrame;
    VertScrollBox1: TVertScrollBox;
    btnPlay: TTextButton;
    btnQuit: TTextButton;
    btnCredits: TTextButton;
    btnHallOfFame: TTextButton;
    btnOptions: TTextButton;
    btnContinue: TTextButton;
    ShadowEffect1: TShadowEffect;
    procedure FrameResized(Sender: TObject);
    procedure btnContinueClick(Sender: TObject);
    procedure btnPlayClick(Sender: TObject);
    procedure btnCreditsClick(Sender: TObject);
    procedure btnHallOfFameClick(Sender: TObject);
    procedure btnOptionsClick(Sender: TObject);
    procedure btnQuitClick(Sender: TObject);
  private
  public
    procedure ShowScene; override;
    procedure HideScene; override;
    procedure TranslateTexts(const Language: string); override;
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

procedure THomeScene.btnContinueClick(Sender: TObject);
begin
  TGameData.DefaultGameData.ContinueGame;
  TScene.Current := tscenetype.Game;
end;

procedure THomeScene.btnCreditsClick(Sender: TObject);
begin
  TScene.Current := tscenetype.Credits;
end;

procedure THomeScene.btnHallOfFameClick(Sender: TObject);
begin
  TScene.Current := tscenetype.HallOfFame;
end;

procedure THomeScene.btnOptionsClick(Sender: TObject);
begin
  TScene.Current := tscenetype.Options;
end;

procedure THomeScene.btnPlayClick(Sender: TObject);
begin
  TGameData.DefaultGameData.StartANewGame;
  TScene.Current := tscenetype.Game;
end;

procedure THomeScene.btnQuitClick(Sender: TObject);
begin
  TScene.Current := tscenetype.Exit;
end;

procedure THomeScene.FrameResized(Sender: TObject);
begin
  // TODO : calculer hauteur du conteneur des boutons et s'assurer qu'il ne déborde pas de l'écran
end;

procedure THomeScene.HideScene;
begin
  inherited;
  TUIItemsList.Current.RemoveLayout;
end;

procedure THomeScene.ShowScene;
begin
  inherited;
  tiTitle.Font := dmAdobeStock_101337396.ImageList;
  tiTitle.Text := CAboutGameTitle.ToUpper;

  TUIItemsList.Current.NewLayout;
  TUIItemsList.Current.AddControl(btnPlay, nil, nil, btnCredits, nil, true);
  btnContinue.Visible := false;
  btnOptions.Visible := false;
  btnHallOfFame.Visible := false;
{$IF Defined(IOS) or Defined(ANDROID)}
  TUIItemsList.Current.AddControl(btnCredits, btnPlay, nil, nil, nil);
  btnQuit.Visible := false;
{$ELSE}
  TUIItemsList.Current.AddControl(btnCredits, btnPlay, nil, btnQuit, nil);
  TUIItemsList.Current.AddControl(btnQuit, btnCredits, nil, nil, nil,
    false, true);
{$ENDIF}
  // TODO : recalculer hauteur du conteneur des boutons et véifier qu'il ne déborde pas de l'écran
end;

procedure THomeScene.TranslateTexts(const Language: string);
begin
  inherited;
  if Language = 'fr' then
  begin
    btnPlay.Text := 'Jouer';
    btnContinue.Text := 'Reprendre';
    btnOptions.Text := 'Options';
    btnHallOfFame.Text := 'Scores';
    btnCredits.Text := 'Crédits';
    btnQuit.Text := 'Quitter';
  end
  else
  begin
    btnPlay.Text := 'Play';
    btnContinue.Text := 'Continue';
    btnOptions.Text := 'Options';
    btnHallOfFame.Text := 'Scores';
    btnCredits.Text := 'Credits';
    btnQuit.Text := 'Quit';
  end;
end;

initialization

TMessageManager.DefaultManager.SubscribeToMessage(TSceneFactory,
  procedure(const Sender: TObject; const Msg: TMessage)
  var
    NewScene: THomeScene;
  begin
    if (Msg is TSceneFactory) and
      ((Msg as TSceneFactory).SceneType = tscenetype.Home) then
    begin
      NewScene := THomeScene.Create(application.mainform);
      NewScene.Parent := application.mainform;
      TScene.RegisterScene(tscenetype.Home, NewScene);
    end;
  end);

end.
