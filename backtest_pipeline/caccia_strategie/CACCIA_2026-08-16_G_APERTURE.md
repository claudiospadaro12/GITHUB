# 🏹 CACCIA G del 16/08/2026 — **LE APERTURE DI DAX E NASDAQ**

_Quinta battuta della giornata. Bersaglio: il punto 5 della
`CODA_PROSSIMA_SESSIONE.md` — motori per l'apertura di DAX e Nasdaq, con
mandato esplicito su **`retest`** (zero occorrenze nei quattro dossier
precedenti) e sul **gap in continuazione**._

---

## 🎯 LA RIGA CHE CONTA, PRIMA DI TUTTO IL RESTO

> **Su 1.200 EA del Code Base sfogliati a mano + 1.185 sorgenti del mirror
> passati al grep, `retest` compare ZERO volte nei titoli e ZERO volte nei
> sorgenti. Tre candidati sono arrivati alla lettura del sorgente, uno solo
> lo consiglierei — ma il risultato che vale davvero questa caccia non e'
> un EA esterno: e' che, controllando di non duplicare roba nostra, ho
> trovato una spazzolata che il NOSTRO referto aveva ordinato e che nessuno
> ha mai fatto, su un motore d'apertura che in OOS fa PF 1,94 con DD 3,28%.**

E ho anche **chiuso una porta** che la coda considerava ancora aperta.
Vedi §6: sono due round risparmiati.

---

## 1. 🚦 CONTROLLO POSITIVO, FONTE PER FONTE

| fonte | prova fatta | esito |
|---|---|---|
| **MQL5 Code Base** `/en/code/mt5/experts` | `HTTP 200`, 84.623 byte, 40 schede/pagina con `id`, titolo e autore veri (es. `76153 Session Opening Range Breakout EA`) | 🟢 **VIVA** |
| **Mirror GitHub** `GeneralTradingSarl/expert-mt5` | clonato, **1.185 `.mq5`** convertiti da UTF-16 e indicizzati | 🟢 **VIVO** |
| **arXiv API** | ⚠️ **`http://export.arxiv.org` risponde 0 byte** (bloccato dal proxy). In **`https://`** risponde `HTTP 200` con entry veri | 🟢 **VIVA, ma solo in https** |
| **SSRN** `papers.ssrn.com` | `HTTP 403` | 🔴 **NON RAGGIUNTA** (challenge Cloudflare del sito) |
| **Quantpedia** | `HTTP 308` (redirect), non sceso oltre | 🟡 **non usata** |
| **Forex Factory** | non tentata dopo il 403 noto | 🔴 **NON RAGGIUNTA** |

📌 **Nota di metodo confermata**: come nella caccia F, lo **sfoglio diretto
delle pagine di elenco** ha reso tutto; la ricerca interna MQL5 resta
inutilizzabile. In piu' aggiungo un dettaglio nuovo e riusabile: **l'API
arXiv va chiamata in `https`**, in `http` torna vuota senza errore — che e'
il modo peggiore in cui una fonte puo' fallire, perche' sembra "nessun
risultato" invece di "canale morto". Chi legge questo file lo sa gia'.

---

## 2. 📚 COSA HO SFOGLIATO DAVVERO

### A. Code Base, 30 pagine di elenco = **1.200 EA**

Filtrati per le parole del mandato (`retest`, `pullback`, `fair value`,
`fvg`, `gap`, `opening`, `drive`, `reversal`, `continuation`, `fade`,
`imbalance`, `order block`, `first`):

| id | titolo | esito |
|---|---|---|
| **73958** | **ADX Trend Pullback EA** | 🟢 **letto nel sorgente — promosso** |
| **71467** | **KSQ Fair Value Gap EA (FVG)** | 🟡 **letto nel sorgente — in coda** |
| 68704 | Price Action Intraday Trading | 🔴 scarto (1.237 righe, 29 input, nessun `OnTester`) |
| 76153 | Session Opening Range Breakout EA | 🔴 **ORB — porta chiusa** (~210 celle) |
| 75586 | GoldLondonBreakout | 🔴 gia' nel `SETACCIO_MANUALE.md` (= R45) |
| 75301 | Nikkei 225 Gap Continuation EA | 🔴 **gia' in casa** (dossier C di oggi) |
| 74137 | 003 - Weekly Day Reversal | 🔴 gia' scartato nel dossier E |
| 43252 | Reversal Strategy | 🔴 primo taglio, nessuna tesi d'apertura |
| 60347 | Tuyul GAP | 🔴 lotto fisso, gap di **fine settimana su filtro giorno**, 13 input |
| 23223 | Gap DM | 🔴 **`InpStopLoss=0` di default + `InpMaxPositions=15`**: niente stop e accumulo |
| 21617 | Gaps | 🔴 **doppione di `ABTG_GapFill`** (vedi sotto) |
| 14346 | Exp_i-GAP | 🔴 **e' un indicatore**, non un EA (`#property indicator_chart_window`) |

### B. Il mirror, 1.185 sorgenti al grep — **la misura piu' netta della caccia**

| parola cercata | file che la contengono |
|---|---:|
| `retest` | **0** |
| `re-test` | **0** |
| `opening drive` | **0** |
| `gap continuation` | **0** |
| `failed breakout` | **0** |
| `first pullback` | **0** |
| `pullback` | **1** (`Pipsover 2`, e non e' un motore di pullback) |
| `gap` (parola intera) | 21, di cui **4 EA di gap veri** |

> 🔴 **Il buco che Claudio ha notato nei nostri dossier non e' un buco dei
> dossier: e' un buco del Code Base.** Il retest, che e' la meccanica su cui
> vive la nostra sedia migliore (DAX Apertura EU, win rate **81,0%**), non
> e' scritto da nessuna parte in 1.185 EA pubblici. Non e' una parola di
> moda: e' una cosa che quasi nessuno automatizza, perche' richiede una
> macchina a stati (arma → sorveglia → piazza il LIMIT) invece di una
> condizione booleana su una candela.
>
> **Questa e', da sola, una risposta alla domanda "perche' la nostra roba
> regge dove il Code Base non regge".**

### C. I quattro EA di gap del mirror, letti nel sorgente

| EA | direzione del gap | verdetto |
|---|---|---|
| `Gaps` (SFK Corp) | `open < low[1]` → **BUY** = **il gap si chiude** | 🔴 **doppione esatto di `ABTG_GapFill`**, e a lotto fisso |
| `Gap DM` (Хлыстов/barabashkakvn) | `close[1] − open ≥ gap` → **BUY** = si chiude | 🔴 **SL=0 di default**, fino a **15 posizioni** |
| `Tuyul GAP` | gap di fine settimana, filtro giorno=venerdi 23:15 | 🔴 lotto fisso, `SecureProfitTarget` in USD (non scalabile) |
| `Exp_i-GAP` | — | 🔴 indicatore |

> 🎯 **Zero implementazioni di gap in CONTINUAZIONE in tutto il Code Base.**
> Tutte e quattro sono gap-**fill**. Il che conferma che il candidato del
> dossier C (Nikkei 225 Gap Continuation) e' davvero raro — e che **non
> esiste un'implementazione alternativa da confrontarci**. Cercarla ancora
> sarebbe tempo buttato: questa riga chiude quella ricerca.

---

## 3. ✅ IL PROMOSSO ESTERNO — uno solo

### 🥇 `ADX Trend Pullback EA` — l'UNICO motore di pullback del Code Base

```
NOME            ADX Trend Pullback EA
FONTE / URL     https://www.mql5.com/en/code/73958
                sorgente: /en/code/download/73958/ADX_Trend_Pullback_EA.mq5
AUTORE / DATA   DVN CORE (mql5.com/en/users/wazatrader) - #property version 1.00,
                copyright 2026
LICENZA         non dichiarata nel sorgente oltre al #property copyright  [INCERTO]
RIGHE / INPUT   295 righe · 15 input (di cui 2 strutturali: magic, timeframe)

TESI IN UNA RIGA
  "Guadagna perche' in un trend che sta ACCELERANDO (ADX sopra 25 E in
   salita) il primo ritorno del prezzo sulla media di 20 e' liquidita'
   che entra dalla parte del trend, non un'inversione."

MECCANICA (righe 118-133, lette una per una)
  filtro    adx[1] > 25  AND  adx[1] > adx[2]           <- trend E accelerazione
  trigger   |close-EMA20|/ATR : bar[2] >= 0.5  ->  bar[1] < 0.5
            cioe' il prezzo era LONTANO e adesso e' TORNATO sulla media
  direzione +DI > -DI -> BUY   ·   -DI > +DI -> SELL
  uscita    SL = 1.5 x ATR(14)[1] · TP = 2.0 x SL  (mandati con l'ordine)

GESTIONE RISCHIO  🔴 **LOTTO FISSO 0.01** (riga 24) - §4, va sostituito
                  ✅ SL e TP VERI, mandati nella MqlTradeRequest (righe 261-262)
                  ✅ una sola posizione per volta (riga 237)

BANDIERE ROSSE   ✅ **NESSUNA nel motore.** Zero martingala, zero griglia,
                 zero hedge, zero #import, zero WebRequest, zero iCustom.
                 ✅ Zero repaint: TUTTI i CopyBuffer partono da shift **1**
                    (righe 90-102) e i close sono bar[1] e bar[2] (righe
                    105-106). Piu' `IsNewBar` in testa a OnTick (riga 226).
                 🔴 lotto fisso (unica bandiera vera)
                 🟡 **nessun `OnTester`** -> il nostro driver non parte

COSTO DI PORTING  0 ore di traduzione (e' gia' MQL5).
                  ~3-4 ore di riscrittura ABTG_: rischio %, OnTester, magic.

PUNTEGGIO
  [2] semplicita'          295 righe, 15 input, 6 manopole vere
  [2] il filtro E' il motore  ADX+DI non e' appiccicato: DEFINISCE la
                           direzione. Senza, l'EA non sa dove andare.
  [2] tesi scrivibile      vedi sopra
  [1] riempie un BUCO      🟢 e' **simmetrico vero** (`InpTradeDirection`
                           BOTH/BUY/SELL, i due rami sono lo specchio esatto)
                           -> il buco SHORT di R52.
                           🔴 ma **non e' un motore di apertura**: nessun
                           filtro di sessione, nessun orario. Vale 1, non 2.
  [1] testabile            serve un ABTG_ nuovo (OnTester + rischio %)
                           ------
                           **8 / 10 -> PROVA SUBITO per punteggio**
```

#### 🔬 Il difetto che ho trovato leggendo, e che l'autore non sa di avere

Riga 122, il commento dice:
> `// Pullback event: just touched EMA on bar[2], now away on bar[1]`

Il codice alla riga 125 dice **l'opposto**:
```
pullbackEvent = (dist1 < ratio) && (dist2 >= ratio)
```
`dist1` e' la barra **piu' recente**. Quindi la condizione e' "era LONTANO,
adesso e' TORNATO **sulla** media" — entra **sul tocco**, non dopo il
rifiuto. **Il commento e' invertito rispetto al codice.**

Non e' pignoleria: cambia la tesi. Come scritto, l'EA compra **nel** ritorno
(entrata da retest, quella che sul DAX ci paga); come commentato, comprerebbe
**dopo** la ripartenza (entrata da conferma, piu' cara). **Vale il codice.**
E' anche la prova che il sorgente e' stato letto davvero.

#### 🏛️ In ottica prop

**Favorevole.** Una sola posizione per volta (riga 237), niente piramidi,
SL sempre presente, R:R fisso 2.0. Su H1 il trigger e' raro: un pullback
sulla EMA20 con ADX in salita non capita ogni giorno. **Non concentra
perdite in una giornata**, che e' il muro che ci butta fuori (−5.000 su 100k)
prima del muro totale. Il difetto prop e' un altro: **a lotto fisso non e'
scalabile a 100k e non e' confrontabile con nulla di nostro** — e questo
si risolve nella riscrittura, non e' un limite del motore.

#### 🔴 E perche' NON prende il primo posto di questa caccia

**Perche' non e' un motore di apertura.** Non ha orari. Per puntarlo
sull'apertura del DAX (08:00 server) o del Nasdaq (14:30 server) bisognerebbe
**aggiungergli un filtro di sessione** — e nel nostro storico un filtro
aggiunto a un motore gia' tarato ha fatto **0 successi su 5** (R20, R12,
R26, R45, R54). Se entra, entra come **motore di trend simmetrico su H1**,
che e' un buco vero (R52) ma **e' un altro bersaglio**, non questo.

---

## 4. 🟡 IN CODA — `KSQ Fair Value Gap EA`

```
NOME       KSQ FVG EA with Regime Detection and Dual SL TP Mode
URL        https://www.mql5.com/en/code/71467
           sorgente: /en/code/download/71467/KSQ_FVG_EA.mq5
AUTORE     mql5.com/en/users/adiec7 · 949 righe · **53 input**

TESI       "Guadagna perche' uno squilibrio di 3 barre (low[i] > high[i-2])
            e' liquidita' non servita: quando il prezzo ci ritorna dentro,
            riparte nella direzione che l'ha creato."
           -> e' **il retest**, vestito da ICT. E' l'unica altra
              implementazione di retest che esiste nel Code Base.

✅ IL BUONO   - `rates[ratesTotal-2]` = ultima barra CHIUSA (riga 312).
                Nessun repaint sul trigger.
              - ha `LOT_RISK` con `InpRiskPercent` (righe 123-125, 474)
              - `InpSessionStartHour/EndHour` **gia' etichettati "Server Time"**
                (righe 135-136) -> puntabile sull'apertura senza inventare nulla

🔴 IL CATTIVO - **53 input.** Il nostro tetto e' ~15. §5.A: sopra quella
                soglia il backtest ha troppe manopole da girare verso il
                passato.
              - "Regime Detection" (EMA + ADX) e' **esattamente il filtro
                appiccicato** che ci ha fatto 0 su 5.
              - `InpMaxOpenTrades = 3` -> fino a 3 posizioni insieme.
                🏛️ **In ottica prop e' il difetto grave**: tre trade
                correlati la stessa mattina sono un rischio GIORNALIERO,
                non un edge diversificato (§7-bis punto 2).
              - `InpSessionEndHour` e' a granularita' **di ora**: il Nasdaq
                delle **14:30 server** non e' esprimibile. Solo 14:00.
              - nessun `OnTester`
              - 🟡 il filtro di regime legge `CopyBuffer(..., 0, 3, ...)`
                = **shift 0**, barra in formazione (riga 669). Non e'
                look-ahead (usa solo passato+presente) ma rende il
                backtest dipendente dal modello di tick: da dichiarare.

PUNTEGGIO  [0] semplicita' · [0] filtro E' il motore · [2] tesi ·
           [1] buco · [1] testabile  ->  **4 / 10 = SCARTO per punteggio**
VERDETTO   🟡 **IN CODA, non scartato.** Il MOTORE (lo squilibrio a 3 barre
           + ritorno dentro la zona) e' sano e sarebbe 2/2 da solo.
           Sono i 53 input e le 3 posizioni a bocciarlo, e sono
           **gestione**, non motore — cioe' la parte che sappiamo rifare.
           Va ripreso SOLO se il n.1 muore: prima si sfronda a ~8 input
           (via regime detection, via dual mode, 1 posizione), poi si misura.
```

---

## 5. 🔥 IL RISULTATO PIU' GROSSO DELLA CACCIA — e non e' un EA esterno

Prima di proporre qualunque cosa ho fatto il controllo di duplicazione
(§5.D: un candidato che fa la stessa cosa di una sedia viva vale poco).
Il controllo ha trovato altro.

### `ABTG_Nasdaq_Apertura_US` ha SEI motori d'apertura. Cinque sono misurati e morti. Il sesto ha PF OOS 1,94 e nessuno l'ha mai spazzolato.

`risultati_archivio/Walkforward_Aperture/NASDAQ_B_motore_OOS.csv`, tick
reali M5, rischio 1%, sessione **14:30 server**, RangeMode 0:

| `InpEntryMode` | Profit OOS | PF | DD % | n |
|---|---:|---:|---:|---:|
| **1 GAPFILL** | **+487,09** | **1,937** | **3,28** | **19** |
| 2 RETEST | +218,98 | 1,041 | 8,79 | 240 |
| 0 BREAKOUT | −281,55 | 0,949 | 9,60 | 244 |
| 5 OPENCONFIRM | −365,50 | 0,927 | 7,18 | 240 |
| 3 RANGE_FADE | −392,49 | 0,930 | 17,29 | 244 |
| 4 DELAYED | −615,74 | 0,890 | 12,18 | 247 |

**Il GAPFILL ha il PF piu' alto E il drawdown piu' basso dei sei.** Non e'
stato seguito perche' n=19. E il referto stesso, `REFERTO_FASE_B_C5.md`,
"Cosa fare adesso" punto 2, lo aveva scritto:

> _"GAPFILL: misura da rifare in grande, spazzolando `InpGapMinPoints` e
> `InpGapMinRR` per vedere se le occasioni salgono restando redditizie.
> Con 19 trade non si decide niente."_

✅ **Verificato il 16/08 su TUTTI i CSV dell'archivio: `InpGapMinPoints` e
`InpGapMinRR` hanno un solo valore ovunque (150 e 1.5). Quella spazzolata
non e' mai stata fatta.**

### E la meccanica NON e' il fade che R42 ha ucciso

Letta riga per riga (`ABTG_Nasdaq_Apertura_US.mq5`, 1423-1487):

- riga 1425-1429 — `gap = open D1 di oggi − close D1 di ieri`
- riga 1456 — **GAP UP → SELL STOP sotto il MINIMO della finestra d'apertura**
- riga 1471 — **GAP DOWN → BUY STOP sopra il MASSIMO**
- riga 1449 — TP = chiusura di ieri

Entra con uno **STOP dalla parte opposta al gap**: pretende che il gap
**prima fallisca**. E' un **failed opening drive**, non un fade — il fade
(motore 3, LIMIT sugli estremi) e' proprio quello che R42 ha bocciato
0 celle su 48 e che qui fa −392,49.

🎯 **Ed e' esattamente una delle parole del mandato: `failed breakout`.**

### ⚠️ Il limite meccanico che va detto ad alta voce

Il gap e' misurato su barre **D1** (righe 1425-1426). Su un CFD che gira
24/5 il gap D1 e' quasi sempre ~0: **questo motore intercetta in pratica il
gap del FINE SETTIMANA, non quello della campanella delle 15:30 IT.**
[INFERITO dalle righe 1425-1429] E' coerente con n=19 in nove mesi
(~2 al mese ≈ i lunedi' con un gap vero).

**Va scritto perche' e' il modo in cui l'ipotesi puo' morire**: se il motore
vive sui lunedi', allargare i cancelli non porta giornate nuove, porta solo
lunedi' peggiori.

### E qual e' il cancello che stringe davvero

Non la taglia: la **geometria**. `InpGapMinRR` confronta
`reward = distanza dalla chiusura di ieri` con
`risk = larghezza della finestra d'apertura + 2 buffer`. Chiedere RR ≥ 1,5
vuol dire chiedere **un gap grande almeno 1,5 volte l'apertura del Nasdaq**,
che e' larga. **Abbassare l'RR fa salire n piu' in fretta che abbassare i
punti** — ed e' per questo che la griglia proposta muove tutte e due.

### 🏛️ In ottica prop, e' il profilo migliore che abbia visto oggi

DD OOS **3,28%** contro il muro del 10%. Un solo ciclo al giorno
(`InpOneTradePerDay=1`). Frequenza bassissima. **Un motore che opera due
volte al mese non puo' sfondare il muro giornaliero dei −5.000**, e non
perde insieme a nulla di quello che gia' gira di giorno.
⚠️ **Il contro, dichiarato**: abbiamo gia' `ABTG_GapFill` su 225JPY (R36/R37,
5 celle vive). **Il gap del lunedi' e' un evento mondiale**: se questa passa,
il cumulo dei due va guardato con occhio cattivo (lezione R37, dove il cumulo
della riapertura ha bocciato una famiglia intera).

📄 **File prova:** `backtest_pipeline/prove/ABTG_Nasdaq_Apertura_US_GAP.txt`
— 24 celle, `@DAQUANDO 2024.09.26` **misurato** (lo stesso di R7a/R12 su
NASUSD M5, non inventato), tutti i pin copiati dalla riga vincente della
FASE B perche' altrimenti le celle nuove non sono confrontabili.

---

## 6. 🛑 UNA PORTA CHE HO CHIUSO — la coda ne esce piu' corta

`REFERTO_WALKFORWARD.md` (verdetto 2) e `REFERTO_FASE_D_C8.md` dicono
**tutti e due**, e sono ancora li':

> _"Resta una sola cosa mai misurata: `RangeMode=2`, la candela H1
> precedente, che e' quello che gira davvero in forward. **Prima di
> spegnere: provare RETEST e RangeMode 2.**"_

**È stato misurato. FASE L.** `NASDAQ_L_rangemode_*.csv`, `InpEntryMode=2`:

| RangeMode | IS Profit | PF | | OOS Profit | PF | DD % | n |
|---|---:|---:|---|---:|---:|---:|---:|
| **2 (candela H1 prec.)** | **+434,08** | **1,096** | → | **−2.444,14** | **0,665** | **26,29** | 321 |
| 1 (finestra prec.) | +106,12 | 1,020 | → | −1.600,74 | 0,798 | 17,35 | 329 |
| 0 (range apertura) | −261,87 | 0,928 | → | +107,19 | 1,022 | 7,88 | 301 |

> 🔥 **RangeMode 2 e' il MIGLIORE in campione e il PEGGIORE fuori
> campione**, con un DD del 26,3%. E' il ribaltamento numero **31**, e ha
> la firma esatta degli altri trenta.

**Quindi il Nasdaq d'apertura e' chiuso su tutti e sei i motori × tutti e
tre i RangeMode — tranne il GAPFILL, che e' l'unica casella verde.**
La nota "mai misurato" nei due referti e' **scaduta** e va corretta: chi la
legge oggi lancerebbe un round da 26% di drawdown.

📌 **Questo e' il secondo risultato della caccia: un round in meno da fare,
e una riga sbagliata in meno da mandare.**

---

## 7. ❌ GLI SCARTATI — una riga di motivo a testa

| cosa | motivo |
|---|---|
| `Session Opening Range Breakout EA` (76153) | ORB: ~210 celle a tick reali, "morto ovunque" |
| `GoldLondonBreakout` (75586) | = R45, 0 celle verdi su 48 |
| `003 - Weekly Day Reversal` (74137) | gia' scartato nel dossier E di oggi |
| `Nikkei 225 Gap Continuation` (75301) | gia' in casa (dossier C) |
| `Price Action Intraday` (68704) | 1.237 righe, 29 input, no `OnTester`: costo > valore atteso |
| `Reversal Strategy` (43252) | nessuna tesi d'apertura, primo taglio |
| `Gaps` (21617) | doppione esatto di `ABTG_GapFill` + lotto fisso |
| `Gap DM` (23223) | 🔴 `InpStopLoss=0` di default e fino a **15 posizioni** |
| `Tuyul GAP` (60347) | lotto fisso, target in USD assoluti: non scalabile a 100k |
| `Exp_i-GAP` (14346) | e' un **indicatore** |
| `Pipsover 2` (mirror) | unico file col termine `pullback`, ma non e' un motore di pullback |
| tutti gli `Exp_*_ReOpen` (mirror) | "ReOpen" = **riapertura di posizione**, non retest. Falso positivo di ricerca |

---

## 8. 📖 LA LETTERATURA — e qui c'e' il pezzo che vale piu' di un EA

### 🔬 arXiv **2605.04004** — Mathias Mesfin, 05/05/2026
**"Structural Limits of OHLCV-Based Intraday Signals in MNQ Futures:
A Systematic Falsification Study"**
`https://arxiv.org/abs/2605.04004` · **[VERIFICATO]** via API arXiv (https)

**MNQ = Micro E-mini Nasdaq-100 futures. E' il NOSTRO mercato.**
Metodo: **14 famiglie di segnali**, 947 giornate di dati a 5 minuti
(2021-2025), walk-forward fuori campione, T ≥ 2,0, ≥ 30 trade, costo di
frizione fisso di 2 punti andata-e-ritorno, coerenza fra anni.

**Nessuna delle 14 famiglie ha passato tutti i cancelli.** Il rendimento
lordo massimo prima dei costi sta fra **0,07 e 1,50 punti per trade**,
contro un costo di **2 punti**.

> 🎯 **Traduzione per noi: il momentum intraday da OHLCV sul Nasdaq sta
> SOTTO IL PAVIMENTO DEI COSTI.** E' una conferma indipendente, con un
> metodo dichiarato e su 947 giornate, delle nostre ~210 celle ORB + R42
> (0/48) + R45 (0/48) + R12 (48/48 negative). Non stavamo sbagliando a
> misurare: **non c'e' niente da misurare li'.**

#### 🔥 E poi c'e' la riga che riguarda esattamente il secondo bersaglio

> _"One signal family — **gap continuation short** — produces a T-statistic
> of 3,23 and a mean net return of **14,52 points** but on only **22 trades**
> across three years, falling below the minimum sample threshold and
> therefore failing deployment criteria."_

🔴 **Etichetta d'obbligo: numeri dichiarati dall'autore, NON verificati da
noi, su MNQ futures e non sul nostro CFD `NASUSD` di BCM, con un costo di
frizione (2 punti su futures) che non e' il nostro spread.** Non pesano sul
punteggio di nessuno (§7).

**Ma la LETTURA pesa, ed e' questa:** su quattordici famiglie provate con un
metodo severo, l'**unica** che e' arrivata positiva **al netto dei costi**
sul Nasdaq e' il **gap in continuazione, dal lato SHORT** — e l'autore l'ha
correttamente rifiutata solo perche' n=22 in tre anni.

Cioe':
1. il gap d'apertura e' l'unica cosa che sopravvive ai costi sul Nasdaq —
   **ed e' esattamente dove punta la nostra unica casella verde** (§5);
2. **la rarita' non e' un difetto del segnale, e' la sua natura**: ~7 trade
   l'anno li' , ~2 al mese da noi. Chi cerca frequenza qui non trova niente;
3. il lato e' **SHORT**, che e' il buco dichiarato di R52.

⚠️ **E la fregatura, dichiarata:** con n=22 su tre anni, **il nostro
cancello dei 15/30 trade per famiglia diventa il collo di bottiglia**. Su 21
mesi di BCM non ci arriviamo. Un motore di gap si giudica **su anni**, non
su una finestra OOS di nove mesi — ed e' un argomento in piu' per la prova
di regime su Dukascopy (2012→, quattordici anni), non per un giro in piu' su
BCM.

### Altro trovato, e onestamente meno utile
- `2507.04481` "Does Overnight News Explain Overnight Returns?" — pertinente
  alla tesi del gap, ma e' azionario US giornaliero: **cultura, non un
  candidato** (§3.A).
- `2006.08307` "Hidden Markov Models Applied To Intraday Momentum Trading" —
  🔴 e' proprio l'"EA che si adatta" che `report/ROBUSTEZZA.md` smonta con
  30 ribaltamenti. Non lo propongo.

---

## 9. 🕳️ COSA NON HO POTUTO VEDERE — dichiarato, non taciuto

1. **SSRN**: `HTTP 403`. **Fonte non raggiunta.** E' l'anti-bot del sito,
   non la nostra allowlist.
2. **Forex Factory**: non tentata dopo il 403 noto. **Non raggiunta.**
   E' la fonte che avrebbe risposto meglio alla domanda "come e' invecchiato
   un sistema di gap": resta un buco vero.
3. **Il PDF completo di arXiv 2605.04004**: ho letto **solo l'abstract**
   via API. Non so quali siano le 14 famiglie, ne' come sia definito
   operativamente il "gap continuation short". **[INCERTO]** — e prima di
   scriverne un EA quel PDF va letto.
4. **Il Code Base oltre pagina 30**: 1.200 EA su un totale che non ho
   contato. Ho coperto le pagine piu' recenti; gli EA piu' vecchi di
   `id ~14000` sono nel mirror, quelli in mezzo li ho visti solo li'.
5. **Licenze**: nessuno dei tre sorgenti scaricati dichiara una licenza
   oltre al `#property copyright`. **[INCERTO]** — attribuzione obbligatoria
   in testa a qualunque `.mq5` derivato.
6. **Quantpedia / QuantConnect**: non usate. La caccia aveva gia' una pista
   forte e ho preferito scavarla che allargare.

---

## 10. ❓ LA DOMANDA A CUI IL PRIMO TEST DEVE RISPONDERE

> **"Il +487,09 con PF 1,937 e DD 3,28% del gap d'apertura sul Nasdaq e' un
> edge, o sono 19 trade fortunati?"**
>
> Si risponde in un modo solo: allargando i due cancelli finche' n arriva a
> 30+, e guardando se il PF resta sopra 1,10 **in una REGIONE di celle
> adiacenti** e non in una cella isolata.
>
> Se il PF regge con n≥30 → e' il primo motore d'apertura nuovo dai tempi
> del DAX, con il DD piu' basso dell'arsenale e una frequenza che il muro
> giornaliero della prop non puo' toccare.
>
> Se il PF crolla appena n sale → **il gap d'apertura del Nasdaq e' chiuso,
> e con lui l'ULTIMA casella verde delle aperture Nasdaq.** Anche questo e'
> un verdetto, ed e' quello che chiude la linea per sempre invece di
> lasciarla a mezz'aria come e' oggi.

---

## 11. 🚀 LA RIGA DI LANCIO PROPOSTA

Passata dai quattro controlli di `CHECKLIST_RIGA_DI_LANCIO.md`:

1. ✅ **Ho aperto lo script**: `walkforward_generico.ps1`, riga 65 —
   `-Modello 4 = tick reali`, `1 = OHLC M1 solo screening`. La FASE B che
   giustifica questo round e' **a tick reali**: quindi **Modello 4**, o i
   numeri non si confrontano.
2. ✅ **Difetti gemelli**: nessuna correzione fatta oggi su questi script.
3. ✅ **Il file e' quello giusto**: questa riga **CERCA** (24 celle) e il
   file e' una griglia. Coerenti. (L'errore R58 era l'opposto.)
4. 🔴 **SHA: NON lo scrivo.** Il file prova e' appena stato creato e **non e'
   ancora committato** — e non eseguo comandi git. **La riga va rigenerata
   con lo SHA vero dopo il commit**, oppure con `HEAD`. Un SHA inventato qui
   sarebbe esattamente l'errore del 15/08.

⚙️ **UNA MACCHINA, UN LAVORO**: apre MT5 sul PC di backtest. Prima di
mandarla, dichiarare che non c'e' un'altra corsa viva.

```
# giro a vuoto (deve stampare: spazzolati 24 celle)
powershell -ExecutionPolicy Bypass -File "$env:USERPROFILE\walkforward_generico.ps1" `
  -Expert ABTG_Nasdaq_Apertura_US `
  -Prova "$env:USERPROFILE\ABTG_Nasdaq_Apertura_US_GAP.txt" `
  -Modello 4 -Deposito 100000 -Etichetta gapnas -SoloControllo
```

✅ Deve stampare **`spazzolati: 24`**, `InpGapMinPoints 6 celle`,
`InpGapMinRR 4 celle`, e **`InpSessionHour 14`**.
🛑 Se stampa `InpSessionHour 15` → ora italiana invece di ora server:
**fermarsi e cestinare** (regola fissa di `CLAUDE.md`).

---

## 12. 📎 ATTRIBUZIONI, da riportare in testa a qualunque `.mq5` derivato

| origine | da citare |
|---|---|
| `ADX Trend Pullback EA` | DVN CORE — `https://www.mql5.com/en/users/wazatrader` · `mql5.com/en/code/73958` |
| `KSQ FVG EA` | adiec7 — `https://www.mql5.com/en/users/adiec7` · `mql5.com/en/code/71467` |
| tesi del gap continuation short | Mathias Mesfin, arXiv:2605.04004 (2026) |

---

## 13. 📊 IL CONTO DELLA CACCIA

| | |
|---|---:|
| pagine di elenco Code Base sfogliate | **30** |
| EA visti a titolo | **1.200** |
| sorgenti del mirror passati al grep | **1.185** |
| occorrenze di `retest` nei due insiemi | **0 e 0** |
| candidati arrivati alla lettura del sorgente | **3** |
| promossi (esterni) | **1** — `ADX Trend Pullback EA`, 8/10 |
| in coda (esterni) | **1** — `KSQ FVG`, 4/10 ma motore sano |
| paper letti nell'abstract | **4**, di cui **1 decisivo** |
| **round aperti** | **1** — la spazzolata del gap Nasdaq |
| **round CHIUSI** (porte sbarrate) | **1** — RETEST × RangeMode 2 |
| file prova consegnati | **1** |
