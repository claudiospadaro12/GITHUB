# =====================================================================
#  lancia_r55.ps1  --  ROUND 55: QUANTO SLIPPAGE REGGE OGNI CELLA
# ---------------------------------------------------------------------
#  COSA FA:
#    1. riscarica walkforward_generico.ps1 e i due file prova PINNATI
#       allo stesso commit (-Rif): mai la copia vecchia;
#    2. lancia R55a (ABTG_PTE, ingresso A MERCATO) e R55b
#       (ABTG_ORB_Ottimizzato, ingresso a STOP), uno dopo l'altro;
#    3. raccoglie i CSV sul Desktop in \r55 e ne fa lo zip, con
#       l'elenco dei file attesi controllato uno per uno.
#
#  DOVE: sul PC di BACKTEST, con MT5 CHIUSO. MAI SUL VPS.
#
#  QUANTO DURA: 5 valori di slippage x 2 magic x 2 finestre x 2 EA =
#  40 passate. Il PTE gira su H1 (veloce), l'ORB su M5.
#
#  PRIMA VOLTA CHE SI COMPILANO ABTG_PTE v1.01 e ABTG_ORB_Ottimizzato
#  v1.01 con InpSlippagePts. DEFAULT 0 = comportamento identico a
#  prima: il forward NON cambia per costruzione. Se la compilazione
#  fallisce lo dice qui sotto e il round si ferma prima di sprecare
#  macchina.
#
#  COSA MISURA (e cosa NO, che qui conta):
#    Misura quanto edge resta con un'esecuzione peggiore, su celle che
#    entrano a MERCATO (PTE) e a STOP (ORB) - le due piu' esposte del
#    portafoglio. NON misura il riempimento parziale ne' la profondita'
#    del book: MT5 non li modella, e nessun backtest rispondera' mai a
#    quella domanda. Le celle a LIMIT (DAX/Dow Apertura in RETEST,
#    EMA200, EasyTrend) non partecipano: per loro il tester non ha
#    niente da dire.
#
#  I CRITERI sono congelati in prove\R55_SCALABILITA_TESI.md e si
#  leggono PRIMA della tabella. Da questo round NON esce nessun cambio
#  ai parametri vivi, e nessuna autorizzazione a nessuna taglia.
# =====================================================================
param(
  [string]$Rif      = "lavoro",                        # commit SHA (o branch)
  [string]$Cartella = (Join-Path $env:USERPROFILE "r55"),
  [int]$Deposito    = 100000,
  [switch]$SoloControllo,                              # stampa l'ini e NON lancia MT5
  [switch]$SoloA,                                      # solo il PTE
  [switch]$SoloB                                       # solo l'ORB
)
$ErrorActionPreference = "Stop"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$Raw = "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$Rif"

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

Write-Host "=== ROUND 55 - QUANTO SLIPPAGE REGGE OGNI CELLA ===" -ForegroundColor Cyan
Write-Host ("MACCHINA: " + $env:COMPUTERNAME + "   utente: " + $env:USERNAME) -ForegroundColor Cyan
Write-Host ("riferimento: " + $Rif) -ForegroundColor DarkGray

if (Get-Process -Name "terminal64" -ErrorAction SilentlyContinue) {
  Muori "MetaTrader e' APERTO. Chiudilo prima di lanciare, altrimenti escono 0 CSV."
}

Write-Host ""
Write-Host "    40 passate. Prima compilazione di ABTG_PTE v1.01 e" -ForegroundColor Yellow
Write-Host "    ABTG_ORB_Ottimizzato v1.01 con InpSlippagePts (default 0)." -ForegroundColor Yellow

# =====================================================================
#  1. ATTREZZI (riscaricati sempre)
# =====================================================================
Titolo "1) attrezzi (riscaricati sempre, mai la copia vecchia)"
$Prove = Join-Path $Cartella "prove"
New-Item -ItemType Directory -Force -Path $Prove | Out-Null

$file = @{
  "walkforward_generico.ps1"          = "$Raw/backtest_pipeline/walkforward_generico.ps1"
  "prove\R55a_slippage_PTE.txt"       = "$Raw/backtest_pipeline/prove/R55a_slippage_PTE.txt"
  "prove\R55b_slippage_ORB.txt"       = "$Raw/backtest_pipeline/prove/R55b_slippage_ORB.txt"
  "prove\R55_SCALABILITA_TESI.md"     = "$Raw/backtest_pipeline/prove/R55_SCALABILITA_TESI.md"
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
#  2. I DUE LANCI
# =====================================================================
$wf = Join-Path $Cartella "walkforward_generico.ps1"
$giri = @()
if (-not $SoloB) { $giri += @{ EA="ABTG_PTE";             Prova="prove\R55a_slippage_PTE.txt"; Tag="r55a"; Nota="ingresso A MERCATO" } }
if (-not $SoloA) { $giri += @{ EA="ABTG_ORB_Ottimizzato"; Prova="prove\R55b_slippage_ORB.txt"; Tag="r55b"; Nota="ingresso a STOP" } }

foreach ($g in $giri) {
  Titolo ("2) " + $g.Tag + " - " + $g.EA + "   (" + $g.Nota + ")")
  $arg = @("-ExecutionPolicy","Bypass","-File",$wf,$g.EA,
           "-Prova",$g.Prova,"-Simbolo","U30USD","-Deposito","$Deposito","-Etichetta",$g.Tag)
  if ($SoloControllo) { $arg += "-SoloControllo" }
  & powershell $arg
  if ($LASTEXITCODE -ne 0) {
    Write-Host ("    " + $g.Tag + " e' uscito con codice " + $LASTEXITCODE + ": vado avanti, la raccolta dira' cosa manca.") -ForegroundColor Yellow
  }
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
$dest = Join-Path $desk "r55"
if (Test-Path $dest) { Remove-Item $dest -Recurse -Force -ErrorAction SilentlyContinue }
New-Item -ItemType Directory -Force -Path $dest | Out-Null

$attesi = @()
if (-not $SoloB) { $attesi += @("ABTG_PTE_U30USD_IS_r55a.csv","ABTG_PTE_U30USD_OOS_r55a.csv") }
if (-not $SoloA) { $attesi += @("ABTG_ORB_Ottimizzato_U30USD_IS_r55b.csv","ABTG_ORB_Ottimizzato_U30USD_OOS_r55b.csv") }

$radice = Join-Path $Cartella "risultati_prove"
if (Test-Path $radice) {
  foreach ($f in (Get-ChildItem $radice -Recurse -Filter "*r55*.csv" -ErrorAction SilentlyContinue)) {
    Copy-Item $f.FullName (Join-Path $dest $f.Name) -Force
  }
}
foreach ($n in @("R55a_slippage_PTE.txt","R55b_slippage_ORB.txt","R55_SCALABILITA_TESI.md")) {
  Copy-Item (Join-Path $Prove $n) $dest -Force -ErrorAction SilentlyContinue
}

Write-Host ""
Write-Host "    FILE ATTESI (controllali uno per uno):" -ForegroundColor White
$mancanti = 0
foreach ($a in $attesi) {
  if (Test-Path (Join-Path $dest $a)) { Write-Host ("      OK      " + $a) -ForegroundColor Green }
  else { Write-Host ("      MANCA  " + $a) -ForegroundColor Red; $mancanti++ }
}

$zip = Join-Path $desk "r55.zip"
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
  Write-Host ("=== TUTTI E " + $attesi.Count + " I CSV CI SONO. ===") -ForegroundColor Green
  Write-Host "    Controllo d'igiene numero uno: la riga con slippage 0 deve" -ForegroundColor Gray
  Write-Host "    riprodurre i numeri gia' noti della cella. Se non lo fa," -ForegroundColor Gray
  Write-Host "    il round non vale e si guarda cosa e' cambiato nell'EA." -ForegroundColor Gray
}
