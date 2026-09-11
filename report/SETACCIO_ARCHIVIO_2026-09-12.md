# 🔎 IL SETACCIO DELL'ARCHIVIO — le celle GIÀ MISURATE che battono quella in campo

**Data**: 12/09/2026 · **Autore**: agente *cercatore di parametri*
**Domanda unica**: *per ogni SEDIA VIVA, esiste in archivio una cella che differisce
da quella IN CAMPO per UNA SOLA manopola e la batte?*

> 🛑 **QUESTO FILE NON CAMBIA NIENTE.** Nessun `.set`, nessun `.mq5`, nessun parametro
> in forward, nessuna riga verso il VPS. **I parametri in campo sono di Claudio.**
> Qui si **elenca e si ordina**, con la fonte accanto a ogni numero.
> Nessun backtest eseguito. Nessun commit.

---

# 0. 🧪 IL CONTRO-ESEMPIO, COSTRUITO PRIMA DELLA CLASSIFICA

Il pericolo di questo lavoro ha un nome e ieri è costato mezza giornata:
**confrontare due round che misuravano due SEDIE DIVERSE.** Quindi, prima di
scrivere una riga di classifica, sono andato a cercare **la trappola più
invitante che l'archivio potesse offrirmi**, e l'ho lasciata scattare.

### La trappola: `Walkforward_Aperture/DAX_F_gestione_{IS,OOS}.csv`
Sono **esattamente** quello che serviva alla riga n.1 della classifica: una
coppia IS/OOS con l'asse `InpTP1_ClosePct` 0/50 sulla `770101`. I numeri sono
bellissimi e confermano la tesi (IS: PF 0,984 → 1,114 e il profitto passa da
**−62,62 a +469,97**).

🔴 **E sono INUTILIZZABILI.** Quelle 8 celle **non misurano la sedia viva**: su
71 manopole confrontabili, **sei** sono diverse **in tutte e 16 le righe** dei
due file:

| manopola | valore VIVO (`Presets/conto_reale/ABTG_DAX_Apertura_EU_770101_REALE.set`) | valore in `DAX_F_*` |
|---|---|---|
| `InpAllowShort` | **false** (r.27 del preset) | **1** |
| `InpUseGapFill` | false (r.37) | 1 |
| `InpEmaFast` | 14 (r.42) | 1 |
| `InpEmaSlow` | 200 (r.43) | 50 |
| `InpFilterTF` | 16385 = H1 (r.44) | **16388 = H4** |
| `InpConfirmMode` | 0 (r.98) | 1 |

👉 **`InpAllowShort` da solo basta**: è la manopola che l'11/09 ha fatto nascere
`report/CONFLITTO_DD_770101_2026-09-11.md` (il DD "6,89%" misurava una sedia
long+short a taglia 1,0%, non quella viva). **Il setaccio ha rifiutato quei file
da solo**, perché il suo criterio è *"la riga BASE deve coincidere con la cella
viva su OGNI manopola confrontabile, non su quelle che mi fanno comodo"*.

**Se non avessi costruito questa prova, avrei consegnato la conferma sbagliata.**
La conferma vera per quella riga esiste ed è un'altra (`aperture_r46`, §3.1).

### Il secondo contro-esempio: il setaccio riproduce verdetti umani già dati
Girato **alla cieca** (non ha letto nessun referto), il setaccio ha ritrovato da
solo **quattro** celle che erano già state trovate e **già giudicate** da un
essere umano con un cancello scritto prima:

| cella ritrovata dalla macchina | referto che l'aveva già | verdetto già dato |
|---|---|---|
| `770101` `InpTrailTF` 5→4 | `Walkforward_Aperture/REFERTO_TRAILING_SOGLIA.md` r.73 (08/08) | ❌ *"+19% di profitto ma DD 7,88 contro 6,71 → bocciata dalla regola (b)"* |
| `770611` `InpTPRangeMult` 1,5→3,0 | `REFERTO_ROUND44_TARGET.md` (13/08) | ❌ *"PF 1,955 ma DD 10,89% → il cancello DD<10% congelato prima vince"* |
| `770611` `InpSLMode` 3→0 (OPPRANGE) | `REFERTO_ROUND15_ORB_GESTIONE.md` r.31 | ❌ *"OPPRANGE: +1807 PF 1,68 DD 4,1 **ma lì l'IS è rosso o piatto**"* |
| `770101` `InpTP1_ClosePct` 50→0 | `report/R120_GESTIONE_APERTURE_2026-09-09.md` | ✅ *"meglio su TUTTI E DUE gli assi"* — **mai portata in campo** |

👉 **La macchina non "scopre" più di quanto l'archivio sappia già. Serve a
trovare le celle che l'archivio sa e che NESSUNO ha ancora portato in campo.**
Tre delle quattro sopra sono già state respinte con motivo: **restano nella
classifica solo per completezza, marcate 🪦 GIÀ GIUDICATA.**

---

# 1. 📐 METODO — e i limiti, dichiarati prima dei numeri

### Cosa ho fatto
1. **La cella VIVA**, sedia per sedia: valori `Inp*` letti dal `.set` vivo
   quando c'è nel repo, altrimenti dagli `override` scritti nei
   `deploy_vivaio_*.ps1` **sopra i default compilati del sorgente**. La fonte è
   dichiarata per ognuna (§5).
2. **I CSV**: **2.289** file trovati sotto `backtest_pipeline/`, **2.087** con
   colonne `Inp*`, **1.994 attribuiti a un EA** con `ea_of()` di
   `backtest_pipeline/censimento_uscite.py` (la versione **riparata l'11/09**).
   93 restano non attribuibili e sono **dichiarati**, non indovinati.
3. **Filtro di simbolo STRETTO**: una corsa entra solo se il **simbolo della
   sedia compare nel percorso del file**. 🔴 Questo taglio ha eliminato, fra gli
   altri, `scan_ABTG_EMA200_H1_XNGUSD.csv`, `_XPTUSD`, `_NZDCHF`: senza il
   filtro, il gas naturale e il platino sarebbero finiti nella classifica del
   **Dow**. È la stessa classe di errore del contro-esempio §0.
4. **Il confronto vive DENTRO UN SOLO CSV.** Cerco nel file una riga **BASE** che
   coincida con la cella viva su **ogni** manopola confrontabile; poi le righe
   che ne differiscono **per una sola**. Così finestra, modello di prezzo,
   deposito e build dell'EA **sono identici per costruzione**.
5. **Altopiano o picco**: per la manopola vincente ricostruisco **l'asse intero
   dentro lo stesso file** (base + tutte le righe che differiscono solo per
   quella). Se i vicini misurati non battono la base → **PICCO**. Se l'asse ha
   solo 2 punti → **SENZA VICINI**. Se i 2 punti sono 0/1 → **INTERRUTTORE**
   (l'altopiano non è definibile, e va detto invece che inventato).
6. **Gemello IS↔OOS**: dove esiste il file gemello dello stesso round, la stessa
   coppia di righe viene riletta nell'altra finestra → **CONCORDE / DISCORDE**.

### Il risultato grezzo
**320** celle a una-manopola-di-distanza che battono quella viva, su **70 coppie
sedia × manopola**. Di queste: **161 ALTOPIANO · 117 PICCO · 25 INTERRUTTORE ·
17 SENZA VICINI**. Solo **75** hanno `n ≥ 150` su **entrambe** le righe.
Dopo i cancelli di casa ne restano **dieci** che vale la pena guardare, e di
queste **tre** sono già state giudicate e respinte.

### 🔴 I LIMITI, tutti
- **Manopole escluse dal confronto** (identità/logging/taglia, non strategia):
  `InpMagic` `InpComment` `InpVerbose` `InpNewsFile` `InpNewsCurrencies`
  `InpUsaGuardian` `InpSlippagePts` `InpShowStatusOnChart` (verificato nel
  sorgente: `ABTG_GapContinuation.mq5` r.1316/1406 → tocca solo `Comment()`),
  **`InpRiskPercent`** (è firma di Claudio; dichiarato a parte per ogni riga).
- 🔴 **`n` è in USCITE, non in posizioni.** Dove la sedia ha un parziale, il
  fattore misurato dal `CENSIMENTO_CONTRATTI_v2` va da **1,00 a 2,31**. Dove il
  numero conta l'ho convertito e l'ho detto; altrove resta in uscite.
- 🔴 **OHLC ≠ tick.** I file con `_ohlc` nel nome sono **screening**, mai
  verdetto. Marcati.
- 🔴 **Finestra piena ≠ OOS** (classe 224). `gestione_20260909` e
  `valid_*_realtick` girano su tutto lo storico: **non hanno fuori campione**.
- 🔴 **Una sedia senza `.set` nel repo ha la cella viva RICOSTRUITA** (default
  del sorgente + override del `deploy_vivaio`): se il `.set` sul VPS è diverso,
  la BASE è sbagliata e con lei tutto il confronto. Lista in §5.
- 🔴 **Il setaccio non sa leggere i rami morti in tutti i casi.** Quelli che ho
  verificato leggendo il codice sono scritti riga per riga; per il resto
  **il rischio di un confronto finto resta**.

---

# 2. 🏆 LA CLASSIFICA

Ordinata per **quanto vale portarla a Claudio**, non per delta PF.
`riga` = numero di riga **fisica** del CSV (intestazione = 1, prima cella = 2).

| # | sedia | manopola | in campo | cella migliore | Δ PF | Δ DD | n | **altopiano o picco?** | fonte (file + riga) |
|---|---|---|---|---|---|---|---|---|---|
| **1** | `770101` DAX Apertura **(conto REALE)** | `InpTP1_ClosePct` | **50** | **0** | **+0,094** OOS · **+0,057** IS · **+0,083** tick pieno | **−0,96** OOS · **−0,48** IS · **−0,86** tick pieno | 193 OOS · 132 IS *(posizioni)* | 🟡 **INTERRUTTORE** (asse a 2 soli valori: 25 e 75 **mai misurati**) — ma **3 finestre indipendenti, stessa direzione**, e **20 combinazioni su 24** delle altre manopole di gestione | `aperture_r46/ABTG_DAX_Apertura_EU_D30EUR_OOS_r46a.csv` **r.3→r.2** · `..._IS_r46a.csv` **r.3→r.2** · `gestione_20260909/gestione_ABTG_DAX_Apertura_EU_D30EUR_gestione.csv` **r.56→r.54** |
| **2** | `771531` EMA200 Dow | `InpOrder2Atr` | **0,3** | **0,5 – 0,6** | −0,019 / **+0,021** | **−2,78 / −2,72** | 577 / 546 | 🟢 **ALTOPIANO sul DD**: due valori adiacenti misurati, **tutti e due** a DD ~4,7 contro 7,43 | `risultati_valid_ABTG_EMA200_H1_realtick/valid_ABTG_EMA200_H1_realtick_U30USD.csv` **r.68 → r.9 / r.109** (tick) |
| **3** | `771531` EMA200 Dow | `InpTP_RR` | **2,0** | **2,5** | **+0,036** tick pieno · **+0,041** IS · **+0,014** OOS | −0,12 · −0,01 · +0,00 | 669 tick · 211 IS · 453 OOS | 🟠 **BORDO DELL'ASSE**: 3,0 **non è mai stato misurato** → per la regola di casa **non è promuovibile**, manca il vicino a destra | `valid_..._U30USD.csv` **r.68 → r.111** · `ABTG_EMA200/ABTG_EMA200_U30USD_IS_r29b.csv` **r.24 → r.29** · `..._OOS_r29b.csv` **r.19 → r.29** |
| **4** | `771322` PTE GBPUSD | `InpSLbufferPips` | **5** | **25 – 30** | **+0,128 / +0,122** OOS · **+0,070 / +0,098** IS | **−7,16 / −8,48** OOS · **−8,49 / −9,68** IS | 476/479 OOS · 439/443 IS *(uscite)* | 🟢 **ALTOPIANO MONOTONO su 7 punti**, in **tutte e due** le finestre da 13 anni | `csv_R78/ABTG_PTE_GBPUSD_OOS_ohlc_pte78gbp.csv` **r.7 → r.3 / r.6** · `..._IS_ohlc_pte78gbp.csv` **r.2 → r.8 / r.9** ⚠️ **OHLC** |
| **5** 🪦 | `770611` ORB Dow **(conto REALE)** | `InpTPRangeMult` | **1,5** | **2,0 / 2,5 / 3,0** | **+0,079 / +0,172 / +0,298** OOS · **+0,136 / +0,063 / +0,119** IS | **+1,12 / +0,84 / +0,97** | 119 OOS · 71 IS 🔴 **<150** | 🟢 **ALTOPIANO in IS** (tutti e tre battono 1,5) · monotono in OOS, **bordo a 3,0** | `ABTG_ORB_Ottimizzato/r44/..._OOS_r44a.csv` **r.2 → r.5/r.3/r.4** · `..._IS_r44a.csv` **r.4 → r.3/r.5/r.2** — 🪦 **GIÀ RESPINTA da R44** (cancello DD<10%) |
| **6** 🪦 | `770101` DAX Apertura | `InpTrailTF` | **M5** | **M4** | **+0,156** OOS · **+0,095** IS | **+1,17** OOS · **+0,56** IS | 265 OOS · 172 IS *(uscite)* | 🔴 **CONCORDE ma PICCO in IS**: l'unico vicino misurato che non sia la base (M3, PF 0,982) sta **sotto** la base | `ABTG_DAX_Apertura_EU/ABTG_DAX_Apertura_EU_D30EUR_OOS.csv` **r.25 → r.6** · `..._IS.csv` **r.21 → r.9** — 🪦 **GIÀ RESPINTA il 08/08** |
| **7** 🪦 | `770611` ORB Dow **(conto REALE)** | `InpSLMode` | **3** (HALFRANGE) | **0** (OPPRANGE) | +0,023 OOS · **−0,261 IS** | **−5,80** OOS · **−4,30** IS | 119 / 71 🔴 **<150** | ⚫ **enum, non un asse**: "altopiano" non è definibile. **Rischio CONCORDE, merito DISCORDE** | `ABTG_ORB_Ottimizzato/ABTG_ORB_Ottimizzato_U30USD_OOS_r15.csv` **r.61 → r.36** · `..._IS_r15.csv` **r.58 → r.35** — 🪦 **GIÀ RESPINTA da R15** |
| **8** | `770611` ORB Dow **(conto REALE)** | `InpSLBufferPts` | **0** | **2000** | −0,048 OOS · **−0,287 IS** | **−2,87** OOS · **−0,17 IS** | 119 / 71 🔴 **<150** | 🟢 ALTOPIANO sul DD in OOS (1500 e 2000 scendono insieme) · 🔴 **DISCORDE sul merito** | `r118_csv/ABTG_ORB_Ottimizzato_U30USD_OOS_r118a.csv` **r.2 → r.6** · `..._IS_r118a.csv` **r.2 → r.6** |
| **9** | `772421` + `772422` EasyTrend | `InpAllowShort` | **1** | **0** | **+0,399** CHFJPY · **+0,341** GBPUSD | **−4,17 / −2,83** | 44 / 58 | 🟡 **INTERRUTTORE** · **merito SOSPESO** (n<150) · ma **due simboli, stessa direzione, a tick** | `ABTG_EasyTrend/tick/valid_ABTG_EasyTrend_H1_realtick_CHFJPY.csv` **r.7 → r.3** · `..._GBPUSD.csv` **r.7 → r.6** |
| **10** | `770101` DAX Apertura **(conto REALE)** | `InpBreakevenAtTP1` | **1** | **0** | **+0,013** | **−0,01** | 445 → 445 *(identico)* | ⚪ **DENTRO IL RUMORE** → **la risposta onesta è: il valore in campo va bene** | `gestione_20260909/gestione_..._gestione.csv` **r.56 → r.52** |

---

# 3. 🔬 LE PRIME QUATTRO, coi numeri interi

## 3.1 🥇 `770101` — **togliere il parziale**: `InpTP1_ClosePct` 50 → 0

**Dove gira**: `ABTG_DAX_Apertura_EU`, D30EUR M5, magic 770101 — **conto reale
10105439** (`mql5/Presets/conto_reale/ABTG_DAX_Apertura_EU_770101_REALE.set`
r.65: `InpTP1_ClosePct=50.0`) **e** sul piccolo/100k.

### Le TRE misure, tutte a tick reali, tutte a una sola manopola di distanza

| round | finestra · deposito · rischio | cella VIVA (parziale 50%) | cella `0` | Δ |
|---|---|---|---|---|
| **R46a OOS** `aperture_r46/..._OOS_r46a.csv` **r.3 → r.2** | OOS · **100.000 €** · 1,0% · tick | PF **1,39709** · DD **7,2328%** · n **270** · P **18.029,58** | PF **1,49140** · DD **6,2719%** · n **193** · P **23.607,28** | **PF +0,094 · DD −0,96 · profitto +30,9%** |
| **R46a IS** `..._IS_r46a.csv` **r.3 → r.2** | IS · 100.000 € · 1,0% · tick | PF **1,12634** · DD **5,4362%** · n **175** · P **3.789,36** | PF **1,18323** · DD **4,9576%** · n **132** · P **5.569,37** | **PF +0,057 · DD −0,48 · profitto +47,0%** |
| **R120** `gestione_20260909/...` **r.56 → r.54** | **FINESTRA PIENA** 2024.09.26→2026.06.30 · 10.000 € · 1,0% · tick (`scan_gestione.ps1` r.170-176) | PF **1,29574** · DD **6,8866%** · n **445** · P **2.207,74** | PF **1,37886** · DD **6,0271%** · n **325** · P **2.970,43** | **PF +0,083 · DD −0,86 · profitto +34,6%** |

### 🎯 E il numero che scioglie l'unico dubbio che R120 aveva lasciato aperto
R120 aveva scritto: *"il campione cala da 445 a 325 operazioni (−27%) → è il
cancello G6"*. 🔴 **Quel −27% NON è una perdita di operazioni: è il parziale che
sparisce dal conteggio delle USCITE.**
- `CENSIMENTO_CONTRATTI_v2.md` §2 misura, sul per-trade, **270 uscite = 193
  POSIZIONI**, fattore **1,40**;
- la corsa **senza parziale** di R46a fa **193 uscite** — e senza parziale
  *uscite = posizioni*.
👉 **193 = 193.** Le due strade sono indipendenti e danno lo stesso numero:
**la frequenza non cala di un'operazione.** Stessa aritmetica in IS
(175/132 = 1,33) e sulla finestra piena (445/325 = 1,37).
⚠️ `[MISURATO SU DUE STRADE, NON RICONCILIATO AL PER-TRADE]`: il per-trade della
corsa senza parziale non è in archivio. Chiuderlo costa **una passata**.

### ⚖️ Il limite onesto
- L'asse ha **due soli valori** (0 e 50): **25 e 75 non sono mai stati
  misurati** → *"centro dell'altopiano"* qui **non si può dire**.
- In **OOS** il vantaggio vale **solo con il trailing PREVBAR acceso** (cioè la
  configurazione viva): a `InpTrailMode=0` il parziale diventa migliore
  (`..._OOS_r46a.csv` r.5 PF 0,974 contro r.4 PF 1,028). **Dichiarato.**
- Il DD scende in R46a (tutte e due le finestre) e sulla finestra piena, ma
  **le tre corse non hanno lo stesso deposito**: 100.000 € R46a, 10.000 € R120.
- **Terza fonte indipendente, non un backtest**: la live di Emiliano del 09/09
  (`report/ANALISI_LIVE_EMILIANO_2026-09-09.md`, citata in R120 §"terza conferma").

---

## 3.2 🥈 `771531` EMA200 Dow — `InpOrder2Atr` 0,3 → 0,5/0,6: **il DD cala di 2,7 punti**

Sedia del piano di ottobre. Cella viva: `InpOrder1Atr=0,20 · InpOrder2Atr=0,3 ·
InpTP_RR=2,0` (`mql5/Presets/sedie_piccolo/recupero2/sedia_ABTG_EMA200_771531.set`,
identica agli override di `deploy_vivaio_ema200.ps1` r.28-34).

**L'asse intero a TICK REALI** — `valid_ABTG_EMA200_H1_realtick_U30USD.csv`
(Model 4, 2024.01.01→2026.06.30, deposito 10.000, `valida_realtick.ps1`
r.162-168), tutte le altre manopole = cella viva:

| `InpOrder2Atr` | PF | DD % | n (uscite) | Profit | riga |
|---|---|---|---|---|---|
| 0,2 | 1,41377 | **8,4255** | 696 | 2.796,85 | r.85 |
| **0,3 ← VIVA** | **1,39181** | **7,4298** | **658** | **2.502,70** | **r.68** |
| 0,5 | 1,37333 | **4,6504** | 577 | 2.017,27 | r.9 |
| 0,6 | 1,41290 | **4,7092** | 546 | 1.989,54 | r.109 |

🟢 **È un altopiano, non un picco**: **due** valori adiacenti misurati (0,5 e 0,6)
stanno **tutti e due** a DD ~4,7 contro 7,43. Il PF resta dentro ±0,022 (rumore).
🟢 **Conferma su un secondo modello**: nello scan OHLC
(`risultati_scan_ABTG_EMA200_H1/scan_ABTG_EMA200_H1_U30USD.csv`, Model 1,
2024.01.01→2026.06.30) la stessa direzione: r.91 (0,3) DD **6,2894** → r.38 (0,4)
DD **5,1202** → r.44 (0,6) DD **4,8289**. **Due modelli, stesso verso.**

💰 **Il prezzo, detto chiaro**: profitto **−19,4%** (0,5) / **−20,5%** (0,6) e
frequenza **−12%/−17%**. È uno **scambio**: si compra drawdown con rendimento.
Per una challenge in cui il muro è il DD **può** valere; la decisione è di Claudio.

🔴 **Buchi**: `0,4` **non è mai stato misurato a tick** (solo OHLC) e oltre `0,6`
non c'è niente. E la finestra è **piena**: nessun fuori campione (classe 224).

---

## 3.3 🥉 `771531` EMA200 Dow — `InpTP_RR` 2,0 → 2,5: **tre misure, stesso verso, ma è il BORDO**

| corsa | modello · finestra | TP_RR **2,0** (viva) | TP_RR **2,5** | Δ |
|---|---|---|---|---|
| `valid_..._realtick_U30USD.csv` **r.68 → r.111** | tick · piena | PF 1,39181 · DD 7,4298 · n 658 · P 2.502,70 | PF **1,42783** · DD **7,3132** · n **669** · P **2.743,22** | **PF +0,036 · DD −0,12 · profitto +9,6% · n +11** |
| `ABTG_EMA200_U30USD_IS_r29b.csv` **r.24 → r.29** | tick · IS 40% | PF 1,20890 · DD 5,3048 · n 211 | PF **1,24981** · DD 5,2937 · n 211 | **PF +0,041** |
| `ABTG_EMA200_U30USD_OOS_r29b.csv` **r.19 → r.29** | tick · OOS 60% | PF 1,51760 · DD 7,2138 · n 444 | PF **1,53175** · DD 7,2164 · n 453 | **PF +0,014** |

**Tre corse, tre finestre, sempre lo stesso segno, e la frequenza SALE.**
L'asse completo misurato in R29b è `{1,5 · 2,0 · 2,5}` → in IS è **monotono
crescente** (1,113 → 1,209 → 1,250), in OOS è **piatto** (1,521 → 1,518 → 1,532).

🟠 **E QUI SCATTA LA REGOLA DI CASA, CONTRO DI ME.** `2,5` è **l'ultimo punto
dell'asse**: **3,0 non è mai stato misurato**. Scegliere il bordo è
esattamente *"il picco, non il centro dell'altopiano"*. **Non è promuovibile
così com'è** — e va detto che **`2,0` fu scelto proprio perché era il CENTRO**
dell'asse `{1,5 · 2,0 · 2,5}` (`REFERTO_ROUND29_EMA200_WF.md`, cella CENTRO).

🙋 **QUESTA È LA COSA PIÙ CORTA DA CHIUDERE DI TUTTA LA NOTTE, e la segnalo a
Claudio come tale** (motto 09/09: *"se è ferma per un numero MANCANTE, si trova
la via più corta al numero"*): **un asse `InpTP_RR ∈ {2,0 · 2,5 · 3,0 · 3,5}`,
tutto il resto pinnato alla cella viva, sulle due gambe IS/OOS di R29b** =
**4 celle × 2 finestre = 8 passate** a tick su H1. Se 3,0 regge, **2,5 diventa
un centro** e la cella si può giudicare con la regola giusta. Se 3,0 crolla,
2,0 resta e la questione è chiusa per sempre.
*(Costo in tempo macchina: [NON MISURATO] in minuti — le 30 celle di R29b sono
già girate in un round notturno, 8 passate sono una frazione di quello.)*

---

## 3.4 `771322` PTE GBPUSD — `InpSLbufferPips` 5: **la sedia è sul punto PEGGIORE di un asse a 7 punti**

`csv_R78` — OHLC (Model 1), deposito 100.000, rischio 1,0%,
**IS 2000.01.01→2013.03.31 · OOS 2013.04.01→2026.06.30**
(`gen_ABTG_PTE_GBPUSD_{IS,OOS}_ohlc_pte78gbp.ini` r.9-15). `InpTP2_ATRmult=2`
in tutte le righe qui sotto = valore vivo.

| buffer | PF IS | DD IS | n IS | PF OOS | DD OOS | n OOS | righe (IS / OOS) |
|---|---|---|---|---|---|---|---|
| 0 | 0,74121 | 25,15 | 404 | 1,01060 | 15,90 | 438 | r.3 / r.9 |
| **5 ← VIVA** | **0,79428** | **20,39** | **414** | **0,97164** | **17,68** | **447** | **r.2 / r.7** |
| 10 | 0,83260 | 16,84 | 423 | 1,02968 | 13,82 | 459 | r.5 / r.8 |
| 15 | 0,80860 | 16,77 | 427 | 1,01015 | 13,04 | 464 | r.6 / r.2 |
| 20 | 0,79710 | 15,45 | 431 | 1,07900 | 12,28 | 472 | r.7 / r.5 |
| 25 | 0,86446 | 11,90 | 439 | **1,09997** | 10,51 | 476 | r.8 / r.3 |
| 30 | **0,89220** | **10,71** | 443 | 1,09419 | **9,19** | 479 | r.9 / r.6 |

🟢 **Il DD scende in modo MONOTONO su tutti e sette i punti, in tutte e due le
finestre da 13 anni, e le operazioni AUMENTANO.** Questo è un altopiano vero,
non un picco. E **il valore in campo è il PF minimo dell'asse in OOS** (0,972,
sotto anche a buffer 0) **e il DD massimo** (17,68%).

### ⚖️ MA — quattro cose che tolgono a questa riga il diritto di essere la n.1
1. 🔴 **NON è una cella mai portata in campo.** `771332` è **già viva con
   `InpSLbufferPips = 25`** — `report/CANCELLO_COSTO_FLOTTA_2026-09-10.md` r.520:
   *"PTE (cand. R78) GBPUSD — SLbufferPips **25** ⬅️ la sedia con lo stop più largo
   del duello"*. **Il duello 5 contro 25 è già in campo.** Quello che **non** è
   mai stato in campo è **30**, che nell'OOS batte 25 sul DD (9,19 contro 10,51).
2. 🔴 **È OHLC.** Screening, non verdetto.
3. 🔴 **Sul PROFITTO un round a TICK dice il contrario**, su un'altra finestra:
   R72 (`REFERTO_ROUND72_BUFFER_TICK_REALI.md`, IS 2024.07.05→2025.04.21, OOS
   →2026.06.30) — *"GBPUSD NON passa: la candidata buf 25/TP 3,0 abbassa il DD
   (3,05→2,67%) ma **dimezza il profitto** (+3.166 → +1.566)"*. 👉 **Il verso del
   DD è lo stesso in tutti i round; il verso del PROFITTO cambia fra la finestra
   di 26 anni e quella di 2 anni.** È la "regola B" già scritta in R72:
   *rischio affidabile, rendimento no*.
4. 🔴 **In IS il PF resta sotto 1,00 su tutti e sette i punti.** Nessun buffer
   rende questo motore positivo sui 13 anni in campione: il buffer **governa il
   rischio, non crea edge**.

---

# 4. ⚪ LE SEDIE DOVE LA RISPOSTA È **"IL VALORE IN CAMPO VA BENE"**
### — e questo è un risultato, non un fallimento

## 4.1 `770101` — l'ingresso è già sul massimo misurato FUORI CAMPIONE
Il setaccio aveva tirato fuori `InpRangeMinutes` 35→60/50/30 e `InpBufferPoints`
500→100/200/300/400 come "migliorie". **Sono tutte figlie del solo IS.**
Nel file OOS gemello dello stesso round
(`ABTG_DAX_Apertura_EU/ABTG_DAX_Apertura_EU_D30EUR_OOS_ptd.csv`, tick, 100.000 €):

| asse | valore VIVO | il suo PF OOS | **è il massimo dell'asse?** | punti misurati |
|---|---|---|---|---|
| `InpRangeMinutes` | **35** (r.75) | **1,39709** | 🟢 **SÌ — il più alto di 12 valori** (il secondo è 40 a 1,38985) | 5…60 |
| `InpBufferPoints` | **500** (r.75) | **1,39709** | 🟢 **SÌ — il più alto di 15 valori** (il secondo è 400 a 1,33022) | 100…1500 |

👉 **Nessuna cella d'archivio batte i due assi d'ingresso della sedia viva fuori
campione.** Nell'IS (`..._IS_ptd.csv` r.119: RangeMinutes 60 → PF 1,29468 contro
r.77 1,12634) sembrerebbe di sì: **è il tranello, ed è lo stesso ribaltamento
IS→OOS che l'archivio ha già documentato quindici volte.**

## 4.2 `771531` EMA200 Dow — la superficie è PIATTA e la cella viva è al centro
Le 30 celle di R29b (`InpOrder1Atr × InpOrder2Atr × InpTP_RR`) stanno fra
**1,052 e 1,332 in IS** e fra **1,437 e 1,605 in OOS**. La migliore in IS
(0,30/0,30/2,5 → 1,332) in OOS fa **1,527**; la migliore in OOS (0,10/0,30/1,5 →
1,605) in IS fa **1,052, la PEGGIORE della griglia**. 🔴 **Anticorrelazione agli
estremi**: è la definizione di *"scegliere il picco = scegliere il rumore"*.
Nessuna cella batte la viva su **tutte e due** le finestre oltre il rumore, con
**la sola eccezione di `InpTP_RR=2,5`** (§3.3), che è al bordo.
`InpOrder1Atr` 0,2→0,3 guadagna **+0,093 in IS** e **−0,002 in OOS**
(`..._IS_r29b.csv` r.24→r.17 · `..._OOS_r29b.csv` r.19→r.10): **è un pareggio**.

## 4.3 Sedie con la cella viva misurata e **ZERO** celle migliori in archivio
Per queste il setaccio ha trovato la riga BASE e non ha trovato **nessuna**
cella a una manopola che la batta:

| sedia | EA · simbolo | file con la BASE |
|---|---|---|
| `771201` · `771202` | `ABTG_PostNews` EURJPY / EURUSD | 2 file ciascuna |
| `772232` · `772234` · `772235` | `ABTG_GapFill` EURUSD / U30USD / 225JPY | 14 / 5 / 5 file |
| `772343` · `772344` · `772345` | `ABTG_PunteLarry` XAUUSD / GBPJPY / GBPUSD | 13 / 4 / 13 file |
| `772361` · `772362` | `ABTG_CostToCost` EURJPY / GBPCAD | 13 file ciascuna |

⚠️ **Attenzione a come si legge**: *"nessuna cella migliore"* qui vuol dire
**"nessuna nell'archivio"**, non *"la cella è ottima"*. Per tutte queste la cella
viva è **ricostruita** dai `deploy_vivaio_*.ps1` (§5) e il campione è piccolo.

---

# 5. 🕳️ I BUCHI — dichiarati per nome, non per differenza

## 5.1 🔴 Le sedie la cui CELLA VIVA **non è mai stata misurata**

| sedia | distanza minima da OGNI corsa d'archivio | quali manopole non tornano |
|---|---|---|
| **`770250`** `ABTG_Nasdaq_Apertura_US` NASUSD M15 *(GatedShort)* | 🔴 **8 manopole su 70** | `InpBufferPoints` 300≠50 · `InpCloseHour` 20≠21 · **`InpAllowLong` 0≠1** · `InpUseEmaFilter` 1≠0 · `InpEmaFast` 50≠1 · `InpEmaSlow` 200≠50 · `InpSLMode` 0≠1 · `InpTrailTF` 5≠1 — il più vicino è `risultati_archivio/Nasdaq_Apertura/ablaz_1_nofilt_NASUSD.csv` r.2 |
| **`770402`** `ABTG_MaxMinNotte` XAUUSD H2 | 🔴 **4 su 44** | `InpBoxStartHour` 23≠22 · `InpBoxEndHour` 4≠6 · `InpEntryCutoffHour` 8≠9 · `InpMaxSpread` 150≠0 — il più vicino è `MaxMin_Oro_r17/ABTG_MaxMinNotte_XAUUSD_IS_r17.csv` r.6 |
| **`771203`** `ABTG_PostNews` USDJPY M5 | 🔴 **nessuna corsa esiste** | **zero** CSV di quell'EA con `USDJPY` nel percorso |

🔴 **Per queste tre sedie il setaccio non ha niente da dire, e il motivo è che
in archivio NON C'È LA MISURA DELLA CELLA CHE GIRA.** Su `770250` il round di
gestione dell'09/09 esiste (`gestione_ABTG_Nasdaq_Apertura_US_NASUSD_gestione.csv`,
48 celle, **tutte sotto PF 1,00** — R120) **ma misura un'altra configurazione**:
quella corsa ha l'ingresso ai default, la sedia viva è short-only con filtro
EMA 50/200. **Le due cose non si parlano.**

## 5.2 🟡 `770411` — a **una sola manopola**, ed è quella del costo
`ABTG_MaxMinNotte_DAX_Short_Ottimizzato` D30EUR: la cella viva coincide con le
corse d'archivio **su 43 manopole su 44**. L'unica differenza:
**`InpMaxSpread` = 500 (vivo) contro 0 (tutte le 34 corse d'archivio)**, e nel
sorgente `InpMaxSpread<=0` **spegne il filtro**
(`ABTG_MaxMinNotte_DAX_Short_Ottimizzato.mq5` r.468:
`if(InpMaxSpread<=0) return(true)`).
👉 **Tutti i numeri d'archivio di questa sedia sono un LIMITE SUPERIORE**: sono
misurati **senza** il tetto di spread che la sedia ha in campo.
Ignorando quella manopola l'unico asse disponibile è `InpBufferPoints`
(`ABTG_MaxMinNotte_DAX_Short_Ottimizzato_D30EUR_{IS,OOS}_r2.csv`) con
**n = 20 in IS e 21 in OOS**: 🔴 **merito SOSPESO**, niente da classificare.

## 5.3 🟠 Le celle vive **RICOSTRUITE** (il `.set` vero è sul VPS, non nel repo)
Per queste la BASE è *default del sorgente + override del `deploy_vivaio_*.ps1`*.
**Se il `.set` sul VPS è diverso, tutto il confronto salta.**

| sedie | fonte della cella viva |
|---|---|
| `772161` `772162` `772163` | `backtest_pipeline/deploy_vivaio_bb.ps1` r.46-52 |
| `772231` `772232` `772233` | `deploy_vivaio_gap.ps1` r.48-55 |
| `772234` `772235` | `deploy_vivaio_gap2.ps1` r.39-44 |
| `772341`…`772346` | `deploy_vivaio_larry.ps1` r.46-60 |
| `772361` `772362` | `deploy_vivaio_cost.ps1` r.45-51 |
| `772421` `772422` | `deploy_vivaio_ez.ps1` r.47-56 |
| **`770901`** `ABTG_SupertrendReversal` 225JPY · **`771332`** `ABTG_PTE` GBPUSD | 🔴 **nessun preset E nessun override**: cella = **solo i default del sorgente** → **`[NON VERIFICATO]`**, le loro righe non entrano in classifica |

🙋 **Buco che Claudio può chiudere in due minuti** e che vale per **20 sedie** (18 ricostruite + 2 con i soli default):
`backtest_pipeline/estrai_set_forward.ps1` esiste già. Estrarre i `.set` veri dal
terminale **piccolo 50503392** (`BCM Markets MT5 Terminal`) e metterli nel repo
trasformerebbe **20 celle vive dichiarate incerte in 20 celle vive LETTE**.
*(Nessuna riga di lancio qui dentro: questo file non manda niente al VPS.)*

## 5.4 🔴 Quello che il setaccio **NON** può dire
- **Non sa se una manopola è su un RAMO MORTO** se non gliel'ho detto io
  leggendo il codice. Quelle verificate a mano in questo giro:
  `InpTrailTF` è **viva** con `InpTrailMode=1` (PREVBAR) —
  `ABTG_DAX_Apertura_EU.mq5` r.2003-2004 `if(InpTrailMode==ABTG_TRAIL_PREVBAR)
  return(iLow(_Symbol, InpTrailTF, 1))`; `InpTPRangeMult` è **viva** con
  `InpTPMode=1` (preset reale r.31). **Per le altre 60 coppie il rischio di un
  confronto finto resta e non è quantificato.**
- **Non sa leggere il costo** (`stop ≥ 40 × spread`): quello sta in
  `report/CANCELLO_COSTO_FLOTTA_2026-09-10.md` e **non è stato riverificato qui**.
  🔴 Nessuna riga di questa classifica ha passato il cancello del costo.
- **Non converte `n` in posizioni** se non a mano: dove non l'ho fatto, `n` è
  in **uscite**.
- **93 CSV su 2.087 non sono attribuibili a nessun EA**: se una cella migliore è
  lì dentro, **questo setaccio non l'ha vista**.

---

# 6. 📋 RIEPILOGO PER SEDIA — tutte e 40

`file EA` = CSV attribuiti a quell'EA · `file sym` = quelli sul simbolo giusto ·
`con BASE` = quelli dove la cella viva compare per intero · `trovate` = celle a
una manopola che la battono.

| magic | EA · simbolo | file EA | file sym | **con BASE** | trovate | esito |
|---|---|---|---|---|---|---|
| 770101 | DAX_Apertura_EU · D30EUR | 74 | 72 | **23** | 42 | 🥇 §3.1 · §4.1 |
| 770202 | Dow_Apertura_US · U30USD | 14 | 14 | 12 | 18 | ⏸️ **la riga BASE non arriva a 150** (n 74-130) → merito SOSPESO · e in OOS le migliorie d'ingresso sono **DISCORDI** |
| 770250 | Nasdaq_Apertura_US · NASUSD | 81 | 73 | 🔴 **0** | 0 | 🔴 **cella viva mai misurata** (§5.1) |
| 770402 | MaxMinNotte · XAUUSD | 21 | 14 | 🔴 **0** | 0 | 🔴 **cella viva mai misurata** (§5.1) |
| 770411 | MaxMin_DAX_Short_Ott · D30EUR | 20 | 20 | 🔴 **0** | 0 | 🟡 a 1 manopola: `InpMaxSpread` (§5.2) |
| 770511 | SuperWave_DOW_H1_Ott · U30USD | 6 | 6 | 6 | 9 | ⏸️ solo `InpTF`, n 4-84 |
| 770531 | SuperWave · U30USD | 48 | 9 | 6 | 6 | ⏸️ solo `InpTF`, **n 4-8** (PF 12.642 = zero perdite su 4 trade) |
| 770611 | ORB_Ottimizzato · U30USD 🏦 | 57 | 36 | **28** | 14 | §3 righe 5-7-8 · **tutte già giudicate o discordi** |
| 770901 | SupertrendReversal · 225JPY | 155 | 14 | 9 | 36 | 🔴 cella viva `[NON VERIFICATO]` (§5.3) |
| 770924 | SupertrendReversal · 225JPY | 155 | 14 | 10 | 25 | ⏸️ solo `InpTF`, n 2-42 |
| 771201 | PostNews · EURJPY | 4 | 2 | 2 | **0** | ⚪ nessuna cella migliore |
| 771202 | PostNews · EURUSD | 4 | 2 | 2 | **0** | ⚪ nessuna cella migliore |
| 771203 | PostNews · USDJPY | 4 | **0** | 0 | 0 | 🔴 **zero corse sul simbolo** |
| 771321 | PTE · U30USD | 76 | 10 | 8 | 17 | ⏸️ n 10-43 · 🔴 e su U30USD `SLbufferPips` è **inerte per unità di misura** (R69/R74) |
| 771322 | PTE · GBPUSD | 76 | 26 | 14 | 39 | §3.4 |
| 771332 | PTE · GBPUSD | 76 | 26 | 6 | 21 | 🔴 cella viva `[NON VERIFICATO]` (§5.3) |
| 771531 | EMA200 · U30USD | 209 | 30 | 13 | 18 | 🥈🥉 §3.2 · §3.3 · §4.2 |
| 772161-3 | BreakingBand · GBP/EUR/AUD-USD | 339 | 22/24/13 | 15/15/6 | 2/1/5 | ⏸️ **n 1-26**, PF fino a 176 = rumore puro |
| 772231 | GapFill · GBPUSD | 104 | 15 | 14 | 1 | ⏸️ n 7-8 |
| 772232 | GapFill · EURUSD | 104 | 15 | 14 | **0** | ⚪ nessuna cella migliore |
| 772233 | GapFill · AUDUSD | 104 | 6 | 5 | 1 | ⏸️ n 8-12 |
| 772234-5 | GapFill · U30USD / 225JPY | 104 | 6 | 5 | **0** | ⚪ nessuna cella migliore |
| 772341-2 | PunteLarry · U30USD / EURAUD | 94 | 5 | 4 | 1 | ⏸️ `InpAllowShort`, n 15-38 |
| 772343-5 | PunteLarry · XAUUSD / GBPJPY / GBPUSD | 94 | 14/5/14 | 13/4/13 | **0** | ⚪ nessuna cella migliore |
| 772346 | PunteLarry · EURCAD | 94 | 5 | 4 | 1 | ⏸️ `InpAllowShort` **0→1**, n 19→35 |
| 772361-2 | CostToCost · EURJPY / GBPCAD | 128 | 15 | 13 | **0** | ⚪ nessuna cella migliore |
| 772421-2 | EasyTrend · CHFJPY / GBPUSD | 107 | 17 | 16 | 9 + 9 | riga 9 · **merito SOSPESO** |
| 774101 | GapContinuation · 225JPY | 4 | 4 | 4 | 3 | ⏸️ `InpMinimum*GapPercent`, n 26-57, **OHLC**, DISCORDI |
| 970901 | SupertrendReversal_Ott · XAUUSD | 4 | 4 | 4 | 3 | ⏸️ solo `InpTF`, **n 1-22** |
| 970912 | SupRev_DAX_H4_Ott · D30EUR | 4 | 4 | 4 | 4 | ⏸️ solo `InpTF`, n 15-63, OHLC |
| 970913 | SupRev_NAS_H1_Ott · NASUSD | 6 | 6 | 6 | 9 | ⏸️ solo `InpTF`, n 2-86 |
| 971501 | EMA200_Ottimizzato · XAUUSD | 4 | 4 | 4 | 15 | ⏸️ solo `InpTF`, **n 4-39** |
| — | `BREAKOUT_EA_JPY_v3` USDJPY | — | — | — | — | 🔴 **sorgente non nel repo**: fuori dal setaccio |

🔴 **Il mestiere di `InpTF` in questa tabella**: su 11 sedie l'unica "cella
migliore" trovata è un **cambio di timeframe** che porta il campione a **1-30
operazioni** e il PF a numeri come 12.642 (= una corsa senza nessuna perdita su
4 trade). **Non sono celle: sono divisioni per zero.** Le ho lasciate a
referto perché *"non si scarta niente senza scriverne il numero"*, ma
**nessuna di esse è promuovibile e nessuna entra in classifica.**

---

# 7. ⚖️ IL LIMITE PIÙ IMPORTANTE DI TUTTO IL DOCUMENTO

**Ogni riga della classifica nasce DENTRO UN SOLO CSV**: stessa finestra, stesso
modello, stesso deposito, stessa build. È il confronto più forte che l'archivio
permetta. 🔴 **Ma quando metto in fila DUE round** (riga 1: R46a + R120; riga 3:
valid_realtick + R29b; riga 4: R78 + R72) **il confronto vale meno**, e per ognuno
ho scritto **cosa cambia**:

| righe | cosa NON è uguale fra i round messi in fila |
|---|---|
| **1** (`TP1_ClosePct`) | **deposito 100.000 (R46a) contro 10.000 (R120)** · R46a ha IS/OOS, R120 ha **finestra piena** |
| **3** (`TP_RR`) | `valid_realtick` = **2024.01.01→2026.06.30 piena**; R29b = **2024.09.26→2026.06.30 spezzata 40/60**. Stesso deposito (10.000), stesso modello (tick) |
| **4** (`SLbufferPips`) | R78 = **OHLC, 26 anni, 100.000 €**; R72 = **tick, 2 anni**. 👉 **È qui che il verso del profitto si ribalta** |
| **5** (`TPRangeMult`) | nessuna: R44a IS e OOS sono lo stesso round |
| **2** (`Order2Atr`) | `valid_realtick` (tick) contro `scan_market` (OHLC): **finestra uguale, modello diverso** |

E la regola che non ho mai sospeso: **un numero OHLC non è un verdetto, è uno
screening.** Righe 4 e la conferma di riga 2 sono OHLC.

---

## 📎 Riproducibilità
Il setaccio è uno script di ~250 righe che legge `censimento_uscite.ea_of()` e
non scrive niente nel repo. Ogni numero di questo dossier è stato **riletto a
mano dal CSV citato** prima di finire in tabella: le righe indicate sono righe
fisiche, verificabili con `sed -n 'Np' <file>`.

**Nessun backtest eseguito · nessun preset toccato · nessun commit.**
