# =====================================================================
#  MARCATORE_RIGA_R107_v1
#  RIGA_R107_LATI_SHORT.ps1  --  R107: IL RICONTROLLO DEI LATI SHORT
#  sulle tre geometrie di APERTURA:
#     DOW  ABTG_Dow_Apertura_US     su U30USD M5  (sedia VIVA, solo long)
#     DAX  ABTG_DAX_Apertura_EU     su D30EUR M5  (sedia VIVA, solo long)
#     NAS  ABTG_Nasdaq_Apertura_US  su NASUSD M5  (NESSUNA sedia viva)
# ---------------------------------------------------------------------
#  CRITERI:   backtest_pipeline\risultati_archivio\R107_CRITERI.md
#  PERIMETRO: risultati_archivio\R107_CODA_LATI_SHORT.md
#    (Claudio, 25/08/2026: "Mettilo in coda. Ricontrollo short DAX e
#     Nasdaq e Dow", davanti al candelone rosso dell'apertura Dow delle
#     14:30 che la sedia solo-LONG ha correttamente ignorato.)
#
#  >>> I CRITERI DI DETTAGLIO SONO [DA FIRMARE] (tre decisioni, par. 10).
#      Questo driver LEGGE il file dei criteri al pin e, se ci trova
#      ancora la stringa del lucchetto, la CORSA VERA non parte (exit 2).
#      Il GIRO A VUOTO parte lo stesso: non apre MT5, non produce nessun
#      numero, e serve proprio a far leggere i criteri prima di firmarli.
#      -CriteriFirmati e' la firma IN RIGA di Claudio, e finisce scritta
#      nel referto.
#
#  DA DOVE NASCE, dichiarato: e' RIGA_R101_ABLAZIONE.ps1
#  (MARCATORE_RIGA_R101_v1) adattata da DUE famiglie a TRE e da venti
#  celle a SEI. Il punto 9 della checklist dice che una riscrittura non
#  puo' perdere le funzioni di sicurezza del gemello: sono state
#  riportate TUTTE, una per una -- guardia MT5/MetaEditor chiusi, -Pin
#  senza default, gate della firma dei criteri, pin di $EABranch DENTRO
#  il driver generico, [Charts] MaxBars con gate sullo stato finale,
#  install di ABTG_PausaGuardian.mqh, gate delle righe vive, gate della
#  STELLA, gate dei VALORI, gate dei MAGIC, compilazione DIRETTA col
#  verdetto LastWriteTime + backup datato + ripristino del .mq5 se
#  fallisce, SOSTA SVUOTATA A OGNI GIRO, funzioni e variabili della
#  raccolta SOPRA il try, MODO nel nome della cartella e nel referto,
#  pulizia PER NOME e MAI a wildcard, cultura INVARIANTE, \r? davanti a
#  ogni $ multilinea, raccolta SEMPRE, exit ESPLICITO su ogni ramo.
#
#  ------------------------------------------------------------------
#  COSA CAMBIA RISPETTO A R101, e perche' (checklist 63-69)
#
#  (63) NESSUN HASHTABLE LETTERALE MULTILINEA. Il difetto di R101 (una
#       virgola a fine riga dentro @{ } che rendeva il file
#       SINTATTICAMENTE ROTTO e lessicalmente perfetto) qui non puo'
#       ripetersi: $VIVA si riempie con assegnazioni separate
#       ($VIVA["DOW"] = @(...)), e le tabelle dei valori di cella
#       nascono da una FUNZIONE (V2), non da un letterale.
#       E il parse e' stato FATTO, non dichiarato impossibile:
#       /opt/pwsh/pwsh + [Parser]::ParseFile -> 0 errori.
#
#  (64) OGNI PARAMETRO NUMERICO E' TIPIZZATO e ogni confronto con un
#       sentinella e' CASTATO SUL POSTO. E' il difetto che il 23/08
#       fermo' la famiglia DAX di R101 al gate G0 CON IL METRO
#       RIPRODOTTO: il "-1" posizionale arrivava come STRINGA, e
#       "stringa -gt 0" e' un confronto culture-aware che dice VERO su
#       Windows e FALSO su Linux. Qui il NAS ha PfAtti/DdAtti/NAtti a
#       -1 (= nessun numero agli atti) e quel sentinella viene letto
#       DUE volte: percio' il tipo non e' un dettaglio.
#
#  (65) GLI ELENCHI. -SoloEa accetta 'DOW,DAX' e 'DOW DAX' e li splitta
#       su '[,\s]+', non su ','. In argument mode la virgola fa un
#       ARRAY, il binder [string] lo unisce con uno SPAZIO, e chi
#       splitta su ',' trova un token solo. La riga da mandare lo passa
#       comunque FRA APICI.
#
#  (66) LA SENTINELLA SU TUTTE LE COLONNE. Un numero NON MISURATO si
#       scrive "n/d". Su TUTTE: profitto, PF, DD, n E peggior giornata.
#       In R103 la convenzione era applicata a meta' delle colonne e il
#       PF non misurato usciva "0.000", cioe' un numero PLAUSIBILE che
#       si legge "ha perso tutto". Qui c'e' FmtN apposta per gli interi.
#
#  (67) OGNI REGOLA DELLA PROSA HA IL SUO if. Le tre che nei criteri
#       sono scritte a lettere chiare, e qui sono IMPOSTE dal codice:
#         a. "sul NAS non esiste nessun G0"  -> il gate G0 non viene
#            nemmeno valutato per quella famiglia, e il referto scrive
#            NON APPLICABILE (che NON e' "superato");
#         b. "l'unico asse spazzolato e' InpMagic" -> contato NEL FILE
#            PROVA, non solo nell'anteprima del giro a vuoto;
#         c. "niente coda 2026.07-08" -> la finestra e' fissa nel codice
#            e @DAQUANDO viene CONFRONTATO in ogni file.
#
#  (68) IL TERZO STATO. L'esito non e' binario. Sono QUATTRO:
#         0 = OK  |  0 = COMPLETO CON RILIEVI (tutte le celle hanno
#         prodotto i numeri, e i rilievi sono RISULTATI del round)
#         1 = PARZIALE o FERMATO  |  1 = SELETTORE A VUOTO (nessuna
#         cella ha corrisposto a -SoloEa/-SoloCella: e' il refuso piu'
#         comune che esista, e un verdetto calcolato su "quel che resta"
#         lo spaccerebbe per successo)  |  2 = criteri non firmati.
#
#  (69) NIENTE CANCELLAZIONE PREVENTIVA MUTA. La pulizia degli
#       OptResults_*.csv e della Tester\cache CONTA PRIMA E DOPO e, se
#       un file sopravvive, lo dice RUMOROSAMENTE nei PROBLEMI. Una
#       Remove-Item con -ErrorAction SilentlyContinue che fallisce in
#       silenzio degrada il controllo di freschezza in un "esiste".
#  ------------------------------------------------------------------
#
#  COSA FA, in ordine, e DA SOLA:
#    0.     si rifiuta di partire se MT5 O MetaEditor sono aperti
#    0-bis. si rifiuta di CORRERE se i criteri non sono firmati
#    1.     scarica AL PIN: walkforward_generico.ps1, i 6 file prova, i
#           TRE sorgenti .mq5 e l'include ABTG_PausaGuardian.mqh
#           - GATE DI VERSIONE sui .mq5 (marcatori presi DAL SORGENTE)
#           - GATE DELLE RIGHE VIVE (DOW 74 / DAX 75 / NAS 89)
#           - GATE DELLA STELLA: la cella short differisce dalla sua
#             cella long ESATTAMENTE su InpAllowLong + InpAllowShort
#             (+ InpMagic), e su nessun altro input
#           - GATE DEI VALORI: la geometria viva riga per riga
#           - GATE DELL'ASSE UNICO: un solo flag Y, ed e' InpMagic
#           - GATE DEI MAGIC: unici, vergini, mai un magic vivo
#    2.     FASE COMPILA, un EA alla volta, invocazione DIRETTA di
#           metaeditor64.exe, verdetto sul LastWriteTime del .ex5
#    3.     PASSO 0 PER FAMIGLIA = la cella LONG. Da li' escono:
#             (a) G0 IGIENE GEMELLI: le due righe identiche al centesimo
#             (b) G0 RIPRODUZIONE DEL METRO: PF/DD/n OOS contro i numeri
#                 agli atti -- SOLO su DOW e DAX. Sul NAS NON ESISTE.
#             (c) IL CANARINO: n IS e n OOS. NON BLOCCA (regola B)
#           Se (a) o (b) falliscono la FAMIGLIA si ferma, e le ALTRE
#           vanno avanti.
#    4.     la cella SHORT della famiglia. Sul DOW c'e' in piu' il
#           G0-BIS: deve riprodurre il numero R54 (PF 0,840 / DD 8,62%
#           / n 73). NON ferma la famiglia, ma finisce nei PROBLEMI.
#    5.     raccolta SEMPRE: cartella sul Desktop + zip + REFERTO con la
#           TABELLA MADRE e i numeri attesi DICHIARATI PRIMA.
#
#  QUELLO CHE NON FA, dichiarato:
#    - NON GIUDICA. Produce i CSV, li conta, e mette a referto i delta
#      contro la cella long. I cancelli G1-G5 li applica il REFERTO del
#      round, non questa riga. In particolare NON applica G3 (coerenza
#      cross-mercato): e' un ragionamento su TRE tabelle.
#    - NON promuove niente e NON tocca il forward. Magic VERGINI 761xxx
#      (blocco verificato libero in tutto il repo il 25/08). Sono
#      vietati e controllati i magic vivi 770101, 770202 e ANCHE 770201
#      (Nasdaq Apertura, spenta: un'identita' spenta resta occupata).
#    - NON scarica i TICK e non svuota bases\<server>\ticks. Sono gia'
#      MISURATI e agli atti per U30USD, D30EUR e NASUSD dal 2024.09.26
#      (REFERTO_SONDA_STORICO_17-08.md; su NASUSD ci ha girato R98).
#    - non misura lo spread, non misura i sotto-periodi, non fa la prova
#      di regime, e non inventa nessun numero non letto in un artefatto.
#    - non scrive una riga di MQL5.
#    - non ammazza un lavoro in corso allo scadere di -OreMax: smette
#      solo di iniziarne di nuovi (checklist 19).
#
#  QUANTO CI METTE: [STIMA], non una previsione. 6 file x 2 finestre x 2
#  celle gemelle = 24 passate a tick reali. R101 ne fece 80 sugli stessi
#  due simboli in poche ore. -OreMax e' 10 (tetto sull'INIZIO di nuovi
#  file), con margine largo apposta per il simbolo nuovo.
#
#  LA RIGA CHE SI INCOLLA (blocco INTERO, un comando solo - checklist 21).
#  <PIN> = il commit che contiene QUESTO file: e' l'hash dato in chat.
#
#  & { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
#      if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
#      $pin='<PIN>'; $p="$env:USERPROFILE\RIGA_R107.ps1"; Remove-Item $p -EA SilentlyContinue;
#      irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_R107_LATI_SHORT.ps1" -OutFile $p;
#      if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_R107_v1' -Quiet)){ throw 'SCRIPT VECCHIO' };
#      $global:LASTEXITCODE=0; & $p -Pin $pin -SoloControllo; if($LASTEXITCODE -ne 0){ Write-Host 'ESITO: PARZIALE O FERMO - leggi il REFERTO' } }
#
#  GIRO A VUOTO: e' quello qui sopra (-SoloControllo). Scrive e verifica
#  GLI STESSI .ini che girano nella corsa vera. Non c'e' un secondo
#  artefatto (checklist 33).
#  >>> E NON MISURA NESSUN NUMERO: senza tester non esiste nessun n,
#      nessun PF, nessun DD, nessun canarino, nessun G0. Sta scritto
#      anche nel suo referto, perche' non lo si scambi per il round.
# =====================================================================
param(
  # -Pin NON ha default: un default silenzioso ("lavoro") farebbe girare la
  #  punta del branch spacciandola per un commit congelato. Meglio morire.
  [string]$Pin        = "",
  [double]$OreMax     = 10.0,      # oltre questo NON si iniziano nuovi file
  [switch]$Rifai,                  # rifa' anche i CSV gia' presenti
  [switch]$SoloControllo,          # giro a vuoto: NON apre MT5
  [switch]$CriteriFirmati,         # >>> lo preme CLAUDIO, non l'agente. Senza,
                                   #     la corsa vera non parte (exit 2).
  [string]$SoloEa     = "",        # "DOW" | "DAX" | "NAS", anche in elenco:
                                   #  'DOW,DAX' oppure 'DOW DAX'. FRA APICI.
  [string]$SoloCella  = ""         # es. "R107_DAX_01_short.txt": una cella sola
                                   #     (la cella LONG della sua famiglia gira
                                   #      lo stesso: e' il denominatore)
)
$ErrorActionPreference = "Stop"
[Threading.Thread]::CurrentThread.CurrentCulture   = [Globalization.CultureInfo]::InvariantCulture
[Threading.Thread]::CurrentThread.CurrentUICulture = [Globalization.CultureInfo]::InvariantCulture
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$INV = [Globalization.CultureInfo]::InvariantCulture

$Avvio  = Get-Date
$Stamp  = $Avvio.ToString("yyyyMMdd_HHmm", $INV)
$Dsk    = Join-Path $env:USERPROFILE "Desktop"
$Work   = Join-Path $env:USERPROFILE "abtg_r107"
$Prove  = Join-Path $Work "prove"
$Logs   = Join-Path $Work "log_r107"
$SrcDir = Join-Path $Work "src_motori"
$RawPin = "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$Pin"

#--- LA FINESTRA. Identica a R88/R97/R98/R101: e' l'unico modo di
#    confrontare i round alla pari. Criteri R107 par. 4.
#    >>> IL FILE DI CODA PROPONEVA "+ coda 2026.07-08 se il driver la
#        regge". E' RESPINTA NEI CRITERI, e qui la regola ha il suo if:
#        questi due valori sono FISSI e @DAQUANDO viene confrontato in
#        ogni file prova. Allungare $Fino sposterebbe anche il punto di
#        split al 40%, quindi cambierebbe SIA l'IS SIA l'OOS, e i numeri
#        non sarebbero piu' confrontabili con R54 ne' con R101.
$DaQuando = "2024.09.26"      # muro del feed BCM sugli indici, MISURATO
$Fino     = "2026.06.30"
$Periodo  = "M5"
$Modello  = 4                 # 4 = TICK REALI
$Deposito = 100000            # taglia prop, come R46/R54/R101
$SpreadIni= 0                 # 0 = spread CORRENTE, ma SCRITTO nell'ini invece
                              #  che lasciato allo stato nascosto del terminale.
                              #  NON e' uno stress e NON e' una misura.
$FrazioneIS  = 0.40           # default di walkforward_generico.ps1
$CelleAttese = 2              # le due passate GEMELLE di controllo, per CSV

#--- I MAGIC VIETATI: i due VIVI del round, il magic della sedia Nasdaq
#    SPENTA (un'identita' spenta resta occupata), le sedie confinanti
#    sugli stessi simboli e i blocchi gia' usati dai round recenti.
$MagicVietati = @(770202,770101,   # <<< LE DUE SEDIE VIVE DI QUESTO ROUND
                  770201,          # Nasdaq Apertura: SPENTA, e resta spenta
                  770611,770601,   # ORB Dow VIVO / ORB corso
                  770411,770901,   # MaxMin DAX / STReversal Nikkei
                  770511,970913,   # SuperWave Dow / SupRev Nasdaq
                  772601,772602,772611,772612,   # R54
                  772800,772890,772891,          # R98
                  773200,773201,773300,773301,   # R101
                  750010,750011)                 # R104

# =====================================================================
#  LE TRE FAMIGLIE. Ogni riga e' un EA, con la sua cella LONG, i suoi
#  numeri AGLI ATTI (il metro di G0) e le sue righe vive attese.
#
#  >>> DA DOVE VIENE OGNI COLONNA (criteri R107 par. 2):
#      - Ea / Ver / MagicSrc : LETTI NEL SORGENTE al pin (25/08)
#      - PfAtti / DdAtti / NAtti : MISURATI e agli atti, referto citato.
#        SUL NAS SONO -1 = NON ESISTONO, e HaMetro e' $false: quella
#        famiglia NON HA UN G0, e il referto lo scrive NON APPLICABILE.
#        "Non applicabile" NON e' "superato".
#      - RigheVive : MISURATE sui file prova il 25/08 con
#        `grep -cvE '^\s*(#|$)'`, NON scritte a memoria (checklist 40-bis)
#      - Ora* : ORA SERVER. Server BCM = ora italiana - 1, e per gli
#        indici e' MISURATO sugli orologi del corso (4DOC par. 2.2).
#
#  >>> CHECKLIST 64: OGNI parametro e' TIPIZZATO. Senza il tipo,
#      l'argomento posizionale -1 arriva come STRINGA "-1", e
#      "stringa -gt 0" e' un confronto di STRINGHE culture-aware: su
#      Windows PowerShell 5.1 (NLS) il trattino e' ignorabile, quindi
#      "-1" -gt 0 e' VERO sul PC di backtest e FALSO sul pwsh/Linux del
#      verificatore. E' il difetto che il 23/08 ha fermato la famiglia
#      DAX di R101 al gate G0 CON IL METRO RIPRODOTTO.
# =====================================================================
function F([string]$id,[string]$ea,[string]$ver,[string]$sym,[string]$magicSrc,
           [int]$righe,[string]$oraH,[string]$oraM,
           [double]$pf,[double]$dd,[int]$n,[bool]$haMetro,[string]$fonte){
  return [pscustomobject]@{
    Id=$id; Ea=$ea; Ver=$ver; Sym=$sym; MagicSrc=$magicSrc; RigheVive=$righe;
    OraH=$oraH; OraM=$oraM; PfAtti=$pf; DdAtti=$dd; NAtti=$n;
    HaMetro=$haMetro; Fonte=$fonte;
    # --- riempiti durante la corsa
    Compilato=$false; Metro="NON MISURATO"; Gemelli="NON MISURATO";
    NIS=-1; NOOS=-1; PfOOS=-1.0; DdOOS=-1.0; ProfOOS=-999999.0;
    Esito="NON ESEGUITA"
  }
}
$FAMIGLIE = @(
  (F "DOW" "ABTG_Dow_Apertura_US"    "1.01" "U30USD" "770202" 74 "14" "30" 1.27013 4.3941 130 $true  "REFERTO_ROUND54_LATI_DOW.md par.1 (riga solo LONG) + R101_REFERTO.md riga 26 (riprodotto il 23/08)"),
  (F "DAX" "ABTG_DAX_Apertura_EU"    "1.01" "D30EUR" "770101" 75 "8"  "0"  1.397   7.23   270 $true  "R101_REFERTO.md righe 27 e 68: e' R101 che ha messo AGLI ATTI il n del DAX (IS 175 / OOS 270)"),
  (F "NAS" "ABTG_Nasdaq_Apertura_US" "1.02" "NASUSD" "770201" 89 "14" "30" -1.0    -1.0   -1  $false "NESSUNA: sul Nasdaq non esiste nessuna sedia viva con questa geometria (770201 e' SPENTA). Non c'e' niente da riprodurre e NON c'e' G0.")
)

# =====================================================================
#  LE SEI CELLE. Due per famiglia, e cambiano SOLO i due lati.
#  'Diff' = gli input che DEVONO differire dalla cella LONG della stessa
#  famiglia, e NESSUN ALTRO. Contare "3 righe diverse" non basterebbe:
#  TRE righe SBAGLIATE darebbero lo stesso conteggio e il round
#  misurerebbe un'altra cosa (checklist 33 e 40-bis).
#  'Val' = quanto vale quell'input IN QUESTO FILE: il diff dice CHE
#  cambia, questo dice CHE COSA vale. Se i due file di una famiglia
#  fossero SCAMBIATI, il diff resterebbe verde e questo no (34-bis).
#  >>> V2 e' una FUNZIONE apposta per non scrivere hashtable letterali
#      multilinea: e' la classe di difetto 63, che non e' un errore di
#      runtime ma di PARSE, e nessuna guardia interna puo' intercettarla.
# =====================================================================
function V2([string]$lungo,[string]$corto){
  $h = @{}
  $h["InpAllowLong"]  = $lungo
  $h["InpAllowShort"] = $corto
  return $h
}
function C([string]$fam,[string]$id,[string]$file,[string]$desc,[int]$magic,
           $diff,$val,[bool]$long){
  return [pscustomobject]@{ Fam=$fam; Id=$id; Prova=$file; Desc=$desc; Magic=$magic;
                            Diff=@($diff); Val=$val; Long=$long;
                            Esito="NON ESEGUITO"; IS=-1; OOS=-1; Min=0.0;
                            PfOOS=-1.0; DdOOS=-1.0; ProfOOS=-999999.0; NOOS=-1; PgOOS=99.9;
                            PfIS=-1.0;  DdIS=-1.0;  ProfIS=-999999.0;  NIS=-1;
                            Gemelli="NON MISURATO" }
}
$LATI = @("InpAllowLong","InpAllowShort")
$CELLE = @()
$CELLE += (C "DOW" "00_metro"   "R107_DOW_00_metro.txt"   "LA CELLA VIVA DEL DOW -- il METRO (gate G0), non un candidato"                       761000 @()    (V2 "1" "0") $true)
$CELLE += (C "DOW" "01_short"   "R107_DOW_01_short.txt"   "IL LATO SHORT del Dow -- e' una RIPRODUZIONE di R54 (gate G0-bis)"                   761010 $LATI (V2 "0" "1") $false)
$CELLE += (C "DAX" "00_metro"   "R107_DAX_00_metro.txt"   "LA CELLA VIVA DEL DAX -- il METRO (gate G0), non un candidato"                       761100 @()    (V2 "1" "0") $true)
$CELLE += (C "DAX" "01_short"   "R107_DAX_01_short.txt"   "IL LATO SHORT del DAX -- LA MISURA NUOVA DEL ROUND (registro riga A3, mai fatta)"    761110 $LATI (V2 "0" "1") $false)
$CELLE += (C "NAS" "00_riflong" "R107_NAS_00_riflong.txt" "IL RIFERIMENTO LONG del Nasdaq -- NON e' un metro: nessun numero agli atti"          761200 @()    (V2 "1" "0") $true)
$CELLE += (C "NAS" "01_short"   "R107_NAS_01_short.txt"   "IL LATO SHORT del Nasdaq -- geometria del Dow TRASPOSTA (criteri par. 2.3 e 7)"      761210 $LATI (V2 "0" "1") $false)

# =====================================================================
#  LA GEOMETRIA VIVA, PRETESA RIGA PER RIGA IN OGNI FILE della famiglia.
#  Non e' ridondanza col gate della stella: la stella garantisce che i
#  file siano UGUALI FRA LORO, questo garantisce che siano uguali ALLA
#  SEDIA VIVA. Due file identici e sbagliati passerebbero la stella.
#
#  >>> InpAllowLong e InpAllowShort NON SONO IN QUESTE LISTE, ed e' la
#      differenza di sostanza con R101: in R101 erano invarianti
#      (1 e 0 in tutti e venti i file), qui sono L'ASSE DEL ROUND. Il
#      loro valore lo pretende il gate 'Val' della singola cella.
#
#  >>> NIENTE HASHTABLE LETTERALE MULTILINEA (checklist 63): tre
#      assegnazioni separate, cosi' non esiste nessuna virgola a fine
#      riga che possa continuare l'espressione.
#
#  Fonti: criteri R107 par. 2.1 / 2.2 / 2.3.
# =====================================================================
$VIVA = @{}
$VIVA["DOW"] = @(@("InpSessionHour","14"),@("InpSessionMin","30"),@("InpRangeMinutes","35"),
                 @("InpEntryMode","2"),@("InpRangeMode","0"),@("InpBufferPoints","1000"),
                 @("InpRetestOffsetPts","400"),@("InpUseEmaFilter","1"),@("InpEmaFast","1"),
                 @("InpEmaSlow","50"),@("InpFilterTF","16388"),
                 @("InpSLMode","0"),@("InpTP1_R","1.0"),@("InpTP1_ClosePct","50"),
                 @("InpBreakevenAtTP1","1"),@("InpUseTrailing","1"),@("InpTrailMode","1"),
                 @("InpTrailTF","5"),@("InpTrailStartR","0"),@("InpBEatR","0"),
                 @("InpMinStopPts","500"),@("InpSkipIfTight","0"),
                 @("InpOneTradePerDay","1"),@("InpCloseHour","17"),@("InpCloseMin","30"),
                 @("InpRiskPercent","1.0"),@("InpSlippagePts","0"))
$VIVA["DAX"] = @(@("InpSessionHour","8"),@("InpSessionMin","0"),@("InpRangeMinutes","35"),
                 @("InpEntryMode","2"),@("InpRangeMode","0"),@("InpBufferPoints","500"),
                 @("InpRetestOffsetPts","200"),@("InpUseEmaFilter","0"),
                 @("InpSLMode","0"),@("InpTP1_R","1.0"),@("InpTP1_ClosePct","50"),
                 @("InpBreakevenAtTP1","1"),@("InpUseTrailing","1"),@("InpTrailMode","1"),
                 @("InpTrailTF","5"),@("InpTrailStartR","0"),@("InpBEatR","0"),
                 @("InpMinStopPts","0"),@("InpSkipIfTight","1"),@("InpAllowReverse","0"),
                 @("InpOneTradePerDay","1"),@("InpCloseHour","17"),@("InpCloseMin","30"),
                 @("InpRiskPercent","1.0"),@("InpSlippagePts","0"))
#  Il NAS e' la geometria del DOW TRASPOSTA: stessi valori, piu' i due
#  interruttori del blocco R30 che esiste SOLO in quel .mq5 e che qui
#  DEVONO essere spenti -- altrimenti non staremmo misurando il motore
#  del Dow, ma un motore con due leve mai validate accese.
$VIVA["NAS"] = @(@("InpSessionHour","14"),@("InpSessionMin","30"),@("InpRangeMinutes","35"),
                 @("InpEntryMode","2"),@("InpRangeMode","0"),@("InpBufferPoints","1000"),
                 @("InpRetestOffsetPts","400"),@("InpUseEmaFilter","1"),@("InpEmaFast","1"),
                 @("InpEmaSlow","50"),@("InpFilterTF","16388"),
                 @("InpSLMode","0"),@("InpTP1_R","1.0"),@("InpTP1_ClosePct","50"),
                 @("InpBreakevenAtTP1","1"),@("InpUseTrailing","1"),@("InpTrailMode","1"),
                 @("InpTrailTF","5"),@("InpTrailStartR","0"),@("InpBEatR","0"),
                 @("InpMinStopPts","500"),@("InpSkipIfTight","0"),
                 @("InpOneTradePerDay","1"),@("InpCloseHour","17"),@("InpCloseMin","30"),
                 @("InpRiskPercent","1.0"),@("InpSlippagePts","0"),
                 @("InpUseVolRegime","0"),@("InpUseSRFilter","0"))

#--- I NUMERI DI G0-BIS: la cella short del DOW e' una RIPRODUZIONE.
#    Fonte: REFERTO_ROUND54_LATI_DOW.md par. 1, riga "solo SHORT".
#    NON e' fatale (criteri par. 5, G0-bis): R54a pinnava meno input e
#    che i due insiemi coincidano e' DIMOSTRATO sul lato long (R101) e
#    INFERITO sul lato short. Un gate fatale su un'inferenza fermerebbe
#    il round per una ragione che qui nessuno puo' diagnosticare.
#    Ma finisce nei PROBLEMI: se il banco e' storto, anche DAX e NASUSD
#    vanno letti con riserva, e Claudio DEVE aprire il referto.
$G0bisCella = "R107_DOW_01_short.txt"
$G0bisPf    = 0.840
$G0bisDd    = 8.62
$G0bisN     = 73
$G0bisFonte = "REFERTO_ROUND54_LATI_DOW.md par.1, riga 'solo SHORT': OOS -2.591,58 | PF 0,840 | DD 8,62% | n 73 (e IS +6.463,44 | PF 1,511 | DD 2,68% | n 73)"

#--- LE TOLLERANZE DI G0 e G0-BIS (criteri par. 5, [DA FIRMARE] con la
#    proposta). Stesse di R101, che con quelle ha riprodotto due metri.
$TolPf = 0.01
$TolDd = 0.10

# =====================================================================
#  TUTTO CIO' CHE LA RACCOLTA USA NASCE QUI, PRIMA DEL try
#  (checklist 41-bis), FUNZIONI COMPRESE (checklist 48: in PowerShell una
#  `function` non e' dichiarativa, e' un'ISTRUZIONE: se il flusso non ci
#  passa sopra, il nome non esiste e la raccolta esplode proprio nella
#  corsa fermata da un gate -- cioe' l'unica in cui il referto serve).
# =====================================================================
$Risultati = Join-Path $Work "risultati_prove"
$Sosta     = Join-Path $Work "sosta"
$Problemi  = New-Object System.Collections.ArrayList
$Rilievi   = New-Object System.Collections.ArrayList
$Fatale    = ""
$nAnt      = -1
$Firma     = "NON LETTA"
$Terminal  = ""; $MetaEditor = ""; $DataFolder = ""
$Ordinati  = @()      # checklist 41-bis: la raccolta lo scorre SEMPRE
$Vive      = @{}
$FamFerme  = @()
$SelettoreAVuoto = $false

function Ora(){ return (Get-Date).ToString("HH:mm:ss", $INV) }
function Dico([string]$t,[string]$c="Gray"){ Write-Host ("[" + (Ora) + "] " + $t) -ForegroundColor $c }
function Titolo([string]$t){ Write-Host ""; Write-Host ("=== " + $t + " ===") -ForegroundColor Cyan }

function Scarica([string]$url,[string]$dest,[string]$marcatore){
  Remove-Item -LiteralPath $dest -Force -ErrorAction SilentlyContinue
  Invoke-WebRequest -Uri $url -OutFile $dest -UseBasicParsing -ErrorAction Stop
  if(-not (Test-Path -LiteralPath $dest)){ throw ("scarico fallito: " + $url) }
  if($marcatore -ne "" -and -not (Select-String -LiteralPath $dest -SimpleMatch -Pattern $marcatore -Quiet)){
    throw ("file scaricato SENZA il marcatore '" + $marcatore + "': " + $url)
  }
}

function RigheVive([string]$p){
  return @(Get-Content -LiteralPath $p | Where-Object { $_ -notmatch '^\s*#' -and $_ -notmatch '^\s*$' })
}
function NomeDi([string]$riga){
  if($riga -match '^@'){ return ($riga -split '\s+')[0] }
  return (($riga -split '=')[0]).Trim()
}
function CsvDi($c,[string]$tag){
  $fam = @($FAMIGLIE | Where-Object { $_.Id -eq $c.Fam })[0]
  #  A Modello 4 il driver generico NON aggiunge il suffisso "_ohlc": lo
  #  aggiunge solo ai modelli diversi da 4 (cercare '$Suffisso =' in
  #  walkforward_generico.ps1).
  return (Join-Path $Risultati ($fam.Ea + "\" + $fam.Ea + "_" + $fam.Sym + "_" + $tag + "_" + $c.Id + ".csv"))
}

# ---------------------------------------------------------------------
#  LA CONVENZIONE DI SENTINELLA, E VALE PER TUTTE LE COLONNE.
#  checklist 66: in R103 era applicata a META' delle colonne, e il PF
#  non misurato usciva "0.000" -- un numero PLAUSIBILE che si legge
#  "ha perso tutto". Qui:
#    - i decimali NON MISURATI valgono -1.0   -> Fmt2/Fmt3 -> "n/d"
#    - gli interi NON MISURATI valgono -1     -> FmtN      -> "n/d"
#    - il PROFITTO non misurato vale -999999  -> FmtE      -> "n/d"
#    - la PEGGIOR GIORNATA non misurata vale 99.9 -> FmtPg -> "n/d"
#
#  >>> LE DUE COLONNE CHE NON POSSONO USARE IL SENTINELLA -1, e non e'
#      un dettaglio: e' il difetto 66 in persona, cioe' la convenzione
#      applicata a META' delle colonne.
#      * PROFITTO: e' negativo ogni volta che la cella perde. Un
#        sentinella a -1 sarebbe indistinguibile da una perdita di 1 euro.
#      * PEGGIOR GIORNATA %: e' negativa SEMPRE. MISURATO negli artefatti
#        veri il 25/08 (csv_R74\..._U30USD_OOS_...csv: 'Peggior Giornata %'
#        = -0.9971). Con Fmt2, che rende "n/d" per ogni valore < 0, TUTTE
#        le peggiori giornate del referto sarebbero uscite "n/d" -- cioe'
#        una colonna intera dichiarata non misurata mentre era misurata.
#        Percio' il sentinella e' 99.9 (un +99,9% di peggior giornata non
#        esiste) e il formattatore e' FmtPg, non Fmt2.
# ---------------------------------------------------------------------
function Fmt2($v){
  if($null -eq $v){ return "n/d" }
  if([double]$v -lt 0){ return "n/d" }
  return ([double]$v).ToString("0.00",$INV)
}
function Fmt3($v){
  if($null -eq $v){ return "n/d" }
  if([double]$v -lt 0){ return "n/d" }
  return ([double]$v).ToString("0.000",$INV)
}
function FmtN($v){
  if($null -eq $v){ return "n/d" }
  if([int]$v -lt 0){ return "n/d" }
  return ([int]$v).ToString($INV)
}
function FmtE($v){
  if($null -eq $v){ return "n/d" }
  if([double]$v -le -999998.0){ return "n/d" }
  #  NIENTE separatore delle migliaia, ed e' voluto: sotto cultura
  #  invariante "+2,812" si scrive con la VIRGOLA, e un lettore italiano
  #  lo legge "due virgola otto". Il segno serve (dice subito se la cella
  #  ha guadagnato o perso), il separatore no.
  return ([double]$v).ToString("+0;-0;0",$INV)
}
#  La peggior giornata e' SEMPRE <= 0 negli artefatti veri: qui il
#  sentinella e' in ALTO (99.9), non in basso.
function FmtPg($v){
  if($null -eq $v){ return "n/d" }
  if([double]$v -ge 99.0){ return "n/d" }
  return ([double]$v).ToString("0.00",$INV)
}
function NumInv($s){
  $v = 0.0
  $t = ("" + $s).Replace([string][char]160,"").Replace([string][char]8239,"").Replace([string][char]8201,"").Replace(" ","").Trim()
  if($t -eq ""){ return $null }
  if([double]::TryParse($t,[Globalization.NumberStyles]::Float,$INV,[ref]$v)){ return $v }
  return $null
}

# =====================================================================
#  IL PARSER DEL CSV DI OTTIMIZZAZIONE -- con il CONTROLLO POSITIVO.
#
#  Il bug di R99 (una parola mancante nell'elenco dei sinonimi di colonna
#  faceva tornare una lista vuota, e il chiamante scriveva "NON MISURATA"
#  su una tabella perfettamente leggibile) qui e' impedito da tre cose:
#   1. le colonne si cercano PER NOME nell'intestazione, mai per posizione;
#   2. i sinonimi sono COMPLETI, italiano e inglese, ed elencati qui;
#   3. se NON riconosce le colonne torna $null E DICE QUALI INTESTAZIONI
#      HA VISTO -- perche' il 23/08, per scoprire la parola mancante, e'
#      servito aprire lo zip a mano.
#  L'intestazione VERA e' MISURATA sugli artefatti di questi EA il 23/08
#  (OPTFRAME esteso, e i tre .mq5 delle aperture ce l'hanno tutti e tre):
#    Pass,Profit,Expected Payoff,Profit Factor,Recovery Factor,
#    Sharpe Ratio,Equity DD %,Trades,Peggior Giornata %,...
#  Percio' questo round NON legge nessun .htm: n, PF, DD, profitto E la
#  peggior giornata escono da UN SOLO artefatto, gia' in colonne.
# =====================================================================
$script:CsvIntestazioni = @()
function LeggiOpt([string]$path){
  if(-not (Test-Path -LiteralPath $path)){ return $null }
  $righe = @()
  try{ $righe = @(Import-Csv -LiteralPath $path) }catch{ return $null }
  if($righe.Count -eq 0){ return $null }
  $cols = @($righe[0].PSObject.Properties.Name)
  $script:CsvIntestazioni = $cols
  function Trova($cands){
    foreach($c in $cands){
      foreach($k in $cols){ if(("" + $k).Trim().ToLower() -eq $c){ return $k } }
    }
    return $null
  }
  $kProf = Trova @("profit","profitto","utile")
  $kPf   = Trova @("profit factor","fattore di profitto")
  $kDd   = Trova @("equity dd %","drawdown equity %","equity drawdown %","drawdown %")
  $kN    = Trova @("trades","operazioni","trade")
  $kPg   = Trova @("peggior giornata %","worst day %")
  $kMg   = Trova @("inpmagic")
  #  CONTROLLO POSITIVO: senza le quattro colonne che contano non si tira
  #  a indovinare. Torna $null, e chi chiama scrive "NON MISURATA".
  if($null -eq $kProf -or $null -eq $kPf -or $null -eq $kDd -or $null -eq $kN){ return $null }
  $out = New-Object System.Collections.ArrayList
  foreach($r in $righe){
    [void]$out.Add([pscustomobject]@{
      Profit = (NumInv $r.$kProf)
      Pf     = (NumInv $r.$kPf)
      Dd     = (NumInv $r.$kDd)
      N      = (NumInv $r.$kN)
      Pg     = $(if($null -ne $kPg){ (NumInv $r.$kPg) } else { $null })
      Magic  = $(if($null -ne $kMg){ ("" + $r.$kMg).Trim() } else { "" })
    })
  }
  return @($out)
}

#  I GEMELLI: le due righe devono essere IDENTICHE AL CENTESIMO su
#  profitto, PF, DD e n. E' l'igiene di casa, ed e' il motivo per cui
#  l'unico asse spazzolato e' InpMagic.
#  >>> E SI PRETENDE CHE SIANO DUE. "Una riga sola" non e' "gemelli ok":
#      e' uno sweep che non ha spazzolato (checklist 55).
function Gemelli($righe){
  if($null -eq $righe){ return "NON MISURATO (CSV non letto)" }
  if(@($righe).Count -ne 2){ return ("NON VALIDO: " + @($righe).Count + " righe invece di 2") }
  $a = $righe[0]; $b = $righe[1]
  foreach($ch in @(@("profitto",$a.Profit,$b.Profit),@("PF",$a.Pf,$b.Pf),
                   @("DD",$a.Dd,$b.Dd),@("n",$a.N,$b.N))){
    if($null -eq $ch[1] -or $null -eq $ch[2]){ return ("NON MISURATO (" + $ch[0] + " illeggibile)") }
    if([math]::Abs([double]$ch[1] - [double]$ch[2]) -gt 0.005){
      return ("DIVERSI su " + $ch[0] + ": " + $ch[1] + " contro " + $ch[2])
    }
  }
  return "IDENTICI"
}

#--- LE DUE FINESTRE, calcolate con la STESSA formula del driver generico.
#    Nel giro a vuoto vengono CONFRONTATE con le FromDate/ToDate scritte
#    davvero nelle anteprime .ini: se il driver generico cambiasse la sua
#    FrazioneIS, il confronto se ne accorge.
$DtInizio = [datetime]::ParseExact($DaQuando,"yyyy.MM.dd",$INV)
$DtFine   = [datetime]::ParseExact($Fino,"yyyy.MM.dd",$INV)
$DtMeta   = $DtInizio.AddDays([math]::Floor(($DtFine-$DtInizio).TotalDays*$FrazioneIS))
$IS_Da    = $DtInizio.ToString("yyyy.MM.dd",$INV)
$IS_A     = $DtMeta.ToString("yyyy.MM.dd",$INV)
$OOS_Da   = $DtMeta.AddDays(1).ToString("yyyy.MM.dd",$INV)
$OOS_A    = $DtFine.ToString("yyyy.MM.dd",$INV)

# =====================================================================
#  LA LISTA DEI LAVORI, dopo i filtri -SoloEa / -SoloCella
#
#  >>> CHECKLIST 65: -SoloEa si splitta su '[,\s]+', mai su ','. In
#      argument mode 'DOW,DAX' senza apici diventa un ARRAY, e il binder
#      [string] lo unisce con uno SPAZIO: chi splitta su ',' trova un
#      token solo e il filtro non corrisponde a niente. Cosi' funzionano
#      tutte e due le forme.
#  >>> CHECKLIST 68: se dopo i filtri non resta NESSUNA cella, non e'
#      "zero problemi": e' IL SELETTORE CHE NON HA CORRISPOSTO A NULLA,
#      cioe' il refuso piu' comune che esista. Ha un esito suo (exit 1).
#      IL CASO VERO CHE PRENDE, ed e' stato riprodotto: una famiglia
#      dichiarata in $FAMIGLIE ma SENZA celle in $CELLE -- cioe' quello
#      che succede aggiungendo un quarto EA e dimenticando le sue due
#      righe. Il nome storto in -SoloEa/-SoloCella lo prendono gia' i
#      due controlli qui sopra, con l'elenco dei nomi validi.
# =====================================================================
$Lavori = @($CELLE)
if($SoloEa -ne ""){
  $se = @(($SoloEa.ToUpper() -split '[,\s]+') | Where-Object { $_ -ne "" })
  #  gli id validi si prendono DALLA TABELLA, non da un elenco scritto a
  #  mano qui: se un giorno si aggiungesse una quarta famiglia, un elenco
  #  duplicato resterebbe indietro in silenzio.
  $idValidi = @($FAMIGLIE | ForEach-Object { $_.Id })
  $ignoti   = @($se | Where-Object { $idValidi -notcontains $_ })
  if($ignoti.Count -gt 0){
    Write-Host ("!!! -SoloEa contiene famiglie che non esistono: " + ($ignoti -join ", ")) -ForegroundColor Red
    Write-Host  "    Valide: DOW, DAX, NAS. Elenchi FRA APICI: -SoloEa 'DOW,DAX'" -ForegroundColor Yellow
    exit 1
  }
  $Lavori = @($Lavori | Where-Object { $se -contains $_.Fam })
}
if($SoloCella -ne ""){
  $sc = @($Lavori | Where-Object { $_.Prova -eq $SoloCella })
  if($sc.Count -eq 0){
    Write-Host ("!!! -SoloCella " + $SoloCella + " non e' nella lista (dopo -SoloEa). Nomi validi:") -ForegroundColor Red
    foreach($c in $CELLE){ Write-Host ("      " + $c.Prova + "   [" + $c.Fam + "]") -ForegroundColor Yellow }
    exit 1
  }
  #  >>> LA CELLA LONG DELLA SUA FAMIGLIA GIRA LO STESSO. E' la ripresa
  #      "vera": senza il denominatore i delta non esistono e lo short
  #      non si legge. Costa 2 CSV, non una passata sprecata.
  $famSc = $sc[0].Fam
  $Lavori = @($Lavori | Where-Object { $_.Prova -eq $SoloCella -or ($_.Fam -eq $famSc -and $_.Long) })
}
$FamAttive = @($Lavori | ForEach-Object { $_.Fam } | Sort-Object -Unique)
$FamLavoro = @($FAMIGLIE | Where-Object { $FamAttive -contains $_.Id })
if($Lavori.Count -eq 0){ $SelettoreAVuoto = $true }

Write-Host ""
Write-Host "#####################################################################" -ForegroundColor Cyan
Write-Host "#  R107 - IL RICONTROLLO DEI LATI SHORT: DOW, DAX, NASDAQ           #" -ForegroundColor Cyan
Write-Host "#  U30USD + D30EUR + NASUSD, M5, TICK REALI, 2024.09.26 -> 2026.06.30 #" -ForegroundColor Cyan
Write-Host "#####################################################################" -ForegroundColor Cyan
Dico ("pin      : " + $Pin)
Dico ("cartella : " + $Work)

if($SelettoreAVuoto){
  Write-Host ""
  Write-Host "#####################################################################" -ForegroundColor Red
  Write-Host "#  IL SELETTORE NON HA CORRISPOSTO A NESSUNA CELLA.                 #" -ForegroundColor Red
  Write-Host "#####################################################################" -ForegroundColor Red
  Write-Host ("  -SoloEa    = '" + $SoloEa + "'") -ForegroundColor Yellow
  Write-Host ("  -SoloCella = '" + $SoloCella + "'") -ForegroundColor Yellow
  Write-Host  "  Non ho niente da fare, e questo NON e' 'tutto a posto': e' il refuso" -ForegroundColor Yellow
  Write-Host  "  piu' comune che esista (un nome storto nel selettore). Le sei celle:" -ForegroundColor Yellow
  foreach($c in $CELLE){ Write-Host ("      " + $c.Fam.PadRight(4) + " " + $c.Prova) -ForegroundColor Yellow }
  Write-Host ""
  Write-Host "ESITO: SELETTORE A VUOTO -- nessuna cella selezionata, nessun artefatto prodotto." -ForegroundColor Red
  exit 1
}

Titolo "NUMERI ATTESI (dichiarati PRIMA della corsa)"
Write-Host ("    famiglie .....................  " + $FamLavoro.Count + "   (" + ($FamAttive -join ", ") + ")") -ForegroundColor White
Write-Host ("    celle ........................  " + $Lavori.Count + "   (di cui LONG: " + @($Lavori | Where-Object { $_.Long }).Count + ")") -ForegroundColor White
Write-Host ("    CSV attesi ...................  " + (2*$Lavori.Count) + "   (IS + OOS per cella)") -ForegroundColor White
Write-Host ("    righe per CSV ................  " + $CelleAttese + "   (le due gemelle di controllo)") -ForegroundColor White
Write-Host ("    passate ......................  " + (4*$Lavori.Count)) -ForegroundColor White
Write-Host ("    IS  " + $IS_Da + " -> " + $IS_A) -ForegroundColor White
Write-Host ("    OOS " + $OOS_Da + " -> " + $OOS_A) -ForegroundColor White
Write-Host ""
Write-Host  "    IL GATE G0 (criteri par. 5): la cella LONG deve RIPRODURRE i numeri" -ForegroundColor Yellow
Write-Host  "    agli atti della sedia viva. Se non li riproduce, la FAMIGLIA si ferma" -ForegroundColor Yellow
Write-Host  "    -- e le altre vanno avanti. Un metro sbagliato non e' un round con un" -ForegroundColor Yellow
Write-Host  "    difetto: e' un round che misura un altro motore." -ForegroundColor Yellow
foreach($fam in $FamLavoro){
  #  >>> CHECKLIST 67: la regola "sul NAS non esiste nessun G0" NON e'
  #      solo scritta nei criteri: e' questo if, e si vede a schermo
  #      PRIMA della corsa. "Non applicabile" non e' "superato".
  if($fam.HaMetro){
    Write-Host ("      " + $fam.Id + " : PF " + $fam.PfAtti.ToString("0.000",$INV) + " | DD " + $fam.DdAtti.ToString("0.00",$INV) + "% | n " + $fam.NAtti) -ForegroundColor Yellow
  } else {
    Write-Host ("      " + $fam.Id + " : G0 NON APPLICABILE -- nessuna sedia viva, nessun numero agli atti.") -ForegroundColor Yellow
    Write-Host  "             La sua cella long e' un RIFERIMENTO (denominatore), non un metro." -ForegroundColor Yellow
  }
}
Write-Host ""
Write-Host  "    IL GATE G0-BIS: la cella short del DOW e' una RIPRODUZIONE di R54" -ForegroundColor Yellow
Write-Host ("      attesa: PF " + $G0bisPf.ToString("0.000",$INV) + " | DD " + $G0bisDd.ToString("0.00",$INV) + "% | n " + $G0bisN + "   (R54, 14/08/2026)") -ForegroundColor Yellow
Write-Host  "      NON ferma la famiglia, ma se non torna il BANCO E' SOSPETTO e anche" -ForegroundColor Yellow
Write-Host  "      DAX e NASUSD vanno letti con riserva: finisce nei PROBLEMI." -ForegroundColor Yellow
Write-Host ""
Write-Host  "    IL CANARINO (criteri par. 5, G4) NON E' UN GATE. Il campione sottile" -ForegroundColor Yellow
Write-Host  "    sospende il giudizio sul MERITO, mai sul RISCHIO (Emendamento reg. B)." -ForegroundColor Yellow
Write-Host ""
Write-Host  "    >>> QUESTO ROUND NON PROMUOVE NIENTE E NON TOCCA IL FORWARD." -ForegroundColor Yellow
Write-Host  "        Produce misure. Il deploy e' una firma separata (G5)." -ForegroundColor Yellow

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
  #  DICHIARATO: questo exit sta DENTRO il try e SALTA la raccolta. Qui e'
  #  accettabile ed e' una scelta: siamo a due secondi dal lancio, non e'
  #  stato prodotto NIENTE, e il messaggio a schermo E' il referto.
  exit 1
}

New-Item -ItemType Directory -Force -Path $Work,$Prove,$Logs,$SrcDir | Out-Null

# =====================================================================
#  0-BIS. LA FIRMA DEI CRITERI. Si LEGGE nell'artefatto, non si ricorda.
#
#  Scarica R107_CRITERI.md al pin e guarda se porta ancora la stringa del
#  lucchetto nel titolo. Se si':
#    - -SoloControllo prosegue (il giro a vuoto non apre MT5, non produce
#      numeri e serve proprio a far leggere i criteri prima di firmarli);
#    - la CORSA VERA si ferma con exit 2, a meno che Claudio non passi
#      -CriteriFirmati, che e' la sua firma esplicita in riga.
#  Non e' burocrazia: il round tocca due sedie che stanno sui soldi, e le
#  decisioni da firmare sono TRE (par. 10 dei criteri).
# =====================================================================
Titolo "0-BIS. LA FIRMA DEI CRITERI"
$critFile = Join-Path $Work "R107_CRITERI.md"
$daFirmare = $true
try{
  Scarica ("$RawPin/backtest_pipeline/risultati_archivio/R107_CRITERI.md") $critFile 'R107'
  $daFirmare = (Select-String -LiteralPath $critFile -SimpleMatch -Pattern '[DA FIRMARE]' -Quiet)
  $Firma = if($daFirmare){ "NON FIRMATI (il file porta ancora [DA FIRMARE])" } else { "FIRMATI (nessun [DA FIRMARE] nel file)" }
}catch{
  $Firma = "NON LETTI (" + $_.Exception.Message + ")"
  $daFirmare = $true
}
Dico ("criteri: " + $Firma) $(if($Firma -like "FIRMATI*"){"Green"}else{"Yellow"})
if($daFirmare -and -not $SoloControllo -and -not $CriteriFirmati){
  Write-Host ""
  Write-Host "#####################################################################" -ForegroundColor Red
  Write-Host "#  NON PARTO: I CRITERI DI R107 NON SONO FIRMATI.                   #" -ForegroundColor Red
  Write-Host "#####################################################################" -ForegroundColor Red
  Write-Host "  R107_CRITERI.md porta ancora [DA FIRMARE]. Sono TRE decisioni (par. 10):" -ForegroundColor Yellow
  Write-Host "   D1  la geometria NASUSD e' una TRASPOSIZIONE letterale del Dow?" -ForegroundColor Yellow
  Write-Host "   D2  il cancello di merito sullo short e' quello di R54 (PF>=1,10 e IS+)?" -ForegroundColor Yellow
  Write-Host "   D3  si fa anche una finestra di DISCESA dedicata (feb-apr 2025)?" -ForegroundColor Yellow
  Write-Host "" -ForegroundColor Yellow
  Write-Host "  COSA PUOI FARE ADESSO, in ordine:" -ForegroundColor Yellow
  Write-Host "   1. il GIRO A VUOTO gira lo stesso: rilancia con -SoloControllo." -ForegroundColor Yellow
  Write-Host "      Non apre MT5, non produce nessun numero, e verifica tutti i file." -ForegroundColor Yellow
  Write-Host "   2. leggi R107_CRITERI.md par. 10 e rispondi alle tre decisioni." -ForegroundColor Yellow
  Write-Host "   3. quando hai firmato: si toglie il [DA FIRMARE] dal file, oppure" -ForegroundColor Yellow
  Write-Host "      si rilancia questa riga aggiungendo  -CriteriFirmati" -ForegroundColor Yellow
  Write-Host ""
  exit 2
}
if($daFirmare -and $CriteriFirmati){
  [void]$Rilievi.Add("I criteri portano ancora [DA FIRMARE] nel file, ma la corsa e' partita con -CriteriFirmati: la firma e' quella data in riga da Claudio. VA SCRITTO NEL REFERTO DEL ROUND.")
  Dico "corsa autorizzata da -CriteriFirmati (il file porta ancora [DA FIRMARE])" "Yellow"
}

# =====================================================================
#  1. SCARICO AL PIN
# =====================================================================
Titolo "1. SCARICO AL PIN"
$Driver = Join-Path $Work "walkforward_generico.ps1"
Scarica ("$RawPin/backtest_pipeline/walkforward_generico.ps1") $Driver 'RigaSpread'

# --- 1a. IL PIN DEL MOTORE. walkforward_generico.ps1 ha $EABranch="lavoro"
#     scritto FISSO e riscarica il .mq5 dalla PUNTA del branch: senza
#     questa riscrittura un pin pinnerebbe gli script e NON il motore. Su
#     un round che confronta sei file fra loro, un push a meta' corsa
#     cambierebbe il motore fra un file e l'altro e il confronto non
#     misurerebbe piu' niente.
$dTxt = Get-Content -LiteralPath $Driver -Raw
$dNew = $dTxt -replace '\$EABranch\s*=\s*"lavoro"', ('$EABranch="' + $Pin + '"')
if($dNew -eq $dTxt){ throw "non sono riuscito a pinnare EABranch nel driver generico: riga non trovata" }

# --- 1b. IL TETTO DELLE BARRE. Se il tester ereditasse il tetto "Max barre
#     nel grafico" del terminale, le serie verrebbero TRONCATE IN SILENZIO
#     (checklist 36) e i CSV uscirebbero pieni di numeri coerenti e falsi.
#     Qui morde: questi EA leggono barre M1 per costruire il range, su 21 mesi.
#     [INFERITO] che il tester onori questa riga: NON e' misurato. Il gate
#     vero resta la RIPRODUZIONE DEL METRO (G0).
$dNew = $dNew -replace '(?m)^\[Experts\]\r?$', "[Charts]`r`nMaxBars=2000000000`r`n`r`n[Experts]"
Set-Content -LiteralPath $Driver -Value $dNew -Encoding ASCII
# --- gate sullo STATO FINALE, non sul replace (checklist 33)
if(-not (Select-String -LiteralPath $Driver -SimpleMatch -Pattern ('$EABranch="' + $Pin + '"') -Quiet)){ throw "pin di EABranch NON verificato nel driver generico" }
$nMax = @(Select-String -LiteralPath $Driver -SimpleMatch -Pattern 'MaxBars=2000000000').Count
if($nMax -ne 2){ throw ("MaxBars scritto " + $nMax + " volte nel driver generico invece di 2 (anteprima + corsa vera): il driver e' cambiato, mi fermo.") }
Dico ("driver generico PINNATO (" + $Pin.Substring(0,[math]::Min(7,$Pin.Length)) + ") e con MaxBars alzato") "Green"

# --- 1c. I FILE PROVA, e le loro righe vive
foreach($c in $Lavori){
  Scarica ("$RawPin/backtest_pipeline/prove/" + $c.Prova) (Join-Path $Prove $c.Prova) '@SIMBOLO'
}
foreach($c in $Lavori){
  $fam = @($FAMIGLIE | Where-Object { $_.Id -eq $c.Fam })[0]
  $rv  = RigheVive (Join-Path $Prove $c.Prova)
  if($rv.Count -ne [int]$fam.RigheVive){
    throw ($c.Prova + " ha " + $rv.Count + " righe vive invece di " + $fam.RigheVive + ": artefatto cambiato, mi fermo.")
  }
  $Vive[$c.Prova] = $rv
}
Dico ($Lavori.Count.ToString() + " file prova scaricati al pin, righe vive verificate (DOW 74 / DAX 75 / NAS 89)") "Green"

# --- 1d. IL GATE DELLA STELLA. La cella short si confronta con la cella
#     LONG della sua famiglia. Non basta contare le righe diverse: si
#     pretende QUALI righe, e SOLO quelle. Tre righe sbagliate darebbero
#     lo stesso conteggio e il round misurerebbe due cose insieme.
#     >>> Il confronto e' POSIZIONALE e regge perche' i file sono generati
#         con lo stesso ordine di input: se le righe vive sono in ordine
#         diverso il gate se ne accorge (esce un diff enorme), e in quel
#         caso ci si ferma -- come deve.
foreach($fam in $FamLavoro){
  $rif = @($Lavori | Where-Object { $_.Fam -eq $fam.Id -and $_.Long })
  if($rif.Count -ne 1){ throw ("famiglia " + $fam.Id + ": trovate " + $rif.Count + " celle LONG invece di 1. Senza il denominatore lo short non ha niente contro cui leggersi.") }
  $a = $Vive[$rif[0].Prova]
  foreach($c in @($Lavori | Where-Object { $_.Fam -eq $fam.Id -and -not $_.Long })){
    $b = $Vive[$c.Prova]
    if($a.Count -ne $b.Count){ throw ($c.Prova + ": " + $b.Count + " righe vive contro " + $a.Count + " della cella long. Non sono confrontabili.") }
    $d = New-Object System.Collections.ArrayList
    for($i=0;$i -lt $a.Count;$i++){ if($a[$i] -ne $b[$i]){ [void]$d.Add((NomeDi $a[$i])) } }
    #  InpMagic differisce SEMPRE ed e' voluto: e' l'asse gemello.
    $attese = @($c.Diff) + @("InpMagic")
    $manca  = @($attese | Where-Object { $d -notcontains $_ })
    $extra  = @($d      | Where-Object { $attese -notcontains $_ })
    if($manca.Count -gt 0 -or $extra.Count -gt 0){
      throw ($c.Prova + " contro " + $rif[0].Prova + ": differiscono su [" + ($d -join ", ") +
             "] invece che su [" + ($attese -join ", ") + "]. R107 pretende CHE CAMBINO SOLO I DUE LATI (piu' il magic): cosi' il numero e' attribuibile alla DIREZIONE e a nient'altro.")
    }
  }
}
Dico "gate della STELLA: ogni cella short differisce dalla sua cella long SOLO sui due lati" "Green"

# --- 1e. I VALORI, letti NELL'ARTEFATTO CHE GIRA (checklist 34-bis).
#     Il diff dice CHE cambiano; questo dice CHE COSA valgono: se i due
#     file di una famiglia fossero SCAMBIATI, il diff resterebbe verde.
#     >>> OGNI $ DI UNA REGEX MULTILINEA SI SCRIVE \r?$ (checklist 40): i
#         file arrivano da GitHub con CRLF, e senza \r? il match non
#         avviene MAI e il gate accuserebbe un file sano.
$magicVisti = @()
foreach($c in $Lavori){
  $fam = @($FAMIGLIE | Where-Object { $_.Id -eq $c.Fam })[0]
  $tx  = Get-Content -LiteralPath (Join-Path $Prove $c.Prova) -Raw
  # --- la GEOMETRIA VIVA, riga per riga, in OGNI file della famiglia.
  #     >>> InpAllowLong/InpAllowShort NON sono in queste liste: sono
  #         l'ASSE del round, e il loro valore lo pretende il blocco Val
  #         qui sotto, cella per cella.
  foreach($chk in $VIVA[$c.Fam]){
    $rx = '(?m)^' + $chk[0] + '=' + [regex]::Escape($chk[1]) + '\|\|'
    if($tx -notmatch $rx){
      throw ($c.Prova + ": non trovo '" + $chk[0] + "=" + $chk[1] + "'. Questa NON e' la geometria dichiarata nei criteri par. 2 per la famiglia " +
             $c.Fam + ": il round girerebbe sopra un motore che non esiste.")
    }
  }
  # --- e i valori PROPRI di questa cella: I DUE LATI.
  foreach($k in $c.Val.Keys){
    $rx = '(?m)^' + $k + '=' + [regex]::Escape($c.Val[$k]) + '\|\|'
    if($tx -notmatch $rx){ throw ($c.Prova + ": " + $k + " non vale " + $c.Val[$k] + ". La cella non e' quella che credo -- e su un round sui LATI questo e' l'errore che rende il referto una bugia.") }
  }
  # --- @SIMBOLO / @PERIODO / @DAQUANDO, confrontati e non creduti.
  #     >>> CHECKLIST 67: e' qui che la regola "niente coda 2026.07-08"
  #         (criteri par. 4) diventa un if invece di una frase.
  $m = [regex]::Match($tx,'(?m)^@DAQUANDO\s+([0-9]{4}\.[0-9]{2}\.[0-9]{2})')
  if(-not $m.Success -or $m.Groups[1].Value -ne $DaQuando){ throw ($c.Prova + ": @DAQUANDO non e' " + $DaQuando) }
  $s = [regex]::Match($tx,'(?m)^@SIMBOLO\s+(\S+)')
  if(-not $s.Success -or $s.Groups[1].Value -ne $fam.Sym){ throw ($c.Prova + ": @SIMBOLO non e' " + $fam.Sym) }
  $p = [regex]::Match($tx,'(?m)^@PERIODO\s+(\S+)')
  if(-not $p.Success -or $p.Groups[1].Value -ne $Periodo){ throw ($c.Prova + ": @PERIODO non e' " + $Periodo) }
  # --- L'ORA E' QUELLA DEL SERVER. Regola di casa: server BCM = ora
  #     italiana - 1, e sugli indici e' MISURATA (4DOC par. 2.2). DAX
  #     09:00 IT = 08:00 server; apertura USA 15:30 IT = 14:30 server.
  #     Un 9 o un 15:30 qui dentro sarebbero l'ora ITALIANA, cioe'
  #     un'ALTRA strategia: i CSV andrebbero cestinati, e meglio non
  #     produrli affatto.
  if($tx -notmatch ('(?m)^InpSessionHour=' + $fam.OraH + '\|\|')){ throw ($c.Prova + ": InpSessionHour non e' " + $fam.OraH + " (ORA SERVER!). Server BCM = ora italiana - 1.") }
  if($tx -notmatch ('(?m)^InpSessionMin='  + $fam.OraM + '\|\|')){ throw ($c.Prova + ": InpSessionMin non e' " + $fam.OraM) }
  # --- L'ASSE UNICO. La prosa dei criteri dice "zero parametri
  #     spazzolati, l'unico asse Y e' InpMagic": CHECKLIST 67, la regola
  #     ha il suo if, e lo ha QUI NEL FILE -- non solo nell'anteprima del
  #     giro a vuoto, che nella corsa vera non viene nemmeno prodotta.
  $assiY = @([regex]::Matches($tx,'(?m)^(\w+)=[^\r\n]*\|\|\s*[Yy]\s*\r?$') | ForEach-Object { $_.Groups[1].Value })
  if($assiY.Count -ne 1 -or $assiY[0] -ne "InpMagic"){
    throw ($c.Prova + ": gli assi spazzolati sono [" + ($assiY -join ", ") + "] invece del solo InpMagic. R107 NON ottimizza niente: piu' di un asse sarebbe una griglia, cioe' un altro round.")
  }
  # --- i magic
  $mg = [regex]::Match($tx,'(?m)^InpMagic=(\d+)\|\|(\d+)\|\|1\|\|(\d+)\|\|Y')
  if(-not $mg.Success){ throw ($c.Prova + ": InpMagic non e' nella forma sweep 'v||v||1||v+1||Y'. Senza almeno un asse Y il driver generico si rifiuta di partire e MT5 rispazzola la griglia vecchia (checklist punto 5).") }
  $m0 = [int]$mg.Groups[1].Value; $m1 = [int]$mg.Groups[3].Value
  if($m0 -ne [int]$c.Magic){ throw ($c.Prova + ": InpMagic e' " + $m0 + " ma questa cella deve girare su " + $c.Magic) }
  if($m1 -ne ($m0+1)){ throw ($c.Prova + ": il gemello e' " + $m1 + " invece di " + ($m0+1)) }
  foreach($mm in @($m0,$m1)){
    if($magicVisti -contains $mm){ throw ($c.Prova + ": magic " + $mm + " gia' usato da un altro file prova. Due file con lo stesso magic non sono distinguibili nel CSV.") }
    if($MagicVietati -contains $mm){ throw ($c.Prova + ": il magic " + $mm + " e' di una SEDIA VIVA (o spenta, o di un round precedente). Fermo tutto: il tester non deve poter incrociare i deal del forward.") }
    $magicVisti += $mm
  }
}
Dico ("geometria, ora SERVER, LATI, asse unico e " + $magicVisti.Count + " magic vergini verificati NEI FILE") "Green"

# --- 1f. I SORGENTI E IL GATE DI VERSIONE. I marcatori sono presi DAL
#     SORGENTE, e sono DUE per EA: la versione dichiarata e il magic
#     dichiarato. Una cache CDN o un branch sbagliato darebbero un altro
#     motore, e il round misurerebbe un'altra cosa.
#     >>> IL MAGIC DEL SORGENTE E' QUELLO VIVO (770202 / 770101 / 770201),
#         e va benissimo cosi': e' l'identita' del motore. I magic vergini
#         stanno nei FILE PROVA e sovrascrivono il default nel tester.
foreach($fam in $FamLavoro){
  $srcMq5 = Join-Path $SrcDir ($fam.Ea + ".mq5")
  Scarica ("$RawPin/mql5/Experts/" + $fam.Ea + ".mq5") $srcMq5 'ABTG_ApertureCore'
  $txtSrc = Get-Content -LiteralPath $srcMq5 -Raw
  $mv = [regex]::Match($txtSrc,'#property\s+version\s+"([^"]+)"')
  if(-not $mv.Success){ throw ($fam.Ea + ".mq5 scaricato senza #property version: non e' il sorgente che credo.") }
  if($mv.Groups[1].Value -ne $fam.Ver){
    throw ($fam.Ea + ".mq5 dichiara version '" + $mv.Groups[1].Value + "' invece di '" + $fam.Ver +
           "'. O la cache di raw.githubusercontent serve una copia vecchia, o il pin e' sbagliato: mi fermo.")
  }
  if($txtSrc -notmatch ('#define\s+ABTG_DEF_MAGIC\s+' + $fam.MagicSrc)){
    throw ($fam.Ea + ".mq5 non dichiara ABTG_DEF_MAGIC " + $fam.MagicSrc + ": non e' il motore di questa sedia.")
  }
  foreach($inp in @("InpAllowLong","InpAllowShort")){
    if($txtSrc -notmatch $inp){ throw ($fam.Ea + ".mq5 non ha " + $inp + ": senza i due lati non c'e' niente da misurare in questo round.") }
  }
  #  >>> SOLO IL NASDAQ: i due opt-in del round 30 esistono solo li', e i
  #      file prova li pinnano SPENTI. Se il sorgente non li avesse, il
  #      pin sarebbe INERTE e il file prova mentirebbe.
  if($fam.Id -eq "NAS"){
    foreach($inp in @("InpUseVolRegime","InpUseSRFilter")){
      if($txtSrc -notmatch $inp){ throw ($fam.Ea + ".mq5 non ha " + $inp + ", ma il file prova lo pinna a 0: un pin su un input inesistente e' un pin INERTE, e MT5 non se ne lamenta. Mi fermo.") }
    }
    Dico "   NAS: i due opt-in R30 esistono nel sorgente e sono pinnati SPENTI nei file prova" "Gray"
  }
  Dico ($fam.Ea + ".mq5 al pin, version " + $mv.Groups[1].Value + ", ABTG_DEF_MAGIC " + $fam.MagicSrc) "Green"
}

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
$MqlFiles   = Join-Path $DataFolder "MQL5\Files"
New-Item -ItemType Directory -Force -Path $MqlExperts,$MqlInclude,$Sosta | Out-Null
#  OGNI PASSO STAMPA IL BERSAGLIO CHE HA SCELTO (checklist 37).
Dico ("terminale : " + $Terminal)
Dico ("dati      : " + $DataFolder + "   (DEVE restare lo stesso in tutti i passi)")

# --- 2a. LA SOSTA SI SVUOTA A OGNI GIRO (checklist 56). Il giro a vuoto
#     lascia in sosta le anteprima_*.ini; la corsa vera NON le riproduce e
#     la raccolta copia in blocco tutta la sosta nello zip: dentro il
#     risultato del round finirebbero .ini CHE NON HANNO GIRATO,
#     indistinguibili da quelli veri. Qui non si perde niente: la sosta e'
#     una copia di lavoro, l'archivio e' la cartella datata sul Desktop,
#     che non si sovrascrive mai (checklist 12).
#     >>> E SI CONTA PRIMA E DOPO (checklist 69): una Remove-Item che
#         fallisce in silenzio degraderebbe questo passo in un "boh".
$nSosta = @(Get-ChildItem -LiteralPath $Sosta -File -ErrorAction SilentlyContinue).Count
if($nSosta -gt 0){
  Get-ChildItem -LiteralPath $Sosta -File -ErrorAction SilentlyContinue | Remove-Item -Force -ErrorAction SilentlyContinue
  $nDopo = @(Get-ChildItem -LiteralPath $Sosta -File -ErrorAction SilentlyContinue).Count
  if($nDopo -gt 0){
    [void]$Problemi.Add("sosta: " + $nDopo + " file su " + $nSosta + " di un giro PRECEDENTE non sono stati cancellati. Possono finire nello zip di questo round spacciandosi per artefatti di adesso: controllare le date dentro lo zip prima di leggerlo.")
  }
  Dico ("sosta svuotata: " + $nSosta + " file di un giro precedente rimossi (rimasti: " + $nDopo + ")") "Green"
}

# --- 2b. L'INCLUDE CHE NESSUN DRIVER INSTALLA (checklist 33-bis).
#     I tre EA fanno #include <ABTG_PausaGuardian.mqh> e chiamano
#     ABTG_GuardiaIngresso(). walkforward_generico.ps1 scarica SOLO il
#     .mq5: senza questa riga la compilazione fallisce e il round muore
#     alla prima passata. Pagato due volte (21/08 e 22/08).
#     >>> NEL TESTER LA GUARDIA E' FAIL-OPEN TOTALE (le GlobalVariable del
#         Guardian non esistono): non cambia il comportamento e i numeri
#         restano confrontabili con R46/R54/R101.
$mqh = Join-Path $MqlInclude "ABTG_PausaGuardian.mqh"
Scarica ("$RawPin/mql5/Include/ABTG_PausaGuardian.mqh") $mqh 'ABTG_GuardiaIngresso'
$vfy = Get-Item -LiteralPath $mqh
if($vfy.PSIsContainer){ throw "ABTG_PausaGuardian.mqh: in Include c'e' una CARTELLA con quel nome (checklist 27-ter)." }
if($vfy.Length -lt 4000){ throw ("ABTG_PausaGuardian.mqh e' lungo " + $vfy.Length + " byte: troppo poco, scarico monco.") }
Dico ("include installato: ABTG_PausaGuardian.mqh (" + $vfy.Length + " byte)") "Green"

# --- 2c. PULIZIA DEGLI ARTEFATTI VECCHI, PRIMA (checklist 14, 53 e 69).
#     >>> SOLO se si corre davvero: un giro a vuoto che cancella gli
#         artefatti di una corsa vera fatta ieri e' un danno.
#     >>> E SI CANCELLA PER NOME: un filtro a wildcard prenderebbe anche i
#         CSV delle sedie vive e degli altri round.
#     >>> E SE UN FILE SOPRAVVIVE, LO SI DICE RUMOROSAMENTE (checklist 69):
#         "cancello e poi controllo che esista" fatto con
#         -ErrorAction SilentlyContinue degrada in silenzio nel controllo
#         che il punto 54 vieta per nome.
if($SoloControllo){
  Dico "SoloControllo: NON cancello niente." "Yellow"
} else {
  foreach($fam in $FamLavoro){
    $optCsv = Join-Path $MqlFiles ("OptResults_" + $fam.Ea + "_" + $fam.Sym + ".csv")
    if(Test-Path -LiteralPath $optCsv){
      Remove-Item -LiteralPath $optCsv -Force -ErrorAction SilentlyContinue
      if(Test-Path -LiteralPath $optCsv){
        [void]$Problemi.Add("NON sono riuscito a cancellare " + $optCsv + " (qualcuno lo tiene aperto). Il file di appoggio dell'OPTFRAME e' di un giro PRECEDENTE: i CSV di questo round vanno confrontati con la loro data prima di leggerli.")
        Dico ("OptResults NON cancellato: " + $optCsv) "Red"
      }
    }
  }
  # --- la CACHE del tester, e SOLO quella. MAI bases\<server>\ticks: li'
  #     dentro c'e' lo storico a tick reali di U30USD, D30EUR e NASUSD, e
  #     ributtarlo giu' e' una nottata.
  #  >>> CON -LiteralPath IL * NON E' UN WILDCARD (checklist 46).
  #  >>> E NON SI CREDE ALL'INTENZIONE: si conta PRIMA e DOPO.
  $cache = Join-Path $DataFolder "Tester\cache"
  if(Test-Path -LiteralPath $cache){
    $nc = @(Get-ChildItem -LiteralPath $cache -Force -Recurse -File -ErrorAction SilentlyContinue).Count
    Get-ChildItem -LiteralPath $cache -Force -ErrorAction SilentlyContinue | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
    $nr = @(Get-ChildItem -LiteralPath $cache -Force -Recurse -File -ErrorAction SilentlyContinue).Count
    if($nr -gt 0){
      [void]$Problemi.Add("Tester\cache NON svuotata: " + $nr + " file su " + $nc + " sono rimasti. MT5 puo' ripescare passate gia' calcolate (punto 38).")
      Dico ("Tester\cache: " + $nc + " file prima, " + $nr + " RIMASTI.") "Red"
    } else {
      Dico ("Tester\cache svuotata: " + $nc + " file prima, 0 dopo. bases\<server>\ticks NON toccata.") "Green"
    }
  } else { Dico "Tester\cache non esiste: niente da svuotare." "Gray" }
}

# =====================================================================
#  3. FASE COMPILA, un EA alla volta. .ex5 SCRITTO ADESSO.
#     Si fa ANCHE in -SoloControllo: il -SoloControllo del driver generico
#     esce PRIMA della compilazione (checklist 39), quindi un giro a vuoto
#     che non compilasse non direbbe niente sulla compilabilita'.
#     >>> INVOCAZIONE DIRETTA di metaeditor64.exe (checklist 54 e bug del
#         22/08): con Start-Process -ArgumentList a stringhe pre-quotate,
#         sui path con spazi ("Program Files") torna rc=0 SENZA compilare.
#     >>> E IL VERDETTO E' IL LastWriteTime DEL .ex5 PRIMA/DOPO, non
#         "esiste" e non "e' recente": i file c'erano gia'.
# =====================================================================
Titolo "3. FASE COMPILA"
foreach($fam in $FamLavoro){
  $srcMq5 = Join-Path $SrcDir ($fam.Ea + ".mq5")
  $mq5 = Join-Path $MqlExperts ($fam.Ea + ".mq5")
  $ex5 = Join-Path $MqlExperts ($fam.Ea + ".ex5")
  $logC= Join-Path $MqlExperts ($fam.Ea + ".log")
  #  backup DATATO e MAI sovrascritto (checklist 12): il .ex5 vecchio e'
  #  l'unica prova di cosa girava prima su questa macchina.
  $bakMq5 = $mq5 + ".prima_r107_" + $Stamp
  $bakEx5 = $ex5 + ".prima_r107_" + $Stamp
  if((Test-Path -LiteralPath $mq5) -and -not (Test-Path -LiteralPath $bakMq5)){ Copy-Item -LiteralPath $mq5 -Destination $bakMq5 -Force }
  if((Test-Path -LiteralPath $ex5) -and -not (Test-Path -LiteralPath $bakEx5)){ Copy-Item -LiteralPath $ex5 -Destination $bakEx5 -Force }
  Copy-Item -LiteralPath $srcMq5 -Destination $mq5 -Force
  #  verifica della copia sul CONTENUTO, non sul nome (checklist 27-ter)
  $lenSrc = (Get-Item -LiteralPath $srcMq5).Length
  $vc = Get-Item -LiteralPath $mq5 -ErrorAction SilentlyContinue
  if(-not $vc -or $vc.PSIsContainer -or $vc.Length -ne $lenSrc){ throw ("copia di " + $fam.Ea + ".mq5 in MQL5\Experts NON verificata (lunghezza diversa o e' una cartella).") }
  $ex5Prima = (Get-Date).AddYears(-100)
  if(Test-Path -LiteralPath $ex5){ $ex5Prima = (Get-Item -LiteralPath $ex5).LastWriteTime }
  Remove-Item -LiteralPath $logC -Force -ErrorAction SilentlyContinue
  & $MetaEditor "/compile:$mq5" "/log:$logC" | Out-Null
  $rcMe = $LASTEXITCODE
  $ex5Dopo = $null
  if(Test-Path -LiteralPath $ex5){ $ex5Dopo = (Get-Item -LiteralPath $ex5).LastWriteTime }
  $compileOk = ($null -ne $ex5Dopo) -and ($ex5Dopo -gt $ex5Prima)
  $testoLog = ""
  if(Test-Path -LiteralPath $logC){
    try{ $testoLog = (Get-Content -LiteralPath $logC -Raw -Encoding Unicode) }catch{ $testoLog = "" }
    if($testoLog -notmatch '(?i)error'){ try{ $testoLog = (Get-Content -LiteralPath $logC -Raw) }catch{} }
    Copy-Item -LiteralPath $logC -Destination (Join-Path $Sosta ("compile_" + $fam.Id + ".log")) -Force -ErrorAction SilentlyContinue
  }
  if(-not $compileOk){
    if($testoLog -ne ""){
      Write-Host "--- log del compilatore (ultime righe) ---" -ForegroundColor DarkYellow
      foreach($r in @($testoLog -split "\r?\n" | Select-Object -Last 20)){ Write-Host ("   " + $r) -ForegroundColor DarkYellow }
    } else { Write-Host "   (nessun log prodotto da MetaEditor)" -ForegroundColor DarkYellow }
    #  sorgente e binario devono restare la STESSA versione (checklist 54)
    if(Test-Path -LiteralPath $bakMq5){ Copy-Item -LiteralPath $bakMq5 -Destination $mq5 -Force }
    throw ("COMPILAZIONE FALLITA per " + $fam.Ea + " (metaeditor rc=" + $rcMe + ", .ex5 NON riscritto). Il .mq5 e' stato rimesso com'era e il log e' nello zip. Sospetto n.1: include mancante o MetaEditor gia' aperto.")
  }
  $mw = [regex]::Match($testoLog,'(?i)(\d+)\s+warning')
  if($mw.Success -and [int]$mw.Groups[1].Value -gt 0){
    [void]$Rilievi.Add("compilazione " + $fam.Ea + ": " + $mw.Groups[1].Value + " warning (0 errori). Non fermano il round, ma vanno letti nel log dello zip.")
  }
  $fam.Compilato = $true
  Dico ("COMPILATO " + $fam.Ea + " v" + $fam.Ver + " (.ex5 riscritto adesso, rc=" + $rcMe + ")") "Green"
}

# =====================================================================
#  4. LA CATENA. Una cella alla volta. Mai in parallelo.
#     L'ORDINE CONTA: dentro ogni famiglia la cella LONG gira PER PRIMA,
#     perche' i gate G0 di quella famiglia stanno li' -- e se il metro
#     non si riproduce, la short di quella famiglia non si lancia
#     nemmeno (sarebbero ore di macchina per numeri che non si leggono).
#     >>> E le ALTRE famiglie vanno avanti lo stesso: una sedia storta
#         non porta via anche le altre (stessa scelta di R100 e R101).
# =====================================================================
Titolo ("4. LA CATENA - " + $Lavori.Count + " celle, una alla volta")
$Ordinati = @()
foreach($fam in $FamLavoro){
  $Ordinati += @($Lavori | Where-Object { $_.Fam -eq $fam.Id -and $_.Long })
  $Ordinati += @($Lavori | Where-Object { $_.Fam -eq $fam.Id -and -not $_.Long })
}
$idx = 0
foreach($c in $Ordinati){
  $idx++
  $fam = @($FAMIGLIE | Where-Object { $_.Id -eq $c.Fam })[0]
  if($FamFerme -contains $c.Fam){
    $c.Esito = "NON INIZIATA (la famiglia " + $c.Fam + " si e' fermata al gate G0)"
    continue
  }
  $trascorse = (New-TimeSpan -Start $Avvio -End (Get-Date)).TotalHours
  if($trascorse -ge $OreMax){
    $c.Esito = "NON INIZIATA (tetto ore raggiunto)"
    [void]$Problemi.Add("TEMPO SCADUTO prima di " + $c.Prova + ": il round NON e' completo. Riprendi con -SoloCella " + $c.Prova + " (la cella long della sua famiglia rigira da sola).")
    continue
  }
  Write-Host ""
  Write-Host "------------------------------------------------------------------" -ForegroundColor Cyan
  Write-Host ("  [" + $idx + "/" + $Ordinati.Count + "]  " + $c.Prova + $(if($c.Long -and $fam.HaMetro){ "   <<< IL METRO (gate G0)" }elseif($c.Long){ "   <<< IL RIFERIMENTO (nessun G0)" }else{ "" })) -ForegroundColor Cyan
  Write-Host ("           " + $c.Desc) -ForegroundColor Cyan
  Write-Host "------------------------------------------------------------------" -ForegroundColor Cyan
  $tl = Get-Date
  #  -Terminal e -DataFolder passati ESPLICITI (checklist 37): il driver
  #  generico altrimenti ri-cerca il terminale per conto suo, e potrebbe
  #  trovarne uno diverso da quello su cui abbiamo compilato.
  $arg = @("-ExecutionPolicy","Bypass","-File",$Driver,
           "-Expert",$fam.Ea,"-Prova",(Join-Path $Prove $c.Prova),
           "-Simbolo",$fam.Sym,"-Periodo",$Periodo,
           "-DaQuando",$DaQuando,"-Fino",$Fino,
           "-Etichetta",$c.Id,"-Modello",("" + $Modello),
           "-Deposito",("" + $Deposito),"-Spread",("" + $SpreadIni),
           "-Terminal",$Terminal,"-MetaEditor",$MetaEditor,"-DataFolder",$DataFolder)
  if($Rifai){ $arg += "-Rifai" }
  if($SoloControllo){ $arg += "-SoloControllo" }
  $global:LASTEXITCODE = 0
  try{
    & powershell.exe $arg 2>&1 | Tee-Object -FilePath (Join-Path $Logs ($c.Fam + "_" + $c.Id + ".txt")) | Out-Host
  }catch{
    [void]$Problemi.Add($c.Prova + ": il driver generico e' uscito con eccezione - " + $_.Exception.Message)
  }
  if($LASTEXITCODE -ne 0){
    [void]$Problemi.Add($c.Prova + ": il driver generico e' uscito con codice " + $LASTEXITCODE)
  }
  $c.Min = [math]::Round((New-TimeSpan -Start $tl -End (Get-Date)).TotalMinutes,1)

  if(-not $SoloControllo){
    #  >>> UN CSV VECCHIO NON E' UN CSV OK: SI GUARDA LA DATA.
    #  walkforward_generico.ps1 SALTA la finestra il cui CSV esiste gia'
    #  ("gia' fatto, salto"), e questa riga PRESCRIVE quel percorso
    #  (-OreMax che ferma a meta', -SoloCella per riprendere). Contando
    #  solo le righe, un file di un lancio precedente passerebbe per OK -
    #  e se fra i due lanci fosse cambiato il pin, META' ROUND VERREBBE DA
    #  UN ALTRO MOTORE.
    #  >>> E GLI STATI SONO TRE, NON DUE (checklist 49): il driver
    #      generico salta per FINESTRA, non per cella.
    $vecchie = @()
    foreach($tag in @("IS","OOS")){
      $pth = CsvDi $c $tag
      $nn = -1
      if(Test-Path -LiteralPath $pth){
        $nn = (@(Get-Content -LiteralPath $pth).Count) - 1
        if((Get-Item -LiteralPath $pth).LastWriteTime -lt $tl){ $vecchie += $tag }
      }
      if($tag -eq "IS"){ $c.IS = $nn } else { $c.OOS = $nn }
    }
    if($vecchie.Count -eq 2){
      $c.Esito = "SALTATA DAL DRIVER (IS+OOS gia' presenti da un lancio precedente)"
      [void]$Problemi.Add($c.Prova + ": " + $c.Esito + ". Le righe tornano ma i file NON sono di questo lancio: rilancia con -Rifai.")
    }
    elseif($vecchie.Count -eq 1){
      $c.Esito = "A META' (" + $vecchie[0] + " e' di un lancio PRECEDENTE, l'altra gamba e' di adesso)"
      [void]$Problemi.Add($c.Prova + ": " + $c.Esito + ". Le due gambe vengono da due giri diversi: rilancia questa cella con -Rifai.")
    }
    elseif([int]$c.IS -eq $CelleAttese -and [int]$c.OOS -eq $CelleAttese){ $c.Esito = "OK" }
    else{
      $c.Esito = "RIGHE SBAGLIATE (IS " + $c.IS + " / OOS " + $c.OOS + ", attese " + $CelleAttese + ")"
      [void]$Problemi.Add($c.Prova + ": " + $c.Esito + ". Cache del tester, oppure lo sweep dei magic non ha spazzolato: il file NON si legge.")
    }

    # ---------- LE MISURE, lette dai CSV (parser col controllo positivo)
    $rOOS = LeggiOpt (CsvDi $c "OOS")
    $c.Gemelli = Gemelli $rOOS
    if($null -eq $rOOS){
      [void]$Problemi.Add($c.Prova + ": CSV OOS non letto o colonne non riconosciute. Intestazioni viste: [" + (($script:CsvIntestazioni | Select-Object -First 12) -join " | ") + "]")
    } elseif(@($rOOS).Count -ge 1){
      if($null -ne $rOOS[0].Pf){     $c.PfOOS   = [double]$rOOS[0].Pf }
      if($null -ne $rOOS[0].Dd){     $c.DdOOS   = [double]$rOOS[0].Dd }
      if($null -ne $rOOS[0].N){      $c.NOOS    = [int]$rOOS[0].N }
      if($null -ne $rOOS[0].Profit){ $c.ProfOOS = [double]$rOOS[0].Profit }
      if($null -ne $rOOS[0].Pg){     $c.PgOOS   = [double]$rOOS[0].Pg }
    }
    $rIS = LeggiOpt (CsvDi $c "IS")
    if($null -eq $rIS){
      [void]$Problemi.Add($c.Prova + ": CSV IS non letto o colonne non riconosciute.")
    } elseif(@($rIS).Count -ge 1){
      if($null -ne $rIS[0].Pf){     $c.PfIS   = [double]$rIS[0].Pf }
      if($null -ne $rIS[0].Dd){     $c.DdIS   = [double]$rIS[0].Dd }
      if($null -ne $rIS[0].N){      $c.NIS    = [int]$rIS[0].N }
      if($null -ne $rIS[0].Profit){ $c.ProfIS = [double]$rIS[0].Profit }
    }

    # ---------- I GATE G0, SOLO SULLA CELLA LONG
    if($c.Long){
      $fam.Gemelli = $c.Gemelli
      $fam.NOOS = $c.NOOS; $fam.NIS = $c.NIS
      $fam.PfOOS = $c.PfOOS; $fam.DdOOS = $c.DdOOS; $fam.ProfOOS = $c.ProfOOS
      $guai = New-Object System.Collections.ArrayList
      if($c.Gemelli -ne "IDENTICI"){ [void]$guai.Add("gemelli: " + $c.Gemelli) }
      #  >>> CHECKLIST 67: LA REGOLA "SUL NAS NON ESISTE NESSUN G0" E'
      #      QUESTO if. Il confronto coi numeri agli atti non viene
      #      nemmeno valutato, perche' non ci sono numeri agli atti.
      #      E il verdetto scritto e' NON APPLICABILE, che NON e'
      #      "superato": un gate che non ha niente da confrontare non e'
      #      un gate verde.
      if(-not $fam.HaMetro){
        if($guai.Count -gt 0){
          $fam.Metro = "IGIENE FALLITA (G0 non applicabile) -- " + ($guai -join " ; ")
          $FamFerme += $c.Fam
          [void]$Problemi.Add("GEMELLI FALLITI sulla famiglia " + $c.Fam + ": " + ($guai -join " ; ") +
                              ". Su questa famiglia non c'e' nessun metro da riprodurre, ma due righe gemelle DIVERSE vogliono dire che il file non si legge: la short NON e' stata lanciata.")
          Dico ("IGIENE FALLITA su " + $c.Fam + ": " + $fam.Metro) "Red"
        } else {
          $fam.Metro = "NON APPLICABILE (nessuna sedia viva, nessun numero agli atti) -- misurato adesso: PF " + (Fmt3 $c.PfOOS) + ", DD " + (Fmt2 $c.DdOOS) + "%, n " + (FmtN $c.NOOS)
          [void]$Rilievi.Add("G0 sulla famiglia " + $c.Fam + ": NON APPLICABILE. " + $fam.Fonte +
                             " I numeri della sua cella long sono un RIFERIMENTO (denominatore della short), NON una riproduzione: nessuno puo' dire che il banco e' sano guardando questa famiglia.")
          Dico ("G0 " + $c.Fam + ": NON APPLICABILE (e non e' 'superato'). Riferimento misurato: PF " + (Fmt3 $c.PfOOS) + " | DD " + (Fmt2 $c.DdOOS) + "% | n " + (FmtN $c.NOOS)) "Yellow"
        }
      }
      else{
        if([double]$c.PfOOS -lt 0 -or [double]$c.DdOOS -lt 0){ [void]$guai.Add("PF o DD OOS NON MISURATI") }
        else{
          #  LE TOLLERANZE SONO QUELLE PROPOSTE NEI CRITERI par. 5 (G0) e
          #  sono [DA FIRMARE]: +-0,01 su PF, +-0,10 punti % su DD, n ESATTO.
          #  >>> OGNI CONFRONTO CASTA (checklist 64). Qui NAtti e' -1 solo
          #      sul NAS, che pero' non entra mai in questo ramo: il cast
          #      resta comunque, perche' la regola non si applica "quando
          #      serve" ma sempre.
          if([math]::Abs([double]$c.PfOOS - [double]$fam.PfAtti) -gt $TolPf){ [void]$guai.Add("PF OOS " + (Fmt3 $c.PfOOS) + " contro " + ([double]$fam.PfAtti).ToString("0.000",$INV) + " agli atti") }
          if([math]::Abs([double]$c.DdOOS - [double]$fam.DdAtti) -gt $TolDd){ [void]$guai.Add("DD OOS " + (Fmt2 $c.DdOOS) + "% contro " + ([double]$fam.DdAtti).ToString("0.00",$INV) + "% agli atti") }
          if([int]$fam.NAtti -gt 0 -and [int]$c.NOOS -ne [int]$fam.NAtti){ [void]$guai.Add("n OOS " + (FmtN $c.NOOS) + " contro " + $fam.NAtti + " agli atti") }
        }
        if($guai.Count -gt 0){
          $fam.Metro = "NON RIPRODOTTO -- " + ($guai -join " ; ")
          $FamFerme += $c.Fam
          [void]$Problemi.Add("GATE G0 FALLITO sulla famiglia " + $c.Fam + ": " + $fam.Metro +
                              ". La cella short di questa famiglia NON e' stata lanciata: sopra un metro sbagliato non misurerebbe niente. Fonte dei numeri attesi: " + $fam.Fonte)
          Dico ("GATE G0 FALLITO su " + $c.Fam + ": " + $fam.Metro) "Red"
          Dico ("   la short di " + $c.Fam + " NON verra' lanciata. Le altre famiglie proseguono.") "Red"
        } else {
          $fam.Metro = "RIPRODOTTO (PF " + (Fmt3 $c.PfOOS) + ", DD " + (Fmt2 $c.DdOOS) + "%, n " + (FmtN $c.NOOS) + ")"
          Dico ("GATE G0 SUPERATO su " + $c.Fam + ": " + $fam.Metro) "Green"
        }
      }
      Dico ("   CANARINO " + $c.Fam + ": n IS " + (FmtN $c.NIS) + " / n OOS " + (FmtN $c.NOOS) + "   (NON e' un gate: Emendamento regola B)") "Yellow"
      if([int]$c.NIS -ge 0 -and [int]$c.NIS -lt 150){
        [void]$Rilievi.Add("CANARINO " + $c.Fam + ": n IS = " + $c.NIS + ", sotto i 150 dell'Emendamento regola A. Il giudizio di MERITO su questa famiglia e' SOSPESO (criteri par. 5, G4) -- e' un risultato, non un guasto.")
      }
      if([int]$c.NOOS -ge 0 -and [int]$c.NOOS -lt 150){
        [void]$Rilievi.Add("CANARINO " + $c.Fam + ": n OOS = " + $c.NOOS + ", sotto 150. Vale la stessa sospensione, e il lato short assottiglia ancora.")
      }
    }
    else {
      #  ---------- LA CELLA SHORT
      #  sui gradini il gemello e' comunque igiene, e va nei PROBLEMI
      if($c.Gemelli -ne "IDENTICI" -and $c.Gemelli -ne "NON MISURATO (CSV non letto)"){
        [void]$Problemi.Add($c.Prova + ": gemelli " + $c.Gemelli + ". Le due righe dovevano essere identiche al centesimo: questa cella non si legge.")
      }
      #  ---------- G1: la MISURABILITA'. Sotto 30 il verdetto e' "NON
      #  MISURABILE", MAI "non funziona" (criteri par. 5, G1). E' un
      #  RILIEVO, cioe' un risultato del round, non un guasto.
      if([int]$c.NOOS -ge 0 -and [int]$c.NOOS -lt 30){
        [void]$Rilievi.Add($c.Prova + ": n OOS = " + $c.NOOS + ", sotto la soglia G1 di 30. Il verdetto su questa cella e' NON MISURABILE, NON 'non funziona' (criteri par. 5, G1). E' una risposta del round.")
      }
      #  ---------- G0-BIS: SOLO IL DOW SHORT, ed e' una RIPRODUZIONE.
      #  Criteri par. 5: NON ferma la famiglia (R54a pinnava meno input e
      #  la coincidenza dei due insiemi e' INFERITA sul lato short), ma
      #  finisce nei PROBLEMI: se il banco e' storto, anche DAX e NASUSD
      #  vanno letti con riserva.
      if($c.Prova -eq $G0bisCella){
        $gb = New-Object System.Collections.ArrayList
        if([double]$c.PfOOS -lt 0 -or [double]$c.DdOOS -lt 0){ [void]$gb.Add("PF o DD OOS NON MISURATI") }
        else{
          if([math]::Abs([double]$c.PfOOS - $G0bisPf) -gt $TolPf){ [void]$gb.Add("PF OOS " + (Fmt3 $c.PfOOS) + " contro " + $G0bisPf.ToString("0.000",$INV) + " di R54") }
          if([math]::Abs([double]$c.DdOOS - $G0bisDd) -gt $TolDd){ [void]$gb.Add("DD OOS " + (Fmt2 $c.DdOOS) + "% contro " + $G0bisDd.ToString("0.00",$INV) + "% di R54") }
          if([int]$c.NOOS -ne [int]$G0bisN){ [void]$gb.Add("n OOS " + (FmtN $c.NOOS) + " contro " + $G0bisN + " di R54") }
        }
        if($gb.Count -gt 0){
          [void]$Problemi.Add("GATE G0-BIS FALLITO: " + $G0bisCella + " NON riproduce il numero di R54 -- " + ($gb -join " ; ") +
                              ". NON ferma il round (criteri par. 5, G0-bis), MA IL BANCO E' SOSPETTO: anche le celle DAX e NASUSD di questo round vanno lette con riserva finche' lo scarto non e' spiegato. Fonte: " + $G0bisFonte)
          Dico ("GATE G0-BIS FALLITO su " + $c.Prova + ": " + ($gb -join " ; ")) "Red"
        } else {
          [void]$Rilievi.Add("GATE G0-BIS SUPERATO: " + $G0bisCella + " riproduce il numero di R54 (PF " + (Fmt3 $c.PfOOS) + " | DD " + (Fmt2 $c.DdOOS) + "% | n " + (FmtN $c.NOOS) + "). E' la conferma che il banco e' lo stesso di agosto: le celle DAX e NASUSD si leggono sullo stesso metro.")
          Dico ("GATE G0-BIS SUPERATO: R54 riprodotto (PF " + (Fmt3 $c.PfOOS) + " | DD " + (Fmt2 $c.DdOOS) + "% | n " + (FmtN $c.NOOS) + ")") "Green"
        }
      }
    }
  } else { $c.Esito = "SOLO CONTROLLO" }

  # --- L'ANTEPRIMA del giro a vuoto. Il driver generico la scrive sempre
  #     con lo stesso nome (anteprima_<EA>_<Simbolo>.ini, SENZA etichetta) e
  #     qui le celle di una famiglia girano TUTTE sullo stesso simbolo:
  #     senza metterla in sosta subito, ne resterebbe UNA sola e sarebbe
  #     l'ultima (checklist 31).
  if($SoloControllo){
    $ant = Join-Path $Work ("anteprima_" + $fam.Ea + "_" + $fam.Sym + ".ini")
    if(Test-Path -LiteralPath $ant){
      #  >>> E SI LEGGE, non si archivia soltanto. Tre cose, che sono
      #      ESATTAMENTE quelle che il giro a vuoto puo' dire:
      #      (1) la finestra IS che il driver generico ha CALCOLATO davvero;
      #      (2) che l'unico asse spazzolato e' InpMagic (2 celle);
      #      (3) che il magic e' quello di QUESTA cella.
      $atx = Get-Content -LiteralPath $ant -Raw
      $mf = [regex]::Match($atx,'(?m)^FromDate=([0-9.]+)\r?$')
      $mt = [regex]::Match($atx,'(?m)^ToDate=([0-9.]+)\r?$')
      if(-not $mf.Success -or -not $mt.Success){ [void]$Problemi.Add("giro a vuoto / " + $c.Fam + " " + $c.Id + ": nell'anteprima non trovo FromDate/ToDate.") }
      elseif($mf.Groups[1].Value -ne $IS_Da -or $mt.Groups[1].Value -ne $IS_A){
        [void]$Problemi.Add("giro a vuoto / " + $c.Fam + " " + $c.Id + ": il driver generico calcola la finestra IS " + $mf.Groups[1].Value + " - " + $mt.Groups[1].Value +
                            ", ma questa riga (e i criteri par. 4) dicono " + $IS_Da + " - " + $IS_A + ". O e' cambiata la FrazioneIS del driver, o e' cambiata la finestra: le due cose NON possono divergere.")
      }
      $assiY2 = @([regex]::Matches($atx,'(?m)^(\w+)=[^\r\n]*\|\|\s*[Yy]\s*\r?$') | ForEach-Object { $_.Groups[1].Value })
      if($assiY2.Count -ne 1 -or $assiY2[0] -ne "InpMagic"){
        [void]$Problemi.Add("giro a vuoto / " + $c.Fam + " " + $c.Id + ": gli assi spazzolati nell'anteprima sono [" + ($assiY2 -join ", ") + "] invece del solo InpMagic. Piu' di un asse = piu' di 2 celle per finestra, cioe' un altro round.")
      }
      if($atx -notmatch ('(?m)^InpMagic=' + $c.Magic + '\|\|')){
        [void]$Problemi.Add("giro a vuoto / " + $c.Fam + " " + $c.Id + ": nell'anteprima InpMagic non parte da " + $c.Magic + ".")
      }
      #  >>> E I DUE LATI, NELL'INI CHE GIRA DAVVERO. E' il controllo che
      #      un round sui LATI non puo' non fare: il file prova e' gia'
      #      stato verificato, ma quello che MT5 legge e' l'ini.
      foreach($k in $c.Val.Keys){
        if($atx -notmatch ('(?m)^' + $k + '=' + [regex]::Escape($c.Val[$k]) + '\s*\r?$') -and
           $atx -notmatch ('(?m)^' + $k + '=' + [regex]::Escape($c.Val[$k]) + '\|\|')){
          [void]$Problemi.Add("giro a vuoto / " + $c.Fam + " " + $c.Id + ": nell'anteprima " + $k + " non vale " + $c.Val[$k] + ". E' il LATO, cioe' l'unica cosa che questo round misura.")
        }
      }
      Copy-Item -LiteralPath $ant -Destination (Join-Path $Sosta ("anteprima_" + $c.Fam + "_" + $c.Id + ".ini")) -Force
      Remove-Item -LiteralPath $ant -Force -ErrorAction SilentlyContinue
    } else { [void]$Problemi.Add("giro a vuoto: nessuna anteprima .ini per " + $c.Prova) }
  }
  Write-Host ("    esito: " + $c.Esito + "   [" + $c.Min.ToString("0.0",$INV) + " min]") -ForegroundColor Gray
}

if($SoloControllo){
  $nAnt = @(Get-ChildItem -LiteralPath $Sosta -Filter "anteprima_*.ini" -ErrorAction SilentlyContinue).Count
  if($nAnt -ne $Ordinati.Count){ [void]$Problemi.Add("giro a vuoto: " + $nAnt + " anteprime .ini invece di " + $Ordinati.Count + ".") }
  Write-Host ""
  Write-Host ("    anteprime .ini in sosta: " + $nAnt + " su " + $Ordinati.Count + "   -> " + $Sosta) -ForegroundColor White
  Write-Host  "    >>> COSA SI LEGGE NELL'ANTEPRIMA, e cosa no:" -ForegroundColor Yellow
  Write-Host  "        SI LEGGE: FromDate/ToDate (la finestra IS vera, calcolata dal" -ForegroundColor Yellow
  Write-Host  "          driver generico: questa riga la CONFRONTA da sola con la sua)," -ForegroundColor Yellow
  Write-Host  "          il blocco [TesterInputs], l'unico asse Y (InpMagic), il magic," -ForegroundColor Yellow
  Write-Host  "          e I DUE LATI di questa cella." -ForegroundColor Yellow
  Write-Host  "        NON SI LEGGE: 'Model=4' e' una COSTANTE scritta a mano nel ramo" -ForegroundColor Yellow
  Write-Host  "          di prova del driver generico (cercare 'Model=4' li' dentro)." -ForegroundColor Yellow
  Write-Host  "          Stavolta COINCIDE con la corsa vera (-Modello 4), quindi non" -ForegroundColor Yellow
  Write-Host  "          mente -- ma resta una costante, non una conferma." -ForegroundColor Yellow
  Write-Host  "        E NON SI LEGGE NESSUN NUMERO DI ROUND: niente n, niente PF," -ForegroundColor Yellow
  Write-Host  "          niente DD, niente canarino, niente G0, niente G0-bis." -ForegroundColor Yellow
}

}catch{
  $Fatale = $_.Exception.Message
  Write-Host ""
  Write-Host ("!!! FERMATO: " + $Fatale) -ForegroundColor Red
}

# =====================================================================
#  5. RACCOLTA. Si fa SEMPRE, anche a esito parziale o fermato.
# =====================================================================
Titolo "5. RACCOLTA SUL DESKTOP"
#  >>> OGNI ARTEFATTO DICE IN QUALE MODO E' STATO PRODOTTO (checklist 50). <<<
$Modo = if($SoloControllo){ "CONTROLLO" } elseif($SoloCella -ne ""){ "RIPRESA" } elseif($SoloEa -ne ""){ ("SOLO" + ($SoloEa.ToUpper() -replace '[,\s]+','')) } else { "CORSA" }
$Cart = Join-Path $Dsk ("R107_LATI_SHORT_" + $Modo + "_" + $Stamp)
$Zip  = Join-Path $Dsk ("R107_LATI_SHORT_" + $Modo + "_" + $Stamp + ".zip")
$Referto = Join-Path $Cart "REFERTO_R107.txt"
try{
  New-Item -ItemType Directory -Force -Path $Cart | Out-Null
  foreach($c in $Lavori){
    foreach($tag in @("IS","OOS")){
      $src = CsvDi $c $tag
      if(Test-Path -LiteralPath $src){ Copy-Item -LiteralPath $src -Destination (Join-Path $Cart (Split-Path -Leaf $src)) -Force }
    }
  }
  #  i file prova che HANNO GIRATO, cosi' lo zip e' autosufficiente
  if(Test-Path -LiteralPath $Prove){
    foreach($f in @(Get-ChildItem -LiteralPath $Prove -File -ErrorAction SilentlyContinue)){
      Copy-Item -LiteralPath $f.FullName -Destination (Join-Path $Cart $f.Name) -Force
    }
  }
  if($Sosta -and (Test-Path -LiteralPath $Sosta)){
    foreach($f in @(Get-ChildItem -LiteralPath $Sosta -File -ErrorAction SilentlyContinue)){
      Copy-Item -LiteralPath $f.FullName -Destination (Join-Path $Cart $f.Name) -Force
    }
  }

  $R = New-Object System.Collections.ArrayList
  [void]$R.Add("REFERTO R107 - IL RICONTROLLO DEI LATI SHORT")
  [void]$R.Add("DOW (U30USD) - DAX (D30EUR) - NASDAQ (NASUSD), M5, TICK REALI")
  [void]$R.Add("modo: " + $Modo + $(if($SoloControllo){ "   <<< GIRO A VUOTO: NESSUNA passata, NESSUN CSV, NESSUN numero di round qui dentro" } else { "" }))
  $sw = @()
  if($SoloControllo){ $sw += "-SoloControllo (nessuna passata)" }
  if($CriteriFirmati){ $sw += "-CriteriFirmati (FIRMA IN RIGA di Claudio: il file dei criteri portava ancora [DA FIRMARE])" }
  if($SoloEa -ne ""){ $sw += "-SoloEa " + $SoloEa }
  if($SoloCella -ne ""){ $sw += "-SoloCella " + $SoloCella + " (la cella LONG della sua famiglia e' girata lo stesso: senza denominatore lo short non si legge)" }
  if($Rifai){ $sw += "-Rifai (i CSV precedenti sono stati rifatti)" }
  if($sw.Count -eq 0){ $sw += "nessuno (corsa piena, ripresa dei CSV gia' presenti ATTIVA)" }
  [void]$R.Add("switch di questo giro: " + ($sw -join " | "))
  [void]$R.Add("     Senza -Rifai il driver generico SALTA le finestre gia' presenti. I file saltati")
  [void]$R.Add("     sono marcati 'SALTATA DAL DRIVER' o 'A META'' e finiscono nei PROBLEMI, non in OK.")
  [void]$R.Add("stato dei criteri: " + $Firma)
  [void]$R.Add("data: " + (Get-Date).ToString("yyyy-MM-dd HH:mm:ss",$INV) + "   (questa data deve essere di ADESSO)")
  [void]$R.Add("     ATTENZIONE: la data fresca NON distingue un giro a vuoto da una corsa.")
  [void]$R.Add("     Quello che lo distingue e' la riga 'modo:' qui sopra e il NOME della cartella.")
  [void]$R.Add("avvio: " + $Avvio.ToString("yyyy-MM-dd HH:mm:ss",$INV) + "   durata: " + ((New-TimeSpan -Start $Avvio -End (Get-Date)).TotalHours).ToString("0.0",$INV) + " ore")
  [void]$R.Add("pin: " + $Pin)
  [void]$R.Add("criteri: risultati_archivio\R107_CRITERI.md   perimetro: R107_CODA_LATI_SHORT.md")
  [void]$R.Add("finestra: " + $DaQuando + " -> " + $Fino + "   split 40/60   modello " + $Modello + " (tick reali)   deposito " + $Deposito)
  [void]$R.Add("     IS  " + $IS_Da + " - " + $IS_A)
  [void]$R.Add("     OOS " + $OOS_Da + " - " + $OOS_A)
  [void]$R.Add("     (le stesse di R88, R97, R98 e R101: e' l'unico modo di confrontare i round alla pari)")
  [void]$R.Add("spread: Spread=" + $SpreadIni + " scritto NELL'INI = spread CORRENTE del feed BCM, dichiarato.")
  [void]$R.Add("     NON e' uno stress di spread e NON e' una misura dello spread.")
  [void]$R.Add("rischio: 1,00% nei file prova. IN CAMPO SUL 100K E' 0,65%.")
  [void]$R.Add("     >>> OGNI DD DI QUESTO REFERTO E' ALL'1%. Per confrontarlo col forward del")
  [void]$R.Add("     100k si MOLTIPLICA PER 0,65 (criteri par. 2.4). Chi salta la conversione")
  [void]$R.Add("     confronta due cose diverse.")
  [void]$R.Add("")
  [void]$R.Add("--- CONVENZIONE DI SENTINELLA (checklist 66) ---")
  [void]$R.Add("  Un numero NON MISURATO si scrive 'n/d'. MAI -1, MAI 0.000. Vale per TUTTE le")
  [void]$R.Add("  colonne: profitto, PF, DD, n e peggior giornata. Un '0.000' su un PF sarebbe un")
  [void]$R.Add("  numero PLAUSIBILE, e si leggerebbe 'ha perso tutto'.")
  [void]$R.Add("")
  [void]$R.Add("--- IL GATE G0: LA CELLA LONG SI RIPRODUCE? (criteri par. 5) ---")
  foreach($fam in $FamLavoro){
    [void]$R.Add("  " + $fam.Id + " (" + $fam.Ea + " / " + $fam.Sym + ", magic del sorgente " + $fam.MagicSrc + ")")
    if($fam.HaMetro){
      [void]$R.Add("     atteso agli atti : PF " + ([double]$fam.PfAtti).ToString("0.000",$INV) + " | DD " + ([double]$fam.DdAtti).ToString("0.00",$INV) + "% | n " + $fam.NAtti)
    } else {
      [void]$R.Add("     atteso agli atti : NESSUNO -- G0 NON APPLICABILE su questa famiglia.")
      [void]$R.Add("                        'Non applicabile' NON e' 'superato': qui non c'e' nessuna")
      [void]$R.Add("                        prova che il banco sia sano, e il round lo dichiara.")
    }
    [void]$R.Add("     misurato adesso  : PF " + (Fmt3 $fam.PfOOS) + " | DD " + (Fmt2 $fam.DdOOS) + "% | n " + (FmtN $fam.NOOS))
    [void]$R.Add("     gemelli          : " + $fam.Gemelli)
    [void]$R.Add("     VERDETTO G0      : " + $fam.Metro)
    [void]$R.Add("     fonte dei numeri : " + $fam.Fonte)
    [void]$R.Add("     CANARINO         : n IS " + (FmtN $fam.NIS) + " / n OOS " + (FmtN $fam.NOOS) + "   (NON e' un gate - Emendamento regola B)")
  }
  [void]$R.Add("  NOTA: 'NON MISURATO' NON e' 'va bene'. Un gate che non legge niente non e' un")
  [void]$R.Add("  gate verde. Se il metro non si riproduce, la cella short di QUELLA famiglia non")
  [void]$R.Add("  e' stata nemmeno lanciata -- e le altre famiglie sono andate avanti.")
  [void]$R.Add("")
  [void]$R.Add("--- IL GATE G0-BIS: IL DOW SHORT E' UNA RIPRODUZIONE DI R54 ---")
  [void]$R.Add("  cella  : " + $G0bisCella)
  [void]$R.Add("  atteso : PF " + $G0bisPf.ToString("0.000",$INV) + " | DD " + $G0bisDd.ToString("0.00",$INV) + "% | n " + $G0bisN)
  [void]$R.Add("  fonte  : " + $G0bisFonte)
  $cG0b = @($Ordinati | Where-Object { $_.Prova -eq $G0bisCella })
  if($cG0b.Count -eq 1){
    [void]$R.Add("  misurato adesso : PF " + (Fmt3 $cG0b[0].PfOOS) + " | DD " + (Fmt2 $cG0b[0].DdOOS) + "% | n " + (FmtN $cG0b[0].NOOS))
  } else {
    [void]$R.Add("  misurato adesso : NON ESEGUITA in questo giro (la cella non era nella lista dei lavori)")
  }
  [void]$R.Add("  >>> NON ferma il round, MA se non torna il banco e' SOSPETTO e anche le celle")
  [void]$R.Add("      DAX e NASUSD vanno lette con riserva. Il verdetto sta nei PROBLEMI o nei RILIEVI.")
  [void]$R.Add("")
  [void]$R.Add("--- LA TABELLA MADRE ---   (attese: " + $CelleAttese + " righe per CSV, " + (2*$Lavori.Count) + " CSV, " + (4*$Lavori.Count) + " passate)")
  [void]$R.Add("  IS e OOS accanto, perche' su un round sui LATI la differenza fra le due finestre")
  [void]$R.Add("  E' il risultato (vedi LA SPINA DORSALE in fondo). dPF e dDD sono il DELTA OOS")
  [void]$R.Add("  contro la cella LONG della stessa famiglia.")
  [void]$R.Add(("  {0,-4} {1,-11} {2,-9} {3,-7} {4,-7} {5,-6} {6,-9} {7,-7} {8,-7} {9,-6} {10,-8} {11,-7} {12,-8} {13}" -f `
                "FAM","CELLA","ISprof","ISpf","ISdd","ISn","OOSprof","OOSpf","OOSdd","OOSn","dPF","dDD%","PeggGio%","ESITO"))
  foreach($fam in $FamLavoro){
    foreach($c in @($Ordinati | Where-Object { $_.Fam -eq $fam.Id })){
      $dpf = "n/d"; $ddd = "n/d"
      if([double]$c.PfOOS -ge 0 -and [double]$fam.PfOOS -ge 0){ $dpf = ([double]$c.PfOOS - [double]$fam.PfOOS).ToString("+0.000;-0.000;0.000",$INV) }
      if([double]$c.DdOOS -ge 0 -and [double]$fam.DdOOS -ge 0){ $ddd = ([double]$c.DdOOS - [double]$fam.DdOOS).ToString("+0.00;-0.00;0.00",$INV) }
      [void]$R.Add(("  {0,-4} {1,-11} {2,-9} {3,-7} {4,-7} {5,-6} {6,-9} {7,-7} {8,-7} {9,-6} {10,-8} {11,-7} {12,-8} {13}" -f `
                    $c.Fam,$c.Id,(FmtE $c.ProfIS),(Fmt3 $c.PfIS),(Fmt2 $c.DdIS),(FmtN $c.NIS),
                    (FmtE $c.ProfOOS),(Fmt3 $c.PfOOS),(Fmt2 $c.DdOOS),(FmtN $c.NOOS),
                    $dpf,$ddd,(FmtPg $c.PgOOS),$c.Esito))
    }
  }
  [void]$R.Add("")
  [void]$R.Add("--- LE CELLE, COME SONO SCRITTE NEI FILE CHE HANNO GIRATO ---")
  foreach($c in $Ordinati){
    $dd2 = $(if(@($c.Diff).Count -eq 0){ "(niente: e' la cella LONG)" } else { ($c.Diff -join " + ") })
    $lati = "InpAllowLong=" + $c.Val["InpAllowLong"] + " / InpAllowShort=" + $c.Val["InpAllowShort"]
    [void]$R.Add(("  {0,-4} {1,-11} magic {2}/{3}   {4}   muove: {5}" -f $c.Fam,$c.Id,$c.Magic,($c.Magic+1),$lati,$dd2))
    [void]$R.Add("       " + $c.Desc)
  }
  [void]$R.Add("")
  [void]$R.Add("--- LA SPINA DORSALE: DOVE STANNO LE DISCESE (criteri par. 4.2) ---")
  [void]$R.Add("  FATTO DI CALENDARIO: la discesa documentata dentro questa finestra e' la")
  [void]$R.Add("  correzione di FEBBRAIO-APRILE 2025, e cade DENTRO L'IS (l'IS finisce il")
  [void]$R.Add("  " + $IS_A + "). L'OOS e' quasi tutto salita.")
  [void]$R.Add("  >>> COME SI LEGGE UNA SHORT VERDE IN IS E ROSSA IN OOS: la prima ipotesi NON e'")
  [void]$R.Add("      'il lato e' instabile', e' che L'EDGE DELLO SHORT VIVA NELLE DISCESE e che")
  [void]$R.Add("      l'IS ne contenga una mentre l'OOS quasi no. R54 chiamo' quel risultato")
  [void]$R.Add("      'il 28 ribaltamento' e lo lesse come rumore di regime: guardando il")
  [void]$R.Add("      calendario, la spiegazione piu' semplice e' un'altra.")
  [void]$R.Add("  >>> [INFERITO], E RESTA [INFERITO]: questo round NON misura i sotto-periodi.")
  [void]$R.Add("      Non sa quanto del profitto IS venga da febbraio-aprile, e NON sa se l'OOS")
  [void]$R.Add("      contenga discese di ampiezza paragonabile. Non lo assuma nessuno.")
  [void]$R.Add("      La misura vera e' un round di PROVA DI REGIME fatto apposta (decisione D3).")
  [void]$R.Add("")
  [void]$R.Add("--- QUELLO CHE QUESTO REFERTO NON DICE, DICHIARATO ---")
  [void]$R.Add("  * NON APPLICA I CANCELLI. G1 (n>=30), G2 (PF OOS >= 1,10 E positivo in IS),")
  [void]$R.Add("    G3 (coerenza cross-mercato) e G4 (campione) li applica il REFERTO DEL ROUND,")
  [void]$R.Add("    a mano, sopra questa tabella. Qui ci sono i numeri, non i verdetti.")
  [void]$R.Add("  * G3 in particolare NON e' meccanizzabile qui: e' il confronto fra TRE tabelle.")
  [void]$R.Add("    Ed e' il cancello che in R46 fermo' un candidato che faceva +31%.")
  [void]$R.Add("  * IL NASUSD E' UNA TRASPOSIZIONE, NON UNA SEDIA (criteri par. 2.3). buffer e")
  [void]$R.Add("    offset sono in PUNTI ASSOLUTI e i due indici non hanno la stessa scala:")
  [void]$R.Add("    1000 punti sono lo 0,023% su un Dow a ~44.000 e lo 0,05% su un Nasdaq a")
  [void]$R.Add("    ~20.000. >>> SE LE CELLE NASUSD ESCONO ROSSE, IL RISULTATO E' 'LA GEOMETRIA")
  [void]$R.Add("    DEL DOW NON SI TRASPORTA SUL NASDAQ', NON 'il Nasdaq non ha edge in")
  [void]$R.Add("    apertura'. Sono due frasi diverse e solo la prima e' misurata qui.")
  [void]$R.Add("  * IL DOW SHORT NON E' UNA MISURA NUOVA: e' una riproduzione di R54, che lo")
  [void]$R.Add("    aveva gia' BOCCIATO PER MERITO (PF OOS 0,840, n 73, quindi non per campione).")
  [void]$R.Add("    Da solo NON riapre la domanda sul Dow: serve da metro e da riga di paragone.")
  [void]$R.Add("  * LA MISURA NUOVA DEL ROUND E' IL DAX SHORT. Il registro (riga A3) la teneva")
  [void]$R.Add("    'in coda' da un anno, e per di piu' su una geometria diversa (rottura secca).")
  [void]$R.Add("  * NON PROMUOVE NIENTE (G5). Due delle tre sedie stanno sul conto 100k: un")
  [void]$R.Add("    cambio al forward e' una firma successiva, con il suo referto.")
  [void]$R.Add("  * NON misura lo spread, non misura i sotto-periodi, non fa la prova di regime.")
  [void]$R.Add("  * LA FINESTRA E' UN SOLO REGIME (21 mesi di indici che salgono) e IL LATO SHORT")
  [void]$R.Add("    PARTE SVANTAGGIATO PER REGIME. Un 'niente edge short' qui NON chiude la")
  [void]$R.Add("    domanda per sempre: la chiude PER QUESTA EPOCA.")
  [void]$R.Add("")
  if($Rilievi.Count -gt 0){
    [void]$R.Add("--- RILIEVI (NON sono guasti: sono RISULTATI del round) ---   (" + $Rilievi.Count + ")")
    foreach($n in $Rilievi){ [void]$R.Add("  - " + $n) }
    [void]$R.Add("")
  }
  [void]$R.Add("--- PROBLEMI (questi SI sono guasti) ---   (" + $Problemi.Count + ")")
  if($Problemi.Count -eq 0){ [void]$R.Add("  nessuno.") }
  foreach($p in $Problemi){ [void]$R.Add("  - " + $p) }
  if($Fatale -ne ""){
    [void]$R.Add("")
    [void]$R.Add("--- FERMATO ---")
    [void]$R.Add("  " + $Fatale)
  }
  [void]$R.Add("")
  # --- L'ESITO SCRITTO NEL REFERTO DICE LE STESSE PAROLE DELLO SCHERMO.
  #     E DISTINGUE 'PARZIALE' da 'COMPLETO CON RILIEVI' (classe 47, e il
  #     difetto pagato sul blocco 1 di R102: la frase diceva "PARZIALE --
  #     0 sedie su 3 non sono OK" su una corsa perfettamente riuscita).
  $koR = @($Ordinati | Where-Object { $_.Esito -ne "OK" -and $_.Esito -ne "SOLO CONTROLLO" })
  if($Fatale -ne ""){
    [void]$R.Add("ESITO: FERMATO -- " + $Fatale)
  }
  elseif($SoloControllo){
    if($koR.Count -gt 0 -or $Problemi.Count -gt 0){
      [void]$R.Add("ESITO: GIRO A VUOTO CON PROBLEMI (" + $Problemi.Count + ") -- NESSUNA passata. NON lanciare la corsa vera prima di aver letto i PROBLEMI.")
    } else {
      [void]$R.Add("ESITO: GIRO A VUOTO COMPLETATO -- NESSUNA passata, NESSUN CSV, NESSUN numero. QUESTO ZIP NON E' IL ROUND.")
    }
  }
  elseif($koR.Count -gt 0){
    [void]$R.Add("ESITO: PARZIALE -- " + $koR.Count + " celle su " + $Ordinati.Count + " NON hanno prodotto i numeri (elenco qui sopra), piu' " + $Problemi.Count + " problemi. NON e' un round completo.")
  }
  elseif($Problemi.Count -gt 0){
    [void]$R.Add("ESITO: COMPLETO CON PROBLEMI -- tutte e " + $Ordinati.Count + " le celle hanno prodotto i numeri attesi, ma ci sono " + $Problemi.Count + " problemi (fra cui puo' esserci G0-bis). I numeri ci sono: si leggono ACCANTO ai problemi, non invece dei problemi.")
  }
  elseif($Rilievi.Count -gt 0){
    [void]$R.Add("ESITO: COMPLETO CON RILIEVI -- tutte e " + $Ordinati.Count + " le celle hanno prodotto i numeri attesi. I " + $Rilievi.Count + " rilievi sono RISULTATI del round (canarino, G1 non misurabile, G0 non applicabile sul NAS), non guasti.")
  }
  else{
    [void]$R.Add("ESITO: OK -- tutte le celle hanno prodotto i numeri attesi, nessun problema e nessun rilievo in elenco.")
  }
  [void]$R.Add("")
  [void]$R.Add("--- COME SI RIPRENDE ---")
  [void]$R.Add('  una famiglia sola  : ... & $p -Pin <PIN> -CriteriFirmati -SoloEa ''DAX''')
  [void]$R.Add('  due famiglie       : ... & $p -Pin <PIN> -CriteriFirmati -SoloEa ''DOW,NAS''   <-- FRA APICI (checklist 65)')
  [void]$R.Add('  una cella sola     : ... & $p -Pin <PIN> -CriteriFirmati -SoloCella R107_DAX_01_short.txt')
  [void]$R.Add("  >>> in tutti i casi la cella LONG della famiglia rigira: e' il denominatore.")
  [void]$R.Add("      Costa 2 CSV, non una passata sprecata.")
  [void]$R.Add("  rifare cio' che c'e' gia' : aggiungi -Rifai")

  Set-Content -LiteralPath $Referto -Value ($R -join "`r`n") -Encoding UTF8
  if(Test-Path -LiteralPath $Zip){ Remove-Item -LiteralPath $Zip -Force -ErrorAction SilentlyContinue }
  Compress-Archive -Path (Join-Path $Cart "*") -DestinationPath $Zip -Force
}catch{
  Write-Host ("!!! RACCOLTA PARZIALE: " + $_.Exception.Message) -ForegroundColor Red
}

Write-Host ""
Write-Host "=====================================================================" -ForegroundColor White
Write-Host "  R107 - FINE" -ForegroundColor White
function Riga3([string]$path,[string]$coda){
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
  Write-Host ("  MODO: " + $Modo + " -- GIRO A VUOTO. NESSUNA passata, NESSUN CSV, NESSUN") -ForegroundColor Yellow
  Write-Host ("        numero di round. Anteprime .ini attese: " + $Ordinati.Count + ".") -ForegroundColor Yellow
  Write-Host  "        GATE G0 e G0-BIS: NON ESEGUITI, ed e' giusto cosi'. Si misurano nella CORSA VERA." -ForegroundColor Yellow
  Write-Host  "        QUESTO ZIP NON E' IL ROUND e non va mandato come risultato." -ForegroundColor Yellow
} else {
  Write-Host ("  MODO: " + $Modo) -ForegroundColor White
  Write-Host ("  ATTESI:  " + (2*$Lavori.Count) + " CSV (" + $Lavori.Count + " celle x IS/OOS), " + $CelleAttese + " righe l'uno, " + (4*$Lavori.Count) + " passate.") -ForegroundColor White
  foreach($fam in $FamLavoro){
    $col = if($fam.Metro -like "RIPRODOTTO*"){ "Green" } elseif($fam.Metro -like "NON APPLICABILE*"){ "Yellow" } else { "Red" }
    Write-Host ("  GATE G0 " + $fam.Id + ": " + $fam.Metro) -ForegroundColor $col
    Write-Host ("     CANARINO " + $fam.Id + ": n IS " + (FmtN $fam.NIS) + " / n OOS " + (FmtN $fam.NOOS) + "   (NON e' un gate: regola B)") -ForegroundColor White
  }
}
foreach($c in $Ordinati){
  $col = "Green"; if($c.Esito -ne "OK" -and $c.Esito -ne "SOLO CONTROLLO"){ $col = "Yellow" }
  Write-Host ("   " + ($c.Fam + " " + $c.Id).PadRight(20) + " " + $c.Esito) -ForegroundColor $col
}
if($Rilievi.Count -gt 0){
  Write-Host ""
  Write-Host "   RILIEVI (risultati del round, NON guasti):" -ForegroundColor Yellow
  foreach($n in $Rilievi){ Write-Host ("    - " + $n) -ForegroundColor Yellow }
}
if($Problemi.Count -gt 0){
  Write-Host ""
  Write-Host "   PROBLEMI DA LEGGERE:" -ForegroundColor Red
  foreach($p in $Problemi){ Write-Host ("    - " + $p) -ForegroundColor Red }
}
Write-Host ""
# =====================================================================
#  L'ESITO IN CONSOLE DICE LE STESSE PAROLE DEL REFERTO, o i due si
#  contraddicono: chi legge lo schermo e manda lo zip non ha visto il
#  referto.
#  >>> E OGNI RAMO FINISCE CON UN exit ESPLICITO. Senza, il codice di
#      uscita e' quello dell'ULTIMO comando eseguito e il blocco che si
#      incolla in chat (che guarda $LASTEXITCODE) puo' annunciare
#      "PARZIALE O FERMO" su un round perfetto.
#  >>> E GLI STATI SONO PIU' DI DUE (checklist 68): "COMPLETO CON
#      RILIEVI" e' un successo e esce 0. Un codice rosso su una corsa
#      riuscita e' esattamente la spia che nessuno guarda piu' la volta
#      che diventa vera (classe 47).
#      CODICI: 0 = OK / COMPLETO CON RILIEVI
#              1 = parziale, fermato, con problemi, o selettore a vuoto
#              2 = criteri non firmati
# =====================================================================
if($Fatale -ne ""){ Write-Host ("ESITO: FERMATO -- " + $Fatale) -ForegroundColor Red; exit 1 }
$ko = @($Ordinati | Where-Object { $_.Esito -ne "OK" -and $_.Esito -ne "SOLO CONTROLLO" })
if($SoloControllo){
  if($ko.Count -gt 0 -or $Problemi.Count -gt 0){
    Write-Host ("ESITO: GIRO A VUOTO CON PROBLEMI (" + $Problemi.Count + ") -- NESSUNA passata, e c'e' da leggere il referto") -ForegroundColor Yellow
    exit 1
  }
  Write-Host "ESITO: GIRO A VUOTO COMPLETATO -- NESSUNA passata, NESSUN CSV. QUESTO ZIP NON E' IL ROUND." -ForegroundColor Green
  exit 0
}
if($ko.Count -gt 0){
  Write-Host ("ESITO: PARZIALE (" + $ko.Count + " celle su " + $Ordinati.Count + " non hanno prodotto i numeri, " + $Problemi.Count + " problemi) -- lo zip esiste: mandalo") -ForegroundColor Yellow
  exit 1
}
if($Problemi.Count -gt 0){
  #  Tutte le celle hanno prodotto i numeri, ma c'e' almeno un guasto
  #  (puo' essere G0-bis, che e' apposta non fatale ma rumoroso).
  Write-Host ("ESITO: COMPLETO CON PROBLEMI (" + $Problemi.Count + ") -- i numeri ci sono TUTTI, ma vanno letti ACCANTO ai problemi. Lo zip esiste: mandalo.") -ForegroundColor Yellow
  exit 1
}
if($Rilievi.Count -gt 0){
  #  Solo rilievi dichiarativi (canarino, G1 non misurabile, G0 non
  #  applicabile sul NAS): NON e' un fallimento, e quindi NON esce 1.
  Write-Host ("ESITO: COMPLETO CON RILIEVI (" + $Rilievi.Count + " rilievi da leggere nel referto, nessuna cella mancante e nessun guasto)") -ForegroundColor Green
  exit 0
}
Write-Host "ESITO: OK" -ForegroundColor Green
exit 0
