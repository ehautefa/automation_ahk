; Script d'Automatisation : MACRO_RESET_TEST_JABRA
; Généré automatiquement par step2_generate_automation.ahk
; Touche de raccourci : F12

#Requires AutoHotkey v2.0
#SingleInstance Force
SetWorkingDir(A_ScriptDir)

; Rendre le script DPI-aware
DllCall("SetThreadDpiAwarenessContext", "Ptr", -3, "Ptr")

; Définir le mode de coordonnées
CoordMode("Mouse", "Screen")
CoordMode("Pixel", "Screen")

; Message de démarrage
MsgBox("=== MACRO_RESET_TEST_JABRA ===`n`nScript d'automatisation prêt !`n`nAppuyez sur F12 pour lancer l'automatisation.`nAppuyez sur ESC pour quitter.")

; Touche de raccourci pour lancer l'automatisation
F12:: {
    RunAutomation()
}

; Fonction d'automatisation principale
RunAutomation() {
    ToolTip("Démarrage de l'automatisation...")
    Sleep(500)

    ; Bouton 1
    ; Déplacer la souris au coin pour enlever tout effet hover
    MouseMove(A_ScreenWidth - 10, A_ScreenHeight - 10, 0)
    Sleep(150)

    ToolTip("Recherche du bouton 1...")
    if (ImageSearch(&x, &y, 0, 0, A_ScreenWidth, A_ScreenHeight, "*50 images\button1.png")) {
        MouseMove(x+25, y+12)
        Sleep(100)
        Click()
        ToolTip("Bouton 1 cliqué !")
        Sleep(500)
    } else {
        ToolTip("ERREUR : Bouton 1 introuvable !")
        Sleep(2000)
        return
    }

    ; Bouton 2
    ; Déplacer la souris au coin pour enlever tout effet hover
    MouseMove(A_ScreenWidth - 10, A_ScreenHeight - 10, 0)
    Sleep(150)

    ToolTip("Recherche du bouton 2...")
    if (ImageSearch(&x, &y, 0, 0, A_ScreenWidth, A_ScreenHeight, "*50 images\button2.png")) {
        MouseMove(x+25, y+12)
        Sleep(100)
        Click()
        ToolTip("Bouton 2 cliqué !")
        Sleep(3000)
    } else {
        ToolTip("ERREUR : Bouton 2 introuvable !")
        Sleep(2000)
        return
    }

    ; Bouton 3
    ; Déplacer la souris au coin pour enlever tout effet hover
    MouseMove(A_ScreenWidth - 10, A_ScreenHeight - 10, 0)
    Sleep(150)

    ToolTip("Recherche du bouton 3...")
    if (ImageSearch(&x, &y, 0, 0, A_ScreenWidth, A_ScreenHeight, "*50 images\button3.png")) {
        MouseMove(x+25, y+12)
        Sleep(100)
        Click()
        ToolTip("Bouton 3 cliqué !")
        Sleep(500)
    } else {
        ToolTip("ERREUR : Bouton 3 introuvable !")
        Sleep(2000)
        return
    }

    ; Bouton 4
    ; Déplacer la souris au coin pour enlever tout effet hover
    MouseMove(A_ScreenWidth - 10, A_ScreenHeight - 10, 0)
    Sleep(150)

    ToolTip("Recherche du bouton 4...")
    if (ImageSearch(&x, &y, 0, 0, A_ScreenWidth, A_ScreenHeight, "*50 images\button4.png")) {
        MouseMove(x+25, y+12)
        Sleep(100)
        Click()
        ToolTip("Bouton 4 cliqué !")
        Sleep(500)
    } else {
        ToolTip("ERREUR : Bouton 4 introuvable !")
        Sleep(2000)
        return
    }

    ; Bouton 5
    ; Déplacer la souris au coin pour enlever tout effet hover
    MouseMove(A_ScreenWidth - 10, A_ScreenHeight - 10, 0)
    Sleep(150)

    ToolTip("Recherche du bouton 5...")
    if (ImageSearch(&x, &y, 0, 0, A_ScreenWidth, A_ScreenHeight, "*50 images\button5.png")) {
        MouseMove(x+25, y+12)
        Sleep(100)
        Click()
        ToolTip("Bouton 5 cliqué !")
        Sleep(2000)
    } else {
        ToolTip("ERREUR : Bouton 5 introuvable !")
        Sleep(2000)
        return
    }

    ; Bouton 6
    ; Déplacer la souris au coin pour enlever tout effet hover
    MouseMove(A_ScreenWidth - 10, A_ScreenHeight - 10, 0)
    Sleep(150)

    ToolTip("Recherche du bouton 6...")
    if (ImageSearch(&x, &y, 0, 0, A_ScreenWidth, A_ScreenHeight, "*50 images\button6.png")) {
        MouseMove(x+25, y+12)
        Sleep(100)
        Click()
        ToolTip("Bouton 6 cliqué !")
        Sleep(500)
    } else {
        ToolTip("ERREUR : Bouton 6 introuvable !")
        Sleep(2000)
        return
    }

    ; Bouton 7
    ; Déplacer la souris au coin pour enlever tout effet hover
    MouseMove(A_ScreenWidth - 10, A_ScreenHeight - 10, 0)
    Sleep(150)

    ToolTip("Recherche du bouton 7...")
    if (ImageSearch(&x, &y, 0, 0, A_ScreenWidth, A_ScreenHeight, "*50 images\button7.png")) {
        MouseMove(x+25, y+12)
        Sleep(100)
        Click()
        ToolTip("Bouton 7 cliqué !")
        Sleep(500)
    } else {
        ToolTip("ERREUR : Bouton 7 introuvable !")
        Sleep(2000)
        return
    }

    ; Bouton 8
    ; Déplacer la souris au coin pour enlever tout effet hover
    MouseMove(A_ScreenWidth - 10, A_ScreenHeight - 10, 0)
    Sleep(150)

    ToolTip("Recherche du bouton 8...")
    if (ImageSearch(&x, &y, 0, 0, A_ScreenWidth, A_ScreenHeight, "*50 images\button8.png")) {
        MouseMove(x+25, y+12)
        Sleep(100)
        Click()
        ToolTip("Bouton 8 cliqué !")
        Sleep(500)
    } else {
        ToolTip("ERREUR : Bouton 8 introuvable !")
        Sleep(2000)
        return
    }

    ; Bouton 9
    ; Déplacer la souris au coin pour enlever tout effet hover
    MouseMove(A_ScreenWidth - 10, A_ScreenHeight - 10, 0)
    Sleep(150)

    ToolTip("Recherche du bouton 9...")
    if (ImageSearch(&x, &y, 0, 0, A_ScreenWidth, A_ScreenHeight, "*50 images\button9.png")) {
        MouseMove(x+25, y+12)
        Sleep(100)
        Click()
        ToolTip("Bouton 9 cliqué !")
        Sleep(500)
    } else {
        ToolTip("ERREUR : Bouton 9 introuvable !")
        Sleep(2000)
        return
    }

    ; Bouton 10
    ; Déplacer la souris au coin pour enlever tout effet hover
    MouseMove(A_ScreenWidth - 10, A_ScreenHeight - 10, 0)
    Sleep(150)

    ToolTip("Recherche du bouton 10...")
    if (ImageSearch(&x, &y, 0, 0, A_ScreenWidth, A_ScreenHeight, "*50 images\button10.png")) {
        MouseMove(x+25, y+12)
        Sleep(100)
        Click()
        ToolTip("Bouton 10 cliqué !")
        Sleep(500)
    } else {
        ToolTip("ERREUR : Bouton 10 introuvable !")
        Sleep(2000)
        return
    }


    ToolTip("Automatisation terminée !")
    Sleep(2000)
    ToolTip()
}

; ESC pour quitter
Esc::ExitApp()
