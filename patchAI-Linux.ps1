#!/usr/bin/powershell -Command

# Clone the repo
&git clone "https://github.com/jamiephan/HeroesOfTheStorm_S2MA" ./_s2ma_repo

# Grab MPQEditor
Invoke-WebRequest -Uri http://www.zezula.net/download/mpqeditor_en.zip -UseBasicParsing -OutFile "./mpqeditor.zip"
Expand-Archive -LiteralPath "./mpqeditor.zip" -DestinationPath "./mpqeditor" -Force
Move-Item "./mpqeditor/x64/MPQEditor.exe" "." -Force
Remove-Item "./mpqeditor.zip" -Force
Remove-Item "./mpqeditor" -Force -Recurse

$mpqEditor = "./MPQEditor.exe"


function PatchAI ($mapPath, $savePath, $aiPlayers) {

  if (Test-Path "./MapInfo") {
    Remove-Item -Force "./MapInfo"
  }
  Start-Process -WindowStyle Hidden "$mpqEditor" -Wait -ArgumentList "extract `"$mapPath`" MapInfo"
  $byteString = $(Get-Content "./MapInfo" -Raw -AsByteStream).ForEach('ToString', 'X') -join ' '
  
  # Invoke-Expression, yikes...
  foreach ($i in (Invoke-Expression $aiPlayers)) {
    $player = $i.ToString('X')
    if ($i -le 5) {
      $byteString = $byteString -replace "\b$player 1 0 0 0 2 0 0 0 50 72 6F 74 0 0 0 0 0\b", "$player 2 0 0 0 2 0 0 0 50 72 6F 74 0 0 0 0 0"
    }
    else {
      $byteString = $byteString -replace "\b$player 1 0 0 0 6 0 0 0 50 72 6F 74 0 0 0 0 0\b", "$player 2 0 0 0 6 0 0 0 50 72 6F 74 0 0 0 0 0"
    }
  }

  [byte[]] $newByteArray = -split $byteString -replace '^', '0x'
  Set-Content "./MapInfo" -AsByteStream -Value $newByteArray

  # Prevent no parent directory error
  New-Item -Force "$savePath" | Out-Null
  Copy-Item -Path $mapPath -Destination $savePath -Force

  Start-Process -WindowStyle Normal "$mpqEditor" -Wait -ArgumentList "add `"$savePath`" `"./MapInfo`" MapInfo"
  
  Remove-Item -Force "./MapInfo"

}

Get-ChildItem "./_s2ma_repo/maps" | ForEach-Object {
  # Nope.
  if ($_.Name -eq "Try Me Mode.stormmap") { continue }
  if ($_.Name -eq "Tutorial.stormmap") { continue }
  if ($_.Name -eq "Tutorial Map Mechanics.stormmap") { continue }
  
  $mapName = $_.BaseName
  $mapFile = $_.Name
  $mapPath = $_.FullName

  
  # Fair Game
  Write-Output "Patching: $mapName (spectator)"
  PatchAI $mapPath "./maps/spectator/$mapFile" 1..10
  Write-Output "Patching: $mapName (5v5)"
  PatchAI $mapPath "./maps/5v5/$mapFile" 2..10
  Write-Output "Patching: $mapName (4v4)"
  PatchAI $mapPath "./maps/4v4/$mapFile" "2,3,4,6,7,8,9"
  Write-Output "Patching: $mapName (3v3)"
  PatchAI $mapPath "./maps/3v3/$mapFile" "2,3,6,7,8"
  Write-Output "Patching: $mapName (2v2)"
  PatchAI $mapPath "./maps/2v2/$mapFile" "2,6,7"
  Write-Output "Patching: $mapName (1v1)"
  PatchAI $mapPath "./maps/1v1/$mapFile" "6"

  # Unfair Game KEKW: 1vX
  Write-Output "Patching: $mapName (1v2)"
  PatchAI $mapPath "./maps/1v2/$mapFile" "6,7"
  Write-Output "Patching: $mapName (1v3)"
  PatchAI $mapPath "./maps/1v3/$mapFile" "6,7,8"
  Write-Output "Patching: $mapName (1v4)"
  PatchAI $mapPath "./maps/1v4/$mapFile" "6,7,8,9"
  Write-Output "Patching: $mapName (1v5)"
  PatchAI $mapPath "./maps/1v5/$mapFile" "6,7,8,9,10"

  # Unfair Game KEKW: Xv1
  Write-Output "Patching: $mapName (5v1)"
  PatchAI $mapPath "./maps/5v1/$mapFile" "2,3,4,5,6"
  Write-Output "Patching: $mapName (4v1)"
  PatchAI $mapPath "./maps/4v1/$mapFile" "2,3,4,6"
  Write-Output "Patching: $mapName (3v1)"
  PatchAI $mapPath "./maps/3v1/$mapFile" "2,3,6"
  Write-Output "Patching: $mapName (2v1)"
  PatchAI $mapPath "./maps/2v1/$mapFile" "2,6"
}

Remove-Item "./_s2ma_repo" -Force -Recurse



