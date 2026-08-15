# =====================================================================
#  cerca_mt4.ps1  --  C'E' UN MT4 SU QUESTA MACCHINA? (senza installarlo)
# ---------------------------------------------------------------------
#  PERCHE' ESISTE (15/08/2026)
#    Claudio: "puo' essere che quegli EA fossero sul mio MT4? Lo avevo
#    disinstallato, provo a reinstallarlo e ci togliamo ogni dubbio."
#
#    Reinstallare NON serve, e non e' gratis: rimetterebbe sul PC un
#    altro terminale capace di collegarsi al conto vivo, cioe' proprio
#    la condizione che ha prodotto 174 ordini fantasma in sedici
#    giorni. Il dubbio si toglie GUARDANDO, non installando.
#
#  COME SI DISTINGUONO, con certezza e senza opinioni
#    MT5:  <cartella dati>\MQL5\Profiles\Charts\<profilo>\chartNN.chr
#          EA compilati in  MQL5\Experts\*.ex5
#    MT4:  <cartella dati>\profiles\<profilo>\chartNN.chr   (NIENTE MQL5)
#          EA compilati in  MQL4\Experts\*.ex4
#
#    I grafici censiti il 15/08 stanno sotto MQL5\Profiles\Charts.
#    Quel pezzo di percorso in MT4 non esiste: quei grafici SONO di MT5.
#    Questo script lo verifica sulla macchina, e in piu' dice se di MT4
#    e' rimasto qualcosa dopo la disinstallazione (le cartelle dati NON
#    vengono rimosse dal disinstallatore: restano li' con dentro EA,
#    profili e a volte le credenziali salvate).
#
#  USO (non tocca NIENTE, si puo' lanciare con tutto aperto):
#    powershell -ExecutionPolicy Bypass -File .\cerca_mt4.ps1
# =====================================================================
$ErrorActionPreference = "Continue"

$out = New-Object System.Collections.ArrayList
function Riga($t, $col = "Gray") { Write-Host $t -ForegroundColor $col; [void]$out.Add($t) }

function Trova-Desktop {
  $c = @()
  try { $c += [Environment]::GetFolderPath("Desktop") } catch {}
  $c += (Join-Path $env:USERPROFILE "Desktop")
  $c += (Join-Path $env:USERPROFILE "OneDrive\Desktop")
  foreach ($d in $c) { if ($d -and (Test-Path $d)) { return $d } }
  return $env:USERPROFILE
}

Riga "=== C'E' UN MT4 SU QUESTA MACCHINA? ===" "Cyan"
Riga ("MACCHINA: " + $env:COMPUTERNAME + "   utente: " + $env:USERNAME) "Cyan"
Riga ("letto il  " + (Get-Date -Format "yyyy-MM-dd HH:mm:ss"))
Riga ""

# =====================================================================
#  1. LE CARTELLE DATI: quali sono MT5 e quali MT4
# =====================================================================
Riga "--- 1) cartelle dati sotto %APPDATA%\MetaQuotes\Terminal ---" "Yellow"
$termRoot = Join-Path $env:APPDATA "MetaQuotes\Terminal"
$nMT5 = 0; $nMT4 = 0
if (-not (Test-Path $termRoot)) {
  Riga "  la cartella non esiste: nessun terminale MetaQuotes su questo utente." "Yellow"
} else {
  foreach ($dir in (Get-ChildItem $termRoot -Directory -EA SilentlyContinue)) {
    $haMQL5 = Test-Path (Join-Path $dir.FullName "MQL5")
    $haMQL4 = Test-Path (Join-Path $dir.FullName "MQL4")
    $haProfMT4 = Test-Path (Join-Path $dir.FullName "profiles")
    $tipo = "?"
    if ($haMQL5) { $tipo = "MT5"; $nMT5++ }
    elseif ($haMQL4 -or $haProfMT4) { $tipo = "MT4"; $nMT4++ }
    if ($dir.Name -eq "Common") { $tipo = "(comune)" }

    Riga ("  " + $tipo.PadRight(9) + $dir.Name) $(if ($tipo -eq "MT4") { "Red" } else { "Gray" })
    $orig = Join-Path $dir.FullName "origin.txt"
    if (Test-Path $orig) {
      try { Riga ("            installato in: " + ((Get-Content $orig -Raw).Trim())) "DarkGray" } catch {}
    }
    if ($tipo -eq "MT4") {
      foreach ($sub in @("profiles", "MQL4\Experts")) {
        $p = Join-Path $dir.FullName $sub
        if (Test-Path $p) {
          $n = @(Get-ChildItem $p -Recurse -File -EA SilentlyContinue).Count
          Riga ("            " + $sub + " : " + $n + " file") "Red"
        }
      }
    }
  }
}
Riga ""
Riga ("  cartelle dati MT5: " + $nMT5 + "    cartelle dati MT4: " + $nMT4) "White"
Riga ""

# =====================================================================
#  2. GLI EA COMPILATI: .ex5 = MT5, .ex4 = MT4
# =====================================================================
Riga "--- 2) EA compilati (.ex5 = MT5, .ex4 = MT4) ---" "Yellow"
$ex5 = 0; $ex4 = 0
$nomiEx4 = New-Object System.Collections.ArrayList
if (Test-Path $termRoot) {
  foreach ($dir in (Get-ChildItem $termRoot -Directory -EA SilentlyContinue)) {
    foreach ($f in (Get-ChildItem $dir.FullName -Recurse -Include "*.ex5" -File -EA SilentlyContinue)) { $ex5++ }
    foreach ($f in (Get-ChildItem $dir.FullName -Recurse -Include "*.ex4" -File -EA SilentlyContinue)) {
      $ex4++
      if (-not $nomiEx4.Contains($f.BaseName)) { [void]$nomiEx4.Add($f.BaseName) }
    }
  }
}
Riga ("  file .ex5 trovati: " + $ex5)
Riga ("  file .ex4 trovati: " + $ex4) $(if ($ex4 -gt 0) { "Red" } else { "Green" })
if ($nomiEx4.Count -gt 0) {
  Riga "  nomi degli EA MT4 rimasti:" "Red"
  foreach ($n in ($nomiEx4 | Sort-Object)) { Riga ("     " + $n) "Red" }
}
Riga ""

# =====================================================================
#  3. IL PROGRAMMA: terminal.exe (MT4) vs terminal64.exe (MT5)
# =====================================================================
Riga "--- 3) il programma installato ---" "Yellow"
$trovati = 0
foreach ($radice in @($env:ProgramFiles, ${env:ProgramFiles(x86)})) {
  if (-not $radice -or -not (Test-Path $radice)) { continue }
  foreach ($d in (Get-ChildItem $radice -Directory -EA SilentlyContinue |
                  Where-Object { $_.Name -match "(?i)meta|trader|mt4|mt5" })) {
    $t64 = Test-Path (Join-Path $d.FullName "terminal64.exe")
    $t32 = Test-Path (Join-Path $d.FullName "terminal.exe")
    $che = @()
    if ($t64) { $che += "MT5 (terminal64.exe)" }
    if ($t32 -and -not $t64) { $che += "MT4 (terminal.exe)" }
    if ($t32 -and $t64) { $che += "anche terminal.exe" }
    if ($che.Count -gt 0) {
      $trovati++
      Riga ("  " + $d.FullName + "   ->  " + ($che -join " + ")) $(if ($t32 -and -not $t64) { "Red" } else { "Gray" })
    }
  }
}
if ($trovati -eq 0) { Riga "  nessuna cartella MetaTrader trovata in Programmi." "Yellow" }
Riga ""

# =====================================================================
#  4. LA RISPOSTA
# =====================================================================
Riga "=== LA RISPOSTA ===" "Cyan"
if ($nMT4 -eq 0 -and $ex4 -eq 0) {
  Riga "Di MT4 non c'e' traccia su questo utente: ne' cartelle dati, ne' .ex4." "Green"
  Riga "Quindi i grafici censiti il 15/08 NON possono venire da li'." "Green"
} else {
  Riga "ATTENZIONE: qualcosa di MT4 e' rimasto (vedi sopra, in rosso)." "Red"
  Riga "Il disinstallatore NON cancella le cartelle dati: dentro possono" "Red"
  Riga "esserci EA, profili e a volte le credenziali salvate del conto." "Red"
}
Riga ""
Riga "IN OGNI CASO, e vale a prescindere da cosa c'e' qui sopra:" "White"
Riga "gli 11 grafici del censimento stanno sotto" "White"
Riga "   ...\\Terminal\\215D85D7...\\MQL5\\Profiles\\Charts\\Default\\" "White"
Riga "e il pezzo  MQL5\\  in MT4 NON ESISTE (MT4 usa profiles\\ e MQL4\\)." "White"
Riga "Sono grafici di MT5. Questo non e' un'inferenza: e' il percorso." "White"
Riga ""
Riga "Che tu avessi gli stessi EA anche su un MT4 e' probabile e non" "Gray"
Riga "cambia niente: le due cose possono essere vere insieme. Quelli da" "Gray"
Riga "staccare sono quelli che stanno su MT5 ADESSO." "Gray"

# --- referto sul Desktop ---------------------------------------------
$desk = Trova-Desktop
$dest = Join-Path $desk "cerca_mt4"
if (Test-Path $dest) { Remove-Item $dest -Recurse -Force -EA SilentlyContinue }
New-Item -ItemType Directory -Force -Path $dest | Out-Null
$nome = "cerca_mt4_" + $env:COMPUTERNAME + ".txt"
$out | Set-Content -Path (Join-Path $dest $nome) -Encoding ASCII
$zip = Join-Path $desk "cerca_mt4.zip"
if (Test-Path $zip) { Remove-Item $zip -Force -EA SilentlyContinue }
Write-Host ""
Write-Host "    FILE ATTESO:" -ForegroundColor White
if (Test-Path (Join-Path $dest $nome)) { Write-Host ("      OK      " + $nome) -ForegroundColor Green }
else { Write-Host ("      MANCA  " + $nome) -ForegroundColor Red }
try {
  Compress-Archive -Path (Join-Path $dest "*") -DestinationPath $zip -Force
  Write-Host ""
  Write-Host ("    ZIP PRONTO DA MANDARE:  " + $zip) -ForegroundColor Cyan
} catch {
  Write-Host ("!!! zip non creato: " + $_.Exception.Message) -ForegroundColor Red
}
