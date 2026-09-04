# =====================================================================
#  MARCATORE_RIGA_SONDARELATIVO_ESTESA_v1
#  RIGA_SONDARELATIVO_ESTESA.ps1 -- SONDA DI CONVERGENZA "RELATIVO",
#  ESTENSIONE DELLA GRIGLIA OLTRE IL BORDO MISURATO IL 04/09/2026.
#
#  QUESTA RIGA NON SOSTITUISCE RIGA_SONDARELATIVO.ps1 (marcatore _v5).
#  Quella resta com'e', coi suoi quattro prova e col suo gemellaggio a
#  4 gia' verificato dal verificatore di stringhe il 03/09. Si e'
#  scelta la strada dei FILE NUOVI DEDICATI proprio per non invalidare
#  quella verifica: il diff fra le due righe e' piccolo, elencato qui
#  sotto voce per voce, e ogni voce e' verificabile con un grep.
#
#  ---------------------------------------------------------------
#  PERCHE' ESISTE -- decisione di Claudio del 04/09/2026 (D4)
#  ---------------------------------------------------------------
#  La corsa del 04/09 ha dato VIVO su entrambi i lati su D30_M5 e
#  NAS_M5, ma L'ALTOPIANO VIVO SI APPOGGIA AL BORDO DELLA GRIGLIA SU
#  TUTTI E DUE GLI ASSI (N=40 e sigma=1,65 sono i MASSIMI misurati):
#     D30_M5: blocchi 2x2 vivi in N {35,40} x sigma {1.20 .. 1.65}
#     NAS_M5: blocchi 2x2 vivi in N {35,40} x sigma {1.35 .. 1.65}
#  Quindi il "centro dell'altopiano" NON E' DETERMINABILE: puo' essere
#  il centro vero, o il FIANCO BASSO di un altopiano piu' grande che
#  continua fuori dalla griglia. La cella per il round a tick reali non
#  si congela finche' non si sa quale delle due letture e' vera.
#  Riferimento: report\PROPOSTA_RELATIVO_TICK_REALI_2026-09-04.md, 3.4.
#
#  ---------------------------------------------------------------
#  IL DIFF DICHIARATO rispetto a RIGA_SONDARELATIVO.ps1 (_v5)
#  ---------------------------------------------------------------
#   1. DUE prova ammessi invece di quattro, ed entrambi M5:
#        -Prova D30_M5_EST   D30EUR M5   prove\RELATIVO_D30_M5_ESTESA.txt
#        -Prova NAS_M5_EST   NASUSD M5   prove\RELATIVO_NAS_M5_ESTESA.txt
#      I due M15 hanno dato SOSPESO su entrambi i lati e sono CHIUSI:
#      non entrano nel gemellaggio di questa riga, e il gemellaggio
#      qui e' A DUE (identici salvo @SIMBOLO: stesso TF, stessa
#      finestra). Il gemellaggio A QUATTRO dei prova originali resta
#      valido perche' quei quattro file NON SONO STATI TOCCATI.
#   2. GRIGLIA 10 x 9 = 90 celle (erano 7 x 7 = 49):
#        InpFinestraN            10 -> 55 passo 5      (+45, +50, +55)
#        InpSogliaIngressoSigma  0,75 -> 1,95 passo 0,15  (+1,80, +1,95)
#      Si rigirano ANCHE le 49 vecchie, ed e' una scelta: vedi il
#      COLLAUDO DI RIPRODUZIONE al punto 3 e la mappa unica al punto 4.
#   3. COLLAUDO DI RIPRODUZIONE, NUOVO E BLOCCANTE. La cella di
#      riferimento N=20 sigma=1,05 deve tornare IDENTICA ai referti del
#      04/09 (conteggi interi esatti, mediane a 0,01). Se non torna,
#      non e' l'estensione a essere sbagliata: sono i numeri del 04/09
#      a non essere riproducibili, e va saputo PRIMA di scegliere una
#      cella. Tabella $RIPRO, gate in AnalizzaCsv.
#   4. UNA MAPPA SOLA (10x9) invece di due mappe da cucire a mano. La
#      regola dell'altopiano guarda blocchi 2x2 di celle CONTIGUE:
#      cucire due mappe misurate in corse diverse e' esattamente il
#      punto in cui si sbaglia.
#   5. WORKDIR SEPARATA (%USERPROFILE%\abtg_sondarelativo_est),
#      sentinella, cartella sul Desktop, referto e zip con la marca
#      _EST: nessun file di questa corsa puo' essere scambiato per uno
#      della corsa del 04/09, in nessun punto della catena.
#   6. $Righe49 rinominata $RigheGriglia: su 90 celle quel nome era
#      MISLEADING. Rinomina meccanica, 4 occorrenze, verificata a grep.
#  NON E' CAMBIATO NIENT'ALTRO: gate del sorgente, #define delle
#  soglie, collaudi per riga, regola dell'altopiano, tetto barre,
#  scelta del terminale, compilazione, sentinella, raccolta.
#
#  ---------------------------------------------------------------
#  COSA NON SI TOCCA, ED E' IL PUNTO
#  ---------------------------------------------------------------
#  - mql5\Experts\ABTG_SondaRelativo.mq5 v1.03: CONTATORE PURO,
#    nessun ordine, nessun magic, nessuna sedia. Invariato.
#  - i quattro prova originali prove\RELATIVO_{D30,NAS}_{M5,M15}.txt.
#  - RIGA_SONDARELATIVO.ps1 (_v5) e la sua pagina.
#  - I CANCELLI: C1, C2, C3, C5, C6, C7, C8 stanno nei #define del
#    sorgente e si LEGGONO da li' al pin, come sempre. Estendere la
#    griglia NON e' spostare un cancello.
#  - LA REGOLA DI LETTURA: ALTOPIANO, MAI IL PICCO. Su una griglia piu'
#    grande la tentazione del picco CRESCE: la regola resta scritta
#    prima dei numeri, qui e nei due prova.
#
#  ---------------------------------------------------------------
#  IL RISCHIO DICHIARATO: IL CONTEGGIO DELLE CELLE
#  ---------------------------------------------------------------
#  L'asse sigma va per multipli di 0,15 in virgola mobile: 0,75 + 8 x
#  0,15 puo' uscire 1,9500000000000002 e produrre 8 valori invece di 9
#  (72 celle invece di 90). NON si corregge in silenzio: le righe del
#  CSV si CONTANO e si confrontano con 90. Se sono 72 o 81 e' un
#  PROBLEMA scritto nel referto, non una griglia "quasi giusta".
#
#  QUANTO CI METTE [MISURATO, non stimato]: le 49 passate M5 del 04/09
#  sono state fatte in ~30 secondi di tester (referti alla mano: corsa
#  avviata 14:19:28, CSV scritto 14:19:58). 90 passate sono ~55-60 s
#  [CALCOLO], piu' due avvii del terminale e una compilazione: 2-6
#  minuti in tutto. La riga originale stimava 15-45 minuti a prova: era
#  una STIMA prudenziale, e la misura l'ha smentita. Se questa corsa
#  dovesse metterci molto di piu', non e' un errore -- ma va scritto.
#
#  >>> EA MAI COMPILATO IN QUESTO AMBIENTE: si compila QUI
#      (metaeditor64, invocazione diretta, log letto qualunque sia la
#      codifica). Se fallisce, QUELLO e' il risultato del passo.
#  >>> CONTATORE PURO, PROVATO A MACCHINA: grep delle chiamate di
#      trading fuori dai commenti, attese ZERO.
#  >>> SENTINELLA + FOTO (classe 116), EXIT CODE A TRE STATI (classe
#      108), CSV DATATO PRIMA DI LEGGERLO, TIMBRO data: = ORA DI AVVIO
#      (classe 110): tutto identico alla riga _v5.
#
#  LA RIGA CHE SI INCOLLA sta in
#  righe\RIGA_SONDARELATIVO_ESTESA_DA_MANDARE.md
# =====================================================================
[CmdletBinding()]
param(
  # -Pin NON ha default: un default silenzioso ("lavoro") farebbe girare
  #  la punta del branch spacciandola per un commit congelato.
  [string]$Pin              = "",
  # -Prova: UNO dei DUE nomi ammessi (i due M15 sono chiusi). Obbligatorio.
  [ValidateSet("D30_M5_EST","NAS_M5_EST")]
  [string]$Prova            = "",
  [switch]$SoloControllo,
  # -AccettoTettoBarre: l'interruttore ESPLICITO per i prova che chiedono
  #  piu' anni di quanti il tester ne dia su quel TF (i due M5). Senza,
  #  la riga si ferma e lo dice. Con, la scelta finisce nel referto.
  [switch]$AccettoTettoBarre,
  # -Terminale: si usa SOLO se la scelta automatica si ferma perche' non
  #  sa quale installazione MT5 e' quella di backtest (classe 115).
  [string]$Terminale        = "",
  [string]$DaQuando         = "2024.09.26",  # pavimento MISURATO dei dati BCM sugli indici (REFERTO_SONDA_STORICO_17-08)
  [string]$Fino             = "2026.06.30",  # dichiarata nei prova (@FINOA) e gattata
  [double]$FrazioneIS       = 1.0,           # finestra intera; la gamba OOS del generico e' degenere e si ignora
  [int]$Deposito            = 100000         # INERTE: la sonda non apre ordini. Sta qui perche' il generico lo vuole
)
$ErrorActionPreference = "Stop"
[Threading.Thread]::CurrentThread.CurrentCulture   = [Globalization.CultureInfo]::InvariantCulture
[Threading.Thread]::CurrentThread.CurrentUICulture = [Globalization.CultureInfo]::InvariantCulture
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$INV = [Globalization.CultureInfo]::InvariantCulture

$EA      = "ABTG_SondaRelativo"
$METRO   = "U30USD"
$Avvio   = Get-Date
$Stamp   = $Avvio.ToString("yyyyMMdd_HHmm", $INV)
# IL DESKTOP SI CERCA, NON SI ASSUME (classe 116-bis): con OneDrive il
# Desktop vero non e' %USERPROFILE%\Desktop. La riga di chat usa le
# STESSE tre righe, nello stesso ordine.
function TrovaDesktop(){
  foreach($p in @([Environment]::GetFolderPath("Desktop"),
                  (Join-Path $env:USERPROFILE "Desktop"),
                  (Join-Path $env:USERPROFILE "OneDrive\Desktop"))){
    if($p -and (Test-Path -LiteralPath $p)){ return $p }
  }
  return $env:USERPROFILE
}
$Dsk     = TrovaDesktop
$Work    = Join-Path $env:USERPROFILE "abtg_sondarelativo_est"
$Prove   = Join-Path $Work "prove"
$RawPin  = "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$Pin"
$Sentinella = Join-Path $Work "SONDARELATIVO_EST_IN_CORSO.txt"

# --- IDENTITA' ATTESA DEL SORGENTE (gate, non decorazione)
$VERSIONE_ATTESA         = "1.03"
$AUTOTEST_BLOCCHI_ATTESI = 25
$NSTATS_ATTESI           = 97      # 97 valori + Pass, Simbolo, Periodo = 100 colonne
$INPUT_ATTESI            = 22
$NCelleAttese            = 90      # GRIGLIA ESTESA: 10 valori di N x 9 di sigma. RICONTATE dai pin ||Y al pin.
$NCelleVecchie           = 49      # la griglia del 04/09, CONTENUTA in questa: 41 celle sono nuove.

# --- I NUMERI CHE LA PAGINA PROMETTE. Si CONFRONTANO con i #define del
#     sorgente scaricato al pin: se divergono e' un PROBLEMA (pagina e
#     codice non dicono la stessa cosa) e la lettura NON si fa.
$PAGINA_C1_TOT_GG   = 2.00    # C1: somma dei due lati >= 2,00 eseguibili/giorno
$PAGINA_SPREAD_D30  = 2.80    # mediana oraria PEGGIORE 14-21 server, D30EUR (SPREAD_FLOTTA 03/09)
$PAGINA_SPREAD_NAS  = 1.80    # idem NASUSD
$PAGINA_C3_MULT     = 3.0     # C3: MFE mediana >= 3x spread  (8,40 DAX / 5,40 NAS)
$PAGINA_C3_LARGO    = 6.0     # C3: > 6x = passa LARGO
$PAGINA_C5_RR       = 0.70    # C5: RR da mediane >= 0,70
$PAGINA_C6_KO       = 40.0    # C6: non convergute > 40% = SCARTO
$PAGINA_C6_SOSP     = 25.0    # C6: 25-40% = SOSPESO
$PAGINA_C8_TENUTA   = 12.0    # C8: tenuta mediana < 12 barre = SOSPESO
$PAGINA_C8_SOTTO60  = 25.0    # C8: >= 25% sotto 60 s = SCARTO PROP
$PAGINA_C2_SPAIATI  = 10.0    # C2: > 10% giorni spaiati = rifare filtrando
$PAGINA_C7_RISCHIO  = 0.65    # C7: rischio per trade
$PAGINA_C7_CAP      = 3.25    # C7: cap rischio aperto (18/08)

# --- IL TETTO DEL TESTER, in giorni di calendario per TF (CLAUDE.md
#     25/08: M5 ~1,3 anni, M15 ~4 anni). 1,3 x 365 = 475; 4 x 365 = 1461.
$TETTO_GIORNI = @{ "M5" = 475; "M15" = 1461 }

# --- LE DUE CORSE AMMESSE: etichetta -> simbolo, TF, file prova, gemello.
#     I due M15 NON ci sono: hanno dato SOSPESO su entrambi i lati il
#     04/09 e sono chiusi. Il campo Gemello serve alla firma del tetto
#     (classe 36) e sostituisce il vecchio calcolo "NAS_" + $Periodo,
#     che con le etichette _EST avrebbe cercato un CSV inesistente.
$CORSE = [ordered]@{
  "D30_M5_EST" = @{ Simbolo="D30EUR"; Periodo="M5"; File="RELATIVO_D30_M5_ESTESA.txt"; SpreadPagina=$PAGINA_SPREAD_D30; Gemello="NAS_M5_EST"; GemelloSim="NASUSD" }
  "NAS_M5_EST" = @{ Simbolo="NASUSD"; Periodo="M5"; File="RELATIVO_NAS_M5_ESTESA.txt"; SpreadPagina=$PAGINA_SPREAD_NAS; Gemello="D30_M5_EST"; GemelloSim="D30EUR" }
}

# --- I FISSI attesi nei prova (primo campo prima di ||), nome per nome:
#     TUTTI gli input della sonda tranne i due assi. Un nome sbagliato
#     qui sarebbe l'errore n.3 della checklist (MT5 ignora in silenzio).
$FissiAttesi = [ordered]@{
  "InpSimboloMetro"="U30USD"; "InpModoSpread"="0"; "InpModoZScore"="0";
  "InpSogliaUscitaSigma"="0.05";
  "InpOraInizioServer"="14"; "InpMinInizioServer"="30"; "InpOraFineServer"="22"; "InpMinFineServer"="0";
  "InpBarreMaxTenuta"="120"; "InpBarreOrizzonte"="24"; "InpLato"="0"; "InpPuntiPerIndice"="100.0";
  "InpAtrPeriod"="14"; "InpAtrModoRma"="false";
  "InpWarmupBarre"="300"; "InpConfrontaMT5"="true"; "InpScriviCsv"="true"; "InpVerbose"="true";
  "InpAutoTest"="true"; "InpTag"="RELATIVO_SONDA" }
$AssiAttesi = [ordered]@{ "InpFinestraN"="20||10||5||55||Y"; "InpSogliaIngressoSigma"="1.05||0.75||0.15||1.95||Y" }
# la cella di RIFERIMENTO della domanda-sonda (GIACIMENTO sez. 8): i
# default del motore. Si stampa a parte, NON e' una promozione.
$RIF_N     = 20
$RIF_SIGMA = 1.05

# --- IL COLLAUDO DI RIPRODUZIONE, ED E' LA RAGIONE PER CUI SI RIGIRANO
#     ANCHE LE 49 CELLE VECCHIE.
#     La cella N=20 sigma=1,05 esiste in ENTRAMBE le griglie: qui ci sono
#     i suoi numeri MISURATI il 04/09/2026, ricopiati dai due referti
#     (REFERTO_D30_M5_2026-09-04_1419_v103_VIVO.txt e
#      REFERTO_NAS_M5_2026-09-04_1422_v103_VIVO.txt, sezione "LA CELLA DI
#      RIFERIMENTO"). Estendere la griglia NON puo' cambiare il risultato
#     di una passata che ha gli stessi identici input: ogni passata e'
#     indipendente. Se questi numeri NON tornano, la spiegazione non e'
#     l'estensione -- e' che i numeri del 04/09 non sono riproducibili
#     (storico cambiato sul PC, cache del tester, versione diversa), e
#     allora la scelta della cella per il round a tick non si puo'
#     appoggiare su quel referto. E' un PROBLEMA, non un rilievo: e' la
#     clausola severa di casa applicata prima di vedere i numeri nuovi.
#     I conteggi si confrontano ESATTI, le mediane e le quote a 0,01.
$RIPRO = @{
  "D30EUR" = @{ Giorni=441; BarreVal=38760; GrezL=2246; GrezS=2374; EseL=1417; EseS=1454;
                MfeL=18.50; MfeS=17.70; MaeL=16.00; MaeS=18.50; NonConvT=9.33; TenMedT=9.00 }
  "NASUSD" = @{ Giorni=450; BarreVal=38715; GrezL=2419; GrezS=2418; EseL=1523; EseS=1534;
                MfeL=27.50; MfeS=26.80; MaeL=31.20; MaeS=29.35; NonConvT=9.22; TenMedT=8.00 }
}

# --- tutto cio' che la raccolta usa nasce QUI, prima del try: la
#     raccolta gira SEMPRE, anche nella corsa fermata da un gate.
$Problemi   = New-Object System.Collections.ArrayList
$Rilievi    = New-Object System.Collections.ArrayList
$Fatale     = ""
$Modo       = "CORSA"
if($SoloControllo){ $Modo = "CONTROLLO" }
$TermScelto = "n/d"
$TermCrit   = "NON RAGGIUNTA"
$DataFolder = ""
$Compilato  = "NON TENTATA"
$ResultTxt  = "NON RAGGIUNTA"
$RcMeTxt    = "NON RAGGIUNTO"
$CacheTxt   = "NON RAGGIUNTA"
$VersioneTxt= "NON LETTA"
$AutoSrcTxt = "NON CONTATI"
$NStatsTxt  = "NON LETTO"
$InputTxt   = "NON CONTATI"
$GrepTxt    = "NON ESEGUITO"
$IncludeTxt = "NON CONTATI"
$CelleTxt   = "NON CONTATE"
$GemelliTxt = "NON VERIFICATA"
$TettoTxt   = "NON VALUTATO"
$DefineTxt  = "NON LETTI"
$RcGenTxt   = "NON RAGGIUNTO"
$AnteprimaTxt = "n/a (solo in CONTROLLO)"
$CsvOraTxt  = "n/d"
$CsvRighe   = $null
$SoglieSrc  = $null      # i #define letti dal sorgente
$Cella      = $null      # la riga della cella di riferimento
$RigheGriglia    = $null      # tutte le righe lette
$Mappa      = @{}        # "L"/"S" -> testo della mappa 7x7
$VerdettoL  = "n/d"
$VerdettoS  = "n/d"
$FotoPrima  = @()
$FotoDopo   = @()
$SentTrovata = ""
$tCorsa     = $Avvio
$Simbolo    = "n/d"
$Periodo    = "n/d"
$FileProva  = "n/d"
$SpreadAtteso = 0.0
$SogliaC3Attesa = 0.0
$Results    = Join-Path $Work ("risultati_prove\" + $EA)

function Ora(){ return (Get-Date).ToString("HH:mm:ss", $INV) }
function Dico([string]$t,[string]$c="Gray"){ Write-Host ("[" + (Ora) + "] " + $t) -ForegroundColor $c }
function Titolo([string]$t){ Write-Host ""; Write-Host ("=== " + $t + " ===") -ForegroundColor Cyan }

function Scarica([string]$url,[string]$dest){
  Remove-Item -LiteralPath $dest -Force -ErrorAction SilentlyContinue
  try{ Invoke-WebRequest -Uri $url -OutFile $dest -UseBasicParsing -ErrorAction Stop }
  catch{ throw ("scarico fallito (" + $_.Exception.Message + "): " + $url + " -- se e' un 404 su un pin appena creato, la cache di GitHub raw tiene ~5 minuti: aspetta e rilancia LA STESSA riga.") }
  if(-not (Test-Path -LiteralPath $dest)){ throw ("scarico fallito: " + $url) }
}
function RigheVive([string]$p){
  return @(Get-Content -LiteralPath $p | Where-Object { $_ -notmatch '^\s*#' -and $_ -notmatch '^\s*$' })
}
function Num([string]$s){ return [double]::Parse($s.Trim(), $INV) }
function FmtN($v){ if($null -eq $v){ return "n/d" }; return ([long]$v).ToString($INV) }
function Fmt2($v){ if($null -eq $v){ return "n/d" }; return ([double]$v).ToString("0.00",$INV) }
function Fmt3($v){ if($null -eq $v){ return "n/d" }; return ([double]$v).ToString("0.000",$INV) }
function Foto([string]$p){
  if(Test-Path -LiteralPath $p){
    $i = Get-Item -LiteralPath $p
    return ("presente, " + $i.Length + " byte, " + $i.LastWriteTime.ToString("yyyy-MM-dd HH:mm:ss",$INV))
  }
  return "assente"
}
# legge un file di testo QUALUNQUE sia la codifica (MetaEditor scrive il
# log in UTF-16): BOM FF FE -> Unicode; molti byte 0 -> Unicode; altrimenti ANSI.
function LeggiTesto([string]$p){
  if(-not (Test-Path -LiteralPath $p)){ return @() }
  $b = [IO.File]::ReadAllBytes($p)
  if($b.Length -eq 0){ return @() }
  $unicode = $false
  if($b.Length -ge 2 -and $b[0] -eq 0xFF -and $b[1] -eq 0xFE){ $unicode = $true }
  else{
    $zeri = 0; $n = [math]::Min($b.Length, 400)
    for($i=0; $i -lt $n; $i++){ if($b[$i] -eq 0){ $zeri++ } }
    if($zeri -gt ($n/4)){ $unicode = $true }
  }
  $txt = ""
  if($unicode){ $txt = [Text.Encoding]::Unicode.GetString($b) } else { $txt = [Text.Encoding]::Default.GetString($b) }
  return @($txt -split "`r?`n")
}

# legge un file prova in una mappa @{nome=valore} + lista assi Y (una
# riga DOPPIA e' FATALE: in [TesterInputs] un parametro doppio fa fare a
# MT5 ZERO passate).
function LeggiProva([string]$percorso,[string]$nome){
  $mappa = [ordered]@{}
  $assi  = New-Object System.Collections.ArrayList
  foreach($r in (RigheVive $percorso)){
    if($r -match '^@'){
      $parti = ($r -split '\s+',2)
      if($parti.Count -lt 2){ throw ($nome + ": la direttiva '" + $r + "' non ha un valore.") }
      if($mappa.Contains($parti[0])){ throw ($nome + ": direttiva doppia '" + $parti[0] + "'.") }
      $mappa[$parti[0]] = $parti[1].Trim()
      continue
    }
    $i = $r.IndexOf("=")
    if($i -lt 0){ continue }
    $n = $r.Substring(0,$i).Trim()
    $v = $r.Substring($i+1).Trim()
    if($mappa.Contains($n)){ throw ($nome + ": DUE righe per '" + $n + "'. In [TesterInputs] un parametro doppio fa fare a MT5 ZERO passate.") }
    $mappa[$n] = $v
    if($v -match '\|\|Y\s*$'){ [void]$assi.Add($n) }
  }
  return @{ Mappa=$mappa; Assi=$assi }
}
# conta le celle di UN asse ESATTAMENTE come le conta il generico
# (Floor(|stop-start|/|step| + 1e-9) + 1). Niente enum: la sonda non
# ha input enum sweepati.
function CelleAsse([string]$valore,[string]$nome){
  $campi = $valore -split '\|\|'
  if($campi.Count -lt 5){ throw ($nome + ": pin '" + $valore + "' non ha 5 campi: non e' un asse.") }
  $conv = New-Object System.Collections.ArrayList
  foreach($ix in @(1,2,3)){
    $t = $campi[$ix].Trim()
    if($t -notmatch '^-?\d+(\.\d+)?$'){ throw ($nome + ": campo '" + $campi[$ix] + "' non numerico nell'asse.") }
    [void]$conv.Add([double]::Parse($t,$INV))
  }
  $start = $conv[0]; $step = $conv[1]; $stop = $conv[2]
  if($step -eq 0 -or $start -eq $stop){ throw ($nome + ": asse DEGENERE (start==stop o step==0).") }
  return ([int]([math]::Floor([math]::Abs($stop-$start)/[math]::Abs($step) + 1e-9)) + 1)
}
# gli input dell'EA, letti dal sorgente (le righe "input group" non
# hanno l'uguale e non entrano).
function LeggiInputEA([string]$src){
  $nomi = New-Object System.Collections.ArrayList
  foreach($m in [regex]::Matches($src,'(?m)^\s*input\s+[A-Za-z_]\w*\s+([A-Za-z_]\w*)\s*=')){ [void]$nomi.Add($m.Groups[1].Value) }
  return $nomi
}
# i #define numerici del sorgente: vince la PRIMA definizione.
function LeggiDefine([string]$src){
  $d = @{}
  foreach($m in [regex]::Matches($src,'(?m)^\s*#define\s+(\w+)\s+([^\r\n/]+)')){
    $n = $m.Groups[1].Value; $v = $m.Groups[2].Value.Trim()
    if(-not $d.ContainsKey($n)){ $d[$n] = $v }
  }
  return $d
}
function DefNum($d,[string]$nome){
  if(-not $d.ContainsKey($nome)){ throw ("il sorgente non ha il #define " + $nome + ": la sonda al pin non e' quella attesa.") }
  $v = ("" + $d[$nome]).Trim()
  if($v -notmatch '^-?\d+(\.\d+)?$'){ throw ("#define " + $nome + " = '" + $v + "' non e' un numero.") }
  return [double]::Parse($v,$INV)
}

# IL GATE DI UN PROVA, in una funzione: direttive nude, parametri che
# ESISTONO nell'EA (nei due versi), 2 assi esatti, celle contate, fissi
# nome per nome, nessuna riga estranea. Torna @{ Lettura; Celle }.
function GateProva([string]$percorso,[string]$pf,[string]$simAtteso,[string]$tfAtteso,$inputEA){
  $lettura = LeggiProva $percorso $pf
  $h    = $lettura.Mappa
  $assi = $lettura.Assi
  if($h["@SIMBOLO"]  -ne $simAtteso){ throw ($pf + ": @SIMBOLO e' '" + $h["@SIMBOLO"] + "', atteso " + $simAtteso) }
  if($h["@PERIODO"]  -ne $tfAtteso){  throw ($pf + ": @PERIODO e' '" + $h["@PERIODO"] + "', atteso " + $tfAtteso) }
  if($h["@DAQUANDO"] -ne $DaQuando){  throw ($pf + ": @DAQUANDO e' '" + $h["@DAQUANDO"] + "', atteso " + $DaQuando + " (pavimento MISURATO dei dati BCM sugli indici)") }
  if($h["@FINOA"]    -ne $Fino){      throw ($pf + ": @FINOA e' '" + $h["@FINOA"] + "', atteso " + $Fino + " (la finestra si dichiara nel prova, non si eredita dal default del generico)") }
  # OGNI parametro del prova DEVE esistere nell'EA (errore n.3: MT5 ignora
  # in silenzio) e OGNI input dell'EA DEVE essere pinnato nel prova.
  $paramProva = @($h.Keys | Where-Object { $_ -notmatch '^@' })
  foreach($k in $paramProva){ if(-not ($inputEA -contains $k)){ throw ($pf + ": il parametro '" + $k + "' NON e' un input di " + $EA + " (classe 112 / errore n.3: MT5 lo ignorerebbe in silenzio).") } }
  foreach($k in @($inputEA)){ if(-not $h.Contains($k)){ throw ($pf + ": l'input '" + $k + "' dell'EA NON e' pinnato nel prova: MT5 userebbe lo stato che si ricorda dall'ultima griglia.") } }
  # DUE assi Y esatti.
  if(@($assi).Count -ne 2){ throw ($pf + ": deve avere ESATTAMENTE 2 assi Y (" + (@($AssiAttesi.Keys) -join ", ") + "). Trovati: " + @($assi).Count + " {" + (@($assi) -join ", ") + "}.") }
  $nc = 1
  foreach($k in @($AssiAttesi.Keys)){
    if(-not ($assi -contains $k)){ throw ($pf + ": manca l'asse Y " + $k + ".") }
    if($h[$k] -ne $AssiAttesi[$k]){ throw ($pf + ": " + $k + " e' '" + $h[$k] + "', atteso '" + $AssiAttesi[$k] + "' (la griglia e' quella CONGELATA nella bozza: non si ritocca).") }
    $nc = $nc * (CelleAsse $h[$k] $k)
  }
  if($nc -ne $NCelleAttese){ throw ($pf + ": i pin ||Y danno " + $nc + " celle, attese " + $NCelleAttese + ".") }
  # I FISSI, nome per nome, col valore.
  foreach($k in @($FissiAttesi.Keys)){
    if(-not $h.Contains($k)){ throw ($pf + ": manca la riga '" + $k + "'.") }
    $v = ($h[$k] -split '\|\|')[0]
    if($v -ne $FissiAttesi[$k]){ throw ($pf + ": " + $k + " e' '" + $v + "', atteso '" + $FissiAttesi[$k] + "'.") }
    if($h[$k] -match '\|\|Y\s*$'){ throw ($pf + ": " + $k + " NON va sweepato.") }
  }
  # niente righe estranee: 4 direttive + 20 fissi + 2 assi = 26.
  $attese = 4 + @($FissiAttesi.Keys).Count + @($AssiAttesi.Keys).Count
  if(@($h.Keys).Count -ne $attese){ throw ($pf + ": " + @($h.Keys).Count + " righe vive invece di " + $attese + ": c'e' una riga estranea o ne manca una.") }
  return @{ Lettura=$lettura; Celle=$nc }
}
# IL GEMELLAGGIO A QUATTRO: le righe vive dei parametri (tutto tranne le
# direttive) devono essere IDENTICHE nei quattro prova; le direttive
# @SIMBOLO/@PERIODO devono valere quello che l'etichetta dichiara.
# NOTA: qui il gemellaggio e' A DUE (i due prova ESTESA: stesso TF,
# stessa finestra, differiscono SOLO per @SIMBOLO). Il gemellaggio A
# QUATTRO dei prova originali NON viene toccato ne' invalidato: quei
# quattro file restano com'erano e questa riga non li legge nemmeno.
function GateGemelli($letture){
  $chiavi = @($letture.Keys)
  $base = $chiavi[0]
  $hA = $letture[$base]
  foreach($altro in $chiavi){
    if($altro -eq $base){ continue }
    $hB = $letture[$altro]
    foreach($k in @($hA.Keys)){
      if($k -match '^@'){ continue }
      if(-not $hB.Contains($k)){ throw ("GEMELLAGGIO NON VALIDO: " + $base + " ha la riga '" + $k + "' che " + $altro + " non ha.") }
      if($hA[$k] -ne $hB[$k]){ throw ("GEMELLAGGIO NON VALIDO: '" + $k + "' vale '" + $hA[$k] + "' in " + $base + " e '" + $hB[$k] + "' in " + $altro + ". I quattro prova devono differire SOLO per @SIMBOLO e @PERIODO.") }
    }
    foreach($k in @($hB.Keys)){
      if($k -match '^@'){ continue }
      if(-not $hA.Contains($k)){ throw ("GEMELLAGGIO NON VALIDO: " + $altro + " ha la riga '" + $k + "' che " + $base + " non ha.") }
    }
    if($hA["@DAQUANDO"] -ne $hB["@DAQUANDO"] -or $hA["@FINOA"] -ne $hB["@FINOA"]){ throw ("GEMELLAGGIO NON VALIDO: finestra diversa fra " + $base + " e " + $altro + ".") }
  }
  return ("VALIDO: i " + @($chiavi).Count + " prova hanno il blocco dei parametri IDENTICO riga per riga e differiscono SOLO per @SIMBOLO e @PERIODO")
}

# L'ESITO DI UN LATO PER UNA CELLA, ricalcolato dai numeri grezzi con le
# disuguaglianze del sorgente (OnTester): serve a incrociare le colonne
# "Cx Esito" della sonda. Torna "V" (viva), "S" (sospesa), "." (no).
function StatoCella($r,[string]$lato,$sg){
  $mfe = $r.MfeL; $rr = $r.RrL
  if($lato -eq "S"){ $mfe = $r.MfeS; $rr = $r.RrS }
  $c1 = ($r.EseGT -ge $sg.C1)
  $c3 = ($mfe -ge $sg.SogliaC3)
  $c5 = ($rr -ge $sg.C5)
  $c6 = 2; if($r.NonConvT -gt $sg.C6KO){ $c6 = 0 } elseif($r.NonConvT -gt $sg.C6SOSP){ $c6 = 1 }
  $c8 = 2; if($r.Sotto60 -ge $sg.C8SOTTO60){ $c8 = 0 } elseif($r.TenMedT -lt $sg.C8TEN){ $c8 = 1 }
  if(-not ($c1 -and $c3 -and $c5) -or $c6 -eq 0 -or $c8 -eq 0){ return "." }
  if($c6 -eq 2 -and $c8 -eq 2){ return "V" }
  return "S"
}
# L'ALTOPIANO: esiste un blocco 2x2 di celle CONTIGUE (N adiacenti x
# sigma adiacenti) tutte in piedi? Torna @{ Verdetto; VVV; SSS; Mappa }.
function Altopiano($stati,$listaN,$listaSig,[string]$lato){
  $blocchiV = 0; $blocchiVS = 0
  for($i=0; $i -lt ($listaN.Count-1); $i++){
    for($j=0; $j -lt ($listaSig.Count-1); $j++){
      $q = @($stati[("" + $listaN[$i] + "|" + $listaSig[$j])], $stati[("" + $listaN[$i+1] + "|" + $listaSig[$j])],
             $stati[("" + $listaN[$i] + "|" + $listaSig[$j+1])], $stati[("" + $listaN[$i+1] + "|" + $listaSig[$j+1])])
      $tuttiV  = (@($q | Where-Object { $_ -eq "V" }).Count -eq 4)
      $tuttiVS = (@($q | Where-Object { $_ -eq "V" -or $_ -eq "S" }).Count -eq 4)
      if($tuttiV){ $blocchiV++ }
      if($tuttiVS){ $blocchiVS++ }
    }
  }
  $nV = @($stati.Values | Where-Object { $_ -eq "V" }).Count
  $nS = @($stati.Values | Where-Object { $_ -eq "S" }).Count
  $v = "NO (nessun blocco 2x2 in piedi: celle vive isolate = rumore)"
  if($blocchiV -gt 0){ $v = "VIVO (" + $blocchiV + " blocchi 2x2 tutti VIVI)" }
  elseif($blocchiVS -gt 0){ $v = "SOSPESO (" + $blocchiVS + " blocchi 2x2 in piedi ma con celle SOSPESE per C6 25-40% o C8 < 12 barre)" }
  if($nV -eq 0 -and $nS -eq 0){ $v = "NO (nessuna cella passa C1+C3+C5+C6+C8 insieme)" }
  $righe = New-Object System.Collections.ArrayList
  [void]$righe.Add(("    lato " + $lato + "   sigma -> " + (($listaSig | ForEach-Object { Fmt2 $_ }) -join "  ")))
  foreach($n in $listaN){
    $riga = "    N=" + ("" + $n).PadLeft(2) + "        "
    foreach($s in $listaSig){ $k = "" + $n + "|" + $s; $st = "?"; if($stati.ContainsKey($k)){ $st = $stati[$k] }; $riga += "  " + $st + "   " }
    [void]$righe.Add($riga)
  }
  return @{ Verdetto=$v; NV=$nV; NS=$nS; Mappa=($righe -join "`r`n") }
}

# L'ANALISI DEL CSV, in una funzione: datazione, righe CONTATE, colonne
# per NOME, collaudi PRIMA dei numeri, cella di riferimento, mappa e
# verdetto per lato. Muta $Problemi/$Rilievi e le variabili di script.
function AnalizzaCsv([string]$csvIS,[datetime]$tC,$sg){
  if(-not (Test-Path -LiteralPath $csvIS)){
    [void]$Problemi.Add("CSV OPTFRAME NON prodotto: " + $csvIS + " (storico mancante su " + $Simbolo + " o sul metro " + $METRO + "? MT5 gia' aperto? compilazione?)")
    return
  }
  $csvItem = Get-Item -LiteralPath $csvIS
  $script:CsvOraTxt = $csvItem.LastWriteTime.ToString("yyyy-MM-dd HH:mm:ss",$INV)
  if($csvItem.LastWriteTime -lt $tC){
    [void]$Problemi.Add("CSV STANTIO, NON LETTO. E' scritto alle " + $script:CsvOraTxt + ", cioe' PRIMA dell'avvio di questa corsa (" + $tC.ToString("yyyy-MM-dd HH:mm:ss",$INV) + "): e' il CSV di una corsa PRECEDENTE rimasto nella workdir (-Rifai copre il generico che SALTA, non quello che MUORE). Questa corsa NON ha numeri.")
    return
  }
  $lin = @(Get-Content -LiteralPath $csvIS | Where-Object { $_.Trim() -ne "" })
  $nRighe = $lin.Count - 1
  if($nRighe -lt 0){ $nRighe = 0 }
  $script:CsvRighe = $nRighe
  if($nRighe -ne $NCelleAttese){ [void]$Problemi.Add("" + $nRighe + " righe nel CSV, " + $NCelleAttese + " passate chieste (cache del tester? storico? passate morte a OnInit?).") }
  if($nRighe -le 0){ return }
  $head = $lin[0] -split ','
  $ix = @{}
  for($i=0; $i -lt $head.Count; $i++){ $ix[$head[$i].Trim()] = $i }
  $servono = @("Attraversamenti Grezzi Long","Attraversamenti Grezzi Short",
    "Attraversamenti Eseguibili Long","Attraversamenti Eseguibili Short","Giorni Contati",
    "Eseguibili Al Giorno Long","Eseguibili Al Giorno Short","Eseguibili Al Giorno Totale","C1 Esito",
    "Mfe Mediana Long Punti Indice","Mfe Mediana Short Punti Indice",
    "Mae Mediana Long Punti Indice","Mae Mediana Short Punti Indice",
    "Rr Da Mediane Long","Rr Da Mediane Short","Win Rate Necessario Long Pct","Win Rate Necessario Short Pct",
    "Mfe Su Spread Long","Mfe Su Spread Short","Spread Misurato Punti Indice","Soglia C3 Punti Indice",
    "C3 Esito Long","C3 Esito Short","C5 Esito Long","C5 Esito Short",
    "Chiuse Long","Chiuse Short","Convergute Long","Convergute Short",
    "Non Convergute Long Pct","Non Convergute Short Pct","Non Convergute Totale Pct","Uscite Fine Corsa Escluse","C6 Esito",
    "Max Eseguibili Giorno Long","Max Eseguibili Giorno Short","Max Eseguibili Giorno Totale","Rischio Aperto Max Pct","C7 Cap Necessario",
    "Giorni Almeno 2 Eseguibili","Giorni Zero Eseguibili",
    "Tenuta Mediana Long Barre","Tenuta Mediana Short Barre","Tenuta Mediana Totale Barre","Sotto 60 Secondi Pct","C8 Esito",
    "Barre Valutate","Barre Fuori Finestra","Barre Saltate Dati",
    "Valutazioni Metro Mancante Segnale","Valutazioni Perse Buco Finestra","Valutazioni Con Solo Metro","Z Non Calcolabile",
    "Giorni Spaiati","Giorni Spaiati Pct","C2 Esito",
    "Scartati Occupato Altro Lato Collaudo","Atr Mediano Punti Indice","Atr Divergenza Rel Media Pct","Punto Indice Prezzo",
    "Metro Prima Barra Epoch","Gamba Prima Barra Epoch","Campioni Troncati","Autotest Falliti","Autotest Blocchi",
    "Finestra N","Soglia Ingresso Sigma","Soglia Uscita Sigma","Modo Spread","Modo Z Score","Barre Max Tenuta","Barre Orizzonte","Lato Attivo",
    "Giorni Festa Metro","Giorni Metro Zero Calendario",
    "Ingressi Barra Reale Fuori","Chiuse Zero Barre")
  $manca = New-Object System.Collections.ArrayList
  foreach($cn in $servono){ if(-not $ix.ContainsKey($cn)){ [void]$manca.Add($cn) } }
  if($manca.Count -gt 0){ [void]$Problemi.Add("nel CSV mancano le colonne: " + ($manca -join ", ") + " (header OPTFRAME cambiato nella sonda?)."); return }
  if($head.Count -lt ($NSTATS_ATTESI + 3)){ [void]$Problemi.Add("header con " + $head.Count + " colonne, attese almeno " + ($NSTATS_ATTESI + 3) + ".") }
  $maxIx = 0
  foreach($cn in $servono){ if($ix[$cn] -gt $maxIx){ $maxIx = $ix[$cn] } }

  $righe = New-Object System.Collections.ArrayList
  for($i=1; $i -lt $lin.Count; $i++){
    $c = $lin[$i] -split ','
    if($c.Count -le $maxIx){ [void]$Problemi.Add("riga " + $i + " del CSV ha meno colonne dell'header: non la leggo."); continue }
    $r = [pscustomobject]@{
      N        = [int](Num $c[$ix["Finestra N"]]);  Sigma = [math]::Round((Num $c[$ix["Soglia Ingresso Sigma"]]),2)
      SigUsc   = Num $c[$ix["Soglia Uscita Sigma"]]; ModoSp = [int](Num $c[$ix["Modo Spread"]]); ModoZ = [int](Num $c[$ix["Modo Z Score"]])
      BarreMax = [int](Num $c[$ix["Barre Max Tenuta"]]); BarreOr = [int](Num $c[$ix["Barre Orizzonte"]]); Lato = [int](Num $c[$ix["Lato Attivo"]])
      GrezL = Num $c[$ix["Attraversamenti Grezzi Long"]]; GrezS = Num $c[$ix["Attraversamenti Grezzi Short"]]
      EseL  = Num $c[$ix["Attraversamenti Eseguibili Long"]]; EseS = Num $c[$ix["Attraversamenti Eseguibili Short"]]
      Giorni= Num $c[$ix["Giorni Contati"]]
      EseGL = Num $c[$ix["Eseguibili Al Giorno Long"]]; EseGS = Num $c[$ix["Eseguibili Al Giorno Short"]]; EseGT = Num $c[$ix["Eseguibili Al Giorno Totale"]]
      C1    = [int](Num $c[$ix["C1 Esito"]])
      MfeL  = Num $c[$ix["Mfe Mediana Long Punti Indice"]]; MfeS = Num $c[$ix["Mfe Mediana Short Punti Indice"]]
      MaeL  = Num $c[$ix["Mae Mediana Long Punti Indice"]]; MaeS = Num $c[$ix["Mae Mediana Short Punti Indice"]]
      RrL   = Num $c[$ix["Rr Da Mediane Long"]]; RrS = Num $c[$ix["Rr Da Mediane Short"]]
      WrL   = Num $c[$ix["Win Rate Necessario Long Pct"]]; WrS = Num $c[$ix["Win Rate Necessario Short Pct"]]
      MfeSpL= Num $c[$ix["Mfe Su Spread Long"]]; MfeSpS = Num $c[$ix["Mfe Su Spread Short"]]
      Spread= Num $c[$ix["Spread Misurato Punti Indice"]]; SogliaC3 = Num $c[$ix["Soglia C3 Punti Indice"]]
      C3L   = [int](Num $c[$ix["C3 Esito Long"]]); C3S = [int](Num $c[$ix["C3 Esito Short"]])
      C5L   = [int](Num $c[$ix["C5 Esito Long"]]); C5S = [int](Num $c[$ix["C5 Esito Short"]])
      ChL   = Num $c[$ix["Chiuse Long"]]; ChS = Num $c[$ix["Chiuse Short"]]; CvL = Num $c[$ix["Convergute Long"]]; CvS = Num $c[$ix["Convergute Short"]]
      NonConvL = Num $c[$ix["Non Convergute Long Pct"]]; NonConvS = Num $c[$ix["Non Convergute Short Pct"]]; NonConvT = Num $c[$ix["Non Convergute Totale Pct"]]
      FineCorsa= Num $c[$ix["Uscite Fine Corsa Escluse"]]; C6 = [int](Num $c[$ix["C6 Esito"]])
      MaxGL = Num $c[$ix["Max Eseguibili Giorno Long"]]; MaxGS = Num $c[$ix["Max Eseguibili Giorno Short"]]; MaxGT = Num $c[$ix["Max Eseguibili Giorno Totale"]]
      Rischio = Num $c[$ix["Rischio Aperto Max Pct"]]; C7 = [int](Num $c[$ix["C7 Cap Necessario"]])
      G2    = Num $c[$ix["Giorni Almeno 2 Eseguibili"]]; G0 = Num $c[$ix["Giorni Zero Eseguibili"]]
      TenL  = Num $c[$ix["Tenuta Mediana Long Barre"]]; TenS = Num $c[$ix["Tenuta Mediana Short Barre"]]; TenMedT = Num $c[$ix["Tenuta Mediana Totale Barre"]]
      Sotto60 = Num $c[$ix["Sotto 60 Secondi Pct"]]; C8 = [int](Num $c[$ix["C8 Esito"]])
      BarreVal = Num $c[$ix["Barre Valutate"]]; BarreFuori = Num $c[$ix["Barre Fuori Finestra"]]; BarreSal = Num $c[$ix["Barre Saltate Dati"]]
      MetroManc = Num $c[$ix["Valutazioni Metro Mancante Segnale"]]; PerseBuco = Num $c[$ix["Valutazioni Perse Buco Finestra"]]
      SoloMetro = Num $c[$ix["Valutazioni Con Solo Metro"]]; ZNon = Num $c[$ix["Z Non Calcolabile"]]
      Spaiati = Num $c[$ix["Giorni Spaiati"]]; SpaiPct = Num $c[$ix["Giorni Spaiati Pct"]]; C2 = [int](Num $c[$ix["C2 Esito"]])
      GFesta = Num $c[$ix["Giorni Festa Metro"]]; GZeroCal = Num $c[$ix["Giorni Metro Zero Calendario"]]
      IngrFuori = Num $c[$ix["Ingressi Barra Reale Fuori"]]; ChiuseZero = Num $c[$ix["Chiuse Zero Barre"]]
      AltroLato = Num $c[$ix["Scartati Occupato Altro Lato Collaudo"]]
      AtrMed = Num $c[$ix["Atr Mediano Punti Indice"]]; AtrDiv = Num $c[$ix["Atr Divergenza Rel Media Pct"]]
      PuntoIdx = Num $c[$ix["Punto Indice Prezzo"]]
      MetroEpoch = Num $c[$ix["Metro Prima Barra Epoch"]]; GambaEpoch = Num $c[$ix["Gamba Prima Barra Epoch"]]
      Troncati = [int](Num $c[$ix["Campioni Troncati"]])
      AutoKo = [int](Num $c[$ix["Autotest Falliti"]]); AutoBl = [int](Num $c[$ix["Autotest Blocchi"]]) }
    [void]$righe.Add($r)
  }
  if($righe.Count -eq 0){ return }
  $script:RigheGriglia = $righe

  # COLLAUDI, su OGNI riga, PRIMA di leggere qualunque numero. Se uno
  # solo non torna, il file NON VALE (clausola severa dei prova).
  $collaudoKo = 0
  foreach($r in $righe){
    $et = "cella N=" + $r.N + " sigma=" + (Fmt2 $r.Sigma)
    if($r.AutoKo -eq -1){ [void]$Problemi.Add($et + ": Autotest Falliti = -1 (autotest NON girato): file invalido."); $collaudoKo++ }
    elseif($r.AutoKo -gt 0){ [void]$Problemi.Add($et + ": Autotest Falliti = " + $r.AutoKo + ": la sonda DIVERGE dalla spec, i numeri NON si leggono."); $collaudoKo++ }
    if($r.AutoBl -ne $AUTOTEST_BLOCCHI_ATTESI){ [void]$Problemi.Add($et + ": Autotest Blocchi = " + $r.AutoBl + " invece di " + $AUTOTEST_BLOCCHI_ATTESI + " (sonda diversa da quella attesa?)."); $collaudoKo++ }
    if($r.AltroLato -ne 0){ [void]$Problemi.Add($et + ": Scartati Occupato Altro Lato Collaudo = " + (FmtN $r.AltroLato) + " (atteso 0 per costruzione, T6): la macchina a stati e' rotta, i numeri non valgono."); $collaudoKo++ }
    if([math]::Abs($r.Sotto60) -gt 0.0001){ [void]$Problemi.Add($et + ": Sotto 60 Secondi Pct = " + (Fmt2 $r.Sotto60) + " (atteso 0,00: a M5/M15 la tenuta minima e' una barra, T12): contabilita' dei tempi rotta."); $collaudoKo++ }
    if($r.ChiuseZero -ne 0){ [void]$Problemi.Add($et + ": Chiuse Zero Barre = " + (FmtN $r.ChiuseZero) + " (atteso 0, fix T12 v1.03: dalla v1.03 e' LO STESSO EVENTO di 'Sotto 60 Secondi Pct', qui in conteggio secco): contabilita' dei tempi rotta."); $collaudoKo++ }
    if([math]::Abs($r.PuntoIdx - 1.0) -gt 0.001){ [void]$Problemi.Add($et + ": Punto Indice Prezzo = " + (Fmt3 $r.PuntoIdx) + " invece di 1,000 (T14): MFE/MAE sbagliati di un fattore, la TAGLIA non si legge."); $collaudoKo++ }
    if([math]::Abs($r.Spread - $SpreadAtteso) -gt 0.001){ [void]$Problemi.Add($et + ": Spread Misurato Punti Indice = " + (Fmt2 $r.Spread) + " invece di " + (Fmt2 $SpreadAtteso) + ": la sonda ha preso un altro simbolo."); $collaudoKo++ }
    if([math]::Abs($r.SogliaC3 - $SogliaC3Attesa) -gt 0.001){ [void]$Problemi.Add($et + ": Soglia C3 Punti Indice = " + (Fmt2 $r.SogliaC3) + " invece di " + (Fmt2 $SogliaC3Attesa) + "."); $collaudoKo++ }
    if($r.Troncati -ne 0){ [void]$Problemi.Add($et + ": Campioni Troncati = 1: le mediane sono TRONCATE, non si leggono."); $collaudoKo++ }
    if([math]::Abs($r.AtrDiv) -gt 0.5){ [void]$Rilievi.Add($et + ": Atr Divergenza Rel Media Pct = " + ([double]$r.AtrDiv).ToString("0.0000",$INV) + " (atteso ~0 con InpAtrModoRma=false): la convenzione di iATR NON e' la SMA del TR e VA SCRITTO. Non blocca: l'ATR e' eco, non motore.") }
    if($r.MetroEpoch -le 0 -or $r.GambaEpoch -le 0){ [void]$Problemi.Add($et + ": Metro/Gamba Prima Barra Epoch = " + (FmtN $r.MetroEpoch) + "/" + (FmtN $r.GambaEpoch) + ": la serie del metro o della gamba non e' sincronizzata."); $collaudoKo++ }
    elseif($r.MetroEpoch -gt ($r.GambaEpoch + 7*86400)){ [void]$Problemi.Add($et + ": il METRO " + $METRO + " parte DOPO la gamba (" + ([DateTime]'1970-01-01').AddSeconds($r.MetroEpoch).ToString("yyyy-MM-dd",$INV) + " contro " + ([DateTime]'1970-01-01').AddSeconds($r.GambaEpoch).ToString("yyyy-MM-dd",$INV) + "): la finestra effettiva e' piu' corta per tutte le coppie, e va dichiarata."); $collaudoKo++ }
    if($r.SigUsc -ne 0.05 -or $r.ModoSp -ne 0 -or $r.ModoZ -ne 0 -or $r.BarreMax -ne 120 -or $r.BarreOr -ne 24 -or $r.Lato -ne 0){ [void]$Problemi.Add($et + ": eco dei pin diverso dall'atteso (uscita " + (Fmt2 $r.SigUsc) + ", spread " + $r.ModoSp + ", z " + $r.ModoZ + ", tenuta " + $r.BarreMax + ", orizzonte " + $r.BarreOr + ", lato " + $r.Lato + "): il pin non e' passato."); $collaudoKo++ }
    if($r.BarreSal -gt 10){ [void]$Rilievi.Add($et + ": Barre Saltate Dati = " + (FmtN $r.BarreSal) + " (atteso ~0): buchi nello storico, da guardare.") }
    if($r.SpaiPct -gt $sg.C2){ [void]$Rilievi.Add($et + ": Giorni Spaiati Pct = " + (Fmt2 $r.SpaiPct) + " > " + (Fmt2 $sg.C2) + " (C2): la sonda va rifatta filtrando i giorni spaiati, E SI DICHIARA.") }
    if($r.GZeroCal -ne 0){ [void]$Rilievi.Add($et + ": Giorni Metro Zero Calendario = " + (FmtN $r.GZeroCal) + " (atteso 0: e' il vecchio criterio v1.01 -- zero barre in TUTTO il giorno calendario sul metro 24h -- tenuto SOLO come controllo. Se non e' 0 su un metro quasi-24h, guardare da vicino: e' la spia della domanda VUOTA che la v1.02 ha corretto).") }
    # incrocio fra gli esiti scritti dalla sonda e la ricalcolo con i #define del sorgente
    $c1r = 0; if($r.EseGT -ge $sg.C1){ $c1r = 1 }
    $c6r = 2; if($r.NonConvT -gt $sg.C6KO){ $c6r = 0 } elseif($r.NonConvT -gt $sg.C6SOSP){ $c6r = 1 }
    $c8r = 2; if($r.Sotto60 -ge $sg.C8SOTTO60){ $c8r = 0 } elseif($r.TenMedT -lt $sg.C8TEN){ $c8r = 1 }
    $c3Lr = 0; if($r.MfeL -gt $sg.Largo){ $c3Lr = 2 } elseif($r.MfeL -ge $sg.SogliaC3){ $c3Lr = 1 }
    $c3Sr = 0; if($r.MfeS -gt $sg.Largo){ $c3Sr = 2 } elseif($r.MfeS -ge $sg.SogliaC3){ $c3Sr = 1 }
    if($r.C1 -ne $c1r -or $r.C6 -ne $c6r -or $r.C8 -ne $c8r -or $r.C3L -ne $c3Lr -or $r.C3S -ne $c3Sr){
      [void]$Problemi.Add($et + ": gli esiti scritti dalla sonda (C1 " + $r.C1 + ", C3 " + $r.C3L + "/" + $r.C3S + ", C6 " + $r.C6 + ", C8 " + $r.C8 + ") NON coincidono con la ricalcolo dai #define (" + $c1r + ", " + $c3Lr + "/" + $c3Sr + ", " + $c6r + ", " + $c8r + "): sonda e driver non applicano le stesse disuguaglianze. NON si legge.")
      $collaudoKo++
    }
  }
  # FIX T12 v1.03, MISURATO (non solo dichiarato): quante volte il gate
  # sulla barra REALE ha morso dove il gate vecchio (barra teorica) lasciava
  # passare. E' la somma su tutte le celle, non un collaudo per riga: puo'
  # essere 0 per costruzione (nessun buco di storico incontrato in QUESTA
  # finestra/simbolo), e in quel caso il fix non e' stato messo alla prova
  # qui, non e' "sbagliato" -- si dichiara e basta (ordine di lettura
  # consigliato: 1. autotest 0/25, 2. Chiuse Zero Barre=0 e Sotto60=0,00 su
  # tutte le celle, 3. questo numero: se e' 0 mentre il 2 passa comunque,
  # il fix non ha mai morso qui).
  $sommaIngrFuori = (@($righe | Measure-Object -Property IngrFuori -Sum)).Sum
  if($null -eq $sommaIngrFuori){ $sommaIngrFuori = 0 }
  if($sommaIngrFuori -eq 0){ [void]$Rilievi.Add("FIX T12 (v1.03) NON MISURATO IN QUESTA CORSA: Ingressi Barra Reale Fuori = 0 sulla somma delle " + $righe.Count + " celle. Il collaudo T12 (Chiuse Zero Barre / Sotto 60 Secondi Pct) puo' passare comunque: se qui non c'e' nessun buco di storico, il fix semplicemente non e' mai stato chiamato a intervenire su questa finestra/simbolo, e non e' un problema. Se invece T12 fallisce ancora ALTROVE con questo a 0, la diagnosi v1.03 va riverificata (vedi commento del sorgente).") }
  else{ [void]$Rilievi.Add("FIX T12 (v1.03) MISURATO: Ingressi Barra Reale Fuori = " + (FmtN $sommaIngrFuori) + " (somma sulle " + $righe.Count + " celle): il gate nuovo sulla barra REALE ha morso almeno una volta dove il gate vecchio (barra teorica) avrebbe lasciato passare l'ingresso. E' la prova che il fix e' falsificabile e regge.") }
  # la finestra EFFETTIVA (tetto o broker, classe 36): dalla prima riga.
  $r0 = $righe[0]
  $dGamba = ([DateTime]'1970-01-01').AddSeconds($r0.GambaEpoch)
  $dMetro = ([DateTime]'1970-01-01').AddSeconds($r0.MetroEpoch)
  $dChiesta = [DateTime]::ParseExact($DaQuando,"yyyy.MM.dd",$INV)
  $dFine    = [DateTime]::ParseExact($Fino,"yyyy.MM.dd",$INV)
  $feriali = 0; $d = $dChiesta
  while($d -le $dFine){ if($d.DayOfWeek -ne "Saturday" -and $d.DayOfWeek -ne "Sunday"){ $feriali++ }; $d = $d.AddDays(1) }
  $script:TettoTxt = $script:TettoTxt + " | EFFETTIVA: prima barra GAMBA " + $dGamba.ToString("yyyy-MM-dd",$INV) + ", METRO " + $dMetro.ToString("yyyy-MM-dd",$INV) + ", Giorni Contati " + (FmtN $r0.Giorni) + " su ~" + $feriali + " feriali chiesti, Barre Valutate " + (FmtN $r0.BarreVal)
  if($dGamba -gt $dChiesta.AddDays(7)){ [void]$Rilievi.Add("FINESTRA EFFETTIVA PIU' CORTA di quella chiesta: la gamba parte dal " + $dGamba.ToString("yyyy-MM-dd",$INV) + " invece che dal " + $DaQuando + ". TETTO del tester (classe 36) o storico del broker: C1 resta per-giorno sul denominatore CONTATO (leggibile), campione e regime coperto si DICHIARANO nella lettura.") }
  if($r0.Giorni -lt 0.75*$feriali){ [void]$Rilievi.Add("Giorni Contati " + (FmtN $r0.Giorni) + " contro ~" + $feriali + " feriali nella finestra chiesta: la corsa copre MENO del 75% dei giorni. Finestra effettiva piu' corta (tetto/storico) o molti giorni senza barre in finestra: si dichiara.") }
  # firma del tetto sul gemello dello stesso TF, se il suo CSV esiste
  # il gemello si legge dalla tabella $CORSE (campo Gemello), non si
  # ricostruisce concatenando "NAS_" + $Periodo: con le etichette _EST
  # quella concatenazione cercherebbe un CSV che non esiste, e la firma
  # del tetto risulterebbe "non verificabile" per un motivo finto.
  $altroSim = $CORSE[$Prova].GemelloSim; $altraEt = $CORSE[$Prova].Gemello
  $csvAltro = Join-Path $Results ($EA + "_" + $altroSim + "_IS_ohlc_" + $altraEt + ".csv")
  if(Test-Path -LiteralPath $csvAltro){
    try{
      $la = @(Get-Content -LiteralPath $csvAltro | Where-Object { $_.Trim() -ne "" })
      if($la.Count -ge 2){
        $ha = $la[0] -split ','; $ixa = @{}; for($i=0; $i -lt $ha.Count; $i++){ $ixa[$ha[$i].Trim()] = $i }
        $ca = $la[1] -split ','
        if($ixa.ContainsKey("Barre Valutate")){
          $bvA = Num $ca[$ixa["Barre Valutate"]]
          $dataA = (Get-Item -LiteralPath $csvAltro).LastWriteTime.ToString("yyyy-MM-dd HH:mm",$INV)
          if([math]::Abs($bvA - $r0.BarreVal) -lt 0.5){ [void]$Rilievi.Add("FIRMA DEL TETTO (classe 36): Barre Valutate IDENTICHE (" + (FmtN $r0.BarreVal) + ") a quelle di " + $altraEt + " (CSV del " + $dataA + "). Il broker non da' mai lo stesso numero a due simboli diversi; il tetto si'. La finestra effettiva e' quella del tetto, non quella chiesta.") }
          else{ [void]$Rilievi.Add("confronto col gemello " + $altraEt + " (CSV del " + $dataA + "): Barre Valutate " + (FmtN $r0.BarreVal) + " contro " + (FmtN $bvA) + " -> NON identiche, nessuna firma del tetto su questo confronto.") }
        }
      }
    } catch { [void]$Rilievi.Add("confronto col gemello " + $altraEt + " non riuscito: " + $_.Exception.Message) }
  }
  else{ [void]$Rilievi.Add("firma del tetto NON verificabile a macchina in questa corsa: il CSV del gemello " + $altraEt + " non e' in workdir. Si confronta a mano 'Barre Valutate' fra i due referti dello stesso TF: IDENTICHE = tetto.") }

  if($collaudoKo -gt 0){
    $script:VerdettoL = "NON LEGGIBILE (" + $collaudoKo + " collaudi falliti: vedi PROBLEMI)"
    $script:VerdettoS = $script:VerdettoL
    return
  }
  # la cella di riferimento (la domanda-sonda del GIACIMENTO)
  $script:Cella = @($righe | Where-Object { $_.N -eq $RIF_N -and [math]::Abs($_.Sigma - $RIF_SIGMA) -lt 0.001 }) | Select-Object -First 1
  if($null -eq $script:Cella){ [void]$Rilievi.Add("la cella di riferimento N=" + $RIF_N + " sigma=" + (Fmt2 $RIF_SIGMA) + " NON e' nel CSV (griglia diversa?): la domanda-sonda si legge sulla cella piu' vicina, a mano.") }

  # --- COLLAUDO DI RIPRODUZIONE (esiste SOLO in questa riga ESTESA).
  #     La stessa cella, con gli stessi input, deve dare gli stessi
  #     numeri del 04/09: una passata non sa nemmeno che la griglia
  #     intorno a lei e' cresciuta. Se non torna, il referto del 04/09
  #     non e' riproducibile su questo banco, e la scelta della cella
  #     per il round a tick non si puo' appoggiare su di lui.
  if($null -eq $script:Cella){
    [void]$Problemi.Add("COLLAUDO DI RIPRODUZIONE NON ESEGUIBILE: la cella N=" + $RIF_N + " sigma=" + (Fmt2 $RIF_SIGMA) + " non e' nel CSV, quindi non si puo' verificare che questa corsa riproduca i numeri del 04/09. La mappa estesa NON si cuce su quella vecchia.")
  }
  elseif(-not $RIPRO.ContainsKey($Simbolo)){
    [void]$Rilievi.Add("COLLAUDO DI RIPRODUZIONE saltato: nessun atteso in tabella per " + $Simbolo + ". Si dichiara, non si inventa un atteso.")
  }
  else{
    $rip = $RIPRO[$Simbolo]
    $cr  = $script:Cella
    $sc  = New-Object System.Collections.ArrayList
    $oss = [ordered]@{ "Giorni Contati"=$cr.Giorni; "Barre Valutate"=$cr.BarreVal;
                       "Grezzi L"=$cr.GrezL; "Grezzi S"=$cr.GrezS;
                       "Eseguibili L"=$cr.EseL; "Eseguibili S"=$cr.EseS }
    $chi = [ordered]@{ "Giorni Contati"="Giorni"; "Barre Valutate"="BarreVal";
                       "Grezzi L"="GrezL"; "Grezzi S"="GrezS";
                       "Eseguibili L"="EseL"; "Eseguibili S"="EseS" }
    foreach($vk in @($oss.Keys)){
      $val = [double]$oss[$vk]; $atteso = [double]$rip[$chi[$vk]]
      if([math]::Abs($val - $atteso) -gt 0.5){ [void]$sc.Add($vk + " " + (FmtN $val) + " invece di " + (FmtN $atteso)) }
    }
    $oss2 = [ordered]@{ "MFE mediana L"=$cr.MfeL; "MFE mediana S"=$cr.MfeS;
                        "MAE mediana L"=$cr.MaeL; "MAE mediana S"=$cr.MaeS;
                        "Non convergute tot pct"=$cr.NonConvT; "Tenuta mediana tot"=$cr.TenMedT }
    $chi2 = [ordered]@{ "MFE mediana L"="MfeL"; "MFE mediana S"="MfeS";
                        "MAE mediana L"="MaeL"; "MAE mediana S"="MaeS";
                        "Non convergute tot pct"="NonConvT"; "Tenuta mediana tot"="TenMedT" }
    foreach($vk in @($oss2.Keys)){
      $val = [double]$oss2[$vk]; $atteso = [double]$rip[$chi2[$vk]]
      if([math]::Abs($val - $atteso) -gt 0.011){ [void]$sc.Add($vk + " " + (Fmt2 $val) + " invece di " + (Fmt2 $atteso)) }
    }
    if($sc.Count -gt 0){
      [void]$Problemi.Add("COLLAUDO DI RIPRODUZIONE FALLITO sulla cella N=" + $RIF_N + " sigma=" + (Fmt2 $RIF_SIGMA) + " (" + $Simbolo + "): " + ($sc -join "; ") + ". Estendere la griglia NON puo' cambiare una passata con gli stessi identici input: se questi numeri divergono e' cambiato il BANCO (storico scaricato dopo il 04/09, cache del tester, sorgente diverso). I numeri del referto del 04/09 NON sono riproducibili qui: la mappa estesa resta leggibile DA SOLA, ma i verdetti del 04/09 vanno considerati SUPERATI, non confermati.")
    }
    else{
      [void]$Rilievi.Add("COLLAUDO DI RIPRODUZIONE PASSATO sulla cella N=" + $RIF_N + " sigma=" + (Fmt2 $RIF_SIGMA) + " (" + $Simbolo + "): 12 grandezze su 12 identiche ai referti del 04/09 (6 conteggi esatti + 6 mediane/quote a 0,01). Le celle nuove si leggono sulla STESSA scala delle vecchie.")
    }
  }
  # la mappa 7x7 e l'ALTOPIANO, per lato
  $listaN   = @($righe | ForEach-Object { $_.N } | Sort-Object -Unique)
  $listaSig = @($righe | ForEach-Object { $_.Sigma } | Sort-Object -Unique)
  $mappe = @{ "L"=$null; "S"=$null }
  foreach($lato in @("L","S")){
    $stati = @{}
    foreach($r in $righe){ $stati[("" + $r.N + "|" + $r.Sigma)] = (StatoCella $r $lato $sg) }
    $a = Altopiano $stati $listaN $listaSig $lato
    $script:Mappa[$lato] = $a.Mappa + "`r`n    celle VIVE " + $a.NV + " / SOSPESE " + $a.NS + " su " + $righe.Count
    if($lato -eq "L"){ $script:VerdettoL = $a.Verdetto } else { $script:VerdettoS = $a.Verdetto }
  }
}

# =====================================================================
#  INIZIO ESECUZIONE
# =====================================================================
try{
  Titolo ("SONDA RELATIVO -- PASSO 0, CONTATORE (" + $EA + ") -- modo " + $Modo)
  if($Pin -eq ""){ throw "-Pin obbligatorio: senza, girerebbe la punta del branch spacciandola per un commit congelato." }
  if($Pin -notmatch '^[0-9a-f]{40}$'){ throw ("-Pin deve essere un commit di 40 caratteri esadecimali, ricevuto: " + $Pin) }
  if($Prova -eq ""){ throw ("-Prova obbligatorio: uno fra " + (@($CORSE.Keys) -join ", ") + ".") }
  if(Get-Process terminal64,metaeditor64 -ErrorAction SilentlyContinue){
    throw "MT5 O METAEDITOR APERTO: col terminale aperto il tester non gira (zero CSV), con MetaEditor aperto la compilazione torna subito senza compilare."
  }
  $corsa    = $CORSE[$Prova]
  $Simbolo  = $corsa.Simbolo
  $Periodo  = $corsa.Periodo
  $FileProva= $corsa.File
  Dico ("pin ......... " + $Pin)
  Dico ("prova ....... " + $Prova + " = " + $FileProva + " | gamba " + $Simbolo + " " + $Periodo + " | metro " + $METRO + " (si legge, non si scambia)")
  Dico ("finestra .... " + $DaQuando + " -> " + $Fino + " (UNA TRANCHE, FrazioneIS " + $FrazioneIS + ")")
  Dico ("banco ....... MODELLO 2 (SOLO PREZZI DI APERTURA), " + $NCelleAttese + " passate (GRIGLIA ESTESA: N 10..55 passo 5 = 10 valori x sigma 0,75..1,95 passo 0,15 = 9 valori; le " + $NCelleVecchie + " celle del 04/09 sono CONTENUTE qui dentro). Deposito " + $Deposito + " (inerte: zero ordini)")
  Dico ("regola ...... ALTOPIANO, NON PICCO: verdetto per lato = esiste un blocco 2x2 di celle contigue con C1+C3+C5+C6+C8 in piedi INSIEME. Cella isolata = rumore = NO.") "Yellow"

  # -------------------------------------------------------------------
  #  1. SCARICO AL PIN + SENTINELLA DI UN GIRO PRECEDENTE
  # -------------------------------------------------------------------
  Titolo "1. SCARICO AL PIN"
  New-Item -ItemType Directory -Force -Path $Work,$Prove | Out-Null
  if(Test-Path -LiteralPath $Sentinella){
    $SentTrovata = (@(Get-Content -LiteralPath $Sentinella -ErrorAction SilentlyContinue) -join " | ")
    [void]$Rilievi.Add("SENTINELLA di un giro PRECEDENTE INTERROTTO trovata (classe 116): " + $SentTrovata + ". I file elencati sono rimasti nel terminale; questo giro li riscrive e la sentinella viene rimossa a fine raccolta.")
    Dico ("sentinella di un giro interrotto: " + $SentTrovata) "Yellow"
  }
  $drv = Join-Path $Work "walkforward_generico.ps1"
  Scarica ($RawPin + "/backtest_pipeline/walkforward_generico.ps1") $drv
  $t = Get-Content -LiteralPath $drv -Raw
  if($t -notmatch '\$EABranch\s*=\s*"lavoro"'){ throw 'walkforward_generico.ps1 non ha la riga $EABranch = "lavoro" attesa: non lo posso pinnare (il pin varrebbe per il driver e NON per la sonda misurata).' }
  $t = $t -replace '\$EABranch\s*=\s*"lavoro"', ('$EABranch="' + $Pin + '"')
  Set-Content -LiteralPath $drv -Value $t -Encoding ASCII
  Dico "driver generico scaricato e PINNATO (riscarica la sonda al pin, non dalla punta del branch)" "Green"
  Remove-Item -Path (Join-Path $Prove "RELATIVO_*.txt") -Force -ErrorAction SilentlyContinue
  foreach($k in @($CORSE.Keys)){ Scarica ($RawPin + "/backtest_pipeline/prove/" + $CORSE[$k].File) (Join-Path $Prove $CORSE[$k].File) }
  Dico ("file prova scaricati: " + @(Get-ChildItem $Prove -Filter "RELATIVO_*_ESTESA.txt").Count + " su 2 (ne gira UNO, l'altro serve al gemellaggio a DUE)") "Green"
  $mq5 = Join-Path $Work ($EA + ".mq5")
  Scarica ($RawPin + "/mql5/Experts/" + $EA + ".mq5") $mq5

  # -------------------------------------------------------------------
  #  2. IDENTITA' DEL SORGENTE (versione, autotest, colonne, input,
  #     contatore puro, include, #define delle soglie)
  # -------------------------------------------------------------------
  Titolo "2. IDENTITA' DEL SORGENTE AL PIN"
  $src = Get-Content -LiteralPath $mq5 -Raw
  $srcRighe = @(Get-Content -LiteralPath $mq5)
  $mv = [regex]::Match($src, '(?m)^\s*#property\s+version\s+"([^"]+)"')
  if(-not $mv.Success){ throw "il sorgente non ha #property version." }
  $VersioneTxt = $mv.Groups[1].Value
  if($VersioneTxt -ne $VERSIONE_ATTESA){ throw ("#property version e' '" + $VersioneTxt + "', attesa '" + $VERSIONE_ATTESA + "': non e' la sonda che la pagina descrive.") }
  $nBlocchi = 0
  foreach($rg in $srcRighe){ $viva = ($rg -replace '//.*$',''); if($viva -match '^\s*blocchi\+\+\s*;'){ $nBlocchi++ } }
  $AutoSrcTxt = "" + $nBlocchi + " blocchi (righe 'blocchi++;' fuori dai commenti)"
  if($nBlocchi -ne $AUTOTEST_BLOCCHI_ATTESI){ throw ("autotest: " + $AutoSrcTxt + ", attesi " + $AUTOTEST_BLOCCHI_ATTESI + ".") }
  if($src -notmatch '\[AUTOTEST\]\s+21\s'){ throw "autotest: manca il blocco 21 nel sorgente (etichetta [AUTOTEST] 21)." }
  $defs = LeggiDefine $src
  $nst = [int](DefNum $defs "REL_NSTATS")
  $NStatsTxt = "REL_NSTATS = " + $nst + " -> " + ($nst + 3) + " colonne"
  if($nst -ne $NSTATS_ATTESI){ throw ("REL_NSTATS = " + $nst + ", atteso " + $NSTATS_ATTESI + " (100 colonne).") }
  $inputEA = LeggiInputEA $src
  $InputTxt = "" + @($inputEA).Count + " input letti dal sorgente"
  if(@($inputEA).Count -ne $INPUT_ATTESI){ throw ("input: " + $InputTxt + ", attesi " + $INPUT_ATTESI + ".") }
  $chiamate = 0
  foreach($rg in $srcRighe){ $viva = ($rg -replace '//.*$',''); if($viva -match 'OrderSend|CTrade|PositionClose|PositionOpen|OrderClose|Trade\.mqh|\.Buy\(|\.Sell\('){ $chiamate++ } }
  $GrepTxt = "" + $chiamate + " chiamate di trading fuori dai commenti (attese 0)"
  if($chiamate -gt 0){ throw ("IL CONTATORE NON E' PURO: " + $GrepTxt + ".") }
  $nInc = 0
  foreach($rg in $srcRighe){ $viva = ($rg -replace '//.*$',''); if($viva -match '^\s*#include\b'){ $nInc++ } }
  $IncludeTxt = "" + $nInc + " righe #include (attese 0: sonda autosufficiente)"
  if($nInc -gt 0){ throw ("il sorgente ha " + $nInc + " #include: la pagina dice che e' autosufficiente, e nessuno li installa. Ci si ferma prima di compilare.") }
  # LE SOGLIE, dal sorgente, confrontate con la pagina.
  $SoglieSrc = @{
    C1 = (DefNum $defs "REL_C1_ESEGUIBILI_GIORNO"); C5 = (DefNum $defs "REL_C5_RR_MINIMO")
    C6KO = (DefNum $defs "REL_C6_NON_CONVERGUTE_KO"); C6SOSP = (DefNum $defs "REL_C6_NON_CONVERGUTE_SOSP")
    C8TEN = (DefNum $defs "REL_C8_TENUTA_BARRE_MIN"); C8SOTTO60 = (DefNum $defs "REL_C8_QUOTA_SOTTO60_KO")
    C2 = (DefNum $defs "REL_C2_GIORNI_SPAIATI_PCT"); C7R = (DefNum $defs "REL_C7_RISCHIO_PER_TRADE"); C7CAP = (DefNum $defs "REL_C7_CAP_RISCHIO_APERTO")
    MultScarto = (DefNum $defs "REL_C3_MULTIPLO_SCARTO"); MultLargo = (DefNum $defs "REL_C3_MULTIPLO_LARGO")
    SpreadD30 = (DefNum $defs "REL_SPREAD_D30EUR"); SpreadNAS = (DefNum $defs "REL_SPREAD_NASUSD") }
  $spreadSrc = $SoglieSrc.SpreadD30
  if($Simbolo -eq "NASUSD"){ $spreadSrc = $SoglieSrc.SpreadNAS }
  $SoglieSrc["SogliaC3"] = $SoglieSrc.MultScarto * $spreadSrc
  $SoglieSrc["Largo"]    = $SoglieSrc.MultLargo  * $spreadSrc
  $SpreadAtteso   = $spreadSrc
  $SogliaC3Attesa = $SoglieSrc.SogliaC3
  $diverg = New-Object System.Collections.ArrayList
  if($SoglieSrc.C1 -ne $PAGINA_C1_TOT_GG){ [void]$diverg.Add("C1 " + (Fmt2 $SoglieSrc.C1) + " vs pagina " + (Fmt2 $PAGINA_C1_TOT_GG)) }
  if($SoglieSrc.C5 -ne $PAGINA_C5_RR){ [void]$diverg.Add("C5 " + (Fmt2 $SoglieSrc.C5) + " vs " + (Fmt2 $PAGINA_C5_RR)) }
  if($SoglieSrc.C6KO -ne $PAGINA_C6_KO -or $SoglieSrc.C6SOSP -ne $PAGINA_C6_SOSP){ [void]$diverg.Add("C6 " + (Fmt2 $SoglieSrc.C6SOSP) + "/" + (Fmt2 $SoglieSrc.C6KO) + " vs " + (Fmt2 $PAGINA_C6_SOSP) + "/" + (Fmt2 $PAGINA_C6_KO)) }
  if($SoglieSrc.C8TEN -ne $PAGINA_C8_TENUTA -or $SoglieSrc.C8SOTTO60 -ne $PAGINA_C8_SOTTO60){ [void]$diverg.Add("C8 " + (Fmt2 $SoglieSrc.C8TEN) + "/" + (Fmt2 $SoglieSrc.C8SOTTO60) + " vs " + (Fmt2 $PAGINA_C8_TENUTA) + "/" + (Fmt2 $PAGINA_C8_SOTTO60)) }
  if($SoglieSrc.C2 -ne $PAGINA_C2_SPAIATI){ [void]$diverg.Add("C2 " + (Fmt2 $SoglieSrc.C2) + " vs " + (Fmt2 $PAGINA_C2_SPAIATI)) }
  if($SoglieSrc.C7R -ne $PAGINA_C7_RISCHIO -or $SoglieSrc.C7CAP -ne $PAGINA_C7_CAP){ [void]$diverg.Add("C7 " + (Fmt2 $SoglieSrc.C7R) + "/" + (Fmt2 $SoglieSrc.C7CAP) + " vs " + (Fmt2 $PAGINA_C7_RISCHIO) + "/" + (Fmt2 $PAGINA_C7_CAP)) }
  if($SoglieSrc.MultScarto -ne $PAGINA_C3_MULT -or $SoglieSrc.MultLargo -ne $PAGINA_C3_LARGO){ [void]$diverg.Add("C3 multipli " + (Fmt2 $SoglieSrc.MultScarto) + "/" + (Fmt2 $SoglieSrc.MultLargo) + " vs " + (Fmt2 $PAGINA_C3_MULT) + "/" + (Fmt2 $PAGINA_C3_LARGO)) }
  if($spreadSrc -ne $corsa.SpreadPagina){ [void]$diverg.Add("spread " + $Simbolo + " " + (Fmt2 $spreadSrc) + " vs pagina " + (Fmt2 $corsa.SpreadPagina)) }
  $DefineTxt = "C1 >= " + (Fmt2 $SoglieSrc.C1) + "/gg | C3 MFE >= " + (Fmt2 $SoglieSrc.SogliaC3) + " pti (" + (Fmt2 $SoglieSrc.MultScarto) + " x spread " + (Fmt2 $spreadSrc) + "; largo > " + (Fmt2 $SoglieSrc.Largo) + ") | C5 RR >= " + (Fmt2 $SoglieSrc.C5) + " | C6 non conv. > " + (Fmt2 $SoglieSrc.C6KO) + "% scarto, " + (Fmt2 $SoglieSrc.C6SOSP) + "-" + (Fmt2 $SoglieSrc.C6KO) + "% sospeso | C8 tenuta < " + (Fmt2 $SoglieSrc.C8TEN) + " barre sospeso, >= " + (Fmt2 $SoglieSrc.C8SOTTO60) + "% sotto 60 s scarto | C2 > " + (Fmt2 $SoglieSrc.C2) + "% spaiati | C7 " + (Fmt2 $SoglieSrc.C7R) + "% x max/gg vs cap " + (Fmt2 $SoglieSrc.C7CAP) + "%"
  if($diverg.Count -gt 0){ throw ("LE SOGLIE DEL SORGENTE NON SONO QUELLE DELLA PAGINA: " + ($diverg -join "; ") + ". Il criterio si cambia PRIMA dei numeri, non dopo: ci si ferma.") }
  Dico ("versione " + $VersioneTxt + " | autotest " + $AutoSrcTxt + " | " + $NStatsTxt + " | " + $InputTxt + " | " + $GrepTxt + " | " + $IncludeTxt) "Green"
  Dico ("soglie dal sorgente (= pagina): " + $DefineTxt) "Green"

  # -------------------------------------------------------------------
  #  3. I GATE SUI PROVA -- girano PRIMA di aprire MT5
  # -------------------------------------------------------------------
  Titolo "3. GATE SUI DUE PROVA (direttive nude + input nei due versi + 2 assi + 90 celle + fissi + gemellaggio a DUE)"
  $letture = [ordered]@{}
  foreach($k in @($CORSE.Keys)){
    $esito = GateProva (Join-Path $Prove $CORSE[$k].File) $CORSE[$k].File $CORSE[$k].Simbolo $CORSE[$k].Periodo $inputEA
    $letture[$k] = $esito.Lettura.Mappa
    if($k -eq $Prova){ $CelleTxt = "" + $esito.Celle + " (2 assi ESTESI: InpFinestraN 10..55 passo 5 x InpSogliaIngressoSigma 0,75..1,95 passo 0,15; il 04/09 erano 10..40 x 0,75..1,65 = 49), ricontate dai pin ||Y al pin" }
  }
  Dico ("gate per prova: 4 direttive nude, " + $INPUT_ATTESI + " input pinnati nome per nome nei DUE versi, 2 assi esatti, celle " + $CelleTxt + ", nessuna riga estranea: PASSATI su 4/4") "Green"
  $GemelliTxt = GateGemelli $letture
  Dico ("gemellaggio: " + $GemelliTxt) "Green"

  # -------------------------------------------------------------------
  #  4. IL TETTO DELLE BARRE: si ferma, non corregge in silenzio
  # -------------------------------------------------------------------
  Titolo "4. IL TETTO DELLE ~100.000 BARRE DEL TESTER"
  $dA = [DateTime]::ParseExact($DaQuando,"yyyy.MM.dd",$INV)
  $dB = [DateTime]::ParseExact($Fino,"yyyy.MM.dd",$INV)
  $giorniChiesti = [int]($dB - $dA).TotalDays
  $tetto = $TETTO_GIORNI[$Periodo]
  $anni = ([double]$giorniChiesti/365.0).ToString("0.00",$INV)
  if($giorniChiesti -gt $tetto){
    $TettoTxt = "OLTRE IL TETTO: " + $Periodo + " chiede " + $giorniChiesti + " giorni (" + $anni + " anni) contro ~" + $tetto + " giorni (" + ([double]$tetto/365.0).ToString("0.0",$INV) + " anni) di tetto"
    if(-not $AccettoTettoBarre){
      throw ("FINESTRA OLTRE IL TETTO DEL TESTER su " + $Periodo + ": " + $giorniChiesti + " giorni chiesti (" + $anni + " anni) contro ~" + $tetto + " (CLAUDE.md 25/08). Il prova lo DICHIARA e sceglie di non spezzare; questa riga NON lo corregge in silenzio e NON parte in silenzio. Due strade, entrambe dichiarate nella pagina: (a) rilanciare CON -AccettoTettoBarre (la sonda dichiara la finestra effettiva con Giorni Contati / Gamba Prima Barra Epoch e il referto la stampa); (b) un @DAQUANDO piu' vicino nel prova (~2025.03.10 per 1,3 anni), che e' una modifica del prova e si committa.")
    }
    $TettoTxt = $TettoTxt + " -- ACCETTATO con -AccettoTettoBarre (scelta DICHIARATA): la finestra EFFETTIVA la dice la sonda, e sta qui sotto"
    [void]$Rilievi.Add("TETTO BARRE accettato esplicitamente (-AccettoTettoBarre): " + $Periodo + " su " + $giorniChiesti + " giorni chiesti contro ~" + $tetto + " di tetto. La finestra EFFETTIVA (Gamba Prima Barra Epoch, Giorni Contati, Barre Valutate) e' nel referto e va letta PRIMA di C1: il denominatore e' quello contato, non quello chiesto.")
    Dico $TettoTxt "Yellow"
  }
  else{
    $TettoTxt = "DENTRO IL TETTO: " + $Periodo + " chiede " + $giorniChiesti + " giorni (" + $anni + " anni) contro ~" + $tetto + " di tetto"
    if($AccettoTettoBarre){ [void]$Rilievi.Add("-AccettoTettoBarre passato su una corsa che sta DENTRO il tetto (" + $Periodo + "): inerte, dichiarato.") }
    Dico $TettoTxt "Green"
  }

  # -------------------------------------------------------------------
  #  5. IL TERMINALE (classe 115: da un FATTO, non dal nome) + FOTO PRIMA
  # -------------------------------------------------------------------
  Titolo "5. TERMINALE DI BACKTEST (terminal64 + metaeditor64 + cartella dati)"
  $termRoot = Join-Path $env:APPDATA "MetaQuotes\Terminal"
  $mappaT = @{}
  foreach($d in @(Get-ChildItem -LiteralPath $termRoot -Directory -ErrorAction SilentlyContinue)){
    $o = Join-Path $d.FullName "origin.txt"
    if(Test-Path -LiteralPath $o){
      $io = (Get-Content -LiteralPath $o -Raw -ErrorAction SilentlyContinue)
      if($null -ne $io){ $io = $io.Trim(); if($io -ne "" -and -not $mappaT.ContainsKey($io)){ $mappaT[$io] = $d.FullName } }
    }
  }
  $cand = New-Object System.Collections.ArrayList
  foreach($k in @($mappaT.Keys)){
    if(-not (Test-Path -LiteralPath (Join-Path $k "terminal64.exe"))){ continue }
    if(-not (Test-Path -LiteralPath (Join-Path $k "metaeditor64.exe"))){ continue }
    $df = $mappaT[$k]
    $fatto = ""
    $basi = @(Get-ChildItem -LiteralPath (Join-Path $df "bases") -Directory -ErrorAction SilentlyContinue | Where-Object { $_.Name -like "*BCM*" })
    if($basi.Count -gt 0){ $fatto = "cartella dati con bases\" + $basi[0].Name }
    elseif($k -like "*BCM*"){ $fatto = "percorso di installazione" }
    [void]$cand.Add([pscustomobject]@{ Inst=$k; Data=$df; Fatto=$fatto })
  }
  Write-Host "  installazioni MT5 con cartella dati, terminal64 e metaeditor64:" -ForegroundColor Gray
  foreach($c in $cand){ $f = $c.Fatto; if($f -eq ""){ $f = "nessun fatto BCM" }; Write-Host ("    " + $c.Inst + "   [" + $f + "]   dati: " + $c.Data) -ForegroundColor Gray }
  $scelto = $null
  if($Terminale -ne ""){
    $scelto = @($cand | Where-Object { $_.Inst -ieq $Terminale.TrimEnd("\") }) | Select-Object -First 1
    if($null -eq $scelto){ throw ("-Terminale '" + $Terminale + "' non e' fra le installazioni con cartella dati elencate qui sopra (il tester ha bisogno della cartella dati, non basta l'exe).") }
    $TermCrit = "SCELTO A MANO con -Terminale"
  }
  else{
    $conFatto = @($cand | Where-Object { $_.Fatto -ne "" })
    $senzaV3  = @($conFatto | Where-Object { $_.Inst -notlike "*-V3*" })
    if($senzaV3.Count -ge 1){
      $scelto = $senzaV3[0]; $TermCrit = "FATTO: " + $scelto.Fatto + " (scartate le installazioni -V3)"
      if($senzaV3.Count -gt 1){ [void]$Rilievi.Add("piu' di una installazione BCM non -V3 (" + $senzaV3.Count + "): scelta la prima (" + $scelto.Inst + "). Se non e' quella del banco di backtest, rilancia con -Terminale.") }
    }
    elseif($conFatto.Count -ge 1){ $scelto = $conFatto[0]; $TermCrit = "FATTO: " + $scelto.Fatto + " (solo -V3 disponibili: DICHIARATO)"; [void]$Rilievi.Add("l'unica installazione BCM con cartella dati e' una -V3: usata, dichiarato.") }
    elseif($cand.Count -eq 1){ $scelto = $cand[0]; $TermCrit = "NESSUN FATTO BCM: unica installazione presente (dichiarato)"; [void]$Rilievi.Add("nessun fatto ha identificato un terminale BCM: usata l'unica installazione MT5 con cartella dati. Dichiarato, non indovinato.") }
    else{
      $elenco = (@($cand | ForEach-Object { $_.Inst }) -join " | ")
      throw ("NON SO QUALE TERMINALE USARE (classe 115: l'ambiente non si indovina dal nome). Candidati: " + $elenco + ". Rilancia aggiungendo -Terminale ""<percorso di installazione>"".")
    }
  }
  $TermScelto = $scelto.Inst
  $DataFolder = $scelto.Data
  $TermExe = Join-Path $TermScelto "terminal64.exe"
  $MeExe   = Join-Path $TermScelto "metaeditor64.exe"
  Dico ("terminale scelto: " + $TermScelto + "  [" + $TermCrit + "]  dati: " + $DataFolder) "Yellow"

  $dstExp  = Join-Path $DataFolder "MQL5\Experts"
  $dstMq5  = Join-Path $dstExp ($EA + ".mq5")
  $dstEx5  = Join-Path $dstExp ($EA + ".ex5")
  $dstCsv  = Join-Path $DataFolder ("MQL5\Files\OptResults_" + $EA + "_" + $Simbolo + ".csv")
  $FotoPrima = @(("Experts\" + $EA + ".mq5: " + (Foto $dstMq5)), ("Experts\" + $EA + ".ex5: " + (Foto $dstEx5)), ("Files\OptResults_" + $EA + "_" + $Simbolo + ".csv: " + (Foto $dstCsv)))
  foreach($f in $FotoPrima){ Dico ("foto PRIMA  " + $f) }

  # -------------------------------------------------------------------
  #  6. COMPILAZIONE (EA MAI compilato): sentinella PRIMA di scrivere
  # -------------------------------------------------------------------
  Titolo "6. COMPILAZIONE (metaeditor64, invocazione diretta, .ex5 vecchio cancellato prima)"
  New-Item -ItemType Directory -Force -Path $dstExp | Out-Null
  Set-Content -LiteralPath $Sentinella -Value @(("scritto il " + (Get-Date).ToString("yyyy-MM-dd HH:mm:ss",$INV) + " da RIGA_SONDARELATIVO_ESTESA.ps1 (" + $Prova + ")"), $dstMq5, $dstEx5, $dstCsv) -Encoding ASCII
  Copy-Item -LiteralPath $mq5 -Destination $dstMq5 -Force
  Remove-Item -LiteralPath $dstEx5 -Force -ErrorAction SilentlyContinue
  $logC = Join-Path $Work "COMPILAZIONE.log"
  Remove-Item -LiteralPath $logC -Force -ErrorAction SilentlyContinue
  $tComp = Get-Date
  $global:LASTEXITCODE = $null
  & $MeExe ("/compile:" + $dstMq5) ("/log:" + $logC) | Out-Null
  $grezzoMe = $LASTEXITCODE
  $RcMeTxt = "NON LETTO"
  if($null -ne $grezzoMe -and (("" + $grezzoMe).Trim()) -match '^-?\d+$'){ $RcMeTxt = "" + $grezzoMe }
  $battito = 0; $muto = $false
  while($true){
    if((Test-Path -LiteralPath $dstEx5) -and ((Get-Item -LiteralPath $dstEx5).LastWriteTime -ge $tComp)){ break }
    $lr = LeggiTesto $logC
    if(@($lr).Count -gt 0 -and (@($lr) -match 'Result:').Count -gt 0){ break }
    $sec = (New-TimeSpan -Start $tComp -End (Get-Date)).TotalSeconds
    if(@($lr).Count -eq 0 -and $sec -ge 30){ $muto = $true; break }
    if($sec -ge 240){ break }
    if($sec -ge ($battito + 10)){ $battito = [int]$sec; Dico ("   ... aspetto l'.ex5 da " + $battito + "s (tetto 240s): NON interrompere") }
    Start-Sleep -Seconds 2
  }
  $LogRighe = @(LeggiTesto $logC)
  $nErr = -1; $nWar = -1
  foreach($r in $LogRighe){
    $m = [regex]::Match($r, '(?i)(\d+)\s+error[s]?\s*,\s*(\d+)\s+warning')
    if($m.Success){ $nErr = [int]::Parse($m.Groups[1].Value,$INV); $nWar = [int]::Parse($m.Groups[2].Value,$INV); $ResultTxt = $r.Trim() }
  }
  if($nErr -lt 0){ $ResultTxt = "NON TROVATA nel log (fa fede l'.ex5)" }
  $ex5Fresco = ((Test-Path -LiteralPath $dstEx5) -and ((Get-Item -LiteralPath $dstEx5).LastWriteTime -ge $tComp))
  if($ex5Fresco -and $nErr -le 0){
    $itm = Get-Item -LiteralPath $dstEx5
    $wtxt = "warning NON LETTI"; if($nWar -ge 0){ $wtxt = "" + $nWar + " warning" }
    $Compilato = "OK (" + [int]($itm.Length/1024) + " KB, " + $itm.LastWriteTime.ToString("HH:mm:ss",$INV) + "), 0 errors, " + $wtxt
    Dico ("compilato " + $EA + ": " + $Compilato) "Green"
    if($nWar -gt 0){ [void]$Rilievi.Add("la compilazione ha prodotto " + $nWar + " warning: non bloccano, ma vanno letti nel log dentro lo zip."); foreach($r in $LogRighe){ if($r -match '(?i):\s*warning'){ [void]$Rilievi.Add("  warning: " + $r.Trim()) } } }
  }
  else{
    $quanti = "NON LETTI"; if($nErr -ge 0){ $quanti = "" + $nErr }
    $Compilato = "FALLITA (MetaEditor lanciato, nessun .ex5 fresco; errori dal log: " + $quanti + ") -- QUESTO E' IL RISULTATO DEL PASSO: EA nuovo, mai compilato"
    if($muto -or @($LogRighe).Count -eq 0){ $Compilato = "FALLITA -- METAEDITOR MUTO: lanciato e tornato SENZA scrivere ne' log ne' .ex5 (editor aperto, percorso, permessi). NON e' un verdetto sul codice: ricontrollare metaeditor64 chiuso e rifare." }
    Dico ("COMPILAZIONE FALLITA. Prime 30 righe del log:") "Red"
    $k = 0; foreach($r in $LogRighe){ if($r.Trim() -eq ""){ continue }; Write-Host ("      " + $r) -ForegroundColor Red; $k++; if($k -ge 30){ break } }
    throw ("COMPILAZIONE FALLITA: " + $Compilato)
  }

  # LA CACHE DEL TESTER (checklist punto 38): un pass ripescato non
  # chiama OnTester e lascia il CSV monco. Si svuota SOLO Tester\cache.
  $cacheT = Join-Path $DataFolder "Tester\cache"
  if(Test-Path -LiteralPath $cacheT){
    $ncPrima = @(Get-ChildItem -LiteralPath $cacheT -Recurse -File -ErrorAction SilentlyContinue).Count
    Remove-Item (Join-Path $cacheT "*") -Recurse -Force -ErrorAction SilentlyContinue
    $ncDopo  = @(Get-ChildItem -LiteralPath $cacheT -Recurse -File -ErrorAction SilentlyContinue).Count
    $CacheTxt = "prima " + $ncPrima + " file, dopo " + $ncDopo
    if($ncDopo -gt 0){ [void]$Problemi.Add("Tester\cache NON si e' svuotata (" + $CacheTxt + "): un pass ripescato non chiama OnTester e lascia il CSV monco."); Dico ("Tester\cache NON SVUOTATA: " + $CacheTxt) "Red" }
    else{ Dico ("Tester\cache svuotata: " + $CacheTxt) "Green" }
  }
  else{ $CacheTxt = "cartella assente: niente da svuotare"; Dico ("Tester\cache: " + $CacheTxt) "Yellow" }

  # -------------------------------------------------------------------
  #  7. LA CORSA -- il generico, UNA volta, con lo STESSO terminale
  # -------------------------------------------------------------------
  Titolo ("7. LA CORSA " + $Prova + " (generico, Modello 2 OPEN PRICES, FrazioneIS " + $FrazioneIS + ", -Rifai)")
  $tCorsa = Get-Date
  $argv = @("-ExecutionPolicy","Bypass","-File",$drv,
            "-Expert",$EA,
            "-Prova",(Join-Path $Prove $FileProva),
            "-Etichetta",$Prova,
            "-DaQuando",$DaQuando,
            "-Fino",$Fino,
            "-FrazioneIS",("" + $FrazioneIS),
            "-Modello","2",
            "-Rifai",
            "-Deposito",("" + $Deposito),
            "-Terminal",$TermExe,
            "-MetaEditor",$MeExe,
            "-DataFolder",$DataFolder)
  if($SoloControllo){ $argv += "-SoloControllo" }
  Dico ("argv generico: " + ($argv -join " "))
  $global:LASTEXITCODE = $null
  & powershell $argv
  $grezzo = $LASTEXITCODE
  $rc = -1; $rcLetto = $false
  if($null -ne $grezzo -and (("" + $grezzo).Trim()) -match '^-?\d+$'){ $rc = [int](("" + $grezzo).Trim()); $rcLetto = $true }
  if($rcLetto){ $RcGenTxt = "" + $rc } else { $RcGenTxt = "NON LETTO" }
  if($rcLetto -and $rc -ne 0){ [void]$Problemi.Add("il generico e' uscito con codice " + $rc + " (controlli non passati? storico mancante? CSV non prodotto? Il rosso sul *_OOS invece e' ATTESO con FrazioneIS 1.0).") }
  elseif(-not $rcLetto){ [void]$Rilievi.Add("codice di uscita del generico NON LETTO (vuoto su PS 5.1, classe 108): non e' un fallimento e non e' un successo. Il verdetto sta sugli ARTEFATTI DATATI.") }

  if($SoloControllo){
    # l'artefatto datato del giro a vuoto: l'anteprima .ini del generico
    # (SOLO esistenza e data: sul Model mente, punto 96 della checklist).
    $ante = Join-Path $Work ("anteprima_" + $EA + "_" + $Simbolo + ".ini")
    if((Test-Path -LiteralPath $ante) -and ((Get-Item -LiteralPath $ante).LastWriteTime -ge $tCorsa)){
      $AnteprimaTxt = "FRESCA (" + (Get-Item -LiteralPath $ante).LastWriteTime.ToString("HH:mm:ss",$INV) + "): il generico ha passato i suoi controlli. NON aprirla: scrive Model=4 hardcoded, la corsa vera usa Model=2."
      $nIni = @(Get-Content -LiteralPath $ante | Where-Object { $_ -match '^Inp\w+=' }).Count
      $AnteprimaTxt = $AnteprimaTxt + " Righe Inp* in [TesterInputs]: " + $nIni + " (attese " + $INPUT_ATTESI + ")"
      if($nIni -ne $INPUT_ATTESI){ [void]$Problemi.Add("anteprima .ini con " + $nIni + " righe Inp* invece di " + $INPUT_ATTESI + ".") }
    }
    else{ $AnteprimaTxt = "ASSENTE o VECCHIA: il generico NON e' arrivato a scriverla (controlli non passati: leggere l'output qui sopra)"; [void]$Problemi.Add("giro a vuoto: anteprima .ini del generico assente o piu' vecchia dell'avvio: i controlli del generico non sono passati.") }
    Dico ("anteprima: " + $AnteprimaTxt)
  }
  else{
    $csvIS = Join-Path $Results ($EA + "_" + $Simbolo + "_IS_ohlc_" + $Prova + ".csv")
    AnalizzaCsv $csvIS $tCorsa $SoglieSrc
  }
}
catch{
  $Fatale = ("" + $_.Exception.Message)
  Write-Host ""
  Write-Host ("!!! FERMATO: " + $Fatale) -ForegroundColor Red
}

# =====================================================================
#  RACCOLTA + PULIZIA -- SEMPRE, anche quando la corsa si e' fermata.
#  (classe 116: il ripristino NON vive solo nel ramo felice)
# =====================================================================
if($Modo -ne "CORSA" -and $Modo -ne "CONTROLLO"){ [void]$Problemi.Add("BUG INTERNO (punto 79): variabile del modo sovrascritta (" + $Modo + ")."); $Modo = "CORSA"; if($SoloControllo){ $Modo = "CONTROLLO" } }
Titolo "RACCOLTA"
$Pulizia = "niente da pulire (il terminale non e' stato toccato)"
if($DataFolder -ne ""){
  $dstExp = Join-Path $DataFolder "MQL5\Experts"
  $dstMq5 = Join-Path $dstExp ($EA + ".mq5"); $dstEx5 = Join-Path $dstExp ($EA + ".ex5")
  $dstCsv = Join-Path $DataFolder ("MQL5\Files\OptResults_" + $EA + "_" + $Simbolo + ".csv")
  # l'unico residuo che si toglie e' il CSV grezzo NOSTRO rimasto in
  # MQL5\Files (il generico lo sposta; se e' morto prima, resta li' e il
  # prossimo giro lo leggerebbe come fresco). I .mq5/.ex5 della sonda
  # RESTANO e si DICHIARANO (contatore senza ordini, riscritti a ogni corsa).
  $tolto = "nessun CSV grezzo residuo"
  if(Test-Path -LiteralPath $dstCsv){ Remove-Item -LiteralPath $dstCsv -Force -ErrorAction SilentlyContinue; $tolto = "rimosso il CSV grezzo residuo " + $dstCsv }
  $FotoDopo = @(("Experts\" + $EA + ".mq5: " + (Foto $dstMq5)), ("Experts\" + $EA + ".ex5: " + (Foto $dstEx5)), ("Files\OptResults_" + $EA + "_" + $Simbolo + ".csv: " + (Foto $dstCsv)))
  $Pulizia = $tolto + "; nel terminale RESTANO (dichiarati, non cancellati): " + $dstMq5 + " e " + $dstEx5
}
Remove-Item -LiteralPath $Sentinella -Force -ErrorAction SilentlyContinue

$suff = ""
if($Modo -eq "CONTROLLO"){ $suff = "CONTROLLO_" }
$Cart = Join-Path $Dsk ("SONDARELATIVO_EST_" + $Prova + "_" + $suff + $Stamp)
if($Prova -eq ""){ $Cart = Join-Path $Dsk ("SONDARELATIVO_EST_SENZAPROVA_" + $suff + $Stamp) }
New-Item -ItemType Directory -Force -Path $Cart | Out-Null

$nOos = 0
if($Prova -ne "" -and (Test-Path -LiteralPath (Join-Path $Results ($EA + "_" + $Simbolo + "_OOS_ohlc_" + $Prova + ".csv")))){ $nOos = 1 }
if($nOos -gt 0){ [void]$Rilievi.Add("un CSV *_OOS esiste NONOSTANTE la gamba degenere (FrazioneIS " + $FrazioneIS + "): numeri su finestra NON dichiarata, NON leggerli. Nello zip solo come reperto.") }

$sg = $SoglieSrc
$R = New-Object System.Collections.ArrayList
[void]$R.Add("=====================================================================")
[void]$R.Add(" SONDA RELATIVO -- PASSO 0 / ESTENSIONE DELLA GRIGLIA (" + $EA + ")")
[void]$R.Add(" gamba " + $Simbolo + " (si scambia) x metro " + $METRO + " (si legge), " + $Periodo + " -- NESSUN ORDINE -- " + $NCelleAttese + " passate (griglia ESTESA; le " + $NCelleVecchie + " del 04/09 sono dentro)")
[void]$R.Add("=====================================================================")
[void]$R.Add("modo: " + $Modo + "   <- CONTROLLO = giro a vuoto, NON e' il risultato")
[void]$R.Add("data: " + $Avvio.ToString("yyyy-MM-dd HH:mm:ss",$INV) + "   <- ORA DI AVVIO, non di fine. MISURATO il 04/09: 49 passate M5 = ~30 s di tester, quindi 90 ~= 1 minuto piu' gli avvii del terminale")
[void]$R.Add("pin:  " + $Pin)
[void]$R.Add("prova: " + $Prova + " = " + $FileProva)
[void]$R.Add("finestra: " + $DaQuando + " -> " + $Fino + "  (UNA TRANCHE, FrazioneIS " + $FrazioneIS + ")")
[void]$R.Add("banco: MODELLO 2 (SOLO PREZZI DI APERTURA): il segnale nasce su barra chiusa e non si apre niente. I CSV portano il suffisso _ohlc (marca del generico per ogni modello non-tick). Deposito " + $Deposito + " (inerte).")
[void]$R.Add("terminale: " + $TermScelto + "   [" + $TermCrit + "]   dati: " + $DataFolder)
[void]$R.Add("compilazione: " + $Compilato + "   <- EA NUOVO: se e' FALLITA, QUESTO e' il risultato del passo")
[void]$R.Add("riga Result del log: " + $ResultTxt)
[void]$R.Add("codice di uscita di metaeditor64: " + $RcMeTxt + "   (NON LETTO non e' un fallimento: fa fede l'.ex5 e il log)")
[void]$R.Add("versione letta dal #property: " + $VersioneTxt + " (attesa " + $VERSIONE_ATTESA + ")")
[void]$R.Add("autotest nel sorgente: " + $AutoSrcTxt + " (attesi " + $AUTOTEST_BLOCCHI_ATTESI + ")")
[void]$R.Add("colonne: " + $NStatsTxt + " (attese 100)")
[void]$R.Add("input: " + $InputTxt + " (attesi " + $INPUT_ATTESI + ", tutti pinnati nel prova)")
[void]$R.Add("grep contatore puro: " + $GrepTxt)
[void]$R.Add("include: " + $IncludeTxt)
[void]$R.Add("celle: " + $CelleTxt)
[void]$R.Add("gemellaggio 4 prova: " + $GemelliTxt)
[void]$R.Add("tetto barre: " + $TettoTxt)
[void]$R.Add("cache tester: " + $CacheTxt)
[void]$R.Add("codice di uscita del generico: " + $RcGenTxt)
[void]$R.Add("anteprima .ini (solo CONTROLLO): " + $AnteprimaTxt)
[void]$R.Add("csv *_OOS trovati: " + $nOos + " (attesi 0: gamba OOS degenere; il rosso del generico su quel file e' ATTESO e NON si rilancia)")
[void]$R.Add("foto PRIMA dei file del terminale:")
foreach($f in $FotoPrima){ [void]$R.Add("   " + $f) }
[void]$R.Add("foto DOPO:")
foreach($f in $FotoDopo){ [void]$R.Add("   " + $f) }
[void]$R.Add("pulizia: " + $Pulizia)
[void]$R.Add("")
[void]$R.Add("--- I CRITERI DI LETTURA (dai #define del sorgente al pin, uguali alla pagina; scritti PRIMA dei numeri) ---")
[void]$R.Add("  " + $DefineTxt)
[void]$R.Add("  VERDETTO PER LATO = ALTOPIANO, NON PICCO: esiste un blocco 2x2 di celle CONTIGUE (N adiacenti x sigma adiacenti)")
[void]$R.Add("  in cui C1 (somma dei lati) + C3 (lato) + C5 (lato) + C6 (totale) + C8 (totale) stanno in piedi INSIEME?")
[void]$R.Add("    VIVO    = almeno un blocco 2x2 tutto di celle VIVE (C6 <= " + (Fmt2 $PAGINA_C6_SOSP) + "% e tenuta >= " + (Fmt2 $PAGINA_C8_TENUTA) + " barre dentro)")
[void]$R.Add("    SOSPESO = blocchi 2x2 in piedi solo con celle SOSPESE dentro (C6 " + (Fmt2 $PAGINA_C6_SOSP) + "-" + (Fmt2 $PAGINA_C6_KO) + "% o tenuta < " + (Fmt2 $PAGINA_C8_TENUTA) + ")")
[void]$R.Add("    NO      = nessun blocco 2x2: le celle vive, se ci sono, sono ISOLATE = rumore. Una cella sola non e' una risposta.")
[void]$R.Add("  CLAUSOLA SEVERA: un solo collaudo fallito su una sola delle " + $NCelleAttese + " righe = NON LEGGIBILE, nessun verdetto.")
[void]$R.Add("  NESSUNA CELLA VIENE PROMOSSA: la cella di riferimento (N=" + $RIF_N + ", sigma=" + (Fmt2 $RIF_SIGMA) + ") si stampa perche' e' la domanda-sonda, non perche' e' la migliore.")
[void]$R.Add("")
[void]$R.Add("--- I COLLAUDI (si leggono PRIMA dei numeri; su TUTTE le righe) ---")
if($null -ne $RigheGriglia){
  $r0 = $RigheGriglia[0]
  [void]$R.Add("  righe nel CSV: " + (FmtN $CsvRighe) + " (attese " + $NCelleAttese + ") | CSV scritto alle " + $CsvOraTxt + " (FRESCO: piu' recente dell'avvio della corsa)")
  [void]$R.Add("  autotest: " + $r0.AutoKo + " falliti su " + $r0.AutoBl + " blocchi (attesi 0/" + $AUTOTEST_BLOCCHI_ATTESI + ") | occupato ALTRO lato (T6): " + (FmtN $r0.AltroLato) + " (atteso 0) | sotto 60 s: " + (Fmt2 $r0.Sotto60) + "% (atteso 0,00)")
  [void]$R.Add("  punto indice: " + (Fmt3 $r0.PuntoIdx) + " (atteso 1,000) | spread misurato: " + (Fmt2 $r0.Spread) + " (atteso " + (Fmt2 $SpreadAtteso) + ") | soglia C3: " + (Fmt2 $r0.SogliaC3) + " (attesa " + (Fmt2 $SogliaC3Attesa) + ") | campioni troncati: " + $r0.Troncati + " (atteso 0)")
  [void]$R.Add("  ATR divergenza vs iATR: " + ([double]$r0.AtrDiv).ToString("0.0000",$INV) + "% (atteso ~0 con SMA del TR) | ATR mediano " + (Fmt2 $r0.AtrMed) + " punti idx")
  [void]$R.Add("  storico: prima barra GAMBA " + ([DateTime]'1970-01-01').AddSeconds($r0.GambaEpoch).ToString("yyyy-MM-dd HH:mm",$INV) + " | METRO " + ([DateTime]'1970-01-01').AddSeconds($r0.MetroEpoch).ToString("yyyy-MM-dd HH:mm",$INV) + " (il metro NON deve partire dopo la gamba)")
  [void]$R.Add("  barre valutate " + (FmtN $r0.BarreVal) + " | fuori finestra " + (FmtN $r0.BarreFuori) + " | saltate per dati " + (FmtN $r0.BarreSal) + " | giorni contati " + (FmtN $r0.Giorni))
  [void]$R.Add("  DUE FEED: metro mancante sul segnale " + (FmtN $r0.MetroManc) + " | valutazioni perse per buco " + (FmtN $r0.PerseBuco) + " (il COSTO della regola stretta) | solo metro " + (FmtN $r0.SoloMetro) + " | z non calcolabile " + (FmtN $r0.ZNon))
  [void]$R.Add("  C2 giorni spaiati: " + (FmtN $r0.Spaiati) + " = " + (Fmt2 $r0.SpaiPct) + "% (oltre " + (Fmt2 $PAGINA_C2_SPAIATI) + "% = rifare filtrando, e dichiarare)")
  [void]$R.Add("  diagnostica C2 (v1.02): Giorni Festa Metro " + (FmtN $r0.GFesta) + " (festivita' del metro DENTRO la finestra della sonda, ora esclusa dal numeratore C2) | Giorni Metro Zero Calendario " + (FmtN $r0.GZeroCal) + " (vecchio criterio v1.01, tenuto come controllo, atteso 0 su un metro quasi-24h)")
  [void]$R.Add("  FIX T12 (v1.03): Chiuse Zero Barre " + (FmtN $r0.ChiuseZero) + " (atteso 0, prima riga; collaudato su TUTTE le righe, un fallimento sta nei PROBLEMI) | Ingressi Barra Reale Fuori " + (FmtN $r0.IngrFuori) + " (prima riga; la SOMMA sulle " + (FmtN $CsvRighe) + " celle sta nei RILIEVI qui sotto: se e' 0 mentre il collaudo T12 passa comunque, il fix non e' mai stato messo alla prova in questa corsa)")
  [void]$R.Add("  (i valori qui sopra sono della prima riga; i collaudi sono stati verificati su TUTTE le " + (FmtN $CsvRighe) + " righe: un fallimento sta nei PROBLEMI)")
}
else{ [void]$R.Add("  SENZA NUMERI (corsa non girata, CSV non prodotto o non letto: vedi PROBLEMI / FERMATO)") }
[void]$R.Add("")
[void]$R.Add("--- LA CELLA DI RIFERIMENTO (N=" + $RIF_N + ", sigma=" + (Fmt2 $RIF_SIGMA) + "): la domanda-sonda del GIACIMENTO sez. 8 ---")
if($null -ne $Cella){
  $c = $Cella
  [void]$R.Add("  eseguibili/giorno: LONG " + (Fmt3 $c.EseGL) + " | SHORT " + (Fmt3 $c.EseGS) + " | SOMMA " + (Fmt3 $c.EseGT) + " (C1 >= " + (Fmt2 $sg.C1) + ": esito " + $c.C1 + ") | grezzi L/S " + (FmtN $c.GrezL) + "/" + (FmtN $c.GrezS) + ", eseguibili " + (FmtN $c.EseL) + "/" + (FmtN $c.EseS) + " su " + (FmtN $c.Giorni) + " giorni")
  [void]$R.Add("  MFE mediana: LONG " + (Fmt2 $c.MfeL) + " pti = " + (Fmt2 $c.MfeSpL) + " x spread | SHORT " + (Fmt2 $c.MfeS) + " pti = " + (Fmt2 $c.MfeSpS) + " x spread   (C3 soglia " + (Fmt2 $sg.SogliaC3) + " = 3x " + (Fmt2 $SpreadAtteso) + "; esiti L/S " + $c.C3L + "/" + $c.C3S + ": 0 scarto, 1 passa, 2 largo)")
  [void]$R.Add("  MAE mediana: LONG " + (Fmt2 $c.MaeL) + " | SHORT " + (Fmt2 $c.MaeS) + " pti (pavimento SL) | RR: L " + (Fmt3 $c.RrL) + " / S " + (Fmt3 $c.RrS) + " (C5 >= " + (Fmt2 $sg.C5) + ": esiti " + $c.C5L + "/" + $c.C5S + ") | win rate necessario L " + (Fmt2 $c.WrL) + "% / S " + (Fmt2 $c.WrS) + "%")
  [void]$R.Add("  C6 non convergute: L " + (Fmt2 $c.NonConvL) + "% / S " + (Fmt2 $c.NonConvS) + "% / TOTALE " + (Fmt2 $c.NonConvT) + "% (chiuse " + (FmtN $c.ChL) + "/" + (FmtN $c.ChS) + ", convergute " + (FmtN $c.CvL) + "/" + (FmtN $c.CvS) + ", fine corsa escluse " + (FmtN $c.FineCorsa) + "; esito " + $c.C6 + ": 0 scarto, 1 sospeso, 2 passa)")
  [void]$R.Add("  C8 tenuta mediana: L " + (Fmt2 $c.TenL) + " / S " + (Fmt2 $c.TenS) + " / due lati " + (Fmt2 $c.TenMedT) + " barre (esito " + $c.C8 + ") | C7 max eseguibili in un giorno L/S/tot " + (FmtN $c.MaxGL) + "/" + (FmtN $c.MaxGS) + "/" + (FmtN $c.MaxGT) + " -> rischio aperto " + (Fmt2 $c.Rischio) + "% vs cap " + (Fmt2 $sg.C7CAP) + "% (cap necessario: " + $c.C7 + ")")
  [void]$R.Add("  giorni con >= 2 eseguibili " + (FmtN $c.G2) + " | giorni a zero " + (FmtN $c.G0))
  [void]$R.Add("  stato della cella: LONG " + (StatoCella $c "L" $sg) + " | SHORT " + (StatoCella $c "S" $sg) + "   (V viva, S sospesa, . no)")
}
else{ [void]$R.Add("  n/d") }
[void]$R.Add("")
[void]$R.Add("--- LA MAPPA 10x9 PER LATO (V = C1+C3+C5+C6+C8 in piedi; S = in piedi con C6 25-40% o tenuta < 12; . = no). Le prime 7 righe x 7 colonne sono la mappa del 04/09 ---")
foreach($lato in @("L","S")){ if($Mappa.ContainsKey($lato) -and $null -ne $Mappa[$lato]){ [void]$R.Add($Mappa[$lato]); [void]$R.Add("") } }
[void]$R.Add("VERDETTO LONG : " + $VerdettoL)
[void]$R.Add("VERDETTO SHORT: " + $VerdettoS)
[void]$R.Add("")
[void]$R.Add("--- LE " + $NCelleAttese + " CELLE (ordinate per N, poi sigma; mai aggregate). Quelle con N <= 40 E sigma <= 1,65 sono le " + $NCelleVecchie + " del 04/09 ---")
[void]$R.Add(("{0,3} {1,5} {2,7} {3,7} {4,7} {5,7} {6,7} {7,6} {8,6} {9,7} {10,7} {11,4} {12,3} {13,3} {14,3} {15,3} {16,3} {17,3}" -f "N","sigma","ese/ggL","ese/ggS","ese/ggT","MFE L","MFE S","RR L","RR S","nonCnv%","ten.med","mx/g","C1","C3L","C3S","C6","C8","L/S"))
if($null -ne $RigheGriglia){
  foreach($rw in ($RigheGriglia | Sort-Object N, Sigma)){
    [void]$R.Add(("{0,3} {1,5} {2,7} {3,7} {4,7} {5,7} {6,7} {7,6} {8,6} {9,7} {10,7} {11,4} {12,3} {13,3} {14,3} {15,3} {16,3} {17,3}" -f $rw.N, (Fmt2 $rw.Sigma), (Fmt3 $rw.EseGL), (Fmt3 $rw.EseGS), (Fmt3 $rw.EseGT), (Fmt2 $rw.MfeL), (Fmt2 $rw.MfeS), (Fmt2 $rw.RrL), (Fmt2 $rw.RrS), (Fmt2 $rw.NonConvT), (Fmt2 $rw.TenMedT), (FmtN $rw.MaxGT), $rw.C1, $rw.C3L, $rw.C3S, $rw.C6, $rw.C8, ((StatoCella $rw "L" $sg) + "/" + (StatoCella $rw "S" $sg))))
  }
}
[void]$R.Add("")
[void]$R.Add("--- LE NOTE CHE VANNO LETTE INSIEME AI NUMERI ---")
[void]$R.Add("  - QUESTA SONDA NON DICE SE IL MOTORE GUADAGNA: conta OCCASIONI e misura TAGLIA, GEOMETRIA, CONVERGENZA, TENUTA.")
[void]$R.Add("    Il merito e' a tick, dopo, con >= 150 operazioni IS (Emendamento della Finestra, punto A).")
[void]$R.Add("  - NON MISURA LA CO-INTEGRAZIONE: C6 e' la sua approssimazione operativa. Se C6 e' alto, e' MOMENTUM TRAVESTITO.")
[void]$R.Add("  - IL DAX DALLE 17 SERVER IN POI E' FUORI DAL SUO CASH e lo spread quasi raddoppia (2,80 = ora peggiore): C3 usa la")
[void]$R.Add("    CLAUSOLA SEVERA (mediana oraria PEGGIORE), non la mediana di sessione 1,6-1,7 citata nel GIACIMENTO.")
[void]$R.Add("  - C9 GRADIENTE M5/M15: NON si legge in questa corsa. I due M15 hanno dato SOSPESO su entrambi i lati il 04/09 e")
[void]$R.Add("    sono CHIUSI: questa estensione gira solo su M5. Il confronto fra TF resta quello dei referti del 04/09.")
[void]$R.Add("  - PERCHE' QUESTA CORSA ESISTE: il 04/09 l'altopiano VIVO si appoggiava al BORDO della griglia su ENTRAMBI gli assi")
[void]$R.Add("    (N=40 e sigma=1,65 erano i massimi misurati), quindi il CENTRO dell'altopiano NON era determinabile. Qui si guarda")
[void]$R.Add("    se l'altopiano CONTINUA (e allora il centro va rifatto) o se FINISCE (e allora la scelta del 04/09 regge).")
[void]$R.Add("    Nessuna delle due uscite e' un fallimento. Decisione di Claudio del 04/09 (D4 della proposta a tick reali).")
[void]$R.Add("  - E IL BORDO SI SPOSTA, NON SPARISCE: se un blocco 2x2 VIVO tocca N=55 o sigma=1,95, la griglia va estesa ANCORA")
[void]$R.Add("    prima di congelare una cella. Il rilievo si riscrive uguale, un gradino piu' in la'.")
[void]$R.Add("  - PREVISIONE SCRITTA PRIMA: N e sigma piu' grandi RIDUCONO le occasioni; una parte delle celle nuove dovrebbe morire")
[void]$R.Add("    sul PAVIMENTO C1 (2,00/giorno) per PORTATA, non per geometria. Se muore cosi', il bordo vecchio non tagliava niente.")
[void]$R.Add("  - TETTO BARRE (M5): la finestra EFFETTIVA la dice la riga 'tetto barre' qui sopra; C1 resta per-giorno sul denominatore CONTATO.")
[void]$R.Add("  - UN SOLO BROKER, UN SOLO REGIME (toro). FORMA UNILATERALE: a due gambe i numeri di C3 andrebbero RADDOPPIATI.")
[void]$R.Add("  - Nessun per-trade e nessun CSV riga-per-segnale: corsa in ottimizzazione, zero ordini. I numeri stanno SOLO nelle 100 colonne OPTFRAME.")
[void]$R.Add("")
if($FrazioneIS -ge 1.0){ [void]$R.Add("AVVISO: FrazioneIS 1.0 -> la gamba 'OOS' del generico e' DEGENERE (0 giorni). Il rosso del generico sul CSV *_OOS e' ATTESO: NON rilanciare."); [void]$R.Add("") }
if($Fatale -ne ""){ [void]$R.Add("!!! FERMATO: " + $Fatale); [void]$R.Add("") }
[void]$R.Add("PROBLEMI: " + $Problemi.Count)
foreach($p in $Problemi){ [void]$R.Add("  - " + $p) }
[void]$R.Add("RILIEVI: " + $Rilievi.Count)
foreach($p in $Rilievi){ [void]$R.Add("  - " + $p) }
[void]$R.Add("")
[void]$R.Add('COME SI RIPRENDE: dalla pagina righe/RIGA_SONDARELATIVO_ESTESA_DA_MANDARE.md, NON da questa riga: $Pin nasce dentro il blocco e non sopravvive.')

$refPath = Join-Path $Cart ("REFERTO_SONDARELATIVO_EST_" + $Prova + ".txt")
if($Prova -eq ""){ $refPath = Join-Path $Cart "REFERTO_SONDARELATIVO_EST.txt" }
Set-Content -LiteralPath $refPath -Value ($R -join "`r`n") -Encoding ASCII
Write-Host ($R -join "`r`n")

foreach($f in @("COMPILAZIONE.log")){ $s = Join-Path $Work $f; if(Test-Path -LiteralPath $s){ Copy-Item -LiteralPath $s -Destination $Cart -Force } }
if($Prova -ne ""){
  $sp = Join-Path $Prove $FileProva
  if(Test-Path -LiteralPath $sp){ Copy-Item -LiteralPath $sp -Destination $Cart -Force }
  foreach($leg in @("IS","OOS")){
    $f = Join-Path $Results ($EA + "_" + $Simbolo + "_" + $leg + "_ohlc_" + $Prova + ".csv")
    if(Test-Path -LiteralPath $f){ Copy-Item -LiteralPath $f -Destination $Cart -Force }
  }
}
$zip = $Cart + ".zip"
Remove-Item -LiteralPath $zip -Force -ErrorAction SilentlyContinue
Compress-Archive -Path (Join-Path $Cart "*") -DestinationPath $zip -Force
Write-Host ""
Write-Host ("CARTELLA: " + $Cart) -ForegroundColor Green
Write-Host ("ZIP DA MANDARE: " + $zip) -ForegroundColor Green
if($Prova -ne ""){ Write-Host ("FILE ATTESI NELLO ZIP: REFERTO_SONDARELATIVO_EST_" + $Prova + ".txt + COMPILAZIONE.log + il prova + 1 CSV OPTFRAME (" + $EA + "_" + $Simbolo + "_IS_ohlc_" + $Prova + ".csv, " + $NCelleAttese + " righe = le " + $NCelleAttese + " passate, 100 colonne + gli input accodati dal tester). In CONTROLLO: solo referto + COMPILAZIONE.log + prova.") -ForegroundColor Gray }
else{ Write-Host "FILE ATTESI NELLO ZIP: il solo REFERTO_SONDARELATIVO_EST.txt (fermato prima di scegliere il prova)" -ForegroundColor Gray }
Write-Host ("CSV *_OOS trovati: " + $nOos + " (attesi 0: gamba OOS degenere; il numero sta ANCHE nel referto). Il rosso del generico su quel file e' ATTESO: NON rilanciare.") -ForegroundColor Gray

if($Fatale -ne ""){ Write-Host "ESITO: FERMATO" -ForegroundColor Red; exit 1 }
if($Problemi.Count -gt 0){ Write-Host "ESITO: COMPLETATO CON PROBLEMI" -ForegroundColor Yellow; exit 1 }
Write-Host ("ESITO: " + $Modo + " COMPLETATO") -ForegroundColor Green
exit 0
