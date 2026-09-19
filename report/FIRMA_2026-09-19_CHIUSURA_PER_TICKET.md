# ✍️ FIRMA DEL 19/09/2026 — **la chiusura va per TICKET, non per simbolo**

**Richiesta di Claudio, testuale**: *«Fai la toppa per ticket»*
— scelta l'**opzione 1** fra le tre presentate in `report/DUE_SEDIE_NASDAQ_IL_BLOCCO_2026-09-19.md`.

---

## ① COSA VIENE DECISO

Sostituire le chiamate `CTrade` che prendono il **SIMBOLO** con le equivalenti che prendono il
**TICKET**, a partire dai due siti verificati nel binario in campo di
`ABTG_Nasdaq_Apertura_US.mq5` (`3af47ed9`):

| riga | oggi | domani |
|---|---|---|
| **r.1858** | `gTrade.PositionClose(_Symbol)` — fine sessione | `PositionClose(<ticket della NOSTRA>)` |
| **r.553** | `gTrade.PositionClose(_Symbol)` — flatten notizie *(oggi morto: `InpUseNewsFilter=false`)* | idem |

**Il motivo, misurato**: su conto **HEDGING** `PositionClose(_Symbol)` chiude la posizione **più
vecchia del simbolo, di chiunque sia**. La guardia `SelectMyPosition()` è hedge-safe; l'azione no.

## ② PERCHÉ ADESSO E NON PRIMA — la condizione che è caduta

`report/AUDIT_POSITIONSELECT_HEDGING_2026-09-03.md` lo censisce **dal 3 settembre** (r.39) e
classifica `ABTG_Nasdaq_Apertura_US` 🟠 **proprio su `NASUSD · 770250`** (r.89).
🟢 Era tollerato per **una ragione sola**: su quel simbolo c'era **una posizione sola**, quindi
*«la più vecchia È la nostra»*.
🔴 **Schierare `770260` e `770261` toglie esattamente quella condizione** — classe **441**.

## ③ COSA QUESTA FIRMA **NON** AUTORIZZA

- ❌ **Non autorizza una ricompilazione sul conto REALE `10105439`.** Quel perimetro resta chiuso.
- ❌ **Non tocca nessun parametro di rischio né nessuna taglia.** `InpRiskPercent`,
  `InpTP1_ClosePct` e `InpBreakevenAtTP1` restano come sono.
- ❌ **Non è un via libera ad accendere le due sedie nuove**: quella è una firma separata, e
  arriva dopo che la toppa è in campo.

## ④ LA SEQUENZA, e dove si ferma il mio perimetro

| passo | chi |
|---|---|
| 1. censimento di **tutti** i siti pericolosi in `mql5/Experts/`, ordinati per danno reale | 🤖 in corso |
| 2. scrittura della toppa + i tre contro-esempi *(flatten voluto · firma di `PositionClosePartial` · comportamento su conto **netting**)* | 🤖 in corso |
| 3. **doppio cancello** sulla toppa | 🤖 |
| 4. applicazione al sorgente in repo | 🤖 dopo il PASS |
| 5. 🔴 **ricompilazione (F7) sul terminale `50503392`** | ✍️ **Claudio** |
| 6. verifica che il binario in campo sia cambiato *(righe + data `.ex5`, via `CODA_06`)* | 🤖 |

⚠️ **Il passo 5 è manuale e suo**, e va fatto sul terminale giusto: **50503392**
(`C:\Program Files\BCM Markets MT5 Terminal`). 🔴 **NON** su `-V3` (50504263), **NON** su
`C:\BCM_Reale` (10105439), **NON** su `C:\MT5_Backtest` (50504400).

## ⑤ IL GUADAGNO ATTESO, dichiarato prima
🟢 **Sblocca il round delle due sedie Nasdaq** (era il solo blocco rimasto).
🟢 **E chiude un fail-open che riguarda sette-otto EA**, non uno: secondo l'audit del 03/09 la
stessa riga sbagliata è su più sedie della flotta. **Una passata per tutti.**
🔴 **Costo: [NON MISURATO]** finché il censimento non dice quante ricompilazioni servono.

---
*Verbale di una decisione, non una misura. Fonti: `report/DUE_SEDIE_NASDAQ_IL_BLOCCO_2026-09-19.md` ·
`report/AUDIT_POSITIONSELECT_HEDGING_2026-09-03.md` rr.39 e 89 ·
`ABTG_Nasdaq_Apertura_US.mq5` a `3af47ed9` rr.553 e 1858.*
