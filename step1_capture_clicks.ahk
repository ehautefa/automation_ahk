; ÉTAPE 1 : Capture d'Écran au Clic - VERSION SIMPLIFIÉE
; Ce script capture une capture d'écran à chaque fois que vous cliquez
; Utilisez ceci UNE SEULE FOIS pour capturer tous vos boutons
;
; COMMENT L'UTILISER :
; 1. Lancez ce script
; 2. Appuyez sur F1 pour DÉMARRER l'enregistrement
; 3. Cliquez sur chaque bouton que vous voulez automatiser (un par un)
; 4. Appuyez sur ESC pour ARRÊTER l'enregistrement
; 5. Les captures d'écran sont sauvegardées et prêtes pour le script d'automatisation !

#SingleInstance Force
SetWorkingDir %A_ScriptDir%
FileCreateDir, button_images

; Variables
isRecording := false
clickCount := 0

; Appuyez sur F1 pour démarrer l'enregistrement
F1::
    global isRecording, clickCount
    
    if (isRecording) {
        MsgBox, Déjà en cours d'enregistrement ! Appuyez sur ESC pour arrêter.
        return
    }
    
    isRecording := true
    clickCount := 0
    
    MsgBox, 4, Démarrer l'enregistrement ?, 
    (
    MODE D'ENREGISTREMENT DES CLICS
    
    Le script va maintenant :
    1. Capturer une capture d'écran après chaque clic que vous faites
    2. Sauvegarder la position du bouton
    3. Sauvegarder la capture d'écran comme button1.png, button2.png, etc.
    
    Cliquez OUI pour commencer l'enregistrement.
    Ensuite cliquez sur chaque bouton que vous voulez automatiser.
    Appuyez sur ESC quand vous avez terminé.
    )
    
    IfMsgBox No
    {
        isRecording := false
        return
    }
    
    ToolTip, [ENREGISTREMENT] - Cliquez sur vos boutons - ESC pour arrêter
    
    ; Activer la surveillance des clics
    Hotkey, ~LButton, OnLeftClick, On
return

; Ceci se déclenche quand vous cliquez gauche n'importe où
OnLeftClick:
    global isRecording, clickCount
    
    if (!isRecording)
        return
    
    ; Attendre que le clic se termine
    Sleep, 100
    
    ; Obtenir la position du clic
    MouseGetPos, mouseX, mouseY
    
    ; Incrémenter le compteur
    clickCount++
    
    ; Afficher le retour
    ToolTip, Capturé bouton %clickCount% à (%mouseX%, %mouseY%)
    SoundBeep, 1000, 100
    
    ; Attendre un moment
    Sleep, 500
    
    ; Sauvegarder la position dans le fichier
    IniWrite, %mouseX%, button_positions.ini, Positions, Button%clickCount%_X
    IniWrite, %mouseY%, button_positions.ini, Positions, Button%clickCount%_Y
    
    ; Mettre à jour le tooltip
    ToolTip, [ENREGISTREMENT] - Bouton %clickCount% sauvegardé - ESC pour arrêter
return

; Appuyez sur ESC pour arrêter l'enregistrement
Esc::
    global isRecording, clickCount
    
    if (!isRecording) {
        ExitApp
        return
    }
    
    isRecording := false
    
    ; Désactiver la surveillance des clics
    Hotkey, ~LButton, OnLeftClick, Off
    
    ToolTip
    
    MsgBox, 
    (
    === ENREGISTREMENT TERMINÉ ===
    
    Capturé %clickCount% bouton(s).
    
    Fichiers sauvegardés :
    - button_positions.ini (coordonnées des boutons)
    
    Prochaine étape :
    Lancez le script d'AUTOMATISATION pour cliquer automatiquement sur ces boutons !
    
    Appuyez sur OK pour quitter.
    )
    
    ExitApp
return

; Ctrl+Esc pour forcer la sortie
^Esc::ExitApp

; Message de démarrage
MsgBox, 
(
=== SCRIPT DE CAPTURE DE BOUTONS ===

Ce script capturera les positions quand vous cliquez.

INSTRUCTIONS :
1. Appuyez sur F1 pour DÉMARRER l'enregistrement
2. Cliquez sur chaque bouton que vous voulez automatiser
3. Après chaque clic, la position est sauvegardée
4. Appuyez sur ESC quand vous avez terminé

Prêt ? Appuyez sur F1 pour commencer !
)

