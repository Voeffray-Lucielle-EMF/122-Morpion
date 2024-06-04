
$board = Import-Csv -Path .\leaderboard.csv -Delimiter ","

foreach ($line in $board) {
    [Int32] $score = $line.Score

    Write-Host "Le score est : $($score + 1)" 
}
