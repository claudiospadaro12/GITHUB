# 🛑 LA FIRMA n.2 VA RIVISTA — la cella è un PICCO, e il numero era etichettato male

**Verificato da me alla fonte**, `r88_csv/ABTG_ORB_Ottimizzato_U30USD_OOS_r88a.csv`,
48 righe. Riguarda la firma **n.2 dell'11/09** (geometria OPPRANGE per la `770611`).

> 🔴 **Te l'avevo messa davanti come *"−4,04 punti di DD, già misurati, serve solo
> il tuo sì"*. Due parole su tre erano sbagliate.** Nessuna scusa: i numeri sono
> qui sotto.

---

# ❌ 1. IL NUMERO ERA ETICHETTATO MALE

`9,7623 − 3,8395 = **5,9228**` — **non 4,04.**

Il **−4,04** viene da `6,5389 − 2,4957 = 4,0432`, che è **a taglia 0,65%**.
🔴 E `2,4957` è **`[INFERITO]`**, non misurato: è un riscalaggio lineare — su un
riscalaggio che **lo stesso referto misura non reggere** (predice 6,346 contro
**6,5389** misurato).

👉 **Numero vero, tabella sbagliata.** L'ho appaiato a una tabella @1% in
`FIRME_2026-09-11.md` r.84 e in `PIANO_CHALLENGE_OTTOBRE_v2.md` r.274.

---

# 🔴 2. LA CELLA FIRMATA È UN PICCO — il secondo in un giorno

Cella firmata: `SLMode=0` · **`SLBufferPts=500`** · `TPMode=0` · `TP_R=1.5`.
I suoi **vicini sull'asse del buffer** `[MISURATO]`:

| buffer | Profit | PF | **DD%** | Rec.F. | Sharpe |
|---:|---:|---:|---:|---:|---:|
| 0 | 21.942,40 | 1,76162 | 4,2025 | 4,81220 | 29,509 |
| 🎯 **500** | **23.003,35** | **1,83850** | **3,8395** | **5,54340** | **31,929** |
| 1000 | 16.850,58 | 1,64542 | 4,4027 | 3,54357 | 23,856 |

> ### 🔴 Massimo su Profit, PF, Recovery e Sharpe — e minimo sul DD. **Picco su 5 metriche su 5, coi vicini che scendono da tutte e due le parti.**
> **Regola di casa: centro dell'altopiano, MAI il picco.**

📌 **E il referto firmato lo diceva già**: procedura `P1..P8` → esito **P4,
"nessuna configurazione robusta"**, e al punto 6 **non proponeva di toccare la
sedia**. 🔴 **Sono io che l'ho tirata fuori come azione da firmare.**

---

# 🟢 3. MA LA DIREZIONE È SOLIDA — e questo è il pezzo buono

Non è il **ramo** a essere rumore: è il **punto sull'asse**.

| geometria | celle | banda del DD |
|---|---:|---|
| 🟢 **OPPRANGE** (`SLMode=0`) | **12/12** | **3,70% – 5,87%** |
| 🔴 **HALFRANGE** (`SLMode=3`, quella viva) | **12/12** | **7,96% – 12,02%** |

**Le due bande non si toccano nemmeno.** Dodici celle contro dodici: **quella è
una differenza di meccanismo, non una cella fortunata.**

---

# 🎁 4. L'ALTERNATIVA: **una sola manopola invece di quattro**

`InpSLMode` **3 → 0**, e basta. Niente buffer, niente TPMode, niente TP_R.

| | oggi (HALFRANGE) | **solo SLMode 3→0** |
|---|---:|---:|
| **Drawdown** | 9,7623% | 🟢 **4,2956%** — **meno della metà** |
| **Profit Factor** | 1,67419 | 🟢 **1,68012** — *identico* (+0,006) |
| Profit | 41.057,00 | 🔴 **18.921,52** (−53,9%) |

## 🧪 E soprattutto: **è un ALTOPIANO, non un picco**
Lo stesso blocco al variare del buffer: PF **1,680 → 1,661 → 1,642**, DD
**4,30 → 3,96 → 3,70**. 🟢 **Monotono e piatto.** Niente sporge, niente crolla.

| | cella firmata | **alternativa** |
|---|---|---|
| forma | 🔴 **picco 5/5** | 🟢 **altopiano monotono** |
| manopole da cambiare | **4** | 🟢 **1** |
| DD | 3,8395% | 4,2956% |
| PF | 1,8385 | 1,6801 |

👉 **La cella firmata è "migliore" su tutti i numeri. È esattamente per questo
che non mi fido**: sporge su cinque metriche contemporaneamente e crolla di
fianco. L'alternativa è **peggiore sulla carta e più probabile in campo.**

---

# 🔴 5. DUE COSE DA CHIARIRE PRIMA DI QUALUNQUE GESTO

## 🟠 A. Una contraddizione di perimetro, e la devi sciogliere tu
- `report/FIRME_2026-09-11.md` §2 (scritto da me oggi) dice **conto reale 10105439**;
- `report/PIANO_CHALLENGE_OTTOBRE_v2.md` **A4** dice *"sul conto della challenge,
  **senza toccare il reale 10105439**"*.

**Su quale conto va il cambio?** Finché non lo dici tu, **non si tocca niente**.

## ⚠️ B. Una cosa trovata leggendo il sorgente
Sul reale `InpBreakeven=true` è **un no-op**: `InpTP1Pct=0` fa uscire subito
`ManageTP1()` (r.655-666). 🔴 **Nessuno stop in pari, oggi né dopo il cambio.**
L'unica protezione dinamica è il trailing EMA (`ManageRunner()`, indipendente —
verificato).

---

# ✅ 6. E LA FIRMA n.4 NON SERVE PIÙ: la risposta era in casa

**Il parziale della `770101` è al 50%.** `[MISURATO]` su `trades_auto.csv` e
`trades_100k.csv`, **4 giornate × 2 conti**: con `p=50%` e l'arrotondamento a
pavimento, **7 righe su 8 tornano al centesimo**
(es. 100k 25/08: `3,70 × 42,00 + 3,80 × 65,00 = 402,40` = P/L riportato).

🔴 **E `p=1/3` non è improbabile: è ARITMETICAMENTE IMPOSSIBILE.** Richiederebbe
un parziale a `26271,56` e a `26018,79` — **il D30EUR quota a passi di 0,10:
quei prezzi non esistono.**

📌 **Perché la pagella del 03/09 sembrava tornare**: quella giornata da sola ha
**due incognite e una equazione per conto** → **sei** coppie (lotti, prezzo)
tornano. Ne è stata scelta una e chiamata *"misurato al centesimo su DUE conti"*.
👉 **Nessun gesto manuale: ti risparmio il viaggio al PC.** 😄

---

## 📌 TRE CLASSI NUOVE
- **239** — la finestra Proprietà di un EA vivo si chiude con **Annulla**, mai
  con OK (OK **reinizializza l'EA** sul conto reale).
- **240** — parametro dedotto da **UNA** giornata: due incognite, una equazione,
  sei risposte. Il vincolo che decide è **fisico** (griglia dei prezzi, step del
  lotto), non statistico.
- **241** — delta calcolato a **una taglia** e appaiato alla tabella di **un'altra**.
  Ogni delta porta scritta la taglia e il marchio di ogni addendo.

> ## 🔥 Due picchi intercettati in un giorno, e tutti e due stavano per diventare una decisione. Il metodo funziona — ma tutte e due le volte l'errore l'avevo fatto io per primo.
