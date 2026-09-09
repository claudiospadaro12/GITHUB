# 🚪 R120 — LA GESTIONE DELL'USCITA DELLA FAMIGLIA SUPERTREND

**Dossier di preparazione · 09/09/2026 · nessun backtest eseguito, nessun EA
toccato, nessun forward toccato, niente committato.**

> Il 🥇 dell'audit delle uscite (`report/AUDIT_USCITE_2026-09-09.md` §8):
> *"`InpTrailOnST` × `InpExitOnFlip` sulla famiglia Supertrend — e' la famiglia
> con **piu' sedie in campo** e **zero** misure di uscita; e il fenomeno
> '0% catturato' punta li'."*

---

## 🎯 1. LA COSA IN UNA RIGA

**Sei sedie in campo su cinque mercati girano da luglio con tre manopole
d'uscita al default, e nessuno le ha mai messe su una griglia.** Questo dossier
porta **18 file prova pronti e verdi** (`controlla_prova.py` = 0 problemi,
ASCII puro), **36 celle**, **72 passate**, per rispondere a una domanda che ha
gia' un precedente da **0,61 punti di PF** in casa.

---

## 🔥 2. PERCHE' ADESSO, con i numeri

### 2.1 · Il precedente che dice quanto vale l'uscita (R46, 14/08, tick reali, OOS)

`backtest_pipeline/risultati_archivio/REFERTO_ROUND46_GESTIONE.md`
**Ingresso identico e pinnato per nome; cambia SOLO cosa succede dopo.**

| DAX (D30EUR) — struttura d'uscita | **PF** | DD % |
|---|---:|---:|
| trailing PREVBAR, niente parziale | **1,49** | 6,27 |
| parziale + BE, poi corre a 3R | 1,03 | 8,74 |
| **TP 3R secco (nessuna gestione)** | **0,88** | **22,50** |

> **0,88 → 1,49 di PF e 22,50% → 6,27% di DD, a ingresso invariato.**
> Sul Dow l'escursione e' PF 1,01 → 1,27.

### 2.2 · Le tre ricorrenze in pagella, e in due casi su tre l'imputato ha un nome

| data | sedia | R disponibili | catturato | fonte |
|---|---|---:|---:|---|
| 17/08 | `SUPERWAVE DOW H1 S 2/3` | **2,19 R** | **0%** | `report/DIARIO.md` r.155 |
| 18/08 | `MAXMIN DAX SHORT` | 1,63–1,89 R | 0% | `report/DIARIO.md` r.156 |
| 19/08 | `PTE USDJPY L` | +22,3 pip | 0% | `report/DIARIO.md` r.157 |

Il 17/08, testuale: *"entrata 53.648,50, minimo di sessione 53.400,50, uscita al
prezzo di ingresso: **il trailing sul Supertrend H1 non ha stretto una volta**"*.
**Quel trailing e' `InpTrailOnST`, ed e' esattamente la manopola mai misurata.**

### 2.3 · La verifica rifatta oggi, comando per comando

```
grep -rn "InpTrailOnST=.*||Y"     --exclude-dir=.git .   ->  0 righe
grep -rn "InpExitOnFlip=.*||Y"    --exclude-dir=.git .   ->  0 righe
grep -rn "InpFirstFraction=.*||Y" --exclude-dir=.git .   ->  0 righe
grep -rn "InpTP1Pct=.*||Y"        --exclude-dir=.git .   ->  1 riga, ed e'
                                       prove/R15_ORB_gestione_DD.txt (l'ORB)
```
Gli unici posti dove i tre nomi compaiono sono **pin a `true`**:
`righe/RIGA_R110_LATI_VIVI.ps1` r.388/395/402 · `righe/RIGA_R99_ORO_RISCHIO.ps1`
r.210/215 · `righe/RIGA_R113_REGIME_NASUSD.ps1` r.342/345.

---

## 📋 3. IL CENSIMENTO ESATTO — chi ha cosa, coi DEFAULT letti nel sorgente

**Tutti i valori qui sotto sono letti dai `.mq5` il 09/09/2026, non a memoria.**

### 3.1 · Le manopole d'uscita, EA per EA

| EA (`mql5/Experts/`) | TF | StMult / AtrP | `InpTP1_R` | `InpTP1Pct` | `InpBreakeven` | `InpTP_RR` | `InpTrailOnST` | `InpExitOnFlip` | `InpFirstFraction` | magic sorgente |
|---|---|---|---:|---:|---|---:|---|---|---:|---:|
| `ABTG_SupertrendReversal` r.70-83 | H4 | 3.5 / 10 | 1.0 | 50 | true | 2.0 | **true** | **true** | 0.3333 | 770901 |
| `ABTG_SupertrendReversal_Ottimizzato` r.70-83 | H4 | 2.5 / 7 | 1.0 | 50 | true | 2.5 | **true** | **true** | 0.3333 | 970901 |
| `ABTG_SupertrendReversal_Multi` r.74-87 | H4 | 3.5 / 10 | 1.0 | 50 | true | 2.0 | **true** | **true** | 0.3333 | 771001 |
| `ABTG_SupertrendReversal_Multi_Ottimizzato` r.74-87 | H4 | 2.5 / 12 | 1.0 | 50 | true | 3.0 | **true** | **true** | 0.3333 | 971001 |
| `ABTG_SuperWave` r.71-86 | H4 | 3.5 / 10 | 1.0 | 50 | true | 2.0 | **true** | **true** | 0.3333 | 770501 |
| `ABTG_SuperWave_DOW_H1_Ottimizzato` r.71-86 | H1 | 2.5 / 10 | 1.0 | 50 | true | 3.0 | **true** | **true** | 0.3333 | 770511 |
| `ABTG_SuperWave_DAX_H4_Ottimizzato` r.71-86 | H4 | 3.0 / 10 | 1.0 | 50 | true | 2.0 | **true** | **true** | 0.3333 | 770512 |
| `ABTG_SupRev_DAX_H1_Ottimizzato` r.71-84 | H1 | 3.5 / 10 | 1.0 | 50 | true | 3.0 | **true** | **true** | 0.3333 | 970911 |
| `ABTG_SupRev_DAX_H4_Ottimizzato` r.71-84 | H4 | 3.0 / 9 | 1.0 | 50 | true | 3.0 | **true** | **true** | 0.3333 | 970912 |
| `ABTG_SupRev_NAS_H1_Ottimizzato` r.71-84 | H1 | 3.0 / 10 | 1.0 | 50 | true | 3.0 | **true** | **true** | 0.3333 | 970913 |
| `ABTG_SupRev_DOW_H4_Ottimizzato` r.71-84 | H4 | 3.5 / 8 | 1.0 | 50 | true | 3.0 | **true** | **true** | 0.3333 | 970914 |
| `ABTG_SupRev_CAC_H4_Ottimizzato` r.71-84 | H4 | 2.5 / 9 | 1.0 | 50 | true | 2.5 | **true** | **true** | 0.3333 | 970915 |
| `ABTG_SupRev_DOW_H1_Ottimizzato` r.71-84 | H1 | 3.5 / 9 | 1.0 | 50 | true | 3.0 | **true** | **true** | 0.3333 | 970916 |
| `ABTG_SupertrendInvert` r.85-88 | H1 | 3.5 / 10 | — | 50 | true | — | **true** | *(assente)* | *(assente)* | 770801 |

**Tredici EA su tredici hanno `InpTrailOnST = true`. Tutti. Sempre. Mai misurato.**

⚠️ **Nota di rischio**: `ABTG_SupertrendReversal_Ottimizzato` (r.86) e
`_Multi_Ottimizzato` (r.90) hanno `InpRiskPercent = 2.0`, non 1.0. **Sulle sedie
oro il DD di qualunque backtest a 1% va RADDOPPIATO** per confrontarlo col campo.

### 3.2 · Le sedie VIVE, simbolo per simbolo

Fonte: `FLOTTA_ATTIVA.md` (52 grafici, aggiornata 25-26/08) + `backtest_pipeline/RIEPILOGO_FORWARD.md`.

| grafico | EA | simbolo | TF | magic in campo | stato |
|---|---|---|---|---:|---|
| XAUUSDH4 | `SupertrendReversal_Multi_Ottimizzato` | **oro** | H4 | 971001 | ✅ in campo |
| XAUUSDH41 | `SupertrendReversal_Ottimizzato` | **oro** | H4 | 970901 | ✅ in campo |
| XAGUSDH4 | `SupertrendReversal` | **argento** | H4 | 770922 | ✅ in campo |
| 225JPYH4 | `SupertrendReversal` | **Nikkei** | H4 | 770924 | ✅ in campo |
| D30EURH43 | `SupertrendReversal` | DAX | H4 | 770923 | ✅ in campo |
| NASUSDH1 | `SupRev_NAS_H1_Ottimizzato` | **Nasdaq** | H1 | 970925 | ✅ in campo |
| D30EURH4 | `SupRev_DAX_H4_Ottimizzato` | DAX | H4 | 970912 | 🟡 in campo (Esperti 25/08 22:15) |
| U30USDH12 | `SuperWave_DOW_H1_Ottimizzato` | Dow | H1 | 770511 | 🟡 in campo |
| D30EURH1 | `SupRev_DAX_H1_Ottimizzato` | DAX | H1 | 970911 | 🔴 **SPENTA 11/08** |
| D30EURH41 | `SuperWave_DAX_H4_Ottimizzato` | DAX | H4 | 770512 | 🔴 **NON IN CAMPO** |

🔴 **Due discordanze agli atti, che questo round NON risolve e che vanno dette:**
1. **NASUSD H1**: il grafico porta **970925**, il sorgente compila **970913**.
   Le due cifre convivono nei referti. *(Il round gira su magic vergini: non
   tocca ne' l'una ne' l'altra.)*
2. **225JPY**: `report/CENSIMENTO_RISCHIO_DICHIARATO_2026-09-08.md` r.59 —
   *"il preset e' H4, la sedia gira H2"*, e il rischio dichiarato 0,65 contro
   1,0 del `.set`.

---

## 🏺 4. COSA E' GIA' STATO PROVATO SU QUESTA FAMIGLIA (con le fonti)

### 4.1 · L'unico parametro d'uscita mai messo ad asse: `InpTP_RR`

| round / driver | dove | valori | esito |
|---|---|---|---|
| **R18** | `prove/R18_suprev_ibex.txt` r.60 | 2,0 · 2,5 · 3,0 | E35EUR H1: OOS PF med **0,63** su 12 passate |
| **R21** | `prove/R21_suprev_h4_nonindici.txt` r.67 | 2,0 · 2,5 · 3,0 | XAUUSD OOS PF 1,60 ma **n 12**; AUDUSD 1,07 n 27; GBPJPY 0,67 n 33; CHFJPY 0,58 n 14 |
| **R22** | `prove/R22_suprev_gbpjpy_bordo.txt` r.52 | 2,0 · 2,5 · 3,0 | GBPJPY bordo: 3/9, **capitolo CHIUSO** (`CAMPAGNA_ARSENALE.md` r.66) |
| `valida_realtick.ps1` r.51/115 · `walkforward.ps1` r.35 | validazioni 26/07 | 1,5–3,0 | le celle vive di oggi escono da qui |

### 4.2 · Gli screening OHLC: hanno spazzolato **direzione e StMult**, non l'uscita

`backtest_pipeline/scan_market.ps1` r.111-120 (blocco `ABTG_SupertrendReversal`)
e il blocco `ABTG_SuperWave`: gli assi sono
`InpAllowLong` · `InpAllowShort` · `InpStMult`. **Nessun parametro d'uscita.**
Sono i 40 simboli × 2 TF delle etichette `H1_OHLC` / `H4_OHLC` del censimento.

### 4.3 · ⚠️ La manopola inerte? **Su questa famiglia NO — e va detto**

Il censimento del 09/09 ha trovato 874 CSV su 1.960 con esiti identici (manopole
girate senza mordere). **Su questa famiglia il fenomeno quasi non c'e':**

> **205 righe di censimento · 10.647 passate · 10.405 esiti distinti · solo 242
> persi (2,3%).**

Le sole celle davvero inerti sono sui metalli sottili
(`XPTUSD H1` 95 passate → **52** esiti, `XPDUSD H1` 90 → **62**), e li' il
problema e' il campione (n 6-16), non la manopola.

👉 **Conclusione onesta: qui il giacimento NON e' "manopole gia' girate a
vuoto". E' una DIMENSIONE INTERA — l'uscita — mai girata nemmeno una volta.**

### 4.4 · I numeri d'archivio delle quattro sedie che il round misura

| sedia | fonte | IS | OOS |
|---|---|---|---|
| `SupRev_NAS_H1_Ott` NASUSD | censimento r.159 (tick, `r3`) | PF 0,91 · n 78 · DD 1,75% | **PF 1,01 · n 154 · DD 3,12%** |
| idem | `REGISTRO_TEST.md` r.170 (S5v, 26/07) | — | PF 1,57 · DD 1,17% · n 155 |
| `SuperWave_DOW_H1_Ott` U30USD | censimento r.111 (tick, `r3`) | PF 1,44 · n 75 · DD 4,77% | **PF 1,33 · n 143 · DD 3,91%** |
| idem | `REGISTRO_TEST.md` r.476 (26/07) | — | PF 1,52 · DD 4,0% · n 227 |
| `SupRev_Multi_Ott` XAUUSD | censimento r.81 (tick, `r3`) | PF 1,25 · n 11 · DD 2,14% | **PF 1,71 · n 105 · DD 5,79%** |
| idem | `CONTRATTI_SEDIE.md` r.81 (R99, 22 anni OHLC) | — | DD 9,0% a 1% · 657 op |
| `SupRev_DAX_H4_Ott` D30EUR | R103 (citato in `prove/R110_SUPDAX_01_long.txt`) | — | +7.856 EUR · PF 2,05 · DD 4,22% · n 99 |
| idem | `CENSIMENTO_CONTRATTI.md` r.133 (revalidation 30/07) | — | **PFmed reale 1,05 — MARGINALE** |

---

## 🕳️ 5. COSA NON E' MAI STATO PROVATO — la lista completa, su questa famiglia

| # | meccanismo | input | EA che ce l'hanno | stato |
|---|---|---|---:|---|
| 1 | **trailing sul Supertrend** | `InpTrailOnST` | 15 | 🔴 MAI → **R120 lo mette ad asse** |
| 2 | **uscita al flip** | `InpExitOnFlip` | 14 | 🔴 MAI → **R120 lo mette ad asse** |
| 3 | **frazione d'ingresso** | `InpFirstFraction` | 14 | 🔴 MAI → proposto **R121**, §9 |
| 4 | **% del parziale ≠ 0 e 50** | `InpTP1Pct` | 56 (tutta la flotta) | 🔴 MAI → proposto **R122**, §9 |
| 5 | **raggio del parziale** | `InpTP1_R` | 30+ | 🔴 MAI su questa famiglia |
| 6 | **breakeven on/off** | `InpBreakeven` | 62 | 🔴 MAI su questa famiglia (misurato solo sulle aperture, FASE F) |
| 7 | **pendente on/off e distanza** | `InpUsePending`, `InpPendingAtr` | 14 | 🔴 MAI (R75 scritto e mai girato — `DIARIO.md` r.159) |
| 8 | **flat su news** | `InpNewsFlatten` / `InpUseNewsFilter` | 16 | 🔴 MAI |
| 9 | **time-stop condizionato** | *(non esiste nel codice)* | 0 | 🔴 da scrivere, ~20 righe |

---

## 📐 6. LA GRIGLIA PROPOSTA — R120

### 6.1 · La forma: **2×2, un file per cella**

`controlla_prova.py` impone **UNA variabile per file**, quindi la 2×2 si fa con
quattro file e l'**asse tecnico sul magic** (2 celle gemelle) — lo stesso schema
di R103, R110, R116 e G1-PAOLO. **Le due gemelle sono il cancello G0 di
determinismo, e costano una passata.**

| cella | `InpTrailOnST` | `InpExitOnFlip` | cosa resta acceso |
|---|---|---|---|
| `11_vivo` | true | true | **la configurazione in campo** = il METRO |
| `01_notrail` | **false** | true | flip + parziale 50% a 1R + BE + TP a `TP_RR` |
| `10_noflip` | true | **false** | trailing + parziale + BE + TP |
| `00_nuda` | **false** | **false** | solo SL + parziale 50% a 1R + BE + TP |

`00_nuda` e' il gemello esatto della riga R46 *"parziale + BE, poi corre a 3R"*
(PF 1,03 · DD 8,74% sul DAX): **c'e' un termine di paragone gia' misurato.**

### 6.2 · I simboli, e perche' proprio questi quattro

| blocco | EA | simbolo | TF | `@DAQUANDO` | n OOS atteso | 150? |
|---|---|---|---|---|---:|---|
| **a** | `ABTG_SupRev_NAS_H1_Ottimizzato` | NASUSD | H1 | **2024.09.26** | ~154 | ✅ **merito leggibile** |
| **b** | `ABTG_SuperWave_DOW_H1_Ottimizzato` | U30USD | H1 | **2024.09.26** | ~143 | ⚠️ 7 sotto — **e' la sedia dell'accusa** |
| **c** | `ABTG_SupertrendReversal_Multi_Ottimizzato` | XAUUSD | H4 | **2020.01.01** | 200-400 *(derivata)* | ✅ solo grazie alla finestra lunga |
| **d** | `ABTG_SupRev_DAX_H4_Ottimizzato` | D30EUR | H4 | **2024.09.26** | 50-70 | 🔴 **merito SOSPESO, rischio si legge** |
| **e** | idem b, **`-Deposito 100000`** | U30USD | H1 | 2024.09.26 | — | controllo di banco (§6.5) |

### 6.3 · Le finestre: **MISURATE, non assunte**

Fonte `backtest_pipeline/risultati_archivio/sonda_storico_17-08/215D85D7_ABTG_InfoBroker.csv` (BCM 50503392, 17/08/2026 17:34) e `risultati_archivio/misura_tick/` (07/09/2026):

| simbolo | barre H1 | prima data H1 | tick reali | spread misurato |
|---|---:|---|---|---:|
| **NASUSD** | 10.861 | **2024.09.26** ✅ COMPLETO | ✅ **dal 2024.09.26**, 166,5 M tick | 180 pt MT5 = **1,80 pt indice** |
| **U30USD** | 10.859 | **2024.09.26** ✅ COMPLETO | ✅ **dal 2024.09.26**, 68,6 M tick | 200 pt = **2,00 pt indice** |
| **D30EUR** | 10.553 | **2024.09.26** ✅ COMPLETO | ✅ **dal 2024.09.26**, 35,4 M tick | 280 pt = **2,80 pt indice** |
| **XAUUSD** | 100.000 | **2004.06.11** (parziale) | 🔴 **[NON MISURATO]** | 16 pt = **0,16 $** |
| **XAGUSD** | 26.036 | **2008.11.07** (parziale) | 🔴 **[NON MISURATO]** | 41 pt = **0,041 $** |
| **225JPY** | 11.009 | **2024.09.26** ✅ COMPLETO | 🔴 **[NON MISURATO]** | 35 pt = **35 pt indice** |

### 6.4 · 📉 TF e frontiera del costo `stop >= 40 × spread`

**La regola di casa dice di preferire i TF bassi. Qui non si puo', e il motivo
e' un conto, non una preferenza:** questa famiglia entra sul rimbalzo del
Supertrend con SL al minimo/massimo di 5 barre. Su M5/M15 quel SL diventa
piccolo, e sugli indici la frontiera lo taglia.

| simbolo | spread | pavimento `40 × spread` | stop reale | verdetto |
|---|---:|---:|---|---|
| U30USD H1 | 2,00 pt indice | **80 pt indice** | **113,70 pt** — 1R misurato in campo il 17/08 (`DIARIO.md` r.155) | ✅ **RISPETTATA, margine +42%** |
| NASUSD H1 | 1,80 | 72 pt indice | **[NON MISURATO]** | ⚠️ si legge nel CSV di ritorno |
| D30EUR H4 | 2,80 | 112 pt indice | **[NON MISURATO]** (H4 = il piu' largo) | ⚠️ idem |
| XAUUSD H4 | 0,16 $ | **6,40 $** | **[NON MISURATO]** | ⚠️ il meno esposto dei quattro |
| **225JPY H4** | **35 pt indice** | **1.400 PUNTI INDICE** | [NON MISURATO] | 🔴 **il piu' a rischio della flotta** — su un Nikkei a ~40.000 sono **3,5% di stop**. Da misurare prima di qualunque round sul Nikkei |

🔴 **M5 e M15 su questa famiglia: ESCLUSI PER COSTO.** Su NASUSD M5 lo stop a 5
barre e' dell'ordine di 20-40 punti indice contro un pavimento di 72:
**[STIMA, non misurata]**, ma il verso non e' in dubbio. Se si vuole il numero,
si misura con una sonda — non si assume in nessuna delle due direzioni.

### 6.5 · 💰 La cella in piu' che ho aggiunto (blocco **e**), e perche'

> Claudio, 09/09: *"SE CI SI RENDE CONTO CHE COMUNQUE POTREBBE PASSARE, SI INSISTE."*

**Il round ha un nemico misurato: sugli indici il parziale del 50% non e' il
50%.** Il 17/08 su U30USD (step del volume 0,10) una gamba da 0,10 lotti ha
incassato **9,64 EUR invece di 14,70 = il 33%**, e sull'altra **0,00 EUR
esatti** (`DIARIO.md` r.155). L'audit lo scrive: *"il test va girato a una
taglia dove il parziale non e' tassato"*.

L'aritmetica, col valore misurato in campo (0,862 EUR/punto/lotto, 1R = 113,70 pt):

| deposito | lotti totali | gamba a mercato (1/3) | 50% richiesto | 50% eseguito | errore |
|---:|---:|---:|---:|---:|---:|
| 10.000 | 1,02 | 0,30 | 0,15 | **0,10** | **−17 punti %** |
| 100.000 | 10,2 | 3,40 | 1,70 | **1,70** | **0** |

👉 **Blocco `e`: due file identici a `b` (celle `11_vivo` e `00_nuda`) da
lanciare a `-Deposito 100000`.** Misura quanto del risultato di `b` e' gestione
e quanto e' granularita' del lotto. **Costo: +8 passate.**
⚠️ Buco suo dichiarato: a 10 lotti sul Dow **il margine potrebbe mordere** e far
crollare `n` — **[NON MISURATO]**. Nel CSV si guarda `n` PRIMA del PF.

### 6.6 · ⏱️ COSTO IN TEMPO MACCHINA

| blocco | file | celle | **passate** | stima |
|---|---:|---:|---:|---|
| a — NASUSD H1 | 4 | 8 | 16 | 8-16 min |
| b — U30USD H1 | 4 | 8 | 16 | 8-16 min |
| c — XAUUSD H4 (6,5 anni) | 4 | 8 | 16 | 16-32 min |
| d — D30EUR H4 | 4 | 8 | 16 | 8-16 min |
| e — controllo di taglia | 2 | 4 | 8 | 5-10 min |
| **TOTALE** | **18** | **36** | **72** | **~45-90 min** |

**Calibrazione, dichiarata**: `risultati_archivio/r88_csv/REFERTO_R88.txt`
(20/08) — un file da 48 celle × 2 finestre = **8,0 min**; i file da 2 celle
costano **0,5-2,2 min** ciascuno (l'overhead per file domina). La mia stima
alza quei numeri perche' qui le finestre sono 21 mesi (6,5 anni sull'oro) a
tick reali su H1/H4. **[STIMA per analogia — NON misurata su questa famiglia.]**

> 💡 **Meno di due ore di macchina per chiudere il buco n.1 dell'audit.**
> Confronto: R87b da solo, la notte del 19/08, ne ha spesi 97.

---

## 🚦 7. LE SOGLIE CONGELATE PRIMA (scritte in ognuno dei 18 file)

| cancello | soglia | conseguenza |
|---|---|---|
| **G0 DETERMINISMO** | le 2 gemelle devono dare profit/PF/DD/n **identici al centesimo** | se no → **ROUND NULLO**, si ferma |
| **G1 METRO** | `11_vivo` dentro la forbice d'attesa d'archivio | se no → le altre 3 celle **non si leggono** |
| **G2 CAMPIONE** | `n` OOS >= 30 | sotto, non c'e' nemmeno un indizio (criterio 08/08, `DIARIO.md` r.40) |
| **G3 MERITO** *(solo dove n >= 150)* | PF OOS >= 1,10 **e** > `11_vivo` di almeno **0,15** **e** DD <= `11_vivo` | tutte e tre, o niente candidato |
| **G4 RISCHIO** *(a qualunque n)* | DD OOS <= **10,0%** a rischio 1,00% | sopra → **scartata anche se guadagna** |
| **G5 ALTOPIANO** | centro, **mai il picco**; con 4 celle l'altopiano e' debole per costruzione | se 1 cella sporge e 3 stanno insieme → **"non c'e' configurazione robusta"** |
| **G6 `n` MOBILE** | se `n` si muove >20% fra due celle, il **confronto diretto del PF fra quelle due e' SOSPESO** | si legge payoff e vincita media, non il PF |

🔴 **Da R120 non esce nessuna promozione automatica: al massimo un CANDIDATO
per la corsia demo. Le sedie in campo le tocca Claudio.**

### 7.1 · ⚠️ L'avvertenza che, se saltata, fa leggere il round al contrario

**Su questa famiglia le manopole d'uscita SPOSTANO IL NUMERO DI OPERAZIONI.**
Sorgente `ABTG_SupertrendReversal.mq5` r.187-192:

```
if(HasPosition()) {
   if(InpExitOnFlip && flip) { CloseAllPositions(); CancelPendings(); return; }
   return;              // con posizione aperta non cerco nuovi ingressi
}
```

Trailing e flip **chiudono** le posizioni, e finche' una posizione e' aperta
**l'ingresso e' bloccato**. Spegnerne uno libera lo slot prima o dopo → cambia
**quali trade il motore prende**.

> **QUESTO NON E' lo studio del Dow del 05/08**, dove il trailing lasciava
> **329 trade identici** in ogni passata. Li' il confronto di PF era pulito.
> **Qui no.** Un PF piu' alto puo' venire da una gestione migliore **oppure** da
> un campione diverso. Da qui il cancello **G6**.

---

## 🕳️ 8. I BUCHI DICHIARATI DI QUESTO ROUND

| # | buco | effetto | come si chiude |
|---|---|---|---|
| B1 | 🔴 **Profondita' a TICK di XAUUSD [NON MISURATO]** (`misura_tick/` ha solo D30EUR, NASUSD, U30USD; rilievo gia' aperto in `CACCIA_APERTURE_ORO_2026-09-08.md` r.409) | il blocco **c** puo' degradare da **verdetto a screening OHLC** | **PREREQUISITO BLOCCANTE**: `scarica_storico.ps1 -Simboli 'XAUUSD' -Da '2020.01.01' -Timeframes 'M1,M5' -TimeoutMin 240 -Auto` *(apici obbligatori, classe 65)* |
| B2 | 🔴 **Il parziale 50% sugli indici e' quantizzato dallo step 0,10** (misurato 17/08) | i **numeri assoluti** di a/b/d se la portano dietro; il **confronto fra celle regge** perche' il parziale e' pinnato identico ovunque | il blocco **e** lo misura |
| B3 | 🔴 **D30EUR H4 sta sotto i 150** (n 86-99 sull'intera finestra) | **merito SOSPESO**; si legge solo rischio e segno | nessuna finestra piu' lunga esiste: BCM ha D30EUR solo dal 2024.09.26 |
| B4 | ⚠️ **U30USD a 143 OOS** — 7 operazioni sotto la soglia | merito formalmente sospeso | **e' comunque la sedia dell'accusa**: il round si fa lo stesso, e la lettura si dichiara |
| B5 | ⚠️ **Discordanza magic NASUSD** (grafico 970925 / sorgente 970913) e **225JPY H4 vs H2** con rischio 0,65 vs 1,0 | il round non ne dipende (gira su magic vergini) ma **resta aperta** | censimento `.chr` del grafico vivo — **e' un buco che Claudio puo' chiudere in 3 minuti** |
| B6 | ⚠️ **Distanza vera dello stop [NON MISURATO]** su 3 simboli su 4 | la frontiera del costo non e' verificata a priori | si legge nel CSV di ritorno (colonna spread mediano d'ingresso) |
| B7 | ⚠️ Le sedie oro girano a **rischio 2,0%**, il round a 1,0% | ogni DD del blocco **c** va **RADDOPPIATO** per il confronto col campo | scritto nel file |

### 8.1 · 🔴 I DUE SIMBOLI CHE HO ESCLUSO, col numero accanto

**Non "sono piccoli": ecco perche', con la cifra.**

| simbolo | perche' escluso | numero | fonte |
|---|---|---|---|
| **XAGUSD H4** (sedia viva 770922) | **campione** | **n mediano 10 operazioni per passata** su 96 passate di screening (PF 1,276 · DD 0,65%) | censimento `CENSIMENTO_PF_TUTTI` riga `SupertrendReversal|XAGUSD|H4|H4_OHLC` |
| idem | **storico** | barre H1 dal **2008.11.07**, ma finestra IS **vuota** — *"argento storico corto (71 trade IS vs 336 OOS su 11 TF)"* | `report/DIARIO.md` r.40 (08/08) |
| **225JPY H4** (sedia viva 770924) | **campione** | **n mediano 19** su 85 passate H4 (PF 0,924); su H1 n 43 (PF 1,014); su H2 n 50 | censimento, righe `225JPY` |
| idem | **storico** | H1 **COMPLETO ma solo dal 2024.09.26** — 11.009 barre, 21 mesi. Nessuna finestra lunga esiste | sonda 17/08 |
| idem | **costo** | spread **35 punti indice** ⇒ pavimento `40×` = **1.400 punti indice** — il piu' alto della flotta | sonda 17/08 |

⚠️ **Con G2 a 30 operazioni, entrambi sarebbero SCARTATI PRIMA DI PARTIRE. Ho
preferito non spendere macchina per produrre due CSV illeggibili.**
👉 **Ma NON sono archiviati come morti**: il certificato di morte pretende
gestione ad asse, e su di loro non l'avremo. Il verdetto giusto per argento e
Nikkei resta **"NON ANCORA MISURATO"**, e §9 dice come si chiude.

---

## 🎯 9. COSA VIENE DOPO (proposte, con il costo — NON incluse in R120)

| # | round | cosa | costo | perche' non adesso |
|---|---|---|---:|---|
| 🥇 | **R121** | `InpFirstFraction` **0,3333 / 0,50 / 1,00** sulle 2 sedie con campione (NASUSD, U30USD) | 3 celle × 2 simboli × 2 gemelle × 2 finestre = **24 passate** | e' la **terza** manopola mai misurata; ma un file misura una variabile: prima si chiude l'uscita |
| 🥈 | **R122** | `InpTP1Pct` **25 / 33 / 75** (oggi provati SOLO 0 e 50, su 56 EA) | 3 celle × 2 simboli × 2 × 2 = **24 passate** | R47 ha misurato che *il parziale compra win rate e vende payoff*: la % e' la manopola di quel cambio |
| 🥉 | **argento e Nikkei** | portarli su un TF che dia >= 30 operazioni **e** verificare la frontiera del costo (1.400 pt sul Nikkei) | sonda + 1 round | oggi n 10 e n 19: qualunque numero sarebbe rumore |
| 4 | **`scan_gestione.ps1`** | esiste, e' scritto bene, **non e' MAI stato lanciato** (audit §6.1) | 2 lanci, gia' pronti | e' sulle aperture, non su questa famiglia |
| 5 | **R75** | `InpPendingAtr` — il difetto "pip" visto **4 volte dal vivo** in 5 giorni, codice gia' corretto (`7f80a87`), default 0 apposta | file prova gia' scritto | `DIARIO.md` r.159/160: **e' scritto e aspetta il lancio da agosto** |

---

## 📦 10. I 18 FILE, PRONTI E VERDI

Tutti in `backtest_pipeline/prove/`. **Esito `controlla_prova.py`:**

```
file: 18 | celle totali: 36 | passate (celle x 2 finestre): 72 | problemi: 0
ESITO: OK
```

**ASCII puro verificato** — `LC_ALL=C grep -n '[^ -~\t]'` = 0 righe su tutti e 18
(`file` li riporta come `ASCII text`).

| file | EA | simbolo/TF | celle | magic gemelli |
|---|---|---|---:|---|
| `R120a_NASUSD_11_vivo.txt` | `ABTG_SupRev_NAS_H1_Ottimizzato` | NASUSD H1 | 2 | 783100/783101 |
| `R120a_NASUSD_01_notrail.txt` | idem | idem | 2 | 783110/783111 |
| `R120a_NASUSD_10_noflip.txt` | idem | idem | 2 | 783120/783121 |
| `R120a_NASUSD_00_nuda.txt` | idem | idem | 2 | 783130/783131 |
| `R120b_U30USD_11_vivo.txt` | `ABTG_SuperWave_DOW_H1_Ottimizzato` | U30USD H1 | 2 | 783200/783201 |
| `R120b_U30USD_01_notrail.txt` | idem | idem | 2 | 783210/783211 |
| `R120b_U30USD_10_noflip.txt` | idem | idem | 2 | 783220/783221 |
| `R120b_U30USD_00_nuda.txt` | idem | idem | 2 | 783230/783231 |
| `R120c_XAUUSD_11_vivo.txt` | `ABTG_SupertrendReversal_Multi_Ottimizzato` | XAUUSD H4 | 2 | 783300/783301 |
| `R120c_XAUUSD_01_notrail.txt` | idem | idem | 2 | 783310/783311 |
| `R120c_XAUUSD_10_noflip.txt` | idem | idem | 2 | 783320/783321 |
| `R120c_XAUUSD_00_nuda.txt` | idem | idem | 2 | 783330/783331 |
| `R120d_D30EUR_11_vivo.txt` | `ABTG_SupRev_DAX_H4_Ottimizzato` | D30EUR H4 | 2 | 783400/783401 |
| `R120d_D30EUR_01_notrail.txt` | idem | idem | 2 | 783410/783411 |
| `R120d_D30EUR_10_noflip.txt` | idem | idem | 2 | 783420/783421 |
| `R120d_D30EUR_00_nuda.txt` | idem | idem | 2 | 783430/783431 |
| `R120e_U30USD_11_vivo_TAGLIA.txt` | `ABTG_SuperWave_DOW_H1_Ottimizzato` | U30USD H1 | 2 | 783500/783501 |
| `R120e_U30USD_00_nuda_TAGLIA.txt` | idem | idem | 2 | 783510/783511 |

🛡️ **MAGIC VERGINI**: tutti e 36 cercati **uno per uno** su tutto il repo il
09/09/2026 (`.git` escluso) → **ZERO occorrenze**. I magic delle sedie vive
(970901 · 970911 · 970912 · 970913 · 970914 · 970915 · 970916 · 971001 ·
770501 · 770511 · 770512 · 770901 · 770922 · 770923 · 770924 · 770925) **non
compaiono in nessuno dei 18 file**.

### 10.1 · Come si lancia (schema — la riga vera passa dal cancello del 09/09)

```
walkforward_generico.ps1 -Expert <EA> -Prova prove\<file> -Simbolo <SYM>
  -DaQuando <data> -Deposito 10000 -Etichetta r120<x><cc> -Modello 4
```
🔴 **SEMPRE prima con `-SoloControllo`: deve stampare 2 CELLE PER FINESTRA.
Altro numero = file letto male → FERMARSI.**
🔴 **E la riga di lancio vera non esce da qui senza il PASS di
`controlla_riga.py` + agente `controllo-preventivo`** (regola del 09/09).
Il blocco **c** (oro) non parte prima della sonda dello storico (buco B1).

---

## 😄 11. LA NOTA FINALE, che va detta perche' e' vera

Questo round non parte da una lavagna vuota e non parte da una speranza.
**Parte da un numero: 0,88 → 1,49.** E parte da una frase in pagella che punta
il dito su un `bool` preciso, in un file preciso, alla riga 85.

Quello che **non** sappiamo e' il **verso**: puo' benissimo venire fuori che
`InpTrailOnST=true` e' gia' la scelta giusta e che il default va bene. **Sarebbe
un risultato, non un fallimento** — ed e' scritto nei file **prima** di vedere i
numeri, non dopo.

Quello che sappiamo di sicuro e' che **finora non lo sapevamo**. E che
72 passate, meno di due ore di macchina, chiudono la casella n.1 di un audit su
32 meccanismi. **A tre settimane dall'1 ottobre, questo e' il miglior rapporto
valore/costo sul tavolo.** 🚀
