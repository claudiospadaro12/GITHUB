# ⚖️ HEDGING FRA CONTI, SECONDA MISURA: i DEMO e gli indici CORRELATI (25/09/2026)

**25/09/2026** · branch `lavoro` · **SOLA LETTURA E MISURA**: nessun EA, preset, terminale o conto toccato. Misura sui file del **25/09 03:30**, prima delle sospensioni delle 13:07 e 13:14:47 (vedi 🕐).
Vincolo nuovo: `docs/RISPOSTA_SUPPORTO_FTMO_2026-09-25.md` (Jonas Friedrich). I **demo di altri broker contano**. Contano gli
**strumenti correlati**, e l'esempio lo scrive FTMO stessa: *"long DAX on one account and short Dow Jones or Nasdaq on
another"*. Non c'e' soglia e non c'e' distinzione fra accidentale e voluto. Vale in valutazione.
Macchina di partenza: `report/HEDGING_FRA_CONTI_2026-09-24.md` (quel giorno senza script). Stavolta lo script c'e' ed e' in repo:
`backtest_pipeline/hedging_demo_correlati.py` (ogni numero di §3.3 e §4 esce da li').
Etichette: **[MISURATO]** = letto in un file del repo, con fonte · **[INFERITO]** = dedotto · **[NON MISURATO]** = manca il dato.

🕐 **AGGIORNAMENTO 25/09 pomeriggio: lo stato di OGGI non e' quello delle 03:30** (`report/SOSPENSIONE_SEDIE_DEMO_2026-09-25.md`, ESEGUITO): piccolo `50503392` **15/15 sedie indice tolte** dai `.chr` del profilo `ORO` alle **13:07** (ora VPS), `ESEGUITO_OK`, terminale chiuso; che MT5 alla riapertura carichi quei grafici senza EA e' [NON VERIFICATO]. 100k `50504263`: `ABTG_SupertrendReversal` 225JPY H2 (`770901`) **rimosso alle 13:14:47**; salvataggio del profilo `SQUADRA 100K` [NON VERIFICATO] fino a `CODA_01` del 26/09. Sedie indice non-FTMO attive: **0**, con tre riserve [NON MISURATO]: posizioni/pendenti gia' sul server (§3.4), salvataggio del profilo 100k, conto `50503392` operato da un'altra macchina (§3.4 punto 5).

---

## 0️⃣ LA RISPOSTA IN CINQUE RIGHE

1. 🔴 **SI', una sovrapposizione opposta c'e' GIA' STATA, ed e' per CORRELAZIONE.** Il **22/09**, alle **09:52:01-10:13:45 UTC**
   (**21 min 44 s**), FTMO `541452707` era **short Dow** (`771531` S1+S2, 22,78 lotti US30.cash). Nello stesso intervallo erano
   **long DAX** (`770101`) tre conti BCM: il **REALE `10105439`** (0,10 lotti), il **100k `50504263`** (4,00) e il **piccolo
   `50503392`** (0,30). E' **letteralmente l'esempio di FTMO**. [MISURATO]
   🟠 Il referto del 24/09 diceva *"zero opposte"*: era giusto **sul perimetro di allora** (stesso sottostante). Col perimetro
   del 25/09 **non lo e' piu'**.
2. 🟢 **Sullo STESSO indice: zero opposte** dal 21/09. Tutte le sovrapposizioni sullo stesso indice sono **copie nello stesso
   verso**: 22/09 Dow (piccolo), 24/09 DAX short (100k), 24/09 DAX long (REALE e 100k). [MISURATO]
3. 📋 **Censimento, profili ATTIVI del 25/09 03:30**: **16 sedie non-FTMO su indici**. **15 sono sul piccolo** (Dow 7 · DAX 3 ·
   Nasdaq 2 · Nikkei 3) e **1 sul 100k** (`770901` Nikkei). REALE, Tickmill, Pepperstone, manuale `50503635` e banco `50504400` (`C:\MT5_Backtest`): **0**. Poi c'e' la **zona grigia**
   (forex e oro): **23** sedie sul piccolo, **1** sul REALE (`770611` EURAUD) e **2** su Tickmill.
4. 🔴 **Ma il terminale VPS del piccolo e' MUTO dal 23/09 alle 19:35 italiane** [INFERITO forte]; il CONTO `50503392` da quell'ora e' [NON MISURATO] (loggato anche sul PC di backtest, §3.4 punto 5). In quel minuto si fermano tre cose: l'ultimo log
   Esperti, l'ultimo `ABTG_Trades.csv` e tutti i 45 `.chr`, salvati insieme come alla chiusura del terminale. Il giornale del 24/09
   non esiste. Alle 03:30 del 25/09 voleva dire **1 sedia indice su 16 operativa** e **16 al primo riavvio**; dopo le sospensioni delle 13:07 e 13:14:47 sono **0 attive** nei profili (riserve nel riquadro 🕐).
   Tickmill e' muto dal **20/07**.
5. 📈 **Rischio per giornata, con lo stesso metodo del 24/09** (forward 14/08-22/09, 28 giorni di borsa):

   | scenario | solo stesso indice | + correlati DAX/Dow/Nasdaq | + Nikkei [INFERITO] |
   |---|---|---|---|
   | **A, alle 03:30 del 25/09** (piccolo muto, gira solo `770901` 100k; `770901` tolto alle 13:14:47, vedi 🕐) | **0** | **0** | 0 osservati · rotazione **6,5%/giorno**, **~73% in 20 gg** (n=5 posizioni, fragile) |
   | **B, se le 15 sedie indice tornassero sul piccolo** (profilo ORO del 25/09 03:30, prima della sospensione delle 13:07) | **17,9%/giorno** → **97%** in 20 gg | **35,7%/giorno** → **~100%** | 35,7% → ~100% |

---

## 1️⃣ L'OROLOGIO (lo stesso del 24/09, ricontrollato sull'episodio nuovo)

FTMO = **UTC+3** · BCM = **UTC+1** · giornali MT5 = ora locale italiana = **UTC+2**. L'ancora e' `report/HEDGING_FRA_CONTI_2026-09-24.md` §1.
🧪 **Il verdetto del 22/09 dipende da UN solo numero, lo scarto FTMO − BCM, ed e' misurato sullo stesso episodio.** La copia
`771531` si apre alle **12:52:01 FTMO** e alle **10:52:01 BCM**, e chiude alle **14:45:51 FTMO** e alle **12:45:51 BCM**: stesso
secondo, **scarto +2 h**. Il long DAX BCM (09:56:41-11:13:45 BCM) in ora FTMO e' **11:56:41-13:13:45**, e si sovrappone allo short
FTMO (12:52:01-14:45:51) per 21 min 44 s.
**Contro-esempio**: con uno scarto di +1 h il long DAX finirebbe alle 12:13:45 FTMO, **prima** dello short, e non ci sarebbe
nessuna sovrapposizione. Quell'ipotesi pero' richiede che le due gambe EMA200 siano entrate **e** uscite a un'ora esatta di
distanza. Sono allo stesso secondo **tutte e due le volte**, quindi l'ipotesi cade.

---

## 2️⃣ CENSIMENTO: le sedie NON-FTMO su indici o su strumenti che possono esserci correlati

Fonte: `backtest_pipeline/coda/referti/CODA_01_sedie_attaccate_20260925_033004.log` (profilo **ATTIVO** di tutte le 8 cartelle dati).
I lati vengono da `CODA_08_preset_dai_chr_20260925_033004.log` (`InpAllowLong/Short` dei `.chr`) o dal sorgente, quando il
preset non ha il parametro.
**Contro chi**: FTMO tiene **entrambi i lati** su DAX (`770101` L + `770411` S), Dow (`771531` L/S, `770511` L/S, `770202` L) e
Nasdaq (`770260` L/S). Quindi **ogni** sedia qui sotto, qualunque lato abbia, puo' trovarsi opposta a qualche sedia FTMO, sullo
stesso indice o su un altro.

### 2.1 🔴 Indici DAX / Dow / Nasdaq: correlazione **scritta da FTMO**. **12 sedie**, tutte sul piccolo `50503392` (`BCM Markets MT5 Terminal`, profilo `ORO`)

| magic | EA | simbolo · TF | lato | fonte del lato |
|---|---|---|---|---|
| `770101` | ABTG_DAX_Apertura_EU | D30EUR M5 | **solo LONG** | CODA_08 r.1779-1780 |
| `770411` | ABTG_MaxMinNotte_DAX_Short_Ottimizzato | D30EUR M15 | **solo SHORT** | r.2018-2019 |
| `970912` | ABTG_SupRev_DAX_H4_Ottimizzato | D30EUR H4 | LONG e SHORT | r.2420-2421 |
| `770202` | ABTG_Dow_Apertura_US | U30USD M5 | **solo LONG** | r.1898-1899 |
| `770611` | ABTG_ORB_Ottimizzato | U30USD M5 | **solo LONG** | r.2587-2588 |
| `770511` | ABTG_SuperWave_DOW_H1_Ottimizzato | U30USD H1 | LONG e SHORT | r.2340-2341 |
| `770531` | ABTG_SuperWave | U30USD H4 | LONG e SHORT | r.1599-1600 |
| `771321` | ABTG_PTE | U30USD H1 | LONG e SHORT | r.86-87 |
| `772234` | ABTG_GapFill | U30USD H1 | LONG e SHORT (contro il gap) | sorgente `ABTG_GapFill.mq5` r.437 |
| `772341` | ABTG_PunteLarry | U30USD H1 | LONG e SHORT | r.761-762 |
| `970913` | ABTG_SupRev_NAS_H1_Ottimizzato | NASUSD H1 | LONG e SHORT | r.2500-2501 |
| `770250` | ABTG_Nasdaq_Apertura_US | NASUSD M15 | **solo SHORT** | r.2683-2684 |

### 2.2 🟠 Nikkei (225JPY): correlazione **[INFERITO]**, non nominata da FTMO ma "clearly related" per la stessa logica. **4 sedie**

| conto | magic | EA | simbolo · TF | lato | fonte |
|---|---|---|---|---|---|
| piccolo `50503392` | `772235` | ABTG_GapFill | 225JPY H1 | LONG e SHORT | sorgente r.437 |
| piccolo | `774101` | ABTG_GapContinuation | 225JPY M1 | LONG e SHORT | `InpEnableBuyGaps/SellGaps=true`, r.1356-1388. In CODA_01 il magic compare come "-" perche' il parametro si chiama `InpMagicNumber` |
| piccolo | `770924` | ABTG_SupertrendReversal | 225JPY H2 | LONG e SHORT | r.2178-2179 |
| **100k `50504263`** (`...-V3`, profilo `SQUADRA 100K`) | `770901` | ABTG_SupertrendReversal | 225JPY H2 | LONG e SHORT | r.3628-3629 |

**S&P (SPXUSD / US500)**: **nessuna sedia** non-FTMO. Su FTMO c'e' solo lo `SpreadLogger` su US500.cash, che non fa trading.

### 2.3 ⚪ Zona grigia: forex e oro. Correlazione con gli indici **[INFERITO], instabile, NON contata nei numeri**
- **Piccolo, 23 sedie**:
  - XAUUSD: `772343` (solo L), `770402`, `971501`, `970901` (L/S);
  - JPY: `772344` GBPJPY (solo L), `772361` EURJPY (solo L), `772421` CHFJPY (L/S), `771203` USDJPY e `771201` EURJPY (PostNews, a cavallo: L/S);
  - le altre 14 sono forex non-JPY.
  - Perche' conta: yen e oro sono i classici "risk-off" e si muovono spesso contro gli indici. FTMO scrive che *"correlations can
    change over time"* e non da' una lista. Qui **non c'e' nessuna misura** di quella correlazione.
- **REALE `10105439`**: `770611` ORB EURAUD H1, **solo LONG** (r.3879-3880). Oggi e' l'unico EA che fa trading sul reale.
- **Tickmill** (`Tickmill Europe MT5 Terminal`), conto **[NON MISURATO]** perche' il giornale non lo stampa:
  - `250604` Gold_Ichimoku XAUUSD M5, **solo LONG** (`InpTradeDirection=1` = `DIR_LONG_ONLY`, sorgente r.49-53);
  - `BREAKOUT_EA_JPY_v3` su **7 JPY** (`InpSymbols=USDJPY,EURJPY,GBPJPY,CHFJPY,CADJPY,NZDJPY,AUDJPY`), L/S. Questo e'
    [INFERITO] dal sorgente v1 in repo, perche' la v3 non c'e'.
  - 🟢 Il terminale e' **muto dal 20/07** (CODA_05 e CODA_09: ultimo log 2026-07-20 22:19).
- **Pepperstone**, **manuale `50503635`**: 0 sedie, nessun log. 🔴 **I trade a mano non li vede nessuna sonda** [NON MISURATO].

### 2.4 Chi operava DAVVERO alle 03:30 del 25/09, e quali residui ci sono su disco
- 🔴 **Il terminale VPS del piccolo e' MUTO dal 23/09 alle 19:35 italiane** [INFERITO forte]; il CONTO `50503392` e' [NON MISURATO] da quell'ora (§3.4 punto 5). Nello stesso minuto si fermano tre cose [MISURATO]:
  - l'ultimo log Esperti (`CODA_05_..._20260925` r.23-25, *"ultimo log Esperti: 2026-09-23 19:35"*);
  - `ABTG_Trades.csv` in Common\Files (ultima scrittura 2026-09-23 19:35, CODA_05 r.106);
  - tutti i 45 `.chr` del profilo ORO, salvati come alla chiusura del terminale.

  Nel CODA_09 del 25/09 il piccolo **non ha un giornale del 24/09**, e l'ultima autorizzazione letta e' quella del 20/09 (CODA_03).
  👉 Alle 03:30, al riavvio sarebbero ripartite le 15 sedie indice del profilo ORO. **Dalle 13:07 non sono piu' nei `.chr`**; che MT5 le carichi davvero senza EA e' [NON VERIFICATO].
- **100k**: le sedie DAX, Dow, MaxMin e ORB stanno **ancora su disco** nel profilo `Default` (CODA_01, "RESIDUI"). Se si cambia
  profilo, rientrano.

---

## 3️⃣ LE SOVRAPPOSIZIONI GIA' AVVENUTE (21/09 → 25/09 03:30)

### 3.1 Il lato FTMO e' completo: 4 posizioni, riconciliate al centesimo [MISURATO]
- `ABTG_Trades_FTMO.csv`: **4 posizioni** (CODA_12 del 25/09, r.16-21);
- bilancio: 80.000 − 3.426,14 = 76.573,86 (`SECONDO_STOP` §6), piu' 69,66 = **76.643,52**. Coincide con il Guardian a fine 24/09
  e alle 03:30 del 25/09;
- `rischioAperto=0.00%` alle 03:30 del 25/09.

Il 21/09 e il 23/09 FTMO non ha avuto **nessuna** posizione. Il troncamento del giornale FTMO del 24/09 (40 righe su 103, tetto
della sonda) **non cambia** questo elenco.

| # | FTMO | intervallo UTC |
|---|---|---|
| F1 | 22/09 `771531` S1 **sell** US30.cash 9,11 | 09:52:01-11:45:51 |
| F2 | 22/09 `771531` S2 **sell** US30.cash 13,67 | 09:52:31-11:45:51 |
| F3 | 24/09 `770411` **sell** GER40.cash 25,23 | 07:02:04-07:14:49 |
| F4 | 24/09 `770101` **buy** GER40.cash 10,70 | ingresso **fra 13:17:03 e 13:35:18** [INFERITO: dal BUY LIMIT nel giornale alla prima modify] → 13:36:01 |

### 3.2 Il lato non-FTMO: cosa copre ogni fonte
| conto | fonte | copre fino a | buco |
|---|---|---|---|
| piccolo `50503392` | `data/statements/trades_auto.csv` (solo posizioni **chiuse**) | 23/09 **18:35 BCM**, cioe' l'esportatore fermo alle 19:35 italiane | da li' in poi niente: il terminale VPS e' muto, il conto no (PC di backtest). Vedi §3.4 punti 1 e 5 |
| 100k `50504263` | `trades_100k.csv` | **completo al 25/09 03:11** (40 righe in repo = 40 in Common\Files, CODA_12 r.23-28) | nessuno |
| REALE `10105439` | ledger dello SlippageLogger (CODA_10 del 25/09, **tutti** i deal dal 04/09) | 25/09 02:30 server | nessuno sul deal. Dal 04/09 le sole posizioni sono `770101` D30EUR |
| Tickmill · Pepperstone · manuale | nessun per-trade | | Tickmill e' muto dal 20/07. Manuale e Pepperstone: **[NON MISURATO]** |

### 3.3 Ogni sovrapposizione trovata, in UTC

| FTMO | conto non-FTMO | posizione | sovrapposizione UTC | durata | verso | classe |
|---|---|---|---|---:|---|---|
| **F1+F2** Dow **short** | 🔴 **REALE `10105439`** | `770101` D30EUR **buy** 0,10 · 08:56:41-10:13:45 | **09:52:01-10:13:45** | **21:44** | 🔴 **OPPOSTO** | **indice correlato** (DAX contro Dow = esempio FTMO) |
| F1+F2 Dow short | **100k `50504263`** | `770101` D30EUR **buy** 4,00 · stessi orari | 09:52:01-10:13:45 | 21:44 | 🔴 **OPPOSTO** | indice correlato |
| F1+F2 Dow short | **piccolo `50503392`** | `770101` D30EUR **buy** 0,30 · stessi orari | 09:52:01-10:13:45 | 21:44 | 🔴 **OPPOSTO** | indice correlato |
| F1+F2 Dow short | piccolo | `771531` U30USD **sell** 0,20 + 0,30 | 09:52:01-11:45:51 | 1:53:50 | 🟢 stesso | stesso indice (copia) |
| F1+F2 | piccolo | `772362` GBPCAD buy · `772422` GBPUSD sell | tutto l'intervallo | 1:53:50 | — | ⚪ zona grigia, non contata |
| F3 DAX short | 100k | `770411` D30EUR **sell** 10,80 · 07:02:04-07:14:29 | 07:02:04-07:14:29 | 12:25 | 🟢 stesso | stesso indice (copia) |
| F4 DAX long | REALE · 100k | `770101` D30EUR **buy** 0,20 / 4,50 · 13:23:03-13:35:00 | 13:23:03-13:35:00 (se F4 era gia' dentro) | ≤ 11:57 | 🟢 stesso | stesso indice (copia) |
| F4 DAX long | 100k | **NPO** (`Nasdaq_PreOpen_Breakout_EA`, magic 20260617) NASUSD **buy** 21,60 · 13:30:11-13:30:21 | 13:30:11-13:30:21 (se F4 era gia' dentro) | ≤ 0:10 | 🟢 stesso | indice correlato, **stesso verso** |

- 🔴 **Totale OPPOSTE: 1 episodio (22/09), 3 conti, 21 min 44 s, solo per CORRELAZIONE.** Stesso indice: **0**.
- 🟠 **Quasi-incidente del 24/09** [INFERITO]: l'NPO sul 100k aveva anche un **SELL STOP NASUSD @ 30197,80**, poi cancellato.
  - La riga dell'NPO in `trades_100k.csv` ha `session_low` **30198,50**: il sell stop e' mancato per **0,70 punti**.
  - Se fosse partito, sarebbe stato **short Nasdaq contro il long DAX FTMO F4**, cioe' opposto per correlazione.
  - Che `session_low` sia il minimo vero del giorno e' [INFERITO]: la semantica della colonna non e' documentata.
  - Che il sell stop **non** sia stato riempito e' [MISURATO]: il giornale del 24/09 ha `cancel sell stop` (`SOSPENSIONE_SEDIE_HEDGING_2026-09-24.md` r.72) e il file del 100k, completo, non ha short NASUSD chiusi.

### 3.4 🔴 I buchi dichiarati (classe 786)
1. **Il piccolo dal 23/09 18:35 BCM a oggi: [NON MISURATO]**. Con il terminale VPS muto nessun EA di QUEL terminale apre (il PC di backtest e' il punto 5), ma **il server riempie i
   pendenti e tiene le posizioni aperte**, e togliere gli EA dai grafici non le chiude.
   - Nel giornale del 23/09 c'e' **`772341` PunteLarry SELL STOP U30USD @ 51714,50**, lotto 0,10, SL 52484,90, TP 50558,90,
     scadenza **server** 23/09 23:59 (`ORDER_TIME_SPECIFIED`, sorgente r.696-701).
   - 51714,50 e' **il minimo del 22/09** (`session_low` delle righe `771531` del 22/09).
   - Se il Dow l'ha rotto il 23/09, il piccolo **e' short Dow da allora**, con uscita solo su SL/TP perche' l'EA che gestisce
     il tempo e' spento. Sarebbe **OPPOSTO al long DAX FTMO F4** del 24/09 (13:17-13:36 UTC).
   - Il riempimento **non e' misurato** (lo diceva gia' il 24/09). Si chiude guardando la scheda Storico/Trade del conto
     `50503392`.
   - 🟠 Dalle 13:07 le 15 sedie indice non sono piu' nei `.chr`: riaprire quel terminale non dovrebbe farle ripartire, ma e' [NON VERIFICATO] (`SOSPENSIONE_SEDIE_DEMO` §ESEGUITO, "Da verificare" 1).
     L'app mobile o il web terminal di BCM leggono lo stesso conto **senza avviare EA**.
2. Altre posizioni del piccolo **aperte** al momento della chiusura, per esempio una seconda gamba SupRev NAS: `trades_auto.csv`
   ha solo le chiuse [NON MISURATO].
3. **Conto manuale `50503635` e Pepperstone**: nessuna sonda vede i trade a mano [NON MISURATO].
4. **Il giornale del 21/09 manca** (gia' dichiarato il 24/09). E' irrilevante: il 21/09 FTMO non aveva posizioni.
5. **Il conto `50503392` sul PC di backtest `DESKTOP-H4D7CAJ`**: quel MT5 e' loggato sullo stesso conto (ordini veri #3160534/#3160535 il 14/08) e nessuna sonda lo legge. Si chiude con lo Storico del CONTO (app o web terminal BCM), che vede i deal di tutte le macchine [NON MISURATO].

---

## 4️⃣ RISCHIO FUTURO: probabilita' di almeno una sovrapposizione opposta

**Metodo** (quello del 24/09, esteso):
- **Proxy delle sedie FTMO**: le posizioni sul piccolo delle stesse sedie (`770101` solo buy, `770411`, `770202`, `770511`,
  `771531`), dal 14/08 al 22/09, **28 giorni di borsa**, 54 posizioni.
- **Controparti**: le posizioni forward delle sedie **nel profilo attivo del 25/09 03:30** dei conti non-FTMO (prima delle sospensioni: vedi 🕐).
- Si contano gli intervalli sovrapposti di verso opposto, si deduplicano per giornata × coppia di sedie, e si tiene la frequenza
  = giornate con un episodio / 28.
- P(≥1 in 20 giorni di borsa) = 1 − e^(−20·f), come il 24/09. 20 giorni e' la mediana Monte Carlo al target.
- **Controllo di robustezza**: le controparti vengono **ruotate** di k = 1..27 giorni di borsa, alla stessa ora, e si prende la
  media degli episodi. E' il valore atteso se i tempi fossero indipendenti.

### 4.1 🧪 Contro-esempio prima dei numeri: lo strumento RIPRODUCE il 24/09
Sullo stesso indice lo script trova **5 giornate su 28** (19/08, 24/08, 25/08, 31/08, 03/09): **le stesse cinque, alla data**, di
`HEDGING_FRA_CONTI` §5.1. Tiene separate **75 coppie nello stesso verso**, che non conta. Ai dati veri del 24/09 (F3 e F4)
assegna "copia", non "opposta": lo strumento sa dire di no.

### 4.2 I numeri

| scenario | sedie controparte | **stesso indice** | **giornate con un episodio correlato DAX/Dow/Nasdaq** (2 in comune con lo stesso indice: 31/08, 03/09) | **stesso + correlati FTMO** | **+ Nikkei** [INFERITO] |
|---|---|---|---|---|---|
| **A, 25/09 03:30** (piccolo muto, Tickmill muto; superato alle 13:14:47, vedi 🕐) | 100k `770901` (5 posizioni in finestra) | **0**: nessuna sedia | **0**: nessuna sedia | **0** | osservati **0/28**. Rotazione: **1,8/28 = 6,5%/giorno → ~73% in 20 gg** (min 0, max 4 giornate) |
| **B, se le 15 sedie indice tornassero** (profilo ORO del 25/09 03:30, prima della sospensione) | le 15 sedie indice del piccolo + `770901` | **5/28 = 17,9%/giorno → 97%** (rotazione 19,4% → 98%) | **7/28 = 25,0%/giorno → 99%** | **10/28 = 35,7%/giorno → ~100%** (rotazione 37,3%) | 10/28 (rotazione **42,5%/giorno**) |
| controllo: perimetro del 24/09, prima della sospensione | B + 100k `770101`/`770202`/`770411`/`770611` + REALE (ledger solo dal 04/09) | 5/28 | 7/28 | 10/28 | 10/28 |

**Le giornate opposte "solo correlati" dello scenario B** (UTC):

| giorno | proxy FTMO | contro | durata |
|---|---|---|---|
| 20/08 | `770411` DAX short | `770531` Dow long | 2 h 52 |
| 21/08 | `770101` DAX long | `770531` Dow short | 52 min |
| 26/08 | `770411` DAX short | `772341` Dow long | 4 min |
| 31/08 | `770411` DAX short | `772234` e `772341` Dow long | 1 h 47 |
| 03/09 | `770101` DAX long | `772341` Dow short | 41 min |
| 08/09 | `770101` DAX long | `770511`, `770531` e `772341` Dow short | 44 min |
| 22/09 | `771531` Dow short | `770101` DAX long | 21 min |

Il 22/09 e' **l'episodio vero** del §3.

### 4.3 Come si leggono
- 🔴 **La sospensione del 24/09 ha tolto dal perimetro il DENARO VERO, non la FREQUENZA.** Il controllo e B danno **le stesse
  10 giornate**: ogni episodio del 100k e del REALE (quest'ultimo solo dal 04/09, inizio del ledger) aveva gia' la sua gemella sul piccolo, per esempio l'08/09 e il 22/09; il REALE fra il 14/08 e il 03/09 e' [NON MISURATO].
- 🔴 **Gli indici correlati raddoppiano la frequenza** rispetto al solo stesso indice: da 17,9% a **35,7% dei giorni di borsa**.
  In pratica, col piccolo acceso, **una giornata su tre**.
- 🟢 **In A il rischio di NUOVE entrate su DAX, Dow e Nasdaq e' zero per costruzione**: nessuna sedia non-FTMO attiva su quei tre. Alle 03:30 dipendeva da un terminale spento; **dalle 13:07 dipende da una scelta registrata** (15 sedie tolte dai `.chr`). Fuori da questo zero restano posizioni/pendenti gia' sul server e il PC di backtest (§3.4), [NON MISURATO].
- 🟠 **Il Nikkei (A, alle 03:30)** diceva 0 osservati, ma **~73% in 20 giorni** a tempi indipendenti. Dalle 13:14:47 `770901` e' tolto: oggi conta solo se il profilo del 100k non e' stato salvato. Vale **solo se** FTMO considera il Nikkei
  correlato, e questo e' [INFERITO]. E' costruito su **5 posizioni**: e' un ordine di grandezza, non una misura.

### 4.4 Confidenza: BASSA-MEDIA, per le stesse ragioni del 24/09 e due in piu'
- 28 giorni di borsa, un regime solo. La proxy "piccolo = FTMO" non e' un'identita': FTMO ha fatto **4 posizioni in 4 giorni**,
  la proxy ne fa **~1,9 al giorno**, quindi **il numero puo' essere ALTO**.
- `770260` FTMO Nasdaq non ha proxy sul piccolo. Il Nasdaq e' quindi un **pavimento**: spinge **in su**.
- La correlazione DAX/Dow/Nasdaq e' scritta da FTMO. Quella del Nikkei e' [INFERITO]. Forex e oro **non sono stimati**, perche'
  FTMO non ha sedie lì e la correlazione e' instabile.
- ❄️ D'inverno l'incastro cambia (dal 26/10 DAX, dal 02/11 USA). Vale quanto scritto al §5.4 del 24/09, [NON MISURATO].

---

## 5️⃣ COSA NON DICE QUESTO REFERTO
- Non dice **cosa fara' FTMO** con l'episodio del 22/09: la risposta scritta dice *"can result in corrective action, including
  account termination, depending on the circumstances and severity"*. Questo referto misura **il fatto**, non la sanzione.
- **Nessuna raccomandazione di spegnere, spostare o ridimensionare.** La decisione e' di Claudio.

## 6️⃣ FONTI
- vincolo: `docs/RISPOSTA_SUPPORTO_FTMO_2026-09-25.md` · metodo: `report/HEDGING_FRA_CONTI_2026-09-24.md` · sospensione: `report/SOSPENSIONE_SEDIE_HEDGING_2026-09-24.md`
- sedie: `CODA_01_sedie_attaccate_20260925_033004.log` · lati: `CODA_08_preset_dai_chr_20260925_033004.log` · stato terminali: `CODA_05_foto_fresca_20260925_033004.log`, `CODA_03_..._20260925`
- FTMO: `CODA_12_pertrade_posizioni_20260925_033004.log` r.16-21 · `report/PRIMO_STOP_FTMO_2026-09-22.md` r.17-18 · `SECONDO_STOP_FTMO_2026-09-24.md` §1, §6 · `MODIFY_A_RAFFICA_FTMO_2026-09-25.md` §1 · giornale `CODA_09_giornale_operativo_20260925_033004.log`
- non-FTMO: `data/statements/trades_auto.csv` · `trades_100k.csv` · `CODA_10_slippage_20260925_033004.log` (REALE) · `CODA_09_..._20260923_033004.log` e `..._20260925_033004.log`
- script: `backtest_pipeline/hedging_demo_correlati.py` (`--autotest` 6/6) · sospensioni eseguite: `report/SOSPENSIONE_SEDIE_DEMO_2026-09-25.md` §ESEGUITO
- sorgenti: `mql5/Experts/ABTG_GapFill.mq5` r.437 · `ABTG_PunteLarry.mq5` r.696-701 · `Gold_Ichimoku_TK_ATR_EA.mq5` r.49-53 · `BREAKOUT_EA_JPY.mq5` r.348

---
_Cancello: strato 1 OK; strato 2 FAIL (D1 stato superato dalle sospensioni, D2 provenienza, D3 REALE nel controllo, D4 conto contro terminale -> classe 792, D5 etichetta, D6 prova) -> correzioni applicate; strato 2 FAIL in seconda passata (5 frasi al presente superate dalle sospensioni: r.37, r.106-107, r.140, r.190, r.207) -> correzioni applicate alla lettera; terza passata PASS._
