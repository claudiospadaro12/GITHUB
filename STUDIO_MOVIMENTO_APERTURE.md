# 🔬 STUDIO DEL MOVIMENTO — DAX e Nasdaq all'apertura

> **Richiesta di Claudio (03/08):** *"Quello che dobbiamo studiare sono i movimenti che fa il DAX, capire dove entrare, come fare il trailing e il BE e trovare la quadra, sia con DAX che con Nasdaq."*

## Perché questo è un lavoro DIVERSO da quello fatto finora

Finora ho testato **quale motore entra** (breakout, retest, fade, ritardato, ORB) e li ho quasi tutti bocciati. Ma il 03/08 il forward ha mostrato che il problema può stare **dopo** l'ingresso:

| Trade reale del 03/08 | Cosa dice |
|---|---|
| Live5m: buy a 25 900, stop a 25 858,60 → **−167 €** | ingresso **senza livello** (29 punti sotto il max notturno) |
| Apertura EU/Marco: buy a 25 932,50 (3 punti sopra il max notturno) → **+33 €** | ingresso **giusto**… |
| …chiusi dal proprio trailing in **39 secondi**, +12 punti su un movimento da **+83** | …ma **uscita sbagliata** |

**L'ingresso giusto senza la gestione giusta vale +33 € invece di +241 €.** Ottimizzare ancora l'ingresso non risolve questo.

## E sull'incrocio 9/21: hai ragione tu

L'indicatore su TradingView segnala l'incrocio EMA 9/21 — ottimo setup, ma **se si aspetta sempre quello si opera pochissimo**. È lo stesso muro trovato sul Nasdaq: il filtro volumi porta il PF da 0,91 a 1,38 ma taglia i trade da 481 a 79.

Un filtro che seleziona bene ma opera 13 giorni su 100 non è un EA: è un segnale occasionale. **La quadra non è "quale filtro", è "quanto stretto".**

---

## Il metodo: due fasi

### FASE A — MISURARE cosa fa il mercato (nessuna ottimizzazione)

```powershell
irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/lavoro/backtest_pipeline/studio_apertura.ps1" | iex
```

`ABTG_Apertura_Study_EA` **simula senza mandare ordini** e misura, per ogni giorno e per ogni indice:

| Metrica | Cosa dice |
|---|---|
| **ampiezza del range** | quanto è largo il campo da gioco |
| **MAE** (max escursione avversa) in punti e in R | **quanto va CONTRO prima di andare a favore** → dove NON mettere lo stop |
| **MFE** (max escursione favorevole) in punti e in R | **quanto corre davvero** → quanto vale lasciar correre |
| **durata** (barre nel trade) | quanto dura il movimento → quando ha senso il BE |

Da questi tre numeri si leggono **direttamente** le tre risposte che cerchiamo:
- **Dove entrare** → sopra/sotto quale livello, e con quanto buffer perché il MAE tipico non ti prenda
- **Dove mettere lo stop** → oltre il MAE dei giorni che poi vanno bene (altrimenti ti stoppa lo sweep, come ai Live5m)
- **Quando mettere il BE** → **dopo** il ritracciamento tipico, non prima
- **Quanto largo il trailing** → proporzionato al respiro del movimento, non 4 punti

⚠️ Lo script puntava al vecchio branch `claude/ea-market-openings-d79m8l` (fermo). **Corretto il 03/08 → `lavoro`.**

### FASE B — VERIFICARE sui P&L

```powershell
# 1) STRUTTURA: quali toggle (parziale sì/no, BE sì/no, quale trailing)
.\scan_gestione.ps1 -Robot ABTG_DAX_Apertura_EU     -Symbol D30EUR -SessionHour 8
.\scan_gestione.ps1 -Robot ABTG_Nasdaq_Apertura_US  -Symbol NASUSD -SessionHour 14

# 2) DISTANZE: fissata la struttura, QUANTO larghi   ⬅️ è qui che si trova la quadra
.\scan_gestione.ps1 -Robot ABTG_DAX_Apertura_EU     -Symbol D30EUR -SessionHour 8  -Fase distanze
.\scan_gestione.ps1 -Robot ABTG_Nasdaq_Apertura_US  -Symbol NASUSD -SessionHour 14 -Fase distanze
```

**La fase "distanze" è nuova (03/08)** e nasce dall'errore di oggi. Prima lo script spazzolava solo *quali* toggle accendere, non *quanto larghi*: avrebbe detto "il trailing a punti fissi è cattivo" senza rivelare che era cattiva **la distanza** (4,1 punti indice su un mercato che ne respira 20–40).

Ora, fissata la struttura, spazzola i tre numeri che decidono:

| Parametro | Griglia | Domanda a cui risponde |
|---|---|---|
| `InpTP1_R` | 0,5 / 1,0 / 1,5 / 2,0 | dove metto il primo obiettivo |
| `InpBEatR` | 0 (off) / 0,5 / 1,0 / 1,5 | **quando vado in pari** — troppo presto = mi butta fuori il respiro |
| `InpTrailFixedPts` | 410 / 1607 / 2804 / 4000 → **4 / 16 / 28 / 40 punti indice** | quanto largo il trailing |

---

## Come si legge il risultato

Non cerchiamo il PF più alto: cerchiamo la combinazione che **tiene il trade dentro il movimento senza allargare il rischio**.

| Segnale | Lettura |
|---|---|
| PF sale e i trade restano ~uguali | ✅ è gestione, non selezione |
| PF sale ma i trade crollano | ⚠️ stai selezionando, non gestendo |
| Il trailing largo vince e il DD non peggiora | ✅ il 410 era davvero troppo stretto |
| Il BE tardivo vince | ✅ oggi lo mettiamo troppo presto |

E il metro del campione resta quello: ~625 giorni di borsa, **sotto 150 trade il risultato è sospetto, sotto 80 non è un dato**.

---

## Ordine di lavoro

1. **FASE A** — studio del movimento (DAX + Nasdaq + gli altri indici, in un colpo)
2. Io leggo MAE/MFE/durata e **derivo** i valori di partenza per stop, BE, trailing
3. **FASE B** — sweep distanze, che conferma o smentisce quei valori sui P&L
4. Solo allora si toccano i preset in forward

_Un backtest alla volta: `studio_apertura.ps1` non va lanciato mentre gira l'ablazione._
