# A3 / R002 - Evidenze

Rapporto sintetico per il Consiglio. Dettaglio e tabelle complete: `agents/A3/audit_dati.md`; codice: `agents/A3/audit_dati.py` (python3 -I, solo numpy, self-check 4/4 SUPERATI). Etichette: FATTO_VERIFICATO / INFERENZA / DA_VERIFICARE.

## 1. Audit dati dei 4 CSV M1 (FATTO_VERIFICATO)
| Periodo | Righe | Intervallo (ora server) | Barre H1 | Barre M15 | Spread USD p50 / p90 / p99 | Spread=0 |
|---|---|---|---|---|---|---|
| 2013 | 348.647 | 01/01/2013 23:05 - 31/12/2013 16:59 | 5.874 | 23.440 | 0,36 / 0,52 / 0,84 | 439 righe |
| 2018 | 349.730 | 02/01/2018 07:00 - 31/12/2018 18:59 | 5.873 | 23.487 | 0,21 / 0,27 / 0,40 | 94 |
| 2020 | 351.258 | 02/01/2020 04:00 - 31/12/2020 18:59 | 5.904 | 23.611 | 0,17 / 0,41 / 1,60 | 144 |
| 2025-26 | 611.062 | 02/01/2025 00:05 - 30/09/2026 23:59 | 10.280 | 41.095 | 0,21 / 0,30 / 0,45 | 0 |

- Integrita: 0 duplicati di timestamp, 0 violazioni dell'ordine, 0 righe malformate, 0 incoerenze OHLC (high<low, high<max(o,c), low>min(o,c)), 0 prezzi <= 0/NaN, 0 tickvol = 0, 0 spread negativi.
- Buchi: weekend regolari (52 per anno, 91 in 2025-26, mediana ~49 h); pausa giornaliera 60-119 min (181/186/189/350); buchi anomali >= 120 min feriali: 24 / 19 / 17 / 10, quasi tutti festivi USA e Natale/Capodanno (fino a 2.281 min) o pause serali allungate di 126-132 min in settimane di sfasamento orario legale (INFERENZA). Buchi brevi 2-59 min: 344 / 38 / 276 / 150 (minuti senza tick, probabile; DA_VERIFICARE).
- Anomalie da trattare: spread = 0 concentrato a luglio 2013 (364 righe) e aprile-maggio 2020 (142): valore mancante probabile (INFERENZA); A4 deve sostituirlo o dichiararlo. Gap di riapertura (domenica) fino al 2,06% inclusi nell'ATR e negli stop.
- Spread per ora: piu caro nelle ore server 21-23 / 0-1 (rollover); in 2025-26 0,24-0,26 USD di notte contro 0,19-0,21 in ore 8-20. Tabella completa per ora in audit_dati.md. Spread del broker BCM, non FTMO (DA_VERIFICARE).
- Livello prezzo: 1.160-1.696 (2013/2018), 1.451-2.075 (2020), 2.614-5.597 (2025-26): confrontare periodi solo in unita ATR.

## 2. Geometria a priori (nessun pattern guardato)
Definizioni: Bollinger(20,2) su chiusure (dev. std. di popolazione), ATR(14) Wilder, target = SMA(20) (interpretazione di "mediana"), stop 3 ATR, ingresso sulla banda opposta; costo = spread mediano del periodo / ATR di ogni barra, pagato una volta.

Fatto strutturale: SMA-banda inferiore e banda superiore-SMA sono identiche (2 sigma) in ogni barra; la larghezza e il doppio.

| Periodo / TF | Distanza banda-SMA in ATR p10 / p50 / p90 | Larghezza ATR p50 | R:R (target/stop) | Win rate di pareggio senza costo | Con spread mediano |
|---|---|---|---|---|---|
| 2013 H1 | 1,11 / 1,98 / 3,78 | 3,96 | 0,66 | 60,2% | 62,0% |
| 2013 M15 | 1,10 / 1,83 / 3,39 | 3,66 | 0,61 | 62,1% | 66,0% |
| 2018 H1 | 1,17 / 1,94 / 3,48 | 3,89 | 0,65 | 60,7% | 62,6% |
| 2018 M15 | 1,13 / 1,89 / 3,31 | 3,77 | 0,63 | 61,4% | 65,5% |
| 2020 H1 | 1,07 / 1,77 / 3,33 | 3,55 | 0,59 | 62,8% | 63,5% |
| 2020 M15 | 1,06 / 1,73 / 3,13 | 3,45 | 0,58 | 63,5% | 64,9% |
| 2025-26 H1 | 1,21 / 2,00 / 3,59 | 4,00 | 0,67 | 60,0% | 60,3% |
| 2025-26 M15 | 1,17 / 1,91 / 3,38 | 3,82 | 0,64 | 61,1% | 61,7% |

Implicazioni (FATTO + INFERENZA):
1. Con stop 3 ATR e target alla SMA, la strategia deve vincere circa il 60-64% dei trade prima dei costi e il 60-66% dopo lo spread mediano (H1 60-64%, M15 62-66%). Con spread p90 sale a 60-64% (H1) e 62-68% (M15).
2. In un mercato senza deriva la probabilita di raggiungere il target prima dello stop e esattamente S/(S+T) = il win rate di pareggio senza costo: l'ingresso sulla banda opposta non crea edge per costruzione. Il vantaggio deve venire dal pattern e deve superare lo spread: da +0,3 a +4,1 punti percentuali sul win rate (M15 e circa 2 volte piu esposto di H1; 2013 e 2018 i peggiori).
3. Per un profit factor lordo 1,2 servono ~65% di vittorie (R:R 0,65).
4. Il pareggio dipende dall'ampiezza delle bande al momento dell'ingresso: ~73% se le bande sono strette (1,1 ATR), ~46% se larghe (3,5 ATR). Il test sulle regole deve confrontare il win rate osservato con il pareggio delle barre dove scatta il segnale (non con quello medio).
Limiti: ingresso/uscita ideali (nessun gap, slippage, commissioni), ATR gonfiato dai gap di riapertura, target SMA ricalcolata ogni barra (R003 prevede ogni 3 barre), spread BCM non FTMO.

## 3. Ricerca nel repo /home/user/GITHUB (solo letture; V0_C0_RISERVATO e file BREAKING_BAND_TEST_* ignorati)

Metodo: Grep case-insensitive di "bulge" e "bollinger" su tutto il repo (esclusi riservati), find per nomi file *bulge* / *boll*, grep di iBands/BandsHandle in mql5/, report/, backtest_pipeline/, optimizer/, tools/, agent/.

### 3.1 EA o indicatore "Bulge" nel codice: NON trovato (FATTO_VERIFICATO)
- Nessun file con "bulge" nel nome. Nessun .mq5/.mqh/.py/.set/.ini/.md di mql5/, report/, docs/, backtest_pipeline/ contiene "bulge". Nessun commit con "bulge" o "bollinger" nel messaggio (git log --grep).
- Le uniche occorrenze di "bulge" fuori dalla cartella del progetto sono nei dati: `/home/user/GITHUB/data/statements/trades_auto.csv` (colonna `strategy` = commento ordine), 298 righe su 1.005.

### 3.2 Trade etichettati BULGE in data/statements/trades_auto.csv (FATTO_VERIFICATO sui dati; origine INFERENZA)
- Etichette: BULGE_MULTI_SIGNAL_BLU_L / BLU_S / VIOLA_L / VIOLA_S / VIOLA_B / ARANCIO_L / ARANCIO_S e BULGE_V3_CLEAN. Mercato: 22 coppie forex (nessun XAUUSD), lotti 0,03-1,20, aperture dal 31/03/2026 al 08/06/2026, durata mediana ~7,5 h. Il codice sorgente dell'EA non e nel repo (un EA esterno o non versionato; chi l'abbia scritto e DA_VERIFICARE). Il file e l'estratto di uno statement MT5 (README di data/statements parla di export dello storico; esiste ReportHistory50503392.xlsx: INFERENZA che il conto sia il demo BCM 50503392, non verificato).
- Risultati netti (profit + commissione + swap): 298 ticket (292 posizioni uniche; 6 coppie di ticket gemelli BLU/ARANCIO sulla stessa posizione), 207 vincenti / 91 perdenti, win rate 69,5%, profit factor 0,83, netto -1.148,52 (di cui commissioni -372,11). Vincita media 26,63, perdita media 73,19: pareggio implicito 73,3% contro 69,5% osservato (coerente con la geometria: R:R basso richiede win rate alto).
- Per etichetta (n, win%, PF, netto): BLU_L 123, 71,5%, 1,05, +126,46; BLU_S 115, 64,3%, 0,70, -834,02; VIOLA_S 29, 69,0%, 0,46, -658,23; VIOLA_L 14, 78,6%, 1,27, +56,85; VIOLA_B 7, 100%, n.d., +163,34; ARANCIO_L 4, 75%, 1,11, +2,50; ARANCIO_S 5, 60%, 0,39, -14,96; V3_CLEAN 1, +9,54.
- Lettura onesta: il campione e piccolo, non separa costi, e stato osservato su forex per 2,5 mesi in condizioni non testate: il sottoinsieme short perde, i long sono circa pareggio. Non e una prova su oro ne sulla Breaking Band della Checklist 15/02/2026 (non sappiamo se l'EA implementi quella checklist). Nessun report del repo analizza questi trade.

### 3.3 Bollinger nel repo (altre occorrenze)
- `mql5/Experts/IchiTrend_Gold_Base.mq5` + `README_IchiTrend_Gold.md`: EA XAUUSD M5 "base" (v1.1). Direzione dall'Ichimoku (Tenkan > Kijun e prezzo oltre la nuvola); innesco = chiusura "fresca" oltre la banda Bollinger(20, 2,0) nella direzione del trend (rottura, non rientro); SL = 1,5 ATR, trailing 2 ATR, rischio 0,5%, spread max 50 punti, una sola posizione. E una strategia di continuazione per breakout, il contrario del rientro verso la media di Breaking Band. Il README non riporta risultati di backtest; nessun report del repo (report/, backtest_pipeline/) cita IchiTrend: nessun risultato noto (DA_VERIFICARE se esistono risultati altrove).
- `piano_trading/build_plan.js` (testo del piano trading): "EA Bollinger H1 (multi-ordine), Forex, compressione/espansione bande, In test - ridurre rischio", e nota "l'EA Bollinger a 10 ordini con rischio 5% e TROPPO". Descrive uno stato di lavoro, nessun numero di performance. Probabile corrispondenza con gli ordini BULGE_MULTI_SIGNAL di 3.2 (INFERENZA, non verificata: il piano non cita il nome Bulge).
- `backtest_pipeline/REGISTRO_TEST.md` (righe 159, 197-203): appunti dai live di Paolo/Emiliano: Bollinger con "37, dev 3" per il DAX, "20/2" per le valute; Std Dev in espansione dopo compressione come conferma del breakout; nessun test numerico delle bande.
- `docs/live_paolo/*` e `docs/live_emiliano/*` (trascrizioni dei live): descrizioni discorsive delle bande (compressione/squeeze prima di un movimento, retest della banda inferiore/superiore, deviazione standard in espansione), nessun numero testabile. Il materiale ufficiale della Breaking Band e in sala-del-consiglio/breaking_band/materiali/.
- Nessuna analisi quantitativa di bande di Bollinger o bulge nel repo: il test della Breaking Band non ha precedenti numerici interni sull'oro. Cio che esiste e (a) un EA di breakout su oro senza risultati registrati, (b) trade BULGE forex senza codice sorgente e senza analisi.

## 4. Obiezioni e cosa non e stato fatto
- Nessun test delle regole del pattern (come richiesto): il win rate necessario e un limite aritmetico, non una stima del win rate reale.
- Nessuna fonte indipendente per verificare i dati M1 (buchi brevi, salti) ne lo spread FTMO.
- I numeri della sezione 3.2 sono dati di conto, non backtest; dedurne qualcosa sulla Breaking Band sarebbe un salto non giustificato.
