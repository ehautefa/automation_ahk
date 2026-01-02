# 🤖 Automation AHK - Système d'Automatisation de Clics

> Capturez vos clics, générez votre automatisation - en 2 étapes simples !

## 📋 Table des Matières

- [Vue d'ensemble](#-vue-densemble)
- [Prérequis](#-prérequis)
- [Installation](#-installation)
- [Guide d'Utilisation](#-guide-dutilisation)

---

## 🎯 Vue d'ensemble

Ce système d'automatisation vous permet de :

1. **Capturer** vos clics de souris et les boutons associés
2. **Générer automatiquement** un script d'automatisation personnalisé
3. **Rejouer** la séquence de clics à volonté

### ✨ Caractéristiques

- ✅ Capture des screenshots de boutons (sans effet hover/clic)
- ✅ Enregistrement précis des délais entre clics
- ✅ Génération automatique de scripts d'automatisation
- ✅ Reconnaissance d'image intelligente (ImageSearch)
- ✅ Compatible DPI-aware (écrans haute résolution)
- ✅ Gestion des effets hover automatique

---

## 💻 Prérequis

### Logiciel Requis

**AutoHotkey v2.0 ou supérieur**

- **Téléchargement :** [https://www.autohotkey.com/](https://www.autohotkey.com/)
- **Version minimale :** v2.0
- **Système d'exploitation :** Windows 7/8/10/11

### Vérifier votre installation

1. Téléchargez et installez AutoHotkey v2.0
2. Cliquez-droit sur un fichier `.ahk` → Vous devriez voir "Run Script"
3. Si vous voyez une erreur de version, désinstallez AutoHotkey v1 et installez v2

---

## 📦 Installation

### Étape 1 : Télécharger le Projet

```bash
# Option 1 : Cloner le dépôt
git clone <votre-repo-url>

# Option 2 : Télécharger le ZIP
# Extraire dans un dossier de votre choix
```

### Étape 2 : Vérifier les Fichiers

Votre dossier doit contenir :

```
automation_ahk/
├── step1_capture_clicks.ahk      ← Script de capture
├── step2_generate_automation.ahk ← Générateur de script
├── automation_template.txt       ← Template principal
├── button_template.txt           ← Template de boutons
└── README.md                     ← Ce fichier
```

### Étape 3 : C'est Prêt ! 🎉

Aucune configuration supplémentaire nécessaire.

---

## 🚀 Guide d'Utilisation

### 📸 ÉTAPE 1 : Capturer vos Boutons

#### Objectif
Enregistrer les positions et apparences des boutons que vous voulez automatiser.

#### Instructions

1. **Lancer le script de capture**
   ```
   Double-cliquez sur : step1_capture_clicks.ahk
   ```

2. **Démarrer l'enregistrement**
   - Un message de bienvenue s'affiche
   - Appuyez sur **F1** pour commencer

3. **Cliquer sur vos boutons**
   - Cliquez sur chaque bouton dans l'ordre souhaité
   - Un bip sonore confirme chaque capture
   - Le tooltip affiche les coordonnées et le timing

4. **Terminer l'enregistrement**
   - Appuyez sur **ESC** quand vous avez terminé
   - Un message de confirmation s'affiche

#### Résultats

Après l'étape 1, vous obtenez :

```
automation_ahk/
├── button_images/
│   ├── button1.png          ← Screenshot du 1er bouton
│   ├── button2.png          ← Screenshot du 2ème bouton
│   └── ...
└── button_timings.json      ← Délais entre clics (ms)
```

#### ⚙️ Raccourcis Clavier

| Touche | Action |
|--------|--------|
| `F1` | Démarrer l'enregistrement |
| `ESC` | Arrêter et sauvegarder |
| `Ctrl+ESC` | Forcer la sortie |

---

### 🔧 ÉTAPE 2 : Générer votre Automatisation

#### Objectif
Créer un script d'automatisation personnalisé à partir de vos captures.

#### Instructions

1. **Lancer le générateur**
   ```
   Double-cliquez sur : step2_generate_automation.ahk
   ```

2. **Configurer votre script**

   **a) Nom du script**
   - Exemple : `MonAutomation`
   - Caractères autorisés : lettres, chiffres, tirets, underscores

   **b) Touche de raccourci**
   - Exemples :
     - `F2` = Touche F2
     - `^j` = Ctrl+J
     - `!a` = Alt+A
     - `^!r` = Ctrl+Alt+R

   **Symboles de modificateurs :**
   - `^` = Ctrl
   - `!` = Alt
   - `+` = Shift
   - `#` = Win

3. **Génération automatique**
   - Le script copie les images dans un nouveau dossier
   - Génère le code d'automatisation
   - Affiche un message de succès

#### Résultats

Un nouveau dossier est créé :

```
automation_ahk/
└── MonAutomation/              ← Nouveau dossier
    ├── MonAutomation.ahk       ← Script d'automatisation
    └── images/
        ├── button1.png
        ├── button2.png
        └── ...
```

---

### ▶️ ÉTAPE 3 : Utiliser votre Automatisation

#### Lancer le Script

1. **Ouvrir le script généré**
   ```
   Double-cliquez sur : MonAutomation/MonAutomation.ahk
   ```

2. **Le script est actif**
   - Un message de confirmation s'affiche
   - Le script tourne en arrière-plan

3. **Déclencher l'automatisation**
   - Appuyez sur votre touche de raccourci (ex: `F2`)
   - Le script cherche et clique automatiquement sur les boutons
   - Des tooltips affichent la progression

4. **Arrêter le script**
   - Appuyez sur `ESC` pour quitter

#### 🎬 Fonctionnement

```
Appui sur F2
    ↓
Déplacer souris au coin (enlever hover)
    ↓
Chercher button1.png sur l'écran
    ↓
Cliquer sur button1
    ↓
Attendre le délai enregistré
    ↓
Chercher button2.png
    ↓
Cliquer sur button2
    ↓
... et ainsi de suite
    ↓
Terminé !
```

**Bon automatisation ! 🚀**
