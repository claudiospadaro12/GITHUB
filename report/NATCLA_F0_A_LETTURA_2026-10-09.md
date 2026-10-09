# NATCLA F0 - lotto A (11 simboli forex) - 08/10/2026 16:24-17:01

Fonte: `backtest_pipeline/risultati_archivio/NATCLA_F0_A_20261009/NATCLA_F0_A.zip` (SHA256 6829a122...; PC di backtest, BCM demo, pin e2f0506b, **EA v1.04**, compilazione 0/0, 37 minuti, media 33 s a passata). Lettore `leggi_natcla_f0.py` (stesso del lotto C). Tabella completa: lanciare il lettore sullo zip. Modello 1 OHLC M1, InpSoloConta: **nessun ordine, nessun PF, nessun DD, nessun merito.**
Simboli: EURUSD, GBPUSD, AUDUSD, NZDUSD, USDCAD, USDCHF, USDJPY, EURGBP, EURNZD, GBPJPY, GBPAUD.

## Esito
- **66 passate: 66 OK, 0 KO, 0 non lanciate.** VERIFICA ADX **MetaQuotes su tutte e 66**. AVVIO v1.04 x 66: lo SHA256 dell'EA nel RIEPILOGO (681DC882...) e' quello di `EA_NatCla.mq5` al pin e2f0506b (NC_VER 1.04), girato l'08/10 col pin vecchio come prescrive il file prova ("i lotti PILOTA, A, B, D NON si rifanno"). Che la v1.05 non cambi niente sul forex **non e' misurato su una passata forex v1.05**: lo dicono il diff (solo tre CopyBuffer di "tocco" in CaricaDati), il collaudo (modelli 0 e 2) e XAUUSD (pilota v1.04 = lotto C v1.05, CSV identici).
- Tempo: mediana 33 s, media 33 s, min 28, max 58. La media del pilota (33 s) regge, la sua forchetta 28-40 s no: **7 passate su 66 oltre 40 s** (58 s: USDCAD M2_H1, USDCHF AUDIO_H4, GBPAUD AUDIO_H1; H12 max 35, D1 max 43). H4/H12/D1 sul forex erano gia' misurati dai lotti B e D del 07/10 (B: mediana 28, max 68). F0 intera (216 passate) = **2,0 ore**.
- Finestra: **1,99 anni** (dalla barra della VERIFICA ADX, luglio 2024, al 30/06/2026) = **un solo regime**, non misurato come regime. Proxy prezzo della linea: EURNZD +14,0%, USDCHF -10,0%, NZDUSD -7,4%, EURUSD +5,3%, gli altri fra +0,3% e +4,3%.

## Setup per famiglia (n = setup; soglia E3 = 300)
| famiglia | simboli | setup | E3 | simboli con >= 70 |
|---|---:|---:|---|---|
| AUDIO_H1 | 11 | 5.089 | SOPRA | **11 su 11 (E0: tutti VIVI)**, 434-485 ciascuno |
| AUDIO_H4 | 11 | 1.225 | SOPRA | 11 su 11 |
| AUDIO_H12 | 11 | 461 | SOPRA | 0 su 11 (28-52 per simbolo) |
| AUDIO_D1 | 11 | 252 | **SOTTO: merito SOSPESO per n** | 0 su 11 (17-29) |
| M2_H1 | 11 | 4.334 | SOPRA | 11 su 11 |
| M2_H4 | 11 | 1.082 | SOPRA | 11 su 11 (71-137) |
Frequenza AUDIO_H1: ~218-244 setup/anno per simbolo (circa 1 al giorno di borsa per simbolo). Forex AUDIO_H4: 49-67/anno; D1: 8,6-14,6/anno.
Linee AUDIO_H1, setup per simbolo **nella finestra di 1,99 anni** (non per anno): ST25 221-247 (~230), ST30 159-196 (~180), **ST35 solo 41-55 (~50)** (la linea piu' lontana dalla EMA e' anche la piu' rara). In M2 tutti i setup sono sulla linea EMA200.

## Costo (stop >= 40 x pedaggio; geometria AUDIO letterale, commissione DERIVATA 0,004% del prezzo)
- **Con la commissione nessuna delle 66 passa il lavoro**: 47 FRA (13,3-40x), 19 ESCLUSO PER COSTO, 0 PASSA. **Senza commissione**: 37 PASSA, 19 FRA, 10 ESCLUSO. La commissione e' DERIVATA (0,004% del prezzo), non misurata: il verdetto PASSA/FRA dipende da quel numero. FRA non e' un'esclusione.
- **FRA anche senza commissione** (19): USDCHF su H1, H4, H12, D1, M2_H1 (passa solo su M2_H4); EURUSD e USDCAD su H12 e D1; NZDUSD e USDJPY su D1; GBPAUD su H1, H4, M2_H1; GBPJPY su H1, H4, H12, M2_H1, M2_H4.
- **ESCLUSO PER COSTO anche senza commissione** (10): **EURNZD su tutte le 6 configurazioni**; GBPAUD su H12, D1, M2_H4; GBPJPY su D1.
- **ESCLUSO PER COSTO solo con la commissione** (9): GBPAUD (H1, H4, M2_H1), GBPJPY (H1, H4, H12, M2_H1, M2_H4), USDCAD su D1. Quindi con la commissione **GBPAUD e GBPJPY sono esclusi su tutte e 6**, come EURNZD.
- Lotto B (11 altri forex, girato il 07/10): il lettore ci era gia' passato il 07/10 (la lettura del lotto D ne cita le 740 incoerenze), ma **la sua tabella non era mai stata scritta**: eccola in breve, stesso lettore. **Nessuna delle 66 passa il lavoro, ne' con ne' senza commissione** (con: 35 ESCLUSO, 31 FRA; senza: 16 ESCLUSO, 50 FRA). GBPNZD escluso su tutte e 6 anche senza commissione; CHFJPY escluso su tutte e 6 con la commissione e su 5 senza (M2_H4 senza = FRA); AUDNZD e GBPCAD esclusi su tutte e 6 con la commissione (FRA senza, tranne GBPCAD D1); D1 esclusa su 11/11 con la commissione e su 7/11 senza. Dettaglio: lanciare il lettore su `NATCLA_F0_B_20261007/NATCLA_F0_B.zip`.
- 🔴 Limite: tutto questo vale per la geometria AUDIO letterale. La regola di stop di Claudio ("20 unita' oltre EMA200/ST3.5") **non e' ancora nel codice**: con stop piu' lontani i rapporti salgono e la classificazione puo' cambiare. **[NON MISURATO]** per il forex; sugli indici resta ~10-12x (lotto C).

## Controlli e incoerenze
- Spread del tester (VARIABILE da barra M1): mediana 0,1-0,2 pip sui maggiori (EURUSD, GBPUSD, USDJPY coerenti con lo spread vivo, rapporto 0,50-0,67); **gli altri 8 simboli non hanno spread vivo** (primo numero).
- **Il lettore segnala 990 righe-ordine con stop_ped fuori tolleranza** (sui 37.329 ordini dei setup). Non e' un'incoerenza dell'EA, ma la causa **non e' lo spread**: e' l'arrotondamento dei **prezzi**. L'EA calcola stop_ped = |p - SL| / (Ask - Bid) con p e SL non arrotondati, e il CSV li scrive a `_Digits` (mezzo punto ciascuno = fino a 1 punto sulla distanza); lo spread del tester (Ask - Bid) e' un numero intero di punti: non e' letto direttamente, lo conferma la prova qui sotto (commissione dell'EA 0 su tutte le 26.126 righe CONTA). Prova che distingue le due spiegazioni: AUDUSD H1 2024.07.05 13:00 ST25, distanze nel CSV 149/99/50 punti, spread 4 punti, stop_ped 37,5/25,0/12,5: uno spread unico non spiega i tre ordini (servirebbero 3,97/3,96/4,00 punti), distanze vere 150/100/50 si'. Su tutte le 78.378 righe-ordine CONTA: **0 fuori dalla banda "+/-1 punto sulla distanza"**; la banda "spread +/-0,5 punti" ne lascia fuori 4 (3 fra i setup: spread di 111-399 punti, dove mezzo punto non copre niente). Contro-esempio (stop_ped falsato apposta sui 37.329 ordini dei setup): la banda dei prezzi prende il 98,5% di un errore del 10% e il 100% di un fattore 2; quella dello spread solo il 34,6% e l'81,4%, perche' su 7.089 ordini lo spread e' 1 punto e mezzo punto vale un fattore 3. Lotto B (740) e lotto D (171): stesso esito, 0 fuori dalla banda dei prezzi. Nel lotto C dava 0 perche' un punto e' piccolo rispetto allo spread di indici e oro.
- I due conteggi: 990 = ordini dei SETUP (nuovo episodio, entro il limite di tocco, contesto valido all'armo); **1.459** = stessi filtri **senza il limite di tocco** (15.857 righe, 47.571 ordini); tutte le righe CONTA danno 2.189 su 78.378.
- Effetto sui numeri di costo: la distanza mediana dell'ordine piu' lontano e' 150 punti su tutte le 66, quindi l'errore e' al massimo +/-0,7% (1 punto su 150). Ricalcolato con lo stop_ped dell'EA (che usa i prezzi veri): scarto massimo 0,94% (GBPJPY AUDIO_H1, 13,60 contro 13,73), **0 verdetti su 66 cambiano**. Il caso piu' vicino al bordo e' GBPAUD AUDIO_H12 senza commissione: 13,25 (EA) / 13,27 (lettore) contro 13,3 = ESCLUSO per 0,05.
- Orologio BCM sul forex (H4/H12/D1/M2_H4): setup prima del cambio 18-24% per configurazione (634 su 3.020, 21%), dopo 71-76% (2.222, 74%), il resto nella zona dubbia (finestra 0,48 anni prima, 1,40 dopo): il campione "prima" e' corto.
- Determinismo: **misurato**. Il PILOTA del 07/10 (stesso pin e2f0506b, stessa v1.04) ha 4 passate che il lotto A ripete: EURUSD e GBPUSD x AUDIO_H1 e M2_H1. Lettore sui due zip insieme: **4 su 4 CSV IDENTICI** (senza la riga #AVVIO).
- XAUUSD E0 vs feed esterno: non nel lotto A (e' nel C).

## Cosa dice e cosa NON dice
- Dice: il motore **conta setup in abbondanza su tutti gli 11 forex** a H1, H4 e in M2 (H12 e D1 per simbolo sono sotto 70); ADX MetaQuotes confermato su 66/66; i tempi di macchina sono noti (F0 = ~2 h).
- Non dice niente sul merito (nessun PF, DD): il Modello 1 puo' solo bocciare. Il forex del lotto A non e' bocciato in blocco: per costo **EURNZD e' escluso su tutte e 6 anche senza commissione**, GBPAUD e GBPJPY su tutte e 6 con la commissione (su 3 e 1 anche senza); gli altri 8 sono FRA con la commissione, tranne USDCAD D1 (ESCLUSO).
- Mappa NatCla dopo A, B, C, D: forex e oro hanno setup in abbondanza a H1/H4; H12 e D1 sono sotto soglia per simbolo (D1 anche in famiglia); gli indici sono esclusi per costo con la geometria letterale. Sul costo del forex con la geometria letterale: **nessuna passata di A e B passa il lavoro con la commissione derivata**; senza commissione passano solo simboli del lotto A (37 passate), nessuno del B.

## Aperto
1. Regola di stop di Claudio (20 u oltre la linea) nel codice (v1.06, piano B in `NATCLA_PIANO_B_V106_2026-10-08.md`) -> poi riclassificare il costo.
2. Periodo ATR e simboli: domande ancora aperte a Claudio (`data/natcla/LEGGIMI.md`).
3. Tolleranza del lettore sul forex: la forma giusta e' "+/-1 punto sulla distanza" (|stop_ped - d/s| <= punto/s + 0,05), non mezzo punto di spread; modifica allo script = cancello. Fino ad allora le 990 si leggono come sopra.
4. Un solo regime (luglio 2024-giugno 2026): la prova di regime resta da fare prima di qualunque merito.
5. Lettore indipendente (09/10): passato, con correzioni a tempi, linee per finestra, liste di costo, causa e conteggi delle 990, orologio, determinismo (misurato), lotto B e v1.04/v1.05.
