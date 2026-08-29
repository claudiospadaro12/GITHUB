# CACCIA — MOTORI A TF BASSO (priorita' M1, poi M5/M15) — 29/08/2026

**Mandato (sessione principale, 29/08):** _"dobbiamo avere piu'
EA/strategie/motori a TF basso, anche M1 oltre che M5 e M15. Dobbiamo
farcela."_ Obiettivo: piu' frequenza di operazioni per accorciare i giorni di
passaggio della challenge prop. **M1 e' la priorita' (dimensione MAI battuta
prima).** Mercati: indici / forex major / oro.

---

## IL RISULTATO IN UNA RIGA

> **Su 5 fonti passate al controllo positivo (arXiv, MQL5 Code Base,
> TradingView, GitHub-via-WebFetch, motore di ricerca web), ho letto nel
> sorgente 4 oggetti a bersaglio M1 (1 `.mq5` Code Base, 2 repo GitHub di cui
> 1 `.mq5` completo, 1 Pine ES-1m) + letto le README di 3 repo GitHub + 2
> interrogazioni arXiv. Arrivano al sorgente 4 candidati. Ne PROMUOVO ZERO a
> "prova subito". UNO va IN CODA con caveat pesante. Il resto e' SCARTO.**
>
> **La risposta scomoda, e va letta due volte: M1 e' una TRAPPOLA DI COSTO
> strutturale su questi strumenti, e i due poli falliscono entrambi.** Chi
> opera spesso su M1 si fa mangiare dai costi (l'EA `snipe-fx-ea` misura sul
> tick reale, di suo pugno, **payoff atteso costante −0,31 per trade** — lo
> stesso identico numero del nostro R98). Chi mette un gate stretto abbastanza
> da sopravvivere ai costi (`gold-pro-scalper`, cost gate StdDev>=3x e TP>=4x
> il costo) **opera raramente, e cosi' distrugge il motivo stesso per cui si
> scende a M1.** E l'unico segnale M1 davvero nuovo in letteratura — l'**order
> flow imbalance** — ha predittivita' direzionale ma **richiede il book di
> livello 2**, che BCM su CFD/forex NON espone (solo tick volume).
>
> **La conseguenza operativa per la challenge e' la stessa gia' scritta il
> 25/08: la frequenza NON la compreremo scendendo a M1. Va presa con PIU'
> SIMBOLI a M15-H1**, dove i motori sono vivi. Il gradiente misurato in casa
> lo dice senza ambiguita': **H1 > M30 > M15** (R108/R111), e M1 e' l'estremo
> di quel declino.

---

## 0. IL CIMITERO RILETTO — il metro di scarto di questa caccia

Letti PRIMA di uscire: `REGISTRO_TEST.md` (intero), le due cacce low-TF del
25/08 (`CACCIA_M5M15_INDICI` e `CACCIA_M5M15_FOREX_ORO`), le tre cacce del
26-28/08 (`CACCIA_SMC_OB_FVG`, `CACCIA_INTRADAY_INDICI`,
`CACCIA_INTRADAY_FOREX_ORO`), e i referti R108 / R109 / R111.

### Le mura strutturali (misurate in casa e fuori) che governano M1

| muro | dove | numero |
|---|---|---|
| **Gradiente di TF: l'edge si consuma scendendo** | R108 + R111 (BreakingBand, stesso motore, unico input diverso = `InpTF`) | **H1 > M30 > M15, monotono su 3 simboli.** M15: 6 finestre su 6 rosse (PF 0,64-0,87). M30: solo GBPUSD OOS PF 1,087. H1: PF 1,20-1,94 |
| **Soffitto del costo su M5 OHLCV** | arXiv 2605.04004 §6.1 (Mesfin 2026, 14 famiglie su MNQ) | _"max achievable gross return before friction ~**1,05-1,50 punti**... the **2,0-point friction cost consistently exceeds this**"_ |
| **Fade/MR a basso TF senza regime = morto** | R60 `ABTG_MeanRevert` | **12 celle su 12 in perdita** |
| **Gated exhaustion+volume su indici basso TF = morto** | R109 (ATR Exhaustion & Volume Spike, tick reali) | **DD 44-68%**, peggior giornata **−9,72%**. BOCCIATO senza appello |
| **MR intraday sull'oro = falsificato** | 23/08 §S15 (OU su micro gold futures) | tutte le config FAIL, T da −1,12 a **−4,49**; half-life di reversione **~8 ore** > una sessione RTH |
| **Intraday momentum a orario fisso = morto** | R98 | **−0,31 punti/trade** su 410, gia' al netto dello spread |
| **Volume affidabile solo su indici, NON su FX/oro** | `REGISTRO_TEST.md` §Paolo + arXiv 2605.04004 §4.5 | su FX/CFD MT5 e' **tick volume** (n. variazioni di prezzo), non contratti |
| **Breakout/ORB d'apertura a basso TF** | `REGISTRO_TEST.md` §2, ~210 celle | **CHIUSO 26.07.26** a tick reali |

**Nessuno di questi si ammorbidisce per M1: M1 li aggrava tutti.** Su M1 il
rapporto attrito/edge e' strettamente peggiore che su M5; il gradiente H1>M30>M15
proietta M1 sotto M15; la MR sull'oro (l'unico bersaglio M1 con "take grasso")
e' gia' falsificata.

---

## 1. CONTROLLO POSITIVO — fonte per fonte, misurato oggi

| fonte | strumento | bersaglio noto verificato | esito |
|---|---|---|---|
| **MQL5 Code Base** | WebFetch + WebSearch | la scheda `/en/code/76331` rende titolo `HybridMicrostructure EA`, autore **`RitzFalih`**, data **2026.08.19** (dalla ricerca); il listato experts rende titoli reali (Market Replay Tool, Daily Zone Recovery EA...) | **PASSA** (titolo+autore+data presenti) |
| **arXiv API** (`export.arxiv.org`) | WebFetch | `cat:q-fin.TR AND abs:intraday` rende entry recenti reali con data (es. *Hidden Order in Trades*, 2025-12-02) | **PASSA** — sterile sul bersaglio (vedi §4) |
| **TradingView** | WebSearch | rende link `/script/` + titoli e repo Pine open source | **PASSA** (canale gia' documentato 25/08 §1-bis; endpoint di ricerca 28/08 §1-bis) |
| **GitHub** | **WebFetch** (NON curl) | `github.com/topics/expert-advisor?l=mql5` rende repo, descrizioni, stelle, date. `raw.githubusercontent.com` rende i sorgenti | **PASSA per lettura** (come da scoperta 28/08). ⚠️ `api.github.com` = **403** (invariato) |
| **Motore di ricerca web** | WebSearch | rende link reali con titolo/URL | **PASSA** |

**Note oneste sul controllo positivo:**
- La lettura WebFetch del listato Code Base ha reso i **titoli** ma non
  autori/date in quella singola chiamata (limite della sintesi del modellino);
  autori/date sono confermati dalla ricerca sul singolo id. Tratto MQL5 come
  **PASSA** perche' su `/code/76331` ho titolo+autore+data.
- **GitHub e' leggibile via WebFetch** (repo, topic, raw), **non** via
  `api.github.com` (403) ne' `gh` (non installato in questo ambiente).

---

## 2. I CANDIDATI LETTI NEL SORGENTE — quattro, e perche' non passano

### IN CODA (con caveat pesante) — `gold-pro-scalper` / "N30 Gold Reversion EA"

```
NOME            XAU_Quant_Reversion_TickRobust.mq5  (+ 3 varianti nel repo)
FONTE / URL     https://github.com/n30dyn4m1c/gold-pro-scalper  (branch master)
AUTORE          n30dyn4m1c   ·   ultimo update ~2026-08-06   ·   14 stelle
LICENZA         MIT  [VERIFICATO: file LICENSE nel repo, README "MIT License"]
                => commerciale OK, attribuzione a n30dyn4m1c in testa a qualunque derivato
RIGHE / INPUT   34 input (variante TickRobust)  [VERIFICATO leggendo il .mq5]
COPIA IN CASA   DA ARCHIVIARE: 4 file .mq5 alla radice del repo (TickRobust,
                Breakout, m1_EveryTick, m1_OLHC). NON archiviati qui: WebFetch
                restituisce una sintesi, non i byte esatti -> scaricare col
                download tool prima di committare la copia in biblioteca
```

**TESI IN UNA RIGA**
> _"Quando l'oro si spinge oltre 2,2 deviazioni standard dalla sua media a 20
> barre e SMETTE di allungarsi in quella direzione, in un mercato non-trending
> (ADX<22) e allineato al trend H1, il ritorno verso la media paga — ma solo
> se quel ritorno vale almeno 4 volte il costo di andata e ritorno."_

**MECCANICA — letta nel sorgente `.mq5`, riga per riga**
1. **Ingresso (il motore):** `z1 = (close[1] - SMA20[1]) / StdDev20[1]`; BUY se
   `z1 <= -2.2`, SELL se `z1 >= 2.2`. **Conferma di svolta anti-coltello**
   (`InpRequireTurn`): non entra se la barra chiusa fa ancora progresso nella
   direzione dello stiramento.
2. **I gate costitutivi (tutti in AND, decisi su barra chiusa, una volta a
   barra):** ADX(14) chiuso `<= 22` (fade solo nel non-trend) · allineamento
   con SMA(50) su H1 · rapporto ATR corrente/ATR medio(50) dentro [0,4 ; 2,0]
   (niente spike, niente mercato morto) · **COST GATE**: `StdDev >= 3x costo`
   **e** `distanza dalla media (TP) >= 4x costo`, dove `costo = spread +
   InpExtraCostPts`.
3. **Uscita:** TP limite **sulla media** lato server · SL reale al broker =
   `max(800 punti, 2,5x ATR)` · breakeven a 1 ATR · uscita a tempo a 40 barre ·
   uscita di riserva a `z` che rientra sotto 0,2. **Una posizione al massimo.**
   Sessione 10-20, cooldown 15', filtro news, daily-loss 15%.

**BANDIERE ROSSE §4 / §C3: NESSUNA.**
Rischio in %, SL reale al broker, decide su barra chiusa (niente repaint), una
posizione, niente martingala/griglia/averaging, zero dipendenze esterne, zero
WebRequest/DLL. **E' l'unico oggetto M1 trovato in tutta la caccia che passa
il §4 pulito.**

**IL PEZZO CHE VALE — il cost gate (spunto da rubare, comunque vada)**
```cpp
double costPts = spreadPts + InpExtraCostPts;
if(sdPts   < InpMinSDCostMult * costPts) return;   // StdDev >= 3x costo
if(tpDistPts < InpMinTPCostMult * costPts) return; // TP alla media >= 4x costo
```
E' **esattamente la lezione R55** (_"lo spread va letto in percentuale dello
stop"_) messa **a monte**, come porta d'ingresso invece che come contorno.
Combacia con la nostra critica al costo su M5 e con la modellazione dello
spread lodata in P1 (VWAP MeanReversion, 25/08). **Questo design pattern —
cost gate + regime ADX + closed-bar-only + SL reale — e' la cosa piu' utile
uscita da questa caccia, e vale su QUALUNQUE motore a basso TF, soprattutto
sugli indici** (dove il volume/regime funziona e le half-life di reversione
sono diverse da quelle dell'oro).

**PERCHE' NON E' "PROVA SUBITO" — la parte onesta**

Il MOTORE (fade MR intraday sull'oro a M1) e' su terreno **falsificato tre
volte**, e i gate non lo salvano:
- **S15 (23/08):** MR intraday sull'oro gia' falsificata (OU su micro gold
  futures, tutte FAIL, T −1,12..−4,49). L'argomento e' strutturale, non di
  taratura: **half-life di reversione ~8 ore**. Un fade M1 che spera nel
  ritorno entro 40 minuti scommette CONTRO la half-life misurata.
- **R60:** il fade dell'estremo a N barre e' 12/12 in perdita. Qui i gate sono
  piu' ricchi, ma il gradino R109 (ATR Exhaustion, che aveva anch'esso regime
  + soglie) e' morto DD 44-68% su indici: **gated mean-reversion a basso TF ha
  un pessimo curriculum in casa.**
- **Contraddizione di frequenza:** il cost gate e' severo. Sull'oro lo spread
  e' largo; StdDev>=3x e TP>=4x quel costo, in AND con ADX<22, allineamento
  H1, ATR-ratio, svolta e sessione, fanno sparare **raramente**. Un motore
  cosi' filtrato **non consegna la frequenza M1 che e' il motivo del mandato.**

> **VERDETTO: IN CODA, 6/10.** Miglior oggetto M1 trovato (MIT, SL reale,
> rischio%, cost-gate), ma motore su inefficienza falsificata e frequenza
> auto-limitata. **La domanda che UNA passata chiuderebbe con un numero:**
> _"il cost-gate + regime ADX resuscita la MR intraday sull'oro dove R60/S15
> l'hanno sepolta, o produce l'ennesimo −0,3/trade?"_ Attesa strutturale: no
> (half-life 8h). Ma e' una passata, e chiuderebbe la porta M1-oro-MR con un
> referto, come R98 ha chiuso l'intraday momentum. **Se si testa: forzare
> `InpUseDynamicRisk=false`, `InpRiskPct=0.65`** (i tier dinamici di default
> 10%/7%/5%/3%/1,5% sono da conto bruciato) e **PASSO 0 = misurare take medio
> realizzato vs spread BCM oro PRIMA di leggere il PF.**

**RIGA PROP.** Fade controtendenza gated: pochi segnali, scorrelati per
costruzione dalle sedie direzionali. MA sull'oro la **concentrazione e' gia'
altissima** (12 grafici, R100 ha tagliato 3 sedie oro): se mai passasse,
entra al posto di qualcosa, non in piu'. Il rischio vero e' la stessa parete
di R109: una serie di stop del fade in un trend forte dell'oro.

---

### SCARTO 1 — `HybridMicrostructure EA` (Code Base 76331): il bersaglio esatto, disqualificato alla radice

- **Fonte:** https://www.mql5.com/en/code/76331 · autore **RitzFalih** ·
  **2026.08.19** · XAUUSD **M1**, microstruttura tick-level.
- **Perche' e' interessante:** e' letteralmente il bersaglio del mandato
  ("microstruttura/order-flow su M1"). Cuore deterministico non banale: ring
  buffer da **500 tick**, VWAP + bande di deviazione standard in tempo reale,
  tick velocity, opzione rischio-%, SL ATR, breakeven/trailing, niente
  martingala.
- **Perche' e' SCARTO §4 / §C3 senza appello:** manda una **WebRequest POST a
  un server Python/FastAPI locale** (`http://127.0.0.1:8787/analyze`), in
  **formato OpenAI-compatible** (`messages`, `role: system/user`), e aspetta
  `decision/confidence/reason`. **La decisione di trading e' delegata a un LLM
  esterno.** E' rete + scatola nera di terzi + **non backtestabile** (la
  WebRequest non funziona nello Strategy Tester). Il §4 lo vieta due volte.
- **Spunto tenuto agli atti:** il core deterministico (VWAP-su-500-tick +
  bande) e' teoricamente estraibile, ma atterra su meccanismi gia' sepolti
  (VWAP MR sull'oro + sweep-rejection = R95) e richiede profondita' tick BCM
  sull'oro **mai misurata**. Non lo rincorro.

### SCARTO 2 — `snipe-fx-ea` (GitHub, NadirAliOfficial): il web che riproduce il nostro R98

- **Fonte:** https://github.com/NadirAliOfficial/snipe-fx-ea · M1 tick scalp ·
  ~3 stelle · licenza **non dichiarata**.
- **Meccanica:** arma stop virtuali a **2 pip** dal prezzo, ri-armati ogni 5s,
  con filtro EMA di trend. Stop di lavoro **virtuale** (in memoria) + stop
  "disaster" reale al broker.
- **SCARTO, tre motivi:** (a) **lotto fisso** `LotSize=0.01` (non scalabile a
  100k); (b) **stop virtuale/stealth** (§4); (c) — il piu' istruttivo — il
  test dell'autore **sul tick reale** dichiara _"Expected payoff is a constant
  **−0,31 per trade** across parameter variations... transaction costs
  dominate."_ **E' lo stesso identico numero del nostro R98** (−0,31 punti):
  un web indipendente ha misurato il polo "opera spesso su M1" e ha trovato la
  stessa morte per costo.

### SCARTO 3 — `best-strategy-es-1m.txt` (GitHub, dearvn): M1 su indice, repaint + zuppa

- **Fonte:** https://github.com/dearvn/trading-futures-tradingview-script
  (`best-strategy-es-1m.txt`) · Pine · ES **1 minuto**.
- **SCARTO, §4 + §5C:** usa `request.security(... lookahead=barmerge.lookahead_on)`
  = **look-ahead / repaint** (future-leak nei backtest). Piu' **nessuna tesi**:
  confluenza di WMA 13/48/200 + RSI(3) + Pivot + Supertrend(CCI) + MACD +
  delta volume + aggregazioni multi-TF 11m/12m/60m = fabbrica di combinazioni.
  Stop 10% del prezzo, nessun sizing. Non misurabile.

### Letto in README, non nel sorgente (dichiarato) — `eurusd-scalper-ea`

- https://github.com/NadirAliOfficial/eurusd-scalper-ea · **M5** EURUSD · 16
  stelle. EMA cross + RSI + ADX + filtro trend H1, auto lot, breakeven/trailing.
- **Non promosso, non aperto nel sorgente:** e' **M5 (non M1)** ed e' lo schema
  **filtro appiccicato a un cross di medie** (0/5 in casa: R20/R12/R26/R45/R54).
  Titolo e descrizione bastano per il primo taglio; se qualcuno lo riapre,
  legga prima il sorgente per confermare lo schema.

---

## 3. LA LETTERATURA M1 — l'unico segnale nuovo, e perche' non lo possiamo usare

- **Order Flow Imbalance (OFI)** — la letteratura (arXiv 2408.03594 e affini,
  2024-2026) mostra una relazione **quasi lineare** fra sbilanciamento del
  flusso ordini e variazione di prezzo a breve orizzonte, **con direzione**.
  E' il candidato-motore M1 piu' serio che esista. **MA richiede il book di
  livello 2** (volumi netti bid/ask del limit order book). **BCM su CFD/forex
  NON lo espone**: MT5 da' solo **tick volume**. Non implementabile sui nostri
  dati. **Porta chiusa dai dati, non dal metodo.**
- **"Hidden Order in Trades Predicts the Size of Price Moves"** (arXiv,
  2025-12-02) — entropia dell'order flow su SPY a **risoluzione secondo**;
  predice la **magnitudine**, **non la direzione**. Non e' un motore
  direzionale, e usa dati a risoluzione secondo che non abbiamo.
- **arXiv q-fin intraday recente:** per il resto e' microstruttura di
  esecuzione, forecasting di volatilita', RL, pricing opzioni. **Zero regole
  di trading M1 direzionali traducibili sui nostri strumenti.** Terza/quarta
  caccia consecutiva con lo stesso esito.

**La convergenza e' netta e va scritta: ogni meccanismo M1 con un edge
direzionale documentato (OFI, tick microstructure, order-flow entropy)
dipende da un dato — book L2 o volume reale o risoluzione sub-minuto — che
questo broker non ci da'. Cio' che resta a M1 sui NOSTRI dati (OHLC + tick
volume) e' precisamente cio' che le mura del §0 dichiarano morto.**

---

## 4. COSA NON HO POTUTO VEDERE — dichiarato

| non visto | conseguenza |
|---|---|
| Il **sorgente esatto (byte)** del TickRobust per archiviarlo in biblioteca | WebFetch da' una sintesi fedele ma non i byte. Archiviazione rimandata al download tool. Le citazioni di codice nella scheda IN CODA sono verificate ma non sono un file |
| **api.github.com** (403) e **`gh`** (non installato) | ho listato i repo via WebFetch su `github.com` e letto i raw via `raw.githubusercontent.com`. La ricerca strutturata su GitHub API resta chiusa |
| **Forex Factory / SSRN** | non interrogate qui: mute da sei cacce (403). Restano il buco su "come invecchia un sistema M1" |
| **Lo spread BCM su oro/indici a M1** | tuttora non misurato in repo. E' il PASSO 0 di qualunque test M1 (lo strumento e' il Code Base 74148, promosso 23/08, mai usato) |
| Il **sorgente Pine** di eventuali strategie M1 su TradingView oltre l'ES-1m | non aperti uno per uno: la parete di costo del §0 li abbatte a monte, e le due cacce del 25-28/08 hanno gia' letto 400+ Pine low-TF con purezza bassissima |

---

## 5. LA DOMANDA A CUI IL PRIMO TEST (SE SI FA) DEVE RISPONDERE

> **"Il cost-gate + regime ADX del `gold-pro-scalper` (StdDev>=3x costo, TP
> alla media >=4x costo, fade solo con ADX<22) resuscita la mean-reversion
> intraday sull'oro a M1 — dove R60 (12/12) e S15 (half-life 8h) l'hanno
> sepolta — o produce l'ennesimo payoff ~−0,3/trade?"**

- **PASSO 0 (cancello zero):** misurare lo **spread BCM oro** (logger 74148) e
  il **take medio realizzato** a M1. Se il take medio < 3x lo spread -> il
  round si chiude qui, e la porta M1-oro-MR si chiude **con un numero**.
- **Solo se verde:** IS/OOS con i cancelli di casa, **rischio 0,65%**
  (`InpUseDynamicRisk=false`), cella al **centro dell'altopiano**, verdetto
  **SOLO a tick reali** (su M1 l'OHLC inganna piu' che mai).

**Ma la vera raccomandazione di questa caccia non e' quel test.** E':

> **La frequenza per la challenge NON si compra a M1. Si compra allargando i
> motori VIVI (SupRev, SuperWave, aperture DAX, night-box) a PIU' SIMBOLI allo
> stesso TF M15-H1**, dove l'edge esiste e il costo non lo mangia. Il gradiente
> H1>M30>M15 e i due poli falliti di M1 (snipe-fx −0,31 / gold-pro auto-gated)
> dicono che scendere di TF e' la direzione sbagliata. **Il design pattern del
> cost-gate va invece portato SUGLI INDICI**, non sull'oro M1.

---

_Dossier compilato il 29/08/2026 dall'agente cacciatore-strategie._
_Fonti aperte davvero: MQL5 Code Base (controllo positivo + sorgente
HybridMicrostructure 76331 letto via scheda), GitHub via WebFetch/raw (3 repo
listati, `gold-pro-scalper` TickRobust `.mq5` letto integralmente, `snipe-fx-ea`
README letto, `best-strategy-es-1m.txt` Pine letto), arXiv API (2 interrogazioni
+ letteratura OFI), motore di ricerca web (4 query)._
_Fonti/canali chiusi: api.github.com (403), `gh` (assente), Forex Factory/SSRN
(non interrogate, mute da sei cacce)._
_Nessun numero di performance dichiarato da un autore ha pesato su un punteggio.
Nessun EA nostro toccato, nessun parametro in forward modificato, nulla
committato (al commit pensa la sessione principale)._

_Attribuzione (da ripetere in testa a qualunque `.mq5` derivato):_
- _`gold-pro-scalper` / N30 Gold Reversion e' di **n30dyn4m1c** (GitHub), **licenza MIT**_
- _`HybridMicrostructure EA` e' di **RitzFalih** (MQL5 Code Base 76331)_
- _`snipe-fx-ea` e' di **NadirAliOfficial** (GitHub, licenza non dichiarata)_
