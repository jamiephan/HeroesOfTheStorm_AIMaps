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
  $byteString = $(Get-Content "./MapInfo" -Raw -Encoding Byte).ForEach('ToString', 'X') -join ' '
  
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
  Set-Content "./MapInfo" -Encoding Byte -Value $newByteArray

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


  # Generate Comps

  foreach ($t1 in 1..5) {
  
    # Generate Team 1 Player Array
    $t1Arr = @()
    for ($t1n = 2 ; $t1n -le $t1 ; $t1n++) {
      $t1Arr += $t1n
    }
    $t1ArrStr = $t1Arr -join ","
  
    foreach ($t2 in 1..5) {
  
      # Generate Team 1 Player Array
      $t2Arr = @()
      for ($t2n = 1 ; $t2n -le $t2 ; $t2n++) {
        $t2Arr += ($t2n + 5)
      }
      $t2ArrStr = $t2Arr -join ","
  
      # =======
      $versesString = -join ($t1, "v", $t2)
      $listString = $t2ArrStr
      if ($t1ArrStr) {
        $listString = ($t1ArrStr, $t2ArrStr) -join ","
      }    
      Write-Output "Patching: $mapName ($versesString)"
      PatchAI $mapPath "./maps/$versesString/$mapFile" "$listString"
      
    }
  
  }

  # Spectator Mode
  Write-Output "Patching: $mapName (spectator)"
  PatchAI $mapPath "./maps/spectator/$mapFile" 1..10

  
  # === Add Your Configuration Here ===


  # ===================================

}

Remove-Item "./_s2ma_repo" -Force -Recurse



