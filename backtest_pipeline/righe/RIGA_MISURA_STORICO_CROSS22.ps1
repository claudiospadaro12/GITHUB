# =====================================================================
#  MARCATORE_RIGA_MISURA_STORICO_CROSS22_v1
#  RIGA_MISURA_STORICO_CROSS22.ps1 -- PASSO 0 di R92b: la PROFONDITA' delle
#  BARRE M1 dei 22 cross del basket BULGE a BCM (senza tick).
# ---------------------------------------------------------------------
#  PERCHE' ESISTE
#  R92b (firma di Claudio 29/09/2026, report/FIRME_2026-09-29_BULGE_R92B.md)
#  misura ABTG_Bulge v5.20 sul cesto dei 22 cross. La profondita' dei dati
#  dei 21 cross diversi da GBPUSD NON e' mai stata misurata (R92: "difetto
#  n.18, mezza finestra che non esiste"). Questo passo lo misura, prima di
#  qualunque passata. Da qui dipende se esiste una finestra fuori campione
#  piu' vecchia del 2022.
#
#  COSA FA: pilota scarica_storico.ps1 (gia' in casa) con -SenzaTick,
#  timeframe M1, sui 22 simboli, poi impagina il referto.
#
#  ###################################################################
#  #  SOLO SUL PC DI BACKTEST DESKTOP-H4D7CAJ -- MAI SUL VPS.        #
#  #  scarica_storico.ps1 con -Auto apre e chiude MT5 da solo.       #
#  ###################################################################
#  Non tocca preset, EA, sedie, conti, taglie. Nessun round parte da qui.
# =====================================================================
[CmdletBinding()]
param(
  [string]$Pin        = "",
  [string]$Simboli    = "EURUSD,GBPUSD,AUDUSD,NZDUSD,USDCAD,USDCHF,USDJPY,EURGBP,EURNZD,GBPJPY,GBPAUD,GBPCAD,GBPNZD,AUDJPY,AUDCAD,AUDNZD,NZDJPY,NZDCAD,NZDCHF,CADJPY,CADCHF,CHFJPY",
  [string]$Da         = "2010.01.01",
  [string]$Timeframes = "M1",
  [int]   $TimeoutMin = 180
)

$ErrorActionPreference = "Stop"
[Threading.Thread]::CurrentThread.CurrentCulture   = [Globalization.CultureInfo]::InvariantCulture
[Threading.Thread]::CurrentThread.CurrentUICulture = [Globalization.CultureInfo]::InvariantCulture
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$INV = [Globalization.CultureInfo]::InvariantCulture

if($env:COMPUTERNAME -ne 'DESKTOP-H4D7CAJ'){
  throw ('VIETATO: questa riga gira SOLO sul PC di backtest DESKTOP-H4D7CAJ. Macchina attuale: ' + $env:COMPUTERNAME + '. Non ho scaricato ne scritto niente.')
}
if($Pin -notmatch '^[0-9a-fA-F]{40}$'){
  Write-Host "!!! PIN MANCANTE O NON VALIDO: senza, non parte." -ForegroundColor Red
  exit 1
}
$Pin    = $Pin.ToLower()
$RawPin = "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$Pin"

$Avvio = Get-Date
$Stamp = $Avvio.ToString("yyyyMMdd_HHmm",$INV)
$Dsk   = [Environment]::GetFolderPath("Desktop")
if([string]::IsNullOrWhiteSpace($Dsk)){ $Dsk = Join-Path $env:USERPROFILE "Desktop" }

$Base  = Join-Path $env:USERPROFILE "abtg_misura_storico_cross22"
$DirBT = Join-Path $Base "backtest_pipeline"
$DirMQ = Join-Path $Base "mql5\Scripts"
New-Item -ItemType Directory -Force -Path $DirBT,$DirMQ | Out-Null

$Cart       = Join-Path $Dsk ("MISURA_STORICO_CROSS22_" + $Stamp)
New-Item -ItemType Directory -Force -Path $Cart | Out-Null
$RefertoOut = Join-Path $Cart "REFERTO_MISURA_STORICO_CROSS22.txt"
$CsvRinom   = Join-Path $Cart "misura_storico_cross22.csv"

function Ora(){ return (Get-Date).ToString("HH:mm:ss",$INV) }
function Dico($t,$c="Gray"){ Write-Host ("[" + (Ora) + "] " + $t) -ForegroundColor $c }
function Titolo($t){ Write-Host ""; Write-Host ("=== " + $t + " ===") -ForegroundColor Cyan }

function Scarica($url,$dest,$marcatore){
  Remove-Item -LiteralPath $dest -Force -ErrorAction SilentlyContinue
  Invoke-WebRequest -Uri $url -OutFile $dest -UseBasicParsing -ErrorAction Stop
  if(-not (Test-Path -LiteralPath $dest)){ throw ("scarico fallito: " + $url) }
  if($marcatore -ne "" -and -not (Select-String -LiteralPath $dest -SimpleMatch -Pattern $marcatore -Quiet)){
    throw ("file scaricato SENZA il marcatore atteso '" + $marcatore + "': " + $url)
  }
}

$lista = @($Simboli.Split(',') | ForEach-Object { $_.Trim().ToUpper() } | Where-Object { $_ -ne '' })
Write-Host ""
Write-Host "#####################################################################" -ForegroundColor Cyan
Write-Host "#  PASSO 0 DI R92b -- PROFONDITA' BARRE M1 DEI 22 CROSS @ BCM" -ForegroundColor Cyan
Write-Host "#####################################################################" -ForegroundColor Cyan
Write-Host "  SOLO SUL PC DI BACKTEST DESKTOP-H4D7CAJ. Il VPS VMI3047753 e tutte le" -ForegroundColor Yellow
Write-Host "  sue cartelle (FTMO 541452707, REALE 10105439, piccolo 50503392, 100k" -ForegroundColor Yellow
Write-Host "  50504263, manuale 50503635, banco 50504400, Pepperstone, Tickmill) NON toccati." -ForegroundColor Yellow
Dico ("pin      : " + $Pin)
Dico ("simboli  : " + $lista.Count + "  da " + $Da + "  TF " + $Timeframes + "  senza tick")
Dico ("raccolta : " + $Cart)
if($lista.Count -ne 22){ Write-Host ("  ATTENZIONE: i simboli sono " + $lista.Count + ", non 22.") -ForegroundColor Red }

Titolo "F1 - strumenti dal pin (con marcatore)"
$Scar = Join-Path $DirBT "scarica_storico.ps1"
$Mq5  = Join-Path $DirMQ "ABTG_HistoryDownloader.mq5"
Scarica ("$RawPin/backtest_pipeline/scarica_storico.ps1") $Scar 'scarica lo STORICO dal broker'
Scarica ("$RawPin/mql5/Scripts/ABTG_HistoryDownloader.mq5") $Mq5 'Scarica lo STORICO dei prezzi dal broker'
Write-Host ("   scarica_storico.ps1        -> " + $Scar) -ForegroundColor Green
Write-Host ("   ABTG_HistoryDownloader.mq5 -> " + $Mq5) -ForegroundColor Green

$rigaArg = ("-Simboli <22 cross> -Da " + $Da + " -Timeframes " + $Timeframes + " -TimeoutMin " + $TimeoutMin + " -SenzaTick -Auto")
Titolo ("F2 - corsa  (" + $rigaArg + ")")
Write-Host "   Se scarica_storico.ps1 trova MT5 APERTO esce con 1 e lo dice: chiudi MT5 e rilancia." -ForegroundColor DarkGray
$rcChild = 0
$oldEA = $ErrorActionPreference
$ErrorActionPreference = "Continue"
$global:LASTEXITCODE = 0
try{
  & powershell -ExecutionPolicy Bypass -File $Scar -Simboli ($lista -join ',') -Da $Da -Timeframes $Timeframes -TimeoutMin $TimeoutMin -SenzaTick -Auto
  $rcChild = $LASTEXITCODE
}catch{
  $rcChild = 99
  Write-Host ("   eccezione lanciando scarica_storico.ps1: " + $_.Exception.Message) -ForegroundColor Red
}finally{ $ErrorActionPreference = $oldEA }
if($null -eq $rcChild){ $rcChild = 0 }
Write-Host ("   scarica_storico.ps1 uscito con codice: " + $rcChild) -ForegroundColor $(if($rcChild -eq 0){"Green"}else{"Yellow"})

Titolo "F3 - trova il CSV prodotto (solo se scritto DOPO l'avvio)"
function TrovaCsvDati(){
  $allTerm = Get-ChildItem "C:\Program Files","C:\Program Files (x86)" -Recurse -Filter "terminal64.exe" -ErrorAction SilentlyContinue
  $cand = $allTerm | Where-Object { $_.DirectoryName -like "*BCM Markets MT5 Terminal*" -and $_.DirectoryName -notlike "*-V3*" } | Select-Object -First 1
  if(-not $cand){ return $null }
  $instDir = $cand.DirectoryName
  $termRoot = Join-Path $env:APPDATA "MetaQuotes\Terminal"
  $df = Get-ChildItem $termRoot -Directory -ErrorAction SilentlyContinue | Where-Object {
    $o = Join-Path $_.FullName "origin.txt"
    (Test-Path $o) -and ((Get-Content $o -Raw).Trim() -ieq $instDir)
  } | Select-Object -First 1 -ExpandProperty FullName
  if(-not $df){ return $null }
  return (Join-Path $df "MQL5\Files\ABTG_StoricoScaricato.csv")
}
$csvFonte = $null
$candidati = @()
$c1 = TrovaCsvDati
if($c1){ $candidati += $c1 }
$candidati += (Join-Path $Dsk "storico_bcm\ABTG_StoricoScaricato.csv")
foreach($c in $candidati){
  if($c -and (Test-Path -LiteralPath $c)){
    $lw = (Get-Item -LiteralPath $c).LastWriteTime
    if($lw -ge $Avvio.AddMinutes(-1)){
      $csvFonte = $c
      Write-Host ("   CSV trovato (fresco): " + $c) -ForegroundColor Green
      break
    } else {
      Write-Host ("   scartato (vecchio, LastWrite " + $lw.ToString("yyyy-MM-dd HH:mm",$INV) + "): " + $c) -ForegroundColor DarkYellow
    }
  }
}

Titolo "F4 - referto"
$righe = @()
$nota = ""
if($csvFonte){
  try{
    Copy-Item -LiteralPath $csvFonte -Destination $CsvRinom -Force
    $tutte = Import-Csv -LiteralPath $CsvRinom
    $righe = @($tutte | Where-Object { ($lista -contains $_.Simbolo) -and ($_.Timeframe -eq "M1") })
  }catch{
    $nota = "CSV trovato ma NON leggibile: " + $_.Exception.Message
  }
} else {
  $nota = "NESSUN CSV FRESCO TROVATO: la corsa non ha prodotto un referto scritto dopo l'avvio (rc=" + $rcChild + ")."
}
$trovati = @($righe | ForEach-Object { $_.Simbolo } | Sort-Object -Unique)
$mancanti = @($lista | Where-Object { $trovati -notcontains $_ })

$L = New-Object System.Collections.ArrayList
[void]$L.Add("PASSO 0 DI R92b -- PROFONDITA' DELLE BARRE M1 DEI 22 CROSS @ BCM")
[void]$L.Add("data: " + (Get-Date).ToString("yyyy-MM-dd HH:mm:ss",$INV) + "   (corsa partita alle " + $Avvio.ToString("yyyy-MM-dd HH:mm:ss",$INV) + ")")
[void]$L.Add("macchina: " + $env:COMPUTERNAME + "   script: scarica_storico.ps1 pinnato a " + $Pin)
[void]$L.Add("riga: " + $rigaArg)
[void]$L.Add("codice di uscita (scarica_storico.ps1): " + $rcChild)
[void]$L.Add("simboli con riga M1: " + $trovati.Count + " su " + $lista.Count)
if($mancanti.Count -gt 0){ [void]$L.Add("SIMBOLI SENZA RIGA M1 (NON MISURATI): " + ($mancanti -join ", ")) }
[void]$L.Add("")
[void]$L.Add("SIMBOLO  barre  prima_data_locale  prima_data_server  verdetto")
foreach($r in @($righe | Sort-Object Simbolo)){
  [void]$L.Add(($r.Simbolo + "  " + $r.Barre + "  locale=" + $r.PrimaDataLocale + "  server=" + $r.PrimaDataServer + "  -> " + $r.Verdetto))
}
if($nota -ne ""){ [void]$L.Add(""); [void]$L.Add("NOTA: " + $nota) }
[void]$L.Add("")
[void]$L.Add("COME SI LEGGE: la colonna che decide e' la PRIMA DATA VERA per simbolo.")
[void]$L.Add(" - una prima data di server dopo il 2022.01.01: quel cross ha girato su mezza finestra in R92.")
[void]$L.Add(" - una prima data prima del 2010: esiste una finestra fuori campione lunga.")
[void]$L.Add(" - il tetto di 100.000 barre M1 del terminale puo' tagliare la prima data: se il verdetto lo dice, la misura e' un MINIMO, non il muro del broker.")
Set-Content -LiteralPath $RefertoOut -Value $L -Encoding ASCII
Get-Content -LiteralPath $RefertoOut | ForEach-Object { Write-Host $_ }

Titolo "F5 - raccolta + zip"
$srcLog = Join-Path $Dsk "storico_bcm"
if(Test-Path -LiteralPath $srcLog){
  Get-ChildItem -LiteralPath $srcLog -Filter "*.log" -ErrorAction SilentlyContinue |
    Sort-Object LastWriteTime -Descending | Select-Object -First 2 |
    ForEach-Object { Copy-Item -LiteralPath $_.FullName -Destination $Cart -Force -ErrorAction SilentlyContinue }
}
$Zip = Join-Path $Dsk ("MISURA_STORICO_CROSS22_" + $Stamp + ".zip")
try{ Compress-Archive -Path (Join-Path $Cart "*") -DestinationPath $Zip -Force }catch{ }
Write-Host ""
Write-Host ("RACCOLTA: " + $Cart) -ForegroundColor Green
Write-Host ("ZIP PRONTO DA MANDARE: " + $Zip) -ForegroundColor Green
Write-Host "Verifica che dentro ci siano:" -ForegroundColor DarkGray
Write-Host "   - REFERTO_MISURA_STORICO_CROSS22.txt" -ForegroundColor DarkGray
Write-Host "   - misura_storico_cross22.csv" -ForegroundColor DarkGray
Write-Host "   - gli ultimi log di MT5 (*.log), se prodotti" -ForegroundColor DarkGray

if(($trovati.Count -eq $lista.Count) -and ($rcChild -eq 0)){
  Write-Host ""
  Write-Host "MISURA COMPLETA: riga M1 per tutti i simboli e corsa terminata bene." -ForegroundColor Green
  exit 0
}
Write-Host ""
Write-Host "ATTENZIONE: MISURA PARZIALE." -ForegroundColor Red
if($mancanti.Count -gt 0){ Write-Host ("  senza riga M1: " + ($mancanti -join ", ")) -ForegroundColor Red }
if($rcChild -ne 0){ Write-Host ("  scarica_storico.ps1 e' uscito con " + $rcChild + " (2 = timeout/parziale).") -ForegroundColor Red }
Write-Host "  Il referto e lo zip ci sono lo stesso: chi legge decide." -ForegroundColor Yellow
exit 2
