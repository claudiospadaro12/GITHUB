# 🥇 CACCIA — ORO alle 15:30 ITALIANE (apertura cash USA): LE PROVE ESTERNE
## 10/09/2026 · caccia alle PROVE, non ai nostri dati

**Mandato (Claudio, 10/09).** Un collega opera cosi' sull'ORO:
candela **M5 15:30-15:35 italiane**, poi **M1**, al minuto **15:36** entra dalla
parte in cui il prezzo **sfonda** quel range, tiene **3-4 candele M1**, una
operazione al giorno. Precisazione arrivata in corsa: _"E' X TRADARE MANUALE. O
PER CREARE UN EA SULL'APERTURA. LUI DICE CHE QUEI 5 MINUTI SONO FACILI DA
TRADARE... PROBABILMENTE CI POTREBBE ESSERE L'INCROCIO DELLE MEDIE 9 E 21."_

🔒 **Niente toccato in forward. Niente lanciato sul VPS. Nessun parametro
sfiorato. Nessun backtest nostro: il costo e i dati li misura un altro agente.**

---

## ⚡ LA RIGA CHE CONTA

> **Su 11 canali provati (5 vivi, 6 murati dal proxy), 320 titoli del Code Base
> MQL5 letti (8 pagine), 5 interrogazioni all'indice pubblico TradingView, 4
> all'API arXiv e 8 ricerche testuali, sono arrivato al SORGENTE o al TESTO
> INTEGRALE di 8 oggetti. E la risposta onesta alla domanda di Claudio e':**
>
> 🟡 **L'effetto "l'oro si muove all'apertura del cash USA" NON l'ho trovato
> MISURATO da nessuna parte in modo pulito.** Le due fonti accademiche che lo
> misurerebbero davvero (PLOS ONE 2017 sui 5 minuti dei metalli preziosi; il
> paper EFMA sui co-jump dell'oro) sono **entrambe murate dal proxy**: §7.
>
> 🔴 **Ma ho trovato il CONTRO-ARGOMENTO, ed e' forte, indipendente e
> quantificato**: la **replica indipendente** del paper ORB piu' citato
> (Zarattini & Aziz 2023) misura che **con costi di esecuzione realistici il
> guadagno passa da 138.639 $ a 4.860 $**, e che il pareggio arriva a **2,2
> centesimi/azione di slippage** su uno strumento con **1 centesimo di
> spread**. E uno studio di falsificazione 2026 su MNQ trova che i segnali
> intraday da OHLCV rendono **0,07-1,50 punti lordi** contro **2 punti di
> attrito**. 👉 **Il rischio nominato dal mandato — "un edge direzionale
> piccolo su M1 si mangia da solo" — e' l'unica cosa che le fonti serie
> misurano davvero, ed e' misurata AL RIBASSO.**
>
> 🟢 **La cosa piu' utile che porto NON e' un EA: e' un cancello aritmetico
> gia' in casa nostra.** Lo stop del collega e' il lato opposto di un range di
> **5 minuti**. Con lo spread oro **misurato in casa a 0,24 $**
> (`CACCIA_APERTURE_ORO_2026-09-08.md` §, riga 208), il pavimento **DURO** e'
> **3,2 $** e quello **DI LAVORO** e' **9,6 $**. 👉 **La domanda che decide
> tutto e' una sola e si misura in mezz'ora: quanto e' larga, in dollari, la
> candela M5 delle 14:30 server sull'oro?** Se la mediana sta sotto 9,6 $,
> l'idea e' fuori per COSTO prima ancora che per edge — e non serve nessun
> backtest per saperlo.
>
> 🔴 **Sul 9/21 su M1: ZERO evidenza misurata.** Tutto cio' che ho trovato e'
> marketing (*"usata ogni giorno da conti funded a 6 e 7 cifre"*), e l'unico
> sorgente aperto che fa **9/21 su oro M1** e' un **`indicator()`, non una
> `strategy()`** — cioe' **non produce nessun numero**, e per giunta ha un
> filtro CCI che e' vero quasi sempre. §5.

---

## 1. 🕐 PRIMA DI TUTTO: LE ORE, CON IL FUSO — e c'e' una collisione pericolosa

Il mandato avverte giustamente. Ecco la tabella, e va letta prima di ogni numero
di questo dossier.

| evento | ora ET | ora ITALIANA | ora SERVER BCM (= IT − 1) | ora UTC (estate) |
|---|---|---|---|---|
| apertura pit COMEX | **08:20 ET** | 14:20 | **13:20 srv** | 12:20 |
| **dati macro USA** (NFP, CPI…) | **08:30 ET** | **14:30** | **13:30 srv** | 12:30 |
| **apertura azionario USA** ← 🎯 **quella di Claudio** | **09:30 ET** | **15:30** | **14:30 srv** | 13:30 |
| fixing Londra AM / PM | — | 11:30 / 16:00 | 10:30 / 15:00 srv | 09:30 / 14:00 |

### 🔴 LA TRAPPOLA DA SEGNARE IN ROSSO
**Il numero `14:30` compare DUE VOLTE e vuol dire due cose opposte:**
- **14:30 SERVER** = 15:30 italiane = **09:30 ET** = quella che vuole Claudio;
- **14:30 ITALIANE** = 13:30 server = **08:30 ET** = **i dati macro**.

👉 Se qualcuno scrive "l'oro alle 14:30" senza il fuso, **c'e' il 50% di
probabilita' che stia parlando di un altro fenomeno**, e per giunta del piu'
famoso dei due (le news delle 08:30 ET sono il driver n.1 dell'oro in
letteratura). ⚠️ **In qualunque `.ini` o `input` il valore va scritto in ORA
SERVER: `14` e `30`.** Chi scrive `15:30` ha sbagliato di un'ora e sta
misurando le 16:30 italiane.

### 🪑 E c'e' un fatto di casa che nessuno aveva collegato
`REGISTRO_TEST.md` r.595: le nostre **due sedie vive** `ABTG_ORB` (770601,
NASUSD) e `ABTG_ORB_Ottimizzato` (770611, U30USD) costruiscono il range su
**14:25-14:30 server** — cioe' **i 5 minuti IMMEDIATAMENTE PRIMA** della
finestra del collega, sullo stesso evento (apertura cash USA), su simboli
diversi. **Le due finestre sono adiacenti e non si sovrappongono.** Non e' un
doppione, ma non e' nemmeno terra vergine: e' la stanza accanto.

---

## 2. 🚦 CONTROLLO POSITIVO, FONTE PER FONTE

| fonte | bersaglio noto | esito | verdetto |
|---|---|---|---|
| **MQL5 Code Base** `/en/code/mt5/experts` | devono comparire gli id **76446, 76153** che so gia' esserci | HTTP **200**, 85.849 byte, **entrambi presenti**, 320 titoli su 8 pagine | 🟢 **PASSA** (⚠️ autore/data/download NON resi nell'HTML: metadati letti sulla singola scheda) |
| **API arXiv** `export.arxiv.org` | ultimi q-fin.TR con data | HTTP **200**, titoli reali datati **2026-09-04 → 2026-09-09** | 🟢 **PASSA** |
| **arxiv.org/abs** (pagine singole) | 2605.04004 | **200**, testo integrale letto | 🟢 **PASSA** |
| **TradingView** (indice pubblico + `pine-facade`) | ricerca "XAUUSD ORB" deve dare script veri con id | **200**, sorgenti Pine **scaricati e letti** | 🟢 **PASSA** |
| **GitHub** (pagine repo via fetch) | repo noto | README letti integralmente | 🟢 **PASSA** |
| **GitHub SEARCH (API)** | `search/repositories` | **403**: _"sessions are bound to their configured repositories"_ | 🔴 **NULLA** — su GitHub ho potuto solo **aprire repo trovati da altrove**, non setacciarlo |
| **Quantpedia** — pagine strategia | `/strategies/momentum-effect-in-commodities/` | **200**, 237 KB, testo vero | 🟢 **PASSA** |
| **Quantpedia** — RICERCA | `?s=opening+range` vs `?s=gold+intraday` | **200 ma i DUE file sono IDENTICI (133.782 byte entrambi)**: la ricerca non filtra | 🔴 **NULLA** (ricerca) |
| **SSRN** `papers.ssrn.com` | qualunque pagina | **403** su tutto | 🔴 **NULLA** |
| **ScienceDirect / ResearchGate / PubMed / PMC / EuropePMC / PLOS / DOAJ / RePEc / DiVA / Umeå / Semantic Scholar** | — | **403 dal proxy di egress (policy)** | 🔴 **NULLA** |
| **cxoadvisory · tradingstats.net · danfin.net · optionalpha · quantifiedstrategies · vtmarkets · tradethatswing · reddit** | — | **403 dal proxy** | 🔴 **NULLA** |

> ⚠️ **404 ≠ 403.** Nessuno di questi e' un 404: **esistono**, e' la policy di
> rete di questa sessione che li chiude. Vanno **riprovati da una sessione con
> egress diverso**, non cancellati dal catalogo. §7 li elenca uno per uno.

---

## 3. 📚 L'EFFETTO IN SE': cosa dice la letteratura che sono RIUSCITO ad aprire

### 3.1 🔴 IL CONTRO-ARGOMENTO, ed e' il pezzo migliore della caccia
**`giovannibrusco/zarattini-2023-orb-qqq`** — replica indipendente del paper ORB
piu' citato · MIT · [github.com/giovannibrusco/zarattini-2023-orb-qqq](https://github.com/giovannibrusco/zarattini-2023-orb-qqq)
**[VERIFICATO — README aperto e letto per intero]**

- Riproduce l'ORB a **5 minuti** di Zarattini & Aziz 2023 (SSRN 4416622) su
  **QQQ**, gen-2016 → feb-2023, **1.775 operazioni** (il paper ne dichiarava 1.795).
- **Senza slippage:** PnL **138.639 $**, Sharpe **1,06**, CAGR **30,4%**, DD max **22,4%**.
- 🔴 **Con costi realistici** (2 ¢/azione in ingresso + 4 ¢ sugli stop):
  **PnL 4.860 $, Sharpe 0,23.**
- 🔴 **Il pareggio arriva a ~2,2 ¢/azione di slippage**, su uno strumento il cui
  bid-ask e' **~1 ¢**. Margine di **un centesimo**.
- 🔴 **Concentrazione di regime: il 76% del PnL della versione filtrata viene dal
  SOLO 2022.** In perdita nel 2017, nel 2020 e a inizio 2023.
- 🟢 Onesta' metodologica da imitare: **placebo** (sostituendo il filtro NQ con
  la barra pre-market di QQQ stessa: t=1,27, non significativo, contro t=2,05
  del filtro vero) e **intervalli bootstrap** che si **sovrappongono** a
  buy&hold (Sharpe [0,05; 1,41] contro [−0,03; 1,47]).

> 🎯 **Perche' conta per NOI.** E' la stessa forma della nostra lezione R57
> (_"cambiando SOLO il modello, il segno si e' ribaltato"_), misurata da un
> estraneo su un altro mercato: **un ORB a 5 minuti vive o muore sul costo di
> esecuzione, non sulla direzione.** ⭐ E i numeri gonfi che girano in rete su
> questa famiglia vengono quasi tutti dalla colonna "zero slippage".

### 3.2 🔴 Falsificazione sistematica dei segnali intraday da OHLCV
**"Structural Limits of OHLCV-Based Intraday Signals in MNQ Futures: A
Systematic Falsification Study"** · **Mathias Mesfin** · arXiv **2605.04004**,
sottomesso **05/05/2026**, revisionato **13/07/2026** ·
[arxiv.org/abs/2605.04004](https://arxiv.org/abs/2605.04004)
**[VERIFICATO — pagina aperta]**

- **14 famiglie di segnali** su **MNQ**, 2021-2025, **947 giornate**, barre **5 minuti**.
- Cancelli dichiarati **prima**: walk-forward, **t ≥ 2,0**, **≥ 30 operazioni**,
  positivo **dopo i costi**, coerenza annuale. **Nessuna famiglia li passa tutti.**
- 🔴 **Il numero che brucia:** rendimento **lordo 0,07-1,50 punti/operazione**
  contro un attrito **fisso di 2 punti** andata e ritorno.
- 🟢 **Ma NON e' un "tutto morto" cieco:** due segnali mostrano edge (**RTH
  Confluence** e **London Session B**) e l'autore li usa come **controllo
  positivo del proprio metodo**. 👉 Cioe': su intraday da OHLCV **qualcosa
  esiste**, ma **non nella famiglia breakout generica**, e comunque il vaglio
  e' il costo.

### 3.3 🟡 Il paper madre e le sue repliche
- **Zarattini & Aziz (2023), "Can Day Trading Really Be Profitable?"**, SSRN
  **4416622** — 🔴 **NON aperto: SSRN risponde 403 a tutto in questa sessione.**
  Quel che ne so viene dalla **replica** (§3.1), che e' una fonte migliore per
  noi comunque.
- **QuantConnect, "Opening Range Breakout for Stocks in Play"**, Derek Melchin
  (staff) · [quantconnect.com/research/18444/…](https://www.quantconnect.com/research/18444/opening-range-breakout-for-stocks-in-play/)
  **[VERIFICATO — pagina aperta]** · re-implementazione di Zarattini-Barbon-Aziz
  2024, **range 5 minuti** (testati 5→25), scansione alle **9:35** (fuso non
  dichiarato sulla pagina — assunto US), stop a **1,0 × ATR(14)**, uscita a
  fine giornata. Sharpe 2,396 nel **solo 2016**.
  🔴 Caveat scritti sulla pagina stessa: **"testato solo il 2016"**, sensibilita'
  ai parametri, rischio di sovradattamento. 🟡 Il win rate ~17% citato viene
  dalla discussione sotto il post: **[INCERTO]**, non e' il testo dell'autore.
  👉 **Se anche fosse vero il 17%**, ha un significato preciso per il collega di
  Claudio: **un ORB a 5 minuti fa TANTE piccole perdite e poche vincite grosse.**
  E' l'opposto di *"quei 5 minuti sono facili da tradare"*.

### 3.4 ⚪ Sull'ORO all'apertura cash USA: **il buco vero**
- **`Batten, Lucey, McGroarty, Peat, Urquhart (2017), "Stylized facts of
  intraday precious metals"`, PLOS ONE 12(4): e0174232** — 5 minuti su oro,
  argento, platino, palladio, **mag-2000 → apr-2015**, e misura **periodicita'
  intraday di rendimenti, volatilita', volumi E bid-ask spread**.
  🎯 **E' ESATTAMENTE la fonte che risponderebbe alla domanda di Claudio** —
  compreso *"di quanto si allarga lo spread"*.
  🔴 **NON APERTA**: PLOS, PMC, EuropePMC, DOAJ, ResearchGate, PubMed,
  Semantic Scholar **tutti 403 dal proxy**. Quel che si legge negli estratti
  dei motori (*"periodicita' legata all'apertura e alla chiusura dei mercati
  principali; lo spread e' al minimo quando l'Europa e' aperta"*) e' **una
  citazione di seconda mano e NON la uso come prova.** 📌 **Da riaprire dalla
  prima sessione con egress diverso: e' la fonte n.1 della lista.**
- **"What causes intraday price jumps and co-jumps in Gold"** (EFMA 2024,
  Lisbona) — 🔴 **efmaefm.org 403.** Idem.
- **"Intraday seasonality… Platinum and gold futures in Tokyo and New York"**
  (Kobe DP 1722) — 🔴 **RePEc e ScienceDirect 403.**
- **Tesi svedese "Intraday momentum: day trading on the gold futures market
  using Opening Range Breakout"** (DiVA) — 🔴 **diva-portal.org 403.**
  E' l'unico lavoro accademico ORB **direttamente su GC** che ho individuato.
- 🟡 **Filone "market intraday momentum"** (prima mezz'ora predice l'ultima
  mezz'ora), esteso a oro/argento e alle commodity: individuato,
  **tutti i testi su ScienceDirect/RePEc = 403**. ⚠️ **E comunque non e' la
  stessa cosa**: quel filone predice **l'ULTIMA mezz'ora**, non i **4 minuti**
  successivi. Non lo spaccio per un supporto: **non lo e'**.

> 🔴 **Detto senza girarci intorno: sull'oro alle 09:30 ET non ho una sola
> misura pubblica in mano.** Ho la famiglia (ORB a 5 minuti), ho il costo, ho
> le repliche — **non ho il simbolo e non ho l'ora.** Chi dicesse il contrario
> starebbe citando estratti di motori di ricerca.

---

## 4. 💻 IL CODICE GIA' SCRITTO — letto nel sorgente, non nella descrizione

### 4.1 🥇 `SessionORB_EA` — Code Base **76153** · l'unico che sa fare la finestra del collega
[mql5.com/en/code/76153](https://www.mql5.com/en/code/76153) · pubblicato
**15/08/2026 00:32** · **2.975 visualizzazioni** · sorgente `.mq5` **466 righe
scaricate e lette** · ⚠️ **GIA' SETACCIATO IL 19/08** (famiglia ORB chiusa) —
lo ripresento **solo** perche' e' l'unico attrezzo che imposta *esattamente*
quella finestra, e Claudio deve sapere che esiste.

**[VERIFICATO nel sorgente]**
```
InpSessionStartHour = 8 · InpSessionStartMinute = 0     // ORA SERVER (lo dichiara: "broker/server time")
InpOpeningRangeMinutes = 30 · InpTradingWindowMinutes = 120
InpRiskPercent = 1.0 · InpStopLossBufferPoints = 30 · InpRewardToRiskRatio = 2.0
InpMaxTradesPerSession = 1 · InpBreakoutBufferPoints = 20
```
- 🟢 **Il range e' costruito su `PERIOD_M1` esplicito** (righe 181-196:
  `iBarShift(_Symbol, PERIOD_M1, …)`, `iHighest/iLowest` su M1): la finestra e'
  **precisa al minuto qualunque sia il TF del grafico**. 👉 Per la ricetta del
  collega bastano **tre valori**: `14 / 30 / 5`.
- 🟢 Ingresso su **barra CHIUSA** (riga 222: `iClose(_Symbol, PERIOD_CURRENT, 1)
  // last fully closed bar`) → **niente repaint, niente look-ahead**.
- 🟢 **Zero bandiere rosse del §4**: rischio in %, SL vero, 1 trade/sessione,
  niente martingala/griglia/hedge, niente `#import`, niente `iCustom`.
- 🟢 Dettaglio da rubare comunque: `EnforceMinStopDistance()` **somma lo spread
  corrente** al minimo del server e **allontana** lo stop, mai lo avvicina —
  e il commento spiega perche' (broker che dichiarano `stops_level = 0` e poi
  rifiutano). E `NormalizeLot()` **restituisce 0 invece di arrotondare al lotto
  minimo**, per non tradire il sizing a rischio. 🎯 **Sono due pezzi di igiene
  che valgono a prescindere da questo EA.**
- 🔴 **MA NON FA la cosa del collega**: esce a **SL / TP a 2R**, **non ha
  nessuna uscita a tempo**. Le "3-4 candele M1" **non esistono nel codice** e
  sono la parte che cambia tutto (§6).
- 🔴 **20 `input`** (16 funzionali + 4 grafici): al tetto di ~15, sopra soglia.

### 4.2 🔴 `Gold ORB Strategy (15-min Range, 5-min Entry)` — **LA DESCRIZIONE MENTE**
TradingView, autore **krypson**, **24/04/2025**, **1.036 like**, 4 commenti,
`scriptAccess = open_no_auth`
[tradingview.com/script/oYW9gdag-…](https://www.tradingview.com/script/oYW9gdag-Gold-ORB-Strategy-15-min-Range-5-min-Entry/)

**Cosa promette la pagina** (meta-description, citazione esatta):
_"The strategy defines the Opening Range (ORB) between **9:30 AM EST and 9:45 AM
EST**… trades the Gold market (XAU/USD) during the New York session."_

**Cosa fa il codice** — scaricato da `pine-facade`, **88 righe lette**,
`script_id_part` verificato come quello **principale** della pagina (`"related":[]`):
```pine
strategy("15m Asia Gold ORB Strategy [TP/SL Labels + R FIXED]", overlay=true,
         default_qty_type=strategy.percent_of_equity, default_qty_value=100)
// === Time Settings (UTC) ===
asia_start  = timestamp("UTC", …, 0, 0)   //  00:00 UTC
asia_end    = timestamp("UTC", …, 6, 0)   //  06:00 UTC
trade_start = timestamp("UTC", …, 6, 0)
trade_end   = timestamp("UTC", …, 10, 0)  //  06:00-10:00 UTC
```
🔴 **Non e' l'apertura di New York: e' il range ASIATICO 00:00-06:00 UTC**, con
finestra operativa **06:00-10:00 UTC** (= 02:00-06:00 ET). **Il titolo, la
descrizione e le 1.036 approvazioni si riferiscono a una strategia che il codice
non contiene.**
🔴 In piu': `default_qty_value=100` = **100% dell'equity per operazione**,
nessun dimensionamento a rischio.
🎯 **Questa e' la prova provata del perche' §6 del nostro protocollo dice
"leggi il sorgente": 1.036 persone hanno messo like a una descrizione.**

### 4.3 🟡 `Gold NY Open ORB v11 — LIVE [Ahmed]` — il meglio scritto, ma non e' la ricetta
TradingView, autore **YukozB**, creato **29/05/2026**, `open_no_auth`,
**97 righe lette**
```pine
strategy(…, commission_type=strategy.commission.percent, commission_value=0.02,
         slippage=2, calc_on_every_tick=false)
bHour = hour(time, "UTC")
isORPeriod = isWkd and bHour == 13                    // 13:00-14:00 UTC
isEntryWin = isWkd and bHour >= 14 and (bHour < 16 or (bHour == 16 and bMin <= 30))
```
- 🟢 **Cose giuste, e sono tante:** `calc_on_every_tick=false`; conferma su barra
  chiusa (`close > orHigh and close[1] <= orHigh`); **rischio in % dell'equity**
  (`riskAmt = strategy.equity * riskPct / 100`); SL e TP veri (1:1 sul range);
  chiusura obbligatoria a fine sessione; filtro di regime (`atr <= atrAvg20*2`),
  filtro di ampiezza (`orRange <= atr*2.5`), filtro volume (`volume > volAvg*1.5`);
  **commissioni e slippage DICHIARATI nel `strategy()`**. **Un solo input.**
- 🔴 **Ma il fuso e' cablato in UTC senza DST**: `bHour == 13` e' **09:00-10:00
  ET d'estate** e **08:00-09:00 ET d'inverno**. 👉 **La stessa riga di codice
  cambia evento due volte l'anno**, e d'inverno cade sui **dati macro delle
  08:30 ET**. E' precisamente la collisione del §1.
- 🔴 **Numeri dell'autore — DICHIARATI, NON VERIFICATI**, e riportati solo per
  completezza (header righe 10-22): training gen-2024→giu-2025 **41 op**, WR
  73,17%, PF 2,641; validazione lug-2025→mag-2026 **43 op**, WR 60,47%, PF
  1,499; DD max ~2,5-5%. 🛑 **n=41 e n=43 sono sotto il nostro pavimento di
  150 operazioni**, e l'autore scrive di aver **scelto** R:R 1:1 *"optimal"* e
  **solo long** *dopo* aver visto che gli short abbassavano il PF da 2,64 a
  1,47: **e' selezione dopo il risultato.** Peso di questi numeri sul
  punteggio: **zero**, come da §7.
- 🔴 Range di **60 minuti**, finestra d'ingresso di **2,5 ore**, uscita a
  SL/TP: **non e' la ricetta del collega**.

### 4.4 🟡 `n30dyn4m1c/gold-pro-scalper` — l'unico che nomina il COSTO come cancello
[github.com/n30dyn4m1c/gold-pro-scalper](https://github.com/n30dyn4m1c/gold-pro-scalper) ·
MIT · **14 stelle**, 10 fork · **5 file `.mq5` presenti** · **XAUUSD, M1**
**[VERIFICATO dal README letto; ⚠️ i `.mq5` NON li ho aperti — dichiarato in §7]**
- Quattro EA su **oro M1**: mean-reversion Z-score (±2,2-2,4) con `ADX ≤ 20-22`,
  piu' una variante **"TickRobust"** pensata per il modello **Every Tick**,
  piu' un ibrido con breakout Donchian a 30 barre quando `ADX > 30`.
- 🎯 **Il pezzo che vale:** un **"cost gate"** esplicito — _"StdDev ≥ 3× il
  costo completo andata-e-ritorno"_ e _"distanza del TP ≥ 4× il costo"_, con un
  input `InpExtraCostPts` per la commissione del broker in punti oro.
  👉 **E' la nostra stessa idea del pavimento, trovata in natura**… ma tarata a
  **4×**, mentre il nostro pavimento **di lavoro e' 40×** e quello **duro 13,3×**.
  **Anche il piu' prudente che ho trovato in rete e' 3 volte sotto il nostro
  cancello minimo.**
- 🟢 Ha **un'uscita a TEMPO** (`time exit, 40 bars`): la prova che il mattoncino
  "esci dopo N barre" esiste gia' scritto in MQL5 su oro M1.
- 🔴 **Nessun risultato di backtest nel README** (niente PF, DD, n, periodo):
  quindi **niente da citare**. E **10% di rischio per operazione** dichiarato
  dall'autore stesso come "aggressivo": fuori dai nostri cancelli di rischio,
  ma e' **gestione**, non motore.

### 4.5 🟡 `yulz008/GOLD_ORB` — 290 stelle, e non c'entra con le 15:30
[github.com/yulz008/GOLD_ORB](https://github.com/yulz008/GOLD_ORB) ·
**290 stelle** · sorgente MQL5 presente **[VERIFICATO dal README]**
- ORB su **H1**, finestra che parte alle **"1:02 server time"**, TP **1.200
  punti** / SL **400 punti**, max 2 op/giorno, rischio 1%, tetto di DD 10%,
  trailing da 700 punti.
- 🔴 Nessun risultato numerico nel README (solo screenshot citati).
- 📐 Nota di costo, ed e' interessante: **SL 400 punti oro ≈ 4,00 $**. Contro il
  nostro spread misurato di 0,24 $ fa **16,7 × spread**: sopra il pavimento
  **duro** (13,3×), **ben sotto** quello **di lavoro** (40×). 👉 Anche il
  progetto GitHub con piu' stelle su questo tema **vive nella fascia in cui il
  pedaggio conta**.

### 4.6 🗄️ Gli scarti del Code Base (letti nel titolo, molti gia' setacciati)
Su **320 titoli** delle prime 8 pagine, i pertinenti sono **13**, e **11 erano
gia' passati al setaccio nelle cacce precedenti**:

| oggetto | id | esito |
|---|---|---|
| `GoldLondonBreakout` | 75586 | 🔴 gia' scartato: _"e' LETTERALMENTE il nostro R45"_ (0/48 celle) |
| `Session Opening Range Breakout EA` | 76153 | 🟡 gia' scartato 19/08 · ripreso qui in §4.1 come **attrezzo**, non come candidato |
| `AAPL cfd - ORB strategy` | 76333 | 🔴 gia' scartato: famiglia ORB + simbolo che non abbiamo |
| `Sniper Gold Hybrid Recovery` · `XANDER Grid XAUUSD` · `XANDER Gold Recovery` · `Daily Zone Recovery for GOLD` | 76605 · 71776 · 72278 · 75922 | 🔴 **recovery / griglia**: §4 del protocollo, scarto secco |
| `Quantum XAUUSD Silver Trader` · `Quantum Gold Silver Trader` | 73622 · 63193 | 🔴 gia' scartati: fattoria di manopole, doppia taratura cucita |
| `Easy Range Breakout EA` (x2) · `Universal Breakout Study` · `Viral 4 Hour Range Strategy` | 68764 · 71460 · 73711 · 68082 | 🔴 gia' setacciati (21/08, 25/08, 29/08) |
| `KA-Gold Bot MT5` | 48251 | 🟡 promosso il 28/08 e **mai costruito**: resta in coda, non e' oggetto di questa caccia |

> 🔴 **Verdetto sulla fonte: IL CODE BASE E' ARATO su questo tema.** Zero oggetti
> nuovi pertinenti in 320 titoli. E' la **quinta** caccia di fila che lo dice.

---

## 5. 📉 LE MEDIE 9 E 21 SU M1 — la richiesta nuova di Claudio, e la risposta e' magra

### 5.1 Cosa ho trovato di MISURATO: **niente**
Ho cercato apposta. Il migliore candidato in codice aperto e' questo:

**`ZUMIKO FX - EMA 9/21 + CCI | GOLD M1 PRO`** · TradingView, autore
**kodik19788**, creato **01/03/2026**, `open_no_auth`, **173 righe scaricate e
lette**.
```pine
indicator("ZUMIKO FX - EMA 9/21 + CCI | GOLD M1 PRO", overlay=true, …)
emaCrossUp = ta.crossover(emaFast, emaSlow)   // 9 e 21, su close
cciConfirmLong  = cci > cciOS                 // cciOS = -100
longCondition   = emaCrossUp and cciConfirmLong and trendLong   // trendLong = close > EMA200
```
- 🔴 **E' un `indicator()`, non una `strategy()`.** Non ha `strategy.entry`, non
  ha un tester, **non produce UN SOLO numero**. Chi lo cita come "strategia
  9/21 sull'oro M1 che funziona" sta citando dei triangolini su un grafico.
- 🔴 **Il filtro CCI e' un placebo**: `cci > -100` per il long e `cci < +100`
  per lo short sono **veri quasi sempre**. E' lo **stesso identico difetto**
  gia' verbalizzato in casa il 06/09 sullo script `Gold/Silver 30m` (_"l'ingresso
  short usa `vrsi > RSIOverSold`: vero quasi sempre"_). 🎯 **Due volte lo stesso
  errore in due script diversi: e' un difetto di categoria, non un caso.**
- ⚪ **E soprattutto: non ha NESSUNA finestra oraria.** Non ha niente a che
  vedere con le 15:30. E' un incrocio di medie che gira 24 ore su 24.

**Tutto il resto trovato sul 9/21 e' materiale di vendita**, e lo dico con le
loro stesse parole: _"la stessa identica strategia gold a 5 minuti e' usata ogni
giorno da vari conti funded a 6 e 7 cifre nel 2025"_; _"win rate 45-50% grezzo,
60-68% con cinque filtri applicati"_ (su Bank Nifty, non sull'oro). 🔴 **Zero
periodo, zero campione, zero costi, zero fuori campione. Non entra da nessuna
parte in questo dossier se non in questa riga.**

### 5.2 🔴 IL RITARDO — il numero piu' utile, e lo devo etichettare per bene
Il mandato chiede: _"se esiste una misura pubblica del ritardo, e' il numero
piu' utile che puoi portare"_. **Non l'ho trovata.** Nessuna fonte apribile
misura il ritardo dell'incrocio 9/21 in barre. Quel che si trova sono frasi
qualitative (_"il crossover e' un indicatore ritardato"_, _"se l'incrocio arriva
dopo un movimento grosso, salta il trade: il movimento potrebbe essere gia'
finito"_).

**Allora metto l'aritmetica, e la etichetto per quello che e'.**
🔵 **[INFERITO — non misurato: e' la proprieta' standard del ritardo di una
media esponenziale, `lag ≈ (N−1)/2` barre, applicata ai due periodi.]**

| media | ritardo ≈ (N−1)/2 | su M1 |
|---|---:|---:|
| EMA(9) | 4,0 barre | **4 minuti** |
| EMA(21) | 10,0 barre | **10 minuti** |

👉 **Il conto che deve vedere Claudio:** il collega vuole **entrare al minuto
15:36** e **uscire dopo 3-4 minuti** — cioe' **essere fuori entro le 15:39-15:40**.
Un incrocio 9/21 su M1 **e' una funzione di prezzi vecchi fino a 10 minuti**:
alle 15:36 le due medie stanno ancora digerendo **il pre-apertura**, cioe' la
fase piatta prima delle 15:30. **Nella finestra in cui il collega vuole
operare, il 9/21 su M1 tipicamente NON si e' ancora incrociato**; quando si
incrocia, la finestra di 4 minuti e' finita.

🔴 **Quindi: come CONFERMA d'ingresso alle 15:36 il 9/21 su M1 e'
strutturalmente in ritardo.** ⚠️ **Attenzione pero' a non fare l'errore
opposto**: questo e' un ragionamento, **non una misura**. La misura c'e' e
costa poco — **e la faccio scrivere in §8 come domanda al banco**, perche' il
motto di casa dice di cercare la misura, non di chiudere con un'inferenza.

🟢 **E c'e' una versione del 9/21 che il ritardo NON ce l'ha, ed e' quella da
misurare**: non l'**incrocio**, ma **lo STATO** delle due medie **gia'
allineato** alle 15:30 come **filtro di lato** — cioe' *"entro solo dalla parte
in cui EMA9 sta gia' sopra EMA21"*. 🎯 **E questa non e' una mia invenzione: e'
scritta da anni nel nostro `REGISTRO_TEST.md` r.230 e r.250**, dalla voce dei
docenti: _"medie 9/21 INCLINATE nella direzione"_ (non incrociate: **inclinate**).
👉 **La casa aveva gia' la forma giusta della stessa idea, e nessuno l'ha mai
misurata sull'oro.**

---

## 6. 🔧 IL PUNTO STRUTTURALE — perche' questa NON e' (del tutto) la famiglia gia' chiusa

Va detto con precisione, perche' e' la differenza fra "gia' morto" e "mai
misurato", e il protocollo di casa distingue le due cose.

**Cosa dice il verdetto chiuso** (`REGISTRO_TEST.md` r.40, **26/07/2026**):
> _"capitolo BREAKOUT M5 CHIUSO. Provati e morti in real-tick: Live5m,
> Live5m_v2, DAX_M3, aperture Nasdaq, ORB_Fibo, Londra_ORB. Il breakout in
> apertura su M5 NON ha edge sul tick vero."_
E **R45**: ORB di sessione **su XAUUSD** (Londra) = **0 celle positive su 48**.

**Cosa e' identico** nella ricetta del collega: e' un breakout di un range di
apertura. 🔴 Non giriamoci intorno: **la famiglia e' quella.**

**Cosa e' DIVERSO, e sono tre cose verificabili:**

| | famiglia chiusa (nostra) | ricetta del collega |
|---|---|---|
| **evento** | apertura Londra (R45, oro) / aperture indici | **apertura cash USA 09:30 ET** — mai misurata sull'oro in casa |
| **uscita** | **SL / TP a multiplo di R**, si tiene per ore | ⚠️ **uscita a TEMPO: 3-4 minuti** |
| **oggetto raccolto** | la tendenza della giornata | **il primo impulso**, e basta |

🎯 **L'uscita a tempo e' la vera differenza, e cambia la natura dell'oggetto.**
Un ORB con TP a 2R scommette che la giornata continui; **un'uscita dopo 4 minuti
scommette solo che l'impulso di apertura abbia inerzia per 4 minuti.** Sono due
ipotesi di mercato diverse, e la seconda **non e' fra le ~210 celle chiuse il
26/07**.

🔴 **MA — e qui la grinta non tocca i numeri — questa differenza NON e' un
lasciapassare.** Un'uscita a 4 minuti **incassa un movimento piu' piccolo**
pagando **lo stesso identico pedaggio** di andata e ritorno. Rispetto alla
famiglia chiusa, **il rapporto segnale/costo peggiora, non migliora**. Il §3.1
e il §3.2 dicono esattamente questo con dei numeri. 👉 **Quindi la porta e'
socchiusa per il MECCANISMO, non per l'ottimismo**, e si apre solo se passa il
cancello aritmetico del §8.

### 🔁 REGOLA DELLA SECONDA CACCIA (19/08) — meccanismi alternativi, non parametri
Come da regola, se il breakout secco non regge **non propongo altri parametri
dello stesso motore**. Le alternative **sulla stessa inefficienza**, ordinate
per quanto costa misurarle:

| # | meccanismo alternativo | perche' proprio questo | supporto esterno |
|---|---|---|---|
| **A1** | 🎯 **misurare l'AMPIEZZA prima della direzione**: quanto vale, in dollari, la candela M5 delle 14:30 srv | **decide se l'idea esiste**: se la mediana < 9,6 $ e' fuori per costo | il "cost gate" di §4.4 e i due studi di §3.1-3.2 |
| **A2** | **FADE della prima spinta** invece del breakout | e' il rovescio esatto; e la casa e' **quasi tutta long/trend**: riempirebbe un buco vero | ⚪ trovato solo materiale non apribile (optionalpha, 403) |
| **A3** | **filtro di STATO 9/21 gia' allineate** alle 15:30 (non l'incrocio) | toglie il ritardo strutturale di §5.2 ed e' **gia' scritto in casa** (r.230 _"inclinate"_) | 🟢 la voce dei docenti nel nostro `REGISTRO_TEST.md` |
| **A4** | **range piu' lungo** (15:30-15:45 = 14:30-14:45 srv) con **stessa uscita a tempo** | uno stop 3× piu' largo **entra nel pavimento di lavoro**; e la fonte migliore (Zarattini) usa 5 min, non 1 | §3.1, §3.3 |
| **A5** | **ingresso su RITRACCIAMENTO al livello** invece che a mercato | **e' il rimedio diretto allo slippage**, e in casa e' gia' regola (r.230: _"se apre lontano → entra sul RETEST, mai inseguire"_) | §3.1 (il pareggio sta a 1 centesimo di esecuzione) |
| **A6** | **saltare i giorni con macro alle 08:30 ET** (= 13:30 srv) | separa l'evento vero dal residuo di news di un'ora prima | la letteratura sulle news e' il driver n.1 dell'oro |

⚠️ **A2-A6 sono DIREZIONI, non candidati.** Nessuna di esse ha oggi un numero:
non le porto all'imbuto finche' A1 non ha risposto.

---

## 7. 🕳️ COSA NON HO POTUTO VEDERE — l'elenco, senza scuse

| cosa | perche' | quanto pesa |
|---|---|---|
| 🔴 **PLOS ONE 2017, "Stylized facts of intraday precious metals"** | PLOS + PMC + EuropePMC + DOAJ + ResearchGate + PubMed + SemanticScholar **tutti 403** | 🔴🔴 **il buco piu' grave**: e' la fonte che misura periodicita' **e spread** dell'oro a 5 minuti |
| 🔴 **Tesi DiVA: ORB sui futures oro (GC)** | `diva-portal.org` 403 (registrato in `recentRelayFailures`) | 🔴 l'unico lavoro accademico ORB **su GC** individuato |
| 🔴 **Holmberg/Lönnbark/Lundström, "Assessing the profitability of intraday ORB"** | `econ.umu.se` 403, ScienceDirect 403 | 🔴 il paper ORB piu' citato dopo Zarattini |
| 🔴 **Zarattini & Aziz 2023 (SSRN 4416622) in originale** | SSRN 403 su tutto | 🟡 attenuato: ho letto la **replica**, che per noi vale di piu' |
| 🔴 **EFMA 2024, co-jump sull'oro** | `efmaefm.org` 403 | 🟡 |
| 🔴 **tradingstats.net (6.142 giornate ES/NQ, tassi di continuazione) · danfin.net · optionalpha · quantifiedstrategies · cxoadvisory** | 403 dal proxy | 🟡 **numeri visti solo negli estratti dei motori: NON li riporto come prova.** Ce n'erano di ghiotti (continuazione 58,6% col range 5 min, asimmetria long/short di 8-10 punti): **da riverificare, non da usare** |
| 🔴 **GitHub: la RICERCA** | API `search/repositories` **403 di policy** | 🟠 ho potuto solo **aprire** repo trovati da altrove: **GitHub NON e' stato setacciato** |
| 🔴 **Quantpedia: la RICERCA** | due query diverse → **file identici, 133.782 byte** | 🟠 le pagine strategia si aprono, ma **non so trovarle** |
| 🟠 **I `.mq5` di `gold-pro-scalper`** | letto solo il README; `/tree/main` risponde **404** (nome del ramo diverso) | 🟠 il "cost gate" e' **[VERIFICATO dal README]**, non dal codice |
| 🔴 **Lo spread BCM sull'oro alle 14:30 SERVER** | **non misurato in repo** — e' il buco che questa casa si porta dietro dal 25/08 | 🔴🔴 **e' il cancello zero di tutto §8** |
| 🔴 **La profondita' TICK di XAUUSD su BCM** | `REGISTRO_TEST.md` r.574: _"mai stata misurata"_ | 🔴 senza questa, `@DAQUANDO` **non si puo' scrivere** |

---

## 8. 🎯 LA DOMANDA A CUI IL PRIMO TEST DEVE RISPONDERE

Non e' *"il metodo del collega guadagna?"*. E' **una domanda di aritmetica che
viene prima**, costa mezz'ora di macchina e **puo' chiudere il caso da sola**:

> ## 🥇 **"Sull'oro, la candela M5 delle 14:30 SERVER (= 15:30 italiane = 09:30 ET), quanto e' larga in DOLLARI — mediana e primo quartile — e quella larghezza sta sopra il pavimento DI LAVORO di 9,6 $ (= 40 × lo spread misurato di 0,24 $) oppure no? E i 4 minuti successivi, quanto percorrono LORDI nella direzione della rottura?"**

**Perche' proprio questa, e in questo ordine:**
1. 🧱 **Lo stop del collega E' quel range.** Se la mediana della larghezza sta
   sotto **9,6 $**, il metodo nasce dentro la zona in cui il pedaggio comanda —
   e sotto **3,2 $** (pavimento **duro**) e' fuori **matematicamente**, senza
   che serva discutere di direzione.
2. 📏 **Il secondo pezzo (quanto percorrono 4 minuti) e' il numeratore.** Il
   confronto che decide e' **quello di §3.2**: *movimento lordo* contro
   *attrito*. Su MNQ ha dato **0,07-1,50 punti contro 2**. **Se sull'oro alle
   14:30 srv da' lo stesso segno, il caso e' chiuso e lo diciamo a Claudio con
   il numero in mano** — che e' molto meglio di un backtest rosso fra tre giorni.
3. 🕐 **E si misura in ORA SERVER, `14` e `30`.** Chi scrive `15:30` misura le
   16:30 italiane e ci racconta un altro mercato (§1).

### 📋 Blocco per il file prova — **NON lo creo io**, la misura e' di un altro agente
Lo lascio qui pronto, con la riga che **non ho il diritto di riempire**:
```
# IPOTESI: sull'oro, la candela M5 delle 14:30 SERVER (apertura cash USA)
#   produce un impulso la cui ampiezza LORDA nei 4 minuti successivi supera
#   il costo di andata e ritorno, e la rottura del range di 5 minuti ne
#   indica la direzione.
# CRITERI DI ACCETTAZIONE (congelati PRIMA dei numeri):
#   C1 [COSTO]   mediana della larghezza del range M5 14:30-14:35 srv >= 9,6 $
#                (= 40 x spread misurato 0,24 $).  Sotto 3,2 $ = SCARTO SECCO.
#   C2 [SEGNALE] percorso lordo mediano nei 4 minuti dopo la rottura
#                >= 3 x costo andata/ritorno misurato NELLA STESSA ORA.
#   C3 [LATI]    misurati SEMPRE tutti e due (regola di casa, 25/08).
#   C4 [CAMPIONE] >= 150 operazioni, altrimenti sospensione del giudizio
#                sul MERITO (il RISCHIO si giudica lo stesso).
@SIMBOLO  XAUUSD
@PERIODO  M1
@DAQUANDO             <- 🔴 VUOTO DI PROPOSITO. La profondita' TICK di XAUUSD
                         su BCM NON e' mai stata misurata (REGISTRO_TEST r.574).
                         Si misura con scarica_storico.ps1. NON si inventa:
                         sugli indici il driver diceva 2024.01.01 e i dati
                         partivano dal 26/09/2024.
```

---

## 9. 🏛️ IN OTTICA PROP — una riga, e non e' lusinghiera

- 🟢 **A favore:** **una** operazione al giorno, **una** direzione, uscita entro
  4 minuti. Rischio giornaliero strutturalmente contenuto: **un solo SL da
  0,65% e' 1/7,7 del cap giornaliero da 5.000 $ su 100k.** Nessuna esposizione
  overnight. **Come forma, e' compatibile con una challenge.**
- 🟢 **Scorrelazione:** riempirebbe una fascia oraria (**14:30-14:40 srv**) su un
  **simbolo** dove oggi abbiamo motori **H1/H4** (SupRev, EMA200), non intraday.
  Le due sedie `ABTG_ORB` stanno **sui 5 minuti prima** e su **indici**, non
  sull'oro. **Il buco esiste ed e' vero.**
- 🔴 **Contro, e pesa di piu':** e' un motore la cui vita dipende **dal costo di
  esecuzione**, cioe' dalla variabile **peggio controllata** in una prop (fill,
  slippage, allargamento dello spread all'apertura). §3.1 misura che il margine
  puo' essere **di un centesimo**. **Un motore cosi' non e' fragile ai mercati:
  e' fragile al broker.** In una challenge e' il tipo di fragilita' che non si
  vede nel backtest e si vede nell'estratto conto.
- 🔴 **E il DD trailing:** un motore a un trade/giorno con vincite piccole ha
  **lunghi ritorni dal picco**. E' proprio la forma che il DD trailing punisce,
  e le nostre Monte Carlo sono tutte su **DD statico dal deposito**. Segnalato,
  come da protocollo.

---

## 10. ✍️ CONCLUSIONE IN QUATTRO RIGHE

1. 🔴 **L'effetto NON e' documentato**: sull'oro alle 09:30 ET non ho una sola
   misura pubblica in mano, e le quattro fonti che l'avrebbero sono murate.
2. 🔴 **Il contro-argomento SI' ed e' quantificato**: 138.639 → 4.860 $ con
   slippage realistico; 0,07-1,50 punti lordi contro 2 di attrito.
3. 🟡 **Il codice esiste ma non fa quella cosa**: nessuno dei 5 sorgenti letti
   ha **finestra 09:30 ET + uscita a tempo**; uno ha perfino la **descrizione
   che non corrisponde al codice**.
4. 🟢 **E la mossa giusta non e' un backtest: e' un righello.** Misurare la
   larghezza della candela M5 delle 14:30 srv contro il pavimento di 9,6 $.
   **Costa mezz'ora e puo' rispondere a Claudio prima di cena.**

> 🔥 **Non ci accontentiamo — e infatti non archivio niente.** Qui non c'e' un
> numero BRUTTO: c'e' un numero **MANCANTE**, e per la regola di casa del 09/09
> quello vuol dire *"non ancora misurato"*, non *"morto"*. La via piu' corta al
> numero e' scritta in §8. 💪

