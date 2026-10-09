# Mon RPG Godot 4 - VERSION FINALE

## 🎮 Lancer le jeu

1. Ouvrir Godot 4
2. Ouvrir le dossier du projet
3. Appuyer sur Play

## 🎮 Contrôles

- **ZQSD / Flèches** : Déplacement
- **Espace** : Attaquer l'ennemi le plus proche
- **H** : Boire une potion (+50 PV)
- **E** : Interagir avec NPCs et marchands
- **I** : Afficher l'inventaire
- **Esc** : Sauvegarder manuellement
- **R** : Recommencer après la victoire

## 🎯 Gameplay

### Objectif Principal
Vaincre le Dragon Ancien dans la Caverne du Dragon après avoir vaincu 5 créatures.

### Zones
- **Village** : Point de départ, marchand
- **Forêt** : Premiers ennemis (Slimes, Goblins)
- **Grotte** : Ennemis plus forts (Squelettes, Ogres)
- **Caverne du Dragon** : Boss final

### Système de Combat
- Attaque en appuyant sur Espace
- Chaque ennemi a sa propre vie et dégâts
- Les boss font plus de dégâts
- Gagne de l'or et de l'XP en tuant des ennemis

### Système de Progression
- Gagne de l'XP en tuant des ennemis
- Montée de niveau automatique (PV +20, Dégâts +5)
- Chaque niveau augmente le seuil d'XP

### Système de Boutique
- **Potion** : 10 or (+50 PV)
- **Épée** : 25 or (+8 dégâts)
- **Armure** : 40 or (+30 PV max)

### Inventaire
- Potions, Épées, Armures, Herbes magiques, Pierres de pouvoir
- Affichage en temps réel dans le HUD

### Quêtes
- Enquête sur le dragon (tuer 5 créatures)
- Bonus : Affronter le Dragon Ancien

## 🏆 Victoire

Vaincre le Dragon Ancien déclenche l'écran de victoire avec :
- Niveau final
- Or total
- XP total
- Possibilité de recommencer

## 💾 Sauvegarde

- Auto-sauvegarde lors de chaque action importante
- Sauvegarde manuelle avec Esc
- Les données sont stockées dans `user://savegame.json`

## 📊 Statistiques du Joueur

- Niveau actuel
- Points de Vie (PV)
- Or collecté
- Expérience (XP)
- Inventaire complet
- Position dans le monde
- Progression des quêtes

## 🎨 Design

- Graphismes géométriques simples en couleur
- HUD informatif et clair
- Monde divisé en 4 zones principales
- Boss distinctif en rouge foncé

## ⚙️ Architecture

- **Player.gd** : Gestion du joueur, combat, inventaire, quêtes
- **Enemy.gd** : Ennemis standards
- **Boss.gd** : Boss du dragon avec IA agressif
- **World.gd** : Gestion du monde, zones, ennemis, victoire
- **HUD.gd** : Interface utilisateur
- **VictoryScreen.gd** : Écran de victoire
- **QuestSystem.gd** : Système de quêtes
- **SaveSystem.gd** : Système de sauvegarde

## 🎯 Étapes de Jeu Recommandées

1. Parler au Chef du Village
2. Acheter équipement au marchand si nécessaire
3. Tuer des Slimes et Goblins dans la Forêt
4. Progresser vers la Grotte pour les ennemis plus forts
5. Obtenir une quête complète (5 créatures tuées)
6. Se diriger vers la Caverne du Dragon
7. Affronter le Dragon Ancien
8. Victoire!

---

**Amusez-vous bien dans votre aventure! 🗡️⚔️🏆**
