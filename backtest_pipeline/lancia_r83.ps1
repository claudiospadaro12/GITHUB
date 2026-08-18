# =====================================================================
#  lancia_r83.ps1  --  R83 DUELLO DEGLI INGRESSI (Nasdaq e DAX)
#  TRE STILI D'INGRESSO, STESSO TUTTO IL RESTO, UN MAGIC PER MODALITA'
#  EA del round: ABTG_Apertura_3Ingressi (nuovo, FIRMA 6 del 18/08)
#  + una cella di controprova sull'EA VIVO del DAX
# ---------------------------------------------------------------------
#  LA DOMANDA (congelata in prove\R83_INGRESSI_CRITERI.md, letta PRIMA):
#    "A parita' ASSOLUTA di livello, orario, stop, gestione e uscite,
#     quale STILE D'INGRESSO regge meglio sull'apertura - e su QUALE
#     mercato?"
#
#  LE TRE MODALITA' (InpEntryMode dell'EA nuovo):
#    0 STOP     ordine BUY/SELL STOP oltre il livello + buffer
#               costo: SLIPPAGE, si riempie sempre ma spesso peggio
#    1 LIMIT    rottura, poi LIMIT sul RETEST del livello rotto
#               costo: NO-FILL, se non torna non entri
#    2 MARKET   una candela CHIUDE oltre il livello -> market
#               costo: RITARDO, entri piu' lontano, stop piu' largo
#  Nessuna delle tre e' gratis: il duello misura quale costo pesa meno.
#
#  SETTE CELLE:
#    N0 NASUSD modalita' 0   (baseline Nasdaq + canarino di equivalenza)
#    N1 NASUSD modalita' 1
#    N2 NASUSD modalita' 2   (codice nuovo)
#    D0 D30EUR modalita' 0
#    D1 D30EUR modalita' 1   (baseline DAX: la sedia viva gira GIA' cosi')
#    D2 D30EUR modalita' 2   (codice nuovo)
#    V  D30EUR EA VIVO       (controprova: D1 e V devono coincidere)
#
#  I DUE CANARINI, e senza di loro il duello NON CONTA:
#    (a) N0 deve dare gli STESSI numeri della cella A di R84, che gira
#        sull'EA VIVO del Nasdaq con la stessa identica configurazione;
#    (b) D1 deve dare gli STESSI numeri della cella V.
#    Se non coincidono ci si FERMA e si cerca la divergenza nel codice:
#    un duello fra un EA e un suo clone che non e' un clone non misura
#    gli ingressi, misura un bug.
#
#  PRIMA DI TUTTO, UNA VOLTA SOLA: l'EA nuovo stampa in avvio le righe
#  [3ING][AUTOTEST] (sei controlli sulla modalita' 2, che e' codice mai
#  girato). Quelle righe le produce un'ESECUZIONE, non il tasto F7:
#  si leggono facendo UN TEST SINGOLO nello Strategy Tester (difetto
#  n.20 della checklist). E mai attaccando l'EA a un grafico: sul PC di
#  backtest il terminale e' collegato al conto vivo.
#
#  DOVE: sul PC di BACKTEST, con MT5 CHIUSO. MAI SUL VPS.
#
#  PRIMA SEMPRE IL GIRO A VUOTO (-SoloControllo), poi il CANARINO
#  (-Solo N0), poi il resto.
#
#  SUL TIMEOUT, detto com'e': walkforward_generico.ps1 lancia MT5 con
#  WaitForExit() SENZA limite (riga 633): non c'e' nessun -TimeoutMin da
#  passargli, e non gliene aggiungiamo uno (un timeout che ammazza MT5 a
#  meta' corsa e' il difetto n.19 fatto in casa). Il timeout serve al
#  PASSO 0, ed e' scritto esplicito nella riga che lo lancia.
#
#  QUESTO ROUND NON TOCCA IL FORWARD. L'EA nuovo gira in parallelo e non
#  sostituisce niente; al massimo UNA modalita' per mercato potra' mai
#  andare in campo (le tre si innescano sullo stesso evento: sarebbero
#  posizioni correlate e mangerebbero tre volte il cap C1).
#
#  NOTA CULTURA INVARIANTE: nessun numero dei CSV viene convertito, si
#  stampano come stringhe. L'unica conversione e' sulle DATE del PASSO 0,
#  con ParseExact + InvariantCulture, esplicita.
# =====================================================================
param(
  [string]$Rif      = "lavoro",                          # commit SHA (o branch)
  [string]$Cartella = (Join-Path $env:USERPROFILE "r83"),
  [int]$Deposito    = 10000,
  [int]$Modello     = 4,                                 # 4 = tick reali. 1 = OHLC M1: solo se i tick non ci sono, e va DICHIARATO
  [string]$Solo     = "",                                # es. "N0" oppure "N0,D1,V"
  [switch]$Rifai,
  [switch]$SoloControllo,
  [switch]$SaltaPassoZero
)
$ErrorActionPreference = "Stop"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$Raw    = "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$Rif"
$EAnew  = "ABTG_Apertura_3Ingressi"
$EAvivo = "ABTG_DAX_Apertura_EU"

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

Write-Host "=== ROUND 83 - DUELLO DEGLI INGRESSI (stop / limit / conferma) ===" -ForegroundColor Cyan
Write-Host ("MACCHINA: " + $env:COMPUTERNAME + "   utente: " + $env:USERNAME) -ForegroundColor Cyan
Write-Host ("riferimento: " + $Rif) -ForegroundColor DarkGray
Write-Host ("data      : " + (Get-Date -Format "yyyy-MM-dd HH:mm")) -ForegroundColor DarkGray

if (Get-Process -Name "terminal64" -ErrorAction SilentlyContinue) {
  Muori ("MetaTrader e' APERTO. Chiudilo prima di lanciare, altrimenti escono 0 CSV." + "`n" +
         "    (e se sul PC sta girando un altro lavoro - HistData, Dukascopy, R84 -" + "`n" +
         "     aspetta che finisca: c'e' un solo MT5)")
}

# =====================================================================
#  LE SETTE CELLE
# =====================================================================
$celle = @(
  @{ K="N0"; EA=$EAnew;  Sym="NASUSD"; File="R83n0_stop_NASUSD.txt";      Tag="r83n0"; Mag=@("777010","777011"); Cosa="modalita' 0 STOP (baseline Nasdaq + canarino)" }
  @{ K="N1"; EA=$EAnew;  Sym="NASUSD"; File="R83n1_limit_NASUSD.txt";     Tag="r83n1"; Mag=@("777020","777021"); Cosa="modalita' 1 LIMIT sul retest" }
  @{ K="N2"; EA=$EAnew;  Sym="NASUSD"; File="R83n2_conferma_NASUSD.txt";  Tag="r83n2"; Mag=@("777030","777031"); Cosa="modalita' 2 MARKET alla chiusura (codice nuovo)" }
  @{ K="D0"; EA=$EAnew;  Sym="D30EUR"; File="R83d0_stop_D30EUR.txt";      Tag="r83d0"; Mag=@("777110","777111"); Cosa="modalita' 0 STOP" }
  @{ K="D1"; EA=$EAnew;  Sym="D30EUR"; File="R83d1_limit_D30EUR.txt";     Tag="r83d1"; Mag=@("777120","777121"); Cosa="modalita' 1 LIMIT (baseline DAX = sedia viva)" }
  @{ K="D2"; EA=$EAnew;  Sym="D30EUR"; File="R83d2_conferma_D30EUR.txt";  Tag="r83d2"; Mag=@("777130","777131"); Cosa="modalita' 2 MARKET alla chiusura (codice nuovo)" }
  @{ K="V";  EA=$EAvivo; Sym="D30EUR"; File="R83v_vivo_D30EUR.txt";       Tag="r83v";  Mag=@("777190","777191"); Cosa="EA VIVO del DAX: controprova di equivalenza" }
)

if ($Solo -ne "") {
  $scelti = @()
  foreach ($s in ($Solo -split ",")) { $scelti += $s.Trim().ToUpper() }
  $celle = @($celle | Where-Object { $scelti -contains $_.K })
  if ($celle.Count -eq 0) { Muori "il filtro -Solo '$Solo' non seleziona nessuna cella (valide: N0 N1 N2 D0 D1 D2 V)." }
  Write-Host ("  -Solo attivo: giro solo " + (($celle | ForEach-Object { $_.K }) -join ", ")) -ForegroundColor Yellow
}

Write-Host ""
Write-Host ("  celle da girare: " + $celle.Count + "   modello: " + $Modello + "   deposito: " + $Deposito) -ForegroundColor White
if ($Modello -ne 4) {
  Write-Host "  ATTENZIONE: NON stai girando a tick reali. Ogni numero di questa corsa" -ForegroundColor Yellow
  Write-Host "  va scritto con accanto 'OHLC, non tick'. E su un duello fra ingressi" -ForegroundColor Yellow
  Write-Host "  l'OHLC e' particolarmente bugiardo: il riempimento e' proprio la cosa" -ForegroundColor Yellow
  Write-Host "  che distingue uno STOP da un LIMIT." -ForegroundColor Yellow
}

# =====================================================================
#  1. ATTREZZI (riscaricati sempre, mai la copia vecchia)
# =====================================================================
Titolo "1) attrezzi (riscaricati sempre, pinnati a $Rif)"
$Prove = Join-Path $Cartella "prove"
New-Item -ItemType Directory -Force -Path $Prove | Out-Null

$file = @{}
$file["walkforward_generico.ps1"] = "$Raw/backtest_pipeline/walkforward_generico.ps1"
$file["prove\R83_INGRESSI_CRITERI.md"] = "$Raw/backtest_pipeline/prove/R83_INGRESSI_CRITERI.md"
foreach ($c in $celle) { $file["prove\" + $c.File] = "$Raw/backtest_pipeline/prove/" + $c.File }

foreach ($k in $file.Keys) {
  $dest = Join-Path $Cartella $k
  Remove-Item -LiteralPath $dest -Force -ErrorAction SilentlyContinue
  try {
    Invoke-WebRequest -Uri $file[$k] -OutFile $dest -UseBasicParsing -ErrorAction Stop
    Write-Host ("    ok  " + $k) -ForegroundColor Green
  } catch {
    Muori ("non sono riuscito a scaricare " + $k + " da " + $Rif + "`n    " + $_.Exception.Message)
  }
}
foreach ($c in $celle) {
  $p = Join-Path $Prove $c.File
  if (-not (Select-String -Path $p -SimpleMatch -Pattern "R83 / DUELLO INGRESSI" -Quiet)) {
    Muori ("il file prova " + $c.File + " non contiene il marcatore R83: e' una copia sbagliata o vecchia.")
  }
}
$wf = Join-Path $Cartella "walkforward_generico.ps1"
if (-not (Select-String -Path $wf -SimpleMatch -Pattern "WALK-FORWARD GENERICO" -Quiet)) {
  Muori "walkforward_generico.ps1 scaricato non e' quello giusto (manca il marcatore)."
}

Get-ChildItem -Path $Cartella -Filter "anteprima_*.ini" -ErrorAction SilentlyContinue | ForEach-Object {
  try { Remove-Item -LiteralPath $_.FullName -Force } catch {}
}

# =====================================================================
#  PASSO 0 - LA PROFONDITA' DEI TICK, MISURATA (difetto n.18)
#
#  Il @DAQUANDO dei file prova (2024.09.26) e' la profondita' delle
#  BARRE degli indici. La profondita' dei TICK degli INDICI a BCM non e'
#  MAI stata misurata: il referto del 15/08 misura GBPUSD (tick dal
#  2024.07.05) e dice "da misurare allo stesso modo: i tick degli
#  INDICI". Qui i simboli sono DUE, e si controllano tutti e due.
#  Viene DOPO il download apposta: la finestra si legge dal file prova
#  appena scaricato, non da un numero scritto in questo script.
# =====================================================================
$desk = Trova-Desktop
$CsvStorico = Join-Path $desk "storico_bcm\ABTG_StoricoScaricato.csv"
$simboli = @($celle | ForEach-Object { $_.Sym } | Select-Object -Unique)

if ($Modello -eq 4 -and -not $SaltaPassoZero) {
  Titolo ("0) PASSO 0 - profondita' dei TICK di " + ($simboli -join " e ") + " (misurata, non ipotizzata)")
  if (-not (Test-Path -LiteralPath $CsvStorico)) {
    Muori ("il referto della profondita' storica non c'e': " + $CsvStorico + "`n" +
           "    Lancialo PRIMA (MT5 chiuso), col timeout dimensionato sulla stima:`n" +
           "      powershell -ExecutionPolicy Bypass -File `"$PSScriptRoot\scarica_storico.ps1`" -Simboli `"" + ($simboli -join ",") + "`" -Da 2024.01.01 -TimeoutMin 180 -Auto`n" +
           "    Poi si LEGGONO le righe  <SIMBOLO>,TICK  (colonna PrimaDataLocale), NON le`n" +
           "    righe M1: la profondita' si misura sul dato che il tester usa davvero.`n" +
           "    Se i tick degli indici non esistono, si rilancia con`n" +
           "      -Modello 1 -SaltaPassoZero   e OGNI numero porta scritto 'OHLC, non tick'.")
  }
  $righeStorico = @()
  try { $righeStorico = @(Import-Csv -LiteralPath $CsvStorico) } catch { Muori ("il referto storico non e' leggibile: " + $_.Exception.Message) }

  $inv = [Globalization.CultureInfo]::InvariantCulture
  foreach ($sy in $simboli) {
    $rigaTick = @($righeStorico | Where-Object { $_.Simbolo -eq $sy -and $_.Timeframe -eq "TICK" })
    if ($rigaTick.Count -eq 0) {
      Muori ("nel referto " + $CsvStorico + " non c'e' la riga  " + $sy + ",TICK.`n" +
             "    Rilancia scarica_storico.ps1 includendo " + $sy + ".")
    }
    $dataTick = ($rigaTick[0].PrimaDataLocale + "").Trim()
    Write-Host ("    " + $sy + ",TICK  n=" + $rigaTick[0].Barre + "  PrimaDataLocale=" + $dataTick) -ForegroundColor Gray
    if ($dataTick -eq "" -or $dataTick -eq "-") {
      Muori ("PrimaDataLocale della riga TICK di " + $sy + " e' vuota: i tick NON ci sono sul disco.`n" +
             "    O li scarichi, o si gira a -Modello 1 -SaltaPassoZero dichiarando 'OHLC, non tick'.")
    }
    $cella1 = @($celle | Where-Object { $_.Sym -eq $sy })[0]
    $daQuando = ""
    $m = Select-String -Path (Join-Path $Prove $cella1.File) -Pattern '^@DAQUANDO\s+(\S+)'
    if ($m) { $daQuando = $m.Matches[0].Groups[1].Value }
    if ($daQuando -eq "") { Muori ("nel file prova " + $cella1.File + " non trovo la riga @DAQUANDO.") }
    $dT = $null; $dW = $null
    try { $dT = [datetime]::ParseExact($dataTick, "yyyy.MM.dd", $inv) } catch {}
    try { $dW = [datetime]::ParseExact($daQuando, "yyyy.MM.dd", $inv) } catch {}
    if ($dT -eq $null -or $dW -eq $null) {
      Write-Host ("    non riesco a confrontare le date ('" + $dataTick + "' e '" + $daQuando + "'): controllale a mano.") -ForegroundColor Yellow
    } elseif ($dT -gt $dW) {
      Muori ("I TICK DI " + $sy + " PARTONO DOPO LA FINESTRA DEL ROUND.`n" +
             "    tick da  : " + $dataTick + "`n" +
             "    finestra : " + $daQuando + "  (@DAQUANDO nei file prova)`n" +
             "    La prima parte della finestra sarebbe VUOTA. Si riscrive il @DAQUANDO`n" +
             "    dei file prova con la data misurata, si aggiornano i criteri, e SI RILANCIA.")
    } else {
      Write-Host ("    ok: tick dal " + $dataTick + ", finestra dal " + $daQuando + ".") -ForegroundColor Green
    }
  }
} elseif ($SaltaPassoZero) {
  Write-Host ""
  Write-Host "  -SaltaPassoZero: il controllo sulla profondita' dei tick E' STATO SALTATO." -ForegroundColor Yellow
  Write-Host "  Va detto in chat accanto ai risultati, altrimenti nessuno sa su che dati girano." -ForegroundColor Yellow
}

# =====================================================================
#  2. LE SERIE PER-TRADE VECCHIE DEI NOSTRI MAGIC (se ci fossero)
# =====================================================================
$Common = Join-Path $env:APPDATA "MetaQuotes\Terminal\Common\Files"
if ((-not $SoloControllo) -and (Test-Path $Common)) {
  $puliti = 0
  foreach ($c in $celle) {
    foreach ($m in $c.Mag) {
      $f = Join-Path $Common ("abtg_trades_" + $c.EA + "_" + $c.Sym + "_" + $m + ".csv")
      if (Test-Path -LiteralPath $f) {
        try { Remove-Item -LiteralPath $f -Force; $puliti++ } catch { Write-Host ("    non riesco a cancellare " + $f) -ForegroundColor Yellow }
      }
    }
  }
  if ($puliti -gt 0) { Write-Host ("    ripulite " + $puliti + " serie per-trade di corse precedenti") -ForegroundColor DarkYellow }
}

# =====================================================================
#  3. LE CORSE
# =====================================================================
$falliti = @()
$i = 0
foreach ($c in $celle) {
  $i++
  Titolo ("2." + $i + ") CELLA " + $c.K + " - " + $c.Sym + " - " + $c.Cosa + "   [" + $c.Tag + "]")
  Write-Host ("      EA: " + $c.EA) -ForegroundColor DarkGray

  $arg = @("-ExecutionPolicy","Bypass","-File",$wf,$c.EA,
           "-Prova",("prove\" + $c.File),
           "-Modello","$Modello",
           "-Deposito","$Deposito",
           "-Etichetta",$c.Tag)
  if ($SoloControllo) { $arg += "-SoloControllo" }
  if ($Rifai)         { $arg += "-Rifai" }

  $global:LASTEXITCODE = 0
  & powershell $arg
  if ($LASTEXITCODE -ne 0) {
    Write-Host ("    cella " + $c.K + " uscita con codice " + $LASTEXITCODE + ": vado avanti, la raccolta dira' cosa manca.") -ForegroundColor Yellow
    $falliti += $c.K
    continue
  }
  if ($SoloControllo) { continue }

  if (Test-Path $Common) {
    $Risultati = Join-Path $Cartella ("risultati_prove\" + $c.EA)
    foreach ($m in $c.Mag) {
      $f = Join-Path $Common ("abtg_trades_" + $c.EA + "_" + $c.Sym + "_" + $m + ".csv")
      if (Test-Path -LiteralPath $f) {
        New-Item -ItemType Directory -Force -Path $Risultati | Out-Null
        Copy-Item -LiteralPath $f -Destination (Join-Path $Risultati ("pertrade_" + $c.Tag + "_" + $m + ".csv")) -Force
        Write-Host ("    serie per-trade raccolta: magic " + $m) -ForegroundColor DarkGray
      }
    }
  }
}

# =====================================================================
#  4a. GIRO A VUOTO: il codice d'uscita DIPENDE dalle celle (difetto n.14)
# =====================================================================
if ($SoloControllo) {
  Titolo "3) ANTEPRIME PRODOTTE e modalita' d'ingresso di ciascuna"
  $senzaAnteprima = @()
  $coppie = @()
  foreach ($c in $celle) {
    $chiave = $c.EA + "|" + $c.Sym
    if ($coppie -notcontains $chiave) { $coppie += $chiave }
  }
  foreach ($cp in $coppie) {
    $pz = $cp -split "\|"
    $ant = Join-Path $Cartella ("anteprima_" + $pz[0] + "_" + $pz[1] + ".ini")
    Write-Host ""
    Write-Host ("  " + $pz[0] + " su " + $pz[1]) -ForegroundColor White
    if (-not (Test-Path -LiteralPath $ant)) {
      Write-Host "      (nessuna anteprima prodotta)" -ForegroundColor Red
      $senzaAnteprima += $cp
      continue
    }
    $chiavi = "^(InpEntryMode|InpRangeMode|InpRangeMinutes|InpLevelTF|InpBufferPoints|InpRetestOffsetPts|InpOCTimeframe|InpSessionHour|InpSessionMin|InpTrailTF|InpRiskPercent|InpMagic|InpAutoTest)="
    foreach ($r in (Select-String -Path $ant -Pattern $chiavi)) { Write-Host ("      " + $r.Line) -ForegroundColor Gray }
    foreach ($r in (Select-String -Path $ant -Pattern "^(Symbol|Period|FromDate|ToDate)=")) { Write-Host ("      " + $r.Line) -ForegroundColor DarkGray }
  }
  Write-Host ""
  Write-Host "  ATTENZIONE ALLA TRAPPOLA PIU' FACILE DI QUESTO ROUND:" -ForegroundColor Yellow
  Write-Host "  sull'EA NUOVO le modalita' sono TRE e il retest vale 1;" -ForegroundColor Yellow
  Write-Host "  sull'EA VIVO (cella V) l'enum ne ha SEI e il retest vale 2." -ForegroundColor Yellow
  Write-Host "  Le anteprime qui sopra sono l'ULTIMA cella girata per ogni EA+simbolo:" -ForegroundColor Yellow
  Write-Host ("  il confronto cella per cella si fa sui file prova in " + $Prove) -ForegroundColor Yellow
  Write-Host "  La riga 'Model=' dell'anteprima e' SCRITTA FISSA a 4 dal driver:" -ForegroundColor Yellow
  Write-Host ("  il modello VERO di questo giro e' " + $Modello + ".") -ForegroundColor Yellow
  Write-Host ""
  if ($falliti.Count -gt 0 -or $senzaAnteprima.Count -gt 0) {
    Write-Host ("=== GIRO A VUOTO FALLITO: " + (($falliti + $senzaAnteprima | Select-Object -Unique) -join " ") + " ===") -ForegroundColor Red
    exit 1
  }
  Write-Host "SoloControllo: MT5 non e' stato aperto, nessun CSV da raccogliere." -ForegroundColor Green
  exit 0
}

# =====================================================================
#  4b. RACCOLTA SUL DESKTOP + ZIP
# =====================================================================
Titolo "3) raccolta sul Desktop"
$nomeCartella = "R83_DUELLO_INGRESSI"
$dest = Join-Path $desk $nomeCartella
if (Test-Path $dest) { Remove-Item $dest -Recurse -Force -ErrorAction SilentlyContinue }
New-Item -ItemType Directory -Force -Path $dest | Out-Null

$suff = if ($Modello -eq 4) { "" } else { "_ohlc" }
$attesi = @()
foreach ($c in $celle) {
  $attesi += ($c.EA + "_" + $c.Sym + "_IS"  + $suff + "_" + $c.Tag + ".csv")
  $attesi += ($c.EA + "_" + $c.Sym + "_OOS" + $suff + "_" + $c.Tag + ".csv")
}

foreach ($ea in @($celle | ForEach-Object { $_.EA } | Select-Object -Unique)) {
  $Risultati = Join-Path $Cartella ("risultati_prove\" + $ea)
  if (Test-Path $Risultati) {
    foreach ($f in (Get-ChildItem $Risultati -Filter "*r83*.csv" -ErrorAction SilentlyContinue)) {
      try { Copy-Item -LiteralPath $f.FullName -Destination (Join-Path $dest $f.Name) -Force } catch { Write-Host ("    non copiato: " + $f.Name) -ForegroundColor Yellow }
    }
  }
}
foreach ($c in $celle) { try { Copy-Item -LiteralPath (Join-Path $Prove $c.File) -Destination $dest -Force } catch {} }
try { Copy-Item -LiteralPath (Join-Path $Prove "R83_INGRESSI_CRITERI.md") -Destination $dest -Force } catch {}

Write-Host ""
Write-Host "    FILE ATTESI (controllali uno per uno):" -ForegroundColor White
$mancanti = 0
foreach ($a in $attesi) {
  if (Test-Path (Join-Path $dest $a)) { Write-Host ("      OK      " + $a) -ForegroundColor Green }
  else { Write-Host ("      MANCA  " + $a) -ForegroundColor Red; $mancanti++ }
}
$nPerTrade = @(Get-ChildItem $dest -Filter "pertrade_r83*.csv" -ErrorAction SilentlyContinue).Count
Write-Host ("      (serie per-trade raccolte: " + $nPerTrade + " - sono della SOLA finestra OOS, l'IS viene sovrascritta)") -ForegroundColor DarkGray

# =====================================================================
#  5. TABELLA DI LETTURA - solo stringhe, NESSUN parse numerico
# =====================================================================
Titolo "4) tabella (letta dai CSV, campi NON convertiti)"
Write-Host ("  {0,-3} {1,-7} {2,-4} {3,14} {4,10} {5,9} {6,7}  {7}" -f "","mercato","fin.","Profit","PF","DD %","trades","magic") -ForegroundColor White
foreach ($c in $celle) {
  foreach ($w in @("IS","OOS")) {
    $csv = Join-Path $dest ($c.EA + "_" + $c.Sym + "_" + $w + $suff + "_" + $c.Tag + ".csv")
    if (-not (Test-Path -LiteralPath $csv)) {
      Write-Host ("  {0,-3} {1,-7} {2,-4} {3}" -f $c.K, $c.Sym, $w, "CSV MANCANTE") -ForegroundColor Red
      continue
    }
    $righe = @()
    try { $righe = @(Import-Csv -LiteralPath $csv) } catch { }
    if ($righe.Count -eq 0) {
      Write-Host ("  {0,-3} {1,-7} {2,-4} {3}" -f $c.K, $c.Sym, $w, "ZERO PASSATE (solo intestazione)") -ForegroundColor Red
      continue
    }
    foreach ($r in $righe) {
      Write-Host ("  {0,-3} {1,-7} {2,-4} {3,14} {4,10} {5,9} {6,7}  {7}" -f $c.K, $c.Sym, $w, $r.Profit, $r.'Profit Factor', $r.'Equity DD %', $r.Trades, $r.InpMagic) -ForegroundColor Gray
    }
    if ($righe.Count -eq 2) {
      if ($righe[0].Profit -ne $righe[1].Profit) {
        Write-Host ("      ATTENZIONE: le due passate gemelle della cella " + $c.K + " " + $w + " NON coincidono. Qualcosa e' rotto.") -ForegroundColor Red
      }
    } else {
      Write-Host ("      ATTENZIONE: " + $righe.Count + " righe invece di 2 (cache del tester? magic gia' usato?)") -ForegroundColor Red
    }
  }
}
Write-Host ""
Write-Host "  I CRITERI SI LEGGONO PRIMA DELLA TABELLA: prove\R83_INGRESSI_CRITERI.md" -ForegroundColor Yellow
Write-Host "  PRIMA i canarini: N0 deve coincidere con la cella A di R84, e D1 con la" -ForegroundColor Yellow
Write-Host "  cella V. Se non coincidono, il duello NON si legge: si cerca il bug." -ForegroundColor Yellow
Write-Host "  Poi: il verdetto e' PER MERCATO (una modalita' puo' vincere sul Nasdaq e" -ForegroundColor Yellow
Write-Host "  perdere sul DAX: e' un risultato, non una contraddizione)." -ForegroundColor Yellow
Write-Host "  Vince una modalita' solo con PF meglio di +0,10 sulla baseline del SUO" -ForegroundColor Yellow
Write-Host "  mercato, segno non ribaltato fra IS e OOS, DD non peggiore di 1 punto." -ForegroundColor Yellow
Write-Host "  Sotto 30 operazioni il MERITO e' sospeso (valvola R59)." -ForegroundColor Yellow
Write-Host "  E lo slippage e' a ZERO: la modalita' 0 e' avvantaggiata. Se vince lei," -ForegroundColor Yellow
Write-Host "  serve il giro 2 con un valore MISURATO, o la vittoria ha l'asterisco." -ForegroundColor Yellow

# =====================================================================
#  6. REFERTO + ZIP
# =====================================================================
$ref = @()
$ref += "REFERTO DI RACCOLTA - R83 DUELLO DEGLI INGRESSI"
$ref += ("data: " + (Get-Date -Format "yyyy-MM-dd HH:mm"))
$ref += ("riferimento (commit/branch): " + $Rif)
$ref += ("macchina: " + $env:COMPUTERNAME + "   utente: " + $env:USERNAME)
$ref += ("deposito: " + $Deposito + "   modello: " + $Modello)
$ref += ("EA in gara: " + $EAnew + "   EA di controprova: " + $EAvivo)
$ref += ("celle girate: " + (($celle | ForEach-Object { $_.K }) -join " "))
$ref += ("CSV attesi: " + $attesi.Count + "   mancanti: " + $mancanti)
$ref += ("serie per-trade raccolte: " + $nPerTrade + " (solo finestra OOS)")
$ref += "CANARINI DA VERIFICARE PRIMA DI LEGGERE IL DUELLO: N0 = cella A di R84; D1 = cella V."
if ($Modello -ne 4)  { $ref += "ATTENZIONE: modello " + $Modello + " = NON tick reali: su un duello di ingressi l'OHLC e' particolarmente bugiardo." }
if ($SaltaPassoZero) { $ref += "ATTENZIONE: PASSO 0 SALTATO: profondita' dei tick non verificata in questa corsa." }
if ($falliti.Count -gt 0) { $ref += ("CELLE USCITE IN ERRORE: " + ($falliti -join " ")) }
$ref += ""
$ref += "La riga 'data:' qui sopra deve essere di ADESSO. Se e' vecchia, stai"
$ref += "guardando una raccolta precedente e non i file di questa corsa."
$ref | Set-Content -Path (Join-Path $dest "REFERTO_RACCOLTA_R83.txt") -Encoding ASCII

$zip = Join-Path $desk ($nomeCartella + ".zip")
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
if ($mancanti -gt 0 -or $falliti.Count -gt 0) {
  Write-Host ("=== " + $mancanti + " CSV su " + $attesi.Count + " MANCANO. Guarda sopra qual e' stato l'errore. ===") -ForegroundColor Red
  Write-Host "    Si rilancia la STESSA riga: i CSV gia' fatti non si rifanno" -ForegroundColor Yellow
  Write-Host "    (per rifarli davvero serve -Rifai: senza, il driver li salta)." -ForegroundColor Yellow
  exit 1
} else {
  Write-Host ("=== TUTTI E " + $attesi.Count + " I CSV CI SONO. ===") -ForegroundColor Green
  Write-Host "    Questo round NON tocca il forward: nessuna sedia e' cambiata," -ForegroundColor Gray
  Write-Host "    e l'EA nuovo non sostituisce niente (gira in parallelo)." -ForegroundColor Gray
}
