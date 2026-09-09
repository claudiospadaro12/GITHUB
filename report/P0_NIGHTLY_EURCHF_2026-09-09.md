# 🌙 PASSO 0 `ABTG_Nightly` su EURCHF — **BOCCIATO PER RISCHIO**, e chiude una famiglia

Girato sul VPS il 09/09/2026. `rc=0`, **RILIEVI: 0**, PID degli altri terminali intatti.

---

## 📊 I NUMERI

| finestra | Trades | Profit | PF | **DD %** |
|---|---:|---:|---:|---:|
| **IS** | 63 | **−408,07** | **0,89113** | 🔴 **11,0988** |
| **OOS** | 85 | **−956,49** | **0,81429** | 🔴 **15,3861** |

## ✅ LE ATTESE DICHIARATE PRIMA: **centrate tutte e due**

| attesa congelata | misurato | |
|---|---|---|
| **135-315 operazioni** totali | **148** | ✅ (estremo basso) |
| *"quella forbice sta SOTTO le 150 per finestra"* | **63 e 85** | ✅ **previsto** |

*(Seconda previsione centrata di fila, dopo le tre sbagliate sull'OpeningReversalB.
Non è bravura: è che l'attesa era costruita sul numero di notti, non sul desiderio.)*

---

## 🏁 IL VERDETTO, dal criterio congelato PRIMA della corsa
> *"DD > 10% su una cella → **BOCCIATO per RISCHIO**, subito, qualunque sia il
> conteggio (Emendamento B)."*

**11,10% e 15,39%.** Sfondano **tutte e due**, e il muro di una challenge è 10%.
👉 **BOCCIATO.**

E il merito, per quel poco che si può dire sotto le 150 operazioni, **va nella
stessa direzione**: **in perdita in ENTRAMBE le finestre** (PF 0,891 e 0,814).
🔴 È la forma **meno ambigua** di verdetto negativo che abbiamo raccolto in questi
giorni: non "guadagna in una finestra e perde nell'altra", ma **perde sempre**.

## 🧊 E il dubbio sullo spread **non lo salva**
Avevo dichiarato prima: *"lo spread di EURCHF non è misurato, qualunque PF esca
va riletto"*. 👉 Quella riserva poteva solo **peggiorare** un PF, mai migliorarlo:
**un costo non misurato è un costo in più, non uno sconto.** Con PF 0,81-0,89 il
verdetto regge **a prescindere** da quanto vale lo spread.

---

## 🔒 COSA CHIUDE, ed è il valore vero di questa corsa

Il fade del box notturno è ora misurato su **quattro coppie**, e **tutte e quattro
sono coppie che il corso AMMETTE**:

| coppia | esito | quando |
|---|---|---|
| EURUSD · GBPUSD · USDCHF | 🔴 negativo (~160 trade a testa) | agli atti, `REGISTRO_TEST.md` |
| **EURCHF** | 🔴 **negativo, e con DD sopra il muro** | **oggi** |

> ### 🎯 EURCHF era **la prima coppia che Paolo nomina**, la più "lenta" di notte,
> quella su cui la strategia dovrebbe funzionare **meglio**. Non funziona.
> **Il buco che avevo trovato ieri era reale — ed è stato chiuso in una corsa.**

### 📉 E il valore marginale di provare le altre è basso
Restano `EURCAD`, `GBPCAD`, `EURGBP`. A **quattro su quattro negative**, una
quinta coppia negativa aggiunge poco; e se una uscisse positiva su n<150,
**non potremmo comunque promuoverla**. A 22 giorni dalla challenge, **il tempo
macchina rende di più altrove**.
🔓 **Non è una chiusura definitiva**: se un giorno si misura la profondità tick
vera del forex e la finestra si allunga sopra le 150 per parte, la domanda si
riapre — con un campione che permette un verdetto di merito.

## 🆕 E resta in piedi la cosa NUOVA della live
Il **box PROIETTATO** (media degli N box precedenti, ordine piazzato **prima**
della notte) è un **meccanismo diverso**, non una variante di questo. Questo
round **non lo tocca**: boccia il fade del box *realizzato*, non la previsione.
Spec e tre parametri liberi in `caccia_strategie/ANALISI_LIVE_PAOLO_2026-09-08.md`.

💰 **Costo del verdetto: una corsa.** L'EA era già scritto e già compilato.
