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
/// File last update : 2025-02-02T19:53:10.000+01:00
/// Signature : ad6755e6978009c474a0b1ba023c8881cc1c3c09
/// ***************************************************************************
/// </summary>

unit fSceneGame;

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
  System.Messaging,
  _ScenesAncestor,
  _ButtonsAncestor,
  cTextButton,
  FMX.Layouts,
  Olf.FMX.TextImageFrame,
  FMX.Objects,
  FMX.Effects;

type
  TGameScene = class(T__SceneAncestor)
    GridPanelLayout1: TGridPanelLayout;
    zScore: TLayout;
    zNbLives: TLayout;
    Layout3: TLayout;
    Layout4: TLayout;
    btnPause: TTextButton;
    imgScore: TImage;
    imgNbLives: TImage;
    tiNbLives: TOlfFMXTextImageFrame;
    tiScore: TOlfFMXTextImageFrame;
    UpdateScore: TTimer;
    ShadowEffect1: TShadowEffect;
    ShadowEffect2: TShadowEffect;
    procedure btnPauseClick(Sender: TObject);
    procedure UpdateScoreTimer(Sender: TObject);
  private
    FScore: int64;
    FNbLives: int64;
    procedure SetNbLives(const Value: int64);
    procedure SetScore(const Value: int64);
  protected
    procedure DoNbLivesChanged(const Sender: TObject; const Msg: TMessage);
    procedure FlashRect(const Color: TAlphaColor);
  public
    property Score: int64 read FScore write SetScore;
    property NbLives: int64 read FNbLives write SetNbLives;
    procedure ShowScene; override;
    procedure HideScene; override;
  end;

implementation

{$R *.fmx}

uses
  uUIElements,
  uConsts,
  uScene,
  uGameData,
  udmAdobeStock_101337396,
  uSVGBitmapManager_InputPrompts,
  USVGIconesDuJeu;

{ TGameScene }

procedure TGameScene.btnPauseClick(Sender: TObject);
begin
  // TGameData.DefaultGameData.PauseGame;
  // TScene.Current := TSceneType.Home;
  // TODO : réactiver le HOME/Pause quand on gèrera les mise en pause de parties
  TGameData.DefaultGameData.StopGame;
  TScene.Current := TSceneType.gameover;
end;

procedure TGameScene.DoNbLivesChanged(const Sender: TObject;
  const Msg: TMessage);
begin
  if not assigned(self) then
    exit;

  if assigned(Msg) and (Msg is TNbLivesChangedMessage) then
    NbLives := (Msg as TNbLivesChangedMessage).NbLives;
end;

procedure TGameScene.FlashRect(const Color: TAlphaColor);
var
  r: TRectangle;
begin
  r := TRectangle.Create(self);
  r.parent := self;
  r.Stroke.Kind := TBrushKind.None;
  r.Fill.Color := Color;
  r.Opacity := 0.3;
  r.Align := TAlignLayout.Contents;
  r.HitTest := false;
  tthread.CreateAnonymousThread(
    procedure
    begin
      sleep(100);
      tthread.queue(nil,
        procedure
        begin
          r.free;
        end);
    end).start;
end;

procedure TGameScene.HideScene;
begin
  inherited;
  TUIItemsList.Current.RemoveLayout;
  UpdateScore.Enabled := false;
  TMessageManager.DefaultManager.Unsubscribe(TNbLivesChangedMessage,
    DoNbLivesChanged, true);
end;

procedure TGameScene.SetNbLives(const Value: int64);
begin
  if (FNbLives < Value) then
    FlashRect(talphacolors.green) // TODO : play a "houra" song
  else if (FNbLives > Value) then
    if Value < 1 then
    begin
      TGameData.DefaultGameData.StopGame;
      TScene.Current := TSceneType.gameover;
    end
    else
      FlashRect(talphacolors.red); // TODO : play a "dead" song

  FNbLives := Value;
  tiNbLives.Text := FNbLives.ToString;
  zNbLives.width := imgNbLives.width + imgNbLives.margins.right +
    tiNbLives.width;
end;

procedure TGameScene.SetScore(const Value: int64);
begin
  FScore := Value;
  tiScore.Text := FScore.ToString;
  zScore.width := imgScore.width + imgScore.margins.right + tiScore.width;
end;

procedure TGameScene.ShowScene;
begin
  inherited;
  TUIItemsList.Current.NewLayout;

  imgNbLives.bitmap.Assign(getBitmapFromSVG(TSVGIconesDuJeuIndex.Heart,
    imgNbLives.width, imgNbLives.Height, imgNbLives.bitmap.BitmapScale));
  tiNbLives.Font := dmAdobeStock_101337396.ImageList;
  FNbLives := CDefaultNbLives;
  NbLives := TGameData.DefaultGameData.NbLives;
  TMessageManager.DefaultManager.SubscribeToMessage(TNbLivesChangedMessage,
    DoNbLivesChanged);

  imgScore.bitmap.Assign(getBitmapFromSVG(TSVGIconesDuJeuIndex.Star,
    imgScore.width, imgScore.Height, imgScore.bitmap.BitmapScale));
  tiScore.Font := dmAdobeStock_101337396.ImageList;
  Score := TGameData.DefaultGameData.Score;
  UpdateScore.Enabled := true;

  TUIItemsList.Current.AddControl(btnPause, nil, nil, nil, nil, false, true);
  btnPause.Text := 'Exit'; // TODO : à remplacer par un bouton icone
end;

procedure TGameScene.UpdateScoreTimer(Sender: TObject);
var
  GDScore: int64;
begin
  GDScore := TGameData.DefaultGameData.Score;
  if Score < GDScore then
    Score := Score + 1
  else if Score > GDScore then
    Score := Score - 1;
end;

initialization

TMessageManager.DefaultManager.SubscribeToMessage(TSceneFactory,
  procedure(const Sender: TObject; const Msg: TMessage)
  var
    NewScene: TGameScene;
  begin
    if (Msg is TSceneFactory) and
      ((Msg as TSceneFactory).SceneType = TSceneType.Game) then
    begin
      NewScene := TGameScene.Create(application.mainform);
      NewScene.parent := application.mainform;
      TScene.RegisterScene(TSceneType.Game, NewScene);
    end;
  end);

end.
