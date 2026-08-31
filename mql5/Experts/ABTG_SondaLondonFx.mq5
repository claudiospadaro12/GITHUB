//+------------------------------------------------------------------+
//|                                         ABTG_SondaLondonFx.mq5    |
//|                                                                  |
//|  LA SONDA DI FREQUENZA DI LONDONFX -- E' UN CONTATORE, NON UN EA. |
//|  PASSO 0 del promosso P1 della CACCIA FREQUENZA -- SECONDA        |
//|  BATTUTA del 31/08/2026.                                          |
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
//|  STAMPO OBBLIGATORIO, seguito riga per riga come architettura:    |
//|    mql5\Experts\ABTG_SondaM0PB.mq5                                |
//|  collaudata SUL CAMPO la sera del 31/08 (corsa 19:35: compilata   |
//|  al primo colpo, autotest 0/12 falliti, determinismo perfetto     |
//|  sui conteggi condivisi delle due passate). Da quella sonda       |
//|  arrivano: il nucleo puro interrogabile a tavolino, l'OPTFRAME a  |
//|  colonne CONTATE, il CSV riga-per-segnale spento in              |
//|  ottimizzazione, le soglie dei cancelli come #define e non come   |
//|  input, le colonne SEMPRE per LATO e mai aggregate.               |
//|  Precedente piu' vecchio: mql5\Scripts\ABTG_SondaMediazione.mq5   |
//|  (firma di Claudio del 21/08, "metro, frequenza").                |
//|                                                                  |
//|  >>> PERCHE' STA IN Experts\ E NON IN Scripts\: un .mq5 in        |
//|      Scripts\ NON HA OnTester. Qui i numeri devono uscire in      |
//|      COLONNE di OPTFRAME, perche' la corsa e' in OTTIMIZZAZIONE   |
//|      (due assi: InpUsaRsi e InpOraInizioServer) e in              |
//|      ottimizzazione le Print girano sugli agent e non le legge    |
//|      nessuno (CHECKLIST punto 34, ribadito al 99).                |
//|      Quindi: Expert Advisor che non fa l'expert.                  |
//|                                                                  |
//|  ------------------------------------------------------------    |
//|  ORIGINE E ATTRIBUZIONE (obbligatoria, licenza MPL 2.0)           |
//|  ------------------------------------------------------------    |
//|  Meccanica di SEGNALE derivata da                                 |
//|    "EURUSD 5min london session strategy"                          |
//|  di (c) SoftKill21, TradingView, created 2020-08-30, Pine v4,     |
//|  scriptAccess "open_no_auth", licenza MOZILLA PUBLIC LICENSE 2.0  |
//|  dichiarata alla riga 1 del sorgente:                             |
//|    // This source code is subject to the terms of the Mozilla     |
//|    // Public License 2.0 at https://mozilla.org/MPL/2.0/          |
//|    // (c) SoftKill21                                              |
//|  Pagina:                                                          |
//|    https://www.tradingview.com/script/E6yr9CoN-EURUSD-5min-london-session-strategy/
//|  Copia integrale archiviata in casa e letta riga per riga (52     |
//|  righe, tutte):                                                   |
//|    caccia_strategie\biblioteca\sorgenti\                          |
//|    EurUsd5minLondonSession_SoftKill21-MPL2_tvE6yr9CoN_2026-08-31.pine
//|                                                                  |
//|  DETTAGLIO ONESTO letto nel sorgente e che vale la pena dire: il  |
//|  titolo INTERNO dello script (riga 4) e' rimasto                  |
//|  strategy(title="Moving Average", shorttitle="MA") -- e' il       |
//|  titolo della PUBBLICAZIONE a chiamarla "EURUSD 5min london       |
//|  session strategy". Non cambia niente nella logica, ma dice che   |
//|  il sorgente e' stato letto e non solo scaricato.                 |
//|                                                                  |
//|  Da quel sorgente questa sonda riproduce SOLO LA LOGICA DI        |
//|  SEGNALE (canale di medie + sessione + conferma RSI). NON         |
//|  riproduce gli ordini, il tp/sl in tick, il cap giornaliero di 6  |
//|  ordini, il cap di perdita intraday al 2%, la chiusura di tutto   |
//|  a fine sessione: quelle parti non servono a CONTARE, e alcune    |
//|  (i cap) sono decisioni di gestione che nel PASSO 0 si TAGLIANO   |
//|  SUI DATI, non si ereditano dall'autore.                          |
//|                                                                  |
//|  ------------------------------------------------------------    |
//|  LE DOMANDE, E SONO LE UNICHE                                     |
//|  ------------------------------------------------------------    |
//|  dossier: caccia_strategie\CACCIA_FREQUENZA2_2026-08-31.md (P1)   |
//|  criteri: prove\LONDONFX_FREQUENZA_M5.txt (ex _BOZZA, promossa    |
//|           il 31/08: i cancelli sono quelli congelati nella        |
//|           bozza PRIMA di vedere qualunque numero, INTATTI)        |
//|  firma  : report\FIRME_2026-08-31.md (FIRMA 2, cancello H8)       |
//|                                                                  |
//|   1. Quante volte al giorno, PER LATO, la sessione di Londra      |
//|      offre una chiusura fuori dal canale stretto?                 |
//|          CANCELLO F1: < 1,00 segnali/giorno -> MORTO.             |
//|   1-bis. E l'RSI dell'autore -- che l'autore stesso dichiara      |
//|      OPZIONALE sulla pagina ("Then we can OPTIONALLY verify with  |
//|      the RSI") -- quel pavimento lo REGGE o lo UCCIDE?            |
//|          ABLAZIONE F1-bis: canale NUDO contro canale + RSI.       |
//|   2. Quanto spazio favorevole c'e' davanti al segnale, in PIP?    |
//|          CANCELLO F2: MFE mediana < 3,0 pip -> MORTO.             |
//|   3. Quel premio quanto vale contro l'escursione avversa?         |
//|          CANCELLO H8: RR mediano < 0,70 -> MORTO PER ARITMETICA,  |
//|          senza spendere una corsa a tick.                         |
//|                                                                  |
//|  I cancelli sono CONGELATI PRIMA di vedere qualunque numero e     |
//|  stanno qui sotto come #define, NON come input: un cancello che   |
//|  si puo' spostare dalla riga di lancio non e' un cancello.        |
//|  Questa sonda li stampa GIA' APPLICATI, cosi' nessuno li puo'     |
//|  ammorbidire dopo averli letti.                                   |
//|                                                                  |
//|  E I NUMERI SONO SEMPRE DUE, MAI UNO: LONG e SHORT SEPARATI       |
//|  (regola dei due lati, Claudio 25/08). Qui i due lati stanno      |
//|  nella STESSA corsa -- si puo' fare perche' non si apre niente e  |
//|  quindi non esiste nessuna posizione che i due lati si            |
//|  contendono -- ma NON esiste una sola colonna aggregata dei due:  |
//|  ogni numero di MERITO ha la sua colonna Long e la sua Short. Le  |
//|  uniche colonne "Totale" che esistono servono al MURO             |
//|  GIORNALIERO (F4), che e' un vincolo di conto, non un merito.     |
//|                                                                  |
//|  ------------------------------------------------------------    |
//|  COSA QUESTA SONDA NON DICE, e non e' una dimenticanza            |
//|  ------------------------------------------------------------    |
//|   - NON dice se LondonFx guadagna. Un conteggio dice se un        |
//|     motore e' MISURABILE e se ha SPAZIO, non se ha EDGE. L'edge   |
//|     si misura a tick, dopo, e solo se questi numeri reggono       |
//|     (R57).                                                        |
//|   - NON esce nessuna colonna di P/L, Profit Factor, drawdown:     |
//|     senza operazioni sarebbero tutti ZERO, e uno zero in colonna  |
//|     verrebbe letto prima o poi come un risultato. L'unica cosa    |
//|     che questa corsa produce sono CONTEGGI e DISTANZE.            |
//|   - NON promuove niente e non tocca nessuna sedia viva.           |
//|   - NON simula esiti: non sa quante volte il take dell'autore     |
//|     sarebbe stato preso PRIMA dello stop. Quello e' l'ordine      |
//|     degli eventi dentro la barra, e lo vede solo il tick.         |
//|                                                                  |
//|  DEMO. ASCII puro: niente accenti dentro le stringhe, niente      |
//|  emoji (regola di casa dei .ps1, estesa qui perche' i log e i     |
//|  CSV finiscono negli stessi strumenti).                           |
//|  NON compilato ne' eseguito da chi ha scritto il file: in quel    |
//|  ambiente non esistono MetaEditor ne' Strategy Tester. Si         |
//|  compila in MetaEditor PRIMA di qualunque corsa.                  |
//+------------------------------------------------------------------+
//
//  MAPPA PINE <-> CODICE (verificabile riga per riga sul sorgente)
//  ------------------------------------------------------------------
//  riga .pine | Pine                             | qui
//  -----------|----------------------------------|--------------------
//  5          | timeinrange(res,sess)=time(..)!=0| SessioneAttiva_Calc
//  6-9        | len=5 ; src=high ; out=sma(src,5)| SmaSerie_Calc su HIGH
//  12-15      | len2=5; src2=low; out2=sma(..,5) | SmaSerie_Calc su LOW
//  18         | length = 5                       | InpRsiPeriodo
//  19         | overSold  = 10                   | 100 - InpRsiSoglia  [L2]
//  20         | overBought= 80                   | InpRsiSoglia        [L2]
//  23         | vrsi = rsi(close,5)              | RsiWilderSerie_Calc [L1]
//  25         | close>out and close>out2 and     | CanaleLong_Calc +
//             |   vrsi>80 and timeinrange(..)    |   FiltroRsi_Calc +
//             |                                  |   SessioneAttiva_Calc
//  26         | close<out and close<out2 and     | CanaleShort_Calc +
//             |   vrsi<10 and timeinrange(..)    |   (specchio)
//  25/26      | "0300-1100"                      | InpOraInizioServer +
//             |                                  |   InpOreSessione    [L3]
//  28-29      | tp=150 / sl=80  (tick)           | NON e' un cancello: e'
//             |                                  |   la GEOMETRIA DELLA
//             |                                  |   FONTE, dichiarata [L5]
//  32/36      | strategy.entry("long"/"short")   | NON RIPRODOTTO: non si
//                                                |   apre niente
//  34/38      | strategy.exit(profit=,loss=)     | NON RIPRODOTTO
//  40-44      | max_intraday_filled_orders(6)    | NON RIPRODOTTO: il cap
//             | max_intraday_loss(2,%)           |   si TAGLIA SUI DATI [L8]
//  47         | strategy.close_all(not in range) | NON RIPRODOTTO, ma
//                                                |   DICHIARATO           [L6]
//
//
//  LE SCELTE DI TRADUZIONE, NUMERATE. Sono NOSTRE, non del Pine.
//  ==================================================================
//
//  L1. RSI PINE CONTRO iRSI DI MQL5 -- VERIFICATO, NON ASSUNTO.
//      rsi(src,len) di Pine v4 = 100 - 100/(1+rs) con
//      rs = rma(guadagni,len)/rma(perdite,len), e rma e' la MEDIA DI
//      WILDER (alfa = 1/len) SEMINATA con la SMA dei primi len
//      valori. iRSI di MQL5 fa ESATTAMENTE la stessa cosa (RSI.mq5 di
//      serie: seme = somma/periodo dei primi len delta, poi
//      ricorsione (prec*(len-1)+nuovo)/len). QUINDI I DUE COINCIDONO,
//      e non e' un'opinione: la sonda calcola l'RSI col PROPRIO
//      codice puro E in parallelo legge iRSI, e mette lo SCARTO
//      MASSIMO fra i due in una colonna ("Rsi Divergenza Max").
//      ATTESA: praticamente ZERO (~1e-10). Se quella colonna non e'
//      ~0, la traduzione e' sbagliata e i numeri non valgono: e' un
//      collaudo, non un ornamento.
//      Caso degenere dichiarato: perdite medie = 0 -> RSI 100 se ci
//      sono guadagni, 50 se il mercato e' perfettamente piatto (e' la
//      convenzione di RSI.mq5 di MQL5; Pine li' restituisce na). Su
//      un cambio major non capita mai; sta scritto perche' un caso
//      degenere non dichiarato e' un numero non spiegato.
//
//  L2. LE SOGLIE RSI DELL'AUTORE SONO ASIMMETRICHE. QUI SI MISURANO
//      SIMMETRICHE, ED E' UNA SCELTA CONGELATA NEL FILE PROVA (F5).
//      Il sorgente usa overBought = 80 per il LONG e overSold = 10
//      per lo SHORT: non sono speculari (80/20 o 90/10 lo sarebbero).
//      Con 10 il lato short dell'autore arma molto piu' di rado del
//      long, e un'asimmetria del genere dentro un PASSO 0 non
//      misurerebbe il mercato: misurerebbe la scelta dell'autore.
//      QUI: un solo input, InpRsiSoglia (default 80, il valore
//      dell'autore per il long), e lo short usa 100 - InpRsiSoglia
//      (cioe' 20). CONSEGUENZA DA DICHIARARE NEL REFERTO: il nostro
//      lato SHORT conta PIU' segnali di quelli che conterebbe il
//      sorgente (20 e' piu' permissivo di 10). Se lo short passa F1
//      solo grazie a questo, va detto -- e' scritto qui apposta,
//      prima dei numeri.
//
//  L3. LA SESSIONE, E IL FUSO -- LA PARTE PIU' INCERTA DI TUTTE.
//      Il Pine scrive time(timeframe.period, "0300-1100") SENZA
//      argomento di fuso: in quel caso Pine usa il fuso dello SCAMBIO
//      del simbolo, che su un grafico FX di TradingView dipende dal
//      feed e NON e' leggibile dal sorgente.
//      RAGIONAMENTO (dichiarato, non nascosto):
//        - il titolo della pubblicazione dice "london session";
//        - la sessione di Londra e' 08:00-16:00 ORA DI LONDRA;
//        - New York e' esattamente 5 ore indietro rispetto a Londra
//          TUTTO L'ANNO (le due DST si muovono quasi insieme);
//        - quindi 03:00-11:00 in ora di NEW YORK = 08:00-16:00 ora di
//          LONDRA = la sessione di Londra ESATTA.
//      Il fuso dello scambio, quindi, e' con ogni probabilita'
//      America/New_York. E se il feed fosse invece UTC, 03:00-11:00
//      UTC = 04:00-12:00 in ora server BCM d'estate.
//      CONVERSIONE IN ORA SERVER BCM (regola di casa: server = ora
//      italiana - 1; l'Italia sta 1 ora avanti a Londra tutto l'anno,
//      quindi ORA SERVER = ORA DI LONDRA):
//        - lettura NEW YORK -> 08:00-16:00 SERVER  (la piu' probabile)
//        - lettura UTC      -> 04:00-12:00 SERVER
//      >>> E QUI LA SONDA NON DECIDE. Il criterio F7 congelato nella
//      bozza dice testualmente "L'ora NON si converte a tavolino: si
//      SWEEPA su 3 valori di inizio" -- 4 / 6 / 8 in ora server, che
//      coprono ENTRAMBE le letture piu' quella intermedia. Il
//      ragionamento qui sopra e' un'ATTESA da confermare col numero,
//      non una decisione presa al posto del tester.
//      Gli orari sono INPUT ESPLICITI IN ORA SERVER
//      (InpOraInizioServer + InpOreSessione), mai costanti sepolte.
//      E la fine e' ESCLUSIVA, come in Pine: "0300-1100" include le
//      barre da 03:00 fino a 10:55 su M5, NON quella delle 11:00.
//      PROMEMORIA DI CASA (errore gia' pagato il 06/08): le schede
//      Esperti e Giornale di MT5 stampano in ORA LOCALE del PC, il
//      GRAFICO e TimeCurrent() in ORA SERVER. Qui dentro si lavora
//      SEMPRE in ora server (TimeToStruct sull'ora della barra).
//
//  L4. IL SEGNALE NASCE SU BARRA CHIUSA, SEMPRE. Il Pine originale e'
//      senza calc_on_every_tick, quindi valuta a barra chiusa: qui
//      idem. Nessuna decisione tocca la barra in formazione: niente
//      repaint, per costruzione.
//      IL PREZZO D'INGRESSO e' l'APERTURA DELLA BARRA SUCCESSIVA a
//      quella del segnale, perche' strategy.entry() in Pine senza
//      process_orders_on_close riempie li'. Non c'e' nessun input per
//      cambiarlo: l'unica alternativa (la chiusura della barra di
//      segnale) sarebbe una gentilezza verso il candidato -- gli
//      regalerebbe il salto d'apertura -- e in un PASSO 0 non si
//      regala niente.
//
//  L5. LA MISURA E' IN PIP, NON IN PUNTI INDICE. QUI E' FOREX.
//      Un pip su EURUSD/GBPUSD vale 0,0001 in prezzo; su USDJPY vale
//      0,01. Su un simbolo a 5 (o 3) decimali il pip vale DIECI punti
//      MT5, non uno: leggere "15" dove il vero numero e' "1,5" (o
//      viceversa) e' un errore di un fattore 10, ed e' esattamente il
//      tipo di errore che questa casa ha gia' pagato.
//      DIFESA IN TRE PEZZI:
//        (a) InpPipSize e' un INPUT esplicito (default 0,0001);
//        (b) la sonda calcola DA SOLA il pip atteso dal simbolo
//            (PipAttesoDaDigits_Calc: se DIGITS e' 3 o 5 il pip vale
//            10 x POINT, altrimenti 1 x POINT) e se non combacia con
//            InpPipSize RIFIUTA DI PARTIRE, dicendo nel messaggio il
//            valore giusto da mettere nel file prova. Rifiuta, NON
//            corregge in silenzio: una correzione silenziosa e' una
//            misura che dice un'altra cosa da quella scritta nel file
//            prova. E il rifiuto e' RUMOROSO (errore di init nel
//            Giornale), non una riga di zeri che qualcuno leggerebbe
//            come un verdetto;
//        (c) escono in colonna SIA "Pip Size Prezzo" (deve valere
//            0,00010 su EURUSD/GBPUSD, 0,01000 su USDJPY) SIA "Pip In
//            Punti Mt5" (deve valere 10 su un simbolo a 5/3 decimali).
//      >>> E' l'equivalente esatto della colonna "Punto Indice
//      Prezzo" = 1,00 della SondaM0PB (T8), tradotto in forex.
//      LETTURA DELLA GEOMETRIA DELLA FONTE, che serve a leggere tutto
//      il resto: in Pine strategy.exit(profit=, loss=) e' in TICK,
//      cioe' in mintick del simbolo. Su un feed EURUSD a 5 decimali
//      (mintick 0,00001) tp = 150 tick = 0,00150 = 15,0 PIP e
//      sl = 80 tick = 0,00080 = 8,0 PIP, con RR = 150/80 = 1,875.
//      Quel 1,875 e' ESATTAMENTE il numero scritto nella bozza (F4-bis)
//      e questo CHIUDE la lettura: il feed dell'autore era a 5
//      decimali, non a 4 (a 4 decimali sarebbero 150 pip di take, che
//      su EURUSD a M5 non esistono). Il take e lo stop dell'autore NON
//      sono cancelli di questa sonda: sono la GEOMETRIA DELLA FONTE,
//      e servono a dimensionare l'orizzonte di misura (vedi L7).
//
//  L6. L'ESCURSIONE SI MISURA SU N BARRE DI CALENDARIO, E ATTRAVERSA
//      LA FINE SESSIONE. Il Pine chiude tutto quando si esce dalla
//      finestra oraria (riga 47): un segnale nato a 20 minuti dalla
//      chiusura, nel motore VERO, ha davanti 4 barre, non 12.
//      Questa sonda NON simula uscite e quindi misura comunque le
//      N barre piene.
//      >>> CONSEGUENZA DA DICHIARARE NEL REFERTO: la MFE misurata qui
//      e' un LIMITE SUPERIORE di quella che il motore incasserebbe
//      davvero. Se la MFE mediana MISURATA QUI non passa i 3,0 pip,
//      quella vera passa ancora meno: il cancello F2 e' quindi
//      CONSERVATIVO NEL VERSO GIUSTO (boccia solo cio' che merita).
//      >>> MA SULL'RR L'ONESTA' IMPONE IL CONTRARIO: anche la MAE e'
//      un limite superiore, quindi le due distorsioni vanno nello
//      STESSO verso e NON si cancellano in modo dimostrabile. L'RR
//      misurato qui e' un'INDICAZIONE, e il cancello H8 si applica
//      SAPENDOLO. Non e' una scusa preparata: e' scritto prima dei
//      numeri.
//
//  L7. DUE ORIZZONTI, E IL SECONDO NASCE DA UNA REGOLA DI CASA.
//      Il criterio F2 congelato misura la MFE a 12 BARRE (1 ora su
//      M5) e quel cancello NON SI TOCCA. Ma la CHECKLIST del 31/08
//      ("prima del lancio si rilegge ogni criterio chiedendo: il
//      BANCO puo' fisicamente soddisfarlo?") obbliga a chiedersi se
//      12 barre M5 possano contenere il take da 15 pip della fonte.
//      Con un ATR M5 di EURUSD nell'ordine dei pochi pip, quasi
//      sicuramente NO -- e una domanda senza metro e' un giro a
//      vuoto. Nota bene: il CANCELLO F2 resta comunque
//      FISICAMENTE RAGGIUNGIBILE, perche' la sua soglia e' 3,0 pip,
//      cioe' un quinto del take della fonte.
//      SOLUZIONE, e non tocca nessun criterio: la sonda misura DUE
//      orizzonti su OGNI segnale.
//        - InpBarreOrizzonte      (default 12) -> COLONNE DEL CANCELLO
//        - InpBarreOrizzonteLungo (default 96) -> COLONNE INFORMATIVE
//      96 barre M5 = 8 ore = la sessione intera dell'autore, cioe'
//      il tempo massimo che una sua posizione puo' vivere (riga 47
//      del Pine chiude tutto a fine finestra). E' l'orizzonte che il
//      take da 15 pip PUO' fisicamente contenere. NESSUN CANCELLO
//      sulle colonne lunghe: servono a sapere, non a promuovere.
//      L'RR sull'orizzonte lungo NON ha una colonna sua: si ricalcola
//      a mano dividendo "Mfe Lungo Mediano" per "Mae Lungo Mediano"
//      (una colonna derivabile e' una colonna che gonfia il CSV e
//      basta).
//
//  L8. NESSUN CAP GIORNALIERO, E I DUE LATI SONO INDIPENDENTI.
//      L'autore cappa a 6 ordini al giorno e al 2% di perdita
//      intraday (righe 40-44). Qui NON esiste nessun cap: il cap si
//      TAGLIA SUI DATI, e i dati per tagliarlo sono le colonne "Max
//      Segnali Giorno" (criterio F4). Mettere il cap dentro la sonda
//      vorrebbe dire misurare il cap invece del mercato.
//      ATTENZIONE PROP, gia' scritta nel file prova: se
//      (max segnali giorno) x 0,65% supera il cap C1 di rischio
//      aperto (3,25%, firmato il 18/08), il cap va scritto nell'EA
//      DAL PRIMO ROUND, non aggiunto dopo.
//      I due lati possono sparare sulla stessa barra: nel Pine sono
//      due strategy.entry distinti senza blocco reciproco, e qui non
//      esiste nessuna posizione che se li contenda.
//
//  L9. LA GIORNATA = giornata di calendario del SERVER con almeno una
//      barra valutata DENTRO LA SESSIONE. Non si contano i giorni del
//      calendario civile: un festivo senza barre non e' un giorno in
//      cui il motore "non ha trovato segnali", e' un giorno in cui il
//      mercato era chiuso. Dividere per quello gonfierebbe il
//      denominatore e ABBASSEREBBE la frequenza -- cioe' sbaglierebbe
//      CONTRO il candidato.
//
//  L10. IL RITARDO DI MISURA, E PERCHE' NESSUN SEGNALE HA UN
//      ORIZZONTE TRONCATO. Per misurare l'escursione servono le barre
//      DOPO il segnale. Invece di tenere una coda di segnali aperti,
//      la sonda valuta la barra che sta ORIZZONTE_MAX barre indietro:
//      cosi' le barre successive sono gia' tutte chiuse e stanno
//      nello stesso array, e OGNI segnale contato ha ENTRAMBI gli
//      orizzonti COMPLETI. Nessuna mediana e' sporcata da segnali
//      misurati su meno barre.
//      >>> PREZZO DA DICHIARARE: la CODA della finestra di corsa --
//      le ultime ORIZZONTE_MAX barre -- non viene valutata. Con i
//      default sono 96 barre M5, cioe' 8 ore su una finestra di mesi:
//      trascurabile sul denominatore dei giorni, ma va detto.
//
//  L11. INDICATORI RICALCOLATI SU UNA CODA DI InpWarmupBarre BARRE
//      (default 300) a ogni barra nuova, con funzioni PURE che
//      lavorano su array. E' piu' lento di uno stato incrementale, ma
//      e' l'unica forma che l'AUTOTEST puo' interrogare a tavolino.
//      L'errore introdotto dal seme corto e' calcolabile e
//      trascurabile: la Wilder dell'RSI(5) dimentica il seme con
//      (4/5)^N e la SMA(5) non ha memoria oltre 5 barre. La colonna
//      "Rsi Divergenza Max" contro iRSI (che parte dall'inizio dello
//      storico) lo verifica sul campo.
//
//  L12. L'ATR NON VIENE DAL PINE. Il sorgente non usa nessun ATR:
//      quello che esce in colonna ("Atr Mediano Pip") e' un METRO DI
//      CASA, ATR di Wilder a 14 periodi, e serve a una cosa sola --
//      sapere se lo stop da 8 pip dell'autore sta SOPRA o SOTTO il
//      rumore della sessione (pavimento SL, R109). Non decide niente
//      e non ha cancelli. Il periodo e' un #define e non un input
//      APPOSTA: un metro che si puo' sweepare dalla riga di lancio
//      diventa una manopola da pesca.
//      E NON si confronta con iATR: iATR di MQL5 e' la SMA del True
//      Range, non la Wilder (differenza gia' MISURATA e dichiarata
//      nella SondaM0PB, T3). Confrontarli darebbe una divergenza
//      attesa NON nulla, cioe' un collaudo che non collauda.
//      Il campione dell'ATR si raccoglie su OGNI BARRA DI SESSIONE
//      valutata, non sui segnali: cosi' descrive la sessione e non i
//      segnali, e resta INVARIANTE fra le due passate dell'ablazione
//      (vedi L13).
//
//  L13. L'ABLAZIONE SI MISURA DENTRO OGNI PASSATA, E L'ASSE DIVENTA
//      UN GATE DI DETERMINISMO. Questa e' la parte rubata alla
//      SondaM0PB e migliorata.
//      La sonda conta SEMPRE, in ogni passata, TRE cose per lato:
//        - "Segnali Nudo"   = canale + sessione, RSI ignorato
//        - "Segnali Con Rsi" = canale + sessione + RSI
//        - "Segnali"        = quelli VERI, cioe' quelli scelti da
//                             InpUsaRsi, e sono quelli che portano le
//                             mediane e i cancelli.
//      Le prime due NON dipendono da InpUsaRsi. Quindi, confrontando
//      le due passate dell'asse a PARITA' di ora:
//        (a) "Segnali Nudo" e "Segnali Con Rsi" devono venire
//            IDENTICI -> e' un GATE DI DETERMINISMO vero, non una
//            speranza;
//        (b) "Segnali" deve combaciare con "Nudo" nella passata a
//            false e con "Con Rsi" in quella a true -> e' il gate che
//            dimostra che l'interruttore e' CABLATO davvero;
//        (c) "Con Rsi" <= "Nudo" sempre, per costruzione (il filtro
//            e' un sottoinsieme). Se non fosse vero, il codice
//            sarebbe rotto.
//      L'ablazione F1-bis, cosi', si legge da UNA SOLA RIGA del CSV.
//+------------------------------------------------------------------+
#property copyright "ABTG - Sonda di frequenza LondonFx (PASSO 0, caccia frequenza 2a battuta 31/08/2026)"
#property version   "1.00"
#property description "CONTATORE di segnali LondonFx (canale SMA5 high/low + sessione Londra + RSI opzionale). NON APRE ORDINI."
#property strict

//--- LE SOGLIE CONGELATE PRIMA DI VEDERE I NUMERI. Sono #define e non
//    input APPOSTA: un cancello che si puo' spostare dalla riga di
//    lancio non e' un cancello. Fonte: prove\LONDONFX_FREQUENZA_M5.txt
#define LONDONFX_SOGLIA_SEGNALI_GIORNO   1.00   // F1, pavimento duro di Claudio 31/08
#define LONDONFX_SOGLIA_SEGNALI_PREFERITA 2.00  // F1, sopra questa e' la fascia preferita
#define LONDONFX_SOGLIA_MFE_SCARTO       3.00   // F2, sotto questa e' SCARTO (3 x ~1,0 pip di spread) [SPREAD NON MISURATO]
#define LONDONFX_SOGLIA_MFE_PASSA        6.00   // F2, sopra questa e' PASSA PIENO. Fra le due: SOSPESO
#define LONDONFX_SOGLIA_RR               0.70   // H8, FIRME_2026-08-31.md FIRMA 2
#define LONDONFX_E_TARGET_R              0.075  // H8, E >= 0,075R a tick

//--- LA FASCIA COPERTA DA DUE BULLET, SCIOLTA VERSO LA CLAUSOLA PIU'
//    SEVERA (CHECKLIST 31/08, classe delle sovrapposizioni).
//    La bozza congelata diceva insieme:
//        ">= 3,0 pip -> PASSA"   e   "fra 3,0 e 6,0 -> VERDETTO SOSPESO"
//    cioe' l'intervallo [3,0 ; 6,0] cadeva in DUE clausole. La regola
//    di casa e' esplicita: quando la sovrapposizione c'e' gia' ed e'
//    troppo tardi per riscrivere il criterio, VINCE LA CLAUSOLA PIU'
//    SEVERA, e si DICHIARA di averla scelta. Quindi, congelato qui:
//        MFE mediana <  3,00 pip            -> MORTO F2
//        MFE mediana >= 3,00 e <= 6,00 pip  -> VERDETTO SOSPESO
//        MFE mediana >  6,00 pip            -> PASSA F2
//    Nessun punto dell'asse cade in due clausole. E il verdetto e'
//    calcolato da UNA funzione pura (VerdettoF2_Calc) che l'autotest
//    ESEGUE su una cella di OGNI fascia -- perche' un gate che
//    ricopia le SOGLIE senza ricopiare le DISUGUAGLIANZE e' come non
//    averlo (e' successo, ed e' nella checklist).

//--- il metro di rumore di L12. #define e non input: non e' una manopola.
#define LONDONFX_ATR_PERIODO 14

//--- quanti blocchi di autotest DEVONO girare. Se il contatore a
//    runtime non arriva a questo numero, un blocco e' sparito e
//    l'autotest si dichiara FALLITO: un test rimosso per sbaglio non
//    deve poter passare per "tutto verde".
#define LONDONFX_AUTOTEST_BLOCCHI_ATTESI 16

//--- capienza dei campioni per le mediane. Su M5 e ~1,3 anni i
//    segnali attesi sono qualche migliaio per lato e le barre di
//    sessione qualche decina di migliaia: 100.000 e' abbondante. Se
//    si arrivasse al tetto la mediana sarebbe TRONCATA, quindi il
//    fatto viene stampato a voce alta invece di essere ingoiato.
#define LONDONFX_MAX_CAMPIONI 100000

//==================================================================
//  INPUT
//  I nomi vanno pinnati TALI E QUALI nel file prova: MT5 IGNORA IN
//  SILENZIO un pin che non trova (errore n.3 della
//  CHECKLIST_RIGA_DI_LANCIO, e' cosi' che e' nato il falso "0/8" del
//  FiboH4). Questi nomi sono quelli PROPOSTI dalla bozza del 31/08,
//  tenuti IDENTICI apposta, piu' DUE aggiunte dichiarate nel file
//  prova: InpBarreOrizzonteLungo (vedi L7) e InpConfrontaMT5 (L1).
//==================================================================
input group "=== IL MOTORE DI SEGNALE (tutto cablato dall'autore) ==="
input int    InpSmaPeriodo   = 5;        // SMA su HIGH e su LOW: il canale (Pine righe 6-15)
input bool   InpUsaRsi       = true;     // ABLAZIONE F1-bis: conferma RSI accesa/spenta. L'autore la dichiara OPZIONALE
input int    InpRsiPeriodo   = 5;        // RSI: periodo (Pine riga 18)
input double InpRsiSoglia    = 80.0;     // RSI: soglia LONG. Lo SHORT usa 100 - questa (simmetrica: vedi L2)

input group "=== LA SESSIONE, IN ORA SERVER BCM (= ora italiana - 1) ==="
input int    InpOraInizioServer = 8;     // ORA SERVER di inizio. 8 = lettura New York del Pine (vedi L3). SWEEPATO 4/6/8
input int    InpOreSessione     = 8;     // durata in ore, FINE ESCLUSA come in Pine ("0300-1100" = 8 ore)

input group "=== GLI ORIZZONTI DI MISURA (vedi L7) ==="
input int    InpBarreOrizzonte      = 12; // barre dall'ingresso su cui si misura la MFE/MAE DEL CANCELLO F2/F3
input int    InpBarreOrizzonteLungo = 96; // orizzonte INFORMATIVO: 96 barre M5 = 8 ore = la sessione dell'autore

input group "=== L'UNITA' DI MISURA: PIP, NON PUNTI INDICE (vedi L5) ==="
input double InpPipSize      = 0.0001;   // 1 pip in PREZZO. 0,0001 su EURUSD/GBPUSD, 0,01 su USDJPY. VERIFICATO in OnInit

input group "=== TECNICI ==="
input int    InpWarmupBarre  = 300;      // coda di barre su cui si ricalcolano gli indicatori. Vedi L11
input bool   InpConfrontaMT5 = true;     // legge anche iRSI e mette lo SCARTO in colonna (collaudo L1)
input bool   InpScriviCsv    = true;     // CSV riga-per-segnale + CSV totali (SOLO fuori ottimizzazione)
input bool   InpVerbose      = true;     // log (in ottimizzazione NON li legge nessuno: vedi le colonne)
input bool   InpAutoTest     = true;     // autotest del nucleo puro. L'esito esce in COLONNA
input string InpTag          = "LONDONFX_SONDA"; // ETICHETTA della corsa (NON e' un magic: qui non ci sono ordini)

//==================================================================
//  STATO -- tutti accumulatori di conteggio. Nessuno stato di
//  posizione, perche' non esistono posizioni.
//==================================================================
datetime gLastBar = 0;

//--- l'UNICO handle del file, e non decide NIENTE: serve al collaudo L1
int    hRsiMt5 = INVALID_HANDLE;

//--- il ritardo di misura (L10) = massimo dei due orizzonti
int    gOrizzonteMax = 0;

//--- conteggi generali
long   gBarreValutate    = 0;
long   gBarreSaltateDati = 0;   // storico corto o prezzo non valido: barra NON valutata
long   gFuoriSessione    = 0;   // segnali NUDI caduti fuori dalla sessione
long   gCanaleInvertito  = 0;   // INVARIANTE: SMA(high) < SMA(low) e' impossibile. Atteso 0

//--- conteggi per LATO (mai aggregati in una colonna di merito)
long   gSegnaliLong = 0, gSegnaliShort = 0;   // il lato VERO, secondo InpUsaRsi
long   gNudoLong    = 0, gNudoShort    = 0;   // ablazione: canale nudo
long   gConRsiLong  = 0, gConRsiShort  = 0;   // ablazione: canale + RSI
long   gMfeZeroLong = 0, gMfeZeroShort = 0;   // escursione favorevole nulla
long   gMaeZeroLong = 0, gMaeZeroShort = 0;   // escursione avversa nulla

//--- giornate (L9)
int    gDayStamp      = -1;
int    gDaySigLong    = 0, gDaySigShort = 0;
long   gGiorniContati = 0;
long   gMaxGiornoLong = 0, gMaxGiornoShort = 0, gMaxGiornoTot = 0;
long   gG1Long = 0, gG2Long = 0, gG1Short = 0, gG2Short = 0;
long   gG1Tot  = 0, gG2Tot  = 0, gGiorniZero = 0;

//--- campioni per le mediane (in PIP)
double gMfeL[],  gMfeS[],  gMaeL[],  gMaeS[];
double gMfeLL[], gMfeLS[], gMaeLL[], gMaeLS[];
double gRrL[],   gRrS[],   gAtrPip[];
int    gNMfeL = 0, gNMfeS = 0, gNMaeL = 0, gNMaeS = 0;
int    gNMfeLL = 0, gNMfeLS = 0, gNMaeLL = 0, gNMaeLS = 0;
int    gNRrL = 0,  gNRrS = 0,  gNAtr = 0;
bool   gTroncato = false;

//--- somme per le medie (la media accanto alla mediana dice l'asimmetria)
double gSommaMfeL = 0.0, gSommaMfeS = 0.0;

//--- collaudo L1
double gRsiDivMax = 0.0;

//--- autotest: -1 = NON eseguito, che non e' "passato"
int    gAutotestFalliti = -1;
int    gAutotestBlocchi = 0;

//--- CSV riga-per-segnale
int    gCsvSeg = INVALID_HANDLE;

void Log(string m){ if(InpVerbose) Print("[LONDONFX-SONDA] ", m); }

//==================================================================
//
//   NUCLEO PURO -- funzioni che non leggono NIENTE dal terminale.
//   Prendono numeri e rispondono. E' questa la parte che l'AUTOTEST
//   interroga a tavolino, senza mercato.
//
//==================================================================

//+------------------------------------------------------------------+
//| RSI da medie di Wilder gia' calcolate. Il caso degenere e'         |
//| esplicito (vedi L1): perdite nulle -> 100 se ci sono guadagni,     |
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
//| Seme = media semplice dei primi 'periodo' delta, poi ricorsione    |
//| di Wilder: e' rsi() di Pine ed e' iRSI di MQL5 (vedi L1).          |
//| out[i] = -1 sulle barre in cui l'RSI non e' ancora definito: -1 e' |
//| fuori dal dominio [0,100], quindi nessun confronto di soglia lo    |
//| puo' scambiare per un valore vero.                                 |
//+------------------------------------------------------------------+
bool RsiWilderSerie_Calc(const double &close[], const int n, const int periodo, double &out[])
  {
   if(periodo < 1 || n <= periodo) return(false);
   if(ArrayResize(out, n) != n) return(false);
   for(int i = 0; i < n; i++) out[i] = -1.0;

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
//| SMA alla Pine: il valore e' definito dall'indice periodo-1 in poi. |
//| Le barre prima restano a 0 e non vengono mai lette (il chiamante   |
//| parte molto dopo: vedi il cancello su InpWarmupBarre in OnInit).   |
//+------------------------------------------------------------------+
bool SmaSerie_Calc(const double &src[], const int n, const int periodo, double &out[])
  {
   if(periodo < 1 || n < periodo) return(false);
   if(ArrayResize(out, n) != n) return(false);
   for(int i = 0; i < n; i++) out[i] = 0.0;

   double s = 0.0;
   for(int i = 0; i < periodo; i++) s += src[i];
   out[periodo - 1] = s/(double)periodo;

   for(int i = periodo; i < n; i++)
     {
      s += src[i] - src[i - periodo];
      out[i] = s/(double)periodo;
     }
   return(true);
  }

//+------------------------------------------------------------------+
//| TRUE RANGE: sulla PRIMA barra della finestra non c'e' chiusura     |
//| precedente, quindi TR = high - low.                                |
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
//| ATR DI WILDER (metro di casa, NON viene dal Pine: vedi L12).       |
//| Seme = media semplice dei primi 'periodo' TR, poi alfa = 1/periodo.|
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
//| IL CANALE, LATO LONG (Pine riga 25): close > sma(high) AND         |
//| close > sma(low).                                                  |
//| NOTA DI LETTURA, che vale la pena avere scritta: la seconda meta'  |
//| e' RIDONDANTE, perche' sma(high,n) >= sma(low,n) SEMPRE (la        |
//| differenza e' la media di high-low, che non e' mai negativa).      |
//| Si riproduce comunque ALLA LETTERA, per due motivi: (a) fedelta'   |
//| al sorgente, (b) se un giorno i due periodi diventassero diversi   |
//| la ridondanza sparirebbe. L'invariante e' verificata dall'autotest |
//| E contata a runtime nella colonna "Canale Invertito" (attesa 0).   |
//+------------------------------------------------------------------+
bool CanaleLong_Calc(const double chiusura, const double smaHigh, const double smaLow)
  {
   return(chiusura > smaHigh && chiusura > smaLow);
  }

//+------------------------------------------------------------------+
//| IL CANALE, LATO SHORT (Pine riga 26): specchio esatto.             |
//+------------------------------------------------------------------+
bool CanaleShort_Calc(const double chiusura, const double smaHigh, const double smaLow)
  {
   return(chiusura < smaHigh && chiusura < smaLow);
  }

//+------------------------------------------------------------------+
//| LA CONFERMA RSI, SIMMETRIZZATA (vedi L2).                          |
//| usa = false -> passa sempre: e' il ramo "canale NUDO" dell'         |
//| ablazione F1-bis, e deve essere neutro per costruzione.            |
//| rsi < 0 significa "non ancora definito": non passa mai, perche' un |
//| valore fuori dominio non deve poter fare da conferma.              |
//+------------------------------------------------------------------+
bool FiltroRsi_Calc(const bool usa, const bool latoLong, const double rsi, const double soglia)
  {
   if(!usa) return(true);
   if(rsi < 0.0) return(false);
   if(latoLong) return(rsi > soglia);
   return(rsi < (100.0 - soglia));
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
//| n <= 0 -> 0, che si legge "nessun campione", non "zero pip".       |
//+------------------------------------------------------------------+
double MedianaOrdinata_Calc(const double &v[], const int n)
  {
   if(n <= 0) return(0.0);
   if(n % 2 == 1) return(v[n/2]);
   return((v[n/2 - 1] + v[n/2])/2.0);
  }

//+------------------------------------------------------------------+
//| Da differenza di PREZZO a PIP (vedi L5). pipSize <= 0 -> 0, che si |
//| legge "non convertibile", e la colonna "Pip Size Prezzo" dice      |
//| perche'. Caso di collaudo che vale la pena tenere a mente:         |
//| Pip_Calc(0,00150 ; 0,0001) = 15,0 = il take della fonte.           |
//+------------------------------------------------------------------+
double Pip_Calc(const double diffPrezzo, const double pipSize)
  {
   if(pipSize <= 0.0) return(0.0);
   return(diffPrezzo/pipSize);
  }

//+------------------------------------------------------------------+
//| IL PIP CHE IL SIMBOLO SI ASPETTA (difesa (b) di L5).               |
//| Convenzione universale sul forex: sui simboli a 5 decimali (major  |
//| non-JPY) e a 3 decimali (JPY) il pip vale DIECI punti MT5; sui     |
//| vecchi 4 e 2 decimali vale un punto.                               |
//+------------------------------------------------------------------+
double PipAttesoDaDigits_Calc(const double punto, const int decimali)
  {
   if(punto <= 0.0) return(0.0);
   if(decimali == 3 || decimali == 5) return(punto*10.0);
   return(punto);
  }

//+------------------------------------------------------------------+
//| RR = mediana(favorevole) / mediana(avversa). E' definito COSI' nel |
//| criterio F4-bis congelato (numero 2 diviso numero 3), NON come     |
//| mediana dei rapporti: sono due numeri diversi e la sonda li stampa |
//| TUTTI E DUE, dichiarando quale e' il cancello.                     |
//| Collaudo che vale la pena tenere: RrDaMediane_Calc(15;8) = 1,875,  |
//| cioe' la geometria della fonte (tp 150 / sl 80 tick).              |
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
//| Riproduce la tabella CONGELATA nella bozza (criterio F4-bis):      |
//|   RR 0,36 -> 79,0% | 0,73 -> 62,2% | 1,00 -> 53,8%                 |
//|   RR 1,42 -> 44,4% | 1,56 -> 42,0% | 1,875 -> 37,4%                |
//| L'autotest confronta con QUEI sei valori: se la formula si muove,  |
//| il cancello se ne accorge.                                          |
//+------------------------------------------------------------------+
double WinRateNecessario_Calc(const double rr, const double eTarget)
  {
   if(rr <= -1.0) return(0.0);
   return((eTarget + 1.0)/(rr + 1.0));
  }

//+------------------------------------------------------------------+
//| LA SESSIONE IN ORA SERVER. Inizio INCLUSO, fine ESCLUSA, come la   |
//| session() di Pine: "0300-1100" prende le barre da 03:00 a 10:55 su |
//| M5 e NON quella delle 11:00 (vedi L3).                             |
//| Regge anche il caso a cavallo della mezzanotte, che su Londra non  |
//| serve ma che su una sessione asiatica servirebbe.                  |
//+------------------------------------------------------------------+
bool SessioneAttiva_Calc(const int ora, const int inizio, const int ore)
  {
   if(ore <= 0 || ore > 24) return(false);
   if(ora < 0 || ora > 23) return(false);
   if(inizio < 0 || inizio > 23) return(false);
   if(ore == 24) return(true);
   int fine = inizio + ore;                       // ESCLUSA
   if(fine <= 24) return(ora >= inizio && ora < fine);
   return(ora >= inizio || ora < (fine - 24));
  }

//+------------------------------------------------------------------+
//| I VERDETTI, CALCOLATI DA CODICE E NON RILETTI A OCCHIO.            |
//| CHECKLIST 31/08: un gate che ricopia le SOGLIE senza ricopiare le  |
//| DISUGUAGLIANZE non e' un gate. Qui le disuguaglianze SONO il       |
//| codice, e l'autotest le esegue su una cella di OGNI fascia.        |
//+------------------------------------------------------------------+
string VerdettoF1_Calc(const double segnaliGiorno)
  {
   if(segnaliGiorno < LONDONFX_SOGLIA_SEGNALI_GIORNO)    return("MORTO F1");
   if(segnaliGiorno <= LONDONFX_SOGLIA_SEGNALI_PREFERITA) return("PASSA AL MINIMO");
   return("PASSA");
  }

//+------------------------------------------------------------------+
//| F2, con la sovrapposizione della bozza sciolta verso la clausola   |
//| PIU' SEVERA (vedi il blocco di #define in testa). Nessun punto     |
//| dell'asse cade in due clausole.                                     |
//+------------------------------------------------------------------+
string VerdettoF2_Calc(const double mfeMediana)
  {
   if(mfeMediana <  LONDONFX_SOGLIA_MFE_SCARTO) return("MORTO F2");
   if(mfeMediana <= LONDONFX_SOGLIA_MFE_PASSA)  return("SOSPESO F2 - serve lo spread VERO");
   return("PASSA F2");
  }

//+------------------------------------------------------------------+
//| H8: sotto soglia si muore PER ARITMETICA, senza corsa a tick.      |
//+------------------------------------------------------------------+
string VerdettoH8_Calc(const double rr)
  {
   if(rr < LONDONFX_SOGLIA_RR) return("MORTO H8 PER ARITMETICA");
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
   if(n >= LONDONFX_MAX_CAMPIONI){ gTroncato = true; return; }
   if(n >= ArraySize(v))
     {
      int nuovo = (ArraySize(v) <= 0) ? 4096 : ArraySize(v)*2;
      if(nuovo > LONDONFX_MAX_CAMPIONI) nuovo = LONDONFX_MAX_CAMPIONI;
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
//| dovrebbero ripartire dai loro valori iniziali -- DOVREBBERO. Con  |
//| due assi sweepati, una passata che ereditasse i campioni della    |
//| precedente darebbe mediane sporche e nessuno se ne accorgerebbe   |
//| guardando il CSV: i numeri sarebbero plausibili e sbagliati --    |
//| e qui farebbe crollare proprio il GATE DI DETERMINISMO di L13,    |
//| che e' la cosa su cui si legge l'ablazione. Azzerare a mano costa |
//| una funzione e toglie il dubbio.                                  |
//+------------------------------------------------------------------+
void AzzeraContatori()
  {
   gLastBar = 0;
   gBarreValutate = 0; gBarreSaltateDati = 0; gFuoriSessione = 0; gCanaleInvertito = 0;
   gSegnaliLong = 0; gSegnaliShort = 0;
   gNudoLong = 0; gNudoShort = 0;
   gConRsiLong = 0; gConRsiShort = 0;
   gMfeZeroLong = 0; gMfeZeroShort = 0;
   gMaeZeroLong = 0; gMaeZeroShort = 0;
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
   gRsiDivMax = 0.0;
   gAutotestFalliti = -1; gAutotestBlocchi = 0;
  }

int OnInit()
  {
   AzzeraContatori();

   //--- CANCELLI DI CONFIGURAZIONE: rifiutano, non correggono in
   //    silenzio. Un default nascosto e' una misura che dice un'altra
   //    cosa da quella che c'e' scritta nel file prova.
   if(InpSmaPeriodo < 1)
     { Print("ERRORE: InpSmaPeriodo deve essere >= 1 (il sorgente dice 5)."); return(INIT_FAILED); }
   if(InpRsiPeriodo < 2)
     { Print("ERRORE: InpRsiPeriodo deve essere >= 2 (il sorgente dice 5)."); return(INIT_FAILED); }
   if(InpRsiSoglia <= 50.0 || InpRsiSoglia >= 100.0)
     { Print("ERRORE: InpRsiSoglia deve stare fra 50 e 100, estremi esclusi (il sorgente dice 80 per il long). Lo short usa 100 - questa: vedi L2."); return(INIT_FAILED); }
   if(InpOraInizioServer < 0 || InpOraInizioServer > 23)
     { Print("ERRORE: InpOraInizioServer deve stare fra 0 e 23, ed e' ORA SERVER BCM (= ora italiana - 1)."); return(INIT_FAILED); }
   if(InpOreSessione < 1 || InpOreSessione > 24)
     { Print("ERRORE: InpOreSessione deve stare fra 1 e 24 (il sorgente dice 8: \"0300-1100\", fine esclusa)."); return(INIT_FAILED); }
   if(InpBarreOrizzonte < 1)
     { Print("ERRORE: InpBarreOrizzonte deve essere >= 1 (il criterio F2 congelato dice 12)."); return(INIT_FAILED); }
   if(InpBarreOrizzonteLungo < InpBarreOrizzonte)
     { Print("ERRORE: InpBarreOrizzonteLungo non puo' essere piu' corto di InpBarreOrizzonte: l'orizzonte lungo esiste per CONTENERE quello del cancello (vedi L7)."); return(INIT_FAILED); }
   if(InpBarreOrizzonteLungo > 2000)
     { Print("ERRORE: InpBarreOrizzonteLungo sopra 2000 barre mangerebbe la finestra di corsa senza dire niente di piu' (vedi L10)."); return(INIT_FAILED); }
   if(InpPipSize <= 0.0)
     { Print("ERRORE: InpPipSize deve essere > 0. E' 1 pip in PREZZO: 0,0001 su EURUSD/GBPUSD, 0,01 su USDJPY."); return(INIT_FAILED); }

   //--- LA DIFESA (b) DI L5: il pip dichiarato contro il pip che il
   //    simbolo si aspetta. Un fattore 10 (o 100) qui dentro farebbe
   //    leggere una TAGLIA sbagliata e passare o bocciare F2 per un
   //    motivo che non c'entra niente col mercato.
   double punto      = SymbolInfoDouble(_Symbol, SYMBOL_POINT);
   int    decimali   = (int)SymbolInfoInteger(_Symbol, SYMBOL_DIGITS);
   double pipAtteso  = PipAttesoDaDigits_Calc(punto, decimali);
   if(pipAtteso <= 0.0)
     { Print("ERRORE: SYMBOL_POINT nullo: il pip non e' calcolabile e nessun numero di questa sonda varrebbe niente."); return(INIT_FAILED); }
   if(MathAbs(InpPipSize - pipAtteso) > pipAtteso*0.01)
     {
      PrintFormat("ERRORE UNITA' DI MISURA (vedi L5): InpPipSize = %.5f ma %s ha DIGITS = %d e POINT = %.5f, quindi il pip vale %.5f. QUESTA CORSA NON PARTE APPOSTA: con il pip sbagliato la taglia esce falsata di un fattore e F2 direbbe una bugia. METTERE InpPipSize=%.5f nel file prova per questo simbolo (0,0001 su EURUSD/GBPUSD, 0,01 su USDJPY).",
                  InpPipSize, _Symbol, decimali, punto, pipAtteso, pipAtteso);
      return(INIT_FAILED);
     }

   //--- il ritardo di misura di L10: si valuta la barra che sta
   //    ORIZZONTE_MAX barre indietro, cosi' OGNI segnale contato ha
   //    ENTRAMBI gli orizzonti completi.
   gOrizzonteMax = (InpBarreOrizzonteLungo > InpBarreOrizzonte) ? InpBarreOrizzonteLungo : InpBarreOrizzonte;

   //--- la coda deve bastare a TUTTI gli indicatori PIU' l'orizzonte
   //    di misura PIU' un margine di riscaldamento vero.
   int minimo = InpSmaPeriodo + InpRsiPeriodo + LONDONFX_ATR_PERIODO + gOrizzonteMax + 50;
   if(InpWarmupBarre < minimo)
     {
      PrintFormat("ERRORE: InpWarmupBarre = %d e' troppo corto: con questi periodi e un orizzonte di %d barre ne servono almeno %d (vedi L10/L11).",
                  InpWarmupBarre, gOrizzonteMax, minimo);
      return(INIT_FAILED);
     }
   if(InpWarmupBarre > 5000)
     { Print("ERRORE: InpWarmupBarre sopra 5000 rallenta la corsa senza guadagnare precisione (il seme e' gia' dimenticato: vedi L11)."); return(INIT_FAILED); }

   //--- l'UNICO handle del file, e non decide NIENTE: serve solo al
   //    collaudo L1 (la colonna di divergenza).
   if(InpConfrontaMT5)
     {
      hRsiMt5 = iRSI(_Symbol, PERIOD_CURRENT, InpRsiPeriodo, PRICE_CLOSE);
      if(hRsiMt5 == INVALID_HANDLE)
         Log("ATTENZIONE: handle iRSI non creato. La colonna di divergenza restera' a 0, cioe' IL COLLAUDO L1 NON E' STATO FATTO (che non e' 'passato').");
     }

   ArrayResize(gMfeL, 0);  ArrayResize(gMfeS, 0);
   ArrayResize(gMaeL, 0);  ArrayResize(gMaeS, 0);
   ArrayResize(gMfeLL, 0); ArrayResize(gMfeLS, 0);
   ArrayResize(gMaeLL, 0); ArrayResize(gMaeLS, 0);
   ArrayResize(gRrL, 0);   ArrayResize(gRrS, 0);
   ArrayResize(gAtrPip, 0);

   if(InpAutoTest) AutoTestLondonFx();

   Log(StringFormat("SONDA DI FREQUENZA LONDONFX avviata su %s %s. Etichetta '%s'. NON APRE ORDINI: e' un contatore.",
                    _Symbol, EnumToString((ENUM_TIMEFRAMES)Period()), InpTag));
   Log(StringFormat("motore: chiusura fuori dal canale SMA(%d) di HIGH/LOW, dentro la sessione %02d:00-%02d:00 ORA SERVER (fine esclusa), conferma RSI(%d) %s (long > %.1f, short < %.1f).",
                    InpSmaPeriodo, InpOraInizioServer, (InpOraInizioServer + InpOreSessione)%24,
                    InpRsiPeriodo, (InpUsaRsi ? "ACCESA" : "SPENTA - ramo NUDO dell'ablazione F1-bis"),
                    InpRsiSoglia, 100.0 - InpRsiSoglia));
   Log(StringFormat("misura in PIP: 1 pip = %.5f in prezzo = %.1f punti MT5 (DIGITS %d). Orizzonti: %d barre (CANCELLO F2/F3) e %d barre (informativo, L7). Ritardo di misura %d barre (L10).",
                    InpPipSize, InpPipSize/punto, decimali, InpBarreOrizzonte, InpBarreOrizzonteLungo, gOrizzonteMax));
   Log(StringFormat("cancelli CONGELATI: F1 segnali/giorno >= %.2f | F2 MFE mediana > %.1f pip (fra %.1f e %.1f = SOSPESO, clausola PIU' SEVERA) | H8 RR mediano >= %.2f (E >= %.3fR a tick).",
                    LONDONFX_SOGLIA_SEGNALI_GIORNO, LONDONFX_SOGLIA_MFE_PASSA,
                    LONDONFX_SOGLIA_MFE_SCARTO, LONDONFX_SOGLIA_MFE_PASSA,
                    LONDONFX_SOGLIA_RR, LONDONFX_E_TARGET_R));

   //--- il CSV riga-per-segnale esiste SOLO fuori dall'ottimizzazione:
   //    con piu' passate che condividono lo stesso file ogni passata
   //    sovrascriverebbe la precedente (trappola gia' scritta nel
   //    referto FVGRET).
   //    NOTA: qui NON esiste nessuna colonna open_time/close_time,
   //    e non e' una dimenticanza -- non ci sono operazioni. La riga
   //    e' il SEGNALE, e la sua unica ora e' quella della barra che
   //    lo ha generato.
   if(InpScriviCsv && !MQLInfoInteger(MQL_OPTIMIZATION))
     {
      string f = StringFormat("ABTG_SondaLondonFx_%s_%s_segnali.csv", _Symbol, EnumToString((ENUM_TIMEFRAMES)Period()));
      gCsvSeg = FileOpen(f, FILE_WRITE|FILE_CSV|FILE_ANSI, ";");
      if(gCsvSeg != INVALID_HANDLE)
         FileWrite(gCsvSeg, "ora_barra_segnale", "lato", "chiusura_segnale", "sma_high", "sma_low",
                   "rsi_segnale", "passa_rsi", "prezzo_ingresso",
                   "mfe_pip", "mae_pip", "mfe_lungo_pip", "mae_lungo_pip", "rr_segnale");
      else
         Log("ATTENZIONE: CSV dei segnali non aperto: il conteggio restera' solo nelle colonne, non ricontabile a mano.");
     }
   else if(InpScriviCsv)
      Log("CSV riga-per-segnale NON scritto: siamo in OTTIMIZZAZIONE e le passate si sovrascriverebbero. I numeri escono nelle colonne di OPTFRAME.");

   return(INIT_SUCCEEDED);
  }

void OnDeinit(const int reason)
  {
   if(hRsiMt5 != INVALID_HANDLE) IndicatorRelease(hRsiMt5);
   if(gCsvSeg != INVALID_HANDLE){ FileClose(gCsvSeg); gCsvSeg = INVALID_HANDLE; }
  }

//+------------------------------------------------------------------+
//| Un solo gesto per tick: se e' nata una barra nuova, si valuta la  |
//| barra che sta gOrizzonteMax barre piu' indietro (L10). Non c'e'   |
//| nient'altro da fare: non ci sono posizioni da gestire.            |
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
//| IL CUORE. Legge la coda di barre, ricalcola gli indicatori con le |
//| funzioni pure e decide se sulla barra di segnale c'era un         |
//| segnale; poi misura le escursioni sulle barre successive, che     |
//| sono gia' tutte chiuse e stanno nello stesso array (L10).         |
//| Non apre niente e non chiude niente: conta e misura distanze.     |
//+------------------------------------------------------------------+
void ValutaBarraChiusa()
  {
   int n = InpWarmupBarre;
   double apertura[], high[], low[], close[];
   ArraySetAsSeries(apertura,  false);
   ArraySetAsSeries(high,  false);
   ArraySetAsSeries(low,   false);
   ArraySetAsSeries(close, false);

   //--- shift 1 = ultima barra CHIUSA. Si copiano n barre che
   //    FINISCONO li'; l'indice n-1 e' l'ultima chiusa e la barra di
   //    SEGNALE sta gOrizzonteMax indietro rispetto a quella.
   if(CopyOpen (_Symbol, PERIOD_CURRENT, 1, n, apertura)  != n ||
      CopyHigh (_Symbol, PERIOD_CURRENT, 1, n, high)  != n ||
      CopyLow  (_Symbol, PERIOD_CURRENT, 1, n, low)   != n ||
      CopyClose(_Symbol, PERIOD_CURRENT, 1, n, close) != n)
     { gBarreSaltateDati++; return; }

   double rsi[], smaHigh[], smaLow[], tr[], atr[];
   if(!RsiWilderSerie_Calc(close, n, InpRsiPeriodo, rsi))            { gBarreSaltateDati++; return; }
   if(!SmaSerie_Calc(high, n, InpSmaPeriodo, smaHigh))               { gBarreSaltateDati++; return; }
   if(!SmaSerie_Calc(low,  n, InpSmaPeriodo, smaLow))                { gBarreSaltateDati++; return; }
   if(!TrSerie_Calc(high, low, close, n, tr))                        { gBarreSaltateDati++; return; }
   if(!AtrWilderSerie_Calc(tr, n, LONDONFX_ATR_PERIODO, atr))        { gBarreSaltateDati++; return; }

   int iSeg = n - 1 - gOrizzonteMax;   // la barra di SEGNALE
   int iIng = iSeg + 1;                // la barra d'INGRESSO (L4)
   if(iSeg < InpSmaPeriodo || iIng > n - 1){ gBarreSaltateDati++; return; }

   double chiusura = close[iSeg];
   double sHigh    = smaHigh[iSeg];
   double sLow     = smaLow[iSeg];
   double rsiSeg   = rsi[iSeg];
   double atrSeg   = atr[iSeg];
   double ingresso = apertura[iIng];
   if(!MathIsValidNumber(chiusura) || !MathIsValidNumber(sHigh) || !MathIsValidNumber(sLow) ||
      !MathIsValidNumber(ingresso) || ingresso <= 0.0 || sHigh <= 0.0 || sLow <= 0.0)
     { gBarreSaltateDati++; return; }

   //--- COLLAUDO L1: si confronta con l'RSI di serie di MQL5. Non
   //    decide niente, ma se diverge la traduzione e' sbagliata.
   if(InpConfrontaMT5) AggiornaDivergenze(rsiSeg);

   //--- l'ora della barra di SEGNALE, in ORA SERVER (L3/L9).
   datetime tSeg = iTime(_Symbol, PERIOD_CURRENT, 1 + gOrizzonteMax);
   if(tSeg == 0){ gBarreSaltateDati++; return; }
   MqlDateTime ts; TimeToStruct(tSeg, ts);

   //--- i due lati del canale, indipendenti (L8). Si calcolano PRIMA
   //    del filtro di sessione perche' servono anche a contare i
   //    segnali che la sessione butta via.
   bool canaleL = CanaleLong_Calc (chiusura, sHigh, sLow);
   bool canaleS = CanaleShort_Calc(chiusura, sHigh, sLow);

   //--- FILTRO DI SESSIONE. I segnali caduti fuori NON spariscono: si
   //    contano in colonna (variante NUDA, cosi' il numero resta
   //    invariante fra le due passate dell'ablazione), e la barra non
   //    entra nel denominatore dei giorni (L9).
   if(!SessioneAttiva_Calc(ts.hour, InpOraInizioServer, InpOreSessione))
     {
      if(canaleL) gFuoriSessione++;
      if(canaleS) gFuoriSessione++;
      return;
     }

   gBarreValutate++;

   //--- INVARIANTE DEL CANALE (vedi CanaleLong_Calc): SMA(high) non
   //    puo' stare sotto SMA(low). Se questa colonna non viene 0, il
   //    calcolo del canale e' rotto e nessun altro numero vale.
   if(sHigh < sLow) gCanaleInvertito++;

   //--- il metro di rumore si raccoglie su OGNI barra di sessione,
   //    non sui segnali (L12): cosi' descrive la sessione e resta
   //    invariante fra le due passate dell'ablazione.
   if(atrSeg > 0.0 && MathIsValidNumber(atrSeg)) Aggiungi(gAtrPip, gNAtr, Pip_Calc(atrSeg, InpPipSize));

   //--- L'ABLAZIONE, CONTATA SEMPRE E TUTTA E DUE (L13).
   bool rsiOkL = FiltroRsi_Calc(true, true,  rsiSeg, InpRsiSoglia);
   bool rsiOkS = FiltroRsi_Calc(true, false, rsiSeg, InpRsiSoglia);
   if(canaleL) gNudoLong++;
   if(canaleS) gNudoShort++;
   if(canaleL && rsiOkL) gConRsiLong++;
   if(canaleS && rsiOkS) gConRsiShort++;

   //--- IL SEGNALE VERO, quello che porta le mediane e i cancelli.
   bool sigLong  = canaleL && FiltroRsi_Calc(InpUsaRsi, true,  rsiSeg, InpRsiSoglia);
   bool sigShort = canaleS && FiltroRsi_Calc(InpUsaRsi, false, rsiSeg, InpRsiSoglia);

   //--- contabilita' della giornata (L9)
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
   //    INCLUSA: la posizione e' viva dalla sua apertura, quindi il
   //    range di quella barra conta.
   //    CONSEGUENZA ARITMETICA DA SAPERE: con l'ingresso all'apertura
   //    di iIng, il massimo della finestra e' >= apertura[iIng] e il
   //    minimo e' <= apertura[iIng], quindi MFE e MAE sono >= 0 SEMPRE,
   //    per costruzione. Non c'e' nessun campione da "escludere"
   //    perche' negativo: gli zeri sono zeri veri (nessuno spazio in
   //    quel verso) e restano DENTRO la mediana -- toglierli
   //    gonfierebbe la mediana a favore del candidato.
   double maxBreve = MassimoFinestra_Calc(high, n, iIng, InpBarreOrizzonte);
   double minBreve = MinimoFinestra_Calc (low,  n, iIng, InpBarreOrizzonte);
   double maxLungo = MassimoFinestra_Calc(high, n, iIng, InpBarreOrizzonteLungo);
   double minLungo = MinimoFinestra_Calc (low,  n, iIng, InpBarreOrizzonteLungo);

   if(sigLong)
     {
      gSegnaliLong++;
      gDaySigLong++;
      double mfe  = Pip_Calc(maxBreve - ingresso, InpPipSize);
      double mae  = Pip_Calc(ingresso - minBreve, InpPipSize);
      double mfeL = Pip_Calc(maxLungo - ingresso, InpPipSize);
      double maeL = Pip_Calc(ingresso - minLungo, InpPipSize);
      if(mfe <= 0.0) gMfeZeroLong++;
      if(mae <= 0.0) gMaeZeroLong++;
      Aggiungi(gMfeL,  gNMfeL,  mfe);
      Aggiungi(gMaeL,  gNMaeL,  mae);
      Aggiungi(gMfeLL, gNMfeLL, mfeL);
      Aggiungi(gMaeLL, gNMaeLL, maeL);
      gSommaMfeL += mfe;
      double rr = 0.0;
      if(mae > 0.0){ rr = mfe/mae; Aggiungi(gRrL, gNRrL, rr); }
      ScriviSegnale(tSeg, "LONG", chiusura, sHigh, sLow, rsiSeg, rsiOkL, ingresso, mfe, mae, mfeL, maeL, rr);
     }

   if(sigShort)
     {
      gSegnaliShort++;
      gDaySigShort++;
      double mfe  = Pip_Calc(ingresso - minBreve, InpPipSize);
      double mae  = Pip_Calc(maxBreve - ingresso, InpPipSize);
      double mfeL = Pip_Calc(ingresso - minLungo, InpPipSize);
      double maeL = Pip_Calc(maxLungo - ingresso, InpPipSize);
      if(mfe <= 0.0) gMfeZeroShort++;
      if(mae <= 0.0) gMaeZeroShort++;
      Aggiungi(gMfeS,  gNMfeS,  mfe);
      Aggiungi(gMaeS,  gNMaeS,  mae);
      Aggiungi(gMfeLS, gNMfeLS, mfeL);
      Aggiungi(gMaeLS, gNMaeLS, maeL);
      gSommaMfeS += mfe;
      double rr = 0.0;
      if(mae > 0.0){ rr = mfe/mae; Aggiungi(gRrS, gNRrS, rr); }
      ScriviSegnale(tSeg, "SHORT", chiusura, sHigh, sLow, rsiSeg, rsiOkS, ingresso, mfe, mae, mfeL, maeL, rr);
     }
  }

//+------------------------------------------------------------------+
//| Il confronto con l'RSI di serie di MQL5 (L1). Atteso ~0: le due   |
//| formule sono la stessa. Si legge il buffer alla stessa barra di   |
//| segnale, cioe' allo shift 1 + gOrizzonteMax.                      |
//+------------------------------------------------------------------+
void AggiornaDivergenze(const double rsiMio)
  {
   if(hRsiMt5 == INVALID_HANDLE) return;
   if(rsiMio < 0.0) return;                 // il nostro non e' ancora definito
   double b[1];
   if(CopyBuffer(hRsiMt5, 0, 1 + gOrizzonteMax, 1, b) != 1) return;
   if(!MathIsValidNumber(b[0])) return;
   double d = MathAbs(b[0] - rsiMio);
   if(d > gRsiDivMax) gRsiDivMax = d;
  }

//+------------------------------------------------------------------+
//| Una riga per segnale, cosi' i numeri si possono RICONTARE A MANO  |
//| da un foglio (e' la regola della SondaMediazione). Nessuna        |
//| colonna di ora d'apertura/chiusura: non esistono operazioni.      |
//+------------------------------------------------------------------+
void ScriviSegnale(const datetime t, const string lato, const double chiusura,
                   const double sHigh, const double sLow, const double rsiv,
                   const bool passaRsi, const double ingresso,
                   const double mfe, const double mae,
                   const double mfeLungo, const double maeLungo, const double rr)
  {
   if(gCsvSeg == INVALID_HANDLE) return;
   int dgt = (int)SymbolInfoInteger(_Symbol, SYMBOL_DIGITS);
   FileWrite(gCsvSeg,
             TimeToString(t, TIME_DATE|TIME_MINUTES), lato,
             DoubleToString(chiusura, dgt),
             DoubleToString(sHigh, dgt),
             DoubleToString(sLow, dgt),
             DoubleToString(rsiv, 2),
             (passaRsi ? "1" : "0"),
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
//  variabile con il PROPRIO PREFISSO (b1_, b2_, ...). In MQL5 due
//  dichiarazioni dello stesso nome nello stesso scope sono un errore
//  secco di compilazione, e nessuna rilettura lo vede.
//  IN PIU' RISPETTO ALLO STAMPO: il numero di blocchi eseguiti viene
//  confrontato con LONDONFX_AUTOTEST_BLOCCHI_ATTESI. Un blocco
//  cancellato per sbaglio non deve poter passare per "tutto verde":
//  se il conto non torna, l'autotest si dichiara FALLITO.
//==================================================================
void AutoTestLondonFx()
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
   double b1_c1[]; ArrayResize(b1_c1, 4);
   b1_c1[0]=10.0; b1_c1[1]=11.0; b1_c1[2]=12.0; b1_c1[3]=11.0;
   double b1_r1[];
   bool   b1_ok1 = RsiWilderSerie_Calc(b1_c1, 4, 2, b1_r1);
   double b1_c2[]; ArrayResize(b1_c2, 5);
   b1_c2[0]=10.0; b1_c2[1]=11.0; b1_c2[2]=10.0; b1_c2[3]=11.0; b1_c2[4]=12.0;
   double b1_r2[];
   bool   b1_ok2 = RsiWilderSerie_Calc(b1_c2, 5, 3, b1_r2);
   bool   b1_ko  = RsiWilderSerie_Calc(b1_c1, 2, 6, b1_r1);   // serie piu' corta del periodo -> falso
   if(!b1_ok1 || !b1_ok2 || b1_ko ||
      MathAbs(b1_r1[2] - 100.0)     > 0.0001 ||
      MathAbs(b1_r1[3] -  50.0)     > 0.0001 ||
      MathAbs(b1_r2[3] -  66.66667) > 0.001  ||
      MathAbs(b1_r2[4] -  77.77778) > 0.001  ||
      b1_r2[2] > -0.5)                                   // prima del seme deve valere -1
     { falliti++; Log("[AUTOTEST] 1 RsiWilderSerie_Calc DIVERGE"); }

   //--- BLOCCO 2: il caso degenere dell'RSI, dichiarato in L1.
   blocchi++;
   double b2_su = RsiDaMedie_Calc(1.0, 0.0);    // solo guadagni -> 100
   double b2_pi = RsiDaMedie_Calc(0.0, 0.0);    // mercato piatto -> 50
   double b2_eq = RsiDaMedie_Calc(1.0, 1.0);    // rs = 1 -> 50
   double b2_gi = RsiDaMedie_Calc(0.0, 1.0);    // solo perdite -> 0
   if(MathAbs(b2_su-100.0)>0.0001 || MathAbs(b2_pi-50.0)>0.0001 ||
      MathAbs(b2_eq- 50.0)>0.0001 || MathAbs(b2_gi- 0.0)>0.0001)
     { falliti++; Log("[AUTOTEST] 2 RsiDaMedie_Calc (casi degeneri) DIVERGE"); }

   //--- BLOCCO 3: SMA. periodo 3 su [1,2,3,4,5]: 2, 3, 4.
   //    periodo 1: la SMA e' la serie stessa. n < periodo -> falso.
   blocchi++;
   double b3_s[]; ArrayResize(b3_s, 5);
   b3_s[0]=1.0; b3_s[1]=2.0; b3_s[2]=3.0; b3_s[3]=4.0; b3_s[4]=5.0;
   double b3_m[];
   bool   b3_ok = SmaSerie_Calc(b3_s, 5, 3, b3_m);
   double b3_u[];
   bool   b3_ok1 = SmaSerie_Calc(b3_s, 5, 1, b3_u);
   double b3_v[];
   bool   b3_ko  = SmaSerie_Calc(b3_s, 2, 5, b3_v);
   if(!b3_ok || !b3_ok1 || b3_ko ||
      MathAbs(b3_m[2]-2.0)>0.0001 || MathAbs(b3_m[3]-3.0)>0.0001 || MathAbs(b3_m[4]-4.0)>0.0001 ||
      MathAbs(b3_u[0]-1.0)>0.0001 || MathAbs(b3_u[4]-5.0)>0.0001)
     { falliti++; Log("[AUTOTEST] 3 SmaSerie_Calc DIVERGE"); }

   //--- BLOCCO 4: il canale (Pine righe 25-26), bordi compresi.
   //    I confronti sono STRETTI: una chiusura ESATTAMENTE sulla
   //    media NON e' una rottura.
   blocchi++;
   bool b4_l1 = CanaleLong_Calc (11.0, 10.0, 9.0);   // sopra tutto      -> si
   bool b4_l2 = CanaleLong_Calc (10.0, 10.0, 9.0);   // esattamente sopra -> NO (stretto)
   bool b4_l3 = CanaleLong_Calc ( 9.5, 10.0, 9.0);   // dentro il canale  -> no
   bool b4_s1 = CanaleShort_Calc( 8.0, 10.0, 9.0);   // sotto tutto      -> si
   bool b4_s2 = CanaleShort_Calc( 9.0, 10.0, 9.0);   // esattamente sotto -> NO (stretto)
   bool b4_s3 = CanaleShort_Calc( 9.5, 10.0, 9.0);   // dentro il canale  -> no
   if(!(b4_l1 && !b4_l2 && !b4_l3 && b4_s1 && !b4_s2 && !b4_s3))
     { falliti++; Log("[AUTOTEST] 4 CanaleLong_Calc/CanaleShort_Calc DIVERGONO"); }

   //--- BLOCCO 5: L'INVARIANTE DEL CANALE, e la ridondanza dichiarata
   //    in testa a CanaleLong_Calc. Con high >= low barra per barra,
   //    SMA(high) >= SMA(low) SEMPRE; e allora la seconda meta' della
   //    condizione del Pine non cambia mai l'esito.
   blocchi++;
   double b5_h[]; ArrayResize(b5_h, 5);
   b5_h[0]=10.0; b5_h[1]=12.0; b5_h[2]=11.0; b5_h[3]=13.0; b5_h[4]=14.0;
   double b5_l[]; ArrayResize(b5_l, 5);
   b5_l[0]= 9.0; b5_l[1]=10.0; b5_l[2]=10.0; b5_l[3]=11.0; b5_l[4]=12.0;
   double b5_sh[], b5_sl[];
   bool   b5_o1 = SmaSerie_Calc(b5_h, 5, 3, b5_sh);
   bool   b5_o2 = SmaSerie_Calc(b5_l, 5, 3, b5_sl);
   bool   b5_inv = false;
   if(b5_o1 && b5_o2)   // se le due SMA non sono state calcolate, gli array non esistono: non si legge
      for(int b5_i = 2; b5_i < 5; b5_i++) if(b5_sh[b5_i] < b5_sl[b5_i]) b5_inv = true;
   //    e la ridondanza: sopra la media dei massimi -> canale long vero;
   //    fra le due medie -> falso, esattamente come "close > sma(high)".
   bool b5_r1 = CanaleLong_Calc(11.5, b5_sh[2], b5_sl[2]);   // 11,5 > 11,000 -> si
   bool b5_r2 = CanaleLong_Calc(10.0, b5_sh[2], b5_sl[2]);   // fra 9,667 e 11 -> no
   if(!b5_o1 || !b5_o2 || b5_inv ||
      MathAbs(b5_sh[2]-11.0)>0.0001 || MathAbs(b5_sl[2]-9.666667)>0.001 ||
      !b5_r1 || b5_r2)
     { falliti++; Log("[AUTOTEST] 5 INVARIANTE SMA(high) >= SMA(low) o ridondanza del canale DIVERGE"); }

   //--- BLOCCO 6: la conferma RSI simmetrizzata (L2), compreso il
   //    ramo NUDO dell'ablazione, che deve essere NEUTRO per
   //    costruzione (passa anche con l'RSI non definito).
   blocchi++;
   bool b6_off1 = FiltroRsi_Calc(false, true,  50.0, 80.0);   // spento -> vero
   bool b6_off2 = FiltroRsi_Calc(false, false, -1.0, 80.0);   // spento -> vero anche con RSI non definito
   bool b6_lsi  = FiltroRsi_Calc(true,  true,  81.0, 80.0);   // long: sopra soglia -> si
   bool b6_lbo  = FiltroRsi_Calc(true,  true,  80.0, 80.0);   // long: ESATTA soglia -> no (stretto)
   bool b6_lno  = FiltroRsi_Calc(true,  true,  79.0, 80.0);   // long: sotto -> no
   bool b6_ssi  = FiltroRsi_Calc(true,  false, 19.0, 80.0);   // short: sotto 100-80=20 -> si
   bool b6_sbo  = FiltroRsi_Calc(true,  false, 20.0, 80.0);   // short: ESATTO 20 -> no (stretto)
   bool b6_sno  = FiltroRsi_Calc(true,  false, 21.0, 80.0);   // short: sopra -> no
   bool b6_nd   = FiltroRsi_Calc(true,  true,  -1.0, 80.0);   // RSI non definito -> no
   if(!(b6_off1 && b6_off2 && b6_lsi && !b6_lbo && !b6_lno &&
        b6_ssi && !b6_sbo && !b6_sno && !b6_nd))
     { falliti++; Log("[AUTOTEST] 6 FiltroRsi_Calc DIVERGE"); }

   //--- BLOCCO 7: TRUE RANGE, compresa la prima barra (high-low).
   //    h=[10,11,12] l=[9,10,11] c=[9.5,10.5,11.5]
   //    TR = [1 ; max(1; 1,5; 0,5)=1,5 ; max(1; 1,5; 0,5)=1,5]
   blocchi++;
   double b7_h[]; ArrayResize(b7_h,3); b7_h[0]=10.0; b7_h[1]=11.0; b7_h[2]=12.0;
   double b7_l[]; ArrayResize(b7_l,3); b7_l[0]= 9.0; b7_l[1]=10.0; b7_l[2]=11.0;
   double b7_c[]; ArrayResize(b7_c,3); b7_c[0]= 9.5; b7_c[1]=10.5; b7_c[2]=11.5;
   double b7_tr[];
   bool   b7_ok = TrSerie_Calc(b7_h, b7_l, b7_c, 3, b7_tr);
   if(!b7_ok || MathAbs(b7_tr[0]-1.0)>0.0001 ||
                MathAbs(b7_tr[1]-1.5)>0.0001 || MathAbs(b7_tr[2]-1.5)>0.0001)
     { falliti++; Log("[AUTOTEST] 7 TrSerie_Calc DIVERGE"); }

   //--- BLOCCO 8: ATR di Wilder sullo stesso TR [1; 1,5; 1,5],
   //    periodo 2: seme (1+1,5)/2 = 1,25 ; poi 1,25 + 0,5*(1,5-1,25)
   //    = 1,375. (Con la SMA verrebbe 1,5: e' la differenza gia'
   //    misurata nella SondaM0PB, T3 -- qui NON si usa la SMA.)
   blocchi++;
   double b8_a[];
   bool   b8_ok = AtrWilderSerie_Calc(b7_tr, 3, 2, b8_a);
   double b8_v[];
   bool   b8_ko = AtrWilderSerie_Calc(b7_tr, 1, 2, b8_v);   // n < periodo -> falso
   if(!b8_ok || b8_ko ||
      MathAbs(b8_a[1]-1.25 )>0.0001 || MathAbs(b8_a[2]-1.375)>0.0001)
     { falliti++; Log("[AUTOTEST] 8 AtrWilderSerie_Calc DIVERGE"); }

   //--- BLOCCO 9: le finestre di escursione, compreso il caso in cui
   //    la finestra SBORDA in avanti (si tosa, non si legge fuori).
   blocchi++;
   double b9_v[]; ArrayResize(b9_v, 6);
   b9_v[0]=5.0; b9_v[1]=9.0; b9_v[2]=3.0; b9_v[3]=7.0; b9_v[4]=1.0; b9_v[5]=4.0;
   double b9_max = MassimoFinestra_Calc(b9_v, 6, 1, 3);   // {9;3;7} -> 9
   double b9_min = MinimoFinestra_Calc (b9_v, 6, 1, 3);   // {9;3;7} -> 3
   double b9_sbm = MassimoFinestra_Calc(b9_v, 6, 4, 5);   // sborda: {1;4} -> 4
   double b9_sbn = MinimoFinestra_Calc (b9_v, 6, 4, 5);   // sborda: {1;4} -> 1
   double b9_un  = MassimoFinestra_Calc(b9_v, 6, 3, 1);   // una barra sola -> 7
   double b9_ko1 = MassimoFinestra_Calc(b9_v, 6, 6, 3);   // 'da' fuori range -> 0
   double b9_ko2 = MinimoFinestra_Calc (b9_v, 6, 1, 0);   // quante = 0 -> 0
   if(MathAbs(b9_max-9.0)>0.0001 || MathAbs(b9_min-3.0)>0.0001 ||
      MathAbs(b9_sbm-4.0)>0.0001 || MathAbs(b9_sbn-1.0)>0.0001 ||
      MathAbs(b9_un -7.0)>0.0001 || MathAbs(b9_ko1)>0.0001 || MathAbs(b9_ko2)>0.0001)
     { falliti++; Log("[AUTOTEST] 9 MassimoFinestra_Calc/MinimoFinestra_Calc DIVERGONO"); }

   //--- BLOCCO 10: mediana, dispari / pari / vuota.
   blocchi++;
   double b10_d[]; ArrayResize(b10_d, 5);
   b10_d[0]=1.0; b10_d[1]=2.0; b10_d[2]=3.0; b10_d[3]=10.0; b10_d[4]=100.0;
   double b10_m  = MedianaOrdinata_Calc(b10_d, 5);   // 3
   double b10_p[]; ArrayResize(b10_p, 4);
   b10_p[0]=1.0; b10_p[1]=2.0; b10_p[2]=4.0; b10_p[3]=8.0;
   double b10_mp = MedianaOrdinata_Calc(b10_p, 4);   // (2+4)/2 = 3
   double b10_vu = MedianaOrdinata_Calc(b10_d, 0);   // niente dati -> 0
   if(MathAbs(b10_m-3.0)>0.0001 || MathAbs(b10_mp-3.0)>0.0001 || MathAbs(b10_vu)>0.0001)
     { falliti++; Log("[AUTOTEST] 10 MedianaOrdinata_Calc DIVERGE"); }

   //--- BLOCCO 11: I PIP. I due casi di collaudo SONO la geometria
   //    della fonte letta in L5: 150 tick = 0,00150 = 15,0 pip di
   //    take, 80 tick = 0,00080 = 8,0 pip di stop su un EURUSD a 5
   //    decimali. E lo stesso 15 su un JPY (pip 0,01).
   blocchi++;
   double b11_tp = Pip_Calc(0.00150, 0.0001);   // 15,0
   double b11_sl = Pip_Calc(0.00080, 0.0001);   //  8,0
   double b11_jp = Pip_Calc(0.15000, 0.01);     // 15,0 su USDJPY
   double b11_ne = Pip_Calc(-0.0002, 0.0001);   // -2,0 (il segno passa: e' il chiamante a decidere il verso)
   double b11_ko = Pip_Calc(0.00150, 0.0);      // non convertibile -> 0
   if(MathAbs(b11_tp-15.0)>0.000001 || MathAbs(b11_sl-8.0)>0.000001 ||
      MathAbs(b11_jp-15.0)>0.000001 || MathAbs(b11_ne+2.0)>0.000001 ||
      MathAbs(b11_ko)>0.000001)
     { falliti++; Log("[AUTOTEST] 11 Pip_Calc DIVERGE"); }

   //--- BLOCCO 12: RR da mediane. Il caso di collaudo e' ANCORA la
   //    geometria della fonte: 15 / 8 = 1,875, esattamente il numero
   //    scritto nel criterio F4-bis congelato.
   blocchi++;
   double b12_rr = RrDaMediane_Calc(15.0, 8.0);   // 1,875
   double b12_uu = RrDaMediane_Calc( 4.0, 4.0);   // 1,000
   double b12_ko = RrDaMediane_Calc(15.0, 0.0);   // avversa nulla -> 0
   if(MathAbs(b12_rr-1.875)>0.0001 || MathAbs(b12_uu-1.0)>0.0001 || MathAbs(b12_ko)>0.0001)
     { falliti++; Log("[AUTOTEST] 12 RrDaMediane_Calc DIVERGE"); }

   //--- BLOCCO 13: L'ARITMETICA DEL CANCELLO H8 CONTRO LA TABELLA
   //    CONGELATA NELLA BOZZA (criterio F4-bis), tutti e SEI i
   //    valori. Non e' un test di comodo: se questa formula si muove,
   //    si muove il cancello.
   blocchi++;
   double b13_a = WinRateNecessario_Calc(0.360, LONDONFX_E_TARGET_R);   // 0,790
   double b13_b = WinRateNecessario_Calc(0.730, LONDONFX_E_TARGET_R);   // 0,622
   double b13_c = WinRateNecessario_Calc(1.000, LONDONFX_E_TARGET_R);   // 0,538
   double b13_d = WinRateNecessario_Calc(1.420, LONDONFX_E_TARGET_R);   // 0,444
   double b13_e = WinRateNecessario_Calc(1.560, LONDONFX_E_TARGET_R);   // 0,420
   double b13_f = WinRateNecessario_Calc(1.875, LONDONFX_E_TARGET_R);   // 0,374 <- la geometria della fonte
   if(MathAbs(b13_a-0.790)>0.001 || MathAbs(b13_b-0.622)>0.001 ||
      MathAbs(b13_c-0.538)>0.001 || MathAbs(b13_d-0.444)>0.001 ||
      MathAbs(b13_e-0.420)>0.001 || MathAbs(b13_f-0.374)>0.001)
     { falliti++; Log("[AUTOTEST] 13 WinRateNecessario_Calc NON riproduce la tabella congelata della bozza"); }

   //--- BLOCCO 14: la sessione. Inizio incluso, FINE ESCLUSA come in
   //    Pine, piu' il caso a cavallo della mezzanotte e gli input
   //    impossibili.
   blocchi++;
   bool b14_in  = SessioneAttiva_Calc( 8,  8, 8);   // bordo iniziale INCLUSO
   bool b14_dn  = SessioneAttiva_Calc(15,  8, 8);   // ultima ora dentro
   bool b14_fu  = SessioneAttiva_Calc(16,  8, 8);   // fine ESCLUSA -> fuori
   bool b14_pr  = SessioneAttiva_Calc( 7,  8, 8);   // prima -> fuori
   bool b14_u1  = SessioneAttiva_Calc( 4,  4, 8);   // lettura UTC: bordo
   bool b14_u2  = SessioneAttiva_Calc(12,  4, 8);   // lettura UTC: fine esclusa
   bool b14_w1  = SessioneAttiva_Calc(23, 22, 5);   // a cavallo: dentro
   bool b14_w2  = SessioneAttiva_Calc( 2, 22, 5);   // a cavallo: dentro (22,23,0,1,2? fine=27-24=3 escl.)
   bool b14_w3  = SessioneAttiva_Calc( 3, 22, 5);   // a cavallo: fine esclusa -> fuori
   bool b14_t   = SessioneAttiva_Calc(13,  0, 24);  // 24 ore -> sempre dentro
   bool b14_k1  = SessioneAttiva_Calc(24,  8, 8);   // ora impossibile
   bool b14_k2  = SessioneAttiva_Calc( 8,  8, 0);   // durata impossibile
   if(!(b14_in && b14_dn && !b14_fu && !b14_pr && b14_u1 && !b14_u2 &&
        b14_w1 && b14_w2 && !b14_w3 && b14_t && !b14_k1 && !b14_k2))
     { falliti++; Log("[AUTOTEST] 14 SessioneAttiva_Calc DIVERGE"); }

   //--- BLOCCO 15: IL PIP CHE IL SIMBOLO SI ASPETTA (difesa (b) di
   //    L5). E' l'equivalente forex della colonna "Punto Indice
   //    Prezzo" = 1,00 della SondaM0PB.
   blocchi++;
   double b15_e5 = PipAttesoDaDigits_Calc(0.00001, 5);   // EURUSD moderno -> 0,0001
   double b15_e4 = PipAttesoDaDigits_Calc(0.0001,  4);   // EURUSD vecchio -> 0,0001
   double b15_j3 = PipAttesoDaDigits_Calc(0.001,   3);   // USDJPY moderno -> 0,01
   double b15_j2 = PipAttesoDaDigits_Calc(0.01,    2);   // USDJPY vecchio -> 0,01
   double b15_ko = PipAttesoDaDigits_Calc(0.0,     5);   // POINT nullo -> 0
   if(MathAbs(b15_e5-0.0001)>0.0000001 || MathAbs(b15_e4-0.0001)>0.0000001 ||
      MathAbs(b15_j3-0.01)  >0.0000001 || MathAbs(b15_j2-0.01)  >0.0000001 ||
      MathAbs(b15_ko)       >0.0000001)
     { falliti++; Log("[AUTOTEST] 15 PipAttesoDaDigits_Calc DIVERGE"); }

   //--- BLOCCO 16: I VERDETTI, ESEGUITI SU UNA CELLA DI OGNI FASCIA.
   //    E' la terza meta' della regola della checklist del 31/08: il
   //    gate che ricopia le SOGLIE ma non le DISUGUAGLIANZE non si
   //    accorge di niente. Qui si esercita OGNI fascia, bordi
   //    compresi, e in particolare la fascia [3,0 ; 6,0] che nella
   //    bozza era coperta da DUE bullet e qui e' sciolta verso la
   //    clausola PIU' SEVERA (SOSPESO, non PASSA).
   blocchi++;
   string b16_f1a = VerdettoF1_Calc(0.99);   // MORTO F1
   string b16_f1b = VerdettoF1_Calc(1.00);   // PASSA AL MINIMO (bordo)
   string b16_f1c = VerdettoF1_Calc(2.00);   // PASSA AL MINIMO (bordo alto)
   string b16_f1d = VerdettoF1_Calc(2.01);   // PASSA
   string b16_f2a = VerdettoF2_Calc(2.99);   // MORTO F2
   string b16_f2b = VerdettoF2_Calc(3.00);   // SOSPESO (bordo basso della fascia contesa)
   string b16_f2c = VerdettoF2_Calc(4.50);   // SOSPESO (centro della fascia contesa)
   string b16_f2d = VerdettoF2_Calc(6.00);   // SOSPESO (bordo alto: severita')
   string b16_f2e = VerdettoF2_Calc(6.01);   // PASSA F2
   string b16_h8a = VerdettoH8_Calc(0.69);   // MORTO H8
   string b16_h8b = VerdettoH8_Calc(0.70);   // PASSA H8 (bordo)
   if(b16_f1a != "MORTO F1" || b16_f1b != "PASSA AL MINIMO" ||
      b16_f1c != "PASSA AL MINIMO" || b16_f1d != "PASSA" ||
      b16_f2a != "MORTO F2" ||
      b16_f2b != "SOSPESO F2 - serve lo spread VERO" ||
      b16_f2c != "SOSPESO F2 - serve lo spread VERO" ||
      b16_f2d != "SOSPESO F2 - serve lo spread VERO" ||
      b16_f2e != "PASSA F2" ||
      b16_h8a != "MORTO H8 PER ARITMETICA" || b16_h8b != "PASSA H8")
     { falliti++; Log("[AUTOTEST] 16 I VERDETTI F1/F2/H8 NON rispettano le fasce congelate"); }

   //--- IL CONTROLLO SUL CONTROLLO: i blocchi eseguiti devono essere
   //    quelli attesi. Un blocco cancellato per sbaglio non deve
   //    poter passare per "tutto verde".
   if(blocchi != LONDONFX_AUTOTEST_BLOCCHI_ATTESI)
     {
      falliti++;
      Log(StringFormat("[AUTOTEST] eseguiti %d blocchi ma ne erano attesi %d: MANCA UN BLOCCO. L'autotest si dichiara FALLITO.",
                       blocchi, LONDONFX_AUTOTEST_BLOCCHI_ATTESI));
     }

   gAutotestFalliti = falliti;
   gAutotestBlocchi = blocchi;
   Log(StringFormat("AUTOTEST: %d BLOCCHI SU %d PASSATI (falliti %d, attesi %d). L'esito VERO esce nelle colonne 'Autotest Falliti' e 'Autotest Blocchi': in ottimizzazione questa riga non la legge nessuno.",
                    blocchi - falliti, blocchi, falliti, LONDONFX_AUTOTEST_BLOCCHI_ATTESI));
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
void StampaLato(const string lato, const double sigGiorno, const double mfeMed,
                const double maeMed, const double rr, const long segnali,
                const long nudo, const long conRsi, const long maxGiorno,
                const long g1, const long g2, const double mfeLungoMed,
                const double maeLungoMed, const double mfeMedio,
                const long mfeZero, const long maeZero)
  {
   Print("--------------------------------------------------------------");
   PrintFormat("[LONDONFX-SONDA] ===== LATO %s =====", lato);
   PrintFormat("   1. segnali/giorno      : %.3f   (segnali %d)   %s",
               sigGiorno, (int)segnali, VerdettoF1_Calc(sigGiorno));
   PrintFormat("   1-bis. ABLAZIONE RSI   : canale NUDO %d  ->  canale + RSI %d   (l'autore la dichiara OPZIONALE; questa corsa usa %s)",
               (int)nudo, (int)conRsi, (InpUsaRsi ? "CON RSI" : "NUDO"));
   PrintFormat("   2. MFE MEDIANA a %d barre: %.2f pip   %s",
               InpBarreOrizzonte, mfeMed, VerdettoF2_Calc(mfeMed));
   PrintFormat("      MFE media           : %.2f pip   (accanto alla mediana dice l'asimmetria)   MFE nulle: %d",
               mfeMedio, (int)mfeZero);
   PrintFormat("   3. MAE MEDIANA a %d barre: %.2f pip   (nessun cancello: dice se lo stop da 8 pip della fonte sta sopra o sotto il rumore)   MAE nulle: %d",
               InpBarreOrizzonte, maeMed, (int)maeZero);
   PrintFormat("   4. RR MEDIANO (2/3)    : %.3f   %s",
               rr, VerdettoH8_Calc(rr));
   PrintFormat("      win rate NECESSARIO per E >= %.3fR : %.1f%%",
               LONDONFX_E_TARGET_R, 100.0*WinRateNecessario_Calc(rr, LONDONFX_E_TARGET_R));
   PrintFormat("   5. MASSIMO in un giorno: %d   (muro giornaliero: e' da qui che si taglia InpMaxTradesPerDay dell'EA futuro)",
               (int)maxGiorno);
   PrintFormat("      giorni con >= 1      : %d      giorni con >= 2 : %d   (pavimento di Claudio: 1-2 al giorno)",
               (int)g1, (int)g2);
   PrintFormat("   ORIZZONTE LUNGO (%d barre, INFORMATIVO, nessun cancello): MFE mediana %.2f pip | MAE mediana %.2f pip | RR %.3f",
               InpBarreOrizzonteLungo, mfeLungoMed, maeLungoMed,
               RrDaMediane_Calc(mfeLungoMed, maeLungoMed));
   PrintFormat("      (e' l'orizzonte che PUO' contenere il take da 15,0 pip della fonte: quello a %d barre quasi certamente no -- vedi L7)",
               InpBarreOrizzonte);
  }

double OnTester()
  {
   //--- l'ultima giornata va chiusa a mano: nessuna barra nuova la
   //    chiudera' piu'.
   ChiudiGiornata();
   gDayStamp = -1;

   double mfeMedL  = Mediana(gMfeL,  gNMfeL);
   double mfeMedS  = Mediana(gMfeS,  gNMfeS);
   double maeMedL  = Mediana(gMaeL,  gNMaeL);
   double maeMedS  = Mediana(gMaeS,  gNMaeS);
   double mfeLunL  = Mediana(gMfeLL, gNMfeLL);
   double mfeLunS  = Mediana(gMfeLS, gNMfeLS);
   double maeLunL  = Mediana(gMaeLL, gNMaeLL);
   double maeLunS  = Mediana(gMaeLS, gNMaeLS);
   double rrMedL   = RrDaMediane_Calc(mfeMedL, maeMedL);
   double rrMedS   = RrDaMediane_Calc(mfeMedS, maeMedS);
   double rrSegL   = Mediana(gRrL, gNRrL);
   double rrSegS   = Mediana(gRrS, gNRrS);
   double atrMed   = Mediana(gAtrPip, gNAtr);

   double gg      = (gGiorniContati > 0) ? (double)gGiorniContati : 0.0;
   double sigGgL  = (gg > 0.0) ? (double)gSegnaliLong /gg : 0.0;
   double sigGgS  = (gg > 0.0) ? (double)gSegnaliShort/gg : 0.0;
   double sigGgT  = (gg > 0.0) ? (double)(gSegnaliLong + gSegnaliShort)/gg : 0.0;
   double mfeAvgL = (gNMfeL > 0) ? gSommaMfeL/(double)gNMfeL : 0.0;
   double mfeAvgS = (gNMfeS > 0) ? gSommaMfeS/(double)gNMfeS : 0.0;
   double punto   = SymbolInfoDouble(_Symbol, SYMBOL_POINT);
   double pipPti  = (punto > 0.0) ? InpPipSize/punto : 0.0;

   //--- REFERTO A SCHERMO (corsa singola). In ottimizzazione non lo
   //    legge nessuno: per quello ci sono le colonne qui sotto.
   Print("==============================================================");
   PrintFormat("[LONDONFX-SONDA] CONTATORE LONDONFX su %s %s - etichetta '%s'. NESSUN ORDINE APERTO.",
               _Symbol, EnumToString((ENUM_TIMEFRAMES)Period()), InpTag);
   PrintFormat("   sessione %02d:00-%02d:00 ORA SERVER (fine esclusa) | RSI %s | orizzonti %d e %d barre | ritardo di misura %d barre",
               InpOraInizioServer, (InpOraInizioServer + InpOreSessione)%24,
               (InpUsaRsi ? "ACCESO" : "SPENTO"), InpBarreOrizzonte, InpBarreOrizzonteLungo, gOrizzonteMax);
   PrintFormat("   barre di sessione valutate %d | barre saltate per dati %d | giorni contati %d | rotture di canale fuori sessione %d",
               (int)gBarreValutate, (int)gBarreSaltateDati, (int)gGiorniContati, (int)gFuoriSessione);
   PrintFormat("   ATR(%d) mediano di sessione %.2f pip -> lo stop da 8,0 pip della fonte vale %.2f ATR (metro di casa, NON viene dal Pine: vedi L12)",
               LONDONFX_ATR_PERIODO, atrMed, (atrMed > 0.0 ? 8.0/atrMed : 0.0));
   PrintFormat("   collaudo traduzione: scarto MAX contro iRSI = %.8f (atteso ~0, vedi L1) | pip = %.5f in prezzo = %.1f punti MT5 (vedi L5)",
               gRsiDivMax, InpPipSize, pipPti);
   if(gCanaleInvertito > 0)
      PrintFormat("   >>> ALLARME: SMA(high) < SMA(low) su %d barre. E' IMPOSSIBILE: il canale e' calcolato male e NESSUN numero di questa corsa vale.", (int)gCanaleInvertito);
   if(gTroncato)
      Print("   >>> ATTENZIONE: uno dei vettori di campioni (escursioni dei segnali OPPURE ATR di sessione) ha toccato il tetto di 100.000: LE MEDIANE POSSONO ESSERE TRONCATE e vanno considerate NON VALIDE finche' non si e' guardato quale vettore. Rifare con una finestra piu' corta.");

   StampaLato("LONG",  sigGgL, mfeMedL, maeMedL, rrMedL, gSegnaliLong,
              gNudoLong, gConRsiLong, gMaxGiornoLong, gG1Long, gG2Long,
              mfeLunL, maeLunL, mfeAvgL, gMfeZeroLong, gMaeZeroLong);
   StampaLato("SHORT", sigGgS, mfeMedS, maeMedS, rrMedS, gSegnaliShort,
              gNudoShort, gConRsiShort, gMaxGiornoShort, gG1Short, gG2Short,
              mfeLunS, maeLunS, mfeAvgS, gMfeZeroShort, gMaeZeroShort);

   Print("--------------------------------------------------------------");
   PrintFormat("[LONDONFX-SONDA] i DUE LATI insieme (solo per il MURO GIORNALIERO, MAI per il merito): %.3f segnali/giorno, massimo %d in un giorno, giorni con >=1 %d, con >=2 %d, giorni a zero %d",
               sigGgT, (int)gMaxGiornoTot, (int)gG1Tot, (int)gG2Tot, (int)gGiorniZero);
   PrintFormat("[LONDONFX-SONDA] promemoria prop (criterio F4): %d segnali x 0,65%% = %.2f%% di rischio aperto contro il cap C1 di 3,25%% firmato il 18/08.",
               (int)gMaxGiornoTot, 0.65*(double)gMaxGiornoTot);
   Print("[LONDONFX-SONDA] questa corsa NON promuove niente e NON dice se il motore guadagna: e' un conteggio. Il merito si misura a tick, dopo, e solo se questi numeri reggono.");
   Print("==============================================================");

   //--- ATTENZIONE: 'stats', l'header di OnTesterDeinit e il suo
   //    StringFormat SI TOCCANO SEMPRE INSIEME. Una colonna aggiunta a
   //    uno solo dei tre sfasa tutto il CSV e chi legge trova il numero
   //    sbagliato sotto il nome giusto.
   //    CONTEGGIO CONGELATO: 55 valori -> 58 nomi (Pass, Simbolo,
   //    Periodo + 55) -> 58 specificatori -> 58 argomenti.
   //    E il margine e' dichiarato: StringFormat riceve 1 formato + 58
   //    argomenti = 59 parametri, contro il tetto di 64 di MQL5.
   //    AGGIUNGERE PIU' DI CINQUE COLONNE QUI OBBLIGA A SPEZZARE LA
   //    RIGA IN DUE StringFormat. Sta scritto perche' e' il genere di
   //    muro che si scopre a compilazione fallita.
   double stats[55];
   stats[0]  = (double)gSegnaliLong;      // il lato VERO (secondo InpUsaRsi)
   stats[1]  = (double)gSegnaliShort;
   stats[2]  = (double)gNudoLong;         // ablazione F1-bis: canale nudo  (INVARIANTE sull'asse)
   stats[3]  = (double)gNudoShort;
   stats[4]  = (double)gConRsiLong;       // ablazione F1-bis: canale + RSI (INVARIANTE sull'asse)
   stats[5]  = (double)gConRsiShort;
   stats[6]  = (double)gGiorniContati;
   stats[7]  = sigGgL;                    // CRITERIO F1, LONG
   stats[8]  = sigGgS;                    // CRITERIO F1, SHORT
   stats[9]  = sigGgT;                    // solo muro giornaliero, MAI merito
   stats[10] = mfeMedL;                   // CRITERIO F2, LONG
   stats[11] = mfeMedS;                   // CRITERIO F2, SHORT
   stats[12] = maeMedL;                   // CRITERIO F3, LONG
   stats[13] = maeMedS;                   // CRITERIO F3, SHORT
   stats[14] = rrMedL;                    // CANCELLO H8, LONG = 2/3
   stats[15] = rrMedS;                    // CANCELLO H8, SHORT = 2/3
   stats[16] = rrSegL;                    // mediana dei rapporti: NON e' il cancello
   stats[17] = rrSegS;
   stats[18] = 100.0*WinRateNecessario_Calc(rrMedL, LONDONFX_E_TARGET_R);
   stats[19] = 100.0*WinRateNecessario_Calc(rrMedS, LONDONFX_E_TARGET_R);
   stats[20] = (double)gMaxGiornoLong;    // CRITERIO F4
   stats[21] = (double)gMaxGiornoShort;
   stats[22] = (double)gMaxGiornoTot;
   stats[23] = (double)gG1Long;
   stats[24] = (double)gG2Long;
   stats[25] = (double)gG1Short;
   stats[26] = (double)gG2Short;
   stats[27] = (double)gG1Tot;
   stats[28] = (double)gG2Tot;
   stats[29] = (double)gGiorniZero;
   stats[30] = mfeAvgL;
   stats[31] = mfeAvgS;
   stats[32] = mfeLunL;                   // orizzonte lungo: informativo (L7)
   stats[33] = mfeLunS;
   stats[34] = maeLunL;
   stats[35] = maeLunS;
   stats[36] = (double)gMfeZeroLong;
   stats[37] = (double)gMfeZeroShort;
   stats[38] = (double)gMaeZeroLong;
   stats[39] = (double)gMaeZeroShort;
   stats[40] = atrMed;                    // metro di rumore (L12)
   stats[41] = (double)gBarreValutate;
   stats[42] = (double)gBarreSaltateDati;
   stats[43] = (double)gFuoriSessione;
   stats[44] = gRsiDivMax;                // collaudo L1: atteso ~0
   stats[45] = InpPipSize;                // eco L5: 0,00010 su EURUSD/GBPUSD
   stats[46] = pipPti;                    // eco L5: 10 su un simbolo a 5/3 decimali
   stats[47] = (double)gCanaleInvertito;  // INVARIANTE: atteso 0
   stats[48] = (InpUsaRsi ? 1.0 : 0.0);   // eco dell'asse dell'ablazione
   stats[49] = (double)InpOraInizioServer;// eco dell'asse dell'ora
   stats[50] = (double)InpOreSessione;
   stats[51] = (double)InpBarreOrizzonte;
   stats[52] = (double)InpBarreOrizzonteLungo;
   stats[53] = (double)gAutotestFalliti;  // 0 = tutti passati; >0 DIVERGE; -1 non eseguito
   stats[54] = (double)gAutotestBlocchi;

   if(InpScriviCsv && !MQLInfoInteger(MQL_OPTIMIZATION)) ScriviCsvTotali(stats);

   //--- MT5 vuole un criterio di ottimizzazione. Qui NON si sceglie
   //    niente e NESSUNA CELLA VIENE PROMOSSA: si dichiara il numero
   //    di segnali totali, che e' cio' che la sonda conta. Leggerlo
   //    per sbaglio come "il migliore" vorrebbe dire "quello che ha
   //    contato di piu'", che non e' un merito -- e su questi due
   //    assi vincerebbe SEMPRE la passata con l'RSI SPENTO, che e' il
   //    ramo di controllo dell'ablazione, non un candidato.
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
   string f = StringFormat("ABTG_SondaLondonFx_%s_%s_totali.csv", _Symbol, EnumToString((ENUM_TIMEFRAMES)Period()));
   int h = FileOpen(f, FILE_WRITE|FILE_CSV|FILE_ANSI, ";");
   if(h == INVALID_HANDLE)
     { Log(StringFormat("CSV totali non scritto (err %d).", GetLastError())); return; }

   FileWrite(h, "criterio", "grandezza", "LONG", "SHORT", "cancello");
   FileWrite(h, "F1", "segnali al giorno", DoubleToString(s[7], 3), DoubleToString(s[8], 3),
             StringFormat(">= %.2f, altrimenti SCARTO", LONDONFX_SOGLIA_SEGNALI_GIORNO));
   FileWrite(h, "F1-bis", "ablazione: segnali canale NUDO", DoubleToString(s[2], 0), DoubleToString(s[3], 0),
             "nessun cancello: e' il confronto");
   FileWrite(h, "F1-bis", "ablazione: segnali canale + RSI", DoubleToString(s[4], 0), DoubleToString(s[5], 0),
             "se scende sotto 1/giorno, l'RSI uccide il pavimento");
   FileWrite(h, "F2", "MFE mediana pip (orizzonte corto)", DoubleToString(s[10], 3), DoubleToString(s[11], 3),
             StringFormat("< %.1f SCARTO | %.1f-%.1f SOSPESO | > %.1f PASSA",
                          LONDONFX_SOGLIA_MFE_SCARTO, LONDONFX_SOGLIA_MFE_SCARTO,
                          LONDONFX_SOGLIA_MFE_PASSA, LONDONFX_SOGLIA_MFE_PASSA));
   FileWrite(h, "F2", "verdetto calcolato", VerdettoF2_Calc(s[10]), VerdettoF2_Calc(s[11]),
             "fascia contesa sciolta verso la clausola PIU' SEVERA");
   FileWrite(h, "F3", "MAE mediana pip (orizzonte corto)", DoubleToString(s[12], 3), DoubleToString(s[13], 3),
             "nessun cancello: da leggere sempre");
   FileWrite(h, "H8", "RR mediano = F2/F3", DoubleToString(s[14], 4), DoubleToString(s[15], 4),
             StringFormat(">= %.2f, altrimenti SCARTO PER ARITMETICA", LONDONFX_SOGLIA_RR));
   FileWrite(h, "H8", "win rate necessario % per E >= 0,075R", DoubleToString(s[18], 2), DoubleToString(s[19], 2),
             "tabella congelata nella bozza, criterio F4-bis");
   FileWrite(h, "F4", "massimo segnali in un giorno", DoubleToString(s[20], 0), DoubleToString(s[21], 0),
             "muro giornaliero prop: taglia InpMaxTradesPerDay sui dati");
   FileWrite(h, "-", "segnali totali (lato VERO)", DoubleToString(s[0], 0), DoubleToString(s[1], 0), "");
   FileWrite(h, "-", "giorni con almeno 1 segnale", DoubleToString(s[23], 0), DoubleToString(s[25], 0),
             "pavimento di Claudio: 1-2 al giorno");
   FileWrite(h, "-", "giorni con almeno 2 segnali", DoubleToString(s[24], 0), DoubleToString(s[26], 0), "");
   FileWrite(h, "-", "MFE media pip", DoubleToString(s[30], 3), DoubleToString(s[31], 3),
             "accanto alla mediana dice l'asimmetria");
   FileWrite(h, "L7", "MFE mediana pip (orizzonte LUNGO)", DoubleToString(s[32], 3), DoubleToString(s[33], 3),
             "informativo: e' l'orizzonte che PUO' contenere i 15,0 pip della fonte");
   FileWrite(h, "L7", "MAE mediana pip (orizzonte LUNGO)", DoubleToString(s[34], 3), DoubleToString(s[35], 3),
             "informativo, nessun cancello");
   FileWrite(h, "-", "MFE nulle / MAE nulle", DoubleToString(s[36], 0) + " / " + DoubleToString(s[38], 0),
             DoubleToString(s[37], 0) + " / " + DoubleToString(s[39], 0),
             "contate e TENUTE dentro la mediana: uno zero e' un fatto");
   FileWrite(h, "-", "RR mediano per segnale", DoubleToString(s[16], 4), DoubleToString(s[17], 4),
             "NON e' il cancello: il cancello e' F2/F3");
   FileWrite(h, "-", "giorni contati", DoubleToString(s[6], 0), "", "L9");
   FileWrite(h, "-", "giorni a zero segnali (due lati)", DoubleToString(s[29], 0), "", "");
   FileWrite(h, "-", "ATR mediano di sessione pip", DoubleToString(s[40], 4), "",
             "metro di rumore di casa, NON viene dal Pine (L12)");
   FileWrite(h, "-", "barre di sessione valutate", DoubleToString(s[41], 0), "", "");
   FileWrite(h, "-", "barre saltate per dati", DoubleToString(s[42], 0), "", "deve essere ~0");
   FileWrite(h, "-", "rotture di canale fuori sessione", DoubleToString(s[43], 0), "",
             "variante NUDA: resta invariante sull'asse dell'RSI");
   FileWrite(h, "-", "scarto max contro iRSI", DoubleToString(s[44], 8), "", "collaudo L1: atteso ~0");
   FileWrite(h, "-", "pip in prezzo / in punti MT5", DoubleToString(s[45], 5), DoubleToString(s[46], 2),
             "L5: 0,00010 e 10,00 su EURUSD/GBPUSD a 5 decimali");
   FileWrite(h, "-", "canale invertito (SMA high < SMA low)", DoubleToString(s[47], 0), "",
             "INVARIANTE: deve essere 0, altrimenti niente vale");
   FileWrite(h, "-", "autotest falliti su blocchi", DoubleToString(s[53], 0), DoubleToString(s[54], 0),
             StringFormat("0 falliti su %d = passato; -1 = NON eseguito", LONDONFX_AUTOTEST_BLOCCHI_ATTESI));
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
         //--- 58 nomi = Pass + Simbolo + Periodo + 55 valori di stats[].
         string head = "Pass,Simbolo,Periodo,Segnali Long,Segnali Short,Segnali Nudo Long,Segnali Nudo Short,Segnali Con Rsi Long,Segnali Con Rsi Short,Giorni Contati,Segnali Long Al Giorno,Segnali Short Al Giorno,Segnali Totali Al Giorno,Mfe Mediano Long Pip,Mfe Mediano Short Pip,Mae Mediano Long Pip,Mae Mediano Short Pip,RR Da Mediane Long,RR Da Mediane Short,RR Mediano Per Segnale Long,RR Mediano Per Segnale Short,Win Rate Necessario Long Pct,Win Rate Necessario Short Pct,Max Segnali Giorno Long,Max Segnali Giorno Short,Max Segnali Giorno Totale,Giorni Almeno 1 Long,Giorni Almeno 2 Long,Giorni Almeno 1 Short,Giorni Almeno 2 Short,Giorni Almeno 1 Totale,Giorni Almeno 2 Totale,Giorni Zero Segnali,Mfe Medio Long Pip,Mfe Medio Short Pip,Mfe Lungo Mediano Long Pip,Mfe Lungo Mediano Short Pip,Mae Lungo Mediano Long Pip,Mae Lungo Mediano Short Pip,Mfe Zero Long,Mfe Zero Short,Mae Zero Long,Mae Zero Short,Atr Mediano Pip,Barre Valutate,Barre Saltate Dati,Segnali Fuori Sessione,Rsi Divergenza Max,Pip Size Prezzo,Pip In Punti Mt5,Canale Invertito,Usa Rsi,Ora Inizio Server,Ore Sessione,Barre Orizzonte,Barre Orizzonte Lungo,Autotest Falliti,Autotest Blocchi";
         for(uint i = 0; i < pcount; i++)
           { string kv[]; if(StringSplit(params[i], '=', kv) == 2) head += "," + kv[0]; }
         FileWrite(h, head); header_scritto = true;
        }
      //--- 58 specificatori = 58 argomenti (pass, simbolo, periodo, data[0..54]).
      string row = StringFormat("%d,%s,%s,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.3f,%.3f,%.3f,%.3f,%.3f,%.3f,%.3f,%.4f,%.4f,%.4f,%.4f,%.2f,%.2f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.3f,%.3f,%.3f,%.3f,%.3f,%.3f,%.0f,%.0f,%.0f,%.0f,%.4f,%.0f,%.0f,%.0f,%.8f,%.5f,%.2f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f",
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
                                data[54]);
      for(uint i = 0; i < pcount; i++)
        { string kv[]; if(StringSplit(params[i], '=', kv) == 2) row += "," + kv[1]; }
      FileWrite(h, row); righe++;
     }
   FileClose(h);
   PrintFormat("OptFrame: scritte %d passate in MQL5\\Files\\%s", righe, fname);
  }
//================== fine OPTFRAME inlined ==========================//
