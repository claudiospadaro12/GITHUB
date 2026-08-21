# 📋 R92-SCAN BULGE — REFERTO, 21/08/2026

**Criteri firmati PRIMA dei numeri:** `R92_CRITERI.md`
(firma di Claudio: *"c,firmo 0,8,misura entrambe"*).
**Pin script:** `bdaf3601be53e2d21d38ba22cce239821be0d735` · **rischio 0,80%**
(verificato: 44/44 `.ini` dicono `Risk_Percent=0.8||0.8||0||0.8||N`).
**Finestra:** 2022.01.01 – 2026.06.30 · H1 · OHLC M1 (Modello 1).

---

## ⚫ VERDETTO: **NESSUN SIMBOLO PROMOSSO. 0 su 22.**

E **non** per il profitto: per il **CAMPIONE**. Il round si ferma sul primo
cancello e, per regola di casa (§3.1), **oltre quello non si legge niente**.

| soglia firmata | esito |
|---|---|
| **S1 — n >= 30** | **0 simboli su 22.** Il massimo assoluto e' **GBPUSD n=11** |
| **bocciatura secca n < 20** | **22 simboli su 22** la prendono |
| **S2 — PF >= 1,30** | **non si legge** (§3.1: *"un numero senza n non entra nel referto"*) |
| **S3 — WR >= 65%** | **non si legge** (e i per-trade per calcolarlo non sono nella raccolta) |

---

## 📉 IL FATTO CENTRALE: LA FREQUENZA E' ~10 VOLTE SOTTO IL DICHIARATO

| | dichiarato (backtest di Claudio) | **misurato da R92** |
|---|---:|---:|
| trade per simbolo per anno | **~10,5** | **~1,07** |
| trade per simbolo su 4,5 anni | **~47** (atteso scritto nei criteri) | **4,8** |
| totale (cella base, 22 cross) | — | **106** |

Distribuzione: **n=1** su AUDJPY/AUDUSD/USDCAD, **n=11** su GBPUSD (il massimo).

⚠️ **Questo e' il numero che il round doveva falsificare, e l'ha falsificato.**
I criteri §1 lo dicevano prima: *"se lo scan NON riproduce quel profilo,
l'ipotesi numero uno non e' «il mercato e' cambiato»"*. Ma **prima** di
attribuirlo ai dati al 40% di qualita' del backtest originale, questo referto
nomina una causa **piu' vicina e MISURATA** — sotto.

---

## 🐤 I CANARINI — ed e' qui che il round diventa utile

### 🟣 CANARINO 1 (nuovo, MISURATO): **il VIOLA-PINE non scatta MAI. 0 trade su 44 celle su 44.**

Non e' "piu' selettivo": e' **morto**. E la causa sta nel codice, riga 1089-1094
di `ABTG_Bulge.mq5`:

```
bool PurpleReactionOk(bool isLong, double open0, double close0, double atr1)
{
   if(Use_Purple_PineReaction)
      return isLong ? (close0 > open0) : (close0 < open0);   // VIOLA-PINE
   return (MathAbs(close0 - open0) <= atr1 * 1.5);           // VIOLA-EA (default)
}
```

`CheckSignal` gira **una volta per barra, al primo tick**. Al primo tick della
barra 0, **`close0 == open0`**. Quindi `close0 > open0` e' **sempre falso**, e
`close0 < open0` **anche**. Il PINE non puo' scattare, in nessun mercato,
in nessuna finestra.

> ### 🎯 E' LO STESSO IDENTICO DIFETTO CHE I CRITERI AVEVANO GIA' NOMINATO PER IL BLU
> §2.1: *"la conferma BLU pretende `closes[0] > opens[0]` sulla barra 0 — che al
> primo tick e' uguale all'apertura. Sul simbolo del grafico il BLU rischia di
> non scattare mai."* Era etichettato **[INFERITO dal codice, NON misurato]**.
> **R92 lo ha MISURATO** — e ha scoperto che colpisce **due** segnali, non uno.

**Conseguenza sulla firma:** la firma diceva *"misura entrambe"* (le due versioni
del VIOLA). **Le 44 passate del PINE non hanno misurato niente**: hanno misurato
un segnale che il banco non puo' produrre. Meta' round e' andata a vuoto.

### 🔵 CANARINO 2 (AGGRAVATO dopo lettura del codice): **nello scan il BLU e' 0 PER COSTRUZIONE, non "quasi muto".**

Prima lettura (dal collaudo PASSO 2B sul basket): `aperture=115 -> BLU=6`, cioe'
il 5%. **Ma quel 6 e' del BASKET, e nello SCAN non puo' esistere.** Riga 1227:

```
bool confirmLong  = (closes[0] > opens[0] && ...);
```

Nello scan **ogni passata gira su UN simbolo solo, che e' il simbolo del
grafico**: `OnTick` scatta al primo tick della sua barra 0, dove
`closes[0] == opens[0]`. Il BLU **non puo' scattare**. Il 6 del basket veniva
dai simboli **NON** del grafico, dove la barra 0 puo' avere gia' un corpo
perche' l'EA se ne accorge in ritardo (ed e' esattamente cio' che §2.1
prevedeva come **[INFERITO]**: adesso e' **misurato**).

`Use_Orange=0` nella cella firmata. Quindi, dei tre segnali:
**ARANCIO spento per firma · BLU impossibile · PINE impossibile.**

### 🟪 CANARINO 2-bis (NUOVO, il piu' pesante): **anche il VIOLA-EA gira con la sua condizione SVUOTATA.**

Il VIOLA-EA e' l'altra faccia della stessa funzione (riga 1093):

```
return (MathAbs(close0 - open0) <= atr1 * 1.5);   // VIOLA-EA (default)
```

Al primo tick `close0 - open0 == 0`, e **`0 <= 1,5 x ATR` e' SEMPRE VERO**.

> ### 🎯 Quindi: la stessa riga di codice rende il PINE **sempre falso** e l'EA **sempre vero**.
> **Le 106 operazioni di R92 sono TUTTE VIOLA, e sono VIOLA con la
> condizione "candela di reazione" DISATTIVATA.** Non e' il VIOLA del motore
> di Claudio: e' una sua versione **piu' larga**, che dovrebbe fare **piu'**
> trade dell'originale — e ne fa comunque 4,8 per simbolo.
>
> **Questo e' il numero che pesa davvero**: la frequenza non e' bassa
> *nonostante* i filtri, e' bassa **con un filtro in meno**.

### 👯 CANARINO 3 (passato): **n(PINE) <= n(EA)** — 0 violazioni su 22.
Formalmente rispettato, ma **vuoto**: e' rispettato perche' n(PINE)=0 ovunque.

### 🔁 CANARINO 4 (nuovo): **la gestione non cambia NIENTE su 21 simboli su 22.**
`nuda` e `gestita` (BE 1R + trailing R) danno numeri **identici al centesimo**
ovunque tranne **USDJPY** (nuda +64,04 / gestita −10,34). Coerente con n cosi'
piccoli — se i trade non arrivano a 1R, il breakeven non si arma mai — ma
significa che **anche l'asse "gestione" ha misurato poco o niente**.

---

## 📊 I NUMERI, PER COMPLETEZZA (dichiarati NON leggibili come merito)

Si scrivono perche' il referto sia completo, **non** perche' valgano: con n=1..11
per simbolo, §3.1 dice che il simbolo *"non e' leggibile nemmeno come direzione"*.

Cella base `nuda`, `Use_Purple_PineReaction=0`, 22 cross:
- **17 simboli in utile, 5 in perdita** (CADJPY, EURGBP, GBPJPY, GBPNZD, NZDCHF)
- somma profitti: **+909,03** su 22 conti separati (**non** e' un portafoglio)
- **DD massimo osservato: 3,17%** (GBPNZD) a rischio 0,80%
- PF: valori assurdi in entrambe le direzioni (60,28 su AUDCAD con n=3;
  170,70 su AUDUSD con n=1) — **e' esattamente cosa succede a un PF con n=1**,
  ed e' il motivo per cui la soglia sul campione viene PRIMA di quella sul PF.

---

## 🔬 DIFETTO DI BANCO TROVATO E CORRETTO IN CORSA (non tocca il verdetto)

I 44 CSV avevano **header 60 colonne / righe 65**. Causa: l'input
`News_Block_Hours = "7,9,11,12,15,22"` e' una **stringa con virgole dentro**,
scritta grezza in un file separato da virgole -> 5 campi in piu' per riga.
Le prime 11 colonne escono da uno `StringFormat` fisso, quindi
**`Profit`, `Trades`, `Profit Factor`, `Equity DD %` e `Use_Purple_PineReaction`
non sono mai state disallineate**: il verdetto qui sopra e' salvo.
Corretto in `OnTesterDeinit` (quoting RFC4180 + header dall'unione dei nomi):
commit `cbde6ba`. Lo stesso blocco e' copiato in **62 file** del repo — due
(`ABTG_DAX_M3`, `ABTG_Londra_ORB`) sono vulnerabili **gia' coi default**:
lavoro a parte, non fatto qui.

---

## ➡️ COSA SIGNIFICA, E COSA **NON** SIGNIFICA

**NON significa** "il motore di Claudio non funziona". Significa che
**questo banco non lo ha misurato**: due segnali su tre erano spenti o quasi
(PINE morto per difetto di codice, BLU al 5%), e con ~1 trade per simbolo
per anno non c'e' campione per dire niente ne' in bene ne' in male.

**Significa** che, prima di rifare qualunque misura sul BULGE, va risolta la
domanda che i criteri avevano gia' aperto al punto **[DA DECIDERE] (a)**:
**come si valuta un segnale che pretende la candela CHIUSA, se `CheckSignal`
gira al primo tick della barra che si sta ancora formando?**

Le vie possibili, con la **raccomandazione motivata** (decide Claudio):

**1. ✅ RACCOMANDATA — spostare la conferma sulla BARRA 1 (l'ultima chiusa).**
Tutto il resto di `CheckSignal` legge gia' la barra 1: `atr1`, le Bollinger
`bbUpper1/bbLower1`, `isBulge1`, `bullReaction1`/`bearReaction1`, `origLong1`.
**La lettura della barra 0 e' l'ECCEZIONE, non la regola** — e' l'unico pezzo
fuori posto. Portando anche BLU e VIOLA sulla barra 1 il motore diventa
coerente con se stesso, deterministico e senza look-ahead. Costo: il segnale
originale slitta alla barra 2 e l'ingresso avviene **una barra dopo** — cambio
di semantica **vero e dichiarato**, non nascosto.

**2. ❌ SCONSIGLIATA — far girare `CheckSignal` all'ultimo tick della barra.**
In MT5 **non esiste** il modo di sapere che un tick e' l'ultimo della barra:
lo si scopre solo quando arriva il primo della successiva. Si puo' solo
approssimare (es. "negli ultimi N secondi"), e un'approssimazione dentro la
condizione d'ingresso e' proprio il genere di cosa che nel backtest funziona e
in forward no.

**3. ❌ SCONSIGLIATA — dichiarare che BLU/PINE valgono solo sui simboli NON del grafico.**
Renderebbe il segnale dipendente da **quale grafico** ha l'EA sotto, cioe' da
un dettaglio di installazione. Il 6 su 115 del basket nasce da un **ritardo di
accorgimento**, non da una regola: e' rumore d'implementazione promosso a
strategia. E soprattutto: il banco a un simbolo per passata — il modo in cui si
misura qualunque cosa in questo progetto — diventerebbe inutilizzabile.

Finche' quella domanda non ha una risposta, **rilanciare R92 misurerebbe di
nuovo la stessa cosa**. E la correzione **non e' cosmetica**: cambia quali
segnali esistono, quindi il round che ne esce e' un **round nuovo**, con
criteri da firmare prima dei numeri (le soglie S1/S2/S3 possono essere
riusate: non sono state toccate dai numeri di R92).

---

## 📦 COSA MANCA ANCORA NELLA RACCOLTA (dichiarato)

- **i per-trade** (`abtg_trades_ABTG_Bulge_*.csv`, cartella `Common\Files`):
  servivano al **win rate** di S3 e al conteggio BLU/VIOLA per riga. Non
  cambiano il verdetto (S1 e' gia' fallita), ma la loro assenza va scritta.
- **il `REFERTO_R92_SCAN.txt`** generato dalla riga di lancio: la raccolta
  arrivata e' la cartella di lavoro `r92\`, non lo zip del Desktop.
- **il `[BULGE-CONTA]` per simbolo**: in ottimizzazione MT5 non esegue le
  `Print` degli agent (canarino 2.2 dei criteri). L'unico conteggio disponibile
  e' quello del collaudo PASSO 2B sul basket (`aperture=115 -> BLU=6`).
