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
