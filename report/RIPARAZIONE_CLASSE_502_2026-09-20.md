# 🔧 LA RIPARAZIONE DELLA CLASSE 502 — pacchetto pronto da firmare

**20/09/2026** · branch `lavoro` · **PREPARAZIONE, NON APPLICAZIONE**
🔴 **Nessun `.mq5` è stato toccato da questo documento.** Qui c'è la toppa scritta, verificata
riga per riga sui sorgenti, e la firma che serve per applicarla. Modificare un EA schierato è
una **firma di Claudio**, non un lavoro dell'agente.
🔴 **Niente MetaEditor in questo ambiente: nessuna riga qui sotto è mai stata compilata né
passata al tester.** Tutto quello che segue è **lettura statica e argomentazione**, e i punti in
cui questo pesa sono dichiarati dove pesano, non in fondo.

---

## 🎯 IN UNA RIGA, E LA RISPOSTA ALLA DOMANDA CHE CONTA

La toppa esiste, è di **sei righe in tutto su tre file**, ed è costruita perché **non possa**
cambiare una cella validata: **nessun termine della condizione attuale viene tolto o
riscritto — si aggiungono solo `&&`**. Una condizione che riceve solo congiunzioni può
**restringersi**, mai allargarsi: quindi nessuna `PositionModify` oggi soppressa viene spedita
dopo la toppa, e le uniche che spariscono sono quelle che il server rifiuta.

🟠 **MA UNA METÀ DELLA TOPPA NON È NEUTRA, E VA DETTO IN TESTA.** Il pezzo che rispetta
`SYMBOL_TRADE_STOPS_LEVEL` **può bloccare modifiche che oggi nel tester RIESCONO** (§3.3,
contro-esempio **CE-3**). Per questo il pacchetto è diviso in due: la **TOPPA A** (guardia sul
prezzo + confronto normalizzato) è neutra per costruzione; la **TOPPA B** (stops level) **no**,
e viaggia dietro un `input` con default `false`.

🔴 **E la raccomandazione finale va contro l'istinto: NON applicarla per lunedì 21/09** (§4).
Non perché la toppa sia cattiva, ma perché il numero misurato dice che il problema che risolve
vale **328 richieste locali in un giorno su 2.000 di soglia** — mentre il rischio che
introdurrebbe (codice mai compilato, su tre EA, su una challenge che si gioca una volta sola)
si paga tutto in una volta.

---

## ① 📐 I FATTI VERIFICATI — ogni numero riaperto sul file

### 1.1 Le tre righe del difetto, e le basi su cui stanno

Verificato con `grep -n` sui sorgenti, non ripreso dal testo della consegna:

| file | riga `if` del ramo **BUY** | riga `if` del ramo **SELL** | righe totali |
|---|---:|---:|---:|
| `mql5/Experts/ABTG_DAX_Apertura_EU.mq5` | **1986** | **1992** | 2425 |
| `mql5/Experts/ABTG_Dow_Apertura_US.mq5` | **1817** | **1823** | 2205 |
| `mql5/Experts/ABTG_Nasdaq_Apertura_US.mq5` | **2230** | **2236** | 2624 |

### 1.2 🟢 HEAD e il pin schierato sono **IDENTICI AL BIT** — la prima buona notizia

Richiesto dalla consegna, e la risposta è netta. Confronto `md5` fra
`9fca63d98046e60b29f9300fc09dad7738cc887d` e l'albero di lavoro:

| file | pin `9fca63d9` | HEAD `21b2ae61` | esito |
|---|---|---|---|
| `ABTG_DAX_Apertura_EU.mq5` | `02b643d4a49b` | `02b643d4a49b` | 🟢 **identici** |
| `ABTG_Dow_Apertura_US.mq5` | `90484302dd5c` | `90484302dd5c` | 🟢 **identici** |
| `ABTG_Nasdaq_Apertura_US.mq5` | `c2f769936514` | `c2f769936514` | 🟢 **identici** |

👉 **Conseguenza pratica**: i numeri di riga della toppa valgono **su tutti e due**, e non
esiste il rischio di classe 449 (toppa costruita su una base diversa da quella che c'è).
Il pin è anche quello che la riga di schieramento installa davvero:
`report/SCHIERAMENTO_FTMO_2026-09-20.md` rr.179/181/184 dichiara `9fca63d9` con righe attese
**2425 / 2205 / 2624** — e i tre numeri coincidono con quelli misurati qui sopra.

### 1.3 🟠 MA ESISTE UNA **TERZA** BASE, ed è viva — va dichiarata prima della toppa

`backtest_pipeline/toppe_da_applicare/2026-09-19/` contiene i **tre stessi file** patchati per
la chiusura-per-ticket, e la loro base **non è il pin**:

| file | base `3af47ed9` (08/08) | staged 19/09 | pin `9fca63d9` = HEAD |
|---|---:|---:|---:|
| `ABTG_DAX_Apertura_EU.mq5` | 2132 | **2190** | 2425 |
| `ABTG_Dow_Apertura_US.mq5` | 2064 | **2122** | 2205 |
| `ABTG_Nasdaq_Apertura_US.mq5` | 2032 | **2090** | 2624 |

🟢 **E la buona notizia è che non cambia la toppa**: il blocco del trailing negli staged è
**testualmente identico** a quello a HEAD, solo a righe diverse (DAX **1788**/1794, Dow
**1771**/1777, Nasdaq **1739**/1745). 🔴 **La cattiva è che le basi in giro sono TRE, e la
firma deve dire su QUALE si applica.** Il `LEGGIMI.md` di quella cartella punta al terminale
**BCM 50503392** (`C:\Program Files\BCM Markets MT5 Terminal`), che **non è** il bersaglio
FTMO. Le due toppe vivono su binari diversi e **non vanno mescolate**.

### 1.4 🔴 IL DIFETTO È PIÙ DIFFUSO DI TRE FILE — 18 copie, censite per nome

`grep -rn "newSL > 0 && newSL > sl && newSL > openP" --include=*.mq5 --include=*.mqh`
(escluse le worktree degli agenti) trova **18 occorrenze in 15 file**. Le tre schierate sono
la punta:

- **schierate FTMO (3)**: `ABTG_DAX_Apertura_EU.mq5` · `ABTG_Dow_Apertura_US.mq5` ·
  `ABTG_Nasdaq_Apertura_US.mq5`
- **libreria condivisa (1)**: `mql5/Include/ABTG/ABTG_ApertureCore.mqh` **r.897** — 🔴 **e
  questa è quella che si propaga**: chiunque scriverà un'Apertura nuova includendo il core
  eredita il difetto. 🟢 **Nota che assolve i tre schierati**: verificato che i tre EA
  **non** includono il core (`#include` solo `Trade/Trade.mqh` e `ABTG_PausaGuardian.mqh`),
  quindi la toppa ai tre **non passa** dalla `.mqh` e viceversa.
- **altri sorgenti in repo (11)**: `ABTG_Apertura_3Ingressi` r.2345 · `ABTG_Apertura_Marco`
  r.1279 · `ABTG_DAX_Apertura_EU_Ottimizzato` r.1106 · `ABTG_Nasdaq_Apertura_US_Ottimizzato`
  r.1107 · `ABTG_DAX_Live5m` r.1043 · `ABTG_DAX_Live5m_v2` r.1090 · `ABTG_Nasdaq_Live5m`
  r.1046 · `standalone/ABTG_DAX_Apertura_EU` r.917 · `standalone/ABTG_Nasdaq_Apertura_US`
  r.920 · `standalone/ABTG_DAX_Live5m` r.920 · `standalone/ABTG_Nasdaq_Live5m` r.923
- **staged 19/09 (3)**: elencati al §1.3

📌 **La firma riguarda i tre schierati.** Gli altri 15 vanno in coda come **igiene**, con
priorità alla `.mqh` perché è l'unica che **genera difetti futuri** invece di subirli.

### 1.5 ✏️ DUE CORREZIONI ALLA **CLASSE 502** — i riferimenti agli EA sani sono sbagliati

La checklist (`backtest_pipeline/CHECKLIST_RIGA_DI_LANCIO.md` r.27108 segg.) cita gli EA che
la guardia ce l'hanno con numeri di riga **che non esistono lì**. Riaperti:

| citato in CLASSE 502 | cosa c'è davvero a quella riga | 🟢 riga VERA della guardia |
|---|---|---|
| `ABTG_EMA200.mq5` **r.302-303** | `}` di `OnTick` e riga vuota | **r.440-441** |
| `ABTG_SuperWave_DOW_H1_Ottimizzato.mq5` **r.341-342** | `}` e intestazione `ConfluenceOK` | **r.470-471** |

🟢 **Invece i riferimenti alle tre Aperture sono giusti**: `r.1984-1988` / `r.1815` / `r.2228`
sono le **aperture di blocco** (`{`), non l'`if` — che sta due righe sotto (1986 / 1817 / 2230).
Notazione diversa, non errore.

Il testo vero delle due guardie sane, copiato dai file:

```
// ABTG_EMA200.mq5 r.440-441
if(isLong && n>slNow && n<bid) gTrade.PositionModify(tk,n,PositionGetDouble(POSITION_TP));
if(!isLong && (n<slNow||slNow==0) && n>ask) gTrade.PositionModify(tk,n,PositionGetDouble(POSITION_TP));

// ABTG_SuperWave_DOW_H1_Ottimizzato.mq5 r.470-471
if(isLong && stLine>slNow && stLine<bid) gTrade.PositionModify(tk,stLine,PositionGetDouble(POSITION_TP));
if(!isLong && (stLine<slNow||slNow==0) && stLine>ask) gTrade.PositionModify(tk,stLine,PositionGetDouble(POSITION_TP));
```

🔎 **Da notare, perché è il modello giusto**: `EMA200` fa `double n=NormalizePrice(e14);`
**prima** e poi confronta `n` — cioè **confronta il valore che spedisce**. È esattamente la
seconda metà della toppa, e in casa esiste già.

### 1.6 🔴 IL PUNTO PIÙ IMPORTANTE DI TUTTO IL DOCUMENTO: **il «tappo» della CLASSE 507 NON TIENE**

La consegna dice che «l'unica cosa che oggi tiene chiuso quel rubinetto è `InpTrailMode=1`».
**È falso, e la misura di casa lo dimostra già.** Due correzioni, una buona e una cattiva.

#### 🟢 La buona: il tappo è **più forte** di un preset

`InpTrailMode` non parte da un `.set`: parte da una **costante compilata**, e vale **1** in
tutti e tre i file (verificato):

| file | riga | valore |
|---|---:|---|
| `ABTG_DAX_Apertura_EU.mq5` | **100** | `#define ABTG_DEF_TRAIL_MODE   1` |
| `ABTG_Dow_Apertura_US.mq5` | **68** | `#define ABTG_DEF_TRAIL_MODE   1` |
| `ABTG_Nasdaq_Apertura_US.mq5` | **48** | `#define ABTG_DEF_TRAIL_MODE   1` |

👉 Quindi un preset **mancante o dimenticato** non apre il rubinetto: servirebbe qualcuno che
scrive **attivamente** `InpTrailMode=0`. E i tre preset FTMO lo confermano a valle:
`ABTG_DAX_Apertura_EU_770101_FTMO.set` · `ABTG_Dow_Apertura_US_770202_FTMO.set` ·
`ABTG_Nasdaq_Apertura_US_RETEST_770260_FTMO.set` portano tutti e tre `InpTrailMode=1` e
`InpTrailTF=5`.

#### 🔴 La cattiva, e vale più della buona: **con `InpTrailMode=1` il ciclo SI APRE LO STESSO**

`ABTG_TRAIL_PREVBAR` restituisce `iLow(_Symbol, InpTrailTF, 1)`: un prezzo **già quotato**,
sì — ma quotato **nel passato**. Niente impedisce al prezzo vivo di scendere **sotto** il
minimo della candela precedente. Il percorso, tutto dentro il codice letto:

1. long aperto a `openP`, stop iniziale `sl` sotto (stop di range);
2. i tre preset FTMO hanno **`InpTrailStartR=0.0`** (verificato), e a r.1980 `trailArmato =
   (InpTrailStartR <= 0) || ...` → 🔴 **il trailing è armato dal primo tick**, non dopo un R;
3. la candela M5 precedente chiude con minimo `prevLow` **sopra** `openP` (prezzo salito);
4. la candela in corso ritraccia e il `bid` scende **sotto** `prevLow` — il primo pullback
   dopo una rottura, cioè l'evento più comune che esista su un indice in apertura;
5. allora `newSL = prevLow`: `newSL > sl` ✅ · `newSL > openP` ✅ · **ma `newSL > bid`** → il
   server rifiuta (stop dalla parte sbagliata del mercato per un long);
6. `sl` **non cambia**, la condizione **resta vera**, si riparte **al tick dopo** — e
   `prevLow` non si aggiorna fino alla **chiusura della barra**.

📐 **Il tappo vero di `PREVBAR` non è "niente ciclo": è "ciclo LIMITATO A UNA BARRA".** Su M5
in sessione indici sono centinaia di tick. Su `ATR`/`FIXED` lo stesso episodio **non ha
confine di barra**: è quella la differenza, non la presenza o assenza del ciclo.

🟢 **E non è una deduzione: è già misurato.** `report/LE_2000_RICHIESTE_LA_MISURA_2026-09-20.md`
r.193 classifica **CODA B** (`PositionModify` rifiutata che si ripete a ogni tick, **le tre
Aperture**) come 🟠 **«VIVO ma piccolo»**, con **328 FALLITI** in un giorno come massimo su
**186 giornate** — e quelle giornate giravano **con `InpTrailMode=1`**. La tabella r.203-206:

| giornata | ESITI | di cui RETE | **FALLITI** |
|---|---:|---:|---:|
| 11/09/2026 | 350 | 22 | **328** |
| 25/08/2026 | 370 | 51 | **319** |
| 17/09/2026 | 217 | 16 | **201** |
| 17/08/2026 | 70 | 36 | 34 |

👉 **Se il tappo tenesse, quella colonna sarebbe a zero.** Non lo è. **La CLASSE 507 va
emendata**: il tappo non è «un valore di preset», è **un limite di barra**, e non chiude
niente — dirada.

---

## ② 🩹 LA TOPPA — testo esatto, prima → dopo

### 2.1 Il principio costruttivo, che è il motivo per cui è firmabile

🔑 **Nessun termine esistente viene tolto, riscritto o sostituito. Si aggiungono solo `&&`.**
Una congiunzione può solo rendere `false` ciò che era `true`, mai il contrario. Da qui,
**per costruzione e senza bisogno del tester**:
- nessuna `PositionModify` che **oggi non parte** partirà dopo la toppa;
- le sole che spariscono sono quelle in cui `nSL` sta **dalla parte sbagliata del prezzo**;
- **il valore spedito non cambia mai**: era `NormalizePrice(newSL)`, resta `nSL`, che è lo
  stesso numero calcolato una volta sola.

Questo è il contrario di quello che verrebbe istintivo (riscrivere la condizione in forma
pulita, confrontando solo `nSL`): la forma pulita è **più corretta** ma **non dimostrabilmente
neutra** (contro-esempio **CE-2** al §3.2). Qui si è scelta la neutralità.

### 2.2 TOPPA A — la parte **neutra per costruzione** 🟢 (consigliata come contenuto)

#### `mql5/Experts/ABTG_DAX_Apertura_EU.mq5` — righe **1983-1994**

**PRIMA** (testo attuale, copiato dal file):
```
      if(type == POSITION_TYPE_BUY)
        {
         double newSL = TrailStopBuy(bid);
         if(newSL > 0 && newSL > sl && newSL > openP)
            gTrade.PositionModify(ticket, NormalizePrice(newSL), tp);
        }
      else if(type == POSITION_TYPE_SELL)
        {
         double newSL = TrailStopSell(ask);
         if(newSL > 0 && (newSL < sl || sl == 0) && newSL < openP)
            gTrade.PositionModify(ticket, NormalizePrice(newSL), tp);
        }
```

**DOPO**:
```
      if(type == POSITION_TYPE_BUY)
        {
         double newSL = TrailStopBuy(bid);
         //--- CLASSE 502: si normalizza UNA volta e si confronta il valore che si SPEDISCE.
         //    Prima il confronto usava newSL grezzo mentre alla PositionModify andava
         //    NormalizePrice(newSL): due numeri diversi, e la guardia valeva per l'altro.
         double nSL = NormalizePrice(newSL);
         //--- CLASSE 502: la guardia sul MERCATO. Senza, uno stop finito sopra il bid viene
         //    rifiutato dal server, sl non cambia, la condizione resta vera e la richiesta
         //    riparte a OGNI TICK fino alla chiusura della barra. Stessa forma di
         //    ABTG_EMA200.mq5 r.440 e ABTG_SuperWave_DOW_H1_Ottimizzato.mq5 r.470.
         //    I termini vecchi restano tutti: si aggiungono solo &&, quindi la condizione
         //    puo' solo STRINGERSI e nessuna modifica oggi accettata viene persa.
         if(newSL > 0 && newSL > sl && newSL > openP
            && nSL > sl && nSL > openP
            && nSL < bid)
            gTrade.PositionModify(ticket, nSL, tp);
        }
      else if(type == POSITION_TYPE_SELL)
        {
         double newSL = TrailStopSell(ask);
         double nSL   = NormalizePrice(newSL);
         if(newSL > 0 && (newSL < sl || sl == 0) && newSL < openP
            && (nSL < sl || sl == 0) && nSL < openP
            && nSL > ask)
            gTrade.PositionModify(ticket, nSL, tp);
        }
```

#### `mql5/Experts/ABTG_Dow_Apertura_US.mq5` — righe **1814-1825**
#### `mql5/Experts/ABTG_Nasdaq_Apertura_US.mq5` — righe **2227-2238**

🟢 **Testo identico, carattere per carattere.** Verificato che i tre blocchi a HEAD sono la
stessa stringa (stessa indentazione a 6/8/9 spazi, stessi nomi `newSL`/`sl`/`openP`/`tp`/
`ticket`/`bid`/`ask`). Cambiano **solo** i numeri di riga. Se applicata agli staged del 19/09
(§1.3) le righe diventano **1785-1796** / **1768-1779** / **1736-1747**.

**Verifiche di contesto fatte, non assunte:**
- `bid` e `ask` sono **in scope**: `ManageOneTicket(ulong ticket, double bid, double ask)` li
  riceve come parametri (DAX r.1884), valorizzati in `ManagePosition()` rr.1865-1866 con
  `SymbolInfoDouble(_Symbol, SYMBOL_BID/ASK)`. **Nessuna nuova lettura di simbolo**, nessuna
  variabile nuova oltre a `nSL`.
- `nSL` è dichiarato **dentro le graffe** del ramo, come `newSL`: nessuna collisione fra i due
  rami, nessun `nSL` già presente nel file.
- `NormalizePrice()` esiste in tutti e tre (DAX r.2062, Dow r.1893, Nasdaq r.2306) ed è
  identica: arrotonda al **tick size**, non solo ai decimali.

### 2.3 TOPPA B — `SYMBOL_TRADE_STOPS_LEVEL` 🟠 (**NON** neutra, dietro `input`, da differire)

La consegna chiede esplicitamente di rispettare lo stops level. **Si può, ma non è gratis**
(il perché è al §3.3). Quindi viaggia separata e **spenta di default**, secondo la regola di
casa «ogni nuovo comportamento dietro un `input` con default che non cambia niente».

**Aggiunta vicino agli altri input del trailing** (DAX dopo r.325, Dow dopo r.293, Nasdaq
dopo r.272):
```
input bool   InpTrailStopsLevel = false;  // CLASSE 502: il trailing rispetta SYMBOL_TRADE_STOPS_LEVEL (default false = comportamento invariato)
```

**Helper nuovo, accanto a `EffectiveBuffer()`** (DAX dopo r.2080, Dow dopo r.1911, Nasdaq dopo
r.2326):
```
//+------------------------------------------------------------------+
//| Distanza minima dello stop dal prezzo, in PREZZO.                |
//| Separata da EffectiveBuffer() di proposito: quella somma il      |
//| buffer di INGRESSO (InpBufferPoints, 500-700 punti) ed e' giusta |
//| per decidere dove ROMPE il range, non per decidere quanto puo'   |
//| stare vicino uno STOP gia' aperto.                               |
//+------------------------------------------------------------------+
double StopsDistance()
  {
   if(!InpTrailStopsLevel) return(0.0);
   return((double)SymbolInfoInteger(_Symbol, SYMBOL_TRADE_STOPS_LEVEL) * _Point);
  }
```

**Modifica alle due righe della TOPPA A** — `&& nSL < bid` diventa
`&& nSL < bid - StopsDistance()`, e `&& nSL > ask` diventa `&& nSL > ask + StopsDistance()`.
Con `InpTrailStopsLevel=false` la sottrazione è di `0.0`: **la TOPPA B spenta è la TOPPA A**,
bit per bit nel comportamento.

#### 🔎 La domanda della consegna: `EffectiveBuffer()` è riusabile qui? **NO.** Ed è misurato.

```
// ABTG_DAX_Apertura_EU.mq5 r.2075-2080 (identica in ABTG_Dow r.1906-1911)
double EffectiveBuffer()
  {
   double stopsLvl = (double)SymbolInfoInteger(_Symbol, SYMBOL_TRADE_STOPS_LEVEL);
   double bufPts   = MathMax(InpBufferPoints, stopsLvl);
   return(bufPts * _Point);
  }
```

**Tre motivi per cui non va usata nel trailing, tutti letti sul file:**
1. 🔴 **Il `MathMax` con `InpBufferPoints`.** `InpBufferPoints` è il buffer di **rottura**
   (DAX r.265: *«Quanto in là deve andare il prezzo perché la rottura CONTI (500 = 5 punti
   indice)»*; Dow r.234 e Nasdaq r.213: *«live: 700 = 7 punti indice»*). Usarla come distanza
   minima dello stop imporrebbe al trailing di **stare 5-7 punti indice lontano dal prezzo**:
   non è una guardia, è **un trailing diverso** — e cambierebbe ogni cella validata.
2. 🔴 **Su Nasdaq non è nemmeno la stessa funzione.** r.2319-2329 la versione Nasdaq scala il
   buffer col regime di volatilità (`if(InpUseVolRegime && gVolOffMult > 0 && gVolOffMult !=
   1.0) bufPts *= gVolOffMult;`). La distanza dello stop diventerebbe **funzione della
   volatilità**: un secondo comportamento non voluto, e diverso fra i tre EA.
3. ⚪ **È semanticamente un'altra cosa.** Un buffer di ingresso risponde a «quanto deve
   sfondare»; uno stops level risponde a «cosa accetta il broker». Sovrapporle è esattamente
   il tipo di riuso che rende poi illeggibile quale regola ha mosso i numeri.

👉 **Serve l'helper nuovo.** È di quattro righe e non tocca nessun percorso esistente.

### 2.4 🟠 LA SOGLIA DI MOVIMENTO MINIMO ALLA BULGE — **NON la consiglio adesso**, e dico perché

Il modello richiesto esiste e l'ho riaperto:
```
// ABTG_Bulge.mq5 r.1731 e BULGE_MASTER.mq5 r.1056, identiche
bool slChanged = (MathAbs(newSL - sl) > 5 * point);
```

**🔴 Perché NON va aggiunta ora — tre ragioni, in ordine di peso:**

1. **Non è neutra, ed è l'unica delle tre proposte che cambia gli ESITI.** La guardia sul
   prezzo toglie richieste **che il server rifiuta comunque**; la soglia di movimento minimo
   toglie richieste **che il server ACCETTA** — modifiche piccole ma valide dello stop. Uno
   stop che oggi sale di 3 punti e domani non sale più **è un trade che finisce a un prezzo
   diverso**. Applicarla significa **rivalidare tutte e tre le celle**, non «confermarle».
2. **Con `PREVBAR` non compra niente.** `iLow(..., 1)` cambia **solo alla chiusura della
   barra**: il tetto è già ≤1 modifica accettata per barra M5 (~100/giorno per sedia, ed è il
   numero che `LE_2000_RICHIESTE_LA_MISURA` usa al §⑤ per costruire il totale ~530). Una
   soglia sopra un tetto che c'è già è peso morto.
3. **Il `5 * point` è un numero di un altro simbolo.** La Bulge gira sui cross forex; su
   `NASUSD` `_Point` è un'altra cosa. Copiare la costante senza rimisurarla sarebbe esattamente
   il difetto che si sta correggendo (un numero ripreso invece che verificato).

**🟢 Quando invece diventa OBBLIGATORIA — ed è un difetto nuovo che la misura di oggi non
copre.** Se qualcuno mette `InpTrailMode=0` (ATR) o `=2` (FIXED), letto sul file:
```
// ABTG_DAX_Apertura_EU.mq5 rr.2001-2009 (TrailStopBuy)
if(InpTrailMode == ABTG_TRAIL_FIXED) return(bid - InpTrailFixedPts * _Point);
double atr = AtrValue();
return(atr > 0 ? bid - atr*InpTrailAtrMult : 0);
```
`newSL` diventa **funzione del `bid`**: a ogni tick al rialzo `newSL > sl` è **vera** e la
modifica **parte e RIESCE**. 🔴 **Questa non è CODA B: è un fiume di richieste ACCETTATE, con
tempo di rete, che per FTMO contano tutte** — e **la guardia sul prezzo NON la ferma**
(`bid - atr*mult < bid` è sempre vero). L'unico rimedio è la soglia di movimento minimo.

📌 **Conferma di casa che il meccanismo è reale**: `ABTG_MaxMinNotte_DAX_Short_Ottimizzato.mq5`
rr.363-364 fa esattamente `NormalizePrice(bid-a*InpTrailAtrMult)` — ed è la **CODA A** del
referto, misurata ≤117 richieste su conto intero. 🟢 Piccola perché quella sedia sta su **M15
di notte**; su M5 in sessione indici lo stesso disegno è un altro numero.

🔎 **Contro-esempio che ho cercato contro me stesso**: *«la soglia alla Bulge non serve,
perché la Bulge ce l'ha e ha fatto lo stesso 54.508 richieste il 10/04»*. 🟢 **Non regge, e
la data lo dimostra**: `ABTG_Bulge.mq5` compare in repo per la **prima volta il 21/08/2026**
(`git log --diff-filter=A`, commit `f9eaae42`) **con la soglia già dentro** — quindi il flusso
del **10/04** è di una versione **precedente alla soglia**. La soglia non è smentita da quel
caso. 🟠 **Ma nemmeno confermata**: non esiste una giornata misurata che provi che la soglia
avrebbe fermato quel flusso. **[NON MISURATO]**, dichiarato.

---

## ③ 🧪 LA PROVA CHE LA TOPPA NON CAMBIA NESSUNA CELLA VALIDATA

È il punto che la consegna chiama «il più importante». Qui non lo do per scontato: costruisco
**quattro contro-esempi** che la farebbero sbagliare, e li verifico uno per uno. **Uno passa**,
e sta nel documento **in testa** (§🎯), non in fondo.

### 3.1 🟢 CE-1 — «esiste un caso in cui la guardia nuova blocca una `PositionModify` che oggi RIESCE?»

La guardia aggiunta è `nSL < bid` (long). Blocca quando `nSL >= bid`. Perché la toppa non sia
neutra, deve esistere un `nSL >= bid` che **oggi viene accettato** in una cella validata.

- **Nel tester** (dove le celle sono state validate): uno stop-loss **al di sopra del `bid`
  per un long** è uno stop già superato. MT5 lo respinge con `TRADE_RETCODE_INVALID_STOPS`
  (10016), tester e live con lo stesso controllo. **Se venisse accettato**, non resterebbe
  appeso: scatterebbe **immediatamente**, chiudendo la posizione. Non è un dettaglio: sarebbe
  un **esito di trade diverso**, e la toppa non sarebbe neutra.
- 🔴 **E qui va detta la cosa vera: questo NON l'ho potuto verificare in questo ambiente.**
  Non c'è MetaEditor, non c'è tester. La neutralità di CE-1 poggia su *«MT5 rifiuta uno stop
  oltre il mercato, anche nel tester»* — comportamento documentato e coerente con tutto il
  codice di casa (i due EA sani mettono la guardia **proprio perché** la richiesta veniva
  rifiutata), **ma argomentato, non collaudato**.
- 🟢 **Esiste però una prova empirica indiretta, e pesa**: se il tester accettasse quegli stop,
  le tre Aperture avrebbero chiuso a mercato ogni primo pullback dopo la rottura — e le celle
  validate non esisterebbero. **Il fatto che le celle siano quelle che sono è coerente solo
  col rifiuto.** Indizio forte, non prova.
- ✅ **Come si chiude davvero**: §5, punto 4 — **tre backtest before/after** sullo stesso
  preset e sullo stesso periodo, e si confrontano **netto, n trade, DD**. Devono coincidere
  **cifra per cifra**. È l'unica prova che non sia un'argomentazione, e costa un'ora di
  macchina.

### 3.2 🟢 CE-2 — «la normalizzazione arrotonda in SU e fa partire una modifica che oggi non parte»

Il contro-esempio serio, e per poco non mordeva. `NormalizePrice` fa
`NormalizeDouble(MathRound(price/ts)*ts, dg)`: **`MathRound` può arrotondare verso l'alto**.
Se `newSL <= sl` ma `nSL > sl`, una condizione oggi **falsa** diventerebbe **vera** → una
modifica **in più** → stop a un livello diverso → **cella cambiata**.

🟢 **Neutralizzato per costruzione, non per fortuna**: nella TOPPA A i termini vecchi
`newSL > sl` e `newSL > openP` **restano**, e i nuovi si aggiungono in `&&`. Perché la
modifica parta servono **entrambi**. Una congiunzione non può far diventare vero ciò che era
falso. 👉 **CE-2 è chiuso dalla forma della toppa** — ed è esattamente il motivo per cui NON
ho scritto la versione «pulita» che confronta solo `nSL`.

⚪ **In più, e a conferma**: col trailing `PREVBAR` in campo il caso non si presenta comunque,
perché `iLow()` restituisce un **prezzo realmente quotato**, già sulla griglia del tick →
`NormalizePrice` è l'identità. L'arrotondamento è un problema solo in `ATR`/`FIXED`. 🔴 **Ma
questa seconda ragione non me la tengo come garanzia**: dipende da un valore di configurazione,
e la CLASSE 507 insegna che cosa vale una garanzia che un `.set` può togliere.

### 3.3 🔴 CE-3 — LO STOPS LEVEL: **qui la toppa NON è neutra, e passa il contro-esempio**

La TOPPA B aggiunge `nSL < bid - stopsLevel*_Point`. Perché sia neutra, il tester deve
rifiutare **esattamente** ciò che la guardia blocca. **Non è garantito**, e i casi sono due:

1. **Il tester non applica lo stops level storico.** Lo stops level letto con
   `SymbolInfoInteger` è quello **corrente** del simbolo, non quello del 2024. Se una cella è
   stata validata quando la distanza accettata era più corta, il tester oggi **accetta**
   modifiche che la TOPPA B **bloccherebbe** → stop diversi → **P/L diverso**.
2. **`stopsLevel == 0` con limite dinamico.** Parecchi broker dichiarano `0` e applicano in
   realtà un limite legato allo spread. In quel caso la TOPPA B **non aggiunge niente** (guardia
   a `0.0`), quindi è neutra — ma anche **inutile**, il che è un altro modo di non tenere.

👉 **Verdetto: CE-3 NON è chiuso.** Per questo la TOPPA B è **separata** e **`false` di
default**. 🔴 **Con questo disegno la conclusione è comunque pulita**: *il pacchetto che si
firma è neutro perché la parte non neutra è spenta.* Non *«è tutto neutro»*.

📌 La chiusura di CE-3 è a buon mercato: `ABTG_PrevoloFTMO_Specifiche.mq5` (già nel pacchetto
di schieramento, `MQL5\Scripts`, sola lettura) **stampa già** le specifiche dei simboli. Basta
leggere lo `SYMBOL_TRADE_STOPS_LEVEL` di `D30EUR`/`U30USD`/`NASUSD` su FTMO: se è **0**, la
TOPPA B è decorativa e si archivia; se è **>0**, va accesa **e** rivalidata con un backtest.

### 3.4 🟢 CE-4 — i casi limite che la consegna nomina: `sl==0`, il gap, il breakeven

| caso | oggi | con la TOPPA A | esito |
|---|---|---|---|
| **`sl == 0`, ramo BUY** | `newSL > sl` con `sl=0` è vera appena `newSL>0` → richiesta spedita | si aggiunge `nSL < bid`: se lo stop è oltre il prezzo, **non parte** | 🟢 **neutro**: oggi partiva e **veniva rifiutata lo stesso**. Non si perde nessuno stop piazzato, si perde solo il tentativo fallito |
| **`sl == 0`, ramo SELL** | già gestito con `\|\| sl == 0` (r.1992/1823/2236) | il termine `(nSL < sl \|\| sl == 0)` lo replica sul valore normalizzato | 🟢 **neutro** |
| **gap di apertura oltre lo stop** | il server esegue lo stop **sul gap**: la posizione è già chiusa quando `ManageOneTicket` gira | `PositionSelectByTicket` fallisce → il blocco non viene nemmeno raggiunto | 🟢 **fuori percorso** |
| **breakeven (rr.1931-1939 e 1945-1959)** | `PositionModify(ticket, be, tp)` con `be = NormalizePrice(openP)` | 🔴 **NON TOCCATO dalla toppa** | ⚪ **e va bene così** — vedi sotto |

🔎 **Perché il breakeven non entra nella toppa, verificato e non assunto:**
- **Non può ciclare**: entrambi i rami sono protetti da `TkDone(ticket, gBETk)` / `TkMark(...)`
  — **una sola volta per ticket**, e il marchio si mette **anche se la modifica fallisce**.
  Nessun ritorno al tick successivo. **Non è CLASSE 502.**
- **Non può finire oltre il prezzo**: il BE indipendente scatta solo se
  `bid >= openP + riskDist*InpBEatR` con `InpBEatR > 0` (r.1945-1951), quindi per un long
  `be = openP < bid`. Il BE su TP1 sta dentro il ramo «obiettivo raggiunto», quindi anche lì
  il prezzo è oltre `openP`.
- 🟠 **Il solo residuo dichiarato**: se una modifica di BE fallisce, il marchio è già messo e
  **non si riprova mai più** — la posizione resta senza breakeven. È un difetto di **merito**
  (protezione persa), **non** di richieste al server, ed è **fuori dal perimetro di questa
  firma**. Va in coda, non qui.

### 3.5 🔴 E UNA COSA CHE LA TOPPA **NON** FA, detta prima che qualcuno se l'aspetti

La toppa **non ripara il trailing**. Durante l'episodio del §1.6 lo stop **non avanza** — né
prima né dopo. La toppa toglie i **tentativi**, non cambia gli **esiti**: è esattamente il
motivo per cui è neutra. 👉 Chi volesse anche *riparare* il comportamento (per esempio
limitando `newSL` a un livello valido invece di scartarlo) starebbe proponendo **un'altra
cosa**, che **cambia le celle** e **non va fatta adesso**.

---

## ④ ⚖️ IL COSTO E IL RISCHIO DI APPLICARLA ADESSO — le due strade a confronto

### 4.1 I numeri veri, riaperti sul referto

| numero | valore | fonte verificata |
|---|---:|---|
| soglia FTMO *hyperactivity* | **2.000/giorno** | `LE_2000_RICHIESTE_LA_MISURA_2026-09-20.md` |
| giornate misurate | **186** | ivi r.15 |
| massimo su 186 giornate | **563** (28% della soglia) | ivi r.26 |
| massimo a firma **CODA B** (FALLITI) | **328** | ivi r.193 e r.203 |
| la giornata sfondata | **54.508** il 10/04, **BULGE**, 99,94% `MODIFY` | ivi rr.57, 73, 213 |
| tetto per costruzione delle 9 sedie | **~530** (27%, margine 3,8×) | ivi §⑤ |

🟢 **Il dato che decide**: i **328 FALLITI non hanno tempo di rete** (nessuna riga `done in
<n> ms`) → **respinti localmente dal terminale, al server non arrivano** → **per FTMO non
contano** (ivi, §④). 🟠 Il referto stesso lo dichiara **indizio forte, non prova**, e io non lo
trasformo in certezza. **Anche contandoli tutti**, la giornata peggiore a firma CODA B resta
**370** — **5,4 volte sotto la soglia**.

### 4.2 Strada **A** — applicare prima di lunedì

🟢 **A favore, e sono argomenti veri:**
- **La ricompilazione è già sul percorso critico.** `SCHIERAMENTO_FTMO_2026-09-20.md` §⑦ r.324:
  *«Nessun F7 è stato provato»*. I nove sorgenti vanno compilati sul terminale FTMO
  **comunque**. La toppa **non aggiunge un rischieramento**: aggiunge sei righe a una
  compilazione già in calendario.
- **Il difetto è VIVO, non ipotetico** (§1.6): 328/319/201 FALLITI in giornate vere, con il
  tappo che si credeva efficace.
- **Il tappo non è strutturale** (§1.6): oggi regge su un `#define`. Un domani qualcuno
  ottimizza `InpTrailMode` e il ramo `ATR` apre un flusso di richieste **accettate** che
  nessuna guardia di prezzo ferma.

🔴 **Contro, e pesano di più:**
- **Sei righe mai compilate, su tre EA, a meno di 24 ore.** La compilazione FTMO è già
  **[NON VERIFICATO]**: la toppa **somma** il proprio rischio di F7 a un rischio già aperto,
  su un percorso che non ha margine. Se lunedì mattina un `F7` fallisce, la diagnosi è più
  lenta perché le variabili sono due.
- **La neutralità è argomentata, non collaudata** (CE-1, §3.1). La prova vera è un backtest
  before/after, e **quel backtest non è stato fatto**.
- **Cambia l'impronta dei sorgenti.** Il prevolo confronta i sorgenti con le **righe attese**
  (2425/2205/2624). La toppa le sposta a **2440/2220/2639** (**+15 per file**: 6 righe di codice,
  9 di commento) e il cancello di prevolo va **riallineato prima**, non dopo. Se la TOPPA B venisse
  accesa, cambierebbe anche il **numero di input** — l'impronta che il progetto ha già usato
  per scoprire che il Guardian in campo aveva 15 input invece di 19.
- **Il problema che risolve vale il 16% della soglia nel caso peggiore misurato**, e
  probabilmente **lo 0%** (nessun tempo di rete).

### 4.3 Strada **B** — non applicare, e tenere il tappo verificato dal cancello

🟢 **A favore:**
- **Rischio residuo misurato e piccolo**: 328 su 2.000, e verosimilmente non conteggiati.
- **Zero rischio di F7 aggiunto** su un percorso che già non ha prove di compilazione.
- **Zero rischio di cella cambiata**: i tre `.ex5` restano quelli dei backtest.
- **L'impronta di prevolo resta quella congelata** (2425/2205/2624), che è il modo in cui il
  progetto verifica di aver installato la cosa giusta.

🔴 **Contro, e non vanno addolciti:**
- Si parte con un difetto **conosciuto e censito** a bordo. Se lunedì una delle tre sedie
  producesse un episodio più lungo del previsto, sarebbe stato **prevedibile**.
- Il cancello di prevolo verifica `InpTrailMode=1` — 🔴 **ma §1.6 dimostra che quella verifica
  NON è sufficiente**: il ciclo esiste anche con `1`. **Il cancello va riscritto**: non
  «verifica che il tappo ci sia», ma **«dichiara che il tappo limita a una barra e non
  azzera»**.

### 4.4 🎯 LA RACCOMANDAZIONE

## 🟢 Consiglio la strada **B** per lunedì 21/09, e la strada **A** entro la prima settimana.

**Il motivo in una riga**: la toppa corregge un difetto che vale **328 richieste locali su
2.000**, e per farlo mette codice **mai compilato** dentro tre EA su una challenge che **si
gioca una volta sola**. Il rapporto fra i due numeri non giustifica la fretta.

🔴 **E la condizione che ribalta il consiglio, scritta prima e non dopo**: se il cancello di
prevolo trova **anche un solo** `InpTrailMode` diverso da `1` in uno dei tre preset, oppure se
qualcuno ha intenzione di ottimizzare `InpTrailMode` durante la challenge, **allora la strada
A diventa obbligatoria** — perché in `ATR` il flusso è di richieste **accettate**, con tempo di
rete, **che contano davvero** e che nessun tappo di barra dirada. Verificato stanotte: i tre
preset FTMO portano `InpTrailMode=1`. 🟢 **Oggi la condizione non scatta.**

📌 **E una cosa da fare comunque lunedì, che costa zero e non tocca nessun EA**: mettere le tre
sedie sotto osservazione nella **pagella serale**, contando i `FALLITI` per magic. Se una
giornata vera FTMO supera i 328 misurati su BCM, la strada A si anticipa **su un dato**, non
su una paura.

---

## ⑤ ✍️ COSA SERVE PER FIRMARE — in ordine

Nessuno di questi punti è stato fatto: sono **richieste a Claudio**, non cose già decise.

1. 🔴 **La scelta fra A e B** (§4.4). È l'unica firma che blocca le altre.
   👉 *Proposta: **B per lunedì**, con revisione mercoledì sui numeri veri FTMO.*
2. 🔴 **L'emendamento alla CLASSE 507** (§1.6): la checklist dice che `InpTrailMode=1` chiude
   il rubinetto; la misura dice che lo **dirada a una barra**. Finché la riga sta così, il
   cancello di prevolo certifica una cosa falsa. **Questo va corretto anche scegliendo B** —
   anzi, **soprattutto** scegliendo B, perché in B il cancello è l'unica difesa.
3. ⚪ **La correzione dei due riferimenti sbagliati nella CLASSE 502** (§1.5): `EMA200`
   r.302-303 → **440-441**, `SuperWave` r.341-342 → **470-471**.
4. 🔴 **Se A: i tre backtest before/after PRIMA della compilazione di schieramento.** Stesso
   preset FTMO, stesso periodo delle celle validate, modello «ogni tick». **Netto, n trade e
   DD devono coincidere cifra per cifra.** È la sola prova di CE-1 (§3.1) che non sia
   un'argomentazione. 🔴 Se **un solo numero** si muove, la toppa **non è neutra** e torna qui.
5. 🔴 **Se A: il riallineamento dell'impronta di prevolo** da 2425/2205/2624 a
   **2440/2220/2639**, e la riscrittura della riga di verifica. Va fatto **prima**
   dell'installazione, o il cancello boccia la cosa giusta.
6. ⚪ **La TOPPA B (stops level) resta SPENTA** in ogni caso (§3.3, CE-3 aperto). Per aprirla
   serve prima il numero: lo `SYMBOL_TRADE_STOPS_LEVEL` di `D30EUR`/`U30USD`/`NASUSD` su FTMO,
   che `ABTG_PrevoloFTMO_Specifiche.mq5` stampa già. **Se è 0, la TOPPA B si archivia** come
   inutile su questo broker — con il numero accanto, non per stanchezza.
7. ⚪ **La soglia alla Bulge NON entra** (§2.4). Rientra **solo** insieme a un eventuale
   `InpTrailMode=0`, e con la sua costante **rimisurata** sul simbolo, mai copiata.
8. ⚪ **Le altre 15 copie del difetto** (§1.4) come igiene post-challenge, **a partire da
   `mql5/Include/ABTG/ABTG_ApertureCore.mqh` r.897** — è l'unica che **propaga** il difetto
   agli EA che verranno.
9. ⚪ **Il bersaglio, per esteso** (regola dei terminali multipli): se si sceglie A, la toppa
   va **solo** sui sorgenti destinati al terminale **FTMO**. 🔴 **NON** `50503392`
   (`C:\Program Files\BCM Markets MT5 Terminal`) · **NON** `50504263` (`... -V3`) ·
   **NON** `10105439` (`C:\BCM_Reale`) · **NON** `50504400` (`C:\MT5_Backtest`). E **non** va
   mescolata con gli staged del 19/09 (§1.3), che hanno un'altra base e un altro bersaglio.

---

## ⑥ ⚪ COSA QUESTO DOCUMENTO **NON** COPRE — dichiarato

1. 🔴 **Nessuna compilazione, nessun backtest.** Le sei righe della TOPPA A non hanno mai visto
   un `F7`. La correttezza è **argomentata** (API esistenti, variabili in scope verificate,
   stessa forma già in campo su `EMA200` e `SuperWave`), **non collaudata**.
2. 🔴 **CE-1 resta chiuso per argomento, non per misura** (§3.1). Il punto 4 del §5 esiste
   apposta.
3. 🔴 **CE-3 resta APERTO** (§3.3): la TOPPA B **può** cambiare una cella. Per questo è spenta.
4. 🟠 **«I FALLITI non contano per FTMO» è un indizio forte, non una prova.** Ereditato dal
   referto, che lo dichiara a sua volta. Il consiglio del §4.4 **regge anche senza**: contando
   tutto, il peggio misurato è 370 su 2.000.
5. ⚪ **Il difetto di merito del breakeven** (§3.4: marchio messo anche su modifica fallita,
   nessun secondo tentativo) è **censito qui ma fuori perimetro**. Va aperto a parte, con il
   suo numero.
6. ⚪ **Nessun conto, nessuna taglia, nessun parametro di rischio è stato toccato o proposto.**
   Il conto reale **10105439** non compare in nessuna riga di questo pacchetto se non per
   essere **escluso**.
