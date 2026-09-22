# 🩸 IL PRIMO STOP VERO DELLA CHALLENGE — e costa il 10,5% IN PIÙ di quello che il modello prometteva

**22/09/2026** · conto FTMO `541452707` · sedia **`771531` EMA200 Dow** · simbolo `US30.cash`
Fonte: schermate `Storico > Affari` e `Trade` del telefono di Claudio, 14:24 ora italiana.

> ## 🎯 IN UNA RIGA
> **Lo stop ha funzionato, ma è stato riempito 7,83 punti oltre il livello.** La perdita reale è
> **−1.757,68 €** contro i **−1.590,37 €** che il nostro modello prometteva: **+10,5%**.
> 🔴 **Se quel 10,5% è sistematico, OGNI drawdown promesso nei nostri referti è sottostimato.**

---

## 1. 📋 I FATTI, dal libro affari

| | ingresso | uscita | P/L |
|---|---|---|---:|
| **S1** | sell **9,11** @ `52160,28` · 12:52:01 | buy @ `52265,82` · 14:45:51 | **−844,58** |
| **S2** | sell **13,67** @ `52189,78` · 12:52:31 | buy @ `52265,82` · 14:45:51 | **−913,10** |
| | | **Bilancio** | 🔴 **−1.757,68** |

Commento di tutti e due gli affari: **`[sl 52257.99]`** → chiusi dallo **stop**, non a mano.
Saldo: `80.000,00` → **`78.242,32`**. *(Orari in ORA SERVER: 14:45:51 server = 13:45:51 italiane.)*

---

## 2. 🔬 LA SCOMPOSIZIONE — tre pezzi, e due non li avevamo modellati

| | perdita | % del conto | |
|---|---:|---:|---|
| **A** — allo SL esatto, col cambio d'ingresso | **1.590,37** | 1,988% | ✅ quello che il modello prometteva |
| **B** — allo SL esatto, col cambio d'uscita | **1.601,00** | 2,001% | 🟠 `+10,62` = **deriva del CAMBIO** |
| **C** — **REALE**, riempito a `52265,82` | 🔴 **1.757,68** | 🔴 **2,197%** | 🔴 `+156,68` = **SLIPPAGGIO** |

**Eccesso totale sul promesso: `+167,31 €` = `+10,5%`.**

### 🔴 (C) Lo slippaggio sullo stop — **prima misura vera su `US30.cash` FTMO**
Stop a `52257,99`, riempimento a **`52265,82`** → **7,83 punti contro**, su **22,78 lotti**.
Lo spread in quel momento era **2,38** → lo slippaggio vale **3,3× lo spread**.
⚠️ `n = 1`. **Un solo campione non è un tasso**: va accumulato prima di usarlo come fattore.

### 🟠 (B) Il valore per punto **NON è una costante** — misurato, non supposto
`US30.cash` è quotato in **USD**, il conto è in **EUR**: il valore per punto si muove **col cambio**.

| momento | valore per punto | come l'ho ricavato |
|---|---:|---|
| 12:26 (posizioni aperte) | **0,8726** | dai due P/L flottanti, due strade indipendenti |
| 14:45 (chiusura) | **0,8784** | dai due P/L realizzati, due strade indipendenti |

**Deriva: +0,67% in due ore.** 👉 `CalcLotByRisk` dimensiona col cambio **dell'ingresso**, la perdita
si paga col cambio **dell'uscita**: è una varianza sul rischio che **non controlliamo e non modellavamo**.

---

## 3. 🟢 LO STOP HA AVUTO RAGIONE — e va detto, perché non è scontato

Dopo la chiusura il prezzo **ha continuato a salire**: alle 15:24 server era a **`52277,34`** in acquisto,
con un massimo intorno a **`52291`**.
👉 Tenendo aperto fino a lì avremmo perso **altri 230,51 €**, per un totale di **1.988,19 € = 2,485%**.

🔴 **Quindi lo stop non ci ha tolto una vincita: ci ha risparmiato il 13% in più di perdita.**
Non è stato un *whipsaw*: l'ipotesi «il prezzo rifiuta la EMA200» era **sbagliata**, e lo stop l'ha
incassata al prezzo deciso prima.

---

## 4. 🧱 DOVE SIAMO CONTRO I LIMITI FTMO

| limite | consumato | 🟢 margine residuo |
|---|---:|---:|
| **Perdita giornaliera 5,00%** | 2,197% | **2,80 punti** |
| **Muro totale 10,00%** | 2,197% | **7,80 punti** |

🟢 **Nessuna situazione di pericolo.** È una perdita dimensionata, di una sedia che ha fatto il suo
mestiere.

---

## 5. 🔴 LA CONSEGUENZA CHE NON VA PERSA

Il **criterio di uscita firmato il 18/08** dice: *«DD forward > DD promesso dal backtest → revisione
IMMEDIATA»*. 🔴 **Qui non è il DD a essere stato superato: è il METRO.** La singola perdita massima
promessa era **1,988%** e ne è costata **2,197%**.

**Cosa NON si fa:** cambiare un parametro su **un solo campione**. `n = 1`.
**Cosa si fa:** si accumulano i campioni. `RIGA_SLIPPAGELOGGER` esiste già in repo, e la sonda
`IMBUTO_EMA200_FTMO` (pin `3a57dc67`) legge i log FTMO in sola lettura.

📌 **La domanda aperta, da misurare e non da opinare**: lo slippaggio sullo stop è un costo
**sistematico** (e allora ogni DD promesso va moltiplicato per un fattore da misurare) o è stato
**l'evento singolo** di un mercato in corsa? **[NON MISURATO]** — serve `n`.

---

## 6. 🕳️ NON COPERTO
- Il **fattore di slippaggio**: `n = 1`. Nessuna conclusione.
- **Perché** il prezzo è passato oltre lo stop di 7,83 punti: non ho i tick di quel minuto.
- Se `ABTG_EMA200` si sia **riarmato** dopo lo stop (`InpMaxTradesPerDay=0`, nessun tetto): da leggere
  nei log.
- Se la **deriva del cambio** sia stata EURUSD o un aggiustamento del broker: non misurato.
