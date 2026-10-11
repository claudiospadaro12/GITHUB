# TABELLA UNICA DELLE SEDIE per merito misurato (11/10/2026)

**BOZZA, NON PASSATA DAL CANCELLO** (strato 1 `controlla_riga.py --oggetto md`: esito in sez. 10; strato 2 `controllo-preventivo`: NON LANCIATO). Non e' stato mandato a nessuno.
**SOLA LETTURA del repo** (branch `lavoro`). Nessun numero misurato di nuovo, nessun EA, preset, sedia, magic, conto, Guardian o terminale toccato, nessuna riga di lancio, nessuna decisione presa. Il reale `10105439` e' citato solo come conto in chiaro, mai toccato. Taglie, rischio, conti e sedie sul reale restano di Claudio.
Nata dalla domanda di Claudio: _"le sedie su FTMO sono quelle col PF piu' alto?"_ (risposta in sez. 7: **NO, non confermabile**, numeri accanto).

**Etichette**: **FATTO** = letto alla fonte (file e riga) · **DERIVATO** = somma o conto mio su numeri FATTO, metodo scritto accanto · **INFERITO** = ragionamento · **NON TROVATO** = cercato e assente (mai stimato) · `[T]` tick reali BCM · `[B]` barre OHLC (screening: non promuove e non boccia il merito; il suo DD e' un limite INFERIORE e un DD gia' oltre il muro e' un fatto) · deal = uscite, pos = posizioni (rapporto misurato 1,00-2,31, `CEN` r.135).
**Unita'**: PF = adimensionale; n in posizioni salvo scritto "deal"; DD in % del picco di equity del tester, **sempre con taglia di rischio e deposito**; frequenza in operazioni/giorno di borsa; forward in EUR netti.

---

## 0. ORDINE DELLA TABELLA, DICHIARATO PRIMA DEI NUMERI

1. **Primo criterio**: verdetto sui cancelli di oggi, nell'ordine **SI, NO, NON MISURABILE**. E' l'ordine della richiesta, non una graduatoria di valore: "NON MISURABILE" non e' meglio ne' peggio di "NO".
2. **A parita' di verdetto**: prima le righe con **n OOS >= 150 posizioni**, per **PF OOS decrescente**; poi, in coda, le righe **"campione sottile: merito sospeso"** (n OOS < 150, oppure finestra piena senza OOS, oppure n non trovato), **in ordine di magic crescente, che non e' un ordine di merito**. Regola di casa: _"il campione sottile sospende il giudizio sul MERITO, mai sul RISCHIO"_ (`CEN` r.204-207).
3. Una riga = una **sedia** (magic + simbolo). Il magic `770611` compare **tre volte** (ORB Dow, ORB argento, ORB EURAUD) perche' sono tre sedie diverse (`PIA` r.161); `971501` due (XAUUSD del contratto, AUDCHF in campo).
4. **Questa tabella NON e' una classifica dei migliori** e non propone di accendere o spegnere niente (sez. 6: solo domande).

## 1. I CANCELLI DI OGGI, LETTI ALLA FONTE (con la riga)

Metro scelto: quello che `PERCHE_NON_PASSANO_2026-09-09.md` §3.1 chiama "il metro che un candidato nuovo trova in faccia oggi" (r.165-175), rimandato tale e quale in `DOSSIER_SCHIERAMENTO_EMA200_DOW_2026-09-09.md` §5 (r.218-231):

| sigla | cancello | soglia (citata) | fonte |
|---|---|---|---|
| **R** | RISCHIO | DD <= **10,0%** e peggior giornata > **-5,0%** | `PNP` r.169; `DOS` r.225-226 |
| **N** | CAMPIONE (Emendamento A) | **n >= 150 per finestra** (150 IS e 150 OOS = 300 totali); unita' = **posizione**, "dentro la finestra OOS" | `PNP` r.170; `CEN` r.206-207; `DOS` r.228 |
| **0** | C0 | se n >= 150: **PF >= 1,10** nella finestra peggiore | `PNP` r.171; `DOS` r.229 |
| **3** | C3 costo | stop mediano >= **40 x spread** | `PNP` r.173; `DOS` r.227 |
| **F** | FREQUENZA | >= **1,00 op/giorno di FAMIGLIA** (firma 07/09) | `PNP` r.172 |

- **PF OOS >= 1,2 NON e' un cancello nei documenti letti.** La soglia di PF dei cancelli di oggi e' **1,10** (C0). Il numero 1,20 compare solo come soglia di un singolo file prova (`report/I_MORTI_E_LO_STORICO_2026-09-23.md` r.513: "PF OOS >= 1,20") e come criterio C dei recuperabili ("PF > 1,20", `PNP` r.291); 1,15 nel "metro di un round vero" (`PNP` r.188). **FATTO** con un grep su `report/*.md` e `REGISTRO_TEST.md` (non su tutto il repo); la colonna PF OOS resta visibile ma non e' un cancello.
- **Come leggo il verdetto**: **NO** = almeno un cancello **misurato e fallito** · **SI** = R, N, 0, 3 tutti misurati e superati · **NON MISURABILE** = nessun fallimento misurato ma almeno un cancello non misurabile. Dentro la cella: `ok` / `NO` / `?` (non misurabile o non riconciliato) / `nd` (non applicabile: C0 vale solo da n >= 150).
- **F non entra nel verdetto di sedia**: la firma del 07/09 sposta il pavimento da sedia a **famiglia** (`CLAUDE.md`, "PAVIMENTO DI FREQUENZA"). Lo scrivo accanto (sez. 4, colonna "freq.") con i valori di famiglia del 09/09 (`PNP` r.246-259: EMA200 1,850 passa; Aperture 1,660 passa solo se i tre EA contano insieme, "presi uno per uno nessuno passa"; SupRev 0,861, SuperWave 0,680, PunteLarry 0,512, PTE 0,470, ORB 0,430, CostToCost 0,429, EasyTrend 0,309, MaxMinNotte 0,248, GapFill 0,225, BreakingBand 0,175, GapContinuation 0,170: sotto). **Dimensione dell'effetto**: la sola EMA200 (famiglia a 1,850) e' sopra; togliere F dal verdetto non cambia lo stato di nessuna riga in "SI" (nessuna riga e' SI).
- **R: come lo applico**: DD a rischio 1% (normalizzato come `PNP` r.175). Se **qualunque** misura documentata della stessa cella (anche su barre, anche su storico lungo) mostra DD > 10% a 1%, R = NO: e' un fatto accaduto (Emendamento B e `CEN` §1.1 punto 4). Se il DD e' ok ma la peggior giornata **NON TROVATA**, la cella scrive "DD ok, giorn. ?".
- **Unita' del campione, ancora aperta** (`DOS` r.249: _"Da decidere PRIMA del prossimo round"_; `DOS` r.260: _"Se l'unita' e' la POSIZIONE nessuna sedia passa N"_): uso la posizione come `CEN` §1.8. Dove cambia lo stato di una riga lo scrivo (solo EMA200 `771531`).
- Il 09/09 la lettura "in uscite" dava **una sola sedia sopra** (`PNP` r.236: EMA200 Dow). Qui sotto, con la posizione e le misure arrivate dopo, **lo stato di quella riga e' NON MISURABILE**, non SI (riga 44).

**Cancelli che esistono ma NON ho usato nel verdetto** (li cito perche' sono nei documenti): R4 "rischio vero = dichiarato" (`DOS` r.230, firma 08/09) e PROVA DI REGIME, Emendamento C (`DOS` r.231: _"NON MISURABILE"_ per tutte, un solo regime). Con la prova di regime nel verdetto nessuna riga sarebbe SI per costruzione.

## 2. LE SIGLE DELLE FONTI (tutte su `lavoro` @ `fb1537df`)

`CEN` = `report/CENSIMENTO_CONTRATTI_v2.md` · `CTR` = `report/CONTRATTI_DELLE_SEDIE_FTMO_2026-09-20.md` · `RES` = `report/RESOCONTO_EA_IN_PAROLE_SEMPLICI_2026-10-06.md` · `G2` / `G3` / `G4` / `G5` = `report/RESOCONTO_EA_G2_EMA200_SW_ORB_...`, `G3_NOTTE_EVENTI_BULGE_...`, `G4_FOREX_AGOSTO_...`, `G5_SUPERTREND_GOLDEN_ORO_...` (tutti `_2026-10-05.md`) · `ORB` = `report/CENSIMENTO_ORB_2026-09-29.md` · `DAXM` = `report/APERTURE_DAX_MAPPA_2026-10-03.md` · `MEMA` = `report/MIGLIORA_EMA200_DOW_H1_2026-10-11.md` · `REG` = `report/REGIMI_DOW_BCM_2026-10-11.md` · `PIA` = `report/PIANO_SCHIERAMENTO_PICCOLO_DEMO_2026-10-11.md` · `PNP` = `report/PERCHE_NON_PASSANO_2026-09-09.md` · `DOS` = `report/DOSSIER_SCHIERAMENTO_EMA200_DOW_2026-09-09.md` · `TRS` = `report/TRIAL_STORICO_COMPLETO_2026-10-10.md` · `AUT` = `report/FTMO_TRIAL_AUTOPSIA_2026-10-08.md` · `CHI` = `report/FTMO_CHALLENGE_CHIUSURA_2026-09-30.md` · `8GG` = `report/FTMO_PRIMI_OTTO_GIORNI_2026-09-30.md` · `SOSP` = `report/SOSPENSIONE_SEDIE_DEMO_2026-09-25.md` · `AZF` = `report/AZZURRA_FREQ_LETTURA_2026-10-10.md` · `BUL` = `report/MIGLIORA_BULGE_VIOLA_2026-10-08.md` · `EUR` = `report/ORB_EURAUD_SUL_REALE_2026-09-25.md` · File citati per nome nelle celle: `report/AUDIT_RISCHIO_FLOTTA_2026-10-01.md`, `report/AZZURRA_PICCOLO_PASSI_2026-10-09.md`, `report/DECISIONE_OROLOGIO_INVERNALE_BCM_2026-10-11.md`, `report/APERTURE_DOW_MAPPA_2026-10-03.md`, `report/RESOCONTO_EA_CONSOLIDATO_2026-10-05.md` (`consolidato`), `report/PRIORITA_EA_E_DA_FARE_2026-10-08.md` (`PRI`), `HANDOFF.md` · `C01` = `backtest_pipeline/coda/referti/CODA_01_sedie_attaccate_20261011_033004.log` (sonda di SOLA LETTURA di stanotte; profilo salvato su disco, non la finestra viva) · `REGT` = `REGISTRO_TEST.md` (root) · `TA` = `data/statements/trades_auto.csv` (export del solo piccolo, chiusure fino al 09/10 14:22, citato tramite `PIA`).

**Dove sta ogni terminale oggi** (`C01` r.1-103, FATTO): piccolo `50503392` (`C:\Program Files\BCM Markets MT5 Terminal`): 29 grafici con EA, 26 con magic (r.14-43), **nessun Guardian** · FTMO `C:\FTMO` (trial `1514806751`, scade il 14/10, `PRI` r.29): 10 grafici, 7 sedie con magic + Guardian 779001 (r.48-58) · 100k `50504263` (`...-V3`): **nessuna sedia nel profilo attivo** (solo TradeExporter e Guardian 779001, r.76-78); 5 sedie sono **residui su disco** di altri profili (r.79-85) · reale `10105439` (`C:\BCM_Reale`): SlippageLogger, Guardian 779002 e **ORB EURAUD 770611** (r.96-99) · manuale `50503635` e Tickmill: fuori perimetro (sez. 9).

---

## 3. TABELLA 1 — identita', dove sta, campione, PF, cancelli, verdetto

Le tre tabelle (1, 2, 3) hanno lo **stesso ordine e lo stesso numero `#`**. "dove oggi": **ATT** = attaccata nel profilo salvato (`C01`); **SOSP** = tolta il 25/09 con firma di Claudio (`SOSP` r.3; eseguita sul piccolo il 25/09 13:07 e sul 100k, `SOSP` r.88-96); **RES** = residuo su disco, non attivo.

### 3.1 Verdetto SI: nessuna riga (0 su 49)

### 3.2 Verdetto NO, con n OOS >= 150 posizioni (PF OOS decrescente): 2 righe

| # | magic | sedia | dove oggi | n IS / n OOS | PF IS -> OOS | R | N | 0 | 3 | verdetto: cancelli falliti |
|--:|---|---|---|---|---|---|---|---|---|---|
| 1 | 770101 | DAX Apertura RETEST **long** · D30EUR M5 | SOSP piccolo (`PIA` r.61); RES sul 100k (`C01` r.81); non nel profilo trial; non nel profilo reale dell'11/10 (`C01` r.96-99); c'era nella challenge `541452707` (`8GG` r.10) | **132 / 193 pos** (175/270 deal) FATTO `CTR` r.63 | 1,12634 -> **1,39709** | DD ok (7,2328%), giorn. ? | **NO** (IS 132) | ok (IS 1,126 >= 1,10) | **NO** (33,0x geometria viva; 42,3x piena; 26,6x P95; `CEN` r.215) | **NO**: N, 3 |
| 2 | 770105 | DAX Apertura RETEST **short** · GER40.cash M5 | **ATT trial FTMO** (2,0%, solo short, `C01` r.56) | 138 deal IS / **194 pos** OOS (`DAXM` r.52) | 0,96513 -> **0,95734** | **NO** (DD OOS 12,3052%) | **NO** (IS 138 deal < 150) | **NO** (0,957 < 1,10, n >= 150) | ? | **NO**: R, N, 0 |

### 3.3 Verdetto NO, campione sottile: merito sospeso (magic crescente): 41 righe

| # | magic | sedia | dove oggi | n IS / n OOS | PF IS -> OOS | R | N | 0 | 3 | verdetto: cancelli falliti |
|--:|---|---|---|---|---|---|---|---|---|---|
| 3 | 770202 | Dow Apertura **long** · U30USD M5 (FTMO: US30.cash) | **ATT trial FTMO** (2,0%, long, `C01` r.49); SOSP piccolo; RES 100k (`C01` r.82) | 56 / 96 pos `CTR` r.64 | 1,22247 -> 1,27013 | DD ok (4,3941%), giorn. ? | **NO** | nd | ok (51,0x, `CEN` r.260) | **NO**: N |
| 4 | 770250 | Nasdaq Apertura **GatedShort** · NASUSD M15 (solo short) | SOSP piccolo (`SOSP` r.44) | 57 / 47 deal `RES` r.50 | 1,257 -> **0,948** | DD ok (3,63% OOS / 4,54% IS, taglia non dichiarata in `RES`; 4,54% @0,65% in `CEN` r.352), giorn. ? | **NO** | nd | **NO** (~37,2x, stima INFERITA, `CEN` r.352) | **NO**: N, 3 |
| 5 | 770260 | Nasdaq Apertura **RETEST** · US100.cash M5 (L+S) | **ATT trial FTMO** (2,0%, `C01` r.50) | 94 / 91 pos (`CTR` r.65) **oppure** 135/172 deal = 102 pos OOS (`ORB` r.47): **conteso** | 1,14498 -> 1,10936 (`CTR`) **oppure** 1,221 -> 1,215 (`ORB`) | DD ok (3,6753% @1% 10k `CTR`; 7,86% @2% 80k `ORB`), giorn. ? | **NO** | nd | ? | **NO**: N |
| 6 | 770402 | MaxMinNotte **oro** · XAUUSD M15 (preset H2 nel contratto; L+S) | **ATT piccolo** (0,5%, `C01` r.33) | n.d. / 93 pos (118 deal), **finestra piena, nessun OOS** `G3` r.29 | 1,453 (finestra piena) | **NO** (22 anni [B]: 19,72% @1% = 10,30% @0,5% vs 10,0% di contratto, `RES` r.113 e `CEN` r.302) | **NO** (93; nessun OOS) | nd | ok (126,5x, `CEN` r.302) | **NO**: R, N |
| 7 | 770411 | MaxMinNotte **DAX short** · D30EUR M15 (FTMO: GER40.cash M30) | **ATT trial FTMO** (2,0%, short, `C01` r.54); SOSP piccolo; RES 100k (`C01` r.83) | IS n.m. (forbice 9-20) / **14 pos** (21 deal) `CTR` r.66 | 1,87803 -> 2,15985 | DD ok (1,9213%), giorn. ? | **NO** (14) | nd | ? | **NO**: N |
| 8 | 770511 | SuperWave **Dow H1** · U30USD H1 (L+S) | **ATT trial FTMO** (2,0%, `C01` r.51); SOSP piccolo | 84 / 143 deal (o 72/131): pos **n.m., forbice 62-143** `CTR` r.67 | 1,84892 -> 1,32770 **oppure** 1,48166 -> 1,24312 (**contratto CONTESO**) | DD ok (3,9082-4,1675% @1% 10k), giorn. ? | **NO** (forbice <= 143) | nd | **NO** (38,5x; minima gamba 6,3x < duro 13,3x, `CEN` r.317) | **NO**: N, 3 |
| 9 | 770531 | SuperWave **Dow H2** · U30USD H2 (tolta) | SOSP piccolo | 32 deal / **50 pos** (88 deal) `G2` r.41 | 5,571 -> 1,762 | DD ok (4,27% CSV; 2,96% censimento: **non riconciliati**), giorn. ? | **NO** | nd | ok (147,8x, `CEN` r.306) | **NO**: N |
| 10 | 770611 | ORB_Ottimizzato **Dow** · U30USD M5 (solo long) | SOSP piccolo; RES 100k (`C01` r.85) | 71 / 119 pos (invariante in 48 celle) `ORB` r.53 | 1,250 -> 1,674 | **al limite**: 9,76% OOS (muro 10%), **10,34% con slippage 1,5 pt** (`CEN` r.247), giorn. ? | **NO** | nd | **NO** (29,5x, `CEN` r.216) | **NO**: N, 3 (R sul filo) |
| 11 | 770621 | ORB_Ottimizzato **Dow, copia di prova** · US30.cash M5 (solo long, 0,3%) | **ATT trial FTMO** (`C01` r.57) | contratto = quello della riga 10 (`copia di prova 770621`, `APERTURE_DOW_MAPPA` r.68): 71 / 119 pos | 1,250 -> 1,674 (riga 10) | idem riga 10 | **NO** | nd | **NO** (29,5x, riga 10) | **NO**: N, 3 |
| 12 | 770901 | SupertrendReversal **Nikkei** · 225JPY H2 (L+S) | RES sul 100k (`C01` r.84); rimossa dal grafico il 25/09 13:14 (`SOSP` r.96; salvataggio del profilo: da confermare) | 29 / 50 deal `G5` r.76 | 1,542 -> 1,653 | DD ok (0,65-0,88% @1% 100k), giorn. ? | **NO** | nd | **NO** (13,6x: sotto 40x, sopra il duro 13,3x di 0,3, `CEN` r.263) | **NO**: N, 3 |
| 13 | 770924 | SupertrendReversal **Nikkei FW** · 225JPY H2 (long) | SOSP piccolo | 30 / 26 deal `G5` r.77 (che la scrive H4; `CEN` r.301 e `SOSP` H2); contratto: **finestra piena, nessun OOS**, n 21 `CEN` r.301 | 1,356 -> 1,621 | DD ok (0,14% contratto), giorn. ? | **NO** | nd | **NO** (13,6x, `CEN` r.301) | **NO**: N, 3 |
| 14 | 771201 | PostNews **ECB** · EURJPY M5 | **ATT piccolo** (1,3%, `C01` r.37) | **nessuno** (CSV con `Trades = 0`, `CTR` r.69-71) | **n.m.** | ? (nessun DD mai misurato, `CEN` r.353) | ? | nd | **NO** (62,5x -> 21,9x all-in; 13,2x dopo il trailing, **sotto il duro 13,3x**, `CEN` r.353) | **NO**: 3 |
| 15 | 771202 | PostNews **FOMC** · EURUSD M5 | **ATT piccolo** (1,3%, `C01` r.38) | nessuno | n.m. | ? | ? | nd | **NO** (62,5x -> 28,9x; 17,4x dopo trail, `CEN` r.354) | **NO**: 3 |
| 16 | 771203 | PostNews **NFP** · USDJPY M5 | **ATT piccolo** (1,3%, `C01` r.36) | nessuno | n.m. | ? | ? | nd | **NO** (83,3x -> 26,8x; 16,1x dopo trail, `CEN` r.355) | **NO**: 3 |
| 17 | 771321 | PTE · U30USD H1 | SOSP piccolo | IS n.m. / **23 pos** (40 deal) `G3` r.48 | 1,178 -> 1,171 | DD ok (3,22% CSV; 2,18% contratto: **non riconciliati**, `G3` r.101), giorn. ? | **NO** | nd | **NO** (32,5x [INF], `CEN` r.303) | **NO**: N, 3 |
| 18 | 771322 | PTE (duello) · GBPUSD H1 (L+S) | **ATT piccolo** (0,5%, `C01` r.32) | 20 deal / **27 pos** (49 deal) `G3` r.46 | 40,98 (IS su 20 deal) -> 1,378 | **NO** (13 anni [B] 17,68% @1%, PF 0,972; contratto **CONTESO** 2,64 / 13,1 / 17,68%, `CEN` r.304) | **NO** | nd | ? | **NO**: R, N |
| 19 | 772161 | BreakingBand · GBPUSD H1 | **ATT piccolo** (1,0%, `C01` r.16) | 13 / **26 pos** `G4` r.32 | 2,736 -> 1,748 | **NO** (27,5 anni [B]: 23,43% @1%, PF 0,897, n 522, `G4` r.40); OOS tick 3,40% | **NO** | nd | ? | **NO**: R, N |
| 20 | 772162 | BreakingBand · EURUSD H1 | **ATT piccolo** (1,0%, `C01` r.17) | 4 / **13 pos** `G4` r.33 | 53,78 (IS su n 4) -> 3,870 | DD ok (1,2%; 27,5 anni [B] 8,24%), giorn. ? | **NO** | nd | **NO** (55,2x -> 25,6x all-in, `CEN` r.329) | **NO**: N, 3 |
| 21 | 772163 | BreakingBand · AUDUSD H1 | **ATT piccolo** (1,0%, `C01` r.18) | 5 / **11 pos** `G4` r.34 | 47,99 (IS su n 5) -> 2,756 | DD ok (1,2%; 27,5 anni [B] 8,97%), giorn. ? | **NO** | nd | ? | **NO**: N |
| 22 | 772231 | GapFill · GBPUSD H1 | **ATT piccolo** (1,0%, `C01` r.19) | 3-5 / **8 pos** `G4` r.64 | IS 1,34 / 1,62 / 1,63 (nell'ordine AUD, GBP, EUR della fonte; mappatura per sedia INFERITA) -> **5,026** | DD ok (2,4% WF; 1,0% 100k, `CEN` r.331), giorn. ? | **NO** | nd | ? | **NO**: N |
| 23 | 772232 | GapFill · EURUSD H1 | **ATT piccolo** (`C01` r.20) | 3-5 / **9 pos** | idem -> **2,740** | DD ok (1,5% WF; 1,0%, `CEN` r.332), giorn. ? | **NO** | nd | ? | **NO**: N |
| 24 | 772233 | GapFill · AUDUSD H1 | **ATT piccolo** (`C01` r.21) | 3-5 / **12 pos** | idem -> **2,890** | DD ok (1,9% WF; 1,0%, `CEN` r.333), giorn. ? | **NO** | nd | ? | **NO**: N |
| 25 | 772234 | GapFill · U30USD H1 | SOSP piccolo | 10 / **20 pos** `G4` r.65 | 1,627 -> 1,301 | DD ok (2,3%, `CEN` r.334), giorn. ? | **NO** | nd | **NO** (35,0x, `CEN` r.334) | **NO**: N, 3 |
| 26 | 772235 | GapFill · 225JPY H1 | SOSP piccolo | 11 / **15 pos** `G4` r.65 | 3,183 -> 1,137 | DD ok (4,3%, `CEN` r.335), giorn. ? | **NO** | nd | ? | **NO**: N |
| 27 | 772341 | PunteLarry · U30USD H1 (L+S) | SOSP piccolo | 16 / **38 pos** `G4` r.75 | 1,724 -> 1,784 | DD ok (3,87%; 21 mesi [B] 3,96%), giorn. ? | **NO** | nd | ok (105,4x, `CEN` r.336) | **NO**: N |
| 28 | 772342 | PunteLarry · EURAUD H1 (L+S) | **ATT piccolo** (0,5%, `C01` r.22) | 20 / **33 pos** `G4` r.76 | 2,135 -> 1,741 | **NO** (6,5 anni [B] 17,1% @1%, PF 1,05, n 216, `G4` r.82, `CEN` r.337) | **NO** | nd | ? (<= 54,6x condizionato) | **NO**: R, N |
| 29 | 772343 | PunteLarry · XAUUSD H1 (solo long) | **ATT piccolo** (0,3%, `C01` r.23) | n.m. / **11 pos** `G4` r.77 | n.m. -> 4,233 | **NO** (22 anni [B] 29,74% @1%, **PF 0,872, sotto 1 in 14 prove su 14**, `RES` r.51) | **NO** | nd | ok (236,2x, `CEN` r.338) | **NO**: R, N |
| 30 | 772344 | PunteLarry · GBPJPY H1 (solo long) | **ATT piccolo** (1,0%, `C01` r.24) | 18 / **20 pos** `G4` r.78 | 1,301 -> 2,003 | DD ok (2,70%; 6,5 anni [B] 8,95%), giorn. ? | **NO** | nd | ? (<= 68,8x condizionato) | **NO**: N |
| 31 | 772345 | PunteLarry · GBPUSD H1 (solo short) | **ATT piccolo** (1,0%, `C01` r.25) | 11 / **25 pos** `G4` r.79 | 1,938 -> 1,841 | DD ok (5,10%; 6,5 anni [B] 8,5%), giorn. ? | **NO** | nd | ? | **NO**: N |
| 32 | 772346 | PunteLarry · EURCAD H1 (solo long) | **ATT piccolo** (1,0%, `C01` r.26) | 15 / **19 pos** `G4` r.80 | 1,084 -> 1,252 | DD ok (4,77%; 6,5 anni [B] 6,96%), giorn. ? | **NO** | nd | ? | **NO**: N |
| 33 | 772361 | CostToCost · EURJPY H4 (solo long) | **ATT piccolo** (0,65%, `C01` r.27) | 48 / **64 pos** (WF, `G4` r.43); contratto: 394 pos **finestra piena, nessun OOS** | 1,026 -> 1,740 | **NO** (12,26% e giornata -8,02% su 2020-2026 [B]; contratto 12,3% @1%, `G4` r.44, `CEN` r.342) | **NO** | nd | **NO** (73,0x -> 25,6x all-in, `CEN` r.342) | **NO**: R, N, 3 |
| 34 | 772362 | CostToCost · GBPCAD H4 (solo long) | **ATT piccolo** (0,25%, `C01` r.28) | 44 / **62 pos** (WF, `G4` r.49) | 1,298 -> 1,442 | **NO** (6,5 anni [B] 41,5% @1%, PF 0,92, n 382, `CEN` r.343) | **NO** | nd | **NO** (32,4x -> 20,0x all-in, `CEN` r.343) | **NO**: R, N, 3 |
| 35 | 772421 | EasyTrend · CHFJPY H1 (L+S) | **ATT piccolo** (0,3%, `C01` r.29) | 31 / **53 pos** `G4` r.54 | 1,157 -> 1,248 | **NO** (6,5 anni [B] 21,8% @1%, PF 1,07, `G4` r.60) | **NO** | nd | ? (<= 58,4x condizionato) | **NO**: R, N |
| 36 | 772422 | EasyTrend · GBPUSD H1 (L+S) | **ATT piccolo** (0,5%, `C01` r.30) | 26 / **41 pos** `G4` r.55 | 1,258 -> 1,492 | **NO** (6,5 anni [B] 15,77% @1%, PF 1,059, `G4` r.60) | **NO** | nd | ok (175,0x -> 47,3x all-in: regge, margine +18%, `CEN` r.344) | **NO**: R, N |
| 37 | 772700 | Bulge v5.20 viola + BLU · GBPUSD H4 (22 cross) | **ATT piccolo** (0,8% x Max_Trades 4, `PIA` r.44; `C01` r.40) | pool 221 segnali, **nessuno split IS/OOS** (`BUL` §0 punto 1); riga diagnostica R92BAB `G3` r.59 | PF(r) **0,72** (pool) | **NO** (DD 13,7 / 22,8% [B] su 4 mesi, 0,80% 10k, `G3` r.59) | ? (nessun OOS) | nd (il PF e' "un numero, non un verdetto", `G3` r.59) | ? | **NO**: R |
| 38 | 772720 | Bulge **viola** · AUDNZD M15 | **ATT trial FTMO** (`C01` r.58) | stesso pool della riga 37 | PF(r) 0,72 (pool) | **NO** (come riga 37) | ? | nd | ? | **NO**: R |
| 39 | 774101 | GapContinuation · 225JPY M1 (L+S) | SOSP piccolo | IS tick n.m. / **70 deal** (30-70 pos, unita' non riconciliata) `G4` r.70 | n.m. -> 1,398 | **NO** (DD 11,59% @1%; 7,53% a 0,65% DERIVATO) | **NO** | nd | **NO** (13,7x, `CEN` r.346) | **NO**: R, N, 3 |
| 40 | 970901 | SupertrendReversal_Ott. · XAUUSD H4 (L+S) | **ATT piccolo** (1,0%, `C01` r.35) | 22 / **30 deal** `G5` r.41 | 4,752 -> 2,253 (picco) | DD ok (22 anni [B] 9,02% @1%: **0,98 punti** sotto il muro, `G5` r.251) | **NO** | nd | ok (~135,7x [INF], `CEN` r.314) | **NO**: N |
| 41 | 970912 | SupRev **DAX H4** · D30EUR H4 | SOSP piccolo (`SOSP` r.41); `C01` non la elenca fra le 26. Nel 05/10 `G5` r.303 la diceva ancora "in campo, 0 operazioni" | 26 / **60 deal** `G5` r.44 | 4,302 -> 1,525 | DD ok (4,04-4,2%), giorn. ? | **NO** | nd | ? (27,8-184x NON MISURATO) | **NO**: N |
| 42 | 970913 | SupRev **Nasdaq H1** · NASUSD H1 | SOSP piccolo | 69 / **86 deal** `G5` r.45 | 1,342 -> 1,688 | DD ok (0,86-1,29%), giorn. ? | **NO** | nd | **NO** (28,7x, `CEN` r.316) | **NO**: N, 3 |
| 43 | 971501 | EMA200_Ottimizzato · **XAUUSD H4** (cella del contratto) | non in campo su XAUUSD: oggi la sedia e' su AUDCHF (riga 49) | 39 / **67 deal** `G2` r.37 | 0,658 -> 1,495 | **NO** (22 anni [B] **45,91% @1%** vs 4,40% promesso; "prop: NO a nessuna taglia", firma 23/08) | **NO** | nd | ok (162,4x, `CEN` r.313) | **NO**: R, N |

### 3.4 Verdetto NON MISURABILE, con n OOS >= 150 (PF OOS decrescente): 2 righe

| # | magic | sedia | dove oggi | n IS / n OOS | PF IS -> OOS | R | N | 0 | 3 | verdetto: cosa manca |
|--:|---|---|---|---|---|---|---|---|---|---|
| 44 | 771531 | **EMA200 Dow** · U30USD H1 (L+S) | **in nessun profilo salvato**; via dal piccolo fra le sonde del 23/09 e del 24/09 (chi l'ha tolta: NON TROVATO); non sulla trial; il binario sul disco del piccolo e' `344a11b` (487 righe, zero `InpUsaGuardian`) (`MEMA` r.19, r.26-27) | **132 dichiarato (non ricontabile dal repo) / 257 pos** (237 / 517 deal) FATTO `MEMA` r.13, `CTR` r.68 | 1,20110 -> **1,52365** | ok (DD 7,8323% @1%, 100k, tick; giornata -2,45% chiusi / -1,98% equity, pavimento dei soli chiusi, `DOS` r.226) | **?** (OOS 257 ok; IS 132 dichiarato < 150, forbice 103-237; **NO se vale il 132**) | ok (IS 1,2011 >= 1,10) | **?** (4 convenzioni non riconciliate: 28,7x campo / 30,0-33,9x / 40,0-45,2x / 54,9x, `MEMA` r.76-78) | **NON MISURABILE**: IS in posizioni; convenzione del costo |
| 45 | 774500 | **Azzurra** · EURGBP H1 (33 simboli: 22 cross + oro + 10 indici) | **ATT piccolo** dal 09/10 16:39 (0,80% x 4, `C01` r.43; `PIA` r.45) | **527 / 259 Trades**, unita' non dichiarata, **Modello 1 (barre)**, OOS 01/07-09/10 (`AZF`, tab. frequenza) | IS 0,961 -> OOS **0,836** (cella D0) | ? (DD D0 NON TROVATO; C0 54,7% nella cella "ritracciamento spento") | ? (259 Trades, unita' non dichiarata, su barre) | ? (PF 0,836 < 1,10 su barre: screening, "non boccia") | ? | **NON MISURABILE**: nessun tick, nessun DD |

### 3.5 Verdetto NON MISURABILE, campione sottile / senza misura (magic crescente): 4 righe

| # | magic | sedia | dove oggi | n IS / n OOS | PF IS -> OOS | R | N | 0 | 3 | verdetto: cosa manca |
|--:|---|---|---|---|---|---|---|---|---|---|
| 46 | 770611 | ORB_Ottimizzato · **XAGUSD H4** (solo long, 1,0%) | **ATT piccolo** (`C01` r.41); comparsa fra le sonde del 06/10 e del 07/10 | **NON TROVATO** | **NON TROVATO** | ? | ? | ? | ? (costo sull'argento NON MISURATO, `PIA` r.125) | **NON MISURABILE**: nessuna misura su XAGUSD (`PIA` r.122) |
| 47 | 770611 | ORB_Ottimizzato · **EURAUD H1** (solo long, 1,0%) | **ATT reale `10105439`** (`C01` r.99) | **nessuna misura** (`ORB` r.55) | nessuna | ? | ? | ? | ? | **NON MISURABILE**: mai testata; livelli a +10,0 in prezzo, **zero riempimenti**, 0 EUR (`EUR` §0 punti 1-2) |
| 48 | 771332 | PTE candidata B25 · GBPUSD H1 (L+S) | **ATT piccolo** (0,5%, `C01` r.31) | 477 pos [B] 13 anni, **finestra piena** (forbice 206-477), nessun OOS; **zero operazioni in tutto il file** `CEN` r.305/`G3` r.199 | 1,095 (13 anni [B]) | ? (9,87% @1% su barre = limite inferiore, a 0,13 dal muro) | ? | ? | ? | **NON MISURABILE**: nessun OOS, nessun tick; e' attaccata? M-C9 (`CEN` r.522) |
| 49 | 971501 | EMA200_Ottimizzato · **AUDCHF H4** (0,25%, L+S) | **ATT piccolo** (`C01` r.34) | **NON TROVATO** | **NON TROVATO** | ? | ? | ? | ? | **NON MISURABILE**: nessuna misura su AUDCHF (`PIA` r.142) |

**Conteggio di controllo** (FATTO, contato sulle righe): SI **0** · NO **43** (righe 1-43) · NON MISURABILE **6** (righe 44-49) = **49**. Righe con n OOS >= 150 posizioni misurato: **4** (righe 1, 2, 44 e 45, la 45 a barre); le altre **45** hanno n OOS < 150, oppure finestra piena senza OOS, oppure n non trovato.

---

## 4. TABELLA 2 — DD promesso, frequenza, regime, classe

Colonne: **DD OOS** a taglia e deposito dichiarati · **DD promesso alla taglia in campo** (dove la fonte lo scrive: `CTR` per FTMO a 2,00%, `CEN` per piccolo/reale; "lineare" = metro di casa approssimato, `CEN` r.80-84, forbice 0,28-6%) · **freq. promessa vs vista** (op/giorno; "vista" = la finestra scritta) · **regime** · **classe G2** (A: n OOS >= 150 + OOS vero + >= 2 regimi; B: n >= 150, un regime; C: 30-149; D: < 30, `G2` r.13).

| # | magic | DD OOS @ taglia, deposito (modello) | DD promesso alla taglia in campo | freq. promessa -> vista (finestra) | regime in cui e' misurata | classe G2 |
|--:|---|---|---|---|---|---|
| 1 | 770101 | 7,2328% @1%, 100k, tick (IS 5,4362%) `CTR` r.63 | 14,47% @2,00% FTMO (`CTR`); 4,3501% @0,65% su dep. **10.000** `[T]` (a 100k NON MISURATO, `CEN` r.226-229) | 0,699 (`CTR`) / ~0,60 pos (`CEN` r.215) -> 0,54 (piccolo 25/08-10/09, `CEN` r.297); famiglia Aperture 1,660 (`PNP` r.247) | **UN solo regime (rialzo 2024-26)**; orologio mescolato (PF 1,27 n144 allineati / 1,48 n126 sfasati, `ORB` r.76) | B (`RES` r.34) |
| 2 | 770105 | 12,3052% @1%, 100k, tick (IS 7,4732%) `DAXM` r.52 | 24,6% @2,00% DERIVATO lineare (12,3052 x 2) | NON TROVATO | un solo regime; stagione: estate 96 pos PF 1,390 / inverno 85 pos PF 0,899 (`DAXM` r.53) | n.m. (bocciata per rischio e merito, `ORB` r.42) |
| 3 | 770202 | 4,3941% @1%, 100k, tick (IS 5,6692%) `CTR` r.64 | 8,79% @2,00% (`CTR`) | 0,348 -> **0,08** (1 pos in 13 giornate, p 0,018, `CEN` r.260) | un solo regime; feed Dow: IS LATERALE (provv.) / OOS TORO (`REG` r.10-11); orologio: PF 0,78 n73 allineati / 1,66 n57 sfasati (`ORB` r.87) | C (96 pos) |
| 4 | 770250 | 3,63% (IS 4,54%) `RES` r.50; 4,54% @0,65% finestra intera (`CEN` r.352) | ~2,4% @0,35% lineare (`CEN` r.352) | ~0,23 -> **0** dal deploy 30/08 (`CEN` r.352) | un solo regime (toro 21 mesi); verdetto orso solo OHLC | C (derivata da 47 deal) |
| 5 | 770260 | 3,6753% @1%, 10k (IS 5,9528%) `CTR` r.65; 7,86% @2%, 80k (`ORB` r.47) | 7,35% @2,00% (`CTR`) | 0,360 -> NON TROVATO | un solo regime (21 mesi) | C (`RES` r.36) |
| 6 | 770402 | 2,34% @0,5%, 100k, tick, finestra piena (`RES` r.41); 22 anni [B]: 19,72% @1% | ~10,0% @0,5% (firma 23/08) | ~0,17 -> **0,46** (25/08-10/09, 270%, `CEN` r.302) | tick 2 anni (toro); barre 6,5 anni: toro 2020, laterale 2021-22, toro 2023-26, PF per regime NON separato (`G3` r.28) | C (93 pos, `G3`) |
| 7 | 770411 | 1,9213% @1%, 100k (IS 3,0977%) `CTR` r.66 | 3,84% @2,00% (`CTR`) | 0,051 -> 0,15 (piccolo, `CEN` r.300) / **0,43** (challenge, 3 pos in 7 gg, `8GG` r.17) | un solo regime | D (14 pos, derivata) |
| 8 | 770511 | 3,9082-4,1675% @1%, 10k; 4,2149% a 100k (`CTR` r.67) | 7,82-8,34% @2,00% (`CTR`) | 0,518 deal (~0,294 pos STIMATO) -> 0,62 (124%, `CEN` r.317) | un solo regime; nessuna finestra oraria (`CTR` r.83) | n.m. (CONTESA, `G2` r.44) |
| 9 | 770531 | 4,27% CSV / 2,96% censimento (non riconciliati) `G2` r.41 | NON TROVATO | ~0,18 -> 0,62 (344%, `CEN` r.306) | un solo regime; stagione PF 5,83 (42 deal) / 1,23 (46) [DICHIARATO] | C |
| 10 | 770611 Dow | 9,76% @1%, 100k (IS 7,89%) `G2` r.51; 9,92% @1% 10k R15; 10,34% con slippage (`CEN` r.247) | 6,5389% @0,65% (reale, `CEN` r.216); 2,98% @0,30% (`CEN` r.261) | ~0,43 -> 0,23 (piccolo, 54%, `CEN` r.299) | un solo regime; feed Dow IS LATERALE provv. / OOS TORO (`REG`) | C (119 pos) |
| 11 | 770621 | come riga 10 | NON TROVATO per 0,3% su FTMO | NON TROVATO | idem riga 10; range 16:30-16:45 (`DECISIONE_OROLOGIO...` r.49) | C (riga 10) |
| 12 | 770901 | 0,88% @1%, 100k (R5); 0,65% (R16) `CEN` r.263 | ~0,57% @0,65% | ~0,18 -> NON MISURATO (100k senza export, `CEN` r.263) | un solo regime | D/C (`G5` r.76) |
| 13 | 770924 | 0,14% @1%, finestra piena (`CEN` r.301) | NON TROVATO | ~0,046 -> 0,15 (`CEN` r.301) | un solo regime | D |
| 14 | 771201 | **nessuno** | **nessuno** (tetto aritmetico) | 0,03-0,05 (calendario) -> 0,08 (1 pos) | nessuna misura | n.m. |
| 15 | 771202 | nessuno | nessuno | 0,03 -> 0 | nessuna | n.m. |
| 16 | 771203 | nessuno | nessuno | 0,05 -> 0,08 (1 pos) | nessuna | n.m. |
| 17 | 771321 | 3,22% CSV / 2,18% contratto (non riconciliati) `G3` r.101 | NON TROVATO | ~0,09 pos -> 0,08 (`CEN` r.303) | un solo regime | D (23 pos) |
| 18 | 771322 | contratto conteso: 2,64% (R23, tick) / 13,1% (R103 [B]) / 17,68% (R78 [B]) @1% `CEN` r.304 | NON TROVATO | ~0,10 pos -> **0** (ultima op. 14/08) | tick 1 regime; 13 anni [B] PF 0,972; GBPUSD orso 2022 feed generato 0,75 (`consolidato` r.144) | D (27 pos) |
| 19 | 772161 | 3,40% WF 10k / 1,9% 100k `CEN` r.328 | 1,9% @1% (R34) | ~0,092 -> 0,08 (84%, `CEN` r.328) | tick 1 regime; barre 27,5 anni DD 23,43% | D (`G4` r.32) |
| 20 | 772162 | 1,2% `CEN` r.329 | NON TROVATO | ~0,046 -> 0,08 (167%) | 1 regime | D |
| 21 | 772163 | 1,2% `CEN` r.330 | NON TROVATO | ~0,037 -> 0,08 (208%) | 1 regime | D |
| 22 | 772231 | 2,4% WF / 1,0% 100k `CEN` r.331 | NON TROVATO | ~0,028 -> **0** (`CEN` r.331) | 1 regime; **0 operazioni nelle epoche 2020-2023** (`G4` r.64) | D |
| 23 | 772232 | 1,5% / 1,0% `CEN` r.332 | NON TROVATO | ~0,032 -> 0 | idem | D |
| 24 | 772233 | 1,9% / 1,0% `CEN` r.333 | NON TROVATO | ~0,041 -> 0 | idem | D |
| 25 | 772234 | 2,3% `CEN` r.334 | NON TROVATO | ~0,069 -> 0,08 (111%) | 1 regime | D |
| 26 | 772235 | 4,3% `CEN` r.335 | NON TROVATO | ~0,055 -> 0,08 (140%) | 1 regime | D |
| 27 | 772341 | 3,87% (21 mesi [B] 3,96%) `G4` r.75 | NON TROVATO | ~0,134 -> 0,31 (230%, `CEN` r.336) | 1 regime | C (38 pos) |
| 28 | 772342 | 3,72% `G4` r.76 | 8,6% @0,5% (da 17,1% @1%, `CEN` r.337) | ~0,115 -> 0,23 (200%) | tick 1 regime; barre 6,5 anni: 3/7 anni negativi | C (33 pos) |
| 29 | 772343 | 22 anni [B] 29,74% @1% | 9,0% @0,3% lineare (`CEN` r.338) | ~0,037 -> 0,08 (208%) | barre 22 anni PF 0,872; tick toro oro | D (11 pos) |
| 30 | 772344 | 2,70% `G4` r.78 | NON TROVATO | ~0,069 -> 0,08 | 1 regime; il lato long e' l'edge (short 0,108) | D (20 pos) |
| 31 | 772345 | 5,10% `G4` r.79 | NON TROVATO | ~0,088 -> 0,08 (87%) | 1 regime | D (25 pos) |
| 32 | 772346 | 4,77% `G4` r.80 | NON TROVATO | ~0,069 -> 0 | 1 regime | D (19 pos) |
| 33 | 772361 | 9,33% WF 10k / 9,45% 100k `G4` r.43; R127c [B] 12,26% (giornata -8,02%) | 8,0% @0,65% (da 12,3% @1%, `CEN` r.342) | ~0,217 -> 0,15 (69%) | **4 regimi `_EXT` misurati su campioni 23-67**: crollo puro feb-apr 2020 PF **0,025** (n23, DD 14,83%), orso 2022 2,654 (n43) (`G4` r.45) | C (64 pos) |
| 34 | 772362 | 6,19% WF `G4` r.49 | 10,4% @0,25% (da 41,5% @1%, `CEN` r.343) | ~0,212 -> 0,15 (73%) | regimi `_EXT`: toro 1,238, orso 0,611, laterale 0,852, crollo-anno 0,966 | C (62 pos) |
| 35 | 772421 | 6,27% (WF) `G4` r.54 | 6,5% @0,3% (da 21,8% @1%, `CEN` r.345) | ~0,175 -> 0,08 (44%) | 1 regime; `_EXT`: nessuno tiene orso e crollo (`G4` r.62) | C (53 pos) |
| 36 | 772422 | 4,58% (WF) `G4` r.55 | 7,9% @0,5% (da 15,8% @1%, `CEN` r.344) | ~0,134 -> 0,15 (115%) | idem; crollo 2020 0,391 | C (41 pos) |
| 37 | 772700 | 13,7 / 22,8% [B] 0,80% 10k, 4 mesi (`G3` r.59) | NON TROVATO (`PIA` r.271) | backtest 4,6/g (R92BAB, 190 VIOLA in 41 gg) e 5,5/g (piccolo v5.20) -> forward 66 pos dal 30/09 al 09/10 (`BUL` §0 punto 11; `PIA` r.137) | 1 regime (4 mesi 2026 [B]) | n.m. (riga diagnostica) |
| 38 | 772720 | come riga 37 | NON TROVATO | come riga 37 | come riga 37 | n.m. |
| 39 | 774101 | 11,59% @1%, 100k, tick (`G4` r.70) | 7,53% @0,65% DERIVATO | ~0,17 -> 0,08 (47%, `CEN` r.346) | 1 regime; cella = picco; lato short perde (-2.182) | C (70 deal) |
| 40 | 970901 | 0,79% IS / 2,08% OOS (rischio 2% nel CSV) `G5` r.41 | 9,02% @1% 22 anni [B] (R99) | ~0,115 -> 0,08 (70%, `CEN` r.314) | tick: rialzo oro 2024-26; 22 anni [B]: IS 2004-13 sotto 1, OOS 2013-26 sopra (segno invertito) | D |
| 41 | 970912 | 4,04-4,2% `G5` r.44 | NON TROVATO | ~0,18 -> 0 | 1 regime | D/C |
| 42 | 970913 | 0,86-1,29% `G5` r.45 | NON TROVATO | ~0,34 -> 0,15 (45%, `CEN` r.316) | tick 1 regime; `[B]` 2011-2022: laterale 2015-16 PF 0,664 (n55) | C |
| 43 | 971501 XAU | IS 2,20% / OOS 4,49% (tick, `G2` r.37); 22 anni [B] 45,91% | 11,5% @0,25% (firma 23/08) | ~0,30 -> 0,38 (127%, `CEN` r.313) | tick: rialzo oro; IS invertito su 9 TF su 9 | C (67 deal) |
| 44 | 771531 | **7,8323% @1%, 100k, tick** (IS 5,7325%) `MEMA` r.13 | 5,09% @0,65% lineare; 7,83% @1,0%; 15,66% @2,00% (`MEMA` r.51: lineare, sovrastima salendo) | 0,945 gambe (0,58 segnali) -> 0,85 (25/08-10/09, 55% in uscite / 110% in pos, `CEN` r.312); G2 r.153: 1,00 contro 0,93 (**due fonti, uso la prudente**); famiglia EMA200 1,850 (`PNP` r.246) | **IS LATERALE provvisorio con calo 18,46% in 66 giorni (picco 2025-01-31, fondo 2025-04-07); OOS TORO** (`REG` r.10-11); regola DK non firmata; **resto NON MISURATO** | **B** (`G2` r.23) |
| 45 | 774500 | NON TROVATO (D0); cella "ritracciamento spento" 54,7% | NON TROVATO | ~3,4-3,5 aperture/g attese -> **0** il 09/10 (P(0) 35-37%, `AZF`) | 1 regime (barre); 9 simboli su 11 non-FX a 0 aperture (`AZF`, cecita' per classe) | n.m. (Modello 1) |
| 46 | 770611 XAG | NON TROVATO | NON TROVATO (`PIA` r.271) | NON TROVATO | NON TROVATO | n.m. |
| 47 | 770611 EURAUD | nessuna misura | nessuna | n.m. | n.m. | n.m. |
| 48 | 771332 | 9,87% @1%, 13 anni [B] OHLC `CEN` r.305 | ~4,94% @0,5% (da 9,87%) | ~0,14 -> **0 in tutto il file** (30/03-10/09, `CEN` r.305) | barre 13 anni, finestra piena | n.m. |
| 49 | 971501 AUDCHF | NON TROVATO | NON TROVATO | NON TROVATO | NON TROVATO | n.m. |

---

## 5. TABELLA 3 — forward, certificato di morte, note

**Forward**: n = posizioni chiuse, netto in EUR, dove, finestra. Il forward **non decide il merito sotto 20 operazioni di famiglia** (`CLAUDE.md`, criterio del 18/08). I 4 posti di forward sono diversi e **non si sommano**: **piccolo** `50503392` (`TA`/`PIA`/`G4`), **challenge FTMO** `541452707` (22/09-30/09, chiusa), **trial FTMO** `1514806751` (01-09/10, `TRS`), 100k/reale (nessun export, `CEN` r.162).
**Certificato di morte** (09/09): le 5 caselle = (1) PF, (2) n e DD, (3) uscita ad asse, (4) gemelli, (5) TF. **Nessuna riga di questa tabella e' MORTA** (`RES` r.19): dove ne manca una il verdetto e' "NON ANCORA MISURATO". La colonna dice **quali mancano**.

| # | magic | forward (n, netto, dove, finestra) | caselle del certificato che MANCANO | note: conflitti, binario in campo, magic |
|--:|---|---|---|---|
| 1 | 770101 | piccolo: **40 pos, -483,85, PF 0,45**, 20/07-22/09 (39 D30EUR + 1 NASUSD, `PIA` r.104). Challenge: 5 pos DAX Apertura (770101 buy + 770105 sell) **-1.258,07**, 22-30/09 (`8GG` r.10). Trial: **0** (INFERITO: nessuna riga "RETEST BUY" in `TRS` r.15-26) | (4) gemelli e (5) TF **parziali** (`ORB` r.41); conflitto: `RES` r.34 scrive F40EUR 1,440 -> 0,770, `ORB` r.74 scrive F40/E50/E35 "MAI provati" (**NON RICONCILIATO**) | binario piccolo: `ABTG_DAX_Apertura_EU` 2191 righe del 08/08 senza Guardian, HEAD 2886 (`PIA` r.61). Dipende dall'ora: dal 26/10 un'ora prima della cash (`PIA` r.194). Il 100k non ha nessun `.set` della sedia e il default dell'EA ha il corto **acceso** (`CEN` r.259, M-C12). Il 4,3501% e' a dep. 10.000 |
| 2 | 770105 | trial: **3 pos, 1 vinta, -6.059,66** (01-09/10, `TRS` r.17). Challenge: vedi riga 1 | (4) gemelli e (5) TF parziali (`ORB` r.42) | nel contratto FTMO **non c'e'** (la tavola `CTR` r.63-71 non la elenca); `AUDIT_RISCHIO_FLOTTA` r.146-147: _"coppia 770411+770105 fuori dal campo di misura del contratto"_. Doppio stop pieno il 01/10 (-6.403,00). Opposta alle sedie long DAX di altri conti: divieto FTMO fra conti (`PIA` r.159) |
| 3 | 770202 | piccolo: 4 righe **+0,35** (`PIA` r.105). Trial e challenge: **0** (challenge: `8GG` r.18; trial INFERITO da `TRS`) | (4) gemelli, (5) TF parziale (`ORB` r.44) | sulla trial **2,0%**; contratto a 1,00%. Il 40/40 OOS di `Dow_Apertura/` e' di un'altra sedia (`ORB` r.87). Orologio mescolato. Sul reale non c'e' |
| 4 | 770250 | piccolo: **2 righe +7,56** (`PIA` r.106) | (3) uscita, (4) gemelli, (5) TF parziale (`ORB` r.49) | `S-1` aperta: riaccenderla e' una domanda di Claudio (`RES` r.98). Il "1,097 su 104" era la finestra intera (`RES` r.125) |
| 5 | 770260 | trial: **0** (INFERITO, nessuna riga "Nasdaq" in `TRS`); challenge: **0** (`8GG` r.18) | (4) gemelli, (5) TF parziali (`ORB` r.47) | **due contratti** per la stessa sedia: PF OOS 1,10936 (`CTR`) contro 1,21546/1,215 (`ORB` §9 C1), banchi e celle diversi. Il PF 1,10936 sta a 0,009 dal C0 1,10 |
| 6 | 770402 | piccolo: **13 righe (4 buy, 9 sell), +60,40, PF 1,51** (`PIA` r.118); `G3` r.127: 12 trade 11/08-23/09 PF 1,86, lotto sempre 0,01 | NON TROVATO per casella (n e DD si, PF su finestra piena, nessun OOS) | rischio `.chr` 0,5; il preset del repo dice 1,0 (**NON RICONCILIATO**, `PIA` r.40, r.118). `RES` r.41 scrive "solo long", il `.chr` ha long e short (`PIA` r.118). Box 23:00-04:59 BCM, cade sul rollover d'inverno: effetto NON MISURATO |
| 7 | 770411 | piccolo: **5 pos, +155,78** (18/08-31/08, `G3` r.143). Challenge: **3 pos -2.236,00** (`8GG` r.9). Trial: **1 pos, -3.292,52** (`TRS` r.18) | (5) TF: solo M15; `R214g` scritto, mai girato (`G3` r.145) | frequenza di campo 10-14 volte la promessa (`G3` r.143, `8GG` r.17). Rischio 2,0% sulla trial |
| 8 | 770511 | piccolo: **16 righe, 10 vinte, +344,33** (`PIA` r.108). Trial: **2 pos, 2 vinte, +998,57** (`TRS` r.23) | (3) uscita: 7 file pronti, non girati (`G2` r.441) | contratto **CONTESO** fra due binari (26/07 `a4107cf` contro 19/09 `872dba82`), 41 input identici (`G2` r.273). Non legge l'ora (`CTR` r.83). Binario piccolo 564 righe, HEAD 775 |
| 9 | 770531 | piccolo: **14 righe, -41,68** (`PIA` r.111) | NON TROVATO | tolta il 25/09. DD CSV 4,27% contro 2,96% non riconciliati |
| 10 | 770611 Dow | ex-piccolo: **8 righe, -209,18, PF 0,27**, 11/08-03/09 (`PIA` r.109); `ORB` r.105: 3 vinte su 15, -295,58 | (3) parziale, (4) gemelli parziali (provati e negativi), (5) TF M5 ovunque (`ORB` r.53) | **magic condiviso**: stesso `770611` su piccolo (XAG), reale (EURAUD), 100k (Dow, residuo) (`PIA` r.123). Se l'ORB Dow tornasse sul piccolo avrebbe lo stesso magic dell'argento |
| 11 | 770621 | trial: **3 pos, 1 vinta, -914,57** ("ORB OTT FT BUY", 01-09/10, `TRS` r.21); `AUT` r.17: 1 pos -537,86 fino al 06/10 | come riga 10 | copia di prova di 770611 (`APERTURE_DOW_MAPPA` r.68): stesso EA, rischio 0,3% |
| 12 | 770901 | 100k: **5 righe, +17,96** (10/08-24/09, `G5` r.231) | (3) parziale (`G5`), (4) NON TROVATO per Nikkei | **collisione**: `770901` e' anche XAUUSD sul piccolo (3 righe -81,46, `G5` r.231): ogni P/L per magic va filtrato per conto e simbolo (`CEN` r.265-274, M-C8) |
| 13 | 770924 | piccolo: **5 righe, +2,79** (27/08-17/09, `G5` r.231) | (5) TF presente per nome; resto NON TROVATO | il contratto non ha OOS |
| 14 | 771201 | ECB 10/09: **1 pos, -83,22**, lotto 2,3x il contratto (1,49% invece di 0,65%: default compilato 3,0 contro 1,3 del pannello, `G3` r.235) | **tutte e 5** (0/5, `G3` r.237) | primo evento utile **28/10** (`G3` r.235). Rischio .chr 1,3% (la piu' alta del piccolo). Binario del 04/09 chiama il Guardian ma sul piccolo e' fail-open (`PIA` r.43) |
| 15 | 771202 | FOMC: **0** (`G3` r.235) | tutte e 5 | FOMC del 09/12 richiede un secondo F7 (`PIA` r.133) |
| 16 | 771203 | NFP: **1 pos, +37,36** (collaudo 04/09, `G3` r.235). Il piano elenca 3 righe totali PostNews (+37,36 / -83,22 / +142,82) senza mappare il +142,82 (`PIA` r.133): **mappatura NON TROVATA** | tutte e 5 | preset che punta a un calendario che finiva 2025.07.03 (`CTR` r.70), poi ricostruito il 02/10 (`G3` r.235) |
| 17 | 771321 | **1 pos short, +3,78** (03/09, `G3` r.199) | nessuna (certificato "completo ma su dato [B]", `G3` r.201) | sospesa. Contratto DD 2,18% contro CSV 3,22% |
| 18 | 771322 | PTE GBPUSD: **1 pos short +22,16** (14/08, `G3` r.199) (attribuzione a 771322 o 771332: **NON TROVATA**) | nessuna (certificato completo ma [B], `G3` r.201) | **due sedie PTE sullo stesso GBPUSD H1** (771322 e 771332): stesso conto, stesso simbolo (`PIA` r.39). Contratto conteso, la scelta e' di firma (tick lungo inesistente, `CEN` r.514-516) |
| 19 | 772161 | BreakingBand: forward piccolo 29/07-18/09, 4 pos totali **-19,24** (GBPUSD INV L +18,06, AUDUSD INV L +12,45, GBPUSD INV S +2,69, EURUSD CONT S -52,44; per magic: **NON TROVATO**, `G4` r.175) | (3) uscita **parziale**; M15 e M30 chiusi per misura, non morto (`G4` r.177) | 27,5 anni: REVISIONE rischio (DD 6,9-12,3x il promesso, `G4` r.177). Binario piccolo 1578 righe v1.02 senza Guardian, HEAD 1858 |
| 20 | 772162 | idem riga 19 (EURUSD CONT S -52,44) | idem | l'IS ha 4 trade; costo 55,2x -> 25,6x con la commissione |
| 21 | 772163 | idem (AUDUSD INV L +12,45) | idem | IS con 5 trade |
| 22 | 772231 | GapFill piccolo 29/07-18/09: 4 pos totali **-67,26** (GAP NIKKEI S +36,35 / L +1,47, GAP DOW L -50,70, GAP AUDUSD L -54,38; nessuna a nome 772231, `G4` r.239); `PIA` r.210: a 0 righe | (3) uscita, (5) TF (H1 e basta, `G4` r.241) | binario 791 righe, HEAD 806 |
| 23 | 772232 | 0 righe (`PIA` r.210) | idem | |
| 24 | 772233 | GAP AUDUSD L **-54,38** (29/07-18/09, `G4` r.239); `CEN` r.333: freq 0 in 25/08-10/09 | idem | l'attribuzione a 772233 e' per simbolo, non per magic (**INFERITO**) |
| 25 | 772234 | GAP Dow L **-50,70** (29/07-18/09, `G4` r.239; per simbolo, INFERITO) | idem | esclusa dal portafoglio R37 (cumulo del lunedi'); sospesa 25/09 "per una regola di compatibilita', non per merito" |
| 26 | 772235 | GAP NIKKEI S +36,35 / L +1,47 (29/07-18/09, `G4` r.239; per simbolo, INFERITO) | idem | il piu' tirato (PF 1,14 in `CEN` r.335) |
| 27 | 772341 | Larry piccolo 29/07-18/09: 14 pos totali **+23,10** (`G4` r.271); DOW L -49,20 / DOW S +5,19 (per simbolo, INFERITO) | (3) parziale, (5) TF H1 e basta (`G4` r.273) | sospesa 25/09 |
| 28 | 772342 | EURAUD S +8,64, L -41,17 (3 pos) (`G4` r.271; per simbolo) | idem | 3/7 anni negativi (`CEN` r.337) |
| 29 | 772343 | ORO L **+91,96** (2 pos) (`G4` r.271; per simbolo) | idem | **decisione S-6 (taglia o spegnimento) ancora aperta** (`RES` r.103); _"se il tagliando dei 6 mesi non la giustifica, spegnere"_ (`G4` r.273) |
| 30 | 772344 | GBPJPY L **-50,91** (`G4` r.271; per simbolo) | idem | il lato short di questa cella perde (0,108) |
| 31 | 772345 | GBPUSD S **+46,07** (`G4` r.271; per simbolo) | idem | |
| 32 | 772346 | EURCAD L **+12,52** (`G4` r.271; per simbolo) | idem | il piu' tirato (PF 1,252 su 19) |
| 33 | 772361 | piccolo: **11 righe** (`PIA` r.210); 29/07-18/09: COST EURJPY L 7 pos **-134,46 (PF 0,19)** (`G4` r.191); netto 09/10 per magic: **NON TROVATO** | (3) uscita: `InpExitMode` girato una volta in scan [B] su finestra NON MISURATA (`G4` r.193) | EURJPY e' "NO PER RISCHIO" (DD > 10% in IS e OOS, giornata 1,6x il muro, `G4` r.193) |
| 34 | 772362 | piccolo: **10 righe** (`PIA` r.210); GBPCAD L 5 pos **+42,34 (PF 1,64)** 29/07-18/09 (`G4` r.191) | idem | _"il DD promesso piu' alto della flotta"_ (`CEN` r.343). **Conflitto di fonte**: `G4` r.49 la dice "spenta 24/08"; `CEN` r.366 elenca come spenta solo 772363 (XAGUSD); `C01` r.28 la mostra attaccata. Lo stato di oggi e' quello di `C01` (FATTO) |
| 35 | 772421 | piccolo: **9 righe, -32,13, PF 0,75** (`PIA` r.129) | (5) TF: H1 e basta (`G4` r.209) | famiglia **BOCCIATA in portafoglio (R49)**; la corsia B del 24/08 ha ridotto 772421 da 1,0% a 0,3% (`PIA` r.129) |
| 36 | 772422 | piccolo: **8 righe, +248,22, PF 4,18** (`PIA` r.129) | idem | |
| 37 | 772700 | piccolo: **66 pos dal 30/09 al 09/10, -128,79, PF 0,77**; VIOLA 47 -75,92 (PF 0,81), BLU 19 -52,87 (PF 0,66) (`PIA` r.137, da `TA`); v5.20 a vita -153,23 su n 60; motore intero -1.311,29 su n 357 (`PIA` r.137) | (3) **NO** (BE, trailing e parziale inerti per costruzione), (4) **NO** (7 cross fuori dai 15), (5) **IMPOSSIBILE** con H1 cablato (`G3` r.253); (1)(2) "si ma solo 2026" | il PF(r) 0,72 e' del solo VIOLA (pool R92BAB + 31 del piccolo), non dei 66. Decisione di Claudio 08/10: _"OGNI TOCCO DOPO UN IMPULSO, COM'E' ORA"_. Rischio aperto sommato con l'Azzurra **6,40%** (> cap C1 3,25%, nessun Guardian, `PIA` r.138) |
| 38 | 772720 | trial 01-09/10 (`TRS` r.19-26): VIOLA_VIOLA_L 17 pos, 12 vinte, **-1.538,84** · V520_FT_VIOLA_L 1 pos **-1.389,09** · VIOLA_VIOLA_S 9 pos **-876,79** · V520_FT_VIOLA_S 1 pos **+423,79** · BULGE_VIOLA_L 1 **+561,79** · BULGE_VIOLA_S 1 **+990,87** (somma non fatta: la tabella per EA di `TRS` non somma al suo totale, vedi sez. 8) | come riga 37 | sulla trial i commenti di due configurazioni (A: V520_FT 0,80%, magic 772720; B: VIOLA 1,00%, magic 772700) convivono sulla stessa istanza (`AUDIT_RISCHIO_FLOTTA` r.94). La Bulge viola della trial e' opposta alla Bulge del piccolo su 15 dei 22 cross (`AZZURRA_PICCOLO_PASSI` r.73) |
| 39 | 774101 | piccolo 29/07-18/09: 3 pos **-84,21** (GAPCONT L +19,21 / S -103,42, 0 su 2, `G4` r.255) | (3) parziale, (4) **nessuno**, (5) M1 e basta (`G4` r.257) | sospesa. **Tre avvertenze nel contratto**: lo short perde (-2.182), perdite a gruppi (Z -4,03, 6 di fila), cella-picco (`CEN` r.346). Rischio vivo non leggibile dal `.chr` |
| 40 | 970901 | **3 righe, -21,19** (28/08, 18-23/09, `G5` r.249) | (3) parziale (SLLookback ad asse, TrailOnST/ExitOnFlip mai), (4) solo l'oro (`G5` r.251) | **picco**: celle vicine H3/H6/H2 sotto 1; il 2,74 non riprodotto (`RES` r.43) |
| 41 | 970912 | **0 righe** (`G5` r.303) | (3) uscita **mai** (`G5` r.305) | costo H4 NON MISURATO (27,8-184x). `PIA` r.210 la conta a zero |
| 42 | 970913 | **9 righe, +53,48** (7 long +43,35 PF 2,69; 2 short +10,13), 30/07-23/09 (`G5` r.332) | (3) parziale (TrailOnST/ExitOnFlip mai) (`G5` r.334) | 3 binari, 3 cifre (`G5` r.120): 1,688 / 1,581 / 1,613. Il contratto "PF 1,57 / DD 1,17 / n 155" e' **finestra piena senza split** (classe 224). **ESCLUSO PER COSTO 28,7x** (misura diretta mancante) |
| 43 | 971501 XAU | 13 pos XAUUSD, **+0,43**, 05/08-23/09 (`G2` r.186) | nessuna: **certificato 5/5, NO PER RISCHIO** (`G2` r.161; `REGT` r.16) | e' l'unica prova di casa con certificato pieno (`RES` r.19) |
| 44 | 771531 | demo piccolo 14/08-22/09: **23 gambe = 14 segnali, -54,71, PF 0,684** (p 0,071) (`MEMA` r.127). Challenge FTMO: 3 pos **-1.006,86**, di cui 2 gambe del 22/09 **identiche** allo stesso evento del demo (aperture a 0 e 1 s): **i due campioni non si sommano** (`MEMA` r.130-135) | (5 su 5 presenti); manca per la non-morte: **prova di regime**, **IS in posizioni**, posizioni/segnali/peggior giornata delle varianti, convenzione del costo, per-trade con ora d'ingresso (`MEMA` r.115) | **binario fermo del piccolo `344a11b` (06/08)**: 487 righe, zero Guardian (HEAD 691): fail-open doppio. Il profitto OOS sta per il **74,0%** nei 3 mesi migliori su 13; **long nov-mar PF 0,241 su 38 gambe** (`MEMA` r.14, r.69); le 257 sono gambe, ~157 segnali. Gemelli: D30EUR H1 0,928 / 0,783; NASUSD H1 0,755 / 0,693 (non passano). Non legge l'ora. A 2,00% (taglia della trial) il DD OOS e' 15,66% lineare |
| 45 | 774500 | **0 righe** a magic 774500 nel `TA` (`PIA` r.75); accesa dal 09/10 16:39 | (3) uscita, (4) gemelli, (5) TF (`AZF`, "Screening di merito") | porta **indici e oro**: _"nessuna sedia automatica su indici sul piccolo"_ non e' piu' vero alla lettera (`PIA` r.75); se abbia gia' aperto su un indice: NON TROVATO. Possibile tetto di `Max_Trades` che fa saltare i simboli in coda (`AZF`, ipotesi NON MISURATA) |
| 46 | 770611 XAG | **0 righe** a magic 770611 dopo il 03/09 (`PIA` r.122) | **tutte e 5** (nessun PF, n, DD) | chi l'ha attaccata e quando: NON TROVATO. Rischio 1,0%. Magic condiviso (riga 10) |
| 47 | 770611 EURAUD | **0 EUR**, zero riempimenti (`EUR` §0 punto 2) | tutte e 5 | sul **reale**. Il preset e' quello del Dow (`InpEntryPoints=10`, `InpK=1.0` = +10,0 in prezzo): BUY STOP ~11,62 su un cambio a ~1,62. Il pericolo e' la "correzione" con `InpK=0,0001` (stop 2,7-12,5 pip, lotti fino a 3,00) (`EUR` §0 punto 5). Per 12 giorni ha convissuto con l'istanza Dow stesso magic (`EUR` §0 punto 3). Stato di oggi sul reale: solo il profilo salvato (`C01` r.99), non la finestra viva |
| 48 | 771332 | **zero operazioni in tutto il file** (30/03-10/09, `CEN` r.305) | (1) OOS tick, (2) n in OOS, (3)-(5) NON TROVATO | e' attaccata o muta? M-C9 (`CEN` r.522) |
| 49 | 971501 AUDCHF | `TA`: 8 righe a magic 971501 su AUDCHF (`PIA` r.142) | tutte e 5 | **un magic, due simboli** (oro, poi AUDCHF): senza filtro per simbolo le serie si mescolano |

---

## 6. COSA LA TABELLA PERMETTE DI DECIDERE A CLAUDIO (domande, nessuna risposta mia)

1. **L'unita' del cancello campione** (posizione o uscita): sposta la riga 44 (EMA200 Dow) da NON MISURABILE a SI (uscite: IS 237 / OOS 517) o a NO (posizioni: IS 132 dichiarato). Chiude la domanda lasciata aperta da `DOS` r.249.
2. **Quale convenzione del costo (C3) vale** per l'EMA200 (28,7x / 30-34x / 40-45x / 54,9x). E' l'altro buco della riga 44.
3. **Il perimetro "tutti gli EA" sul piccolo**: la tabella ha **26** sedie attaccate sul piccolo e **13** sospese sul piccolo e non attaccate altrove (righe 1, 4, 9, 10, 13, 17, 25, 26, 27, 39, 41, 42, 44). Dieci righe non hanno nessuna misura o ce l'hanno incompleta (righe 14-16, 37, 38, 45-49): per quali vuoi accumulare operazioni in forward (non per giudicare il merito, che a quel n resta sospeso)?
4. **Sedie con certificato incompleto sul reale**: l'ORB EURAUD (riga 47) non ha nessuna misura. Resta com'e' o ne vuoi una? (Il reale e' tuo; io non propongo niente.)
5. **Trial FTMO fino al 14/10 e dopo**: la tabella mostra cosa c'e' sulla trial e con che numeri (sez. 7). La scelta di cosa tenere accesa e' tua.
6. **Bulge e Azzurra sul piccolo** (righe 37 e 45): rischio aperto sommato 6,40% (`PIA` r.138) con PF(r) 0,72 e 0,836 (barre). Resta cosi'?
7. **Magic duplicati** (770611 x3, 971501 x2, 770901 x2): vuoi che i cruscotti filtrino per conto + simbolo?

---

## 7. SI/NO ALLA DOMANDA: "LE SEDIE SU FTMO SONO QUELLE COL PF PIU' ALTO?"

# **NO. Non e' confermabile, e i numeri dicono il contrario per la sedia piu' solida.**

**Cosa c'e' sulla trial `1514806751`** (`C01` r.48-58, profilo salvato; 7 sedie con magic) e il loro PF OOS:

| # | magic | PF OOS | n OOS (pos) | nota |
|--:|---|---|---|---|
| 2 | 770105 DAX short | **0,957** | 194 | **la sola sulla trial con n OOS >= 150: PF sotto 1** |
| 3 | 770202 Dow Apertura | 1,270 | 96 | sotto 150 |
| 5 | 770260 Nasdaq RETEST | 1,109 (`CTR`) o 1,215 (`ORB`) | 91-102 | sotto 150; contratto conteso |
| 7 | 770411 MaxMin DAX short | 2,160 | **14** | campione sottilissimo |
| 8 | 770511 SuperWave Dow H1 | 1,328 o 1,243 | <= 143 deal | sotto 150; contratto conteso |
| 11 | 770621 ORB Dow (copia di 770611) | 1,674 | 119 | sotto 150 |
| 38 | 772720 Bulge viola | PF(r) 0,72 (pool; riga diagnostica) | 221 segnali, nessun OOS | sotto 1 |

(In ordine di magic, non di merito.)

**Le righe della tabella con n OOS >= 150 posizioni sono 4** (righe 1, 2, 44, 45): le due con PF OOS **piu' alto** sono **771531 EMA200 Dow (1,524, 257 pos)** e **770101 DAX long (1,397, 193 pos)**, e **nessuna delle due e' nel profilo della trial** (`C01` r.48-58; `DECISIONE_OROLOGIO_INVERNALE_BCM_2026-10-11.md` r.41: _"770101 e 771531 NON compaiono"_). Erano entrambe sulla challenge `541452707` (chiusa il 30/09, `CHI` r.3; 771531 in `8GG` r.11, 770101 in `8GG` r.10). La sola sedia della trial con n OOS >= 150 ha PF OOS 0,957 (< 1,10 del cancello C0).

**Quello che NON posso dire**: che le sedie col PF piu' alto in assoluto siano "buone". Contando sulla colonna "PF IS -> OOS" della Tabella 1 (45 righe hanno un PF OOS; le righe 14-16 e 46-49 non ne hanno), i tre PF OOS piu' alti sono **5,026 (#22 GapFill GBPUSD, 8 pos), 4,233 (#29 Larry oro, 11 pos), 3,870 (#20 BreakingBand EURUSD, 13 pos)**: tutti su 8-13 posizioni, **merito sospeso**, e nessuno e' sulla trial. Sulla trial il PF OOS piu' alto e' 770411 con 2,160 su 14 posizioni (ottavo nella stessa colonna): stessa categoria. **Il PF piu' alto fra le righe con n OOS >= 150 (771531, 1,524) non e' sulla trial.**

**I numeri della trial al 09/10** (`TRS` r.3-12; il "-14.916,29" citato da Claudio e' il valore del **06/10** in `AUT` r.7): 39 posizioni chiuse, **netto -11.176,84** (bilancio 148.823,16), PF 0,42, media vinta +325,55 contro media persa -1.379,68; equity 149.837,10 con 4 posizioni aperte. Peggior giorno chiuso 01/10 -5.816. **Minimo di bilancio a chiuso 145.054,66 (08/10)**, 1.054,66 sopra la linea 144.000 (DERIVATO: 145.054,66 - 144.000). L'equity intraday e' NON MISURATA (`TRS` r.12). Il Guardian della trial ha scritto `GV_FAILED` il 06/10 (`AUT` r.21).

**Challenge `541452707` (chiusa 30/09)**: flotta (DAX, Dow) 11 posizioni, **-4.500,93, PF 0,31**, somma -3,25 R; 5 stop pieni su 11 (45%) contro ~26% atteso dal backtest (`CHI` r.24, r.32). _"Nessuna sedia e' archiviata come MORTA"_ (`CHI` r.33).

---

## 8. NON TROVATO — cosa manca per completare ogni riga

| cosa manca | righe | chi puo' portarlo |
|---|---|---|
| **Peggior giornata** (cancello R, seconda meta') | quasi tutte (le uniche con giornata dichiarata: 44 con -2,45% chiusi / -1,98% equity [DICHIARATO `G2`]; 33 con -8,02% [B]) | collaudatore / misura di sola lettura sui per-trade |
| **IS 771531 in posizioni** (132 dichiarato, non ricontabile) | 44 | PC di backtest: ~45 s, una corsa sola, gamba IS, magic vergine, deposito 100k (`G2` r.167); firma: no |
| **Convenzione del costo C3** per EMA200 e per le sedie con "?" | 44 e tutte le righe con 3 = ? | analista (riconciliazione A/B/C/D, `MEMA` r.76-79) |
| **Certificato (PF, n, DD) dell'ORB su XAGUSD e su EURAUD**; qualunque misura su AUDCHF 971501; chi ha attaccato l'argento | 46, 47, 49 | PC di backtest; domanda a Claudio per chi/quando |
| **DD e frequenza promessi** (contratto) di Bulge, Azzurra, ORB argento, EasyTrend CHFJPY | 37, 38, 45, 46, 35 | `PIA` r.271: non scritto; da scrivere come contratto |
| **DD, tick e n dell'Azzurra** (solo barre, Modello 1) | 45 | PC di backtest (prova a tick, misura a due corse) |
| **PF, n, DD delle tre PostNews** (CSV con `Trades = 0`) | 14, 15, 16 | PC di backtest: primo PF (~6 min stimati, `RES` r.83) |
| **Mappatura per magic** del forward (BreakingBand, GapFill, Larry, CostToCost, EasyTrend dopo il 18/09; PostNews; PTE 771322 contro 771332) | 14-16, 18-34 | `TA` (export del piccolo, chiusure fino al 09/10 14:22): un conteggio per magic, non fatto qui; il 10-11/10 manca (weekend, INFERITO) |
| **Forward delle sedie FTMO per magic sulla challenge** (solo per famiglia in `8GG`) e sulla trial per 770202/770260/770101/771531 (assenza INFERITA dai commenti) | 1-3, 5, 44 | export completo FTMO (`TRS` e xlsx della challenge) |
| **Equity e saldo del piccolo di oggi**; stato di `Algo Trading`; faccine dei 29 grafici | tutte le ATT piccolo | Claudio (finestra viva); la sonda legge il profilo salvato |
| **Se la trial e' accesa o ferma oggi** e se il suo Guardian e' vivo (_"GUARDIAN: nessuna riga"_ le notti 10 e 11/10, `PIA` r.275) | 2, 3, 5, 7, 8, 11, 38 | Claudio, a vista |
| **Se 771531 e' accesa sulla trial** (`HANDOFF.md` r.17 la dichiara accesa all'01/10 ~00:30, "Salva profilo NON confermato"; 11 sonde consecutive non la vedono) | 44 | Claudio, a vista (`MEMA` r.27) |
| **Gemelli di 770101**: conflitto `RES` r.34 (F40EUR 1,440 -> 0,770) contro `ORB` r.74 (F40/E50/E35 "MAI provati") | 1 | analista (due file da riconciliare) |
| **Peso reale di PTE 771322 contro 771332** e se 771332 e' attaccata o muta | 18, 48 | Claudio (`C01` la vede attaccata: r.31-32) |
| **Perche' 772362 e' attaccata dopo lo "spenta 24/08"** | 34 | Claudio / `HANDOFF.md` |
| **Il diff reale dei +20 righe** di PostNews e ORB fra campo e HEAD | 14-16, 46 | letto dal titolo del commit, non dal diff (`PIA` r.273) |
| **Contratto conteso**: 770511 (3,91 contro 4,17%), 770260 (1,10936 contro 1,21546), 771322 (2,64 / 13,1 / 17,68%), 770531 (4,27 contro 2,96%), 771321 (2,18 contro 3,22%) | 8, 5, 18, 9, 17 | misura di riconciliazione (`G2` r.273, `G3` r.101) |
| **Il confronto "il numero descrive la sedia che gira?"** rifatto sui binari di oggi: `CEN` lo ha fatto l'11/09 (una sola riga su 47 era SI: `770611` sul reale, `CEN` r.416), oggi sul reale gira ORB EURAUD e non quella cella; `PIA` §2a confronta i binari del piccolo (20 su 26 senza Guardian) ma per FTMO e 100k non c'e' un confronto di oggi | tutte | sonda `CODA_06` di stanotte, letta per FTMO e 100k |

**Anomalie di fonte trovate mentre compilavo (non mie, da riconciliare)**:
- `TRS` r.15-26: la tabella "per EA" somma **-11.096,45**, contro il **-11.176,84** dichiarato a r.7: differenza **80,39** (DERIVATO, somma delle dieci righe: -6.059,66 -3.292,52 -1.538,84 -1.389,09 -914,57 -876,79 +998,57 +423,79 +561,79 +990,87). Quindi non ho sommato le righe del Bulge della trial.
- `CEN` v2 §2 descrive il reale con **770101 e 770611 (Dow)** (11/09); `C01` di stanotte mostra sul reale **solo ORB EURAUD 770611** (r.99). Lo stato "dove oggi" della riga 1 usa la sonda di stanotte.
- `PIA` r.18 e r.60: la 771531 e' "assente dal profilo dalla sonda del 24/09" ma `HANDOFF.md` la conta fra le 16 sparite e la tabella del 25/09 non la contiene: **NON RICONCILIATO** (`MEMA` r.26).
- `CLAUDE.md` (motto 09/09) dice 41 sedie vive e "l'unica che passa i cancelli di oggi alla lettera" = EMA200 Dow; qui la stessa sedia e' NON MISURABILE (sez. 1): la differenza e' l'unita' del campione (uscite contro posizioni) e il costo C3, non una misura nuova.

---

## 9. FUORI PERIMETRO (letti, non in tabella)

- Manuale `50503635` (`C:\MT5_MANUALE`): `ABTG_ScalperDirezionale (4)` D30EUR M1, magic 779901, avvio manuale (`C01` r.91).
- Tickmill: `Gold_Ichimoku_TK_ATR_EA` XAUUSD M5 magic 250604 (0,5%) e `BREAKOUT_EA_JPY_v3` USDJPY M15 (`C01` r.70-71). In `CEN` r.362 la prima era "SEDIA FANTASMA" (11/09); stanotte e' nel profilo attivo: **conflitto di stato, NON RICONCILIATO**. Il `BREAKOUT_EA_JPY` ha "famiglia SCARTATA pre-progetto" (7 cross JPY -20.853 EUR, PF 0,67-0,95, DD 30-48%, `CEN` r.356), solo prosa.
- `The Gold Reaper MT5`, `XAUUSD 5 minute` (`.ex5` senza sorgente sul disco del piccolo), `Nasdaq PreOpen Breakout` (esterno, mai girato): `PIA` r.54, r.150-151. Non sedie.
- Guardian 779001 (100k, trial) e 779002 (reale), TradeExporter, SpreadLogger, SlippageLogger, EMA200_Ombra: utility o sola simulazione, senza contratto.

## 10. CONTROLLO FATTO PRIMA DI CONSEGNARE (Sviluppatore contro Agente dei Controlli)

- **Contro-esempi costruiti da me**: (a) _"la domanda `PF OOS >= 1,2` e' un cancello"_ -> cercato nei documenti: non lo e' (sez. 1); (b) _"il campione sottile non puo' stare davanti al campione pieno"_ -> controllato che nel blocco NO le righe 1-2 (n OOS 193 e 194) precedano le 41 con n OOS < 150; (c) _"il conteggio 43 + 6 = 49"_ -> ricontato riga per riga (sez. 3.5); (d) _"771531 e' l'unica sopra"_ -> la riga 44 e' NON MISURABILE, non SI, e ho scritto perche'; (e) i conti derivati (somma `TRS`, 145.054,66 - 144.000) rifatti con python.
- **Non ho verificato** i numeri rileggendo i CSV: sono presi dai referti con la loro riga (stessa avvertenza di `PIA` r.291). Le righe citate con `r.NNN` sono quelle del file a `fb1537df`.
- **Strato 1** (`python3 backtest_pipeline/controlla_riga.py --oggetto md report/TABELLA_SEDIE_2026-10-11.md`): **ESITO: nessun difetto meccanico** (1 controllo passato: nessun blocco ``` da controllare; 2 rilievi non bloccanti: nessun blocco di codice, e prosa che nomina conti/terminali vietati alle righe 4, 44, 119 perche' spiega cosa NON si tocca). Non e' un PASS completo.
- **Strato 2** (`controllo-preventivo`): **NON LANCIATO**, come da mandato. La bozza non e' passata dal cancello e non va a Claudio finche' non passa.
