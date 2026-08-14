# =====================================================================
#  lancia_r54.ps1  --  ROUND 54: IL LATO MAI MISURATO (Dow)
# ---------------------------------------------------------------------
#  COSA FA, in ordine:
#    1. si porta a casa walkforward_generico.ps1 e i due file prova
#       PINNATI allo stesso commit (parametro -Rif), in una cartella di
#       lavoro pulita: cosi' non si rischia di rifare la griglia
#       sbagliata con una copia vecchia (successo il 10/08 con maxmin);
#    2. lancia R54a (Dow Apertura) e R54b (ORB-EMA200 Dow), uno dopo
#       l'altro - il tester serializza comunque;
#    3. raccoglie TUTTI i CSV sul Desktop in \r54 e ne fa lo zip, con
#       l'elenco dei file attesi stampato in console.
#
#  DOVE SI LANCIA: sul PC di BACKTEST ("Master"), con MT5 CHIUSO.
#  MAI SUL VPS: qui dentro si apre e si chiude MetaTrader.
#
#  QUANTO DURA: 4 celle x 2 finestre x 2 EA = 16 passate a tick reali
#  su M5. Si lascia girare.
#
#  I CRITERI si leggono PRIMA della tabella e stanno in
#  prove\R54_LATO_MAI_MISURATO_TESI.md. Non si spostano dopo.
# =====================================================================
param(
  [string]$Rif      = "lavoro",                       # commit SHA (o branch) da cui pescare
  [string]$Cartella = (Join-Path $env:USERPROFILE "r54"),
  [switch]$SoloControllo,                             # stampa l'ini e NON lancia MT5
  [switch]$SoloA,                                     # solo il Dow Apertura
  [switch]$SoloB                                      # solo l'ORB Dow
)
$ErrorActionPreference = "Stop"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$Raw = "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$Rif"

function Titolo($t) { Write-Host ""; Write-Host $t -ForegroundColor Cyan }
function Muori($t)  { Write-Host ""; Write-Host "!!! $t" -ForegroundColor Red; exit 1 }

# --- il Desktop vero: OneDrive lo sposta, e il percorso fisso sbaglia --
function Trova-Desktop {
  $c = @()
  try { $c += [Environment]::GetFolderPath("Desktop") } catch {}
  $c += (Join-Path $env:USERPROFILE "Desktop")
  $c += (Join-Path $env:USERPROFILE "OneDrive\Desktop")
  $c += (Join-Path $env:USERPROFILE "OneDrive\Desktop")
  foreach ($d in $c) { if ($d -and (Test-Path $d)) { return $d } }
  return $env:USERPROFILE
}

Write-Host "=== ROUND 54 - IL LATO MAI MISURATO (Dow) ===" -ForegroundColor Cyan
Write-Host ("MACCHINA: " + $env:COMPUTERNAME + "   utente: " + $env:USERNAME) -ForegroundColor Cyan
Write-Host ("riferimento: " + $Rif) -ForegroundColor DarkGray

if (Get-Process -Name "terminal64" -ErrorAction SilentlyContinue) {
  Muori "MetaTrader e' APERTO. Chiudilo prima di lanciare, altrimenti escono 0 CSV."
}

# =====================================================================
#  1. SCARICO TUTTO, SEMPRE, ANCHE SE C'E' GIA'
# =====================================================================
Titolo "1) attrezzi (riscaricati sempre, mai la copia vecchia)"
$Prove = Join-Path $Cartella "prove"
New-Item -ItemType Directory -Force -Path $Prove | Out-Null

$file = @{
  "walkforward_generico.ps1"           = "$Raw/backtest_pipeline/walkforward_generico.ps1"
  "prove\R54a_lato_DOW_apertura.txt"   = "$Raw/backtest_pipeline/prove/R54a_lato_DOW_apertura.txt"
  "prove\R54b_lato_ORB_DOW.txt"        = "$Raw/backtest_pipeline/prove/R54b_lato_ORB_DOW.txt"
  "prove\R54_LATO_MAI_MISURATO_TESI.md"= "$Raw/backtest_pipeline/prove/R54_LATO_MAI_MISURATO_TESI.md"
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
if (-not $SoloB) { $giri += @{ EA="ABTG_Dow_Apertura_US"; Prova="prove\R54a_lato_DOW_apertura.txt"; Tag="r54a" } }
if (-not $SoloA) { $giri += @{ EA="ABTG_ORB_Ottimizzato";  Prova="prove\R54b_lato_ORB_DOW.txt";      Tag="r54b" } }

foreach ($g in $giri) {
  Titolo ("2) " + $g.Tag + " - " + $g.EA)
  $arg = @("-ExecutionPolicy","Bypass","-File",$wf,$g.EA,
           "-Prova",$g.Prova,"-Simbolo","U30USD","-Deposito","100000","-Etichetta",$g.Tag)
  if ($SoloControllo) { $arg += "-SoloControllo" }
  & powershell $arg
  if ($LASTEXITCODE -ne 0) {
    Write-Host ("    " + $g.Tag + " e' uscito con codice " + $LASTEXITCODE + ": vado avanti lo stesso, la raccolta dira' cosa manca.") -ForegroundColor Yellow
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
$dest = Join-Path $desk "r54"
if (Test-Path $dest) { Remove-Item $dest -Recurse -Force -ErrorAction SilentlyContinue }
New-Item -ItemType Directory -Force -Path $dest | Out-Null

$attesi = @(
  "ABTG_Dow_Apertura_US_U30USD_IS_r54a.csv",
  "ABTG_Dow_Apertura_US_U30USD_OOS_r54a.csv",
  "ABTG_ORB_Ottimizzato_U30USD_IS_r54b.csv",
  "ABTG_ORB_Ottimizzato_U30USD_OOS_r54b.csv"
)

$radice = Join-Path $Cartella "risultati_prove"
$copiati = 0
if (Test-Path $radice) {
  foreach ($f in (Get-ChildItem $radice -Recurse -Filter "*r54*.csv" -ErrorAction SilentlyContinue)) {
    Copy-Item $f.FullName (Join-Path $dest $f.Name) -Force
    $copiati++
  }
}
Copy-Item (Join-Path $Prove "R54_LATO_MAI_MISURATO_TESI.md") $dest -Force -ErrorAction SilentlyContinue
Copy-Item (Join-Path $Prove "R54a_lato_DOW_apertura.txt")    $dest -Force -ErrorAction SilentlyContinue
Copy-Item (Join-Path $Prove "R54b_lato_ORB_DOW.txt")         $dest -Force -ErrorAction SilentlyContinue

Write-Host ""
Write-Host "    FILE ATTESI (controllali uno per uno):" -ForegroundColor White
$mancanti = 0
foreach ($a in $attesi) {
  if (Test-Path (Join-Path $dest $a)) { Write-Host ("      OK      " + $a) -ForegroundColor Green }
  else { Write-Host ("      MANCA  " + $a) -ForegroundColor Red; $mancanti++ }
}

$zip = Join-Path $desk "r54.zip"
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
  Write-Host "=== TUTTI E 4 I CSV CI SONO. ===" -ForegroundColor Green
  Write-Host "    Prima di guardarli: prove\R54_LATO_MAI_MISURATO_TESI.md, criteri 1-7." -ForegroundColor Gray
}
