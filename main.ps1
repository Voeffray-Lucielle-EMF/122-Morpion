<#
-----------------------------------------------------------
Autrice: Lucielle Anya Voeffray
Date de création: 22.05.2024
Contact: lucielle.voeffray@studentfr.ch

Version: 0.0

Description: Jeu du morpion avec un scoreboard et des logs
-----------------------------------------------------------
#>

param(
    [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
    [string] $joueur1,
    [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
    [string] $joueur2
)

$global:A1 = 64
$global:B1 = 68
$global:C1 = 72
$global:A2 = 118
$global:B2 = 122
$global:C2 = 126
$global:A3 = 172
$global:B3 = 176
$global:C3 = 180

# Ajouter une ligne de log au fichier logs.log
function log {
    param (
        [Parameter(Mandatory = $true)]
        [string] $TypeEntree,
        [Parameter(Mandatory = $true)]
        [string] $message
    )

    Out-File -FilePath "logs.log" -Encoding utf8 -Append -InputObject "$(Get-Date) $($TypeEntree) $($message)"

}

function whatToDo {

    $Options = Read-Host "Voulez-vous voir le scoreboard (scoreboard), jouer (jouer) ou quitter le jeu (quitter) ?"

    switch ($Options) {
        "jouer" { jeu }
        "scoreboard" { afficherScore }
        "quitter" { Write-Host "Extinction des feux"; exit }
        Default { Write-Host "Faut écrire correctement ! Pour la peine je boude, adieu"; exit }
    }
    
}

function afficherScore {
    # Trouver le fichier de scoreboard

    $board = Import-Csv -Path "leaderboard.csv" -Delimiter "," | Sort-Object -Property Score -Descending

    Out-Host -InputObject $board

    whatToDo
    
}

function afficherRegles {
    Get-Content -Path .\regles.txt | Write-Host
}

function placerPion {
    param (
        [Parameter(Mandatory = $true)]
        [int] $caseAChanger,
        [Parameter(Mandatory = $true)]
        [char] $pion,
        [Parameter(Mandatory = $true)]
        [char[]] $grille
    )
    
    $grille[$caseAChanger] = $pion

    return $grille

}

function checkWinner {
    param (
        [Parameter(Mandatory = $true)]
        [char[]] $grille
    )

    # Combos gagants
    $g1 = @($grille[$A1], $grille[$A2], $grille[$A3])
    $g2 = @($grille[$B1], $grille[$B2], $grille[$B3])
    $g3 = @($grille[$C1], $grille[$C2], $grille[$C3])
    $g4 = @($grille[$A1], $grille[$B1], $grille[$C1])
    $g5 = @($grille[$A2], $grille[$B2], $grille[$C2])
    $g6 = @($grille[$A3], $grille[$B3], $grille[$C3])
    $g7 = @($grille[$A1], $grille[$B2], $grille[$C3])
    $g8 = @($grille[$A3], $grille[$B2], $grille[$C3])

    # Tous les combos
    $combos = @($g1, $g2, $g3, $g4, $g5, $g6, $g7, $g8)

    # Boucle qui contrôle s'il y a un combos gagnant présent dans la grille actuelle
    $ret = $false
    Write-Host $combos.Count
    for ($i = 0; $i -lt $combos.Count; $i++) {
        if ((($combos[$i][0] -eq $combos[$i][1]) -and ($combos[$i][0] -eq $combos[$i][2])) -and ($combos[$i][0] -ne " ")) {
            $ret = $true
            break
        }
    }

    return $ret
    
}

function WriteScore {
    param (
        [Parameter(Mandatory = $true)]
        [string] $gagnant
    )

    $board = Import-Csv -Path .\leaderboard.csv -Delimiter ","

    $exists = $false

    for ($i = 0; $i -lt $board.Count; $i++) {
        if ($board[$i].Utilisateur -eq $gagnant) {
            $exists = $true
            break
        }
    }
    
    if ($exists) {
        for ($i = 0; $i -lt $board.Count; $i++) {
            if ($board[$i].Utilisateur -eq $gagnant) {
                [int32] $board[$i].Score = $board.Score + 1
                $board[$i].Date_du_dernier_match = Get-Date
            }
        }
        ConvertTo-CSV -InputObject $board | Out-File -FilePath .\leaderboard.csv
    }
    else {
        "$($gagnant),1,$(Get-Date)" | Out-File -FilePath .\leaderboard.csv -Append -Encoding utf8
    }
    
    
    Write-Host "Le score du gagnant a été mis à jour"

}

# Fonctionnement du jeu
function jeu {

    log -TypeEntree "[INFO]" -message "----- Début du jeu entre $($joueur1) et $($joueur2) -----"
    
    $Grille = [char[]] @"
    |===|=A=|=B=|=C=|===|
    ---------------------
    |=1=|   |   |   |=1=|
    ---------------------
    |=2=|   |   |   |=2=|
    ---------------------
    |=3=|   |   |   |=3=|
    ---------------------
    |===|=A=|=B=|=C=|===| 
"@

    
    $tour = 0

    [System.Boolean] $termine = $false

    while ($termine -ne $true) {
        $tour += 1        
        Write-Host $Grille
        Write-Host $tour

        if ($tour % 2 -ne 0) {
            $move = Read-Host "$($joueur1), dans quelle case souhaitez-vous poser votre pion ?"
            switch ($move.ToUpper()) {
                "A1" { 
                    if ($Grille[$A1] -eq " ") {
                        $Grille = placerPion -caseAChanger $A1 -grille $Grille -pion ([char] "X")
                    }
                    else {
                        log -TypeEntree "[DEBUG]" -message "$($joueur1) n'a pas entré une case valide"
                        Write-Host "La case entrée n'est pas valide, veuillez recommencer"
                        $tour -= 1
                        Continue
                    }
                }
                "A2" { 
                    if ($Grille[$A2] -eq " ") {
                        $Grille = placerPion -caseAChanger $A2 -grille $Grille -pion ([char] "X")
                    }
                    else {
                        log -TypeEntree "[DEBUG]" -message "$($joueur1) n'a pas entré une case valide"
                        Write-Host "La case entrée n'est pas valide, veuillez recommencer"
                        $tour -= 1
                        Continue
                    }
                }
                "A3" { 
                    if ($Grille[$A3] -eq " ") {
                        $Grille = placerPion -caseAChanger $A3 -grille $Grille -pion ([char] "X")
                    }
                    else {
                        log -TypeEntree "[DEBUG]" -message "$($joueur1) n'a pas entré une case valide"
                        Write-Host "La case entrée n'est pas valide, veuillez recommencer"
                        $tour -= 1
                        Continue
                    }
                }
                "B1" { 
                    if ($Grille[$B1] -eq " ") {
                        $Grille = placerPion -caseAChanger $B1 -grille $Grille -pion ([char] "X")
                    }
                    else {
                        log -TypeEntree "[DEBUG]" -message "$($joueur1) n'a pas entré une case valide"
                        Write-Host "La case entrée n'est pas valide, veuillez recommencer"
                        $tour -= 1
                        Continue
                    }
                }
                "B2" { 
                    if ($Grille[$B2] -eq " ") {
                        $Grille = placerPion -caseAChanger $B2 -grille $Grille -pion ([char] "X")
                    }
                    else {
                        log -TypeEntree "[DEBUG]" -message "$($joueur1) n'a pas entré une case valide"
                        Write-Host "La case entrée n'est pas valide, veuillez recommencer"
                        $tour -= 1
                        Continue
                    }
                }
                "B3" { 
                    if ($Grille[$B3] -eq " ") {
                        $Grille = placerPion -caseAChanger $B3 -grille $Grille -pion ([char] "X")
                    }
                    else {
                        log -TypeEntree "[DEBUG]" -message "$($joueur1) n'a pas entré une case valide"
                        Write-Host "La case entrée n'est pas valide, veuillez recommencer"
                        $tour -= 1
                        Continue
                    }
                }
                "C1" { 
                    if ($Grille[$C1] -eq " ") {
                        $Grille = placerPion -caseAChanger $C1 -grille $Grille -pion ([char] "X")
                    }
                    else {
                        log -TypeEntree "[DEBUG]" -message "$($joueur1) n'a pas entré une case valide"
                        Write-Host "La case entrée n'est pas valide, veuillez recommencer"
                        $tour -= 1
                        Continue
                    }
                }
                "C2" { 
                    if ($Grille[$C2] -eq " ") {
                        $Grille = placerPion -caseAChanger $C2 -grille $Grille -pion ([char] "X")
                    }
                    else {
                        log -TypeEntree "[DEBUG]" -message "$($joueur1) n'a pas entré une case valide"
                        Write-Host "La case entrée n'est pas valide, veuillez recommencer"
                        $tour -= 1
                        Continue
                    }
                }
                "C3" { 
                    if ($Grille[$C3] -eq " ") {
                        $Grille = placerPion -caseAChanger $C3 -grille $Grille -pion ([char] "X")
                    }
                    else {
                        log -TypeEntree "[DEBUG]" -message "$($joueur1) n'a pas entré une case valide"
                        Write-Host "La case entrée n'est pas valide, veuillez recommencer"
                        $tour -= 1
                        Continue
                    }
                }
                Default {
                    log -TypeEntree "[DEBUG]" -message "$($joueur1) n'a pas entré une case valide"
                    Write-Host "La case entrée n'est pas valide, veuillez recommencer"
                    $tour -= 1
                    Continue
                }
            }

        }
        else {
            $move = Read-Host "$($joueur2), dans quelle case souhaitez-vous poser votre pion"
            switch ($move.ToUpper()) {
                "A1" { 
                    if ($Grille[$A1] -eq " ") {
                        $Grille = placerPion -caseAChanger $A1 -grille $Grille -pion ([char] "O")
                    }
                    else {
                        log -TypeEntree "[DEBUG]" -message "$($joueur2) n'a pas entré une case valide"
                        Write-Host "La case entrée n'est pas valide, veuillez recommencer"
                        $tour -= 1
                        Continue
                    }
                }
                "A2" { 
                    if ($Grille[$A2] -eq " ") {
                        $Grille = placerPion -caseAChanger $A2 -grille $Grille -pion ([char] "O")
                    }
                    else {
                        log -TypeEntree "[DEBUG]" -message "$($joueur2) n'a pas entré une case valide"
                        Write-Host "La case entrée n'est pas valide, veuillez recommencer"
                        $tour -= 1
                        Continue
                    }
                }
                "A3" { 
                    if ($Grille[$A3] -eq " ") {
                        $Grille = placerPion -caseAChanger $A3 -grille $Grille -pion ([char] "O")
                    }
                    else {
                        log -TypeEntree "[DEBUG]" -message "$($joueur2) n'a pas entré une case valide"
                        Write-Host "La case entrée n'est pas valide, veuillez recommencer"
                        $tour -= 1
                        Continue
                    }
                }
                "B1" { 
                    if ($Grille[$B1] -eq " ") {
                        $Grille = placerPion -caseAChanger $B1 -grille $Grille -pion ([char] "O")
                    }
                    else {
                        log -TypeEntree "[DEBUG]" -message "$($joueur2) n'a pas entré une case valide"
                        Write-Host "La case entrée n'est pas valide, veuillez recommencer"
                        $tour -= 1
                        Continue
                    }
                }
                "B2" { 
                    if ($Grille[$B2] -eq " ") {
                        $Grille = placerPion -caseAChanger $B2 -grille $Grille -pion ([char] "O")
                    }
                    else {
                        log -TypeEntree "[DEBUG]" -message "$($joueur2) n'a pas entré une case valide"
                        Write-Host "La case entrée n'est pas valide, veuillez recommencer"
                        $tour -= 1
                        Continue
                    }
                }
                "B3" { 
                    if ($Grille[$B3] -eq " ") {
                        $Grille = placerPion -caseAChanger $B3 -grille $Grille -pion ([char] "O")
                    }
                    else {
                        log -TypeEntree "[DEBUG]" -message "$($joueur2) n'a pas entré une case valide"
                        Write-Host "La case entrée n'est pas valide, veuillez recommencer"
                        $tour -= 1
                        Continue
                    }
                }
                "C1" { 
                    if ($Grille[$C1] -eq " ") {
                        $Grille = placerPion -caseAChanger $C1 -grille $Grille -pion ([char] "O")
                    }
                    else {
                        log -TypeEntree "[DEBUG]" -message "$($joueur2) n'a pas entré une case valide"
                        Write-Host "La case entrée n'est pas valide, veuillez recommencer"
                        $tour -= 1
                        Continue
                    }
                }
                "C2" { 
                    if ($Grille[$C2] -eq " ") {
                        $Grille = placerPion -caseAChanger $C2 -grille $Grille -pion ([char] "O")
                    }
                    else {
                        log -TypeEntree "[DEBUG]" -message "$($joueur2) n'a pas entré une case valide"
                        Write-Host "La case entrée n'est pas valide, veuillez recommencer"
                        $tour -= 1
                        Continue
                    }
                }
                "C3" { 
                    if ($Grille[$C3] -eq " ") {
                        $Grille = placerPion -caseAChanger $C3 -grille $Grille -pion ([char] "O")
                    }
                    else {
                        log -TypeEntree "[DEBUG]" -message "$($joueur2) n'a pas entré une case valide"
                        Write-Host "La case entrée n'est pas valide, veuillez recommencer"
                        $tour -= 1
                        Continue
                    }
                }
                Default {
                    log -TypeEntree "[DEBUG]" -message "$($joueur2) n'a pas entré une case valide"
                    Write-Host "La case entrée n'est pas valide, veuillez recommencer"
                    $tour -= 1
                    Continue
                }
            }
        }

        $termine = checkWinner -grille $Grille


    }

    Write-Host $Grille

    if ($tour % 2 -eq 0) {
        Write-Host "$($joueur2) a gagné la partie"
    }
    else {
        Write-Host "$($joueur1) a gagné la partie"
    }

    whatToDo
}


WriteScore
# whatToDo
# log -TypeEntree "[INFO]" -message "Lancement du programme"
