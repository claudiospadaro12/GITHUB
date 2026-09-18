# 🎚️ «PIÙ LOTTI CHE POSSIAMO» — ma le nostre sedie **non si tarano a lotti**

**18/09/2026** · nasce da Claudio: *«Facciamo più lotti che possiamo»* · *«Ma sono bassi.
Io pensavo su dax 10 lotti, oro 3 lotti ecc ecc»*

> ## 🟢 **LA NOTIZIA BUONA È CHE LA MANOPOLA C'È GIÀ, ED È UNA SOLA PER SEDIA.** Non dobbiamo inventare un dimensionatore: tutte e quattro le sedie della rosa calcolano il lotto **da sole**, partendo da `InpRiskPercent` e dalla distanza dello stop. Il lotto non è un input: è un **risultato**.

---

## ① IL FATTO, verificato nel sorgente di tutte e quattro

| magic | EA | riga del sorgente | manopola |
|---|---|---|---|
| `770201` | `ABTG_Nasdaq_Apertura_US.mq5` | r.260 | `InpRiskPercent` — *«Rischio per trade in %»* |
| `770511` | `ABTG_SuperWave.mq5` | r.89 | `InpRiskPercent = 1.0` — *«rischio per trade in % (sull'intera size)»* |
| `770402` | `ABTG_MaxMinNotte.mq5` | r.171 | `InpRiskPercent = 2.0` — *«piano: 2%»* |
| `770101` | `ABTG_DAX_Apertura_EU.mq5` | r.313 | `InpRiskPercent` — *«contratto sedia: 1,0 — tetto A4: mai sopra 1»* |

**E il campo lo conferma**: la stessa sedia `770101` ha operato con lotti da **0,90 a 2,70**
sullo stesso simbolo. Non è incoerenza — è il dimensionatore che lavora: **quando lo stop è
stretto il lotto cresce, quando è largo cala, e la perdita resta la stessa.**

👉 Quindi *«DAX 10 lotti»* non è un parametro che si scrive da nessuna parte. Si scrive
**una percentuale**, e i 10 lotti escono (o non escono) a seconda di quanto è lontano lo stop
quel giorno. 🔴 **E `InpRiskPercent` è firma di Claudio, non mia** (mandato 08/09).

---

## ② LA PROVA CHE IL DIMENSIONATORE FUNZIONA — i sette stop del DAX

Sette stop in perdita di `770101`, dal 23/07 al 14/08. Lotto e perdita, affiancati:

| chiusura | lotto | perdita |
|---|---:|---:|
| 2026.07.23 13:39 | 0,90 | 114,30 |
| 2026.07.29 13:01 | 1,60 | 115,04 |
| 2026.07.29 13:01 | 1,60 | 120,80 |
| 2026.07.29 13:16 | 1,60 | 115,04 |
| 2026.08.06 09:11 | 0,90 | 102,96 |
| 2026.08.10 09:00 | 1,70 | 101,83 |
| 2026.08.14 09:17 | 2,00 | 104,60 |

> ## ✅ **Il lotto varia di 2,2 volte (0,90 → 2,00). La perdita varia dell'11% (101,83 → 120,80).** È esattamente il comportamento che deve avere un dimensionatore a rischio. Funziona.

---

## ③ 🔴 E IL CAMPO HA CONFERMATO, DA SOLO, IL BUG C4 DEL 02/09

Ricostruito il saldo al momento di ogni stop (ancora: bilancio **5.129,30 €** del
`ReportTrade50503392.xlsx` timbrato 2026.09.09 09:04, più il P/L cumulato del CSV a ritroso):

| chiusura | perdita | saldo ricostruito | **= % del saldo** |
|---|---:|---:|---:|
| 2026.07.23 | 114,30 | 5.738,16 | **1,992%** |
| 2026.07.29 | 115,04 | 5.588,55 | **2,058%** |
| 2026.07.29 | 120,80 | 5.346,95 | **2,259%** |
| 2026.07.29 | 115,04 | 5.231,91 | **2,199%** |
| 2026.08.06 | 102,96 | 5.484,63 | **1,877%** |
| 2026.08.10 | 101,83 | 5.265,87 | **1,934%** |
| 2026.08.14 | 104,60 | 5.147,81 | **2,032%** |

**Sette su sette fra 1,88% e 2,26%.** Il contratto di quella sedia dice **1,0%**.

🟢 **Ma non è una ferita aperta: è il FIX C4 che si vede in campo.** Il sorgente lo dice
a `ABTG_DAX_Apertura_EU.mq5` **r.90**: *«02/09: era 2.0. Il default compilato era il DOPPIO
del contratto (1,0%) e della riga rossa A4: ogni RIPRISTINA rimetteva il 2%. FIX firmato C4.»*
Commit `9638318f`. **Tutti e sette gli stop sono PRIMA del 02/09.**

> ## 🟢 **E questo vale più di quanto sembri: è una verifica INDIPENDENTE del bug.** Il C4 è stato trovato leggendo il codice. Qui è uscito dai P/L veri, senza sapere che il codice lo prevedesse — due strade diverse, stesso numero. **Il fix era reale e ha funzionato.**

### 🧪 Il contro-esempio, perché il 2% non è un artefatto della mia ricostruzione
L'ipotesi alternativa è: *«il saldo di luglio era il doppio, quindi era davvero l'1%»*.
Non regge, ed è aritmetica: fra il 23/07 e il 09/09 il P/L cumulato del conto si muove di
**−608 €**. Perché il saldo fosse ~11.000 in luglio e 5.129 in settembre servirebbe un calo
di ~5.400 € che **nei trade non c'è**. Su un demo senza prelievi, l'alternativa è impossibile.

---

## ④ IL RISCHIO **REALIZZATO**, sedia per sedia — ed è qui che si decide

| magic | sedia | contratto nel preset | **realizzato in campo** | |
|---|---|---:|---:|---|
| `770101` | DAX Apertura | 1,0% (era 2,0 fino al 02/09) | **~2,03%** (n=7) | 🟠 spiegato dal C4 |
| `770402` | MaxMin ORO | 1,0% | **~0,55%** (n=2) | 🟠 campione da 2 |
| `770511` | SuperWave DOW | 1,0% | **~0,13%** (n=4) | 🔴 **otto volte sotto** |
| `770201` | Nasdaq Apertura | **2,0%** nel `.set` | **MAI STOPPATA** | 🔴 **non misurabile** |

### 🔴 Due cose qui non tornano, e tutte e due contano per la challenge

**(a) `770511` realizza lo 0,13% contro un contratto dell'1,0%.** Otto volte meno.
👉 **È la sedia con più margine di tutte** — ma prima di alzarla va capito *perché* è così
bassa: se il dimensionatore la sta strozzando per un motivo (lotto minimo, distanza di stop,
un cap), alzare `InpRiskPercent` non farà niente. **Misura da fare, non conclusione.**

**(b) `770201` non è mai stata stoppata in perdita: 10 posizioni, 10 vinte, ZERO perse.**
👉 Il suo drawdown per lotto **non esiste nei dati di campo**. È esattamente il buco che
l'agente sta misurando adesso col p99 per riordino — e adesso sappiamo **perché** quel numero
mancava: non è una svista d'archivio, **è che il campo non ha mai prodotto il dato**.
⚠️ E il suo preset `mql5/Presets/ABTG_Nasdaq_Apertura_US.set` porta `InpRiskPercent=2.0`,
**il doppio delle altre tre** e sopra il tetto A4 citato nel sorgente del DAX.

---

## ⑤ 🔴 UNA CORREZIONE ALLA SELEZIONE DI UN'ORA FA

`report/LE_SEDIE_PER_LA_PROP_2026-09-18.md` mette fra i criteri **«un solo simbolo»** e lo
applica anche a `770101`. **È falso**: `770101` ha **38 posizioni su D30EUR e 1 su NASUSD**.

Una posizione su 39 non cambia il giudizio sulla sedia, **ma cambia il criterio**: se
«un solo simbolo» è un cancello, allora `770101` non lo passa e va detto. *(Il criterio
resta pienamente vero per `770201`, `770511` e `770402`.)*

---

## ⑥ COSA RESTA DA MISURARE PRIMA DI TOCCARE UNA TAGLIA

1. ⏳ **p99 del DD di `770201`** — in corso. Senza, il Nasdaq è la sedia col record migliore
   e **il rischio ignoto**.
2. 🔎 **Perché `770511` realizza 0,13% invece di 1,0%.** Finché non si sa, «alziamola» è un
   auspicio, non una leva.
3. 📐 **Quale preset è davvero in campo per `770201`** — la lezione `EMA200` (il binario del
   04/08 senza Guardian) dice che il repo e il VPS possono non combaciare. Il 2,0% nel `.set`
   va verificato sul terminale **50503392 (`BCM Markets MT5 Terminal`)**, in sola lettura.
4. ✍️ **E poi firma Claudio.** `InpRiskPercent` è suo, per mandato.

---

## 📌 In una riga
**Non si mettono più lotti: si alza una percentuale, e i lotti seguono.** Il dimensionatore
funziona (provato sui sette stop del DAX), il bug che raddoppiava il rischio era reale ed è
stato chiuso il 02/09 (riconfermato qui dai P/L veri), **ma due delle quattro sedie hanno un
rischio realizzato che non somiglia al contratto** — e una delle due non è mai stata stoppata.
🔴 **Alzare una taglia sopra un numero che non abbiamo misurato sarebbe il modo più veloce di
ripetere il 18 settembre.**

---
*Fonti: `data/statements/trades_auto.csv` (piccolo 50503392, dichiarato in
`backtest_pipeline/pubblica_trades.ps1` r.9) · i quattro sorgenti `.mq5` e i quattro `.set`
citati per riga · `report/PICCOLO_50503392_2026-09-09.md` r.10 per l'ancora di bilancio ·
commit `9638318f` per il fix C4.*
