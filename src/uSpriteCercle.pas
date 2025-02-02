unit uSpriteCercle;

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
  FMX.Objects,
  System.Generics.Collections;

type
  TSpriteCercle = class;
  TSpriteEvent = procedure(Sender: TSpriteCercle) of object;
  TSpriteDuoEvent = procedure(Sender, Other: TSpriteCercle) of object;
{$SCOPEDENUMS ON}
  TSpriteTypeRebond = (Interieur, Exterieur);
  TSpriteTypeCollision = (Multiple, Unique);

  TSpriteCercle = class(TFrame)
    Circle1: TCircle;
    procedure FrameResize(Sender: TObject);
    procedure Circle1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
  private
    FonSpriteClic: TSpriteEvent;
    FonSpriteCollision: TSpriteEvent;
    Fvx: integer;
    Fvy: integer;
    FTypeRebond: TSpriteTypeRebond;
    FonSpriteRebond: TSpriteEvent;
    FonSpritesCollision: TSpriteDuoEvent;
    FTypeCollision: TSpriteTypeCollision;
    procedure SetonSpriteClic(const Value: TSpriteEvent);
    procedure SetonSpriteCollision(const Value: TSpriteEvent);
    procedure Setvx(const Value: integer);
    procedure Setvy(const Value: integer);
    procedure SetTypeRebond(const Value: TSpriteTypeRebond);
    function GetCentreDuCercle: TPointF;
    function GetRayon: single;
    procedure SetonSpriteRebond(const Value: TSpriteEvent);
    procedure SetonSpritesCollision(const Value: TSpriteDuoEvent);
    procedure SetTypeCollision(const Value: TSpriteTypeCollision);
  protected
    FCollisionDejaTraitee: boolean;
    procedure DoSpriteCollision;
    function getZoneDAffichageHeight: single;
    function getZoneDAffichageWidth: single;
  public
    constructor Create(AOwner: TComponent); override;
    property CollisionDejaTraitee: boolean read FCollisionDejaTraitee;
    property onSpriteClic: TSpriteEvent read FonSpriteClic
      write SetonSpriteClic;
    property onSpriteCollision: TSpriteEvent read FonSpriteCollision
      write SetonSpriteCollision;
    property onSpritesCollision: TSpriteDuoEvent read FonSpritesCollision
      write SetonSpritesCollision;
    property onSpriteRebond: TSpriteEvent read FonSpriteRebond
      write SetonSpriteRebond;
    property vx: integer read Fvx write Setvx;
    property vy: integer read Fvy write Setvy;
    property Rayon: single read GetRayon;
    property CentreDuCercle: TPointF read GetCentreDuCercle;
    property TypeRebond: TSpriteTypeRebond read FTypeRebond write SetTypeRebond;
    property TypeCollision: TSpriteTypeCollision read FTypeCollision
      write SetTypeCollision;
    procedure Bouge; virtual;
    procedure InverseDirection;
    function CheckCollisionCercle(Cercle: TSpriteCercle): boolean; virtual;
  end;

  TSpriteCercleList = TObjectList<TSpriteCercle>;

implementation

{$R *.fmx}

procedure TSpriteCercle.Bouge;
var
  CollisionDetectee: boolean;
  RebondDetecte: boolean;
begin
  position.Point := pointf(position.x + vx, position.y + vy);

  // test sortie écran
  RebondDetecte := false;
  if (TypeRebond = TSpriteTypeRebond.Exterieur) then
  begin
    if (position.x > getZoneDAffichageWidth) or (position.x + width < 0) then
    begin
      vx := -vx;
      RebondDetecte := false;
    end;
    if (position.y > getZoneDAffichageHeight) or (position.y + height < 0) then
    begin
      vy := -vy;
      RebondDetecte := false;
    end;
  end
  else
  begin
    if (position.x + width > getZoneDAffichageWidth) or (position.x < 0) then
    begin
      vx := -vx;
      RebondDetecte := false;
    end;
    if (position.y + height > getZoneDAffichageHeight) or (position.y < 0) then
    begin
      vy := -vy;
      RebondDetecte := false;
    end;
  end;
  if RebondDetecte and assigned(onSpriteRebond) then
    onSpriteRebond(self);

  // test collision
  CollisionDetectee := false;
  for var e in parent.Children do
    if (e is TSpriteCercle) and (e <> self) and
      ((TypeCollision <> TSpriteTypeCollision.Unique) or
      (not(e as TSpriteCercle).CollisionDejaTraitee)) and
      CheckCollisionCercle(e as TSpriteCercle) then
    begin
      if assigned(onSpritesCollision) then
        onSpritesCollision(self, (e as TSpriteCercle));
      if not CollisionDetectee then
      begin
        DoSpriteCollision;
        CollisionDetectee := true;
      end;
      (e as TSpriteCercle).DoSpriteCollision;
      if (TypeCollision = TSpriteTypeCollision.Unique) then
        break;
    end;
end;

function TSpriteCercle.CheckCollisionCercle(Cercle: TSpriteCercle): boolean;
var
  ab, ac, bc: single;
begin
  ab := abs(CentreDuCercle.x - Cercle.CentreDuCercle.x);
  ac := abs(CentreDuCercle.y - Cercle.CentreDuCercle.y);
  bc := sqrt(sqr(ab) + sqr(ac));
  result := bc <= (Rayon + Cercle.Rayon);
end;

procedure TSpriteCercle.Circle1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
  if assigned(onSpriteClic) then
    onSpriteClic(self);
end;

constructor TSpriteCercle.Create(AOwner: TComponent);
begin
  inherited;
  name := '';
  FCollisionDejaTraitee := false;
  vx := 0;
  vy := 0;
  TypeRebond := TSpriteTypeRebond.Interieur;
  TypeCollision := TSpriteTypeCollision.Multiple;
end;

procedure TSpriteCercle.DoSpriteCollision;
begin
  if CollisionDejaTraitee then
    exit;
  FCollisionDejaTraitee := true;
  if assigned(onSpriteCollision) then
    onSpriteCollision(self);
end;

procedure TSpriteCercle.FrameResize(Sender: TObject);
begin
  if width <> height then
    height := width;
end;

function TSpriteCercle.GetCentreDuCercle: TPointF;
begin
  result.x := position.x + Rayon;
  result.y := position.y + Rayon;
end;

function TSpriteCercle.GetRayon: single;
begin
  result := width / 2; // ou height/2 (car cercle)
end;

function TSpriteCercle.getZoneDAffichageHeight: single;
begin
  if assigned(parent) and (parent is tcontrol) then
    result := (parent as tcontrol).height
  else if assigned(parent) and (parent is tcommoncustomform) then
    result := (parent as tcommoncustomform).clientheight
  else
    result := height;
end;

function TSpriteCercle.getZoneDAffichageWidth: single;
begin
  if assigned(parent) and (parent is tcontrol) then
    result := (parent as tcontrol).width
  else if assigned(parent) and (parent is tcommoncustomform) then
    result := (parent as tcommoncustomform).clientwidth
  else
    result := width;
end;

procedure TSpriteCercle.InverseDirection;
begin
  vx := -vx;
  vy := -vy;
end;

procedure TSpriteCercle.SetonSpriteClic(const Value: TSpriteEvent);
begin
  FonSpriteClic := Value;
end;

procedure TSpriteCercle.SetonSpriteCollision(const Value: TSpriteEvent);
begin
  FonSpriteCollision := Value;
end;

procedure TSpriteCercle.SetonSpriteRebond(const Value: TSpriteEvent);
begin
  FonSpriteRebond := Value;
end;

procedure TSpriteCercle.SetonSpritesCollision(const Value: TSpriteDuoEvent);
begin
  FonSpritesCollision := Value;
end;

procedure TSpriteCercle.SetTypeCollision(const Value: TSpriteTypeCollision);
begin
  FTypeCollision := Value;
end;

procedure TSpriteCercle.SetTypeRebond(const Value: TSpriteTypeRebond);
begin
  FTypeRebond := Value;
end;

procedure TSpriteCercle.Setvx(const Value: integer);
begin
  Fvx := Value;
end;

procedure TSpriteCercle.Setvy(const Value: integer);
begin
  Fvy := Value;
end;

end.
