# Ea Nat&Cla - note sul CODICE di `EA_NatCla.mq5` v1.00 (07/10/2026)

**STATO: strato 1 fatto; strato 2 (`controllo-preventivo`, 07/10): PASS CON RISERVE (par. 5); seconda lettura (07/10, par. 6): PASS CON RISERVE, v1.01, **serve un TERZO lettore** sulle righe nuove dei pendenti. Solo DEMO/TESTER: niente di questo
EA va su un conto senza la prima compilazione, un giro nel tester e una firma di Claudio.**
Il file NON e' stato compilato (nessun MetaEditor qui) e NON e' girato nel tester. Nessun backtest lanciato, VPS non toccato.

- Codice: `mql5/Experts/EA_NatCla.mq5` (2048 righe, ASCII puro). Regole SOLO da `report/NATCLA_SPECIFICA_2026-10-07.md`.
- Collaudo: `python3 backtest_pipeline/collaudo_natcla.py` (circa 2 minuti; `--senza-mutanti` circa 16 s). Esito al commit del cancello: **TUTTO OK**, mutanti ciechi **43/43 presi** (21 dell'autore + 22 del cancello, par. 5).

## 1. Che cosa il collaudo ha MISURATO (feed HistData dell'oro, orologio +6 h, NON BCM)

| controllo | esito |
|---|---|
| `NC_STCore` == `SW_STCore` della casa (testo) e == `py_stcore` bit per bit, 3 livelli, 21.228 barre H1 | 0 differenze |
| `NC_Episodi` (scansione all'indietro, C++ vero) == macchina a stati in avanti (Python indipendente), 4 linee x 3 configurazioni (base; SFIORA + distacco; placebo 1 ATR) | 0 differenze su ogni barra |
| finestra EA di 1500 barre == serie intera (534 punti, ST 2.5 e 3.5) | 0 differenze, 0 segmenti troncati |
| contro-esempio: finestra di 40 barre | 62/83 differenze: il controllo morde |
| episodi/anno AUDIO H1, 2024-07-10 -> 2026-09-18 | **150,7 / 121,0 / 97,2** (specifica 151 / 121 / 97) |
| entro il limite audio 1/1/2 | **101,4 / 84,9 / 88,1** (specifica 101 / 84 / 88) |
| + ADX **Wilder** <= 20 alla barra del tocco | **40,2 / 35,6 / 35,6** (specifica 37/34/37, ricontato dal cancello 40/36/36) |
| + ADX Wilder alla barra PRIMA (quella in cui la scala si arma) | 37,4 / 34,2 / 37,9 |
| + ADX **iADX di MT5** <= 20 (specchio di ADX.mq5 scritto a memoria, **NON verificato col terminale**) | **16,4 / 17,8 / 15,5** |
| H4 / D1 (informativo, dipendono dall'orologio) | 44/25/26 e 5/5/3 episodi; +ADX Wilder 11/6/10 e 1/0/1 |

## 2. Il punto che pesa: QUALE ADX (deciso dal cancello il 07/10: resta `iADX`, la specifica e' stata corretta)

La specifica dice **`iADX`** al par. 2.1, ma la frequenza attesa del par. 5.4 ("35-40 setup l'anno per linea") e' contata con
l'**ADX di Wilder**. Le due formule NON danno lo stesso numero: con lo specchio di `iADX` la soglia `<= 20` lascia passare
**meno della meta'** dei setup (16-18 l'anno contro 36-40). Nel codice ho messo l'input `InpAdxTipo` con default **`iADX`**
(lettera della specifica, par. 2.1) e `iADXWilder` come asse.

**Decisione del cancello (07/10)**: il default resta **`iADX`** e si e' corretta la specifica (commit a parte, par. 5.4 e E0).
~~Il motivo: il materiale del gruppo e' MT5 su BCM~~ *(argomento ritirato dalla terza lettura 07/10: le immagini del PDF non
contengono nessun ADX, e il PDF non e' piu' una fonte di questo EA)*. **Il motivo vero, in parole semplici: e' un'assunzione.**
L'audio dice solo "ADX a 20", non su che programma lo guarda: su MT5 "ADX" e' `iADX`, su TradingView e' Wilder, e con la formula
sbagliata il "20" si sposta **in tutti e due i versi** (oro H1: Wilder 20 ~ `iADX` 23; `iADX` 20 ~ Wilder 17). `iADX` resta il
default perche' e' quello del programma su cui gira l'EA e perche' e' il **piu' stretto** (sbagliando, si perdono setup, non si
aprono setup in piu'). Va chiesto alla collega (bloccante 9). Ricontato dal cancello con un programma suo: 16,4 / 17,8 / 15,5 (identico). Su **H4** il filtro letterale
lascia **1-5 setup l'anno** per linea sull'oro. Lo specchio di `iADX` resta **[DA CONFERMARE sul terminale]** (scritto a memoria
da due mani diverse, con lo stesso risultato: non e' una verifica).

## 3. Interpretazioni [NOSTRA] entrate nel codice OLTRE quelle gia' scritte nella specifica

1. **Tocco valido** (C1-C3): oltre a "niente flip sulla barra" serve la chiusura non oltre la linea in vigore. Per i Supertrend e'
   la stessa condizione; per la EMA200 (M2) e per il placebo e' una condizione in piu', dichiarata.
2. **Direzione della EMA200** (M2): +1 se la chiusura sta sopra la EMA, -1 sotto; chiusura uguale = direzione precedente.
3. **ADX mai sulla EMA200**: `TUTTE` = le tre linee Supertrend (nessuna fonte lega l'ADX alla EMA).
4. **Modalita' EMA200** (base M2, par. 3.3): scala AUDIO, inclinazione accesa, ADX spento, nessun limite di tocchi,
   stop sull'ordine profondo, TP dalla linea.
5. **Contesto** misurato alla barra chiusa `last`: per la scala e' la barra PRIMA del riempimento, per il PDF e' la barra del
   tocco. La confluenza si misura sulla linea USATA (spostata dal placebo, se acceso).
6. **Unita' AUTO_CLASSE**: XAU/XAG dal nome -> 1,0; modalita' di calcolo forex **oppure base e profitto due valute vere**
   (aggiunto dal cancello, regola di casa di `ABTG_EMA200_Dashboard`: un forex servito come CFD resta forex) -> pip; il resto -> 1,0.
   Aggiunto `NC_UNITA_MANUALE` per l'asse dell'oro a 0,1 USD. L'unita' risolta si legge nella riga d'avvio: **va guardata** al
   primo giro su ogni simbolo.
7. **Magic**: `InpMagic=0` -> automatico `7786` + motore + TF (H1/H4/H12/D1); per W1 e altri TF va messo a mano. Fuori dal
   blocco 778600-778699 l'EA non parte. Blocco verificato libero nel repo (collaudo); i **preset vivi sui terminali** restano da
   verificare (non sono nel repo).
8. **Contraddizione interna della specifica su `InpMoltConfluenza`** (par. 2.1 "rifiuta l'avvio" contro S4 "lo tronca"): ho
   seguito il par. 2.1 (rifiuto all'avvio, lato prudente) e tenuto anche il troncamento a runtime come seconda rete.
9. **Scala**: i tre LIMIT sono GTC, cancellati e ripiazzati a ogni barra (il lotto cambia con la distanza dallo stop). Un ordine
   il cui prezzo e' gia' stato superato dal mercato **si scarta** (non diventa un ordine a mercato). **Rischio dichiarato**: se
   l'EA si ferma, i limit restano vivi al prezzo vecchio (con il loro stop). I pendenti PDF hanno la scadenza sul server, se il
   simbolo la accetta, e comunque gestita dall'EA.
10. **Lotti**: calcolati sugli ordini rimasti; un ordine scartato sotto il minimo NON fa ricalcolare gli altri (prudente).
    Tolleranza di arrotondamento 1e-9 step (0,30/0,01 resta 30 step; 0,299999999 lotti restano 0,29).
11. **PDF**: il secondo ordine e' un LIMIT (pseudocodice della specifica; l'analisi PDF dice che il tipo non e' scritto). Se la
    tranche a mercato fallisce, il pendente da solo non parte. Ingresso a mercato solo entro 300 s dall'apertura della barra
    (convenzione `InpGraceSec` di `ABTG_EMA200_Ombra`): dopo un riavvio a meta' barra niente ingresso tardivo.
12. **TP1 raggiunto** (PDF): oltre a parziale e pareggio si cancellano i pendenti residui (nessun riempimento nuovo dopo il
    pareggio). Il pareggio va al prezzo medio ponderato solo se migliora lo stop ed e' lecito rispetto allo stops level.
13. **X10**: la prima uscita di una qualunque posizione del setup (TP o SL) cancella i pendenti residui.
14. **Conti netting rifiutati** (ogni ordine della scala deve restare una posizione con la sua etichetta nel commento).
15. **Riavvio**: le posizioni con etichetta si ADOTTANO; i pendenti senza posizione si cancellano e la scala si riarma dai dati.
    TP1, pareggio e chiave dell'episodio **non sono ricostruibili** dopo un riavvio (scritto a log).
16. **CSV per-setup** (`natcla_setup_<simbolo>_<magic>.csv`, cartella comune) non scritto in ottimizzazione; l'export di casa
    `abtg_trades_...` ha una colonna in piu' IN CODA (`entry_comment`), le prime 8 restano identiche.
17. **Costo**: `InpCommissionePrezzo` (commissione in prezzo, 0 = non contata) e `InpCancelloCostoX=40` solo come AVVISO in log e
    colonna `stop_ped` nel CSV: **non blocca** niente.

## 4. Cosa il cancello deve guardare (strato 2)

- **Semaforo con piu' linee armate** (lettera della specifica, E7/2.2): sulla scala AUDIO le tre linee possono avere limit vivi
  insieme; se due si riempiono nello stesso tick (linee vicine, spike) i setup aperti diventano 2-3, cioe' **fino a 3 R**. Il
  codice lo CONTA (`semaforo sforato`) e lo scrive a log ma **non chiude**. Va deciso se basta.
- **Buco B6** del Guardian: con la scala il rischio vive nei pendenti, che C1 non vede.
- **ADX** (par. 2 qui sopra): default `iADX` contro frequenza contata con Wilder.
- **Compilazione**: la lista delle 69 funzioni MQL5 e dei 13 metodi CTrade con il numero di argomenti e' controllata dal
  collaudo, ma solo MetaEditor puo' dire se compila (tipi, overload, avvisi).
- **Non provato**: riempimenti, cancellazione e riprezzamento nel tester, `OnTradeTransaction`, il Guardian, `iATR`/`iMA`/`iADX`
  del terminale, il calcolo di `OrderCalcProfit`, l'orologio BCM, il modo PDF a mercato (nessun dato di tick qui).

## 5. Il cancello (strato 2, `controllo-preventivo`, 07/10/2026): PASS CON RISERVE

**Che cosa e' stato controllato, e com'e' andata** (anche i controlli passati):
- **Letto riga per riga** tutto il file. Passati: lo stop c'e' SEMPRE (rifiuto di `sl<=0` prima di ogni invio, lato giusto
  per BUY/SELL, distanza minima = il maggiore fra STOPS_LEVEL e FREEZE_LEVEL); lotti **per difetto** allo step, mai alzati al
  minimo, tetto al massimo; perdita per lotto con `OrderCalcProfit` (vale per forex, oro e indici: il conto lo fa il broker);
  pendenti PDF con scadenza; scala riprezzata a ogni barra; residui cancellati alla prima uscita (X10), al TP1 e al flip;
  retcode controllato (solo DONE/PLACED/DONE_PARTIAL); conto netting rifiutato; Guardian chiamato subito prima di OGNI
  apertura; handle a `INVALID_HANDLE` e rilasciati; `CopyBuffer` dopo `BarsCalculated`; ore solo del server (nessuna regola
  d'orario); niente rete, DLL, `#import`; CSV nella cartella comune di MQL5 (convenzione di casa).
- **Fedelta' alla specifica**: 47 righe della tabella regola|input|default confrontate a mano con gli input (nome, tipo,
  default, colonne AUDIO/PDF/EMA200): **tutte uguali**. Bandiere rosse spente con AVVISO in log; rischio 0,25% "DA FIRMARE";
  magic 7786xx: **zero collisioni** su tutti i 23 rami del repo, preset compresi; TF sotto H1 e placebo fuori dal tester rifiutati.
- **Guardian, buco B6 riletto alla fonte**: `ABTG_Guardian.mq5` r.385-413 (`OpenRiskPct`, il cap C1) somma **solo le posizioni**
  con SL: i pendenti **non** si contano. Confermato. Attenuazione propria di questo EA: la scala si cancella e si ripiazza a ogni
  barra passando di nuovo dal Guardian, quindi un pendente vive al massimo **una barra** dopo che il cap si e' chiuso.
- **Frequenze rifatte con un programma indipendente** (oro HistData, +6 h): 150,5 / 120,4 / 97,1 episodi l'anno (autore
  150,7 / 121,0 / 97,2), 101,2 / 84,4 / 88,0 entro il limite, 40,1 / 35,6 / 35,6 con Wilder, 16,4 / 17,8 / 15,5 con `iADX`:
  scarti sotto 0,6 l'anno. Barra di prova 14/08/2025 05:00 (+6 h): ADX Wilder 12,96, `iADX` 20,98.
- **Mutanti ciechi del cancello, su copie fuori dal repo**: primo giro 8 (lato, SL, lotto, conteggio, ADX, inclinazione,
  orologio, riga d'avvio): **6 su 8 passavano** il collaudo. Secondo giro 10 nuovi (ATR sfasato, semaforo, conteggio, direzione,
  default DA_MODALITA, stop, rischio x10, perdita per lotto, pip x10, X10): **10 su 10 passavano**. Rimedio: quattro funzioni
  spostate nel blocco puro (pip, lato ammesso, rischio in soldi, controllo del pendente: stesse righe, ora provate per
  comportamento) + 14 invarianti sul raccordo nel collaudo (sezione R). Dopo: **43/43 presi**.

**Che cosa ho cambiato nel codice (serve un SECONDO LETTORE: e' codice scritto dal cancello)**: le quattro funzioni pure qui
sopra (spostate, non riscritte), l'unita' forex per valute (punto 6 del par. 3), due commenti (ADX, stato in testa).

**Riserve (non bloccano il demo/tester, vanno lette prima di un conto vero):**
1. **Residuo del collaudo, dichiarato**: terzo giro di 10 mutanti nuovi, **6 restano VERDI** (scadenza applicata anche alla
   scala, verso del TP1, durata in secondi, unita' dell'oro, conferma PDF rovesciata, adozione al riavvio). Quelle righe le ho
   LETTE e sono giuste, ma il collaudo non le vede: le prova solo il tester.
2. **Semaforo sforabile**: con piu' linee armate, un salto di prezzo (apertura del lunedi', notizia) puo' riempirne 2-3 nello
   stesso istante = fino a **3 R** per istanza (max 1 setup per linea, 3 linee nel modo AUDIO). Il codice lo conta e lo scrive,
   non chiude. La specifica (E7) prevede la cancellazione al riempimento, non questo caso: **e' un limite dichiarato**, e il
   collaudo nel tester deve contare quante volte succede.
3. **Ordine d'anticipo senza tocco**: se il prezzo arriva a 5 u dalla linea senza toccarla, l'ordine d'anticipo si riempie ma
   il conteggio dei tocchi (che si fa sulle candele) non sale: la linea puo' dare piu' di un setup prima del "primo tocco".
   E' una conseguenza di due letture [NOSTRA] che non coincidono; il CSV la rende misurabile (stesso `tocco_n` ripetuto).
4. **Riavvio**: i limit della scala restano vivi se l'EA viene tolto (convenzione di casa, con il loro stop); dopo un riavvio
   TP1, pareggio e chiave dell'episodio non si ricostruiscono: un episodio gia' usato puo' essere riarmato una volta.
5. **`iADX` scritto a memoria** (vedi par. 2).

**NON COPERTO**: compilazione (nessun MetaEditor qui), Strategy Tester, riempimenti e ordine degli eventi nel tester,
`OnTradeTransaction`, il Guardian vivo, `iADX`/`iATR`/`iMA` del terminale, `OrderCalcProfit` del broker, l'orologio BCM, i
preset vivi sui terminali (fuori dal repo) per il magic.


## 6. Seconda lettura indipendente (`controllo-preventivo`, 07/10/2026): PASS CON RISERVE, v1.01, serve un TERZO lettore

**Controllato, e com'e' andata** (anche i passati):
- **ADX**: lo specchio `py_adx_mt5` coincide con `ADX.mq5` di MetaQuotes come lo ricordo io (DM pulito per barra, DI = 100 x DM/TR
  **barra per barra**, EMA `2/(n+1)` su +DI, -DI e DX, seme 0): stessa formula, terza mano. Resta memoria, non misura.
  **Le immagini del PDF NON contengono un ADX** (`NATCLA_ANALISI_PDF` r.174; p22 riletta: sotto-finestre `PeakRepairerStrict` e
  `ATR(14)`): che il gruppo lavori su MT5/BCM e' vero (`EURUSD.bcm`, `CHFJPY.bcm`), ma l'ADX viene **solo dall'audio** e la
  piattaforma della collega resta una deduzione. "Wilder <= 20 ~ `iADX` <= 25": sostenuto **in frequenza** sull'oro H1
  (40/36/36 contro 38/38/38) e H4, non barra per barra. 👉 Aggiunta la riga **`VERIFICA ADX`** (prima barra con dati): ADX del
  terminale contro i due ricalcoli dalle stesse barre (`NC_AdxUltimo`, blocco puro) e il verdetto scritto. Collaudo: ricalcolo ==
  specchi a 0 di scarto su 13 finestre da 1500 barre; le due formule differiscono di > 0,05 in 13/13 (la riga **decide**).
  La riga d'avvio stampa ora anche `ADX acceso/spento, iADX MetaQuotes/iADXWilder, max, periodo`.
- **Percorsi di denaro riletti**: perdita per lotto con `OrderCalcProfit` su 1 lotto e distanza intera (vale per forex con
  quotazione inversa, oro, indici: converte il broker; spread e commissione NON inclusi, come la casa); lotto per difetto,
  sotto il minimo = scartato, tetto al massimo; stop sempre presente e dal lato giusto; STOPS/FREEZE nel controllo dei
  pendenti; un LIMIT gia' superato dal prezzo **si scarta** (il server lo rifiuterebbe come prezzo non valido: non diventa
  mercato); magic 7786xx **libero su tutti i rami** (`git grep` su ogni ref). Nessun controllo del margine: un ordine senza
  margine viene rifiutato dal server (niente danno, un setup perso).
- **Difetto di SOSTANZA trovato e corretto (classe 1164)**: se una cancellazione falliva, lo stato del setup veniva azzerato lo
  stesso e il pendente restava vivo **per sempre**, al prezzo vecchio, **fuori dal semaforo** e senza scadenza (la guardia
  anti-duplicato lo vedeva ma non lo cancellava mai). Ora `Sincronizza` lo ricancella a ogni passaggio. Correlati: la scala
  armata si cancella anche su una barra senza dati; il parziale al TP1 parte solo se il residuo resta >= minimo.
- **Buco del collaudo trovato**: "rischio x10" passato DAL CHIAMANTE (`RischioSoldi`) restava **VERDE** (D7 mordeva solo dentro
  la funzione pura): ricorrenza della classe 1068. Invarianti 15-24 aggiunte; i **6 residui VERDI** del par. 5 ora sono presi.
  Mutanti: **59/59 presi** (43 + 6 sui soldi + 6 residui + 4 sulle righe nuove), tutti su copie fuori dal repo.
- **Buco B6**: confermato alla fonte (`ABTG_Guardian.mq5` r.385-413 somma solo posizioni). L'attenuante "la scala si ripiazza a
  ogni barra" e' **vera per la scala non riempita** (max 1 barra) ma **falsa per i pendenti residui di un setup gia' riempito**
  (restano fino a X10/TP1/flip/fine setup, mai ripassati dal Guardian) e per i setup adottati dopo un riavvio. Il tetto R per
  setup tiene comunque per costruzione.

**Riserve aggiunte** (oltre a quelle del par. 5, che restano):
1. **Semaforo**: coerente con la LETTERA della specifica (2.2: cancella al riempimento), non con la frase "un setup alla volta":
   il caso peggiore e' **linee attive x R** (AUDIO 3 x 0,25% = 0,75%), solo su salti di prezzo. Decisione di rischio = Claudio.
2. **Riprezzamento**: la specifica dice `OrderModify`, il codice cancella e riarma (giustificato: il lotto dipende dalla distanza
   dallo stop). In campo, se la lista ordini del terminale si aggiorna in ritardo, la guardia anti-duplicato puo' far saltare un
   riarmo (lo scrive a log): da guardare nel primo giro demo.
3. GTC dato per accettato dal simbolo (non si legge `SYMBOL_EXPIRATION_GTC`): se un simbolo lo rifiuta, `INVIO FALLITO` a log.

**Checklist per il primo giro nel tester (leggibile nel log, una riga per punto):** (1) `AVVIO v1.02` con `1 u` giusta per il
simbolo (oro 1,00; forex 1 pip) e `ADX ... iADX MetaQuotes`; (2) `VERIFICA ADX ... coincide con: formula MetaQuotes` (se dice
NESSUNA, fermarsi); (3) almeno un `RIEMPITO` seguito da `cancellati N pendenti (X10...)` o `(semaforo...)`; (4) nessun
`SEMAFORO SFORATO` oltre i salti del lunedi'; (5) in PDF, `ORDINE ... LIMIT` con scadenza e poi `E6 scadenza pendenti` o
`SCADUTO_SENZA_RIEMPIMENTO`; (6) togliere e rimettere l'EA a posizione aperta: `AVVIO: ADOTTATO setup ...`.

**NON COPERTO**: compilazione (nessun MetaEditor), tester, ordine degli eventi reali, `OrderCalcProfit`/`iADX` del terminale, il
Guardian vivo, i preset sui terminali (fuori dal repo).

## 7. Terza lettura indipendente (`controllo-preventivo`, 07/10/2026): PASS CON RISERVE, v1.02 — NON serve un quarto lettore

Per decisione di Claudio (07/10) l'EA segue **solo gli audio**: questa lettura ha guardato i modi **AUDIO** e **EMA200**; il modo
PDF non e' stato riletto ne' toccato (lo toglie un passaggio separato).

**Controllato, e com'e' andata** (anche i passati):
- **Delta v1.00 -> v1.01 riletto riga per riga.** La cancellazione dei pendenti orfani tocca SOLO ordini con **stesso simbolo, stesso
  magic e etichetta di linea** `NATCLA_..._O<n>`: un ordine a mano di Claudio (magic 0) o di un'altra istanza (magic diverso: il
  magic automatico cambia con modo e TF) **non si tocca**. Non puo' colpire una scala viva: `ArmaScala` segna il setup attivo
  **prima** di inviare, e gli eventi di MT5 non si accavallano. Unico caso scoperto: due istanze con **lo stesso magic sullo stesso
  simbolo** (solo con `InpMagic` messo a mano uguale): si cancellerebbero i pendenti a vicenda. Regola: **un magic = una istanza**.
- 🔧 **Corretto (forma, classe 1165)**: il ritentativo partiva **a ogni tick** (fino a 3 `OrderDelete` per linea per tick, e una
  riga d'errore per ognuno se il rifiuto e' permanente: freeze level, AutoTrading spento). Ora **uno ogni 10 secondi per linea**,
  il primo subito. Caso peggiore dei riarmi normali: AUDIO 3 linee x (3 cancellazioni + 3 invii) = **18 richieste per barra**,
  su H1 al massimo ~430 al giorno se tutte e tre le linee restano armate tutto il giorno.
- **Scadenza logica dei pendenti** (AUDIO/EMA200, scala GTC): a ogni barra chiusa la scala non riempita viene cancellata e
  ripiazzata, anche su linea n/d, flip e (nuovo) barra senza dati; dopo un riavvio i pendenti senza posizione si cancellano e
  si riarmano dai dati. Restano vivi oltre la barra solo i **residui di un setup gia' riempito** (fino a X10/TP1/flip/durata/fine
  setup) e quelli di un setup adottato dopo un riavvio: e' il buco B6, scritto sotto.
- **Parziale al TP1**, fatto a mano: EURUSD e oro (minimo 0,01, passo 0,01): 0,07 lotti al 50% -> chiude 0,03, restano 0,04;
  0,01 -> nessun parziale (sotto il minimo). Indice con minimo 0,5 e passo 0,1, al 60%: 1,0 -> 0,6 lascerebbe 0,4 < 0,5 ->
  **nessun parziale** (prima della v1.01 il server l'avrebbe rifiutato: nessun danno, ma un errore). Sempre per difetto al passo;
  il verso lo mette `PositionClosePartial` sul ticket (un BUY si chiude con un SELL dello stesso volume).
- **VERIFICA ADX**: stampa e basta (invariante 27: non assegna stato, non ritorna, non ferma l'EA). Ricostruite **da me, con una
  quarta mano**, tutte e due le formule sull'oro H1 HistData (2021-01 -> 2026-09, 33.033 barre): coincidono con gli specchi del
  collaudo a 1e-13. Restano formule **ricordate**, non lette dal terminale: decide la riga `VERIFICA ADX` al primo giro.
  Il PDF **non contiene nessun ADX** (p22 riguardata: `PeakRepairerStrict` e `ATR(14)`): motivazione riscritta (par. 2 e
  specifica §5.4), **default `iADX` invariato**, dichiarato **assunzione**.
- **Percorsi di denaro**: Guardian (`ABTG_GuardiaIngresso`) chiamato **prima di ogni invio**, pendenti compresi (`InviaLimit` r.~1630);
  mai un ordine senza stop; lotto per difetto con somma dei rischi <= R; stops/freeze level controllati sui pendenti; un LIMIT gia'
  superato si scarta; semaforo come al par. 6.
- **Collaudo**: 3 mutanti miei erano **VERDI** (filtro magic tolto, filtro simbolo tolto, parziale sotto il minimo): aggiunte le
  invarianti 22b/25/26/27. Rilanciato: **TUTTO OK, mutanti 66/66** (59 + 7 della terza lettura), tutti su copie in `/tmp`.

**Le riserve per Claudio, in parole semplici** (nessuna e' nuova; qui sono tutte insieme):
1. **Semaforo sforabile**: con 3 linee armate in AUDIO, un salto di prezzo puo' riempirle insieme: **fino a 0,75%** invece di 0,25%.
   E' una scelta di rischio: **tua**.
2. **Buco B6**: i pendenti rimasti di un setup gia' entrato (e quelli ripresi dopo un riavvio) **non ripassano dal Guardian** e
   restano al prezzo vecchio finche' il setup non finisce. Il tetto per setup tiene comunque.
3. **Limit GTC se togli l'EA**: i pendenti restano sul conto (con il loro stop). Per spegnerlo davvero: togliere l'EA **e**
   cancellare a mano gli ordini `NATCLA_`.
4. **Riarmo = cancella e ripiazza** (non `OrderModify`): fino a 18 richieste per barra in AUDIO.
5. **Nessun controllo del margine**: un ordine senza margine lo rifiuta il broker (un setup perso, nessun danno).
6. **`SYMBOL_EXPIRATION_GTC` non letto**: se un simbolo non accetta GTC, `INVIO FALLITO` a log e niente ordini.
7. **Un magic = una istanza** sullo stesso simbolo.
8. **ADX: e' un'assunzione** (MT5 contro TradingView): va chiesto alla collega.

**Perche' non serve un quarto lettore**: l'unica correzione al codice di questa lettura e' la **cadenza** di un ritentativo di
cancellazione (non apre, non dimensiona, non sposta stop): nessun percorso che crea rischio e' cambiato. Le altre modifiche sono
commenti, documenti e collaudo. Rischio residuo limitato a **demo/tester** (solo DEMO finche' Claudio non firma).

**NON COPERTO**: compilazione (nessun MetaEditor qui), tester, ordine reale degli eventi, `iADX`/`iADXWilder` del terminale (li
decide la riga `VERIFICA ADX`), il comportamento reale del freeze level BCM, il Guardian vivo, il modo PDF (fuori perimetro).
