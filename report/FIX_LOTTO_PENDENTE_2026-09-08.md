# 🔧 FIX DEL LOTTO PENDENTE — 15 sorgenti corretti

**Data:** 08/09/2026 · **Branch:** `lavoro`
**Difetto corretto:** #1 della lista `report/RISCHIO_DICHIARATO_VS_VERO_2026-09-08.md` §7
**Natura dell'intervento:** **solo riordino di due righe** + commento + bump di versione.
🛑 **Nessun `.set`, nessun preset, nessun parametro toccato.** Nessuna rinomina,
nessuna riformattazione, nessun "già che ci sono".

---

## 🐞 1. IL DIFETTO (già verificato, non ipotizzato)

Prima (esempio `ABTG_SuperWave.mq5`, righe 253-255):

```mql5
double lotMkt=NormVol(totLot*InpFirstFraction);
double lotPend=NormVol(totLot-lotMkt);                              // calcolato PRIMA
if(lotMkt<=0) lotMkt=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MIN);   // pavimento DOPO
```

`NormVol()` restituisce **0** sotto il lotto minimo (identica in tutti e 15 i file:
`v=MathFloor(v/st)*st; return(v<mn?0:v);`). Quindi se `totLot*InpFirstFraction`
normalizza a zero:

1. `lotMkt = 0`;
2. `lotPend = NormVol(totLot - 0) = totLot` **intero**;
3. `lotMkt` **risorge** a `volMin`.

👉 Volume totale piazzato = **`totLot + volMin`** invece di `totLot` — **fino al
doppio del rischio dichiarato**.
📌 **Misurato in campo:** `report/DIARIO.md`, 20/08/2026 — `SW DOW H2`, due gambe
da 0,10 lotti, **−72,32 € su 5.076,62 = 1,42%** contro un contratto dichiarato
**1,0%**.

---

## ✅ 2. LA CORREZIONE APPLICATA

Dopo:

```mql5
double lotMkt=NormVol(totLot*InpFirstFraction);
//--- CORREZIONE 08/09/2026: il pavimento del lotto minimo ora e' applicato
//    PRIMA del calcolo di lotPend. Con l'ordine precedente, se NormVol()
//    azzerava lotMkt (tranche sotto il minimo), lotPend si prendeva TUTTO
//    totLot e subito dopo lotMkt risorgeva al minimo: volume totale
//    totLot+volMin, cioe' fino al doppio del rischio dichiarato.
//    Misurato in campo il 20/08/2026: 1,42% su un contratto da 1,0%.
//    Ora lotPend si calcola su cio' che resta DAVVERO; se resta sotto il
//    minimo NormVol torna 0 e la guardia (InpUsePending && lotPend>0)
//    salta il pendente: volume totale = lotMkt. Coerente.
if(lotMkt<=0) lotMkt=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MIN);
double lotPend=NormVol(totLot-lotMkt);
```

**Ordine finale in tutti e 15 i file:** `lotMkt` → **pavimento** → `lotPend`.

🟢 **Il caso limite è già coperto dal codice esistente:** se `totLot-lotMkt` resta
sotto il minimo, `NormVol` torna 0 e la guardia **già presente**
`if(InpUsePending && lotPend>0)` salta il pendente → volume totale = `lotMkt`.
La guardia è stata **verificata presente in tutti e 15 i file** (nessuna aggiunta).

⚠️ **Effetto atteso, dichiarato onestamente:** questa correzione **riduce** il
volume piazzato nel regime «tranche sotto il minimo» (da `totLot+volMin` a
`totLot`, e nel caso peggiore da `2×volMin` a `1×volMin`). Non "migliora le
performance": **allinea il rischio vero al rischio dichiarato**. Le curve di
backtest delle celle promosse su questi motori **cambieranno** — chi le
riproduce deve saperlo.

---

## 📋 3. I 15 FILE CORRETTI — versione vecchia → nuova

Tutti avevano `#property version "1.00"`; tutti alzati a **`1.01`**, così dal
titolo della finestra MT5 si riconosce se il terminale ha l'EA corretto o quello
vecchio.

| # | file | versione | riga `lotPend` DOPO il fix |
|---:|---|:---:|---:|
| 1 | `mql5/Experts/ABTG_SuperWave.mq5` | 1.00 → **1.01** | 264 |
| 2 | `mql5/Experts/ABTG_SuperWave_DAX_H4_Ottimizzato.mq5` | 1.00 → **1.01** | 264 |
| 3 | `mql5/Experts/ABTG_SuperWave_DOW_H1_Ottimizzato.mq5` | 1.00 → **1.01** | 264 |
| 4 | `mql5/Experts/ABTG_SupertrendReversal.mq5` | 1.00 → **1.01** | 285 |
| 5 | `mql5/Experts/ABTG_SupertrendReversal_Ottimizzato.mq5` | 1.00 → **1.01** | 271 |
| 6 | `mql5/Experts/ABTG_SupertrendReversal_Multi.mq5` | 1.00 → **1.01** | 275 |
| 7 | `mql5/Experts/ABTG_SupertrendReversal_Multi_Ottimizzato.mq5` | 1.00 → **1.01** | 275 |
| 8 | `mql5/Experts/ABTG_SupRev_CAC_H4_Ottimizzato.mq5` | 1.00 → **1.01** | 272 |
| 9 | `mql5/Experts/ABTG_SupRev_DAX_H1_Ottimizzato.mq5` | 1.00 → **1.01** | 272 |
| 10 | `mql5/Experts/ABTG_SupRev_DAX_H4_Ottimizzato.mq5` | 1.00 → **1.01** | 272 |
| 11 | `mql5/Experts/ABTG_SupRev_DOW_H1_Ottimizzato.mq5` | 1.00 → **1.01** | 272 |
| 12 | `mql5/Experts/ABTG_SupRev_DOW_H4_Ottimizzato.mq5` | 1.00 → **1.01** | 272 |
| 13 | `mql5/Experts/ABTG_SupRev_NAS_H1_Ottimizzato.mq5` | 1.00 → **1.01** | 272 |
| 14 | `mql5/Experts/standalone/ABTG_SupertrendReversal.mq5` | 1.00 → **1.01** | 257 |
| 15 | `mql5/Experts/standalone/ABTG_SupertrendReversal_Multi.mq5` | 1.00 → **1.01** | 261 |

✅ **Nessun file saltato.** In tutti e 15 il blocco era **identico** a quello
descritto (stesso testo, stessa indentazione a 3 spazi, LF), presente **una sola
volta** per file. Nessuna forzatura su codice diverso.

🗂️ **Gli `standalone` sono corretti anche loro, di proposito:** non sappiamo
ancora quale albero viene compilato sul VPS (lo misura **CODA_06** stanotte).
Correggerne uno solo sarebbe lavoro che **sembra** fatto e non lo è.

---

## 🔎 4. VERIFICA TESTUALE (non compilo qui: non c'è MetaEditor)

⚠️ **Limite dichiarato:** in questo ambiente **non posso compilare né fare
backtest**. La verifica qui sotto è **testuale**, non una compilazione. La prova
finale è il compilatore di MetaEditor sul PC di Claudio.

### ✅ Controllo 1 — la riga DOPO `lotPend` non deve più essere il pavimento

```
$ grep -rn -A1 "lotPend=NormVol(totLot-lotMkt)" mql5/Experts/ | grep -c "lotMkt<=0"
0
```
**Atteso 0 → ottenuto 0.** ✅

### ✅ Controllo 2 — la riga PRIMA di `lotPend` deve essere il pavimento, in tutti e 15

```
$ grep -rn -B1 "lotPend=NormVol(totLot-lotMkt)" mql5/Experts/ \
    | grep -c "if(lotMkt<=0) lotMkt=SymbolInfoDouble"
15
```
**Atteso 15 → ottenuto 15.** ✅

### ✅ Controllo 3 — conteggio dei file toccati

```
$ git diff --name-only | wc -l
15
$ git diff --stat | tail -1
 15 files changed, 165 insertions(+), 30 deletions(-)
```
**Atteso 15 → ottenuto 15.** ✅

🔢 **E l'aritmetica del diff conferma che non è stato toccato altro:**
per file **+11 / −2** = (1 riga di versione) + (9 righe di commento) + (1 riga
`lotPend` spostata) contro (1 riga di versione) + (1 riga `lotPend` vecchia).
`15 × 11 = 165` e `15 × 2 = 30`: **combaciano esattamente**. Nessuna riga di
logica aggiunta, rimossa o riformattata oltre al riordino.

### ✅ Controllo 4 (extra) — niente emoji nei `.mq5`

```
$ git diff -U0 | grep "^+" | grep -P "[^\x00-\x7F]"
(nessun risultato)
```
Le righe aggiunte sono **ASCII puro**: accenti resi con apostrofo (`e'`, `cio'`),
zero emoji. ✅

---

## 🎯 5. LA COSA CHE SERVE A CLAUDIO — quali SEDIE VIVE sono colpite

Incrocio con `backtest_pipeline/coda/referti/CODA_01_sedie_attaccate_20260908_033003.log`
(lettura 08/09/2026 03:30). **7 sedie vive** montano uno dei 15 EA corretti.

### 🟡 Terminale PICCOLO — conto **50503392** (`C:\Program Files\BCM Markets MT5 Terminal`, profilo `ORO`) — **6 sedie**

| EA | simbolo | TF | magic | rischio che GIRA |
|---|---|---|---:|---:|
| `ABTG_SuperWave` | U30USD | H4 | 770531 | 1.0 |
| `ABTG_SuperWave_DOW_H1_Ottimizzato` | U30USD | H1 | 770511 | 1.0 |
| `ABTG_SupertrendReversal` | 225JPY | H2 | 770924 | 1.0 |
| `ABTG_SupertrendReversal_Ottimizzato` | XAUUSD | H4 | 970901 | 1 |
| `ABTG_SupRev_DAX_H4_Ottimizzato` | D30EUR | H4 | 970912 | 1.0 |
| `ABTG_SupRev_NAS_H1_Ottimizzato` | NASUSD | H1 | 970913 | 1.0 |

### 🟠 Terminale 100K — conto **50504263** (`C:\Program Files\BCM Markets MT5 Terminal -V3`, profilo `SQUADRA 100K`) — **1 sedia**

| EA | simbolo | TF | magic | rischio che GIRA |
|---|---|---|---:|---:|
| `ABTG_SupertrendReversal` | 225JPY | H2 | 770901 | 0.65 |

*(più **1 residuo su disco** nel profilo `Default` dello stesso terminale, stesso
EA/magic — non è nel profilo attivo, non conta finché quel profilo non viene caricato.)*

### 🟢 Terminale REALE — conto **10105439** (`C:\BCM_Reale`) — **NESSUNA sedia colpita**

Le due sedie del reale sono `ABTG_DAX_Apertura_EU` (770101) e
`ABTG_ORB_Ottimizzato` (770611): **non sono fra i 15 file**. 👉 **Questa correzione
non tocca il conto reale.**

### 📦 File corretti ma senza sedia viva (7 + 2 standalone)
`ABTG_SuperWave_DAX_H4_Ottimizzato`, `ABTG_SupertrendReversal_Multi`,
`ABTG_SupertrendReversal_Multi_Ottimizzato`, `ABTG_SupRev_CAC_H4_Ottimizzato`,
`ABTG_SupRev_DAX_H1_Ottimizzato`, `ABTG_SupRev_DOW_H1_Ottimizzato`,
`ABTG_SupRev_DOW_H4_Ottimizzato` + i **2 `standalone/`**.
Corretti comunque: costano zero e tolgono un difetto che tornerebbe alla prima
sedia nuova.

---

## 🚨 6. LA CORREZIONE **NON HA ANCORA EFFETTO** — e questo va detto forte

🔴 **Modificare il `.mq5` nel repo NON cambia una virgola di ciò che gira sul VPS.**
Sul terminale gira l'**`.ex5` compilato**, non il sorgente. Perché la correzione
morda servono **due passi che fa Claudio, non noi**:

1. **RICOMPILARE** i file in MetaEditor (F7) sul PC/VPS che possiede l'albero giusto;
2. **RICARICARE** l'EA sulle 7 sedie vive (rimuovi/riattacca o refresh del profilo),
   **verificando che i parametri del preset restino quelli** — un RIPRISTINA che
   perde il preset atterra sul default del sorgente (difetto già noto, riga A4 e
   `report/DIAGNOSI_770101_SIZING_2026-08-31.md`).

🔍 **Come si controlla che il terminale abbia l'EA NUOVO:** il `#property version`
è passato a **1.01** — si legge nelle proprietà dell'EA / nella scheda Esperti.
Se dice ancora **1.00**, sta girando il vecchio.

🔴 **E resta aperta la domanda che decide tutto (la misura CODA_06):
quale albero viene compilato sul VPS, `mql5/Experts/` o `mql5/Experts/standalone/`?**
Abbiamo corretto entrambi proprio per non dipendere dalla risposta, ma finché non
si sa, **non si sa quale `.ex5` corrisponde a quale sorgente**.

⚠️ **Ricompilare cambia il VOLUME delle sedie vive.** È un intervento sulla
**taglia**, e le taglie sono la firma di Claudio: la decisione di quando
ricompilare e ricaricare è sua.

---

## 📌 Fatto / inferenza / da misurare

- **FATTO (letto e verificato riga per riga):** il blocco difettoso era identico
  in 15 sorgenti; `NormVol` torna 0 sotto il minimo in tutti e 15; la guardia
  `InpUsePending && lotPend>0` esiste in tutti e 15; l'ordine ora è
  `lotMkt → pavimento → lotPend` in tutti e 15; il diff è +11/−2 per file.
- **FATTO (misurato altrove, fonte citata):** 1,42% su contratto 1,0%
  (`report/DIARIO.md` 20/08/2026); 7 sedie vive colpite
  (`CODA_01_..._20260908_033003.log`).
- **INFERENZA DICHIARATA:** che il codice **compili** è un'inferenza da lettura —
  qui **non c'è MetaEditor**. La sintassi non è stata alterata (due dichiarazioni
  `double` riordinate, nessun uso di `lotPend` prima della sua dichiarazione:
  il primo uso è alla guardia, decine di righe più sotto), ma **la prova è F7**.
- **DA MISURARE:** quale albero viene compilato sul VPS (**CODA_06**); di quanto
  cambia il volume effettivo delle 7 sedie dopo la ricompilazione (si legge dal
  primo trade nuovo, non si stima).
