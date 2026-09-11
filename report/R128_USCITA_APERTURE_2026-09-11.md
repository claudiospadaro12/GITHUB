# 🔄 R128 — IL ROUND È PRONTO, E HA ROTTO TRE COSE CHE AVEVO DETTO IO

**Nato da:** la candela rossa di Claudio (11/09) → `TRAILING_770101_2026-09-11.md`
→ `CORREZIONE_TRAILING_770101_2026-09-11.md` → questo.
**Consegna:** 5 file prova, **30 celle**, **60 passate**, entrambi i cancelli PASS.

---

# 🔴 PARTE 1 — LE TRE CORREZIONI, verificate una per una da me

## ❌ 1. *"Le manopole di uscita non sono MAI state messe ad asse"* — **FALSO**

L'ho detto due volte a Claudio. **È sbagliato, e l'ho verificato io adesso:**

| file | righe | manopole d'uscita che VARIANO | `[MISURATO]` |
|---|---:|---|---|
| `risultati_prove/ABTG_DAX_Apertura_EU/..._IS.csv` | 25 | `InpTrailStartR` (0 · 0,25 · 0,50 · 0,75 · 1,00) × `InpTrailTF` (**M1→M5**) | ✅ tick reali, 08/08/2026 |
| `risultati_prove/gestione_20260909/..._gestione.csv` | 96 | `InpTP1_ClosePct` · `InpBreakevenAtTP1` · `InpBEatR` · `InpUseTrailing` · `InpTrailMode` | ✅ tick reali, R120, 09/09 |

**Da dove viene l'errore**: `CENSIMENTO_USCITE_MAI_PROVATE_2026-09-11.md` r.111 dice
una cosa **più stretta e giusta** — *"17 manopole, **6** mai ad asse"*. 🔴 **Io ho
trasformato "6 su 17" in "mai".** Invocare una fonte dicendo più di quanto dice.

📌 E il censimento stesso va corretto su due caselle: elenca `InpBreakevenAtTP1` e
`InpBEatR` fra le mai provate, ma **variano tutte e due** nel CSV R120 (`'0','1'`).

## ❌ 2. *"49 celle"* — **erano 30**

Ho riportato il conteggio di `controlla_prova.py`, che **non conosce gli enum**.
`walkforward_generico.ps1` r.526-530: *"ENUM: MT5 IGNORA LO STEP e spazzola i
membri fra start e stop"*. 👉 `InpTrailTF` M5→M30 fa **7 celle** (M5 M6 M10 M12 M15
M20 M30), **non 26**. Totale vero: **7+7+8+2+6 = 30**.

## ❌ 3. *"il trailing taglia i vincitori"* — **sulla sedia VIVA non è mai successo**

Rifatto da me, riga per riga, sulle 11 operazioni RETEST:

| uscita | n | in guadagno | in perdita |
|---|---:|---:|---:|
| **`sl` (= il trailing)** | **10** | 🟢 **10** | **0** |
| `expert` (= flat di fine seduta) | 1 | 0 | 🔴 **1** |

> ### 🎯 **Zero stop pieni in 11 operazioni. Il trailing sulla sedia viva non ha MAI tagliato un vincitore in perdita: ha chiuso 10 vincitori su 10.**
> 🔴 **E l'unica perdita non è del trailing**: ingresso **28/08 alle 16:56:41**,
> chiusura **17:30:00** = **il flat di fine seduta su un ingresso tardivo.**

👉 Il colpevole non è la manopola che sospettavo. È **l'orologio** — e
`InpCloseHour` **non è mai stato mosso in 1.148 righe di CSV.**

---

# 🔴 PARTE 2 — LA SCOPERTA CHE CAMBIA IL CONTRATTO DELLA SEDIA

## 💰 La sedia VIVA **non passa la frontiera del costo** — e credevamo di sì

Le 7 gambe di stop misurate erano **7 su 7 di ramo ROTTURA** (colonna `strategy`).
**Zero RETEST.** Lo stop della sedia viva in campo è `[NON MISURATO], n=0`.

Derivato dal codice (`ABTG_DAX_Apertura_EU.mq5`):
```
BREAKOUT r.1045-1046, 1059-1060 : stop = range + 2 x buffer  = range + 10 idx
RETEST   r.1471-1474, 1488-1489 : stop = range + buffer - offset = range + 3 idx
```
👉 **Il RETEST ha uno stop più stretto di esattamente 7 punti indice.**

Spread vero `spread_orario_D30EUR.csv`, **ora server 8**, **1.847.049 tick**:
**mediana 1,7000 · P95 2,7000**. Il pavimento 40× chiede **68,0 idx**.

| stop | ×spread mediano | passa il 40×? |
|---|---:|:---:|
| 🔴 **49,10 idx — RETEST, la sedia VIVA** `[DERIVATO n=2]` | **28,9×** | 🔴 **NO — 72% del pavimento** |
| 71,90 idx — mediana ROTTURA, geometrie miste | 42,3× | 🟢 sì (+6%) |

> ### 🔴 **L'unico numero che passava il cancello veniva da un ramo SPENTO dal 14/08 e da un campione di geometrie MISTE.**

⚠️ **Discrepanza da riconciliare**: la mia gamba dava 54,90, il calcolo da codice
dà **52,90** (avevo tolto il buffer e **dimenticato l'offset del retest**).
**Nessuno dei due cambia il verdetto**: 54,90 → **32,3×**, sempre sotto 40×.

## 📏 E anche l'Emendamento A era letto male

R120, stessa finestra e stessa geometria: col parziale **spento** `Trades` = **325**
in tutte e quattro le strutture d'uscita; col parziale al 50% diventano
**476/524/445/330**. 👉 **Le righe in più sono i PARZIALI, non ingressi.**

🔴 **Gli ingressi veri sono 325 sull'intera finestra.** A `FrazioneIS 0.40` l'IS fa
**~130 → SOTTO il pavimento dei 150.** **Questa sedia non ha MAI avuto 150
operazioni vere in campione**, e nessuno l'aveva letto.
✅ Rimedio: R128b/c/d/e girano a **0.50** → IS ~163, OOS ~162. Margine **+8%**,
dichiarato sottile. R128a resta a 0.40 perché deve riprodurre l'ancora dell'08/08:
lì **il merito in IS è SOSPESO**, si legge solo rischio.

---

# 🎯 PARTE 3 — LA GRIGLIA, e l'attesa dichiarata PRIMA

| file | asse | celle | `-FrazioneIS` |
|---|---|---:|---:|
| **R128a** | `InpTrailTF` **M5→M30** (enum) | **7** | 0.40 |
| **R128b** | `InpTP1_R` 0→3,0, parziale SPENTO | **7** | 0.50 |
| **R128c** | `InpTrailFixedPts` 410→13010 | **8** | 0.50 |
| **R128d** | `InpUseTrailing` 0/1 — **IL CONTROLLO** | **2** | 0.50 |
| **R128e** | `InpCloseHour` 11→21 (**ora SERVER**) | **6** | 0.50 |

## 🔓 Il giacimento: **la griglia dell'08/08 si è fermata sul valore VIVO**
Profitto OOS massimo per TF: `M1 +1139,64 · M2 +1865,70 · M3 +1861,04 ·
M4 +2155,58 · **M5 +1810,72**` — e **M5 è l'ultima colonna provata**, cioè il
valore in campo. **La superficie si stava ancora muovendo sul bordo.**
📌 **Mezza manopola provata non è una manopola provata.**

## 📢 L'ATTESA, e non è quella che il mio brief suggeriva
> **NON mi aspetto un miglioramento, ed è scritto nei file prima dei numeri.**
> Il risultato che mi aspetto di più è **"il default va bene"** — ed è un
> risultato, non un fallimento. R128 non ripara niente: **dà un `n` e un
> altopiano a una configurazione che in campo ne ha 11.**
> 🔺 **E l'orologio (R128e) è salito di rango**: è l'unica manopola d'uscita che
> in campo ha **già prodotto una perdita**, e non è mai stata mossa.

## 🧪 IL CONTRO-ESEMPIO — la griglia distingue i tre mondi
| | il trailing **TAGLIA** | il trailing **PROTEGGE** | **INDIFFERENTE** |
|---|---|---|---|
| R128a | una cella M6-M30 ≥ +10% a DD non peggiore | M10-M30 peggiorano | tutto entro ±5% |
| R128c | massimo a distanza ≥ 5.810 punti | sale poco e si appiattisce | curva piatta |
| R128d | **la spenta batte l'accesa in OOS** | la spenta perde su PF **e** sfonda il DD | DD peggiore da spenta |

🔑 **Non esiste combinazione che faccia coincidere i tre scenari**: R128a e R128c
allargano la distanza per **due strade indipendenti** — se la diagnosi fosse
giusta **devono salire tutte e due**; R128d porta la distanza **a infinito** ed è
il **limite** dei due assi.
🎁 **Cancello incrociato gratis**: la cella `13010` (130,1 idx, **più larga dello
stop iniziale**) **deve convergere** su "trailing spento" di R128d. Se non lo fa,
**il banco è sporco**.

## 🚨 CLASSE NUOVA per `CHECKLIST_RIGA_DI_LANCIO.md`: **LA VERIFICA CHE NON DISCRIMINA**
La nota d'archivio *"MT5 sugli enum ignora lo step — misurato il 07/08"* era
basata su `InpTrailTF=5||1||1||5`: da M1 a M5 con passo 1, **aritmetica ed
enumerazione danno la STESSA risposta** (1,2,3,4,5). **Quel test non distingueva
niente.** La prova vera sta in archivio: `InpTF=16385||15||1||16408` ha prodotto
**11 righe** dove l'aritmetica ne avrebbe fatte **16.394**.
📌 **Un test in cui l'ipotesi alternativa produce lo stesso risultato non è una
verifica: è una coincidenza.**

---

# ⏱️ COSTO · 🕳️ BUCHI · 🔥 LA COSA PIÙ PROMETTENTE

**Tempo macchina**: calibrazione misurata (`r88_csv/REFERTO_R88.txt`: 96 passate
in 8,0 min = **5,0 s/passata**) → **60 passate ≈ 7,0 min**. Banda **6-12 min**
(calibrazione da U30USD, non D30EUR).

**Buchi dichiarati:**
1. 🔴 **`InpTP1_ClosePct`: CONFLITTO APERTO.** Il preset dice **50%**, la pagella
   03/09 misura il parziale **su due conti** a **1/3**. **Un terzo non è metà.**
   Si chiude leggendo gli input sul terminale — **sola lettura, domanda per Claudio.**
2. Stop RETEST **derivato, non misurato** (n=0 in campo) + i 2 punti da riconciliare.
3. Ampiezza mediana della candela per TF all'ora 8 = `[NON MISURATO]`.
4. TP non separabile dal parziale senza toccare l'EA (`TpTotalR()` r.1621-1627 è
   **cablato a `3 × InpTP1_R`**: una manopola, due effetti).
5. Nessuna prova di regime (tick solo dal 2024.09.26).
6. Round a 1,0%, campo a 0,65%: **DD da riscalare ×0,65**.

## 🔥 E LA COSA PIÙ PROMETTENTE NON È IN R128
**R118c** (tick, stessa finestra, RETEST **ma con lo short acceso**):
`InpMinStopPts=6000` (60 idx) con `InpSkipIfTight=1` →
**OOS PF 1,4382 · DD 6,64% · n 226** contro **1,1878 · 10,60% · n 311** a floor 0.
**PF meglio, DD meglio, 85 operazioni in meno.**

> 🎯 **È la manopola che porterebbe la sedia DENTRO la frontiera del costo** (oggi
> al 72%), **ed è già stata misurata una volta — ma sul lato sbagliato.**
> **Va rifatta long-only: 10 passate.** Vale più di tutto il resto.

---

## 🚦 STATO DEI CANCELLI
✅ `controlla_riga.py --oggetto prova`: **5/5 nessun difetto meccanico**
✅ `controlla_prova.py`: **5/5 OK, 0 problemi**, pin=81
✅ **ASCII puro**: 0 byte non-ASCII nei cinque `.txt`
🔴 **MANCA**: `controllo-preventivo` (giudizio) · la dichiarazione del **REGIME**
della finestra · 🔴 **e il round NON PUÒ GIRARE**: perimetro del runner in **sola
lettura**.

**Non ci accontentiamo. 🔥 Tre cose che credevo di sapere sono cadute oggi, e ognuna era un pezzo di sedia.**
