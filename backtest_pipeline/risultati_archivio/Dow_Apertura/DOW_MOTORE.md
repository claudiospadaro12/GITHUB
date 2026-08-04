# 🎯 DOW APERTURA — fase MOTORE, tick reali

_03/08/2026. `ABTG_Nasdaq_Apertura_US` su **U30USD** M5 (apertura USA 14:30 server = 15:30 IT), 2024.01–2026.06._
_Replica esatta della FASE A sui P&L veri: range di apertura 15 min, buffer 200 pt, stop sull'estremo opposto, TP a 1,5R, **gestione nuda** (niente parziale, niente BE, niente trailing). 12 pass._

## Risultati

| filtro H4 | filtro volumi | soglia | profit | **PF** | **DD%** | trade |
|---|---|---|---|---|---|---|
| — | — | — | 633 | 1,03 | 14,9 | 445 |
| — | ✔ | 1,2 | 158 | 1,01 | 13,0 | 358 |
| — | ✔ | 1,5 | −157 | 0,99 | 13,5 | 321 |
| — | ✔ | 1,8 | 511 | 1,05 | 8,5 | 288 |
| **✔** | **—** | — | **3 917** | **1,24** | **6,9** | **329** |
| ✔ | ✔ | 1,2 | 2 247 | 1,21 | 7,2 | 247 |
| ✔ | ✔ | 1,5 | 17 | 1,00 | 15,1 | 214 |
| ✔ | ✔ | 1,8 | −286 | 0,96 | 13,2 | 186 |

_(le righe con filtro volumi spento sono ripetute tre volte perché la soglia è inerte: 4 pass ridondanti su 12, previsti)_

## ✅ Il filtro trend H4 funziona sul Dow — confermato sui P&L veri

**PF 1,03 → 1,24. DD 14,9% → 6,9%. Trade 445 → 329.**

Migliora **tutte e tre** le colonne che contano: il PF sale, il drawdown si dimezza, e il campione resta ampio (329 trade, ben oltre la soglia dei 150). Non sta comprando PF pagando in campione — è il contrario di quello che fa il filtro volumi sul Nasdaq, dove per arrivare a PF 1,38 si scende a 80 trade.

La FASE A prevedeva **+0,052 R/trade** dal filtro H4 sul Dow. Il backtest completo, con costi e slippage veri, conferma: **Expected Payoff 11,91 per trade** contro 1,42 senza filtro.

## ❌ Il filtro volumi NON si trasferisce dal Nasdaq

Da solo sul Dow: 1,01 / 0,99 / 1,05 al variare della soglia — **nessun ordine, nessuna tendenza**. È la firma del rumore, la stessa che aveva l'ATR sul Nasdaq.

Peggio: **sopra al filtro H4 fa danno**, e in modo monotòno — 1,24 → 1,21 → 1,00 → 0,96 stringendo la soglia. Sta togliendo trade buoni.

> **Lezione da mettere a verbale: un filtro che funziona su un indice non funziona sull'altro.** Il volume di pre-apertura porta informazione sul Nasdaq (0,90 → 1,15) e zero sul Dow. Il trend H4 porta informazione sul Dow (1,03 → 1,24) ed è dannoso sugli indici europei (FASE A: DAX −0,043, CAC −0,053, IBEX −0,081). **Non esiste "il filtro giusto": esiste il filtro giusto per QUEL mercato.**

## 📊 Dov'è arrivato il Dow rispetto al resto

| | PF | DD | trade |
|---|---|---|---|
| **Dow + H4** | **1,24** | **6,9%** | **329** |
| Nasdaq + volumi 1,5× | 1,15 | 9,6% | 152 |
| Nasdaq + volumi 1,8× | 1,38 | 7,6% | 80 ⚠️ |
| Nasdaq nudo | 0,90 | 34,4% | 482 |

**È il miglior risultato che abbiamo su un sistema di aperture**, e l'unico che regge su tutti e tre i criteri insieme.

## ✅ ROBUSTEZZA — l'altopiano c'è (fase 2, 03/08)

Sweep dell'EMA dentro il filtro H4, da 20 a 200 periodi. 10 pass, tutto il resto fermo.

| EmaSlow | PF | DD% | trade | profit |
|---|---|---|---|---|
| 20 | 1,274 | 8,81 | 324 | 4 424 |
| **40** | **1,299** | **7,07** | 328 | **5 026** |
| 60 | 1,241 | 7,53 | 334 | 3 946 |
| 80 | 1,270 | 7,32 | 337 | 4 421 |
| 100 | 1,202 | 11,04 | 342 | 3 176 |
| 120 | 1,228 | 11,38 | 344 | 3 703 |
| 140 | 1,211 | 10,81 | 345 | 3 401 |
| 160 | 1,211 | 11,72 | 350 | 3 411 |
| 180 | 1,241 | 11,48 | 351 | 4 011 |
| 200 | 1,252 | 11,66 | 351 | 4 108 |

**Tutti e 10 i valori stanno sopra PF 1,20** (min 1,202 · max 1,299 · mediana 1,241). Non c'è nessuna punta: il PF 1,24 dell'EMA 50 è un punto qualunque dentro una regione buona larga un ordine di grandezza. **Il filtro H4 sul Dow è una proprietà del mercato, non un artefatto di taratura.**

### Una sottostruttura vera, non rumore

| | PF mediano | **DD mediano** | trade mediani |
|---|---|---|---|
| **EMA 20–80** (corta) | **1,272** | **7,42%** | 331 |
| EMA 100–200 (lunga) | 1,219 | **11,43%** | 348 |

Lo stacco sul drawdown è di **4 punti percentuali** ed è coerente su 4 valori contro 6 — non è un singolo pass fortunato. Un'EMA corta su H4 reagisce prima ai cambi di regime e tiene fuori dai giorni peggiori, al costo di ~17 trade.

**Scelta: si resta a `InpEmaSlow = 50`.** È dentro la regione buona, e prendere il 40 solo perché è il massimo della griglia sarebbe esattamente l'errore da cui questo test doveva proteggerci. La regola operativa vera è: **stare sotto i 100**.

## ⚠️ Cosa NON è ancora dimostrato

1. ~~Il numero dentro l'interruttore non è mai stato testato~~ → **fatto: altopiano confermato**, 10/10 sopra PF 1,20.
2. **Nessun out-of-sample.** Un solo periodo 2024.01–2026.06, nessuna divisione IS/OOS.
3. **Gestione ancora nuda.** Qui non c'è né BE né trailing: il risultato è il valore *grezzo* del segnale. La fase `distanze` dirà quanto se ne può tenere.

## ▶️ Prossimi passi, in ordine

```powershell
# ~~1) robustezza~~ -> FATTA, superata.
# 2) le distanze di gestione. 48 pass.
.\dow_apertura.ps1 -Fase distanze          # gia' tarato su -H4 1 -Vol 0
```

---

# 📏 FASE DISTANZE (04/08) — il risultato che non mi aspettavo

48 pass a tick reali. Struttura fissata (**parziale 50% + BE al primo target + trailing a punti fissi**), spazzolati i tre numeri: `InpTP1_R`, `InpBEatR`, `InpTrailFixedPts` — quest'ultimo in **frazioni dell'R misurato del Dow** (12 532 punti MT5).

## ⚠️ Prima: metà griglia era ridondante

`InpBEatR` conta **solo quando è più piccolo di `InpTP1_R`**. Altrimenti il breakeven l'ha già fatto il parziale (`InpBreakevenAtTP1=1`) e il parametro non tocca niente. Su 48 pass, **le combinazioni distinte sono 16**.

## Le 16 combinazioni (BE al primo target, nessun BE anticipato)

| TP totale | trailing | in R | PF | DD% | trade | profit |
|---|---|---|---|---|---|---|
| 0,99R | 3 000 | 0,24 | 1,163 | 5,37 | 580 | 966 |
| 0,99R | 9 000 | 0,72 | 1,199 | 5,86 | 567 | 1 403 |
| 1,50R | 9 000 | 0,72 | 1,180 | 7,33 | 538 | 1 701 |
| 2,01R | 9 000 | 0,72 | 1,159 | 6,84 | 530 | 1 833 |
| 2,52R | 3 000 | 0,24 | **1,201** | **5,39** | 458 | 1 388 |
| **2,52R** | **9 000** | **0,72** | 1,187 | 7,32 | 514 | 1 750 |
| **2,52R** | **12 000** | **0,96** | 1,212 | 8,01 | 509 | **2 575** |

## 🔴 1. La gestione, così com'è, DISTRUGGE valore sul Dow

| | profit | PF | DD% |
|---|---|---|---|
| **NUDA** (stop 1R, TP 1,5R, niente parziale/BE/trailing) | **3 917** | **1,240** | **6,90** |
| migliore con gestione, a parità di TP (1,5R) | 1 701 | 1,180 | 7,33 |
| migliore con gestione, qualunque TP | 2 575 | 1,212 | 8,01 |

**Non gestire batte qualunque gestione testata**: +52% di profit sul migliore in assoluto, **+130%** a parità di take profit. E con un drawdown *più basso*.

Stesso periodo, stessi ingressi, stesso rischio per trade. L'unica differenza è cosa succede **dopo** l'ingresso.

## 🔴 2. Il breakeven anticipato costa, e costa tanto

Isolando i casi in cui il BE arriva **prima** del parziale:

| TP totale | trailing | BE tardi | BE a 0,5R | Δ |
|---|---|---|---|---|
| 2,01R | 0,72R | 1 833 | 1 471 | **−362** |
| 2,01R | 0,96R | 1 649 | 1 259 | **−391** |
| 2,52R | 0,72R | 2 387 | 1 750 | **−637** |
| **2,52R** | **0,96R** | **2 575** | **1 601** | **−974 (−38%)** |
| 2,01R | 0,24R | 1 120 | 1 187 | +67 |
| 2,52R | 0,24R | 1 270 | 1 388 | +118 |

**Sei casi su otto in perdita**, e il danno cresce col trailing largo: quando il trade ha spazio per correre, il BE anticipato lo butta fuori prima.

⚠️ **Questo smentisce l'ipotesi che avevo tratto dalla FASE A** (*"il 48% dei perdenti DAX era prima a +0,5R, quindi il BE è promettente"*). Vero che quei trade passano dal profitto: ma **portarli in pari costa più di quanto salva**, perché gli stessi che ritracciano sono quelli che poi corrono. Il conto complessivo, misurato, è negativo.

## 🟡 3. Il trailing: largo meglio di stretto, ma niente meglio di tutti

Dentro le combinazioni gestite, la direzione è quella attesa: **0,72–0,96 R battono 0,24 R** in profit (1 750–2 575 contro 1 388). Conferma dell'ordine di grandezza che il forward suggeriva — il `410` del DAX vale **0,07 R**, dieci volte più stretto del peggiore qui testato.

Ma anche il trailing migliore perde contro il non-trailing. **La distanza giusta esiste; il trailing in sé, sul Dow, non paga.**

## ⚠️ Il limite grosso di questa griglia

`InpTrailMode` è stato **pinnato a 2 (punti fissi)** in tutti e 48 i pass. **Non abbiamo mai testato `InpTrailMode = 1` (base della candela precedente)** — che è proprio quello che il 04/08 in forward ha fatto **13× i punti** del trailing fisso sul DAX.

Quindi la conclusione onesta è: *il trailing **a punti fissi** non paga sul Dow*. Sul trailing adattivo non abbiamo ancora un dato.

## ✅ Cosa portiamo a casa

1. **Preset Dow: `InpTP1_ClosePct = 0`, `InpBreakevenAtTP1 = 0`, `InpBEatR = 0`, `InpUseTrailing = false`, `InpTP1_R = 0.5`** (TP totale 1,5R). Profit 3 917, PF 1,24, DD 6,9%, 329 trade.
2. **Il BE anticipato si toglie**, sul Dow. Va contro l'intuizione, ma i numeri sono otto confronti puliti.
3. **Prossimo test**: `InpTrailMode = 1` a parità di tutto il resto. È l'unica gestione che il forward ha mostrato funzionare e che il backtest non ha ancora visto.
4. ⚠️ Tutto questo resta **in-sample**. Manca il walk-forward.

---

# 🔄 FASE TRAILING (05/08) — mi ero sbagliato: il trailing giusto paga

30 pass. Stessi ingressi, **329 trade in ogni singolo pass** (il trailing non tocca la selezione): il confronto è pulitissimo, cambia solo cosa succede dopo l'ingresso.

## Trailing a BASE CANDELA (`InpTrailMode = 1`)

| TF della candela | profit | **PF** | **DD%** | Sharpe | recovery |
|---|---|---|---|---|---|
| M1 | 1 162 | 1,200 | 4,85 | 9,62 | 2,12 |
| M2 | 2 471 | 1,337 | 5,56 | 14,19 | 3,68 |
| M3 | 2 652 | 1,311 | 5,64 | 12,63 | 3,81 |
| M4 | 2 837 | 1,300 | 6,18 | 11,69 | 4,19 |
| **M5** | **3 882** | **1,371** | **5,32** | **13,99** | **6,51** |

## Trailing ATR (`InpTrailMode = 0`)

| moltiplicatore | profit | PF | DD% | Sharpe |
|---|---|---|---|---|
| 1× | 1 748 | 1,203 | 6,65 | 8,05 |
| 2× | 3 311 | 1,242 | 7,34 | 8,57 |
| 3× | 3 990 | 1,247 | **8,22** | 8,69 |

## Il confronto che conta

| | profit | PF | DD% | Sharpe | recovery |
|---|---|---|---|---|---|
| gestione **NUDA** | 3 917 | 1,238 | 6,92 | 8,26 | 4,20 |
| **base candela M5** | 3 882 | **1,371** | **5,32** | **13,99** | **6,51** |
| ATR ×3 | 3 990 | 1,247 | 8,22 | 8,69 | 3,57 |

**A parità di profit e di trade, il trailing a base candela M5 migliora tutto il resto:**
PF **+11%**, drawdown **−23%**, Sharpe **+69%**, recovery factor **+55%**.

L'ATR invece fa più profit solo alzando il moltiplicatore, e paga con un DD che **cresce** (6,65 → 8,22): è indistinguibile dal non gestire, solo più rumoroso.

## ⚠️ Correzione di quello che avevo scritto ieri

Ieri, dopo la fase distanze, avevo concluso: *"non gestire batte qualunque gestione testata"*. Avevo anche segnalato il limite — `InpTrailMode` era pinnato a punti fissi in tutti e 48 i pass. **Adesso quel buco è chiuso, e la conclusione cambia:**

> **Non era il trailing a essere sbagliato. Era il TIPO di trailing.**
> A punti fissi peggiora sempre. A base candela migliora ogni metrica di rischio a parità di rendimento.

E soprattutto: **è la stessa risposta che il forward aveva dato il 04/08**, quando sul DAX il trailing a base candela catturò 25,64 punti contro 1,90 del fisso, a parità di simbolo, ora e direzione. Due metodi indipendenti, stessa conclusione.

## 🟡 Un dubbio onesto: M5 è il bordo della griglia

Il profit sale in modo **ordinato** con la candela: 1 162 → 2 471 → 2 652 → 2 837 → **3 882**. Non c'è una gobba: **la curva sta ancora salendo quando la griglia finisce.** Non sappiamo se M10 o M15 facciano meglio.

→ fase `trailing2`: M5 / M10 / M15 / M20, 4 pass.

## ✅ Preset Dow aggiornato

| | prima | **adesso** |
|---|---|---|
| `InpUseTrailing` | false | **true** |
| `InpTrailMode` | — | **1 (base candela precedente)** |
| `InpTrailTF` | — | **M5** |
| parziale / BE | spenti | spenti (invariato) |
| `InpTP1_R` | 0.5 (TP 1,5R) | 0.5 (invariato) |

`ABTG_Dow_Apertura_US.mq5` aggiornato: **serve ricompilare sul VPS** perché l'EA in forward lo usi.

---

# ✅ FASE TRAILING2 (05/08) — la cima c'è, ed è a M5. Dow chiuso.

| TF candela | profit | **PF** | DD% | Sharpe | recovery |
|---|---|---|---|---|---|
| **M5** | 3 882 | **1,371** | **5,32** | **13,99** | **6,51** |
| M6 | **4 180** | **1,371** | 5,88 | 13,85 | 5,14 |
| M10 | 4 040 | 1,303 | 5,31 | 11,59 | 5,30 |
| M12 | 3 910 | 1,281 | 5,81 | 10,91 | 4,63 |
| M15 | 3 932 | 1,262 | 8,36 | 10,03 | 3,16 |
| M20 | 3 824 | 1,251 | 7,94 | 9,22 | 3,28 |

Mettendo insieme le due fasi, la curva completa del PF è una **gobba pulita**:

`M1 1,200 → M2 1,337 → M3 1,311 → M4 1,300 → M5 1,371 = M6 1,371 → M10 1,303 → M12 1,281 → M15 1,262 → M20 1,251`

**Sale fino a M5-M6, poi scende in modo monotòno.** Il dubbio della fase precedente ("il profit sale ancora al bordo della griglia") era legittimo ed è ora risolto: **l'ottimo non stava oltre, stava dove eravamo.**

## Perché M5 e non M6

M6 fa **298 € di profit in più** (4 180 contro 3 882), ma:
- PF **identico** (1,371 entrambi)
- DD **peggiore** (5,88% contro 5,32%)
- recovery factor **molto peggiore** (5,14 contro 6,51)

Più rendimento pagato con più rischio, a parità di qualità. Per un sistema destinato a una prop (dove comanda il DD) **si tiene M5**. E il fatto che due TF adiacenti diano lo stesso PF è la conferma che siamo su un altopiano, non su una punta.

---

# 🏁 IL DOW È FINITO — configurazione definitiva

| | valore | da dove viene |
|---|---|---|
| Simbolo / TF | **U30USD M5** | FASE A: unico indice su 8 con aspettativa positiva |
| Range | primi **15 min** dopo l'apertura (14:30 server) | fase motore |
| Buffer | 200 punti | inerte sotto i 100, 200 è sicuro |
| Filtro | **EMA 50 su H4**, prezzo dalla parte giusta | 1,03 → 1,24 · robustezza 10/10 |
| Filtro volumi | **spento** | sul Dow è rumore, sopra l'H4 fa danno |
| Stop | estremo opposto del range, floor 500 | p90 del MAE dei vincenti = 0,80R |
| TP | `InpTP1_R = 0.5` → **1,5R** | ×3 interno; l'ottimo misurato |
| Parziale / BE | **spenti** | fase distanze: tolgono profit, il BE anticipato fino a −38% |
| **Trailing** | **base candela, M5** | fase trailing: PF 1,238 → 1,371, DD −23%, Sharpe +69% |

## Il percorso, in una riga

| | PF | DD% | trade |
|---|---|---|---|
| breakout cieco | 1,03 | 14,9 | 445 |
| + filtro H4 | 1,24 | 6,9 | 329 |
| **+ trailing base candela M5** | **1,371** | **5,32** | **329** |

**106 pass a tick reali in tutto.** Il PF sale del 33% e il drawdown scende di due terzi rispetto al punto di partenza, senza toccare il numero di trade nell'ultimo passo.

## ⚠️ Resta UNA cosa, e non è un dettaglio

**Nessun out-of-sample.** Tutto vive su 2024.01–2026.06. Sei numeri sono stati scelti guardando quel periodo: se il walk-forward non regge, questo è un bell'esercizio e basta.

→ **Prossimo e ultimo passo: walk-forward IS/OOS.**
