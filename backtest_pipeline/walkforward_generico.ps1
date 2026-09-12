# =====================================================================
#  MARCATORE_WALKFORWARD_GENERICO_v5_INCLUDE
#  walkforward_generico.ps1  --  UN walk-forward per QUALSIASI EA
# ---------------------------------------------------------------------
#  PERCHE' ESISTE (07/08/2026)
#  Claudio: "puoi creare un agente che mi faccia i backtest, le
#  ottimizzazioni, che trovi i motori in autonomia degli EA che ho?".
#  Il collo di bottiglia non e' l'analisi: e' che finora OGNI EA ha
#  voluto il SUO driver scritto a mano. walkforward_aperture.ps1 sa fare
#  solo le aperture, walkforward_pte.ps1 sa fare solo la PTE. Con 39 EA
#  testabili (scheda_ea.py, 07/08) quello e' un lavoro di sartoria che
#  non finisce mai.
#
#  QUESTO invece non sa niente di nessun EA. Legge il .mq5, si ricava
#  da solo l'elenco degli input e li BLINDA tutti al loro default; poi
#  legge da prove\<EA>.txt le SOLE righe da spazzolare, con l'ipotesi e
#  i criteri gia' scritti sopra. Aggiungere un EA alla coda = scrivere
#  un file di testo, non un driver.
#
#  LE TRE TRAPPOLE CHE BLOCCA, GIA' PAGATE TUTTE E TRE
#   1. SWEEP DEGENERE: flag Y con start == stop, oppure step == 0. Non
#      spazzola niente e su un enum non produce nemmeno un pass. Il
#      07/08 sono usciti QUATTRO CSV VUOTI dopo una notte di macchina.
#   2. PARAMETRO DOPPIO in [TesterInputs]: MT5 fa zero passate.
#   3. NOME SBAGLIATO: un parametro che l'EA non ha viene ignorato in
#      silenzio da MT5, e la fase risponde a una domanda diversa da
#      quella che credevi di fare. Qui e' un errore, non un avviso.
#
#  E DICE QUANTE CELLE ASPETTARSI, PRIMA DI PARTIRE. Sugli enum MT5
#  IGNORA LO STEP e spazzola i membri compresi fra start e stop
#  (misurato il 07/08: InpTrailTF=5||1||4||5||Y ha dato M1..M5, cinque
#  celle, non ventidue). Il conteggio qui sotto lo tiene in conto.
#
#  QUELLO CHE NON FA, dichiarato:
#   - non dice se un EA e' buono. Produce i CSV. Il giudizio si legge
#     dai numeri FUORI campione contro i criteri scritti PRIMA.
#   - non verifica lo storico del simbolo. Quello si misura con
#     scarica_storico.ps1 -Simboli "XXX" -SoloReferto e si passa qui
#     con -DaQuando. Sugli indici il driver diceva 2024.01.01 e i dati
#     partivano dal 26/09/2024: meta' finestra IS non esisteva.
#
#  USO (PC di backtest, MT5 CHIUSO):
#    powershell -ExecutionPolicy Bypass -File .\walkforward_generico.ps1 -Expert ABTG_PTE -SoloControllo
#    powershell -ExecutionPolicy Bypass -File .\walkforward_generico.ps1 -Expert ABTG_PTE -DaQuando 2024.09.26
#
#  -BrokerPattern (14/08/2026): su QUALE terminale girare. Default "BCM",
#  cioe' esattamente quello che facevamo prima. Con un altro broker (demo
#  Pepperstone, che sugli indici ha gli anni che a BCM mancano) parte un
#  avviso rosso e i CSV escono col suffisso del broker, cosi' non si
#  mescolano mai ai nostri. PRIMA DI USARLO: gli orari degli EA sono in
#  ORA SERVER e vanno rimappati (docs\BROKER_ESTERNO_MAPPA.md), altrimenti
#  l'EA opera a un'ora che non c'entra niente con l'apertura di borsa.
#    powershell -ExecutionPolicy Bypass -File .\walkforward_generico.ps1 -Expert ABTG_ORB -BrokerPattern "Pepperstone" -Simbolo "GER40" -DaQuando 2018.01.01
#
#  -SoloControllo NON apre MT5: scarica, legge, controlla tutto e ti
#  fa vedere l'.ini che lancerebbe. Lancialo SEMPRE prima: costa dieci
#  secondi e ti dice quante celle sono, cioe' quante ore di macchina.
#
#  -PermettiCellaSingola (05/09/2026, classe 133): questo driver e' nato
#  per le GRIGLIE, e uno dei suoi controlli pretende almeno un parametro
#  spazzolato ("sarebbe un backtest singolo, non un walk-forward").
#  Esiste pero' una famiglia di round LEGITTIMA che di griglia non ne ha
#  nessuna: la CELLA CONGELATA, scelta in un round precedente e qui solo
#  MISURATA su due finestre indipendenti (R117 RELATIVO). Per quei round
#  il controllo non protegge niente e blocca tutto. Questo interruttore
#  salta QUEL controllo e SOLO quello, ed e' OPT-IN: senza, il
#  comportamento e' identico a sempre per ogni round gia' pinnato.
#  NON e' una scorciatoia per le griglie: se un asse Y c'e' ma e'
#  degenere, l'errore "sweep degenere" resta e ferma lo stesso.
#
#  >>> LEGGI QUESTO PRIMA DI USARLO -- CLASSE 134, MISURATA IL 05/09/2026
#  L'interruttore qui sopra toglie IL CARTELLO, NON IL MURO. La prima
#  corsa vera che l'ha usato (R117 RELATIVO, prova D30_PORTO, Modello 4)
#  e' uscita con codice 0, senza un errore da nessuna parte, e con i DUE
#  CSV DA ZERO BYTE. Motivo: questo driver scrive SEMPRE Optimization=1,
#  ma con tutti i parametri in forma v||v||0||v||N nessun input e'
#  marcato come ottimizzabile, quindi MT5 non ha nessuna combinazione da
#  eseguire e NON ESEGUE NESSUNA PASSATA. Su un EA che esporta i
#  risultati con FrameAdd/OnTesterDeinit (cioe' su TUTTI i nostri:
#  quel canale esiste solo in ottimizzazione) il file viene creato e
#  resta vuoto -- e' lo stesso muro del "sweep degenere" del 07/08.
#  QUINDI: se il tuo round non ha nessuna griglia nel merito, NON usare
#  questo flag. Metti un ASSE TECNICO A DUE CELLE su un parametro che
#  non tocca l'economia, tipicamente il magic:
#        InpMagic=774601||774601||50||774651||Y
#  E' quello che fanno R102, R103 e R116 da agosto, e i loro OPTFRAME
#  sono pieni. Le due passate sono identiche per costruzione, quindi la
#  seconda e' anche un gemello di determinismo gratis.
#  Il flag resta qui SOLO per il caso (finora mai visto in casa) di un
#  EA che scriva il suo CSV direttamente da OnTester/OnDeinit, senza
#  passare dai frame.
#
#  -TerminaleBacktest (08/09/2026, v4) -- PASSO 6 di report\QUARTO_MT5_PIANO.md
#  PERCHE' ESISTE, ED E' UN DIFETTO GIA' PAGATO, NON UNA PRECAUZIONE.
#  Fino a ieri il terminale lo sceglieva SOLO il ripiego del punto 7:
#  "prendi il primo terminal64.exe sotto Program Files la cui cartella
#  contiene 'BCM Markets', escludendo -V3 (il 100k) e BCM_Reale". Con TRE
#  installazioni quel filtro ne lasciava passare UNA, e il primo che
#  capitava era per forza quella giusta.
#  Il 07/09 sul VPS e' stato installato il QUARTO terminale, dedicato ai
#  backtest: C:\MT5_Backtest, conto demo 50504400 (HEDGING, zero EA
#  attaccati). Da quel momento il filtro ne lascia passare DUE -- il
#  terminale da backtest E IL PICCOLO 50503392, che ha 40 sedie vive e
#  posizioni aperte -- e "il primo che capita" diventa un'inferenza su
#  come Get-ChildItem ordina le cartelle. E' esattamente la CLASSE
#  37-QUATER, pagata il 07/09: un ripiego che sceglie il terminale
#  sbagliato e non lo dice.
#  Con questo parametro la cartella si NOMINA, e il driver muore se non
#  la trova o se non contiene terminal64.exe. E dall'11/09/2026 la
#  guardia su questo parametro e' POSITIVA: non elenca i vietati, AMMETTE
#  il solo banco C:\MT5_Backtest (demo 50504400) e uccide tutto il resto,
#  compreso cio' che non e' in nessuna lista e compreso cio' che nascera'
#  domani. Un bersaglio legittimo diverso dal banco si passa con
#  -Terminal, che e' il parametro nato per quello.
#  E da questa versione il terminale scelto viene sempre DICHIARATO
#  a schermo (percorso + da quale via), perche' il difetto che stiamo
#  chiudendo non e' scegliere male: e' scegliere in silenzio.
#  SENZA il parametro, dall'11/09/2026, IL DRIVER NON SI SCEGLIE PIU' UN
#  TERMINALE DA SOLO: sul broker BCM il ripiego valorizza lui stesso
#  questo parametro col BANCO C:\MT5_Backtest (demo 50504400) e passa
#  quindi dagli STESSI controlli di qui sotto; se il banco non c'e',
#  MUORE invece di spazzolare Program Files. Vedi il punto 7-ter.
#  Le righe di lancio gia' scritte non cambiano di una virgola nel TESTO
#  -- cambia DOVE atterrano sul VPS: il banco, non il piccolo 50503392.
#    powershell -ExecutionPolicy Bypass -File .\walkforward_generico.ps1 -Expert ABTG_ORB -TerminaleBacktest "C:\MT5_Backtest"
#
#  PERCHE' ESISTE LA v5 -- GLI #include NOSTRI (08/09/2026)
#  Il passo 7 (ancora R119 sul quarto MT5, C:\MT5_Backtest) e' fallito
#  alle 17:43 dell'08/09 cosi': "CSV OOS assente o non fresco" su TUTTE E
#  DUE le sedie, driver uscito con codice 1, ESITO "NON MISURATO -- ZERO
#  CSV letti". Fallimento IMMEDIATO, non dopo ore: quindi non era il
#  tester, era prima del tester.
#  La causa: questo driver scaricava e copiava SOLO mql5\Experts\<EA>.mq5.
#  Ma 69 EA su 153 hanno #include <ABTG_PausaGuardian.mqh> -- fra questi
#  ABTG_ORB_Ottimizzato (r.106) e ABTG_DAX_Apertura_EU (r.132), cioe'
#  ESATTAMENTE le due sedie dell'ancora. Sul PC di backtest quel file
#  stava nella cartella dati da mesi e nessuno se n'era accorto;
#  C:\MT5_Backtest e' un'installazione NUOVA E VUOTA, quindi metaeditor
#  non trovava l'include, non produceva l'.ex5, e il driver moriva su
#  "compilazione fallita" prima ancora di aprire MT5.
#  Da questa versione il driver porta anche gli #include NOSTRI in
#  <cartella dati>\MQL5\Include\, rispettando le sottocartelle del repo
#  (ABTG\ resta ABTG\), li DICHIARA a schermo uno per uno (un file
#  copiato in silenzio e' un'assunzione, non un fatto), e se la
#  compilazione fallisce lo stesso STAMPA LE ULTIME RIGHE DEL LOG DI
#  METAEDITOR invece del solo "compilazione fallita".
#  Gli #include di SISTEMA (<Trade/Trade.mqh>, <Trade\PositionInfo.mqh>,
#  <Trade\SymbolInfo.mqh>, <Trade\AccountInfo.mqh>) NON si copiano: li
#  ha gia' MT5 in ogni installazione. I NOSTRI sono tre, censiti col
#  grep sull'intero repo, e stanno nella lista $NostriInclude qui sotto.
#
#  COMPATIBILITA' DEI MARCATORI -- QUESTE RIGHE SONO VOLUTE, NON AVANZI.
#  Questo file contiene ANCORA, di proposito, le stringhe
#  MARCATORE_WALKFORWARD_GENERICO_v3_EXECMODE e
#  MARCATORE_WALKFORWARD_GENERICO_v4_TERMINALE_BACKTEST. Le righe di lancio gia'
#  scritte la cercano con Select-String -SimpleMatch per rifiutare le copie
#  vecchie del driver -- fra queste righe\RIGA_RITARDO_TESTER.ps1 (r.99 e
#  r.225), che e' esattamente la riga dell'ancora R119 del passo 7.
#  Togliendo quelle stringhe, quelle righe morirebbero dicendo "driver
#  vecchio" davanti a un driver PIU' NUOVO. Cio' che il marcatore v3
#  promette (il parametro -Ritardo, cioe' ExecutionMode nell'.ini) e cio'
#  che promette il v4 (il parametro -TerminaleBacktest) qui sono
#  invariati: le promesse sono ancora vere, quindi le stringhe restano.
#
#  12/09/2026 -- v6_FRAZIONEIS AGGIUNTO, NIENTE TOLTO. I MARCATORI SONO
#  ADDITIVI: il v6 promette che questo driver LEGGE la direttiva
#  '@FRAZIONEIS' dal file prova (blocco dopo @FINOA). Il v5_INCLUDE
#  RESTA: righe\RIGA_SOTTILE_ROUND.ps1 lo cerca con Select-String
#  -SimpleMatch e MORIREBBE dicendo "driver vecchio" davanti a un driver
#  PIU' NUOVO se lo togliessimo. Chi aggiunge un v7 fa la stessa cosa:
#  aggiunge una riga, non rinomina quelle di sopra.
# =====================================================================
param(
  [Parameter(Mandatory=$true,Position=0)][string]$Expert,   # nome del .mq5 senza estensione
  [string]$Simbolo   = "",           # se vuoto lo prende da @SIMBOLO nel file prova
  [string]$DaQuando  = "",           # inizio storico VERO, misurato
  [string]$Fino      = "2026.06.30",
  [string]$Periodo   = "",           # TF del grafico nel tester (@PERIODO nel file prova)
  [double]$FrazioneIS = 0.40,        # 40% dentro campione, 60% fuori
  [int]$Modello      = 4,            # 4 = tick reali (verita'). 1 = OHLC M1: SOLO screening, mai verdetti
  [switch]$FinoDallaRiga,            # 12/09/2026: dichiara che -Fino VINCE su '@FINOA'.
                                     #   Senza, le due date che si contraddicono fanno MORIRE la corsa.
                                     #   Serve a chi misura APPOSTA una finestra diversa da quella
                                     #   del file prova (unico caso in casa: RIGA_DIAG_GBPUSD.ps1
                                     #   -Passo C, che misura un TEMPO, non un orologio).
  [switch]$FrazioneDallaRiga,        # 12/09/2026: dichiara che -FrazioneIS VINCE su '@FRAZIONEIS'.
                                     #   Senza, i due tagli che si contraddicono fanno MORIRE la corsa.
                                     #   Stessa ragione di -FinoDallaRiga: il taglio IS/OOS fa parte
                                     #   dell'IDENTITA' della cella, non e' un default comodo.
  [int]$Deposito     = 10000,        # deposito del tester. 100000 = taglia prop: serve dove il lotto minimo schiaccia il rischio
  [string]$Etichetta = "",           # suffisso nei nomi dei CSV: un round nuovo NON sovrascrive il precedente
  [int]$Spread       = -1,           # 19/08/2026 (R84-bis, stress spread). -1 = NON scrive la riga
                                     #   Spread nell'.ini = comportamento identico a sempre.
                                     #    0 = spread CORRENTE, scritto esplicito (toglie lo stato
                                     #        nascosto: fino a oggi nessun .ini di questa casa
                                     #        dichiarava lo spread usato, e nessuno lo sapeva).
                                     #    N = spread FISSO di N punti (stress).
                                     #   ATTENZIONE, NON MISURATO: a Modello 4 (tick reali) MT5
                                     #   prende bid/ask dai tick e non e' detto che onori questa
                                     #   riga. Prima di leggere una scala di stress serve il
                                     #   canarino: stesso EA con uno spread ASSURDO deve dare
                                     #   numeri DIVERSI. Se sono identici, la riga e' ignorata e
                                     #   la scala a tick reali NON E' ESEGUIBILE (va dichiarato,
                                     #   non interpretato come "robusto allo spread").
  [int]$Ritardo      = -999,         # 07/09/2026 (R119). RITARDO DI ESECUZIONE del tester.
                                     #   -999 (default) = non passato: l'.ini esce con
                                     #        ExecutionMode=0, IDENTICO a sempre.
                                     #     -1 = ritardo CASUALE
                                     #      0 = normale, zero ritardo (uguale al default)
                                     #  1..600000 = ritardo in MILLISECONDI
                                     #
                                     #   >>> LA CHIAVE E' ExecutionMode, NON "Delay". MISURATO IL
                                     #       07/09/2026, SBAGLIANDO (classe 156): la prima stesura
                                     #       di questo parametro scriveva una riga "Delay=500" e
                                     #       il canarino del round R119 ha trovato i CSV a 0 ms e
                                     #       a 500 ms IDENTICI BYTE PER BYTE. MT5 ignora IN
                                     #       SILENZIO le chiavi .ini che non conosce: un nome
                                     #       plausibile ma inventato non da' nessun errore, da'
                                     #       un round che sembra girato e non e' girato.
                                     #   >>> E ATTENZIONE A COSA VUOL DIRE: questo driver scriveva
                                     #       GIA' ExecutionMode=0 in tutti i round dal 07/08. Non
                                     #       era uno stato nascosto: era zero ritardo DICHIARATO
                                     #       nell'.ini, che nessun referto pero' ha mai letto.
  [string]$Prova     = "",           # file prova alternativo (default: prove\<EA>.txt)
  [string]$BrokerPattern = "BCM",    # SU QUALE TERMINALE girare. "BCM" = come sempre.
                                     #   Altro valore (es. "Pepperstone") = secondo
                                     #   broker: vedi l'avviso rosso qui sotto.
  [string]$TerminaleBacktest = "",   # 08/09/2026 (v4): CARTELLA PROGRAMMA del terminale
                                     #   da usare, nominata a mano. Es. "C:\MT5_Backtest"
                                     #   (VPS, conto demo 50504400, zero EA attaccati).
                                     #   Se passato si usa QUELLO E SOLO QUELLO: niente
                                     #   ripiego, niente inferenza sull'ordine delle
                                     #   cartelle. Muore se la cartella non esiste, se non
                                     #   contiene terminal64.exe, o -- dall'11/09/2026 --
                                     #   se NON E' IL BANCO: la guardia e' POSITIVA e ammette
                                     #   il solo C:\MT5_Backtest. Per un bersaglio legittimo
                                     #   diverso (altro broker, PC di casa) c'e' -Terminal.
                                     #   Vuoto (default) = dall'11/09/2026 ce lo mette il
                                     #   DRIVER STESSO, col banco, se il banco c'e'. Se non
                                     #   c'e', il round MUORE: niente piu' ripiego che si
                                     #   sceglie un terminale fra quelli di Program Files.
  [switch]$SoloControllo,            # controlla e stampa l'ini, NON lancia MT5
  [switch]$PermettiCellaSingola,     # round a CELLA CONGELATA (zero assi Y): salta SOLO
                                     #   il controllo "nessun parametro da spazzolare".
                                     #   Default spento = comportamento di sempre.
  [switch]$Rifai,
  [switch]$UseSpare,[string]$Terminal="",[string]$MetaEditor="",[string]$DataFolder="",[switch]$Force
)
$ErrorActionPreference="Stop"
[Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12
$EABranch="lavoro"
$RawBase="https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$EABranch"
$Work= if($PSScriptRoot){$PSScriptRoot}else{(Get-Location).Path}; Set-Location $Work

function Titolo($t){ Write-Host ""; Write-Host $t -ForegroundColor Cyan }
function Muori($t){ Write-Host ""; Write-Host "!!! $t" -ForegroundColor Red; exit 1 }

Write-Host "=== WALK-FORWARD GENERICO - $Expert ===" -ForegroundColor Cyan
Write-Host "    MARCATORE_WALKFORWARD_GENERICO_v5_INCLUDE" -ForegroundColor DarkGray
Write-Host "    MARCATORE_WALKFORWARD_GENERICO_v6_FRAZIONEIS" -ForegroundColor DarkGray

# =====================================================================
#  0. SU QUALE BROKER SI STA GIRANDO
#  Default "BCM" = comportamento identico a sempre. Con un altro broker
#  (14/08: demo Pepperstone, che sugli indici ha lo storico che a BCM
#  manca) cambiano DUE cose e vanno dette PRIMA, non dopo.
# =====================================================================
$BrokerBCM  = ($BrokerPattern -match '^(?i)bcm$')
$SuffBroker = ""
if(-not $BrokerBCM){
  $SuffBroker = "_" + ($BrokerPattern -replace '[^A-Za-z0-9]','').ToLower()
  Write-Host ""
  Write-Host "#####################################################################" -ForegroundColor Red
  Write-Host "#  ATTENZIONE: NON stai girando su BCM, ma su '$BrokerPattern'." -ForegroundColor Red
  Write-Host "#####################################################################" -ForegroundColor Red
  Write-Host "#  1) GLI ORARI DEGLI EA SONO IN ORA SERVER, E VANNO RIMAPPATI." -ForegroundColor Red
  Write-Host "#     DAX InpSessionHour=8, apertura USA 14:30, box notturno 23:00," -ForegroundColor Red
  Write-Host "#     fascia 8-18 dell'EasyTrend: sono ore del server BCM. Un altro" -ForegroundColor Red
  Write-Host "#     broker ha un altro offset (e un altro calendario di ora legale)." -ForegroundColor Red
  Write-Host "#     Se non li rimappi, l'EA opera a un'ora che non c'entra niente" -ForegroundColor Red
  Write-Host "#     con l'apertura di borsa: IL VERDETTO E' SPAZZATURA." -ForegroundColor Red
  Write-Host "#     La formula e la tabella dei valori nuovi le stampa:" -ForegroundColor Red
  Write-Host "#        prepara_broker_esterno.ps1 -BrokerPattern `"$BrokerPattern`" -SoloReferto" -ForegroundColor Yellow
  Write-Host "#     e stanno in docs\BROKER_ESTERNO_MAPPA.md (sezione FUSO)." -ForegroundColor Red
  Write-Host "#" -ForegroundColor Red
  Write-Host "#  2) QUESTI RISULTATI NON SI CONFRONTANO CON QUELLI BCM." -ForegroundColor Red
  Write-Host "#     Spread, commissioni e composizione del feed sono diversi: il" -ForegroundColor Red
  Write-Host "#     confronto ASSOLUTO fra feed non significa niente. Vale solo il" -ForegroundColor Red
  Write-Host "#     confronto RELATIVO DENTRO LO STESSO FEED (periodo calante vs" -ForegroundColor Red
  Write-Host "#     crescente sui dati di questo broker) - criterio congelato al" -ForegroundColor Red
  Write-Host "#     punto 2 di prove\PROVA_REGIME_CRITERI.md." -ForegroundColor Red
  Write-Host "#     E i parametri NON si ritarano qui: la taratura resta su BCM." -ForegroundColor Red
  Write-Host "#####################################################################" -ForegroundColor Red
  Write-Host ""
  Write-Host "    (i CSV usciranno con il suffisso '$SuffBroker': non sovrascrivono mai i nostri)" -ForegroundColor Yellow
}

# =====================================================================
#  1. IL SORGENTE
# =====================================================================
$SrcDir=Join-Path $Work "src_prove"
New-Item -ItemType Directory -Force -Path $SrcDir | Out-Null
$srcFile=Join-Path $SrcDir "$Expert.mq5"
try{ Invoke-WebRequest -Uri "$RawBase/mql5/Experts/$Expert.mq5" -OutFile $srcFile -UseBasicParsing }
catch{
  if(-not (Test-Path $srcFile)){
    Muori ("non trovo l'EA '$Expert'. Il nome deve essere quello del file .mq5 SENZA estensione,`n" +
           "    e maiuscole/minuscole contano: es. ABTG_PTE, ABTG_DAX_Apertura_EU.")
  }
  Write-Host "    (download fallito: uso la copia locale gia' scaricata)" -ForegroundColor Yellow
}
$src=Get-Content $srcFile -Raw
Write-Host ("    sorgente: {0} righe" -f (($src -split "`n").Count)) -ForegroundColor DarkGray

# --- 1-bis. GLI #include NOSTRI (v5, 08/09/2026)
#  Censiti col grep su TUTTO il repo (mql5\Experts\*.mq5 + mql5\Include):
#    110 + 12  #include <Trade/Trade.mqh> e <Trade\Trade.mqh>   -> DI SISTEMA
#      3       <Trade\PositionInfo|SymbolInfo|AccountInfo.mqh>  -> DI SISTEMA
#     69       #include <ABTG_PausaGuardian.mqh>                 -> NOSTRO
#  Nessun altro. ABTG\ABTG_ApertureCore.mqh e OptFrame.mqh stanno nel
#  repo ma OGGI nessun .mq5 li include (dentro gli EA quel codice e'
#  copiato in linea): si portano lo stesso, costano un download e
#  coprono il giorno in cui un EA tornera' a includerli. Il campo Serve
#  dice chi e' indispensabile: se manca QUELLO, si muore qui invece di
#  morire piu' avanti su un "compilazione fallita" che non spiega niente.
$NostriInclude=@(
  @{ Rel="ABTG_PausaGuardian.mqh";     Serve=$true;  Nota="69 EA lo includono (ORB e DAX dell'ancora compresi)" },
  @{ Rel="ABTG/ABTG_ApertureCore.mqh"; Serve=$false; Nota="nel repo, oggi nessun #include" },
  @{ Rel="OptFrame.mqh";               Serve=$false; Nota="nel repo, oggi nessun #include" }
)
$IncDir=Join-Path $Work "src_include"
New-Item -ItemType Directory -Force -Path $IncDir | Out-Null
$IncPronti=@()
foreach($inc in $NostriInclude){
  $rel=$inc.Rel
  $relWin=$rel.Replace("/","\")
  $dst=Join-Path $IncDir $relWin
  $dstDir=Split-Path -Parent $dst
  New-Item -ItemType Directory -Force -Path $dstDir | Out-Null
  # stesso schema di ripiego del sorgente (r.245): si prova a scaricare,
  # e se la rete non c'e' si usa la copia gia' scaricata prima.
  try{ Invoke-WebRequest -Uri "$RawBase/mql5/Include/$rel" -OutFile $dst -UseBasicParsing }
  catch{
    if(Test-Path $dst){ Write-Host "    (download fallito per $rel : uso la copia locale gia' scaricata)" -ForegroundColor Yellow }
    elseif($inc.Serve){
      Muori ("non riesco a scaricare l'include NOSTRO '$rel' e non ne ho una copia locale.`n" +
             "    Senza quel file l'EA non compila: 69 EA su 153 hanno #include <ABTG_PausaGuardian.mqh>.`n" +
             "    URL provata: $RawBase/mql5/Include/$rel")
    }
    else{ Write-Host "    (download fallito per $rel : non e' incluso da nessun EA, tiro dritto)" -ForegroundColor DarkYellow; continue }
  }
  if(Test-Path $dst){ $IncPronti += @{ Rel=$relWin; File=$dst; Nota=$inc.Nota } }
}
Write-Host ("    include nostri pronti: {0} su {1}" -f $IncPronti.Count,$NostriInclude.Count) -ForegroundColor DarkGray

# --- l'EA esporta i risultati? senza OnTester non c'e' niente da leggere.
#  Il 07/08 scheda_ea.py ha contato 39 EA su 61 che esportano: gli altri
#  22 NON sono testabili con questa pipeline, e va detto subito, non
#  dopo una notte di macchina.
if($src -notmatch 'double\s+OnTester\s*\('){
  Muori ("$Expert NON esporta i risultati (manca OnTester).`n" +
         "    MT5 girerebbe lo stesso, ma non produrrebbe nessun CSV da leggere.`n" +
         "    Va aggiunto il blocco OnTester all'EA prima di poterlo misurare.")
}

# =====================================================================
#  2. #define, enum, input: letti dal codice, non dichiarati a mano
# =====================================================================
#  ATTENZIONE: vince la PRIMA definizione di un #define, non l'ultima: quelle in
#  fondo stanno dentro un #ifndef e sono il ripiego generico. Prendendo
#  l'ultima, il 07/08 nove EA d'apertura risultavano con lo stesso magic
#  e usciva un falso allarme.
$Defines=@{}
foreach($m in [regex]::Matches($src,'(?m)^\s*#define\s+(\w+)\s+([^\r\n/]+)')){
  $n=$m.Groups[1].Value; $v=$m.Groups[2].Value.Trim()
  if(-not $Defines.ContainsKey($n)){ $Defines[$n]=$v }
}

# --- enum: valore di ogni membro, e i membri IN ORDINE per ogni enum.
#  L'ordine serve per contare le celle: MT5 spazzola i membri fra start
#  e stop, quindi il numero di celle dipende da QUANTI membri ci sono
#  in mezzo, non dallo step.
$EnumVal=@{}          # NOME_MEMBRO -> valore
$EnumMembri=@{}       # NOME_ENUM   -> lista ordinata dei valori
foreach($m in [regex]::Matches($src,'(?s)enum\s+(\w+)\s*\{(.*?)\}')){
  $nomeEnum=$m.Groups[1].Value
  $corpo=$m.Groups[2].Value
  $corpo=[regex]::Replace($corpo,'(?s)/\*.*?\*/','')
  $corpo=[regex]::Replace($corpo,'//[^\r\n]*','')
  $prossimo=0
  $lista=New-Object System.Collections.ArrayList
  foreach($pezzo in ($corpo -split ',')){
    $p=$pezzo.Trim()
    if($p -eq ""){ continue }
    if($p -match '^(\w+)\s*=\s*(-?\d+)'){ $mn=$Matches[1]; $mv=[int]$Matches[2] }
    elseif($p -match '^(\w+)'){ $mn=$Matches[1]; $mv=$prossimo }
    else { continue }
    $prossimo=$mv+1
    $EnumVal[$mn]="$mv"
    [void]$lista.Add($mv)
  }
  if($lista.Count -gt 0){ $EnumMembri[$nomeEnum]=$lista }
}

# --- gli enum di MT5 non stanno nel sorgente: li mettiamo noi.
$TF=[ordered]@{ PERIOD_CURRENT=0; PERIOD_M1=1; PERIOD_M2=2; PERIOD_M3=3; PERIOD_M4=4
  PERIOD_M5=5; PERIOD_M6=6; PERIOD_M10=10; PERIOD_M12=12; PERIOD_M15=15; PERIOD_M20=20
  PERIOD_M30=30; PERIOD_H1=16385; PERIOD_H2=16386; PERIOD_H3=16387; PERIOD_H4=16388
  PERIOD_H6=16390; PERIOD_H8=16392; PERIOD_H12=16396; PERIOD_D1=16408; PERIOD_W1=32769
  PERIOD_MN1=49153 }
$listaTF=New-Object System.Collections.ArrayList
foreach($k in $TF.Keys){ $EnumVal[$k]="$($TF[$k])"; if($TF[$k] -gt 0){ [void]$listaTF.Add($TF[$k]) } }
$EnumMembri["ENUM_TIMEFRAMES"]=($listaTF | Sort-Object)
foreach($kv in @{ MODE_SMA=0; MODE_EMA=1; MODE_SMMA=2; MODE_LWMA=3 }.GetEnumerator()){ $EnumVal[$kv.Key]="$($kv.Value)" }
$EnumMembri["ENUM_MA_METHOD"]=@(0,1,2,3)
foreach($kv in @{ PRICE_CLOSE=1; PRICE_OPEN=2; PRICE_HIGH=3; PRICE_LOW=4
                  PRICE_MEDIAN=5; PRICE_TYPICAL=6; PRICE_WEIGHTED=7 }.GetEnumerator()){ $EnumVal[$kv.Key]="$($kv.Value)" }
$EnumMembri["ENUM_APPLIED_PRICE"]=@(1,2,3,4,5,6,7)
foreach($kv in @{ CALENDAR_IMPORTANCE_NONE=0; CALENDAR_IMPORTANCE_LOW=1
                  CALENDAR_IMPORTANCE_MODERATE=2; CALENDAR_IMPORTANCE_HIGH=3 }.GetEnumerator()){ $EnumVal[$kv.Key]="$($kv.Value)" }
$EnumMembri["ENUM_CALENDAR_EVENT_IMPORTANCE"]=@(0,1,2,3)

function Risolvi([string]$grezzo){
  # da "PERIOD_H4" / "true" / "ABTG_DEF_RANGE 35" al numero che MT5 vuole.
  $t=$grezzo
  $t=[regex]::Replace($t,'//.*$','')
  $t=$t.Trim().TrimEnd(';').Trim()
  # cast alla C: "(ENUM_ABTG_RANGE)ABTG_DEF_RANGE_MODE". Senza toglierlo
  # restavano fuori proprio RangeMode e TrailMode delle nove aperture,
  # cioe' i due parametri su cui abbiamo passato la notte del 07/08.
  $t=[regex]::Replace($t,'^\(\s*[A-Za-z_]\w*\s*\)\s*','').Trim()
  $apice=[char]34
  if($t.StartsWith($apice)){ return @{ ok=$true; tipo="stringa"; val=$t.Trim($apice) } }
  if($t -ieq "true" ){ return @{ ok=$true; tipo="num"; val="1" } }
  if($t -ieq "false"){ return @{ ok=$true; tipo="num"; val="0" } }
  if($t -match '^-?\d+(\.\d+)?$'){ return @{ ok=$true; tipo="num"; val=$t } }
  # un identificatore solo: #define oppure membro di enum. Due giri, perche'
  # un #define puo' puntare a un altro #define.
  for($giro=0; $giro -lt 3; $giro++){
    if($t -notmatch '^[A-Za-z_]\w*$'){ break }
    if($Defines.ContainsKey($t)){ $t=$Defines[$t].Trim(); continue }
    if($EnumVal.ContainsKey($t)){ return @{ ok=$true; tipo="num"; val=$EnumVal[$t] } }
    break
  }
  if($t -match '^-?\d+(\.\d+)?$'){ return @{ ok=$true; tipo="num"; val=$t } }
  if($t -ieq "true" ){ return @{ ok=$true; tipo="num"; val="1" } }
  if($t -ieq "false"){ return @{ ok=$true; tipo="num"; val="0" } }
  return @{ ok=$false; tipo="?"; val=$t }
}

# --- gli input. "input group" non ha l'uguale e non entra.
$Inputs=New-Object System.Collections.ArrayList     # @{ nome; tipo; val; ok }
$NonRisolti=New-Object System.Collections.ArrayList
foreach($m in [regex]::Matches($src,'(?m)^\s*s?input\s+([A-Za-z_]\w*)\s+([A-Za-z_]\w*)\s*=\s*(.+)$')){
  $tipo=$m.Groups[1].Value; $nome=$m.Groups[2].Value
  $r=Risolvi $m.Groups[3].Value
  [void]$Inputs.Add(@{ nome=$nome; tipo=$tipo; val=$r.val; ok=$r.ok; kind=$r.tipo })
  if(-not $r.ok){ [void]$NonRisolti.Add("$nome = $($r.val)") }
}
if($Inputs.Count -eq 0){ Muori "non ho trovato nessun 'input' nel sorgente: il formato non e' quello che mi aspetto." }

$NomiInput=@{}
foreach($i in $Inputs){ $NomiInput[$i.nome]=$i }
$TipoDi=@{}
foreach($i in $Inputs){ $TipoDi[$i.nome]=$i.tipo }

Write-Host ("    input trovati: {0}   (blindati al default: {1})" -f $Inputs.Count, (@($Inputs|Where-Object{$_.ok}).Count)) -ForegroundColor DarkGray
if($NonRisolti.Count -gt 0){
  Write-Host "    NON blindati (MT5 usera' il default compilato, che e' lo stesso valore):" -ForegroundColor DarkYellow
  foreach($n in $NonRisolti){ Write-Host "        $n" -ForegroundColor DarkYellow }
}

# =====================================================================
#  3. IL FILE PROVA: ipotesi, criteri, sweep
# =====================================================================
$ProvaFile= if($Prova){ $Prova } else { Join-Path $Work "prove\$Expert.txt" }
if((-not (Test-Path $ProvaFile)) -and $Prova){ Muori "il file prova che mi hai passato non esiste: $Prova" }
if(-not (Test-Path $ProvaFile)){
  New-Item -ItemType Directory -Force -Path (Join-Path $Work "prove") | Out-Null
  try{ Invoke-WebRequest -Uri "$RawBase/backtest_pipeline/prove/$Expert.txt" -OutFile $ProvaFile -UseBasicParsing }
  catch{
    Muori ("manca il file della prova: prove\$Expert.txt`n" +
           "    Dentro ci vanno TRE cose, in quest'ordine:`n" +
           "      1. l'IPOTESI, in italiano: perche' ci aspettiamo che quel parametro conti`n" +
           "      2. i CRITERI DI ACCETTAZIONE, scritti PRIMA di vedere i numeri`n" +
           "      3. le righe da spazzolare:  Nome=default||start||step||stop||Y`n" +
           "    Tutto il resto viene blindato da solo. Il formato e' in prove\LEGGIMI.md.")
  }
}
$righeProva=Get-Content $ProvaFile

$Direttive=@{}
$RigheProvaUtili=New-Object System.Collections.ArrayList
foreach($r in $righeProva){
  $t=$r.Trim()
  if($t -eq "" ){ continue }
  if($t.StartsWith("#")){ continue }
  if($t.StartsWith("@")){
    if($t -match '^@(\w+)\s+(.+)$'){ $Direttive[$Matches[1].ToUpper()]=$Matches[2].Trim() }
    continue
  }
  if($t -match "="){ [void]$RigheProvaUtili.Add($t) }
}
if($RigheProvaUtili.Count -eq 0){ Muori "in prove\$Expert.txt non c'e' nessuna riga di parametri (Nome=...)." }

if(-not $Simbolo  -and $Direttive.ContainsKey("SIMBOLO")){  $Simbolo =$Direttive["SIMBOLO"] }
if(-not $Periodo  -and $Direttive.ContainsKey("PERIODO")){  $Periodo =$Direttive["PERIODO"] }
if(-not $DaQuando -and $Direttive.ContainsKey("DAQUANDO")){ $DaQuando=$Direttive["DAQUANDO"] }

# ---------------------------------------------------------------------
#  @FINOA -- CHIUSA IL 12/09/2026, ED ERA UNA TRAPPOLA SILENZIOSA.
#  Il tag @FINOA nasce in R113 (finestre di regime: la data di FINE fa
#  parte dell'identita' della cella, non e' un default). Da allora sta in
#  111 file prova, 44 dei quali con una data DIVERSA da quella di
#  fabbrica qui sopra ($Fino = 2026.06.30).
#  Questo driver lo leggeva -- finisce in $Direttive come tutti gli altri
#  -- e poi NON LO USAVA MAI. Cioe': un file prova poteva dichiarare
#  "finestra fino al 2012.12.31" e il tester girava fino al 2026.06.30
#  senza dire niente a nessuno. Il verdetto sarebbe uscito su un'altra
#  finestra, con l'etichetta di quella giusta.
#  DANNO MISURATO: UNO, ed e' DICHIARATO. Al primo giro avevo scritto
#  "NESSUNO", e mi sbagliavo per un difetto di metodo, non di codice:
#  avevo censito i FILE PROVA con '@FINOA' non-default, ma la divergenza
#  si crea da DUE lati, e il secondo e' il CHIAMANTE che passa -Fino
#  apposta. Il caso vero, unico su tutto il repo:
#  RIGA_DIAG_GBPUSD.ps1 -Passo C passa -Fino 2013.01.01 su un file prova
#  che dichiara @FINOA 2026.06.30, DI PROPOSITO ("qui si misura un TEMPO,
#  non un orologio"). Per lui esiste -FinoDallaRiga, qui sotto.
#  Gli altri 44 file con la data diversa NON passano di qui:
#    - i 18 R113_F* usano RIGA_R113_REGIME_NASUSD.ps1, che si scrive gli
#      .ini da solo (r.54-55: "NIENTE walkforward_generico") e confronta
#      @FINOA con la tabella congelata dei criteri (r.893-894);
#    - i POSTNEWS_ORO passano -Fino a mano nella loro riga di lancio;
#    - gli altri hanno ciascuno il proprio script dedicato fra i 33 che
#      leggono @FINOA.
#  Quindi qui non si ripara un danno: si chiude la porta PRIMA che il
#  prossimo file prova ci entri.
#  DUE COMPORTAMENTI, e sono diversi apposta:
#    a) -Fino NON passato a mano  -> @FINOA VINCE (e' l'identita' della
#       cella, scritta nel file da chi l'ha pensata);
#    b) -Fino passato a mano E diverso da @FINOA -> SI MUORE. Non si
#       sceglie per conto di chi ha scritto la riga: le due fonti si
#       contraddicono e la contraddizione va vista, non risolta di
#       nascosto.
#  I 67 file con @FINOA 2026.06.30 non cambiano comportamento: la data
#  che vince e' identica a quella di fabbrica.
# ---------------------------------------------------------------------
if($Direttive.ContainsKey("FINOA")){
  $finoDaFile = $Direttive["FINOA"]
  if($finoDaFile -notmatch '^[0-9]{4}\.[0-9]{2}\.[0-9]{2}$'){
    Muori ("la direttiva '@FINOA " + $finoDaFile + "' non e' una data aaaa.mm.gg.")
  }
  if($PSBoundParameters.ContainsKey("Fino")){
    if($Fino -ne $finoDaFile){
      if($FinoDallaRiga){
        # DIVERGENZA DICHIARATA. Non e' un'eccezione comoda: e' una firma.
        # Chi lancia ha scritto -FinoDallaRiga, cioe' "lo so, la sto
        # cambiando apposta". E siccome un avviso dentro mille righe di log
        # non lo legge nessuno, esce a banda larga: riquadro pieno, magenta,
        # con le DUE date accanto. (12/09: qui c'era scritto "e si RIPETE piu'
        # sotto" -- NON si ripete, esce una volta sola. Frase falsa dentro byte
        # inchiodati da un pin: corretta appena trovata.)
        Write-Host ""
        Write-Host "*********************************************************************" -ForegroundColor Magenta
        Write-Host "  ATTENZIONE: LA FINESTRA NON E' QUELLA DEL FILE PROVA." -ForegroundColor Magenta
        Write-Host ("    '@FINOA' nel file    : " + $finoDaFile) -ForegroundColor Magenta
        Write-Host ("    -Fino usato DAVVERO  : " + $Fino) -ForegroundColor Magenta
        Write-Host "  Vince la riga di lancio perche' e' stato passato -FinoDallaRiga." -ForegroundColor Magenta
        Write-Host "  I numeri che escono NON descrivono la cella del file prova." -ForegroundColor Magenta
        Write-Host "*********************************************************************" -ForegroundColor Magenta
        Write-Host ""
      } else {
        Muori ("DUE DATE DI FINE, DIVERSE, E NON SCELGO IO.`n" +
               "    -Fino passato a mano : " + $Fino + "`n" +
               "    '@FINOA' nel file    : " + $finoDaFile + "`n" +
               "    Il file prova dice che la finestra finisce in una data, la riga`n" +
               "    di lancio ne dice un'altra. Una delle due e' sbagliata: si`n" +
               "    guarda QUALE, non si esegue la piu' comoda.`n" +
               "    Se la differenza e' VOLUTA, si dichiara: aggiungi -FinoDallaRiga.")
      }
    }
  } else {
    $Fino = $finoDaFile
    Write-Host ("    finestra di fine presa da '@FINOA' nel file prova: " + $Fino) -ForegroundColor Yellow
  }
}

# ---------------------------------------------------------------------
#  @FRAZIONEIS -- APERTA IL 12/09/2026. E NON E' UNA COMODITA':
#  E' L'ULTIMO PEZZO DELL'IDENTITA' DELLA CELLA CHE NON AVEVA UN CANALE.
#
#  IL PROBLEMA, MISURATO. Venti file prova (R128b/c/d/e, R129a/b/c,
#  R130a..e, R131a..h) dichiarano nei propri criteri -- congelati PRIMA
#  dei numeri, in prove\R128_USCITA_CRITERI.md r.236-271 -- un taglio
#  IS/OOS a 0.50, e ciascuno porta il conto scritto: sui 325 ingressi
#  misurati da R120 sulla finestra 2024.09.26-2026.06.30, a 0.50 l'IS
#  vale ~163 operazioni e l'OOS ~162 (SOPRA il pavimento 150
#  dell'Emendamento A), mentre a 0.40 l'IS scende a ~130, cioe' SOTTO.
#  Ma la corsia ROUND (righe\RIGA_ROUND_VPS.ps1 r.646-650 e
#  righe\RIGA_SOTTILE_ROUND.ps1) NON PASSA -FrazioneIS: passa solo
#  -Expert -Prova -Etichetta -Modello -Deposito. Cioe' su quella corsia
#  le direttive del file prova sono l'UNICO canale esistente per
#  l'identita' della finestra -- ed erano quattro (@SIMBOLO, @PERIODO,
#  @DAQUANDO, @FINOA) su cinque. Il taglio IS/OOS era il buco.
#  Senza questa direttiva quei venti round girano a 0.40 (il default di
#  fabbrica qui sopra) con l'etichetta dei criteri a 0.50: IS che finisce
#  il 2025.06.09 invece del 2025.08.13, cioe' 65 giorni di calendario,
#  47 feriali, ~33 operazioni di differenza -- IN SILENZIO.
#
#  >>> PERCHE' QUESTO BLOCCO COPIA @FINOA E **NON** @SIMBOLO. <<<
#  E' LA TRAPPOLA, ED E' STATA MISURATA CON POWERSHELL VERO, NON
#  RAGIONATA. La riga "ovvia", per analogia con r.493-495, sarebbe:
#      if(-not $FrazioneIS -and $Direttive.ContainsKey("FRAZIONEIS")){ ... }
#  e NON FUNZIONA MAI. In PowerShell (-not 0.40) vale False: un [double]
#  con default 0.40 e' sempre "vero", quindi la condizione e' sempre
#  falsa e la direttiva NON VIENE MAI LETTA. I venti file girerebbero a
#  0.40, cioe' ESATTAMENTE il guasto che la direttiva ripara, travestito
#  da riparazione, e senza una riga di avviso a schermo.
#  E peggio: (-not 0.0) vale True, quindi con -FrazioneIS 0 la logica si
#  INVERTE e la direttiva scatta proprio dove non deve.
#  Lo schema di @SIMBOLO funziona SOLO perche' quei tre sono [string] con
#  default "" -- cioe' "falso" quando non passati. Su un numero no.
#  Qui la guardia interroga $PSBoundParameters.ContainsKey("FrazioneIS"),
#  che risponde a "l'argomento e' stato PASSATO?", non a "il suo valore
#  e' VERO?". E' la stessa chiave usata da @FINOA (r.559).
#
#  >>> E PERCHE' LA COLLISIONE MUORE INVECE DI SCEGLIERE. <<<
#  35 script dedicati passano -FrazioneIS SEMPRE ed esplicitamente. Due
#  lo passano a 1.0 (righe\RIGA_NYRETEST_TAR.ps1 r.307 e
#  righe\RIGA_SONDALONDONFX.ps1 r.604) e SCRIVONO NEL PROPRIO REFERTO
#  "UNA TRANCHE, FrazioneIS 1.0" e "il CSV *_OOS NON esiste MAI qui".
#  Se la regola fosse "vince il file" e un giorno il loro file prova
#  prendesse @FRAZIONEIS 0.50, il driver girerebbe un walk-forward 50/50
#  mentre il referto continua a dichiarare 1.0 e a chiamare i CSV _OOS
#  "reperti da non leggere" -- e invece sarebbero l'unico numero vero.
#  Referto e numeri direbbero due cose diverse, e nessuno lo vedrebbe.
#  Quindi: contraddizione = si MUORE. Chi la vuole apposta la DICHIARA
#  con -FrazioneDallaRiga, e si becca il riquadro magenta.
#
#  DUE MESSAGGI DISTINTI SULLA VALIDAZIONE, ed e' un difetto corretto,
#  non un vezzo: la prima stesura faceva morire '@FRAZIONEIS 1.5' con
#  "non e' un numero decimale" -- e 1.5 E' un numero decimale, e' solo
#  fuori campo. Un messaggio falso manda a cercare il guasto dalla parte
#  sbagliata. Adesso il FORMATO e il CAMPO dicono cose diverse.
#
#  [double]::Parse con InvariantCulture, NON [double]$testo: su un VPS
#  con locale italiana il cast sulla cultura corrente puo' leggere "0.50"
#  come 50. Il cancello controlla_riga.py ha una regola apposta.
#
#  ZERO REGRESSIONE, e non e' un'opinione: chi non scrive @FRAZIONEIS
#  non cambia comportamento di una virgola, e il 12/09 la direttiva non
#  compariva in NESSUNO dei file prova del repo (verificato col grep).
# ---------------------------------------------------------------------
#  >>> LA DIRETTIVA SCRITTA SENZA VALORE: UN BUCO TROVATO PROVANDO A
#      ROMPERE QUESTA STESSA TOPPA, IL 12/09/2026. <<<
#  Il parser generico di r.493 accetta solo '^@(\w+)\s+(.+)$': una riga
#  '@FRAZIONEIS' SENZA valore NON matcha, quindi non entra in $Direttive
#  e il blocco qui sotto non scatta nemmeno. Risultato: il file CREDE di
#  aver dichiarato un taglio, il driver gira col default 0.40, e NON DICE
#  NIENTE. E' lo stesso guasto silenzioso che questa direttiva ripara,
#  entrato dalla porta di servizio.
#  MISURATO che il buco NON e' mio ma del parser, ed e' CONDIVISO: con
#  '@FINOA' scritta da sola, oggi, il driver tira dritto sulla data di
#  fabbrica senza una riga di avviso (provato, exit 0). Su @SIMBOLO,
#  @PERIODO e @DAQUANDO il silenzio lo intercetta il cancello di r.574-579
#  ('if(-not $Simbolo){ Muori ... }'): quei tre hanno default "" e muoiono
#  dopo. @FINOA e @FRAZIONEIS hanno un default VALIDO, quindi no.
#  QUI chiudo SOLO il mio: la riparazione giusta sta nel parser e vale per
#  tutte e cinque le direttive, ma il parser e' inchiodato al byte da un
#  pin e lo toccherebbe per 1969 righe '@' su 675 file prova -- fra cui
#  CINQUE che portano un '@DAQUANDO' senza valore (ABTG_BandFade,
#  ABTG_CanaleLento, ABTG_RangeBudget, ABTG_TurnaroundTuesday,
#  SESSIONREOPEN_ORO_BOZZA). Quelli oggi muoiono comunque sul cancello di
#  r.574-579, ma una riga di lancio che passi -DaQuando a mano li fa
#  girare: cambiare il parser cambierebbe il comportamento di quei cinque,
#  e va misurato in un lavoro suo. Dichiarato, non fatto di nascosto.
#  QUESTA guardia invece e' un NO-OP DIMOSTRATO: il 12/09 nessuno dei 675
#  file prova contiene '@FRAZIONEIS', figuriamoci senza valore.
foreach($rp in $righeProva){
  if($rp.Trim() -match '^@FRAZIONEIS\s*$'){
    Muori ("nel file prova c'e' una riga '@FRAZIONEIS' SENZA VALORE.`n" +
           "    Cosi' com'e' il parser la BUTTA VIA e il driver gira col taglio di`n" +
           "    fabbrica (0.40) senza dirlo a nessuno: il file crede di aver`n" +
           "    dichiarato una cosa, i CSV ne raccontano un'altra.`n" +
           "    Si scrive col valore attaccato: '@FRAZIONEIS 0.50'.")
  }
}
if($Direttive.ContainsKey("FRAZIONEIS")){
  $frzTesto = $Direttive["FRAZIONEIS"]
  if($frzTesto -notmatch '^[0-9]*\.?[0-9]+$'){
    Muori ("la direttiva '@FRAZIONEIS " + $frzTesto + "' non e' un numero decimale con il PUNTO.`n" +
           "    Si scrive come lo vuole il driver: '@FRAZIONEIS 0.50'. Niente virgola,`n" +
           "    niente percentuale, niente frazione con la barra.")
  }
  $frzNum = [double]::Parse($frzTesto, [Globalization.CultureInfo]::InvariantCulture)
  if($frzNum -le 0.0 -or $frzNum -gt 1.0){
    Muori ("la direttiva '@FRAZIONEIS " + $frzTesto + "' e' fuori campo: ammesso 0 < f <= 1.`n" +
           "    1.0 = UNA SOLA TRANCHE (gamba OOS degenere, si dichiara).")
  }
  if($PSBoundParameters.ContainsKey("FrazioneIS")){
    if([math]::Abs($FrazioneIS - $frzNum) -gt 0.000001){
      if($FrazioneDallaRiga){
        # DIVERGENZA DICHIARATA. Non e' un'eccezione comoda: e' una firma.
        # Chi lancia ha scritto -FrazioneDallaRiga, cioe' "lo so, lo sto
        # cambiando apposta". E siccome un avviso dentro mille righe di log
        # non lo legge nessuno, esce a banda larga: riquadro pieno, magenta,
        # con i DUE tagli accanto. Esce UNA volta sola.
        Write-Host ""
        Write-Host "*********************************************************************" -ForegroundColor Magenta
        Write-Host "  ATTENZIONE: IL TAGLIO IS/OOS NON E' QUELLO DEL FILE PROVA." -ForegroundColor Magenta
        Write-Host ("    '@FRAZIONEIS' nel file   : " + $frzNum) -ForegroundColor Magenta
        Write-Host ("    -FrazioneIS usato DAVVERO: " + $FrazioneIS) -ForegroundColor Magenta
        Write-Host "  Vince la riga di lancio perche' e' stato passato -FrazioneDallaRiga." -ForegroundColor Magenta
        Write-Host "  I numeri che escono NON descrivono la cella del file prova." -ForegroundColor Magenta
        Write-Host "*********************************************************************" -ForegroundColor Magenta
        Write-Host ""
      } else {
        Muori ("DUE TAGLI IS/OOS, DIVERSI, E NON SCELGO IO.`n" +
               "    -FrazioneIS passato a mano : " + $FrazioneIS + "`n" +
               "    '@FRAZIONEIS' nel file     : " + $frzNum + "`n" +
               "    Il file prova dice che il campione si taglia in un punto, la riga`n" +
               "    di lancio ne dice un altro. Le due finestre IS/OOS che ne escono`n" +
               "    sono DIVERSE, e le soglie sono firmate su UNA delle due: una delle`n" +
               "    due e' sbagliata, si guarda QUALE.`n" +
               "    Se la differenza e' VOLUTA, si dichiara: aggiungi -FrazioneDallaRiga.")
      }
    }
  } else {
    $FrazioneIS = $frzNum
    Write-Host ("    taglio IS/OOS preso da '@FRAZIONEIS' nel file prova: " + $FrazioneIS) -ForegroundColor Yellow
    if($FrazioneIS -ge 1.0){
      Write-Host "    ATTENZIONE: FrazioneIS 1.0 = UNA SOLA TRANCHE. La gamba OOS e' DEGENERE" -ForegroundColor Yellow
      Write-Host "    (finestra vuota): il CSV _OOS non descrive niente. Dichiaralo nel referto." -ForegroundColor Yellow
    }
  }
}
if(-not $Simbolo){ Muori "manca il simbolo. Passalo con -Simbolo NASUSD, o scrivi '@SIMBOLO NASUSD' nel file della prova." }
if(-not $DaQuando){ Muori ("manca la data di inizio storico.`n" +
    "    NON metterla a caso: misurala prima con`n" +
    "      powershell -ExecutionPolicy Bypass -File .\scarica_storico.ps1 -Simboli `"$Simbolo`" -SoloReferto`n" +
    "    e poi passala con -DaQuando. Sugli indici il driver diceva 2024.01.01`n" +
    "    e i dati partivano dal 26/09/2024: meta' finestra IS non esisteva.") }
if(-not $Periodo){ $Periodo="M5" }

# --- il TF del grafico conta o no? Se l'EA prende il TF da un input, il
#  Period del tester e' quasi ininfluente; se usa PERIOD_CURRENT, il
#  Period del tester E' la strategia.
$haInpTF   = $NomiInput.ContainsKey("InpTF")
$usaCurrent= ($src -match 'PERIOD_CURRENT')
if($usaCurrent -and -not $haInpTF){
  Write-Host ""
  Write-Host "    !! Questo EA usa PERIOD_CURRENT e non ha un input InpTF." -ForegroundColor Yellow
  Write-Host "       Il timeframe operativo E' il Period del tester: adesso e' $Periodo." -ForegroundColor Yellow
  Write-Host "       Se non e' quello su cui gira in forward, la misura non c'entra niente" -ForegroundColor Yellow
  Write-Host "       con l'EA vero. Si cambia con -Periodo M15 o con '@PERIODO M15'." -ForegroundColor Yellow
}

# =====================================================================
#  4. I CONTROLLI. Qui si ferma, non dopo una notte di macchina.
# =====================================================================
Titolo "--- controlli ---"
$Errori=New-Object System.Collections.ArrayList
$Sweep =New-Object System.Collections.ArrayList     # @{ nome; celle }

$Ignoti=New-Object System.Collections.ArrayList
$Degeneri=New-Object System.Collections.ArrayList
foreach($riga in $RigheProvaUtili){
  $nome=($riga -split "=")[0].Trim()
  if(-not $NomiInput.ContainsKey($nome)){ [void]$Ignoti.Add($nome); continue }
  $resto=$riga.Substring($riga.IndexOf("=")+1)
  $campi=$resto -split '\|\|'
  if($campi.Count -lt 5){ continue }                # riga a valore secco: pin, non sweep
  $flag=$campi[4].Trim()
  if($flag -notmatch '^[Yy]'){ continue }           # blindata di proposito
  $start=$campi[1].Trim(); $step=$campi[2].Trim(); $stop=$campi[3].Trim()
  $a=Risolvi $start; $b=Risolvi $stop; $s=Risolvi $step
  if(-not ($a.ok -and $b.ok -and $s.ok)){ [void]$Errori.Add("$nome : start/step/stop non sono numeri"); continue }

  # --- LA TRAPPOLA N.1, quella che e' costata una notte il 07/08.
  if(($a.val -eq $b.val) -or ([double]$s.val -eq 0)){
    [void]$Degeneri.Add($nome); continue
  }

  $tipoP=$TipoDi[$nome]
  if($EnumMembri.ContainsKey($tipoP)){
    # ENUM: MT5 IGNORA LO STEP e spazzola i membri fra start e stop.
    $lo=[math]::Min([double]$a.val,[double]$b.val); $hi=[math]::Max([double]$a.val,[double]$b.val)
    $celle=@($EnumMembri[$tipoP] | Where-Object { $_ -ge $lo -and $_ -le $hi }).Count
    [void]$Sweep.Add(@{ nome=$nome; celle=$celle; nota="enum $tipoP - lo step e' ignorato" })
  }else{
    # +1e-9: senza, uno step tipo 0,1 puo' dare 2,9999999998 e Floor mangia una cella.
    $celle=[math]::Floor([math]::Abs([double]$b.val-[double]$a.val)/[math]::Abs([double]$s.val)+1e-9)+1
    [void]$Sweep.Add(@{ nome=$nome; celle=[int]$celle; nota="" })
  }
}

if($Ignoti.Count -gt 0){
  Write-Host ""
  Write-Host "!!! QUESTI PARAMETRI L'EA NON CE LI HA:" -ForegroundColor Red
  foreach($n in $Ignoti){
    $pezzo= if($n.Length -gt 6){ $n.Substring(3) } else { "" }
    $vicini= if($pezzo){ @($Inputs | Where-Object { $_.nome -like "*$pezzo*" } | Select-Object -First 3 -ExpandProperty nome) } else { @() }
    if($vicini.Count -gt 0){ Write-Host ("      $n   -> forse intendevi: " + ($vicini -join ", ")) -ForegroundColor Red }
    else                   { Write-Host "      $n" -ForegroundColor Red }
  }
  Write-Host "    MT5 li ignorerebbe IN SILENZIO e la fase risponderebbe a un'altra domanda." -ForegroundColor Yellow
  [void]$Errori.Add("parametri inesistenti nel file della prova")
}
if($Degeneri.Count -gt 0){
  Write-Host ""
  Write-Host "!!! SWEEP DEGENERE (flag Y ma non spazzola niente):" -ForegroundColor Red
  foreach($n in $Degeneri){ Write-Host "      $n   -> start == stop, oppure step == 0" -ForegroundColor Red }
  Write-Host "    E' l'errore del 07/08: quattro CSV vuoti dopo una notte di macchina." -ForegroundColor Yellow
  [void]$Errori.Add("sweep degenere")
}
if($Sweep.Count -eq 0 -and $Errori.Count -eq 0 -and -not $PermettiCellaSingola){
  [void]$Errori.Add("nessun parametro da spazzolare: sarebbe un backtest singolo, non un walk-forward" +
                    " (se il round e' a CELLA CONGELATA per costruzione, e' -PermettiCellaSingola)")
}

# --- il blocco finale: prima le blindature automatiche, poi il file
#  prova, che quindi VINCE sulle blindature (dedup: sopravvive l'ultima).
$Righe=New-Object System.Collections.ArrayList
foreach($i in $Inputs){
  if(-not $i.ok){ continue }
  if($i.kind -eq "stringa"){
    if($i.val -eq ""){ continue }                   # stringa vuota: la lascio al default compilato
    [void]$Righe.Add("$($i.nome)=$($i.val)")
  }
  else { [void]$Righe.Add("$($i.nome)=$($i.val)||$($i.val)||0||$($i.val)||N") }
}
foreach($r in $RigheProvaUtili){
  $n=($r -split "=")[0].Trim()
  if(-not $NomiInput.ContainsKey($n)){ continue }          # gli ignoti sono gia' un errore: non li conto qui
  $resto=$r.Substring($r.IndexOf("=")+1)
  if(($resto -split '\|\|').Count -ge 5){ [void]$Righe.Add($r); continue }
  # PIN SECCO: va blindato in forma completa v||v||0||v||N. Scoperto il
  # 09/08 (pt6c): un pin scritto 'Nome=35' imposta il VALORE ma NON spegne
  # il flag di ottimizzazione che MT5 ricorda dall'ultima griglia di
  # quell'EA -> il tester rispazzola la griglia vecchia nonostante il pin.
  $v=$resto.Trim()
  if($NomiInput[$n].kind -eq "stringa"){ [void]$Righe.Add("$n=$v") }
  else { [void]$Righe.Add("$n=$v||$v||0||$v||N") }
}

$Visti=@{}
$Finali=New-Object System.Collections.ArrayList
for($i=$Righe.Count-1; $i -ge 0; $i--){
  $n=($Righe[$i] -split "=")[0].Trim()
  if(-not $Visti.ContainsKey($n)){ $Visti[$n]=$true; [void]$Finali.Insert(0,$Righe[$i]) }
}
$doppi=@($Finali | ForEach-Object { ($_ -split "=")[0].Trim() } | Group-Object | Where-Object { $_.Count -gt 1 })
if($doppi.Count -gt 0){ [void]$Errori.Add("parametri duplicati: " + ($doppi.Name -join ", ")) }

$NCelle=1
foreach($s in $Sweep){ $NCelle=$NCelle * $s.celle }

# --- 14/08: celle SPENTE per costruzione. Quando si spazzolano ENTRAMBI i
#     lati (AllowLong 0-1 e AllowShort 0-1) la combinazione "0 e 0" non
#     opera: zero trade, nessuna riga utile nel CSV. Il conteggio grezzo
#     faceva scattare l'allarme rosso della cache su un caso normalissimo
#     (8 chieste, 6 righe). Qui si scala la quota di celle mute.
$nomiSweep = @($Sweep | ForEach-Object { $_.nome })
$NMute = 0
if(($nomiSweep -contains "InpAllowLong") -and ($nomiSweep -contains "InpAllowShort")){
  $cL = ($Sweep | Where-Object { $_.nome -eq "InpAllowLong"  }).celle
  $cS = ($Sweep | Where-Object { $_.nome -eq "InpAllowShort" }).celle
  if($cL -ge 2 -and $cS -ge 2){ $NMute = [int]($NCelle / ($cL * $cS)) }
}
$NAttese = $NCelle - $NMute

Write-Host ""
Write-Host "    parametri in [TesterInputs] : $($Finali.Count)" -ForegroundColor Gray
Write-Host "    spazzolati                  : $($Sweep.Count)" -ForegroundColor Gray
foreach($s in $Sweep){
  $nota= if($s.nota){ "   ($($s.nota))" } else { "" }
  Write-Host ("        {0,-24} {1,3} celle{2}" -f $s.nome, $s.celle, $nota) -ForegroundColor Gray
}
if($Sweep.Count -gt 0){
  Write-Host ("    celle per finestra          : $NCelle   ->  " + ($NCelle*2) + " pass a tick reali in tutto") -ForegroundColor White
}
elseif($PermettiCellaSingola -and $Errori.Count -eq 0){
  # senza questa riga un round a cella congelata NON stampa NESSUN
  # conteggio di celle (il ramo sopra non scatta), e chi legge il log
  # resta senza il numero che poi deve ritrovare come righe nel CSV.
  # Il "-and $Errori.Count -eq 0" NON e' cosmetico: con un asse Y
  # DEGENERE lo sweep e' vuoto lo stesso, e senza quel pezzo questa
  # riga giurerebbe "zero assi Y" proprio quando un asse c'era.
  Write-Host "    CELLA CONGELATA (-PermettiCellaSingola): zero assi Y." -ForegroundColor Yellow
  Write-Host ("    celle per finestra          : $NCelle   ->  " + ($NCelle*2) + " pass a tick reali in tutto") -ForegroundColor White
  Write-Host "    IS e OOS qui NON selezionano niente: sono due campioni della STESSA configurazione." -ForegroundColor Yellow
  #--- CLASSE 134 (MISURATA il 05/09/2026): il flag toglie il cartello,
  #    non il muro. Con Optimization=1 e ZERO parametri ottimizzabili
  #    MT5 non esegue nessuna passata, e un EA che esporta via
  #    FrameAdd/OnTesterDeinit lascia un CSV DA 0 BYTE. Chi accende
  #    questo flag deve vederlo scritto PRIMA di aspettare una notte.
  Write-Host "" -ForegroundColor Red
  Write-Host "    !!! ATTENZIONE, CLASSE 134 (MISURATA IL 05/09/2026) !!!" -ForegroundColor Red
  Write-Host "    Con Optimization=1 e ZERO parametri ottimizzabili MT5 non esegue NESSUNA" -ForegroundColor Red
  Write-Host "    passata: non da' errore, esce con codice 0, e un EA che esporta con" -ForegroundColor Red
  Write-Host "    FrameAdd/OnTesterDeinit (tutti i nostri) lascia il CSV DA 0 BYTE." -ForegroundColor Red
  Write-Host "    Se questo EA e' di quelli, METTI UN ASSE TECNICO A DUE CELLE sul magic:" -ForegroundColor Yellow
  Write-Host "        InpMagic=<m>||<m>||50||<m+50>||Y" -ForegroundColor Yellow
  Write-Host "    e togli -PermettiCellaSingola. E' quello che fanno R102, R103, R116, R117." -ForegroundColor Yellow
}

if($Errori.Count -gt 0){
  Write-Host ""
  Write-Host "=== NON LANCIO. Prima si sistemano questi ===" -ForegroundColor Red
  foreach($e in $Errori){ Write-Host "    - $e" -ForegroundColor Red }
  exit 1
}
Write-Host "    controlli passati." -ForegroundColor Green

# =====================================================================
#  5. LE DUE FINESTRE
# =====================================================================
$Inizio=[datetime]::ParseExact($DaQuando,"yyyy.MM.dd",$null)
$FineDt=[datetime]::ParseExact($Fino,"yyyy.MM.dd",$null)
if($FineDt -le $Inizio){ Muori "la data -Fino ($Fino) non e' dopo -DaQuando ($DaQuando)." }
$Meta=$Inizio.AddDays([math]::Floor(($FineDt-$Inizio).TotalDays*$FrazioneIS))
$WF=@(
  @{ Tag="IS";  Da=$Inizio.ToString("yyyy.MM.dd");            A=$Meta.ToString("yyyy.MM.dd") },
  @{ Tag="OOS"; Da=$Meta.AddDays(1).ToString("yyyy.MM.dd");   A=$FineDt.ToString("yyyy.MM.dd") }
)
Write-Host ""
# 12/09/2026: la FRAZIONE finisce nel log ACCANTO alle due finestre. Prima il
# driver stampava le finestre ma NON il taglio che le ha prodotte: il log che il
# runner pubblica sul repo non bastava a ricostruire dove era stato tagliato il
# campione (e con @FRAZIONEIS il taglio puo' venire dal file prova, non dalla
# riga di lancio). Una riga di log, e il dubbio "la direttiva e' stata letta o
# ignorata in silenzio?" non esiste piu'.
Write-Host ("    taglio IS/OOS: FrazioneIS " + $FrazioneIS) -ForegroundColor Gray
Write-Host "    IS  $($WF[0].Da) - $($WF[0].A)   (qui si sceglie)" -ForegroundColor Gray
Write-Host "    OOS $($WF[1].Da) - $($WF[1].A)   (qui si verifica, e NON si guarda per scegliere)" -ForegroundColor Gray
Write-Host ""
Write-Host "    Lo storico di $Simbolo parte DAVVERO dal $DaQuando ? Se non l'hai MISURATO," -ForegroundColor Yellow
Write-Host "    fermati: sugli indici diceva 2024.01.01 e partiva dal 26/09/2024." -ForegroundColor Yellow

$InputsTxt=($Finali) -join "`n"

# --- la riga Spread dell'.ini (R84-bis). Con -1 la riga NON esiste: e'
#     esattamente quello che facevano tutti i round fino al 18/08.
$RigaSpread = ""
if($Spread -ge 0){
  $RigaSpread = "Spread=$Spread"
  $comeSpread = if($Spread -eq 0){ "spread CORRENTE, dichiarato" } else { "spread FISSO $Spread punti (STRESS)" }
  Write-Host ""
  Write-Host "    Spread=$Spread  ->  $comeSpread" -ForegroundColor Yellow
  if($Modello -eq 4 -and $Spread -gt 0){
    Write-Host "    ATTENZIONE: a tick reali non e' MISURATO che MT5 onori questa riga." -ForegroundColor Yellow
    Write-Host "    Senza il canarino (stesso EA, spread assurdo, numeri DIVERSI) questa" -ForegroundColor Yellow
    Write-Host "    scala non si legge: identico alla base vorrebbe dire riga IGNORATA," -ForegroundColor Yellow
    Write-Host "    non 'robusto allo spread'." -ForegroundColor Yellow
  }
} else {
  Write-Host ""
  Write-Host "    (nessuna riga Spread nell'.ini: MT5 usa il valore che ha in memoria." -ForegroundColor DarkYellow
  Write-Host "     E' il comportamento di sempre, ma e' STATO NASCOSTO: per metterlo agli" -ForegroundColor DarkYellow
  Write-Host "     atti passa -Spread 0.)" -ForegroundColor DarkYellow
}

# --- il RITARDO DI ESECUZIONE (R119). La chiave e' ExecutionMode, e questo
#     driver la scriveva gia' a 0: qui si limita a prendere un valore.
if($Ritardo -ne -999 -and $Ritardo -ne -1 -and ($Ritardo -lt 0 -or $Ritardo -gt 600000)){
  Muori "-Ritardo ammette: -1 (casuale), 0 (normale), oppure 1..600000 millisecondi. Ricevuto: $Ritardo"
}
$ValExec = if($Ritardo -eq -999){ 0 } else { $Ritardo }
$RigaExec = "ExecutionMode=$ValExec"
Write-Host ""
if($Ritardo -eq -999){
  Write-Host "    ExecutionMode=0  ->  esecuzione normale, zero ritardo (come TUTTI i round)." -ForegroundColor DarkYellow
  Write-Host "     Per stressare l'esecuzione: -Ritardo 100 (ms) oppure -Ritardo -1 (casuale)." -ForegroundColor DarkYellow
} elseif($ValExec -eq 0){
  Write-Host "    ExecutionMode=0  ->  esecuzione normale, zero ritardo (BASE della scala)." -ForegroundColor Yellow
} elseif($ValExec -eq -1){
  Write-Host "    ExecutionMode=-1  ->  ritardo CASUALE (STRESS)." -ForegroundColor Yellow
} else {
  Write-Host ("    ExecutionMode=$ValExec  ->  ritardo di $ValExec ms (STRESS).") -ForegroundColor Yellow
}
if($ValExec -ne 0){
  Write-Host "    Il CANARINO resta obbligatorio: stessa cella, ritardo assurdo, numeri DIVERSI." -ForegroundColor Yellow
  Write-Host "    Identico alla base vuol dire riga NON ONORATA, non 'immune al ritardo'." -ForegroundColor Yellow
}

# =====================================================================
#  6. -SoloControllo: si ferma qui e fa vedere cosa lancerebbe
# =====================================================================
if($SoloControllo){
  $anteprima=Join-Path $Work "anteprima_$($Expert)_$Simbolo$SuffBroker.ini"
@"
[Experts]
AllowLiveTrading=false
AllowDllImport=false

[Tester]
Expert=$Expert.ex5
Symbol=$Simbolo
Period=$Periodo
Model=4
$RigaSpread
Optimization=1
OptimizationCriterion=6
FromDate=$($WF[0].Da)
ToDate=$($WF[0].A)
ForwardMode=0
Deposit=$Deposito
Currency=EUR
Leverage=100
$RigaExec
ReplaceReport=1
ShutdownTerminal=1
Report=OptReport_$($Expert)_$($Simbolo)_IS

[TesterInputs]
$InputsTxt
"@ | Set-Content -Path $anteprima -Encoding ASCII
  Write-Host ""
  Write-Host "=== SOLO CONTROLLO: MT5 non e' stato aperto ===" -ForegroundColor Green
  Write-Host "    L'ini che lancerei e' qui, guardalo:" -ForegroundColor Gray
  Write-Host "      $anteprima" -ForegroundColor White
  Write-Host "    Se il numero di celle ti torna, rilancia lo stesso comando SENZA -SoloControllo." -ForegroundColor Gray
  try{ Set-Clipboard -Value $anteprima }catch{}
  exit 0
}

# =====================================================================
#  7. MT5: trova, compila, gira
# =====================================================================
# =====================================================================
#  GUARDIA_BANCO_POSITIVA_v1 -- INIZIO DEL BLOCCO COPIATO
#
#  QUESTA E' UNA COPIA, NON CODICE NUOVO, e non va "migliorata" qui.
#  ORIGINALE: backtest_pipeline\righe\RIGA_ROUND_VPS.ps1, righe 282-386
#  al commit e2d5dc3be1c05d275d8c45c353caa46f929f846e (11/09/2026).
#  Le righe fra questo marcatore e quello di FINE sono IDENTICHE BYTE
#  PER BYTE all'originale, e si verifica cosi' (zero differenze attese):
#     sed -n '282,386p' backtest_pipeline/righe/RIGA_ROUND_VPS.ps1 > /tmp/a
#     sed -n '<prima riga di codice>,<ultima>p' QUESTO_FILE > /tmp/b
#     diff /tmp/a /tmp/b
#  (i due numeri si leggono qui accanto ai marcatori; il comando per
#   intero sta nel referto di consegna dell'11/09/2026).
#
#  NOTA PER CHI TOCCA QUESTE RIGHE: il marcatore di INIZIO e quello di
#  FINE devono comparire in questo file UNA VOLTA SOLA CIASCUNO. Sono
#  presi come confini da chi estrae il blocco per rigirarci sopra i
#  contro-esempi, e una seconda occorrenza dentro un commento accorcia il
#  blocco estratto senza dire niente. Misurato l'11/09/2026, sbagliando:
#  la prima stesura di questa intestazione citava i due marcatori per
#  esteso dentro un esempio di comando, e il banco di prova ha estratto
#  NOVE righe invece di centocinque -- verdetto "RIFIUTATO" su tutto,
#  banco compreso, per un difetto del banco e non della guardia.
#
#  PERCHE' COPIATA E NON INCLUSA -- scelta dichiarata, col suo costo.
#  Un include sarebbe UNA DIPENDENZA IN PIU' DA PINNARE, e qui il pin e'
#  la sola cosa che lega il codice che gira al codice che qualcuno ha
#  letto: RIGA_SOTTILE_ROUND.ps1 inchioda al byte (SHA-256 + pin di
#  commit) i .ps1 che esegue, e RIGA_ROUND_VPS.ps1 scarica questo driver
#  da solo, un file alla volta. Con un include il file incluso o viaggia
#  NON pinnato -- e allora il pin non vuol dire piu' niente -- oppure va
#  aggiunto a mano a ogni catena di scaricamento e a ogni elenco di
#  impronte: tre punti nuovi in cui sbagliare, per risparmiare una copia.
#  Fra comodo e stretto, stretto: si duplica, e si DICHIARA.
#
#  IL COSTO DELLA COPIA, detto per intero: se un giorno la guardia si
#  corregge, va corretta in TUTTI i posti che portano questo marcatore.
#  Si trovano con:
#     grep -rn "GUARDIA_BANCO_POSITIVA_v1" backtest_pipeline
#  L'originale NON porta il marcatore (la sua impronta e' gia' pinnata
#  altrove e toccarlo vorrebbe dire ri-pinnare tutta la catena): sta
#  scritto qui sopra col nome e col commit, ed e' il primo posto da
#  aprire.
# =====================================================================
$BANCO_PERC  = "C:\MT5_Backtest"
$BANCO_CONTO = "50504400"

# I vietati per NOME. NON decidono piu' niente -- decide la guardia
# positiva qui sotto -- ma servono a due cose che contano: dare il
# messaggio GIUSTO (chi e' il terminale che stavi per toccare, col suo
# numero di conto in chiaro, regola dei terminali multipli del 06/09), e
# fare da seconda rete se un domani qualcuno allentasse il confronto.
$TERMINALI_VIETATI = @(
  @{ p = "BCM_Reale";                chi = "il terminale del conto REALE 10105439" },
  @{ p = "-V3";                      chi = "il terminale del 100k, conto 50504263" },
  @{ p = "BCM Markets MT5 Terminal"; chi = "un terminale con SEDIE VIVE sopra: il piccolo 50503392 (e il 100k, che sta nella stessa famiglia di cartelle)" },
  @{ p = "10105439";                 chi = "il conto REALE" },
  @{ p = "50504263";                 chi = "il 100k" },
  @{ p = "50503392";                 chi = "il piccolo" }
)

# Canonicalizza UNA SCRITTURA DI PERCORSO DI WINDOWS: '/' diventa '\',
# i separatori doppi si collassano, '.' e '..' si risolvono, il
# separatore finale sparisce. Torna "" quando la forma NON e' riducibile
# a un percorso ancorato a una lettera di disco -- e "" vuol dire NO.
# Regola dichiarata: cio' che non so risolvere lo RIFIUTO, non lo
# indovino. L'errore cade sempre verso il no.
#
# PERCHE' NON USO [IO.Path]::GetFullPath(), che farebbe le prime quattro
# cose da solo: perche' il suo risultato DIPENDE DALLA PIATTAFORMA e dal
# runtime. Su Linux -- dove questa guardia e' stata collaudata riga per
# riga -- '\' non e' un separatore e GetFullPath("C:\MT5_Backtest")
# torna "<cartella corrente>/C:\MT5_Backtest"; fra .NET Framework 4 (il
# VPS) e .NET Core cambia anche il trattamento di punti e spazi finali.
# Una guardia il cui significato cambia col runtime e' una guardia che
# non si puo' collaudare, e una che non si puo' collaudare non si sa se
# protegge. Questa fa lo stesso identico conto ovunque.
# Il pezzo che il DISCO deve dire (e che nessuna stringa sa) e' un altro,
# ed e' l'attributo ReparsePoint: sta al PUNTO 1, non qui.
function NormalizzaPercorsoWin([string]$p){
  if($null -eq $p){ return "" }
  $s = ("" + $p).Trim()
  if($s -eq ""){ return "" }
  $s = $s.Replace("/","\")
  if($s.Contains("~")){ return "" }              # nome 8.3 (PROGRA~1): espanderlo richiede Win32, quindi si rifiuta
  if($s -match '[\*\?\[\]"|<>]'){ return "" }    # jolly e caratteri che in un percorso non ci vanno
  if($s -notmatch '^[A-Za-z]:\\'){ return "" }   # solo "X:\...": niente UNC, niente \\?\, niente "C:senza-barra"
  $disco = $s.Substring(0,2).ToUpper()
  $resto = $s.Substring(2)
  if($resto.Contains(":")){ return "" }          # un secondo ':' non e' un percorso (flusso NTFS, argomenti incollati)
  $pezzi = New-Object System.Collections.ArrayList
  foreach($t in $resto.Split("\")){
    if($t -eq "" -or $t -eq "."){ continue }
    if($t -eq ".."){
      if($pezzi.Count -eq 0){ return "" }        # si risale sopra la radice: forma senza senso
      $pezzi.RemoveAt($pezzi.Count - 1)
      continue
    }
    [void]$pezzi.Add($t)
  }
  if($pezzi.Count -eq 0){ return ($disco + "\") }   # la RADICE di un disco: normalizzata, e rifiutata piu' sotto
  return ($disco + "\" + ($pezzi -join "\"))
}

# La radice di un disco ("C:\", "D:\") non e' un terminale: e' TUTTO il
# disco. Ha una riga sua perche' merita un messaggio suo -- con un
# bersaglio cosi' la pipe di chiusura diventa "C:\*", cioe' ogni
# terminal64 della macchina, conto reale compreso.
function RadiceDiDisco([string]$norm){
  if($null -eq $norm){ return $false }
  return ($norm -match '^[A-Za-z]:\\$')
}

# IL VERDETTO SUL BERSAGLIO, in una funzione sola e senza effetti: torna
# "" se il bersaglio E' il banco, altrimenti il MOTIVO del rifiuto.
# L'ordine dei controlli e' scelto: prima i divieti per nome (che sanno
# dire CHI stavi per toccare), poi la normalizzazione, poi il confronto
# positivo. Il confronto positivo da solo basterebbe a rifiutare tutto
# quanto; gli altri servono a dire perche'.
function MotivoRifiutoBanco([string]$chiesto){
  $g = ("" + $chiesto).Trim()
  if($g -eq ""){ return "BERSAGLIO VUOTO: -TerminaleBacktest non dice niente." }
  foreach($v in $TERMINALI_VIETATI){
    if($g -like ("*" + $v.p + "*")){
      return ("TERMINALE VIETATO: '" + $g + "' nomina " + $v.chi + ".")
    }
  }
  $n = NormalizzaPercorsoWin $g
  if($n -eq ""){
    return ("BERSAGLIO NON RICONDUCIBILE A UNA CARTELLA DI WINDOWS: '" + $g + "'." +
            " Un nome 8.3 (PROGRA~1 = C:\Program Files scritto in un altro modo), un" +
            " percorso di rete, un \\?\, un carattere jolly o un percorso non ancorato" +
            " a un disco non si indovinano: si rifiutano.")
  }
  if(RadiceDiDisco $n){
    return ("RADICE DI UN DISCO: '" + $g + "'. Un disco intero non e' un terminale:" +
            " con un bersaglio cosi' la pipe di chiusura diventa '" + $n + "*', cioe'" +
            " OGNI terminal64 della macchina.")
  }
  # Confronto ORDINALE, non -ieq. Il -eq di PowerShell passa dalla CULTURA
  # del thread, e una regola di casa di questo stesso file e' che la cultura
  # non deve mai entrare in un confronto (vedi NumInv, qui sopra): su un
  # confronto culturale certi caratteri invisibili vengono IGNORATI, cioe'
  # due stringhe diverse risultano uguali. Qui si guardano i byte.
  if(-not [string]::Equals($n, $BANCO_PERC, [StringComparison]::OrdinalIgnoreCase)){
    return ("NON E' IL BANCO: '" + $g + "' (normalizzato: '" + $n + "').")
  }
  return ""
}
# ---------------------------------------------------------------------
#  GUARDIA_BANCO_POSITIVA_v1 -- FINE DEL BLOCCO COPIATO
# ---------------------------------------------------------------------

# ---------------------------------------------------------------------
#  NomeVietato -- LA SECONDA RETE, E SERVE ALL'ALTRO RAMO (11/09/2026)
#  NON fa parte del blocco copiato qui sopra: sta fuori apposta, perche'
#  quel blocco deve restare identico byte per byte all'originale.
#
#  A COSA SERVE, e nasce da un CONTRO-ESEMPIO trovato provando a rompere
#  la riparazione di oggi: $BrokerBCM vale ($BrokerPattern -match
#  '^(?i)bcm$'), cioe' e' vero SOLO per la parola esatta "BCM". Chi passa
#  -BrokerPattern "BCM Markets" finisce nel ramo dell'ALTRO broker qui
#  sotto, che cerca "*BCM Markets*" sotto Program Files e -- senza questa
#  rete -- si prende IL PICCOLO 50503392. Sarebbe il buco di oggi con un
#  vestito nuovo, raggiungibile da riga di comando.
#
#  PERCHE' QUI LA LISTA E' NEGATIVA e non positiva come per il banco: in
#  quel ramo il bersaglio LEGITTIMO e' un terminale di un altro broker
#  (Pepperstone, 14/08), che per definizione non si puo' elencare in
#  anticipo. Una lista nera dimentica, e va detto: questa NON promette
#  "il bersaglio e' giusto", promette solo "NON e' uno dei nostri MT5 con
#  le sedie vive". E' meno forte della guardia positiva, ed e' il massimo
#  che si puo' fare senza chiudere un uso vero.
# ---------------------------------------------------------------------
function NomeVietato([string]$cartella){
  $d = ("" + $cartella)
  foreach($v in $TERMINALI_VIETATI){
    if($d -like ("*" + $v.p + "*")){ return $v.chi }
  }
  return ""
}

# ---------------------------------------------------------------------
#  7-bis. IL TERMINALE NOMINATO A MANO (-TerminaleBacktest)
#  Sta PRIMA di tutto il resto e, se valorizzato, riempie $Terminal: i
#  due blocchi di ripiego qui sotto sono entrambi guardati da
#  "if(-not $Terminal ...)" e quindi non partono nemmeno. Se invece il
#  parametro e' vuoto, questo blocco non fa NIENTE e la scelta resta
#  quella di sempre, identica riga per riga.
# ---------------------------------------------------------------------
$ViaTerminale=""
if($Terminal){ $ViaTerminale="parametro esplicito -Terminal" }

# ---------------------------------------------------------------------
#  RIPIEGO_BANCO_v1_INIZIO (11/09/2026) -- IL RIPIEGO PREFERISCE IL BANCO
#
#  IL BUCO CHE QUESTA RIGA CHIUDE, ed e' misurato leggendo il file, non
#  dedotto: la guardia positiva stava TUTTA DENTRO "if($TerminaleBacktest)".
#  Chi lancia il driver A MANO senza quel parametro -- e le righe di
#  report\PASSI_OPERATIVI.md (r.95-97) sono scritte proprio cosi' -- non
#  la sfiorava nemmeno: partiva il ripiego del punto 7, che spazzolava
#  Program Files col filtro "*BCM Markets MT5 Terminal*" e non "*-V3*".
#  SUL VPS QUEL FILTRO E' IL PICCOLO 50503392, CON LE SEDIE VIVE SOPRA.
#
#  LA RIPARAZIONE, in una riga: il ripiego non "controlla anche lui", il
#  ripiego ENTRA NELLO STESSO RAMO. Qui si valorizza $TerminaleBacktest
#  con la COSTANTE $BANCO_PERC e si lascia fare al blocco 7-bis qui
#  sotto, che e' identico e non e' stato toccato. Cosi' il percorso del
#  ripiego passa dalla STESSA MotivoRifiutoBanco e dagli STESSI gradini
#  fisici: cartella esistente, NON junction, terminal64.exe,
#  metaeditor64.exe. Un ripiego con controlli PROPRI sarebbe il buco di
#  prima con un vestito nuovo: due copie divergono, e la copia che
#  diverge e' sempre quella che nessuno rilegge.
#
#  PERCHE' NON SI FIRMA DA SOLO IL BANCO QUANDO C'E' -UseSpare: perche'
#  -UseSpare e' una richiesta ESPLICITA di un altro terminale (il -V3,
#  cioe' il 100k 50504263). Dargli il banco in silenzio sarebbe scegliere
#  al posto di chi ha scritto la riga, cioe' lo stesso difetto di classe
#  37-quater visto dall'altra parte. Con -UseSpare si cade nel 7-ter e si
#  muore dicendolo: se quel terminale serve davvero, si passa -Terminal
#  col percorso per esteso, che e' un atto consapevole e scritto.
#
#  E SE IL BANCO NON C'E'? Non si ripiega altrove: si muore (punto 7-ter).
# ---------------------------------------------------------------------
$RipiegoSulBanco = $false
if(-not $Terminal -and -not $TerminaleBacktest -and $BrokerBCM -and -not $UseSpare){
  # Test-Path -PathType Container e' l'UNICA cosa decisa qui, e decide
  # solo "provo o non provo". Tutto il resto -- junction compresa -- lo
  # decide il blocco 7-bis. Una junction risponde SI' a questa riga ed e'
  # giusto cosi': deve morire piu' sotto, col messaggio che spiega DOVE
  # potrebbe puntare, non sparire in silenzio come "banco assente".
  if(Test-Path -LiteralPath $BANCO_PERC -PathType Container){
    Write-Host ""
    Write-Host "--- RIPIEGO: NESSUN TERMINALE NOMINATO, PRENDO IL BANCO -------------" -ForegroundColor Yellow
    Write-Host ("    cartella : " + $BANCO_PERC) -ForegroundColor White
    Write-Host ("    conto    : " + $BANCO_CONTO + "  (demo solo-tester, zero EA attaccati)") -ForegroundColor White
    Write-Host "    NON e' il piccolo 50503392, NON e' il 100k 50504263, NON e' il REALE 10105439." -ForegroundColor White
    Write-Host "    Adesso questo bersaglio passa dagli stessi controlli di -TerminaleBacktest." -ForegroundColor DarkYellow
    Write-Host "---------------------------------------------------------------------" -ForegroundColor Yellow
    $TerminaleBacktest = $BANCO_PERC
    $RipiegoSulBanco   = $true
  }
}

if($TerminaleBacktest){
  if($Terminal){
    Muori ("-TerminaleBacktest e -Terminal dicono due cose diverse: passane UNO solo.`n" +
           "    -TerminaleBacktest = '$TerminaleBacktest'`n" +
           "    -Terminal          = '$Terminal'")
  }
  # LA GUARDIA E' POSITIVA (rifatta l'11/09/2026, GUARDIA_BANCO_POSITIVA_v1
  # qui sopra). PRIMA ERA NEGATIVA e PERDEVA: diceva "non deve essere -V3
  # ne' BCM_Reale", e con quella lista PASSAVANO quattro bersagli, tre dei
  # quali sono terminali VERI di questa macchina --
  #   C:\Program Files\BCM Markets MT5 Terminal  -> il PICCOLO 50503392,
  #       che ha le sedie VIVE sopra;
  #   C:\  -> la RADICE di un disco. Qui il danno non e' teorico: piu'
  #       avanti $cartellaBT diventa il percorso di terminal64.exe e, nelle
  #       righe che ci girano intorno, la pipe di chiusura ($cartellaBT +
  #       "\*") con la radice vale "C:\*", cioe' OGNI terminal64 del disco,
  #       conto REALE 10105439 compreso;
  #   C:\PROGRA~1\BCMMAR~1  -> lo stesso posto di sopra scritto in nome
  #       8.3: una lista di divieti guarda le LETTERE, non il POSTO;
  #   C:\MT5_Backtest\..\Program Files\BCM Markets MT5 Terminal -> il nome
  #       del banco c'e', ma il '..' porta altrove.
  # Misurato eseguendo, non dedotto. Adesso la guardia dice UNA COSA SOLA:
  # DEVE ESSERE IL BANCO, confrontato DOPO normalizzazione e con confronto
  # ORDINALE.
  #
  # E CHI HA UN BERSAGLIO LEGITTIMO DIVERSO DAL BANCO? Passa -Terminal
  # (l'altro parametro, qui sopra): quella porta NON e' toccata da questa
  # modifica ed e' quella che usano le righe vecchie sul PC di backtest di
  # casa e il ramo -BrokerPattern per un secondo broker. Restringere
  # -TerminaleBacktest al solo banco non toglie quindi nessun uso vero --
  # ma va detto, ed e' scritto nel referto, che -Terminal resta SENZA
  # guardia: questa riga chiude la porta che il VPS usa, non tutte.
  # 11/09/2026: il ramo -BrokerPattern qui sotto ha adesso la rete
  # NomeVietato, quindi non puo' piu' atterrare su uno dei NOSTRI MT5 con
  # le sedie vive. -Terminal invece resta scoperto, ed e' voluto.
  $motivoNo = MotivoRifiutoBanco $TerminaleBacktest
  if($motivoNo -ne ""){
    Muori ($motivoNo + "`n" +
           "    L'UNICO bersaglio ammesso in -TerminaleBacktest e' " + $BANCO_PERC + "`n" +
           "    (demo " + $BANCO_CONTO + ", solo-tester). Gli altri MT5 del VPS hanno SEDIE`n" +
           "    VIVE sopra e non si toccano: il piccolo 50503392, il 100k 50504263 e`n" +
           "    il conto REALE 10105439.`n" +
           "    La guardia e' POSITIVA: non elenca i vietati, AMMETTE il banco. Se`n" +
           "    davvero ti serve un altro terminale (un secondo broker, il PC di`n" +
           "    backtest di casa) usa -Terminal, che e' il parametro nato per quello.`n" +
           "    Se invece il banco cambiasse casa, si cambia la COSTANTE, a mano, e`n" +
           "    si ripassa dal cancello.")
  }
  # LA COSTANTE, NON LA STRINGA DI FUORI: da qui in avanti la stringa
  # arrivata da fuori e' stata GIUDICATA e si butta. E' questa riga che
  # impedisce a $cartellaBT di diventare "C:\" per colpa di come e' stato
  # scritto un argomento.
  $cartellaBT=$BANCO_PERC
  if(-not (Test-Path -LiteralPath $cartellaBT -PathType Container)){
    Muori ("-TerminaleBacktest: la cartella NON esiste.`n" +
           "    cercata  : '$cartellaBT'`n" +
           "    Va passata la CARTELLA PROGRAMMA del terminale, cioe' quella che`n" +
           "    contiene terminal64.exe (non l'exe, non la cartella dati):`n" +
           "      -TerminaleBacktest `"C:\MT5_Backtest`"")
  }
  # --- GUARDIA_BANCO_POSITIVA_v1, GRADINO f: COPIA da RIGA_ROUND_VPS.ps1
  #     righe 480-497 al commit e2d5dc3 (stesse regole di sopra). E' il
  #     gradino che la sola stringa NON puo' fare: un nome giusto puo'
  #     puntare nel posto sbagliato se la cartella e' una junction.
  # IL GRADINO CHE NESSUNA STRINGA PUO' FARE. Un nome giusto puo' puntare
  # nel posto sbagliato: basta che la cartella sia una junction o un link
  # simbolico. Il testo e' identico, il posto no -- e quello lo sa solo il
  # filesystem. Se e' un collegamento non si parte: non si indovina dove va.
  $infoBT = $null
  try  { $infoBT = Get-Item -LiteralPath $cartellaBT -Force -ErrorAction Stop }
  catch{ $infoBT = $null }
  if($null -eq $infoBT){
    Muori ("la cartella '" + $cartellaBT + "' non e' leggibile: non posso dire DOVE punta, e quindi non parto.")
  }
  if((([int]$infoBT.Attributes) -band ([int][IO.FileAttributes]::ReparsePoint)) -ne 0){
    Muori ("IL BANCO E' UN COLLEGAMENTO: '" + $cartellaBT + "' non e' una cartella vera,`n" +
           "    e' una junction (o un link simbolico) che rimanda altrove. Il nome e'`n" +
           "    quello giusto, il posto potrebbe non esserlo, e nessun controllo sulla`n" +
           "    STRINGA se ne accorgerebbe.`n" +
           "    Se il banco 50504400 e' davvero installato cosi', si guarda insieme dove`n" +
           "    punta e si cambia questa riga. Non si tira a indovinare.")
  }
  $exeBT=Join-Path $cartellaBT "terminal64.exe"
  if(-not (Test-Path -LiteralPath $exeBT -PathType Leaf)){
    Muori ("-TerminaleBacktest: la cartella c'e', ma NON contiene terminal64.exe.`n" +
           "    cartella : '$cartellaBT'`n" +
           "    cercato  : '$exeBT'`n" +
           "    Se il terminale e' installato altrove, passa QUELLA cartella.`n" +
           "    Per vedere le installazioni vive, in sola lettura:`n" +
           "      Get-Process terminal64 | Select-Object Id, MainWindowTitle, Path")
  }
  # il compilatore sta nella stessa cartella: se manca, il round morirebbe
  # piu' avanti con un errore che non nomina il terminale. Meglio adesso.
  $medBT=Join-Path $cartellaBT "metaeditor64.exe"
  if(-not (Test-Path -LiteralPath $medBT -PathType Leaf)){
    Muori ("-TerminaleBacktest: manca metaeditor64.exe, e senza compilatore l'EA`n" +
           "    non si compila.`n" +
           "    cartella : '$cartellaBT'`n" +
           "    cercato  : '$medBT'")
  }
  $Terminal=$exeBT
  $MetaEditor=$medBT
  $ViaTerminale="parametro esplicito -TerminaleBacktest"
}
# LA VIA VA DETTA PER QUELLA CHE E'. Se ci siamo arrivati dal ripiego,
# nessuno ha passato -TerminaleBacktest: scriverlo sarebbe una bugia
# stampata, e il banner "TERMINALE SCELTO" esiste apposta per non far
# tirare a indovinare. Questa riga sta FUORI dal blocco perche' dentro il
# blocco si puo' morire: se si e' arrivati qui, i controlli sono passati.
if($RipiegoSulBanco){
  $ViaTerminale = "RIPIEGO automatico SUL BANCO " + $BANCO_PERC + " (demo " + $BANCO_CONTO + ")"
}

# ---------------------------------------------------------------------
#  7-ter. IL RIPIEGO CHE SPAZZOLAVA Program Files E' STATO TOLTO
#  (11/09/2026, RIPIEGO_BANCO_v1)
#
#  QUI CI SI ARRIVA SOLO IN DUE CASI, e nessuno dei due ammette una
#  scelta automatica:
#    a) il banco C:\MT5_Backtest NON esiste (o non e' una cartella);
#    b) e' stato passato -UseSpare, che chiede un terminale con le sedie
#       vive sopra (il -V3 = 100k 50504263).
#
#  PERCHE' SI MUORE E NON SI CERCA ANCORA. Le due strade offerte erano
#  "morire" oppure "ripiegare solo su cio' che MotivoRifiutoBanco non
#  rifiuta". La seconda, GUARDATA DA VICINO, e' la prima travestita: la
#  guardia e' POSITIVA e ammette UN SOLO percorso, C:\MT5_Backtest. Un
#  ripiego che puo' accettare un bersaglio solo e in questo ramo sa gia'
#  che quel bersaglio non c'e' e' un modo piu' lento di morire -- con in
#  piu' una spazzolata ricorsiva di Program Files che tocca le cartelle
#  del conto REALE per poi buttare via il risultato. Fra comodo e
#  stretto, stretto: si muore, e si dice cosa passare.
#
#  E LA PERDITA DI COMODITA' E' REALE, VA DETTA: su una macchina dove il
#  banco non e' installato (un PC nuovo, un collega) le righe vecchie
#  senza -TerminaleBacktest adesso non partono piu' da sole. Il rimedio
#  e' una riga sola (-Terminal col percorso per esteso), ed e' un atto
#  consapevole: e' esattamente cio' che il 06/09 e' mancato, quando un
#  attacco destinato al piccolo 50503392 e' quasi finito sul REALE.
# ---------------------------------------------------------------------
if(-not $Terminal -and $BrokerBCM){
  $perche = ("IL BANCO NON C'E': '" + $BANCO_PERC + "' non esiste, o non e' una cartella.")
  if($UseSpare){
    $perche = ("-UseSpare chiede il terminale '-V3', cioe' IL 100k 50504263, che ha SEDIE" +
               "`n             VIVE sopra. Dall'11/09/2026 il driver non se lo sceglie piu' da solo.")
  }
  Muori ("NESSUN TERMINALE DA USARE, e non me ne scelgo uno io.`n" +
         "    motivo : " + $perche + "`n" +
         "`n" +
         "    Il driver NON spazzola piu' Program Files per indovinare un terminale:`n" +
         "    su questa macchina ce ne possono essere quattro, e tre hanno SEDIE VIVE`n" +
         "    sopra (piccolo 50503392, 100k 50504263, REALE 10105439). Sbagliare`n" +
         "    finestra e' gia' costato: incidente del 06/09/2026.`n" +
         "`n" +
         "    COSA FARE, in ordine di preferenza:`n" +
         "      1) se il banco c'e' ma sta altrove, passalo per esteso:`n" +
         "           -TerminaleBacktest `"" + $BANCO_PERC + "`"`n" +
         "         (ammesso SOLO quel percorso: la guardia e' positiva)`n" +
         "      2) se ti serve davvero un ALTRO terminale -- un secondo broker, il`n" +
         "         PC di backtest di casa, il -V3 -- passa -Terminal col percorso`n" +
         "         COMPLETO di terminal64.exe. E' l'unica porta senza guardia, e si`n" +
         "         apre a mano apposta:`n" +
         "           -Terminal `"C:\...\terminal64.exe`"`n" +
         "`n" +
         "    Per vedere cosa c'e' vivo adesso, in SOLA LETTURA:`n" +
         "      Get-Process terminal64 | Select-Object Id, MainWindowTitle, Path")
}
#  RIPIEGO_BANCO_v1_FINE
if(-not $Terminal -and -not $BrokerBCM){
  # TERMINALE DI UN ALTRO BROKER. Si parte da origin.txt (ogni cartella
  # dati dice da quale installazione arriva): e' l'unico modo affidabile,
  # perche' un broker puo' installarsi dove vuole e chiamarsi come vuole.
  # Solo se li' non si trova niente si spazzola Program Files.
  $termRoot=Join-Path $env:APPDATA "MetaQuotes\Terminal"
  foreach($d in (Get-ChildItem $termRoot -Directory -ErrorAction SilentlyContinue)){
    if($d.Name -ieq "Common"){ continue }
    $o=Join-Path $d.FullName "origin.txt"
    if(-not (Test-Path $o)){ continue }
    $inst=""
    try{ $inst=(Get-Content $o -Raw -ErrorAction Stop).Trim() }catch{ continue }
    if($inst -notlike "*$BrokerPattern*"){ continue }
    # 11/09/2026: -BrokerPattern non e' una porta di servizio sui NOSTRI
    # terminali. "BCM Markets" qui dentro pescherebbe il piccolo 50503392.
    $chiVietato = NomeVietato $inst
    if($chiVietato -ne ""){
      Write-Host ("    SCARTATO, e' un terminale VIETATO: " + $inst) -ForegroundColor Red
      Write-Host ("    (" + $chiVietato + "). -BrokerPattern serve per un ALTRO broker.") -ForegroundColor Red
      continue
    }
    $t=Join-Path $inst "terminal64.exe"
    if(-not (Test-Path $t)){ continue }
    $Terminal=$t
    $MetaEditor=Join-Path $inst "metaeditor64.exe"
    $ViaTerminale="RIPIEGO da origin.txt per BrokerPattern '$BrokerPattern'"
    if(-not $DataFolder){ $DataFolder=$d.FullName }
    break
  }
  if(-not $Terminal){
    $allTerm=Get-ChildItem "C:\Program Files","C:\Program Files (x86)" -Recurse -Filter "terminal64.exe" -ErrorAction SilentlyContinue
    # 11/09/2026: stessa rete di sopra. Il "primo che capita" non deve mai
    # poter essere uno dei nostri MT5 con le sedie vive.
    $c=$null
    foreach($x in @($allTerm|Where-Object{$_.DirectoryName -like "*$BrokerPattern*"})){
      $chiVietato = NomeVietato $x.DirectoryName
      if($chiVietato -ne ""){
        Write-Host ("    SCARTATO, e' un terminale VIETATO: " + $x.DirectoryName) -ForegroundColor Red
        Write-Host ("    (" + $chiVietato + "). -BrokerPattern serve per un ALTRO broker.") -ForegroundColor Red
        continue
      }
      $c=$x; break
    }
    if($c){$Terminal=$c.FullName; $MetaEditor=Join-Path $c.DirectoryName "metaeditor64.exe"
           $ViaTerminale="RIPIEGO su Program Files per BrokerPattern '$BrokerPattern'"}
  }
  if(-not $Terminal){
    Muori ("non trovo nessun terminale che contenga '$BrokerPattern'.`n" +
           "    Va installato e APERTO almeno una volta (col login demo), altrimenti`n" +
           "    MT5 non crea nemmeno la sua cartella dati. La sequenza completa e' in`n" +
           "    docs\BROKER_ESTERNO_MAPPA.md; per vedere i terminali che hai:`n" +
           "      powershell -ExecutionPolicy Bypass -File .\prepara_broker_esterno.ps1 -SoloElenco")
  }
  Write-Host "    terminale: $Terminal" -ForegroundColor Yellow
}
if(-not $Terminal){ Muori "non trovo terminal64.exe. Passalo con -Terminal `"C:\...\terminal64.exe`"." }

# --- SI DICHIARA SEMPRE QUALE TERMINALE E' STATO SCELTO, E DA QUALE VIA.
#  Il difetto della classe 37-quater non e' scegliere male: e' scegliere
#  in silenzio. Con quattro terminali BCM sul VPS (piccolo 50503392,
#  100k 50504263 -V3, reale 10105439 BCM_Reale, backtest 50504400 in
#  C:\MT5_Backtest) questa riga va LETTA prima di lasciar girare il round.
if(-not $ViaTerminale){ $ViaTerminale="RIPIEGO automatico" }
Write-Host ""
Write-Host "--- TERMINALE SCELTO ------------------------------------------------" -ForegroundColor Cyan
Write-Host ("    terminal64 : " + $Terminal) -ForegroundColor White
Write-Host ("    cartella   : " + (Split-Path -Parent $Terminal)) -ForegroundColor White
Write-Host ("    via        : " + $ViaTerminale) -ForegroundColor Yellow
if($ViaTerminale -like "RIPIEGO*"){
  Write-Host "    (ripiego: nessuna cartella nominata. Se non e' quello che volevi," -ForegroundColor DarkYellow
  Write-Host "     rilancia con -TerminaleBacktest `"C:\MT5_Backtest`" e non tirare a indovinare.)" -ForegroundColor DarkYellow
}
Write-Host "---------------------------------------------------------------------" -ForegroundColor Cyan

if($Terminal -and -not $DataFolder){
  $instDir=Split-Path -Parent $Terminal; $termRoot=Join-Path $env:APPDATA "MetaQuotes\Terminal"
  if(Test-Path $termRoot){$DataFolder=Get-ChildItem $termRoot -Directory -ErrorAction SilentlyContinue|Where-Object{$o=Join-Path $_.FullName "origin.txt";(Test-Path $o)-and((Get-Content $o -Raw).Trim() -ieq $instDir)}|Select-Object -First 1 -ExpandProperty FullName}
}
if(-not $DataFolder -or -not (Test-Path $DataFolder)){ Muori "cartella dati MT5 non trovata. Passala con -DataFolder." }

# MT5 aperto = il tester non parte e escono ZERO CSV. E' successo.
if((Get-Process -Name "terminal64" -ErrorAction SilentlyContinue) -and -not $Force){
  Muori "chiudi MetaTrader prima di lanciare, altrimenti escono 0 CSV."
}

$MqlExperts=Join-Path $DataFolder "MQL5\Experts"
$MqlInclude=Join-Path $DataFolder "MQL5\Include"
$MqlFiles  =Join-Path $DataFolder "MQL5\Files"
$Results   =Join-Path $Work "risultati_prove\$Expert"
New-Item -ItemType Directory -Force -Path $MqlExperts,$MqlInclude,$Results | Out-Null

# --- GLI #include NOSTRI, PORTATI E DICHIARATI (v5)
#  Un file copiato in silenzio e' un'assunzione: qui si stampa cosa e'
#  arrivato e DOVE, come si fa gia' per il terminale scelto. Ricopiarli
#  su un terminale che li ha gia' e' innocuo: la fonte e' sempre il repo,
#  esattamente come per il .mq5 dell'EA copiato due righe piu' sotto.
Write-Host ""
Write-Host "--- INCLUDE NOSTRI PORTATI SUL TERMINALE -----------------------------" -ForegroundColor Cyan
Write-Host ("    destinazione : " + $MqlInclude) -ForegroundColor White
if($IncPronti.Count -eq 0){
  Write-Host "    (nessuno: la lista e' vuota o i download sono tutti falliti)" -ForegroundColor DarkYellow
}
foreach($ip in $IncPronti){
  $dstInc=Join-Path $MqlInclude $ip.Rel
  New-Item -ItemType Directory -Force -Path (Split-Path -Parent $dstInc) | Out-Null
  Copy-Item $ip.File -Destination $dstInc -Force
  $len=0; if(Test-Path $dstInc){ $len=(Get-Item $dstInc).Length }
  Write-Host ("    " + $ip.Rel.PadRight(30) + " " + $len + " byte   (" + $ip.Nota + ")") -ForegroundColor White
}
Write-Host "    (di SISTEMA, NON copiati perche' MT5 li ha gia': Trade\Trade.mqh," -ForegroundColor DarkGray
Write-Host "     Trade\PositionInfo.mqh, Trade\SymbolInfo.mqh, Trade\AccountInfo.mqh)" -ForegroundColor DarkGray
Write-Host "---------------------------------------------------------------------" -ForegroundColor Cyan

Copy-Item $srcFile -Destination $MqlExperts -Force

# --- 12/09/2026, CLASSE 270: L'EX5 STANTIO CHE PASSA PER COMPILATO.
#     Fino a oggi qui si compilava e poi si faceva Test-Path sull'.ex5, SENZA
#     cancellarlo prima e SENZA guardare la data. Difetto misurato dal
#     cancello: se la compilazione FALLISCE e un .ex5 c'era gia' da una corsa
#     precedente, Test-Path e' VERO, il driver stampa "compilato" in VERDE e
#     gira il BINARIO VECCHIO. I numeri di un commit finiscono attribuiti a
#     un altro, senza un segnale a schermo.
#     E non e' teorico: su questi EA l'archivio ha 116 / 52 / 6 / 4 CSV,
#     quindi l'.ex5 preesistente e' lo scenario NORMALE, non l'eccezione.
#     La toppa e' una riga: si cancella PRIMA, cosi' Test-Path torna a
#     misurare "la compilazione di ADESSO ha prodotto un artefatto" invece di
#     "esiste un artefatto, di chissa' quando".
$ex5Atteso = Join-Path $MqlExperts "$Expert.ex5"
Remove-Item -LiteralPath $ex5Atteso -Force -ErrorAction SilentlyContinue

& $MetaEditor "/compile:$(Join-Path $MqlExperts "$Expert.mq5")" "/log" | Out-Null
if(-not (Test-Path (Join-Path $MqlExperts "$Expert.ex5"))){
  # --- v5: il messaggio di morte deve dire PERCHE'.
  #  Fino a ieri qui usciva solo "compilazione fallita": chi legge non ha
  #  modo di sapere se manca un include, se c'e' un errore di sintassi o
  #  se metaeditor non e' nemmeno partito. Il log lo scrive metaeditor
  #  con /log accanto al sorgente (<EA>.log), in UTF-16: va letto a byte
  #  e decodificato, altrimenti escono caratteri a caso.
  $logAtteso=Join-Path $MqlExperts "$Expert.log"
  $logFile=$null
  if(Test-Path $logAtteso){ $logFile=$logAtteso }
  else{
    $alt=@(Get-ChildItem $MqlExperts -Filter "*.log" -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending | Select-Object -First 1)
    if($alt.Count -gt 0){ $logFile=$alt[0].FullName }
  }
  $coda=@()
  if($logFile){
    $by=$null
    try{ $by=[System.IO.File]::ReadAllBytes($logFile) }catch{ $by=$null }
    if($by -and $by.Length -gt 1){
      $txt=""
      if($by[0] -eq 0xFF -and $by[1] -eq 0xFE){ $txt=[System.Text.Encoding]::Unicode.GetString($by,2,$by.Length-2) }
      elseif($by[0] -eq 0xFE -and $by[1] -eq 0xFF){ $txt=[System.Text.Encoding]::BigEndianUnicode.GetString($by,2,$by.Length-2) }
      elseif($by.Length -gt 3 -and $by[1] -eq 0 -and $by[3] -eq 0){ $txt=[System.Text.Encoding]::Unicode.GetString($by) }
      else{ $txt=[System.Text.Encoding]::UTF8.GetString($by) }
      $righeLog=@(($txt -split "`r?`n") | Where-Object { $_.Trim() -ne "" })
      if($righeLog.Count -gt 25){ $coda=@($righeLog[($righeLog.Count-25)..($righeLog.Count-1)]) }
      else{ $coda=$righeLog }
    }
  }
  Write-Host ""
  Write-Host "--- ULTIME RIGHE DEL LOG DI METAEDITOR -------------------------------" -ForegroundColor Red
  if($logFile){ Write-Host ("    log: " + $logFile) -ForegroundColor DarkGray }
  else{ Write-Host "    NESSUN LOG TROVATO in $MqlExperts (metaeditor potrebbe non essere nemmeno partito)" -ForegroundColor Red }
  if($coda.Count -eq 0 -and $logFile){ Write-Host "    (log presente ma vuoto o illeggibile)" -ForegroundColor Red }
  foreach($r in $coda){ Write-Host ("    " + $r) -ForegroundColor Yellow }
  Write-Host "---------------------------------------------------------------------" -ForegroundColor Red
  Muori ("compilazione fallita per $Expert (nessun .ex5 prodotto).`n" +
         "    Le ultime righe del log di MetaEditor sono stampate qui sopra: si leggono QUELLE.`n" +
         "    Se dicono 'can't open ... .mqh', manca un #include: gli include nostri portati`n" +
         "    da questo driver sono elencati nel riquadro INCLUDE NOSTRI, poco piu' su.")
}
Write-Host "    compilato $Expert" -ForegroundColor Green

$Suffisso = if($Modello -eq 4){ "" } else { "_ohlc" }   # un OHLC non deve MAI sovrascrivere un tick reale
if($Etichetta){ $Suffisso = $Suffisso + "_" + $Etichetta }
# il broker va IN CODA al nome: un CSV girato su un altro feed non deve
# nemmeno poter finire nella stessa tabella dei nostri (es. _r50_pepperstone)
$Suffisso = $Suffisso + $SuffBroker
foreach($w in $WF){
  $tag="$($Expert)_$($Simbolo)_$($w.Tag)$Suffisso"
  $done=Join-Path $Results "$tag.csv"
  if((Test-Path $done) -and -not $Rifai){
    Write-Host "    $tag gia' fatto, salto (usa -Rifai per rifarlo)" -ForegroundColor DarkGray; continue
  }
  if(Test-Path $done){
    $vecchi=Join-Path $Results "vecchi"; New-Item -ItemType Directory -Force -Path $vecchi | Out-Null
    Move-Item $done (Join-Path $vecchi "$tag.csv") -Force
    Write-Host "    ${tag}: il precedente e' finito in 'vecchi\'" -ForegroundColor DarkYellow
  }
  Write-Host ""
  Write-Host "--- $tag   ($($w.Da) -> $($w.A))   $NCelle celle ---" -ForegroundColor Cyan

  $ini=Join-Path $Work "gen_$tag.ini"
  # 14/08/2026 - [Experts] AllowLiveTrading=false: NON e' cosmetica.
  #  Lanciare il tester con /config: AVVIA IL TERMINALE, che carica l'ultimo
  #  profilo con i suoi grafici e gli EA attaccati sopra. Sul PC di backtest
  #  quel terminale e' collegato al conto VIVO 50503392: ogni backtest
  #  riaccendeva di fatto gli EA su grafico, che piazzavano ordini veri.
  #  E' cosi' che il 14/08 e' partito un DAX Apertura in BREAKOUT con buffer
  #  20 pt da un grafico M3 di prova. Questa riga spegne il trading dal vivo
  #  per quella sessione; il TESTER non ne risente, perche' simula e non
  #  passa dal permesso di trading reale.
@"
[Experts]
AllowLiveTrading=false
AllowDllImport=false

[Tester]
Expert=$Expert.ex5
Symbol=$Simbolo
Period=$Periodo
Model=$Modello
$RigaSpread
Optimization=1
OptimizationCriterion=6
FromDate=$($w.Da)
ToDate=$($w.A)
ForwardMode=0
Deposit=$Deposito
Currency=EUR
Leverage=100
$RigaExec
ReplaceReport=1
ShutdownTerminal=1
Report=OptReport_$tag

[TesterInputs]
$InputsTxt
"@ | Set-Content -Path $ini -Encoding ASCII

  $csv=Join-Path $MqlFiles "OptResults_$($Expert)_$($Simbolo).csv"
  if(Test-Path $csv){ Remove-Item $csv -Force }
  $prima=Get-Date
  $comeGira = if($Modello -eq 4){ "tick reali" } else { "OHLC M1 - SOLO SCREENING, non un verdetto" }
  Write-Host "    avvio $NCelle pass ($comeGira)..." -ForegroundColor Cyan
  (Start-Process -FilePath $Terminal -ArgumentList "/config:`"$ini`"" -PassThru).WaitForExit()

  # l'EA compone il nome del CSV con MQL_PROGRAM_NAME e _Symbol. Se per
  # qualche EA non e' cosi', si ripiega sul piu' recente prodotto ADESSO.
  if(-not (Test-Path $csv)){
    $alt=@(Get-ChildItem $MqlFiles -Filter "OptResults_*.csv" -ErrorAction SilentlyContinue |
           Where-Object { $_.LastWriteTime -ge $prima } | Sort-Object LastWriteTime -Descending | Select-Object -First 1)
    if($alt.Count -gt 0){ $csv=$alt[0].FullName; Write-Host "    (CSV trovato con un altro nome: $($alt[0].Name))" -ForegroundColor DarkYellow }
  }
  if(Test-Path $csv){
    $n=@(Get-Content $csv).Count
    Copy-Item $csv -Destination $done -Force; Remove-Item $csv -Force
    if($n -le 1){
      Write-Host "    ATTENZIONE: $tag.csv ha solo l'intestazione (o e' VUOTO), ZERO passate." -ForegroundColor Red
      if($Sweep.Count -eq 0){
        Write-Host "    CAUSA N.1, CLASSE 134: questa corsa non ha NESSUN parametro ottimizzabile." -ForegroundColor Red
        Write-Host "    Con Optimization=1 e zero assi Y, MT5 non esegue nessuna passata: OnTester non" -ForegroundColor Red
        Write-Host "    gira, FrameAdd non manda niente, e OnTesterDeinit crea il file e lo lascia vuoto." -ForegroundColor Red
        Write-Host "    RIMEDIO: asse tecnico a 2 celle sul magic, InpMagic=<m>||<m>||50||<m+50>||Y." -ForegroundColor Yellow
      }
    }
    else        { Write-Host ("    OK -> $tag.csv   ({0} righe)" -f ($n-1)) -ForegroundColor Green }
    if(($n-1) -eq $NAttese -and $NMute -gt 0){
      Write-Host ("    (regolare: {0} celle chieste meno {1} con ENTRAMBI i lati spenti = {2} righe)" -f $NCelle, $NMute, $NAttese) -ForegroundColor DarkGray
    }
    if(($n-1) -ne $NCelle -and ($n-1) -ne $NAttese){
      Write-Host ("    ATTENZIONE: {0} righe nel CSV ma {1} celle chieste ({2} attese)." -f ($n-1), $NCelle, $NAttese) -ForegroundColor Red
      Write-Host "    E' la CACHE del tester: MT5 ripesca pass gia' calcolati (anche di" -ForegroundColor Red
      Write-Host "    griglie vecchie) e NON riesegue le celle chieste se le ha in cache." -ForegroundColor Red
      Write-Host "    Un pass non rieseguito NON scrive i file per-trade (abtg_trades_*)." -ForegroundColor Red
      Write-Host "    Verifica: se i file abtg_trades_* dei magic chiesti sono comparsi" -ForegroundColor Red
      Write-Host "    freschi in Common\Files, i pass sono girati e va tutto bene." -ForegroundColor Red
      Write-Host "    Se NON ci sono: magic MAI usato prima, oppure svuotare Tester\cache." -ForegroundColor Red
    }
  }else{
    Write-Host "    (nessun CSV per ${tag}: storico mancante su $Simbolo? MT5 gia' aperto?)" -ForegroundColor Yellow
  }
}

# =====================================================================
#  8. IL REFERTO
# =====================================================================
$Attesi=@("$($Expert)_$($Simbolo)_IS$Suffisso.csv","$($Expert)_$($Simbolo)_OOS$Suffisso.csv")
$Mancanti=@($Attesi | Where-Object { -not (Test-Path (Join-Path $Results $_)) })

Write-Host ""
Write-Host "=== FINITO ===" -ForegroundColor White
Write-Host ("    CSV attesi: {0}   presenti: {1}   MANCANTI: {2}" -f $Attesi.Count, ($Attesi.Count-$Mancanti.Count), $Mancanti.Count) -ForegroundColor Gray
if($Mancanti.Count -gt 0){
  Write-Host ""
  Write-Host "!!! QUESTI NON SONO STATI PRODOTTI:" -ForegroundColor Red
  foreach($m in $Mancanti){ Write-Host "      $m" -ForegroundColor Red }
  Write-Host "    Rilancia lo STESSO comando SENZA -Rifai: rifa' solo questi." -ForegroundColor Yellow
}else{
  Write-Host "    Tutti e due prodotti, sono qui:" -ForegroundColor Green
  Write-Host "      $Results" -ForegroundColor White
  try{ Set-Clipboard -Value $Results }catch{}
}
Write-Host ""
Write-Host "    I criteri di accettazione sono scritti in cima a prove\$Expert.txt." -ForegroundColor Gray
Write-Host "    Si leggono PRIMA di guardare la tabella, e non si spostano dopo." -ForegroundColor Gray
if(-not $BrokerBCM){
  Write-Host ""
  Write-Host "    PROMEMORIA: questi CSV vengono da '$BrokerPattern', non da BCM." -ForegroundColor Red
  Write-Host "    Si leggono SOLO in confronto relativo dentro questo stesso feed" -ForegroundColor Red
  Write-Host "    (finestra avversa vs finestra favorevole). Nessun numero assoluto" -ForegroundColor Red
  Write-Host "    va messo nelle nostre classifiche, e nessun parametro va ritarato" -ForegroundColor Red
  Write-Host "    qui: la taratura resta su BCM." -ForegroundColor Red
  Write-Host "    E ricontrolla di aver rimappato gli orari: se non l'hai fatto," -ForegroundColor Red
  Write-Host "    questi numeri non misurano l'EA, misurano un EA diverso." -ForegroundColor Red
}
