# 🎯 CACCIA 2026-08-16 — F · **LO SHORT SIMMETRICO** (buco n.3)

> **La riga che conta:**
>
> Su **119 titoli sfogliati** su 3 pagine del Code Base + 5 ricerche in
> letteratura, **4 arrivano al sorgente scaricato e letto**, **1 lo proverei
> subito** — ed e' **`001 - Turnaround Tuesday`**, perche' e' l'unico motore
> trovato in cui **la direzione non e' un input**: e' calcolata dal mercato,
> riga 119-120, esattamente come i nostri due EA "VINCOLATI" del R52. E in un
> mercato che sale **produce piu' SHORT che LONG per costruzione**.

**Bersaglio dichiarato:** buco n.3 del `CODA_PROSSIMA_SESSIONE.md` §5 — _"il
lato SHORT dell'apertura: R54 ha bocciato lo short del Dow, ma su DAX e Nasdaq
non e' mai stato misurato **come motore nato short**, solo come ramo aggiunto."_

**Vincolo di mira che mi sono dato prima di uscire**, da R52 + ROBUSTEZZA:
non cerco un motore long a cui aggiungere `AllowShort` — quella e' la forma
che ha **0 successi su 5** (R20, R12, R26, R45, R54). Cerco **motori la cui
direzione e' costitutiva**, come `ABTG_GapFill.mq5:424 isLong=(gGap<0.0)`.

---

## 0. 🎣 CONTROLLO POSITIVO — fatto prima di cercare, fonte per fonte

| fonte | esito | la prova (bersaglio di cui conoscevo gia' la risposta) |
|---|---|---|
| `mql5.com/en/code/mt5/experts` | 🟢 **PASSA** | HTTP 200, elenco reale. Nei primi 15 titoli ci sono **`ProAutoSL DynamicTP`**, **`Session Opening Range Breakout EA`**, **`Daily Zone Recovery EA mt5 for GOLD`**, **`Smart Trade Manager for MT5`** — **quattro file gia' nel nostro `SETACCIO_MANUALE.md`**. Il canale restituisce cio' che so gia' esserci. |
| paginazione `/page2` `/page3` `/page4` | 🟢 **PASSA** | 39 + 40 + 40 titoli distinti, nessuna ripetizione fra le pagine |
| `export.arxiv.org` (API) | 🟢 **PASSA** | `cat:q-fin.TR` restituisce titoli, autori e date veri (Derksen/Kleijn/de Vilder 2020-12-18, Karpe 2020-06-09, …) |
| pagina singola `/en/code/NNNNN` | 🟢 **PASSA** | 4 schede aperte, con autore + data + descrizione |
| download `/en/code/download/NNNNN/<nome>.mq5` | 🟢 **PASSA** | **3 sorgenti scaricati, HTTP 200**: 11.475 · 12.686 · 11.730 byte |

### 🔴 Fonti NON raggiunte — dichiarate, non sostituite con la memoria

| fonte | esito | nota |
|---|---|---|
| `papers.ssrn.com` | 🔴 **NULLA** | 403, challenge Cloudflare "Just a moment…". Anti-bot del sito, **non** la nostra allowlist. |
| `forexfactory.com` | 🔴 **NULLA** | idem. Perdiamo la fonte che racconta **come una strategia e' invecchiata** — per questa caccia e' una perdita vera, perche' l'effetto calendario e' proprio il tipo di cosa che decade. |
| ricerca interna MQL5 | 🔴 **INUTILIZZABILE** | `robots.txt` → `Disallow: /*/search*`, pagina JavaScript. |
| `WebSearch site:mql5.com/en/code` | 🟡 **RESA QUASI NULLA** | provata: ha restituito **Wikipedia e TradingView**, non il Code Base. **Ho abbandonato la ricerca e sono passato a sfogliare le pagine dell'elenco** — ed e' li' che ho trovato tutto. Lo scrivo perche' e' un'informazione di metodo per il prossimo giro. |

---

## 1. 📚 LA LETTERATURA — e va detto che **e' divisa**

Cinque ricerche su arXiv (`day of the week effect`, `short-term reversal`).
Riporto anche cio' che **gioca contro** il candidato, perche' e' il pezzo che
serve davvero:

| # | paper | data | cosa dice |
|---|---|---|---|
| 1 | *A new look at calendar anomalies: Multifractality and day of the week effect* — Stosic, Stosic, Vodenska, Stanley, Stosic (**arXiv 2106.06164**) | 2021-06-11 | i singoli giorni della settimana hanno **proprieta' multifrattali distinte**, e il lunedi' mostra persistenza piu' forte → 🟢 a favore |
| 2 | *Day of the Week Effect in biotechnology stocks* — Chatterjee (**arXiv 1701.07175**) | 2017-01-25 | rendimenti piu' bassi il **lunedi'**, piu' alti mer/gio/ven su 16 anni → 🟢 a favore |
| 3 | 🔴 *Spurious seasonality detection: a non-parametric test proposal* — Bariviera, Plastino, Judge (**arXiv 1801.07941**) | 2018-01-24 | l'effetto giorno-della-settimana e' **in parte un artefatto della struttura di correlazione nascosta**; testato su **83 indici azionari mondiali** → 🔴 **contro** |
| 4 | *Discovery of a 13-Sharpe OOS Factor* — Singha (arXiv 2511.12490) | 2025-11-16 | combina value + **short-term reversal** su S&P 500 (cross-section di titoli: **non traducibile** sul nostro CFD di indice) |
| 5 | *Cross-Sectional Heterogeneity in LSTM Networks* — Döbelt (arXiv 2608.05755) | 2026-08-13 | segnali guidati da un fattore di **short-term reversal** (idem: cross-section, non traducibile) |

> 🎯 **Lettura onesta.** La tesi ha un fondamento in letteratura **e ha una
> smentita seria e recente su 83 indici**. Questo **non squalifica** il
> candidato: lo qualifica come **screening con criteri congelati**, non come
> promozione annunciata. Il paper n.3 e' esattamente il motivo per cui il
> paletto sul filtro (§7) e' scritto come e' scritto.
>
> I paper 4 e 5 sono **cultura, non candidati**: lavorano sulla sezione
> trasversale di centinaia di titoli, noi abbiamo un CFD di indice. Li
> dichiaro e li lascio andare (§3A: _"e' traducibile su un simbolo che
> abbiamo? Se no, e' cultura"_).

---

## 2. 🥇 IL PROMOSSO — `001 - Turnaround Tuesday`

### 2.1 La scheda §7, compilata sul sorgente

```
NOME            001 - Turnaround Tuesday
FONTE / URL     MQL5 Code Base — https://www.mql5.com/en/code/73674
                sorgente: /en/code/download/73674/001-Turnaround-Tuesday.mq5
AUTORE / DATA   Sergey Ermolov (dj_ermoloff) — 05/06/2026 — versione 1.1
POPOLARITA'     3.096 visualizzazioni · voto 4,3/5 [VERIFICATO sulla pagina]
                Download NON esposti dalla pagina. [INCERTO]
LICENZA         "Open source — modification permitted" come da pagina.
                Nel sorgente: #property copyright "Copyright 2026, Sergei
                Ermolov | IT Trader" (riga 6). Nessun testo di licenza
                formale (MIT/GPL) nel file. [VERIFICATO]
RIGHE / INPUT   306 righe · 11.475 byte · **14 input**, di cui **4 sono
                `input group`** (etichette, non manopole)
                -> **10 manopole vere**, contro il nostro tetto di ~15 ✅

TESI IN UNA RIGA
  "Guadagna perche' il primo giorno pieno della settimana tende a
   RIBALTARE la direzione con cui si e' chiuso il lunedi': la spinta
   emotiva del lunedi' (che digerisce il weekend) e' in media eccessiva
   e si scarica il martedi'."

MECCANICA (3 righe)
  ingresso  al primo tick del nuovo giorno, SE il giorno appena chiuso
            era lunedi'. Direzione = OPPOSTA al segno del corpo del
            lunedi'. Una sola posizione per volta.
  uscita    TP a 2,5R (rrTP) oppure chiusura forzata all'ora CloseHour.
  stop      SL = ATR(D1,14) * kDailyATR, mandato al broker come SL vero.

GESTIONE RISCHIO
  ✅ rischio in **PERCENTUALE** (LOT_RISK, riga 213 `balance*riskPct/100`)
  ⚠️  ma su **balance letto UNA VOLTA in OnInit** (riga 50): e' "% del
      saldo di PARTENZA", non dell'equity corrente. Non compone.
  ✅ SL **vero**, mandato con l'ordine (righe 176 / 202), non virtuale
  ✅ una posizione per volta · ✅ controllo margine (CheckMargin, r.253)
  ❌ nessun parziale, nessun breakeven, nessun runner: TP secco 2,5R

BANDIERE ROSSE §4   **NESSUNA.**
  grep su martingala/griglia/multiplier/recovery/hedge/#import/WebRequest/
  DLL/iCustom/AccountInfo(LOGIN): **zero occorrenze**. [VERIFICATO]
  Nessun lotto che dipende dall'esito precedente. Nessun ordine senza SL
  (salvo il caso dichiarato kDailyATR==0, righe 147/152, che NON useremo).

COSTO DI PORTING   **ZERO righe di traduzione** (e' gia' MQL5 nativo).
                   ~1-2 ore di ADOZIONE per `mql5-ea-developer` (§2.4).

PUNTEGGIO (0-2)
  [2] semplicita'                10 manopole vere, 306 righe, si legge tutto
  [2] il filtro E' il motore     la direzione E' la strategia, non un input
  [2] tesi di mercato scrivibile si', e ha 2 paper a favore e 1 contro
  [2] riempie un BUCO            buco n.3 (short simmetrico) in pieno
  [2] testabile senza riscritture nessuna dipendenza esterna, rischio in %
                                 -> **10 / 10** · VERDETTO **PROVA SUBITO**

PERCHE'  E' l'unico motore trovato in cui il lato non e' una manopola: in un
         mercato che sale genera piu' SELL che BUY **per costruzione**, ed e'
         il contrario esatto del nostro libro. E il costo per saperlo e' un
         solo round di screening.
```

### 2.2 🎯 Il pezzo che lo rende il candidato giusto per QUESTO buco

Righe **119-120**, ed e' tutta la direzione dell'EA:

```cpp
   bool isBullish = closeDay > openDay;
   bool tradeUp   = !isBullish;
```

**Non esiste `InpAllowLong` / `InpAllowShort` in tutto il file.** [VERIFICATO]

E' la stessa grammatica dei due EA che R52 classifica **VINCOLATI** — cioe'
gli unici due del nostro parco a cui non si puo' "spegnere un lato" perche'
il lato lo decide il mercato:

| nostro | riga | direzione decisa da |
|---|---|---|
| `ABTG_GapFill` | `.mq5:424 isLong=(gGap<0.0)` | segno del gap |
| `ABTG_BreakingBand` | `.mq5:924 isLong=(gBulgeDir>0)` | verso del bulge |
| 🆕 **Turnaround Tuesday** | **`:119-120 tradeUp = !isBullish`** | **segno del corpo del lunedi'** |

> 🔥 **E qui c'e' la cosa che vale piu' di tutto il resto del dossier.**
> In un mercato che **sale**, il lunedi' chiude sopra la sua apertura piu'
> spesso di quanto chiuda sotto. `tradeUp = !isBullish` → **piu' SELL**.
> **Questo motore e' strutturalmente SHORT proprio nel regime in cui tutte
> le nostre 14 celle long sono state tarate.** [INFERITO, dalle righe
> 119-120 + dal fatto che i nostri 21 mesi BCM sono un solo regime in salita]
>
> ⚠️ **Ma esposizione anti-correlata non e' P&L anti-correlato**, e non lo
> spaccio per tale: lo dice solo la misura, con l'export per-trade e il DD
> combinato (`ROTTA_PROP.md` punto 2). Qui e' un'**ipotesi con un
> meccanismo**, che e' il massimo che un dossier possa consegnare.

### 2.3 🐛 I TRE DIFETTI CHE HO TROVATO NEL SORGENTE

Nessuno e' nel motore. Tutti e tre sono **gestione**, cioe' §5.F: _"un
candidato con un motore sensato e una gestione scadente e' un BUON
candidato"_. Li elenco perche' vanno corretti **prima** di misurare, o si
misura un'altra cosa.

#### 🔴 A. Un off-by-one che **butta via l'ora di apertura** — e morde solo sugli INDICI

`GetCheckDayData()` (righe 267-307) ricostruisce a mano la candela del lunedi'
da barre H1. Cerca la barra "confine" alla stessa ora, poi cicla:

```cpp
   for (int i = 1; i < boundaryIdx; i++) {      // <-- riga 296: ESCLUDE boundaryIdx
      ...
      openDay = iOpen(_Symbol, PERIOD_H1, i);   // <-- riga 303
   }
```

La barra `boundaryIdx` **e' la barra di apertura del lunedi'**, ed e' esclusa
dal ciclo. Traccia su `D30EUR` (sessione 08:00-22:00 server), EA che parte
alle 08:00 di martedi':

- `boundaryIdx` = 14 → lunedi' **08:00**, la barra dell'apertura
- il ciclo copre i = 1..13 → da lunedi' 21:00 giu' fino a lunedi' **09:00**
- quindi `openDay` = apertura delle **09:00**, non delle 08:00

**Conseguenza:** `isBullish` — cioe' **il segno che decide la direzione del
trade** — viene calcolato scartando la prima ora del lunedi'. Sul DAX quella
e' l'ora piu' volatile della giornata. E anche `highDay`/`lowDay` (usati dal
filtro ATR) escludono la stessa ora.

> 📌 **E il difetto e' peggiore proprio dove ci serve.** Su un simbolo 24h
> (forex) l'errore vale 1 ora su 24. **Su un indice con sessione vale 1 ora
> su 14, ed e' l'ora della campanella.** Il nostro bersaglio e' l'indice.
>
> ✅ **La correzione e' banale e riduce il codice**: `iOpen/iClose/iHigh/iLow`
> su `PERIOD_D1, 1` danno la candela del lunedi' esatta, gratis. Le 40 righe
> di `GetCheckDayData` sono una reimplementazione fragile di una primitiva
> che MT5 gia' offre.

#### 🔴 B. `PositionsTotal()` non e' filtrato — l'EA si autozittisce sul nostro conto

```cpp
   if (PositionsTotal() > 0) return;            // <-- riga 94
```

`PositionsTotal()` conta **tutte le posizioni del conto**, di qualunque
simbolo e magic. Sul nostro conto, dove girano decine di EA insieme, questo
EA **smette di operare ogni volta che un qualsiasi altro EA ha una posizione
aperta**. In backtest da solo non si vede; in forward sulla flotta si', ed e'
un motore che fa gia' solo un trade a settimana.

Nota di merito, per equita': `CloseAllPositions()` (righe 236-246) **e'**
filtrata per magic **e** simbolo. E' solo il controllo d'ingresso a non
esserlo. (Non e' il caso di `Mean_Reversion` del setaccio, che chiudeva le
posizioni altrui: qui **non tocca niente di nostro**, si blocca e basta.)

#### 🔴 C. Manca `OnTester` → **il driver rifiuta di partire**. E' l'unico vero blocco.

Verificato da me su `walkforward_generico.ps1`, righe 144-147:

```powershell
if($src -notmatch 'double\s+OnTester\s*\('){
  Muori ("$Expert NON esporta i risultati (manca OnTester).`n" + ...)
}
```

`grep 'OnTester'` sul sorgente: **0 occorrenze**. [VERIFICATO] Stesso blocco
gia' incontrato oggi sul Nikkei Gap: e' un'aggiunta meccanica, non un
ripensamento.

### 2.4 ✅ COSA TENGO / ❌ COSA RIFACCIO (mandato §5.F, separati)

| ✅ **IL MOTORE — si tiene com'e'** | ❌ **LA GESTIONE — la rifacciamo noi** |
|---|---|
| la direzione costitutiva (r.119-120) — **e' l'edge, non si tocca** | `OnTester` da aggiungere (blocco duro) |
| il giorno di controllo come **`const`**, non input (r.39) — vedi §3 | l'off-by-one: passare a `PERIOD_D1` |
| un solo trade, una sola posizione, SL vero | `PositionsTotal()` → filtrare per magic+simbolo |
| rischio in **percentuale** (gia' scalabile a 100k) | `balance` fisso da OnInit → equity corrente |
| ATR(D1) come misura dello stop | TP secco 2,5R → **parziale 1R + BE + runner 2R** (la nostra gestione delle sedie DAX/Dow) |
| — | spread come **% dello stop**, non in punti (R55) |
| — | intestazione di attribuzione autore+URL+licenza (§9) |

**Costo stimato:** ~1-2 ore di `mql5-ea-developer`. **Nessuna riscrittura**:
il file e' 306 righe, gia' MQL5, gia' leggibile.

> ⚠️ **Nell'ordine giusto**: prima l'adozione minima (OnTester + i due fix +
> attribuzione) e **lo screening del motore NUDO**. La gestione fine
> (parziale/BE/runner) si mette **dopo** che il motore ha dato un segno —
> altrimenti stiamo tarando la gestione su un edge che non sappiamo se esiste.

### 2.5 🏛️ IL CANCELLO PROP (§7-bis) — una riga, e ne dico anche il lato brutto

> **In ottica prop, questo motore vale soprattutto per la FORMA del suo
> rischio, non per il suo rendimento atteso.**

| criterio §7-bis | come sta messo |
|---|---|
| **1. peggior giornata** | 🟢 **strutturalmente protetta**: 1 trade, 1 posizione, SL vero mandato al broker. La peggior giornata **e' 1R**. A 0,65% sono **−650 su 100k**, contro il muro giornaliero di **−5.000**. La nostra peggior giornata misurata (R51) e' −2,06% ≈ 3,2R: questo motore **non puo' arrivarci da solo**. |
| **2. frequenza / concentrazione** | 🟢 **il meglio possibile**: **~1 trade a SETTIMANA**. E' l'opposto esatto del rischio "5 trade correlati la stessa mattina". |
| **3. scorrelazione** | 🟢🔴 **mista, e va detta intera.** 🟢 il lato e' opposto al nostro libro per costruzione, e **nessuna delle 32 celle di R52 lavora su un effetto di CALENDARIO**: e' un asse nuovo. 🔴 **ma entra sullo STESSO simbolo (D30EUR) alla STESSA campanella di `ABTG_DAX_Apertura_EU`**, che e' live. `ROTTA_PROP` regola 1: _"mai due EA sullo stesso segnale/simbolo/lato allo stesso rischio pieno"_. Il martedi' sarebbero due EA sulla stessa apertura. **Non e' un veto — sono lati per lo piu' opposti — ma il DD combinato va MISURATO con l'export per-trade prima di accenderli insieme.** |
| **4. DD trailing** | 🟡 **[INCERTO], e per un motivo strutturale**: 1 trade/settimana significa **lunghi periodi fermi**. Una prop col DD che insegue l'equity punisce i lunghi ritorni dal picco. Con ~50 trade OOS il profilo di equity e' a scalini larghi: **e' esattamente la forma che il trailing tratta peggio.** Da segnalare, come chiede il §7-bis punto 4. |
| **5. scalabilita' a 100k** | 🟢 rischio in % gia' nel codice (r.213). ⚠️ ma su balance di partenza, non equity: **da correggere**, altrimenti a taglia prop non compone. |

---

## 3. 🪤 LA TRAPPOLA — `003 - Weekly Day Reversal`, dello **stesso autore**

L'ho scaricato e letto **apposta**, perche' a prima vista sembra il candidato
migliore: e' `001` generalizzato ("any combination of weekdays can be tested").
**E' il contrario: e' `001` con il segno dell'edge trasformato in manopola.**

| | `001` (promosso) | `003` (respinto) |
|---|---|---|
| il giorno di controllo | **`const ENUM_DAY_OF_WEEK CHECK_DAY = MONDAY;`** (riga 39) — **non ottimizzabile** | **`input`** `CHECK_DAY` (riga 32) → **5 valori** |
| reversal o continuation | **cablato**: `tradeUp = !isBullish` | **`input ENUM_DIRECTION Direction = reverse;`** (riga 33) → **2 valori** |
| **manopole vere** (esclusi gli `input group`) | **10** | **12** |

**La differenza fra i due file e' esattamente 2, e sono quelle due.** Non e'
un'impressione: e' una sottrazione. `003` non aggiunge meccanica al motore —
aggiunge **solo** le due manopole che permettono di scegliere il giorno e il
segno dell'edge sul passato.

```
# 003, righe 32-33 — VERIFICATO sul sorgente scaricato (11.730 byte)
input ENUM_DAY_OF_WEEK CHECK_DAY = MONDAY;     //Day Of Week
input ENUM_DIRECTION   Direction = reverse;    //Direction
```

> 🚨 **`Direction` come input vuol dire che il SEGNO DELL'EDGE e' un parametro
> da ottimizzare.** 5 giorni × 2 direzioni = **10 combinazioni**, e si sceglie
> quella che stava meglio sul passato. E' la macchina dei nostri 30
> ribaltamenti in forma pura: su **13 misure di Spearman IS→OOS, 12 sono
> negative**.
>
> E il nostro setaccio ha gia' scritto la sentenza su questa identica forma,
> sull'EA **dello stesso autore**: `Universal Breakout Study` — _"un
> interruttore per giorno della settimana, col lunedi' spento, e' la forma
> piu' pura di curve-fitting che esista"_.

**Quindi:** `003` **non entra nel primo round**, e non va usato per "provare
anche gli altri giorni". Se un giorno vorremo misurare mercoledi' o la
continuazione, si fara' **come round dichiarato con criteri scritti prima**,
non spazzolando 10 celle e tenendo la migliore.

> 📌 **E c'e' un riscontro che vale per il futuro:** tre EA di **Sergey
> Ermolov** sono ormai passati dal nostro setaccio (`Universal Breakout
> Study` scartato per 38 input, `003` respinto qui, `001` promosso). Il suo
> stile e' **"EA di ricerca ben scritti, ma con troppe manopole"**. `001` e'
> l'eccezione **perche' e' il primo della serie**, quando ancora non aveva
> aggiunto niente. **Nella sua serie numerata, il numero piu' basso e' il
> piu' pulito** — vale la pena ricordarselo.

---

## 4. 🥈 IL SECONDO — `Dominance EA`, **IN CODA (7/10)**

```
NOME            Dominance EA
FONTE / URL     https://www.mql5.com/en/code/71195
                sorgente: /en/code/download/71195/Dominance_EA.mq5
AUTORE / DATA   Chukwubuikem Okeke (Bikeen) — 30/03/2026 08:13
POPOLARITA'     4.975 visualizzazioni · voto 4/5 [VERIFICATO]
LICENZA         🔴 NON dichiarata, ne' sulla pagina ne' nel sorgente. [INCERTO]
RIGHE / INPUT   359 righe · 12.686 byte · **12 input**, di cui **3 sono
                `input group`** -> **9 manopole vere**

TESI IN UNA RIGA
  "Guadagna perche' il lato che ha CONTROLLATO la giornata precedente
   (piu' candele sue, e chiusura dalla sua parte della media) tende a
   controllare anche l'apertura della successiva."

MECCANICA  una volta al giorno all'apertura, **lunedi' escluso**. Conta le
           candele rialziste vs ribassiste del giorno prima; conferma con la
           posizione della chiusura rispetto a una MA(14). SL = estremo del
           giorno prima ± ATR*2,5. TP = 2R.
BANDIERE ROSSE §4  nessuna martingala, nessuna griglia, SL vero.
```

**Perche' merita la coda e non lo scarto:**
- 🟢 direzione **costitutiva** (`getTodayBias`, nessun input di lato)
- 🟢 e sa **NON entrare**: se il conteggio dice una cosa e la MA un'altra, il
  bias resta `BIAS_NEUTRAL` e non opera. E' **letteralmente** la richiesta di
  Claudio del 15/08 (`ROBUSTEZZA.md`): _"se il mercato va long o short o
  laterale, i nostri EA devono capire il mercato e quindi entrare o non
  entrare"_.
- 🟢 esclude il lunedi' → **e' complementare a `001`, che vive sul martedi'**

**Perche' non e' il numero uno:**
- 🔴 **lotto fisso, e nemmeno un input**: `trade.Buy(_VolumeMin, ...)` e
  `trade.Sell(_VolumeMin, ...)` — **il minimo del simbolo, cablato**. Non
  scalabile a 100k, non confrontabile con niente di nostro. **Tutto il
  sizing va riscritto**, non ritoccato (§4: _"lotto fisso senza rischio %"_).
- 🔴 `input ENUM_EA_MODE eaMode` con `MODE_INVERTED`: **un interruttore che
  inverte la tesi**. Stessa malattia del `Direction` di `003`, in forma piu'
  educata. Va **congelato a `MODE_NORMAL`** e mai spazzolato.
- 🟡 doppia chiamata a `CopyRates` con gli stessi argomenti (~righe 241 e 245):
  sciatteria, non un difetto di logica.
- 🔴 nessun `OnTester` (stesso blocco).

> **Verdetto: IN CODA.** Il motore e' sano e riempie lo stesso buco, ma il
> costo di adozione e' **piu' alto di `001`** (sizing intero da rifare) a
> parita' di domanda. Si guarda **dopo** che `001` ha detto se l'asse
> "direzione costitutiva sull'apertura del DAX" e' vivo o morto. Se `001` e'
> rosso, questo non si apre nemmeno.

---

## 5. 📋 LA TABELLA DEGLI SCARTATI — una riga di motivo a testa

**Sfogliati 119 titoli** (page2: 39 · page3: 40 · page4: 40). Non elenco i 119:
elenco **quelli che hanno superato il primo taglio e sono poi caduti**, piu'
i motivi ricorrenti. Serve a non ricercarli il giro prossimo.

### 5.1 Arrivati al sorgente o alla scheda, e caduti

| EA | URL | motivo dello scarto |
|---|---|---|
| **`003 - Weekly Day Reversal`** | `/en/code/74137` | 🪤 **il segno dell'edge e' un input** (`Direction=reverse\|continuation`) + giorno libero = 10 combinazioni da pescare. Vedi §3. **Sorgente scaricato e letto** (11.730 byte). |
| **`Liquidity Sweep H4 - M15`** | `/en/code/68951` | simmetrico per costruzione (sweep del massimo → short, del minimo → long) e la tesi ci mancherebbe. Ma: **rischio monetario FISSO**, e l'autore stesso dichiara **"proof-of-concept, further optimization recommended"**, con test a **RR = 0,2** (venti perdite pagate da cento vincite: profilo che il nostro cancello DD non regge). **Costo di validazione > valore atteso.** |
| `002 - Inside Bar` | `/en/code/73884` | stesso autore, motore simmetrico (stop pendenti sui due lati) — ma **e' un motore di BREAKOUT dalla inside bar**, e il breakout e' porta chiusa con ~96 celle (R7-R13, R42, R45, R12). Non lo riapro per la terza volta. |
| `Universal Breakout Study` | `/en/code/73711` | **gia' nel `SETACCIO_MANUALE.md`** (38 input). Citato qui solo come riscontro sull'autore. |

### 5.2 I motivi ricorrenti che hanno ucciso il resto dei 119

| motivo | quanti (circa) | esempi visti nell'elenco |
|---|---|---|
| **griglia / martingala / recovery**, spesso nel titolo | ~15 | `XANDER Grid XAUUSD`, `RSI Grid EA Pro`, `BGC Grid EA`, `Grid Master`, `Simple_Grid`, `Sideways Martingale`, `MASTER-WINNERFX-Asim`, `Tarantella`, `BotCilento`, `MT5-BuildYourGridEA`, `Martingale Pulse EA`, `KSU_martin`, `VR Locker Lite` (lock), `HedgeCover EA`, `Back kick` (apre il lato opposto) |
| **non e' una strategia: e' un attrezzo** (pannelli, calcolatori, copier, notifiche) | ~30 | `XPro Trade Panel`, `ASQ FlowDesk`, `Position Size Pro Lite`, `Risk Calculator`, `Close All Orders`, `KopierMaschineMT5`, `MT5 Telegram Trade Notifier`, `Stealth Trade Manager`, `Withdrawal Tracking`, `Spread lister` |
| **direzione LONG-ONLY dichiarata** → e' il buco al contrario | 2 | **`Long-Only Trend Breakout with Dynamic Risk Management`** (il nome lo dice), `Indices Tester` (_"trades buy positions **without stop loss or take profit**"_ → doppio scarto) |
| **breakout / opening range** → porta chiusa con ~96 celle | ~8 | `Easy Range Breakout EA`, `Outbreak Trader 1.0`, `VR Breakdown level`, `ASQ Safe Scalping`, `ExMachina SafeScalping`, `Hon APS`, `Viral 4 Hour Range Strategy` |
| **scatola nera / ONNX / AI** → tesi non scrivibile, §5.C | ~6 | `Market Structure Onnx`, `ONNX Trader`, `Prime Quantum AI` (chiama **provider AI esterni** → anche §4 rete), `Larry Williams XGBoost Onnx`, `CryptoTrend` ("self-learning"), `Hon Matrix` |
| **troppe manopole / multi-indicatore** | ~10 | `Seven strategies in One expert`, `Multi_Divergence_EA`, `TrendMomentumEA`, `Candlestick Analysis EA R1`, `ICE (Impulse Confirmation Engine)` |
| **gia' setacciati** (non li ricontrollo, §"NON RICONTROLLARE") | 6 | `Quantum Gold Silver Trader`, `XANDER Gold Recovery`, `Pending tread EA`, `MeanReversionTrendEA`, `Universal Breakout Study`, `Smart Trade Manager` |
| **fuori perimetro / non serio** | 3 | `PlayDOOM` (fa girare DOOM dentro MT5), `Random Trader with Customizable Risk/Reward`, `Babi Ngepet` |

> 🔎 **Una nota che vale per le prossime cacce.** Fra 119 titoli, i motori con
> **direzione costitutiva** sono stati **quattro** (`001`, `003`, `Dominance`,
> `Liquidity Sweep`) — circa il **3%**. La stragrande maggioranza degli EA
> gratuiti o e' un attrezzo, o e' una griglia, o mette `AllowLong/AllowShort`
> come interruttori. **Il buco n.3 e' difficile da riempire dall'esterno
> perche' quasi nessuno scrive motori nati con la direzione dentro** — ed e'
> anche il motivo per cui, quando se ne trova uno, vale il round.

---

## 6. 🚫 COSA NON HO POTUTO VEDERE

1. **SSRN e Forex Factory**: 403 Cloudflare. Su Forex Factory perdiamo la
   cosa che serviva di piu' qui — **i thread lunghi anni che raccontano se e
   quando un effetto di calendario ha smesso di funzionare**. Un effetto
   stagionale pubblicato e' proprio il tipo che decade dopo la pubblicazione,
   e non ho potuto verificarlo. **Buco dichiarato.**
2. **I download di `001`**: la pagina espone visualizzazioni (3.096) ma **non**
   i download. Non li invento. [INCERTO]
3. **La licenza di `Dominance EA`**: non dichiarata da nessuna parte.
   Prima di qualunque uso oltre la ricerca interna, va verificata. [INCERTO]
4. **I numeri dichiarati dall'autore di `001`** (backtest 2016-2026: "XAUUSD
   +38%, SP500 +40% con DD 11%" **col filtro ATR acceso**; senza filtro
   _"minimal edge"_) sono **"dichiarato dall'autore, NON verificato"** e
   **non hanno pesato di un grammo** sul punteggio. ⚠️ **Anzi: pesano al
   contrario**, e questa e' la cosa piu' importante del paragrafo — vedi §7.
5. **Il vero comportamento orario su `D30EUR`**: ho dedotto dal codice che
   l'ingresso cade al primo tick dopo la mezzanotte server, che su un indice
   con sessione **e' la campanella**. E' [INFERITO] dalle righe 81-82, non
   misurato. Il giro a vuoto del driver lo confermera'.

---

## 7. ⚠️ L'AVVERTENZA CHE VALE PIU' DEL CANDIDATO

L'autore dichiara che **il motore nudo ha "minimal edge"** e che i numeri
diventano belli **quando accende il filtro ATR**.

> 🔴 **Nel nostro progetto quella frase e' un allarme, non una promessa.**
> "Motore mediocre + filtro che lo salva" e' **esattamente** la forma con
> **0 successi su 5**: R20 (ADX), R12 (EMA200+volumi, 48/48 rosse OOS),
> R26 (volumi: PF sale a 2,37, DD scende a 2,59%, **e il profitto crolla da
> 1.811 a 1.138**), R45 (_"attenua ma non inverte mai"_), R54 (lo short come
> ramo).
>
> **Il filtro ATR dell'autore e' il SUO overfitting, non il nostro edge** (§0).

Per questo il filtro **va congelato spento** — e il file prova della caccia D
lo fa gia', riga `InpUseATRFilter=0||0||0||0||N`. ✅

**Il paletto che aggiungo io, e che voglio scritto adesso:** se il motore nudo
e' rosso, **la famiglia si chiude e NON si riapre accendendo il filtro**. Non
si spazzola `InpMinDayATR`, non si prova "solo per vedere". Se non lo mettiamo
per iscritto oggi, fra due settimane qualcuno (io) accendera' quel filtro — e
avremo il **31esimo ribaltamento** invece del primo short simmetrico.

---

## 8. ❓ LA DOMANDA A CUI IL PRIMO TEST DEVE RISPONDERE

> ### Sul DAX, un motore la cui direzione e' **decisa dal mercato e non da un input** — e che in un mercato in salita produce **piu' short che long per costruzione** — ha un edge fuori campione **senza nessun filtro**, nella stessa finestra 2024-2026 in cui tutte le nostre 14 celle long-only sono state tarate?
>
> **Se SI:** abbiamo il primo motore **nato simmetrico** del progetto, su un
> asse (il calendario) che nessuna delle 32 celle di R52 tocca, con la
> peggior-giornata strutturalmente limitata a 1R. Si passa ai tick reali e
> poi al DD combinato con `ABTG_DAX_Apertura_EU`.
>
> **Se NO:** abbiamo chiuso il buco n.3 dal lato esterno con **un round solo**,
> e la lettura diventa forte: _"lo short sull'apertura degli indici non
> funziona ne' come ramo aggiunto (R54) ne' come motore costitutivo"_ — che
> e' un'informazione che oggi non abbiamo e che vale quanto una promozione.

**In entrambi i casi il round paga.** E' il tipo di esperimento che il §0
chiede: non "la strategia che guadagna", ma **una struttura sensata e
testabile in fretta**.

---

## 9. 🤝 CONVERGENZA CON LA CACCIA D — **due buchi, LO STESSO MOTORE**

Mentre scrivevo, la **caccia D (`CACCIA_2026-08-16_D_LATERALE.md`)** ha
promosso **lo stesso EA**, arrivandoci dal buco n.1 (**il LATERALE**), e ha
scritto `backtest_pipeline/prove/ABTG_TurnaroundTuesday.txt`.

> 🎯 **Non e' una collisione da sanare: e' una conferma indipendente.** Due
> cacciatori, partiti da due buchi misurati diversi, hanno spazzolato fonti
> diverse e sono atterrati sullo stesso motore. Nel nostro archivio le
> conferme indipendenti valgono (R59 §4: _"tre controlli diversi, tre volte
> lo stesso esito, e nessuno era costruito per confermare gli altri"_).

**Il loro file prova resta quello buono, e non l'ho toccato.** Due motivi, e
il secondo e' che avevano ragione loro:

1. `LEGGIMI.md` dice **un file per EA**. Un secondo file per lo stesso motore
   sarebbe la trappola del 15/08 (la riga R58 che puntava al file sbagliato).
2. Loro prescrivono un EA nuovo con i **nostri** nomi `Inp*`; io avevo scritto
   il file sui nomi originali dell'autore. **La loro e' la strada di casa** —
   la stessa di `ABTG_GapContinuation`. La mia versione e' cestinata.

### Come convivono i due round, senza scrivere niente di nuovo

I due buchi vogliono lo **stesso EA su simboli diversi**, e il driver lo
sostiene gia' da solo (`LEGGIMI.md`: _"si possono passare da riga di comando
`-Simbolo`, `-Periodo`, `-DaQuando`: l'argomento vince sulla direttiva"_).

| | caccia D — LATERALE | **questa caccia (F) — SHORT** |
|---|---|---|
| simbolo | `GBPUSD` (nel file) | **`D30EUR`**, da riga di comando |
| periodo | `H1` | **`M15`** (sotto M15 l'OHLC e' fuorviante, regola 08/08) |
| `@DAQUANDO` | **vuoto, e giustamente**: lo storico GBPUSD non e' misurato | **`2024.09.26` — MISURATO** (06/08 con `SERIES_SERVER_FIRSTDATE`: locale = server, 3 simboli × 7 TF; `BROKER_ESTERNO_MAPPA.md:214`) |
| la domanda | il ribaltamento ancorato al calendario lavora nel laterale? | il motore nato simmetrico produce edge **short** sull'apertura dell'indice? |

### 🕐 IL FUSO, col calcolo mostrato (regola fissa: **ora server BCM = ora italiana − 1**)

**Gli orari di questo EA sono gia' in ora SERVER, e l'ho verificato nel
sorgente** — non e' un'assunzione:

```
riga 77:  tc = TimeCurrent(mtc);              <- TimeCurrent = ora SERVER
riga 78:  if (mtc.hour >= CloseHour) CloseAllPositions();
```

| cosa | ora italiana | calcolo | **ora server (da usare)** |
|---|---|---|---|
| apertura DAX (l'ingresso) | 09:00 | 9 − 1 | **8** ✅ = `InpEntryHourServer=8` |
| chiusura DAX cash | 17:30 | 17,5 − 1 | **16:30** |
| chiusura forzata scelta | 23:00 | 23 − 1 | **22** = `InpCloseHourServer=22` |

✅ **Il file della caccia D e' gia' corretto su entrambi**: spazzola
`InpEntryHourServer` su `0` e `8`, e **8 e' proprio la campanella del DAX in
ora server**. Il `22` di chiusura sono le 23:00 italiane, cioe' fine giornata
CFD: per un effetto di calendario che vuole tenere tutto il martedi', va bene.

⚠️ **Il controllo rapido di sempre, sul CSV che uscira':** la colonna
dell'ora d'ingresso deve dire **8**. Se dice **9**, e' ora italiana → numeri
da cestinare.

📌 E c'e' un motivo in piu' per cui `InpEntryHourServer=8` conta qui: nel
sorgente originale l'ingresso cade al primo tick dopo la mezzanotte server
(righe 81-82), che su un indice con sessione **e' la campanella**. Rendendolo
un input esplicito, la caccia D ha tolto un'ambiguita' che sul forex 24h non
si vedeva e sull'indice si'.

**La riga di lancio del mio round** (passata dalla `CHECKLIST_RIGA_DI_LANCIO.md`:
ho aperto il driver, il file prova e ho verificato il cancello `OnTester`):

```
powershell -ExecutionPolicy Bypass -File .\walkforward_generico.ps1 `
  -Expert ABTG_TurnaroundTuesday `
  -Prova .\prove\ABTG_TurnaroundTuesday.txt `
  -Simbolo D30EUR -Periodo M15 -DaQuando 2024.09.26 `
  -Modello 1 -Deposito 100000 -Etichetta tt_dax -SoloControllo
```

🛑 **Prima il giro a vuoto (`-SoloControllo`), sempre.** E finche' l'EA non
esiste il driver **deve** fallire su `OnTester`: e' il comportamento corretto,
non un errore da aggirare. ⚠️ **UNA MACCHINA, UN LAVORO**: il PC di backtest
ha un solo MT5 — questo round e quello della caccia D non girano insieme.

### 🐛 L'unica cosa mia che manca nel loro file, ed e' un difetto vero

Ho controllato riga per riga: il loro file **copre gia'** il `PositionsTotal()`
di conto (riga 139) e l'obbligo di `OnTester`. **Non copre l'off-by-one del
§2.3.A** — che e' il piu' insidioso dei tre, perche' non impedisce all'EA di
girare: gli fa solo **calcolare la direzione sull'ora sbagliata**, e morde
proprio sugli indici, cioe' sul mio simbolo.

> 📌 **Da portare nella specifica dell'EA, in una riga:** la candela del
> lunedi' si legge con `iOpen/iHigh/iLow/iClose(_Symbol, PERIOD_D1, 1)`, **non**
> ricostruita da barre H1. Le 40 righe di `GetCheckDayData` (originale
> 267-307) sono una reimplementazione fragile che perde la barra di apertura.

---

## 10. 📎 File di questa caccia

- **questo dossier** (l'unico file che ho scritto nel repo)
- sorgenti scaricati e letti per intero, fuori repo (scratchpad):
  `001-Turnaround-Tuesday.mq5` (11.475 byte, 306 righe) ·
  `Dominance_EA.mq5` (12.686, 359 righe) ·
  `003-Weekly-Day-Reversal.mq5` (11.730)

> ℹ️ **Non ho toccato `SETACCIO_MANUALE.md`** ne' il file prova della caccia D:
> oggi lavorano tre cacciatori in parallelo e sarebbe un conflitto di
> scrittura. Le schede dei 4 file letti stanno qui in §2/§3/§4/§5.1, pronte
> da travasare quando le tre cacce rientrano.
