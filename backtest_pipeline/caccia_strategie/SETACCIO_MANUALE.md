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
