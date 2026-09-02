//+------------------------------------------------------------------+
//|                                        ABTG_SondaRsiEmaV8.mq5     |
//|                                                                  |
//|  LA SONDA DI CONTEGGIO DI "RSI + EMA CROSSOVER SIGNALS V8".       |
//|  E' UN CONTATORE, NON UN EA.                                      |
//|                                                                  |
//|  ==============================================================  |
//|  QUESTO FILE NON APRE ORDINI. MAI. NEMMENO NEL TESTER.            |
//|  Non esiste #include <Trade/Trade.mqh>, non esiste nessun         |
//|  CTrade, non esiste nessun OrderSend, nessun PositionClose,       |
//|  nessun calcolo di lotto, nessun rischio, nessun magic number     |
//|  (un magic serve a riconoscere ORDINI PROPRI: qui non ce ne       |
//|  sono). L'identificatore della corsa e' InpTag, che e' una        |
//|  ETICHETTA per i file e per il log, NON un magic.                 |
//|  LA RIGA DI GREP CHE LO DIMOSTRA STA NEL REFERTO, NON QUI, ED E'  |
//|  VOLUTO: scriverne il modello dentro il file lo farebbe           |
//|  combaciare CON SE STESSO e il controllo tornerebbe sempre        |
//|  sporco (successo alla prima stesura della SondaM0PB, corretto).  |
//|  ATTESO: ZERO occorrenze delle chiamate di trading FUORI dalle    |
//|  righe di commento. Le uniche occorrenze in tutto il sorgente     |
//|  sono le TRE righe qui sopra, che le NEGANO.                      |
//|  ==============================================================  |
//|                                                                  |
//|  ------------------------------------------------------------    |
//|  PERCHE' QUESTO FILE ESISTE, VISTO CHE IL CANDIDATO E' GIA'       |
//|  "NON PROMOSSO" SULLA CARTA                                       |
//|  ------------------------------------------------------------    |
//|  Scheda del verdetto di carta (31/08/2026):                       |
//|    backtest_pipeline\caccia_strategie\SCHEDA_RSIEMA_V8_2026-08-31.md
//|  Quella scheda dice NON PROMOSSO e, nello stesso respiro, scrive  |
//|  la PORTA DI RIENTRO: "Se si vuole il numero vero: sonda di       |
//|  conteggio sullo stampo ABTG_SondaM0PB. Criteri da congelare      |
//|  PRIMA: F1 >= 1 segnale/giorno per lato; H8 RR da mediane >=      |
//|  0,70 (FIRMA 2); fascia F2 da definire per il simbolo scelto."    |
//|  QUESTO FILE E' L'ESERCIZIO DI QUELLA PORTA, chiesto da Claudio   |
//|  ESPLICITAMENTE E DUE VOLTE (01-02/09/2026). La differenza fra un |
//|  giudizio di carta e una misura e' che la seconda si puo'         |
//|  sbagliare in modo VERIFICABILE: qui il candidato ha il diritto   |
//|  di essere ucciso dai NUMERI e non dall'analogia con i suoi       |
//|  parenti morti.                                                   |
//|  >>> E VA DETTO SUBITO: i cancelli qui sotto sono PIU' SEVERI di  |
//|  quelli della scheda (F1 chiede ANCHE 2,00 segnali/giorno         |
//|  TOTALI, pavimento firmato da Claudio l'01/09). Sono stati        |
//|  congelati PRIMA di vedere qualunque numero, nel file prova, e    |
//|  stanno qui come #define. Nessuno li puo' ammorbidire dopo.       |
//|                                                                  |
//|  ------------------------------------------------------------    |
//|  STAMPO OBBLIGATORIO E MIGLIORIE EREDITATE                        |
//|  ------------------------------------------------------------    |
//|  STAMPO: mql5\Experts\ABTG_SondaM0PB.mq5, COLLAUDATO SUL CAMPO    |
//|  il 31/08 (corsa 19:35: compilata al primo colpo, autotest 0/12   |
//|  falliti, determinismo perfetto sui conteggi condivisi delle due  |
//|  passate). Da li' arrivano: il nucleo puro interrogabile a        |
//|  tavolino, l'OPTFRAME a colonne CONTATE, il CSV riga-per-segnale  |
//|  spento in ottimizzazione, le soglie dei cancelli come #define e  |
//|  non come input, le colonne SEMPRE per LATO e mai aggregate, la   |
//|  colonna di autoconfronto contro iRSI, i PUNTI INDICE.            |
//|  MIGLIORIE prese da mql5\Experts\ABTG_SondaLondonFx.mq5:          |
//|    (a) l'ABLAZIONE SI CONTA DENTRO OGNI PASSATA (L13), cosi' si   |
//|        legge da UNA SOLA RIGA del CSV e in piu' fa da gate di     |
//|        determinismo fra le due passate dell'asse;                 |
//|    (b) i BLOCCHI DI AUTOTEST ESEGUITI si confrontano con un       |
//|        #define: un blocco cancellato per sbaglio non deve poter   |
//|        passare per "tutto verde";                                 |
//|    (c) i VERDETTI sono FUNZIONI PURE che l'autotest esegue su una |
//|        cella di OGNI fascia -- un gate che ricopia le SOGLIE      |
//|        senza ricopiare le DISUGUAGLIANZE non e' un gate;          |
//|    (d) MFE/MAE su un ORIZZONTE, col ritardo di misura (L10), cosi'|
//|        NESSUN segnale ha l'orizzonte troncato;                    |
//|    (e) guardia anti-inf/nan su ogni campione da mediana.          |
//|  Precedente piu' vecchio: mql5\Scripts\ABTG_SondaMediazione.mq5   |
//|  (firma di Claudio del 21/08, "metro, frequenza").                |
//|                                                                  |
//|  >>> PERCHE' STA IN Experts\ E NON IN Scripts\: un .mq5 in        |
//|      Scripts\ NON HA OnTester. Qui i numeri devono uscire in      |
//|      COLONNE di OPTFRAME, perche' la corsa e' in OTTIMIZZAZIONE   |
//|      (un asse, due passate) e in ottimizzazione le Print girano   |
//|      sugli agent e non le legge nessuno (CHECKLIST punto 34,      |
//|      ribadito al 99). Quindi: Expert Advisor che non fa l'expert. |
//|                                                                  |
//|  ------------------------------------------------------------    |
//|  ORIGINE E ATTRIBUZIONE -- LEGGERE PRIMA DI TOCCARE IL FILE       |
//|  ------------------------------------------------------------    |
//|  Meccanica di SEGNALE derivata da uno script Pine v6 di 52 righe  |
//|  intitolato "RSI + EMA Crossover Signals V8".                     |
//|    AUTORE: IGNOTO. Il sorgente non dichiara nessun autore.        |
//|    PROVENIENZA: INCOLLATO IN CHAT DA CLAUDIO, 01-02/09/2026.      |
//|      Nessun link, nessuna pagina, nessun identificativo di        |
//|      pubblicazione: NON e' stato possibile risalire alla fonte    |
//|      originale, e NON si e' finto di averlo fatto.                |
//|    LICENZA: NON DICHIARATA nel sorgente. Non e' "libera": e'      |
//|      IGNOTA, che e' una cosa diversa e piu' vincolante.           |
//|  >>> CONSEGUENZE OPERATIVE, e valgono per chiunque legga:         |
//|    1. Questo file esiste per USO INTERNO DI MISURA. Serve a       |
//|       contare segnali su dati nostri e a decidere se un motore    |
//|       merita una corsa a tick. Nient'altro.                       |
//|    2. QUESTO PORTING NON VA REDISTRIBUITO COME ROBA NOSTRA. Non   |
//|       si pubblica, non si vende, non si mette in un pacchetto     |
//|       con la nostra firma sopra. Con una licenza ignota alle      |
//|       spalle, "l'abbiamo riscritto noi in MQL5" non e' una        |
//|       difesa: e' un'opinione.                                     |
//|    3. Se un giorno si volesse fare un EA operativo su questa      |
//|       logica, PRIMA si ritrova la fonte e si legge la licenza.    |
//|       Il costo di quel controllo e' minuti; il costo di saltarlo  |
//|       e' una grana legale su un conto vero.                       |
//|  Il sorgente NON e' stato archiviato in                           |
//|  caccia_strategie\biblioteca\sorgenti\ come si fa di regola,      |
//|  perche' l'archivio di casa nomina i file con autore e licenza    |
//|  (schema "Nome_Autore-Licenza_fonte_data.pine") e qui i due       |
//|  campi non esistono. Sta nella chat del 01-02/09 e nel referto.   |
//|  Se salta fuori la fonte, si archivia e si aggiorna questa testa. |
//|                                                                  |
//|  ------------------------------------------------------------    |
//|  LE DOMANDE, E SONO LE UNICHE                                     |
//|  ------------------------------------------------------------    |
//|  scheda : caccia_strategie\SCHEDA_RSIEMA_V8_2026-08-31.md         |
//|  criteri: prove\RSIEMAV8_FREQUENZA_M5.txt + gemella M15           |
//|  firma  : report\FIRME_2026-08-31.md (FIRMA 2, cancello H8) e il  |
//|           pavimento di frequenza firmato da Claudio l'01/09.      |
//|                                                                  |
//|   1. Quante volte al giorno, PER LATO, l'incrocio EMA arriva      |
//|      CON il pending dell'RSI gia' armato?                         |
//|          CANCELLO F1: totale (L+S) < 2,00/giorno  -> MORTO        |
//|                       oppure un lato < 1,00/giorno -> MORTO       |
//|   1-bis. E quel pending, SERVE? Oppure e' acceso quasi sempre e   |
//|      il motore e' solo un incrocio di EMA travestito -- cioe' la  |
//|      famiglia SuperWave/ChaosLyapunov, gia' morta due volte?      |
//|          ABLAZIONE: incrocio EMA NUDO contro segnali VERI, e la   |
//|          percentuale di barre col pending ARMATO. Nessun          |
//|          cancello: e' il confronto che dice se il filtro filtra.  |
//|   2. Quanto spazio favorevole c'e' davanti al segnale, in PUNTI   |
//|      INDICE, dentro il muro d'attrito di 12 barre?                |
//|          CANCELLO F2: MFE mediana > 7,0 -> VIVO                   |
//|                       MFE mediana < 5,0 -> MORTO                  |
//|                       fra 5,0 e 7,0     -> SOSPESO                |
//|   3. Quel premio quanto vale contro l'escursione avversa?         |
//|          CANCELLO H8: RR da mediane < 0,70 -> MORTO PER           |
//|          ARITMETICA, senza spendere una corsa a tick.             |
//|                                                                  |
//|  E I NUMERI SONO SEMPRE DUE, MAI UNO: LONG e SHORT SEPARATI       |
//|  (regola dei due lati, Claudio 25/08). Qui i due lati stanno      |
//|  nella STESSA corsa -- si puo' fare perche' non si apre niente e  |
//|  quindi non esiste nessuna posizione che i due lati si            |
//|  contendono -- ma NON esiste una sola colonna aggregata di        |
//|  MERITO: ogni numero di merito ha la sua colonna Long e la sua    |
//|  Short. L'UNICA colonna aggregata che entra in un cancello e'     |
//|  "Segnali Totali Al Giorno", e ci entra perche' il pavimento      |
//|  dell'01/09 e' scritto COSI' (2,00 totali E 1,00 per lato):       |
//|  e' un vincolo di PORTATA, e i due pezzi restano leggibili        |
//|  separatamente nelle loro colonne.                                |
//|                                                                  |
//|  ------------------------------------------------------------    |
//|  COSA QUESTA SONDA NON DICE, e non e' una dimenticanza            |
//|  ------------------------------------------------------------    |
//|   - NON dice se V8 guadagna. Un conteggio dice se un motore e'    |
//|     MISURABILE e se ha SPAZIO, non se ha EDGE. L'edge si misura   |
//|     a tick, dopo, e solo se questi numeri reggono (R57).          |
//|   - NON esce nessuna colonna di P/L, Profit Factor, drawdown:     |
//|     senza operazioni sarebbero tutti ZERO, e uno zero in colonna  |
//|     verrebbe letto prima o poi come un risultato. L'unica cosa    |
//|     che questa corsa produce sono CONTEGGI e DISTANZE.            |
//|   - NON promuove niente e non tocca nessuna sedia viva.           |
//|   - NON simula esiti: non sa quante volte lo spazio favorevole    |
//|     sarebbe stato incassato PRIMA di quello avverso. Quello e'    |
//|     l'ordine degli eventi dentro la barra, e lo vede solo il      |
//|     tick.                                                         |
//|   - NON ha uscite, ne' stop, ne' take: LA FONTE NON NE HA. E'     |
//|     un INDICATORE di segnali (lo dice la scheda del 31/08).       |
//|     Inventarle qui vorrebbe dire misurare il contenitore invece   |
//|     del motore -- e' la lezione LondonFx, ed e' scritta prima.    |
//|                                                                  |
//|  DEMO. ASCII puro: niente accenti dentro le stringhe, niente      |
//|  emoji (regola di casa dei .ps1, estesa qui perche' i log e i     |
//|  CSV finiscono negli stessi strumenti).                           |
//|  NON compilato ne' eseguito da chi ha scritto il file: in quel    |
//|  ambiente non esistono MetaEditor ne' Strategy Tester. Si         |
//|  compila in MetaEditor PRIMA di qualunque corsa.                  |
//+------------------------------------------------------------------+
//
//  MAPPA PINE <-> CODICE (verificabile riga per riga sul sorgente
//  incollato in chat; il sorgente non ha numeri di riga stabili
//  perche' non e' archiviato, quindi la mappa e' PER COSTRUTTO)
//  ------------------------------------------------------------------
//  costrutto Pine                        | qui
//  --------------------------------------|---------------------------
//  rsiLen = 14                           | V8_RSI_PERIODO      [V14]
//  rsiSignalLen = 14                     | V8_RSI_SEGNALE_PERIODO
//  emaFastLen = 5 / emaSlowLen = 20      | V8_EMA_VELOCE / V8_EMA_LENTA
//  rsi = ta.rsi(close, 14)               | RsiWilderSerie_Calc [V1]
//  rsiSignal = ta.sma(rsi, 14)           | SmaValidaSerie_Calc [V2]
//  emaFast = ta.ema(close, 5)            | EmaSerie_Calc       [V3]
//  emaSlow = ta.ema(close, 20)           | EmaSerie_Calc       [V3]
//  ta.crossover(a,b)                     | Crossover_Calc
//  ta.crossunder(a,b)                    | Crossunder_Calc
//  if crossover(rsi,rsiSignal)           | MotoreV8_Calc, passo 1 [V4]
//      pendingLong := true               |
//  if crossunder(rsi,rsiSignal) or       | MotoreV8_Calc, passo 2 [V4]
//     crossunder(emaFast,emaSlow)        |
//      pendingLong := false              |
//  longSignal = pendingLong and          | MotoreV8_Calc, passo 3 [V4]
//     ta.crossover(emaFast,emaSlow)      |
//  if longSignal                         | MotoreV8_Calc, passo 3
//      pendingLong := false              |
//  (specchio esatto per lo short)        | MotoreV8_Calc, rami short
//  barstate.isconfirmed / barra chiusa   | shift 1+orizzonte      [V6]
//  plotshape / alertcondition            | NON RIPRODOTTI: qui si
//                                        |   CONTA, non si disegna
//  (nessuno strategy.entry/exit)         | NON ESISTONO nella fonte:
//                                        |   e' un INDICATORE
//
//
//  LE SCELTE DI TRADUZIONE, NUMERATE. Sono NOSTRE, non del Pine.
//  ==================================================================
//
//  V1. RSI PINE CONTRO iRSI DI MQL5 -- VERIFICATO, NON ASSUNTO.
//      ta.rsi(src,len) di Pine = 100 - 100/(1+rs) con
//      rs = ta.rma(guadagni,len)/ta.rma(perdite,len), e ta.rma e' la
//      MEDIA DI WILDER (alfa = 1/len) SEMINATA con la SMA dei primi
//      len valori. iRSI di MQL5 fa ESATTAMENTE la stessa cosa
//      (RSI.mq5 di serie: seme = somma/periodo dei primi len delta,
//      poi ricorsione (prec*(len-1)+nuovo)/len). QUINDI I DUE
//      COINCIDONO, e non e' un'opinione: la sonda calcola l'RSI col
//      PROPRIO codice puro E in parallelo legge iRSI, e mette lo
//      SCARTO MASSIMO fra i due in una colonna ("Rsi Divergenza
//      Max"). ATTESA: praticamente ZERO (~1e-10). Se quella colonna
//      non e' ~0, la traduzione e' sbagliata e i numeri non valgono:
//      e' un collaudo, non un ornamento. E' lo stesso pattern gia'
//      passato sul campo nella SondaM0PB (T1, RsiDivMax 0,000).
//      Caso degenere dichiarato: perdite medie = 0 -> RSI 100 se ci
//      sono guadagni, 50 se il mercato e' perfettamente piatto (e' la
//      convenzione di RSI.mq5 di MQL5; Pine li' restituisce na). Su
//      un indice reale non capita mai; sta scritto perche' un caso
//      degenere non dichiarato e' un numero non spiegato.
//
//  V2. LA LINEA DI SEGNALE DELL'RSI E' UNA SMA DELL'RSI, NON DEL
//      PREZZO -- e questo ha una conseguenza che va detta: e'
//      DEFINITA SOLO DOVE L'RSI E' DEFINITO. ta.sma(rsi,14) in Pine
//      resta na finche' non ha 14 valori NON-na di rsi, cioe' fino
//      alla barra 14+14-1 = 27 (contando da 0). Qui la stessa cosa e'
//      esplicita: le serie usano -1 come marcatore di "non definito"
//      (-1 e' fuori dal dominio [0,100] dell'RSI, quindi nessun
//      confronto lo puo' scambiare per un valore vero) e
//      SmaValidaSerie_Calc produce un valore SOLO quando le ultime
//      'periodo' voci sono TUTTE valide. Un incrocio calcolato su un
//      marcatore sarebbe un incrocio inventato: Crossover_Calc e
//      Crossunder_Calc RIFIUTANO qualunque quaterna che contenga un
//      valore negativo.
//
//  V3. EMA PINE CONTRO iMA DI MQL5 -- I SEMI SONO DIVERSI, MA IL
//      SEME MUORE. ta.ema(src,len) di Pine semina con la SMA dei
//      primi len valori e poi applica alfa = 2/(len+1). L'EMA di MQL5
//      (Custom Moving Average.mq5, ExponentialMAOnBuffer) semina col
//      PRIMO PREZZO e poi applica lo stesso alfa. I due partono
//      diversi e CONVERGONO in modo esponenziale: per la EMA(20)
//      l'errore del seme si riduce di (1 - 2/21)^N, che su 280 barre
//      vale circa 1e-12; per la EMA(5) e' ancora piu' rapido. Quindi
//      la differenza NON e' una scelta di traduzione, e' polvere
//      numerica -- e anche questa si MISURA invece di dichiararla:
//      la colonna "Ema Divergenza Max" e' lo scarto massimo IN
//      PREZZO fra le nostre due EMA e le due iMA di MT5, atteso
//      < 0,00001 su un indice. Se fosse grande, o il warmup e'
//      troppo corto o il seeding non e' quello dichiarato.
//      >>> UN'ONESTA' IN PIU', perche' qui il segno conta: la
//      decisione non e' "quanto vale la EMA" ma "chi sta sopra".
//      A ridosso di un incrocio la differenza fra le due EMA e' ~0 e
//      una polvere di 1e-12 potrebbe, in linea di principio,
//      ribaltare il verso. Su un indice il tick di prezzo e' 0,01,
//      cioe' dieci ordini di grandezza sopra la polvere: il caso e'
//      teorico e sta scritto perche' un caso teorico non dichiarato
//      diventa una sorpresa.
//      NOTA: le nostre EMA marcano le barre prima del seme con -1
//      (non con 0 come faceva lo stampo M0PB). E' un IRROBUSTIMENTO
//      NECESSARIO: con lo 0 dello stampo, alla prima barra definita
//      la barra precedente valeva 0 per ENTRAMBE le medie, e un
//      confronto "veloce > lenta" con "prima erano pari" avrebbe
//      prodotto un INCROCIO INVENTATO. Lo stampo non aveva il
//      problema perche' non incrociava mai due EMA.
//
//  V4. L'ORDINE DEGLI EVENTI DENTRO LA BARRA -- E' IL CUORE DELLA
//      FEDELTA', ED E' LA COSA PIU' FACILE DA SBAGLIARE.
//      Il Pine valuta, su OGNI barra, in QUESTA sequenza:
//        passo 1 ARMA    : crossover(rsi,rsiSignal)  -> pendingLong = true
//                          crossunder(rsi,rsiSignal) -> pendingShort = true
//        passo 2 DISARMA : crossunder(rsi,rsiSignal) OR
//                          crossunder(emaFast,emaSlow) -> pendingLong = false
//                          crossover(rsi,rsiSignal) OR
//                          crossover(emaFast,emaSlow)  -> pendingShort = false
//        passo 3 SEGNALA : longSignal  = pendingLong  AND crossover(ema)
//                          shortSignal = pendingShort AND crossunder(ema)
//                          e il pending del lato che ha sparato si SPEGNE.
//      MotoreV8_Calc riproduce questi tre passi IN QUEST'ORDINE, e
//      l'autotest li interroga uno per uno. Le conseguenze da
//      dichiarare, tutte verificate da un blocco di autotest:
//      (a) ARMAMENTO E SEGNALE POSSONO CADERE SULLA STESSA BARRA. Se
//          su una barra l'RSI incrocia la sua SMA verso l'alto E le
//          EMA incrociano verso l'alto, il passo 1 arma e il passo 3
//          spara subito. NON e' un bug ed e' proprio quello che fa il
//          Pine: la sequenza e' un ordine di ASSEGNAZIONI dentro la
//          stessa barra, non un ritardo di una barra.
//      (b) IL PASSO 2 NON PUO' MAI ANNULLARE IL PASSO 3 SULLO STESSO
//          LATO, ed e' un fatto aritmetico, non una speranza:
//          crossover e crossunder DELLA STESSA COPPIA sono
//          mutuamente esclusivi su una barra (uno chiede a > b, l'
//          altro a < b). Quindi il "disarma su crossunder EMA" non
//          spegne mai un long che sta per sparare su crossover EMA;
//          serve a spegnere i pending VECCHI quando il trend gira.
//      (c) DOPO IL SEGNALE IL PENDING E' SPENTO: un secondo incrocio
//          EMA nello stesso verso, senza un nuovo incrocio RSI, NON
//          produce un secondo segnale. E' il motivo per cui questo
//          motore non e' un semplice incrocio di EMA -- ed e'
//          esattamente cio' che l'ablazione MISURA invece di
//          discuterlo.
//
//  V5. LO STATO A SCATTO NON DIMENTICA PER DECADIMENTO -- ED E' LA
//      DIFFERENZA VERA CON LO STAMPO.
//      Una media mobile dimentica il proprio seme in modo
//      esponenziale: e' per questo che lo stampo M0PB puo'
//      ricalcolare gli indicatori su una coda di 300 barre e avere
//      numeri esatti (T7). UN LATCH BOOLEANO NO: pendingLong e'
//      acceso o spento, e se nella coda non capitasse NESSUN evento
//      di armamento o disarmo, il suo valore dipenderebbe da com'era
//      PRIMA della coda -- cioe' da niente.
//      SOLUZIONE, ed e' una MISURA e non una speranza: la macchina a
//      stati gira DUE VOLTE sulla stessa coda, una con i pending
//      inizializzati a FALSO e una con i pending inizializzati a
//      VERO. Se le due corse danno lo STESSO segnale sulla barra
//      valutata, lo stato e' RICOSTRUITO e il seme non conta. Se
//      danno segnali diversi, la barra e' AMBIGUA:
//        - il segnale NON viene contato (si tiene la corsa
//          PESSIMISTA, quella col seme falso: un segnale che non si
//          sa dimostrare non e' un segnale, e l'errore va CONTRO il
//          candidato, cioe' nel verso onesto);
//        - il caso finisce nelle colonne "Stato Ambiguo Long/Short",
//          che sono INVARIANTI ATTESE A ZERO. Se non vengono zero,
//          InpWarmupBarre e' troppo corto e i numeri di quella corsa
//          NON valgono.
//      ATTESA ARGOMENTATA: nella coda utile (con i default, ~270
//      barre) l'RSI(14) incrocia la sua SMA(14) decine di volte; una
//      coda intera senza NESSUN incrocio ne' dell'RSI ne' delle EMA
//      e' praticamente impossibile su un indice. Ma "praticamente
//      impossibile" e' un'opinione finche' non c'e' una colonna che
//      lo controlla, e adesso c'e'.
//      NOTA DI MONOTONIA (serve a capire perche' la scelta pessimista
//      e' quella giusta): il latch acceso puo' solo produrre segnali
//      IN PIU', mai in meno. Quindi "ambiguo" vuol dire sempre "col
//      seme ottimista ci sarebbe un segnale, col pessimista no", e
//      scartarlo abbassa la frequenza misurata: sbagliamo CONTRO il
//      candidato, mai a suo favore.
//
//  V6. IL SEGNALE NASCE SU BARRA CHIUSA, SEMPRE.
//      La sonda non guarda mai la barra in formazione: niente
//      repaint, per costruzione. La fonte Pine e' su barra
//      confermata, quindi fa lo stesso.
//
//  V7. IL RITARDO DI MISURA, E PERCHE' NESSUN SEGNALE HA UN
//      ORIZZONTE TRONCATO (miglioria LondonFx L10).
//      Per misurare l'escursione servono le barre DOPO il segnale.
//      Invece di tenere una coda di segnali aperti, la sonda valuta
//      la barra che sta ORIZZONTE_MAX barre indietro: cosi' le barre
//      successive sono gia' tutte chiuse e stanno nello stesso
//      array, e OGNI segnale contato ha ENTRAMBI gli orizzonti
//      COMPLETI. Nessuna mediana e' sporcata da un orizzonte corto.
//      >>> PREZZO DA DICHIARARE: la CODA della finestra di corsa --
//      le ultime ORIZZONTE_MAX barre -- non viene valutata. Con i
//      default sono 96 barre, cioe' 8 ore su M5, su una finestra di
//      21 mesi: trascurabile sul denominatore dei giorni, ma va detto.
//
//  V8. IL PREZZO D'INGRESSO, E IL SEGNO DI MFE/MAE.
//      InpModoPrezzoIngresso = 1 (default, ed e' la RIGA DEL
//      VERDETTO): l'ingresso e' l'APERTURA DELLA BARRA SUCCESSIVA a
//      quella di segnale -- e' dove un EA vero riempirebbe, visto che
//      il segnale nasce su barra chiusa. La finestra di escursione
//      PARTE da quella stessa barra, inclusa: la posizione e' viva
//      dalla sua apertura, quindi il suo range conta. CONSEGUENZA
//      ARITMETICA: con l'ingresso all'apertura della prima barra
//      della finestra, il massimo della finestra e' >= ingresso e il
//      minimo e' <= ingresso, quindi MFE e MAE sono >= 0 SEMPRE, per
//      costruzione. Gli zeri sono zeri veri (nessuno spazio in quel
//      verso) e restano DENTRO la mediana: toglierli gonfierebbe la
//      mediana a favore del candidato.
//      InpModoPrezzoIngresso = 0 (passata INFORMATIVA, sensibilita'
//      gratis): l'ingresso e' la CHIUSURA della barra di segnale. La
//      finestra resta la stessa (parte dalla barra dopo), quindi
//      l'ingresso NON e' piu' dentro la finestra e MFE o MAE POSSONO
//      VENIRE NEGATIVE -- e' il gap fra la chiusura e cio' che
//      succede dopo. Quei casi NON si buttano (un'escursione negativa
//      e' un fatto: vuol dire che in quel verso non c'era proprio
//      niente) e finiscono nelle colonne "Mfe/Mae Non Positive".
//      >>> Con RR = mediana(MFE)/mediana(MAE), se la mediana della
//      MAE venisse <= 0 l'RR non e' calcolabile e vale 0: si legge
//      "non calcolabile", non "RR pessimo".
//
//  V9. PUNTI INDICE -- la conversione e' 100 e NON e' un'assunzione:
//      e' la misura del repo per U30USD, NASUSD e D30EUR (100 punti
//      MT5 = 1 punto indice; con SYMBOL_POINT = 0,01 il punto indice
//      vale 1,00 in prezzo). Sta in un input (InpPuntiPerIndice) e il
//      valore risultante ESCE IN COLONNA ("Punto Indice Prezzo"): se
//      su un simbolo non viene 1,00 il referto lo vede subito, invece
//      di leggere una taglia sbagliata di un fattore 10. E' la stessa
//      colonna che nella corsa M0PB del 31/08 e' venuta 1,000 su
//      tutti e tre gli indici (T8 dello stampo).
//
//  V10. LA GIORNATA = giornata di calendario del SERVER con almeno
//      una barra valutata. Non si contano i giorni del calendario
//      civile: un festivo senza barre non e' un giorno in cui il
//      motore "non ha trovato segnali", e' un giorno in cui il
//      mercato era chiuso. Dividere per quello gonfierebbe il
//      denominatore e ABBASSEREBBE la frequenza -- cioe' sbaglierebbe
//      CONTRO il candidato, e su un cancello di frequenza sarebbe un
//      errore che uccide.
//      L'ORA E' SEMPRE ORA SERVER (BCM = ora italiana - 1).
//
//  V11. L'ATR NON VIENE DALLA FONTE. Il sorgente non usa nessun ATR:
//      quello che esce in colonna ("Atr Mediano Punti Indice") e' un
//      METRO DI CASA, ATR di Wilder a 14 periodi, e serve a una cosa
//      sola -- sapere se la MFE mediana sta SOPRA o SOTTO il rumore
//      della barra, cioe' se il muro d'attrito e' un muro o una
//      soglia. Non decide niente e non ha cancelli. Il periodo e' un
//      #define e non un input APPOSTA: un metro che si puo' sweepare
//      dalla riga di lancio diventa una manopola da pesca.
//      E NON si confronta con iATR: iATR di MQL5 e' la SMA del True
//      Range, non la Wilder (differenza gia' MISURATA sul campo nella
//      SondaM0PB, T3: scarto 9,6-16,4%). Confrontarli darebbe una
//      divergenza attesa NON nulla, cioe' un collaudo che non
//      collauda. Il campione dell'ATR si raccoglie su OGNI BARRA
//      VALUTATA, non sui segnali: cosi' descrive il mercato e non i
//      segnali, e resta INVARIANTE fra le due passate dell'asse.
//
//  V12. NESSUN CAP GIORNALIERO, E I DUE LATI SONO INDIPENDENTI.
//      Qui NON esiste nessun cap e nessun "uno per volta": il cap si
//      TAGLIA SUI DATI, e i dati per tagliarlo sono le colonne "Max
//      Segnali Giorno" (e il promemoria prop stampato in coda al
//      referto: max x 0,65% contro il cap C1 di 3,25% firmato il
//      18/08). Mettere il cap dentro la sonda vorrebbe dire misurare
//      il cap invece del mercato.
//      I due lati possono sparare sulla stessa barra? Sul PAPERE si':
//      non c'e' nessun blocco reciproco. In pratica no, e vale la
//      pena saperlo: il long chiede crossover(ema) e lo short
//      crossunder(ema), che sono esclusivi. Quindi le colonne "Max
//      Segnali Giorno Totale" e la somma dei due lati coincidono
//      sempre, e nessuna barra produce due segnali opposti.
//
//  V13. L'ABLAZIONE SI MISURA DENTRO OGNI PASSATA (miglioria
//      LondonFx L13), E L'ASSE DIVENTA UN GATE DI DETERMINISMO.
//      La sonda conta SEMPRE, in ogni passata, per lato:
//        - "Segnali Nudo"    = i soli incroci EMA, pending IGNORATO
//        - "Armamenti Rsi"   = i soli incroci RSI/SMA(RSI)
//        - "Pending Attivo"  = barre valutate col latch ARMATO
//                              (misurato PRIMA del passo 3)
//        - "Segnali"         = quelli VERI, cioe' il motore completo,
//                              e sono quelli che portano le mediane e
//                              i cancelli.
//      Nessuno di questi quattro dipende dall'asse (che tocca solo il
//      PREZZO d'ingresso). Quindi, confrontando le due passate:
//        (a) tutti e quattro devono venire IDENTICI -> e' un GATE DI
//            DETERMINISMO vero, non una speranza (nella corsa M0PB
//            del 31/08 questo gate e' passato perfettamente);
//        (b) "Segnali" <= "Nudo" SEMPRE, per costruzione (il segnale
//            e' un sottoinsieme degli incroci EMA). Se non fosse
//            vero, il codice sarebbe rotto.
//      E LA LETTURA CHE INTERESSA, quella che la scheda del 31/08
//      chiedeva a parole ("filtro appiccicato sopra trigger
//      generico"), qui e' un numero:
//        - se "Segnali" ~ "Nudo" e "Pending Attivo" ~ tutte le barre,
//          il pending non filtra niente e il motore E' un incrocio di
//          EMA -- cioe' SuperWave/ChaosLyapunov, gia' morti;
//        - se "Segnali" << "Nudo", il pending morde davvero, e allora
//          la domanda diventa se morde troppo (cancello F1).
//      Il conto si legge da UNA SOLA RIGA del CSV.
//
//  V14. NIENTE SWEEP DEL MOTORE, E NON E' UNA DIMENTICANZA.
//      I quattro numeri del motore (14 / 14 / 5 / 20) sono i DEFAULT
//      DELLA FONTE e stanno qui come #define, NON come input. Non si
//      possono muovere dalla riga di lancio, e questo e' voluto: in
//      un PASSO 0 sweepare le lunghezze servirebbe solo a PESCARE la
//      cella che fa passare il pavimento. E' la regola della seconda
//      caccia (19/08) letta dall'altro lato: su un motore che il
//      giudizio di carta da' per morto, un'altra griglia trova solo
//      picchi di rumore. Qui si misura IL MOTORE DELL'AUTORE, con i
//      SUOI numeri, una volta sola.
//      L'UNICO asse della corsa e' InpModoPrezzoIngresso, che non e'
//      una manopola di merito: e' la sensibilita' al prezzo
//      d'ingresso, gratis, ed e' lo stesso asse usato dalla SondaM0PB
//      (il generico RIFIUTA zero assi, e la sonda non ha magic da
//      usare come gemelli).
//
//  V15. IL COSTO DI CALCOLO, dichiarato perche' si vede nel tempo di
//      corsa. Ogni barra nuova ricalcola cinque serie su una coda di
//      InpWarmupBarre barre E fa girare due volte la macchina a stati
//      (V5). E' piu' lento di uno stato incrementale, ma e' l'unica
//      forma che l'AUTOTEST puo' interrogare a tavolino e l'unica in
//      cui l'ambiguita' del latch e' MISURABILE. Sul banco M0PB
//      (modello 2, open prices) sono minuti, non ore.
//+------------------------------------------------------------------+
#property copyright "ABTG - Sonda di conteggio RSI+EMA V8 (PASSO 0, porta di rientro della scheda 31/08/2026)"
#property version   "1.00"
#property description "CONTATORE di segnali RSI+EMA V8 (pending su incrocio RSI/SMA(RSI) + innesco su incrocio EMA5/EMA20). NON APRE ORDINI."
#property strict

//==================================================================
//  I NUMERI DEL MOTORE -- PINNATI AI DEFAULT DELLA FONTE.
//  Sono #define e NON input APPOSTA (vedi V14): un parametro che si
//  puo' muovere dalla riga di lancio non e' pinnato, e in un PASSO 0
//  sweeparlo sarebbe pescare.
//==================================================================
#define V8_RSI_PERIODO          14   // ta.rsi(close, 14)
#define V8_RSI_SEGNALE_PERIODO  14   // ta.sma(rsi, 14)
#define V8_EMA_VELOCE            5   // ta.ema(close, 5)
#define V8_EMA_LENTA            20   // ta.ema(close, 20)

//--- il metro di rumore di V11. #define e non input: non e' una manopola.
#define V8_ATR_PERIODO          14

//==================================================================
//  LE SOGLIE CONGELATE PRIMA DI VEDERE I NUMERI.
//  Fonte: prove\RSIEMAV8_FREQUENZA_M5.txt (e gemella M15), scritte
//  li' PRIMA che questa sonda producesse un solo numero.
//  Sono #define e non input APPOSTA: un cancello che si puo'
//  spostare dalla riga di lancio non e' un cancello.
//==================================================================
#define V8_SOGLIA_SEGNALI_TOT_GIORNO   2.00   // F1, pavimento TOTALE (L+S) firmato da Claudio 01/09
#define V8_SOGLIA_SEGNALI_LATO_GIORNO  1.00   // F1, pavimento PER LATO (scheda 31/08)
#define V8_SOGLIA_MFE_SCARTO           5.00   // F2, sotto questa e' MORTO
#define V8_SOGLIA_MFE_VIVO             7.00   // F2, sopra questa e' VIVO. Fra le due: SOSPESO
#define V8_SOGLIA_RR                   0.70   // H8, FIRME_2026-08-31.md FIRMA 2
#define V8_E_TARGET_R                  0.075  // H8, E >= 0,075R a tick

//--- LE DISUGUAGLIANZE, SCRITTE SENZA SOVRAPPOSIZIONI (clausola
//    severa della classe 31/08). Il criterio dettato dice "VIVO solo
//    > 7,0 | < 5,0 MORTO | 5,0-7,0 SOSPESO": la fascia di mezzo e'
//    CHIUSA su entrambi i lati e le altre due sono STRETTE, cosi'
//    nessun punto dell'asse cade in due clausole e nessun punto resta
//    scoperto:
//        MFE mediana <  5,00 punti indice          -> MORTO F2
//        MFE mediana >= 5,00 e <= 7,00 punti indice-> SOSPESO F2
//        MFE mediana >  7,00 punti indice          -> VIVO F2
//    La fascia SOSPESA non e' un limbo comodo: e' il caso in cui il
//    verdetto DIPENDE dallo spread vero, che in repo NON esiste
//    ([SPREAD NON MISURATO]). Si scioglie misurandolo col Code Base
//    74148 (RealCost Spread P95 Logger, promosso il 23/08 e MAI
//    ancora usato), non discutendone.
//    E i verdetti sono FUNZIONI PURE che l'autotest esegue su una
//    cella di OGNI fascia E sui due bordi esatti -- perche' un gate
//    che ricopia le SOGLIE senza ricopiare le DISUGUAGLIANZE e' come
//    non averlo (e' successo, ed e' nella checklist).

//--- quanti blocchi di autotest DEVONO girare. Se il contatore a
//    runtime non arriva a questo numero, un blocco e' sparito e
//    l'autotest si dichiara FALLITO: un test rimosso per sbaglio non
//    deve poter passare per "tutto verde" (miglioria LondonFx).
#define V8_AUTOTEST_BLOCCHI_ATTESI 16

//--- capienza dei campioni per le mediane. Se si arrivasse al tetto
//    la mediana sarebbe TRONCATA, quindi il fatto viene stampato a
//    voce alta invece di essere ingoiato.
#define V8_MAX_CAMPIONI 100000

//--- marcatore di "valore non definito" nelle serie. -1 e' fuori dal
//    dominio dell'RSI [0,100] e fuori dal dominio di un prezzo di
//    indice (> 0): nessun confronto lo puo' scambiare per un valore
//    vero, e Crossover_Calc/Crossunder_Calc lo rifiutano.
#define V8_NON_DEFINITO (-1.0)

//==================================================================
//  INPUT
//  I nomi vanno pinnati TALI E QUALI nel file prova: MT5 IGNORA IN
//  SILENZIO un pin che non trova (errore n.3 della
//  CHECKLIST_RIGA_DI_LANCIO, e' cosi' che e' nato il falso "0/8" del
//  FiboH4).
//  QUI NON C'E' NESSUN INPUT DEL MOTORE: sono tutti #define (V14).
//  Quello che resta e' o l'UNITA' DI MISURA, o l'ORIZZONTE del
//  criterio, o roba tecnica.
//==================================================================
input group "=== GLI ORIZZONTI DI MISURA (vedi V7) ==="
input int    InpBarreOrizzonte      = 12;  // MURO D'ATTRITO: barre su cui si misurano MFE/MAE DEL CANCELLO F2/H8
input int    InpBarreOrizzonteLungo = 96;  // orizzonte INFORMATIVO, nessun cancello: 96 barre M5 = 8 ore

input group "=== TRADUZIONE (scelte nostre, dichiarate) ==="
input int    InpModoPrezzoIngresso = 1;    // 1 = apertura barra successiva (RIGA DEL VERDETTO). 0 = chiusura barra di segnale. Vedi V8
input double InpPuntiPerIndice     = 100.0;// punti MT5 per 1 punto indice. MISURATO = 100 su U30USD/NASUSD/D30EUR. Vedi V9

input group "=== FINESTRA ORARIA (default NEUTRO: si conta TUTTO) ==="
input bool   InpUsaFinestraOraria = false; // false = nessun filtro orario: si conta tutta la giornata
input int    InpOraInizioServer   = 14;    // ORA SERVER BCM (italiana - 1). 14 = 15:00 IT, apertura US
input int    InpOraFineServer     = 21;    // ORA SERVER BCM, inclusa

input group "=== TECNICI ==="
input int    InpWarmupBarre    = 400;      // coda di barre su cui si ricalcola tutto. Piu' lunga dello stampo APPOSTA: vedi V5
input bool   InpConfrontaMT5   = true;     // legge anche iRSI/iMA e mette lo SCARTO in colonna (collaudo V1/V3)
input bool   InpScriviCsv      = true;     // CSV riga-per-segnale + CSV totali (SOLO fuori ottimizzazione)
input bool   InpVerbose        = true;     // log (in ottimizzazione NON li legge nessuno: vedi le colonne)
input bool   InpAutoTest       = true;     // autotest del nucleo puro. L'esito esce in COLONNA
input string InpTag            = "RSIEMAV8_SONDA"; // ETICHETTA della corsa (NON e' un magic: qui non ci sono ordini)

//==================================================================
//  STATO -- tutti accumulatori di conteggio. Nessuno stato di
//  posizione, perche' non esistono posizioni.
//==================================================================
datetime gLastBar = 0;

//--- gli handle degli indicatori MT5, usati SOLO per il collaudo V1/V3
int    hRsiMt5   = INVALID_HANDLE;
int    hEmaVMt5  = INVALID_HANDLE;
int    hEmaLMt5  = INVALID_HANDLE;

//--- il ritardo di misura (V7) = massimo dei due orizzonti
int    gOrizzonteMax = 0;

//--- la prima barra su cui si puo' DECIDERE un incrocio (V2)
int    gPrimoDecidibile = 0;

//--- conversione prezzo <-> punto indice
double gPuntoIndice = 0.0;

//--- conteggi generali
long   gBarreValutate    = 0;
long   gBarreSaltateDati = 0;   // storico corto o prezzo non valido: barra NON valutata
long   gScartatiOrario   = 0;   // segnali caduti fuori dalla finestra oraria

//--- conteggi per LATO (mai aggregati in una colonna di merito)
long   gSegnaliLong = 0, gSegnaliShort = 0;   // il motore COMPLETO: portano i cancelli
long   gNudoLong    = 0, gNudoShort    = 0;   // ablazione: soli incroci EMA
long   gPendingLong = 0, gPendingShort = 0;   // ablazione: barre col latch ARMATO
long   gArmamentiLong = 0, gArmamentiShort = 0; // soli incroci RSI/SMA(RSI)
long   gAmbiguoLong = 0, gAmbiguoShort = 0;   // INVARIANTE ATTESA 0 (V5)
long   gMfeNonPosLong = 0, gMfeNonPosShort = 0;
long   gMaeNonPosLong = 0, gMaeNonPosShort = 0;

//--- giornate (V10)
int    gDayStamp      = -1;
int    gDaySigLong    = 0, gDaySigShort = 0;
long   gGiorniContati = 0;
long   gMaxGiornoLong = 0, gMaxGiornoShort = 0, gMaxGiornoTot = 0;
long   gG1Long = 0, gG2Long = 0, gG1Short = 0, gG2Short = 0;
long   gG1Tot  = 0, gG2Tot  = 0, gGiorniZero = 0;

//--- campioni per le mediane (in PUNTI INDICE)
double gMfeL[],  gMfeS[],  gMaeL[],  gMaeS[];
double gMfeLL[], gMfeLS[], gMaeLL[], gMaeLS[];
double gRrL[],   gRrS[],   gAtrPts[];
int    gNMfeL = 0, gNMfeS = 0, gNMaeL = 0, gNMaeS = 0;
int    gNMfeLL = 0, gNMfeLS = 0, gNMaeLL = 0, gNMaeLS = 0;
int    gNRrL = 0,  gNRrS = 0,  gNAtr = 0;
bool   gTroncato = false;

//--- somme per le medie (la media accanto alla mediana dice l'asimmetria)
double gSommaMfeL = 0.0, gSommaMfeS = 0.0;

//--- collaudi V1 e V3
double gRsiDivMax = 0.0;
double gEmaDivMax = 0.0;

//--- autotest: -1 = NON eseguito, che non e' "passato"
int    gAutotestFalliti = -1;
int    gAutotestBlocchi = 0;

//--- CSV riga-per-segnale
int    gCsvSeg = INVALID_HANDLE;

void Log(string m){ if(InpVerbose) Print("[RSIEMAV8-SONDA] ", m); }

//==================================================================
//
//   NUCLEO PURO -- funzioni che non leggono NIENTE dal terminale.
//   Prendono numeri e rispondono. E' questa la parte che l'AUTOTEST
//   interroga a tavolino, senza mercato.
//
//==================================================================

//+------------------------------------------------------------------+
//| RSI da medie di Wilder gia' calcolate. Il caso degenere e'         |
//| esplicito (vedi V1): perdite nulle -> 100 se ci sono guadagni,     |
//| 50 se il mercato e' perfettamente piatto. E' la convenzione di     |
//| RSI.mq5 di MQL5.                                                   |
//+------------------------------------------------------------------+
double RsiDaMedie_Calc(const double mediaGuadagni, const double mediaPerdite)
  {
   if(mediaPerdite <= 0.0) return(mediaGuadagni > 0.0 ? 100.0 : 50.0);
   double rs = mediaGuadagni/mediaPerdite;
   return(100.0 - 100.0/(1.0 + rs));
  }

//+------------------------------------------------------------------+
//| RSI DI WILDER su tutta la serie (indice 0 = barra piu' VECCHIA).   |
//| Seme = media semplice dei primi 'periodo' delta, poi ricorsione di |
//| Wilder: e' ta.rsi di Pine ed e' iRSI di MQL5 (vedi V1).            |
//| out[i] = V8_NON_DEFINITO sulle barre in cui l'RSI non e' ancora    |
//| definito.                                                          |
//+------------------------------------------------------------------+
bool RsiWilderSerie_Calc(const double &close[], const int n, const int periodo, double &out[])
  {
   if(periodo < 1 || n <= periodo) return(false);
   if(ArrayResize(out, n) != n) return(false);
   for(int i = 0; i < n; i++) out[i] = V8_NON_DEFINITO;

   double sg = 0.0, sp = 0.0;
   for(int i = 1; i <= periodo; i++)
     {
      double d = close[i] - close[i-1];
      if(d > 0.0) sg += d; else sp += -d;
     }
   double ag = sg/(double)periodo;
   double ap = sp/(double)periodo;
   out[periodo] = RsiDaMedie_Calc(ag, ap);

   for(int i = periodo + 1; i < n; i++)
     {
      double d = close[i] - close[i-1];
      double g = (d > 0.0) ?  d : 0.0;
      double p = (d < 0.0) ? -d : 0.0;
      ag = (ag*(periodo - 1.0) + g)/(double)periodo;
      ap = (ap*(periodo - 1.0) + p)/(double)periodo;
      out[i] = RsiDaMedie_Calc(ag, ap);
     }
   return(true);
  }

//+------------------------------------------------------------------+
//| SMA DI UNA SERIE CHE PUO' ESSERE NON DEFINITA (vedi V2).           |
//| E' ta.sma(rsi, len) di Pine: produce un valore SOLO quando le      |
//| ultime 'periodo' voci della sorgente sono TUTTE valide (>= 0).     |
//| Alla prima voce non valida il contatore riparte da capo, esattamente|
//| come na in Pine. Tutto il resto resta V8_NON_DEFINITO.             |
//| NOTA: si somma e si divide ogni volta sulla finestra invece di     |
//| tenere una somma rotolante. E' O(n*periodo) e su 400 barre non si  |
//| sente; in cambio non esiste nessun drift di somma da sottrazioni   |
//| ripetute, e la funzione e' leggibile a occhio nudo -- che in un    |
//| file che deve essere CONTROLLATO vale piu' di qualche microsecondo.|
//+------------------------------------------------------------------+
bool SmaValidaSerie_Calc(const double &src[], const int n, const int periodo, double &out[])
  {
   if(periodo < 1 || n < 1) return(false);
   if(ArrayResize(out, n) != n) return(false);
   for(int i = 0; i < n; i++) out[i] = V8_NON_DEFINITO;
   if(n < periodo) return(true);   // array valido, nessun valore: non e' un errore

   for(int i = periodo - 1; i < n; i++)
     {
      double s = 0.0;
      bool   ok = true;
      for(int k = i - periodo + 1; k <= i; k++)
        {
         if(src[k] < 0.0){ ok = false; break; }
         s += src[k];
        }
      if(ok) out[i] = s/(double)periodo;
     }
   return(true);
  }

//+------------------------------------------------------------------+
//| EMA alla Pine: seme = SMA dei primi 'periodo' valori, poi          |
//| alfa = 2/(periodo+1). Le barre prima del seme restano              |
//| V8_NON_DEFINITO -- e NON a zero come faceva lo stampo M0PB: con lo |
//| zero, alla prima barra definita le due EMA sarebbero risultate     |
//| PARI sulla barra precedente e Crossover_Calc avrebbe inventato un  |
//| incrocio (vedi V3, nota finale).                                   |
//+------------------------------------------------------------------+
bool EmaSerie_Calc(const double &src[], const int n, const int periodo, double &out[])
  {
   if(periodo < 1 || n < periodo) return(false);
   if(ArrayResize(out, n) != n) return(false);
   for(int i = 0; i < n; i++) out[i] = V8_NON_DEFINITO;

   double s = 0.0;
   for(int i = 0; i < periodo; i++) s += src[i];
   out[periodo - 1] = s/(double)periodo;

   double a = 2.0/(periodo + 1.0);
   for(int i = periodo; i < n; i++) out[i] = out[i-1] + a*(src[i] - out[i-1]);
   return(true);
  }

//+------------------------------------------------------------------+
//| TRUE RANGE alla Pine (ta.tr): sulla PRIMA barra della finestra non |
//| c'e' chiusura precedente, quindi TR = high - low.                  |
//+------------------------------------------------------------------+
bool TrSerie_Calc(const double &high[], const double &low[], const double &close[],
                  const int n, double &out[])
  {
   if(n < 1) return(false);
   if(ArrayResize(out, n) != n) return(false);
   out[0] = high[0] - low[0];
   for(int i = 1; i < n; i++)
     {
      double a = high[i] - low[i];
      double b = MathAbs(high[i] - close[i-1]);
      double c = MathAbs(low[i]  - close[i-1]);
      double m = a;
      if(b > m) m = b;
      if(c > m) m = c;
      out[i] = m;
     }
   return(true);
  }

//+------------------------------------------------------------------+
//| ATR DI WILDER (RMA del True Range). E' il metro di casa di V11:    |
//| NON viene dalla fonte e NON si confronta con iATR, che in MQL5 e'  |
//| la SMA del TR (differenza gia' misurata nella SondaM0PB, T3).      |
//+------------------------------------------------------------------+
bool AtrWilderSerie_Calc(const double &tr[], const int n, const int periodo, double &out[])
  {
   if(periodo < 1 || n < periodo) return(false);
   if(ArrayResize(out, n) != n) return(false);
   for(int i = 0; i < n; i++) out[i] = 0.0;

   double s = 0.0;
   for(int i = 0; i < periodo; i++) s += tr[i];
   out[periodo - 1] = s/(double)periodo;

   double a = 1.0/(double)periodo;
   for(int i = periodo; i < n; i++) out[i] = out[i-1] + a*(tr[i] - out[i-1]);
   return(true);
  }

//+------------------------------------------------------------------+
//| ta.crossover(a,b) DI PINE: a e' passata SOPRA b su questa barra,   |
//| cioe' PRIMA a <= b e ADESSO a > b.                                 |
//| GUARDIA (vedi V2): se uno qualunque dei quattro valori e' un       |
//| marcatore di "non definito" (< 0) NON c'e' incrocio. In Pine un    |
//| confronto con na e' falso, e qui deve esserlo altrettanto: un      |
//| incrocio calcolato su un marcatore sarebbe un incrocio inventato.  |
//| Il bordo di uguaglianza e' ASIMMETRICO ed e' quello di Pine: se    |
//| prima erano ESATTAMENTE pari e adesso a > b, l'incrocio C'E'.      |
//+------------------------------------------------------------------+
bool Crossover_Calc(const double aPrec, const double bPrec,
                    const double a,     const double b)
  {
   if(aPrec < 0.0 || bPrec < 0.0 || a < 0.0 || b < 0.0) return(false);
   return(aPrec <= bPrec && a > b);
  }

//+------------------------------------------------------------------+
//| ta.crossunder(a,b) DI PINE: specchio esatto.                       |
//+------------------------------------------------------------------+
bool Crossunder_Calc(const double aPrec, const double bPrec,
                     const double a,     const double b)
  {
   if(aPrec < 0.0 || bPrec < 0.0 || a < 0.0 || b < 0.0) return(false);
   return(aPrec >= bPrec && a < b);
  }

//+------------------------------------------------------------------+
//|                                                                    |
//|  IL MOTORE V8 -- LA MACCHINA A STATI, NELL'ORDINE DEL PINE.        |
//|                                                                    |
//|  Gira sulle barre da 'daIdx' a 'iTarget' INCLUSI e restituisce lo  |
//|  stato e i segnali COME STAVANO SULLA BARRA iTarget.               |
//|  I tre passi sono quelli di V4 e l'ordine E' la fedelta':          |
//|    1) ARMA    su incrocio RSI/SMA(RSI) nel verso del lato          |
//|    2) DISARMA su incrocio RSI contrario OPPURE incrocio EMA        |
//|       contrario                                                    |
//|    3) SEGNALA se il pending e' armato E le EMA incrociano nel      |
//|       verso del lato; e il pending che ha sparato si SPEGNE.       |
//|  I pending iniziali sono un PARAMETRO apposta: e' cosi' che si     |
//|  misura l'ambiguita' del latch (V5), facendo girare due volte la   |
//|  stessa coda con semi opposti.                                     |
//|                                                                    |
//|  Escono anche i tre numeri dell'ablazione (V13) RIFERITI ALLA      |
//|  BARRA iTarget e non all'intera coda: nudo = solo incrocio EMA,    |
//|  armamento = solo incrocio RSI, pendingPrima = il latch com'era    |
//|  ENTRANDO nel passo 3. Cosi' contarli dal chiamante, una volta per |
//|  barra valutata, non li duplica.                                   |
//+------------------------------------------------------------------+
bool MotoreV8_Calc(const double &rsi[], const double &rsiSig[],
                   const double &emaV[], const double &emaL[],
                   const int n, const int daIdx, const int iTarget,
                   const bool pendLongIniz, const bool pendShortIniz,
                   bool &sigLong, bool &sigShort,
                   bool &pendLongPrima, bool &pendShortPrima,
                   bool &nudoLong, bool &nudoShort,
                   bool &armaLong, bool &armaShort)
  {
   sigLong = false; sigShort = false;
   pendLongPrima = false; pendShortPrima = false;
   nudoLong = false; nudoShort = false;
   armaLong = false; armaShort = false;

   if(n < 2 || daIdx < 1 || iTarget >= n || iTarget < daIdx) return(false);

   bool pl = pendLongIniz;
   bool ps = pendShortIniz;

   for(int i = daIdx; i <= iTarget; i++)
     {
      bool rsiSu  = Crossover_Calc (rsi[i-1],  rsiSig[i-1], rsi[i],  rsiSig[i]);
      bool rsiGiu = Crossunder_Calc(rsi[i-1],  rsiSig[i-1], rsi[i],  rsiSig[i]);
      bool emaSu  = Crossover_Calc (emaV[i-1], emaL[i-1],   emaV[i], emaL[i]);
      bool emaGiu = Crossunder_Calc(emaV[i-1], emaL[i-1],   emaV[i], emaL[i]);

      //--- passo 1: ARMA
      if(rsiSu)  pl = true;
      if(rsiGiu) ps = true;

      //--- passo 2: DISARMA
      if(rsiGiu || emaGiu) pl = false;
      if(rsiSu  || emaSu)  ps = false;

      //--- il latch com'e' ENTRANDO nel passo 3: e' questo il numero
      //    dell'ablazione "Pending Attivo", non quello di fine barra.
      bool plPrima = pl;
      bool psPrima = ps;

      //--- passo 3: SEGNALA, e chi spara si spegne
      bool sl = (pl && emaSu);
      bool ss = (ps && emaGiu);
      if(sl) pl = false;
      if(ss) ps = false;

      if(i == iTarget)
        {
         sigLong = sl;   sigShort = ss;
         pendLongPrima = plPrima; pendShortPrima = psPrima;
         nudoLong = emaSu; nudoShort = emaGiu;
         armaLong = rsiSu; armaShort = rsiGiu;
        }
     }
   return(true);
  }

//+------------------------------------------------------------------+
//| MASSIMO su una finestra che PARTE dall'indice 'da' e comprende     |
//| 'quante' barre. La finestra si TOSA se sborda in avanti: non si    |
//| legge mai fuori dall'array. 'da' fuori range -> 0.                 |
//+------------------------------------------------------------------+
double MassimoFinestra_Calc(const double &v[], const int n, const int da, const int quante)
  {
   if(quante < 1 || da < 0 || da >= n) return(0.0);
   int fine = da + quante - 1;
   if(fine > n - 1) fine = n - 1;
   double m = v[da];
   for(int i = da + 1; i <= fine; i++) if(v[i] > m) m = v[i];
   return(m);
  }

//+------------------------------------------------------------------+
//| MINIMO su una finestra che PARTE dall'indice 'da'. Specchio.       |
//+------------------------------------------------------------------+
double MinimoFinestra_Calc(const double &v[], const int n, const int da, const int quante)
  {
   if(quante < 1 || da < 0 || da >= n) return(0.0);
   int fine = da + quante - 1;
   if(fine > n - 1) fine = n - 1;
   double m = v[da];
   for(int i = da + 1; i <= fine; i++) if(v[i] < m) m = v[i];
   return(m);
  }

//+------------------------------------------------------------------+
//| MEDIANA di un vettore GIA' ORDINATO. Pari -> media dei centrali.   |
//| n <= 0 -> 0, che si legge "nessun campione", non "zero punti".     |
//+------------------------------------------------------------------+
double MedianaOrdinata_Calc(const double &v[], const int n)
  {
   if(n <= 0) return(0.0);
   if(n % 2 == 1) return(v[n/2]);
   return((v[n/2 - 1] + v[n/2])/2.0);
  }

//+------------------------------------------------------------------+
//| Da differenza di PREZZO a PUNTI INDICE (vedi V9). puntoIndice <= 0 |
//| -> 0, che si legge "non convertibile", e la colonna "Punto Indice  |
//| Prezzo" dice perche'.                                              |
//+------------------------------------------------------------------+
double PuntiIndice_Calc(const double diffPrezzo, const double puntoIndice)
  {
   if(puntoIndice <= 0.0) return(0.0);
   return(diffPrezzo/puntoIndice);
  }

//+------------------------------------------------------------------+
//| RR = mediana(favorevole) / mediana(avversa). E' definito COSI' nel |
//| criterio congelato (numero 2 diviso numero 3), NON come mediana    |
//| dei rapporti: sono due numeri diversi e la sonda li stampa TUTTI E |
//| DUE, dichiarando quale e' il cancello.                             |
//| Mediana avversa <= 0 -> 0, che si legge "non calcolabile" (vedi V8)|
//+------------------------------------------------------------------+
double RrDaMediane_Calc(const double mfeMediana, const double maeMediana)
  {
   if(maeMediana <= 0.0) return(0.0);
   return(mfeMediana/maeMediana);
  }

//+------------------------------------------------------------------+
//| L'ARITMETICA DEL CANCELLO H8, in una funzione sola.                |
//| Da E = p*RR - (1-p) segue p = (E+1)/(RR+1): e' il win rate         |
//| NECESSARIO perche' il valore atteso raggiunga E.                   |
//| Riproduce la tabella CONGELATA (par. 5-bis del dossier di caccia): |
//|   RR 0,36 -> 79,0% | 0,50 -> 71,7% | 0,73 -> 62,2% | 1,00 -> 53,8% |
//| L'autotest confronta con QUEI quattro valori: se la formula si     |
//| muove, il cancello se ne accorge.                                  |
//+------------------------------------------------------------------+
double WinRateNecessario_Calc(const double rr, const double eTarget)
  {
   if(rr <= -1.0) return(0.0);
   return((eTarget + 1.0)/(rr + 1.0));
  }

//+------------------------------------------------------------------+
//| La finestra oraria in ORA SERVER, estremi INCLUSI. Sostiene anche  |
//| il caso a cavallo della mezzanotte (inizio > fine), che su un      |
//| indice non serve ma su un futuro asiatico si'.                     |
//+------------------------------------------------------------------+
bool FinestraOraria_Calc(const int ora, const int inizio, const int fine, const bool attiva)
  {
   if(!attiva) return(true);
   if(ora < 0 || ora > 23) return(false);
   if(inizio < 0 || inizio > 23 || fine < 0 || fine > 23) return(false);
   if(inizio <= fine) return(ora >= inizio && ora <= fine);
   return(ora >= inizio || ora <= fine);
  }

//+------------------------------------------------------------------+
//| I VERDETTI, CALCOLATI DA CODICE E NON RILETTI A OCCHIO.            |
//| Un gate che ricopia le SOGLIE senza ricopiare le DISUGUAGLIANZE    |
//| non e' un gate. Qui le disuguaglianze SONO il codice, e l'autotest |
//| le esegue su una cella di OGNI fascia e sui BORDI ESATTI.          |
//+------------------------------------------------------------------+
//| F1: DUE condizioni in AND (pavimento dell'01/09). Se cadono         |
//| entrambe, il messaggio nomina il TOTALE per primo -- e' una scelta  |
//| di ordine dichiarata, non un giudizio: i due numeri restano         |
//| leggibili separatamente nelle loro colonne.                         |
//+------------------------------------------------------------------+
string VerdettoF1_Calc(const double segnaliGiornoLato, const double segnaliGiornoTotale)
  {
   if(segnaliGiornoTotale < V8_SOGLIA_SEGNALI_TOT_GIORNO)
      return("MORTO F1 - TOTALE SOTTO IL PAVIMENTO");
   if(segnaliGiornoLato < V8_SOGLIA_SEGNALI_LATO_GIORNO)
      return("MORTO F1 - LATO SOTTO IL PAVIMENTO");
   return("PASSA F1");
  }

//+------------------------------------------------------------------+
//| F2: tre fasce, nessuna sovrapposizione, nessun buco (vedi il       |
//| blocco di #define in testa).                                        |
//+------------------------------------------------------------------+
string VerdettoF2_Calc(const double mfeMediana)
  {
   if(mfeMediana <  V8_SOGLIA_MFE_SCARTO) return("MORTO F2");
   if(mfeMediana <= V8_SOGLIA_MFE_VIVO)   return("SOSPESO F2 - serve lo spread VERO (74148)");
   return("VIVO F2");
  }

//+------------------------------------------------------------------+
//| H8: sotto soglia si muore PER ARITMETICA, senza corsa a tick.      |
//+------------------------------------------------------------------+
string VerdettoH8_Calc(const double rr)
  {
   if(rr < V8_SOGLIA_RR) return("MORTO H8 PER ARITMETICA");
   return("PASSA H8");
  }

//==================================================================
//  RACCOLTA DEI CAMPIONI (memoria, non pensiero)
//  Guardia anti-inf/nan: un valore non finito non entra MAI in un
//  vettore da mediana. Se ci entrasse, ArraySort lo metterebbe in
//  fondo e la mediana verrebbe plausibile e sbagliata.
//==================================================================
void Aggiungi(double &v[], int &n, const double x)
  {
   if(!MathIsValidNumber(x)) return;
   if(n >= V8_MAX_CAMPIONI){ gTroncato = true; return; }
   if(n >= ArraySize(v))
     {
      int nuovo = (ArraySize(v) <= 0) ? 4096 : ArraySize(v)*2;
      if(nuovo > V8_MAX_CAMPIONI) nuovo = V8_MAX_CAMPIONI;
      if(ArrayResize(v, nuovo) <= n){ gTroncato = true; return; }
     }
   v[n] = x;
   n++;
  }

double Mediana(const double &v[], const int n)
  {
   if(n <= 0) return(0.0);
   double c[];
   if(ArrayResize(c, n) != n) return(0.0);
   for(int i = 0; i < n; i++) c[i] = v[i];
   ArraySort(c);
   return(MedianaOrdinata_Calc(c, n));
  }

//==================================================================
//  CICLO DI VITA
//==================================================================

//+------------------------------------------------------------------+
//| AZZERAMENTO ESPLICITO DI TUTTI I CONTATORI.                       |
//| In ottimizzazione MT5 rilancia l'EA a ogni passata e le globali   |
//| dovrebbero ripartire dai loro valori iniziali -- DOVREBBERO. Una  |
//| passata che ereditasse i campioni della precedente darebbe mediane|
//| sporche e nessuno se ne accorgerebbe guardando il CSV: i numeri   |
//| sarebbero plausibili e sbagliati. Peggio ancora qui, dove i       |
//| conteggi dell'ablazione devono venire IDENTICI fra le due passate |
//| (V13): un residuo li farebbe divergere e il gate di determinismo  |
//| accuserebbe il codice giusto. Azzerare a mano costa una funzione  |
//| e toglie il dubbio.                                               |
//+------------------------------------------------------------------+
void AzzeraContatori()
  {
   gLastBar = 0;
   gBarreValutate = 0; gBarreSaltateDati = 0; gScartatiOrario = 0;
   gSegnaliLong = 0; gSegnaliShort = 0;
   gNudoLong = 0; gNudoShort = 0;
   gPendingLong = 0; gPendingShort = 0;
   gArmamentiLong = 0; gArmamentiShort = 0;
   gAmbiguoLong = 0; gAmbiguoShort = 0;
   gMfeNonPosLong = 0; gMfeNonPosShort = 0;
   gMaeNonPosLong = 0; gMaeNonPosShort = 0;
   gDayStamp = -1; gDaySigLong = 0; gDaySigShort = 0;
   gGiorniContati = 0;
   gMaxGiornoLong = 0; gMaxGiornoShort = 0; gMaxGiornoTot = 0;
   gG1Long = 0; gG2Long = 0; gG1Short = 0; gG2Short = 0;
   gG1Tot = 0; gG2Tot = 0; gGiorniZero = 0;
   gNMfeL = 0; gNMfeS = 0; gNMaeL = 0; gNMaeS = 0;
   gNMfeLL = 0; gNMfeLS = 0; gNMaeLL = 0; gNMaeLS = 0;
   gNRrL = 0; gNRrS = 0; gNAtr = 0;
   gTroncato = false;
   gSommaMfeL = 0.0; gSommaMfeS = 0.0;
   gRsiDivMax = 0.0; gEmaDivMax = 0.0;
   gAutotestFalliti = -1; gAutotestBlocchi = 0;
  }

int OnInit()
  {
   AzzeraContatori();

   //--- CANCELLI DI CONFIGURAZIONE: rifiutano, non correggono in
   //    silenzio. Un default nascosto e' una misura che dice un'altra
   //    cosa da quella che c'e' scritta nel file prova.
   //    I numeri del motore NON si controllano qui perche' non sono
   //    input (V14): sono #define, e un #define sbagliato e' un
   //    errore di chi tocca il sorgente, non della riga di lancio.
   //    Si controlla pero' la COERENZA fra i due periodi di EMA, che
   //    e' l'unico modo in cui quei quattro numeri possono diventare
   //    assurdi restando compilabili.
   if(V8_EMA_VELOCE >= V8_EMA_LENTA)
     { Print("ERRORE: V8_EMA_VELOCE deve essere piu' corta di V8_EMA_LENTA (la fonte dice 5 e 20). Qualcuno ha toccato i #define del motore."); return(INIT_FAILED); }
   if(V8_RSI_PERIODO < 2 || V8_RSI_SEGNALE_PERIODO < 1)
     { Print("ERRORE: periodi RSI incoerenti nei #define del motore (la fonte dice 14 e 14)."); return(INIT_FAILED); }

   if(InpBarreOrizzonte < 1)
     { Print("ERRORE: InpBarreOrizzonte deve essere >= 1 (il criterio congelato dice 12: e' il MURO D'ATTRITO)."); return(INIT_FAILED); }
   if(InpBarreOrizzonteLungo < InpBarreOrizzonte)
     { Print("ERRORE: InpBarreOrizzonteLungo non puo' essere piu' corto di InpBarreOrizzonte: l'orizzonte lungo esiste per CONTENERE quello del cancello (vedi V7)."); return(INIT_FAILED); }
   if(InpBarreOrizzonteLungo > 2000)
     { Print("ERRORE: InpBarreOrizzonteLungo sopra 2000 barre mangerebbe la coda della finestra di corsa senza dire niente di piu' (vedi V7)."); return(INIT_FAILED); }
   if(InpModoPrezzoIngresso != 0 && InpModoPrezzoIngresso != 1)
     { Print("ERRORE: InpModoPrezzoIngresso ammette solo 1 (apertura barra successiva, RIGA DEL VERDETTO) o 0 (chiusura barra di segnale, informativa)."); return(INIT_FAILED); }
   if(InpPuntiPerIndice <= 0.0)
     { Print("ERRORE: InpPuntiPerIndice deve essere > 0 (misurato = 100 su U30USD/NASUSD/D30EUR)."); return(INIT_FAILED); }
   if(InpOraInizioServer < 0 || InpOraInizioServer > 23 || InpOraFineServer < 0 || InpOraFineServer > 23)
     { Print("ERRORE: le ore della finestra devono stare fra 0 e 23, e sono ORE SERVER (BCM = ora italiana - 1)."); return(INIT_FAILED); }

   //--- il ritardo di misura (V7)
   gOrizzonteMax = (InpBarreOrizzonteLungo > InpBarreOrizzonte) ? InpBarreOrizzonteLungo : InpBarreOrizzonte;

   //--- LA PRIMA BARRA SU CUI SI PUO' DECIDERE UN INCROCIO (V2).
   //    rsiSignal e' definita dalla barra V8_RSI_PERIODO +
   //    V8_RSI_SEGNALE_PERIODO - 1; la EMA lenta dalla barra
   //    V8_EMA_LENTA - 1; e un incrocio ha bisogno ANCHE della barra
   //    precedente, quindi si somma 1.
   int primoRsiSig = V8_RSI_PERIODO + V8_RSI_SEGNALE_PERIODO - 1;
   int primoEmaL   = V8_EMA_LENTA - 1;
   gPrimoDecidibile = ((primoRsiSig > primoEmaL) ? primoRsiSig : primoEmaL) + 1;

   //--- LA CODA deve bastare a TUTTI gli indicatori, PIU' l'orizzonte
   //    di misura, PIU' un tratto in cui la MACCHINA A STATI possa
   //    dimenticare il proprio seme (V5). Le prime due cose sono
   //    aritmetica; la terza e' il motivo per cui qui il default e'
   //    400 e non 300 come nello stampo: 100 barre di macchina a
   //    stati contengono, su un indice, decine di incroci RSI, e
   //    l'ambiguita' residua e' comunque MISURATA in colonna.
   int minimo = gPrimoDecidibile + 100 + gOrizzonteMax;
   if(V8_ATR_PERIODO + 1 + 100 + gOrizzonteMax > minimo) minimo = V8_ATR_PERIODO + 1 + 100 + gOrizzonteMax;
   if(InpWarmupBarre < minimo)
     {
      PrintFormat("ERRORE: InpWarmupBarre = %d e' troppo corto: con questi periodi e un orizzonte di %d barre ne servono almeno %d (vedi V5/V7).",
                  InpWarmupBarre, gOrizzonteMax, minimo);
      return(INIT_FAILED);
     }
   if(InpWarmupBarre > 5000)
     { Print("ERRORE: InpWarmupBarre sopra 5000 rallenta la corsa senza guadagnare precisione (le medie hanno gia' dimenticato il seme e la macchina a stati pure: vedi V5)."); return(INIT_FAILED); }

   //--- conversione in punti indice, e la si DICHIARA subito (V9).
   gPuntoIndice = InpPuntiPerIndice*_Point;
   if(gPuntoIndice <= 0.0)
     { Print("ERRORE: punto indice non calcolabile (SYMBOL_POINT nullo)."); return(INIT_FAILED); }
   if(MathAbs(gPuntoIndice - 1.0) > 0.001)
      Log(StringFormat("ATTENZIONE: il punto indice vale %.5f in prezzo, NON 1,00. Su U30USD/NASUSD/D30EUR (Point %.5f, conversione 100) deve venire 1,00. Se non viene, la TAGLIA della MFE esce sbagliata di un fattore: controllare InpPuntiPerIndice PRIMA di leggere qualunque numero.",
                       gPuntoIndice, _Point));

   //--- gli handle di MT5, e non decidono NIENTE: servono solo ai
   //    collaudi V1 e V3 (le colonne di divergenza).
   if(InpConfrontaMT5)
     {
      hRsiMt5  = iRSI(_Symbol, PERIOD_CURRENT, V8_RSI_PERIODO, PRICE_CLOSE);
      hEmaVMt5 = iMA (_Symbol, PERIOD_CURRENT, V8_EMA_VELOCE, 0, MODE_EMA, PRICE_CLOSE);
      hEmaLMt5 = iMA (_Symbol, PERIOD_CURRENT, V8_EMA_LENTA,  0, MODE_EMA, PRICE_CLOSE);
      if(hRsiMt5 == INVALID_HANDLE || hEmaVMt5 == INVALID_HANDLE || hEmaLMt5 == INVALID_HANDLE)
         Log("ATTENZIONE: handle iRSI/iMA non creati. Le colonne di divergenza resteranno a 0, cioe' I COLLAUDI V1/V3 NON SONO STATI FATTI (che non e' 'passati').");
     }

   ArrayResize(gMfeL, 0);  ArrayResize(gMfeS, 0);
   ArrayResize(gMaeL, 0);  ArrayResize(gMaeS, 0);
   ArrayResize(gMfeLL, 0); ArrayResize(gMfeLS, 0);
   ArrayResize(gMaeLL, 0); ArrayResize(gMaeLS, 0);
   ArrayResize(gRrL, 0);   ArrayResize(gRrS, 0);
   ArrayResize(gAtrPts, 0);

   if(InpAutoTest) AutoTestRsiEmaV8();

   Log(StringFormat("SONDA DI CONTEGGIO RSI+EMA V8 avviata su %s %s. Etichetta '%s'. NON APRE ORDINI: e' un contatore.",
                    _Symbol, EnumToString((ENUM_TIMEFRAMES)Period()), InpTag));
   Log(StringFormat("motore PINNATO ai default della fonte: RSI(%d) contro la sua SMA(%d) arma il pending; incrocio EMA(%d)/EMA(%d) spara. Nessun parametro del motore e' sweepabile (vedi V14).",
                    V8_RSI_PERIODO, V8_RSI_SEGNALE_PERIODO, V8_EMA_VELOCE, V8_EMA_LENTA));
   Log(StringFormat("orizzonti %d (cancello) e %d (informativo) barre | ritardo di misura %d barre | prima barra decidibile %d | coda %d barre | prezzo d'ingresso: %s",
                    InpBarreOrizzonte, InpBarreOrizzonteLungo, gOrizzonteMax, gPrimoDecidibile, InpWarmupBarre,
                    (InpModoPrezzoIngresso == 1 ? "apertura barra successiva (RIGA DEL VERDETTO)" : "chiusura barra di segnale (INFORMATIVA)")));
   Log(StringFormat("cancelli CONGELATI: F1 >= %.2f segnali/giorno TOTALI E >= %.2f per LATO | F2 MFE mediana > %.1f punti indice VIVO, < %.1f MORTO, in mezzo SOSPESO | H8 RR da mediane >= %.2f (E >= %.3fR a tick).",
                    V8_SOGLIA_SEGNALI_TOT_GIORNO, V8_SOGLIA_SEGNALI_LATO_GIORNO,
                    V8_SOGLIA_MFE_VIVO, V8_SOGLIA_MFE_SCARTO, V8_SOGLIA_RR, V8_E_TARGET_R));

   //--- il CSV riga-per-segnale esiste SOLO fuori dall'ottimizzazione:
   //    con piu' passate che condividono lo stesso file ogni passata
   //    sovrascriverebbe la precedente (trappola gia' scritta nel
   //    referto FVGRET).
   if(InpScriviCsv && !MQLInfoInteger(MQL_OPTIMIZATION))
     {
      string f = StringFormat("ABTG_SondaRsiEmaV8_%s_%s_segnali.csv", _Symbol, EnumToString((ENUM_TIMEFRAMES)Period()));
      gCsvSeg = FileOpen(f, FILE_WRITE|FILE_CSV|FILE_ANSI, ";");
      if(gCsvSeg != INVALID_HANDLE)
         FileWrite(gCsvSeg, "ora_barra_segnale", "lato", "rsi", "rsi_signal",
                   "ema_veloce", "ema_lenta", "pending_prima", "prezzo_ingresso",
                   "mfe_punti_indice", "mae_punti_indice",
                   "mfe_lungo_punti_indice", "mae_lungo_punti_indice", "rr_segnale");
      else
         Log("ATTENZIONE: CSV dei segnali non aperto: il conteggio restera' solo nelle colonne, non ricontabile a mano.");
     }
   else if(InpScriviCsv)
      Log("CSV riga-per-segnale NON scritto: siamo in OTTIMIZZAZIONE e le passate si sovrascriverebbero. I numeri escono nelle colonne di OPTFRAME.");

   return(INIT_SUCCEEDED);
  }

void OnDeinit(const int reason)
  {
   if(hRsiMt5  != INVALID_HANDLE) IndicatorRelease(hRsiMt5);
   if(hEmaVMt5 != INVALID_HANDLE) IndicatorRelease(hEmaVMt5);
   if(hEmaLMt5 != INVALID_HANDLE) IndicatorRelease(hEmaLMt5);
   if(gCsvSeg != INVALID_HANDLE){ FileClose(gCsvSeg); gCsvSeg = INVALID_HANDLE; }
  }

//+------------------------------------------------------------------+
//| Un solo gesto per tick: se e' nata una barra nuova, si valuta la  |
//| barra che sta gOrizzonteMax barre piu' indietro (V7). Non c'e'    |
//| nient'altro da fare: non ci sono posizioni da gestire (V6).       |
//+------------------------------------------------------------------+
void OnTick()
  {
   datetime t = iTime(_Symbol, PERIOD_CURRENT, 0);
   if(t == gLastBar || t == 0) return;
   gLastBar = t;
   ValutaBarraChiusa();
  }

//+------------------------------------------------------------------+
//| Chiude la contabilita' della giornata appena finita. E' l'unico   |
//| posto in cui crescono i contatori "giorni con >= N segnali" e i   |
//| massimi giornalieri: un solo punto da leggere.                    |
//+------------------------------------------------------------------+
void ChiudiGiornata()
  {
   if(gDayStamp == -1) return;
   long tot = (long)gDaySigLong + (long)gDaySigShort;
   if(gDaySigLong  >= 1) gG1Long++;
   if(gDaySigLong  >= 2) gG2Long++;
   if(gDaySigShort >= 1) gG1Short++;
   if(gDaySigShort >= 2) gG2Short++;
   if(tot >= 1) gG1Tot++;
   if(tot >= 2) gG2Tot++;
   if(tot == 0) gGiorniZero++;
   if((long)gDaySigLong  > gMaxGiornoLong)  gMaxGiornoLong  = gDaySigLong;
   if((long)gDaySigShort > gMaxGiornoShort) gMaxGiornoShort = gDaySigShort;
   if(tot > gMaxGiornoTot) gMaxGiornoTot = tot;
  }

//+------------------------------------------------------------------+
//| IL CUORE. Legge la coda di barre, ricalcola le serie con le       |
//| funzioni pure, fa girare DUE VOLTE la macchina a stati (V5) e     |
//| decide se sulla barra di segnale c'era un segnale; poi misura le  |
//| escursioni sulle barre successive, che sono gia' tutte chiuse e   |
//| stanno nello stesso array (V7).                                   |
//| Non apre niente e non chiude niente: conta e misura distanze.     |
//+------------------------------------------------------------------+
void ValutaBarraChiusa()
  {
   int n = InpWarmupBarre;
   double apertura[], high[], low[], close[];
   ArraySetAsSeries(apertura, false);
   ArraySetAsSeries(high,     false);
   ArraySetAsSeries(low,      false);
   ArraySetAsSeries(close,    false);

   //--- shift 1 = ultima barra CHIUSA. Si copiano n barre che
   //    FINISCONO li'; l'indice n-1 e' l'ultima chiusa e la barra di
   //    SEGNALE sta gOrizzonteMax indietro rispetto a quella.
   if(CopyOpen (_Symbol, PERIOD_CURRENT, 1, n, apertura) != n ||
      CopyHigh (_Symbol, PERIOD_CURRENT, 1, n, high)     != n ||
      CopyLow  (_Symbol, PERIOD_CURRENT, 1, n, low)      != n ||
      CopyClose(_Symbol, PERIOD_CURRENT, 1, n, close)    != n)
     { gBarreSaltateDati++; return; }

   double rsi[], rsiSig[], emaV[], emaL[], tr[], atr[];
   if(!RsiWilderSerie_Calc(close, n, V8_RSI_PERIODO, rsi))                        { gBarreSaltateDati++; return; }
   if(!SmaValidaSerie_Calc(rsi, n, V8_RSI_SEGNALE_PERIODO, rsiSig))               { gBarreSaltateDati++; return; }
   if(!EmaSerie_Calc(close, n, V8_EMA_VELOCE, emaV))                              { gBarreSaltateDati++; return; }
   if(!EmaSerie_Calc(close, n, V8_EMA_LENTA,  emaL))                              { gBarreSaltateDati++; return; }
   if(!TrSerie_Calc(high, low, close, n, tr))                                     { gBarreSaltateDati++; return; }
   if(!AtrWilderSerie_Calc(tr, n, V8_ATR_PERIODO, atr))                           { gBarreSaltateDati++; return; }

   int iSeg = n - 1 - gOrizzonteMax;   // la barra di SEGNALE
   int iIng = iSeg + 1;                // la barra d'INGRESSO (V8)
   if(iSeg < gPrimoDecidibile || iIng > n - 1){ gBarreSaltateDati++; return; }

   double chiusura = close[iSeg];
   double atrSeg   = atr[iSeg];
   double ingresso = (InpModoPrezzoIngresso == 1) ? apertura[iIng] : chiusura;
   if(!MathIsValidNumber(chiusura) || !MathIsValidNumber(ingresso) || ingresso <= 0.0)
     { gBarreSaltateDati++; return; }

   //--- COLLAUDI V1 e V3: si confronta con gli indicatori di serie di
   //    MQL5. Non decidono niente, ma se divergono la traduzione e'
   //    sbagliata e nessun numero di questa corsa vale.
   if(InpConfrontaMT5) AggiornaDivergenze(rsi[iSeg], emaV[iSeg], emaL[iSeg]);

   //--- LA MACCHINA A STATI, DUE VOLTE (V5): seme PESSIMISTA e seme
   //    OTTIMISTA. Se i due segnali coincidono, lo stato e'
   //    ricostruito e il seme non conta.
   bool sigLongP, sigShortP, pendLongP, pendShortP, nudoL, nudoS, armaL, armaS;
   bool sigLongO, sigShortO, pendLongO, pendShortO, nudoLo, nudoSo, armaLo, armaSo;

   if(!MotoreV8_Calc(rsi, rsiSig, emaV, emaL, n, gPrimoDecidibile, iSeg,
                     false, false,
                     sigLongP, sigShortP, pendLongP, pendShortP, nudoL, nudoS, armaL, armaS))
     { gBarreSaltateDati++; return; }
   if(!MotoreV8_Calc(rsi, rsiSig, emaV, emaL, n, gPrimoDecidibile, iSeg,
                     true, true,
                     sigLongO, sigShortO, pendLongO, pendShortO, nudoLo, nudoSo, armaLo, armaSo))
     { gBarreSaltateDati++; return; }

   //--- si tiene SEMPRE la corsa pessimista (V5): un segnale che non
   //    si sa dimostrare non e' un segnale, e l'errore va CONTRO il
   //    candidato.
   bool sigLong  = sigLongP;
   bool sigShort = sigShortP;
   bool ambiguoL = (sigLongP  != sigLongO);
   bool ambiguoS = (sigShortP != sigShortO);

   //--- l'ora della barra di SEGNALE, in ORA SERVER (V10).
   datetime tSeg = iTime(_Symbol, PERIOD_CURRENT, 1 + gOrizzonteMax);
   if(tSeg == 0){ gBarreSaltateDati++; return; }
   MqlDateTime ts; TimeToStruct(tSeg, ts);

   //--- FILTRO ORARIO. I segnali caduti fuori NON spariscono: si
   //    contano in colonna, e la barra non entra nel denominatore dei
   //    giorni (V10). Col default (filtro SPENTO) questo blocco non
   //    scatta mai e la colonna resta a 0.
   if(!FinestraOraria_Calc(ts.hour, InpOraInizioServer, InpOraFineServer, InpUsaFinestraOraria))
     {
      if(sigLong)  gScartatiOrario++;
      if(sigShort) gScartatiOrario++;
      return;
     }

   gBarreValutate++;

   //--- L'ABLAZIONE, CONTATA SEMPRE E TUTTA (V13). Si conta QUI, cioe'
   //    DOPO il filtro orario e non prima, apposta: se si contasse su
   //    tutte le 24 ore mentre i segnali si contano solo dentro la
   //    finestra, il rapporto "nudo su segnali" -- che e' l'unica cosa
   //    per cui questi numeri esistono -- direbbe una bugia. Col
   //    filtro spento i due conteggi coincidono comunque.
   if(nudoL) gNudoLong++;
   if(nudoS) gNudoShort++;
   if(armaL) gArmamentiLong++;
   if(armaS) gArmamentiShort++;
   if(pendLongP)  gPendingLong++;
   if(pendShortP) gPendingShort++;
   if(ambiguoL) gAmbiguoLong++;
   if(ambiguoS) gAmbiguoShort++;

   //--- il metro di rumore si raccoglie su OGNI barra valutata, non
   //    sui segnali (V11): cosi' descrive il mercato e resta
   //    invariante fra le due passate dell'asse.
   if(atrSeg > 0.0 && MathIsValidNumber(atrSeg))
      Aggiungi(gAtrPts, gNAtr, PuntiIndice_Calc(atrSeg, gPuntoIndice));

   //--- contabilita' della giornata (V10)
   int stamp = ts.year*1000 + ts.day_of_year;
   if(stamp != gDayStamp)
     {
      ChiudiGiornata();
      gDayStamp    = stamp;
      gDaySigLong  = 0;
      gDaySigShort = 0;
      gGiorniContati++;
     }

   if(!sigLong && !sigShort) return;

   //--- LE ESCURSIONI. La finestra PARTE dalla barra d'ingresso
   //    INCLUSA. Col modo 1 l'ingresso e' l'apertura di quella barra,
   //    quindi MFE e MAE sono >= 0 per costruzione; col modo 0
   //    l'ingresso e' la chiusura di quella PRIMA e i valori possono
   //    venire negativi (vedi V8). In nessuno dei due casi si butta
   //    via un campione: i non positivi si CONTANO e restano dentro
   //    la mediana, perche' uno zero e' un fatto e toglierlo
   //    gonfierebbe la mediana a favore del candidato.
   double maxBreve = MassimoFinestra_Calc(high, n, iIng, InpBarreOrizzonte);
   double minBreve = MinimoFinestra_Calc (low,  n, iIng, InpBarreOrizzonte);
   double maxLungo = MassimoFinestra_Calc(high, n, iIng, InpBarreOrizzonteLungo);
   double minLungo = MinimoFinestra_Calc (low,  n, iIng, InpBarreOrizzonteLungo);

   if(sigLong)
     {
      gSegnaliLong++;
      gDaySigLong++;
      double mfe  = PuntiIndice_Calc(maxBreve - ingresso, gPuntoIndice);
      double mae  = PuntiIndice_Calc(ingresso - minBreve, gPuntoIndice);
      double mfeU = PuntiIndice_Calc(maxLungo - ingresso, gPuntoIndice);
      double maeU = PuntiIndice_Calc(ingresso - minLungo, gPuntoIndice);
      if(mfe <= 0.0) gMfeNonPosLong++;
      if(mae <= 0.0) gMaeNonPosLong++;
      Aggiungi(gMfeL,  gNMfeL,  mfe);
      Aggiungi(gMaeL,  gNMaeL,  mae);
      Aggiungi(gMfeLL, gNMfeLL, mfeU);
      Aggiungi(gMaeLL, gNMaeLL, maeU);
      gSommaMfeL += mfe;
      double rr = 0.0;
      if(mae > 0.0){ rr = mfe/mae; Aggiungi(gRrL, gNRrL, rr); }
      ScriviSegnale(tSeg, "LONG", rsi[iSeg], rsiSig[iSeg], emaV[iSeg], emaL[iSeg],
                    pendLongP, ingresso, mfe, mae, mfeU, maeU, rr);
     }

   if(sigShort)
     {
      gSegnaliShort++;
      gDaySigShort++;
      double mfe  = PuntiIndice_Calc(ingresso - minBreve, gPuntoIndice);
      double mae  = PuntiIndice_Calc(maxBreve - ingresso, gPuntoIndice);
      double mfeU = PuntiIndice_Calc(ingresso - minLungo, gPuntoIndice);
      double maeU = PuntiIndice_Calc(maxLungo - ingresso, gPuntoIndice);
      if(mfe <= 0.0) gMfeNonPosShort++;
      if(mae <= 0.0) gMaeNonPosShort++;
      Aggiungi(gMfeS,  gNMfeS,  mfe);
      Aggiungi(gMaeS,  gNMaeS,  mae);
      Aggiungi(gMfeLS, gNMfeLS, mfeU);
      Aggiungi(gMaeLS, gNMaeLS, maeU);
      gSommaMfeS += mfe;
      double rr = 0.0;
      if(mae > 0.0){ rr = mfe/mae; Aggiungi(gRrS, gNRrS, rr); }
      ScriviSegnale(tSeg, "SHORT", rsi[iSeg], rsiSig[iSeg], emaV[iSeg], emaL[iSeg],
                    pendShortP, ingresso, mfe, mae, mfeU, maeU, rr);
     }
  }

//+------------------------------------------------------------------+
//| I confronti con gli indicatori di serie di MQL5 (V1 e V3).        |
//| RSI: atteso ~0 (le due formule sono la stessa).                   |
//| EMA: atteso ~0 IN PREZZO (i semi sono diversi ma decadono).       |
//| Si legge il buffer alla stessa barra di segnale, cioe' allo shift |
//| 1 + gOrizzonteMax.                                                |
//+------------------------------------------------------------------+
void AggiornaDivergenze(const double rsiMio, const double emaVMio, const double emaLMio)
  {
   int shift = 1 + gOrizzonteMax;
   double b[1];

   if(hRsiMt5 != INVALID_HANDLE && rsiMio >= 0.0)
     {
      if(CopyBuffer(hRsiMt5, 0, shift, 1, b) == 1 && MathIsValidNumber(b[0]))
        {
         double d = MathAbs(b[0] - rsiMio);
         if(d > gRsiDivMax) gRsiDivMax = d;
        }
     }
   if(hEmaVMt5 != INVALID_HANDLE && emaVMio >= 0.0)
     {
      if(CopyBuffer(hEmaVMt5, 0, shift, 1, b) == 1 && MathIsValidNumber(b[0]))
        {
         double d = MathAbs(b[0] - emaVMio);
         if(d > gEmaDivMax) gEmaDivMax = d;
        }
     }
   if(hEmaLMt5 != INVALID_HANDLE && emaLMio >= 0.0)
     {
      if(CopyBuffer(hEmaLMt5, 0, shift, 1, b) == 1 && MathIsValidNumber(b[0]))
        {
         double d = MathAbs(b[0] - emaLMio);
         if(d > gEmaDivMax) gEmaDivMax = d;
        }
     }
  }

//+------------------------------------------------------------------+
//| Una riga per segnale, cosi' i numeri si possono RICONTARE A MANO  |
//| da un foglio (e' la regola della SondaMediazione). Nessuna        |
//| colonna di ora d'apertura/chiusura: non esistono operazioni.      |
//+------------------------------------------------------------------+
void ScriviSegnale(const datetime t, const string lato,
                   const double rsiv, const double rsiSigv,
                   const double emaVv, const double emaLv,
                   const bool pendingPrima, const double ingresso,
                   const double mfe, const double mae,
                   const double mfeLungo, const double maeLungo, const double rr)
  {
   if(gCsvSeg == INVALID_HANDLE) return;
   int dgt = (int)SymbolInfoInteger(_Symbol, SYMBOL_DIGITS);
   FileWrite(gCsvSeg,
             TimeToString(t, TIME_DATE|TIME_MINUTES), lato,
             DoubleToString(rsiv, 4),
             DoubleToString(rsiSigv, 4),
             DoubleToString(emaVv, dgt),
             DoubleToString(emaLv, dgt),
             (pendingPrima ? "1" : "0"),
             DoubleToString(ingresso, dgt),
             DoubleToString(mfe, 3),
             DoubleToString(mae, 3),
             DoubleToString(mfeLungo, 3),
             DoubleToString(maeLungo, 3),
             DoubleToString(rr, 4));
  }

//==================================================================
//  AUTOTEST DEL NUCLEO PURO
//  Gira in OnInit. NON stampa un verdetto che nessuno legge: il
//  numero di blocchi falliti finisce nella colonna "Autotest
//  Falliti" del CSV di ottimizzazione (CHECKLIST punto 99), insieme
//  al numero di blocchi eseguiti.
//  REGOLA DI SCRITTURA (CHECKLIST punto 98): ogni blocco usa nomi di
//  variabile con il PROPRIO PREFISSO (c1_, c2_, ...). In MQL5 due
//  dichiarazioni dello stesso nome nello stesso scope sono un errore
//  secco di compilazione, e nessuna rilettura lo vede.
//  MIGLIORIA EREDITATA DA LondonFx: il numero di blocchi eseguiti
//  viene confrontato con V8_AUTOTEST_BLOCCHI_ATTESI. Un blocco
//  cancellato per sbaglio non deve poter passare per "tutto verde":
//  se il conto non torna, l'autotest si dichiara FALLITO.
//  SEI BLOCCHI SU SEDICI (dal 6 all'11) INTERROGANO LA MACCHINA A
//  STATI: e' li' che sta la fedelta' al Pine, ed e' li' che un
//  errore non si vedrebbe rileggendo il codice.
//==================================================================
void AutoTestRsiEmaV8()
  {
   int falliti = 0;
   int blocchi = 0;

   //--- BLOCCO 1: RSI di Wilder, due casi calcolati A MANO.
   //    periodo 2 su [10,11,12,11]: delta +1,+1,-1.
   //      seme  -> guadagni 1,0  perdite 0,0 -> perdite nulle -> 100
   //      passo -> guadagni 0,5  perdite 0,5 -> rs 1 -> 50
   //    periodo 3 su [10,11,10,11,12]: delta +1,-1,+1,+1.
   //      seme  -> 2/3 e 1/3 -> rs 2   -> 66,6667
   //      passo -> 7/9 e 2/9 -> rs 3,5 -> 77,7778
   blocchi++;
   double c1_a[]; ArrayResize(c1_a, 4);
   c1_a[0]=10.0; c1_a[1]=11.0; c1_a[2]=12.0; c1_a[3]=11.0;
   double c1_r1[];
   bool   c1_ok1 = RsiWilderSerie_Calc(c1_a, 4, 2, c1_r1);
   double c1_b[]; ArrayResize(c1_b, 5);
   c1_b[0]=10.0; c1_b[1]=11.0; c1_b[2]=10.0; c1_b[3]=11.0; c1_b[4]=12.0;
   double c1_r2[];
   bool   c1_ok2 = RsiWilderSerie_Calc(c1_b, 5, 3, c1_r2);
   double c1_r3[];
   bool   c1_ko  = RsiWilderSerie_Calc(c1_a, 2, 6, c1_r3);   // serie piu' corta del periodo -> falso
   if(!c1_ok1 || !c1_ok2 || c1_ko ||
      MathAbs(c1_r1[2] - 100.0)     > 0.0001 ||
      MathAbs(c1_r1[3] -  50.0)     > 0.0001 ||
      MathAbs(c1_r2[3] -  66.66667) > 0.001  ||
      MathAbs(c1_r2[4] -  77.77778) > 0.001  ||
      c1_r2[2] > -0.5)                                   // prima del seme deve valere il marcatore
     { falliti++; Log("[AUTOTEST] 1 RsiWilderSerie_Calc DIVERGE"); }

   //--- BLOCCO 2: il caso degenere dell'RSI, dichiarato in V1.
   blocchi++;
   double c2_su = RsiDaMedie_Calc(1.0, 0.0);    // solo guadagni -> 100
   double c2_pi = RsiDaMedie_Calc(0.0, 0.0);    // mercato piatto -> 50
   double c2_eq = RsiDaMedie_Calc(1.0, 1.0);    // rs = 1 -> 50
   double c2_gi = RsiDaMedie_Calc(0.0, 1.0);    // solo perdite -> 0
   if(MathAbs(c2_su-100.0)>0.0001 || MathAbs(c2_pi-50.0)>0.0001 ||
      MathAbs(c2_eq- 50.0)>0.0001 || MathAbs(c2_gi- 0.0)>0.0001)
     { falliti++; Log("[AUTOTEST] 2 RsiDaMedie_Calc (casi degeneri) DIVERGE"); }

   //--- BLOCCO 3: LA SMA SU UNA SERIE CON BUCHI (V2), che e' la
   //    linea di segnale dell'RSI. Sorgente [-1, 2, 4, 6, -1, 8, 10,
   //    12] con periodo 2:
   //      idx1 non valido (la finestra tocca il -1 di idx0)
   //      idx2 = (2+4)/2 = 3 ; idx3 = (4+6)/2 = 5
   //      idx4 e idx5 non validi (finestra sul -1 di idx4)
   //      idx6 = (8+10)/2 = 9 ; idx7 = (10+12)/2 = 11
   //    E' il comportamento di na in Pine: alla voce non valida il
   //    conto RIPARTE, non si "salta" il buco.
   blocchi++;
   double c3_s[]; ArrayResize(c3_s, 8);
   c3_s[0]=V8_NON_DEFINITO; c3_s[1]=2.0; c3_s[2]=4.0; c3_s[3]=6.0;
   c3_s[4]=V8_NON_DEFINITO; c3_s[5]=8.0; c3_s[6]=10.0; c3_s[7]=12.0;
   double c3_o[];
   bool   c3_ok = SmaValidaSerie_Calc(c3_s, 8, 2, c3_o);
   double c3_corta[]; ArrayResize(c3_corta, 2); c3_corta[0]=1.0; c3_corta[1]=2.0;
   double c3_oc[];
   bool   c3_okc = SmaValidaSerie_Calc(c3_corta, 2, 5, c3_oc);   // n < periodo: valido, tutto non definito
   if(!c3_ok || !c3_okc ||
      c3_o[0] > -0.5 || c3_o[1] > -0.5 ||
      MathAbs(c3_o[2]-3.0)>0.0001 || MathAbs(c3_o[3]-5.0)>0.0001 ||
      c3_o[4] > -0.5 || c3_o[5] > -0.5 ||
      MathAbs(c3_o[6]-9.0)>0.0001 || MathAbs(c3_o[7]-11.0)>0.0001 ||
      c3_oc[1] > -0.5)
     { falliti++; Log("[AUTOTEST] 3 SmaValidaSerie_Calc DIVERGE (linea di segnale dell'RSI)"); }

   //--- BLOCCO 4: EMA alla Pine. periodo 3 su [1,2,3,4,5]:
   //    seme = SMA(1,2,3) = 2, alfa 0,5 -> 3 -> 4.
   //    periodo 1: l'EMA e' la serie stessa.
   //    E LE BARRE PRIMA DEL SEME DEVONO VALERE IL MARCATORE, non 0:
   //    e' l'irrobustimento dichiarato in V3 e senza di lui
   //    Crossover_Calc inventerebbe un incrocio sulla prima barra.
   blocchi++;
   double c4_s[]; ArrayResize(c4_s, 5);
   c4_s[0]=1.0; c4_s[1]=2.0; c4_s[2]=3.0; c4_s[3]=4.0; c4_s[4]=5.0;
   double c4_e[];
   bool   c4_ok = EmaSerie_Calc(c4_s, 5, 3, c4_e);
   double c4_u[];
   bool   c4_ok1 = EmaSerie_Calc(c4_s, 5, 1, c4_u);
   double c4_ko[];
   bool   c4_kof = EmaSerie_Calc(c4_s, 3, 5, c4_ko);   // n < periodo -> falso
   if(!c4_ok || !c4_ok1 || c4_kof ||
      MathAbs(c4_e[2]-2.0)>0.0001 || MathAbs(c4_e[3]-3.0)>0.0001 || MathAbs(c4_e[4]-4.0)>0.0001 ||
      MathAbs(c4_u[4]-5.0)>0.0001 ||
      c4_e[0] > -0.5 || c4_e[1] > -0.5)
     { falliti++; Log("[AUTOTEST] 4 EmaSerie_Calc DIVERGE (valori o marcatore di non definito)"); }

   //--- BLOCCO 5: GLI INCROCI, BORDI COMPRESI E MARCATORI COMPRESI.
   //    Il bordo di uguaglianza e' quello di Pine: "prima pari, ora
   //    sopra" E' un incrocio. E una quaterna che contiene un
   //    marcatore NON e' un incrocio (V2).
   blocchi++;
   bool c5_su   = Crossover_Calc (1.0, 2.0, 3.0, 2.0);   // sotto -> sopra
   bool c5_su2  = Crossover_Calc (2.0, 2.0, 3.0, 2.0);   // pari  -> sopra: SI
   bool c5_no1  = Crossover_Calc (3.0, 2.0, 4.0, 2.0);   // era gia' sopra: NO
   bool c5_no2  = Crossover_Calc (1.0, 2.0, 2.0, 2.0);   // arriva alla pari: NO
   bool c5_giu  = Crossunder_Calc(3.0, 2.0, 1.0, 2.0);   // sopra -> sotto
   bool c5_giu2 = Crossunder_Calc(2.0, 2.0, 1.0, 2.0);   // pari  -> sotto: SI
   bool c5_no3  = Crossunder_Calc(1.0, 2.0, 0.5, 2.0);   // era gia' sotto: NO
   bool c5_nd1  = Crossover_Calc (V8_NON_DEFINITO, 2.0, 3.0, 2.0);
   bool c5_nd2  = Crossover_Calc (1.0, V8_NON_DEFINITO, 3.0, 2.0);
   bool c5_nd3  = Crossunder_Calc(3.0, 2.0, V8_NON_DEFINITO, 2.0);
   bool c5_nd4  = Crossunder_Calc(3.0, 2.0, 1.0, V8_NON_DEFINITO);
   //    e i due non possono MAI essere veri insieme sulla stessa
   //    quaterna: e' l'aritmetica su cui poggia V4(b).
   bool c5_mai  = (Crossover_Calc(1.0,2.0,3.0,2.0) && Crossunder_Calc(1.0,2.0,3.0,2.0));
   if(!(c5_su && c5_su2 && !c5_no1 && !c5_no2 && c5_giu && c5_giu2 && !c5_no3 &&
        !c5_nd1 && !c5_nd2 && !c5_nd3 && !c5_nd4 && !c5_mai))
     { falliti++; Log("[AUTOTEST] 5 Crossover_Calc/Crossunder_Calc DIVERGONO"); }

   //--- BLOCCO 6: MOTORE -- ARMA SU UNA BARRA, SPARA SU UNA BARRA
   //    DOPO. E' il caso base del Pine.
   //    rsi incrocia la sua sma verso l'alto alla barra 1 (arma);
   //    le ema incrociano verso l'alto alla barra 3 (spara).
   blocchi++;
   double c6_rsi[];  ArrayResize(c6_rsi, 5);
   c6_rsi[0]=10.0; c6_rsi[1]=30.0; c6_rsi[2]=30.0; c6_rsi[3]=30.0; c6_rsi[4]=30.0;
   double c6_sig[];  ArrayResize(c6_sig, 5);
   for(int c6_i = 0; c6_i < 5; c6_i++) c6_sig[c6_i] = 20.0;
   double c6_ev[];   ArrayResize(c6_ev, 5);
   c6_ev[0]=1.0; c6_ev[1]=1.0; c6_ev[2]=1.0; c6_ev[3]=3.0; c6_ev[4]=3.0;
   double c6_el[];   ArrayResize(c6_el, 5);
   for(int c6_j = 0; c6_j < 5; c6_j++) c6_el[c6_j] = 2.0;

   bool c6_sl1, c6_ss1, c6_pl1, c6_ps1, c6_nl1, c6_ns1, c6_al1, c6_as1;
   bool c6_o1 = MotoreV8_Calc(c6_rsi, c6_sig, c6_ev, c6_el, 5, 1, 1, false, false,
                              c6_sl1, c6_ss1, c6_pl1, c6_ps1, c6_nl1, c6_ns1, c6_al1, c6_as1);
   bool c6_sl3, c6_ss3, c6_pl3, c6_ps3, c6_nl3, c6_ns3, c6_al3, c6_as3;
   bool c6_o3 = MotoreV8_Calc(c6_rsi, c6_sig, c6_ev, c6_el, 5, 1, 3, false, false,
                              c6_sl3, c6_ss3, c6_pl3, c6_ps3, c6_nl3, c6_ns3, c6_al3, c6_as3);
   bool c6_sl4, c6_ss4, c6_pl4, c6_ps4, c6_nl4, c6_ns4, c6_al4, c6_as4;
   bool c6_o4 = MotoreV8_Calc(c6_rsi, c6_sig, c6_ev, c6_el, 5, 1, 4, false, false,
                              c6_sl4, c6_ss4, c6_pl4, c6_ps4, c6_nl4, c6_ns4, c6_al4, c6_as4);
   bool c6_ko1, c6_ko2, c6_ko3, c6_ko4, c6_ko5, c6_ko6, c6_ko7, c6_ko8;
   bool c6_bad = MotoreV8_Calc(c6_rsi, c6_sig, c6_ev, c6_el, 5, 0, 3, false, false,
                               c6_ko1, c6_ko2, c6_ko3, c6_ko4, c6_ko5, c6_ko6, c6_ko7, c6_ko8);
   if(!c6_o1 || !c6_o3 || !c6_o4 || c6_bad ||       // daIdx = 0 non e' ammesso: serve la barra prima
      c6_sl1 || !c6_al1 || c6_nl1 || !c6_pl1 ||     // barra 1: arma, non spara, pending acceso
      !c6_sl3 || c6_ss3 || !c6_nl3 || !c6_pl3 ||    // barra 3: spara, e c'era l'incrocio EMA
      c6_sl4  || c6_pl4)                            // barra 4: pending gia' consumato
     { falliti++; Log("[AUTOTEST] 6 MotoreV8_Calc DIVERGE (arma, poi spara)"); }

   //--- BLOCCO 7: MOTORE -- ARMA E SPARA SULLA STESSA BARRA.
   //    E' la conseguenza V4(a) dell'ordine dei passi del Pine: la
   //    sequenza e' un ordine di ASSEGNAZIONI dentro la barra, non un
   //    ritardo di una barra. Se questo blocco fallisse, la sonda
   //    starebbe contando MENO segnali di quelli veri.
   blocchi++;
   double c7_rsi[]; ArrayResize(c7_rsi, 3);
   c7_rsi[0]=10.0; c7_rsi[1]=30.0; c7_rsi[2]=30.0;
   double c7_sig[]; ArrayResize(c7_sig, 3);
   c7_sig[0]=20.0; c7_sig[1]=20.0; c7_sig[2]=20.0;
   double c7_ev[];  ArrayResize(c7_ev, 3);
   c7_ev[0]=1.0; c7_ev[1]=3.0; c7_ev[2]=3.0;
   double c7_el[];  ArrayResize(c7_el, 3);
   c7_el[0]=2.0; c7_el[1]=2.0; c7_el[2]=2.0;
   bool c7_sl, c7_ss, c7_pl, c7_ps, c7_nl, c7_ns, c7_al, c7_as;
   bool c7_o = MotoreV8_Calc(c7_rsi, c7_sig, c7_ev, c7_el, 3, 1, 1, false, false,
                             c7_sl, c7_ss, c7_pl, c7_ps, c7_nl, c7_ns, c7_al, c7_as);
   if(!c7_o || !c7_sl || !c7_al || !c7_nl || !c7_pl || c7_ss)
     { falliti++; Log("[AUTOTEST] 7 MotoreV8_Calc DIVERGE (armamento e segnale sulla STESSA barra)"); }

   //--- BLOCCO 8: MOTORE -- I DUE DISARMI.
   //    8a: l'RSI incrocia all'indietro e spegne il pending; il
   //        successivo incrocio EMA NON deve sparare.
   //    8b: sono le EMA a incrociare all'indietro prima; idem.
   blocchi++;
   double c8_rsiA[]; ArrayResize(c8_rsiA, 5);
   c8_rsiA[0]=10.0; c8_rsiA[1]=30.0; c8_rsiA[2]=10.0; c8_rsiA[3]=10.0; c8_rsiA[4]=10.0;
   double c8_sig[];  ArrayResize(c8_sig, 5);
   for(int c8_i = 0; c8_i < 5; c8_i++) c8_sig[c8_i] = 20.0;
   double c8_evA[];  ArrayResize(c8_evA, 5);
   c8_evA[0]=1.0; c8_evA[1]=1.0; c8_evA[2]=1.0; c8_evA[3]=3.0; c8_evA[4]=3.0;
   double c8_el[];   ArrayResize(c8_el, 5);
   for(int c8_j = 0; c8_j < 5; c8_j++) c8_el[c8_j] = 2.0;
   bool c8_slA, c8_ssA, c8_plA, c8_psA, c8_nlA, c8_nsA, c8_alA, c8_asA;
   bool c8_oA = MotoreV8_Calc(c8_rsiA, c8_sig, c8_evA, c8_el, 5, 1, 3, false, false,
                              c8_slA, c8_ssA, c8_plA, c8_psA, c8_nlA, c8_nsA, c8_alA, c8_asA);

   double c8_rsiB[]; ArrayResize(c8_rsiB, 5);
   c8_rsiB[0]=10.0; c8_rsiB[1]=30.0; c8_rsiB[2]=30.0; c8_rsiB[3]=30.0; c8_rsiB[4]=30.0;
   double c8_evB[];  ArrayResize(c8_evB, 5);
   c8_evB[0]=3.0; c8_evB[1]=3.0; c8_evB[2]=1.0; c8_evB[3]=1.0; c8_evB[4]=3.0;
   bool c8_slB, c8_ssB, c8_plB, c8_psB, c8_nlB, c8_nsB, c8_alB, c8_asB;
   bool c8_oB = MotoreV8_Calc(c8_rsiB, c8_sig, c8_evB, c8_el, 5, 1, 4, false, false,
                              c8_slB, c8_ssB, c8_plB, c8_psB, c8_nlB, c8_nsB, c8_alB, c8_asB);
   if(!c8_oA || !c8_oB ||
      c8_slA || c8_plA || !c8_nlA ||     // 8a: incrocio EMA c'e', segnale NO
      c8_slB || c8_plB || !c8_nlB)       // 8b: idem
     { falliti++; Log("[AUTOTEST] 8 MotoreV8_Calc DIVERGE (disarmo su RSI o su EMA)"); }

   //--- BLOCCO 9: MOTORE -- DOPO IL SEGNALE IL PENDING E' SPENTO.
   //    Un SECONDO incrocio EMA nello stesso verso, senza un nuovo
   //    incrocio RSI, NON produce un secondo segnale (V4c). E'
   //    esattamente cio' che distingue questo motore da un semplice
   //    incrocio di medie: se questo blocco fallisse, la sonda
   //    misurerebbe la famiglia gia' morta invece del candidato.
   blocchi++;
   double c9_rsi[]; ArrayResize(c9_rsi, 7);
   for(int c9_i = 0; c9_i < 7; c9_i++) c9_rsi[c9_i] = 30.0;
   c9_rsi[0] = 10.0;                                  // unico incrocio RSI: barra 1
   double c9_sig[]; ArrayResize(c9_sig, 7);
   for(int c9_j = 0; c9_j < 7; c9_j++) c9_sig[c9_j] = 20.0;
   double c9_ev[];  ArrayResize(c9_ev, 7);
   c9_ev[0]=1.0; c9_ev[1]=1.0; c9_ev[2]=1.0; c9_ev[3]=3.0; c9_ev[4]=1.0; c9_ev[5]=1.0; c9_ev[6]=3.0;
   double c9_el[];  ArrayResize(c9_el, 7);
   for(int c9_k = 0; c9_k < 7; c9_k++) c9_el[c9_k] = 2.0;
   bool c9_sl3, c9_ss3, c9_pl3, c9_ps3, c9_nl3, c9_ns3, c9_al3, c9_as3;
   bool c9_o3 = MotoreV8_Calc(c9_rsi, c9_sig, c9_ev, c9_el, 7, 1, 3, false, false,
                              c9_sl3, c9_ss3, c9_pl3, c9_ps3, c9_nl3, c9_ns3, c9_al3, c9_as3);
   bool c9_sl6, c9_ss6, c9_pl6, c9_ps6, c9_nl6, c9_ns6, c9_al6, c9_as6;
   bool c9_o6 = MotoreV8_Calc(c9_rsi, c9_sig, c9_ev, c9_el, 7, 1, 6, false, false,
                              c9_sl6, c9_ss6, c9_pl6, c9_ps6, c9_nl6, c9_ns6, c9_al6, c9_as6);
   if(!c9_o3 || !c9_o6 ||
      !c9_sl3 ||                       // il PRIMO incrocio spara
      c9_sl6  || !c9_nl6 || c9_pl6)    // il SECONDO no, pur essendoci l'incrocio EMA
     { falliti++; Log("[AUTOTEST] 9 MotoreV8_Calc DIVERGE (il pending non si spegne dopo il segnale)"); }

   //--- BLOCCO 10: MOTORE -- LO SPECCHIO SHORT, che nel Pine e' un
   //    blocco a se' e quindi puo' essere sbagliato da solo.
   blocchi++;
   double c10_rsi[]; ArrayResize(c10_rsi, 5);
   c10_rsi[0]=30.0; c10_rsi[1]=10.0; c10_rsi[2]=10.0; c10_rsi[3]=10.0; c10_rsi[4]=10.0;
   double c10_sig[]; ArrayResize(c10_sig, 5);
   for(int c10_i = 0; c10_i < 5; c10_i++) c10_sig[c10_i] = 20.0;
   double c10_ev[];  ArrayResize(c10_ev, 5);
   c10_ev[0]=3.0; c10_ev[1]=3.0; c10_ev[2]=3.0; c10_ev[3]=1.0; c10_ev[4]=1.0;
   double c10_el[];  ArrayResize(c10_el, 5);
   for(int c10_j = 0; c10_j < 5; c10_j++) c10_el[c10_j] = 2.0;
   bool c10_sl1, c10_ss1, c10_pl1, c10_ps1, c10_nl1, c10_ns1, c10_al1, c10_as1;
   bool c10_o1 = MotoreV8_Calc(c10_rsi, c10_sig, c10_ev, c10_el, 5, 1, 1, false, false,
                               c10_sl1, c10_ss1, c10_pl1, c10_ps1, c10_nl1, c10_ns1, c10_al1, c10_as1);
   bool c10_sl3, c10_ss3, c10_pl3, c10_ps3, c10_nl3, c10_ns3, c10_al3, c10_as3;
   bool c10_o3 = MotoreV8_Calc(c10_rsi, c10_sig, c10_ev, c10_el, 5, 1, 3, false, false,
                               c10_sl3, c10_ss3, c10_pl3, c10_ps3, c10_nl3, c10_ns3, c10_al3, c10_as3);
   if(!c10_o1 || !c10_o3 ||
      c10_ss1 || !c10_as1 || !c10_ps1 ||          // barra 1: arma lo short
      !c10_ss3 || c10_sl3 || !c10_ns3 || !c10_ps3) // barra 3: spara lo short e NON il long
     { falliti++; Log("[AUTOTEST] 10 MotoreV8_Calc DIVERGE (specchio SHORT)"); }

   //--- BLOCCO 11: L'AMBIGUITA' DEL LATCH (V5), NEI DUE VERSI.
   //    11a: se dentro la coda c'e' un evento (qui l'incrocio RSI
   //         della barra 1), i due semi DEVONO convergere: nessuna
   //         ambiguita'.
   //    11b: se dentro la coda NON c'e' nessun evento, i due semi
   //         DEVONO divergere -- e questo e' il caso che dimostra che
   //         il rilevatore rileva davvero. Un rilevatore che non
   //         accende mai non e' una buona notizia: e' un rilevatore
   //         rotto.
   blocchi++;
   bool c11_slF, c11_ssF, c11_plF, c11_psF, c11_nlF, c11_nsF, c11_alF, c11_asF;
   bool c11_slV, c11_ssV, c11_plV, c11_psV, c11_nlV, c11_nsV, c11_alV, c11_asV;
   bool c11_oF = MotoreV8_Calc(c6_rsi, c6_sig, c6_ev, c6_el, 5, 1, 3, false, false,
                               c11_slF, c11_ssF, c11_plF, c11_psF, c11_nlF, c11_nsF, c11_alF, c11_asF);
   bool c11_oV = MotoreV8_Calc(c6_rsi, c6_sig, c6_ev, c6_el, 5, 1, 3, true, true,
                               c11_slV, c11_ssV, c11_plV, c11_psV, c11_nlV, c11_nsV, c11_alV, c11_asV);

   double c11_rsi[]; ArrayResize(c11_rsi, 3);
   c11_rsi[0]=30.0; c11_rsi[1]=30.0; c11_rsi[2]=30.0;    // nessun incrocio RSI
   double c11_sig[]; ArrayResize(c11_sig, 3);
   c11_sig[0]=20.0; c11_sig[1]=20.0; c11_sig[2]=20.0;
   double c11_ev[];  ArrayResize(c11_ev, 3);
   c11_ev[0]=1.0; c11_ev[1]=1.0; c11_ev[2]=3.0;          // un solo incrocio EMA, alla fine
   double c11_el[];  ArrayResize(c11_el, 3);
   c11_el[0]=2.0; c11_el[1]=2.0; c11_el[2]=2.0;
   bool c11_slF2, c11_ssF2, c11_plF2, c11_psF2, c11_nlF2, c11_nsF2, c11_alF2, c11_asF2;
   bool c11_slV2, c11_ssV2, c11_plV2, c11_psV2, c11_nlV2, c11_nsV2, c11_alV2, c11_asV2;
   bool c11_oF2 = MotoreV8_Calc(c11_rsi, c11_sig, c11_ev, c11_el, 3, 1, 2, false, false,
                                c11_slF2, c11_ssF2, c11_plF2, c11_psF2, c11_nlF2, c11_nsF2, c11_alF2, c11_asF2);
   bool c11_oV2 = MotoreV8_Calc(c11_rsi, c11_sig, c11_ev, c11_el, 3, 1, 2, true, true,
                                c11_slV2, c11_ssV2, c11_plV2, c11_psV2, c11_nlV2, c11_nsV2, c11_alV2, c11_asV2);
   if(!c11_oF || !c11_oV || !c11_oF2 || !c11_oV2 ||
      (c11_slF != c11_slV) || (c11_ssF != c11_ssV) ||   // 11a: DEVONO coincidere
      c11_slF2 || !c11_slV2)                            // 11b: DEVONO divergere
     { falliti++; Log("[AUTOTEST] 11 L'AMBIGUITA' DEL LATCH non si comporta come dichiarato in V5"); }

   //--- BLOCCO 12: TRUE RANGE e ATR di Wilder (il metro di casa, V11).
   //    h=[10,11,12] l=[9,10,11] c=[9.5,10.5,11.5]
   //    TR = [1 ; max(1;1,5;0,5)=1,5 ; 1,5]
   //    ATR Wilder periodo 2: seme (1+1,5)/2 = 1,25 ; poi
   //    1,25 + 0,5*(1,5-1,25) = 1,375.
   blocchi++;
   double c12_h[]; ArrayResize(c12_h,3); c12_h[0]=10.0; c12_h[1]=11.0; c12_h[2]=12.0;
   double c12_l[]; ArrayResize(c12_l,3); c12_l[0]= 9.0; c12_l[1]=10.0; c12_l[2]=11.0;
   double c12_c[]; ArrayResize(c12_c,3); c12_c[0]= 9.5; c12_c[1]=10.5; c12_c[2]=11.5;
   double c12_tr[];
   bool   c12_ok = TrSerie_Calc(c12_h, c12_l, c12_c, 3, c12_tr);
   double c12_atr[];
   bool   c12_oa = AtrWilderSerie_Calc(c12_tr, 3, 2, c12_atr);
   if(!c12_ok || !c12_oa ||
      MathAbs(c12_tr[0]-1.0)>0.0001 || MathAbs(c12_tr[1]-1.5)>0.0001 || MathAbs(c12_tr[2]-1.5)>0.0001 ||
      MathAbs(c12_atr[1]-1.25)>0.0001 || MathAbs(c12_atr[2]-1.375)>0.0001)
     { falliti++; Log("[AUTOTEST] 12 TrSerie_Calc / AtrWilderSerie_Calc DIVERGONO"); }

   //--- BLOCCO 13: le finestre di escursione, IN AVANTI, con la
   //    tosatura quando sbordano oltre l'ultimo indice.
   blocchi++;
   double c13_v[]; ArrayResize(c13_v, 6);
   c13_v[0]=5.0; c13_v[1]=9.0; c13_v[2]=3.0; c13_v[3]=7.0; c13_v[4]=1.0; c13_v[5]=4.0;
   double c13_max = MassimoFinestra_Calc(c13_v, 6, 1, 3);   // {9;3;7} -> 9
   double c13_min = MinimoFinestra_Calc (c13_v, 6, 1, 3);   // {9;3;7} -> 3
   double c13_tos = MassimoFinestra_Calc(c13_v, 6, 4, 5);   // tosata: {1;4} -> 4
   double c13_tom = MinimoFinestra_Calc (c13_v, 6, 4, 5);   // tosata: {1;4} -> 1
   double c13_ko1 = MassimoFinestra_Calc(c13_v, 6, 6, 3);   // 'da' fuori range -> 0
   double c13_ko2 = MassimoFinestra_Calc(c13_v, 6, 1, 0);   // finestra vuota  -> 0
   if(MathAbs(c13_max-9.0)>0.0001 || MathAbs(c13_min-3.0)>0.0001 ||
      MathAbs(c13_tos-4.0)>0.0001 || MathAbs(c13_tom-1.0)>0.0001 ||
      MathAbs(c13_ko1)    >0.0001 || MathAbs(c13_ko2)    >0.0001)
     { falliti++; Log("[AUTOTEST] 13 MassimoFinestra_Calc/MinimoFinestra_Calc DIVERGONO"); }

   //--- BLOCCO 14: mediana, punti indice, RR da mediane.
   //    Compreso il caso del modo 0 (V8): una distanza NEGATIVA deve
   //    restare negativa, non essere tosata a zero di nascosto.
   blocchi++;
   double c14_d[]; ArrayResize(c14_d, 5);
   c14_d[0]=1.0; c14_d[1]=2.0; c14_d[2]=3.0; c14_d[3]=10.0; c14_d[4]=100.0;
   double c14_m  = MedianaOrdinata_Calc(c14_d, 5);   // 3
   double c14_p[]; ArrayResize(c14_p, 4);
   c14_p[0]=1.0; c14_p[1]=2.0; c14_p[2]=4.0; c14_p[3]=8.0;
   double c14_mp = MedianaOrdinata_Calc(c14_p, 4);   // (2+4)/2 = 3
   double c14_vu = MedianaOrdinata_Calc(c14_d, 0);   // niente dati -> 0
   double c14_pi = PuntiIndice_Calc(12.5, 1.0);      // punto indice = 1,00 -> 12,5
   double c14_p2 = PuntiIndice_Calc(12.5, 0.5);      // 25
   double c14_pn = PuntiIndice_Calc(-3.0, 1.0);      // -3, e deve restare -3
   double c14_pz = PuntiIndice_Calc(12.5, 0.0);      // non convertibile -> 0
   double c14_rr = RrDaMediane_Calc(6.0, 8.0);       // 0,75
   double c14_rz = RrDaMediane_Calc(6.0, 0.0);       // avversa nulla -> non calcolabile -> 0
   double c14_rn = RrDaMediane_Calc(6.0,-2.0);       // avversa negativa -> 0
   if(MathAbs(c14_m-3.0)>0.0001 || MathAbs(c14_mp-3.0)>0.0001 || MathAbs(c14_vu)>0.0001 ||
      MathAbs(c14_pi-12.5)>0.0001 || MathAbs(c14_p2-25.0)>0.0001 ||
      MathAbs(c14_pn+3.0)>0.0001 || MathAbs(c14_pz)>0.0001 ||
      MathAbs(c14_rr-0.75)>0.0001 || MathAbs(c14_rz)>0.0001 || MathAbs(c14_rn)>0.0001)
     { falliti++; Log("[AUTOTEST] 14 mediana / punti indice / RR DIVERGONO"); }

   //--- BLOCCO 15: L'ARITMETICA DEL CANCELLO H8 CONTRO LA TABELLA
   //    CONGELATA NEL DOSSIER (par. 5-bis). Non e' un test di
   //    comodo: se questa formula si muove, si muove il cancello.
   blocchi++;
   double c15_a = WinRateNecessario_Calc(0.36, V8_E_TARGET_R);   // 0,790
   double c15_b = WinRateNecessario_Calc(0.50, V8_E_TARGET_R);   // 0,717
   double c15_c = WinRateNecessario_Calc(0.73, V8_E_TARGET_R);   // 0,622
   double c15_d = WinRateNecessario_Calc(1.00, V8_E_TARGET_R);   // 0,538
   //    e la soglia H8 stessa: con RR 0,70 servirebbe il 63,2%.
   double c15_s = WinRateNecessario_Calc(V8_SOGLIA_RR, V8_E_TARGET_R);
   if(MathAbs(c15_a-0.790)>0.001 || MathAbs(c15_b-0.717)>0.001 ||
      MathAbs(c15_c-0.622)>0.001 || MathAbs(c15_d-0.538)>0.001 ||
      MathAbs(c15_s-0.632)>0.001)
     { falliti++; Log("[AUTOTEST] 15 WinRateNecessario_Calc NON riproduce la tabella congelata"); }

   //--- BLOCCO 16: I TRE VERDETTI SUI BORDI ESATTI, PIU' LA FINESTRA
   //    ORARIA. E' il blocco che impedisce a un cancello di essere
   //    "quasi" quello scritto nel file prova: le DISUGUAGLIANZE
   //    vengono eseguite, non rilette.
   blocchi++;
   //    F1: due condizioni in AND, bordi inclusi
   string c16_f1a = VerdettoF1_Calc(1.50, 3.00);   // PASSA
   string c16_f1b = VerdettoF1_Calc(1.00, 2.00);   // bordi esatti: PASSA
   string c16_f1c = VerdettoF1_Calc(1.50, 1.99);   // totale sotto
   string c16_f1d = VerdettoF1_Calc(0.99, 3.00);   // lato sotto
   //    F2: tre fasce, nessuna sovrapposizione, bordi esatti
   string c16_f2a = VerdettoF2_Calc(4.99);   // MORTO
   string c16_f2b = VerdettoF2_Calc(5.00);   // SOSPESO (bordo basso INCLUSO)
   string c16_f2c = VerdettoF2_Calc(6.00);   // SOSPESO
   string c16_f2d = VerdettoF2_Calc(7.00);   // SOSPESO (bordo alto INCLUSO)
   string c16_f2e = VerdettoF2_Calc(7.01);   // VIVO
   //    H8: bordo esatto
   string c16_h8a = VerdettoH8_Calc(0.69);
   string c16_h8b = VerdettoH8_Calc(0.70);
   //    finestra oraria
   bool c16_off = FinestraOraria_Calc( 3, 14, 21, false);   // spento -> sempre vero
   bool c16_in  = FinestraOraria_Calc(14, 14, 21, true);    // bordo iniziale incluso
   bool c16_fi  = FinestraOraria_Calc(21, 14, 21, true);    // bordo finale incluso
   bool c16_ou  = FinestraOraria_Calc(22, 14, 21, true);    // fuori
   bool c16_w1  = FinestraOraria_Calc(23, 22,  2, true);    // a cavallo: dentro
   bool c16_w2  = FinestraOraria_Calc( 2, 22,  2, true);    // a cavallo: bordo
   bool c16_w3  = FinestraOraria_Calc(10, 22,  2, true);    // a cavallo: fuori
   bool c16_ko  = FinestraOraria_Calc(24, 14, 21, true);    // ora impossibile
   if(c16_f1a != "PASSA F1" || c16_f1b != "PASSA F1" ||
      c16_f1c != "MORTO F1 - TOTALE SOTTO IL PAVIMENTO" ||
      c16_f1d != "MORTO F1 - LATO SOTTO IL PAVIMENTO" ||
      c16_f2a != "MORTO F2" || c16_f2e != "VIVO F2" ||
      c16_f2b == "MORTO F2" || c16_f2b == "VIVO F2" ||
      c16_f2c == "MORTO F2" || c16_f2c == "VIVO F2" ||
      c16_f2d == "MORTO F2" || c16_f2d == "VIVO F2" ||
      c16_h8a != "MORTO H8 PER ARITMETICA" || c16_h8b != "PASSA H8" ||
      !(c16_off && c16_in && c16_fi && !c16_ou && c16_w1 && c16_w2 && !c16_w3 && !c16_ko))
     { falliti++; Log("[AUTOTEST] 16 I VERDETTI o la FINESTRA ORARIA DIVERGONO dai criteri congelati"); }

   //--- IL CONTROLLO SUL CONTROLLO (miglioria LondonFx): se un blocco
   //    e' sparito, "tutto verde" non deve essere possibile.
   if(blocchi != V8_AUTOTEST_BLOCCHI_ATTESI)
     {
      falliti++;
      Log(StringFormat("[AUTOTEST] SONO STATI ESEGUITI %d BLOCCHI MA NE ERANO ATTESI %d: un blocco e' sparito. L'autotest si dichiara FALLITO.",
                       blocchi, V8_AUTOTEST_BLOCCHI_ATTESI));
     }

   gAutotestFalliti = falliti;
   gAutotestBlocchi = blocchi;
   Log(StringFormat("AUTOTEST: %d BLOCCHI SU %d PASSATI (falliti %d, attesi %d). L'esito VERO esce nelle colonne 'Autotest Falliti' e 'Autotest Blocchi': in ottimizzazione questa riga non la legge nessuno.",
                    blocchi - falliti, blocchi, falliti, V8_AUTOTEST_BLOCCHI_ATTESI));
  }

//==================================================================//
//  OPTFRAME (inlined, self-contained) - export automatico dei      //
//  risultati di OTTIMIZZAZIONE in CSV. NON richiede include.       //
//  Scrive MQL5\Files\OptResults_<EA>_<Symbol>.csv.                 //
//  In backtest singolo e' inerte (FrameAdd gira in ottimizzazione).//
//==================================================================//
#define OPTFRAME_NAME "OptFrame"
#define OPTFRAME_ID   1

string OptFrame_FileName()
  {
   return StringFormat("OptResults_%s_%s.csv", MQLInfoString(MQL_PROGRAM_NAME), _Symbol);
  }

//+------------------------------------------------------------------+
//| Il referto a schermo del BACKTEST SINGOLO, con i cancelli GIA'    |
//| applicati. Le stesse cose escono in colonna: qui si stampano      |
//| perche' nella corsa singola le Print SI LEGGONO, ed e' li' che    |
//| Claudio guarda il numero la prima volta.                          |
//+------------------------------------------------------------------+
void StampaLato(const string lato, const double sigGiorno, const double sigGiornoTot,
                const double mfeMed, const double maeMed, const double rr,
                const long segnali, const long nudo, const long pending,
                const long armamenti, const long maxGiorno,
                const long g1, const long g2,
                const double mfeLungoMed, const double maeLungoMed,
                const double mfeMedio, const long mfeNonPos, const long maeNonPos,
                const long ambiguo, const long barre)
  {
   Print("--------------------------------------------------------------");
   PrintFormat("[RSIEMAV8-SONDA] ===== LATO %s =====", lato);
   PrintFormat("   1. segnali/giorno      : %.3f   (segnali %d)   %s",
               sigGiorno, (int)segnali, VerdettoF1_Calc(sigGiorno, sigGiornoTot));
   PrintFormat("   1-bis. ABLAZIONE       : incroci EMA NUDI %d  ->  segnali VERI %d   (rapporto %.1f%%: quanto morde il pending)",
               (int)nudo, (int)segnali,
               (nudo > 0 ? 100.0*(double)segnali/(double)nudo : 0.0));
   PrintFormat("        armamenti RSI %d | barre col pending ARMATO %d su %d (%.1f%%)",
               (int)armamenti, (int)pending, (int)barre,
               (barre > 0 ? 100.0*(double)pending/(double)barre : 0.0));
   PrintFormat("        >>> se i segnali sono ~ gli incroci nudi e il pending e' armato quasi sempre, il filtro NON filtra e il motore E' un incrocio di EMA (famiglia gia' morta due volte)");
   PrintFormat("   2. MFE MEDIANA a %d barre: %.2f punti indice   %s",
               InpBarreOrizzonte, mfeMed, VerdettoF2_Calc(mfeMed));
   PrintFormat("      MFE media           : %.2f   (accanto alla mediana dice l'asimmetria)   MFE non positive: %d",
               mfeMedio, (int)mfeNonPos);
   PrintFormat("   3. MAE MEDIANA a %d barre: %.2f punti indice   (nessun cancello: e' il denominatore dell'RR)   MAE non positive: %d",
               InpBarreOrizzonte, maeMed, (int)maeNonPos);
   PrintFormat("   4. RR DA MEDIANE (2/3) : %.3f   %s",
               rr, VerdettoH8_Calc(rr));
   PrintFormat("      win rate NECESSARIO per E >= %.3fR : %.1f%%",
               V8_E_TARGET_R, 100.0*WinRateNecessario_Calc(rr, V8_E_TARGET_R));
   PrintFormat("   5. MASSIMO in un giorno: %d   (muro giornaliero: e' da qui che si taglia InpMaxTradesPerDay di un eventuale EA)",
               (int)maxGiorno);
   PrintFormat("      giorni con >= 1      : %d      giorni con >= 2 : %d",
               (int)g1, (int)g2);
   PrintFormat("   ORIZZONTE LUNGO (%d barre, INFORMATIVO, nessun cancello): MFE mediana %.2f | MAE mediana %.2f | RR %.3f",
               InpBarreOrizzonteLungo, mfeLungoMed, maeLungoMed,
               RrDaMediane_Calc(mfeLungoMed, maeLungoMed));
   if(ambiguo > 0)
      PrintFormat("   >>> ALLARME V5: %d barre con STATO DEL LATCH AMBIGUO. La coda e' troppo corta e i numeri di questo lato NON valgono: alzare InpWarmupBarre e rifare.",
                  (int)ambiguo);
  }

double OnTester()
  {
   //--- l'ultima giornata va chiusa a mano: nessuna barra nuova la
   //    chiudera' piu'.
   ChiudiGiornata();
   gDayStamp = -1;

   double mfeMedL = Mediana(gMfeL,  gNMfeL);
   double mfeMedS = Mediana(gMfeS,  gNMfeS);
   double maeMedL = Mediana(gMaeL,  gNMaeL);
   double maeMedS = Mediana(gMaeS,  gNMaeS);
   double mfeLunL = Mediana(gMfeLL, gNMfeLL);
   double mfeLunS = Mediana(gMfeLS, gNMfeLS);
   double maeLunL = Mediana(gMaeLL, gNMaeLL);
   double maeLunS = Mediana(gMaeLS, gNMaeLS);
   double rrMedL  = RrDaMediane_Calc(mfeMedL, maeMedL);
   double rrMedS  = RrDaMediane_Calc(mfeMedS, maeMedS);
   double rrSegL  = Mediana(gRrL, gNRrL);
   double rrSegS  = Mediana(gRrS, gNRrS);
   double atrMed  = Mediana(gAtrPts, gNAtr);

   double gg      = (gGiorniContati > 0) ? (double)gGiorniContati : 0.0;
   double sigGgL  = (gg > 0.0) ? (double)gSegnaliLong /gg : 0.0;
   double sigGgS  = (gg > 0.0) ? (double)gSegnaliShort/gg : 0.0;
   double sigGgT  = (gg > 0.0) ? (double)(gSegnaliLong + gSegnaliShort)/gg : 0.0;
   double mfeAvgL = (gNMfeL > 0) ? gSommaMfeL/(double)gNMfeL : 0.0;
   double mfeAvgS = (gNMfeS > 0) ? gSommaMfeS/(double)gNMfeS : 0.0;

   //--- REFERTO A SCHERMO (corsa singola). In ottimizzazione non lo
   //    legge nessuno: per quello ci sono le colonne qui sotto.
   Print("==============================================================");
   PrintFormat("[RSIEMAV8-SONDA] CONTATORE RSI+EMA V8 su %s %s - etichetta '%s'. NESSUN ORDINE APERTO.",
               _Symbol, EnumToString((ENUM_TIMEFRAMES)Period()), InpTag);
   PrintFormat("   motore PINNATO: RSI(%d) vs SMA(%d) arma | EMA(%d)/EMA(%d) spara | prezzo d'ingresso %s | orizzonti %d e %d barre | ritardo di misura %d",
               V8_RSI_PERIODO, V8_RSI_SEGNALE_PERIODO, V8_EMA_VELOCE, V8_EMA_LENTA,
               (InpModoPrezzoIngresso == 1 ? "APERTURA BARRA DOPO (verdetto)" : "chiusura barra segnale (informativa)"),
               InpBarreOrizzonte, InpBarreOrizzonteLungo, gOrizzonteMax);
   PrintFormat("   barre valutate %d | barre saltate per dati %d | giorni contati %d | segnali fuori orario %d",
               (int)gBarreValutate, (int)gBarreSaltateDati, (int)gGiorniContati, (int)gScartatiOrario);
   PrintFormat("   ATR(%d) mediano %.4f punti indice (metro di casa, NON viene dalla fonte: vedi V11) -> la MFE mediana vale quante ATR? long %.2f, short %.2f",
               V8_ATR_PERIODO, atrMed,
               (atrMed > 0.0 ? mfeMedL/atrMed : 0.0), (atrMed > 0.0 ? mfeMedS/atrMed : 0.0));
   PrintFormat("   collaudo traduzione: scarto MAX contro iRSI = %.8f (atteso ~0, V1) | scarto MAX contro iMA(EMA) = %.8f in prezzo (atteso ~0, V3) | punto indice = %.5f in prezzo (atteso 1,00, V9)",
               gRsiDivMax, gEmaDivMax, gPuntoIndice);
   if(gAmbiguoLong > 0 || gAmbiguoShort > 0)
      PrintFormat("   >>> ALLARME V5: STATO DEL LATCH AMBIGUO su %d barre long e %d short. InpWarmupBarre e' troppo corto: NESSUN numero di questa corsa vale.",
                  (int)gAmbiguoLong, (int)gAmbiguoShort);
   if(gTroncato)
      Print("   >>> ATTENZIONE: uno dei vettori di campioni ha toccato il tetto di 100.000: LE MEDIANE POSSONO ESSERE TRONCATE e vanno considerate NON VALIDE finche' non si e' guardato quale vettore. Rifare con una finestra piu' corta.");

   StampaLato("LONG",  sigGgL, sigGgT, mfeMedL, maeMedL, rrMedL, gSegnaliLong,
              gNudoLong, gPendingLong, gArmamentiLong, gMaxGiornoLong, gG1Long, gG2Long,
              mfeLunL, maeLunL, mfeAvgL, gMfeNonPosLong, gMaeNonPosLong, gAmbiguoLong, gBarreValutate);
   StampaLato("SHORT", sigGgS, sigGgT, mfeMedS, maeMedS, rrMedS, gSegnaliShort,
              gNudoShort, gPendingShort, gArmamentiShort, gMaxGiornoShort, gG1Short, gG2Short,
              mfeLunS, maeLunS, mfeAvgS, gMfeNonPosShort, gMaeNonPosShort, gAmbiguoShort, gBarreValutate);

   Print("--------------------------------------------------------------");
   PrintFormat("[RSIEMAV8-SONDA] IL PAVIMENTO F1 IN UN NUMERO SOLO: %.3f segnali/giorno TOTALI (soglia %.2f) -- e i due lati devono ANCHE fare %.2f ciascuno.",
               sigGgT, V8_SOGLIA_SEGNALI_TOT_GIORNO, V8_SOGLIA_SEGNALI_LATO_GIORNO);
   PrintFormat("[RSIEMAV8-SONDA] muro giornaliero: massimo %d segnali in un giorno, giorni con >=1 %d, con >=2 %d, giorni a ZERO segnali %d su %d",
               (int)gMaxGiornoTot, (int)gG1Tot, (int)gG2Tot, (int)gGiorniZero, (int)gGiorniContati);
   PrintFormat("[RSIEMAV8-SONDA] promemoria prop: %d segnali x 0,65%% = %.2f%% di rischio aperto contro il cap C1 di 3,25%% firmato il 18/08.",
               (int)gMaxGiornoTot, 0.65*(double)gMaxGiornoTot);
   Print("[RSIEMAV8-SONDA] questa corsa NON promuove niente e NON dice se il motore guadagna: e' un conteggio. Il merito si misura a tick, dopo, e solo se questi numeri reggono.");
   Print("==============================================================");

   //--- ATTENZIONE: 'stats', l'header di OnTesterDeinit e il suo
   //    StringFormat SI TOCCANO SEMPRE INSIEME. Una colonna aggiunta a
   //    uno solo dei tre sfasa tutto il CSV e chi legge trova il numero
   //    sbagliato sotto il nome giusto.
   //    CONTEGGIO CONGELATO: 56 valori -> 59 nomi (Pass, Simbolo,
   //    Periodo + 56) -> 59 specificatori -> 59 argomenti.
   //    E il margine e' dichiarato: StringFormat riceve 1 formato + 59
   //    argomenti = 60 parametri, contro il tetto di 64 di MQL5.
   //    RESTANO QUATTRO COLONNE DI MARGINE: la quinta obbliga a
   //    spezzare la riga in due StringFormat. Sta scritto perche' e'
   //    il genere di muro che si scopre a compilazione fallita.
   double stats[56];
   stats[0]  = (double)gSegnaliLong;      // il motore COMPLETO: porta i cancelli
   stats[1]  = (double)gSegnaliShort;
   stats[2]  = (double)gNudoLong;         // ablazione: soli incroci EMA (INVARIANTE sull'asse)
   stats[3]  = (double)gNudoShort;
   stats[4]  = (double)gPendingLong;      // ablazione: barre col latch ARMATO
   stats[5]  = (double)gPendingShort;
   stats[6]  = (double)gArmamentiLong;    // ablazione: soli incroci RSI
   stats[7]  = (double)gArmamentiShort;
   stats[8]  = (double)gGiorniContati;
   stats[9]  = sigGgL;                    // CANCELLO F1, LONG
   stats[10] = sigGgS;                    // CANCELLO F1, SHORT
   stats[11] = sigGgT;                    // CANCELLO F1, TOTALE (pavimento 01/09)
   stats[12] = mfeMedL;                   // CANCELLO F2, LONG
   stats[13] = mfeMedS;                   // CANCELLO F2, SHORT
   stats[14] = maeMedL;                   // denominatore dell'RR, LONG
   stats[15] = maeMedS;
   stats[16] = rrMedL;                    // CANCELLO H8, LONG = F2/MAE
   stats[17] = rrMedS;                    // CANCELLO H8, SHORT
   stats[18] = rrSegL;                    // mediana dei rapporti: NON e' il cancello
   stats[19] = rrSegS;
   stats[20] = 100.0*WinRateNecessario_Calc(rrMedL, V8_E_TARGET_R);
   stats[21] = 100.0*WinRateNecessario_Calc(rrMedS, V8_E_TARGET_R);
   stats[22] = (double)gMaxGiornoLong;    // muro giornaliero
   stats[23] = (double)gMaxGiornoShort;
   stats[24] = (double)gMaxGiornoTot;
   stats[25] = (double)gG1Long;
   stats[26] = (double)gG2Long;
   stats[27] = (double)gG1Short;
   stats[28] = (double)gG2Short;
   stats[29] = (double)gG1Tot;
   stats[30] = (double)gG2Tot;
   stats[31] = (double)gGiorniZero;
   stats[32] = mfeAvgL;
   stats[33] = mfeAvgS;
   stats[34] = mfeLunL;                   // orizzonte lungo: informativo (V7)
   stats[35] = mfeLunS;
   stats[36] = maeLunL;
   stats[37] = maeLunS;
   stats[38] = (double)gMfeNonPosLong;    // possibili SOLO col modo 0 (V8)
   stats[39] = (double)gMfeNonPosShort;
   stats[40] = (double)gMaeNonPosLong;
   stats[41] = (double)gMaeNonPosShort;
   stats[42] = atrMed;                    // metro di rumore (V11)
   stats[43] = (double)gBarreValutate;
   stats[44] = (double)gBarreSaltateDati;
   stats[45] = (double)gScartatiOrario;
   stats[46] = gRsiDivMax;                // collaudo V1: atteso ~0
   stats[47] = gEmaDivMax;                // collaudo V3: atteso ~0 in prezzo
   stats[48] = (double)gAmbiguoLong;      // INVARIANTE V5: atteso 0
   stats[49] = (double)gAmbiguoShort;     // INVARIANTE V5: atteso 0
   stats[50] = gPuntoIndice;              // eco V9: deve valere 1,00 sui tre indici
   stats[51] = (double)InpModoPrezzoIngresso; // eco dell'UNICO asse
   stats[52] = (double)InpBarreOrizzonte;
   stats[53] = (double)InpBarreOrizzonteLungo;
   stats[54] = (double)gAutotestFalliti;  // 0 = tutti passati; >0 DIVERGE; -1 non eseguito
   stats[55] = (double)gAutotestBlocchi;

   if(InpScriviCsv && !MQLInfoInteger(MQL_OPTIMIZATION)) ScriviCsvTotali(stats);

   //--- MT5 vuole un criterio di ottimizzazione. Qui NON si sceglie
   //    niente e NESSUNA CELLA VIENE PROMOSSA: si dichiara il numero
   //    di segnali totali, che e' cio' che la sonda conta. Leggerlo
   //    per sbaglio come "il migliore" vorrebbe dire "quello che ha
   //    contato di piu'", che non e' un merito -- e qui non vorrebbe
   //    dire nemmeno quello, perche' il numero di segnali NON dipende
   //    dall'unico asse sweepato (il prezzo d'ingresso): le due
   //    passate devono restituire lo STESSO criterio, ed e' proprio
   //    questo il gate di determinismo di V13.
   double criterion = (double)(gSegnaliLong + gSegnaliShort);
   FrameAdd(OPTFRAME_NAME, OPTFRAME_ID, criterion, stats);
   return(criterion);
  }

//+------------------------------------------------------------------+
//| CSV dei totali della corsa singola: gli stessi numeri delle       |
//| colonne, in un file, cosi' il referto non dipende dal log.        |
//+------------------------------------------------------------------+
void ScriviCsvTotali(const double &s[])
  {
   string f = StringFormat("ABTG_SondaRsiEmaV8_%s_%s_totali.csv", _Symbol, EnumToString((ENUM_TIMEFRAMES)Period()));
   int h = FileOpen(f, FILE_WRITE|FILE_CSV|FILE_ANSI, ";");
   if(h == INVALID_HANDLE)
     { Log(StringFormat("CSV totali non scritto (err %d).", GetLastError())); return; }

   FileWrite(h, "criterio", "grandezza", "LONG", "SHORT", "cancello");
   FileWrite(h, "F1", "segnali al giorno per lato", DoubleToString(s[9], 3), DoubleToString(s[10], 3),
             StringFormat(">= %.2f per lato, altrimenti MORTO", V8_SOGLIA_SEGNALI_LATO_GIORNO));
   FileWrite(h, "F1", "segnali al giorno TOTALI", DoubleToString(s[11], 3), "",
             StringFormat(">= %.2f totali, altrimenti MORTO (pavimento 01/09)", V8_SOGLIA_SEGNALI_TOT_GIORNO));
   FileWrite(h, "F1", "verdetto calcolato", VerdettoF1_Calc(s[9], s[11]), VerdettoF1_Calc(s[10], s[11]),
             "le DUE condizioni in AND, eseguite e non rilette");
   FileWrite(h, "ABL", "incroci EMA NUDI", DoubleToString(s[2], 0), DoubleToString(s[3], 0),
             "nessun cancello: e' il confronto");
   FileWrite(h, "ABL", "barre col pending ARMATO", DoubleToString(s[4], 0), DoubleToString(s[5], 0),
             "se e' quasi sempre armato, il filtro non filtra");
   FileWrite(h, "ABL", "armamenti RSI", DoubleToString(s[6], 0), DoubleToString(s[7], 0),
             "incroci RSI/SMA(RSI): quante volte il pending si accende");
   FileWrite(h, "F2", "MFE mediana punti indice (muro 12 barre)", DoubleToString(s[12], 3), DoubleToString(s[13], 3),
             StringFormat("< %.1f MORTO | %.1f-%.1f SOSPESO | > %.1f VIVO",
                          V8_SOGLIA_MFE_SCARTO, V8_SOGLIA_MFE_SCARTO,
                          V8_SOGLIA_MFE_VIVO, V8_SOGLIA_MFE_VIVO));
   FileWrite(h, "F2", "verdetto calcolato", VerdettoF2_Calc(s[12]), VerdettoF2_Calc(s[13]),
             "tre fasce senza sovrapposizioni, clausola severa");
   FileWrite(h, "F3", "MAE mediana punti indice", DoubleToString(s[14], 3), DoubleToString(s[15], 3),
             "nessun cancello: e' il denominatore dell'RR");
   FileWrite(h, "H8", "RR da mediane = F2/F3", DoubleToString(s[16], 4), DoubleToString(s[17], 4),
             StringFormat(">= %.2f, altrimenti MORTO PER ARITMETICA", V8_SOGLIA_RR));
   FileWrite(h, "H8", "verdetto calcolato", VerdettoH8_Calc(s[16]), VerdettoH8_Calc(s[17]), "FIRMA 2 del 31/08");
   FileWrite(h, "H8", "win rate necessario % per E >= 0,075R", DoubleToString(s[20], 2), DoubleToString(s[21], 2),
             "tabella congelata nel dossier, par. 5-bis");
   FileWrite(h, "F4", "massimo segnali in un giorno", DoubleToString(s[22], 0), DoubleToString(s[23], 0),
             "muro giornaliero prop: si taglia sui dati, non a occhio");
   FileWrite(h, "F4", "massimo segnali in un giorno, DUE LATI", DoubleToString(s[24], 0), "",
             StringFormat("promemoria prop: x 0,65%% = %.2f%% contro il cap C1 di 3,25%%", 0.65*s[24]));
   FileWrite(h, "-", "segnali totali", DoubleToString(s[0], 0), DoubleToString(s[1], 0), "");
   FileWrite(h, "-", "giorni con almeno 1 segnale", DoubleToString(s[25], 0), DoubleToString(s[27], 0), "");
   FileWrite(h, "-", "giorni con almeno 2 segnali", DoubleToString(s[26], 0), DoubleToString(s[28], 0), "");
   FileWrite(h, "-", "MFE media punti indice", DoubleToString(s[32], 3), DoubleToString(s[33], 3),
             "accanto alla mediana dice l'asimmetria");
   FileWrite(h, "V7", "MFE mediana punti indice (orizzonte LUNGO)", DoubleToString(s[34], 3), DoubleToString(s[35], 3),
             "informativo, nessun cancello");
   FileWrite(h, "V7", "MAE mediana punti indice (orizzonte LUNGO)", DoubleToString(s[36], 3), DoubleToString(s[37], 3),
             "informativo, nessun cancello");
   FileWrite(h, "-", "MFE non positive / MAE non positive",
             DoubleToString(s[38], 0) + " / " + DoubleToString(s[40], 0),
             DoubleToString(s[39], 0) + " / " + DoubleToString(s[41], 0),
             "contate e TENUTE dentro la mediana. Attese 0 col modo 1 (V8)");
   FileWrite(h, "-", "RR mediano per segnale", DoubleToString(s[18], 4), DoubleToString(s[19], 4),
             "NON e' il cancello: il cancello e' F2/F3");
   FileWrite(h, "-", "giorni contati", DoubleToString(s[8], 0), "", "V10");
   FileWrite(h, "-", "giorni a zero segnali (due lati)", DoubleToString(s[31], 0), "", "");
   FileWrite(h, "-", "ATR mediano punti indice", DoubleToString(s[42], 4), "",
             "metro di rumore di casa, NON viene dalla fonte (V11)");
   FileWrite(h, "-", "barre valutate", DoubleToString(s[43], 0), "", "");
   FileWrite(h, "-", "barre saltate per dati", DoubleToString(s[44], 0), "", "deve essere ~0");
   FileWrite(h, "-", "segnali scartati orario", DoubleToString(s[45], 0), "",
             "0 se InpUsaFinestraOraria = false");
   FileWrite(h, "-", "scarto max contro iRSI", DoubleToString(s[46], 8), "", "collaudo V1: atteso ~0");
   FileWrite(h, "-", "scarto max contro iMA(EMA) in prezzo", DoubleToString(s[47], 8), "", "collaudo V3: atteso ~0");
   FileWrite(h, "-", "stato latch AMBIGUO", DoubleToString(s[48], 0), DoubleToString(s[49], 0),
             "INVARIANTE V5: deve essere 0, altrimenti niente vale");
   FileWrite(h, "-", "punto indice in prezzo", DoubleToString(s[50], 5), "", "V9: deve valere 1,00");
   FileWrite(h, "-", "modo prezzo ingresso / orizzonti (corto, lungo)", DoubleToString(s[51], 0),
             DoubleToString(s[52], 0) + " / " + DoubleToString(s[53], 0),
             "1 = RIGA DEL VERDETTO (apertura barra dopo); 0 = informativa");
   FileWrite(h, "-", "autotest falliti su blocchi", DoubleToString(s[54], 0), DoubleToString(s[55], 0),
             StringFormat("0 falliti su %d = passato; -1 = NON eseguito", V8_AUTOTEST_BLOCCHI_ATTESI));
   FileClose(h);
   Log(StringFormat("scritto MQL5\\Files\\%s", f));
  }

int OnTesterInit() { return(INIT_SUCCEEDED); }

void OnTesterDeinit()
  {
   string fname = OptFrame_FileName();
   int h = FileOpen(fname, FILE_WRITE|FILE_CSV|FILE_ANSI, ",");
   if(h == INVALID_HANDLE)
     { PrintFormat("OptFrame: impossibile creare %s (err %d)", fname, GetLastError()); return; }
   FrameFilter(OPTFRAME_NAME, OPTFRAME_ID);
   ulong pass; string name; long id; double value; double data[];
   bool header_scritto = false; int righe = 0;
   string periodo = EnumToString((ENUM_TIMEFRAMES)Period());
   while(FrameNext(pass, name, id, value, data))
     {
      string params[]; uint pcount = 0;
      FrameInputs(pass, params, pcount);
      if(!header_scritto)
        {
         //--- 59 nomi = Pass + Simbolo + Periodo + 56 valori di stats[].
         string head = "Pass,Simbolo,Periodo,Segnali Long,Segnali Short,Segnali Nudo Long,Segnali Nudo Short,Pending Attivo Long,Pending Attivo Short,Armamenti Rsi Long,Armamenti Rsi Short,Giorni Contati,Segnali Long Al Giorno,Segnali Short Al Giorno,Segnali Totali Al Giorno,Mfe Mediano Long Punti Indice,Mfe Mediano Short Punti Indice,Mae Mediano Long Punti Indice,Mae Mediano Short Punti Indice,RR Da Mediane Long,RR Da Mediane Short,RR Mediano Per Segnale Long,RR Mediano Per Segnale Short,Win Rate Necessario Long Pct,Win Rate Necessario Short Pct,Max Segnali Giorno Long,Max Segnali Giorno Short,Max Segnali Giorno Totale,Giorni Almeno 1 Long,Giorni Almeno 2 Long,Giorni Almeno 1 Short,Giorni Almeno 2 Short,Giorni Almeno 1 Totale,Giorni Almeno 2 Totale,Giorni Zero Segnali,Mfe Medio Long Punti Indice,Mfe Medio Short Punti Indice,Mfe Lungo Mediano Long Punti Indice,Mfe Lungo Mediano Short Punti Indice,Mae Lungo Mediano Long Punti Indice,Mae Lungo Mediano Short Punti Indice,Mfe Non Positive Long,Mfe Non Positive Short,Mae Non Positive Long,Mae Non Positive Short,Atr Mediano Punti Indice,Barre Valutate,Barre Saltate Dati,Segnali Scartati Orario,Rsi Divergenza Max,Ema Divergenza Max,Stato Ambiguo Long,Stato Ambiguo Short,Punto Indice Prezzo,Modo Prezzo Ingresso,Barre Orizzonte,Barre Orizzonte Lungo,Autotest Falliti,Autotest Blocchi";
         for(uint i = 0; i < pcount; i++)
           { string kv[]; if(StringSplit(params[i], '=', kv) == 2) head += "," + kv[0]; }
         FileWrite(h, head); header_scritto = true;
        }
      //--- 59 specificatori = 59 argomenti (pass, simbolo, periodo, data[0..55]).
      string row = StringFormat("%d,%s,%s,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.3f,%.3f,%.3f,%.3f,%.3f,%.3f,%.3f,%.4f,%.4f,%.4f,%.4f,%.2f,%.2f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.3f,%.3f,%.3f,%.3f,%.3f,%.3f,%.0f,%.0f,%.0f,%.0f,%.4f,%.0f,%.0f,%.0f,%.8f,%.8f,%.0f,%.0f,%.5f,%.0f,%.0f,%.0f,%.0f,%.0f",
                                (int)pass, _Symbol, periodo,
                                data[0],  data[1],  data[2],  data[3],  data[4],  data[5],
                                data[6],  data[7],  data[8],  data[9],  data[10], data[11],
                                data[12], data[13], data[14], data[15], data[16], data[17],
                                data[18], data[19], data[20], data[21], data[22], data[23],
                                data[24], data[25], data[26], data[27], data[28], data[29],
                                data[30], data[31], data[32], data[33], data[34], data[35],
                                data[36], data[37], data[38], data[39], data[40], data[41],
                                data[42], data[43], data[44], data[45], data[46], data[47],
                                data[48], data[49], data[50], data[51], data[52], data[53],
                                data[54], data[55]);
      for(uint i = 0; i < pcount; i++)
        { string kv[]; if(StringSplit(params[i], '=', kv) == 2) row += "," + kv[1]; }
      FileWrite(h, row); righe++;
     }
   FileClose(h);
   PrintFormat("OptFrame: scritte %d passate in MQL5\\Files\\%s", righe, fname);
  }
//================== fine OPTFRAME inlined ==========================//
