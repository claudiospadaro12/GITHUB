# =====================================================================
#  lancia_r51.ps1  --  ROUND 51: IL SECONDO CICLO DEL DAX (InpAllowReverse)
# ---------------------------------------------------------------------
#  COSA FA:
#    1. riscarica walkforward_generico.ps1 e prove\R51_reverse_DAX.txt
#       PINNATI allo stesso commit (-Rif): mai la copia vecchia;
#    2. lancia il walk-forward su D30EUR M5;
#    3. raccoglie i 2 CSV sul Desktop in \r51 e ne fa lo zip, con
#       l'elenco dei file attesi controllato uno per uno.
#
#  DOVE: sul PC di BACKTEST ("Master"), con MT5 CHIUSO. MAI SUL VPS.
#
#  QUANTO DURA: 4 celle x 2 finestre = 8 passate a tick reali su M5.
#  E' CORTO - il piu' corto degli ultimi round.
#
#  COSA MISURA (e cosa NO, che qui conta):
#    Le due righe sono la STESSA cella validata, con InpAllowReverse
#    spento e acceso. Quindi da questo lancio si leggono:
#      - criterio 1 (FREQUENZA): la differenza di trade fra le due
#        righe E' il numero di attivazioni del secondo ciclo;
#      - criterio 3 (IL CANCELLO DEL DRAWDOWN, quello che decide);
#      - criterio 4 (due banchi: IS e OOS nella stessa direzione);
#      - il profitto INCREMENTALE del secondo ciclo.
#    NON si leggono da qui, e non si fanno finta di leggere:
#      - criterio 2 (PF sui SOLI trade del secondo ciclo): il CSV di
#        ottimizzazione da' solo aggregati, e il PF non e' additivo;
#      - criterio 5 (simmetria long/short di ritorno): i due casi
#        stanno dentro la stessa riga e non sono separabili qui.
#    Tutti e due richiedono il giro PER-TRADE, che e' il criterio 6 e
#    si fa SOLO se il cancello del drawdown passa. E' l'ordine giusto:
#    prima quello che boccia, poi quello che costa.
#
#  IL VERDETTO LO DA' IL DRAWDOWN, NON IL PF. Criteri per esteso in
#  prove\R51_REVERSE_TESI.md e in testa al file prova.
# =====================================================================
param(
  [string]$Rif      = "lavoro",                        # commit SHA (o branch)
  [string]$Cartella = (Join-Path $env:USERPROFILE "r51"),
  [int]$Deposito    = 100000,                          # taglia prop, come gli ultimi round
  [switch]$SoloControllo                               # stampa l'ini e NON lancia MT5
)
$ErrorActionPreference = "Stop"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$Raw = "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$Rif"
$EA  = "ABTG_DAX_Apertura_EU"
$SYM = "D30EUR"

function Titolo($t) { Write-Host ""; Write-Host $t -ForegroundColor Cyan }
function Muori($t)  { Write-Host ""; Write-Host "!!! $t" -ForegroundColor Red; exit 1 }

function Trova-Desktop {
  $c = @()
  try { $c += [Environment]::GetFolderPath("Desktop") } catch {}
  $c += (Join-Path $env:USERPROFILE "Desktop")
  $c += (Join-Path $env:USERPROFILE "OneDrive\Desktop")
  foreach ($d in $c) { if ($d -and (Test-Path $d)) { return $d } }
  return $env:USERPROFILE
}

Write-Host "=== ROUND 51 - IL SECONDO CICLO DEL DAX ===" -ForegroundColor Cyan
Write-Host ("MACCHINA: " + $env:COMPUTERNAME + "   utente: " + $env:USERNAME) -ForegroundColor Cyan
Write-Host ("riferimento: " + $Rif) -ForegroundColor DarkGray

if (Get-Process -Name "terminal64" -ErrorAction SilentlyContinue) {
  Muori "MetaTrader e' APERTO. Chiudilo prima di lanciare, altrimenti escono 0 CSV."
}

Write-Host ""
Write-Host "    Prima volta che si compila l'EA con InpAllowReverse (v1.01)." -ForegroundColor Yellow
Write-Host "    Se la compilazione fallisce lo dice qui sotto: NON e' un problema" -ForegroundColor Yellow
Write-Host "    di dati, e il round si ferma prima di sprecare macchina." -ForegroundColor Yellow

# =====================================================================
#  1. ATTREZZI (riscaricati sempre)
# =====================================================================
Titolo "1) attrezzi (riscaricati sempre, mai la copia vecchia)"
$Prove = Join-Path $Cartella "prove"
New-Item -ItemType Directory -Force -Path $Prove | Out-Null

$file = @{
  "walkforward_generico.ps1"     = "$Raw/backtest_pipeline/walkforward_generico.ps1"
  "prove\R51_reverse_DAX.txt"    = "$Raw/backtest_pipeline/prove/R51_reverse_DAX.txt"
  "prove\R51_REVERSE_TESI.md"    = "$Raw/backtest_pipeline/prove/R51_REVERSE_TESI.md"
}
foreach ($k in $file.Keys) {
  $dest = Join-Path $Cartella $k
  try {
    Invoke-WebRequest -Uri $file[$k] -OutFile $dest -UseBasicParsing
    Write-Host ("    ok  " + $k) -ForegroundColor Green
  } catch {
    Muori ("non sono riuscito a scaricare " + $k + " da " + $Rif + "`n    " + $_.Exception.Message)
  }
}

# =====================================================================
#  2. IL LANCIO
# =====================================================================
Titolo "2) walk-forward - $EA su $SYM M5"
$wf  = Join-Path $Cartella "walkforward_generico.ps1"
$arg = @("-ExecutionPolicy","Bypass","-File",$wf,$EA,
         "-Prova","prove\R51_reverse_DAX.txt","-Simbolo",$SYM,
         "-Deposito","$Deposito","-Etichetta","r51")
if ($SoloControllo) { $arg += "-SoloControllo" }
& powershell $arg
if ($LASTEXITCODE -ne 0) {
  Write-Host ("    uscito con codice " + $LASTEXITCODE + ": vado avanti, la raccolta dira' cosa manca.") -ForegroundColor Yellow
}

if ($SoloControllo) {
  Write-Host ""
  Write-Host "SoloControllo: nessuna passata lanciata, nessun CSV da raccogliere." -ForegroundColor Yellow
  exit 0
}

# =====================================================================
#  3. RACCOLTA SUL DESKTOP + ZIP  (regola delle righe di lancio)
# =====================================================================
Titolo "3) raccolta sul Desktop"
$desk = Trova-Desktop
$dest = Join-Path $desk "r51"
if (Test-Path $dest) { Remove-Item $dest -Recurse -Force -ErrorAction SilentlyContinue }
New-Item -ItemType Directory -Force -Path $dest | Out-Null

$attesi = @(($EA + "_" + $SYM + "_IS_r51.csv"), ($EA + "_" + $SYM + "_OOS_r51.csv"))

$radice = Join-Path $Cartella "risultati_prove"
if (Test-Path $radice) {
  foreach ($f in (Get-ChildItem $radice -Recurse -Filter "*r51*.csv" -ErrorAction SilentlyContinue)) {
    Copy-Item $f.FullName (Join-Path $dest $f.Name) -Force
  }
}
Copy-Item (Join-Path $Prove "R51_reverse_DAX.txt") $dest -Force -ErrorAction SilentlyContinue
Copy-Item (Join-Path $Prove "R51_REVERSE_TESI.md") $dest -Force -ErrorAction SilentlyContinue

Write-Host ""
Write-Host "    FILE ATTESI (controllali uno per uno):" -ForegroundColor White
$mancanti = 0
foreach ($a in $attesi) {
  if (Test-Path (Join-Path $dest $a)) { Write-Host ("      OK      " + $a) -ForegroundColor Green }
  else { Write-Host ("      MANCA  " + $a) -ForegroundColor Red; $mancanti++ }
}

$zip = Join-Path $desk "r51.zip"
if (Test-Path $zip) { Remove-Item $zip -Force -ErrorAction SilentlyContinue }
try {
  Compress-Archive -Path (Join-Path $dest "*") -DestinationPath $zip -Force
  Write-Host ""
  Write-Host ("    ZIP PRONTO DA MANDARE:  " + $zip) -ForegroundColor Cyan
} catch {
  Write-Host ""
  Write-Host ("!!! lo zip NON e' stato creato: " + $_.Exception.Message) -ForegroundColor Red
  Write-Host ("    i file comunque sono qui: " + $dest) -ForegroundColor Yellow
}

Write-Host ""
if ($mancanti -gt 0) {
  Write-Host ("=== $mancanti CSV su " + $attesi.Count + " MANCANO. Guarda sopra qual e' stato l'errore. ===") -ForegroundColor Red
} else {
  Write-Host "=== TUTTI E DUE I CSV CI SONO. ===" -ForegroundColor Green
  Write-Host "    Prima di guardarli: il verdetto lo da' il DRAWDOWN, non il PF." -ForegroundColor Gray
}
