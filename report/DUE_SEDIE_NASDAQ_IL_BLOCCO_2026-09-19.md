# 🛑 DUE SEDIE SUL NASDAQ — **il pacchetto è pronto, ma una può chiudere la posizione dell'altra**

**19/09/2026** · decisione di Claudio: *«Metti tutti e due, Pass 8 e Pass 6»*

---

## ① 🟢 IL ROUND REGGE, ed è meglio di come l'avevo proposto

Confronto a macchina su **78 colonne `Inp*` × 2 finestre**:

| | differenze fra `Pass=6` e `Pass=8` |
|---|---|
| finestra **IS** | **1** — `InpEntryMode` 0 vs 2 |
| finestra **OOS** | **1** — `InpEntryMode` 0 vs 2 |
| 🎁 fra **IS e OOS** della stessa cella | **0** su 78 |

> ## 🔥 **È un duello controllato a UNA manopola, e lo è anche fra le due finestre.** Se in forward una batte l'altra, la causa è quel singolo input.

| | `770260` **Pass 8** | `770261` **Pass 6** |
|---|---|---|
| ingresso | RETEST | BREAKOUT |
| IS | PF **1,14498** · n 91 · DD 5,8450 | PF 1,07124 · n **114** · DD 5,8450 |
| OOS | PF **1,10936** · n 94 · DD **3,68%** | PF 1,06338 · n **108** · DD 4,13% |

I `.set`: **80 input**, **nessun valore sbagliato**, copertura verificata nei due versi contro il
binario `3af47ed9` (zero input in più, zero in meno), md5 del sorgente confermato.
🔴 **E dichiarano onestamente che né 108 né 94 raggiungono il pavimento dei 150.**

---

## ② 🛑 IL BLOCCO — **`770261` può chiudere la posizione di `770250`**

`ABTG_Nasdaq_Apertura_US.mq5` **r.1858** (binario in campo, `3af47ed9`):
```mql5
if(InpCloseAtEnd && SelectMyPosition())
  {
   gTrade.PositionClose(_Symbol);
```
🟢 La **guardia** `SelectMyPosition()` è hedge-safe.
🔴 L'**azione** no: su conto **HEDGING** `PositionClose(_Symbol)` chiude la posizione **più
vecchia del simbolo**, di chiunque sia.

### 🟠 E non è una scoperta: **è già censito in casa dal 3 settembre**
`report/AUDIT_POSITIONSELECT_HEDGING_2026-09-03.md`:
- r.39, testuale: *«`gTrade.PositionClose(_Symbol)` → seleziona la posizione **più vecchia** del
  simbolo e la chiude»*
- r.89: `ABTG_Nasdaq_Apertura_US` classificato 🟠 **proprio su `NASUSD · 770250`**, con **6**
  occorrenze.

### 🔴 Ed era innocuo **per una ragione sola**, che questo round toglie
L'audit lo scrive: era tollerabile perché **su quel simbolo c'era UNA sola posizione** — quindi
*«la più vecchia È la nostra»*. 👉 **Con due sedie nuove accanto, quella condizione cade.**

**In concreto**: alle **17:30 server** `770260`/`770261` chiamano `EndOfSession()`. Se hanno una
posizione aperta, la `PositionClose(_Symbol)` colpisce la **più vecchia su NASUSD** — che sarà
quella di `770250`, entrata fra le 14:30 e le 16:30 e che **per contratto deve restare fino alle
20:45**.
👉 Effetto: **`770250` va flat 3h15 prima**, e il suo forward **smette di misurare il suo
contratto**.

⚠️ **Frequenza attesa dell'incrocio: [STIMA, non misura]** — `770250` ~5 op/mese × `770261` ~9
op/mese → **un paio di volte al mese come pavimento**, e sale perché le tre sedie sparano sullo
stesso evento. **Per misurarla davvero** servirebbe il per-trade dei due Pass incrociato con le
date vere di `770250`: non esiste in repo.

---

## ③ 🧮 IL RISCHIO APERTO SIMULTANEO — **il numero, senza proporre taglie**

Posizioni massime per magic (lette nel sorgente): `770250` **1** (solo short) · `770260` **1**
(RETEST: un limit, poi `PH_PLACED`) · `770261` **2** (BREAKOUT a due lati piazza BUY STOP **e**
SELL STOP; l'OCO cancella la superstite **al tick dopo**).

| caso | conto | totale |
|---|---|---:|
| 🟢 una posizione per magic, tutte short | 0,35 + 1,00 + 1,00 | **2,35%** |
| 🟡 solo le due nuove | 1,00 + 1,00 | **2,00%** |
| 🔴 whipsaw che riempie **tutti e due** i lati di `770261` | 0,35 + 1,00 + 2,00 | **3,35%** |

🔴 **Il cap C1 firmato è 3,25%: il caso peggiore lo supera.** E su quel conto **non c'è niente
che lo faccia rispettare** — il binario `3af47ed9` ha **zero** `InpUsaGuardian`, e sul piccolo
**nessun Guardian gira** (giornale 16 e 17/09).

💯 **Onestà sul 3,35%**: con `SLMode=SL_RANGE` e slippage 0, lo SL del BUY e l'entry del SELL STOP
stanno **allo stesso prezzo**. La doppia esposizione è **istantanea**, non tenuta per ore — ma è
reale nell'istante in cui un cap la misurerebbe.
⚠️ **Amplificatore NON quantificato**: `CalcLotByRisk` chiude con `MathMax(minLot, …)`. Sotto il
lotto minimo il rischio **vero** sale sopra l'1,0% nominale. Serve `SYMBOL_VOLUME_MIN` di NASUSD
su BCM: **non leggibile da qui**.

---

## ④ 🔴 UNA MIA CORREZIONE: **i commenti NON sono tutti uguali**

Avevo detto che tutte e tre avrebbero scritto la stessa stringa. **Falso**: ogni ramo attacca un
suffisso diverso.

| sedia | motore | stringa **vera** |
|---|---|---|
| `770250` | BREAKOUT short | `Nasdaq Apertura US SELL` |
| `770261` | BREAKOUT 2 lati | `Nasdaq Apertura US BUY` / `SELL` |
| `770260` | **RETEST** | `Nasdaq Apertura US RETEST BUY` / `RETEST SELL` |

👉 **La collisione è a DUE vie (`770250` ↔ `770261`, solo sul lato SELL), non a tre.** `770260` è
distinguibile. L'errore sembrava prudente, ma **cambia quali strumenti sbagliano**.

### Gli strumenti che ragionano per commento, uno per uno
| strumento | esito su NASUSD |
|---|---|
| `analizza_trades.py` (pagella) | 🟢 **OK** dal commit `75bd75d9`. ⚠️ Limite residuo: disambigua **sul solo giorno**, quindi in un giorno con una sola sedia attiva l'etichetta torna nuda |
| `classifica_report_mt5.py` | 🔴 **SBAGLIA**: `famiglia()` toglie `BUY/SELL` ma **non `RETEST`** → fonde `770250`+`770261` e separa `770260`. **Il duello lì non è leggibile** |
| `CODA_02_chi_ha_operato.ps1` | 🟡 conta per prefisso di log, identico per tutte e tre: il conteggio **triplicherà** (limite già dichiarato nel suo header) |
| `ABTG_ChiudiSedie.mq5` · `audit_flotta.py` · `censimento_rischio.ps1` | 🟢 ragionano per magic |

---

## ⑤ 🎁 E IL CANCELLO HA TROVATO UN BUCO **NEL CANCELLO STESSO**

`controlla_riga.py` spogliava i commenti con `split("#",1)` e **non conosceva il `;`** dei `.set`.
Risultato: **bocciava la riga che `CLAUDE.md` rende OBBLIGATORIA** (*«NON su -V3 (50504263), NON
su C:\BCM_Reale (10105439)»*), scambiandola per un bersaglio vivo.
🔴 **Puniva chi rispettava la regola e lasciava passare chi taceva.** E la gemella `770260` —
che ieri ha avuto il PASS — **falliva allo stesso modo: quel PASS è stato dato con lo strato 1
rosso.** ✅ Corretto (commit `3e26c785`), con sei contro-esempi verdi fra cui la non-regressione
sui `.ps1`, dove il `;` è separatore di istruzioni e **non si tocca**.

🔴 **E un buco di strumentazione resta aperto e va detto**: `controlla_prova.py` risponde
*«EA NON TROVATO → non misurabile»* su un `.set`. **Un `.set` MT5 oggi non ha nessuno strato-1
semantico.**

---

## ⑥ ✍️ LE TRE STRADE — **e sono tutte firma di Claudio**

Nessuna si può fare da un `.set`:

| | cosa | costo |
|---|---|---|
| **1** | **Ricompilare** l'EA con la chiusura **per TICKET** a r.1858 | tocca il binario di una sedia in **forward** → ripassa dal cancello |
| **2** | **Spegnere `770250`** per la durata del banco di prova | si perde il forward della sedia viva |
| **3** | **Accettarlo dichiarandolo**: nero su bianco che dal giorno X il forward di `770250` non è più confrontabile col suo contratto | zero lavoro, si paga in misura |

📌 **Nota mia, non una proposta**: la strada **1** è la sola che non costa una misura — ed è la
stessa riga che va sistemata comunque su **altri sette EA** secondo l'audit del 03/09.

---
*Fonti: `ABTG_Nasdaq_Apertura_US.mq5` a `3af47ed9` rr.553, 1858, 679-681, 701-715, 1544, 1603 ·
`report/AUDIT_POSITIONSELECT_HEDGING_2026-09-03.md` rr.39 e 89 ·
`Walkforward_Aperture/NASDAQ_B_motore_{IS,OOS}.csv` righe `Pass=6` e `Pass=8` ·
`backtest_pipeline/controlla_riga.py` (correzione `3e26c785`) · classi **439**, **440**, **441**
in `CHECKLIST_RIGA_DI_LANCIO.md`.*
