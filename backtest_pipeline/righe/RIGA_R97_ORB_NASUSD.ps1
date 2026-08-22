# =====================================================================
#  MARCATORE_RIGA_R97_v2
#  (v2, 22/08/2026, dopo il verificatore: sosta svuotata a ogni giro,
#   seconda misura della conversione tirata fuori dal ramo in cui era
#   irraggiungibile, etichetta "CONVERSIONE MISURATA" che non mente piu',
#   e il referto dichiara che i per-trade delle celle coprono SOLO l'OOS.)
#  RIGA_R97_ORB_NASUSD.ps1  --  R97: lo stop all'estremo opposto del
#  range (famiglia vincitrice di R88 sul Dow) TRASFERITO su NASUSD, M5
# ---------------------------------------------------------------------
#  CRITERI: backtest_pipeline\risultati_archivio\R97_CRITERI.md
#  >>> FIRMATI da Claudio il 21/08/2026 ("FIRMIAMO R97, POI ANALIZZIAMO
#      QUESTI EA BENE"), a numeri di R97 mai visti. Questa riga NON
#      cambia i criteri: li traduce in file eseguibili.
#
#  DA DOVE NASCE QUESTO SCRIPT, dichiarato: e' RIGA_R96_APERTURA_USA.ps1
#  v2 adattata. Il punto 9 della checklist dice che una riscrittura non
#  puo' perdere le funzioni di sicurezza del gemello: sono state
#  riportate TUTTE, una per una -- guardia MT5/MetaEditor, pin di
#  $EABranch nei DUE script che lo hanno scritto fisso, install
#  dell'include ABTG_PausaGuardian.mqh, [Charts] MaxBars con gate sullo
#  stato finale, diff A COPPIE dei file prova, magic del gate diversi da
#  quelli della griglia, sosta con nome proprio prima dei gate, funzioni
#  sopra il try, MODO nel nome della cartella e nel referto, tre radici
#  di log, \r? davanti a ogni $ multilinea, raccolta SEMPRE.
#
#  COSA FA, in ordine, e DA SOLA:
#    0. si rifiuta di partire se MT5 O MetaEditor sono aperti (checklist 7 e 39)
#    1. scarica AL PIN driver, file prova, il sorgente .mq5 e l'include
#       - GATE DI VERSIONE sul .mq5: deve dichiarare #property version
#         "1.02". Se no e' cache CDN o branch sbagliato -> STOP.
#       - INSTALLA ABTG_PausaGuardian.mqh, che nessun driver installa
#         (checklist 33-bis, pagato DUE volte: 21/08 nel tester e 22/08
#         sui terminali che operano)
#       - DIFF A COPPIE dei file prova: 43 righe vive MISURATE
#         sull'artefatto, e le righe che differiscono devono essere
#         ESATTAMENTE quelle dell'esperimento
#    2. FASE COMPILA: metaeditor64 invocato DIRETTO (& $Me "/compile:.."
#       "/log:..") -- MAI Start-Process con ArgumentList pre-quotato: sui
#       path con spazi torna rc=0 SENZA compilare (pagato il 22/08). Il
#       verdetto e' il LastWriteTime del .ex5 PRIMA/DOPO, non una
#       finestra di minuti (checklist 54).
#    3. PASSO 0-A: barre M1+M5 di NASUSD dal broker, -SenzaTick.
#       I TICK NON si riscaricano: sono gia' MISURATI e agli atti
#       (NASUSD 164.636.788 dal 2024.09.26, REFERTO_R83_R84 riga 620).
#    4. PASSO 0-B -- IL GATE FIRMATO DELLA CONVERSIONE (criteri par. 3).
#       "Prima di lanciare una sola passata si misura quanti PUNTI MT5
#        valgono 1 punto indice su NASUSD a BCM."
#       COME LO MISURA, senza inventare artefatti nuovi: due passate
#       SINGOLE gemelle derivate dal file prova R97-rif, con
#       InpSLMode=2 (FIXED) e InpVerbose=1. In FIXED il sorgente fa
#       sl = entry - InpSLFixedPts*_Point (ABTG_ORB_Ottimizzato v1.02,
#       SLforLong): e' ESATTAMENTE la stessa moltiplicazione che fa il
#       buffer di R97b/c (SLBuffer() = InpSLBufferPts*_Point). Dalla
#       riga di log "BUY STOP @ X SL Y" si legge (X-Y) e si ricava
#          _Point = (X-Y)/InpSLFixedPts     fattore = 1/_Point
#       cioe' quanti punti MT5 vale 1 punto indice. MISURATO sul
#       terminale di Claudio, sul simbolo vero, nel codice vero.
#       CONTROLLO INDIPENDENTE (seconda misura, altro meccanismo): i
#       decimali della colonna price del per-trade, che il sorgente
#       scrive con DoubleToString(...,_Digits) -> 10^digits.
#       Le due misure devono dire lo STESSO numero.
#       Se la sonda non piazza ordini (lo stop FIXED e' il piu' stretto del
#       round, quindi il LOTTO piu' grande: puo' essere rifiutato per
#       margine) c'e' -RischioSonda, che abbassa il rischio SOLO nella
#       sonda -- il lotto non entra nella geometria che il gate misura.
#       >>> SE IL FATTORE NON E' MISURABILE, LA CORSA NON PARTE.
#       >>> SE IL FATTORE NON E' 100, LA CORSA NON PARTE LO STESSO: i
#           file prova scrivono InpSLBufferPts=500 perche' su U30USD
#           100 punti = 1 punto indice, cioe' 5 PUNTI INDICE. Con un
#           altro fattore quel 500 vorrebbe dire un'altra cosa, ed e'
#           l'errore di fattore DIECI gia' pagato in R88. In quel caso
#           il referto scrive il numero misurato e il valore corretto,
#           e si torna dal verificatore: questa riga NON riscrive da
#           sola una cella firmata.
#    5. PASSO 0-C: sulle STESSE due passate, i gate di sempre --
#       G1 per-trade esiste, e' di ADESSO ed e' popolato
#       G2 prima operazione entro il limite -> i dati coprono la finestra
#       G3 i due gemelli sono identici -> il banco e' pulito
#    6. la catena dei 4 file prova, UNO ALLA VOLTA (una macchina, un lavoro)
#    7. raccolta SEMPRE: cartella sul Desktop + zip, coi numeri attesi
#       dichiarati PRIMA. Tutto cio' che la raccolta usa nasce PRIMA del
#       try che puo' fallire (checklist 41-bis e 48, funzioni comprese).
#
#  QUELLO CHE NON FA, dichiarato:
#    - non giudica nessun numero: produce i CSV, li conta, e mette a
#      referto il fattore di conversione
#    - NON lancia la cella R97d (TP 1:1): NON E' FIRMATA (la firma dice
#      "resta ESCLUSA per ora"). Esiste lo switch -ConD, spento di
#      default, e se acceso il referto lo scrive in chiaro.
#    - non tocca nessuna sedia viva. In particolare NON tocca il magic
#      770611 (ABTG_ORB_Ottimizzato VIVO sul Dow, stesso EA!): R97 usa
#      magic vergini del blocco 7797xx e cancella SOLO i per-trade dei
#      propri magic, per nome, uno per uno.
#    - non tocca niente di R88 (altro simbolo, altri magic, altri CSV)
#    - non ammazza un lavoro in corso allo scadere di -OreMax: smette
#      solo di iniziarne di nuovi (checklist 19)
#
#  LA RIGA CHE SI INCOLLA (blocco INTERO, un comando solo - checklist 21).
#  <PIN> = il commit che contiene QUESTO file: e' l'hash dato in chat.
#
#  & { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
#      if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
#      $pin='<PIN>'; $p="$env:USERPROFILE\RIGA_R97.ps1"; Remove-Item $p -EA SilentlyContinue;
#      irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_R97_ORB_NASUSD.ps1" -OutFile $p;
#      if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_R97_v2' -Quiet)){ throw 'SCRIPT VECCHIO' };
#      $global:LASTEXITCODE=0; & $p -Pin $pin; if($LASTEXITCODE -ne 0){ Write-Host 'ESITO: PARZIALE O FERMO - leggi il REFERTO' } }
#
#  GIRO A VUOTO (dieci secondi, nessuna passata, nessun MT5 che opera):
#    ... & $p -Pin $pin -SoloControllo
#  Il giro a vuoto controlla ESATTAMENTE gli stessi file prova che
#  girano nella corsa vera. Non c'e' un secondo artefatto (checklist 33).
# =====================================================================
param(
  # -Pin NON ha default: un default silenzioso ("lavoro") farebbe girare la
  #  punta del branch spacciandola per un commit congelato. Meglio morire.
  [string]$Pin       = "",
  [double]$OreMax    = 8.0,        # oltre questo NON si iniziano nuovi file
  [switch]$Rifai,
  [switch]$SoloControllo,
  [switch]$ConD,                   # aggiunge la cella R97d, NON FIRMATA
  [double]$RischioSonda = 0,       # SOLO per la sonda del PASSO 0. 0 = lascia
                                   #   quello del file prova (1,00%). Serve se
                                   #   la sonda non piazza ordini: con lo stop
                                   #   stretto del modo FIXED il lotto e' il
                                   #   piu' grande di tutto il round e puo'
                                   #   essere rifiutato per margine. NON tocca
                                   #   le celle firmate, e il referto lo scrive.
  [switch]$SaltaPasso0             # SOLO per rilanciare una coda gia' gatata.
                                   #   Se lo usi, il referto lo scrive in rosso
                                   #   E il fattore di conversione NON c'e'.
)
$ErrorActionPreference = "Stop"
[Threading.Thread]::CurrentThread.CurrentCulture   = [Globalization.CultureInfo]::InvariantCulture
[Threading.Thread]::CurrentThread.CurrentUICulture = [Globalization.CultureInfo]::InvariantCulture
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$INV = [Globalization.CultureInfo]::InvariantCulture

$Avvio = Get-Date
$Stamp = $Avvio.ToString("yyyyMMdd_HHmm", $INV)
$Dsk   = Join-Path $env:USERPROFILE "Desktop"
$Work  = Join-Path $env:USERPROFILE "abtg_r97"
$Prove = Join-Path $Work "prove"
$Logs  = Join-Path $Work "log_r97"
$SrcDir= Join-Path $Work "src_motori"
$RawPin= "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$Pin"

$Ea       = "ABTG_ORB_Ottimizzato"
$VersioneAttesa = "1.02"      # criteri par. 0: e' l'EA di R88, non un altro
$Sym      = "NASUSD"
$Periodo  = "M5"
$DaQuando = "2024.09.26"      # MISURATO: muro dei tick di BCM su NASUSD
$Fino     = "2026.06.30"      # come R88
$Modello  = 4                 # TICK REALI: i numeri di R97 vanno confrontati
                              #  con quelli di R88, che sono a tick reali. Uno
                              #  scan OHLC non sarebbe confrontabile, e la
                              #  finestra e' corta (16 passate).
$Deposito = 100000            # criteri par. 2: per confrontare con R88 alla pari
$SpreadIni= 0                 # 0 = spread CORRENTE, ma SCRITTO nell'ini invece
                              #     che lasciato allo stato nascosto del
                              #     terminale. NON e' uno stress di spread.
$CelleAttese = 2              # per file, per finestra: le due passate gemelle

$MagicA   = 779700            # PASSO 0, passata A
$MagicB   = 779701            # PASSO 0, passata B (gemella di controllo)
#  I magic della GRIGLIA stanno nei file prova (779710/11, 779720/21,
#  779730/31, 779740/41, e 779750/51 per la R97d non firmata) e NON
#  coincidono mai con quelli del gate: se le due fasi condividessero il
#  magic, le passate di ottimizzazione riscriverebbero il per-trade su
#  cui il gate ha dato il via libera (checklist 41, pagato in R82).
$MagicVietati = @(770611,770601,770201)
#  770611 = ABTG_ORB_Ottimizzato VIVO sul Dow: E' LO STESSO EA DI QUESTO
#           ROUND. Se un file prova lo nominasse, i per-trade della sedia
#           in campo verrebbero riscritti dal tester.
#  770601 = ABTG_ORB (versione corso).  770201 = Nasdaq_Apertura_US (spenta).

#--- IL LIMITE DEL GATE G2. La finestra parte dal 2024.09.26; un motore
#    che opera all'apertura USA tutti i giorni deve aver tradato entro i
#    primi tre mesi. Se la prima operazione e' oltre, i dati non coprono
#    l'inizio della finestra.
$LimiteG2 = "2024.12.31"

#--- RIGHE VIVE ATTESE nei file prova. MISURATA il 22/08/2026 su tutti e
#    cinque con `grep -vE '^\s*(#|$)' | wc -l`: 3 direttive @ + 40
#    parametri = 43. NON scritta a memoria (checklist 40-bis).
$RigheAttese = 43

#--- IL FATTORE ATTESO E PERCHE'. I file prova di R97b/c scrivono
#    InpSLBufferPts=500 perche' su U30USD 100 punti MT5 = 1 punto indice
#    (MISURATO: R55b riga 25), quindi 500 punti = 5 PUNTI INDICE, che e'
#    la cella regina di R88. Su NASUSD questo numero il PASSO 0-B lo
#    MISURA: se non e' 100, il 500 scritto nei file vuol dire un'altra
#    cosa e la corsa non parte.
$FattoreAtteso     = 100.0
$BufferIndiceAtteso= 5.0     # punti INDICE della cella R88b, non punti MT5

#--- TUTTO CIO' CHE LA RACCOLTA USA NASCE QUI, PRIMA DEL try (checklist 41-bis),
#    FUNZIONI COMPRESE (checklist 48: in PowerShell una `function` non e'
#    dichiarativa, e' un'istruzione: se il flusso non ci passa sopra, il nome
#    non esiste, e la raccolta esplode proprio nella corsa fermata da un gate).
$Risultati = Join-Path $Work "risultati_prove"
$Comune    = Join-Path $env:APPDATA "MetaQuotes\Terminal\Common\Files"
$Sosta     = Join-Path $Work "sosta"
$Passo0    = @{ Fatto=$false; PrimaData=""; UltimaData=""; N=0; Giorni=0.0;
                Gemelli="NON MISURATO"; Minuti=0.0; LogLetti=0;
                Ordini=0; DistMediana=0.0; Fattore=0.0; FattoreGrezzo=0.0;
                Digits=-1; FattoreDaDigits=0.0; PtsGate=0.0;
                Conversione="NON MISURATA" }
$Storico   = @{ Eseguito=$false; Esito="NON ESEGUITO" }
$Problemi = New-Object System.Collections.ArrayList
$Note     = New-Object System.Collections.ArrayList
$Fatale   = ""
$nAnt     = -1        # -1 = non misurato (checklist 41-bis)
$VersioneLetta = "NON LETTA"

function Ora(){ return (Get-Date).ToString("HH:mm:ss", $INV) }
function Dico($t,$c="Gray"){ Write-Host ("[" + (Ora) + "] " + $t) -ForegroundColor $c }
function Titolo($t){ Write-Host ""; Write-Host ("=== " + $t + " ===") -ForegroundColor Cyan }

function Scarica($url,$dest,$marcatore){
  Remove-Item -LiteralPath $dest -Force -ErrorAction SilentlyContinue
  Invoke-WebRequest -Uri $url -OutFile $dest -UseBasicParsing -ErrorAction Stop
  if(-not (Test-Path -LiteralPath $dest)){ throw ("scarico fallito: " + $url) }
  if($marcatore -ne "" -and -not (Select-String -LiteralPath $dest -SimpleMatch -Pattern $marcatore -Quiet)){
    throw ("file scaricato SENZA il marcatore '" + $marcatore + "': " + $url)
  }
}

function L($f,$et,$cella,$slmode,$buf,$tpmode,$tpr,$magic,$firmata){
  return [pscustomobject]@{ Prova=$f; Et=$et; Cella=$cella;
                            SLMode=$slmode; Buf=$buf; TPMode=$tpmode; TPR=$tpr; Magic=$magic;
                            Firmata=$firmata; Esito="NON ESEGUITO"; IS=-1; OOS=-1; Min=0.0 }
}

#  >>> CsvDi E RigheVive STANNO QUI, SOPRA IL try. <<<
#  Il throw che salta la catena e' IL CASO NORMALE di questa riga: i gate
#  del PASSO 0 lanciano PRIMA, e cosi' il diff dei file prova e la
#  compilazione. Se queste funzioni nascessero dentro il try, la raccolta
#  morirebbe con "The term 'CsvDi' is not recognized" e NON CI SAREBBE
#  NESSUN REFERTO proprio nella corsa fermata, che e' l'unica in cui serve
#  a capire perche'. CHI LE RIPORTA DENTRO IL try RIAPRE IL DIFETTO 48.
#  A Modello 4 il driver NON aggiunge il suffisso "_ohlc": lo aggiunge solo
#  ai modelli diversi da 4 (walkforward_generico.ps1, cercare '$Suffisso =').
function CsvDi($l,$tag){
  return (Join-Path $Risultati ($Ea + "\" + $Ea + "_" + $Sym + "_" + $tag + "_" + $l.Et + ".csv"))
}
function RigheVive($p){
  return @(Get-Content -LiteralPath $p | Where-Object { $_ -notmatch '^\s*#' -and $_ -notmatch '^\s*$' })
}
function NomeDi($riga){
  if($riga -match '^@'){ return ($riga -split '\s+')[0] }
  return (($riga -split '=')[0]).Trim()
}
$Vive = @{}    # etichetta -> righe vive del file prova (riempita nella sezione 1c)
function DiffNomi($a,$b){
  $d = New-Object System.Collections.ArrayList
  for($i=0;$i -lt $a.Count;$i++){ if($a[$i] -ne $b[$i]){ [void]$d.Add((NomeDi $a[$i])) } }
  return @($d)
}
function Pretendi($etA,$etB,$attese,$perche){
  $d = DiffNomi $Vive[$etA] $Vive[$etB]
  $manca = @($attese | Where-Object { $d -notcontains $_ })
  $extra = @($d      | Where-Object { $attese -notcontains $_ })
  if($d.Count -ne $attese.Count -or $manca.Count -gt 0 -or $extra.Count -gt 0){
    throw ($etA + " contro " + $etB + ": differiscono su [" + ($d -join ", ") + "] invece che su [" +
           ($attese -join ", ") + "]. " + $perche)
  }
}
function Mediana($v){
  $s = @($v | Sort-Object)
  if($s.Count -eq 0){ return 0.0 }
  if($s.Count % 2 -eq 1){ return [double]$s[[int](($s.Count-1)/2)] }
  return ([double]$s[$s.Count/2 - 1] + [double]$s[$s.Count/2]) / 2.0
}

# --- LA LISTA DEI LAVORI. Le 4 celle FIRMATE, piu' la quinta SOLO con -ConD.
$Lavori = @(
  (L "R97rif_halfrange_NASUSD.txt"         "r97rif" "R97-rif HALFRANGE buffer 0, TP range x1,5 (RIFERIMENTO: geometria della sedia viva Dow)" 3 0   1 "1.5" 779710 $true),
  (L "R97a_opprange_R2_NASUSD.txt"         "r97a"   "R97a OPPRANGE buffer 0, TP 2,0 R"                                                          0 0   0 "2.0" 779720 $true),
  (L "R97b_opprange_buf500_R15_NASUSD.txt" "r97b"   "R97b OPPRANGE buffer 500 pt, TP 1,5 R (la cella regina di R88)"                            0 500 0 "1.5" 779730 $true),
  (L "R97c_opprange_buf500_R2_NASUSD.txt"  "r97c"   "R97c OPPRANGE buffer 500 pt, TP 2,0 R (conferma)"                                          0 500 0 "2.0" 779740 $true)
)
if($ConD){
  $Lavori += (L "R97d_opprange_buf500_R1_NASUSD.txt" "r97d" "R97d OPPRANGE buffer 500 pt, TP 1,0 R  <<< NON FIRMATA" 0 500 0 "1.0" 779750 $false)
}

Write-Host ""
Write-Host "#####################################################################" -ForegroundColor Cyan
Write-Host "#  R97 - LO STOP ALL'ESTREMO OPPOSTO DEL RANGE, SU NASUSD (M5)      #" -ForegroundColor Cyan
Write-Host "#####################################################################" -ForegroundColor Cyan
Dico ("pin      : " + $Pin)
Dico ("cartella : " + $Work)

# =====================================================================
#  I NUMERI ATTESI, DICHIARATI PRIMA. Se a fine corsa non tornano,
#  il round non si legge.
# =====================================================================
Titolo "NUMERI ATTESI (dichiarati PRIMA della corsa)"
Write-Host ("    file prova ...................  " + $Lavori.Count + "   (4 celle firmate" + $(if($ConD){ " + R97d NON FIRMATA" } else { "" }) + ")") -ForegroundColor White
Write-Host ("    celle per file per finestra ..  " + $CelleAttese + "   (le due passate GEMELLE di controllo)") -ForegroundColor White
Write-Host ("    CSV attesi ...................  " + (2*$Lavori.Count) + "   (" + $Lavori.Count + " file x IS/OOS)") -ForegroundColor White
Write-Host ("    righe per CSV ................  " + $CelleAttese) -ForegroundColor White
Write-Host ("    passate totali ...............  " + (4*$Lavori.Count)) -ForegroundColor White
Write-Host  "    passate del PASSO 0 ..........  2   (gemelle, cella R97-rif in modo FIXED)" -ForegroundColor White
Write-Host ("    modello ......................  " + $Modello + " = TICK REALI (come R88: i numeri vanno confrontati con quelli)") -ForegroundColor White
Write-Host ("    finestra .....................  " + $DaQuando + " -> " + $Fino + "  (split 40/60)") -ForegroundColor White
Write-Host  "    IS / OOS .....................  NON le scrivo qui a memoria: si LEGGONO" -ForegroundColor Gray
Write-Host  "                                    nell'anteprima .ini del giro a vuoto" -ForegroundColor Gray
Write-Host  "                                    (FromDate/ToDate). Le calcola il driver," -ForegroundColor Gray
Write-Host  "                                    ed e' l'artefatto che gira davvero." -ForegroundColor Gray
Write-Host ("    deposito .....................  " + $Deposito + "   rischio 1,00% pinnato nei file prova") -ForegroundColor White
Write-Host ("    spread .......................  Spread=" + $SpreadIni + " nell'ini = spread CORRENTE, dichiarato.") -ForegroundColor White
Write-Host ""
Write-Host  "    IL GATE FIRMATO (criteri par. 3): quanti PUNTI MT5 valgono 1 punto" -ForegroundColor Yellow
Write-Host  "    indice su NASUSD. Atteso 100 (come U30USD), ma ATTESO non e' MISURATO:" -ForegroundColor Yellow
Write-Host  "    lo misura il PASSO 0-B e se non torna 100 la corsa NON PARTE." -ForegroundColor Yellow
Write-Host ""
Write-Host  "    QUANTO CI METTE: [STIMA] 1-2 ore. Il riferimento e' R88 (U30USD M5," -ForegroundColor Yellow
Write-Host ("    tick reali, 27 file in 2h16). R97 ha " + (4*$Lavori.Count) + " passate: dovrebbe essere meno.") -ForegroundColor Yellow
Write-Host  "    Il PASSO 0 MISURA una passata intera e stampa la stima." -ForegroundColor Yellow
Write-Host ""
Write-Host  "    >>> QUESTO ROUND NON PRODUCE NESSUNA SEDIA (criteri par. 6). Al" -ForegroundColor Yellow
Write-Host  "        massimo produce una PROPOSTA per un round di deploy separato." -ForegroundColor Yellow
if($ConD){
  Write-Host ""
  Write-Host "    !!! -ConD ACCESO: gira anche R97d (TP 1:1), CHE NON E' FIRMATA." -ForegroundColor Red
  Write-Host "        La firma del 21/08 dice: 'resta ESCLUSA per ora ... entra solo" -ForegroundColor Red
  Write-Host "        con un'approvazione a parte'. Se quell'approvazione non c'e'," -ForegroundColor Red
  Write-Host "        rilancia SENZA -ConD." -ForegroundColor Red
}

if($Pin -eq ""){
  Write-Host ""
  Write-Host "!!! MANCA -Pin. Questa riga gira SOLO su un commit congelato." -ForegroundColor Red
  Write-Host "    Rilancia col blocco intero, che passa -Pin <hash>." -ForegroundColor Yellow
  exit 1
}

try{

# =====================================================================
#  0. MT5 E METAEDITOR CHIUSI. Prima di qualunque altra cosa.
#     MT5 aperto = il tester non parte e escono ZERO CSV (checklist 7).
#     MetaEditor e' SINGLE-INSTANCE: se ne gira gia' una copia, il nostro
#     metaeditor64.exe /compile torna SUBITO senza aver compilato, e la
#     fase 3 dichiarerebbe "COMPILAZIONE FALLITA" su un sorgente sano
#     (checklist 39).
# =====================================================================
$vivi = @(Get-Process -Name "terminal64","metaeditor64" -ErrorAction SilentlyContinue)
if($vivi.Count -gt 0){
  Write-Host ""
  Write-Host ("!!! APERTO: " + (($vivi | ForEach-Object { $_.ProcessName } | Sort-Object -Unique) -join ", ")) -ForegroundColor Red
  Write-Host "    Non parto: col terminale aperto il tester non gira (zero CSV), e con" -ForegroundColor Red
  Write-Host "    MetaEditor aperto la compilazione torna subito senza compilare." -ForegroundColor Red
  Write-Host "    Chiudi MetaTrader E MetaEditor (tutte le istanze) e rilancia." -ForegroundColor Yellow
  #  DICHIARATO AD ALTA VOCE: questo exit 1 sta DENTRO il try e quindi SALTA
  #  LA RACCOLTA - niente cartella, niente referto, niente zip. Qui e'
  #  accettabile ed e' una scelta: siamo a due secondi dal lancio, non e'
  #  stato prodotto NIENTE, e non c'e' niente da raccogliere. Il messaggio a
  #  schermo E' il referto di questo caso.
  exit 1
}

# =====================================================================
#  1. SCARICO AL PIN
# =====================================================================
Titolo "1. SCARICO AL PIN"
New-Item -ItemType Directory -Force -Path $Work,$Prove,$Logs,$SrcDir | Out-Null

$Driver = Join-Path $Work "walkforward_generico.ps1"
Scarica ("$RawPin/backtest_pipeline/walkforward_generico.ps1") $Driver 'RigaSpread'

# --- 1a. IL PIN DEL MOTORE (difetto 24). walkforward_generico.ps1 ha
#     $EABranch="lavoro" scritto FISSO (cercare '$EABranch=') e riscarica
#     il .mq5 dalla PUNTA del branch: senza questa riscrittura un pin
#     pinnerebbe gli script e NON il motore. Su un round che confronta
#     4 celle fra loro, un push a meta' corsa cambierebbe il motore fra
#     una cella e l'altra e il confronto non misurerebbe piu' niente.
$dTxt = Get-Content -LiteralPath $Driver -Raw
$dNew = $dTxt -replace '\$EABranch\s*=\s*"lavoro"', ('$EABranch="' + $Pin + '"')
if($dNew -eq $dTxt){ throw "non sono riuscito a pinnare EABranch nel driver: riga non trovata" }

# --- 1b. IL TETTO DELLE BARRE. Se il tester ereditasse il tetto "Max barre
#     nel grafico" del terminale, le serie verrebbero TRONCATE IN SILENZIO
#     (checklist 36) e i CSV uscirebbero pieni di numeri coerenti e falsi.
#     [INFERITO] che il tester onori questa riga: NON e' misurato. Il gate
#     vero resta il PASSO 0-C sulla prima data del per-trade.
$dNew = $dNew -replace '(?m)^\[Experts\]\r?$', "[Charts]`r`nMaxBars=2000000000`r`n`r`n[Experts]"
Set-Content -LiteralPath $Driver -Value $dNew -Encoding ASCII
# --- gate sullo STATO FINALE, non sul replace (checklist 33)
if(-not (Select-String -LiteralPath $Driver -SimpleMatch -Pattern ('$EABranch="' + $Pin + '"') -Quiet)){ throw "pin di EABranch NON verificato nel driver" }
$nMax = @(Select-String -LiteralPath $Driver -SimpleMatch -Pattern 'MaxBars=2000000000').Count
if($nMax -ne 2){ throw ("MaxBars scritto " + $nMax + " volte nel driver invece di 2 (anteprima + corsa vera): il driver e' cambiato, mi fermo.") }
Dico ("driver PINNATO (" + $Pin.Substring(0,[math]::Min(7,$Pin.Length)) + ") e con MaxBars alzato") "Green"

# --- 1c. I FILE PROVA
foreach($l in $Lavori){ Scarica ("$RawPin/backtest_pipeline/prove/" + $l.Prova) (Join-Path $Prove $l.Prova) '@SIMBOLO' }
Dico ($Lavori.Count.ToString() + " file prova scaricati al pin") "Green"

foreach($l in $Lavori){
  $rv = RigheVive (Join-Path $Prove $l.Prova)
  if($rv.Count -ne $RigheAttese){ throw ($l.Prova + " ha " + $rv.Count + " righe vive invece di " + $RigheAttese + ": artefatto cambiato, mi fermo.") }
  $Vive[$l.Et] = $rv
}

# --- 1d. IL DIFF A COPPIE (checklist 33 e 40-bis). Contare "2 righe
#     diverse" non basta: due righe SBAGLIATE darebbero lo stesso
#     conteggio e il round misurerebbe due cose insieme. Qui si pretende
#     QUALI righe differiscono, coppia per coppia.
Pretendi "r97rif" "r97a" @("InpSLMode","InpTPMode","InpTP_R","InpMagic") "Fra il riferimento HALFRANGE e la cella base OPPRANGE cambiano SOLO la geometria dello stop e il modo/valore del TP: e' la domanda del round."
Pretendi "r97a" "r97b" @("InpSLBufferPts","InpTP_R","InpMagic")          "Fra R97a e R97b cambiano SOLO il buffer e il TP in R (criteri par. 4)."
Pretendi "r97a" "r97c" @("InpSLBufferPts","InpMagic")                    "Fra R97a e R97c cambia SOLO il buffer: e' l'asse dello stop-widening isolato."
Pretendi "r97b" "r97c" @("InpTP_R","InpMagic")                           "Fra R97b e R97c cambia SOLO il TP in R: e' l'asse del target isolato."
if($ConD){
  Pretendi "r97c" "r97d" @("InpTP_R","InpMagic")                         "Fra R97c e R97d cambia SOLO il TP in R (2,0 contro 1,0)."
}
Dico ("diff a coppie dei file prova: righe vive " + $RigheAttese + ", e differiscono solo dove devono") "Green"

# --- 1e. I VALORI DELLE CELLE, letti NELL'ARTEFATTO CHE GIRA
#     (checklist 34-bis). Il diff dice CHE cambiano; questo dice CHE COSA
#     valgono: se due celle fossero scambiate il diff resterebbe verde.
$magicVisti = @()
foreach($l in $Lavori){
  $tx = Get-Content -LiteralPath (Join-Path $Prove $l.Prova) -Raw
  foreach($chk in @(@("InpSLMode",("" + $l.SLMode)), @("InpSLBufferPts",("" + $l.Buf)), @("InpTPMode",("" + $l.TPMode)), @("InpTP_R",$l.TPR))){
    #  >>> OGNI $ DI UNA REGEX MULTILINEA SI SCRIVE \r?$ (checklist 40): i
    #      file arrivano da GitHub con CRLF, e senza \r? il match non
    #      avviene MAI e il gate accuserebbe un file sano.
    $rx = '(?m)^' + $chk[0] + '=' + [regex]::Escape($chk[1]) + '\r?$'
    if($tx -notmatch $rx){ throw ($l.Prova + ": non trovo la riga '" + $chk[0] + "=" + $chk[1] + "'. La cella non e' quella che credo: le celle sono scambiate o il file e' cambiato.") }
  }
  $mg = [regex]::Match($tx,'(?m)^InpMagic=(\d+)\|\|')
  if(-not $mg.Success){ throw ($l.Prova + ": non trovo la riga InpMagic nella forma sweep 'v||v||1||v+1||Y'") }
  $m0 = [int]$mg.Groups[1].Value
  if($m0 -ne $l.Magic){ throw ($l.Prova + ": InpMagic e' " + $m0 + " ma questa cella deve girare su " + $l.Magic) }
  if($magicVisti -contains $m0){ throw ($l.Prova + ": magic " + $m0 + " gia' usato da un altro file prova. Due celle con lo stesso magic si sovrascrivono il per-trade.") }
  if($m0 -eq $MagicA -or $m0 -eq $MagicB){ throw ($l.Prova + ": usa il magic del PASSO 0 (" + $m0 + "). Le due fasi non condividono il magic (checklist 41).") }
  if($MagicVietati -contains $m0){ throw ($l.Prova + ": il magic " + $m0 + " e' di una SEDIA VIVA (770611 e' QUESTO STESSO EA sul Dow). Fermo tutto.") }
  $magicVisti += $m0
}
Dico ("valori delle celle e magic verificati NEI FILE: " + ($magicVisti -join ", ") + "   (PASSO 0: " + $MagicA + "/" + $MagicB + ")") "Green"

# --- 1f. @DAQUANDO, @SIMBOLO, @PERIODO E L'ORA SERVER, scritti in DUE
#     posti (file prova e questa riga): si CONFRONTANO, non ci si fida del
#     commento "se cambi qui cambia anche li'" (checklist 33).
$PtsGateProva = 0.0
$PtsGateStr   = ""
foreach($l in $Lavori){
  $tx = Get-Content -LiteralPath (Join-Path $Prove $l.Prova) -Raw
  $m = [regex]::Match($tx,'(?m)^@DAQUANDO\s+([0-9]{4}\.[0-9]{2}\.[0-9]{2})')
  if(-not $m.Success){ throw ($l.Prova + ": manca @DAQUANDO") }
  if($m.Groups[1].Value -ne $DaQuando){ throw ($l.Prova + ": @DAQUANDO e' " + $m.Groups[1].Value + " ma la riga di lancio dice " + $DaQuando) }
  $s = [regex]::Match($tx,'(?m)^@SIMBOLO\s+(\S+)')
  if(-not $s.Success -or $s.Groups[1].Value -ne $Sym){ throw ($l.Prova + ": @SIMBOLO non e' " + $Sym) }
  $p = [regex]::Match($tx,'(?m)^@PERIODO\s+(\S+)')
  if(-not $p.Success -or $p.Groups[1].Value -ne $Periodo){ throw ($l.Prova + ": @PERIODO non e' " + $Periodo) }
  # --- L'ORA E' IN ORA SERVER. Regola di casa: server BCM = ora italiana - 1,
  #     quindi l'apertura USA (15:30 IT) e' 14:30 SERVER. Un 15 qui dentro
  #     vorrebbe dire ora italiana, cioe' un'altra strategia, e i CSV
  #     andrebbero cestinati. Meglio non produrli affatto.
  foreach($chk in @(@("InpRangeStartHour","14"), @("InpRangeStartMin","30"), @("InpRangeEndHour","14"), @("InpRangeEndMin","45"))){
    if($tx -notmatch ('(?m)^' + $chk[0] + '=' + $chk[1] + '\r?$')){
      throw ($l.Prova + ": " + $chk[0] + " non e' " + $chk[1] + " (ORA SERVER, = " + $chk[1] + " server BCM). Un 15 sarebbe l'ora ITALIANA: server BCM = ora italiana - 1.")
    }
  }
  # --- e InpSLFixedPts, che serve al PASSO 0-B: si LEGGE dal file prova,
  #     non si scrive a memoria nello script (checklist 40-bis).
  $sf = [regex]::Match($tx,'(?m)^InpSLFixedPts=([0-9]+(?:\.[0-9]+)?)\r?$')
  if(-not $sf.Success){ throw ($l.Prova + ": manca InpSLFixedPts, che il gate del PASSO 0-B usa per misurare la conversione dei punti.") }
  #  >>> SI TIENE LA STRINGA ESATTA DEL FILE, non la sua rilettura da double.
  #      "1000.0" letto come double e riscritto diventa "1000": il gate
  #      sull'ini derivato cercherebbe una riga che nel file non c'e' e
  #      accuserebbe un artefatto sano (checklist 40, il gate che non morde
  #      preso dal lato opposto).
  $vs = $sf.Groups[1].Value
  $v  = [double]::Parse($vs,$INV)
  if($PtsGateStr -eq ""){ $PtsGateStr = $vs; $PtsGateProva = $v }
  elseif($PtsGateStr -ne $vs){ throw ($l.Prova + ": InpSLFixedPts=" + $vs + " ma un altro file prova dice " + $PtsGateStr + ". Il corpo delle celle non e' piu' identico.") }
}
if($PtsGateProva -le 0){ throw "InpSLFixedPts nei file prova non e' un numero positivo: il gate della conversione non puo' misurare niente." }
$Passo0.PtsGate = $PtsGateProva
Dico ("@DAQUANDO / @SIMBOLO / @PERIODO, il range 14:30-14:45 SERVER e InpSLFixedPts=" + $PtsGateProva + " verificati in tutti i file") "Green"

# --- 1g. IL SORGENTE E IL GATE DI VERSIONE. Il marcatore e'
#     'InpSLBufferPts', che esiste SOLO dalla v1.02: senza quell'input
#     l'intero asse di R97 sarebbe muto. E la versione si legge, non si
#     spera: una cache CDN o un branch sbagliato darebbero la v1.01, e
#     le celle a buffer 500 uscirebbero identiche a quelle a buffer 0.
$srcMq5 = Join-Path $SrcDir ($Ea + ".mq5")
Scarica ("$RawPin/mql5/Experts/" + $Ea + ".mq5") $srcMq5 'InpSLBufferPts'
$txtSrc = Get-Content -LiteralPath $srcMq5 -Raw
$mv = [regex]::Match($txtSrc,'#property\s+version\s+"([^"]+)"')
if(-not $mv.Success){ throw ($Ea + ".mq5 scaricato senza #property version: non e' il sorgente che credo.") }
$VersioneLetta = $mv.Groups[1].Value
if($VersioneLetta -ne $VersioneAttesa){
  throw ($Ea + ".mq5 dichiara version '" + $VersioneLetta + "' invece di '" + $VersioneAttesa +
         "'. O la cache di raw.githubusercontent serve una copia vecchia, o il pin e' sbagliato. I criteri di R97 parlano della v1.02: mi fermo.")
}
Dico ($Ea + ".mq5 scaricato al pin, version " + $VersioneLetta + " (marcatore: InpSLBufferPts)") "Green"

# =====================================================================
#  2. TERMINALE E CARTELLA DATI (per NOME, mai il primo che capita)
# =====================================================================
Titolo "2. TERMINALE E CARTELLA DATI"
$tutti = @(Get-ChildItem "C:\Program Files","C:\Program Files (x86)" -Recurse -Filter "terminal64.exe" -ErrorAction SilentlyContinue)
$cand  = @($tutti | Where-Object { $_.DirectoryName -like "*BCM Markets MT5 Terminal*" -and $_.DirectoryName -notlike "*-V3*" })
if($cand.Count -eq 0){ throw "non trovo il terminale 'BCM Markets MT5 Terminal' (quello NON -V3). Non tiro a indovinare." }
if($cand.Count -gt 1){ throw ("trovati " + $cand.Count + " terminali che corrispondono: ambiguo, mi fermo.") }
$InstDir    = $cand[0].DirectoryName
$Terminal   = Join-Path $InstDir "terminal64.exe"
$MetaEditor = Join-Path $InstDir "metaeditor64.exe"
if(-not (Test-Path -LiteralPath $MetaEditor)){ throw ("manca metaeditor64.exe in " + $InstDir) }
$termRoot = Join-Path $env:APPDATA "MetaQuotes\Terminal"
$DataFolder = Get-ChildItem $termRoot -Directory -ErrorAction SilentlyContinue | Where-Object {
    $o = Join-Path $_.FullName "origin.txt"
    (Test-Path $o) -and ((Get-Content $o -Raw).Trim() -ieq $InstDir)
  } | Select-Object -First 1 -ExpandProperty FullName
if(-not $DataFolder){ throw "cartella dati MT5 non trovata (origin.txt non punta a nessuna cartella)." }
$MqlExperts = Join-Path $DataFolder "MQL5\Experts"
$MqlInclude = Join-Path $DataFolder "MQL5\Include"
New-Item -ItemType Directory -Force -Path $MqlExperts,$MqlInclude,$Sosta | Out-Null
# --- 2-bis. LA SOSTA SI SVUOTA A OGNI GIRO (checklist 53 e 50).
#     Il documento PRESCRIVE il giro a vuoto PRIMA della corsa vera. Il giro
#     a vuoto lascia in sosta anteprima_r97*.ini; la corsa vera NON le
#     riproduce e la raccolta copia in blocco tutta la sosta nello zip:
#     dentro il risultato del round finirebbero quattro .ini CHE NON HANNO
#     GIRATO (finestra IS, Model=4 costante), indistinguibili da quelli veri.
#     E' l'artefatto di ieri che passa per quello di oggi, sull'unico zip che
#     Claudio guarda. Qui non si perde niente: la sosta e' una copia di
#     lavoro, l'archivio e' la cartella datata sul Desktop, che non si
#     sovrascrive mai (checklist 12).
$nSosta = @(Get-ChildItem -LiteralPath $Sosta -File -ErrorAction SilentlyContinue).Count
if($nSosta -gt 0){
  Get-ChildItem -LiteralPath $Sosta -File -ErrorAction SilentlyContinue | Remove-Item -Force -ErrorAction SilentlyContinue
  $nSostaDopo = @(Get-ChildItem -LiteralPath $Sosta -File -ErrorAction SilentlyContinue).Count
  if($nSostaDopo -gt 0){
    [void]$Problemi.Add("sosta: " + $nSostaDopo + " file su " + $nSosta + " di un giro PRECEDENTE non sono stati cancellati. Possono finire nello zip di questo round spacciandosi per artefatti di adesso: controllare le date dentro lo zip prima di leggerlo.")
  }
  Dico ("sosta svuotata: " + $nSosta + " file di un giro precedente rimossi (rimasti: " + $nSostaDopo + ")") "Green"
}
#  OGNI PASSO STAMPA IL BERSAGLIO CHE HA SCELTO (checklist 37).
Dico ("terminale : " + $Terminal)
Dico ("dati      : " + $DataFolder + "   (DEVE restare lo stesso in tutti i passi)")

# --- 2a. L'INCLUDE CHE NESSUN DRIVER INSTALLA (checklist 33-bis).
#     ABTG_ORB_Ottimizzato.mq5 fa #include <ABTG_PausaGuardian.mqh> e
#     chiama ABTG_GuardiaIngresso(). walkforward_generico.ps1 scarica
#     SOLO il .mq5: senza questa riga la compilazione fallisce e il
#     round muore alla prima passata. Pagato due volte (21/08 e 22/08).
$mqh = Join-Path $MqlInclude "ABTG_PausaGuardian.mqh"
Scarica ("$RawPin/mql5/Include/ABTG_PausaGuardian.mqh") $mqh 'ABTG_GuardiaIngresso'
$vfy = Get-Item -LiteralPath $mqh
if($vfy.PSIsContainer){ throw "ABTG_PausaGuardian.mqh: in Include c'e' una CARTELLA con quel nome (checklist 27-ter)." }
if($vfy.Length -lt 4000){ throw ("ABTG_PausaGuardian.mqh e' lungo " + $vfy.Length + " byte: troppo poco, scarico monco.") }
Dico ("include installato: ABTG_PausaGuardian.mqh (" + $vfy.Length + " byte)") "Green"

# --- 2b. PULIZIA DEGLI ARTEFATTI VECCHI, PRIMA (checklist 14 e 53).
#     >>> SOLO se si corre davvero: un giro a vuoto che cancella gli
#         artefatti di una corsa vera fatta ieri e' un danno.
#     >>> E SI CANCELLA PER NOME, MAGIC PER MAGIC: un filtro
#         "abtg_trades_<EA>_*" prenderebbe anche i per-trade della SEDIA
#         VIVA sul Dow (stesso EA, magic 770611). Qui si toccano solo i
#         nostri 7797xx su NASUSD.
$MieiMagic = @($MagicA,$MagicB)
foreach($l in $Lavori){ $MieiMagic += $l.Magic; $MieiMagic += ($l.Magic + 1) }
if($SoloControllo){
  $quanti = 0
  foreach($m in $MieiMagic){ if(Test-Path -LiteralPath (Join-Path $Comune ("abtg_trades_" + $Ea + "_" + $Sym + "_" + $m + ".csv"))){ $quanti++ } }
  Dico ("SoloControllo: NON cancello niente (per-trade R97 presenti adesso: " + $quanti + ")") "Yellow"
} else {
  $nTolti = 0; $nRimasti = 0
  foreach($m in $MieiMagic){
    $f = Join-Path $Comune ("abtg_trades_" + $Ea + "_" + $Sym + "_" + $m + ".csv")
    if(Test-Path -LiteralPath $f){
      Remove-Item -LiteralPath $f -Force -ErrorAction SilentlyContinue
      if(Test-Path -LiteralPath $f){ $nRimasti++ } else { $nTolti++ }
    }
  }
  if($nRimasti -gt 0){
    [void]$Problemi.Add("pulizia: " + $nRimasti + " per-trade R97 NON cancellati (file aperto in Excel?). Un file vecchio che sopravvive verrebbe letto come nuovo: i gate guardano la DATA, ma va saputo.")
  }
  Dico ("per-trade R97 rimossi: " + $nTolti + " (rimasti: " + $nRimasti + "). NESSUN file di altri magic o di altri simboli e' stato toccato: la sedia viva 770611 sul Dow e i CSV di R88 restano dove sono.") "Green"
  Remove-Item -LiteralPath (Join-Path $DataFolder ("MQL5\Files\OptResults_" + $Ea + "_" + $Sym + ".csv")) -Force -ErrorAction SilentlyContinue
  # --- la CACHE del tester, e SOLO quella. MAI bases\<server>\ticks: li'
  #     dentro c'e' lo storico a tick reali, e ributtarlo giu' e' una nottata.
  #  >>> CON -LiteralPath IL * NON E' UN WILDCARD (checklist 46).
  #  >>> E NON SI CREDE ALL'INTENZIONE: si conta PRIMA e DOPO.
  $cache = Join-Path $DataFolder "Tester\cache"
  if(Test-Path -LiteralPath $cache){
    $nc = @(Get-ChildItem -LiteralPath $cache -Force -Recurse -File -ErrorAction SilentlyContinue).Count
    Get-ChildItem -LiteralPath $cache -Force -ErrorAction SilentlyContinue | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
    $nr = @(Get-ChildItem -LiteralPath $cache -Force -Recurse -File -ErrorAction SilentlyContinue).Count
    if($nr -gt 0){
      [void]$Problemi.Add("Tester\cache NON svuotata: " + $nr + " file su " + $nc + " sono rimasti. MT5 puo' ripescare passate gia' calcolate e NON scrivere i per-trade (punto 38).")
      Dico ("Tester\cache: " + $nc + " file prima, " + $nr + " RIMASTI. NON e' stata svuotata.") "Red"
    } else {
      Dico ("Tester\cache svuotata: " + $nc + " file prima, " + $nr + " dopo. bases\<server>\ticks NON toccata.") "Green"
    }
  } else { Dico "Tester\cache non esiste: niente da svuotare." "Gray" }
}

# =====================================================================
#  3. FASE COMPILA. .ex5 SCRITTO ADESSO.
#     Si fa ANCHE in -SoloControllo: il -SoloControllo del driver generico
#     esce PRIMA della compilazione (checklist 39).
#     >>> INVOCAZIONE DIRETTA di metaeditor64.exe (checklist 54 e bug del
#         22/08): con Start-Process -ArgumentList a stringhe pre-quotate,
#         sui path con spazi ("Program Files") torna rc=0 SENZA compilare.
#     >>> E IL VERDETTO E' IL LastWriteTime DEL .ex5 PRIMA/DOPO, non
#         "esiste" e non "e' recente": il file c'era gia'.
# =====================================================================
Titolo "3. FASE COMPILA"
$mq5 = Join-Path $MqlExperts ($Ea + ".mq5")
$ex5 = Join-Path $MqlExperts ($Ea + ".ex5")
$logC= Join-Path $MqlExperts ($Ea + ".log")
#  backup DATATO e MAI sovrascritto (checklist 12): il .ex5 vecchio e'
#  l'unica prova di cosa girava prima su questa macchina.
$bakMq5 = $mq5 + ".prima_r97_" + $Stamp
$bakEx5 = $ex5 + ".prima_r97_" + $Stamp
if((Test-Path -LiteralPath $mq5) -and -not (Test-Path -LiteralPath $bakMq5)){ Copy-Item -LiteralPath $mq5 -Destination $bakMq5 -Force }
if((Test-Path -LiteralPath $ex5) -and -not (Test-Path -LiteralPath $bakEx5)){ Copy-Item -LiteralPath $ex5 -Destination $bakEx5 -Force }
Copy-Item -LiteralPath $srcMq5 -Destination $mq5 -Force
#  verifica della copia sul CONTENUTO, non sul nome (checklist 27-ter)
$lenSrc = (Get-Item -LiteralPath $srcMq5).Length
$vc = Get-Item -LiteralPath $mq5 -ErrorAction SilentlyContinue
if(-not $vc -or $vc.PSIsContainer -or $vc.Length -ne $lenSrc){ throw "copia del .mq5 in MQL5\Experts NON verificata (lunghezza diversa o e' una cartella)." }
$ex5Prima = (Get-Date).AddYears(-100)
if(Test-Path -LiteralPath $ex5){ $ex5Prima = (Get-Item -LiteralPath $ex5).LastWriteTime }
Remove-Item -LiteralPath $logC -Force -ErrorAction SilentlyContinue
& $MetaEditor "/compile:$mq5" "/log:$logC" | Out-Null
$rcMe = $LASTEXITCODE
$ex5Dopo = $null
if(Test-Path -LiteralPath $ex5){ $ex5Dopo = (Get-Item -LiteralPath $ex5).LastWriteTime }
$compileOk = ($ex5Dopo -ne $null) -and ($ex5Dopo -gt $ex5Prima)
$testoLog = ""
if(Test-Path -LiteralPath $logC){
  try{ $testoLog = (Get-Content -LiteralPath $logC -Raw -Encoding Unicode) }catch{ $testoLog = "" }
  if($testoLog -notmatch '(?i)error'){ try{ $testoLog = (Get-Content -LiteralPath $logC -Raw) }catch{} }
  Copy-Item -LiteralPath $logC -Destination (Join-Path $Sosta "compile_r97.log") -Force -ErrorAction SilentlyContinue
}
if(-not $compileOk){
  if($testoLog -ne ""){
    Write-Host "--- log del compilatore (ultime righe) ---" -ForegroundColor DarkYellow
    foreach($r in @($testoLog -split "\r?\n" | Select-Object -Last 20)){ Write-Host ("   " + $r) -ForegroundColor DarkYellow }
  } else { Write-Host "   (nessun log prodotto da MetaEditor)" -ForegroundColor DarkYellow }
  #  sorgente e binario devono restare la STESSA versione (checklist 54)
  if(Test-Path -LiteralPath $bakMq5){ Copy-Item -LiteralPath $bakMq5 -Destination $mq5 -Force }
  throw ("COMPILAZIONE FALLITA per " + $Ea + " (metaeditor rc=" + $rcMe + ", .ex5 NON riscritto). Il .mq5 e' stato rimesso com'era. Il round si ferma qui, e il log e' nello zip.")
}
$mw = [regex]::Match($testoLog,'(?i)(\d+)\s+warning')
if($mw.Success -and [int]$mw.Groups[1].Value -gt 0){
  [void]$Note.Add("compilazione: " + $mw.Groups[1].Value + " warning (0 errori). Non fermano il round, ma vanno letti nel log compile_r97.log dello zip.")
}
Dico ("COMPILATO " + $Ea + " v" + $VersioneLetta + " (.ex5 riscritto adesso, metaeditor rc=" + $rcMe + ")") "Green"

# =====================================================================
#  4-A. PASSO 0-A -- LE BARRE. I TICK NON SI RISCARICANO.
#     Sono gia' MISURATI e agli atti: NASUSD 164.636.788 tick dal
#     2024.09.26 (REFERTO_R83_R84_PREPARAZIONE.md riga 620).
#     Riscaricarli aprirebbe la finestra del difetto 30 (il guardiano di
#     progresso che ammazza MT5 in mezzo alla fase dei tick, dove il CSV
#     per costruzione non cresce di un byte per ore).
# =====================================================================
if(-not $SoloControllo -and -not $SaltaPasso0){
  Titolo "4-A. PASSO 0-A - LE BARRE M1+M5 DI NASUSD"
  $ScStorico = Join-Path $Work "scarica_storico.ps1"
  $t0A = Get-Date       # serve a distinguere un referto NUOVO da uno di ieri
  try{
    Scarica ("$RawPin/backtest_pipeline/scarica_storico.ps1") $ScStorico 'REFERTO STORICO'
    #  >>> ANCHE QUESTO GEMELLO VA PINNATO (difetto 24, seconda occorrenza). <<<
    $stTxt = Get-Content -LiteralPath $ScStorico -Raw
    $stNew = $stTxt -replace '\$EABranch\s*=\s*"lavoro"', ('$EABranch="' + $Pin + '"')
    if($stNew -eq $stTxt){ throw "non sono riuscito a pinnare EABranch in scarica_storico.ps1: riga non trovata" }
    Set-Content -LiteralPath $ScStorico -Value $stNew -Encoding ASCII
    if(-not (Select-String -LiteralPath $ScStorico -SimpleMatch -Pattern ('$EABranch="' + $Pin + '"') -Quiet)){ throw "pin di EABranch NON verificato in scarica_storico.ps1" }
    #  checklist 51: l'ini che quello script passa a terminal64 /config deve
    #  avere [Experts] AllowLiveTrading=false, o aprire MT5 per MISURARE
    #  riarma il profilo del conto vivo.
    if(-not (Select-String -LiteralPath $ScStorico -SimpleMatch -Pattern 'AllowLiveTrading=false' -Quiet)){
      throw "scarica_storico.ps1 NON scrive [Experts] AllowLiveTrading=false nell'ini: aprirebbe il terminale riarmando la flotta sul conto vivo (checklist 51). Mi fermo."
    }
    Dico ("scarica_storico.ps1 PINNATO e con AllowLiveTrading=false verificato") "Green"
    $global:LASTEXITCODE = 0
    & powershell.exe -ExecutionPolicy Bypass -File $ScStorico -Simboli $Sym -Da $DaQuando -Timeframes "M1,M5" -SenzaTick -Auto -TimeoutMin 45 2>&1 |
      Tee-Object -FilePath (Join-Path $Logs "passo0a_storico.txt") | Out-Host
    $Storico.Eseguito = $true
    $Storico.Esito = "eseguito, uscita " + $LASTEXITCODE
    if($LASTEXITCODE -ne 0){
      $che = if($LASTEXITCODE -eq 2){ "TIMEOUT dei 45 minuti: MT5 fermato a meta', il referto storico e' PARZIALE (ma c'e', e lo leggo lo stesso)" } else { "errore" }
      [void]$Problemi.Add("PASSO 0-A: scarica_storico.ps1 e' uscito con codice " + $LASTEXITCODE + " -> " + $che + ". Il gate 0-C resta la misura che decide.")
    }
    #  >>> E ANCHE QUI SI GUARDA LA DATA (checklist 23). <<<
    $csvSt = Join-Path $DataFolder "MQL5\Files\ABTG_StoricoScaricato.csv"
    if((Test-Path -LiteralPath $csvSt) -and ((Get-Item -LiteralPath $csvSt).LastWriteTime -lt $t0A)){
      [void]$Problemi.Add("PASSO 0-A: il referto storico e' del " +
                          (Get-Item -LiteralPath $csvSt).LastWriteTime.ToString("yyyy-MM-dd HH:mm",$INV) +
                          ", PRIMA dell'avvio di questo passo: e' STANTIO e NON descrive questa corsa. Non lo leggo.")
      $csvSt = ""
    }
    if($csvSt -ne "" -and (Test-Path -LiteralPath $csvSt)){
      #  LE COLONNE VERE le scrive ABTG_HistoryDownloader.mq5:
      #    Simbolo,Timeframe,Barre,PrimaDataLocale,PrimaDataServer,Verdetto
      #  'Stato' NON esiste: PowerShell risponderebbe $null in silenzio
      #  (checklist 46-bis).
      $vistoSym = $false
      foreach($r in (Import-Csv -LiteralPath $csvSt)){
        $sy = ("" + $r.Simbolo).Trim().ToUpper()
        if($sy -ne $Sym){ continue }
        $vistoSym = $true
        $verd = ("" + $r.Verdetto).Trim()
        [void]$Note.Add("PASSO 0-A: " + $sy + " " + $r.Timeframe + " | barre " + $r.Barre +
                        " | disco " + $r.PrimaDataLocale + " | broker " + $r.PrimaDataServer +
                        " -> " + $(if($verd -ne ""){ $verd } else { "VERDETTO VUOTO" }))
        #  >>> LA GUARDIA SI SCRIVE AL POSITIVO (checklist 40-ter e 47). <<<
        if($verd -like "MANCA STORICO LOCALE*"){
          [void]$Note.Add("PASSO 0-A: " + $sy + " " + $r.Timeframe + " -> '" + $verd +
                          "' (BENIGNO: c'e' sul server, non ancora sul disco. Il tester si scarica il resto da solo.)")
        }
        elseif($verd -ne "COMPLETO"){
          $che = if($verd -eq ""){ "VUOTO (formato del referto cambiato: NON e' stato letto)" } else { "'" + $verd + "'" }
          [void]$Problemi.Add("PASSO 0-A: verdetto NON 'COMPLETO' su " + $sy + " " + $r.Timeframe + " -> " + $che +
                              " | barre " + $r.Barre + " | broker " + $r.PrimaDataServer + " | chiesto dal " + $DaQuando +
                              ".  Il gate 0-C sulla prima data del per-trade e' la misura che decide.")
        }
      }
      if(-not $vistoSym){ [void]$Problemi.Add("PASSO 0-A: nessuna riga per " + $Sym + " nel referto storico.") }
    } else { [void]$Note.Add("PASSO 0-A: ABTG_StoricoScaricato.csv non trovato, referto storico NON letto.") }
  }catch{
    $Storico.Esito = "NON ESEGUITO (" + $_.Exception.Message + ")"
    [void]$Problemi.Add("PASSO 0-A NON ESEGUITO: " + $_.Exception.Message + ". Il gate 0-C resta l'unica misura.")
  }
  Dico ("PASSO 0-A: " + $Storico.Esito) "Gray"
} else {
  $Storico.Esito = "SALTATO (SoloControllo o SaltaPasso0)"
}

# =====================================================================
#  4-B / 4-C. IL GATE FIRMATO (criteri par. 3) + i gate di sempre.
#     Due passate SINGOLE gemelle derivate dal file prova R97-rif, in
#     modo FIXED, con InpVerbose=1.
# =====================================================================
if($SaltaPasso0){
  [void]$Problemi.Add("PASSO 0 SALTATO SU RICHIESTA: LA CONVERSIONE DEI PUNTI NON E' STATA MISURATA IN QUESTA CORSA. I criteri (par. 3, coperto dalla firma, punto (c)) dicono che nessuna passata parte senza quel numero agli atti: questa corsa NON rispetta la firma e i suoi numeri sui buffer non si leggono da soli.")
  Write-Host "    !! PASSO 0 SALTATO. Il referto lo scrive in rosso." -ForegroundColor Red
} else {
  #  IL BERSAGLIO DEL GATE E' IL PRIMO LAVORO DELLA LISTA (R97-rif), e non
  #  un nome riscritto a mano: un selettore ricopiato degrada di una riga
  #  per volta (checklist 37).
  $ProvaGate = $Lavori[0].Prova
  Titolo ("4-B. PASSO 0 - IL GATE (2 passate singole gemelle da " + $ProvaGate + ", modo FIXED)")

  # --- l'ini si DERIVA dal file prova: un solo artefatto (checklist 33)
  function IniPasso0($magic,$dest){
    $righe = @(Get-Content -LiteralPath (Join-Path $Prove $ProvaGate) |
               Where-Object { $_ -notmatch '^\s*#' -and $_ -notmatch '^\s*$' -and $_ -notmatch '^@' })
    $out = New-Object System.Collections.ArrayList
    foreach($r in $righe){
      $nome = ($r -split '=')[0].Trim()
      switch($nome){
        "InpVerbose"  { [void]$out.Add("InpVerbose=1") }    # serve il log: e' li' che si legge la conversione
        "InpSLMode"   { [void]$out.Add("InpSLMode=2") }     # 2 = FIXED: sl = entry - InpSLFixedPts*_Point
        "InpMagic"    { [void]$out.Add("InpMagic=" + $magic) }
        "InpRiskPercent" {
            #  di norma resta quello del file prova. Si abbassa SOLO se
            #  chiesto a mano, e non cambia di una virgola la GEOMETRIA che
            #  il gate misura (la distanza dello stop non dipende dal lotto).
            if($RischioSonda -gt 0){ [void]$out.Add("InpRiskPercent=" + $RischioSonda.ToString("0.####",$INV)) }
            else                   { [void]$out.Add($r) }
          }
        default       { [void]$out.Add($r) }
      }
    }
    $inputs = ($out -join "`r`n")
    # --- gate sullo STATO FINALE (checklist 33): niente sweep residui.
    #  >>> OGNI $ DI UNA REGEX MULTILINEA SI SCRIVE \r?$ (checklist 40).
    if($inputs -match '\|\|'){ throw "PASSO 0: nell'ini e' rimasto uno sweep '||'. Sarebbe un'ottimizzazione, non una passata singola -- e in ottimizzazione le Print non le legge nessuno (checklist 34)." }
    if($inputs -notmatch '(?m)^InpSLMode=2\r?$'){ throw "PASSO 0: InpSLMode non e' 2 (FIXED). Senza FIXED la distanza dello stop non e' InpSLFixedPts*_Point e la conversione NON e' misurabile." }
    if($inputs -notmatch '(?m)^InpVerbose=1\r?$'){ throw "PASSO 0: InpVerbose non e' 1: le righe 'BUY STOP @ ... SL ...' non verrebbero stampate e il gate non avrebbe niente da leggere." }
    if($inputs -notmatch ('(?m)^InpSLFixedPts=' + [regex]::Escape($PtsGateStr) + '\r?$')){ throw ("PASSO 0: InpSLFixedPts non e' " + $PtsGateStr + " nell'ini derivato.") }
    if($inputs -notmatch ('(?m)^InpMagic=' + $magic + '\r?$')){ throw ("PASSO 0: InpMagic non e' stato pinnato a " + $magic) }
    foreach($mg in $magicVisti){
      if($inputs -match ('(?m)^InpMagic=' + $mg + '\r?$')){ throw "PASSO 0: sta girando con un magic della GRIGLIA. Le due fasi non condividono il magic." }
    }
    #  E il CONTEGGIO: la derivazione deve produrre ESATTAMENTE i parametri
    #  ($RigheAttese meno le 3 direttive @). Uno in meno = una riga persa nel
    #  filtro, uno in piu' = ne ha aggiunte.
    $nPar = @($out).Count
    if($nPar -ne ($RigheAttese - 3)){ throw ("PASSO 0: l'ini derivato ha " + $nPar + " parametri invece di " + ($RigheAttese - 3) + ".") }
    $testo = @"
[Charts]
MaxBars=2000000000

[Experts]
AllowLiveTrading=false
AllowDllImport=false

[Tester]
Expert=$Ea.ex5
Symbol=$Sym
Period=$Periodo
Model=$Modello
Spread=$SpreadIni
Optimization=0
FromDate=$DaQuando
ToDate=$Fino
ForwardMode=0
Deposit=$Deposito
Currency=EUR
Leverage=100
ExecutionMode=0
ReplaceReport=1
ShutdownTerminal=1
Report=OptReport_R97_passo0_$magic

[TesterInputs]
$inputs
"@
    Set-Content -LiteralPath $dest -Value $testo -Encoding ASCII
  }

  $iniA = Join-Path $Work "passo0_a.ini"; IniPasso0 $MagicA $iniA
  $iniB = Join-Path $Work "passo0_b.ini"; IniPasso0 $MagicB $iniB
  Copy-Item -LiteralPath $iniA -Destination (Join-Path $Sosta "passo0_a.ini") -Force
  Copy-Item -LiteralPath $iniB -Destination (Join-Path $Sosta "passo0_b.ini") -Force
  Write-Host ("    anteprima [TesterInputs] della passata A (" + ($RigheAttese - 3) + " parametri attesi):") -ForegroundColor DarkGray
  Get-Content -LiteralPath $iniA | Select-Object -Last ($RigheAttese - 2) | ForEach-Object { Write-Host ("      " + $_) -ForegroundColor DarkGray }

  if($SoloControllo){
    Dico "SoloControllo: gli ini del PASSO 0 sono scritti e verificati, MT5 NON viene aperto e la conversione NON e' misurata." "Yellow"
    [void]$Note.Add("giro a vuoto: la CONVERSIONE DEI PUNTI non e' misurata (serve MT5 aperto dal tester). Il giro a vuoto NON autorizza la lettura di nessun buffer.")
  } else {
    #  $tPasso0 marca l'inizio: i log si leggono SOLO da qui in avanti,
    #  altrimenti un log di ieri risponderebbe per la corsa di oggi.
    $tPasso0 = Get-Date
    foreach($pp in @(@($iniA,$MagicA),@($iniB,$MagicB))){
      $tp = Get-Date
      Dico ("PASSO 0: passata singola magic " + $pp[1] + " su tutta la finestra...") "Cyan"
      (Start-Process -FilePath $Terminal -ArgumentList ("/config:`"" + $pp[0] + "`"") -PassThru).WaitForExit()
      $Passo0.Minuti = [math]::Round((New-TimeSpan -Start $tp -End (Get-Date)).TotalMinutes,1)
      Dico ("  ... " + $Passo0.Minuti.ToString("0.0",$INV) + " minuti") "Gray"
    }

    # --- SOSTA CON NOME PROPRIO, SUBITO, PRIMA DEI GATE (checklist 41).
    #     L'artefatto di un gate si mette al sicuro appena prodotto: cosi'
    #     esiste anche quando il gate esce ROSSO, che e' proprio il caso in
    #     cui serve.
    foreach($m in @($MagicA,$MagicB)){
      $src = Join-Path $Comune ("abtg_trades_" + $Ea + "_" + $Sym + "_" + $m + ".csv")
      if(Test-Path -LiteralPath $src){
        Copy-Item -LiteralPath $src -Destination (Join-Path $Sosta ("passo0_pertrade_" + $m + ".csv")) -Force
      }
    }
    $ptA = Join-Path $Sosta ("passo0_pertrade_" + $MagicA + ".csv")
    $ptB = Join-Path $Sosta ("passo0_pertrade_" + $MagicB + ".csv")
    Dico ("per-trade del PASSO 0 messi in sosta in " + $Sosta) "Green"

    # =================================================================
    #  4-B. LA CONVERSIONE. E' IL GATE FIRMATO: si legge PRIMA di tutto
    #  il resto, perche' senza quel numero l'asse dei buffer e' cieco.
    # =================================================================
    $radici = @(
      (Join-Path $DataFolder "Tester"),
      (Join-Path $InstDir    "Tester"),
      (Join-Path $env:APPDATA "MetaQuotes\Tester")
    )
    $fattori = New-Object System.Collections.ArrayList
    $distanze= New-Object System.Collections.ArrayList
    $letti = 0
    foreach($rad in $radici){
      if(-not (Test-Path -LiteralPath $rad)){ continue }
      $files = @(Get-ChildItem -LiteralPath $rad -Filter "*.log" -Recurse -File -ErrorAction SilentlyContinue |
                 Where-Object { $_.LastWriteTime -ge $tPasso0 })
      foreach($lg in $files){
        $tx = ""
        try{
          #  ENCODING SCELTO DAL BOM, mai per decreto: i log MT5 sono UTF-16LE
          #  con BOM, ma non sempre. Un -Encoding fisso legge byte a caso e la
          #  ricerca esce verde per assenza (checklist 28-bis).
          $by = [IO.File]::ReadAllBytes($lg.FullName)
          if($by.Length -ge 2 -and $by[0] -eq 0xFF -and $by[1] -eq 0xFE){ $tx = [Text.Encoding]::Unicode.GetString($by) }
          elseif($by.Length -ge 3 -and $by[0] -eq 0xEF -and $by[1] -eq 0xBB -and $by[2] -eq 0xBF){ $tx = [Text.Encoding]::UTF8.GetString($by) }
          else{ $tx = [Text.Encoding]::Default.GetString($by) }
        }catch{ continue }
        $letti++
        #  LA RIGA VERA la scrive ABTG_ORB_Ottimizzato v1.02 (TryPlace):
        #    Log("BUY STOP @ %.5f SL %.5f TP %.5f lot %.2f")
        #  e Log() antepone "[ORB_OTT] ". Il pattern e' preso DAL SORGENTE
        #  che lo produce, non dalla memoria (checklist 55).
        foreach($mm in [regex]::Matches($tx,'\[ORB_OTT\]\s+(BUY|SELL) STOP @ ([0-9]+\.[0-9]+) SL ([0-9]+\.[0-9]+) TP ([0-9]+\.[0-9]+) lot ([0-9]+\.[0-9]+)')){
          $entry = [double]::Parse($mm.Groups[2].Value,$INV)
          $sl    = [double]::Parse($mm.Groups[3].Value,$INV)
          $d = [math]::Abs($entry - $sl)
          if($d -le 0){ continue }
          [void]$distanze.Add($d)
          [void]$fattori.Add($PtsGateProva / $d)
        }
      }
    }
    $Passo0.LogLetti = $letti
    $Passo0.Ordini   = $fattori.Count
    if($letti -eq 0){
      $Fatale = "PASSO 0 / CONVERSIONE: ZERO log del tester letti nelle tre radici dopo l'avvio delle passate. La conversione NON e' stata misurata, e senza quel numero i criteri (par. 3) vietano di lanciare qualunque passata."
    }
    elseif($fattori.Count -eq 0){
      #  CONTROLLO POSITIVO (checklist 55): "0 righe cattive" e "0 righe
      #  capite" non possono finire nello stesso ramo.
      $Fatale = "PASSO 0 / CONVERSIONE: " + $letti + " log letti ma NESSUNA riga '[ORB_OTT] ... STOP @ ... SL ...'. Le cause possibili sono TRE e vanno distinte prima di rilanciare: " +
                "(1) l'EA non ha piazzato nemmeno un ordine in 21 mesi -> il motore e' MUTO su " + $Sym + ", non brutto (guarda i log del tester nello zip); " +
                "(2) gli ordini sono stati RIFIUTATI per margine: la sonda gira in modo FIXED, che e' lo stop piu' STRETTO del round e quindi il LOTTO PIU' GRANDE -> rilancia con -RischioSonda 0.10, che abbassa il rischio SOLO nella sonda e non tocca le celle firmate; " +
                "(3) InpVerbose non e' arrivato acceso. In tutti e tre i casi NON e' un via libera."
    }
    else{
      $medD = Mediana $distanze
      $medF = Mediana $fattori
      $Passo0.DistMediana   = [math]::Round($medD,5)
      $Passo0.FattoreGrezzo = [math]::Round($medF,4)
      #  IL FATTORE E' 1/_Point, quindi una POTENZA DI DIECI: si classifica
      #  ogni ordine sulla potenza piu' vicina e si guarda quanti sono
      #  D'ACCORDO. Un min/max secco boccerebbe tutto il round per UN solo
      #  ordine clampato dallo STOPS_LEVEL; un consenso no, e dice pure
      #  quanti sono i dissidenti (che finiscono nelle NOTE).
      $gruppi = @{}
      foreach($f in $fattori){
        $e = [int][math]::Round([math]::Log10([double]$f))
        if($gruppi.ContainsKey($e)){ $gruppi[$e] = $gruppi[$e] + 1 } else { $gruppi[$e] = 1 }
      }
      $espTop = -999; $nTop = 0
      foreach($k in $gruppi.Keys){ if($gruppi[$k] -gt $nTop){ $nTop = $gruppi[$k]; $espTop = $k } }
      $quota = [double]$nTop / [double]$fattori.Count
      $cand  = [math]::Pow(10,$espTop)
      if($quota -lt 0.90){
        $Fatale = "PASSO 0 / CONVERSIONE: le " + $fattori.Count + " misure NON concordano: solo " + $nTop +
                  " (" + [math]::Round($quota*100,1) + "%) danno lo stesso ordine di grandezza. In modo FIXED la distanza dello stop deve essere sempre la stessa: se non lo e', c'e' di mezzo lo STOPS_LEVEL o un arrotondamento grosso. Il numero NON e' affidabile e non tiro a indovinare."
      }
      elseif([math]::Abs($medF - $cand) / $cand -gt 0.05){
        $Fatale = "PASSO 0 / CONVERSIONE: il fattore misurato e' " + $medF.ToString("0.####",$INV) +
                  ", che NON e' una potenza di dieci (la piu' vicina e' " + $cand + ") a meno del 5%. _Point vale 10^-digits: un numero cosi' vuol dire che sto misurando un'altra cosa. Mi fermo."
      }
      else{
        $Passo0.Fattore = $cand
        $Passo0.Conversione = "1 punto indice = " + $cand + " punti MT5   (_Point = " + (1.0/$cand).ToString("0.#####",$INV) + ")"
        [void]$Note.Add("CONVERSIONE MISURATA su " + $Sym + ": " + $Passo0.Conversione +
                        "  [misura 1: " + $fattori.Count + " ordini in modo FIXED, " + $nTop + " d'accordo (" +
                        [math]::Round($quota*100,1) + "%), distanza mediana " + $medD.ToString("0.#####",$INV) +
                        " di prezzo per " + $PtsGateStr + " punti]")
        if($nTop -lt $fattori.Count){
          [void]$Note.Add("CONVERSIONE: " + ($fattori.Count - $nTop) + " ordini su " + $fattori.Count +
                          " danno una distanza diversa dagli altri (probabile STOPS_LEVEL su quel giorno). Non cambiano il fattore, ma sono agli atti.")
        }
      }
    }
    # --- SECONDA MISURA, MECCANISMO DIVERSO: i decimali della colonna
    #     price del per-trade, che il sorgente scrive con
    #     DoubleToString(price,_Digits) -> digits, e 1/_Point = 10^digits.
    #  >>> STA FUORI DAI TRE RAMI DI SOPRA, E NON PER ELEGANZA. Prima era
    #      annidata nel ramo "la misura 1 e' riuscita", cioe' era irraggiungibile
    #      PROPRIO NEL CASO IN CUI SERVE: se gli ordini sono stati piazzati ma il
    #      log non e' stato letto (encoding, log in una quarta radice, InpVerbose
    #      non arrivato), il per-trade c'e' lo stesso e il numero si legge
    #      GRATIS da li'. Senza questa lettura il rilancio sarebbe alla cieca:
    #      un altro giro di macchina per sapere una cosa gia' sul disco.
    #  >>> NON APRE IL GATE: $Fatale resta com'e'. La firma chiede DUE misure
    #      che concordano, e una sola non e' un via libera (checklist 55).
    if(Test-Path -LiteralPath $ptA){
      $righeP = @(Get-Content -LiteralPath $ptA)
      $dg = -1
      for($i=1;$i -lt $righeP.Count;$i++){
        $col = ($righeP[$i] -split ';')
        if($col.Count -lt 8){ continue }
        $pz = ("" + $col[6]).Trim()
        if($pz -match '^\d+\.(\d+)$'){ $dg = $Matches[1].Length; break }
      }
      if($dg -ge 0){
        $Passo0.Digits = $dg
        $Passo0.FattoreDaDigits = [math]::Pow(10,$dg)
        if($Passo0.Fattore -gt 0 -and $Passo0.FattoreDaDigits -ne $Passo0.Fattore -and $Fatale -eq ""){
          $Fatale = "PASSO 0 / CONVERSIONE: le DUE misure indipendenti non dicono la stessa cosa. Dagli ordini FIXED esce " +
                    $Passo0.Fattore + ", dai decimali del per-trade (digits=" + $dg + ") esce " + $Passo0.FattoreDaDigits +
                    ". Finche' non si capisce quale delle due mente, non si misura niente."
        }
        if($Passo0.Fattore -le 0){
          [void]$Note.Add("PASSO 0 / CONVERSIONE: la misura 1 (dal log) NON c'e', ma i decimali del per-trade dicono digits=" + $dg +
                          " -> fattore " + $Passo0.FattoreDaDigits + ". QUESTO NON E' UN VIA LIBERA (la firma chiede DUE misure che" +
                          " concordano, qui ce n'e' una sola e il round resta fermo), ma dice se vale la pena rilanciare: se questo" +
                          " numero e' " + $FattoreAtteso + ", allora gli ordini sono stati piazzati e il guasto e' SOLO nella lettura del log.")
        }
      } else {
        [void]$Problemi.Add("PASSO 0 / CONVERSIONE: non sono riuscito a leggere i decimali della colonna price nel per-trade: la seconda misura (di controllo) NON e' stata fatta. Resta la prima, che e' il gate.")
      }
    }
    # --- E ADESSO IL CONFRONTO CON QUELLO CHE I FILE PROVA ASSUMONO.
    #     Qui la corsa PUO' essere riuscita benissimo e la risposta non
    #     piacerci (checklist 26-bis): si ferma la GRIGLIA, non la
    #     raccolta -- il numero misurato e' gia' il risultato del PASSO 0
    #     e finisce nel referto e nello zip.
    if($Fatale -eq "" -and $Passo0.Fattore -gt 0 -and $Passo0.Fattore -ne $FattoreAtteso){
      $bufGiusto = [int]($BufferIndiceAtteso * $Passo0.Fattore)
      $Fatale = "PASSO 0 / CONVERSIONE: MISURATO 1 punto indice = " + $Passo0.Fattore + " punti MT5 su " + $Sym +
                ", NON " + $FattoreAtteso + " come su U30USD. I file prova R97b/R97c scrivono InpSLBufferPts=500 proprio perche' 500/" +
                $FattoreAtteso + " = " + $BufferIndiceAtteso + " punti indice (la cella regina di R88): col fattore misurato quel 500 varrebbe " +
                (500.0/$Passo0.Fattore).ToString("0.##",$INV) + " punti indice, cioe' un'ALTRA cella. E' l'errore di fattore dieci gia' pagato in R88. " +
                "IL VALORE CORRETTO SAREBBE InpSLBufferPts=" + $bufGiusto + ". NON lo riscrivo da solo: i file prova si rigenerano, si ri-pinna e si rifa' un giro dal verificatore. " +
                "IL NUMERO MISURATO E' NEL REFERTO E NELLO ZIP: e' il risultato del PASSO 0, non un guasto."
    }

    # =================================================================
    #  4-C. I GATE DI SEMPRE, sulle stesse due passate.
    # =================================================================
    $righeA = @()
    # --- G1: il per-trade esiste, e' di ADESSO ed e' popolato
    if($Fatale -eq ""){
      if(-not (Test-Path -LiteralPath $ptA)){
        $Fatale = "PASSO 0 / G1: nessun per-trade prodotto. O lo storico manca su " + $Sym + ", o l'EA non ha CHIUSO niente in 21 mesi."
      }
      elseif((Get-Item -LiteralPath $ptA).LastWriteTime -lt $tPasso0){
        $Fatale = "PASSO 0 / G1: il per-trade e' PIU' VECCHIO dell'avvio delle passate gemelle (" +
                  (Get-Item -LiteralPath $ptA).LastWriteTime.ToString("yyyy-MM-dd HH:mm:ss",$INV) +
                  "): l'EA non l'ha riscritto, e questo NON e' il gate di questa corsa."
      }
    }
    if($Fatale -eq ""){
      $righeA = @(Get-Content -LiteralPath $ptA)
      $Passo0.N = $righeA.Count - 1
      if($Passo0.N -lt 2){ $Fatale = "PASSO 0 / G1: il per-trade ha " + $Passo0.N + " operazioni. Non c'e' niente da misurare." }
    }
    # --- G2: la PRIMA DATA. E' il gate vero sulla copertura dei dati.
    if($Fatale -eq ""){
      $Passo0.PrimaData  = (($righeA[1] -split ';')[0]).Trim()
      $Passo0.UltimaData = (($righeA[$righeA.Count-1] -split ';')[0]).Trim()
      #  >>> IL RITORNO DI TryParse SI GUARDA (checklist 40-ter): con [void]
      #  davanti, una data illeggibile lascerebbe $d1 a MinValue, MinValue
      #  -gt <limite> e' $false e IL GATE PASSEREBBE.
      $d1 = [datetime]::MinValue; $d2 = [datetime]::MinValue
      $ok1 = [datetime]::TryParse($Passo0.PrimaData.Replace(".","-"),$INV,[Globalization.DateTimeStyles]::None,[ref]$d1)
      $ok2 = [datetime]::TryParse($Passo0.UltimaData.Replace(".","-"),$INV,[Globalization.DateTimeStyles]::None,[ref]$d2)
      if(-not $ok1 -or -not $ok2){
        $Fatale = "PASSO 0 / G2: non riesco a leggere le date del per-trade (prima='" + $Passo0.PrimaData +
                  "', ultima='" + $Passo0.UltimaData + "'). IL GATE SULLA COPERTURA NON E' STATO ESEGUITO: non e' un via libera."
      } else {
        $limite = [datetime]::ParseExact($LimiteG2,"yyyy.MM.dd",$INV)
        $Passo0.Giorni = [math]::Round(($d2-$d1).TotalDays,0)
        if($d1 -gt $limite){
          $Fatale = "PASSO 0 / G2: la prima operazione e' del " + $Passo0.PrimaData + ", oltre il limite " + $LimiteG2 + ". " +
                    "I dati NON coprono l'inizio della finestra dichiarata (" + $DaQuando + "), oppure il motore non ha operato per tre mesi: in tutti e due i casi il round non si legge cosi'."
        }
      }
    }
    # --- G3: i gemelli devono essere identici
    if($Fatale -eq ""){
      if(-not (Test-Path -LiteralPath $ptB)){ $Fatale = "PASSO 0 / G3: manca il per-trade del gemello " + $MagicB }
      else{
        $a = @(Get-Content -LiteralPath $ptA); $b = @(Get-Content -LiteralPath $ptB)
        if($a.Count -ne $b.Count){ $Fatale = "PASSO 0 / G3: i gemelli hanno " + $a.Count + " e " + $b.Count + " righe. Banco sporco." }
        else{
          $div = 0
          for($i=1;$i -lt $a.Count;$i++){
            $ca = ($a[$i] -split ';'); $cb = ($b[$i] -split ';')
            if($ca[0] -ne $cb[0] -or $ca[7] -ne $cb[7]){ $div++ }
          }
          if($div -gt 0){ $Fatale = "PASSO 0 / G3: i gemelli divergono su " + $div + " operazioni. Banco sporco, il round si ferma." }
          else{ $Passo0.Gemelli = "IDENTICI" }
        }
      }
    }
    # --- IL CANARINO DELLA FINESTRA (criteri par. 2.1), dichiarato PRIMA
    #     di guardare qualunque numero economico.
    #     >>> VA NELLE NOTE, NON NEI PROBLEMI (checklist 44): un campione
    #     sottile e' un RISULTATO del round, non un guasto della corsa.
    if($Passo0.N -gt 0){
      if($Passo0.N -lt 152){
        [void]$Note.Add("CANARINO (criteri par. 2.1): la passata intera ha " + $Passo0.N + " operazioni; il cancello S4 chiede n OOS >= 95 e n IS >= 57 (152 in tutto). Il MERITO e' SOSPESO e il round si legge per il RISCHIO (Emendamento regola B, applicata dall'inizio come prevede la firma).")
      }
      if($Passo0.N -lt 300){
        [void]$Note.Add("EMENDAMENTO DELLA FINESTRA (regola A): " + $Passo0.N + " operazioni in tutto (< 300), quindi le due meta' non possono fare 150 ciascuna. Era ATTESO (R88 sul Dow aveva IS 71 / OOS 119): e' un risultato, non un guasto.")
      }
      #  NOTA: queste operazioni sono quelle della cella FIXED del gate, che
      #  ENTRA come le celle del round (stessi ingressi) ma ESCE diversamente.
      #  E' una stima della frequenza, non il conteggio delle celle firmate.
      [void]$Note.Add("il conteggio operazioni qui sopra viene dalla cella del GATE (modo FIXED): gli INGRESSI sono gli stessi delle celle firmate, le USCITE no. Il n vero di ogni cella si legge nei CSV.")
    }

    Write-Host ""
    Write-Host "    --- ESITO DEL PASSO 0 ---" -ForegroundColor White
    Write-Host ("    CONVERSIONE ........ " + $Passo0.Conversione) -ForegroundColor Yellow
    Write-Host ("      ordini letti ..... " + $Passo0.Ordini + "   distanza mediana " + $Passo0.DistMediana.ToString("0.#####",$INV) + " di prezzo per " + $PtsGateProva + " punti") -ForegroundColor Yellow
    Write-Host ("      fattore grezzo ... " + $Passo0.FattoreGrezzo.ToString("0.####",$INV) + "   digits dal per-trade: " + $Passo0.Digits + " -> " + $Passo0.FattoreDaDigits) -ForegroundColor Yellow
    Write-Host ("      atteso ........... " + $FattoreAtteso + " (come U30USD). ATTESO non e' MISURATO: decide il numero qui sopra.") -ForegroundColor Yellow
    Write-Host ("    operazioni ......... " + $Passo0.N) -ForegroundColor White
    Write-Host ("    prima operazione ... " + $Passo0.PrimaData + "   (limite: " + $LimiteG2 + ")") -ForegroundColor White
    Write-Host ("    ultima operazione .. " + $Passo0.UltimaData) -ForegroundColor White
    Write-Host ("    gemelli ............ " + $Passo0.Gemelli + "   (log del tester letti: " + $Passo0.LogLetti + ")") -ForegroundColor White
    Write-Host ("    durata 1 passata ... " + $Passo0.Minuti.ToString("0.0",$INV) + " min su TUTTA la finestra") -ForegroundColor Yellow
    Write-Host ("    tetto teorico x" + (4*$Lavori.Count) + " .. " + ([math]::Round($Passo0.Minuti*4*$Lavori.Count/60,1)).ToString("0.0",$INV) + " ore -- NON E' UNA PREVISIONE:") -ForegroundColor Yellow
    Write-Host  "                         le passate della griglia coprono META' finestra l'una" -ForegroundColor Yellow
    Write-Host  "                         (IS o OOS) e MT5 le distribuisce sugli agent in parallelo." -ForegroundColor Yellow
    Write-Host ("    -OreMax e' " + $OreMax.ToString("0.0",$INV) + " h: e' un TETTO sull'INIZIO di nuovi file,") -ForegroundColor Yellow
    Write-Host  "                         non una stima e non un'interruzione." -ForegroundColor Yellow
    $Passo0.Fatto = $true

    if($Fatale -ne ""){ throw $Fatale }
    Dico "PASSO 0 SUPERATO: si parte." "Green"
  }
}

# =====================================================================
#  5. LA CATENA. Uno alla volta. Mai in parallelo.
# =====================================================================
Titolo ("5. LA CATENA - " + $Lavori.Count + " file, uno alla volta")
$idx = 0
foreach($l in $Lavori){
  $idx++
  $trascorse = (New-TimeSpan -Start $Avvio -End (Get-Date)).TotalHours
  if($trascorse -ge $OreMax){
    $l.Esito = "NON INIZIATO (tetto ore raggiunto)"
    [void]$Problemi.Add("TEMPO SCADUTO prima di " + $l.Prova + ": il round NON e' completo.")
    continue
  }
  Write-Host ""
  Write-Host "------------------------------------------------------------------" -ForegroundColor Cyan
  Write-Host ("  [" + $idx + "/" + $Lavori.Count + "]  " + $l.Prova) -ForegroundColor Cyan
  Write-Host ("           " + $l.Cella) -ForegroundColor Cyan
  Write-Host "------------------------------------------------------------------" -ForegroundColor Cyan
  $tl = Get-Date
  #  -Terminal e -DataFolder passati ESPLICITI (checklist 37): il driver
  #  altrimenti ri-cerca il terminale per conto suo, e potrebbe trovarne uno
  #  diverso da quello su cui abbiamo compilato e girato il PASSO 0.
  $arg = @("-ExecutionPolicy","Bypass","-File",$Driver,
           "-Expert",$Ea,"-Prova",(Join-Path $Prove $l.Prova),
           "-Simbolo",$Sym,"-Periodo",$Periodo,
           "-DaQuando",$DaQuando,"-Fino",$Fino,
           "-Etichetta",$l.Et,"-Modello",("" + $Modello),
           "-Deposito",("" + $Deposito),"-Spread",("" + $SpreadIni),
           "-Terminal",$Terminal,"-MetaEditor",$MetaEditor,"-DataFolder",$DataFolder)
  if($Rifai){ $arg += "-Rifai" }
  if($SoloControllo){ $arg += "-SoloControllo" }
  $global:LASTEXITCODE = 0
  try{
    & powershell.exe $arg 2>&1 | Tee-Object -FilePath (Join-Path $Logs ($l.Et + ".txt")) | Out-Host
  }catch{
    [void]$Problemi.Add($l.Prova + ": il driver e' uscito con eccezione - " + $_.Exception.Message)
  }
  if($LASTEXITCODE -ne 0){
    [void]$Problemi.Add($l.Prova + ": il driver e' uscito con codice " + $LASTEXITCODE)
  }
  $l.Min = [math]::Round((New-TimeSpan -Start $tl -End (Get-Date)).TotalMinutes,1)
  if(-not $SoloControllo){
    #  >>> UN CSV VECCHIO NON E' UN CSV OK: SI GUARDA LA DATA. <<<
    #  walkforward_generico.ps1 SALTA la finestra il cui CSV esiste gia'
    #  ("gia' fatto, salto"), e questa riga PRESCRIVE quel percorso (-OreMax
    #  che ferma a meta', -SaltaPasso0 per riprendere). Contando solo le righe,
    #  un file di un lancio precedente passerebbe per OK - e se fra i due lanci
    #  fosse cambiato il pin, META' ROUND VERREBBE DA UN ALTRO MOTORE.
    #  >>> E GLI STATI SONO TRE, NON DUE (checklist 49): il driver salta per
    #      FINESTRA, non per cella.
    $vecchie = @()
    foreach($tag in @("IS","OOS")){
      $p = CsvDi $l $tag
      $n = -1
      if(Test-Path -LiteralPath $p){
        $n = (@(Get-Content -LiteralPath $p).Count) - 1
        if((Get-Item -LiteralPath $p).LastWriteTime -lt $tl){ $vecchie += $tag }
      }
      if($tag -eq "IS"){ $l.IS = $n } else { $l.OOS = $n }
    }
    if($vecchie.Count -eq 2){
      $l.Esito = "SALTATO DAL DRIVER (IS+OOS gia' presenti da un lancio precedente)"
      [void]$Problemi.Add($l.Prova + ": " + $l.Esito + ". Le righe tornano ma i file NON sono di questo lancio: rilancia con -Rifai.")
    }
    elseif($vecchie.Count -eq 1){
      $l.Esito = "A META' (" + $vecchie[0] + " e' di un lancio PRECEDENTE, l'altra gamba e' di adesso)"
      [void]$Problemi.Add($l.Prova + ": " + $l.Esito + ". Le due gambe vengono da due giri diversi: la cache era stata svuotata ALLORA, non adesso. Rilancia questa cella con -Rifai.")
    }
    elseif($l.IS -eq $CelleAttese -and $l.OOS -eq $CelleAttese){ $l.Esito = "OK" }
    else{
      $l.Esito = "RIGHE SBAGLIATE (IS " + $l.IS + " / OOS " + $l.OOS + ", attese " + $CelleAttese + ")"
      [void]$Problemi.Add($l.Prova + ": " + $l.Esito + ". Cache del tester, oppure lo sweep dei magic non ha spazzolato: il file NON si legge.")
    }
  } else { $l.Esito = "SOLO CONTROLLO" }
  # --- L'ANTEPRIMA del giro a vuoto. Il driver la scrive sempre con lo stesso
  #     nome (anteprima_<EA>_<Simbolo>.ini, SENZA etichetta) e qui i file
  #     girano TUTTI sullo stesso simbolo: senza metterla in sosta subito, ne
  #     resterebbe UNA sola e sarebbe l'ultima (checklist 31).
  if($SoloControllo){
    $ant = Join-Path $Work ("anteprima_" + $Ea + "_" + $Sym + ".ini")
    if(Test-Path -LiteralPath $ant){
      Copy-Item -LiteralPath $ant -Destination (Join-Path $Sosta ("anteprima_" + $l.Et + ".ini")) -Force
      Remove-Item -LiteralPath $ant -Force -ErrorAction SilentlyContinue
    } else { [void]$Problemi.Add("giro a vuoto: nessuna anteprima .ini per " + $l.Prova) }
  }
  Write-Host ("    esito: " + $l.Esito + "   [" + $l.Min.ToString("0.0",$INV) + " min]") -ForegroundColor Gray
}

if($SoloControllo){
  $nAnt = @(Get-ChildItem -LiteralPath $Sosta -Filter "anteprima_r97*.ini" -ErrorAction SilentlyContinue).Count
  if($nAnt -ne $Lavori.Count){ [void]$Problemi.Add("giro a vuoto: " + $nAnt + " anteprime .ini invece di " + $Lavori.Count + ".") }
  Write-Host ""
  Write-Host ("    anteprime .ini in sosta: " + $nAnt + " su " + $Lavori.Count + "   -> " + $Sosta) -ForegroundColor White
  Write-Host "    >>> COSA SI LEGGE NELL'ANTEPRIMA, e cosa no:" -ForegroundColor Yellow
  Write-Host "        SI LEGGE: FromDate/ToDate (le finestre IS/OOS vere, calcolate dal" -ForegroundColor Yellow
  Write-Host "          driver: sono quelle che vanno copiate nel referto), il blocco" -ForegroundColor Yellow
  Write-Host "          [TesterInputs] e il numero delle celle (deve dire 2)." -ForegroundColor Yellow
  Write-Host "        NON SI LEGGE: 'Model=4' e' una COSTANTE scritta a mano nel ramo" -ForegroundColor Yellow
  Write-Host "          di prova del driver (cercare 'Model=4' in walkforward_generico)." -ForegroundColor Yellow
  Write-Host "          Stavolta COINCIDE con la corsa vera (-Modello 4), quindi non" -ForegroundColor Yellow
  Write-Host "          mente -- ma resta una costante, non una conferma." -ForegroundColor Yellow
}

}catch{
  $Fatale = $_.Exception.Message
  Write-Host ""
  Write-Host ("!!! FERMATO: " + $Fatale) -ForegroundColor Red
}

# =====================================================================
#  6. RACCOLTA. Si fa SEMPRE, anche a esito parziale o fermato.
# =====================================================================
Titolo "6. RACCOLTA SUL DESKTOP"
#  >>> OGNI ARTEFATTO DICE IN QUALE MODO E' STATO PRODOTTO (checklist 50). <<<
$Modo = if($SoloControllo){ "CONTROLLO" } elseif($SaltaPasso0){ "SENZAPASSO0" } else { "CORSA" }
if($ConD){ $Modo = $Modo + "_COND" }
$Cart = Join-Path $Dsk ("R97_ORB_NASUSD_" + $Modo + "_" + $Stamp)
$Zip  = Join-Path $Dsk ("R97_ORB_NASUSD_" + $Modo + "_" + $Stamp + ".zip")
$Referto = Join-Path $Cart "REFERTO_R97.txt"
try{
  New-Item -ItemType Directory -Force -Path $Cart | Out-Null
  foreach($l in $Lavori){
    foreach($tag in @("IS","OOS")){
      $src = CsvDi $l $tag
      if(Test-Path -LiteralPath $src){ Copy-Item -LiteralPath $src -Destination (Join-Path $Cart (Split-Path -Leaf $src)) -Force }
    }
  }
  #  DALLA SOSTA, non da Common\Files: li' dentro i file col magic della
  #  griglia sono stati riscritti a ogni passata.
  if($Sosta -and (Test-Path -LiteralPath $Sosta)){
    foreach($f in @(Get-ChildItem -LiteralPath $Sosta -File -ErrorAction SilentlyContinue)){
      Copy-Item -LiteralPath $f.FullName -Destination (Join-Path $Cart $f.Name) -Force
    }
  }
  #  e i per-trade della GRIGLIA, per NOME (mai un wildcard che prenderebbe
  #  anche la sedia viva): servono al confronto fra le celle.
  if(-not $SoloControllo -and (Test-Path -LiteralPath $Comune)){
    foreach($l in $Lavori){
      foreach($m in @($l.Magic,($l.Magic+1))){
        $f = Join-Path $Comune ("abtg_trades_" + $Ea + "_" + $Sym + "_" + $m + ".csv")
        if(Test-Path -LiteralPath $f){ Copy-Item -LiteralPath $f -Destination (Join-Path $Cart (Split-Path -Leaf $f)) -Force }
      }
    }
  }

  $R = New-Object System.Collections.ArrayList
  [void]$R.Add("REFERTO R97 - LO STOP ALL'ESTREMO OPPOSTO DEL RANGE SU NASUSD (M5, TICK REALI)")
  [void]$R.Add("modo: " + $Modo + $(if($SoloControllo){ "   <<< GIRO A VUOTO: NESSUNA passata, NESSUN CSV, NESSUN numero di round qui dentro" } else { "" }))
  $sw = @()
  if($SoloControllo){ $sw += "-SoloControllo (nessuna passata)" }
  if($SaltaPasso0)  { $sw += "-SaltaPasso0 (CONVERSIONE NON MISURATA: la firma chiede il contrario)" }
  if($ConD)         { $sw += "-ConD (gira anche R97d, CHE NON E' FIRMATA)" }
  if($RischioSonda -gt 0){ $sw += "-RischioSonda " + $RischioSonda.ToString("0.####",$INV) + " (SOLO la sonda del PASSO 0: le celle firmate girano col rischio del file prova)" }
  if($Rifai)        { $sw += "-Rifai (i CSV precedenti sono stati rifatti)" }
  if($sw.Count -eq 0){ $sw += "nessuno (corsa piena, PASSO 0 eseguito, ripresa dei CSV gia' presenti ATTIVA)" }
  [void]$R.Add("switch di questo giro: " + ($sw -join " | "))
  [void]$R.Add("     Senza -Rifai il driver SALTA le finestre gia' presenti. I file saltati sono")
  [void]$R.Add("     marcati 'SALTATO DAL DRIVER' o 'A META'' e finiscono nei PROBLEMI, non in OK.")
  [void]$R.Add("EA: " + $Ea + "  version letta dal sorgente: " + $VersioneLetta + " (attesa " + $VersioneAttesa + ")")
  [void]$R.Add("spread: Spread=" + $SpreadIni + " scritto NELL'INI = spread CORRENTE del feed BCM, dichiarato.")
  [void]$R.Add("     NON e' uno stress di spread, e lo spread NON e' misurato.")
  [void]$R.Add("data: " + (Get-Date).ToString("yyyy-MM-dd HH:mm:ss",$INV) + "   (questa data deve essere di ADESSO)")
  [void]$R.Add("     ATTENZIONE: la data fresca NON distingue un giro a vuoto da una corsa.")
  [void]$R.Add("     Quello che lo distingue e' la riga 'modo:' qui sopra e il NOME della cartella.")
  [void]$R.Add("avvio: " + $Avvio.ToString("yyyy-MM-dd HH:mm:ss",$INV) + "   durata: " + ((New-TimeSpan -Start $Avvio -End (Get-Date)).TotalHours).ToString("0.0",$INV) + " ore")
  [void]$R.Add("pin: " + $Pin)
  [void]$R.Add("criteri: risultati_archivio\R97_CRITERI.md   (FIRMATI il 21/08/2026)")
  [void]$R.Add("")
  [void]$R.Add("--- IL GATE FIRMATO: LA CONVERSIONE DEI PUNTI (criteri par. 3) ---")
  [void]$R.Add("  " + $Passo0.Conversione)
  [void]$R.Add("  misura 1 (il gate) : " + $Passo0.Ordini + " ordini in modo FIXED (InpSLFixedPts=" + $Passo0.PtsGate + "),")
  [void]$R.Add("                       distanza mediana " + $Passo0.DistMediana.ToString("0.#####",$INV) + " di prezzo -> fattore grezzo " + $Passo0.FattoreGrezzo.ToString("0.####",$INV))
  [void]$R.Add("  misura 2 (controllo): digits del per-trade = " + $Passo0.Digits + " -> fattore " + $Passo0.FattoreDaDigits)
  [void]$R.Add("  atteso (U30USD)    : " + $FattoreAtteso + ".  ATTESO NON E' MISURATO: qui decide il numero misurato.")
  [void]$R.Add("  >>> COME SI USA QUESTO NUMERO: InpSLBufferPts delle celle R97b/R97c e'")
  [void]$R.Add("      500 PUNTI MT5. In punti INDICE vale 500 / (fattore). Con fattore 100")
  [void]$R.Add("      sono 5 punti indice, cioe' la cella regina di R88. Ogni riga di")
  [void]$R.Add("      referto che parla del buffer deve portarsi dietro questa conversione.")
  [void]$R.Add("")
  [void]$R.Add("--- PASSO 0 (gli altri gate) ---")
  [void]$R.Add("  0-A barre .......... " + $Storico.Esito + "   (chiesto dal " + $DaQuando + ", cioe' la finestra dichiarata)")
  [void]$R.Add("      I TICK non sono stati riscaricati: sono gia' MISURATI e agli atti")
  [void]$R.Add("      (NASUSD 164.636.788 dal 2024.09.26, REFERTO_R83_R84_PREPARAZIONE riga 620).")
  [void]$R.Add("  0-C eseguito ....... " + $Passo0.Fatto)
  [void]$R.Add("  operazioni ......... " + $Passo0.N + "   (cella del GATE, modo FIXED: stessi INGRESSI delle celle firmate, uscite diverse)")
  [void]$R.Add("  prima operazione ... " + $Passo0.PrimaData + "   (limite dei criteri: " + $LimiteG2 + ")")
  [void]$R.Add("  ultima operazione .. " + $Passo0.UltimaData)
  [void]$R.Add("  gemelli ............ " + $Passo0.Gemelli + "   (log del tester letti: " + $Passo0.LogLetti + ")")
  [void]$R.Add("     NOTA: 'NON MISURATA' / 'NON LETTO' NON e' 'va bene'. Un gate che non")
  [void]$R.Add("     legge niente non e' un gate verde, ed e' un esito FATALE.")
  [void]$R.Add("")
  [void]$R.Add("--- LAVORI ---   (attese: " + $CelleAttese + " righe per CSV, " + (2*$Lavori.Count) + " CSV, " + (4*$Lavori.Count) + " passate)")
  [void]$R.Add(("{0,-38} {1,-6} {2,-5} {3,-5} {4,-8} {5}" -f "FILE","ET","IS","OOS","MIN","ESITO"))
  foreach($l in $Lavori){
    [void]$R.Add(("{0,-38} {1,-6} {2,-5} {3,-5} {4,-8} {5}" -f $l.Prova,$l.Et,$l.IS,$l.OOS,$l.Min.ToString("0.0",$INV),$l.Esito))
  }
  [void]$R.Add("")
  [void]$R.Add("--- LE CELLE, COME SONO SCRITTE NEI FILE CHE HANNO GIRATO ---")
  foreach($l in $Lavori){
    [void]$R.Add(("  {0,-6} SLMode={1}  Buffer={2} pt  TPMode={3}  TP_R={4}  magic {5}/{6}  {7}" -f $l.Et,$l.SLMode,$l.Buf,$l.TPMode,$l.TPR,$l.Magic,($l.Magic+1),$(if($l.Firmata){ "" } else { "<<< NON FIRMATA" })))
  }
  [void]$R.Add("")
  [void]$R.Add("--- I PER-TRADE DELLE CELLE (abtg_trades_..._7797xx.csv): COSA COPRONO ---")
  [void]$R.Add("  L'EA li riscrive a OGNI passata sullo stesso nome (magic), e le due")
  [void]$R.Add("  finestre girano IN ORDINE: prima IS, poi OOS. Quelli nello zip")
  [void]$R.Add("  contengono quindi SOLO LA FINESTRA OOS: l'OOS ha sovrascritto l'IS.")
  [void]$R.Add("  NON sono la serie completa del round e NON si usano cosi' per un DD")
  [void]$R.Add("  di portafoglio. I numeri di round si leggono nei CSV IS/OOS.")
  [void]$R.Add("  (I due del PASSO 0, passo0_pertrade_7797 00/01, coprono invece TUTTA la")
  [void]$R.Add("   finestra: erano passate singole su 2024.09.26 -> " + $Fino + ".)")
  [void]$R.Add("")
  [void]$R.Add("--- COME SI LEGGE (e in che ordine) ---")
  [void]$R.Add("  1. la CONVERSIONE qui sopra. Se non e' misurata, nessun numero sul")
  [void]$R.Add("     buffer vuol dire niente (criteri par. 3, coperto dalla firma).")
  [void]$R.Add("  2. il PASSO 0. Se e' rosso, i numeri sotto NON esistono.")
  [void]$R.Add("  3. R97-rif PER PRIMA, e da sola: e' la geometria della sedia VIVA sul")
  [void]$R.Add("     Dow trasferita qui. Il suo DD OOS FISSA la soglia della bocciatura")
  [void]$R.Add("     secca (2x, criteri par. 5) e va scritta PRIMA di leggere a/b/c.")
  [void]$R.Add("  4. poi i 4 cancelli S1-S4 (DD OOS <= 7,00% | PF OOS >= 1,40 | IS")
  [void]$R.Add("     profit > 0 e PF IS >= 1,10 | n OOS >= 95 e n IS >= 57).")
  [void]$R.Add("  5. il CANARINO par. 2.1: se n IS e' sotto ~100 il MERITO e' SOSPESO e")
  [void]$R.Add("     si legge il RISCHIO (Emendamento regola B, applicata DALL'INIZIO).")
  [void]$R.Add("     Il n va scritto ACCANTO A OGNI NUMERO, sempre.")
  [void]$R.Add("  6. R97b e R97c insieme: se dicono cose opposte, quello di b e' un")
  [void]$R.Add("     PUNTO SINGOLO e non un altopiano -- e un punto singolo non si")
  [void]$R.Add("     promuove (centro dell'altopiano, mai il picco).")
  [void]$R.Add("  7. REGIME: UNO SOLO (indici USA 2024-2026, prevalentemente rialzista).")
  [void]$R.Add("     R97 misura TRASFERIBILITA' dentro un regime, non robustezza di regime.")
  [void]$R.Add("  8. R97 NON PRODUCE SEDIE (criteri par. 6). Al massimo una PROPOSTA di")
  [void]$R.Add("     round di deploy, con magic nuovo e MAI 770201.")
  if($ConD){
    [void]$R.Add("  9. R97d E' FUORI FIRMA: la firma del 21/08 dice 'resta ESCLUSA per ora'.")
    [void]$R.Add("     I suoi numeri si leggono solo se esiste un'approvazione a parte, e")
    [void]$R.Add("     comunque le si applica il cancello S3 come a tutte le altre.")
  }
  [void]$R.Add("")
  [void]$R.Add("--- NOTE ---")
  if($Note.Count -eq 0){ [void]$R.Add("  (nessuna)") }
  foreach($n in $Note){ [void]$R.Add("  - " + $n) }
  [void]$R.Add("")
  [void]$R.Add("--- PROBLEMI ---")
  if($Problemi.Count -eq 0){ [void]$R.Add("  (nessuno)") }
  foreach($p in $Problemi){ [void]$R.Add("  - " + $p) }
  [void]$R.Add("")
  if($Fatale -ne ""){ [void]$R.Add("ESITO: FERMATO -- " + $Fatale) }
  elseif($SoloControllo){
    if($Problemi.Count -gt 0){
      [void]$R.Add("ESITO: GIRO A VUOTO CON PROBLEMI -- " + $Problemi.Count + " problemi nell'elenco qui sopra.")
      [void]$R.Add("       NESSUNA passata, NESSUN CSV. Anteprime .ini prodotte: " + $nAnt + " su " + $Lavori.Count + ".")
      [void]$R.Add("       IL CONTROLLO NON E' PASSATO: la corsa vera NON si lancia finche'")
      [void]$R.Add("       l'elenco dei PROBLEMI non e' vuoto.")
    }
    else{
      [void]$R.Add("ESITO: GIRO A VUOTO COMPLETATO -- NESSUNA passata, NESSUN CSV, NESSUN")
      [void]$R.Add("       numero di round in questo file. Anteprime .ini prodotte: " + $nAnt + " su " + $Lavori.Count + ".")
      [void]$R.Add("       E NESSUNA CONVERSIONE: quella si misura solo nella corsa vera.")
      [void]$R.Add("       QUESTO ZIP NON E' IL ROUND: non va mandato come risultato.")
    }
  }
  else{
    $ko = @($Lavori | Where-Object { $_.Esito -ne "OK" -and $_.Esito -ne "SOLO CONTROLLO" })
    if($ko.Count -gt 0 -or $Problemi.Count -gt 0){
      [void]$R.Add("ESITO: PARZIALE -- " + $ko.Count + " file su " + $Lavori.Count + " non sono OK, e " + $Problemi.Count + " problemi in elenco. NON e' un round completo.")
    }
    else{ [void]$R.Add("ESITO: OK -- tutti i file hanno prodotto le righe attese, nessun problema in elenco.") }
  }
  Set-Content -LiteralPath $Referto -Value $R -Encoding ASCII

  Remove-Item -LiteralPath $Zip -Force -ErrorAction SilentlyContinue
  Compress-Archive -Path (Join-Path $Cart "*") -DestinationPath $Zip -Force
  Dico ("zip pronto: " + $Zip) "Green"
}catch{
  Write-Host ("!! raccolta incompleta: " + $_.Exception.Message) -ForegroundColor Red
}

# =====================================================================
#  7. COSA DEVE VEDERE CLAUDIO SULLO SCHERMO
# =====================================================================
Write-Host ""
Write-Host "=====================================================================" -ForegroundColor White
Write-Host "  FINITO. File da verificare, uno per uno:" -ForegroundColor White
#  >>> NON SI ANNUNCIA UN ARTEFATTO CHE NON ESISTE (checklist 22). <<<
function Riga3($path,$coda){
  if(Test-Path -LiteralPath $path){ Write-Host ("   " + $path + "   " + $coda) -ForegroundColor White }
  else                            { Write-Host ("   " + $path + "   <<< NON ESISTE") -ForegroundColor Red }
}
Riga3 $Cart    ""
Riga3 $Zip     "<- e' questo che mi mandi"
Riga3 $Referto "<- la riga 'data:' deve essere di ADESSO, la riga 'modo:' dice se e' il round o un giro a vuoto"
Write-Host "=====================================================================" -ForegroundColor White
#  >>> L'ETICHETTA NON PUO' DIRE "MISURATA" QUANDO NON LO E' (checklist 47 e 50).
#      Nel giro a vuoto e con -SaltaPasso0 questa riga stampava
#      "CONVERSIONE MISURATA: NON MISURATA": la riga del gate FIRMATO che si
#      contraddice da sola, sull'ultima schermata, che e' quella che si legge.
if($Passo0.Fattore -gt 0){
  Write-Host ("  CONVERSIONE MISURATA: " + $Passo0.Conversione) -ForegroundColor Yellow
} else {
  Write-Host ("  CONVERSIONE: " + $Passo0.Conversione + "   <<< il gate FIRMATO non ha un numero:") -ForegroundColor Red
  Write-Host  "                nessuna riga sul buffer si legge (criteri par. 3)." -ForegroundColor Red
}
if($SoloControllo){
  Write-Host ("  MODO: " + $Modo + " -- GIRO A VUOTO. NESSUNA passata, NESSUN CSV, NESSUN") -ForegroundColor Yellow
  Write-Host ("        numero di round. Anteprime .ini attese: " + $Lavori.Count + ".") -ForegroundColor Yellow
  Write-Host  "        QUESTO ZIP NON E' IL ROUND e non va mandato come risultato." -ForegroundColor Yellow
} else {
  Write-Host ("  MODO: " + $Modo) -ForegroundColor White
  Write-Host ("  ATTESI:  " + (2*$Lavori.Count) + " CSV (" + $Lavori.Count + " file x IS/OOS), " + $CelleAttese + " righe l'uno, " + (4*$Lavori.Count) + " passate,") -ForegroundColor White
  Write-Host  "           piu' 2 per-trade del PASSO 0 e i per-trade delle celle." -ForegroundColor White
}
foreach($l in $Lavori){
  $c = "Green"; if($l.Esito -ne "OK" -and $l.Esito -ne "SOLO CONTROLLO"){ $c = "Yellow" }
  Write-Host ("   " + $l.Prova.PadRight(38) + " " + $l.Esito) -ForegroundColor $c
}
if($Problemi.Count -gt 0){
  Write-Host ""
  Write-Host "   PROBLEMI DA LEGGERE:" -ForegroundColor Red
  foreach($p in $Problemi){ Write-Host ("    - " + $p) -ForegroundColor Red }
}
Write-Host ""
#  L'ESITO IN CONSOLE DEVE DIRE LE STESSE PAROLE DEL REFERTO, o i due si
#  contraddicono: chi legge lo schermo e manda lo zip non ha visto il referto.
if($Fatale -ne ""){ Write-Host ("ESITO: FERMATO -- " + $Fatale) -ForegroundColor Red; exit 1 }
$ko = @($Lavori | Where-Object { $_.Esito -ne "OK" -and $_.Esito -ne "SOLO CONTROLLO" })
if($SoloControllo){
  if($ko.Count -gt 0 -or $Problemi.Count -gt 0){
    Write-Host ("ESITO: GIRO A VUOTO CON PROBLEMI (" + $Problemi.Count + ") -- NESSUNA passata, e c'e' da leggere il referto") -ForegroundColor Yellow; exit 1
  }
  Write-Host "ESITO: GIRO A VUOTO COMPLETATO -- NESSUNA passata, NESSUN CSV. QUESTO ZIP NON E' IL ROUND." -ForegroundColor Green
  exit 0
}
if($ko.Count -gt 0 -or $Problemi.Count -gt 0){
  Write-Host ("ESITO: PARZIALE (" + $ko.Count + " file non OK, " + $Problemi.Count + " problemi)") -ForegroundColor Yellow; exit 1
}
Write-Host "ESITO: OK" -ForegroundColor Green
