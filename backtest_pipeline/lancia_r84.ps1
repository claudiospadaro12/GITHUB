# =====================================================================
#  lancia_r84.ps1  --  R84 ABLAZIONE DEI FILTRI DEL CORSO (Nasdaq)
#  UN FILTRO ALLA VOLTA, STESSO MOTORE, STESSA FINESTRA, STESSA CELLA
#  EA: ABTG_Nasdaq_Apertura_US (quello VIVO: questo round NON tocca
#      nemmeno una riga del suo codice, accende input che esistono gia')
# ---------------------------------------------------------------------
#  LA DOMANDA (congelata in prove\R84_ABLAZIONE_CRITERI.md, letta PRIMA):
#    "I filtri che il corso prescrive come CONDIZIONI aggiungono o
#     tolgono - misurato, un filtro alla volta, a parita' di tutto il
#     resto?"
#
#  PERCHE' ESISTE: l'audit del 02/08 spense tutti i filtri promettendo di
#  misurarli. La misura non e' mai stata finita (analisi del 18/08, par.
#  1.2: "l'ablazione dei filtri Nasdaq non risulta mai girata"). Quindi
#  oggi i filtri sono spenti NON perche' misurati inutili, ma perche' la
#  misura non c'e'. Finche' R84 non gira, "il metodo del corso non
#  funziona" resta NON DIMOSTRATO.
#
#  NOVE CELLE:
#    A base       nessun filtro (il metro)
#    B volumi     rottura confermata dai volumi (x1,5 su 20 barre)
#    C atr        ATR >= media a 20 barre
#    D volatr     volumi OPPURE ATR (la conferma come la scrive il PDF)
#    E ema        trend EMA 14/200 su H1
#    F supertrend Supertrend 10/2.5 su H1
#    G st3        tre Supertrend concordi (2.5/3.0/3.5)
#    H corr       indice guida SPXUSD concorde
#    I completo   TUTTE le condizioni insieme (il metodo del corso)
#
#  COSA FA QUESTO SCRIPT:
#    1. si rifiuta di partire se MetaTrader e' aperto;
#    2. riscarica walkforward_generico.ps1, i criteri e i file prova
#       PINNATI allo stesso commit (-Rif): mai la copia vecchia;
#    3. PASSO 0: controlla che la profondita' dei TICK del simbolo sia
#       stata MISURATA e che copra la finestra del round. Viene DOPO il
#       download apposta: la finestra si legge dal file prova appena
#       scaricato, non da una copia vecchia ne' da un numero scritto qui;
#    4. lancia le celle in fila;
#    5. raccoglie i CSV + le serie per-trade sul Desktop e ne fa lo zip,
#       con l'elenco dei file attesi controllato uno per uno.
#
#  DOVE: sul PC di BACKTEST, con MT5 CHIUSO. MAI SUL VPS.
#
#  PRIMA SEMPRE IL GIRO A VUOTO (-SoloControllo): non apre MT5, stampa
#  quante celle sono e cosa finirebbe in [TesterInputs]. Se una cella non
#  produce la sua anteprima, questo script esce 1 (difetto n.14: un giro
#  a vuoto che esce 0 anche se un pezzo e' fallito e' un guard finto).
#
#  E POI IL CANARINO:  -Solo A  (una cella sola). Costa una frazione e
#  misura sul serio compilazione, profondita' vera, CSV prodotti e
#  passate gemelle. Da li' si ricava la stima delle altre otto.
#
#  SUL TIMEOUT, detto com'e': walkforward_generico.ps1 lancia MT5 con
#  WaitForExit() SENZA limite (riga 633). Non c'e' nessun -TimeoutMin da
#  passargli, e non gliene aggiungiamo uno: un timeout che ammazza MT5 a
#  meta' corsa e' il difetto n.19 fatto in casa. Il timeout serve invece
#  al PASSO 0 (scarica_storico.ps1, default 90 minuti): li' si passa
#  esplicito, ed e' scritto nella riga qui sotto.
#
#  QUESTO ROUND NON TOCCA IL FORWARD e non promuove niente. La sedia
#  770201 e' SPENTA dal 18/08 (FIRMA 5) e resta spenta.
#
#  NOTA CULTURA INVARIANTE: questo script NON converte mai un numero dei
#  CSV dei risultati: li stampa come stringhe, esattamente come li scrive
#  MT5 (su Windows in italiano un parse senza InvariantCulture leggerebbe
#  "2.0" come VENTI). L'unica conversione e' sulle DATE del PASSO 0, ed
#  e' fatta con ParseExact + InvariantCulture, esplicita.
# =====================================================================
param(
  [string]$Rif      = "lavoro",                          # commit SHA (o branch)
  [string]$Cartella = (Join-Path $env:USERPROFILE "r84"),
  [int]$Deposito    = 10000,                             # deposito del tester
  [int]$Modello     = 4,                                 # 4 = tick reali. 1 = OHLC M1: SOLO se i tick non ci sono, e va DICHIARATO
  [string]$Solo     = "",                                # es. "A" oppure "A,B,I"
  [switch]$Rifai,                                        # rifa' anche i CSV gia' presenti
  [switch]$SoloControllo,                                # stampa e NON apre MT5
  [switch]$SaltaPassoZero                                # salta il controllo sulla profondita' dei tick (da dichiarare in chat)
)
$ErrorActionPreference = "Stop"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$Raw = "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$Rif"
$EA  = "ABTG_Nasdaq_Apertura_US"
$Sym = "NASUSD"

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

Write-Host "=== ROUND 84 - ABLAZIONE DEI FILTRI DEL CORSO (Nasdaq) ===" -ForegroundColor Cyan
Write-Host ("MACCHINA: " + $env:COMPUTERNAME + "   utente: " + $env:USERNAME) -ForegroundColor Cyan
Write-Host ("riferimento: " + $Rif) -ForegroundColor DarkGray
Write-Host ("data      : " + (Get-Date -Format "yyyy-MM-dd HH:mm")) -ForegroundColor DarkGray

# --- UNA MACCHINA, UN LAVORO. MT5 aperto = zero CSV.
if (Get-Process -Name "terminal64" -ErrorAction SilentlyContinue) {
  Muori ("MetaTrader e' APERTO. Chiudilo prima di lanciare, altrimenti escono 0 CSV." + "`n" +
         "    (e se sul PC sta girando un altro lavoro - HistData, Dukascopy, un altro" + "`n" +
         "     round - aspetta che finisca: c'e' un solo MT5)")
}

# =====================================================================
#  LE NOVE CELLE
# =====================================================================
$celle = @(
  @{ K="A"; Nome="base";       File="R84a_base_NASUSD.txt";       Tag="r84a"; Mag=@("776010","776011"); Cosa="nessun filtro (il metro)" }
  @{ K="B"; Nome="volumi";     File="R84b_volumi_NASUSD.txt";     Tag="r84b"; Mag=@("776020","776021"); Cosa="volumi >= 1,5 x media 20 barre" }
  @{ K="C"; Nome="atr";        File="R84c_atr_NASUSD.txt";        Tag="r84c"; Mag=@("776030","776031"); Cosa="ATR >= media 20 barre" }
  @{ K="D"; Nome="volatr";     File="R84d_volatr_NASUSD.txt";     Tag="r84d"; Mag=@("776040","776041"); Cosa="volumi OPPURE ATR (PDF)" }
  @{ K="E"; Nome="ema";        File="R84e_ema_NASUSD.txt";        Tag="r84e"; Mag=@("776050","776051"); Cosa="trend EMA 14/200 H1" }
  @{ K="F"; Nome="supertrend"; File="R84f_supertrend_NASUSD.txt"; Tag="r84f"; Mag=@("776060","776061"); Cosa="Supertrend 10/2.5 H1" }
  @{ K="G"; Nome="st3";        File="R84g_st3_NASUSD.txt";        Tag="r84g"; Mag=@("776070","776071"); Cosa="tre Supertrend concordi" }
  @{ K="H"; Nome="corr";       File="R84h_corr_NASUSD.txt";       Tag="r84h"; Mag=@("776080","776081"); Cosa="indice guida SPXUSD" }
  @{ K="I"; Nome="completo";   File="R84i_completo_NASUSD.txt";   Tag="r84i"; Mag=@("776090","776091"); Cosa="METODO COMPLETO del corso" }
)

if ($Solo -ne "") {
  $scelti = @()
  foreach ($s in ($Solo -split ",")) { $scelti += $s.Trim().ToUpper() }
  $celle = @($celle | Where-Object { $scelti -contains $_.K })
  if ($celle.Count -eq 0) { Muori "il filtro -Solo '$Solo' non seleziona nessuna cella (valide: A B C D E F G H I)." }
  Write-Host ("  -Solo attivo: giro solo " + (($celle | ForEach-Object { $_.K }) -join ", ")) -ForegroundColor Yellow
}

Write-Host ""
Write-Host ("  celle da girare: " + $celle.Count + "   modello: " + $Modello + "   deposito: " + $Deposito) -ForegroundColor White
if ($Modello -ne 4) {
  Write-Host "  ATTENZIONE: NON stai girando a tick reali. Ogni numero di questa corsa" -ForegroundColor Yellow
  Write-Host "  va scritto con accanto 'OHLC, non tick'. L'illusione OHLC ha gia'" -ForegroundColor Yellow
  Write-Host "  revocato una promozione in questa casa (SupRev DOW H4)." -ForegroundColor Yellow
}

# =====================================================================
#  1. ATTREZZI (riscaricati sempre, mai la copia vecchia)
# =====================================================================
Titolo "1) attrezzi (riscaricati sempre, pinnati a $Rif)"
$Prove = Join-Path $Cartella "prove"
New-Item -ItemType Directory -Force -Path $Prove | Out-Null

$file = @{}
$file["walkforward_generico.ps1"] = "$Raw/backtest_pipeline/walkforward_generico.ps1"
$file["prove\R84_ABLAZIONE_CRITERI.md"] = "$Raw/backtest_pipeline/prove/R84_ABLAZIONE_CRITERI.md"
foreach ($c in $celle) { $file["prove\" + $c.File] = "$Raw/backtest_pipeline/prove/" + $c.File }

foreach ($k in $file.Keys) {
  $dest = Join-Path $Cartella $k
  Remove-Item -LiteralPath $dest -Force -ErrorAction SilentlyContinue   # niente copia vecchia da eseguire
  try {
    Invoke-WebRequest -Uri $file[$k] -OutFile $dest -UseBasicParsing -ErrorAction Stop
    Write-Host ("    ok  " + $k) -ForegroundColor Green
  } catch {
    Muori ("non sono riuscito a scaricare " + $k + " da " + $Rif + "`n    " + $_.Exception.Message)
  }
}
# --- controllo di versione: e' il file NUOVO? (la cache di raw tiene ~5 minuti)
foreach ($c in $celle) {
  $p = Join-Path $Prove $c.File
  if (-not (Select-String -Path $p -SimpleMatch -Pattern "R84 / ABLAZIONE" -Quiet)) {
    Muori ("il file prova " + $c.File + " non contiene il marcatore R84: e' una copia sbagliata o vecchia.")
  }
}
$wf = Join-Path $Cartella "walkforward_generico.ps1"
if (-not (Select-String -Path $wf -SimpleMatch -Pattern "WALK-FORWARD GENERICO" -Quiet)) {
  Muori "walkforward_generico.ps1 scaricato non e' quello giusto (manca il marcatore)."
}

# --- le anteprime VECCHIE si buttano PRIMA: un'anteprima rimasta dal giro
#     precedente si legge come se fosse di adesso (referto stantio).
Get-ChildItem -Path $Cartella -Filter "anteprima_*.ini" -ErrorAction SilentlyContinue | ForEach-Object {
  try { Remove-Item -LiteralPath $_.FullName -Force } catch {}
}

# =====================================================================
#  PASSO 0 - LA PROFONDITA' DEI TICK, MISURATA (difetto n.18)
#
#  Il @DAQUANDO dei file prova (2024.09.26) e' la profondita' delle
#  BARRE degli indici. La profondita' dei TICK degli INDICI a BCM non
#  e' MAI stata misurata: il referto del 15/08 misura GBPUSD (tick dal
#  2024.07.05) e dice a chiare lettere "da misurare allo stesso modo:
#  i tick degli INDICI". Girare a modello 4 su una finestra piu' lunga
#  dei tick disponibili = meta' round su dati che non ci sono.
# =====================================================================
$desk = Trova-Desktop
$CsvStorico = Join-Path $desk "storico_bcm\ABTG_StoricoScaricato.csv"

if ($Modello -eq 4 -and -not $SaltaPassoZero) {
  Titolo "0) PASSO 0 - profondita' dei TICK di $Sym (misurata, non ipotizzata)"
  if (-not (Test-Path -LiteralPath $CsvStorico)) {
    Muori ("il referto della profondita' storica non c'e': " + $CsvStorico + "`n" +
           "    Lancialo PRIMA (MT5 chiuso), e col timeout dimensionato sulla stima:`n" +
           "      powershell -ExecutionPolicy Bypass -File `"$PSScriptRoot\scarica_storico.ps1`" -Simboli `"$Sym`" -Da 2024.01.01 -TimeoutMin 180 -Auto`n" +
           "    Poi si LEGGE la riga  $Sym,TICK  (colonna PrimaDataLocale), NON la riga M1:`n" +
           "    la profondita' si misura sul dato che il tester usa davvero (difetto n.18).`n" +
           "    Se i tick degli indici non esistono, si rilancia questo script con`n" +
           "      -Modello 1 -SaltaPassoZero   e OGNI numero porta scritto 'OHLC, non tick'.")
  }
  $righeStorico = @()
  try { $righeStorico = @(Import-Csv -LiteralPath $CsvStorico) } catch { Muori ("il referto storico non e' leggibile: " + $_.Exception.Message) }
  $rigaTick = @($righeStorico | Where-Object { $_.Simbolo -eq $Sym -and $_.Timeframe -eq "TICK" })
  if ($rigaTick.Count -eq 0) {
    Muori ("nel referto " + $CsvStorico + " non c'e' la riga  $Sym,TICK.`n" +
           "    Quel referto misura altri simboli o altri timeframe: rilancia scarica_storico.ps1 su $Sym.")
  }
  $dataTick = ($rigaTick[0].PrimaDataLocale + "").Trim()
  Write-Host ("    riga misurata: " + $Sym + ",TICK  barre/tick=" + $rigaTick[0].Barre + "  PrimaDataLocale=" + $dataTick) -ForegroundColor Gray
  if ($dataTick -eq "" -or $dataTick -eq "-") {
    Muori ("la colonna PrimaDataLocale della riga TICK e' vuota: i tick di $Sym NON ci sono sul disco.`n" +
           "    O li scarichi, o si gira a -Modello 1 -SaltaPassoZero dichiarando 'OHLC, non tick'.")
  }
  # --- la finestra del round si legge DAL FILE PROVA, non da qui: cosi'
  #     se un giorno si sposta, questo controllo si sposta con lei.
  $provaLocale = Join-Path $Cartella ("prove\" + $celle[0].File)
  $daQuando = ""
  if (Test-Path -LiteralPath $provaLocale) {
    $m = Select-String -Path $provaLocale -Pattern '^@DAQUANDO\s+(\S+)'
    if ($m) { $daQuando = $m.Matches[0].Groups[1].Value }
  }
  if ($daQuando -eq "") {
    Write-Host "    (il file prova non e' ancora sul disco: confronto rimandato al giro vero)" -ForegroundColor DarkYellow
  } else {
    $inv = [Globalization.CultureInfo]::InvariantCulture
    $dT = $null; $dW = $null
    try { $dT = [datetime]::ParseExact($dataTick, "yyyy.MM.dd", $inv) } catch {}
    try { $dW = [datetime]::ParseExact($daQuando, "yyyy.MM.dd", $inv) } catch {}
    if ($dT -eq $null -or $dW -eq $null) {
      Write-Host ("    non riesco a confrontare le due date ('" + $dataTick + "' e '" + $daQuando + "'): controllale a mano.") -ForegroundColor Yellow
    } elseif ($dT -gt $dW) {
      Muori ("I TICK DI $Sym PARTONO DOPO LA FINESTRA DEL ROUND.`n" +
             "    tick da  : " + $dataTick + "`n" +
             "    finestra : " + $daQuando + "  (@DAQUANDO nei file prova)`n" +
             "    Cosi' la prima parte della finestra e' VUOTA: e' l'errore che ha gia'`n" +
             "    rovinato un round sugli indici. Si riscrive il @DAQUANDO dei file prova`n" +
             "    con la data misurata, si aggiornano i criteri, e SI RILANCIA.")
    } else {
      Write-Host ("    ok: i tick partono dal " + $dataTick + ", la finestra dal " + $daQuando + ".") -ForegroundColor Green
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
      $f = Join-Path $Common ("abtg_trades_" + $EA + "_" + $Sym + "_" + $m + ".csv")
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
$Risultati = Join-Path $Cartella ("risultati_prove\" + $EA)
$falliti = @()
$i = 0
foreach ($c in $celle) {
  $i++
  Titolo ("2." + $i + ") CELLA " + $c.K + " - " + $c.Cosa + "   [" + $c.Tag + "]")

  $arg = @("-ExecutionPolicy","Bypass","-File",$wf,$EA,
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
    foreach ($m in $c.Mag) {
      $f = Join-Path $Common ("abtg_trades_" + $EA + "_" + $Sym + "_" + $m + ".csv")
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
  Titolo "3) ANTEPRIME PRODOTTE (una per cella) e filtri accesi"
  $senzaAnteprima = @()
  $ant = Join-Path $Cartella ("anteprima_" + $EA + "_" + $Sym + ".ini")
  # il driver scrive UNA anteprima per EA+simbolo: con nove celle la
  # sovrascrive ogni volta. Quindi si controlla che ci sia (l'ultima) e
  # si stampa; il confronto cella per cella si fa sui FILE PROVA, che
  # sono nove e stanno tutti nella cartella.
  if (-not (Test-Path -LiteralPath $ant)) {
    Write-Host "      (nessuna anteprima prodotta: qualcosa si e' fermato prima)" -ForegroundColor Red
    $senzaAnteprima += "anteprima"
  } else {
    $chiavi = "^(gEntryMode|InpEntryMode|InpRangeMode|InpLevelTF|InpBufferPoints|InpUseVolumeFilter|InpUseAtrFilter|InpConfirmMode|InpUseEmaFilter|InpUseSupertrend|InpUseSupertrend3|InpUseCorrelation|InpUseNewsFilter|InpUseRoundLevels|InpRiskPercent|InpMagic)="
    foreach ($r in (Select-String -Path $ant -Pattern $chiavi)) { Write-Host ("      " + $r.Line) -ForegroundColor Gray }
    foreach ($r in (Select-String -Path $ant -Pattern "^(Symbol|Period|FromDate|ToDate)=")) { Write-Host ("      " + $r.Line) -ForegroundColor DarkGray }
  }
  Write-Host ""
  Write-Host "  Le righe qui sopra sono dell'ULTIMA cella girata a vuoto." -ForegroundColor Yellow
  Write-Host "  Il confronto cella per cella si fa sui file prova scaricati in:" -ForegroundColor Yellow
  Write-Host ("     " + $Prove) -ForegroundColor Yellow
  Write-Host "  (diff R84a_base_NASUSD.txt R84g_st3_NASUSD.txt = una riga sola di differenza)" -ForegroundColor Yellow
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
#  4b. RACCOLTA SUL DESKTOP + ZIP (regola delle righe di lancio)
# =====================================================================
Titolo "3) raccolta sul Desktop"
$nomeCartella = "R84_ABLAZIONE_NASDAQ"
$dest = Join-Path $desk $nomeCartella
if (Test-Path $dest) { Remove-Item $dest -Recurse -Force -ErrorAction SilentlyContinue }
New-Item -ItemType Directory -Force -Path $dest | Out-Null

# suffisso dei CSV: il driver antepone "_ohlc" a tutto cio' che NON e' tick reali
$suff = if ($Modello -eq 4) { "" } else { "_ohlc" }
$attesi = @()
foreach ($c in $celle) {
  $attesi += ($EA + "_" + $Sym + "_IS"  + $suff + "_" + $c.Tag + ".csv")
  $attesi += ($EA + "_" + $Sym + "_OOS" + $suff + "_" + $c.Tag + ".csv")
}

if (Test-Path $Risultati) {
  foreach ($f in (Get-ChildItem $Risultati -Filter "*r84*.csv" -ErrorAction SilentlyContinue)) {
    try { Copy-Item -LiteralPath $f.FullName -Destination (Join-Path $dest $f.Name) -Force } catch { Write-Host ("    non copiato: " + $f.Name) -ForegroundColor Yellow }
  }
}
foreach ($c in $celle) { try { Copy-Item -LiteralPath (Join-Path $Prove $c.File) -Destination $dest -Force } catch {} }
try { Copy-Item -LiteralPath (Join-Path $Prove "R84_ABLAZIONE_CRITERI.md") -Destination $dest -Force } catch {}

Write-Host ""
Write-Host "    FILE ATTESI (controllali uno per uno):" -ForegroundColor White
$mancanti = 0
foreach ($a in $attesi) {
  if (Test-Path (Join-Path $dest $a)) { Write-Host ("      OK      " + $a) -ForegroundColor Green }
  else { Write-Host ("      MANCA  " + $a) -ForegroundColor Red; $mancanti++ }
}
$nPerTrade = @(Get-ChildItem $dest -Filter "pertrade_r84*.csv" -ErrorAction SilentlyContinue).Count
Write-Host ("      (serie per-trade raccolte: " + $nPerTrade + " - sono della SOLA finestra OOS, l'IS viene sovrascritta)") -ForegroundColor DarkGray

# =====================================================================
#  5. TABELLA DI LETTURA - solo stringhe, NESSUN parse numerico
# =====================================================================
Titolo "4) tabella (letta dai CSV, campi NON convertiti)"
Write-Host ("  {0,-2} {1,-11} {2,-4} {3,14} {4,10} {5,9} {6,7}  {7}" -f "","cella","fin.","Profit","PF","DD %","trades","magic") -ForegroundColor White
foreach ($c in $celle) {
  foreach ($w in @("IS","OOS")) {
    $csv = Join-Path $dest ($EA + "_" + $Sym + "_" + $w + $suff + "_" + $c.Tag + ".csv")
    if (-not (Test-Path -LiteralPath $csv)) {
      Write-Host ("  {0,-2} {1,-11} {2,-4} {3}" -f $c.K, $c.Nome, $w, "CSV MANCANTE") -ForegroundColor Red
      continue
    }
    $righe = @()
    try { $righe = @(Import-Csv -LiteralPath $csv) } catch { }
    if ($righe.Count -eq 0) {
      Write-Host ("  {0,-2} {1,-11} {2,-4} {3}" -f $c.K, $c.Nome, $w, "ZERO PASSATE (solo intestazione)") -ForegroundColor Red
      continue
    }
    foreach ($r in $righe) {
      Write-Host ("  {0,-2} {1,-11} {2,-4} {3,14} {4,10} {5,9} {6,7}  {7}" -f $c.K, $c.Nome, $w, $r.Profit, $r.'Profit Factor', $r.'Equity DD %', $r.Trades, $r.InpMagic) -ForegroundColor Gray
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
Write-Host "  I CRITERI SI LEGGONO PRIMA DELLA TABELLA: prove\R84_ABLAZIONE_CRITERI.md" -ForegroundColor Yellow
Write-Host "  Un filtro AGGIUNGE solo se: >=30 trade, segno non ribaltato fra IS e OOS," -ForegroundColor Yellow
Write-Host "  PF meglio della cella A di almeno +0,10, DD non peggiore di 1 punto." -ForegroundColor Yellow
Write-Host "  Sotto 30 operazioni il MERITO e' sospeso (valvola R59): si scrive" -ForegroundColor Yellow
Write-Host "  'non misurabile', mai 'peggiora'. Il RISCHIO invece si legge sempre." -ForegroundColor Yellow
Write-Host "  E questa finestra contiene UN REGIME E MEZZO: nessun numero di qui" -ForegroundColor Yellow
Write-Host "  puo' essere chiamato robusto, e nessuna cella va in forward da qui." -ForegroundColor Yellow

# =====================================================================
#  6. REFERTO + ZIP
# =====================================================================
$ref = @()
$ref += "REFERTO DI RACCOLTA - R84 ABLAZIONE FILTRI (Nasdaq apertura US)"
$ref += ("data: " + (Get-Date -Format "yyyy-MM-dd HH:mm"))
$ref += ("riferimento (commit/branch): " + $Rif)
$ref += ("macchina: " + $env:COMPUTERNAME + "   utente: " + $env:USERNAME)
$ref += ("deposito: " + $Deposito + "   modello: " + $Modello + "   EA: " + $EA + "   simbolo: " + $Sym)
$ref += ("celle girate: " + (($celle | ForEach-Object { $_.K }) -join " "))
$ref += ("CSV attesi: " + $attesi.Count + "   mancanti: " + $mancanti)
$ref += ("serie per-trade raccolte: " + $nPerTrade + " (solo finestra OOS)")
if ($Modello -ne 4)  { $ref += "ATTENZIONE: modello " + $Modello + " = NON tick reali. Ogni numero va letto come 'OHLC, non tick'." }
if ($SaltaPassoZero) { $ref += "ATTENZIONE: PASSO 0 SALTATO: la profondita' dei tick non e' stata verificata in questa corsa." }
if ($falliti.Count -gt 0) { $ref += ("CELLE USCITE IN ERRORE: " + ($falliti -join " ")) }
$ref += ""
$ref += "La riga 'data:' qui sopra deve essere di ADESSO. Se e' vecchia, stai"
$ref += "guardando una raccolta precedente e non i file di questa corsa."
$ref | Set-Content -Path (Join-Path $dest "REFERTO_RACCOLTA_R84.txt") -Encoding ASCII

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
  Write-Host "    Questo round NON tocca il forward: nessuna sedia e' cambiata." -ForegroundColor Gray
}
