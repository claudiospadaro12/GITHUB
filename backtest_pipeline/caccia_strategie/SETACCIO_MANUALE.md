# 🔎 SETACCIO MANUALE — i file che porta Claudio a mano

Qui finisce il materiale che Claudio scarica di persona dal Code Base (o da
dovunque) e mi incolla in chat. Stesso setaccio dei dossier di caccia, stessa
regola: **una riga di motivo per ogni scarto**, cosi' non si ricontrolla due
volte la stessa cosa.

---

## 16/08/2026 — `ProAutoSL_DynamicTP.mq5` v2.10

**Autore:** Khaled — `https://www.mql5.com/en/users/bjmkhaled` · **[INCERTO]**
licenza e download: la pagina del Code Base non e' raggiungibile da qui.

### VERDETTO: 🟡 **FUORI IMBUTO — non e' una strategia, e' un attrezzo**

**Non apre nessuna posizione.** `OnTick()` e' vuoto per costruzione; tutto il
lavoro sta in `OnTimer()`, che ogni secondo cerca posizioni **gia' aperte**
senza SL/TP e gliene mette uno.

> Conseguenza secca: **zero ingressi = zero edge = niente da backtestare.**
> L'imbuto (IS/OOS, prova di regime, tick reali) non ha nulla su cui girare.
> Non e' una bocciatura di merito: e' che non e' il tipo di oggetto che
> l'imbuto misura.

### ✅ Cosa fa BENE — e va detto

- **Nessuna bandiera rossa del §4**: niente martingala, niente griglia, niente
  hedge, niente DLL, niente `iCustom` esterno.
- **Manda uno SL VERO al broker** (`trade.PositionModify`), non virtuale. Sta
  dalla parte giusta del 44% di EA del Code Base che lo stop non lo nominano.
- Rispetta `SYMBOL_TRADE_STOPS_LEVEL` e `SYMBOL_TRADE_FREEZE_LEVEL`.
- `SetAsyncMode(false)`, retry solo su retcode davvero transitori, input
  validati in `OnInit`. **Codice pulito e commentato.**

### 🔴 I QUATTRO DIFETTI, in ordine di quanto ci riguardano

**1. LA SCALA DEI PIP E' SBAGLIATA SU METALLI E INDICI — ed e' mascherata**

```cpp
const double pip_factor = ((digits==3 || digits==5) ? 10.0 : 1.0);
const double stop_loss_points = InpStopLossPips * pip_factor;
new_sl = open_price - (stop_loss_points * point);
```

| strumento | digits | 30 "pips" diventano |
|---|---|---|
| EURUSD | 5 | 0,0030 = **30 pip** ✅ |
| USDJPY | 3 | 0,300 = **30 pip** ✅ |
| **XAUUSD** | **2** | **0,30 USD** 🔴 con l'oro a 4.376 |
| **D30EUR / U30USD** | **1-2** | **3 punti indice** 🔴 |

E il pezzo insidioso: **non da' errore.** Il clamp sulla distanza minima
```cpp
if(minimum_distance>0.0 && tick.bid-new_sl<minimum_distance)
   new_sl = tick.bid - minimum_distance;
```
lo "aggiusta" piazzando lo stop **alla distanza minima consentita dal broker**
— cioe' **il piu' stretto possibile**. Non fallisce: mette un grilletto a pelo
di prezzo e lo fa in silenzio. **Su oro e indici e' il nostro caso d'uso.**

**2. IL DEFAULT TOCCA TUTTE LE POSIZIONI DEL SIMBOLO**

`InpMagicNumber = -1` (tutte) e `InpModifyManualTrades = true`. Attaccato a un
grafico del VPS, **modificherebbe anche le posizioni dei nostri EA vivi**.
🛑 **Sul VPS non ci va, ne' cosi' ne' per prova.**

**3. RIPROVA ALL'INFINITO, UNA VOLTA AL SECONDO**

Se il broker rifiuta con un errore NON transitorio, `ModifyPositionWithRetry`
restituisce `false` — ma la posizione resta senza SL, quindi al giro di timer
successivo (**1 secondo dopo**) rientra e ritenta altre 5 volte. Nessun
contatore, nessuna lista dei falliti: **5 tentativi al secondo per sempre**,
con il log che si riempie. Su un conto prop, traffico del genere e' il tipo di
cosa che fa alzare un sopracciglio.

**4. `Sleep()` DENTRO `OnTimer()`**

`InpMaxRetries=5` x `InpRetryDelayMs=1000` = fino a **5 secondi di blocco per
posizione**. Con piu' posizioni i ritardi si sommano, e l'EA resta fermo.

### 🧭 E per noi, in pratica

1. **Non serve alla flotta**: tutti i nostri EA mandano gia' uno SL vero al
   broker. Questo risolve un problema che non abbiamo.
2. **La rete di sicurezza ce l'abbiamo gia' e fa di piu'**: `ABTG_Guardian`
   con i preset FTMO (5%/10%, CHIUDI+BLOCCA) protegge **il conto**, non la
   singola posizione.
3. **Se un giorno servisse davvero** un salvagente per operazioni manuali, si
   riscrive: **SL in ATR o in percentuale di rischio** (mai in pip fissi),
   **whitelist di magic** invece di `-1`, retry con lista dei falliti e
   backoff, niente `Sleep` nel timer.

> ✅ **Ma il segnale importante e' un altro: la scelta e' buona.** Su un
> catalogo dove **522 file su 1.185 (44%) non nominano nemmeno lo stop loss**,
> Claudio ha pescato uno dei pochi scritti bene. **Continua a pescare cosi'** —
> serve solo che sia roba che **APRE** posizioni, non che le sistema.

---

## 16/08/2026 — `Mean_Reversion` v1.00 (AHARON TZADIK)

**Autore:** AHARON TZADIK · `https://5d3071208c5e2.site123.me/` · **[INCERTO]**
licenza e provenienza esatta: `mql5.com` non raggiungibile da qui.

### VERDETTO: 🔴 **SCARTO IMMEDIATO — MARTINGALA, e non compila su MT5**

Il nome dice "Mean Reversion". **Il codice dice martingala.** E' esattamente
il caso per cui la regola del mandato e' *"si scarta leggendo il SORGENTE, non
la descrizione"*.

### 💣 PROVA 1 — la martingala e' una riga sola, esplicita

```cpp
extern double LotExponent = 1.44;     //Lots size Exponent
input  int    Max_Trades  = 10;
...
double LOT = Lots * MathPow(LotExponent, CountTrades());
```

**Il lotto cresce di 1,44 volte per ogni posizione gia' aperta**, fino a 10.
Con `Lots=0.01`:

| livello | lotto |
|---|---:|
| 1 | 0,010 |
| 5 | 0,062 |
| 10 | **0,266** |
| **esposizione totale** | **0,85 lotti = 85 volte il lotto iniziale** |

E l'ingresso non chiede **nessuna** conferma che il prezzo si sia mosso a
favore: basta `CountTrades() < Max_Trades`. **Somma posizioni mentre perde.**

### 💣 PROVA 2 — c'e' una SECONDA martingala, nascosta nel sizing

```cpp
double LotsOptimized(double llots) {
   ...
   if(OrderSymbol()!=Symbol()) continue;   // <-- NESSUN filtro sul magic
   if(OrderProfit()<0) losses++;
   ...
   if(losses>1) lot = AccountFreeMargin()*IncreaseFactor/1000.0;
```

Il lotto **dipende dalle perdite consecutive nello storico**. E il conteggio
non filtra per magic: **conta anche le perdite dei NOSTRI altri EA** sullo
stesso simbolo.

### 🛑 PROVA 3 — sul nostro conto chiuderebbe le posizioni degli altri EA

```cpp
void RemoveAllOrders() {
   if(OrderSymbol() != Symbol()) continue;   // <-- e basta
   ... OrderClose(...)
```

`RemoveAllOrders()` chiude **tutto quello che sta sul simbolo**, senza
guardare il magic — e viene chiamata da `Take_Profit_In_Money()`,
`Take_Profit_In_percent()` e dal trailing in denaro. Su un conto con piu' EA
come il nostro **e' un'arma puntata sulla flotta**.

### ⛔ PROVA 4 — e comunque **e' MQL4, non MQL5**

`extern`, `#property strict`, `OrderSend(Symbol(),OP_BUY,...)`, `MarketInfo`,
`AccountFreeMargin()`, `RefreshRates()`, `MODE_STOPLEVEL`, `Bid`/`Ask`/
`Digits`/`Time[0]`, `iMA(NULL,L,8,0,MODE_LWMA,PRICE_TYPICAL,0)` con firma MQL4,
`HideTestIndicators`, `AccountStopoutMode()`.

> **Non compila in MetaEditor come `.mq5`.** Anche volendo ignorare tutto il
> resto, non c'e' niente da mettere sul tester.

### 🐛 E i difetti di mestiere, per completezza

1. **L'"equity high" non e' un high water mark** — ed e' proprio il concetto
   di `METRO_PROP.md`:
   ```cpp
   if(AccountEquityHighAmt<PrevEquity) AccountEquityHighAmt=PrevEquity;
   else AccountEquityHighAmt=AccountEquity();   // <-- puo' SCENDERE
   ```
   Il ramo `else` lo riporta all'equity corrente: **il "massimo" torna
   indietro.** L'EA dichiara uno stop sull'equity di picco e non ce l'ha.
2. **`NDTP()` confronta un PREZZO con una DISTANZA**:
   `if(val < StopLevel*pips + SPREAD*pips)` — `val` e' un prezzo (1,0850),
   il termine destro e' una distanza (0,0003). Il clamp non scatta mai; se
   scattasse, metterebbe lo stop a un prezzo di 0,0003. Stesso errore in
   `Trail1()`.
3. **Codice morto**: `OnInit()` fa `return(INIT_SUCCEEDED)` **prima** del
   blocco `freeze_level`, che quindi non viene mai eseguito.
4. **`L` non e' mai inizializzato** e viene usato come timeframe in tutte le
   `iMA()`. Vale 0 (PERIOD_CURRENT) per caso, non per scelta. E `T` resta 0
   sui timeframe W1 e MN.
5. **Condizioni decorative**: `if(Low[2]<High[1])` e `if(Low[1]<High[2])`
   sono vere quasi sempre. Non filtrano niente.
6. **Unita' confuse**: `CANDLE_TRIGER_OPEN = CandlesToRetrace * _Point` — una
   variabile che si chiama "numero di candele" moltiplicata per un punto.
7. **`Sleep(1000)` dentro il ciclo di chiusura**: chiudere 10 posizioni
   richiede 10 secondi. Durante uno stop-out.
8. `Close_All_Buy_Trades()` chiude anche i sell (copia-incolla), ed e' morta.

### 🧭 La lezione che vale oltre questo file

L'idea di fondo — **comprare la debolezza dentro un trend rialzista** — non e'
folle, ed e' persino imparentata con il buco del laterale che stiamo cercando
di coprire. **Ma non si recupera niente da qui**: la meccanica di ingresso e'
tre condizioni di cui due decorative, e tutto il resto e' una martingala con
un nome rassicurante.

> 🔴 **"Mean Reversion" nel titolo non vuol dire mean reversion nel codice.**
> Il setaccio si applica al sorgente, sempre. Questo file da solo copre due
> delle bandiere rosse piu' gravi del §4 — ed e' uno dei **219 su 1.185**
> (18,5%) che il grep del mirror aveva gia' classificato martingala/griglia.

---

# 📦 16/08/2026 — CINQUE FILE IN UN COLPO

| # | file | righe | autore | verdetto |
|---|---|---:|---|---|
| 1 | `BreakRevertPro.mq5` | 1.699 | Mustafa Seyyid Sahin | 🔴 **SCARTO** — cambia comportamento NEL TESTER |
| 2 | **`MeanReversion.mq5`** | **135** | Yashar Seyyedin | 🟢 **PROMOSSO 9/10** |
| 3 | `Mean Reverse.mq5` | 678 | Mustafa Seyyid Sahin | 🔴 **SCARTO** — stesso trucco del n.1 + lotto fisso |
| 4 | `RMA` (10 file) | 3.765 | — | 🟡 **IN CODA** — 44 input, lotto fisso |
| 5 | `BBStochRSIXReversal.mq5` | 617 | tshalgo | 🔴 **FUORI** — e' un INDICATORE, non un EA |

---

## 🟢 `MeanReversion.mq5` — **PROMOSSO, 9/10**

**Autore:** Yashar Seyyedin · `https://www.mql5.com/en/users/yashar.seyyedin` ·
header `Copyright 2025, MetaQuotes Ltd.` · **[INCERTO]** licenza esatta.

### TESI IN UNA RIGA
> Quando una barra segna il **minimo delle ultime 200**, il prezzo e'
> statisticamente lontano dal centro del proprio intervallo: si compra
> l'estremo e si punta al **punto medio del range**.

### MECCANICA — tutta qui, ed e' tutto il file

```cpp
if(PositionsTotal()>0) return;
if(iLowest (_Symbol, PERIOD_CURRENT, MODE_LOW,  lookback, 0)==0) Buy();
if(iHighest(_Symbol, PERIOD_CURRENT, MODE_HIGH, lookback, 0)==0) Sell();

double tp = Mean();          // (massimo + minimo delle 200 barre) / 2
double sl = 2*Ask - tp;      // simmetrico -> R:R esattamente 1:1
```

### PERCHE' E' IL MIGLIORE ARRIVATO FINORA

| criterio | punti | perche' |
|---|---|---|
| **semplicita'** | **2** | **135 righe, DUE input**: `lookback=200` e `risk_per_trade=1`. Una sola manopola e' la strategia. |
| **il filtro E' il motore** | **2** | la mean-reversion e' costitutiva, non un cerotto. Vale il confronto di `ROBUSTEZZA.md`: **0 su 5** quando e' appiccicata, **30 su 30** quando nasce con la tesi. |
| **tesi scrivibile** | **2** | vedi sopra, una riga |
| **riempie un buco** | **2** | **DUE in un colpo: il LATERALE** (dove `LARRY_GBPUSD` fa **−6.445** nel 2019) **e lo SHORT simmetrico** — il ramo sell e' lo specchio esatto, e le nostre 14 celle vive sono quasi tutte long-only |
| **testabile senza riscritture** | **1** | serve un `ABTG_` nuovo: manca il magic, manca `OnTester`, il conteggio posizioni e' di conto |

✅ **SL e TP veri mandati al broker** · ✅ **rischio in percentuale** · ✅ **una
posizione alla volta** · ✅ **zero bandiere rosse del §4** · ✅ **decide su dati
gia' formati** (nessun indicatore ridipingente).

### 🔴 I DIFETTI, tutti da correggere nella riscrittura

1. **`PositionsTotal()` e' DI CONTO, non di simbolo/magic.** Sul nostro conto
   con la flotta accesa **non aprirebbe mai**. Va per simbolo + magic.
2. **Nessun magic number impostato.** `trade.Buy()` senza
   `SetExpertMagicNumber` → magic **0**, indistinguibile da un'operazione
   manuale. Per la nostra pipeline e' bloccante.
3. **`NormalizeVolume()` e' codice morto**: tutti e tre i `return` stanno
   dentro il `while(true)`, quello finale e' irraggiungibile. Il lotto resta
   valido solo perche' parte dal minimo e cresce di step — ma l'accumulo di
   `double` puo' derivare e MT5 rifiuta un volume fuori passo.
4. **Errore di un passo sul rischio**: il ciclo restituisce il **primo lotto
   che SUPERA** il budget (`if(pnl < -balance*risk/100) return lot;`), non
   l'ultimo che ci sta dentro. **Rischia sempre un po' piu' del dichiarato.**
5. **Valuta a OGNI TICK** e `iLowest(...,0)` include la barra in formazione:
   l'ingresso dipende dal momento dentro la barra. 🔴 **Lo screening OHLC
   sara' fuorviante** — R57 ha misurato che cambiando solo il modello il segno
   si ribalta. **Verdetto solo a tick reali, e sensibile al modello.**
6. **Manca `OnTester`**: il driver si rifiuta di partire (22 EA su 61 gia'
   bocciati per questo).

### ⚠️ E il limite di merito, dichiarato prima dei numeri
**R:R 1:1 con uno stop LARGO** (la distanza entrata→media di un range di 200
barre). Serve un win rate **sopra il 50%** per stare in piedi. In un trend
forte prendera' stop a ripetizione: **e' uno specialista del laterale, e va
giudicato li'** — non gli si chiede di guadagnare nell'orso.

---

## 🔴 `BreakRevertPro.mq5` — SCARTO: **cambia comportamento quando capisce di essere in un test**

Niente martingala, rischio in percentuale, `max_positions=1`: sul setaccio
automatico e' **pulito**. Poi si legge il codice.

**PROVA 1 — apre un trade FANTASMA nel tester**
```cpp
bool CTradeValidator::ExecuteSafetyTrade() {
    if(!IsInTester())        return false;
    if(HistoryDealsTotal()>0) return false;
    ...
    request.magic = 999999;  // "Safety Trade"
    OrderSend(request,result);
}
```
In **ogni** backtest, prima della prima operazione, spara un BUY vero al lotto
minimo — solo per non risultare "senza operazioni" al validatore del Market.
**Inquina ogni CSV che produrremmo.**

**PROVA 2 — riconosce l'ambiente di test e cambia il sizing**
```cpp
if(MQLInfoInteger(MQL_TESTER) && (small_balance || known_test_symbol))
   m_is_validation_run = true;
...
if(m_is_validation_run || balance < 500)  return min_lot;   // niente rischio %
```
e `IsTestSymbol()` elenca **EURUSD H1, XAUUSD D1, GBPUSD M30, EURUSD M1**.

> 🚨 **Su EURUSD H1 questo EA gira al LOTTO MINIMO invece che al rischio
> dichiarato.** Un EA che si comporta diversamente quando lo misuri **non e'
> misurabile**, e non c'e' backtest che possa dire qualcosa di vero su di lui.

Contorno: 1.699 righe, 12 input, nessun `OnTester`, e una facciata
probabilistica (`Weibull`, `Poisson`, `Exponential`) sopra un segnale che poi
e' `trend su + volatilita' > 10 punti`.

## 🔴 `Mean Reverse.mq5` (MeanReversionTrendEA) — SCARTO

Stesso autore del n.1 e **stesso trucco**: 19 occorrenze di `safety`. In piu'
**`LotSize = 0.1` fisso** (nessun rischio %, non scalabile a 100k) e SL/TP in
**punti fissi** (500/1000) — che su oro e indici sono la scala sbagliata,
lo stesso difetto gia' visto in `ProAutoSL_DynamicTP`. Nessun `OnTester`.

## 🟡 `RMA` — IN CODA, non scartato

10 file, **3.765 righe**, architettura seria: `SignalEngine`, `RegimeDetector`,
`TradeManager`, `AdverseMonitor`, pannello. **Nessuna bandiera rossa**, e ha
`OnTester`. Il `RegimeDetector` e' concettualmente proprio la cosa che
cerchiamo.

**Ma:** **44 `input` nel solo `RMA.mq5`** (il nostro tetto e' ~15 — troppe
manopole da girare verso il passato), **lotto fisso `InpLotSize=0.01`**, e
serve compilare **tre programmi** con gli include al posto giusto, perche'
l'EA chiama l'indicatore via `iCustom(_Symbol,_Period,"RMA\\RMA_Engine",...)`.
**Si riapre solo dopo che il candidato n.2 ha avuto il suo verdetto.**

## 🔴 `BBStochRSIXReversal.mq5` — FUORI: **e' un INDICATORE**

```
#property indicator_chart_window
#property indicator_buffers 7
#property indicator_plots   6
int OnCalculate(...)
```
**Zero `OnTick`, zero `OrderSend`, zero `CTrade`.** Disegna frecce, non apre
niente. Come il n.1 del setaccio manuale (`ProAutoSL`): fuori imbuto perche'
non c'e' niente da misurare.

> 💡 **La regola pratica per il prossimo giro**, in un `Ctrl+F`: se trovi
> **`OnCalculate`** e' un indicatore → salta. Se trovi **`OnTick`** e
> **`OrderSend`** o **`trade.Buy`** e' un EA → mandalo.

---

# 🧱 16/08/2026 — CINQUE FILE SUL BREAKOUT: **zero promossi**

| # | file | righe | tipo | verdetto |
|---|---|---:|---|---|
| 1 | `SessionORB_EA (4).mq5` | 466 | EA MQL5 **pulito** | 🟡 **DOPPIONE** — famiglia gia' misurata a morte |
| 2 | `Universal Breakout Study.mq5` | 542 | EA MQL5 | 🔴 **38 input**, con gli interruttori per giorno della settimana |
| 3 | `BreakOut.mq4` | 444 | EA **MQL4** | 🔴 non compila su MT5 |
| 4 | `Open Range Breakout-H-Max.mq5` | 690 | **INDICATORE** | 🔴 non apre posizioni |
| 5 | `AsianSessionBreakoutBhanuCodeLab.mq5` | 2.100 | **INDICATORE** + MQL4 | 🔴 non apre posizioni |

---

## 🎯 IL PUNTO CHE VALE PIU' DEI CINQUE FILE

**Il breakout e' l'unico spazio dove abbiamo gia' misurato quasi tutto — e i
numeri sono negativi.** Non e' un'opinione, e' l'archivio:

| round | cosa | esito |
|---|---|---|
| batteria ORB (R7-R13) | 7 fonti, 8 round, 4 mercati, **~210 celle a tick reali** | _"il breakout puro al tocco e' morto ovunque"_ |
| **R45** | ORB sulla sessione di Londra, 48 celle | **0 celle verdi su 48** |
| **R12** | ORB + EMA200 + volumi sul Nasdaq, 48 celle | **48 su 48 negative OOS** |
| R44 | target 2x/3x sul Dow | il bordo era gia' a 1,5x: R13 aveva trovato il massimo |
| R55 | slippage sull'ORB | sfonda il cancello del 10% con 1,5 punti indice |

E cio' che **e' sopravvissuto** a quella batteria **e' gia' in campo**:
`ABTG_DAX_Apertura_EU` (live, win rate **81,0%**) e `Dow Apertura`, piu' la
pista ORB-EMA200 di R13/R15.

> 🔴 **Quindi un ORB di sessione generico non ci porta niente di nuovo:
> ci porta la 211-esima cella di una famiglia che conosciamo meglio
> dell'autore.** Vale la regola del mandato §5.D: un candidato che fa la
> stessa cosa di una sedia viva **vale poco anche se e' buono**.

---

## 🟡 `SessionORB_EA (4).mq5` — **il migliore dei cinque, e comunque non entra**

**Ed e' scritto bene**, va detto: `CTrade`, `SetExpertMagicNumber`,
`SetTypeFillingBySymbol`, rischio in percentuale, lati separabili
(`InpAllowLongTrades` / `InpAllowShortTrades`), SL oltre il bordo opposto del
range, TP come multiplo di R. Zero bandiere rosse del §4.

E ha persino il dettaglio che sbagliano quasi tutti:
```
input group "===== Session Settings (broker/server time) ====="
input int InpSessionStartHour = 8;    // Session start hour (0-23)
```
**Ora del SERVER, dichiarata** — che e' la nostra regola del fuso BCM
(DAX 09:00 IT = **08:00 server**), e il default e' proprio 8.

**Perche' non entra lo stesso:** meccanica identica a
`ABTG_DAX_Apertura_EU` / `ABTG_ORB` (range di apertura, buffer di conferma,
finestra di trading, SL al bordo opposto, TP a R multipli). Anche il suo unico
asse davvero diverso — `InpBreakoutBufferPoints` — e' gia' misurato: e' il
buffer di R11 e l'offset di C11 (_"preteso un ritorno 300 punti piu' profondo:
16 riempimenti persi su 409, l'edge non dipende da riempimenti ottimistici"_).

📌 **Messo in archivio come riferimento**, non in coda: se un giorno servisse
un secondo motore ORB su un banco vergine, questo e' un buon scheletro. Ma non
si spende una macchina per rimisurare cio' che ha gia' 210 celle.

## 🔴 `Universal Breakout Study.mq5` — **38 input, e tre sono giorni della settimana**

```cpp
input group "=== Days trading ===";
input ENUM_ED Monday    = false;      // <-- SPENTO di default
input ENUM_ED Tuesday   = true;
input ENUM_ED Wednesday = true;
...
```

> 🚨 **Un interruttore per giorno della settimana, col lunedi' spento, e' la
> forma piu' pura di curve-fitting che esista**: vuol dire "nel mio backtest
> il lunedi' perdeva, quindi l'ho tolto". Non e' una regola di mercato: e'
> una cicatrice del passato di qualcun altro.

Il resto e' un vivaio di manopole: box di 48 candele da un'ora GMT, `Shift`
dagli estremi, **due tipi di stop e due di take profit** con i rispettivi
coefficienti, breakeven, trailing classico con tre parametri, uscita a tempo
con due. **38 input contro il nostro tetto di ~15.** Non ha bandiere rosse —
ha troppe manopole, che nei nostri dati e' lo stesso problema con un altro
nome (`ROBUSTEZZA.md`: _"ogni parametro in piu' e' una manopola che il
backtest gira verso il passato"_).

## 🔴 Gli altri tre, in una riga a testa

- **`BreakOut.mq4`** (Soubra2003, 2016) — **MQL4**: `extern`, `OrderSend(Symbol(),...)`,
  `MarketInfo`. Non compila come `.mq5`. E il link porta alla pagina `/seller`.
- **`Open Range Breakout-H-Max.mq5`** — **indicatore**: `OnCalculate`, nessun
  `OnTick`, nessun ordine. Disegna il range, non lo opera.
- **`AsianSessionBreakoutBhanuCodeLab.mq5`** — **indicatore** (e con sintassi
  MQL4), 2.100 righe e **45 input**. Doppiamente fuori.

---

> ### 🧭 La correzione di mira che vale per i prossimi giri
> **Sul breakout siamo pieni.** Le zone dove ci manca davvero qualcosa restano
> tre, e sono misurate: **il LATERALE** (`LARRY_GBPUSD` −6.445 nel 2019), il
> **CROLLO** (dove `BB` regge e `Larry` cede), e **lo SHORT simmetrico**
> (14 celle vive quasi tutte long-only).
>
> Parole utili nel titolo: _mean reversion, fade, range, reversal,
> counter-trend, exhaustion, short_. Parole gia' coperte: _breakout, opening
> range, ORB, session, EMA, trend following_.

---

# 🧪 16/08/2026 — ALTRI QUATTRO: **uno merita la coda, tre no**

| # | file | righe | input | verdetto |
|---|---|---:|---:|---|
| 1 | **`Nikkei225_Gap_Continuation_EA.mq5`** | 1.160 | 39 | 🟡 **IN CODA — tesi NUOVA** |
| 2 | `Range_BreakOut_EA_1.02.mq5` | 274 | 6 | 🔴 lotto fisso + doppione |
| 3 | `GoldLondonBreakout.mq5` | 383 | 19 | 🔴 **e' esattamente R45** |
| 4 | `ilan_1_6_dynamic_ht.mq5` (+6 include) | 628 | 34 | 🔴🔴 **MARTINGALA CERTIFICATA** |

---

## 🟡 `Nikkei225_Gap_Continuation_EA` — **il primo con una tesi che NON abbiamo**

**Autore:** Francesc Jordi Mallol Nolden.

### 🎯 Perche' e' diverso da tutto quello arrivato finora

Noi abbiamo `ABTG_GapFill` (R36/R37): scommette che **il gap si CHIUDE**, e
`225JPY` e' fra i promossi (**+76 OOS, PF 1,14**, "il piu' tirato").

**Questo scommette l'esatto contrario: che il gap CONTINUI.** Stesso evento,
stesso mercato, **direzione opposta** — e su quella direzione non abbiamo
**nemmeno una misura**.

> E' l'unica cosa arrivata oggi che non e' ne' un doppione ne' spazzatura:
> una **tesi complementare** su un evento che sappiamo gia' mappare, su un
> simbolo di cui abbiamo lo storico e un precedente diretto per il confronto.

### ✅ Ed e' scritto con la nostra stessa grammatica di gestione

```
InpPartialClosePercent = 40.0   // chiusura parziale (%)
InpPartialTargetR      = 1.0    // parziale a 1R
InpFinalTargetR        = 2.0    // target finale a 2R
InpMoveStopToBreakEven = true   // breakeven dopo il parziale
```
E' **la gestione delle nostre sedie DAX/Dow** (parziale + breakeven + runner),
scritta in multipli di R. Rischio in **percentuale dell'equity**, magic
number, uscita forzata prima della chiusura, e un'idea che non avevamo:
`InpMaxSpreadToStopPercent` — **lo spread massimo come percentuale dello
stop**, che e' il modo giusto di misurarlo (R55 docet).

### 🔴 I tre motivi per cui NON parte adesso

1. **39 input.** Il tetto nostro e' ~15. Molti sono pinnabili (pannello,
   diagnostica, orari strutturali), ma le manopole vere restano ~7: soglie
   di gap buy/sell, minuti di opening range, finestra d'ingresso, parziale,
   e i due target in R. **Va sfrondato prima, non dopo.**
2. ⚠️ **`InpSessionTimeMode = SESSION_JST_DARWINEX_AUTO`** — e' costruito per
   il Nikkei di **Darwinex**. Da noi il simbolo e' `225JPY` su **BCM**, dove
   **il server e' un'ora indietro rispetto all'Italia**. Il fuso e' la prima
   cosa che va risolta e la piu' facile da sbagliare: e' una regola fissa di
   progetto, e un EA di sessione con l'ora sbagliata misura un altro mercato.
3. 🚩 **Un odore di taratura, da dichiarare:**
   ```
   InpReduceRiskOnSmallSellGap = true
   InpSellFullRiskFromGapPct   = 1.25   // rischio pieno solo sopra 1,25%
   InpSmallSellRiskPercent     = 0.25   // meta' rischio sotto
   ```
   **Rischio diverso fra long e short, con una soglia a 1,25%**, e' il tipo di
   asimmetria che nasce guardando i risultati. Se entra, entra **simmetrico**
   e quella soglia si misura, non si eredita.

📌 **Posizione in coda: dopo `ABTG_MeanRevert`.** Una macchina, un lavoro.

---

## 🔴🔴 `ilan_1_6_dynamic_ht` — **MARTINGALA, e per giunta l'archetipo**

`Ilan` e' **il** grid-martingala del forex retail. La prova sta in due righe:

```cpp
input double LotExponent = 1.4;                                    // riga 32
return NormalizeDouble(Lots * MathPow(LotExponent,
                       Environment.GetPositionsTotal()+1), lotdecimal);   // riga 573
```

**Il lotto cresce di 1,4 volte per ogni posizione gia' aperta** — e
l'esponente parte da `+1`, quindi **la prima aggiunta e' gia' maggiorata**.

Colpisce **quattro** bandiere rosse del §4 insieme:
**martingala** · **averaging** · **hedge** (46 riferimenti nel solo
`drawhedgeposition.mqh`, 141 in `prototypes.mqh`) · **`#import`**.

> Il commento dell'autore lo dice da solo, alla riga 29:
> _"if LotExponent = 1.4: the first lot is 0.1, the following..."_
> **Non e' nascosto. E' il prodotto.**

## 🔴 `GoldLondonBreakout` — **l'abbiamo gia' fatto, e si chiama R45**

Oro + rottura della sessione di Londra. E' **letteralmente** il nostro
`backtest_pipeline/prove/R45a_londra_XAUUSD.txt`:

> **R45 — ORB su sessione di Londra: ZERO celle verdi su 48.**
> Il filtro volumi _"attenua ma non inverte mai"_.

19 input, nessuna bandiera rossa, codice ordinato — e **48 celle di prova
gia' spese su questa identica idea, con verdetto**. Non si rimisura.

## 🔴 `Range_BreakOut_EA_1.02` — pulito, minuscolo, e non serve

**6 input, tutti orari** (range 01:00→06:00 = **range asiatico**, operativita'
fino alle 22:00). Copyright MetaQuotes: e' un **esempio didattico** del Code
Base. SL al bordo opposto, TP = rottura + ampiezza del range.

Due motivi, e il primo basta:
```cpp
trade.Buy(minLot, Symbol(), 0, rangeLow, tp);   // <-- LOTTO MINIMO FISSO
```
**Nessun sizing sul rischio** → non scalabile a 100k e non confrontabile coi
nostri numeri (bandiera rossa §4). E la meccanica e' di nuovo la famiglia ORB,
dove abbiamo **~210 celle a tick reali** e due sedie vive.

---

> ### 📊 Il bilancio del setaccio manuale di oggi
> **14 file guardati nel sorgente · 1 promosso (`MeanReversion` → scritto come
> `ABTG_MeanRevert`) · 1 in coda (`Nikkei Gap Continuation`) · 12 scartati.**
>
> Motivi ricorrenti degli scarti, in ordine: **doppioni di famiglie gia'
> misurate** (6), **martingala/griglia** (2), **indicatori che non operano**
> (3), **MQL4 che non compila** (2), **lotto fisso** (2), **troppe manopole**
> (2). _(Un file puo' cadere per piu' motivi.)_

---

# 🥇 16/08/2026 — CINQUE FILE SULL'ORO: **zero promossi, e quattro sono gravi**

| # | file | righe | input | verdetto |
|---|---|---:|---:|---|
| 1 | `XANDER_Gold_Recovery.mq5` | 482 | 24 | 🔴🔴 **MARTINGALA** dichiarata nel nome dell'input |
| 2 | `DailyZoneRecovery.mq5` **(x2)** | 636 | 38 | 🔴🔴 **TRE GRIGLIE** in parallelo |
| 3 | `Quantum Gold Silver Trader.mq5` | 1.679 | **81** | 🔴 fattoria di manopole |
| 4 | `Gold Dust.mq5` | 836 | 19 | 🔴 **8 pesi liberi**: 2,7 miliardi di miliardi di combinazioni |

_(Il n.2 e' arrivato in due zip diversi: e' lo stesso identico file.)_

---

## 🔴🔴 `XANDER_Gold_Recovery` — la martingala e' nel NOME dell'input

```cpp
input double xr_RecoveryMultiplier = 1.4;   // Lot multiplier per step
...
double next_volume = NormalizeVolume(last_volume * xr_RecoveryMultiplier);
```

**`ultimo_volume x 1,4` a ogni passo.** E' la stessa meccanica di `Ilan` e di
`Mean_Reversion`, col nome cambiato: "recovery" e' come si chiama la
martingala quando la si vende.

⚠️ **E il `#property link` non porta a MQL5: porta a un canale Telegram**
(`t.me/xandertool`). Non e' una bandiera rossa del §4, ma dice tutto su cosa
sia questo file. In piu' e' **sintassi MQL4**: non compila come `.mq5`.

## 🔴🔴 `DailyZoneRecovery` — non una griglia, **TRE**

```cpp
input double InpStrategy1GridStepPct = 0.34;   // Grid step (%)
input double InpStrategy2GridStepPct = 0.01;   // Grid step (%)
input double InpStrategy3GridStepPct = 0.32;   // Grid step (%)
```

Tre motori a griglia in parallelo, **lotto fisso `InpLot = 0.01`** (nessun
rischio in percentuale), 38 input, e il `#property link` finisce in
**`/seller`**: e' un prodotto del Market.

Lo "Zone Recovery" e' la variante con copertura: si apre il lato opposto per
non chiudere in perdita. **Colpisce tre bandiere rosse insieme** — griglia,
hedge di copertura, lotto fisso.

## 🔴 `Quantum Gold Silver Trader` — **81 input**, e due tarature separate

1.679 righe, **13 gruppi di parametri**, commenti in russo, header con
copyright MetaQuotes. **Nessuna martingala** (i 38 "multiplier" sono tutti
moltiplicatori di ATR, verificato riga per riga) e ha persino `OnTester`.

Ma:
- **81 input contro il nostro tetto di ~15.** Cinque volte e mezzo.
- **12 parametri `Gold_` e 12 `Silver_`**: due tarature separate cucite dentro
  lo stesso EA. Non e' un motore che funziona su due mercati — sono **due
  overfitting nello stesso file**.

## 🔴 `Gold Dust` — e questo merita di essere raccontato

**Non e' martingala. Compila davvero** (usa `CTrade` e si definisce da solo
`bool RefreshRates(void)`, quindi il mio primo controllo automatico l'aveva
segnato MQL4 per sbaglio — **verificato a mano, e corretto**). Ha uno
**stop loss vero** (150 pip) e un trailing. Yury V. Reshetov, 2011.

E allora perche' esce? Per gli input:

```cpp
input int x11=100;  input int x21=100;  input int x31=100;  input int x41=100;
input int x12=100;  input int x22=100;  input int x32=100;  input int x42=100;
input int pass=1;
...
int Perceptron(int x1,int x2,int x3,int x4)
  { double w1 = x1 - 100.0; ... double result = w1*a1+w2*a2+w3*a3+w4*a4; }
```

**Sono due percettroni con OTTO PESI LIBERI.** I pesi non hanno alcun
significato di mercato: sono numeri che l'ottimizzatore riempie. Ognuno
spazza 0-200:

> ### 🚨 **201⁸ = 2.664.210.032.449.121.601 combinazioni.**
> **Due miliardi di miliardi di modi di sembrare bravi sul passato.**

Con **dodici Spearman IS→OOS negativi su tredici** — l'ultimo (R58) misurato
sui tick reali del nostro broker — un motore i cui parametri **sono solo
output dell'ottimizzatore** e' l'oggetto piu' lontano da noi che esista.
`ROBUSTEZZA.md` in una riga: _"ogni parametro in piu' e' una manopola che il
backtest gira verso il passato"_. Qui **il motore E' la manopola.**

Non e' un EA scritto male. E' **la macchina per costruire il ribaltamento
numero trentuno**.

---

> ### 🧭 Correzione di mira, terza edizione
> **Sull'oro e sul "recovery" siamo pieni di veleno.** Le parole che nel
> titolo o negli input valgono uno scarto immediato, senza aprire il file:
> **recovery · zone · grid · multiplier sul LOTTO · martingale · x11/w1
> (pesi liberi) · doppia taratura per simbolo**.
>
> Restano i tre buchi veri, misurati: **LATERALE · CROLLO · SHORT simmetrico**.

---

## 16/08/2026 — `Pending_tread.mq5` · 🔴 **GRIGLIA** dichiarata negli input

**Autore:** Mir Mostofa Kamal · `mql5.com/en/users/bokul` · 283 righe, 15 input.

```cpp
input double PipStep       = 100;    // Distance between orders (pips)
input bool   EnableBuyGrid  = true;  // Enable Buy grid
input bool   EnableSellGrid = true;  // Enable Sell grid
input double LotSize        = 0.10;  // Lot size
```

**Griglia di pendenti a distanza fissa, su entrambi i lati, a lotto fisso.**
Non serve leggere altro: bandiera rossa §4 due volte (griglia + lotto fisso).

E porta anche il **difetto della scala dei pip** gia' visto in
`ProAutoSL_DynamicTP`:
```cpp
double pipMultiplier = (digits == 3 || digits == 5) ? 10.0 : 1.0;
```
su oro e indici i 100 "pip" di `PipStep` diventano un'altra cosa.

Ha una protezione sull'equity (`MaxLossPercent = 20.0`) — che pero' su una
prop non serve a niente: il muro e' al **10%**, e a quel punto il conto e'
gia' chiuso.

## 16/08/2026 — `SmartTradeManager.mq5` · 🟡 **FUORI IMBUTO — altro attrezzo**

**Autore:** Waseem Shahrukh · 386 righe, 34 input.

**Zero `trade.Buy`, zero `trade.Sell`, zero `OrderSend`, zero `PositionOpen`:
non apre niente.** E' un gestore di posizioni gia' aperte, come
`ProAutoSL_DynamicTP` del primo giro. `InpOnlyManual = true` (magic 0).

> ✅ **Ma e' scritto molto meglio del primo**, e va detto perche' fa da
> capitolato se un giorno ci servisse davvero:
> ```cpp
> InpStructTF      = PERIOD_M15;  // swing + ATR
> InpSwingLookback = 20;          // SL sullo swing recente
> InpATRBuffer     = 0.6;         // margine oltre lo swing
> InpMinSL_ATR     = 1.2;         // pavimento anti-stop-stretto
> InpMaxSL_ATR     = 4.0;         // tetto anti-stop-enorme
> ```
> **SL strutturale sullo swing, in ATR, con pavimento e tetto** — cioe'
> esattamente la correzione che avevo scritto per `ProAutoSL`
> ("SL in ATR o in percentuale di rischio, mai in pip fissi"). Il difetto
> della scala su oro e indici **qui non c'e'**.

Resta fuori dall'imbuto per lo stesso motivo del primo: **zero ingressi =
zero edge = niente da backtestare**. Ma se un giorno serve un salvagente per
le operazioni manuali, **si parte da questo, non da quello**.

---

## 16/08/2026 — `BreakoutEA.mq5` v1.30 · 🔴 **il report e' la lezione, non il codice**

**Autore:** Yashar Seyyedin — **lo stesso di `MeanReversion.mq5`**, il nostro
unico promosso. 145 righe, **4 input**.

### ✅ Il codice e' pulito, e in due punti e' MEGLIO del suo fratello promosso

- decide **solo all'apertura di una nuova barra**, su `[1]` e `[2]` chiuse → **niente repaint**
- **SL e TP veri** al broker · magic impostato
- posizioni contate per **simbolo + magic** (il fratello usa `PositionsTotal()`, di conto)
- lotto arrotondato **verso il basso** e, se sotto il minimo, **non opera** invece di forzare

### 🔴 Ma non entra, e i motivi sono quattro

1. **LONG-ONLY.** `if(closeBar1 > highBar2) ... trade.Buy(...)`. Nessuno short.
   E' l'opposto del buco che dobbiamo riempire.
2. **`InpRiskAmount = 20.0` — rischio in VALUTA FISSA, non in percentuale.**
   Venti dollari a operazione: su 100k sono lo **0,02%**. Non scala col conto,
   non si legge nei nostri confronti.
3. 🚩 **L'autore etichetta due input `-> Optimize`** — e `InpMinSLPoints = 5000`
   e' un filtro di selezione tarato sull'ottimizzatore, non una regola di mercato.
4. Il segnale e' **una barra che chiude sopra il massimo della precedente**:
   la famiglia breakout, dove abbiamo **~210 celle a tick reali**.

### 🔬 E ORA IL PEZZO CHE VALE: il report allegato

Nello zip c'erano `report.png`, `curve.png` e `setting.png`. **La curva sale.**
Poi si leggono le impostazioni:

```
Symbol:     US100.cash  H4
Date:       2023.01.01 -> 2026.06.01
Forward:    No                              <-- NESSUN out-of-sample
Delays:     Zero latency, ideal execution   <-- slippage ZERO
Modelling:  1 minute OHLC                   <-- NON tick reali
Deposit:    10000 USD
```

| il risultato | il nostro metro |
|---|---|
| Net Profit **520,74** su 10.000 in 3,4 anni | **+1,53% l'anno** |
| **Profit Factor 1,10** | il nostro pavimento e' 1,10: **zero margine** |
| **589 operazioni**, Expected Payoff **0,88** | **88 centesimi di margine per operazione** |
| Short trades: **0 (0,00%)** | long-only confermato dai numeri |
| Largest profit **20,00** / loss **−28,00** | ogni vincita e' il rischio fisso: 589 lanci di moneta al **54,16%** |
| **OnTester result: 0** | conferma: `OnTester` non c'e' |

> 🚨 **Tre delle nostre regole, tutte violate nello stesso screenshot:**
> - **`Modelling: 1 minute OHLC`** → _"OHLC solo screening, verdetti solo a tick reali"_. **R57** ha misurato che cambiando **solo** il modello il segno dell'orso si ribalta.
> - **`Delays: Zero latency, ideal execution`** → **R55** ha misurato che l'ORB **sfonda il cancello del 10% con 1,5 punti indice di slippage**. Qui lo slippage e' **zero per impostazione**, su un **indice**.
> - **`Forward: No`** → nessun fuori campione. E' **tutto in campione**, con due parametri dichiarati "da ottimizzare" su quella stessa finestra.
>
> 🎯 **Il margine e' 88 centesimi per operazione, misurati a latenza zero.**
> Qualunque attrito reale mangia una fetta di quel margine, e non ce n'e'.

**Non e' un EA disonesto: e' un EA misurato col metodo che noi abbiamo
abbandonato dopo trenta ribaltamenti.** Il codice si potrebbe anche riusare;
**il numero no**.

---

## 📅 02/09/2026 — CACCIA FREQUENZA, QUARTA BATTUTA (fronte B): 7 sorgenti Code Base letti, 7 scarti

Dossier completo: `caccia_strategie/CACCIA_FREQUENZA4_CB_PAPER_2026-09-02.md`.
Qui resta solo l'indice degli id, perche' e' questo il file che il prossimo
cacciatore grep-a.

| id | titolo | esito | la riga che lo prova |
|---|---|---|---|
| **23499** | `Ingrit` (V. Karputov, 2018) — **M5 nativo** | 🔴 **SCARTO** | **averaging senza cap dentro un motore di FADE**: il blocco `if(m_need_open_buy){ … OpenPosition(POSITION_TYPE_BUY,level); return; }` (righe 170-191) **non ha nessun controllo sul numero di posizioni** e `InpCloseOpposite` e' `false` di default → una barra M5 al 3% di rischio, ogni barra, contro il prezzo. Peccato: il motore (fade di un'estensione di 25 pip in 14 barre M5) e' leggibile e a due lati, e legge barra chiusa |
| **42283** | `CCI + MACD Scalper` | 🔴 **SCARTO** | `CopyBuffer(cciHandler, 0, **0**, 3, cciArray)` **senza `ArraySetAsSeries`** → l'elemento `[2]` **e' la barra in formazione**, ed e' quello usato nella condizione (righe 99-101). Piu': tre indicatori in AND = tesi dentro il menu; `MaxOpenPositions` di fatto 1 |
| **43278** | `Aussie Surfer` — GBPAUD M15 | 🔴 **SCARTO** | `static input double Entry_Amount = 0.30; // Entry lots` (**lotto fisso**) + `input int Take_Profit = 0;` (**nessun target**). Motore = Bollinger(5;2,5) + Alligator = **doppione di `ABTG_BandFade`** |
| **44883** | `AK-47 Scalper EA - MT5` | 🔴🔴 **SCARTO** | `ENUM_ORDER_TYPE OrdType = ORDER_TYPE_SELL;//-1;` **cablato**: il ramo BUY e' codice morto e **non esiste nessun segnale** — riarma per sempre un sell-stop a 1,75 pip. `InpSL_Pips = 3.5` (spread ~1 pip = **29% dello stop**). `LotSize = (InpRisk) * m_account.FreeMargin();` non e' un rischio |
| **49770** | `Probability Theory EA` (Koshtenko) | 🔴 **SCARTO** | `input int StopLoss = 0;` → `if(StopLoss>0) sl=…` → `trade.Buy(Lot(),NULL,pr,**sl**,tp,"")` con `sl=0`: **nessuno stop di default**. `input double Lots = 0.1` **fisso** |
| **52105** | `QuickTrend Scalper` (`revised_self_adaptive_ea.mq5`) | 🔴 **SCARTO** | `input int InpPeriodRSI = **6**;` = **lo stesso grilletto di M0PB**, morto 12/12 il 31/08 (0,52 segnali/giorno). Regola del mandato: mai "parametri diversi di un motore morto". Piu' `InpLot = 0.05` fisso |
| **59303** | `RSI Ea MT5` | 🟠 **SCARTO PER FREQUENZA** — e **non per difetto: e' il codice meglio scritto dei sette** (ATR-stop RR 1,5, rischio % opzionale, filtro di sessione, scale-out, barra chiusa) | `if ((CurrentSignal > LowerThreshold) && (PreviousSignal <= LowerThreshold))` con `LowerThreshold=20` su `iRSI(…,14,…)` (riga 675): **evento di coda**, non 2/giorno. `MaxOpenPositions = 1` |

### 🔴 IL VERDETTO SULLA FONTE — adesso su 400 titoli, non su 20

Le battute del 31/08 e 01/09 avevano chiuso il Code Base **su 20 id e 4 pagine**.
Il 02/09 l'ho rifatto su **10 pagine e 400 id unici** (dall'id 76811 all'id
11637), incrociando meccanicamente con i **78 id gia' setacciati** nei dossier
precedenti (grep su `caccia_strategie/*` **e** `report/*`, come chiede §F del
promemoria).

> **Su 400 EA del Code Base MT5, i motori intraday M5/M15 con SL vero, rischio in
> percentuale e frequenza >=2/giorno sono ZERO.** Non "pochi": zero.
> Composizione misurata: **~53% attrezzi** (pannelli, calcolatori, gestori,
> trailing, logger, copiatori — fra cui **sette utility `Quantora` di fila**),
> **~15% snippet didattici**, **~20% incroci di indicatori senza tesi**,
> **~8% griglia/martingala/recovery/lock**, il resto ONNX, Renko, rete, cripto.
>
> 🔬 **La ragione e' strutturale:** il Code Base premia cio' che serve a
> **chiunque**. Un calcolatore di lotto serve a tutti; un motore di sessione su
> M5 serve a chi ha gia' una tesi — e **chi ha una tesi che funziona non la
> carica gratis**.
>
> ➡️ **Regola d'uso, confermata su 400 titoli: il Code Base si apre per gli
> ATTREZZI, non per i motori.** Non si riapre per cercare un motore intraday
> senza una ragione nuova e dichiarata.

### 🪦 E una lapide dalla stessa battuta, che chiude una famiglia

`arXiv 2407.08036` — *The tube oscillator* (Katic & Richter, 10/07/2024), su
**DAX 40 ed EUR/USD dentro MetaTrader**, 2019/01→2024/05. Tre squalifiche
verbatim: **(1)** i parametri della geometria sono **oscurati nel paper**
(`###`, _"in this preliminary version, the parameters are not disclosed"_) → non
replicabile; **(2)** _"in average, **61.67 trades are performed per day** …
average position holding time of **171.75 seconds** … lots of positions gave up
in **less than 30 seconds**"_ → viola il paletto prop **P5** (max 25% dei trade
sotto 60 s); **(3)** _"the average profit/share is **0.37·10⁻⁵**"_ = **0,037 pip
netti per trade** → contro il nostro spread di ~1 pip `[NON MISURATO]` e' morto
di un fattore ~27.

> 🎯 **Terza conferma indipendente del muro d'attrito** (arXiv 2605.04004 §6.2 ·
> `fx-bizday` 01/09, _"even 1 basis point will destroy the profitability"_ ·
> questa). **Direzione "oscillatore geometrico continuo ad altissima frequenza"
> chiusa con un numero, prima di spenderci un round.**

---

## 📅 05/09/2026 — CACCIA DEDICATA **TF M30**: 5 meccanismi MISURATI, 5 sepolti, 2 sorgenti letti, 0 promossi

Dossier completo: `caccia_strategie/CACCIA_TF_M30_2026-09-05.md`.
Qui resta l'indice, perche' e' questo il file che il prossimo cacciatore grep-a.

### I MECCANISMI (scartati su MISURA, non su lettura)

| meccanismo | esito | il numero che lo uccide |
|---|---|---|
| **M27 · deriva a mezz'ora** (Knuteson arXiv:2010.01727) | 🔴 **SEPOLTO — ed esce dalla coda del 23/08** | `GRXEUR` **1.518 sedute** su 4 regimi, 28 mezz'ore: la **migliore** rende **1,63 punti indice** contro un cancello 3× spread di **4,95** = **0,33×**. `SPXUSD` 1.545 sedute: massimo `t = 2,65` sull'ultima mezz'ora, che e' **M13/Gao, gia' ⬛ con R98**. **Nessuna mezz'ora paga nemmeno UNO spread** |
| **cross-asset INDICE × VALUTA della stessa area** (chiesto dal mandato) | 🔴 **SEPOLTO** | `FR40_EUR × EUR_USD`, stesso provider, **8.112 barre M30**: correlazione ritardata **−0,015** a 1 barra. Condizionamento: la cella migliore vale **+0,92 bp ≈ 0,05 punti indice** contro spread 1,65 (**fattore ~30**), e il win rate **peggiora** man mano che il segnale si rafforza (52,9 → 47,1 → 44,2 a 1/1,5/2 σ) = **monotonia rotta**. La letteratura lo diceva prima (Wagner, IREF 2020: a frequenza intraday la causalita' va **indice → valuta**) |
| **reversione overnight→intraday, UNIVARIATA** (*Overnight-Intraday Reversal Everywhere*) | 🔴 **SEPOLTO** | DAX **1.513** coppie: monotonia **FALLITA**, long Q1+short Q5 = **−1,98 punti indice medi, −0,75 mediani** (in perdita **prima** dei costi). S&P **1.262** coppie: monotonia **FALLITA** e **segno rovesciato**. 👉 Il paper e' **CROSS-SEZIONALE su migliaia di titoli**; noi abbiamo 4 indici. Stessa obiezione con cui il 03/09 e' stato scartato **M12** |
| **la stessa cosa in forma CROSS-SEZIONALE** | 🚨 **ARTEFATTO — LOOK-AHEAD, §4 rossa** | sembrava **+29,64 bp/giorno, t +8,49**. La "notte" dell'S&P finisce alle **15:30 CET di oggi** e **contiene la seduta europea di oggi**. Prove: la **sola coppia a stesso orario** (DAX vs ESTX50) e' **negativa in entrambe le direzioni**; l'ingresso ritardato **non** uccide l'effetto (quindi non e' prezzo stantio); l'univariata e' piatta. ✅ **`RELATIVO` NON e' esposto** (lavora solo nella sovrapposizione 14:30-22:00) |
| **M25 · seduta USA di ieri → seduta EU di oggi, come MOTORE** | 🔴 **SEPOLTO sull'orizzonte GIORNALIERO** | tolto il gap (ingresso a +30 e +60 min dall'apertura): **monotonia FALLITA in entrambe le direzioni su 4 corse**, spread da **−2,49 a +2,43 bp**, `\|t\| ≤ 0,55`, su **2.532 giornate**. ⚠️ **NON** chiude il lead-lag intraday a 20-45 minuti, che resta ⬜ |

### I SORGENTI LETTI RIGA PER RIGA — 2 su 2 scartati

| id / slug | titolo | esito | la riga che lo prova |
|---|---|---|---|
| **tv `pjZmjlZB`** | `Prod_1st_NQ15HMADY` — *NQ HMA Midday Strategy* (QuantByBoji, **MPL 2.0**) | 🔴 **SCARTO** | riga 149 calcola `shortCondition`, riga 154 lo tiene **commentato**: **long-only nei fatti**, e la riga 180 `strategy.exit('long', from_entry='short')` punta a un ID **mai creato**. Piu': `strategy.entry('long', strategy.long, 1, …)` = **lotto fisso**; TP/SL `ta.atr(...)*mult/**0.25**` = **cablati sul tick del future NQ**; motore = **EMA200 + flip di canale** = doppione di `ABTG_EMA200` **e** della famiglia `SupertrendReversal`; righe 16-17 l'autore dichiara la **ri-ottimizzazione periodica**; e il nome interno dice **NQ15** = M15 |
| **tv `fmPC9fWd`** | `OBS Volume Spike Reaction Fade [NQ]` (TurkishTraderUsa_, **MPL 2.0**) | 🔴 **SCARTO** | intestazione: _"Designed and tested on NQ futures, **1-minute chart**"_ (M1, gia' chiuso); `default_qty_type=strategy.fixed` = **lotto fisso**; tooltip `grpFib`: livelli statici _"**calibrated for NQ over Oct 2025 - Apr 2026**"_ = **sovradattamento dichiarato dall'autore**; motore = **fade dell'anomalo (M17, ⬛ due volte)** + gate di **compressione→espansione**, falsificata il 03/09 su 9.723 segnali. 🟢 **Ma una frase da tenere:** _"without Bar Magnifier the Strategy Tester **overstates** close-target results"_ — e' la nostra R57 scritta da un estraneo |

### 🏷️ TAG TRADINGVIEW A RESA **ZERO** misurati oggi (da non riprovare)
**`intermarket`** · **`timeofday`** — entrambi _"Nothing here, yet"_ col filtro `script_type=strategies`.

### 🔬 IL RILIEVO DI METODO
**`WebSearch` puo' restituire repository che NON esistono:** `algorembrant/QRAT2025`
arriva con tanto di descrizione dettagliata e **`WebFetch` da' 404**.
👉 **Uno snippet di ricerca non e' una verifica.** Prima volta misurata in questo progetto.

### 🎯 LA CONSEGUENZA CHE ORIENTA LE PROSSIME CACCE M30
**A M30 il costo non e' piu' il vincolo:** ATR M30 del DAX **25-40 punti** contro
uno spread misurato di **1,65** → un take a 1,5R vale **23-36 volte lo spread**.
Le morti di casa a M5/M15 sono in buona parte morti da **attrito**; a M30 quel muro
non c'e'. 👉 **Il vincolo che resta e' l'EDGE**, e nei cinque meccanismi misurati
non c'e' — non hanno fallito il cancello dello spread, hanno fallito **la
monotonia**, tre volte su tre.
