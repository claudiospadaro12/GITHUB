# 📜 IL CENSIMENTO DEI CONTRATTI — cosa il backtest ha PROMESSO, sedia per sedia

_Missione M11, 18/08/2026 — prerequisito dichiarato alla firma della C3
(`report/FIRME_2026-08-18.md`): la regola "DD forward oltre il DD promesso" e
"frequenza molto sotto quella promessa" morde solo se esiste questa tabella._

**Fonte della lista sedie:**
`backtest_pipeline/risultati_archivio/censimento_rischio_2026-08-18_0001.txt`
(censimento dai `.chr` del 18/08 00:01, 57 righe → **44 sedie di trading
uniche** per EA/simbolo/magic, dopo deduplica; escluse le 3 utility:
`ABTG_Guardian` 779001 e `ABTG_TradeExporter` EURUSD/NZDCAD, che non tradano).
Nota: i magic che compaiono due volte con rischi diversi (770101, 770202,
770411, 770901 a 0,65 · 770611 a 0,3) sono le **copie sul dry-run 100k col
Guardian** (`report/DEPLOY_GUARDIANO_100K.md`) — stessa sedia, stesso
contratto, taglia diversa. Le due PTE GBPUSD a 0,5 sono il duello del 17/08.

---

## ⚖️ COME LEGGERE I NUMERI (le unità, dichiarate)

1. **DD promesso** = il drawdown del backtest della **cella che ha promosso la
   sedia**, in % del deposito del test, **a rischio 1% per trade** salvo nota.
   I backtest girano su **10k** (walk-forward) o **100k** (per-trade): a
   rischio percentuale il DD% è ~indipendente dal deposito, quindi **la % vale
   anche sul conto piccolo (~5.100 €)** — gli euro no.
2. **Sedie a rischio ridotto** (0,65 / 0,5 / 0,3 / 0,25): il DD atteso scala
   ~linearmente col rischio per trade. Es. ORB a 0,3%: promessa 9,9% × 0,3 ≈
   **3,0%**. Il confronto forward va fatto DOPO questa conversione.
3. **Op/mese promesse** = n trade OOS del backtest ÷ mesi della finestra OOS
   **dello stesso referto** (non medie di altri studi). Dove il tester conta
   le CHIUSURE parziali (PTE/SW/MaxMin: ~2-3 chiusure per posizione) è
   indicato: per la C3 contano le POSIZIONI.
4. Le finestre "~13 mesi" sono l'OOS standard delle famiglie di agosto
   (split 40/60 su storico BCM dal 2024.09.26 → OOS ≈ 2025.06→2026.06/08).

---

## 🚨 PRIMA LE URGENZE — LE SEDIE SENZA CONTRATTO (2)

**In campo senza che nessuno abbia mai scritto perché.** Peggio: per entrambe
esistono misure NEGATIVE agli atti.

| EA | Simbolo | Magic | Rischio | DD promesso | Op/mese | Finestra | Fonte | Etichetta |
|---|---|---|---:|---|---|---|---|---|
| ABTG_Nasdaq_Apertura_US ⛔ **SPENTA dal 18/08 09:41** (vedi nota sotto la tabella) | NASUSD | 770201 | 0,25 | **NESSUNO** — mai promossa. Anzi: tick reali 31/07 **PF 0,82 · DD 17% · SCARTATO**; walk-forward 05/08: **19/20 celle OOS negative** | n/d | — | `PROMEMORIA_APERTURE.md` (31/07) · `Walkforward_Aperture/REFERTO_WALKFORWARD.md` §Verdetti | 🔴 **[SENZA CONTRATTO]** |
| BREAKOUT_EA_JPY_v3 | USDJPY | n/d | n/d | **NESSUNO** — famiglia **SCARTATA** pre-progetto (paniere 7 cross JPY 2022-24: **−20.853 €, PF 0,67-0,95 su TUTTE, DD 30-48%**); della v3 non esiste alcun referto | n/d | — | `docs/Portafoglio_Strategie.md` §Breakout JPY | 🔴 **[SENZA CONTRATTO]** |

> ### ⚠️ CORREZIONE DEL 21/08/2026 — questa tabella e' invecchiata in nove ore
>
> **`ABTG_Nasdaq_Apertura_US` NON e' piu' accesa, e non lo era gia' quando
> questo file e' stato pubblicato.** Questo censimento e' costruito sulla foto
> dei `.chr` delle **18/08 00:01**; nella foto delle **18/08 09:41** — la
> verifica della FIRMA 5, *"SPEGNILE TUTTE E TRE"* — la riga **non c'e' piu'**,
> e resta assente in tutte e tre le misure del 19/08 (11:53, 15:24, 15:34).
>
> **`BREAKOUT_EA_JPY_v3`, al contrario, e' presente in TUTTI e sette i
> censimenti**, ultimo compreso: NON e' mai stata spenta, malgrado
> `STATO_QUATTRO_STRATEGIE_2026-08-21.md` la dia per spenta.
>
> Decisione di Claudio del 21/08 (**"A, SU JPY, B SU NASDAQ"**) e verbale
> completo: `report/FIRMA_2026-08-21_DUE_SEDIE.md`.

_Entrambe risultano tenute "per osservazione" (decisione Claudio 01/08 di far
girare tutta la flotta), ma la C3 su di loro non ha alcun metro: qualunque DD
fanno, non violano niente perché nessuno ha promesso niente. Da decidere:
o si scrive un contratto (misura nuova) o si dichiara formalmente lo stato._

## 🟡 CONTRATTO PARZIALE (2)

| EA | Simbolo | Magic | Rischio | DD promesso | Op/mese | Finestra | Fonte | Etichetta |
|---|---|---|---:|---|---|---|---|---|
| ABTG_SupertrendReversal_Ottimizzato | XAUUSD | 970901 | 1,0 | **DD 9,0%** (R99: massimo equity su 22 anni 2004→2026, OHLC M1 = LIMITE INFERIORE, 657 op, gemelli identici) · **peggior giornata attesa ~0,7%** [APPROSSIMATO, chiusure realizzate] · nessuna finestra di regime concentra il rischio (max 2,69% nel TORO 2021) · 2008: 1,79% · 2013: 0,44% · ⚠️ a rischio 2% i numeri RADDOPPIANO (~18% = fuori muro prop) | ~2,5 (657 op / 264 mesi, misurata R99) | **2004.06.11→2026.06.30 (22 anni, R99)** | `risultati_archivio/R99_REFERTO.md` · zip `R99_ORO_22ANNI_CORSA_20260823_1333` | 🟢 **[PIENO da R99]** — riempito il 23/08/2026 su firma di Claudio ("FIRMO, RIEMPI IL CONTRATTO CON QUEI NUMERI"). Caveat: 39/42 input della cella = default del sorgente [DA CONFERMARE col .chr del grafico vivo] |
| Gold_Ichimoku_TK_ATR_EA | XAUUSD | 250604 | 0,5 | Verifica MT5: **PF 1,31 · DD 4,38% a rischio 0,3%** (a 0,5% ≈ 7,3%) · 217 trade. ⚠️ Ma la validazione vale "su broker a spread stretto" (Tickmill PF 1,54): **su BCM lo stesso test dava PF 1,01 / DD 28%** — e la sedia gira su BCM | ~7,2 (217 tr / 30 mesi) | 2024.01→2026.06 (tick 78%) | `docs/Portafoglio_Strategie.md` §Gold Ichimoku | 🟡 **[PARZIALE]** — numeri pre-imbuto, broker sbagliato, mai passata dai round |

## 🟢 CONTRATTO PIENO (40)

### 🏛️ Le 5+1 storiche del portafoglio R16 (per-trade 100k · OOS 2025.06.10→2026.06.30, 12,6 mesi · rischio 1%)

| EA | Simbolo | Magic | Rischio | DD promesso | Op/mese | Finestra | Fonte | Etichetta |
|---|---|---|---:|---|---|---|---|---|
| ABTG_DAX_Apertura_EU | D30EUR | 770101 | 1,0 (+0,65 sul 100k) | **6,25%** (R16; la griglia R46 sulla cella LIVE dà 7,23%) | **~21** (270 tr) | OOS 12,6 mesi | `REFERTO_PORTAFOGLIO_R16.md` tab. serie · `REFERTO_ROUND46_GESTIONE.md` riga "A = LIVE" | ✅ [TROVATO] |
| ABTG_Dow_Apertura_US | U30USD | 770202 | 1,0 (+0,65) | **4,22%** (R16; R54 riconferma la cella live: 4,39%, PF 1,270) | **~10** (130 tr) | OOS 12,6 mesi | `REFERTO_PORTAFOGLIO_R16.md` · `REFERTO_ROUND54_LATI_DOW.md` §1 | ✅ [TROVATO] |
| ABTG_ORB_Ottimizzato | U30USD | 770611 | 1,0 (+0,3) | **9,92%** (R15, col **doppio asterisco**: passa il muro 10% per 8 centesimi, cella di confine; R16 a 100k: 9,72%) — a 0,3% ≈ 3,0% | **~9,4** (119 tr) | OOS 12,6 mesi | `REFERTO_ROUND15_ORB_GESTIONE.md` · `REFERTO_PORTAFOGLIO_R16.md` | ✅ [TROVATO] |
| ABTG_MaxMinNotte_DAX_Short_Ottimizzato | D30EUR | 770411 | 1,0 (+0,65) | **1,27%** (R16; la promozione 26/07: PF 2,05 · DD 3,1% · 41 tr, corr S&P ON) | **~1,7** (21 tr) | OOS 12,6 mesi | `REFERTO_PORTAFOGLIO_R16.md` · `REGISTRO_TEST.md` §MaxMinNotte raffinamento | ✅ [TROVATO] |
| ABTG_SupertrendReversal (Nikkei H2) | 225JPY | 770901 | 0,65 | **0,88%** (R5 cella H2, 100k; R16: 0,65%) — a 0,65% ≈ 0,6% | **~4** (50 tr) | OOS 12,6 mesi | `REFERTO_ROUND5_NIKKEI.md` · `REFERTO_PORTAFOGLIO_R16.md` | ✅ [TROVATO] |
| ABTG_MaxMinNotte (oro notte) | XAUUSD | 770402 | 1,0 | **5,3%** (R17, cella 250/H2, PF 1,91) | **~3,7 posizioni** (~9 chiusure: 82 chiusure ≈ 33 posizioni / 9 mesi) | OOS 2025.09→2026.06 (9 mesi — storico oro dal 28/02/2025) | `REFERTO_ROUND17_ORO_NOTTE.md` · agg. R19b in `REFERTO_PORTAFOGLIO_R16.md` | ✅ [TROVATO] |

### 🪑 Vivaio R23 — PTE e SuperWave (per-trade 100k · OOS ~12,5 mesi · rischio 1%)

| EA | Simbolo | Magic | Rischio | DD promesso | Op/mese | Finestra | Fonte | Etichetta |
|---|---|---|---:|---|---|---|---|---|
| ABTG_PTE | U30USD | 771321 | 1,0 | **2,18%** | **~3,2** (40 chiusure) | OOS ~12,5 mesi | `REFERTO_ROUND23_PERTRADE.md` tab. serie · deploy `report/VIVAIO_R23_DEPLOY.md` | ✅ [TROVATO] |
| ABTG_PTE | GBPUSD | 771322 | 0,5 (dal 17/08) | **2,64%** — a 0,5% ≈ 1,3%. ⚠️ R78 (OHLC 13 anni): la stessa cella fa **−2.125 · PF 0,972 · DD 17,68%** — contratto e finestra lunga non conciliabili, giudice = forward (duello) | **~3,9** (49 chiusure) | OOS ~12,5 mesi | `REFERTO_ROUND23_PERTRADE.md` · ⚠️ `REFERTO_ROUND78_SEDIA_VERA_FINESTRA_LUNGA.md` | ✅ [TROVATO] |
| ABTG_PTE | USDJPY | 771323 | 1,0 | **3,97%** ⚠️ R77/R78 su 13 anni: **1 cella positiva su 14 (PF 1,011)** — su finestra lunga il motore non ha edge su USDJPY | **~2,8** (35 chiusure) | OOS ~12,5 mesi | `REFERTO_ROUND23_PERTRADE.md` · ⚠️ `REFERTO_ROUND77/78` | ✅ [TROVATO] |
| ABTG_PTE (candidata R78) | GBPUSD | 771332 | 0,5 | **9,87%** (PF 1,095, pegg. giornata −1,35%) — a 0,5% ≈ 4,9% | **~3** (477 tr / 158 mesi ≈ 36/anno) | **OOS 2013.04→2026.06, 13 anni, OHLC** (tick lungo impossibile su BCM) | `REFERTO_ROUND78_SEDIA_VERA_FINESTRA_LUNGA.md` §2 · duello in `FLOTTA_ATTIVA.md` | ✅ [TROVATO] |
| ABTG_SuperWave (H2) | U30USD | 770531 | 1,0 | **2,96%** | ~7 chiusure ≈ **~4 posizioni** (88 chiusure/50 posizioni) | OOS ~12,5 mesi | `REFERTO_ROUND23_PERTRADE.md` | ✅ [TROVATO] |
| ABTG_SuperWave (H2) | GBPUSD | 770532 | 1,0 | **1,04%** | **~5 chiusure** (63) | OOS ~12,5 mesi | `REFERTO_ROUND23_PERTRADE.md` | ✅ [TROVATO] |

### 📈 EMA200 (sedia 12) e vecchi Ottimizzati del 26/07

| EA | Simbolo | Magic | Rischio | DD promesso | Op/mese | Finestra | Fonte | Etichetta |
|---|---|---|---:|---|---|---|---|---|
| ABTG_EMA200 | U30USD | 771531 | 1,0 | **7,21%** (cella CENTRO O1 0,20/O2 0,3/TP 2,0 · PF OOS 1,52 · regione 30/30 PASS) | **~33-35** (444 tr / 12,5 mesi; R29: 32,8 tr/mese OOS) | OOS ~12,5 mesi (serie R31: 12/06/2025→26/06/2026) | `REFERTO_ROUND29_EMA200_WF.md` · `REFERTO_ROUND31_EMA200_PORTAFOGLIO.md` | ✅ [TROVATO] |
| ABTG_EMA200_Ottimizzato | XAUUSD | 971501 | 1,0 | **4,4%** (PF 1,92 · Recovery 3,68 · superficie 100% positiva) | **~6,6** (199 tr / 30 mesi) | 2024.01→2026.06, tick reali (25/07) | `backtest_pipeline/RISULTATI_OTTIMIZZAZIONE.md` §EMA200_Ottimizzato | ✅ [TROVATO] |
| ABTG_SupRev_DAX_H4_Ottimizzato | D30EUR | 970912 | 1,0 | **5,7%** (PF 1,96 · 86 tr, validazione real-tick 26/07) ⚠️ revalidation 30/07: PFmed reale **1,05 marginale** | **~4** (86 tr / ~21 mesi reali) | 2024.01→2026.06 nominale (tick indici dal 2024.09.26) | `REGISTRO_TEST.md` §4 S4v · nota in `FLOTTA_ATTIVA.md` | ✅ [TROVATO] |
| ABTG_SupRev_DOW_H4_Ottimizzato | U30USD | 970914 | 1,0 | **4,0%** (PF 2,77 · 79 tr) — ⚠️ **PROMOZIONE POI REVOCATA**: revalidation pulita PFmed reale **0,79, illusione OHLC** (30/07). La sedia gira comunque, "scartata ma in osservazione" | **~3,8** (79 tr / ~21 mesi) | 2024.01→2026.06 nominale | `REGISTRO_TEST.md` §SupRev nuovi indici · revoca in `CLASSIFICHE.md` §Scartati e `FLOTTA_ATTIVA.md` | ✅ [TROVATO] (contratto revocato agli atti) |
| ABTG_SupRev_NAS_H1_Ottimizzato | NASUSD | 970913 | 1,0 | **1,17%** (PF 1,57 · 8/8 combo positive — il prop-friendly ⭐) | **~7,4** (155 tr / ~21 mesi) | 2024.01→2026.06 nominale | `REGISTRO_TEST.md` §4 S5v · `CLASSIFICHE.md` | ✅ [TROVATO] |
| ABTG_SuperWave_DOW_H1_Ottimizzato | U30USD | 770511 | 1,0 | **4,0%** (PF 1,52 · 9/9 combo positive) | **~10,8** (227 tr / ~21 mesi) | 2024.01→2026.06 nominale | `REGISTRO_TEST.md` §SuperWave validazione | ✅ [TROVATO] |
| ABTG_SupertrendReversal (Nikkei H4 FW) | 225JPY | 770924 | 1,0 | **0,14%** (PFmed tick reali 1,05 — marginale, "poco attivo") | **~1** (21 tr / ~21 mesi) | 2024.01→2026.06 nominale, tick 30/07 | `CLASSIFICHE.md` §2 SupertrendReversal · `FLOTTA_ATTIVA.md` | ✅ [TROVATO] |

### 🧪 Le famiglie di agosto — Breaking Band, Gap-fill, Larry, Cost-to-cost, Easy Trend (walk-forward IS 40/OOS 60, storico dal 2024.09.26, rischio 1%)

| EA | Simbolo | Magic | Rischio | DD promesso | Op/mese | Finestra | Fonte | Etichetta |
|---|---|---|---:|---|---|---|---|---|

> ### 🗣️ NOTA DI DISEGNO — famiglia BREAKING BAND (dichiarata da Claudio il 21/08, fonte: coach Leonardo)
> **"ATR x 3 e' veramente difficile che venga toccato: e' stato fatto apposta cosi'."**
> Lo stop largo e' una scelta del metodo: il motore guadagna dalla **frequenza**
> di piccole vincite sulla mediana, non dalla loro taglia. Confermato per via
> indipendente da **R91** (il filtro di RR minimo tagliava i trade migliori:
> +193 / +184 / +66 di aspettativa a trade -> bocciato su tutti e tre i simboli).
> 📌 **Conseguenza per il forward**: per questa famiglia la metrica da sorvegliare
> **non e' il win rate** (sara' sempre alto per costruzione) ma le **perdite
> consecutive** e la **peggior giornata** — il rischio sta nella coda.


| ABTG_BreakingBand | GBPUSD | 772161 | 1,0 | **1,9%** (100k R34; WF R33: 3,4% · PF 1,75) | **~2,0** (26 tr / 13 mesi) | OOS 2025.06→2026.06 | `REFERTO_ROUND33_BREAKINGBAND_WF.md` · `REFERTO_ROUND34_BB_PORTAFOGLIO.md` | ✅ [TROVATO] |
| ABTG_BreakingBand | EURUSD | 772162 | 1,0 | **1,2%** (solo CONT · PF 3,87 — nota: IS con 4 trade) | **~1,0** (13 tr) | OOS 2025.06→2026.06 | R33 · R34 | ✅ [TROVATO] |
| ABTG_BreakingBand | AUDUSD | 772163 | 1,0 | **1,2%** (solo INV · PF 2,76) | **~0,8** (11 tr) | OOS 2025.06→2026.06 | R33 · R34 | ✅ [TROVATO] |
| ABTG_GapFill | AUDUSD | 772233 | 1,0 | **1,9%** (WF R36 · PF 2,89; 100k R37: 1,0%) | **~0,9** (12 tr) | OOS ~13 mesi | `REFERTO_ROUND36_GAPFILL_WF.md` · `REFERTO_ROUND37_GAP_PORTAFOGLIO.md` | ✅ [TROVATO] |
| ABTG_GapFill | GBPUSD | 772231 | 1,0 | **2,4%** (PF 5,03; 100k: 1,0%) | **~0,6** (8 tr) | OOS ~13 mesi | R36 · R37 | ✅ [TROVATO] |
| ABTG_GapFill | EURUSD | 772232 | 1,0 | **1,5%** (fill 50 · PF 2,74; 100k: 1,0%) | **~0,7** (9 tr) | OOS ~13 mesi | R36 · R37 | ✅ [TROVATO] |
| ABTG_GapFill | U30USD | 772234 | 1,0 | **2,3%** (PF 1,30) — sedia 19 **in OSSERVAZIONE**: promossa R36 ma esclusa dal portafoglio (R37: cumulo del lunedì), porta 100k chiusa | **~1,5** (20 tr) | OOS ~13 mesi | R36 · esclusione in R37 · stato in `HANDOFF.md` | ✅ [TROVATO] |
| ABTG_GapFill | 225JPY | 772235 | 1,0 | **4,3%** (PF 1,14 — il promosso più tirato; richeck R65: +811 · PF 1,144 · DD 4,36%) — sedia 20 in OSSERVAZIONE, come sopra | **~1,2** (15 tr) | OOS ~13 mesi | R36 · R37 · `REFERTO_ROUND65_GAPCONTINUATION.md` §GapFill | ✅ [TROVATO] |
| ABTG_PunteLarry | U30USD | 772341 | 1,0 | **3,9%** (PF 1,78, L+S) | **~2,9** (38 tr) | OOS ~13 mesi | `REFERTO_ROUND38_PUNTE_LARRY.md` tab. WF · deploy R39 | ✅ [TROVATO] |
| ABTG_PunteLarry | EURAUD | 772342 | 1,0 | **3,7%** (PF 1,74, L+S) | **~2,5** (33 tr) | OOS ~13 mesi | R38 · R39 | ✅ [TROVATO] |
| ABTG_PunteLarry | XAUUSD | 772343 | 1,0 | **3,5%** (PF 4,23, solo L — **n=11, riserva campioni**) | **~0,8** (11 tr) | OOS ~13 mesi | R38 · R39 | ✅ [TROVATO] |
| ABTG_PunteLarry | GBPJPY | 772344 | 1,0 | **2,7%** (PF 2,00, solo L) | **~1,5** (20 tr) | OOS ~13 mesi | R38 · R39 | ✅ [TROVATO] |
| ABTG_PunteLarry | GBPUSD | 772345 | 1,0 | **5,1%** (PF 1,84, solo S) | **~1,9** (25 tr) | OOS ~13 mesi | R38 · R39 | ✅ [TROVATO] |
| ABTG_PunteLarry | EURCAD | 772346 | 1,0 | **4,8%** (PF 1,25 — "il più tirato") | **~1,5** (19 tr) | OOS ~13 mesi | R38 · R39 | ✅ [TROVATO] |
| ABTG_CostToCost | EURJPY | 772361 | 1,0 | **9,33%** (flip di struttura, solo L · PF 1,74 · pegg. giornata −3,97%) | **~4,7** (64 tr / 13,5 mesi) | OOS ~13,5 mesi | CSV `risultati_prove/ABTG_CostToCost/r40/` (OOS, cella L) · `REFERTO_ROUND41_COST_PORTAFOGLIO.md` | ✅ [TROVATO] |
| ABTG_CostToCost | GBPCAD | 772362 | 1,0 | **6,18%** (R-based 1,5R, solo L · PF 1,44) | **~4,6** (62 tr) | OOS ~13,5 mesi | CSV r40 · R41 | ✅ [TROVATO] |
| ABTG_CostToCost | XAGUSD | 772363 | 1,0 | **4,48%** (cost puro, solo L · PF 1,25) | **~3,0** (41 tr) | OOS ~13,5 mesi | CSV r40 · R41 | ✅ [TROVATO] |
| ABTG_EasyTrend | GBPUSD | 772422 | 1,0 | **4,58%** (TP 1,5 L+S · PF 1,49) — sedie 30-32 **in OSSERVAZIONE**: promosse R48, famiglia BOCCIATA in portafoglio (R49), porta 100k chiusa | **~2,9** (41 tr / 14 mesi) | OOS ~14 mesi (dal 2024.09.26, IS 8,5 mesi) | `REFERTO_ROUND48_EASYTREND_WF.md` · bocciatura `REFERTO_ROUND49` | ✅ [TROVATO] |
| ABTG_EasyTrend | AUDJPY | 772423 | 1,0 | **4,29%** (TP 1,0 L+S · PF 1,37) — osservazione, come sopra | **~3,9** (54 tr) | OOS ~14 mesi | R48 · R49 | ✅ [TROVATO] |
| ABTG_EasyTrend | CHFJPY | 772421 | 1,0 | **6,27%** (TP 1,5 L+S · PF 1,25) — osservazione, come sopra | **~3,8** (53 tr) | OOS ~14 mesi | R48 · R49 | ✅ [TROVATO] |

> 🔎 **Nota del 18/08 sera — incrocio col CORSO (referto:
> `backtest_pipeline/caccia_strategie/ANALISI_CORSO_EASYTREND_2026-08-18.md`,
> spec: `backtest_pipeline/prove/EASYTREND_CORSO_SPEC.md`).** Tre cose che il
> contratto qui sopra non dice e che servono a leggerlo:
> 1. **Universo FUORI FONTE.** Il corso (Leonardo Fasciano, lez. 13 e 17)
>    dichiara **EURUSD, EURGBP, EURCAD**. Le tre sedie sono CHFJPY / GBPUSD /
>    AUDJPY: **intersezione zero**. EURGBP e' stata **bocciata** in R48 e rossa
>    in tutte e 8 le celle di R53; EURUSD e' **nona** allo scan 48. L'imbuto ha
>    fatto il suo mestiere, ma il forward di queste sedie **non conferma e non
>    smentisce il corso**.
> 2. **TP 1,5 = deviazione MISURATA, non refuso.** Il corso insegna **RR 1:1**;
>    CHFJPY e GBPUSD girano a **1,5** perche' lo scan 48 ha trovato che _"il TP
>    1,5 batte il RR 1:1 della fonte quasi ovunque"_. Il default del codice e'
>    1,0 (fedele): a cambiare la regola sono i **preset** (`deploy_vivaio_ez.ps1`).
> 3. **Win rate implicito** — con RR fisso e due sole uscite (nessun BE, nessun
>    trailing) vale `WR = PF/(PF+TP_R)`: **GBPUSD 49,8% · AUDJPY 57,8% ·
>    CHFJPY 45,5%**, contro il **70% dichiarato dal corso**. E' la sveglia piu'
>    rapida su queste sedie: con RR 1:1 il pareggio lordo sta al 50%.

### 🎌 L'esterna — GapContinuation (R65/R66, tick reali 100k, rischio 1%)

| EA | Simbolo | Magic | Rischio | DD promesso | Op/mese | Finestra | Fonte | Etichetta |
|---|---|---|---:|---|---|---|---|---|
| ABTG_GapContinuation | 225JPY | 774101 | 1,0 | **11,59%** (PF 1,398 · pegg. giornata −1,10% · zero overnight) ⚠️ contratto con 3 avvertenze scritte: short in perdita (−2.182), perdite in GRUPPO (Z −4,03, 6 di fila nel carattere), cella = PICCO non altopiano (R66) | **~3,7** (n=70 chiusure, ~47 giornate / 12,7 mesi, OneTradePerDay) | OOS 2025.06.10→2026.06.30 | `REFERTO_ROUND65_GAPCONTINUATION.md` · `REFERTO_ROUND66_GAP_ALTOPIANO.md` · scheda in `FLOTTA_ATTIVA.md` | ✅ [TROVATO] |

---

## 🧮 SINTESI

**Su 44 sedie di trading censite: 40 con contratto PIENO · 2 PARZIALE · 2
SENZA CONTRATTO.**

- 🔴 **Le 2 senza contratto**: `ABTG_Nasdaq_Apertura_US` NASUSD 770201 (in
  campo a 0,25% con DUE verdetti negativi agli atti) e `BREAKOUT_EA_JPY_v3`
  USDJPY (famiglia scartata nel 2026 pre-progetto, nessun referto della v3,
  nemmeno l'input di rischio leggibile). **Per la C3 sono fuori metro: niente
  DD promesso = la corsia RISCHIO non può scattare.**
- 🟡 **La parziale rimasta (1)**: `Gold_Ichimoku` XAUUSD 250604
  (numeri pre-imbuto, validati su ALTRO broker, su BCM il test storico era
  PF 1,01/DD 28%).
  _(`SupertrendReversal_Ottimizzato` XAUUSD 970901 e' stata RIEMPITA il
  23/08/2026 coi numeri di R99 — 22 anni, DD 9,0% a rischio 1% — su firma
  di Claudio: la riga sta nella tabella dei parziali per storia, ma
  l'etichetta ora e' PIENO da R99.)_
- ✅ **Le 40 piene** hanno DD promesso E frequenza promessa, col riferimento
  esatto. Dentro le 40 restano dichiarate le situazioni particolari:
  - `SupRev_DOW_H4_Ottimizzato` 970914: contratto scritto ma **promozione
    revocata** (illusione OHLC) — gira da "scartato in osservazione";
  - le 5 sedie **in OSSERVAZIONE** (GapFill Dow/Nikkei, EasyTrend ×3):
    contratto di cella valido, porta 100k chiusa da bocciatura di portafoglio;
  - le PTE storiche: contratto R23 (finestra ~12,5 mesi) contraddetto dalla
    finestra lunga R77/R78 — il duello GBPUSD è il giudice, e il contratto
    C3 resta quello della promozione (R23) finché una firma non lo cambia;
  - ORB 770611: promessa col **doppio asterisco** originale (DD 9,92% a un
    soffio dal muro), oggi mitigata dal rischio 0,3%.
- 🧰 **Utility escluse** (non tradano): Guardian 779001, TradeExporter ×2.
- 📌 **Nota di perimetro**: nel censimento del 18/08 NON compaiono le vecchie
  sedie della squadra forward di fine luglio (SupRev 770921-23/770925,
  GoldenCross 770331-33/970301, EMA200 771511-15, SupRev_Multi_Ott 971001,
  ecc.): se risultassero ancora accese su un terminale non censito, il loro
  contratto andrà aggiunto qui. Questa tabella copre le sedie del censimento,
  come da missione.

_Compilato il 18/08/2026 (M11). Nessun numero inventato: ogni cifra ha il suo
file. Se un referto e questa tabella divergono, comanda il referto._
