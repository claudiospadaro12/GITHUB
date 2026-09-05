# =====================================================================
#  MARCATORE_RIGA_POSTNEWS_1330_v1
#  RIGA_POSTNEWS_1330.ps1 -- PASSO 0 (conta-occasioni) del preset
#  USD1330/USDJPY di ABTG_PostNews.mq5 (v1.10): il BLOCCO DELLE 13:30
#  SERVER OLTRE L'NFP (CPI m/m, Retail Sales, Core Retail Sales, PPI
#  m/m). Modello 1 (1 minuto OHLC = SCREENING, mai un verdetto),
#  @PERIODO M5, UNA finestra IS/OOS, UN solo asse: InpMagic
#  774801/774806 (2 celle gemelle, DEVONO uscire identiche: e' un
#  controllo di coerenza del banco, non una griglia).
#  Preset:  mql5\Presets\ABTG_PostNews_USD1330_USDJPY.set
#  Prova:   prove\POSTNEWS_1330_00_conta.txt  (@DAQUANDO OMESSO APPOSTA)
#  Calendario: mql5\Files\abtg_news_usd1330_2010_2023_UTC.csv
#              (645 righe = 1 intestazione + 644 eventi; di questi 541
#               portano l'etichetta USD1330OKF, cioe' quella del preset,
#               e corrispondono a 347 GIORNATE distinte)
#  E' la SORELLA di RIGA_POSTNEWS_NFP.ps1 (MARCATORE_RIGA_POSTNEWS_NFP_v2)
#  e di RIGA_POSTNEWS_ISM.ps1: stesso motore, stessa struttura, stessi
#  gate. Le differenze VERE di logica rispetto alla riga NFP sono
#  dichiarate qui sotto ai punti >>> PAVIMENTO, >>> -Fino 2023.12.31 e
#  >>> CONTA-OCCASIONI: non sono rifiniture, sono scelte che cambiano i
#  numeri e vanno lette prima di lanciare.
# ---------------------------------------------------------------------
#  >>> QUESTA RIGA NON TOCCA LA SEDIA NFP CHE GIRA IN FORWARD.
#      Il dossier del 04/09 (par. 4.B) proponeva di allargare il filtro
#      del titolo della sedia viva (magic 771203). NON si fa: non si
#      tocca una sedia in forward prima di aver misurato a parte la
#      modifica. Istanza nuova, magic nuovo, calendario nuovo.
#      E la convivenza e' sicura per un fatto CONTATO, non supposto: il
#      calendario di questo preset NON contiene l'NFP e le sue giornate
#      non toccano MAI quelle dell'NFP (0 giornate in comune su 14 anni,
#      caso 7 dell'autotest di costruisci_news_blocchi_usa.py). Le due
#      istanze non possono aprire lo stesso giorno: nessun raddoppio di
#      rischio, cap C1 non sfiorato.
#
#  PERCHE' QUESTA RIGA E' DIVERSA DALLE ALTRE (dichiarato in testa,
#  non scoperto a meta' lettura):
#
#  >>> IL PROVA OMETTE @DAQUANDO DI PROPOSITO. Modello 1 (1 minuto OHLC)
#      lavora su barre M1 VERE: la data d'inizio corretta e' quella in
#      cui BCM possiede DAVVERO le barre M1 di USDJPY, non 2010.01.01 a
#      occhio. Questa riga la MISURA da sola (fase 8), con lo stesso
#      meccanismo di scarica_storico.ps1 (ABTG_HistoryDownloader.mq5),
#      ESEGUITO DENTRO QUESTO DRIVER e sullo STESSO terminale/cartella
#      dati risolti alla fase 5 -- non chiama scarica_storico.ps1 come
#      processo separato apposta: quello script si sceglie il terminale
#      DA SOLO e non accetta un -Terminale, quindi con due installazioni
#      BCM ambigue misurerebbe lo storico su un terminale e girerebbe il
#      tester su un altro. Qui i due passi condividono $InstDir/$DataFolder.
#      SOLO M1, SOLO barre (InpScaricaTick=false: Modello 1 non usa
#      tick), 2 tentativi al massimo: se al secondo tentativo il
#      verdetto resta "MANCA STORICO LOCALE" la riga SI FERMA con un
#      messaggio chiaro. Non si indovina @DAQUANDO: mai.
#
#  >>> PAVIMENTO 2010.01.01 -- DIFFERENZA DI LOGICA rispetto alla riga
#      NFP, e nasce da un fatto GIA' MISURATO (su un altro simbolo, ed
#      e' dichiarato che e' un altro simbolo).
#      In R102 (24/08, backtest_pipeline\risultati_archivio\
#      R102_REFERTO_BLOCCO1.md righe 16-18 e 106) lo scarico M1 di
#      EURUSD da BCM ha dichiarato 10.014.728 barre "dal 1971.01.03",
#      mentre la PRIMA OPERAZIONE vera di quel round su EURUSD e' del
#      1999.01.18. Cioe': la data che ABTG_HistoryDownloader restituisce
#      puo' essere una data DICHIARATA dal broker, non una data
#      OPERATIVA. Su USDJPY non lo abbiamo ancora misurato: il rischio
#      e' [INFERITO per analogia], non [MISURATO] -- e proprio per
#      questo la riga non lo assume, lo TAPPA e lo DICHIARA.
#      Se la riga prendesse alla lettera una data del genere, con -Fino
#      2023.12.31 e lo split 0,40 l'IS finirebbe in anni in cui QUESTO
#      calendario (2010-2023) ha ZERO eventi. Il CSV IS uscirebbe con
#      Trades=0 e sembrerebbe "niente edge" mentre e' "non e' girata" --
#      esattamente l'errore del 07/08 che questo round esiste per non
#      ripetere.
#      Percio': -DaQuando usato = IL PIU' TARDI fra la data MISURATA e
#      -PavimentoDaQuando (default 2010.01.01: il primo evento utile di
#      questo calendario e' il 2010.01.14). Tutti e due i numeri
#      finiscono nel referto, e se il pavimento MORDE la riga lo scrive
#      nei RILIEVI. Se la data misurata e' PIU' TARDI del pavimento,
#      vince la misura e non cambia niente rispetto alla riga NFP.
#      [SCELTA DICHIARATA: il valore 2010.01.01 non e' fissato da nessun
#       materiale, e' derivato dal calendario stesso. Si cambia con
#       -PavimentoDaQuando, non si tocca il codice.]
#
#  >>> -Fino 2023.12.31 (e NON 2026.06.30 come la riga NFP).
#      Il calendario di questo blocco COPRE 2010-2023 E BASTA (la
#      sorgente Forex Factory di casa finisce li'; lo dice il preset in
#      testa). Con -Fino 2026.06.30 gli ultimi 2,5 anni della finestra
#      varrebbero ZERO occasioni e, peggio, sposterebbero il confine
#      IS/OOS in avanti sulla base di tempo MORTO.
#      NB, e va detto perche' e' il contrario di quello che
#      converrebbe: questa scelta RIDUCE il campione IS (119 occasioni
#      invece di 145). Non e' scelta per superare una soglia -- anzi,
#      allontana da essa.
#      [SCELTA DICHIARATA: nessun materiale fissava -Fino per questo
#       preset. Si cambia con -Fino, non si tocca il codice.]
#
#  >>> CONTA-OCCASIONI, A MACCHINA, PRIMA DEL TESTER (fase 8-bis).
#      Questa cella si chiama "00_conta" e allora conta davvero: dal
#      calendario SCARICATO AL PIN la riga estrae le GIORNATE distinte
#      che passano i filtri di QUESTO preset (impatto >= 3, valuta USD,
#      titolo che contiene USD1330OKF) e le divide fra IS e OOS con lo
#      STESSO split del generico.
#      >>> QUI LA DIFFERENZA RIGHE/GIORNATE E' GROSSA E VA CAPITA:
#          541 RIGHE ma 347 GIORNATE. Non e' un errore del file: Retail
#          Sales m/m e Core Retail Sales m/m escono nello STESSO minuto
#          (due righe, un solo prezzo) e gPlacedDay dell'EA concede
#          comunque UN SOLO piazzamento al giorno. La FREQUENZA vera di
#          questa famiglia e' 347 / 13,91 anni = 24,9 giornate l'anno,
#          non le "43,5/anno" del dossier (che contava 609 giornate del
#          blocco INTERO, GDP e giornate DST comprese, che il default
#          qui ESCLUDE).
#      >>> E UN'OCCASIONE NON E' UN'OPERAZIONE: ogni giornata utile
#          piazza DUE pendenti e quante gambe scattino non lo sa nessuno
#          prima della passata (0, 1 o 2). L'Emendamento A si applica
#          alle OPERAZIONI (colonna Trades), MAI alle occasioni. Le
#          occasioni servono a capire se il round e' anche solo GIRATO.
#      Se le occasioni IS sono ZERO la riga lo dichiara un PROBLEMA.
#
#  >>> IL CAMPIONE E' IL PUNTO DEBOLE DICHIARATO DI QUESTO CANDIDATO.
#      Con la finestra di default (pavimento 2010.01.01, -Fino
#      2023.12.31, split 0,40) l'IS ha 119 OCCASIONI: sotto il pavimento
#      dei 150 dell'Emendamento A, a meno che le gambe scattino piu' di
#      1,26 volte per occasione. Non e' una previsione, e' un'aritmetica
#      da dichiarare PRIMA: se n(IS) resta sotto 150, il MERITO di
#      questa famiglia resta SOSPESO anche in un round successivo a tick
#      reali, e la strada e' allargare la finestra o il blocco, non
#      spremere parametri.
#
#  >>> ECCEZIONE DICHIARATA alla regola di casa "-SoloControllo non apre
#      MT5": qui la APRE UNA VOLTA (fase 8, lo script di misura, NON il
#      tester). Senza la data vera anche l'anteprima del generico
#      sarebbe una prova su un numero indovinato -- l'unico modo per non
#      indovinare @DAQUANDO neppure nel giro a vuoto. -SoloControllo
#      resta comunque piu' leggero: NON lancia il tester (il generico
#      gira con -SoloControllo, MT5 non apre una seconda volta per il
#      backtest).
#
#  >>> QUESTA CELLA NON PUO' PROMUOVERE NIENTE, per DUE motivi sommati:
#      il campione IS sotto il pavimento (vedi sopra) e IL BANCO, che e'
#      MODELLO 1 (OHLC) = uno screening. In questa casa l'illusione OHLC
#      ha gia' revocato una promozione (SupRev DOW H4, PF 2,77 OHLC
#      contro 0,79 a tick reali). Il referto stampa i numeri, applica
#      l'Emendamento A alla colonna Trades (soglie di casa 150/30) e NON
#      promuove. Il giudizio di RISCHIO (Emendamento B) vale a qualunque
#      n ma su questo OPTFRAME si legge SOLO su Equity DD % (l'EA non
#      esporta un Peggior Giornata %): dichiarato, non inventato.
#
#  >>> LA COMPOSIZIONE DEL BLOCCO NON E' COSTANTE NEL TEMPO (rilievo
#      MISURATO, dichiarato nel preset): CPI m/m ha un BUCO 2010-2013,
#      PPI m/m un BUCO 2019-2021. Il 2010-2013 e' fatto quasi solo di
#      Retail Sales e PPI. Un confronto IS/OOS qui sta confrontando
#      anche MISCELE DIVERSE, non solo periodi diversi. Il referto lo
#      ricopia fra le cose che NON si possono dire.
#
#  >>> IL CANARINO E' UNA RIGA DI LOG, NON UNA COLONNA CSV. A differenza
#      di altre righe di casa, "UTILI per questo preset N" lo stampa
#      OnInit() dell'EA nel log del TESTER (uno per ogni pass/agente),
#      non l'OPTFRAME. Il driver lo legge dai log (fase 11, gli stessi
#      5 radici di R116) e lo stampa IN CHIARO nel referto: N=0 diventa
#      un PROBLEMA esplicito ("calendario cieco, la passata NON CONTA"),
#      mai un warning sepolto in fondo. E qui c'e' in piu' il valore
#      ATTESO: con questo preset e questo calendario N DEVE valere 541
#      (RIGHE, non giornate: l'EA conta le righe filtrate), dal
#      2010.01.14 al 2023.12.14. Un N diverso da 541 e' un PROBLEMA: il
#      filtro non sta selezionando quello che crediamo.
#
#  >>> NESSUN #define per l'autotest (a differenza di ABTG_LondonFx):
#      questo EA non dichiara BLOCCHI_ATTESI/CASI_ATTESI. Il conteggio
#      "vero" si CALCOLA dal sorgente (occorrenze di "falliti+=AT_Caso("
#      + "if(!X) falliti++;"), non si indovina: oggi (v1.10) fa 3+2=5,
#      e il gate lo ricalcola SEMPRE dal file appena scaricato al pin,
#      non da un numero scritto qui una volta per tutte.
#
#  >>> I MAGIC 774801/774806 SONO STATI VERIFICATI VERGINI ORA,
#      DALL'ASSISTENTE, SUL REPO (04/09/2026): 774801 compare solo nel
#      preset e nel prova nuovi, 774806 non compariva da nessuna parte.
#      >>> 774802 NON SI USA QUI: e' RISERVATO nel preset al gemello
#          CROSS-SIMBOLO (blocco 13:30 su EURUSD), che e' un altro round.
#      La riga NON puo' riverificarlo a runtime: il PC di backtest non
#      ha il repo clonato (come tutte le righe di questa casa).
#
#  >>> IL PRESET .set NON VIENE CARICATO DAL TESTER (walkforward_generico
#      non supporta i .set): e' il CONTRATTO da cui il prova e' stato
#      derivato a mano, e il gate di fase 4 verifica che i 31 valori
#      fissi combacino UNO A UNO fra prova e preset (+ che InpMagic del
#      preset, 774801, sia la CELLA CHE FA DA LEAD nell'asse). Se preset
#      e prova divergono, quella e' un'incoerenza vera: ci si ferma.
#
#  >>> NESSUN per-trade CSV: OnTesterDeinit() di questo EA scrive solo
#      l'OPTFRAME (9 colonne: Pass,Profit,Expected Payoff,Profit Factor,
#      Recovery Factor,Sharpe Ratio,Equity DD %,Trades,InpMagic). A
#      differenza di ABTG_LondonFx non c'e' ExportTrades: dichiarato,
#      non un buco del driver.
#
#  COSA FA, IN ORDINE (ogni passo timbra il SUO campo del referto PRIMA
#  di potersi fermare: classe 94-ter, stati sempre a TRE: NON TENTATO /
#  FALLITO / OK):
#   0. guardie: -Pin 40-hex obbligatorio, MT5 e MetaEditor CHIUSI,
#      sentinella di un giro precedente interrotto (classe 116);
#   1. scarico AL PIN: walkforward_generico.ps1 (pinnato col replace di
#      $EABranch + [Charts] MaxBars alzato, ENTRAMBI riletti dal disco),
#      ABTG_PostNews.mq5, ABTG_PausaGuardian.mqh (censito dal
#      sorgente), il calendario CSV, il preset .set, il prova .txt, e
#      ABTG_HistoryDownloader.mq5 (per la misura storico, fase 8);
#   2. gate sul sorgente: #property version "1.10" (ancorato), casi
#      autotest ricalcolati (3 AT_Caso + 2 falliti++ = 5), include
#      censiti (Trade/Trade.mqh + il Guardian, nessun terzo), hedge-safe
#      (zero Position*(_Symbol) fuori commenti), OnTester presente;
#   3. gate sul prova: @SIMBOLO USDJPY, @PERIODO M5, @DAQUANDO/@FINOA
#      ASSENTI, asse InpMagic esatto (2 celle), 31 fissi nome per nome,
#      nessuna riga estranea (34 righe vive attese);
#   4. gate di coerenza col preset .set: i 31 fissi del prova E i valori
#      del preset combaciano uno a uno, InpMagic preset (774801) = lead
#      dell'asse; + gate sul calendario (645 righe, intestazione esatta,
#      541 righe / 347 giornate USD1330OKF contate a macchina);
#   5. terminale BCM di backtest (non -V3) + cartella dati da origin.txt
#      (classe 115, -Terminale come manopola se le candidate non sono 1);
#   6. FOTO PRIMA dei 3 file del terminale, sentinella scritta PRIMA di
#      toccarlo (classe 116), include installato con backup, EA copiato
#      e COMPILATO con metaeditor64 diretto, log letto qualunque sia la
#      codifica (Result: N errors);
#   7. calendario installato in ENTRAMBI i posti (Common\Files e
#      <CartellaDati>\MQL5\Files), foto/size prima-dopo;
#   8. MISURA STORICO M1 USDJPY (automatica, SOLO barre, MAX 2 tentativi),
#      poi il PAVIMENTO: PrimaDataServer filtrato diventa -DaQuando;
#   8-bis. CONTA-OCCASIONI dal calendario al pin, per finestra IS/OOS;
#   9. Tester\cache svuotata (SOLO quella), log del tester fotografati;
#  10. CORSA (generico, -SoloControllo o vera): 2 celle x 1 finestra
#      IS/OOS, -DaQuando MISURATO (col pavimento), -Modello 1, -Rifai;
#  11. collaudi: 2 righe per CSV (attese), gemelli 774801/774806
#      IDENTICI su tutte le colonne tranne Pass/InpMagic, canarino NEWS
#      letto dai log del tester (5 radici, atteso N=541), autotest "casi
#      falliti" letto dai log (atteso 0 su ogni riga trovata);
#  12. conto economico (Profit, Payoff, PF, RF, Sharpe, DD%, Trades) letto
#      per finestra, Emendamento A (soglie 150/30) applicato SENZA MAI
#      promuovere;
#  RIPRISTINO -- SEMPRE: include rimesso com'era (backup) o rimosso,
#      sentinella tolta, FOTO DOPO. L'EA .mq5/.ex5 RESTA in MQL5\Experts
#      (il tester lo richiede), dichiarato con la foto;
#  RACCOLTA -- SEMPRE: cartella + zip sul Desktop VERO (GetFolderPath,
#      poi %USERPROFILE%\Desktop, poi OneDrive\Desktop: classe 116-bis),
#      referto + CSV + .ini veri + log + prova + preset + il CSV dello
#      storico misurato. Exit 0/1, la riga di chat legge il codice a
#      TRE stati (classe 108).
# ---------------------------------------------------------------------
#  LE SCELTE CHE I MATERIALI NON FISSAVANO (clausola SEVERA, dichiarate):
#   - Etichetta CSV: "1330OK00" (nessun materiale la fissava; segue lo
#     stile "NFP00" della riga sorella e nomina l'etichetta del titolo).
#   - -Fino 2023.12.31 e -PavimentoDaQuando 2010.01.01: vedi i due punti
#     >>> in testa. Sono DUE differenze di logica rispetto alla riga NFP,
#     non rifiniture.
#   - Deposito 100000, FrazioneIS 0.40: default di casa, nessun materiale
#     li fissava diversamente per questo preset. NB: con questo split
#     l'IS ha 119 occasioni. Spostare lo split PER FAR PASSARE la soglia
#     sarebbe pescare: la soglia si dichiara prima e si legge dopo.
#   - -DaQuandoRichiesta 2010.01.01: il punto da cui CHIEDE lo storico
#     al broker. Il valore VERO che finisce nel test e' quello MISURATO
#     (PrimaDataServer) filtrato dal pavimento.
#   - -TimeoutStoricoMin 45, max 2 tentativi: la misura M1-senza-tick e'
#     piu' leggera del download tick di scarica_storico.ps1 (default 90),
#     ma nessun materiale ha mai cronometrato QUESTA misura su USDJPY:
#     stima onesta, non una previsione.
#   - Emendamento B (rischio) letto SOLO su Equity DD % (l'unico che
#     l'OPTFRAME di questo EA esporta): nessuna soglia numerica e' stata
#     CONGELATA per questo preset in nessun materiale ricevuto -- il
#     referto stampa il numero, la CHIAMATA resta a chi legge.
#   - Nessuna "prova di regime" (Emendamento C, 4 finestre toro/orso/
#     laterale/crollo): il prova dichiara UNA finestra sola. Dichiarato,
#     non eseguito qui (fuori scopo del Passo 0).
#   - Nessuna ablazione sul GDP (USD1330OK) ne' sul DST (USD1330DST):
#     il prova ha UN SOLO asse (InpMagic). Sono round successivi, e si
#     ottengono cambiando UNA stringa nel preset.
#
#  QUANTO CI METTE [STIMA, non una previsione]: compilazione EA + misura
#  storico M1 USDJPY senza tick (10-45 minuti, MOLTO variabile) + 2
#  passate OHLC M1 su una finestra di 14 anni (secondi-minuti, non tick
#  reali) + 2-3 avvii del terminale. Totale onesto: 20-60 minuti, quasi
#  tutti nella misura storico.
#
#  LA RIGA CHE SI INCOLLA sta in righe\RIGA_POSTNEWS_1330_DA_MANDARE.md
# =====================================================================
[CmdletBinding()]
param(
  # -Pin NON ha default: un default silenzioso ("lavoro") farebbe girare
  #  la punta del branch spacciandola per un commit congelato.
  [string]$Pin                 = "",
  [switch]$SoloControllo,                  # generico -SoloControllo: MT5 NON apre per il tester (ma APRE per la misura storico, vedi header)
  [string]$Terminale           = "",       # manopola (classe 115): cartella dell'installazione MT5 di backtest
  [string]$DaQuandoRichiesta   = "2010.01.01", # da dove CHIEDE lo storico al broker (non e' il valore usato: vedi -DaQuando misurato)
  [string]$PavimentoDaQuando   = "2010.01.01", # PAVIMENTO: vedi header. -DaQuando usato = il PIU' TARDI fra misurato e questo
  [string]$Fino                = "2023.12.31", # il calendario di questo blocco finisce nel 2023: oltre sono mesi a ZERO occasioni
  [double]$FrazioneIS          = 0.40,     # split 40/60 (firma di casa)
  [int]$Deposito                = 100000,  # taglia prop
  [int]$TimeoutStoricoMin      = 45,       # tetto per OGNI tentativo di misura storico (max 2 tentativi)
  [switch]$SaltaMisuraStorico,             # SOLO PER RIPETIZIONE nella STESSA sessione di lavoro: NON salta la prima volta
  [string]$DaQuandoGiaMisurata = ""        # vedi -SaltaMisuraStorico: valore GIA' misurato da un giro precedente, nella STESSA $Work, da riusare senza riaprire MT5
)
$ErrorActionPreference = "Stop"
[Threading.Thread]::CurrentThread.CurrentCulture   = [Globalization.CultureInfo]::InvariantCulture
[Threading.Thread]::CurrentThread.CurrentUICulture = [Globalization.CultureInfo]::InvariantCulture
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$INV = [Globalization.CultureInfo]::InvariantCulture

$EA          = "ABTG_PostNews"
$INC         = "ABTG_PausaGuardian.mqh"
$Simbolo     = "USDJPY"
$Periodo     = "M5"
$Etichetta   = "1330OK00"
$VERSIONE_ATTESA = "1.10"
$MAGIC1 = 774801; $MAGIC2 = 774806
$NCELLE_ATTESE = 2
$NEWSFILE    = "abtg_news_usd1330_2010_2023_UTC.csv"
$PRESET_FILE = "ABTG_PostNews_USD1330_USDJPY.set"
$PROVA_FILE  = "POSTNEWS_1330_00_conta.txt"
$HISTDL      = "ABTG_HistoryDownloader.mq5"
# --- il calendario, numeri VERI letti dal file nel repo il 04/09/2026
#     (NON copiati dalla riga NFP, che aveva 600/599):
$CAL_RIGHE_ATTESE   = 645          # righe totali del file = 1 intestazione + 644 eventi
$CAL_INTESTAZIONE   = "Data Ora;Impatto;Valuta;Titolo"
$TITLE_MATCH        = "USD1330OKF"  # deve combaciare con InpNewsTitleMatch del preset
$CAL_UTILI_ATTESI   = 541          # righe che passano i filtri di QUESTO preset (= quello che l'EA stampa come "UTILI per questo preset")
$CAL_GIORNATE_ATTESE= 347          # giornate distinte: MOLTE MENO delle righe (Retail Sales e Core Retail
                                   # Sales escono nello STESSO minuto = 2 righe, 1 sola occasione)
$CAL_PRIMO_ATTESO   = "2010.01.14"
$CAL_ULTIMO_ATTESO  = "2023.12.14"
# --- casi dell'autotest: NON un #define nel sorgente. Si RICALCOLANO
#     dal file appena scaricato al pin (fase 2): questi due numeri sono
#     l'atteso di OGGI (v1.10), non un valore di cui il gate si fida.
$AT_CASO_ATTESI      = 3   # "falliti+=AT_Caso(" -- T1 ECB, T2 FOMC, T3 slide NFP/USDJPY
$FALLITIPP_ATTESI    = 2   # "if(!X) falliti++;" -- pip del simbolo, calendario
$CASI_TOTALI_ATTESI  = $AT_CASO_ATTESI + $FALLITIPP_ATTESI
# --- Emendamento A (CLAUDE.md, unita' = OPERAZIONE): soglie di casa.
$N_PASSA = 150; $N_MIN = 30

$Avvio = Get-Date
$Stamp = $Avvio.ToString("yyyyMMdd_HHmm", $INV)
function TrovaDesktop(){
  foreach($p in @([Environment]::GetFolderPath("Desktop"),
                  (Join-Path $env:USERPROFILE "Desktop"),
                  (Join-Path $env:USERPROFILE "OneDrive\Desktop"))){
    if($p -and (Test-Path -LiteralPath $p)){ return $p }
  }
  return $env:USERPROFILE
}
$Dsk    = TrovaDesktop
$Work   = Join-Path $env:USERPROFILE "abtg_postnews_1330"
$Prove  = Join-Path $Work "prove"
$Sentinella = Join-Path $Work "POSTNEWS_1330_IN_CORSO.txt"
$RawPin = "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$Pin"

$Problemi   = New-Object System.Collections.ArrayList
$Rilievi    = New-Object System.Collections.ArrayList
$RigheLog   = New-Object System.Collections.ArrayList
$Fatale     = ""
$TermTxt    = "NON SCELTO"
$DataFolder = ""
$InstDir    = ""
$Compilato  = "NON TENTATA"
$ResultTxt  = "NON LETTA"
$VersTxt    = "NON LETTA"
$AutotestTxt= "NON LETTO"
$IncTxt     = "NON CENSITO"
$IncGuardia = "NON VERIFICATA"
$HedgeTxt   = "NON ESEGUITO"
$OnTesterTxt= "NON VERIFICATO"
$CacheTxt   = "NON SVUOTATA"
$CelleTxt   = "NON CONTATE"
$GemPreset  = "NON VERIFICATO"
$CalCsvTxt  = "NON VERIFICATO"
$ModelTxt   = "NON LETTO"
$LogLetti   = -1
$CorsaTxt   = "NON TENTATA"
$Ripristino = "NON NECESSARIO (il terminale non e' mai stato scritto)"
$FotoPrese  = $false
$IncInstallato = $false
$IncEraLi   = $false
$IncBackup  = ""
$TExpMq5 = ""; $TExpEx5 = ""; $TIncMqh = ""
$F1Prima = $null; $F2Prima = $null; $F3Prima = $null
$RigheFotoDopo = New-Object System.Collections.ArrayList
$CalFotoRighe  = New-Object System.Collections.ArrayList
$logC = Join-Path $Work "COMPILAZIONE.log"
$Modo = "CORSA"
if($SoloControllo){ $Modo = "CONTROLLO" }
$ZipNome = "POSTNEWS_1330_" + $Modo + "_" + $Stamp
$DaQuandoMisurato = ""
$DaQuandoUsato    = ""
$PavimentoTxt     = "NON APPLICATO (misura non arrivata)"
$StoricoTxt = "NON MISURATO"
$StoricoTentativi = New-Object System.Collections.ArrayList
$StoricoCsvCopia = ""
$provaPath = ""; $presetPath = ""
$WinIS = "n/d"; $WinOOS = "n/d"
$OccTxt = "NON CONTATE"
$OccIS = -1; $OccOOS = -1
$GiorniCal = @()
$IS = $null; $OOS = $null

function Ora(){ return (Get-Date).ToString("HH:mm:ss", $INV) }
function Dico([string]$t,[string]$c="Gray"){ Write-Host ("[" + (Ora) + "] " + $t) -ForegroundColor $c }
function Titolo([string]$t){ Write-Host ""; Write-Host ("=== " + $t + " ===") -ForegroundColor Cyan }
function Num([string]$s){ return [double]::Parse($s.Trim(), $INV) }
function FmtN($v){ if($null -eq $v){ return "n/d" }; return ([long]$v).ToString($INV) }
function Fmt2($v){ if($null -eq $v){ return "n/d" }; return ([double]$v).ToString("0.00",$INV) }
function Fmt4($v){ if($null -eq $v){ return "n/d" }; return ([double]$v).ToString("0.0000",$INV) }

function Scarica([string]$url,[string]$dest){
  Remove-Item -LiteralPath $dest -Force -ErrorAction SilentlyContinue
  try{ Invoke-WebRequest -Uri $url -OutFile $dest -UseBasicParsing -ErrorAction Stop }
  catch{
    throw ("SCARICO FALLITO da " + $url + " -- " + $_.Exception.Message +
           " | se e' un 404 su un pin appena creato: la cache di raw.githubusercontent dura qualche minuto, si aspetta e si rilancia LA STESSA riga (il pin non si cambia).")
  }
  if(-not (Test-Path -LiteralPath $dest)){ throw ("SCARICO FALLITO (nessun file scritto): " + $url) }
  if((Get-Item -LiteralPath $dest).Length -le 0){ throw ("SCARICO FALLITO (file vuoto): " + $url) }
}

# Legge un file di testo qualunque sia la codifica (i log di MetaEditor
# e del tester escono in UTF-16LE col BOM).
function LeggiTesto([string]$path){
  if(-not (Test-Path -LiteralPath $path)){ return @() }
  $b = [System.IO.File]::ReadAllBytes($path)
  if($b.Length -eq 0){ return @() }
  $txt = ""
  if($b.Length -ge 2 -and $b[0] -eq 255 -and $b[1] -eq 254){ $txt = [System.Text.Encoding]::Unicode.GetString($b,2,$b.Length-2) }
  elseif($b.Length -ge 2 -and $b[0] -eq 254 -and $b[1] -eq 255){ $txt = [System.Text.Encoding]::BigEndianUnicode.GetString($b,2,$b.Length-2) }
  elseif($b.Length -ge 3 -and $b[0] -eq 239 -and $b[1] -eq 187 -and $b[2] -eq 191){ $txt = [System.Text.Encoding]::UTF8.GetString($b,3,$b.Length-3) }
  else{
    $zeri = 0; $fin = [math]::Min($b.Length,400)
    for($i=1; $i -lt $fin; $i=$i+2){ if($b[$i] -eq 0){ $zeri++ } }
    if($zeri -gt ($fin/4)){ $txt = [System.Text.Encoding]::Unicode.GetString($b) } else { $txt = [System.Text.Encoding]::UTF8.GetString($b) }
  }
  return @($txt -split "`r`n|`n|`r")
}

function Foto([string]$path){
  if($path -eq "" -or $null -eq $path -or -not (Test-Path -LiteralPath $path)){ return [pscustomobject]@{ Esiste=$false; Len=-1; Ora="ASSENTE" } }
  $i = Get-Item -LiteralPath $path
  return [pscustomobject]@{ Esiste=$true; Len=$i.Length; Ora=$i.LastWriteTime.ToString("yyyy-MM-dd HH:mm:ss",$INV) }
}
function FotoTxt($f){ if(-not $f.Esiste){ return "ASSENTE" }; return ("presente, " + $f.Len + " byte, " + $f.Ora) }

function RigheVive([string]$p){ return @(Get-Content -LiteralPath $p | Where-Object { $_ -notmatch '^\s*#' -and $_ -notmatch '^\s*$' }) }

# legge un prova in una mappa @{nome=valore} (le direttive @NOME entrano
# con la chiocciola come chiave) + lista assi Y. Riga DOPPIA = FATALE.
function LeggiProva([string]$percorso,[string]$nome){
  $mappa = @{}
  $assi  = New-Object System.Collections.ArrayList
  foreach($r in (RigheVive $percorso)){
    if($r -match '^@'){
      $parti = ($r -split '\s+',2)
      if($parti.Count -lt 2){ throw ($nome + ": la direttiva '" + $r + "' non ha un valore.") }
      if($mappa.ContainsKey($parti[0])){ throw ($nome + ": direttiva doppia '" + $parti[0] + "'.") }
      $mappa[$parti[0]] = $parti[1].Trim()
      continue
    }
    $i = $r.IndexOf("=")
    if($i -lt 0){ continue }
    $n = $r.Substring(0,$i).Trim(); $v = $r.Substring($i+1).Trim()
    if($mappa.ContainsKey($n)){ throw ($nome + ": DUE righe per '" + $n + "'. In [TesterInputs] un parametro doppio fa fare a MT5 ZERO passate.") }
    $mappa[$n] = $v
    if($v -match '\|\|Y\s*$'){ [void]$assi.Add($n) }
  }
  return @{ Mappa=$mappa; Assi=$assi }
}

# conta le celle di UN asse ESATTAMENTE come le conta il generico
# (Floor(|stop-start|/|step| + 1e-9) + 1; true->1, false->0).
function CelleAsse([string]$valore,[string]$nome){
  $campi = $valore -split '\|\|'
  if($campi.Count -lt 5){ throw ($nome + ": pin '" + $valore + "' non ha 5 campi: non e' un asse.") }
  $conv = New-Object System.Collections.ArrayList
  foreach($ix in @(1,2,3)){
    $t = $campi[$ix].Trim()
    if($t -ieq "true"){ $t = "1" }; if($t -ieq "false"){ $t = "0" }
    if($t -notmatch '^-?\d+(\.\d+)?$'){ throw ($nome + ": campo '" + $campi[$ix] + "' non numerico nell'asse.") }
    [void]$conv.Add([double]::Parse($t,$INV))
  }
  $start = $conv[0]; $step = $conv[1]; $stop = $conv[2]
  if($step -eq 0 -or $start -eq $stop){ throw ($nome + ": asse DEGENERE (start==stop o step==0).") }
  return ([int]([math]::Floor([math]::Abs($stop-$start)/[math]::Abs($step) + 1e-9)) + 1)
}

# I 31 FISSI del prova, nome per nome (identici, valore per valore, al
# preset ABTG_PostNews_USD1330_USDJPY.set: fase 4 lo riverifica).
# L'ordine non conta per il gate, ma e' quello del file, per leggibilita'.
# NB: rispetto alla riga NFP cambiano SETTE chiavi -- ExpiryHour 14 (NFP 16),
# ExpiryMin 45 (NFP 59), NewsFile, NewsTitleMatch, CloseAtExpiry true (NFP
# false), RiskPercent 0.65 (NFP 1.30), Comment. ActionHour/Min restano 13:45,
# IDENTICI alla sedia NFP. Tutti presi 1:1 dal preset frozen.
$FissiAttesi = [ordered]@{
  "InpUsaGuardian"="true"; "InpActionHour"="13"; "InpActionMin"="45"; "InpExpiryHour"="14"; "InpExpiryMin"="45"
  "InpRestrictToNews"="true"; "InpUseNewsFilter"="true"; "InpNewsFile"=$NEWSFILE; "InpNewsCommon"="true"
  "InpNewsMinImpact"="3"; "InpNewsCurrencies"="USD"; "InpNewsTitleMatch"=$TITLE_MATCH
  "InpNewsShiftMinutes"="0"; "InpBuyOffsetPips"="3.0"; "InpSellOffsetPips"="2.0"; "InpTPpips"="30.0"
  "InpSLpips"="25.0"; "InpUseOCO"="false"; "InpCloseAtExpiry"="true"; "InpUseTrail25"="false"
  "InpTrailTriggerPips"="25.0"; "InpTrailNewSLpips"="15.0"; "InpFridayClose"="true"; "InpFridayCloseHour"="21"
  "InpFridayCloseMin"="50"; "InpRiskPercent"="0.65"; "InpRiskRefSLpips"="50.0"; "InpComment"="USD1330 PostNews"
  "InpMaxSpread"="0"; "InpVerbose"="true"; "InpAutoTest"="true"
}
$AssiAttesi = [ordered]@{ "InpMagic" = ("" + $MAGIC1 + "||" + $MAGIC1 + "||5||" + $MAGIC2 + "||Y") }

# IL GATE DEL PROVA: @SIMBOLO/@PERIODO esatti, @DAQUANDO/@FINOA ASSENTI
# (se compaiono, ci si ferma: sarebbero una data indovinata che scavalca
# la misura di fase 8), UN asse esatto con celle ricontate, 31 fissi
# nome per nome, nessuna riga estranea (34 righe vive attese).
function GateProva([string]$percorso,[string]$pf){
  $lettura = LeggiProva $percorso $pf
  $h = $lettura.Mappa; $assi = $lettura.Assi
  if($h["@SIMBOLO"] -ne $Simbolo){ throw ($pf + ": @SIMBOLO e' '" + $h["@SIMBOLO"] + "', atteso " + $Simbolo) }
  if($h["@PERIODO"] -ne $Periodo){ throw ($pf + ": @PERIODO e' '" + $h["@PERIODO"] + "', atteso " + $Periodo) }
  if($h.ContainsKey("@DAQUANDO")){ throw ($pf + ": @DAQUANDO e' PRESENTE ('" + $h["@DAQUANDO"] + "') ma DEVE essere assente: il Modello 1 vuole la data VERA delle barre M1, misurata dalla fase 8 di questa riga, mai scritta a mano nel prova.") }
  if($h.ContainsKey("@FINOA")){ throw ($pf + ": @FINOA e' PRESENTE ('" + $h["@FINOA"] + "') ma DEVE essere assente: la finestra finale si passa con -Fino della riga, non dal prova.") }
  if(@($assi).Count -ne 1 -or (@($assi) -notcontains "InpMagic")){ throw ($pf + ": deve avere ESATTAMENTE 1 asse Y (InpMagic). Trovati: " + @($assi).Count + " {" + (@($assi) -join ", ") + "}.") }
  if($h["InpMagic"] -ne $AssiAttesi["InpMagic"]){ throw ($pf + ": InpMagic e' '" + $h["InpMagic"] + "', atteso '" + $AssiAttesi["InpMagic"] + "'.") }
  $nc = CelleAsse $h["InpMagic"] "InpMagic"
  if($nc -ne $NCELLE_ATTESE){ throw ($pf + ": il pin ||Y di InpMagic da' " + $nc + " celle, attese " + $NCELLE_ATTESE + ".") }
  foreach($k in @($FissiAttesi.Keys)){
    if(-not $h.ContainsKey($k)){ throw ($pf + ": manca la riga '" + $k + "' (fisso dichiarato: va verificabile nell'.ini).") }
    if($h[$k] -match '\|\|Y\s*$'){ throw ($pf + ": " + $k + " e' SWEEPATO ma qui e' un fisso: questo round ha UN SOLO asse (InpMagic).") }
    $v = ($h[$k] -split '\|\|')[0].Trim()
    if($v -ne $FissiAttesi[$k]){ throw ($pf + ": " + $k + " e' '" + $v + "', atteso '" + $FissiAttesi[$k] + "'.") }
  }
  $attese = 2 + @($FissiAttesi.Keys).Count + 1   # @SIMBOLO + @PERIODO + 31 fissi + 1 asse = 34
  if(@($h.Keys).Count -ne $attese){ throw ($pf + ": " + @($h.Keys).Count + " righe vive invece di " + $attese + ": c'e' una riga estranea o ne manca una.") }
  return @{ Lettura=$lettura; Celle=$nc }
}

# legge un .set (Nome=Valore, commenti ';') in una mappa semplice.
function LeggiSet([string]$percorso){
  $mappa = [ordered]@{}
  foreach($r in (Get-Content -LiteralPath $percorso)){
    $t = $r.Trim()
    if($t -eq "" -or $t.StartsWith(";")){ continue }
    $i = $t.IndexOf("=")
    if($i -lt 0){ continue }
    $mappa[$t.Substring(0,$i).Trim()] = $t.Substring($i+1).Trim()
  }
  return $mappa
}

# GATE DI COERENZA prova<->preset (fase 4): i 31 fissi combaciano uno a
# uno, il preset ha ESATTAMENTE i 31 fissi + InpMagic (32 chiavi), e
# InpMagic del preset e' il LEAD dell'asse (774801).
function GateCoerenzaPreset($mappaSet){
  $attese = @($FissiAttesi.Keys) + @("InpMagic")
  foreach($k in $attese){ if(-not $mappaSet.Contains($k)){ throw ("preset " + $PRESET_FILE + ": manca la riga '" + $k + "'.") } }
  if(@($mappaSet.Keys).Count -ne $attese.Count){ throw ("preset " + $PRESET_FILE + ": " + @($mappaSet.Keys).Count + " righe invece di " + $attese.Count + " (31 fissi + InpMagic): preset e prova non sono piu' lo stesso contratto.") }
  $diff = New-Object System.Collections.ArrayList
  foreach($k in @($FissiAttesi.Keys)){ if(("" + $mappaSet[$k]) -ne $FissiAttesi[$k]){ [void]$diff.Add($k + ": preset='" + $mappaSet[$k] + "' prova='" + $FissiAttesi[$k] + "'") } }
  if($diff.Count -gt 0){ throw ("preset " + $PRESET_FILE + " e prova " + $PROVA_FILE + " DIVERGONO su: " + ($diff -join " | ")) }
  $leadAtteso = "" + $MAGIC1
  if(("" + $mappaSet["InpMagic"]) -ne $leadAtteso){ throw ("preset " + $PRESET_FILE + ": InpMagic e' '" + $mappaSet["InpMagic"] + "', atteso il lead dell'asse (" + $leadAtteso + ").") }
  return "VALIDO: 31 fissi identici uno a uno, InpMagic preset (" + $leadAtteso + ") = lead dell'asse prova (" + $AssiAttesi["InpMagic"] + ")"
}

# =====================================================================
#  IL CONTA-OCCASIONI (fase 4 per il totale, fase 8-bis per finestra).
#  Rifa' A MANO il filtro che l'EA applica in LoadNews(): impatto >= 3
#  ("High"), valuta contenuta in InpNewsCurrencies, titolo che CONTIENE
#  InpNewsTitleMatch. Poi riduce a GIORNATE DISTINTE, perche' gPlacedDay
#  dell'EA concede UN SOLO piazzamento al giorno.
#  >>> Serve a sapere se il round e' GIRATO, non a giudicarlo:
#      un'occasione (= una giornata) puo' produrre 0, 1 o 2 operazioni.
# =====================================================================
function LeggiCalendario([string]$path){
  $righe = @(Get-Content -LiteralPath $path)
  $utili = 0
  $giorni = New-Object System.Collections.ArrayList
  $visti = @{}
  for($i=1; $i -lt $righe.Count; $i++){
    $r = ("" + $righe[$i]).Trim()
    if($r -eq ""){ continue }
    $c = $r -split ';'
    if($c.Count -lt 4){ continue }
    $dataOra = $c[0].Trim(); $imp = $c[1].Trim().ToUpper(); $ccy = $c[2].Trim(); $tit = $c[3].Trim()
    # impatto: l'EA mappa HIGH->3, MED->2, altro->1; il preset chiede >=3
    if($imp -notlike "*HIGH*" -and $imp -ne "3"){ continue }
    if($ccy -ne "USD"){ continue }                       # InpNewsCurrencies=USD
    if($tit.IndexOf($TITLE_MATCH) -lt 0){ continue }     # InpNewsTitleMatch, come StringFind
    $utili++
    $g = ($dataOra -split '\s+')[0]
    if(-not $visti.ContainsKey($g)){ $visti[$g] = 1; [void]$giorni.Add($g) }
  }
  $ord = @($giorni | Sort-Object)
  return [pscustomobject]@{ Utili=$utili; Giorni=$ord; Primo=$(if($ord.Count -gt 0){ $ord[0] } else { "-" }); Ultimo=$(if($ord.Count -gt 0){ $ord[$ord.Count-1] } else { "-" }) }
}
function ContaFraDate($giorni,[datetime]$da,[datetime]$a){
  $n = 0
  foreach($g in $giorni){
    try{ $d = [datetime]::ParseExact($g,"yyyy.MM.dd",$INV) }catch{ continue }
    if($d -ge $da -and $d -le $a){ $n++ }
  }
  return $n
}

# UNA COMPILAZIONE con metaeditor64 diretto. MUTO = niente log e niente
# .ex5 dopo 20s (il rc=0 muto gia' pagato altrove).
function Compila([string]$exe,[string]$mq5,[string]$ex5,[string]$log,[int]$tetto){
  Remove-Item -LiteralPath $ex5 -Force -ErrorAction SilentlyContinue
  Remove-Item -LiteralPath $log -Force -ErrorAction SilentlyContinue
  $t0 = Get-Date
  Dico ("metaeditor64: /compile:" + $mq5 + " /log:" + $log) "Yellow"
  & $exe ("/compile:" + $mq5) ("/log:" + $log) | Out-Null
  $muto = $false; $battito = 0
  while($true){
    if((Test-Path -LiteralPath $ex5) -and ((Get-Item -LiteralPath $ex5).LastWriteTime -ge $t0)){ break }
    $r = LeggiTesto $log
    if(@($r).Count -gt 0 -and (@($r) -match 'Result:').Count -gt 0){ break }
    $sec = (New-TimeSpan -Start $t0 -End (Get-Date)).TotalSeconds
    if(@($r).Count -eq 0 -and $sec -ge 20){ $muto = $true; break }
    if($sec -ge $tetto){ break }
    if($sec -ge ($battito + 10)){ $battito = [int]$sec; Dico ("   ... aspetto l'.ex5 da " + $battito + "s (tetto " + $tetto + "s): NON interrompere") }
    Start-Sleep -Seconds 2
  }
  $fresco = ((Test-Path -LiteralPath $ex5) -and ((Get-Item -LiteralPath $ex5).LastWriteTime -ge $t0))
  return @{ Ex5=$fresco; Log=(LeggiTesto $log); Muto=$muto }
}

# I LOG DEL TESTER: cinque radici (gli agent NON stanno sotto la
# cartella dati). Si fotografa la lunghezza PRIMA e si legge SOLO cio'
# che e' cresciuto.
$script:RadiciLog = @(); $script:LenPrima = @{}
function FotografaLog(){
  $script:RadiciLog = @()
  if($env:APPDATA){ $script:RadiciLog += (Join-Path $env:APPDATA "MetaQuotes\Tester") }
  if($DataFolder){  $script:RadiciLog += (Join-Path $DataFolder "Tester"); $script:RadiciLog += (Join-Path $DataFolder "Logs"); $script:RadiciLog += (Join-Path $DataFolder "MQL5\Logs") }
  if($InstDir){     $script:RadiciLog += (Join-Path $InstDir "Tester") }
  $script:LenPrima = @{}
  foreach($rad in $script:RadiciLog){
    if(-not (Test-Path -LiteralPath $rad)){ continue }
    foreach($f in @(Get-ChildItem -LiteralPath $rad -Recurse -File -Filter "*.log" -ErrorAction SilentlyContinue)){ $script:LenPrima[$f.FullName] = $f.Length }
  }
  Dico ("log gia' presenti nelle radici del tester, fotografati: " + $script:LenPrima.Count) "DarkGray"
}
function RaccogliLog(){
  $n = 0
  $pattern = 'ticks data begins|no memory|generat|not exist|cannot|error|\[PostNews\]'
  foreach($rad in $script:RadiciLog){
    if(-not (Test-Path -LiteralPath $rad)){ continue }
    foreach($f in @(Get-ChildItem -LiteralPath $rad -Recurse -File -Filter "*.log" -ErrorAction SilentlyContinue)){
      $da = 0
      if($script:LenPrima.ContainsKey($f.FullName)){ $da = [int64]$script:LenPrima[$f.FullName] }
      if($f.Length -le $da){ continue }
      $n++
      # SOLO la coda nuova (da $da in poi), MAI il file intero: senza il seek,
      # un log gia' scritto da una corsa PRECEDENTE nello stesso giorno (stesso
      # file 20260905.log) verrebbe riletto da capo, e le righe VECCHIE (con i
      # loro eventuali problemi gia' superati) rientrerebbero come se fossero
      # di QUESTA corsa. I log del tester sono UTF-16LE (LeggiTesto lo rileva
      # dal BOM iniziale; qui il BOM non c'e' piu' perche' si legge da meta'
      # file, quindi si forza Unicode, stessa codifica di CodaLogStorico sopra).
      $nuovo = ""
      try{
        $daAllineato = $da
        if($daAllineato % 2 -ne 0){ $daAllineato = $daAllineato - 1 }
        $fs = New-Object System.IO.FileStream($f.FullName,[System.IO.FileMode]::Open,[System.IO.FileAccess]::Read,[System.IO.FileShare]::ReadWrite)
        if($daAllineato -gt 0){ [void]$fs.Seek($daAllineato,[System.IO.SeekOrigin]::Begin) }
        $sr = New-Object System.IO.StreamReader($fs,[System.Text.Encoding]::Unicode,$false)
        $nuovo = $sr.ReadToEnd(); $sr.Close(); $fs.Close()
      } catch { $nuovo = "" }
      foreach($l in @($nuovo -split "`r`n|`n|`r")){
        if($l -match $pattern){ [void]$RigheLog.Add(($f.Name + ": " + $l.Trim())) }
      }
      try{ Copy-Item -LiteralPath $f.FullName -Destination (Join-Path $Work ("log_" + $f.Name)) -Force -ErrorAction SilentlyContinue }catch{}
    }
  }
  return $n
}

# =====================================================================
#  LA MISURA DELLO STORICO M1 (fase 8). Ricalca scarica_storico.ps1
#  (stesso EA ABTG_HistoryDownloader, stessa euristica di attesa), ma
#  SUL TERMINALE GIA' RISOLTO da questa riga (fase 5): niente auto-
#  selezione separata, niente rischio di misurare su un terminale e
#  testare su un altro.
# =====================================================================
function MisuraStoricoUnaVolta([string]$mq5Path,[string]$metaEditor,[string]$terminal,[string]$dataFolder,[int]$timeoutMin){
  # RI-GUARDIA (classe di casa): fra un tentativo e l'altro, o fra il
  # giro a vuoto e la corsa vera, MT5 potrebbe essere stato riaperto a
  # mano. Non si presume: si ricontrolla PRIMA di scrivere nel terminale.
  if(Get-Process terminal64,metaeditor64 -ErrorAction SilentlyContinue){
    throw "MT5 O METAEDITOR APERTO (ricontrollato subito prima della misura storico): chiudili e rilancia LA STESSA riga."
  }
  $dstDir = Join-Path $dataFolder "MQL5\Scripts"
  New-Item -ItemType Directory -Force -Path $dstDir | Out-Null
  $dstMq5 = Join-Path $dstDir $HISTDL
  Copy-Item -LiteralPath $mq5Path -Destination $dstMq5 -Force
  $ex5 = [System.IO.Path]::ChangeExtension($dstMq5,".ex5")
  $logHD = Join-Path $Work "COMPILAZIONE_HISTDL.log"
  $esitoC = Compila $metaEditor $dstMq5 $ex5 $logHD 90
  if(-not $esitoC.Ex5){ throw ("ABTG_HistoryDownloader.mq5 non si e' compilato: impossibile misurare lo storico M1. Log: " + ($esitoC.Log -join " | ")) }

  $presetDir = Join-Path $dataFolder "MQL5\Presets"
  New-Item -ItemType Directory -Force -Path $presetDir | Out-Null
  $setFile = Join-Path $presetDir "abtg_storico_postnews_1330_m1.set"
@"
InpSimboli=$Simbolo
InpTimeframes=M1
InpDataInizio=$DaQuandoRichiesta
InpListaSoloNomi=false
InpTuttiBroker=false
InpTimeoutSec=120
InpScaricaTick=false
InpTolleranzaGG=4
"@ | Set-Content -Path $setFile -Encoding ASCII

  $csvOut = Join-Path $dataFolder "MQL5\Files\ABTG_StoricoScaricato.csv"
  Remove-Item -LiteralPath $csvOut -Force -ErrorAction SilentlyContinue

  $ini = Join-Path $Work "gen_storico_postnews_1330.ini"
  # [Experts] AllowLiveTrading=false: STESSA ragione di walkforward_generico
  # e di scarica_storico.ps1 -- /config apre IL TERMINALE (non un tester),
  # che carica l'ultimo profilo coi suoi grafici. Sul PC di backtest quel
  # terminale e' collegato al conto VIVO 50503392: senza questa riga, uno
  # script che gira riarmerebbe di fatto gli EA su grafico.
@"
[Experts]
AllowLiveTrading=false
AllowDllImport=false

[Charts]
MaxBars=2000000000

[StartUp]
Script=ABTG_HistoryDownloader
ScriptParameters=abtg_storico_postnews_1330_m1.set
Symbol=$Simbolo
Period=M1
"@ | Set-Content -Path $ini -Encoding Unicode

  Dico ("misura storico: avvio MT5 in automatico (tetto " + $timeoutMin + " min, SOLO M1, SENZA tick)...") "Cyan"
  Start-Process -FilePath $terminal -ArgumentList ("/config:`"" + $ini + "`"")

  $logDirW = Join-Path $dataFolder "MQL5\Logs"
  $lenPrima = @{}
  if(Test-Path -LiteralPath $logDirW){
    foreach($f in @(Get-ChildItem -LiteralPath $logDirW -Filter "*.log" -ErrorAction SilentlyContinue)){ $lenPrima[$f.FullName] = $f.Length }
  }
  # LEGGE SOLO cio' che i log hanno scritto DOPO la fotografia: un file
  # non cresciuto e' il log di IERI (difetto gia' pagato altrove: MAI
  # rileggere un log da capo solo perche' non e' cresciuto).
  function CodaLogStorico(){
    if(-not (Test-Path -LiteralPath $logDirW)){ return "" }
    $tutto = ""
    foreach($f in @(Get-ChildItem -LiteralPath $logDirW -Filter "*.log" -ErrorAction SilentlyContinue)){
      $da = 0
      if($lenPrima.ContainsKey($f.FullName)){ $da = [int64]$lenPrima[$f.FullName] }
      if($da % 2 -ne 0){ $da = $da - 1 }
      try{
        $fs = New-Object System.IO.FileStream($f.FullName,[System.IO.FileMode]::Open,[System.IO.FileAccess]::Read,[System.IO.FileShare]::ReadWrite)
        if($da -ge $fs.Length){ $fs.Close(); continue }
        if($da -gt 0){ [void]$fs.Seek($da,[System.IO.SeekOrigin]::Begin) }
        $sr = New-Object System.IO.StreamReader($fs,[System.Text.Encoding]::Unicode,$false)
        $tutto = $tutto + $sr.ReadToEnd(); $sr.Close(); $fs.Close()
      }catch{}
    }
    return $tutto
  }
  # IL PROGRESSO VERO STA IN bases\ (imparato altrove il 23/08): il CSV
  # lo scrive l'EA SOLO alla fine. Qui si legge SOLO la dimensione,
  # bases\ non si tocca MAI in scrittura.
  function BattitoBasi(){
    $tot = [long]0
    $d = Join-Path $dataFolder "bases"
    if(-not (Test-Path -LiteralPath $d)){ return $tot }
    try{
      foreach($srv in @(Get-ChildItem -LiteralPath $d -Directory -ErrorAction SilentlyContinue)){
        $p = Join-Path $srv.FullName "history"
        if(-not (Test-Path -LiteralPath $p)){ continue }
        $m = Get-ChildItem -LiteralPath $p -Recurse -File -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum
        if($m -and $m.Sum){ $tot += [long]$m.Sum }
      }
    }catch{}
    return $tot
  }

  $scaduto = (Get-Date).AddMinutes($timeoutMin)
  $ultimaLen = -1; $ultimaBasi = -1; $fermoDa = 0; $visto = $false; $finito = $false
  while((Get-Date) -lt $scaduto){
    Start-Sleep -Seconds 15
    $coda = CodaLogStorico
    if($coda -match "=== FINITO"){ Dico "  lo script ha stampato la sua riga di chiusura: ha finito." "Green"; $visto = $true; $finito = $true; break }
    if($coda -match "ABTG_HistoryDownloader"){ $visto = $true }
    $len = 0
    if(Test-Path -LiteralPath $csvOut){ $visto = $true; try{ $len = (Get-Item -LiteralPath $csvOut -ErrorAction Stop).Length }catch{ $len = 0 } }
    $basi = BattitoBasi
    if($len -ne $ultimaLen -or $basi -ne $ultimaBasi){
      $fermoDa = 0
      Dico ("  ... CSV " + $len + " byte, storico bases " + [int]($basi/1MB) + " MB") "DarkGray"
      $ultimaLen = $len; $ultimaBasi = $basi
    } else {
      $fermoDa += 15
      if($fermoDa -ge 900){ Dico "  fermo da 15 minuti senza riga di chiusura e senza crescita dello storico: mi fermo qui." "Yellow"; break }
    }
  }

  Dico "  chiudo MT5 (misura storico)..." "DarkGray"
  Get-Process -Name "terminal64" -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
  Start-Sleep -Seconds 3

  $righe = $null
  if(Test-Path -LiteralPath $csvOut){
    try{
      $fs = [System.IO.File]::Open($csvOut,'Open','Read','ReadWrite')
      $sr = New-Object System.IO.StreamReader($fs)
      $testo = $sr.ReadToEnd(); $sr.Close(); $fs.Close()
      if(-not [string]::IsNullOrWhiteSpace($testo)){ $righe = ($testo | ConvertFrom-Csv) }
    }catch{}
  }
  return @{ Visto=$visto; Finito=$finito; Righe=$righe; CsvOut=$csvOut }
}

# =====================================================================
#  Il referto del canarino NEWS (letto dai LOG, non dal CSV).
# =====================================================================
function LeggiCanarinoNews($righeLog){
  $nRighe = @($righeLog | Where-Object { $_ -match '\[PostNews\]\[NEWS\] letto da' })
  $nCieco = @($righeLog | Where-Object { $_ -match 'CALENDARIO CIECO' })
  $nRosso = @($righeLog | Where-Object { $_ -match 'CANARINO ROSSO' })
  $valori = New-Object System.Collections.ArrayList
  foreach($r in $nRighe){
    $m = [regex]::Match($r,'UTILI per questo preset\s+(-?\d+)')
    if($m.Success){ [void]$valori.Add([int]$m.Groups[1].Value) }
  }
  return [pscustomobject]@{ Righe=$nRighe; Cieco=$nCieco; Rosso=$nRosso; Valori=$valori }
}
function LeggiAutotestLog($righeLog){
  $righe = @($righeLog | Where-Object { $_ -match '\[PostNews\]\[AUTOTEST\] ---- fine:' })
  $valori = New-Object System.Collections.ArrayList
  foreach($r in $righe){
    $m = [regex]::Match($r,'---- fine:\s+(-?\d+)\s+casi falliti')
    if($m.Success){ [void]$valori.Add([int]$m.Groups[1].Value) }
  }
  return [pscustomobject]@{ Righe=$righe; Valori=$valori }
}

# LEGGE UN CSV OPTFRAME (9 colonne: Pass,Profit,Expected Payoff,Profit
# Factor,Recovery Factor,Sharpe Ratio,Equity DD %,Trades,InpMagic).
$ColonneServono = @("Pass","Profit","Expected Payoff","Profit Factor","Recovery Factor","Sharpe Ratio","Equity DD %","Trades","InpMagic")
function LeggiCsv([string]$path,[string]$et){
  $lin = @(Get-Content -LiteralPath $path | Where-Object { $_.Trim() -ne "" })
  if($lin.Count -lt 1){ [void]$Problemi.Add($et + ": CSV vuoto (nemmeno l'header)."); return $null }
  $head = $lin[0] -split ','
  $ix = @{}
  for($i=0;$i -lt $head.Count;$i++){ $ix[$head[$i].Trim()] = $i }
  $manca = @($ColonneServono | Where-Object { -not $ix.ContainsKey($_) })
  if($manca.Count -gt 0){ [void]$Problemi.Add($et + ": nel CSV mancano le colonne: " + ($manca -join ", ") + " (header OPTFRAME cambiato nell'EA?)."); return $null }
  $righe = New-Object System.Collections.ArrayList
  for($i=1;$i -lt $lin.Count;$i++){
    $cols = $lin[$i] -split ','
    if($cols.Count -lt $head.Count){ [void]$Problemi.Add($et + ": riga " + $i + " del CSV ha meno colonne dell'header: non la leggo."); continue }
    $g = @{}
    foreach($k in $ix.Keys){ $g[$k] = $cols[$ix[$k]].Trim() }
    $r = [pscustomobject]@{ Grezzo=$g; Magic=[long](Num $g["InpMagic"])
      Profit=(Num $g["Profit"]); Payoff=(Num $g["Expected Payoff"]); PF=(Num $g["Profit Factor"])
      RF=(Num $g["Recovery Factor"]); Sharpe=(Num $g["Sharpe Ratio"]); DD=(Num $g["Equity DD %"]); N=[int](Num $g["Trades"]) }
    [void]$righe.Add($r)
  }
  return $righe
}

# I GEMELLI 774801/774806: righe IDENTICHE su tutte le colonne tranne
# Pass e InpMagic (stesso motore, stesso rischio: solo il magic cambia).
function GateGemelli($righe,[string]$et){
  $a = @($righe | Where-Object { $_.Magic -eq $MAGIC1 }); $b = @($righe | Where-Object { $_.Magic -eq $MAGIC2 })
  if($a.Count -ne 1 -or $b.Count -ne 1){ [void]$Problemi.Add($et + ": non ho ESATTAMENTE una passata per magic (" + $a.Count + "/" + $b.Count + "): griglia incompleta o cache."); return "ROTTI O NON VERIFICABILI" }
  $diff = New-Object System.Collections.ArrayList
  foreach($k in $a[0].Grezzo.Keys){
    if($k -eq "Pass" -or $k -eq "InpMagic"){ continue }
    if($a[0].Grezzo[$k] -ne $b[0].Grezzo[$k]){ [void]$diff.Add($k) }
  }
  if($diff.Count -gt 0){ [void]$Problemi.Add($et + ": GEMELLI DIVERGONO (" + $MAGIC1 + " contro " + $MAGIC2 + "): " + ($diff -join ", ") + ". Banco sporco: la corsa e' FERMA."); return "ROTTI: " + ($diff -join ", ") }
  return "IDENTICI al centesimo (magic " + $MAGIC1 + " = magic " + $MAGIC2 + " su tutte le colonne tranne Pass/InpMagic)"
}

# legge la finestra di una corsa: data il CSV, conta le righe, collauda.
function LeggiFinestra([string]$tag,[datetime]$tCorsa){
  $csv = Join-Path $Work ("risultati_prove\" + $EA + "\" + $EA + "_" + $Simbolo + "_" + $tag + "_ohlc_" + $Etichetta + ".csv")
  $et = $tag
  $ris = [pscustomobject]@{ Csv=$csv; CsvOra="n/d"; Letto=$false; NRighe=-1; Righe=$null; Gemelli="NON VERIFICATO"; PerMagic=@{} }
  if(-not (Test-Path -LiteralPath $csv)){ [void]$Problemi.Add($et + ": CSV OPTFRAME NON prodotto: " + $csv); return $ris }
  $itm = Get-Item -LiteralPath $csv
  $ris.CsvOra = $itm.LastWriteTime.ToString("yyyy-MM-dd HH:mm:ss",$INV)
  if($itm.LastWriteTime -lt $tCorsa){
    [void]$Problemi.Add($et + ": CSV STANTIO, NON LETTO. Scritto alle " + $ris.CsvOra + ", PRIMA dell'avvio di questa corsa: e' il reperto di una corsa precedente. Questa finestra NON ha numeri.")
    return $ris
  }
  $righe = LeggiCsv $csv $et
  if($null -eq $righe){ return $ris }
  $ris.NRighe = $righe.Count
  if($ris.NRighe -ne $NCELLE_ATTESE){ [void]$Problemi.Add($et + ": " + $ris.NRighe + " righe nel CSV, " + $NCELLE_ATTESE + " passate chieste (cache del tester? storico?). Il round NON si legge.") }
  if($ris.NRighe -le 0){ return $ris }
  $ris.Righe = $righe; $ris.Letto = $true
  $ris.Gemelli = GateGemelli $righe $et
  foreach($r in $righe){ $ris.PerMagic["" + $r.Magic] = $r }
  return $ris
}

function LanciaGenerico([string]$drv,[string]$prova,[string]$daQuando){
  $argv = @("-ExecutionPolicy","Bypass","-File",$drv,
            "-Expert",$EA, "-Prova",$prova, "-Etichetta",$Etichetta,
            "-Simbolo",$Simbolo, "-Periodo",$Periodo,
            "-DaQuando",$daQuando, "-Fino",$Fino,
            "-FrazioneIS",("" + $FrazioneIS), "-Modello","1",
            "-Rifai", "-Deposito",("" + $Deposito))
  if($Terminale -ne ""){ $argv += @("-Terminal",(Join-Path $Terminale "terminal64.exe"),"-MetaEditor",(Join-Path $Terminale "metaeditor64.exe")) }
  if($SoloControllo){ $argv += "-SoloControllo" }
  Dico ("argv generico: " + ($argv -join " "))
  $global:LASTEXITCODE = $null
  & powershell $argv
  $rc = $LASTEXITCODE
  $rcLetto = ($null -ne $rc -and (("" + $rc).Trim()) -match '^-?\d+$')
  if($rcLetto -and [int]$rc -ne 0){ [void]$Problemi.Add("il generico e' uscito con codice " + $rc + " (storico mancante? CSV non prodotto? MT5 aperto?).") }
  elseif(-not $rcLetto){ [void]$Rilievi.Add("codice di uscita del generico NON LETTO (capita su PS 5.1): NON e' un fallimento, fanno fede i CSV datati.") }
}

try{
  Titolo ("POSTNEWS USD1330/USDJPY -- PASSO 0 (" + $EA + ") -- modo " + $Modo)

  # -------------------------------------------------------------------
  #  0. LE GUARDIE, PRIMA DI TOCCARE QUALUNQUE COSA
  # -------------------------------------------------------------------
  if($Pin -eq ""){ throw "-Pin obbligatorio: senza, girerebbe la punta del branch spacciandola per un commit congelato." }
  if($Pin -notmatch '^[0-9a-f]{40}$'){ throw ("-Pin deve essere un commit di 40 caratteri esadecimali, ricevuto: " + $Pin) }
  if($PavimentoDaQuando -notmatch '^\d{4}\.\d{2}\.\d{2}$'){ throw ("-PavimentoDaQuando deve essere yyyy.MM.dd, ricevuto: " + $PavimentoDaQuando) }
  if($Fino -notmatch '^\d{4}\.\d{2}\.\d{2}$'){ throw ("-Fino deve essere yyyy.MM.dd, ricevuto: " + $Fino) }
  if($SaltaMisuraStorico -and $DaQuandoGiaMisurata -eq ""){ throw "-SaltaMisuraStorico richiede -DaQuandoGiaMisurata (la data GIA' misurata da un giro precedente nella STESSA sessione di lavoro): senza, sarebbe una data indovinata." }
  if(Get-Process terminal64,metaeditor64 -ErrorAction SilentlyContinue){
    throw "MT5 O METAEDITOR APERTO: col terminale aperto ne' lo script di misura ne' il tester possono girare puliti (zero CSV/CSV sporco), con MetaEditor aperto la compilazione torna subito senza compilare. Chiudili e rilancia."
  }
  New-Item -ItemType Directory -Force -Path $Work,$Prove | Out-Null
  # LA SENTINELLA DEL GIRO PRECEDENTE (classe 116): se un giro e' stato
  # interrotto fra l'installazione dell'include e il ripristino, qui si
  # rimette a posto PRIMA di tutto.
  if(Test-Path -LiteralPath $Sentinella){
    $rigaS = @(Get-Content -LiteralPath $Sentinella -ErrorAction SilentlyContinue)
    $sDest = ""; $sBack = ""
    if(@($rigaS).Count -ge 1){ $sDest = ("" + $rigaS[0]).Trim() }
    if(@($rigaS).Count -ge 2){ $sBack = ("" + $rigaS[1]).Trim() }
    $esitoS = "niente da fare"
    if($sDest -ne "" -and (Test-Path -LiteralPath $sDest)){
      if($sBack -ne "" -and (Test-Path -LiteralPath $sBack)){
        Copy-Item -LiteralPath $sBack -Destination $sDest -Force
        Remove-Item -LiteralPath $sBack -Force -ErrorAction SilentlyContinue
        $esitoS = "include ripristinato dal backup " + $sBack
      } else { Remove-Item -LiteralPath $sDest -Force -ErrorAction SilentlyContinue; $esitoS = "include rimosso (non c'era prima di quel giro)" }
    }
    Remove-Item -LiteralPath $Sentinella -Force -ErrorAction SilentlyContinue
    [void]$Rilievi.Add("UN GIRO PRECEDENTE ERA STATO INTERROTTO prima del ripristino: " + $esitoS + ", adesso, all'avvio di questo giro.")
    Dico ("sentinella di un giro interrotto: " + $esitoS) "Yellow"
  }
  Dico ("pin ......... " + $Pin)
  Dico ("simbolo ..... " + $Simbolo + " (fisso: il gemello CROSS-SIMBOLO su EURUSD e' un altro round, magic 774802)")
  Dico ("banco ....... MODELLO 1 (1 minuto OHLC = SCREENING) | @PERIODO " + $Periodo + " | deposito " + $Deposito + " | rischio 0,65%/evento (0,325%/ordine)") "Yellow"
  Dico ("finestra .... pavimento " + $PavimentoDaQuando + " | -Fino " + $Fino + " (il calendario di questo blocco finisce nel 2023)") "Yellow"
  Dico ("celle ....... " + $NCELLE_ATTESE + " (InpMagic " + $MAGIC1 + "/" + $MAGIC2 + ", gemelle: DEVONO uscire identiche)") "Yellow"

  # -------------------------------------------------------------------
  #  1. SCARICO AL PIN
  # -------------------------------------------------------------------
  Titolo "1. SCARICO AL PIN (generico pinnato, EA, include, calendario, preset, prova, history downloader)"
  $drv = Join-Path $Work "walkforward_generico.ps1"
  Scarica ($RawPin + "/backtest_pipeline/walkforward_generico.ps1") $drv
  $t = Get-Content -LiteralPath $drv -Raw
  if($t -notmatch '\$EABranch\s*=\s*"lavoro"'){ throw 'walkforward_generico.ps1 non ha la riga $EABranch = "lavoro" attesa: non lo posso pinnare.' }
  $t = $t -replace '\$EABranch\s*=\s*"lavoro"', ('$EABranch="' + $Pin + '"')
  # IL TETTO DELLE BARRE (checklist 36, gia' portato da RIGA_R107/R111/R114).
  # Se il tester ereditasse il tetto "Max barre nel grafico" del terminale, le
  # serie verrebbero TRONCATE IN SILENZIO e i CSV uscirebbero pieni di numeri
  # coerenti e falsi. Qui morde piu' che altrove: la finestra e' di 14 anni
  # e l'EA legge iHigh/iLow(_Symbol,PERIOD_M5,...).
  # [INFERITO] che il tester onori questa riga: NON e' misurato da nessuna
  # corsa di casa -- si scrive perche' costa zero, non perche' sia provata.
  $t = $t -replace '(?m)^\[Experts\]\r?$', "[Charts]`r`nMaxBars=2000000000`r`n`r`n[Experts]"
  Set-Content -LiteralPath $drv -Value $t -Encoding ASCII
  # GATE SULLO STATO FINALE, non sul replace (checklist 33): si rilegge dal
  # disco il file che verra' DAVVERO eseguito, non la variabile in memoria.
  if(-not (Select-String -LiteralPath $drv -SimpleMatch -Pattern ('$EABranch="' + $Pin + '"') -Quiet)){ throw "walkforward_generico.ps1: il pin di `$EABranch NON risulta scritto nel file su disco (il replace non ha morso): mi fermo." }
  $nMax = @(Select-String -LiteralPath $drv -SimpleMatch -Pattern 'MaxBars=2000000000').Count
  if($nMax -ne 2){ throw ("walkforward_generico.ps1: MaxBars scritto " + $nMax + " volte invece di 2 (anteprima + corsa vera): il generico al pin e' cambiato, mi fermo.") }
  Dico "driver generico scaricato, PINNATO (riscarica l'EA al pin, non dalla punta del branch) e con MaxBars alzato -- stato finale riletto dal disco" "Green"

  Remove-Item -Path (Join-Path $Prove "POSTNEWS_1330_*.txt") -Force -ErrorAction SilentlyContinue
  $provaPath = Join-Path $Prove $PROVA_FILE
  Scarica ($RawPin + "/backtest_pipeline/prove/" + $PROVA_FILE) $provaPath

  $mq5 = Join-Path $Work ($EA + ".mq5")
  $mqh = Join-Path $Work $INC
  Scarica ($RawPin + "/mql5/Experts/" + $EA + ".mq5") $mq5
  $presetPath = Join-Path $Work $PRESET_FILE
  Scarica ($RawPin + "/mql5/Presets/" + $PRESET_FILE) $presetPath
  $calPath = Join-Path $Work $NEWSFILE
  Scarica ($RawPin + "/mql5/Files/" + $NEWSFILE) $calPath
  $histDlPath = Join-Path $Work $HISTDL
  Scarica ($RawPin + "/mql5/Scripts/" + $HISTDL) $histDlPath
  Dico ("scaricati: " + $EA + ".mq5, " + $PRESET_FILE + ", " + $NEWSFILE + ", " + $PROVA_FILE + ", " + $HISTDL) "Green"

  # -------------------------------------------------------------------
  #  2. GATE SUL SORGENTE (identita' dell'EA al pin)
  # -------------------------------------------------------------------
  Titolo "2. GATE SUL SORGENTE: versione, autotest ricalcolato, include censiti, hedge-safe, OnTester"
  $srcRighe = @(LeggiTesto $mq5)
  $vers = @($srcRighe | Where-Object { $_ -match '^\s*#property\s+version\s+"([^"]+)"' } | ForEach-Object { [regex]::Match($_,'"([^"]+)"').Groups[1].Value })
  if($vers.Count -ne 1){ $VersTxt = "NON TROVATA (o doppia): " + $vers.Count + " righe #property version"; throw ("#property version non trovata (o doppia) in " + $EA + ".mq5: " + $vers.Count + " righe.") }
  $VersTxt = $vers[0]
  if($VersTxt -ne $VERSIONE_ATTESA){ throw ("versione letta '" + $VersTxt + "', attesa '" + $VERSIONE_ATTESA + "': il file al pin NON e' l'EA firmato.") }

  # NESSUN #define per i casi dell'autotest: si RICALCOLA dal sorgente
  # appena scaricato, sempre, non da un numero scritto qui per sempre.
  $srcRaw = ($srcRighe -join "`n")
  $nAT   = @([regex]::Matches($srcRaw,'falliti\s*\+=\s*AT_Caso\(')).Count
  $nPP   = @([regex]::Matches($srcRaw,'if\s*\(\s*!\w+\s*\)\s*falliti\+\+;')).Count
  $nCasiTotali = $nAT + $nPP
  $AutotestTxt = "" + $nAT + " AT_Caso() + " + $nPP + " controlli 'if(!X) falliti++;' = " + $nCasiTotali + " casi totali (nessun #define nel sorgente: RICALCOLATO ora dal file al pin, non un numero scritto a mano)"
  if($nAT -ne $AT_CASO_ATTESI -or $nPP -ne $FALLITIPP_ATTESI){ throw ("autotest: " + $AutotestTxt + " -- atteso " + $AT_CASO_ATTESI + " AT_Caso() + " + $FALLITIPP_ATTESI + " controlli = " + $CASI_TOTALI_ATTESI + ". Il sorgente e' cambiato: il gate NON si aggiorna da solo, va rivisto a mano.") }

  if($srcRaw -notmatch 'double\s+OnTester\s*\('){ throw ("" + $EA + ".mq5 NON esporta i risultati (manca OnTester): il generico si fermerebbe da solo, ma e' meglio saperlo qui.") }
  $OnTesterTxt = "presente (double OnTester(), OnTesterInit(), OnTesterDeinit() -- OPTFRAME inline, 9 colonne)"

  $hedge = 0
  foreach($riga in $srcRighe){ $viva = ($riga -replace '//.*$',''); if($viva -match 'Position(Select|Close|Modify|ClosePartial)\s*\(\s*_Symbol\s*[\),]'){ $hedge++ } }
  $HedgeTxt = "" + $hedge + " chiamate Position*(_Symbol) fuori dai commenti (attese 0: hedge-safe, usa PositionGetTicket + confronto magic/simbolo)"
  if($hedge -gt 0){ throw ("L'EA NON e' hedge-safe: " + $HedgeTxt + ". Sul conto HEDGING chiuderebbe o modificherebbe la posizione del vicino.") }

  $incl = New-Object System.Collections.ArrayList
  foreach($riga in $srcRighe){ $viva = ($riga -replace '//.*$',''); $m = [regex]::Match($viva,'^\s*#include\s*[<"]([^>"]+)[>"]'); if($m.Success){ [void]$incl.Add($m.Groups[1].Value.Trim()) } }
  $IncTxt = "" + $incl.Count + " (" + ($incl -join ", ") + ")"
  $inattesi = @($incl | Where-Object { $_ -ne "Trade/Trade.mqh" -and $_ -ne $INC })
  if($inattesi.Count -gt 0){ throw ("include NON previsti nel sorgente: " + ($inattesi -join ", ") + ". La riga installa SOLO " + $INC + ".") }
  if(-not ($incl -contains $INC)){ [void]$Rilievi.Add("il sorgente NON include " + $INC + ": l'include Guardian non viene installato.") }
  Dico ("versione " + $VersTxt + " | autotest " + $AutotestTxt + " | OnTester " + $OnTesterTxt + " | " + $HedgeTxt + " | include " + $IncTxt) "Green"
  if($incl -contains $INC){
    Scarica ($RawPin + "/mql5/Include/" + $INC) $mqh
    $ng = @((LeggiTesto $mqh) | Where-Object { $_ -match '^\s*bool\s+ABTG_GuardiaIngresso\s*\(' }).Count
    $IncGuardia = "bool ABTG_GuardiaIngresso( trovata " + $ng + " volta; " + (Get-Item -LiteralPath $mqh).Length + " byte"
    if($ng -ne 1){ throw ("l'include al pin non definisce ESATTAMENTE una 'bool ABTG_GuardiaIngresso(' (" + $ng + "): l'EA non compilerebbe con la guardia attesa.") }
    Dico ("include scaricato al pin: " + $IncGuardia) "Green"
  }

  # -------------------------------------------------------------------
  #  3. GATE SUL PROVA (@DAQUANDO/@FINOA ASSENTI, asse, 31 fissi)
  # -------------------------------------------------------------------
  Titolo "3. GATE SUL PROVA (@SIMBOLO/@PERIODO esatti, @DAQUANDO/@FINOA ASSENTI, asse InpMagic, 31 fissi)"
  $gP = GateProva $provaPath $PROVA_FILE
  $CelleTxt = "" + $gP.Celle + " (InpMagic " + $MAGIC1 + "/" + $MAGIC2 + "), ricontate dal pin ||Y al pin. @DAQUANDO/@FINOA verificati ASSENTI: nessuna data indovinata puo' scavalcare la misura di fase 8."
  Dico ("gate prova: PASSATO. celle " + $CelleTxt) "Green"

  # -------------------------------------------------------------------
  #  4. GATE DI COERENZA COL PRESET .set + GATE SUL CALENDARIO
  # -------------------------------------------------------------------
  Titolo "4. GATE DI COERENZA prova <-> preset .set (31 fissi uno a uno + InpMagic lead) e gate sul calendario"
  $mappaSet = LeggiSet $presetPath
  $GemPreset = GateCoerenzaPreset $mappaSet
  Dico ("coerenza prova/preset: " + $GemPreset) "Green"

  # gate sul calendario: intestazione esatta, 464 righe (1 + 463 eventi),
  # e il conteggio delle righe/giornate che passano i filtri del preset
  # RIFATTO QUI a macchina (non un numero copiato dalla riga NFP).
  $calRighe = @(Get-Content -LiteralPath $calPath)
  if(@($calRighe).Count -ne $CAL_RIGHE_ATTESE){ throw ("calendario " + $NEWSFILE + ": " + @($calRighe).Count + " righe, attese " + $CAL_RIGHE_ATTESE + " (1 intestazione + " + ($CAL_RIGHE_ATTESE-1) + " eventi). Il file al pin non e' quello atteso.") }
  if($calRighe[0].Trim() -ne $CAL_INTESTAZIONE){ throw ("calendario " + $NEWSFILE + ": intestazione '" + $calRighe[0] + "', attesa '" + $CAL_INTESTAZIONE + "'.") }
  $cal = LeggiCalendario $calPath
  if($cal.Utili -ne $CAL_UTILI_ATTESI){ throw ("calendario " + $NEWSFILE + ": " + $cal.Utili + " righe passano i filtri di questo preset (impatto>=3, USD, titolo contiene '" + $TITLE_MATCH + "'), attese " + $CAL_UTILI_ATTESI + ". E' lo stesso numero che l'EA stampera' come 'UTILI per questo preset': se non torna qui, non tornera' nemmeno nel log.") }
  if(@($cal.Giorni).Count -ne $CAL_GIORNATE_ATTESE){ throw ("calendario " + $NEWSFILE + ": " + @($cal.Giorni).Count + " GIORNATE distinte, attese " + $CAL_GIORNATE_ATTESE + ".") }
  if($cal.Primo -ne $CAL_PRIMO_ATTESO -or $cal.Ultimo -ne $CAL_ULTIMO_ATTESO){ throw ("calendario " + $NEWSFILE + ": copre dal " + $cal.Primo + " al " + $cal.Ultimo + ", atteso dal " + $CAL_PRIMO_ATTESO + " al " + $CAL_ULTIMO_ATTESO + ".") }
  $GiorniCal = $cal.Giorni
  $CalCsvTxt = "" + @($calRighe).Count + " righe (1 intestazione + " + (@($calRighe).Count-1) + " eventi), intestazione verificata. FILTRI DI QUESTO PRESET (impatto>=3, USD, titolo contiene '" + $TITLE_MATCH + "'): " + $cal.Utili + " righe = " + @($cal.Giorni).Count + " GIORNATE distinte, dal " + $cal.Primo + " al " + $cal.Ultimo + ". NB: nel log del tester l'EA stampera' 'righe " + (@($calRighe).Count-1) + " | UTILI per questo preset " + $cal.Utili + "' (l'intestazione la salta da sola). Verificato ORA, sul repo, che nessun'altra occorrenza dei magic " + $MAGIC1 + "/" + $MAGIC2 + " esiste fuori da preset+prova -- la riga NON puo' riverificarlo a runtime (niente repo sul PC di backtest)."
  Dico ("calendario: " + $CalCsvTxt) "Green"

  # -------------------------------------------------------------------
  #  5. IL TERMINALE DI BACKTEST
  # -------------------------------------------------------------------
  Titolo "5. TERMINALE BCM DI BACKTEST (non -V3) e cartella dati"
  $allTerm = @(Get-ChildItem "C:\Program Files","C:\Program Files (x86)" -Recurse -Filter "terminal64.exe" -ErrorAction SilentlyContinue)
  if($Terminale -ne ""){
    if(-not (Test-Path -LiteralPath (Join-Path $Terminale "terminal64.exe"))){ throw ("-Terminale '" + $Terminale + "' non contiene terminal64.exe.") }
    $InstDir = $Terminale
    $TermTxt = $InstDir + " (imposto con -Terminale)"
  } else {
    $cand = @($allTerm | Where-Object { $_.DirectoryName -like "*BCM Markets MT5 Terminal*" -and $_.DirectoryName -notlike "*-V3*" })
    if($cand.Count -eq 0){ $cand = @($allTerm | Where-Object { $_.DirectoryName -like "*BCM Markets*" -and $_.DirectoryName -notlike "*-V3*" }) }
    if($cand.Count -ne 1){
      Write-Host "  installazioni MT5 con terminal64.exe trovate:" -ForegroundColor Gray
      foreach($tt in $allTerm){ Write-Host ("    " + $tt.DirectoryName) -ForegroundColor Gray }
      if($allTerm.Count -eq 0){ Write-Host "    (nessuna)" -ForegroundColor Gray }
      throw ("NON SO QUALE TERMINALE USARE: candidate BCM non -V3 = " + $cand.Count + ". Rilancia lo stesso blocco aggiungendo al driver: -Terminale '<cartella dell'installazione di backtest, copiata dall'elenco qui sopra>'.")
    }
    $InstDir = $cand[0].DirectoryName
    $TermTxt = $InstDir + " (selettore: BCM Markets, non -V3)"
  }
  $Terminal64  = Join-Path $InstDir "terminal64.exe"
  $MetaEditor  = Join-Path $InstDir "metaeditor64.exe"
  if(-not (Test-Path -LiteralPath $MetaEditor)){ throw ("metaeditor64.exe non trovato in " + $InstDir) }
  $termRoot = Join-Path $env:APPDATA "MetaQuotes\Terminal"
  $DataFolder = (Get-ChildItem $termRoot -Directory -ErrorAction SilentlyContinue | Where-Object { $o = Join-Path $_.FullName "origin.txt"; (Test-Path $o) -and ((Get-Content $o -Raw).Trim() -ieq $InstDir) } | Select-Object -First 1 -ExpandProperty FullName)
  if(-not $DataFolder){
    $portable = Join-Path $InstDir "MQL5"
    if(Test-Path -LiteralPath $portable){ $DataFolder = $InstDir; [void]$Rilievi.Add("cartella dati PORTABLE (dentro l'installazione): nessun origin.txt la puntava.") }
    else{ throw ("cartella dati non trovata per " + $InstDir + " (nessun origin.txt in " + $termRoot + " la punta, e non e' portable).") }
  }
  Dico ("terminale: " + $TermTxt) "Yellow"
  Dico ("cartella dati: " + $DataFolder)

  # -------------------------------------------------------------------
  #  6. FOTO PRIMA, SENTINELLA, INCLUDE, COMPILAZIONE
  # -------------------------------------------------------------------
  Titolo "6. FOTO PRIMA -> sentinella -> include installato -> EA compilato (metaeditor64 diretto)"
  $dstExp = Join-Path $DataFolder "MQL5\Experts"
  $dstInc = Join-Path $DataFolder "MQL5\Include"
  New-Item -ItemType Directory -Force -Path $dstExp,$dstInc | Out-Null
  $TExpMq5 = Join-Path $dstExp ($EA + ".mq5")
  $TExpEx5 = Join-Path $dstExp ($EA + ".ex5")
  $TIncMqh = Join-Path $dstInc $INC
  $F1Prima = Foto $TExpMq5; $F2Prima = Foto $TExpEx5; $F3Prima = Foto $TIncMqh
  $FotoPrese = $true
  Dico ("foto PRIMA -- Experts\" + $EA + ".mq5: " + (FotoTxt $F1Prima))
  Dico ("foto PRIMA -- Experts\" + $EA + ".ex5: " + (FotoTxt $F2Prima))
  Dico ("foto PRIMA -- Include\" + $INC + ": " + (FotoTxt $F3Prima))
  if($incl -contains $INC){
    $IncEraLi = $F3Prima.Esiste
    $bkTxt = "nessun backup: l'include NON c'era"
    if($IncEraLi){ $IncBackup = $TIncMqh + ".prima_postnews_1330_" + $Stamp; Copy-Item -LiteralPath $TIncMqh -Destination $IncBackup -Force; $bkTxt = "backup " + $IncBackup }
    Set-Content -LiteralPath $Sentinella -Value @($TIncMqh, $IncBackup) -Encoding ASCII
    Copy-Item -LiteralPath $mqh -Destination $TIncMqh -Force
    $IncInstallato = $true
    Dico ("include " + $INC + " installato AL PIN in MQL5\Include (" + $bkTxt + "); ripristinato a fine giro") "Yellow"
  }
  Copy-Item -LiteralPath $mq5 -Destination $TExpMq5 -Force
  $esito = Compila $MetaEditor $TExpMq5 $TExpEx5 $logC 240
  $nErr = -1; $nWar = -1
  foreach($r in @($esito.Log)){
    $m = [regex]::Match($r, '(?i)(\d+)\s+error[s]?\s*,\s*(\d+)\s+warning')
    if($m.Success){ $nErr = [int]::Parse($m.Groups[1].Value,$INV); $nWar = [int]::Parse($m.Groups[2].Value,$INV); $ResultTxt = $r.Trim() }
  }
  if($nErr -lt 0){ $ResultTxt = "NON TROVATA nel log (fa fede l'.ex5 fresco)" }
  if($esito.Ex5 -and $nErr -le 0){
    $itm = Get-Item -LiteralPath $TExpEx5
    $Compilato = "OK (" + [int]($itm.Length/1024) + " KB, " + $itm.Length + " byte, " + $itm.LastWriteTime.ToString("HH:mm:ss",$INV) + "), errori 0, warning " + $(if($nWar -ge 0){ "" + $nWar } else { "NON LETTI" })
    Dico ("COMPILATO: " + $Compilato) "Green"
    if($nWar -gt 0){ foreach($r in @($esito.Log)){ if($r -match '(?i):\s*warning'){ [void]$Rilievi.Add("warning di compilazione: " + $r.Trim()) } } }
  }
  else{
    if($esito.Muto -or @($esito.Log).Count -eq 0){
      $Compilato = "FALLITA -- METAEDITOR MUTO: lanciato ed e' tornato SENZA scrivere ne' log ne' .ex5. NON e' un verdetto sul codice."
    } else {
      $Compilato = "FALLITA (MetaEditor lanciato, nessun .ex5 fresco; errori dal log: " + $(if($nErr -ge 0){ "" + $nErr } else { "NON LETTI" }) + ") -- QUESTO E' IL RISULTATO DEL PASSO."
    }
    $k = 0
    foreach($r in @($esito.Log)){ if($r.Trim() -eq ""){ continue }; Write-Host ("      " + $r) -ForegroundColor Red; $k++; if($k -ge 30){ break } }
    throw ("COMPILAZIONE FALLITA: " + $Compilato)
  }

  # -------------------------------------------------------------------
  #  7. IL CALENDARIO, IN ENTRAMBI I POSTI
  # -------------------------------------------------------------------
  Titolo "7. CALENDARIO installato in ENTRAMBI i posti (Common\Files e <CartellaDati>\MQL5\Files)"
  $commonFiles = Join-Path $env:APPDATA "MetaQuotes\Terminal\Common\Files"
  New-Item -ItemType Directory -Force -Path $commonFiles | Out-Null
  $dstFilesLocal = Join-Path $DataFolder "MQL5\Files"
  New-Item -ItemType Directory -Force -Path $dstFilesLocal | Out-Null
  $calCommon = Join-Path $commonFiles $NEWSFILE
  $calLocale = Join-Path $dstFilesLocal $NEWSFILE
  $fotoCommonPrima = Foto $calCommon; $fotoLocalePrima = Foto $calLocale
  Copy-Item -LiteralPath $calPath -Destination $calCommon -Force
  Copy-Item -LiteralPath $calPath -Destination $calLocale -Force
  $fotoCommonDopo = Foto $calCommon; $fotoLocaleDopo = Foto $calLocale
  [void]$CalFotoRighe.Add("  Common\Files\" + $NEWSFILE + ": prima [" + (FotoTxt $fotoCommonPrima) + "] dopo [" + (FotoTxt $fotoCommonDopo) + "]  (questa e' quella che CONTA nel tester: gli agenti la condividono)")
  [void]$CalFotoRighe.Add("  MQL5\Files\" + $NEWSFILE + " (sandbox locale): prima [" + (FotoTxt $fotoLocalePrima) + "] dopo [" + (FotoTxt $fotoLocaleDopo) + "]  (serve al test singolo/grafico, non agli agenti dell'ottimizzazione)")
  if(-not $fotoCommonDopo.Esiste -or $fotoCommonDopo.Len -ne (Get-Item -LiteralPath $calPath).Length){ throw "installazione del calendario in Common\Files FALLITA (dimensione diversa dal file al pin)." }
  if(-not $fotoLocaleDopo.Esiste -or $fotoLocaleDopo.Len -ne (Get-Item -LiteralPath $calPath).Length){ throw "installazione del calendario in MQL5\Files FALLITA (dimensione diversa dal file al pin)." }
  Dico "calendario installato e verificato in entrambi i posti (stessa dimensione del file al pin)" "Green"

  # -------------------------------------------------------------------
  #  8. MISURA STORICO M1 USDJPY (automatica, max 2 tentativi) + PAVIMENTO
  # -------------------------------------------------------------------
  Titolo ("8. MISURA STORICO M1 " + $Simbolo + " (ABTG_HistoryDownloader, SOLO barre, SENZA tick, max 2 tentativi)")
  if($SaltaMisuraStorico){
    $DaQuandoMisurato = $DaQuandoGiaMisurata
    $StoricoTxt = "SALTATA (-SaltaMisuraStorico): riuso -DaQuandoGiaMisurata " + $DaQuandoGiaMisurata + " -- valida SOLO nella STESSA sessione di lavoro di un giro precedente di QUESTA riga (non un valore indovinato ora)."
    [void]$Rilievi.Add("misura storico SALTATA su richiesta esplicita (-SaltaMisuraStorico): la data usata (" + $DaQuandoGiaMisurata + ") viene da un giro precedente, non da questa esecuzione.")
    Dico $StoricoTxt "Yellow"
  } else {
    $tentativo = 0; $trovato = $false; $verdettoRiga = $null
    while($tentativo -lt 2 -and -not $trovato){
      $tentativo++
      Dico ("tentativo " + $tentativo + "/2 di misura storico M1 " + $Simbolo + "...") "Cyan"
      $esitoM = MisuraStoricoUnaVolta $histDlPath $MetaEditor $Terminal64 $DataFolder $TimeoutStoricoMin
      [void]$StoricoTentativi.Add("tentativo " + $tentativo + ": visto=" + $esitoM.Visto + " finito=" + $esitoM.Finito + " righe_csv=" + $(if($esitoM.Righe){ @($esitoM.Righe).Count } else { 0 }))
      if($esitoM.Righe){
        $rigaM1 = @($esitoM.Righe | Where-Object { $_.Simbolo -eq $Simbolo -and $_.Timeframe -eq "M1" } | Select-Object -First 1)
        if($rigaM1.Count -gt 0){
          $verdettoRiga = $rigaM1[0]
          Dico ("verdetto tentativo " + $tentativo + ": " + $verdettoRiga.Verdetto + " | PrimaDataServer " + $verdettoRiga.PrimaDataServer + " | PrimaDataLocale " + $verdettoRiga.PrimaDataLocale + " | Barre " + $verdettoRiga.Barre) "Yellow"
          if($verdettoRiga.Verdetto -eq "COMPLETO" -or $verdettoRiga.Verdetto -eq "IL BROKER NON HA PIU' STORICO"){ $trovato = $true }
        }
      }
      $StoricoCsvCopia = Join-Path $Work ("ABTG_StoricoScaricato_M1_" + $Simbolo + ".csv")
      if(Test-Path -LiteralPath $esitoM.CsvOut){ Copy-Item -LiteralPath $esitoM.CsvOut -Destination $StoricoCsvCopia -Force }
    }
    if(-not $trovato -or $null -eq $verdettoRiga){
      $StoricoTxt = "FERMATO dopo " + $tentativo + " tentativi: nessuna riga " + $Simbolo + "/M1 con verdetto COMPLETO o 'IL BROKER NON HA PIU' STORICO' in " + $Work + "\ABTG_StoricoScaricato_M1_" + $Simbolo + ".csv. Vedi StoricoTentativi nel referto."
      throw ("MISURA STORICO NON RIUSCITA: " + $StoricoTxt + " -- QUESTO E' IL RISULTATO DEL PASSO: non si indovina @DAQUANDO. Rilancia la stessa riga (il download parziale resta sul disco e il tentativo successivo riparte da li').")
    }
    $DaQuandoMisurato = ("" + $verdettoRiga.PrimaDataServer).Trim()
    if($DaQuandoMisurato -notmatch '^\d{4}\.\d{2}\.\d{2}$'){ throw ("PrimaDataServer letto ('" + $DaQuandoMisurato + "') non e' una data yyyy.MM.dd: la riga non indovina, si ferma.") }
    $StoricoTxt = "MISURATA al tentativo " + $tentativo + "/2: verdetto '" + $verdettoRiga.Verdetto + "', PrimaDataServer " + $DaQuandoMisurato + " (PrimaDataLocale " + $verdettoRiga.PrimaDataLocale + ", Barre " + $verdettoRiga.Barre + ")"
    if($verdettoRiga.Verdetto -eq "IL BROKER NON HA PIU' STORICO"){ [void]$Rilievi.Add("il broker NON ha M1 fino a " + $DaQuandoRichiesta + ": il muro vero e' " + $DaQuandoMisurato + ". La finestra IS/OOS parte da li', REGIME piu' corto del calendario -- dichiarato, non un errore.") }
    Dico $StoricoTxt "Green"
  }

  # IL PAVIMENTO (vedi header): -DaQuando usato = il PIU' TARDI fra la
  # data misurata e -PavimentoDaQuando. Tutti e due i numeri nel referto.
  $dMis = [datetime]::ParseExact($DaQuandoMisurato,"yyyy.MM.dd",$INV)
  $dPav = [datetime]::ParseExact($PavimentoDaQuando,"yyyy.MM.dd",$INV)
  if($dMis -lt $dPav){
    $DaQuandoUsato = $PavimentoDaQuando
    $PavimentoTxt = "APPLICATO: la misura ha dato " + $DaQuandoMisurato + ", PRIMA del pavimento " + $PavimentoDaQuando + " -> si usa il pavimento. Motivo (header, >>> PAVIMENTO): BCM puo' DICHIARARE barre M1 molto piu' vecchie di quelle operative -- MISURATO su EURUSD in R102 ('dal 1971.01.03' con prima operazione 1999.01.18), su USDJPY e' un rischio INFERITO per analogia, e con lo split 0,40 l'IS finirebbe in anni dove questo calendario ha ZERO eventi."
    [void]$Rilievi.Add("PAVIMENTO APPLICATO: -DaQuando misurato " + $DaQuandoMisurato + " -> usato " + $PavimentoDaQuando + ". NON e' una data indovinata: e' una MANOPOLA dichiarata (-PavimentoDaQuando), e la data misurata resta scritta qui accanto.")
  } else {
    $DaQuandoUsato = $DaQuandoMisurato
    $PavimentoTxt = "NON applicato: la misura ha dato " + $DaQuandoMisurato + ", gia' pari o successiva al pavimento " + $PavimentoDaQuando + " -> vince la MISURA (comportamento identico alla riga NFP)."
  }
  $dIniChk = [datetime]::ParseExact($DaQuandoUsato,"yyyy.MM.dd",$INV)
  $dFinChk = [datetime]::ParseExact($Fino,"yyyy.MM.dd",$INV)
  if($dIniChk -ge $dFinChk){ throw ("finestra VUOTA: -DaQuando usato " + $DaQuandoUsato + " non e' prima di -Fino " + $Fino + ". Se la misura ha dato una data recente, questo calendario (che finisce nel " + $CAL_ULTIMO_ATTESO + ") non e' testabile su questo banco: e' il risultato del passo, non un guasto.") }
  Dico ("pavimento: " + $PavimentoTxt) "Yellow"
  Dico ("-DaQuando che verra' usato per la corsa: " + $DaQuandoUsato) "Yellow"

  # -------------------------------------------------------------------
  #  8-bis. CONTA-OCCASIONI per finestra (dal calendario al pin)
  # -------------------------------------------------------------------
  Titolo "8-bis. CONTA-OCCASIONI: giornate utili del calendario dentro IS e dentro OOS"
  $dIni = $dIniChk
  $dFin = $dFinChk
  $dMeta = $dIni.AddDays([math]::Floor(($dFin-$dIni).TotalDays*$FrazioneIS))
  $WinIS  = $dIni.ToString("yyyy.MM.dd",$INV) + " -> " + $dMeta.ToString("yyyy.MM.dd",$INV)
  $WinOOS = $dMeta.AddDays(1).ToString("yyyy.MM.dd",$INV) + " -> " + $dFin.ToString("yyyy.MM.dd",$INV)
  $OccIS  = ContaFraDate $GiorniCal $dIni $dMeta
  $OccOOS = ContaFraDate $GiorniCal $dMeta.AddDays(1) $dFin
  $OccTxt = "IS " + $WinIS + " = " + $OccIS + " occasioni | OOS " + $WinOOS + " = " + $OccOOS + " occasioni (su " + @($GiorniCal).Count + " giornate utili in tutto il calendario). >>> UN'OCCASIONE NON E' UN'OPERAZIONE: ogni giornata piazza DUE pendenti e ne scattano 0, 1 o 2. L'Emendamento A si applica alla colonna Trades, MAI a questo numero."
  Dico ("occasioni: " + $OccTxt) "Yellow"
  if($OccIS -le 0){ [void]$Problemi.Add("ZERO OCCASIONI NELL'IS (" + $WinIS + "): in quella finestra il calendario non ha nemmeno una giornata utile. Un CSV IS con Trades=0 NON e' 'niente edge', e' 'non e' girata'. Controlla -DaQuando/-PavimentoDaQuando/-Fino.") }
  if($OccOOS -le 0){ [void]$Problemi.Add("ZERO OCCASIONI NELL'OOS (" + $WinOOS + "): stessa lettura dell'IS a zero.") }

  # -------------------------------------------------------------------
  #  9. CACHE DEL TESTER e FOTO DEI LOG
  # -------------------------------------------------------------------
  Titolo "9. Tester\cache svuotata (SOLO quella) e log del tester fotografati"
  $cacheT = Join-Path $DataFolder "Tester\cache"
  if(Test-Path -LiteralPath $cacheT){
    $ncPrima = @(Get-ChildItem -LiteralPath $cacheT -Recurse -File -ErrorAction SilentlyContinue).Count
    Remove-Item (Join-Path $cacheT "*") -Recurse -Force -ErrorAction SilentlyContinue
    $ncDopo  = @(Get-ChildItem -LiteralPath $cacheT -Recurse -File -ErrorAction SilentlyContinue).Count
    $CacheTxt = "prima " + $ncPrima + " file, dopo " + $ncDopo
    if($ncDopo -gt 0){ [void]$Problemi.Add("Tester\cache NON si e' svuotata (" + $CacheTxt + "): un pass ripescato non chiama OnTester e lascia il CSV monco."); Dico ("Tester\cache NON SVUOTATA: " + $CacheTxt) "Red" }
    else{ Dico ("Tester\cache svuotata: " + $CacheTxt) "Green" }
  } else { $CacheTxt = "cartella assente (" + $cacheT + "): niente da svuotare"; Dico ("Tester\cache: " + $CacheTxt) "Yellow" }
  FotografaLog

  # -------------------------------------------------------------------
  #  10. LA CORSA (2 celle x 1 finestra IS/OOS a OHLC M1)
  # -------------------------------------------------------------------
  Titolo ("10. CORSA: " + $NCELLE_ATTESE + " celle x 2 finestre, Modello 1 (OHLC M1), -DaQuando " + $DaQuandoUsato + ", -Fino " + $Fino)
  Dico ("finestra: IS " + $WinIS + " | OOS " + $WinOOS + " (split " + $FrazioneIS + ", come lo calcola il generico)") "Yellow"

  $tCorsa = Get-Date
  LanciaGenerico $drv $provaPath $DaQuandoUsato
  if($SoloControllo){
    $CorsaTxt = "CONTROLLO (generico -SoloControllo: MT5 NON aperto per il tester, anteprima .ini scritta -- NON e' l'.ini che girera', classe 96)"
  } else {
    $CorsaTxt = "LANCIATA alle " + $tCorsa.ToString("HH:mm:ss",$INV)
    $IS = LeggiFinestra "IS" $tCorsa
    $OOS = LeggiFinestra "OOS" $tCorsa
    if($IS.Letto -and $OOS.Letto){ $CorsaTxt = $CorsaTxt + " -- CSV IS e OOS LETTI (freschi), " + $IS.NRighe + " + " + $OOS.NRighe + " righe" }
    else { $CorsaTxt = $CorsaTxt + " -- CSV NON LETTI (vedi PROBLEMI)" }
  }

  # -------------------------------------------------------------------
  #  11. LOG DEL TESTER: canarino NEWS, autotest, Model=
  # -------------------------------------------------------------------
  Titolo "11. LOG DEL TESTER: canarino '[PostNews][NEWS]' e autotest 'casi falliti'"
  if(-not $SoloControllo){
    $LogLetti = RaccogliLog
    $canarino = LeggiCanarinoNews $RigheLog
    $autotestLog = LeggiAutotestLog $RigheLog
    $inis = @(Get-ChildItem -LiteralPath $Work -Filter ("gen_" + $EA + "_" + $Simbolo + "_*" + $Etichetta + ".ini") -ErrorAction SilentlyContinue | Where-Object { $_.LastWriteTime -ge $Avvio })
    $mods = @()
    foreach($ini in $inis){ $mods += @((Get-Content -LiteralPath $ini.FullName) | Where-Object { $_ -match '^Model=' } | ForEach-Object { $ini.Name + ": " + $_.Trim() }) }
    if($mods.Count -gt 0){ $ModelTxt = ($mods -join " | ") + "  (dall'.ini VERO scritto dal generico per QUESTA corsa)"; if(@($mods | Where-Object { $_ -notmatch 'Model=1$' }).Count -gt 0){ [void]$Problemi.Add("un .ini vero della corsa NON ha Model=1: " + ($mods -join " | ")) } }
    else{ $ModelTxt = "NESSUN gen_*.ini fresco trovato: Model NON verificato a macchina"; [void]$Problemi.Add("Model=1 NON verificabile: nessun .ini vero della corsa trovato (" + $Work + ").") }
  } else {
    $LogLetti = 0
    $canarino = [pscustomobject]@{ Righe=@(); Cieco=@(); Rosso=@(); Valori=@() }
    $autotestLog = [pscustomobject]@{ Righe=@(); Valori=@() }
    $ModelTxt = "n/d (giro di controllo: l'anteprima scrive Model=4 hardcoded e NON fa da prova, classe 96 -- qui il modello vero e' 1)"
  }
}
catch{
  $Fatale = ("" + $_.Exception.Message)
  Write-Host ""
  Write-Host ("!!! FERMATO: " + $Fatale) -ForegroundColor Red
  if($null -eq (Get-Variable -Name canarino -Scope 0 -ErrorAction SilentlyContinue)){ $canarino = [pscustomobject]@{ Righe=@(); Cieco=@(); Rosso=@(); Valori=@() } }
  if($null -eq (Get-Variable -Name autotestLog -Scope 0 -ErrorAction SilentlyContinue)){ $autotestLog = [pscustomobject]@{ Righe=@(); Valori=@() } }
}

# =====================================================================
#  RIPRISTINO -- SEMPRE, anche se il giro e' morto a meta' (classe 116).
# =====================================================================
if($IncInstallato){
  try{
    if($IncEraLi -and $IncBackup -ne "" -and (Test-Path -LiteralPath $IncBackup)){
      Copy-Item -LiteralPath $IncBackup -Destination $TIncMqh -Force
      Remove-Item -LiteralPath $IncBackup -Force -ErrorAction SilentlyContinue
      $Ripristino = "include del terminale RIPRISTINATO dal backup (c'era gia' prima di questo giro)"
    } else {
      Remove-Item -LiteralPath $TIncMqh -Force -ErrorAction SilentlyContinue
      $Ripristino = "include del terminale RIMOSSO (non c'era prima di questo giro)"
    }
    Remove-Item -LiteralPath $Sentinella -Force -ErrorAction SilentlyContinue
  }
  catch{ $Ripristino = "RIPRISTINO FALLITO: " + $_.Exception.Message; [void]$Problemi.Add("RIPRISTINO FALLITO dell'include nel terminale (" + $TIncMqh + "): controllalo a mano. La sentinella resta e il prossimo giro ci riprova.") }
}
if($FotoPrese){
  try{
    $F1Dopo = Foto $TExpMq5; $F2Dopo = Foto $TExpEx5; $F3Dopo = Foto $TIncMqh
    foreach($t in @(@{N=("Experts\" + $EA + ".mq5"); A=$F1Prima; B=$F1Dopo; Atteso="SCRITTO (l'EA al pin: resta, come ogni EA della pipeline)"},
                    @{N=("Experts\" + $EA + ".ex5"); A=$F2Prima; B=$F2Dopo; Atteso="SCRITTO (compilato qui: resta, il tester lo richiede)"},
                    @{N=("Include\" + $INC);          A=$F3Prima; B=$F3Dopo; Atteso="INVARIATO (installato al pin e RIMESSO com'era)"})){
      $stato = "INVARIATO"
      if($t.A.Esiste -ne $t.B.Esiste -or $t.A.Len -ne $t.B.Len){ $stato = "CAMBIATO" } elseif($t.A.Ora -ne $t.B.Ora){ $stato = "stessa dimensione, data diversa" }
      [void]$RigheFotoDopo.Add("  " + $t.N + ": prima [" + (FotoTxt $t.A) + "] dopo [" + (FotoTxt $t.B) + "] -> " + $stato + "   atteso: " + $t.Atteso)
      if($t.N -like "Include*" -and $stato -eq "CAMBIATO"){ [void]$Problemi.Add("l'include del terminale RISULTA CAMBIATO dopo il ripristino: controlla la foto prima/dopo e rimettilo a mano.") }
    }
  } catch { [void]$Problemi.Add("non ho potuto rifare la foto dei file del terminale: il ripristino resta DICHIARATO e non MISURATO.") }
}

# =====================================================================
#  RACCOLTA -- SEMPRE, anche quando la corsa si e' fermata a meta'.
# =====================================================================
Titolo "RACCOLTA"
$Cart = Join-Path $Dsk $ZipNome
if(Test-Path -LiteralPath $Cart){ Remove-Item -LiteralPath $Cart -Recurse -Force -ErrorAction SilentlyContinue }
New-Item -ItemType Directory -Force -Path $Cart | Out-Null

$R = New-Object System.Collections.ArrayList
[void]$R.Add("=====================================================================")
[void]$R.Add(" POSTNEWS USD1330/USDJPY -- PASSO 0 CONTA-OCCASIONI (" + $EA + " v" + $VERSIONE_ATTESA + ")")
[void]$R.Add(" Modello 1 (1 minuto OHLC = SCREENING) | InpMagic " + $MAGIC1 + "/" + $MAGIC2 + " (2 celle gemelle)")
[void]$R.Add("=====================================================================")
[void]$R.Add("modo: " + $Modo + "   <- CONTROLLO = generico -SoloControllo (MT5 apre SOLO per la misura storico, non per il tester); FASE reale = CORSA")
[void]$R.Add("data: " + $Avvio.ToString("yyyy-MM-dd HH:mm:ss",$INV) + "   <- ORA DI AVVIO del giro (non l'ora in cui leggi: la corsa dura decine di minuti, quasi tutti nella misura storico)")
[void]$R.Add("pin:  " + $Pin)
[void]$R.Add("simbolo di questa corsa: " + $Simbolo + " (fisso; il gemello CROSS-SIMBOLO su EURUSD, magic 774802, e' un ALTRO round)")
[void]$R.Add("finestra: IS " + $WinIS + " | OOS " + $WinOOS + " (split " + $FrazioneIS + " come lo calcola il generico) -- -Fino " + $Fino)
[void]$R.Add("-DaQuando: MISURATO " + $(if($DaQuandoMisurato){ $DaQuandoMisurato } else { "n/d (misura non arrivata)" }) + " | USATO " + $(if($DaQuandoUsato){ $DaQuandoUsato } else { "n/d" }) + "   <- pavimento " + $PavimentoDaQuando)
[void]$R.Add("pavimento: " + $PavimentoTxt)
[void]$R.Add("banco: MODELLO 1 (1 minuto OHLC, SOLO SCREENING -- un numero OHLC non e' mai un verdetto) | @PERIODO " + $Periodo + " | deposito " + $Deposito + " | rischio 0,65%/evento (0,325%/ordine su 50 pip)")
[void]$R.Add("terminale: " + $TermTxt)
[void]$R.Add("cartella dati: " + $DataFolder)
[void]$R.Add("compilazione: " + $Compilato)
[void]$R.Add("riga Result del log: " + $ResultTxt)
[void]$R.Add("versione letta dal #property: " + $VersTxt + "   (attesa " + $VERSIONE_ATTESA + ")")
[void]$R.Add("autotest (ricalcolato dal sorgente, NESSUN #define in questo EA): " + $AutotestTxt)
[void]$R.Add("OnTester: " + $OnTesterTxt)
[void]$R.Add("hedge-safe: " + $HedgeTxt)
[void]$R.Add("include censiti nel sorgente: " + $IncTxt)
[void]$R.Add("include al pin: " + $IncGuardia)
[void]$R.Add("coerenza prova <-> preset .set: " + $GemPreset)
[void]$R.Add("calendario: " + $CalCsvTxt)
foreach($l in $CalFotoRighe){ [void]$R.Add($l) }
[void]$R.Add("ripristino del terminale: " + $Ripristino)
[void]$R.Add("foto PRIMA/DOPO dei file del terminale (la prova sta nella foto, non nella frase):")
if($RigheFotoDopo.Count -eq 0){ [void]$R.Add("  NON PRESE: il giro si e' fermato prima di guardare il terminale, niente e' stato scritto") }
foreach($l in $RigheFotoDopo){ [void]$R.Add($l) }
[void]$R.Add("")
[void]$R.Add("--- MISURA STORICO M1 " + $Simbolo + " (fase 8) ---")
[void]$R.Add("  " + $StoricoTxt)
foreach($l in $StoricoTentativi){ [void]$R.Add("  " + $l) }
[void]$R.Add("")
[void]$R.Add("--- CONTA-OCCASIONI (fase 8-bis, dal calendario AL PIN, prima del tester) ---")
[void]$R.Add("  " + $OccTxt)
[void]$R.Add("cache tester: " + $CacheTxt)
[void]$R.Add("celle: " + $CelleTxt)
[void]$R.Add("corsa: " + $CorsaTxt)
[void]$R.Add("Model letto: " + $ModelTxt)
[void]$R.Add("log del tester letti a macchina (cresciuti in questo giro): " + $(if($LogLetti -ge 0){ "" + $LogLetti } else { "NON LETTI" }))
[void]$R.Add("")
[void]$R.Add("--- IL CANARINO NEWS (letto dai LOG del tester, NON dal CSV -- par. intestazione) ---")
# IL CANARINO E' UN CANCELLO, NON UNA DECORAZIONE (classe 14/84): ogni
# rilievo qui sotto entra ANCHE in $Problemi, cioe' nel ramo che decide il
# codice d'uscita. Se finisse solo in $R (una lista di righe di testo), la
# riga in chat direbbe "CORSA OK" in verde con il calendario cieco: e' ESATTAMENTE
# l'errore del 07/08 (verdetto "PostNews nessun edge" con Trades=0) che questo
# round esiste per non ripetere.
$CorsaVeraFinita = ((-not $SoloControllo) -and $Fatale -eq "")
if($canarino.Righe.Count -eq 0){
  [void]$R.Add("  NESSUNA riga '[PostNews][NEWS] letto da ...' trovata nei log letti: NON CONFERMATO che il calendario sia arrivato agli agenti. Se la corsa e' COMPLETATA questo e' un PROBLEMA, non un warning.")
  if($CorsaVeraFinita){ [void]$Problemi.Add("CANARINO NEWS ASSENTE: la corsa e' arrivata in fondo ma nei log del tester non c'e' nessuna riga '[PostNews][NEWS] letto da ...'. NON e' confermato che il calendario sia arrivato agli agenti: i numeri economici NON si leggono.") }
}
foreach($l in $canarino.Righe){ [void]$R.Add("  " + $l) }
if($canarino.Cieco.Count -gt 0){
  [void]$R.Add("  !!! CALENDARIO CIECO trovato " + $canarino.Cieco.Count + " volte: il file non e' arrivato agli agenti. La passata NON CONTA.")
  [void]$Problemi.Add("CALENDARIO CIECO nei log del tester (" + $canarino.Cieco.Count + " volte): il calendario non e' arrivato agli agenti. La passata NON CONTA: non e' 'niente edge', e' 'non e' girata'.")
}
if($canarino.Rosso.Count -gt 0){
  [void]$R.Add("  !!! CANARINO ROSSO trovato " + $canarino.Rosso.Count + " volte: il calendario si legge ma per QUESTO preset ha ZERO eventi utili. La passata NON CONTA.")
  [void]$Problemi.Add("CANARINO ROSSO nei log del tester (" + $canarino.Rosso.Count + " volte): il calendario si legge ma per QUESTO preset ha ZERO eventi utili. La passata NON CONTA.")
}
if($canarino.Valori.Count -gt 0){
  $distinti = @($canarino.Valori | Select-Object -Unique)
  [void]$R.Add("  UTILI per questo preset: valori trovati nei log = " + ($canarino.Valori -join ", ") + "  (distinti: " + ($distinti -join ", ") + "; ATTESO " + $CAL_UTILI_ATTESI + ")")
  if(@($distinti | Where-Object { $_ -le 0 }).Count -gt 0){
    [void]$R.Add("  !!! N=0 su almeno una riga: CALENDARIO CIECO PER QUESTO PRESET. La passata con N=0 NON CONTA: non e' 'niente edge', e' 'non e' girata'.")
    [void]$Problemi.Add("CANARINO NEWS N=0 su almeno una passata (valori letti: " + ($canarino.Valori -join ", ") + "): calendario cieco PER QUESTO PRESET. La passata con N=0 NON CONTA: non e' 'niente edge', e' 'non e' girata'.")
  }
  elseif(@($distinti | Where-Object { $_ -ne $CAL_UTILI_ATTESI }).Count -gt 0){
    [void]$R.Add("  !!! N DIVERSO DALL'ATTESO (" + $CAL_UTILI_ATTESI + "): il filtro non sta selezionando quello che crediamo. I numeri economici NON si leggono finche' non si capisce perche'.")
    [void]$Problemi.Add("CANARINO NEWS con N diverso dall'atteso (letti: " + ($canarino.Valori -join ", ") + "; atteso " + $CAL_UTILI_ATTESI + " dal calendario al pin, contato a macchina in fase 4): il preset non sta filtrando gli eventi che crediamo.")
  }
}
[void]$R.Add("--- AUTOTEST, letto dai log del tester (atteso 0 casi falliti su OGNI riga) ---")
if($autotestLog.Righe.Count -eq 0){ [void]$R.Add("  NESSUNA riga '[PostNews][AUTOTEST] ---- fine: ...' trovata nei log letti.") }
foreach($l in $autotestLog.Righe){ [void]$R.Add("  " + $l) }
if(@($autotestLog.Valori | Where-Object { $_ -ne 0 }).Count -gt 0){ [void]$Problemi.Add("autotest dell'EA: almeno una riga di log riporta 'casi falliti' diverso da 0 -- l'EA DIVERGE dalla sua stessa spec, i numeri NON si leggono.") }
[void]$R.Add("")
[void]$R.Add("--- IL CONTO ECONOMICO (n IS e n OOS accanto a OGNI numero) ---")
[void]$R.Add("  promemoria: occasioni IS " + $OccIS + " / OOS " + $OccOOS + " -- ogni occasione piazza DUE pendenti, quindi n sta fra 0 e il doppio delle occasioni.")
foreach($tag in @("IS","OOS")){
  $w = if($tag -eq "IS"){ $IS } else { $OOS }
  if($null -eq $w -or -not $w.Letto){ [void]$R.Add("  " + $tag + ": SENZA NUMERI"); continue }
  [void]$R.Add("  " + $tag + " (CSV " + $w.CsvOra + ", righe " + $w.NRighe + "/" + $NCELLE_ATTESE + ", gemelli: " + $w.Gemelli + ")")
  foreach($mg in @($MAGIC1,$MAGIC2)){
    if(-not $w.PerMagic.ContainsKey("" + $mg)){ [void]$R.Add("    magic " + $mg + ": riga mancante"); continue }
    # NB: la variabile della cella si chiama $rg e NON $r (classe 79-bis):
    # in PowerShell i nomi NON distinguono maiuscole/minuscole, quindi un
    # $r qui dentro DISTRUGGEREBBE $R, la lista del referto -- e il difetto
    # vivrebbe SOLO quando la corsa e' riuscita (nel giro a vuoto questo
    # ramo non si raggiunge nemmeno).
    $rg = $w.PerMagic["" + $mg]
    $fN = if($rg.N -ge $N_PASSA){ "PASSA (Emendamento A, >= " + $N_PASSA + ")" } elseif($rg.N -ge $N_MIN){ "MERITO SOSPESO (Emendamento A, " + $N_MIN + "-" + ($N_PASSA-1) + ")" } else { "NON MISURABILE (Emendamento A, < " + $N_MIN + ")" }
    [void]$R.Add("    magic " + $mg + ": n=" + $rg.N + " " + $fN + " | Profit " + (Fmt2 $rg.Profit) + " | Payoff " + (Fmt4 $rg.Payoff) + " | PF " + (Fmt2 $rg.PF) + " | RF " + (Fmt2 $rg.RF) + " | Sharpe " + (Fmt2 $rg.Sharpe) + " | Equity DD% " + (Fmt2 $rg.DD))
  }
}
[void]$R.Add("  Emendamento B (rischio): questo OPTFRAME NON esporta 'Peggior Giornata %' (a differenza di altri EA di casa) -- il giudizio di rischio si legge SOLO su Equity DD%, dichiarato, nessuna soglia numerica e' stata CONGELATA per questo preset in nessun materiale ricevuto.")
[void]$R.Add("  NESSUNA PROMOZIONE PUO' USCIRE DA QUESTA CELLA. Non perche' il campione sia per forza sottile (qui n POTREBBE superare 150), ma perche' IL BANCO E' MODELLO 1 = OHLC = SCREENING. Se lo screening interessa, la finestra recente si RIFA' a tick reali (-Modello 4) e SOLO quella si legge come misura.")
[void]$R.Add("")
[void]$R.Add("--- COSA NON SI PUO' DIRE con questi dati ---")
[void]$R.Add("  1. 'ha edge' o 'non ha edge' (banco OHLC = screening, e comunque il MERITO si giudica a tick reali) | 2. 'regge nel tempo' (nessuna prova di regime qui, Emendamento C fuori scopo del Passo 0)")
[void]$R.Add("  3. 'il DD sara' quello' (Modello 1 = OHLC: in questa casa l'illusione OHLC ha gia' revocato una promozione, SupRev DOW H4 PF 2,77 OHLC contro 0,79 a tick reali) | 4. promuovere qualunque cella da qui")
[void]$R.Add("  5. niente sul CONFRONTO con la sedia NFP: qui offset, SL/TP, ora d'azione e SIMBOLO sono IDENTICI alla sedia viva, ma quella non ha ancora un backtest suo con questi criteri. Due numeri si confrontano quando sono stati fatti sullo stesso banco: finche' il passo 0 dell'NFP non e' girato, il paragone non esiste.")
[void]$R.Add("  6. 'lo spread e' quello vero': a Modello 1 non lo e'. E su USDJPY non abbiamo lo spread reale BCM archiviato come su EURUSD (R115): un altro motivo per cui il MERITO si giudica solo a tick reali.")
[void]$R.Add("  7. niente sulla COMPOSIZIONE del blocco: il calendario non e' costante nel tempo (CPI m/m ha un buco 2010-2013, PPI m/m un buco 2019-2021). IS e OOS confrontano anche MISCELE DIVERSE, non solo periodi diversi. Dichiarato nel prova, non scoperto dopo.")
[void]$R.Add("")
if($RigheLog.Count -gt 0){
  [void]$R.Add("--- ALTRE RIGHE INTERESSANTI DAI LOG DEL TESTER (tick/memoria/errori) ---")
  $k = 0
  foreach($l in $RigheLog){ if($l -match '\[PostNews\]'){ continue }; [void]$R.Add("  " + $l); $k++; if($k -ge 40){ [void]$R.Add("  ... (altre righe nei log_*.log dentro lo zip)"); break } }
  [void]$R.Add("")
}
if($Fatale -ne ""){ [void]$R.Add("!!! FERMATO: " + $Fatale); [void]$R.Add("") }
[void]$R.Add("PROBLEMI: " + $Problemi.Count)
foreach($p in $Problemi){ [void]$R.Add("  - " + $p) }
[void]$R.Add("RILIEVI: " + $Rilievi.Count)
foreach($p in $Rilievi){ [void]$R.Add("  - " + $p) }
[void]$R.Add("")
[void]$R.Add('COME SI RIPRENDE: dalla pagina righe/RIGA_POSTNEWS_1330_DA_MANDARE.md, NON da questa')
[void]$R.Add('riga: $Pin nasce dentro il blocco e non sopravvive. Un giro morto a meta'' si rilancia')
[void]$R.Add("INTERO (il generico ha -Rifai). La misura storico riparte da dove sta il disco (bases\ non si svuota mai): un secondo tentativo e' quasi sempre piu' veloce del primo.")

$refPath = Join-Path $Cart "REFERTO_POSTNEWS_USD1330_USDJPY.txt"
Set-Content -LiteralPath $refPath -Value ($R -join "`r`n") -Encoding ASCII
Write-Host ($R -join "`r`n")

if(Test-Path -LiteralPath $logC){
  Copy-Item -LiteralPath $logC -Destination $Cart -Force
  Set-Content -LiteralPath (Join-Path $Cart "COMPILAZIONE_leggibile.txt") -Value ((LeggiTesto $logC) -join "`r`n") -Encoding ASCII
}
if($provaPath  -and (Test-Path -LiteralPath $provaPath)){  Copy-Item -LiteralPath $provaPath  -Destination $Cart -Force }
if($presetPath -and (Test-Path -LiteralPath $presetPath)){ Copy-Item -LiteralPath $presetPath -Destination $Cart -Force }
if($StoricoCsvCopia -ne "" -and (Test-Path -LiteralPath $StoricoCsvCopia)){ Copy-Item -LiteralPath $StoricoCsvCopia -Destination $Cart -Force }
$Results = Join-Path $Work ("risultati_prove\" + $EA)
foreach($leg in @("IS","OOS")){
  $f = Join-Path $Results ($EA + "_" + $Simbolo + "_" + $leg + "_ohlc_" + $Etichetta + ".csv")
  if(Test-Path -LiteralPath $f){ Copy-Item -LiteralPath $f -Destination $Cart -Force }
}
foreach($f in @(Get-ChildItem -LiteralPath $Work -Filter ("gen_" + $EA + "_" + $Simbolo + "_*" + $Etichetta + ".ini") -ErrorAction SilentlyContinue)){ Copy-Item -LiteralPath $f.FullName -Destination $Cart -Force }
foreach($f in @(Get-ChildItem -LiteralPath $Work -Filter ("anteprima_" + $EA + "_*.ini") -ErrorAction SilentlyContinue | Where-Object { $_.LastWriteTime -ge $Avvio })){ Copy-Item -LiteralPath $f.FullName -Destination $Cart -Force }
foreach($f in @(Get-ChildItem -LiteralPath $Work -Filter "log_*.log" -ErrorAction SilentlyContinue | Where-Object { $_.LastWriteTime -ge $Avvio })){ Copy-Item -LiteralPath $f.FullName -Destination $Cart -Force }
$zip = $Cart + ".zip"
Remove-Item -LiteralPath $zip -Force -ErrorAction SilentlyContinue
Compress-Archive -Path (Join-Path $Cart "*") -DestinationPath $zip -Force
Write-Host ""
Write-Host ("CARTELLA: " + $Cart) -ForegroundColor Green
Write-Host ("ZIP DA MANDARE: " + $zip) -ForegroundColor Green
Write-Host ("FILE ATTESI NELLO ZIP: REFERTO_POSTNEWS_USD1330_USDJPY.txt + COMPILAZIONE.log (+ _leggibile.txt) + il prova + il preset + ABTG_StoricoScaricato_M1_" + $Simbolo + ".csv + i CSV " + $EA + "_" + $Simbolo + "_IS_ohlc_" + $Etichetta + ".csv e _OOS_ (2 righe l'uno) + gli .ini veri gen_*.ini + i log del tester cresciuti") -ForegroundColor Gray
Write-Host ("NOTA: il canarino '[PostNews][NEWS] ... UTILI per questo preset N' e' nel REFERTO, letto dai log: qui N deve valere " + $CAL_UTILI_ATTESI + ". Se N=0 la corsa NON CONTA (vedi PROBLEMI/RILIEVI).") -ForegroundColor Gray

if($Fatale -ne ""){ Write-Host "ESITO: FERMATO" -ForegroundColor Red; exit 1 }
if($Problemi.Count -gt 0){ Write-Host "ESITO: COMPLETATO CON PROBLEMI" -ForegroundColor Yellow; exit 1 }
Write-Host ("ESITO: " + $Modo + " COMPLETATO") -ForegroundColor Green
exit 0
