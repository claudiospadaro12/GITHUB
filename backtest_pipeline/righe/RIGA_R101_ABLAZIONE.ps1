# =====================================================================
#  MARCATORE_RIGA_R101_v1
#  RIGA_R101_ABLAZIONE.ps1  --  R101: l'ABLAZIONE DEI FILTRI sulle due
#  sedie vive del conto 100k: ABTG_Dow_Apertura_US (U30USD M5) e
#  ABTG_DAX_Apertura_EU (D30EUR M5).
# ---------------------------------------------------------------------
#  CRITERI: backtest_pipeline\risultati_archivio\R101_CRITERI.md
#  PERIMETRO FIRMATO: risultati_archivio\R101_FIRMA_ABLAZIONE.md
#    (Claudio 23/08/2026: "SI AD ENTRAMBE, FIRMO L'ABLAZIONE SU DOW E DAX")
#
#  >>> CRITERI FIRMATI da Claudio il 23/08/2026: "FIRMO TUTTE E 6 CON LE
#      PROPOSTE, POI FACCIO I 2 CONTROLLI". Le sei decisioni del par. 10
#      sono chiuse con le proposte, a numeri non visti.
#      Da quel momento R101_CRITERI.md NON porta piu' la stringa del
#      lucchetto, quindi IL GATE DI QUESTO DRIVER SI APRE DA SOLO e
#      -CriteriFirmati NON SERVE PIU'. Resta nel codice come scialuppa:
#      se qualcuno riscrivesse quella stringa nel file dei criteri (anche
#      dentro una frase storica) il gate si richiuderebbe, e -CriteriFirmati
#      permette di superarlo DICHIARANDOLO nel referto.
#      Il gate non si toglie: il round tocca DUE SEDIE CHE STANNO SUI
#      SOLDI, e la regola di casa e' che i criteri si congelano PRIMA dei
#      numeri. Un driver che parte comunque rende la regola un ornamento.
#
#  >>> E UNA COSA CHE IL DRIVER NON PUO' CONTROLLARE, DETTA QUI: Claudio
#      ha firmato "POI FACCIO I 2 CONTROLLI". Sono le due verifiche sul
#      grafico del par. 10.1 dei criteri (Dow: InpMinStopPts 500,
#      InpSkipIfTight false, range min/max 0 - DAX: InpAllowShort 0).
#      IL LANCIO ASPETTA QUELLE. Se una non torna, la cella viva scritta
#      nei file prova NON e' la sedia viva e i 20 file vanno corretti
#      PRIMA. Nessuno script puo' leggere un grafico: lo fa Claudio.
#
#  DA DOVE NASCE, dichiarato: e' RIGA_R98_MOMENTUM_NASUSD.ps1
#  (MARCATORE_RIGA_R98_v1) adattata a DUE EA e VENTI file prova. Il
#  punto 9 della checklist dice che una riscrittura non puo' perdere le
#  funzioni di sicurezza del gemello: sono state riportate TUTTE, una per
#  una -- guardia MT5/MetaEditor chiusi, -Pin senza default, pin di
#  $EABranch DENTRO il driver generico, [Charts] MaxBars con gate sullo
#  stato finale, install di ABTG_PausaGuardian.mqh, diff dei file prova,
#  compilazione DIRETTA col verdetto LastWriteTime + backup datato +
#  ripristino del .mq5 se fallisce, SOSTA SVUOTATA A OGNI GIRO, sosta con
#  nome proprio PRIMA dei gate, funzioni e variabili della raccolta SOPRA
#  il try, MODO nel nome della cartella e nel referto, pulizia PER NOME e
#  MAI a wildcard, cultura INVARIANTE, \r? davanti a ogni $ multilinea,
#  raccolta SEMPRE.
#
#  ------------------------------------------------------------------
#  LE QUATTRO CORREZIONI RECENTI, APPLICATE QUI
#
#  (1) EXIT 0 FINALE, ESPLICITO. R98 finiva con Write-Host "ESITO: OK" e
#      NIENTE: senza un exit esplicito il codice di uscita e' quello
#      dell'ULTIMO comando eseguito, e il blocco che si incolla in chat
#      controlla $LASTEXITCODE. Un round perfetto poteva stampare
#      "ESITO: PARZIALE O FERMO". Qui ogni ramo termina con un exit
#      DICHIARATO, e i codici sono tre: 0 = tutto OK, 1 = parziale o
#      fermato, 2 = NON PARTITO PERCHE' I CRITERI NON SONO FIRMATI.
#
#  (2) RIPRESA PER-CELLA VERA. R98 aveva -SaltaPasso0, che salta i GATE:
#      e' una ripresa che costa la sicurezza. Qui ci sono -SoloEa (una
#      famiglia sola) e -SoloCella (una cella sola, per NOME DI FILE),
#      che NON toccano i gate: il PASSO 0 della famiglia che gira si rifa'
#      sempre, perche' e' la CELLA 00_viva -- cioe' il METRO -- e senza
#      metro i gradini di quella famiglia non si leggono.
#      >>> E QUI VA DETTA LA COSA CHE R100 AVEVA PROMESSO MALE: il PASSO 0
#          NON E' UNA PASSATA IN PIU'. E' la cella 00_viva, che deve
#          girare comunque. Riprendere una famiglia costa DUE CSV in
#          piu' (il metro), non una passata sprecata.
#
#  (3) IL PARSER LEGGE UN CSV, NON UN .htm -- e per una ragione MISURATA,
#      non per comodita'. Il bug di R99 (la parola "Bilancio" mancante nel
#      parser dei deal del report .htm) qui NON PUO' RIPETERSI, perche'
#      questo round non legge nessun .htm: i due EA delle aperture hanno
#      l'OPTFRAME ESTESO e scrivono TUTTO nel CSV di ottimizzazione.
#      VERIFICATO sugli artefatti veri il 23/08, intestazione letta:
#        Pass,Profit,Expected Payoff,Profit Factor,Recovery Factor,
#        Sharpe Ratio,Equity DD %,Trades,Peggior Giornata %,
#        Perdite Consecutive Max,Serie Perdente Peggiore,<tutti gli input>
#      Quindi n, PF, DD, profitto E la PEGGIOR GIORNATA escono da UN SOLO
#      artefatto, gia' in colonne. Le colonne si cercano PER NOME
#      nell'intestazione, MAI per posizione, e con il CONTROLLO POSITIVO
#      (checklist 55): se non riconosce le colonne torna VUOTO e chi
#      chiama scrive "NON MISURATA" -- non tira a indovinare.
#
#  (4) MAGIC SORGENTE contro MAGIC VIVO. I due .mq5 dichiarano
#      InpMagic = 770202 (Dow) e 770101 (DAX): sono i magic VIVI, e il
#      gate di versione controlla QUELLI nel sorgente. I file prova pero'
#      girano su magic VERGINI 7733xx / 7732xx, e il driver PRETENDE che
#      nessun file prova contenga un magic vivo. Le due cose non si
#      confondono: 'magic del sorgente' e' identita' del motore, 'magic
#      del file prova' e' l'etichetta degli ordini del tester.
#  ------------------------------------------------------------------
#
#  COSA FA, in ordine, e DA SOLA:
#    0. si rifiuta di partire se MT5 O MetaEditor sono aperti
#    0-bis. si rifiuta di CORRERE se i criteri non sono firmati
#    1. scarica AL PIN: walkforward_generico.ps1, i 20 file prova, i DUE
#       sorgenti .mq5 e l'include ABTG_PausaGuardian.mqh
#       - GATE DI VERSIONE sui .mq5 (marcatori presi DAL SORGENTE)
#       - GATE DELLA STELLA: ogni cella deve differire dalla sua 00_viva
#         ESATTAMENTE sugli input dichiarati, e su nessun altro
#       - GATE DEI VALORI: la geometria viva riga per riga, nel file
#       - GATE DEI MAGIC: unici, vergini, mai un magic vivo
#    2. FASE COMPILA, un EA alla volta, invocazione DIRETTA di
#       metaeditor64.exe, verdetto sul LastWriteTime del .ex5
#    3. PASSO 0 PER FAMIGLIA = la cella 00_viva. Da li' escono:
#         (a) G0 IGIENE GEMELLI: le due righe identiche al centesimo
#         (b) G0 RIPRODUZIONE DEL METRO: PF/DD/n OOS contro i numeri
#             agli atti (R54 per il Dow, R46 per il DAX)
#         (c) IL CANARINO: n IS e n OOS della cella viva. NON BLOCCA
#             (Emendamento regola B: il campione sottile sospende il
#             MERITO, mai il RISCHIO)
#       Se (a) o (b) falliscono la FAMIGLIA si ferma -- e l'ALTRA va
#       avanti (stessa scelta di R100: una sedia storta non porta via
#       anche l'altra).
#    4. la catena dei gradini, UNO ALLA VOLTA (una macchina, un lavoro)
#    5. raccolta SEMPRE: cartella sul Desktop + zip + REFERTO con LA
#       TABELLA MADRE (gradino | n | PF | DD | peggior giornata | delta
#       contro la viva), coi numeri attesi dichiarati PRIMA.
#
#  QUELLO CHE NON FA, dichiarato:
#    - NON GIUDICA. Produce i CSV, li conta, e mette a referto i delta
#      contro la cella viva. I cancelli G1-G5 li applica il REFERTO del
#      round, non questa riga. In particolare NON applica G3 (coerenza
#      cross-mercato): quello e' un ragionamento su due tabelle, non un
#      confronto meccanico.
#    - non tocca nessuna sedia viva: magic VERGINI 7732xx/7733xx
#      (blocco verificato libero in tutto il repo il 23/08). Sono vietati
#      e controllati nel codice i magic vivi 770101 e 770202, piu' quelli
#      delle sedie confinanti.
#    - non scarica i TICK e non svuota bases\<server>\ticks. Sono gia'
#      MISURATI e agli atti per U30USD e D30EUR dal 2024.09.26.
#    - non misura lo spread e non inventa nessun numero non letto in un
#      artefatto.
#    - non scrive una riga di MQL5 e non tocca il forward.
#    - non ammazza un lavoro in corso allo scadere di -OreMax: smette
#      solo di iniziarne di nuovi (checklist 19)
#
#  QUANTO CI METTE: [STIMA], non una previsione. 20 file x 2 finestre x
#  2 celle gemelle = 80 passate a tick reali su meta' finestra l'una.
#  Il PASSO 0 MISURA la prima cella e stampa il tetto teorico. -OreMax e'
#  12 (tetto sull'INIZIO di nuovi file), con margine largo apposta.
#
#  LA RIGA CHE SI INCOLLA (blocco INTERO, un comando solo - checklist 21).
#  <PIN> = il commit che contiene QUESTO file: e' l'hash dato in chat.
#
#  & { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
#      if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
#      $pin='<PIN>'; $p="$env:USERPROFILE\RIGA_R101.ps1"; Remove-Item $p -EA SilentlyContinue;
#      irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_R101_ABLAZIONE.ps1" -OutFile $p;
#      if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_R101_v1' -Quiet)){ throw 'SCRIPT VECCHIO' };
#      $global:LASTEXITCODE=0; & $p -Pin $pin -SoloControllo; if($LASTEXITCODE -ne 0){ Write-Host 'ESITO: PARZIALE O FERMO - leggi il REFERTO' } }
#
#  GIRO A VUOTO: e' quello qui sopra (-SoloControllo). Scrive e verifica
#  GLI STESSI .ini che girano nella corsa vera. Non c'e' un secondo
#  artefatto (checklist 33).
#  >>> E NON MISURA NESSUN NUMERO: senza tester non esiste nessun n,
#      nessun PF, nessun DD, nessun canarino. Sta scritto anche nel suo
#      referto, perche' non lo si scambi per il round.
# =====================================================================
param(
  # -Pin NON ha default: un default silenzioso ("lavoro") farebbe girare la
  #  punta del branch spacciandola per un commit congelato. Meglio morire.
  [string]$Pin        = "",
  [double]$OreMax     = 12.0,      # oltre questo NON si iniziano nuovi file
  [switch]$Rifai,                  # rifa' anche i CSV gia' presenti
  [switch]$SoloControllo,          # giro a vuoto: NON apre MT5
  [switch]$CriteriFirmati,         # >>> lo preme CLAUDIO, non l'agente. Senza,
                                   #     la corsa vera non parte (exit 2).
  [string]$SoloEa     = "",        # "DOW" oppure "DAX": una famiglia sola
  [string]$SoloCella  = ""         # es. "R101_DOW_03_atr.txt": una cella sola
                                   #     (il METRO della sua famiglia gira lo
                                   #      stesso: senza metro non si legge)
)
$ErrorActionPreference = "Stop"
[Threading.Thread]::CurrentThread.CurrentCulture   = [Globalization.CultureInfo]::InvariantCulture
[Threading.Thread]::CurrentThread.CurrentUICulture = [Globalization.CultureInfo]::InvariantCulture
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$INV = [Globalization.CultureInfo]::InvariantCulture

$Avvio  = Get-Date
$Stamp  = $Avvio.ToString("yyyyMMdd_HHmm", $INV)
$Dsk    = Join-Path $env:USERPROFILE "Desktop"
$Work   = Join-Path $env:USERPROFILE "abtg_r101"
$Prove  = Join-Path $Work "prove"
$Logs   = Join-Path $Work "log_r101"
$SrcDir = Join-Path $Work "src_motori"
$RawPin = "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$Pin"

#--- LA FINESTRA. Identica a R88/R97/R98: e' l'unico modo di confrontare
#    i round alla pari. Criteri R101 par. 4.
$DaQuando = "2024.09.26"      # muro del feed BCM sugli indici, MISURATO
$Fino     = "2026.06.30"
$Periodo  = "M5"
$Modello  = 4                 # 4 = TICK REALI. Gli indici hanno solo questo
                              #  storico e il round giudica il MERITO: un OHLC
                              #  non sarebbe confrontabile con R46/R54.
$Deposito = 100000            # taglia prop, come R46/R54
$SpreadIni= 0                 # 0 = spread CORRENTE, ma SCRITTO nell'ini invece
                              #  che lasciato allo stato nascosto del terminale.
                              #  NON e' uno stress e NON e' una misura.
$FrazioneIS  = 0.40           # default di walkforward_generico.ps1
$CelleAttese = 2              # le due passate GEMELLE di controllo, per CSV

#--- I MAGIC VIETATI: i due VIVI del round, le sedie confinanti sugli
#    stessi simboli, e i blocchi gia' usati dai round recenti. Un magic
#    vivo dentro un .ini non cambia il comportamento dell'EA, ma e'
#    comunque da fermare: il tester non deve poter incrociare il forward.
$MagicVietati = @(770101,770202,   # <<< LE DUE SEDIE DI QUESTO ROUND
                  770201,          # Nasdaq Apertura (spenta, resta spenta)
                  770611,770601,   # ORB Dow VIVO / ORB corso
                  770411,770901,   # MaxMin DAX / STReversal Nikkei
                  772601,772602,772611,772612,   # R54
                  772800,772890,772891)          # R98

#--- IL LIMITE DEL GATE SULLA PRIMA OPERAZIONE. La finestra parte dal
#    2024.09.26; un motore che opera UNA VOLTA AL GIORNO deve aver
#    tradato entro i primi tre mesi. Stesso limite di R97/R98.
$LimiteG2 = "2024.12.31"

# =====================================================================
#  LE DUE FAMIGLIE. Ogni riga e' un EA, con la sua cella viva, i suoi
#  numeri AGLI ATTI (il metro di G0) e le sue righe vive attese.
#
#  >>> DA DOVE VIENE OGNI COLONNA (criteri R101 par. 2):
#      - Ea / Ver / MagicSrc : LETTI NEL SORGENTE al pin
#      - PfAtti / DdAtti / NAtti : MISURATI e agli atti, referto citato
#      - RigheVive : MISURATE sui file prova il 23/08 con
#        `grep -cvE '^\s*(#|$)'`, NON scritte a memoria (checklist 40-bis)
#      - Ora* : ORA SERVER. Server BCM = ora italiana - 1, e per gli
#        indici e' MISURATO sugli orologi del corso (4DOC par. 2.2).
# =====================================================================
function F($id,$ea,$ver,$sym,$magicSrc,$righe,$oraH,$oraM,$pf,$dd,$n,$fonte){
  return [pscustomobject]@{
    Id=$id; Ea=$ea; Ver=$ver; Sym=$sym; MagicSrc=$magicSrc; RigheVive=$righe;
    OraH=$oraH; OraM=$oraM; PfAtti=$pf; DdAtti=$dd; NAtti=$n; Fonte=$fonte;
    # --- riempiti durante la corsa
    Compilato=$false; Metro="NON MISURATO"; Gemelli="NON MISURATO";
    NIS=-1; NOOS=-1; PfOOS=-1.0; DdOOS=-1.0; ProfOOS=0.0;
    Esito="NON ESEGUITA"
  }
}
#  PfAtti/DdAtti/NAtti sono i numeri OOS della cella VIVA.
#   DOW : REFERTO_ROUND54_LATI_DOW.md par. 1, riga "solo LONG" ->
#         +6.721,93 | PF 1,27013 | DD 4,3941% | n 130. Lo stesso referto
#         certifica che riproduce R46 riga "A = LIVE" (+6.722 | 1,27 | 4,39).
#   DAX : REFERTO_ROUND46_GESTIONE.md, riga "A = LIVE" -> +18.030 | PF 1,40
#         | DD 7,23%. >>> Il n del DAX NON E' AGLI ATTI riga per riga: si
#         mette -1 = NON DICHIARATO, e il gate sul n NON si applica al DAX.
#         Inventare un "circa 270" e usarlo come gate sarebbe il difetto
#         peggiore possibile in un round di riproduzione.
$FAMIGLIE = @(
  (F "DOW" "ABTG_Dow_Apertura_US" "1.01" "U30USD" "770202" 74 "14" "30" 1.27013 4.3941 130 "REFERTO_ROUND54_LATI_DOW.md par.1 (riga solo LONG) + REFERTO_ROUND46_GESTIONE.md (riga A = LIVE)"),
  (F "DAX" "ABTG_DAX_Apertura_EU" "1.01" "D30EUR" "770101" 75 "8"  "0"  1.40    7.23   -1  "REFERTO_ROUND46_GESTIONE.md (riga A = LIVE). Il n per finestra NON e' agli atti: lo misura questa corsa")
)

# =====================================================================
#  LE VENTI CELLE. 'Diff' = gli input che DEVONO differire dalla
#  00_viva della stessa famiglia, e NESSUN ALTRO. E' il gate della
#  STELLA: contare "1 riga diversa" non basterebbe, perche' UNA riga
#  SBAGLIATA darebbe lo stesso conteggio e il round misurerebbe
#  un'altra cosa (checklist 33 e 40-bis).
#  'Val' = il valore che quell'input deve avere IN QUESTO FILE: il diff
#  dice CHE cambia, questo dice CHE COSA vale. Se due celle fossero
#  scambiate, il diff resterebbe verde e questo no (checklist 34-bis).
# =====================================================================
function C($fam,$id,$file,$desc,$magic,$diff,$val,$metro){
  return [pscustomobject]@{ Fam=$fam; Id=$id; Prova=$file; Desc=$desc; Magic=$magic;
                            Diff=@($diff); Val=$val; Metro=$metro;
                            Esito="NON ESEGUITO"; IS=-1; OOS=-1; Min=0.0;
                            PfOOS=-1.0; DdOOS=-1.0; ProfOOS=0.0; NOOS=-1; PgOOS=99.9;
                            Gemelli="NON MISURATO" }
}
$CELLE = @()
foreach($f in @(@("DOW",773300),@("DAX",773200))){
  $fam = $f[0]; $b = [int]$f[1]
  #  il valore dell'EMA e' l'unico ASIMMETRICO fra le due famiglie: sul Dow
  #  il filtro e' ACCESO e si TOGLIE (1->0), sul DAX e' SPENTO e si METTE
  #  (0->1). Criteri par. 3.1. G3 (coerenza cross-mercato) NON si applica
  #  a questo gradino, e il referto lo deve dire.
  $emaVal = if($fam -eq "DOW"){ "0" } else { "1" }
  $emaTxt = if($fam -eq "DOW"){ "- EMA H4 (si TOGLIE: e' l'unico filtro acceso del Dow)" } else { "+ EMA 14/200 H1 (si METTE: sul DAX e' spento)" }
  $CELLE += (C $fam "00_viva"         ("R101_" + $fam + "_00_viva.txt")         "LA CELLA VIVA -- il METRO, non un candidato" ($b+0)  @()                                          @{}                                                    $true)
  $CELLE += (C $fam "01_ema"          ("R101_" + $fam + "_01_ema.txt")          $emaTxt                                      ($b+10) @("InpUseEmaFilter")                          @{"InpUseEmaFilter"=$emaVal}                            $false)
  $CELLE += (C $fam "02_volumi"       ("R101_" + $fam + "_02_volumi.txt")       "+ VOLUMI >= 1,5x media(20)  [corso]"        ($b+20) @("InpUseVolumeFilter")                       @{"InpUseVolumeFilter"="1"}                             $false)
  $CELLE += (C $fam "03_atr"          ("R101_" + $fam + "_03_atr.txt")          "+ ATR >= 1,0x media(20)  [corso]"           ($b+30) @("InpUseAtrFilter")                          @{"InpUseAtrFilter"="1"}                                $false)
  $CELLE += (C $fam "04_corso_or"     ("R101_" + $fam + "_04_corso_or.txt")     "+ VOLUMI **O** ATR  [corso, COMBINATA]"     ($b+40) @("InpUseVolumeFilter","InpUseAtrFilter")     @{"InpUseVolumeFilter"="1";"InpUseAtrFilter"="1";"InpConfirmMode"="0"} $false)
  $CELLE += (C $fam "05_supertrend3"  ("R101_" + $fam + "_05_supertrend3.txt")  "+ TRE SUPERTREND concordi  [corso EU]"      ($b+50) @("InpUseSupertrend3")                        @{"InpUseSupertrend3"="1"}                              $false)
  $CELLE += (C $fam "06_correlazione" ("R101_" + $fam + "_06_correlazione.txt") "+ CORRELAZIONE SPXUSD  [corso]"             ($b+60) @("InpUseCorrelation")                        @{"InpUseCorrelation"="1"}                              $false)
  $CELLE += (C $fam "07_vwap"         ("R101_" + $fam + "_07_vwap.txt")         "+ VWAP di sessione M15  [Emiliano, NON corso]" ($b+70) @("InpUseVwapFilter")                      @{"InpUseVwapFilter"="1"}                               $false)
  $CELLE += (C $fam "08_tondi"        ("R101_" + $fam + "_08_tondi.txt")        "+ NUMERI TONDI come 1o obiettivo  [corso]"  ($b+80) @("InpUseRoundLevels")                        @{"InpUseRoundLevels"="1"}                              $false)
  #  --- IL GRADINO 9: decisione 4 dei criteri, FIRMATA SI' il 23/08.
  #      E' L'UNICA CELLA CUMULATIVA DEL ROUND, ed e' dichiarato: muove
  #      QUATTRO interruttori, non uno. Non attribuisce niente a nessun
  #      filtro (quello lo fanno 02/03/05/06): risponde a "e tutti
  #      insieme?", che e' la CHECKLIST del corso [PDF PAG 29-30] e il
  #      debito del 18/08. Si legge SOLO accanto ai gradini singoli.
  #      InpConfirmMode resta 0 = OR, come nel gradino 04 e come nel PDF.
  $CELLE += (C $fam "09_corso_pieno"   ("R101_" + $fam + "_09_corso_pieno.txt")  "+ IL CORSO PIENO: volumi+ATR+ST3+correlazione INSIEME  [corso, CUMULATIVA]" ($b+90) @("InpUseVolumeFilter","InpUseAtrFilter","InpUseSupertrend3","InpUseCorrelation") @{"InpUseVolumeFilter"="1";"InpUseAtrFilter"="1";"InpUseSupertrend3"="1";"InpUseCorrelation"="1";"InpConfirmMode"="0"} $false)
}

#--- LA GEOMETRIA VIVA, PRETESA RIGA PER RIGA IN OGNI FILE della famiglia.
#    Non e' ridondanza col gate della stella: la stella garantisce che i
#    file siano UGUALI FRA LORO, questo garantisce che siano uguali ALLA
#    SEDIA VIVA. Due file identici e sbagliati passerebbero la stella.
#    Fonti: criteri par. 2.2 / 2.3, e gli artefatti citati li' dentro.
$VIVA = @{
 "DOW" = @(@("InpSessionHour","14"),@("InpSessionMin","30"),@("InpRangeMinutes","35"),
           @("InpEntryMode","2"),@("InpRangeMode","0"),@("InpBufferPoints","1000"),
           @("InpRetestOffsetPts","400"),@("InpAllowLong","1"),@("InpAllowShort","0"),
           @("InpSLMode","0"),@("InpTP1_R","1.0"),@("InpTP1_ClosePct","50"),
           @("InpBreakevenAtTP1","1"),@("InpUseTrailing","1"),@("InpTrailMode","1"),
           @("InpTrailTF","5"),@("InpTrailStartR","0"),@("InpBEatR","0"),
           @("InpMinStopPts","500"),@("InpSkipIfTight","0"),
           @("InpOneTradePerDay","1"),@("InpCloseHour","17"),@("InpCloseMin","30"),
           @("InpRiskPercent","1.0"),@("InpSlippagePts","0"))
 "DAX" = @(@("InpSessionHour","8"),@("InpSessionMin","0"),@("InpRangeMinutes","35"),
           @("InpEntryMode","2"),@("InpRangeMode","0"),@("InpBufferPoints","500"),
           @("InpRetestOffsetPts","200"),@("InpAllowLong","1"),@("InpAllowShort","0"),
           @("InpSLMode","0"),@("InpTP1_R","1.0"),@("InpTP1_ClosePct","50"),
           @("InpBreakevenAtTP1","1"),@("InpUseTrailing","1"),@("InpTrailMode","1"),
           @("InpTrailTF","5"),@("InpTrailStartR","0"),@("InpBEatR","0"),
           @("InpMinStopPts","0"),@("InpSkipIfTight","1"),@("InpAllowReverse","0"),
           @("InpOneTradePerDay","1"),@("InpCloseHour","17"),@("InpCloseMin","30"),
           @("InpRiskPercent","1.0"),@("InpSlippagePts","0"))
}

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
$Note      = New-Object System.Collections.ArrayList
$Fatale    = ""
$nAnt      = -1
$Firma     = "NON LETTA"
$Terminal  = ""; $MetaEditor = ""; $DataFolder = ""
$Ordinati  = @()      # checklist 41-bis: la raccolta lo scorre SEMPRE
$Vive      = @{}
$FamFerme  = @()

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

function RigheVive($p){
  return @(Get-Content -LiteralPath $p | Where-Object { $_ -notmatch '^\s*#' -and $_ -notmatch '^\s*$' })
}
function NomeDi($riga){
  if($riga -match '^@'){ return ($riga -split '\s+')[0] }
  return (($riga -split '=')[0]).Trim()
}
function CsvDi($c,$tag){
  $fam = @($FAMIGLIE | Where-Object { $_.Id -eq $c.Fam })[0]
  #  A Modello 4 il driver generico NON aggiunge il suffisso "_ohlc": lo
  #  aggiunge solo ai modelli diversi da 4 (cercare '$Suffisso =' in
  #  walkforward_generico.ps1).
  return (Join-Path $Risultati ($fam.Ea + "\" + $fam.Ea + "_" + $fam.Sym + "_" + $tag + "_" + $c.Id + ".csv"))
}
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
#  L'intestazione VERA e' MISURATA sugli artefatti di questi due EA il
#  23/08 (OPTFRAME esteso):
#    Pass,Profit,Expected Payoff,Profit Factor,Recovery Factor,
#    Sharpe Ratio,Equity DD %,Trades,Peggior Giornata %,...
# =====================================================================
$script:CsvIntestazioni = @()
function LeggiOpt($path){
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
    if($ch[1] -eq $null -or $ch[2] -eq $null){ return ("NON MISURATO (" + $ch[0] + " illeggibile)") }
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
# =====================================================================
$Lavori = @($CELLE)
if($SoloEa -ne ""){
  $se = $SoloEa.ToUpper()
  if(@($FAMIGLIE | Where-Object { $_.Id -eq $se }).Count -eq 0){
    Write-Host ("!!! -SoloEa " + $SoloEa + " non esiste. Validi: DOW, DAX") -ForegroundColor Red; exit 1
  }
  $Lavori = @($Lavori | Where-Object { $_.Fam -eq $se })
}
if($SoloCella -ne ""){
  $sc = @($Lavori | Where-Object { $_.Prova -eq $SoloCella })
  if($sc.Count -eq 0){
    Write-Host ("!!! -SoloCella " + $SoloCella + " non e' nella lista. Nomi validi:") -ForegroundColor Red
    foreach($c in $CELLE){ Write-Host ("      " + $c.Prova) -ForegroundColor Yellow }
    exit 1
  }
  #  >>> IL METRO DELLA SUA FAMIGLIA GIRA LO STESSO. E' la ripresa "vera":
  #      senza la cella viva i delta non esistono e il gradino non si legge.
  $fam = $sc[0].Fam
  $Lavori = @($Lavori | Where-Object { $_.Prova -eq $SoloCella -or ($_.Fam -eq $fam -and $_.Metro) })
}
$FamAttive = @($Lavori | ForEach-Object { $_.Fam } | Sort-Object -Unique)
$FamLavoro = @($FAMIGLIE | Where-Object { $FamAttive -contains $_.Id })

Write-Host ""
Write-Host "#####################################################################" -ForegroundColor Cyan
Write-Host "#  R101 - L'ABLAZIONE DEI FILTRI SU DOW E DAX                       #" -ForegroundColor Cyan
Write-Host "#  U30USD + D30EUR, M5, TICK REALI, 2024.09.26 -> 2026.06.30        #" -ForegroundColor Cyan
Write-Host "#####################################################################" -ForegroundColor Cyan
Dico ("pin      : " + $Pin)
Dico ("cartella : " + $Work)

Titolo "NUMERI ATTESI (dichiarati PRIMA della corsa)"
Write-Host ("    famiglie .....................  " + $FamLavoro.Count + "   (" + ($FamAttive -join ", ") + ")") -ForegroundColor White
Write-Host ("    celle ........................  " + $Lavori.Count + "   (di cui METRO: " + @($Lavori | Where-Object { $_.Metro }).Count + ")") -ForegroundColor White
Write-Host ("    CSV attesi ...................  " + (2*$Lavori.Count) + "   (IS + OOS per cella)") -ForegroundColor White
Write-Host ("    righe per CSV ................  " + $CelleAttese + "   (le due gemelle di controllo)") -ForegroundColor White
Write-Host ("    passate ......................  " + (4*$Lavori.Count)) -ForegroundColor White
Write-Host ("    IS  " + $IS_Da + " -> " + $IS_A) -ForegroundColor White
Write-Host ("    OOS " + $OOS_Da + " -> " + $OOS_A) -ForegroundColor White
Write-Host ""
Write-Host  "    IL GATE G0 (criteri par. 5): la cella 00_viva deve RIPRODURRE i" -ForegroundColor Yellow
Write-Host  "    numeri agli atti della sedia viva. Se non li riproduce, la FAMIGLIA" -ForegroundColor Yellow
Write-Host  "    si ferma -- e l'altra va avanti. Un metro sbagliato non e' un round" -ForegroundColor Yellow
Write-Host  "    con un difetto: e' un round che misura un altro motore." -ForegroundColor Yellow
Write-Host ""
Write-Host  "    IL CANARINO (par. 5, G4) NON E' UN GATE: n OOS del Dow e' 130," -ForegroundColor Yellow
Write-Host  "    sotto i 150 dell'Emendamento regola A. La corsa SEGNALA e prosegue" -ForegroundColor Yellow
Write-Host  "    (regola B: il campione sottile sospende il MERITO, mai il RISCHIO)." -ForegroundColor Yellow
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
#  Il perimetro e' firmato; i criteri di dettaglio no. Questo passo
#  scarica R101_CRITERI.md al pin e guarda se porta ancora "[DA FIRMARE]"
#  nel titolo. Se si':
#    - -SoloControllo prosegue (il giro a vuoto non apre MT5, non produce
#      numeri e serve proprio a far leggere i criteri prima di firmarli);
#    - la CORSA VERA si ferma con exit 2, a meno che Claudio non passi
#      -CriteriFirmati, che e' la sua firma esplicita in riga.
#  Non e' burocrazia: il round tocca due sedie che stanno sui soldi.
# =====================================================================
Titolo "0-BIS. LA FIRMA DEI CRITERI"
$critFile = Join-Path $Work "R101_CRITERI.md"
try{
  Scarica ("$RawPin/backtest_pipeline/risultati_archivio/R101_CRITERI.md") $critFile 'R101'
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
  Write-Host "#  NON PARTO: I CRITERI DI R101 NON SONO FIRMATI.                   #" -ForegroundColor Red
  Write-Host "#####################################################################" -ForegroundColor Red
  Write-Host "  R101_CRITERI.md porta ancora [DA FIRMARE]. Il perimetro e' firmato," -ForegroundColor Yellow
  Write-Host "  i criteri di dettaglio no -- e sono SEI decisioni (par. 10), fra cui" -ForegroundColor Yellow
  Write-Host "  quale cancello di merito si usa e se il MERITO sul Dow e' sospeso." -ForegroundColor Yellow
  Write-Host "" -ForegroundColor Yellow
  Write-Host "  COSA PUOI FARE ADESSO, in ordine:" -ForegroundColor Yellow
  Write-Host "   1. il GIRO A VUOTO gira lo stesso: rilancia con -SoloControllo." -ForegroundColor Yellow
  Write-Host "      Non apre MT5, non produce nessun numero, e verifica tutti i file." -ForegroundColor Yellow
  Write-Host "   2. leggi R101_CRITERI.md par. 10 e rispondi alle sei decisioni." -ForegroundColor Yellow
  Write-Host "   3. quando hai firmato: si toglie il [DA FIRMARE] dal file, oppure" -ForegroundColor Yellow
  Write-Host "      si rilancia questa riga aggiungendo  -CriteriFirmati" -ForegroundColor Yellow
  Write-Host ""
  exit 2
}
if($daFirmare -and $CriteriFirmati){
  [void]$Note.Add("I criteri portano ancora [DA FIRMARE] nel file, ma la corsa e' partita con -CriteriFirmati: la firma e' quella data in riga da Claudio. VA SCRITTO NEL REFERTO DEL ROUND.")
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
#     un round che confronta 20 file fra loro, un push a meta' corsa
#     cambierebbe il motore fra un file e l'altro e il confronto non
#     misurerebbe piu' niente.
$dTxt = Get-Content -LiteralPath $Driver -Raw
$dNew = $dTxt -replace '\$EABranch\s*=\s*"lavoro"', ('$EABranch="' + $Pin + '"')
if($dNew -eq $dTxt){ throw "non sono riuscito a pinnare EABranch nel driver generico: riga non trovata" }

# --- 1b. IL TETTO DELLE BARRE. Se il tester ereditasse il tetto "Max barre
#     nel grafico" del terminale, le serie verrebbero TRONCATE IN SILENZIO
#     (checklist 36) e i CSV uscirebbero pieni di numeri coerenti e falsi.
#     Qui morde: gli EA delle aperture leggono barre M1 per costruire il
#     range, su 21 mesi.
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
  if($rv.Count -ne $fam.RigheVive){
    throw ($c.Prova + " ha " + $rv.Count + " righe vive invece di " + $fam.RigheVive + ": artefatto cambiato, mi fermo.")
  }
  $Vive[$c.Prova] = $rv
}
Dico ($Lavori.Count.ToString() + " file prova scaricati al pin, righe vive verificate (DOW 74 / DAX 75)") "Green"

# --- 1d. IL GATE DELLA STELLA. Ogni cella si confronta con la 00_viva
#     DELLA SUA FAMIGLIA -- che e' il riferimento di TUTTE (criteri par. 1).
#     Non basta contare le righe diverse: si pretende QUALI righe, e SOLO
#     quelle. Due righe sbagliate darebbero lo stesso conteggio e il round
#     misurerebbe due cose insieme.
#     >>> Il confronto e' POSIZIONALE e regge perche' i file sono generati
#         con lo stesso ordine di input: se le righe vive sono in ordine
#         diverso il gate se ne accorge (esce un diff enorme), e in quel
#         caso ci si ferma -- come deve.
foreach($fam in $FamLavoro){
  $rif = @($Lavori | Where-Object { $_.Fam -eq $fam.Id -and $_.Metro })
  if($rif.Count -ne 1){ throw ("famiglia " + $fam.Id + ": trovate " + $rif.Count + " celle METRO invece di 1. Senza metro i gradini non hanno denominatore.") }
  $a = $Vive[$rif[0].Prova]
  foreach($c in @($Lavori | Where-Object { $_.Fam -eq $fam.Id -and -not $_.Metro })){
    $b = $Vive[$c.Prova]
    if($a.Count -ne $b.Count){ throw ($c.Prova + ": " + $b.Count + " righe vive contro " + $a.Count + " della cella viva. Non sono confrontabili.") }
    $d = New-Object System.Collections.ArrayList
    for($i=0;$i -lt $a.Count;$i++){ if($a[$i] -ne $b[$i]){ [void]$d.Add((NomeDi $a[$i])) } }
    #  InpMagic differisce SEMPRE ed e' voluto: e' l'asse gemello.
    $attese = @($c.Diff) + @("InpMagic")
    $manca  = @($attese | Where-Object { $d -notcontains $_ })
    $extra  = @($d      | Where-Object { $attese -notcontains $_ })
    if($manca.Count -gt 0 -or $extra.Count -gt 0){
      throw ($c.Prova + " contro " + $rif[0].Prova + ": differiscono su [" + ($d -join ", ") +
             "] invece che su [" + ($attese -join ", ") + "]. L'ablazione a STELLA pretende UN interruttore solo (piu' il magic): cosi' il numero non sarebbe attribuibile a nessun filtro.")
    }
  }
}
Dico "gate della STELLA: ogni gradino differisce dalla sua cella viva SOLO dove deve" "Green"

# --- 1e. I VALORI, letti NELL'ARTEFATTO CHE GIRA (checklist 34-bis).
#     Il diff dice CHE cambiano; questo dice CHE COSA valgono: se due celle
#     fossero scambiate, il diff resterebbe verde.
#     >>> OGNI $ DI UNA REGEX MULTILINEA SI SCRIVE \r?$ (checklist 40): i
#         file arrivano da GitHub con CRLF, e senza \r? il match non
#         avviene MAI e il gate accuserebbe un file sano.
$magicVisti = @()
foreach($c in $Lavori){
  $fam = @($FAMIGLIE | Where-Object { $_.Id -eq $c.Fam })[0]
  $tx  = Get-Content -LiteralPath (Join-Path $Prove $c.Prova) -Raw
  # --- la GEOMETRIA VIVA, riga per riga, in OGNI file della famiglia
  foreach($chk in $VIVA[$c.Fam]){
    $rx = '(?m)^' + $chk[0] + '=' + [regex]::Escape($chk[1]) + '\|\|'
    if($tx -notmatch $rx){
      throw ($c.Prova + ": non trovo '" + $chk[0] + "=" + $chk[1] + "'. Questo NON e' la geometria della sedia viva (criteri par. 2." +
             $(if($c.Fam -eq "DOW"){"2"}else{"3"}) + "): l'ablazione girerebbe sopra un motore che non esiste.")
    }
  }
  # --- e i valori PROPRI di questa cella
  foreach($k in $c.Val.Keys){
    $rx = '(?m)^' + $k + '=' + [regex]::Escape($c.Val[$k]) + '\|\|'
    if($tx -notmatch $rx){ throw ($c.Prova + ": " + $k + " non vale " + $c.Val[$k] + ". La cella non e' quella che credo.") }
  }
  # --- @SIMBOLO / @PERIODO / @DAQUANDO, confrontati e non creduti
  $m = [regex]::Match($tx,'(?m)^@DAQUANDO\s+([0-9]{4}\.[0-9]{2}\.[0-9]{2})')
  if(-not $m.Success -or $m.Groups[1].Value -ne $DaQuando){ throw ($c.Prova + ": @DAQUANDO non e' " + $DaQuando) }
  $s = [regex]::Match($tx,'(?m)^@SIMBOLO\s+(\S+)')
  if(-not $s.Success -or $s.Groups[1].Value -ne $fam.Sym){ throw ($c.Prova + ": @SIMBOLO non e' " + $fam.Sym) }
  $p = [regex]::Match($tx,'(?m)^@PERIODO\s+(\S+)')
  if(-not $p.Success -or $p.Groups[1].Value -ne $Periodo){ throw ($c.Prova + ": @PERIODO non e' " + $Periodo) }
  # --- L'ORA E' QUELLA DEL SERVER. Regola di casa: server BCM = ora
  #     italiana - 1, e sugli indici e' MISURATA (4DOC par. 2.2, orologi
  #     del corso su una data invernale). DAX 09:00 IT = 08:00 server;
  #     apertura USA 15:30 IT = 14:30 server. Un 9 o un 15:30 qui dentro
  #     sarebbero l'ora ITALIANA, cioe' un'ALTRA strategia: i CSV
  #     andrebbero cestinati, e meglio non produrli affatto.
  if($tx -notmatch ('(?m)^InpSessionHour=' + $fam.OraH + '\|\|')){ throw ($c.Prova + ": InpSessionHour non e' " + $fam.OraH + " (ORA SERVER!). Server BCM = ora italiana - 1.") }
  if($tx -notmatch ('(?m)^InpSessionMin='  + $fam.OraM + '\|\|')){ throw ($c.Prova + ": InpSessionMin non e' " + $fam.OraM) }
  # --- i magic
  $mg = [regex]::Match($tx,'(?m)^InpMagic=(\d+)\|\|(\d+)\|\|1\|\|(\d+)\|\|Y')
  if(-not $mg.Success){ throw ($c.Prova + ": InpMagic non e' nella forma sweep 'v||v||1||v+1||Y'. Senza almeno un asse Y il driver generico si rifiuta di partire e MT5 rispazzola la griglia vecchia (checklist punto 5).") }
  $m0 = [int]$mg.Groups[1].Value; $m1 = [int]$mg.Groups[3].Value
  if($m0 -ne $c.Magic){ throw ($c.Prova + ": InpMagic e' " + $m0 + " ma questa cella deve girare su " + $c.Magic) }
  if($m1 -ne ($m0+1)){ throw ($c.Prova + ": il gemello e' " + $m1 + " invece di " + ($m0+1)) }
  foreach($m in @($m0,$m1)){
    if($magicVisti -contains $m){ throw ($c.Prova + ": magic " + $m + " gia' usato da un altro file prova. Due file con lo stesso magic non sono distinguibili nel CSV.") }
    if($MagicVietati -contains $m){ throw ($c.Prova + ": il magic " + $m + " e' di una SEDIA VIVA o di un round precedente. Fermo tutto.") }
    $magicVisti += $m
  }
}
Dico ("geometria viva, ora SERVER, valori delle celle e " + $magicVisti.Count + " magic vergini verificati NEI FILE") "Green"

# --- 1f. I SORGENTI E IL GATE DI VERSIONE. I marcatori sono presi DAL
#     SORGENTE, e sono DUE per EA: il nome proprio della sedia e il magic
#     dichiarato. Una cache CDN o un branch sbagliato darebbero un altro
#     motore, e il round misurerebbe un'altra cosa.
#     >>> IL MAGIC DEL SORGENTE E' QUELLO VIVO (770202 / 770101), e va
#         benissimo cosi': e' l'identita' del motore. I magic vergini
#         stanno nei FILE PROVA e sovrascrivono il default nel tester.
#         Confondere i due e' il difetto che R100 ha dovuto correggere
#         a mano su due sedie.
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
  if($txtSrc -notmatch 'InpUseVolumeFilter'){ throw ($fam.Ea + ".mq5 non ha InpUseVolumeFilter: senza i filtri non c'e' niente da ablare.") }
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
#     I due EA fanno #include <ABTG_PausaGuardian.mqh> e chiamano
#     ABTG_GuardiaIngresso(). walkforward_generico.ps1 scarica SOLO il
#     .mq5: senza questa riga la compilazione fallisce e il round muore
#     alla prima passata. Pagato due volte (21/08 e 22/08).
#     >>> NEL TESTER LA GUARDIA E' FAIL-OPEN TOTALE (le GlobalVariable del
#         Guardian non esistono): non cambia il comportamento e i numeri
#         restano confrontabili con R46/R54.
$mqh = Join-Path $MqlInclude "ABTG_PausaGuardian.mqh"
Scarica ("$RawPin/mql5/Include/ABTG_PausaGuardian.mqh") $mqh 'ABTG_GuardiaIngresso'
$vfy = Get-Item -LiteralPath $mqh
if($vfy.PSIsContainer){ throw "ABTG_PausaGuardian.mqh: in Include c'e' una CARTELLA con quel nome (checklist 27-ter)." }
if($vfy.Length -lt 4000){ throw ("ABTG_PausaGuardian.mqh e' lungo " + $vfy.Length + " byte: troppo poco, scarico monco.") }
Dico ("include installato: ABTG_PausaGuardian.mqh (" + $vfy.Length + " byte)") "Green"

# --- 2c. PULIZIA DEGLI ARTEFATTI VECCHI, PRIMA (checklist 14 e 53).
#     >>> SOLO se si corre davvero: un giro a vuoto che cancella gli
#         artefatti di una corsa vera fatta ieri e' un danno.
#     >>> E SI CANCELLA PER NOME: un filtro a wildcard prenderebbe anche i
#         CSV delle sedie vive e degli altri round.
if($SoloControllo){
  Dico "SoloControllo: NON cancello niente." "Yellow"
} else {
  foreach($fam in $FamLavoro){
    Remove-Item -LiteralPath (Join-Path $MqlFiles ("OptResults_" + $fam.Ea + "_" + $fam.Sym + ".csv")) -Force -ErrorAction SilentlyContinue
  }
  # --- la CACHE del tester, e SOLO quella. MAI bases\<server>\ticks: li'
  #     dentro c'e' lo storico a tick reali di U30USD e D30EUR, e
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
  $bakMq5 = $mq5 + ".prima_r101_" + $Stamp
  $bakEx5 = $ex5 + ".prima_r101_" + $Stamp
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
    [void]$Note.Add("compilazione " + $fam.Ea + ": " + $mw.Groups[1].Value + " warning (0 errori). Non fermano il round, ma vanno letti nel log dello zip.")
  }
  $fam.Compilato = $true
  Dico ("COMPILATO " + $fam.Ea + " v" + $fam.Ver + " (.ex5 riscritto adesso, rc=" + $rcMe + ")") "Green"
}

# =====================================================================
#  4. LA CATENA. Una cella alla volta. Mai in parallelo.
#     L'ORDINE CONTA: dentro ogni famiglia il METRO gira PER PRIMO,
#     perche' i gate G0 di quella famiglia stanno li' -- e se il metro
#     non si riproduce, i gradini di quella famiglia non si lanciano
#     nemmeno (sarebbero ore di macchina per numeri che non si leggono).
#     >>> E l'ALTRA famiglia va avanti lo stesso: una sedia storta non
#         porta via anche l'altra (stessa scelta di R100 par. 3).
# =====================================================================
Titolo ("4. LA CATENA - " + $Lavori.Count + " celle, una alla volta")
$Ordinati = @()
foreach($fam in $FamLavoro){
  $Ordinati += @($Lavori | Where-Object { $_.Fam -eq $fam.Id -and $_.Metro })
  $Ordinati += @($Lavori | Where-Object { $_.Fam -eq $fam.Id -and -not $_.Metro })
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
    [void]$Problemi.Add("TEMPO SCADUTO prima di " + $c.Prova + ": il round NON e' completo. Riprendi con -SoloCella " + $c.Prova + " (il metro della sua famiglia rigira da solo).")
    continue
  }
  Write-Host ""
  Write-Host "------------------------------------------------------------------" -ForegroundColor Cyan
  Write-Host ("  [" + $idx + "/" + $Ordinati.Count + "]  " + $c.Prova + $(if($c.Metro){ "   <<< IL METRO (gate G0)" }else{ "" })) -ForegroundColor Cyan
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
      $p = CsvDi $c $tag
      $n = -1
      if(Test-Path -LiteralPath $p){
        $n = (@(Get-Content -LiteralPath $p).Count) - 1
        if((Get-Item -LiteralPath $p).LastWriteTime -lt $tl){ $vecchie += $tag }
      }
      if($tag -eq "IS"){ $c.IS = $n } else { $c.OOS = $n }
    }
    if($vecchie.Count -eq 2){
      $c.Esito = "SALTATA DAL DRIVER (IS+OOS gia' presenti da un lancio precedente)"
      [void]$Problemi.Add($c.Prova + ": " + $c.Esito + ". Le righe tornano ma i file NON sono di questo lancio: rilancia con -Rifai.")
    }
    elseif($vecchie.Count -eq 1){
      $c.Esito = "A META' (" + $vecchie[0] + " e' di un lancio PRECEDENTE, l'altra gamba e' di adesso)"
      [void]$Problemi.Add($c.Prova + ": " + $c.Esito + ". Le due gambe vengono da due giri diversi: rilancia questa cella con -Rifai.")
    }
    elseif($c.IS -eq $CelleAttese -and $c.OOS -eq $CelleAttese){ $c.Esito = "OK" }
    else{
      $c.Esito = "RIGHE SBAGLIATE (IS " + $c.IS + " / OOS " + $c.OOS + ", attese " + $CelleAttese + ")"
      [void]$Problemi.Add($c.Prova + ": " + $c.Esito + ". Cache del tester, oppure lo sweep dei magic non ha spazzolato: il file NON si legge.")
    }

    # ---------- LE MISURE, lette dal CSV OOS (parser col controllo positivo)
    $rOOS = LeggiOpt (CsvDi $c "OOS")
    $c.Gemelli = Gemelli $rOOS
    if($null -eq $rOOS){
      [void]$Problemi.Add($c.Prova + ": CSV OOS non letto o colonne non riconosciute. Intestazioni viste: [" + (($script:CsvIntestazioni | Select-Object -First 12) -join " | ") + "]")
    } elseif(@($rOOS).Count -ge 1){
      $c.PfOOS   = $(if($null -ne $rOOS[0].Pf){ [double]$rOOS[0].Pf   } else { -1.0 })
      $c.DdOOS   = $(if($null -ne $rOOS[0].Dd){ [double]$rOOS[0].Dd   } else { -1.0 })
      $c.NOOS    = $(if($null -ne $rOOS[0].N){ [int]$rOOS[0].N       } else { -1 })
      $c.ProfOOS = $(if($null -ne $rOOS[0].Profit){ [double]$rOOS[0].Profit } else { 0.0 })
      if($null -ne $rOOS[0].Pg){ $c.PgOOS = [double]$rOOS[0].Pg }
    }
    $rIS = LeggiOpt (CsvDi $c "IS")
    $nISm = -1
    if($null -ne $rIS -and @($rIS).Count -ge 1 -and $rIS[0].N -ne $null){ $nISm = [int]$rIS[0].N }

    # ---------- I GATE G0, SOLO SUL METRO
    if($c.Metro){
      $fam.Gemelli = $c.Gemelli
      $fam.NOOS = $c.NOOS; $fam.NIS = $nISm
      $fam.PfOOS = $c.PfOOS; $fam.DdOOS = $c.DdOOS; $fam.ProfOOS = $c.ProfOOS
      $guai = New-Object System.Collections.ArrayList
      if($c.Gemelli -ne "IDENTICI"){ [void]$guai.Add("gemelli: " + $c.Gemelli) }
      if($c.PfOOS -lt 0 -or $c.DdOOS -lt 0){ [void]$guai.Add("PF o DD OOS NON MISURATI") }
      else{
        #  LE TOLLERANZE SONO QUELLE PROPOSTE NEI CRITERI par. 5 (G0) e
        #  sono [DA FIRMARE]: +-0,01 su PF, +-0,10 punti % su DD, n ESATTO.
        #  >>> SUL DAX IL n NON E' AGLI ATTI: NAtti = -1 e il gate sul n
        #      NON SI APPLICA. Non si inventa un "circa 270" per avere un
        #      gate in piu': un denominatore inventato e' peggio di un
        #      denominatore mancante.
        if([math]::Abs($c.PfOOS - $fam.PfAtti) -gt 0.01){ [void]$guai.Add("PF OOS " + (Fmt3 $c.PfOOS) + " contro " + $fam.PfAtti.ToString("0.000",$INV) + " agli atti") }
        if([math]::Abs($c.DdOOS - $fam.DdAtti) -gt 0.10){ [void]$guai.Add("DD OOS " + (Fmt2 $c.DdOOS) + "% contro " + $fam.DdAtti.ToString("0.00",$INV) + "% agli atti") }
        if($fam.NAtti -gt 0 -and $c.NOOS -ne $fam.NAtti){ [void]$guai.Add("n OOS " + $c.NOOS + " contro " + $fam.NAtti + " agli atti") }
      }
      if($guai.Count -gt 0){
        $fam.Metro = "NON RIPRODOTTO -- " + ($guai -join " ; ")
        $FamFerme += $c.Fam
        [void]$Problemi.Add("GATE G0 FALLITO sulla famiglia " + $c.Fam + ": " + $fam.Metro +
                            ". I gradini di questa famiglia NON sono stati lanciati: sopra un metro sbagliato non misurerebbero niente. Fonte dei numeri attesi: " + $fam.Fonte)
        Dico ("GATE G0 FALLITO su " + $c.Fam + ": " + $fam.Metro) "Red"
        Dico ("   i gradini di " + $c.Fam + " NON verranno lanciati. L'altra famiglia prosegue.") "Red"
      } else {
        $fam.Metro = "RIPRODOTTO (PF " + (Fmt3 $c.PfOOS) + ", DD " + (Fmt2 $c.DdOOS) + "%, n " + $c.NOOS + ")"
        Dico ("GATE G0 SUPERATO su " + $c.Fam + ": " + $fam.Metro) "Green"
        Dico ("   CANARINO: n IS " + $fam.NIS + " / n OOS " + $fam.NOOS + "   (NON e' un gate: Emendamento regola B)") "Yellow"
        if($fam.NIS -ge 0 -and $fam.NIS -lt 150){
          [void]$Note.Add("CANARINO " + $c.Fam + ": n IS = " + $fam.NIS + ", sotto i 150 dell'Emendamento regola A. Il giudizio di MERITO su questa famiglia e' SOSPESO (criteri par. 5, G4) -- e' una nota, non un guasto.")
        }
        if($fam.NOOS -ge 0 -and $fam.NOOS -lt 150){
          [void]$Note.Add("CANARINO " + $c.Fam + ": n OOS = " + $fam.NOOS + ", sotto 150. Vale la stessa sospensione, e OGNI FILTRO lo assottiglia ancora.")
        }
      }
    } else {
      #  sui gradini il gemello e' comunque igiene, e va nei problemi
      if($c.Gemelli -ne "IDENTICI" -and $c.Gemelli -ne "NON MISURATO (CSV non letto)"){
        [void]$Problemi.Add($c.Prova + ": gemelli " + $c.Gemelli + ". Le due righe dovevano essere identiche al centesimo: questa cella non si legge.")
      }
      if($c.NOOS -ge 0 -and $c.NOOS -lt 30){
        [void]$Note.Add($c.Prova + ": n OOS = " + $c.NOOS + ", sotto la soglia G1 di 30. Il verdetto su questo gradino e' NON MISURABILE, NON 'non funziona' (criteri par. 5, G1).")
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
      if(-not $mf.Success -or -not $mt.Success){ [void]$Problemi.Add("giro a vuoto / " + $c.Id + ": nell'anteprima non trovo FromDate/ToDate.") }
      elseif($mf.Groups[1].Value -ne $IS_Da -or $mt.Groups[1].Value -ne $IS_A){
        [void]$Problemi.Add("giro a vuoto / " + $c.Id + ": il driver generico calcola la finestra IS " + $mf.Groups[1].Value + " - " + $mt.Groups[1].Value +
                            ", ma questa riga (e i criteri par. 4) dicono " + $IS_Da + " - " + $IS_A + ". O e' cambiata la FrazioneIS del driver, o e' cambiata la finestra: le due cose NON possono divergere.")
      }
      $assiY = @([regex]::Matches($atx,'(?m)^(\w+)=[^\r\n]*\|\|\s*[Yy]\s*\r?$') | ForEach-Object { $_.Groups[1].Value })
      if($assiY.Count -ne 1 -or $assiY[0] -ne "InpMagic"){
        [void]$Problemi.Add("giro a vuoto / " + $c.Id + ": gli assi spazzolati nell'anteprima sono [" + ($assiY -join ", ") + "] invece del solo InpMagic. Piu' di un asse = piu' di 2 celle per finestra, cioe' un altro round.")
      }
      if($atx -notmatch ('(?m)^InpMagic=' + $c.Magic + '\|\|')){
        [void]$Problemi.Add("giro a vuoto / " + $c.Id + ": nell'anteprima InpMagic non parte da " + $c.Magic + ".")
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
  Write-Host  "          il blocco [TesterInputs], l'unico asse Y (InpMagic) e il magic." -ForegroundColor Yellow
  Write-Host  "        NON SI LEGGE: 'Model=4' e' una COSTANTE scritta a mano nel ramo" -ForegroundColor Yellow
  Write-Host  "          di prova del driver generico (cercare 'Model=4' li' dentro)." -ForegroundColor Yellow
  Write-Host  "          Stavolta COINCIDE con la corsa vera (-Modello 4), quindi non" -ForegroundColor Yellow
  Write-Host  "          mente -- ma resta una costante, non una conferma." -ForegroundColor Yellow
  Write-Host  "        E NON SI LEGGE NESSUN NUMERO DI ROUND: niente n, niente PF," -ForegroundColor Yellow
  Write-Host  "          niente DD, niente canarino, niente gate G0. Solo la corsa vera." -ForegroundColor Yellow
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
$Modo = if($SoloControllo){ "CONTROLLO" } elseif($SoloCella -ne ""){ "RIPRESA" } elseif($SoloEa -ne ""){ ("SOLO" + $SoloEa.ToUpper()) } else { "CORSA" }
$Cart = Join-Path $Dsk ("R101_ABLAZIONE_" + $Modo + "_" + $Stamp)
$Zip  = Join-Path $Dsk ("R101_ABLAZIONE_" + $Modo + "_" + $Stamp + ".zip")
$Referto = Join-Path $Cart "REFERTO_R101.txt"
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
  [void]$R.Add("REFERTO R101 - ABLAZIONE DEI FILTRI SU DOW (U30USD) E DAX (D30EUR), M5, TICK REALI")
  [void]$R.Add("modo: " + $Modo + $(if($SoloControllo){ "   <<< GIRO A VUOTO: NESSUNA passata, NESSUN CSV, NESSUN numero di round qui dentro" } else { "" }))
  $sw = @()
  if($SoloControllo){ $sw += "-SoloControllo (nessuna passata)" }
  if($CriteriFirmati){ $sw += "-CriteriFirmati (FIRMA IN RIGA di Claudio: il file dei criteri portava ancora [DA FIRMARE])" }
  if($SoloEa -ne ""){ $sw += "-SoloEa " + $SoloEa }
  if($SoloCella -ne ""){ $sw += "-SoloCella " + $SoloCella + " (il METRO della sua famiglia e' girato lo stesso: senza metro il gradino non si legge)" }
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
  [void]$R.Add("criteri: risultati_archivio\R101_CRITERI.md   perimetro: R101_FIRMA_ABLAZIONE.md")
  [void]$R.Add("finestra: " + $DaQuando + " -> " + $Fino + "   split 40/60   modello " + $Modello + " (tick reali)   deposito " + $Deposito)
  [void]$R.Add("     IS  " + $IS_Da + " - " + $IS_A)
  [void]$R.Add("     OOS " + $OOS_Da + " - " + $OOS_A)
  [void]$R.Add("     (le stesse di R88, R97 e R98: e' l'unico modo di confrontare i round alla pari)")
  [void]$R.Add("spread: Spread=" + $SpreadIni + " scritto NELL'INI = spread CORRENTE del feed BCM, dichiarato.")
  [void]$R.Add("     NON e' uno stress di spread e NON e' una misura dello spread.")
  [void]$R.Add("rischio: 1,00% nei file prova. IN CAMPO SUL 100K E' 0,65%.")
  [void]$R.Add("     >>> OGNI DD DI QUESTO REFERTO E' ALL'1%. Per confrontarlo col forward del")
  [void]$R.Add("     100k si MOLTIPLICA PER 0,65 (criteri par. 2.4). Chi salta la conversione")
  [void]$R.Add("     confronta due cose diverse.")
  [void]$R.Add("")
  [void]$R.Add("--- IL GATE G0: LA CELLA VIVA SI RIPRODUCE? (criteri par. 5) ---")
  foreach($fam in $FamLavoro){
    [void]$R.Add("  " + $fam.Id + " (" + $fam.Ea + " / " + $fam.Sym + ", magic vivo " + $fam.MagicSrc + ")")
    [void]$R.Add("     atteso agli atti : PF " + $fam.PfAtti.ToString("0.000",$INV) + " | DD " + $fam.DdAtti.ToString("0.00",$INV) + "% | n " + $(if($fam.NAtti -gt 0){ "" + $fam.NAtti } else { "NON AGLI ATTI (gate sul n NON applicato)" }))
    [void]$R.Add("     misurato adesso  : PF " + (Fmt3 $fam.PfOOS) + " | DD " + (Fmt2 $fam.DdOOS) + "% | n " + $fam.NOOS)
    [void]$R.Add("     gemelli          : " + $fam.Gemelli)
    [void]$R.Add("     VERDETTO G0      : " + $fam.Metro)
    [void]$R.Add("     fonte dei numeri : " + $fam.Fonte)
    [void]$R.Add("     CANARINO         : n IS " + $fam.NIS + " / n OOS " + $fam.NOOS + "   (NON e' un gate - Emendamento regola B)")
  }
  [void]$R.Add("  NOTA: 'NON MISURATO' NON e' 'va bene'. Un gate che non legge niente non e' un")
  [void]$R.Add("  gate verde. Se il metro non si riproduce, i gradini di QUELLA famiglia non")
  [void]$R.Add("  sono stati nemmeno lanciati -- e l'altra famiglia e' andata avanti.")
  [void]$R.Add("")
  [void]$R.Add("--- LA TABELLA MADRE ---   (attese: " + $CelleAttese + " righe per CSV, " + (2*$Lavori.Count) + " CSV, " + (4*$Lavori.Count) + " passate)")
  [void]$R.Add("  Tutti i numeri sono OOS. dPF e dDD sono il DELTA contro la cella viva della")
  [void]$R.Add("  stessa famiglia. PeggGio = 'Peggior Giornata %', letta nella sua colonna del CSV.")
  [void]$R.Add(("  {0,-26} {1,-5} {2,-9} {3,-8} {4,-9} {5,-8} {6,-9} {7}" -f "CELLA","n","PF","DD%","dPF","dDD%","PeggGio%","ESITO"))
  foreach($fam in $FamLavoro){
    [void]$R.Add("  --- " + $fam.Id + " ---")
    foreach($c in @($Ordinati | Where-Object { $_.Fam -eq $fam.Id })){
      $dpf = "n/d"; $ddd = "n/d"
      if($c.PfOOS -ge 0 -and $fam.PfOOS -ge 0){ $dpf = ($c.PfOOS - $fam.PfOOS).ToString("+0.000;-0.000;0.000",$INV) }
      if($c.DdOOS -ge 0 -and $fam.DdOOS -ge 0){ $ddd = ($c.DdOOS - $fam.DdOOS).ToString("+0.00;-0.00;0.00",$INV) }
      $pg = $(if($c.PgOOS -lt 99){ $c.PgOOS.ToString("0.00",$INV) } else { "n/d" })
      [void]$R.Add(("  {0,-26} {1,-5} {2,-9} {3,-8} {4,-9} {5,-8} {6,-9} {7}" -f $c.Id,$c.NOOS,(Fmt3 $c.PfOOS),(Fmt2 $c.DdOOS),$dpf,$ddd,$pg,$c.Esito))
    }
  }
  [void]$R.Add("")
  [void]$R.Add("--- LE CELLE, COME SONO SCRITTE NEI FILE CHE HANNO GIRATO ---")
  foreach($c in $Ordinati){
    $dd = $(if(@($c.Diff).Count -eq 0){ "(niente: e' il METRO)" } else { ($c.Diff -join " + ") })
    [void]$R.Add(("  {0,-4} {1,-26} magic {2}/{3}   muove: {4}" -f $c.Fam,$c.Id,$c.Magic,($c.Magic+1),$dd))
    [void]$R.Add("       " + $c.Desc)
  }
  [void]$R.Add("")
  [void]$R.Add("--- QUELLO CHE QUESTO REFERTO NON DICE, DICHIARATO ---")
  [void]$R.Add("  * NON APPLICA I CANCELLI. G1 (n>=30), G2 (PF su + DD non peggiore), G3")
  [void]$R.Add("    (coerenza cross-mercato) e G4 (campione) li applica il REFERTO DEL ROUND,")
  [void]$R.Add("    a mano, sopra questa tabella. Qui ci sono i numeri, non i verdetti.")
  [void]$R.Add("  * G3 in particolare NON e' meccanizzabile qui: e' il confronto fra le DUE")
  [void]$R.Add("    tabelle (lo stesso filtro deve andare nella stessa direzione sui due")
  [void]$R.Add("    indici). Ed e' il cancello che in R46 fermo' un candidato che faceva +31%.")
  [void]$R.Add("  * IL GRADINO 09 'CORSO PIENO' E' CUMULATIVO, NON UN'ABLAZIONE. Muove QUATTRO")
  [void]$R.Add("    interruttori insieme e NON attribuisce niente a nessun filtro: si legge SOLO")
  [void]$R.Add("    accanto ai gradini 02/03/05/06. E' la CHECKLIST del corso [PDF PAG 29-30],")
  [void]$R.Add("    cioe' il debito del 18/08, ed e' la decisione 4 firmata il 23/08.")
  [void]$R.Add("    >>> ATTESO, SCRITTO PRIMA DEI NUMERI: il n CROLLA. Quattro filtri che devono")
  [void]$R.Add("        passare tutti, sopra un motore da ~130 operazioni OOS sul Dow: e'")
  [void]$R.Add("        PROBABILE che finisca sotto la soglia G1 di 30, cioe' NON MISURABILE.")
  [void]$R.Add("        E 'NON MISURABILE' QUI E' GIA' UNA RISPOSTA, non un fallimento: vuol")
  [void]$R.Add("        dire che il metodo del corso, applicato alla lettera sulla nostra")
  [void]$R.Add("        geometria, NON PRODUCE UN CAMPIONE su cui si possa giudicare.")
  [void]$R.Add("        NON si abbassa nessuna soglia per far 'funzionare' questa cella.")
  [void]$R.Add("  * IL GRADINO 01 E' ASIMMETRICO: sul Dow TOGLIE l'EMA, sul DAX la METTE.")
  [void]$R.Add("    G3 NON si applica a quel gradino, e i due numeri si leggono separati.")
  [void]$R.Add("  * NON PROMUOVE NIENTE (G5). Le due sedie stanno sul conto 100k: un cambio")
  [void]$R.Add("    al forward e' una firma successiva, con il suo referto.")
  [void]$R.Add("  * NON misura lo spread, non misura il regime, non fa walk-forward nuovo.")
  [void]$R.Add("  * LA FINESTRA E' UN SOLO REGIME (21 mesi di indici che salgono) e questo OOS")
  [void]$R.Add("    e' gia' stato guardato molte volte: con 18 confronti sulla stessa finestra")
  [void]$R.Add("    QUALCUNO ESCE VERDE PER CASO. E' scritto nei criteri par. 4.1, ed e' il")
  [void]$R.Add("    motivo per cui esiste G3.")
  [void]$R.Add("")
  if($Note.Count -gt 0){
    [void]$R.Add("--- NOTE (non sono guasti: sono risultati del round) ---")
    foreach($n in $Note){ [void]$R.Add("  - " + $n) }
    [void]$R.Add("")
  }
  [void]$R.Add("--- PROBLEMI ---   (" + $Problemi.Count + ")")
  if($Problemi.Count -eq 0){ [void]$R.Add("  nessuno.") }
  foreach($p in $Problemi){ [void]$R.Add("  - " + $p) }
  if($Fatale -ne ""){
    [void]$R.Add("")
    [void]$R.Add("--- FERMATO ---")
    [void]$R.Add("  " + $Fatale)
  }
  [void]$R.Add("")
  [void]$R.Add("--- COME SI RIPRENDE ---")
  [void]$R.Add('  una famiglia sola  : ... & $p -Pin <PIN> -CriteriFirmati -SoloEa DAX')
  [void]$R.Add('  una cella sola     : ... & $p -Pin <PIN> -CriteriFirmati -SoloCella R101_DOW_03_atr.txt')
  [void]$R.Add("  >>> in tutti e due i casi il METRO della famiglia rigira: e' la cella 00_viva,")
  [void]$R.Add("      cioe' il denominatore. Costa 2 CSV, non una passata sprecata.")
  [void]$R.Add("  rifare cio' che c'e' gia' : aggiungi -Rifai")

  Set-Content -LiteralPath $Referto -Value ($R -join "`r`n") -Encoding UTF8
  if(Test-Path -LiteralPath $Zip){ Remove-Item -LiteralPath $Zip -Force -ErrorAction SilentlyContinue }
  Compress-Archive -Path (Join-Path $Cart "*") -DestinationPath $Zip -Force
}catch{
  Write-Host ("!!! RACCOLTA PARZIALE: " + $_.Exception.Message) -ForegroundColor Red
}

Write-Host ""
Write-Host "=====================================================================" -ForegroundColor White
Write-Host "  R101 - FINE" -ForegroundColor White
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
  Write-Host ("  MODO: " + $Modo + " -- GIRO A VUOTO. NESSUNA passata, NESSUN CSV, NESSUN") -ForegroundColor Yellow
  Write-Host ("        numero di round. Anteprime .ini attese: " + $Ordinati.Count + ".") -ForegroundColor Yellow
  Write-Host  "        GATE G0: NON ESEGUITO, ed e' giusto cosi'. Si misura nella CORSA VERA." -ForegroundColor Yellow
  Write-Host  "        QUESTO ZIP NON E' IL ROUND e non va mandato come risultato." -ForegroundColor Yellow
} else {
  Write-Host ("  MODO: " + $Modo) -ForegroundColor White
  Write-Host ("  ATTESI:  " + (2*$Lavori.Count) + " CSV (" + $Lavori.Count + " celle x IS/OOS), " + $CelleAttese + " righe l'uno, " + (4*$Lavori.Count) + " passate.") -ForegroundColor White
  foreach($fam in $FamLavoro){
    $col = if($fam.Metro -like "RIPRODOTTO*"){ "Green" } else { "Red" }
    Write-Host ("  GATE G0 " + $fam.Id + ": " + $fam.Metro) -ForegroundColor $col
    Write-Host ("     CANARINO " + $fam.Id + ": n IS " + $fam.NIS + " / n OOS " + $fam.NOOS + "   (NON e' un gate: regola B)") -ForegroundColor White
  }
}
foreach($c in $Ordinati){
  $col = "Green"; if($c.Esito -ne "OK" -and $c.Esito -ne "SOLO CONTROLLO"){ $col = "Yellow" }
  Write-Host ("   " + ($c.Fam + " " + $c.Id).PadRight(28) + " " + $c.Esito) -ForegroundColor $col
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
#      "PARZIALE O FERMO" su un round perfetto. E' la correzione (1)
#      dichiarata in testa a questo file.
#      CODICI: 0 = OK | 1 = parziale o fermato | 2 = criteri non firmati
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
if($ko.Count -gt 0 -or $Problemi.Count -gt 0){
  Write-Host ("ESITO: PARZIALE (" + $ko.Count + " celle non OK, " + $Problemi.Count + " problemi)") -ForegroundColor Yellow
  exit 1
}
Write-Host "ESITO: OK" -ForegroundColor Green
exit 0
