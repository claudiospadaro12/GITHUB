# 🔬 AUDIT — `Nasdaq_PreOpen_Breakout_EA.mq5` (EA ESTERNO)

_12/09/2026 · repo `/home/user/GITHUB`, branch `lavoro` · **SOLO LETTURA: l'EA non
e' stato toccato, non e' stato compilato, non e' stato girato. Nessun ABTG_, nessun
preset, nessuna coda.**_

**Oggetto:** `mql5/Experts/esterni/Nasdaq_PreOpen_Breakout_EA.mq5`
894 righe · 30.442 byte · `md5 86ff7bdc711e4c8032139577dd17b2e2` · magic `20260617`
(**nessuna collisione** con i nostri: verificato, unica occorrenza in tutto il repo).

---

## 🟢 PRIMA LA NOTIZIA BUONA, perche' esiste ed e' grossa

**Questo EA non e' spazzatura.** Ha il pattern hedging **giusto** (r.380-402:
`PositionsTotal()` + `SelectByIndex` + filtro simbolo **e** magic), cioe' **non** ha
il difetto che il 03/09 abbiamo trovato addosso a mezza flotta nostra
(`report/AUDIT_POSITIONSELECT_HEDGING_2026-09-03.md`). Normalizza i prezzi al tick,
rispetta `SYMBOL_TRADE_STOPS_LEVEL`, calcola il lotto **dopo** aver validato lo stop,
gestisce i filling mode, rilascia l'handle in `OnDeinit`. Scritto meglio di parecchia
roba che abbiamo comprato.

🔴 **E non basta**, perche' il problema non e' l'artigianato: e' che **il meccanismo
lo abbiamo gia' misurato in casa e non passa**, e che l'orologio si rompe **dentro la
finestra della challenge**. Sotto, coi numeri.

---

## 1. 📐 IL MECCANISMO IN DIECI RIGHE, con `file:riga`

Tutti i riferimenti sono a `mql5/Experts/esterni/Nasdaq_PreOpen_Breakout_EA.mq5`.

1. **Orologio**: converte l'ora server in ora **Roma** con `TimeTradeServer()-TimeGMT()`
   piu' un offset **cablato** `InpLocalUtcOffsetHours=2` (r.25, r.116-126).
2. **Candela di riferimento**: la barra `InpTimeframe`(=M5) la cui **apertura** cade a
   **15:25 Roma** — cioe' la candela **15:25-15:30**, l'ultima **prima** dell'apertura
   USA (r.288-293 `NPO_BarIsPreOpen`, r.296-310 `NPO_LoadPreOpenCandle`).
3. **Cancello di ampiezza**: opera solo se `range >= InpMinCandlePoints = 17` punti
   indice (r.37, r.443-449). 🔴 **Nessun tetto massimo.**
4. **Ingresso**: `BuyStop` a `H + 7` e `SellStop` a `L - 7`
   (`InpEntryBufferPoints=7`, r.467-468), piazzati al primo tick da 15:30 in poi
   (r.373-374), scadenza `ORDER_TIME_SPECIFIED` alle **18:00 Roma** (r.432-435, r.490).
5. **Stop**: l'**estremo opposto della candela** — `buySL = g_preLow`,
   `sellSL = g_preHigh` (r.469-470). Quindi **stop = range + 7**.
6. **Lotto**: `InpRiskPercent` (1,0%) x peso, sulla distanza ingresso-stop
   (r.244-263 `NPO_CalcLots`).
7. **Filtro EMA50 M5**: non blocca, **pesa** — 70% al lato concorde col trend, 30%
   all'altro (r.451, r.479-483). Trend = `close[1]` vs EMA50 (r.277-285).
8. **OCO**: quando uno riempie, l'altro viene cancellato — da `OnTradeTransaction`
   (r.719-736) che chiama `NPO_HandleFill` (r.588-612) che chiama
   `NPO_CancelOppositePending` (r.420-429).
9. **Gestione**: a **+20 punti FISSI** chiude il 50% e porta lo stop a pareggio
   (r.661-698); a **+50 punti FISSI** chiude tutto con un ordine a mercato
   (r.648-658, **non** un TP sul server: i pendenti partono con `tp = 0.0`, r.504/518).
10. **Chiusura forzata** alle **21:55 Roma** (r.32-33, r.623-632); un solo trade al
    giorno (r.56, r.357).

---

## 2. 🏠 IL CONFRONTO CON CASA NOSTRA — **e qui l'audit finisce prima di cominciare**

### 🔴 IL GEMELLO NON E' `ABTG_Nasdaq_Apertura_US`. E' `ABTG_Nasdaq_Live5m` (magic `770203`).

Il sospetto della consegna era giusto a meta': **il nostro morto `770201` prende
davvero la candela H1 PRECEDENTE, non la pre-apertura**. Ma la casa ha **un terzo
EA** che nessuno aveva nominato, e quello e' **lo stesso meccanismo alla virgola**.

`mql5/Experts/ABTG_Nasdaq_Live5m.mq5` r.1-38, intestazione testuale:

> _"candela TRIGGER = i 5 minuti PRIMA dell'apertura (15:25-15:30 IT) ... ordini a 7
> punti indice oltre max/min (buffer 700) ... FILTRO ampiezza candela: opera solo se
> e' tra 17 e 40 punti indice (1700-4000), come da live"_

E la stessa origine: **la live di E. Monza del 17/07/26**, cioe' lo stesso piano ABTG
da cui l'EA esterno e' stato codificato.

| ingrediente | 🏠 `ABTG_Nasdaq_Live5m` (770203) | 📦 `Nasdaq_PreOpen_Breakout_EA` | esito |
|---|---|---|---|
| da dove nasce il **range** | `InpRangeMode=1` + `InpPrevWindowMin=5`, finestra `[14:25, 14:30)` **server** | barra M5 aperta alle 15:25 **Roma** (= 14:25 server) | 🟰 **IDENTICO** |
| **buffer** d'ingresso | `InpBufferPoints=700` = **7 idx** | `InpEntryBufferPoints=7` = **7 idx** | 🟰 **IDENTICO** |
| cancello di **ampiezza minima** | `InpMinRangePts=1700` = **17 idx** | `InpMinCandlePoints=17` | 🟰 **IDENTICO** |
| cancello di **ampiezza massima** | `InpMaxRangePts=4000` = **40 idx** | 🔴 **NON C'E'** | ❌ **PEGGIORE** |
| da dove nasce lo **stop** | `InpSLMode=0` = `ABTG_SL_RANGE`, bordo opposto (r.155-158, r.661/678) | bordo opposto della candela (r.469-470) | 🟰 **IDENTICO** |
| **primo obiettivo** | `InpTP1_R=1` → **1R**, scala con lo stop | **+20 punti FISSI** | ❌ **PEGGIORE** (vedi §3) |
| % chiusa al primo obiettivo | `InpTP1_ClosePct=50` | `InpPartialClosePercent=50` | 🟰 IDENTICO |
| **resto della posizione** | `InpUseTrailing=1`, trailing base candela **M1** | **target FISSO +50 punti** | ⚠️ **DIVERSO** |
| un trade al giorno | `InpOneTradePerDay=1` | `InpMaxTradesPerDay=1` | 🟰 IDENTICO |
| **quando si entra** | pendenti armati all'apertura, scadenza 120' | pendenti armati all'apertura, scadenza 150' | 🟰 ~IDENTICO |

👉 **Su nove ingredienti, sei sono identici e tre sono l'uscita.** Il **segnale**
d'ingresso — che e' quello che decide se un'inefficienza esiste — e' **lo stesso
identico**.

### 🪦 E il gemello di casa E' MISURATO — a **TICK REALI**, e non passa

Fonte: `backtest_pipeline/risultati_prove/ABTG_Nasdaq_Live5m/*.csv`, letti riga per
riga (non dai referti). Cella confermata dai parametri nel CSV stesso:
`InpSessionHour=14 · InpSessionMin=30 · InpRangeMode=1 · InpPrevWindowMin=5 ·
InpBufferPoints=700 · InpMinRangePts=1700 · InpMaxRangePts=4000 · InpAllowLong=1 ·
InpAllowShort=1 · InpRiskPercent=2 · filtri EMA/Supertrend/correlazione/news TUTTI a 0`.

| finestra | modello | **PF** | **n** | **DD %** | **Profit** |
|---|---|---:|---:|---:|---:|
| IS | 🟢 **tick reali** | **1,01621** | **116** | **11,5160** | **+98,96** |
| **OOS** | 🟢 **tick reali** | 🔴 **0,96265** | **175** | 🔴 **19,4006** | 🔴 **−326,54** |
| IS | 🟡 OHLC M1 | 1,36567 | 125 | 8,0081 | +2.403,74 |
| OOS | 🟡 OHLC M1 | 2,16249 | 198 | 7,3108 | +8.943,56 |

> ## 🔴 **E GUARDATE LA DISTANZA FRA LE DUE RIGHE OOS.**
> **OHLC: PF 2,16 e +8.943,56 €. Tick reali, stessa cella, stessa finestra:
> PF 0,96 e −326,54 €.** Il segno si ribalta e il profitto fa un salto di
> **9.270 €**. E' la regola di casa (_"OHLC = ottimista su M5/breakout intraday"_,
> `REGISTRO_TEST.md` riga 8) misurata nella sua forma piu' brutale che abbiamo agli
> atti. 👉 **Su questo meccanismo, qualunque numero non-tick vale ZERO.** Se un
> venditore di questo EA esterno vi mostra una curva, chiedete il modello: quasi
> certamente e' quella da +8.943.

**n = 116 + 175 = 291 operazioni.** L'OOS da solo fa **175 >= 150**: per
l'Emendamento della finestra (regola A) questo campione **e' misurabile**, e lo e'
**sia per il rischio sia per il merito**. Non e' un "campione sottile" da sospendere.

### E i gemelli di simbolo — provati anche quelli, stessa famiglia

Da `report/CENSIMENTO_PF_MISURATI_2026-09-09.md` (tick reali, cella mediana):

| sedia | PF IS | PF OOS | n OOS | DD OOS |
|---|---:|---:|---:|---:|
| `Live5m` **NASUSD** | 1,02 | **0,96** | 175 | **19,40%** |
| `Live5m_v2` **D30EUR** | 1,01 | **0,92** | 202 | 14,16% |
| `Live5m` **D30EUR** | 0,93 | **0,86** | 342 | **39,74%** |

🔴 **Tre sedie, tre PF OOS sotto 1, su 719 operazioni fuori campione.**

---

## 3. 🎯 ANCORA UNICA: **NO.** Ancorata a **BARRE per lo stop, ASSOLUTO per tutto il resto**

| gamba | valore | ancora |
|---|---|---|
| stop | `range della candela + 7` (r.469-470) | 🟢 **BARRE** — si stringe scendendo di TF |
| buffer d'ingresso | **7 punti fissi** (r.38) | 🔴 **ASSOLUTO** |
| cancello di ampiezza | **17 punti fissi** (r.37) | 🔴 **ASSOLUTO** |
| primo obiettivo + BE | **20 punti fissi** (r.39) | 🔴 **ASSOLUTO** |
| target finale | **50 punti fissi** (r.40) | 🔴 **ASSOLUTO** |
| finestra oraria | 15:25 / 15:30 / 18:00 / 21:55 | 🔴 **CALENDARIO** |

### 🔴 E il verso dello sbilanciamento e' **quello sbagliato**, coi numeri

Con **stop variabile** e **target fisso**, l'RR **peggiora** man mano che il setup si
allarga. Ma il take vero **non e' 50**: col parziale acceso (50% a +20, resto a +50)
il guadagno pieno vale `0,5 x 20 + 0,5 x 50 =` **35 punti**, mentre la perdita piena
resta **1R = range + 7**.

| range candela | stop = r+7 | **RR lordo** (50/stop) | **RR EFFETTIVO** (35/stop) |
|---:|---:|---:|---:|
| **17** (il minimo ammesso) | 24 | 2,083 | **1,458** |
| 25 | 32 | 1,562 | 1,094 |
| **28** | 35 | 1,429 | 🔴 **1,000** |
| 40 (tetto che l'EA **non ha**) | 47 | 1,064 | 🔴 **0,745** |
| 65 (serve per il 40x, §4) | 72 | 0,694 | 🔴 **0,486** |

_(I tre valori della consegna — 2,08 / 1,56 / 1,06 — sono riprodotti esatti dalla
colonna "RR lordo": la formula regge contro numeri scritti da qualcun altro.)_

> ## 🔴 **DA `range >= 28` IN SU, L'EA RISCHIA PIU' DI QUANTO PUO' VINCERE.**
> E il suo documento di origine chiede **RR minimo 1:2**
> (`CACCIA_MOTORE_APERTURE.md` r.112-118, dal `Piano_Trading__NASDAQ__ABTG`).
> Per avere RR effettivo **>= 2** servirebbe `range <= 10,5` — cioe' **sotto il
> cancello di 17 che l'EA stesso impone**.
> 👉 **L'insieme dei range che soddisfano la regola del piano e' VUOTO.
> Questo EA non puo' consegnare l'1:2 che promette, per nessun valore del range.**

### 🔴 E il tetto dei 40 punti che l'EA **ha buttato via** era li' apposta

`backtest_pipeline/REGISTRO_TEST.md` r.192, scritto quando abbiamo trascritto la live:

> _"Filtro ampiezza candela **17-40 punti** (sotto=whipsaw, **sopra=stop troppo
> largo**)."_

L'EA esterno tiene il 17 e **butta il 40**. Cioe' tiene il cancello che protegge dal
whipsaw e toglie quello che protegge **esattamente dal difetto strutturale che ha**.
Nella tabella qui sopra, e' la differenza fra fermarsi a RR 0,745 e scendere a 0,486.

---

## 4. 💸 LA FRONTIERA DEL COSTO — col numero, e a quale range si arriva al 40x

**Spread MISURATO** su `NASUSD`, `data/spread_vivo/SPREAD_VIVO_2026-09-12_referto.txt`,
**ora 14 server** (= 15:00-16:00 Roma, il secchio che contiene sia la candela
15:25-15:30 sia l'apertura): **n=3.578 campioni su 5 giornate** —
**mediana 1,800 · P95 1,900 · P99 1,900 · max 1,900** punti indice.

| soglia | formula | **range richiesto** |
|---|---|---:|
| pavimento **DURO 13,3x** @ spread mediano 1,80 | `13,3 x 1,80 − 7` | **16,94** |
| pavimento **DURO 13,3x** @ spread P95 1,90 | `13,3 x 1,90 − 7` | **18,27** |
| pavimento di **LAVORO 40x** @ 1,80 | `40 x 1,80 − 7` | 🔴 **65,00** |
| pavimento di **LAVORO 40x** @ 1,90 | `40 x 1,90 − 7` | 🔴 **69,00** |

### 🔴 I tre fatti che ne escono

**(a) Il cancello dell'EA e' tarato SOTTO il pavimento duro.**
Al minimo ammesso (`range 17`) lo stop e' **24** → **24/1,80 = 13,33x**, cioe' **il
pavimento duro al decimale, con un margine dello 0,25%**. Ma allo spread **P95 (1,90),
che nell'ora 14 e' anche il MASSIMO osservato**, lo stesso setup fa **24/1,90 =
12,63x** → 🔴 **SOTTO IL DURO**. Perche' il 13,3x fosse garantito, `InpMinCandlePoints`
dovrebbe stare a **18,3**, non a 17,0.

**(b) Il 40x si raggiunge a `range >= 65`. Quanto e' frequente? Poco, e si calcola.**
Usando la **stessa scala radice-del-tempo gia' in uso in casa** — verifica:
`239,4 x sqrt(30/1440) = 34,6`, che riproduce **esatto** l'`ATR(M30) al p25` scritto in
`REGISTRO_TEST.md` r.3087 — il range atteso di una barra **M5** di NASUSD nella
giornata al **p25** vale `239,4 x sqrt(5/1440) =` **14,11 punti indice** `[DERIVATO]`.
- **14,11 sta SOTTO il cancello di 17.** Su una giornata al p25 di volatilita', la
  candela pre-apertura e' attesa **sotto soglia** → **nessun trade**.
- **65 punti in cinque minuti sono il 27,2% dell'INTERO range giornaliero al p25.**
- 🔎 **Contro-esempio costruito contro me stesso:** la finestra 15:25-15:30 **non e'**
  una barra M5 qualunque, e' la piu' calda del pre-market, quindi la scala uniforme
  sottostima. Raddoppiandola (`x2`, generoso) si arriva a **28,2** — che e' esattamente
  il punto dove **RR effettivo = 1,000** e resta a **15,7x**, **meno della meta' del
  40x**. 👉 **Il contro-esempio non salva l'EA: lo porta sul filo.**
- 🔎 Secondo appoggio indipendente, sempre di casa: `REGISTRO_TEST.md` r.3054 dà per
  `AtrExhaustVol` **NASUSD M5** uno stop di **~18,5 idx `[DER]` = 10,9x**, gia'
  **escluso PER COSTO**. Stesso simbolo, stesso TF, stesso ordine di grandezza.

**(c) E le due condizioni sono MUTUAMENTE ESCLUSIVE — e' algebra, non opinione.**
- per il **40x** serve `stop >= 72`;
- per **RR effettivo >= 1** serve `stop <= 35`;
- per il **RR 1:2 del piano** serve `stop <= 17,5`.

> 🔴 **`72 <= stop <= 35` non ha soluzioni. L'intersezione e' VUOTA.**
> Su NASUSD, allo spread BCM misurato, **non esiste nessun range della candela
> pre-apertura che paghi il pedaggio di casa E dia un RR >= 1** con
> `InpTargetPoints = 50`. L'unica manopola che scioglierebbe il nodo e'
> **il target** — che e' un parametro di un motore **gia' dichiarato senza edge**,
> cioe' 🚫 **esattamente quello che la regola del 19/08 vieta di toccare.**

---

## 5. 🧾 LA TABELLA DEI DIFETTI, per gravita'

| # | grav. | difetto | riga | **conseguenza, col numero** |
|---|---|---|---|---|
| **D1** | 🔴🔴 | **L'orologio si rompe DENTRO la challenge.** `InpLocalUtcOffsetHours=2` e' **cablato** e l'EA e' ancorato all'orologio di **ROMA**, non a quello della **BORSA** | r.25 · r.116-126 · r.135-144 | **Dal 1 nov 2026 al 14 mar 2027 (~95 sedute) arma sulla candela 14:25-14:30 Roma: 60 minuti PRIMA della vera pre-apertura.** Silenzioso — nessun errore nel log, l'EA trada come sempre. Tabella sotto |
| **D2** | 🔴🔴 | **Nel TESTER l'orologio potrebbe essere sfasato di 1h**: `TimeTradeServer()-TimeGMT()` vale **0** quando il tester modella GMT = ora server | r.118 · r.125 | Se e' cosi', in backtest Roma = `server + 2h` → arma a **13:25 server = 14:25 Roma**: **misura una candela che non c'entra**. 👉 **Finche' non e' verificato, NESSUN PF di questo EA e' leggibile.** Verifica in §7 |
| **D3** | 🔴 | **Il meccanismo e' gia' misurato in casa e non passa** | — | `Live5m` 770203, tick reali: **PF OOS 0,96265 · n 175 · DD 19,40% · −326,54 €** |
| **D4** | 🔴 | **Ancora NON unica** + **manca il tetto di 40 punti** che il nostro gemello ha | r.37-40 · r.443 | RR effettivo **1,000 a range 28**, **0,745 a range 40**, **0,486 a range 65**. L'1:2 del piano d'origine e' **irraggiungibile per ogni range** |
| **D5** | 🔴 | **Frontiera del costo sfondata al cancello** | r.37 · r.467-470 | **13,33x** allo spread mediano (duro 13,3x), **12,63x** al P95 → **sotto il duro**. Il 40x a **range 65** = 27,2% del range giornaliero p25 |
| **D6** | 🟠 | **Il rischio RADDOPPIA in `NPO_TREND_NO_FILTER`**: i pesi restano 100/100 perche' solo il ramo `BOTH` li riscrive | r.477-488 | In `BOTH` (default) 70+30 = **100% di `InpRiskPercent`** ✅. In `NO_FILTER` (=2) **100+100 = 2 x `InpRiskPercent` = 2,00%** su un conto hedging, **senza che nessun messaggio lo dica** |
| **D7** | 🟠 | **Doppio fill possibile → posizione ORFANA.** `g_fillHandled` blocca la seconda gestione; `NPO_SelectPosition` restituisce la **prima** posizione trovata | r.590 · r.392-402 · r.420-429 | La cancellazione dell'opposto parte da `OnTradeTransaction`, **asincrona**: in un whipsaw sul tick d'apertura entrambi i pendenti possono riempire. La seconda posizione **non ha BE, ne' parziale, ne' target, ne' chiusura alle 21:55** — solo lo SL del pendente. E `g_tradesToday` conta **1**, quindi il tetto giornaliero non se ne accorge |
| **D8** | 🟠 | **Il rischio reale puo' solo SALIRE con lo slippage** (mai scendere) | r.498 · r.588-612 | Il lotto nasce su `stop = range+7`; un `BuyStop` riempie **a prezzo >= stop**, quindi la distanza dal `preLow` **cresce sempre**. A `range 17` (stop 24): **+5 idx di slippage = +20,8% di rischio**, **+10 = +41,7%**. La riscrittura dello SL a r.599 **non** ricalcola il lotto, quindi il 1,0% dichiarato diventa **1,21-1,42%** |
| **D9** | 🟠 | **Il breakeven non viene MAI ritentato** se la `PositionModify` fallisce ma il parziale riesce | r.661-698 | `partialDone=true` chiude l'intero blocco per sempre. Il "resto protetto" corre col **1R pieno**: a range 17, invece del `+10` promesso si rischia un **−2** netto (`+10` incassati − `12` di stop sulla meta' residua) |
| **D10** | 🟠 | **Raffica di ordini su fallimento**: se `BuyStop`/`SellStop` falliscono, `g_ordersPlaced` resta `false` | r.524-534 · r.357 | Ritenta **a OGNI TICK** dalle 15:30 alle 18:00 (150 minuti). Il retcode finisce solo in una stringa di stato, **nessun log d'errore, nessun backoff** |
| **D11** | 🟠 | **Doppio parziale dopo una re-inizializzazione** | r.544-558 · r.848 | `NPO_RegisterTradeState` legge `initialVolume` dal volume **gia' ridotto** e rimette `partialDone=false`: a EA ricaricato con posizione aperta, sopra +20 chiude **un altro 50%** |
| **D12** | 🟡 | **Nessun Guardian, nessun filtro news, nessun filtro spread** (verificato: **0 occorrenze**) | tutto il file | Fuori dal pacchetto firmato il 18/08 (pausa B1, cap C1 3,25%). Il nostro gemello 770203 il gancio Guardian **ce l'ha**. E `InpRiskPercent=1,0%` e' **1,54x** l'unita' di casa (0,65%) |
| **D13** | 🟡 | **`OnTick` senza guardia di barra nuova** | r.868-883 | `Comment()`, `ObjectMove` x5 e **quattro** scansioni separate di `PositionsTotal()` a **ogni tick**, incluso il minuto piu' denso della giornata. `Comment()` forza il ridisegno del grafico |
| **D14** | 🟡 | **Con `InpTimeframe != M5` l'EA fa ZERO trade, in silenzio** | r.288-293 · r.834-835 | Su M15 nessuna barra apre a `:25` → `NPO_BarIsPreOpen` sempre `false`. `OnInit` stampa un avviso e **prosegue**. 🔴 **Trappola diretta per il punto 5 del certificato di morte** ("il TF e' stato cambiato?"): darebbe `Trades=0`, che in casa vale **"non e' girata"**, non "non ha edge" |
| **D15** | 🟡 | **Il pannello mente**: `g_strategyActive` non diventa **mai** `true` | r.336 · r.341 · r.822 | Il blocco che lo valorizza e' sotto `if(... && !g_preReady)`, ma `g_preReady` e' gia' `true` dalla barra in formazione → il ramo **non viene mai eseguito**. In forward il pannello dice **"Strategia attiva: NO"** anche nei giorni in cui l'EA trada |
| **D16** | 🟡 | **Il "breakeven" e' a prezzo d'ingresso esatto**, senza offset | r.643 | Su NASUSD significa uscire perdendo **lo spread (1,80 idx) + commissioni**. Su stop 24 e' il **7,5%** di 1R regalato a ogni BE |
| **D17** | ⚪ | `SetDeviationInPoints(30)` = **0,30 idx**, sei volte piu' stretto dello spread | r.492 | ⚠️ **Non e' un difetto NUOVO**: in **Market Execution la deviazione e' IGNORATA** [VERIFICATO, `backtest_pipeline/caccia_strategie/CONFIG_PROP_SPREAD_SLIPPAGE_2026-09-05.md` r.344], e **la modalita' di BCM e' `[NON MISURATA]`** — stesso buco dei nostri 61 `SetDeviationInPoints(30)`. Da tenere, non da imputare a lui |

### 🕐 D1 in dettaglio — le quattro finestre DST, incluse le due in cui l'errore si compensa

L'offset del **server** si auto-corregge (`TimeTradeServer()-TimeGMT()`, letto a
runtime); e' l'offset di **Roma** a essere cablato. E l'EA ancora tutto all'orologio di
**Roma**, mentre l'evento che vuole prendere e' definito da **New York** (9:30 ET).

| periodo | Roma | New York | **vera candela pre-open (Roma)** | **quando arma l'EA** | esito |
|---|---|---|---|---|---|
| ~29 mar → **25 ott 2026** | CEST +2 | EDT | 15:25-15:30 | 15:25 | 🟢 **giusto** |
| **25 ott → 1 nov 2026** | CET +1 | EDT | 14:25-14:30 | 14:25 | 🟢 giusto **per compensazione** |
| 🔴 **1 nov 2026 → 14 mar 2027** | CET +1 | EST | **15:25-15:30** | 🔴 **14:25** | 🔴 **UN'ORA PRIMA** |
| 14 mar → 28 mar 2027 | CET +1 | EDT | 14:25-14:30 | 14:25 | 🟢 giusto per compensazione |

> 🔎 **Contro-esempio costruito e verificato:** _"l'offset e' un `input`, basta metterlo
> a 1 il 25 ottobre"_. 🔴 **Non basta, ed e' il punto**: nella riga 2 e nella riga 4
> l'offset "sbagliato" (2) e' quello che fa armare **giusto**, perche' i due errori si
> annullano. Metterlo a 1 il 25 ottobre **romperebbe quella settimana**. La correzione
> giusta non e' un numero diverso: e' **ancorare l'EA all'orologio della BORSA** invece
> che a quello di Roma. Con l'ancoraggio a Roma servono **quattro cambi manuali
> all'anno, in date che non coincidono con nessuna delle due transizioni**.
> 🎯 **E la finestra rotta e' proprio quella della fase funded** di una challenge che
> parte ai primi di ottobre.

---

## 6. ✅ I CONTRO-ESEMPI CHE HANNO SALVATO L'EA — cose che sembravano difetti e NON lo sono

Costruiti apposta per rompere le mie stesse accuse. Questi hanno retto:

| accusa | verdetto | **prova** |
|---|---|---|
| `NPO_ResetDayState` (r.164) chiama `NPO_ClearTradeState` definita a r.538: **non compila?** | 🟢 **COMPILA** | **MQL5 risolve le funzioni globali in una passata preliminare.** Prova in casa, non da manuale: `mql5/Experts/ABTG_Nasdaq_Apertura_US.mq5` chiama `ComputeRangeWindow` a **r.924** e la definisce a **r.931** — e quell'EA ha prodotto i CSV che abbiamo letto oggi. Idem `NPO_ShouldPlaceOrdersNow` (r.355) → `NPO_HasOurPosition` (r.380) |
| `InpPointSize = 1.0`: **errore di un fattore 100?** | 🟢 **CORRETTO** | Gate firmato R97: su **NASUSD 1 punto indice = 100 punti MT5 = 1,00 di prezzo**. `InpPointSize=1.0` e' **esatto**, e `NPO_ValidateStops` usa `stopsLevel * _Point` che e' anch'esso in **unita' di prezzo**: le due scale **coincidono**. Nessun fattore 100 |
| `NPO_ValidateStops` allarga lo stop: **il lotto e' gia' calcolato?** | 🟢 **ORDINE GIUSTO** | `ValidateStops` a r.474-475, `CalcLots` a r.498/512: il lotto nasce **dopo**, sullo stop corretto |
| `LoadPreOpenCandle(true)` legge la **barra in formazione** (shift 0) | 🟢 **NON e' un errore di misura** | All'ultimo tick della candela, `iHigh/iLow` della barra in formazione **coincidono** con quelli della barra chiusa. Con `InpEarlyPlaceSeconds=0` (default) il piazzamento avviene comunque **dopo** le 15:30 (r.373). ⚠️ Con `InpEarlyPlaceSeconds > 0` **sì**, misurerebbe una candela incompleta: l'input **va lasciato a 0** |
| I pesi 70/30 **raddoppiano il rischio** | 🟡 **NO in `BOTH`, SI in `NO_FILTER`** | 70+30 = **100% di `InpRiskPercent`** ✅. Ma `NO_FILTER` non entra in nessuno dei due rami di r.479-488 e resta a **100+100** → vedi **D6** |
| `PositionSelect` cieco su hedging (il difetto del 03/09) | 🟢 **NON CE L'HA** | r.380-402 usa `PositionsTotal()` + `SelectByIndex` + filtro simbolo **e** magic: il pattern giusto |

---

## 7. 🔬 LA VERIFICA CHE COSTA ZERO E SBLOCCA D2 — **nessun codice da scrivere**

L'EA **stampa gia'** la sua ora di Roma sul pannello: r.819 `"Ora Roma: ", TimeToString(romeNow, TIME_MINUTES)`.

🪟 **BERSAGLIO: terminale MT5 `50504400` (`C:\MT5_Backtest`)** — Strategy Tester in
**modalita' VISIVA**, un solo giorno, `NASUSD M5`. **Non si tocca nessun altro
terminale: ne' `50503392`, ne' `50504263`, ne' il REALE `10105439`, ne' Pepperstone,
ne' Tickmill.**

Si legge **l'ora del pannello** e la si confronta con **l'ora dell'ultima candela**:
- pannello = candela **+1h** → `TimeTradeServer()-TimeGMT()` vale **0** nel tester →
  🔴 **D2 CONFERMATO**: ogni backtest di questo EA misura la candela sbagliata;
- pannello = candela **+0h**... ⚠️ **attenzione, questo NON e' il caso buono**: il
  pannello **deve** stare un'ora **avanti** rispetto al grafico (Roma = server + 1).
  Se coincidono, l'orologio e' sfasato in senso opposto.

🔎 **Contro-esempio sulla verifica stessa** (classe 178 — "quale numero produce
l'ALTRA spiegazione?"): la misura distingue le due ipotesi **solo perche' le due
attese sono numeri diversi e non adiacenti** (`+1h` = sano, `+2h` = rotto). Se avessi
proposto _"controlla che l'EA armi alle 15:25"_, **entrambe** le ipotesi avrebbero
prodotto "15:25" sul pannello — e la verifica non avrebbe misurato niente. Per questo
si legge **la differenza pannello-grafico**, non il valore del pannello.

---

## 8. ⚖️ VERDETTO SUL MECCANISMO

> ## 🪦 **NON E' UN MECCANISMO NUOVO. E' `ABTG_Nasdaq_Live5m` (magic `770203`), gia' misurato a TICK REALI: PF OOS 0,96265 su n=175, DD 19,40%, −326,54 €.**
> Sei ingredienti su nove sono **identici alla virgola** (range da `[apertura−5min,
> apertura)`, buffer 7, cancello 17, stop al bordo opposto, 50% al primo obiettivo, un
> trade al giorno). Stessa fonte: **la live ABTG di E. Monza del 17/07/26**.
> **Non e' il cugino `770201`** — quello prende la candela H1 precedente, e su quello
> il sospetto della consegna era corretto. E' **un terzo EA di casa** che non era stato
> censito in questa conversazione.

**Cosa c'e' davvero di diverso: l'USCITA.** E la regola del 19/08 dice che **la
gestione dell'uscita E' un asse legittimo di allargamento**. Quindi la domanda giusta
non e' _"e' nuovo?"_ (no) ma _"questa uscita vale una misura?"_.

🔴 **Risposta: no, e si sa PRIMA di girarla.** L'uscita del gemello di casa ha il primo
obiettivo a **1R** — cioe' **ancorato allo stop**. L'EA esterno lo sostituisce con
**+20 punti fissi** e il trailing con **+50 punti fissi**. Su un'ancora gia' mista,
questo e' un **peggioramento in direzione nota**, e produce l'insieme vuoto del §4c.
👉 **Non e' "un altro punto sull'asse dell'uscita": e' lo stesso asse percorso nel
verso sbagliato.**

---

## 9. 🚪 VALE UN POSTO NELL'IMBUTO A 19 GIORNI DALLA CHALLENGE?

# ❌ **NO.**

E i cinque motivi sono **tutti numerici**, nessuno e' un'opinione:

1. **Il meccanismo d'ingresso e' misurato e bocciato**: PF OOS **0,96265** su
   **n=175** a tick reali, DD **19,40%**. E i gemelli di simbolo fanno **0,92** e
   **0,86** su altre **544** operazioni OOS. **719 operazioni fuori campione, tre PF
   sotto 1.**
2. **La frontiera del costo e l'RR sono INCOMPATIBILI**: `stop >= 72` e `stop <= 35`
   non hanno intersezione. Non e' un parametro da tarare, e' aritmetica.
3. **Il cancello di 17 sta SOTTO il pavimento duro** allo spread P95 misurato
   (**12,63x** contro 13,3x).
4. **L'orologio si rompe dal 1 novembre 2026**, cioe' **dentro la fase funded**, e in
   modo **silenzioso**.
5. 🎯 **E la bussola**: a 19 giorni, un candidato vale un posto se **accorcia** la
   strada a una sedia schierabile. Questo la allunga — richiede la verifica D2, poi la
   riparazione dell'orologio (D1), poi D6-D11, **e solo allora** potrebbe girare per
   riprodurre un PF che **abbiamo gia' e vale 0,96**.

### 🪦 IL CERTIFICATO DI MORTE — le cinque voci, una per una

Verdetto per il **MECCANISMO** (candela 5' pre-apertura + buffer 7 + stop al bordo),
non per il file `.mq5` esterno:

| # | voce richiesta | esito |
|---|---|---|
| 1 | **PF misurato** | ✅ **1,01621 IS / 0,96265 OOS**, tick reali |
| 2 | **n e DD** | ✅ **116 / 175**, **11,52% / 19,40%** |
| 3 | **gestione dell'uscita messa ad asse** | ❌ **NO** — il CSV ha **2 passate e 1 esito distinto**: e' una cella singola girata due volte, **nessun asse** |
| 4 | **simboli gemelli provati** | ✅ **D30EUR x2** (`Live5m` 0,86 · `Live5m_v2` 0,92 OOS) |
| 5 | **TF cambiato almeno una volta** | ❌ **NO** — e qui "TF" per questo motore significa **la LUNGHEZZA della finestra pre-apertura**: girata **solo a 5 minuti** |

> ## ⚪ Quindi, alla lettera della regola del 09/09: il verdetto sul meccanismo e' **"BOCCIATO SULL'INGRESSO, NON ANCORA MISURATO SU DUE ASSI"**, e le due caselle vuote vanno scritte — non nascoste.

### 🔥 E SICCOME NON CI ACCONTENTIAMO: **la casella 5 nasconde un buco vero**, e non e' di questo EA

Il `Piano_Trading__NASDAQ__ABTG` prescrive **15 minuti** di pre-apertura
(`CACCIA_MOTORE_APERTURE.md` r.112: _"Canale = MAX/MIN dei **15 minuti**
PRE-apertura"_). Noi abbiamo girato **5**. E il round PREOPEN (mai lanciato:
**zero CSV `PREOPEN*`** in tutto il repo, confermato) ha una griglia
`InpPrevWindowMin` che va da **60 a 300**.

> ## 🕳️ **FRA 5 E 60 MINUTI NON C'E' MAI STATA NESSUNA MISURA. E il valore che il piano d'origine PRESCRIVE — 15 — sta esattamente dentro quel buco.**

E non e' una curiosita': **a 15 minuti l'aritmetica del §4 cambia di segno.** Col
range atteso che scala come `sqrt(T)`, passare da 5 a 15 minuti lo moltiplica per
**1,73** (da ~14,1 a **~24,4** al p25) → lo stop sale a ~31,4 → **17,5x** invece di
13,3x, cioe' **sopra il pavimento duro con margine**, e il cancello dei 17 punti
smette di essere il collo di bottiglia. 🔴 **Con `InpTargetPoints` fisso l'RR
peggiorerebbe** — ma la manopola giusta li' e' l'uscita **1R** che il nostro
`Live5m` **ha gia'**, non il 50 fisso dell'EA esterno.

🙋 **La cosa da fare non e' questo EA: e' `InpPrevWindowMin` = 10 · 15 · 20 · 30 su
`ABTG_Nasdaq_Live5m`, a tick reali, coi due lati.** Motore nostro, gia' compilato,
orologio in **ora server** (nessun D1, nessun D2), Guardian gia' agganciato, uscita
gia' ancorata a 1R. Un file prova, **zero righe di codice**.
⚠️ **E va detto con la stessa onesta' del resto**: il **5** vale 0,96 e il **60-300**
non e' mai girato, quindi **e' un buco, non una promessa**. Puo' benissimo uscirne un
altro 0,9x.

**🛑 E la regola vieta di allargare la griglia di un motore senza edge.** Questo
allargamento e' ammesso **solo** perche' `InpPrevWindowMin` **non e' un parametro
tarabile: e' la DEFINIZIONE della finestra**, cioe' del meccanismo — e perche'
il valore **15** viene dal **documento d'origine**, non dal tester. Se serve una
firma per distinguerlo dalla pesca, **va chiesta prima, non dopo**.
📌 **Non scrivo il file prova in questo giro**: e' un round nuovo con criteri da
congelare, e la coda delle 03:30 (45 righe) **non si tocca**.

### 📋 LA RIGA PRONTA PER `backtest_pipeline/REGISTRO_TEST.md` (sezione 1, APERTURE)

**Non l'ho incollata io** — `REGISTRO_TEST.md` e' un file condiviso e la riga A5 va
riscritta, non solo appesa. Testo proposto:

```
| A6 | Nasdaq_PreOpen_Breakout (ESTERNO, non nostro) | NASUSD | candela M5 15:25-15:30 Roma, buffer 7 pt, stop al bordo opposto | target FISSO 50 pt + 50% a +20 pt, NESSUN tetto di ampiezza, EMA50 pesa 70/30 | — (non girato) | 🪦 **MECCANISMO GIA' MISURATO**: e' `ABTG_Nasdaq_Live5m` 770203 — tick reali **PF IS 1,01621 (n 116, DD 11,52%, +98,96) · PF OOS 0,96265 (n 175, DD 19,40%, −326,54)**. In piu': RR effettivo **1,00 a range 28** e **0,486 a range 65**; **stop/spread 13,33x** (mediana 1,80 MIS) e **12,63x** al P95 = **sotto il pavimento DURO 13,3x**; `stop>=72` (40x) e `stop<=35` (RR>=1) **non hanno intersezione** | 🔴 **SCARTATO — cancello COSTO + cancello PF OOS.** Referto: `report/AUDIT_NASDAQ_PREOPEN_2026-09-12.md` |
```

**E la riga A5 va corretta**, perche' oggi dice `⏳ in coda` una cosa che **e' stata
girata**: `A5` ("stile Monza", candela 5-min pre-apertura, filtro 17-40) e'
**`ABTG_Nasdaq_Live5m` 770203**, e i suoi CSV stanno in
`backtest_pipeline/risultati_prove/ABTG_Nasdaq_Live5m/`. 🔴 **Un "⏳ in coda" che in
realta' e' un `0,96` misurato e' esattamente il tipo di buco che il certificato di
morte doveva chiudere.**

---

## 10. 🚫 CIO' CHE **NON** HO MISURATO — dichiarato, non nascosto

| cosa | stato |
|---|---|
| **La distribuzione VERA del range della candela 15:25-15:30 su NASUSD** | 🔴 **`[NON MISURATO]`**. Il **14,11** e' `[DERIVATO]` con la scala radice-del-tempo di casa dal `p25` giornaliero (239,4). Serve una sonda per averlo davvero |
| **La frequenza dell'EA** (quanti giorni superano il cancello di 17) | 🔴 **`[NON MISURATO]`** — dipende dalla riga sopra |
| **Se `TimeGMT()` = `TimeTradeServer()` nel tester BCM** (D2) | 🔴 **`[NON VERIFICATO]`** — la verifica costa un giro visivo, §7 |
| **La modalita' di esecuzione di BCM** (`SYMBOL_TRADE_EXEMODE`, D17) | 🔴 **`[NON MISURATA]`** — buco gia' a registro dal 05/09, non imputabile a questo EA |
| **Commissioni e swap** sugli indici BCM | 🔴 **`[NON MISURATI]`** — i conti del §4 sono **solo spread**: il pedaggio vero e' **>= 1,80**, quindi tutti i multipli `x` qui sopra sono **ottimistici** |
| **Il comportamento della barra in formazione con `InpEarlyPlaceSeconds > 0`** | 🟡 analizzato staticamente, non girato |
| **Compilazione** | 🔴 **Non compilato** — in questo ambiente non c'e' MetaEditor. Le affermazioni sulla compilabilita' (§6) poggiano su un **precedente nel repo**, non su un compilatore |

---

## 🚦 CANCELLO

- 🟢 **Strato 1 — `python3 backtest_pipeline/controlla_riga.py`**: **non applicabile.**
  Questa consegna e' **un `.md` di sola lettura**: nessuna riga di lancio, nessuno
  `.ps1`, nessun file prova, nessun `.ini`, nessuna modifica a un EA, nessun magic
  nuovo, niente che tocchi la coda o il forward.
- 🟡 **Strato 2 — agente `controllo-preventivo`**: **lo lancia il chiamante**, come da
  mandato. 🔴 **Questo referto contiene un VERDETTO CHE ARCHIVIA UN CANDIDATO**, e la
  regola del 09/09 dice che i verdetti di archiviazione **passano dal cancello**.
  👉 **La riga `A6` non va incollata in `REGISTRO_TEST.md` prima del PASS.**
- ✅ **Confini rispettati**: nessun `ABTG_*.mq5` toccato · nessun preset ·
  `backtest_pipeline/coda/CODA.txt` non aperto in scrittura ·
  `walkforward_generico.ps1` e `RIGA_SOTTILE_ROUND.ps1` non toccati · nessun backtest
  eseguito · nessun saldo/equita'/P/L del **10105439** o del **50504263** in questo
  file (i numeri citati sono **profitti di backtest** su deposito di prova).

---

_Referto scritto il 12/09/2026. Tutti i numeri vengono da: i CSV in
`backtest_pipeline/risultati_prove/ABTG_Nasdaq_Live5m/`,
`data/spread_vivo/SPREAD_VIVO_2026-09-12_referto.txt`,
`backtest_pipeline/REGISTRO_TEST.md`, `report/CENSIMENTO_PF_MISURATI_2026-09-09.md`
e dal sorgente in esame. Dove non c'e' una fonte, c'e' scritto `[DERIVATO]` o
`[NON MISURATO]`._
