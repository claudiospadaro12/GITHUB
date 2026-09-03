//+------------------------------------------------------------------+
//|                                        ABTG_SondaRelativo.mq5     |
//|                                                                  |
//|  LA SONDA DI CONVERGENZA DEL CANDIDATO "RELATIVO" -- E' UN        |
//|  CONTATORE, NON UN EA. PASSO 0 del promosso (8/10) della QUARTA   |
//|  BATTUTA della caccia-frequenza del 02/09/2026.                   |
//|                                                                  |
//|  ==============================================================  |
//|  QUESTO FILE NON APRE ORDINI. MAI. NEMMENO NEL TESTER.            |
//|  Non esiste #include <Trade/Trade.mqh>, non esiste nessun         |
//|  CTrade, non esiste nessun invio d'ordine, nessuna chiusura di    |
//|  posizione, nessun calcolo di lotto, nessun calcolo di rischio,   |
//|  nessun magic number (un magic serve a riconoscere ORDINI PROPRI: |
//|  qui non ce ne sono). L'identificatore della corsa e' InpTag, che |
//|  e' una ETICHETTA per i file e per il log, non un magic.          |
//|  Le "posizioni" di cui parla questo sorgente sono FINTE: sono     |
//|  variabili in memoria che servono a misurare escursioni e tenuta. |
//|  LA RIGA DI GREP CHE LO DIMOSTRA STA NEL REFERTO, NON QUI, ED E'  |
//|  VOLUTO: scriverne il modello dentro il file lo farebbe           |
//|  combaciare CON SE STESSO e il controllo tornerebbe sempre        |
//|  sporco (lezione gia' pagata sulla prima stesura di               |
//|  ABTG_SondaM0PB).                                                 |
//|  ==============================================================  |
//|                                                                  |
//|  CHASSIS DI CASA, riusato riga per riga come pattern:             |
//|    mql5\Experts\ABTG_SondaM0PB.mq5     (contatore + OPTFRAME)     |
//|    mql5\Experts\ABTG_SondaRsiEmaV8.mq5 (autotest a blocchi)       |
//|  Da li' vengono: il nucleo puro interrogabile a tavolino,         |
//|  l'autotest contato in COLONNA, FrameAdd/OPTFRAME in OnTester,    |
//|  il CSV da OnTesterDeinit, le colonne di eco e di collaudo.       |
//|                                                                  |
//|  >>> LA DIFFERENZA STRUTTURALE CON OGNI ALTRA SONDA DI CASA <<<   |
//|  QUESTA LEGGE DUE SIMBOLI. Il simbolo del grafico (quello che     |
//|  SI SCAMBIA, la gamba) e un SECONDO simbolo che si LEGGE e basta  |
//|  (il METRO). Tutta la parte fragile del file sta li', non nella   |
//|  formula: vedi T1, T2, T3 e le sette colonne di sincronizzazione. |
//|                                                                  |
//|  ------------------------------------------------------------    |
//|  ORIGINE E ATTRIBUZIONE -- E IL PUNTO DI LICENZA, DICHIARATO      |
//|  ------------------------------------------------------------    |
//|  Il MOTORE (rapporto fra due simboli -> scarto dalla media        |
//|  mobile -> normalizzazione a z-score -> due soglie simmetriche    |
//|  -> uscita per convergenza) e' derivato dalla LETTURA di:         |
//|                                                                  |
//|   1) "Pair Trade" (c) vladimirkovalchuk / @wa1one                 |
//|      https://www.tradingview.com/script/ru23VN0C/                 |
//|      Pine v4, 40 righe, access=1, created 2022-01-15              |
//|   2) "Unilateral Pairs Trading" (c) @pietro3334                   |
//|      https://www.tradingview.com/script/MD5vkc0n/                 |
//|      Pine v4, 78 righe, access=1, created 2022-01-06              |
//|   3) "Statistical Arbitrage Pairs Trading - Long-Side Only"       |
//|      (c) @piirsalu                                                |
//|      https://www.tradingview.com/script/Kt6XkQIM/                 |
//|      Pine v5, 97 righe, access=1, created 2025-01-30              |
//|      (da qui SOLO la normalizzazione robusta mediana/MAD)         |
//|   4) CONFERMA INDIPENDENTE DEL MECCANISMO su MT5 e su INDICI      |
//|      (indicatore, non EA: NON e' la fonte del codice)             |
//|      m4rk-lewis/price_action_analytics (GitHub)                   |
//|                                                                  |
//|  LICENZA: (1), (2) e (3) NON DICHIARANO NESSUNA LICENZA nel       |
//|  sorgente [VERIFICATO il 02/09/2026, nessuna riga di licenza in   |
//|  nessuno dei tre file]. Su TradingView access=1 rende il          |
//|  sorgente LEGGIBILE, non automaticamente RIUSABILE.               |
//|  >>> REGOLA APPLICATA IN QUESTO FILE: NON E' STATA COPIATA        |
//|      NEMMENO UNA RIGA DI PINE. E' stata riscritta in MQL5 la      |
//|      FORMULA STATISTICA -- media mobile, deviazione standard,     |
//|      correlazione, z-score, z-score modificato di                 |
//|      Iglewicz-Hoaglin: matematica pubblica, non proteggibile --   |
//|      E SI CITA COMUNQUE autore, URL e data, come si e' fatto per  |
//|      ABTG_AllineaLondra. Copie archiviate e lette riga per riga:  |
//|        caccia_strategie\biblioteca\sorgenti\                      |
//|          PairTrade_OLS_wa1one-vladimirkovalchuk_tv8e024d8c1b75_2026-09-02.pine
//|          UnilateralPairsTrading_pietro3334_tvb852187ca0ac_2026-09-02.pine
//|          StatArbPairsLongOnly_piirsalu_tvd9bf81d59471_2026-09-02.pine
//|                                                                  |
//|  ------------------------------------------------------------    |
//|  LE DOMANDE, E SONO LE UNICHE                                     |
//|  ------------------------------------------------------------    |
//|  dossier: caccia_strategie\CACCIA_FREQUENZA4_GH_TV_FF_2026-09-02.md
//|  bozza  : prove\RELATIVO_FREQUENZA_BOZZA.txt (storia; fanno fede  |
//|           i prova operativi RELATIVO_*.txt)                       |
//|  firma  : report\FIRME_2026-08-31.md (FIRMA 2, cancello H8)       |
//|  spread : risultati_archivio\SPREAD_FLOTTA_MISURA_2026-09-03.md   |
//|           + spread_flotta\spread_orario_*.csv  [MISURATO]         |
//|                                                                  |
//|  LA DOMANDA DEL PRIMO TEST, TESTUALE DAL DOSSIER:                 |
//|    "Quando D30EUR si stacca da U30USD piu' del solito nella       |
//|     sessione americana, quello scarto RIENTRA -- abbastanza       |
//|     spesso da fare 2+ occasioni al giorno a M5, e abbastanza da   |
//|     pagare lo spread?"                                            |
//|                                                                  |
//|  E LA CONDIZIONE DI MORTE, SCRITTA PRIMA DELLA MISURA:            |
//|    se la divergenza NON rientra, questo non e' un motore di       |
//|    convergenza: e' un MOMENTUM TRAVESTITO, e si chiude. E' il     |
//|    cancello C6, ed e' il numero che uccide o salva la tesi.       |
//|                                                                  |
//|  ------------------------------------------------------------    |
//|  COSA QUESTA SONDA NON DICE, e non e' una dimenticanza            |
//|  ------------------------------------------------------------    |
//|   - NON dice se RELATIVO guadagna. Dice se ha PORTATA, TAGLIA,    |
//|     GEOMETRIA, CONVERGENZA e TENUTA sufficienti perche' valga la  |
//|     pena scrivere l'EA operativo. Il merito e' a tick, dopo, e    |
//|     con >= 150 operazioni IS (Emendamento della Finestra, A).     |
//|   - NON misura la CO-INTEGRAZIONE. La tesi assume che il          |
//|     rapporto sia STAZIONARIO intraday: assunzione MAI verificata  |
//|     in questo progetto, ed e' l'ipotesi piu' forte del            |
//|     candidato. C6 e' la sua approssimazione operativa.            |
//|   - NON esce nessuna colonna di P/L, Profit Factor o drawdown:    |
//|     senza operazioni sarebbero tutti ZERO, e uno zero in colonna  |
//|     prima o poi qualcuno lo legge come un risultato.              |
//|   - NON promuove niente e non tocca nessuna sedia viva.           |
//|                                                                  |
//|  DEMO. ASCII puro: niente accenti dentro le stringhe, niente      |
//|  emoji (regola di casa dei .ps1, estesa qui perche' log e CSV     |
//|  finiscono negli stessi strumenti).                               |
//|  NON COMPILATO NE' ESEGUITO da chi ha scritto il file: in quel    |
//|  ambiente non esistono MetaEditor ne' Strategy Tester. Si         |
//|  compila in MetaEditor PRIMA di qualunque corsa.                  |
//+------------------------------------------------------------------+
//
//  LE SCELTE DI TRADUZIONE E I RILIEVI TECNICI, NUMERATI.
//  Sono NOSTRI, non dei tre Pine. Ogni numero e' verificabile sul
//  codice qui sotto e ogni numero ha almeno una COLONNA che lo
//  misura sul campo: un rilievo senza colonna e' un'opinione.
//  ==================================================================
//
//  T1. IL SECONDO SIMBOLO SI LEGGE SOLO A BARRA CHIUSA.
//      Il tester MT5 modella i tick SOLO del simbolo del grafico;
//      del secondo scarica le barre. Leggere il metro a shift 0
//      vuol dire leggere una barra IN FORMAZIONE = LOOK-AHEAD
//      MASCHERATO. Qui ENTRAMBE le serie si leggono a shift 1 e
//      oltre, e si VERIFICA CHE I TIMESTAMP COINCIDANO barra per
//      barra. Colonne (NOMI REALI, quelli dell'intestazione di
//      OnTesterDeinit -- la prima stesura ne citava tre che non
//      esistevano, corretto nell'audit del 03/09):
//        "Valutazioni Metro Mancante Segnale"
//        "Valutazioni Perse Buco Finestra"
//        "Valutazioni Con Solo Metro"
//
//  T2. SE MANCA UNA BARRA DEL METRO, LA BARRA SI SALTA. NON SI
//      RIUSA LA PRECEDENTE, e non esiste nessun input per farlo:
//      un carry-forward inventerebbe uno scarto che non e' mai
//      esistito, cioe' un SEGNALE FINTO. Questa e' la regola del
//      dossier (rilievo 5.6.2).
//      >>> ESTENSIONE NOSTRA, DICHIARATA: non basta che sia
//      presente la barra di segnale. Lo z-score guarda indietro
//      2n barre (3n in modo beta OLS): se dentro quella finestra
//      c'e' un buco, media e deviazione sarebbero calcolate su
//      barre di ORE DIVERSE. Quindi si pretende l'allineamento
//      SULL'INTERA finestra, e il costo di questa severita' e'
//      MISURATO in due colonne separate ("Valutazioni Metro
//      Mancante Segnale" = buco sulla barra di segnale;
//      "Valutazioni Perse Buco Finestra" = barra di segnale
//      allineata ma buco nella coda). Se la seconda e' grande, la
//      regola stretta sta mangiando il campione e il referto lo
//      deve dire.
//
//  T3. I CALENDARI NON COINCIDONO (4 luglio, Thanksgiving,
//      Ferragosto, 26 dicembre). I GIORNI SPAIATI si CONTANO
//      ("Giorni Spaiati", "Giorni Spaiati Pct" = cancello C2):
//      sono i giorni in cui il rapporto fa un salto che non e' un
//      segnale. Oltre il 10% dei giorni la sonda va rifatta
//      filtrandoli, e si dichiara.
//      >>> AVVERTENZA DA LEGGERE PRIMA DEI NUMERI: nel tester MT5
//      la storia del SECONDO simbolo viene sincronizzata alla
//      prima richiesta. Le PRIME barre della corsa possono quindi
//      risultare "mancanti" per sincronizzazione, non per
//      calendario. E' un altro motivo per cui questi conteggi
//      sono colonne e non silenzio.
//      >>> CORREZIONE DELL'AUDIT 03/09: le barre del SOLO METRO si
//      contano SOLO dentro lo span dello z-score, non su tutta la
//      coda di warmup. La coda attraversa la notte e il metro di
//      notte quota mentre la gamba no: contarla avrebbe dato
//      "Giorni Spaiati Pct" = 100% ogni giorno, cioe' C2 avrebbe
//      misurato gli ORARI DI QUOTAZIONE invece dei CALENDARI.
//      Il perche' per esteso sta in testa ad AllineaSerie_Calc.
//      >>> FIX C2 v1.01 (04/09): la misura D30EUR/U30USD ha mostrato
//      il difetto che il paragrafo sopra descriveva ma non correggeva
//      ancora del tutto: un giorno in cui il METRO era chiuso per
//      FESTIVITA' PROPRIA (DAX aperto, Dow chiuso o viceversa) veniva
//      contato "spaiato" come un buco vero. Ora si distingue: vedi il
//      cartello sopra GiorniMetroAttivi_Calc/GiornoMetroAttivo_Calc.
//      >>> E IL FIX v1.01 NON MORDEVA (misurato, non temuto): chiedeva
//      "zero barre del metro in TUTTO il giorno di calendario", che su
//      un metro quasi 24h non capita MAI -- infatti la corsa rifatta ha
//      dato numeri identici al centesimo. La v1.02 fa la stessa domanda
//      DENTRO LA FINESTRA ORARIA, dove ha un senso. Il criterio vecchio
//      resta come contatore di controllo ("Giorni Metro Zero
//      Calendario", atteso 0).
//
//  T4. FORMA UNILATERALE, NON A DUE GAMBE -- ed e' una SCELTA
//      NOSTRA. A due gambe si pagano DUE spread per UNA
//      convergenza. Qui si "scambia" SOLO il simbolo del grafico,
//      usando l'altro come METRO. La forma a due gambe e' piu'
//      pura statisticamente e piu' cara operativamente: NON E'
//      STATA MISURATA. Dichiarato.
//
//  T5. IL RAPPORTO NON E' ADIMENSIONALE PER I PUNTI. Lo z-score
//      normalizza la SCALA, non il BETA: se il metro e'
//      sistematicamente piu' volatile della gamba, il rapporto
//      eredita la volatilita' del metro. Per questo il BETA OLS
//      resta come SECONDA cella dell'ablazione (InpModoSpread=1),
//      non si butta.
//
//  T6. UNA SOLA POSIZIONE FINTA PER VOLTA, ED E' IL NUMERO C1.
//      Il dossier chiede gli attraversamenti ESEGUIBILI, cioe'
//      quelli che un EA con una posizione per volta prenderebbe
//      davvero. Quindi si contano DUE numeri, non uno:
//        "Attraversamenti Grezzi"     = tutti gli attraversamenti
//        "Attraversamenti Eseguibili" = quelli presi a slot libero
//      >>> E c'e' un COLLAUDO gratis dentro questa scelta: mentre
//      un long e' aperto, uno short NON PUO' nascere, perche' per
//      arrivare a z > +soglia lo z deve prima passare da
//      -soglia_uscita, che chiude il long. Quindi la colonna
//      "Scartati Occupato Altro Lato Collaudo" DEVE VENIRE ZERO.
//      Se non viene zero, c'e' un errore nella macchina a stati e
//      i numeri non valgono.
//
//  T7. LA FINESTRA E' AL MINUTO, NON ALL'ORA. 14:30 -> 22:00 ORA
//      SERVER BCM (= 15:30 -> 23:00 italiane; server = ora
//      italiana - 1). Inizio INCLUSO, fine ESCLUSA: una barra che
//      apre esattamente alle 22:00 e' gia' fuori.
//      E un attraversamento vale solo se la BARRA D'INGRESSO (la
//      successiva) cade ANCORA dentro la finestra: gli altri si
//      contano a parte ("Attraversamenti Ingresso Fuori
//      Finestra"), non si eseguono.
//      DALLA v1.03 "la successiva" e' la barra 0 VERA (tProssima),
//      non tSeg + gTfSec: se lo storico della gamba ha un buco le
//      due NON coincidono, e chiedere alla barra teorica lasciava
//      aprire posizioni su una barra gia' fuori sessione (era la
//      causa del collaudo T12 rotto). Quante volte il gate nuovo
//      morde lo dice la colonna "Ingressi Barra Reale Fuori":
//      senza buchi vale 0 e il comportamento e' identico a prima.
//
//  T8. I BARRE FUORI FINESTRA NON SI VALUTANO, ED E' UNA SCELTA.
//      Fuori dalla sessione non si calcola nemmeno lo z-score
//      (costerebbe il triplo del tempo per contare attraversamenti
//      che il motore non prenderebbe). La colonna "Barre Fuori
//      Finestra" dice quante sono. Conseguenza dichiarata: la
//      sonda NON sa quanti attraversamenti ci sono la notte.
//
//  T9. IL PRIMO ATTRAVERSAMENTO DELLA SESSIONE E' CONTATO, E
//      SEPARATAMENTE. Alla prima barra utile lo z precedente
//      viene dalla barra PRIMA della sessione: e' un
//      attraversamento vero, ma nasce su uno stacco di riapertura
//      e non su un movimento intra-sessione. Sta in colonna
//      ("Attraversamenti Prima Barra Sessione") cosi' il referto
//      lo puo' sottrarre invece di doverlo indovinare.
//
//  T10. IL PREZZO D'INGRESSO E' L'APERTURA DELLA BARRA
//      SUCCESSIVA, e l'uscita l'apertura della barra successiva a
//      quella di convergenza: e' cio' che un EA a barra chiusa
//      puo' davvero fare. MFE e MAE si misurano SEMPRE da quel
//      prezzo, sui massimi/minimi delle barre della GAMBA (mai del
//      metro: il metro non si scambia, T4).
//
//  T11. MFE/MAE A ORIZZONTE: SONO UNA MISURA SEPARATA, e serve.
//      MFE/MAE "alla convergenza" dipendono dalla REGOLA D'USCITA;
//      MFE/MAE "a orizzonte fisso" no. Per averli senza guardare
//      il futuro, ogni attraversamento eseguibile apre un
//      OSSERVATORE che vive InpBarreOrizzonte barre e muore da
//      solo, indipendentemente dalla posizione finta. Gli
//      osservatori che NON completano l'orizzonte (fine sessione)
//      sono ESCLUSI dalle mediane e CONTATI ("Orizzonte Completo
//      Long/Short" e' la numerosita' vera di quelle mediane).
//
//  T12. LA TENUTA SOTTO 60 SECONDI E' UN COLLAUDO, NON UNA
//      SCOPERTA. Su M5 la tenuta minima e' UNA barra = 300 s, su
//      M15 = 900 s: la quota sotto 60 s (vincolo prop P5) DEVE
//      venire 0,00%. Se non viene zero, c'e' un errore nella
//      contabilita' dei tempi. Il vincolo si legge lo stesso,
//      perche' e' quello che chiede CONFIG_PROP_2026-08-31 P5.
//      DALLA v1.03 la tenuta in secondi si misura sulle BARRE
//      EFFETTIVAMENTE VALUTATE (gPosBarre x gTfSec) e non sulla
//      differenza di calendario fra i due timestamp: su un buco
//      dello storico quella differenza misura IL BUCO, non la
//      posizione. Il collaudo NON diventa per questo una
//      tautologia -- resta l'unico modo di produrre "sotto 60 s",
//      cioe' gPosBarre = 0: una posizione chiusa senza aver mai
//      valutato una barra. Il conteggio secco esce in colonna
//      ("Chiuse Zero Barre"), e il tempo di calendario grezzo resta
//      leggibile nel CSV riga-per-segnale ("secondi_calendario").
//
//  T13. ATR: ECO, NON MOTORE. L'ATR della gamba al momento del
//      segnale non decide niente qui: serve a leggere il MAE in
//      unita' di ATR (pavimento SL, R109) quando si scrivera' l'EA.
//      Default InpAtrModoRma=false, cioe' la SMA del True Range,
//      che secondo la misura T3 di ABTG_SondaM0PB e' la
//      convenzione di iATR in MQL5: la colonna "Atr Divergenza Rel
//      Media Pct" DEVE quindi venire ~0. Se non viene ~0, la
//      convenzione di iATR e' l'altra (Wilder) e va SCRITTO: la
//      colonna MISURA, non assume.
//
//  T14. PUNTI INDICE -- la conversione e' 100 e NON e'
//      un'assunzione: e' la misura del repo per U30USD, NASUSD e
//      D30EUR (100 punti MT5 = 1 punto indice). Sta in un input e
//      il valore risultante ESCE IN COLONNA ("Punto Indice
//      Prezzo"): se non viene 1,00 la TAGLIA e' sbagliata di un
//      fattore, e si vede subito.
//
//  T15. LA GIORNATA = giornata di calendario del SERVER con almeno
//      una barra valutata DENTRO la finestra. Un festivo senza
//      barre non e' un giorno in cui il motore "non ha trovato
//      occasioni": e' un giorno chiuso. Contarlo gonfierebbe il
//      denominatore e abbasserebbe la frequenza, cioe'
//      sbaglierebbe CONTRO il candidato.
//+------------------------------------------------------------------+
#property copyright "ABTG - Sonda di convergenza RELATIVO (PASSO 0, caccia 02/09/2026)"
#property version   "1.03"
//  v1.03 (03/09/2026) -- FIX T12 "TENUTA SOTTO 60 SECONDI". Difetto
//  PRE-ESISTENTE (c'era gia' nella primissima corsa v1.00, quindi NON
//  introdotto dai fix C2): 47 celle su 49 con "Sotto 60 Secondi Pct"
//  fra 0,10 e 0,74 dove il collaudo pretende 0,00.
//  LA CAUSA, TRACCIATA RIGA PER RIGA (non e' una supposizione):
//    a) i due timestamp che entrano in 'sec' sono APERTURE DI BARRA
//       sulla stessa griglia del TF, quindi la loro differenza vale 0
//       oppure >= gTfSec (300 s a M5, 900 s a M15). "sotto 60 secondi"
//       non e' "una tenuta corta": e' ESATTAMENTE sec = 0.
//    b) sec = 0 si produce in UN SOLO punto: la posizione viene aperta
//       su tProssima (la barra 0 VERA, iTime(...,0)) mentre il gate T7
//       controllava la finestra oraria su tAttesa = tSeg + gTfSec, cioe'
//       sulla barra d'ingresso TEORICA. Quando la GAMBA ha un buco
//       (barra M15 mancante) le due NON coincidono: la teorica cade
//       dentro la finestra, la REALE cade fuori, il gate lascia passare
//       e la posizione nasce su una barra FUORI SESSIONE.
//    c) alla valutazione successiva quella stessa barra e' la barra di
//       segnale (tSeg == gPosTIngr) e, essendo fuori finestra, scatta la
//       rete "nessuno stato attraversa la notte": ChiudiPosizioneFinta(2,
//       tSeg, ...) con tSeg == gPosTIngr -> sec = 0 -> gSotto60++.
//       Quel ramo esce PRIMA del passo 6, quindi gPosBarre e' ancora 0:
//       la stessa posizione deposita anche un campione di tenuta a ZERO
//       BARRE, che tirava giu' pure la mediana di C8.
//  FIX, in due gesti e nessuno tocca z-score/ingresso/uscita/C2:
//    1) il gate T7 si applica alla barra d'ingresso REALE (tProssima),
//       non a quella teorica. Senza buchi le due coincidono e il
//       comportamento e' IDENTICO: il fix morde solo sul buco.
//    2) la tenuta in secondi si misura sulle BARRE EFFETTIVAMENTE
//       VALUTATE (gPosBarre x gTfSec) e non sulla differenza di
//       calendario grezza fra due timestamp, che su un buco misura il
//       buco e non la posizione. Il tempo di calendario resta, come
//       colonna SEPARATA, nel CSV riga-per-segnale.
//  COSI' T12 NON DIVENTA UNA TAUTOLOGIA: con la (2) "sotto 60 s"
//  significa ora, esattamente, "posizione chiusa senza aver mai
//  valutato una barra", che e' un difetto vero e resta rilevabile.
//  E IL FIX E' FALSIFICABILE (lezione della v1.01): esce la colonna
//  "Ingressi Barra Reale Fuori" = quante volte il gate nuovo ha
//  fermato un ingresso che il vecchio lasciava passare. Se torna 0 e
//  T12 fallisce ancora, questa diagnosi e' SBAGLIATA e va riscritta.
//  Accanto, "Chiuse Zero Barre" = il collaudo T12 in conteggio secco.
//  REL_NSTATS 95 -> 97, autotest 23 -> 25 blocchi, CSV dei segnali
//  con una colonna in piu' ("secondi_calendario").
//  v1.02 (03/09/2026) -- IL FIX v1.01 ERA COLLEGATO MA NON POTEVA
//  MORDERE: LA DOMANDA ERA POSTA ALLA GRANULARITA' SBAGLIATA.
//  MISURA (non opinione): la corsa D30_M15 rifatta con la v1.01
//  (referto ..._1814_v101_IDENTICO_A_PREFIX.txt) ha dato "Giorni
//  Spaiati" IDENTICI AL CENTESIMO alla v1.00 su tutte e 49 le celle
//  (44 = 10,05% sulla prima riga), e anche "metro mancante sul
//  segnale" (352) e "valutazioni perse per buco" (58) sono identici.
//  Siccome per costruzione vale
//      Spaiati(v1.01) = Spaiati(v1.00) - GiorniFestaMetro,
//  l'uguaglianza 44 = 44 DIMOSTRA che gGiorniFestaMetro e' rimasto 0
//  su tutte le celle: la funzione girava, ma la sua condizione non si
//  e' MAI verificata.
//  PERCHE': la v1.01 chiedeva "il metro ha ZERO barre in TUTTO IL
//  GIORNO DI CALENDARIO?". U30USD e' un CFD quasi 24h (lo dice gia'
//  il cartello di AllineaSerie_Calc) e la coda parte 300 barre prima
//  della barra di segnale, che sta sempre dopo le 14:30 server:
//  quindi la coda contiene SEMPRE anche le barre notturne del metro
//  dello stesso giorno. Un giorno di calendario del tutto muto per il
//  metro, in 438 giorni, non e' mai esistito. La condizione era
//  VUOTA. I 352 buchi non sono giornate intere: sono PEZZI di
//  giornata dentro la finestra 14:30-22:00.
//  FIX v1.02: la stessa identica logica, ma misurata NELLA FINESTRA
//  in cui la sonda guarda davvero. "Il metro non ha mai quotato" ora
//  vuol dire "nessuna barra del metro dentro la finestra oraria di
//  quel giorno" = il suo mercato cash era chiuso (festivita' propria),
//  mentre di notte il CFD quotava lo stesso. Il criterio di calendario
//  della v1.01 NON viene buttato: resta come CONTATORE INFORMATIVO
//  ("Giorni Metro Zero Calendario", atteso 0) cosi' la prossima corsa
//  MISURA quello che qui e' stato dedotto, invece di doverlo dedurre.
//  NON TOCCATO NIENTE di ingresso/uscita/z-score: spanOk e' identico
//  bit per bit, cambia solo la CLASSIFICAZIONE del buco per il gate
//  C2. REL_NSTATS 94 -> 95, autotest 22 -> 23 blocchi.
//  v1.01 (04/09/2026) -- FIX C2 "GIORNI SPAIATI": la corsa D30EUR x
//  U30USD M15 (REFERTO_SONDARELATIVO_D30_M15.txt) ha misurato C2 fino
//  al 60,50% (soglia 10%), 47 celle su 49 NON LEGGIBILI. La CAUSA e'
//  che DAX e Dow hanno calendari di festivita' DIVERSI: un giorno in
//  cui il METRO era semplicemente chiuso per festa PROPRIA (T3)
//  veniva contato come "spaiato" allo stesso modo di un buco VERO del
//  feed (mercato aperto, barra mancante per davvero). Fix: si
//  distingue costruendo, dai tempi del metro gia' scaricati per la
//  coda, l'elenco dei giorni in cui il metro ha ALMENO una barra
//  (GiorniMetroAttivi_Calc/GiornoMetroAttivo_Calc). Un giorno senza
//  NESSUNA barra del metro e' festivita' propria del suo mercato:
//  NON entra nel numeratore di C2 (va in "Giorni Festa Metro",
//  informativo, colonna nuova). Un giorno in cui il metro ERA attivo
//  ma manca proprio quella barra o quello span resta spaiato VERO.
//  NON TOCCATA la logica di ingresso/uscita/convergenza: spanOk
//  decide lo z-score esattamente come prima, cambia SOLO come il
//  buco viene classificato per il gate C2. REL_NSTATS 93 -> 94
//  (colonna "Giorni Festa Metro" in coda), autotest 21 -> 22 blocchi
//  (BLOCCO 22: GiorniMetroAttivi_Calc/GiornoMetroAttivo_Calc).
#property description "CONTATORE di attraversamenti dello z-score del rapporto fra DUE simboli. NON APRE ORDINI."
#property strict

//==================================================================
//  LE SOGLIE CONGELATE PRIMA DI VEDERE I NUMERI.
//  Sono #define e non input APPOSTA: un cancello che si puo'
//  spostare dalla riga di lancio non e' un cancello.
//==================================================================

//--- C1: PAVIMENTO DI PORTATA (mandato di Claudio 02/09, somma dei
//    due lati, attraversamenti ESEGUIBILI al giorno).
#define REL_C1_ESEGUIBILI_GIORNO   2.00

//--- C5 / H8: aritmetica del cancello H8 (FIRME_2026-08-31, FIRMA 2).
#define REL_C5_RR_MINIMO           0.70
#define REL_H8_E_TARGET_R          0.075

//--- C6: la condizione di morte della tesi.
#define REL_C6_NON_CONVERGUTE_KO   40.0    // oltre -> SCARTO
#define REL_C6_NON_CONVERGUTE_SOSP 25.0    // 25-40 -> SOSPESO

//--- C7: cap di rischio aperto firmato il 18/08 (C1 = 3,25% = 5 SL
//    vivi da 0,65%). Se il massimo giornaliero misurato supera 5,
//    InpMaxTradesPerDay entra nell'EA DAL PRIMO ROUND.
#define REL_C7_RISCHIO_PER_TRADE   0.65
#define REL_C7_CAP_RISCHIO_APERTO  3.25

//--- C8: muro d'attrito (arXiv 2605.04004 par.6.2) e clausola HFT
//    delle prop (CONFIG_PROP_2026-08-31, proposta P5).
#define REL_C8_TENUTA_BARRE_MIN    12.0
#define REL_C8_QUOTA_SOTTO60_KO    25.0

//--- C2: quota di giorni spaiati oltre la quale la sonda va rifatta
//    filtrando quei giorni. NON e' un cancello di merito.
#define REL_C2_GIORNI_SPAIATI_PCT  10.0

//==================================================================
//  C3 -- LA TAGLIA, E QUI IL 03/09/2026 E' CAMBIATO QUALCOSA.
//  ----------------------------------------------------------------
//  LA BOZZA diceva: "3x spread -> SCARTO, 3-6x -> SOSPESO (e
//  finalmente si misura lo spread col Code Base 74148)", con in
//  testa il cartello [SPREAD NON MISURATO].
//  QUEL DEBITO E' STATO PAGATO LA MATTINA DEL 03/09/2026:
//    risultati_archivio\SPREAD_FLOTTA_MISURA_2026-09-03.md
//    risultati_archivio\spread_flotta\spread_orario_<SIMBOLO>.csv
//    (252 milioni di tick, 2024.09.26 -> 2026.06.30, solo-bid 0,000%)
//  QUINDI LA FASCIA "SOSPESO PER SPREAD NON MISURATO" QUI NON
//  ESISTE PIU': la soglia e' SECCA, sul numero VERO.
//
//  QUALE numero vero: la MEDIANA ORARIA PEGGIORE del simbolo
//  SCAMBIATO dentro le ore di lavoro di QUESTA sonda (14-21 ora
//  server: la finestra e' 14:30-22:00 e l'ultima ora d'ingresso e'
//  la 21). E' la CLAUSOLA SEVERA: non la media della finestra, non
//  l'ora migliore -- la PEGGIORE. Motivo: un motore che regge solo
//  nelle tre ore a spread basso e' un motore con un filtro orario
//  non dichiarato, e quel filtro va MISURATO dopo, non regalato ora.
//
//  I NUMERI, letti dai CSV orari (colonna mediana_idx, ore 14..21):
//    D30EUR : 1,7 1,7 1,7 2,6 2,7 2,7 2,7 2,8  -> PEGGIORE 2,80
//             (il DAX dalle 17 in poi e' FUORI dal suo cash: lo
//              spread quasi raddoppia dentro la nostra finestra.
//              E' un fatto misurato, non una stima.)
//    NASUSD : 1,8 1,8 1,7 1,7 1,7 1,6 1,7 1,7  -> PEGGIORE 1,80
//    U30USD : 2,0 2,0 1,9 1,9 1,9 1,9 1,9 1,8  -> PEGGIORE 2,00
//             (U30USD e' METRO nelle tre coppie dichiarate, non si
//              scambia: il suo numero sta qui per completezza e
//              perche' una coppia futura potrebbe scambiarlo.)
//  Un solo spread per convergenza, perche' la forma e' UNILATERALE
//  (T4). Nella forma a due gambe questi numeri andrebbero
//  RADDOPPIATI, e la forma a due gambe non e' stata misurata.
//==================================================================
#define REL_SPREAD_D30EUR          2.80
#define REL_SPREAD_NASUSD          1.80
#define REL_SPREAD_U30USD          2.00
#define REL_C3_MULTIPLO_SCARTO     3.0     // MFE mediana < 3x spread -> SCARTO
#define REL_C3_MULTIPLO_LARGO      6.0     // > 6x spread -> passa largo

//--- capienza dei campioni per le mediane. A M5 su una tranche di
//    ~12 mesi gli attraversamenti attesi sono qualche migliaio per
//    lato: 100.000 e' abbondante. Se si arrivasse al tetto la
//    mediana sarebbe TRONCATA, quindi il fatto viene stampato a voce
//    alta invece di essere ingoiato.
#define REL_MAX_CAMPIONI           100000

//--- numero di valori esportati in colonna. E' un #define perche'
//    l'array, l'intestazione e la riga di formato SI TOCCANO SEMPRE
//    INSIEME: qui sotto c'e' un controllo automatico che conta le
//    virgole dell'intestazione e i '%' del formato e URLA se non
//    tornano (la trappola del CSV sfasato di ABTG_SondaM0PB, risolta
//    a mano li' e resa automatica qui).
//    v1.01 (04/09): +1 (94) per "Giorni Festa Metro" (fix C2, vedi
//    GiorniMetroAttivi_Calc): informativo, NON entra nel numeratore C2.
//    v1.02 (03/09): +1 (95) per "Giorni Metro Zero Calendario", il
//    criterio VUOTO della v1.01 tenuto come contatore di controllo:
//    atteso 0, ed e' la PROVA misurata della diagnosi (vedi in testa).
#define REL_NSTATS                 97

//==================================================================
//  INPUT
//  I nomi vanno pinnati TALI E QUALI dal file prova: MT5 IGNORA IN
//  SILENZIO un pin che non trova (errore n.3 della
//  CHECKLIST_RIGA_DI_LANCIO, e' cosi' che e' nato il falso "0/8" del
//  FiboH4). LA BOZZA PROPONEVA QUESTI NOMI SENZA CHE ESISTESSERO:
//  DA QUI IN POI FANNO FEDE QUELLI DI QUESTO FILE.
//==================================================================
input group "=== IL METRO -- il secondo simbolo, che si LEGGE e non si scambia (T4) ==="
input string InpSimboloMetro       = "U30USD";  // simbolo METRO: si legge, NON si scambia
input int    InpModoSpread         = 0;         // 0 = rapporto gamba/metro | 1 = beta OLS (ablazione T5)
input int    InpModoZScore         = 0;         // 0 = media/deviazione | 1 = mediana/MAD (Iglewicz-Hoaglin)

input group "=== I TRE PARAMETRI VERI DEL MOTORE: qui e solo qui sta lo screening ==="
input int    InpFinestraN          = 20;        // LA MANOPOLA DELLA FREQUENZA (par.5.4 del dossier). SWEEPABILE
input double InpSogliaIngressoSigma= 1.05;      // attraversamento d'ingresso, in sigma. SWEEPABILE
input double InpSogliaUscitaSigma  = 0.05;      // rientro = convergenza. PIN: e' la definizione di C6

input group "=== LA FINESTRA -- ORA SERVER BCM (= ora italiana - 1), al MINUTO (T7) ==="
input int    InpOraInizioServer    = 14;        // 14:30 server = 15:30 italiane
input int    InpMinInizioServer    = 30;
input int    InpOraFineServer      = 22;        // 22:00 server = 23:00 italiane. FINE ESCLUSA
input int    InpMinFineServer      = 0;

input group "=== CONTENITORE DELLA MISURA ==="
input int    InpBarreMaxTenuta     = 120;       // tetto di tenuta della posizione finta: alimenta C6
input int    InpBarreOrizzonte     = 24;        // orizzonte fisso per MFE/MAE indipendenti dall'uscita (T11)
input int    InpLato               = 0;         // 0 = entrambi | 1 = solo long | 2 = solo short
input double InpPuntiPerIndice     = 100.0;     // punti MT5 per 1 punto indice. MISURATO = 100 sui tre indici (T14)

input group "=== ECO ATR (non decide niente: serve a leggere il MAE in ATR, T13) ==="
input int    InpAtrPeriod          = 14;        // periodo ATR sulla GAMBA
input bool   InpAtrModoRma         = false;     // false = SMA del TR (modo MT5) | true = Wilder/RMA

input group "=== TECNICI ==="
input int    InpWarmupBarre        = 300;       // coda di barre ricalcolate a ogni barra nuova
input bool   InpConfrontaMT5       = true;      // legge iATR e mette lo SCARTO in colonna (collaudo T13)
input bool   InpScriviCsv          = true;      // CSV riga-per-segnale + CSV totali (SOLO fuori ottimizzazione)
input bool   InpVerbose            = true;      // log (in ottimizzazione NON li legge nessuno: vedi le colonne)
input bool   InpAutoTest           = true;      // autotest del nucleo puro. L'esito esce in COLONNA
input string InpTag                = "RELATIVO_SONDA"; // ETICHETTA (NON e' un magic: qui non ci sono ordini)

//==================================================================
//  STATO -- tutti accumulatori di conteggio e una posizione FINTA.
//  Nessun ordine, nessun ticket, nessun lotto.
//==================================================================
datetime gLastBar        = 0;
double   gPuntoIndice    = 0.0;
double   gSpreadMisurato = 0.0;   // dalla tabella congelata, per il simbolo SCAMBIATO
double   gSogliaC3       = 0.0;   // 3 x spread misurato
int      gTfSec          = 0;
int      hAtrMt5         = INVALID_HANDLE;

//--- conteggi di barre e di sincronizzazione fra i DUE feed
long gBarreValutate      = 0;
long gBarreFuoriFinestra = 0;
long gBarreSaltateDati   = 0;   // storico della GAMBA corto/illeggibile
long gMetroMancantiUltima= 0;   // buco del METRO sulla barra di segnale (T1)
//--- ATTENZIONE ALLA SEMANTICA DI QUESTI DUE, e non e' pignoleria:
//    contano VALUTAZIONI PERSE, non BUCHI. Un solo buco del metro
//    invalida fino a 'span' valutazioni successive (2n, o 3n in beta
//    OLS), perche' lo z-score guarda indietro. Quindi questi numeri
//    misurano IL COSTO DELLA REGOLA STRETTA (T2), che e' esattamente
//    la cosa da sapere: se sono grandi, non e' il calendario che
//    sporca il campione, e' la nostra severita' che se lo mangia.
long gValutazioniPerseBuco = 0; // barra di segnale allineata, ma buco nella coda
long gValutazioniSoloMetro = 0; // il metro ha barre che la gamba non ha
long gBarreSenzaZAperta  = 0;   // z non calcolabile mentre la posizione finta e' aperta
long gZNonCalcolabile    = 0;   // deviazione o MAD nulla: z indefinito

//--- attraversamenti
long gGrezziL = 0, gGrezziS = 0;
long gEseguibiliL = 0, gEseguibiliS = 0;
long gOccupatoStessoL = 0, gOccupatoStessoS = 0;
long gOccupatoAltroLato = 0;          // COLLAUDO T6: deve venire 0
long gAttrIngressoFuori = 0;
long gAttrPrimaBarra    = 0;
//--- FIX T12 v1.03, ed e' il numero che rende il fix FALSIFICABILE
//    (lezione della v1.01, che "girava" senza mai mordere): quante
//    volte il gate T7 ha fermato un ingresso che la versione vecchia
//    lasciava passare, cioe' i casi in cui la barra d'ingresso TEORICA
//    (tSeg + gTfSec) cadeva DENTRO la finestra ma quella REALE
//    (iTime(...,0), spostata da un buco dello storico) cadeva FUORI.
//    Senza buchi vale 0. Se vale 0 E il collaudo T12 fallisce ancora,
//    la diagnosi della v1.03 e' sbagliata e va riscritta.
long gIngressoBarraRealeFuori = 0;

//--- esiti delle posizioni finte
long gChiuseL = 0, gChiuseS = 0;
long gConvergL = 0, gConvergS = 0;
long gFineSessL = 0, gFineSessS = 0;
long gTettoL = 0, gTettoS = 0;
long gFineCorsa = 0;                  // esclusa da C6: e' un artefatto del bordo corsa
long gSotto60L = 0, gSotto60S = 0;
//--- COLLAUDO T12 in conteggio secco (v1.03): posizioni chiuse con
//    ZERO barre valutate. Dalla v1.03 la tenuta in secondi vale
//    gPosBarre x gTfSec, quindi "sotto 60 secondi" e "zero barre" sono
//    lo STESSO evento: la percentuale dice quanto pesa, questo dice
//    quante sono. Atteso 0.
long gChiuseZeroBarre = 0;

//--- giornate (T15)
int  gDayStamp = -1;
bool gDaySpaiato = false;
//--- FIX C2 v1.01 (04/09): un giorno in cui il METRO non ha MAI
//    quotato dentro la finestra (festivita' propria del suo mercato,
//    calendari diversi fra gamba e metro, T3) e' FISIOLOGICO, non e'
//    un difetto del feed. gDayFestaMetro lo isola dal gDaySpaiato
//    "vero" (buco mentre il metro era comunque attivo). Vedi
//    GiorniMetroAttivi_Calc/GiornoMetroAttivo_Calc piu' sotto.
bool gDayFestaMetro = false;
//--- CONTATORE DI CONTROLLO v1.02: il criterio della v1.01 (metro con
//    ZERO barre in TUTTO il giorno di calendario). Non decide niente:
//    serve a MISURARE che quel criterio e' vuoto su una coppia con
//    metro quasi 24h. Se esce 0, la diagnosi in testa al file e' provata
//    dai dati e non dedotta.
bool gDayMetroZeroCal = false;
int  gDayEseL = 0, gDayEseS = 0;
long gGiorniContati = 0, gGiorniSpaiati = 0;
long gGiorniFestaMetro = 0;   // informativo: ESCLUSI dal numeratore C2, non dal denominatore
long gGiorniMetroZeroCal = 0; // controllo: quante volte MORDEREBBE il criterio di calendario v1.01
long gMaxGiornoL = 0, gMaxGiornoS = 0, gMaxGiornoTot = 0;
long gGiorni2Tot = 0, gGiorniZero = 0;

//--- campioni (in PUNTI INDICE, salvo tenuta in BARRE)
double gMfeL[], gMfeS[], gMaeL[], gMaeS[];
int    gNMfeL=0, gNMfeS=0, gNMaeL=0, gNMaeS=0;
double gTenL[], gTenS[];
int    gNTenL=0, gNTenS=0;
double gMfeOrL[], gMfeOrS[], gMaeOrL[], gMaeOrS[], gMovOrL[], gMovOrS[];
int    gNMfeOrL=0, gNMfeOrS=0, gNMaeOrL=0, gNMaeOrS=0, gNMovOrL=0, gNMovOrS=0;
double gAtrPts[];
int    gNAtr=0;
bool   gTroncato = false;

//--- collaudo T13
double gAtrDivRelSom = 0.0;
long   gAtrDivN = 0;

//--- autotest: -1 = NON eseguito, che non e' "passato"
int gAutotestFalliti = -1;
int gAutotestBlocchi = 0;

//--- LA POSIZIONE FINTA (T6). Una sola, per costruzione.
bool     gPosAttiva  = false;
int      gPosLato    = 0;          // +1 long, -1 short
datetime gPosTIngr   = 0;
double   gPosPrezzo  = 0.0;
double   gPosZIngr   = 0.0;
int      gPosBarre   = 0;
double   gPosMfe     = 0.0;
double   gPosMae     = 0.0;
double   gPosAtr     = 0.0;

//--- GLI OSSERVATORI DI ORIZZONTE (T11). Array paralleli, non struct:
//    lo stesso stile del resto del repo e nessuna sorpresa di copia.
bool   gOsAttivo[];
int    gOsLato[];
double gOsPrezzo[];
int    gOsRimaste[];
double gOsMfe[];
double gOsMae[];
int    gOsMax = 0;
long   gOsIncompletiL = 0, gOsIncompletiS = 0;

//--- CSV riga-per-segnale
int gCsvSeg = INVALID_HANDLE;

void Log(string m){ if(InpVerbose) Print("[RELATIVO-SONDA] ", m); }

//==================================================================
//
//   NUCLEO PURO -- funzioni che non leggono NIENTE dal terminale.
//   Prendono numeri e rispondono. E' questa la parte che
//   l'AUTOTEST interroga a tavolino, senza mercato e senza feed.
//
//   Convenzione degli indici in TUTTO il nucleo: indice 0 = barra
//   piu' VECCHIA, indice n-1 = barra piu' RECENTE (l'ultima
//   CHIUSA). Nessun array e' "as series": la sonda copia con
//   ArraySetAsSeries(...,false) apposta, perche' un nucleo che
//   ragiona all'indietro e' un nucleo che nessuno rilegge.
//
//==================================================================

//+------------------------------------------------------------------+
//| MEDIA SEMPLICE su una finestra che FINISCE all'indice 'fine' e    |
//| comprende 'quante' barre (la barra 'fine' inclusa).               |
//| Fuori dominio -> 0 e valido=false: uno zero muto sarebbe un       |
//| numero che nessuno spiega.                                        |
//+------------------------------------------------------------------+
bool SmaFin_Calc(const double &v[], const int n, const int fine, const int quante, double &out)
  {
   out = 0.0;
   if(quante < 1 || fine < 0 || fine >= n) return(false);
   int da = fine - quante + 1;
   if(da < 0) return(false);
   double s = 0.0;
   for(int i = da; i <= fine; i++) s += v[i];
   out = s/(double)quante;
   return(true);
  }

//+------------------------------------------------------------------+
//| DEVIAZIONE STANDARD di POPOLAZIONE (divisore 'quante') sulla      |
//| stessa finestra. E' la convenzione di ta.stdev con biased=true,   |
//| che e' il DEFAULT di Pine: la scelta e' dichiarata qui e non      |
//| lasciata al caso. Con 'quante' = 1 la deviazione e' 0 per         |
//| definizione, e lo z-score sara' dichiarato NON CALCOLABILE.       |
//+------------------------------------------------------------------+
bool StdevFin_Calc(const double &v[], const int n, const int fine, const int quante, double &out)
  {
   out = 0.0;
   double media;
   if(!SmaFin_Calc(v, n, fine, quante, media)) return(false);
   int da = fine - quante + 1;
   double s = 0.0;
   for(int i = da; i <= fine; i++)
     {
      double d = v[i] - media;
      s += d*d;
     }
   out = MathSqrt(s/(double)quante);
   return(true);
  }

//+------------------------------------------------------------------+
//| CORRELAZIONE DI PEARSON sulla stessa finestra. Serve SOLO al modo |
//| beta OLS (T5). Se una delle due serie e' costante la              |
//| correlazione non esiste: si restituisce false, NON zero (zero     |
//| vorrebbe dire "misurata e nulla", che e' un'altra cosa).          |
//+------------------------------------------------------------------+
bool CorrFin_Calc(const double &x[], const double &y[], const int n,
                  const int fine, const int quante, double &out)
  {
   out = 0.0;
   double mx, my;
   if(!SmaFin_Calc(x, n, fine, quante, mx)) return(false);
   if(!SmaFin_Calc(y, n, fine, quante, my)) return(false);
   int da = fine - quante + 1;
   double sxy = 0.0, sxx = 0.0, syy = 0.0;
   for(int i = da; i <= fine; i++)
     {
      double dx = x[i] - mx;
      double dy = y[i] - my;
      sxy += dx*dy; sxx += dx*dx; syy += dy*dy;
     }
   if(sxx <= 0.0 || syy <= 0.0) return(false);
   out = sxy/MathSqrt(sxx*syy);
   return(true);
  }

//+------------------------------------------------------------------+
//| MEDIANA di un vettore GIA' ORDINATO. Pari -> media dei centrali.  |
//+------------------------------------------------------------------+
double MedianaOrdinata_Calc(const double &v[], const int n)
  {
   if(n <= 0) return(0.0);
   if(n % 2 == 1) return(v[n/2]);
   return((v[n/2 - 1] + v[n/2])/2.0);
  }

//+------------------------------------------------------------------+
//| MEDIANA sulla finestra che finisce in 'fine'. Copia e ordina: la  |
//| finestra e' corta (n <= 40 nelle celle dichiarate) e la           |
//| chiarezza vale piu' di un algoritmo di selezione.                 |
//+------------------------------------------------------------------+
bool MedianaFin_Calc(const double &v[], const int n, const int fine, const int quante, double &out)
  {
   out = 0.0;
   if(quante < 1 || fine < 0 || fine >= n) return(false);
   int da = fine - quante + 1;
   if(da < 0) return(false);
   double c[];
   if(ArrayResize(c, quante) != quante) return(false);
   for(int i = 0; i < quante; i++) c[i] = v[da + i];
   ArraySort(c);
   out = MedianaOrdinata_Calc(c, quante);
   return(true);
  }

//+------------------------------------------------------------------+
//| MAD -- mediana degli scarti assoluti dalla mediana, sulla stessa  |
//| finestra. E' il denominatore dello z-score modificato di          |
//| Iglewicz-Hoaglin, cioe' la sola cosa presa dal terzo Pine (e      |
//| anche quella e' una formula pubblica, non codice).                |
//+------------------------------------------------------------------+
bool MadFin_Calc(const double &v[], const int n, const int fine, const int quante,
                 double &mediana, double &mad)
  {
   mediana = 0.0; mad = 0.0;
   if(!MedianaFin_Calc(v, n, fine, quante, mediana)) return(false);
   int da = fine - quante + 1;
   double c[];
   if(ArrayResize(c, quante) != quante) return(false);
   for(int i = 0; i < quante; i++) c[i] = MathAbs(v[da + i] - mediana);
   ArraySort(c);
   mad = MedianaOrdinata_Calc(c, quante);
   return(true);
  }

//+------------------------------------------------------------------+
//| IL RAPPORTO fra la gamba e il metro. Il guardiano su x <= 0 non   |
//| e' teoria: un tick sporco a zero su un CFD di indice esiste, e    |
//| una divisione per zero qui diventerebbe un segnale finto.         |
//+------------------------------------------------------------------+
bool Rapporto_Calc(const double y, const double x, double &out)
  {
   out = 0.0;
   if(x <= 0.0) return(false);
   out = y/x;
   return(true);
  }

//+------------------------------------------------------------------+
//| IL BETA OLS: beta = corr(x,y,n) * stdev(y,n) / stdev(x,n).        |
//| E' la formula del primo Pine, riscritta: e' la regressione        |
//| minimi quadrati di y su x, matematica pubblica. Serve solo        |
//| all'ablazione InpModoSpread=1 (T5).                               |
//+------------------------------------------------------------------+
bool BetaOls_Calc(const double &x[], const double &y[], const int n,
                  const int fine, const int quante, double &out)
  {
   out = 0.0;
   double corr, sx, sy;
   if(!CorrFin_Calc(x, y, n, fine, quante, corr)) return(false);
   if(!StdevFin_Calc(x, n, fine, quante, sx)) return(false);
   if(!StdevFin_Calc(y, n, fine, quante, sy)) return(false);
   if(sx <= 0.0) return(false);
   out = corr*sy/sx;
   return(true);
  }

//+------------------------------------------------------------------+
//| LO SPREAD IN MODO BETA: spread = sma(y,n) - beta * sma(x,n).      |
//+------------------------------------------------------------------+
bool SpreadOls_Calc(const double &x[], const double &y[], const int n,
                    const int fine, const int quante, double &out)
  {
   out = 0.0;
   double beta, mx, my;
   if(!BetaOls_Calc(x, y, n, fine, quante, beta)) return(false);
   if(!SmaFin_Calc(x, n, fine, quante, mx)) return(false);
   if(!SmaFin_Calc(y, n, fine, quante, my)) return(false);
   out = my - beta*mx;
   return(true);
  }

//+------------------------------------------------------------------+
//| LO Z-SCORE CLASSICO su uno scarto gia' calcolato:                 |
//|   z = (delta - media(delta,n)) / deviazione(delta,n)              |
//| Deviazione nulla -> NON CALCOLABILE (false), e chi chiama lo      |
//| conta in colonna. Restituire 0 sarebbe peggio: 0 e' "perfettamente|
//| allineati", cioe' la condizione di USCITA. Un indefinito letto    |
//| come uscita chiuderebbe posizioni che nessuno ha chiuso.          |
//+------------------------------------------------------------------+
bool ZClassico_Calc(const double &d[], const int n, const int fine, const int quante, double &out)
  {
   out = 0.0;
   double media, dev;
   if(!SmaFin_Calc(d, n, fine, quante, media)) return(false);
   if(!StdevFin_Calc(d, n, fine, quante, dev)) return(false);
   if(dev <= 0.0) return(false);
   out = (d[fine] - media)/dev;
   return(true);
  }

//+------------------------------------------------------------------+
//| LO Z-SCORE MODIFICATO (Iglewicz-Hoaglin, terzo Pine):             |
//|   z = 0,6745 * (x - mediana) / MAD                                |
//| Il 0,6745 e' il quartile della normale standard: rende il numero  |
//| CONFRONTABILE con lo z classico, cioe' le stesse soglie in sigma  |
//| significano la stessa cosa nei due modi. Senza quella costante    |
//| l'ablazione confronterebbe due righelli diversi.                  |
//+------------------------------------------------------------------+
bool ZModificato_Calc(const double &d[], const int n, const int fine, const int quante, double &out)
  {
   out = 0.0;
   double med, mad;
   if(!MadFin_Calc(d, n, fine, quante, med, mad)) return(false);
   if(mad <= 0.0) return(false);
   out = 0.6745*(d[fine] - med)/mad;
   return(true);
  }

//+------------------------------------------------------------------+
//| L'ATTRAVERSAMENTO -- ed e' il cuore della PORTATA (par.5.4).      |
//| Non e' uno STATO ("z e' sotto soglia") ma un EVENTO ("z ERA sopra |
//| e ORA e' sotto"): e' questa la differenza fra contare 26 segnali  |
//| grezzi al giorno e contarne 2-3 veri.                             |
//|   lato +1 (LONG)  : zPrec >= -soglia  AND  z <  -soglia           |
//|   lato -1 (SHORT) : zPrec <= +soglia  AND  z >  +soglia           |
//| I confronti sono ASIMMETRICI apposta: uno z fermo ESATTAMENTE     |
//| sulla soglia non attraversa niente, e senza l'asimmetria lo       |
//| stesso z fermo verrebbe contato a ogni barra.                     |
//+------------------------------------------------------------------+
bool Attraversamento_Calc(const double zPrec, const double z, const double soglia, const int lato)
  {
   if(soglia <= 0.0) return(false);
   if(lato > 0) return(zPrec >= -soglia && z < -soglia);
   if(lato < 0) return(zPrec <=  soglia && z >  soglia);
   return(false);
  }

//+------------------------------------------------------------------+
//| LA CONVERGENZA -- la definizione operativa di C6.                 |
//|   long  : rientrato quando z >= -sogliaUscita                     |
//|   short : rientrato quando z <= +sogliaUscita                     |
//| Con sogliaUscita = 0,05 "convergenza" vuol dire "lo scarto e'     |
//| tornato dentro un ventesimo di sigma dalla sua media": e' la      |
//| forma del secondo Pine, riscritta.                                |
//+------------------------------------------------------------------+
bool Convergenza_Calc(const double z, const double sogliaUscita, const int lato)
  {
   if(lato > 0) return(z >= -sogliaUscita);
   if(lato < 0) return(z <=  sogliaUscita);
   return(false);
  }

//+------------------------------------------------------------------+
//| LA FINESTRA ORARIA AL MINUTO (T7). Inizio INCLUSO, fine ESCLUSA.  |
//| Sostiene anche il caso a cavallo della mezzanotte (inizio > fine),|
//| che su questi indici non serve ma che costa due righe.            |
//+------------------------------------------------------------------+
bool InFinestra_Calc(const int ora, const int minuto,
                     const int oraIni, const int minIni,
                     const int oraFin, const int minFin)
  {
   if(ora < 0 || ora > 23 || minuto < 0 || minuto > 59) return(false);
   int m = ora*60 + minuto;
   int a = oraIni*60 + minIni;
   int b = oraFin*60 + minFin;
   if(a == b) return(false);            // finestra nulla: non si conta niente
   if(a < b)  return(m >= a && m < b);
   return(m >= a || m < b);
  }

//+------------------------------------------------------------------+
//| FIX T12 v1.03 -- IL GATE T7 SULLA BARRA D'INGRESSO **REALE**.     |
//|                                                                   |
//| La sonda entra e esce SULL'APERTURA DELLA BARRA SUCCESSIVA (T10), |
//| e "la successiva" e' la barra 0 del terminale (tReale), non       |
//| tSeg + tfSec. Le due coincidono SOLO se lo storico e' pieno: se   |
//| alla gamba manca una barra M15, la barra teorica cade dentro la   |
//| finestra e quella VERA puo' cadere gia' fuori. Chiedere alla      |
//| teorica lasciava aprire una posizione su una barra FUORI          |
//| sessione, che la valutazione dopo chiudeva subito come "fine      |
//| sessione" con lo STESSO timestamp d'ingresso: tenuta 0 secondi e  |
//| 0 barre. Era la causa del collaudo T12 rotto (v1.00 -> v1.02).    |
//|                                                                   |
//| 'contigua' esce a parte perche' MISURA il buco: senza buchi vale  |
//| sempre true e questa funzione risponde esattamente come la        |
//| versione vecchia -- il fix morde SOLO dove c'era il difetto.      |
//+------------------------------------------------------------------+
bool IngressoInFinestra_Calc(const datetime tSeg, const datetime tReale, const int tfSec,
                             const int oraIni, const int minIni,
                             const int oraFin, const int minFin,
                             bool &contigua)
  {
   contigua = (tfSec > 0 && tReale == tSeg + tfSec);
   if(tReale <= tSeg) return(false);    // barra 0 non piu' avanti della barra di segnale: non e' un ingresso
   MqlDateTime t; TimeToStruct(tReale, t);
   return(InFinestra_Calc(t.hour, t.min, oraIni, minIni, oraFin, minFin));
  }

//+------------------------------------------------------------------+
//| FIX T12 v1.03 -- LA TENUTA IN SECONDI SI DERIVA DALLE BARRE       |
//| EFFETTIVAMENTE VALUTATE, non dalla differenza di calendario fra   |
//| il timestamp d'ingresso e quello d'uscita.                        |
//|                                                                   |
//| Il perche' e' la stessa cosa che ha rotto il gate C2: con un buco |
//| nello storico (barra mancante, festivo del metro, salto di        |
//| sessione) la differenza di calendario misura IL BUCO, non la      |
//| posizione. Una posizione viva 3 barre M15 e' viva 2700 secondi    |
//| anche se in mezzo il feed ha saltato mezz'ora.                    |
//| Conseguenza voluta: l'unico modo di restare "sotto 60 secondi" e' |
//| barre = 0, cioe' una posizione chiusa senza aver mai valutato una |
//| barra -- che e' un difetto vero, e resta il collaudo T12.         |
//+------------------------------------------------------------------+
long TenutaSecondi_Calc(const int barre, const int tfSec)
  {
   if(barre <= 0 || tfSec <= 0) return(0);
   return((long)barre*(long)tfSec);
  }

//+------------------------------------------------------------------+
//| TRUE RANGE. Prima barra della coda: high-low (non c'e' chiusura   |
//| precedente).                                                      |
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
//| ATR. modoRma = true -> Wilder/RMA. false -> media mobile SEMPLICE |
//| del TR, che secondo la misura T3 di ABTG_SondaM0PB e' la          |
//| convenzione di iATR in MQL5 (vedi T13).                           |
//+------------------------------------------------------------------+
bool AtrSerie_Calc(const double &tr[], const int n, const int periodo,
                   const bool modoRma, double &out[])
  {
   if(periodo < 1 || n < periodo) return(false);
   if(ArrayResize(out, n) != n) return(false);
   for(int i = 0; i < n; i++) out[i] = 0.0;

   double s = 0.0;
   for(int i = 0; i < periodo; i++) s += tr[i];
   out[periodo - 1] = s/(double)periodo;

   if(modoRma)
     {
      double a = 1.0/(double)periodo;
      for(int i = periodo; i < n; i++) out[i] = out[i-1] + a*(tr[i] - out[i-1]);
     }
   else
     {
      double somma = s;
      for(int i = periodo; i < n; i++)
        {
         somma += tr[i] - tr[i - periodo];
         out[i] = somma/(double)periodo;
        }
     }
   return(true);
  }

//+------------------------------------------------------------------+
//| Da differenza di PREZZO a PUNTI INDICE (T14).                     |
//+------------------------------------------------------------------+
double PuntiIndice_Calc(const double diffPrezzo, const double puntoIndice)
  {
   if(puntoIndice <= 0.0) return(0.0);
   return(diffPrezzo/puntoIndice);
  }

//+------------------------------------------------------------------+
//| RR = mediana(MFE) / mediana(MAE). E' definito COSI' nel dossier   |
//| (numero 3 diviso numero 4), non come mediana dei rapporti.        |
//+------------------------------------------------------------------+
double RrDaMediane_Calc(const double mfeMediana, const double maeMediana)
  {
   if(maeMediana <= 0.0) return(0.0);
   return(mfeMediana/maeMediana);
  }

//+------------------------------------------------------------------+
//| L'ARITMETICA DEL CANCELLO H8. Da E = p*RR - (1-p) segue           |
//| p = (E+1)/(RR+1): il win rate NECESSARIO perche' il valore atteso |
//| raggiunga E. Riproduce la tabella CONGELATA nel dossier:          |
//|   RR 0,36 -> 79,0% | 0,50 -> 71,7% | 0,73 -> 62,2% | 1,00 -> 53,8%|
//| L'autotest confronta con QUEI quattro valori: se la formula si    |
//| muove, il cancello se ne accorge.                                 |
//+------------------------------------------------------------------+
double WinRateNecessario_Calc(const double rr, const double eTarget)
  {
   if(rr <= -1.0) return(0.0);
   return((eTarget + 1.0)/(rr + 1.0));
  }

//+------------------------------------------------------------------+
//| LO SPREAD MISURATO del simbolo SCAMBIATO, dalla tabella congelata |
//| in testa al file (mediana oraria PEGGIORE fra le 14 e le 21 ora   |
//| server, dai CSV di SPREAD_FLOTTA del 03/09/2026).                 |
//| Simbolo non in tabella -> -1, e la sonda si RIFIUTA di partire:   |
//| un cancello non si inventa su un simbolo non misurato.            |
//| StringFind e non uguaglianza: regge i suffissi di broker          |
//| ("D30EUR.cash"), e la scelta e' dichiarata perche' un giorno un   |
//| simbolo con nome contenente un altro nome farebbe danno.          |
//+------------------------------------------------------------------+
double SpreadMisurato_Calc(const string simbolo)
  {
   if(StringFind(simbolo, "D30EUR") >= 0) return(REL_SPREAD_D30EUR);
   if(StringFind(simbolo, "NASUSD") >= 0) return(REL_SPREAD_NASUSD);
   if(StringFind(simbolo, "U30USD") >= 0) return(REL_SPREAD_U30USD);
   return(-1.0);
  }

//+------------------------------------------------------------------+
//| AGGIORNAMENTO DI UN'ESCURSIONE (MFE/MAE) con una barra chiusa.    |
//| MFE e MAE escono ENTRAMBI come distanze POSITIVE in punti indice: |
//| il segno lo porta il lato, non il numero, altrimenti la mediana   |
//| del MAE avrebbe un segno che nessuno ricorda al momento di        |
//| leggerla. Una barra che non spinge da nessuna parte non abbassa   |
//| niente: sono MASSIMI, non medie.                                  |
//+------------------------------------------------------------------+
void AggiornaEscursione_Calc(const int lato, const double prezzoIngresso,
                             const double high, const double low,
                             const double puntoIndice,
                             double &mfe, double &mae)
  {
   if(lato > 0)
     {
      double f = PuntiIndice_Calc(high - prezzoIngresso, puntoIndice);
      double a = PuntiIndice_Calc(prezzoIngresso - low,  puntoIndice);
      if(f > mfe) mfe = f;
      if(a > mae) mae = a;
     }
   else if(lato < 0)
     {
      double f = PuntiIndice_Calc(prezzoIngresso - low,  puntoIndice);
      double a = PuntiIndice_Calc(high - prezzoIngresso, puntoIndice);
      if(f > mfe) mfe = f;
      if(a > mae) mae = a;
     }
  }

//+------------------------------------------------------------------+
//| L'ALLINEAMENTO DEI DUE FEED -- LA FUNZIONE PIU' IMPORTANTE DEL    |
//| FILE, e non e' la formula.                                        |
//| Ha in ingresso i tempi della GAMBA (ty, n valori crescenti) e i   |
//| tempi + chiusure del METRO (tx, cx, nx valori crescenti) e        |
//| riempie xa[i] con la chiusura del metro che ha ESATTAMENTE lo     |
//| stesso timestamp di ty[i]. Dove non c'e', valido[i] = false.      |
//| Restituisce anche quante barre del METRO non hanno gemella sulla  |
//| GAMBA (soloMetro): e' l'altra meta' dei giorni spaiati, quella    |
//| che si dimentica sempre perche' non rompe niente.                 |
//| Scansione a due indici, O(n+nx): le due serie sono ordinate.      |
//|                                                                   |
//| >>> 'daConta' NON E' UN DETTAGLIO: E' UNA CORREZIONE DEL 03/09     |
//| (audit di completamento della sonda). soloMetro si conta SOLO da   |
//| ty[daConta] in avanti, cioe' sullo SPAN che lo z-score guarda      |
//| davvero. Contandolo su tutta la coda di warmup (300 barre = 25 ore |
//| a M5) verrebbe un numero ENORME e SEMPRE positivo: quella coda     |
//| attraversa la NOTTE, e di notte il metro (U30USD, quasi 24h) ha    |
//| barre che la gamba (D30EUR, cash EU) non puo' avere. Con quel      |
//| conteggio "Giorni Spaiati" verrebbe 100% tutti i giorni: un numero |
//| vero che risponde alla DOMANDA SBAGLIATA, perche' C2 deve misurare |
//| i CALENDARI (4 luglio, Thanksgiving), non gli orari di quotazione. |
//| daConta fuori dominio -> si conta da 0. Mai in silenzio.           |
//+------------------------------------------------------------------+
bool AllineaSerie_Calc(const datetime &ty[], const int n,
                       const datetime &tx[], const double &cx[], const int nx,
                       const int daConta,
                       double &xa[], bool &valido[], int &allineate, int &soloMetro)
  {
   allineate = 0; soloMetro = 0;
   if(n < 1) return(false);
   if(ArrayResize(xa, n) != n) return(false);
   if(ArrayResize(valido, n) != n) return(false);
   for(int i = 0; i < n; i++){ xa[i] = 0.0; valido[i] = false; }
   int      dc  = (daConta < 0 || daConta >= n) ? 0 : daConta;
   datetime tDa = ty[dc];
   if(nx < 1) return(true);          // nessuna barra del metro: tutto invalido, e non e' un errore di codice

   int j = 0;
   for(int i = 0; i < n; i++)
     {
      while(j < nx && tx[j] < ty[i]){ if(tx[j] >= tDa) soloMetro++; j++; }
      if(j < nx && tx[j] == ty[i])
        {
         xa[i] = cx[j];
         valido[i] = true;
         allineate++;
         j++;
        }
     }
   while(j < nx){ if(tx[j] >= tDa) soloMetro++; j++; }
   return(true);
  }

//+------------------------------------------------------------------+
//| FIX C2 v1.01 (04/09) -- IL GIORNO DI FESTA DEL METRO NON E' UN    |
//| GIORNO SPAIATO.                                                    |
//| Il referto REFERTO_SONDARELATIVO_D30_M15.txt ha misurato C2 fino   |
//| al 60,50% su D30EUR (gamba, DAX) x U30USD (metro, Dow): la CAUSA   |
//| e' che DAX e Dow hanno calendari di festivita' DIVERSI (4 luglio,  |
//| Thanksgiving, Ferragosto tedesco...). Finora OGNI barra con metro  |
//| mancante (controllo su 'ultimaValida') o OGNI buco nello span      |
//| dello z-score (controllo su 'spanOk'), entrambi dentro             |
//| ValutaBarraChiusa piu' sotto, marcavano l'INTERA giornata           |
//| "spaiata", SENZA distinguere due casi diversi:                     |
//|   (a) il METRO non ha MAI quotato quel giorno di calendario -> il  |
//|       suo mercato era CHIUSO per festivita' propria. FISIOLOGICO,  |
//|       non e' un difetto del feed (T3/T15 gia' escludono cosi' le   |
//|       festivita' della GAMBA dal denominatore; qui si fa lo        |
//|       stesso ragionamento per il METRO, sul lato NUMERATORE).      |
//|   (b) il METRO ha quotato ALTRE barre quel giorno, ma proprio      |
//|       quella barra/quello span ha un buco -> difetto vero del      |
//|       feed, e QUESTO deve restare "spaiato".                       |
//| La distinzione si fa SENZA calendari esterni: basta guardare se    |
//| tx[] (le barre del metro gia' scaricate per la coda) contiene      |
//| ALMENO una barra nello stesso giorno di calendario del SERVER.     |
//| Se non c'e' nessuna barra quel giorno, il mercato del metro era    |
//| chiuso: e' la stessa logica della clausola SICURA del compito      |
//| (punto 4): il denominatore (giorni con barre della GAMBA, T15)     |
//| NON cambia; cambia SOLO chi entra nel numeratore "spaiato".        |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| Costruisce, scandendo tx[] UNA sola volta (tx e' crescente, come   |
//| tutte le serie qui), l'elenco ORDINATO e SENZA DOPPIONI dei giorni |
//| di calendario (anno*1000+giorno dell'anno) in cui il METRO ha      |
//| ALMENO una barra. E' la stessa scansione O(nx) gia' pagata per     |
//| AllineaSerie_Calc: costo aggiuntivo trascurabile.                  |
//|                                                                    |
//| >>> 'soloFinestra' E' IL FIX v1.02, E NON E' UN DETTAGLIO: E' LA   |
//| DIFFERENZA FRA UNA DOMANDA VUOTA E UNA DOMANDA VERA.                |
//| Con soloFinestra = false si ottiene ESATTAMENTE il criterio della   |
//| v1.01 ("il metro ha quotato in un qualsiasi momento di quel giorno  |
//| di calendario?"). Su una coppia in cui il METRO e' un CFD quasi 24h |
//| (U30USD) quella domanda ha risposta SEMPRE SI', anche nel giorno in |
//| cui il mercato cash americano era chiuso per festa: il CFD stampa   |
//| comunque le barre notturne, e la coda di 300 barre della gamba le   |
//| contiene sempre (la barra di segnale sta sempre dopo le 14:30       |
//| server). Ecco perche' la v1.01 non ha spostato nemmeno un centesimo.|
//| Con soloFinestra = true si guarda SOLO dentro la finestra oraria in |
//| cui la sonda valuta (T7/T8): li' "nessuna barra del metro" vuol     |
//| dire davvero "il suo mercato era chiuso mentre noi guardavamo",     |
//| che e' la festivita' propria che T3 voleva escludere da C2.         |
//| Il denominatore di C2 (giorni con barre della GAMBA, T15) NON       |
//| cambia in nessuno dei due modi.                                     |
//+------------------------------------------------------------------+
void GiorniMetroAttivi_Calc(const datetime &tx[], const int nx,
                            const bool soloFinestra,
                            const int oraIni, const int minIni,
                            const int oraFin, const int minFin,
                            int &giorni[], int &nGiorni)
  {
   nGiorni = 0;
   int cap = 32;
   if(ArrayResize(giorni, cap) < cap){ ArrayResize(giorni, 0); return; }
   int ultimo = -1;
   for(int i = 0; i < nx; i++)
     {
      MqlDateTime g; TimeToStruct(tx[i], g);
      //--- v1.02: le barre fuori finestra non fanno testo. Non alterano
      //    l'ordinamento: si SALTANO, e i giorni superstiti restano
      //    crescenti (tx e' crescente), quindi la ricerca binaria sotto
      //    resta valida.
      if(soloFinestra && !InFinestra_Calc(g.hour, g.min, oraIni, minIni, oraFin, minFin)) continue;
      int stamp = g.year*1000 + g.day_of_year;
      if(stamp == ultimo) continue;   // stessa giornata della barra precedente: niente doppioni
      ultimo = stamp;
      if(nGiorni >= cap)
        {
         cap *= 2;
         if(ArrayResize(giorni, cap) < cap) break;   // capacita' esaurita: caso limite, non urla, si ferma
        }
      giorni[nGiorni] = stamp;
      nGiorni++;
     }
  }

//+------------------------------------------------------------------+
//| Il metro ha quotato ALMENO una barra nel giorno 'stamp'? giorni[]  |
//| e' ordinato crescente (viene da tx[] crescente): ricerca binaria.  |
//+------------------------------------------------------------------+
bool GiornoMetroAttivo_Calc(const int &giorni[], const int nGiorni, const int stamp)
  {
   int lo = 0, hi = nGiorni - 1;
   while(lo <= hi)
     {
      int mid = (lo + hi) / 2;
      if(giorni[mid] == stamp) return(true);
      if(giorni[mid] <  stamp) lo = mid + 1; else hi = mid - 1;
     }
   return(false);
  }

//+------------------------------------------------------------------+
//| QUANTE BARRE INDIETRO GUARDA LO Z-SCORE. Non e' un dettaglio: e'  |
//| l'ampiezza su cui si pretende l'allineamento dei due feed (T2).   |
//|   modo rapporto : delta[k] serve su n barre, e ogni delta serve   |
//|                   n barre di serie -> 2n, +1 per lo z precedente  |
//|   modo beta OLS : ogni valore di serie serve a sua volta n barre  |
//|                   di y e x -> 3n, +1                              |
//+------------------------------------------------------------------+
int SpanRichiesto_Calc(const int finestra, const int modoSpread)
  {
   if(finestra < 1) return(0);
   if(modoSpread == 1) return(3*finestra + 1);
   return(2*finestra + 1);
  }

//+------------------------------------------------------------------+
//| LO Z-SCORE DELLE DUE ULTIME BARRE, che e' tutto quello che serve  |
//| per riconoscere un ATTRAVERSAMENTO.                               |
//| Catena, identica nei due modi salvo il primo anello:              |
//|   serie[k] = y[k]/x[k]            (modo 0)                        |
//|            = sma(y,n)[k] - beta[k]*sma(x,n)[k]   (modo 1)         |
//|   delta[k] = serie[k] - sma(serie,n)[k]                           |
//|   z[k]     = (delta[k] - sma(delta,n)[k]) / stdev(delta,n)[k]     |
//|            oppure 0,6745*(delta[k]-mediana)/MAD  (modo z 1)       |
//| Ritorna false se un solo anello non e' calcolabile: mezza catena  |
//| non e' un mezzo segnale, e' nessun segnale.                       |
//+------------------------------------------------------------------+
bool ZDueBarre_Calc(const double &y[], const double &x[], const int n, const int fine,
                    const int finestra, const int modoSpread, const int modoZ,
                    double &z, double &zPrec)
  {
   z = 0.0; zPrec = 0.0;
   if(finestra < 1 || fine < 1 || fine >= n) return(false);
   int span = SpanRichiesto_Calc(finestra, modoSpread);
   if(fine - span + 1 < 0) return(false);

   //--- 1) la serie, su 2n valori che finiscono in 'fine'
   int nS = 2*finestra;
   double s[];
   if(ArrayResize(s, nS) != nS) return(false);
   for(int k = 0; k < nS; k++)
     {
      int idx = fine - nS + 1 + k;      // 'idx' e non 'abs': 'abs' e' un
                                        // nome troppo vicino alle funzioni
                                        // matematiche di MQL5 per usarlo
                                        // come variabile.
      double v;
      if(modoSpread == 1)
        { if(!SpreadOls_Calc(x, y, n, idx, finestra, v)) return(false); }
      else
        { if(!Rapporto_Calc(y[idx], x[idx], v))          return(false); }
      s[k] = v;
     }

   //--- 2) lo scarto dalla sua media, su n+1 valori che finiscono in 'fine'
   int nD = finestra + 1;
   double d[];
   if(ArrayResize(d, nD) != nD) return(false);
   for(int k = 0; k < nD; k++)
     {
      int locale = nS - nD + k;          // indice dentro s[]
      double media;
      if(!SmaFin_Calc(s, nS, locale, finestra, media)) return(false);
      d[k] = s[locale] - media;
     }

   //--- 3) la normalizzazione, sulle DUE ultime posizioni
   if(modoZ == 1)
     {
      if(!ZModificato_Calc(d, nD, nD-1, finestra, z))     return(false);
      if(!ZModificato_Calc(d, nD, nD-2, finestra, zPrec)) return(false);
     }
   else
     {
      if(!ZClassico_Calc(d, nD, nD-1, finestra, z))       return(false);
      if(!ZClassico_Calc(d, nD, nD-2, finestra, zPrec))   return(false);
     }
   return(true);
  }

//==================================================================
//  RACCOLTA DEI CAMPIONI (memoria, non pensiero)
//==================================================================
void Aggiungi(double &v[], int &n, const double x)
  {
   if(n >= REL_MAX_CAMPIONI){ gTroncato = true; return; }
   if(n >= ArraySize(v))
     {
      int nuovo = (ArraySize(v) <= 0) ? 4096 : ArraySize(v)*2;
      if(nuovo > REL_MAX_CAMPIONI) nuovo = REL_MAX_CAMPIONI;
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
//| In ottimizzazione MT5 rilancia l'EA a ogni passata e le globali    |
//| DOVREBBERO ripartire dai valori iniziali. Con due assi sweepati    |
//| (finestra n e soglia in sigma) una passata che ereditasse i        |
//| campioni della precedente darebbe mediane sporche e PLAUSIBILI:    |
//| nessuno se ne accorgerebbe guardando il CSV. Azzerare a mano costa |
//| una funzione e toglie il dubbio.                                   |
//+------------------------------------------------------------------+
void AzzeraContatori()
  {
   gLastBar = 0;
   gBarreValutate = 0; gBarreFuoriFinestra = 0; gBarreSaltateDati = 0;
   gMetroMancantiUltima = 0; gValutazioniPerseBuco = 0; gValutazioniSoloMetro = 0;
   gBarreSenzaZAperta = 0; gZNonCalcolabile = 0;
   gGrezziL = 0; gGrezziS = 0; gEseguibiliL = 0; gEseguibiliS = 0;
   gOccupatoStessoL = 0; gOccupatoStessoS = 0; gOccupatoAltroLato = 0;
   gAttrIngressoFuori = 0; gAttrPrimaBarra = 0; gIngressoBarraRealeFuori = 0;
   gChiuseL = 0; gChiuseS = 0; gConvergL = 0; gConvergS = 0;
   gFineSessL = 0; gFineSessS = 0; gTettoL = 0; gTettoS = 0;
   gFineCorsa = 0; gSotto60L = 0; gSotto60S = 0; gChiuseZeroBarre = 0;
   gDayStamp = -1; gDaySpaiato = false; gDayFestaMetro = false; gDayMetroZeroCal = false;
   gDayEseL = 0; gDayEseS = 0;
   gGiorniContati = 0; gGiorniSpaiati = 0; gGiorniFestaMetro = 0; gGiorniMetroZeroCal = 0;
   gMaxGiornoL = 0; gMaxGiornoS = 0; gMaxGiornoTot = 0;
   gGiorni2Tot = 0; gGiorniZero = 0;
   gNMfeL = 0; gNMfeS = 0; gNMaeL = 0; gNMaeS = 0;
   gNTenL = 0; gNTenS = 0;
   gNMfeOrL = 0; gNMfeOrS = 0; gNMaeOrL = 0; gNMaeOrS = 0; gNMovOrL = 0; gNMovOrS = 0;
   gNAtr = 0; gTroncato = false;
   gAtrDivRelSom = 0.0; gAtrDivN = 0;
   gAutotestFalliti = -1; gAutotestBlocchi = 0;
   gPosAttiva = false; gPosLato = 0; gPosTIngr = 0; gPosPrezzo = 0.0;
   gPosZIngr = 0.0; gPosBarre = 0; gPosMfe = 0.0; gPosMae = 0.0; gPosAtr = 0.0;
   gOsIncompletiL = 0; gOsIncompletiS = 0;
   for(int i = 0; i < ArraySize(gOsAttivo); i++) gOsAttivo[i] = false;
  }

int OnInit()
  {
   //--- CANCELLI DI CONFIGURAZIONE: rifiutano, non correggono in
   //    silenzio. Un default nascosto e' una misura che dice un'altra
   //    cosa da quella scritta nel file prova.
   if(InpSimboloMetro == "" || InpSimboloMetro == _Symbol)
     {
      Print("ERRORE: InpSimboloMetro deve essere un simbolo DIVERSO da quello del grafico. Il metro si legge, la gamba si scambia (T4): se coincidono il rapporto vale 1 e non esiste nessun segnale.");
      return(INIT_FAILED);
     }
   if(InpModoSpread != 0 && InpModoSpread != 1)
     { Print("ERRORE: InpModoSpread ammette solo 0 (rapporto) o 1 (beta OLS)."); return(INIT_FAILED); }
   if(InpModoZScore != 0 && InpModoZScore != 1)
     { Print("ERRORE: InpModoZScore ammette solo 0 (media/deviazione) o 1 (mediana/MAD)."); return(INIT_FAILED); }
   if(InpFinestraN < 5 || InpFinestraN > 200)
     { Print("ERRORE: InpFinestraN deve stare fra 5 e 200. Sotto 5 la deviazione e' rumore, sopra 200 la finestra non e' piu' intraday."); return(INIT_FAILED); }
   if(InpSogliaIngressoSigma <= 0.0 || InpSogliaIngressoSigma > 5.0)
     { Print("ERRORE: InpSogliaIngressoSigma deve stare fra 0 (escluso) e 5,0 sigma."); return(INIT_FAILED); }
   if(InpSogliaUscitaSigma < 0.0 || InpSogliaUscitaSigma >= InpSogliaIngressoSigma)
     { Print("ERRORE: InpSogliaUscitaSigma deve stare fra 0 e la soglia d'ingresso (esclusa): altrimenti l'uscita scatterebbe nello stesso istante dell'ingresso."); return(INIT_FAILED); }
   if(InpOraInizioServer < 0 || InpOraInizioServer > 23 || InpOraFineServer < 0 || InpOraFineServer > 23 ||
      InpMinInizioServer < 0 || InpMinInizioServer > 59 || InpMinFineServer < 0 || InpMinFineServer > 59)
     { Print("ERRORE: la finestra deve stare in ore 0-23 e minuti 0-59, ed e' ORA SERVER (BCM = ora italiana - 1)."); return(INIT_FAILED); }
   if(InpOraInizioServer*60 + InpMinInizioServer == InpOraFineServer*60 + InpMinFineServer)
     { Print("ERRORE: finestra nulla (inizio uguale a fine): non si conterebbe niente."); return(INIT_FAILED); }
   if(InpBarreMaxTenuta < 1 || InpBarreMaxTenuta > 5000)
     { Print("ERRORE: InpBarreMaxTenuta deve stare fra 1 e 5000."); return(INIT_FAILED); }
   if(InpBarreOrizzonte < 1 || InpBarreOrizzonte > 500)
     { Print("ERRORE: InpBarreOrizzonte deve stare fra 1 e 500."); return(INIT_FAILED); }
   if(InpLato < 0 || InpLato > 2)
     { Print("ERRORE: InpLato ammette 0 (entrambi), 1 (solo long) o 2 (solo short)."); return(INIT_FAILED); }
   if(InpPuntiPerIndice <= 0.0)
     { Print("ERRORE: InpPuntiPerIndice deve essere > 0 (misurato = 100 su U30USD/NASUSD/D30EUR)."); return(INIT_FAILED); }
   if(InpAtrPeriod < 2)
     { Print("ERRORE: InpAtrPeriod deve essere >= 2."); return(INIT_FAILED); }

   //--- la coda deve bastare allo z-score PIU' un margine vero.
   //    Lo span e' 2n (o 3n in beta OLS) piu' una barra per lo z
   //    precedente: vedi SpanRichiesto_Calc.
   int minimo = SpanRichiesto_Calc(InpFinestraN, InpModoSpread) + InpAtrPeriod + 40;
   if(InpWarmupBarre < minimo)
     {
      PrintFormat("ERRORE: InpWarmupBarre = %d e' troppo corto: con finestra %d e modo spread %d servono almeno %d barre.",
                  InpWarmupBarre, InpFinestraN, InpModoSpread, minimo);
      return(INIT_FAILED);
     }
   if(InpWarmupBarre > 3000)
     { Print("ERRORE: InpWarmupBarre sopra 3000 rallenta la corsa senza guadagnare precisione."); return(INIT_FAILED); }

   AzzeraContatori();

   //--- conversione in punti indice, e la si DICHIARA subito (T14).
   gPuntoIndice = InpPuntiPerIndice*_Point;
   if(gPuntoIndice <= 0.0)
     { Print("ERRORE: punto indice non calcolabile (SYMBOL_POINT nullo)."); return(INIT_FAILED); }
   if(MathAbs(gPuntoIndice - 1.0) > 0.001)
      Log(StringFormat("ATTENZIONE: il punto indice vale %.5f in prezzo, NON 1,00. Sui tre indici (Point %.5f, conversione 100) deve venire 1,00. Se non viene, MFE e MAE escono sbagliati di un fattore: controllare InpPuntiPerIndice PRIMA di leggere qualunque numero.",
                       gPuntoIndice, _Point));

   //--- IL CANCELLO C3 SI PRENDE DALLA TABELLA CONGELATA, e se il
   //    simbolo non e' misurato la sonda NON PARTE. Misurare la taglia
   //    contro uno spread inventato e' esattamente l'errore che il
   //    debito del 23/08 ha lasciato aperto per otto cacce.
   gSpreadMisurato = SpreadMisurato_Calc(_Symbol);
   if(gSpreadMisurato <= 0.0)
     {
      PrintFormat("ERRORE: lo spread di %s NON e' nella tabella MISURATA in testa al sorgente (D30EUR / NASUSD / U30USD, SPREAD_FLOTTA del 03/09/2026). Il cancello C3 e' 3 x spread: su un simbolo non misurato sarebbe una convenzione travestita da misura. Misurare prima, poi tornare qui.", _Symbol);
      return(INIT_FAILED);
     }
   gSogliaC3 = REL_C3_MULTIPLO_SCARTO*gSpreadMisurato;

   gTfSec = PeriodSeconds(PERIOD_CURRENT);
   if(gTfSec <= 0)
     { Print("ERRORE: durata del timeframe non leggibile."); return(INIT_FAILED); }

   //--- IL METRO IN MARKET WATCH. Senza questo, nel tester il secondo
   //    simbolo semplicemente non esiste e ogni barra risulterebbe
   //    "spaiata": un errore di configurazione travestito da misura di
   //    calendario. Si fallisce forte, non si conta piano.
   if(!SymbolSelect(InpSimboloMetro, true))
     {
      PrintFormat("ERRORE: il simbolo METRO '%s' non e' selezionabile (errore %d). Nel tester va scaricato lo storico del SECONDO simbolo prima della corsa.",
                  InpSimboloMetro, GetLastError());
      return(INIT_FAILED);
     }
   if(!SymbolInfoInteger(InpSimboloMetro, SYMBOL_SELECT))
     {
      PrintFormat("ERRORE: il simbolo METRO '%s' risulta non selezionato dopo SymbolSelect.", InpSimboloMetro);
      return(INIT_FAILED);
     }

   //--- LA PROFONDITA' DELLO STORICO DEL METRO -- e' un debito aperto
   //    dalla bozza: "@DAQUANDO 2024.09.26 e' misurato su D30EUR e
   //    NASUSD; su U30USD NON e' stato verificato in questa caccia".
   //    Qui si legge e si dichiara. Nel tester la serie del secondo
   //    simbolo puo' non essere ancora sincronizzata a OnInit: per
   //    questo il numero VERO esce in colonna da OnTester, e questo e'
   //    solo un log.
   datetime primaMetro = (datetime)SeriesInfoInteger(InpSimboloMetro, PERIOD_CURRENT, SERIES_FIRSTDATE);
   Log(StringFormat("METRO '%s': prima barra dichiarata dal terminale a OnInit = %s (se e' 1970 la serie non e' ancora sincronizzata: il numero che vale e' la colonna 'Metro Prima Barra Epoch').",
                    InpSimboloMetro, (primaMetro > 0 ? TimeToString(primaMetro, TIME_DATE|TIME_MINUTES) : "non disponibile")));

   //--- l'unico handle del file, e non decide NIENTE: serve al
   //    collaudo T13 (la colonna di divergenza dell'ATR).
   if(InpConfrontaMT5)
     {
      hAtrMt5 = iATR(_Symbol, PERIOD_CURRENT, InpAtrPeriod);
      if(hAtrMt5 == INVALID_HANDLE)
         Log("ATTENZIONE: handle iATR non creato. La colonna di divergenza restera' a 0, cioe' IL COLLAUDO T13 NON E' STATO FATTO (che non e' 'passato').");
     }

   //--- gli OSSERVATORI di orizzonte: al massimo ne vivono
   //    InpBarreOrizzonte+2 insieme (uno per barra), e non uno di piu'.
   gOsMax = InpBarreOrizzonte + 2;
   ArrayResize(gOsAttivo,  gOsMax);
   ArrayResize(gOsLato,    gOsMax);
   ArrayResize(gOsPrezzo,  gOsMax);
   ArrayResize(gOsRimaste, gOsMax);
   ArrayResize(gOsMfe,     gOsMax);
   ArrayResize(gOsMae,     gOsMax);
   for(int i = 0; i < gOsMax; i++) gOsAttivo[i] = false;

   ArrayResize(gMfeL,0);  ArrayResize(gMfeS,0);  ArrayResize(gMaeL,0);  ArrayResize(gMaeS,0);
   ArrayResize(gTenL,0);  ArrayResize(gTenS,0);
   ArrayResize(gMfeOrL,0);ArrayResize(gMfeOrS,0);ArrayResize(gMaeOrL,0);ArrayResize(gMaeOrS,0);
   ArrayResize(gMovOrL,0);ArrayResize(gMovOrS,0);ArrayResize(gAtrPts,0);

   if(InpAutoTest) AutoTestRelativo();

   Log(StringFormat("SONDA RELATIVO avviata: GAMBA %s (si scambia) contro METRO %s (si legge), %s. Etichetta '%s'. NON APRE ORDINI: e' un contatore.",
                    _Symbol, InpSimboloMetro, EnumToString((ENUM_TIMEFRAMES)Period()), InpTag));
   Log(StringFormat("motore: %s -> scarto dalla sua media -> z-score %s su finestra n=%d | ingresso all'ATTRAVERSAMENTO di %.2f sigma | convergenza a %.2f sigma | tetto tenuta %d barre | orizzonte %d barre.",
                    (InpModoSpread == 1 ? "spread beta OLS" : "rapporto gamba/metro"),
                    (InpModoZScore == 1 ? "MODIFICATO mediana/MAD" : "classico media/deviazione"),
                    InpFinestraN, InpSogliaIngressoSigma, InpSogliaUscitaSigma,
                    InpBarreMaxTenuta, InpBarreOrizzonte));
   Log(StringFormat("finestra %02d:%02d -> %02d:%02d ORA SERVER BCM (= ora italiana - 1), inizio incluso e fine ESCLUSA.",
                    InpOraInizioServer, InpMinInizioServer, InpOraFineServer, InpMinFineServer));
   Log(StringFormat("cancelli CONGELATI: C1 eseguibili/giorno (somma lati) >= %.2f | C3 MFE mediana >= %.2f punti indice (= %.1f x spread MISURATO %.2f di %s, ora peggiore 14-21) | C5 RR >= %.2f | C6 non convergute <= %.0f%% | C8 tenuta >= %.0f barre e sotto-60s < %.0f%%.",
                    REL_C1_ESEGUIBILI_GIORNO, gSogliaC3, REL_C3_MULTIPLO_SCARTO, gSpreadMisurato, _Symbol,
                    REL_C5_RR_MINIMO, REL_C6_NON_CONVERGUTE_KO, REL_C8_TENUTA_BARRE_MIN, REL_C8_QUOTA_SOTTO60_KO));

   //--- il CSV riga-per-segnale esiste SOLO fuori dall'ottimizzazione:
   //    con piu' passate che condividono lo stesso file ogni passata
   //    sovrascriverebbe la precedente (trappola gia' a verbale nel
   //    referto FVGRET).
   if(InpScriviCsv && !MQLInfoInteger(MQL_OPTIMIZATION))
     {
      string f = StringFormat("ABTG_SondaRelativo_%s_%s_%s_segnali.csv",
                              _Symbol, InpSimboloMetro, EnumToString((ENUM_TIMEFRAMES)Period()));
      gCsvSeg = FileOpen(f, FILE_WRITE|FILE_CSV|FILE_ANSI, ";");
      if(gCsvSeg != INVALID_HANDLE)
         FileWrite(gCsvSeg, "ora_ingresso", "lato", "z_ingresso", "prezzo_ingresso",
                   "ora_uscita", "prezzo_uscita", "motivo_uscita", "barre_tenuta",
                   "secondi_tenuta", "secondi_calendario",
                   "mfe_punti_indice", "mae_punti_indice", "atr_punti_indice");
      else
         Log("ATTENZIONE: CSV dei segnali non aperto: il conteggio restera' solo nelle colonne, non ricontabile a mano.");
     }
   else if(InpScriviCsv)
      Log("CSV riga-per-segnale NON scritto: siamo in OTTIMIZZAZIONE e le passate si sovrascriverebbero. I numeri escono nelle colonne di OPTFRAME.");

   return(INIT_SUCCEEDED);
  }

void OnDeinit(const int reason)
  {
   if(hAtrMt5 != INVALID_HANDLE){ IndicatorRelease(hAtrMt5); hAtrMt5 = INVALID_HANDLE; }
   if(gCsvSeg != INVALID_HANDLE){ FileClose(gCsvSeg); gCsvSeg = INVALID_HANDLE; }
  }

//+------------------------------------------------------------------+
//| Un solo gesto per tick: se e' nata una barra nuova, si valuta la  |
//| barra CHIUSA che l'ha preceduta. Su ENTRAMBI i simboli (T1).      |
//+------------------------------------------------------------------+
void OnTick()
  {
   datetime t = iTime(_Symbol, PERIOD_CURRENT, 0);
   if(t == gLastBar || t == 0) return;
   gLastBar = t;
   ValutaBarraChiusa();
  }

//+------------------------------------------------------------------+
//| Chiude la contabilita' della giornata appena finita (T15). E'     |
//| l'unico posto in cui crescono i massimi giornalieri e i giorni    |
//| spaiati: un solo punto da leggere.                                |
//+------------------------------------------------------------------+
void ChiudiGiornata()
  {
   if(gDayStamp == -1) return;
   long tot = (long)gDayEseL + (long)gDayEseS;
   if((long)gDayEseL > gMaxGiornoL) gMaxGiornoL = gDayEseL;
   if((long)gDayEseS > gMaxGiornoS) gMaxGiornoS = gDayEseS;
   if(tot > gMaxGiornoTot) gMaxGiornoTot = tot;
   if(tot >= 2) gGiorni2Tot++;
   if(tot == 0) gGiorniZero++;
   //--- FIX C2 v1.01: se il giorno ha ANCHE un buco vero (gDaySpaiato),
   //    conta come spaiato vero: la severita' resta dalla parte del
   //    difetto. Solo se il giorno e' spiegato INTERAMENTE da festivita'
   //    del metro (nessun buco vero rilevato) va in gGiorniFestaMetro,
   //    che e' informativo e NON entra nel numeratore di C2.
   if(gDaySpaiato)          gGiorniSpaiati++;
   else if(gDayFestaMetro)  gGiorniFestaMetro++;
   //--- CONTROLLO v1.02: conteggio INDIPENDENTE dai due sopra (non e'
   //    un ramo dell'else). Dice quante volte avrebbe morso il criterio
   //    di CALENDARIO della v1.01. Atteso 0 su un metro quasi 24h: se
   //    esce 0, i "numeri identici al centesimo" della v1.01 sono
   //    spiegati da una misura e non da un ragionamento.
   if(gDayMetroZeroCal) gGiorniMetroZeroCal++;
  }

//+------------------------------------------------------------------+
//| Apre la posizione FINTA e l'osservatore di orizzonte. Non tocca   |
//| nessun conto: sono due righe di memoria.                          |
//+------------------------------------------------------------------+
void ApriPosizioneFinta(const int lato, const datetime tIngresso,
                        const double prezzo, const double z, const double atrPrezzo)
  {
   gPosAttiva = true;
   gPosLato   = lato;
   gPosTIngr  = tIngresso;
   gPosPrezzo = prezzo;
   gPosZIngr  = z;
   gPosBarre  = 0;
   gPosMfe    = 0.0;
   gPosMae    = 0.0;
   gPosAtr    = atrPrezzo;

   if(lato > 0) gEseguibiliL++; else gEseguibiliS++;
   if(lato > 0) gDayEseL++;     else gDayEseS++;
   if(atrPrezzo > 0.0) Aggiungi(gAtrPts, gNAtr, PuntiIndice_Calc(atrPrezzo, gPuntoIndice));

   //--- l'OSSERVATORE (T11): vive InpBarreOrizzonte barre e muore da
   //    solo, che la posizione finta sia ancora aperta o no.
   for(int i = 0; i < gOsMax; i++)
     {
      if(gOsAttivo[i]) continue;
      gOsAttivo[i]  = true;
      gOsLato[i]    = lato;
      gOsPrezzo[i]  = prezzo;
      gOsRimaste[i] = InpBarreOrizzonte;
      gOsMfe[i]     = 0.0;
      gOsMae[i]     = 0.0;
      return;
     }
   //--- non puo' succedere (gOsMax = orizzonte+2 e ne nasce al massimo
   //    uno per barra), ma se succedesse sarebbe un campione perso in
   //    silenzio: si urla.
   Log("ATTENZIONE: nessuno slot libero per l'osservatore di orizzonte. La mediana MFE/MAE a orizzonte e' INCOMPLETA e non va letta.");
  }

//+------------------------------------------------------------------+
//| Chiude la posizione FINTA e ne deposita i campioni.               |
//| motivo: 1 = CONVERGENZA | 2 = FINE SESSIONE | 3 = TETTO BARRE     |
//|         4 = FINE CORSA (bordo della corsa, escluso da C6)         |
//+------------------------------------------------------------------+
void ChiudiPosizioneFinta(const int motivo, const datetime tUscita, const double prezzoUscita)
  {
   if(!gPosAttiva) return;

   int    lato = gPosLato;
   //--- FIX T12 v1.03: la tenuta in secondi VIENE DALLE BARRE VALUTATE
   //    (vedi TenutaSecondi_Calc), non dai due timestamp. Il tempo di
   //    calendario grezzo NON si butta: resta accanto, come colonna
   //    separata del CSV riga-per-segnale, perche' la differenza fra i
   //    due numeri E' la misura dei buchi dello storico.
   long   sec    = TenutaSecondi_Calc(gPosBarre, gTfSec);
   long   secCal = (long)(tUscita - gPosTIngr);
   double barre  = (double)gPosBarre;

   if(motivo == 4) gFineCorsa++;
   else
     {
      if(lato > 0)
        {
         gChiuseL++;
         Aggiungi(gMfeL, gNMfeL, gPosMfe);
         Aggiungi(gMaeL, gNMaeL, gPosMae);
         Aggiungi(gTenL, gNTenL, barre);
         if(motivo == 1) gConvergL++;
         if(motivo == 2) gFineSessL++;
         if(motivo == 3) gTettoL++;
         if(sec < 60) gSotto60L++;
        }
      else
        {
         gChiuseS++;
         Aggiungi(gMfeS, gNMfeS, gPosMfe);
         Aggiungi(gMaeS, gNMaeS, gPosMae);
         Aggiungi(gTenS, gNTenS, barre);
         if(motivo == 1) gConvergS++;
         if(motivo == 2) gFineSessS++;
         if(motivo == 3) gTettoS++;
         if(sec < 60) gSotto60S++;
        }
      //--- COLLAUDO T12 in conteggio secco: con la tenuta derivata dalle
      //    barre, "sotto 60 s" e "zero barre" sono lo stesso evento. Si
      //    contano tutte e due perche' una e' una PERCENTUALE (pesa) e
      //    l'altra e' un NUMERO (esiste o non esiste).
      if(gPosBarre <= 0) gChiuseZeroBarre++;
     }

   ScriviSegnale(motivo, tUscita, prezzoUscita, sec, secCal);

   gPosAttiva = false;
   gPosLato   = 0;
   gPosBarre  = 0;
  }

//+------------------------------------------------------------------+
//| Una riga per posizione finta chiusa, cosi' i numeri di C3-C8 si   |
//| possono RICONTARE A MANO da un foglio (regola della               |
//| SondaMediazione, firma di Claudio del 21/08).                     |
//+------------------------------------------------------------------+
void ScriviSegnale(const int motivo, const datetime tUscita,
                   const double prezzoUscita, const long sec, const long secCal)
  {
   if(gCsvSeg == INVALID_HANDLE) return;
   int dgt = (int)SymbolInfoInteger(_Symbol, SYMBOL_DIGITS);
   string mot = "SCONOSCIUTO";
   if(motivo == 1) mot = "CONVERGENZA";
   if(motivo == 2) mot = "FINE_SESSIONE";
   if(motivo == 3) mot = "TETTO_BARRE";
   if(motivo == 4) mot = "FINE_CORSA";
   FileWrite(gCsvSeg,
             TimeToString(gPosTIngr, TIME_DATE|TIME_MINUTES),
             (gPosLato > 0 ? "LONG" : "SHORT"),
             DoubleToString(gPosZIngr, 4),
             DoubleToString(gPosPrezzo, dgt),
             TimeToString(tUscita, TIME_DATE|TIME_MINUTES),
             DoubleToString(prezzoUscita, dgt),
             mot,
             IntegerToString(gPosBarre),
             IntegerToString((int)sec),
             IntegerToString((int)secCal),
             DoubleToString(gPosMfe, 3),
             DoubleToString(gPosMae, 3),
             DoubleToString(PuntiIndice_Calc(gPosAtr, gPuntoIndice), 4));
  }

//+------------------------------------------------------------------+
//| Aggiorna gli osservatori di orizzonte con la barra appena chiusa  |
//| e deposita quelli che hanno COMPLETATO l'orizzonte. 'chiusura' e' |
//| la chiusura della barra: serve al movimento netto a orizzonte,    |
//| che e' l'unico numero SEGNATO di tutta la sonda (positivo = a     |
//| favore del lato).                                                 |
//+------------------------------------------------------------------+
void AggiornaOsservatori(const double high, const double low, const double chiusura)
  {
   for(int i = 0; i < gOsMax; i++)
     {
      if(!gOsAttivo[i]) continue;
      AggiornaEscursione_Calc(gOsLato[i], gOsPrezzo[i], high, low, gPuntoIndice, gOsMfe[i], gOsMae[i]);
      gOsRimaste[i]--;
      if(gOsRimaste[i] > 0) continue;

      double mov = (gOsLato[i] > 0)
                   ? PuntiIndice_Calc(chiusura - gOsPrezzo[i], gPuntoIndice)
                   : PuntiIndice_Calc(gOsPrezzo[i] - chiusura, gPuntoIndice);
      if(gOsLato[i] > 0)
        {
         Aggiungi(gMfeOrL, gNMfeOrL, gOsMfe[i]);
         Aggiungi(gMaeOrL, gNMaeOrL, gOsMae[i]);
         Aggiungi(gMovOrL, gNMovOrL, mov);
        }
      else
        {
         Aggiungi(gMfeOrS, gNMfeOrS, gOsMfe[i]);
         Aggiungi(gMaeOrS, gNMaeOrS, gOsMae[i]);
         Aggiungi(gMovOrS, gNMovOrS, mov);
        }
      gOsAttivo[i] = false;
     }
  }

//+------------------------------------------------------------------+
//| Gli osservatori che la fine sessione taglia PRIMA dell'orizzonte  |
//| NON entrano nelle mediane -- entrerebbero con un'escursione       |
//| troncata, cioe' piu' piccola del vero, e la taglia risulterebbe   |
//| sottostimata proprio nelle ore in cui il motore lavora meno. Si   |
//| contano e basta.                                                  |
//+------------------------------------------------------------------+
void ScartaOsservatoriIncompleti()
  {
   for(int i = 0; i < gOsMax; i++)
     {
      if(!gOsAttivo[i]) continue;
      if(gOsLato[i] > 0) gOsIncompletiL++; else gOsIncompletiS++;
      gOsAttivo[i] = false;
     }
  }

//+------------------------------------------------------------------+
//| Il confronto con l'ATR di serie di MQL5 (collaudo T13).           |
//+------------------------------------------------------------------+
void AggiornaDivergenzaAtr(const double atrMio)
  {
   if(hAtrMt5 == INVALID_HANDLE) return;
   double b[1];
   if(CopyBuffer(hAtrMt5, 0, 1, 1, b) != 1) return;
   if(b[0] <= 0.0) return;
   gAtrDivRelSom += 100.0*MathAbs(b[0] - atrMio)/b[0];
   gAtrDivN++;
  }

//+------------------------------------------------------------------+
//| IL CUORE. Legge la coda di barre della GAMBA, va a prendere le    |
//| barre del METRO, LE ALLINEA PER TIMESTAMP, ricalcola lo z-score   |
//| con le funzioni pure e decide se sulla barra chiusa c'era un      |
//| ATTRAVERSAMENTO. Non apre niente e non chiude niente: conta       |
//| eventi e misura distanze.                                         |
//|                                                                   |
//| L'ORDINE DEI GESTI NON E' CASUALE, ed e' la parte che si sbaglia: |
//|   1. dati della gamba      2. finestra oraria (T7/T8)             |
//|   3. giornata (T15)        4. allineamento col metro (T1/T2/T3)   |
//|   5. z-score               6. aggiornamento posizione/osservatori |
//|   7. USCITE                8. INGRESSI                            |
//| Le uscite PRIMA degli ingressi: una convergenza libera lo slot     |
//| nella stessa barra. Gli osservatori si aggiornano PRIMA che ne    |
//| nasca uno nuovo, altrimenti il nuovo mangerebbe la barra in cui   |
//| non era ancora vivo.                                              |
//+------------------------------------------------------------------+
void ValutaBarraChiusa()
  {
   int n = InpWarmupBarre;

   //--- 1) LA GAMBA. shift 1 = ultima barra CHIUSA (T1): si copiano n
   //    barre che finiscono li'. L'indice n-1 e' la barra di segnale.
   double   high[], low[], close[];
   datetime ty[];
   ArraySetAsSeries(high,  false);
   ArraySetAsSeries(low,   false);
   ArraySetAsSeries(close, false);
   ArraySetAsSeries(ty,    false);
   if(CopyHigh (_Symbol, PERIOD_CURRENT, 1, n, high)  != n ||
      CopyLow  (_Symbol, PERIOD_CURRENT, 1, n, low)   != n ||
      CopyClose(_Symbol, PERIOD_CURRENT, 1, n, close) != n ||
      CopyTime (_Symbol, PERIOD_CURRENT, 1, n, ty)    != n)
     { gBarreSaltateDati++; return; }

   int      iSeg = n - 1;
   datetime tSeg = ty[iSeg];
   if(tSeg <= 0){ gBarreSaltateDati++; return; }

   MqlDateTime ts; TimeToStruct(tSeg, ts);
   datetime tAttesa = tSeg + gTfSec;      // dove CADREBBE la barra d'ingresso
   MqlDateTime ti; TimeToStruct(tAttesa, ti);

   bool inSeg  = InFinestra_Calc(ts.hour, ts.min, InpOraInizioServer, InpMinInizioServer,
                                 InpOraFineServer, InpMinFineServer);
   //--- FIX T12 v1.03: 'inIngrAttesa' e' la risposta della versione
   //    vecchia (barra d'ingresso TEORICA). NON decide piu' niente: si
   //    tiene solo per MISURARE, poco piu' sotto, quante volte differisce
   //    dalla risposta sulla barra REALE. Il gate vero e' 'inIngr', e
   //    nasce dopo tProssima perche' e' su QUELLA barra che si entra.
   bool inIngrAttesa = InFinestra_Calc(ti.hour, ti.min, InpOraInizioServer, InpMinInizioServer,
                                       InpOraFineServer, InpMinFineServer);

   //--- 2) FUORI SESSIONE non si valuta niente (T8), ma NESSUNO STATO
   //    ATTRAVERSA LA NOTTE: la posizione finta e gli osservatori,
   //    se per qualunque motivo fossero ancora vivi, muoiono qui.
   //    In condizioni normali sono gia' chiusi dalla barra precedente
   //    (quella con inIngr = false), e questo blocco non fa niente.
   //    v1.03, E VA SCRITTO: e' proprio da QUI che usciva il collaudo
   //    T12 rotto. Non perche' questa rete sia sbagliata, ma perche' il
   //    gate T7 (allora sulla barra TEORICA) lasciava aprire posizioni
   //    su una barra gia' fuori sessione: alla valutazione dopo quella
   //    barra era la barra di segnale, tSeg coincideva col timestamp
   //    d'ingresso e la chiusura veniva registrata a durata NULLA, per
   //    giunta senza aver mai attraversato il passo 6 (gPosBarre = 0).
   //    Col gate sulla barra REALE questo non e' piu' costruibile; la
   //    rete resta perche' resta il caso di una valutazione saltata per
   //    dati mancanti. Nota dichiarata: qui l'uscita e' segnata sulla
   //    CHIUSURA della barra di segnale e non sull'apertura della
   //    successiva (T10) perche' in questo ramo la barra successiva non
   //    e' nemmeno stata letta; incide solo sul CSV riga-per-segnale,
   //    la tenuta ora viene dalle barre valutate.
   if(!inSeg)
     {
      gBarreFuoriFinestra++;
      if(gPosAttiva) ChiudiPosizioneFinta(2, tSeg, close[iSeg]);
      ScartaOsservatoriIncompleti();
      return;
     }

   //--- il prezzo con cui si entra e si esce: l'apertura della barra
   //    appena nata (T10). Senza di quello non si puo' fare niente.
   double   apProssima = iOpen(_Symbol, PERIOD_CURRENT, 0);
   datetime tProssima  = iTime(_Symbol, PERIOD_CURRENT, 0);
   if(apProssima <= 0.0 || tProssima <= 0){ gBarreSaltateDati++; return; }

   //--- FIX T12 v1.03: IL GATE T7 SULLA BARRA D'INGRESSO **REALE**.
   //    Si entra e si esce su tProssima (T10), quindi e' tProssima che
   //    deve stare dentro la finestra -- non tSeg + gTfSec, che e' dove
   //    la barra CADREBBE se lo storico fosse pieno. Con un buco della
   //    gamba le due divergono, la teorica dice "dentro" e la vera e'
   //    gia' fuori sessione: era cosi' che nasceva una posizione su una
   //    barra fuori finestra, chiusa subito dopo con lo stesso
   //    timestamp d'ingresso (tenuta 0 secondi, 0 barre = T12 rotto).
   bool contiguaIngr = false;
   bool inIngr = IngressoInFinestra_Calc(tSeg, tProssima, gTfSec,
                                         InpOraInizioServer, InpMinInizioServer,
                                         InpOraFineServer,   InpMinFineServer,
                                         contiguaIngr);

   gBarreValutate++;

   //--- 3) LA GIORNATA (T15). Il denominatore di C1 sono i giorni con
   //    almeno una barra valutata DENTRO la finestra.
   bool primaBarraGiorno = false;
   int  stamp = ts.year*1000 + ts.day_of_year;
   if(stamp != gDayStamp)
     {
      ChiudiGiornata();
      gDayStamp = stamp;
      gDaySpaiato = false;
      gDayFestaMetro = false;
      gDayMetroZeroCal = false;
      gDayEseL = 0; gDayEseS = 0;
      gGiorniContati++;
      primaBarraGiorno = true;
     }

   //--- 4) IL METRO, E IL SUO ALLINEAMENTO (T1/T2/T3).
   //    Si chiedono le barre del metro NELLO STESSO INTERVALLO DI
   //    TEMPO della coda della gamba -- non "le ultime n del metro",
   //    che sarebbero un altro intervallo se il metro ha buchi. E'
   //    precisamente qui che una sonda a due feed diventa un
   //    artefatto, se scritta di fretta.
   datetime tx[];
   double   cx[];
   ArraySetAsSeries(tx, false);
   ArraySetAsSeries(cx, false);
   int nxT = CopyTime (InpSimboloMetro, PERIOD_CURRENT, ty[0], tSeg, tx);
   int nxC = CopyClose(InpSimboloMetro, PERIOD_CURRENT, ty[0], tSeg, cx);
   int nx  = (nxT > 0 && nxT == nxC) ? nxT : 0;

   //--- FIX C2 v1.01, corretto in v1.02: i giorni in cui il METRO ha
   //    quotato ALMENO una barra dentro tx[] (gia' scaricato sopra).
   //    Serve a separare "il mercato del metro era chiuso quel giorno"
   //    (T3, festivita' propria, FISIOLOGICO) da "il metro era attivo ma
   //    manca proprio quella barra/quello span" (difetto vero del feed).
   //    v1.02: la domanda si fa DENTRO LA FINESTRA ORARIA, non sul
   //    giorno di calendario intero -- il perche', misurato, sta nel
   //    cartello sopra GiorniMetroAttivi_Calc e in testa al file.
   int giorniMetroAttivi[];
   int nGiorniMetroAttivi = 0;
   GiorniMetroAttivi_Calc(tx, nx, true,
                          InpOraInizioServer, InpMinInizioServer,
                          InpOraFineServer,   InpMinFineServer,
                          giorniMetroAttivi, nGiorniMetroAttivi);

   //--- CONTROLLO v1.02 (non decide niente): lo STESSO elenco col
   //    criterio VECCHIO, di calendario. Se "Giorni Metro Zero
   //    Calendario" esce 0, e' PROVATO dai dati che il criterio della
   //    v1.01 era vuoto su questa coppia -- che e' esattamente la
   //    diagnosi dei numeri identici al centesimo.
   int giorniMetroCal[];
   int nGiorniMetroCal = 0;
   //    Si ASSEGNA (non si accumula): l'ultima barra valutata del giorno
   //    e' quella la cui coda copre piu' giornata, quindi e' la risposta
   //    migliore disponibile a "il metro ha quotato oggi, in qualsiasi
   //    ora?". Accumulando con |= si conterebbero le prime ore del
   //    mattino, quando la risposta non e' ancora completa.
   GiorniMetroAttivi_Calc(tx, nx, false, 0, 0, 0, 0, giorniMetroCal, nGiorniMetroCal);
   gDayMetroZeroCal = !GiornoMetroAttivo_Calc(giorniMetroCal, nGiorniMetroCal, stamp);

   //--- LO SPAN CHE LO Z-SCORE GUARDA (T2). Si calcola PRIMA
   //    dell'allineamento perche' e' anche l'intervallo su cui ha senso
   //    contare le barre del SOLO METRO: vedi il cartello in testa ad
   //    AllineaSerie_Calc.
   int span   = SpanRichiesto_Calc(InpFinestraN, InpModoSpread);
   int iDaSpan = iSeg - span + 1;
   if(iDaSpan < 0) iDaSpan = 0;

   double xa[];
   bool   valido[];
   int    allineate = 0, soloMetro = 0;
   if(!AllineaSerie_Calc(ty, n, tx, cx, nx, iDaSpan, xa, valido, allineate, soloMetro))
     { gBarreSaltateDati++; return; }

   bool ultimaValida = valido[iSeg];
   if(!ultimaValida)
     {
      gMetroMancantiUltima++;
      //--- FIX C2 v1.01: se il metro non ha MAI quotato nel giorno della
      //    barra di SEGNALE, il suo mercato era chiuso quel giorno (T3):
      //    non e' "spaiato", e' festivita' propria del metro (T15 gia'
      //    fa lo stesso ragionamento per la gamba, sul denominatore).
      if(GiornoMetroAttivo_Calc(giorniMetroAttivi, nGiorniMetroAttivi, ts.year*1000 + ts.day_of_year))
         gDaySpaiato = true;      // il metro ERA attivo quel giorno: buco vero
      else
         gDayFestaMetro = true;   // il metro non ha quotato affatto: festivita' propria
     }
   if(soloMetro > 0){ gValutazioniSoloMetro++; gDaySpaiato = true; }
   //    (soloMetro conta il caso OPPOSTO -- il metro ha barre che la
   //    gamba non ha -- che non e' la festivita' descritta sopra: resta
   //    fuori da questo fix, e' un rilievo separato, vedi T3 in testa.)

   //--- L'ALLINEAMENTO SI PRETENDE SU TUTTO LO SPAN, non solo sulla
   //    barra di segnale. Un buco dentro la finestra fa calcolare media
   //    e deviazione su barre di ore diverse: il numero uscirebbe, e
   //    sarebbe finto. spanOk NON CAMBIA con questo fix (resta identico
   //    a prima, bit per bit): decide ancora se lo z-score si calcola.
   //    Cambia SOLO come il buco viene CLASSIFICATO per il gate C2: si
   //    scandisce l'INTERO span (niente piu' 'break' al primo invalido)
   //    per sapere se OGNI bar mancante ricade su un giorno in cui il
   //    metro non ha mai quotato (festa, propagata in avanti dallo
   //    z-score che guarda indietro, T2) oppure se ALMENO una ricade su
   //    un giorno in cui il metro era comunque attivo (buco vero).
   bool spanOk = (span > 0 && iSeg - span + 1 >= 0);
   //--- parte vero SOLO se si e' potuto scandire davvero lo span (si
   //    entra nel ciclo sotto): se spanOk era GIA' falso in partenza
   //    (span/warmup malconfigurati, mai vero a regime: OnInit lo
   //    impedisce) non e' provato che sia "festa", quindi resta un
   //    buco vero per prudenza (stesso trattamento di prima del fix).
   bool bucoSpanSoloFesta = spanOk;
   if(spanOk)
     {
      for(int k = iSeg - span + 1; k <= iSeg; k++)
        {
         if(!valido[k])
           {
            spanOk = false;
            MqlDateTime tk; TimeToStruct(ty[k], tk);
            if(GiornoMetroAttivo_Calc(giorniMetroAttivi, nGiorniMetroAttivi, tk.year*1000 + tk.day_of_year))
               bucoSpanSoloFesta = false;   // quel giorno il metro ha quotato: buco vero, non festa
           }
        }
     }
   if(!spanOk && ultimaValida)
     {
      gValutazioniPerseBuco++;
      if(bucoSpanSoloFesta) gDayFestaMetro = true;   // l'eco di una festa gia' contata altrove nello span
      else                  gDaySpaiato    = true;   // buco vero dentro un giorno con metro attivo
     }

   //--- ECO ATR (T13): non decide niente, serve a leggere il MAE in ATR.
   double tr[], atr[];
   double atrSeg = 0.0;
   if(TrSerie_Calc(high, low, close, n, tr) &&
      AtrSerie_Calc(tr, n, InpAtrPeriod, InpAtrModoRma, atr))
      atrSeg = atr[iSeg];
   if(InpConfrontaMT5 && atrSeg > 0.0) AggiornaDivergenzaAtr(atrSeg);

   //--- 5) LO Z-SCORE delle due ultime barre allineate.
   double z = 0.0, zPrec = 0.0;
   bool   zOk = false;
   if(spanOk)
     {
      zOk = ZDueBarre_Calc(close, xa, n, iSeg, InpFinestraN, InpModoSpread, InpModoZScore, z, zPrec);
      if(!zOk) gZNonCalcolabile++;
     }

   //--- 6) AGGIORNAMENTO DELLO STATO con la barra appena chiusa.
   //    MFE e MAE si misurano sui massimi/minimi della GAMBA: il metro
   //    non si scambia e la sua escursione non e' incassabile (T4/T10).
   if(gPosAttiva)
     {
      gPosBarre++;
      AggiornaEscursione_Calc(gPosLato, gPosPrezzo, high[iSeg], low[iSeg], gPuntoIndice, gPosMfe, gPosMae);
      if(!zOk) gBarreSenzaZAperta++;
     }
   AggiornaOsservatori(high[iSeg], low[iSeg], close[iSeg]);

   //--- 7) LE USCITE. La convergenza ha la precedenza sulla fine
   //    sessione nella stessa barra: la convergenza e' successa
   //    DENTRO la barra chiusa, il flat sarebbe successo dopo.
   if(gPosAttiva)
     {
      int motivo = 0;
      if(zOk && Convergenza_Calc(z, InpSogliaUscitaSigma, gPosLato)) motivo = 1;
      else if(!inIngr)                                               motivo = 2;
      else if(gPosBarre >= InpBarreMaxTenuta)                        motivo = 3;
      if(motivo > 0) ChiudiPosizioneFinta(motivo, tProssima, apProssima);
     }
   if(!inIngr) ScartaOsservatoriIncompleti();

   //--- 8) GLI INGRESSI. Senza z non esiste attraversamento: si esce
   //    in silenzio contato (gZNonCalcolabile / le colonne di buco).
   if(!zOk) return;

   bool crossL = Attraversamento_Calc(zPrec, z, InpSogliaIngressoSigma, +1);
   bool crossS = Attraversamento_Calc(zPrec, z, InpSogliaIngressoSigma, -1);
   if(!crossL && !crossS) return;
   //--- non possono essere veri insieme: z dovrebbe stare sotto
   //    -soglia E sopra +soglia nello stesso istante. Se un giorno
   //    succedesse, il lato scelto qui sotto sarebbe arbitrario, e per
   //    questo la condizione e' scritta e non sottintesa.
   if(crossL) gGrezziL++;
   if(crossS) gGrezziS++;
   if(primaBarraGiorno) gAttrPrimaBarra++;      // T9

   int lato = (crossL ? +1 : -1);

   //--- lato disabilitato: l'attraversamento resta contato fra i
   //    GREZZI e non entra fra gli ESEGUIBILI. Nessun contatore in
   //    piu': la differenza grezzi-eseguibili dice gia' tutto.
   if(InpLato == 1 && lato < 0) return;
   if(InpLato == 2 && lato > 0) return;

   //--- SLOT OCCUPATO (T6). Il ramo "altro lato" e' un COLLAUDO: deve
   //    restare a zero per costruzione delle soglie.
   if(gPosAttiva)
     {
      if(gPosLato == lato){ if(lato > 0) gOccupatoStessoL++; else gOccupatoStessoS++; }
      else                  gOccupatoAltroLato++;
      return;
     }

   //--- la barra d'INGRESSO deve cadere ancora dentro la finestra (T7):
   //    un ingresso che nasce gia' oltre il flat non e' eseguibile.
   //    v1.03: 'inIngr' guarda la barra REALE. Il ramo qui sotto e' LA
   //    MISURA CHE RENDE IL FIX FALSIFICABILE (lezione della v1.01, che
   //    girava senza mai mordere): conta SOLO gli ingressi che il gate
   //    vecchio -- quello sulla barra teorica -- avrebbe lasciato
   //    passare. Se questa colonna torna 0 su tutte le celle e il
   //    collaudo T12 fallisce ancora, la diagnosi della v1.03 e'
   //    sbagliata e va riscritta, non ritoccata.
   if(!inIngr)
     {
      gAttrIngressoFuori++;
      if(inIngrAttesa) gIngressoBarraRealeFuori++;
      return;
     }

   ApriPosizioneFinta(lato, tProssima, apProssima, z, atrSeg);
  }

//==================================================================
//  AUTOTEST DEL NUCLEO PURO
//  Gira in OnInit, prima di qualunque barra. NON stampa un verdetto
//  che nessuno legge: il numero di blocchi FALLITI e il numero di
//  blocchi ESEGUITI finiscono nelle colonne "Autotest Falliti" e
//  "Autotest Blocchi" (CHECKLIST punto 99). -1 vuol dire NON
//  ESEGUITO, che non e' "passato".
//  REGOLA DI SCRITTURA (CHECKLIST punto 98): ogni blocco usa nomi di
//  variabile col PROPRIO PREFISSO (a1_, a2_, ...). In MQL5 due
//  dichiarazioni dello stesso nome nello stesso scope sono un errore
//  secco di compilazione, e nessuna rilettura lo vede.
//  Ogni valore atteso qui sotto e' calcolato A MANO nel commento: un
//  test che copia il risultato del codice non prova niente.
//==================================================================
void AutoTestRelativo()
  {
   int falliti = 0;
   int blocchi = 0;

   //--- BLOCCO 1: SmaFin_Calc, valore e DOMINIO.
   //    v = [1,2,3,4,5]: sma(fine 4, 3) = (3+4+5)/3 = 4; sma(fine 2, 3) = 2.
   //    fine 1 con 3 barre sborda all'indietro -> false (NON si tosa).
   blocchi++;
   double a1_v[]; ArrayResize(a1_v,5);
   a1_v[0]=1.0; a1_v[1]=2.0; a1_v[2]=3.0; a1_v[3]=4.0; a1_v[4]=5.0;
   double a1_o1=0.0, a1_o2=0.0, a1_o3=0.0, a1_o4=0.0, a1_o5=0.0;
   bool   a1_k1 = SmaFin_Calc(a1_v, 5, 4, 3, a1_o1);   // 4
   bool   a1_k2 = SmaFin_Calc(a1_v, 5, 2, 3, a1_o2);   // 2
   bool   a1_k3 = SmaFin_Calc(a1_v, 5, 1, 3, a1_o3);   // sborda -> false
   bool   a1_k4 = SmaFin_Calc(a1_v, 5, 5, 3, a1_o4);   // fine fuori -> false
   bool   a1_k5 = SmaFin_Calc(a1_v, 5, 4, 0, a1_o5);   // quante 0 -> false
   if(!a1_k1 || !a1_k2 || a1_k3 || a1_k4 || a1_k5 ||
      MathAbs(a1_o1-4.0)>0.0001 || MathAbs(a1_o2-2.0)>0.0001)
     { falliti++; Log("[AUTOTEST] 1 SmaFin_Calc DIVERGE"); }

   //--- BLOCCO 2: StdevFin_Calc, deviazione di POPOLAZIONE (divisore
   //    'quante', convenzione di ta.stdev biased=true, che e' il
   //    default di Pine -- scelta dichiarata nel sorgente).
   //    [3,4,5]: media 4, scarti -1,0,1 -> sqrt(2/3) = 0,8164966.
   //    Con quante = 1 la deviazione e' 0 e la funzione risponde TRUE:
   //    e' misurata e nulla, non indefinita. Serie costante -> 0.
   blocchi++;
   double a2_o1=0.0, a2_o2=0.0, a2_o3=0.0;
   bool   a2_k1 = StdevFin_Calc(a1_v, 5, 4, 3, a2_o1);   // 0,8164966
   bool   a2_k2 = StdevFin_Calc(a1_v, 5, 4, 1, a2_o2);   // 0, true
   double a2_c[]; ArrayResize(a2_c,3); a2_c[0]=2.0; a2_c[1]=2.0; a2_c[2]=2.0;
   bool   a2_k3 = StdevFin_Calc(a2_c, 3, 2, 3, a2_o3);   // 0, true
   if(!a2_k1 || !a2_k2 || !a2_k3 ||
      MathAbs(a2_o1-0.8164966)>0.0001 || MathAbs(a2_o2)>0.0000001 || MathAbs(a2_o3)>0.0000001)
     { falliti++; Log("[AUTOTEST] 2 StdevFin_Calc DIVERGE (o non e' di popolazione)"); }

   //--- BLOCCO 3: CorrFin_Calc. y = 2x -> +1 esatto; y specchiata -> -1;
   //    serie costante -> NON esiste (false), non zero.
   blocchi++;
   double a3_x[]; ArrayResize(a3_x,4); a3_x[0]=1.0; a3_x[1]=2.0; a3_x[2]=3.0; a3_x[3]=4.0;
   double a3_y[]; ArrayResize(a3_y,4); a3_y[0]=2.0; a3_y[1]=4.0; a3_y[2]=6.0; a3_y[3]=8.0;
   double a3_z[]; ArrayResize(a3_z,4); a3_z[0]=8.0; a3_z[1]=6.0; a3_z[2]=4.0; a3_z[3]=2.0;
   double a3_k[]; ArrayResize(a3_k,4); a3_k[0]=1.0; a3_k[1]=1.0; a3_k[2]=1.0; a3_k[3]=1.0;
   double a3_o1=0.0, a3_o2=0.0, a3_o3=0.0;
   bool   a3_b1 = CorrFin_Calc(a3_x, a3_y, 4, 3, 4, a3_o1);   // +1
   bool   a3_b2 = CorrFin_Calc(a3_x, a3_z, 4, 3, 4, a3_o2);   // -1
   bool   a3_b3 = CorrFin_Calc(a3_k, a3_y, 4, 3, 4, a3_o3);   // false
   if(!a3_b1 || !a3_b2 || a3_b3 ||
      MathAbs(a3_o1-1.0)>0.0001 || MathAbs(a3_o2+1.0)>0.0001)
     { falliti++; Log("[AUTOTEST] 3 CorrFin_Calc DIVERGE"); }

   //--- BLOCCO 4: mediana. Dispari -> centrale; pari -> media dei due
   //    centrali; vettore vuoto -> 0. MedianaFin su finestra mobile:
   //    [5,1,9,3,7] tutta -> 5; ultime 3 = {9,3,7} -> 7.
   blocchi++;
   double a4_d[]; ArrayResize(a4_d,5);
   a4_d[0]=1.0; a4_d[1]=2.0; a4_d[2]=3.0; a4_d[3]=4.0; a4_d[4]=5.0;
   double a4_p[]; ArrayResize(a4_p,4); a4_p[0]=1.0; a4_p[1]=2.0; a4_p[2]=4.0; a4_p[3]=8.0;
   double a4_m1 = MedianaOrdinata_Calc(a4_d, 5);   // 3
   double a4_m2 = MedianaOrdinata_Calc(a4_p, 4);   // 3
   double a4_m3 = MedianaOrdinata_Calc(a4_d, 0);   // 0
   double a4_v[]; ArrayResize(a4_v,5);
   a4_v[0]=5.0; a4_v[1]=1.0; a4_v[2]=9.0; a4_v[3]=3.0; a4_v[4]=7.0;
   double a4_o1=0.0, a4_o2=0.0, a4_o3=0.0;
   bool   a4_k1 = MedianaFin_Calc(a4_v, 5, 4, 5, a4_o1);   // 5
   bool   a4_k2 = MedianaFin_Calc(a4_v, 5, 4, 3, a4_o2);   // 7
   bool   a4_k3 = MedianaFin_Calc(a4_v, 5, 1, 3, a4_o3);   // sborda -> false
   if(!a4_k1 || !a4_k2 || a4_k3 ||
      MathAbs(a4_m1-3.0)>0.0001 || MathAbs(a4_m2-3.0)>0.0001 || MathAbs(a4_m3)>0.0001 ||
      MathAbs(a4_o1-5.0)>0.0001 || MathAbs(a4_o2-7.0)>0.0001)
     { falliti++; Log("[AUTOTEST] 4 MedianaOrdinata_Calc / MedianaFin_Calc DIVERGONO"); }

   //--- BLOCCO 5: MAD (Iglewicz-Hoaglin). [1,2,3,4,100]: mediana 3,
   //    scarti |.-3| = {2,1,0,1,97} -> ordinati {0,1,1,2,97} -> MAD 1.
   //    E' il senso della normalizzazione ROBUSTA: il 100 non la muove.
   //    Serie costante -> mediana 5, MAD 0 (true: misurato e nullo).
   blocchi++;
   double a5_v[]; ArrayResize(a5_v,5);
   a5_v[0]=1.0; a5_v[1]=2.0; a5_v[2]=3.0; a5_v[3]=4.0; a5_v[4]=100.0;
   double a5_me=0.0, a5_ma=0.0, a5_me2=0.0, a5_ma2=0.0;
   bool   a5_k1 = MadFin_Calc(a5_v, 5, 4, 5, a5_me, a5_ma);
   double a5_c[]; ArrayResize(a5_c,3); a5_c[0]=5.0; a5_c[1]=5.0; a5_c[2]=5.0;
   bool   a5_k2 = MadFin_Calc(a5_c, 3, 2, 3, a5_me2, a5_ma2);
   if(!a5_k1 || !a5_k2 ||
      MathAbs(a5_me-3.0)>0.0001 || MathAbs(a5_ma-1.0)>0.0001 ||
      MathAbs(a5_me2-5.0)>0.0001 || MathAbs(a5_ma2)>0.0000001)
     { falliti++; Log("[AUTOTEST] 5 MadFin_Calc DIVERGE"); }

   //--- BLOCCO 6: il rapporto, col guardiano su x <= 0. Un tick sporco
   //    a zero su un CFD esiste: la divisione per zero diventerebbe un
   //    SEGNALE FINTO, e un segnale finto e' peggio di nessun segnale.
   blocchi++;
   double a6_o1=0.0, a6_o2=1.0, a6_o3=1.0;
   bool   a6_k1 = Rapporto_Calc(10.0,  4.0, a6_o1);   // 2,5
   bool   a6_k2 = Rapporto_Calc(10.0,  0.0, a6_o2);   // false
   bool   a6_k3 = Rapporto_Calc(10.0, -1.0, a6_o3);   // false
   if(!a6_k1 || a6_k2 || a6_k3 ||
      MathAbs(a6_o1-2.5)>0.0001 || MathAbs(a6_o2)>0.0001 || MathAbs(a6_o3)>0.0001)
     { falliti++; Log("[AUTOTEST] 6 Rapporto_Calc DIVERGE"); }

   //--- BLOCCO 7: beta OLS e spread OLS (T5). Con y = 2x il beta DEVE
   //    valere 2 e lo spread 0: e' la definizione della copertura
   //    perfetta, cioe' il caso in cui il motore NON deve vedere niente.
   //    x = [1,2,3,4]: stdev pop = 1,1180340; y = [2,4,6,8]: 2,2360680.
   //    beta = 1 * 2,2360680 / 1,1180340 = 2; spread = 5 - 2*2,5 = 0.
   blocchi++;
   double a7_b=0.0, a7_s=0.0, a7_bk=0.0;
   bool   a7_k1 = BetaOls_Calc  (a3_x, a3_y, 4, 3, 4, a7_b);
   bool   a7_k2 = SpreadOls_Calc(a3_x, a3_y, 4, 3, 4, a7_s);
   bool   a7_k3 = BetaOls_Calc  (a3_k, a3_y, 4, 3, 4, a7_bk);  // x costante -> false
   if(!a7_k1 || !a7_k2 || a7_k3 ||
      MathAbs(a7_b-2.0)>0.0001 || MathAbs(a7_s)>0.0001)
     { falliti++; Log("[AUTOTEST] 7 BetaOls_Calc / SpreadOls_Calc DIVERGONO"); }

   //--- BLOCCO 8: z classico. d = [1,2,3,4,5], fine 4, finestra 3:
   //    media {3,4,5} = 4, dev 0,8164966 -> z = (5-4)/0,8164966 = 1,2247449.
   //    Deviazione nulla -> false, MAI zero: zero e' "perfettamente
   //    allineati", cioe' la condizione di USCITA, e un indefinito letto
   //    come uscita chiuderebbe posizioni che nessuno ha chiuso.
   blocchi++;
   double a8_o=0.0, a8_ko=1.0;
   bool   a8_k1 = ZClassico_Calc(a4_d, 5, 4, 3, a8_o);
   bool   a8_k2 = ZClassico_Calc(a2_c, 3, 2, 3, a8_ko);
   if(!a8_k1 || a8_k2 || MathAbs(a8_o-1.2247449)>0.0001 || MathAbs(a8_ko)>0.0001)
     { falliti++; Log("[AUTOTEST] 8 ZClassico_Calc DIVERGE"); }

   //--- BLOCCO 9: z MODIFICATO. d = [1,2,3,4,5], finestra 5: mediana 3,
   //    MAD 1 -> z = 0,6745*(5-3)/1 = 1,3490.
   //    La costante 0,6745 e' il quartile della normale: senza di lei
   //    l'ablazione InpModoZScore confronterebbe DUE RIGHELLI DIVERSI.
   //    Il blocco fallisce anche se z modificato = z classico.
   blocchi++;
   double a9_o=0.0, a9_ko=1.0;
   bool   a9_k1 = ZModificato_Calc(a4_d, 5, 4, 5, a9_o);
   bool   a9_k2 = ZModificato_Calc(a2_c, 3, 2, 3, a9_ko);
   if(!a9_k1 || a9_k2 || MathAbs(a9_o-1.3490)>0.0001 || MathAbs(a9_ko)>0.0001)
     { falliti++; Log("[AUTOTEST] 9 ZModificato_Calc DIVERGE"); }

   //--- BLOCCO 10: L'ATTRAVERSAMENTO, bordi compresi. E' il cuore della
   //    PORTATA: e' la differenza fra contare uno STATO (z sotto soglia,
   //    contato a ogni barra) e un EVENTO (z era sopra, ora e' sotto).
   blocchi++;
   bool a10_l1 = Attraversamento_Calc( 0.0, -1.5, 1.0, +1);  // si
   bool a10_l2 = Attraversamento_Calc(-1.2, -1.5, 1.0, +1);  // era gia' sotto -> no
   bool a10_l3 = Attraversamento_Calc(-1.0, -1.5, 1.0, +1);  // bordo zPrec = -soglia -> si
   bool a10_l4 = Attraversamento_Calc( 0.0, -1.0, 1.0, +1);  // z fermo SULLA soglia -> no
   bool a10_s1 = Attraversamento_Calc( 0.0,  1.5, 1.0, -1);  // si
   bool a10_s2 = Attraversamento_Calc( 1.2,  1.5, 1.0, -1);  // no
   bool a10_s3 = Attraversamento_Calc( 1.0,  1.5, 1.0, -1);  // si
   bool a10_s4 = Attraversamento_Calc( 0.0,  1.0, 1.0, -1);  // no
   bool a10_z  = Attraversamento_Calc( 0.0, -1.5, 0.0, +1);  // soglia nulla -> no
   bool a10_n  = Attraversamento_Calc( 0.0, -1.5, 1.0,  0);  // lato assente -> no
   if(!(a10_l1 && !a10_l2 && a10_l3 && !a10_l4 &&
        a10_s1 && !a10_s2 && a10_s3 && !a10_s4 && !a10_z && !a10_n))
     { falliti++; Log("[AUTOTEST] 10 Attraversamento_Calc DIVERGE"); }

   //--- BLOCCO 11: la CONVERGENZA, cioe' la definizione operativa di C6.
   blocchi++;
   bool a11_l1 = Convergenza_Calc(-0.04, 0.05, +1);  // rientrato
   bool a11_l2 = Convergenza_Calc(-0.06, 0.05, +1);  // ancora fuori
   bool a11_l3 = Convergenza_Calc(-0.05, 0.05, +1);  // bordo incluso
   bool a11_l4 = Convergenza_Calc( 2.00, 0.05, +1);  // ha sfondato dall'altra parte
   bool a11_s1 = Convergenza_Calc( 0.04, 0.05, -1);
   bool a11_s2 = Convergenza_Calc( 0.06, 0.05, -1);
   bool a11_s3 = Convergenza_Calc( 0.05, 0.05, -1);
   bool a11_s4 = Convergenza_Calc(-2.00, 0.05, -1);
   bool a11_n  = Convergenza_Calc( 0.00, 0.05,  0);
   if(!(a11_l1 && !a11_l2 && a11_l3 && a11_l4 &&
        a11_s1 && !a11_s2 && a11_s3 && a11_s4 && !a11_n))
     { falliti++; Log("[AUTOTEST] 11 Convergenza_Calc DIVERGE"); }

   //--- BLOCCO 12: la finestra AL MINUTO (T7). 14:30 incluso, 22:00
   //    ESCLUSA. Piu' il caso a cavallo della mezzanotte e le ore
   //    impossibili.
   blocchi++;
   bool a12_a = InFinestra_Calc(14, 30, 14, 30, 22, 0);  // bordo iniziale: dentro
   bool a12_b = InFinestra_Calc(14, 29, 14, 30, 22, 0);  // un minuto prima: fuori
   bool a12_c = InFinestra_Calc(21, 59, 14, 30, 22, 0);  // ultimo minuto: dentro
   bool a12_d = InFinestra_Calc(22,  0, 14, 30, 22, 0);  // bordo finale ESCLUSO
   bool a12_e = InFinestra_Calc(23,  0, 14, 30, 22, 0);  // fuori
   bool a12_f = InFinestra_Calc(23,  0, 22,  0,  2, 0);  // cavallo: dentro
   bool a12_g = InFinestra_Calc( 1, 59, 22,  0,  2, 0);  // cavallo: dentro
   bool a12_h = InFinestra_Calc( 2,  0, 22,  0,  2, 0);  // cavallo: fine esclusa
   bool a12_i = InFinestra_Calc(10,  0, 22,  0,  2, 0);  // cavallo: fuori
   bool a12_j = InFinestra_Calc(24,  0, 14, 30, 22, 0);  // ora impossibile
   bool a12_k = InFinestra_Calc(14, 60, 14, 30, 22, 0);  // minuto impossibile
   bool a12_l = InFinestra_Calc(15,  0, 14, 30, 14, 30); // finestra nulla
   if(!(a12_a && !a12_b && a12_c && !a12_d && !a12_e &&
        a12_f && a12_g && !a12_h && !a12_i && !a12_j && !a12_k && !a12_l))
     { falliti++; Log("[AUTOTEST] 12 InFinestra_Calc DIVERGE"); }

   //--- BLOCCO 13: TRUE RANGE, prima barra compresa (high-low).
   //    h=[10,11,12] l=[9,10,11] c=[9,5;10,5;11,5] -> TR = [1; 1,5; 1,5]
   blocchi++;
   double a13_h[]; ArrayResize(a13_h,3); a13_h[0]=10.0; a13_h[1]=11.0; a13_h[2]=12.0;
   double a13_l[]; ArrayResize(a13_l,3); a13_l[0]= 9.0; a13_l[1]=10.0; a13_l[2]=11.0;
   double a13_c[]; ArrayResize(a13_c,3); a13_c[0]= 9.5; a13_c[1]=10.5; a13_c[2]=11.5;
   double a13_tr[];
   bool   a13_k1 = TrSerie_Calc(a13_h, a13_l, a13_c, 3, a13_tr);
   bool   a13_k2 = TrSerie_Calc(a13_h, a13_l, a13_c, 0, a13_tr);   // n < 1 -> false
   if(!a13_k1 || a13_k2 ||
      MathAbs(a13_tr[0]-1.0)>0.0001 || MathAbs(a13_tr[1]-1.5)>0.0001 ||
      MathAbs(a13_tr[2]-1.5)>0.0001)
     { falliti++; Log("[AUTOTEST] 13 TrSerie_Calc DIVERGE"); }

   //--- BLOCCO 14: ATR nei DUE modi, sullo stesso TR [1; 1,5; 1,5],
   //    periodo 2. Wilder/RMA: seme 1,25 poi 1,25+0,5*(1,5-1,25)=1,375.
   //    SMA del TR (modo MT5, default): (1,5+1,5)/2 = 1,5.
   //    Il blocco fallisce anche se i due VENISSERO UGUALI: se
   //    coincidessero, T13 sarebbe una bugia scritta in testa al file.
   blocchi++;
   double a14_rma[], a14_sma[];
   bool   a14_k1 = AtrSerie_Calc(a13_tr, 3, 2, true,  a14_rma);
   bool   a14_k2 = AtrSerie_Calc(a13_tr, 3, 2, false, a14_sma);
   bool   a14_k3 = AtrSerie_Calc(a13_tr, 3, 5, false, a14_sma);   // n < periodo -> false
   if(!a14_k1 || !a14_k2 || a14_k3 ||
      MathAbs(a14_rma[1]-1.25 )>0.0001 || MathAbs(a14_rma[2]-1.375)>0.0001 ||
      MathAbs(a14_sma[1]-1.25 )>0.0001 || MathAbs(a14_sma[2]-1.5  )>0.0001 ||
      MathAbs(a14_rma[2]-a14_sma[2]) < 0.0001)
     { falliti++; Log("[AUTOTEST] 14 AtrSerie_Calc DIVERGE (o le due modalita' coincidono, e allora T13 e' sbagliata)"); }

   //--- BLOCCO 15: conversione in punti indice e RR da mediane.
   blocchi++;
   double a15_p1 = PuntiIndice_Calc(12.5, 1.0);   // 12,5
   double a15_p2 = PuntiIndice_Calc(12.5, 0.5);   // 25
   double a15_p3 = PuntiIndice_Calc(12.5, 0.0);   // non convertibile -> 0
   double a15_r1 = RrDaMediane_Calc(6.0, 8.0);    // 0,75
   double a15_r2 = RrDaMediane_Calc(6.0, 0.0);    // MAE nullo -> 0
   if(MathAbs(a15_p1-12.5)>0.0001 || MathAbs(a15_p2-25.0)>0.0001 || MathAbs(a15_p3)>0.0001 ||
      MathAbs(a15_r1-0.75)>0.0001 || MathAbs(a15_r2)>0.0001)
     { falliti++; Log("[AUTOTEST] 15 PuntiIndice_Calc / RrDaMediane_Calc DIVERGONO"); }

   //--- BLOCCO 16: L'ARITMETICA DEL CANCELLO H8 CONTRO LA TABELLA
   //    CONGELATA NEL DOSSIER. Non e' un test di comodo: se questa
   //    formula si muove, si muove IL CANCELLO.
   //      RR 0,36 -> 79,0% | 0,50 -> 71,7% | 0,73 -> 62,2% | 1,00 -> 53,8%
   blocchi++;
   double a16_a = WinRateNecessario_Calc(0.36, REL_H8_E_TARGET_R);
   double a16_b = WinRateNecessario_Calc(0.50, REL_H8_E_TARGET_R);
   double a16_c = WinRateNecessario_Calc(0.73, REL_H8_E_TARGET_R);
   double a16_d = WinRateNecessario_Calc(1.00, REL_H8_E_TARGET_R);
   double a16_e = WinRateNecessario_Calc(-1.5, REL_H8_E_TARGET_R);   // fuori dominio -> 0
   if(MathAbs(a16_a-0.790)>0.001 || MathAbs(a16_b-0.717)>0.001 ||
      MathAbs(a16_c-0.622)>0.001 || MathAbs(a16_d-0.538)>0.001 ||
      MathAbs(a16_e)>0.0001)
     { falliti++; Log("[AUTOTEST] 16 WinRateNecessario_Calc NON riproduce la tabella congelata del dossier"); }

   //--- BLOCCO 17: la TABELLA DELLO SPREAD MISURATO. Se un giorno
   //    qualcuno cambia un numero qui, il cancello C3 cambia in
   //    silenzio: questo blocco e' il chiavistello.
   //    Simbolo NON misurato -> -1, e la sonda si rifiuta di partire.
   blocchi++;
   double a17_d = SpreadMisurato_Calc("D30EUR");
   double a17_n = SpreadMisurato_Calc("NASUSD");
   double a17_u = SpreadMisurato_Calc("U30USD");
   double a17_s = SpreadMisurato_Calc("D30EUR.cash");   // suffisso di broker
   double a17_x = SpreadMisurato_Calc("EURUSD");        // non misurato
   if(MathAbs(a17_d-2.80)>0.0001 || MathAbs(a17_n-1.80)>0.0001 ||
      MathAbs(a17_u-2.00)>0.0001 || MathAbs(a17_s-2.80)>0.0001 || a17_x > 0.0)
     { falliti++; Log("[AUTOTEST] 17 SpreadMisurato_Calc DIVERGE dalla tabella misurata del 03/09"); }

   //--- BLOCCO 18: L'ALLINEAMENTO DEI DUE FEED. E' la funzione piu'
   //    importante del file, e quella che rende una sonda a due feed un
   //    artefatto se scritta di fretta.
   //    ty = [100,200,300,400]; tx = [100,300,350,400].
   //      -> valido = [SI, NO, SI, SI], allineate = 3
   //      -> la barra 350 e' SOLO METRO: con daConta = 0 si conta (1),
   //         con daConta = 3 (si conta solo da ty[3] = 400) NON si
   //         conta (0). E' la correzione del 03/09.
   blocchi++;
   datetime a18_ty[]; ArrayResize(a18_ty,4);
   a18_ty[0]=(datetime)100; a18_ty[1]=(datetime)200; a18_ty[2]=(datetime)300; a18_ty[3]=(datetime)400;
   datetime a18_tx[]; ArrayResize(a18_tx,4);
   a18_tx[0]=(datetime)100; a18_tx[1]=(datetime)300; a18_tx[2]=(datetime)350; a18_tx[3]=(datetime)400;
   double a18_cx[]; ArrayResize(a18_cx,4);
   a18_cx[0]=10.0; a18_cx[1]=30.0; a18_cx[2]=35.0; a18_cx[3]=40.0;
   double a18_xa[]; bool a18_va[];
   int    a18_al=0, a18_so=0;
   bool   a18_k1 = AllineaSerie_Calc(a18_ty, 4, a18_tx, a18_cx, 4, 0, a18_xa, a18_va, a18_al, a18_so);
   int    a18_al2=0, a18_so2=0;
   double a18_xa2[]; bool a18_va2[];
   bool   a18_k2 = AllineaSerie_Calc(a18_ty, 4, a18_tx, a18_cx, 4, 3, a18_xa2, a18_va2, a18_al2, a18_so2);
   int    a18_al3=0, a18_so3=0;
   double a18_xa3[]; bool a18_va3[];
   bool   a18_k3 = AllineaSerie_Calc(a18_ty, 4, a18_tx, a18_cx, 0, 0, a18_xa3, a18_va3, a18_al3, a18_so3);
   int    a18_al4=0, a18_so4=0;
   bool   a18_k4 = AllineaSerie_Calc(a18_ty, 0, a18_tx, a18_cx, 4, 0, a18_xa3, a18_va3, a18_al4, a18_so4);
   if(!a18_k1 || !a18_k2 || !a18_k3 || a18_k4 ||
      a18_al != 3 || a18_so != 1 || a18_al2 != 3 || a18_so2 != 0 ||
      a18_al3 != 0 ||
      !a18_va[0] || a18_va[1] || !a18_va[2] || !a18_va[3] ||
      MathAbs(a18_xa[0]-10.0)>0.0001 || MathAbs(a18_xa[2]-30.0)>0.0001 ||
      MathAbs(a18_xa[3]-40.0)>0.0001 || MathAbs(a18_xa[1])>0.0001 ||
      a18_va3[0] || a18_va3[3])
     { falliti++; Log("[AUTOTEST] 18 AllineaSerie_Calc DIVERGE (e con lei tutta la sincronizzazione dei due feed)"); }

   //--- BLOCCO 19: quante barre indietro guarda lo z-score. Non e' un
   //    dettaglio: e' l'ampiezza su cui si PRETENDE l'allineamento (T2).
   blocchi++;
   int a19_r = SpanRichiesto_Calc(20, 0);   // 2n+1 = 41
   int a19_b = SpanRichiesto_Calc(20, 1);   // 3n+1 = 61
   int a19_z = SpanRichiesto_Calc( 0, 0);   // 0
   int a19_n = SpanRichiesto_Calc(-3, 1);   // 0
   if(a19_r != 41 || a19_b != 61 || a19_z != 0 || a19_n != 0)
     { falliti++; Log("[AUTOTEST] 19 SpanRichiesto_Calc DIVERGE"); }

   //--- BLOCCO 20: LA CATENA INTERA, a mano. finestra 3, modo rapporto,
   //    z classico, metro costante a 1 (cosi' rapporto = gamba).
   //      y = [1,2,3,5,4,7,6], fine = 6
   //      s = y[1..6]           = [2, 3, 5, 4, 7, 6]
   //      d = s - sma(s,3)      = [5/3, 0, 5/3, 1/3]
   //      z    su {0; 5/3; 1/3} : media 2/3, dev 0,7200823 -> -0,4629100
   //      zPrec su {5/3; 0; 5/3}: media 10/9, dev 0,7856742 -> +0,7071068
   //    Se un indice si sposta di uno, questi due numeri si scambiano o
   //    cambiano segno: e' un test che VEDE l'errore piu' probabile.
   blocchi++;
   double a20_y[]; ArrayResize(a20_y,7);
   a20_y[0]=1.0; a20_y[1]=2.0; a20_y[2]=3.0; a20_y[3]=5.0;
   a20_y[4]=4.0; a20_y[5]=7.0; a20_y[6]=6.0;
   double a20_x[]; ArrayResize(a20_x,7);
   for(int a20_i = 0; a20_i < 7; a20_i++) a20_x[a20_i] = 1.0;
   double a20_z=0.0, a20_zp=0.0;
   bool   a20_k1 = ZDueBarre_Calc(a20_y, a20_x, 7, 6, 3, 0, 0, a20_z, a20_zp);
   double a20_z2=0.0, a20_zp2=0.0;
   bool   a20_k2 = ZDueBarre_Calc(a20_y, a20_x, 7, 3, 3, 0, 0, a20_z2, a20_zp2);  // span 7 > fine+1 -> false
   double a20_z3=0.0, a20_zp3=0.0;
   bool   a20_k3 = ZDueBarre_Calc(a20_y, a20_x, 7, 6, 3, 1, 0, a20_z3, a20_zp3);  // beta OLS: span 10 -> false
   double a20_z4=0.0, a20_zp4=0.0;
   bool   a20_k4 = ZDueBarre_Calc(a20_y, a20_x, 7, 0, 3, 0, 0, a20_z4, a20_zp4);  // fine < 1 -> false
   if(!a20_k1 || a20_k2 || a20_k3 || a20_k4 ||
      MathAbs(a20_z + 0.4629100)>0.0001 || MathAbs(a20_zp - 0.7071068)>0.0001)
     { falliti++; Log("[AUTOTEST] 20 ZDueBarre_Calc DIVERGE (la catena rapporto -> scarto -> z e' rotta)"); }

   //--- BLOCCO 21: MFE e MAE. Escono ENTRAMBI come distanze POSITIVE:
   //    il segno lo porta il LATO, non il numero. E sono MASSIMI: una
   //    barra che non spinge non abbassa niente.
   blocchi++;
   double a21_f = 0.0, a21_a = 0.0;
   AggiornaEscursione_Calc(+1, 100.0, 105.0, 98.0, 1.0, a21_f, a21_a);   // mfe 5, mae 2
   AggiornaEscursione_Calc(+1, 100.0, 103.0, 95.0, 1.0, a21_f, a21_a);   // mfe resta 5, mae 5
   double a21_g = 0.0, a21_b = 0.0;
   AggiornaEscursione_Calc(-1, 100.0, 105.0, 98.0, 1.0, a21_g, a21_b);   // short: mfe 2, mae 5
   double a21_h = 0.0, a21_c = 0.0;
   AggiornaEscursione_Calc( 0, 100.0, 105.0, 98.0, 1.0, a21_h, a21_c);   // lato assente: niente
   if(MathAbs(a21_f-5.0)>0.0001 || MathAbs(a21_a-5.0)>0.0001 ||
      MathAbs(a21_g-2.0)>0.0001 || MathAbs(a21_b-5.0)>0.0001 ||
      MathAbs(a21_h)>0.0001    || MathAbs(a21_c)>0.0001)
     { falliti++; Log("[AUTOTEST] 21 AggiornaEscursione_Calc DIVERGE"); }

   //--- BLOCCO 22 (v1.01, fix C2): GiorniMetroAttivi_Calc / GiornoMetroAttivo_Calc
   //    in modo CALENDARIO (soloFinestra = false, il criterio vecchio).
   //    tx = barre del metro su 3 giorni: 2024.01.01 (2 barre),
   //    2024.01.02 SALTATO (il "festivo"), 2024.01.03 (1 barra).
   //    Attesi: 2 giorni distinti trovati; 01/01 e 03/01 ATTIVI;
   //    02/01 (nessuna barra) NON attivo.
   blocchi++;
   datetime a22_tx[]; ArrayResize(a22_tx,3);
   a22_tx[0] = D'2024.01.01 10:00';
   a22_tx[1] = D'2024.01.01 10:15';
   a22_tx[2] = D'2024.01.03 10:00';
   int a22_giorni[]; int a22_n = -1;
   GiorniMetroAttivi_Calc(a22_tx, 3, false, 0, 0, 0, 0, a22_giorni, a22_n);
   MqlDateTime a22_g1; TimeToStruct(D'2024.01.01 09:00', a22_g1);
   MqlDateTime a22_g2; TimeToStruct(D'2024.01.02 09:00', a22_g2);
   MqlDateTime a22_g3; TimeToStruct(D'2024.01.03 09:00', a22_g3);
   int  a22_s1 = a22_g1.year*1000 + a22_g1.day_of_year;
   int  a22_s2 = a22_g2.year*1000 + a22_g2.day_of_year;
   int  a22_s3 = a22_g3.year*1000 + a22_g3.day_of_year;
   bool a22_a1 = GiornoMetroAttivo_Calc(a22_giorni, a22_n, a22_s1);   // true
   bool a22_a2 = GiornoMetroAttivo_Calc(a22_giorni, a22_n, a22_s2);   // false: il "festivo"
   bool a22_a3 = GiornoMetroAttivo_Calc(a22_giorni, a22_n, a22_s3);   // true
   if(a22_n != 2 || !a22_a1 || a22_a2 || !a22_a3)
     { falliti++; Log("[AUTOTEST] 22 GiorniMetroAttivi_Calc/GiornoMetroAttivo_Calc DIVERGONO"); }

   //--- BLOCCO 23 (v1.02): LA DIFFERENZA FRA I DUE CRITERI, sullo STESSO
   //    tx. E' il collaudo che dimostra il difetto della v1.01: un metro
   //    che quota di NOTTE (03:00) ma NON nella finestra 14:30-22:00
   //    risulta ATTIVO col criterio di CALENDARIO e NON attivo col
   //    criterio di FINESTRA. Il primo e' il giorno che la v1.01 non
   //    riusciva a vedere; il secondo e' quello che la v1.02 esclude
   //    dal numeratore di C2.
   //    tx: 05/01 barra NOTTURNA soltanto (il "festivo cash" del metro),
   //        08/01 barra IN FINESTRA (giornata normale).
   blocchi++;
   datetime a23_tx[]; ArrayResize(a23_tx,2);
   a23_tx[0] = D'2024.01.05 03:00';   // fuori finestra: solo notte
   a23_tx[1] = D'2024.01.08 16:00';   // dentro 14:30-22:00
   int a23_cal[];  int a23_nc = -1;
   int a23_fin[];  int a23_nf = -1;
   GiorniMetroAttivi_Calc(a23_tx, 2, false, 0, 0, 0, 0, a23_cal, a23_nc);
   GiorniMetroAttivi_Calc(a23_tx, 2, true, 14, 30, 22, 0, a23_fin, a23_nf);
   MqlDateTime a23_g5; TimeToStruct(D'2024.01.05 16:00', a23_g5);
   MqlDateTime a23_g8; TimeToStruct(D'2024.01.08 16:00', a23_g8);
   int  a23_s5 = a23_g5.year*1000 + a23_g5.day_of_year;
   int  a23_s8 = a23_g8.year*1000 + a23_g8.day_of_year;
   bool a23_cal5 = GiornoMetroAttivo_Calc(a23_cal, a23_nc, a23_s5);   // true  <- il difetto v1.01
   bool a23_fin5 = GiornoMetroAttivo_Calc(a23_fin, a23_nf, a23_s5);   // false <- la v1.02 lo vede
   bool a23_fin8 = GiornoMetroAttivo_Calc(a23_fin, a23_nf, a23_s8);   // true  <- giornata normale
   if(a23_nc != 2 || a23_nf != 1 || !a23_cal5 || a23_fin5 || !a23_fin8)
     { falliti++; Log("[AUTOTEST] 23 GiorniMetroAttivi_Calc modo FINESTRA (fix v1.02) DIVERGE"); }

   //--- BLOCCO 24 (v1.03): IL GATE T7 SULLA BARRA D'INGRESSO REALE.
   //    E' il caso che produceva il collaudo T12 rotto, messo a tavolino
   //    con la finestra vera della prova (14:30-22:00, fine ESCLUSA) e
   //    il TF vero (M15 = 900 s):
   //      a) storico pieno, barra di segnale 21:30 -> ingresso 21:45:
   //         dentro, e contigua. E' il caso normale, e la risposta DEVE
   //         essere identica a quella del gate vecchio.
   //      b) storico pieno, barra di segnale 21:45 -> ingresso 22:00:
   //         fine ESCLUSA, quindi fuori (nessuna regressione sul bordo).
   //      c) IL BUCO: barra di segnale 21:30, la 21:45 MANCA e la barra
   //         vera e' la 22:00. Il gate VECCHIO guardava la teorica
   //         (21:45) e diceva DENTRO; il nuovo guarda la reale (22:00) e
   //         dice FUORI. E' esattamente l'ingresso che nasceva fuori
   //         sessione e moriva a durata nulla.
   //      d) buco che salta DENTRO la finestra (16:00 -> 16:30): si
   //         entra lo stesso, ma 'contigua' e' false e lo dichiara.
   blocchi++;
   bool a24_c1 = true, a24_c2 = true, a24_c3 = true, a24_c4 = true;
   bool a24_a = IngressoInFinestra_Calc(D'2024.01.08 21:30', D'2024.01.08 21:45', 900, 14, 30, 22, 0, a24_c1);
   bool a24_b = IngressoInFinestra_Calc(D'2024.01.08 21:45', D'2024.01.08 22:00', 900, 14, 30, 22, 0, a24_c2);
   bool a24_c = IngressoInFinestra_Calc(D'2024.01.08 21:30', D'2024.01.08 22:00', 900, 14, 30, 22, 0, a24_c3);
   bool a24_d = IngressoInFinestra_Calc(D'2024.01.08 16:00', D'2024.01.08 16:30', 900, 14, 30, 22, 0, a24_c4);
   //--- e la barra 0 non puo' MAI essere indietro rispetto alla barra di
   //    segnale: se lo fosse, non e' un ingresso ed e' un difetto di
   //    lettura della serie, non un orario fuori finestra.
   bool a24_c5 = true;
   bool a24_e = IngressoInFinestra_Calc(D'2024.01.08 16:00', D'2024.01.08 16:00', 900, 14, 30, 22, 0, a24_c5);
   if(!a24_a || !a24_c1 ||          // (a) dentro e contigua
      a24_b  || !a24_c2 ||          // (b) fuori (fine esclusa) ma contigua
      a24_c  ||  a24_c3 ||          // (c) IL BUCO: fuori, e non contigua
      !a24_d ||  a24_c4 ||          // (d) dentro ma NON contigua
      a24_e)                        // (e) barra 0 non avanti: non e' un ingresso
     { falliti++; Log("[AUTOTEST] 24 IngressoInFinestra_Calc (gate T7 sulla barra REALE, fix T12 v1.03) DIVERGE"); }

   //--- BLOCCO 25 (v1.03): LA TENUTA IN SECONDI DALLE BARRE VALUTATE.
   //    Il collaudo T12 in forma di aritmetica: a M5 e a M15 UNA barra
   //    vale gia' 300 e 900 secondi, quindi nessuna tenuta puo' cadere
   //    nella fascia 1-59 s. L'unico "sotto 60" possibile e' ZERO barre,
   //    che e' il difetto che il collaudo deve continuare a vedere.
   blocchi++;
   long a25_m15_1  = TenutaSecondi_Calc(1,  900);
   long a25_m5_1   = TenutaSecondi_Calc(1,  300);
   long a25_m15_12 = TenutaSecondi_Calc(12, 900);
   long a25_zero   = TenutaSecondi_Calc(0,  900);
   long a25_neg    = TenutaSecondi_Calc(-3, 900);
   long a25_tf0    = TenutaSecondi_Calc(5,    0);
   if(a25_m15_1 != 900 || a25_m5_1 != 300 || a25_m15_12 != 10800 ||
      a25_zero != 0 || a25_neg != 0 || a25_tf0 != 0 ||
      a25_m15_1 < 60 || a25_m5_1 < 60)
     { falliti++; Log("[AUTOTEST] 25 TenutaSecondi_Calc (collaudo T12 in aritmetica, fix v1.03) DIVERGE"); }

   gAutotestFalliti = falliti;
   gAutotestBlocchi = blocchi;
   Log(StringFormat("AUTOTEST: %d BLOCCHI SU %d PASSATI (falliti %d). L'esito VERO esce nelle colonne 'Autotest Falliti' e 'Autotest Blocchi': in ottimizzazione questa riga non la legge nessuno.",
                    blocchi - falliti, blocchi, falliti));
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
//| Conta le occorrenze di UN carattere in una stringa. Serve al       |
//| controllo automatico dell'intestazione: vedi ControllaColonne.     |
//+------------------------------------------------------------------+
int ContaCarattere(const string s, const ushort c)
  {
   int n = 0;
   int L = StringLen(s);
   for(int i = 0; i < L; i++) if(StringGetCharacter(s, i) == c) n++;
   return(n);
  }

//+------------------------------------------------------------------+
//| IL CONTROLLO CHE LA SONDA M0PB NON AVEVA, E CHE LI' E' COSTATO UN  |
//| CSV SFASATO. 'stats', l'intestazione e la riga di formato SI       |
//| TOCCANO SEMPRE INSIEME: una colonna aggiunta a uno solo dei tre    |
//| sposta TUTTI i numeri di una casella, e chi legge trova il numero  |
//| sbagliato sotto il nome giusto -- senza nessun errore a schermo.   |
//| Qui si contano le VIRGOLE dell'intestazione e i '%' del formato e  |
//| si URLA se non tornano. Il controllo non ripara: dichiara.         |
//|   nomi attesi          = REL_NSTATS + 3 (Pass, Simbolo, Periodo)   |
//|   virgole attese       = nomi - 1                                  |
//|   specificatori attesi = nomi                                      |
//+------------------------------------------------------------------+
bool ControllaColonne(const string head, const string fmt)
  {
   int virgole = ContaCarattere(head, ',');
   int perc    = ContaCarattere(fmt,  '%');
   int nomi    = REL_NSTATS + 3;
   bool ok = (virgole == nomi - 1) && (perc == nomi);
   if(!ok)
      PrintFormat("### CSV SFASATO ### intestazione con %d virgole (attese %d) e formato con %d specificatori (attesi %d) per REL_NSTATS = %d. LE COLONNE NON CORRISPONDONO AI NUMERI: NON LEGGERE QUESTO CSV.",
                  virgole, nomi - 1, perc, nomi, REL_NSTATS);
   return(ok);
  }

//+------------------------------------------------------------------+
//| Il referto a schermo del BACKTEST SINGOLO, un lato per volta, coi  |
//| cancelli GIA' applicati. Gli stessi numeri escono in colonna: qui  |
//| si stampano perche' nella corsa singola le Print SI LEGGONO.       |
//+------------------------------------------------------------------+
void StampaLatoRelativo(const string lato, const long grezzi, const long esegui,
                        const double perGiorno, const double mfeMed, const double maeMed,
                        const double rr, const long chiuse, const long converg,
                        const double nonConvPct, const double tenuta, const long maxGiorno)
  {
   Print("--------------------------------------------------------------");
   PrintFormat("[RELATIVO-SONDA] ===== LATO %s =====", lato);
   PrintFormat("   C1 eseguibili/giorno  : %.3f   (eseguibili %d su %d grezzi)",
               perGiorno, (int)esegui, (int)grezzi);
   PrintFormat("   C3 MFE mediana        : %.3f punti indice = %.2f x lo spread MISURATO (%.2f)   %s",
               mfeMed, (gSpreadMisurato > 0.0 ? mfeMed/gSpreadMisurato : 0.0), gSpreadMisurato,
               (mfeMed < gSogliaC3 ? "<<< C3 NON PASSATO: SCARTO" : "C3 passato"));
   PrintFormat("   C4 MAE mediana        : %.3f punti indice   (nessun cancello: e' il pavimento dello SL)", maeMed);
   PrintFormat("   C5 RR = C3/C4         : %.4f   %s", rr,
               (rr < REL_C5_RR_MINIMO ? "<<< C5 NON PASSATO: SCARTO PER ARITMETICA" : "C5 passato"));
   PrintFormat("      win rate NECESSARIO per E >= %.3fR : %.1f%%",
               REL_H8_E_TARGET_R, 100.0*WinRateNecessario_Calc(rr, REL_H8_E_TARGET_R));
   PrintFormat("   C6 non convergute     : %.2f%%   (convergute %d su %d chiuse)   %s",
               nonConvPct, (int)converg, (int)chiuse,
               (nonConvPct > REL_C6_NON_CONVERGUTE_KO ? "<<< C6 NON PASSATO: NON E' CONVERGENZA, E' MOMENTUM TRAVESTITO"
                                                      : (nonConvPct > REL_C6_NON_CONVERGUTE_SOSP ? "C6 SOSPESO" : "C6 passato")));
   PrintFormat("   C8 tenuta mediana     : %.2f barre   %s", tenuta,
               (tenuta < REL_C8_TENUTA_BARRE_MIN ? "<<< sotto il muro d'attrito: SOSPESO" : "sopra il muro d'attrito"));
   PrintFormat("   C7 massimo in un giorno: %d   (e' da qui che si taglia InpMaxTradesPerDay, SUI DATI)", (int)maxGiorno);
  }

double OnTester()
  {
   //--- LA CHIUSURA DELLA CORSA, e sono tre gesti che nessuna barra
   //    fara' piu': la posizione finta ancora aperta si chiude col
   //    motivo 4 (FINE CORSA) ed e' ESCLUSA da C6 -- non e' una
   //    divergenza che non converge, e' il bordo della corsa;
   //    gli osservatori a meta' orizzonte si contano e si buttano;
   //    l'ultima giornata si chiude a mano.
   if(gPosAttiva)
      ChiudiPosizioneFinta(4, iTime(_Symbol, PERIOD_CURRENT, 0), iOpen(_Symbol, PERIOD_CURRENT, 0));
   ScartaOsservatoriIncompleti();
   ChiudiGiornata();
   gDayStamp = -1;

   //--- LE MEDIANE. Tutte in PUNTI INDICE salvo la tenuta, in BARRE.
   double mfeMedL = Mediana(gMfeL, gNMfeL);
   double mfeMedS = Mediana(gMfeS, gNMfeS);
   double maeMedL = Mediana(gMaeL, gNMaeL);
   double maeMedS = Mediana(gMaeS, gNMaeS);
   double rrL     = RrDaMediane_Calc(mfeMedL, maeMedL);
   double rrS     = RrDaMediane_Calc(mfeMedS, maeMedS);
   double tenMedL = Mediana(gTenL, gNTenL);
   double tenMedS = Mediana(gTenS, gNTenS);

   //--- la tenuta dei DUE lati insieme: si accorpano i campioni, NON si
   //    fa la media delle due mediane (che non e' una mediana).
   double tenTutte[];
   int    nTen = gNTenL + gNTenS;
   double tenMedT = 0.0;
   if(nTen > 0 && ArrayResize(tenTutte, nTen) == nTen)
     {
      for(int i = 0; i < gNTenL; i++) tenTutte[i]          = gTenL[i];
      for(int j = 0; j < gNTenS; j++) tenTutte[gNTenL + j] = gTenS[j];
      tenMedT = Mediana(tenTutte, nTen);
     }

   double mfeOrMedL = Mediana(gMfeOrL, gNMfeOrL);
   double mfeOrMedS = Mediana(gMfeOrS, gNMfeOrS);
   double maeOrMedL = Mediana(gMaeOrL, gNMaeOrL);
   double maeOrMedS = Mediana(gMaeOrS, gNMaeOrS);
   double movOrMedL = Mediana(gMovOrL, gNMovOrL);
   double movOrMedS = Mediana(gMovOrS, gNMovOrS);
   double atrMed    = Mediana(gAtrPts, gNAtr);

   //--- C1: PORTATA. Il denominatore sono i GIORNI CONTATI (T15), cioe'
   //    i giorni con almeno una barra valutata dentro la finestra.
   double gg    = (double)gGiorniContati;
   double eseGL = (gg > 0.0) ? (double)gEseguibiliL/gg : 0.0;
   double eseGS = (gg > 0.0) ? (double)gEseguibiliS/gg : 0.0;
   double eseGT = eseGL + eseGS;
   double greGT = (gg > 0.0) ? (double)(gGrezziL + gGrezziS)/gg : 0.0;
   double c1Esito = (eseGT >= REL_C1_ESEGUIBILI_GIORNO) ? 1.0 : 0.0;

   //--- C2: GIORNI SPAIATI. NON e' un cancello di merito: dice quanto i
   //    calendari sfalsati sporcano il campione.
   double spaiPct = (gg > 0.0) ? 100.0*(double)gGiorniSpaiati/gg : 0.0;
   double c2Esito = (spaiPct <= REL_C2_GIORNI_SPAIATI_PCT) ? 1.0 : 0.0;

   //--- C3: TAGLIA, contro lo spread MISURATO (mediana oraria PEGGIORE
   //    nelle ore di lavoro, clausola severa). 0 = scarto, 1 = passa,
   //    2 = passa LARGO (> 6x). Nessuna fascia "sospeso": il debito
   //    dello spread e' stato pagato il 03/09.
   double largo   = REL_C3_MULTIPLO_LARGO*gSpreadMisurato;
   double c3L     = (mfeMedL >  largo) ? 2.0 : ((mfeMedL >= gSogliaC3) ? 1.0 : 0.0);
   double c3S     = (mfeMedS >  largo) ? 2.0 : ((mfeMedS >= gSogliaC3) ? 1.0 : 0.0);
   double mfeSpL  = (gSpreadMisurato > 0.0) ? mfeMedL/gSpreadMisurato : 0.0;
   double mfeSpS  = (gSpreadMisurato > 0.0) ? mfeMedS/gSpreadMisurato : 0.0;
   double c5L     = (rrL >= REL_C5_RR_MINIMO) ? 1.0 : 0.0;
   double c5S     = (rrS >= REL_C5_RR_MINIMO) ? 1.0 : 0.0;

   //--- C6: LA CONDIZIONE DI MORTE DELLA TESI. Denominatore = posizioni
   //    finte CHIUSE (fine corsa esclusa). Se il denominatore e' zero il
   //    numero non esiste: si scrive 0 e lo dice la colonna "Chiuse".
   double nonConvL = (gChiuseL > 0) ? 100.0*(double)(gChiuseL - gConvergL)/(double)gChiuseL : 0.0;
   double nonConvS = (gChiuseS > 0) ? 100.0*(double)(gChiuseS - gConvergS)/(double)gChiuseS : 0.0;
   long   chiuseT  = gChiuseL + gChiuseS;
   long   convT    = gConvergL + gConvergS;
   double nonConvT = (chiuseT > 0) ? 100.0*(double)(chiuseT - convT)/(double)chiuseT : 0.0;
   double c6Esito  = (nonConvT >  REL_C6_NON_CONVERGUTE_KO)   ? 0.0
                   : ((nonConvT > REL_C6_NON_CONVERGUTE_SOSP) ? 1.0 : 2.0);

   //--- C7: cap di rischio aperto (firmato il 18/08). Se il massimo
   //    giornaliero misurato porta il rischio aperto oltre il cap,
   //    InpMaxTradesPerDay entra nell'EA DAL PRIMO ROUND.
   double rischioMax = (double)gMaxGiornoTot*REL_C7_RISCHIO_PER_TRADE;
   double c7Cap      = (rischioMax > REL_C7_CAP_RISCHIO_APERTO) ? 1.0 : 0.0;

   //--- C8: tenuta e clausola HFT delle prop. La quota sotto 60 secondi
   //    e' un COLLAUDO (T12): su M5 la tenuta minima e' 300 s, quindi
   //    DEVE venire 0,00%. Se non viene zero, e' rotta la contabilita'
   //    dei tempi, non e' una scoperta sul mercato.
   double sotto60Pct = (chiuseT > 0) ? 100.0*(double)(gSotto60L + gSotto60S)/(double)chiuseT : 0.0;
   double c8Esito    = (sotto60Pct >= REL_C8_QUOTA_SOTTO60_KO) ? 0.0
                     : ((tenMedT   <  REL_C8_TENUTA_BARRE_MIN) ? 1.0 : 2.0);

   double atrDiv = (gAtrDivN > 0) ? gAtrDivRelSom/(double)gAtrDivN : 0.0;

   //--- la profondita' VERA dello storico dei due feed. E' il debito (a)
   //    lasciato aperto dalla bozza: "@DAQUANDO 2024.09.26 e' misurato
   //    su D30EUR e NASUSD; su U30USD NON e' stato verificato".
   //    Qui si LEGGE, e a fine corsa la serie del metro e' sincronizzata.
   double metroPrima = (double)(long)SeriesInfoInteger(InpSimboloMetro, PERIOD_CURRENT, SERIES_FIRSTDATE);
   double gambaPrima = (double)(long)SeriesInfoInteger(_Symbol,        PERIOD_CURRENT, SERIES_FIRSTDATE);

   //--- REFERTO A SCHERMO (corsa singola).
   Print("==============================================================");
   PrintFormat("[RELATIVO-SONDA] GAMBA %s (si scambia) contro METRO %s (si legge), %s - etichetta '%s'. NESSUN ORDINE APERTO: e' un contatore.",
               _Symbol, InpSimboloMetro, EnumToString((ENUM_TIMEFRAMES)Period()), InpTag);
   PrintFormat("   motore: %s -> scarto -> z %s, finestra n=%d, ingresso %.2f sigma, convergenza %.2f sigma",
               (InpModoSpread == 1 ? "spread beta OLS" : "rapporto gamba/metro"),
               (InpModoZScore == 1 ? "MODIFICATO mediana/MAD" : "classico media/deviazione"),
               InpFinestraN, InpSogliaIngressoSigma, InpSogliaUscitaSigma);
   PrintFormat("   barre valutate %d | fuori finestra %d | saltate per dati %d | giorni contati %d",
               (int)gBarreValutate, (int)gBarreFuoriFinestra, (int)gBarreSaltateDati, (int)gGiorniContati);
   PrintFormat("   DUE FEED: metro mancante sulla barra di segnale %d | valutazioni perse per buco nella coda %d | valutazioni con barre di SOLO metro %d | z non calcolabile %d",
               (int)gMetroMancantiUltima, (int)gValutazioniPerseBuco, (int)gValutazioniSoloMetro, (int)gZNonCalcolabile);
   PrintFormat("   C2 giorni spaiati: %d su %d = %.2f%%   %s   (FESTA METRO esclusi dal numeratore, criterio FINESTRA v1.02: %d | controllo criterio CALENDARIO v1.01, atteso 0: %d)",
               (int)gGiorniSpaiati, (int)gGiorniContati, spaiPct,
               (spaiPct > REL_C2_GIORNI_SPAIATI_PCT ? "<<< oltre il 10%: la sonda va rifatta filtrando quei giorni, e si dichiara" : "sotto il 10%"),
               (int)gGiorniFestaMetro, (int)gGiorniMetroZeroCal);
   PrintFormat("   COLLAUDO T6 (deve essere ZERO): attraversamenti scartati perche' era aperto l'ALTRO lato = %d",
               (int)gOccupatoAltroLato);
   PrintFormat("   COLLAUDO T12 (deve essere 0,00%%): tenuta sotto 60 secondi = %.2f%% | chiuse con ZERO barre valutate = %d (v1.03: la tenuta in secondi viene dalle barre, quindi i due numeri sono lo stesso evento)",
               sotto60Pct, (int)gChiuseZeroBarre);
   PrintFormat("   FIX T12 v1.03 (la misura che lo rende falsificabile): ingressi fermati dal gate sulla barra REALE che il gate vecchio lasciava passare = %d. Se e' 0 e T12 fallisce ancora, la diagnosi della v1.03 e' SBAGLIATA.",
               (int)gIngressoBarraRealeFuori);
   PrintFormat("   COLLAUDO T13: scarto medio contro iATR = %.4f%% (con InpAtrModoRma=false atteso ~0; se non lo e', la convenzione di iATR e' Wilder e VA SCRITTO)", atrDiv);
   PrintFormat("   COLLAUDO T14: punto indice = %.5f in prezzo (deve valere 1,00 sui tre indici)", gPuntoIndice);
   PrintFormat("   AUTOTEST: falliti %d su %d blocchi (-1 = NON eseguito, che non e' 'passato')",
               gAutotestFalliti, gAutotestBlocchi);
   PrintFormat("   storico: prima barra GAMBA %s | prima barra METRO %s (il pavimento 2024.09.26 e' misurato su D30EUR/NASUSD, su U30USD lo dice QUESTA riga)",
               TimeToString((datetime)(long)gambaPrima, TIME_DATE|TIME_MINUTES),
               TimeToString((datetime)(long)metroPrima, TIME_DATE|TIME_MINUTES));
   if(gTroncato)
      Print("   >>> ATTENZIONE: raggiunto il tetto dei campioni: LE MEDIANE SONO TRONCATE e non vanno lette.");

   StampaLatoRelativo("LONG",  gGrezziL, gEseguibiliL, eseGL, mfeMedL, maeMedL, rrL,
                      gChiuseL, gConvergL, nonConvL, tenMedL, gMaxGiornoL);
   StampaLatoRelativo("SHORT", gGrezziS, gEseguibiliS, eseGS, mfeMedS, maeMedS, rrS,
                      gChiuseS, gConvergS, nonConvS, tenMedS, gMaxGiornoS);

   Print("--------------------------------------------------------------");
   PrintFormat("[RELATIVO-SONDA] C1 SOMMA DEI DUE LATI: %.3f eseguibili/giorno (pavimento %.2f)   %s",
               eseGT, REL_C1_ESEGUIBILI_GIORNO,
               (eseGT < REL_C1_ESEGUIBILI_GIORNO ? "<<< C1 NON PASSATO: SCARTO IMMEDIATO" : "C1 passato"));
   PrintFormat("   C6 SOMMA DEI DUE LATI: %.2f%% non convergute su %d chiuse   %s",
               nonConvT, (int)chiuseT,
               (c6Esito == 0.0 ? "<<< C6 NON PASSATO: NON E' CONVERGENZA, E' MOMENTUM TRAVESTITO -- muore la famiglia valore-relativo"
                               : (c6Esito == 1.0 ? "C6 SOSPESO (25-40%)" : "C6 passato")));
   PrintFormat("   C7: massimo %d eseguibili in un giorno -> rischio aperto %.2f%% contro un cap di %.2f%%   %s",
               (int)gMaxGiornoTot, rischioMax, REL_C7_CAP_RISCHIO_APERTO,
               (c7Cap > 0.0 ? "<<< InpMaxTradesPerDay VA NELL'EA DAL PRIMO ROUND" : "il cap regge senza limite giornaliero"));
   PrintFormat("   C8: tenuta mediana (due lati) %.2f barre contro un muro di %.0f", tenMedT, REL_C8_TENUTA_BARRE_MIN);
   PrintFormat("   giorni con almeno 2 eseguibili %d | giorni a zero %d | uscite di FINE CORSA escluse da C6: %d",
               (int)gGiorni2Tot, (int)gGiorniZero, (int)gFineCorsa);
   Print("[RELATIVO-SONDA] questa corsa NON promuove niente e NON dice se il motore guadagna: e' un conteggio. Il merito si misura a tick, dopo, e solo se questi numeri reggono.");
   Print("==============================================================");

   //--- ATTENZIONE: 'stats', l'intestazione di OnTesterDeinit e le sue
   //    tre righe di formato SI TOCCANO SEMPRE INSIEME. Il controllo
   //    automatico (ControllaColonne) conta virgole e '%' e URLA: e' il
   //    guardiano che sulla SondaM0PB non c'era.
   //    CONTEGGIO CONGELATO v1.03: REL_NSTATS = 97 valori -> 100 nomi
   //    (Pass, Simbolo, Periodo + 97) -> 100 specificatori -> 100 argomenti.
   double stats[REL_NSTATS];
   stats[0]  = (double)gGrezziL;
   stats[1]  = (double)gGrezziS;
   stats[2]  = (double)gEseguibiliL;
   stats[3]  = (double)gEseguibiliS;
   stats[4]  = (double)gGiorniContati;
   stats[5]  = eseGL;                       // C1 lato LONG
   stats[6]  = eseGS;                       // C1 lato SHORT
   stats[7]  = eseGT;                       // C1 SOMMA: il cancello del mandato
   stats[8]  = greGT;
   stats[9]  = c1Esito;
   stats[10] = mfeMedL;                     // C3 LONG
   stats[11] = mfeMedS;                     // C3 SHORT
   stats[12] = maeMedL;                     // C4 LONG
   stats[13] = maeMedS;                     // C4 SHORT
   stats[14] = rrL;                         // C5 LONG
   stats[15] = rrS;                         // C5 SHORT
   stats[16] = 100.0*WinRateNecessario_Calc(rrL, REL_H8_E_TARGET_R);
   stats[17] = 100.0*WinRateNecessario_Calc(rrS, REL_H8_E_TARGET_R);
   stats[18] = mfeSpL;
   stats[19] = mfeSpS;
   stats[20] = gSpreadMisurato;
   stats[21] = gSogliaC3;
   stats[22] = c3L;
   stats[23] = c3S;
   stats[24] = c5L;
   stats[25] = c5S;
   stats[26] = (double)gChiuseL;
   stats[27] = (double)gChiuseS;
   stats[28] = (double)gConvergL;
   stats[29] = (double)gConvergS;
   stats[30] = nonConvL;
   stats[31] = nonConvS;
   stats[32] = nonConvT;                    // C6: il numero che uccide o salva la tesi
   stats[33] = (double)gFineSessL;
   stats[34] = (double)gFineSessS;
   stats[35] = (double)gTettoL;
   stats[36] = (double)gTettoS;
   stats[37] = (double)gFineCorsa;
   stats[38] = c6Esito;
   stats[39] = (double)gMaxGiornoL;
   stats[40] = (double)gMaxGiornoS;
   stats[41] = (double)gMaxGiornoTot;       // C7
   stats[42] = rischioMax;
   stats[43] = c7Cap;
   stats[44] = (double)gGiorni2Tot;
   stats[45] = (double)gGiorniZero;
   stats[46] = tenMedL;                     // C8 LONG
   stats[47] = tenMedS;                     // C8 SHORT
   stats[48] = tenMedT;                     // C8 due lati
   stats[49] = sotto60Pct;                  // collaudo T12: deve essere 0
   stats[50] = c8Esito;
   stats[51] = mfeOrMedL;                   // T11: indipendenti dalla regola d'uscita
   stats[52] = mfeOrMedS;
   stats[53] = maeOrMedL;
   stats[54] = maeOrMedS;
   stats[55] = movOrMedL;                   // l'unico numero SEGNATO della sonda
   stats[56] = movOrMedS;
   stats[57] = (double)gNMfeOrL;            // numerosita' VERA delle mediane a orizzonte
   stats[58] = (double)gNMfeOrS;
   stats[59] = (double)gOsIncompletiL;
   stats[60] = (double)gOsIncompletiS;
   stats[61] = (double)gBarreValutate;
   stats[62] = (double)gBarreFuoriFinestra;
   stats[63] = (double)gBarreSaltateDati;
   stats[64] = (double)gMetroMancantiUltima;   // T1
   stats[65] = (double)gValutazioniPerseBuco;  // T2: il COSTO della regola stretta
   stats[66] = (double)gValutazioniSoloMetro;  // T3: l'altra meta' dei giorni spaiati
   stats[67] = (double)gBarreSenzaZAperta;
   stats[68] = (double)gZNonCalcolabile;
   stats[69] = (double)gGiorniSpaiati;
   stats[70] = spaiPct;                     // C2
   stats[71] = c2Esito;
   stats[72] = (double)gAttrIngressoFuori;  // T7
   stats[73] = (double)gAttrPrimaBarra;     // T9
   stats[74] = (double)gOccupatoStessoL;
   stats[75] = (double)gOccupatoStessoS;
   stats[76] = (double)gOccupatoAltroLato;  // COLLAUDO T6: DEVE VENIRE ZERO
   stats[77] = atrMed;                      // eco T13
   stats[78] = atrDiv;                      // collaudo T13
   stats[79] = gPuntoIndice;                // collaudo T14: deve valere 1,00
   stats[80] = metroPrima;
   stats[81] = gambaPrima;
   stats[82] = (gTroncato ? 1.0 : 0.0);
   stats[83] = (double)gAutotestFalliti;    // 0 = passati; >0 DIVERGE; -1 NON eseguito
   stats[84] = (double)gAutotestBlocchi;
   stats[85] = (double)InpFinestraN;        // eco degli ASSI e dei pin
   stats[86] = InpSogliaIngressoSigma;
   stats[87] = InpSogliaUscitaSigma;
   stats[88] = (double)InpModoSpread;
   stats[89] = (double)InpModoZScore;
   stats[90] = (double)InpBarreMaxTenuta;
   stats[91] = (double)InpBarreOrizzonte;
   stats[92] = (double)InpLato;
   stats[93] = (double)gGiorniFestaMetro;   // FIX C2 v1.01/v1.02: informativo, ESCLUSI dal numeratore C2
   stats[94] = (double)gGiorniMetroZeroCal; // CONTROLLO v1.02: quante volte mordeva il criterio di CALENDARIO v1.01 (atteso 0)
   stats[95] = (double)gIngressoBarraRealeFuori; // FIX T12 v1.03: quante volte il gate NUOVO ha morso dove il vecchio passava. Se 0 e T12 fallisce ancora, la diagnosi e' sbagliata
   stats[96] = (double)gChiuseZeroBarre;         // COLLAUDO T12 in conteggio secco: posizioni chiuse senza aver valutato UNA barra (atteso 0)

   if(InpScriviCsv && !MQLInfoInteger(MQL_OPTIMIZATION)) ScriviCsvTotali(stats);

   //--- MT5 vuole un criterio di ottimizzazione. Qui NON si sceglie
   //    niente e NESSUNA CELLA VIENE PROMOSSA: si dichiara il numero di
   //    attraversamenti ESEGUIBILI, che e' cio' che la sonda conta.
   //    Leggerlo per sbaglio come "il migliore" vorrebbe dire "quello
   //    che ha contato di piu'", e contare di piu' NON e' un merito:
   //    la finestra n e' proprio la manopola della frequenza, quindi il
   //    massimo di questo criterio e' la finestra piu' corta, sempre.
   double criterion = (double)(gEseguibiliL + gEseguibiliS);
   FrameAdd(OPTFRAME_NAME, OPTFRAME_ID, criterion, stats);
   return(criterion);
  }

//+------------------------------------------------------------------+
//| CSV dei totali della corsa singola: gli stessi numeri delle        |
//| colonne, in un file, cosi' il referto non dipende dal log.         |
//+------------------------------------------------------------------+
void ScriviCsvTotali(const double &s[])
  {
   string f = StringFormat("ABTG_SondaRelativo_%s_%s_%s_totali.csv",
                           _Symbol, InpSimboloMetro, EnumToString((ENUM_TIMEFRAMES)Period()));
   int h = FileOpen(f, FILE_WRITE|FILE_CSV|FILE_ANSI, ";");
   if(h == INVALID_HANDLE)
     { Log(StringFormat("CSV totali non scritto (err %d).", GetLastError())); return; }

   FileWrite(h, "cancello", "grandezza", "LONG", "SHORT", "soglia congelata");
   FileWrite(h, "C1", "eseguibili al giorno", DoubleToString(s[5], 3), DoubleToString(s[6], 3),
             StringFormat("somma dei due lati %.3f, pavimento %.2f", s[7], REL_C1_ESEGUIBILI_GIORNO));
   FileWrite(h, "C2", "giorni spaiati pct", DoubleToString(s[70], 2), "",
             StringFormat("oltre %.0f%% la sonda va rifatta filtrando quei giorni", REL_C2_GIORNI_SPAIATI_PCT));
   FileWrite(h, "-", "giorni festa metro (informativo)", DoubleToString(s[93], 0), "",
             "fix v1.02: giorno con ZERO barre del metro DENTRO LA FINESTRA ORARIA = festivita' propria del suo mercato (T3), ESCLUSO dal numeratore C2");
   FileWrite(h, "-", "giorni metro zero calendario (controllo)", DoubleToString(s[94], 0), "",
             "criterio VECCHIO v1.01 (zero barre in TUTTO il giorno): atteso 0 con un metro quasi 24h -- se e' 0, e' PROVATO perche' la v1.01 non spostava un centesimo");
   FileWrite(h, "C3", "MFE mediana punti indice", DoubleToString(s[10], 3), DoubleToString(s[11], 3),
             StringFormat(">= %.2f = %.0f x spread MISURATO %.2f (ora peggiore 14-21)",
                          s[21], REL_C3_MULTIPLO_SCARTO, s[20]));
   FileWrite(h, "C3", "MFE in multipli di spread", DoubleToString(s[18], 3), DoubleToString(s[19], 3),
             StringFormat("< %.0f scarto | > %.0f passa largo", REL_C3_MULTIPLO_SCARTO, REL_C3_MULTIPLO_LARGO));
   FileWrite(h, "C4", "MAE mediana punti indice", DoubleToString(s[12], 3), DoubleToString(s[13], 3),
             "nessun cancello: e' il pavimento dello SL (R109)");
   FileWrite(h, "C5", "RR = C3/C4", DoubleToString(s[14], 4), DoubleToString(s[15], 4),
             StringFormat(">= %.2f, altrimenti SCARTO PER ARITMETICA (H8)", REL_C5_RR_MINIMO));
   FileWrite(h, "C5", "win rate necessario pct", DoubleToString(s[16], 2), DoubleToString(s[17], 2),
             StringFormat("perche' E >= %.3fR", REL_H8_E_TARGET_R));
   FileWrite(h, "C6", "non convergute pct", DoubleToString(s[30], 2), DoubleToString(s[31], 2),
             StringFormat("due lati %.2f%% | > %.0f scarto, %.0f-%.0f sospeso",
                          s[32], REL_C6_NON_CONVERGUTE_KO, REL_C6_NON_CONVERGUTE_SOSP, REL_C6_NON_CONVERGUTE_KO));
   FileWrite(h, "C6", "chiuse / convergute", StringFormat("%.0f / %.0f", s[26], s[28]),
             StringFormat("%.0f / %.0f", s[27], s[29]),
             StringFormat("fine sessione %.0f/%.0f, tetto %.0f/%.0f, fine corsa esclusa %.0f",
                          s[33], s[34], s[35], s[36], s[37]));
   FileWrite(h, "C7", "massimo eseguibili in un giorno", DoubleToString(s[39], 0), DoubleToString(s[40], 0),
             StringFormat("totale %.0f -> rischio aperto %.2f%% contro cap %.2f%%", s[41], s[42], REL_C7_CAP_RISCHIO_APERTO));
   FileWrite(h, "C8", "tenuta mediana barre", DoubleToString(s[46], 2), DoubleToString(s[47], 2),
             StringFormat("due lati %.2f | muro d'attrito %.0f", s[48], REL_C8_TENUTA_BARRE_MIN));
   FileWrite(h, "C8", "tenuta sotto 60 secondi pct", DoubleToString(s[49], 2), "",
             StringFormat("COLLAUDO T12: deve essere 0,00 | scarto prop a %.0f%%", REL_C8_QUOTA_SOTTO60_KO));
   FileWrite(h, "-", "chiuse con ZERO barre (collaudo T12)", DoubleToString(s[96], 0), "",
             "v1.03: la tenuta in secondi viene dalle BARRE VALUTATE, quindi 'sotto 60 s' = 'zero barre'. Atteso 0");
   FileWrite(h, "-", "ingressi barra reale fuori (fix T12 v1.03)", DoubleToString(s[95], 0), "",
             "quante volte il gate T7 sulla barra REALE ha fermato un ingresso che il gate vecchio (barra teorica tSeg+TF) lasciava passare. Se 0 e T12 fallisce ancora, la diagnosi v1.03 e' SBAGLIATA");
   FileWrite(h, "-", "attraversamenti grezzi", DoubleToString(s[0], 0), DoubleToString(s[1], 0),
             StringFormat("%.3f al giorno", s[8]));
   FileWrite(h, "-", "attraversamenti eseguibili", DoubleToString(s[2], 0), DoubleToString(s[3], 0),
             "T6: quelli presi a slot libero");
   FileWrite(h, "-", "scartati slot occupato stesso lato", DoubleToString(s[74], 0), DoubleToString(s[75], 0), "");
   FileWrite(h, "-", "scartati slot occupato ALTRO lato", DoubleToString(s[76], 0), "",
             "COLLAUDO T6: DEVE VENIRE ZERO, altrimenti la macchina a stati e' rotta");
   FileWrite(h, "-", "MFE a orizzonte fisso", DoubleToString(s[51], 3), DoubleToString(s[52], 3),
             StringFormat("su %.0f/%.0f osservatori completi (T11)", s[57], s[58]));
   FileWrite(h, "-", "MAE a orizzonte fisso", DoubleToString(s[53], 3), DoubleToString(s[54], 3),
             StringFormat("incompleti scartati %.0f/%.0f", s[59], s[60]));
   FileWrite(h, "-", "movimento netto a orizzonte", DoubleToString(s[55], 3), DoubleToString(s[56], 3),
             "l'unico numero SEGNATO: positivo = a favore del lato");
   FileWrite(h, "-", "giorni contati", DoubleToString(s[4], 0), "", "T15");
   FileWrite(h, "-", "giorni con almeno 2 eseguibili", DoubleToString(s[44], 0), "", "");
   FileWrite(h, "-", "giorni a zero eseguibili", DoubleToString(s[45], 0), "", "");
   FileWrite(h, "-", "barre valutate / fuori finestra", DoubleToString(s[61], 0), DoubleToString(s[62], 0), "T8");
   FileWrite(h, "-", "barre saltate per dati", DoubleToString(s[63], 0), "", "deve essere ~0 a regime");
   FileWrite(h, "-", "metro mancante sulla barra di segnale", DoubleToString(s[64], 0), "", "T1");
   FileWrite(h, "-", "valutazioni perse per buco nella coda", DoubleToString(s[65], 0), "",
             "T2: il COSTO della regola stretta");
   FileWrite(h, "-", "valutazioni con barre di solo metro", DoubleToString(s[66], 0), "", "T3");
   FileWrite(h, "-", "z non calcolabile", DoubleToString(s[68], 0), "", "deviazione o MAD nulla");
   FileWrite(h, "-", "barre senza z con posizione aperta", DoubleToString(s[67], 0), "", "");
   FileWrite(h, "-", "attraversamenti con ingresso fuori finestra", DoubleToString(s[72], 0), "", "T7");
   FileWrite(h, "-", "attraversamenti sulla prima barra di sessione", DoubleToString(s[73], 0), "",
             "T9: da sottrarre, non da indovinare");
   FileWrite(h, "-", "ATR mediano punti indice", DoubleToString(s[77], 4), "", "T13: eco, non motore");
   FileWrite(h, "-", "scarto medio pct contro iATR", DoubleToString(s[78], 4), "", "collaudo T13");
   FileWrite(h, "-", "punto indice in prezzo", DoubleToString(s[79], 5), "", "T14: deve valere 1,00");
   FileWrite(h, "-", "prima barra metro / gamba (epoch)", DoubleToString(s[80], 0), DoubleToString(s[81], 0),
             "profondita' VERA dello storico dei due feed");
   FileWrite(h, "-", "campioni troncati", DoubleToString(s[82], 0), "", "1 = mediane TRONCATE, non leggere");
   FileWrite(h, "-", "autotest falliti su blocchi", DoubleToString(s[83], 0), DoubleToString(s[84], 0),
             "0 falliti = passato; -1 = NON eseguito");
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

   //--- 100 nomi (v1.03) = Pass + Simbolo + Periodo + 97 valori di stats[].
   string head = "Pass,Simbolo,Periodo,"
                 "Attraversamenti Grezzi Long,Attraversamenti Grezzi Short,"
                 "Attraversamenti Eseguibili Long,Attraversamenti Eseguibili Short,"
                 "Giorni Contati,Eseguibili Al Giorno Long,Eseguibili Al Giorno Short,"
                 "Eseguibili Al Giorno Totale,Grezzi Al Giorno Totale,C1 Esito,"
                 "Mfe Mediana Long Punti Indice,Mfe Mediana Short Punti Indice,"
                 "Mae Mediana Long Punti Indice,Mae Mediana Short Punti Indice,"
                 "Rr Da Mediane Long,Rr Da Mediane Short,"
                 "Win Rate Necessario Long Pct,Win Rate Necessario Short Pct,"
                 "Mfe Su Spread Long,Mfe Su Spread Short,"
                 "Spread Misurato Punti Indice,Soglia C3 Punti Indice,"
                 "C3 Esito Long,C3 Esito Short,C5 Esito Long,C5 Esito Short,"
                 "Chiuse Long,Chiuse Short,Convergute Long,Convergute Short,"
                 "Non Convergute Long Pct,Non Convergute Short Pct,Non Convergute Totale Pct,"
                 "Uscite Fine Sessione Long,Uscite Fine Sessione Short,"
                 "Uscite Tetto Barre Long,Uscite Tetto Barre Short,Uscite Fine Corsa Escluse,C6 Esito,"
                 "Max Eseguibili Giorno Long,Max Eseguibili Giorno Short,Max Eseguibili Giorno Totale,"
                 "Rischio Aperto Max Pct,C7 Cap Necessario,"
                 "Giorni Almeno 2 Eseguibili,Giorni Zero Eseguibili,"
                 "Tenuta Mediana Long Barre,Tenuta Mediana Short Barre,Tenuta Mediana Totale Barre,"
                 "Sotto 60 Secondi Pct,C8 Esito,"
                 "Mfe Orizzonte Mediana Long,Mfe Orizzonte Mediana Short,"
                 "Mae Orizzonte Mediana Long,Mae Orizzonte Mediana Short,"
                 "Movimento Orizzonte Mediano Long,Movimento Orizzonte Mediano Short,"
                 "Orizzonte Completo Long,Orizzonte Completo Short,"
                 "Orizzonte Incompleto Long,Orizzonte Incompleto Short,"
                 "Barre Valutate,Barre Fuori Finestra,Barre Saltate Dati,"
                 "Valutazioni Metro Mancante Segnale,Valutazioni Perse Buco Finestra,"
                 "Valutazioni Con Solo Metro,Barre Senza Z Con Posizione Aperta,Z Non Calcolabile,"
                 "Giorni Spaiati,Giorni Spaiati Pct,C2 Esito,"
                 "Attraversamenti Ingresso Fuori Finestra,Attraversamenti Prima Barra Sessione,"
                 "Occupato Stesso Lato Long,Occupato Stesso Lato Short,"
                 "Scartati Occupato Altro Lato Collaudo,"
                 "Atr Mediano Punti Indice,Atr Divergenza Rel Media Pct,Punto Indice Prezzo,"
                 "Metro Prima Barra Epoch,Gamba Prima Barra Epoch,Campioni Troncati,"
                 "Autotest Falliti,Autotest Blocchi,"
                 "Finestra N,Soglia Ingresso Sigma,Soglia Uscita Sigma,"
                 "Modo Spread,Modo Z Score,Barre Max Tenuta,Barre Orizzonte,Lato Attivo,"
                 "Giorni Festa Metro,Giorni Metro Zero Calendario,"
                 "Ingressi Barra Reale Fuori,Chiuse Zero Barre";

   //--- LA RIGA E' SPEZZATA IN TRE, E NON E' ESTETICA: MQL5 non accetta
   //    piu' di 64 parametri per chiamata, e qui gli argomenti sono 100
   //    (v1.01: +1 per "Giorni Festa Metro", data[93], in coda a fmt3;
   //     v1.02: +1 per "Giorni Metro Zero Calendario", data[94];
   //     v1.03: +2 per "Ingressi Barra Reale Fuori" (data[95]) e
   //            "Chiuse Zero Barre" (data[96]), fix T12).
   //    Un solo StringFormat non compilerebbe.
   string fmt1 = "%d,%s,%s,%.0f,%.0f,%.0f,%.0f,%.0f,%.3f,%.3f,%.3f,%.3f,%.0f,%.3f,%.3f,%.3f,%.3f,%.4f,%.4f,%.2f,%.2f,%.3f,%.3f,%.2f,%.2f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f";
   string fmt2 = "%.2f,%.2f,%.2f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.2f,%.0f,%.0f,%.0f,%.2f,%.2f,%.2f,%.2f,%.0f,%.3f,%.3f,%.3f,%.3f,%.3f,%.3f,%.0f,%.0f,%.0f,%.0f";
   string fmt3 = "%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.2f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.4f,%.4f,%.5f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.3f,%.3f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f";
   ControllaColonne(head, fmt1 + "," + fmt2 + "," + fmt3);

   while(FrameNext(pass, name, id, value, data))
     {
      string params[]; uint pcount = 0;
      FrameInputs(pass, params, pcount);
      if(!header_scritto)
        {
         string testa = head;
         for(uint i = 0; i < pcount; i++)
           { string kv[]; if(StringSplit(params[i], '=', kv) == 2) testa += "," + kv[0]; }
         FileWrite(h, testa); header_scritto = true;
        }
      string row = StringFormat(fmt1,
                                (int)pass, _Symbol, periodo,
                                data[0],  data[1],  data[2],  data[3],  data[4],  data[5],
                                data[6],  data[7],  data[8],  data[9],  data[10], data[11],
                                data[12], data[13], data[14], data[15], data[16], data[17],
                                data[18], data[19], data[20], data[21], data[22], data[23],
                                data[24], data[25], data[26], data[27], data[28], data[29]);
      row += "," + StringFormat(fmt2,
                                data[30], data[31], data[32], data[33], data[34], data[35],
                                data[36], data[37], data[38], data[39], data[40], data[41],
                                data[42], data[43], data[44], data[45], data[46], data[47],
                                data[48], data[49], data[50], data[51], data[52], data[53],
                                data[54], data[55], data[56], data[57], data[58], data[59],
                                data[60]);
      row += "," + StringFormat(fmt3,
                                data[61], data[62], data[63], data[64], data[65], data[66],
                                data[67], data[68], data[69], data[70], data[71], data[72],
                                data[73], data[74], data[75], data[76], data[77], data[78],
                                data[79], data[80], data[81], data[82], data[83], data[84],
                                data[85], data[86], data[87], data[88], data[89], data[90],
                                data[91], data[92], data[93], data[94], data[95], data[96]);
      for(uint i = 0; i < pcount; i++)
        { string kv[]; if(StringSplit(params[i], '=', kv) == 2) row += "," + kv[1]; }
      FileWrite(h, row); righe++;
     }
   FileClose(h);
   PrintFormat("OptFrame: scritte %d passate in MQL5\\Files\\%s", righe, fname);
  }
//================== fine OPTFRAME inlined ==========================//
