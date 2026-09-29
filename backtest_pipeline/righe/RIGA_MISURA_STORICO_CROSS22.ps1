# =====================================================================
#  MARCATORE_RIGA_MISURA_STORICO_CROSS22_v2
#  (il marcatore v1 resta qui sotto solo come storia: la riga di lancio
#   di oggi cerca il v2, quindi una copia v1 in cache NON parte)
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
#  timeframe M1, sul terminale NOMINATO del PC di backtest, a BLOCCHI di
#  5 simboli, in DUE PASSATE, poi impagina il referto.
#
#  v2 (29/09/2026, cancello strato 2) -- cosa e' cambiato e perche':
#   1. il terminale si NOMINA a scarica_storico.ps1 (parametro
#      TerminaleBacktest = $TB, la cartella programma di questo PC, vedi
#      sotto). Senza, scarica_storico.ps1 (RIPIEGO_BANCO_v1, dal 11/09) cerca
#      C:\MT5_Backtest, che sta sul VPS e non sul PC: sul PC usciva 1
#      subito e la misura non partiva mai. Il precedente approvato piu'
#      recente (RIGA_ROUND_CORTI_A, 28/09) lo passa gia' cosi'.
#   2. GUARDIA EA SUL PROFILO: /config apre il terminale col suo ultimo
#      profilo, EA attaccati compresi. Il 14/08 da questo PC sono partiti
#      ordini veri. [Experts] AllowLiveTrading=false (scarica_storico)
#      toglie il trading, ma un EA caricato resta un EA caricato: se un
#      qualunque grafico salvato ha un <expert>, qui NON si parte.
#   3. LA DATA CHE DECIDE e' quella del DISCO (PrimaDataLocale), MAI
#      PrimaDataServer ne' Verdetto (classe 851: sui cambi BCM il server
#      dichiara 1971/1993). E la data del disco si CONTROLLA con le barre:
#      su EURUSD/USDJPY il disco M1 dichiara 1971.01.03 (archivio R258L,
#      R259), che per M1 non e' una data vera.
#   4. DUE PASSATE: una data del disco dopo -Da puo' essere il MURO del
#      broker OPPURE uno scarico non finito (il downloader aspetta 120 s
#      a simbolo). Una data sola non li separa: se la seconda passata
#      ridice la stessa data e le stesse barre, e' il muro; se si sposta,
#      e' un MINIMO e lo si scrive.
#   5. BLOCCHI DA 5: scarica_storico.ps1 ferma MT5 dopo 15 minuti senza
#      crescita di CSV o di bases\. Un simbolo gia' sul disco col muro
#      dopo -Da tiene il downloader fermo ~120 s senza far crescere
#      nulla: 8 di fila ammazzano la corsa a meta'. 5 x 120 s = 10 min.
#
#  ###################################################################
#  #  SOLO SUL PC DI BACKTEST DESKTOP-H4D7CAJ -- MAI SUL VPS.        #
#  #  scarica_storico.ps1 con -Auto apre e chiude MT5 da solo, e     #
#  #  chiude SOLO il terminal64 di C:\Program Files\BCM Markets MT5   #
#  #  Terminal (chiusura chirurgica v3).                              #
#  ###################################################################
#  Non tocca preset, EA, sedie, conti, taglie. Nessun round parte da qui.
#
#  TEMPO: [NON MISURATO]. Tetti per costruzione: ogni chiamata a
#  scarica_storico ha -TimeoutMin (default 180); le chiamate sono 5 in
#  passata 1 e al massimo 5 in passata 2. Il tipico dipende da quanto
#  M1 il PC ha gia' sul disco e dalla banda del server BCM.
#
#  CODICI DI USCITA: 0 = esito CONCLUSIVO su tutti i 22 ; 2 = misura
#  PARZIALE (referto e zip ci sono lo stesso) ; 1 = fermato PRIMA di
#  partire (niente scaricato ne' aperto: leggi il messaggio).
#  (storia) MARCATORE_RIGA_MISURA_STORICO_CROSS22_v1
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
if($Timeframes -ne "M1"){
  Write-Host "!!! Questa misura e' tarata sul solo M1 (barre per anno, esiti): -Timeframes deve essere M1." -ForegroundColor Red
  exit 1
}
$Pin    = $Pin.ToLower()
$RawPin = "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$Pin"

# --- IL TERMINALE, NOMINATO: il SOLO bersaglio ammesso su questo PC ---
$TB    = 'C:\Program Files\BCM Markets MT5 Terminal'
$ExeTB = Join-Path $TB 'terminal64.exe'

# --- COSTANTI DELLA LETTURA (dichiarate prima dei numeri) ---
#  TOLL_GG: stessa tolleranza che scarica_storico passa al downloader
#           (InpTolleranzaGG=4): il 2010.01.01 e' festivo, la prima
#           barra vera arriva il 2010.01.03/04.
#  BARRE_ANNO: barre M1 forex per anno, MISURATE in casa sullo storico BCM:
#           R258L GBPUSD 6.888.089 dal 2007.12.28 = 367.400/anno;
#           R259 AUDUSD 2.873.662 dal 2018.12.28 = 370.800/anno.
#  BANDA:   barre/arco fra 0,85 e 1,15. Fuori banda la data del disco e il
#           numero di barre NON raccontano la stessa storia (data finta
#           come il 1971 di EURUSD, oppure BUCHI): esito NON CONCLUSIVO.
$TOLL_GG    = 4
$BARRE_ANNO = 368000.0
$BANDA_MIN  = 0.85
$BANDA_MAX  = 1.15
$DIM_BLOCCO     = 5

$DaData = [datetime]::MinValue
if(-not [datetime]::TryParseExact($Da, "yyyy.MM.dd", $INV, [Globalization.DateTimeStyles]::None, [ref]$DaData)){
  Write-Host ("!!! -Da non e' una data yyyy.MM.dd: '" + $Da + "'") -ForegroundColor Red
  exit 1
}

function Ora(){ return (Get-Date).ToString("HH:mm:ss",$INV) }
function Dico($t,$c="Gray"){ Write-Host ("[" + (Ora) + "] " + $t) -ForegroundColor $c }
function Titolo($t){ Write-Host ""; Write-Host ("=== " + $t + " ===") -ForegroundColor Cyan }
function Ferma($t){
  Write-Host ""
  Write-Host ("STOP: " + $t) -ForegroundColor Red
  Write-Host "Non ho scaricato niente, non ho aperto MT5, non ho scritto niente sul Desktop." -ForegroundColor Red
  exit 1
}
function TerminaleVivo(){
  foreach($p in @(Get-Process -Name terminal64 -ErrorAction SilentlyContinue)){
    $pp = ""
    try { $pp = [string]$p.Path } catch { $pp = "" }
    if($pp -ieq $ExeTB){ return $true }
  }
  return $false
}
function LeggiTesto($p){
  #  I .chr sono di norma UTF-16: si guarda con tutte e due le letture,
  #  cosi' un <expert> non sfugge per colpa della codifica.
  try { $b = [IO.File]::ReadAllBytes($p) } catch { return "" }
  return ([Text.Encoding]::Unicode.GetString($b) + "`n" + [Text.Encoding]::Default.GetString($b))
}

$lista = @($Simboli.Split(',') | ForEach-Object { $_.Trim().ToUpper() } | Where-Object { $_ -ne '' })

Write-Host ""
Write-Host "#####################################################################" -ForegroundColor Cyan
Write-Host "#  PASSO 0 DI R92b -- PROFONDITA' BARRE M1 DEI 22 CROSS @ BCM  (v2)" -ForegroundColor Cyan
Write-Host "#####################################################################" -ForegroundColor Cyan
Write-Host "  SOLO SUL PC DI BACKTEST DESKTOP-H4D7CAJ. Il VPS VMI3047753 e tutte le" -ForegroundColor Yellow
Write-Host "  sue cartelle (FTMO 541452707, REALE 10105439, piccolo 50503392, 100k" -ForegroundColor Yellow
Write-Host "  50504263, manuale 50503635, banco 50504400, Pepperstone, Tickmill) NON toccati." -ForegroundColor Yellow
Dico ("pin      : " + $Pin)
Dico ("terminale: " + $TB + "   (demo 50503392, l'unico di questo PC)")
Dico ("simboli  : " + $lista.Count + "  da " + $Da + "  TF " + $Timeframes + "  senza tick, blocchi da " + $DIM_BLOCCO)
if($lista.Count -ne 22){ Write-Host ("  ATTENZIONE: i simboli sono " + $lista.Count + ", non 22.") -ForegroundColor Red }

# =====================================================================
#  F0 - CONTROLLI PRIMA DI TOCCARE QUALUNQUE COSA (sola lettura)
# =====================================================================
Titolo "F0 - controlli di sola lettura"
if(-not (Test-Path -LiteralPath $ExeTB -PathType Leaf)){ Ferma ("non trovo " + $ExeTB + ": questo non e' il PC di backtest che conosco.") }
if(@(Get-Process -Name terminal64 -ErrorAction SilentlyContinue).Count -gt 0){
  Ferma "su questo PC c'e' un MT5 APERTO. Chiudilo a mano (File > Esci) e rilancia."
}
$termRoot = Join-Path $env:APPDATA "MetaQuotes\Terminal"
$DataFolder = Get-ChildItem -LiteralPath $termRoot -Directory -ErrorAction SilentlyContinue | Where-Object {
  $o = Join-Path $_.FullName "origin.txt"
  (Test-Path -LiteralPath $o) -and ((Get-Content -LiteralPath $o -Raw).Trim() -ieq $TB)
} | Select-Object -First 1 -ExpandProperty FullName
if(-not $DataFolder){ Ferma ("cartella dati di " + $TB + " non trovata sotto " + $termRoot) }
Write-Host ("   cartella dati: " + $DataFolder) -ForegroundColor Green

#  LA GUARDIA EA: /config apre l'ULTIMO profilo con i suoi grafici. Si
#  guardano TUTTI i profili salvati (non si indovina quale e' l'ultimo).
$chartsRoot = Join-Path $DataFolder "MQL5\Profiles\Charts"
$conEA = @()
$nChr = 0
if(Test-Path -LiteralPath $chartsRoot){
  foreach($f in @(Get-ChildItem -LiteralPath $chartsRoot -Recurse -File -Filter "*.chr" -ErrorAction SilentlyContinue)){
    $nChr++
    $t = LeggiTesto $f.FullName
    if($t -match '<expert>'){
      $nome = "?"
      $m = [regex]::Match($t, '(?s)<expert>\s*name=([^\r\n<]*)')
      if($m.Success){ $nome = $m.Groups[1].Value.Trim() }
      $conEA += ($f.Directory.Name + "\" + $f.Name + "  EA: " + $nome)
    }
  }
}
Write-Host ("   grafici salvati letti: " + $nChr + "   con un EA attaccato: " + $conEA.Count) -ForegroundColor $(if($conEA.Count -eq 0){"Green"}else{"Red"})
if($conEA.Count -gt 0){
  foreach($x in $conEA){ Write-Host ("      " + $x) -ForegroundColor Red }
  Ferma ("nel profilo del terminale 50503392 di questo PC ci sono grafici con un EA attaccato (elenco sopra). Aprire MT5 per lo scarico li caricherebbe: il 14/08 da questo PC sono partiti ordini veri. Mandami questo elenco, NON aprire MT5 per toglierli senza avermelo detto.")
}

# =====================================================================
#  Da qui in poi si scrive (cartella di lavoro + Desktop)
# =====================================================================
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
$CsvDati    = Join-Path $DataFolder "MQL5\Files\ABTG_StoricoScaricato.csv"

function Scarica($url,$dest,$marcatore){
  Remove-Item -LiteralPath $dest -Force -ErrorAction SilentlyContinue
  Invoke-WebRequest -Uri $url -OutFile $dest -UseBasicParsing -ErrorAction Stop
  if(-not (Test-Path -LiteralPath $dest)){ throw ("scarico fallito: " + $url) }
  if($marcatore -ne "" -and -not (Select-String -LiteralPath $dest -SimpleMatch -Pattern $marcatore -Quiet)){
    throw ("file scaricato SENZA il marcatore atteso '" + $marcatore + "': " + $url)
  }
}

Titolo "F1 - strumenti dal pin (con marcatore)"
$Scar = Join-Path $DirBT "scarica_storico.ps1"
$Mq5  = Join-Path $DirMQ "ABTG_HistoryDownloader.mq5"
Scarica ("$RawPin/backtest_pipeline/scarica_storico.ps1") $Scar 'MARCATORE_SCARICA_STORICO_v3_TERMINALE_BACKTEST'
Scarica ("$RawPin/mql5/Scripts/ABTG_HistoryDownloader.mq5") $Mq5 'Scarica lo STORICO dei prezzi dal broker'
Write-Host ("   scarica_storico.ps1        -> " + $Scar) -ForegroundColor Green
Write-Host ("   ABTG_HistoryDownloader.mq5 -> " + $Mq5 + "   (copia pinnata: scarica_storico usa questa)") -ForegroundColor Green

# =====================================================================
#  F2 - LE CORSE: passata 1 su tutti, passata 2 su chi non copre -Da
# =====================================================================
function RigaNum($r){
  #  Trasforma una riga del CSV in numeri. $null se non leggibile.
  if($null -eq $r){ return $null }
  $b = [long]0
  if(-not [long]::TryParse([string]$r.Barre, [Globalization.NumberStyles]::Integer, $INV, [ref]$b)){ return $null }
  if($b -le 0){ return $null }
  $d = [datetime]::MinValue
  if(-not [datetime]::TryParseExact([string]$r.PrimaDataLocale, "yyyy.MM.dd", $INV, [Globalization.DateTimeStyles]::None, [ref]$d)){ return $null }
  return [pscustomobject]@{ Barre = $b; Disco = $d; Server = [string]$r.PrimaDataServer; Verdetto = [string]$r.Verdetto }
}
function Copre($n){ return ($null -ne $n -and $n.Disco -le $DaData.AddDays($TOLL_GG)) }

$Righe = @{ 1 = @{}; 2 = @{} }     # passata -> simbolo -> riga CSV
$Quando = @{ 1 = @{}; 2 = @{} }    # passata -> simbolo -> ora della corsa
$Corse = New-Object System.Collections.ArrayList
$noteCorse = New-Object System.Collections.ArrayList

foreach($passata in 1,2){
  if($passata -eq 1){
    $daFare = @($lista)
  } else {
    $daFare = @($lista | Where-Object { -not (Copre (RigaNum $Righe[1][$_])) })
    if($daFare.Count -eq 0){ Titolo "F2 - passata 2: non serve, tutti coprono dal $Da"; break }
  }
  $nBlocchi = [int][Math]::Ceiling($daFare.Count / [double]$DIM_BLOCCO)
  for($bi = 0; $bi -lt $nBlocchi; $bi++){
    $blocco = @($daFare | Select-Object -Skip ($bi * $DIM_BLOCCO) -First $DIM_BLOCCO)
    $etich  = ("passata " + $passata + " blocco " + ($bi + 1) + "/" + $nBlocchi)
    Titolo ("F2 - " + $etich + ": " + ($blocco -join ','))

    #  Il terminale deve essere CHIUSO: se la corsa prima lo sta ancora
    #  chiudendo si aspetta. Non si ammazza mai niente da qui.
    $attesa = 0
    while((TerminaleVivo) -and $attesa -lt 120){ Start-Sleep -Seconds 5; $attesa += 5 }
    if(TerminaleVivo){
      [void]$noteCorse.Add($etich + ": NON LANCIATA, il terminale era ancora aperto dopo 120 s (non l'ho chiuso io).")
      Write-Host "   il terminale e' ancora aperto dopo 120 s: salto le corse rimaste." -ForegroundColor Red
      break
    }

    $t0 = Get-Date
    $rc = 0
    $oldEA = $ErrorActionPreference
    $ErrorActionPreference = "Continue"
    $global:LASTEXITCODE = 0
    try{
      & powershell -NoProfile -ExecutionPolicy Bypass -File $Scar -Simboli ($blocco -join ',') -Da $Da -Timeframes $Timeframes -TimeoutMin $TimeoutMin -SenzaTick -Auto -TerminaleBacktest $TB
      $rc = $LASTEXITCODE
    }catch{
      $rc = 99
      Write-Host ("   eccezione lanciando scarica_storico.ps1: " + $_.Exception.Message) -ForegroundColor Red
    }finally{ $ErrorActionPreference = $oldEA }
    if($null -eq $rc){ $rc = 0 }
    $minuti = ((Get-Date) - $t0).TotalMinutes

    #  Solo un CSV scritto DOPO l'inizio di QUESTA corsa (scarica_storico
    #  lo cancella prima di lanciare MT5: un file di ieri non passa).
    $fresco = $false
    if(Test-Path -LiteralPath $CsvDati){
      $lw = (Get-Item -LiteralPath $CsvDati).LastWriteTime
      if($lw -ge $t0.AddMinutes(-1)){ $fresco = $true }
      else { Write-Host ("   CSV scartato: vecchio (LastWrite " + $lw.ToString("yyyy-MM-dd HH:mm",$INV) + ")") -ForegroundColor DarkYellow }
    }
    $nLette = 0
    if($fresco){
      $copia = Join-Path $Cart ("passata" + $passata + "_blocco" + ($bi + 1) + ".csv")
      try{
        Copy-Item -LiteralPath $CsvDati -Destination $copia -Force
        foreach($r in @(Import-Csv -LiteralPath $copia)){
          if(($blocco -contains $r.Simbolo) -and ($r.Timeframe -eq "M1")){
            $Righe[$passata][$r.Simbolo] = $r
            $Quando[$passata][$r.Simbolo] = $t0
            $nLette++
          }
        }
      }catch{
        [void]$noteCorse.Add($etich + ": CSV fresco ma NON leggibile: " + $_.Exception.Message)
      }
    }
    $rigaCorsa = ($etich + ": codice " + $rc + ", " + $minuti.ToString("0.0",$INV) + " min, CSV " + $(if($fresco){"fresco"}else{"ASSENTE o vecchio"}) + ", righe M1 lette " + $nLette + " su " + $blocco.Count)
    [void]$Corse.Add($rigaCorsa)
    Write-Host ("   " + $rigaCorsa) -ForegroundColor $(if($rc -eq 0 -and $nLette -eq $blocco.Count){"Green"}else{"Yellow"})
    if($passata -eq 1 -and $bi -eq 0 -and -not $fresco -and $rc -ne 0 -and $rc -ne 2){
      [void]$noteCorse.Add("la prima corsa e' uscita " + $rc + " senza CSV: guasto dello strumento (compilazione, terminale). Non insisto sulle altre.")
      Write-Host "   la prima corsa non ha prodotto niente: mi fermo qui, leggi il messaggio sopra." -ForegroundColor Red
      break
    }
  }
  if($passata -eq 1 -and $noteCorse.Count -gt 0 -and ($noteCorse[$noteCorse.Count-1] -like "la prima corsa*")){ break }
}

# =====================================================================
#  F3 - ESITO PER SIMBOLO
# =====================================================================
Titolo "F3 - esito per simbolo"
$Esiti = New-Object System.Collections.ArrayList
foreach($s in $lista){
  $n1 = RigaNum $Righe[1][$s]
  $n2 = RigaNum $Righe[2][$s]
  $fin = $n2; if($null -eq $fin){ $fin = $n1 }
  $txtEsito = ""; $concl = $false; $rapp = ""
  if($null -eq $fin){
    if(($null -eq $Righe[1][$s]) -and ($null -eq $Righe[2][$s])){
      $txtEsito = "NON MISURATO: nessuna riga M1 (simbolo inesistente o non selezionabile a BCM, oppure corsa fermata prima: leggi i log)"
    } else {
      $txtEsito = "NON MISURATO: riga M1 senza dati leggibili (NESSUN DATO / timeout / riga troncata)"
    }
  } else {
    $inizio = $fin.Disco; if($inizio -lt $DaData){ $inizio = $DaData }
    $anniData  = ((Get-Date) - $inizio).TotalDays / 365.25
    $anniBarre = $fin.Barre / $BARRE_ANNO
    $r = 0.0; if($anniData -gt 0){ $r = $anniBarre / $anniData }
    $rapp = $r.ToString("0.00",$INV)
    $inBanda = ($r -ge $BANDA_MIN -and $r -le $BANDA_MAX)
    $dataTxt = $fin.Disco.ToString("yyyy.MM.dd",$INV)
    if(Copre $fin){
      if($inBanda){ $txtEsito = ("COPRE DAL " + $Da + " (disco " + $dataTxt + ", barre coerenti)"); $concl = $true }
      else { $txtEsito = ("NON CONCLUSIVO: il disco dice " + $dataTxt + " ma le barre coprono " + $anniBarre.ToString("0.0",$INV) + " anni su " + $anniData.ToString("0.0",$INV) + " (data finta o BUCHI)") }
    } elseif($null -ne $n1 -and $null -ne $n2) {
      $dMin  = 0.0
      if($Quando[1].ContainsKey($s) -and $Quando[2].ContainsKey($s)){ $dMin = ($Quando[2][$s] - $Quando[1][$s]).TotalMinutes }
      $crescita = $n2.Barre - $n1.Barre
      $stabile = ($n2.Disco -eq $n1.Disco) -and ($crescita -ge 0) -and ($crescita -le ($dMin + 60))
      if($stabile -and $inBanda){ $txtEsito = ("MURO A " + $dataTxt + " (stabile su due passate, barre coerenti)"); $concl = $true }
      elseif($stabile){ $txtEsito = ("NON CONCLUSIVO: muro stabile a " + $dataTxt + " ma barre/arco " + $rapp + " fuori banda (BUCHI?)") }
      else { $txtEsito = ("MINIMO " + $dataTxt + ": lo scarico si muoveva ancora (passata 1: disco " + $n1.Disco.ToString("yyyy.MM.dd",$INV) + ", barre " + $n1.Barre + "; passata 2: barre " + $n2.Barre + ")") }
    } else {
      $txtEsito = ("MINIMO NON CONFERMATO " + $dataTxt + ": una sola passata leggibile, non separa il muro da uno scarico a meta'")
    }
  }
  $p1 = "-"; if($null -ne $n1){ $p1 = ("barre " + $n1.Barre + " disco " + $n1.Disco.ToString("yyyy.MM.dd",$INV)) }
  $p2 = "-"; if($null -ne $n2){ $p2 = ("barre " + $n2.Barre + " disco " + $n2.Disco.ToString("yyyy.MM.dd",$INV)) }
  $srv = "-"; $ver = "-"
  if($null -ne $fin){ $srv = $fin.Server; $ver = $fin.Verdetto }
  [void]$Esiti.Add([pscustomobject]@{
    Simbolo = $s; Conclusivo = $concl; Esito = $txtEsito; BarreSuArco = $rapp
    Passata1 = $p1; Passata2 = $p2; PrimaDataServer_NON_DECIDE = $srv; Verdetto_NON_DECIDE = $ver
  })
}
$Esiti | Export-Csv -LiteralPath $CsvRinom -NoTypeInformation -Encoding ASCII
$nConcl = @($Esiti | Where-Object { $_.Conclusivo }).Count

# =====================================================================
#  F4 - REFERTO
# =====================================================================
Titolo "F4 - referto"
$L = New-Object System.Collections.ArrayList
[void]$L.Add("PASSO 0 DI R92b -- PROFONDITA' DELLE BARRE M1 DEI 22 CROSS @ BCM  (script v2)")
[void]$L.Add("data: " + (Get-Date).ToString("yyyy-MM-dd HH:mm:ss",$INV) + "   (corsa partita alle " + $Avvio.ToString("yyyy-MM-dd HH:mm:ss",$INV) + ")")
[void]$L.Add("macchina: " + $env:COMPUTERNAME + "   terminale: " + $TB + "   pin: " + $Pin)
[void]$L.Add("richiesta: -Da " + $Da + " -Timeframes M1 -SenzaTick -Auto -TerminaleBacktest, blocchi da " + $DIM_BLOCCO + ", -TimeoutMin " + $TimeoutMin + " per blocco")
[void]$L.Add("guardia EA: " + $nChr + " grafici salvati letti, zero EA attaccati")
[void]$L.Add("ESITI CONCLUSIVI: " + $nConcl + " su " + $lista.Count)
[void]$L.Add("")
[void]$L.Add("CORSE:")
foreach($c in $Corse){ [void]$L.Add("  " + $c) }
foreach($c in $noteCorse){ [void]$L.Add("  NOTA: " + $c) }
[void]$L.Add("")
[void]$L.Add("SIMBOLO  ESITO  | barre/arco | passata 1 | passata 2 | server (NON decide) | verdetto (NON decide)")
foreach($e in $Esiti){
  [void]$L.Add(($e.Simbolo + "  " + $e.Esito + "  | " + $e.BarreSuArco + " | " + $e.Passata1 + " | " + $e.Passata2 + " | " + $e.PrimaDataServer_NON_DECIDE + " | " + $e.Verdetto_NON_DECIDE))
}
[void]$L.Add("")
[void]$L.Add("COME SI LEGGE (scritto PRIMA dei numeri):")
[void]$L.Add(" - decide la data del DISCO (PrimaDataLocale) dopo lo scarico, controllata con le barre. PrimaDataServer e Verdetto")
[void]$L.Add("   NON decidono (classe 851): sui cambi BCM il server dichiara 1971/1993 e il verdetto esce MANCA STORICO LOCALE per costruzione.")
[void]$L.Add(" - COPRE DAL " + $Da + ": il disco arriva alla data chiesta (tolleranza " + $TOLL_GG + " giorni) e le barre lo confermano. Prima del " + $Da + " NON e' misurato.")
[void]$L.Add(" - MURO A <data>: il disco si ferma dopo " + $Da + " e due passate ridicono la stessa data e le stesse barre = il broker parte da li'.")
[void]$L.Add(" - MINIMO: la data si e' spostata fra le passate (o ce n'e' una sola): lo storico vero parte da li' O PRIMA. Non e' un muro.")
[void]$L.Add(" - barre/arco = barre M1 / (" + $BARRE_ANNO.ToString("0",$INV) + " x anni dalla data del disco). Fuori da " + $BANDA_MIN.ToString("0.00",$INV) + "-" + $BANDA_MAX.ToString("0.00",$INV) + " la data non e' credibile")
[void]$L.Add("   (EURUSD/USDJPY: disco M1 1971.01.03 in R258L/R259) oppure lo storico ha BUCHI: NON CONCLUSIVO.")
[void]$L.Add(" - per R92b: un MURO dopo il 2022.01.01 = quel cross in R92 ha girato su mezza finestra.")
Set-Content -LiteralPath $RefertoOut -Value $L -Encoding ASCII
Get-Content -LiteralPath $RefertoOut | ForEach-Object { Write-Host $_ }

# =====================================================================
#  F5 - RACCOLTA + ZIP
# =====================================================================
Titolo "F5 - raccolta + zip"
$logDir = Join-Path $DataFolder "MQL5\Logs"
if(Test-Path -LiteralPath $logDir){
  Get-ChildItem -LiteralPath $logDir -Filter "*.log" -ErrorAction SilentlyContinue |
    Sort-Object LastWriteTime -Descending | Select-Object -First 2 |
    ForEach-Object { Copy-Item -LiteralPath $_.FullName -Destination $Cart -Force -ErrorAction SilentlyContinue }
}
$Zip = Join-Path $Dsk ("MISURA_STORICO_CROSS22_" + $Stamp + ".zip")
try{ Compress-Archive -Path (Join-Path $Cart "*") -DestinationPath $Zip -Force }catch{ Write-Host ("   zip non riuscito: " + $_.Exception.Message) -ForegroundColor Red }
Write-Host ""
Write-Host ("RACCOLTA: " + $Cart) -ForegroundColor Green
Write-Host ("ZIP PRONTO DA MANDARE: " + $Zip) -ForegroundColor Green
Write-Host "Verifica che dentro ci siano:" -ForegroundColor DarkGray
Write-Host "   - REFERTO_MISURA_STORICO_CROSS22.txt" -ForegroundColor DarkGray
Write-Host "   - misura_storico_cross22.csv  (un esito per simbolo)" -ForegroundColor DarkGray
Write-Host "   - passata1_blocco1..5.csv (+ passata2_blocco*.csv se la passata 2 e' servita)" -ForegroundColor DarkGray
Write-Host "   - gli ultimi 2 log di MT5 (*.log)" -ForegroundColor DarkGray

if($nConcl -eq $lista.Count){
  Write-Host ""
  Write-Host ("MISURA COMPLETA: esito conclusivo su tutti i " + $lista.Count + " simboli.") -ForegroundColor Green
  exit 0
}
Write-Host ""
Write-Host ("ATTENZIONE: MISURA PARZIALE -- esito conclusivo su " + $nConcl + " simboli su " + $lista.Count + ".") -ForegroundColor Red
Write-Host "  Il referto e lo zip ci sono lo stesso: chi legge decide." -ForegroundColor Yellow
exit 2
