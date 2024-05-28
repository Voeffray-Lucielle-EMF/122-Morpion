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
        [PSCustomObject] $LogPrincipal,
        [Parameter(Mandatory=$true)]
        [string] $TypeEntree,
        [Parameter(Mandatory=$true)]
        [int] $tour,
        [Parameter(Mandatory=$true)]
        [string] $message
    )

    $LogNouveauTour = @{
        Type = $TypeEntree
        Message = $message
    }

    Add-Member -InputObject $LogPrincipal -NotePropertyMembers @{"Tour$($tour)" = (ConvertTo-Json -InputObject $LogNouveauTour)} -PassThru

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

# Création de l'objet de log à insérer ensuite dans log.json
$dateDuJeu = Get-Date 
$logPartie = [System.Collections.IDictionary]@{
    Date = [String] $dateDuJeu.DateTime
    joueur1 = $joueur1
    joueur2 = $joueur2
}

function WriteLogs {
    param (
        [Parameter(Mandatory=$true)]
        [PSCustomObject]$LogPrincipal,
        [Parameter(Mandatory=$true)]
        $message
    )

    $PathLog = (Get-ChildItem "Projet\Fichiers\log.json" -Recurse -ErrorAction SilentlyContinue).FullName

    Add-Member -InputObject $LogPrincipal -NotePropertyMembers @{message = $message} -PassThru

    $fichierLog = Get-Content -LiteralPath $PathLog -Encoding UTF8 | ConvertFrom-Json

    $nbreParties = Import-Csv -Delimiter ";" -LiteralPath ((Get-ChildItem "Projet\Fichiers\log.json" -Recurse -ErrorAction SilentlyContinue).FullName)

    Add-Member -InputObject $fichierLog.parties -Name "partie$($nbreParties.Nombre_de_parties)" -Value $LogPrincipal -MemberType AliasProperty

    Out-File -FilePath $PathLog -Encoding utf8 -InputObject (ConvertTo-Json -InputObject $fichierLog)
    
}

# Définir les chemin vers le fichiers nécessaires au bon fonctionnement du jeu

$PathGrille = (Get-ChildItem "Projet\Fichiers\grille.txt" -Recurse -ErrorAction SilentlyContinue).FullName


log -LogPrincipal $logPartie -TypeEntree "[DEBUG]" -tour 1 -message "Test de la fonction"
WriteLogs -LogPrincipal $logPartie -message "Test de lancement de la fonction"






