# 🪑 PIANO DI SCHIERAMENTO: il piccolo DEMO BCM 50503392 con "tutti gli EA" (11/10/2026)

**11/10/2026 (domenica)** · branch `lavoro` @ `3df81442` · **BOZZA, NON PASSATA DAL CANCELLO** (strato 1 `controlla_riga.py --oggetto md`: esito in sez. 10; strato 2 `controllo-preventivo`: da invocare, finche' non da' PASS questa pagina non esce verso Claudio).
**SOLA LETTURA del repo.** Nessun EA, preset, sedia, magic, conto, Guardian o terminale toccato. Nessuna stringa di lancio. Nessuna decisione presa al posto tuo: **rischio, taglie, Guardian, spese e il reale `10105439` sono tuoi**. Questo e' un piano da firmare passo per passo, non un'esecuzione.
Richiesta (verbale `report/FIRME_2026-10-11.md` r.9, punto 5): _"NON LO SO TENIAMO IL CONTO PICCOLO DEMO DA FAR GIRARE TUTTI GLI EA."_ E' una **direzione**, non l'esecuzione: schierare, il Guardian sul piccolo, il rischio per sedia sul demo e la riattivazione delle sedie indice sospese restano **firme da dare una per una dopo questo piano** (stesso r.9).

**Etichette**: **FATTO** = letto o contato alla fonte (file e riga) · **DERIVATO** = conto mio su numeri FATTO, il metodo e' scritto accanto · **INFERITO** = ragionamento, non verificato · **NON TROVATO** = cercato e assente.
**Sigle delle fonti** (tutte sul branch `lavoro`):
`C01` = `backtest_pipeline/coda/referti/CODA_01_sedie_attaccate_20261011_033004.log` · `C06` = `..._CODA_06_quale_codice_gira_20261011_033004.log` · `C08` = `..._CODA_08_preset_dai_chr_20261011_033004.log` · `C03` = `..._CODA_03_conti_dei_terminali_20261011_033004.log` (sonde di SOLA LETTURA di stanotte, 03:30; il profilo su disco e' una foto al salvataggio, **non** la finestra viva di MT5) ·
`OROL` = `report/DECISIONE_OROLOGIO_INVERNALE_BCM_2026-10-11.md` · `SOSP` = `report/SOSPENSIONE_SEDIE_DEMO_2026-09-25.md` · `GCS` = `report/IL_GUARDIAN_CHE_SCHIEREREMO_2026-09-12.md` · `GIC` = `report/IL_GUARDIAN_IN_CAMPO_2026-09-12.md` · `RUN` = `report/RUNBOOK_RICOMPILAZIONE_PICCOLO_2026-09-14.md` · `MEMA` = `report/MIGLIORA_EMA200_DOW_H1_2026-10-11.md` (anch'essa **bozza non passata dal cancello**: cito solo i fatti che rimandano a una fonte) · `CHIUS` = `report/FTMO_CHALLENGE_CHIUSURA_2026-09-30.md` · `AUT` = `report/FTMO_TRIAL_AUTOPSIA_2026-10-08.md` · `RES` = `report/RESOCONTO_EA_IN_PAROLE_SEMPLICI_2026-10-06.md` · `PRI` = `report/PRIORITA_EA_E_DA_FARE_2026-10-08.md` · `CTR` = `report/CONTRATTI_DELLE_SEDIE_FTMO_2026-09-20.md` · `CEN` = `report/CENSIMENTO_CONTRATTI_v2.md` · `TA` = `data/statements/trades_auto.csv` (export del piccolo, ultimo aggiornamento 09/10 22:45; chiusure fino al 09/10 14:22) · `DIA` = `report/DIARIO.md` · `AZZ` = `report/AZZURRA_PICCOLO_PASSI_2026-10-09.md` · `HAN` = `HANDOFF.md`.
Convenzione righe: `C06` conta **una riga in piu'** di `wc -l` (`GCS` r.61, "scarto costante di +1"). Per confrontare mele con mele scrivo le righe del sorgente a `HEAD` **gia' col +1**.

---

## 1. 🎯 IN BREVE (5 righe)

1. **Il piccolo NON e' vuoto**: oggi il profilo `ORO` ha **29 grafici con un EA** (26 sedie con magic + `TradeExporter`, `SpreadLogger`, `EMA200_Ombra` che non apre ordini), nessuna e' un'apertura su indici (DAX, Dow, Nasdaq) ma **l'Azzurra puo' aprire sugli indici** (sez. 2c), **nessun Guardian** (`C01` r.13-43). "Tutti gli EA" a mano libera sono 157 sorgenti in `mql5/Experts` (`git ls-tree` su `3df81442`): non si schierano tutti, si **ordinano** (sez. 7).
2. 🔴 **Il binario in campo e' vecchio**: 20 sedie su 26 sono compilate fra il **06/08 e il 14/08**, prima della "Migrazione Guardian" del 19/08, e **non chiamano il Guardian**; le altre 6 (PostNews x3, Bulge, Azzurra, ORB argento) lo chiamano ma **sul piccolo non c'e' nessun Guardian: fail-open** (`C06` r.86-137, `C08`). **L'EMA200 `771531` e' tolta dal piccolo dal 24/09**; il binario che resta sul disco e' `344a11b`, **487 righe** (HEAD: 691), zero `InpUsaGuardian`.
3. 🔴 **Il rischio vero sul piccolo, oggi, non e' un EA**: dal 29/09 al 09/10 `TA` ha **105 posizioni chiuse, -1.006,39**: **89 degli EA (-45,45)** e **16 a magic 0 (mani o EA senza magic) = -960,94**, la piu' grossa `D30EUR` buy **10,00 lotti, -1.462,00** (08/10). E' la lezione della challenge, tornata sullo stesso conto (sez. 6).
4. 🟠 **Fino al 14/10 il divieto FTMO sulle posizioni opposte fra conti e' vivo** (trial `1514806751` ancora in scadenza con sedie indice + Bulge viola); **dopo il 14/10 nei documenti non risulta nessun conto FTMO vivo** e la sospensione firmata il 25/09 puo' essere riesaminata. In piu': dal **26/10** (DAX) e **02/11** (USA) le sedie a ora fissa armano un'ora prima della cash (`OROL`).
5. 🟢 **Proposta**: non tutti insieme. **Passo 0** (adesso, zero EA nuovi): alcune firme tue (sez. 8) e un po' di igiene. **Passo 1** (dal 15/10): **una sola sedia**, l'`EMA200 771531`, perche' e' la numero 1 di `PRI`, e' una delle tre prove "B pulita" (257 posizioni OOS) e **non dipende dall'orologio**. Poi, a gruppi di 1-3 e **mai sulle ore fisse prima della tua decisione d'inverno**.

---

## 2. 📋 STATO OGGI sul piccolo `50503392` (`C:\Program Files\BCM Markets MT5 Terminal`, **senza** `-V3`)

**Chi e' chi (FATTO)**: la cartella dati `215D85D7...` e' `C:\Program Files\BCM Markets MT5 Terminal`, profilo attivo `ORO`, 41 file `.chr` di cui 29 con un EA (`C01` r.11-14, `C08` r.20-26 e r.2074). Il numero di conto **non e' ricavabile da `C03`** ("CONTO: NON TROVATO nei giornali recenti", r.13-17); l'identita' `50503392` viene da `CLAUDE.md` e da `SOSP` r.11 (`BCM Markets MT5 Terminal` = piccolo). Ultimo saldo noto: **bilancio 5.430,99 / equity 5.404,27 al 30/09 20:55** (`HAN` r.34); **equity di oggi: NON TROVATA**.
**Spento e riacceso (FATTO)**: fermo dal 23/09 19:35 al 29/09 ~19:40, riacceso a mano da Claudio, chiusura "normale" (`HAN` r.67): **6 giorni di conteggio persi**.

### 2a. Le 29 sedie attaccate

| EA | magic | simbolo / TF (grafico) | attaccata | binario in campo (righe C06 · ver · Guardian nel sorgente · `.ex5`) | sorgente a HEAD (righe +1) | legge il Guardian? | rischio per op. (`.chr`) | fonte |
|---|---|---|---|---|---|---|---|---|
| BreakingBand | 772161 / 772162 / 772163 | GBPUSD / EURUSD / AUDUSD H1 | **SI** | 1578 · 1.02 · **no** · 13/08 07:29 | 1858 · 1.05 | **NO** (il codice non lo chiama) | 1,0 | C01 r.16-18 · C06 r.86 · C08 r.70,178,286 |
| GapFill | 772231 / 772232 / 772233 | GBPUSD / EURUSD / AUDUSD H1 | **SI** | 791 · 1.00 · **no** · 13/08 14:30 | 806 · 1.00 | **NO** | 1,0 | C01 r.19-21 · C06 r.102 |
| PunteLarry | 772342 / 772343 / 772344 / 772345 / 772346 | EURAUD, XAUUSD, GBPJPY, GBPUSD, EURCAD H1 | **SI** | 1200 · 1.00 · **no** · 13/08 18:17 | 1215 · 1.00 | **NO** | 0,5 / 0,3 / 1,0 / 1,0 / 1,0 | C01 r.22-26 · C06 r.120 |
| CostToCost | 772361 / 772362 | EURJPY / GBPCAD H4 (solo long) | **SI** | 1079 · 1.00 · **no** · 13/08 19:46 | 1469 · 1.00 | **NO** | 0,65 / 0,25 | C01 r.27-28 · C06 r.89 |
| EasyTrend | 772421 / 772422 | CHFJPY / GBPUSD H1 | **SI** | 1606 · 1.00 · **no** · 14/08 08:49 | 1621 · 1.00 | **NO** | 0,3 / 0,5 | C01 r.29-30 · C06 r.96 |
| PTE | 771332 / 771322 (**due sedie sullo stesso GBPUSD H1**) | GBPUSD H1 x2 | **SI** | 526 · 1.00 · **no** · 06/08 19:34 | 777 · 1.01 | **NO** | 0,5 / 0,5 | C01 r.31-32 · C06 r.119 |
| MaxMinNotte oro | 770402 | XAUUSD M15 (gestione H2) | **SI** | 540 · 1.10 · **no** · 06/08 19:33 | 919 · 1.11 | **NO** | 0,5 (il preset del repo dice 1,0: `mql5/Presets/sedie_piccolo/sedia_MAXMIN_ORO_770402.set`) | C01 r.33 · C06 r.108 · C08 r.1271-1286 |
| EMA200_Ottimizzato | 971501 | **AUDCHF** H4 | **SI** | 487 · 1.00 · **no** · 06/08 19:32 | 749 · 1.00 | **NO** | 0,25 | C01 r.34 · C06 r.99 |
| SupertrendReversal_Ott. | 970901 | XAUUSD H4 | **SI** | 577 · 1.00 · **no** · 06/08 19:32 | 744 · 1.01 | **NO** | 1 | C01 r.35 · C06 r.126 |
| PostNews | 771203 NFP / 771201 ECB / 771202 FOMC | USDJPY / EURJPY / EURUSD M5 | **SI** | 667 · 1.10 · **SI** · 04/09 13:24 | 687 · 1.10 (+20 righe: INFERITO = lo scrittore OptFrame del tester, commit `a66dcb07` del 28/09, letto dal titolo) | il codice lo chiama (`InpUsaGuardian=true`) ma **senza Guardian sul terminale e' fail-open** | 1,3 | C01 r.36-38 · C06 r.118 · C08 r.1530,1601,1672 |
| Bulge (viola) | 772700 | GBPUSD H4 (22 cross) | **SI** | 2235 · 5.20 · **SI** · 29/09 22:51 | 2235 · 5.20 (**uguale**) | idem: chiama, ma **fail-open** | 0,8 x Max_Trades 4 | C01 r.40 · C06 r.87 · C08 r.1792 · AZZ r.272 |
| BulgeAzzurra | 774500 | EURGBP H1; **33 simboli: 22 cross + XAUUSD + 10 indici BCM** | **SI** (dal 09/10 16:39) | 2492 · 5.20 · **SI** · 09/10 16:24 | 2492 · 5.20 (**uguale**) | idem: **fail-open** | 0,80 x 4 | C01 r.43 · C06 r.88 · AZZ r.275-277 |
| ORB_Ottimizzato (**argento**) | **770611** | XAGUSD H4 (range 14:30-14:45, solo long) | **SI** (compare nella sonda del 07/10) | 1464 · 1.04 · **SI** · 03/09 16:14 | 1484 · 1.04 (+20: stesso INFERITO di PostNews) | idem: **fail-open** | 1,0 | C01 r.41 · C06 r.117 · C08 r.1836-1846 |
| EMA200_Ombra | - (nessun ordine) | EURUSD M15 | **SI** (dal 07/10) | 2115 · 1.03 · no · 05/10 14:45 | 2115 (**uguale**) | n/a, non apre ordini | n/a | C01 r.42 · C06 r.98 |
| TradeExporter | - | NZDCAD H1 | **SI** | 212 · 1.00 · 06/08 | 212 (**uguale**) | n/a | n/a | C01 r.15 · C06 r.137 |
| SpreadLogger | - | CADCHF H1 | **SI** | 1019 · 1.00 · 06/09 | 1019 (**uguale**) | n/a | n/a | C01 r.39 · C06 r.121 |
| **Guardian** | 779001 / 779002 altrove | **NON attaccato sul piccolo** | **NO** | sul disco: `ABTG_Guardian.mq5` 1.10, 414 righe, `.ex5` **09/08** (**piu' vecchio** dei cap firmati il 18/08) | 900 · 1.14 (19 input) | - | - | C01 r.12-44 · C06 r.105 · GCS r.68 |

**Come leggere "legge il Guardian"** (INFERITO dal codice, non da una prova di campo): una sedia protegge solo se **(1)** il suo binario chiama `ABTG_GuardiaIngresso` **e** `InpUsaGuardian=true` **e** **(2)** un Guardian gira davvero su quel terminale. Se manca (2), la guardia e' **fail-open** (`mql5/Include/ABTG_PausaGuardian.mqh` r.765 `ABTG_PuoAprire`, citato in `RUN` r.61 e `MEMA` r.246): l'ordine passa lo stesso.

**Altre cose sul disco del piccolo (FATTO, `C06` r.180-182)**: tre `.ex5` **senza sorgente**: `NasdaqOpeningBreakout_EA_v21_OPTIMIZED (1)` (12/08), **`The Gold Reaper MT5`** (10/10 19:52) e **`XAUUSD 5 minute`** (10/10 19:51). **Non sono nel profilo salvato** (`C01`). `NOTTE_2026-10-11.md` dice: *"se e' sul VPS: Annulla, non attaccarlo"* (Gold Reaper). Se siano attaccati ora in una finestra viva: **NON TROVATO**.

### 2b. Le sedie che NON ci sono piu' (sospese) e il loro binario

| sedia | magic | simbolo / TF | attaccata | quando sparita | binario rimasto sul disco (C06) | fonte |
|---|---|---|---|---|---|---|
| **EMA200** | **771531** | U30USD H1 | **NO** | **24/09 03:30** (grafico `ORO\chart33.chr`); chi l'ha tolta: **NON TROVATO**; la tabella del 25/09 non la contiene e `HAN` r.68 la conta fra le 16 sparite: **NON RICONCILIATO** (`MEMA` r.26) | 487 righe · 1.00 · no · **06/08** = commit `344a11b` (486+1); **HEAD 691** | MEMA r.126,131 · GCS r.116 · C06 r.97 |
| DAX Apertura long | 770101 | D30EUR M5 | NO | 25/09 (sospensione firmata) | 2191 · 1.00 · no · 08/08 14:23; **HEAD 2886** | SOSP r.36 · C06 r.90 |
| Dow Apertura long | 770202 | U30USD M5 | NO | 25/09 | 2123 · 1.00 · no · 08/08; **HEAD 2206** | SOSP r.37 · C06 r.95 |
| Nasdaq Apertura | 770250 | NASUSD M15 | NO | 25/09 | 2091 · 1.00 · no · 08/08; HEAD 2645 | SOSP r.44 · C06 r.110 |
| MaxMin DAX short | 770411 | D30EUR M15 | NO | 25/09 | 605 · 1.10 · no · 18/08; HEAD 620 | SOSP r.38 · C06 r.109 |
| SuperWave Dow H1 | 770511 | U30USD H1 | NO | 25/09 | 564 · 1.00 · no · 06/08; HEAD 775 | SOSP r.40 · C06 r.129 |
| ORB (Dow) | 770611 | U30USD M5 | NO | 25/09 | (e' lo stesso `ABTG_ORB_Ottimizzato`, ora su XAGUSD) | SOSP r.43 |
| SupRev Nasdaq H1 | 970913 | NASUSD H1 | NO | 25/09 | 578 · 1.00 · no · 06/08; HEAD 653 | SOSP r.42 · C06 r.136 |
| SupRev DAX H4 | 970912 | D30EUR H4 | NO | 25/09 | 578 · 1.00 · no · 06/08; HEAD 616 | SOSP r.41 · C06 r.133 |
| PTE Dow, GapFill U30USD / 225JPY, PunteLarry U30USD, GapContinuation 225JPY, SuperWave Dow H2, SupertrendReversal 225JPY | 771321, 772234, 772235, 772341, 774101, 770531, 770924 | indici / 225JPY | NO | 25/09 | non analizzati uno per uno | SOSP r.30-39 |

Totale sospeso: **15 grafici** il 25/09 (`SOSP` r.27-44) piu' la 771531 il 24/09. `HAN` r.68: *"le sedie indice NON vanno riattaccate finche' vale il divieto"* (firma del 25/09).

### 2c. Una cosa che la sonda NON vede: l'Azzurra porta gli indici sul piccolo

Il profilo mostra l'Azzurra su **EURGBP H1** e 5 parametri (`C08` r.2062-2074: la sonda stampa solo gli `Inp*`). Ma `AZZ` r.275-277 scrive la decisione di Claudio del 09/10 (**"ANCHE INDICI E METALLI"**) e la conferma dalla scheda Esperti del 10/10: **`Init OK | Simboli: 33`** = 22 cross + `XAUUSD` + `100GBP, 200AUD, 225JPY, D30EUR, E35EUR, E50EUR, F40EUR, NASUSD, SPXUSD, U30USD`. **Quindi "nessuna sedia automatica su indici sul piccolo" (`OROL` r.13) non e' piu' vero alla lettera**: l'Azzurra puo' aprire su DAX, Dow, Nasdaq. Non e' un errore tuo: la pagina d'orologio e' di oggi e la sonda non mostra l'elenco simboli. Va solo saputo (**FATTO** per la lista; **NON TROVATO** se abbia gia' aperto qualcosa su un indice: `TA` ha 0 righe a magic 774500).

### 2d. CLAU12_ nel campo: spiegato (FATTO), non e' un'anomalia

- Lo screenshot degli Esperti che hai mostrato **e' `C:\FTMO`** (conto `1514806751`, la trial): il suo profilo `Default` ha **esattamente** quei 10 grafici: `CLAU12_Dow_Apertura_US` (US30.cash M5), `CLAU12_Nasdaq_Apertura_US`, `CLAU12_SuperWave_DOW_H1_Ottimizzato`, `CLAU12_Guardian` (NZDJPY M1), `ABTG_TradeExporter`, `CLAU12_MaxMinNotte_DAX_Short_Ottimizzato`, `ABTG_SpreadLogger`, `CLAU12_DAX_Apertura_EU`, `ABTG_ORB_Ottimizzato`, `ABTG_Bulge` (`C01` r.49-58).
- I nomi `CLAU12_` sono su **quel solo terminale** dal **20/09**: lo ha fatto `backtest_pipeline/righe/RINOMINA_CLAU12.ps1` (v2), su tua richiesta del 20/09 (_"clau12 e' tipo un mio nickname"_), con `Rename-Item` **solo dei sette `.mq5` e cancellando i `.ex5` col nome vecchio**. Lo scrive nel suo stesso commento: *"Sul FTMO e BASTA: in repo e su tutti i terminali di casa i file restano ABTG_"* (r.9-12). In `C06` r.216-222 i `CLAU12_*.mq5` di `C:\FTMO` hanno data **20/09 16:58** e le stesse righe delle copie `ABTG_*.mq5` accanto; le copie `ABTG_*.mq5` accanto portano **28/09 07:44** (perche' siano ricomparse: **NON TROVATO**).
- **Sul piccolo i nomi sono ABTG_** (`C01` r.15-43): coerente con la decisione di casa dell'11/10 (nel repo non si rinomina niente, solo copie additive `CLAU12_*`; `CLAUDE.md`, `FIRME_2026-10-11.md` r.7). Nel repo `CLAU12_*` esiste solo in `mql5/Experts/trailfix_9fca63d9/` (3 file: DAX, Dow, Nasdaq; "NON in campo", `LEGGIMI.md`).
- 🔴 **Cosa costerebbe far diventare CLAU12_ anche il piccolo** (dalla stessa `RINOMINA_CLAU12.ps1`): niente `.ex5` finche' non rifai F7 su ogni EA, **e** i CSV di diario che costruiscono il nome da `MQL_PROGRAM_NAME` cambiano nome (la serie "per nome" si spezza; per magic no). Quindi e' una **domanda tua** (sez. 8, n. 6), non un'ovvieta'.

---

## 3. 🧾 LA LISTA DEGLI EA CANDIDATI al forward sul piccolo

**Che cosa intendo per "tutti"** (INFERITO): non i 157 sorgenti, ma **chi ha un motivo scritto per girare**: (A) quelli gia' sul piccolo, (B) quelli sospesi il 24-25/09, (C) quelli nuovi che hanno un numero. Per ciascuno: certificato (cinque caselle del 09/09: PF · n e DD · uscita ad asse · gemelli · TF), perche' vale, **rischio per sedia attuale dal preset/`.chr` (SOLA LETTURA: non propongo nessun numero di taglia)**, conflitti. **Nessuno e' MORTO**: dove manca una casella il verdetto e' **NON ANCORA MISURATO**.

### 3a. EMA200 Dow H1 `771531` (n. 1 di `PRI`)

- **Certificato**: PF **1,2011 IS / 1,5237 OOS**, 132 (non ricontabile) / **257 posizioni**, DD **5,73% / 7,83%** a 1%, tick reali, 26/09/2024-30/06/2026 (`MEMA` r.13; `CTR` r.68). Uscita messa ad asse in 7 manopole (casella 3 SI, ma tutte nel toro); gemelli D30EUR H1 0,928/**0,783**, NASUSD H1 0,755/**0,693** (non passano, mancano della casella 3); TF: H1 e' il bordo, 7 TF provati (`MEMA` r.18). **Mancano**: prova di regime, IS in posizioni misurate (`MEMA` r.115).
- **Cosa dice onestamente il numero (derivazioni della scheda `MEMA`, non rifatte qui)**: le 257 sono **gambe**, ~157 segnali; il profitto sta per il 72,5% in 3 mesi su 13; bootstrap PF 1,05-2,23; **long novembre-marzo PF 0,241 su 38 gambe** (`MEMA` r.14,69). **Un solo regime (toro con una correzione di marzo)**.
- **Forward**: demo 14/08-22/09, **23 gambe = 14 segnali, PF 0,684** (p 0,071), dentro il rumore: nessun verdetto di merito. Il 22/09 demo e FTMO hanno preso **lo stesso evento** (aperture a 0 e 1 s): i due campioni **non si sommano** (`MEMA` r.127,130,135; `TA` righe a magic 771531: 23, -54,71).
- **Perche' vale**: e' l'unica "B pulita" insieme al DAX long (`RES` r.17), gira a **0,945 gambe/giorno** feriale (`MEMA` r.54) e **non legge l'ora** (`MEMA` r.39,121: *"nessuna azione sull'orologio per questa sedia"*). Con 0,945/giorno, **20 operazioni arrivano in ~21 giorni di mercato** (DERIVATO: 20 / 0,945).
- **Perche' non va in campo com'e'**: il binario sul piccolo (`344a11b`) **non legge il Guardian**; HEAD si'. **4 posizioni su 21 attraversano le 23:00 server** (`GCS` r.41). Costo: nessuna spesa, e' un F7 e un preset (sez. 7, passo 1).
- **Rischio per sedia dai preset**: `VIVA` 0,65% · `recupero2` (piccolo) **1,0%** · FTMO 2,00% (`mql5/Presets/ABTG_EMA200_U30USD_H1_771531_VIVA.set`; `mql5/Presets/sedie_piccolo/recupero2/sedia_ABTG_EMA200_771531.set`; `MEMA` r.41). Il DD OOS e' lineare con la taglia: 5,09% a 0,65 · 7,83% a 1,0 · 15,66% a 2,00 (DERIVATO, `MEMA` r.51; la linearita' e' approssimata). **Non propongo una taglia.**
- **Conflitti**: sullo **stesso simbolo U30USD** e' sospesa anche la flotta Dow; il magic `771531` e' unico; sulla trial FTMO **non c'e'** (11 sonde consecutive dal 01/10, `MEMA` r.27). Il divieto FTMO riguarda le sedie Dow/DAX della trial **finche' vive**.

### 3b. La flotta indici sospesa (15 grafici + 771531)

| sedia | certificato (fonte) | perche' vale / non vale | rischio dal preset `recupero2` | forward piccolo (`TA`) |
|---|---|---|---|---|
| **DAX Apertura long 770101** | PF 1,126 → **1,397**, **132** / 193 pos, DD 5,44 / 7,23% a 1%, **0,699 op/g** (`CTR` r.63; `RES` r.34). Un solo regime | la piu' vicina a "B pulita" dopo l'EMA200 ma IS sotto 150; **dipende dall'ora** (-60 min dal 26/10, `OROL`) | 1,0 | 40 righe, **-483,85, PF 0,45** (20/07-22/09) |
| **Dow Apertura long 770202** | 1,222 → 1,270, 56 / **96** pos, DD 5,67 / 4,39%, 0,348 op/g (`CTR` r.64) | C (sotto 150); uscite alternative provate (10): nessuna batte la attuale | 1,0 | 4, +0,35 |
| **Nasdaq Apertura 770250** | 1,257 → **0,948**, 57 / 47 deal, DD 4,54 / 3,63 (`RES` r.50) | **SOTTO** nell'esame; il "1,097 su 104" era la finestra intera. `S-1` aperta: riaccenderla e' una tua domanda | **NON TROVATO** (nessun preset `recupero2` per 770250) | 2, +7,56 |
| **MaxMin DAX short 770411** | IS 1,878 / OOS **2,160**, **14 pos** OOS, DD 1,92%, **0,051 op/g** (`CTR` r.66) | campione sottilissimo; su **FTMO** ha operato **14 volte il contratto** (3 posizioni in 7 giorni contro ~0,03/giorno, `HAN` r.77); sul piccolo ha 5 righe | 1,0 | 5, +155,78 |
| **SuperWave Dow H1 770511** | contratto **CONTESO**: 1,849→1,328 (143 deal) o 1,482→1,243 (131), DD 3,91-4,21% (`CTR` r.67; `RES` r.38) | nessuna finestra oraria (`CTR` r.83): **non dipende dall'orologio**; ma il numero non e' riconciliato | 1,0 | 16, +344,33 (PF 16 su 10 vinte: campione piccolo) |
| **ORB Dow 770611** | 1,250 → 1,674, 71 / 119 pos, **DD OOS 9,76% (muro 10%)** (`RES` r.39) | DD gia' al limite; sul Nasdaq 7 prove su 7 passano da sopra a sotto | 1,0 | 8, **-209,18, PF 0,27** (11/08-03/09) |
| **SupRev Nasdaq H1 970913** | 1,342 → 1,688, 69 / 86 deal, DD 0,86-1,29% (`RES` r.40) | **ESCLUSO PER COSTO**: 28,7x lo spread contro la frontiera 40x (R290a) | 1,0 | 9, +53,48 |
| SuperWave Dow H2 770531 (tolta) | 5,571 (su 32) → 1,762 (50 pos) (`RES` r.38) | C | 1,0 (`sedia_SW_DOW_H2_770531.set`) | 14, -41,68 |
| Le altre 7 (PTE Dow, GapFill U30USD / 225JPY, Larry U30USD, GapContinuation 225JPY, SupRev DAX H4 970912, SupertrendReversal 225JPY 770924) | **NON letti in questo piano** | - | - | vedi `TA` per magic |

**Perche' non rientrano adesso (FATTO + INFERITO)**: **(1)** la firma del 25/09 dice di non riattaccarle finche' vale il divieto; **(2)** i loro binari sul piccolo sono di agosto, **senza Guardian e senza i fix di HEAD**; riattaccare "com'erano" e' riattaccare un binario che non e' quello dei contratti; **(3)** DAX, Dow, MaxMin DAX e ORB Dow **dipendono dall'ora**: dal 26/10 e 02/11 armerebbero un'ora prima (`OROL`), e la decisione A/B/C/D e' tua entro 25/10 e 01/11.

### 3c. MaxMinNotte oro `770402` (gia' attaccata)

PF **1,453 su tutta la finestra, senza esame separato**; 93 posizioni (118 deal); DD **2,34% a 0,5%** su tick da luglio 2024; a barre dal 2004 (22 anni, nessun OOS) il DD e' **19,72% a 1% = ~10,0% a 0,5%** (`RES` r.41; `CEN` r.302). Frequenza **~0,17 op/g**: 20 operazioni in **~118 giorni di mercato** (DERIVATO). Forward: 13 righe, +60,40, PF 1,51 (`TA`). **Rischio**: `.chr` **0,5**; il preset del repo dice 1,0: **NON RICONCILIATO** (la firma del 23/08 e' sullo 0,5). **Orologio**: box 23:00-04:59 BCM; d'inverno cade sul rollover (`OROL` r.34), effetto **NON MISURATO**. Certificato: n e DD SI, PF su finestra piena, **nessun OOS**: NON ANCORA MISURATO come sedia schierabile.

### 3d. ORB sull'**argento** (XAGUSD H4) `770611` (gia' attaccata)

- 🔴 **Certificato NON TROVATO.** Nessun file che ho letto contiene PF, n o DD dell'ORB_Ottimizzato su XAGUSD: tutta la misura dell'ORB e' su **U30USD** (PF 1,250 → 1,674) e sul Nasdaq (7/7 sotto 1). `git grep` su report, docs, HANDOFF e `REGISTRO_TEST.md` non trova una riga "ORB + argento". Chi l'ha attaccata e quando (appare nella sonda del **07/10**; profilo salvato 10/10 19:53) e' **NON TROVATO**. Forward: 0 righe a magic 770611 dopo il 03/09 (`TA`).
- **Conflitti**: **magic `770611` condiviso**: piccolo (XAGUSD), **reale `10105439` (EURAUD H1, `C01` r.99)**, 100k (U30USD, **residuo** non attivo, `C01` r.85) e ex-piccolo (U30USD, 8 righe nel `TA`). I conti sono separati, quindi **in cassa non si pestano**; ma ogni statistica "per magic" che non filtri anche **conto + simbolo** mescola ORB Dow, ORB argento e ORB EURAUD. Se l'ORB Dow tornasse sul piccolo con lo stesso magic, sullo stesso conto ci sarebbero **due ORB con lo stesso magic**.
- **Orologio**: range 14:30-14:45 BCM (`C08` r.1836-1846): -60 min dal 02/11 **se** l'aggancio e' la cash USA (che valga per l'argento: NON dimostrato).
- Rischio `.chr`: **1,0%**, solo long. Costo `stop >= 40 x spread` sull'argento: **NON MISURATO**.

### 3e. EasyTrend `772421` CHFJPY / `772422` GBPUSD (gia' attaccate)

GBPUSD: WF IS 1,258 → OOS **1,492**, 26 / **41 pos**, DD 4,58%; CHFJPY: 1,248 su 53 pos, DD 6,27%; **su 6,5 anni a barre PF 1,01-1,07 con DD 15,8-21,8% a 1%**; **nel crollo 2020 0,391 (GBPUSD) e 0,732 (CHFJPY)**; la famiglia e' **"BOCCIATA in portafoglio (R49)"** e la corsia B del 24/08, firmata da te, ha ridotto 772421 da 1,0% a 0,3% (`report/RESOCONTO_EA_CONSOLIDATO_2026-10-05.md` r.161 e r.284; `DIA` r.191). Frequenza contratto 0,134 / 0,175 op/g. Forward: 772422 **8 righe, +248,22, PF 4,18**; 772421 **9 righe, -32,13, PF 0,75** (`TA`). **Rischio `.chr`**: 0,5 / 0,3. Orologio: finestra 08-18 BCM, relativa a Londra scivola di 1 h d'inverno, effetto NON MISURATO. Certificato: NON ANCORA MISURATO (finestra piena, nessun OOS sui 6,5 anni).

### 3f. PostNews NFP / ECB / FOMC `771203 / 771201 / 771202` (gia' attaccate)

**Contratto `[NON MISURATO]`**: i CSV di archivio hanno `Trades = 0` (`CTR` r.69-71). Frequenza di calendario **~8-12 eventi/anno per sedia = 0,03-0,05 op/g**: per arrivare a **20 operazioni di famiglia servono oltre otto mesi** (DERIVATO: ~28 eventi/anno). Forward: 3 righe totali (+37,36 / -83,22 / +142,82). `OROL` r.36: orari NFP, ECB e FOMC del 28/10 **gia' regolati**; il FOMC del **09/12** richiede un secondo F7. Rischio `.chr`: **1,3%** (la piu' alta del piccolo). Il binario in campo (04/09) chiama il Guardian, ma **sul piccolo e' fail-open**. Valore come forward: ottimo come campione "evento", **inutile per la frequenza**.

### 3g. Bulge viola `772700` e Azzurra `774500` (gia' attaccate)

- **Bulge viola**: PF(r) del pool v5.20 **0,72** su 221 segnali, win rate 72,9% contro 78,9% di pareggio; trial FTMO 0,40 su 19 (-4.925,49); "sotto 1 su ogni misura nostra, anche lordo di costi" (`report/MIGLIORA_BULGE_VIOLA_2026-10-08.md` §0 punti 1-3). Forward piccolo: **66 posizioni dal 30/09 al 09/10, -128,79, PF 0,77** (`TA`); v5.20 a vita -153,23 su n=60, motore intero -1.311,29 su n=357 (`DIA` r.190). **Non e' "morto"** (certificato incompleto, e' stato deciso _"OGNI TOCCO DOPO UN IMPULSO, COM'E' ORA"_, `PRI` r.39-41), ma **non vale la pena schierarne altre varianti prima di sapere cosa fa questa**. Rischio: 0,8% x 4 = 3,20% aperto.
- **Azzurra**: il lettore di `report/AZZURRA_FREQ_LETTURA_2026-10-10.md` stampa, per la cella A, un profitto OOS di -706,79 e un PF 0,82014 ("PF a 5 decimali identico"), ma **lo stesso referto dichiara il merito NON ANCORA MISURATO** (Modello 1, un solo regime, "vietato morto"); frequenza attesa ~3,4-3,5 aperture/giorno feriale sui simboli del tester. **Rischio aperto sommato sul piccolo con la Bulge viola: 6,40%**, sopra il cap C1 del 3,25% e senza Guardian: _"e' un demo: scelta sua"_ (`AZZ` r.272). Orologio: l'Azzurra porta 33 simboli, effetto d'inverno NON MISURATO.

### 3h. Le "forex/oro di agosto" gia' sul piccolo (BreakingBand, GapFill, Larry, CostToCost, PTE, EMA200 AUDCHF, SupRev oro)

Tutte **a n molto sotto 150 (affidabilita' C o D)**: BreakingBand GBPUSD 2,736 → 1,748 (26 pos); CostToCost EURJPY 1,026 → 1,740 (64 pos, DD 9,33%); a 1999-2026 su barre BB 0,714 → 1,123 (segno invertito); nel crollo 2020 CostToCost EURJPY **0,025**, BB GBPUSD 0,595 (`RES` r.42, r.69). **Due casi da guardare con occhio**: **Larry oro `772343`** (0,3% long): **PF 0,872, sotto 1 in 14 prove su 14, DD 29,74% a 1%** su 22 anni, decisione `S-6` (taglia o spegnimento) **ancora aperta** (`RES` r.51,103); **magic `971501`**: nel `TA` compare su **XAUUSD (13 righe)** e su **AUDCHF (8)** (oggi e' AUDCHF H4): l'EMA200 oro H4 e' "NO PER RISCHIO" (DD 22 anni 45,91% contro 4,40% promesso, `RES` r.52), l'AUDCHF **NON TROVATO**; senza filtrare per simbolo le due serie si mescolano.

### 3i. Gli altri nomi che hai fatto e perche' NON li metto sul piccolo adesso

| EA | stato (fonte) | perche' non adesso |
|---|---|---|
| **NatCla** (`EA_NatCla.mq5`) | in misura, F0/F1 sul PC di backtest; M30 autorizzato il 11/10 come deviazione dichiarata, **solo IS** (`FIRME_2026-10-11.md` r.5) | nessun PF di merito; firma 11/10 "non autorizza taglie, rischio, conto reale ne' spese" |
| **GBA** (oro notturno, `ABTG_GoldBreakoutATR.mq5`, 775800) | cancello **PASS solo per F7 e tester sul PC di backtest, non per il campo**; a lotto fisso 1,00 la perdita a SL e' ~530 USD (mediana) = **~16-17% di 5.430 EUR**: _"non sul piccolo"_ (`PRI` r.60) | taglia = firma tua; non e' una sedia |
| **Gold Reaper** (Market, `.ex5` sul piccolo) | _"se e' sul VPS: Annulla, non attaccarlo"_ (`NOTTE_2026-10-11.md`); il suo passo zero e' sospeso | scatola nera, nessun numero di merito; da non attaccare |
| **Nasdaq PreOpen** (esterno, `.ex5` sul 100k) | mai girato, fuso cablato (`OROL` r.67) | e' un'ipotesi, non un candidato |
| **ScalperDirezionale `779901`** | sul **manuale `50503635`** (`C:\MT5_MANUALE`), avvio manuale (`C01` r.91; `OROL` r.13) | non e' del piccolo; non spostarlo |
| **SupRev oro H4 970901** (gia' attaccata) | picco: le celle vicine sono sotto 1 (`RES` r.43) | tenerla e' scelta tua, ma e' un forward di un picco |

### 3j. I conflitti trasversali (stesso conto, stesso simbolo, FTMO)

- **Il conto e' HEDGING** (`CLAUDE.md`, Contesto: "Conto DEMO BCM 50503392, tipo HEDGING"; `C03` r.17 non lo ritrova nei giornali: "NON TROVATO nel testo, NON vuol dire netting"). Quindi **posizioni opposte sullo stesso simbolo dentro il piccolo sono possibili e non sono una violazione**: INFERITO, vale per il broker, **non** per FTMO.
- **Quante sedie sullo stesso simbolo (FATTO, `C01` r.16-43, grafici attaccati)**: **GBPUSD**: BreakingBand 772161, GapFill 772231, Larry 772345 (solo short), EasyTrend 772422, PTE 771332 e 771322 = **6 sedie su 6 grafici**, piu' Bulge e Azzurra (GBPUSD e' fra i 22 cross). **XAUUSD**: Larry 772343 (solo long), MaxMinNotte 770402, SupRev 970901, piu' Bulge (3 righe a oro nel `TA`) e Azzurra. **EURUSD**: BreakingBand 772162, GapFill 772232, PostNews FOMC 771202, piu' Bulge e Azzurra. Il rischio e' l'**attribuzione** (e il margine usato), non un divieto.
- **Il divieto FTMO (FATTO, testo della risposta del 25/09, `docs/RISPOSTA_SUPPORTO_FTMO_2026-09-25.md` r.5-9, r.14-16, r.23-26)**: vale **anche sui demo** e **anche su indici correlati** (long DAX contro short Dow o Nasdaq), "senza soglia", con possibile chiusura del conto.
- **Quando vale (INFERITO da quel testo e dai documenti)**: serve un conto **FTMO** da un lato. **Fino al 14/10 c'e' la trial `1514806751`** (`AUT` r.6 "01/10-14/10"; `PRI` r.29), con sul `C:\FTMO` DAX short `770105` e `770411`, Dow long `770202`, Nasdaq `770260`, SuperWave `770511`, ORB Dow `770621` (long), Bulge viola `772720` (`C01` r.49-58). Per questo **DAX long `770101` sul piccolo contro DAX short della trial era esattamente il caso vietato**. **Dopo il 14/10** nei documenti non c'e' un conto FTMO vivo (la challenge `541452707` e' chiusa dal 30/09, `CHIUS` r.3; la domanda "comprare una nuova challenge" e' aperta, `FIRME_2026-10-11.md` r.9): **INFERITO** che il divieto, oggi, non abbia un lato. **Nota**: l'Azzurra a 33 simboli (indici e oro) e il Bulge viola della trial stanno **gia' ora** dalle due parti (`AZZ` r.275: "le conseguenze per la trial sono NON MISURATE; Claudio ha scelto lo stesso").
- **Magic con piu' conti o piu' simboli**: `770611` (piccolo/XAG, reale/EURAUD, 100k residuo/U30USD), `779001` (Guardian: 100k e trial FTMO), `971501` (oro poi AUDCHF), `771322`/`771332` (due sedie sullo stesso simbolo). Un cruscotto "per magic" che non filtra anche conto e simbolo mescola serie diverse.

---

## 4. 🛡️ IL GUARDIAN SUL PICCOLO: una scelta tua (e non la faccio io)

**Cosa e' stato deciso (FATTO)**: _"decisione di Claudio del 06/09: NIENTE Guardian sul piccolo, perche' il DD della flotta si deve vedere NON FRENATO"_ (`CEN` r.281; `RUN` r.52). Nello stato di oggi vale ancora (`C01` r.12-44: nessun Guardian; `MEMA` r.234).

**Cosa serve per cambiarla (il PASSO 0 del runbook, `RUN` r.57-71)**: due rami.
- **Ramo A, si tiene il 06/09**: nessun gesto sul Guardian. Le sedie ricompilate avranno `InpUsaGuardian=true` ma la guardia e' **fail-open** senza Guardian sul terminale: **non protegge niente, e nessuna regressione** rispetto a oggi (`RUN` r.60-62; `MEMA` r.246).
- **Ramo B, si rovescia**: il Guardian va **ricompilato PRIMA**: quello sul disco e' la 1.10 con `.ex5` **09/08**, **piu' vecchio** del `.mq5` accanto e dei cap firmati il 18/08. Attaccarlo senza F7 *"metterebbe in campo una protezione che NON contiene il cap 3,25% ne' la pausa 4,0/4,9"* (`RUN` r.64-83). Poi i valori del suo preset **non esistono in nessun preset per il piccolo** (`RUN` §6; `MEMA` r.247: `InpAction`, `InpCloseAllMagics`, `InpStartBalance`, soglie = **tue firme**). Il preset del 100k (`mql5/Presets/ABTG_Guardian_50504263_779001_VIVO.set`) porta, **come esempio di cosa e' firmato oggi per un conto da 100k**: pausa giornaliera 4,0 · muro giornaliero 4,9 · muro totale 9,9 · cap C1 3,25 · `InpAction=0` · `InpCloseAllMagics=true`.
- **Una terza via che il sorgente gia' prevede** (FATTO a `mql5/Experts/ABTG_Guardian.mq5` r.168: `InpAction` 1 = **SOLO ALLARME**, "monitor, non chiude"; r.754 e r.761: `FlattenAll()` solo con `InpAction==0`). Non e' un ramo del runbook; **come si comportino con `InpAction=1` la pausa B1 e il cap C1 non l'ho verificato**: INFERITO che scrivano comunque le GlobalVariable, NON verificato.

**Cosa protegge davvero e cosa no, SUL DEMO** (INFERITO dal codice e dai casi reali; scelta tua):
1. 🟢 Dove gira, chiude da solo **qualsiasi magic** (`InpCloseAllMagics=true`, `ABTG_Guardian.mq5` r.169, r.689-697): i muri duri 4,9/9,9 **non passano dall'EA** (`GCS` r.325-328).
2. 🔴 **Ma sul piccolo "chiude tutto" vorrebbe dire anche le mani** e **fermare per 30 giorni il forward**: e' quello che e' successo alla trial il 06/10 (`FlattenAll` + `GV_FAILED` + pausa 30 giorni, nessun ingresso dal 06/10, `AUT` r.21). Su un conto da ~5,4k un muro al 9,9% sta a **~538 EUR** (DERIVATO: 9,9% di 5.430,99 del 30/09; **non** della equity di oggi): la sola riga a mano del 08/10 (**-1.462,00**) l'avrebbe oltrepassato da sola. Cioe' **un Guardian con i valori del 100k ucciderebbe il campione prima di darci un numero**, se le mani restano.
3. 🟠 Il Guardian **e' contro la lettura del DD "non frenato"**: il criterio di rischio del 18/08 confronta il DD forward con il DD **promesso** dal backtest (che il Guardian non ha frenato). Con la pausa B1 il DD forward sarebbe piu' basso del promesso senza che la sedia lo meriti.
4. 🟠 `InpDailyBaseline` (equita' contro saldo giornaliero): **assente nel Guardian in campo** e arriva con la 1.14. Sul demo non c'e' una prop da rispettare: per il piccolo la domanda non si pone (INFERITO).
5. 🟢 Quello che un Guardian **darebbe** davvero al forward, senza chiudere niente: i **log** (`stato=OK pausa=...`) con il rischio aperto sommato (hai gia' 6,40% di Bulge + Azzurra, `AZZ` r.272) e la serie di equity per leggere il DD senza dipendere dai referti.

**Opzioni, SENZA sceglierne una** (la scelta e' sul piccolo e l'unica cosa che non cambia e' che e' una firma tua):

| opzione | cosa cambia | costo | rischio |
|---|---|---|---|
| **A**: resta com'e' (06/09) | nulla; binari e Guardian fuori | 0 | fail-open per tutti; DD non frenato; le mani non si fermano |
| **B**: Guardian pieno | F7 del Guardian da HEAD v1.14 (899 righe, 19 input), preset firmato da te, un grafico | 1 F7 + 1 preset + cancello | uccide il campione al primo muro; chiude le mani; da firmare soglie e `InpStartBalance` |
| **B-allarme**: Guardian in `InpAction=1` | stessa F7, ma **non chiude** | idem | comportamento di B1/C1 non verificato; non e' nel runbook |

---

## 5. 🕰️ L'OROLOGIO D'INVERNO (rimando, non rifatto)

La pagina e' `OROL` (passata dal cancello, 3 giri): **dal lunedi' 26/10 la sedia DAX a `InpSessionHour=8` arma alle 08:00 italiane, un'ora prima di Xetra; dal lunedi' 02/11 il `14:30` BCM e' 8:30 a New York**, un'ora prima della cash. BCM e' UTC+1 fisso. **Le tue scadenze sono 25/10 (DAX) e 01/11 (USA).** Opzioni A/B/C/D e le 7 domande stanno li'; non le ripeto.

**Cosa ne consegue per questo piano**:
- 🟢 **L'EMA200 `771531` e il SuperWave Dow `770511` non leggono l'ora** (`MEMA` r.39,121; `CTR` r.83): possono entrare **prima** della decisione.
- 🟠 Sul piccolo, **oggi attaccate e a ora fissa**: MaxMinNotte oro 770402 (box 23:00-04:59 BCM), ORB argento 770611 (14:30-14:45), EasyTrend (08-18), Bulge (kill switch a mezzanotte server). Nella tabella 2a di `OROL` **mancano l'Azzurra su 33 simboli** (indici inclusi) e il suo orologio: da aggiungere, **NON MISURATO**.
- 🔴 **Le aperture (DAX 770101, Dow 770202, Nasdaq 770250, MaxMin DAX 770411, ORB Dow)** non rientrano **prima** di una tua scelta A/B/C/D: o le fai armare un'ora prima per ignoranza (B), o le prepari con l'ora giusta (A), e A vuol dire un preset diverso da rifare in primavera (14/03 e 28/03/2027).
- 📅 **Misura di 10 secondi il 26/10** sul `50503392` (ora dell'ultima candela M1 contro l'orologio di Windows; `OROL` r.137): serve **la stringa con il bersaglio dichiarato in testa** (regola 12/09), te la mando io.

---

## 6. 🧪 LA RACCOLTA DATI: cosa serve perche' il forward sul demo sia una prova

**Cosa dev'essere vero** (dai criteri di casa) e **cosa c'e'**:

| requisito | stato (FATTO se non diversamente scritto) |
|---|---|
| **n per sedia**: criterio MERITO a **20 operazioni per famiglia**, RISCHIO a qualunque n; sotto 20 e in perdita a 6 mesi = revisione tua (`CLAUDE.md`, `FIRME_2026-08-18.md`) | **quasi nessuna sedia ci arriva**: dal `TA` (a vita sul piccolo): 771531 23 · 770101 40 · 770511 16 · 970913 9 · 772361 11 · 772362 10 · 772422 8 · 772421 9 · 770402 13 · **772700 66 (tutte dal 30/09)**; le altre da 1 a 8, tranne `971501` (21, di cui 13 sull'oro). Tempi per le 20 (DERIVATO dalle frequenze di contratto): EMA200 ~21 giorni di mercato · MaxMin oro ~118 · PostNews di famiglia oltre 8 mesi · MaxMin DAX short ~390 giorni (a 0,051 op/g; su FTMO ha fatto 14 volte il contratto, `HAN` r.77) |
| **per-trade esportato** | **SI**: `TradeExporter` (NZDCAD H1, `InpFile=ABTG_Trades.csv`, ogni 30 min, `C08` r.27-69) → `pubblica_trades.ps1` → `data/statements/trades_auto.csv` (la riga di `pubblica_trades.ps1` r.9: *"piccolo 50503392 (OBBLIGATORIO)"*). Ultimo aggiornamento **09/10 22:45**; 10 e 11/10 non ci sono (weekend: **INFERITO**, l'ultimo scambio e' di venerdi'). Colonne: `pid, symbol, side, volume, open/close time e price, commission, swap, profit, strategy (commento), magic, close_reason, session_high/low` |
| **cap / rischio aperto** | **non misurato in modo continuo**: nessun Guardian = nessuna riga "rischioAperto" per il piccolo. Somma teorica Bulge + Azzurra = **6,40%** (`AZZ` r.272) senza contare le altre sedie (DERIVATO) |
| **stessi parametri nel tempo** | `CODA_08` stampa ogni notte i parametri dai `.chr`, ma **non esiste un confronto notte su notte** che io abbia trovato (**NON TROVATO**). Casi reali di cambio a mano: Azzurra 0,5 → 0,8% (09/10, `AZZ` r.272), 971501 oro → AUDCHF, Bulge: BULGE_MASTER → v5.20 il 29/09 (`HAN` r.73), Use_Blue ancora acceso mentre il preset `SOLO_VIOLA` e' un altro (`AZZ` r.277) |
| **una sedia = un magic = un simbolo** | **NO** in 3 punti: `971501` (oro poi AUDCHF), `770611` (argento, ex Dow, reale EURAUD), PTE `771322`+`771332` sullo **stesso** GBPUSD H1 |
| **nessun trade manuale sullo stesso conto** | 🔴 **NO. Il fatto piu' importante di questa pagina.** Dal 29/09 al 09/10 (`TA`, DERIVATO): **16 deal a magic 0**, somma **-960,94** (netto), volume massimo **10,00 lotti**; contro 89 deal degli EA, **-45,45** (di cui Bulge 66: -128,79; le altre sedie 23: **+83,34**). Il `DIARIO` lo ha gia' scritto tre volte: 06/10 -321,94; 07/10 CADCHF 10 lotti +724,93; 08/10 D30EUR 10 lotti **-1.462,00**, *"la peggiore riga a mano dal 28/07"* (`DIA` r.189,190). Il 09/10 e' stato **il primo giorno su quattro senza mani** (`DIA` r.191). Un grafico "flotta" che non esclude `magic == 0` (la regola corretta del 07/10) legge +737,45 dove la flotta ha fatto +12,52 |
| **un solo posto dove gira il piccolo** | 🟠 il **PC di backtest `DESKTOP-H4D7CAJ`** ha un MT5 loggato sul **stesso** 50503392: *"se li' ci sono sedie attaccate, operano su questo conto e la sonda notturna del VPS non le vede: e' gia' successo il 14/08 (ordini #3160534/#3160535)"* (`SOSP` r.82). Che oggi non ne abbia: **NON MISURATO** |
| **regime** | **un solo regime misurato** (toro, indici dal 26/09/2024): il forward di 4 settimane **non lo cambia**; serve la prova di regime del Dow (P1, `MEMA` r.21: esito **NON TROVATO**) |
| **continuita'** | il piccolo e' rimasto fermo 6 giorni (23/09-29/09) e il VPS si e' inchiodato il 21/09 (i round NON girano sul VPS, `CLAUDE.md`). Dopo ogni riavvio: terminale connesso, sedie attaccate, **Algo Trading verde** |

**Cosa MANCA e costa poco**: (1) una regola scritta per le mani sul piccolo (sez. 8, n. 5); (2) un **confronto notturno** dei parametri `.chr` fra due sonde (idea: un'altra lettura di sola lettura, **non scritta**: servirebbe riga + cancello); (3) il **per-trade dei giorni 10-11/10** appena il mercato riapre; (4) l'**equity di oggi** (NON TROVATA); (5) l'elenco simboli dell'Azzurra nei referti; (6) per ogni sedia la riga del **contratto** (DD e frequenza promessi): c'e' per le 9 sedie FTMO (`CTR`) e per una parte di quelle del piccolo (`CEN`), **non per Bulge, Azzurra, ORB argento, EasyTrend**.

---

## 7. 🧭 UN ORDINE PROPOSTO DI SCHIERAMENTO (PROPOSTA: nessun passo e' firmato)

**Perche' a gruppi piccoli e non tutti insieme** (non e' prudenza di principio, sono tre fatti):
1. 🔴 **Le attribuzioni si perdono.** I primi giorni della challenge (6 di mercato) hanno fatto 5 stop pieni su 11 posizioni (`CHIUS` r.30-32): senza un gruppo isolato non sai **quale** sedia ha sbagliato. Con 29 sedie vive oggi hai gia' il problema: 66 righe sono di una sola (Bulge), tutte le altre sedie insieme ne hanno 23.
2. 🔴 **Gli indici sono un cluster solo.** Le sedie sospese sono tutte a 1,0% nei preset `recupero2` (11 file letti, grep di `InpRiskPercent`): messe insieme sullo stesso lato (long Dow + long DAX + long ORB + EMA200 Dow) **non si diversificano**; il tetto per cluster del 3,0% e' **firmato ma non attivo** (`CLAUDE.md`; 4 modi in cui e' spento) e il C1 3,25% vive nel Guardian, che sul piccolo non c'e'.
3. 🟢 **Il piccolo non puo' fare tre cose insieme**: ricevere binari nuovi (F7 a mano tua), cambiare l'ora (26/10, 02/11) e restare leggibile. Una cosa alla volta.

**Costo di ogni passo**: **zero euro** (F7 e preset non costano). Tempo: quello tuo davanti al terminale giusto; io posso preparare le stringhe e passarle dal cancello.

| # | quando | cosa | perche' qui | chi decide | cosa passa dal cancello |
|---|---|---|---|---|---|
| **0** | **da ora al 14/10, nessun EA nuovo** | **(0a)** firme della sez. 8 (Guardian si/no, rischio, mani, CLAU12). **(0b)** sapere se sul PC di backtest c'e' qualcosa attaccato su 50503392. **(0c)** il 14/10 si chiude la trial FTMO: **dopo** quella data il divieto non ha piu' un lato. **(0d)** decidere se l'Azzurra tiene gli indici e l'oro (`AZZ` r.275-277) | senza queste 4 cose ogni sedia nuova nasce senza che si sappia leggerla | **Claudio** (tutte) | stringhe di sola lettura per (0b): SI, regola del 12/09 col bersaglio in testa; nessuna modifica |
| **1** | **dal 15/10**, se firmi | **EMA200 `771531` da sola** su U30USD H1: F7 da HEAD (atteso `1.00 · 691` righe e input `InpLogImbuto`, `MEMA` r.248 G4), preset a taglia **tua**, ramo Guardian tuo (A: resta com'e'). Verifica la notte dopo: `C01` sedia con magic e rischio giusti, `C06` `GUARD=SI` e 691 righe, `C09` | numero 1 di `PRI`; unica "B pulita" insieme al DAX; non legge l'ora; frequenza alta (20 operazioni in ~21 giorni di mercato) | **Claudio** (F7 a mano, taglia, ramo) | preset e stringa che attacca il grafico: SI. Il sorgente HEAD e' gia' passato dal doppio cancello del 15/09 (`MEMA` r.237) |
| **2** | **da ~1 settimana di giorni puliti dopo il passo 1** (almeno: la sedia ha chiuso la sua prima operazione e `C01`/`C06` confermano binario e input) | **SuperWave Dow H1 `770511`** (nessuna finestra oraria), e **solo dopo** una scelta tua sul contratto conteso (3,91-4,21%) | seconda sedia sul Dow: **stesso cluster dell'EMA200**, quindi **due** sul cluster, non tre | **Claudio** | F7 da HEAD (775 righe contro le 564 del campo) + preset: SI |
| **3** | **dopo la tua scelta A/B/C/D dell'orologio** (DAX entro 25/10, USA entro 01/11) | **una per volta**: DAX long `770101` (contratto piu' pulito, IS 132 < 150), poi MaxMin DAX short `770411`, ORB Dow, Dow Apertura. **Nasdaq `770250`: solo se firmi `S-1`** (sotto 1 nell'esame) | le aperture dipendono dall'ora; **si ferma il rientro finche' non c'e' un'ora scritta** | **Claudio** | preset con l'ora giusta + F7: SI. **Binario da HEAD**, non quello di agosto |
| **4** | da quando vuoi | nuove cacce (NatCla, GBA, ecc.) | **non qui**: non sono sedie, sono misure sul PC di backtest | **Claudio** | n/a |

**Come si decide di fermarsi fra un passo e l'altro (non e' una soglia nuova)**: valgono quelli firmati. **RISCHIO** per sedia a qualunque n: DD forward > DD promesso → revisione immediata. **MERITO** a 20 operazioni di famiglia. **Tagliando** a 6 mesi. Il piano non aggiunge criteri.

🔴 **Cosa NON propongo, perche' e' tua o e' vietata**: numeri di taglia (sez. 3); il Guardian (sez. 4); spese (nessuna); il reale `10105439` (non toccato); alcuna sedia sulla trial FTMO; alcun nuovo EA su `C:\FTMO`.

---

## 8. ❓ DOMANDE A CLAUDIO (secche)

1. **Guardian sul piccolo**: **A** (resta com'e' dal 06/09), **B** (Guardian pieno con tue soglie) o **B-allarme** (`InpAction=1`)? Se B: `InpStartBalance`, soglie e `InpCloseAllMagics` sono tuoi.
2. **Rischio per sedia sul demo**: **tieni quello che c'e' nei `.chr`** (da 0,25% a 1,3%, tabella 2a) o vuoi un altro criterio? E per le sedie che rientrano: preset `recupero2` (1,0%) o altro? Io non propongo numeri.
3. **Chi entra per primo**: ti torna l'**EMA200 `771531` da sola dal 15/10** (sez. 7, passo 1)? Se no, dimmi l'ordine.
4. **Sedie indice sospese**: si riattaccano **dopo il 14/10**, **dopo la scelta d'orologio**, o restano spente? (La firma del 25/09 dice *"non riattaccare finche' vale il divieto"*; senza un conto FTMO vivo il divieto non ha un lato, ma **solo tu** puoi toglierla.)
5. **Mani sul piccolo**: le fai ancora (sono **-960,94** dal 29/09 contro **-45,45** di tutti gli EA)? Se si, le facciamo stare **sul manuale `50503635`** (`C:\MT5_MANUALE`, hedging, c'e' gia')? E ricorda che l'esposizione opposta di un conto vale anche per FTMO se rinasce.
6. **Nomi `CLAU12_` nel campo**: su `C:\FTMO` li hai gia' (rinominati il 20/09 da `RINOMINA_CLAU12.ps1`, solo sul FTMO). Sul **piccolo** li vuoi, **si/no e quando**? Costa un F7 per ogni EA e spezza i CSV di diario per nome (non per magic).
7. **ORB argento `770611` (XAGUSD)**: l'hai attaccata tu, il 06/10? La tieni, senza un certificato (PF/n/DD) che io non trovo?
8. **Azzurra con indici e oro** (`AZZ` r.276): resta cosi' o torna ai 22 cross, almeno finche' non decidi l'orologio d'inverno?
9. **"Tutti gli EA"**: ti basta il perimetro della sez. 3 (gia' sul piccolo + sospesi + EMA200), o intendevi **altri** sorgenti che non ho elencato?

---

## 9. 🚫 NON TROVATO / NON COPERTO

- **Equity e balance del piccolo di oggi**, stato di `Algo Trading`, faccine sui 29 grafici: la sonda legge i `.chr` salvati alle 03:30, non la finestra viva (`C01` r.2-3; `OROL` §6).
- **Chi ha attaccato l'ORB su XAGUSD e perche'** (appare fra la sonda del 06/10 e quella del 07/10); **certificato ORB su argento**: NON TROVATO.
- **L'elenco simboli dell'Azzurra** nei referti della sonda (stampa solo `Inp*`): lo so da `AZZ` r.276-277, non da `C08`.
- **Se `The Gold Reaper MT5` e `XAUUSD 5 minute` sono attaccati** in una finestra viva (non nel profilo).
- **Preset del Guardian per il piccolo**: non esiste (`RUN` §6).
- **Esito di P1** (prova di regime Dow) e della decisione sull'orologio: aperti.
- **Per-trade del 10 e 11/10** (`TA` ferma al 09/10 22:45; weekend: INFERITO).
- **Contratto (DD e frequenza promessi)** di Bulge, Azzurra, ORB argento, EasyTrend CHFJPY: non scritto.
- **Certificati delle 7 sospese minori** (PTE Dow, GapFill U30USD/225JPY, Larry U30USD, GapContinuation 225JPY, SupRev DAX H4, SupertrendReversal 225JPY): non letti qui.
- **Il diff reale dei +20 righe** di PostNews e ORB fra campo e HEAD: inferito dal titolo del commit `a66dcb07`, **non dal diff**.
- **Perche' i `.mq5` ABTG sono riapparsi su `C:\FTMO` il 28/09** accanto ai `CLAU12_`.
- **Se la trial FTMO e' accesa o ferma oggi**, e se il suo Guardian e' vivo (`GUARDIAN: nessuna riga` le notti 10 e 11/10, `NOTTE_2026-10-11.md`): per il calcolo del divieto **fino al 14/10** assumo che possa ancora operare.
- **La prova che nessun conto FTMO sia vivo dopo il 14/10**: e' solo **l'assenza** nei documenti (`FIRME_2026-10-11.md` r.9, `OROL` r.14, `PRI` r.29): **INFERITO**, e dipende da una tua risposta alla domanda aperta "DEVO DECIDERE SE COMPRARE UNA NUOVA CHALLENGE" (consiglio dato: non comprare finche' prova di regime e forward pulito non reggono).
- **157 contro 174**: `CLAUDE.md` parla di 174 EA `.mq5`; `git ls-tree` su `3df81442` ne conta **157** sotto `mql5/Experts`. NON riconciliato (probabile: conta altre cartelle).
- **Nome del conto in `CLAUDE.md`**: `C:\FTMO` = `541452707` (challenge chiusa) vs `1514806751` (trial, giornale): gia' segnalato in `NOTTE_2026-10-11.md`.
- **Cose che sono tue e non ho toccato**: rischio, taglie, Guardian, spese, reale `10105439`; il tetto per cluster C2 e' firmato ma non attivo.

---

## 10. ✅ CONTROLLO FATTO PRIMA DI CONSEGNARE (Sviluppatore contro Agente dei Controlli)

- **Contro-esempi costruiti da me** (non conferme): (a) *"il piccolo non ha CLAU12_"* → ho cercato in `C01` e in `C06` per cartella: il piccolo ha 0, il FTMO 6 attaccati su 10 (e 7 `.mq5` rinominati), e lo script che li ha rinominati dice "sul FTMO e BASTA"; (b) *"20 sedie su 26 senza Guardian"* → ho contato le righe `GUARD` di `C06` r.86-126 per ogni EA attaccato: no = BreakingBand, GapFill, Larry, CostToCost, EasyTrend, PTE, MaxMinNotte, EMA200_Ott, SupRev_Ott = 3+3+5+2+2+2+1+1+1 = **20**; SI = PostNews 3, Bulge, Azzurra, ORB = **6**; (c) *"i deal a magic 0 del `TA`"* → ricontati con due script indipendenti (per magic e per data) e confrontati con `DIA` r.189-191: **tornano** le tre righe a mano citate dal `DIARIO` (06/10 -321,94 AUDJPY; 07/10 CADCHF +724,93 → in `TA` +749,98 lordo: il `DIARIO` dice +724,93 **netto di commissioni e swap**; 08/10 D30EUR -1.462,00); (d) *"le righe a HEAD +1"* → controprova sul banco `C:\MT5_Backtest` (BreakingBand `C06` r.10 = 1858 = HEAD 1857+1).
- **Strato 1** (`controlla_riga.py --oggetto md`): esito scritto nel messaggio di commit.
- **Strato 2** (`controllo-preventivo`): **non invocato da questa sessione** (non ho lo strumento per lanciare un agente): **da fare prima di mandare a Claudio**.
- **Cosa non ho verificato**: i numeri di contratto li ho letti dai referti con la loro riga, **non** li ho rifatti dai CSV; i conti su `TA` sono miei (DERIVATO) e riproducibili con un `csv.DictReader` su `data/statements/trades_auto.csv` a `3df81442` (colonna `magic`, `close_time >= 2026.09.29`, netto = `profit + commission + swap`).

## 11. 🏁 COSA E' ANDATO BENE (un elenco di difetti descrive male la realta')

- 🟢 **Il piccolo lavora**: 26 sedie con magic vive, un exporter che pubblica ogni sera, una sonda che le conta ogni notte; il **09/10 e' stato il primo giorno su quattro senza mani, flotta +27,81 su 8 chiusure** (`DIA` r.191).
- 🟢 **Le sedie "diverse da Bulge" hanno fatto +83,34 su 23 posizioni** dal 29/09: poche, ma non sono loro il problema.
- 🟢 **La domanda di Claudio ("tutti gli EA") ha fatto trovare 5 cose** che nessun referto diceva insieme: l'Azzurra sugli indici, l'ORB argento senza certificato, il `971501` che cambia simbolo, le mani a 10 lotti, i `.ex5` di mercato sul disco.
- 🟢 **L'EMA200 e' il primo candidato con una strada tutta scritta** (G0-G7 in `MEMA`, runbook, preset `VIVA`): manca solo la tua firma.
