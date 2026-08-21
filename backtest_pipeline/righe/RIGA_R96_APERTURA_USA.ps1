# =====================================================================
#  MARCATORE_RIGA_R96_v1
#  RIGA_R96_APERTURA_USA.ps1  --  R96: l'apertura americana COSTRUISCE
#  il segnale (medie 9/21 di sessione) su U30USD e NASUSD, M5
# ---------------------------------------------------------------------
#  >>> NON SI MANDA A CLAUDIO FINCHE' R96_CRITERI.md NON E' FIRMATO. <<<
#  I criteri sono una BOZZA. Questa riga esiste perche' sia pronta il
#  minuto dopo la firma, non per partire prima.
#
#  DA DOVE NASCE QUESTO SCRIPT, dichiarato: e' RIGA_R95_LIQSWEEP_JPY.ps1
#  v7 adattata. Il punto 9 della checklist dice che una riscrittura non
#  puo' perdere le funzioni di sicurezza del gemello: sono state
#  riportate TUTTE, una per una -- pin di $EABranch nei due script che
#  lo hanno scritto fisso, install dell'include, diff dei file prova,
#  cache contata prima E dopo, magic del gate diverso da quello della
#  griglia, sosta prima dei gate, funzioni sopra il try, MODO nel nome
#  e nel referto, tre radici di log, \r? davanti a ogni $ multilinea.
#
#  COSA FA, in ordine, e DA SOLA:
#    0. si rifiuta di partire se MT5 O MetaEditor sono aperti (checklist 7 e 39)
#    1. scarica AL PIN driver, include, 4 file prova e il sorgente .mq5
#       - PINNA $EABranch dentro walkforward_generico.ps1 (cercare
#         '$EABranch=': e' scritto fisso su "lavoro", quindi senza
#         questo un pin pinna gli script e NON il motore -- difetto 24)
#       - INSTALLA ABTG_PausaGuardian.mqh, che nessun driver installa
#         (checklist 33-bis)
#       - aggiunge [Charts] MaxBars all'ini del tester, con gate sullo
#         STATO FINALE e non sul replace (checklist 33)
#       - DIFF dei 4 file prova: DUE righe diverse su 29 (29 e' MISURATA
#         il 21/08 sull'artefatto vero, non scritta a memoria), e le due
#         righe devono essere InpAncoraSessione e InpMagic
#    2. FASE COMPILA: metaeditor64 /compile, .ex5 SCRITTO ADESSO
#       (il -SoloControllo del driver generico NON compila: punto 39)
#    3. PASSO 0-A: barre M1+M5 dei due simboli dal broker, -SenzaTick.
#       I TICK NON si riscaricano: sono gia' MISURATI e agli atti
#       (U30USD 67.618.571 dal 2024.09.26, REFERTO_ROUND88 par.7;
#        NASUSD 164.636.788 dal 2024.09.26, REFERTO_R83_R84 riga 620).
#       Riscaricarli aprirebbe la finestra del difetto 30 (il guardiano
#       di progresso che ammazza MT5 in mezzo alla fase dei tick).
#    4. PASSO 0-C - E' UN GATE, NON UN CONTORNO. Due passate SINGOLE
#       gemelle sulla cella A di U30USD, con magic PROPRI (779690/779691,
#       diversi da quelli della griglia), derivate DAL FILE PROVA che
#       gira davvero (checklist 33). Si legge:
#         G1  il per-trade esiste, e' di ADESSO ed e' popolato?
#         G2  la PRIMA DATA -> i dati coprono la finestra? (TryParse
#             guardato: "non ho potuto misurare" e "va bene" sono due
#             esiti DIVERSI)
#         G3  i gemelli sono identici? -> il banco e' pulito?
#         G4  [XEMAAP][CONTEGGIO] nei log delle TRE radici:
#             sessioni=0 -> L'ANCORA NON HA TROVATO NIENTE, cioe' la
#             cella non e' brutta: NON E' GIRATA. E' FATALE.
#             ZERO log letti -> "NON LETTO", ed e' FATALE lo stesso.
#         G5  [XEMAAP][AUTOTEST] esito motore -> CINQUE BLOCCHI SU
#             CINQUE. Si legge QUI, in una esecuzione vera nel tester,
#             non chiedendo a Claudio di premere un tasto che non
#             produce quell'output (checklist 20).
#       Se uno di questi e' rosso, LA CORSA NON PARTE.
#    5. la catena dei 4 file, UNO ALLA VOLTA (una macchina, un lavoro)
#    6. raccolta SEMPRE: cartella sul Desktop + zip, coi numeri attesi
#       dichiarati PRIMA. Tutto cio' che la raccolta usa nasce PRIMA del
#       try che puo' fallire (checklist 41-bis e 48, funzioni comprese).
#
#  QUELLO CHE NON FA, dichiarato:
#    - non giudica nessun numero: produce i CSV e li conta
#    - non tocca nessuna sedia viva. In particolare NON tocca ABTG_ORB
#      (magic 770601), che gira sullo stesso simbolo e sulla stessa
#      apertura: R96 usa magic vergini del blocco 7796xx
#    - non tocca ABTG_CrossEma ne' i risultati di R86
#    - non ammazza un lavoro in corso allo scadere di -OreMax: smette
#      solo di iniziarne di nuovi (checklist 19)
#
#  LA RIGA CHE SI INCOLLA (blocco INTERO, un comando solo - checklist 21).
#  <PIN> = il commit che contiene QUESTO file: e' l'hash dato in chat.
#
#  & { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
#      if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
#      $pin='<PIN>'; $p="$env:USERPROFILE\RIGA_R96.ps1"; Remove-Item $p -EA SilentlyContinue;
#      irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_R96_APERTURA_USA.ps1" -OutFile $p;
#      if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_R96_v1' -Quiet)){ throw 'SCRIPT VECCHIO' };
#      $global:LASTEXITCODE=0; & $p -Pin $pin; if($LASTEXITCODE -ne 0){ Write-Host 'ESITO: PARZIALE O FERMO - leggi il REFERTO' } }
#
#  GIRO A VUOTO (dieci secondi, nessuna passata, nessun MT5 che opera):
#    ... & $p -Pin $pin -SoloControllo
#  Il giro a vuoto controlla ESATTAMENTE gli stessi 4 file prova che
#  girano nella corsa vera. Non c'e' un secondo artefatto (checklist 33).
# =====================================================================
param(
  # -Pin NON ha default: un default silenzioso ("lavoro") farebbe girare la
  #  punta del branch spacciandola per un commit congelato. Meglio morire.
  [string]$Pin       = "",
  [double]$OreMax    = 8.0,        # oltre questo NON si iniziano nuovi file
  [switch]$Rifai,
  [switch]$SoloControllo,
  [switch]$SaltaPasso0            # SOLO per rilanciare una coda gia' gatata.
                                  #   Se lo usi, il referto lo scrive in rosso.
)
$ErrorActionPreference = "Stop"
[Threading.Thread]::CurrentThread.CurrentCulture   = [Globalization.CultureInfo]::InvariantCulture
[Threading.Thread]::CurrentThread.CurrentUICulture = [Globalization.CultureInfo]::InvariantCulture
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$INV = [Globalization.CultureInfo]::InvariantCulture

$Avvio = Get-Date
$Stamp = $Avvio.ToString("yyyyMMdd_HHmm", $INV)
$Dsk   = Join-Path $env:USERPROFILE "Desktop"
$Work  = Join-Path $env:USERPROFILE "abtg_r96"
$Prove = Join-Path $Work "prove"
$Logs  = Join-Path $Work "log_r96"
$SrcDir= Join-Path $Work "src_motori"
$RawPin= "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$Pin"

$Ea       = "ABTG_CrossEmaApertura"
$Simboli  = @("U30USD","NASUSD")
$Periodo  = "M5"
$DaQuando = "2024.09.26"      # MISURATO, non prudente: e' il muro del broker
$Fino     = "2026.06.30"
$Modello  = 4                 # TICK REALI. I tick di entrambi i simboli sono misurati
$Deposito = 100000            # come REFERTO_ROUND88 su U30USD M5: unico riferimento confrontabile
$SpreadIni= 0                 # 0 = spread CORRENTE, ma SCRITTO nell'ini invece che
                              #     lasciato allo stato nascosto del terminale.
                              #     NON e' uno stress di spread: e' una dichiarazione.
$CelleAttese = 2              # per file, per finestra: le due passate gemelle
$MagicA   = 779690      # PASSO 0, passata A
$MagicB   = 779691      # PASSO 0, passata B (gemella di controllo)
#  I magic della GRIGLIA stanno nei file prova (779610/11, 779620/21,
#  779630/31, 779640/41) e NON coincidono mai con quelli del gate: se le
#  due fasi condividessero il magic, le passate di ottimizzazione
#  riscriverebbero il per-trade su cui il gate ha dato il via libera
#  (checklist 41, gia' pagato in R82). Qui il gate ha i suoi.
$MagicVietati = @(770601)   # ABTG_ORB, sedia VIVA sullo stesso simbolo e sulla
                            #  stessa apertura: se comparisse in un file prova
                            #  sarebbe una collisione, e ci si ferma.

#--- IL LIMITE DEL GATE G2. La finestra parte dal 2024.09.26; un motore che
#    opera 3 ore al giorno deve aver tradato entro i primi tre mesi. Se la
#    prima operazione e' oltre, i dati non coprono l'inizio della finestra.
$LimiteG2 = "2024.12.31"

#--- RIGHE VIVE ATTESE nei file prova. MISURATA il 21/08/2026 su tutti e
#    quattro con `grep -vE '^\s*(#|$)' | wc -l`: 3 direttive @ + 26
#    parametri = 29. NON scritta a memoria (checklist 40-bis).
$RigheAttese = 29
#--- e le righe che possono differire, PER NOME e PER COPPIA. Contare "2
#    righe diverse" non basta: se cambiassero due righe SBAGLIATE il
#    conteggio tornerebbe lo stesso e il round misurerebbe due cose
#    insieme. Il confronto e' fatto a coppie nella sezione 1d.

#--- TUTTO CIO' CHE LA RACCOLTA USA NASCE QUI, PRIMA DEL try (checklist 41-bis),
#    FUNZIONI COMPRESE (checklist 48: in PowerShell una `function` non e'
#    dichiarativa, e' un'istruzione: se il flusso non ci passa sopra, il nome
#    non esiste, e la raccolta esplode proprio nella corsa fermata da un gate).
$Risultati = Join-Path $Work "risultati_prove"
$Comune    = Join-Path $env:APPDATA "MetaQuotes\Terminal\Common\Files"
$Sosta     = Join-Path $Work "sosta"
$Passo0    = @{ Fatto=$false; PrimaData=""; UltimaData=""; N=0; Giorni=0.0;
                Gemelli="NON MISURATO"; Conteggio="NON LETTO"; Autotest="NON LETTO";
                Sessioni=-1; Incroci=-1; Ingressi=-1; Minuti=0.0; LogLetti=0 }
$Storico   = @{ Eseguito=$false; Esito="NON ESEGUITO" }
$Problemi = New-Object System.Collections.ArrayList
$Note     = New-Object System.Collections.ArrayList
$Fatale   = ""
$nAnt     = -1        # -1 = non misurato (checklist 41-bis, terza occasione)

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

function L($f,$et,$sym,$cella){
  return [pscustomobject]@{ Prova=$f; Et=$et; Sym=$sym; Cella=$cella; Esito="NON ESEGUITO"; IS=-1; OOS=-1; Min=0.0 }
}

#  >>> CsvDi E RigheVive STANNO QUI, SOPRA IL try. <<<
#  Il throw che salta la sezione 5 e' IL CASO NORMALE di questa riga: i cinque
#  gate del PASSO 0 lanciano PRIMA, e cosi' il diff dei file prova e la
#  compilazione. Se queste funzioni nascessero dentro il try, la raccolta
#  morirebbe con "The term 'CsvDi' is not recognized" e NON CI SAREBBE NESSUN
#  REFERTO proprio nella corsa fermata, che e' l'unica in cui serve a capire
#  perche'. CHI LE RIPORTA DENTRO IL try RIAPRE IL DIFETTO 48.
#  A Modello 4 il driver NON aggiunge il suffisso "_ohlc": lo aggiunge solo
#  ai modelli diversi da 4 (walkforward_generico.ps1, cercare '$Suffisso =').
#  Se un giorno si scendesse a Modello 1, questa funzione va cambiata insieme.
function CsvDi($l,$tag){
  return (Join-Path $Risultati ($Ea + "\" + $Ea + "_" + $l.Sym + "_" + $tag + "_" + $l.Et + ".csv"))
}
function RigheVive($p){
  return @(Get-Content -LiteralPath $p | Where-Object { $_ -notmatch '^\s*#' -and $_ -notmatch '^\s*$' })
}
function NomeDi($riga){
  if($riga -match '^@'){ return ($riga -split '\s+')[0] }
  return (($riga -split '=')[0]).Trim()
}
#  DiffNomi e Pretendi stanno QUI SOPRA IL try insieme alle altre, e non
#  dentro la sezione 1d dove vengono usate: e' la regola del punto 48 presa
#  sul serio invece che aggirata perche' "tanto la raccolta non le chiama".
#  Le funzioni di servizio stanno in cima, sempre.
$Vive = @{}    # etichetta -> righe vive del file prova (riempita nella sezione 1d)
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

$Lavori = @(
  (L "R96a_ancora_U30USD.txt"     "r96adow" "U30USD" "A ancora ACCESA (il motore)"),
  (L "R96a_ancora_NASUSD.txt"     "r96anas" "NASUSD" "A ancora ACCESA (il motore)"),
  (L "R96b_controllo_U30USD.txt"  "r96bdow" "U30USD" "B ancora SPENTA (CONTROLLO, non promuovibile)"),
  (L "R96b_controllo_NASUSD.txt"  "r96bnas" "NASUSD" "B ancora SPENTA (CONTROLLO, non promuovibile)")
)

Write-Host ""
Write-Host "#####################################################################" -ForegroundColor Cyan
Write-Host "#  R96 - L'APERTURA USA COSTRUISCE IL SEGNALE (U30USD e NASUSD M5)  #" -ForegroundColor Cyan
Write-Host "#####################################################################" -ForegroundColor Cyan
Dico ("pin      : " + $Pin)
Dico ("cartella : " + $Work)

# =====================================================================
#  I NUMERI ATTESI, DICHIARATI PRIMA. Se a fine corsa non tornano,
#  il round non si legge.
# =====================================================================
Titolo "NUMERI ATTESI (dichiarati PRIMA della corsa)"
Write-Host "    file prova ...................  4   (2 celle x 2 simboli)" -ForegroundColor White
Write-Host "    celle per file per finestra ..  2   (le due passate GEMELLE di controllo)" -ForegroundColor White
Write-Host "    CSV attesi ...................  8   (4 file x IS/OOS)" -ForegroundColor White
Write-Host "    righe per CSV ................  2" -ForegroundColor White
Write-Host "    passate totali ...............  16" -ForegroundColor White
Write-Host "    passate del PASSO 0 ..........  2   (gemelle, cella A su U30USD)" -ForegroundColor White
Write-Host "    modello ......................  4 = TICK REALI" -ForegroundColor White
Write-Host ("    finestra .....................  " + $DaQuando + " -> " + $Fino + "  (split 40/60)") -ForegroundColor White
Write-Host "    IS / OOS .....................  NON le scrivo qui a memoria: si LEGGONO" -ForegroundColor Gray
Write-Host "                                    nell'anteprima .ini del giro a vuoto" -ForegroundColor Gray
Write-Host "                                    (FromDate/ToDate). Il driver le calcola" -ForegroundColor Gray
Write-Host "                                    lui, ed e' l'artefatto che gira davvero." -ForegroundColor Gray
Write-Host ("    deposito .....................  " + $Deposito + "   rischio 1,00% pinnato nei file prova") -ForegroundColor White
Write-Host ("    spread .......................  Spread=" + $SpreadIni + " nell'ini = spread CORRENTE, dichiarato.") -ForegroundColor White
Write-Host "                                    NON e' uno stress: toglie lo stato nascosto." -ForegroundColor Gray
Write-Host ""
Write-Host "    QUANTO CI METTE: [STIMA] 1-2 ore. Il riferimento e' R88 (U30USD M5," -ForegroundColor Yellow
Write-Host "    tick reali, 27 file in 2h16). R96 ha 16 passate: dovrebbe essere meno." -ForegroundColor Yellow
Write-Host "    Il PASSO 0 MISURA una passata intera e stampa la stima x16." -ForegroundColor Yellow
Write-Host ""
Write-Host "    >>> QUESTO ROUND NON PRODUCE NESSUNA SEDIA. Al massimo produce il" -ForegroundColor Yellow
Write-Host "        permesso di fare un walk-forward vero, e per la cella A soltanto." -ForegroundColor Yellow

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
  #  schermo E' il referto di questo caso. Non vale per nessun altro punto di
  #  uscita: tutti gli altri passano dal throw e quindi dalla raccolta.
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
#     pinnerebbe gli script e NON il motore.
#     Il numero di riga NON e' citato apposta: una citazione che non si
#     puo' mantenere e' meglio scritta come pattern da cercare che come
#     indirizzo fisso (checklist 43).
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
#     Le occorrenze di [Experts] nel driver sono DUE: l'anteprima del giro
#     a vuoto e l'ini della corsa vera. Devono essere toccate ENTRAMBE, o
#     il giro a vuoto controllerebbe un ini diverso da quello che gira.
$nMax = @(Select-String -LiteralPath $Driver -SimpleMatch -Pattern 'MaxBars=2000000000').Count
if($nMax -ne 2){ throw ("MaxBars scritto " + $nMax + " volte nel driver invece di 2 (anteprima + corsa vera): il driver e' cambiato, mi fermo.") }
Dico ("driver PINNATO (" + $Pin.Substring(0,[math]::Min(7,$Pin.Length)) + ") e con MaxBars alzato") "Green"

# --- 1c. I 4 FILE PROVA
foreach($l in $Lavori){ Scarica ("$RawPin/backtest_pipeline/prove/" + $l.Prova) (Join-Path $Prove $l.Prova) '@SIMBOLO' }
Dico "4 file prova scaricati al pin" "Green"

# --- 1d. IL DIFF DEI 4 FILE PROVA (checklist 33). Sono generati dallo
#     stesso modello, e il confronto NON si fa contro "un file base": si fa
#     A COPPIE, perche' e' la coppia che risponde alla domanda del round.
#       - stesso SIMBOLO, celle A e B  -> devono differire in ESATTAMENTE 2
#         righe, e devono chiamarsi InpAncoraSessione e InpMagic. Se
#         differissero su altro, il round misurerebbe due cose insieme e
#         il CANCELLO DELLA DISTINZIONE non vorrebbe piu' dire niente.
#       - stessa CELLA, simboli diversi -> ESATTAMENTE 2: @SIMBOLO e InpMagic.
#     Contare solo "2" non basterebbe: due righe SBAGLIATE darebbero lo
#     stesso conteggio (checklist 40-bis, la costante del gate va misurata
#     sull'artefatto e il gate deve guardare la cosa giusta).
foreach($l in $Lavori){
  $rv = RigheVive (Join-Path $Prove $l.Prova)
  if($rv.Count -ne $RigheAttese){ throw ($l.Prova + " ha " + $rv.Count + " righe vive invece di " + $RigheAttese + ": artefatto cambiato, mi fermo.") }
  $Vive[$l.Et] = $rv
}
Pretendi "r96adow" "r96bdow" @("InpAncoraSessione","InpMagic") "Su U30USD la sola differenza ammessa e' l'ANCORA: e' la domanda del round."
Pretendi "r96anas" "r96bnas" @("InpAncoraSessione","InpMagic") "Su NASUSD la sola differenza ammessa e' l'ANCORA: e' la domanda del round."
Pretendi "r96adow" "r96anas" @("@SIMBOLO","InpMagic")          "Fra i due simboli deve cambiare SOLO il simbolo."
Pretendi "r96bdow" "r96bnas" @("@SIMBOLO","InpMagic")          "Fra i due simboli deve cambiare SOLO il simbolo."
Dico ("diff a coppie dei 4 file prova: 2 righe su " + $RigheAttese + ", e sono quelle giuste") "Green"

# --- 1d-bis. I MAGIC, letti NELL'ARTEFATTO CHE GIRA (checklist 34-bis).
#     Devono essere: tutti diversi fra loro, tutti diversi da quelli del
#     PASSO 0, e MAI uguali a un magic di una sedia VIVA.
$magicVisti = @()
foreach($l in $Lavori){
  $tx = Get-Content -LiteralPath (Join-Path $Prove $l.Prova) -Raw
  $mg = [regex]::Match($tx,'(?m)^InpMagic=(\d+)\|\|')
  if(-not $mg.Success){ throw ($l.Prova + ": non trovo la riga InpMagic nella forma sweep 'v||v||1||v+1||Y'") }
  $m0 = [int]$mg.Groups[1].Value
  if($magicVisti -contains $m0){ throw ($l.Prova + ": magic " + $m0 + " gia' usato da un altro file prova. Due celle con lo stesso magic si sovrascrivono il per-trade.") }
  if($m0 -eq $MagicA -or $m0 -eq $MagicB){ throw ($l.Prova + ": usa il magic del PASSO 0 (" + $m0 + "). Le due fasi non condividono il magic (checklist 41).") }
  if($MagicVietati -contains $m0){ throw ($l.Prova + ": il magic " + $m0 + " e' di una SEDIA VIVA. Fermo tutto.") }
  $magicVisti += $m0
  #  e l'ancora, letta nel file che gira: la cella A deve dire 1, la B 0.
  $an = [regex]::Match($tx,'(?m)^InpAncoraSessione=([01])\r?$')
  if(-not $an.Success){ throw ($l.Prova + ": non trovo InpAncoraSessione") }
  $attesa = if($l.Et -like "r96a*"){ "1" } else { "0" }
  if($an.Groups[1].Value -ne $attesa){ throw ($l.Prova + ": InpAncoraSessione=" + $an.Groups[1].Value + " ma questa cella deve avere " + $attesa + ". Le celle sono scambiate.") }
}
Dico ("magic della griglia verificati: " + ($magicVisti -join ", ") + "   (PASSO 0: " + $MagicA + "/" + $MagicB + ")") "Green"

# --- 1e. @DAQUANDO, @SIMBOLO, @PERIODO E L'ORA SERVER, scritti in DUE
#     posti (file prova e questa riga): si CONFRONTANO, non ci si fida del
#     commento "se cambi qui cambia anche li'" (checklist 33).
foreach($l in $Lavori){
  $tx = Get-Content -LiteralPath (Join-Path $Prove $l.Prova) -Raw
  $m = [regex]::Match($tx,'(?m)^@DAQUANDO\s+([0-9]{4}\.[0-9]{2}\.[0-9]{2})')
  if(-not $m.Success){ throw ($l.Prova + ": manca @DAQUANDO") }
  if($m.Groups[1].Value -ne $DaQuando){ throw ($l.Prova + ": @DAQUANDO e' " + $m.Groups[1].Value + " ma la riga di lancio dice " + $DaQuando) }
  $s = [regex]::Match($tx,'(?m)^@SIMBOLO\s+(\S+)')
  if(-not $s.Success -or $s.Groups[1].Value -ne $l.Sym){ throw ($l.Prova + ": @SIMBOLO non e' " + $l.Sym) }
  $p = [regex]::Match($tx,'(?m)^@PERIODO\s+(\S+)')
  if(-not $p.Success -or $p.Groups[1].Value -ne $Periodo){ throw ($l.Prova + ": @PERIODO non e' " + $Periodo) }
  # --- L'ORA E' IN ORA SERVER. Regola di casa: server BCM = ora italiana - 1,
  #     quindi l'apertura USA (15:30 IT) e' 14:30 SERVER. Un 15 qui dentro
  #     vorrebbe dire ora italiana, cioe' un'altra strategia, e i CSV
  #     andrebbero cestinati. Meglio non produrli affatto.
  $oh = [regex]::Match($tx,'(?m)^InpOpenHour=(\d+)\r?$')
  $om = [regex]::Match($tx,'(?m)^InpOpenMin=(\d+)\r?$')
  if(-not $oh.Success -or -not $om.Success){ throw ($l.Prova + ": non trovo InpOpenHour/InpOpenMin") }
  if($oh.Groups[1].Value -ne "14" -or $om.Groups[1].Value -ne "30"){
    throw ($l.Prova + ": apertura " + $oh.Groups[1].Value + ":" + $om.Groups[1].Value +
           " invece di 14:30 SERVER. 15:30 sarebbe l'ora ITALIANA: server BCM = ora italiana - 1.")
  }
}
Dico ("@DAQUANDO / @SIMBOLO / @PERIODO e l'apertura 14:30 SERVER verificati in tutti e 4 i file") "Green"

# --- 1f. IL SORGENTE. Il marcatore e' '[XEMAAP][CONTEGGIO]', che esiste
#     SOLO nella versione col canarino a schermo: senza quella riga il
#     gate G4 non avrebbe niente da leggere e uscirebbe "NON LETTO".
Scarica ("$RawPin/mql5/Experts/" + $Ea + ".mq5") (Join-Path $SrcDir ($Ea + ".mq5")) '[XEMAAP][CONTEGGIO]'
Dico ($Ea + ".mq5 scaricato al pin (marcatore: canarino [XEMAAP][CONTEGGIO])") "Green"

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
#  OGNI PASSO STAMPA IL BERSAGLIO CHE HA SCELTO (checklist 37): se un passo
#  successivo ne scegliesse un altro, la divergenza si legge in console
#  invece di essere dedotta da un conteggio sbagliato.
Dico ("terminale : " + $Terminal)
Dico ("dati      : " + $DataFolder + "   (DEVE restare lo stesso in tutti i passi)")

# --- 2a. L'INCLUDE CHE NESSUN DRIVER INSTALLA (checklist 33-bis).
#     L'EA fa #include <ABTG_PausaGuardian.mqh> e chiama
#     ABTG_AutotestGuardia(), che esiste solo dalla v1.20.
#     walkforward_generico.ps1 scarica SOLO il .mq5.
$mqh = Join-Path $MqlInclude "ABTG_PausaGuardian.mqh"
Scarica ("$RawPin/mql5/Include/ABTG_PausaGuardian.mqh") $mqh 'ABTG_AutotestGuardia'
$vfy = Get-Item -LiteralPath $mqh
if($vfy.PSIsContainer){ throw "ABTG_PausaGuardian.mqh: in Include c'e' una CARTELLA con quel nome (checklist 27-ter)." }
if($vfy.Length -lt 4000){ throw ("ABTG_PausaGuardian.mqh e' lungo " + $vfy.Length + " byte: troppo poco, scarico monco.") }
Dico ("include installato: ABTG_PausaGuardian.mqh (" + $vfy.Length + " byte, marcatore v1.20 presente)") "Green"

# --- 2b. PULIZIA DEGLI ARTEFATTI VECCHI, PRIMA (checklist 14).
#     >>> SOLO se si corre davvero: un giro a vuoto che cancella gli
#         artefatti di una corsa vera fatta ieri e' un danno, non un controllo.
if($SoloControllo){
  $quanti = 0
  foreach($sy in $Simboli){ $quanti += @(Get-ChildItem -LiteralPath $Comune -Filter ("abtg_trades_" + $Ea + "_" + $sy + "_*.csv") -ErrorAction SilentlyContinue).Count }
  Dico ("SoloControllo: NON cancello niente (per-trade di questo EA presenti adesso: " + $quanti + ")") "Yellow"
} else {
  $nTolti = 0
  foreach($sy in $Simboli){
    foreach($v in @(Get-ChildItem -LiteralPath $Comune -Filter ("abtg_trades_" + $Ea + "_" + $sy + "_*.csv") -ErrorAction SilentlyContinue)){
      Remove-Item -LiteralPath $v.FullName -Force -ErrorAction SilentlyContinue; $nTolti++
    }
    Remove-Item -LiteralPath (Join-Path $DataFolder ("MQL5\Files\OptResults_" + $Ea + "_" + $sy + ".csv")) -Force -ErrorAction SilentlyContinue
  }
  Dico ("per-trade vecchi di questo EA rimossi: " + $nTolti + "   (nessun file di altri EA e' stato toccato)") "Green"
  # --- la CACHE del tester, e SOLO quella. MAI bases\<server>\ticks: li'
  #     dentro c'e' lo storico a tick reali, e ributtarlo giu' e' una nottata.
  #  >>> CON -LiteralPath IL * NON E' UN WILDCARD (checklist 46): sarebbe il
  #      nome LETTERALE di un file che su Windows non puo' esistere, e
  #      -EA SilentlyContinue si mangerebbe l'errore lasciando la cache piena.
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
#     esce PRIMA della compilazione (checklist 39), quindi un errore di
#     sintassi in un EA appena scritto si vedrebbe solo a corsa avviata.
#     E questo EA E' appena scritto: non e' mai stato compilato da nessuno.
# =====================================================================
Titolo "3. FASE COMPILA"
$mq5 = Join-Path $MqlExperts ($Ea + ".mq5")
$ex5 = Join-Path $MqlExperts ($Ea + ".ex5")
$log = Join-Path $MqlExperts ($Ea + ".log")
$t0  = Get-Date
Copy-Item -LiteralPath (Join-Path $SrcDir ($Ea + ".mq5")) -Destination $mq5 -Force
Remove-Item -LiteralPath $ex5,$log -Force -ErrorAction SilentlyContinue
& $MetaEditor "/compile:$mq5" "/log" | Out-Null
# --- ASPETTA L'ARTEFATTO, non il processo (checklist 39.2).
$scad = (Get-Date).AddMinutes(5)
while((Get-Date) -lt $scad){
  if((Test-Path -LiteralPath $ex5) -and (Test-Path -LiteralPath $log)){
    if((Get-Item -LiteralPath $ex5).LastWriteTime -ge $t0){ break }
  }
  Start-Sleep -Seconds 2
}
$errori = -1
$testoLog = ""
if(Test-Path -LiteralPath $log){
  try{ $testoLog = (Get-Content -LiteralPath $log -Raw -Encoding Unicode) }catch{ $testoLog = "" }
  if($testoLog -notmatch 'error'){ try{ $testoLog = (Get-Content -LiteralPath $log -Raw) }catch{} }
  $mm = [regex]::Match($testoLog,'(?i)(\d+)\s+error')
  if($mm.Success){ $errori = [int]$mm.Groups[1].Value }
}
$fresco = $false
if(Test-Path -LiteralPath $ex5){ $fresco = ((Get-Item -LiteralPath $ex5).LastWriteTime -ge $t0) }
if(-not $fresco -or $errori -gt 0){
  if($testoLog -ne ""){
    Write-Host "--- log del compilatore ---" -ForegroundColor DarkYellow
    Write-Host $testoLog -ForegroundColor DarkYellow
  }
  throw ("COMPILAZIONE FALLITA per " + $Ea + " (errori=" + $errori + ", ex5 fresco=" + $fresco + "). Il round si ferma qui.")
}
$mw = [regex]::Match($testoLog,'(?i)(\d+)\s+warning')
if($mw.Success -and [int]$mw.Groups[1].Value -gt 0){
  [void]$Note.Add("compilazione: " + $mw.Groups[1].Value + " warning (0 errori). Non fermano il round, ma vanno letti nel log.")
}
Dico ("COMPILATO " + $Ea + " (0 errori, .ex5 scritto adesso)") "Green"

# =====================================================================
#  4-A. PASSO 0-A -- LE BARRE. I TICK NON SI RISCARICANO.
#     Sono gia' MISURATI e agli atti: U30USD 67.618.571 tick dal
#     2024.09.26 (REFERTO_ROUND88_ORB_MIGLIORAMENTO.md par.7, 20/08) e
#     NASUSD 164.636.788 dal 2024.09.26 (REFERTO_R83_R84_PREPARAZIONE.md
#     riga 620). Riscaricarli aprirebbe la finestra del difetto 30 (il
#     guardiano di progresso che ammazza MT5 in mezzo alla fase dei tick,
#     dove il CSV per costruzione non cresce di un byte per ore).
#     Qui si scaricano solo le BARRE M1+M5 (-SenzaTick, ~120 s per TF), e
#     -Da e' la NOSTRA finestra: il verdetto del downloader si calcola
#     CONTRO quel parametro (checklist 47), quindi passargli una data
#     catchall stamperebbe "IL BROKER NON HA PIU' STORICO" per costruzione.
# =====================================================================
if(-not $SoloControllo -and -not $SaltaPasso0){
  Titolo "4-A. PASSO 0-A - LE BARRE M1+M5 DEI DUE SIMBOLI"
  $ScStorico = Join-Path $Work "scarica_storico.ps1"
  $t0A = Get-Date       # serve a distinguere un referto NUOVO da uno di ieri
  try{
    Scarica ("$RawPin/backtest_pipeline/scarica_storico.ps1") $ScStorico 'REFERTO STORICO'
    #  >>> ANCHE QUESTO GEMELLO VA PINNATO (difetto 24, seconda occorrenza). <<<
    #  scarica_storico.ps1 ha $EABranch="lavoro" scritto FISSO e da li' scarica
    #  ABTG_HistoryDownloader.mq5 dalla PUNTA del branch: cioe' la FORMULA che
    #  calcola il verdetto arriverebbe NON pinnata.
    $stTxt = Get-Content -LiteralPath $ScStorico -Raw
    $stNew = $stTxt -replace '\$EABranch\s*=\s*"lavoro"', ('$EABranch="' + $Pin + '"')
    if($stNew -eq $stTxt){ throw "non sono riuscito a pinnare EABranch in scarica_storico.ps1: riga non trovata" }
    Set-Content -LiteralPath $ScStorico -Value $stNew -Encoding ASCII
    if(-not (Select-String -LiteralPath $ScStorico -SimpleMatch -Pattern ('$EABranch="' + $Pin + '"') -Quiet)){ throw "pin di EABranch NON verificato in scarica_storico.ps1" }
    #  E il controllo del punto 51: l'ini che quello script passa a
    #  terminal64 /config deve avere [Experts] AllowLiveTrading=false, o
    #  aprire MT5 per MISURARE riarma il profilo del conto vivo.
    if(-not (Select-String -LiteralPath $ScStorico -SimpleMatch -Pattern 'AllowLiveTrading=false' -Quiet)){
      throw "scarica_storico.ps1 NON scrive [Experts] AllowLiveTrading=false nell'ini: aprirebbe il terminale riarmando la flotta sul conto vivo (checklist 51). Mi fermo."
    }
    Dico ("scarica_storico.ps1 PINNATO e con AllowLiveTrading=false verificato") "Green"
    $global:LASTEXITCODE = 0
    & powershell.exe -ExecutionPolicy Bypass -File $ScStorico -Simboli ($Simboli -join ",") -Da $DaQuando -Timeframes "M1,M5" -SenzaTick -Auto -TimeoutMin 45 2>&1 |
      Tee-Object -FilePath (Join-Path $Logs "passo0a_storico.txt") | Out-Host
    $Storico.Eseguito = $true
    $Storico.Esito = "eseguito, uscita " + $LASTEXITCODE
    if($LASTEXITCODE -ne 0){
      $che = if($LASTEXITCODE -eq 2){ "TIMEOUT dei 45 minuti: MT5 fermato a meta', il referto storico e' PARZIALE (ma c'e', e lo leggo lo stesso)" } else { "errore" }
      [void]$Problemi.Add("PASSO 0-A: scarica_storico.ps1 e' uscito con codice " + $LASTEXITCODE + " -> " + $che + ". Il gate 0-C resta la misura che decide.")
    }
    #  >>> E ANCHE QUI SI GUARDA LA DATA. <<<
    #  Se lo script muore PRIMA di cancellare il CSV, il referto di IERI
    #  resta li' e verrebbe letto come il verdetto di ADESSO.
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
      $vistiSym = @()
      foreach($r in (Import-Csv -LiteralPath $csvSt)){
        $sy = ("" + $r.Simbolo).Trim().ToUpper()
        if($Simboli -notcontains $sy){ continue }
        $vistiSym += $sy
        $verd = ("" + $r.Verdetto).Trim()
        [void]$Note.Add("PASSO 0-A: " + $sy + " " + $r.Timeframe + " | barre " + $r.Barre +
                        " | disco " + $r.PrimaDataLocale + " | broker " + $r.PrimaDataServer +
                        " -> " + $(if($verd -ne ""){ $verd } else { "VERDETTO VUOTO" }))
        #  >>> LA GUARDIA SI SCRIVE AL POSITIVO (checklist 40-ter e 47). <<<
        #  I verdetti possibili sono CINQUE: NESSUN DATO, server non risponde,
        #  MANCA STORICO LOCALE, IL BROKER NON HA PIU' STORICO, COMPLETO.
        #  L'unico che passa e' COMPLETO: un verdetto NUOVO, o vuoto, non puo'
        #  passare per buono. E fra i non-COMPLETO uno e' BENIGNO.
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
      foreach($sy in $Simboli){ if($vistiSym -notcontains $sy){ [void]$Problemi.Add("PASSO 0-A: nessuna riga per " + $sy + " nel referto storico.") } }
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
#  4. PASSO 0-C -- IL GATE. Due passate SINGOLE gemelle sulla cella A
#     di U30USD, derivate DAL FILE PROVA che gira davvero.
# =====================================================================
if($SaltaPasso0){
  [void]$Problemi.Add("PASSO 0 SALTATO SU RICHIESTA: la copertura dei dati e il canarino dell'ancora NON sono verificati in questa corsa.")
  Write-Host "    !! PASSO 0 SALTATO. Il referto lo scrive in rosso." -ForegroundColor Red
} else {
  #  IL BERSAGLIO DEL GATE E' IL PRIMO LAVORO DELLA LISTA, e non un nome
  #  riscritto a mano: un selettore ricopiato degrada di una riga per volta
  #  (checklist 37), e il simbolo dell'ini deve essere lo STESSO del file
  #  prova da cui l'ini e' derivato, o il gate misura un'altra cella.
  $SymGate   = $Lavori[0].Sym
  $ProvaGate = $Lavori[0].Prova
  Titolo ("4. PASSO 0-C - IL GATE (2 passate singole gemelle, " + $ProvaGate + " su " + $SymGate + ")")

  # --- l'ini si DERIVA dal file prova: un solo artefatto (checklist 33)
  function IniPasso0($magic,$dest){
    $righe = @(Get-Content -LiteralPath (Join-Path $Prove $ProvaGate) |
               Where-Object { $_ -notmatch '^\s*#' -and $_ -notmatch '^\s*$' -and $_ -notmatch '^@' })
    $out = New-Object System.Collections.ArrayList
    foreach($r in $righe){
      $nome = ($r -split '=')[0].Trim()
      switch($nome){
        "InpVerbose"  { [void]$out.Add("InpVerbose=1") }    # serve il log
        "InpAutoTest" { [void]$out.Add("InpAutoTest=1") }   # G5: si legge UNA volta, QUI
        "InpMagic"    { [void]$out.Add("InpMagic=" + $magic) }
        default       { [void]$out.Add($r) }
      }
    }
    $inputs = ($out -join "`r`n")
    # --- gate sullo STATO FINALE (checklist 33): niente sweep residui.
    #  >>> OGNI $ DI UNA REGEX MULTILINEA SI SCRIVE \r?$ (checklist 40). <<<
    #  $inputs e' unito con "`r`n": in .NET il $ multilinea matcha la posizione
    #  PRIMA di \n, e con un \r davanti quella posizione non e' raggiungibile.
    #  Senza \r? questi -notmatch sarebbero SEMPRE veri e il throw scatterebbe
    #  sempre, accusando un file prova sano.
    if($inputs -match '\|\|'){ throw "PASSO 0: nell'ini e' rimasto uno sweep '||'. Sarebbe un'ottimizzazione, non una passata singola." }
    if($inputs -notmatch '(?m)^InpAncoraSessione=1\r?$'){ throw "PASSO 0: InpAncoraSessione non e' 1. Il gate deve girare sul MOTORE, non sul controllo." }
    if($inputs -notmatch '(?m)^InpOpenHour=14\r?$'){ throw "PASSO 0: InpOpenHour non e' 14 (ora SERVER)." }
    if($inputs -notmatch '(?m)^InpAutoTest=1\r?$'){ throw "PASSO 0: InpAutoTest non e' stato acceso: il gate G5 non avrebbe niente da leggere." }
    if($inputs -notmatch ('(?m)^InpMagic=' + $magic + '\r?$')){ throw ("PASSO 0: InpMagic non e' stato pinnato a " + $magic) }
    foreach($mg in $magicVisti){
      if($inputs -match ('(?m)^InpMagic=' + $mg + '\r?$')){ throw "PASSO 0: sta girando con un magic della GRIGLIA. Le due fasi non condividono il magic." }
    }
    #  E il CONTEGGIO: la derivazione deve produrre ESATTAMENTE i 26 parametri
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
Symbol=$SymGate
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
Report=OptReport_R96_passo0_$magic

[TesterInputs]
$inputs
"@
    Set-Content -LiteralPath $dest -Value $testo -Encoding ASCII
  }

  $iniA = Join-Path $Work "passo0_a.ini"; IniPasso0 $MagicA $iniA
  $iniB = Join-Path $Work "passo0_b.ini"; IniPasso0 $MagicB $iniB
  Write-Host ("    anteprima [TesterInputs] della passata A (" + ($RigheAttese - 3) + " parametri attesi):") -ForegroundColor DarkGray
  Get-Content -LiteralPath $iniA | Select-Object -Last ($RigheAttese - 2) | ForEach-Object { Write-Host ("      " + $_) -ForegroundColor DarkGray }

  if($SoloControllo){
    Dico "SoloControllo: l'ini del PASSO 0 e' scritto e verificato, MT5 NON viene aperto." "Yellow"
  } else {
    #  $tPasso0 marca l'inizio: G4 e G5 leggeranno SOLO i log scritti dopo di
    #  qui, altrimenti un log di ieri risponderebbe per la corsa di oggi.
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
    #     cui serve. E la raccolta legge da qui, non da Common\Files.
    foreach($m in @($MagicA,$MagicB)){
      $src = Join-Path $Comune ("abtg_trades_" + $Ea + "_" + $SymGate + "_" + $m + ".csv")
      if(Test-Path -LiteralPath $src){
        Copy-Item -LiteralPath $src -Destination (Join-Path $Sosta ("passo0_pertrade_" + $m + ".csv")) -Force
      }
    }
    $ptA = Join-Path $Sosta ("passo0_pertrade_" + $MagicA + ".csv")
    $ptB = Join-Path $Sosta ("passo0_pertrade_" + $MagicB + ".csv")
    Dico ("per-trade del PASSO 0 messi in sosta in " + $Sosta) "Green"

    $righeA = @()
    # --- G1: il per-trade esiste, e' di ADESSO ed e' popolato
    if(-not (Test-Path -LiteralPath $ptA)){
      $Fatale = "PASSO 0 / G1: nessun per-trade prodotto. O lo storico manca su U30USD, o l'EA non ha aperto NIENTE in 21 mesi -- e in quel secondo caso il motore non e' brutto, e' MUTO (guarda la riga [XEMAAP][CONTEGGIO] nei log)."
    }
    elseif((Get-Item -LiteralPath $ptA).LastWriteTime -lt $tPasso0){
      $Fatale = "PASSO 0 / G1: il per-trade e' PIU' VECCHIO dell'avvio delle passate gemelle (" +
                (Get-Item -LiteralPath $ptA).LastWriteTime.ToString("yyyy-MM-dd HH:mm:ss",$INV) +
                "): l'EA non l'ha riscritto, e questo NON e' il gate di questa corsa."
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
      #  >>> IL RITORNO DI TryParse SI GUARDA (checklist 40-ter). <<<
      #  Con [void] davanti, una data illeggibile lascerebbe $d1 a MinValue,
      #  MinValue -gt <limite> e' $false e IL GATE PASSEREBBE: "non ho potuto
      #  misurare" e "ho misurato e va bene" finirebbero nello stesso ramo.
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
    # --- G4 e G5: si leggono nei LOG, e le radici sono TRE (checklist 34-ter).
    #  Le Print del tester finiscono nei log degli AGENT, che NON stanno sotto
    #  la cartella dati del terminale: la terza radice e' %APPDATA%\MetaQuotes\Tester.
    #  Con la sola Tester\logs i due gate resterebbero SEMPRE "NON LETTO".
    $radici = @(
      (Join-Path $DataFolder "Tester"),
      (Join-Path $InstDir    "Tester"),
      (Join-Path $env:APPDATA "MetaQuotes\Tester")
    )
    $rigaConta = ""; $rigaAuto = ""; $letti = 0
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
        $mc = [regex]::Match($tx,'\[XEMAAP\]\[CONTEGGIO\][^\r\n]*')
        if($mc.Success){ $rigaConta = $mc.Value }
        $ma = [regex]::Match($tx,'\[XEMAAP\]\[AUTOTEST\] esito motore:[^\r\n]*')
        if($ma.Success){ $rigaAuto = $ma.Value }
      }
    }
    $Passo0.LogLetti = $letti
    if($letti -eq 0){
      #  UN GATE CHE NON LEGGE NIENTE NON E' UN GATE VERDE (checklist 40-ter).
      $Passo0.Conteggio = "NON LETTO"; $Passo0.Autotest = "NON LETTO"
      if($Fatale -eq ""){
        $Fatale = "PASSO 0 / G4-G5: ZERO log del tester letti nelle tre radici dopo l'avvio delle passate. " +
                  "Il canarino dell'ancora e l'autotest NON SONO STATI ESEGUITI: non e' un via libera."
      }
    } else {
      # --- G4: l'ancora ha trovato le sessioni?
      if($rigaConta -eq ""){
        $Passo0.Conteggio = "NON TROVATO nei log"
        if($Fatale -eq ""){ $Fatale = "PASSO 0 / G4: " + $letti + " log letti ma NESSUNA riga [XEMAAP][CONTEGGIO]. Il canarino non e' arrivato: o l'EA compilato non e' quello del pin, o OnTester non e' stato chiamato." }
      } else {
        $Passo0.Conteggio = $rigaConta
        [void]$Note.Add("PASSO 0, canarino: " + $rigaConta)
        $ms = [regex]::Match($rigaConta,'sessioni=(\d+)\s+incroci=(\d+)\s+ingressi=(\d+)\s+ancora=(\d+)')
        if($ms.Success){
          $Passo0.Sessioni = [int]$ms.Groups[1].Value
          $Passo0.Incroci  = [int]$ms.Groups[2].Value
          $Passo0.Ingressi = [int]$ms.Groups[3].Value
          if([int]$ms.Groups[4].Value -ne 1 -and $Fatale -eq ""){
            $Fatale = "PASSO 0 / G4: il canarino dice ancora=0, ma il gate deve girare sul MOTORE (ancora=1). L'ini non ha fatto quello che credevo."
          }
          if($Passo0.Sessioni -eq 0 -and $Fatale -eq ""){
            $Fatale = "PASSO 0 / G4: SESSIONI VISTE = 0. L'ancora delle 14:30 SERVER non ha trovato nessuna barra su U30USD. " +
                      "La cella NON E' GIRATA -- non e' brutta, e' ASSENTE. Si va a vedere l'orario (server BCM = ora italiana - 1) prima di leggere qualunque numero."
          }
        } else {
          [void]$Problemi.Add("PASSO 0 / G4: riga del canarino trovata ma non interpretabile: '" + $rigaConta + "'. I tre contatori NON sono stati letti.")
        }
      }
      # --- G5: l'autotest del motore. Si legge QUI, in un'esecuzione vera nel
      #     tester: e' l'unico posto dove quelle Print nascono (checklist 20).
      if($rigaAuto -eq ""){
        $Passo0.Autotest = "NON TROVATO nei log"
        [void]$Problemi.Add("PASSO 0 / G5: nessuna riga [XEMAAP][AUTOTEST] esito motore nei log. L'autotest NON e' stato letto: non e' un via libera, ma non fermo il round su questo se G1-G4 sono verdi.")
      } elseif($rigaAuto -match 'DIVERGE'){
        $Passo0.Autotest = $rigaAuto
        if($Fatale -eq ""){ $Fatale = "PASSO 0 / G5: l'AUTOTEST DEL MOTORE DIVERGE. Il codice non ragiona come la firma: non si misura niente finche' non e' sistemato. Riga: " + $rigaAuto }
      } else {
        $Passo0.Autotest = $rigaAuto
        [void]$Note.Add("PASSO 0, autotest: " + $rigaAuto)
      }
    }
    Dico ("log del tester letti: " + $letti + " (tre radici, solo file scritti dopo l'avvio)") "Gray"
    $Passo0.Fatto = $true

    Write-Host ""
    Write-Host "    --- ESITO DEL PASSO 0 ---" -ForegroundColor White
    Write-Host ("    operazioni ......... " + $Passo0.N) -ForegroundColor White
    Write-Host ("    prima operazione ... " + $Passo0.PrimaData + "   (limite: " + $LimiteG2 + ")") -ForegroundColor White
    Write-Host ("    ultima operazione .. " + $Passo0.UltimaData) -ForegroundColor White
    Write-Host ("    sessioni viste ..... " + $Passo0.Sessioni + "   (0 = LA CELLA NON E' GIRATA)") -ForegroundColor White
    Write-Host ("    incroci in finestra  " + $Passo0.Incroci) -ForegroundColor White
    Write-Host ("    ingressi aperti .... " + $Passo0.Ingressi) -ForegroundColor White
    if($Passo0.Sessioni -gt 0){
      $perSess = [math]::Round($Passo0.Incroci / $Passo0.Sessioni,2)
      Write-Host ("    incroci per sessione " + $perSess.ToString("0.00",$INV)) -ForegroundColor White
      Write-Host  "    previsione nei criteri (par. 3.2): 1-3 incroci per sessione" -ForegroundColor Yellow
      [void]$Note.Add("frequenza MISURATA: " + $perSess.ToString("0.00",$INV) + " incroci/sessione su " + $Passo0.Sessioni + " sessioni, contro 1-3 previsti nei criteri")
      #  IL CANARINO DELL'EMENDAMENTO, detto qui e non a fine round: se la
      #  passata intera (IS+OOS) non arriva a 300 operazioni, le due meta' non
      #  potranno mai fare 150 ciascuna, e il MERITO e' SOSPESO in partenza.
      if($Passo0.N -lt 300){
        [void]$Problemi.Add("EMENDAMENTO DELLA FINESTRA: la passata intera ha " + $Passo0.N + " operazioni (< 300). " +
                            "Le due meta' non possono fare 150 ciascuna: il MERITO e' SOSPESO in partenza (valvola R59), e il round si legge per il RISCHIO. " +
                            "NON e' un motivo per fermare la corsa -- e' un motivo per non promettere un verdetto di merito.")
      }
    }
    Write-Host ("    gemelli ............ " + $Passo0.Gemelli) -ForegroundColor White
    Write-Host ("    autotest ........... " + $Passo0.Autotest) -ForegroundColor White
    Write-Host ("    durata 1 passata ... " + $Passo0.Minuti.ToString("0.0",$INV) + " min su TUTTA la finestra") -ForegroundColor Yellow
    Write-Host ("    tetto teorico x16 .. " + ([math]::Round($Passo0.Minuti*16/60,1)).ToString("0.0",$INV) + " ore -- NON E' UNA PREVISIONE, E TIRA DA DUE PARTI:") -ForegroundColor Yellow
    Write-Host "                         IN MENO: le 16 passate coprono meta' finestra l'una" -ForegroundColor Yellow
    Write-Host "                         (IS o OOS) e MT5 le distribuisce sugli agent in parallelo." -ForegroundColor Yellow
    Write-Host "                         IN PIU': la cella misurata qui e' quella con l'ancora" -ForegroundColor Yellow
    Write-Host "                         ACCESA, che ricalcola le medie a ogni barra: le celle di" -ForegroundColor Yellow
    Write-Host "                         controllo leggono un buffer e vanno piu' veloci." -ForegroundColor Yellow
    Write-Host "                         L'unico numero vero e' quello che si misura a fine corsa." -ForegroundColor Yellow
    Write-Host ("    -OreMax e' " + $OreMax.ToString("0.0",$INV) + " h: e' un TETTO sull'INIZIO di nuovi file,") -ForegroundColor Yellow
    Write-Host "                         non una stima e non un'interruzione." -ForegroundColor Yellow

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
  Write-Host ("  [" + $idx + "/" + $Lavori.Count + "]  " + $l.Prova + "   (" + $l.Sym + ", cella " + $l.Cella + ")") -ForegroundColor Cyan
  Write-Host "------------------------------------------------------------------" -ForegroundColor Cyan
  $tl = Get-Date
  #  -Terminal e -DataFolder passati ESPLICITI (checklist 37): il driver
  #  altrimenti ri-cerca il terminale per conto suo, e potrebbe trovarne uno
  #  diverso da quello su cui abbiamo compilato e girato il PASSO 0.
  $arg = @("-ExecutionPolicy","Bypass","-File",$Driver,
           "-Expert",$Ea,"-Prova",(Join-Path $Prove $l.Prova),
           "-Simbolo",$l.Sym,"-Periodo",$Periodo,
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
    #      FINESTRA, non per cella, quindi esiste il caso "una gamba di ieri e
    #      una di oggi", e quel caso VA DICHIARATO, non ignorato.
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
  #     nome (anteprima_<EA>_<Simbolo>.ini, SENZA etichetta): le due chiamate
  #     sullo stesso simbolo si sovrascriverebbero e ne resterebbe UNA
  #     (checklist 31). Qui viene messa in sosta col nome della cella, e alla
  #     fine si CONTA che siano 4.
  if($SoloControllo){
    $ant = Join-Path $Work ("anteprima_" + $Ea + "_" + $l.Sym + ".ini")
    if(Test-Path -LiteralPath $ant){
      Copy-Item -LiteralPath $ant -Destination (Join-Path $Sosta ("anteprima_" + $l.Et + ".ini")) -Force
      Remove-Item -LiteralPath $ant -Force -ErrorAction SilentlyContinue
    } else { [void]$Problemi.Add("giro a vuoto: nessuna anteprima .ini per " + $l.Prova) }
  }
  Write-Host ("    esito: " + $l.Esito + "   [" + $l.Min.ToString("0.0",$INV) + " min]") -ForegroundColor Gray
}

if($SoloControllo){
  $nAnt = @(Get-ChildItem -LiteralPath $Sosta -Filter "anteprima_r96*.ini" -ErrorAction SilentlyContinue).Count
  if($nAnt -ne 4){ [void]$Problemi.Add("giro a vuoto: " + $nAnt + " anteprime .ini invece di 4.") }
  Write-Host ""
  Write-Host ("    anteprime .ini in sosta: " + $nAnt + " su 4   -> " + $Sosta) -ForegroundColor White
  Write-Host "    >>> COSA SI LEGGE NELL'ANTEPRIMA, e cosa no:" -ForegroundColor Yellow
  Write-Host "        SI LEGGE: FromDate/ToDate (le finestre IS vere, calcolate dal" -ForegroundColor Yellow
  Write-Host "          driver: sono quelle che vanno copiate nel referto), il blocco" -ForegroundColor Yellow
  Write-Host "          [TesterInputs] e il numero delle celle." -ForegroundColor Yellow
  Write-Host "        NON SI LEGGE: 'Model=4' e' una COSTANTE scritta a mano nel ramo" -ForegroundColor Yellow
  Write-Host "          di prova del driver (cercare 'Model=4' in walkforward_generico)." -ForegroundColor Yellow
  Write-Host "          Stavolta COINCIDE con la corsa vera (-Modello 4), quindi non" -ForegroundColor Yellow
  Write-Host "          mente -- ma resta una costante, non una conferma." -ForegroundColor Yellow
  Write-Host ("        La riga 'Spread=" + $SpreadIni + "' invece l'anteprima la scrive davvero") -ForegroundColor Yellow
  Write-Host "          (il driver ci mette la variabile, non una costante): quella si legge." -ForegroundColor Yellow
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
#  Il modo va nel NOME della cartella, DENTRO il referto e nella riga di ESITO:
#  si guardano in tre momenti diversi, e la riga 'data:' NON basta a
#  distinguerli, perche' il referto di un giro a vuoto e' fresco davvero.
$Modo = if($SoloControllo){ "CONTROLLO" } elseif($SaltaPasso0){ "SENZAPASSO0" } else { "CORSA" }
$Cart = Join-Path $Dsk ("R96_APERTURA_USA_" + $Modo + "_" + $Stamp)
$Zip  = Join-Path $Dsk ("R96_APERTURA_USA_" + $Modo + "_" + $Stamp + ".zip")
$Referto = Join-Path $Cart "REFERTO_R96.txt"
try{
  New-Item -ItemType Directory -Force -Path $Cart | Out-Null
  if($Risultati){
    foreach($l in $Lavori){
      foreach($tag in @("IS","OOS")){
        $src = CsvDi $l $tag
        if(Test-Path -LiteralPath $src){ Copy-Item -LiteralPath $src -Destination (Join-Path $Cart (Split-Path -Leaf $src)) -Force }
      }
    }
  }
  #  DALLA SOSTA, non da Common\Files: li' dentro i file col magic della
  #  griglia sono stati riscritti a ogni passata.
  if($Sosta -and (Test-Path -LiteralPath $Sosta)){
    foreach($f in @(Get-ChildItem -LiteralPath $Sosta -File -ErrorAction SilentlyContinue)){
      Copy-Item -LiteralPath $f.FullName -Destination (Join-Path $Cart $f.Name) -Force
    }
  }
  #  e i per-trade della GRIGLIA: servono a misurare la sovrapposizione fra
  #  la cella A e la cella B (cancello della distinzione, criteri par. 4.2).
  if(-not $SoloControllo -and (Test-Path -LiteralPath $Comune)){
    foreach($sy in $Simboli){
      foreach($f in @(Get-ChildItem -LiteralPath $Comune -Filter ("abtg_trades_" + $Ea + "_" + $sy + "_*.csv") -ErrorAction SilentlyContinue)){
        Copy-Item -LiteralPath $f.FullName -Destination (Join-Path $Cart $f.Name) -Force
      }
    }
  }

  $R = New-Object System.Collections.ArrayList
  [void]$R.Add("REFERTO R96 - L'APERTURA USA COSTRUISCE IL SEGNALE  (U30USD e NASUSD, M5, TICK REALI)")
  [void]$R.Add("modo: " + $Modo + $(if($SoloControllo){ "   <<< GIRO A VUOTO: NESSUNA passata, NESSUN CSV, NESSUN numero di round qui dentro" } else { "" }))
  $sw = @()
  if($SoloControllo){ $sw += "-SoloControllo (nessuna passata)" }
  if($SaltaPasso0)  { $sw += "-SaltaPasso0 (copertura dati e canarino dell'ancora NON verificati)" }
  if($Rifai)        { $sw += "-Rifai (i CSV precedenti sono stati rifatti)" }
  if($sw.Count -eq 0){ $sw += "nessuno (corsa piena, PASSO 0 eseguito, ripresa dei CSV gia' presenti ATTIVA)" }
  [void]$R.Add("switch di questo giro: " + ($sw -join " | "))
  [void]$R.Add("     Senza -Rifai il driver SALTA le finestre gia' presenti. I file saltati sono")
  [void]$R.Add("     marcati 'SALTATO DAL DRIVER' o 'A META'' e finiscono nei PROBLEMI, non in OK.")
  [void]$R.Add("spread: Spread=" + $SpreadIni + " scritto NELL'INI = spread CORRENTE del feed BCM, dichiarato.")
  [void]$R.Add("     NON e' uno stress di spread. E lo spread NON e' misurato: la prima mezz'ora")
  [void]$R.Add("     americana e' il momento peggiore della giornata, e questo round non lo tocca.")
  [void]$R.Add("data: " + (Get-Date).ToString("yyyy-MM-dd HH:mm:ss",$INV) + "   (questa data deve essere di ADESSO)")
  [void]$R.Add("     ATTENZIONE: la data fresca NON distingue un giro a vuoto da una corsa.")
  [void]$R.Add("     Quello che lo distingue e' la riga 'modo:' qui sopra e il NOME della cartella.")
  [void]$R.Add("avvio: " + $Avvio.ToString("yyyy-MM-dd HH:mm:ss",$INV) + "   durata: " + ((New-TimeSpan -Start $Avvio -End (Get-Date)).TotalHours).ToString("0.0",$INV) + " ore")
  [void]$R.Add("pin: " + $Pin)
  [void]$R.Add("criteri: risultati_archivio\R96_CRITERI.md   (BOZZA se la riga della firma e' vuota)")
  [void]$R.Add("")
  [void]$R.Add("--- PASSO 0 (IL GATE) ---")
  [void]$R.Add("  0-A barre .......... " + $Storico.Esito + "   (chiesto dal " + $DaQuando + ", cioe' la finestra dichiarata)")
  [void]$R.Add("      I TICK non sono stati riscaricati: sono gia' MISURATI e agli atti")
  [void]$R.Add("      (U30USD 67.618.571 e NASUSD 164.636.788, entrambi dal 2024.09.26).")
  [void]$R.Add("  0-C eseguito ....... " + $Passo0.Fatto)
  [void]$R.Add("  operazioni ......... " + $Passo0.N + "   (sotto 300 = le due meta' non fanno 150: MERITO SOSPESO)")
  [void]$R.Add("  prima operazione ... " + $Passo0.PrimaData + "   (limite dei criteri: " + $LimiteG2 + ")")
  [void]$R.Add("  ultima operazione .. " + $Passo0.UltimaData)
  [void]$R.Add("  sessioni viste ..... " + $Passo0.Sessioni)
  [void]$R.Add("      >>> 0 = LA CELLA NON E' GIRATA. Non e' brutta: e' ASSENTE.")
  [void]$R.Add("  incroci in finestra  " + $Passo0.Incroci)
  [void]$R.Add("  ingressi aperti .... " + $Passo0.Ingressi)
  [void]$R.Add("  canarino ........... " + $Passo0.Conteggio)
  [void]$R.Add("  autotest ........... " + $Passo0.Autotest)
  [void]$R.Add("  gemelli ............ " + $Passo0.Gemelli + "   (log del tester letti: " + $Passo0.LogLetti + ")")
  [void]$R.Add("     NOTA: 'NON LETTO' NON e' 'va bene'. Un gate che non legge niente")
  [void]$R.Add("     non e' un gate verde, ed e' un esito FATALE.")
  [void]$R.Add("")
  [void]$R.Add("--- LAVORI ---   (attese: 2 righe per CSV, 8 CSV, 16 passate)")
  [void]$R.Add(("{0,-30} {1,-8} {2,-5} {3,-5} {4,-8} {5}" -f "FILE","SIMBOLO","IS","OOS","MIN","ESITO"))
  foreach($l in $Lavori){
    [void]$R.Add(("{0,-30} {1,-8} {2,-5} {3,-5} {4,-8} {5}" -f $l.Prova,$l.Sym,$l.IS,$l.OOS,$l.Min.ToString("0.0",$INV),$l.Esito))
  }
  [void]$R.Add("")
  [void]$R.Add("--- COME SI LEGGE (e in che ordine) ---")
  [void]$R.Add("  1. il PASSO 0 qui sopra. Se e' rosso, i numeri sotto NON esistono.")
  [void]$R.Add("  2. la colonna 'Sessioni Viste' di OGNI cella, PRIMA di qualunque PF:")
  [void]$R.Add("     0 = quella cella non e' girata. Poi 'Ingressi Aperti' e 'Trades'.")
  [void]$R.Add("  3. IL CANCELLO DELLA DISTINZIONE (criteri par. 4.2), e viene PRIMA del")
  [void]$R.Add("     conto economico: se la cella A e la cella B, sullo stesso simbolo,")
  [void]$R.Add("     hanno n entro il +/-10% E 'Incroci Sessione' entro il +/-10%,")
  [void]$R.Add("     L'ANCORA E' COSMETICA e R96 risponde NO alla propria domanda,")
  [void]$R.Add("     qualunque sia il profitto.")
  [void]$R.Add("  4. LA CELLA B NON E' PROMUOVIBILE. MAI. NEMMENO SE VINCE. E' lo schema")
  [void]$R.Add("     'filtro orario appiccicato' (0 successi su 5) ed e' nel round come")
  [void]$R.Add("     strumento di misura, non come candidato.")
  [void]$R.Add("  5. solo dopo, il conto economico, per SIMBOLO e mai in pooling, con n")
  [void]$R.Add("     accanto a ogni numero e il regime dichiarato (un regime e mezzo).")
  [void]$R.Add("  6. NESSUN numero di R96 si confronta con un numero di R86: motore,")
  [void]$R.Add("     simboli e timeframe sono diversi. Si confrontano le CONCLUSIONI.")
  [void]$R.Add("  7. Su U30USD c'e' GIA' una sedia viva sulla stessa apertura (ABTG_ORB,")
  [void]$R.Add("     magic 770601). Anche se la cella A vincesse, prima di qualunque")
  [void]$R.Add("     sedia va misurata la SOVRAPPOSIZIONE: due motori che perdono negli")
  [void]$R.Add("     stessi giorni non sono diversificazione.")
  [void]$R.Add("  8. R96 NON PRODUCE SEDIE. Al massimo il permesso di un walk-forward.")
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
    #  ANCHE QUI L'ESITO GUARDA $Problemi. In -SoloControllo i problemi ci sono
    #  per DISEGNO (le anteprime mancanti sono il gate proprio del giro a
    #  vuoto): un COMPLETATO due righe sopra il numero che lo smentisce vale
    #  una notte di macchina, perche' e' il giro a vuoto che autorizza le ore vere.
    if($Problemi.Count -gt 0){
      [void]$R.Add("ESITO: GIRO A VUOTO CON PROBLEMI -- " + $Problemi.Count + " problemi nell'elenco qui sopra.")
      [void]$R.Add("       NESSUNA passata, NESSUN CSV. Anteprime .ini prodotte: " + $nAnt + " su 4.")
      [void]$R.Add("       IL CONTROLLO NON E' PASSATO: la corsa vera NON si lancia finche'")
      [void]$R.Add("       l'elenco dei PROBLEMI non e' vuoto.")
    }
    else{
      [void]$R.Add("ESITO: GIRO A VUOTO COMPLETATO -- NESSUNA passata, NESSUN CSV, NESSUN")
      [void]$R.Add("       numero di round in questo file. Anteprime .ini prodotte: " + $nAnt + " su 4.")
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
#  Quando un gate ferma il round la cartella puo' restare VUOTA e
#  Compress-Archive fallisce: stampare comunque il percorso dello zip
#  manderebbe Claudio a cercare un file che non c'e'.
function Riga3($path,$coda){
  if(Test-Path -LiteralPath $path){ Write-Host ("   " + $path + "   " + $coda) -ForegroundColor White }
  else                            { Write-Host ("   " + $path + "   <<< NON ESISTE") -ForegroundColor Red }
}
Riga3 $Cart    ""
Riga3 $Zip     "<- e' questo che mi mandi"
Riga3 $Referto "<- la riga 'data:' deve essere di ADESSO, e la riga 'modo:' dice se e' il round o un giro a vuoto"
Write-Host "=====================================================================" -ForegroundColor White
if($SoloControllo){
  Write-Host ("  MODO: " + $Modo + " -- GIRO A VUOTO. NESSUNA passata, NESSUN CSV, NESSUN") -ForegroundColor Yellow
  Write-Host "        numero di round. Anteprime .ini attese: 4." -ForegroundColor Yellow
  Write-Host "        QUESTO ZIP NON E' IL ROUND e non va mandato come risultato." -ForegroundColor Yellow
} else {
  Write-Host ("  MODO: " + $Modo) -ForegroundColor White
  Write-Host "  ATTESI:  8 CSV (4 file x IS/OOS), 2 righe l'uno, 16 passate," -ForegroundColor White
  Write-Host "           piu' 2 per-trade del PASSO 0 e i per-trade delle 4 celle." -ForegroundColor White
}
foreach($l in $Lavori){
  $c = "Green"; if($l.Esito -ne "OK" -and $l.Esito -ne "SOLO CONTROLLO"){ $c = "Yellow" }
  Write-Host ("   " + $l.Prova.PadRight(30) + " " + $l.Esito) -ForegroundColor $c
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
