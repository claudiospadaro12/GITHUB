# LA CELLA CHE VINCE GIRAVA SENZA BREAKEVEN -- e nessuno se n'era accorto

**22/09/2026** · sola lettura · nessun EA, preset o forward toccato
Sedia **`770101`** DAX Apertura EU · `D30EUR` M5

> ## IN UNA RIGA
> La cella che alza il PF da **1,39709 a 1,49140** e abbassa il DD da **7,2328% a 6,2719%**
> e' stata misurata **con il breakeven COMPLETAMENTE SPENTO**. Vince **handicappata**.

---

## 1. IL FATTO, letto dai CSV

`risultati_prove/aperture_r46/..._OOS_r46a.csv` e
`risultati_prove/dal_vps/ABTG_DAX_Apertura_EU/..._OOS_r137c.csv`, due corse indipendenti
(la seconda **sul binario col Guardian**), riportano la stessa cella al quinto decimale:

| colonna | cella viva | cella proposta |
|---|---:|---:|
| `InpTP1_ClosePct` | **50** | **0** |
| `InpBreakevenAtTP1` | 1 | 1 |
| **`InpBEatR`** | **0** | **0** |
| `InpTrailMode` | 1 | 1 |
| `Profit Factor` | 1,39709 | **1,49140** |
| `Equity DD %` | 7,2328 | **6,2719** |
| `Trades` | 270 | **193** |
| `Profit` | 18.029,58 | **23.607,28** |

## 2. PERCHE' QUELLA RIGA `InpBEatR = 0` CAMBIA TUTTO

In `mql5/Experts/ABTG_DAX_Apertura_EU.mq5` ci sono **DUE** breakeven, e con
`InpTP1_ClosePct=0` **non ne resta acceso nessuno**:

| | riga | condizione | con `ClosePct=0` |
|---|---|---|---|
| BE al primo obiettivo | ~2391 | annidato dentro il blocco del parziale, che si apre a **r.2359** con `InpTP1_ClosePct > 0` | **IRRAGGIUNGIBILE** -- `InpBreakevenAtTP1=true` resta acceso dietro una porta chiusa |
| BE indipendente | **2405** | `if(InpBEatR > 0 ...)` | **SPENTO**, perche' `InpBEatR = 0` |

👉 **La cella da 1,49 di PF ha corso dall'ingresso allo stop (o al target) senza mai portare
lo stop a pari.** Nessuna protezione, nemmeno una.

## 3. LE DUE CONSEGUENZE, e vanno tutte e due nella stessa direzione

**(a) La proposta e' PIU' FORTE di come e' stata presentata.** Non e' *"togliendo il parziale
si guadagna"*: e' *"togliendo il parziale si guadagna **anche rinunciando al breakeven**"*.
Il confronto era **a sfavore** della cella proposta e ha vinto lo stesso.

**(b) La cella che potrebbe essere la migliore NON E' MAI STATA MISURATA.**
`(ClosePct = 0, BEatR = 1,0)` rimette la protezione **senza chiudere niente** -- ed e'
esattamente la cella `(0, BE)` di **R207b**. Prima di questa lettura era *"una variante";
adesso e' **l'unica cella della tabella che non ha gia' una risposta**.

## 4. UN'ANCORA GRATIS PER R207a

R46 ha girato con `InpTrailMode` a **1 e 0**; la riga vincente e' quella che `r137c` riproduce
con `InpTrailMode = 1` **soltanto**, cioe' **PREVBAR** -- lo stesso valore pinnato in R207a/R207b.

👉 Quindi la cella `(0, 0)` di **R207a deve riprodurre `PF 1,49140 · DD 6,2719 · n 193 ·
Profit 23.607,28`**. E' un'**ancora in piu'**, che il file non aveva: se non la riproduce,
balla un pin e non si legge il resto. *(Chiude anche la riserva sul trailing che la prima
stesura di R207a dichiarava: era infondata, corretta il 22/09.)*

## 5. COSA QUESTO NON DICE
- **Non dice che il breakeven non serve.** Dice che la cella vince **anche senza**. Quanto
  valga il breakeven e' **`[NON MISURATO]`**: lo misura la cella `(0, 1,0)` di R207b.
- **Non si trasferisce alle altre sedie.** Sul **Dow** lo stesso cambio ha **segno OPPOSTO**
  (misurato, dossier `report/ALZARE_IL_PF_2026-09-22.md`). E' una proprieta' del DAX.
- **Non chiude il muro FTMO del 10%**: alla taglia in campo la cella viva sta a **14,50% OOS**,
  e col miglioramento di DD piu' generoso mai misurato atterrerebbe a **~12,6%**, ancora sopra.
- **Non e' una firma mia.** Cambia il profilo di rischio della sedia: decide Claudio.
