# =====================================================================
#  lancia_r93.ps1  --  R93: IL FIBO H4 ALL'IMBUTO, DUE GAMBE
#  Scritto sul modello di lancia_r84bis.ps1 (stessa struttura, stesso pin).
# ---------------------------------------------------------------------
#  LE DUE DOMANDE, congelate in risultati_archivio\R93_CRITERI.md, che
#  vanno LETTE E FIRMATE PRIMA dei numeri:
#
#    GAMBA A  "il filtro news cambia l'edge del NOSTRO EA, e in che verso?"
#             banco ABTG_FiboH4_Multi v1.20, geometria INTOCCATA
#             6 file prova x 2 celle x 2 finestre = 24 passate
#
#    GAMBA B  "la geometria del CORSO opera, e con che profilo?"
#             banco ABTG_FiboH4_Corso v1.10, EA NUOVO, MAI COMPILATO
#             4 file prova x 2 simboli, 11 celle x 2 finestre = 44 passate
#
#  Totale 68 passate. UNA puo' passare e l'altra no: si giudicano SEPARATE.
#
#  >>> QUESTO SCRIPT NON PROMUOVE NIENTE E NON TOCCA NESSUNA SEDIA. <<<
#  Il FiboH4 NON e' in campo (assente da FLOTTA_ATTIVA e da
#  CONTRATTI_SEDIE, ed e' perfino in $KillSempre della pulizia VPS).
#  Magic 771602 (gamba A) e 771640 (gamba B): nessuna collisione.
#
#  E NON PUO' PRODURRE UN VERDETTO DI MERITO A TICK REALI, per aritmetica:
#  a BCM i tick di GBPUSD partono dal 2024.07.05 (misurato il 15/08),
#  mentre la finestra del round e' 2021.01.04 -> 2025.12.19 (l'intervallo
#  coperto dal calendario news). Quindi Modello 1, OHLC su M1, SCREENING.
#  In questa casa "l'OHLC e' solo screening, i verdetti solo a tick"
#  (R57: cambiato SOLO il modello, il segno si e' RIBALTATO).
#
#  DOVE: sul PC di BACKTEST, con MT5 CHIUSO. MAI SUL VPS.
#  UNA MACCHINA, UN LAVORO: c'e' un solo MT5. R92 deve essere FINITO.
#
#  L'ORDINE DELLE COSE (e non si salta):
#    passo 0  profondita' delle BARRE M1 dei tre cross (modello 1 le usa)
#    passo 1  attrezzi riscaricati e pinnati + il .mqh del Guardian
#    passo 2  il CALENDARIO NEWS messo dove il tester lo trova davvero
#    passo 3  GIRO A VUOTO (-SoloControllo): non apre MT5
#    passo 4  le 68 passate
#    passo 5  raccolta sul Desktop + zip pronto da mandare
#
#  IL PEZZO CHE PUO' FAR FALLIRE TUTTO, e per cui c'e' il passo 2:
#  nel tester OGNI AGENTE ha la SUA sandbox MQL5\Files, e
#  walkforward_generico.ps1 NON copia nessun file ausiliario (verificato
#  riga per riga). Un CSV lasciato solo in MQL5\Files del terminale NON
#  ARRIVA agli agenti: FileOpen fallisce e il filtro news si spegne DA
#  SOLO, in silenzio, e la cella "news ON" esce identica alla baseline.
#  Per questo l'EA legge da Common\Files, che gli agenti condividono, e
#  per questo stampa [FIBOH4][NEWS-CONTA] a fine passata.
#  >>> UNA CELLA "news ON" CON bloccate=0 SI BUTTA. Non e' "il filtro e'
#      neutro": e' "il filtro non e' stato eseguito". <<<
#
#  NOTA CULTURA INVARIANTE: nessun numero dei CSV viene convertito. Sono
#  stampati come STRINGHE, come li scrive MT5 (su Windows in italiano un
#  parse senza InvariantCulture leggerebbe "2.0" come VENTI). L'unica
#  conversione e' sulle DATE del passo 0, e usa ParseExact.
#
#  MARCATORE VERSIONE: R93-LANCIO-v3
#  (v2 = dopo la prima bocciatura del verificatore: i canarini escono dai
#   DATI e non da una Print, i due EA vengono compilati QUI invece che a
#   mano con F7, il canarino del pin si legge nei CSV e non nell'anteprima,
#   i per-trade non si mescolano piu' fra le celle, raccolta CUMULATIVA.
#   v3 = dopo la SECONDA: la raccolta era cumulativa per -Gamba ma ancora
#   DISTRUTTIVA per -Solo, cioe' proprio nel caso che i criteri
#   consigliano per rifare una cella. Piu' il referto mirato che non
#   seppellisce quello pieno e il conteggio dei CSV separato dai
#   per-trade. IL MARCATORE E' CAMBIATO APPOSTA: con la v2 la cache di
#   raw servirebbe uno script SENZA il fix e il gate direbbe verde.)
# =====================================================================
param(
  [string]$Rif      = "lavoro",                            # commit SHA (o branch)
  [string]$Cartella = (Join-Path $env:USERPROFILE "r93"),
  [int]$Deposito    = 10000,
  [int]$Modello     = 1,                                   # 1 = OHLC M1 (SCREENING). 4 = tick: qui NON e' possibile
  [string]$Gamba    = "",                                  # "A" oppure "B" (vuoto = tutte e due)
  [string]$Solo     = "",                                  # chiavi valide: A0..A5, BG1 BG2 BH1 BH2 BI1 BI2 BJ1 BJ2
  [switch]$Rifai,
  [switch]$SoloControllo,
  [switch]$SaltaPassoZero
)
$ErrorActionPreference = "Stop"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$Raw = "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$Rif"
$DaQuando = "2021.01.04"
$Fino     = "2025.12.19"
$NewsCsv  = "abtg_news_2021_2025_UTC.csv"

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

Write-Host "=== R93 - FIBO H4 ALL'IMBUTO (gamba A: filtro news | gamba B: geometria del corso) ===" -ForegroundColor Cyan
Write-Host ("MACCHINA: " + $env:COMPUTERNAME + "   utente: " + $env:USERNAME) -ForegroundColor Cyan
Write-Host ("riferimento: " + $Rif) -ForegroundColor DarkGray
Write-Host ("data       : " + (Get-Date -Format "yyyy-MM-dd HH:mm")) -ForegroundColor DarkGray
Write-Host ("finestra   : " + $DaQuando + " -> " + $Fino + "  (la copertura del calendario news)") -ForegroundColor DarkGray
# La fine della finestra IS, calcolata con la STESSA formula del driver
# (walkforward_generico.ps1: $Meta = Inizio + floor(giorni * FrazioneIS)),
# perche' e' quella che finira' scritta nelle anteprime .ini. Un atteso
# calcolato con un'altra formula manda Claudio a cercare un numero che non
# uscira' mai: e' il difetto 40-quater.
$FrazIS = 0.40
$dtIni  = [datetime]::ParseExact($DaQuando, "yyyy.MM.dd", [System.Globalization.CultureInfo]::InvariantCulture)
$dtFin  = [datetime]::ParseExact($Fino,     "yyyy.MM.dd", [System.Globalization.CultureInfo]::InvariantCulture)
$fineIS = $dtIni.AddDays([math]::Floor(($dtFin - $dtIni).TotalDays * $FrazIS)).ToString("yyyy.MM.dd")
Write-Host ("             IS " + $DaQuando + " -> " + $fineIS + "   OOS " + $dtIni.AddDays([math]::Floor(($dtFin - $dtIni).TotalDays * $FrazIS) + 1).ToString("yyyy.MM.dd") + " -> " + $Fino) -ForegroundColor DarkGray

if (Get-Process -Name "terminal64" -ErrorAction SilentlyContinue) {
  Muori ("MetaTrader e' APERTO. Chiudilo prima di lanciare, altrimenti escono 0 CSV." + "`n" +
         "    (e se sul PC sta girando un altro lavoro - R92, HistData, Dukascopy -" + "`n" +
         "     aspetta che finisca: c'e' un solo MT5)")
}

if ($Modello -eq 4) {
  Muori ("-Modello 4 su questa finestra NON e' possibile: a BCM i tick di GBPUSD partono" + "`n" +
         "    dal 2024.07.05 e la finestra di R93 comincia il " + $DaQuando + "." + "`n" +
         "    Girerebbe su meta' dei dati senza dirlo. R93 e' SCREENING OHLC: -Modello 1.")
}
if ($Modello -ne 1) {
  Write-Host ""
  Write-Host "  ATTENZIONE: modello diverso da 1. Ogni numero va scritto con accanto quale" -ForegroundColor Yellow
  Write-Host "  modello lo ha prodotto. L'illusione OHLC ha gia' revocato una promozione in" -ForegroundColor Yellow
  Write-Host "  questa casa (SupRev DOW H4), e il contrario e' altrettanto vero." -ForegroundColor Yellow
}

# =====================================================================
#  LE 14 CELLE (= 14 file prova). Una variabile alla volta, sempre.
#   K    = etichetta corta, quella che si usa con -Solo
#   G    = gamba (A / B)
#   Tag  = suffisso nel nome del CSV: un round nuovo non sovrascrive mai
#   News = questa cella accende il filtro notizie? (serve al passo 2 e
#          alla lettura del canarino)
# =====================================================================
$celle = @(
  # --- GAMBA A: il filtro news sul NOSTRO EA -----------------------
  @{ K="A0"; G="A"; EA="ABTG_FiboH4_Multi"; Sym="GBPUSD"; File="R93a_baseline.txt";
     Tag="r93a"; News=$false; Celle=2;
     Cosa="BASELINE (news SPENTO) + il DETERMINISMO del banco (magic gemello)" }
  @{ K="A1"; G="A"; EA="ABTG_FiboH4_Multi"; Sym="GBPUSD"; File="R93b_news.txt";
     Tag="r93b"; News=$true; Celle=2;
     Cosa="il filtro: blackout GLOBALE contro ESCLUSIONE PER VALUTA" }
  @{ K="A2"; G="A"; EA="ABTG_FiboH4_Multi"; Sym="GBPUSD"; File="R93c_fuso.txt";
     Tag="r93c"; News=$true; Celle=2;
     Cosa="quanto pesa UN'ORA di fuso (shift 0 = corso, +60 = repo)" }
  @{ K="A3"; G="A"; EA="ABTG_FiboH4_Multi"; Sym="GBPUSD"; File="R93d_toglio_ordini.txt";
     Tag="r93d"; News=$true; Celle=2;
     Cosa="la regola del corso: prima del dato gli ordini si TOLGONO (deroga 100 pip)" }
  @{ K="A4"; G="A"; EA="ABTG_FiboH4_Multi"; Sym="GBPUSD"; File="R93e_overnight.txt";
     Tag="r93e"; News=$false; Celle=2;
     Cosa="il cancello OVERNIGHT, misurato invece che acceso per fede" }
  @{ K="A5"; G="A"; EA="ABTG_FiboH4_Multi"; Sym="GBPUSD"; File="R93f_weekend.txt";
     Tag="r93f"; News=$false; Celle=2;
     Cosa="il cancello WEEKEND (mai e qua dico mai)" }

  # --- GAMBA B: la geometria del CORSO -----------------------------
  @{ K="BG1"; G="B"; EA="ABTG_FiboH4_Corso"; Sym="GBPUSD"; File="R93g_stop_GBPUSD.txt";
     Tag="r93g"; News=$false; Celle=4;
     Cosa="LO STOP: 4 dei 7 metodi del corso, l'asse piu' importante della gamba B" }
  @{ K="BG2"; G="B"; EA="ABTG_FiboH4_Corso"; Sym="USDJPY"; File="R93g_stop_USDJPY.txt";
     Tag="r93g"; News=$false; Celle=4;
     Cosa="LO STOP: 4 dei 7 metodi del corso" }
  @{ K="BH1"; G="B"; EA="ABTG_FiboH4_Corso"; Sym="GBPUSD"; File="R93h_trend_GBPUSD.txt";
     Tag="r93h"; News=$false; Celle=2;
     Cosa="la PRECONDIZIONE fine-di-un-trend, accesa contro spenta" }
  @{ K="BH2"; G="B"; EA="ABTG_FiboH4_Corso"; Sym="USDJPY"; File="R93h_trend_USDJPY.txt";
     Tag="r93h"; News=$false; Celle=2;
     Cosa="la PRECONDIZIONE fine-di-un-trend, accesa contro spenta" }
  @{ K="BI1"; G="B"; EA="ABTG_FiboH4_Corso"; Sym="GBPUSD"; File="R93i_ancoraggio_GBPUSD.txt";
     Tag="r93i"; News=$false; Celle=2;
     Cosa="l'ambiguita' del range (il minimo successivo): due letture, misurate" }
  @{ K="BI2"; G="B"; EA="ABTG_FiboH4_Corso"; Sym="USDJPY"; File="R93i_ancoraggio_USDJPY.txt";
     Tag="r93i"; News=$false; Celle=2;
     Cosa="l'ambiguita' del range: due letture, misurate" }
  @{ K="BJ1"; G="B"; EA="ABTG_FiboH4_Corso"; Sym="GBPUSD"; File="R93j_zona_GBPUSD.txt";
     Tag="r93j"; News=$false; Celle=3;
     Cosa="quale entry zone: solo EZ2 (il corso), solo EZ1, oppure fallback" }
  @{ K="BJ2"; G="B"; EA="ABTG_FiboH4_Corso"; Sym="USDJPY"; File="R93j_zona_USDJPY.txt";
     Tag="r93j"; News=$false; Celle=3;
     Cosa="quale entry zone: solo EZ2 (il corso), solo EZ1, oppure fallback" }
)

# --- selezione
if ($Gamba -ne "") {
  $g = $Gamba.Trim().ToUpper()
  if ($g -ne "A" -and $g -ne "B") { Muori "-Gamba accetta solo A o B." }
  $celle = @($celle | Where-Object { $_.G -eq $g })
  Write-Host ("  -Gamba attiva: " + $g) -ForegroundColor Yellow
}
if ($Solo -ne "") {
  $scelti = @()
  foreach ($s in ($Solo -split ",")) { $scelti += $s.Trim().ToUpper() }
  $celle = @($celle | Where-Object { $scelti -contains $_.K })
  if ($celle.Count -eq 0) { Muori "il filtro -Solo '$Solo' non seleziona nessuna cella." }
  Write-Host ("  -Solo attivo: " + ($scelti -join ", ")) -ForegroundColor Yellow
}

$passateAttese = 0
foreach ($c in $celle) { $passateAttese += ($c.Celle * 2) }
Write-Host ("  celle in coda: " + $celle.Count + " file prova -> " + $passateAttese + " passate") -ForegroundColor White

$simboli = @($celle | ForEach-Object { $_.Sym } | Select-Object -Unique)
# gamba A: l'EA e' MULTI-SIMBOLO e opera sul basket, non sul grafico.
# I cross del basket entrano nel passo 0 come tutti gli altri.
if (@($celle | Where-Object { $_.G -eq "A" }).Count -gt 0) {
  foreach ($s in @("USDJPY","EURUSD","GBPUSD")) { if ($simboli -notcontains $s) { $simboli += $s } }
}

# =====================================================================
#  1. ATTREZZI (riscaricati sempre, mai la copia vecchia)
# =====================================================================
Titolo "1) attrezzi (riscaricati sempre, pinnati a $Rif)"
New-Item -ItemType Directory -Force -Path $Cartella | Out-Null
$Prove = Join-Path $Cartella "prove"
New-Item -ItemType Directory -Force -Path $Prove | Out-Null

$file = @{}
$file["walkforward_generico.ps1"] = "$Raw/backtest_pipeline/walkforward_generico.ps1"
$file["R93_CRITERI.md"]           = "$Raw/backtest_pipeline/risultati_archivio/R93_CRITERI.md"
$file[$NewsCsv]                   = "$Raw/mql5/Files/$NewsCsv"
$file["ABTG_PausaGuardian.mqh"]   = "$Raw/mql5/Include/ABTG_PausaGuardian.mqh"
foreach ($c in $celle) { $file["prove\" + $c.File] = "$Raw/backtest_pipeline/prove/" + $c.File }
# --- I DUE .mq5. Li scarica QUESTO script, non walkforward_generico:
#     il suo ramo -SoloControllo esce a riga 538, mentre copia e compila
#     stanno alle righe 601-603, cioe' DOPO. Senza queste due righe, dopo
#     il giro a vuoto sulla macchina non c'e' nessun sorgente da compilare
#     e "premi F7" sarebbe un giro a vuoto su un file che non esiste.
foreach ($e in @($celle | ForEach-Object { $_.EA } | Select-Object -Unique)) {
  $file[($e + ".mq5")] = "$Raw/mql5/Experts/$e.mq5"
}

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

# --- controllo di versione: la cache di raw.githubusercontent tiene ~5
#     minuti. Ogni file prova deve contenere il marcatore del round.
foreach ($c in $celle) {
  $p = Join-Path $Prove $c.File
  if (-not (Select-String -Path $p -SimpleMatch -Pattern "R93 -- FIBO H4 ALL'IMBUTO" -Quiet)) {
    Muori ("il file prova " + $c.File + " non contiene il marcatore R93: e' una copia vecchia o sbagliata.")
  }
}
$wf = Join-Path $Cartella "walkforward_generico.ps1"
if (-not (Select-String -Path $wf -SimpleMatch -Pattern "WALK-FORWARD GENERICO" -Quiet)) {
  Muori "walkforward_generico.ps1 scaricato non e' quello giusto (manca il marcatore)."
}

# --- IL PIN NON COPRE L'EA (difetto n.24 della checklist).
#     walkforward_generico.ps1 ha $EABranch="lavoro" SCRITTO FISSO e
#     riscarica il .mq5 da HEAD ignorando -Rif; se il download fallisce
#     ripiega IN SILENZIO sulla copia locale. Su un round di due ore
#     questo vuol dire che un push a meta' corsa puo' cambiare il motore
#     FRA UNA CELLA E L'ALTRA. Qui si confronta byte a byte.
if ($Rif -ne "lavoro") {
  foreach ($ea in @($celle | ForEach-Object { $_.EA } | Select-Object -Unique)) {
    $u1 = "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/lavoro/mql5/Experts/$ea.mq5"
    $u2 = "$Raw/mql5/Experts/$ea.mq5"
    try {
      $a = (Invoke-WebRequest -Uri $u1 -UseBasicParsing -ErrorAction Stop).Content
      $b = (Invoke-WebRequest -Uri $u2 -UseBasicParsing -ErrorAction Stop).Content
      if ($a -ne $b) {
        Muori ("il branch 'lavoro' e il pin '" + $Rif + "' hanno DUE VERSIONI DIVERSE di " + $ea + ".mq5." + "`n" +
               "    Il driver scarica l'EA da 'lavoro' HEAD, non dal pin: girerebbe un motore" + "`n" +
               "    diverso da quello che credi di aver pinnato. O allinei, o lanci con -Rif lavoro" + "`n" +
               "    DICHIARANDO il congelamento del branch per tutta la durata del round.")
      }
    } catch {
      Write-Host ("    (non ho potuto confrontare " + $ea + ": " + $_.Exception.Message + ")") -ForegroundColor Yellow
    }
  }
} else {
  # -Rif lavoro: non c'e' niente da confrontare con un pin, ma si prende
  # la FOTOGRAFIA D'INIZIO CORSA dei due .mq5 (hash del contenuto). A fine
  # corsa la si rifa': se e' cambiata, qualcuno ha pushato mentre giravamo
  # e il motore e' cambiato FRA UNA CELLA E L'ALTRA. Meglio saperlo che
  # fidarsi di una raccomandazione scritta in un referto.
  Write-Host "    -Rif lavoro: il branch va CONGELATO per tutta la durata del round." -ForegroundColor Yellow
  Write-Host "    (il driver riscarica l'EA da 'lavoro' HEAD a ogni cella: un push a meta'" -ForegroundColor Yellow
  Write-Host "     corsa cambierebbe il motore fra una cella e l'altra)" -ForegroundColor Yellow
  $script:FotoEA = @{}
  foreach ($ea in @($celle | ForEach-Object { $_.EA } | Select-Object -Unique)) {
    try {
      $txt = (Invoke-WebRequest -Uri "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/lavoro/mql5/Experts/$ea.mq5" -UseBasicParsing -ErrorAction Stop).Content
      $md5 = [System.BitConverter]::ToString(
               (New-Object System.Security.Cryptography.MD5CryptoServiceProvider).ComputeHash(
                 [System.Text.Encoding]::UTF8.GetBytes($txt))).Replace("-","")
      $script:FotoEA[$ea] = $md5
      Write-Host ("      foto d'inizio  " + $ea + "  " + $md5.Substring(0,12)) -ForegroundColor DarkGray
    } catch {
      Write-Host ("      (non ho potuto fotografare " + $ea + ": " + $_.Exception.Message + ")") -ForegroundColor Yellow
    }
  }
}

# --- le anteprime del giro precedente vanno via PRIMA (difetto n.14):
#     un'anteprima rimasta sul disco verrebbe letta come quella di adesso,
#     ed e' il referto stantio del 17/08 travestito da giro a vuoto.
Get-ChildItem -Path $Cartella -Filter "anteprima_*.ini" -ErrorAction SilentlyContinue | ForEach-Object {
  try { Remove-Item -LiteralPath $_.FullName -Force } catch {}
}
$sostaAnt = Join-Path $Cartella "anteprime"
if (Test-Path $sostaAnt) { Remove-Item -LiteralPath $sostaAnt -Recurse -Force -ErrorAction SilentlyContinue }

# =====================================================================
#  1-bis. LA CARTELLA DATI DI MT5 (serve al Guardian e al calendario)
# =====================================================================
$allTerm = Get-ChildItem "C:\Program Files","C:\Program Files (x86)" -Recurse -Filter "terminal64.exe" -ErrorAction SilentlyContinue
$cand = $allTerm | Where-Object { $_.DirectoryName -like "*BCM Markets MT5 Terminal*" -and $_.DirectoryName -notlike "*-V3*" } | Select-Object -First 1
if (-not $cand) { $cand = $allTerm | Where-Object { $_.DirectoryName -like "*BCM Markets*" } | Select-Object -First 1 }
if (-not $cand) { Muori "terminale BCM non trovato." }
$instDir = $cand.DirectoryName
$termRoot = Join-Path $env:APPDATA "MetaQuotes\Terminal"
$DataFolder = Get-ChildItem $termRoot -Directory -ErrorAction SilentlyContinue | Where-Object {
  $o = Join-Path $_.FullName "origin.txt"
  (Test-Path $o) -and ((Get-Content $o -Raw).Trim() -ieq $instDir)
} | Select-Object -First 1 -ExpandProperty FullName
if (-not $DataFolder) { Muori "cartella dati MT5 non trovata." }
Write-Host ("    cartella dati MT5: " + $DataFolder) -ForegroundColor DarkGray

# --- IL .mqh DEL GUARDIAN. walkforward_generico.ps1 scarica SOLO il
#     .mq5: se l'include non c'e', la COMPILAZIONE FALLISCE e il round
#     muore al primo passo. Qui si installa, e si VERIFICA sul contenuto
#     (non con Test-Path: se in $dst ci fosse una cartella con lo stesso
#     nome, Copy-Item ci metterebbe il file DENTRO e Test-Path direbbe si').
$IncDir = Join-Path $DataFolder "MQL5\Include"
New-Item -ItemType Directory -Force -Path $IncDir | Out-Null
$srcMqh = Join-Path $Cartella "ABTG_PausaGuardian.mqh"
$dstMqh = Join-Path $IncDir "ABTG_PausaGuardian.mqh"
$lenMqh = (Get-Item -LiteralPath $srcMqh).Length
Copy-Item -LiteralPath $srcMqh -Destination $dstMqh -Force -ErrorAction Stop
$v = Get-Item -LiteralPath $dstMqh -ErrorAction Stop
if ($v.PSIsContainer -or $v.Length -ne $lenMqh) { Muori "ABTG_PausaGuardian.mqh: copia NON verificata." }
# Il marcatore NON puo' essere ABTG_GuardiaIngresso: c'e' anche nelle
# versioni VECCHIE del .mqh, quindi un include stantio passerebbe il gate.
# Entrambi gli EA chiamano ABTG_AutotestGuardia(), che e' della v1.20: se
# manca QUELLA, la compilazione fallirebbe piu' avanti con un errore che non
# dice niente. Meglio morire qui, dicendo cosa manca.
if (-not (Select-String -Path $dstMqh -SimpleMatch -Pattern "ABTG_AutotestGuardia" -Quiet)) {
  Muori ("ABTG_PausaGuardian.mqh installato ma NON contiene ABTG_AutotestGuardia():" + "`n" +
         "    e' una versione VECCHIA dell'include. I due EA di R93 la chiamano" + "`n" +
         "    nell'autotest e senza di lei NON COMPILANO. Aggiorna il .mqh (v1.20+).")
}
Write-Host ("    ok  MQL5\Include\ABTG_PausaGuardian.mqh (" + $lenMqh + " byte)") -ForegroundColor Green

# =====================================================================
#  1-ter. I DUE EA: INSTALLATI E COMPILATI QUI, NON A MANO CON F7
#  Vale SIA in -SoloControllo SIA nella corsa vera, ed e' il punto: una
#  compilazione fallita muore adesso, in tre minuti, invece che al blocco
#  4 dopo due ore di macchina. Prima si toglie l'.ex5 VECCHIO: senza,
#  un binario di ieri fa passare il gate su una compilazione fallita oggi
#  (e' il difetto n.23, l'artefatto scaduto, applicato al compilato).
# =====================================================================
$MqlExp = Join-Path $DataFolder "MQL5\Experts"
New-Item -ItemType Directory -Force -Path $MqlExp | Out-Null
$MetaEditor = Join-Path $instDir "metaeditor64.exe"
if (-not (Test-Path -LiteralPath $MetaEditor)) { Muori ("metaeditor64.exe non trovato in " + $instDir) }

foreach ($ea in @($celle | ForEach-Object { $_.EA } | Select-Object -Unique)) {
  $srcEa = Join-Path $Cartella ($ea + ".mq5")
  $dstEa = Join-Path $MqlExp   ($ea + ".mq5")
  $exEa  = Join-Path $MqlExp   ($ea + ".ex5")
  $lenEa = (Get-Item -LiteralPath $srcEa).Length

  Remove-Item -LiteralPath $exEa -Force -ErrorAction SilentlyContinue
  Copy-Item -LiteralPath $srcEa -Destination $dstEa -Force -ErrorAction Stop
  $vEa = Get-Item -LiteralPath $dstEa -ErrorAction Stop
  # la copia si verifica sul CONTENUTO, non con Test-Path: se in $dstEa ci
  # fosse una cartella con lo stesso nome, Copy-Item ci metterebbe il file
  # DENTRO e Test-Path direbbe di si' (difetto n.27-ter).
  if ($vEa.PSIsContainer -or $vEa.Length -ne $lenEa) { Muori ($ea + ".mq5: copia NON verificata.") }

  & $MetaEditor ("/compile:" + $dstEa) "/log" | Out-Null
  if (-not (Test-Path -LiteralPath $exEa)) {
    Muori ($ea + ".mq5 NON COMPILA." + "`n" +
           "    Apri MetaEditor su " + $dstEa + " e guarda gli errori." + "`n" +
           "    (ABTG_FiboH4_Corso.mq5 non e' MAI stato compilato da nessuno: se" + "`n" +
           "     e' lui, e' l'esito piu' probabile ed e' proprio quello che questo" + "`n" +
           "     passo serve a scoprire adesso invece che fra due ore.)")
  }
  Write-Host ("    ok  compilato " + $ea + ".ex5 (" + (Get-Item -LiteralPath $exEa).Length + " byte)") -ForegroundColor Green
}

# =====================================================================
#  2. IL CALENDARIO NEWS, MESSO DOVE IL TESTER LO TROVA DAVVERO
#  E' il passo che puo' far fallire il round, e va fatto anche quando
#  nessuna cella accende il filtro: cosi' il file c'e' comunque e una
#  cella lanciata a mano dopo non trova il vuoto.
# =====================================================================
Titolo "2) il calendario news (Common\Files + sandbox del terminale)"
$Common = Join-Path $env:APPDATA "MetaQuotes\Terminal\Common\Files"
$MqlFiles = Join-Path $DataFolder "MQL5\Files"
New-Item -ItemType Directory -Force -Path $Common, $MqlFiles | Out-Null
$srcCsv = Join-Path $Cartella $NewsCsv
$lenCsv = (Get-Item -LiteralPath $srcCsv).Length
$righeCsv = @(Get-Content -LiteralPath $srcCsv).Count
foreach ($d in @($Common, $MqlFiles)) {
  $dst = Join-Path $d $NewsCsv
  Copy-Item -LiteralPath $srcCsv -Destination $dst -Force -ErrorAction Stop
  $vv = Get-Item -LiteralPath $dst -ErrorAction Stop
  if ($vv.PSIsContainer -or $vv.Length -ne $lenCsv) { Muori ("calendario: copia NON verificata in " + $d) }
  Write-Host ("    ok  " + $dst) -ForegroundColor Green
}
Write-Host ("    righe: " + $righeCsv + " (attese ~2.972: intestazione + 2.971 eventi ad alto impatto)") -ForegroundColor DarkGray
$prima = (Get-Content -LiteralPath $srcCsv -TotalCount 2)[1]
$ultima = (Get-Content -LiteralPath $srcCsv)[-1]
Write-Host ("    primo evento : " + $prima) -ForegroundColor DarkGray
Write-Host ("    ultimo evento: " + $ultima) -ForegroundColor DarkGray
Write-Host "    IL CSV E' IN UTC. L'ora del server la fa InpNewsShiftMinutes nel file prova." -ForegroundColor Yellow
$celleNews = @($celle | Where-Object { $_.News }).Count
if ($celleNews -gt 0) {
  Write-Host ("    " + $celleNews + " celle di questo giro accendono il filtro. A fine passata leggi:") -ForegroundColor Yellow
  Write-Host "       [FIBOH4][NEWS-CONTA] ... bloccate=N (X%)      atteso X fra 8% e 12%" -ForegroundColor Yellow
  Write-Host "       bloccate=0  -> LA CELLA SI BUTTA: il filtro non e' stato eseguito." -ForegroundColor Yellow
}

# =====================================================================
#  3. PASSO 0 - LA PROFONDITA' DELLE BARRE M1 (difetto n.18)
#  Il tester a modello 1 costruisce le sue barre dall'M1, non dall'H4:
#  la profondita' che morde e' quella dell'M1. Si legge la riga M1,
#  colonna PrimaDataServer. (Sulle righe TICK quella colonna vale sempre
#  "-": per i tick si guarda PrimaDataLocale. Qui i tick non servono.)
# =====================================================================
$desk = Trova-Desktop
$CsvStorico = Join-Path $desk "storico_bcm\ABTG_StoricoScaricato.csv"
if (-not $SaltaPassoZero) {
  Titolo ("0) PASSO 0 - profondita' delle BARRE M1 di " + ($simboli -join ", "))
  if (-not (Test-Path -LiteralPath $CsvStorico)) {
    Muori ("il referto dello storico non c'e': " + $CsvStorico + "`n" +
           "    Misuralo PRIMA (MT5 chiuso, ~10-30 minuti):" + "`n" +
           "      .\scarica_storico.ps1 -Auto -SenzaTick -Da 2021.01.01 -Simboli `"" + ($simboli -join ",") + "`" -TimeoutMin 240" + "`n" +
           "    Poi rilancia. Oppure -SaltaPassoZero, e allora VA DETTO in chat.")
  }
  # L'ARTEFATTO DI INPUT SCADUTO (difetto n.23): non basta che esista.
  $eta = (New-TimeSpan -Start (Get-Item -LiteralPath $CsvStorico).LastWriteTime -End (Get-Date)).TotalHours
  if ($eta -gt 48) {
    Muori ("il referto dello storico ha " + [int]$eta + " ore: e' la foto di un'altra volta." + "`n" +
           "    Rifai la misura prima di girare (comando qui sopra).")
  }
  Write-Host ("    referto di " + (Get-Item -LiteralPath $CsvStorico).LastWriteTime.ToString("yyyy-MM-dd HH:mm") + " (" + [int]$eta + " ore fa)") -ForegroundColor DarkGray

  $inizio = [datetime]::ParseExact($DaQuando, "yyyy.MM.dd", [System.Globalization.CultureInfo]::InvariantCulture)
  # IL SEPARATORE E' LA VIRGOLA: ABTG_HistoryDownloader.mq5 riga 139 apre con
  # FileOpen(..., FILE_CSV|FILE_ANSI|FILE_SHARE_READ, ","). Con -Delimiter ";"
  # Import-Csv NON fallisce: restituisce UNA colonna sola con dentro tutta la
  # riga, e ogni Where-Object dopo non trova mai niente. E' un errore che esce
  # silenzioso, quindi qui il separatore NON si passa (default = virgola) e
  # subito dopo si VERIFICA che le colonne attese ci siano davvero.
  try { $righeSt = @(Import-Csv -LiteralPath $CsvStorico) } catch { Muori ("il referto storico non e' leggibile: " + $_.Exception.Message) }
  if ($righeSt.Count -eq 0) { Muori ("il referto storico e' vuoto: " + $CsvStorico) }
  $colonne = @($righeSt[0].PSObject.Properties.Name)
  foreach ($col in @("Simbolo","Timeframe","PrimaDataServer","PrimaDataLocale")) {
    if ($colonne -notcontains $col) {
      Muori ("il referto storico non ha la colonna '" + $col + "' (trovate: " + ($colonne -join ", ") + ")." + "`n" +
             "    Non e' il file giusto, oppure il formato e' cambiato: non si tira a indovinare.")
    }
  }
  $corti = @()
  foreach ($sy in $simboli) {
    $r = @($righeSt | Where-Object { $_.Simbolo -eq $sy -and $_.Timeframe -eq "M1" }) | Select-Object -First 1
    if (-not $r) { $corti += ($sy + " (riga M1 ASSENTE nel referto)"); continue }
    # DUE date, e vogliono dire due cose diverse:
    #   PrimaDataServer  = il piu' vecchio dato che il BROKER possiede
    #   PrimaDataLocale  = quello che sta sul DISCO adesso
    # Il tester puo' scaricare quello che manca, ma su GBPUSD il referto del
    # 15/08 diceva "MANCA STORICO LOCALE: rilancia" con server 1993 e locale
    # 2014: il broker ce l'ha, il disco no. Si guardano tutte e due.
    $dSrv = ("" + $r.PrimaDataServer).Trim()
    $dLoc = ("" + $r.PrimaDataLocale).Trim()
    $dtSrv = $null; $dtLoc = $null
    foreach ($fmt in @("yyyy.MM.dd HH:mm", "yyyy.MM.dd")) {
      if (-not $dtSrv) { try { $dtSrv = [datetime]::ParseExact($dSrv, $fmt, [System.Globalization.CultureInfo]::InvariantCulture) } catch {} }
      if (-not $dtLoc) { try { $dtLoc = [datetime]::ParseExact($dLoc, $fmt, [System.Globalization.CultureInfo]::InvariantCulture) } catch {} }
    }
    if (-not $dtSrv) { $corti += ($sy + " (PrimaDataServer illeggibile: '" + $dSrv + "')"); continue }
    if ($dtSrv -gt $inizio) {
      $corti += ($sy + " (il BROKER ha M1 solo dal " + $dtSrv.ToString("yyyy.MM.dd") + ", la finestra dal " + $DaQuando + ")")
      continue
    }
    Write-Host ("    ok  " + $sy + ": il broker ha barre M1 dal " + $dtSrv.ToString("yyyy.MM.dd")) -ForegroundColor Green
    if ($dtLoc -and $dtLoc -gt $inizio) {
      Write-Host ("        ma sul DISCO partono dal " + $dtLoc.ToString("yyyy.MM.dd") + ": il tester dovra' scaricarle.") -ForegroundColor Yellow
      Write-Host ("        Se la prima passata esce con pochissime operazioni, e' questo: rifai") -ForegroundColor Yellow
      Write-Host ("        il passo 0 finche' il Verdetto della riga M1 dice COMPLETO.") -ForegroundColor Yellow
    }
    Write-Host ("        verdetto del referto: " + $r.Verdetto) -ForegroundColor DarkGray
  }
  if ($corti.Count -gt 0) {
    Write-Host ""
    Write-Host "!!! FINESTRA CORTA su:" -ForegroundColor Red
    foreach ($x in $corti) { Write-Host ("      " + $x) -ForegroundColor Red }
    Muori ("Non si interpreta: o si SPOSTA la finestra (e si rifa' l'aritmetica del campione" + "`n" +
           "    nei criteri, par. 4.2), o si scarica lo storico. E' il difetto n.18 della" + "`n" +
           "    checklist, gia' pagato sugli indici.")
  }
} else {
  Write-Host ""
  Write-Host "  -SaltaPassoZero: il controllo sulla profondita' M1 E' STATO SALTATO." -ForegroundColor Yellow
  Write-Host "  Va detto in chat accanto ai risultati, altrimenti nessuno sa su che dati girano." -ForegroundColor Yellow
}

# =====================================================================
#  4. LE SERIE PER-TRADE VECCHIE (un artefatto di ieri letto come di oggi
#     e' il referto stantio del 17/08 prodotto in casa)
# =====================================================================
if ((-not $SoloControllo) -and (Test-Path $Common)) {
  $puliti = 0
  foreach ($ea in @($celle | ForEach-Object { $_.EA } | Select-Object -Unique)) {
    Get-ChildItem -Path $Common -Filter ("abtg_trades_" + $ea + "_*.csv") -ErrorAction SilentlyContinue | ForEach-Object {
      try { Remove-Item -LiteralPath $_.FullName -Force; $puliti++ } catch {}
    }
  }
  if ($puliti -gt 0) { Write-Host ("    ripulite " + $puliti + " serie per-trade di corse precedenti") -ForegroundColor DarkYellow }
}

# =====================================================================
#  5. LE CORSE
# =====================================================================
$falliti = @()
$i = 0
foreach ($c in $celle) {
  $i++
  Titolo ("3." + $i + ") CELLA " + $c.K + " [gamba " + $c.G + "] - " + $c.Cosa)
  Write-Host ("      EA " + $c.EA + " | " + $c.Sym + " | prova " + $c.File + " | " + $c.Celle + " celle | news " + $(if ($c.News) { "ACCESO" } else { "spento" })) -ForegroundColor DarkGray

  # L'ANTEPRIMA NON PORTA L'ETICHETTA NEL NOME (difetto n.31 della
  # checklist): walkforward_generico.ps1 la chiama
  # anteprima_<EA>_<Simbolo>.ini, e in gamba A SEI celle hanno lo stesso
  # EA e lo stesso simbolo. Senza questo, alla fine del giro a vuoto ne
  # resterebbe UNA sola, quella dell'ultima cella, e nessuno lo direbbe.
  # Si cancella PRIMA, e subito dopo si mette al sicuro con un nome PROPRIO.
  $ant = Join-Path $Cartella ("anteprima_" + $c.EA + "_" + $c.Sym + ".ini")
  Remove-Item -LiteralPath $ant -Force -ErrorAction SilentlyContinue

  # L'ISTANTE DI INIZIO DELLA CELLA. Serve alla raccolta dei per-trade qui
  # sotto: senza, il glob ripesca i file che le celle PRECEDENTI hanno
  # lasciato in Common\Files e li ribattezza col tag di QUESTA. Un file con
  # dentro r93g/USDJPY uscirebbe etichettato r93h/GBPUSD, e nessuno lo
  # saprebbe. Si prende PRIMA di lanciare, mai dopo.
  $tCella = Get-Date

  $arg = @("-ExecutionPolicy","Bypass","-File",$wf,$c.EA,
           "-Prova",("prove\" + $c.File),
           "-Modello","$Modello",
           "-Deposito","$Deposito",
           "-Fino",$Fino,
           "-DaQuando",$DaQuando,
           "-Etichetta",$c.Tag)
  if ($SoloControllo) { $arg += "-SoloControllo" }
  if ($Rifai)         { $arg += "-Rifai" }

  $global:LASTEXITCODE = 0
  & powershell $arg

  if (Test-Path -LiteralPath $ant) {
    $sosta = Join-Path $Cartella "anteprime"
    New-Item -ItemType Directory -Force -Path $sosta | Out-Null
    try { Move-Item -LiteralPath $ant -Destination (Join-Path $sosta ($c.K + "_" + $c.Tag + ".ini")) -Force } catch {}
  }
  if ($LASTEXITCODE -ne 0) {
    Write-Host ("    cella " + $c.K + " uscita con codice " + $LASTEXITCODE + ": vado avanti, la raccolta dira' cosa manca.") -ForegroundColor Yellow
    $falliti += $c.K
    continue
  }
  if ($SoloControllo) { continue }

  # la serie per-trade, subito, con un nome PROPRIO (difetto n.26) e SOLO
  # quella prodotta da QUESTA cella: filtro sul simbolo E sull'orario.
  $Risultati = Join-Path $Cartella ("risultati_prove\" + $c.EA)
  if (Test-Path $Common) {
    $freschi = @(Get-ChildItem -Path $Common -Filter ("abtg_trades_" + $c.EA + "_" + $c.Sym + "_*.csv") -ErrorAction SilentlyContinue |
                 Where-Object { $_.LastWriteTime -ge $tCella })
    foreach ($f in $freschi) {
      New-Item -ItemType Directory -Force -Path $Risultati | Out-Null
      try {
        Copy-Item -LiteralPath $f.FullName -Destination (Join-Path $Risultati ("pertrade_" + $c.Tag + "_" + $c.Sym + "_" + $f.Name)) -Force
      } catch {}
    }
    if ($freschi.Count -eq 0) {
      Write-Host "    (nessun per-trade NUOVO da questa cella: normale se il pass era in cache)" -ForegroundColor DarkGray
    }
  }
}

# =====================================================================
#  6. GIRO A VUOTO: il codice d'uscita DIPENDE dalle celle (difetto n.14)
# =====================================================================
if ($SoloControllo) {
  Titolo "4) ANTEPRIME PRODOTTE (una per cella, con nome proprio)"
  $senzaAnteprima = @()
  $sosta = Join-Path $Cartella "anteprime"
  foreach ($c in $celle) {
    $ant = Join-Path $sosta ($c.K + "_" + $c.Tag + ".ini")
    Write-Host ""
    Write-Host ("    --- " + $c.K + "  " + $c.EA + " / " + $c.Sym + " ---") -ForegroundColor White
    if (-not (Test-Path -LiteralPath $ant)) {
      Write-Host "      (nessuna anteprima prodotta: qualcosa si e' fermato prima)" -ForegroundColor Red
      $senzaAnteprima += $c.K
    } else {
      $chiavi = "^(InpSymbols|InpMaxTotalPositions|InpUseNewsFilter|InpNewsFile|InpNewsCommon|InpNewsShiftMinutes|InpNewsPerCurrency|InpNewsCancelPendings|InpUseCutoff|InpFridayClose|InpSLMode|InpUseTrendFilter|InpAncoraggio|InpZona|InpRiskPercent|InpMagic)="
      foreach ($r in (Select-String -Path $ant -Pattern $chiavi)) { Write-Host ("      " + $r.Line) -ForegroundColor Gray }
      foreach ($r in (Select-String -Path $ant -Pattern "^(Symbol|Period|FromDate|ToDate)=")) { Write-Host ("      " + $r.Line) -ForegroundColor DarkGray }
    }
  }
  Write-Host ""
  Write-Host ("  Le anteprime hanno un nome PROPRIO per cella e stanno in: " + $sosta) -ForegroundColor DarkGray
  Write-Host "  DA CONTROLLARE A OCCHIO, e sono trenta secondi:" -ForegroundColor Yellow
  Write-Host ("   1) FromDate deve dire " + $DaQuando + " e ToDate " + $fineIS + ".") -ForegroundColor Yellow
  Write-Host ("      ATTENZIONE, e' un FALSO ALLARME facile: walkforward_generico.ps1") -ForegroundColor Yellow
  Write-Host ("      (righe 526-527) scrive nell'anteprima SOLO LA FINESTRA IS. La data") -ForegroundColor Yellow
  Write-Host ("      " + $Fino + " NON compare in nessuna delle 14 anteprime, e va bene cosi':") -ForegroundColor Yellow
  Write-Host ("      la OOS la costruisce il driver a runtime (" + $DaQuando + " -> " + $Fino + ", split " + $FrazIS + ").") -ForegroundColor Yellow
  Write-Host "   2) le celle news devono avere InpNewsFile=abtg_news_2021_2025_UTC.csv" -ForegroundColor Yellow
  Write-Host "      e InpNewsCommon=1." -ForegroundColor Yellow
  Write-Host ""
  Write-Host "  E QUELLO CHE **NON** SI CONTROLLA QUI: il canarino del pin InpSymbols." -ForegroundColor Yellow
  Write-Host "  Nell'anteprima .ini dira' USDJPY;EURUSD;GBPUSD SEMPRE, anche il giorno in" -ForegroundColor Yellow
  Write-Host "  cui MT5 lo ignora: l'anteprima la scrive QUESTO script copiando il file" -ForegroundColor Yellow
  Write-Host "  prova, non MT5. Leggerlo qui sarebbe un guardiano decorativo, ed e' il" -ForegroundColor Yellow
  Write-Host "  difetto che ha prodotto il vecchio 0/8: passerebbe una SECONDA volta." -ForegroundColor Yellow
  Write-Host "  Si legge nella colonna InpSymbols dei CSV, a corsa FINITA (par. 6 sotto)." -ForegroundColor Yellow
  Write-Host "  ATTENZIONE: la riga 'Model=' dell'anteprima e' SCRITTA FISSA a 4 dal driver" -ForegroundColor Yellow
  Write-Host ("  (difetto n.31): il modello VERO di questo giro e' " + $Modello + ".") -ForegroundColor Yellow
  Write-Host ""
  if ($falliti.Count -gt 0 -or $senzaAnteprima.Count -gt 0) {
    Write-Host ("=== GIRO A VUOTO FALLITO: " + (($falliti + $senzaAnteprima | Select-Object -Unique) -join " ") + " ===") -ForegroundColor Red
    exit 1
  }
  Write-Host "SoloControllo: MT5 non e' stato aperto, nessun CSV da raccogliere." -ForegroundColor Green
  exit 0
}

# =====================================================================
#  6-bis. LA FOTOGRAFIA D'INIZIO CORSA, RIFATTA
#  Il "branch congelato" e' una raccomandazione: questo la MISURA. Se un
#  .mq5 e' cambiato mentre giravamo, le celle di prima e quelle di dopo
#  hanno usato DUE MOTORI DIVERSI e il confronto fra celle non vale.
# =====================================================================
if ($script:FotoEA -and $script:FotoEA.Count -gt 0) {
  $cambiati = @()
  foreach ($ea in $script:FotoEA.Keys) {
    try {
      $txt = (Invoke-WebRequest -Uri "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/lavoro/mql5/Experts/$ea.mq5" -UseBasicParsing -ErrorAction Stop).Content
      $md5 = [System.BitConverter]::ToString(
               (New-Object System.Security.Cryptography.MD5CryptoServiceProvider).ComputeHash(
                 [System.Text.Encoding]::UTF8.GetBytes($txt))).Replace("-","")
      if ($md5 -ne $script:FotoEA[$ea]) { $cambiati += $ea }
    } catch {}
  }
  if ($cambiati.Count -gt 0) {
    Write-Host ""
    Write-Host ("!!! IL BRANCH NON E' STATO CONGELATO: " + ($cambiati -join ", ") + " e' cambiato durante la corsa.") -ForegroundColor Red
    Write-Host "    Le celle girate prima e dopo il push hanno usato DUE MOTORI DIVERSI:" -ForegroundColor Red
    Write-Host "    il confronto fra celle NON VALE. Va scritto nel referto e si rilancia." -ForegroundColor Red
    $falliti += "BRANCH-NON-CONGELATO"
  } else {
    Write-Host ""
    Write-Host "    branch congelato: i due .mq5 sono gli stessi dell'inizio corsa." -ForegroundColor Green
  }
}

# =====================================================================
#  7. RACCOLTA SUL DESKTOP + ZIP (regola delle righe di lancio, punto 2)
#
#  E' CUMULATIVA, non distruttiva (difetto n.35). Il par. 14 dei criteri
#  dice che il round si puo' spezzare in due sere (-Gamba A, poi -Gamba B):
#  con una raccolta che fa Remove-Item -Recurse sulla cartella, la seconda
#  sera raderebbe al suolo la prima, il referto direbbe "MANCANTI: nessuno"
#  perche' conta solo le celle di QUESTO giro, e Claudio manderebbe in
#  buona fede meta' round credendo di mandarlo intero.
#  Quindi: una cartella di sosta PER GAMBA, si ripulisce solo la propria,
#  e lo zip si fa in fondo su tutto quello che c'e'.
# =====================================================================
Titolo "5) raccolta sul Desktop (cumulativa: una sotto-cartella per gamba)"
$nomeCartella = "R93_FIBOH4"
$dest = Join-Path $desk $nomeCartella
New-Item -ItemType Directory -Force -Path $dest | Out-Null

$gambeGirate = @($celle | ForEach-Object { $_.G } | Select-Object -Unique)
foreach ($g in $gambeGirate) {
  $dg = Join-Path $dest $g
  # LA PULIZIA E IL RIEMPIMENTO DEVONO AVERE LO STESSO PERIMETRO.
  # Qui la pulizia ragiona per GAMBA e il riempimento (sotto) per CELLA:
  # finche' si lancia -Gamba A i due coincidono e non si vede niente. Ma il
  # par. 14 dei criteri consiglia proprio "-Solo A1 -Rifai" per rifare UNA
  # cella: li' $celle ha 1 elemento, questa riga raderebbe al suolo A\ e ci
  # rientrerebbero 2 CSV su 12, lo zip si rifarebbe su quel che resta e il
  # referto scriverebbe MANCANTI: nessuno.
  # E' il difetto n.35 spostato da -Gamba a -Solo. Quindi: si ripulisce
  # SOLO a gamba intera, cioe' quando -Solo non e' stato usato.
  if ($Solo -eq "" -and (Test-Path $dg)) { Remove-Item $dg -Recurse -Force -ErrorAction SilentlyContinue }
  New-Item -ItemType Directory -Force -Path $dg | Out-Null
}
if ($Solo -ne "") {
  Write-Host ("    -Solo attivo: la cartella di raccolta NON viene ripulita, le celle") -ForegroundColor Yellow
  Write-Host ("    rifatte si sovrascrivono una per una e il resto resta dov'e'.") -ForegroundColor Yellow
}

$suff = if ($Modello -eq 4) { "" } else { "_ohlc" }
$attesi = @()
$mancanti = @()
$csvRaccolti = @()
foreach ($c in $celle) {
  $dg = Join-Path $dest $c.G
  foreach ($w in @("IS","OOS")) {
    $nome = $c.EA + "_" + $c.Sym + "_" + $w + $suff + "_" + $c.Tag + ".csv"
    $attesi += ($c.G + "\" + $nome)
    $src = Join-Path $Cartella ("risultati_prove\" + $c.EA + "\" + $nome)
    if (Test-Path -LiteralPath $src) {
      Copy-Item -LiteralPath $src -Destination (Join-Path $dg $nome) -Force
      $csvRaccolti += @{ G = $c.G; K = $c.K; Path = (Join-Path $dg $nome); Nome = $nome }
    } else {
      $mancanti += ($c.G + "\" + $nome)
    }
  }
}
# le serie per-trade, dentro la cartella della loro gamba
foreach ($c in $celle) {
  $rp = Join-Path $Cartella ("risultati_prove\" + $c.EA)
  if (Test-Path $rp) {
    Get-ChildItem -Path $rp -Filter ("pertrade_" + $c.Tag + "_" + $c.Sym + "_*.csv") -ErrorAction SilentlyContinue | ForEach-Object {
      try { Copy-Item -LiteralPath $_.FullName -Destination (Join-Path (Join-Path $dest $c.G) $_.Name) -Force } catch {}
    }
  }
}
Copy-Item -LiteralPath (Join-Path $Cartella "R93_CRITERI.md") -Destination $dest -Force -ErrorAction SilentlyContinue

# =====================================================================
#  7-bis. IL CANARINO DEL PIN, LETTO NELL'ARTEFATTO CHE LO RICEVE
#  (difetto n.34-bis). NON nell'anteprima .ini, che la scrive questo
#  script copiando il file prova e direbbe la cosa giusta SEMPRE, anche
#  il giorno in cui MT5 ignora il pin: era esattamente il difetto che ha
#  prodotto il vecchio 0/8, e passerebbe una seconda volta.
#  Si legge la colonna InpSymbols dei CSV, che la scrive MT5.
#  TRE esiti, non due -- il terzo e' il ';' troncato dal parser dell'.ini,
#  cioe' un basket da UN cross invece di tre, con n a un terzo.
# =====================================================================
$pinEsito = @()
$pinRotto = $false
foreach ($r in @($csvRaccolti | Where-Object { $_.G -eq "A" })) {
  $val = "(colonna assente)"
  try {
    $righeCsvA = @(Import-Csv -LiteralPath $r.Path)
    if ($righeCsvA.Count -gt 0 -and (@($righeCsvA[0].PSObject.Properties.Name) -contains "InpSymbols")) {
      $val = ("" + $righeCsvA[0].InpSymbols).Trim()
    }
  } catch { $val = "(CSV illeggibile)" }

  if ($val -eq "USDJPY;EURUSD;GBPUSD") {
    $pinEsito += ("  OK        " + $r.Nome + "  ->  " + $val + "   (pin ARRIVATO)")
  } elseif ($val -eq "GBPUSD;USDJPY;EURUSD") {
    $pinEsito += ("  ROTTO     " + $r.Nome + "  ->  " + $val + "   (pin IGNORATO: e' il DEFAULT compilato)")
    $pinRotto = $true
  } elseif ($val -eq "USDJPY") {
    $pinEsito += ("  ROTTO     " + $r.Nome + "  ->  " + $val + "   (il ';' TRONCATO dall'.ini: basket da 1 cross invece di 3)")
    $pinRotto = $true
  } else {
    $pinEsito += ("  SOSPETTO  " + $r.Nome + "  ->  " + $val)
    $pinRotto = $true
  }
}

# il referto porta dentro la sua DATA: quella deve essere di ADESSO
# Il referto di una corsa MIRATA (-Solo) non deve sovrascrivere quello della
# corsa PIENA: il primo elenca 2 file attesi, il secondo 12, e chi apre lo zip
# leggerebbe "MANCANTI: nessuno" riferito a due celle credendolo riferito a
# tutte. Nomi diversi, cosi' convivono e si vede subito quale e' quale.
$sufRef = if ($Solo -ne "") { "_rifatte" } else { "" }
$ref = Join-Path $dest ("REFERTO_R93_" + ($gambeGirate -join "") + $sufRef + ".txt")
$rr = @()
$rr += "R93 - FIBO H4 ALL'IMBUTO"
$rr += ("data: " + (Get-Date -Format "yyyy-MM-dd HH:mm") + "   <-- questa data deve essere di ADESSO")
$rr += ("macchina: " + $env:COMPUTERNAME + "   riferimento: " + $Rif + "   (branch CONGELATO per tutta la corsa)")
$rr += ("finestra: " + $DaQuando + " -> " + $Fino + "   modello: " + $Modello + " (1 = OHLC M1, SCREENING)")
$rr += ("gambe girate in QUESTO giro: " + ($gambeGirate -join ", "))
$rr += ("celle in coda: " + $celle.Count + "   passate attese: " + $passateAttese)
$rr += ("calendario news: " + $NewsCsv + " (" + $righeCsv + " righe) in Common\Files e in MQL5\Files")
$rr += ""
$rr += ("FILE ATTESI DA QUESTO GIRO (" + $attesi.Count + "):")
foreach ($a in $attesi) { $rr += ("  " + $a) }
$rr += ""
if ($mancanti.Count -gt 0) {
  $rr += ("MANCANTI (" + $mancanti.Count + "):")
  foreach ($m in $mancanti) { $rr += ("  " + $m) }
} else { $rr += "MANCANTI (di questo giro): nessuno." }
if ($falliti.Count -gt 0) { $rr += ("CELLE USCITE IN ERRORE: " + ($falliti -join " ")) }
$rr += ""
$rr += "ATTENZIONE, LA RACCOLTA E' CUMULATIVA: 'MANCANTI: nessuno' vale SOLO per le"
$rr += "gambe girate stasera. Se il round e' stato spezzato, la cartella contiene"
$rr += "anche la gamba dell'altra sera e il suo referto sta accanto a questo."
$rr += "Prima di mandare lo zip: dentro devono esserci le sottocartelle A E B."
$rr += ""
$rr += "CANARINO DEL PIN InpSymbols (letto nella colonna dei CSV, che la scrive MT5,"
$rr += "NON nell'anteprima .ini, che la scriviamo noi):"
if ($pinEsito.Count -eq 0) { $rr += "  (nessun CSV di gamba A in questo giro)" }
foreach ($e in $pinEsito) { $rr += $e }
if ($pinRotto) {
  $rr += "  >>> IL PIN E' ROTTO: I NUMERI DELLA GAMBA A NON SI LEGGONO."
  $rr += "      E' il difetto che ha prodotto il vecchio 0/8 (otto copie dello stesso"
  $rr += "      basket). Si ripiega su un simbolo per passata e si RIFA' l'aritmetica"
  $rr += "      del campione (criteri par. 4.2). Non si interpreta."
}
$rr += ""
$rr += "COSA SI LEGGE PER PRIMO (criteri par. 5), e non e' il profitto."
$rr += "TUTTO DAI DATI: le 68 passate girano in OTTIMIZZAZIONE e le Print degli"
$rr += "agent non le vede nessuno (checklist 34). Queste sono COLONNE del CSV:"
$rr += "  1. il canarino del pin qui sopra."
$rr += "  2. il magic gemello di A0: le due righe IDENTICHE al centesimo."
$rr += "  3. gamba A, celle news: colonne 'News Eventi' / 'News Bloccate' /"
$rr += "     'News Interrogazioni'."
$rr += "       News Eventi = 0        -> il file NON e' arrivato: cella da BUTTARE."
$rr += "       News Bloccate = 0      -> il filtro non ha filtrato: cella da BUTTARE."
$rr += "       Bloccate/Interrogazioni fra 8% e 12% -> il filtro ha girato: si legge."
$rr += "       colonna = -1           -> passata SENZA canarino (EA vecchio)."
$rr += "  4. gamba B: colonna 'Setup Piazzati' (SOGLIA S1-B)."
$rr += "       0 -> la passata NON dice che la strategia perde: dice che non ha mai"
$rr += "            operato. Le colonne 'Scartati Laterale/Distanza/Ampiezza' dicono"
$rr += "            QUALE cancello ha mangiato tutto."
$rr += ""
$rr += "E QUELLO CHE NON SI POTRA' DIRE (criteri par. 10):"
$rr += "  - niente sul merito a TICK REALI (a BCM i tick partono dal 2024.07.05)."
$rr += "  - niente sul 2026 (il calendario news finisce il 2025.12.19)."
$rr += "  - niente sulla fedelta' al corso finche' mancano le richieste R2 e R3."
$rr += "  - niente promozioni, in nessun caso."
$rr | Set-Content -LiteralPath $ref -Encoding ASCII

Write-Host ""
Write-Host ("    file attesi da questo giro : " + $attesi.Count) -ForegroundColor White
Write-Host ("    mancanti                   : " + $mancanti.Count) -ForegroundColor $(if ($mancanti.Count -gt 0) { "Red" } else { "Green" })
foreach ($m in $mancanti) { Write-Host ("      manca: " + $m) -ForegroundColor Red }
Write-Host ""
Write-Host "    CANARINO DEL PIN InpSymbols (letto nei CSV, non nell'anteprima):" -ForegroundColor White
if ($pinEsito.Count -eq 0) { Write-Host "      (nessun CSV di gamba A in questo giro)" -ForegroundColor DarkGray }
foreach ($e in $pinEsito) { Write-Host ("    " + $e) -ForegroundColor $(if ($e -like "*  OK  *") { "Green" } else { "Red" }) }
Write-Host ""
Write-Host ("    cartella (CUMULATIVA): " + $dest) -ForegroundColor White
# I due conteggi vanno TENUTI SEPARATI: il blocco 5 dei criteri dice "12 CSV in
# A, 16 in B", e quel numero e' dei CSV DI RISULTATO. Contare insieme i
# pertrade_* dava un totale che non poteva tornare con nessun atteso, cioe' un
# numero preciso e inutilizzabile.
foreach ($g in @("A","B")) {
  $dg = Join-Path $dest $g
  $nRis = 0; $nPer = 0
  if (Test-Path $dg) {
    $tutti = @(Get-ChildItem -Path $dg -Filter "*.csv" -ErrorAction SilentlyContinue)
    $nPer = @($tutti | Where-Object { $_.Name -like "pertrade_*" }).Count
    $nRis = $tutti.Count - $nPer
  }
  $atteso = if ($g -eq "A") { 12 } else { 16 }
  $col = if ($nRis -eq $atteso) { "Green" } elseif ($nRis -gt 0) { "Yellow" } else { "DarkGray" }
  Write-Host ("      gamba " + $g + ": " + $nRis + " CSV di risultato (attesi " + $atteso + " a round intero) + " + $nPer + " per-trade") -ForegroundColor $col
}

$zip = Join-Path $desk ($nomeCartella + ".zip")
if (Test-Path $zip) { Remove-Item $zip -Force -ErrorAction SilentlyContinue }
try {
  Compress-Archive -Path (Join-Path $dest "*") -DestinationPath $zip -Force
  Write-Host ""
  Write-Host ("    ZIP PRONTO DA MANDARE:  " + $zip) -ForegroundColor Cyan
  Write-Host "    (contiene TUTTO quello che sta nella cartella, comprese le gambe" -ForegroundColor DarkGray
  Write-Host "     girate in serate precedenti: la raccolta e' cumulativa)" -ForegroundColor DarkGray
} catch {
  Write-Host ""
  Write-Host ("!!! lo zip NON e' stato creato: " + $_.Exception.Message) -ForegroundColor Red
  Write-Host ("    i file comunque sono qui: " + $dest) -ForegroundColor Yellow
}

Write-Host ""
if ($pinRotto) {
  Write-Host "=== R93: IL CANARINO DEL PIN E' ROTTO. I numeri della gamba A NON si leggono. ===" -ForegroundColor Red
  Write-Host "    Manda lo zip lo stesso: il canarino rotto E' GIA' UNA RISPOSTA." -ForegroundColor Yellow
  exit 1
}
if ($falliti.Count -gt 0 -or $mancanti.Count -gt 0) {
  Write-Host ("=== R93 FINITO PARZIALE: " + $falliti.Count + " celle in errore, " + $mancanti.Count + " file mancanti ===") -ForegroundColor Red
  Write-Host "    Manda lo zip lo stesso: un risultato parziale e' gia' una risposta," -ForegroundColor Yellow
  Write-Host "    ma va detto QUALE pezzo manca prima di leggere gli altri." -ForegroundColor Yellow
  exit 1
}
Write-Host "=== R93 FINITO. I criteri si leggono PRIMA dei numeri, e vanno FIRMATI. ===" -ForegroundColor Green
exit 0
