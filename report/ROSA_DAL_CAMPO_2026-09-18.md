# 🇪🇺 LA ROSA RIFATTA COL **CAMPO** COME PRIMO CRITERIO

**18/09/2026** · richiesta di Claudio: *«RIFAI LA ROSA COL CAMPO COME PRIMO CRITERIO»*
Fonte: `ReportHistory-50503392.xlsx` — **231 posizioni chiuse**, **29/07 → 18/09** (7 settimane),
conto demo **50503392**. Strumento: `backtest_pipeline/classifica_report_mt5.py` (rieseguibile).

---

# 0. 🧊 I CRITERI, CONGELATI PRIMA DI GUARDARE I NUMERI

| # | criterio | soglia |
|---|---|---|
| **C1** | 🥇 **CAMPO** — netto in forward della **FAMIGLIA-MOTORE** | positivo = candidata |
| **C2** | **CAMPIONE** — quante operazioni ha quel netto | **n ≥ 20** ⇒ il criterio di MERITO del 18/08 può parlare. **n < 20** ⇒ il campo è un **segnale**, non un verdetto |
| **C3** | **RISCHIO** — i cancelli congelati **non si muovono** | DD, cap C1 3,25%, muro giornaliero |
| **C4** | **COSTO** — `stop >= 40 x spread` | invariato ⚠️ e **in due unità**, vedi §5 |
| **C5** | **BACKTEST** | scende a **corroborazione**, non è più il cancello d'ingresso |

🔴 **E il limite dichiarato prima di tutto**: il campione più grande è **32 operazioni**,
il tipico è **5-15**. Sette settimane, **un solo regime**. Il conto è il **piccolo**, con
taglie diverse dal 100k. 👉 **Il campo dice la DIREZIONE, non la misura.** Chi legge questa
rosa come una classifica definitiva la sta leggendo male.

---

# 1. 🏆 LA ROSA NUOVA — famiglie ordinate per netto sul campo

| # | famiglia-motore | **n** | **netto EUR** | vinte/perse | EUR/lotto | lettura |
|---:|---|---:|---:|---:|---:|---|
| **1** | **`MaxMinNotte`** | 16 | **+199,07** | 11/5 | +31,55 | 🟢 miglior netto, campione medio |
| **2** | **`SuperWave`** | 26 | **+172,10** | 10/12 | +50,62 | 🟢 **n≥20**, e il dettaglio è la notizia (§2) |
| **3** | **`EasyTrend`** | 13 | **+147,30** | 6/7 | **+66,35** | 🟠 netto alto con metà operazioni perse |
| **4** | **`Nasdaq_Apertura_US`** | 10 | **+144,83** | **9/1** | +26,82 | 🟢 **il miglior RECORD della rosa** |
| **5** | `DAX_Live5m` | 12 | +46,85 | 6/6 | +1,76 | 🟠 netto che sparisce per lotto |
| **6** | `SupertrendReversal` | 18 | +32,04 | 5/11 | +5,61 | 🟠 positivo con **11 perse su 18** |
| **7** | `PunteLarry` | 14 | +23,10 | 7/7 | +10,74 | 🟠 |
| **8** | **`DAX_Apertura_EU`** | 25 | **+2,62** | **22/3** | +0,12 | 🟠 **n≥20**: quasi pari, ma 22 vinte su 25 (§2) |
| **9** | `Dow_Apertura_US` | 4 | +0,35 | 3/1 | +0,29 | ⚪ campione troppo sottile |
| — | `PTE` · `BreakingBand` · `Nightly` · `PostNews` | 1-4 | ≈ 0 | | | ⚪ non misurabili |
| **🔴** | **`EMA200`** | **32** | **−127,37** | **15/16** | −25,42 | 🔴 **vedi §3** |
| 🔴 | `CostToCost` | 13 | −127,68 | 6/7 | −58,30 | 🔴 in perdita |
| 🔴 | `GapFill` | 7 | −151,47 | 3/4 | −13,80 | 🔴 in perdita |
| 🔴 | `Apertura Marco` | 6 | −172,98 | 4/2 | −28,83 | 🔴 perde pur vincendo 4 su 6 |
| 🔴 | **`ORB`** | **15** | **−295,58** | **3/12** | −22,91 | 🔴 **il peggiore**, 12 perse su 15 |

---

# 2. 🔥 LE DUE COSE CHE IL CAMPO DICE E IL BACKTEST NON DICEVA

## ① `SuperWave`: **tutti gli SHORT guadagnano, tutti i LONG perdono**

| variante | netto | n |
|---|---:|---:|
| `SUPERWAVE DOW H1 S 2/3` | **+165,57** | 3 |
| `SUPERWAVE DOW H1 S 1/3` | **+88,55** | 3 |
| `SW DOW H2 S 1/3` | **+41,40** | 4 |
| `SW DOW H2 S 2/3` | **+41,34** | 4 |
| `SUPERWAVE DOW H1 L 2/3` | −0,70 | 2 |
| `SUPERWAVE DOW H1 L 1/3` | −8,48 | 2 |
| `SW DOW H2 L 1/3` | **−62,19** | 3 |
| `SW DOW H2 L 2/3` | **−62,23** | 3 |

> ## 🟢 **Quattro varianti SHORT su quattro positive (+336,86). Quattro LONG su quattro negative (−133,60). Zero eccezioni.**

⚠️ Campioni da 2-4 operazioni: **non è una prova, è il segnale più pulito della rosa.**
👉 E si aggancia a una misura che abbiamo già: su EURUSD H4 in archivio il **long fa 0/28
positive** e lo **short 26/26**. **Due strumenti diversi, stessa forma.**

## ② `DAX_Apertura_EU`: la variante **RETEST** vale 317 euro più della base

| variante | netto | n |
|---|---:|---:|
| `DAX Apertura EU RETEST` | **+149,16** | **15** |
| `DAX Apertura EU OTT` | +21,70 | 4 |
| `DAX Apertura EU` (base) | **−168,24** | 6 |

👉 **La famiglia nel suo insieme fa +2,62 e sembra piatta. Non lo è: dentro ci sono una
variante che vince 14 volte su 15 e una che perde.** Leggere la famiglia senza aprire le
varianti avrebbe nascosto la cosa migliore della rosa.

---

# 3. 🚨 IL VERDETTO CHE IL CAMPO IMPONE: **`EMA200` fa scattare il criterio del 18/08**

Il criterio di uscita congelato da Claudio il 18/08 dice, testuale:
> *«MERITO (per famiglia, a 20 operazioni): famiglia a 20+ op totali in perdita → revisione
> di tutte le sedie; **si spegne la SEDIA colpevole**, la gemella positiva resta.»*

> ## 🔴 **`EMA200`: n = 32, netto −127,37, 15 vinte e 16 perse. È l'UNICA famiglia con n≥20 in perdita di tutta la rosa. Il criterio SCATTA.**

| variante | netto | n | |
|---|---:|---:|---|
| `EMA200 DOW L2` | **+27,12** | 5 | 🟢 la gemella positiva |
| `EMA200 OTT S2` | +9,77 | 2 | 🟠 |
| `EMA200 DOW S2` | −4,56 | 3 | |
| `EMA200 OTT L2` | −6,06 | 2 | |
| `EMA200 DOW S1` | −18,01 | 6 | 🔴 |
| `EMA200 S2` | −21,89 | 1 | |
| `EMA200 DOW L1` | **−23,94** | 7 | 🔴 |
| `EMA200 OTT S1` | −26,23 | 2 | |
| `EMA200 S1` | −31,72 | 1 | |
| `EMA200 OTT L1` | **−31,85** | 3 | 🔴 |

🔴 **E questo è il motore su cui la rosa precedente aveva la SECONDA sedia (`771531`), e
su cui è stata spesa l'intera giornata di oggi** (AUDJPY, GBPUSD, EURUSD).
🟢 **Coerenza che vale**: stamattina AUDJPY e GBPUSD sono morti su 16,5 anni di storico.
**Il campo, in sette settimane e in totale indipendenza, dice la stessa cosa.** Due misure
che non si parlano e concordano valgono più di una che urla.

⚠️ **Ma non promuovo e non spengo io**: il criterio dice *«revisione»*, e le sedie in campo
si toccano con una firma. Qui si porta il numero, la decisione è di Claudio.

---

# 4. 🎯 LA ROSA CHE PROPONGO, in tre fasce

## 🥇 FASCIA A — **candidate vere**, campo positivo con il record migliore
1. **`Nasdaq_Apertura_US`** — **9 vinte su 10**, +144,83. Il record più pulito della rosa.
2. **`DAX_Apertura_EU` variante RETEST** — **14 su 15**, +149,16, **n=15 è il campione più grande di una singola variante positiva**.
3. **`MaxMinNotte`** — +199,07 su 16, 11/5. Miglior netto assoluto.

## 🥈 FASCIA B — **il segnale c'è, il campione no**
4. **`SuperWave` SOLO LATO SHORT** — +336,86 su 12 operazioni, 4 varianti su 4 positive.
   👉 **La mossa non è schierarlo: è MISURARLO**, ed è lo stesso disegno già pronto per EURUSD.
5. `EasyTrend` · `PunteLarry` — netti alti, record 6/7 e 7/7: **metà perse**. Servono numeri.

## 🔴 FASCIA C — **fuori dalla rosa, col numero accanto**
- **`ORB`** −295,58 su 15, **3 vinte su 15** — ed è la sedia `770611`, in rosa fino a ieri.
- **`EMA200`** −127,37 su 32 — criterio del 18/08 scattato (§3).
- `CostToCost` −127,68 · `GapFill` −151,47 · `Apertura Marco` −172,98.

---

# 5. ⚠️ COSA **NON** CAMBIA, e va detto perché la rosa nuova non lo risolve

- 🔴 **I cancelli di RISCHIO e di COSTO restano quelli congelati.** Il campo può dire *chi
  guadagna*; **non può dire se sopravvive a un muro giornaliero del 4%**.
- 🔴 **Il cancello di costo è ancora in DUE UNITÀ** (spread o costo pieno): finché non è
  firmato, `R5` non si può applicare in modo coerente a nessuna di queste famiglie.
- 🔴 **Il Guardian, coi numeri di oggi, arriverebbe DOPO la prop** su un muro al 4%.
  Nessuna sedia di questa rosa è schierabile finché quel numero non è firmato.
- ⚠️ **La frequenza**: 231 posizioni in 7 settimane su ~37 giorni feriali = **~6,2
  posizioni/giorno di CONTO**, ma distribuite su 80 varianti. Il pavimento per FAMIGLIA
  va ricalcolato sulla rosa nuova: **non l'ho fatto in questo giro**.

---

# 6. 🕳️ BUCHI DICHIARATI

- **Attribuzione per COMMENTO, non per magic**: due EA con lo stesso commento finiscono
  insieme. **6 posizioni su 231 non attribuite.**
- **Il conto è il piccolo `50503392`**, con taglie da 0,01 a 3,8 lotti (**380×**). Il netto
  in euro **non è confrontabile fra famiglie**; per questo c'è la colonna EUR/lotto, che
  **cambia l'ordine** (vedi `CLASSIFICA_CAMPO_50503392_2026-09-18.md`).
- **Un solo regime, sette settimane.** Nessuna di queste famiglie ha visto un crollo.
- **Nessun DD per famiglia calcolato qui**: servirebbe la curva di equity per magic, e il
  report non ha il magic.
- **Nessuna sedia promossa o spenta da questo documento.** È una fotografia con dei
  criteri dichiarati sopra, non un cancello.

---

*Rosa rifatta il 18/09/2026 col campo come primo criterio. I criteri sono al §0, scritti
prima dei numeri. Dove una misura non esiste, qui è scritto.*
