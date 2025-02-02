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
