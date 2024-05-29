function WriteScore {
    param (
        [Parameter(Mandatory = $true)]
        [string] $gagnant
    )

    $board = Import-Csv -Path "leaderboard.csv" -Delimiter ","

    $exists = $false

    ForEach-Object -InputObject $board {
        if ($_.Utilisateur -eq $gagnant) {
            $exists = $true
        }
    }
    
    if ($exists) {
        for ($i = 0; $i -lt $board.Count; $i++) {
            if ($board[$i].Utilisateur -eq $gagnant) {
                [int32] $board[$i].Score += 1
                $board[$i].Date_du_dernier_match = Get-Date
            }
        }
        ConvertTo-CSV -InputObject $board > .\leaderboard.csv
    } else {
        "$($gagnant),1,$(Get-Date)" | Add-Content -Path .\leaderboard.csv
    }
    
    
    Write-Host "Le score du gagnant a été mis à jour"

}