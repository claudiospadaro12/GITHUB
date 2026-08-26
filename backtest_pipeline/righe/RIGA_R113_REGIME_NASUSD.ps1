# =====================================================================
#  MARCATORE_RIGA_R113_v1
#  RIGA_R113_REGIME_NASUSD.ps1  --  R113: PROVA DI REGIME NASUSD_EXT.
#  L'EDGE SHORT SUL NASDAQ VIVE NELLE DISCESE? (lettura: IPOTESI-S)
#  UN solo motore (ABTG_SupRev_NAS_H1_Ottimizzato, sedia viva 970913),
#  TRE celle (metro L+S / long / short), SEI finestre di regime:
#     F0 TORO         2021.01.01 - 2021.12.31   merito (controllo)
#     F1 ORSO         2022.01.01 - 2022.10.31   merito + rischio
#     F2 CROLLO       2020.02.01 - 2020.04.30   SOLO rischio (E.3)
#     F3 CROLLO_ANNO  2020.01.01 - 2020.12.31   merito
#     F4 LATERALE_NAS 2015.01.01 - 2016.06.30   merito + rischio
#     F5 VECCHIA      2011.01.01 - 2012.12.31   SOLO rischio (regola B)
#  18 celle (3 x 6), ognuna col suo gemello dentro (asse magic +5):
#  36 passate in tutto. Magic: 763500 + F*10 + C, gemello +5
#  (blocco vergine 7635xx, range usato 763500-763557).
# ---------------------------------------------------------------------
#  CRITERI:   backtest_pipeline\risultati_archivio\R113_CRITERI.md
#  ORIGINE:   R110 chiude con "da verificare in prova di regime sui 16
#             anni" sul lato short SUPNAS (OOS PF 1,870 ma n 34 =
#             indizio); il 26/08 Claudio firma "FIRMO FRIGO NASUSD"
#             (NASUSD_EXT ammesso alla prova di regime, bordo sottile
#             0,199 dichiarato); il 27/08 notte firma "FIRMO R113".
#
#  >>> LA FIRMA DEI CRITERI SI LEGGE NEL FILE AL PIN, NON SI RICORDA:
#      se il driver ci trova ancora la stringa del lucchetto (composta
#      nel codice, MAI scritta per esteso qui: checklist 82), la CORSA
#      VERA non parte (exit 2); il GIRO A VUOTO parte lo stesso.
#      [Alla stesura i criteri risultano FIRMATI: "FIRMO R113", Claudio
#      27/08/2026 notte -- ma fa fede SOLO cio' che il gate legge al
#      pin, non questa nota.] -CriteriFirmati e' la firma IN RIGA di
#      Claudio; su un file gia' firmato e' INERTE e il referto lo dice.
#
#  DA DOVE NASCE, dichiarato: e' RIGA_R112_EMADOW_CONTRATTO.ps1
#  (MARCATORE_RIGA_R112_v1) adattata da "contratto" a "prova di
#  regime". Il punto 9 della checklist dice che una riscrittura non
#  puo' perdere le funzioni di sicurezza del gemello: sono state
#  riportate TUTTE quelle che restano nel perimetro -- guardia
#  MT5/MetaEditor chiusi, -Pin senza default, [CmdletBinding()], gate
#  della firma a tre rami (checklist 82), AllowLiveTrading=false
#  scritto E verificato nell'artefatto, install dell'include, gate
#  delle righe vive, ANTENATO per nome, STELLA, VALORI e geometria
#  d'identita', asse unico InpMagic, magic vietati (RANGE 7633xx e
#  7634xx + 970913), compilazione diretta con verdetto LastWriteTime +
#  backup datato + ripristino, sosta svuotata, raccolta e variabili
#  SOPRA il try, modo nel nome, cultura invariante, \r? sui $
#  multilinea, raccolta SEMPRE, exit esplicito su ogni ramo,
#  sentinella su TUTTE le colonne, ricontrollo della finestra prima di
#  ogni lancio (checklist 79), rilettura dei gen_*.ini che hanno
#  girato, elenchi ordinati alla fonte (checklist 70-bis).
#
#  ------------------------------------------------------------------
#  COSA CAMBIA RISPETTO A R112, e perche'
#
#  (a)  NIENTE walkforward_generico. Le finestre di regime sono
#       FINESTRE UNICHE senza split IS/OOS, e walkforward_generico
#       costruisce SEMPRE le due gambe (righe 465-468): QUESTO driver
#       scrive DA SOLO gli .ini del tester, finestra per finestra
#       (Model=1, FromDate/ToDate della finestra, Optimization=1 con
#       l'asse magic dei 2 gemelli, Deposit=100000, Currency=EUR,
#       Leverage=100 come gli .ini di casa, Spread=0 come i round OHLC
#       di casa: la riga Spread SCRITTA nell'ini = spread del simbolo
#       messo agli atti invece che lasciato allo stato nascosto del
#       terminale; su un simbolo CUSTOM e' lo spread FISSO impostato
#       all'import, identico per tutte le finestre PER COSTRUZIONE --
#       stessa riga in tutti i 18 .ini -- e il referto lo dichiara).
#       La struttura dell'.ini e' COPIATA campo per campo da quella di
#       walkforward_generico.ps1 (righe 636-662) + il blocco [Charts]
#       MaxBars che R112 iniettava. [INFERITO] che il tester onori
#       MaxBars: qui comunque il tetto barre NON morde (93.085 barre
#       H1 totali < 100.000, misurato in STORICO_INDICI).
#
#  (b)  PULIZIA PER CELLA (checklist 88, pagata su R112 il 26/08):
#       gli artefatti condivisi (OptResults_* in MQL5\Files e
#       Tester\cache) si puliscono SUBITO PRIMA del lancio di QUELLA
#       cella, mai in blocco a inizio corsa. Una cella SALTATA (CSV
#       gia' presente, senza -Rifai) raccoglie il CSV esistente con
#       l'ETA' DICHIARATA, non lo pretende fresco: "fresco o niente"
#       vale solo per le celle girate DAVVERO in questo lancio.
#
#  (c)  NIENTE per-trade / Common Files: FUORI PERIMETRO (criteri).
#       L'EA scrive comunque i suoi abtg_trades_* nella cartella
#       comune coi magic 7635xx: questo driver NON li legge, NON li
#       cancella e NON li raccoglie, e il referto lo dichiara.
#       Niente peggior giornata: non e' nel perimetro del round.
#
#  (d)  NIENTE G0-B: non esiste un riferimento da riprodurre (nessun
#       round e' mai girato su NASUSD_EXT). Il gate di riproduzione
#       non e' applicabile ed e' dichiarato tale, non "superato".
#
#  (80) L'OPTFRAME DI QUESTO EA HA 8 COLONNE STATISTICHE, MISURATO NEL
#       SORGENTE AL PIN (OnTesterDeinit, riga 629):
#         Pass,Profit,Expected Payoff,Profit Factor,Recovery Factor,
#         Sharpe Ratio,Equity DD %,Trades
#       'Peggior Giornata %' NON esiste e NON e' un criterio di questo
#       round. Il parser pretende ESATTAMENTE quelle 8, nell'ordine.
#
#  (83) IL SIMBOLO E' CUSTOM: il tester accetta Symbol=NASUSD_EXT
#       nell'ini SOLO se il simbolo esiste nel terminale. Il driver
#       controlla PRIMA (bases\Custom\history\NASUSD_EXT) e se manca
#       si ferma con l'errore ONESTO: 'NASUSD_EXT non trovato: va
#       reimportato con la Riga 2 dello storico'. E se le barre ci
#       sono ma il tester dice lo stesso "symbol not exist", la
#       registrazione del simbolo e' andata persa (terminale ammazzato
#       invece che chiuso): anche questo e' scritto nel messaggio del
#       guasto, non lasciato indovinare (checklist 83: due cause,
#       due nomi).
#
#  (86) OROLOGI: le finestre sono DATE DI CALENDARIO a giorni interi;
#       le barre _EXT sono in ORA SERVER BCM (shift +5 verificato
#       all'import). Ogni orario del referto dichiara il suo orologio.
#
#  (87) VERSI: i DD sono MAGNITUDINI POSITIVE (piu' basso = meglio),
#       i profitti hanno il SEGNO. Dichiarato in ogni tabella.
#  ------------------------------------------------------------------
#
#  COSA FA, in ordine, e DA SOLA:
#    0.     si rifiuta di partire se MT5 O MetaEditor sono aperti
#    0-bis. si rifiuta di CORRERE se i criteri non sono firmati
#    1.     scarica AL PIN: i 18 file prova R113, i 3 ANTENATI
#           R110_SUPNAS, il sorgente ABTG_SupRev_NAS_H1_Ottimizzato.mq5
#           e l'include ABTG_PausaGuardian.mqh
#           - gate di versione + i due lati + intestazione OPTFRAME a
#             8 colonne PRESENTE NEL SORGENTE (misurato, non sperato)
#           - gate delle righe vive (46 per file R113, 45 per antenato)
#           - gate dell'ANTENATO per nome (checklist 72): delta ammessi
#             @SIMBOLO + @DAQUANDO + InpMagic, riga NUOVA ammessa @FINOA
#           - gate della STELLA (long e short contro il metro della
#             STESSA finestra)
#           - gate dei VALORI e della geometria d'identita'
#           - gate dell'asse unico (un solo Y, ed e' InpMagic)
#           - gate dei MAGIC (schema 763500+F*10+C gemello +5; vietati
#             970913 e i RANGE 7633xx e 7634xx)
#    2.     terminale e cartella dati PER NOME; CONTROLLO DEL SIMBOLO
#           CUSTOM (bases\Custom\history\NASUSD_EXT) PRIMA di aprire MT5
#    3.     FASE COMPILA (un solo EA), invocazione DIRETTA di
#           metaeditor64.exe, verdetto sul LastWriteTime del .ex5
#    4.     la CATENA: 18 lanci (F0..F5 x metro/long/short), UNO alla
#           volta. Per ogni lancio: ricontrollo finestra (checklist
#           79), pulizia PER CELLA (checklist 88), .ini scritto E
#           riletto, tester, CSV fresco, G0-C gemelli, lettura E.2.
#    5.     raccolta SEMPRE: cartella sul Desktop + zip + REFERTO con
#           la tabella madre a 18 righe, l'elenco attesi/trovati e la
#           griglia IPOTESI-S STAMPATA VUOTA (si spunta A MANO).
#
#  QUELLO CHE NON FA, dichiarato:
#    - NON GIUDICA IPOTESI-S e NON spunta la griglia del par. 6: le
#      caselle escono VUOTE, si compilano a mano nel referto del round.
#    - NON promuove niente e NON tocca il forward (G5 per costruzione):
#      la sedia 970913 non si tocca, nessun numero _EXT muove sedie.
#    - NON legge, NON cancella e NON raccoglie i per-trade della
#      cartella comune (fuori perimetro).
#    - NON scarica storico e NON tocca bases\<server>\ticks ne'
#      bases\Custom (il simbolo lo CONTROLLA, non lo costruisce).
#    - non scrive una riga di MQL5.
#    - non ammazza un lavoro in corso allo scadere di -OreMax: smette
#      solo di iniziarne di nuovi (checklist 19).
#
#  QUANTO CI METTE: [STIMA], non una previsione. 36 passate OHLC-M1 H1
#  su finestre da 3 a 24 mesi: 10-25 minuti piu' la compilazione, DA
#  VERIFICARE AL PRIMO GIRO. -OreMax e' 4, tetto sull'INIZIO.
#
#  LA RIGA CHE SI INCOLLA (blocco INTERO, un comando solo - checklist 21).
#  <PIN> = il commit che contiene QUESTO file: e' l'hash dato in chat.
#
#  & { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
#      if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
#      $pin='<PIN>'; $p="$env:USERPROFILE\RIGA_R113.ps1"; Remove-Item $p -EA SilentlyContinue;
#      irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_R113_REGIME_NASUSD.ps1" -OutFile $p;
#      if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_R113_v1' -Quiet)){ throw 'SCRIPT VECCHIO' };
#      $global:LASTEXITCODE=0; & $p -Pin $pin -SoloControllo; if($LASTEXITCODE -ne 0){ Write-Host 'ESITO: PARZIALE O FERMO - leggi il REFERTO' } }
#
#  GIRO A VUOTO: e' quello qui sopra (-SoloControllo). Scrive e verifica
#  GLI STESSI .ini che girano nella corsa vera (checklist 33) e NON
#  misura nessun numero: senza tester non esiste nessun n, nessun PF,
#  nessun G0-C.
# =====================================================================
[CmdletBinding()]
param(
  # -Pin NON ha default: un default silenzioso ("lavoro") farebbe girare la
  #  punta del branch spacciandola per un commit congelato. Meglio morire.
  [string]$Pin        = "",
  [double]$OreMax     = 4.0,       # oltre questo NON si iniziano nuovi lanci
  [switch]$Rifai,                  # rifa' anche i CSV gia' presenti
  [switch]$SoloControllo,          # giro a vuoto: NON apre MT5
  [switch]$CriteriFirmati,         # >>> lo preme CLAUDIO, non l'agente. Senza,
                                   #     la corsa vera non parte (exit 2). Su
                                   #     un file gia' firmato e' INERTE e va
                                   #     detto (checklist 82).
  [string]$SoloCella  = ""         # es. "R113_F1_02_short.txt": un lancio solo.
                                   #     In R113 NON c'e' G0-B: nessuna cella
                                   #     e' denominatore di un'altra, quindi
                                   #     -SoloCella lancia SOLO quella (i gate
                                   #     G0-A/stella/valori girano comunque su
                                   #     TUTTI i 18 file, che MT5 non serve).
)
$ErrorActionPreference = "Stop"
[Threading.Thread]::CurrentThread.CurrentCulture   = [Globalization.CultureInfo]::InvariantCulture
[Threading.Thread]::CurrentThread.CurrentUICulture = [Globalization.CultureInfo]::InvariantCulture
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$INV = [Globalization.CultureInfo]::InvariantCulture

$Avvio  = Get-Date
$Stamp  = $Avvio.ToString("yyyyMMdd_HHmm", $INV)
$Dsk    = Join-Path $env:USERPROFILE "Desktop"
$Work   = Join-Path $env:USERPROFILE "abtg_r113"
$Prove  = Join-Path $Work "prove"
$Anten  = Join-Path $Work "antenati"
$Logs   = Join-Path $Work "log_r113"
$SrcDir = Join-Path $Work "src_motori"
$RawPin = "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$Pin"

# =====================================================================
#  LA SEDIA E IL BANCO. Un solo motore su un solo simbolo CUSTOM.
#  - EaVersione / MagicSorgente : LETTI NEL SORGENTE al pin. Qui il
#    magic del SORGENTE (970913) E' anche quello della SEDIA VIVA: e'
#    lo stesso numero, ed e' VIETATO nel round.
#  - RigheVive : MISURATE con grep -cvE su tutti i file il 27/08:
#    46 per i file R113 (3 tag + @FINOA + 42 input), 45 per gli
#    antenati R110 (che @FINOA non ce l'hanno).
# =====================================================================
$EaNome           = "ABTG_SupRev_NAS_H1_Ottimizzato"
$EaVersione       = "1.00"
$SimboloRound     = "NASUSD_EXT"
$PeriodoRound     = "H1"
$MagicSorgente    = "970913"
$RigheViveProvaAtt   = 46
$RigheViveAntenatoAtt = 45
$Modello          = 1            # OHLC su M1: l'UNICO banco che esiste su
                                 # un simbolo fatto di barre M1 importate.
$Deposito         = 100000       # taglia prop, come i round di casa
$SpreadIni        = 0            # 0 = riga Spread SCRITTA nell'ini, e nella
                                 # convenzione di casa (walkforward_generico
                                 # riga 484) vuol dire "spread CORRENTE del
                                 # simbolo", come R100/R102/R103.
                                 # >>> IL VALORE EFFETTIVO IN PUNTI NON E'
                                 # MISURATO DA QUESTO DRIVER e non si ricava
                                 # da un .ps1: sta nella configurazione
                                 # BINARIA del simbolo custom. Si DICHIARA
                                 # MANCANTE, non si deduce (checklist 89).
                                 # Cio' che invece E' verificato: la stessa
                                 # riga in tutti e 18 gli .ini, riletta
                                 # nell'artefatto -> coerenza interna dei
                                 # confronti _EXT-vs-_EXT PER COSTRUZIONE.
$CelleAttese      = 2            # le due passate GEMELLE, per CSV

#--- MAGIC VIETATI (criteri par. 5): la sedia viva/sorgente 970913 e i
#    blocchi bruciati 7633xx (R110) e 7634xx (R112), vietati come RANGE.
$MagicVietati = @(970913)
function MagicVietato([int]$numeroMagic){
  if($MagicVietati -contains $numeroMagic){ return $true }
  if($numeroMagic -ge 763300 -and $numeroMagic -le 763499){ return $true }
  return $false
}

# =====================================================================
#  LE SEI FINESTRE (criteri par. 3), CONGELATE. Ogni valore e' una data
#  di CALENDARIO a giorni interi (le barre _EXT sono in ora server BCM,
#  shift +5 verificato all'import: il fuso non sposta il verdetto).
#  >>> CHECKLIST 79 regola 3: formato, giorno che esiste, verso --
#      controllati QUI, alla costruzione della tabella.
# =====================================================================
function FinestraNuova([int]$indiceF,[string]$etichetta,[string]$dataDa,[string]$dataA,[string]$giudica){
  foreach($dataCorr in @($dataDa,$dataA)){
    if($dataCorr -notmatch '^\d{4}\.\d{2}\.\d{2}$'){ throw ("finestra F" + $indiceF + ": data [" + $dataCorr + "] non e' yyyy.MM.dd") }
    $dataParse = [datetime]::MinValue
    if(-not [datetime]::TryParseExact($dataCorr,"yyyy.MM.dd",$INV,[Globalization.DateTimeStyles]::None,[ref]$dataParse)){
      throw ("finestra F" + $indiceF + ": data [" + $dataCorr + "] non e' un giorno che esiste")
    }
  }
  $dtDa = [datetime]::ParseExact($dataDa,"yyyy.MM.dd",$INV)
  $dtA  = [datetime]::ParseExact($dataA, "yyyy.MM.dd",$INV)
  if($dtA -le $dtDa){ throw ("finestra F" + $indiceF + ": " + $dataA + " non e' dopo " + $dataDa) }
  return [pscustomobject]@{ F=$indiceF; Etichetta=$etichetta; Da=$dataDa; A=$dataA; Giudica=$giudica }
}
$FINESTRE = @(
  (FinestraNuova 0 "TORO"         "2021.01.01" "2021.12.31" "merito (controllo)"),
  (FinestraNuova 1 "ORSO"         "2022.01.01" "2022.10.31" "merito + rischio"),
  (FinestraNuova 2 "CROLLO"       "2020.02.01" "2020.04.30" "SOLO rischio (E.3)"),
  (FinestraNuova 3 "CROLLO_ANNO"  "2020.01.01" "2020.12.31" "merito"),
  (FinestraNuova 4 "LATERALE_NAS" "2015.01.01" "2016.06.30" "merito + rischio"),
  (FinestraNuova 5 "VECCHIA"      "2011.01.01" "2012.12.31" "SOLO rischio (regola B)")
)
#--- IL SECONDO DEPOSITO DELLE FINESTRE (checklist 79): letterali
#    indipendenti dalla tabella sopra, ricontrollati un istante prima
#    di OGNI lancio. Se una variabile viene sporcata a meta' script, il
#    confronto con QUESTE stringhe la prende.
$FinestreLetterali = @("2021.01.01|2021.12.31","2022.01.01|2022.10.31","2020.02.01|2020.04.30",
                       "2020.01.01|2020.12.31","2015.01.01|2016.06.30","2011.01.01|2012.12.31")

# =====================================================================
#  LE TRE CELLE x SEI FINESTRE = 18 LANCI (criteri par. 2 e 5).
#  - DiffStella : gli input che DEVONO differire dal 00_metro della
#    STESSA finestra (oltre a InpMagic, che differisce sempre).
#  - AntFile : l'ANTENATO R110_SUPNAS scaricato al pin. Delta ammessi
#    PER NOME (checklist 72): @SIMBOLO + @DAQUANDO + InpMagic; riga
#    NUOVA ammessa: @FINOA (il tag di fine finestra nasce in R113 ed
#    e' documentato nell'header di ogni file prova).
#  - Val : i valori dei LATI che i gate pretendono NEL FILE.
#  >>> NIENTE HASHTABLE LETTERALE MULTILINEA (checklist 63).
# =====================================================================
function ValoriCella([string]$latoLungo,[string]$latoCorto){
  $tabella = @{}
  $tabella["InpAllowLong"]  = $latoLungo
  $tabella["InpAllowShort"] = $latoCorto
  return $tabella
}
function CellaNuova($finestra,[int]$indiceC,[string]$idCella,[string]$descrizione,$diffStella,[string]$antFile,$valori,[bool]$eMetro){
  $magicBase = 763500 + 10*$finestra.F + $indiceC
  return [pscustomobject]@{
    Id=("F" + $finestra.F + "_" + $idCella); Cella=$idCella
    Prova=("R113_F" + $finestra.F + "_" + $idCella + ".txt")
    Desc=$descrizione; Magic=$magicBase; F=$finestra.F
    Etichetta=$finestra.Etichetta; Da=$finestra.Da; A=$finestra.A; Giudica=$finestra.Giudica
    DiffStella=@($diffStella); AntFile=$antFile; Val=$valori; Metro=$eMetro
    Esito="NON ESEGUITA"; Righe=-1; Min=0.0
    Pf=-1.0; Dd=-1.0; Prof=-999999.0; N=-1
    Gemelli="NON MISURATO"; Antenato="NON VERIFICATO"; EtaCsv=""
  }
}
$CELLE = @()
foreach($finCorr in $FINESTRE){
  $CELLE += (CellaNuova $finCorr 0 "00_metro" "la cella VIVA L+S (contesto)"        @()                "R110_SUPNAS_00_metro.txt" (ValoriCella "true"  "true")  $true)
  $CELLE += (CellaNuova $finCorr 1 "01_long"  "solo long (denominatore)"           @("InpAllowShort") "R110_SUPNAS_01_long.txt"  (ValoriCella "true"  "false") $false)
  $CELLE += (CellaNuova $finCorr 2 "02_short" "solo short (LA DOMANDA, IPOTESI-S)" @("InpAllowLong")  "R110_SUPNAS_02_short.txt" (ValoriCella "false" "true")  $false)
}

# =====================================================================
#  LA GEOMETRIA D'IDENTITA', pretesa riga per riga in OGNI file. Non e'
#  ridondanza col gate dell'antenato: l'antenato garantisce che i file
#  R113 siano uguali ai file R110, QUESTO garantisce che siano la cella
#  che i criteri descrivono, anche se qualcuno corrompesse ANCHE gli
#  antenati in repo.
#  >>> InpAllowLong e InpAllowShort NON SONO QUI: sono l'ASSE del round
#      (il lato), e il loro valore lo pretende il gate 'Val' della cella.
#  >>> NIENTE HASHTABLE LETTERALE MULTILINEA (checklist 63).
#  Fonte: prove\R110_SUPNAS_00_metro.txt, letto riga per riga il 27/08.
# =====================================================================
$GeometriaViva = @(@("InpUsaGuardian","true"),@("InpTF","16385"),@("InpStMult","3.0"),
                   @("InpStAtrPeriod","10"),@("InpNearAtr","1.0"),@("InpRequireConfirmBody","true"),
                   @("InpUseConfluence","true"),@("InpEma1","14"),@("InpEma2","89"),
                   @("InpEma3","100"),@("InpEma4","200"),@("InpConflAtr","1.5"),
                   @("InpFirstFraction","0.3333"),@("InpUsePending","true"),@("InpPendingPips","20.0"),
                   @("InpPendingExpiryBars","3"),@("InpSLLookback","5"),@("InpSLBufferPips","3.0"),
                   @("InpTP1_R","1.0"),@("InpTP1Pct","50.0"),@("InpBreakeven","true"),
                   @("InpTP_RR","3.0"),@("InpTrailOnST","true"),@("InpExitOnFlip","true"),
                   @("InpRiskPercent","1.0"),@("InpMaxTradesPerDay","0"),@("InpUseTimeWindow","false"),
                   @("InpStartHour","0"),@("InpEndHour","24"),@("InpUseNewsFilter","false"),
                   @("InpNewsMinImpact","3"),@("InpNewsBeforeMin","30"),@("InpNewsAfterMin","30"),
                   @("InpNewsShiftMinutes","0"),@("InpMaxSpread","0"),@("InpVerbose","true"))
#--- le tre righe SENZA sweep (nome=valore secco), pretese come riga intera
$GeometriaPiatta = @(@("InpNewsFile","abtg_news.csv"),@("InpNewsCurrencies",""),@("InpComment","STREV NAS H1"))

#--- I DELTA AMMESSI CONTRO L'ANTENATO (checklist 72): valori DIVERSI
#    ammessi su queste chiavi; @FINOA e' una riga NUOVA ammessa (il tag
#    nasce in R113: l'antenato non ce l'ha, ed e' dichiarato).
$DeltaAmmessi   = @("@SIMBOLO","@DAQUANDO","InpMagic")
$RigheNuoveAmm  = @("@FINOA")

#--- Tolleranza per il confronto fra gemelli (G0-C).
$TolGemelli = 0.005

#--- LE 8 COLONNE STATISTICHE DELL'OPTFRAME, ESATTE E NELL'ORDINE
#    (checklist 80: misurate nel sorgente al pin, OnTesterDeinit).
$ColonneOptAttese = @("Pass","Profit","Expected Payoff","Profit Factor","Recovery Factor","Sharpe Ratio","Equity DD %","Trades")

#--- I METRI R110 PER LA LETTURA G2 (criteri par. 4): DD OOS R110 per
#    cella, a rischio 1%. MAGNITUDINI POSITIVE (checklist 87). Servono
#    SOLO come INFO nel referto: la segnalazione e' A MANO.
$MetroG2 = @{}
$MetroG2["00_metro"] = 1.29
$MetroG2["01_long"]  = 1.62
$MetroG2["02_short"] = 0.93

# =====================================================================
#  TUTTO CIO' CHE LA RACCOLTA USA NASCE QUI, PRIMA DEL try (checklist
#  41-bis), FUNZIONI COMPRESE (checklist 48).
# =====================================================================
$Risultati = Join-Path $Work "risultati_prove"
$Sosta     = Join-Path $Work "sosta"
$Problemi  = New-Object System.Collections.ArrayList
$Rilievi   = New-Object System.Collections.ArrayList
$Fatale    = ""
$Firma     = "NON LETTA"
#  >>> CHECKLIST 41-bis e 82: $daFirmare lo LEGGE la raccolta, che sta
#      FUORI dal try. Il valore prudente e' $true: "non ho letto" non e'
#      "e' firmato".
$daFirmare = $true
#  >>> IL LUCCHETTO SI COMPONE, NON SI SCRIVE (checklist 82, regola 1).
$LucchettoFirma = '[DA ' + 'FIRMARE]'
$Terminal  = ""; $MetaEditor = ""; $DataFolder = ""
$Ordinati  = @()      # checklist 41-bis: la raccolta lo scorre SEMPRE
$Vive      = @{}
$SelettoreAVuoto = $false
$EaCompilato = $false

function Ora(){ return (Get-Date).ToString("HH:mm:ss", $INV) }
function Dico([string]$testo,[string]$colore="Gray"){ Write-Host ("[" + (Ora) + "] " + $testo) -ForegroundColor $colore }
function Titolo([string]$testo){ Write-Host ""; Write-Host ("=== " + $testo + " ===") -ForegroundColor Cyan }

function Scarica([string]$urlSorgente,[string]$destinazione,[string]$marcatore){
  Remove-Item -LiteralPath $destinazione -Force -ErrorAction SilentlyContinue
  Invoke-WebRequest -Uri $urlSorgente -OutFile $destinazione -UseBasicParsing -ErrorAction Stop
  if(-not (Test-Path -LiteralPath $destinazione)){ throw ("scarico fallito: " + $urlSorgente) }
  if($marcatore -ne "" -and -not (Select-String -LiteralPath $destinazione -SimpleMatch -Pattern $marcatore -Quiet)){
    throw ("file scaricato SENZA il marcatore '" + $marcatore + "': " + $urlSorgente)
  }
}

function RigheVive([string]$percorso){
  return @(Get-Content -LiteralPath $percorso | Where-Object { $_ -notmatch '^\s*#' -and $_ -notmatch '^\s*$' })
}
function NomeDi([string]$rigaViva){
  if($rigaViva -match '^@'){ return ($rigaViva -split '\s+')[0] }
  return (($rigaViva -split '=')[0]).Trim()
}
function ValoreDi([string]$rigaViva){
  if($rigaViva -match '^@'){ return (($rigaViva -split '\s+',2)[1]).Trim() }
  $posUguale = $rigaViva.IndexOf("=")
  if($posUguale -lt 0){ return "" }
  return $rigaViva.Substring($posUguale+1).Trim()
}
#  MAPPA NOME -> VALORE: e' cosi' che si confronta con l'ANTENATO, per
#  NOME e mai per posizione (checklist 72 e 58). Un doppione di nome e'
#  un guasto in se' (in [TesterInputs] fa fare a MT5 ZERO passate).
function MappaDi($elencoRighe){
  $mappa = @{}
  foreach($rigaCorr in @($elencoRighe)){
    $nomeChiave = NomeDi $rigaCorr
    if($mappa.ContainsKey($nomeChiave)){ throw ("il file ha DUE righe per '" + $nomeChiave + "': in [TesterInputs] un parametro doppio fa fare a MT5 ZERO passate.") }
    $mappa[$nomeChiave] = (ValoreDi $rigaCorr)
  }
  return $mappa
}
function CsvDi($cella){
  return (Join-Path $Risultati ("R113_" + $cella.Id + ".csv"))
}
function IniDi($cella){
  return (Join-Path $Work ("gen_R113_" + $cella.Id + ".ini"))
}

# ---------------------------------------------------------------------
#  LA CONVENZIONE DI SENTINELLA, E VALE PER TUTTE LE COLONNE (checklist
#  66): decimali non misurati -1.0 -> "n/d"; interi -1 -> "n/d";
#  profitto -999999 -> "n/d" (il profitto puo' essere negativo, -1 non
#  va bene).
# ---------------------------------------------------------------------
function Fmt2($valore){
  if($null -eq $valore){ return "n/d" }
  if([double]$valore -lt 0){ return "n/d" }
  return ([double]$valore).ToString("0.00",$INV)
}
function Fmt3($valore){
  if($null -eq $valore){ return "n/d" }
  if([double]$valore -lt 0){ return "n/d" }
  return ([double]$valore).ToString("0.000",$INV)
}
function FmtN($valore){
  if($null -eq $valore){ return "n/d" }
  if([int]$valore -lt 0){ return "n/d" }
  return ([int]$valore).ToString($INV)
}
function FmtE($valore){
  if($null -eq $valore){ return "n/d" }
  if([double]$valore -le -999998.0){ return "n/d" }
  return ([double]$valore).ToString("+0;-0;0",$INV)
}
function NumInv($testoNumero){
  $valoreParse = 0.0
  $testoPulito = ("" + $testoNumero).Replace([string][char]160,"").Replace([string][char]8239,"").Replace([string][char]8201,"").Replace(" ","").Trim()
  if($testoPulito -eq ""){ return $null }
  if([double]::TryParse($testoPulito,[Globalization.NumberStyles]::Float,$INV,[ref]$valoreParse)){ return $valoreParse }
  return $null
}
#  ~POSIZIONI dalla n in USCITE: equivalenza MISURATA in R112 par. 3
#  (~2 uscite = 1 posizione). E' una STIMA e si stampa col tilde.
function FmtPos($valoreN){
  if($null -eq $valoreN){ return "n/d" }
  if([int]$valoreN -lt 0){ return "n/d" }
  return ("~" + [math]::Floor([int]$valoreN/2).ToString($INV))
}
#  LA CLASSIFICAZIONE E.2 (criteri par. 4 G1), MECCANICA: e' la
#  tassonomia congelata del campione, NON un verdetto di merito.
function ClasseE2($valoreN){
  if($null -eq $valoreN -or [int]$valoreN -lt 0){ return "n/d" }
  if([int]$valoreN -ge 20){ return "PIENO" }
  if([int]$valoreN -ge 8){ return "SOSPESO" }
  return "NON MIS."
}

# =====================================================================
#  IL PARSER DEL CSV DI OTTIMIZZAZIONE -- STRETTO (checklist 80).
#  L'intestazione VERA, LETTA NEL SORGENTE AL PIN (OnTesterDeinit):
#    Pass,Profit,Expected Payoff,Profit Factor,Recovery Factor,
#    Sharpe Ratio,Equity DD %,Trades,<gli input>
#  OTTO colonne statistiche ESATTE E NELL'ORDINE: se le prime 8 non
#  sono queste, il CSV non e' di questo EA e NON si legge (niente
#  sinonimi: un formato diverso e' una notizia, non un dettaglio).
# =====================================================================
$script:CsvIntestazioni = @()
function LeggiOpt([string]$percorsoCsv){
  if(-not (Test-Path -LiteralPath $percorsoCsv)){ return $null }
  $righeCsv = @()
  try{ $righeCsv = @(Import-Csv -LiteralPath $percorsoCsv) }catch{ return $null }
  if($righeCsv.Count -eq 0){ return $null }
  $nomiColonne = @($righeCsv[0].PSObject.Properties.Name)
  $script:CsvIntestazioni = $nomiColonne
  if($nomiColonne.Count -lt $ColonneOptAttese.Count){ return $null }
  for($iCol=0; $iCol -lt $ColonneOptAttese.Count; $iCol++){
    if(("" + $nomiColonne[$iCol]).Trim() -cne $ColonneOptAttese[$iCol]){ return $null }
  }
  #  E DOPO le 8 statistiche devono venire SUBITO gli input (Inp*):
  #  un OPTFRAME esteso (stile R107, 11 colonne statistiche) ha le
  #  PRIME 8 identiche e ingannerebbe il controllo posizionale da solo.
  #  Formato diverso = EA diverso = non si legge (checklist 80 e 83).
  if($nomiColonne.Count -gt $ColonneOptAttese.Count){
    if(("" + $nomiColonne[$ColonneOptAttese.Count]).Trim() -notlike 'Inp*'){ return $null }
  }
  $elencoLetture = New-Object System.Collections.ArrayList
  foreach($rigaCsv in $righeCsv){
    [void]$elencoLetture.Add([pscustomobject]@{
      Profit = (NumInv $rigaCsv.'Profit')
      Pf     = (NumInv $rigaCsv.'Profit Factor')
      Dd     = (NumInv $rigaCsv.'Equity DD %')
      N      = (NumInv $rigaCsv.'Trades')
    })
  }
  return @($elencoLetture)
}

#  I GEMELLI (G0-C): le due righe identiche al centesimo su profitto,
#  PF, DD e n. E SI PRETENDE CHE SIANO DUE: "una riga sola" e' uno
#  sweep che non ha spazzolato (checklist 55).
function Gemelli($lettureCsv){
  if($null -eq $lettureCsv){ return "NON MISURATO (CSV non letto o intestazione non a 8 colonne attese)" }
  if(@($lettureCsv).Count -ne 2){ return ("NON VALIDO: " + @($lettureCsv).Count + " righe invece di 2") }
  $gemA = $lettureCsv[0]; $gemB = $lettureCsv[1]
  foreach($confronto in @(@("profitto",$gemA.Profit,$gemB.Profit),@("PF",$gemA.Pf,$gemB.Pf),
                          @("DD",$gemA.Dd,$gemB.Dd),@("n",$gemA.N,$gemB.N))){
    if($null -eq $confronto[1] -or $null -eq $confronto[2]){ return ("NON MISURATO (" + $confronto[0] + " illeggibile)") }
    if([math]::Abs([double]$confronto[1] - [double]$confronto[2]) -gt $TolGemelli){
      return ("DIVERSI su " + $confronto[0] + ": " + $confronto[1] + " contro " + $confronto[2])
    }
  }
  return "IDENTICI"
}

# =====================================================================
#  LA FABBRICA DEGLI .ini -- il pezzo NUOVO di R113 (differenza (a)).
#  Struttura COPIATA campo per campo da walkforward_generico.ps1
#  (righe 636-662) + [Charts] MaxBars (iniettato da R112 sul generico).
#  CHECKLIST 79: le date si controllano sugli ARGOMENTI (formato,
#  giorno che esiste, verso) E POI SULL'ARTEFATTO (rilettura del file
#  scritto): il giro a vuoto verifica GLI STESSI .ini della corsa vera
#  (checklist 33).
# =====================================================================
function GeneraIni($cella,$righeInput){
  $percorsoIni = IniDi $cella
  foreach($dataArg in @($cella.Da,$cella.A)){
    if($dataArg -notmatch '^\d{4}\.\d{2}\.\d{2}$'){ throw ("fabbrica .ini " + $cella.Id + ": data [" + $dataArg + "] non e' yyyy.MM.dd (la variabile e' stata sporcata?)") }
    $dataParse = [datetime]::MinValue
    if(-not [datetime]::TryParseExact($dataArg,"yyyy.MM.dd",$INV,[Globalization.DateTimeStyles]::None,[ref]$dataParse)){
      throw ("fabbrica .ini " + $cella.Id + ": data [" + $dataArg + "] non e' un giorno che esiste")
    }
  }
  $dtDaIni = [datetime]::ParseExact($cella.Da,"yyyy.MM.dd",$INV)
  $dtAIni  = [datetime]::ParseExact($cella.A, "yyyy.MM.dd",$INV)
  if($dtAIni -le $dtDaIni){ throw ("fabbrica .ini " + $cella.Id + ": ToDate " + $cella.A + " non e' dopo FromDate " + $cella.Da) }
  $testoInput = (@($righeInput) -join "`r`n")
@"
[Charts]
MaxBars=2000000000

[Experts]
AllowLiveTrading=false
AllowDllImport=false

[Tester]
Expert=$EaNome.ex5
Symbol=$SimboloRound
Period=$PeriodoRound
Model=$Modello
Spread=$SpreadIni
Optimization=1
OptimizationCriterion=6
FromDate=$($cella.Da)
ToDate=$($cella.A)
ForwardMode=0
Deposit=$Deposito
Currency=EUR
Leverage=100
ExecutionMode=0
ReplaceReport=1
ShutdownTerminal=1
Report=OptReport_R113_$($cella.Id)

[TesterInputs]
$testoInput
"@ | Set-Content -LiteralPath $percorsoIni -Encoding ASCII
  # --- GATE SULLO STATO FINALE (checklist 33 e 79): si RILEGGE il file.
  $testoIni = Get-Content -LiteralPath $percorsoIni -Raw
  $guastiIni = New-Object System.Collections.ArrayList
  foreach($rigaAttesa in @(("Symbol=" + $SimboloRound),("Period=" + $PeriodoRound),("Model=" + $Modello),
                           ("Spread=" + $SpreadIni),("FromDate=" + $cella.Da),("ToDate=" + $cella.A),
                           ("Deposit=" + $Deposito),"Leverage=100","Optimization=1","ShutdownTerminal=1")){
    if($testoIni -notmatch ('(?m)^' + [regex]::Escape($rigaAttesa) + '\r?$')){ [void]$guastiIni.Add("manca la riga '" + $rigaAttesa + "'") }
  }
  $numAllowLive = @([regex]::Matches($testoIni,'(?m)^AllowLiveTrading=false\r?$')).Count
  if($numAllowLive -ne 1){ [void]$guastiIni.Add("AllowLiveTrading=false compare " + $numAllowLive + " volte invece di 1") }
  $assiYIni = @([regex]::Matches($testoIni,'(?m)^(\w+)=[^\r\n]*\|\|\s*[Yy]\s*\r?$') | ForEach-Object { $_.Groups[1].Value })
  if($assiYIni.Count -ne 1 -or $assiYIni[0] -ne "InpMagic"){ [void]$guastiIni.Add("assi Y nell'ini: [" + ($assiYIni -join ", ") + "] invece del solo InpMagic") }
  if($testoIni -notmatch ('(?m)^InpMagic=' + $cella.Magic + '\|\|' + $cella.Magic + '\|\|5\|\|' + ($cella.Magic+5) + '\|\|Y\s*\r?$')){
    [void]$guastiIni.Add("InpMagic nell'ini non e' lo sweep " + $cella.Magic + "/" + ($cella.Magic+5) + " a passo 5")
  }
  if($guastiIni.Count -gt 0){
    throw ("l'.ini scritto per " + $cella.Id + " NON e' quello dichiarato: " + ($guastiIni -join " ; ") + ". NON lancio: MT5 non protesta per un .ini storto e produrrebbe numeri PLAUSIBILI su una finestra NON DICHIARATA (checklist 79).")
  }
  return $percorsoIni
}

# =====================================================================
#  LA LISTA DEI LAVORI, dopo il filtro -SoloCella.
#  >>> CHECKLIST 68: se il selettore non corrisponde a nulla NON e'
#      "zero problemi": e' il refuso piu' comune che esista.
#  >>> In R113 NESSUNA cella e' denominatore (niente G0-B): -SoloCella
#      lancia SOLO quella. I gate senza MT5 girano su TUTTI i 18 file.
# =====================================================================
$Lavori = @($CELLE)
if($SoloCella -ne ""){
  $celleScelte = @($Lavori | Where-Object { $_.Prova -eq $SoloCella })
  if($celleScelte.Count -eq 0){
    Write-Host ("!!! -SoloCella " + $SoloCella + " non e' nella lista. Nomi validi:") -ForegroundColor Red
    foreach($cellaElenco in $CELLE){ Write-Host ("      " + $cellaElenco.Prova) -ForegroundColor Yellow }
    exit 1
  }
  $Lavori = $celleScelte
}
if($Lavori.Count -eq 0){ $SelettoreAVuoto = $true }
#  >>> L'ELENCO DEGLI ATTESI NASCE QUI, FUORI E PRIMA DEL try, e NON dentro la
#      catena: se lo si costruisse al passo 4, una corsa fermata al passo 2
#      arriverebbe alla raccolta con $Ordinati VUOTO e il referto direbbe
#      "attesi 0 CSV" con la sezione ATTESI vs TROVATI vuota -- cioe' l'ATTESO
#      si adatterebbe a quanto e' successo, che e' il contrario del suo
#      mestiere. Con le 18 celle qui, una corsa fermata subito stampa 18 righe
#      "NON ESEGUITA" e 18 "MANCA", che e' la verita'.
$Ordinati = @($Lavori | Sort-Object F, Cella)

Write-Host ""
Write-Host "#####################################################################" -ForegroundColor Cyan
Write-Host "#  R113 - PROVA DI REGIME NASUSD_EXT: L'EDGE SHORT VIVE NELLE       #" -ForegroundColor Cyan
Write-Host "#  DISCESE? SupRev NAS H1, OHLC-M1 (modello 1), 6 finestre 2011-22  #" -ForegroundColor Cyan
Write-Host "#####################################################################" -ForegroundColor Cyan
Dico ("pin      : " + $Pin)
Dico ("cartella : " + $Work)

if($SelettoreAVuoto){
  Write-Host ""
  Write-Host "ESITO: SELETTORE A VUOTO -- nessuna cella selezionata, nessun artefatto prodotto." -ForegroundColor Red
  exit 1
}

Titolo "NUMERI ATTESI (dichiarati PRIMA della corsa)"
Write-Host ("    lanci ........................  " + $Lavori.Count + "   (su 18 del round pieno)") -ForegroundColor White
Write-Host ("    CSV attesi ...................  " + $Lavori.Count + "   (UNO per lancio: finestra UNICA, niente split IS/OOS)") -ForegroundColor White
Write-Host ("    righe per CSV ................  " + $CelleAttese + "   (le due gemelle di controllo, magic +5)") -ForegroundColor White
Write-Host ("    passate ......................  " + (2*$Lavori.Count)) -ForegroundColor White
Write-Host ("    banco ........................  OHLC su M1 (modello " + $Modello + ") su " + $SimboloRound + " " + $PeriodoRound) -ForegroundColor White
foreach($finCorr in $FINESTRE){
  Write-Host ("    F" + $finCorr.F + " " + $finCorr.Etichetta.PadRight(13) + $finCorr.Da + " -> " + $finCorr.A + "   " + $finCorr.Giudica) -ForegroundColor White
}
Write-Host ""
Write-Host  "    >>> IL LIMITE COSTITUTIVO (criteri par. 1): NASUSD_EXT e' barre M1" -ForegroundColor Yellow
Write-Host  "    importate, SENZA tick reali BCM. Questi sono dati di un ALTRO broker:" -ForegroundColor Yellow
Write-Host  "    si legge la FORMA (verde/rosso), MAI i numeri fini; confronti SOLO" -ForegroundColor Yellow
Write-Host  "    _EXT-contro-_EXT. G0-EXT superato per firma, bordo sottile 0,199" -ForegroundColor Yellow
Write-Host  "    dichiarato." -ForegroundColor Yellow
Write-Host ""
Write-Host  "    >>> LO SPREAD EFFETTIVO E' *NON MISURATO*, ed e' dichiarato mancante e non" -ForegroundColor Yellow
Write-Host ("    dedotto: Spread=" + $SpreadIni + " nell'ini vuol dire 'spread corrente del simbolo', e su") -ForegroundColor Yellow
Write-Host  "    un CUSTOM il valore vero sta nella config binaria del simbolo. L'importatore" -ForegroundColor Yellow
Write-Host  "    scrive spread=0 in ogni barra M1: il banco POTREBBE essere SENZA ATTRITO." -ForegroundColor Yellow
Write-Host  "    Identico in tutte e 18 le finestre PER COSTRUZIONE (i confronti reggono)," -ForegroundColor Yellow
Write-Host  "    ma va letto prima dei PF. Il referto lo spiega per esteso (checklist 89)." -ForegroundColor Yellow
Write-Host ""
Write-Host  "    >>> QUESTO ROUND NON PROMUOVE NIENTE (G5 per costruzione): produce la" -ForegroundColor Yellow
Write-Host  "    risposta a IPOTESI-S (griglia par. 6, si spunta A MANO nel referto del" -ForegroundColor Yellow
Write-Host  "    round) e la mappa verde/rosso della sedia 970913 su 16 anni." -ForegroundColor Yellow
Write-Host ""
Write-Host  "    >>> NIENTE G0-B (nessun numero da riprodurre su _EXT), NIENTE peggior" -ForegroundColor Yellow
Write-Host  "    giornata e NIENTE per-trade (fuori perimetro)." -ForegroundColor Yellow

if($Pin -eq ""){
  Write-Host ""
  Write-Host "!!! MANCA -Pin. Questa riga gira SOLO su un commit congelato." -ForegroundColor Red
  Write-Host "    Rilancia col blocco intero, che passa -Pin <hash>." -ForegroundColor Yellow
  exit 1
}

try{

# =====================================================================
#  0. MT5 E METAEDITOR CHIUSI. Prima di qualunque altra cosa.
# =====================================================================
$processiVivi = @(Get-Process -Name "terminal64","metaeditor64" -ErrorAction SilentlyContinue)
if($processiVivi.Count -gt 0){
  Write-Host ""
  Write-Host ("!!! APERTO: " + (($processiVivi | ForEach-Object { $_.ProcessName } | Sort-Object -Unique) -join ", ")) -ForegroundColor Red
  Write-Host "    Non parto: col terminale aperto il tester non gira (zero CSV), e con" -ForegroundColor Red
  Write-Host "    MetaEditor aperto la compilazione torna subito senza compilare." -ForegroundColor Red
  Write-Host "    Chiudi MetaTrader E MetaEditor (tutte le istanze) e rilancia." -ForegroundColor Yellow
  #  DICHIARATO: questo exit sta DENTRO il try e SALTA la raccolta. Siamo a
  #  due secondi dal lancio, non e' stato prodotto NIENTE: il messaggio a
  #  schermo E' il referto.
  exit 1
}

New-Item -ItemType Directory -Force -Path $Work,$Prove,$Anten,$Logs,$SrcDir,$Risultati | Out-Null

# =====================================================================
#  0-BIS. LA FIRMA DEI CRITERI. Si LEGGE nell'artefatto, non si ricorda.
#     TRE rami (checklist 82):
#       FIRMATI nel file          -> la corsa parte; -CriteriFirmati, se
#                                    passato, e' INERTE e va detto;
#       NON firmati + switch      -> la corsa parte con la dichiarazione
#                                    "firma data a voce" scritta agli atti;
#       NON firmati senza switch  -> la CORSA VERA esce 2 (il giro a
#                                    vuoto -SoloControllo parte comunque).
#     Il lucchetto si cerca in TUTTO il file, con la stringa COMPOSTA.
# =====================================================================
Titolo "0-BIS. LA FIRMA DEI CRITERI"
$critFile = Join-Path $Work "R113_CRITERI.md"
$daFirmare = $true
try{
  Scarica ("$RawPin/backtest_pipeline/risultati_archivio/R113_CRITERI.md") $critFile 'R113'
  $daFirmare = (Select-String -LiteralPath $critFile -SimpleMatch -Pattern $LucchettoFirma -Quiet)
  $Firma = if($daFirmare){ "NON FIRMATI (il file porta ancora il lucchetto della firma)" } else { "FIRMATI (nessun lucchetto nel file al pin)" }
}catch{
  $Firma = "NON LETTI (" + $_.Exception.Message + ")"
  $daFirmare = $true
}
Dico ("criteri: " + $Firma) $(if($Firma -like "FIRMATI*"){"Green"}else{"Yellow"})
if($daFirmare -and -not $SoloControllo -and -not $CriteriFirmati){
  Write-Host ""
  Write-Host "#####################################################################" -ForegroundColor Red
  Write-Host "#  NON PARTO: I CRITERI DI R113 NON SONO FIRMATI.                   #" -ForegroundColor Red
  Write-Host "#####################################################################" -ForegroundColor Red
  Write-Host "  R113_CRITERI.md porta ancora il lucchetto. Sono OTTO decisioni (par. 9):" -ForegroundColor Yellow
  Write-Host "   D1  perimetro: un motore (SupRev NAS), le 3 celle di R110, congelate" -ForegroundColor Yellow
  Write-Host "   D2  finestre: le sei del par. 3 (LATERALE_NAS 2015-16, VECCHIA 2011-12)" -ForegroundColor Yellow
  Write-Host "   D3  banco: OHLC su M1, spread fisso dichiarato, confronti solo _EXT-vs-_EXT" -ForegroundColor Yellow
  Write-Host "   D4  campione: unita' USCITE, soglie E.2 (20/8), ~2 uscite = 1 posizione" -ForegroundColor Yellow
  Write-Host "   D5  lettura IPOTESI-S pre-dichiarata (par. 6), non si tocca dopo i numeri" -ForegroundColor Yellow
  Write-Host "   D6  rischio G2: sfondamento (2x metro E >20%) -> segnalazione, decide Claudio" -ForegroundColor Yellow
  Write-Host "   D7  magic 763500-763557, gemello +5, 970913 vietato" -ForegroundColor Yellow
  Write-Host "   D8  G5: nessuna promozione da questo round" -ForegroundColor Yellow
  Write-Host "" -ForegroundColor Yellow
  Write-Host "  COSA PUOI FARE ADESSO, in ordine:" -ForegroundColor Yellow
  Write-Host "   1. il GIRO A VUOTO gira lo stesso: rilancia con -SoloControllo." -ForegroundColor Yellow
  Write-Host "   2. leggi R113_CRITERI.md par. 9 e rispondi alle otto decisioni." -ForegroundColor Yellow
  Write-Host "   3. quando hai firmato: si toglie il lucchetto dal file (da TUTTO il" -ForegroundColor Yellow
  Write-Host "      file), oppure si rilancia aggiungendo -CriteriFirmati (la firma in" -ForegroundColor Yellow
  Write-Host "      riga, che finisce scritta nel referto)." -ForegroundColor Yellow
  Write-Host ""
  exit 2
}
if($daFirmare -and $CriteriFirmati){
  [void]$Rilievi.Add("I criteri portano ancora il lucchetto nel file, ma la corsa e' partita con -CriteriFirmati: la firma e' quella data in riga da Claudio. VA SCRITTO NEL REFERTO DEL ROUND.")
  Dico "corsa autorizzata da -CriteriFirmati (il file porta ancora il lucchetto)" "Yellow"
}
if(-not $daFirmare -and $CriteriFirmati){
  Dico "-CriteriFirmati e' INERTE: i criteri risultano gia' FIRMATI NEL FILE al pin. La firma agli atti e' quella del documento, non una firma in riga." "Yellow"
}

# =====================================================================
#  1. SCARICO AL PIN. NIENTE walkforward_generico: gli .ini li scrive
#     questa riga (differenza (a)). I gate girano su TUTTI i 18 file,
#     anche con -SoloCella: non serve MT5 e la corruzione non aspetta.
# =====================================================================
Titolo "1. SCARICO AL PIN"
foreach($cellaCorr in $CELLE){
  Scarica ("$RawPin/backtest_pipeline/prove/" + $cellaCorr.Prova) (Join-Path $Prove $cellaCorr.Prova) '@SIMBOLO'
}
$antenatiUnici = @($CELLE | ForEach-Object { $_.AntFile } | Sort-Object -Unique)
foreach($nomeAntenato in $antenatiUnici){
  Scarica ("$RawPin/backtest_pipeline/prove/" + $nomeAntenato) (Join-Path $Anten $nomeAntenato) '@SIMBOLO'
}
foreach($cellaCorr in $CELLE){
  $righeViveProva = RigheVive (Join-Path $Prove $cellaCorr.Prova)
  if($righeViveProva.Count -ne $RigheViveProvaAtt){
    throw ($cellaCorr.Prova + " ha " + $righeViveProva.Count + " righe vive invece di " + $RigheViveProvaAtt + ": artefatto cambiato, mi fermo.")
  }
  $Vive[$cellaCorr.Prova] = $righeViveProva
}
foreach($nomeAntenato in $antenatiUnici){
  $righeViveAnt = RigheVive (Join-Path $Anten $nomeAntenato)
  if($righeViveAnt.Count -ne $RigheViveAntenatoAtt){
    throw ("l'antenato " + $nomeAntenato + " ha " + $righeViveAnt.Count + " righe vive invece di " + $RigheViveAntenatoAtt + ": artefatto cambiato, mi fermo.")
  }
}
Dico ("18 file prova R113 + " + $antenatiUnici.Count + " antenati R110_SUPNAS scaricati al pin, righe vive verificate (46 / 45)") "Green"

# --- 1a. IL GATE DELL'ANTENATO (checklist 72). Catena R103 -> R110 ->
#     R113. Confronto PER NOME, mai per posizione. Delta ammessi:
#     @SIMBOLO + @DAQUANDO + InpMagic; riga NUOVA ammessa: @FINOA.
foreach($cellaCorr in $CELLE){
  $mappaAntenato = MappaDi (RigheVive (Join-Path $Anten $cellaCorr.AntFile))
  $mappaCella    = MappaDi $Vive[$cellaCorr.Prova]
  $guastiAntenato = New-Object System.Collections.ArrayList
  foreach($chiaveAnt in @($mappaAntenato.Keys)){
    if(-not $mappaCella.ContainsKey($chiaveAnt)){ [void]$guastiAntenato.Add("manca la riga '" + $chiaveAnt + "' che l'antenato ha") ; continue }
    if($mappaAntenato[$chiaveAnt] -ne $mappaCella[$chiaveAnt] -and $DeltaAmmessi -notcontains $chiaveAnt){
      [void]$guastiAntenato.Add("'" + $chiaveAnt + "' vale [" + $mappaCella[$chiaveAnt] + "] ma nell'antenato vale [" + $mappaAntenato[$chiaveAnt] + "]")
    }
  }
  foreach($chiaveCella in @($mappaCella.Keys)){
    if(-not $mappaAntenato.ContainsKey($chiaveCella) -and $RigheNuoveAmm -notcontains $chiaveCella){
      [void]$guastiAntenato.Add("ha la riga '" + $chiaveCella + "' che l'antenato NON ha e che non e' fra le nuove ammesse")
    }
  }
  #  e i delta ammessi devono ESSERCI DAVVERO: un @SIMBOLO che NON
  #  differisce vorrebbe dire che la cella gira sul feed BCM vero.
  foreach($chiaveDelta in @("@SIMBOLO","@DAQUANDO")){
    if($mappaAntenato.ContainsKey($chiaveDelta) -and $mappaCella.ContainsKey($chiaveDelta) -and $mappaAntenato[$chiaveDelta] -eq $mappaCella[$chiaveDelta]){
      [void]$guastiAntenato.Add("'" + $chiaveDelta + "' e' UGUALE all'antenato ([" + $mappaCella[$chiaveDelta] + "]) ma questa cella deve muoverlo")
    }
  }
  foreach($chiaveNuova in $RigheNuoveAmm){
    if(-not $mappaCella.ContainsKey($chiaveNuova)){ [void]$guastiAntenato.Add("manca la riga nuova '" + $chiaveNuova + "' (la data di fine finestra e' parte dell'identita' della cella)") }
  }
  if($guastiAntenato.Count -gt 0){
    throw ("GATE DELL'ANTENATO FALLITO su " + $cellaCorr.Prova + " contro prove\" + $cellaCorr.AntFile + ": " + ($guastiAntenato -join " ; ") +
           ". La frase 'il corpo e' copiato riga per riga da R110' e' un GATE, non un commento: se non torna, questo round girerebbe su un motore diverso da quello che sta sui soldi.")
  }
  $cellaCorr.Antenato = "OK contro " + $cellaCorr.AntFile + " (delta: " + (($DeltaAmmessi | Sort-Object) -join " + ") + "; riga nuova: " + (($RigheNuoveAmm | Sort-Object) -join " + ") + ")"
}
Dico "gate dell'ANTENATO: ogni cella e' la copia riga per riga del suo file prova R110_SUPNAS, salvo i delta dichiarati (catena R103 -> R110 -> R113)" "Green"

# --- 1b. IL GATE DELLA STELLA, PER FINESTRA: long e short si
#     confrontano col 00_metro della STESSA finestra e devono differire
#     ESATTAMENTE su DiffStella + InpMagic. Confronto POSIZIONALE, e
#     regge perche' i file hanno lo stesso ordine (righe vive contate).
foreach($finCorr in $FINESTRE){
  $celleFinestra = @($CELLE | Where-Object { $_.F -eq $finCorr.F })
  $cellaMetro = @($celleFinestra | Where-Object { $_.Metro })
  if($cellaMetro.Count -ne 1){ throw ("finestra F" + $finCorr.F + ": trovate " + $cellaMetro.Count + " celle 00_metro invece di 1.") }
  $righeMetro = $Vive[$cellaMetro[0].Prova]
  foreach($cellaCorr in @($celleFinestra | Where-Object { -not $_.Metro })){
    $righeCella = $Vive[$cellaCorr.Prova]
    if($righeMetro.Count -ne $righeCella.Count){ throw ($cellaCorr.Prova + ": " + $righeCella.Count + " righe vive contro " + $righeMetro.Count + " del metro di finestra. Non sono confrontabili.") }
    $nomiDiversi = New-Object System.Collections.ArrayList
    for($iRigaViva=0; $iRigaViva -lt $righeMetro.Count; $iRigaViva++){
      if($righeMetro[$iRigaViva] -ne $righeCella[$iRigaViva]){ [void]$nomiDiversi.Add((NomeDi $righeMetro[$iRigaViva])) }
    }
    $diffAttesi = @($cellaCorr.DiffStella) + @("InpMagic")
    $diffMancanti = @($diffAttesi   | Where-Object { $nomiDiversi -notcontains $_ })
    $diffExtra    = @($nomiDiversi  | Where-Object { $diffAttesi  -notcontains $_ })
    if($diffMancanti.Count -gt 0 -or $diffExtra.Count -gt 0){
      throw ($cellaCorr.Prova + " contro " + $cellaMetro[0].Prova + ": differiscono su [" + ($nomiDiversi -join ", ") +
             "] invece che su [" + ($diffAttesi -join ", ") + "]. R113 pretende che dentro una finestra cambi SOLO il lato (piu' il magic): cosi' il numero e' attribuibile al LATO e a nient'altro.")
    }
  }
}
Dico "gate della STELLA: dentro ogni finestra, long e short differiscono dal metro SOLO sul lato dichiarato (+ magic)" "Green"

# --- 1c. I VALORI, letti NELL'ARTEFATTO CHE GIRA (checklist 34-bis):
#     geometria d'identita' + lati della cella + @SIMBOLO/@PERIODO +
#     @DAQUANDO/@FINOA contro la tabella congelata + asse unico + magic.
#     >>> OGNI $ DI UNA REGEX MULTILINEA SI SCRIVE \r?$ (checklist 40).
$magicVisti = @()
foreach($cellaCorr in $CELLE){
  $testoProva = Get-Content -LiteralPath (Join-Path $Prove $cellaCorr.Prova) -Raw
  foreach($vincolo in $GeometriaViva){
    $regexVincolo = '(?m)^' + $vincolo[0] + '=' + [regex]::Escape($vincolo[1]) + '\|\|'
    if($testoProva -notmatch $regexVincolo){
      throw ($cellaCorr.Prova + ": non trovo '" + $vincolo[0] + "=" + $vincolo[1] + "'. Questa NON e' la cella dei criteri par. 2: il round girerebbe sopra un motore che non e' quello della sedia.")
    }
  }
  foreach($vincoloPiatto in $GeometriaPiatta){
    $regexPiatto = '(?m)^' + $vincoloPiatto[0] + '=' + [regex]::Escape($vincoloPiatto[1]) + '\s*\r?$'
    if($testoProva -notmatch $regexPiatto){
      throw ($cellaCorr.Prova + ": la riga '" + $vincoloPiatto[0] + "=" + $vincoloPiatto[1] + "' non c'e' o e' cambiata.")
    }
  }
  foreach($chiaveVal in $cellaCorr.Val.Keys){
    $regexVal = '(?m)^' + $chiaveVal + '=' + [regex]::Escape($cellaCorr.Val[$chiaveVal]) + '\|\|'
    if($testoProva -notmatch $regexVal){ throw ($cellaCorr.Prova + ": " + $chiaveVal + " non vale " + $cellaCorr.Val[$chiaveVal] + ". La cella non e' quella che credo: il LATO e' l'asse del round.") }
  }
  $matchSimbolo = [regex]::Match($testoProva,'(?m)^@SIMBOLO\s+(\S+)')
  if(-not $matchSimbolo.Success -or $matchSimbolo.Groups[1].Value -ne $SimboloRound){ throw ($cellaCorr.Prova + ": @SIMBOLO non e' " + $SimboloRound) }
  $matchPeriodo = [regex]::Match($testoProva,'(?m)^@PERIODO\s+(\S+)')
  if(-not $matchPeriodo.Success -or $matchPeriodo.Groups[1].Value -ne $PeriodoRound){ throw ($cellaCorr.Prova + ": @PERIODO non e' " + $PeriodoRound + " (il TF del GRAFICO nel tester, che NON si deriva da InpTF: trappola di R102).") }
  $matchDaQuando = [regex]::Match($testoProva,'(?m)^@DAQUANDO\s+([0-9]{4}\.[0-9]{2}\.[0-9]{2})')
  if(-not $matchDaQuando.Success -or $matchDaQuando.Groups[1].Value -ne $cellaCorr.Da){ throw ($cellaCorr.Prova + ": @DAQUANDO e' [" + $matchDaQuando.Groups[1].Value + "] invece di " + $cellaCorr.Da + " (finestra F" + $cellaCorr.F + " " + $cellaCorr.Etichetta + " dei criteri par. 3)") }
  $matchFinoA = [regex]::Match($testoProva,'(?m)^@FINOA\s+([0-9]{4}\.[0-9]{2}\.[0-9]{2})')
  if(-not $matchFinoA.Success -or $matchFinoA.Groups[1].Value -ne $cellaCorr.A){ throw ($cellaCorr.Prova + ": @FINOA e' [" + $matchFinoA.Groups[1].Value + "] invece di " + $cellaCorr.A + " (finestra F" + $cellaCorr.F + " " + $cellaCorr.Etichetta + " dei criteri par. 3)") }
  $assiY = @([regex]::Matches($testoProva,'(?m)^(\w+)=[^\r\n]*\|\|\s*[Yy]\s*\r?$') | ForEach-Object { $_.Groups[1].Value })
  if($assiY.Count -ne 1 -or $assiY[0] -ne "InpMagic"){
    throw ($cellaCorr.Prova + ": gli assi spazzolati sono [" + ($assiY -join ", ") + "] invece del solo InpMagic. R113 NON ottimizza niente: cambiano finestra e lato FRA le celle, mai DENTRO una cella.")
  }
  $matchMagic = [regex]::Match($testoProva,'(?m)^InpMagic=(\d+)\|\|(\d+)\|\|5\|\|(\d+)\|\|Y')
  if(-not $matchMagic.Success){ throw ($cellaCorr.Prova + ": InpMagic non e' nella forma sweep 'v||v||5||v+5||Y' (gemello +5, criteri par. 5).") }
  $magicBaseLetto = [int]$matchMagic.Groups[1].Value; $magicGemLetto = [int]$matchMagic.Groups[3].Value
  if($magicBaseLetto -ne [int]$cellaCorr.Magic){ throw ($cellaCorr.Prova + ": InpMagic e' " + $magicBaseLetto + " ma questa cella deve girare su " + $cellaCorr.Magic + " (schema 763500 + F*10 + C)") }
  if($magicGemLetto -ne ($magicBaseLetto+5)){ throw ($cellaCorr.Prova + ": il gemello e' " + $magicGemLetto + " invece di " + ($magicBaseLetto+5)) }
  foreach($magicDaVagliare in @($magicBaseLetto,$magicGemLetto)){
    if($magicVisti -contains $magicDaVagliare){ throw ($cellaCorr.Prova + ": magic " + $magicDaVagliare + " gia' usato da un altro file prova. Due file con lo stesso magic non sono distinguibili nel CSV.") }
    if(MagicVietato $magicDaVagliare){ throw ($cellaCorr.Prova + ": il magic " + $magicDaVagliare + " e' VIETATO (sedia viva 970913, o blocchi bruciati 7633xx/7634xx). Fermo tutto.") }
    $magicVisti += $magicDaVagliare
  }
}
Dico ("geometria d'identita', TF del grafico, LATI, finestre @DAQUANDO/@FINOA, asse unico e " + $magicVisti.Count + " magic vergini verificati NEI FILE") "Green"

# --- 1d. IL SORGENTE E IL GATE DI VERSIONE. E il pezzo R113 (checklist
#     80): l'intestazione OPTFRAME a 8 colonne deve esistere NEL
#     SORGENTE AL PIN, perche' il parser di questo driver pretende
#     ESATTAMENTE quelle colonne.
$srcMq5 = Join-Path $SrcDir ($EaNome + ".mq5")
Scarica ("$RawPin/mql5/Experts/" + $EaNome + ".mq5") $srcMq5 'ABTG_GuardiaIngresso'
$testoSorgente = Get-Content -LiteralPath $srcMq5 -Raw
$matchVersione = [regex]::Match($testoSorgente,'#property\s+version\s+"([^"]+)"')
if(-not $matchVersione.Success){ throw ($EaNome + ".mq5 scaricato senza #property version: non e' il sorgente che credo.") }
if($matchVersione.Groups[1].Value -ne $EaVersione){
  throw ($EaNome + ".mq5 dichiara version '" + $matchVersione.Groups[1].Value + "' invece di '" + $EaVersione + "'. O la cache di raw.githubusercontent serve una copia vecchia, o il pin e' sbagliato: mi fermo.")
}
if($testoSorgente -notmatch ('(?m)^input\s+long\s+InpMagic\s*=\s*' + $MagicSorgente + '\s*;')){
  throw ($EaNome + ".mq5 non dichiara 'input long InpMagic = " + $MagicSorgente + ";': non e' il motore di questa sedia. (970913 e' il magic del SORGENTE e della SEDIA; qui girano i vergini 7635xx.)")
}
foreach($inputAtteso in @("InpAllowLong","InpAllowShort")){
  if($testoSorgente -notmatch ('(?m)^input\s+bool\s+' + $inputAtteso + '\s*=')){ throw ($EaNome + ".mq5 non ha l'input " + $inputAtteso + ": senza i due lati non c'e' la domanda del round, e questo round NON tocca il codice degli EA.") }
}
if($testoSorgente -notmatch [regex]::Escape('"Pass,Profit,Expected Payoff,Profit Factor,Recovery Factor,Sharpe Ratio,Equity DD %,Trades"')){
  throw ($EaNome + ".mq5 non scrive l'intestazione OPTFRAME a 8 colonne attesa: il parser di questo driver leggerebbe un formato diverso (checklist 80). Mi fermo PRIMA di produrre CSV illeggibili.")
}
Dico ($EaNome + ".mq5 al pin, version " + $matchVersione.Groups[1].Value + ", InpMagic sorgente " + $MagicSorgente + ", due lati + intestazione OPTFRAME a 8 colonne VERIFICATI NEL SORGENTE") "Green"
Dico "(l'EA scrive anche i per-trade abtg_trades_* in Common\Files: FUORI PERIMETRO in R113, questo driver non li tocca)" "Gray"

# =====================================================================
#  2. TERMINALE, CARTELLA DATI E SIMBOLO CUSTOM (per NOME, mai il
#     primo che capita -- checklist 37; simbolo: checklist 83)
# =====================================================================
Titolo "2. TERMINALE, CARTELLA DATI E SIMBOLO CUSTOM"
$terminaliTrovati = @(Get-ChildItem "C:\Program Files","C:\Program Files (x86)" -Recurse -Filter "terminal64.exe" -ErrorAction SilentlyContinue)
$terminaliBcm  = @($terminaliTrovati | Where-Object { $_.DirectoryName -like "*BCM Markets MT5 Terminal*" -and $_.DirectoryName -notlike "*-V3*" })
if($terminaliBcm.Count -eq 0){ throw "non trovo il terminale 'BCM Markets MT5 Terminal' (quello NON -V3). Non tiro a indovinare." }
if($terminaliBcm.Count -gt 1){ throw ("trovati " + $terminaliBcm.Count + " terminali che corrispondono: ambiguo, mi fermo.") }
$InstDir    = $terminaliBcm[0].DirectoryName
$Terminal   = Join-Path $InstDir "terminal64.exe"
$MetaEditor = Join-Path $InstDir "metaeditor64.exe"
if(-not (Test-Path -LiteralPath $MetaEditor)){ throw ("manca metaeditor64.exe in " + $InstDir) }
$TermRoot = Join-Path $env:APPDATA "MetaQuotes\Terminal"
$DataFolder = Get-ChildItem $TermRoot -Directory -ErrorAction SilentlyContinue | Where-Object {
    $originFile = Join-Path $_.FullName "origin.txt"
    (Test-Path $originFile) -and ((Get-Content $originFile -Raw).Trim() -ieq $InstDir)
  } | Select-Object -First 1 -ExpandProperty FullName
if(-not $DataFolder){ throw "cartella dati MT5 non trovata (origin.txt non punta a nessuna cartella)." }
$MqlExperts = Join-Path $DataFolder "MQL5\Experts"
$MqlInclude = Join-Path $DataFolder "MQL5\Include"
$MqlFiles   = Join-Path $DataFolder "MQL5\Files"
New-Item -ItemType Directory -Force -Path $MqlExperts,$MqlInclude,$Sosta | Out-Null
Dico ("terminale : " + $Terminal)
Dico ("dati      : " + $DataFolder + "   (DEVE restare lo stesso in tutti i passi)")

# --- 2a. IL SIMBOLO CUSTOM ESISTE? (checklist 83: PRIMA di aprire MT5.)
#     Le barre dei simboli costruiti stanno in bases\Custom\history\
#     <SIMBOLO> (lezione della diagnosi 14/08: il livello giusto e'
#     quello del simbolo, non i contenitori history/ticks).
$cartellaSimbolo = Join-Path $DataFolder ("bases\Custom\history\" + $SimboloRound)
if(-not (Test-Path -LiteralPath $cartellaSimbolo)){
  $msgSimbolo = ($SimboloRound + " non trovato: va reimportato con la Riga 2 dello storico (importa_storico_esterno.ps1, referto STORICO_INDICI). Cercato in: " + $cartellaSimbolo)
  if($SoloControllo){
    [void]$Problemi.Add("SIMBOLO CUSTOM MANCANTE -- " + $msgSimbolo + ". Il giro a vuoto continua (non serve MT5), ma la corsa vera si fermerebbe qui.")
    Dico ("simbolo   : MANCANTE -- " + $msgSimbolo) "Red"
  } else {
    throw $msgSimbolo
  }
} else {
  $pesoSimbolo = [math]::Round(((Get-ChildItem -LiteralPath $cartellaSimbolo -Recurse -File -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum / 1MB),1)
  Dico ("simbolo   : " + $SimboloRound + " trovato (" + $pesoSimbolo.ToString("0.0",$INV) + " MB in bases\Custom\history). ATTENZIONE: le barre NON bastano da sole -- se il tester dicesse 'symbol not exist', la REGISTRAZIONE del simbolo e' andata persa (terminale ammazzato invece che chiuso il 14/08): si riapre MT5 una volta a mano o si rifa' la Riga 2.") "Green"
}

# --- 2b. LA SOSTA SI SVUOTA A OGNI GIRO (checklist 56), contando PRIMA
#     e DOPO (checklist 69).
$numSostaPrima = @(Get-ChildItem -LiteralPath $Sosta -File -ErrorAction SilentlyContinue).Count
if($numSostaPrima -gt 0){
  Get-ChildItem -LiteralPath $Sosta -File -ErrorAction SilentlyContinue | Remove-Item -Force -ErrorAction SilentlyContinue
  $numSostaDopo = @(Get-ChildItem -LiteralPath $Sosta -File -ErrorAction SilentlyContinue).Count
  if($numSostaDopo -gt 0){
    [void]$Problemi.Add("sosta: " + $numSostaDopo + " file su " + $numSostaPrima + " di un giro PRECEDENTE non sono stati cancellati. Possono finire nello zip di questo round spacciandosi per artefatti di adesso: controllare le date dentro lo zip prima di leggerlo.")
  }
  Dico ("sosta svuotata: " + $numSostaPrima + " file di un giro precedente rimossi (rimasti: " + $numSostaDopo + ")") "Green"
}

# --- 2c. LA MEMORIA DEL TESTER PER QUESTO EA (trappola n.1 di
#     prova_regime): MT5 ricorda i flag di ottimizzazione dell'ultima
#     griglia in MQL5\Profiles\Tester\<EA>.set. Qui blindiamo TUTTI gli
#     input in [TesterInputs] (come walkforward), ma buttare il ricordo
#     costa zero e chiude anche quella porta. NON e' un artefatto di
#     risultato: la checklist 88 non c'entra, si puo' fare una volta.
$ricordoTester = Join-Path $DataFolder ("MQL5\Profiles\Tester\" + $EaNome + ".set")
if(Test-Path -LiteralPath $ricordoTester){
  Remove-Item -LiteralPath $ricordoTester -Force -ErrorAction SilentlyContinue
  Dico ("buttata la memoria del tester per " + $EaNome + " (Profiles\Tester\*.set)") "DarkYellow"
}

# --- 2d. L'INCLUDE CHE NESSUN DRIVER INSTALLA (checklist 33-bis).
$includeGuardian = Join-Path $MqlInclude "ABTG_PausaGuardian.mqh"
Scarica ("$RawPin/mql5/Include/ABTG_PausaGuardian.mqh") $includeGuardian 'ABTG_GuardiaIngresso'
$includeInfo = Get-Item -LiteralPath $includeGuardian
if($includeInfo.PSIsContainer){ throw "ABTG_PausaGuardian.mqh: in Include c'e' una CARTELLA con quel nome (checklist 27-ter)." }
if($includeInfo.Length -lt 4000){ throw ("ABTG_PausaGuardian.mqh e' lungo " + $includeInfo.Length + " byte: troppo poco, scarico monco.") }
Dico ("include installato: ABTG_PausaGuardian.mqh (" + $includeInfo.Length + " byte)") "Green"

# =====================================================================
#  3. FASE COMPILA (un solo EA). Si fa ANCHE in -SoloControllo
#     (checklist 39). Invocazione DIRETTA di metaeditor64.exe, verdetto
#     sul LastWriteTime del .ex5, backup datato, ripristino se fallisce.
# =====================================================================
Titolo "3. FASE COMPILA"
$mq5Destinazione = Join-Path $MqlExperts ($EaNome + ".mq5")
$ex5Destinazione = Join-Path $MqlExperts ($EaNome + ".ex5")
$logCompilatore  = Join-Path $MqlExperts ($EaNome + ".log")
$backupMq5 = $mq5Destinazione + ".prima_r113_" + $Stamp
$backupEx5 = $ex5Destinazione + ".prima_r113_" + $Stamp
if((Test-Path -LiteralPath $mq5Destinazione) -and -not (Test-Path -LiteralPath $backupMq5)){ Copy-Item -LiteralPath $mq5Destinazione -Destination $backupMq5 -Force }
if((Test-Path -LiteralPath $ex5Destinazione) -and -not (Test-Path -LiteralPath $backupEx5)){ Copy-Item -LiteralPath $ex5Destinazione -Destination $backupEx5 -Force }
Copy-Item -LiteralPath $srcMq5 -Destination $mq5Destinazione -Force
$lunghezzaSorgente = (Get-Item -LiteralPath $srcMq5).Length
$copiaVerifica = Get-Item -LiteralPath $mq5Destinazione -ErrorAction SilentlyContinue
if(-not $copiaVerifica -or $copiaVerifica.PSIsContainer -or $copiaVerifica.Length -ne $lunghezzaSorgente){ throw ("copia di " + $EaNome + ".mq5 in MQL5\Experts NON verificata (lunghezza diversa o e' una cartella).") }
$ex5Prima = (Get-Date).AddYears(-100)
if(Test-Path -LiteralPath $ex5Destinazione){ $ex5Prima = (Get-Item -LiteralPath $ex5Destinazione).LastWriteTime }
Remove-Item -LiteralPath $logCompilatore -Force -ErrorAction SilentlyContinue
& $MetaEditor "/compile:$mq5Destinazione" "/log:$logCompilatore" | Out-Null
$rcMetaEditor = $LASTEXITCODE
$ex5Dopo = $null
if(Test-Path -LiteralPath $ex5Destinazione){ $ex5Dopo = (Get-Item -LiteralPath $ex5Destinazione).LastWriteTime }
$compilazioneOk = ($null -ne $ex5Dopo) -and ($ex5Dopo -gt $ex5Prima)
$testoLogCompilatore = ""
if(Test-Path -LiteralPath $logCompilatore){
  try{ $testoLogCompilatore = (Get-Content -LiteralPath $logCompilatore -Raw -Encoding Unicode) }catch{ $testoLogCompilatore = "" }
  if($testoLogCompilatore -notmatch '(?i)error'){ try{ $testoLogCompilatore = (Get-Content -LiteralPath $logCompilatore -Raw) }catch{} }
  Copy-Item -LiteralPath $logCompilatore -Destination (Join-Path $Sosta ("compile_SUPNAS.log")) -Force -ErrorAction SilentlyContinue
}
if(-not $compilazioneOk){
  if($testoLogCompilatore -ne ""){
    Write-Host "--- log del compilatore (ultime righe) ---" -ForegroundColor DarkYellow
    foreach($rigaLog in @($testoLogCompilatore -split "\r?\n" | Select-Object -Last 20)){ Write-Host ("   " + $rigaLog) -ForegroundColor DarkYellow }
  } else { Write-Host "   (nessun log prodotto da MetaEditor)" -ForegroundColor DarkYellow }
  #  sorgente e binario devono restare la STESSA versione (checklist 54):
  #  qui il .ex5 e' quello di una SEDIA VIVA sul 100k.
  if(Test-Path -LiteralPath $backupMq5){ Copy-Item -LiteralPath $backupMq5 -Destination $mq5Destinazione -Force }
  throw ("COMPILAZIONE FALLITA per " + $EaNome + " (metaeditor rc=" + $rcMetaEditor + ", .ex5 NON riscritto). Il .mq5 e' stato rimesso com'era e il log e' nello zip. Sospetto n.1: include mancante o MetaEditor gia' aperto.")
}
$matchWarning = [regex]::Match($testoLogCompilatore,'(?i)(\d+)\s+warning')
if($matchWarning.Success -and [int]$matchWarning.Groups[1].Value -gt 0){
  [void]$Rilievi.Add("compilazione " + $EaNome + ": " + $matchWarning.Groups[1].Value + " warning (0 errori). Non fermano il round, ma vanno letti nel log dello zip.")
}
$EaCompilato = $true
Dico ("COMPILATO " + $EaNome + " v" + $EaVersione + " (.ex5 riscritto adesso, rc=" + $rcMetaEditor + ")") "Green"

# =====================================================================
#  4. LA CATENA. 18 lanci (o quelli scelti), UNO alla volta, F0 -> F5,
#     dentro ogni finestra metro -> long -> short. Nessun lancio
#     dipende da un altro: un guasto ferma QUELLA cella, non la catena.
# =====================================================================
Titolo ("4. LA CATENA - " + $Lavori.Count + " lanci, uno alla volta")
#  $Ordinati e' gia' pronto da PRIMA del try (vedi il commento la' sopra).
$csvStaging = Join-Path $MqlFiles ("OptResults_" + $EaNome + "_" + $SimboloRound + ".csv")
$indiceCella = 0
foreach($cellaCorr in $Ordinati){
  $indiceCella++
  $oreTrascorse = (New-TimeSpan -Start $Avvio -End (Get-Date)).TotalHours
  if($oreTrascorse -ge $OreMax){
    $cellaCorr.Esito = "NON INIZIATA (tetto ore raggiunto)"
    [void]$Problemi.Add("TEMPO SCADUTO prima di " + $cellaCorr.Prova + ": il round NON e' completo. Riprendi con -SoloCella " + $cellaCorr.Prova + ".")
    continue
  }
  Write-Host ""
  Write-Host "------------------------------------------------------------------" -ForegroundColor Cyan
  Write-Host ("  [" + $indiceCella + "/" + $Ordinati.Count + "]  " + $cellaCorr.Prova + "   F" + $cellaCorr.F + " " + $cellaCorr.Etichetta + " " + $cellaCorr.Da + " -> " + $cellaCorr.A) -ForegroundColor Cyan
  Write-Host ("           " + $cellaCorr.Desc + "   [giudica: " + $cellaCorr.Giudica + "]") -ForegroundColor Cyan
  Write-Host "------------------------------------------------------------------" -ForegroundColor Cyan
  $avvioCella = Get-Date
  #  >>> CHECKLIST 79: LA FINESTRA SI RICONTROLLA QUI, UN ISTANTE PRIMA
  #      DI USARLA, contro il SECONDO deposito letterale. E il valore
  #      sporco si TRONCA prima di stamparlo.
  $finestraAttesa = $FinestreLetterali[$cellaCorr.F]
  $finestraLetta  = ("" + $cellaCorr.Da + "|" + $cellaCorr.A)
  if($finestraLetta -ne $finestraAttesa){
    if($finestraLetta.Length -gt 60){ $finestraLetta = $finestraLetta.Substring(0,60) + " ...[+" + ($finestraLetta.Length-60) + " caratteri: la variabile e' diventata un ARRAY]" }
    throw ("LA FINESTRA E' STATA SPORCATA prima di " + $cellaCorr.Prova + ": [" + $finestraLetta + "] invece di [" + $finestraAttesa +
           "]. NON lancio: MT5 non protesta per una data storta e produrrebbe numeri PLAUSIBILI su una finestra NON DICHIARATA (checklist 79).")
  }
  Write-Host ("           finestra: " + $cellaCorr.Da + " -> " + $cellaCorr.A + "   (ricontrollata adesso sul secondo deposito, non solo dichiarata in testa)") -ForegroundColor Gray

  $percorsoCsv = CsvDi $cellaCorr
  # ---------- CELLA GIA' FATTA (checklist 88, corollario): il CSV di un
  #  giro precedente NON si cancella e NON si pretende fresco: si
  #  RACCOGLIE con l'eta' dichiarata. Si rifa' solo con -Rifai.
  if((Test-Path -LiteralPath $percorsoCsv) -and -not $Rifai -and -not $SoloControllo){
    $etaCsvVecchio = (Get-Item -LiteralPath $percorsoCsv).LastWriteTime
    $cellaCorr.EtaCsv = $etaCsvVecchio.ToString("yyyy-MM-dd HH:mm:ss",$INV)
    $cellaCorr.Esito = "GIA' FATTA (CSV del " + $cellaCorr.EtaCsv + " ora del PC, NON di questo lancio)"
    [void]$Rilievi.Add($cellaCorr.Prova + ": " + $cellaCorr.Esito + ". Raccolto con l'eta' dichiarata (checklist 88); per rifarlo: -Rifai.")
    $lettureVecchie = LeggiOpt $percorsoCsv
    $cellaCorr.Gemelli = Gemelli $lettureVecchie
    if($null -ne $lettureVecchie -and @($lettureVecchie).Count -ge 1){
      $cellaCorr.Righe = @($lettureVecchie).Count
      if($null -ne $lettureVecchie[0].Pf){     $cellaCorr.Pf   = [double]$lettureVecchie[0].Pf }
      if($null -ne $lettureVecchie[0].Dd){     $cellaCorr.Dd   = [double]$lettureVecchie[0].Dd }
      if($null -ne $lettureVecchie[0].N){      $cellaCorr.N    = [int]$lettureVecchie[0].N }
      if($null -ne $lettureVecchie[0].Profit){ $cellaCorr.Prof = [double]$lettureVecchie[0].Profit }
    }
    Write-Host ("    esito: " + $cellaCorr.Esito) -ForegroundColor DarkYellow
    continue
  }

  # ---------- PULIZIA PER CELLA (checklist 88): SOLO adesso, SOLO per
  #  questa cella, SOLO se si corre davvero. OptResults di staging e
  #  Tester\cache, contati prima e dopo. MAI bases\<server>\ticks,
  #  MAI bases\Custom, MAI la cartella comune (fuori perimetro).
  if(-not $SoloControllo){
    if(Test-Path -LiteralPath $csvStaging){
      Remove-Item -LiteralPath $csvStaging -Force -ErrorAction SilentlyContinue
      if(Test-Path -LiteralPath $csvStaging){
        [void]$Problemi.Add($cellaCorr.Prova + ": NON sono riuscito a cancellare il file di staging " + $csvStaging + " (qualcuno lo tiene aperto). Il CSV che uscira' va confrontato con la sua data.")
      }
    }
    $cacheTester = Join-Path $DataFolder "Tester\cache"
    if(Test-Path -LiteralPath $cacheTester){
      $numCachePrima = @(Get-ChildItem -LiteralPath $cacheTester -Force -Recurse -File -ErrorAction SilentlyContinue).Count
      Get-ChildItem -LiteralPath $cacheTester -Force -ErrorAction SilentlyContinue | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
      $numCacheDopo = @(Get-ChildItem -LiteralPath $cacheTester -Force -Recurse -File -ErrorAction SilentlyContinue).Count
      if($numCacheDopo -gt 0){
        [void]$Problemi.Add($cellaCorr.Prova + ": Tester\cache NON svuotata (" + $numCacheDopo + " file su " + $numCachePrima + " rimasti). MT5 puo' ripescare passate gia' calcolate (punto 38).")
      }
      Dico ("pulizia per cella: staging OptResults tolto, Tester\cache " + $numCachePrima + " -> " + $numCacheDopo + " file (checklist 88: mai in blocco a inizio corsa)") "Gray"
    } else {
      Dico "pulizia per cella: staging OptResults tolto, Tester\cache non esiste." "Gray"
    }
  }

  # ---------- L'INI: scritto E riletto (stesso file in giro a vuoto e
  #  corsa vera, checklist 33; gate sull'artefatto, checklist 79).
  $righeInputCella = @($Vive[$cellaCorr.Prova] | Where-Object { $_ -notmatch '^@' })
  if($righeInputCella.Count -ne 42){ throw ($cellaCorr.Prova + ": " + $righeInputCella.Count + " righe di input invece di 42. Il [TesterInputs] non e' quello atteso.") }
  $percorsoIni = GeneraIni $cellaCorr $righeInputCella
  Copy-Item -LiteralPath $percorsoIni -Destination (Join-Path $Sosta ("gen_R113_" + $cellaCorr.Id + ".ini")) -Force -ErrorAction SilentlyContinue

  if($SoloControllo){
    $cellaCorr.Esito = "SOLO CONTROLLO"
    Dico ("ini scritto e VERIFICATO sull'artefatto: " + (Split-Path -Leaf $percorsoIni) + " (Model=1, " + $cellaCorr.Da + " -> " + $cellaCorr.A + ", magic " + $cellaCorr.Magic + "/" + ($cellaCorr.Magic+5) + ")") "Green"
    Write-Host ("    esito: SOLO CONTROLLO   [nessuna passata]") -ForegroundColor Gray
    continue
  }

  # ---------- IL LANCIO
  Write-Host ("    avvio 2 passate (OHLC su M1 - il SOLO banco che esiste su _EXT)...") -ForegroundColor Cyan
  (Start-Process -FilePath $Terminal -ArgumentList "/config:`"$percorsoIni`"" -PassThru).WaitForExit()
  $cellaCorr.Min = [math]::Round((New-TimeSpan -Start $avvioCella -End (Get-Date)).TotalMinutes,1)

  # ---------- IL CSV: fresco, con le righe giuste, spostato per nome.
  $csvTrovato = ""
  if(Test-Path -LiteralPath $csvStaging){ $csvTrovato = $csvStaging }
  else {
    $csvAlternativi = @(Get-ChildItem -Path $MqlFiles -Filter "OptResults_*.csv" -ErrorAction SilentlyContinue |
                        Where-Object { $_.LastWriteTime -ge $avvioCella } | Sort-Object LastWriteTime -Descending | Select-Object -First 1)
    #  >>> IL NOME DELL'OptResults CONTIENE IL SIMBOLO: l'EA lo compone con
    #      MQL_PROGRAM_NAME e _Symbol (OptFrame_FileName, riga 555-558). Quindi
    #      un ripiego "prendo il primo CSV fresco" puo' prendere i numeri di UN
    #      ALTRO BANCO -- p.es. NASUSD (BCM) invece di NASUSD_EXT. Si controlla
    #      il nome, e in ogni caso il ripiego NON resta a schermo: finisce nel
    #      referto e nel codice d'uscita (checklist 84).
    if($csvAlternativi.Count -gt 0){
      $nomeCsvAlt = $csvAlternativi[0].Name
      if($nomeCsvAlt -notlike ("*_" + $SimboloRound + ".csv")){
        [void]$Problemi.Add($cellaCorr.Prova + ": in MQL5\Files e' comparso un CSV FRESCO che NON porta il simbolo di questo round nel nome (" + $nomeCsvAlt + " invece di " + (Split-Path -Leaf $csvStaging) + "). Il nome dell'OptResults lo scrive l'EA con MQL_PROGRAM_NAME e _Symbol: leggerlo vorrebbe dire prendere i numeri di un ALTRO banco. NON lo leggo.")
      } else {
        $csvTrovato = $csvAlternativi[0].FullName
        [void]$Rilievi.Add($cellaCorr.Prova + ": il CSV atteso (" + (Split-Path -Leaf $csvStaging) + ") non c'era e ho letto il fresco " + $nomeCsvAlt + ", che porta lo stesso simbolo. Da guardare: in una corsa sana i due nomi coincidono.")
        Dico ("(CSV trovato con un altro nome: " + $nomeCsvAlt + ")") "DarkYellow"
      }
    }
  }
  if($csvTrovato -eq ""){
    $cellaCorr.Esito = "NESSUN CSV (il tester non ha scritto niente)"
    [void]$Problemi.Add($cellaCorr.Prova + ": NESSUN CSV prodotto. DUE cause con nomi diversi (checklist 83): (1) il simbolo custom ha le barre ma la REGISTRAZIONE e' persa -- il log del tester direbbe 'symbol " + $SimboloRound + " not exist': si riapre MT5 una volta a mano o si rifa' la Riga 2 dello storico; (2) MT5 e' rimasto aperto o il tester e' uscito male. Il log del tester in " + $DataFolder + "\Tester\logs dice quale delle due.")
    Write-Host ("    esito: " + $cellaCorr.Esito + "   [" + $cellaCorr.Min.ToString("0.0",$INV) + " min]") -ForegroundColor Red
    continue
  }
  if((Get-Item -LiteralPath $csvTrovato).LastWriteTime -lt $avvioCella){
    $cellaCorr.Esito = "CSV VECCHIO (LastWriteTime prima dell'avvio della cella)"
    [void]$Problemi.Add($cellaCorr.Prova + ": il CSV in MQL5\Files e' VECCHIO (di un giro precedente): la pulizia per cella non l'ha tolto o il tester non e' girato. Il file NON si legge.")
    Write-Host ("    esito: " + $cellaCorr.Esito) -ForegroundColor Red
    continue
  }
  Move-Item -LiteralPath $csvTrovato -Destination $percorsoCsv -Force
  $cellaCorr.EtaCsv = (Get-Item -LiteralPath $percorsoCsv).LastWriteTime.ToString("yyyy-MM-dd HH:mm:ss",$INV)

  # ---------- RILETTURA DELL'INI CHE HA GIRATO (checklist 79): dopo il
  #  tester si rileggono FromDate/ToDate dall'artefatto consumato.
  $testoIniGirato = Get-Content -LiteralPath $percorsoIni -Raw
  $matchFromGirato = [regex]::Match($testoIniGirato,'(?m)^FromDate=([0-9.]+)\r?$')
  $matchToGirato   = [regex]::Match($testoIniGirato,'(?m)^ToDate=([0-9.]+)\r?$')
  if(-not $matchFromGirato.Success -or -not $matchToGirato.Success -or $matchFromGirato.Groups[1].Value -ne $cellaCorr.Da -or $matchToGirato.Groups[1].Value -ne $cellaCorr.A){
    [void]$Problemi.Add($cellaCorr.Prova + ": l'.ini CHE HA GIRATO porta FromDate=[" + $matchFromGirato.Groups[1].Value + "] ToDate=[" + $matchToGirato.Groups[1].Value + "] invece di [" + $cellaCorr.Da + "] e [" + $cellaCorr.A + "]. I numeri di questa cella NON sono della finestra dichiarata: non si leggono.")
  }

  # ---------- LE MISURE (parser stretto a 8 colonne) e G0-C.
  $lettureCsv = LeggiOpt $percorsoCsv
  $cellaCorr.Gemelli = Gemelli $lettureCsv
  if($null -eq $lettureCsv){
    $cellaCorr.Esito = "CSV ILLEGGIBILE (intestazione non a 8 colonne attese)"
    [void]$Problemi.Add($cellaCorr.Prova + ": CSV non letto o intestazione diversa dalle 8 colonne OPTFRAME attese (checklist 80). Intestazioni viste: [" + (($script:CsvIntestazioni | Select-Object -First 10) -join " | ") + "]")
    Write-Host ("    esito: " + $cellaCorr.Esito) -ForegroundColor Red
    continue
  }
  $cellaCorr.Righe = @($lettureCsv).Count
  if(@($lettureCsv).Count -ge 1){
    if($null -ne $lettureCsv[0].Pf){     $cellaCorr.Pf   = [double]$lettureCsv[0].Pf }
    if($null -ne $lettureCsv[0].Dd){     $cellaCorr.Dd   = [double]$lettureCsv[0].Dd }
    if($null -ne $lettureCsv[0].N){      $cellaCorr.N    = [int]$lettureCsv[0].N }
    if($null -ne $lettureCsv[0].Profit){ $cellaCorr.Prof = [double]$lettureCsv[0].Profit }
  }
  if($cellaCorr.Righe -ne $CelleAttese){
    $cellaCorr.Esito = "RIGHE SBAGLIATE (" + (FmtN $cellaCorr.Righe) + " invece di " + $CelleAttese + ")"
    [void]$Problemi.Add($cellaCorr.Prova + ": " + $cellaCorr.Esito + ". Cache del tester, oppure lo sweep dei magic non ha spazzolato: il file NON si legge.")
  }
  elseif($cellaCorr.Gemelli -ne "IDENTICI"){
    $cellaCorr.Esito = "G0-C FALLITO"
    [void]$Problemi.Add($cellaCorr.Prova + ": gemelli " + $cellaCorr.Gemelli + ". Due passate a parametri identici devono dare numeri identici: questa cella non si legge.")
  }
  else {
    $cellaCorr.Esito = "OK"
    Dico ("G0-C: IDENTICI. F" + $cellaCorr.F + " " + $cellaCorr.Etichetta + " / " + $cellaCorr.Cella + ": profitto " + (FmtE $cellaCorr.Prof) + " | PF " + (Fmt3 $cellaCorr.Pf) + " | DD " + (Fmt2 $cellaCorr.Dd) + "% | n " + (FmtN $cellaCorr.N) + " uscite (" + (FmtPos $cellaCorr.N) + " posizioni) | E.2: " + (ClasseE2 $cellaCorr.N)) "Green"
  }
  Write-Host ("    esito: " + $cellaCorr.Esito + "   [" + $cellaCorr.Min.ToString("0.0",$INV) + " min]") -ForegroundColor Gray
}

if($SoloControllo){
  $numIniSosta = @(Get-ChildItem -LiteralPath $Sosta -Filter "gen_R113_*.ini" -ErrorAction SilentlyContinue).Count
  if($numIniSosta -ne $Ordinati.Count){ [void]$Problemi.Add("giro a vuoto: " + $numIniSosta + " .ini in sosta invece di " + $Ordinati.Count + ".") }
  Write-Host ""
  Write-Host ("    .ini scritti e verificati in sosta: " + $numIniSosta + " su " + $Ordinati.Count + "   -> " + $Sosta) -ForegroundColor White
  Write-Host  "    >>> IL GIRO A VUOTO NON MISURA NESSUN NUMERO: niente n, niente PF," -ForegroundColor Yellow
  Write-Host  "        niente DD, niente G0-C. Conferma gli ARTEFATTI (e G0-A, l'antenato," -ForegroundColor Yellow
  Write-Host  "        che gira prima di MT5). Gli .ini sono GLI STESSI della corsa vera" -ForegroundColor Yellow
  Write-Host  "        (checklist 33): aprine uno e leggi FromDate/ToDate/Model/Symbol." -ForegroundColor Yellow
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
$Modo = if($SoloControllo){ "CONTROLLO" } elseif($SoloCella -ne ""){ "RIPRESA" } else { "CORSA" }
$Cart = Join-Path $Dsk ("R113_REGIME_" + $Modo + "_" + $Stamp)
$Zip  = Join-Path $Dsk ("R113_REGIME_" + $Modo + "_" + $Stamp + ".zip")
$Referto = Join-Path $Cart "REFERTO_R113.txt"
try{
  New-Item -ItemType Directory -Force -Path $Cart | Out-Null
  $AttesiTrovati = New-Object System.Collections.ArrayList
  foreach($cellaRacc in $Ordinati){
    $csvDaCopiare = CsvDi $cellaRacc
    $trovatoRacc = "MANCA"
    if(Test-Path -LiteralPath $csvDaCopiare){
      Copy-Item -LiteralPath $csvDaCopiare -Destination (Join-Path $Cart (Split-Path -Leaf $csvDaCopiare)) -Force
      $trovatoRacc = "trovato (" + (Get-Item -LiteralPath $csvDaCopiare).LastWriteTime.ToString("yyyy-MM-dd HH:mm",$INV) + ")"
    } elseif($SoloControllo){ $trovatoRacc = "non atteso (giro a vuoto)" }
    [void]$AttesiTrovati.Add((Split-Path -Leaf $csvDaCopiare).PadRight(28) + " " + $trovatoRacc)
    $provaDaCopiare = Join-Path $Prove $cellaRacc.Prova
    if(Test-Path -LiteralPath $provaDaCopiare){ Copy-Item -LiteralPath $provaDaCopiare -Destination (Join-Path $Cart $cellaRacc.Prova) -Force }
  }
  foreach($nomeAntenato in @($Ordinati | ForEach-Object { $_.AntFile } | Sort-Object -Unique)){
    $antDaCopiare = Join-Path $Anten $nomeAntenato
    if(Test-Path -LiteralPath $antDaCopiare){ Copy-Item -LiteralPath $antDaCopiare -Destination (Join-Path $Cart $nomeAntenato) -Force }
  }
  #  la SOSTA si copia intera: e' svuotata a ogni giro (56) e contiene
  #  solo artefatti di ADESSO (gen_*.ini riletti, log compilatore).
  if(Test-Path -LiteralPath $Sosta){
    foreach($fileSosta in @(Get-ChildItem -LiteralPath $Sosta -File -ErrorAction SilentlyContinue)){
      Copy-Item -LiteralPath $fileSosta.FullName -Destination (Join-Path $Cart $fileSosta.Name) -Force
    }
  }

  $RefTxt = New-Object System.Collections.ArrayList
  [void]$RefTxt.Add("REFERTO R113 - PROVA DI REGIME NASUSD_EXT: L'EDGE SHORT VIVE NELLE DISCESE?")
  [void]$RefTxt.Add($EaNome + " / " + $SimboloRound + " " + $PeriodoRound + " - sedia viva 970913 (che NON si tocca: G5)")
  [void]$RefTxt.Add("")
  [void]$RefTxt.Add(">>> QUESTI SONO DATI DI UN ALTRO BROKER - spread, orari di seduta e prezzi")
  [void]$RefTxt.Add(">>> NON SONO BCM (decisione D-C del 25/08, emendamento FRIGO del 26/08).")
  [void]$RefTxt.Add(">>> IL LIMITE COSTITUTIVO (criteri par. 1): " + $SimboloRound + " e' barre M1")
  [void]$RefTxt.Add(">>> importate (HistData), SENZA tick reali BCM: banco OHLC su M1 (modello 1).")
  [void]$RefTxt.Add(">>> La differenza fra i banchi e' MISURATA (SupRev_DOW_H4: PF 2,77 OHLC vs")
  [void]$RefTxt.Add(">>> 0,79 tick reali). Si legge la FORMA (verde/rosso, ordini di grandezza),")
  [void]$RefTxt.Add(">>> MAI i numeri fini. Confronti SOLO _EXT-contro-_EXT fra finestre: mai")
  [void]$RefTxt.Add(">>> '_EXT contro BCM', mai 'questa cella contro il suo numero R110'.")
  [void]$RefTxt.Add(">>> G0-EXT superato PER FIRMA (26/08): rapporto 0,199 sul metro relativo")
  [void]$RefTxt.Add(">>> 0,20 - BORDO SOTTILE, dichiarato.")
  [void]$RefTxt.Add("")
  [void]$RefTxt.Add("modo: " + $Modo + $(if($SoloControllo){ "   <<< GIRO A VUOTO: NESSUNA passata, NESSUN CSV, NESSUN numero di round qui dentro" } else { "" }))
  $switchGiro = @()
  if($SoloControllo){ $switchGiro += "-SoloControllo (nessuna passata)" }
  #  >>> CHECKLIST 82: la frase sulla firma si costruisce sul VALORE
  #      LETTO, mai su un ramo solo. Lo switch inerte va detto inerte.
  if($CriteriFirmati -and $daFirmare){ $switchGiro += "-CriteriFirmati (FIRMA IN RIGA di Claudio: il file dei criteri portava ancora il lucchetto)" }
  elseif($CriteriFirmati){ $switchGiro += "-CriteriFirmati (INERTE, e va bene: i criteri risultano gia' FIRMATI NEL FILE al pin -- la firma e' quella del documento, non una firma in riga)" }
  if($SoloCella -ne ""){ $switchGiro += "-SoloCella " + $SoloCella + " (in R113 nessuna cella e' denominatore: gira solo quella)" }
  if($Rifai){ $switchGiro += "-Rifai (i CSV precedenti sono stati rifatti)" }
  if($switchGiro.Count -eq 0){ $switchGiro += "nessuno (corsa piena; una cella con CSV gia' presente viene RACCOLTA con l'eta' dichiarata, checklist 88)" }
  [void]$RefTxt.Add("switch di questo giro: " + ($switchGiro -join " | "))
  [void]$RefTxt.Add("stato dei criteri: " + $Firma)
  [void]$RefTxt.Add("data: " + (Get-Date).ToString("yyyy-MM-dd HH:mm:ss",$INV) + " ora del PC   (questa data deve essere di ADESSO)")
  [void]$RefTxt.Add("avvio: " + $Avvio.ToString("yyyy-MM-dd HH:mm:ss",$INV) + " ora del PC   durata: " + ((New-TimeSpan -Start $Avvio -End (Get-Date)).TotalMinutes).ToString("0.0",$INV) + " minuti")
  [void]$RefTxt.Add("pin: " + $Pin)
  [void]$RefTxt.Add("criteri: risultati_archivio\R113_CRITERI.md (otto decisioni, par. 9)")
  [void]$RefTxt.Add("banco: modello " + $Modello + " (OHLC su M1)   deposito " + $Deposito + "   leva 100   EUR")
  [void]$RefTxt.Add("spread: Spread=" + $SpreadIni + " scritto NELL'INI di OGNI finestra = nella convenzione")
  [void]$RefTxt.Add("     di casa (R100/R102/R103, walkforward_generico riga 484) vuol dire SPREAD")
  [void]$RefTxt.Add("     CORRENTE DEL SIMBOLO, messo agli atti invece che lasciato allo stato")
  [void]$RefTxt.Add("     nascosto del terminale. VERIFICATO NELL'ARTEFATTO: la stessa riga in")
  [void]$RefTxt.Add("     tutti e 18 gli .ini -> il banco e' IDENTICO fra le finestre PER")
  [void]$RefTxt.Add("     COSTRUZIONE, ed e' questa coerenza interna che rende leggibile il")
  [void]$RefTxt.Add("     confronto relativo _EXT-vs-_EXT.")
  [void]$RefTxt.Add("  >>> IL VALORE EFFETTIVO IN PUNTI E' *NON MISURATO*, e si dichiara mancante")
  [void]$RefTxt.Add("      invece di dedurlo (i criteri par. 1 punto 3 lo chiedevano letto: questo")
  [void]$RefTxt.Add("      driver NON puo' leggerlo, e dirlo e' l'unica risposta onesta).")
  [void]$RefTxt.Add("      Perche' non si deduce, con DUE nomi (checklist 83 e 89):")
  [void]$RefTxt.Add("      (1) ABTG_ImportaStoricoEsterno.mq5 scrive spread = 0 in OGNI barra M1")
  [void]$RefTxt.Add("          importata (riga 327) e copia SYMBOL_SPREAD_FLOAT dal simbolo BCM,")
  [void]$RefTxt.Add("          ma NON copia SYMBOL_SPREAD: se il tester prende lo spread dalla")
  [void]$RefTxt.Add("          BARRA, questo banco e' SENZA ATTRITO (spread zero);")
  [void]$RefTxt.Add("      (2) se invece ripiega su SYMBOL_SPREAD del simbolo custom, il valore e'")
  [void]$RefTxt.Add("          quello che il simbolo si e' portato dietro alla creazione.")
  [void]$RefTxt.Add("      Quale delle due sia, QUI NON E' MISURATO. Non sposta i confronti fra")
  [void]$RefTxt.Add("      finestre (identico ovunque), MA un edge SHORT giudicato su un banco")
  [void]$RefTxt.Add("      forse senza attrito e' una cosa da sapere PRIMA di leggere i PF.")
  [void]$RefTxt.Add("      Come si chiude, ed e' un passo A SE': in MT5 -> Vista -> Simboli ->")
  [void]$RefTxt.Add("      " + $SimboloRound + " -> campo Spread (o Specifiche del simbolo nel tester).")
  [void]$RefTxt.Add("      Nota agli atti: STORICO_INDICI_CRITERI.md riga 157 dice gia' 'nel tester")
  [void]$RefTxt.Add("      lo spread e' quello che si imposta', e ABTG_ImportaStoricoEsterno.mq5")
  [void]$RefTxt.Add("      riga 33 dice 'SPREAD E COMMISSIONI restano quelli che imposti nel")
  [void]$RefTxt.Add("      tester': nessuno dei due dichiara uno spread FISSO messo all'import.")
  [void]$RefTxt.Add("orologi (checklist 86): le finestre sono DATE DI CALENDARIO a giorni interi;")
  [void]$RefTxt.Add("     le barre _EXT sono in ORA SERVER BCM (shift +5 verificato all'import);")
  [void]$RefTxt.Add("     'data:' e 'avvio:' qui sopra sono ORA DEL PC (= ora italiana sul VPS).")
  [void]$RefTxt.Add("rischio: 1,0% per trade nei file (come gli antenati R110). La sedia in campo")
  [void]$RefTxt.Add("     sta a 0,65% sul 100k: OGNI DD di questo referto va MOLTIPLICATO x0,65")
  [void]$RefTxt.Add("     per confrontarlo col forward - ma il confronto col forward NON si fa")
  [void]$RefTxt.Add("     qui (dati di un altro broker).")
  [void]$RefTxt.Add("")
  [void]$RefTxt.Add("--- CONVENZIONE DI SENTINELLA (checklist 66) ---")
  [void]$RefTxt.Add("  Un numero NON MISURATO si scrive 'n/d'. MAI -1, MAI 0.000.")
  [void]$RefTxt.Add("")
  [void]$RefTxt.Add("--- I GATE (criteri par. 4) ---")
  [void]$RefTxt.Add("  G0-EXT AMMISSIONE : superato PER FIRMA (26/08), bordo sottile 0,199 dichiarato.")
  [void]$RefTxt.Add("  G0-A  ANTENATO    : copia riga per riga del file prova R110_SUPNAS, salvo")
  [void]$RefTxt.Add("                      @SIMBOLO + @DAQUANDO + InpMagic (e la riga NUOVA @FINOA,")
  [void]$RefTxt.Add("                      documentata nei file). Catena R103 -> R110 -> R113.")
  [void]$RefTxt.Add("                      Gira PRIMA di MT5, su TUTTI i 18 file.")
  [void]$RefTxt.Add("  G0-B              : NON APPLICABILE, dichiarato: nessun round e' mai girato")
  [void]$RefTxt.Add("                      su NASUSD_EXT, non c'e' niente da riprodurre.")
  [void]$RefTxt.Add("  G0-C  GEMELLI     : le due righe del CSV identiche al centesimo (magic +5).")
  [void]$RefTxt.Add("  G1    CAMPIONE    : unita' = USCITE (STAT_TRADES), la stessa di tutti i round")
  [void]$RefTxt.Add("                      di casa; ~2 uscite = 1 posizione (MISURATO in R112 par. 3:")
  [void]$RefTxt.Add("                      la colonna ~pos e' quella STIMA). Soglie E.2: n>=20 verdetto")
  [void]$RefTxt.Add("                      pieno di merito / 8-19 SOSPESO / <8 NON MISURATO. La")
  [void]$RefTxt.Add("                      colonna E.2 e' la TASSONOMIA meccanica, non un verdetto.")
  [void]$RefTxt.Add("                      E.3: il campione sottile sospende il MERITO, MAI il RISCHIO.")
  [void]$RefTxt.Add("  G2    RISCHIO     : vedi la sezione G2 sotto - i METRI, il verdetto e' a mano.")
  [void]$RefTxt.Add("  G5                : NESSUNA promozione, per costruzione (par. 7).")
  [void]$RefTxt.Add("")
  [void]$RefTxt.Add("--- LA TABELLA MADRE ---   (attese: " + $CelleAttese + " righe gemelle per CSV, " + $Ordinati.Count + " CSV, " + (2*$Ordinati.Count) + " passate)")
  [void]$RefTxt.Add("  VERSI DICHIARATI (checklist 87) - in questa riga ce ne sono TRE diversi:")
  [void]$RefTxt.Add("  PROF col SEGNO (+ guadagno / - perdita); PF sempre POSITIVO (piu' ALTO =")
  [void]$RefTxt.Add("  meglio); DD% MAGNITUDINE POSITIVA (piu' BASSO = meglio). n e' in USCITE;")
  [void]$RefTxt.Add("  ~pos = n/2 arrotondato in giu' (equivalenza misurata R112 par. 3, e' una stima).")
  [void]$RefTxt.Add("  E.2: PIENO (n>=20) / SOSPESO (8-19) / NON MIS. (<8) - meccanica, non verdetto.")
  [void]$RefTxt.Add(("  {0,-4} {1,-13} {2,-9} {3,-24} {4,-9} {5,-7} {6,-7} {7,-7} {8,-6} {9,-9} {10}" -f `
                "F","FINESTRA","CELLA","GIUDICA","PROF","PF","DD%","n(usc)","~pos","E.2","ESITO"))
  foreach($cellaRef in $Ordinati){
    [void]$RefTxt.Add(("  {0,-4} {1,-13} {2,-9} {3,-24} {4,-9} {5,-7} {6,-7} {7,-7} {8,-6} {9,-9} {10}" -f `
                  ("F" + $cellaRef.F),$cellaRef.Etichetta,$cellaRef.Cella,$cellaRef.Giudica,
                  (FmtE $cellaRef.Prof),(Fmt3 $cellaRef.Pf),(Fmt2 $cellaRef.Dd),(FmtN $cellaRef.N),
                  (FmtPos $cellaRef.N),(ClasseE2 $cellaRef.N),$cellaRef.Esito))
  }
  [void]$RefTxt.Add("  (niente colonna 'peggior giornata': NON e' nel perimetro di R113. L'OPTFRAME")
  [void]$RefTxt.Add("   di questo EA ha 8 colonne statistiche, misurato nel sorgente al pin.)")
  [void]$RefTxt.Add("")
  [void]$RefTxt.Add("--- FILE ATTESI vs TROVATI ---")
  foreach($rigaAtteso in $AttesiTrovati){ [void]$RefTxt.Add("  " + $rigaAtteso) }
  [void]$RefTxt.Add("")
  [void]$RefTxt.Add("--- LE CELLE, GATE PER GATE ---")
  foreach($cellaRef in $Ordinati){
    [void]$RefTxt.Add(("  {0,-22} magic {1}/{2}   InpAllowLong={3} InpAllowShort={4}" -f `
                  $cellaRef.Id,$cellaRef.Magic,($cellaRef.Magic+5),$cellaRef.Val["InpAllowLong"],$cellaRef.Val["InpAllowShort"]))
    [void]$RefTxt.Add("       finestra " + $cellaRef.Etichetta + " " + $cellaRef.Da + " -> " + $cellaRef.A + "   giudica: " + $cellaRef.Giudica)
    [void]$RefTxt.Add("       G0-A antenato : " + $cellaRef.Antenato)
    [void]$RefTxt.Add("       G0-C gemelli  : " + $cellaRef.Gemelli)
    [void]$RefTxt.Add("       CSV           : righe " + (FmtN $cellaRef.Righe) + $(if($cellaRef.EtaCsv -ne ""){ "   LastWriteTime " + $cellaRef.EtaCsv + " ora del PC" } else { "" }))
    [void]$RefTxt.Add("       esito         : " + $cellaRef.Esito)
  }
  [void]$RefTxt.Add("")
  [void]$RefTxt.Add("--- G2 RISCHIO (criteri par. 4): I METRI, NON IL VERDETTO ---")
  [void]$RefTxt.Add("  Metro per cella = DD OOS R110 a rischio 1% (STA NEI CRITERI COME ORIGINE,")
  [void]$RefTxt.Add("  non come paragone di merito): 00_metro 1,29 | 01_long 1,62 | 02_short 0,93.")
  [void]$RefTxt.Add("  Soglia di SEGNALAZIONE: in una finestra avversa (F1 ORSO, F2 CROLLO, F5")
  [void]$RefTxt.Add("  VECCHIA) DD > 2x il metro della cella E comunque > 20%.")
  [void]$RefTxt.Add("  [DD = MAGNITUDINI POSITIVE, piu' basso = meglio - checklist 87. Si legge la")
  [void]$RefTxt.Add("   FORMA/ordine di grandezza, coerente col par. 1.]")
  foreach($cellaRef in @($Ordinati | Where-Object { $_.F -eq 1 -or $_.F -eq 2 -or $_.F -eq 5 })){
    $metroCella = [double]$MetroG2[$cellaRef.Cella]
    [void]$RefTxt.Add("  INFO " + $cellaRef.Id.PadRight(20) + " DD " + (Fmt2 $cellaRef.Dd) + "%   metro R110 " + $metroCella.ToString("0.00",$INV) + "%   soglia (2x metro E >20%): " + ([math]::Max(2.0*$metroCella,20.0)).ToString("0.00",$INV) + "%   -> lettura A MANO")
  }
  [void]$RefTxt.Add("  >>> La SEGNALAZIONE FORMALE DI REVISIONE della sedia 970913 (se scatta) e'")
  [void]$RefTxt.Add("      del referto del round, A MANO: decisione a Claudio, nessun automatismo")
  [void]$RefTxt.Add("      su dati esterni (D-C + regola B, criteri par. 4 G2).")
  [void]$RefTxt.Add("")
  [void]$RefTxt.Add("--- LETTURA IPOTESI-S (criteri par. 6) - LE CASELLE SONO VUOTE APPOSTA ---")
  [void]$RefTxt.Add("  La lettura e' PRE-DICHIARATA (scritta PRIMA dei numeri) e si spunta A MANO")
  [void]$RefTxt.Add("  NEL REFERTO DEL ROUND, mai da questo driver. Si legge sulla cella 02_short;")
  [void]$RefTxt.Add("  00_metro e 01_long sono contesto. F2 (CROLLO) e F5 (VECCHIA) NON entrano")
  [void]$RefTxt.Add("  nel verdetto (giudicano solo il rischio); F4 (LATERALE_NAS) e' contesto:")
  [void]$RefTxt.Add("  nessuna condizione ci poggia sopra. 'Verde in ORSO ma sottile in")
  [void]$RefTxt.Add("  CROLLO_ANNO' (o viceversa) = NON CONCLUSIVA: non esiste 'confermata a meta''.")
  [void]$RefTxt.Add("  [ ] CONFERMATA ............. short PF >= 1,10 con n >= 20 in ORSO _E_ in")
  [void]$RefTxt.Add("                               CROLLO_ANNO, _E_ PF < 1,10 in TORO")
  [void]$RefTxt.Add("  [ ] SMENTITA ............... short PF < 0,90 con n >= 20 in ORSO _E_ in")
  [void]$RefTxt.Add("                               CROLLO_ANNO")
  [void]$RefTxt.Add("  [ ] MOTORE PER TUTTE LE     short PF >= 1,10 con n >= 20 in ORSO,")
  [void]$RefTxt.Add("      STAGIONI ............... CROLLO_ANNO _E_ TORO (etichetta diversa,")
  [void]$RefTxt.Add("                               NON promozione: G5 resta)")
  [void]$RefTxt.Add("  [ ] NON CONCLUSIVA ......... ogni altro quadro (segni misti fra le due")
  [void]$RefTxt.Add("                               finestre avverse, o campioni sottili/non")
  [void]$RefTxt.Add("                               misurati dove serviva il verdetto)")
  [void]$RefTxt.Add("  (le caselle si spuntano a mano nel referto del round)")
  [void]$RefTxt.Add("")
  [void]$RefTxt.Add("--- QUELLO CHE QUESTO REFERTO NON DICE, DICHIARATO ---")
  [void]$RefTxt.Add("  * NON spunta IPOTESI-S e NON applica G2: numeri e metri stampati, verdetti")
  [void]$RefTxt.Add("    a mano (la lettura pre-dichiarata non si tocca dopo i numeri, D5).")
  [void]$RefTxt.Add("  * NON promuove niente (G5 per costruzione): nessuna cella entra in flotta,")
  [void]$RefTxt.Add("    cambia stato o si muove in classifica per un numero uscito su un _EXT.")
  [void]$RefTxt.Add("    'Facciamo la sedia short-only' e' un round SUCCESSIVO su dati BCM.")
  [void]$RefTxt.Add("  * NIENTE peggior giornata e NIENTE per-trade: fuori perimetro. L'EA scrive")
  [void]$RefTxt.Add("    comunque abtg_trades_*_7635xx.csv nella cartella comune: NON letti, NON")
  [void]$RefTxt.Add("    raccolti, NON cancellati da questo driver.")
  [void]$RefTxt.Add("  * I numeri R110 citati stanno come ORIGINE delle celle e metro G2 del")
  [void]$RefTxt.Add("    RISCHIO, mai come paragone di merito (banchi diversi).")
  [void]$RefTxt.Add("  * NON misura il flottante, non fa split IS/OOS (finestre UNICHE di regime),")
  [void]$RefTxt.Add("    non scrive una riga di MQL5.")
  [void]$RefTxt.Add("")
  if($Rilievi.Count -gt 0){
    [void]$RefTxt.Add("--- RILIEVI (NON sono guasti: sono RISULTATI o note del giro) ---   (" + $Rilievi.Count + ")")
    foreach($rilievoRef in $Rilievi){ [void]$RefTxt.Add("  - " + $rilievoRef) }
    [void]$RefTxt.Add("")
  }
  [void]$RefTxt.Add("--- PROBLEMI (questi SI sono guasti) ---   (" + $Problemi.Count + ")")
  if($Problemi.Count -eq 0){ [void]$RefTxt.Add("  nessuno.") }
  foreach($problemaRef in $Problemi){ [void]$RefTxt.Add("  - " + $problemaRef) }
  if($Fatale -ne ""){
    [void]$RefTxt.Add("")
    [void]$RefTxt.Add("--- FERMATO ---")
    [void]$RefTxt.Add("  " + $Fatale)
  }
  [void]$RefTxt.Add("")
  # --- L'ESITO DEL REFERTO DICE LE STESSE PAROLE DELLO SCHERMO, e i
  #     gate ARRIVANO al codice d'uscita: la lista che decide e' LA
  #     STESSA che finisce nel testo (checklist 84).
  $celleKoRef = @($Ordinati | Where-Object { $_.Esito -ne "OK" -and $_.Esito -ne "SOLO CONTROLLO" -and $_.Esito -notlike "GIA' FATTA*" })
  if($Fatale -ne ""){
    [void]$RefTxt.Add("ESITO: FERMATO -- " + $Fatale)
  }
  elseif($SoloControllo){
    if($celleKoRef.Count -gt 0 -or $Problemi.Count -gt 0){
      [void]$RefTxt.Add("ESITO: GIRO A VUOTO CON PROBLEMI (" + $Problemi.Count + ") -- NESSUNA passata. NON lanciare la corsa vera prima di aver letto i PROBLEMI.")
    } else {
      [void]$RefTxt.Add("ESITO: GIRO A VUOTO COMPLETATO -- NESSUNA passata, NESSUN CSV, NESSUN numero. QUESTO ZIP NON E' IL ROUND.")
    }
  }
  elseif($celleKoRef.Count -gt 0){
    [void]$RefTxt.Add("ESITO: PARZIALE -- " + $celleKoRef.Count + " celle su " + $Ordinati.Count + " NON hanno prodotto numeri leggibili (elenco qui sopra), piu' " + $Problemi.Count + " problemi. NON e' un round completo.")
  }
  elseif($Problemi.Count -gt 0){
    [void]$RefTxt.Add("ESITO: COMPLETO CON PROBLEMI -- tutte e " + $Ordinati.Count + " le celle hanno numeri, ma ci sono " + $Problemi.Count + " problemi. I numeri si leggono ACCANTO ai problemi, non invece dei problemi.")
  }
  elseif($Rilievi.Count -gt 0){
    [void]$RefTxt.Add("ESITO: COMPLETO CON RILIEVI -- tutte e " + $Ordinati.Count + " le celle hanno numeri. I " + $Rilievi.Count + " rilievi vanno letti (celle GIA' FATTE raccolte con eta' dichiarata comprese).")
  }
  else{
    [void]$RefTxt.Add("ESITO: OK -- tutte le celle hanno prodotto i numeri attesi, nessun problema e nessun rilievo in elenco.")
  }
  [void]$RefTxt.Add("")
  [void]$RefTxt.Add("--- COME SI RIPRENDE ---")
  [void]$RefTxt.Add('  una cella sola : ... & $p -Pin <PIN> -SoloCella R113_F1_02_short.txt')
  [void]$RefTxt.Add('  rifare cio'' che c''e'' gia'' : aggiungi -Rifai')
  [void]$RefTxt.Add("  >>> in R113 NESSUNA cella e' denominatore di un'altra: -SoloCella lancia")
  [void]$RefTxt.Add("      solo quella. Una cella con CSV gia' presente viene RACCOLTA con l'eta'")
  [void]$RefTxt.Add("      dichiarata, non rifatta (checklist 88): per rifarla serve -Rifai.")
  [void]$RefTxt.Add("  >>> i tre puntini stanno per IL BLOCCO INTERO della riga di lancio, con il")
  [void]$RefTxt.Add("      suo irm e la sua guardia: si riprende da RIGA_R113_DA_MANDARE.md.")
  [void]$RefTxt.Add('  >>> senza -CriteriFirmati: se una ripresa esce con codice 2, il file dei')
  [void]$RefTxt.Add('      criteri al pin porta (ancora, o di nuovo) il lucchetto: si legge il')
  [void]$RefTxt.Add('      documento, NON si aggira lo switch.')

  Set-Content -LiteralPath $Referto -Value ($RefTxt -join "`r`n") -Encoding UTF8
  if(Test-Path -LiteralPath $Zip){ Remove-Item -LiteralPath $Zip -Force -ErrorAction SilentlyContinue }
  Compress-Archive -Path (Join-Path $Cart "*") -DestinationPath $Zip -Force
}catch{
  Write-Host ("!!! RACCOLTA PARZIALE: " + $_.Exception.Message) -ForegroundColor Red
}

Write-Host ""
Write-Host "=====================================================================" -ForegroundColor White
Write-Host "  R113 - FINE" -ForegroundColor White
function RigaFinale([string]$percorsoFinale,[string]$codaFinale){
  if(Test-Path -LiteralPath $percorsoFinale){ Write-Host ("   " + $percorsoFinale + "   " + $codaFinale) -ForegroundColor White }
  else                                      { Write-Host ("   " + $percorsoFinale + "   <<< NON ESISTE") -ForegroundColor Red }
}
RigaFinale $Cart    ""
RigaFinale $Zip     "<- e' questo che mi mandi"
RigaFinale $Referto "<- la riga 'data:' deve essere di ADESSO, la riga 'modo:' dice se e' il round o un giro a vuoto"
Write-Host "=====================================================================" -ForegroundColor White
if($SoloControllo){
  Write-Host ("  MODO: " + $Modo + " -- GIRO A VUOTO. NESSUNA passata, NESSUN CSV, NESSUN numero") -ForegroundColor Yellow
  Write-Host ("        di round. .ini attesi in sosta: " + $Ordinati.Count + ". G0-C: NON ESEGUITO, ed e'") -ForegroundColor Yellow
  Write-Host  "        giusto cosi'. (G0-A l'antenato SI: gira PRIMA di MT5 ed e' gia'" -ForegroundColor Yellow
  Write-Host  "        passato.) QUESTO ZIP NON E' IL ROUND." -ForegroundColor Yellow
} else {
  Write-Host ("  MODO: " + $Modo) -ForegroundColor White
  Write-Host ("  ATTESI:  " + $Ordinati.Count + " CSV (uno per lancio, finestra UNICA), " + $CelleAttese + " righe l'uno, " + (2*$Ordinati.Count) + " passate.") -ForegroundColor White
}
foreach($cellaFinale in $Ordinati){
  $coloreFinale = "Green"
  if($cellaFinale.Esito -ne "OK" -and $cellaFinale.Esito -ne "SOLO CONTROLLO"){ $coloreFinale = "Yellow" }
  Write-Host ("   " + $cellaFinale.Id.PadRight(22) + " " + $cellaFinale.Esito) -ForegroundColor $coloreFinale
}
if($Rilievi.Count -gt 0){
  Write-Host ""
  Write-Host "   RILIEVI (risultati o note del giro, NON guasti):" -ForegroundColor Yellow
  foreach($rilievoFin in $Rilievi){ Write-Host ("    - " + $rilievoFin) -ForegroundColor Yellow }
}
if($Problemi.Count -gt 0){
  Write-Host ""
  Write-Host "   PROBLEMI DA LEGGERE:" -ForegroundColor Red
  foreach($problemaFin in $Problemi){ Write-Host ("    - " + $problemaFin) -ForegroundColor Red }
}
Write-Host ""
# =====================================================================
#  L'ESITO IN CONSOLE DICE LE STESSE PAROLE DEL REFERTO, ogni ramo
#  finisce con un exit ESPLICITO, e i gate ARRIVANO al codice d'uscita
#  (checklist 84: la lista dei problemi che decide e' la stessa scritta
#  nel referto). CODICI: 0 = OK / COMPLETO CON RILIEVI; 1 = parziale,
#  fermato, con problemi, o selettore a vuoto; 2 = criteri non firmati.
# =====================================================================
if($Fatale -ne ""){ Write-Host ("ESITO: FERMATO -- " + $Fatale) -ForegroundColor Red; exit 1 }
$celleKoFinali = @($Ordinati | Where-Object { $_.Esito -ne "OK" -and $_.Esito -ne "SOLO CONTROLLO" -and $_.Esito -notlike "GIA' FATTA*" })
if($SoloControllo){
  if($celleKoFinali.Count -gt 0 -or $Problemi.Count -gt 0){
    Write-Host ("ESITO: GIRO A VUOTO CON PROBLEMI (" + $Problemi.Count + ") -- NESSUNA passata, e c'e' da leggere il referto") -ForegroundColor Yellow
    exit 1
  }
  Write-Host "ESITO: GIRO A VUOTO COMPLETATO -- NESSUNA passata, NESSUN CSV. QUESTO ZIP NON E' IL ROUND." -ForegroundColor Green
  exit 0
}
if($celleKoFinali.Count -gt 0){
  Write-Host ("ESITO: PARZIALE (" + $celleKoFinali.Count + " celle su " + $Ordinati.Count + " senza numeri leggibili, " + $Problemi.Count + " problemi) -- lo zip esiste: mandalo") -ForegroundColor Yellow
  exit 1
}
if($Problemi.Count -gt 0){
  Write-Host ("ESITO: COMPLETO CON PROBLEMI (" + $Problemi.Count + ") -- i numeri ci sono TUTTI, ma vanno letti ACCANTO ai problemi. Lo zip esiste: mandalo.") -ForegroundColor Yellow
  exit 1
}
if($Rilievi.Count -gt 0){
  Write-Host ("ESITO: COMPLETO CON RILIEVI (" + $Rilievi.Count + " rilievi da leggere nel referto, nessuna cella mancante e nessun guasto)") -ForegroundColor Green
  exit 0
}
Write-Host "ESITO: OK" -ForegroundColor Green
exit 0
