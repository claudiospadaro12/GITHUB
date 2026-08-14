# =====================================================================
#  lancia_r53.ps1  --  ROUND 53: DOVE CADE LA FASCIA ORARIA DI EASY TREND
# ---------------------------------------------------------------------
#  COSA FA:
#    1. riscarica walkforward_generico.ps1 e prove\R53_fuso_EZ.txt
#       PINNATI allo stesso commit (-Rif): mai la copia vecchia;
#    2. lancia i QUATTRO simboli della famiglia, uno dopo l'altro
#       (GBPUSD, EURGBP, AUDJPY, CHFJPY) - il tester serializza;
#    3. raccoglie gli 8 CSV sul Desktop in \r53 e ne fa lo zip, con
#       l'elenco dei file attesi controllato uno per uno.
#
#  DOVE: sul PC di BACKTEST ("Master"), con MT5 CHIUSO. MAI SUL VPS.
#
#  QUANTO DURA: 16 celle x 2 finestre x 4 simboli = 128 passate a tick
#  reali su H1. E' il round piu' lungo che abbiamo lanciato: si mette
#  su e si lascia stare. Se serve spezzarlo, c'e' -Simboli.
#
#  COSA SI MISURA (e cosa NO): si cerca DOVE CADE la fascia della
#  fonte, non la fascia migliore. Le celle che contano sono solo le
#  QUATTRO DIAGONALI (6-16, 7-17, 8-18, 9-19), una per fuso reale; le
#  altre 12 hanno larghezza sbagliata e NON sono candidate. Un fuso
#  vince solo se vince su ALMENO 3 SIMBOLI SU 4. Criteri per esteso in
#  testa a prove\R53_fuso_EZ.txt: si leggono PRIMA della tabella.
# =====================================================================
param(
  [string]$Rif      = "lavoro",                        # commit SHA (o branch)
  [string]$Cartella = (Join-Path $env:USERPROFILE "r53"),
  [string]$Simboli  = "GBPUSD,EURGBP,AUDJPY,CHFJPY",   # per spezzare il round
  [int]$Deposito    = 100000,                          # come R49: sui cambi a 10k il lotto minimo schiaccia il rischio
  [switch]$SoloControllo                               # stampa l'ini e NON lancia MT5
)
$ErrorActionPreference = "Stop"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$Raw = "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$Rif"
$EA  = "ABTG_EasyTrend"

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

Write-Host "=== ROUND 53 - IL FUSO DI EASY TREND ===" -ForegroundColor Cyan
Write-Host ("MACCHINA: " + $env:COMPUTERNAME + "   utente: " + $env:USERNAME) -ForegroundColor Cyan
Write-Host ("riferimento: " + $Rif) -ForegroundColor DarkGray

if (Get-Process -Name "terminal64" -ErrorAction SilentlyContinue) {
  Muori "MetaTrader e' APERTO. Chiudilo prima di lanciare, altrimenti escono 0 CSV."
}

$lista = @($Simboli -split "," | ForEach-Object { $_.Trim() } | Where-Object { $_ })
if ($lista.Count -eq 0) { Muori "nessun simbolo da lanciare." }

Write-Host ""
Write-Host ("    " + (16 * 2 * $lista.Count) + " passate in totale a tick reali. E' lungo: lascialo girare.") -ForegroundColor Yellow

# =====================================================================
#  1. ATTREZZI (riscaricati sempre)
# =====================================================================
Titolo "1) attrezzi (riscaricati sempre, mai la copia vecchia)"
$Prove = Join-Path $Cartella "prove"
New-Item -ItemType Directory -Force -Path $Prove | Out-Null

$file = @{
  "walkforward_generico.ps1" = "$Raw/backtest_pipeline/walkforward_generico.ps1"
  "prove\R53_fuso_EZ.txt"    = "$Raw/backtest_pipeline/prove/R53_fuso_EZ.txt"
  "prove\EASY_TREND_TESI.md" = "$Raw/backtest_pipeline/prove/EASY_TREND_TESI.md"
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
#  2. I QUATTRO LANCI
# =====================================================================
$wf = Join-Path $Cartella "walkforward_generico.ps1"
$n  = 0
foreach ($sym in $lista) {
  $n++
  Titolo ("2." + $n + ") " + $sym + "   (" + $n + " di " + $lista.Count + ")")
  $arg = @("-ExecutionPolicy","Bypass","-File",$wf,$EA,
           "-Prova","prove\R53_fuso_EZ.txt","-Simbolo",$sym,
           "-Deposito","$Deposito","-Etichetta","r53")
  if ($SoloControllo) { $arg += "-SoloControllo" }
  & powershell $arg
  if ($LASTEXITCODE -ne 0) {
    Write-Host ("    " + $sym + " e' uscito con codice " + $LASTEXITCODE + ": vado avanti, la raccolta dira' cosa manca.") -ForegroundColor Yellow
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
$dest = Join-Path $desk "r53"
if (Test-Path $dest) { Remove-Item $dest -Recurse -Force -ErrorAction SilentlyContinue }
New-Item -ItemType Directory -Force -Path $dest | Out-Null

$attesi = @()
foreach ($sym in $lista) {
  $attesi += ($EA + "_" + $sym + "_IS_r53.csv")
  $attesi += ($EA + "_" + $sym + "_OOS_r53.csv")
}

$radice = Join-Path $Cartella "risultati_prove"
if (Test-Path $radice) {
  foreach ($f in (Get-ChildItem $radice -Recurse -Filter "*r53*.csv" -ErrorAction SilentlyContinue)) {
    Copy-Item $f.FullName (Join-Path $dest $f.Name) -Force
  }
}
Copy-Item (Join-Path $Prove "R53_fuso_EZ.txt") $dest -Force -ErrorAction SilentlyContinue

Write-Host ""
Write-Host "    FILE ATTESI (controllali uno per uno):" -ForegroundColor White
$mancanti = 0
foreach ($a in $attesi) {
  if (Test-Path (Join-Path $dest $a)) { Write-Host ("      OK      " + $a) -ForegroundColor Green }
  else { Write-Host ("      MANCA  " + $a) -ForegroundColor Red; $mancanti++ }
}

$zip = Join-Path $desk "r53.zip"
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
  Write-Host "    Prima di guardarli: solo le 4 celle DIAGONALI, e serve 3 simboli su 4." -ForegroundColor Gray
}
