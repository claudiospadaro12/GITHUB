# =====================================================================
#  diagnosi_tester.ps1  --  PERCHE' IL TESTER NON HA PRODOTTO NIENTE
# ---------------------------------------------------------------------
#  PERCHE' ESISTE (14/08/2026):
#  R50 ha lanciato 32 passate e raccolto ZERO CSV. Il messaggio dello
#  script ("il simbolo esiste? lo storico copre il periodo?") e' una
#  DOMANDA, non una diagnosi: sono io che non sapevo perche'. Le cause
#  possibili sono almeno quattro e portano ad azioni diverse:
#
#    1. i simboli _EXT non ci sono (o non in QUESTO terminale);
#    2. ci sono ma senza storico nel periodo chiesto;
#    3. il terminale non ha nemmeno avviato l'ottimizzazione;
#    4. la riga [Experts] AllowLiveTrading=false che ho aggiunto oggi
#       agli ini blocca anche il tester - cioe' un danno fatto da me.
#
#  La quarta va guardata come le altre, senza sconti: l'ho introdotta
#  poche ore fa in uno script che non aveva mai girato con successo,
#  quindi non ha un "prima" da confrontare.
#
#  Questo script NON lancia niente e NON tocca niente: legge il disco.
#
#  USO (sul PC di backtest, MT5 chiuso o aperto e' uguale):
#    powershell -ExecutionPolicy Bypass -File .\diagnosi_tester.ps1
# =====================================================================
param(
  [string] $Simboli = "EXT",     # pezzo di nome dei simboli da cercare
  [int]    $Righe   = 40         # quante righe di log mostrare
)
$ErrorActionPreference = "Continue"

# --- lettura CONDIVISA (14/08/2026) ---------------------------------
#  [IO.File]::ReadAllBytes apre in lettura esclusiva: se MT5 e' aperto e
#  sta scrivendo il log, la chiamata fallisce con "il processo non puo'
#  accedere al file perche' e' in uso da un altro processo". E' successo
#  la sera del 14/08 sul terminale Pepperstone. Con FileShare::ReadWrite
#  si legge anche un file che qualcun altro tiene aperto in scrittura.
function Leggi-Bytes($path) {
  try {
    $fs = [IO.File]::Open($path, [IO.FileMode]::Open, [IO.FileAccess]::Read, [IO.FileShare]::ReadWrite)
    $b  = New-Object byte[] $fs.Length
    [void]$fs.Read($b, 0, $b.Length)
    $fs.Close()
    return $b
  } catch { return $null }
}

function Leggi-Testo($path) {
  $b = Leggi-Bytes $path
  if ($null -eq $b) { return "" }
  if ($b.Count -lt 4) { return "" }
  $utf16 = ($b[0] -eq 0xFF -and $b[1] -eq 0xFE)
  if (-not $utf16) {
    $zeri = 0; $n = [math]::Min(400, $b.Count)
    for ($i = 1; $i -lt $n; $i += 2) { if ($b[$i] -eq 0) { $zeri++ } }
    $utf16 = ($zeri -gt ($n/4))
  }
  if ($utf16) { return [Text.Encoding]::Unicode.GetString($b) }
  return [Text.Encoding]::UTF8.GetString($b)
}

$out = New-Object System.Collections.ArrayList
function Riga($t, $col = "Gray") { Write-Host $t -ForegroundColor $col; [void]$out.Add($t) }

Riga "=== DIAGNOSI DEL TESTER ===" "Cyan"
Riga ("MACCHINA: " + $env:COMPUTERNAME + "   utente: " + $env:USERNAME) "Cyan"
Riga ("letto il  " + (Get-Date -Format "yyyy-MM-dd HH:mm:ss"))
Riga ""

$termRoot = Join-Path $env:APPDATA "MetaQuotes\Terminal"
$cartelle = @(Get-ChildItem $termRoot -Directory -ErrorAction SilentlyContinue |
              Where-Object { Test-Path (Join-Path $_.FullName "MQL5") })

foreach ($dir in $cartelle) {
  Riga ("--- cartella dati " + $dir.Name + " ---") "Yellow"

  # ---------------------------------------------------------------
  #  1. I SIMBOLI PERSONALIZZATI, letti dal disco
  #     MT5 li tiene in bases\Custom\ . Se la cartella non c'e', di
  #     simboli costruiti non ne esiste nemmeno uno.
  # ---------------------------------------------------------------
  #  14/08, PRIMA STESURA SBAGLIATA: guardavo le cartelle dentro
  #  bases\Custom e mi usciva "history / ticks", cioe' i CONTENITORI, non i
  #  simboli. I nomi veri stanno un livello piu' sotto: bases\Custom\history\
  #  <SIMBOLO>. Elencare il livello sbagliato faceva sembrare che di simboli
  #  costruiti non ce ne fosse nessuno, mentre c'erano 297 MB di storico.
  $custom = Join-Path $dir.FullName "bases\Custom"
  if (Test-Path $custom) {
    $sym = @()
    foreach ($sotto in @("history", "ticks", ".")) {
      $q = Join-Path $custom $sotto
      if (Test-Path $q) { $sym += @(Get-ChildItem $q -Directory -ErrorAction SilentlyContinue) }
    }
    $sym = @($sym | Sort-Object Name -Unique)
    if ($sym.Count -eq 0) {
      $sym = @(Get-ChildItem $custom -ErrorAction SilentlyContinue)
    }
    if ($sym.Count -gt 0) {
      Riga ("  simboli personalizzati trovati: " + $sym.Count) "Green"
      foreach ($s in $sym) {
        $peso = 0
        if ($s.PSIsContainer) {
          $peso = (Get-ChildItem $s.FullName -Recurse -File -EA SilentlyContinue |
                   Measure-Object -Property Length -Sum).Sum
        } else { $peso = $s.Length }
        $mb = [math]::Round(($peso / 1MB), 1)
        $marca = if ($s.Name -like "*$Simboli*") { "  <<< quello che cerchiamo" } else { "" }
        Riga ("    " + $s.Name.PadRight(24) + $mb.ToString().PadLeft(8) + " MB" + $marca)
      }
    } else {
      Riga "  bases\Custom c'e' ma e' VUOTA: nessun simbolo costruito." "Red"
    }
  } else {
    Riga "  bases\Custom NON ESISTE: qui non e' mai stato creato un simbolo personalizzato." "Red"
  }

  # ---------------------------------------------------------------
  #  2. IL LOG DEL TESTER: e' li' che sta il motivo vero
  # ---------------------------------------------------------------
  $tlog = Join-Path $dir.FullName "Tester\logs"
  if (Test-Path $tlog) {
    $f = @(Get-ChildItem $tlog -Filter "*.log" -EA SilentlyContinue |
           Sort-Object LastWriteTime -Descending | Select-Object -First 1)
    if ($f.Count -gt 0) {
      Riga ("  log del tester piu' recente: " + $f[0].Name + "  (" + $f[0].LastWriteTime + ")") "Yellow"
      $txt = Leggi-Testo $f[0].FullName
      $righe = @($txt -split "`r?`n" | Where-Object { $_.Trim() -ne "" })
      # prima le righe che sanno di errore, poi comunque la coda
      $sospette = @($righe | Where-Object {
        $_ -match "(?i)error|fail|not found|no history|cannot|unknown symbol|disabled|not allowed|invalid"
      })
      if ($sospette.Count -gt 0) {
        Riga "  --- righe che parlano di errori ---" "Red"
        foreach ($r in ($sospette | Select-Object -Last $Righe)) { Riga ("    " + $r.Trim()) }
      } else {
        Riga "  nessuna riga di errore evidente nel log del tester." "Gray"
      }
      Riga "  --- coda del log ---" "Yellow"
      foreach ($r in ($righe | Select-Object -Last 15)) { Riga ("    " + $r.Trim()) }
    } else {
      Riga "  Tester\logs esiste ma e' vuota: il tester non e' mai partito qui." "Red"
    }
  } else {
    Riga "  Tester\logs NON ESISTE: il tester non e' mai partito su questa cartella dati." "Red"
  }

  #  Il log di Tester\logs e' spesso quasi vuoto: le passate vere girano
  #  negli AGENTI, che hanno i loro log. E' li' che si trova "symbol not
  #  found" o il motivo per cui l'ottimizzazione non e' partita.
  $agenti = @(Get-ChildItem (Join-Path $dir.FullName "Tester") -Directory -EA SilentlyContinue |
              Where-Object { $_.Name -like "Agent*" })
  foreach ($ag in $agenti) {
    $al = Join-Path $ag.FullName "logs"
    if (-not (Test-Path $al)) { continue }
    $af = @(Get-ChildItem $al -Filter "*.log" -EA SilentlyContinue |
            Sort-Object LastWriteTime -Descending | Select-Object -First 1)
    if ($af.Count -eq 0) { continue }
    $atxt = Leggi-Testo $af[0].FullName
    $ar = @($atxt -split "`r?`n" | Where-Object { $_.Trim() -ne "" })
    if ($ar.Count -eq 0) { continue }
    Riga ("  agente " + $ag.Name + " -> " + $af[0].Name + "  (" + $af[0].LastWriteTime + ")") "Yellow"
    foreach ($r in ($ar | Select-Object -Last 12)) { Riga ("    " + $r.Trim()) }
  }

  # ---------------------------------------------------------------
  #  2-bis. IL GIORNALE DEL TERMINALE
  #     Mancava nella prima stesura: e' qui che MT5 scrive "unknown
  #     symbol", "cannot open" e i motivi per cui il tester non parte.
  # ---------------------------------------------------------------
  $gio = Join-Path $dir.FullName "logs"
  if (Test-Path $gio) {
    $gf = @(Get-ChildItem $gio -Filter "*.log" -EA SilentlyContinue |
            Sort-Object LastWriteTime -Descending | Select-Object -First 1)
    if ($gf.Count -gt 0) {
      $gt = Leggi-Testo $gf[0].FullName
      $gr = @($gt -split "`r?`n" | Where-Object { $_.Trim() -ne "" })
      $gs = @($gr | Where-Object {
        $_ -match "(?i)error|fail|not found|no history|cannot|unknown|symbol|tester|optimi"
      })
      Riga ("  giornale " + $gf[0].Name + ": " + $gr.Count + " righe, " + $gs.Count + " interessanti") "Yellow"
      foreach ($r in ($gs | Select-Object -Last $Righe)) { Riga ("    " + $r.Trim()) }
    }
  }

  # ---------------------------------------------------------------
  #  3. I CSV che l'EA avrebbe dovuto scrivere
  # ---------------------------------------------------------------
  $files = Join-Path $dir.FullName "MQL5\Files"
  if (Test-Path $files) {
    $csv = @(Get-ChildItem $files -Filter "OptResults_*.csv" -EA SilentlyContinue |
             Sort-Object LastWriteTime -Descending | Select-Object -First 8)
    if ($csv.Count -gt 0) {
      Riga ("  CSV OptResults_ presenti: " + $csv.Count + " (i piu' recenti)") "Green"
      foreach ($c in $csv) { Riga ("    " + $c.Name + "   " + $c.LastWriteTime) }
    } else {
      Riga "  nessun CSV OptResults_ in MQL5\Files." "Yellow"
    }
  }
  Riga ""
}

# -----------------------------------------------------------------
#  4. L'INI CHE E' STATO DAVVERO PASSATO AL TERMINALE
#     Serve a vedere con i propri occhi cosa c'era dentro, blocco
#     [Experts] compreso.
# -----------------------------------------------------------------
$iniDir = Join-Path $env:TEMP "ini_regime"
Riga "--- l'ultimo .ini generato da prova_regime ---" "Yellow"
if (Test-Path $iniDir) {
  $ini = @(Get-ChildItem $iniDir -Filter "*.ini" -EA SilentlyContinue |
           Sort-Object LastWriteTime -Descending | Select-Object -First 1)
  if ($ini.Count -gt 0) {
    Riga ("  " + $ini[0].FullName) "Green"
    foreach ($r in (Get-Content $ini[0].FullName)) { Riga ("    " + $r) }
  } else { Riga "  la cartella c'e' ma non contiene .ini" "Red" }
} else {
  Riga ("  " + $iniDir + " non esiste: prova_regime non ha scritto nessun ini.") "Red"
}

$dest = Join-Path $env:USERPROFILE "diagnosi_tester.txt"
$out | Set-Content -Path $dest -Encoding ASCII
Write-Host ""
Write-Host "=== REFERTO (mandamelo) ===" -ForegroundColor Cyan
Write-Host "  $dest" -ForegroundColor White
