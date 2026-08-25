# =====================================================================
#  MARCATORE_RIGA_R111_v1
#  RIGA_R111_BB_M30.ps1  --  R111: IL BREAKING BAND SU M30
#     ABTG_BreakingBand su GBPUSD, EURUSD, AUDUSD
#     due celle per simbolo, e fra loro cambia SOLO InpTF:
#        00_metroH1  H1  (InpTF 16385)  = IL METRO, riproduce R103
#        01_m30      M30 (InpTF 30)     = LA MISURA NUOVA
# ---------------------------------------------------------------------
#  CRITERI:   backtest_pipeline\risultati_archivio\R111_CRITERI.md
#  GEMELLO:   backtest_pipeline\righe\RIGA_R108_BB_M15.ps1 (MARCATORE_RIGA_R108_v1)
#  ANTENATI:  backtest_pipeline\prove\R108_<SIM>_00_metroH1.txt
#             backtest_pipeline\prove\R103_ABTG_BreakingBand_<SIM>_<magic>.txt
#
#  ------------------------------------------------------------------
#  LA DOMANDA DEL ROUND, UNA SOLA: DOV'E' IL CONFINE DELL'EDGE?
#
#  Il Breaking Band VIVE a H1 ed e' MISURATO (R103: GBPUSD PF 1,199 n126 /
#  EURUSD 1,936 n59 / AUDUSD 1,541 n64, 6,5 anni).
#  Lo stesso motore MUORE a M15 ed e' MISURATO (R108, 25/08: sei finestre
#  su sei ROSSE, e morto di SEGNALE -- il cancello del costo S0a passava).
#  M30 e' IL PUNTO DI MEZZO, e non l'ha mai misurato nessuno.
#
#  >>> NON E' RIGIRARE LA GRIGLIA DI UN MORTO (clausola della SECONDA
#      CACCIA, 19/08). Il motore e' VIVO a H1 e ha TRE SEDIE IN CAMPO:
#      quello che R108 ha dichiarato morto e' UN PUNTO, non la famiglia.
#      E qui non c'e' NESSUNA GRIGLIA: l'unico flag Y e' InpMagic, un
#      solo input cambia (InpTF), e i criteri par. 8 dichiarano PRIMA che
#      cosa si legge in OGNUNO dei quattro esiti possibili -- compreso il
#      ROSSO, che CHIUDE il capitolo della discesa di TF.
#  ------------------------------------------------------------------
#
#  >>> I CRITERI SONO [DA FIRMARE] (SETTE decisioni, par. 11), e la forma
#      del lucchetto e' DICHIARATA nei criteri (par. "LA FORMA DEL
#      LUCCHETTO"): il titolo del file conserva la stringa APPOSTA.
#      C'e' una PRE-FIRMA di Claudio del 25/08 -- "FIRMO R111" -- ma e'
#      sul PERIMETRO ("BB M30, confine fra H1 vivo e M15 morto"), NON
#      sulle sette decisioni: quelle restano smentibili finche' la corsa
#      non parte. Percio' il driver LEGGE il file al pin e, se ci trova
#      ancora il lucchetto, la CORSA VERA non parte (exit 2). Il GIRO A
#      VUOTO parte lo stesso. -CriteriFirmati e' la registrazione della
#      pre-firma, e finisce SCRITTA NEL REFERTO.
#
#  DA DOVE NASCE, dichiarato: e' RIGA_R108_BB_M15.ps1 -- il DRIVER GEMELLO,
#  stesso EA, stessi tre simboli, stesso schema metro/cella -- di cui
#  questo file e' la copia con InpTF 15 -> 30 e la finestra piu' lunga.
#  Il punto 9 della checklist dice che una riscrittura non puo' perdere le
#  funzioni di sicurezza del gemello: sono state riportate TUTTE --
#    [CmdletBinding()], -Pin senza default, gate della firma dei criteri,
#    guardia MT5 E MetaEditor chiusi, [Charts] MaxBars, [Experts]
#    AllowLiveTrading=false, install di ABTG_PausaGuardian.mqh, gate delle
#    righe vive, gate della STELLA, gate dell'ANTENATO, gate dei VALORI,
#    gate dell'ASSE UNICO, gate dei MAGIC, compilazione DIRETTA con
#    verdetto sul LastWriteTime del .ex5 + backup datato + ripristino del
#    .mq5 se fallisce, SOSTA SVUOTATA A OGNI GIRO, funzioni e variabili
#    della raccolta SOPRA il try, MODO nel nome della cartella e nel
#    referto, pulizia PER NOME e MAI a wildcard, cultura INVARIANTE, \r?
#    davanti a ogni $ multilinea, raccolta SEMPRE, exit ESPLICITO su ogni
#    ramo, convenzione di sentinella su TUTTE le colonne.
#
#  ------------------------------------------------------------------
#  E QUATTRO COSE CHE IL GEMELLO NON AVEVA -- R108 E' PRE-CHECKLIST 76-80
#
#  1. checklist 79 -- LE VARIABILI DI POWERSHELL SONO CASE-INSENSITIVE.
#     R108 ha la coppia $R (l'ArrayList del referto) / $r (variabili di
#     ciclo) come MINA DISINNESCATA: e' innocua solo perche' tutti i
#     foreach($r ...) stanno PRIMA della riga che crea $R, e basta
#     spostare una riga per armarla. Qui l'ArrayList si chiama $RefTxt.
#     E NESSUNA data ha un nome corto: $Da/$A sono VIETATI (il difetto
#     che ha bruciato un pin a R109), si chiamano $MetroDataDa,
#     $M30DataDa, $M30IS_DataDa... e i parametri delle fabbriche
#     $DataDa/$DataA. Anche le due variabili di comodo del gate della
#     stella, che a scope di SCRIPT si chiamavano $a e $b, adesso si
#     chiamano $RigheMetro e $RigheCella.
#  2. checklist 79 punto 3 -- LE DATE SONO UN PARAMETRO COME GLI ALTRI.
#     GateDate controlla gli ARGOMENTI di ENTRAMBE le fabbriche (forma,
#     giorno che esiste, verso), GateDateIni rilegge FromDate e ToDate
#     DALL'INI PRODOTTO, e il giro a vuoto li RISTAMPA. In R109 il giro a
#     vuoto usciva ESITO OK, codice 0, con dentro un ToDate fatto di 41
#     righe di input incollate.
#  3. checklist 76 -- LA VARIABILE DEL foreach SOPRAVVIVE AL CICLO. Le
#     frasi di ripresa in fondo al referto sono in APICI SINGOLI: in R108
#     sono in apici doppi e MISURATO nella sua corsa vera si sono mangiate
#     il testo dell'ultimo PROBLEMA al posto del comando.
#  4. checklist 72 -- IL GATE DELL'ANTENATO, RADDOPPIATO. R108 ne aveva
#     uno (contro R103); qui sono DUE, perche' le celle metro di R111 sono
#     copiate da R108, non da R103: si confrontano con ENTRAMBI.
#  ------------------------------------------------------------------
#
#  ------------------------------------------------------------------
#  PERCHE' QUESTO DRIVER NON CHIAMA walkforward_generico.ps1
#  (e' una scelta, e va dichiarata perche' e' il primo round dopo R103
#   che se ne stacca)
#
#  Il PASSO 0 di R111 chiede IL TAKE IN PIP e LA DURATA IN BARRE: sono
#  grandezze PER OPERAZIONE, e servono ENTRAMBI i prezzi (ingresso E
#  uscita). Gli unici due artefatti che li contengono sono:
#    - il report .htm della PASSATA SINGOLA (Optimization=0) -> SI',
#      la tabella Deal ha Ora, Direzione, Tipo, Volume, PREZZO, Profitto,
#      Commissioni e Swap;
#    - il file per-trade dell'EA (abtg_trades_*.csv, ExportTrades() in
#      OnTester) -> NO: MISURATO nel sorgente il 25/08, scrive SOLO i
#      deal di USCITA (riga 1531: `if(entry!=DEAL_ENTRY_OUT ...) continue`),
#      quindi il prezzo d'ingresso NON C'E' e il take NON e' calcolabile.
#  walkforward_generico.ps1 fa SOLO Optimization=1 e SOLO due finestre per
#  invocazione: non puo' produrre la passata singola sulla finestra
#  intera. Percio' questo driver scrive i suoi .ini, con la stessa
#  fabbrica di R103 (che quei numeri li produceva gia').
#  >>> E' la TRADUZIONE DICHIARATA che pretende la checklist 57: (1) lo
#      strumento nominato nel file prova non puo' produrre la misura,
#      (2) la misura si fa QUI, (3) l'INTENTO ("letto dalle serie per
#      operazione, non dal riepilogo") e' conservato. La stessa frase sta
#      nei criteri par. 1.2 e finisce nel referto.
#  ------------------------------------------------------------------
#
#  COSA FA, in ordine, e DA SOLA:
#    0.     si rifiuta di partire se MT5 O MetaEditor sono aperti
#    0-bis. si rifiuta di CORRERE se i criteri non sono firmati
#    1.     scarica AL PIN: i 6 file prova, i 3 ANTENATI R108, i 3
#           ANTENATI R103, il sorgente .mq5, l'include
#           ABTG_PausaGuardian.mqh e (se c'e') la misura dei TICK
#           - GATE DI VERSIONE sul .mq5 (marcatore preso DAL SORGENTE)
#           - GATE DELLE RIGHE VIVE (70 per file, MISURATE il 25/08)
#           - GATE DELLA STELLA: la cella M30 differisce dalla sua cella
#             metro ESATTAMENTE su InpTF (+ InpMagic), e su nient'altro
#           - DUE GATE DELL'ANTENATO (checklist 72): la cella METRO e'
#             identica (a) al file prova METRO DI R108 da cui e' copiata,
#             salvo InpMagic/InpComment, e (b) al file prova di R103,
#             salvo InpMagic/InpComment/InpNewsCurrencies. E' il gate che
#             vede la corruzione SIMMETRICA (la stessa riga storta in
#             ENTRAMBE le celle di un simbolo), che la stella per
#             costruzione non puo' vedere. DUE e non uno: R108 e' la
#             copia da cui R111 nasce, R103 e' l'originale -- se qualcuno
#             avesse corrotto R108 DOPO la sua corsa, lo vede il secondo.
#           - GATE DEI VALORI: InpTF 16385/30 e InpPatternMode VIVO
#           - GATE DELL'ASSE UNICO: un solo flag Y, ed e' InpMagic
#           - GATE DEI MAGIC: unici, vergini, mai un magic vivo
#           - GATE DELLE DATE (checklist 79): forma, giorno che esiste,
#             verso -- sugli ARGOMENTI e poi RILETTI DALL'INI PRODOTTO
#    2.     FASE COMPILA: invocazione DIRETTA di metaeditor64.exe,
#           verdetto sul LastWriteTime del .ex5 (checklist 69)
#    3.     PASSO 0 PER SIMBOLO = la cella METRO H1. Da li' escono:
#             (a) IGIENE GEMELLI: le due righe identiche al centesimo
#             (b) GATE G0: PF/DD/n E LA PRIMA OPERAZIONE contro i numeri
#                 agli atti di R103
#           Se (a) o (b) falliscono, quel SIMBOLO si ferma e la sua cella
#           M30 NON viene lanciata. Gli ALTRI simboli vanno avanti.
#    4.     la cella M30: passata SINGOLA (-> PASSO 0: prima operazione,
#           TAKE in pip, durata in barre, peggior giornata) + gemelle
#           sulla finestra intera + gemelle IS + gemelle OOS.
#    5.     raccolta SEMPRE: cartella sul Desktop + zip + REFERTO con la
#           TABELLA MADRE e i numeri attesi DICHIARATI PRIMA.
#
#  QUELLO CHE NON FA, dichiarato:
#    - NON TOCCA ABTG_BreakingBand.mq5. Zero righe di MQL5. A M30 ci si
#      arriva via input: InpTF esiste (riga 213 del sorgente), e'
#      ENUM_TIMEFRAMES, e PERIOD_M30 vale 30.
#      >>> E il sorgente stesso, alla riga 213, commenta l'input cosi':
#          "// TF operativo (guida: D1/H4/H1/M30)". M30 STA nella lista
#          dei TF che l'autore del motore dichiara; M15 NON c'era. E'
#          una riga LETTA nel sorgente il 25/08, non un ricordo.
#    - NON GIUDICA. Produce i numeri e li mette a referto. I cancelli
#      G2 (merito) e G3 (coerenza cross-simbolo) li applica il REFERTO
#      DEL ROUND, a mano, CONTRO LA TABELLA DEI QUATTRO ESITI dei criteri
#      par. 8: G3 e' un ragionamento su TRE tabelle.
#    - NON promuove niente e NON tocca il forward (G5). Magic VERGINI
#      764xxx (blocco verificato libero in tutto il repo il 25/08: zero
#      occorrenze di 7640xx). Sono vietati e controllati i magic delle
#      sedie vive e quelli di R103 (7600xx: sono proprio le tre
#      BreakingBand di questo round), R107 (7610xx), R108 (7620xx, il
#      round gemello), R110 (7630xx e 7631-7633xx) e R109 (7744xx).
#    - NON MISURA LO SPREAD. Usa il valore DICHIARATO nei criteri (D4) e
#      stampa [SPREAD NON MISURATO] accanto a ogni verdetto S0a. E' lo
#      STESSO valore di R108 apposta: cambiarlo renderebbe i due S0a
#      incomparabili, e il confronto M15<->M30 e' meta' del round.
#    - NON MISURA LA PROFONDITA' DEI TICK. La cerca al pin; se non la
#      trova scrive un RILIEVO OBBLIGATORIO e non lo nasconde (criteri
#      par. 4.3, decisione D2). >>> E qui la finestra e' il DOPPIO di
#      R108: se i tick reali di BCM partissero dopo il 2018, la meta' IS
#      girerebbe su un ripiego SENZA DIRLO.
#    - NON scarica storico e NON svuota bases\<server>\ticks.
#    - non fa la prova di regime, non misura i sotto-periodi, e non
#      inventa nessun numero non letto in un artefatto.
#    - non ammazza un lavoro in corso allo scadere di -OreMax: smette
#      solo di iniziarne di nuovi (checklist 19).
#
#  QUANTO CI METTE: [STIMA], non una previsione -- ma stavolta poggia su
#  un MISURATO. R108 ha fatto LE STESSE 30 passate (12 metro in OHLC + 18
#  a TICK REALI su 4 anni di M15) in 24 MINUTI, corsa vera del 25/08 agli
#  atti. Qui le 12 passate metro sono IDENTICHE; le 18 a tick reali
#  girano su 8 anni di M30: le BARRE sono circa le stesse (~100.000 in
#  entrambi i casi, e' lo stesso tetto), i TICK sono circa il DOPPIO
#  perche' la finestra e' doppia. -> STIMA 40-60 MINUTI.
#  -OreMax e' 12 (tetto sull'INIZIO di nuovi lavori), con margine largo
#  apposta: una stima non e' una promessa.
#
#  LA RIGA CHE SI INCOLLA (blocco INTERO, un comando solo - checklist 21).
#  <PIN> = il commit che contiene QUESTO file: e' l'hash dato in chat.
#
#  & { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
#      if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
#      $pin='<PIN>'; $p="$env:USERPROFILE\RIGA_R111.ps1"; Remove-Item $p -EA SilentlyContinue;
#      irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_R111_BB_M30.ps1" -OutFile $p;
#      if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_R111_v1' -Quiet)){ throw 'SCRIPT VECCHIO' };
#      $global:LASTEXITCODE=0; & $p -Pin $pin -SoloControllo; if($LASTEXITCODE -ne 0){ Write-Host 'ESITO: PARZIALE O FERMO - leggi il REFERTO' } }
#
#  GIRO A VUOTO: e' quello qui sopra (-SoloControllo). Scrive e verifica
#  GLI STESSI .ini che girano nella corsa vera. Non c'e' un secondo
#  artefatto (checklist 33).
#  >>> E NON MISURA NESSUN NUMERO: senza tester non esiste nessun n,
#      nessun PF, nessun DD, nessun G0 e NESSUN S0. Sta scritto anche
#      nel suo referto, perche' non lo si scambi per il round.
# =====================================================================
# >>> [CmdletBinding()] NON E' DECORAZIONE, ED E' MISURATO (25/08, verifica
#     di R111). Un .ps1 con il solo `param()` NON RIFIUTA i parametri che
#     non conosce: li infila in $args e TIRA DRITTO, in silenzio.
#     Riprodotto: `& $p -Pin X -Riprendi` su uno script che non ha
#     -Riprendi stampa "args=[-Riprendi]" e prosegue, uscita 0.
#     Conseguenza per QUESTA riga: un `-SoloControlo` con una L sola non e'
#     un giro a vuoto, e' LA CORSA VERA -- 18 passate a tick reali su 8 anni
#     di M30, avviate credendo di fare il controllo da un minuto. Con
#     [CmdletBinding()] lo stesso refuso e' un errore di binding e lo script
#     muore PRIMA di aprire MT5.
[CmdletBinding()]
param(
  # -Pin NON ha default: un default silenzioso ("lavoro") farebbe girare la
  #  punta del branch spacciandola per un commit congelato. Meglio morire.
  [string]$Pin        = "",
  [double]$OreMax     = 12.0,      # oltre questo NON si iniziano nuovi lavori
  [switch]$SoloControllo,          # giro a vuoto: NON apre MT5
  [switch]$CriteriFirmati,         # >>> lo preme CLAUDIO, non l'agente. Senza,
                                   #     la corsa vera non parte (exit 2).
  # >>> NON ESISTE NESSUN -Riprendi, ed e' una scelta scritta (verifica del
  #     25/08): la v1 lo dichiarava fra i parametri con il commento "salta i
  #     lanci il cui artefatto c'e' gia'" e POI NON LO CONSULTAVA MAI. Un
  #     interruttore documentato che non fa niente e' la guardia decorativa
  #     del punto 14 applicata alla RIPRESA: chi lo passa dopo una corsa
  #     interrotta crede di riprendere e RIFA' TUTTO da capo (18 passate a
  #     tick reali). Tolto: chi lo scrive adesso prende un errore di binding
  #     e muore subito. La ripresa VERA, implementata e provata, e'
  #     -SoloSimbolo / -SoloCella.
  [switch]$ScreenOhlcM30,          # screen VELOCE: le celle M30 girano a
                                   #  MODELLO 1 (OHLC M1) invece che a tick
                                   #  reali. In questo modo il round NON
                                   #  produce nessun giudizio: ogni riga M30
                                   #  esce marcata NON GIUDICABILE, e la
                                   #  cartella si chiama SCREENOHLC.
                                   #  >>> checklist 67: la regola "un OHLC e
                                   #  un tick reale non devono nemmeno poter
                                   #  finire nella stessa tabella" qui e' un
                                   #  if, non una frase.
  [string]$SoloSimbolo = "",       # "GBPUSD" | "EURUSD" | "AUDUSD", anche in
                                   #  elenco: 'GBPUSD,EURUSD' o 'GBPUSD EURUSD'.
                                   #  FRA APICI (checklist 65).
  [string]$SoloCella   = ""        # es. "R111_GBPUSD_01_m30.txt": una cella
                                   #  sola (la sua cella METRO gira lo stesso:
                                   #  senza il metro il numero non si legge)
)
$ErrorActionPreference = "Stop"
[Threading.Thread]::CurrentThread.CurrentCulture   = [Globalization.CultureInfo]::InvariantCulture
[Threading.Thread]::CurrentThread.CurrentUICulture = [Globalization.CultureInfo]::InvariantCulture
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$INV = [Globalization.CultureInfo]::InvariantCulture

$Avvio  = Get-Date
$Stamp  = $Avvio.ToString("yyyyMMdd_HHmm", $INV)
$Dsk    = Join-Path $env:USERPROFILE "Desktop"
$Work   = Join-Path $env:USERPROFILE "abtg_r111"
$Prove  = Join-Path $Work "prove"
$Logs   = Join-Path $Work "log_r111"
$SrcDir = Join-Path $Work "src_motori"
$RawPin = "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$Pin"

$NomeEa    = "ABTG_BreakingBand"
$EaVer     = "1.03"              # LETTA nel sorgente al pin il 25/08
$RigheAtte = 70                  # MISURATE sui sei file, non a memoria
$Deposito  = 100000              # come R103: e' anche la taglia prop
$SpreadIni = 0                   # 0 = spread CORRENTE, ma SCRITTO nell'ini
                                 #  invece che lasciato allo stato nascosto del
                                 #  terminale. NON e' uno stress e NON e' una
                                 #  misura dello spread (criteri par. 3.3).
$CelleAttese = 2                 # le due passate GEMELLE, per CSV

#--- LO SPREAD DI RIFERIMENTO DI S0a. E' [NON MISURATO]: criteri D4.
#    Non e' una misura del feed BCM, e' un valore PRUDENZIALE DICHIARATO.
#    Ogni verdetto S0a esce con l'etichetta [SPREAD NON MISURATO] accanto.
#    >>> E' LO STESSO VALORE DI R108, APPOSTA: cambiarlo renderebbe i due
#        verdetti S0a incomparabili, e il confronto M15<->M30 e' meta' del
#        round (criteri D4).
$SpreadPipDich = 1.5
$S0aMult       = 3.0             # take LORDO mediano >= 3 x spread
$S0aBanda      = 0.5             # se il rapporto cade in 3.0 +- 0.5 il
                                 #  verdetto NON si da': si misura lo spread
                                 #  e si rilegge (criteri D4).

# ---------------------------------------------------------------------
#  LE FINESTRE. Criteri par. 4.
#  >>> NOMI LUNGHI, ED E' LA CHECKLIST 79 (difetto girato sul PC di
#      Claudio il 25/08): in PowerShell le variabili sono CASE-INSENSITIVE,
#      quindi un $a di comodo dentro un ciclo DISTRUGGE un $A di
#      configurazione. $Da e $A sono VIETATI in questo file.
# ---------------------------------------------------------------------
$MetroDataDa   = "2020.01.01"    # R103: la finestra del gruppo FOREX
$MetroDataA    = "2026.06.30"
#  LA FINESTRA M30: 8 anni. DERIVATA dal tetto delle 100.000 barre e NON
#  MISURATA -- forex ~240 barre M30 a settimana -> 100.000/240 = 416,7
#  settimane = 8,0 anni, cioe' ESATTAMENTE questa finestra.
#  >>> SIAMO AL LIMITE DEL TETTO, NON SOTTO (in R108 il margine c'era).
#      Il PASSO 0 lo verifica con la data della PRIMA OPERAZIONE VERA, e
#      se esce ACCORCIATA la divisione 4+4 non e' piu' 4+4: va riscritta
#      nel referto PRIMA delle tabelle (criteri par. 4.2).
$M30DataDa     = "2018.07.01"
$M30DataA      = "2026.06.30"
#  DIVISIONE 4+4 ANNI (criteri D3), e NON il 2+2 di R108 ne' il 40/60
#  degli altri round. Due ragioni, tutte e due dichiarate:
#   (a) le due meta' contengono DUE REGIMI DIVERSI (IS: pre-Covid, crollo
#       marzo 2020, tassi a zero; OOS: ciclo di rialzo, 2023 laterale,
#       direzionalita' 2025) -- Emendamento regola C;
#   (b) IL PONTE: l'OOS di R111 E' LA FINESTRA INTERA DI R108 (M15).
#       Stessa epoca, stessi simboli, stesso motore, stesso modello: fra
#       le due cambia UNA COSA SOLA, il timeframe. E' il confronto piu'
#       pulito che questo round puo' produrre (criteri par. 4.1).
#  >>> COSTO DICHIARATO: questi CSV IS/OOS NON sono confrontabili ne' col
#      40/60 degli altri round ne' col 2+2 di R108.
$M30IS_DataDa  = "2018.07.01"
$M30IS_DataA   = "2022.06.30"
$M30OOS_DataDa = "2022.07.01"
$M30OOS_DataA  = "2026.06.30"
$MesiPrimaOp = 6                 # prima operazione entro N mesi = FINESTRA PIENA

#--- I MAGIC VIETATI: le sedie vive, i magic di R103 (che sono proprio le
#    tre BreakingBand di questo round!) e quelli dei round recenti --
#    R108 COMPRESO, che e' il gemello di questo.
$MagicVietati = @(760020,760021,760030,760031,760040,760041,   # <<< R103 BB: GBP/EUR/AUD
                  772161,772162,772163,                        # id sedia R103 BB
                  770202,770101,770201,                        # aperture (vive e spente)
                  770611,770601,770411,770901,770511,970913,   # sedie confinanti
                  971501,770402,970901,770532,772341,          # oro / forex vive
                  770512,770531,771501,771531,970911,970912,   # indici vivi/spenti
                  970914,771511,771512,771513,771514,771515,   # famiglia EMA200
                  770923,770924,770925,771321,771322,771323,   # SupRev / PTE
                  771332,                                      # Larry
                  772601,772602,772611,772612,                 # R54
                  772800,772890,772891,                        # R98
                  773200,773201,773300,773301,                 # R101
                  750010,750011,                               # R104
                  761000,761001,761010,761011,761100,761101,   # R107
                  761110,761111,761200,761201,761210,761211,
                  762000,762001,762010,762011,762020,762021,   # R108 (IL GEMELLO)
                  762030,762031,762040,762041,762050,762051,
                  763000,763010,763020,763100,763110,763120,   # R110
                  763200,763210,763220,763300,763310,763320,
                  774400,774401,774410,774420,774430,774440,   # R109 (+ default EA)
                  774450,774460)

# =====================================================================
#  LE SEI CELLE. Due per simbolo, e fra loro cambia SOLO InpTF.
#
#  >>> DA DOVE VIENE OGNI COLONNA (criteri par. 0 e 2):
#      - Pat        : InpPatternMode VIVO, LETTO nei file prova di R103
#                     (GBPUSD 2, EURUSD 0, AUDUSD 1). NON e' 2 per tutti:
#                     e' il difetto n.2 del file del cacciatore.
#      - PfAtti / DdAtti / NAtti / PrimaAtti : MISURATI e agli atti,
#                     R103_REFERTO_DRIVER_FOREX_METALLI_20260824_1922.txt
#                     TABELLA 1 (e le righe 156/229/302 per la prima op).
#      - Base       : magic. Blocco 764xxx VERGINE (verificato il 25/08:
#                     `grep -rEo '\b7640[0-9]{2}\b'` su tutto il repo da'
#                     ZERO occorrenze).
#      - Pip        : ampiezza del pip. I tre sono XXXUSD a 5 cifre.
#
#  >>> NAtteM30 = LA FREQUENZA ATTESA A M30 SULLA FINESTRA INTERA, e NON
#      e' una stima a tavolino: e' l'INTERPOLAZIONE GEOMETRICA fra DUE
#      PUNTI MISURATI -- il tasso annuo a H1 (R103) e quello a M15 (R108).
#      Resta [INFERITA] e il referto la stampa come tale, ma e' un altro
#      mestiere rispetto al "~155 per finestra" di R108, che nasceva da
#      "le barre sono 4x" e MISURATO era falso.
#
#  >>> CHECKLIST 64: OGNI parametro e' TIPIZZATO e ogni confronto con un
#      sentinella e' CASTATO SUL POSTO. Senza il tipo, un -1 posizionale
#      arriva come STRINGA, e "stringa -gt 0" e' un confronto culture-aware
#      che dice VERO su Windows e FALSO su Linux (difetto pagato il 23/08
#      sulla famiglia DAX di R101).
# =====================================================================
function S([string]$sym,[int]$pat,[double]$pf,[double]$dd,[int]$n,
          [string]$primaOp,[double]$prof,[int]$baseMetro,[int]$baseM30,[double]$pip,
          [double]$annoH1,[double]$annoM15,[int]$natteM30){
  return [pscustomobject]@{
    Sym=$sym; Pat=$pat; PfAtti=$pf; DdAtti=$dd; NAtti=$n; PrimaAtti=$primaOp;
    ProfAtti=$prof; BaseMetro=$baseMetro; BaseM30=$baseM30; Pip=$pip;
    AnnoH1=$annoH1; AnnoM15=$annoM15; NAtteM30=$natteM30;
    # --- riempiti durante la corsa
    Metro="NON MISURATO"; Gemelli="NON MISURATO"; Fermo=$false;
    TickMisurati="NON MISURATA"
  }
}
#              sym      pat  PF     DD    n   prima op.    prof   metro  m30    pip     /annoH1 /annoM15 attesiM30(8y)
$SIMBOLI = @(
  (S "GBPUSD" 2 1.199 7.75 126 "2020.01.14" 5415.0 764000 764010 0.0001  19.4  56.8  265),
  (S "EURUSD" 0 1.936 2.51  59 "2020.02.03" 8271.0 764020 764030 0.0001   9.1  21.8  113),
  (S "AUDUSD" 1 1.541 2.13  64 "2020.02.05" 5365.0 764040 764050 0.0001   9.9  29.5  136)
)

# ---------------------------------------------------------------------
#  I DUE ANTENATI DI OGNI CELLA METRO -- checklist 72.
#
#  La cella METRO di R111 e' la copia riga per riga della cella METRO di
#  R108, che a sua volta e' la copia della cella VIVA di R103. Si
#  confronta con TUTTE E DUE, e non e' zelo:
#    - R108 e' la copia da cui R111 NASCE. Se qualcuno avesse toccato una
#      riga copiando, lo vede questo.
#    - R103 e' l'ORIGINALE, ed e' la fonte dei numeri del gate G0. Se
#      qualcuno avesse corrotto il file di R108 DOPO la sua corsa, il
#      primo gate resterebbe verde e il secondo no.
#  >>> Il gate della STELLA non puo' sostituirli: confronta le due celle
#      di un simbolo FRA LORO, quindi la STESSA riga storta in ENTRAMBE
#      gli e' invisibile per costruzione (misurato in R108: InpBBPeriod
#      20->25 nelle due celle di GBPUSD passava TUTTI i gate, uscita 0).
#  >>> costruiti chiave per chiave e NON con un hashtable letterale
#      multilinea: e' la classe di difetto 63 (una virgola a fine riga e
#      lo script non PARSA, e nessuna guardia interna la intercetta).
# ---------------------------------------------------------------------
$AntenatoR108 = @{}
$AntenatoR108["GBPUSD"] = "R108_GBPUSD_00_metroH1.txt"
$AntenatoR108["EURUSD"] = "R108_EURUSD_00_metroH1.txt"
$AntenatoR108["AUDUSD"] = "R108_AUDUSD_00_metroH1.txt"
#  Delta ammessi contro R108: solo l'IDENTITA' del lancio.
#   - InpMagic  : serie vergine 764xxx invece della 762xxx di R108
#   - InpComment: usato SOLO per comporre il commento dell'ordine, e nel
#                 tester non lo legge nessuno
$DeltaAmmessiR108 = @("InpMagic","InpComment")

$AntenatoR103 = @{}
$AntenatoR103["GBPUSD"] = "R103_ABTG_BreakingBand_GBPUSD_772161.txt"
$AntenatoR103["EURUSD"] = "R103_ABTG_BreakingBand_EURUSD_772162.txt"
$AntenatoR103["AUDUSD"] = "R103_ABTG_BreakingBand_AUDUSD_772163.txt"
#  Delta ammessi contro R103: i due di sopra PIU' la riga tolta.
#   - InpNewsCurrencies: riga TOLTA gia' in R108; con InpUseNewsFilter=false
#                        il filtro non gira proprio (MISURATO nel sorgente,
#                        righe 1491-1496: `if(!InpUseNewsFilter||...) return`)
$DeltaAmmessiR103 = @("InpMagic","InpComment","InpNewsCurrencies")

# ---------------------------------------------------------------------
#  LE CELLE. 'Val' = i valori che questo file DEVE avere: il gate della
#  stella dice CHE COSA cambia, questo dice CHE COSA VALE. Se i due file
#  di un simbolo fossero SCAMBIATI, la stella resterebbe verde e questo
#  no (checklist 34-bis).
#  >>> V2 e' una FUNZIONE apposta per non scrivere hashtable letterali
#      multilinea: e' la classe di difetto 63, che non e' un errore di
#      runtime ma di PARSE, e nessuna guardia interna la intercetta.
# ---------------------------------------------------------------------
function V2([string]$tf,[string]$pat){
  $h = @{}
  $h["InpTF"]          = $tf
  $h["InpPatternMode"] = $pat
  return $h
}
function C([string]$sym,[string]$id,[string]$file,[string]$desc,[bool]$metro,
           [string]$tf,[string]$DataDa,[string]$DataA,$val){
  return [pscustomobject]@{
    Sym=$sym; Id=$id; Prova=$file; Desc=$desc; Metro=$metro; Tf=$tf; DataDa=$DataDa; DataA=$DataA;
    Val=$val; Base=0; Modello=1; Esito="NON ESEGUITA"; Min=0.0;
    # --- gemelle: finestra INTERA
    PfInt=-1.0; DdInt=-1.0; NInt=-1; ProfInt=-999999.0; PgInt=99.9; GemInt="NON MISURATO";
    # --- gemelle: IS e OOS (solo celle M30)
    PfIS=-1.0;  DdIS=-1.0;  NIS=-1;  ProfIS=-999999.0;  GemIS="NON MISURATO";  PgIS=99.9;
    PfOOS=-1.0; DdOOS=-1.0; NOOS=-1; ProfOOS=-999999.0; GemOOS="NON MISURATO"; PgOOS=99.9;
    # --- PASSO 0, dalla passata SINGOLA (report .htm)
    P0Stato="NON MISURATO"; P0Prima="NON MISURATA"; P0N=-1; P0Finestra="NON MISURATA";
    P0Ordinamento="NON MISURATO"; P0GruppiPari=-1;
    P0TakeNetMed=-1.0; P0TakeNetMedia=-1.0; P0TakeLordoMed=-1.0; P0Rapporto=-1.0;
    P0PerdMed=-1.0; P0DurMed=-1.0; P0DurMedia=-1.0; P0Pegg=99.9; P0PeggData="n/d";
    S0a="NON MISURATO"
  }
}
$CELLE = @()
foreach($s in $SIMBOLI){
  $cm = (C $s.Sym "00_metroH1" ("R111_" + $s.Sym + "_00_metroH1.txt") `
           "IL METRO -- la cella VIVA di R103 a H1. Gate G0: deve RIPRODURRE, non convincere." `
           $true "H1" $MetroDataDa $MetroDataA (V2 "16385" ("" + $s.Pat)))
  $cm.Base = [int]$s.BaseMetro
  $cm.Modello = 1                       # OHLC M1: R103 e' girato cosi' (D1)
  $c30 = (C $s.Sym "01_m30" ("R111_" + $s.Sym + "_01_m30.txt") `
            "LA MISURA NUOVA -- lo stesso motore a M30. Unico input diverso: InpTF." `
            $false "M30" $M30DataDa $M30DataA (V2 "30" ("" + $s.Pat)))
  $c30.Base = [int]$s.BaseM30
  $c30.Modello = 4                      # TICK REALI: e' il giudizio (criteri par. 1)
  if($ScreenOhlcM30){ $c30.Modello = 1 }
  $CELLE += $cm
  $CELLE += $c30
}

# =====================================================================
#  TUTTO CIO' CHE LA RACCOLTA USA NASCE QUI, PRIMA DEL try
#  (checklist 41-bis), FUNZIONI COMPRESE (checklist 48: in PowerShell una
#  `function` non e' dichiarativa, e' un'ISTRUZIONE: se il flusso non ci
#  passa sopra il nome non esiste, e la raccolta esplode proprio nella
#  corsa fermata da un gate -- cioe' l'unica in cui il referto serve).
# =====================================================================
$Risultati = Join-Path $Work "risultati_prove"
$Sosta     = Join-Path $Work "sosta"
$Problemi  = New-Object System.Collections.ArrayList
$Rilievi   = New-Object System.Collections.ArrayList
$Fatale    = ""
$Firma     = "NON LETTA"
$Terminal  = ""; $MetaEditor = ""; $DataFolder = ""; $InstDir = ""
$MqlFiles  = ""; $CommonFiles = ""
$Ordinati  = @()      # checklist 41-bis: la raccolta lo scorre SEMPRE
$Vive      = @{}
$SimFermi  = @()
$SelettoreAVuoto = $false
$nAnt      = -1
$Compilato = $false

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
function ValoreDi([string]$riga){
  $i = $riga.IndexOf("=")
  if($i -lt 0){ return "" }
  $resto = $riga.Substring($i+1)
  return (($resto -split '\|\|')[0]).Trim()
}
function NumInv($s){
  $v = 0.0
  #  MISURATO sui report veri: MT5 scrive le migliaia con lo SPAZIO
  #  ("9 005.54"). Si tolgono tutti gli spazi, compresi i tipografici
  #  (nbsp 160, narrow-nbsp 8239, thin space 8201).
  $t = ("" + $s).Replace([string][char]160,"").Replace([string][char]8239,"").Replace([string][char]8201,"").Replace(" ","").Replace("&nbsp;","").Trim()
  if($t -eq ""){ return $null }
  if([double]::TryParse($t,[Globalization.NumberStyles]::Float,$INV,[ref]$v)){ return $v }
  return $null
}

# ---------------------------------------------------------------------
#  LA CONVENZIONE DI SENTINELLA, E VALE PER TUTTE LE COLONNE.
#  checklist 66: in R103 era applicata a META' delle colonne, e il PF non
#  misurato usciva "0.000", cioe' un numero PLAUSIBILE che si legge "ha
#  perso tutto". Qui:
#    - i decimali NON MISURATI valgono -1.0   -> Fmt2/Fmt3 -> "n/d"
#    - gli interi NON MISURATI valgono -1     -> FmtN      -> "n/d"
#    - il PROFITTO non misurato vale -999999  -> FmtE      -> "n/d"
#    - la PEGGIOR GIORNATA non misurata vale 99.9 -> FmtPg -> "n/d"
#  Le due colonne che NON possono usare -1 sono il PROFITTO (negativo ogni
#  volta che la cella perde) e la PEGGIOR GIORNATA (negativa SEMPRE: con
#  Fmt2 l'intera colonna sarebbe uscita "n/d" su valori misurati).
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
  #  lo legge "due virgola otto".
  return ([double]$v).ToString("+0;-0;0",$INV)
}
function FmtPg($v){
  if($null -eq $v){ return "n/d" }
  if([double]$v -ge 99.0){ return "n/d" }
  return ([double]$v).ToString("0.00",$INV)
}
function Mediana($lista){
  #  >>> CHECKLIST 81, e qui il sort E' LEGITTIMO -- va dichiarato perche'
  #      "c'e' un Sort-Object" non e' piu' una cosa che si passa in silenzio.
  #      La CHIAVE di ordinamento E' L'ELEMENTO STESSO (una lista di double):
  #      due chiavi uguali sono due VALORI IDENTICI, quindi l'ordine
  #      arbitrario fra loro non puo' cambiare nessun risultato -- la mediana
  #      pesca per POSIZIONE, e in quella posizione c'e' lo stesso numero
  #      comunque siano disposti i pari. E' l'unico caso in cui l'instabilita'
  #      di Sort-Object e' inerte: quando i pari sono indistinguibili.
  $ordinata = @($lista | Sort-Object)
  if($ordinata.Count -eq 0){ return -1.0 }
  if($ordinata.Count % 2 -eq 1){ return [double]$ordinata[[int](($ordinata.Count-1)/2)] }
  return ([double]$ordinata[$ordinata.Count/2 - 1] + [double]$ordinata[$ordinata.Count/2]) / 2.0
}

# =====================================================================
#  IL GATE DELLE DATE -- checklist 79, punto 3.
#
#  IL DIFETTO CHE LO IMPONE, e non e' teorico: e' ARRIVATO FINO AL PC DI
#  CLAUDIO. Il 25/08 il giro a vuoto di R109 e' uscito "ESITO: OK", codice
#  0, con dentro un .ini che diceva:
#      FromDate=2024.09.26
#      ToDate=InpUsaGuardian=true||true||0||true||N InpPivotLeft=5||...
#  Causa: le variabili di PowerShell sono CASE-INSENSITIVE, un $a di comodo
#  del gate della stella aveva distrutto il $A della configurazione, e le
#  fabbriche di .ini avevano gate su 41 parametri, Period, Model, Symbol,
#  l'asse Y, il magic e AllowLiveTrading -- e NESSUNO SULLE DATE. La
#  finestra e' META' di quello che un backtest misura, e non era
#  controllata. E MT5 con un ToDate invalido NON PROTESTA: la corsa vera
#  avrebbe prodotto numeri plausibili su una finestra NON DICHIARATA.
#  L'ha trovato Claudio, APRENDO UN .ini DELLO ZIP.
#
#  Qui il controllo e' in DUE tempi, ed e' voluto:
#    GateDate    -> sugli ARGOMENTI, dentro la fabbrica, PRIMA di scrivere
#    GateDateIni -> sull'ARTEFATTO, rileggendo il testo appena scritto
#  >>> La lezione di metodo, che vale piu' del difetto: provare una
#      funzione chiamandola da un test dimostra che LA FUNZIONE e' giusta,
#      NON che riceve GLI ARGOMENTI giusti. Il secondo controllo legge
#      quello che finira' davvero nel tester.
# =====================================================================
function GateDate([string]$DataDa,[string]$DataA,[string]$dove){
  foreach($coppia in @(@("FromDate",$DataDa),@("ToDate",$DataA))){
    $valore = "" + $coppia[1]
    if($valore -notmatch '^\d{4}\.\d{2}\.\d{2}$'){
      throw ("GATE DELLE DATE (" + $dove + "): " + $coppia[0] + " vale '" + $valore +
             "' e NON e' nella forma yyyy.MM.dd. E' il difetto 79: una variabile di configurazione schiacciata da una temporanea, oppure un array convertito in stringa con lo spazio. MT5 NON protesterebbe, e il round girerebbe su una finestra NON DICHIARATA.")
    }
    $d = [datetime]::MinValue
    if(-not [datetime]::TryParseExact($valore,"yyyy.MM.dd",$INV,[Globalization.DateTimeStyles]::None,[ref]$d)){
      throw ("GATE DELLE DATE (" + $dove + "): " + $coppia[0] + " vale '" + $valore +
             "', che ha la forma giusta ma NON e' un giorno che esiste (tipo 2018.02.30). La forma da sola non basta.")
    }
  }
  $d1 = [datetime]::ParseExact($DataDa,"yyyy.MM.dd",$INV)
  $d2 = [datetime]::ParseExact($DataA,"yyyy.MM.dd",$INV)
  if($d2 -le $d1){
    throw ("GATE DELLE DATE (" + $dove + "): ToDate " + $DataA + " NON e' dopo FromDate " + $DataDa + ". Una finestra al contrario o lunga zero non e' un backtest.")
  }
}
function GateDateIni([string]$testo,[string]$DataDa,[string]$DataA,[string]$dove){
  #  >>> \r? davanti a ogni $ multilinea (checklist 40) e [regex]::Escape
  #      sui punti della data, che in regex valgono "un carattere qualsiasi".
  if($testo -notmatch ('(?m)^FromDate=' + [regex]::Escape($DataDa) + '\r?$')){
    throw ("GATE DELLE DATE (" + $dove + "): nell'.ini APPENA SCRITTO non c'e' la riga 'FromDate=" + $DataDa + "'. Non e' un controllo sulla variabile: e' un controllo sull'ARTEFATTO CHE GIRA.")
  }
  if($testo -notmatch ('(?m)^ToDate=' + [regex]::Escape($DataA) + '\r?$')){
    throw ("GATE DELLE DATE (" + $dove + "): nell'.ini APPENA SCRITTO non c'e' la riga 'ToDate=" + $DataA + "'. E' esattamente il caso di R109, dove il ToDate era diventato 41 righe di input incollate.")
  }
}

# =====================================================================
#  IL PARSER DEL CSV DI OTTIMIZZAZIONE -- con il CONTROLLO POSITIVO.
#
#  Il bug di R99 (una parola mancante nell'elenco dei sinonimi faceva
#  tornare una lista vuota, e il chiamante scriveva "NON MISURATA" su una
#  tabella perfettamente leggibile) qui e' impedito da tre cose:
#   1. le colonne si cercano PER NOME nell'intestazione, mai per posizione;
#   2. i sinonimi sono COMPLETI, italiano e inglese;
#   3. se NON riconosce le colonne torna $null E DICE QUALI INTESTAZIONI
#      HA VISTO -- perche' il 23/08, per scoprire la parola mancante, e'
#      servito aprire lo zip a mano.
#  L'intestazione VERA e' MISURATA nel sorgente di questo EA (OPTFRAME
#  inlined, riga 1625):
#    Pass,Profit,Expected Payoff,Profit Factor,Recovery Factor,
#    Sharpe Ratio,Equity DD %,Trades,Peggior Giornata %,...
# =====================================================================
$script:CsvIntestazioni = @()
function LeggiOpt([string]$path){
  if(-not (Test-Path -LiteralPath $path)){ return $null }
  $righe = @()
  try{ $righe = @(Import-Csv -LiteralPath $path) }catch{ return $null }
  if($righe.Count -eq 0){ return $null }
  $cols = @($righe[0].PSObject.Properties.Name)
  $script:CsvIntestazioni = $cols
  $kProf = $null; $kPf = $null; $kDd = $null; $kN = $null; $kPg = $null; $kMg = $null
  foreach($k in $cols){
    $h = ("" + $k).Trim().ToLower()
    if($null -eq $kProf -and ($h -eq "profit" -or $h -eq "profitto" -or $h -eq "utile")){ $kProf = $k }
    if($null -eq $kPf   -and ($h -eq "profit factor" -or $h -eq "fattore di profitto")){ $kPf = $k }
    if($null -eq $kDd   -and ($h -eq "equity dd %" -or $h -eq "drawdown equity %" -or $h -eq "equity drawdown %" -or $h -eq "drawdown %")){ $kDd = $k }
    if($null -eq $kN    -and ($h -eq "trades" -or $h -eq "operazioni" -or $h -eq "trade")){ $kN = $k }
    if($null -eq $kPg   -and ($h -eq "peggior giornata %" -or $h -eq "worst day %")){ $kPg = $k }
    if($null -eq $kMg   -and ($h -eq "inpmagic")){ $kMg = $k }
  }
  #  CONTROLLO POSITIVO: senza le quattro colonne che contano non si tira
  #  a indovinare. Torna $null, e chi chiama scrive "NON MISURATA".
  if($null -eq $kProf -or $null -eq $kPf -or $null -eq $kDd -or $null -eq $kN){ return $null }
  $out = New-Object System.Collections.ArrayList
  foreach($r in $righe){
    $pg = $null
    if($null -ne $kPg){ $pg = (NumInv $r.$kPg) }
    $mg = ""
    if($null -ne $kMg){ $mg = ("" + $r.$kMg).Trim() }
    [void]$out.Add([pscustomobject]@{
      Profit = (NumInv $r.$kProf); Pf = (NumInv $r.$kPf); Dd = (NumInv $r.$kDd)
      N = (NumInv $r.$kN); Pg = $pg; Magic = $mg
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

# =====================================================================
#  IL PARSER DEI DEAL DEL REPORT .htm
#  E' quello di R100/R102/R103, che nasce dal bug di R99 (il parser
#  cercava 'balance'/'saldo' e MT5 in italiano scrive BILANCIO, quindi
#  tornava una lista vuota su una tabella perfettamente leggibile).
#  >>> QUI E' ESTESO CON TRE COLONNE IN PIU' -- Tipo, Volume e PREZZO --
#      perche' senza il PREZZO non esiste nessun take in pip, cioe' non
#      esiste il PASSO 0 (criteri par. 3.4).
#  Intestazione MISURATA (MT5 italiano):
#    Ora | Affare | Simbolo | Tipo | Direzione | Volume | Prezzo |
#    Ordine | Commissioni | Swap | Profitto | Bilancio | Commento
#  Il CONTROLLO POSITIVO e' dentro: una riga vale solo se ha una data vera
#  nella colonna Ora E 'in'/'out' nella colonna Direzione. Se non ne
#  riconosce nessuna torna VUOTO, chi chiama scrive "NON MISURATA" -- e
#  dice anche QUALI intestazioni ha visto.
# =====================================================================
$script:DealIntestazioni = @()
$script:DealColonne = ""
function LeggiDeal([string]$path){
  $txt = ""
  try{
    $by = [IO.File]::ReadAllBytes($path)
    #  L'ORDINE NON SI CAMBIA: MISURATO che il report di R99 e' UTF-16, e
    #  il tentativo UTF8 su byte UTF-16 produce "<\0t\0r\0", quindi il
    #  match su '<t[dr]' fallisce correttamente e si passa a Unicode.
    $txt = [Text.Encoding]::UTF8.GetString($by)
    if($txt -notmatch '<t[dr]'){ $txt = [Text.Encoding]::Unicode.GetString($by) }
    if($txt -notmatch '<t[dr]'){ $txt = [Text.Encoding]::GetEncoding(1252).GetString($by) }
  }catch{ return @() }
  $righe = New-Object System.Collections.ArrayList
  foreach($tr in [regex]::Matches($txt,'(?s)<tr[^>]*>(.*?)</tr>')){
    $celle = New-Object System.Collections.ArrayList
    foreach($td in [regex]::Matches($tr.Groups[1].Value,'(?s)<t[dh][^>]*>(.*?)</t[dh]>')){
      $c = $td.Groups[1].Value
      $c = [regex]::Replace($c,'<[^>]+>','')
      $c = $c.Replace("&nbsp;"," ").Replace([string][char]160," ").Trim()
      [void]$celle.Add($c)
    }
    [void]$righe.Add(@($celle))
  }
  $iOra=-1; $iDir=-1; $iProf=-1; $iSald=-1; $iComm=-1; $iSwap=-1; $iPrez=-1; $iVol=-1; $iTipo=-1; $iAff=-1
  $viste = New-Object System.Collections.ArrayList
  foreach($celle in $righe){
    if($celle.Count -lt 8){ continue }
    $o=-1; $dz=-1; $p=-1; $s=-1; $c=-1; $w=-1; $pz=-1; $vl=-1; $tp=-1; $af=-1
    for($i=0; $i -lt $celle.Count; $i++){
      $h = ("" + $celle[$i]).ToLower().Trim()
      if($h -eq "time" -or $h -eq "ora" -or $h -eq "orario"){ $o = $i }
      if($h -eq "direction" -or $h -eq "direzione"){ $dz = $i }
      if($h -eq "profit" -or $h -eq "profitto" -or $h -eq "utile"){ $p = $i }
      if($h -eq "balance" -or $h -eq "saldo" -or $h -eq "bilancio"){ $s = $i }
      if($h -eq "commission" -or $h -eq "commissione" -or $h -eq "commissioni"){ $c = $i }
      if($h -eq "swap"){ $w = $i }
      if($h -eq "price" -or $h -eq "prezzo"){ $pz = $i }
      if($h -eq "volume" -or $h -eq "volumi"){ $vl = $i }
      if($h -eq "type" -or $h -eq "tipo"){ $tp = $i }
      #  >>> IL NUMERO DELL'AFFARE (il TICKET del deal). CHECKLIST 81: e' la
      #      CHIAVE DI SPAREGGIO UNIVOCA, ed e' cronologica. In R109 il parser
      #      LA SCARTAVA -- ed e' precisamente il motivo per cui, quando il
      #      Sort-Object instabile ha invertito i pari al secondo, la
      #      scorciatoia per rimediare NON ERA DISPONIBILE. Si legge SEMPRE,
      #      anche quando (quasi sempre) non serve.
      #      Attenzione a non confondersi con 'Ordine', che e' un'altra
      #      colonna: qui si vuole 'Affare' / 'Deal'.
      if($h -eq "deal" -or $h -eq "affare" -or $h -eq "affari"){ $af = $i }
    }
    #  >>> LE INTESTAZIONI SI RACCOLGONO SEMPRE, non solo quando qualcosa
    #      e' stato riconosciuto: se NESSUNA colonna viene riconosciuta il
    #      messaggio d'errore uscirebbe VUOTO, ed e' il caso in cui serve di
    #      piu' (il 23/08, per trovare la parola mancante, e' servito aprire
    #      lo zip a mano).
    if($viste.Count -lt 6){ [void]$viste.Add(($celle -join " | ")) }
    if($p -ge 0 -and $s -ge 0){ $iOra=$o; $iDir=$dz; $iProf=$p; $iSald=$s; $iComm=$c; $iSwap=$w; $iPrez=$pz; $iVol=$vl; $iTipo=$tp; $iAff=$af; break }
  }
  $script:DealIntestazioni = @($viste | Select-Object -First 6)
  if($iProf -lt 0 -or $iSald -lt 0){ return @() }
  if($iOra -lt 0){ $iOra = 0 }        # MISURATO: 'Ora' e' la prima colonna
  #  >>> IL PREZZO E' OBBLIGATORIO PER IL PASSO 0. Senza, non si tira a
  #      indovinare una colonna: si torna vuoto e chi chiama lo dichiara.
  if($iPrez -lt 0){
    $script:DealColonne = "PREZZO NON TROVATO nell'intestazione: senza il prezzo il take in pip NON esiste."
    return @()
  }
  $script:DealColonne = ("Ora=" + $iOra + " Affare=" + $iAff + " Direzione=" + $iDir + " Tipo=" + $iTipo +
                         " Volume=" + $iVol + " Prezzo=" + $iPrez + " Profitto=" + $iProf +
                         " Bilancio=" + $iSald + " Commissioni=" + $iComm + " Swap=" + $iSwap)
  #  L'AFFARE NON e' obbligatorio come il prezzo: serve solo come SPAREGGIO,
  #  e serve solo se la fonte non fosse monotona. Se manca, Passo0 lo sa e
  #  DICHIARA invece di riordinare alla cieca (checklist 81).
  if($iAff -lt 0){ $script:DealColonne += "   [colonna AFFARE NON TROVATA: nessuno spareggio univoco disponibile]" }
  $tutti = @($iOra,$iDir,$iProf,$iSald,$iComm,$iSwap,$iPrez,$iVol,$iTipo,$iAff)
  $maxi = @($tutti | Measure-Object -Maximum).Maximum
  $out = New-Object System.Collections.ArrayList
  foreach($celle in $righe){
    if($celle.Count -le $maxi){ continue }
    if($celle[$iOra] -notmatch '^\d{4}\.\d{2}\.\d{2} \d{2}:\d{2}:\d{2}$'){ continue }
    #  la direzione si legge NELLA SUA COLONNA, non scandendo tutte le
    #  celle: un 'in' dentro la colonna COMMENTO farebbe passare per deal
    #  una riga qualunque (checklist 58). MISURATO: i valori sono 'in'/'out'
    #  MINUSCOLI e NON localizzati, anche col terminale in italiano.
    $dir = ""
    if($iDir -ge 0){ $dir = ("" + $celle[$iDir]).ToLower().Trim() }
    if($dir -ne "in" -and $dir -ne "out" -and $dir -ne "in/out"){ continue }
    $d = [datetime]::MinValue
    if(-not [datetime]::TryParseExact($celle[$iOra],"yyyy.MM.dd HH:mm:ss",$INV,[Globalization.DateTimeStyles]::None,[ref]$d)){ continue }
    $pr = (NumInv $celle[$iProf])
    $cm = $null; if($iComm -ge 0){ $cm = (NumInv $celle[$iComm]) }
    $sw = $null; if($iSwap -ge 0){ $sw = (NumInv $celle[$iSwap]) }
    $netto = 0.0
    if($null -ne $pr){ $netto += [double]$pr }
    if($null -ne $cm){ $netto += [double]$cm }
    if($null -ne $sw){ $netto += [double]$sw }
    $tipo = ""; if($iTipo -ge 0){ $tipo = ("" + $celle[$iTipo]).ToLower().Trim() }
    $vol = $null; if($iVol -ge 0){ $vol = (NumInv $celle[$iVol]) }
    #  l'AFFARE si conserva come [long]: 0 = non letto, e Passo0 lo tratta
    #  come "nessuno spareggio disponibile" (checklist 81).
    $aff = [long]0
    if($iAff -ge 0){
      $vv = [long]0
      if([long]::TryParse((("" + $celle[$iAff]).Replace(" ","").Trim()),[ref]$vv)){ $aff = $vv }
    }
    [void]$out.Add([pscustomobject]@{
      Ora=$d; Affare=$aff; Dir=$dir; Tipo=$tipo; Volume=$vol; Prezzo=(NumInv $celle[$iPrez]); Netto=$netto
    })
  }
  return @($out)
}

# =====================================================================
#  IL PASSO 0 -- accoppia i deal in -> out e ne tira fuori le misure che
#  i criteri par. 3.4 chiedono. Con InpMaxPositions=1 e InpTPMode=0
#  (mediana secca, nessuna parziale) la sequenza DEVE essere alternata.
#  >>> SE NON LO E', LA MISURA SI DICHIARA NON MISURATA E NON SI STIMA.
#      E' scritto nei criteri prima di girare, e qui e' l'if che lo impone
#      (checklist 67).
# =====================================================================
function Passo0($deal,[double]$pip,[int]$barSec,[double]$deposito){
  $r = [pscustomobject]@{
    Stato="NON MISURATO"; N=-1; Prima="NON MISURATA"; Anomalie=0
    TakeNetMed=-1.0; TakeNetMedia=-1.0; PerdMed=-1.0
    DurMed=-1.0; DurMedia=-1.0; Pegg=99.9; PeggData="n/d"
    #  --- checklist 81: l'ordinamento dei deal e' una MISURA, e sta a referto
    Ordinamento="NON MISURATO"; GruppiPari=-1; FuoriOrdine=-1
  }
  if($null -eq $deal -or @($deal).Count -eq 0){ $r.Stato = "NON MISURATO (nessun deal letto dal report)"; return $r }
  # ===================================================================
  #  >>> QUI STAVA IL DIFETTO 81, ED E' COSTATO UNA CORSA VERA.
  #
  #  R109 (e R108, e questo file prima della correzione) scriveva:
  #        $ordinati = @($deal | Sort-Object Ora)
  #  un gesto DIFENSIVO -- "ordino per sicurezza" -- che introduce il
  #  difetto che vuole evitare. Sort-Object di PowerShell NON E' STABILE:
  #  sulle chiavi UGUALI l'ordine d'uscita e' ARBITRARIO, e -Stable esiste
  #  solo da PS7 (il PC di Claudio ha Windows PowerShell 5.1, quindi
  #  "aggiungo -Stable" NON e' una correzione che arriva sul posto).
  #  Su dati di mercato i PARI AL SECONDO SONO LA REGOLA, non un caso
  #  limite: una posizione chiusa e la successiva aperta dentro lo stesso
  #  secondo bastano. Ogni gruppo invertito trasforma una coppia in/out
  #  perfetta in out/in, e da li' la sequenza sembra SPAIATA.
  #  MISURATO nella corsa vera di R109: 34 FALSE ANOMALIE e 16 operazioni
  #  perse su sei celle, con il driver che accusava L'EA -- l'unico pezzo
  #  innocente della catena.
  #  >>> E IL SOSPETTO SU R108 E' ARITMETICO: il suo referto registra
  #      "EURUSD M15: 2 deal non accoppiati". Un gruppo invertito = 2
  #      anomalie e 1 operazione persa. Non e' dimostrato qui, ma e'
  #      esattamente il numero che questo difetto produce.
  #
  #  LA CORREZIONE, nei tre pezzi della regola:
  #   1. NON SI ORDINA cio' che arriva gia' ordinato: i deal dell'.htm sono
  #      in ordine di TICKET, che e' cronologico e non ha pari. Si usa
  #      L'ORDINE DELLA FONTE.
  #   2. "arriva gia' ordinato" e' un'ASSUNZIONE, e SI MISURA: si conta
  #      quante volte l'ora VA INDIETRO.
  #   3. se la fonte smentisce l'assunzione, si riordina SOLO con una
  #      chiave di SPAREGGIO UNIVOCA (il numero dell'AFFARE, che il parser
  #      adesso legge e conserva apposta) -- e si DICHIARA di averlo fatto.
  #      Se lo spareggio non c'e', NON SI MISURA.
  # ===================================================================
  $ordinati = @($deal)            # <<< L'ORDINE DELLA FONTE, non un sort
  $fuoriOrdine = 0
  for($i=1; $i -lt $ordinati.Count; $i++){
    if($ordinati[$i].Ora -lt $ordinati[$i-1].Ora){ $fuoriOrdine++ }
  }
  #  E si CONTA quanti gruppi a PARI SECONDO ci sono: e' il numero che a
  #  R109 e' servito per la diagnosi, e non costa niente misurarlo adesso.
  $gruppiPari = 0; $inGruppo = $false
  for($i=1; $i -lt $ordinati.Count; $i++){
    if($ordinati[$i].Ora -eq $ordinati[$i-1].Ora){
      if(-not $inGruppo){ $gruppiPari++; $inGruppo = $true }
    } else { $inGruppo = $false }
  }
  $r.GruppiPari  = $gruppiPari
  $r.FuoriOrdine = $fuoriOrdine
  $r.Ordinamento = "ORDINE DELLA FONTE (nessun sort): " + $gruppiPari + " gruppi a pari secondo, 0 salti all'indietro"
  if($fuoriOrdine -gt 0){
    $conAffare = @($ordinati | Where-Object { [long]$_.Affare -gt 0 }).Count
    if($conAffare -eq $ordinati.Count){
      #  spareggio UNIVOCO disponibile: si riordina, e lo si DICHIARA
      $ordinati = @($deal | Sort-Object -Property Ora, @{Expression={[long]$_.Affare}})
      $r.Ordinamento = "RIORDINATO per Ora + numero d'AFFARE (spareggio UNIVOCO): la fonte NON era monotona (" +
                       $fuoriOrdine + " salti all'indietro), " + $gruppiPari + " gruppi a pari secondo"
    } else {
      $r.Stato = "NON MISURATO: i deal NON arrivano in ordine di tempo (" + $fuoriOrdine +
                 " salti all'indietro) e la colonna AFFARE non e' leggibile su tutte le righe, quindi non esiste una chiave di SPAREGGIO UNIVOCA. Riordinare con Sort-Object Ora e basta INVENTEREBBE anomalie (checklist 81): meglio dichiarare che non si misura."
      $r.Ordinamento = $r.Stato
      return $r
    }
  }
  $apertoOra = $null; $apertoPrezzo = $null; $apertoNetto = 0.0
  $take = New-Object System.Collections.ArrayList
  $perd = New-Object System.Collections.ArrayList
  $dur  = New-Object System.Collections.ArrayList
  $perGiorno = @{}
  $n = 0; $anom = 0; $prima = $null
  foreach($d in $ordinati){
    if($d.Dir -eq "in"){
      if($null -ne $apertoOra){ $anom++ }      # due 'in' di fila: MaxPositions=1 violato
      $apertoOra = $d.Ora; $apertoPrezzo = $d.Prezzo; $apertoNetto = [double]$d.Netto
      if($null -eq $prima){ $prima = $d.Ora }
      continue
    }
    if($d.Dir -eq "out"){
      if($null -eq $apertoOra){ $anom++; continue }   # 'out' senza 'in'
      $n++
      $netto = $apertoNetto + [double]$d.Netto
      if($null -ne $apertoPrezzo -and $null -ne $d.Prezzo -and $pip -gt 0){
        $pips = [math]::Abs([double]$d.Prezzo - [double]$apertoPrezzo) / $pip
        if($netto -gt 0){ [void]$take.Add($pips) } else { [void]$perd.Add($pips) }
      }
      if($barSec -gt 0){
        [void]$dur.Add( ((New-TimeSpan -Start $apertoOra -End $d.Ora).TotalSeconds) / $barSec )
      }
      $g = $d.Ora.ToString("yyyy.MM.dd",$INV)
      if($perGiorno.ContainsKey($g)){ $perGiorno[$g] = [double]$perGiorno[$g] + $netto }
      else { $perGiorno[$g] = $netto }
      $apertoOra = $null; $apertoPrezzo = $null; $apertoNetto = 0.0
    }
  }
  $r.N = $n
  $r.Anomalie = $anom
  if($null -ne $prima){ $r.Prima = $prima.ToString("yyyy.MM.dd",$INV) }
  if($anom -gt 0){
    $r.Stato = "NON AFFIDABILE: " + $anom + " deal non accoppiati (la sequenza in/out non e' alternata)"
    return $r
  }
  if($n -eq 0){ $r.Stato = "ZERO OPERAZIONI nella finestra"; return $r }
  if(@($take).Count -gt 0){
    $r.TakeNetMed   = (Mediana $take)
    $r.TakeNetMedia = (@($take) | Measure-Object -Average).Average
  }
  if(@($perd).Count -gt 0){ $r.PerdMed = (Mediana $perd) }
  if(@($dur).Count -gt 0){
    $r.DurMed   = (Mediana $dur)
    $r.DurMedia = (@($dur) | Measure-Object -Average).Average
  }
  if($perGiorno.Count -gt 0 -and $deposito -gt 0){
    $peggio = 0.0; $quando = "n/d"
    foreach($k in $perGiorno.Keys){
      if([double]$perGiorno[$k] -lt $peggio){ $peggio = [double]$perGiorno[$k]; $quando = $k }
    }
    $r.Pegg = ($peggio / $deposito) * 100.0
    $r.PeggData = $quando
  }
  $r.Stato = "MISURATO"
  return $r
}

# =====================================================================
#  IL VERDETTO DEL CANCELLO ZERO S0a. E' una FUNZIONE e non tre righe in
#  mezzo al ciclo, per due motivi: (1) la regola dei criteri par. 3.4 sta
#  in UN posto solo, (2) e' PROVABILE senza aprire MT5 -- e un cancello
#  che non e' mai stato fatto scattare non e' dimostrato.
#  Torna un oggetto, mai una stringa sola: chi chiama ha bisogno anche del
#  lordo e del rapporto per la tabella.
# =====================================================================
function VerdettoS0a([double]$takeNetMed){
  $etich = "  [SPREAD NON MISURATO: " + $SpreadPipDich.ToString("0.0",$INV) + " pip DICHIARATO, criteri D4]"
  if($takeNetMed -lt 0){
    return [pscustomobject]@{ Lordo=-1.0; Rapporto=-1.0; Verdetto="NON MISURATO (nessun vincente, o prezzi illeggibili)" }
  }
  $lordo = $takeNetMed + $SpreadPipDich
  $rap   = $lordo / $SpreadPipDich
  $coda  = "take lordo mediano " + $lordo.ToString("0.0",$INV) + " pip = " + $rap.ToString("0.00",$INV) + "x lo spread"
  #  LA BANDA DI SOSPENSIONE VIENE PRIMA DEL CONFRONTO, ed e' voluto: un
  #  rapporto 3,01x non e' "superato", e' "non lo sappiamo" -- perche' la
  #  soglia poggia su uno spread NON MISURATO (criteri D4). Dare un
  #  verdetto secco su un numero dentro l'incertezza del suo metro e' il
  #  modo piu' elegante di sbagliare.
  if([math]::Abs($rap - $S0aMult) -le $S0aBanda){
    return [pscustomobject]@{ Lordo=$lordo; Rapporto=$rap; Verdetto=("SOSPESO -- " + $coda + ", cioe' DENTRO la banda " +
      ($S0aMult-$S0aBanda).ToString("0.0",$INV) + "-" + ($S0aMult+$S0aBanda).ToString("0.0",$INV) +
      "x: il verdetto NON si da', si misura lo spread e si rilegge (criteri D4)." + $etich) }
  }
  if($rap -ge $S0aMult){
    return [pscustomobject]@{ Lordo=$lordo; Rapporto=$rap; Verdetto=("SUPERATO -- " + $coda + " (soglia " + $S0aMult.ToString("0.0",$INV) + "x)." + $etich) }
  }
  return [pscustomobject]@{ Lordo=$lordo; Rapporto=$rap; Verdetto=("FALLITO -- " + $coda + ", sotto la soglia " + $S0aMult.ToString("0.0",$INV) + "x." + $etich) }
}

# =====================================================================
#  LA LISTA DEI LAVORI, dopo i filtri -SoloSimbolo / -SoloCella
#
#  >>> CHECKLIST 65: -SoloSimbolo si splitta su '[,\s]+', mai su ','. In
#      argument mode 'GBPUSD,EURUSD' senza apici diventa un ARRAY, e il
#      binder [string] lo unisce con uno SPAZIO: chi splitta su ',' trova
#      un token solo e il filtro non corrisponde a niente.
#  >>> CHECKLIST 68: se dopo i filtri non resta NESSUNA cella, non e'
#      "zero problemi": e' IL SELETTORE CHE NON HA CORRISPOSTO A NULLA,
#      cioe' il refuso piu' comune che esista. Ha un esito suo (exit 1).
# =====================================================================
$Lavori = @($CELLE)
if($SoloSimbolo -ne ""){
  $ss = @(($SoloSimbolo.ToUpper() -split '[,\s]+') | Where-Object { $_ -ne "" })
  $idValidi = @($SIMBOLI | ForEach-Object { $_.Sym })
  $ignoti   = @($ss | Where-Object { $idValidi -notcontains $_ })
  if($ignoti.Count -gt 0){
    Write-Host ("!!! -SoloSimbolo contiene simboli che non esistono in R111: " + ($ignoti -join ", ")) -ForegroundColor Red
    Write-Host ("    Validi: " + ($idValidi -join ", ") + ". Elenchi FRA APICI: -SoloSimbolo 'GBPUSD,EURUSD'") -ForegroundColor Yellow
    exit 1
  }
  $Lavori = @($Lavori | Where-Object { $ss -contains $_.Sym })
}
if($SoloCella -ne ""){
  $sc = @($Lavori | Where-Object { $_.Prova -eq $SoloCella })
  if($sc.Count -eq 0){
    Write-Host ("!!! -SoloCella " + $SoloCella + " non e' nella lista (dopo -SoloSimbolo). Nomi validi:") -ForegroundColor Red
    foreach($c in $CELLE){ Write-Host ("      " + $c.Prova + "   [" + $c.Sym + "]") -ForegroundColor Yellow }
    exit 1
  }
  #  >>> LA CELLA METRO DEL SUO SIMBOLO GIRA LO STESSO. E' la ripresa
  #      "vera": senza il metro non si sa se il banco e' sano, e il numero
  #      della M30 non si legge. Costa 3 passate, non una corsa sprecata.
  $symSc = $sc[0].Sym
  $Lavori = @($Lavori | Where-Object { $_.Prova -eq $SoloCella -or ($_.Sym -eq $symSc -and $_.Metro) })
}
#  >>> CHECKLIST 81 + 70: qui il sort e' LEGITTIMO e va dichiarato. -Unique
#      DEDUPLICA, quindi dopo di lui i pari NON ESISTONO PIU': l'uscita e'
#      un insieme di stringhe tutte diverse, e l'ordine e' deterministico.
#      (Il punto 70 resta: ORDINA, e l'elenco atteso va scritto alfabetico.)
$SymAttivi = @($Lavori | ForEach-Object { $_.Sym } | Sort-Object -Unique)
$SymLavoro = @($SIMBOLI | Where-Object { $SymAttivi -contains $_.Sym })
if($Lavori.Count -eq 0){ $SelettoreAVuoto = $true }

#--- il conto delle passate, calcolato DALLA LISTA e non scritto a memoria
#    (checklist 40-bis): metro = 1 singola + 2 gemelle; M30 = 1 singola +
#    2 gemelle intera + 2 IS + 2 OOS.
$PassateAttese = 0
foreach($c in $Lavori){ if($c.Metro){ $PassateAttese += 3 } else { $PassateAttese += 7 } }

Write-Host ""
Write-Host "#####################################################################" -ForegroundColor Cyan
Write-Host "#  R111 - BREAKING BAND SU M30: DOV'E' IL CONFINE DELL'EDGE?         #" -ForegroundColor Cyan
Write-Host "#  H1 VIVO (R103) ... M30 MAI MISURATO ... M15 MORTO (R108)          #" -ForegroundColor Cyan
Write-Host "#  GBPUSD + EURUSD + AUDUSD.  Unico input diverso: InpTF.            #" -ForegroundColor Cyan
Write-Host "#####################################################################" -ForegroundColor Cyan
Dico ("pin      : " + $Pin)
Dico ("cartella : " + $Work)

if($SelettoreAVuoto){
  Write-Host ""
  Write-Host "#####################################################################" -ForegroundColor Red
  Write-Host "#  IL SELETTORE NON HA CORRISPOSTO A NESSUNA CELLA.                 #" -ForegroundColor Red
  Write-Host "#####################################################################" -ForegroundColor Red
  Write-Host ("  -SoloSimbolo = '" + $SoloSimbolo + "'") -ForegroundColor Yellow
  Write-Host ("  -SoloCella   = '" + $SoloCella + "'") -ForegroundColor Yellow
  Write-Host  "  Non ho niente da fare, e questo NON e' 'tutto a posto': e' il refuso" -ForegroundColor Yellow
  Write-Host  "  piu' comune che esista (un nome storto nel selettore). Le sei celle:" -ForegroundColor Yellow
  foreach($c in $CELLE){ Write-Host ("      " + $c.Sym.PadRight(7) + " " + $c.Prova) -ForegroundColor Yellow }
  Write-Host ""
  Write-Host "ESITO: SELETTORE A VUOTO -- nessuna cella selezionata, nessun artefatto prodotto." -ForegroundColor Red
  exit 1
}

Titolo "NUMERI ATTESI (dichiarati PRIMA della corsa)"
Write-Host ("    simboli ......................  " + $SymLavoro.Count + "   (" + ($SymAttivi -join ", ") + ")") -ForegroundColor White
Write-Host  "        >>> in ORDINE ALFABETICO, non nell'ordine del dossier: la lista e'" -ForegroundColor DarkGray
Write-Host  "            costruita con Sort-Object -Unique, che ORDINA (checklist 70)." -ForegroundColor DarkGray
Write-Host ("    celle ........................  " + $Lavori.Count + "   (di cui METRO: " + @($Lavori | Where-Object { $_.Metro }).Count + ")") -ForegroundColor White
Write-Host ("    passate ......................  " + $PassateAttese + "   (metro 3 = 1 singola + 2 gemelle; M30 7 = 1 + 2 + 2 + 2)") -ForegroundColor White
Write-Host ("    righe vive per file prova ....  " + $RigheAtte) -ForegroundColor White
Write-Host ("    righe per CSV di ottimizz. ...  " + $CelleAttese + "   (le due gemelle di controllo)") -ForegroundColor White
Write-Host ""
Write-Host ("    METRO H1 : " + $MetroDataDa + " -> " + $MetroDataA + "   modello 1 (OHLC M1, come R103)") -ForegroundColor White
if($ScreenOhlcM30){
  Write-Host ("    M30      : " + $M30DataDa + " -> " + $M30DataA + "   modello 1 (OHLC M1)   <<< -ScreenOhlcM30 ACCESO") -ForegroundColor Yellow
  Write-Host  "               >>> E' UNO SCREEN. OGNI RIGA M30 DI QUESTO GIRO ESCE MARCATA" -ForegroundColor Yellow
  Write-Host  "                   'NON GIUDICABILE'. Su M30 l'OHLC inganna, ed e' MISURATO" -ForegroundColor Yellow
  Write-Host  "                   in casa (REGISTRO_TEST.md par.2). Nessun cancello si applica." -ForegroundColor Yellow
} else {
  Write-Host ("    M30      : " + $M30DataDa + " -> " + $M30DataA + "   modello 4 (TICK REALI)") -ForegroundColor White
}
Write-Host ("        IS  " + $M30IS_DataDa + " -> " + $M30IS_DataA + "     OOS " + $M30OOS_DataDa + " -> " + $M30OOS_DataA) -ForegroundColor White
Write-Host  "        >>> IL PONTE (criteri par. 4.1): l'OOS di R111 E' LA FINESTRA INTERA" -ForegroundColor White
Write-Host  "            DI R108 A M15. Stessa epoca, stessi simboli, stesso motore, stesso" -ForegroundColor White
Write-Host  "            modello: fra le due cambia UNA COSA SOLA, il timeframe." -ForegroundColor White
Write-Host  "        >>> @DAQUANDO 2018.07.01 e' DERIVATO dal tetto delle 100.000 barre" -ForegroundColor White
Write-Host  "            (240 barre M30 a settimana -> 8,0 anni): SIAMO AL LIMITE, non" -ForegroundColor White
Write-Host  "            sotto. Se il PASSO 0 dice FINESTRA ACCORCIATA, il 4+4 non e' piu'" -ForegroundColor White
Write-Host  "            4+4 e va riscritto nel referto PRIMA delle tabelle." -ForegroundColor White
Write-Host ""
Write-Host  "    LA FREQUENZA ATTESA a M30, [INFERITA] per interpolazione geometrica fra" -ForegroundColor Yellow
Write-Host  "    DUE PUNTI MISURATI (H1 di R103, M15 di R108). NON e' una misura:" -ForegroundColor Yellow
foreach($s in $SymLavoro){
  Write-Host ("      " + $s.Sym + " : H1 " + $s.AnnoH1.ToString("0.0",$INV) + "/anno  ->  M15 " +
              $s.AnnoM15.ToString("0.0",$INV) + "/anno   ==>  M30 attesi ~" + $s.NAtteM30 +
              " sulla finestra INTERA (~" + [int]($s.NAtteM30/2) + " per finestra IS/OOS)") -ForegroundColor Yellow
}
Write-Host  "      >>> E LA CONSEGUENZA SI GUARDA IN FACCIA PRIMA: con queste attese" -ForegroundColor Yellow
Write-Host  "          NESSUNA finestra IS/OOS arriva a 150, e SOLO GBPUSD ha una speranza" -ForegroundColor Yellow
Write-Host  "          di superarli sulla INTERA. Il MERITO PIENO nasce giudicabile su UN" -ForegroundColor Yellow
Write-Host  "          SIMBOLO SOLO -- e' il costo dichiarato di misurare un TF alto su un" -ForegroundColor Yellow
Write-Host  "          motore a bassa frequenza (criteri par. 3.3, S0b)." -ForegroundColor Yellow
Write-Host ""
Write-Host  "    IL GATE G0 (criteri par. 5): la cella METRO H1 deve RIPRODURRE i numeri" -ForegroundColor Yellow
Write-Host  "    agli atti di R103. Se non li riproduce, QUEL SIMBOLO si ferma e la sua" -ForegroundColor Yellow
Write-Host  "    cella M30 non viene nemmeno lanciata -- gli altri vanno avanti. Un metro" -ForegroundColor Yellow
Write-Host  "    sbagliato non e' un round con un difetto: e' un round che misura altro." -ForegroundColor Yellow
foreach($s in $SymLavoro){
  Write-Host ("      " + $s.Sym + " : PF " + $s.PfAtti.ToString("0.000",$INV) + " | DD " + $s.DdAtti.ToString("0.00",$INV) +
              "% | n " + $s.NAtti + " | prima op. " + $s.PrimaAtti + "   (pattern VIVO " + $s.Pat + ")") -ForegroundColor Yellow
}
Write-Host ""
Write-Host  "    IL CANCELLO ZERO S0a (criteri par. 3): take LORDO MEDIANO dei vincenti" -ForegroundColor Yellow
Write-Host ("      >= " + $S0aMult.ToString("0.0",$INV) + " x " + $SpreadPipDich.ToString("0.0",$INV) +
            " pip = " + ($S0aMult*$SpreadPipDich).ToString("0.0",$INV) + " pip.   [SPREAD NON MISURATO]") -ForegroundColor Yellow
Write-Host  "      Lo spread di BCM sul forex NON e' misurato in repo: 1,5 pip e' un" -ForegroundColor Yellow
Write-Host  "      valore PRUDENZIALE DICHIARATO (criteri D4), non una misura." -ForegroundColor Yellow
Write-Host  "      E non e' teorico: il DIARIO del 20/08 registra DAL VIVO un take da" -ForegroundColor Yellow
Write-Host  "      2,5 pip su BB GBPUSD, e quello era H1." -ForegroundColor Yellow
Write-Host ""
Write-Host  "    IL CANARINO n (criteri G1) NON E' UN GATE. Il campione sottile sospende" -ForegroundColor Yellow
Write-Host  "    il giudizio sul MERITO, mai sul RISCHIO (Emendamento regola B)." -ForegroundColor Yellow
Write-Host ""
Write-Host  "    LA LETTURA DEL CONFINE E' PRE-DICHIARATA (criteri par. 8), e il referto" -ForegroundColor Yellow
Write-Host  "    del round si legge CONTRO quella tabella, non raccontando i numeri:" -ForegroundColor Yellow
Write-Host  "      A) M30 VERDE su >=2 simboli  -> il confine sta fra M30 e M15. Apre UN" -ForegroundColor Yellow
Write-Host  "         ROUND DI VALIDAZIONE nuovo, NON una sedia (G5)." -ForegroundColor Yellow
Write-Host  "      B) M30 ROSSO ovunque         -> il confine sta fra H1 e M30, e IL" -ForegroundColor Yellow
Write-Host  "         CAPITOLO DELLA DISCESA DI TF SI CHIUDE: niente M20, niente M10," -ForegroundColor Yellow
Write-Host  "         niente ripescaggi, nessuna nuova griglia (Seconda Caccia)." -ForegroundColor Yellow
Write-Host  "      C) MISTO (un simbolo verde)  -> G3 dice NO. Un simbolo su tre non e'" -ForegroundColor Yellow
Write-Host  "         un edge: e' rumore. Resta una riga a registro, e basta." -ForegroundColor Yellow
Write-Host  "      D) n<20 per finestra, o FINESTRA ACCORCIATA su tutti e tre -> NON" -ForegroundColor Yellow
Write-Host  "         MISURABILE, che NON e' un NO e non chiude nessun capitolo." -ForegroundColor Yellow
Write-Host ""
Write-Host  "    >>> QUESTO ROUND NON PROMUOVE NIENTE E NON TOCCA IL FORWARD (G5)." -ForegroundColor Yellow
Write-Host  "        E NON TOCCA UNA RIGA DI ABTG_BreakingBand.mq5: a M30 ci si arriva" -ForegroundColor Yellow
Write-Host  "        via input (riga 213 del sorgente, che commenta proprio" -ForegroundColor Yellow
Write-Host  "        'guida: D1/H4/H1/M30'), ed e' il punto della promozione." -ForegroundColor Yellow

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
#     fase 2 dichiarerebbe "COMPILAZIONE FALLITA" su un sorgente sano
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

New-Item -ItemType Directory -Force -Path $Work,$Prove,$Logs,$SrcDir,$Risultati,$Sosta | Out-Null

# =====================================================================
#  0-BIS. LA FIRMA DEI CRITERI. Si LEGGE nell'artefatto, non si ricorda.
# =====================================================================
Titolo "0-BIS. LA FIRMA DEI CRITERI"
$critFile = Join-Path $Work "R111_CRITERI.md"
$daFirmare = $true
try{
  Scarica ("$RawPin/backtest_pipeline/risultati_archivio/R111_CRITERI.md") $critFile 'R111'
  $daFirmare = (Select-String -LiteralPath $critFile -SimpleMatch -Pattern '[DA FIRMARE]' -Quiet)
  if($daFirmare){ $Firma = "NON FIRMATI (il file porta ancora [DA FIRMARE])" }
  else          { $Firma = "FIRMATI (nessun [DA FIRMARE] nel file)" }
}catch{
  $Firma = "NON LETTI (" + $_.Exception.Message + ")"
  $daFirmare = $true
}
if($Firma -like "FIRMATI*"){ Dico ("criteri: " + $Firma) "Green" } else { Dico ("criteri: " + $Firma) "Yellow" }
if($daFirmare -and -not $SoloControllo -and -not $CriteriFirmati){
  Write-Host ""
  Write-Host "#####################################################################" -ForegroundColor Red
  Write-Host "#  NON PARTO: I CRITERI DI R111 NON SONO FIRMATI.                   #" -ForegroundColor Red
  Write-Host "#####################################################################" -ForegroundColor Red
  Write-Host "  R111_CRITERI.md porta ancora [DA FIRMARE], ed E' VOLUTO: la PRE-FIRMA di" -ForegroundColor Yellow
  Write-Host "  Claudio del 25/08 ('FIRMO R111') e' sul PERIMETRO -- 'BB M30, il confine" -ForegroundColor Yellow
  Write-Host "  fra l'H1 vivo e l'M15 morto' -- NON sulle sette decisioni qui sotto, che" -ForegroundColor Yellow
  Write-Host "  restano SMENTIBILI finche' la corsa non parte." -ForegroundColor Yellow
  Write-Host "" -ForegroundColor Yellow
  Write-Host "  LE SETTE DECISIONI, PRE-FIRMATE CON PROPOSTE (criteri par. 11):" -ForegroundColor Yellow
  Write-Host "   D1  il METRO G0 gira a modello 1 (OHLC M1), come R103 e R108?   -> SI" -ForegroundColor Yellow
  Write-Host "   D2  profondita' TICK NON misurata: si gira e si DICHIARA?       -> SI" -ForegroundColor Yellow
  Write-Host "       (ma se l'esito e' VERDE la riserva diventa BLOCCANTE)" -ForegroundColor Yellow
  Write-Host "   D3  finestra M30 2018.07->2026.06, IS/OOS 4+4 anni?             -> SI" -ForegroundColor Yellow
  Write-Host "       (l'OOS coincide con la finestra intera di R108: e' IL PONTE)" -ForegroundColor Yellow
  Write-Host "   D4  spread di S0a = 1,5 pip DICHIARATO, come R108?              -> SI" -ForegroundColor Yellow
  Write-Host "   D5  se S0 o G0 falliscono su un simbolo, gli altri proseguono?  -> SI" -ForegroundColor Yellow
  Write-Host "   D6  la LETTURA DEL CONFINE si dichiara PRIMA (4 esiti, par. 8)? -> SI" -ForegroundColor Yellow
  Write-Host "       (M30 rosso ovunque = capitolo della discesa di TF CHIUSO)" -ForegroundColor Yellow
  Write-Host "   D7  se M30 e' VERDE: round di VALIDAZIONE nuovo, NON una sedia? -> SI" -ForegroundColor Yellow
  Write-Host "" -ForegroundColor Yellow
  Write-Host "  COSA PUOI FARE ADESSO, in ordine:" -ForegroundColor Yellow
  Write-Host "   1. il GIRO A VUOTO gira lo stesso: rilancia con -SoloControllo." -ForegroundColor Yellow
  Write-Host "      Non apre MT5, non produce nessun numero, e verifica tutti i file." -ForegroundColor Yellow
  Write-Host "   2. leggi R111_CRITERI.md par. 11 e smentisci quello che non ti torna." -ForegroundColor Yellow
  Write-Host "      I criteri si cambiano PRIMA dei numeri, mai dopo." -ForegroundColor Yellow
  Write-Host "   3. per far partire la corsa: si rilancia questa riga aggiungendo" -ForegroundColor Yellow
  Write-Host "      -CriteriFirmati, che REGISTRA la pre-firma nel referto." -ForegroundColor Yellow
  Write-Host ""
  exit 2
}
if($daFirmare -and $CriteriFirmati){
  [void]$Rilievi.Add("I criteri portano ancora [DA FIRMARE] nel file, ED E' LA FORMA VOLUTA (criteri, par. 'LA FORMA DEL LUCCHETTO'): la PRE-FIRMA di Claudio del 25/08 -- 'FIRMO R111' -- e' sul PERIMETRO del round ('BB M30, il confine fra l'H1 vivo e l'M15 morto'), non sulle sette decisioni del par. 11, che erano scritte prima dei numeri e restavano smentibili. La corsa e' partita con -CriteriFirmati, che e' la REGISTRAZIONE di quella pre-firma. VA LETTO COSI' NEL REFERTO DEL ROUND: autorizzato il PERIMETRO, proposte le SETTE DECISIONI.")
  Dico "corsa autorizzata da -CriteriFirmati = registrazione della PRE-FIRMA sul perimetro (25/08, 'FIRMO R111')" "Yellow"
}

# =====================================================================
#  1. SCARICO AL PIN E GATE SUGLI ARTEFATTI
# =====================================================================
Titolo "1. SCARICO AL PIN"
foreach($c in $Lavori){
  Scarica ("$RawPin/backtest_pipeline/prove/" + $c.Prova) (Join-Path $Prove $c.Prova) '@SIMBOLO'
}
foreach($c in $Lavori){
  $rv = RigheVive (Join-Path $Prove $c.Prova)
  #  le tre righe @ non sono input: il conto delle righe di INPUT e' quello
  #  che il gate confronta, e il numero e' MISURATO sull'artefatto il
  #  25/08, non scritto a memoria (checklist 40-bis).
  $soloInput = @($rv | Where-Object { $_ -notmatch '^@' })
  if($soloInput.Count -ne $RigheAtte){
    throw ($c.Prova + " ha " + $soloInput.Count + " righe di input invece di " + $RigheAtte + ": artefatto cambiato, mi fermo.")
  }
  $Vive[$c.Prova] = $soloInput
}
Dico ($Lavori.Count.ToString() + " file prova scaricati al pin, " + $RigheAtte + " righe di input ciascuno") "Green"

# --- 1a. IL GATE DELLA STELLA. La cella M30 si confronta con la cella
#     METRO del suo simbolo. Non basta contare le righe diverse: si
#     pretende QUALI righe, e SOLO quelle. Due righe SBAGLIATE darebbero
#     lo stesso conteggio e il round misurerebbe due cose insieme.
foreach($s in $SymLavoro){
  $rif = @($Lavori | Where-Object { $_.Sym -eq $s.Sym -and $_.Metro })
  if($rif.Count -ne 1){
    throw ("simbolo " + $s.Sym + ": trovate " + $rif.Count + " celle METRO invece di 1. Senza il metro la cella M30 non ha niente contro cui leggersi.")
  }
  $RigheMetro = $Vive[$rif[0].Prova]
  foreach($c in @($Lavori | Where-Object { $_.Sym -eq $s.Sym -and -not $_.Metro })){
    $RigheCella = $Vive[$c.Prova]
    if($RigheMetro.Count -ne $RigheCella.Count){ throw ($c.Prova + ": " + $RigheCella.Count + " righe contro " + $RigheMetro.Count + " della cella metro. Non sono confrontabili.") }
    $Diversi = New-Object System.Collections.ArrayList
    for($i=0;$i -lt $RigheMetro.Count;$i++){ if($RigheMetro[$i] -ne $RigheCella[$i]){ [void]$Diversi.Add((NomeDi $RigheMetro[$i])) } }
    $attese = @("InpTF","InpMagic")
    $manca  = @($attese | Where-Object { $Diversi -notcontains $_ })
    $extra  = @($Diversi   | Where-Object { $attese -notcontains $_ })
    if($manca.Count -gt 0 -or $extra.Count -gt 0){
      throw ($c.Prova + " contro " + $rif[0].Prova + ": differiscono su [" + ($Diversi -join ", ") +
             "] invece che su [" + ($attese -join ", ") + "]. R111 pretende CHE CAMBI SOLO IL TIMEFRAME (piu' il magic): cosi' il numero e' attribuibile al TF e a nient'altro.")
    }
  }
}
Dico "gate della STELLA: ogni cella M30 differisce dalla sua cella metro SOLO su InpTF" "Green"

# --- 1a-bis. I DUE GATE DELL'ANTENATO (checklist 72). Il gate della stella
#     confronta le due celle di un simbolo FRA LORO: per costruzione NON PUO'
#     VEDERE una corruzione applicata a ENTRAMBE. MISURATO il 25/08 facendo
#     girare il driver R108 su un repo corrotto: InpBBPeriod portato da 20 a 25
#     nelle DUE celle di GBPUSD passava la stella, i valori, l'asse unico, i
#     magic, le righe vive -- tutto verde, uscita 0. Restavano fuori 64 dei 70
#     input.
#     >>> E QUI GLI ANTENATI SONO DUE, non uno, perche' la catena di copia ha
#         due anelli: R111 <- R108 <- R103. Il primo gate prende un errore di
#         COPIA (qualcosa toccato costruendo R111); il secondo prende un file
#         di R108 CORROTTO DOPO la sua corsa -- che al primo gate sarebbe
#         invisibile, perche' i due file sarebbero storti allo stesso modo.
#         E' esattamente lo stesso ragionamento del punto 72, applicato una
#         generazione piu' in la'.
#     >>> IL CONFRONTO E' PER NOME, NON PER POSIZIONE: l'antenato R103 ha una
#         riga in piu' (InpNewsCurrencies) e un confronto posizionale sfaserebbe
#         tutto il resto accusando 40 righe sane (difetto 58, la colonna
#         contata dalla fine).
function GateAntenato([string]$sym,$cellaMetro,[string]$nomeAnt,$deltaAmmessi,[string]$etichetta){
  if([string]::IsNullOrEmpty($nomeAnt)){ throw ("simbolo " + $sym + ": nessun antenato " + $etichetta + " dichiarato. Non tiro a indovinare.") }
  $fileAnt = Join-Path $Prove ("ANTENATO_" + $nomeAnt)
  Scarica ("$RawPin/backtest_pipeline/prove/" + $nomeAnt) $fileAnt '@SIMBOLO'
  $hAnt = @{}; foreach($riga in (RigheVive $fileAnt)){ $hAnt[(NomeDi $riga)] = $riga }
  $hMet = @{}; foreach($riga in (RigheVive (Join-Path $Prove $cellaMetro.Prova))){ $hMet[(NomeDi $riga)] = $riga }
  $div = New-Object System.Collections.ArrayList
  foreach($k in $hAnt.Keys){
    if(-not $hMet.ContainsKey($k)){ [void]$div.Add($k) }
    elseif($hAnt[$k] -ne $hMet[$k]){ [void]$div.Add($k) }
  }
  foreach($k in $hMet.Keys){ if(-not $hAnt.ContainsKey($k)){ [void]$div.Add($k) } }
  $extraA = @($div | Where-Object { $deltaAmmessi -notcontains $_ })
  if($extraA.Count -gt 0){
    throw ($cellaMetro.Prova + " contro l'antenato " + $etichetta + " " + $nomeAnt + ": differiscono anche su [" + ($extraA -join ", ") +
           "], oltre ai soli delta dichiarati [" + ($deltaAmmessi -join ", ") +
           "]. La cella METRO esiste per RIPRODURRE la cella viva di R103: con un input diverso il gate G0 fallirebbe TRE PASSATE PIU' TARDI, e direbbe 'il banco e' storto' invece di 'il file e' storto'.")
  }
  #  >>> E SI PRETENDE CHE I DELTA CI SIANO DAVVERO. Se il metro fosse
  #      IDENTICO all'antenato anche sul magic, vorrebbe dire che sta per
  #      girare con un magic di un ALTRO round -- il gate dei magic lo
  #      prenderebbe, ma qui costa una riga e il messaggio e' piu' chiaro.
  if($div -notcontains "InpMagic"){
    throw ($cellaMetro.Prova + " contro l'antenato " + $etichetta + " " + $nomeAnt + ": InpMagic e' IDENTICO. Questa cella deve girare su un magic VERGINE, non su quello del round da cui e' copiata.")
  }
  Dico ("gate dell'ANTENATO " + $etichetta + " " + $sym + ": il metro e' identico a " + $nomeAnt + " (delta: " + ($div -join ", ") + ")") "Green"
}
foreach($s in $SymLavoro){
  $rifA = @($Lavori | Where-Object { $_.Sym -eq $s.Sym -and $_.Metro })
  if($rifA.Count -ne 1){ throw ("simbolo " + $s.Sym + ": manca la cella METRO per il gate dell'antenato.") }
  GateAntenato $s.Sym $rifA[0] $AntenatoR108[$s.Sym] $DeltaAmmessiR108 "R108"
  GateAntenato $s.Sym $rifA[0] $AntenatoR103[$s.Sym] $DeltaAmmessiR103 "R103"
}

# --- 1b. I VALORI, letti NELL'ARTEFATTO CHE GIRA (checklist 34-bis).
#     Il diff dice CHE cambiano; questo dice CHE COSA valgono: se i file
#     di due simboli fossero SCAMBIATI, il diff resterebbe verde.
#     >>> OGNI $ DI UNA REGEX MULTILINEA SI SCRIVE \r?$ (checklist 40): i
#         file arrivano da GitHub con CRLF, e senza \r? il match non
#         avviene MAI e il gate accuserebbe un file sano.
$magicVisti = @()
foreach($c in $Lavori){
  $s  = @($SIMBOLI | Where-Object { $_.Sym -eq $c.Sym })[0]
  $tx = Get-Content -LiteralPath (Join-Path $Prove $c.Prova) -Raw
  foreach($k in $c.Val.Keys){
    $rx = '(?m)^' + $k + '=' + [regex]::Escape($c.Val[$k]) + '\|\|'
    if($tx -notmatch $rx){
      throw ($c.Prova + ": " + $k + " non vale " + $c.Val[$k] +
             ". La cella non e' quella che credo -- e su InpPatternMode questo e' IL difetto del file del cacciatore: le tre celle vive di R103 hanno pattern DIVERSI (GBPUSD 2, EURUSD 0, AUDUSD 1), e pinnarne uno solo vorrebbe dire misurare UN ALTRO MOTORE.")
    }
  }
  #  la geometria che NON cambia mai: le due valvole del take DEVONO
  #  restare spente, o il round misurerebbe il filtro invece del motore
  #  (criteri par. 6).
  foreach($sp in @(@("InpMinTPatATR","0.0"),@("InpMinRR","0.0"),
                   @("InpTPMode","0"),@("InpMaxPositions","1"),
                   @("InpRiskPercent","1.0"),@("InpVerbose","true"))){
    $rx = '(?m)^' + $sp[0] + '=' + [regex]::Escape($sp[1]) + '\|\|'
    if($tx -notmatch $rx){ throw ($c.Prova + ": " + $sp[0] + " non vale " + $sp[1] + " (criteri par. 6 e 2).") }
  }
  # --- @SIMBOLO / @PERIODO / @DAQUANDO, confrontati e non creduti.
  $m = [regex]::Match($tx,'(?m)^@DAQUANDO\s+([0-9]{4}\.[0-9]{2}\.[0-9]{2})')
  if(-not $m.Success -or $m.Groups[1].Value -ne $c.DataDa){ throw ($c.Prova + ": @DAQUANDO non e' " + $c.DataDa) }
  $sm = [regex]::Match($tx,'(?m)^@SIMBOLO\s+(\S+)')
  if(-not $sm.Success -or $sm.Groups[1].Value -ne $c.Sym){ throw ($c.Prova + ": @SIMBOLO non e' " + $c.Sym) }
  $pm = [regex]::Match($tx,'(?m)^@PERIODO\s+(\S+)')
  if(-not $pm.Success -or $pm.Groups[1].Value -ne $c.Tf){ throw ($c.Prova + ": @PERIODO non e' " + $c.Tf) }
  #  >>> IL TF DEL GRAFICO NON SI DERIVA DA InpTF, E VICEVERSA (trappola
  #      pagata in R102 su SuperWave). Qui DEVONO coincidere, ed e' voluto:
  #      si vuole misurare il motore a M30, non un motore M30 letto da un
  #      grafico di altro TF. Questo if e' quella regola.
  $tfAtteso = "16385"; if($c.Tf -eq "M30"){ $tfAtteso = "30" }
  if($tx -notmatch ('(?m)^InpTF=' + $tfAtteso + '\|\|')){ throw ($c.Prova + ": @PERIODO " + $c.Tf + " ma InpTF non e' " + $tfAtteso + ".") }
  # --- L'ASSE UNICO.
  $assiY = @([regex]::Matches($tx,'(?m)^(\w+)=[^\r\n]*\|\|\s*[Yy]\s*\r?$') | ForEach-Object { $_.Groups[1].Value })
  if($assiY.Count -ne 1 -or $assiY[0] -ne "InpMagic"){
    throw ($c.Prova + ": gli assi spazzolati sono [" + ($assiY -join ", ") + "] invece del solo InpMagic. R111 NON ottimizza niente: piu' di un asse sarebbe una griglia, cioe' un altro round.")
  }
  # --- i magic: il file pinna la coppia della finestra INTERA (base/base+1);
  #     il driver ricava gli altri (singola = base+2, IS = base+4, OOS = base+6).
  $mg = [regex]::Match($tx,'(?m)^InpMagic=(\d+)\|\|(\d+)\|\|1\|\|(\d+)\|\|Y')
  if(-not $mg.Success){ throw ($c.Prova + ": InpMagic non e' nella forma sweep 'v||v||1||v+1||Y'. Senza almeno un asse Y MT5 rispazzola la griglia vecchia (checklist punto 5).") }
  $m0 = [int]$mg.Groups[1].Value; $m1 = [int]$mg.Groups[3].Value
  if($m0 -ne [int]$c.Base){ throw ($c.Prova + ": InpMagic e' " + $m0 + " ma questa cella deve girare su " + $c.Base) }
  if($m1 -ne ($m0+1)){ throw ($c.Prova + ": il gemello e' " + $m1 + " invece di " + ($m0+1)) }
  #  >>> LE PARENTESI NON SONO COSMETICA (trovato ESEGUENDO, 25/08): in
  #      PowerShell l'operatore VIRGOLA ha precedenza PIU' ALTA del '+',
  #      quindi @($a,$b,$a+2) NON e' una lista di tre numeri: e'
  #      ($a,$b,$a) + (2) -- cioe' una CONCATENAZIONE DI ARRAY che
  #      DUPLICA $a. Il gate dei magic accusava di collisione il primo
  #      file sano del round. Ogni espressione dentro un @( ) va fra
  #      parentesi.
  foreach($mm in @($m0,$m1,($m0+2),($m0+4),($m0+5),($m0+6),($m0+7))){
    if($magicVisti -contains $mm){ throw ($c.Prova + ": magic " + $mm + " gia' usato da un'altra cella. Due lanci con lo stesso magic non sono distinguibili nei file per-trade.") }
    if($MagicVietati -contains $mm){ throw ($c.Prova + ": il magic " + $mm + " e' di una SEDIA VIVA o di un round precedente (7600xx e' proprio R103 su questi tre simboli). Fermo tutto: il tester non deve poter incrociare i deal di un altro round.") }
    $magicVisti += $mm
  }
}
Dico ("valori, pattern VIVO, TF del grafico, asse unico e " + $magicVisti.Count + " magic vergini verificati NEI FILE") "Green"

# --- 1c. IL SORGENTE E IL GATE DI VERSIONE.
$srcMq5 = Join-Path $SrcDir ($NomeEa + ".mq5")
Scarica ("$RawPin/mql5/Experts/" + $NomeEa + ".mq5") $srcMq5 'OPTFRAME'
$txtSrc = Get-Content -LiteralPath $srcMq5 -Raw
$mv = [regex]::Match($txtSrc,'#property\s+version\s+"([^"]+)"')
if(-not $mv.Success){ throw ($NomeEa + ".mq5 scaricato senza #property version: non e' il sorgente che credo.") }
if($mv.Groups[1].Value -ne $EaVer){
  throw ($NomeEa + ".mq5 dichiara version '" + $mv.Groups[1].Value + "' invece di '" + $EaVer +
         "'. O la cache di raw.githubusercontent serve una copia vecchia, o il pin e' sbagliato, o il motore E' CAMBIATO -- e in quel caso il metro di R103 non e' piu' riproducibile e va rifatto il ragionamento, non il gate.")
}
#  >>> IL GATE CHE PROTEGGE IL PUNTO DELLA PROMOZIONE: InpTF deve essere
#      un input LIBERO del sorgente. Se non lo fosse, "zero righe di
#      codice" sarebbe falso e il round non esisterebbe.
if($txtSrc -notmatch '(?m)^input\s+ENUM_TIMEFRAMES\s+InpTF\s*='){
  throw ($NomeEa + ".mq5 non ha 'input ENUM_TIMEFRAMES InpTF': tutto R111 si regge su quell'input. Mi fermo.")
}
foreach($inp in @("InpPatternMode","InpMinTPatATR","InpMinRR","InpTPMode")){
  if($txtSrc -notmatch $inp){ throw ($NomeEa + ".mq5 non ha " + $inp + ": un pin su un input inesistente e' un pin INERTE, e MT5 non se ne lamenta (checklist 52).") }
}
Dico ($NomeEa + ".mq5 al pin, version " + $mv.Groups[1].Value + ", InpTF e' un input libero") "Green"

# --- 1d. LA PROFONDITA' DEI TICK. NON e' un gate: e' un RILIEVO
#     OBBLIGATORIO (criteri par. 4.3, decisione D2). Se il file non c'e',
#     lo si DICE -- non lo si nasconde e non si tira a indovinare.
foreach($s in $SymLavoro){
  $tk = Join-Path $Work ("misura_tick_" + $s.Sym + ".csv")
  try{
    Scarica ("$RawPin/backtest_pipeline/risultati_archivio/misura_tick/misura_tick_" + $s.Sym + ".csv") $tk ""
    $riga = @(Get-Content -LiteralPath $tk | Where-Object { $_ -match '(?i)TICK' } | Select-Object -First 1)
    if($riga.Count -gt 0){ $s.TickMisurati = ("" + $riga[0]).Trim() }
    else { $s.TickMisurati = "file presente ma senza riga TICK" }
    Copy-Item -LiteralPath $tk -Destination (Join-Path $Sosta ("misura_tick_" + $s.Sym + ".csv")) -Force -ErrorAction SilentlyContinue
    Dico ("profondita' TICK " + $s.Sym + ": " + $s.TickMisurati) "Green"
  }catch{
    $s.TickMisurati = "NON MISURATA (nessun misura_tick_" + $s.Sym + ".csv al pin)"
    if(-not $ScreenOhlcM30){
      [void]$Rilievi.Add("PROFONDITA' TICK NON MISURATA su " + $s.Sym + ": in tutto il repo esiste una sola misura dei tick, ed e' U30USD. La cella M30 gira a MODELLO 4 e MT5, se i tick reali non ci sono, NON SI FERMA: ripiega e produce numeri PLAUSIBILI E FALSI. Nessuna guardia di questo driver puo' accorgersene. E' la decisione D2 dei criteri. >>> E IN R111 LA FINESTRA E' IL DOPPIO DI R108 (8 anni contro 4): se i tick reali di BCM partissero dopo il 2018, la META' IS di questa cella girerebbe su un ripiego SENZA DIRLO. Controllo indiretto gratis: se la PRIMA OPERAZIONE del PASSO 0 cade molto dopo il " + $M30DataDa + " su tutti e tre i simboli, il sospetto n.1 e' proprio questo. >>> E vale la regola di D2: LA RISERVA AMMORBIDISCE UN SI', NON UN NO -- un rosso su sei finestre concordi non cambia con tick migliori, un verde si'.")
    }
    Dico ("profondita' TICK " + $s.Sym + ": " + $s.TickMisurati) "Yellow"
  }
}

# =====================================================================
#  2. TERMINALE, CARTELLA DATI, INCLUDE E PULIZIA
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
$CommonFiles = Join-Path $termRoot "Common\Files"
New-Item -ItemType Directory -Force -Path $MqlExperts,$MqlInclude | Out-Null
#  OGNI PASSO STAMPA IL BERSAGLIO CHE HA SCELTO (checklist 37).
Dico ("terminale : " + $Terminal)
Dico ("dati      : " + $DataFolder + "   (DEVE restare lo stesso in tutti i passi)")

# --- 2a. LA SOSTA SI SVUOTA A OGNI GIRO (checklist 56), e SI CONTA PRIMA
#     E DOPO (checklist 69): una Remove-Item che fallisce in silenzio
#     degraderebbe questo passo in un "boh", e nello zip finirebbero
#     artefatti di un giro precedente indistinguibili da quelli veri.
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
#     L'EA fa #include <ABTG_PausaGuardian.mqh>. Senza questa riga la
#     compilazione fallisce e il round muore alla prima passata. Pagato
#     due volte (21/08 e 22/08).
#     >>> NEL TESTER LA GUARDIA E' FAIL-OPEN TOTALE (le GlobalVariable del
#         Guardian non esistono): non cambia il comportamento e i numeri
#         restano confrontabili con R103.
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
#     >>> E SE UN FILE SOPRAVVIVE, LO SI DICE RUMOROSAMENTE (checklist 69).
if($SoloControllo){
  Dico "SoloControllo: NON cancello niente." "Yellow"
} else {
  foreach($s in $SymLavoro){
    $optCsv = Join-Path $MqlFiles ("OptResults_" + $NomeEa + "_" + $s.Sym + ".csv")
    if(Test-Path -LiteralPath $optCsv){
      Remove-Item -LiteralPath $optCsv -Force -ErrorAction SilentlyContinue
      if(Test-Path -LiteralPath $optCsv){
        [void]$Problemi.Add("NON sono riuscito a cancellare " + $optCsv + " (qualcuno lo tiene aperto). Il file di appoggio dell'OPTFRAME e' di un giro PRECEDENTE: i CSV di questo round vanno confrontati con la loro data prima di leggerli.")
        Dico ("OptResults NON cancellato: " + $optCsv) "Red"
      }
    }
  }
  #  i file per-trade dei NOSTRI magic, e SOLO quelli: si cancellano per
  #  NOME COMPLETO, mai a wildcard (checklist 46).
  if(Test-Path -LiteralPath $CommonFiles){
    $nPt = 0
    foreach($c in $Lavori){
      foreach($mm in @($c.Base,($c.Base+1),($c.Base+2),($c.Base+4),($c.Base+5),($c.Base+6),($c.Base+7))){
        $pt = Join-Path $CommonFiles ("abtg_trades_" + $NomeEa + "_" + $c.Sym + "_" + $mm + ".csv")
        if(Test-Path -LiteralPath $pt){
          Remove-Item -LiteralPath $pt -Force -ErrorAction SilentlyContinue
          if(Test-Path -LiteralPath $pt){
            [void]$Problemi.Add("per-trade NON cancellato: " + $pt + ". Se ricompare 'fresco' non e' detto che sia di adesso.")
          } else { $nPt++ }
        }
      }
    }
    if($nPt -gt 0){ Dico ($nPt.ToString() + " file per-trade di un giro precedente rimossi da Common\Files") "Green" }
  }
  #  la CACHE del tester, e SOLO quella. MAI bases\<server>\ticks: li'
  #  dentro c'e' lo storico, e ributtarlo giu' e' una nottata.
  #  >>> CON -LiteralPath IL * NON E' UN WILDCARD (checklist 46).
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
#  3. FASE COMPILA. .ex5 SCRITTO ADESSO.
#     Si fa ANCHE in -SoloControllo: altrimenti un giro a vuoto non
#     direbbe niente sulla compilabilita' (checklist 39).
#     >>> INVOCAZIONE DIRETTA di metaeditor64.exe (checklist 54 e bug del
#         22/08): con Start-Process -ArgumentList a stringhe pre-quotate,
#         sui path con spazi ("Program Files") torna rc=0 SENZA compilare.
#     >>> E IL VERDETTO E' IL LastWriteTime DEL .ex5 PRIMA/DOPO, non
#         "esiste" e non "e' recente": il file c'era gia'.
# =====================================================================
Titolo "3. FASE COMPILA"
$mq5 = Join-Path $MqlExperts ($NomeEa + ".mq5")
$ex5 = Join-Path $MqlExperts ($NomeEa + ".ex5")
$logC= Join-Path $MqlExperts ($NomeEa + ".log")
#  backup DATATO e MAI sovrascritto (checklist 12): il .ex5 vecchio e'
#  l'unica prova di cosa girava prima su questa macchina.
$bakMq5 = $mq5 + ".prima_r108_" + $Stamp
$bakEx5 = $ex5 + ".prima_r108_" + $Stamp
if((Test-Path -LiteralPath $mq5) -and -not (Test-Path -LiteralPath $bakMq5)){ Copy-Item -LiteralPath $mq5 -Destination $bakMq5 -Force }
if((Test-Path -LiteralPath $ex5) -and -not (Test-Path -LiteralPath $bakEx5)){ Copy-Item -LiteralPath $ex5 -Destination $bakEx5 -Force }
Copy-Item -LiteralPath $srcMq5 -Destination $mq5 -Force
#  verifica della copia sul CONTENUTO, non sul nome (checklist 27-ter)
$lenSrc = (Get-Item -LiteralPath $srcMq5).Length
$vc = Get-Item -LiteralPath $mq5 -ErrorAction SilentlyContinue
if(-not $vc -or $vc.PSIsContainer -or $vc.Length -ne $lenSrc){ throw ("copia di " + $NomeEa + ".mq5 in MQL5\Experts NON verificata (lunghezza diversa o e' una cartella).") }
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
  Copy-Item -LiteralPath $logC -Destination (Join-Path $Sosta "compile_BreakingBand.log") -Force -ErrorAction SilentlyContinue
}
if(-not $compileOk){
  if($testoLog -ne ""){
    Write-Host "--- log del compilatore (ultime righe) ---" -ForegroundColor DarkYellow
    foreach($r in @($testoLog -split "\r?\n" | Select-Object -Last 20)){ Write-Host ("   " + $r) -ForegroundColor DarkYellow }
  } else { Write-Host "   (nessun log prodotto da MetaEditor)" -ForegroundColor DarkYellow }
  #  sorgente e binario devono restare la STESSA versione (checklist 54)
  if(Test-Path -LiteralPath $bakMq5){ Copy-Item -LiteralPath $bakMq5 -Destination $mq5 -Force }
  throw ("COMPILAZIONE FALLITA per " + $NomeEa + " (metaeditor rc=" + $rcMe + ", .ex5 NON riscritto). Il .mq5 e' stato rimesso com'era e il log e' nello zip. Sospetto n.1: include mancante o MetaEditor gia' aperto.")
}
$mw = [regex]::Match($testoLog,'(?i)(\d+)\s+warning')
if($mw.Success -and [int]$mw.Groups[1].Value -gt 0){
  [void]$Rilievi.Add("compilazione " + $NomeEa + ": " + $mw.Groups[1].Value + " warning (0 errori). Non fermano il round, ma vanno letti nel log dello zip.")
}
$Compilato = $true
Dico ("COMPILATO " + $NomeEa + " v" + $EaVer + " (.ex5 riscritto adesso, rc=" + $rcMe + ")") "Green"

# =====================================================================
#  LE DUE FABBRICHE DI .ini. Un solo artefatto: le righe le detta il FILE
#  PROVA, non questa riga (checklist 33). Ogni fabbrica ha i suoi gate
#  SULLO STATO FINALE del testo, non sul replace.
# =====================================================================
function IniOtt($cella,[string]$DataDa,[string]$DataA,[int]$magic,[string]$dest,[string]$report){
  #  >>> LE DATE SI CONTROLLANO PRIMA DI SCRIVERE (checklist 79).
  GateDate $DataDa $DataA ("ini OTT " + $cella.Prova + " -> " + $dest)
  $out = New-Object System.Collections.ArrayList
  foreach($r in $Vive[$cella.Prova]){
    if((NomeDi $r) -eq "InpMagic"){ [void]$out.Add("InpMagic=" + $magic + "||" + $magic + "||1||" + ($magic+1) + "||Y") }
    else { [void]$out.Add($r) }
  }
  $inputs = ($out -join "`r`n")
  if(@($out).Count -ne $RigheAtte){ throw ("ini OTT " + $cella.Prova + ": " + @($out).Count + " parametri invece di " + $RigheAtte) }
  $yy = @([regex]::Matches($inputs,'(?m)^(\w+)=[^\r\n]*\|\|\s*[Yy]\s*\r?$') | ForEach-Object { $_.Groups[1].Value })
  if($yy.Count -ne 1 -or $yy[0] -ne "InpMagic"){ throw ("ini OTT " + $cella.Prova + ": assi Y = [" + ($yy -join ", ") + "] invece del solo InpMagic.") }
  if($inputs -notmatch ('(?m)^InpMagic=' + $magic + '\|\|' + $magic + '\|\|1\|\|' + ($magic+1) + '\|\|Y\r?$')){ throw ("ini OTT: InpMagic non pinnato a " + $magic + "/" + ($magic+1)) }
  $testo = @"
[Charts]
MaxBars=2000000000

[Experts]
AllowLiveTrading=false
AllowDllImport=false

[Tester]
Expert=$NomeEa.ex5
Symbol=$($cella.Sym)
Period=$($cella.Tf)
Model=$($cella.Modello)
Spread=$SpreadIni
Optimization=1
OptimizationCriterion=6
FromDate=$DataDa
ToDate=$DataA
ForwardMode=0
Deposit=$Deposito
Currency=EUR
Leverage=100
ExecutionMode=0
ReplaceReport=1
ShutdownTerminal=1
Report=$report

[TesterInputs]
$inputs
"@
  #  >>> E ADESSO SULL'ARTEFATTO: la finestra si rilegge NEL TESTO che
  #      sta per finire su disco, non nella variabile che l'ha prodotto.
  GateDateIni $testo $DataDa $DataA ("ini OTT " + $cella.Prova)
  Set-Content -LiteralPath $dest -Value $testo -Encoding ASCII
  #  >>> e una terza volta DAL FILE SCRITTO: fra la stringa e il disco c'e'
  #      un encoding, e un Set-Content che fallisse in silenzio lascerebbe
  #      sul posto l'.ini di un giro precedente (checklist 69).
  GateDateIni (Get-Content -LiteralPath $dest -Raw) $DataDa $DataA ("ini OTT RILETTO DA DISCO " + $dest)
}
function IniSingola($cella,[string]$DataDa,[string]$DataA,[int]$magic,[string]$dest,[string]$report){
  #  >>> LE DATE SI CONTROLLANO PRIMA DI SCRIVERE (checklist 79).
  GateDate $DataDa $DataA ("ini SINGOLA " + $cella.Prova + " -> " + $dest)
  $out = New-Object System.Collections.ArrayList
  foreach($r in $Vive[$cella.Prova]){
    $nome = NomeDi $r
    if($nome -eq "InpMagic"){ [void]$out.Add("InpMagic=" + $magic) }
    else { [void]$out.Add($nome + "=" + (ValoreDi $r)) }
  }
  $inputs = ($out -join "`r`n")
  if(@($out).Count -ne $RigheAtte){ throw ("ini SINGOLA " + $cella.Prova + ": " + @($out).Count + " parametri invece di " + $RigheAtte) }
  #  un "||" rimasto vorrebbe dire un'OTTIMIZZAZIONE TRAVESTITA, e in
  #  ottimizzazione non esiste nessun report .htm da leggere: il PASSO 0
  #  resterebbe muto e nessuno saprebbe perche' (checklist 34).
  if($inputs -match '\|\|'){ throw ("ini SINGOLA " + $cella.Prova + ": e' rimasto uno sweep '||'.") }
  if($inputs -notmatch ('(?m)^InpMagic=' + $magic + '\r?$')){ throw ("ini SINGOLA: InpMagic non pinnato a " + $magic) }
  if($inputs -notmatch '(?m)^InpVerbose=true\r?$'){ throw "ini SINGOLA: InpVerbose non e' true." }
  $testo = @"
[Charts]
MaxBars=2000000000

[Experts]
AllowLiveTrading=false
AllowDllImport=false

[Tester]
Expert=$NomeEa.ex5
Symbol=$($cella.Sym)
Period=$($cella.Tf)
Model=$($cella.Modello)
Spread=$SpreadIni
Optimization=0
FromDate=$DataDa
ToDate=$DataA
ForwardMode=0
Deposit=$Deposito
Currency=EUR
Leverage=100
ExecutionMode=0
ReplaceReport=1
ShutdownTerminal=1
Report=$report

[TesterInputs]
$inputs
"@
  GateDateIni $testo $DataDa $DataA ("ini SINGOLA " + $cella.Prova)
  Set-Content -LiteralPath $dest -Value $testo -Encoding ASCII
  GateDateIni (Get-Content -LiteralPath $dest -Raw) $DataDa $DataA ("ini SINGOLA RILETTO DA DISCO " + $dest)
}

#  --- LANCIA UN .ini E TORNA I MINUTI. Uno solo per volta, mai in parallelo.
function Lancia([string]$ini){
  $t0 = Get-Date
  (Start-Process -FilePath $Terminal -ArgumentList ("/config:`"" + $ini + "`"") -PassThru).WaitForExit()
  return [math]::Round((New-TimeSpan -Start $t0 -End (Get-Date)).TotalMinutes,1)
}
#  --- TROVA IL REPORT .htm SCRITTO DOPO $dopo. MT5 lo scrive dove gli
#      pare (install dir, cartella dati, cartella di lavoro): si cerca in
#      tutte, e SI GUARDA LA DATA -- un .htm di ieri non e' un report
#      (checklist 23).
function TrovaReport([string]$nome,[datetime]$dopo){
  foreach($rad in @($InstDir,$DataFolder,$Work,$MqlFiles)){
    if([string]::IsNullOrEmpty($rad)){ continue }
    if(-not (Test-Path -LiteralPath $rad)){ continue }
    #  >>> CHECKLIST 81: si ordina per prendere IL PRIMO, quindi i pari
    #      contano. Due file scritti nello stesso istante (.htm e .html
    #      dello stesso report) darebbero un vincitore ARBITRARIO, e un
    #      giro dopo un altro. Spareggio UNIVOCO: il FullName.
    $c = @(Get-ChildItem -LiteralPath $rad -Filter ($nome + "*.htm*") -File -ErrorAction SilentlyContinue |
           Where-Object { $_.LastWriteTime -ge $dopo } |
           Sort-Object -Property @{Expression="LastWriteTime";Descending=$true}, @{Expression="FullName";Descending=$true})
    if($c.Count -gt 0){ return $c[0].FullName }
  }
  return ""
}

# =====================================================================
#  4. LA CATENA. Una cella alla volta.
#     L'ORDINE CONTA: dentro ogni simbolo la cella METRO gira PER PRIMA,
#     perche' il gate G0 sta li' -- e se il metro non si riproduce, la
#     cella M30 di quel simbolo non si lancia nemmeno (sarebbero ore di
#     macchina per numeri che non si leggono).
#     >>> E gli ALTRI simboli vanno avanti lo stesso (criteri D5).
# =====================================================================
Titolo ("4. LA CATENA - " + $Lavori.Count + " celle, una alla volta")
$Ordinati = @()
foreach($s in $SymLavoro){
  $Ordinati += @($Lavori | Where-Object { $_.Sym -eq $s.Sym -and $_.Metro })
  $Ordinati += @($Lavori | Where-Object { $_.Sym -eq $s.Sym -and -not $_.Metro })
}
$idx = 0
foreach($c in $Ordinati){
  $idx++
  $s = @($SIMBOLI | Where-Object { $_.Sym -eq $c.Sym })[0]
  if($SimFermi -contains $c.Sym){
    $c.Esito = "NON INIZIATA (il simbolo " + $c.Sym + " si e' fermato al gate G0)"
    continue
  }
  $trascorse = (New-TimeSpan -Start $Avvio -End (Get-Date)).TotalHours
  if($trascorse -ge $OreMax){
    $c.Esito = "NON INIZIATA (tetto ore raggiunto)"
    [void]$Problemi.Add("TEMPO SCADUTO prima di " + $c.Prova + ": il round NON e' completo. Riprendi con -SoloCella " + $c.Prova + " (la cella metro del suo simbolo rigira da sola).")
    continue
  }
  Write-Host ""
  Write-Host "------------------------------------------------------------------" -ForegroundColor Cyan
  if($c.Metro){ Write-Host ("  [" + $idx + "/" + $Ordinati.Count + "]  " + $c.Prova + "   <<< IL METRO (gate G0)") -ForegroundColor Cyan }
  else        { Write-Host ("  [" + $idx + "/" + $Ordinati.Count + "]  " + $c.Prova) -ForegroundColor Cyan }
  Write-Host ("           " + $c.Desc) -ForegroundColor Cyan
  Write-Host ("           TF " + $c.Tf + " | modello " + $c.Modello + " | " + $c.DataDa + " -> " + $c.DataA + " | magic base " + $c.Base) -ForegroundColor Cyan
  Write-Host "------------------------------------------------------------------" -ForegroundColor Cyan
  $tCella = Get-Date

  # --- gli .ini di questa cella, scritti SEMPRE (anche a vuoto): sono
  #     GLI STESSI che girano nella corsa vera, non un secondo artefatto.
  $iniSing = Join-Path $Work ($c.Sym + "_" + $c.Id + "_singola.ini")
  $iniInt  = Join-Path $Work ($c.Sym + "_" + $c.Id + "_gemelle_intera.ini")
  $repSing = "R111_" + $c.Sym + "_" + $c.Id + "_singola"
  IniSingola $c $c.DataDa $c.DataA ($c.Base + 2) $iniSing $repSing
  IniOtt     $c $c.DataDa $c.DataA  $c.Base      $iniInt  ("R111_" + $c.Sym + "_" + $c.Id + "_gemelle")
  Copy-Item -LiteralPath $iniSing -Destination (Join-Path $Sosta ($c.Sym + "_" + $c.Id + "_singola.ini")) -Force
  Copy-Item -LiteralPath $iniInt  -Destination (Join-Path $Sosta ($c.Sym + "_" + $c.Id + "_gemelle_intera.ini")) -Force
  $iniIS = ""; $iniOOS = ""
  if(-not $c.Metro){
    $iniIS  = Join-Path $Work ($c.Sym + "_" + $c.Id + "_gemelle_IS.ini")
    $iniOOS = Join-Path $Work ($c.Sym + "_" + $c.Id + "_gemelle_OOS.ini")
    IniOtt $c $M30IS_DataDa  $M30IS_DataA  ($c.Base + 4) $iniIS  ("R111_" + $c.Sym + "_" + $c.Id + "_IS")
    IniOtt $c $M30OOS_DataDa $M30OOS_DataA ($c.Base + 6) $iniOOS ("R111_" + $c.Sym + "_" + $c.Id + "_OOS")
    Copy-Item -LiteralPath $iniIS  -Destination (Join-Path $Sosta ($c.Sym + "_" + $c.Id + "_gemelle_IS.ini")) -Force
    Copy-Item -LiteralPath $iniOOS -Destination (Join-Path $Sosta ($c.Sym + "_" + $c.Id + "_gemelle_OOS.ini")) -Force
  }

  if($SoloControllo){
    # --- IL GIRO A VUOTO LEGGE GLI .ini CHE HA APPENA SCRITTO. E' tutto
    #     quello che puo' fare, e lo dice.
    $guai = New-Object System.Collections.ArrayList
    #  >>> LA FINESTRA ATTESA DI OGNI .ini SI DICHIARA QUI, e si confronta
    #      con quella LETTA DAL FILE: e' la checklist 79 portata anche nel
    #      giro a vuoto, che e' il posto dove il difetto di R109 e' passato.
    $AtteseFinestra = @{}
    $AtteseFinestra["singola"]        = @($c.DataDa, $c.DataA)
    $AtteseFinestra["gemelle_intera"] = @($c.DataDa, $c.DataA)
    $AtteseFinestra["gemelle_IS"]     = @($M30IS_DataDa,  $M30IS_DataA)
    $AtteseFinestra["gemelle_OOS"]    = @($M30OOS_DataDa, $M30OOS_DataA)
    foreach($pair in @(@($iniSing,"singola"),@($iniInt,"gemelle_intera"),@($iniIS,"gemelle_IS"),@($iniOOS,"gemelle_OOS"))){
      if([string]::IsNullOrEmpty($pair[0])){ continue }
      $atx = Get-Content -LiteralPath $pair[0] -Raw
      if($atx -notmatch ('(?m)^Model=' + $c.Modello + '\r?$')){ [void]$guai.Add($pair[1] + ": Model non e' " + $c.Modello) }
      if($atx -notmatch ('(?m)^Period=' + $c.Tf + '\r?$')){ [void]$guai.Add($pair[1] + ": Period non e' " + $c.Tf) }
      if($atx -notmatch ('(?m)^Symbol=' + $c.Sym + '\r?$')){ [void]$guai.Add($pair[1] + ": Symbol non e' " + $c.Sym) }
      if($atx -notmatch '(?m)^AllowLiveTrading=false\r?$'){ [void]$guai.Add($pair[1] + ": manca AllowLiveTrading=false (checklist 51!)") }
      if($atx -notmatch ('(?m)^InpTF=' + $c.Val["InpTF"] + '(\||\r|$)')){ [void]$guai.Add($pair[1] + ": InpTF non e' " + $c.Val["InpTF"] + " NELL'INI CHE GIRA") }
      if($atx -notmatch ('(?m)^InpPatternMode=' + $c.Val["InpPatternMode"] + '(\||\r|$)')){ [void]$guai.Add($pair[1] + ": InpPatternMode non e' " + $c.Val["InpPatternMode"] + " NELL'INI CHE GIRA") }
      # --- LE DATE, RILETTE DALL'INI E STAMPATE (checklist 79)
      $att = $AtteseFinestra[$pair[1]]
      $mDa = [regex]::Match($atx,'(?m)^FromDate=([^\r\n]*)\r?$')
      $mA  = [regex]::Match($atx,'(?m)^ToDate=([^\r\n]*)\r?$')
      $letDa = "ASSENTE"; if($mDa.Success){ $letDa = $mDa.Groups[1].Value }
      $letA  = "ASSENTE"; if($mA.Success){  $letA  = $mA.Groups[1].Value }
      if($letDa -ne $att[0] -or $letA -ne $att[1]){
        [void]$guai.Add($pair[1] + ": FINESTRA NELL'INI = [" + $letDa + " -> " + $letA + "] invece di [" + $att[0] + " -> " + $att[1] + "]. E' il difetto 79: MT5 NON protesterebbe e il round girerebbe su una finestra NON DICHIARATA.")
      }
      Write-Host ("      " + $pair[1].PadRight(15) + " finestra letta NELL'INI: " + $letDa + " -> " + $letA) -ForegroundColor DarkGray
    }
    if($guai.Count -gt 0){
      foreach($g in $guai){ [void]$Problemi.Add("giro a vuoto / " + $c.Sym + " " + $c.Id + ": " + $g) }
      $c.Esito = "SOLO CONTROLLO (con " + $guai.Count + " rilievi sugli .ini)"
    } else {
      $c.Esito = "SOLO CONTROLLO"
    }
    Write-Host ("    esito: " + $c.Esito) -ForegroundColor Gray
    continue
  }

  # -------------------------------------------------------------------
  #  4a. LA PASSATA SINGOLA -> il report .htm -> TUTTO IL PASSO 0
  # -------------------------------------------------------------------
  Write-Host ("  -- PASSATA SINGOLA " + $c.DataDa + " -> " + $c.DataA + " (magic " + ($c.Base+2) + ")") -ForegroundColor White
  $t0 = Get-Date
  $minS = Lancia $iniSing
  Dico ("  ... passata singola: " + $minS.ToString("0.0",$INV) + " minuti") "Gray"
  $rep = TrovaReport $repSing $t0
  if($rep -eq ""){
    $c.P0Stato = "NON MISURATO (nessun report .htm scritto dopo l'avvio)"
    [void]$Problemi.Add($c.Prova + ": NON ho trovato nessun report '" + $repSing + "*.htm' scritto dopo l'avvio della passata (cercato in " + $InstDir + ", " + $DataFolder + ", " + $Work + ", " + $MqlFiles + "). TUTTO IL PASSO 0 di questa cella resta NON MISURATO e NON si inventa: niente prima operazione, niente take, niente durata, niente peggior giornata. COME AVERLO A MANO: aprire MT5, Strategy Tester, ricaricare l'ini (e' nello zip) in test singolo, tasto destro sul risultato -> Report.")
  } else {
    Copy-Item -LiteralPath $rep -Destination (Join-Path $Sosta ($c.Sym + "_" + $c.Id + "_report_singola.htm")) -Force -ErrorAction SilentlyContinue
    $deal = LeggiDeal $rep
    if(@($deal).Count -eq 0){
      $c.P0Stato = "NON MISURATO (deal non riconosciuti nel report)"
      [void]$Problemi.Add($c.Prova + ": report trovato ma NESSUN deal riconosciuto. Colonne viste: [" + $script:DealColonne + "]. Prime intestazioni: [" + (($script:DealIntestazioni | Select-Object -First 3) -join "  //  ") + "]")
    } else {
      #  LA DURATA SI MISURA IN BARRE DEL TF DELLA CELLA, e il numero di
      #  secondi per barra si prende DAL TF, non a memoria: H1 3600, M30
      #  1800. Sbagliarlo raddoppierebbe o dimezzerebbe la sola misura
      #  che il round confronta con una specifica esterna (S0c).
      $barSec = 3600; if($c.Tf -eq "M30"){ $barSec = 1800 }
      $p0 = Passo0 $deal $s.Pip $barSec ([double]$Deposito)
      $c.P0Stato = $p0.Stato
      $c.P0Ordinamento = $p0.Ordinamento
      $c.P0GruppiPari  = [int]$p0.GruppiPari
      $c.P0Prima = $p0.Prima
      $c.P0N     = $p0.N
      $c.P0TakeNetMed   = $p0.TakeNetMed
      $c.P0TakeNetMedia = $p0.TakeNetMedia
      $c.P0PerdMed      = $p0.PerdMed
      $c.P0DurMed       = $p0.DurMed
      $c.P0DurMedia     = $p0.DurMedia
      $c.P0Pegg         = $p0.Pegg
      $c.P0PeggData     = $p0.PeggData
      if($p0.Anomalie -gt 0){
        #  >>> E QUI NON SI ACCUSA L'EA. E' la lezione 81-bis, pagata a R109:
        #      il driver scriveva "con una posizione alla volta NON DOVREBBE
        #      SUCCEDERE", cioe' puntava il dito sul motore -- l'unico pezzo
        #      innocente della catena -- con una frase tecnicamente
        #      ineccepibile, e sono state bruciate ore a cercare un difetto
        #      che non c'era. La prima domanda quando una guardia scatta non
        #      e' "la guardia e' troppo severa?" ma "CHI HA TOCCATO IL DATO
        #      PRIMA DELLA GUARDIA?". Percio' il messaggio porta con se' LA
        #      MISURA DELL'ORDINAMENTO e i tre testimoni da confrontare.
        [void]$Problemi.Add($c.Prova + ": " + $p0.Anomalie + " deal NON accoppiati (la sequenza in/out non e' alternata). Le misure del PASSO 0 di questa cella sono DICHIARATE NON MISURATE e non si stimano (criteri par. 3.3). >>> PRIMA DI ACCUSARE L'EA, checklist 81-bis: ORDINAMENTO = [" + $p0.Ordinamento + "]. In R109 anomalie identiche a queste erano INVENTATE da un Sort-Object instabile sui deal a pari secondo, e l'EA era pulito. Qui i deal NON sono stati riordinati alla cieca, ma la verifica resta la stessa: confrontare n con i TRE TESTIMONI INDIPENDENTI -- il CSV OPTFRAME di questa cella (colonna Trades), i soli deal 'out' dell'.htm, e il per-trade abtg_trades_*.csv scritto dall'EA. Se i tre concordano fra loro e a dissentire e' questo parser, il difetto e' QUI.")
      }
      # --- LA FINESTRA VERA (criteri par. 4.1): la prima operazione entro
      #     N mesi dall'inizio = PIENA. Oltre = ACCORCIATA, e va nei PROBLEMI.
      if($p0.Prima -ne "NON MISURATA"){
        $dIni = [datetime]::ParseExact($c.DataDa,"yyyy.MM.dd",$INV)
        $dPri = [datetime]::ParseExact($p0.Prima,"yyyy.MM.dd",$INV)
        if($dPri -le $dIni.AddMonths($MesiPrimaOp)){
          $c.P0Finestra = "PIENA (prima op. " + $p0.Prima + ", entro " + $MesiPrimaOp + " mesi dall'inizio)"
        } else {
          $c.P0Finestra = "ACCORCIATA (prima op. " + $p0.Prima + ", finestra dichiarata dal " + $c.DataDa + ")"
          [void]$Problemi.Add($c.Prova + " FINESTRA ACCORCIATA: la prima operazione e' del " + $p0.Prima + ", la finestra dichiarata parte dal " + $c.DataDa + ". >>> @DAQUANDO NON E' UNA MISURA, e' DERIVATO dal tetto delle 100.000 barre (criteri par. 4.1): la finestra REALE e' piu' corta di quella nominale e va RISCRITTA NEL REFERTO PRIMA di leggere qualunque numero di questa cella.")
        }
      }
      # --- IL CANCELLO ZERO S0a, solo sulle celle M30 (criteri par. 3.4)
      #  >>> E SOLO A TICK REALI. Con -ScreenOhlcM30 la cella e' girata a
      #      OHLC M1: il take viene misurato sui prezzi di deal costruiti da
      #      barre finte, ed e' PROPRIO la grandezza che l'OHLC distorce di
      #      piu' su M30 (REGISTRO_TEST.md par. 2). Dare li' un SUPERATO/
      #      FALLITO sarebbe un verdetto verde su un numero che non esiste.
      #      MISURATO il 25/08 facendo girare lo screen: senza questo if il
      #      referto usciva 'S0a SUPERATO' su tutti e tre i simboli, ogni
      #      riga con esito OK e 'ESITO: COMPLETO ... nessun guasto', exit 0.
      #      La regola stava DUE VOLTE nella prosa e ZERO volte nel codice:
      #      e' esattamente il difetto 67. Adesso e' un if.
      if(-not $c.Metro){
        if($ScreenOhlcM30){
          $c.S0a = "NON GIUDICABILE -- questa cella e' girata a OHLC M1 (-ScreenOhlcM30): il take misurato su barre OHLC NON e' il take. Nessun verdetto S0a si da' qui, ne' SUPERATO ne' FALLITO. Serve un giro a MODELLO 4."
        } else {
        $v = VerdettoS0a ([double]$p0.TakeNetMed)
        $c.P0TakeLordoMed = [double]$v.Lordo
        $c.P0Rapporto     = [double]$v.Rapporto
        $c.S0a            = $v.Verdetto
        if($v.Verdetto -like "SOSPESO*"){ [void]$Rilievi.Add("S0a " + $c.Sym + ": " + $v.Verdetto) }
        if($v.Verdetto -like "FALLITO*"){
          [void]$Problemi.Add("CANCELLO ZERO S0a FALLITO su " + $c.Sym + ": " + $v.Verdetto +
                              " >>> E' LA RISPOSTA DEL ROUND SU QUESTO SIMBOLO, NON UN GUASTO: il take a M30 non copre il costo, e i numeri di PF/DD che seguono si leggono SAPENDO questo. Gli altri simboli proseguono (criteri D5).")
        }
        }
      }
    }
  }
  #  il file per-trade dell'EA: non serve al take (non ha il prezzo
  #  d'ingresso) ma e' una seconda vista sui netti, e nello zip ci va.
  if(Test-Path -LiteralPath $CommonFiles){
    $pt = Join-Path $CommonFiles ("abtg_trades_" + $NomeEa + "_" + $c.Sym + "_" + ($c.Base+2) + ".csv")
    if(Test-Path -LiteralPath $pt){
      Copy-Item -LiteralPath $pt -Destination (Join-Path $Sosta ($c.Sym + "_" + $c.Id + "_pertrade_singola.csv")) -Force -ErrorAction SilentlyContinue
    }
  }

  # -------------------------------------------------------------------
  #  4b. LE GEMELLE SULLA FINESTRA INTERA -> profitto / PF / DD / n
  # -------------------------------------------------------------------
  $optCsv = Join-Path $MqlFiles ("OptResults_" + $NomeEa + "_" + $c.Sym + ".csv")
  Write-Host ("  -- GEMELLE finestra INTERA (magic " + $c.Base + "/" + ($c.Base+1) + ")") -ForegroundColor White
  Remove-Item -LiteralPath $optCsv -Force -ErrorAction SilentlyContinue
  $minI = Lancia $iniInt
  Dico ("  ... gemelle intera: " + $minI.ToString("0.0",$INV) + " minuti") "Gray"
  $dstInt = Join-Path $Risultati ($NomeEa + "_" + $c.Sym + "_" + $c.Id + "_INTERA.csv")
  if(Test-Path -LiteralPath $optCsv){ Copy-Item -LiteralPath $optCsv -Destination $dstInt -Force; Remove-Item -LiteralPath $optCsv -Force -ErrorAction SilentlyContinue }
  $rInt = LeggiOpt $dstInt
  $c.GemInt = Gemelli $rInt
  if($null -eq $rInt){
    [void]$Problemi.Add($c.Prova + ": CSV INTERA non letto o colonne non riconosciute. Intestazioni viste: [" + (($script:CsvIntestazioni | Select-Object -First 12) -join " | ") + "]")
  } elseif(@($rInt).Count -ge 1){
    if($null -ne $rInt[0].Pf){     $c.PfInt   = [double]$rInt[0].Pf }
    if($null -ne $rInt[0].Dd){     $c.DdInt   = [double]$rInt[0].Dd }
    if($null -ne $rInt[0].N){      $c.NInt    = [int]$rInt[0].N }
    if($null -ne $rInt[0].Profit){ $c.ProfInt = [double]$rInt[0].Profit }
    if($null -ne $rInt[0].Pg){     $c.PgInt   = [double]$rInt[0].Pg }
  }

  # -------------------------------------------------------------------
  #  4c. IL GATE G0, SOLO SULLA CELLA METRO
  # -------------------------------------------------------------------
  if($c.Metro){
    $s.Gemelli = $c.GemInt
    $guai = New-Object System.Collections.ArrayList
    if($c.GemInt -ne "IDENTICI"){ [void]$guai.Add("gemelli: " + $c.GemInt) }
    if([double]$c.PfInt -lt 0 -or [double]$c.DdInt -lt 0){ [void]$guai.Add("PF o DD NON MISURATI") }
    else{
      #  TOLLERANZE dei criteri par. 5: +-0,01 su PF, +-0,10 punti su DD,
      #  n ESATTO, prima operazione ESATTA.
      #  >>> OGNI CONFRONTO CASTA (checklist 64).
      if([math]::Abs([double]$c.PfInt - [double]$s.PfAtti) -gt 0.01){ [void]$guai.Add("PF " + (Fmt3 $c.PfInt) + " contro " + ([double]$s.PfAtti).ToString("0.000",$INV) + " agli atti") }
      if([math]::Abs([double]$c.DdInt - [double]$s.DdAtti) -gt 0.10){ [void]$guai.Add("DD " + (Fmt2 $c.DdInt) + "% contro " + ([double]$s.DdAtti).ToString("0.00",$INV) + "% agli atti") }
      if([int]$c.NInt -ne [int]$s.NAtti){ [void]$guai.Add("n " + (FmtN $c.NInt) + " contro " + $s.NAtti + " agli atti") }
    }
    if($c.P0Prima -ne "NON MISURATA" -and $c.P0Prima -ne $s.PrimaAtti){
      [void]$guai.Add("prima operazione " + $c.P0Prima + " contro " + $s.PrimaAtti + " agli atti")
    }
    if($guai.Count -gt 0){
      $s.Metro = "NON RIPRODOTTO -- " + ($guai -join " ; ")
      $SimFermi += $c.Sym
      [void]$Problemi.Add("GATE G0 FALLITO su " + $c.Sym + ": " + $s.Metro +
                          ". La cella M30 di questo simbolo NON e' stata lanciata: sopra un metro sbagliato non misurerebbe niente. Fonte dei numeri attesi: R103_REFERTO_DRIVER_FOREX_METALLI_20260824_1922.txt, TABELLA 1.")
      Dico ("GATE G0 FALLITO su " + $c.Sym + ": " + $s.Metro) "Red"
      Dico ("   la cella M30 di " + $c.Sym + " NON verra' lanciata. Gli altri simboli proseguono.") "Red"
    } else {
      $s.Metro = "RIPRODOTTO (PF " + (Fmt3 $c.PfInt) + ", DD " + (Fmt2 $c.DdInt) + "%, n " + (FmtN $c.NInt) + ", prima op. " + $c.P0Prima + ")"
      Dico ("GATE G0 SUPERATO su " + $c.Sym + ": " + $s.Metro) "Green"
    }
    $c.Esito = "OK"
    if($guai.Count -gt 0){ $c.Esito = "G0 FALLITO" }
  }

  # -------------------------------------------------------------------
  #  4d. LE GEMELLE IS e OOS -- solo celle M30
  # -------------------------------------------------------------------
  if(-not $c.Metro){
    foreach($w in @(@("IS",$iniIS,$M30IS_DataDa,$M30IS_DataA,($c.Base+4)),@("OOS",$iniOOS,$M30OOS_DataDa,$M30OOS_DataA,($c.Base+6)))){
      Write-Host ("  -- GEMELLE " + $w[0] + " " + $w[2] + " -> " + $w[3] + " (magic " + $w[4] + "/" + ([int]$w[4]+1) + ")") -ForegroundColor White
      Remove-Item -LiteralPath $optCsv -Force -ErrorAction SilentlyContinue
      $mw2 = Lancia $w[1]
      Dico ("  ... gemelle " + $w[0] + ": " + $mw2.ToString("0.0",$INV) + " minuti") "Gray"
      $dst = Join-Path $Risultati ($NomeEa + "_" + $c.Sym + "_" + $c.Id + "_" + $w[0] + ".csv")
      if(Test-Path -LiteralPath $optCsv){ Copy-Item -LiteralPath $optCsv -Destination $dst -Force; Remove-Item -LiteralPath $optCsv -Force -ErrorAction SilentlyContinue }
      $rr = LeggiOpt $dst
      $gg = Gemelli $rr
      if($null -eq $rr){
        [void]$Problemi.Add($c.Prova + ": CSV " + $w[0] + " non letto o colonne non riconosciute.")
      } elseif(@($rr).Count -ge 1){
        if($w[0] -eq "IS"){
          $c.GemIS = $gg
          if($null -ne $rr[0].Pf){ $c.PfIS = [double]$rr[0].Pf }
          if($null -ne $rr[0].Dd){ $c.DdIS = [double]$rr[0].Dd }
          if($null -ne $rr[0].N){  $c.NIS  = [int]$rr[0].N }
          if($null -ne $rr[0].Profit){ $c.ProfIS = [double]$rr[0].Profit }
          #  G4 dei criteri: "PEGGIOR GIORNATA, misurata SEMPRE". La colonna
          #  c'e' nell'OPTFRAME e LeggiOpt la legge gia': non leggerla qui
          #  vorrebbe dire buttare una misura di RISCHIO gia' pagata.
          if($null -ne $rr[0].Pg){ $c.PgIS = [double]$rr[0].Pg }
        } else {
          $c.GemOOS = $gg
          if($null -ne $rr[0].Pf){ $c.PfOOS = [double]$rr[0].Pf }
          if($null -ne $rr[0].Dd){ $c.DdOOS = [double]$rr[0].Dd }
          if($null -ne $rr[0].N){  $c.NOOS  = [int]$rr[0].N }
          if($null -ne $rr[0].Profit){ $c.ProfOOS = [double]$rr[0].Profit }
          if($null -ne $rr[0].Pg){ $c.PgOOS = [double]$rr[0].Pg }
        }
      }
      if($gg -ne "IDENTICI" -and $gg -ne "NON MISURATO (CSV non letto)"){
        [void]$Problemi.Add($c.Prova + " " + $w[0] + ": gemelli " + $gg + ". Le due righe dovevano essere identiche al centesimo: questa finestra non si legge.")
      }
    }
    # --- IL CANARINO n. NON E' UN GATE (Emendamento regola B).
    #     >>> L'attesa e' PER SIMBOLO, e non e' un numero tirato: e'
    #         l'interpolazione geometrica fra il tasso annuo MISURATO a H1
    #         (R103) e quello MISURATO a M15 (R108). Resta [INFERITA], ma il
    #         referto puo' dire QUANTO ha sbagliato, e di quale segno.
    $AtteseFin = [int]($s.NAtteM30 / 2)
    foreach($pair in @(@("IS",$c.NIS),@("OOS",$c.NOOS))){
      $nn = [int]$pair[1]
      $coda = " >>> ATTESA DICHIARATA PRIMA su " + $c.Sym + ": ~" + $AtteseFin + " per finestra (~" + $s.NAtteM30 +
              " sulla INTERA), [INFERITA] interpolando H1 " + $s.AnnoH1.ToString("0.0",$INV) + "/anno e M15 " +
              $s.AnnoM15.ToString("0.0",$INV) + "/anno. Se n e' molto diverso, quello e' GIA' un risultato: a M15 la frequenza NON scalava col numero di barre."
      if($nn -ge 0 -and $nn -lt 20){
        [void]$Rilievi.Add("CANARINO " + $c.Sym + " " + $pair[0] + ": n = " + $nn + ", sotto 20. Il verdetto su questa finestra e' NON MISURABILE, MAI 'non funziona' (criteri G1). E' l'esito D dei criteri par. 8." + $coda)
      } elseif($nn -ge 0 -and $nn -lt 150){
        [void]$Rilievi.Add("CANARINO " + $c.Sym + " " + $pair[0] + ": n = " + $nn + ", sotto i 150 dell'Emendamento regola A. Il giudizio di MERITO su questa finestra e' SOSPESO; il RISCHIO si legge lo stesso (regola B)." + $coda + " >>> E i criteri par. 3.3 lo DICHIARAVANO: con le attese INFERITE nessuna finestra IS/OOS arriva a 150, e solo GBPUSD ha una speranza sulla INTERA.")
      }
    }
    # --- E IL CANARINO SULLA FINESTRA INTERA, che con 8 anni e' l'unica che
    #     puo' arrivare a 150 (criteri G1, ultimo capoverso). In R108 fu
    #     proprio l'INTERA di GBPUSD (n=227) a rendere il NO leggibile.
    if([int]$c.NInt -ge 0 -and [int]$c.NInt -lt 150){
      [void]$Rilievi.Add("CANARINO " + $c.Sym + " INTERA: n = " + [int]$c.NInt + ", sotto i 150 dell'Emendamento regola A. Su questo simbolo il MERITO PIENO e' SOSPESO ANCHE sulla finestra di 8 anni -- che era l'unica che poteva arrivarci. Attesa dichiarata prima: ~" + $s.NAtteM30 + " [INFERITA]. Il RISCHIO si legge lo stesso (regola B).")
    }
    $c.Esito = "OK"
    #  >>> LO SCREEN OHLC NON PRODUCE UN ESITO 'OK'. La riga della TABELLA
    #      MADRE porta il marchio addosso, non in una nota a tre pagine di
    #      distanza: chi legge la tabella deve vedere il marchio NELLA
    #      TABELLA (difetto 67, misurato eseguendo il 25/08).
    if($ScreenOhlcM30){ $c.Esito = "NON GIUDICABILE" }
    if([int]$c.NInt -lt 0 -or $c.P0Stato -notlike "MISURATO*"){ $c.Esito = "INCOMPLETA (vedi PROBLEMI)" }
  }

  $c.Min = [math]::Round((New-TimeSpan -Start $tCella -End (Get-Date)).TotalMinutes,1)
  Write-Host ("    esito: " + $c.Esito + "   [" + $c.Min.ToString("0.0",$INV) + " min]") -ForegroundColor Gray
}

if($SoloControllo){
  $nAnt = @(Get-ChildItem -LiteralPath $Sosta -Filter "*.ini" -ErrorAction SilentlyContinue).Count
  $attesi = 0
  foreach($c in $Ordinati){ if($c.Metro){ $attesi += 2 } else { $attesi += 4 } }
  if($nAnt -ne $attesi){ [void]$Problemi.Add("giro a vuoto: " + $nAnt + " file .ini in sosta invece di " + $attesi + ".") }
  Write-Host ""
  Write-Host ("    .ini scritti e verificati: " + $nAnt + " su " + $attesi + "   -> " + $Sosta) -ForegroundColor White
  Write-Host  "    >>> COSA SI LEGGE NEGLI .ini, e cosa no:" -ForegroundColor Yellow
  Write-Host  "        SI LEGGE: Symbol, Period, Model, FromDate/ToDate, AllowLiveTrading=false," -ForegroundColor Yellow
  Write-Host  "          l'unico asse Y (InpMagic), il magic, InpTF e InpPatternMode." -ForegroundColor Yellow
  Write-Host  "        >>> E LE DATE SONO STAMPATE QUI SOPRA, RIGA PER RIGA, LETTE DALL'INI" -ForegroundColor Yellow
  Write-Host  "            (checklist 79). Il 25/08 un giro a vuoto e' uscito ESITO OK, codice" -ForegroundColor Yellow
  Write-Host  "            0, con dentro un ToDate fatto di 41 righe di input incollate: le" -ForegroundColor Yellow
  Write-Host  "            fabbriche avevano gate su tutto TRANNE che sulla finestra, e MT5" -ForegroundColor Yellow
  Write-Host  "            con un ToDate invalido NON PROTESTA. L'ha visto Claudio, aprendo un" -ForegroundColor Yellow
  Write-Host ("            .ini dello zip. ATTESE: METRO " + $MetroDataDa + " -> " + $MetroDataA) -ForegroundColor Yellow
  Write-Host ("            M30 " + $M30DataDa + " -> " + $M30DataA + " | IS " + $M30IS_DataDa + " -> " + $M30IS_DataA +
              " | OOS " + $M30OOS_DataDa + " -> " + $M30OOS_DataA) -ForegroundColor Yellow
  Write-Host  "        E NON SI LEGGE NESSUN NUMERO DI ROUND: niente n, niente PF, niente DD," -ForegroundColor Yellow
  Write-Host  "          niente prima operazione, niente TAKE, NIENTE G0 e NIENTE S0." -ForegroundColor Yellow
  Write-Host  "          Il PASSO 0 lo misura la CORSA VERA, dal report .htm della passata" -ForegroundColor Yellow
  Write-Host  "          singola: un giro a vuoto non apre MT5, quindi non ha nessun deal." -ForegroundColor Yellow
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
$Modo = "CORSA"
if($SoloControllo){ $Modo = "CONTROLLO" }
elseif($ScreenOhlcM30){ $Modo = "SCREENOHLC" }
elseif($SoloCella -ne ""){ $Modo = "RIPRESA" }
elseif($SoloSimbolo -ne ""){ $Modo = "SOLO" + ($SoloSimbolo.ToUpper() -replace '[,\s]+','') }
$Cart = Join-Path $Dsk ("R111_BB_M30_" + $Modo + "_" + $Stamp)
$Zip  = Join-Path $Dsk ("R111_BB_M30_" + $Modo + "_" + $Stamp + ".zip")
$Referto = Join-Path $Cart "REFERTO_R111.txt"
try{
  New-Item -ItemType Directory -Force -Path $Cart | Out-Null
  if(Test-Path -LiteralPath $Risultati){
    foreach($f in @(Get-ChildItem -LiteralPath $Risultati -File -Filter "*.csv" -ErrorAction SilentlyContinue)){
      Copy-Item -LiteralPath $f.FullName -Destination (Join-Path $Cart $f.Name) -Force
    }
  }
  if(Test-Path -LiteralPath $Prove){
    foreach($f in @(Get-ChildItem -LiteralPath $Prove -File -ErrorAction SilentlyContinue)){
      Copy-Item -LiteralPath $f.FullName -Destination (Join-Path $Cart $f.Name) -Force
    }
  }
  if(Test-Path -LiteralPath $Sosta){
    foreach($f in @(Get-ChildItem -LiteralPath $Sosta -File -ErrorAction SilentlyContinue)){
      Copy-Item -LiteralPath $f.FullName -Destination (Join-Path $Cart $f.Name) -Force
    }
  }

  $RefTxt = New-Object System.Collections.ArrayList
  [void]$RefTxt.Add("REFERTO R111 - IL BREAKING BAND SU M30: DOV'E' IL CONFINE DELL'EDGE?")
  [void]$RefTxt.Add("ABTG_BreakingBand v" + $EaVer + " su GBPUSD, EURUSD, AUDUSD")
  [void]$RefTxt.Add("due celle per simbolo, e fra loro cambia SOLO InpTF (16385 -> 30)")
  [void]$RefTxt.Add("H1 VIVO (R103, MISURATO) ... M30 MAI MISURATO ... M15 MORTO (R108, MISURATO)")
  if($SoloControllo){ [void]$RefTxt.Add("modo: " + $Modo + "   <<< GIRO A VUOTO: NESSUNA passata, NESSUN CSV, NESSUN numero di round qui dentro") }
  else              { [void]$RefTxt.Add("modo: " + $Modo) }
  $sw = @()
  if($SoloControllo){ $sw += "-SoloControllo (nessuna passata)" }
  if($CriteriFirmati){ $sw += "-CriteriFirmati (REGISTRAZIONE della PRE-FIRMA di Claudio del 25/08, 'FIRMO R111', che e' sul PERIMETRO del round e non sulle sette decisioni: il file dei criteri porta [DA FIRMARE] APPOSTA)" }
  if($ScreenOhlcM30){ $sw += "-ScreenOhlcM30 (le celle M30 girano a OHLC M1: NIENTE di questo giro e' GIUDICABILE)" }
  if($SoloSimbolo -ne ""){ $sw += "-SoloSimbolo " + $SoloSimbolo }
  if($SoloCella -ne ""){ $sw += "-SoloCella " + $SoloCella + " (la cella METRO del suo simbolo e' girata lo stesso: senza il metro il numero non si legge)" }
  if($sw.Count -eq 0){ $sw += "nessuno (corsa piena)" }
  [void]$RefTxt.Add("switch di questo giro: " + ($sw -join " | "))
  [void]$RefTxt.Add("stato dei criteri: " + $Firma)
  [void]$RefTxt.Add("data: " + (Get-Date).ToString("yyyy-MM-dd HH:mm:ss",$INV) + "   (questa data deve essere di ADESSO)")
  [void]$RefTxt.Add("     ATTENZIONE: la data fresca NON distingue un giro a vuoto da una corsa.")
  [void]$RefTxt.Add("     Quello che lo distingue e' la riga 'modo:' qui sopra e il NOME della cartella.")
  [void]$RefTxt.Add("avvio: " + $Avvio.ToString("yyyy-MM-dd HH:mm:ss",$INV) + "   durata: " + ((New-TimeSpan -Start $Avvio -End (Get-Date)).TotalHours).ToString("0.0",$INV) + " ore")
  [void]$RefTxt.Add("pin: " + $Pin)
  [void]$RefTxt.Add("criteri: risultati_archivio\R111_CRITERI.md")
  [void]$RefTxt.Add("antenati: prove\R108_<SIM>_00_metroH1.txt  e  prove\R103_ABTG_BreakingBand_<SIM>_<magic>.txt")
  [void]$RefTxt.Add("gemello: righe\RIGA_R108_BB_M15.ps1 (stesso EA, stessi simboli, TF diverso)")
  [void]$RefTxt.Add("compilato: " + $(if($Compilato){ "SI, .ex5 riscritto adesso" } else { "NO" }))
  [void]$RefTxt.Add("")
  [void]$RefTxt.Add("--- LE FINESTRE E I MODELLI ---")
  [void]$RefTxt.Add("  METRO H1 : " + $MetroDataDa + " -> " + $MetroDataA + "   modello 1 (OHLC M1)")
  [void]$RefTxt.Add("     >>> il modello 1 NON e' una svista: R103 e' girato cosi', e un metro a")
  [void]$RefTxt.Add("         tick reali non riprodurrebbe MAI quel numero (criteri D1).")
  if($ScreenOhlcM30){
    [void]$RefTxt.Add("  M30      : " + $M30DataDa + " -> " + $M30DataA + "   modello 1 (OHLC M1)  <<< SCREEN")
    [void]$RefTxt.Add("     >>> OGNI RIGA M30 DI QUESTO REFERTO E' *NON GIUDICABILE*. Che l'OHLC")
    [void]$RefTxt.Add("         inganni sui TF bassi e' MISURATO in casa (REGISTRO_TEST.md par. 2:")
    [void]$RefTxt.Add("         'in OHLC i Live5m davano numeri finti enormi... In real tick: morti'),")
    [void]$RefTxt.Add("         e su M30 in particolare NON e' misurato ne' in un senso ne' nell'altro.")
    [void]$RefTxt.Add("         Questo giro puo' produrre AL MASSIMO il permesso di un giro a tick.")
  } else {
    [void]$RefTxt.Add("  M30      : " + $M30DataDa + " -> " + $M30DataA + "   modello 4 (TICK REALI)")
  }
  [void]$RefTxt.Add("     IS  " + $M30IS_DataDa + " -> " + $M30IS_DataA + "     OOS " + $M30OOS_DataDa + " -> " + $M30OOS_DataA)
  [void]$RefTxt.Add("     >>> divisione 4+4 anni (criteri D3), e NON il 2+2 di R108 ne' il 40/60")
  [void]$RefTxt.Add("         degli altri round: questi CSV IS/OOS NON sono confrontabili ne' con")
  [void]$RefTxt.Add("         gli uni ne' con gli altri. Dichiarato.")
  [void]$RefTxt.Add("     >>> IL PONTE (criteri par. 4.1): l'OOS di R111 E' LA FINESTRA INTERA di")
  [void]$RefTxt.Add("         R108 a M15. Stessa epoca, stessi simboli, stesso motore, stesso")
  [void]$RefTxt.Add("         modello: fra le due cambia UNA COSA SOLA, il timeframe. E' il")
  [void]$RefTxt.Add("         confronto piu' pulito che questo round puo' produrre, e va letto")
  [void]$RefTxt.Add("         SIMBOLO PER SIMBOLO contro questi numeri MISURATI di R108:")
  [void]$RefTxt.Add("             GBPUSD  M15 INTERA: -8754 / PF 0,823 / n 227")
  [void]$RefTxt.Add("             EURUSD  M15 INTERA: -8872 / PF 0,637 / n  87")
  [void]$RefTxt.Add("             AUDUSD  M15 INTERA: -3131 / PF 0,865 / n 118")
  [void]$RefTxt.Add("     >>> E IL CAVEAT, dichiarato: l'OOS di R111 NON e' 'out of sample' nel")
  [void]$RefTxt.Add("         senso pieno rispetto a R108 -- e' un'epoca che ABBIAMO GIA' GUARDATO,")
  [void]$RefTxt.Add("         su un altro TF. Rispetto ai PARAMETRI, che non tocchiamo, resta OOS;")
  [void]$RefTxt.Add("         rispetto alla nostra conoscenza dell'epoca, no.")
  [void]$RefTxt.Add("     >>> @DAQUANDO " + $M30DataDa + " e' DERIVATO dal tetto delle 100.000 barre")
  [void]$RefTxt.Add("         (240 barre M30 a settimana -> 416,7 settimane = 8,0 anni): SIAMO AL")
  [void]$RefTxt.Add("         LIMITE, non sotto. Se la colonna FINESTRA del PASSO 0 dice ACCORCIATA,")
  [void]$RefTxt.Add("         il 4+4 NON e' piu' 4+4 e va riscritto QUI, PRIMA delle tabelle.")
  [void]$RefTxt.Add("  spread: Spread=" + $SpreadIni + " scritto NELL'INI = spread CORRENTE del feed BCM.")
  [void]$RefTxt.Add("     A modello 1 e' UNA SOLA FOTOGRAFIA applicata a tutta la finestra; a")
  [void]$RefTxt.Add("     modello 4 il bid/ask arriva dai tick. In nessuno dei due c'e' slippage.")
  [void]$RefTxt.Add("  rischio: 1,00% nei file prova. IN CAMPO SUL 100K LE BB SONO ALL'1,0% (R103),")
  [void]$RefTxt.Add("     ma le sedie del 100k girano allo 0,65%: ogni DD va convertito prima di")
  [void]$RefTxt.Add("     confrontarlo col forward.")
  [void]$RefTxt.Add("")
  [void]$RefTxt.Add("--- CONVENZIONE DI SENTINELLA (checklist 66) ---")
  [void]$RefTxt.Add("  Un numero NON MISURATO si scrive 'n/d'. MAI -1, MAI 0.000. Vale per TUTTE le")
  [void]$RefTxt.Add("  colonne: profitto, PF, DD, n, take, durata e peggior giornata.")
  [void]$RefTxt.Add("")
  [void]$RefTxt.Add("--- IL GATE G0: LA CELLA METRO H1 SI RIPRODUCE? (criteri par. 5) ---")
  foreach($s in $SymLavoro){
    [void]$RefTxt.Add("  " + $s.Sym + "   (InpPatternMode VIVO = " + $s.Pat + ")")
    [void]$RefTxt.Add("     atteso agli atti : profitto " + ([double]$s.ProfAtti).ToString("+0;-0;0",$INV) +
                 " | PF " + ([double]$s.PfAtti).ToString("0.000",$INV) +
                 " | DD " + ([double]$s.DdAtti).ToString("0.00",$INV) + "% | n " + $s.NAtti + " | prima op. " + $s.PrimaAtti)
    $cm = @($Ordinati | Where-Object { $_.Sym -eq $s.Sym -and $_.Metro })
    if($cm.Count -eq 1){
      [void]$RefTxt.Add("     misurato adesso  : profitto " + (FmtE $cm[0].ProfInt) + " | PF " + (Fmt3 $cm[0].PfInt) +
                   " | DD " + (Fmt2 $cm[0].DdInt) + "% | n " + (FmtN $cm[0].NInt) + " | prima op. " + $cm[0].P0Prima)
    } else {
      [void]$RefTxt.Add("     misurato adesso  : NON ESEGUITA in questo giro")
    }
    [void]$RefTxt.Add("     gemelli          : " + $s.Gemelli)
    [void]$RefTxt.Add("     VERDETTO G0      : " + $s.Metro)
    [void]$RefTxt.Add("     profondita' TICK : " + $s.TickMisurati)
    [void]$RefTxt.Add("     fonte dei numeri : R103_REFERTO_DRIVER_FOREX_METALLI_20260824_1922.txt, TABELLA 1")
    [void]$RefTxt.Add("                        (seconda conferma: R108 ha fatto G0 3/3 al centesimo il 25/08)")
    [void]$RefTxt.Add("     frequenza attesa a M30 [INFERITA, interpolazione fra DUE PUNTI MISURATI]:")
    [void]$RefTxt.Add("                        H1 " + $s.AnnoH1.ToString("0.0",$INV) + "/anno -> M15 " + $s.AnnoM15.ToString("0.0",$INV) +
                       "/anno  ==>  ~" + $s.NAtteM30 + " sulla INTERA, ~" + [int]($s.NAtteM30/2) + " per finestra")
  }
  [void]$RefTxt.Add("  NOTA: 'NON MISURATO' NON e' 'va bene'. Un gate che non legge niente non e' un")
  [void]$RefTxt.Add("  gate verde. Se il metro non si riproduce, la cella M30 di QUEL simbolo non e'")
  [void]$RefTxt.Add("  stata nemmeno lanciata -- e gli altri simboli sono andati avanti.")
  [void]$RefTxt.Add("")
  [void]$RefTxt.Add("--- IL PASSO 0: IL CANCELLO ZERO SUL COSTO (criteri par. 3) ---")
  [void]$RefTxt.Add("  Si legge PRIMA di qualunque PF. Il take e' misurato SUI PREZZI dei deal")
  [void]$RefTxt.Add("  (in -> out) del report .htm della passata singola, quindi in PIP e senza")
  [void]$RefTxt.Add("  nessuna conversione di valuta. E' GIA' AL NETTO dello spread (entry all'ask,")
  [void]$RefTxt.Add("  uscita al bid): il LORDO si ottiene aggiungendo lo spread dichiarato.")
  [void]$RefTxt.Add("  spread DICHIARATO: " + $SpreadPipDich.ToString("0.0",$INV) + " pip   [NON MISURATO -- criteri D4]")
  [void]$RefTxt.Add("  soglia S0a: take LORDO MEDIANO dei vincenti >= " + $S0aMult.ToString("0.0",$INV) + "x lo spread")
  [void]$RefTxt.Add(("  {0,-8} {1,-11} {2,-13} {3,-6} {4,-9} {5,-9} {6,-9} {7,-8} {8}" -f `
                "SIMB","CELLA","PRIMA-OP","n","TAKEnet","TAKElordo","PERDmed","DURmed","FINESTRA"))
  foreach($c in $Ordinati){
    [void]$RefTxt.Add(("  {0,-8} {1,-11} {2,-13} {3,-6} {4,-9} {5,-9} {6,-9} {7,-8} {8}" -f `
                  $c.Sym,$c.Id,$c.P0Prima,(FmtN $c.P0N),(Fmt2 $c.P0TakeNetMed),(Fmt2 $c.P0TakeLordoMed),
                  (Fmt2 $c.P0PerdMed),(Fmt2 $c.P0DurMed),$c.P0Finestra))
  }
  [void]$RefTxt.Add("  (TAKE in PIP, mediana sui VINCENTI. DUR in BARRE del TF della cella.)")
  [void]$RefTxt.Add("")
  foreach($c in @($Ordinati | Where-Object { -not $_.Metro })){
    [void]$RefTxt.Add("  S0a " + $c.Sym + ": " + $c.S0a)
    [void]$RefTxt.Add("      stato del PASSO 0: " + $c.P0Stato)
    [void]$RefTxt.Add("      ordinamento dei deal (checklist 81): " + $c.P0Ordinamento)
    [void]$RefTxt.Add("      take medio (non mediano) sui vincenti: " + (Fmt2 $c.P0TakeNetMedia) + " pip netto")
    [void]$RefTxt.Add("      durata media (non mediana): " + (Fmt2 $c.P0DurMedia) + " barre")
    [void]$RefTxt.Add("      peggior giornata: " + (FmtPg $c.P0Pegg) + "%  il " + $c.P0PeggData + "   (muro prop: -5,00%)")
  }
  [void]$RefTxt.Add("  >>> LA DURATA E' UNA MISURA, NON UN CANCELLO (criteri par. 3.3, S0c). Se la")
  [void]$RefTxt.Add("      mediana esce 1-3 barre, va scritto come SEGNALE DI ALLARME sulla")
  [void]$RefTxt.Add("      robustezza anche a cancelli verdi: arXiv 2605.04004 par. 6.2 misura che")
  [void]$RefTxt.Add("      i soli segnali intraday sopravvissuti tengono 12-15 barre, non 1-6.")
  [void]$RefTxt.Add("")
  [void]$RefTxt.Add("--- LA TABELLA MADRE ---   (attese: " + $CelleAttese + " righe per CSV, " + $PassateAttese + " passate)")
  #  >>> LA COLONNA ISdd C'E'. La v1 leggeva il DD della IS dal CSV e poi non
  #      lo stampava da nessuna parte: una misura di RISCHIO raccolta e
  #      buttata. E il RISCHIO non si sospende mai (Emendamento regola B).
  [void]$RefTxt.Add(("  {0,-8} {1,-11} {2,-9} {3,-7} {4,-7} {5,-6} {6,-9} {7,-7} {8,-7} {9,-6} {10,-9} {11,-7} {12,-7} {13,-6} {14}" -f `
                "SIMB","CELLA","INTprof","INTpf","INTdd","INTn","ISprof","ISpf","ISdd","ISn","OOSprof","OOSpf","OOSdd","OOSn","ESITO"))
  foreach($c in $Ordinati){
    [void]$RefTxt.Add(("  {0,-8} {1,-11} {2,-9} {3,-7} {4,-7} {5,-6} {6,-9} {7,-7} {8,-7} {9,-6} {10,-9} {11,-7} {12,-7} {13,-6} {14}" -f `
                  $c.Sym,$c.Id,(FmtE $c.ProfInt),(Fmt3 $c.PfInt),(Fmt2 $c.DdInt),(FmtN $c.NInt),
                  (FmtE $c.ProfIS),(Fmt3 $c.PfIS),(Fmt2 $c.DdIS),(FmtN $c.NIS),
                  (FmtE $c.ProfOOS),(Fmt3 $c.PfOOS),(Fmt2 $c.DdOOS),(FmtN $c.NOOS),$c.Esito))
  }
  [void]$RefTxt.Add("")
  # --- IL PONTE: la colonna OOS di R111 contro la INTERA di R108, che sono
  #     LA STESSA EPOCA. E' il confronto per cui la finestra e' stata scelta
  #     cosi', quindi si stampa DENTRO il referto e non si lascia a chi legge.
  [void]$RefTxt.Add("--- IL PONTE M30 <-> M15: LA STESSA EPOCA, DUE TIMEFRAME (criteri par. 4.1) ---")
  [void]$RefTxt.Add("  finestra: " + $M30OOS_DataDa + " -> " + $M30OOS_DataA + " = l'OOS di R111 E la INTERA di R108.")
  [void]$RefTxt.Add(("  {0,-8} {1,-24} {2,-24} {3}" -f "SIMB","M15 (R108, MISURATO)","M30 (R111, OOS)","cambia SOLO il TF"))
  $PonteR108 = @{}
  $PonteR108["GBPUSD"] = "-8754 / PF 0,823 / n 227"
  $PonteR108["EURUSD"] = "-8872 / PF 0,637 / n  87"
  $PonteR108["AUDUSD"] = "-3131 / PF 0,865 / n 118"
  foreach($c in @($Ordinati | Where-Object { -not $_.Metro })){
    $vecchio = "n/d (simbolo non in R108)"
    if($PonteR108.ContainsKey($c.Sym)){ $vecchio = $PonteR108[$c.Sym] }
    $nuovo = (FmtE $c.ProfOOS) + " / PF " + (Fmt3 $c.PfOOS) + " / n " + (FmtN $c.NOOS)
    [void]$RefTxt.Add(("  {0,-8} {1,-24} {2,-24} {3}" -f $c.Sym,$vecchio,$nuovo,"InpTF 15 -> 30"))
  }
  [void]$RefTxt.Add("  >>> CAVEAT DICHIARATO: rispetto ai PARAMETRI (che non tocchiamo) l'OOS resta")
  [void]$RefTxt.Add("      OOS; rispetto alla NOSTRA CONOSCENZA dell'epoca no -- quella epoca l'abbiamo")
  [void]$RefTxt.Add("      gia' guardata a M15. Non e' un difetto: e' il prezzo del ponte, e si dice.")
  [void]$RefTxt.Add("")
  # --- G4: LA PEGGIOR GIORNATA, MISURATA SEMPRE (criteri par. 5, G4).
  #     Due viste, e vanno tenute distinte: quella del report .htm e' sulla
  #     finestra INTERA della passata SINGOLA; quelle del CSV sono per
  #     FINESTRA (INTERA / IS / OOS) e vengono dall'OPTFRAME. Se divergono,
  #     e' un'informazione, non un guasto: sono due strumenti diversi.
  [void]$RefTxt.Add("--- G4: LA PEGGIOR GIORNATA (muro prop: -5,00% su 100k) ---")
  [void]$RefTxt.Add(("  {0,-8} {1,-11} {2,-12} {3,-12} {4,-10} {5,-10} {6}" -f `
                "SIMB","CELLA","htm-INTERA","quando","csv-INTERA","csv-IS","csv-OOS"))
  foreach($c in $Ordinati){
    [void]$RefTxt.Add(("  {0,-8} {1,-11} {2,-12} {3,-12} {4,-10} {5,-10} {6}" -f `
                  $c.Sym,$c.Id,(FmtPg $c.P0Pegg),$c.P0PeggData,
                  (FmtPg $c.PgInt),(FmtPg $c.PgIS),(FmtPg $c.PgOOS)))
  }
  [void]$RefTxt.Add("  (tutti in % del deposito. 'n/d' = NON MISURATA, mai 0.)")
  [void]$RefTxt.Add("  >>> CHECKLIST 80: la colonna 'Peggior Giornata %' NON e' stata ereditata dal")
  [void]$RefTxt.Add("      round gemello, e' stata RIVERIFICATA NEL SORGENTE di QUESTO EA il 25/08:")
  [void]$RefTxt.Add("      ABTG_BreakingBand.mq5 riga 1591 dichiara 'double stats[10]' e riga 1625")
  [void]$RefTxt.Add("      scrive un OPTFRAME a 11 colonne che LA CONTIENE. Quindi un 'n/d' in queste")
  [void]$RefTxt.Add("      colonne vuol dire 'stavolta non e' uscita', NON 'e' strutturalmente")
  [void]$RefTxt.Add("      impossibile' -- ed e' la distinzione che il punto 80 impone di dichiarare.")
  [void]$RefTxt.Add("")
  [void]$RefTxt.Add("  gemelli: " )
  foreach($c in $Ordinati){
    [void]$RefTxt.Add("    " + $c.Sym + " " + $c.Id + "  INTERA: " + $c.GemInt + " | IS: " + $c.GemIS + " | OOS: " + $c.GemOOS)
  }
  [void]$RefTxt.Add("")
  [void]$RefTxt.Add("--- LE CELLE, COME SONO SCRITTE NEI FILE CHE HANNO GIRATO ---")
  foreach($c in $Ordinati){
    [void]$RefTxt.Add(("  {0,-8} {1,-11} magic {2}/{3} (int) {4} (sing) {5}/{6} (IS) {7}/{8} (OOS)" -f `
                  $c.Sym,$c.Id,$c.Base,($c.Base+1),($c.Base+2),($c.Base+4),($c.Base+5),($c.Base+6),($c.Base+7)))
    [void]$RefTxt.Add("       InpTF=" + $c.Val["InpTF"] + "  InpPatternMode=" + $c.Val["InpPatternMode"] + "  modello " + $c.Modello + "  " + $c.Desc)
  }
  [void]$RefTxt.Add("")
  [void]$RefTxt.Add("--- QUELLO CHE QUESTO REFERTO NON DICE, DICHIARATO ---")
  [void]$RefTxt.Add("  * NON APPLICA I CANCELLI DI MERITO. G2 (positivo in ENTRAMBE le finestre, PF")
  [void]$RefTxt.Add("    OOS >= 1,10, DD OOS < 10%) e G3 (coerenza cross-simbolo) li applica il")
  [void]$RefTxt.Add("    REFERTO DEL ROUND, a mano, sopra questa tabella. Qui ci sono i numeri.")
  [void]$RefTxt.Add("  * G3 in particolare NON e' meccanizzabile: e' un confronto fra TRE tabelle,")
  [void]$RefTxt.Add("    ed e' il cancello che protegge dal 'uno su tre e' andato bene'. Un simbolo")
  [void]$RefTxt.Add("    su tre NON e' un edge: e' rumore, finche' qualcuno non dimostra il contrario.")
  [void]$RefTxt.Add("  * LA PROFONDITA' DEI TICK sui tre simboli NON E' MISURATA IN REPO (esiste una")
  [void]$RefTxt.Add("    sola misura, ed e' U30USD). A modello 4 senza tick reali MT5 NON SI FERMA:")
  [void]$RefTxt.Add("    ripiega e produce numeri PLAUSIBILI E FALSI. Vedi la riga 'profondita' TICK'")
  [void]$RefTxt.Add("    di ogni simbolo qui sopra e i RILIEVI.")
  [void]$RefTxt.Add("  * LO SPREAD NON E' MISURATO: la soglia di S0a usa un valore DICHIARATO, ed e'")
  [void]$RefTxt.Add("    LO STESSO DI R108 apposta -- cambiarlo renderebbe i due S0a incomparabili.")
  [void]$RefTxt.Add("  * @DAQUANDO " + $M30DataDa + " e' DERIVATO dal tetto delle 100.000 barre, NON e'")
  [void]$RefTxt.Add("    una misura, e stavolta la finestra e' AL LIMITE del tetto (8,0 anni su 8,0).")
  [void]$RefTxt.Add("    La colonna FINESTRA del PASSO 0 dice se e' stata rispettata.")
  [void]$RefTxt.Add("  * NIENTE M20, NIENTE M10, NIENTE M5, e non e' pigrizia: i criteri par. 8")
  [void]$RefTxt.Add("    dichiarano PRIMA che un M30 rosso CHIUDE il capitolo della discesa di TF.")
  [void]$RefTxt.Add("    Un TF intermedio in piu' sarebbe pesca (Seconda Caccia).")
  [void]$RefTxt.Add("  * NON PROMUOVE NIENTE (G5) e non tocca nessuna sedia in forward. Le tre")
  [void]$RefTxt.Add("    BreakingBand H1 restano dove sono. E anche un M30 VERDE non e' una sedia:")
  [void]$RefTxt.Add("    e' un ROUND DI VALIDAZIONE nuovo, con criteri nuovi (decisione D7).")
  [void]$RefTxt.Add("  * NON HA TOCCATO UNA RIGA DI ABTG_BreakingBand.mq5.")
  [void]$RefTxt.Add("")
  [void]$RefTxt.Add("--- LA LETTURA DEL CONFINE, PRE-DICHIARATA (criteri par. 8) ---")
  [void]$RefTxt.Add("  >>> QUESTA TABELLA ERA SCRITTA PRIMA DI VEDERE UN SOLO NUMERO. Il referto")
  [void]$RefTxt.Add("      del round si legge CONTRO di lei, non raccontando i numeri.")
  [void]$RefTxt.Add("  A) M30 VERDE su >=2 simboli (G2 pieno) con G3 coerente")
  [void]$RefTxt.Add("     -> IL CONFINE STA FRA M30 E M15. Apre UN ROUND DI VALIDAZIONE nuovo")
  [void]$RefTxt.Add("        (prova di regime, spread MISURATO, tick MISURATI, posto in portafoglio).")
  [void]$RefTxt.Add("        NON e' una promozione: G5, e la decisione D7.")
  [void]$RefTxt.Add("  B) M30 ROSSO ovunque (0 su 3)")
  [void]$RefTxt.Add("     -> IL CONFINE STA FRA H1 E M30, e IL CAPITOLO 'ABBASSO IL TF DEL BREAKING")
  [void]$RefTxt.Add("        BAND' SI CHIUDE. Niente M20, niente M10, niente M5, nessun ripescaggio,")
  [void]$RefTxt.Add("        nessuna nuova griglia. E la frequenza forex per la challenge non verra'")
  [void]$RefTxt.Add("        da questa famiglia: si spende altrove (indici, oro).")
  [void]$RefTxt.Add("  C) MISTO (un simbolo verde, gli altri no)")
  [void]$RefTxt.Add("     -> G3 DICE NO. Un simbolo su tre non e' un edge: e' rumore -- ed e' il")
  [void]$RefTxt.Add("        cancello che in R46 fermo' un candidato che faceva +31%. Resta una riga")
  [void]$RefTxt.Add("        a registro col numero, e nessun round nuovo parte.")
  [void]$RefTxt.Add("  D) n<20 per finestra, oppure FINESTRA ACCORCIATA su tutti e tre")
  [void]$RefTxt.Add("     -> NON MISURABILE: il round ha misurato il tetto delle barre o i tick, non")
  [void]$RefTxt.Add("        il motore. E NON MISURABILE NON E' UN NO: non chiude nessun capitolo.")
  [void]$RefTxt.Add("  >>> Se a numeri visti qualcuno propone una QUINTA lettura, quella lettura va")
  [void]$RefTxt.Add("      scritta e firmata PRIMA di essere usata -- e a quel punto non e' piu' una")
  [void]$RefTxt.Add("      lettura di R111: e' un round nuovo.")
  [void]$RefTxt.Add("")
  if($Rilievi.Count -gt 0){
    [void]$RefTxt.Add("--- RILIEVI (NON sono guasti: sono RISULTATI del round) ---   (" + $Rilievi.Count + ")")
    foreach($n in $Rilievi){ [void]$RefTxt.Add("  - " + $n) }
    [void]$RefTxt.Add("")
  }
  [void]$RefTxt.Add("--- PROBLEMI (questi SI sono guasti, o risposte scomode) ---   (" + $Problemi.Count + ")")
  if($Problemi.Count -eq 0){ [void]$RefTxt.Add("  nessuno.") }
  foreach($p in $Problemi){ [void]$RefTxt.Add("  - " + $p) }
  if($Fatale -ne ""){
    [void]$RefTxt.Add("")
    [void]$RefTxt.Add("--- FERMATO ---")
    [void]$RefTxt.Add("  " + $Fatale)
  }
  [void]$RefTxt.Add("")
  # --- L'ESITO SCRITTO NEL REFERTO DICE LE STESSE PAROLE DELLO SCHERMO,
  #     e distingue PARZIALE da COMPLETO CON RILIEVI (checklist 47 e 68).
  $koR = @($Ordinati | Where-Object { $_.Esito -ne "OK" -and $_.Esito -notlike "SOLO CONTROLLO*" -and $_.Esito -ne "NON GIUDICABILE" })
  if($Fatale -ne ""){
    [void]$RefTxt.Add("ESITO: FERMATO -- " + $Fatale)
  }
  elseif($ScreenOhlcM30 -and -not $SoloControllo){
    #  >>> LO SCREEN HA UN ESITO SUO, E NON PUO' ESSERE 'COMPLETO'. Senza
    #      questo ramo il referto chiudeva con "tutte le celle hanno prodotto
    #      i numeri attesi ... nessun guasto" e uscita 0 su una tabella che
    #      per costruzione non vale niente (misurato il 25/08).
    [void]$RefTxt.Add("ESITO: SCREEN OHLC -- NESSUN VERDETTO. Le celle M30 sono girate a MODELLO 1 (OHLC M1), non a tick reali: nessun cancello si applica, nessun S0a e' stato dato, e ogni riga M30 e' marcata NON GIUDICABILE. Che l'OHLC inganni sui TF bassi e' MISURATO in casa (REGISTRO_TEST.md par. 2), e su M30 in particolare NON e' misurato ne' in un senso ne' nell'altro: percio' non si giudica. Questo giro puo' produrre AL MASSIMO il PERMESSO di un giro a tick reali. Celle senza numeri: " + $koR.Count + " - problemi: " + $Problemi.Count + " - rilievi: " + $Rilievi.Count + ".")
  }
  elseif($SoloControllo){
    if($koR.Count -gt 0 -or $Problemi.Count -gt 0){
      [void]$RefTxt.Add("ESITO: GIRO A VUOTO CON PROBLEMI (" + $Problemi.Count + ") -- NESSUNA passata. NON lanciare la corsa vera prima di aver letto i PROBLEMI.")
    } else {
      [void]$RefTxt.Add("ESITO: GIRO A VUOTO COMPLETATO -- NESSUNA passata, NESSUN CSV, NESSUN numero. QUESTO ZIP NON E' IL ROUND.")
    }
  }
  elseif($koR.Count -gt 0){
    [void]$RefTxt.Add("ESITO: PARZIALE -- " + $koR.Count + " celle su " + $Ordinati.Count + " NON hanno prodotto i numeri attesi, piu' " + $Problemi.Count + " problemi. NON e' un round completo.")
  }
  elseif($Problemi.Count -gt 0){
    [void]$RefTxt.Add("ESITO: COMPLETO CON PROBLEMI -- tutte e " + $Ordinati.Count + " le celle hanno prodotto i numeri, ma ci sono " + $Problemi.Count + " problemi (fra cui puo' esserci un S0a FALLITO, che e' una RISPOSTA e non un guasto). I numeri si leggono ACCANTO ai problemi, non invece dei problemi.")
  }
  elseif($Rilievi.Count -gt 0){
    [void]$RefTxt.Add("ESITO: COMPLETO CON RILIEVI -- tutte e " + $Ordinati.Count + " le celle hanno prodotto i numeri attesi. I " + $Rilievi.Count + " rilievi sono RISULTATI del round (canarino, profondita' tick non misurata, S0a sospeso), non guasti.")
  }
  else{
    [void]$RefTxt.Add("ESITO: OK -- tutte le celle hanno prodotto i numeri attesi, nessun problema e nessun rilievo.")
  }
  [void]$RefTxt.Add("")
  [void]$RefTxt.Add("--- COME SI RIPRENDE ---")
  [void]$RefTxt.Add('  un simbolo solo    : ... & $p -Pin <PIN> -CriteriFirmati -SoloSimbolo ''GBPUSD''')
  [void]$RefTxt.Add('  due simboli        : ... & $p -Pin <PIN> -CriteriFirmati -SoloSimbolo ''GBPUSD,EURUSD''   <-- FRA APICI (checklist 65)')
  [void]$RefTxt.Add('  una cella sola     : ... & $p -Pin <PIN> -CriteriFirmati -SoloCella ''R111_GBPUSD_01_m30.txt''')
  [void]$RefTxt.Add("  >>> in tutti i casi la cella METRO del simbolo rigira: e' la prova che il")
  [void]$RefTxt.Add("      banco e' sano, e senza non si legge niente.")
  [void]$RefTxt.Add("  >>> E OGNI RIGA DI RIPRESA E' UN BLOCCO INTERO col suo irm e la sua guardia")
  [void]$RefTxt.Add("      (checklist 42): i tre puntini stanno per il blocco di RIGA_R111_DA_MANDARE.md.")
  #  >>> APICI SINGOLI, ED E' LA CHECKLIST 76 (difetto vero, MISURATO nella
  #      corsa vera di R108): questa frase deve MOSTRARE del codice, e in
  #      apici DOPPI PowerShell espande $p -- che nello script ESISTE, ed e'
  #      la variabile del ciclo `foreach($p in $Problemi)` venti righe piu'
  #      su. In PowerShell la variabile di un foreach NON muore col ciclo:
  #      resta in scope e vale l'ULTIMO elemento. Risultato misurato in
  #      R108: al posto del comando finiva IL TESTO DELL'ULTIMO PROBLEMA,
  #      cioe' un paragrafo intero in mezzo alla frase -- e sembrava un
  #      guasto del referto proprio nella corsa andata male. Con zero
  #      problemi, invece, la frase usciva mozza: "Una riga '&  ...'".
  [void]$RefTxt.Add('      Una riga ''& $p ...'' incollata da sola riusa la copia locale e il pin di prima.')

  Set-Content -LiteralPath $Referto -Value ($RefTxt -join "`r`n") -Encoding UTF8
  if(Test-Path -LiteralPath $Zip){ Remove-Item -LiteralPath $Zip -Force -ErrorAction SilentlyContinue }
  Compress-Archive -Path (Join-Path $Cart "*") -DestinationPath $Zip -Force
}catch{
  Write-Host ("!!! RACCOLTA PARZIALE: " + $_.Exception.Message) -ForegroundColor Red
}

Write-Host ""
Write-Host "=====================================================================" -ForegroundColor White
Write-Host "  R111 - FINE" -ForegroundColor White
function Riga3([string]$path,[string]$coda){
  if(Test-Path -LiteralPath $path){ Write-Host ("   " + $path + "   " + $coda) -ForegroundColor White }
  else                            { Write-Host ("   " + $path + "   <<< NON ESISTE") -ForegroundColor Red }
}
Riga3 $Cart    ""
Riga3 $Zip     "<- e' questo che mi mandi"
Riga3 $Referto "<- la riga 'data:' deve essere di ADESSO, la riga 'modo:' dice se e' il round o un giro a vuoto"
Write-Host "=====================================================================" -ForegroundColor White
if($SoloControllo){
  Write-Host ("  MODO: " + $Modo + " -- GIRO A VUOTO. NESSUNA passata, NESSUN CSV, NESSUN") -ForegroundColor Yellow
  Write-Host  "        numero di round. GATE G0 e CANCELLO S0: NON ESEGUITI, ed e' giusto" -ForegroundColor Yellow
  Write-Host  "        cosi'. Si misurano nella CORSA VERA, dal report .htm della singola." -ForegroundColor Yellow
  Write-Host  "        QUESTO ZIP NON E' IL ROUND e non va mandato come risultato." -ForegroundColor Yellow
} else {
  Write-Host ("  MODO: " + $Modo) -ForegroundColor White
  Write-Host ("  ATTESE:  " + $PassateAttese + " passate, " + $CelleAttese + " righe per CSV di ottimizzazione.") -ForegroundColor White
  if($ScreenOhlcM30){
    Write-Host  "  >>> -ScreenOhlcM30 ACCESO: OGNI RIGA M30 E' NON GIUDICABILE." -ForegroundColor Yellow
  }
  foreach($s in $SymLavoro){
    $col = "Red"
    if($s.Metro -like "RIPRODOTTO*"){ $col = "Green" }
    Write-Host ("  GATE G0 " + $s.Sym + ": " + $s.Metro) -ForegroundColor $col
  }
  foreach($c in @($Ordinati | Where-Object { -not $_.Metro })){
    $col = "Yellow"
    if($c.S0a -like "SUPERATO*"){ $col = "Green" }
    if($c.S0a -like "FALLITO*"){ $col = "Red" }
    Write-Host ("  S0a " + $c.Sym + ": " + $c.S0a) -ForegroundColor $col
  }
}
foreach($c in $Ordinati){
  $col = "Green"; if($c.Esito -ne "OK" -and $c.Esito -notlike "SOLO CONTROLLO*"){ $col = "Yellow" }
  Write-Host ("   " + ($c.Sym + " " + $c.Id).PadRight(22) + " " + $c.Esito) -ForegroundColor $col
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
#      incolla in chat puo' annunciare "PARZIALE O FERMO" su un round
#      perfetto.
#  >>> E GLI STATI SONO PIU' DI DUE (checklist 68): "COMPLETO CON RILIEVI"
#      e' un successo e esce 0.
#      CODICI: 0 = OK / COMPLETO CON RILIEVI
#              1 = parziale, fermato, con problemi, o selettore a vuoto
#              2 = criteri non firmati
# =====================================================================
if($Fatale -ne ""){ Write-Host ("ESITO: FERMATO -- " + $Fatale) -ForegroundColor Red; exit 1 }
$ko = @($Ordinati | Where-Object { $_.Esito -ne "OK" -and $_.Esito -notlike "SOLO CONTROLLO*" -and $_.Esito -ne "NON GIUDICABILE" })
if($ScreenOhlcM30 -and -not $SoloControllo){
  Write-Host  "ESITO: SCREEN OHLC -- NESSUN VERDETTO. Le celle M30 sono girate a OHLC M1:" -ForegroundColor Yellow
  Write-Host  "       nessun cancello, nessun S0a, ogni riga M30 marcata NON GIUDICABILE." -ForegroundColor Yellow
  Write-Host ("       Celle senza numeri: " + $ko.Count + " - problemi: " + $Problemi.Count + " - rilievi: " + $Rilievi.Count + ". Lo zip esiste: mandalo.") -ForegroundColor Yellow
  exit 1
}
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
  Write-Host ("ESITO: COMPLETO CON PROBLEMI (" + $Problemi.Count + ") -- i numeri ci sono TUTTI, ma vanno letti ACCANTO ai problemi. Lo zip esiste: mandalo.") -ForegroundColor Yellow
  exit 1
}
if($Rilievi.Count -gt 0){
  Write-Host ("ESITO: COMPLETO CON RILIEVI (" + $Rilievi.Count + " rilievi da leggere nel referto, nessuna cella mancante e nessun guasto)") -ForegroundColor Green
  exit 0
}
Write-Host "ESITO: OK" -ForegroundColor Green
exit 0
