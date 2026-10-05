# Le schede simbolo: e' fattibile? Piano, specifica e prototipo (05/10/2026)

Richiesta di Claudio (05/10): *"analizzare ogni simbolo che usiamo, conoscerlo a memoria: come si muove, come ritraccia, quanti punti fa di media al giorno, i piu' volatili e i meno. E' una cosa fattibile?"*
Autore: sviluppatore (sessione 05/10, FASE 1). Perimetro: **fattibilita' + specifica + prototipo su dati realmente presenti.** Nessun round, nessun terminale MT5, nessun VPS, nessuna riga consegnata a Claudio, nessun EA/preset/taglia toccato. L'idea dell'"ordine edge di riparazione" resta backlog separato e non e' toccata.
Etichette: **[MISURATO]** letto o calcolato qui da un file · **[DERIVATO]** conto su numeri misurati · **[INFERITO]** ragionamento · **[NON MISURATO]** buco dichiarato.
Stato del cancello: questo file e il prototipo **non sono ancora passati dal secondo strato (`controllo-preventivo`)**: finche' non c'e' un PASS non escono da qui (vedi sezione 8).

---

## 0. La risposta, in sei righe

1. **Si', e' fattibile, e con numeri che si rifanno identici.** TradingView non e' raggiungibile da noi e non e' riproducibile; le stesse statistiche (ADR, ATR per TF, range per sessione/ora/giorno, gap, ritracciamento, trend/laterale, comportamento alla EMA200, costo in ATR, correlazioni) escono dalle **nostre barre M1**, con fonte, fuso e profondita' dichiarati.
2. **Il prototipo esiste e funziona**: `backtest_pipeline/scheda_simbolo.py` (solo numpy, ASCII, autotest da **71 controlli**, provato con **19 mutanti, 19 uccisi**). Provato su **12 serie M1 reali** (**10,1 milioni di barre**: 2,0 M dal repo + 8,1 M da feed esterni raggiunti dal cloud), in **6 secondi per 2 milioni di barre** e **471 MB** di RAM [MISURATO].
3. **Controllo indipendente passato su due fronti**: il suo ATR(14) mediano di M5/M15/H1 coincide a **meno di 0,01%** con quello scritto dai referti EMA200_D1 del 01/10 su **3 feed e 9 valori**; l'ADR mediano di **8 mesi di oro** ricalcolato in python puro (senza numpy) coincide **al millesimo, mese per mese**.
4. **Il limite vero non e' il codice, e' il dato.** Dentro il repo c'e' **una sola serie M1 profonda** (oro HistData 2021-2026). Tutto il resto dei dati BCM sta sul **PC di backtest** e per i forex BCM serve **uno script nuovo che esporti le M1 dal terminale** (non esiste: backlog F2, con cancello). Il **Dow** non ha storia profonda da nessuna parte (2024-09-26 in poi).
5. **Che cosa NON e'**: non e' un test di edge. Ogni misura con un'attesa "a caso" porta accanto il **random walk passato dalla stessa procedura**; il comportamento alla EMA200 e' descrittivo.
6. **Costo di esecuzione sul PC di backtest**: circa **12-15 minuti di calcolo per tutti e 36 i simboli** [DERIVATO da 3,7 s per milione di barre; la velocita' del PC e' **[NON MISURATO]**], piu' il tempo di export dal terminale **[NON MISURATO]** (un canarino lo misura in pochi minuti).

---

## 1. Che cosa abbiamo gia' in casa (e che cosa questa scheda NON rifa')

Prima di scrivere un byte ho cercato. Parti del lavoro **esistono gia'**, ognuna su un perimetro stretto. La scheda e' il **ponte per simbolo, su tutta la giornata, confrontabile fra simboli**.

| gia' fatto | dove | perimetro | come lo usa la scheda |
|---|---|---|---|
| ATR/ADR della flotta indici, legge radice-di-T validata | `report/ANCORA_ADR_FLOTTA_INDICI_2026-09-18.md`, `report/ATR_DAX_M30_RICONCILIAZIONE_2026-09-17.md` | DAX H4 (+0,3%), Dow H1 (-0,7%); finestra attiva DAX 780 min, indici USA ~1380 | stessa legge nel rapporto ATR(H4)/ATR(H1) della scheda; **la finestra attiva del simbolo**, non 1440, e' il denominatore giusto |
| ADR in 8 definizioni (media, mediana, True Range, senza domeniche, Wilder, sul TF del grafico...) | `mql5/Scripts/ABTG_SondaADR.mq5` | forex, per il corso Point Break | la scheda usa la definizione V1-V4 (H-L, giorni pieni, media **e** mediana); non sostituisce l'ADR(50) del corso |
| volatilita' oraria in % | `backtest_pipeline/dukascopy/histdata_m1.py --vol-oraria`; `LETTURA_MISURE_LAMPO_2026-08-26.md` | NASUSD 0,3324%/h, SPXUSD 0,2602%, 225JPY 0,3747%, EURUSD 0,1232% (2025) | la scheda dara' la tabella oraria **per ora server** per ogni simbolo, in punti e in % |
| anatomia delle aperture e dei movimenti M5 dopo la rottura | `anatomia_aperture.py`, `anatomia_movimenti_m5.py` (29/09) | Nasdaq e DAX, solo il **range d'apertura** | la scheda guarda il **ritracciamento generale** (zigzag in ATR); non rifa' il retest dell'apertura |
| esplosioni dell'oro | `anatomia_esplosioni_oro.py`, `sonda_oro_*` | oro | complementare: la scheda da' il fondo (ADR/ATR), non le esplosioni |
| EMA200 col nullo a blocchi | `ema200_rimbalzo.py`, `ema200_d1_su_m5.py` | DAX, SPX, oro, forex | la scheda **non** rifa' il test: conta tocchi e distanze e stampa il RW accanto; l'edge resta li' |
| spread vivo e pedaggio | `data/spread_vivo/` (8 simboli, 04-11/09), `CANCELLO_COSTO_FLOTTA_2026-09-10.md` | 225JPY, D30EUR, EURUSD, GBPUSD, NASUSD, U30USD, USDJPY, XAUUSD | la scheda legge lo stesso file e calcola **ATR/spread** per TF |
| cluster proposti | `report/CLUSTER_PROPOSTA.md` (07/09, **non firmata**) | mappa nominale | **non e' mai stata misurata**: la scheda produce la prima matrice di correlazione vera |

Un segnale d'attenzione trovato cercando: i **file `data/snapshots/*.json`** (45 giorni, ticker Yahoo, con `prev_day_high/low`) **non servono per l'ADR**. Confrontati con l'oro HistData sugli stessi giorni, **nessun allineamento li riproduce** (mediana del range 44,3 contro 92,0; correlazione fra -0,16 e +0,11 su 4 sfasamenti) [MISURATO]. Causa **[NON INDAGATA]**. Non li ho usati.

---

## 2. L'inventario dei dati: che cosa abbiamo DAVVERO e DOVE

**Lista dei simboli (36)**: i 30 del dashboard `mql5/Indicators/ABTG_EMA200_Dashboard.mq5` (22 forex `InpSymForex`, 6 indici `D30EUR,U30USD,NASUSD,SPXUSD,200AUD,225JPY`, 2 metalli `XAUUSD,XAGUSD`) + **6 extra** usati dalla flotta o dagli screening: `F40EUR` (CAC), `E50EUR`, `E35EUR`, `100GBP`, `EURJPY`, `EURCHF`.
Fuso dei dati BCM (per le schede): **UTC+1 fisso dal cambio di inizio 2025** (indici: su tutto l'arco dal 2024-09-26); **vecchio orologio** (UTC+0 inverno / +1 estate) per il forex fino a dic 2024. Il cambio sul forex e' **dopo il 26/12/2024 23:03 ed entro il 02/02/2025 23:05**, giorno esatto **[NON MISURATO]** (`report/OROLOGIO_BCM_2026-09-24.md`). Il prototipo ha il fuso `BCM_MISTO` che **scarta e conta** le righe nella finestra dubbia.

### 2.1 Che cosa sta fisicamente nel repo (verificato da me oggi)

| file | contenuto | periodo | righe | note |
|---|---|---|---:|---|
| `backtest_pipeline/risultati_prove/oro_m1_histdata_zip/` (14 zip, tracciati in git) | XAUUSD M1 HistData, ora **New York con DST USA** | 2021-01-03 18:00 -> 2026-09-18 16:58 (ora del file) | **1.981.357** (1.980.301 dopo la pulizia: **1.056 doppi** gia' nei file, 383 fuori ordine nel file) | **la sola serie profonda nel repo**. Anno 2023: **M1 per giorno 1.319** contro 1.380 degli altri anni e **308.812 righe contro ~354.000** (-13%): buchi di HistData, ATR 2023 leggermente per difetto |
| `risultati_archivio/r91_csv/U30USD_M1_prova_*.csv` | Dow M1 Dukascopy, 2 prove | 2025-06-15 20:00 -> 06-16 19:59 e 2015-06-15 02:00-16:00 | **1.335 + 781** | troppo corte per una scheda; fuso nel file **[NON DICHIARATO]** |
| `data/spread_vivo/SPREAD_VIVO_2026-09-12_*.csv` | spread orario | 04-11/09/2026 | 24 ore x 8 simboli, **5 giornate** | ore con GG < 5 sottili |
| `data/snapshots/*.json` | chiusure/livelli Yahoo | 45 file da 22/07 al 05/10 | - | **non affidabili per il range** (sopra) |
| `report/*`, `risultati_archivio/*` | per-trade, referti, profondita' storiche | - | - | **nessuna barra** |

**Nel repo non c'e' nessuna barra M1 BCM.** [MISURATO: ricerca di `*.csv/*.zip/*.npz` con M1/M5/barre, oltre le prove sopra]

### 2.2 Che cosa sta sul PC di backtest (`DESKTOP-H4D7CAJ`) e sul VPS (dai referti, **non toccati da me**)

| cosa | dove | profondita' | risoluzione | fuso | fonte del dato |
|---|---|---|---|---|---|
| **Forex BCM nativo** (22 cross) | terminale PC, disco | **21 coppie COPRONO dal 2010.01.01**; **GBPNZD parte 2010.05.10** (muro, 2 passate concordi); EURUSD e USDJPY dal **1971.01.03**; 22 esiti conclusivi su 22 | M1 (6,2 M barre a coppia) | server BCM (vecchio -> UTC+1 fisso) | `MISURA_STORICO_CROSS22_2026-09-29/REFERTO_...txt`; **esportazione in CSV: non esiste** |
| `EURJPY`, `EURCHF` BCM | terminale | **[NON MISURATO]** (non erano fra i 22 della sonda) | - | - | - |
| **`_EXT` HistData forex+oro** (8 simboli) | terminale PC | 2018.01.01 -> 2024.12.31 | M1 | NY+DST, calibrato +5 su 8/8 | `LO_STORICO_ESTERNO_MAPPA` 1.1 |
| **XAUUSD BCM nativo** | terminale | **dal 2004.06.11** (22,1 anni) | H1 misurato (sonda 17/08); M1 **[NON MISURATO]** | server | `REFERTO_SONDA_STORICO_17-08.md` |
| **XAGUSD BCM** | terminale | dal 2008.11.07 (17,6 anni) | H1 | server | idem |
| **Indici BCM** (`D30EUR,U30USD,NASUSD,SPXUSD,200AUD,225JPY,F40EUR,E50EUR,E35EUR,100GBP`) | terminale | **2024.09.26** (`COMPLETO`: il broker non ha di piu') | M1: NASUSD 648.972, D30EUR 623.824 (18/08); gli altri **[NON MISURATO]** qui | **UTC+1 fisso** | `passo0_tick_indici_2026-08-18.csv` |
| tick BCM | terminale | forex dal **2024.07.05**; indici dal 2024.09.26 | tick | server | `NOTA_PAVIMENTO_TICK_FOREX_2026-09-01.md` |
| **NASUSD** M1 HistData | PC `C:\Users\Master\abtg_storico_indici\NASUSD_M1.csv` ("Formato 1") | **2010.11.14 18:01 -> 2026.07.31** (~5,35 M barre); piu' `histdata_m1\NASUSD_M1.csv` dal 2019.01.01 | M1 | **NY** | `ANATOMIA_APERTURE_20260826/CENSIMENTO_FONTE.txt` |
| `NASUSD_EXT` / `SPXUSD_EXT` / `225JPY_EXT` | terminale | 5,23 M / 4,60 M / 2,36 M barre; 2010-11 (Nas/SPX), 2019-01 (Nikkei) -> 2026-07-31 | M1 | calibrato +5 | `LO_STORICO_ESTERNO_MAPPA` 1.2: **NAS ammesso alla prova di regime; SPX e Nikkei in frigo** (rapporto 0,203 e 0,232 contro 0,20) |
| **D30EUR** HistData | **VPS** `C:\Users\Administrator\abtg_storico_indici\D30EUR_M1.csv` | **2010.11.15 -> 2018.12.28**, 1.718.805 barre, **0 fuori banda su 9 anni** | M1 | NY | `STORICO_INDICI_SCARICATO_2026-09-10.md`; **ZERO giorni in comune col nativo: non importato**. Gli anni 2020-2023 dello stesso feed sono **un altro indice** |
| **Dow** | - | nessuna storia esterna: HistData **non ha il Dow**; Dukascopy `USA30IDXUSD` dal 2012 **mai scaricato in profondita'** | - | - | `PIANO_REGIME_DOW_DUKASCOPY_2026-10-05.md` (nucleo 1.306 giorni = **90-348 ore di PC**, in attesa di firma F1/F2); la cache Dukascopy contiene solo **222 giorni** (2024-10-01 -> 2025-06-17), **dentro** lo storico nativo |
| Oanda XAUUSD | cache cloud `/tmp/sonda_st_cache` (effimera) | 2006-03-19 -> 2020-05-14, 4.884.366 barre | M1 | UTC | `LO_STORICO_ESTERNO_MAPPA` 1.4 |

### 2.3 Che cosa raggiunge il container (mirror GitHub `FutureSharks/financial-data`, solo per provare lo strumento)

`histdata.com` e `dukascopy.com` sono bloccati dal cloud (403), `raw.githubusercontent.com` no. Sondato io oggi, mese di marzo di 2010 e 2018 (per EURUSD, NAS100, SPX500, JP225 anche marzo di ogni anno 2005-2020):

| feed | simboli presenti (risposta 206) | simboli assenti (404) |
|---|---|---|
| **HistData** (`stocks/histdata/`) | `GRXEUR` (DAX), `SPXUSD`, `JPXJPY` (Nikkei) 2010-2018 | `NSXUSD`, `UDXUSD` |
| **Oanda** (`currencies/oanda/`) | `EUR_USD`, `GBP_USD`, `AUD_USD`, `USD_CAD`, `AUD_JPY`, `EUR_JPY`, `XAU_USD`, `NAS100_USD`, `SPX500_USD`, `JP225_USD`, `AU200_AUD`, `UK100_GBP`, `FR40_EUR`, `WTICO_USD` (marzo 2010 e marzo 2018 per tutti; **marzo di ogni anno 2005-2020 solo per `EUR_USD`, `NAS100_USD`, `SPX500_USD`, `JP225_USD`**; l'oro dal 2006-03 e' nella cache del 22/09; gli altri anni **[NON MISURATO]**) | `USD_JPY`, `GBP_JPY`, `USD_CHF`, `NZD_USD`, **tutti gli altri cross**, `XAG_USD`, `DE30_EUR`, **`US30_USD` (il Dow)**, `EU50_EUR` |

**Sono feed di altri broker**: servono a provare lo strumento e a controllare la coerenza fra feed gemelli, **non** a conoscere BCM (lezione R80: stessa cella, stessa finestra, solo il feed cambia -> quattro cambi di segno).

### 2.4 La tabella per simbolo: dove si calcola

| simboli | nel repo | container (feed esterno, per la prova) | PC di backtest (BCM) | cosa manca |
|---|---|---|---|---|
| **XAUUSD** | **si**, 2021-2026 HistData | si (anche Oanda 2006-2020 se si riscarica) | nativo dal 2004; `_EXT` 2018-2024 | M1 nativo in CSV |
| **D30EUR** (DAX) | no | si: HistData 2010-2018 (mirror) | nativo 2024-09-26+; CSV HistData sul **VPS** | CSV sul PC, oppure rilettura dal mirror |
| **NASUSD** | no | si: Oanda NAS100 2005-2020 | CSV 2010-2026 (NY) + nativo 2024-09-26+ | - (dati gia' sul PC) |
| **SPXUSD** | no | si: HistData 2010-2018, Oanda SPX500 | `SPXUSD_EXT` (terminale), nativo 2024-09-26+ | CSV da export |
| **225JPY** | no | si: HistData 2013-2018, Oanda JP225 | `225JPY_EXT` 2019+, nativo 2024-09-26+ | CSV da export |
| **U30USD** (Dow) | solo 2 prove | **no** (nessun feed) | nativo 2024-09-26+ (circa **2 anni**, un solo regime) | profondita': solo con il piano Dukascopy (firma) |
| **EURUSD, GBPUSD, AUDUSD, USDCAD, AUDJPY, EURJPY** | no | si: Oanda 2005-2020 | nativo dal 2010 (EURUSD dal 1971) | export CSV |
| **USDJPY, NZDUSD, USDCHF, GBPJPY, EURGBP, EURNZD, GBPAUD, GBPCAD, GBPNZD, AUDCAD, AUDNZD, NZDJPY, NZDCAD, NZDCHF, CADJPY, CADCHF, CHFJPY, EURCHF** | no | **no** | nativo dal 2010 | export CSV (GBPNZD parte da 2010.05.10) |
| **XAGUSD** | no | no | nativo dal 2008-11 (H1) | export CSV |
| **200AUD, F40EUR, 100GBP** | no | si: Oanda (marzo 2010 e 2018 sondati) | nativo 2024-09-26+ | export CSV |
| **E50EUR, E35EUR** | no | no | nativo 2024-09-26+ | export CSV |

### 2.5 Che cosa si calcola qui nel container e che cosa solo sul PC

- **Qui, oggi [MISURATO]**: oro (repo), DAX/SPX/Nikkei HistData, e 8 serie Oanda, tutte come **prova** dello strumento e per cross-check fra feed.
- **Solo sul PC**: tutto cio' che e' BCM nativo, il CSV Nasdaq 2010-2026, i `_EXT`, il Dow, e **qualunque calcolo pesante vero** (regola 21/09: i round e i calcoli sul PC, mai sul VPS).
- **Mai sul VPS**: il VPS ospita le sedie FTMO; questo lavoro non lo sfiora.

---

## 3. La SPECIFICA della scheda: misura per misura

Convenzioni valide per tutte (nel codice, con il nome):
- **Barre**: M1 -> M15/H1/H4 costruite **sull'orologio server UTC+1 fisso**, mai a cavallo di due giorni; **giorno** = giorno server (mezzanotte server); sabato/domenica attribuiti al lunedi' (convenzione di casa). Alternativa `--giorno nyclose` (17:00 New York, stesse formule di `ema200_d1_su_m5.py`) per la sensibilita'.
- **Giorno pieno**: M1 del giorno >= 50% della mediana dei giorni (esclude mezze giornate e primo/ultimo giorno parziale). Parametro dichiarato `FRAZ_GIORNO_PIENO`.
- **Unita'**: **pip** (0,0001; 0,01 se c'e' JPY) per il forex; **punti di prezzo** (1,0) per indici e metalli (come `PipSize` del dashboard).
- **ATR(14)**: media semplice del true range su 14 barre, **come `iATR` di MT5** (non Wilder).
- **Ogni misura riporta**: n, periodo, e per le serie profonde **per anno** e **ultimi 252 giorni** (il regime di oggi).

| # | misura | formula esatta e finestra | che cosa dice del simbolo | decisione che informa | nel prototipo |
|---|---|---|---|---|---|
| 1 | **ADR / range giornaliero** | `H-L` del giorno server, giorni pieni; in punti/pip **e** in % `100*(H-L)/open`; mediana, media, p10/p25/p75/p90/p95; **per anno** e ultimi 252 gg; quota di giorni > 1,5x e > 2x la mediana | quanta strada fa in un giorno tipico, e quanta coda grassa | stop in ADR; un TP ragionevole dentro il giorno; lettura di una giornata anomala | si |
| 2 | **ATR per TF** | ATR(14) di M15, H1, H4, D1: mediana, media, % del prezzo, per anno, ultimi 252 gg; rapporti ATR(H1)/ATR(M15), ATR(H4)/ATR(H1) (atteso 2 se radice-di-T) e ADR/ATR(H1) | la scala di ogni TF e se il simbolo accumula tendenza (rapporto > 2) o compensa rumore (< 2) | stop in ATR su quel TF; scelta del TF | si |
| 3 | **distribuzione dell'estensione giornaliera** | quantili del punto 1; frazione di giorni sotto 0,5x / sopra 1,5x / sopra 2x la mediana | quanto e' regolare il simbolo | taglia/stop nei giorni "da coda"; filtro volatilita' | si |
| 4 | **range per sessione** | finestre **orari reali di borsa** convertiti in UTC con il loro DST: **Asia** = Tokyo 09:00-15:00 JST (00:00-06:00 UTC, niente DST); **Londra** = 08:00-16:30 locale (inverno 08:00-16:30 UTC, estate 07:00-15:30); **NY** = 09:30-16:00 locale (inverno 14:30-21:00 UTC, estate 13:30-20:00). Range = max(H)-min(L) nella finestra, giorni feriali con >= 50% dei minuti; mediana, media, p90, % del prezzo, **quota dell'ADR mediano**. La scheda stampa le finestre in **ora server UTC+1** d'inverno e d'estate | in quale sessione il simbolo fa il suo movimento | fascia oraria di un EA; spazio del TP dentro la fascia | si |
| 5 | **range per ora server e per giorno della settimana** | H-L dentro ogni ora server (UTC+1 fisso), solo feriali con >= 30 M1 nell'ora; mediana; **inverno (dic-feb) e estate (giu-ago) separati** perche' gli eventi USA/Europa si spostano di 1 ora; quota % del totale. Per giorno: media del range / media dei 5 giorni | dove sta il movimento nella giornata e nella settimana | finestra oraria, giorni da pesare o evitare | si |
| 6 | **gap di apertura** | primo open dopo un buco di quotazioni >= 60 min meno l'ultima chiusura. Classe `pausa` (< 36 h) e `weekend` (>= 36 h). Mediana, media, p95 in punti e in **ATR D1**; % con gap > 0,25 ATR D1; % gap su; **% riempito** nel segmento seguente (anche solo per i gap > 0,25 ATR) | quanto salta e se il salto si ritira | gap-fade o gap-continuation (le sedie GapFill/GapContinuation); distanza minima dello stop dall'overnight | si |
| 7 | **volatilita' relativa e ranking** | per simbolo: ADR% mediano, ADR% medio, volatilita' realizzata annua `100*std(ln c_t/c_(t-1))*sqrt(252)`, ATR(H1)% , ER D1. **Ranking solo su una finestra comune** (intersezione delle serie, o `--finestra`); se l'intersezione e' < 60 giorni **il ranking resta vuoto** e marcato `finestra_comune=NO` | i piu' e i meno volatili, normalizzati | taglia relativa fra simboli; quali tenere insieme | si |
| 8 | **ritracciamento dopo un impulso** | zigzag a inversione `0,5 ATR(14)` del TF (default **H1**, anche M15/H4 con `--tf-ritr`). **Impulso k** = gamba fra due pivot >= k ATR (k = 2, 3, 4). **Ritracciamento** = gamba successiva / impulso. Tocco di un livello 23,6 / 38,2 / 50 / 61,8 / 78,6 = frazione di impulsi con ritracciamento >= livello; profondita' media, mediana, p25-p75; **inversione** (>= 100%); **tempo mediano in barre**. I livelli <= `0,5/k` sono **troncati per costruzione** e mostrati `n.d.`. Una barra che fa un nuovo estremo non conferma anche l'inversione. **Nullo: un RW gaussiano a 40.000 barre, seme fisso, passato dalla stessa funzione** | quanto un movimento forte viene riassorbito e dopo quanto | dove piazzare un ingresso su ritracciamento; quanto aspettare; se lo stop va oltre il 78,6% | si |
| 9 | **trend contro laterale** | **Efficiency Ratio** `ER(N)=|c_t-c_(t-N)|/somma|dc|`, N = 24 (H1), 20 (H4), 20 (D1). Trend se ER >= 0,30, laterale se <= 0,15 (**soglie mie, scritte prima dei numeri**). Nullo: ER medio di un RW ~ `1/sqrt(N)` (verificato dall'autotest entro il 15%) e ER mediano simulato | direzionale o di ritorno | motore a trend o a ritorno; quanto filtro-trend | si |
| 10 | **comportamento alla EMA200 (DESCRITTIVO)** | EMA200 delle chiusure del TF (H1, H4, D1): % di tempo sopra; mediana della serie sullo stesso lato; distanza `|c-EMA|/ATR` (p50/p90/p95) e % entro 1 ATR; **tocchi per 100 barre** (`low<=EMA<=high`); incroci per 100 barre; **tocco da lontano** = tocco con le 20 barre precedenti tutte dallo stesso lato e almeno una a >= 1 ATR; esito entro 20 barre: **rimbalzo** (ritorna a >= 1 ATR dal lato di origine senza chiudere a >= 0,5 ATR oltre) / **rottura** / ambiguo; un evento ogni 20 barre; **quota di rimbalzo B/(B+P)** con il RW accanto. **Non e' un test di edge** (regola di casa): il test col nullo a blocchi resta `ema200_rimbalzo.py` | quanto "tiene" la linea e quanto il prezzo ci vive attorno | cella O1/O2 del dashboard (distanza-soglia in ATR); se ha senso un limit alla linea | si |
| 11 | **spread per ora e costo in ATR** | da file `SPREAD_VIVO_*_orario.csv`: mediana e p95 per ora server; `ATR(TF, ultimi 252 gg) / spread mediano` e al p95; **stop minimo in ATR per 40 x spread**; esito **FUORI COSTO** se `ATR(TF) < 40 x spread`, **col numero accanto** | il pedaggio e dove costa di piu' | TF minimo schierabile; ore da evitare per ordini a mercato | si (8 simboli con spread nel repo) |
| 12 | **correlazione e cluster** | rendimenti **giornalieri** (log, chiusure dei giorni pieni) e **orari** (H1 consecutive, chiave = ora UTC) sull'**intersezione per chiave** (mai per posizione); minimo 60 giorni / 500 ore, **altrimenti NaN**; matrici `correlazioni_giornaliere.csv` e `correlazioni_orarie.csv` con n per cella; **cluster per collegamento medio** sulla correlazione assoluta (soglia 0,50), non a catena; etichette nominali di `CLUSTER_PROPOSTA.md` accanto, per confronto | quali simboli sono lo stesso trade | i tetti per cluster (C2), la scelta delle sedie scorrelate | si |
| 13 | **gap di qualita' del dato** (obbligatorio, viene PRIMA dei numeri) | n M1, periodo, righe scartate (parse, OHLC, doppi, fuori ordine, **fuori banda di prezzo dichiarata**, finestra dubbia dell'orologio), buchi interni 2-59 min, M1 mediane per giorno **per anno**, **cancello dell'orologio**: picco del minuto-del-giorno inverno/estate, ancora assoluta (07:00, 08:00, 13:30, 14:30, 15:00 UTC; Tokyo 00:00/06:00), **nettezza** del picco e **campione minimo** (40 giorni/stagione): verdetto `ok` / `DA GUARDARE` / `INDECISO` | se si puo' fidarsi del fuso e del feed | tutto il resto | si |

Misure **non** in questa versione (dichiarate): **gap di cash a tabella** (qui il gap e' definito dal buco di quotazioni, non da un orario di cash), **range per ora in % del prezzo** (c'e' in punti), **seconda soglia del ritracciamento** (`rho` diverso da 0,5 ATR) e **profilo del tick/spread storico per ora** (lo spread BCM storico non esiste: c'e' solo lo spread vivo di una settimana).

---

## 4. Il PROTOTIPO e i suoi numeri di prova

**File**: `backtest_pipeline/scheda_simbolo.py` (ASCII puro, solo numpy, nessuna rete, nessuna scrittura fuori da `--uscita`). SHA256 iniziale `0226c9dc...` (pin definitivo nel commit). **Uso**: `--autotest` | `--serie SIM:FEED:FUSO:PERCORSO` (ripetibile) | `--manifest m.csv` (colonne `simbolo,feed,fuso,percorso[,unita][,banda]`) | `--ispeziona PERCORSO` (inventario veloce, nessuna misura) | `--verifica-mese ...` (controllo indipendente) | `--finestra`, `--giorno`, `--orologio`, `--tf-ritr`, `--spread`.
**Contratto di input**: M1 con le colonne `time|date, open, high, low, close` (qualunque ordine, `,` o `;`, tempo `AAAA-MM-GG HH:MM[:SS]` o `AAAA.MM.GG HH:MM[:SS]`), oppure HistData senza intestazione `AAAAMMGG HHMMSS;O;H;L;C;V`; file, cartella o `.zip`. **Il fuso lo dichiara chi lancia, mai dedotto**: `UTC | NY | BCM_UTC1 | BCM_VECCHIO | BCM_MISTO`.
**Uscite**: `SCHEDA_<simbolo>_<feed>.md`, `ranking_volatilita.csv`, `correlazioni_giornaliere.csv`, `correlazioni_orarie.csv`, `cluster.txt`.

### 4.1 Quanto e' provato (tutti [MISURATO])

| controllo | esito |
|---|---|
| **autotest** | **71 controlli ok**: calendario DST (USA 2005/2015, EU 2015, bordi EST/EDT), i 3 formati di lettura, righe malformate **contate**, pulizia (OHLC, doppi, fuori ordine, fuori banda, finestra dubbia), ADR/giorno-della-settimana su dati con la **risposta nota**, sessioni d'inverno **e** d'estate, gap con formula, zigzag con rapporti 0,5/3,0/0,5333 e rumore sotto soglia, RW riproducibile, ER = 1 / 0 / ~1/sqrt(N), EMA contro un **oracolo in python puro** (69 rimbalzi, 78 rotture, 1 ambiguo, identici), correlazioni, cluster, costo |
| **potenza dell'autotest** (`SCHEDE_SIMBOLO_PROTOTIPO_2026-10-05/mutazioni_autotest.*`) | **19 mutanti, 19 uccisi**. **La prima stesura dell'autotest ne lasciava vivi 6** (ATR senza gap, zigzag senza soglia, finestra NY d'estate, ancora assoluta dell'orologio, percentili, quota di rimbalzo): ho aggiunto i test e rilanciato. Lo scrivo perche' un autotest che non ha mai fallito su un difetto vero non e' stato provato |
| **controlli con il contro-esempio** | fuso sbagliato (NY applicato a dati UTC) **non** supera il cancello dell'orologio; feed spostato di **un'ora** passa il test relativo (differenza 60) ma **non** l'ancora assoluta (lezione del 10/09); campione di soli gen-feb o rumore puro -> **INDECISO**; serie identiche **sfasate di 5 chiavi** non danno rho = 1; catena A-B 0,9 / B-C 0,55 / A-C 0,1 **non** diventa un cluster unico; serie di periodi diversi **non** vanno in classifica |
| **ATR contro numeri di un altro percorso di codice** | `ATR(14)` mediano dal giorno 600, M5/M15/H1, su **D30EUR, SPXUSD, XAUUSD**, contro `REFERTO_*_UTC1.txt` di `EMA200_D1_M5_2026-10-02`: **9 valori su 9 entro lo 0,006%** (D30EUR H1 35,4286 = 35,4286; SPX H1 3,4643 = 3,4643; oro H1 7,6206 = 7,6206). **Limite dichiarato**: la *formula* dell'ATR e' copiata dalla casa di proposito, quindi il controllo prova lettura/fuso/giorni/barre, **non** l'indipendenza della formula. Le M1 pulite sono identiche per DAX (1.718.805) e SPX (2.117.667); sull'oro 1.980.301 contro 1.979.587 dei referti: **714 barre di differenza non spiegate** [NON INDAGATO], ATR M5 2,0762 contro 2,0761 |
| **ADR ricalcolato a mano su un mese** | python puro, senza numpy, con la lettura riga per riga e la conversione DST riscritte (condividono solo la routine che apre file e zip e il calcolo della domenica di cambio ora): ADR mediano di **8 mesi** di oro (`2021-11, 2022-03, 2023-10, 2024-03, 2025-03, 2025-11, 2026-06, 2026-07`) **coincide mese per mese** con la procedura (es. 2024-03: 28,700; 2026-06: 103,035). La prima versione del controllo **differiva sul 2023-10** (n M1 1.560 contro 1.500): HistData **duplica un'ora** (19:00-19:59, ora del file, del 29/10/2023) e il controllo a mano non toglieva i doppi. Corretto il controllo (stessa regola "vale il primo"), non la procedura |
| **coerenza fra feed gemelli** | stesso indice, due feed, 2018: **ADR% mediano SPX 1,121 (HistData) contro 1,141 (Oanda)**, +1,8%; **Nikkei 1,466 contro 1,475**, +0,6%; correlazione dei rendimenti giornalieri **0,999** (SPX) e **0,982** (Nikkei) |
| **riproducibilita'** | stessa serie + stesso codice -> scheda **identica byte per byte** (confrontata); il solo elemento casuale, il RW di riferimento, ha seme fisso |
| **tempo e memoria** | **5,8 s e 471 MB** per 1,98 M barre (4 vCPU del container); 11 serie / 8,1 M barre in 30 secondi |

### 4.2 Che cosa dicono i numeri di prova (e che cosa NON dicono)

**Oro, HistData 2021-01 -> 2026-09** (la serie del repo, 1.474 giorni pieni) [MISURATO]:
- **ADR mediano 29,30 punti = 1,349% del prezzo** (media 45,30; p10 14,88; p90 97,06). **Per anno**: 21,05 (2021) · 22,97 · 20,56 · 30,27 · 51,35 · **105,98 (2026)**. **Ultimi 252 giorni: 97,78 punti (2,188%)**. L'oro di oggi muove **piu' di tre volte** quello del 2021-2023: un numero medio su tutta la storia **descrive male** il simbolo di oggi, ed e' il motivo per cui la scheda stampa sempre il blocco "ultimi 252 giorni".
- **ATR**: M15 2,69 · H1 5,57 · H4 10,77 · D1 29,07 (intera storia); **ultimi 252 gg: 8,97 / 19,02 / 38,13**. Rapporti 2,07 e 1,93 (attesi 2,00): **legge radice-di-T rispettata**.
- **Sessioni** (mediana del range): Asia 10,76 (37% dell'ADR), **Londra 22,51 (77%)**, **NY 18,20 (62%)**. **Ore**: il picco e' alle **14-15 server** (10,5 e 10,1 punti, 7,2% e 7,0% del totale), l'inverno 14:00 vale 9,57 e l'estate 11,08.
- **Gap**: `pausa` mediano 0,68 punti (0,023 ATR D1); **`weekend` mediano 1,31, p95 27,22 punti (0,94 ATR D1), 15,8% dei weekend supera 0,25 ATR**; riempito nell'88% dei weekend e nel **60%** di quelli > 0,25 ATR.
- **Ritracciamento H1, k = 3 ATR**: **tocco 38,2% = 65%, 50% = 47%, 61,8% = 34%, 78,6% = 21%**, inversione 12%, tempo mediano 2 barre. **Il random walk fa 60 / 40 / 27 / 15% e inversione 7%**: l'oro ritraccia **piu' a fondo** di un RW (mediana 0,479 contro 0,433).
- **Trend/laterale**: ER D1 mediano 0,203 contro 0,190 del RW; H1 0,198 contro 0,172: **appena piu' direzionale di un RW**, quasi indistinguibile.
- **EMA200 H1**: 57,7% del tempo sopra; distanza mediana **3,56 ATR**, entro 1 ATR solo il **16%**; 7,6 tocchi per 100 barre; rimbalzo B/(B+P) = **0,56** (183/141) contro 0,48 del RW. Intervallo di Wilson 95% su 324 eventi ~ **0,51-0,62**, eventi non indipendenti: **indicativo, non un test**.
- **Costo** (spread mediano 0,21 punti, 12/09): ATR(M15)/spread **42,7** (dentro, ma **al p95 dello spread scende a 39,0 < 40**: sul bordo), H1 90,6, H4 181,6.

**Classifica 2018 su 11 serie esterne** (finestra comune 2018-01-02 -> 2018-12-28, ADR% mediano; feed Oanda e HistData, **non BCM**): Nasdaq 100 **1,619%** · Nikkei (Oanda) 1,475 · Nikkei (HistData) 1,466 · DAX 1,295 · S&P (Oanda) 1,141 · S&P (HistData) 1,121 · AUDJPY 0,895 · oro 0,893 · AUDUSD 0,772 · GBPUSD 0,748 · **EURUSD 0,678%** (80,2 pip). Dall'indice piu' al meno volatile **il rapporto e' 2,4 volte**. **Cluster per correlazione giornaliera** (collegamento medio, 2018 soltanto): {Nikkei, DAX, Nasdaq, S&P} · {EURUSD, GBPUSD, oro} · {AUDJPY, AUDUSD}; **oro contro indici: correlazione da -0,14 a -0,02**. Nota: il **singolo anno 2018** e' un regime, i feed sono esterni, e la correlazione giornaliera fra mercati con chiusure sfasate (DAX 17:30 CET, USA 22:00) e' sottostimata: e' una dimostrazione dello strumento, **non** una mappa da usare.
**Il valore EURUSD di 80,2 pip non e' verificato contro una fonte esterna indipendente** [NON MISURATO]. E' coerente con la volatilita' realizzata del feed (7,2% annuo -> range browniano atteso ~0,72%), ma non e' una prova.

**Verdetto dell'orologio sulle 12 serie**: **9 `ok`**, **3 `DA GUARDARE`** (AUDJPY, AUDUSD, GBPUSD: il picco estivo e' un evento locale con ora legale propria, 08:30/01:30 UTC; e' il limite dichiarato del controllo, non un feed rotto). Il controllo **non separa 13:30 da 14:30 UTC** (dati USA 8:30 contro apertura cash 9:30): un errore di esattamente un'ora fra questi due non si vede.

---

## 5. Il PIANO DI ESECUZIONE: che cosa gira dove, in che ordine, quanto costa

**Regola di casa applicata**: round e calcoli pesanti **solo sul PC di backtest**, **mai sul VPS** (firma 21/09). La scheda gira in **un solo thread**, legge CSV e scrive CSV/`.md`: **non apre MT5, non tocca terminali, conti, EA, preset**.

### 5.1 Le fasi

| fase | che cosa | dove | prerequisito | stima |
|---|---|---|---|---|
| **F0** (fatta) | strumento + autotest + prova su 12 serie reali | container | - | fatto |
| **F1** | `--ispeziona` sulle cartelle M1 che **esistono gia'** sul PC (`abtg_storico_indici`, `histdata_m1`, lo zip oro) e **schede di Nasdaq, oro, e dei simboli per cui il CSV c'e' gia'** | **PC di backtest** | **numpy sul PC [NON MISURATO]** (Python 3.14 c'e', DUKA_P0 del 05/10); nessuna installazione senza un si' di Claudio | ~1 minuto per simbolo di calcolo [DERIVATO]; ~15 minuti in tutto |
| **F2a** | **script MQL5 `ABTG_EsportaM1.mq5`** (da scrivere: `CopyRates` a blocchi -> CSV "Formato 1" in ora server, **sola lettura**, nessun ordine) | scrittura: sviluppatore/`mql5-ea-developer`, **cancello Opus**; compilazione F7 **a mano di Claudio** | firma di Claudio | sviluppo ~2-3 h [DERIVATO]; **tempo di export [NON MISURATO]**: canarino = 1 simbolo x 1 anno, si cronometra e si scala |
| **F2b** | schede dei **forex BCM** (24) e dei metalli, fuso `BCM_MISTO` | PC | F2a | calcolo ~23 s per coppia da 6,2 M barre [DERIVATO]; ~9 min in tutto |
| **F3** | schede degli **indici BCM nativi** (2024-09-26+) e del **Dow**; il Dow resta "campione corto, un solo regime" finche' non c'e' la firma del piano Dukascopy | PC | F2a | ~1 min |
| **F4** | **ranking, correlazioni, cluster** sulla finestra comune (default: ultimi 12 mesi comuni) **e** su 2 regimi (toro / crollo), consegnati come `.md` + `.csv` + **PDF** per Claudio | PC (poi container per il PDF) | F1-F3 | ~5 min |

**Alternativa se l'export pesa troppo**: esportare **M5** invece di M1 (5 volte meno righe). Il prototipo oggi vuole M1; un parametro `--tf-base` e' **backlog**, non implementato: ATR/ADR/sessioni/gap/zigzag resterebbero esatti, il cancello dell'orologio perderebbe risoluzione (gia' tollerata a 5 minuti).

### 5.2 La riga di lancio (solo SPECIFICA: **non e' scritta, non esce**)

Quando Claudio firma F1, la riga si scrive e **passa dai due cancelli prima di uscire** (`controlla_riga.py` + `controllo-preventivo`). Specifica:
- **Bersaglio in testa, per esteso**: *finestra PowerShell sul PC di backtest `DESKTOP-H4D7CAJ`. Nessun terminale MT5 viene toccato. Il VPS non viene toccato.*
- **`irm` davanti** che riscarica `scheda_simbolo.py` e il manifest dal branch `lavoro`, **pinnato a un commit**.
- Passi: (1) controllo che `python` e `numpy` rispondano, **altrimenti stampa e si ferma** (niente installazioni); (2) `--autotest` (deve dare `AUTOTEST OK`); (3) `--ispeziona` sulle cartelle del manifest; (4) corsa con `--manifest`; (5) **raccolta** in `Desktop\SCHEDE_SIMBOLO_<data>` + `Compress-Archive` + elenco dei file attesi da verificare in console. File `.ps1` in **ASCII puro**.
- **Sola lettura**: legge solo i CSV elencati nel manifest; scrive solo nella cartella di uscita.

### 5.3 L'ordine dei simboli (prima quelli con sedie e candidati)

1. **U30USD** (Dow: `771531`, `770202`, `770611`; lo stato di campo di oggi va riletto in `HANDOFF.md`, qui conta il candidato) · **D30EUR** (DAX: `770101`, `770411`) · **NASUSD** (Nasdaq: `770260`) · **XAUUSD** (oro: 12 grafici nella mappa del 02/08, la concentrazione piu' alta) · **SPXUSD**, **225JPY** (EMA200 e GapContinuation).
2. **EURUSD, GBPUSD, USDJPY** (PTE, Nightly, MaxMin) · **GBPJPY, AUDJPY, CHFJPY, EURJPY** (EMA200, EasyTrend, Bulge, CostToCost) · **USDCHF, USDCAD, NZDUSD** (GoldenCross) · **200AUD** (EMA200).
3. I restanti cross del Bulge a 22 e `XAGUSD`, `F40EUR`, `100GBP`, `E50EUR`, `E35EUR`, `EURCHF`.

### 5.4 Il costo, in ordini di grandezza

- **Calcolo**: 3,7 s per milione di barre e ~235 MB per milione [MISURATO nel container]. **36 simboli** a 2-6 M barre ciascuno: **~12-15 minuti, picco ~1,5 GB** [DERIVATO]. La velocita' del PC di Claudio e' **[NON MISURATO]**.
- **Export dal terminale**: **[NON MISURATO]**. Riferimento: scaricare la storia M1 dei 22 cross dal server aveva impiegato **89,8 minuti** in 6 passate (referto 30/09); l'export da disco locale dovrebbe essere piu' veloce, ma e' un'ipotesi.
- **Tempo di Claudio**: una riga (F1) + una compilazione F7 e un'accensione (F2a): pochi minuti ciascuna.
- **Soldi**: **zero**.

---

## 6. I limiti dichiarati e i buchi

1. **E' descrittivo.** Ritracciamento ed EMA200 **non** sono segnali: i pivot dello zigzag si conoscono in ritardo. Il nullo (RW) e' accanto proprio perche' un numero senza il suo nullo non dice niente.
2. **I dati BCM veri non sono in questo container.** Quello che ho provato sono feed di altri broker: provano lo strumento, **non** descrivono BCM. Lo spread BCM storico non esiste (solo 5 giornate vive su 8 simboli).
3. **Il Dow non ha storia profonda**: nessun feed esterno, Dukascopy in profondita' non scaricato (piano in attesa di firma). Una scheda del Dow dal 2024-09-26 e' **un solo regime**.
4. **Il DAX HistData e' 2010-2018 e non si incolla al nativo 2024+** (zero giorni in comune); due schede separate, mai fuse. Gli anni 2020-2023 di quel feed sono un altro indice: serve la **banda di prezzo** (il prototipo ce l'ha, nel manifest).
5. **Il giorno esatto del cambio d'orologio BCM sul forex e' [NON MISURATO]**; `BCM_MISTO` scarta la finestra dubbia (5 settimane).
6. **L'ora della scheda e' sempre il server UTC+1 fisso, anche per il passato**: le tabelle orarie di un feed vecchio sono nell'orologio moderno, non in quello che il broker mostrava allora (`--orologio vecchio` per l'alternativa).
7. **Il cancello dell'orologio ha un buco noto** (13:30 contro 14:30) e **non si applica** ai simboli dominati da eventi locali con ora legale propria (Australia): sono 3 `DA GUARDARE` su 12 nella prova.
8. **Soglie mie, da firmare**: ER trend 0,30 / laterale 0,15; zigzag 0,5 ATR; impulsi 2/3/4 ATR; "giorno pieno" 50%; correlazione di cluster 0,50; finestra minima di ranking 60 giorni. **Nessuna di queste decide un'azione**: sono la lente.
9. **Correlazione fra mercati con chiusure sfasate**: sottostimata; la tabella oraria e' piu' onesta di quella giornaliera per DAX/Nikkei contro USA.
10. **Diversita' di definizione dell'ADR**: la scheda ne usa una (H-L del giorno server, giorni pieni); l'ADR(50) del corso Point Break e il `ATR` del dashboard sono altre. Non si sovrappongono.
11. **HistData oro 2023**: buchi (1.319 M1 per giorno contro 1.380; 308.812 righe nell'anno contro ~354.000): l'ATR di quell'anno e' leggermente per difetto.
12. **714 barre di differenza non spiegate** fra le M1 pulite dell'oro (mie 1.980.301, referti 1.979.587): l'ATR coincide, la causa **[NON INDAGATA]**.
13. **Tutto cio' che e' marcato [NON MISURATO] sopra**: numpy sul PC, velocita' del PC, tempo di export, M1 nativo dell'oro in CSV, esistenza dei CSV SPX/Nikkei/DAX sul PC, `EURJPY`/`EURCHF` BCM.
14. **Che cosa TradingView da' e questo no**: la sensazione visiva, l'overlay delle notizie, il confronto fra strumenti a occhio. Quello che questo da' e TradingView no: numeri **riproducibili**, con fonte, fuso e nullo.

---

## 7. Le domande a Claudio

1. **Firma F2a**: scrivo lo script MQL5 `ABTG_EsportaM1.mq5` (sola lettura, CSV in ora server) e lo passo dal cancello. Va compilato (F7) e acceso **sul PC di backtest `DESKTOP-H4D7CAJ`, terminale `C:\Program Files\BCM Markets MT5 Terminal`** (nel referto DUKA P0 del 05/10 risulta il conto 50503392), **mai sul VPS**. Si' o no?
2. **Numpy sul PC**: se `python -c "import numpy"` fallisce, posso proporti `py -m pip install numpy` (non costa, ma cambia il PC)? Oppure preferisci che passi per un'altra via?
3. **Priorita' dell'export**: i 24 forex BCM da **2010** (peso) oppure gli **ultimi 3 anni** (leggero, bastano per "come si muovono oggi")? La scheda stampa comunque il blocco "ultimi 252 giorni".
4. **Una scheda ogni settimana?** Per i simboli in campo, la stessa scheda rigirata ogni settimana e' un controllo di regime gratuito (l'oro 2026 e' gia' tre volte quello del 2021-2023). Lo vuoi come attivita' del PC, o a richiesta?

---

## 8. File prodotti e stato del cancello

- `backtest_pipeline/scheda_simbolo.py` (prototipo, autotest dentro)
- `backtest_pipeline/risultati_archivio/SCHEDE_SIMBOLO_PROTOTIPO_2026-10-05/`: `LEGGIMI.txt`, `A_oro_repo/` (scheda + ranking dell'oro del repo, con spread), `B_esterno_2018/` (11 schede + `ranking_volatilita.csv` + `correlazioni_*.csv` + `cluster.txt`), `autotest.log`, `mutazioni_autotest.{py,log}`, `controllo_atr_vs_casa.{py,log}`, `verifica_mese_python_puro.log`, `ispeziona_repo_U30USD_prove.log`, `manifest_B_esterno_2018.csv`
- questo documento

**Cancello**: `controlla_riga.py --oggetto md` eseguito su questo file; il secondo strato (`controllo-preventivo`) **non l'ho invocato io** (sono un sottoagente di ricerca: non ho lo strumento per lanciare altri agenti): **va fatto dalla sessione principale prima che qualunque cosa esca verso Claudio**. Il prototipo e' **codice Python che non gira su nessun conto**, ma il manifest e la riga di F1 sono la parte che gira sul PC e **passano dal cancello**.
