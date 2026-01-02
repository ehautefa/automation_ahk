; ÉTAPE 2 : Générateur de Script d'Automatisation - AUTOHOTKEY V2
; Ce script génère un script d'automatisation basé sur les captures d'écran
;
; COMMENT L'UTILISER :
; 1. Assurez-vous d'avoir exécuté step1_capture_clicks.ahk d'abord
; 2. Lancez ce script
; 3. Entrez le nom du script à créer
; 4. Entrez la touche de raccourci pour lancer l'automatisation
; 5. Le script généré sera créé avec toutes les images dans un nouveau dossier

#Requires AutoHotkey v2.0
#SingleInstance Force
SetWorkingDir(A_ScriptDir)

; Rendre le script DPI-aware
DllCall("SetThreadDpiAwarenessContext", "Ptr", -3, "Ptr")

; Message de bienvenue
MsgBox("=== GÉNÉRATEUR DE SCRIPT D'AUTOMATISATION ===`n`n" .
    "Ce script va créer un script d'automatisation basé sur vos captures.`n`n" .
    "Il va :`n" .
    "1. Demander un nom pour votre script`n" .
    "2. Demander une touche de raccourci`n" .
    "3. Créer un nouveau dossier avec vos images`n" .
    "4. Générer le script d'automatisation`n`n" .
    "Prêt ? Cliquez OK pour continuer.")

; Vérifier que les fichiers nécessaires existent
if (!FileExist("button_timings.json")) {
    MsgBox("ERREUR : button_timings.json introuvable !`n`n" .
        "Veuillez d'abord exécuter step1_capture_clicks.ahk`n" .
        "pour capturer vos boutons.", "Erreur", "Icon!")
    ExitApp()
}

if (!DirExist("button_images")) {
    MsgBox("ERREUR : Le dossier button_images est introuvable !`n`n" .
        "Veuillez d'abord exécuter step1_capture_clicks.ahk`n" .
        "pour capturer vos boutons.", "Erreur", "Icon!")
    ExitApp()
}

; Demander le nom du script
scriptName := InputBox("Entrez le nom de votre script d'automatisation`n`n" .
    "Exemple : MonAutomation, ClickSequence, etc.`n`n" .
    "Le script sera sauvegardé sous : NomDuScript.ahk",
    "Nom du Script", "w350 h200").Value

if (scriptName = "") {
    MsgBox("Annulé - Aucun nom de script fourni.", "Annulé")
    ExitApp()
}

; Nettoyer le nom (enlever caractères invalides)
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

; Lire les données de timing
timingData := FileRead("button_timings.json", "UTF-8")
buttonCount := 0
timings := []

; Parser le JSON manuellement (simple)
if (RegExMatch(timingData, '"buttonCount":\s*(\d+)', &match)) {
    buttonCount := Integer(match[1])
}

; Extraire les timings
pos := 1
while (pos := RegExMatch(timingData, 'm)^\s*(\d+)', &match, pos)) {
    timings.Push(Integer(match[1]))
    pos += StrLen(match[0])
}

if (buttonCount = 0) {
    MsgBox("ERREUR : Aucun bouton trouvé dans button_timings.json !", "Erreur", "Icon!")
    ExitApp()
}

; Copier les images
Loop buttonCount {
    sourceImage := A_ScriptDir . "\button_images\button" . A_Index . ".png"
    destImage := projectFolder . "\images\button" . A_Index . ".png"

    if (FileExist(sourceImage)) {
        FileCopy(sourceImage, destImage, 1)
    } else {
        MsgBox("ATTENTION : " . sourceImage . " introuvable !", "Avertissement", "Icon!")
    }
}

; Vérifier que le template existe
if (!FileExist("automation_template.txt")) {
    MsgBox("ERREUR : automation_template.txt introuvable !`n`nLe fichier template est nécessaire pour générer le script.", "Erreur", "Icon!")
    ExitApp()
}

; Lire le template
templateContent := FileRead("automation_template.txt", "UTF-8")

; Générer le code des clics de boutons
buttonClicksCode := GenerateButtonClicks(buttonCount, timings)

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
MsgBox("=== SCRIPT GÉNÉRÉ AVEC SUCCÈS ===`n`n" .
    "Nom : " . scriptName . ".ahk`n" .
    "Touche : " . triggerKey . "`n" .
    "Dossier : " . projectFolder . "`n" .
    "Boutons : " . buttonCount . "`n`n" .
    "Fichiers créés :`n" .
    "- " . scriptName . ".ahk (script d'automatisation)`n" .
    "- images\ (dossier avec " . buttonCount . " images)`n`n" .
    "Pour l'utiliser :`n" .
    "1. Ouvrez " . scriptFile . "`n" .
    "2. Lancez le script`n" .
    "3. Appuyez sur " . triggerKey . " pour exécuter l'automatisation !",
    "Succès", "Icon!")

ExitApp()

; Fonction pour générer le code des clics de boutons
GenerateButtonClicks(count, timings) {
    ; Lire le template de bouton
    if (!FileExist("button_template.txt")) {
        MsgBox("ERREUR : button_template.txt introuvable !")
        ExitApp()
    }

    buttonTemplate := FileRead("button_template.txt", "UTF-8")
    code := ""

    ; Générer le code pour chaque bouton
    Loop count {
        buttonNum := A_Index
        timing := (buttonNum <= timings.Length) ? timings[buttonNum] : 1000

        ; Copier le template et remplacer les placeholders
        buttonCode := StrReplace(buttonTemplate, "{BUTTON_NUM}", buttonNum)
        buttonCode := StrReplace(buttonCode, "{TIMING}", timing)

        code .= buttonCode

        ; Ajouter une ligne vide entre les boutons sauf pour le dernier
        if (A_Index < count)
            code .= "`n"
    }

    return code
}
