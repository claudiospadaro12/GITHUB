# 🔓 RIAPERTURA DEI QUATTRO CANDIDATI DI CLASSE A1 — 09/09/2026

> ## 🎯 LA RISPOSTA IN CINQUE RIGHE
> 1. 🏆 **Su `SupRev DOW H1` LO SPLIT IS/OOS CHE TUTTI CHIEDONO DI FARE ESISTE GIA' IN ARCHIVIO, dall'08/08.** E dice una cosa che nessun documento del 09/09 riporta: **la finestra OOS ha `n=155` — SOPRA il muro dei 150 — con PF `1,43648` e DD `4,8184%` a tick reali.** Su quella finestra il merito **non e' sospeso: e' verde**.
> 2. 🚪 **La casella d'uscita della famiglia Supertrend e' vuota**, riverificata oggi **nome per nome** su tutte le **599 prove `.txt`**: `InpTrailOnST` **0** · `InpExitOnFlip` **0** · `InpFirstFraction` **0** · `InpBreakeven` **0** · `InpTP1_R` **0** · `InpSLLookback` **0**. 👉 **Su `ABTG_SupRev_DOW_H1_Ottimizzato` non esiste UN SOLO asse d'uscita in tutto l'archivio.** E l'unica accusa mai mossa a questo motore e' **"IS ROSSO"**, cioe' esattamente la cosa che una gestione diversa puo' muovere.
> 3. 📐 **Su `DaxReEntry` lo stop e' una frazione del RANGE MATTUTINO, non della barra** (`ABTG_DaxReEntry.mq5` r.81). 👉 **Scendere di TF NON accorcia lo stop**: e' l'unico motore di casa per cui la via "TF piu' basso" **non paga il pedaggio C3**. Nessun documento lo aveva notato.
> 4. ⚠️ **Su `NY Retest` il gate `InpVwapSlopeMin` e' in PUNTI INDICE ASSOLUTI** (sorgente r.96). 👉 **Il numero 75 NON si trasferisce a un altro simbolo.** Chi avesse copiato il preset su NASUSD avrebbe misurato un'altra cosa credendo di replicare. **Avviso scritto prima che qualcuno lo faccia.**
> 5. 💰 **Costo totale di quanto propongo: 20 passate in 5 file prova, tutti gia' PASS a `controlla_prova.py`.** Stima **1,2 - 2,2 ore di banco**. Nessuna griglia larga, nessun parametro d'ingresso toccato su un motore sotto barra.

_Compilato il **09/09/2026** in **sola lettura d'archivio**. **Nessun EA, preset, parametro, magic o sedia viva e' stato toccato. Nessun backtest lanciato. Nessuna promozione. Nessun commit.** Ogni numero e' letto da un file citato per nome e riga; dove non esiste, la riga dice **[NON MISURATO]**._

**Mandato:** riaprire i 4 candidati di **CLASSE A1** di `report/PERCHE_NON_PASSANO_2026-09-09.md` par. 4.1 — quelli fermi da un **numero mancante**, non da un numero brutto.

---

## 0. 🧊 I LIMITI DI QUESTO DOSSIER, dichiarati PRIMA

1. 🔴 **Su TRE candidati su quattro i CSV grezzi NON esistono nel repo.** Verificato oggi: `backtest_pipeline/risultati_archivio/CENSIMENTO_PF_TUTTI_2026-09-09.csv` (1.558 righe) **non contiene nessuna riga** per `NySessionRetest`, `Relativo`, `DaxReEntry` (`grep -c -i relativ` → **0**). I loro numeri vivono in referti `.md` con **due citazioni indipendenti ciascuno**, mai in un file di misura primario. **Solo `SupRev DOW H1` ha i CSV**, ed e' il motivo per cui e' il candidato su cui questo dossier trova di piu'.
2. 🔴 **Un solo regime, per tutti e quattro.** 21 mesi di tick BCM sugli indici (pavimento **2024.09.26**, MISURATO e dichiarato COMPLETO dal broker — `REFERTO_SONDA_STORICO_17-08.md` r.46) = **un solo toro**. L'Emendamento della Finestra **regola C (prova di regime) non e' soddisfatta da nessuno dei quattro**, e nessuna delle vie che propongo la soddisfa.
3. 🟡 **Le stime di tempo macchina sono DERIVATE da due referti, non cronometrate** (par. 6). Il costo di prima costruzione della cache tick su un simbolo nuovo e' **[NON MISURATO]**.
4. ⚪ **Non tocco il perimetro delle decisioni di Claudio:** conto reale 10105439, taglie, spese. E non accendo niente: **la corsia demo resta una firma sua**.

---

# 1. 🥇 NY SESSION RETEST slope 75 — U30USD M15

## 1a. LA SCHEDA — una riga per round, con la fonte

| campo | valore | fonte |
|---|---|---|
| EA | `mql5/Experts/ABTG_NySessionRetest.mq5` (v5, flat di recupero) | sorgente |
| Simbolo / TF | **U30USD M15**, trend EMA200 letto su **H1** | `prove/ABTG_NySessionRetest_Tar2.txt` |
| Sessione | **14:30 → 20:55 ORA SERVER BCM** (= 15:30 → 21:55 IT) | idem |
| Finestra | **2024.09.26 → 2026.06.30** = **459 giorni feriali**, UNA tranche | idem (`@DAQUANDO`/`@FINOA`) |
| Modello | 🟢 **TICK REALI (modello 4)** — **non e' uno screening OHLC** | `RIGA_NYRETEST_TAR2.ps1` |
| Rischio / deposito | **0,65%** girato direttamente (**nessuna riscalatura**) · deposito **100.000** | `CORSIA_DEMO_NYRETEST.md` par. "Il rischio 0,65% NON e' stato riscalato" |
| Magic | **769503** (round) · **769510** riservato alla demo, vergine al 07/09 | `prove/..._Tar2.txt` r. magic · `CORSIA_DEMO_NYRETEST.md` |
| **Dove sta adesso** | 🗄️ **ARCHIVIO.** Scheda di corsia demo scritta il 07/09, magic riservato, **MAI attaccata**: zero occorrenze di `769510`/`NySession` nel log delle sedie attaccate del 09/09 (`backtest_pipeline/coda/referti/CODA_01_sedie_attaccate_20260909_033002.log`, 98 righe) | verificato oggi |
| Frequenza | **0,2505 op/giorno feriale** (115/459) = **5,45 op/mese** | ricalcolo dai numeri primari, coerente col referto |

### I ROUND, uno per riga — **numeri di round diversi NON sono lo stesso numero**

| # | round (data, pin) | modello | cella | n | PF | DD | pegg.gio | fonte (file · riga) |
|---:|---|---|---|---:|---:|---:|---:|---|
| 1 | **passo 0 corsa 1 (31/08)** — H1 | tick | motore nudo | **0** | — | — | — | `REFERTO_NYRETEST_2026-08-31.md` r.1-8 — *"MOTORE STRUTTURALMENTE MUTO SU H1"* |
| 2 | **passo 0 M15 v4** (10:08, pin `c673b98`) | tick | nudo, gate OFF | 623 | **0,998** | 12,97% | −2,89% | idem r.36-56 · 🔴 **INVALIDATA: 30 chiusure OLTRE il flat** = violazione del vincolo duro |
| 3 | **passo 0 M15 v5** (10:36, pin `50551fa`) | tick | nudo, gate OFF | **625 deal / 462 posizioni** | **1,002** | 12,87% | [NON MISURATO in questa riga] | idem r.76-84 · profit **+214** su 100k |
| 4 | **taratura, griglia 48** (11:10, pin `606111d`) | tick | slope 45, sl5 | 211 | **1,174** | 6,51% | −1,13 | idem r.102-137 · **0 celle su 48** con PF≥1,3 & DD<8 |
| 4b | idem | tick | slope 45, sl7 | 212 | 1,166 | 5,78% | −1,13 | idem |
| 5 | **estensione finale** (11:42, pin `77435cb`, 8/8) | tick | slope 60 | 160 | 1,137 / 1,195 | 5,6% | −1,12 | idem r.139-158 |
| 5b | idem | tick | 🎯 **slope 75** | **115 / 114** | **1,374 / 1,427** | **3,7%** (sl7, stampato) | **−0,69** | idem |
| 5c | idem | tick | slope 90 | 75 / 76 | 1,248 / 1,280 | 2,2% | −0,66 | idem |

🟠 **Il "4,7%" che gira nei documenti e' DEDOTTO, non stampato.** La tabella del referto stampa la colonna `DD (sl7) = 3,7%`; il 4,7 si ricostruisce incrociando con `CORSIA_DEMO_CANDIDATI.md` ("DD 3,7-4,7%"). `CORSIA_DEMO_NYRETEST.md` par.3 lo dichiara gia'. **Lo ripeto perche' e' un numero a due passaggi, non una lettura.**

🔴 **E la cella slope 75 e' il PICCO del PF, non il centro di un altopiano:** 45→1,17 · 60→1,14/1,20 · **75→1,374/1,427** · 90→1,25/1,28. Una cella sola sopra la barra, le due vicine sotto. 🟢 **Ma l'asse del RISCHIO e' un gradiente monotono** (n 625→449→295→211→160→115→75, DD 12,9→9,8→5,9→5,8→5,6→3,7→2,2%): il numero di rischio poggia sulla parte solida della mappa, il PF su una cella.

## 1b. IL CERTIFICATO — le 5 caselle

| # | casella | esito | la prova |
|---:|---|:---:|---|
| 1 | **PF misurato?** | ✅ **SI** | 1,374/1,427 a tick alla cella; 1,002 nudo; tutta la mappa slope. Non e' mai stato OHLC |
| 2 | **n e DD?** | ✅ **SI** | n 115/114 · DD 3,7% stampato (4,7% dedotto) · peggior giornata −0,69% |
| 3 | **Gestione dell'uscita ad asse?** | 🟡 **PARZIALE** | ✅ `InpSlLookback` 3/5/7 messo ad asse (`_Tar.txt` r.134, `_Tar2.txt` r.119) = **il piazzamento dello STOP**. ❌ **MAI ad asse SU QUESTO EA**: `InpTP1_ClosePct` (il parziale al 50%), `InpMoveBE` (il breakeven), `InpUsePmLevel`, `InpUseDayLevel`, `InpSlBufferPts`, `InpMinStopPts`. Verificato oggi su tutte le **599 prove `.txt`** del repo. ⚠️ **Precisione dovuta:** `InpTP1_ClosePct` compare ad asse in `R46a/R46b_gestione_*.txt` e `InpMinStopPts` in `R118b/R118c_pavimento_*.txt`, **ma sono ALTRI EA** (`ABTG_DAX_Apertura_EU` / Dow Apertura / DAX RETEST): i nomi coincidono, i motori no |
| 4 | **Simboli gemelli provati?** | ❌ **NO** | `@SIMBOLO U30USD` in **tutti e tre** i file prova esistenti. Mai NASUSD, mai D30EUR, mai SPXUSD. **Zero volte** |
| 5 | **TF cambiato?** | 🟡 **UNA VOLTA** | H1 (0 trade, muto) → M15. Mai M30, mai M10, mai M5 |

> ### 👉 **LE CASELLE NO SONO LA LISTA: gemelli (mai) e uscita oltre lo stop (mai).**

## 1c. LA VIA PIU' CORTA AL VERDETTO

**Le tre vie, con il numero accanto a ciascuna:**

| via | verdetto | il numero che decide |
|---|---|---|
| 📉 **TF PIU' BASSO** (M5) | ❌ **ESCLUSA PER COSTO** | Lo stop e' `InpSlLookback` barre (5 barre del TF): **scendere di TF lo accorcia**. Gia' a M15 la perdita mediana misurata e' **−57,1 punti indice** contro spread U30USD **1,9-2,0** = **29,3×**: sopra il pavimento **duro** (13,3×), **sotto** quello di **lavoro** (**40× = 76-80 punti indice**, frontiera C3 del 06/09). A M5 il rapporto peggiora. **Non e' pigrizia: e' il conto.** _(Il TF piu' ALTO — M30 — alzerebbe lo stop sopra il pavimento ma taglierebbe le operazioni, e il muro qui e' il CAMPIONE: va detto, non e' la via.)_ |
| 📅 **FINESTRA PIU' LUNGA** | ❌ **CHIUSA** | Pavimento tick BCM **2024.09.26**, **MISURATO** e dichiarato **COMPLETO dal broker**. Oltre, i tick sono generati dalle M1 e la colonna spread non e' vera. Il tagliando meccanico e' gia' calendarizzato (**primavera-estate 2027**): **non e' materiale per il 1° ottobre** |
| 🌐 **SIMBOLI GEMELLI** | 🟢 **E' LA VIA** | **NASUSD**: stessa seduta (14:30-20:55 server), stesso orologio, stessa struttura VWAP-di-seduta + EMA200 H1, tick dal **2024.09.26 COMPLETI**. Cambia **una cosa sola**: il simbolo |

### ⚠️ MA C'E' UNA TRAPPOLA TECNICA, E VA DETTA PRIMA CHE QUALCUNO CI CADA

Il gate `InpVwapSlopeMin` e' in **PUNTI INDICE ASSOLUTI** (sorgente r.96: *"Pendenza minima |VWAP| sul periodo, in PUNTI INDICE"*). Su U30USD la scala era **ancorata al take mediano MISURATO**: `45` = meta' del take mediano WIN (**+87,8 punti indice**), `90` = ~1×.

> 🔴 **IL NUMERO 75 NON SI TRASFERISCE A NASUSD.** Copiare il preset sarebbe **inventare una soglia**, non replicare una misura.

👉 Quindi la via corta e' in **due passi**, e il primo e' quello che consegno:
1. **Passo 0 NUDO su NASUSD** (gate spento) → produce la **scala del simbolo** (take mediano in punti indice) **e** lo **stop mediano in punti indice**, che chiude anche il buco C3 su quel simbolo. **File pronto: `backtest_pipeline/prove/A1_NYRETEST_NASUSD_00_nudo.txt`** (2 celle gemelle sul magic = cancello G1 di determinismo · 4 passate).
2. **Solo se il passo 0 passa le soglie congelate**, l'asse slope costruito **su quella scala**, in un file separato.

---

# 2. 🥈 SupRev DOW H1 — U30USD H1, magic 970916 — **IL PIU' RICCO DEI QUATTRO**

## 2a. LA SCHEDA — una riga per round

| campo | valore | fonte |
|---|---|---|
| EA | `mql5/Experts/ABTG_SupRev_DOW_H1_Ottimizzato.mq5` — **esiste e compilato dal 26/07** | sorgente |
| Simbolo / TF | **U30USD H1** · cella `StMult 3,5 / AtrP 9 / TP_RR 3,0` | `REGISTRO_TEST.md` r.404 |
| Magic | **970916** (magic VIVO della sedia, poi spenta) | idem |
| **Dove sta adesso** | 🔴 **SPENTA dall'11/08/2026, da flat.** Verdetto: *"IS −103 / OOS +623 — IS ROSSO → SPEGNERE (SOLO DA FLAT: ha posizione aperta)"*, approvato da Claudio la sera stessa (*"VAI CON LO SPEGNIMENTO"*). L'ultima posizione ha chiuso in TP l'11/08 (`data/statements/trades_auto.csv` r.1157-1158). **Non compare nel log delle sedie attaccate del 09/09** | `risultati_archivio/REFERTO_FUORILISTA.md` r.15, r.43-57, r.77 |
| Frequenza | 🟢 **0,595 op/giorno feriale** — 273 operazioni / 459 feriali. **MISURATA, non derivata** | vedi sotto |

> 🎯 **PRIMO REGALO: la frequenza di questo motore era etichettata `[DERIVATA dal gemello 770511]` in `PERCHE_NON_PASSANO` par.4.1 (~0,60 op/g). Non serve derivarla: 273/459 = 0,595.** L'etichetta si puo' togliere.

### I ROUND, uno per riga

| # | round (data) | modello | finestra | n | PF | DD | fonte (file · riga) |
|---:|---|---|---|---:|---:|---:|---|
| 1 | screening 26/07 | 🟡 **OHLC** | non dichiarata | 273-454 | 1,2-1,33 | 7-8% | `REGISTRO_TEST.md` par. "SupRev su NUOVI INDICI — screen OHLC" |
| 2 | validazione 26/07 | 🟢 **tick** | *"2024.01→2026.06 nominale"* | **273** | **1,20** | **9,8%** | `REGISTRO_TEST.md` **r.404** · profit +560 · rischio 1% |
| 3 | 🆕 **FASE 0 weekend 07-08/08, asse `InpTF` 11 celle** | 🟢 **tick** | **IS 2024.09.26→2025.06.09** | **118** | **0,92343** | **6,2975%** | `risultati_prove/ABTG_SupRev_DOW_H1_Ottimizzato/ABTG_SupRev_DOW_H1_Ottimizzato_U30USD_IS.csv` **riga 5** · profit −102,96 |
| 3b | idem | 🟢 **tick** | **OOS 2025.06.10→2026.06.30** | 🟢 **155** | 🟢 **1,43648** | 🟢 **4,8184%** | `..._U30USD_OOS.csv` **riga 2** · profit **+622,65** |
| 3c | idem, stessa cella | 🟡 OHLC | IS | 118 | 1,11840 | 4,8849% | `..._IS_ohlc.csv` **riga 8** · profit +138,24 |
| 3d | idem, stessa cella | 🟡 OHLC | OOS | 155 | 1,51796 | 4,7758% | `..._OOS_ohlc.csv` **riga 5** · profit +719,18 |

_Finestre del round 3 dichiarate in `risultati_archivio/REFERTO_WEEKEND_FASE0.md` r.7: **IS 26/09/2024→09/06/2025 · OOS 10/06/2025→30/06/2026**. Rischio = default dell'EA = **1,0%** (colonna `InpRiskPercent` dei CSV). Deposito **10.000** (default del driver)._

> ## 🔥 **LA COSA PIU' IMPORTANTE DI TUTTO IL DOSSIER**
> **`PERCHE_NON_PASSANO` par.5.2 (09/09) propone come mossa n.2 di *"rimisurare la stessa cella con split IS/OOS 40/60 sulla finestra tick 2024.09.26→2026.06.30"*. 🎯 QUEL ROUND E' GIA' STATO FATTO L'08/08, a tick, su quella finestra esatta — e i CSV sono nel repo.**
>
> E dice due cose che **nessun documento del 09/09 riporta**:
> - 🟢 **`n OOS = 155`, cioe' SOPRA il muro dei 150. Su quella finestra il merito NON E' SOSPESO** — ed e' **PF 1,43648 con DD 4,8184%** a rischio 1%. **A 0,65% quel DD scenderebbe intorno al 3,1%** _(aritmetica di casa, DERIVATA, non misurata)_.
> - 🔴 **`n IS = 118`, sotto i 150: e' l'IS ad avere il merito sospeso, non l'OOS.** La sedia e' stata spenta l'11/08 **su un IS rosso il cui campione non basta a giudicare il merito** (Emendamento §A, e la valvola R59: *il campione sottile sospende il giudizio sul MERITO, mai sul RISCHIO*).
>
> 🧮 **E un'identita' aritmetica chiude un dubbio che era agli atti:** `118 + 155 = 273`, **esattamente** l'`n` della validazione del 26/07. `CORSIA_DEMO_CANDIDATI_v2` par.3.1 sospettava che quella corsa girasse su *"2024.01→2026.06 nominale"* quando i tick partono dal 2024.09.26. **L'identita' sull'`n` dice che le due misure descrivono le STESSE operazioni sulla STESSA finestra.** _(Il profitto no: 622,65 − 102,96 = **519,69** contro 560. E' **atteso**: due corse separate ripartono ciascuna dal deposito, quindi il dimensionamento composto e' diverso. E' un **indizio forte, non una prova**: la prova sarebbe rilanciare, e io non lancio.)_

### 🟢 E il trasferimento OHLC→tick, su QUESTA cella, e' MITE — non un crollo

| finestra | PF OHLC | PF tick | delta | `n` |
|---|---:|---:|---:|---:|
| IS | 1,11840 | 0,92343 | **−0,195** | 118 in **entrambi** |
| OOS | 1,51796 | 1,43648 | **−0,081** | 155 in **entrambi** |

👉 **L'`n` e' IDENTICO**: gli ingressi sono gli stessi, cambia solo il riempimento. 🔴 **E' l'opposto dei due collassi documentati della famiglia** (Dow **H4** 2,58→**0,79**, CAC **H4** 7,37→**0,96**). La contro-evidenza sulla famiglia **resta agli atti e va ripetuta ogni volta** — ma su **questa cella** e' misurata e vale −0,08/−0,20, non −1,8.

### ⚠️ E UN ARTEFATTO DEL CENSIMENTO, da segnalare

`report/CENSIMENTO_PF_MISURATI_2026-09-09.md` **r.575** marca questa riga `IS PFmed 0,77 · OOS PFmed 0,73 · vicino = no`. 🔴 **Sono MEDIANE su 11 TF**, cioe' su dieci timeframe su cui la sedia non ha mai girato. **La cella H1 — l'unica reale — sta a PF OOS 1,43648.** Un aggregato non e' un verdetto sulla cella, e questa riga da sola avrebbe seppellito il candidato.

## 2b. IL CERTIFICATO — le 5 caselle

| # | casella | esito | la prova |
|---:|---|:---:|---|
| 1 | **PF misurato?** | ✅ **SI, DUE VOLTE** | tick full-period 1,20 (26/07) **e** tick split 0,92343 / 1,43648 (08/08). Piu' le due letture OHLC |
| 2 | **n e DD?** | 🟡 **quasi** | n 118 + 155 = 273 ✅ · DD 9,8% full @1%, 6,2975 IS / 4,8184 OOS ✅ · 🔴 **peggior giornata [NON MISURATO]** — e con DD 6,3%/4,8% **non e' implicata** |
| 3 | **Gestione dell'uscita ad asse?** | 🔴 **NO — ZERO** | `AUDIT_USCITE_2026-09-09.md` par.1 riga 3: *"`InpTrailOnST` (15 EA), `InpExitOnFlip` (14 EA) e `InpFirstFraction` (14 EA) hanno **zero** occorrenze come asse in tutto il repo"*. **Riverificato oggi, nome per nome, su tutte le 599 prove `.txt`** (conteggio esatto, prima dei file che consegno): `InpTrailOnST` **0** · `InpExitOnFlip` **0** · `InpFirstFraction` **0** · `InpBreakeven` **0** · `InpTP1_R` **0** · `InpSLLookback` **0** · `InpTP1Pct` **1**, ma in `R15_ORB_gestione_DD.txt` = **un altro EA** (`ABTG_ORB_Ottimizzato`) · `InpTP_RR` **7 file**, e **nessuno e' di questo EA** (R18 IBEX, R21 H4 non-indici, R22 GBPJPY sono altri Supertrend; R29/R32 sono EMA200). 👉 **Su `ABTG_SupRev_DOW_H1_Ottimizzato` non esiste UN SOLO asse d'uscita in tutto l'archivio** |
| 4 | **Simboli gemelli provati?** | 🟡 **PARZIALE** | La FAMIGLIA e' stata screenata OHLC il 26/07 su Dow/CAC/Stoxx50/FTSE/Nikkei e ha EA dedicati su DAX e NAS. Ma **questa cella** (`StMult 3,5 / AtrP 9 / TP_RR 3,0`, a tick, con l'asse TF) e' girata **solo su U30USD** |
| 5 | **TF cambiato?** | ✅ **SI, E COMPLETAMENTE** | **11 TF ad asse** (M15, M20, M30, H1, H2, H3, H4, H6, H8, H12, D1) × IS e OOS × tick **e** OHLC = **44 passate**. E' **la casella meglio chiusa dei quattro candidati** |

## 2c. LA VIA PIU' CORTA AL VERDETTO

| via | verdetto | il numero che decide |
|---|---|---|
| 📉 **TF PIU' BASSO** | ❌ **ESCLUSA — ma PER MISURA, non per costo** | 🎯 I tre TF bassi **sono gia' stati misurati a tick, IS e OOS**, e sono **tutti sotto 1,00 fuori campione**: **M30** PF OOS **0,995** (n 369, DD 10,37%) · **M20** PF OOS **0,623** (n 408, DD 19,42%) · **M15** PF OOS **0,732** (n 656, DD **22,33%**). Fonte: `..._U30USD_OOS.csv` righe 6, 8, 9. **Piu' operazioni e PF peggiore, con DD che sfonda il muro prop: li' non c'e' niente da cercare, e il numero lo dice.** |
| 📅 **FINESTRA PIU' LUNGA** | ❌ **CHIUSA** | pavimento 2024.09.26 misurato e completo |
| 🌐 **SIMBOLI GEMELLI** | 🟡 **possibile, ma non prima** | La famiglia ha **due collassi OHLC→tick** documentati su H4; e la casella 4 e' solo mezza vuota. **Non e' la mossa piu' economica** |
| 🚪 **GESTIONE DELL'USCITA** | 🟢🟢 **E' LA VIA, e non e' nemmeno vicina** | E' **l'unica casella completamente NERA** del certificato, su un motore che ha **l'unico merito misurabile a pieno titolo** della corsia. E l'unica accusa mai mossa e' **"IS ROSSO"**: **cio' che una gestione diversa muove per definizione** |

### 🎁 E c'e' un regalo che nessun altro candidato ha: **LA SENTINELLA GRATIS**

I CSV dell'08/08 danno il numero **esatto** che la cella `default` deve riprodurre. 👉 **Il cancello G1 di determinismo non costa una passata in piu': e' gia' pagato dall'archivio.** Se la cella `InpTrailOnST=1` non riproduce `n 118 / PF 0,92343` in IS e `n 155 / PF 1,43648` in OOS, il file e' invalido e non si legge nient'altro.

### 📏 Quanto puo' valere — ordine di grandezza **MISURATO**, su un'altra famiglia
`AUDIT_USCITE_2026-09-09.md` par.2.1 (R46, 14/08, tick, OOS, **stesso identico ingresso**, sei uscite diverse, DAX): **PF da 0,88 a 1,49 e DD da 22,50% a 6,27% cambiando SOLO l'uscita.** Sul Dow, stesso referto: **PF 1,01 → 1,27**.
🔴 **E' un ordine di grandezza, NON una previsione su questo motore. Su SupRev il numero e' [NON MISURATO] e i file che consegno non assumono nessun segno: puo' benissimo peggiorare. Servono a saperlo.**

**File pronti:**
- `backtest_pipeline/prove/A1_SUPREV_DOW_H1_01_trailonst.txt` — asse `InpTrailOnST` (2 celle × 2 finestre = **4 passate**)
- `backtest_pipeline/prove/A1_SUPREV_DOW_H1_02_exitonflip.txt` — asse `InpExitOnFlip` (**4 passate**), si legge **DOPO** il primo

🔴 **Perche' girano a rischio 1,0% e non a 0,65%, dichiarato:** a 0,65% la **sentinella non sarebbe piu' confrontabile con l'archivio** e si perderebbe l'unico cancello di determinismo gratis che abbiamo. La rimisura a 0,65% (che per l'aritmetica di casa porta il DD full-period da 9,8% a ~6,4%) e' una **domanda separata** e va in un **file separato**: una variabile per file.

---

# 3. 🥉 RELATIVO NASUSD — z-score NASUSD/U30USD, M5

## 3a. LA SCHEDA

| campo | valore | fonte |
|---|---|---|
| EA | `mql5/Experts/ABTG_Relativo.mq5` | sorgente |
| Simbolo / TF | **NASUSD M5**, **metro U30USD** (si legge, non si scambia) | `prove/RELATIVO_R117_NAS.txt` |
| Sessione | **14:30 → 22:00 ORA SERVER BCM** | idem |
| Cella | `N=40 · sigma_in 1,35 · sigma_out 0,05 · AtrSL 2,75 · MaxTradesPerDay 5 · Lato 0` | idem |
| Finestra / split | **2024.09.26 → 2026.06.30**, split **40/60** | idem + driver |
| Modello | 🟢 **TICK REALI** | `REGISTRO_TEST.md` par. R117 |
| Rischio | **0,65%** girato direttamente (**nessuna riscalatura**) | `CORSIA_DEMO_RELATIVO_NASUSD.md` par. "Il rischio 0,65% NON e' stato riscalato" |
| Deposito | **[NON MISURATO]** — non dichiarato in nessuna delle due citazioni | — |
| Magic | **774602** (round) · **774690** riservato alla demo, vergine al 07/09 | idem |
| **Dove sta adesso** | 🗄️ **ARCHIVIO.** Scheda di corsia demo scritta il 07/09, magic riservato, **MAI attaccata** (zero occorrenze nel log del 09/09) | verificato oggi |
| Frequenza | **0,525 op/giorno feriale** (media pesata: IS 87/183 = 0,475 · OOS 154/276 = 0,558) | `REGISTRO_TEST.md` par. "A6 NON E' RAGGIUNGIBILE" |

### I ROUND

| # | round | modello | finestra | n | PF | DD | pegg.gio | fonte |
|---:|---|---|---|---:|---:|---:|---:|---|
| 1 | **R117 NASUSD** | tick | IS | **87** | **0,754** | [NON MISURATO] | [NON MISURATO] | `REGISTRO_TEST.md` r.1554-1562 |
| 1b | idem | tick | OOS | **154** | **1,189** | **8,40%** | **−2,12%** | idem · E **+0,063 R** · A7 **0,00%** |
| 2 | **R117 D30EUR** (gamba gemella) | tick | OOS | [NON MISURATO] | **0,452** | **25,01%** | **−5,20%** | `REGISTRO_TEST.md` r.1540-1552 · 🪦 **MORTA PER RISCHIO, non si riapre** |

🟠 **Le due zone morte, da ripetere ogni volta:** E **+0,063 R** (soglia 0,075, muro 0,050) e **DD 8,40%** (soglia R117 8,0, muro prop 10,0). **Il margine dal muro e' 1,60 punti: basta un forward peggiore del backtest di meno di un quinto perche' salti.**
🟠 **E A3 e' incoerente**: IS in perdita (0,754), OOS in utile (1,189), su campioni di taglia molto diversa (87 contro 154). **Puo' essere rumore, non e' dimostrato che lo sia.**

## 3b. IL CERTIFICATO

| # | casella | esito | la prova |
|---:|---|:---:|---|
| 1 | **PF misurato?** | ✅ **SI** | 1,189 OOS a tick |
| 2 | **n e DD?** | ✅ **SI** | 87 / 154 · DD 8,40% · peggior giornata −2,12% |
| 3 | **Gestione dell'uscita ad asse?** | 🔴 **NO** | `InpAtrSL` (2,75 = **lo stop**) **mai** ad asse: verificato oggi su tutte le **599 prove `.txt`** → **0 righe**. `InpBarreMaxTenuta` **mai** ad asse — e il **sorgente stesso lo dichiara INERTE**: `ABTG_Relativo.mq5` r.372, *"tetto di tenuta: **INERTE** dentro una sessione da 90 barre (R6)"*. 👉 **Una manopola dichiarata inerte nel codice e' una casella LIBERA per definizione, non una casella provata** |
| 4 | **Simboli gemelli provati?** | 🟡 **PARZIALE — 2 su n** | NASUSD (viva) e D30EUR (**morta per rischio**). **Mai**: SPXUSD, E50EUR, F40EUR, 100GBP — tutti con tick BCM dal 2024.09.26 **COMPLETI** |
| 5 | **TF cambiato?** | 🔴 **NO** (con l'EA vero) | Esistono `RELATIVO_NAS_M5.txt` e `RELATIVO_NAS_M15.txt`, **ma sono file della SONDA** (`ABTG_SondaRelativo`, `InpModoSonda`: *"NON manda ordini, conta e basta"*). Con l'EA che opera: **solo M5, una volta** |

## 3c. LA VIA PIU' CORTA AL VERDETTO

| via | verdetto | il numero che decide |
|---|---|---|
| 📉 **TF PIU' BASSO** (M1) | ❌ **ESCLUSA PER COSTO, in via cautelare** | Lo stop e' `2,75 × ATR(TF)`: a M1 si accorcia. Il pavimento di lavoro C3 su NASUSD e' **64-72 punti indice** (40 × spread **1,6-1,8** MISURATO, `SPREAD_FLOTTA_MISURA_2026-09-03.md` r.17). 🔴 **Lo stop attuale in punti indice e' [NON MISURATO]** — e' il buco gia' segnalato in `CORSIA_DEMO_CANDIDATI_v2` par.2 come *"l'unica domanda aperta sul piu' veloce dei quattro"*. Finche' manca quel numero, scendere di TF si esclude **col numero del pavimento accanto**, non "perche' e' basso" |
| 📅 **FINESTRA PIU' LUNGA** | 🟡 **gia' pronta, ma non risolve** | **R117BIS e' scritto, pinnato (`48b035cf…`) e mai lanciato**: sposta `@FINOA` a 2026.08.31 e `FrazioneIS` a 0,50. Compra **~2 mesi ≈ +23 operazioni**. Costa **zero lavoro**: si lancia. 🔴 **Ma il verdetto atteso resta MERITO SOSPESO, ed e' scritto nel registro prima dei numeri.** E il pavimento 2024.09.26 non si abbassa |
| 🌐 **SIMBOLI GEMELLI** | 🟢 **E' LA VIA — l'unica che cambia l'ARITMETICA** | A6 **non e' raggiungibile** su questa gamba: 0,525 op/g × 503 feriali disponibili contro **567 necessari**; lo split e' a somma zero, il massimo ottenibile oggi e' **min(n_IS, n_OOS) ≈ 133**; autosoddisfazione **27/11/2026** = **due mesi DOPO l'inizio della challenge**. **Aggiungere un simbolo e' l'unico modo di cambiare quel conto** — ed e' esattamente cio' che dice la firma del 07/09 sul pavimento di FAMIGLIA |

### 🎯 IL GEMELLO GIUSTO E' **SPXUSD**, e c'e' una ragione scritta nel certificato del morto

🔴 **La gamba D30EUR e' BOCCIATA PER RISCHIO e NON si riapre, mai** (DD 25,01% + peggior giornata −5,20% = due muri insieme; `REGISTRO_TEST.md` r.1540-1552 lo blinda: *"NON si ritocca e NON si riprova con una finestra piu' lunga"*).

🟢 **Ma il suo stesso certificato dice PERCHE' era la gamba peggiore gia' PRIMA dei numeri:** la finestra operativa **14:30-22:00 SERVER** e' la seduta cash **USA**, e — testuale — *"dalle 17 server in poi il DAX e' fuori dal suo cash"*. 👉 **Quel test faceva operare un simbolo EUROPEO negli orari AMERICANI.**

**Non e' un argomento per riaprire il D30EUR. E' un argomento per dire che un gemello con la SEDUTA GIUSTA non e' lo stesso test.** SPXUSD ha la stessa seduta cash del metro U30USD, lo stesso orologio, tick dal 2024.09.26 COMPLETI, ed e' gia' un simbolo di casa (ci gira `ABTG_EMA200`).

🧮 **E l'aritmetica cambia davvero:** famiglia `RELATIVO` = NASUSD + SPXUSD ≈ **1,05 op/giorno** _(**[DERIVATA]**: 0,525 × 2, cioe' **assumendo la stessa frequenza sul gemello** — assunzione dichiarata, non misurata)_ → **centra il pavimento di 1,00 firmato il 07/09**.

**File pronto: `backtest_pipeline/prove/A1_RELATIVO_SPXUSD_00_gemello.txt`** (2 celle gemelle sul magic · **4 passate**).

> 🔴 **CON DUE PRE-CONDIZIONI BLOCCANTI, scritte dentro il file:**
> - **P1** — `InpPuntiPerIndice` su SPXUSD: il `100.0` e' **MISURATO sui TRE indici** D30EUR/U30USD/NASUSD (`ABTG_Relativo.mq5` r.392); **su SPXUSD e' [NON MISURATO]**. Va letto dal simbolo **prima** di lanciare, come fatto per D30EUR il 31/08. **Con la conversione sbagliata i lotti sono sbagliati e ogni numero di rischio e' spazzatura.**
> - **P2** — **spread SPXUSD: [NON MISURATO].** `SPREAD_FLOTTA_MISURA_2026-09-03.md` ha **solo** NASUSD, U30USD e D30EUR. Finche' manca, **il cancello C3 su questa gamba non e' compilabile**, e va dichiarato come buco, non aggirato.

---

# 4. 4️⃣ DaxReEntry LATO LONG — D30EUR M5

## 4a. LA SCHEDA

| campo | valore | fonte |
|---|---|---|
| EA | `mql5/Experts/ABTG_DaxReEntry.mq5` | sorgente |
| Simbolo / TF | **D30EUR M5** | `prove/ABTG_DaxReEntry.txt` |
| Orari | range **08:35-11:05** · trading **11:05-14:15** · flat **16:30** — **ORA SERVER BCM** | idem |
| Finestra | **2024.09.26 → 2026.06.30**, **UNA tranche** (`FrazioneIS 1.0`, OOS degenere e ignorata **per dichiarazione**) | idem |
| Modello | 🟢 **TICK REALI** · autotest 0/18 · overnight veri **0%** | `REFERTO_DAXREENTRY_2026-08-31.md` |
| Rischio | **0,65%** · cap 2/giorno (1 per lato) | `prove/ABTG_DaxReEntry.txt` |
| Deposito | **[NON MISURATO]** — non dichiarato nel referto | — |
| Magic | **769300** (round) · **769310** riservato alla demo, vergine al 07/09 | `CORSIA_DEMO_DAXREENTRY.md` r.129-133 |
| **Dove sta adesso** | 🗄️ **ARCHIVIO.** Scheda di corsia demo scritta, magic riservato, **MAI attaccata** (zero occorrenze nel log del 09/09) | verificato oggi |
| Frequenza | **0,200 op/giorno feriale** (92/459) alla cella break 20 LONG = **~4,4 op/mese** | ricalcolo dai numeri primari |

### I ROUND — griglia 18 passate (3 break × 2 SlFrac × 3 lati), **tutte nella stessa corsa** (16:25, pin `a9343f4`)

| break | lato | n | PF | DD | pegg.gio | profit | fonte |
|---:|---|---:|---:|---:|---:|---:|---|
| 20 | 🟢 LONG | **92** | **1,159** | 4,6% | −0,68 | +4.368 | `REFERTO_DAXREENTRY_2026-08-31.md` |
| 30 | 🟢 LONG | 71 | 1,25-1,29 | 3,0-3,5% | −0,69 | +3.925 / +5.053 | idem |
| 40 | 🟢 LONG | 57 | **1,69-1,80** | 2,5-2,9% | −0,67 | +7.168 / +9.518 | idem |
| 20-40 | 🪦 SHORT | 45-94 | **0,38-0,54** | **8,8-23%** | — | tutto rosso | idem — **misurato e MORTO** |
| 20-40 | BOTH | 102-186 | 0,67-1,03 | — | — | rosso/piatto | idem |

🟢 **Take mediano LONG MISURATO: +76,8 punti indice su n=71** = **46,5× lo spread D30EUR (1,65)** → **sopra il pavimento di lavoro**.
⚠️ **Ma la frontiera C3 e' definita sullo STOP, non sul take.** Lo stop in punti indice e' **[NON MISURATO]** (buco gia' segnalato in `CORSIA_DEMO_CANDIDATI_v2` par.2). **Stima DERIVATA** dal take e dall'RR di progetto 2,2:1 dichiarato nel file prova: 76,8/2,2 ≈ **35 punti indice** ≈ **21×** lo spread → **sopra** il pavimento duro (13,3×), **sotto** quello di lavoro (40× = 64-68 punti indice). 🔴 **E' una stima, non una misura.**

## 4b. IL CERTIFICATO

| # | casella | esito | la prova |
|---:|---|:---:|---|
| 1 | **PF misurato?** | ✅ **SI** | 1,159 a break 20; fino a 1,80 a break 40; a tick |
| 2 | **n e DD?** | ✅ **SI** | n 57 / 71 / 92 · DD 2,5-4,6% · peggior giornata −0,67 / −0,69% |
| 3 | **Gestione dell'uscita ad asse?** | 🔴 **QUASI NO — e con una manopola INERTE dichiarata** | Il motore **non ha un take profit**: l'uscita e' **solo** SL + flat orario. L'unico asse d'uscita mai scritto e' `InpSlFracRange`, e il file prova **lo dichiara degenere**: *"dichiarato ma di FATTO a UN valore (0,454): con step 0,300 il secondo passo (0,754) supera lo stop (0,700)"*. Poi MT5 ne ha dati **due** (18 passate invece di 9) e il referto conclude *"SL-fraction insensibile"*. `InpMinStopPts` **mai** ad asse su questo EA. 👉 **Un asse dichiarato degenere e poi giudicato "insensibile" non e' un asse provato: e' una manopola che non ha morso** |
| 4 | **Simboli gemelli provati?** | 🔴 **NO** | **Solo D30EUR.** **F40EUR** (CAC) ed **E50EUR** (Stoxx50) — **stessa seduta europea, stesso orologio, tick BCM dal 2024.09.26 COMPLETI** — mai provati, **zero volte** |
| 5 | **TF cambiato?** | 🔴 **NO** | **Solo M5, una corsa sola.** Mai M1, mai M15 |

## 4c. LA VIA PIU' CORTA AL VERDETTO

> ### 🔥 **QUI C'E' LA COSA CHE NESSUNO AVEVA GUARDATO**
> Su quasi tutti i nostri motori intraday la via "TF piu' basso" e' chiusa dal costo, perche' **lo stop e' figlio della BARRA** (ATR del TF, minimi a N barre): scendere di TF lo accorcia e il rapporto `stop / spread` sfonda la frontiera C3.
>
> 🎯 **Su DaxReEntry NO, e si legge nel sorgente — `ABTG_DaxReEntry.mq5` riga 81:**
> ```
> input double InpSlFracRange = 0.454; // SL = estremo del range +/- (range * questa frazione)
> ```
> **Lo stop e' una frazione del RANGE MATTUTINO 08:35-11:05 SERVER.** Il range e' lo **stesso identico intervallo di orologio** a M1 e a M5.
> 👉 **SCENDERE DI TF NON ACCORCIA LO STOP. Il pedaggio C3 non peggiora.**
> **E' l'unico dei quattro candidati A1 per cui questo e' vero.**

| via | verdetto | il numero che decide |
|---|---|---|
| 📉 **TF PIU' BASSO (M1)** | 🟢 **E' LA VIA** | La casella 5 e' **completamente vuota** e la frontiera del costo **non la punisce**. Cosa cambia davvero: la **granularita' della CONFERMA del reclaim** (*"reclaim confermato a barra chiusa"*). A M1 si conferma prima e in giornate in cui la barra M5 non lo stampava. 🧮 **E il tetto giornaliero non e' il vincolo**: 92 LONG su 459 feriali = **0,20 al giorno** contro un tetto di **1 LONG al giorno**. Lo spazio c'e' |
| 🌐 **SIMBOLI GEMELLI** | 🟡 **seconda mossa, con due pre-condizioni** | F40EUR ed E50EUR condividono la **seduta europea** e hanno i tick dal 2024.09.26. 🔴 Ma per entrambi **`InpMT5PerPuntoIndice` e' [NON MISURATO]** (il 100 e' misurato su D30EUR il 31/08) **e lo spread e' [NON MISURATO]** (`SPREAD_FLOTTA_MISURA` copre solo 3 simboli). **Due misure da fare prima, entrambe da sola lettura** |
| 📅 **FINESTRA PIU' LUNGA** | ❌ **CHIUSA** | pavimento 2024.09.26 misurato e completo |

### 🚫 E UNA VIA CHE **RIFIUTO**, con il motivo scritto
Il referto del 31/08 dichiara come prossimo passo *"eventuale estensione bordo break {40..70} LONG-only"*. **Non la propongo, e dico perche':** a `break=40` l'`n` e' gia' **57**; salire lo porta verso 40 e sotto. **Cercare un PF piu' alto riducendo il campione e' esattamente la caccia al picco che la regola del 19/08 vieta — e qui il muro E' il campione.** Se un giorno si vuole mappare il bordo, si mappa **dopo** aver risolto il campione, non prima.

**File pronto: `backtest_pipeline/prove/A1_DAXREENTRY_M1_00_long.txt`** — `@PERIODO M1`, cella `break=20` **LONG-ONLY** (`InpSide=0`: lo short e' misurato e morto), 2 celle gemelle sul magic · **4 passate**.

> 🔴 **CON UN RISCHIO DI BANCO DICHIARATO PRIMA, non scoperto dopo (soglia D7 nel file):**
> `CLAUDE.md` (regola 25/08) dichiara un tetto di **~100.000 barre** per corsa, che *"limita M15 a ~4 anni e M5 a ~1,3 anni"*. Questa corsa e' **M1 su 21 mesi**. **Se il tetto morde, il tester TRONCA la finestra e i numeri non sono confrontabili con quelli di M5.**
> 👉 **Controllo obbligatorio PRIMA di leggere qualunque numero:** la data della prima operazione nel per-trade CSV deve stare a ridosso del **2024.09.26**. Se parte molto dopo, **il file e' INVALIDO** e la corsa va spezzata in tranche, dichiarandolo.

---

# 5. 📦 I FILE PROVA CONSEGNATI — tutti **PASS** a `controlla_prova.py`

```
=== CONTROLLO FILE PROVA ===
  A1_DAXREENTRY_M1_00_long.txt       ABTG_DaxReEntry.mq5                pin=22 celle= 2  OK
  A1_NYRETEST_NASUSD_00_nudo.txt     ABTG_NySessionRetest.mq5           pin=24 celle= 2  OK
  A1_RELATIVO_SPXUSD_00_gemello.txt  ABTG_Relativo.mq5                  pin=28 celle= 2  OK
  A1_SUPREV_DOW_H1_01_trailonst.txt  ABTG_SupRev_DOW_H1_Ottimizzato.mq5 pin=41 celle= 2  OK
  A1_SUPREV_DOW_H1_02_exitonflip.txt ABTG_SupRev_DOW_H1_Ottimizzato.mq5 pin=41 celle= 2  OK

file: 5 | celle totali: 10 | passate (celle x 2 finestre): 20 | problemi: 0
ESITO: OK
```
✅ **ASCII puro verificato** su tutti e cinque: `LC_ALL=C grep -n '[^ -~\t]'` → **zero righe**.
✅ **UNA variabile per file.** ✅ **Attesa dichiarata PRIMA dei numeri** in ogni file. ✅ **Soglie congelate col numero** in ogni file. ✅ **Magic vergini verificati repo-wide oggi** (769520/769521, 970960/970961, 774640/774641, 769320/769321 → **0 occorrenze ciascuno**).

| file | candidato | asse | tipo di asse | celle | passate |
|---|---|---|---|---:|---:|
| `A1_SUPREV_DOW_H1_01_trailonst.txt` | SupRev DOW H1 | `InpTrailOnST` 0/1 | 🚪 **gestione dell'uscita** | 2 | 4 |
| `A1_SUPREV_DOW_H1_02_exitonflip.txt` | SupRev DOW H1 | `InpExitOnFlip` 0/1 | 🚪 **gestione dell'uscita** | 2 | 4 |
| `A1_DAXREENTRY_M1_00_long.txt` | DaxReEntry LONG | magic gemelli | 🔧 **tecnico (G1)** — la variabile vera e' `@PERIODO M1` | 2 | 4 |
| `A1_NYRETEST_NASUSD_00_nudo.txt` | NY Retest | magic gemelli | 🔧 **tecnico (G1)** — la variabile vera e' `@SIMBOLO NASUSD` | 2 | 4 |
| `A1_RELATIVO_SPXUSD_00_gemello.txt` | RELATIVO | magic gemelli | 🔧 **tecnico (G1)** — la variabile vera e' `@SIMBOLO SPXUSD` | 2 | 4 |

---

# 6. 💰 IL COSTO IN TEMPO MACCHINA

## 6.1 Le due ancore, e sono DERIVATE da referti (non cronometrate da me)

| ancora | conto | risultato |
|---|---|---|
| **A — indici, TF alti, tick, 21 mesi** | `REFERTO_FUORILISTA.md` prima riga: *"5 walk-forward a tick reali in **40 minuti** di coda (**11 celle** TF ciascuno)"* = 5 × 11 × 2 finestre = **110 passate** | **~22 s / passata** |
| **B — indici, M15, tick, 21 mesi** | `REFERTO_NYRETEST_2026-08-31.md`: corsa 48 celle alle **11:10**, corsa successiva alle **11:42** → **≤ 32 min per 48 passate** | **≤ ~40 s / passata** |

⚠️ **Approssimazioni dichiarate:** l'ancora B include la preparazione della corsa successiva, quindi e' un **tetto**. E **nessuna delle due misura il costo di PRIMA COSTRUZIONE della cache tick su un simbolo nuovo**, che e' la parte lenta: **[NON MISURATO]**.

## 6.2 Il preventivo

| file | TF | passate | calcolo puro (dalle ancore) | stima realistica |
|---|---|---:|---|---|
| `A1_SUPREV_..._01_trailonst` | H1 | 4 | ~1,5 min | **~5 min** |
| `A1_SUPREV_..._02_exitonflip` | H1 | 4 | ~1,5 min | **~5 min** |
| `A1_NYRETEST_NASUSD_00_nudo` | M15 | 4 | ~3 min | **10-20 min** (prima cache tick NASUSD M15) |
| `A1_RELATIVO_SPXUSD_00_gemello` | M5 | 4 | [NON MISURATO] | **20-40 min** (M5 + lettura di un SECONDO simbolo + prima cache SPXUSD) |
| `A1_DAXREENTRY_M1_00_long` | M1 | 4 | [NON MISURATO] | **30-60 min** (M1 su 21 mesi + rischio tetto barre) |
| **TOTALE** | | **20** | | 🟢 **~1,2 - 2,2 ore di banco** |

> 💡 **Per confronto:** una griglia da 600 passate non la lancia nessuno. **Venti passate, in cinque file, con la sentinella gratis dentro il primo. Questo si lancia stasera.**

## 6.3 L'ordine che consiglio, con la challenge fra ~3 settimane

| # | file | perche' primo |
|---:|---|---|
| 🥇 | `A1_SUPREV_..._01_trailonst` + `_02_exitonflip` | **~10 min in tutto**, l'EA e' compilato dal 26/07, la **casella e' completamente nera**, e la **sentinella di determinismo e' gia' pagata dall'archivio**. Il rapporto valore/costo piu' alto del dossier |
| 🥈 | `A1_DAXREENTRY_M1_00_long` | l'unica discesa di TF **gratis** del lotto, e attacca **direttamente** il muro del campione |
| 🥉 | `A1_NYRETEST_NASUSD_00_nudo` | apre il candidato col **miglior profilo di rischio** dell'archivio su un secondo simbolo. Va **prima** dell'asse slope, per forza: il 75 non si trasferisce |
| 4️⃣ | `A1_RELATIVO_SPXUSD_00_gemello` | 🔴 **ha DUE pre-condizioni bloccanti** (P1 conversione, P2 spread). Non si lancia finche' non sono chiuse |

---

# 7. 🙋 TRE COSE CHE CLAUDIO PUO' CHIUDERE LUI, e valgono piu' di un round

_Si e' messo a disposizione per fare ricerche in prima persona. **Questi sono buchi che lui puo' chiudere in minuti, in SOLA LETTURA**, e ognuno sblocca qualcosa di scritto qui sopra._

| # | cosa | quanto costa | cosa sblocca |
|---:|---|---|---|
| 1 | 📏 **Leggere `digits` e `point` di SPXUSD, F40EUR, E50EUR** in MT5 (sola lettura, Vista simboli) | minuti | Chiude **P1** del RELATIVO SPXUSD **e** la pre-condizione dei gemelli DaxReEntry. Senza, i lotti sono sbagliati e i numeri di rischio sono spazzatura |
| 2 | 💸 **Estendere il logger dello spread a SPXUSD, F40EUR, E50EUR** — lo strumento **esiste gia'** e ha gia' prodotto i tre indici il 03/09 | una sessione di raccolta | Chiude **P2** e rende **compilabile il cancello C3** su tre simboli nuovi. Oggi la frontiera del costo si sa calcolare **solo su tre simboli su dodici** |
| 3 | 📐 **Lo stop mediano in punti indice** delle celle vive di RELATIVO NASUSD e DaxReEntry LONG | si legge dai per-trade CSV, se esistono ancora sul PC di backtest | Chiude il buco C3 che questo dossier ha dovuto **stimare** su DaxReEntry (~35 pt, DERIVATA) e **dichiarare ignoto** su RELATIVO |

---

# 8. 🕳️ I BUCHI DI QUESTO DOSSIER — dichiarati, non tappati a mente

1. 🔴 **CSV grezzi assenti per tre candidati su quattro** (NY Retest, RELATIVO, DaxReEntry): due citazioni indipendenti ciascuno, **zero file di misura primari**. Non e' un motivo per non misurare; **lo sarebbe per promuovere**.
2. 🔴 **La peggior giornata di `SupRev DOW H1` non e' producibile** senza toccare l'EA: il sorgente **non scrive un CSV riga-per-operazione** e la colonna non esiste nel CSV di ottimizzazione MT5. **Restera' [NON MISURATO] anche dopo i due round che propongo.** Toccare l'EA e' fuori dal mio perimetro.
3. 🔴 **Lo stop in punti indice e' [NON MISURATO]** per RELATIVO (tutti i TF) e per DaxReEntry (stimato per derivazione). 👉 **Il cancello C3 su quei due non e' compilabile oggi.**
4. 🔴 **Lo spread e' [NON MISURATO]** su SPXUSD, F40EUR, E50EUR (e su tutto il forex e l'oro — riga H12, aperta da sette dossier).
5. 🔴 **Un solo regime, per tutti e quattro.** L'Emendamento della Finestra **regola C non e' soddisfatta da nessuno**, e **nessuna** delle vie che propongo la soddisfa. Ogni verdetto che uscira' da questi file e' un verdetto **dentro un toro**.
6. 🔴 **Lo slippage non e' misurato**: `ABTG_SlippageLogger` sul reale ha ancora **0 deal**. Ogni numero qui e' al netto di uno slippaggio **assunto**, non misurato.
7. 🟡 **Il tetto delle barre del tester su M1 non e' verificato** (soglia D7 del file DaxReEntry). E' un controllo scritto, non un problema risolto.
8. 🟡 **Le stime di tempo macchina sono DERIVATE da due referti** e non includono la prima costruzione della cache tick. Possono sbagliare **al rialzo**.
9. 🟡 **L'identita' `118+155=273`** che collega la corsa del 26/07 a quella dell'08/08 e' un **indizio forte, non una prova**: la prova sarebbe rilanciare, e **io non lancio**.

---

# 9. 🏁 IL VERDETTO SULLA MISSIONE

> ## 🔓 **NESSUNO DEI QUATTRO E' MORTO. E DI NESSUNO DEI QUATTRO SI PUO' SCRIVERE "MORTO", perche' a tutti e quattro manca almeno una casella del certificato.**

| candidato | caselle NO | la via | costo | 🎯 il fatto nuovo trovato oggi |
|---|---|---|---:|---|
| **SupRev DOW H1** | **3** (uscita: ZERO) | 🚪 gestione dell'uscita | **~10 min** | **Lo split IS/OOS esiste gia': `n OOS = 155 ≥ 150` con PF 1,43648 e DD 4,82%. Su quella finestra il merito NON e' sospeso** |
| **DaxReEntry LONG** | **3, 4, 5** | 📉 TF a M1 | ~30-60 min | **Lo stop e' figlio del RANGE, non della barra: scendere di TF non paga pedaggio C3** |
| **NY Retest slope 75** | **3 (parziale), 4** | 🌐 gemello NASUSD | ~10-20 min | **Il gate e' in punti indice ASSOLUTI: il "75" non si trasferisce. Avviso dato prima del danno** |
| **RELATIVO NASUSD** | **3, 4 (parziale), 5** | 🌐 gemello SPXUSD | ~20-40 min + 2 pre-condizioni | **`InpBarreMaxTenuta` e' dichiarato INERTE nel sorgente stesso: e' una casella libera, non una casella provata** |

🔴 **E il limite, che fa parte dello stesso mandato:** **nessuno di questi cinque file allarga la griglia dei parametri d'INGRESSO.** Due muovono **la gestione dell'uscita**, due muovono **il simbolo**, uno muove **il TF**. Sono esattamente le tre corsie su cui la regola del 19/08 dice ✅, e nessuna delle corsie su cui dice ❌.
🔴 **E ogni allargamento e' pagato:** i due gemelli **sono** una prova fuori campione (dati che il motore non ha mai visto), e i due file sull'uscita hanno una **sentinella di determinismo** che li invalida se il banco non riproduce l'archivio.

> ## 🔥 **"SI CONTROLLA TUTTO AL CENTESIMO E SE CI SI RENDE CONTO CHE COMUNQUE POTREBBE PASSARE, SI INSISTE."**
> Controllato al centesimo: `1,43648` · `n=155` · `118+155=273`. **E si', potrebbe passare.**

---

_Fonti primarie, tutte nel branch `lavoro`: `backtest_pipeline/REGISTRO_TEST.md` (r.390-410, r.1540-1600) · `backtest_pipeline/risultati_prove/ABTG_SupRev_DOW_H1_Ottimizzato/*.csv` · `backtest_pipeline/risultati_archivio/REFERTO_NYRETEST_2026-08-31.md` · `REFERTO_DAXREENTRY_2026-08-31.md` · `REFERTO_FUORILISTA.md` · `REFERTO_WEEKEND_FASE0.md` · `REFERTO_SONDA_STORICO_17-08.md` · `SPREAD_FLOTTA_MISURA_2026-09-03.md` · `CENSIMENTO_PF_TUTTI_2026-09-09.csv` · `backtest_pipeline/prove/` (628 file) · `backtest_pipeline/coda/referti/CODA_01_sedie_attaccate_20260909_033002.log` · `report/AUDIT_USCITE_2026-09-09.md` · `report/CENSIMENTO_PF_MISURATI_2026-09-09.md` · `report/PERCHE_NON_PASSANO_2026-09-09.md` · `report/CORSIA_DEMO_NYRETEST.md` · `report/CORSIA_DEMO_RELATIVO_NASUSD.md` · `report/CORSIA_DEMO_DAXREENTRY.md` · `report/CORSIA_DEMO_CANDIDATI_v2.md` · `mql5/Experts/ABTG_{NySessionRetest,Relativo,DaxReEntry,SupRev_DOW_H1_Ottimizzato}.mq5`._
_**Se un referto e questo documento divergono, comanda il referto.**_
