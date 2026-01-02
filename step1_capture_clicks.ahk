; ÉTAPE 1 : Capture d'Écran au Clic - VERSION AUTOHOTKEY V2
; Ce script capture une capture d'écran à chaque fois que vous cliquez
; Utilisez ceci UNE SEULE FOIS pour capturer tous vos boutons
;
; COMMENT L'UTILISER :
; 1. Lancez ce script
; 2. Appuyez sur F1 pour DÉMARRER l'enregistrement
; 3. Cliquez sur chaque bouton que vous voulez automatiser (un par un)
; 4. Appuyez sur ESC pour ARRÊTER l'enregistrement
; 5. Les captures d'écran sont sauvegardées et prêtes pour le script d'automatisation !

#Requires AutoHotkey v2.0
#SingleInstance Force
SetWorkingDir(A_ScriptDir)
DirCreate("button_images")

; Rendre le script DPI-aware pour corriger les problèmes de coordonnées
DllCall("SetThreadDpiAwarenessContext", "Ptr", -3, "Ptr")  ; DPI_AWARENESS_CONTEXT_PER_MONITOR_AWARE

; Définir le mode de coordonnées sur Screen pour cohérence
CoordMode("Mouse", "Screen")
CoordMode("Pixel", "Screen")

; Variables globales
global isRecording := false
global clickCount := 0
global lastClickTime := 0
global clickTimings := []  ; Array pour stocker les délais entre clics

; Fonction pour capturer une région de l'écran autour du curseur
CaptureRegion(x, y, width, height, filename) {
    ; Créer un objet bitmap pour capturer l'écran
    pToken := Gdip_Startup()
    pBitmap := Gdip_BitmapFromScreen(x "|" y "|" width "|" height)
    Gdip_SaveBitmapToFile(pBitmap, filename)
    Gdip_DisposeImage(pBitmap)
    Gdip_Shutdown(pToken)
}

; Fonction pour sauvegarder les données de timing
SaveTimingData(count, timings) {
    ; Créer le contenu JSON
    jsonContent := '{'
    jsonContent .= '`n  "buttonCount": ' . count . ','
    jsonContent .= '`n  "timings": ['

    Loop count {
        if (A_Index > 1)
            jsonContent .= ','
        jsonContent .= '`n    ' . timings[A_Index]
    }

    jsonContent .= '`n  ]'
    jsonContent .= '`n}'

    ; Sauvegarder dans un fichier
    try {
        FileDelete("button_timings.json")
    }
    FileAppend(jsonContent, "button_timings.json", "UTF-8")
}

; Bibliothèque GDI+ simplifiée pour AutoHotkey v2
Gdip_Startup() {
    DllCall("LoadLibrary", "Str", "gdiplus")
    si := Buffer(24, 0)
    NumPut("UInt", 1, si)
    DllCall("gdiplus\GdiplusStartup", "Ptr*", &pToken := 0, "Ptr", si, "Ptr", 0)
    return pToken
}

Gdip_Shutdown(pToken) {
    DllCall("gdiplus\GdiplusShutdown", "Ptr", pToken)
    DllCall("FreeLibrary", "Ptr", DllCall("GetModuleHandle", "Str", "gdiplus", "Ptr"))
}

Gdip_BitmapFromScreen(Screen := 0) {
    if (Screen = 0) {
        Screen := "0|0|" . A_ScreenWidth . "|" . A_ScreenHeight
    }

    StringSplit := StrSplit(Screen, "|")
    x := Integer(StringSplit[1])
    y := Integer(StringSplit[2])
    w := Integer(StringSplit[3])
    h := Integer(StringSplit[4])

    ; S'assurer que les valeurs sont positives et valides
    if (w <= 0 or h <= 0) {
        return 0
    }

    chdc := DllCall("GetDC", "Ptr", 0, "Ptr")
    hdc := DllCall("gdi32\CreateCompatibleDC", "Ptr", chdc, "Ptr")
    hbm := DllCall("gdi32\CreateCompatibleBitmap", "Ptr", chdc, "Int", w, "Int", h, "Ptr")
    obm := DllCall("gdi32\SelectObject", "Ptr", hdc, "Ptr", hbm, "Ptr")
    DllCall("gdi32\BitBlt", "Ptr", hdc, "Int", 0, "Int", 0, "Int", w, "Int", h, "Ptr", chdc, "Int", x, "Int", y, "UInt", 0x00CC0020)
    DllCall("gdiplus\GdipCreateBitmapFromHBITMAP", "Ptr", hbm, "Ptr", 0, "Ptr*", &pBitmap := 0)
    DllCall("gdi32\SelectObject", "Ptr", hdc, "Ptr", obm)
    DllCall("gdi32\DeleteObject", "Ptr", hbm)
    DllCall("gdi32\DeleteDC", "Ptr", hdc)
    DllCall("ReleaseDC", "Ptr", 0, "Ptr", chdc)
    return pBitmap
}

Gdip_SaveBitmapToFile(pBitmap, sOutput) {
    SplitPath(sOutput, , , &Extension := "")
    if (!RegExMatch(Extension, "^(?i:BMP|DIB|RLE|JPG|JPEG|JPE|JFIF|GIF|TIF|TIFF|PNG)$"))
        return -1

    Extension := "." . Extension
    DllCall("gdiplus\GdipGetImageEncodersSize", "UInt*", &nCount := 0, "UInt*", &nSize := 0)
    ci := Buffer(nSize)
    DllCall("gdiplus\GdipGetImageEncoders", "UInt", nCount, "UInt", nSize, "Ptr", ci)

    Loop nCount {
        sString := StrGet(NumGet(ci, (idx := (48 + 7 * A_PtrSize) * (A_Index - 1)) + 32 + 3 * A_PtrSize, "Ptr"), "UTF-16")
        if InStr(sString, Extension) {
            pCodec := ci.Ptr + idx
            break
        }
    }

    if (!IsSet(pCodec))
        return -2

    DllCall("gdiplus\GdipSaveImageToFile", "Ptr", pBitmap, "WStr", sOutput, "Ptr", pCodec, "UInt", 0)
    return 0
}

Gdip_DisposeImage(pBitmap) {
    return DllCall("gdiplus\GdipDisposeImage", "Ptr", pBitmap)
}

; Appuyez sur F1 pour démarrer l'enregistrement
F1:: {
    global isRecording, clickCount, lastClickTime, clickTimings

    if (isRecording) {
        MsgBox("Déjà en cours d'enregistrement ! Appuyez sur ESC pour arrêter.")
        return
    }

    isRecording := true
    clickCount := 0
    lastClickTime := A_TickCount  ; Initialiser le temps de départ
    clickTimings := []  ; Réinitialiser les timings

    result := MsgBox("MODE D'ENREGISTREMENT DES CLICS`n`n" .
        "Le script va maintenant :`n" .
        "1. Capturer une capture d'écran autour de chaque clic`n" .
        "2. Sauvegarder la capture d'écran comme button1.png, button2.png, etc.`n" .
        "3. Chaque image montrera le bouton sur lequel vous avez cliqué`n`n" .
        "Cliquez OUI pour commencer l'enregistrement.`n" .
        "Ensuite cliquez sur chaque bouton que vous voulez automatiser.`n" .
        "Appuyez sur ESC quand vous avez terminé.",
        "Démarrer l'enregistrement ?",
        "YesNo")

    if (result = "No") {
        isRecording := false
        return
    }


    ; Activer la surveillance des clics (sans ~ pour intercepter AVANT le clic)
    Hotkey("LButton", OnLeftClick, "On")
}

; Ceci se déclenche quand vous cliquez gauche n'importe où
OnLeftClick(*) {
    global isRecording, clickCount, lastClickTime, clickTimings

    if (!isRecording) {
        ; Si on n'enregistre pas, laisser le clic passer normalement
        Click()
        return
    }

    ; Calculer le temps écoulé depuis le dernier clic
    currentTime := A_TickCount
    timeSinceLastClick := currentTime - lastClickTime

    ; Obtenir la position du clic IMMÉDIATEMENT
    MouseGetPos(&mouseX, &mouseY)

    ; Incrémenter le compteur
    clickCount++

    ; Sauvegarder le timing (en millisecondes)
    clickTimings.Push(timeSinceLastClick)

    ; Mettre à jour le temps du dernier clic
    lastClickTime := currentTime

    ; ÉTAPE 1: DÉPLACER LA SOURIS LOIN pour enlever l'effet hover
    ; On déplace vers le coin inférieur droit de l'écran
    MouseMove(A_ScreenWidth - 50, A_ScreenHeight - 50, 0)  ; 0 = instantané

    ; ÉTAPE 2: ATTENDRE que l'effet hover disparaisse
    Sleep(150)

    ; Définir la taille de la région à capturer (150x150 pixels autour du clic)
    captureSize := 50
    width := captureSize // 2
    height := captureSize // 4
     

    ; Calculer les coordonnées de la région (centrer sur le clic original)
    captureX := mouseX - width
    captureY := mouseY - height

    ; S'assurer que la région ne sort pas de l'écran
    if (captureX < 0)
        captureX := 0
    if (captureY < 0)
        captureY := 0
    if (captureX + captureSize > A_ScreenWidth)
        captureX := A_ScreenWidth - captureSize
    if (captureY + captureSize > A_ScreenHeight)
        captureY := A_ScreenHeight - captureSize

    ; Créer le nom de fichier
    filename := A_ScriptDir . "\button_images\button" . clickCount . ".png"

    ; ÉTAPE 3: CAPTURER LA RÉGION (sans hover, sans clic)
    CaptureRegion(captureX, captureY, captureSize, captureSize // 2, filename)

    ; Feedback sonore
    SoundBeep(1000, 100)

    ; ÉTAPE 4: REPLACER LA SOURIS à la position originale
    MouseMove(mouseX, mouseY, 0)  ; 0 = instantané

    ; Petit délai pour stabiliser
    Sleep(50)

    ; ÉTAPE 5: MAINTENANT envoyer le clic pour que le bouton fonctionne normalement
    Click()

    ; Petit délai pour voir le feedback
    Sleep(200)
}

; Appuyez sur ESC pour arrêter l'enregistrement
Esc:: {
    global isRecording, clickCount, clickTimings

    if (!isRecording) {
        ExitApp()
        return
    }

    isRecording := false

    ; Désactiver la surveillance des clics
    Hotkey("LButton", "Off")

    ; Sauvegarder les données de timing
    if (clickCount > 0) {
        SaveTimingData(clickCount, clickTimings)
    }

    MsgBox("=== ENREGISTREMENT TERMINÉ ===`n`n" .
        "Capturé " . clickCount . " screenshot(s).`n`n" .
        "Fichiers sauvegardés :`n" .
        "- button_images\button1.png, button2.png, etc.`n" .
        "- button_timings.json (délais entre clics)`n`n" .
        "Les captures d'écran sont prêtes à être utilisées !`n`n" .
        "Lancez step2_generate_automation.ahk pour créer votre script d'automatisation.`n`n" .
        "Appuyez sur OK pour quitter.")

    ExitApp()
}

; Ctrl+Esc pour forcer la sortie
^Esc::ExitApp()

; Message de démarrage
MsgBox("=== SCRIPT DE CAPTURE DE BOUTONS ===`n`n" .
    "Ce script capturera des screenshots autour de vos clics.`n`n" .
    "INSTRUCTIONS :`n" .
    "1. Appuyez sur F1 pour DÉMARRER l'enregistrement`n" .
    "2. Cliquez sur chaque bouton que vous voulez capturer`n" .
    "3. Après chaque clic, une capture d'écran est sauvegardée`n" .
    "4. Appuyez sur ESC quand vous avez terminé`n`n" .
    "Prêt ? Appuyez sur F1 pour commencer !")

