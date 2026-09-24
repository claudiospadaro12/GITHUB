# 🩹 SECONDO STOP DELLA CHALLENGE FTMO — 24/09/2026, `770411` MaxMinNotte DAX Short

Fonte: due screenshot di Claudio dall'app MT5 (Storico → Affari, e grafico GER40.cash M15),
conto FTMO `541452707`. Ore **del server FTMO** (= ora italiana **+1**, verificato stamattina
sulle tre Aperture in `report/PERCHE_LE_SEDIE_NON_SPARANO_2026-09-24.md` §3).

## 1. L'operazione, ricontata al centesimo

| | |
|---|---|
| ingresso | **sell 25,23 lotti @ 25.286,39** · 10:02:04 server = **09:02 italiane** (2 minuti dopo l'apertura cash) · commento `MAXMIN DAX SHORT SELL` |
| uscita | **buy 25,23 @ 25.352,52** · 10:14:49 server · commento `[sl 25350.64]` → **stop** |
| durata | **12 minuti e 45 secondi** |
| punti persi | 25.352,52 − 25.286,39 = **66,13** |
| perdita | 66,13 × 25,23 = **1.668,46 €** ✅ *(= screenshot, al centesimo)* |

### 🟢 Tre verifiche che TORNANO
1. **La taglia è quella di contratto.** Distanza ingresso→SL **64,25 punti** × 25,23 lotti =
   **1.621,03 € = 2,03% di 80.000**. La sedia in campo porta `rischio 2.00`
   (`CODA_01_sedie_attaccate_20260924`). Nessuna anomalia di dimensionamento.
2. **La geometria è quella del modello.** `R242a` r.219-220 dava per la cella viva `770411`
   *"2,5 × ATR M15 = **64,5 idx**"*. **Il campo ha dato 64,25.** Scarto **0,4%**.
3. **Lo slittamento sta dentro quello modellato.** SL a 25.350,64, eseguito a 25.352,52:
   **1,88 punti = 47,43 € = +2,9%** sulla perdita voluta. Il Monte Carlo ha uno scenario a
   **+10,5%**: il dato vero sta a meno di un terzo.

## 2. Dove siamo contro i muri

| | valore | muro | spazio |
|---|---:|---:|---:|
| equity prima (Guardian, 24/09 03:30) | 78.242,32 | | |
| **equity dopo** | **76.573,86** | | |
| perdita del giorno | **2,09%** di 80.000 | 5% = 4.000 € | **2.331,54 €** |
| **pausa del Guardian** (B1) | | **3,5%** = 2.800 € | **1.131,54 €** → un altro stop oggi la fa scattare |
| emergenza del Guardian | | 4,5% = 3.600 € | 1.931,54 € |
| **DD totale statico** | **4,28%** | 10% = 72.000 € | **4.573,86 € ≈ 2,8 stop pieni** |

🟢 **Oggi il Guardian ci copre**: un secondo stop pieno porterebbe la giornata a ~4,1%, **sopra
la pausa (3,5%)** — il Guardian bloccherebbe i nuovi ingressi — e **sotto il muro FTMO (5%)**.

## 3. 🎲 IL MONTE CARLO RIFATTO DAL SALDO VERO (0,95717)

**Contro-esempio prima**: rilanciato `mc_challenge_ftmo.py` **così com'è** → riproduce **al
decimale** i numeri del 23/09 (70,3% · 84,0% · 96,6%). La macchina è sana. Poi sostituito
**solo** il saldo di partenza (78.242,32 → **76.573,86**) via import, senza toccare il file.

| scenario | ieri (0,97803) | **oggi (0,95717)** |
|---|---:|---:|
| 2,00%, Guardian NON attivo | 70,3% | **61,8%** |
| **2,00%, Guardian attivo** *(la configurazione in campo)* | **84,0%** | 🟠 **74,6%** |
| 2,00%, Guardian + slittamento +10,5% | 78,4% | 68,4% |
| 1,00%, Guardian attivo | 96,6% | 91,3% |
| *pessimista* 2,00%, Guardian | 67,8% | 57,6% |
| *pessimista* 1,00%, Guardian | 69,0% | 57,2% |

🔴 **Tutto il calo viene dal muro STATICO** (colonna "statico" da 16,0% a 25,4% a 2%): la morte
per muro giornaliero resta **0,0%** in tutti gli scenari col Guardian. **Il Guardian fa il suo
mestiere; è il 10% totale che si avvicina.**
⚠️ Limiti dichiarati del modello: **4 sedie su 6** (quelle con per-trade), 242 giornate, un solo
regime. Giorni di borsa mediani al +10%: **20**.

## 4. Che cosa NON è
- **Non è un guasto.** Taglia, geometria e slittamento tornano tutti e tre col modello.
- **Non è la rosa che "non spara"**: `770411` ha frequenza promessa **0,051/giorno** e ha sparato.
  E questo è anche il **secondo Trading Day confermato** della challenge (22/09 e 24/09).
- **Non è una decisione mia.** Le taglie sono di Claudio. I numeri a 1,00% qui sopra sono
  **l'uscita del modello già in repo dal 23/09**, non una proposta. E lo scenario pessimista dice
  che a 1,00% (57,2%) si sta **come** a 2,00% (57,6%): la taglia da sola non è la leva, sotto le
  ipotesi peggiori.

---

## 5. 🚀 CHE COSA SA FARE LA ROSA — i numeri che il Monte Carlo usa, letti uno per uno

Stesse fonti del Monte Carlo (`mc_challenge_ftmo.py`, `carica()`): **4 sedie su 6**, **242
giornate di borsa**, **tick reali**, finestra **2025.06.10 → 2026.06.29**, riportate a **2,00%**
(la taglia in campo). ⚠️ È backtest, un regime solo: sono il **contratto**, non una promessa.

| | |
|---|---:|
| somma in 242 giornate @2% | **+108,4%** |
| media per giornata | **+0,448%** |
| **giornate VERDI** | **162 su 242 = 66,9%** |
| giornata verde media / rossa media | +1,71% / −2,13% |
| **profit factor per giornate** | **1,64** |
| migliore giornata | +8,30% |
| **mesi in positivo** | **11 su 13** — e i due rossi valgono −0,2% e −1,1% |

Mesi: `2025.06 +7,5` · `07 +10,5` · `08 +0,2` · `09 +22,6` · `10 +2,2` · `11 +15,6` · `12 −0,2` ·
`2026.01 +13,2` · `02 +14,3` · `03 +16,0` · `04 −1,1` · `05 +0,5` · `06 +7,2`

### La rimonta, in giornate
- i due stop della challenge (**−4,28%**) valgono **~9,6 giornate medie** della rosa (4,28 / 0,448);
- per arrivare al target (88.000 €) servono **+14,9%** dall'equity di oggi: in 242 giornate la
  rosa ha fatto **+108,4%**, cioè **~7 volte** quello che manca.

### 🔴 E il numero che tiene onesti gli altri
**Solo il 22,9%** delle finestre di **20 giornate esatte** fa +14,9% da sola (51 su 223). Il 74,6%
del Monte Carlo non dice *"in 20 giorni"*: dice *"prima di toccare il 10%"*, e regge **perché la
challenge non ha limite di tempo**. 👉 **Il tempo non è il nostro nemico. Il muro del 10% sì.**
