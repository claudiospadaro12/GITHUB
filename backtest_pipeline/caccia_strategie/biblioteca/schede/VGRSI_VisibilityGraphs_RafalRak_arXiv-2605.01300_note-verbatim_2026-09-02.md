# 📄 SCHEDA — `VGRSI` · Visibility Graphs Relative Strength Index

**Note VERBATIM dal paper, prese il 02/09/2026.** Servono a non dover
ri-scaricare 5,7 MB di PDF e a non far divergere una citazione riassunta.

```
TITOLO      Visibility graphs can make money in financial markets
ARXIV       2605.01300v1  [cs.CE]   --  https://arxiv.org/abs/2605.01300
PUBBLICATO  02/05/2026
AUTORE      Rafal Rak
            Institute of Physics, Faculty of Exact and Technical Sciences,
            University of Rzeszow, Pigonia 1, 35-310 Rzeszow, Polonia
LETTO       PDF scaricato il 02/09/2026: 5.756.634 byte, 16 pagine.
            Letto per intero (Abstract, Methods, Interpretation, Results,
            Discussion). Estrazione testo con pdftotext -layout, 555 righe.
ETICHETTA   [VERIFICATO -- PDF aperto e letto, non ricerca testuale]
```

🔴 **LICENZA — la riga che decide cosa si può fare.** Nota 1, pag. 3, verbatim:

> _"The VGRSI indicator is an original authorial concept introduced in this
> paper; the author reserves all rights to its use."_

**Nessuna licenza aperta. Nessun repository. Nessun sorgente pubblicato.**
Il paper pubblica **la formula per intero** (ed è implementabile). Uso interno
di ricerca: si fa, citando l'autore in testa a qualunque sorgente derivato.
Qualunque cosa oltre: si chiede prima.

---

## 1. Le citazioni che contano, in ordine di peso

### 1.1 🔴 LA RI-OTTIMIZZAZIONE SETTIMANALE — il fatto che svaluta tutti i numeri

§Results, punto (4):

> _"The EA performed simulations with a given set of parameters in a 30-day
> window. **It then selected the parameter set that was best in terms of profit**
> and executed trades over the following 7 days. For example, the EA tested
> parameters from January 1, 2024, to January 30, 2024, and then traded over the
> period from January 31, 2024, to February 6, 2024. ... In the next step, the
> 30-day test window was shifted by 7 days, and this procedure was repeated
> throughout the 2024-2025 period."_

👉 **Sono ~104 scelte del PICCO su finestre di 30 giorni.** In casa la regola è
**centro dell'altopiano, MAI il picco**, e il motivo è misurato: **12 Spearman
IS→OOS negative su 13**, l'ultima (R58) a tick reali sul nostro broker.
🔴 **Il paper non riporta NESSUN risultato a parametri fissi.**

§Discussion, l'autore stesso sulla scelta delle finestre:

> _"the walk-forward scheme applied here was based on a 30-day training window
> and a 7-day trading window. **Both of these intervals were chosen
> arbitrarily**, and their optimisation or adjustment to the characteristics of a
> given instrument may potentially increase the profits obtained."_

### 1.2 🟢 LA FREQUENZA — il motivo per cui il candidato esiste

§Discussion + Tabella 1:

> _"high profits were achieved with a relatively small number of trades — on
> average about **3.3-4.8 trades per day** (Table 1)."_

| strumento | trade/giorno | trade totali | long (min/max/media) | short (min/max/media) | Sharpe | max DD | profitto |
|---|---:|---:|---|---|---:|---:|---:|
| **DJI30** | **3,5** | 1.842 | 0 / 32 / **10** | 0 / 29 / **8** | 3,6 | **18%** | 146.000 USD |
| **EUR/USD** | **3,3** | 1.677 | 0 / 40 / **7** | 0 / 39 / **9** | 2,55 | **12%** | 69.000 USD |
| **XAU/USD** | **4,8** | 2.418 | 0 / 55 / **18** | 0 / 45 / **6** | 3,20 | **10%** | 125.000 USD |

_(min/max/media sono per finestra rotolante di 7 giorni; Sharpe e DD sono medie
su tutte le finestre. **Tutti [DICHIARATI DALL'AUTORE], nessuno verificato, e
tutti prodotti dalla ri-ottimizzazione del §1.1.**)_

🎯 **Il numero che vale davvero è la colonna dei LATI: su EUR/USD gli short sono
PIÙ dei long (9 contro 7).** La flotta viva di casa è quasi tutta long-only.

### 1.3 L'ambiente di prova — ed è il nostro

§Results, punto (1):

> _"All calculations and simulations were performed on the publicly available
> **MetaTrader 5** platform using its built-in automated trading system (Expert
> Advisor, EA). All scripts were written in the dedicated programming language
> **MQL5** and Python. The tests were carried out on a demo account provided by
> the broker, which accurately replicates the historical prices of financial
> instruments traded on the FOREX market, as well as the rules of order execution
> (**bid/ask quotations, spreads, and commissions**)."_

§Results, punto (3): _"**All transaction costs were included in the tests.**"_

⚠️ **Il broker non è nominato**, quindi lo spread che ha pagato è `[IGNOTO]`.
È il motivo per cui il criterio V2 della sonda resta un cancello vero.

### 1.4 I vincoli operativi — e sono la ragione per cui 3-5/giorno è credibile

§Results, punto (5):

> _"For each instrument, the EA was initialised with a portfolio value of USD
> 10,000. The drawdown was always calculated relative to this amount. To avoid
> excessive risk, the EA could have **at most two open positions** within a single
> instrument. In addition, a **minimum time interval between consecutive trade
> entries was introduced (30 minutes)**. In all simulations, a leverage of 1:100
> was assumed."_

👉 Tetto teorico con questi vincoli: 48 trade/giorno. Misurato: 3-5.
**Il numero non è gonfiato dai vincoli: è quello che il segnale produce.**

§Results, punto (6): _"The investment value for a single trade was **fixed** for
each instrument and amounted to approximately **USD 1,000**"_ → 🔴 **lotto fisso,
~10% di nozionale su 10k. Gestione da rifare per intero.**

### 1.5 Lo stop — e c'è, ed è volatility-adaptive

§Results, punto (7):

> _"For each open position, the **Stop Loss (SL) and Take Profit (TP) were set
> symmetrically** at the moment of opening the trade. The EA analysed the most
> recent **N candle heights** (bearish and bullish), determining the **median of
> their heights** measured in points. The resulting value, multiplied by the total
> number **Z**, defined the levels of SL and TP. The values of N and Z were
> parameters tested by the EA."_

👉 **RR = 1,00 esatto per costruzione** → cancello H8: serve `p ≥ 1,075/2` =
**53,75%** di win rate. Passa l'aritmetica, ma non con abbondanza.

### 1.6 🔴 Il grilletto — e l'ambiguità che NON ho potuto sciogliere

§Results, punto (8):

> _"**The opening of a position was based solely on the indicator VGRSI_rA(t).**
> In the simulations, a configuration based on three time intervals of the asset
> price was used for the indicator: **1 minute (M1), 5 minutes (M5) and 30 minutes
> (M30)**. For each interval, the VGRSI calculations depend on two structural
> parameters: Window Size (WS) and Window Visibility (WV); both parameters were
> tested in the range of **10 to 200 candles** backward for each time scale. For
> **long positions (buy), the threshold** for both variants of VGRSI_rA(t) **was
> tested in the range 20-35**, while for **short positions (sell), it was tested in
> the range 70-95**. **Crossing the relevant threshold from above on all time
> scales** triggered the opening of the corresponding position, provided that the
> additional constraints were satisfied."_

🔴 **`[INCERTO]`** — _"from above"_ per **entrambi** i lati descrive un motore di
**mean reversion simmetrico** (long sotto ~30, short sotto ~80). L'alternativa
(long che incrocia 20-35 **dal basso**, come l'RSI classico) non è esclusa dal
testo in modo definitivo. **Il criterio V4 della sonda misura entrambe le letture
e dichiara quale si usa per il verdetto.**

🟢 **"based solely on the indicator"** = il filtro **È** il motore. È la forma
`ABTG_EMA200` del §5B di `ROBUSTEZZA.md` (30 celle su 30 a PASS pieno), non la
forma "filtro appiccicato dopo" (0 successi su 5).

### 1.7 L'affermazione forte dell'autore sul non essere trend-following

§Results:

> _"For EUR/USD, a clear multi-month decline in price is observed, while the
> cumulative profit curve continues to rise. ... This suggests that VGRSI does not
> operate merely as a simple trend-following indicator but captures more subtle
> local and global market structures, making it possible to take profitable
> positions **regardless of the prevailing trend**."_

⚠️ `[DICHIARATO DALL'AUTORE]`. E va letto ricordando il §1.1: una curva che sale
mentre lo strumento scende **è compatibile anche** con una ri-ottimizzazione
settimanale che insegue il regime. **Non è una prova di scorrelazione: è una
promessa da verificare.**

---

## 2. La formula, per intero — §Methods, pagg. 3-5

Due parametri strutturali: **WS** (Window Size, quanto si aggrega) e **WV**
(Window Visibility, quanto indietro si guarda).

**Passo 1 — visibilità all'indietro.** Per ogni `j ∈ {t−WS+1, …, t}` si
considerano gli indici passati `i ∈ {j−1, j−2, …, max(0, j−WV)}`. Il punto
`(i, p_i)` è **visibile** da `(j, p_j)` se, per ogni `k` con `i < k < j`:

```
p_k  <  p_j + (p_i − p_j)/(i − j) · (k − j)
```

L'insieme dei visibili è `V_j`; se ne usano al massimo WS (`|V_j^(WS)| ≤ WS`).

**Passo 2 — dai punti ai segni.** `Δp_i = p_i − p_(i−1)`.
⚠️ **Dettaglio che il paper dichiara esplicitamente e che si sbaglia facilmente:**

> _"Visibility determines only **which indices i are selected** as relevant for a
> given j; the change Δp_i itself **always refers to the neighbouring pair
> (i−1, i)**, regardless of whether the point i−1 is visible from j."_

```
S+(t) = Σ_j Σ_{i ∈ V_j^(WS)} (+Δp_i)   per Δp_i > 0
S−(t) = Σ_j Σ_{i ∈ V_j^(WS)} (−Δp_i)   per Δp_i < 0
N+(t) = # dei contributi con Δp_i > 0
N−(t) = # dei contributi con Δp_i < 0
```

**Passo 3 — due forze relative:** `rS = S+/S−` (ampiezza) · `rN = N+/N−` (frequenza).

**Passo 4 — due varianti:** `rA0 = ½(rS + rN)` · `rA1 = rS/rN`.

**Passo 5 — normalizzazione:** `VGRSI_rA(t) = 100 − 100/(1 + rA(t))`.

**Interpretazione dell'autore** (§Interpretation): **A0** = filtro di
**trend/persistenza**; **A1** = misura di **impulso/rottura**, più sensibile ai
fakeout. `A1 alto + A0 basso` = impulso senza struttura. `A1 alto + A0 in salita`
= impulso che diventa trend. `A0 alto + A1 moderato` = trend stabile.

**Valori d'esempio del paper:** Fig. 1 con `WS = WV = 35` → VGRSI_rA0 = 60,1.
Fig. 2 su XAU/USD con `WS=20, WV=40, A0` e `WS=15, WV=100, A1`.

🔧 **Vincolo di calcolo (calcolo mio, non dell'autore):** la forma ingenua è
`O(WS · WV²)` per barra — con WS=WV=35 sono ~43.000 confronti/barra, cioè ~6,4e9
su 150.000 barre M5: **non gira**. Serve la forma **incrementale** (un solo set
di visibilità nuovo per barra, `O(WV²) ≈ 1.200`, più una coda delle ultime WS
barre) → ~1,8e8 su 150.000 barre: gira.

---

## 3. Cosa terrei e cosa rifarei

| | |
|---|---|
| 🟢 **IL MOTORE, che terrei** | l'indicatore VGRSI: **decide solo lui**, non ha look-ahead possibile (usa **solo** punti passati per definizione), è a **due lati**, e lo stop è **volatility-adaptive** (mediana altezza candele × Z), non a pip fissi |
| 🔴 **LA GESTIONE, che rifarei per intero** | lotto **fisso** ~1.000 USD → **rischio in % dell'equity (0,65%)** · nessun cap giornaliero → **cap sui dati**, dal massimo di segnali in una giornata misurato dalla sonda · DD dichiarato 10-18% contro il muro prop del 10% |
| 🔴 **IL METODO, che NON importerei mai** | la **ri-ottimizzazione ogni 7 giorni sul picco dei 30 precedenti**. È la cosa che i nostri 13 Spearman dicono di non fare. **Noi congeliamo, e la domanda del round è proprio se l'edge sopravvive al congelamento** |

📄 **Il contratto del PASSO 0:** `backtest_pipeline/prove/VGRSI_SONDA_CONTEGGIO_M5.txt`
📄 **Il dossier:** `backtest_pipeline/caccia_strategie/CACCIA_FREQUENZA4_CB_PAPER_2026-09-02.md`
