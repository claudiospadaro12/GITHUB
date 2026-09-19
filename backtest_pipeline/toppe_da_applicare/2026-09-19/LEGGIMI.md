# 🔧 I TRE SORGENTI PATCHATI — chiusura per TICKET

**19/09/2026** · firma: `report/FIRMA_2026-09-19_CHIUSURA_PER_TICKET.md`

## COSA SONO
I tre `.mq5` del binario **in campo** (`3af47ed9`, 08/08/2026) con la chiusura di fine sessione
cambiata da **simbolo** a **TICKET**. Sono file **finiti**, non diff: non c'è nessuna base da
sbagliare (classe **449**).

| file | base `3af47ed9` | patchato | delta |
|---|---:|---:|---:|
| `ABTG_Nasdaq_Apertura_US.mq5` | 2032 | **2090** | +58 |
| `ABTG_DAX_Apertura_EU.mq5` | 2132 | **2190** | +58 |
| `ABTG_Dow_Apertura_US.mq5` | 2064 | **2122** | +58 |

🟢 **Delta identico su tutti e tre**: è la firma di una toppa meccanica.

## PERCHÉ
Su conto **HEDGING** `gTrade.PositionClose(_Symbol)` chiude la posizione **più vecchia del
simbolo, di chiunque sia** — anche di un altro magic. Censito dal **03/09**
(`report/AUDIT_POSITIONSELECT_HEDGING_2026-09-03.md` rr.39 e 89), tollerato finché su quel
simbolo c'era **una posizione sola**. Accendere una seconda sedia toglie quella condizione
(classe **441**).

## 🖥️ BERSAGLIO — e solo quello
Terminale **50503392**, `C:\Program Files\BCM Markets MT5 Terminal`.
🔴 **NON** `-V3` (50504263) · **NON** `C:\BCM_Reale` (**10105439**) · **NON** `C:\MT5_Backtest`
(50504400). La firma li esclude **per nome**.

## ⚠️ PRIMA DI SOSTITUIRE
🔴 **Controlla che il file che stai per sostituire sia davvero il vintage giusto**: apri il
`.mq5` che c'è ora in MetaEditor e guarda il **numero di righe in fondo** — deve essere
**2032 / 2132 / 2064**. Se è un altro numero, **fermati**: quel terminale ha un binario diverso
da quello censito il 18/09, e la toppa va rifatta su quella base.

## 🔴 E UNA COSA DETTA PRIMA, NON DOPO
**Qui non c'è MetaEditor: questi tre file non sono MAI STATI COMPILATI.** La correttezza è
argomentata (API esistenti, stessa forma già in campo su `ABTG_ORB_Ottimizzato` v1.04), non
collaudata. 👉 **Il primo F7 è anche il primo vero test di compilazione.** Se dà errore, non è una
sorpresa: è il collaudo che fa il suo lavoro.

## DOPO
Il runner delle 03:30 rilegge i sorgenti (`CODA_06`): la notte dopo il referto deve mostrare
**2091 / 2191 / 2123** al posto di 2033 / 2133 / 2065. **È la verifica che la toppa è entrata.**

> 🔴 **ATTENZIONE AL RIGHELLO — correzione del 19/09 sera (classe 456).** Qui c'era scritto
> *«2090 / 2190 / 2122 al posto di 2032 / 2132 / 2064»*: sono i numeri di `wc -l`, **non** quelli
> che stampa `CODA_06`. Quel referto conta le righe con
> `@($t -split "\`r?\`n").Count`, che dà **sempre UNO IN PIU'** di `wc -l` — verificato sui due
> casi possibili: file che finisce con a capo (`"a\nb\n"` → 3 contro 2) e file che non ci
> finisce (`"a\nb"` → 2 contro 1). **Non esiste il caso in cui i due righelli coincidano.**
> 👉 Chi verificasse con i numeri vecchi concluderebbe che **la toppa NON è entrata**, mentre
> è entrata benissimo. Le righe vere dei tre file patchati, con `wc -l`, sono
> **2090 Nasdaq · 2190 DAX · 2122 Dow**.
