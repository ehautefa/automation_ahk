; AUTOMATION COMPLÈTE - CAPTURE ET GÉNÉRATION
; Ce script combine les étapes 1 et 2 en un seul processus
;
; UTILISATION :
; 1. Lancez ce script
; 2. Appuyez sur F1 pour capturer vos boutons
; 3. Cliquez sur chaque bouton
; 4. Appuyez sur ESC pour terminer la capture
; 5. Entrez le nom et la touche de raccourci
; 6. Votre script d'automatisation est généré !

#Requires AutoHotkey v2.0
#SingleInstance Force
SetWorkingDir(A_ScriptDir)

; Rendre le script DPI-aware
DllCall("SetThreadDpiAwarenessContext", "Ptr", -3, "Ptr")

; Définir le mode de coordonnées
CoordMode("Mouse", "Screen")
CoordMode("Pixel", "Screen")

; ============================================================================
; VARIABLES GLOBALES
; ============================================================================

; Variables de capture
global isRecording := false
global clickCount := 0
global lastClickTime := 0
global clickTimings := []

; ============================================================================
; PHASE 1 : CAPTURE DES BOUTONS
; ============================================================================

; Créer le dossier des images
DirCreate("button_images")

; Message de démarrage
MsgBox("=== CRÉATION D'AUTOMATISATION COMPLÈTE ===`n`n" .
    "Ce script va :`n" .
    "1. Capturer vos clics et boutons`n" .
    "2. Générer automatiquement votre script d'automatisation`n`n" .
    "ÉTAPE 1/2 : CAPTURE`n`n" .
    "Appuyez sur F1 pour démarrer la capture de boutons.`n" .
    "Cliquez sur chaque bouton à automatiser.`n" .
    "Appuyez sur ESC quand vous avez terminé.`n`n" .
    "Prêt ? Appuyez sur OK pour continuer.")

; Appuyez sur F1 pour démarrer l'enregistrement
F1:: {
    global isRecording, clickCount, lastClickTime, clickTimings

    if (isRecording) {
        MsgBox("Déjà en cours d'enregistrement ! Appuyez sur ESC pour arrêter.")
        return
    }

    isRecording := true
    clickCount := 0
    lastClickTime := A_TickCount
    clickTimings := []

    result := MsgBox("MODE D'ENREGISTREMENT DES CLICS`n`n" .
        "Le script va maintenant :`n" .
        "1. Capturer une capture d'écran autour de chaque clic`n" .
        "2. Sauvegarder la capture d'écran comme button1.png, button2.png, etc.`n" .
        "3. Enregistrer les délais entre clics`n`n" .
        "Cliquez OUI pour commencer l'enregistrement.`n" .
        "Ensuite cliquez sur chaque bouton que vous voulez automatiser.`n" .
        "Appuyez sur ESC quand vous avez terminé.",
        "Démarrer l'enregistrement ?",
        "YesNo")

    if (result = "No") {
        isRecording := false
        return
    }


    ; Activer la surveillance des clics
    Hotkey("LButton", OnLeftClick, "On")
}

; Gestionnaire de clic
OnLeftClick(*) {
    global isRecording, clickCount, lastClickTime, clickTimings

    if (!isRecording) {
        Click()
        return
    }

    ; Calculer le temps écoulé
    currentTime := A_TickCount
    timeSinceLastClick := currentTime - lastClickTime

    ; Obtenir la position du clic
    MouseGetPos(&mouseX, &mouseY)

    ; Incrémenter le compteur
    clickCount++

    ; Sauvegarder le timing
    clickTimings.Push(timeSinceLastClick)

    ; Mettre à jour le temps
    lastClickTime := currentTime


    ; Déplacer la souris pour enlever l'effet hover
    MouseMove(A_ScreenWidth - 10, A_ScreenHeight - 10, 0)
    Sleep(150)

    ; Calculer la région de capture
    width := 50
    height := 20
     

    ; Calculer les coordonnées de la région (centrer sur le clic original)
    captureX := mouseX - (width // 2)
    captureY := mouseY - (height // 2)

    ; S'assurer que la région ne sort pas de l'écran
    if (captureX < 0)
        captureX := 0
    if (captureY < 0)
        captureY := 0
    if (captureX + width > A_ScreenWidth)
        captureX := A_ScreenWidth - width
    if (captureY + height > A_ScreenHeight)
        captureY := A_ScreenHeight - height

    ; Créer le nom de fichier
    filename := A_ScriptDir . "\button_images\button" . clickCount . ".png"

    ; ÉTAPE 3: CAPTURER LA RÉGION (sans hover, sans clic)
    CaptureRegion(captureX, captureY, width, height, filename)

    ; Feedback sonore
    SoundBeep(1000, 100)

    ; Replacer la souris
    MouseMove(mouseX, mouseY, 0)
    Sleep(50)

    ; Envoyer le clic
    Click()

    Sleep(200)
}

; Appuyez sur ESC pour terminer la capture et passer à la génération
Esc:: {
    global isRecording, clickCount, clickTimings

    if (!isRecording) {
        ExitApp()
        return
    }

    isRecording := false

    ; Désactiver la surveillance des clics
    Hotkey("LButton", "Off")


    ; Vérifier qu'on a capturé au moins un bouton
    if (clickCount = 0) {
        MsgBox("Aucun bouton capturé. Le script va se terminer.", "Annulé")
        ExitApp()
    }

    ; Sauvegarder les données de timing
    SaveTimingData(clickCount, clickTimings)

    ; Afficher résumé de la capture
    MsgBox("=== CAPTURE TERMINÉE ===`n`n" .
        "Capturé " . clickCount . " bouton(s).`n`n" .
        "Fichiers sauvegardés :`n" .
        "- button_images\button1.png, button2.png, etc.`n" .
        "- button_timings.json`n`n" .
        "ÉTAPE 2/2 : GÉNÉRATION`n`n" .
        "Appuyez sur OK pour générer votre script d'automatisation.")

    ; Passer à la phase de génération
    GenerateAutomationScript()
}

; Ctrl+Esc pour forcer la sortie
^Esc::ExitApp()

; ============================================================================
; PHASE 2 : GÉNÉRATION DU SCRIPT
; ============================================================================

GenerateAutomationScript() {
    global clickCount, clickTimings

    ; Demander le nom du script
    scriptName := InputBox("Entrez le nom de votre script d'automatisation`n`n" .
        "Exemple : MonAutomation, ClickSequence, etc.`n`n" .
        "Le script sera sauvegardé sous : NomDuScript.ahk",
        "Nom du Script", "w350 h200").Value

    if (scriptName = "") {
        MsgBox("Annulé - Aucun nom de script fourni.", "Annulé")
        ExitApp()
    }

    ; Nettoyer le nom
    scriptName := RegExReplace(scriptName, "[^\w\-]", "_")

    ; Demander la touche de raccourci
    triggerKey := InputBox("Entrez la touche de raccourci pour lancer l'automatisation`n`n" .
        "Exemples :`n" .
        "  F2 = Touche F2`n" .
        "  ^j = Ctrl+J`n" .
        "  !a = Alt+A`n" .
        "  ^!r = Ctrl+Alt+R`n`n" .
        "Symboles : ^ = Ctrl, ! = Alt, + = Shift, # = Win",
        "Touche de Raccourci", "w400 h280", "F2").Value

    if (triggerKey = "") {
        MsgBox("Annulé - Aucune touche de raccourci fournie.", "Annulé")
        ExitApp()
    }

    ; Créer le dossier du projet
    projectFolder := A_ScriptDir . "\" . scriptName
    DirCreate(projectFolder)
    DirCreate(projectFolder . "\images")

    ; Copier les images
    Loop clickCount {
        sourceImage := A_ScriptDir . "\button_images\button" . A_Index . ".png"
        destImage := projectFolder . "\images\button" . A_Index . ".png"

        if (FileExist(sourceImage)) {
            FileCopy(sourceImage, destImage, 1)
        }
    }

    ; Vérifier que les templates existent
    if (!FileExist("automation_template.txt") || !FileExist("button_template.txt")) {
        MsgBox("ERREUR : Les fichiers template sont introuvables !`n`n" .
            "Fichiers requis :`n" .
            "- automation_template.txt`n" .
            "- button_template.txt", "Erreur", "Icon!")
        ExitApp()
    }

    ; Lire le template principal
    templateContent := FileRead("automation_template.txt", "UTF-8")

    ; Générer le code des boutons
    buttonClicksCode := GenerateButtonClicks(clickCount, clickTimings)

    ; Remplacer les placeholders
    scriptContent := StrReplace(templateContent, "{SCRIPT_NAME}", scriptName)
    scriptContent := StrReplace(scriptContent, "{HOTKEY}", triggerKey)
    scriptContent := StrReplace(scriptContent, "{BUTTON_CLICKS}", buttonClicksCode)

    ; Sauvegarder le script
    scriptFile := projectFolder . "\" . scriptName . ".ahk"
    try {
        FileDelete(scriptFile)
    }
    FileAppend(scriptContent, scriptFile, "UTF-8")

    ; Message de succès
    MsgBox("=== AUTOMATISATION CRÉÉE AVEC SUCCÈS ===`n`n" .
        "Nom : " . scriptName . ".ahk`n" .
        "Touche : " . triggerKey . "`n" .
        "Dossier : " . projectFolder . "`n" .
        "Boutons : " . clickCount . "`n`n" .
        "Fichiers créés :`n" .
        "- " . scriptName . ".ahk (script d'automatisation)`n" .
        "- images\ (dossier avec " . clickCount . " images)`n`n" .
        "Pour l'utiliser :`n" .
        "1. Ouvrez " . scriptFile . "`n" .
        "2. Lancez le script`n" .
        "3. Appuyez sur " . triggerKey . " pour exécuter l'automatisation !",
        "Succès", "Icon!")

    ExitApp()
}

; ============================================================================
; FONCTIONS UTILITAIRES
; ============================================================================

; Fonction pour capturer une région de l'écran
CaptureRegion(x, y, width, height, filename) {
    pToken := Gdip_Startup()
    pBitmap := Gdip_BitmapFromScreen(x "|" y "|" width "|" height)
    Gdip_SaveBitmapToFile(pBitmap, filename)
    Gdip_DisposeImage(pBitmap)
    Gdip_Shutdown(pToken)
}

; Fonction pour sauvegarder les données de timing
SaveTimingData(count, timings) {
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

    try {
        FileDelete("button_timings.json")
    }
    FileAppend(jsonContent, "button_timings.json", "UTF-8")
}

; Fonction pour générer le code des clics de boutons
GenerateButtonClicks(count, timings) {
    buttonTemplate := FileRead("button_template.txt", "UTF-8")
    code := ""

    Loop count {
        buttonNum := A_Index
        timing := (buttonNum <= timings.Length) ? timings[buttonNum] : 1000

        buttonCode := StrReplace(buttonTemplate, "{BUTTON_NUM}", buttonNum)
        buttonCode := StrReplace(buttonCode, "{TIMING}", timing)

        code .= buttonCode

        if (A_Index < count)
            code .= "`n"
    }

    return code
}

; ============================================================================
; BIBLIOTHÈQUE GDI+ (pour captures d'écran)
; ============================================================================

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
