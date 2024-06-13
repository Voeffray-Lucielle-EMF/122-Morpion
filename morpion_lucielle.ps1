<#
-----------------------------------------------------------
Autrice: Lucielle Anya Voeffray
Date de création: 22.05.2024
Contact: lucielle.voeffray@studentfr.ch

Version: 1.0

Description: Jeu du morpion avec un scoreboard et des logs
-----------------------------------------------------------
#>

param(
    [Parameter(Mandatory = $true, ValueFromPipeline = $false)]
    [string] $joueur1,
    [Parameter(Mandatory = $true, ValueFromPipeline = $false)]
    [string] $joueur2
)


# Les emplacements dans la grille qui doivent être modifiés y mettre un pion. Chaque emplacement a le nom de sa case.
$global:A1 = 52
$global:B1 = 56
$global:C1 = 60
$global:A2 = 98
$global:B2 = 102
$global:C2 = 106
$global:A3 = 144
$global:B3 = 148
$global:C3 = 152

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

# La fonction va demander aux joueurs la prochaine action qu'ils souhaite effectuer: -Jouer -Afficher le scoreboard -Quitter. S'ils font une erreur, le script boude et quitte 
function whatToDo {

    $Options = Read-Host "Voulez-vous voir le scoreboard (scoreboard), jouer (jouer) ou quitter le jeu (quitter) ?"

    switch ($Options) {
        "jouer" { log -TypeEntree "[INFO]" -message "----- Début du jeu entre $($joueur1) et $($joueur2) -----"; jeu }
        "scoreboard" { afficherScore log -TypeEntree "[INFO]" -message "Affichage du score demandé" }
        "quitter" { Write-Host "Extinction des feux"; log -TypeEntree "[INFO]" -message "Extinction des feux" ; exit }
        Default { Write-Host "Faut écrire correctement ! Pour la peine je boude, adieu"; Log -TypeEntree "[DEBUG]" -message "Les joueurs n'ont pas entré une donnée correcte"; exit }
    }
    
}

# Affiche le score dans le terminal
function afficherScore {
    # Trouver le fichier de scoreboard

    try {
        $board = Import-Csv -Path "leaderboard.csv" -Delimiter ";" | Sort-Object -Property Score -Descending
        Out-Host -InputObject $board
    }
    catch {
        Log -TypeEntree "[ERROR]" -message "Erreur lors de la lecture du fichier leaderboard.csv"
        #Créer le fichier leaderboard.csv
        Out-File -FilePath "leaderboard.csv" -Encoding utf8 -Append -InputObject '"Utilisateur";"Score";"Date_du_dernier_match"'
        Log -TypeEntree "[DEBUG]" -message "leaderboard.csv créé"
        Write-Host "Le scoreboard est vide, veuillez jouer une partie pour pouvoir afficher les scores"
    }

    whatToDo
    
}

# Affiche les règles dans le terminal
function afficherRegles {
    try {
        Get-Content -Path .\regles.txt -ErrorAction Stop | Write-Host
    }
    catch {
        Log -TypeEntree "[ERROR]" -message "Erreur lors de la lecture du fichier des règles"
        # Créer le fichier
        Out-File -FilePath "regles.txt" -Encoding utf8 -InputObject @"
        Bienvenue dans le jeu du Morpion !!!
        Afin de me simplifier la tâche, je vous invite à jouer à tour de rôle sur un PC
        Les règles sont simples:
            - Le joueur 1 commence par poser un pion sur la grille en donnant sa position (exemple: A1).
            - Le deuxième joueur peut alorsd poser son pion.
            - Il faut former un ligne diagonale, horizontale ou verticale de trois de ses pions pour gagner.
        
        Bonne Chance !!!
"@
        Log -TypeEntree "[DEBUG]" -message "règles.txt créé"
        # Retenter d'afficher les règles
        afficherRegles
    }
}

# Délégation du placement du pion dans la grille
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

# Contrôle s'il y a un gagnant
# - Si oui: ret TRUE
# - Si non: ret FALSE
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
    $g8 = @($grille[$A3], $grille[$B2], $grille[$C1])

    # Tous les combos
    $combos = @($g1, $g2, $g3, $g4, $g5, $g6, $g7, $g8)

    # Boucle qui contrôle s'il y a un combos gagnant présent dans la grille actuelle
    $ret = $false
    for ($i = 0; $i -lt $combos.Count; $i++) {
        if ((($combos[$i][0] -eq $combos[$i][1]) -and ($combos[$i][0] -eq $combos[$i][2])) -and ($combos[$i][0] -ne " ")) {
            $ret = $true
            break
        }
    }

    return $ret
    
}

# Contrôle s'il est encore possible de poser un pion:
# - Si oui: ret TRUE
# - Si non: ret FALSE
function checkDraw {
    param (
        [Parameter(Mandatory = $true)]
        [char[]] $grille
    )

    $cases = @($grille[$A1], $grille[$A2], $grille[$A3], $grille[$B1], $grille[$B2], $grille[$B3], $grille[$C1], $grille[$C2], $grille[$C3])

    $ret = $true

    foreach ($case in $cases) {
        if ($case = " ") {
            $ret = $false
            break;
        }
    }

    return $ret
    
}

# Prend en paramètre le gagnant et va soit créer une nouvelle entrée dans le fichier leaderboard.csv, soit augmenter le score si le joueur a déjà gagné 
function WriteScore {
    param (
        [Parameter(Mandatory = $true)]
        [string] $gagnant
    )

    try {
        $board = Import-Csv -Path "leaderboard.csv" -Delimiter ";"
    }
    catch {
        Log -TypeEntree "[ERROR]" -message "Erreur lors de la lecture du fichier leaderboard.csv"
        #Créer le fichier leaderboard.csv
        Out-File -FilePath "leaderboard.csv" -Encoding utf8 -Append -InputObject '"Utilisateur";"Score";"Date_du_dernier_match"'
        Log -TypeEntree "[DEBUG]" -message "leaderboard.csv créé"
        $board = Import-Csv -Path "leaderboard.csv" -Delimiter ";"
    }

    $exists = $false

    for ($i = 0; $i -lt $board.Count; $i++) {
        if ($board[$i].Utilisateur.ToLower() -eq $gagnant) {
            $exists = $true
            break
        }
    }

    if ($exists) {
        for ($i = 0; $i -lt $board.Count; $i++) {
            if ($board[$i].Utilisateur.ToLower() -eq $gagnant) {
                [int32] $score = $board[$i].Score
                $score++
                $board[$i].Score = $score
                $board[$i].Date_du_dernier_match = Get-Date
            }
        }
        
        $board | Export-Csv -Path .\leaderboard.csv -Delimiter ";" -Encoding utf8
    }
    else {
        $nouveauGagnant = [PSCustomObject]@{
            Utilisateur           = $gagnant.ToLower()
            Score                 = 1
            Date_du_dernier_match = $(Get-Date)
        }

        $board += $nouveauGagnant
        $board | Export-Csv -Path .\leaderboard.csv -Delimiter ";"
    }
    
    
    Write-Host "Le score du gagnant a été mis à jour"

}

# Logique derrière un mouvement du joueur
function tour {
    param (
        [Parameter(Mandatory = $true)]
        [String] $joueur,
        [Parameter(Mandatory = $true)]
        [int32] $toure
    )

    if ($joueur -eq $joueur1) {
        $pion = "X"
    }
    elseif ($joueur -eq $joueur2) {
        $pion = "O"
    }

    # Demande au joueur sur quelle case poser et grâce à un switch appelle la fonction de placement de pion
    # Si la case entrée est invalide, on diminue 1 de $toure et on retourne pour répéter le tour, sinon on retourne $toure sans changement
    $move = Read-Host "$($joueur), dans quelle case souhaitez-vous poser votre pion ?"
    switch ($move.ToUpper()) {
        "A1" { 
            if ($Grille[$A1] -eq " ") {
                $Grille = placerPion -caseAChanger $A1 -grille $Grille -pion $pion
            }
            else {
                log -TypeEntree "[DEBUG]" -message "$($joueur) n'a pas entré une case valide"
                Write-Host "La case entrée n'est pas valide, veuillez recommencer"
                [int32] $toure = ($toure - 1)
                Continue
            }
        }
        "A2" { 
            if ($Grille[$A2] -eq " ") {
                $Grille = placerPion -caseAChanger $A2 -grille $Grille -pion $pion
            }
            else {
                log -TypeEntree "[DEBUG]" -message "$($joueur) n'a pas entré une case valide"
                Write-Host "La case entrée n'est pas valide, veuillez recommencer"
                [int32] $toure = ($toure - 1)
                Continue
            }
        }
        "A3" { 
            if ($Grille[$A3] -eq " ") {
                $Grille = placerPion -caseAChanger $A3 -grille $Grille -pion $pion
            }
            else {
                log -TypeEntree "[DEBUG]" -message "$($joueur) n'a pas entré une case valide"
                Write-Host "La case entrée n'est pas valide, veuillez recommencer"
                [int32] $toure = ($toure - 1)
                Continue
            }
        }
        "B1" { 
            if ($Grille[$B1] -eq " ") {
                $Grille = placerPion -caseAChanger $B1 -grille $Grille -pion $pion
            }
            else {
                log -TypeEntree "[DEBUG]" -message "$($joueur) n'a pas entré une case valide"
                Write-Host "La case entrée n'est pas valide, veuillez recommencer"
                [int32] $toure = ($toure - 1)
                Continue
            }
        }
        "B2" { 
            if ($Grille[$B2] -eq " ") {
                $Grille = placerPion -caseAChanger $B2 -grille $Grille -pion $pion
            }
            else {
                log -TypeEntree "[DEBUG]" -message "$($joueur) n'a pas entré une case valide"
                Write-Host "La case entrée n'est pas valide, veuillez recommencer"
                [int32] $toure = ($toure - 1)
                Continue
            }
        }
        "B3" { 
            if ($Grille[$B3] -eq " ") {
                $Grille = placerPion -caseAChanger $B3 -grille $Grille -pion $pion
            }
            else {
                log -TypeEntree "[DEBUG]" -message "$($joueur) n'a pas entré une case valide"
                Write-Host "La case entrée n'est pas valide, veuillez recommencer"
                [int32] $toure = ($toure - 1)
                Continue
            }
        }
        "C1" { 
            if ($Grille[$C1] -eq " ") {
                $Grille = placerPion -caseAChanger $C1 -grille $Grille -pion $pion
            }
            else {
                log -TypeEntree "[DEBUG]" -message "$($joueur) n'a pas entré une case valide"
                Write-Host "La case entrée n'est pas valide, veuillez recommencer"
                [int32] $toure = ($toure - 1)
                Continue
            }
        }
        "C2" { 
            if ($Grille[$C2] -eq " ") {
                $Grille = placerPion -caseAChanger $C2 -grille $Grille -pion $pion
            }
            else {
                log -TypeEntree "[DEBUG]" -message "$($joueur) n'a pas entré une case valide"
                Write-Host "La case entrée n'est pas valide, veuillez recommencer"
                [int32] $toure = ($toure - 1)
                Continue
            }
        }
        "C3" { 
            if ($Grille[$C3] -eq " ") {
                $Grille = placerPion -caseAChanger $C3 -grille $Grille -pion $pion
            }
            else {
                log -TypeEntree "[DEBUG]" -message "$($joueur) n'a pas entré une case valide"
                Write-Host "La case entrée n'est pas valide, veuillez recommencer"
                [int32] $toure = ($toure - 1)
                Continue
            }
        }
        Default {
            log -TypeEntree "[DEBUG]" -message "$($joueur) n'a pas entré une case valide"
            Write-Host "La case entrée n'est pas valide, veuillez recommencer"
            [int32] $toure = ($toure - 1)
            Continue
        }
    }
    
    return $toure
    
}

# Fonctionnement du jeu
function jeu {

    # Création de la grille de partie
    $global:Grille = [char[]] @"
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
    
    [int32] $tour = 0

    [System.Boolean] $termine = $false

    # Tant que la partie n'est pas terminée (AKA tant qu'aucun joueur n'est annoncé vainqueur) La boucle se répete en demandant aux joueurs d'entrer la case où poser leur pion
    while ($termine -ne $true) {
        $tour = $tour + 1
        Write-Host $Grille

        # Si le tour est impair, c'est le joueur 1 qui joue, sinon c'est le joueur 2
        if ($tour % 2 -ne 0) {
            $tour = (tour -joueur $joueur1 -tour $tour)
        }
        else {
            $tour = (tour -joueur $joueur2 -tour $tour)
        }

        # Savoir si le joueur a gagné
        $termine = checkWinner -grille $Grille

        if ($termine -eq $false) {
            $draw = checkDraw -grille $Grille
        }

        # Si un joueur à gagné, déterminer qui
        if (($tour % 2 -ne 0) -and $termine) {
            Write-Host $Grille
            Write-Host "$($joueur1) a gagné la partie"
            WriteScore -gagnant $joueur1
        }
        elseif (($tour % 2 -eq 0) -and $termine) {
            Write-Host $Grille
            Write-Host "$($joueur2) a gagné la partie"
            WriteScore -gagnant $joueur2
        }
        elseif ($draw) {
            Write-Host $Grille
            Write-Host "MATCH NUL !!!"
        }
    }
    
    whatToDo
}

# Ce qui va s'effectuer au lancement du script
log -TypeEntree "[INFO]" -message "Lancement du programme"
afficherRegles
whatToDo



