<#
Autrice: Lucielle Anya Voeffray
Date de création: 22.05.2024
Contact: lucielle.voeffray@studentfr.ch
#>

param(
    [Parameter(Mandatory=$false, ValueFromPipeline=$true)]
    [string] $joueur1 = "Anonyme1",
    [Parameter(Mandatory=$false, ValueFromPipeline=$true)]
    [string] $joueur2 = "Anonyme2"
)



# Ajouter le log de tour aux logs de la partie
function log {
    param (
        [Parameter(Mandatory=$true)]
        [string] $TypeEntree,
        [Parameter(Mandatory=$true)]
        [string] $message
    )

    Out-File -FilePath "Projet/Fichiers/logs.log" -Encoding utf8 -Append -InputObject "$(Get-Date) $($TypeEntree) $($message)"

}

function whatToDo {

    $Options = Read-Host "Voulez-vous voir le scoreboard (scoreboard), jouer (jouer) ou quitter le jeu (quitter) ?"

    switch ($Options) {
        ($Options.toLower -eq "jouer") { jeu -LogPartie $logPartie }
        ($Options.ToLower -eq "scoreboard") { afficherScore }
        ($Options.ToLower -eq "quitter") { Write-Host "Extinction des feux"; exit }
        Default { Write-Host "Faut écrire correctement ! Pour la peine je boude, adieu"; exit }
    }
    
}

function afficherScore {
    # Trouver le fichier de scoreboard
    $PathScoreboard = (Get-ChildItem "Projet\Fichiers\leaderboard.csv" -Recurse -ErrorAction SilentlyContinue).FullName

    $board = Import-Csv -LiteralPath $PathScoreboard -Delimiter ";" | Sort-Object -Property Score

    Out-File -InputObject $board
    
}

function afficherRegles {
    
    # Trouver le chemin pour le fichier de règles
    $PathRegles = (Get-ChildItem "Projet\Fichiers\regles.txt" -Recurse -ErrorAction SilentlyContinue).FullName

    # Afficher les règles
    Get-Content -LiteralPath $PathRegles | Write-Host
}

# Définir les chemin vers le fichiers nécessaires au bon fonctionnement du jeu
$PathGrille = (Get-ChildItem "Projet\Fichiers\grille.txt" -Recurse -ErrorAction SilentlyContinue).FullName


log -TypeEntree "[DEBUG]" -message "Test de la fonction"


