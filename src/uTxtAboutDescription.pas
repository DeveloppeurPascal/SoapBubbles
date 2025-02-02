﻿/// <summary>
/// ***************************************************************************
///
/// Gamolf FMX Game Template
///
/// Copyright 2024 Patrick Prémartin under AGPL 3.0 license.
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
/// The "Gamolf FMX Game Template" is both a "technical" example of a video
/// game developed in Delphi with everything you need inside, and a reusable
/// project template you can customize for your own games.
///
/// The files provided are fully functional. Numerous comments are included in
/// the sources to explain how they work and what you need to copy, override
/// or customize to make video games without starting from scratch.
///
/// ***************************************************************************
///
/// Author(s) :
/// Patrick PREMARTIN
///
/// Site :
/// https://gametemplate.developpeur-pascal.fr/
///
/// Project site :
/// https://github.com/DeveloppeurPascal/Gamolf-FMX-Game-Template
///
/// ***************************************************************************
/// File last update : 2024-08-09T20:35:58.000+02:00
/// Signature : b224ad6ad4baa80432a9dcbd2ed65ee1dc267399
/// ***************************************************************************
/// </summary>

unit uTxtAboutDescription;

interface

function GetTxtAboutDescription(const Language: string;
  const Recursif: boolean = false): string;

implementation

// For the languages codes, please use 2 letters ISO codes
// https://en.wikipedia.org/wiki/List_of_ISO_3166_country_codes

uses
  System.SysUtils,
  uConsts;

const
  CTxtEN = '''
A game with bubbles to explode before they explode on their own on the screen.

The bubbles grow by joining with the ones they touch until they explode. You have to get rid of them first. The score is calculated according to the size of the bubbles destroyed.

The game can be played with a mouse and finger or stylus on a touch-sensitive device.

*****************
* Credits

This application was developed by Patrick Prémartin in Delphi.

The images (sprites, icones and UI) are licensed by Adobe Stock.

The game has been developed in Delphi. It's based on Gamolf FMX Game Starter Kit and Delphi Game Engine to handle the classic functionalities (music, sounds, parameters, scores, screen sequencing and user interface interactivity).

*****************
* Publisher info

This video game is published by OLF SOFTWARE, a company registered in Paris (France) under the reference 439521725.

****************
* Personal data

This program is autonomous in its current version. It does not depend on the Internet and communicates nothing to the outside world.

We have no knowledge of what you do with it.

No information about you is transmitted to us or to any third party.

We use no cookies, no tracking, no stats on your use of the application.

***************
* User support

If you have any questions or require additional functionality, please leave us a message on the application's website or on its code repository.

To find out more, visit https://soapbubbles.gamolf.fr

''';
   CTxtFR = '''
Un jeu avec des bulles à exploser avant qu'elles n'explosent toutes seules à l'écran.

Les bulles grossissent en s'assemblant à celles qu'elles touchent jusqu'à exploser. On doit s'en débarrasser avant. Le score est calculé en fonction de la taille des bulles détruites.

On peut y jouer à la souris et au doigt ou stylet sur un appareil tactile.

*****************
* Remerciements

Cette application a été développée par Patrick Prémartin en Delphi.

Les images (sprites, icones et éléments d'interface) sont sous licence Adobe Stock.

Ce jeu est développé sous Delphi. Il est basé sur Gamolf FMX Game Starter Kit et Delphi Game Engine pour gérer les fonctionnalités classiques (musiques, sons, paramétres, scores, enchaînement des écrans et interctions avec l'interface utilisateur).

*****************
* Info éditeur

Ce jeu vidéo est éditée par OLF SOFTWARE, société enregistrée à Paris (France) sous la référence 439521725.

****************
* Données personnelles

Ce programme est autonome dans sa version actuelle. Il ne dépend pas d'Internet et ne communique rien au monde extérieur.

Nous n'avons aucune connaissance de ce que vous faites avec lui.

Aucune information vous concernant n'est transmise à nous ou à des tiers.

Nous n'utilisons pas de cookies, pas de tracking, pas de statistiques sur votre utilisation de l'application.

***************
* Assistance aux utilisateurs

Si vous avez des questions ou si vous avez besoin de fonctionnalités supplémentaires, veuillez nous laisser un message sur le site web de l'application ou sur son dépôt de code.

Pour en savoir plus, visitez https://soapbubbles.gamolf.fr

''';
  // CTxtIT = '';
  // CTxtDE = '';
  // CTxtJP = '';
  // CTxtPT = '';
  // CTxtES = '';

function GetTxtAboutDescription(const Language: string;
  const Recursif: boolean): string;
var
  lng: string;
begin
  lng := Language.tolower;
  if (lng = 'en') then
    result := CTxtEN
  else if (lng = 'fr') then // France
    result := CTxtFR
  else if not Recursif then
    result := GetTxtAboutDescription(CDefaultLanguage, true)
  else
    raise Exception.Create('Unknow description for language "' +
      Language + '".');
end;

end.
