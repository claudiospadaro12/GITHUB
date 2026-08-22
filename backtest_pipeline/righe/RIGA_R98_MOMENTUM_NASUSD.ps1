# =====================================================================
#  MARCATORE_RIGA_R98_v1
#  RIGA_R98_MOMENTUM_NASUSD.ps1  --  R98: il primo round del motore A1
#  "Market Intraday Momentum" (ABTG_IntradayMomentum v1.00) su NASUSD M5
# ---------------------------------------------------------------------
#  CRITERI: backtest_pipeline\risultati_archivio\R98_CRITERI.md
#  >>> FIRMATI da Claudio il 22/08/2026 sera ("PF 1,20 + cancello
#      spread" = OPZIONE A del par. 5.1), a numeri di R98 mai visti.
#      Questa riga NON cambia i criteri: li traduce in file eseguibili.
#
#  DA DOVE NASCE QUESTO SCRIPT, dichiarato: e' RIGA_R97_ORB_NASUSD.ps1
#  v2 (pin 85874e5) adattata. Il punto 9 della checklist dice che una
#  riscrittura non puo' perdere le funzioni di sicurezza del gemello:
#  sono state riportate TUTTE, una per una -- guardia MT5/MetaEditor
#  chiusi, pin di $EABranch nei DUE script che lo hanno scritto fisso,
#  install dell'include ABTG_PausaGuardian.mqh, [Charts] MaxBars con
#  gate sullo stato finale, diff A COPPIE dei file prova, magic del
#  PASSO 0 diversi da quelli della griglia, SOSTA SVUOTATA A OGNI GIRO
#  (checklist 56), sosta con nome proprio prima dei gate, funzioni sopra
#  il try, MODO nel nome della cartella e nel referto, radici dei log
#  lette a OFFSET, \r? davanti a ogni $ multilinea, pulizia dei
#  per-trade PER NOME e MAI a wildcard, raccolta SEMPRE.
#
#  COSA FA, in ordine, e DA SOLA:
#    0. si rifiuta di partire se MT5 O MetaEditor sono aperti (checklist 7 e 39)
#    1. scarica AL PIN driver, 8 file prova, il sorgente .mq5 e l'include
#       - GATE DI VERSIONE sul .mq5: deve dichiarare #property version
#         "1.00" e contenere '[A1][AUTOTEST]' e 'MIM_DecisioneGiornata'.
#         Se no e' cache CDN o branch sbagliato -> STOP.
#       - INSTALLA ABTG_PausaGuardian.mqh, che nessun driver installa
#         (checklist 33-bis, pagato DUE volte il 21 e il 22/08)
#       - DIFF A COPPIE dei file prova: 30 righe vive MISURATE
#         sull'artefatto, e le righe che differiscono devono essere
#         ESATTAMENTE quelle dell'esperimento
#    2. FASE COMPILA: metaeditor64 invocato DIRETTO (& $Me "/compile:.."
#       "/log:..") -- MAI Start-Process con ArgumentList pre-quotato: sui
#       path con spazi torna rc=0 SENZA compilare (pagato il 22/08). Il
#       verdetto e' il LastWriteTime del .ex5 PRIMA/DOPO (checklist 54).
#    3. PASSO 0-A: barre M1+M5 di NASUSD dal broker, -SenzaTick.
#       I TICK NON si riscaricano: sono gia' MISURATI e agli atti
#       (NASUSD 164.636.788 dal 2024.09.26, REFERTO_R83_R84 riga 620).
#    4. PASSO 0-B -- DUE PASSATE SINGOLE GEMELLE DELLA CELLA NUDA su
#       TUTTA la finestra (magic 772890/91, InpVerbose=1). Da li' escono,
#       in quest'ordine:
#         (a) IL GATE DELL'AUTOTEST (criteri par. 3.3): le righe
#             [A1][AUTOTEST] devono esserci e NESSUNA deve portare
#             '*** FAIL ***'. Parser col CONTROLLO POSITIVO sui PASS
#             (checklist 55: "0 falliti" e "0 righe capite" non possono
#             finire nello stesso ramo). E' FATALE.
#         (b) i gate di sempre: G1 per-trade di ADESSO e popolato,
#             G2 prima operazione entro il limite, G3 gemelli identici.
#         (c) IL CANARINO (criteri par. 2.1): n IS e n OOS contati PER
#             DATA sul per-trade della passata intera. **NON BLOCCA**:
#             Emendamento regola B -- se n IS < 100 il MERITO e' sospeso
#             e il RISCHIO si giudica lo stesso. Va nelle NOTE, non nei
#             problemi (checklist 44: un campione sottile e' un
#             RISULTATO del round, non un guasto della corsa).
#         (d) LA META' MISURABILE DEL CANCELLO ZERO S0 (par. 3.2): il
#             risultato medio per operazione in PUNTI INDICE, e da li'
#             lo spread massimo compatibile con S0. Lo SPREAD della
#             fascia 20:30-21:00 NON e' misurabile da PowerShell: il
#             referto scrive "S0 = DA MISURARE A MANO" con le istruzioni
#             e NON inventa nessun numero.
#       >>> LA CONVERSIONE DEI PUNTI NON SI RIMISURA. E' gia' MISURATA e
#           agli atti in R97 (R97_REFERTO par. 3): 1 punto indice = 100
#           punti MT5 su NASUSD, due misure indipendenti concordi
#           (1.960 ordini in modo FIXED, digits=2 del per-trade). Stesso
#           simbolo, stesso broker, stessa finestra: rimisurarla sarebbe
#           un'ora di macchina per riconfermare un numero agli atti. Qui
#           serve solo a leggere InpSlippagePts=100 come 1 punto indice
#           (cella R98e) e a convertire i punti indice del cancello zero.
#    5. la catena degli 8 file prova, UNO ALLA VOLTA (una macchina, un
#       lavoro): 6 CELLE firmate + 2 PASSATE DIAGNOSTICHE sui lati, che
#       NON sono celle e non entrano in nessun cancello.
#    6. raccolta SEMPRE: cartella sul Desktop + zip, coi numeri attesi
#       dichiarati PRIMA. Tutto cio' che la raccolta usa nasce PRIMA del
#       try che puo' fallire (checklist 41-bis e 48, funzioni comprese).
#
#  QUELLO CHE NON FA, dichiarato:
#    - non giudica nessun numero: produce i CSV, li conta, e mette a
#      referto il canarino e la meta' misurabile del cancello zero. I
#      cancelli S0-S4 li applica il referto del round, non questa riga.
#    - non tocca nessuna sedia viva. Usa il blocco 7728xx (magic dell'EA)
#      e cancella SOLO i per-trade dei propri magic, PER NOME, uno per
#      uno. Vietati e controllati: 770611 (ORB Dow VIVO), 770601, 770201.
#    - non tocca niente di R97 (altri magic, altri CSV, altro EA)
#    - non riscarica i TICK (una nottata) ne' svuota bases\<server>\ticks
#    - non ammazza un lavoro in corso allo scadere di -OreMax: smette
#      solo di iniziarne di nuovi (checklist 19)
#
#  LA RIGA CHE SI INCOLLA (blocco INTERO, un comando solo - checklist 21).
#  <PIN> = il commit che contiene QUESTO file: e' l'hash dato in chat.
#
#  & { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
#      if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
#      $pin='<PIN>'; $p="$env:USERPROFILE\RIGA_R98.ps1"; Remove-Item $p -EA SilentlyContinue;
#      irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_R98_MOMENTUM_NASUSD.ps1" -OutFile $p;
#      if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_R98_v1' -Quiet)){ throw 'SCRIPT VECCHIO' };
#      $global:LASTEXITCODE=0; & $p -Pin $pin; if($LASTEXITCODE -ne 0){ Write-Host 'ESITO: PARZIALE O FERMO - leggi il REFERTO' } }
#
#  GIRO A VUOTO (un minuto, nessuna passata, nessun MT5 che opera):
#    ... & $p -Pin $pin -SoloControllo
#  Il giro a vuoto controlla ESATTAMENTE gli stessi file prova che
#  girano nella corsa vera. Non c'e' un secondo artefatto (checklist 33).
#  >>> E NON MISURA IL CANARINO: senza tester non esiste nessun n. Il
#      canarino lo misura il PASSO 0 della corsa vera. Sta scritto anche
#      nel referto del giro a vuoto, perche' non lo si scambi per la
#      conferma del par. 2.1.
# =====================================================================
param(
  # -Pin NON ha default: un default silenzioso ("lavoro") farebbe girare la
  #  punta del branch spacciandola per un commit congelato. Meglio morire.
  [string]$Pin       = "",
  [double]$OreMax    = 10.0,       # oltre questo NON si iniziano nuovi file
  [switch]$Rifai,
  [switch]$SoloControllo,
  [double]$RischioSonda = 0,       # SOLO per le due passate del PASSO 0. 0 =
                                   #   lascia quello del file prova (1,00%).
                                   #   Serve se la sonda non piazza ordini per
                                   #   margine. NON tocca le celle firmate, e
                                   #   il referto lo scrive fra gli switch.
  [switch]$SaltaPasso0             # SOLO per rilanciare una coda gia' gatata.
                                   #   Se lo usi, il referto lo scrive in rosso
                                   #   E il gate dell'autotest NON c'e'.
)
$ErrorActionPreference = "Stop"
[Threading.Thread]::CurrentThread.CurrentCulture   = [Globalization.CultureInfo]::InvariantCulture
[Threading.Thread]::CurrentThread.CurrentUICulture = [Globalization.CultureInfo]::InvariantCulture
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$INV = [Globalization.CultureInfo]::InvariantCulture

$Avvio = Get-Date
$Stamp = $Avvio.ToString("yyyyMMdd_HHmm", $INV)
$Dsk   = Join-Path $env:USERPROFILE "Desktop"
$Work  = Join-Path $env:USERPROFILE "abtg_r98"
$Prove = Join-Path $Work "prove"
$Logs  = Join-Path $Work "log_r98"
$SrcDir= Join-Path $Work "src_motori"
$RawPin= "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$Pin"

$Ea       = "ABTG_IntradayMomentum"
$VersioneAttesa = "1.00"      # criteri par. 0: e' l'EA A1, non un altro
$Sym      = "NASUSD"
$Periodo  = "M5"
$DaQuando = "2024.09.26"      # MISURATO: muro dei tick di BCM su NASUSD
$Fino     = "2026.06.30"      # come R97 e R88
$Modello  = 4                 # TICK REALI: stessa scelta di R97, dichiarata.
                              #  I numeri di R98 vanno confrontati con quelli
                              #  di R97 sullo STESSO simbolo e sulla STESSA
                              #  finestra; uno scan OHLC non sarebbe
                              #  confrontabile, e il motore vive di 30 minuti
                              #  al giorno -- proprio dove un OHLC mente di piu'.
$Deposito = 100000            # criteri par. 2
$SpreadIni= 0                 # 0 = spread CORRENTE, ma SCRITTO nell'ini invece
                              #     che lasciato allo stato nascosto del
                              #     terminale. NON e' uno stress di spread.
                              #     >>> E NON E' LA MISURA DELLO SPREAD che il
                              #     cancello zero S0 chiede: quella e' un'altra
                              #     cosa e va fatta a mano (vedi il referto).
$CelleAttese = 2              # per file, per finestra: le due passate gemelle
$FrazioneIS  = 0.40           # default di walkforward_generico.ps1

$MagicA   = 772890            # PASSO 0, passata A
$MagicB   = 772891            # PASSO 0, passata B (gemella di controllo)
#  I magic della GRIGLIA stanno nei file prova (772800/01 per la cella
#  nuda -- e' il magic dell'EA, criteri par. 0 -- poi 772820/21,
#  772830/31, 772840/41, 772850/51, 772860/61 e 772870/71, 772880/81 per
#  le due diagnostiche) e NON coincidono mai con quelli del PASSO 0: se
#  le due fasi condividessero il magic, le passate di ottimizzazione
#  riscriverebbero il per-trade su cui il gate ha dato il via libera
#  (checklist 41, pagato in R82). E' anche il motivo per cui il PASSO 0
#  NON gira sul 772800 come proponeva il par. 3.2 dei criteri (che su
#  quel punto dice "[DA DECIDERE]"): stessa cella, magic diverso.
$MagicVietati = @(770611,770601,770201)
#  770611 = ABTG_ORB_Ottimizzato VIVO sul Dow.  770601 = ABTG_ORB (corso).
#  770201 = ABTG_Nasdaq_Apertura_US (spenta, e resta spenta: criteri par. 0).

#--- IL LIMITE DEL GATE G2. La finestra parte dal 2024.09.26; un motore
#    che opera UNA VOLTA AL GIORNO deve aver tradato entro i primi tre
#    mesi. Se la prima operazione e' oltre, i dati non coprono l'inizio
#    della finestra. Stesso limite di R97, dichiarato.
$LimiteG2 = "2024.12.31"

#--- RIGHE VIVE ATTESE nei file prova. MISURATA il 22/08/2026 su tutti e
#    otto con `grep -vE '^\s*(#|$)' | wc -l`: 3 direttive @ + 27
#    parametri = 30. NON scritta a memoria (checklist 40-bis).
$RigheAttese = 30

#--- I CASI DELL'AUTOTEST A1. CONTATI NEL SORGENTE che li stampa
#    (checklist 55: il campione positivo si prende dal sorgente, non
#    dalla memoria): 4 + 11 + 5 + 8 + 5 + 12 = 45.
$CasiAutotestAttesi = 45

#--- LA CONVERSIONE: CITATA, NON RIMISURATA. R97_REFERTO par. 3, gate
#    firmato e CHIUSO: "MISURATA = 100 (1 punto indice = 100 punti MT5),
#    con due misure indipendenti concordi (1.960 ordini in modo FIXED,
#    mediana 10 di prezzo; digits del per-trade = 2)". Stesso simbolo,
#    stesso broker, stessa finestra di R98.
$ConversioneR97 = 100.0

#--- TUTTO CIO' CHE LA RACCOLTA USA NASCE QUI, PRIMA DEL try (checklist 41-bis),
#    FUNZIONI COMPRESE (checklist 48: in PowerShell una `function` non e'
#    dichiarativa, e' un'istruzione: se il flusso non ci passa sopra, il nome
#    non esiste, e la raccolta esplode proprio nella corsa fermata da un gate).
$Risultati = Join-Path $Work "risultati_prove"
$Comune    = Join-Path $env:APPDATA "MetaQuotes\Terminal\Common\Files"
$Sosta     = Join-Path $Work "sosta"
$Passo0    = @{ Fatto=$false; PrimaData=""; UltimaData=""; N=0; NIS=-1; NOOS=-1;
                Giorni=0.0; Gemelli="NON MISURATO"; Minuti=0.0; LogLetti=0;
                AutotestA1=0; AutotestGuardian=0; AutotestFail=0;
                Autotest="NON ESEGUITO";
                NetTot=0.0; NetMedio=0.0; PeggiorePct=0.0;
                Ingressi=0; PuntiMedi=0.0; SpreadMax=0.0;
                S0Misurato=$false; S0="NON MISURATO" }
$Storico   = @{ Eseguito=$false; Esito="NON ESEGUITO" }
$Problemi = New-Object System.Collections.ArrayList
$Note     = New-Object System.Collections.ArrayList
$Fatale   = ""
$nAnt     = -1        # -1 = non misurato (checklist 41-bis)
$VersioneLetta = "NON LETTA"

#--- LE DUE FINESTRE, calcolate con la STESSA formula del driver generico
#    (walkforward_generico.ps1 riga 465). Servono al CANARINO, che conta
#    le operazioni per DATA. Nel giro a vuoto vengono CONFRONTATE con le
#    FromDate/ToDate scritte davvero nelle anteprime .ini: se il driver
#    generico cambiasse la sua FrazioneIS, il confronto se ne accorge.
$DtInizio = [datetime]::ParseExact($DaQuando,"yyyy.MM.dd",$INV)
$DtFine   = [datetime]::ParseExact($Fino,"yyyy.MM.dd",$INV)
$DtMeta   = $DtInizio.AddDays([math]::Floor(($DtFine-$DtInizio).TotalDays*$FrazioneIS))
$IS_Da    = $DtInizio.ToString("yyyy.MM.dd",$INV)
$IS_A     = $DtMeta.ToString("yyyy.MM.dd",$INV)
$OOS_Da   = $DtMeta.AddDays(1).ToString("yyyy.MM.dd",$INV)
$OOS_A    = $DtFine.ToString("yyyy.MM.dd",$INV)

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

#  Una riga della lista dei lavori. "Cella" = $true per le 6 celle
#  firmate; $false per le DUE PASSATE DIAGNOSTICHE sui lati, che i
#  criteri (par. 4.1) chiamano per nome: "servono a DICHIARARE, non a
#  scegliere" e NON entrano in nessun cancello.
function L($f,$et,$desc,$over,$soglia,$secondo,$slatr,$slip,$long,$short,$magic,$cella){
  return [pscustomobject]@{ Prova=$f; Et=$et; Desc=$desc;
                            Over=$over; Soglia=$soglia; Secondo=$secondo;
                            SLatr=$slatr; Slip=$slip; Long=$long; Short=$short;
                            Magic=$magic; Cella=$cella;
                            Esito="NON ESEGUITO"; IS=-1; OOS=-1; Min=0.0 }
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
function Media($v){
  if($v.Count -eq 0){ return 0.0 }
  $s = 0.0; foreach($x in $v){ $s = $s + [double]$x }
  return ($s / $v.Count)
}
#  LETTURA DEI LOG A OFFSET (checklist 23-bis, nella forma CORRETTA): si
#  legge SOLO cio' che e' stato scritto dopo la fotografia. Un file NON
#  cresciuto non si rilegge da capo, altrimenti il "=== FINITO" di ieri
#  sera passa per quello di adesso. E un file NATO dopo la fotografia ha
#  $da = 0 e si legge TUTTO.
function LeggiNuovo($path,$da){
  $b = $null
  try{
    $fs = [IO.File]::Open($path,[IO.FileMode]::Open,[IO.FileAccess]::Read,[IO.FileShare]::ReadWrite)
    $len = $fs.Length
    if($da % 2 -ne 0){ $da = $da - 1 }
    if($da -ge $len){ $fs.Close(); return "" }
    if($da -gt 0){ [void]$fs.Seek($da,[IO.SeekOrigin]::Begin) }
    $n = [int]($len - $da); $b = New-Object byte[] $n; $letti = 0
    while($letti -lt $n){ $q = $fs.Read($b,$letti,$n-$letti); if($q -le 0){ break }; $letti += $q }
    $fs.Close()
  }catch{ return "" }
  if($b -eq $null -or $b.Count -lt 4){ return "" }
  #  ENCODING SCELTO DAI BYTE, mai per decreto: i log MT5 sono UTF-16LE,
  #  ma non sempre col BOM (e leggendo a offset il BOM non c'e' proprio).
  #  Un -Encoding fisso legge byte a caso e la ricerca esce verde per
  #  ASSENZA (checklist 28-bis).
  $utf16 = ($b[0] -eq 0xFF -and $b[1] -eq 0xFE)
  if(-not $utf16){
    $zeri = 0; $n2 = [math]::Min(400,$b.Count)
    for($i=1;$i -lt $n2;$i+=2){ if($b[$i] -eq 0){ $zeri++ } }
    $utf16 = ($zeri -gt ($n2/4))
  }
  if($utf16){ return [Text.Encoding]::Unicode.GetString($b) }
  return [Text.Encoding]::UTF8.GetString($b)
}

# --- LA LISTA DEI LAVORI: 6 CELLE FIRMATE + 2 PASSATE DIAGNOSTICHE.
#     I valori scritti qui sono quelli che la sezione 1e RILEGGE NEI FILE:
#     il diff dice CHE cambiano, questi dicono CHE COSA valgono.
$Lavori = @(
  (L "R98rif_nuda_NASUSD.txt"           "r98rif"      "R98-rif LA CELLA NUDA: il paper letterale (overnight ON, soglia 0, un segnale, SL 2 ATR)" "1" "0"    "0" "2.0" "0"   "1" "1" 772800 $true),
  (L "R98a_no_overnight_NASUSD.txt"     "r98a"        "R98a  r1 INTRADAY PURO (overnight OFF): predittore DIVERSO, non una taratura"             "0" "0"    "0" "2.0" "0"   "1" "1" 772820 $true),
  (L "R98b_secondo_segnale_NASUSD.txt"  "r98b"        "R98b  SECONDO SEGNALE r12 acceso (variante del paper)"                                    "1" "0"    "1" "2.0" "0"   "1" "1" 772830 $true),
  (L "R98c_soglia010_NASUSD.txt"        "r98c"        "R98c  SOGLIA |r1| >= 0,10% (filtro NOSTRO: e' l'asse che puo' muovere il cancello zero)"   "1" "0.10" "0" "2.0" "0"   "1" "1" 772840 $true),
  (L "R98d_slatr30_NASUSD.txt"          "r98d"        "R98d  STOP 3,0 x ATR invece di 2,0 (quanto costa il NOSTRO guardrail)"                    "1" "0"    "0" "3.0" "0"   "1" "1" 772850 $true),
  (L "R98e_slippage100_NASUSD.txt"      "r98e"        "R98e  SLIPPAGE 100 pt MT5 = 1 punto indice (R55: misura di FRAGILITA', NON promuovibile)" "1" "0"    "0" "2.0" "100" "1" "1" 772860 $true),
  (L "R98diagNoLong_NASUSD.txt"         "r98dnolong"  "DIAGNOSTICA 1: long SPENTI, restano gli SHORT   <<< NON E' UNA CELLA (par. 4.1)"           "1" "0"    "0" "2.0" "0"   "0" "1" 772870 $false),
  (L "R98diagNoShort_NASUSD.txt"        "r98dnoshort" "DIAGNOSTICA 2: short SPENTI, restano i LONG     <<< NON E' UNA CELLA (par. 4.1)"           "1" "0"    "0" "2.0" "0"   "1" "0" 772880 $false)
)

Write-Host ""
Write-Host "#####################################################################" -ForegroundColor Cyan
Write-Host "#  R98 - MARKET INTRADAY MOMENTUM (A1) SU NASUSD (M5, TICK REALI)   #" -ForegroundColor Cyan
Write-Host "#####################################################################" -ForegroundColor Cyan
Dico ("pin      : " + $Pin)
Dico ("cartella : " + $Work)

# =====================================================================
#  I NUMERI ATTESI, DICHIARATI PRIMA. Se a fine corsa non tornano,
#  il round non si legge.
# =====================================================================
$nCelle = @($Lavori | Where-Object { $_.Cella }).Count
$nDiag  = @($Lavori | Where-Object { -not $_.Cella }).Count
Titolo "NUMERI ATTESI (dichiarati PRIMA della corsa)"
Write-Host ("    file prova ...................  " + $Lavori.Count + "   (" + $nCelle + " celle firmate + " + $nDiag + " passate DIAGNOSTICHE sui lati)") -ForegroundColor White
Write-Host ("    celle per file per finestra ..  " + $CelleAttese + "   (le due passate GEMELLE di controllo)") -ForegroundColor White
Write-Host ("    CSV attesi ...................  " + (2*$Lavori.Count) + "   (" + $Lavori.Count + " file x IS/OOS)") -ForegroundColor White
Write-Host ("    righe per CSV ................  " + $CelleAttese) -ForegroundColor White
Write-Host ("    passate totali ...............  " + (4*$Lavori.Count)) -ForegroundColor White
Write-Host  "    passate del PASSO 0 ..........  2   (gemelle, cella NUDA su TUTTA la finestra)" -ForegroundColor White
Write-Host ("    modello ......................  " + $Modello + " = TICK REALI (stessa scelta di R97, dichiarata)") -ForegroundColor White
Write-Host ("    finestra .....................  " + $DaQuando + " -> " + $Fino + "  (split 40/60)") -ForegroundColor White
Write-Host ("    IS / OOS .....................  " + $IS_Da + " - " + $IS_A + "  /  " + $OOS_Da + " - " + $OOS_A) -ForegroundColor White
Write-Host  "                                    (calcolate qui con la STESSA formula del driver" -ForegroundColor Gray
Write-Host  "                                     generico; il giro a vuoto le CONFRONTA con le" -ForegroundColor Gray
Write-Host  "                                     FromDate/ToDate scritte davvero nelle anteprime)" -ForegroundColor Gray
Write-Host ("    deposito .....................  " + $Deposito + "   rischio 1,00% pinnato nei file prova") -ForegroundColor White
Write-Host ("    spread .......................  Spread=" + $SpreadIni + " nell'ini = spread CORRENTE, dichiarato.") -ForegroundColor White
Write-Host  "                                    NON e' la misura che chiede il cancello zero S0." -ForegroundColor Gray
Write-Host ""
Write-Host ("    CONVERSIONE: NON si rimisura. E' agli atti da R97: 1 punto indice =") -ForegroundColor Yellow
Write-Host ("    " + $ConversioneR97 + " punti MT5 su " + $Sym + " (due misure indipendenti concordi).") -ForegroundColor Yellow
Write-Host  "    Serve a leggere InpSlippagePts=100 come 1 PUNTO INDICE (cella R98e)." -ForegroundColor Yellow
Write-Host ""
Write-Host ("    IL GATE FATALE DI QUESTO ROUND (criteri par. 3.3): le righe") -ForegroundColor Yellow
Write-Host ("    [A1][AUTOTEST] delle passate del PASSO 0, " + $CasiAutotestAttesi + " casi l'una (le passate") -ForegroundColor Yellow
Write-Host ("    sono DUE: attese " + (2*$CasiAutotestAttesi) + " righe PASS), e ZERO '*** FAIL ***'.") -ForegroundColor Yellow
Write-Host  "    Se compare un FAIL, i risultati non si leggono nemmeno." -ForegroundColor Yellow
Write-Host ""
Write-Host  "    IL CANARINO (par. 2.1) NON E' UN GATE: n IS atteso ~180 e' [INFERITO]." -ForegroundColor Yellow
Write-Host  "    Il PASSO 0 lo MISURA contando le operazioni per data. Se n IS < 100 la" -ForegroundColor Yellow
Write-Host  "    corsa SEGNALA e prosegue: Emendamento regola B -- il MERITO e' sospeso," -ForegroundColor Yellow
Write-Host  "    il RISCHIO si giudica lo stesso." -ForegroundColor Yellow
Write-Host ""
Write-Host  "    QUANTO CI METTE: [STIMA] 2-4 ore. Riferimento R97 (stesso simbolo, stessa" -ForegroundColor Yellow
Write-Host ("    finestra, tick reali): 16 passate. R98 ne ha " + (4*$Lavori.Count) + ". Il PASSO 0 MISURA una") -ForegroundColor Yellow
Write-Host  "    passata intera e stampa la stima." -ForegroundColor Yellow
Write-Host ""
Write-Host  "    >>> QUESTO ROUND NON PRODUCE NESSUNA SEDIA (criteri par. 6). Al" -ForegroundColor Yellow
Write-Host  "        massimo produce una PROPOSTA per un round di deploy separato." -ForegroundColor Yellow

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
#     8 file fra loro, un push a meta' corsa cambierebbe il motore fra
#     un file e l'altro e il confronto non misurerebbe piu' niente.
$dTxt = Get-Content -LiteralPath $Driver -Raw
$dNew = $dTxt -replace '\$EABranch\s*=\s*"lavoro"', ('$EABranch="' + $Pin + '"')
if($dNew -eq $dTxt){ throw "non sono riuscito a pinnare EABranch nel driver: riga non trovata" }

# --- 1b. IL TETTO DELLE BARRE. Se il tester ereditasse il tetto "Max barre
#     nel grafico" del terminale, le serie verrebbero TRONCATE IN SILENZIO
#     (checklist 36) e i CSV uscirebbero pieni di numeri coerenti e falsi.
#     Qui morde piu' che altrove: l'EA legge barre M1 su 21 mesi.
#     [INFERITO] che il tester onori questa riga: NON e' misurato. Il gate
#     vero resta il PASSO 0 sulla prima data del per-trade.
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
#     QUALI righe differiscono, e OGNI file si confronta con la cella
#     NUDA -- che e' il riferimento di TUTTI (criteri par. 4: "sei celle,
#     una variabile alla volta, tutte contro la cella nuda").
Pretendi "r98rif" "r98a"        @("InpUseOvernightInR1","InpMagic") "Fra la cella nuda e R98a cambia SOLO la definizione di r1 (col gap overnight o intraday pura): e' un PREDITTORE diverso, ed e' l'unica cosa che deve cambiare."
Pretendi "r98rif" "r98b"        @("InpUseSecondSignal","InpMagic")  "Fra la cella nuda e R98b cambia SOLO il secondo segnale r12 (variante del paper)."
Pretendi "r98rif" "r98c"        @("InpMinAbsR1Pct","InpMagic")      "Fra la cella nuda e R98c cambia SOLO la soglia minima su |r1|: e' l'asse che puo' muovere il cancello zero."
Pretendi "r98rif" "r98d"        @("InpSLatr","InpMagic")            "Fra la cella nuda e R98d cambia SOLO la distanza dello stop in ATR."
Pretendi "r98rif" "r98e"        @("InpSlippagePts","InpMagic")      "Fra la cella nuda e R98e cambia SOLO lo slippage stimato (R55)."
Pretendi "r98rif" "r98dnolong"  @("InpAllowLong","InpMagic")        "Fra la cella nuda e la diagnostica 1 cambia SOLO InpAllowLong: e' la passata sui lati del par. 4.1, e NON e' una cella."
Pretendi "r98rif" "r98dnoshort" @("InpAllowShort","InpMagic")       "Fra la cella nuda e la diagnostica 2 cambia SOLO InpAllowShort: e' la passata sui lati del par. 4.1, e NON e' una cella."
Dico ("diff a coppie contro la cella NUDA: righe vive " + $RigheAttese + ", e differiscono solo dove devono") "Green"

# --- 1e. I VALORI DELLE CELLE, letti NELL'ARTEFATTO CHE GIRA
#     (checklist 34-bis). Il diff dice CHE cambiano; questo dice CHE COSA
#     valgono: se due celle fossero scambiate il diff resterebbe verde.
$magicVisti = @()
foreach($l in $Lavori){
  $tx = Get-Content -LiteralPath (Join-Path $Prove $l.Prova) -Raw
  foreach($chk in @(@("InpUseOvernightInR1",$l.Over), @("InpMinAbsR1Pct",$l.Soglia), @("InpUseSecondSignal",$l.Secondo),
                    @("InpSLatr",$l.SLatr), @("InpSlippagePts",$l.Slip), @("InpAllowLong",$l.Long), @("InpAllowShort",$l.Short))){
    #  >>> OGNI $ DI UNA REGEX MULTILINEA SI SCRIVE \r?$ (checklist 40): i
    #      file arrivano da GitHub con CRLF, e senza \r? il match non
    #      avviene MAI e il gate accuserebbe un file sano.
    $rx = '(?m)^' + $chk[0] + '=' + [regex]::Escape($chk[1]) + '\r?$'
    if($tx -notmatch $rx){ throw ($l.Prova + ": non trovo la riga '" + $chk[0] + "=" + $chk[1] + "'. La cella non e' quella che credo: le celle sono scambiate o il file e' cambiato.") }
  }
  $mg = [regex]::Match($tx,'(?m)^InpMagic=(\d+)\|\|')
  if(-not $mg.Success){ throw ($l.Prova + ": non trovo la riga InpMagic nella forma sweep 'v||v||1||v+1||Y'") }
  $m0 = [int]$mg.Groups[1].Value
  if($m0 -ne $l.Magic){ throw ($l.Prova + ": InpMagic e' " + $m0 + " ma questo file deve girare su " + $l.Magic) }
  if($magicVisti -contains $m0){ throw ($l.Prova + ": magic " + $m0 + " gia' usato da un altro file prova. Due file con lo stesso magic si sovrascrivono il per-trade.") }
  if($m0 -eq $MagicA -or $m0 -eq $MagicB){ throw ($l.Prova + ": usa il magic del PASSO 0 (" + $m0 + "). Le due fasi non condividono il magic (checklist 41).") }
  if($MagicVietati -contains $m0){ throw ($l.Prova + ": il magic " + $m0 + " e' di una SEDIA VIVA o spenta di casa. Fermo tutto.") }
  $magicVisti += $m0
}
Dico ("valori delle celle e magic verificati NEI FILE: " + ($magicVisti -join ", ") + "   (PASSO 0: " + $MagicA + "/" + $MagicB + ")") "Green"

# --- 1f. @DAQUANDO, @SIMBOLO, @PERIODO E L'ORA SERVER, scritti in DUE
#     posti (file prova e questa riga): si CONFRONTANO, non ci si fida del
#     commento "se cambi qui cambia anche li'" (checklist 33).
foreach($l in $Lavori){
  $tx = Get-Content -LiteralPath (Join-Path $Prove $l.Prova) -Raw
  $m = [regex]::Match($tx,'(?m)^@DAQUANDO\s+([0-9]{4}\.[0-9]{2}\.[0-9]{2})')
  if(-not $m.Success){ throw ($l.Prova + ": manca @DAQUANDO") }
  if($m.Groups[1].Value -ne $DaQuando){ throw ($l.Prova + ": @DAQUANDO e' " + $m.Groups[1].Value + " ma la riga di lancio dice " + $DaQuando) }
  $s = [regex]::Match($tx,'(?m)^@SIMBOLO\s+(\S+)')
  if(-not $s.Success -or $s.Groups[1].Value -ne $Sym){ throw ($l.Prova + ": @SIMBOLO non e' " + $Sym) }
  $p = [regex]::Match($tx,'(?m)^@PERIODO\s+(\S+)')
  if(-not $p.Success -or $p.Groups[1].Value -ne $Periodo){ throw ($l.Prova + ": @PERIODO non e' " + $Periodo) }
  # --- GLI ORARI SONO IN ORA SERVER. Regola di casa: server BCM = ora
  #     italiana - 1. L'apertura di cassa USA (15:30 IT) e' 14:30 SERVER,
  #     l'ingresso (21:30 IT) e' 20:30 SERVER, la chiusura (22:00 IT) e'
  #     21:00 SERVER. Un 15 o un 21:30 qui dentro sarebbero l'ora
  #     ITALIANA, cioe' un'ALTRA strategia, e i CSV andrebbero cestinati.
  #     Meglio non produrli affatto.
  foreach($chk in @(@("InpSignalStartHour","14"), @("InpSignalStartMin","30"), @("InpSignalMinutes","30"),
                    @("InpEntryHour","20"), @("InpEntryMin","30"),
                    @("InpExitHour","21"), @("InpExitMin","0"))){
    if($tx -notmatch ('(?m)^' + $chk[0] + '=' + $chk[1] + '\r?$')){
      throw ($l.Prova + ": " + $chk[0] + " non e' " + $chk[1] + " (ORA SERVER). Un'ora italiana qui dentro sposta tutto di 60 minuti: server BCM = ora italiana - 1.")
    }
  }
  # --- e il rischio, che i criteri pinnano all'1,00% per confrontabilita'
  if($tx -notmatch '(?m)^InpRiskPercent=1\.0\r?$'){ throw ($l.Prova + ": InpRiskPercent non e' 1.0 (criteri par. 2). Con un rischio diverso i numeri non si confrontano con l'archivio.") }
  # --- e l'autotest ACCESO: e' il gate del par. 3.3
  if($tx -notmatch '(?m)^InpAutoTest=1\r?$'){ throw ($l.Prova + ": InpAutoTest non e' 1. Senza autotest il gate dei criteri par. 3.3 non ha niente da leggere.") }
}
Dico ("@DAQUANDO / @SIMBOLO / @PERIODO, i SETTE orari in ORA SERVER, il rischio 1,00% e InpAutoTest=1 verificati in tutti e " + $Lavori.Count + " i file") "Green"

# --- 1g. IL SORGENTE E IL GATE DI VERSIONE. Il marcatore e'
#     'MIM_DecisioneGiornata', la funzione del NUCLEO PURO che decide il
#     verso della giornata: esiste solo in questo EA. E la versione si
#     legge, non si spera: una cache CDN o un branch sbagliato darebbero
#     un altro sorgente, e il round misurerebbe un altro motore.
$srcMq5 = Join-Path $SrcDir ($Ea + ".mq5")
Scarica ("$RawPin/mql5/Experts/" + $Ea + ".mq5") $srcMq5 'MIM_DecisioneGiornata'
$txtSrc = Get-Content -LiteralPath $srcMq5 -Raw
$mv = [regex]::Match($txtSrc,'#property\s+version\s+"([^"]+)"')
if(-not $mv.Success){ throw ($Ea + ".mq5 scaricato senza #property version: non e' il sorgente che credo.") }
$VersioneLetta = $mv.Groups[1].Value
if($VersioneLetta -ne $VersioneAttesa){
  throw ($Ea + ".mq5 dichiara version '" + $VersioneLetta + "' invece di '" + $VersioneAttesa +
         "'. O la cache di raw.githubusercontent serve una copia vecchia, o il pin e' sbagliato. I criteri di R98 parlano della v1.00: mi fermo.")
}
if($txtSrc -notmatch '\[A1\]\[AUTOTEST\]'){ throw ($Ea + ".mq5 non contiene le stampe [A1][AUTOTEST]: il gate dei criteri par. 3.3 non potrebbe mordere.") }
if($txtSrc -notmatch 'InpMagic\s*=\s*772800'){ throw ($Ea + ".mq5 non dichiara InpMagic=772800: non e' il motore dei criteri (par. 0).") }
Dico ($Ea + ".mq5 scaricato al pin, version " + $VersioneLetta + " (marcatori: MIM_DecisioneGiornata, [A1][AUTOTEST], magic 772800)") "Green"

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

# --- 2-bis. LA SOSTA SI SVUOTA A OGNI GIRO (checklist 56, difetto trovato
#     dal verificatore su R97 e corretto in 85874e5). Il documento
#     PRESCRIVE il giro a vuoto PRIMA della corsa vera; il giro a vuoto
#     lascia in sosta le anteprima_r98*.ini, la corsa vera NON le
#     riproduce e la raccolta copia in blocco tutta la sosta nello zip:
#     dentro il risultato del round finirebbero otto .ini CHE NON HANNO
#     GIRATO, indistinguibili da quelli veri. Qui non si perde niente: la
#     sosta e' una copia di lavoro, l'archivio e' la cartella datata sul
#     Desktop, che non si sovrascrive mai (checklist 12).
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
#     ABTG_IntradayMomentum.mq5 fa #include <ABTG_PausaGuardian.mqh> e
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
#         "abtg_trades_*" prenderebbe anche i per-trade delle sedie VIVE.
#         Qui si toccano solo i nostri 7728xx su NASUSD.
$MieiMagic = @($MagicA,$MagicB)
foreach($l in $Lavori){ $MieiMagic += $l.Magic; $MieiMagic += ($l.Magic + 1) }
if($SoloControllo){
  $quanti = 0
  foreach($m in $MieiMagic){ if(Test-Path -LiteralPath (Join-Path $Comune ("abtg_trades_" + $Ea + "_" + $Sym + "_" + $m + ".csv"))){ $quanti++ } }
  Dico ("SoloControllo: NON cancello niente (per-trade R98 presenti adesso: " + $quanti + ")") "Yellow"
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
    [void]$Problemi.Add("pulizia: " + $nRimasti + " per-trade R98 NON cancellati (file aperto in Excel?). Un file vecchio che sopravvive verrebbe letto come nuovo: i gate guardano la DATA, ma va saputo.")
  }
  Dico ("per-trade R98 rimossi: " + $nTolti + " (rimasti: " + $nRimasti + "). NESSUN file di altri magic o di altri simboli e' stato toccato: le sedie vive e i CSV di R97 restano dove sono.") "Green"
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
#         "esiste" e non "e' recente": il file c'era gia' (l'autotest del
#         22/08 sera ha gia' compilato questo EA su questa macchina).
# =====================================================================
Titolo "3. FASE COMPILA"
$mq5 = Join-Path $MqlExperts ($Ea + ".mq5")
$ex5 = Join-Path $MqlExperts ($Ea + ".ex5")
$logC= Join-Path $MqlExperts ($Ea + ".log")
#  backup DATATO e MAI sovrascritto (checklist 12): il .ex5 vecchio e'
#  l'unica prova di cosa girava prima su questa macchina.
$bakMq5 = $mq5 + ".prima_r98_" + $Stamp
$bakEx5 = $ex5 + ".prima_r98_" + $Stamp
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
  Copy-Item -LiteralPath $logC -Destination (Join-Path $Sosta "compile_r98.log") -Force -ErrorAction SilentlyContinue
}
if(-not $compileOk){
  if($testoLog -ne ""){
    Write-Host "--- log del compilatore (ultime righe) ---" -ForegroundColor DarkYellow
    foreach($r in @($testoLog -split "\r?\n" | Select-Object -Last 20)){ Write-Host ("   " + $r) -ForegroundColor DarkYellow }
  } else { Write-Host "   (nessun log prodotto da MetaEditor)" -ForegroundColor DarkYellow }
  #  sorgente e binario devono restare la STESSA versione (checklist 54)
  if(Test-Path -LiteralPath $bakMq5){ Copy-Item -LiteralPath $bakMq5 -Destination $mq5 -Force }
  throw ("COMPILAZIONE FALLITA per " + $Ea + " (metaeditor rc=" + $rcMe + ", .ex5 NON riscritto). Il .mq5 e' stato rimesso com'era. Il round si ferma qui, e il log e' nello zip. NOTA: questo stesso sorgente e' stato compilato con 0 errori sul PC di Claudio il 22/08 alle 23:04, quindi il sospetto n.1 e' l'include mancante o MetaEditor gia' aperto.")
}
$mw = [regex]::Match($testoLog,'(?i)(\d+)\s+warning')
if($mw.Success -and [int]$mw.Groups[1].Value -gt 0){
  [void]$Note.Add("compilazione: " + $mw.Groups[1].Value + " warning (0 errori). Non fermano il round, ma vanno letti nel log compile_r98.log dello zip.")
}
Dico ("COMPILATO " + $Ea + " v" + $VersioneLetta + " (.ex5 riscritto adesso, metaeditor rc=" + $rcMe + ")") "Green"

# =====================================================================
#  4-A. PASSO 0-A -- LE BARRE. I TICK NON SI RISCARICANO.
#     Sono gia' MISURATI e agli atti: NASUSD 164.636.788 tick dal
#     2024.09.26 (REFERTO_R83_R84_PREPARAZIONE.md riga 620).
#     Riscaricarli aprirebbe la finestra del difetto 30 (il guardiano di
#     progresso che ammazza MT5 in mezzo alla fase dei tick, dove il CSV
#     per costruzione non cresce di un byte per ore).
#     >>> E QUI LE BARRE M1 SERVONO DAVVERO: questo EA misura le mezz'ore
#         leggendo barre M1 con CopyRates. Senza M1 non c'e' segnale.
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
      [void]$Problemi.Add("PASSO 0-A: scarica_storico.ps1 e' uscito con codice " + $LASTEXITCODE + " -> " + $che + ". Il gate G2 sulla prima data del per-trade resta la misura che decide.")
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
                              ".  Il gate G2 sulla prima data del per-trade e' la misura che decide.")
        }
      }
      if(-not $vistoSym){ [void]$Problemi.Add("PASSO 0-A: nessuna riga per " + $Sym + " nel referto storico.") }
    } else { [void]$Note.Add("PASSO 0-A: ABTG_StoricoScaricato.csv non trovato, referto storico NON letto.") }
  }catch{
    $Storico.Esito = "NON ESEGUITO (" + $_.Exception.Message + ")"
    [void]$Problemi.Add("PASSO 0-A NON ESEGUITO: " + $_.Exception.Message + ". Il gate G2 resta l'unica misura sulla copertura.")
  }
  Dico ("PASSO 0-A: " + $Storico.Esito) "Gray"
} else {
  $Storico.Esito = "SALTATO (SoloControllo o SaltaPasso0)"
}

# =====================================================================
#  4-B. IL PASSO 0 -- due passate SINGOLE gemelle della CELLA NUDA su
#  TUTTA la finestra, con InpVerbose=1. Da qui escono, in quest'ordine:
#  il gate FATALE dell'autotest, i gate G1/G2/G3, il canarino e la meta'
#  misurabile del cancello zero S0.
# =====================================================================
if($SaltaPasso0){
  [void]$Problemi.Add("PASSO 0 SALTATO SU RICHIESTA: IL GATE DELL'AUTOTEST (criteri par. 3.3) NON E' STATO ESEGUITO IN QUESTA CORSA, e con lui il canarino e la meta' misurabile del cancello zero. I criteri dicono che se compare un FAIL i risultati non si leggono nemmeno: questa corsa non ha guardato. Vale solo per riprendere una coda GIA' gatata in un giro precedente, e il referto lo scrive in rosso.")
  Write-Host "    !! PASSO 0 SALTATO. Il referto lo scrive in rosso." -ForegroundColor Red
} else {
  #  IL BERSAGLIO DEL PASSO 0 E' IL PRIMO LAVORO DELLA LISTA (la cella
  #  NUDA), e non un nome riscritto a mano: un selettore ricopiato degrada
  #  di una riga per volta (checklist 37).
  $ProvaGate = $Lavori[0].Prova
  if(-not $Lavori[0].Cella -or $Lavori[0].Et -ne "r98rif"){ throw "il primo lavoro della lista non e' la cella NUDA: il PASSO 0 misurerebbe un'altra cella." }
  Titolo ("4-B. PASSO 0 - 2 passate singole gemelle da " + $ProvaGate + " (cella NUDA, tutta la finestra)")

  # --- l'ini si DERIVA dal file prova: un solo artefatto (checklist 33)
  function IniPasso0($magic,$dest){
    $righe = @(Get-Content -LiteralPath (Join-Path $Prove $ProvaGate) |
               Where-Object { $_ -notmatch '^\s*#' -and $_ -notmatch '^\s*$' -and $_ -notmatch '^@' })
    $out = New-Object System.Collections.ArrayList
    foreach($r in $righe){
      $nome = ($r -split '=')[0].Trim()
      switch($nome){
        "InpVerbose"  { [void]$out.Add("InpVerbose=1") }    # serve il log: e' li' che si leggono i prezzi d'ingresso
        "InpMagic"    { [void]$out.Add("InpMagic=" + $magic) }
        "InpRiskPercent" {
            #  di norma resta quello del file prova (1,00%). Si abbassa SOLO
            #  se chiesto a mano, e il referto lo scrive. Non cambia il
            #  SEGNALE, quindi non cambia n ne' i punti indice per
            #  operazione: cambia solo la taglia in euro.
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
    if($inputs -notmatch '(?m)^InpVerbose=1\r?$'){ throw "PASSO 0: InpVerbose non e' 1: le righe '[A1] LONG a mercato @ ...' non verrebbero stampate e il cancello zero non avrebbe niente da leggere." }
    if($inputs -notmatch '(?m)^InpAutoTest=1\r?$'){ throw "PASSO 0: InpAutoTest non e' 1: il gate dei criteri par. 3.3 non avrebbe niente da leggere." }
    if($inputs -notmatch ('(?m)^InpMagic=' + $magic + '\r?$')){ throw ("PASSO 0: InpMagic non e' stato pinnato a " + $magic) }
    foreach($mg in $magicVisti){
      if($inputs -match ('(?m)^InpMagic=' + $mg + '\r?$')){ throw "PASSO 0: sta girando con un magic della GRIGLIA. Le due fasi non condividono il magic." }
    }
    #  >>> E DEVE ESSERE DAVVERO LA CELLA NUDA: il canarino e il cancello
    #      zero si misurano SU DI LEI (criteri par. 2.1 e 3.2). Se una
    #      variante fosse accesa, i due numeri descriverebbero un'altra
    #      cella e nessuno se ne accorgerebbe.
    foreach($chk in @(@("InpUseOvernightInR1","1"), @("InpMinAbsR1Pct","0"), @("InpUseSecondSignal","0"),
                      @("InpSLatr","2.0"), @("InpSlippagePts","0"), @("InpAllowLong","1"), @("InpAllowShort","1"))){
      if($inputs -notmatch ('(?m)^' + $chk[0] + '=' + [regex]::Escape($chk[1]) + '\r?$')){
        throw ("PASSO 0: l'ini derivato ha " + $chk[0] + " diverso da " + $chk[1] + ": NON e' la cella nuda, e il canarino e il cancello zero misurerebbero un'altra cosa.")
      }
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
Report=OptReport_R98_passo0_$magic

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
    Dico "SoloControllo: gli ini del PASSO 0 sono scritti e verificati, MT5 NON viene aperto." "Yellow"
    [void]$Note.Add("GIRO A VUOTO: il PASSO 0 non e' stato eseguito, quindi NON esistono ne' il gate dell'autotest, ne' il CANARINO (n IS / n OOS), ne' la meta' misurabile del cancello zero. Il giro a vuoto verifica gli ARTEFATTI (file prova, finestre, celle, ini), non i NUMERI: quelli li misura solo la corsa vera.")
  } else {
    #  $tPasso0 marca l'inizio E si fotografano le lunghezze dei log: i log
    #  si leggono SOLO da qui in avanti (checklist 23-bis), altrimenti un
    #  log di ieri risponderebbe per la corsa di oggi.
    $tPasso0 = Get-Date
    $radici = @(
      (Join-Path $DataFolder "Tester"),
      (Join-Path $InstDir    "Tester"),
      (Join-Path $env:APPDATA "MetaQuotes\Tester"),
      (Join-Path $DataFolder "MQL5\Logs")
    )
    $primaLen = @{}
    foreach($rad in $radici){
      if(-not (Test-Path -LiteralPath $rad)){ continue }
      foreach($f in @(Get-ChildItem -LiteralPath $rad -Recurse -Filter "*.log" -File -ErrorAction SilentlyContinue)){ $primaLen[$f.FullName] = $f.Length }
    }

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
    #  4-B-1. IL GATE DELL'AUTOTEST (criteri par. 3.3). E' FATALE, e si
    #  legge PRIMA di tutto il resto: "se compare un FAIL, i risultati
    #  non si leggono nemmeno".
    # =================================================================
    $righeAT = New-Object System.Collections.ArrayList
    $righeIN = New-Object System.Collections.ArrayList     # gli ingressi, per il cancello zero
    $letti = 0
    foreach($rad in $radici){
      if(-not (Test-Path -LiteralPath $rad)){ continue }
      $files = @(Get-ChildItem -LiteralPath $rad -Recurse -Filter "*.log" -File -ErrorAction SilentlyContinue | Sort-Object LastWriteTime)
      foreach($lg in $files){
        $da = 0
        if($primaLen.ContainsKey($lg.FullName)){ $da = $primaLen[$lg.FullName] }
        $tx = LeggiNuovo $lg.FullName $da
        if($tx -eq ""){ continue }
        $letti++
        foreach($r in ($tx -split "`r?`n")){
          if($r -match '\[AUTOTEST\]'){ [void]$righeAT.Add($r.Trim()) }
          #  LA RIGA VERA la scrive ABTG_IntradayMomentum v1.00 (TentaIngresso):
          #    Log("%s a mercato @ %.2f lot %.2f SL %.2f (dist %.2f = %.2f x ATR) ...")
          #  e Log() antepone "[A1] ". Il pattern e' preso DAL SORGENTE che
          #  lo produce, non dalla memoria (checklist 55).
          elseif($r -match '\[A1\]\s+(LONG|SHORT) a mercato @ ([0-9]+\.[0-9]+) lot ([0-9]+\.[0-9]+) SL ([0-9]+\.[0-9]+) \(dist ([0-9]+\.[0-9]+)'){
            [void]$righeIN.Add([pscustomobject]@{ Dir=$Matches[1]; Entry=[double]::Parse($Matches[2],$INV);
                                                  Lot=[double]::Parse($Matches[3],$INV); Dist=[double]::Parse($Matches[5],$INV) })
          }
        }
      }
    }
    $Passo0.LogLetti = $letti
    #  >>> IL FAIL VERO E' A TRE STELLE (checklist 55, difetto pagato il
    #      22/08): il sorgente stampa (ok ? "PASS" : "*** FAIL ***"), e i
    #      NOMI dei casi del Guardian contengono "FAIL-OPEN". Un -match
    #      'FAIL' darebbe 12 falsi allarmi; un -cmatch 'FAIL$' non
    #      matcherebbe MAI. Qui si cerca la forma che il sorgente scrive.
    $fallite = @($righeAT | Where-Object { $_ -cmatch '\*\*\*\s*FAIL\s*\*\*\*' })
    $passA1  = @($righeAT | Where-Object { $_ -match '\[A1\]\[AUTOTEST\]' -and $_.TrimEnd() -cmatch 'PASS$' })
    $passGu  = @($righeAT | Where-Object { $_ -notmatch '\[A1\]' -and $_.TrimEnd() -cmatch 'PASS$' })
    $Passo0.AutotestA1       = $passA1.Count
    $Passo0.AutotestGuardian = $passGu.Count
    $Passo0.AutotestFail     = $fallite.Count
    if($righeAT.Count -eq 0){
      $Fatale = "PASSO 0 / AUTOTEST: ZERO righe [AUTOTEST] scritte dopo l'avvio delle passate (log letti: " + $letti + "). Il gate dei criteri par. 3.3 NON HA GUARDATO NIENTE, e un gate che non legge non e' un gate verde. Cause da distinguere prima di rilanciare: (1) il tester non e' partito affatto; (2) i log stanno in una radice che non guardo; (3) InpAutoTest non e' arrivato acceso. In tutti e tre i casi NON e' un via libera."
    }
    elseif($Passo0.AutotestA1 -eq 0){
      #  CONTROLLO POSITIVO (checklist 55): "0 falliti" e "0 righe capite"
      #  non possono finire nello stesso ramo.
      $Fatale = "PASSO 0 / AUTOTEST: " + $righeAT.Count + " righe [AUTOTEST] lette ma NESSUN verdetto PASS del blocco [A1]. O il parser e' cieco, o l'autotest di A1 non e' stato eseguito. Non e' un via libera."
    }
    elseif($fallite.Count -gt 0){
      $Fatale = "PASSO 0 / AUTOTEST: " + $fallite.Count + " casi con '*** FAIL ***'. I criteri (par. 3.3) dicono che i risultati NON SI LEGGONO NEMMENO. Le righe fallite sono nel referto e nello zip: si guarda il CODICE, non si tara niente. Prima riga fallita: " + $fallite[0]
    }
    else{
      #  >>> IL CONTEGGIO ATTESO E' UN MULTIPLO, NON IL NUMERO SECCO, e non
      #      per comodita': l'autotest lo stampa OnInit, e qui le passate
      #      sono DUE (le gemelle). 45 casi x 2 passate = 90 righe PASS, ed
      #      e' il caso NORMALE. Un gate scritto "== 45" darebbe un allarme
      #      rosso a ogni corsa sana, e un allarme che urla sempre non lo
      #      legge piu' nessuno (e' il difetto 47 preso dal lato del rumore).
      #      Quello che NON deve succedere e' un numero che NON e' multiplo
      #      di 45: vorrebbe dire righe perse o sorgente cambiato.
      $mult = 0
      if($CasiAutotestAttesi -gt 0 -and ($Passo0.AutotestA1 % $CasiAutotestAttesi) -eq 0){ $mult = $Passo0.AutotestA1 / $CasiAutotestAttesi }
      $Passo0.Autotest = "PASSATO: " + $Passo0.AutotestA1 + " casi [A1] PASS (= " + $CasiAutotestAttesi + " x " + $mult + " passate), " + $Passo0.AutotestGuardian + " casi Guardian PASS, 0 *** FAIL ***"
      if($mult -eq 0){
        $Passo0.Autotest = "PASSATO CON RISERVA: " + $Passo0.AutotestA1 + " casi [A1] PASS, che NON e' un multiplo di " + $CasiAutotestAttesi
        [void]$Problemi.Add("AUTOTEST: i casi [A1] con verdetto PASS sono " + $Passo0.AutotestA1 + ", che NON e' un multiplo dei " + $CasiAutotestAttesi + " contati nel sorgente (attese 2 passate = " + (2*$CasiAutotestAttesi) + " righe). ZERO FAIL, quindi il gate non ferma il round -- ma o il sorgente e' cambiato, o una parte delle righe si e' persa fra i log. Va guardato PRIMA di leggere i numeri.")
      }
      elseif($mult -ne 2){
        [void]$Note.Add("AUTOTEST: le righe [A1] PASS sono " + $Passo0.AutotestA1 + " = " + $CasiAutotestAttesi + " x " + $mult + ". Le passate del PASSO 0 sono DUE, quindi il numero atteso e' x2: un x1 vuol dire che un blocco non e' stato letto (log in un'altra radice). Non e' un FAIL, ma e' un dato.")
      }
      Dico ($Passo0.Autotest) "Green"
    }

    # =================================================================
    #  4-B-2. I GATE DI SEMPRE, sulle stesse due passate.
    # =================================================================
    $righeA = @()
    # --- G1: il per-trade esiste, e' di ADESSO ed e' popolato
    if($Fatale -eq ""){
      if(-not (Test-Path -LiteralPath $ptA)){
        $Fatale = "PASSO 0 / G1: nessun per-trade prodotto. O lo storico manca su " + $Sym + ", o l'EA non ha CHIUSO niente in 21 mesi (e un motore che opera UNA VOLTA AL GIORNO che non chiude niente e' un motore MUTO: si guardano i log nello zip)."
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

    # =================================================================
    #  4-B-3. IL CANARINO (criteri par. 2.1) e IL CANCELLO ZERO S0
    #  (par. 3.2). NESSUNO DEI DUE FERMA LA CORSA: sono MISURE, e una
    #  misura scomoda e' una risposta, non un guasto (checklist 26-bis).
    # =================================================================
    if($Fatale -eq "" -and $Passo0.N -gt 0){
      #  --- IL CANARINO, contato PER DATA sulla passata intera.
      $nIS = 0; $nOOS = 0; $fuori = 0
      $netti = New-Object System.Collections.ArrayList
      $dirPT = New-Object System.Collections.ArrayList
      for($i=1;$i -lt $righeA.Count;$i++){
        $c = ($righeA[$i] -split ';')
        if($c.Count -lt 8){ continue }
        $dt = [datetime]::MinValue
        $sData = ("" + $c[0]).Trim()
        if($sData.Length -ge 10){ $sData = $sData.Substring(0,10) } else { $sData = "" }
        if($sData -ne "" -and [datetime]::TryParse($sData.Replace(".","-"),$INV,[Globalization.DateTimeStyles]::None,[ref]$dt)){
          if($dt -le $DtMeta){ $nIS++ } elseif($dt -le $DtFine){ $nOOS++ } else { $fuori++ }
        }
        $v = 0.0
        if([double]::TryParse((("" + $c[7]).Trim()),[Globalization.NumberStyles]::Float,$INV,[ref]$v)){ [void]$netti.Add($v) }
        #  deal_type del deal di USCITA: 1 = SELL, cioe' chiude un LONG;
        #  0 = BUY, cioe' chiude uno SHORT. Serve al controllo positivo
        #  dell'accoppiamento con le righe d'ingresso del log.
        [void]$dirPT.Add((("" + $c[4]).Trim()))
      }
      $Passo0.NIS = $nIS; $Passo0.NOOS = $nOOS
      if($netti.Count -gt 0){
        $tot = 0.0; $peggio = 0.0
        foreach($x in $netti){ $tot = $tot + $x; if($x -lt $peggio){ $peggio = $x } }
        $Passo0.NetTot   = [math]::Round($tot,2)
        $Passo0.NetMedio = [math]::Round($tot/$netti.Count,2)
        $Passo0.PeggiorePct = [math]::Round(100.0*$peggio/$Deposito,2)
      }
      [void]$Note.Add("CANARINO MISURATO (criteri par. 2.1), sulla cella NUDA e su TUTTA la finestra: " +
                      $Passo0.N + " operazioni in tutto -> IS " + $nIS + " (" + $IS_Da + " - " + $IS_A + "), OOS " + $nOOS +
                      " (" + $OOS_Da + " - " + $OOS_A + ")" + $(if($fuori -gt 0){ ", piu' " + $fuori + " fuori finestra (da guardare)" } else { "" }) +
                      ".  ATTESO [INFERITO] dai criteri: ~180 IS e ~270 OOS.")
      if($nIS -lt 100){
        [void]$Note.Add("CANARINO: n IS = " + $nIS + " e' SOTTO 100. Emendamento regola B: il MERITO e' SOSPESO, il RISCHIO si giudica lo stesso. LA CORSA NON SI FERMA -- il canarino non e' un gate, e' una misura che cambia COME si legge il round. Il n va scritto ACCANTO A OGNI numero.")
      }
      if($nIS -lt 150 -or $nOOS -lt 150){
        [void]$Note.Add("CANCELLO S4 (n IS >= 150 e n OOS >= 150): con i numeri della cella NUDA sarebbe " + $(if($nIS -ge 150 -and $nOOS -ge 150){ "SUPERATO" } else { "NON superato" }) + ". E' una previsione sulla cella nuda, non il verdetto: il n vero di OGNI cella si legge nei suoi CSV (le celle b e c operano di MENO per costruzione).")
      }
      if($Passo0.PeggiorePct -lt -2.5){
        [void]$Note.Add("BOCCIATURA SECCA n.3 (criteri par. 5.2): la peggior operazione della cella nuda vale " + $Passo0.PeggiorePct.ToString("0.00",$INV) + "% del deposito iniziale, PEGGIO del -2,5% al rischio 1%. Con UNA posizione e UN trade al giorno i criteri dicono che questo e' un BUG, NON un risultato: si guarda il codice, non si tara. [APPROSSIMATO: percentuale calcolata sul deposito INIZIALE, non sull'equity del giorno.]")
      }

      #  --- LA META' MISURABILE DEL CANCELLO ZERO S0.
      #  Il risultato medio per operazione in PUNTI INDICE si ricava
      #  accoppiando i prezzi d'INGRESSO (dal log, che li stampa con
      #  InpVerbose=1) con i prezzi d'USCITA (colonna price del per-trade).
      #  Su questo simbolo 1 punto indice = 1 unita' di prezzo (digits=2,
      #  conversione MISURATA in R97: 1 punto indice = 100 punti MT5).
      #  IL CONTROLLO POSITIVO DELL'ACCOPPIAMENTO: la direzione letta nel
      #  log deve essere l'opposto del deal_type di uscita, riga per riga.
      #  Se non lo e', l'accoppiamento non e' quello che credo e NON si
      #  misura niente (meglio nessun numero che un numero inventato).
      $Passo0.Ingressi = $righeIN.Count
      $prezziOut = New-Object System.Collections.ArrayList
      for($i=1;$i -lt $righeA.Count;$i++){
        $c = ($righeA[$i] -split ';')
        if($c.Count -lt 8){ continue }
        $p = 0.0
        if([double]::TryParse((("" + $c[6]).Trim()),[Globalization.NumberStyles]::Float,$INV,[ref]$p)){ [void]$prezziOut.Add($p) }
        else { [void]$prezziOut.Add(0.0) }
      }
      $nOp = $prezziOut.Count
      $cand = @()
      if($nOp -gt 0 -and $righeIN.Count -ge $nOp -and ($righeIN.Count % $nOp) -eq 0){
        $cand = @(0, ($righeIN.Count - $nOp))     # i primi n, oppure gli ultimi n
      }
      $usato = -1
      foreach($off in $cand){
        $ok = $true
        for($k=0;$k -lt $nOp;$k++){
          $dirLog = $righeIN[$off+$k].Dir
          $dt = $dirPT[$k]
          #  LONG chiuso da un deal SELL (1); SHORT chiuso da un deal BUY (0)
          if(($dirLog -eq "LONG" -and $dt -ne "1") -or ($dirLog -eq "SHORT" -and $dt -ne "0")){ $ok = $false; break }
        }
        if($ok){ $usato = $off; break }
      }
      if($usato -lt 0){
        $Passo0.S0 = "NON MISURABILE DA SCRIPT"
        [void]$Problemi.Add("CANCELLO ZERO S0: non sono riuscito ad accoppiare le " + $righeIN.Count + " righe d'ingresso del log con le " + $nOp + " operazioni del per-trade (il controllo sulla direzione non torna). NON invento un numero: il risultato medio per operazione in punti indice NON e' misurato, e S0 resta interamente DA MISURARE A MANO (istruzioni nel referto).")
      } else {
        $punti = New-Object System.Collections.ArrayList
        for($k=0;$k -lt $nOp;$k++){
          $e = $righeIN[$usato+$k].Entry
          $u = $prezziOut[$k]
          if($e -le 0 -or $u -le 0){ continue }
          if($righeIN[$usato+$k].Dir -eq "LONG"){ [void]$punti.Add($u - $e) } else { [void]$punti.Add($e - $u) }
        }
        if($punti.Count -eq 0){
          $Passo0.S0 = "NON MISURABILE DA SCRIPT (nessuna coppia prezzo valida)"
          [void]$Problemi.Add("CANCELLO ZERO S0: accoppiamento riuscito ma nessuna coppia di prezzi valida. Non misurato.")
        } else {
          $Passo0.PuntiMedi = [math]::Round((Media $punti),3)
          $Passo0.SpreadMax = [math]::Round($Passo0.PuntiMedi/2.0,3)
          $Passo0.S0Misurato = $true
          $Passo0.S0 = "META' MISURATA: risultato medio " + $Passo0.PuntiMedi.ToString("0.###",$INV) + " punti indice/operazione su " + $punti.Count + " operazioni"
          [void]$Note.Add("CANCELLO ZERO S0 (criteri par. 3.2) -- LA META' MISURABILE. Risultato medio per operazione: " +
                          $Passo0.PuntiMedi.ToString("0.###",$INV) + " PUNTI INDICE (" + $punti.Count + " operazioni, cella NUDA, tutta la finestra). " +
                          "E' il risultato NETTO dello spread (si entra all'ask e si esce al bid), quindi il LORDO = netto + spread. " +
                          "La condizione firmata 'lordo >= 3x spread' diventa allora 'netto >= 2x spread', cioe': " +
                          "S0 E' SUPERATO SE LO SPREAD MEDIO DELLA FASCIA 20:30-21:00 SERVER E' <= " + $Passo0.SpreadMax.ToString("0.###",$INV) +
                          " PUNTI INDICE (= " + [math]::Round($Passo0.SpreadMax*$ConversioneR97,1) + " punti MT5, conversione R97). " +
                          "LO SPREAD NON E' MISURATO QUI E NON VIENE INVENTATO: istruzioni per misurarlo a mano nel referto.")
          if($Passo0.PuntiMedi -le 0){
            [void]$Note.Add("CANCELLO ZERO S0: il risultato medio per operazione e' <= 0 punti indice. Con qualunque spread positivo S0 NON PUO' ESSERE SUPERATO, e i criteri (par. 5.2) chiamano questa una BOCCIATURA SECCA. E' una RISPOSTA del round, non un guasto della corsa: la corsa prosegue e produce tutti i CSV.")
          }
        }
      }
    }

    Write-Host ""
    Write-Host "    --- ESITO DEL PASSO 0 ---" -ForegroundColor White
    Write-Host ("    AUTOTEST (gate FATALE)  " + $Passo0.Autotest) -ForegroundColor Yellow
    Write-Host ("      casi [A1] PASS ...... " + $Passo0.AutotestA1 + "   (attesi " + $CasiAutotestAttesi + " x 2 passate = " + (2*$CasiAutotestAttesi) + ")   Guardian PASS: " + $Passo0.AutotestGuardian + "   *** FAIL ***: " + $Passo0.AutotestFail) -ForegroundColor Yellow
    Write-Host ("      log letti ........... " + $Passo0.LogLetti) -ForegroundColor Yellow
    Write-Host ("    operazioni ............ " + $Passo0.N + "   ->  IS " + $Passo0.NIS + " / OOS " + $Passo0.NOOS + "   (CANARINO: NON blocca)") -ForegroundColor White
    Write-Host ("    prima operazione ...... " + $Passo0.PrimaData + "   (limite: " + $LimiteG2 + ")") -ForegroundColor White
    Write-Host ("    ultima operazione ..... " + $Passo0.UltimaData) -ForegroundColor White
    Write-Host ("    gemelli ............... " + $Passo0.Gemelli) -ForegroundColor White
    Write-Host ("    netto medio/operazione  " + $Passo0.NetMedio.ToString("0.00",$INV) + " EUR   totale " + $Passo0.NetTot.ToString("0.00",$INV) + " EUR   peggiore " + $Passo0.PeggiorePct.ToString("0.00",$INV) + "% del deposito") -ForegroundColor White
    Write-Host ("    CANCELLO ZERO S0 ...... " + $Passo0.S0) -ForegroundColor Yellow
    if($Passo0.S0Misurato){
      Write-Host ("      -> S0 superato SE lo spread medio della fascia <= " + $Passo0.SpreadMax.ToString("0.###",$INV) + " punti indice") -ForegroundColor Yellow
      Write-Host  "      -> LO SPREAD VA MISURATO A MANO: le istruzioni sono nel referto." -ForegroundColor Yellow
    }
    Write-Host ("    durata 1 passata ...... " + $Passo0.Minuti.ToString("0.0",$INV) + " min su TUTTA la finestra") -ForegroundColor Yellow
    Write-Host ("    tetto teorico x" + (4*$Lavori.Count) + " ... " + ([math]::Round($Passo0.Minuti*4*$Lavori.Count/60,1)).ToString("0.0",$INV) + " ore -- NON E' UNA PREVISIONE:") -ForegroundColor Yellow
    Write-Host  "                          le passate della griglia coprono META' finestra l'una" -ForegroundColor Yellow
    Write-Host  "                          (IS o OOS) e MT5 le distribuisce sugli agent in parallelo." -ForegroundColor Yellow
    Write-Host ("    -OreMax e' " + $OreMax.ToString("0.0",$INV) + " h: e' un TETTO sull'INIZIO di nuovi file,") -ForegroundColor Yellow
    Write-Host  "                          non una stima e non un'interruzione." -ForegroundColor Yellow
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
  Write-Host ("           " + $l.Desc) -ForegroundColor Cyan
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
      #  >>> E SI LEGGE, non si archivia soltanto. Tre cose, che sono
      #      ESATTAMENTE quelle che il giro a vuoto puo' dire:
      #      (1) la finestra IS che il driver ha CALCOLATO davvero;
      #      (2) che l'unico asse spazzolato e' InpMagic (2 celle);
      #      (3) che il magic e' quello di QUESTO file prova.
      $atx = Get-Content -LiteralPath $ant -Raw
      $mf = [regex]::Match($atx,'(?m)^FromDate=([0-9.]+)\r?$')
      $mt = [regex]::Match($atx,'(?m)^ToDate=([0-9.]+)\r?$')
      if(-not $mf.Success -or -not $mt.Success){ [void]$Problemi.Add("giro a vuoto / " + $l.Et + ": nell'anteprima non trovo FromDate/ToDate.") }
      elseif($mf.Groups[1].Value -ne $IS_Da -or $mt.Groups[1].Value -ne $IS_A){
        [void]$Problemi.Add("giro a vuoto / " + $l.Et + ": il driver generico calcola la finestra IS " + $mf.Groups[1].Value + " - " + $mt.Groups[1].Value +
                            ", ma questa riga (e il referto) dicono " + $IS_Da + " - " + $IS_A + ". O e' cambiata la FrazioneIS del driver, o e' cambiata la finestra: le due cose NON possono divergere.")
      }
      $assiY = @([regex]::Matches($atx,'(?m)^(\w+)=[^\r\n]*\|\|\s*[Yy]\s*\r?$') | ForEach-Object { $_.Groups[1].Value })
      if($assiY.Count -ne 1 -or $assiY[0] -ne "InpMagic"){
        [void]$Problemi.Add("giro a vuoto / " + $l.Et + ": gli assi spazzolati nell'anteprima sono [" + ($assiY -join ", ") + "] invece del solo InpMagic. Piu' di un asse = piu' di 2 celle per finestra, cioe' un altro round.")
      }
      if($atx -notmatch ('(?m)^InpMagic=' + $l.Magic + '\|\|')){
        [void]$Problemi.Add("giro a vuoto / " + $l.Et + ": nell'anteprima InpMagic non parte da " + $l.Magic + ".")
      }
      Copy-Item -LiteralPath $ant -Destination (Join-Path $Sosta ("anteprima_" + $l.Et + ".ini")) -Force
      Remove-Item -LiteralPath $ant -Force -ErrorAction SilentlyContinue
    } else { [void]$Problemi.Add("giro a vuoto: nessuna anteprima .ini per " + $l.Prova) }
  }
  Write-Host ("    esito: " + $l.Esito + "   [" + $l.Min.ToString("0.0",$INV) + " min]") -ForegroundColor Gray
}

if($SoloControllo){
  $nAnt = @(Get-ChildItem -LiteralPath $Sosta -Filter "anteprima_r98*.ini" -ErrorAction SilentlyContinue).Count
  if($nAnt -ne $Lavori.Count){ [void]$Problemi.Add("giro a vuoto: " + $nAnt + " anteprime .ini invece di " + $Lavori.Count + ".") }
  Write-Host ""
  Write-Host ("    anteprime .ini in sosta: " + $nAnt + " su " + $Lavori.Count + "   -> " + $Sosta) -ForegroundColor White
  Write-Host  "    >>> COSA SI LEGGE NELL'ANTEPRIMA, e cosa no:" -ForegroundColor Yellow
  Write-Host  "        SI LEGGE: FromDate/ToDate (la finestra IS vera, calcolata dal" -ForegroundColor Yellow
  Write-Host  "          driver: questa riga la CONFRONTA da sola con la sua), il blocco" -ForegroundColor Yellow
  Write-Host  "          [TesterInputs], l'unico asse Y (InpMagic) e il magic del file." -ForegroundColor Yellow
  Write-Host  "        NON SI LEGGE: 'Model=4' e' una COSTANTE scritta a mano nel ramo" -ForegroundColor Yellow
  Write-Host  "          di prova del driver (cercare 'Model=4' in walkforward_generico)." -ForegroundColor Yellow
  Write-Host  "          Stavolta COINCIDE con la corsa vera (-Modello 4), quindi non" -ForegroundColor Yellow
  Write-Host  "          mente -- ma resta una costante, non una conferma." -ForegroundColor Yellow
  Write-Host  "        E NON SI LEGGE NESSUN NUMERO DI ROUND: niente n, niente canarino," -ForegroundColor Yellow
  Write-Host  "          niente cancello zero. Quelli li misura solo la corsa vera." -ForegroundColor Yellow
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
$Cart = Join-Path $Dsk ("R98_MOMENTUM_NASUSD_" + $Modo + "_" + $Stamp)
$Zip  = Join-Path $Dsk ("R98_MOMENTUM_NASUSD_" + $Modo + "_" + $Stamp + ".zip")
$Referto = Join-Path $Cart "REFERTO_R98.txt"
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
  #  anche le sedie vive): servono al confronto fra le celle.
  if(-not $SoloControllo -and (Test-Path -LiteralPath $Comune)){
    foreach($l in $Lavori){
      foreach($m in @($l.Magic,($l.Magic+1))){
        $f = Join-Path $Comune ("abtg_trades_" + $Ea + "_" + $Sym + "_" + $m + ".csv")
        if(Test-Path -LiteralPath $f){ Copy-Item -LiteralPath $f -Destination (Join-Path $Cart (Split-Path -Leaf $f)) -Force }
      }
    }
  }

  $R = New-Object System.Collections.ArrayList
  [void]$R.Add("REFERTO R98 - MARKET INTRADAY MOMENTUM (A1) SU NASUSD (M5, TICK REALI)")
  [void]$R.Add("modo: " + $Modo + $(if($SoloControllo){ "   <<< GIRO A VUOTO: NESSUNA passata, NESSUN CSV, NESSUN numero di round qui dentro" } else { "" }))
  $sw = @()
  if($SoloControllo){ $sw += "-SoloControllo (nessuna passata)" }
  if($SaltaPasso0)  { $sw += "-SaltaPasso0 (GATE DELL'AUTOTEST NON ESEGUITO: i criteri par. 3.3 chiedono il contrario)" }
  if($RischioSonda -gt 0){ $sw += "-RischioSonda " + $RischioSonda.ToString("0.####",$INV) + " (SOLO le due passate del PASSO 0: le celle firmate girano all'1,00% del file prova)" }
  if($Rifai)        { $sw += "-Rifai (i CSV precedenti sono stati rifatti)" }
  if($sw.Count -eq 0){ $sw += "nessuno (corsa piena, PASSO 0 eseguito, ripresa dei CSV gia' presenti ATTIVA)" }
  [void]$R.Add("switch di questo giro: " + ($sw -join " | "))
  [void]$R.Add("     Senza -Rifai il driver SALTA le finestre gia' presenti. I file saltati sono")
  [void]$R.Add("     marcati 'SALTATO DAL DRIVER' o 'A META'' e finiscono nei PROBLEMI, non in OK.")
  [void]$R.Add("EA: " + $Ea + "  version letta dal sorgente: " + $VersioneLetta + " (attesa " + $VersioneAttesa + ")   magic dell'EA: 772800")
  [void]$R.Add("spread: Spread=" + $SpreadIni + " scritto NELL'INI = spread CORRENTE del feed BCM, dichiarato.")
  [void]$R.Add("     NON e' uno stress di spread, e NON e' la misura che chiede il CANCELLO ZERO S0.")
  [void]$R.Add("data: " + (Get-Date).ToString("yyyy-MM-dd HH:mm:ss",$INV) + "   (questa data deve essere di ADESSO)")
  [void]$R.Add("     ATTENZIONE: la data fresca NON distingue un giro a vuoto da una corsa.")
  [void]$R.Add("     Quello che lo distingue e' la riga 'modo:' qui sopra e il NOME della cartella.")
  [void]$R.Add("avvio: " + $Avvio.ToString("yyyy-MM-dd HH:mm:ss",$INV) + "   durata: " + ((New-TimeSpan -Start $Avvio -End (Get-Date)).TotalHours).ToString("0.0",$INV) + " ore")
  [void]$R.Add("pin: " + $Pin)
  [void]$R.Add("criteri: risultati_archivio\R98_CRITERI.md   (FIRMATI il 22/08/2026: opzione A, PF OOS >= 1,20)")
  [void]$R.Add("finestra: " + $DaQuando + " -> " + $Fino + "   split 40/60")
  [void]$R.Add("     IS  " + $IS_Da + " - " + $IS_A)
  [void]$R.Add("     OOS " + $OOS_Da + " - " + $OOS_A)
  [void]$R.Add("     (le stesse di R97 e R88: e' l'unico modo di confrontare i round alla pari)")
  [void]$R.Add("")
  [void]$R.Add("--- IL GATE FATALE: L'AUTOTEST (criteri par. 3.3) ---")
  [void]$R.Add("  " + $Passo0.Autotest)
  [void]$R.Add("  casi [A1] con verdetto PASS : " + $Passo0.AutotestA1 + "   (attesi " + $CasiAutotestAttesi + " CONTATI nel sorgente, x2 perche' le passate del PASSO 0 sono DUE: " + (2*$CasiAutotestAttesi) + ")")
  [void]$R.Add("  casi Guardian con PASS      : " + $Passo0.AutotestGuardian)
  [void]$R.Add("  casi '*** FAIL ***'         : " + $Passo0.AutotestFail + "   (uno solo basta a fermare tutto)")
  [void]$R.Add("  log del tester letti        : " + $Passo0.LogLetti)
  [void]$R.Add("  NOTA: il FAIL vero e' a TRE STELLE. I NOMI dei casi del Guardian")
  [void]$R.Add("  contengono 'FAIL-OPEN': un parser che cercasse 'FAIL' darebbe 12 falsi")
  [void]$R.Add("  allarmi, uno che cercasse 'FAIL' a fine riga non matcherebbe MAI")
  [void]$R.Add("  (checklist 55, pagato il 22/08). Qui si conta anche il POSITIVO.")
  [void]$R.Add("")
  [void]$R.Add("--- LA CONVERSIONE DEI PUNTI: CITATA, NON RIMISURATA ---")
  [void]$R.Add("  1 punto indice = " + $ConversioneR97 + " punti MT5 su " + $Sym + ".")
  [void]$R.Add("  MISURATA in R97 (R97_REFERTO par. 3, gate firmato e CHIUSO): due misure")
  [void]$R.Add("  indipendenti concordi -- 1.960 ordini in modo FIXED (mediana 10 di prezzo)")
  [void]$R.Add("  e digits=2 del per-trade. Stesso simbolo, stesso broker, stessa finestra.")
  [void]$R.Add("  A COSA SERVE QUI: (1) InpSlippagePts=100 della cella R98e vale 1 PUNTO")
  [void]$R.Add("  INDICE; (2) i punti indice del cancello zero si convertono in punti MT5.")
  [void]$R.Add("")
  [void]$R.Add("--- IL CANCELLO ZERO S0 (criteri par. 3.2) ---")
  [void]$R.Add("  stato: " + $Passo0.S0)
  if($Passo0.S0Misurato){
    [void]$R.Add("  risultato medio per operazione : " + $Passo0.PuntiMedi.ToString("0.###",$INV) + " PUNTI INDICE")
    [void]$R.Add("       (cella NUDA, tutta la finestra, " + $Passo0.Ingressi + " ingressi letti nel log)")
    [void]$R.Add("       E' il NETTO dello spread: si entra all'ask e si esce al bid.")
    [void]$R.Add("       Quindi LORDO = netto + spread, e 'lordo >= 3x spread' diventa")
    [void]$R.Add("       'netto >= 2x spread'.")
    [void]$R.Add("  >>> S0 E' SUPERATO SE lo spread medio di " + $Sym + " nella fascia")
    [void]$R.Add("      20:30-21:00 SERVER e' <= " + $Passo0.SpreadMax.ToString("0.###",$INV) + " PUNTI INDICE")
    [void]$R.Add("      (= " + [math]::Round($Passo0.SpreadMax*$ConversioneR97,1) + " punti MT5).")
  }
  [void]$R.Add("  >>> LO SPREAD NON E' MISURATO DA QUESTO SCRIPT, E NON E' INVENTATO. <<<")
  [void]$R.Add("  S0 = DA MISURARE A MANO. Perche': lo spread STORICO di una fascia oraria")
  [void]$R.Add("  non e' leggibile da PowerShell (sta dentro i tick binari di MT5), e")
  [void]$R.Add("  Spread=0 nell'ini vuol dire 'spread corrente del feed', non e' una misura.")
  [void]$R.Add("  COME MISURARLO, in ordine di onesta':")
  [void]$R.Add("   (a) MT5 aperto, grafico " + $Sym + " M1, indicatore 'Spread' di sistema, e si")
  [void]$R.Add("       guardano le barre fra le 20:30 e le 21:00 SERVER per qualche settimana:")
  [void]$R.Add("       e' lo spread di ADESSO, non quello del 2024, e va detto.")
  [void]$R.Add("   (b) Vista > Finestra Dati / Specifica del simbolo: spread corrente e")
  [void]$R.Add("       tipico dichiarati dal broker. Idem, e' oggi.")
  [void]$R.Add("   (c) la misura VERA sullo storico chiede uno script MQL5 che scorra i tick")
  [void]$R.Add("       della fascia e faccia la media di (ask-bid): NON esiste ancora in")
  [void]$R.Add("       casa. Se il round arriva a dipendere da quel numero, si scrive quello")
  [void]$R.Add("       script e si rifa' un giro dal verificatore -- non si stima a occhio.")
  [void]$R.Add("  Il numero misurato va scritto QUI ACCANTO, con la data e il metodo.")
  [void]$R.Add("")
  [void]$R.Add("--- IL CANARINO (criteri par. 2.1) -- E' UNA MISURA, NON UN GATE ---")
  [void]$R.Add("  operazioni della cella NUDA su tutta la finestra : " + $Passo0.N)
  [void]$R.Add("       di cui IS  : " + $Passo0.NIS + "   (atteso [INFERITO] ~180)")
  [void]$R.Add("       di cui OOS : " + $Passo0.NOOS + "   (atteso [INFERITO] ~270)")
  [void]$R.Add("  COMPORTAMENTO DICHIARATO: se n IS < 100 la corsa SEGNALA e PROSEGUE.")
  [void]$R.Add("  Emendamento regola B: il campione sottile sospende il giudizio sul MERITO,")
  [void]$R.Add("  MAI sul RISCHIO. Il canarino cambia COME si legge il round, non SE si")
  [void]$R.Add("  legge. E il n va scritto ACCANTO A OGNI numero, sempre.")
  [void]$R.Add("  ATTENZIONE: questo n e' quello della cella NUDA. Le celle b (secondo")
  [void]$R.Add("  segnale) e c (soglia 0,10%) operano DI MENO per costruzione: il loro n")
  [void]$R.Add("  vero si legge nei loro CSV, non qui.")
  [void]$R.Add("")
  [void]$R.Add("--- PASSO 0 (gli altri gate) ---")
  [void]$R.Add("  0-A barre M1+M5 .... " + $Storico.Esito + "   (chieste dal " + $DaQuando + ")")
  [void]$R.Add("      I TICK non sono stati riscaricati: sono gia' MISURATI e agli atti")
  [void]$R.Add("      (NASUSD 164.636.788 dal 2024.09.26, REFERTO_R83_R84_PREPARAZIONE riga 620).")
  [void]$R.Add("      Le barre M1 servono DAVVERO: l'EA misura le mezz'ore con CopyRates su M1.")
  [void]$R.Add("  eseguito ........... " + $Passo0.Fatto)
  [void]$R.Add("  prima operazione ... " + $Passo0.PrimaData + "   (limite dei criteri: " + $LimiteG2 + ")")
  [void]$R.Add("  ultima operazione .. " + $Passo0.UltimaData)
  [void]$R.Add("  gemelli ............ " + $Passo0.Gemelli)
  [void]$R.Add("  netto medio/op ..... " + $Passo0.NetMedio.ToString("0.00",$INV) + " EUR    totale " + $Passo0.NetTot.ToString("0.00",$INV) + " EUR")
  [void]$R.Add("  peggior operazione . " + $Passo0.PeggiorePct.ToString("0.00",$INV) + "% del deposito iniziale")
  [void]$R.Add("      (criteri par. 5.2: peggio di -2,5% al rischio 1% e' un BUG, non un")
  [void]$R.Add("       risultato. APPROSSIMATO: sul deposito INIZIALE, non sull'equity del giorno.)")
  [void]$R.Add("     NOTA: 'NON MISURATO' NON e' 'va bene'. Un gate che non legge niente non")
  [void]$R.Add("     e' un gate verde, ed e' un esito FATALE.")
  [void]$R.Add("")
  [void]$R.Add("--- LAVORI ---   (attese: " + $CelleAttese + " righe per CSV, " + (2*$Lavori.Count) + " CSV, " + (4*$Lavori.Count) + " passate)")
  [void]$R.Add(("{0,-34} {1,-12} {2,-5} {3,-5} {4,-8} {5}" -f "FILE","ET","IS","OOS","MIN","ESITO"))
  foreach($l in $Lavori){
    [void]$R.Add(("{0,-34} {1,-12} {2,-5} {3,-5} {4,-8} {5}" -f $l.Prova,$l.Et,$l.IS,$l.OOS,$l.Min.ToString("0.0",$INV),$l.Esito))
  }
  [void]$R.Add("")
  [void]$R.Add("--- LE CELLE, COME SONO SCRITTE NEI FILE CHE HANNO GIRATO ---")
  foreach($l in $Lavori){
    if(-not $l.Cella){ continue }
    [void]$R.Add(("  {0,-12} overnight={1}  soglia={2}%  secondo={3}  SLatr={4}  slippage={5} pt  lati L{6}/S{7}  magic {8}/{9}" -f $l.Et,$l.Over,$l.Soglia,$l.Secondo,$l.SLatr,$l.Slip,$l.Long,$l.Short,$l.Magic,($l.Magic+1)))
  }
  [void]$R.Add("")
  [void]$R.Add("--- LE DUE PASSATE DIAGNOSTICHE SUI LATI: NON SONO CELLE (par. 4.1) ---")
  foreach($l in $Lavori){
    if($l.Cella){ continue }
    [void]$R.Add(("  {0,-12} lati L{1}/S{2}  magic {3}/{4}   <<< NON entra in nessun cancello" -f $l.Et,$l.Long,$l.Short,$l.Magic,($l.Magic+1)))
  }
  [void]$R.Add("  Servono a DICHIARARE, non a scegliere. Malattia R52: un lato non si")
  [void]$R.Add("  spegne MAI guardando i risultati. Se il round finisse con 'teniamo solo i")
  [void]$R.Add("  long', quella e' una decisione da FIRMARE A PARTE, in un round dopo.")
  [void]$R.Add("  E il regime della finestra e' prevalentemente RIALZISTA: un 'solo long'")
  [void]$R.Add("  che brilla non ha dimostrato niente sul lato, ha dimostrato il regime.")
  [void]$R.Add("")
  [void]$R.Add("--- I PER-TRADE (abtg_trades_..._7728xx.csv): COSA COPRONO ---")
  [void]$R.Add("  QUELLI DELLE CELLE: l'EA li riscrive a OGNI passata sullo stesso nome")
  [void]$R.Add("  (magic), e le due finestre girano IN ORDINE: prima IS, poi OOS. Quelli")
  [void]$R.Add("  nello zip contengono quindi SOLO LA FINESTRA OOS: l'OOS ha sovrascritto")
  [void]$R.Add("  l'IS. NON sono la serie completa del round e NON si usano cosi' per un DD")
  [void]$R.Add("  di portafoglio. I numeri di round si leggono nei CSV IS/OOS.")
  [void]$R.Add("  QUELLI DEL PASSO 0 (passo0_pertrade_" + $MagicA + "/" + $MagicB + "): coprono invece TUTTA")
  [void]$R.Add("  la finestra " + $DaQuando + " -> " + $Fino + ", perche' erano passate SINGOLE. Sono loro")
  [void]$R.Add("  la base del canarino e del cancello zero.")
  [void]$R.Add("")
  [void]$R.Add("--- COME SI LEGGE (e in che ordine) ---")
  [void]$R.Add("  1. L'AUTOTEST. Se c'e' anche un solo '*** FAIL ***', i numeri sotto NON")
  [void]$R.Add("     si leggono nemmeno (criteri par. 3.3): si guarda il CODICE.")
  [void]$R.Add("  2. IL CANCELLO ZERO S0. E' il primo cancello del round e quello che fa il")
  [void]$R.Add("     lavoro pesante (la firma del 22/08 lo dice a chiare lettere). Finche'")
  [void]$R.Add("     lo spread della fascia non e' MISURATO, S0 non e' deciso -- e senza S0")
  [void]$R.Add("     nessun PF vuol dire niente, perche' un PF calcolato su un lordo che")
  [void]$R.Add("     non copre i costi e' una promessa che il conto vero non mantiene.")
  [void]$R.Add("  3. IL CANARINO. Il n IS e il n OOS vanno scritti ACCANTO A OGNI numero.")
  [void]$R.Add("     Sotto 100 in IS: MERITO SOSPESO, si legge il RISCHIO (regola B).")
  [void]$R.Add("  4. LA CELLA NUDA (r98rif) PER PRIMA E DA SOLA: e' il paper letterale, ed")
  [void]$R.Add("     e' il metro di tutte le altre. Si scrive PRIMA di guardare a/b/c/d/e.")
  [void]$R.Add("  5. poi i cancelli S1-S4:  DD OOS <= 7,00%  |  PF OOS >= 1,20 (opzione A")
  [void]$R.Add("     FIRMATA: questo motore non ha TP, il payoff e' simmetrico, e chiedere")
  [void]$R.Add("     1,40 sarebbe un'unita' di misura sbagliata)  |  IS profit > 0 e PF IS")
  [void]$R.Add("     >= 1,10  |  n OOS >= 150 e n IS >= 150.")
  [void]$R.Add("  6. LE BOCCIATURE SECCHE (par. 5.2): profitto netto <= 0 in OOS; S0")
  [void]$R.Add("     fallito; peggior giornata peggio di -2,5% al rischio 1% (che e' un BUG,")
  [void]$R.Add("     non un risultato).")
  [void]$R.Add("  7. R98e (slippage) NON e' promuovibile: e' una misura di FRAGILITA'.")
  [void]$R.Add("     Si legge come 'quanto scala la cella nuda', non come una cella.")
  [void]$R.Add("  8. LE DUE DIAGNOSTICHE non entrano in nessun cancello. Si dichiarano.")
  [void]$R.Add("  9. REGIME: UNO SOLO (indici USA 2024-2026, prevalentemente rialzista).")
  [void]$R.Add("     Il paper dichiara che la predittivita' SALE nei giorni volatili e in")
  [void]$R.Add("     recessione: se il nostro regime e' calmo, R98 misura il caso")
  [void]$R.Add("     SFAVOREVOLE al motore. Va scritto in ENTRAMBE le direzioni.")
  [void]$R.Add(" 10. R98 NON PRODUCE SEDIE (criteri par. 6). Al massimo una PROPOSTA di")
  [void]$R.Add("     round di deploy, con criteri propri. E un verdetto negativo pulito")
  [void]$R.Add("     vale quanto uno positivo.")
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
      [void]$R.Add("       E NESSUN CANARINO e NESSUN CANCELLO ZERO: quelli si misurano solo")
      [void]$R.Add("       nella corsa vera, al PASSO 0.")
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
#  >>> L'ETICHETTA NON PUO' DIRE "PASSATO" QUANDO NON E' STATO ESEGUITO
#      (checklist 47 e 50).
if($SoloControllo){
  Write-Host  "  AUTOTEST: NON ESEGUITO, ed e' giusto cosi': il giro a vuoto non apre MT5." -ForegroundColor Yellow
  Write-Host  "            Il gate FATALE dei criteri par. 3.3 si misura nella CORSA VERA." -ForegroundColor Yellow
} elseif($Passo0.AutotestA1 -gt 0 -and $Passo0.AutotestFail -eq 0){
  Write-Host ("  AUTOTEST: " + $Passo0.Autotest) -ForegroundColor Yellow
} else {
  Write-Host ("  AUTOTEST: " + $Passo0.Autotest + "   <<< il gate dei criteri par. 3.3") -ForegroundColor Red
  Write-Host  "            non ha un verdetto verde: i numeri non si leggono." -ForegroundColor Red
}
if($SoloControllo){
  Write-Host ("  MODO: " + $Modo + " -- GIRO A VUOTO. NESSUNA passata, NESSUN CSV, NESSUN") -ForegroundColor Yellow
  Write-Host ("        numero di round. Anteprime .ini attese: " + $Lavori.Count + ".") -ForegroundColor Yellow
  Write-Host  "        QUESTO ZIP NON E' IL ROUND e non va mandato come risultato." -ForegroundColor Yellow
} else {
  Write-Host ("  MODO: " + $Modo) -ForegroundColor White
  Write-Host ("  ATTESI:  " + (2*$Lavori.Count) + " CSV (" + $Lavori.Count + " file x IS/OOS), " + $CelleAttese + " righe l'uno, " + (4*$Lavori.Count) + " passate,") -ForegroundColor White
  Write-Host  "           piu' 2 per-trade del PASSO 0 e i per-trade delle celle." -ForegroundColor White
  Write-Host ("  CANARINO MISURATO: n IS " + $Passo0.NIS + " / n OOS " + $Passo0.NOOS + "   (NON e' un gate: regola B)") -ForegroundColor White
  Write-Host ("  CANCELLO ZERO S0 : " + $Passo0.S0) -ForegroundColor White
  Write-Host  "                     lo SPREAD della fascia va MISURATO A MANO: leggi il referto." -ForegroundColor White
}
foreach($l in $Lavori){
  $c = "Green"; if($l.Esito -ne "OK" -and $l.Esito -ne "SOLO CONTROLLO"){ $c = "Yellow" }
  Write-Host ("   " + $l.Prova.PadRight(34) + " " + $l.Esito) -ForegroundColor $c
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
