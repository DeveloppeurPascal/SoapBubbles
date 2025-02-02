# 20250202 - [DeveloppeurPascal](https://github.com/DeveloppeurPascal)

* création du dépôt
* référencement sur les packs "tous pojets" et "jeux en Delphi"
* ajout du mirroir sur le NAS pour backup
* ajout des dépendances liées à Gamolf FMX Game Starter Kit
* mise à jour des docs fr/en
* suppression des fichiers et dossiers inutiles provenant du template de projets Delphi
* regénération des icones et autres images à partir d'elle via Pic Mob Generator
* création du projet SoapBubbles dans ce dépôt (et mise à jour de son GUID)
* mise à jour des chemins vers les icônes en RELEASE par modification du code source du DPROJ
* mise en place du dossier _PRIVATE à partir de celui du start Kit
* ajout des clés privées générées par XOR Keys Generator pour les sauvegardes de la configuration du jeu en RELEASE et des parties
* mise à jour des informations d'approvisionnement et de signature du projet (génération d'un nouveau magasin de clés pour Android)
* mise à jour des chemins vers les sous-modules ("\Gamolf-FMX-Game-Starter-Kit\lib-externes" devient "")
* mise à jour de la configuration du jeu (personnalisation des contantes du starter kit)
* mise à jour des textes de la licence et de la description du jeu
* mise à jour de l'icone du projet pour la boite de dialogue "à propos"
* transfert de la base des sprites depuis la v1 (uSpriteCircle.pas)
* transfert des sprites "bulles" depuis la v1 (uSpriteBubble.pas)
* mise en place de l'animation des bulles dans l'écran de background
* adaptation des paramètres de Skia4Delphi pour avoir de bons temps de réponse
* création d'un bouton pour les menus et boites de dialogue
* choix d'une fonte graphique pour le titre et les chiffres, puis export de la liste d'image avec uniquement les lettres utiles dans le projet
* création de l'écran d'accueil avec titre et boutons de menu
* création de l'écran de jeu
* récupération d'icones pour afficher score et nombre de vie avec un logo plutôt qu'un texte
* modification de la prise en charge du clic au niveau des bulles (MouseDown au lieu de Click)
* création de l'écran de game over
* création de l'écran des crédits du jeu
* finalisation de cette version 2.0 et soumission à Apple, Google, Amazon et Microsoft + mise à jour sur Itch
