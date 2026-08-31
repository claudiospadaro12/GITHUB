# 🎯 CACCIA FREQUENZA — motori intraday ad ALTA FREQUENZA per indici e forex — 31/08/2026

**Mandato (Claudio, 31/08 sera, testuale):** _"EA che generano trade con
frequenza, non trade per perdere"_ · rinforzo: _"FAI PARTIRE LA CACCIA AD
EXPERT CHE FANNO ABBASTANZA TRADE A SETTIMANA, ALMENO 1 AL GIORNO"_ ·
chiarimento: _"CIOE' MINIMO DEVE ESSERE 1 O 2"_.

La flotta e' fatta di cecchini (~5 trade/mese a sedia). Per passare una
challenge serve **PORTATA**.

---

## ⚡ IL RISULTATO IN UNA RIGA

> **Su 6 fonti sottoposte a controllo positivo (4 vive, 2 nulle) e ~140
> candidati censiti, 9 sono arrivati al sorgente e li ho letti riga per riga
> (2 `.mq5` scaricati e disassemblati, 4 Pine scaricati integrali, 1 articolo
> MQL5 con sorgente, 2 paper arXiv letti per intero). NE PROMUOVO UNO.**
>
> 🔴 **E la scoperta che vale piu' del promosso: i DUE motori che l'unico
> paper serio in circolazione dichiara VINCENTI sul Nasdaq — quelli che
> chiunque vorrebbe copiare — NON SONO RIPRODUCIBILI. L'ho verificato: il loro
> cuore (un classificatore di regime GMM) e' dichiarato dall'autore stesso come
> appartenente a "a separate research program" e non e' pubblicato in NESSUNO
> dei suoi tre paper. Ho controllato l'elenco completo su arXiv: sono tre, e in
> nessuno c'e'. Portarli sarebbe portare un buco.**
>
> 🔴 **E la seconda: entrambi comunque FALLIREBBERO il pavimento di frequenza
> di Claudio.** 538 segnali su ~750 giorni = **0,72/giorno**; 289 su 947 =
> **0,31/giorno**. Il pavimento e' **1/giorno**. Il paper che tutti citerebbero
> come "la prova che si puo' fare" **non porta un candidato a questo mandato**.

---

## 0. ⚖️ I CRITERI, CONGELATI PRIMA DI APRIRE UN SORGENTE

Scritti prima. Non si sono mossi dopo.

**F1 — PAVIMENTO DI FREQUENZA (duro, di Claudio).** ≥ **1 trade/giorno**
(≥ 5/settimana) **dichiarato dal meccanismo**, cioe' derivabile dalla
costruzione (piu' occasioni al giorno per come e' fatto), non da "un pattern
raro cercato piu' spesso". **Target preferito: 2+/giorno.** Sotto il pavimento
→ **SCARTO a prescindere dalla qualita'**. In classifica, a parita' di
qualita', **vince la frequenza piu' alta**.

**F2 — TAGLIA DEL TAKE (metro di casa C2).** Mediana del take **LORDO**
strutturale ≥ **3 × spread**. Riferimento indici: **2,0 punti indice**
[SPREAD NON MISURATO — resta il lato alto della forchetta di `METRO_PROP` D4;
il *RealCost Spread P95 Logger* (Code Base **74148**), promosso il 23/08, e'
**ancora mai stato usato**: **quinta** caccia che lo scrive]. 👉 soglia
operativa indici **≥ 6,0 punti indice**. Su forex major (spread ~1 pip) la
soglia e' ~3 pip, ed e' molto piu' facile: **e' un fatto strutturale, non un
merito del candidato**, e va detto.

**F3 — FREQUENZA SENZA TAGLIA = SCARTO, e TAGLIA SENZA FREQUENZA = SCARTO.**
I due numeri sono **entrambi obbligatori**. E' il filtro che stronca il 90%
dei "sistemi di scalping".

**F4 — NIENTE PARAMETRI DIVERSI DI MOTORI MORTI.** Ogni candidato passa
`REGISTRO_TEST.md` e `SETACCIO_MANUALE.md` **prima** di entrare.

**F5 — NIENTE DOPPIONI DEL PATRIMONIO INTERNO.** Il **NY Session Retest** e'
gia' il motore piu' frequente mai misurato in casa (**~1 pos/giorno nudo**,
n=625/21 mesi, **PF 1,002**, take mediano vincente **+87,6 punti indice**,
gate slope validato a tick). Un candidato deve portare un **MECCANISMO
DIVERSO** o **strumenti diversi**.

**F6 — VERDETTI SOLO A TICK REALI** (R57). **F7 — DUE LATI SEMPRE** (regola
del 25/08). **F8 — CAMPIONE ≥150 op IS**, sotto → *"non misurabile"*, non
*"senza edge"*. **F9 — PAVIMENTO SL OBBLIGATORIO** (R109).

**F10 — §4 non si ammorbidisce:** niente martingala, griglia, recovery, hedge
di copertura, lotto fisso, stop virtuale, repaint, `#import`, `WebRequest`,
`iCustom` non allegato.

**F11 — NON SI TOCCA IL FORWARD.** Nessuna sedia viva, nessun magic. Questo
dossier **non ha modificato una riga di codice operativo**.

### 🖊️ F12 — IL CANCELLO H8, firmato da Claudio MENTRE questa caccia era in volo

`report/FIRME_2026-08-31.md`, **FIRMA 2**, testuale:

> **"Ogni motore ad alta frequenza entra in flotta SOLO con E >= 0.075R
> misurata A TICK. Frequenza sotto questo cancello = portata finta (DD e
> costi). Vale per tutti i promossi della caccia-frequenza, da oggi."**

🔴 **E' il criterio piu' severo dei tre, ed e' quello che rende i primi due
insufficienti.** Frequenza alta **e** take grande possono convivere con un
valore atteso negativo: e' esattamente quello che e' successo al NY Session
Retest (**~1 pos/giorno**, take mediano **+87,6 punti indice**, e **PF
1,002** = pareggio perfetto). **Portata senza E positiva e' portata finta.**

**Lo applico subito a P1, con l'aritmetica, prima di qualunque test** — vedi
**§5-bis**, perche' cambia quale parametro va sweepato per primo.

---

## 1. 📕 IL CIMITERO, RILETTO PRIMA DI USCIRE

Letti per intero prima di aprire un browser: `REGISTRO_TEST.md`,
`SETACCIO_MANUALE.md`, `CACCIA_CRT_SECONDA_2026-08-31.md`, `ROBUSTEZZA.md`,
`ROTTA_PROP.md`, `CACCIA_M1_TFBASSO_2026-08-29.md`,
`CACCIA_H1_INTRADAY_INDICI_2026-08-30.md`,
`CACCIA_PAPER_ACCADEMICI_2026-08-30.md`, `prove/LEGGIMI.md`.

| famiglia caduta | dove | verdetto misurato |
|---|---|---|
| **CRT Turtle Soup** | `REFERTO_CRT_2026-08-30.md` | **0/30 celle** a tick; col gate **PF 0,459** vs 0,462 ungated; 17/19 mesi rossi. **Chiuso oggi** |
| **BreakinBox** (falsa rottura box notturno) | `REFERTO_BREAKIN_2026-08-31.md` | ablazione A/B: TP-al-box PF 1,007 DD 24,1% **contro** RR fisso PF 1,106 DD 19,7% → **tesi falsificata, e il controllo stesso buca il cancello DD**. **Chiuso oggi** |
| **Chaos Lyapunov** | `REFERTO_CHAOS_2026-08-31.md` | gate monotono **al contrario** della tesi; 1 cella su 105 nella fascia buona. **Chiuso oggi** |
| **breakout / ORB** | `REGISTRO_TEST.md` §2-3, R45, R12, R55 | **~210 celle a tick**, R45 **0/48**, R12 **48/48 negative OOS**. Capitolo **chiuso 26.07.26** |
| **fade degli estremi** | R42 | **0/24 IS e 0/24 OOS** |
| **mean reversion a TF basso senza regime** | R60 `ABTG_MeanRevert` | **12 celle su 12 in perdita** |
| **Bollinger/BreakingBand su M15** | R108 / R111 | **6 finestre su 6 rosse**, PF 0,64-0,87. Gradiente **H1 > M30 > M15**, monotono su 3 simboli |
| **momentum intraday a orario fisso** | R98 | **−0,31 punti/trade** su 410, gia' al netto dello spread |
| **capitolo M5 · capitolo M1** | `REGISTRO_TEST.md` §2, caccia 29/08 | chiusi a tick reali. M1: _"trappola di costo strutturale"_ |
| **filtro appiccicato a motore gia' tarato** | `ROBUSTEZZA.md` §5B | **0 successi su 5** |

### 📌 La frase che ha fatto da bussola a tutta la caccia

Dalla caccia M1 del 29/08, e **oggi si conferma per la terza volta**:

> _"La frequenza NON la compreremo scendendo di timeframe. Va presa con PIU'
> SIMBOLI a M15-H1."_

👉 Quindi ho cercato **una sola cosa**: un meccanismo che produca **piu'
occasioni al giorno per COSTRUZIONE**, con un **take strutturale** (che scala
con la volatilita', non fisso in punti) — **non** un motore piu' veloce.

---

## 2. 📡 CONTROLLO POSITIVO — misurato oggi, 31/08, fonte per fonte

| fonte | HTTP | bersaglio noto verificato **oggi** | esito |
|---|---|---|---|
| **MQL5 Code Base** | **200** | id **68951** → `<title>` letto: _"Liquidity Sweep H4 - M15 (Swing Highs and Lows)"_, autore **Osmar Sandoval Espinosa**, data **2026.03.23** — **identici** al censimento del 26/08 e a quello di stamattina | 🟢 **PASSA** |
| **arXiv API** | **200** (su **https**; su http da **301**) | `id_list=2605.04004` → titolo _"Structural Limits of OHLCV-Based Intraday Signals in MNQ Futures"_, autore **Mathias Mesfin** | 🟢 **PASSA in pieno** — ed e' la fonte che ha consegnato il risultato del giorno |
| **TradingView** (+ `pine-facade`) | **200** | tag `/scripts/ict/?script_type=strategies` → **11 strategie**, = il conteggio registrato il 26/08 e il 31/08 mattina | 🟢 **PASSA** |
| **`pine-facade` — sorgente** | **200** | ⚠️ **CORREZIONE TECNICA UTILE:** l'endpoint `/translate/<sid>/last` restituisce **`IL`/`ilTemplate` CIFRATI** (base64 opaco), **non** il Pine. Il sorgente in chiaro sta su **`/pine-facade/get/<sid>/last` → campo `source`**. Verificato su **4 hash**, con `scriptName`, `scriptAccess` e `created` coerenti | 🟢 **PASSA** (con la correzione) |
| **GitHub** (`raw.githubusercontent`) | **200** | `n30dyn4m1c/crt-turtlesoup-ea/README.md` | 🟢 **PASSA** |
| **Forex Factory** | **403** | — | 🔴 **NULLA — ottava di fila** |
| **SSRN** | **403** | — | 🔴 **NULLA — ottava di fila** |

### ⛔ Canali che oggi NON funzionano, e vanno scritti per non riprovarli

| canale | esito misurato |
|---|---|
| **Ricerca per parola chiave del Code Base** (`?keyword=`) | 🔴 **IL PARAMETRO E' IGNORATO.** Provato con `intraday`, `session`, `pullback`: **restituisce le stesse identiche 15 righe** della pagina 1 non filtrata. Il censimento del Code Base si fa **solo sfogliando le pagine**, e va detto |
| **Yahoo Finance** (`query1.finance.yahoo.com`) | 🔴 **403 dal proxy di egress** (`connect_rejected`, policy) |
| **Stooq** (`stooq.com`) | 🔴 **403 dal proxy di egress** |
| **Dukascopy datafeed** (`datafeed.dukascopy.com`) | 🔴 **403 dal proxy di egress** |

👉 **Conseguenza diretta e pesante: NON HO POTUTO MISURARE LA FREQUENZA DI
NESSUN CANDIDATO.** Ci ho provato su tre fonti dati indipendenti e tutte e tre
sono murate da qui. **Quindi la frequenza del promosso e' [INFERITA DAL
MECCANISMO, NON MISURATA]**, ed e' il motivo per cui il PASSO 0 proposto e'
**un contatore, non una griglia** (§6).

---

## 3. 🔬 IL RISULTATO CHE CAMBIA LA MAPPA — i due "vincitori" del paper non esistono

Il repo cita arXiv **2605.04004** (Mesfin, maggio 2026) in **tre** dossier, ma
sempre e solo per le sezioni **negative** (§4.3 liquidity grab, §6.1 soffitto
di frizione). **Oggi ho letto le 15 pagine.** Al **§5** ci sono due segnali che
il paper dichiara **PASSATI**, e sono l'unica cosa positiva del documento:

| | **§5.1 RTH Confluence Signal** | **§5.2 London Session Signal B** |
|---|---|---|
| segnale | regime GMM = *Regime 1 (Active Flow)* **+** probabilita' di transizione di Markov a 200 barre verso *Regime 2* > 0,15 **+** z-score volume a 50 barre > 0,5 | il classificatore GMM su barre **M15 di Londra (03:00-08:30 ET)** rileva la transizione *Regime 0 (Bearish Chop)* → *Regime 2 (Bullish Drift)*, senza contaminazione di *Regime 1* nelle 2 barre precedenti |
| ingresso | **pullback di 25 punti scalato ad ATR** dalla chiusura della barra di segnale | long all'apertura della barra M15 successiva |
| uscita | **barra 13** (= 65 min su M5) | **60 minuti dopo**, o alle 08:30 ET |
| numeri d'autore | 538 segnali IS; netto **+15,77 pt**; T **5,83**; WF OOS T 3,11, netto **+11,82** su 196; 2025 OOS **+13,14**; permutazione p<0,001 | 289 trade; netto **+5,77 pt**; T **5,15**; win 64,7%; PF **2,42**; ritardo di 1 barra → **T = −3,56** |

_(Tutti i numeri qui sopra: **[DICHIARATI DALL'AUTORE, NON VERIFICATI]**. Non
pesano su nessun punteggio — regola di casa.)_

### 🔴 E adesso i due motivi per cui **NON diventano candidati**. Entrambi decisivi.

**MOTIVO 1 — NON SONO RIPRODUCIBILI, e lo dice l'autore.** Riga verbatim,
letta a pagina 8 [VERIFICATO]:

> _"Two signals from a separate research program are included here as positive
> controls. Their job is to confirm that the methodology is not just rejecting
> everything. These signals were developed independently and **are not the
> subject of this paper**."_

Il **classificatore GMM** — che e' **il cuore di tutti e due** (definisce
Regime 0/1/2) — **non e' specificato da nessuna parte**: nessuna feature,
nessun numero di componenti, nessuna procedura di addestramento, nessuna
soglia. Ho verificato che non stia in un altro lavoro dello stesso autore:
**interrogazione arXiv per autore, i paper sono TRE** (2605.04004, 2605.11423,
2605.17724) e **in nessuno c'e' la specifica del GMM**.

> 🎯 **Portare "RTH Confluence" nel nostro imbuto vorrebbe dire inventarsi il
> pezzo che decide, e poi attribuire il risultato al paper.** E' esattamente
> il modo di produrre il ribaltamento numero trentuno.

**MOTIVO 2 — falliscono comunque il pavimento F1, e non di poco.**

| segnale | conteggio | giorni | **trade/giorno** | pavimento 1/gg |
|---|---:|---:|---:|---|
| RTH Confluence (IS 2022-2024) | 538 | ~750 | **0,72** | 🔴 **SOTTO** |
| London Signal B | 289 | 947 | **0,31** | 🔴 **MOLTO SOTTO** |

### ✅ Cosa RESTA di utile, e va tenuto agli atti (spec, non candidati)

1. 🧱 **La durata e' la variabile che fa passare il soffitto.** §6.2 [VERIFICATO,
   pag. 11]: _"The two strategy types that avoid this ceiling share one feature:
   they **hold positions for 12-15 bars rather than 1-6**"_ e _"the ceiling
   applies specifically to **single-bar directional predictions** from publicly
   observable OHLCV features"_. **Entrambi i vincitori tengono 60-65 minuti.**
2. 🧱 **L'ingresso su PULLBACK come strato di esecuzione.** Decisione bloccata
   nel registro dell'autore (Tabella A1, letta): **`D026 — 25-point pullback
   entry as execution layer for Confluence Signal — LOCKED`**. Cioe': **non si
   insegue l'impulso, si aspetta il ritorno.** 👉 E' **esattamente** la
   geometria del promosso di oggi, arrivata da tutt'altra strada.
3. 🧱 **`D041 — Bar 13 time-based exit confirmed as primary exit — LOCKED`**:
   un'**uscita a tempo** puo' essere l'uscita primaria, non un ripiego.

---

## 4. 🆕 DUE PAPER NUOVI DELLO STESSO AUTORE — mai citati in casa, **entrambi negativi**

Trovati oggi nell'elenco q-fin.TR e letti. **Non portano candidati: portano due
lapidi**, e ci risparmiano due cacce future.

### 4.1 arXiv **2605.11423** — *A Validated Volatility-Volume-Gap Classifier for Regime Identification in MNQ Intraday Data* (12/05/2026)

Classificatore di GIORNATA su tre condizioni **simultanee e pre-sessione**:
rendimento dei primi 30 minuti anomalo **+** gap overnight anomalo **+** volume
della prima barra molto sopra la sua base. Soglie su finestra espansiva
(niente lookahead), 947 giorni 2021-2025.

| misura | valore [VERIFICATO nell'abstract] |
|---|---|
| giorni positivi | **4,4%** del campione = **40 giorni in 4 anni** |
| spread di rendimento giorno dopo | **+25,6 punti base** contro gli altri giorni |
| **giorni che si RIBALTANO dal massimo intraday prima della chiusura** | **77,6%**, con restituzione media **11,73 punti** dal picco alla chiusura |
| forma tipica | deriva la mattina, **picco fra le 14:00 e le 15:30**, poi ribaltamento sistematico di fine seduta |
| **strategie direzionali provate** | **8 configurazioni, ZERO passate.** Migliore: T = 1,46 su 127 trade, netto +7,80 pt, ma il **2024 in perdita** rompe la stabilita' annuale |

> 🔴 **Doppia squalifica per noi: (a) 40 giorni in 4 anni = ~10/anno = due
> ordini di grandezza sotto il pavimento F1; (b) l'autore stesso ha gia'
> falsificato 8 configurazioni direzionali.**
> 🟡 **Ma il 77,6% di ribaltamento dal picco fra le 14:00 e le 15:30 ET e' la
> conferma esterna** dell'unico lead che la caccia accademica del 30/08 aveva
> lasciato aperto (*last-2h reversal* del Dow). **Conferma la forma, e insieme
> dice che su un day-classifier non ci sono abbastanza giorni per tradarla.**

### 4.2 arXiv **2605.17724** — *Sequential Structure in Intraday Futures Data: LSTM vs Gradient Boosting on MNQ* (18/05/2026)

944 giorni, walk-forward espansivo, 3 periodi OOS, 4 configurazioni.
Bersaglio: la chiusura supera l'apertura delle 10:30 di piu' di 10 punti.

> **Nessuna configurazione supera il tasso base del 51,8%.** Gradient boosting
> **50,00-50,89%**, LSTM **50,59%**; permutazione p = 0,135 e 0,515.
> _"Feature importance instability across walk-forward folds suggests **noise
> fitting** rather than stable structural signal capture."_
> Conclusione dell'autore: **quattro anni di OHLCV a 5 minuti su un solo
> strumento non bastano** per ML sequenziale intraday.

> 🎯 **Vale per noi come limite inferiore sui DATI, non solo sul metodo:** la
> nostra finestra tick sugli indici e' **21 mesi**, cioe' **meno della meta'**
> di quella che qui e' dichiarata insufficiente. **Nessun round ML sugli
> indici finche' i dati non crescono** — e' una caccia che ora possiamo non
> fare.

---

## 5. 🟢 IL PROMOSSO — uno solo, ed e' il piu' frequente che ho trovato

### 🥇 P1 — `M0PB` (Momentum Pull Back) — **impulso estremo + rientro sulla EMA veloce**

```
FREQUENZA ATTESA   [INFERITA DAL MECCANISMO, NON MISURATA]
                   piu' segnali al giorno per LATO su M5 di sessione indici.
                   E' il campo che il PASSO 0 deve MISURARE PER PRIMO:
                   sotto 1/giorno -> il candidato MUORE li', senza griglia.
NOME               M0PB
FONTE / URL        https://www.tradingview.com/script/GnsUpEsB-M0PB-Momentum-Pullback/
                   sorgente scaricato integrale da pine-facade /get/ (campo "source")
AUTORE / DATA      (c) Marcns_  ---  created 2022-12-13  [VERIFICATO nel JSON]
ACCESSO            scriptAccess "open_no_auth"  [VERIFICATO]
LICENZA            Mozilla Public License 2.0  [VERIFICATO, riga 1 del sorgente]
RIGHE / INPUT      147 righe Pine v5  ---  UN SOLO input libero (atr_inp)
COPIA IN CASA      caccia_strategie/biblioteca/sorgenti/
                   M0PB_MomentumPullback_Marcns_MPL2_tvGnsUpEsB_2026-08-31.pine
```

**TESI IN UNA RIGA**
> _"Quando un RSI velocissimo tocca un estremo, il mercato ha appena mostrato
> uno squilibrio vero di flusso in una direzione. Chi insegue quell'impulso
> paga il prezzo peggiore; chi aspetta il **rientro sulla EMA a 5 dei minimi**
> compra lo stesso squilibrio **al prezzo migliore**, e ha davanti tutto lo
> spazio fino al massimo delle ultime 12 barre."_

**MECCANICA — letta riga per riga, non dalla descrizione**

1. **L'armamento:** `r = ta.rsi(close, 6)`; `b := 1.0` se `r >= 90`,
   `s := -1.0` se `r <= 10`. 🔴 **Nota bene: si opera NEL VERSO dell'estremo**
   (RSI ≥ 90 → **LONG**). **Non e' un fade.**
2. **Il grilletto (il pullback):**
   `es = ta.ema(high,5)` / `el = ta.ema(low,5)` — due bande di ingresso.
   Long: `low[1] > el[1] and low <= el` (la barra prima era sopra la banda, questa
   la tocca). Short: lo specchio esatto su `es`.
3. **La finestra:** `ta.barssince(b == 1.0) < 6` → il pullback vale solo se
   arriva **entro 6 barre** dall'estremo. Oltre, il segnale scade.
4. **L'uscita a target:** `ph = ta.highest(12)` (long) / `pl = ta.lowest(12)`
   (short), passato come **`limit=` di `strategy.exit`**. 👉 e' un **massimo
   mobile a 12 barre**: se il prezzo scappa subito, esce sullo swing; se entra
   in consolidamento, **il target si abbassa da solo a ogni barra nuova**.
5. **Lo stop:** `atr = ta.atr(10)`; `stop_l = prezzo_medio − atr*2,75`
   (`atr_inp`, l'unico input, 0,1-6,0). **In ATR, mai in punti.**

**🔍 PERCHE' NON E' NESSUNO DEI MORTI — confronto asse per asse**

| | R98 momentum | R60 MeanRevert | R42 fade | BreakingBand M15 | **P1** |
|---|---|---|---|---|---|
| segnale | primi 30' → ultime ore, **orario fisso** | estremo a 200 barre, **fade** | fade del box d'apertura | banda di Bollinger | **estremo RSI(6), NEL VERSO** |
| ingresso | al prezzo corrente | al prezzo corrente | al tocco | al tocco | **differito: si aspetta il RIENTRO sulla EMA5** |
| occasioni/giorno | **1** | poche | **1** | poche | **molte, per costruzione** |
| target | orizzonte fisso | **punto medio, RR 1:1** | RR fisso | banda opposta | **massimo mobile a 12 barre (strutturale)** |
| stop | — | simmetrico | fisso | fisso | **2,75 ATR(10)** |

✅ **Non e' in flotta, in nessuna forma.** In casa **non esiste un solo motore
a RSI** (l'`InpUseRsi` di `ABTG_Apertura_Marco` e' un **toggle mai misurato
come motore**), e non esiste nessun motore **impulso-piu-pullback**.

**BANDIERE ROSSE §4 — ✅ NESSUNA NEL MOTORE.** Verificato riga per riga:
niente martingala, niente griglia, niente hedge, niente recovery, **stop vero
sempre presente**, decisioni su barra chiusa (Pine v5 senza
`calc_on_every_tick`), nessuna dipendenza esterna, nessun `request.security`.

**🚩 E ORA I DIFETTI — che sono TUTTI nella GESTIONE, cioe' la parte che sappiamo fare**

| difetto letto nel sorgente | cosa facciamo noi |
|---|---|
| `strategy.entry("EL", strategy.long, **2**)` → **quantita' fissa 2 contratti** | **rischio in % dell'equity**, sempre |
| lo stop e' simulato con `strategy.close_all(when = low[1] > stop_l[1] and low <= stop_l)` → **esce all'apertura della barra DOPO**, non al prezzo dello stop | **SL vero mandato al broker** + **pavimento `InpMinSLPts`** (R109) |
| niente parziale, niente breakeven | **parziale 1R + breakeven + runner**, la gestione delle nostre sedie |
| niente finestra di sessione, niente flat EOD | **finestra in ORA SERVER** + **flat di fine seduta** (muro giornaliero prop) |
| RSI 6, soglie 90/10, EMA 5, finestra 6, uscita 12 sono **cablati** = l'overfitting dell'autore | **si sfrondano e si sweepano pochi assi**, mai la cella migliore |
| nessun `OnTester`, nessun magic | obbligatori, altrimenti il driver non parte |

**💰 F2 — LA TAGLIA DEL TAKE, e perche' batte la frizione**
Il take **non e' in punti**: e' il **massimo delle ultime 12 barre**. Su **M5**
sono **60 minuti di escursione**; l'ingresso e' su un **pullback**, quindi la
distanza entrata→target e' tipicamente **una frazione grossa del range orario**.
Su U30USD un'ora di sessione vale **decine di punti indice** contro la soglia
di **6,0**. 👉 **[STIMA STRUTTURALE — il numero vero e' la mediana del take
LORDO REALIZZATO, e si MISURA al PASSO 0.]**
📌 Confronto interno utile: il NY Session Retest, sullo stesso strumento, ha
take mediano vincente **+87,6 punti indice** — **44× lo spread**. La taglia,
sugli indici, **non e' il problema**. Il problema e' l'edge.

**🔴 L'OBIEZIONE PIU' FORTE, che scrivo io prima che la faccia Claudio**
L'autore scrive, riga 15 del sorgente: _"The best trades tend to work within
**2-6 bars**"_. 👉 E' **esattamente la classe 1-6 barre** che Mesfin §6.2
dichiara **sotto il soffitto di frizione**, e le due strategie che quel
soffitto lo superano tengono **12-15 barre**.

**Percio' l'esperimento e' gia' scritto, e va congelato PRIMA:**
> 🔬 **ABLAZIONE OBBLIGATORIA SULLA DURATA.** `uscita al massimo mobile a 12
> barre` (la tesi) **contro** `uscita a tempo alla barra 13` (la geometria che
> il paper dichiara vincente, §5.1 + D041). **Se vince la barra 13, il motore
> vive ma la sua uscita e' sbagliata. Se perdono entrambe, la classe
> "impulso + pullback a TF basso" ha la sua falsificazione e si chiude.**
> Senza questa ablazione P1 **non e' giudicabile**.

**🧭 Un dettaglio di onesta' dell'autore, raro e da segnalare**
```pine
strategy("M0PB", commission_value = 0.0004, slippage = 1, initial_capital=30000)
// commision is equal to approx $3.8 per round trip which is accurate for ES1!
// futures and slippage per trade is conservatively 1 tick in and 1 tick out.
```
👉 **Ha modellato commissione E slippage nella dichiarazione della strategia**,
e ha scritto perche'. E' il contrario del `Delays: Zero latency` che il
`SETACCIO_MANUALE` ha gia' visto. **Non e' un numero che uso** (resta
`[DICHIARATO DALL'AUTORE, NON VERIFICATO]`), ma dice come lavora chi l'ha
scritto.

**🏛️ IN OTTICA PROP**
- 🟢 **E' l'unico candidato che attacca il problema vero della challenge: la
  PORTATA.** Piu' operazioni = il verdetto arriva prima, e il campione dei 150
  si raggiunge in mesi invece che in anni.
- 🔴 **Ma il rischio giornaliero e' il suo punto debole, ed e' strutturale:** un
  motore che spara **piu' volte al giorno sullo stesso impulso** concentra le
  perdite **nella stessa mattina**. La peggior giornata misurata in casa e'
  **−2,06%** (R51) con motori a ~1 trade/giorno. 👉 **`InpMaxTradesPerDay` e'
  OBBLIGATORIO dal primo round** (non un'aggiunta dopo), e la **peggior
  giornata** va letta prima del PF.
- 🔴 **Geometria a win-rate alto e RR basso:** stop **2,75 ATR** contro un take
  di ~1 ATR. L'autore dichiara 60-70% di win rate. **E' la forma che il DD
  trailing punisce** (`METRO_PROP`, Upcomers): pochi stop grossi dopo tanti
  piccoli take. **Da dichiarare nel referto, non da scoprire dopo.**
- 🟡 **Scorrelazione:** lavora **dentro la sessione USA**, dove stanno gia' Dow
  Apertura, ORB-EMA200 e il NY Retest. **Il meccanismo e' diverso**
  (impulso+pullback contro breakout e contro retest-VWAP), ma la **finestra
  oraria e' la stessa** → **regola di rotta 1: mai a rischio pieno insieme
  finche' la correlazione fra le serie per-trade non e' MISURATA.**

**PUNTEGGIO**
- **[2] semplicita'** — 147 righe, **un solo input libero**. E' il candidato piu'
  semplice arrivato dopo `MeanReversion.mq5` (135 righe, 2 input).
- **[2] il filtro E' il motore** — l'estremo RSI **e'** la direzione e **arma** la
  finestra; il pullback **e'** l'ingresso. Niente e' appiccicato: togli l'RSI e
  non resta una strategia, resta un tocco di media.
- **[2] tesi di mercato scrivibile** — sopra, una riga.
- **[2] riempie un BUCO** — **la FREQUENZA** (il buco del mandato), **i DUE LATI
  perfettamente simmetrici** (14 celle vive quasi tutte long-only), e il primo
  motore **impulso+pullback** della flotta.
- **[1] testabile senza riscritture** — 🔴 **Pine → MQL5 e' una RISCRITTURA**,
  non un porting. Onesto: **~1 giornata**. Attenuante vera: **meta' del lavoro
  esiste gia'** (sessione, flat EOD, parziale, breakeven, SL strutturale,
  spread come % dello stop, `OnTester` sono nei nostri EA aperture), e il
  motore nuovo sono **quattro funzioni**.

## **VERDETTO: 🟢 PROVA — 9/10**
**PERCHE':** e' l'**unico** oggetto trovato oggi che promette **entrambi** i
numeri del mandato per costruzione — molte occasioni al giorno **e** un take
strutturale che scala con la volatilita' — **senza** essere un doppione della
flotta e **senza** essere un caduto. E il suo punto debole (la durata 2-6
barre) non e' un'opinione: e' una **variabile isolabile**, con l'ablazione gia'
scritta sopra.

---

## 5-bis. 🧮 P1 CONTRO IL CANCELLO H8 — l'aritmetica che si fa PRIMA di spendere una macchina

Il cancello firmato oggi (**E ≥ 0,075R a tick**) si puo' interrogare **senza
backtest**, perche' la geometria di P1 e' tutta nel sorgente. E la risposta
sposta l'obiettivo del primo sweep.

**Come e' fatto il rapporto premio/rischio di P1, letto nel codice:**
- **rischio** = `2,75 × ATR(10)` (`atr_inp`, l'unico input libero)
- **premio** = distanza dall'ingresso (il tocco della `ema5`) al **massimo
  mobile a 12 barre**, cioe' **grosso modo l'ampiezza dell'impulso appena
  avvenuto** — [DA MISURARE: e' il numero 2 della sonda]

Chiamiamo **RR** = premio_mediano / rischio_mediano. Con `E = p·RR − (1−p)`,
il win rate **necessario** per superare il cancello e':

| se la sonda misura RR = | serve un win rate di | commento |
|---:|---:|---|
| **0,36** (premio ≈ 1 ATR) | **79,0%** | 🔴 irrealistico |
| **0,50** (premio ≈ 1,4 ATR) | **71,7%** | 🔴 sopra quanto dichiara l'autore |
| **0,73** (premio ≈ 2 ATR) | **62,2%** | 🟡 dentro il "60-70%" **dichiarato** |
| **1,00** (premio = rischio) | **53,8%** | 🟢 comodo |

_(L'autore dichiara **60-70%** di win rate: **[DICHIARATO, NON VERIFICATO]**,
non lo uso come numero — lo uso solo per far vedere **dove cade la soglia**.)_

> 🎯 **Conclusione, e cambia il piano:** con lo **stop da 2,75 ATR dell'autore**,
> il cancello H8 e' **quasi irraggiungibile** a meno che il premio non valga
> almeno **2 ATR**. 👉 **Il parametro che decide non e' l'RSI: e' il
> MOLTIPLICATORE DI STOP.** E' l'unico input libero del sorgente, e non e' un
> caso: **e' li' che l'autore ha girato la manopola.**
>
> ✅ **Quindi il primo sweep, quando si arrivera' li', e' `InpAtrStopMult`, e
> la sonda deve restituire il RR mediano MISURATO** — cioe' esattamente il
> numero che fa entrare o uscire il candidato dal cancello firmato oggi,
> **prima** di guardare un solo PF.
>
> 🔴 **E se il RR mediano misurato e' sotto ~0,7, P1 va chiuso per aritmetica**,
> senza corsa a tick: sarebbe portata finta, che e' la cosa esatta che la
> FIRMA 2 esiste per non comprare.

---

## 6. 📦 IL PASSO 0 — **si conta PRIMA, si giudica DOPO**

🔴 **Non propongo una griglia. Propongo un CONTATORE.** Il motivo e' il §2:
**le tre fonti dati sono murate da qui e la frequenza non l'ho potuta
misurare** — e la frequenza e' il **pavimento**, cioe' la cosa che puo'
uccidere il candidato **prima** che si scriva un EA.

C'e' un precedente di casa esatto, ed e' una firma di Claudio del 21/08
(_"metro, frequenza"_): la **SONDA DI FREQUENZA** della Mediazione
(`ABTG_SondaMediazione.mq5`, `SONDA_MEDIAZIONE_FREQUENZA_2026-08-21.md`) —
**uno SCRIPT che conta i segnali e basta: nessun ordine, nessun lotto, nessun
sizing, nessun EA operativo.** Ha chiuso un nodo con un numero e senza scrivere
codice da buttare. **Qui serve la stessa cosa.**

**La sonda deve restituire quattro numeri, e sono i quattro che decidono:**

| # | numero | cancello congelato PRIMA |
|---|---|---|
| 1 | **segnali/giorno per LATO** (RSI(6)≥90 seguito da tocco di `ema5(low)` entro 6 barre; e lo specchio) | **< 1/giorno → SCARTO IMMEDIATO**, il candidato muore qui e non si scrive nessun EA |
| 2 | **mediana della distanza ingresso → `highest(12)`** in punti indice, al momento del segnale | **< 6,0 punti indice → SCARTO** (F2). Fra 5,0 e 7,0 → **SOSPESO**, e si misura finalmente lo spread col Code Base **74148** |
| 3 | **mediana della distanza ingresso → stop (2,75·ATR(10))** | serve a leggere l'**RR vero** prima di qualunque numero di merito |
| 4 | **massimo di segnali in UNA giornata** | e' il numero del **muro giornaliero prop**: taglia il cap `InpMaxTradesPerDay` sui dati, non a occhio |
| 5 | **RR MEDIANO** = (numero 2) / (numero 3) | 🖊️ **cancello H8, firmato oggi.** **RR < 0,7 → SCARTO PER ARITMETICA**, senza corsa a tick (§5-bis): con quello stop nessun win rate plausibile porta E a 0,075R |

Simboli: **U30USD, NASUSD, D30EUR** (i tre con tick BCM e conversione misurata
= 100 su tutti e tre → **testabili subito**). TF: **M5 e M15**, per leggere il
gradiente prima di sceglierlo.

📄 **File prova (BOZZA, col cartello):**
`backtest_pipeline/prove/M0PB_FREQUENZA_BOZZA.txt`

⚠️ **Non l'ho messo come prova operativa e non e' pigrizia: e' la regola di
casa.** Ne' l'EA ne' la sonda esistono; un file prova che pinna input
inesistenti e' **l'errore n.3 della `CHECKLIST_RIGA_DI_LANCIO`**, e MT5
**ignora in silenzio** un pin che non trova — e' cosi' che e' nato il falso
"0/8" del FiboH4 (`REGISTRO_TEST.md` §2-bis). **Prima la sonda, poi il numero,
poi — solo se il numero regge — l'EA.**

---

## 7. 🗑️ GLI SCARTATI — letti nel SORGENTE, con la riga che lo prova

| # | candidato | fonte | motivo dello scarto |
|---|---|---|---|
| S1 | **`ICE (Impulse Confirmation Engine)`** — file `Impulse Continuation Engine.mq5`, **2.122 righe**, ~25 input, RitzFalih/Syamsurizal Dimjati, 19/02/2026, aggiornato 10/07/2026 | [mql5.com/en/code/69651](https://www.mql5.com/en/code/69651) (ZIP scaricato, 69.891 byte) | 🔴 **REPAINT — decide sulla BARRA IN FORMAZIONE, provato.** `ArraySetAsSeries(rates,true)` alla riga **1476**, e poi gli ingressi girano su **`rates[0]`**: righe **1515** (`rates[0].close > rates[0].open`), **1526** (`rates[0].close > rates[1].high && rates[0].tick_volume > ...`), **1551**, **1561**, **1618**, **1644** — piu' `iHigh/iLow(...,0)` alle righe **614, 684, 1332**. Il segnale cambia dentro la barra. In piu': **nessun `OnTester`** (il driver non parte), e i tre scenari d'ingresso A/B/C sono **in OR** = un OR che collassa. 🟡 Peccato, perche' **il TP e' ATR-scalato** (`atr*InpATRMultiplierTP`) e il rischio e' in %: il difetto e' l'implementazione, non l'idea |
| S2 | **`SteepMA Steep Moving Average Trend EA`** — 150 righe, 10 input, BigBoyka, 27/07/2026 | [mql5.com/en/code/74379](https://www.mql5.com/en/code/74379) (ZIP 2.158 byte) | 🔴🔴 **STOP LOSS AL 30% DELL'EQUITY, scritto in chiaro:** `double riskAmount = equity * 0.3;` → `slPrice = openPrice ± riskAmount/(lots*contract)`. **Il muro prop e' il 10% totale e il 5% giornaliero: un solo stop chiude il conto tre volte.** E non finisce li': `InpRiskPercent = 70.0` **non e' rischio**, e' il 70% del nozionale; **`req.tp = 0`** (nessun target, nessuna uscita se non quello stop); **nessun magic**; `GetPositionDirection()` scorre `PositionsTotal()` **senza filtrare per magic** → su un conto con la flotta accesa legge le posizioni degli altri EA; nessun `OnTester`; e l'"angolo" della media e' calcolato su **differenze di prezzo grezze**, quindi cambia significato fra D30EUR e EURUSD |
| S3 | **`BOCS Channel Scalper Strategy`** — 309 righe Pine v6, ~20 input, created 2025-09-27, `open_no_auth` | [tradingview.com/script/251HmEDh](https://www.tradingview.com/script/251HmEDh-BOCS-Channel-Scalper-Strategy-Automated-Mean-Reversion-System/) (sorgente scaricato) | 🔴 **La geometria E' la trappola di frizione, misurata nel sorgente.** Entra nel **20% basso** di un canale (`longEntryZone = bottomBound + channelRange*0.2`), **SL a 5 tick** oltre il bordo (`sl_offset_ticks = 5`) e **TP a 30 tick FISSI** (`tp_fixed_ticks = 30`). Su NQ (mintick 0,25) sono **7,5 punti** di take contro **2,0** di frizione = **3,75×**, cioe' **appena sopra la soglia F2 nel caso migliore** — e lo stop e' **1,25 punti**, sotto il rumore. In piu': **fade del bordo di un range**, che e' la famiglia **R42 (0/24 IS e 0/24 OOS)** + **R60 (12/12 in perdita)** + `ABTG_BandFade`; sizing `strategy.fixed` 1 contratto o **"% of Equity" al 10% del NOZIONALE** (non rischio). 🟡 Da tenere: **il rilevatore di canale e' serio** (stdev del prezzo normalizzato, box che muore alla rottura) |
| S4 | **`NY VIX Channel Trend Strategy`** — 149 righe Pine v6, © exlux, **MPL 2.0**, created 2025-11-02 | [tradingview.com/script/TlOcVraF](https://www.tradingview.com/script/TlOcVraF-NY-VIX-Channel-Trend-US-Futures-Day-Trade-Strategy/) (sorgente scaricato) | 🔴 **E' R98 con una banda nuova, e fallisce F1 per costruzione.** La direzione viene da `bias_trend_state := window_close_px > ny_open_for_bias ? 1 : -1` — cioe' **i primi 30 minuti decidono il resto della giornata**: e' **Market Intraday Momentum**, **CADUTO in R98** (−0,31 punti/trade su 410) e gia' archiviato come M4 (0/10) dalla caccia accademica del 30/08. E la variabile `entered_this_sess` impone **UN SOLO trade per sessione** → **1/giorno al massimo, cioe' AL pavimento, mai sopra**. In piu' `calc_on_every_tick=true` (§4) e **dipendenza da `VIX` e `VIX9D`** via `request.security`, simboli che **BCM non quota** = dipendenza esterna non risolvibile |
| S5 | **`EURUSD $300 Sniper v8.7`** (titolo interno; indicizzato come `M15 v2`) — 119 righe Pine v5, created 2026-05-03 | [tradingview.com/script/sbopOeJ5](https://www.tradingview.com/script/sbopOeJ5-M15-v2/) (sorgente scaricato) | 🔴 **Doppione di una famiglia MISURATA MORTA in casa.** E' Bollinger(20, 2σ) + EMA200 + RSI(14) su **EURUSD M15**: e' **`ABTG_BreakingBand` su M15**, dove R108/R111 hanno misurato **6 finestre su 6 rosse** (PF 0,64-0,87) e il gradiente **H1 > M30 > M15** monotono su 3 simboli. 🚩 In piu' due odori: `lookbackDays = 90` (l'autore mostra **90 giorni**) e **"v8.7"** (otto giri di taratura). 🟢 Unica cosa utile, e conferma un punto strutturale: TP **35 pip** contro ~1 pip di spread = **35× la frizione** → **su forex il cancello F2 e' facile, e non e' un merito del candidato** |
| S6 | **`Statistical Arbitrage Through Cointegrated Stocks (Part 2)`** — Jocimar Lopes, 08/08/2025, `.mq5` allegato | [mql5.com/en/articles/19052](https://www.mql5.com/en/articles/19052) | 🔴 **Tre motivi, e i primi due sono §4 secchi: NESSUNO STOP LOSS** e **LOTTO FISSO** (10 unita' per gamba, pesate con gli autovettori di Johansen). Terzo: gira su **NVDA/MCHP/MPWR/MU su timeframe DAILY** — strumenti che **BCM non ha** e un TF che **non e' intraday**, quindi fallisce F1 per definizione. 🟡 La classe (spread cointegrato, market-neutral) resta un buco vero della flotta, ma **non entra da questa porta** |
| S7 | **`EMA50BounceEA.mq5`** (art. *From Novice to Expert: Automating Intraday Strategies*) — Clemence Benjamin, **20/02/2026**, sorgente allegato 7,99 KB | [mql5.com/en/articles/21283](https://www.mql5.com/en/articles/21283) | 🟠 **SCARTO come CANDIDATO, PROMOSSO come CONTROLLO e come CHASSIS** (§8.2). Ha delle cose giuste — **`IsNewBar()`, quindi barra chiusa**, opzione `UseRiskPercent`, due lati — ma **`StopLossPoints=300` / `TakeProfitPoints=600` sono PUNTI FISSI**: su D30EUR sono **3 e 6 punti indice**, cioe' uno stop **sotto il rumore** e un take **esattamente sulla soglia F2**. E soprattutto: **il pullback sulla EMA50 e' nudo, senza nessuna condizione di regime** → per il nostro metro non ha un *filtro che e' il motore*, ha **zero filtro**. 👉 **E' esattamente il CONTROLLO di P1** |

### 7.1 Scartati al PRIMO TAGLIO (titolo/pagina, sorgente **non** aperto — dichiarato)

| gruppo | quanti | motivo |
|---|---|---|
| **Code Base, pagine 1-3 experts** — pannelli, calcolatori di lotto, copiatori, logger, `Market Replay Tool`, `Interactive Panel`, `Basket Protective Close`, `Trade Manager` ×9, `Position Size Calculator` ×4 | ~24 | 🔴 **attrezzi, non strategie: zero ingressi = niente da backtestare.** Regola del `SETACCIO_MANUALE`: se c'e' `OnCalculate` o non c'e' `OrderSend`/`trade.Buy` → si salta |
| **Code Base** — `Sniper Gold Hybrid **Recovery**`, `Daily Zone **Recovery**`, `XANDER **Grid**`, `RSI **Grid** Pro`, `BGC **Grid**`, `**Grid** Master`, `Simple_**Grid**`, `Sideways **Martingale**`, `KSU_martin`, `VR Locker Lite` (lock positivo) | 10 | 🔴 **§4 dal titolo**: recovery / griglia / martingala / lock. Primo taglio, dichiarato |
| **Code Base** — gia' setacciati nei dossier del 16, 19, 21, 23, 25, 28, 29, 30/08: `76331`, `76153`, `76333`, `75586`, `75301`, `74148`, `74137`, `73958`, `73884`, `73711`, `73638`, `71467`, `70796`, `70052`, `68951`, `68704`, `68512`, `68082`, `71189`, `74815` | 20 | 🔵 **cio' che e' setacciato non si ricontrolla** |
| **Code Base** — `Prime Quantum AI (Anthropic/OpenAI/Gemini/DeepSeek/Grok)`, `ExMachina Telegram Bridge`, `KSQ CommandCenter Remote Google Sheets`, `MT5 Telegram Trade Notifier`, `T5Copier` | 5 | 🔴 **§4: `WebRequest`/rete per costruzione.** E un EA che chiede il segnale a un servizio esterno non e' backtestabile |
| **TradingView** tag `scalping` / `intraday` / `daytrading` / `pullback` / `futures` / `nasdaq` / `trendfollowing` / `volatility` / `meanreversion` — **9 tag × 24 (tetto di pagina) = ~200 titoli censiti** | ~185 | 🔴 In stragrande maggioranza **fuori bersaglio per STRUMENTO**: cripto (BTC/ETH/SOL/XRP) e azionario indiano (NSE: NIFTY, BANKNIFTY, WIPRO, RELIANCE...). Dei restanti: `Opening Range Breakout` ×3, `Universal Breakout`, `Session ORB`, `ORB Pro Session Breakout Scalper`, `NY First Candle Break and Retest`, `Consolidation Breakout` → **famiglia breakout CHIUSA (~210 celle)**; `VWAP Reversal V1`, `VWAP Band Mean Reversion`, `RVWAP Mean Reversion`, `VWAP Suite`, `Advanced VWAP Pullback` → **doppioni del candidato di casa `ABTG_VwapRevert`** (gia' scritto, PASSO 0 preparato); `Out of the Noise Intraday with VWAP` → **e' gia' `ABTG_OutOfNoise` in casa**; `IBS`, `3 Red/3 Green`, `Turnaround Tuesday`, `Turn of the Month`, `Seasonal Strategies` → **giornalieri/stagionali, F1 fallito per definizione**; `SHORT-ONLY` ×5 (Bar Low Pullback, Sell the Rip, Consecutive Bars, IBS) → tutti su **SPY/QQQ giornaliero** |
| **arXiv q-fin.TR** — scansione di **60 titoli** con `abs:intraday`, ordinati per data | 55 | 🔴 Fuori dominio: **mercati elettrici e batterie** (9 titoli), microstruttura del book / LOB / Hawkes (12), cripto (5), esecuzione ottimale (6), obbligazionario/opzioni (5). **Nessun EA, nessuna regola tradabile su CFD.** I 5 letti/valutati sono nei §3 e §4 |

### 7.2 ⛔ Cosa NON esiste come tag su TradingView (misurato, non supposto)
Aggiornamento al `PROMEMORIA_SBLOCCO_FONTI.md`: il tag **`sessions` rende
2 strategie sole**, contro le 24 (tetto di pagina) di tutti gli altri tag
provati. **Chi cerca "sessione" li' non trova niente, e non perche' la fonte
sia rotta.**

---

## 8. 🧱 LE COSE DA TENERE AGLI ATTI (spec e mattoni, non candidati)

### 8.1 La banda a **volatilita' implicita** — un canale intraday che non ha parametri da tarare
Da `NY VIX Channel Trend Strategy` (S4), righe verbatim:
```pine
sigma_d   = (base_vix_d / 100.0) / math.sqrt(252.0)   // frazione giornaliera
vix_upper = sess_open_px * (1 + sess_width)
vix_lower = sess_open_px * (1 - sess_width)
```
> 🎯 **E' un'ampiezza attesa di giornata che NON viene da un backtest: viene dal
> mercato delle opzioni.** Zero manopole, e si ritara da sola ogni giorno. E'
> il cugino "esterno" del `maDistancePct` registrato il 31/08 mattina.
> 🔴 **Il costo, dichiarato:** richiede un feed **VIX/VIX9D** che **BCM non
> quota**. Resta agli atti come **forma**, non come pezzo montabile oggi.

### 8.2 `EMA50BounceEA.mq5` — **il controllo nudo di P1, gia' in MQL5**
Non e' un candidato (S7). E' la **gamba di ablazione** che serve a P1:
**pullback sulla EMA senza nessun armamento** contro **pullback armato
dall'estremo RSI**. E' **nativo MQL5 con sorgente allegato**, quindi il
controllo costa **zero riscrittura**. 👉 Se il pullback nudo va uguale,
**l'RSI e' decorazione** e il punteggio "il filtro E' il motore" di P1 crolla.

### 8.3 Le tre decisioni bloccate del registro di Mesfin (Tabella A1, lette)
Valgono per **ogni** round intraday futuro, non solo per questo:
`D026` ingresso su **pullback** come strato di esecuzione · `D041` uscita **a
tempo** come uscita primaria · `D179` **soffitto strutturale del guadagno
lordo** confermato a risoluzione 5 minuti.

---

## 9. ⬜ COSA NON HO POTUTO VEDERE — dichiarato, non taciuto

| oggetto | perche', e cosa ci costa |
|---|---|
| 🔴 **LA FREQUENZA, DI QUALUNQUE CANDIDATO** | **Ci ho provato su tre fonti dati e tutte e tre sono murate dal proxy di egress** (Yahoo Finance, Stooq, Dukascopy datafeed: `connect_rejected`). **Il numero che il mandato mette per primo e' proprio quello che da qui non si misura.** E' il motivo per cui il §6 propone un **contatore** e non una griglia. **Il numero lo fa il PC di Claudio.** |
| 🔴 **Forex Factory** (403) | **Ottava di fila.** Su una caccia alla *frequenza* pesa il doppio: i thread lunghi anni sono l'unico posto dove si legge quanti trade al giorno faceva davvero un sistema, e quando ha smesso |
| 🔴 **SSRN** (403) | **Ottava di fila** |
| 🔴 **Ricerca per parola chiave del Code Base** | **Il parametro `?keyword=` e' ignorato** (verificato su 3 parole: rende la pagina 1 non filtrata). Vedo **solo cio' che sta nelle prime pagine per data**: il catalogo profondo resta invisibile |
| 🔴 **Lo SPREAD BCM MISURATO** su D30EUR/U30USD/NASUSD | **Ancora non esiste in repo.** Uso i **2,0 punti indice** dichiarati di `METRO_PROP` D4, marcati **[SPREAD NON MISURATO]**. Il *RealCost Spread P95 Logger* (Code Base **74148**) e' promosso dal **23/08** e **mai usato**: e' la **quinta** caccia che lo scrive. 👉 **Finche' non gira, il cancello F2 e' tarato su una stima, non su una misura** |
| 🟡 **Il GMM di Mesfin §5** | **Non esiste nel record pubblico.** Verificato: 3 paper dell'autore su arXiv, in nessuno la specifica. **Non l'ho ricostruito e non lo ricostruiro'** |
| 🟡 **`ICT Master Suite [Trading IQ]`** | Ancora l'unica strategia del tag `ict` mai setacciata. **Non aperta oggi** — e' una *suite*, la classe gia' scartata per costo di validazione > valore atteso |
| ⚠️ **Nessun backtest eseguito** | Qui non esistono MT5 ne' Strategy Tester. **Nessun numero di questo dossier e' stato misurato oggi.** Quelli di casa vengono dai referti citati; quelli di fuori sono `[VERIFICATO su pagina/sorgente]`, `[DICHIARATO DALL'AUTORE]` o `[STIMA/INFERITO]` |
| 🔴 **I numeri di performance degli autori** | **Letti e NON usati in nessun punteggio.** Vale per il "60-70% win rate" di M0PB, per i "+15,77 pt" di Mesfin e per tutto il resto |

---

## 10. ❓ LA DOMANDA A CUI IL PRIMO TEST DEVE RISPONDERE

> ### **Su indice, a M5, quante volte al giorno il mercato offre un impulso estremo seguito da un rientro — e quel rientro ha davanti abbastanza spazio da pagare la frizione?**

**E' la domanda giusta perche' e' la sola che puo' chiudere il candidato senza
scrivere una riga di EA.** I due numeri del mandato sono **entrambi
misurabili da un contatore**:

- se i segnali sono **meno di 1 al giorno**, P1 muore per **F1** e non si
  spende una macchina;
- se la mediana ingresso→`highest(12)` e' **sotto 6,0 punti indice**, P1 muore
  per **F2**, e con lui muore l'idea che a M5 esista spazio sopra la frizione —
  che e' **la stessa cosa che il §6.1 di Mesfin ha gia' misurato su MNQ**;
- se **passano tutti e due**, allora — e solo allora — si scrive l'EA, e la
  prima cosa che deve girare e' **l'ablazione sulla durata** (massimo mobile a
  12 barre **contro** uscita a tempo alla barra 13). Perche' e' li' che sta
  l'unica differenza fra il candidato e la classe che il paper dichiara sotto
  il soffitto.

**E se il contatore dice di no, quella e' una risposta utile quanto un
promosso:** vorra' dire che la portata sugli indici **non si compra a M5**, e
allora l'unica strada resta quella gia' scritta il 29/08 e mai smentita —
**piu' SIMBOLI a M15-H1**, non piu' velocita'.

---

_Dossier chiuso il 31/08/2026. **~140 candidati censiti** su 6 fonti (4 vive,
2 nulle) + 3 fonti dati murate; **9 sorgenti letti riga per riga** (2 `.mq5`
scaricati, 4 Pine scaricati integrali, 1 articolo MQL5 con codice, 1 EA
d'articolo per specifiche); **2 paper arXiv letti per intero** (15 pagine
ciascuno) + 1 abstract completo; **1 promosso, 0 in coda, 3 spec, 7 scarti
motivati nel sorgente + ~245 scarti al primo taglio.**
**Nessun backtest eseguito. Nessun numero d'autore usato in nessun punteggio.
Nessun EA modificato, nessuna sedia toccata, nessun magic assegnato.**_

---

## ⚰️ ADDENDUM 31/08 SERA — ESITO DEL PROMOSSO: M0PB MORTO AL PASSO 0

La sonda di conteggio (`ABTG_SondaM0PB`, corsa 19:35, pin `4e1cdf8`) ha
bocciato M0PB **12/12** ai criteri congelati sopra: F1 0/12 (lato migliore
0,52 segnali/giorno contro soglia 1,00), H8 7/12 sotto 0,70 (e mai oltre
0,74; win rate necessario 62-70%), F2 12/12 verdi ma irrilevante.
Referto completo: `risultati_archivio/REFERTO_SONDAM0PB_2026-08-31.md`;
voce nel registro dei caduti aggiunta. Il punteggio 9/10 di questa scheda
resta agli atti come giudizio DI CARTA pre-misura: la misura l'ha ribaltato,
ed e' esattamente il lavoro del PASSO 0 (costo: minuti, zero tick).
La caccia frequenza prosegue sui candidati della SECONDA BATTUTA
(`CACCIA_FREQUENZA2_2026-08-31.md`): LondonFx e Sonda dell'Orologio.
