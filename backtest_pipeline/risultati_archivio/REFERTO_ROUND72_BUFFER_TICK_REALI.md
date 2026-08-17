# 🏁 R72 — **IL BUFFER SOPRAVVIVE AI TICK REALI.** Quattro superfici su quattro, monotone.

> ## ✍️ CORREZIONE, scritta lo stesso giorno e PRIMA che Claudio decidesse
> **La cella che in questo referto chiamo "VIVA" NON è la configurazione che
> gira in forward.** La griglia ha `InpTP1_ATRmult = 0` (il default del
> sorgente), mentre le sedie del vivaio R23 — **771321/22/23** — girano con
> **`InpTP1_ATRmult = 0.5`** (`report/VIVAIO_R23_DEPLOY.md` righe 38-40): metà
> posizione chiusa a **0,5 ATR**. Vale per **tutta la serie R68-R72**.
>
> **Cosa cambia e cosa no:**
> - ✅ **Il §1 (buffer → drawdown) NON è toccato**: è una relazione lungo tutta
>   la griglia, misurata a `TP1` costante. Le otto conferme reggono.
> - 🔴 **Il §2 e la PROPOSTA sì**: il criterio 2 confronta la candidata contro
>   una cella che **non è la sedia viva**. Quel confronto **non è valido**, e
>   la frase _"la config viva è l'unica cella negativa"_ **è ritirata**: quella
>   cella è `buffer 5 senza TP1 parziale`, che in forward non gira da nessuna
>   parte.
> - ⏸️ **La proposta passa da FORMALE a SOSPESA**, in attesa di **R73**: stessa
>   griglia con `InpTP1_ATRmult = 0.5` pinnato, così dentro c'è davvero la
>   sedia viva.
>
> Il resto del referto è lasciato com'era scritto: **si corregge in testa, non
> si riscrive la storia.**


_Il primo round della serie del buffer che vale come **VERDETTO** e non come
proposta. R68-R71 erano tutti OHLC._

**Banco:** `ABTG_PTE` · H1 · **Modello 4 = TICK REALI di BCM** · deposito 100.000 ·
rischio 1% · `SLfromDoji` pinnato a 0.
**IS `2024.07.05 → 2025.04.21`** · **OOS `2025.04.22 → 2026.06.30`** — le
**stesse identiche finestre di R58**, quindi confrontabili con quel round.
**14 celle** (buffer 0-30 × TP2 {2,0 ; 3,0}) su due simboli.

### ✅ La trappola di R58 NON ha morso

In R58 le direttive `@` passarono ma **le righe di parametro no**, e girò una
griglia vecchia da 16 celle. Controllo fatto **prima** di leggere i numeri:
`Model=4` ✅ · `InpSLbufferPips` 7 valori ✅ · `InpTP2_ATRmult` 2 valori ✅ ·
`InpSLfromDoji=0` ✅ · **14 celle su 14 in tutti e quattro i CSV** ✅.

---

## 1. 🎯 DOMANDA 1 (il rischio) — **PASSATA, E NEL MODO PIÙ NETTO POSSIBILE**

**Drawdown, tutte e quattro le superfici:**

| buffer | GBPUSD IS | GBPUSD **OOS** | USDJPY IS | USDJPY **OOS** |
|---:|---:|---:|---:|---:|
| **0** | 2,23 | 3,53 | 4,22 | 5,44 |
| 5 | 2,04 | 3,05 | 3,67 | 5,34 |
| 10 | 1,70 | 2,90 | 3,60 | 4,20 |
| 15 | 1,47 | 2,79 | 3,52 | 4,05 |
| 20 | 1,28 | 2,72 | 3,46 | 3,94 |
| 25 | 1,14 | 2,67 | 3,42 | 3,81 |
| **30** | **1,03** | **2,59** | **3,36** | **3,16** |

> ### 🏆 **QUATTRO SUPERFICI SU QUATTRO, MONOTONE DALLA PRIMA ALL'ULTIMA CELLA. Zero eccezioni.**
>
> **Settima e ottava conferma della relazione buffer → drawdown, e le PRIME a
> tick reali.** In R57 bastava cambiare il modello per ribaltare il segno di
> questo stesso motore. **Qui il modello è cambiato e la relazione non si è
> mossa di un decimo.**

📌 **Da oggi non è più una proposta OHLC: è un fatto misurato sul riempimento
vero del nostro broker.** `InpSLbufferPips` è il parametro che governa il
drawdown della PTE.

## 2. ⚖️ DOMANDA 2 (il merito) — **PASSATA SU USDJPY, BOCCIATA SU GBPUSD**

Criterio 2, congelato prima dei numeri: _"la CANDIDATA abbassa il DD **SENZA
perdere profitto OOS** contro la VIVA"_.

### 🔴 GBPUSD — **NON PASSA**

| | IS | **OOS** | PF | **DD** | pegg. GG | n OOS |
|---|---:|---:|---:|---:|---:|---:|
| 🪑 **VIVA** `buf 5 / TP 2,0` | +6.716 | **+3.166** | 1,46 | 3,05% | −1,05% | 55 |
| 🎯 CANDIDATA `buf 25 / TP 3,0` | +3.830 | **+1.566** | 1,38 | **2,67%** | −1,04% | 74 |

**Il DD scende (3,05 → 2,67) ma il profitto si dimezza (−50,5%). Criterio non
soddisfatto → su GBPUSD non si propone niente.** Anzi: qui il profitto scende
**monotonamente** col buffer (+3.953 a buffer 0 → +1.076 a buffer 30). **Sul
cavo sterlina il buffer è uno scambio: paghi rendimento per comprare
sopravvivenza.**

### 🟢 USDJPY — **PASSA, E NON DI POCO**

| | IS | **OOS** | PF | **DD** | pegg. GG | n OOS |
|---|---:|---:|---:|---:|---:|---:|
| 🪑 **VIVA** `buf 5 / TP 2,0` | −1.081 | **−837** | **0,92** | 5,34% | −1,61% | 35 |
| 🎯 CANDIDATA `buf 25 / TP 3,0` | −1.024 | **+3.158** | **1,87** | **3,81%** | **−1,31%** | 64 |

> ### 🔴 **A tick reali, la configurazione che gira in forward su USDJPY è l'UNICA cella negativa della griglia** (2 celle su 14 negative, ed entrambe sono `buffer 5`).
>
> **La candidata è migliore su TUTTO: +3.995 di profitto, PF da 0,92 a 1,87, DD
> da 5,34% a 3,81%, peggior giornata da −1,61% a −1,31%. Nessuna
> compensazione, nessun compromesso.**

📌 E conferma R69, che sui 16 anni OHLC aveva trovato `buffer 5` fra le tre
celle negative su 28. **Due modelli diversi, due finestre diverse, stessa
diagnosi.**

## 3. 🚦 CRITERIO 3 — cosa autorizza questo round, letteralmente

Il file prova dice: _"solo se il punto 1 **E** il punto 2 passano ENTRAMBI, si
può **PROPORRE** a Claudio un cambio in forward. La decisione resta sua."_

| | GBPUSD | USDJPY |
|---|---|---|
| punto 1 (rischio) | ✅ | ✅ |
| punto 2 (merito) | ❌ | ✅ |
| **quindi** | 🔴 **niente da proporre** | 🟢 **si può proporre** |

> ## 🟢 **PROPOSTA FORMALE, LA PRIMA DELLA SERIE:**
> **`PTE USDJPY` (magic 771323): `InpSLbufferPips` da 5 a 25 e `InpTP2_ATRmult`
> da 2,0 a 3,0.**
>
> 🔴 **NON è stato fatto niente. È una proposta, e la decisione è di Claudio.**

### Con i muri della prop (rischio 0,65%)

| | DD | peggior giornata |
|---|---:|---:|
| VIVA a 0,65% | 3,47% | −1,05% |
| **CANDIDATA a 0,65%** | **2,48%** | **−0,85%** |

Entrambe stanno dentro i muri (10% totale, 5% giornaliero). **La differenza non
è la sopravvivenza: è che una guadagna e l'altra no.**

## 4. 🚫 QUELLO CHE QUESTO ROUND **NON** AUTORIZZA — e va detto forte

**a) 🔴 La SELEZIONE resta SOSPESA.** n IS = 33-42, contro la soglia di **150**
del punto A. **Su USDJPY la cella migliore in assoluto è `buffer 30`
(OOS +3.229, PF 2,09, DD 3,16%) — ed è VIETATO sceglierla**, perché sarebbe una
selezione fatta su un campione che il criterio dichiara insufficiente. Le due
celle giudicate erano **nominate prima**, ed è l'unica cosa che questo round
poteva fare.

**b) ⚠️ Niente 2020, niente 2022.** I tick reali partono dal 2024.07.05: questo
round valida il **riempimento** (spread veri, stop presi dentro la barra,
ordini eseguiti davvero), **mai la robustezza di regime**. Identico limite di R58.

**c) 📌 L'IS di GBPUSD ha PF fino a 18,67.** Non è un edge: è una finestra di
nove mesi quasi senza perdite. **L'OOS scende a 1,46 — ed è per questo che i
verdetti si leggono fuori campione.**

**d) 🔍 Su USDJPY l'asse del target è INERTE in OOS**: `TP2 2,0` e `TP2 3,0`
danno numeri **identici al centesimo** in tutte e sette le righe. Quel target
non viene mai raggiunto; le posizioni escono per TP1, breakeven, trailing o
segnale opposto. **Quindi il merito della candidata viene TUTTO dal buffer, non
dal target.** (Nell'IS invece il TP2 muove i numeri: cambia l'epoca, cambia il
comportamento.)

**e) 🔁 Non ribalta R57** e non tocca il Dow (lì l'asse è inerte per unità di
misura, R69 §3).

## 5. 📐 E LA REGOLA B SI CONFERMA UNA TERZA VOLTA

| | GBPUSD | USDJPY |
|---|---|---|
| DD contro buffer | ↓ monotono | ↓ monotono |
| profitto contro buffer | **↓ monotono** | **↑ (opposto)** |

**Il rischio si comporta uguale sui due simboli. Il rendimento fa il contrario.
Terza replica, e la prima a tick reali, del principio: _il buffer è un parametro
di RISCHIO affidabile e un parametro di RENDIMENTO inaffidabile._**

---

## 6. 🚦 VERDETTO

> **1. 🏆 Il crollo del drawdown col buffer È REALE: sopravvive al cambio di
> modello, su 4 superfici su 4, monotono ovunque. Otto conferme in totale.**
>
> **2. 🟢 Su USDJPY la configurazione viva è l'unica cella negativa a tick
> reali, e la candidata la batte su profitto, PF, drawdown e peggior giornata.
> Criterio 2 soddisfatto → PROPOSTA formale a Claudio.**
>
> **3. 🔴 Su GBPUSD la candidata dimezza il profitto: niente da proporre, la
> sedia resta com'è.**
>
> **4. ⏸️ Nessuna cella NUOVA può uscire da qui: n=33-42 contro 150.**
>
> **5. 🔴 NON È STATO TOCCATO NIENTE. La decisione è di Claudio.**

## 7. ➡️ SE CLAUDIO DICE SÌ

1. Cambio **solo su USDJPY** (magic 771323): `InpSLbufferPips 5 → 25`,
   `InpTP2_ATRmult 2,0 → 3,0`. GBPUSD e Dow **non si toccano**.
2. Preset salvato e **verifica dal `.chr`** campo per campo, come nel deploy
   R23 (i pixel non servono, i file sì).
3. Il contatore di collaudo riparte: **10 trade = collaudo, 30 = verdetto**.
   A ~50 trade/anno sono **~2,5 mesi** e **~7 mesi**.

**E se dice no, va bene lo stesso:** il round ha già consegnato la cosa che
valeva di più — **il buffer governa il drawdown della PTE, e adesso è misurato
sui tick veri.**
