# CENSIMENTO DEGLI ORB (indici e oro) — 29/09/2026

**Mandato di Claudio (29/09):** *«Dobbiamo rivedere EA ORB sia sugli indici che oro.»*
**Natura del documento:** SOLA LETTURA. Nessun backtest eseguito, nessun file prova o riga di lancio creati, nessun EA, preset o conto toccato, nessuna taglia proposta. Le decisioni sono di Claudio.
**Regole di lettura:** certificato di morte a 5 punti (PF · n+DD · uscita ad asse · gemelli · TF) del 09/09; finestra in operazioni (Emendamento A: il merito si legge sopra 150 operazioni, il rischio a qualunque n); regola dei due lati sugli indici; orologio BCM UTC+1 fisso (`report/OROLOGIO_BCM_2026-09-24.md`); centro dell'altopiano mai il picco; **un numero OHLC non e' un verdetto**.
**Etichette:** `[MISURATO]` = riletto da me su CSV/referto in questa sessione · `[LETTO]` = riportato da un referto, non riaperto · `[DERIVATO]` = calcolato da numeri scritti · `[NON MISURATO]` = il dato non c'e'.
**Convenzione sui nomi:** nessun magic e nessuna taglia in questo documento (per richiesta del mandato); i motori si citano per nome di EA e simbolo.

---

## 0. LA RIGA IN DIECI

1. **26 righe di censimento, su 19 file EA distinti piu' 3 fonti esterne o senza EA.** Solo **due** righe superano 150 posizioni in OOS a tick reali: DAX Apertura long (193) e il Dow breakout a due lati (197); Nasdaq RETEST (102) e Dow long (96) restano sotto.
2. **Il certificato completo a 5 punti non e' pieno su NESSUN motore ORB.** I piu' vicini sono le tre sedie della famiglia Apertura che gia' operano (§8): hanno ①②③ pieni, e mancano i **gemelli** (④) e il **TF/orologio** (⑤).
3. **Il breakout nudo al tocco e' chiuso con i numeri nostri** (R12 48/48 negative OOS, R45 0/48, R97 0/4 con n=135, ~210 celle): non si riapre. **Quello che paga e' il RETEST** (e, sul Dow, il breakout filtrato con EMA H4): la regola «ORB/breakout apertura = chiusi» del registro e' vera per il **breakout secco**, non per la famiglia.
4. **La misura «range 35-45 min = 8 su 8 OOS positive, 5-15 min = 0 su 8» e' REALE ma e' una lettura SOLO-OOS e SOLO-DAX** (§5): sul DAX in IS il breakout a 5-15 min e' positivo 7 su 8; sul Dow retest il 15 min e' positivo in OOS (PF 1,42); sul Nasdaq 35-45 vale 1 su 8. **Il solo valore positivo in entrambe le finestre sul DAX e' 35.** Emiliano (15 min): contraddetto sul DAX in OOS, non contraddetto sul Dow in OOS.
5. **Lato ORO: nessun ORB e' schierabile e nessuno e' misurato a tick.** ORB su oro = R10 (4 celle, tutte rosse), R45a (Londra, 0/8), la sonda 15:30 su M1 (fenomeno assente + costo 5-6x) e un EA di terzi (`ORB_GOLD_FIBONACCI_EA`) **mai girato**. MaxMinNotte oro e' un box notturno, **non un ORB** (§10).
6. **Orologio:** dal 26/10 (DAX) e dal 02/11 (USA) tutti gli ORB a ora fissa armano un'ora prima dell'apertura cash sui terminali BCM. **Nessun numero di contratto dei motori d'apertura e' pulito da questo** (44-62% di uscite da mesi sfasati).
7. **Contraddizioni trovate: 12** (§9). Le due che cambiano una decisione: la cella viva del Nasdaq RETEST ha **due contratti** (PF OOS 1,10936 contro 1,21546, celle e banchi diversi) e il registro dice ancora «Londra ORB mai un CSV» **dopo** che R258 li ha prodotti.
8. **Lacune piu' economiche:** ORB_Fibo a tick (2 passate), TrailTF del DAX long (4), orologio/uscita del Nasdaq RETEST (4-6), gemelli del DAX long su F40/E50/E35 (6), gemelli del Dow long (6). Tutte sotto ~1,2 minuti a 0,10 min/passata `[MISURATO, R88]`.
9. **Numeri ricontrollati aprendo i CSV: 12 gruppi** (§11).
10. **Buchi:** stato reale delle sedie sul VPS al 29/09 `[NON RILETTO]`; l'esito della mail FTMO sull'hedging fra conti `[NON VERIFICATO]`; profondita' a tick dell'oro `[NON MISURATO]`.

---

## 1. PERIMETRO — trovato per nome, e cosa NON e' un ORB

**Dentro (opening range con rottura o retest):** `ABTG_DAX_Apertura_EU` (+ `_Ottimizzato`, `_Pin9fca`, `_TrailFix`) · `ABTG_Dow_Apertura_US` (+ copie) · `ABTG_Nasdaq_Apertura_US` (+ `_Ottimizzato`, copie) · `ABTG_Apertura_3Ingressi` · `ABTG_ORB` · `ABTG_ORB_Ottimizzato` · `ABTG_ORB_Fibo` · `ABTG_DAX_Live5m` · `ABTG_DAX_Live5m_v2` · `ABTG_Nasdaq_Live5m` · `ABTG_Londra_ORB` · `ABTG_OpeningReversalB` · `ORB_DAX_BASE_EA` · `ORB_DAX_PM_EA` · `ORB_OpeningRange` · `ORB_GOLD_FIBONACCI_EA` (+ `v3.21`) · esterni: `Nasdaq_PreOpen_Breakout_EA`, `Artemis NAS100 ORB` (solo il file dei parametri) · senza EA: «oro 15:36 su M1» del collega.

**Fuori, dichiarato:** `ABTG_MaxMinNotte` oro (box notturno, non l'apertura) · `ABTG_DAX_M3` (Supertrend H4/M3, errore di categoria) · `ABTG_ImpulsoApertura` (impulso, non range) · `ABTG_GapContinuation` · `ABTG_DaxValueArea` (a M30 degenera in un range, gia' escluso per costo) · `ABTG_Apertura_Study_EA` (strumento) · `ABTG_Apertura_Marco` (ritirato il 06/08, doppione del DAX Apertura).

---

## 2. TABELLA — una riga per motore

Legenda certificato: ① PF · ② n+DD · ③ uscita ad asse · ④ gemelli · ⑤ TF. ✅ fatto · 🟡 parziale · ❌ mancante.
Banco = tick reali BCM, finestra `2024.09.26 -> 2026.06.30` (IS fino al 2025.06.09, OOS dal 2025.06.10), salvo dove scritto. n = deal salvo «pos».

| # | EA · simbolo · TF | range (min) | ingresso | stato oggi | PF IS / OOS · n · DD (banco) | ①②③④⑤ | verdetto |
|---|---|---:|---|---|---|---|---|
| 1 | `ABTG_DAX_Apertura_EU` **long** · D30EUR · M5 | 35 | RETEST limit | **IN CAMPO FTMO**; reale/100k sospesi il 24/09 | 1,126 / **1,397** · 175 / 270 deal (132 / 193 pos) · 5,44 / 7,23% (1%, dep. 100k) | ✅✅✅🟡🟡 | vivo; uscita non «al suo meglio» (ClosePct 0 aperto) |
| 2 | id. **short** (specchio) | 35 | RETEST | **IN CAMPO FTMO** | 0,965 / **0,957** · 138 / 257 deal (194 pos) · 7,47 / **12,31%** | ✅✅✅🟡🟡 | bocciata per rischio e merito |
| 3 | `ABTG_DAX_Apertura_EU_Ottimizzato` · D30EUR · M5 | 15 | breakout, solo long | in flotta ad agosto (`FLOTTA_ATTIVA.md`); stato attuale `[NON VERIFICATO]` | «A2»: PF 1,49, DD 3,8%, 314 tr `[LETTO]` (26/07, senza split IS/OOS) | 🟡❌❌❌❌ | non certificato: **mai girato col proprio nome** |
| 4 | `ABTG_Dow_Apertura_US` **long** · U30USD · M5 | 35 | RETEST | **IN CAMPO FTMO**; 100k sospeso il 24/09 | 1,222 / **1,270** · 74 / 130 deal (56 / **96 pos**) · 5,67 / 4,39% (1%, dep. 100k) | ✅✅✅❌🟡 | vivo, **merito sospeso (96 < 150)** |
| 5 | id. **short** · U30USD | 35 (ancora) | RETEST | non schierata | OOS in fase 0,78 · 46 pos · 5,13-5,31%; finestra piena PF 1,108 · 146 deal · 8,51% | ✅✅✅❌❌ | bocciata per rischio; `stH8` 2,40 su 46 pos = indizio sospeso |
| 6 | **Dow breakout 2 lati** («candidato #1») · U30USD · M5 (`ABTG_Nasdaq_Apertura_US`) | 15 | breakout + EMA H4 | non schierabile | 1,252 / **1,489** · 154 / 197 · 7,10 / 6,86% (1%, dep. 10k) | ✅✅🟡❌❌ | rischio: muro DD fra 1,25 e 1,50x del banco; finestra vergine DD 8,38% sopra p95 |
| 7 | `ABTG_Nasdaq_Apertura_US` **RETEST** · NASUSD · M5 | 35 | RETEST, 2 lati | **IN CAMPO FTMO** | 1,221 / **1,215** · 135 / 172 deal (102 pos) · 7,31 / 7,86% (banco 2%, dep. 80k) | ✅✅✅🟡🟡 | vivo, merito sospeso (102 < 150); **due contratti** (§9 C1) |
| 8 | Nasdaq breakout (H1 precedente) + `_Ottimizzato` | 60 (H1) / 15 | breakout | **spente il 18/08** | best IS 1,13 · OOS mediana 0,878, best 1,012 · n 250-255 · DD fino a 24,2% | ✅✅✅❌❌ | breakout nudo: chiuso |
| 9 | Nasdaq GatedShort · NASUSD · **M15** | H1 prec. | breakdown solo short + gate EMA H4 | **demo piccolo** | OOS 1,097 · 104 · 4,54% (toro); regime orso solo **OHLC** 1,84 · 93 | ✅✅❌❌🟡 | non ancora misurato (solo un lato per costruzione) |
| 10 | Nasdaq GAPFILL (+ Openconfirm) | gap | chiusura del gap | mai in campo | OOS 1,54-2,87 · **n 16-43** · 2,9-6,0% | ✅🟡❌❌❌ | bloccato da regola FTMO sul gap trading, non dal PF |
| 11 | `ABTG_Apertura_3Ingressi` · NASUSD | — | tre ingressi | mai in campo | OOS 0,87 / 0,62 / 0,98 · ~300 · fino a 29,1% | ✅✅❌🟡❌ | non ancora misurato |
| 12 | `ABTG_ORB` (corso) · NASUSD · M5 | **5** (14:25-14:30, pre-apertura) | breakout stop | **spenta 10/08** (bug pendente) | config viva IS **0,824** / OOS 1,050 · 222 / 355 · 24,84 / **19,41%**; R8 volume ON 1,49 / 1,03 · 177-190 · 4,7-4,8% | ✅✅❌❌❌ | non ancora misurato (8 CSV, tutti NASUSD) |
| 13 | `ABTG_ORB_Ottimizzato` · **U30USD** · M5 (la «ORB Dow») | 15 (14:30-14:45) | breakout stop, solo long, EMA200 + trailing | reale/100k sospese il 24/09; piccolo `[NON RILETTO]` | HALFRANGE 1,250 / **1,674** · 71 / 119 · 7,89 / 9,76% (1%); OPPRANGE OOS 1,68 · 119 · 4,30% | ✅✅🟡🟡❌ | merito sospeso (n invariante 71/119); il gemello NASUSD **fallisce** (0,84-0,91) |
| 14 | id. su **NASUSD / D30EUR / XAUUSD / forex** (laboratorio R9-R13, R44b, R45, R97, R10) | 15-65 | breakout | mai in campo | Nasdaq R97 OOS 0,84-0,91 · 135 · 8,2-12,4%; D30EUR R11 OOS 0,94-1,02 · 17,5-29,7%; oro R10 OOS 0,87-0,999 | ✅✅🟡✅❌ | chiuso come breakout secco |
| 15 | id. su **EURAUD H1** (istanza sul reale) | 15 | breakout | attaccata sul reale, **zero riempimenti** | **nessuna misura** | ❌❌❌❌❌ | difetto: livelli a +10,0 in prezzo (ordini irraggiungibili) |
| 16 | `ABTG_ORB_Fibo` · NASUSD · M5 | 30 | LIMIT in Golden Zone 50-61,8% (= retest) | mai in campo | **OHLC** 0,835 / 0,968 · 91 / 75 · 3,02 / 3,10% | 🟡🟡❌❌❌ | non ancora misurato: **zero passate a tick** |
| 17 | `ABTG_DAX_Live5m` / `_v2` · D30EUR · M5 | 5 (pre) | breakout della candela pre-apertura | spente | orig. OOS 0,857 · 342 · 39,7% (2%); v2 0,85-0,95 · 16-26% (1%) | ✅✅🟡🟡❌ | negativi a tick e sotto costo su M5 |
| 18 | `ABTG_Nasdaq_Live5m` · NASUSD · M5 | 5 (pre) | idem | spenta (ultimo trade 06/08) | IS 1,016 / OOS **0,963** · 116 / 175 · 11,5 / 19,4% (2%) | ✅✅🟡🟡❌ | non ancora misurato (asse uscita mai su questo ramo) |
| 19 | `Nasdaq_PreOpen_Breakout_EA` (esterno) | 5 | breakout pre-apertura | mai in campo | **mai girato** | ❌❌❌❌❌ | non si schiera: fuso cablato + costo 13,3x |
| 20 | Artemis NAS100 ORB (a pagamento, solo il file dei parametri) | 15 | OCO + filtro di regime | mai in campo | **nessuna misura** (senza sorgente) | ❌❌❌❌❌ | riferimento per i valori, non candidato |
| 21 | `ORB_DAX_BASE_EA` / `ORB_DAX_PM_EA` (toolkit Emiliano) | 30 | chiusura M5 oltre il range + EMA9/21 | mai in campo | **nessun CSV in tutta la storia** | ❌❌❌❌❌ | non ancora misurato |
| 22 | `ORB_OpeningRange` (generico) | 30 | chiusura oltre il range | mai in campo | **nessun CSV** | ❌❌❌❌❌ | non ancora misurato |
| 23 | `ORB_GOLD_FIBONACCI_EA` (+ v3.21) · XAUUSD · M5 | 30 (15:30-16:00 CET) | LIMIT al 61,8% Fibonacci | mai in campo | **nessun CSV** | ❌❌❌❌❌ | non ancora misurato (§10) |
| 24 | «Oro 15:36 su M1» (collega) | 5 | mercato a rottura M1, uscita 3-4 candele | manuale (33 aperture) | non e' un backtest: sonda su 3.634 giornate | 🟡✅✅✅✅ | **bocciato per costo e per assenza del fenomeno** |
| 25 | `ABTG_Londra_ORB` · GBPUSD/EURUSD · M5 | 60 (06-07 srv) | breakout OCO | mai in campo | R258: GBPUSD OOS 0,74-0,97 · ~300 · 32-55% (dep. fisso) | ✅✅❌🟡❌ | non ancora misurato (uscita mai ad asse) |
| 26 | `ABTG_OpeningReversalB` · U30USD · M5 | — | inversione | mai in campo | IS 1,83 · **2 / 0 operazioni** | ✅❌❌❌❌ | bocciato per frequenza |

---

## 3. SEZIONI BREVI (solo il non ovvio; i numeri sono in tabella)

### M1 — DAX Apertura, lato long (riga 1)
- **Cosa e' gia' provato:** modo d'ingresso (R197A: RETEST batte BREAKOUT), durata del range (R-fase B/D: §5), buffer, offset di retest, trailing (R270c: ATR viola il rischio, fisso peggiore), `InpTP1_R` 0,5-2,0 (R270e: 1,5-2R pari al vivo), soglia d'armo (agosto, 5x5), filtro volumi, slippage (C11), RangeMode (Spearman IS→OOS −0,80 = il vivo e' gia' il migliore), lato (SOLO LONG 6/6 in fase M).
- **Cosa NON e' provato:** `InpTP1_ClosePct=0` come cella unica su questo round (esiste in R46a/R137c: PF OOS 1,491, DD 6,27 su 132/193 pos; guadagno +0,094 sotto il rumore 0,147, e sul Dow perde); **gemelli europei F40EUR/E50EUR/E35EUR MAI provati** (nessun CSV li porta); `InpTrailTF`; MFE/MAE (l'export non li scrive).
- **Lati:** entrambi misurati (regola dei due lati rispettata). Il long e' l'unico dei due vivo per merito.
- **Orologio:** arma alle 08:00 server; dal 26/10 e' un'ora prima di Xetra. Contratto: mesi allineati PF 1,27 (n 144), sfasati 1,48 (n 126) `[LETTO]`. La causa del divario **non e' dimostrata**.

### M2 — DAX Apertura, lato short (riga 2)
R270b/d: nessuna leva d'uscita lo ripara (IS/OOS si ribaltano: soglia d'armo alta OOS 1,06-1,07 con IS 0,76-0,77 e DD 15%). Conferma R251. **Il motore short resta NON ANCORA MISURATO** (gemelli e TF non provati); la sedia a questa cella e' bocciata per rischio (DD 12,31% a 1%, misurato dal picco).

### M3 — DAX Apertura _Ottimizzato (riga 3)
La cella «A2» (26/07: range 15, buffer 600, solo long, Supertrend OFF, PF 1,49 avg 1,25, DD 3,8, 314 tr) e' **in campione e a range 15**: sul DAX il range 15 in OOS e' 0/8 (§5). Va letta come indizio, non come contratto. `_Ottimizzato` non ha mai girato col proprio nome (censimento caselle vuote 22/09).

### M4 — Dow Apertura, lato long (riga 4)
- **Provato:** entry mode (R197A: breakout IS 0,965 a 2%, retest 1,212), offset 400 (R197B: centro dell'altopiano), parziale 50 (R47d: sul Dow SERVE, 50→0 peggiora PF e DD; sul DAX e' l'opposto — due indici, stessa manopola, verso opposto), durata del range 15-60 (r35).
- **Non provato:** gemelli (NASUSD/SPXUSD/DAX con questa cella); TF d'ingresso; il lato short e' su un'altra cella (riga 5).
- **Il 40/40 OOS del Dow** in `Dow_Apertura/` e' di **un'altra sedia** (breakout, range 15, dodici input diversi): non e' il contratto di questa. **Clock:** allineati PF 0,78 (n 73), sfasati 1,66 (n 57) `[LETTO]`: nei mesi in cui arma all'apertura giusta il backtest e' in perdita.

### M5 — Dow short (riga 5)
R255 (24 job, 28/09): ancora bocciata per rischio (OOS in fase PF 0,78 su 46 pos). `stH8` 2,40 / `stH12` 1,26 sono indizi con n < 150. Non provati: `InpRetestOffsetPts`, `InpRangeMinutes` 35 sullo short, gemelli, TF, long+short sulla stessa cella.

### M6 — Dow breakout a due lati, candidato #1 (riga 6)
Unica cella ORB sui **due lati** con PF ≥ 1,10 in IS **e** OOS e n ≥ 150 in entrambe: **1,252 / 1,489, 154 / 197**. Ma: R247 sovrapposizione col Dow long **96% dei giorni** (non diversifica); R248 finestra vergine 01/07-18/09/2026 DD 8,38% fra p95 e p99; R263 **0/48 celle sotto il muro a due volte il banco** (muro fra 1,25 e 1,50x); costo 41,25x «al pelo» (212 giornate su 446 sotto 40x); stagione: estate 0,982 (n 199), inverno 1,800 (n 152). Uscita: `InpTP1_R` 4 valori sì; `InpTrailMode`/`InpTrailFixedPts` no.

### M7 — Nasdaq RETEST (riga 7)
Il breakout nudo sul Nasdaq e' morto; **questo e' lo stesso motore con l'ingresso che paga**. Stop 83,20 (stima) o 117,02 (ricostruzione B): quale sia il vero `[NON MISURATO]`, si legge dalle prime operazioni vere. Provato: entry mode, offset (R198: il 400 del Dow NON si trasferisce), BEatR (R199A ritirata: Dow e DAX la rifiutano), ClosePct 0/25/50/75 (R199B). Non provato: TF/`InpLevelTF`, `InpSessionHour` in fase, **gemelli** (solo NASUSD). Zero operazioni FTMO documentate `[NON MISURATO: il libro affari FTMO non arriva in repo]`.

### M8-M11 — Nasdaq: breakout, GatedShort, GAPFILL, 3 Ingressi (righe 8-11)
Il referto del 23/09 (`report/ORB_NASDAQ_PERCHE_E_SPENTO_2026-09-23.md`) ha il certificato riga per riga: **zero certificati completi su dodici**, sette «NON ANCORA MISURATO». Manopole **inerti** misurate: `InpTrailFixedPts` (96 passate, 9 esiti), `InpUseVolumeFilter` su ORB_Ott NASUSD (48 passate, 24 esiti, 24 coppie su 24 identiche), `InpGapMinPoints` 100-300 (24 passate, 6 esiti). Il TF del grafico non e' mai stato cambiato: il file `NASDAQ_openconfirm_M15` muove `InpOCTimeframe`, che serve solo a `EntryMode=5`.

### M12 — ABTG_ORB del corso (riga 12)
Range di **5 minuti PRE-apertura** (14:25-14:30): dentro il rumore per costruzione. R7a config viva: **la peggiore del lotto** (IS 0,824, DD 24,84). R7b range 35: IS 1,69 su **n=64** / OOS 0,93. R8 (manuale, volume ON): 1,49 → 1,03 (IS→OOS). Forward: +351,51 su 20 operazioni (20/07-10/08) e −86,40 su 7 posizioni (dal 03/08): **la stessa sedia, due finestre, PF 1,85 e 0,54** — n=20 vale zero. Spenta per un bug (`InpOneTradePerDay` non letto), non per il rendimento. Costo: stop 47,70 idx = 26,5x BCM, 31,2x con lo spread FTMO `[DERIVATO]`, **sotto 40x**. Non ha **mai girato su un altro simbolo**.

### M13 — ABTG_ORB_Ottimizzato su U30USD (riga 13)
Prima cella promossa in laboratorio (R15, 09/08): IS 1,223 · DD 8,63 · 71 / OOS 1,657 · DD **9,92** · 119 — «cella di confine», passa il muro per 8 centesimi. R88a/R118a (banco 100k, 1%): HALFRANGE 1,250 / 1,674, DD 7,89 / 9,76; **OPPRANGE** (stop all'estremo opposto): DD OOS 3,70-5,87% su 12/12 celle contro 7,96-12,02% su 12/12 HALFRANGE (le bande non si toccano); ma la cella del buffer 500 e' un **picco su 5 metriche su 5**, e il ramo con una manopola sola (`InpSLMode` 3→0) e' un altopiano monotono (PF 1,680 → 1,642, DD 4,30 → 3,70). **n invariante 71 IS / 119 OOS in tutte le 48 celle**: il buffer sposta lo stop, non decide se si entra; un solo regime. Forward: **3 vinte su 15, −295,58** (fuori dalla rosa il 18/09). Provato: stop, buffer, TP, EMA200, trailing EMA9, parziale (R15: il 50% a 1R indebolisce l'IS), lato (R54b: short PF 0,52, DD 26%), slippage (R55: sfonda il 10% con 1,5 punti). Mai: `InpTP1Pct`>0 col BE (a `InpTP1Pct=0` il breakeven non puo' scattare: no-op), TF≠M5 (**`InpExecTF`=M5 in tutte le passate**), gemelli **provati e negativi** (D30EUR r11 = un'altra ricetta, morta; NASUSD R97 = 0/4).
**R125** (6 file prova, 33 celle, 66 passate, ~7 min): **preparato, MAI girato** (nessun CSV in repo).

### M14 — ORB_Ottimizzato laboratorio su altri mercati (riga 14)
R8-R13 (08/08, ~210 celle a tick): Nasdaq R12 **48/48 negative OOS** (DD fino a 77%), R13 «primo altopiano» (solo long + EMA200 + stop ATR/50% + TP 1,0-1,5x: PF OOS 1,10-1,16, DD 12,3%) poi **smentito da R97** (OOS 0,84-0,91, n=135); D30EUR R11 (scheda «Dax Open Range», range 65'): 11° ribaltamento, Spearman −1,0, OOS 0,94-1,02. **Oro R10:** vedi §10.

### M15 — ORB_Ottimizzato su EURAUD H1 (riga 15)
Istanza sul reale dal 12/09: `InpEntryPoints=10,0` × `InpK=1,0` = +10,0 **in prezzo** su un cambio a 1,62: BUY STOP a ~11,62, **irraggiungibile**. Zero riempimenti, 0 EUR. Non e' mai stata testata in casa. Il pericolo e' la «correzione» con `InpK=0,0001`: stop 2,7-12,5 pip e lotti fino a 3,00. Per 12 giorni ha convissuto con l'istanza Dow sullo stesso magic (nessun danno per costruzione: `CancelPendings` e `SelPos` filtrano per simbolo+magic).

### M16 — ABTG_ORB_Fibo (riga 16)
Non e' un breakout: la rottura fissa la **direzione**, l'ingresso e' un LIMIT nella Golden Zone con stop al 78,6% = **un retest**. Su NASUSD: **1 sola passata utile per finestra** (l'asse dei CSV e' il magic, tecnico), **tutte OHLC**, `InpExecTF`=M5 e `InpORMinutes`=30 in tutte. n OOS 75 < 95 (R125-G4) e < 150. Costo derivato: limite inferiore 9,1x BCM / 10,7x FTMO, **sotto il duro 13,3x**. Il fattore OHLC→tick misurato sul Nasdaq Live5m e' **2,25**: un PF OHLC 0,97 non promette 0,97 a tick.

### M17-M18 — Live5m (righe 17-18)
DAX Live5m: 27/27 combo negative (e per quelle 27 **non esiste nessun CSV**); l'unica cella con CSV OOS 0,857, n 342, DD 39,74% a 2%. Nasdaq Live5m: **27/27 negative**, cella mediana IS 1,016 / OOS 0,963, DD 19,40 `[MISURATO]`; r142a/b/c: l'asse morde (+0,11 PF) ma nessuna cella arriva a 1,10 con n ≥ 150; senza trailing il DD OOS sale a 33,62%. M5 sugli indici e' **escluso per costo** a U30USD (11,5-13,1x contro il duro 13,3x).

### M19-M20 — PreOpen esterno, Artemis (righe 19-20)
PreOpen: `InpLocalUtcOffsetHours=2` **cablato** e ancoraggio a Roma: dal 01/11 arma un'ora prima **in silenzio**; costo 13,33x = pavimento duro. Artemis (Store MQL5, autore e prezzo verificati, 1 recensione): range 15 min, finestra di trading 60 min, buffer 12 punti, stop 1,0×ATR, TP 3,5R, rischio raccomandato dall'autore molto sotto il nostro standard, Recovery Ladder **spenta** di default. Senza sorgente: **serve solo per i valori** (stop in ATR, TP multi-R, filtro di regime sopra l'ORB), non come codice.

### M21-M22 — Toolkit di Emiliano e ORB_OpeningRange (righe 21-22)
`ORB_DAX_BASE_EA`: OR 09:00-09:30 CET, filtro EMA9/21 su M5, trigger = chiusura M5 oltre il range, **rischio di default 3%**, RR 2,5; `ORB_DAX_PM_EA`: stessa logica su 15:30-16:00 CET; `ORB_OpeningRange`: generico, chiusura oltre il range, RR 2, rischio 1%, OR 30 min. **Nessun CSV in tutta la storia git**; «bozze mai integrate» nel giacimento del 03/09; il meccanismo (chiusura confermata + EMA9/21) e' quello di R8/R10/R11, gia' misurato «pareggio». **Orologio:** l'offset CET e' un input (`InpBrokerCETOffset` 0 sul DAX, `ServerToCET` 0 sul generico) **fisso**: d'inverno non segue l'orologio BCM.

### M25 — Londra ORB (riga 25)
Vedi §9 C4: CSV esistono da R258 (28/09). 6 celle ora×simbolo, OOS PF 0,74 / 0,97 / 0,82 (GBPUSD ore 7/8/9) e 0,87 / 0,91 / 0,70 (EURUSD); DD a deposito fisso 30-55%; ore 7 escluse per costo (stop 3-8 pip contro ~11-13 pip di frontiera). L'ora non decide (delta PF 0,33 a n~300 = rumore). Uscita **mai** ad asse: NON ANCORA MISURATO, ed e' gia' in mano a Gemini dal 28/09.

### M26 — OpeningReversalB (riga 26)
IS PF 1,83 su **2 operazioni**, OOS 0: bocciato per frequenza, senza PF misurato. Non e' un candidato: e' un numero mancante.

---

## 4. L'OROLOGIO (estate/inverno BCM) — tutti gli ORB a ora fissa

BCM = UTC+1 fisso: **estate = ora italiana − 1, inverno = ora italiana**. Indici: cambio dal 2024.09.26 (tutto lo storico). Conseguenze per il censimento:
- **DAX (08:00 srv), Dow/Nasdaq (14:30 srv), `ABTG_ORB` (14:25-14:30), `ABTG_ORB_Ottimizzato` (14:30-14:45), Live5m, PreOpen:** dal **26/10** (DAX) e dal **02/11** (USA) armano **un'ora prima** dell'apertura cash sui terminali BCM. FTMO segue l'ora italiana: le sue sedie non hanno lo stesso problema d'orario, ma **d'inverno faranno cio' che il backtest d'inverno non ha misurato**.
- **Numeri di contratto contaminati:** DAX long 47% di uscite da mesi sfasati (PF allineati 1,27 / sfasati 1,48); Dow long 44% (**0,78 allineati / 1,66 sfasati**); il divario non ha causa dimostrata.
- **Toolkit e oro (CET con offset fisso):** `ORB_GOLD_FIBONACCI_EA v3.21` porta `InpBrokerCETOffset=-1` «per BCM»: il **segno** e' `[INFERITO]` dubbio (la funzione somma `offset` ore all'ora server; BCM = CET − 1 d'estate implicherebbe +1) e comunque **fisso** contro un orologio che d'inverno cambia. Da verificare con il cancello prima di qualunque uso, non da me.
- **Londra ORB** (06-07 srv): R258 ha girato con stagioni in fase; l'ora non decide.
- **Nasdaq, R250:** due celle su sei nulle per una uscita fuori orario dopo due festivi USA: con la sola finestra A il verdetto e' «orologio», sotto 150 operazioni: indizio.

---

## 5. LA DURATA DEL RANGE — nostra misura contro Emiliano

**Emiliano (RICORRENTE su 18 live):** il range e' la prima candela **M15** (15 minuti). Paolo (03/09): finestra 14:30-14:45 srv, ma lo strumento `ORB_Indicator_V17` usa 14:25-14:30 (5 minuti PRE). **Le due finestre non si sovrappongono.** La nostra `ABTG_ORB` usa 14:25-14:30 (5 min pre); la `ABTG_ORB_Ottimizzato` usa **14:30-14:45 (15 min)** — verificato nei CSV di R15 (`InpRangeStart/End` 14:30/14:45) e nel referto EURAUD; la riga del registro del 04/09 che dava a entrambe 14:25-14:30 e' sbagliata per la seconda (§9 C12).

**La nostra misura** (`report/DIARIO.md` r.53-54; **riletta dai CSV**: `risultati_archivio/Walkforward_Aperture/{DAX,NASDAQ}_{A_geometria,D_retest}_{IS,OOS}.csv`, 4 celle per durata; Dow: `risultati_prove/aperture_r35/*_r35.csv`, 1 cella per durata, buffer 1000):

| banco · ingresso | finestra | 5 | 15 | 25 | 35 | 45 |
|---|---|---:|---:|---:|---:|---:|
| **DAX** breakout | **OOS** positive/4 | 0 | 0 | 0 | **4** | **4** |
| DAX breakout | IS | 3 | 4 | 4 | 4 | 1 |
| **DAX** retest | **OOS** | 0 | 0 | 2 | **4** | **4** |
| DAX retest | IS | 2 | 3 | 4 | 2 | 0 |
| Nasdaq breakout | OOS | 1 | 0 | 0 | 0 | 0 |
| Nasdaq breakout | IS | 0 | 1 | 2 | 3 | 0 |
| Nasdaq retest | OOS | 0 | 0 | 0 | 1 | 1 |
| Nasdaq retest | IS | 0 | 0 | 1 | 0 | 0 |
| **Dow** retest (PF) | OOS | — | 1,42 | 1,48 | 1,28 | 1,68 |
| Dow retest (PF) | IS | — | 0,82 | 1,14 | 1,21 | 0,85 |

**Lettura onesta:**
1. Il «8 su 8 contro 0 su 8» e' **DAX, OOS**, in entrambi gli ingressi. **Non e' una legge dei range**: in IS il breakout DAX a 5-15 min e' positivo 7 su 8, e il retest a 45 min e' 0 su 4. E' la firma del ribaltamento IS→OOS gia' misurato (Spearman −0,28 sul retest DAX, −0,36 sul Dow).
2. **Il solo valore positivo in entrambe le finestre, sul DAX e per entrambi gli ingressi, e' 35** (breakout IS 4/4 · OOS 4/4; retest IS 2/4 · OOS 4/4). Il «centro dell'altopiano» e' **35, non 35-45** (45 crolla in IS).
3. **Sul Dow** il 15 min in OOS e' positivo (PF 1,42, n 153) e in IS negativo (0,82): **la contraddizione con Emiliano c'e' nei numeri in un verso solo (IS)**; il Dow OOS e' positivo a **tutte e 10** le durate (PF 1,17-1,68).
4. **Sul Nasdaq** nessuna durata regge in OOS (1 su 8 a 35-45): la durata non salva il breakout, coerente con R97.
5. Non e' mai stata misurata la durata **in fase con l'orologio** (i mesi d'inverno sfasati sono dentro tutte le celle).

---

## 6. LACUNE — ordinate per misura piu' corta

Ritmo `[MISURATO]`: 0,101 min/passata (R88: 13,7 min / 136 passate; R125 dichiara ~7 min per 66). Ogni cella = 2 passate (IS + OOS); con l'asse tecnico G1 (2 gemelle sul magic) si raddoppia. Tutte a tick BCM su M5, tranne dove scritto.

### A costo ZERO di macchina (lettura, o dati gia' in casa)
| # | lacuna | costo | cosa produce |
|---|---|---|---|
| Z1 | riconciliare le **due celle** del Nasdaq RETEST (diff campo per campo fra il contratto del 20/09 e R199B) | 0 min | quale cella e' in campo e quale promessa e' vera (§9 C1) |
| Z2 | registro: riga O4 (Londra «mai un CSV») e riga r133b («M30») da correggere | 0 min | coerenza (§9 C4, C5) |
| Z3 | ampiezza d'apertura del Nasdaq: 75,30 (BCM, 15') contro 116,6-176,6 (HistData, 30') **sugli stessi giorni** | minuti di calcolo, dati in cache | sblocca il costo derivato di tutte le righe Nasdaq |
| Z4 | spread FTMO `US100.cash` **alle 16:30 server** (oggi: un tick a mercato chiuso, 1,53) | una notte di logger | chiude il cancello del costo sulla sedia viva |
| Z5 | sonda oro 15:30 estesa a range 30'/60' e a 2021-2026 (strumento esistente, ~9 s di lettura) | ~1 min | se M30/H1 sull'oro passa la frontiera (§10) |

### A macchina, in ordine di durata
| # | misura | passate | minuti | attesa (scritta prima) | contro-esempio |
|---|---|---:|---:|---|---|
| M1 | `ABTG_ORB_Fibo` **a tick**, cella viva, IS+OOS (+ gemelle G1) | 2 (4) | 0,2-0,4 | PF OOS tick **≤ 0,97** (OHLC 0,968); n OOS ~75: merito sospeso a prescindere | se esce ≥ 1,10 con n<150 e' un indizio, non promuove; il fattore OHLC→tick e' stato misurato su un'altra famiglia (2,25) |
| M2 | DAX long: `InpTrailTF` M5 → M15/M30 | 4 (8) | 0,4-0,8 | PF OOS ≈ 1,40 ± rumore 0,15; DD ≈ 7% | se migliora solo perche' cala l'esposizione media (n scende), non e' selezione: confrontare a n pari |
| M3 | Nasdaq RETEST: `InpSessionHour` in fase (14:30 vs 15:30 d'inverno) + `InpLevelTF` | 4-6 (8-12) | 0,4-1,2 | PF OOS 1,15-1,25; se l'orologio conta, l'inverno cala | R250 ha 2 celle su 6 nulle per una uscita fuori orario: verificare i deal prima di leggere il PF |
| M4 | DAX long su **F40EUR / E50EUR / E35EUR** (gemelli, ④) | 6 (12) | 0,6-1,2 | PF OOS 1,0-1,4; n OOS ~190 (correlazione col DAX `[NON MISURATA]`, alta per costruzione: **probabilmente non diversifica il DD**, sale il campione e la frequenza per famiglia) | profondita' a tick di quei simboli `[NON MISURATA]`: se manca, il round e' vuoto |
| M5 | Dow long su **NASUSD / SPXUSD / D30EUR** (gemelli, ④) | 6 (12) | 0,6-1,2 | PF OOS 0,9-1,3; il 400 di offset NON si trasferisce (R198) | gemello con stessa taglia di range in punti ≠ stessa geometria: normalizzare sull'ampiezza |
| M6 | toolkit/generico (`ORB_OpeningRange` su D30EUR e U30USD) per chiudere ① | 4 (8) | 0,4-0,8 | PF OOS 0,9-1,05 (R8/R10/R11) | serve solo a dare un numero al «nessun CSV»: **non e' un candidato** |
| M7 | Dow breakout 2 lati: `InpTrailMode`/`InpTrailFixedPts` ad asse | 6 (12) | 0,6-1,2 | PF OOS 1,4-1,5 | resta il muro del rischio (1,25-1,50x) e la sovrapposizione 96%: la misura non li sposta |
| M8 | **R125** (gia' pronto): ORB_Ott OPPRANGE, 6 file, 33 celle | 66 | ~7 | altopiano OPPRANGE sul buffer (DD 3,7-4,4%); n invariante 71/119 | **non produce una sedia** (dichiarato nei suoi criteri); il gemello NASUSD fa 0,84-0,91 |
| M9 | `ORB_GOLD_FIBONACCI_EA v3.21` su XAUUSD OHLC M1 2020-2026 con commissione | 2-4 | `[NON MISURATO]` (OHLC M1 su 6,5 anni) | PF OOS ≤ 1,0 (R10: 0,87-0,999; oro breakout ORB mai verde) | OHLC su un LIMIT e' ottimista: e' screening, non verdetto; rischio di default 1,5% da mettere al banco |

**Totale M1-M7 ≈ 3-6 minuti di macchina.** La regola del 19/08 e' rispettata: **nessuna griglia sui parametri di ingresso di un motore dichiarato senza edge** (ORB Nasdaq breakout, Live5m, ORB corso). Tutti gli assi sopra sono **uscita, TF/orologio, simboli**.

---

## 7. LA REGOLA DEI DUE LATI — chi e' misurato su un lato solo

| motore | long | short | lettura |
|---|---|---|---|
| DAX Apertura | ✅ 1,397 OOS · 193 pos | ✅ 0,957 OOS · 194 pos | **entrambi misurati**; lo short e' bocciato, il motore short e' ⚪ non ancora misurato (gemelli e TF mai) |
| Dow Apertura | ✅ 1,270 · 96 pos | ✅ 0,78 · 46 pos (R255), finestra piena 1,108 | entrambi misurati; lo short in fase e' sotto 150 |
| Dow breakout 2 lati (candidato #1) | incluso | incluso | i due lati insieme; **il contributo per lato non e' scritto** `[NON MISURATO]` |
| Nasdaq RETEST | incluso | incluso | due lati insieme; per lato `[NON MISURATO]`. La fase M (06/08) ha misurato SOLO LONG/SOLO SHORT sul breakout: Nasdaq **1 cella su 6** positiva (SOLO SHORT 7° ribaltamento IS→OOS) |
| Nasdaq GatedShort | ❌ | ✅ (per costruzione) | **solo short**: il long dello stesso gate non e' misurato |
| `ABTG_ORB_Ottimizzato` | ✅ (per costruzione) | ❌ tranne R54b (PF 0,52, DD 26%) | **il lato non e' mai stato un asse sul Nasdaq** (216 passate, tutte `(1,1)`, `(1,0)` o `(0,0)`) |
| `ABTG_ORB` corso | due lati | due lati | R7/R8 a due lati; **mai per lato** `[NON MISURATO]` |
| `ABTG_ORB_Fibo` | `[NON LETTO]` | `[NON LETTO]` | la cella OHLC e' unica: per lato non c'e' |
| Londra ORB | asse presente (R258) | asse presente (R258) | i due lati nell'asse; il dettaglio per lato non e' nel pacchetto letto |
| Live5m | DAX v2 **solo long** in tutte le 32 passate | mai come lato | `[NON MISURATO]` il lato short v2 |
| oro (R10, R45a) | due lati | due lati | per lato `[NON MISURATO]` |

---

## 8. I PIU' VICINI AL CERTIFICATO COMPLETO — e candidati a una sedia in piu'

Cancelli di casa: **PF ≥ 1,10 in IS e OOS · n ≥ 150 posizioni · DD alla taglia dentro il 10% · stop ≥ 40x (spread+commissione) · frequenza per famiglia (pavimento 1,00 op/giorno a livello di famiglia)**. La taglia e' di Claudio: qui il DD e' al banco, e non si riscala linearmente.

| motore | PF IS/OOS ≥ 1,10 | n ≥ 150 pos | DD al banco (1%) | stop ≥ 40x | certificato |
|---|:--:|:--:|---|---|---|
| **DAX Apertura long** | 1,126 / 1,397 ✅ | OOS **193** ✅ · IS 132 ❌ | 5,44 / 7,23% | 42,3x su 71,9 idx `[MIS n=7]` ✅ al pelo | ①②③ ✅ · ④ ❌ (F40/E50/E35 mai provati) · ⑤ 🟡 (TF inerte, ancorato al calendario) |
| **Nasdaq RETEST** | 1,221 / 1,215 ✅ | OOS **102** ❌ | 7,31 / 7,86% (banco 2%) | 46-77x ✅ | ①②③ ✅ · ④ ❌ · ⑤ 🟡 |
| **Dow Apertura long** | 1,222 / 1,270 ✅ | OOS **96** ❌ | 5,67 / 4,39% | 49x (stima) ✅ | ①②③ ✅ · ④ ❌ · ⑤ 🟡 (durata 15-60 misurata) |
| Dow breakout 2 lati | 1,252 / 1,489 ✅ | **154 / 197** ✅ | 7,10 / 6,86% ma **muro a 1,25-1,50x** | 41,25x, 47,5% dei giorni sotto | ①② ✅ · ③ 🟡 · ④⑤ ❌ |

**Chi porterei a una sedia in piu' per le prop, in ordine:**
1. **DAX Apertura long su un gemello europeo** (M4): stesso motore certificato al ①②③, simbolo nuovo = frequenza per famiglia (il pavimento e' per famiglia, non per sedia) e chiude ④. **Non e' un secondo DD indipendente** (correlazione alta): va sotto il tetto di cluster. Manca la profondita' a tick dei simboli.
2. **Dow breakout 2 lati** e' l'**unico** ORB con n ≥ 150 in entrambe le finestre **e** PF ≥ 1,10 in entrambe, ma e' bloccato dal **rischio** (muro sotto 1,5x il banco) e dal 96% di giorni in comune col Dow long: **e' una sedia di sostituzione, non di aggiunta**.
3. **Nasdaq RETEST / Dow long** restano sospesi sul merito (n < 150) fino a nuove operazioni: il modo economico per salire di n **non esiste su BCM** (lo storico tick parte dal 2024.09.26): si sale con **simboli in piu' (M4/M5)**, non con altre griglie.

**Nessun motore ORB dell'oro** e' in questa tabella (§10).

---

## 9. LE CONTRADDIZIONI FRA REFERTI

| # | contraddizione | fonti | stato |
|---|---|---|---|
| **C1** | La sedia Nasdaq RETEST ha **due contratti**: **PF OOS 1,10936, n 94 pos, DD 3,68% a 1%, banco 10k, `ClosePct=0`, OOS dal 2025.07.01** (contratto del 20/09) contro **PF 1,21546, n 102 pos (172 deal), DD 7,86% a banco 2%, banco 80k, `ClosePct=50`, OOS dal 2025.06.10** (R199B, registro A4 riscritto 22-23/09). Sono **celle e banchi diversi**; R199B Pass 0 (`ClosePct=0`, banco 80k) fa 1,14894 / 102 / 9,12% | `report/CONTRATTI_DELLE_SEDIE_FTMO_2026-09-20.md` r.65 · `risultati_archivio/Walkforward_Aperture/NASDAQ_B_motore_OOS.csv` Pass 8 · `risultati_prove/R199B/*` `[MISURATO]` | **APERTA**: il contratto del 20/09 non e' stato aggiornato; la promessa di DD e di frequenza si legge su quale? Z1 |
| **C2** | DAX Apertura «**morto 3 su 3**» (02/08: 138 passate, PF mediano 0,77-0,79, 2 lati, senza split IS/OOS) contro «**KEEPER**» (26/07: range 15, solo long, PF 1,49) contro «**vivo**» (R270: OOS 1,397) | `risultati_archivio/DAX_Apertura/ANALISI_MOTORI_DAX_M5.md` · registro A1-A2 · R270 | **Sciolta**: erano celle diverse (2 lati senza filtro, mediana della griglia contro cella al centro dell'altopiano). Il «morto» era sulla **mediana**, la sedia sta al **centro** |
| **C3** | «Range 35-45 = 8/8 OOS, 5-15 = 0/8» (DIARIO) contro CSV: **solo DAX, solo OOS**; IS opposto; Dow 15' positivo in OOS; Nasdaq 1/8 | §5 `[MISURATO]` | **Sciolta con precisazione**: la regola non e' universale; il centro sul DAX e' 35 |
| **C4** | Registro O4 (22-23/09): «`ABTG_Londra_ORB` **non ha MAI avuto un CSV**, ha misurato l'ora sbagliata» contro R258 (28/09): **36 CSV**, ore 7/8/9, «l'ora non decide». In piu' R45 (14/08) dichiarava la famiglia ORB «**chiusa su ogni sessione**» con `InpRangeStartHour=7` (la stessa pre-apertura) | `backtest_pipeline/REGISTRO_TEST.md` r.227 · `docs/PER_GEMINI_LONDRA_E_NIGHTLY_2026-09-28.md` · `REFERTO_ROUND45_LONDRA.md` | **APERTA nel registro**: la riga O4 e' rimasta com'era; R258 non e' in registro. Il verdetto corretto e' «NON ANCORA MISURATO» (uscita mai ad asse), non «sigillato» |
| **C5** | Registro riga r133b: «ORB_Ottimizzato **U30USD M30**, PF 1,24979 / 1,67419, DD 7,89 / 9,76, n 71/119» ma il file prova `R133b_filtrovolumi_U30USD.txt` dice `-Periodo M5`, `@PERIODO M5`, `InpExecTF=5`, e i numeri sono **identici alla cella M5 di R88a** | `prove/R133b_filtrovolumi_U30USD.txt` r.12, r.182, r.209 `[MISURATO]` | **APERTA**: etichetta TF sbagliata (o TF inerte). Non e' una misura di M30: la casella ⑤ di ORB_Ott **non** si chiude |
| **C6** | Registro O1: ORB NASUSD «best **PF 1,15**, DD 16%, 625 tr, 50% pos» ma nei CSV di `ABTG_ORB` il massimo OOS e' **1,050** (R7a) e R8 1,03; il **1,15564** e' di `ORB_Ottimizzato r44b` (DD 12,26%) | `risultati_prove/ABTG_ORB/*` `[MISURATO]` · `.../ABTG_ORB_Ottimizzato/r44/*` | **APERTA**: la riga O1 non e' riproducibile dai CSV in repo |
| **C7** | Forward ORB (corso): **+351,51 su 20 op, PF 1,85** contro **−86,40 su 7, PF 0,54** (`CLASSIFICA_CAMPO`); ORB_Ott Dow: R15 OOS PF 1,657 contro forward **3 vinte su 15, −295,58** | `report/ORB_NASDAQ_PERCHE_E_SPENTO_2026-09-23.md` §4.2 · `report/ROSA_DAL_CAMPO_2026-09-18.md` | **Sciolta**: finestre diverse; con n=15-20 il forward non misura nulla (lo scrive lo stesso referto) |
| **C8** | Ampiezza d'apertura Nasdaq: **75,30** (BCM, 15', n=447) contro **116,6 (2025) e 176,6 (2026)** (HistData, 30') | referto 23/09 §7.3 | **APERTA** (Z3): raddoppia gli stop derivati |
| **C9** | Commissione oro: **−3,48 EUR/lotto giro** (n=385, misurata) contro **k = 1,8113 EUR/lotto** (classe 844, «per posizione, V = volume d'ingresso»): rapporto ~1,9 | `report/ORO_1530_CANCELLO_COSTO_2026-09-10.md` · `report/STRESS_ORO_LONG_2026-09-27.md` | **APERTA**: non e' scritto se k e' per lato o per giro; **non riconciliata** |
| **C10** | Lista dei caduti: «ORB/breakout apertura = **chiusi**» (`HANDOFF.md` r.775, registro «capitolo M5 chiuso il 26/07») contro la sedia **RETEST** Nasdaq in campo, il Dow long e il DAX long | HANDOFF · registro · referto 23/09 | **Sciolta**: chiuso = breakout **al tocco/alla conferma**; il retest non e' mai stato nella lista |
| **C12** | Registro 04/09 («la finestra del range e' contesa»): le due sedie ORB vive userebbero **entrambe 14:25-14:30**; nei CSV di R15 (`ABTG_ORB_Ottimizzato` U30USD) il range e' **14:30-14:45**, come dice il referto sul reale | `backtest_pipeline/REGISTRO_TEST.md` r.815 · `risultati_prove/ABTG_ORB_Ottimizzato/*U30USD*_r15.csv` `[MISURATO]` | **APERTA nel registro**: la tabella va corretta; solo `ABTG_ORB` era 14:25-14:30 |
| **C11** | Una **stessa** cella Dow: R197A breakout IS **0,965** a banco 2% (perde in IS) contro «candidato #1» breakout IS **1,252** (R245): **celle diverse** (filtro EMA H4 acceso, range 15 contro 35, ecc.) | registro R197A · `risultati_archivio/R245/ROUND_R245b/*` | **Sciolta**: non e' un contrasto, ma va detto perche' la frase «il breakout Dow perde in IS» e' vera solo senza filtro |

---

## 10. L'ORO — cosa e' misurato, con quale costo, su quale storico

**Prima precisazione (il mandato citava «finestra 15:36 · R263 · MaxMinNotte»):**
- **R263 nel registro e' un round sul Dow** (DD misurato a 2x il banco della cella candidata #1), **non sull'oro**. La finestra dell'oro «15:36» e' quella del **collega** (`report/ORO_1530_*`): range M5 14:30-14:35 server, rottura su M1 alle 14:36 (= 15:36 italiane).
- **`ABTG_MaxMinNotte` oro e' un box NOTTURNO (23:00-04:59 circa), non un ORB.** Sta qui solo per il costo (commissione) e per il metodo di lettura OHLC M1.

| # | oro | cosa e' | numeri | storico · modello |
|---|---|---|---|---|
| G1 | `ORB_Ottimizzato` XAUUSD (R10, 08/08) | ORB «da manuale», range **30 min** 14:30-15:00 srv, chiusura M5 confermata, 4 celle (TP 1,5/2 × volume on/off) | OOS PF **0,87-0,999** · n 173-376 · DD 3,5-8,6%; IS 0,60-1,003; **nessuna cella verde in entrambe** `[MISURATO r10]` | tick BCM, dal 2024.09.26; 4 celle = 1 asse tecnico + 2 |
| G2 | `ORB_Ottimizzato` XAUUSD **sessione di Londra** (R45a) | range 07:00-07:15/07:30 srv (pre-apertura di Londra: ora sbagliata, §9 C4) | 0/8 IS e 0/8 OOS; miglior OOS −411 (PF 0,80) | tick BCM |
| G3 | **oro 15:30 su M1 (collega)** | non e' un backtest: sonda di occasioni su HistData M1 Oanda | 5 candele dello stesso colore **4,78% contro 6,25% di una monetina**; nessuna rottura 55,24%; inversione 48,80%; range mediano 5 min **1,57 $** contro un pavimento di lavoro di **8,01 $** (5,10x); solo 13 giornate su 2.511 (0,52%) lo raggiungono; OOS 2016-2020: **MAE > MFE**, netto lordo mediano −0,11 $ | **2006-03 → 2015-12 (IS, 2.511 giornate) · 2016-2020 (OOS, 1.123)**; feed Oanda, **non BCM** |
| G4 | `ORB_GOLD_FIBONACCI_EA` (+ v3.21) | EA di terzi: OR 15:30-16:00 CET, LIMIT al 61,8%, stop al 78,6%, filtro D1 EMA200, `InpBrokerCETOffset` -1 | **nessun CSV** | — |
| — | `ABTG_MaxMinNotte` oro | **non ORB** (box notturno) | R260a OHLC M1 2020.01.01-2026.06.30: 375 deal / 279 pos, +14.062,17 con k | OHLC, k = 1,811 EUR/lotto |

**Costo:** spread oro 0,16 $ (17/08) / 0,22 $ (27/08); **nella finestra 14:30-14:41 `[NON MISURATO]`**; commissione misurata **0,0403 $/oncia**; costo pieno **0,2003 $**; frontiera 40x → stop ≥ 6,40 $ (8,01 $ con il pedaggio pieno), duro 13,3x → 2,13-2,66 $. **Commissione «k»: 1,81 EUR/lotto per MaxMinNotte contro 3,48 EUR/lotto giro nella misura del 10/09: non riconciliate (§9 C9).**
**Storico:** tick BCM dell'oro **`[NON MISURATO]`** (profondita'); M1 HistData 2006-2020 (+ 2021-2026 per la sonda 09:30, non per il 15:30); OHLC M1 2020-2026 per MaxMinNotte.

**Cosa e' chiuso e cosa no.** Chiuso: **la finestra del collega su M1** (fenomeno assente, non solo costoso). **Aperto e mai misurato:** l'ORB con range di **30-60 minuti** su **M30/H1** sull'oro (la frontiera del costo la lascia passare: M30 con stop ≥ ~8,8 $, margine +9,7%; H1 +55%) — il meccanismo e' lo stesso di `ABTG_ORB` e `ABTG_Nasdaq_Apertura_US`; **e il retest** sull'oro (`ORB_GOLD_FIBONACCI_EA`, geometria di retest) non ha un solo numero. Via piu' corta: Z5 (sonda estesa) poi M9.

---

## 11. VERIFICHE — numeri ricontrollati aprendo il CSV o il referto (12 gruppi)

| # | cosa | atteso (dove) | riletto | esito |
|---|---|---|---|---|
| V1 | Nasdaq RETEST OOS, Pass 2 | 1,21546 · 172 · 7,8576 (registro A4) | `risultati_prove/R199B/*OOS_R199B.csv` Pass 2: **1,21546 · 172 · 7,8576**; IS Pass 2: 1,22116 · 135 · 7,3069 | ✅ |
| V2 | Nasdaq RETEST, contratto 20/09 | 1,10936 · 94 · 3,6753 | `Walkforward_Aperture/NASDAQ_B_motore_OOS.csv` Pass 8: **1,10936 · 94 · 3,6753**, `ClosePct=0` | ✅ (e apre C1) |
| V3 | DAX long, R270c | IS 175 · 1,12634 · 5,4362; OOS 270 · 1,39709 · 7,2328 | `ROUND_R270c/*` Pass 1: **identico** | ✅ |
| V4 | DAX short, R270d | IS 138 · 0,965 · 7,47; OOS 257 · 0,957 · 12,31 | `ROUND_R270d/*` Pass 1: **0,96513 · 7,4732; 0,95734 · 12,3052** | ✅ |
| V5 | Dow long, r47c | 1,22247 / 1,27013 · 74 / 130 · 5,6692 / 4,3941 | `aperture_r47/*r47c.csv`: **identico** | ✅ |
| V6 | Dow breakout candidato #1 (R245b centro 200) | 1,252 / 1,489 · 154 / 197 · 7,10 / 6,86 | `R245/ROUND_R245b/*` Pass 3: **1,25176 · 154 · 7,1002; 1,48894 · 197 · 6,8640** | ✅ |
| V7 | ORB_Ott U30USD, R88a | HALFRANGE 41.057,00 · 1,67419 · 9,7623 · 119; OPPRANGE+500 23.003,35 · 1,83850 · 3,8395; solo `SLMode` 3→0: 18.921,52 · 1,68012 · 4,2956 | `r88_csv/*OOS_r88a.csv`: **identici** (Pass 15/16/12) | ✅ |
| V8 | ORB corso NASUSD | R7a IS −1477,26 · 0,82392 · 24,84; OOS 1,04998 · 19,41 · 355; R8 1,49060 / 1,03159 | `ABTG_ORB/*_r7a,r8.csv`: **identici** | ✅ |
| V9 | ORB_Fibo | IS 0,83507 · 91 · 3,02; OOS 0,96816 · 75 · 3,10; `InpExecTF`=5 · `InpORMinutes`=30 | `ABTG_ORB_Fibo/*_ohlc.csv`: **identici**, 2 righe uguali (asse = magic) | ✅ |
| V10 | ORB_Ott U30USD R15 | IS 1,223 · 8,63 · 71; OOS 1,657 · 9,92 · 119 | `_r15.csv`: **1,22314 · 8,6252 · 71; 1,65693 · 9,9181 · 119** | ✅ |
| V11 | **Durata del range** (DAX/Nasdaq/Dow) | «8/8 e 0/8» | 4 file Walkforward_Aperture + `aperture_r35`: §5; **precisazione: solo DAX, solo OOS** | ✅ + nuova informazione |
| V12 | Oro R10 (4 celle) e Nasdaq Live5m OOS (0,96265 · 175 · 19,40) | «nessuna cella verde»; registro L2 | `XAUUSD_*_r10.csv`: OOS 0,87-0,999, IS 0,60-1,003; `Live5m_NASUSD_OOS.csv`: **0,96265 · 175 · 19,4006** (2 righe uguali = asse tecnico) | ✅ |

**Non riaperti (`[LETTO]`):** R97 (0,84-0,91, n=135: letto nel referto, CSV non trovato per nome), R255 Dow short, R263 (muro), R247/R248, contratti FTMO, censimento del 23/09 sulle celle Nasdaq spente, sonda oro 15:30, R258 (letto nel pacchetto per Gemini del 28/09).

---

## 12. BUCHI DICHIARATI

1. **Stato reale sul VPS al 29/09** delle sedie ORB (reale, 100k, piccolo): riletto solo fino al 24-25/09; il terminale del piccolo e' risultato fermo dal 23/09 19:35 nel referto del 25/09 `[NON RILETTO al 29/09]`. Esito della mail a FTMO sull'hedging fra conti `[NON VERIFICATO]`.
2. **Il libro affari FTMO non arriva in repo:** «zero operazioni» significa «zero documentate».
3. **Profondita' a tick dell'oro e dei gemelli europei** (F40EUR/E50EUR/E35EUR) `[NON MISURATA]`: M4 e M9 possono essere vuoti.
4. **R125 mai girato**; la R97 rimane letta solo dal referto.
5. **Sorgenti `ORB_DAX_BASE_EA` / `ORB_DAX_PM_EA` / `ORB_OpeningRange` / `ORB_GOLD_FIBONACCI_EA`**: letti gli header e gli input, non l'intera logica; il segno dell'offset CET e' `[INFERITO]`.
6. **R258 non e' in registro:** ho riportato i numeri dal pacchetto del 28/09, non dai CSV.
7. **Numero di conto e taglie:** volutamente assenti; le taglie sono di Claudio.
