# 🎯 QUANTO È RARA LA SERIE D'APERTURA DELLA CHALLENGE FTMO — 25/09/2026

**Conto**: FTMO **`541452707`** (`C:\FTMO`), 80.000 EUR, rischio in campo **2,00%**. **Sola lettura**:
nessun EA, preset o conto toccato. **Tempo macchina: zero** (solo dati già in repo).
**Domanda (Claudio)**: *«non ricordo da quanto non prendevamo questi stop di fila»*.
**Strumento**: `backtest_pipeline/serie_perdente_ftmo.py` (nuovo, ~10 s) · controlli: `--autotest`
(21 controlli, tutto verde). Importa `mc_challenge_ftmo_stato.py` senza modificarlo.

> 🔴 **Qui ci sono SOLO frequenze. Nessuna proposta su taglie, cap o Guardian: sono firme di Claudio.**

## 📐 Le statistiche, DICHIARATE PRIMA DEL CALCOLO
- **Soglia** = il valore **esatto** dell'evento: **−4.909,28 / 80.000 = −6,1366%** @2,00%. Col −6,14
  tondo l'evento stesso **non** si conterebbe: è un controllo dell'autotest.
- **(a)** finestre di **K = 3 e 4** giornate consecutive con somma @2,00% **≤ −6,1366%**, in due
  definizioni: **a1** = giornate **con operazioni** (l'evento = 3: 22, 24, 25/09) · **a2** = **feriali
  di calendario**, con lo zero nei giorni senza operazioni (l'evento = 4: dal 22 al 25/09).
- **(b)** **3** giornate con operazioni consecutive, **tutte** in perdita netta.
- Inoltre: la **serie negativa più lunga** e la **peggior somma su 4 giornate**.
- Finestre che si sovrappongono = **un episodio**. *"Una volta ogni N"* = feriali / episodi;
  *"per anno"* = episodi / 1,054 anni. Entrambi **[DERIVATO]**.

---

## 0. 📌 In sei righe
1. 🎲 **Nel backtest della flotta non è un evento raro: è una cosa da ogni 2-4 mesi (banda §2.2: 39-92 feriali).** Tre giornate con
   operazioni che sommano −6,14% o peggio: **6 episodi in 1,054 anni** → **una volta ogni ~46 feriali,
   ~5,7 all'anno** [MISURATO / DERIVATO]. La definizione di calendario dell'evento (4 feriali, 23/09
   compreso) dà **4 episodi** → **una volta ogni ~69 feriali, ~3,8 all'anno**.
2. ⚖️ **Il deposito fisso del pool di casa li gonfia un po' (a saldo corrente scendono), lo slittamento vero (×1,0479) li alza: la banda
   onesta è 4-7 episodi per a1 K=3 e 3-6 per a2 K=4** (§2.2). In tutte e tre le letture resta
   **più volte all'anno**.
3. 🧪 **Il contro-esempio**: sulla sequenza **vera** delle date le serie **non si ammucchiano
   più** che rimescolando le giornate (p = 0,28-0,90; autocorrelazione lag-1 **+0,001**). **Nessuna evidenza** che il MC di casa le sottostimi per l'ordine dei giorni, ma con un anno e 4-7
   episodi la prova è debole: un ammucchiamento modesto non si escluderebbe (§3).
4. 📉 **Il peggio del backtest è molto peggio di oggi**: 4 giornate a **−12,32%** e 3 a **−10,16%**
   (11-16/12/2025), con una serie negativa di **5 giornate** (due volte) [MISURATO]. A 2,00% da inizio challenge, il
   −12,32% di dicembre avrebbe superato l'emergenza totale del Guardian al 9,3%, e il DD −13,91% anche il
   10% statico FTMO [DERIVATO: somma realizzata, senza pausa né taglio giornaliero]. Dicembre è un mese
   sfasato d'orologio.
5. 🟠 **Nel forward BCM, sulle sedie configurate come oggi, una serie di questa taglia non c'è mai
   stata**: piccolo `50503392` 20/07→22/09, 100k `50504263` 10/08→24/09. L'unica finestra che tocca la
   soglia, **27-29/07 sul piccolo (−3,75 R)**, esiste solo per le **due SELL gemelle della `770101` del
   29/07** (stesso secondo, doppia istanza di prima del 17/08, `DIAGNOSI_770101_SIZING_2026-08-31.md`
   punto 5), quando la sedia girava ancora al **2%**: senza la gemella il peggio è **−2,86 R** e gli
   episodi sono **zero**. Il campo è corto (flotta a 4 sedie completa sul piccolo solo dal 18/08; su ~47
   feriali il backtest ne attende 0,7-1,0 [DERIVATO]): lo zero **non** dice che la serie sia rara.
   👉 **Dal campo: mai, con le sedie come oggi. Dal backtest: una ogni 2-4 mesi.**
6. 🔴 **Normale nel backtest NON vuol dire innocuo oggi.** Dal saldo di oggi (75.090,72) all'emergenza
   totale del Guardian (72.560) ci sono **2.530,72 EUR = 3,16% del 80.000 = due stop pieni di fila** a
   2,00%: **tutti e 6** gli episodi del backtest la supererebbero. Il MC dallo stato di oggi: **PASS
   57,2%**, **P(fine corsa entro 5 giorni di borsa) = 21-24%** (`MC_DALLO_STATO_DI_OGGI_2026-09-25.md`
   §0). Questo referto misura quanto è **frequente** la serie, non quanto costerebbe ripeterla.

---

## 1. L'evento
| giorno | sedie | EUR | % del 80.000 |
|---|---|---:|---:|
| 22/09 | `771531` EMA200 Dow short, 2 ingressi a stop | −1.757,68 | −2,20% |
| 23/09 | nessuna operazione | 0,00 | 0,00% |
| 24/09 | `770411` MaxMin DAX short −1.668,46 · `770101` DAX +69,66 | −1.598,80 | −2,00% |
| 25/09 | `770101` DAX long | −1.552,80 | −1,94% |
| **netto** | 3 giornate con operazioni su 3 in perdita | **−4.909,28** | **−6,1366%** |

## 2. Il backtest della flotta
**Pool**: lo stesso del MC di casa (`mc_challenge_ftmo_stato.dati()`). Contiene le 4 sedie con
per-trade (`770101`, `770202`, `770411`, `771531`), a deposito 100.000 e rischio 1,00%, con il P/L
sommato per **data di chiusura** e poi ×2. La finestra va dal **10/06/2025 al 29/06/2026**: 385 giorni
di calendario, **275 feriali**, **242 giornate con operazioni**, di cui 79 in perdita (32,6%).

### 2.1 Le frequenze [MISURATO: episodi e finestre · DERIVATO: "ogni N", "per anno" e IC Poisson esatto, tutti stampati dallo strumento]
| statistica | finestre colpite | **episodi** | **una volta ogni** | **per anno** | IC 95% Poisson / anno |
|---|---:|---:|---:|---:|---:|
| a1 K=3 con operazioni ≤ −6,14% | 8 su 240 (3,3%) | **6** | **46 feriali** | **5,7** | 2,1 – 12,4 |
| a1 K=4 con operazioni ≤ −6,14% | 10 su 239 (4,2%) | **4** | 69 feriali | 3,8 | 1,0 – 9,7 |
| a2 K=3 calendario ≤ −6,14% | 9 su 275 (3,3%) | **6** | 46 feriali | 5,7 | 2,1 – 12,4 |
| **a2 K=4 calendario ≤ −6,14%** (la forma dell'evento) | 9 su 274 (3,3%) | **4** | **69 feriali** | **3,8** | 1,0 – 9,7 |
| **b** 3 con operazioni tutte negative | 11 su 240 (4,6%) | **7** | 39 feriali | 6,6 | 2,7 – 13,7 |

- 🧮 **Controllo lampo della (b)**: con il 32,6% di giornate negative e giornate indipendenti,
  0,326³ = **3,5%** delle finestre. Misurato **4,6%**: stesso ordine di grandezza.
- 📅 **Gli episodi di a1 K=3**, con la peggior finestra di ciascuno: 10-15/10/2025 (−8,59%, il 15/10
  **tre sedie in perdita insieme**) · 11-17/12/2025 (−10,16%) · 23-27/01/2026 (−6,50%) ·
  31/03-02/04/2026 (−9,28%) · 11-13/05/2026 (−6,55%, tre stop di fila della `770101`) · 21-23/06/2026
  (−8,27%). **L'ultimo cade a una settimana dalla fine dei dati.**
- 📏 **Serie negativa più lunga: 5 giornate con operazioni**, due volte (30/10-05/11/2025, −7,91%;
  10-16/12/2025). Distribuzione delle serie negative: 36 da 1, 9 da 2, 5 da 3, 2 da 5.
- 📉 **Peggior somma**: su 3 giornate **−10,16%** (12-16/12/2025), su 4 giornate **−12,32%**
  (11-16/12/2025), identiche nelle due definizioni. DD massimo della serie sommata @2%: **−13,91%**
  (dicembre 2025, contesto, non dichiarato prima).

### 2.2 Due sensibilità che spostano il numero, in versi opposti (e la loro somma)
| lettura | a1 K=3 | a1 K=4 | a2 K=3 | a2 K=4 | b |
|---|---:|---:|---:|---:|---:|
| **pool di casa** (÷ 100.000 fisso) | 6 | 4 | 6 | 4 | 7 |
| ÷ **saldo corrente** di ogni sedia nel backtest | 4 | 3 | 3 | 3 | 6 |
| perdite × **1,0479** (lo slittamento dei 3 stop veri FTMO) | 7 | 6 | 7 | 6 | 7 |
| **combinata**: saldo corrente + perdite × 1,0479 | 5 | 3 | 5 | 3 | 6 |

- Il pool di casa divide per il **deposito**, ma nel backtest ogni sedia cresce (fino a **118-123 mila**
  per `770101` e `771531`). Per questo le perdite tardive pesano di più: **−2,64%** medio sulle giornate
  ≤ −1,5%, contro **−2,41%** a saldo corrente. Gli stop veri FTMO sono stati 2,20 · 2,09 · 1,94%.
- 👉 **La banda: da ~3 a ~6,6 volte l'anno**, cioè una volta ogni **39-92 feriali**, secondo la
  definizione e la lettura. **Rara no, mensile nemmeno.**

## 3. 🧪 Il contro-esempio: l'ordine vero dei giorni contro il rimescolamento
Il dubbio era: *un pool di giornate indipendenti sottostima l'ammucchiarsi delle perdite?* Per
rispondere, ho confrontato la sequenza **vera** delle date con 10.000 rimescolamenti (seme 25):
- **R-giorno**: le giornate si permutano intere. Resta la correlazione fra sedie nella stessa
  giornata, sparisce quella fra giornate vicine. È l'ipotesi del MC di casa.
- **R-sedia**: ogni sedia si permuta per conto suo. Sparisce anche la correlazione fra sedie nello
  stesso giorno.

| statistica | **vero** | R-giorno media · p(≥ vero) | R-sedia media · p(≥ vero) |
|---|---:|---:|---:|
| a1 K=3 | **6** | 5,06 · 0,38 | 4,11 · 0,19 |
| a1 K=4 | **4** | 5,31 · 0,89 | 4,57 · 0,76 |
| a2 K=3 | **6** | 5,01 · 0,36 | 3,90 · 0,15 |
| a2 K=4 | **4** | 5,35 · 0,90 | 4,49 · 0,73 |
| b | **7** | 5,57 · 0,28 | 6,22 · 0,43 |
| serie max | **5** | 4,55 · 0,45 | 4,71 · 0,51 |

- ✅ **Fra giornate, nessun ammucchiamento misurabile**: il vero sta dentro il rimescolato, con
  autocorrelazione lag-1 di **+0,001** (banda ±0,129). **Nessuna evidenza che il MC di casa sottostimi
  le serie per colpa dell'ordine** (potenza bassa, ultimo punto).
- 🟠 **Nello stesso giorno, invece, sì**: **`770202` × `771531` hanno r = +0,62** (n = 22 giornate
  comuni, 6 in perdita tutte e due: stesso simbolo U30USD). DAX × Dow **+0,005**, DAX × EMA200
  **+0,008**. 🔴 **`770101` × `770411` (tutte e due DAX) non si misura**: 9 giornate comuni (e `770202` ×
  `770411` 3, `770411` × `771531` 9). Togliendo quella correlazione (R-sedia), gli episodi K=3 scendono da ~5 a ~4. Il MC di
  casa quella correlazione **la conserva**, perché rimescola giornate intere.
- 🧪 **Il metodo vede l'ammucchiarsi quando c'è** (autotest): con dodici perdite attaccate trova 1
  episodio vero contro 0,11 rimescolati; con una serie alternata trova 0 veri contro 6,17; con due
  sedie identiche trova 20 giornate doppie contro 2,9. **Quindi lo strumento non è cieco.** Ma con 1
  anno e 4-7 episodi la potenza è **bassa**: il risultato è *nessuna evidenza*, non *prova
  dell'assenza*; un ammucchiamento modesto non si escluderebbe.

## 4. 🔭 Il forward BCM, sulle stesse sedie
L'unità è **R**, cioè uno stop pieno della sedia su quel conto, preso come mediana degli stop pieni
osservati, **filtrando per magic + simbolo** (regola B9). Sul piccolo la `770101` a stop perde ~114 EUR,
cioè **~2% del saldo di allora**, perché **fino al 17/08 girava al 2,0%** (default compilato
`ABTG_DEF_RISK 2.0`, `DIAGNOSI_770101_SIZING_2026-08-31.md`); i suoi 7 stop pieni sono tutti del
23/07-14/08. Dal 18/08 gira all'1%: in quel periodo è letta con un R doppio (nessuno stop pieno,
l'esito non cambia) [DERIVATO]. L'evento FTMO in R nominale vale −4.909,28 / 1.600 = **−3,068 R**; in R
"proprio", cioè con lo stesso stimatore (mediana dei suoi 3 stop, 1.668,46), vale **−2,94 R**: la soglia
−3,068 è più severa del ~4%. Lo strumento conta con tutte e due, e l'esito non cambia. **[DERIVATO]**

| conto · sedie | periodo · giornate con op. | R per sedia | a K=3 / K=4 ≤ −3,07 R | (b) 3 negative | serie max · peggior K=3 |
|---|---|---|---|---|---|
| **piccolo `50503392`** (1,00%; `770101` al 2,0% fino al 17/08) · `770101` `770202` `770411` `771531` | 20/07 → 22/09 · 38 (4 sedie dal 18/08; 24-25/09 non nel CSV) | `770101` 114,30 (7 stop) · `771531` 36,62 (4 stop a coppia) · `770202` `770411` **nominale** 50,77 | **1 / 1**: **27-29/07** (−3,75 R; il 29/07 da solo −3,07 R = tre stop `770101`) · **di cui due SELL gemelle dello stesso secondo (doppia istanza)**; **senza la gemella `2933140`: 0 / 0**, peggior K=3 −2,86 R (K=4 −2,77 R; R `770101` 109,45) | **1**: 06-10/08 (−1,96 R) | 3 · −3,75 R |
| **100k `50504263`** (0,65%) · `770101` `770202` `770411` | 10/08 → 24/09 · 21 | `770101` 647,82 (1 stop) · `770411` 657,72 (1 stop) · `770202` nominale 645,97 | **0 / 0** | **0** | 1 · −0,79 R |

- 🟢 **Agosto-settembre (piccolo fino al 22/09, 100k fino al 24/09): nessuna serie di questa taglia su nessuno dei due demo; senza la gemella del 29/07, nessuna in tutto il forward.**
- 📌 Le giornate con operazioni del piccolo sono **38**, non le 39 della prima stesura: il 22/07 conteneva
  solo il trade `770101` su NASUSD, tolto dal filtro magic + simbolo.
- 🔎 **Perché il 100k non l'ha vissuta**: il **22/09** la sua `770101` ha chiuso **+312,80** (+0,48 R),
  mentre su FTMO quel giorno la `770101` ha piazzato un ordine (`PERCHE_LE_SEDIE_NON_SPARANO_2026-09-24.md`
  §2) ma nessuna posizione chiusa compare nell'elenco. E sul 100k la `771531` non c'è. Il **24/09** è
  lo stesso stop (`770411` −657,72). Il 25/09 non è ancora nei CSV. **La causa della differenza del
  22/09 è [NON MISURATO].**

## 5. ⚠️ Limiti dichiarati
1. **Quattro sedie su sei**: `770260` e `770511` non hanno per-trade. Con sei sedie ci sono più
   giornate con operazioni, e la `770511` gira sul Dow come `770202` e `771531`. **Le frequenze qui
   sono un PAVIMENTO.**
2. **Un solo anno, un solo inverno, un solo regime** (toro 2025-26). Con 4-7 episodi l'intervallo
   Poisson va da **~1 a ~14 all'anno**: il numero centrale è indicativo, non preciso.
3. **Orologio FTMO contro BCM**: il backtest è in ora BCM UTC+1 fissa, quindi d'inverno le sedie a
   orario armavano un'ora prima dell'apertura cash, mentre quelle FTMO armano all'apertura
   (`OROLOGIO_BCM_2026-09-24.md`). Episodi a1 K=3 nei mesi non tutto-allineati: **2 su 6**, contro
   **~40%** del tempo: nessuna concentrazione invernale visibile, ma su 6 casi.
4. **Slittamento**: i 3 stop veri costano **×1,0479** rispetto allo SL. Applicato alle perdite del
   pool, alza gli episodi (§2.2).
5. **P/L realizzato per data di chiusura**, non equity. Somme di % del capitale iniziale, come la
   misura FTMO del −6,14%.
6. **Forward**: R stimato su pochi stop (sul 100k **uno per sedia**), R nominale dove lo stop non è mai
   arrivato. Sul piccolo il CSV del 19/08 dà −38,48 contro i −36,54 della pagella (1,94 EUR, ~0,04% del
   saldo), mentre il 100k torna al centesimo (−117,37). Nel backtest la domenica 21/06/2026 è una
   giornata con operazioni: riapertura dei future USA, stop della `771531` alle 23:15 server (2 voci di
   calendario su 277 cadono nel weekend, come in `st.pool_feriali`). Piccolo: CSV fino al 23/09 (24-25/09
   non osservati); un trade `770101` su NASUSD (22/07) escluso col filtro magic+simbolo; il CSV del 19/08
   ha 12 operazioni contro le 13 della pagella (+1,94 mancante, magic ignoto).

---
_Autotest: 21/21 verdi. Controlla l'aritmetica dell'evento, il contro-esempio della soglia tonda
(−6,14 non conta l'evento), i contatori su una serie sintetica, l'identità del pool con quello del MC
(242 giornate, 277 voci di calendario), il pool a saldo corrente che senza composizione torna quello
di casa, i tre contro-esempi del rimescolamento (ammucchiata, alternata, sedie identiche), il 100k
contro la pagella del 19/08, la stima di R su gambe sintetiche e, dopo il cancello, la classe 798: il
piccolo con la gemella dà 1 episodio (−3,75 R), senza dà 0 (−2,86 R) anche alla soglia −2,94; nessun
NASUSD; evento in R proprio −2,942; IC Poisson esatto k=6 = 2,20-13,06._

_Cancello: strato 1 (`controlla_riga.py --oggetto md`) **nessun difetto meccanico** (rilievi letti: nessun
blocco ```; il conto `50504263` compare solo come fonte dei dati, in lettura). Strato 2
(`controllo-preventivo`): **FAIL alla prima passata** su `03de12e5`, con 5 difetti bloccanti. F1 è la
classe **798** nuova: l'episodio forward del 27-29/07 esisteva solo per la SELL gemella della doppia
istanza. Gli altri: F2 la `770101` al 2,0% fino al 17/08 letta come arrotondamento dei lotti, e il filtro
senza simbolo; F3 il verso dello slittamento nel §0.2; F4 nessun legame col costo di oggi; F5 il
rimescolamento sopravvalutato. Tutti corretti, con i numeri nuovi rifatti dallo strumento.
🔴 **In attesa della seconda passata: il documento non va a Claudio prima del PASS.**_
