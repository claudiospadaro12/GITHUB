# 🧮 IL CANCELLO DI COSTO IN DUE UNITA' — 18/09/2026

> **Nato dal punto 1 di Marco Garbuglia (13/09), entrato in repo oggi:**
> `docs/garbuglia/RISPOSTA_DOSSIER_ABTG_2026-09-13_Garbuglia_testo.txt` r.57-103.
> Domanda testuale: *«il 40× è su spread o su costo pieno? E la commissione,
> dove entra nel giudizio di una sedia?»*
>
> 🟢 **HA RAGIONE SUL DIFETTO.** 🔴 **E il difetto è peggio di come l'ha visto:
> il referto del 10/09 usa DUE denominatori diversi sotto la STESSA soglia, in
> quattro tabelle, senza etichette.**
> 🎁 **Ma la risposta alla sua domanda NON è una firma di Claudio: è già scritta
> in due file di casa, e la notizia bella è che sulla flotta INDICI la
> differenza fra le due unità è ZERO ESATTO — misurata, non assunta.**

**Tutto ricalcolato da:** `backtest_pipeline/cancello_due_unita.py`
(ASCII puro, rieseguibile, autotest in cinque blocchi tutti VERDI).
Lancio: `python3 backtest_pipeline/cancello_due_unita.py --tutte`.

🖥️ **Bersaglio della riga: nessuno.** Gira su questa macchina (il repo), non
tocca nessun terminale MT5, nessun EA, nessun preset, nessun conto — né il
piccolo `50503392`, né il 100k `50504263`, né il reale `10105439`, né il
backtest `50504400`.

---

## 🎯 IL VERDETTO IN SEI RIGHE

1. 🔴 **Il difetto esiste ed è più largo di come segnalato**: quattro tabelle
   del cancello, **tre denominatori diversi**, una sola soglia. `r.394` indici →
   `spread` · `r.460` oro → `spread+comm` (**già costo pieno**) · `r.485` nikkei
   → `spread` · `r.518` forex → `spr A`/`spr B` (**spread nudo**).
2. 🟢 **E la prima notizia è bella: su 17 sedie su 34 le due letture sono LO
   STESSO NUMERO.** Commissione **0,0000 EUR/lotto, valore UNICO su 330 deal**,
   ricalcolata da me su `trades_auto.csv`: D30EUR · U30USD · NASUSD · 225JPY ·
   SPXUSD · F40EUR · USOIL. **Sugli indici `spread ≡ costo pieno`.** Nessuna
   sedia indice cambia verdetto, in nessuna variante.
3. 🔴 **Le sedie che cambiano verdetto sono SEI, e sono tutte FOREX**, allo
   spread della sonda: `772361` · `772162` · `771201` · `771201` trailata ·
   `771202` · `771203`. Con lo spread prudente a 1,0 pip se ne aggiungono
   **tre**: `772421` · `772344` · di nuovo `771201` trailata. Sull'oro **una**:
   `250604`, e solo allo spread favorevole S1.
4. 🚨 **Una sedia SFONDA il pavimento DURO solo quando la si legge in costo
   pieno**: `771201` PostNews EURJPY **dopo il trailing a 15 pip** → **13,2×**
   contro 13,3. In spread faceva 37,5×. *(Il referto del 10/09 lo aveva già
   scritto nella correzione dell'11/09: qui è **riprodotto per via indipendente**,
   partendo dai deal e dal `TickValue`.)*
5. 🟢 **LA DOMANDA È RISOLTA PER DOCUMENTO, NON PER FIRMA** (§5): la derivazione
   del 40× dice testualmente *«pedaggio di una operazione»*, e un file di criteri
   **congelato prima dei numeri** scrive già `stop >= 40 x pedaggio` con
   *«il denominatore è il pedaggio ALL-IN»*. 🔴 **E la citazione `(budget R55)`
   a r.170 è una MISATTRIBUZIONE: in R55 quel budget non c'è.**
6. 🔴 **E un difetto NUOVO, che non era nel mandato e che va detto**: nella
   catena del 18/09 a **EURUSD è stato dato lo spread di GBPUSD** (0,2 invece di
   0,4). È il numero da cui nascono il «3,32× lo spread» e il «12,1×» del
   mandato. Col nostro spread misurato EURUSD fa **2,16×** e **18,5×** (§4.4).

---

# 1. 📋 IL CENSIMENTO DELLE TABELLE — quale denominatore usa DAVVERO ognuna

Aperte una per una, intestazione letta alla lettera.

| tabella | riga | intestazione della colonna | denominatore **vero** | sedie | **etichettata?** |
|---|---:|---|---|---:|:---:|
| §5.1 indici | **394** | `spread` | 🟢 **spread = costo pieno** (comm 0,0000 misurata) | **19 righe** = 13 sedie + 6 sotto-righe | 🟡 **inutile ma innocua** |
| §5.2 oro | **460** | `spread+comm` | 🔴 **COSTO PIENO** (0,22 + 0,0403 = 0,2603 $) | 5 sedie + 1 sotto-riga | 🟢 **SÌ, è l'unica** |
| §5.3 nikkei | **485** | `spread` | 🟢 **spread = costo pieno** (comm 0,0000 su 225JPY) | 4 sedie | 🟡 inutile ma innocua |
| §5.4 forex | **518** | `spr A` / `spr B` | 🔴 **SPREAD NUDO**, commissione **assente** | **21 righe**, 11 con uno stop | 🔴 **NO** |
| §7.1 «non passano» | **657** | `x` | 🔴 **misto**: 5 righe indici (spread=pieno) + `772362` forex (spread nudo) | 6 | 🔴 **NO** |
| §7.4 «le 15 che passano» | **687** | testo in linea | 🔴 **MISTO NELLA STESSA FRASE**: 4 righe oro in **costo pieno**, 6 forex in **spread nudo**, 5 indici indifferenti | 15 | 🔴 **NO** |
| §D 18/09 «celle che cambiano» | **1001** | `spread mediano` | 🟢 spread = costo pieno (tutte indici) | 6 | 🟡 innocua |
| §F 18/09 spread di coda | **1081** | `spread usato` | 🟢 idem (U30USD) | 1 | 🟡 innocua |
| `ANCORA_ADR` §8 | **407** | `spread` | 🟢 idem (tutte indici) | 6 | 🟡 innocua |
| `ANCORA_ADR` §8 dettaglio | **422** | `/mediana`, `/coda` | 🟢 idem | 5 | 🟡 innocua |

> ### 🎯 E LA LETTURA CHE CAMBIA LA PRIORITÀ
> **Su 10 tabelle, otto sono sui simboli a commissione ZERO**: lì l'etichetta
> manca ma **non c'è niente da sbagliare**, perché i due denominatori sono lo
> stesso numero. 🔴 **Le tabelle che mordono davvero sono DUE: §5.4 (forex,
> r.518) e §7.4 (la lista dei 15 promossi, r.687)** — e la seconda è la
> peggiore, perché **mescola le due unità dentro una frase sola**.

---

# 2. 💰 LA COMMISSIONE, RIMISURATA DA ME — e non è uguale ovunque

Fonte: `data/statements/trades_auto.csv`, colonne `commission` e `volume`,
**1.319 posizioni**. Mediana di `|commission| / volume`, per simbolo.
🚫 Non ho riletto il numero del referto: l'ho **rifatto**.

| classe | commissione **per lotto, giro completo** | n deal | valori distinti |
|---|---:|---:|---:|
| **indici** (D30EUR · U30USD · NASUSD · 225JPY · SPXUSD · F40EUR · USOIL) | 🟢 **0,0000 EUR** | **330** | **1** (`min = max = 0,0000`) |
| **XAUUSD** | **3,4800 EUR** | 524 | 23 |
| **EURUSD** | **4,0000 EUR** | 27 | **1** |
| GBPUSD | 4,6559 EUR | 34 | 22 |
| USDJPY | 3,4210 EUR | 16 | 14 |
| EURJPY | 4,0000 EUR | 9 | 1 |

## 2.1 🔬 DA EUR/LOTTO ALL'UNITÀ DEL SIMBOLO — una formula sola, nessun caso speciale

```
valore di UNA unita' di prezzo, per lotto, in EUR = TickValue / TickSize x unita
commissione nell'unita' del simbolo = commissione_EUR_per_lotto / quel valore
```
`TickValue`/`TickSize` dalla sonda `215D85D7_ABTG_InfoBroker.csv` (17/08 17:34
srv). L'oro e gli indici **non hanno nessun ramo dedicato**: la differenza la fa
il `TickValue` del simbolo, che è un dato **letto**.

| simbolo | comm EUR/lotto | → nell'unità di casa |
|---|---:|---|
| EURUSD | 4,0000 | **0,4636 pip** |
| GBPUSD | 4,6559 | **0,5396 pip** |
| USDJPY | 3,4210 | **0,6318 pip** |
| EURJPY | 4,0000 | **0,7387 pip** |
| GBPCAD | — | **0,7448 pip** |
| CHFJPY | — | **0,8039 pip** |
| GBPJPY | — | **0,8516 pip** |
| EURAUD | — | **0,6518 pip** |
| XAUUSD | 3,4800 | **0,04033 $** di prezzo |
| tutti gli indici + 225JPY | 0,0000 | **0,0000 punti indice** |

## 2.2 🧪 I CONTRO-ESEMPI, COSTRUITI PRIMA DI CONSEGNARE

Sono i cinque blocchi di `--autotest`. **Tutti VERDI.**

1. 🧪 **«Gli indici hanno commissione zero» potrebbe essere un lettore rotto che
   dice zero a tutti.** → Blocco 2: sullo **stesso lettore**, sullo **stesso
   file**, il forex esce **non-zero** su tutti e quattro i simboli provati.
   Il blocco 1 misura qualcosa.
2. 🧪 **«La conversione in pip potrebbe tornare da sola.»** → Blocco 3: la
   commissione in pip è calcolata per **due strade con ingressi diversi** —
   (a) EUR/lotto **misurati sui deal** ÷ `TickValue`, (b) la **legge** 0,004%
   del nozionale in valuta base + cambi incrociati
   (`calcola_pedaggio_forex.commissione_pip`). Scarto massimo su sei coppie:
   **2,12%** (CHFJPY); su EURUSD e EURJPY **0,00%**.
3. 🧪 **«L'ancora dell'oro potrebbe essere la mia stessa formula.»** → Blocco 4:
   l'atteso è **0,0403 $**, scritto da un'ALTRA sessione in
   `ORO_1530_CANCELLO_COSTO_2026-09-10.md` §2.4. Il mio conto parte dai deal e
   dal `TickValue` e **non passa da quel numero**: esce **0,04033 $**.
4. 🧪 **«Lo spread orario potrebbe essere letto dalla riga sbagliata.»** →
   Blocco 5: atteso **dichiarato prima**, dalla tabella di `R125` §2 —
   U30USD h14 = 2,00 · NASUSD h14 = 1,80 · D30EUR h8 = 1,70. **Tre su tre.**
5. 🧪 **«Lo stop del referto potrebbe essere invecchiato e trascinarsi dietro i
   verdetti.»** → §6: lo stop è **ricalcolato oggi** dai deal e messo ACCANTO,
   non al posto. Riproduce il referto entro lo **0,5%** su **16 sedie su 22**, e
   dove no **lo dico** (§6).

---

# 3. 📊 LA TABELLA MADRE IN DUE UNITA' — ogni sedia, tutte e due le letture

**Variante A — spread alla MEDIANA dell'ora modale** (indici: tick; oro: S2
prudente 0,22 $; nikkei e forex: sonda istantanea 17/08).
Verdetti: `PASS` ≥ 40× · `NO` fra 13,3× e 40× · `SFONDA` < 13,3× ·
`FRAGILE` = la soglia cade **dentro** la banda dello stop.

| magic | EA | simb | TF | stop | spread | comm | costo pieno | `stop/spread` | 40x? | `stop/costo pieno` | 40x? | 13,3x (costo)? |
|---|---|---|---|---:|---:|---:|---:|---:|:---:|---:|:---:|:---:|
| `770101` | DAX_Apertura_EU | D30EUR | M5 | 71.90 `[MIS]` | 1.700 | 0.0000 | 1.700 | **42.3x** | PASS | **42.3x** | PASS | SI |
| `770202` | Dow_Apertura_US | U30USD | M5 | 123.80 `[MIS]` | 2.000 | 0.0000 | 2.000 | **61.9x** | PASS | **61.9x** | PASS | SI |
| `770611` | ORB_Ottimizzato | U30USD | M5 | 59.00 `[MIS]` | 2.000 | 0.0000 | 2.000 | **29.5x** | NO | **29.5x** | NO | SI |
| `770511` | SuperWave_DOW_H1_Ott | U30USD | H1 | 77.10 `[MIS]` | 2.000 | 0.0000 | 2.000 | **38.5x** | NO | **38.5x** | NO | SI |
| `770531` | SuperWave | U30USD | H4 | 295.50 `[MIS]` | 2.000 | 0.0000 | 2.000 | **147.8x** | PASS | **147.8x** | PASS | SI |
| `771531` | EMA200 | U30USD | H1 | 104.30 `[MIS]` | 1.900 | 0.0000 | 1.900 | **54.9x** | PASS | **54.9x** | PASS | SI |
| `772341` | PunteLarry | U30USD | H1 | 274.20 `[MIS]` | 2.600 | 0.0000 | 2.600 | **105.5x** | PASS | **105.5x** | PASS | SI |
| `772234` | GapFill | U30USD | H1 | 98.00 `[MIS]` | 2.800 | 0.0000 | 2.800 | **35.0x** | NO | **35.0x** | NO | SI |
| `771321` | PTE | U30USD | H1 | 78.0-88.2 `[MIS]` | 2.000 | 0.0000 | 2.000 | **39.0-44.1x** | FRAGILE | **39.0-44.1x** | FRAGILE | SI |
| `970912` | SupRev_DAX_H4_Ott | D30EUR | H4 | 47.0-313.0 `[NM]` | 1.700 | 0.0000 | 1.700 | **27.6-184.1x** | FRAGILE | **27.6-184.1x** | FRAGILE | SI |
| `970913` | SupRev_NAS_H1_Ott | NASUSD | H1 | 27.10 `[MIS]` | 1.800 | 0.0000 | 1.800 | **15.1x** | NO | **15.1x** | NO | SI |
| `770411` | MaxMinNotte_DAX_Short_Ott | D30EUR | M15 | 64.2-87.5 `[NM]` | 1.700 | 0.0000 | 1.700 | **37.8-51.5x** | FRAGILE | **37.8-51.5x** | FRAGILE | SI |
| `770250` | Nasdaq_Apertura_US_GatedShort | NASUSD | M15 | 83.20 `[INF]` | 1.800 | 0.0000 | 1.800 | **46.2x** | PASS | **46.2x** | PASS | SI |
| `770402` | MaxMinNotte | XAUUSD | H2 | 32.94 `[MIS]` | 0.220 | 0.0403 | 0.260 | **149.7x** | PASS | **126.5x** | PASS | SI |
| `971501` | EMA200_Ottimizzato | XAUUSD | H4 | 42.28 `[MIS]` | 0.220 | 0.0403 | 0.260 | **192.2x** | PASS | **162.4x** | PASS | SI |
| `970901` | SupertrendReversal_Ott | XAUUSD | H4 | 35.31 `[INF]` | 0.220 | 0.0403 | 0.260 | **160.5x** | PASS | **135.6x** | PASS | SI |
| `772343` | PunteLarry | XAUUSD | H1 | 61.48 `[MIS]` | 0.220 | 0.0403 | 0.260 | **279.5x** | PASS | **236.2x** | PASS | SI |
| `250604` | Gold_Ichimoku_TK_ATR | XAUUSD | M5 | 7.22 `[MIS]` | 0.220 | 0.0403 | 0.260 | **32.8x** | NO | **27.7x** | NO | SI |
| `770924` | SupertrendReversal | 225JPY | H2 | 477.00 `[MIS]` | 35.000 | 0.0000 | 35.000 | **13.6x** | NO | **13.6x** | NO | SI |
| `770901n` | SupertrendReversal (100k) | 225JPY | H2 | 477.00 `[INF]` | 35.000 | 0.0000 | 35.000 | **13.6x** | NO | **13.6x** | NO | SI |
| `774101` | GapContinuation | 225JPY | M1 | 479.00 `[MIS]` | 35.000 | 0.0000 | 35.000 | **13.7x** | NO | **13.7x** | NO | SI |
| `772235` | GapFill | 225JPY | H1 | [NM] `[NM]` | 35.000 | 0.0000 | 35.000 | **[NM]** | NM | **[NM]** | NM | - |
| `772422` | EasyTrend | GBPUSD | H1 | 35.00 `[MIS]` | 0.200 | 0.5396 | 0.740 | **175.0x** | PASS | **47.3x** | PASS | SI |
| `772421` | EasyTrend | CHFJPY | H1 | 47.00 `[MIS]` | n/d | 0.8039 | n/d | **[NM]** | NM | **[NM]** | NM | - |
| `772361` | CostToCost | EURJPY | H4 | 29.20 `[MIS]` | 0.400 | 0.7387 | 1.139 | **73.0x** | PASS | **25.6x** | NO | SI |
| `772362` | CostToCost | GBPCAD | H4 | 38.90 `[MIS]` | 1.200 | 0.7448 | 1.945 | **32.4x** | NO | **20.0x** | NO | SI |
| `772162` | BreakingBand | EURUSD | H1 | 22.10 `[MIS]` | 0.400 | 0.4636 | 0.864 | **55.2x** | PASS | **25.6x** | NO | SI |
| `772342` | PunteLarry | EURAUD | H1 | 35.60 `[MIS]` | n/d | 0.6518 | n/d | **[NM]** | NM | **[NM]** | NM | - |
| `772344` | PunteLarry | GBPJPY | H1 | 58.60 `[MIS]` | n/d | 0.8516 | n/d | **[NM]** | NM | **[NM]** | NM | - |
| `771201` | PostNews (ECB) | EURJPY | M5 | 25.00 `[DIC]` | 0.400 | 0.7387 | 1.139 | **62.5x** | PASS | **22.0x** | NO | SI |
| `771201t` | PostNews (ECB) dopo il trail | EURJPY | M5 | 15.00 `[DIC]` | 0.400 | 0.7387 | 1.139 | **37.5x** | NO | **13.2x** | SFONDA | NO |
| `771202` | PostNews (FOMC) | EURUSD | M5 | 25.00 `[DIC]` | 0.400 | 0.4636 | 0.864 | **62.5x** | PASS | **28.9x** | NO | SI |
| `771203` | PostNews | USDJPY | M5 | 25.00 `[DIC]` | 0.300 | 0.6318 | 0.932 | **83.3x** | PASS | **26.8x** | NO | SI |

**Variante B — lo spread PRUDENTE del forex (1,0 pip, colonna B del referto).**
Cambia solo il forex; indici, oro e nikkei restano identici alla variante A.

| magic | EA | simb | TF | stop | spread | comm | costo pieno | `stop/spread` | 40x? | `stop/costo pieno` | 40x? | 13,3x (costo)? |
|---|---|---|---|---:|---:|---:|---:|---:|:---:|---:|:---:|:---:|
| `772422` | EasyTrend | GBPUSD | H1 | 35.00 `[MIS]` | 1.000 | 0.5396 | 1.540 | **35.0x** | NO | **22.7x** | NO | SI |
| `772421` | EasyTrend | CHFJPY | H1 | 47.00 `[MIS]` | 1.000 | 0.8039 | 1.804 | **47.0x** | PASS | **26.1x** | NO | SI |
| `772361` | CostToCost | EURJPY | H4 | 29.20 `[MIS]` | 1.000 | 0.7387 | 1.739 | **29.2x** | NO | **16.8x** | NO | SI |
| `772362` | CostToCost | GBPCAD | H4 | 38.90 `[MIS]` | 1.000 | 0.7448 | 1.745 | **38.9x** | NO | **22.3x** | NO | SI |
| `772162` | BreakingBand | EURUSD | H1 | 22.10 `[MIS]` | 1.000 | 0.4636 | 1.464 | **22.1x** | NO | **15.1x** | NO | SI |
| `772342` | PunteLarry | EURAUD | H1 | 35.60 `[MIS]` | 1.000 | 0.6518 | 1.652 | **35.6x** | NO | **21.6x** | NO | SI |
| `772344` | PunteLarry | GBPJPY | H1 | 58.60 `[MIS]` | 1.000 | 0.8516 | 1.852 | **58.6x** | PASS | **31.6x** | NO | SI |
| `771201` | PostNews (ECB) | EURJPY | M5 | 25.00 `[DIC]` | 1.000 | 0.7387 | 1.739 | **25.0x** | NO | **14.4x** | NO | SI |
| `771201t` | PostNews (ECB) dopo il trail | EURJPY | M5 | 15.00 `[DIC]` | 1.000 | 0.7387 | 1.739 | **15.0x** | NO | **8.6x** | SFONDA | NO |
| `771202` | PostNews (FOMC) | EURUSD | M5 | 25.00 `[DIC]` | 1.000 | 0.4636 | 1.464 | **25.0x** | NO | **17.1x** | NO | SI |
| `771203` | PostNews | USDJPY | M5 | 25.00 `[DIC]` | 1.000 | 0.6318 | 1.632 | **25.0x** | NO | **15.3x** | NO | SI |

> 🔎 **Legenda dei tag dello stop:** `[MIS]` = mediana delle gambe chiuse in
> `sl` e in perdita sui deal veri · `[INF]` = inferito, strada dichiarata ·
> `[DIC]` = dichiarato nel sorgente dell'EA (`InpSLpips`) · `[NM]` = non
> misurato, banda. **Il numeratore è quello del referto**, non il mio ricalcolo:
> vedi §6 per il perché e per il confronto.

---

# 4. 🔴 LA DOMANDA CHE VALE: QUALI SEDIE CAMBIANO VERDETTO, PER NOME

## 4.1 🚨 LE SEI CHE CAMBIANO ALLO SPREAD DELLA SONDA (variante A)

| sedia | EA · simbolo · TF | conto | **in spread** | **in costo pieno** | il salto |
|---|---|---|---:|---:|---|
| **`772361`** | CostToCost EURJPY H4 | 🔵 | **73,0×** 🟢 PASS | **25,6×** 🔴 NO | −65% |
| **`772162`** | BreakingBand EURUSD H1 | 🔵 | **55,2×** 🟢 PASS | **25,6×** 🔴 NO | −54% |
| **`771201`** | PostNews *(ECB)* EURJPY M5 | 🔵 | **62,5×** 🟢 PASS | **22,0×** 🔴 NO | −65% |
| 🚨 **`771201`** ↳ *dopo il trailing a 15 pip* | idem, `ABTG_PostNews.mq5` r.105 | 🔵 | **37,5×** 🔴 NO | **13,2×** ⛔ **SFONDA IL DURO** | −65% |
| **`771202`** | PostNews *(FOMC)* EURUSD M5 | 🔵 | **62,5×** 🟢 PASS | **28,9×** 🔴 NO | −54% |
| **`771203`** | PostNews USDJPY M5 | 🔵 | **83,3×** 🟢 PASS | **26,8×** 🔴 NO | −68% |

🔴 **Sono le sedie su cui l'unità decide davvero. Tutte e sei sono FOREX, e
quattro su sei sono la famiglia PostNews.**

## 4.2 🟡 LE TRE IN PIÙ CON LO SPREAD PRUDENTE (variante B, 1,0 pip)

| sedia | EA · simbolo · TF | **in spread** | **in costo pieno** |
|---|---|---:|---:|
| **`772421`** | EasyTrend CHFJPY H1 | **47,0×** 🟢 PASS | **26,1×** 🔴 NO |
| **`772344`** | PunteLarry GBPJPY H1 | **58,6×** 🟢 PASS | **31,6×** 🔴 NO |
| 🚨 **`771201`** ↳ trailata | PostNews EURJPY M5 | **15,0×** 🔴 NO | **8,6×** ⛔ **SFONDA** |

*(Alla sonda `772421` e `772344` hanno `SpreadPt = 0` = illeggibile: il loro
verdetto esiste **solo** nella variante prudente, in tutte e due le unità.)*

## 4.3 🥇 SULL'ORO: UNA SOLA, E SOLO ALLO SPREAD FAVOREVOLE

| sedia | spread usato | **in spread** | **in costo pieno** |
|---|---|---:|---:|
| **`250604`** Gold_Ichimoku XAUUSD M5 ⚪ Tickmill | **S1 = 0,16 $** (il più favorevole) | **45,1×** 🟢 PASS | **36,0×** 🔴 NO |
| idem | S2 = 0,22 $ (il prudente, quello del referto) | 32,8× 🔴 NO | 27,7× 🔴 NO |

⚠️ `250604` gira su **TICKMILL**, dove lo spread è `[NON MISURATO]` in casa: i
numeri dicono *«su BCM sarebbe al confine»*, e il verdetto resta **NON ANCORA
MISURATO** in tutte e due le unità.

## 4.4 🟢 E LE 17 SEDIE SU CUI NON CAMBIA NIENTE — perché è la notizia più utile

`770101` · `770202` · `770611` · `770511` · `770531` · `771531` · `772341` ·
`772234` · `771321` · `970912` · `970913` · `770411` · `770250` · `770924` ·
`770901` (225JPY) · `774101` · `772235`.

**Non «cambiano poco»: sono LO STESSO NUMERO**, perché la commissione misurata
su quei simboli è **0,0000 EUR/lotto con UN SOLO valore distinto su 330 deal**.
Comprese **tutte** le sedie degli indici — cioè il cuore della flotta di ottobre.

### 📐 IL FATTORE DI AMPLIFICAZIONE, simbolo per simbolo — e il numero di Garbuglia rifatto sui NOSTRI spread

| simbolo | spread | comm | costo pieno | **pieno / spread** | **un 40× in spread vale, in costo pieno** |
|---|---:|---:|---:|---:|---:|
| EURUSD | 0,400 | 0,4636 | 0,864 | **2,16×** | **18,5×** |
| GBPUSD | 0,200 | 0,5396 | 0,740 | **3,70×** | 🔴 **10,8×** |
| USDJPY | 0,300 | 0,6318 | 0,932 | **3,11×** | 🔴 **12,9×** |
| EURJPY | 0,400 | 0,7387 | 1,139 | **2,85×** | **14,1×** |
| GBPCAD | 1,200 | 0,7448 | 1,945 | **1,62×** | **24,7×** |
| XAUUSD | 0,220 | 0,0403 | 0,260 | **1,18×** | **33,8×** |
| D30EUR · U30USD · NASUSD · 225JPY | — | **0,0000** | = spread | 🟢 **1,00×** | 🟢 **40,0×** |

> ## 🔴 **E QUI GARBUGLIA HA RAGIONE FINO IN FONDO, ma su due simboli, non su tutti: su GBPUSD (10,8×) e USDJPY (12,9×) un 40× letto in SPREAD è PIÙ PERMISSIVO del nostro stesso pavimento DURO letto in costo pieno.**
> Su EURUSD no (**18,5×**, sopra 13,3). Su GBPCAD e sull'oro nemmeno vicino.
> Sugli indici la domanda **non si pone**.

### ⚠️ E UN DIFETTO NUOVO, TROVATO STRADA FACENDO — a EURUSD è stato dato lo spread di GBPUSD

Il mandato cita *«su EURUSD il costo pieno vale **3,32×** lo spread, quindi 40×
in spread = **12,1×** in costo pieno»*. 🔴 **Quei due numeri escono da uno
spread di 0,2 pip su EURUSD.** La sonda del 17/08 misura:

| simbolo | `SpreadPt` (sonda r.24-27) | in pip |
|---|---:|---:|
| GBPUSD | **2** | **0,2** |
| USDJPY | 3 | 0,3 |
| **EURUSD** | **4** | **0,4** |

- 🔎 **Dove si è propagato**: `report/AUDJPY_E_GBPUSD_IL_NUMERO_CHE_MANCAVA_2026-09-18.md`
  r.524-525 dà EURUSD H4 a **54,2×** (ancora A) e **22,2×** (ancora B).
  `36,0 / 54,2 = 0,664` e `14,7 / 22,2 = 0,662`: il denominatore usato è
  **0,6636 = 0,2 + 0,4636**, cioè lo spread di GBPUSD con la commissione di
  EURUSD. Coi numeri giusti (`0,8636`) escono **41,7×** e **17,0×** (§4.5).
- 🟢 **`REGISTRO_TEST.md` r.2394-2397 invece è CORRETTO**: scrive testualmente
  *«pedaggio all-in EURUSD **0,864 pip** [MISURATO: spread **0,4** + commissione
  **0,4636**]»*. La riga vecchia è giusta, quella nuova no.
- 📌 **E anche `CANCELLO_COSTO_FLOTTA` r.202 ha la stessa crepa**, ed è la riga
  che Garbuglia ha citato: *«Spread **0,3** + commissione **~0,5** = **0,86**
  pip all-in su EURUSD»*. 🔴 **0,3 + 0,5 = 0,8, non 0,86**: il totale è giusto
  (0,4 + 0,4636 = 0,8636), gli addendi scritti no. **Garbuglia ha ereditato i
  nostri addendi sbagliati, non ne ha inventati.**

## 4.5 🔁 LE ESCLUSIONI PER COSTO GIÀ PRONUNCIATE, RILETTE IN TUTTE E DUE LE UNITÀ

| caso | stop | spread | comm | **stop/spread** | 40×? | **stop/costo pieno** | 40×? |
|---|---:|---:|---:|---:|:---:|---:|:---:|
| **EURUSD H1** — ATR(14) H1 ~18,0 pip `[DER]` | 18,00 | 0,400 | 0,4636 | **45,0×** | 🟢 PASS | **20,8×** | 🔴 NO |
| **EURUSD H4** — ancora A (Oanda M15 ×4) `[DER]` | 36,00 | 0,400 | 0,4636 | **90,0×** | 🟢 PASS | **41,7×** | 🟢 PASS |
| **EURUSD H4** — ancora B (`772162` su BCM ×2) `[DER]` | 14,70 | 0,400 | 0,4636 | **36,7×** | 🔴 NO | **17,0×** | 🔴 NO |
| **`770611`** ORB U30USD M5 — mediana ora 14 | 59,00 | 2,000 | **0,0000** | **29,5×** | 🔴 NO | **29,5×** | 🔴 NO |
| **`770611`** ORB U30USD M5 — coda P95 ora 14 | 59,00 | 3,000 | **0,0000** | **19,7×** | 🔴 NO | **19,7×** | 🔴 NO |
| **`770901`** SupertrendReversal 225JPY H2 | 477,00 | 35,000 | **0,0000** | **13,6×** | 🔴 NO | **13,6×** | 🔴 NO |

### Che cosa se ne ricava, caso per caso
- 🟢 **`EURUSD H1`: l'esclusione REGGE in tutte e due le unità.** 45,0× in
  spread è un PASS, **ma il numero scritto nel `REGISTRO` è 20,8× in costo
  pieno**, cioè la riga **usava già la nostra unità**, ed è quella che ha
  deciso. **L'esclusione per costo di EURUSD H1 non dipende dalla firma.**
  🔴 Va però detto che **in spread quella cella PASSEREBBE**: se domani si
  firmasse lo spread nudo, `EURUSD H1` **rientra**.
- 🔴 **`EURUSD H4` è il caso in cui l'unità NON decide, ma l'ANCORA sì.** Con
  l'ancora A passa in tutte e due (90,0× / 41,7×); con l'ancora B non passa in
  nessuna (36,7× / 17,0×). 👉 **Il `[NON RISOLTO]` scritto il 18/09 resta,
  e la via più corta resta quella già indicata: una lettura diretta di
  `iATR(EURUSD, PERIOD_H4, 14)` sul feed BCM, UNA passata.** Il mio contributo
  qui è solo togliere l'unità dalla lista dei sospetti.
- 🟢 **`770611` ORB: l'esclusione REGGE, ed è INDIFFERENTE all'unità.** 29,5×
  alla mediana e 19,7× in coda **nelle due unità sono lo stesso numero**, perché
  su U30USD la commissione è 0,0000. Il `🔴 NO` del referto **non ha bisogno di
  nessuna firma**.
- 🟡 **`770901` / `770924` SupertrendReversal 225JPY: **13,6× è **13,6× in tutte
  e due le unità** (comm 0,0000 su 225JPY, n=11 deal). I *«tre decimi sopra il
  pavimento duro»* **restano tre decimi**: l'unità non li tocca. 🔴 **Ma il
  vero problema di quella riga non è l'unità ed è ancora aperto**: lo spread di
  **35 punti** è **una lettura sola presa alle 01:34 di Tokyo, cash chiuso** —
  cioè l'ora in cui lo spread del Nikkei è al MASSIMO. Vedi §6.2.

---
# 5. 🎯 IL BUDGET — ED È QUI CHE LA DOMANDA SI CHIUDE SENZA FIRMA

## 5.1 🔴 PRIMO FATTO: la citazione `(budget R55)` a r.170 NON REGGE

`report/CANCELLO_COSTO_FLOTTA_2026-09-10.md` **r.170**, testuale:

> `| **DI LAVORO** | stop >= 40 × spread | il pedaggio vale ≤ 2,5% del movimento tipico (budget R55) |`

**Sono andato ad aprire R55. Tutti e due i file.**

| file | righe | occorrenze di `2,5` / `2.5` | di `40x` / `40 x` | di `budget` |
|---|---:|---:|---:|---:|
| `backtest_pipeline/prove/R55_SCALABILITA_TESI.md` | 136 | **0** | **0** | **0** |
| `backtest_pipeline/risultati_archivio/REFERTO_ROUND55_SLIPPAGE.md` | 142 | **0** | **0** | **0** |

🔴 **R55 non contiene quel budget. R55 è un round sullo SLIPPAGE**, e il suo
criterio §4.2 è un altro numero: *«una cella si dice "scala" se, aggiungendo uno
slippage pari al **10% di un R**, resta positiva fuori campione»*. Quello che R55
misura davvero è il **costo per trade in frazione di R** (PTE **0,41% di un R**,
ORB **4,5% di un R**, r.43-45 e r.63-64 del referto) — un ingrediente del budget,
non il budget.

## 5.2 🟢 SECONDO FATTO: la derivazione VERA esiste, e dice «PEDAGGIO», non «spread»

`backtest_pipeline/caccia_strategie/CACCIA_TFBASSO_FREQUENZA_2026-09-06.md`
§6.1, **r.336-342**, testuale:

> - Cancello **H8** (`FIRME_2026-08-31.md`, FIRMA 2): **E ≥ 0,075R misurata a tick**.
> - **Pedaggio di una operazione**, in R: **`pedaggio = spread ÷ stop_in_punti`**.
> - Se vogliamo che **il pedaggio** si mangi **al massimo un terzo** del cancello:
>   `spread / stop ≤ 0,025` → 🎯 **`stop ≥ 40 × spread`**
> - Se accettiamo che **il pedaggio** valga **tutto** il cancello:
>   `spread / stop ≤ 0,075` → **`stop ≥ 13,3 × spread`**

✅ **Verificata l'aritmetica, come chiesto:**
- `1 / 40 = 0,0250` → il 2,5% **torna**;
- `1 / 13,3 = 0,0752` ≈ **0,075 = il cancello H8 intero** → torna;
- `40 / 3 = 13,33` → 🟢 **Garbuglia indovina anche questo**: il pavimento duro
  **è** un terzo del cancello nominale, e adesso c'è la riga che lo dice.

🔴 **Ma il 2,5% da solo NON individua il denominatore.** `1/40 = 2,5%` è vero
qualunque cosa stia al numeratore: se il budget fosse sullo spread esce 40×
spread, se è sul costo pieno esce 40× costo pieno. **L'aritmetica è
simmetrica.** 👉 **Quello che NON è simmetrico è la PAROLA**: la grandezza a
budget si chiama **«pedaggio di una operazione»**, cioè *quello che
l'operazione paga davvero*. `pedaggio = spread ÷ stop` non è la definizione del
pedaggio: è la sua **implementazione**, scritta il 06/09 quando in casa si
credeva che la commissione fosse **0,00 su tutto**.

🔬 **E quella credenza è stata MISURATA FALSA cinque giorni dopo**, dal referto
stesso (correzione dell'11/09, r.176-186): *«la v1 diceva: sugli indici e sul
nostro forex la commissione è 0,00 — verificata su 7 simboli. **Sugli indici è
vero. Sul forex è FALSO**, e i "7 simboli" erano **tutti indici**»*.
👉 **Quindi `pedaggio = spread` non era una scelta di unità: era un'identità
vera sugli indici e falsa sul forex, e nessuno l'aveva riscritta.**

## 5.3 🟢 TERZO FATTO: un file di CRITERI CONGELATI l'ha già riscritta

`backtest_pipeline/prove/COLLAUDO_SPREAD_FLOTTA_CRITERI.md` — intestazione:
*«🧊 CRITERI CONGELATI … File scritto PRIMA dei numeri della corsa»*, 10/09.
**r.218-221:**

> | **DI LAVORO** | `stop >= 40 x pedaggio` | il pedaggio vale <= 2,5% del movimento tipico |
> | **DURO** | `stop >= 13,3 x pedaggio` | sotto: si scarta per aritmetica |

e **r.224**, prima precisazione, testuale:

> 💰 **Il denominatore e' il pedaggio ALL-IN** = `spread mediano dell'ora modale
> della sedia` **+** `commissione misurata`. Sull'oro il referto lo fa gia'; da
> qui in avanti si fa **anche sul forex**.

> ## 🟢 **QUINDI LA RISPOSTA A GARBUGLIA È UN FATTO, NON UNA FIRMA: il 40× è sul COSTO PIENO, e la commissione entra nel giudizio di una sedia come SECONDO ADDENDO del denominatore. C'è un file di criteri, congelato prima dei numeri, che lo scrive già.**
> Il referto del 10/09 **non l'ha propagato in tabella**: è rimasto in testa,
> nella correzione dell'11/09, e le colonne sono rimaste quelle di prima.
> **Non è una decisione da prendere: è una riscrittura da fare.**

## 5.4 🧪 IL CONTRO-ESEMPIO, costruito prima di consegnare: «e se il budget fosse davvero sullo spread?»

Se non lo cerco, la mia risposta è una conferma, non una verifica. **L'ho
cercato, e UN residuo esiste.**

`mql5/Experts/ABTG_HVAncora.mq5` **r.239** e **r.932-935**:

```
input double InpMaxSpreadPctOfStop  = 2.5;    // Gate di spread (R55): spread <= X% dello stop
...
double spreadPrezzo = ask-bid;
if(spreadPrezzo > (InpMaxSpreadPctOfStop/100.0)*slDist)   // -> si salta il trade
```

🔴 **È il 2,5% implementato con `ask-bid`, cioè SPREAD NUDO — e etichettato
«(R55)», la stessa citazione che a §5.1 non regge.** E `CHECKLIST_RIGA_DI_LANCIO.md`
r.16985 lo elenca fra le tre ancore della convenzione di casa.

**Perché però NON ribalta la conclusione, e lo dico col motivo:**
1. 🔧 Quello è un **filtro per-trade dentro un EA**, che gira a runtime su
   `ask - bid`: la commissione **non è un dato disponibile** in quel punto del
   codice. È un limite di implementazione, non una scelta di criterio.
2. 📅 È **anteriore** alla misura dell'11/09 che ha trovato la commissione forex.
3. 🎯 E soprattutto: `ABTG_HVAncora` è un **candidato**, non il cancello della
   flotta. Il cancello della flotta sta nei file di criteri, e quelli dicono
   `pedaggio`.

➡️ **Conseguenza operativa, dichiarata e NON eseguita** (è una modifica a un EA,
fuori dal mio perimetro di sola lettura): se si firma la lettura in costo pieno,
`InpMaxSpreadPctOfStop` di `ABTG_HVAncora` **va riallineato o rinominato**,
altrimenti il repo continua a contenere due cancelli con lo stesso nome e due
denominatori. **Costo: una ricompilazione.** Decide Claudio.

## 5.5 ✏️ E UNA CORREZIONE DA RIMANDARE A GARBUGLIA — la sua CONCLUSIONE non regge, il suo RILIEVO sì

Lui scrive (r.76-83):
> *«Il vostro pavimento duro, espresso in costo pieno, è **21,5% dello stop** —
> cioè quasi esattamente la mia soglia [del 20%]. I due sistemi non sono a otto
> volte di distanza; sono vicini.»*

🔴 **Quel confronto mette le due soglie in DUE UNITÀ DIVERSE — che è, alla
lettera, il difetto che lui stesso stava segnalando.** Ha convertito **il nostro**
numero in costo pieno (`13,3 / 2,87 = 4,63×` → `1/4,63 = 21,5%`) e ha lasciato
**il suo** in spread (*«sul mio sistema lo **spread** al 20% dello stop»*, r.112).

- 📐 Il rapporto `2,5% : 20%` = **1 : 8** è **invariante rispetto all'unità**,
  purché le due soglie stiano nella stessa. Convertirne una sola **fabbrica**
  la convergenza.
- 🟢 **E sotto la lettura documentata (§5.2-5.3) i due sistemi si allontanano,
  non si avvicinano**: il nostro 2,5% è **già** in costo pieno, il suo 20% è in
  spread. Per confrontarli va convertito **il suo**, e in costo pieno il suo
  20% diventa **di più**, non di meno.
- 🟢 **Ma il suo rilievo di fondo resta VERO e utile**, ed è §4.4: su **GBPUSD**
  e **USDJPY** un 40× letto in spread è **più permissivo del nostro pavimento
  DURO** letto in costo pieno. Quello è un difetto vero, misurato, e va chiuso.
- 🎁 **E la sua proposta finale coincide con la nostra derivazione, e merita di
  essergli detto**: lui scrive *«il parametro comparabile non è né spread ÷ stop
  né costo ÷ stop, ma **costo pieno ÷ aspettativa per operazione**»*. 👉 **È
  esattamente H8**: il nostro 40× nasce da `pedaggio ≤ 1/3 × E`, con
  `E ≥ 0,075R` misurata a tick. **Ci eravamo già arrivati, solo senza dirlo
  nella tabella.**

---
# 6. 🚩 I BUCHI E I RITROVAMENTI LATERALI, DICHIARATI

## 6.1 🔬 LO STOP RICALCOLATO OGGI — tre sedie sono invecchiate (classe 411)

Ho rifatto la ricetta del referto (mediana di `|close − open|` sulle gambe
`close_reason = sl` **e** `profit < 0`) sui dati di **oggi**. 🔴 **I verdetti di
§3 NON la usano** — se cambiassi anche il numeratore, le sedie che si muovono
avrebbero due cause e l'elenco di §4 non vorrebbe dire niente.

🟢 **Riproduce il referto entro lo 0,5% su 16 sedie su 22.** Le tre che divergono
oltre il 5%:

| sedia | stop referto | stop **oggi** | n | scarto | che cosa ne segue |
|---|---:|---:|---:|---:|---|
| **`771531`** EMA200 U30USD H1 | 104,30 | **88,10** | **10** (erano 8) | **−15,5%** | 🟢 `88,10 / 1,90 =` **46,4×**: resta **PASS**, con margine da +37% a **+16%** |
| 🚨 **`774101`** GapContinuation 225JPY M1 | 479,00 | **378,50** | **2** | **−21,0%** | ⛔ `378,50 / 35 =` **10,8×**: **SFONDA IL PAVIMENTO DURO**. Il referto la dava a 13,7× |
| **`770924`** SupertrendReversal 225JPY H2 | 477,00 | **580,00** | **3** (era 1) | **+21,6%** | `580 / 35 =` **16,6×**: resta 🔴 NO, ma **si allontana** dal duro |

> 🚨 **`774101` è il ritrovamento laterale che pesa di più, e NON c'entra con
> l'unità di misura** (su 225JPY le due letture coincidono): c'entra col
> **campione cresciuto**. Con n=2 il numero è sottile, quindi si applica la
> valvola di casa: **il campione sottile sospende il giudizio sul MERITO, mai
> sul RISCHIO.** 👉 Va segnalato a Claudio come **rischio**, non archiviato come
> verdetto.
>
> ⚠️ **E c'è un secondo motivo per non chiudere**: lo spread di **35 punti
> Nikkei** è **una lettura sola, presa alle 17:34 server = 01:34 a Tokyo, cash
> CHIUSO**, mentre `774101` opera fra le **01:00 e le 07:30 server**, cioè a
> cassa APERTA. Sul DAX la stessa differenza vale **2,80 → 1,70 (−39%)**: se sul
> Nikkei valesse altrettanto, **35 → ~21** e `774101` tornerebbe a **~18×**.
> 👉 **La via più corta al numero resta quella già indicata dal referto del
> 10/09 (§8): `ABTG_SpreadLogger` con `,225JPY` nella lista.** Costa
> zero tempo macchina di ottimizzazione. **Finché non c'è, il verdetto di
> `774101` è `[NON ANCORA MISURATO]`, non «sfondato».**

## 6.2 🔴 LE DUE TABELLE CHE VANNO RISCRITTE, e non basta etichettarle

- **§5.4 (r.518, forex)**: le colonne `spr A` / `spr B` non hanno la
  commissione. Con l'etichetta giusta diventano oneste, ma **restano inutili
  per il giudizio**, perché il giudizio è nell'altra unità. Serve la colonna
  `costo pieno`, che è la tabella di §3 di questo referto.
- 🚨 **§7.4 (r.687, «LE 15 CHE PASSANO»)**: è **la peggiore**, perché mescola le
  due unità **dentro una frase sola** — quattro righe oro **già in costo pieno**
  e sei righe forex **in spread nudo**. In costo pieno quelle **15 diventano
  10**: cadono `772361`, `772162`, `771201`, `771202`, `771203`. Resiste
  `772422` EasyTrend GBPUSD (**47,3×**, +18%).
  🔴 **Non è una svista di etichetta: è una LISTA DI PROMOSSI che in costo pieno
  è un terzo più corta.**

## 6.3 🚩 QUELLO CHE QUESTO REFERTO **NON** FA
- ❌ **Non decide l'unità**, salvo dove la decidono i documenti (§5.3), e lì lo
  dico come **fatto con la citazione**, non come opinione.
- ❌ **Non tocca nessun criterio**: 40× e 13,3× sono di Claudio e sono entrati
  nel codice come costanti lette, non discusse.
- ❌ **Non tocca EA, preset, `coda/CODA.txt`, forward, né nessun terminale.**
- ❌ **Non misura nessuno spread.** Lo spread del forex resta **una sonda
  istantanea del 17/08 alle 17:34** per 7 simboli e **illeggibile** (`SpreadPt=0`)
  per 4; quello del Nikkei **una lettura sola a cassa chiusa**; quello di
  Tickmill **mai misurato**. 🔴 **Questo è il buco che vale di più**, e non si
  chiude con una firma: si chiude con `ABTG_SpreadLogger`.
- ❌ **Non copre** slippage, requote, rifiuti, swap, né l'esecuzione della prop
  vera. Copre **spread + commissione**.

## 6.4 ⚖️ E LE COSE ANDATE BENE, che vanno dette quanto i difetti
- 🟢 **La commissione degli indici è 0,0000 con UN SOLO valore distinto su 330
  deal**: non «circa zero», **zero**. Vuol dire che **tutto il lavoro sugli
  indici del 10-18/09 è al riparo da questa polemica**, e gli indici sono la
  flotta di ottobre.
- 🟢 **La legge della commissione regge per due strade indipendenti**: misurata
  sui deal ÷ `TickValue` contro la legge `0,004% del nozionale in valuta base`.
  Scarto massimo **2,12%** su sei coppie.
- 🟢 **`calcola_pedaggio_forex.py` aveva già ragione su tutto**, e il suo
  `--autotest` è la ragione per cui `REGISTRO_TEST.md` r.2394-2397 ha lo spread
  **giusto** mentre la catena del 18/09 ha quello di GBPUSD.
- 🟢 **Il cancello di costo di `770611` ORB e quello di `EURUSD H1` REGGONO in
  tutte e due le unità**: due esclusioni che non hanno bisogno di nessuna firma
  e che restano dove sono.
- 🟢 **Il collega ha visto giusto sul difetto**, e ci ha fatto trovare una
  tabella di promossi lunga 15 che in costo pieno è lunga 10. **Questo scambio
  ha già pagato il tempo che costa.**

---

# 7. ✍️ LA RIGA PER `REGISTRO_TEST.md`

> **18/09/2026 — IL CANCELLO DI COSTO IN DUE UNITÀ.** Il pavimento `40×` è sul
> **COSTO PIENO** (spread + commissione), non sullo spread: lo dice la
> derivazione (`CACCIA_TFBASSO_FREQUENZA_2026-09-06.md` §6.1 r.337, *«pedaggio
> di una operazione»*) e lo scrive già un file di criteri congelato prima dei
> numeri (`COLLAUDO_SPREAD_FLOTTA_CRITERI.md` r.220/224, *«il denominatore è il
> pedaggio ALL-IN»*). La citazione `(budget R55)` a `CANCELLO_COSTO_FLOTTA`
> r.170 è una **misattribuzione**: in R55 quel budget non compare (0 occorrenze
> in 278 righe su due file). **Sedie che cambiano verdetto passando da un'unità
> all'altra: SEI** (`772361`, `772162`, `771201`, `771201`-trailata, `771202`,
> `771203`), tutte forex, allo spread della sonda; **+3** allo spread prudente
> (`772421`, `772344`, `771201`-trailata); **+1** sull'oro allo spread S1
> (`250604`). **Zero sedie indice**, perché la commissione misurata su
> D30EUR/U30USD/NASUSD/225JPY/SPXUSD/F40EUR/USOIL è **0,0000 EUR/lotto, valore
> unico su 330 deal**. `771201` PostNews EURJPY **dopo il trailing a 15 pip
> SFONDA il pavimento duro in costo pieno: 13,2× contro 13,3**.
> **Non archivia nessun candidato. Non tocca nessun criterio.**
> Strumento: `backtest_pipeline/cancello_due_unita.py` (autotest 5/5 verdi).

---

# 8. 🙋 CHE COSA CHIEDO A CLAUDIO — tre cose, e due sono da zero minuti macchina

1. ✍️ **La riscrittura delle due tabelle** (§5.4 r.518 e §7.4 r.687) in costo
   pieno. Non è una firma sull'unità — quella i documenti l'hanno già data —
   è il **permesso di propagare** una correzione dentro un referto già
   consegnato. **Costo: zero tempo macchina.**
2. 🔧 **Che fare di `InpMaxSpreadPctOfStop` in `ABTG_HVAncora.mq5`** (§5.4):
   riallinearlo al costo pieno, o rinominarlo perché non si chiami come il
   cancello della flotta. **È una modifica a un EA: non la tocco.**
3. 🚨 **Il caso `774101` GapContinuation 225JPY M1** (§6.1): stop sceso a
   **378,5** su n=2 → **10,8×**, sotto il pavimento duro — **ma con uno spread
   letto a cassa di Tokyo chiusa**. 👉 O si mette `,225JPY` nella lista di
   `ABTG_SpreadLogger` (**la via più corta, e la più economica del referto**),
   o quella sedia resta `[NON ANCORA MISURATO]` con un rischio aperto sopra.

**E la bussola, per non perderla di vista:** questa è una giornata di
**PONTEGGIO**, non di sedie nuove. Vale perché ha trovato **una lista di
promossi un terzo più corta** e **due rischi veri** (`771201` trailata,
`774101`) che senza il conto in due unità restavano invisibili — ma non ha
aggiunto nessuna sedia schierabile al 1° ottobre, e va detto così.

---

# 🚦 IL CANCELLO, PRIMA DELLA CONSEGNA — che cosa è stato controllato e come

| strato | strumento | esito |
|---|---|---|
| **1 — deterministico** | `controlla_riga.py` | ⚪ **NON APPLICABILE**: qui non esce nessuna riga di lancio, nessuno script `.ps1`, nessuna azione sul VPS o su un terminale |
| **1 — deterministico** | `controlla_prova.py` | ⚪ **NON APPLICABILE**: nessun file prova, nessuna cella, nessuna passata di tester |
| **1-bis — autotest dello strumento** | `cancello_due_unita.py --autotest` | 🟢 **5 blocchi su 5 VERDI** (§2.2) |
| **1-ter — ASCII puro** | conteggio dei byte > 127 nel `.py` | 🟢 **0** |
| **2 — verifica delle citazioni** | ogni riga citata **aperta** con `sed -n` | 🟢 **10 su 10** combaciano alla lettera |

## 🔧 E i DUE difetti che l'Agente dei Controlli ha trovato nel mio stesso lavoro, corretti PRIMA della consegna
1. 🔴 **Lo stop ricalcolato dal forex era in PREZZO, non in pip.** Stampava
   `-100%` di scarto su **ogni** riga forex. Uno scarto del 100% su tutta una
   classe non è un ritrovamento: è un bug di unità — **nello stesso referto che
   parla di unità**. Corretto dividendo per l'unità del simbolo (il commento è
   nel sorgente, r.304-318).
2. 🔴 **Alle due sedie «senza ora modale» (`770511`, `771321`) stavo dando lo
   spread della PEGGIORE ora**, invece del `2,00` della riga TUTTO del referto.
   Peggiorava `770511` da 38,5× a 27,5×: cambiava il **denominatore** per un
   motivo che **non c'entra niente con la domanda di questo referto**, e avrebbe
   sporcato l'elenco di §4 con un secondo effetto. Corretto e dichiarato nel
   sorgente (r.112-125).
