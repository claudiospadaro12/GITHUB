# 🎯 CACCIA I — MIGLIORIE A `SupertrendReversal`

_16/08/2026 · cacciatore-strategie · branch `lavoro`_
_Bersaglio: **varianti STRUTTURALI** della meccanica Supertrend, testabili
come **cella nuova**. NON filtri da appiccicare alle sedie vive._

---

## 0. LA RIGA CHE CONTA

> **Su 27 candidati guardati su 5 fonti, 7 sono arrivati al sorgente (o al
> paper), 3 li proverei — e il primo e' il `Pivot Supertrend`, perche' e'
> l'unica cosa trovata che cambia il MOTORE (la base di calcolo passa dal
> punto medio dell'ultima candela alla STRUTTURA di swing) invece di
> aggiungere una condizione al motore che gia' abbiamo.**

E la cosa piu' utile della caccia **non e' un candidato**: e' che leggendo le
implementazioni altrui ho trovato **due cose che non sapevamo del NOSTRO
Supertrend** (§6). Una delle due va verificata prima di qualunque round nuovo.

---

## 1. IL VINCOLO, RIPETUTO — e come l'ho applicato

`report/ROBUSTEZZA.md` misura:

| | esito |
|---|---|
| filtro **aggiunto dopo** a un motore gia' tarato | **0 su 5** (R20, R12, R26, R45, R54) |
| filtro che **E' la strategia** dall'inizio | **il miglior risultato del progetto** (R29: 30/30) |

Quindi ho tenuto **una sola domanda** davanti a ogni candidato:

> _"Questo cambia la DEFINIZIONE di trend/inversione/uscita — cioe' e' un
> motore diverso — oppure aggiunge una CONDIZIONE a quello che gira gia'?"_

Il secondo caso e' scarto **anche quando sembra buono**. Ne ho scartato uno
proprio cosi' (§4, il "ritardo di conferma"), ed era il piu' seducente.

⚠️ Nessuna delle proposte qui dentro tocca un parametro in forward. Tutte
nascono come **EA nuovo, magic nuovo, imbuto da zero**, in parallelo agli
originali (regola di casa `CLAUDE.md`: gli `_Ottimizzato` girano accanto, non
al posto).

---

## 2. COSA HO SFOGLIATO, FONTE PER FONTE — con il controllo positivo

| fonte | controllo positivo | esito | visti |
|---|---|---|---|
| **MQL5 Code Base** `/en/code/mt5/experts` + `/indicators` | ✅ la lista rende titoli e ID veri (es. 76165 ProAutoSL, 75110 Pivot SuperTrend) | 🟢 **usata, la piu' produttiva** | ~120 titoli sfogliati (elenco experts p.1, indicators p.1-2) + 6 schede aperte |
| **arXiv / export.arxiv.org** | ✅ API risponde, restituisce titoli+autori+date reali | 🟢 usata, **resa quasi nulla** su questo bersaglio | 3 query, ~25 abstract |
| **TradingView** | ✅ 200, script "open source" visibili | 🟡 usata solo per **risalire all'origine** del Pivot Supertrend | ~10 script |
| **GitHub** | ✅ 200, repo veri | 🟡 usata, **valore inferiore** al Code Base (vedi §5) | ~10 repo |
| **SSRN** | ❌ **403 Cloudflare** | 🔴 **NON RAGGIUNTA — dichiarata** | 0 |
| **Forex Factory** | ❌ **403 Cloudflare** | 🔴 **NON RAGGIUNTA — dichiarata** | 0 |
| **Quantpedia / QuantConnect** | non interrogate | ⚪ il bersaglio (meccanica di un indicatore) non e' la loro resa | 0 |

### 📌 CORREZIONE UTILE ALLE PROSSIME CACCE — la ricerca MQL5 si puo' fare

Il briefing (dalla caccia F) diceva: _"`WebSearch site:mql5.com/en/code` rende
quasi zero — funziona solo lo sfoglio diretto"_.

**Misurato oggi: e' vero con l'operatore `site:`, ed e' FALSO con
`allowed_domains:["mql5.com"]`.** La stessa domanda posta con il filtro di
dominio invece che con `site:` ha reso **6 bersagli centrati al primo colpo**
(72345, 57063, 72110, 15239, e i due articoli). Lo sfoglio pagina-per-pagina
degli elenchi resta utile per il **caso** (Pivot Supertrend l'ho trovato
sfogliando, non cercando), ma non e' piu' l'unica strada.

⚠️ **Restano fuori perimetro permanente** (§3.B del mandato): `/market/` e
`/signals/`. E qui la regola ha pagato: le versioni "Supertrend + conferma
timeframe superiore" **esistono tutte li'** (PZ Super Trend, AW Super Trend,
Supertrend G5, Double SuperTrend) — **senza sorgente, quindi non leggibili e
non setacciabili**. In piu' sono comunque della forma sbagliata: PZ vende
_"D1 Filter to true"_, cioe' un filtro HTF **opzionale** = esattamente la
sagoma 0-su-5. Non e' una perdita.

---

## 3. ✅ I PROMOSSI — 3, tutti "CELLA NUOVA"

### 🥇 CANDIDATO 1 — `Pivot Supertrend`: la base di calcolo diventa la STRUTTURA

```
NOME            Pivot SuperTrend (BhanuCodeLab)
FONTE / URL     https://www.mql5.com/en/code/75110
AUTORE / DATA   Bhanu Chandra Raju Indukuri — 19/07/2026        [VERIFICATO]
ORIGINE IDEA    "Pivot Point Supertrend" — LonesomeTheBlue, TradingView,
                open source: https://www.tradingview.com/script/L0AIiLvH-Pivot-Point-Supertrend/
                (esiste anche la versione [Backtest]: .../DwdC6FT4-)   [VERIFICATO]
LICENZA         download gratuito, termini non dichiarati in pagina   [INCERTO]
RIGHE / INPUT   1.073 righe · 3 input di motore (radius, mult, periodo ATR)
                + 20 cosmetici (colori/alert)                    [VERIFICATO, contati]
```

**TESI IN UNA RIGA**
> _"Il nostro Supertrend ricentra la banda sul **punto medio dell'ultima
> candela**; questo la ancora alla **struttura di swing**. Guadagna dove il
> nostro perde: nelle sessioni disordinate degli indici, dove hl2 balla con
> ogni candela e il flip chiude il runner per rumore, non per fine trend."_

**MECCANICA — la differenza vera, letta nel sorgente**

| | il NOSTRO (`ABTG_SupertrendReversal.mq5:361`) | il Pivot Supertrend (`:775-800`) |
|---|---|---|
| base della banda | `hl2 = (high[i]+low[i])/2` — **l'ultima candela** | `center = (2*center_prec + pivot_nuovo)/3` — **media pesata dei pivot di swing CONFERMATI** |
| quando la base si muove | **ogni barra** | **solo quando si conferma un nuovo pivot** |
| bande | `hl2 ± mult*ATR` | `center ± mult*ATR` (ATR c'e' eccome) |
| ratchet + flip | identici (canonici) | identici (canonici) |

🔴 **Attenzione a una fonte secondaria sbagliata:** il sommario TradingView
dice _"Pivot Points are used **instead of ATR**"_. **E' falso.** Nel sorgente
MQL5 che ho letto l'ATR c'e' (`bclRawUpperBand = center − mult*ATR`,
righe 833-840). Il pivot sostituisce **hl2**, non l'ATR. Ho tenuto il codice,
non il blurb.

**🔬 CONTROLLO REPAINT / LOOK-AHEAD — fatto, ed e' la verifica che conta**

Il sospetto ovvio su un indicatore a pivot e' che guardi avanti. **Non lo fa**:

- il pivot valutato alla barra `bar` e' quello della barra `bar − radius`
  (`:753`);
- `BclIsConfirmedPivotHigh` guarda `candidate ± radius` (`:119-146`), cioe'
  al massimo fino a `bar`.

> ✅ **[VERIFICATO sul codice]: non legge nessuna barra futura.** Il prezzo da
> pagare non e' il look-ahead, e' il **ritardo**: il pivot si sa `radius`
> barre dopo. A `radius=2` su H2 sono 4 ore. E' un costo dichiarato, non un
> baco — ed e' proprio il ritardo che rende la linea meno nervosa.

**GESTIONE RISCHIO** — n/a: e' un **indicatore**, non un EA. E va benissimo
cosi': la gestione (rischio %, parziale 1R, BE, runner) ce l'abbiamo gia' ed
e' la parte che sappiamo fare (§5.F del mandato).

**BANDIERE ROSSE §4** — **nessuna.** Niente martingala, niente griglia, niente
`iCustom` esterno, niente DLL/WebRequest, nessun ordine (non ne manda).

**COSTO DI PORTING — basso, ed e' il suo punto di forza**
Il nostro EA **non usa un indicatore esterno**: si calcola il Supertrend
dentro, in `SupertrendSeries()` (`ABTG_SupertrendReversal.mq5:346-375`, **18
righe utili**). La variante e' sostituire la riga della base (`:361`) con il
centro-pivot + il rilevatore di pivot. **Stimate 3-4 ore** a
`mql5-ea-developer`, EA nuovo. ⚠️ Non l'ho toccato io: non e' il mio mestiere.

**PUNTEGGIO**
- [2] semplicita' — 3 input di motore contro i nostri 52 (§6.B)
- [2] il filtro **E' il motore** — non aggiunge condizioni: **ridefinisce cos'e' il trend**
- [2] tesi di mercato scrivibile — si', ed e' falsificabile
- [1] riempie un buco — 🟡 onesto: e' **lo stesso buco** delle celle STREV vive, ma con una geometria che nessuna nostra cella ha (nessun motore nostro si ancora ai pivot di swing)
- [2] testabile senza riscritture — pipeline nostra, sweep nostro, prova gia' scritta

**VERDETTO: 9/10 → 🟢 PROVA SUBITO** · **si testerebbe come CELLA NUOVA**

**🏛️ In ottica prop:** il ritardo del pivot **riduce il numero di flip**, e nel
nostro EA il flip e' un'**uscita** (`InpExitOnFlip`, `:177-178`). Meno flip =
meno uscite per rumore = **meno trade e piu' lunghi**. Effetto atteso sul DD:
🟢 favorevole sulla frequenza (punto 2 del §7-bis: meno trade correlati nella
stessa giornata), 🔴 sfavorevole sulla **peggior giornata** (posizioni tenute
piu' a lungo = piu' esposizione a un gap contro). **Va misurata la giornata
peggiore, non solo il DD totale** — e' il muro che butta fuori col totale
intatto.

---

### 🥈 CANDIDATO 2 — flip sul **wick** invece che sulla **chiusura**

```
NOME            Supertrend
FONTE / URL     https://www.mql5.com/en/code/57063
AUTORE / DATA   Salman Soltaniyan — 15/03/2025                    [VERIFICATO]
POPOLARITA'     48.776 visualizzazioni · 4,9/5 su 64 voti         [VERIFICATO]
LICENZA         **MIT** (dichiarata nel sorgente, riga 242)       [VERIFICATO]
RIGHE / INPUT   ~250 righe · 4 input                              [VERIFICATO]
```

**TESI IN UNA RIGA**
> _"Il nostro Supertrend decide TUTTO sulla chiusura. Questo lascia scegliere
> se l'inversione la fa l'**ombra**: su indici a ombre lunghe (DAX/Nasdaq H1)
> le due definizioni di 'trend finito' non sono la stessa cosa, e noi ne
> abbiamo misurata una sola."_

**La riga che lo prova** (`supertrend.mq5:149-150`, `:201-204`):
```cpp
highPrice = TakeWicksIntoAccount ? high[i] : close[i];
lowPrice  = TakeWicksIntoAccount ? low[i]  : close[i];
...
if(supertrend_dir == -1 && highPrice > shortStopPrev)      // flip a rialzo
else if(supertrend_dir == 1 && lowPrice  < longStopPrev)   // flip a ribasso
```
Contro il nostro (`ABTG_SupertrendReversal.mq5:368-369`):
```cpp
if(r[i].close > (dir==-1?prevFU:fU))      dir=+1;
else if(r[i].close < (dir==+1?prevFL:fL)) dir=-1;
```

> **[VERIFICATO] Il nostro e' un Supertrend interamente a chiusura.** La
> variante a wick flippa **prima e piu' spesso**. Non e' una manopola in piu':
> e' l'altra definizione della stessa cosa, e cambia insieme **ingresso**
> (`d1==d2`, `:190-191`) **e uscita** (`InpExitOnFlip`).

Espone anche `SourcePrice` (default `PRICE_MEDIAN` = il nostro hl2, ma con
`PRICE_TYPICAL`/`PRICE_CLOSE` selezionabili) — l'asse "mediana vs close" del
mandato, **confermato che esiste e che gli autori seri lo parametrizzano**.

**BANDIERE ROSSE** — nessuna (indicatore puro, MIT, nessun ordine).
**COSTO DI PORTING** — **1-2 ore**: due righe in `SupertrendSeries()`.

**PUNTEGGIO** [2] semplicita' · [2] e' il motore · [2] tesi · [0] buco (non ne
riempie nessuno nuovo) · [2] testabile → **8/10 → 🟢 PROVA** ·
**CELLA NUOVA** (ridefinisce l'inversione, quindi ingresso e uscita insieme).

**🏛️ In ottica prop:** flip anticipato = **runner tagliati prima** = giveback
minore ma piu' whipsaw. Direzione attesa: DD totale 🟢 giu', numero di trade
🔴 su. Il rischio prop qui e' la **concentrazione giornaliera** (piu' trade
nella stessa seduta), da guardare esplicitamente.

---

### 🥉 CANDIDATO 3 — trailing **Chandelier** invece che sulla linea Supertrend

```
NOME            Chandelier exit
FONTE / URL     https://www.mql5.com/en/code/19875
AUTORE / DATA   Mladen Rakic — 30/01/2018                         [VERIFICATO]
POPOLARITA'     37.603 visualizzazioni · 4,9/5 su 188 voti        [VERIFICATO]
LICENZA         non dichiarata in pagina                          [INCERTO]
```

**TESI IN UNA RIGA**
> _"Noi trasciniamo lo stop sulla **linea dell'indicatore**; il Chandelier lo
> trascina dal **massimo raggiunto dal trade** (`max(N) − k*ATR`). Sono due
> stop-loss diversi: uno segue la banda, l'altro segue il profitto migliore."_

**Perche' ci riguarda davvero:** il nostro EA fa gia' **meta'** di questa cosa
senza dirlo. Alla riga `:248`:
```cpp
double sl = isLong ? MathMin(stLine,ext)-buf : MathMax(stLine,ext)+buf;
```
`ext` e' il minimo/massimo delle ultime `InpSLLookback=5` barre — cioe' **un
Chandelier senza il termine ATR**, e usato **solo all'ingresso**. Il trailing
successivo (`:334-338`) e' invece **solo** sulla linea Supertrend. La variante
e' rendere la geometria **una sola e coerente** per tutta la vita del trade.

**PUNTEGGIO** [2] semplicita' · [1] e' il motore — 🟡 **onesto: e' l'uscita,
non l'ingresso; e' la piu' vicina delle tre a essere una manopola** · [2] tesi
· [1] buco · [2] testabile → **8/10 → 🟡 PROVA, ma TERZA** · **CELLA NUOVA**
(cambia la geometria dell'uscita per tutta la posizione, non aggiunge una
condizione d'ingresso).

**🏛️ In ottica prop:** e' l'unica delle tre che agisce **direttamente sul
drawdown**, che e' la valuta della prop. Il Chandelier stringe piu' in fretta
della linea Supertrend dopo un'escursione favorevole → attesa 🟢 sul DD e sulla
peggior giornata, 🔴 sul PF (piu' uscite premature). ⚠️ E' anche la forma che
il **DD trailing** di certe prop premia: meno "ritorni dal picco".

---

## 4. ❌ GLI SCARTATI — con il motivo, uno per riga

### 4.a Scartati perche' **sarebbero una PATCH su una sedia viva**

| idea | dove l'ho trovata | perche' si scarta |
|---|---|---|
| **Ritardo di conferma di N barre sul flip** | MQL5 art. 23541, _"optional confirmation bars"_ | 🔴 **Il piu' seducente della caccia, e va buttato.** E' una **condizione aggiuntiva** su un motore tarato: taglia trade senza cambiare la definizione di trend. E' la firma esatta di **R26** — _il filtro alza il PF a 2,37, abbassa il DD a 2,59% e fa crollare il profitto da 1.811 a 1.138_. 0 su 5. |
| **Filtro timeframe superiore (D1 conferma H1)** | PZ Super Trend EA, AW Super Trend, Supertrend G5 (`/market/`) | 🔴 doppiamente fuori: **niente sorgente** (perimetro permanente) **e** forma sbagliata — e' un filtro **opzionale** appiccicato, non un secondo TF costitutivo |
| **Moltiplicatore ATR che si restringe sulla divergenza** | MQL5 art. 23541, `finalMultiplier = mult * (1 − DivSensitivity)` | 🔴 parametro **adattivo**: una manopola in piu' che il backtest gira verso il passato (`ROBUSTEZZA` §2) |

### 4.b Scartati nel merito

| candidato | fonte | motivo — una riga |
|---|---|---|
| **Machine Learning Supertrend** | [72110](https://www.mql5.com/en/code/72110) · homirana · 19/04/2026 · 19.793 visual. · 5/5 | 🔴 **4 sottosistemi ML che ritarano 5 parametri _barra per barra_** (larghezza banda, smoothing ATR, distanza stop, TP, buffer) **sull'esito dei propri trade passati**. E' il contrario esatto dei nostri 30 ribaltamenti: overfitting in diretta, dentro l'EA. + 66 KB → costo di validazione sopra il valore atteso. |
| **Exp_SuperTrend** | [15239](https://www.mql5.com/en/code/15239) · Nikolay Kositsin · 30/06/2016 · 16.292 visual. | 🔴 **DOPPIONE: ce l'abbiamo gia'.** E' "entra sul flip", che e' `mql5/Experts/ABTG_SupertrendInvert.mq5` (documento "SUPERTREND INVERT", flip H1 + EMA50/200 + ADX + Stocastico). Nessuna bandiera rossa, sorgente incluso — ma nulla da imparare. |
| **The Adaptive SuperTrend EA** | [art. 23541](https://www.mql5.com/en/articles/23541) · sorgente libero 24 KB | 🔴 vedi 4.a: adattivo sul moltiplicatore + ingresso sul flip (doppione di `SupertrendInvert`) |
| **Custom Indicator Workshop (Pt.2): Practical Supertrend EA** | [art. 20908](https://www.mql5.com/en/articles/20908) | 🟡 **non scarto, ma nulla di nuovo**: ingresso sul flip (doppione) e `timeframe` input = quello che gia' fa il nostro `InpTF`. Utile solo per una conferma: elenca **tre** geometrie di stop (nessuna / estremo di swing / banda Supertrend) — e noi usiamo **la piu' protettiva delle due**, che li' non e' contemplata |
| **Bayesian Optimization of Supertrend Parameters** | [arXiv 2405.14262](https://arxiv.org/abs/2405.14262) · Abdul Rahman · 23/05/2024 | 🔴 ottimizza **periodo ATR e moltiplicatore** su "diverse stock datasets" — cioe' **esattamente cio' che facciamo gia'**, e con il problema che conosciamo: **12 Spearman IS→OOS negative su 13**. Zero meccanica nuova. L'abstract non riporta nemmeno una conclusione sulla sensibilita'. **Cultura, non candidato.** |
| **Optimal Trading with a Trailing Stop** | [arXiv 1701.03960](https://arxiv.org/abs/1701.03960) · Leung & Zhang · 14/01/2017 | 🟡 teoria di optimal stopping su Ornstein-Uhlenbeck esponenziale: non traducibile su un simbolo/TF che abbiamo. **Un solo pezzo utile e gratis:** dimostra l'ottimalita' di **trailing stop + ordine limite insieme** — cioe' la forma che il nostro parziale-1R + runner ha gia'. **Conferma, non candidato.** |
| **Repo GitHub Supertrend** (fmzquant/strategies, ntalegeofrey, YavuzAkbay, Adonis2115, PeetCrypto/freqtrade) | GitHub | 🟡 sono **reimplementazioni Python degli stessi script TradingView**, incluso il Pivot Point Supertrend. Costo (riscrittura Python→MQL5) **superiore** al Code Base, che la stessa idea ce l'ha gia' in `.mq5`. Nessuno aggiunge meccanica. |
| **PZ / AW / Supertrend G5 / Double SuperTrend Fit / MSX AI SuperTrend** | `mql5.com/en/market/...` | 🔴 **`/market/` — perimetro permanente**: compilati, a pagamento, senza sorgente. Il setaccio §4 non e' applicabile. |

---

## 5. 🕳️ COSA NON HO POTUTO VEDERE — dichiarato

1. **SSRN** e **Forex Factory**: **403 Cloudflare**, non raggiunte. Su Forex
   Factory in particolare perdiamo la cosa che vale di piu' (§3.E): i thread
   lunghi anni che raccontano **come una strategia Supertrend e' invecchiata**.
   Resta un buco vero di questa caccia.
2. **Licenza** di `Pivot SuperTrend` (75110) e di `Chandelier exit` (19875):
   non dichiarate in pagina. **[INCERTO]** — da chiarire prima di derivarne un
   `.mq5`, e l'autore va citato in testa al file comunque (§9).
3. **Numeri di download** esatti: le pagine del Code Base espongono
   *visualizzazioni*, non download. Ho riportato quelle, etichettate.
4. La **ricerca interna** di MQL5 resta inutilizzabile; ho lavorato con
   sfoglio + `allowed_domains` (§2).

---

## 6. 🔬 DUE COSE CHE HO SCOPERTO SUL **NOSTRO** SUPERTREND — e non erano nel mandato

Leggendo le implementazioni altrui per confronto sono usciti due fatti che
riguardano l'EA piu' diffuso dell'arsenale. **Non sono proposte: sono misure.**

### A. 🔴 NON SAPPIAMO CHE ATR STA USANDO IL NOSTRO SUPERTREND — e cambia i numeri

L'indicatore [`Super Trend` (72345)](https://www.mql5.com/en/code/72345)
(homirana, 25/04/2026, 10.270 visual.) esiste **apposta** per offrire due
calcoli alternativi: _"the standard iATR function built into the MQL5 library,
**and a manual Simple Moving Average of True Range**"_. Un autore non mette
quell'interruttore per capriccio.

Il nostro `SupertrendSeries()` usa `hAtr = iATR(...)` (`:121`, `:353`).

> ⚠️ **[INCERTO, e va sciolto]** — Il Supertrend di riferimento (Pine
> `ta.atr`) usa lo smoothing di **Wilder (RMA)**, la cui memoria effettiva e'
> ~`2N−1`: con `InpStAtrPeriod=10` sarebbe una finestra di volatilita' da
> **~19 barre**, non 10. Se invece l'`iATR` di MT5 fa una **SMA del True
> Range**, la banda respira su 10 barre e **tutte le nostre celle "Supertrend
> 10/3.5" non sono la ricetta che crediamo**, e non sono confrontabili con
> nessun riferimento TradingView.
>
> 🎯 **Non e' un round: e' un controllo da mezz'ora.** Si stampa `iATR` contro
> un Wilder calcolato a mano sulle stesse barre e si guarda se coincidono.
> **Va fatto prima** di lanciare qualunque variante di questa caccia,
> altrimenti confrontiamo motori su una base che non conosciamo.
> _(Non l'ho eseguito io: richiede il tester, e non tocco EA nostri.)_

### B. 🟡 IL NOSTRO STREV HA **52 INPUT** (42 non cosmetici)

Contati: `grep -c '^input ' ABTG_SupertrendReversal.mq5` → **52**. Il §5.A
mette il tetto a **~15 liberi**, e i tre candidati di oggi ne hanno 3, 4 e 4.

Non e' un'accusa — la maggior parte sono pinnati al default dal driver, e
molti sono il blocco notizie. Ma e' il motore **piu' diffuso** dell'arsenale
ed e' anche il **piu' pieno di manopole**: la "sfrondatura degli input" e' una
delle rifiniture che il §5.F dice che sappiamo fare, e su questo EA non e'
mai stata fatta. **Segnalato, non proposto.**

---

## 7. 📊 LA TABELLA CHIESTA — **cella nuova vs patch**, ogni idea trovata

| # | idea trovata | classificazione | esito |
|---|---|---|---|
| 1 | **Base della banda = pivot di swing** invece di hl2 (Pivot Supertrend) | 🟢 **CELLA NUOVA** — ridefinisce cos'e' il trend | ✅ **PROVA SUBITO** |
| 2 | **Flip su wick** invece che su chiusura (`TakeWicksIntoAccount`) | 🟢 **CELLA NUOVA** — ridefinisce l'inversione | ✅ prova |
| 3 | **Trailing Chandelier** (`max(N) − k·ATR`) invece che sulla linea ST | 🟢 **CELLA NUOVA** — ridefinisce l'uscita | ✅ prova, terza |
| 4 | **Base `PRICE_TYPICAL`/`PRICE_CLOSE`** invece di mediana | 🟢 CELLA NUOVA | 🟡 in coda: variante minore del n.2, stesso file |
| 5 | **SMA del True Range** invece di `iATR` | 🟢 CELLA NUOVA | ⏸️ **bloccato dal controllo §6.A** — prima si misura cosa usiamo |
| 6 | **Ritardo di conferma di N barre** sul flip | 🔴 **PATCH** — condizione in piu' su motore tarato | ❌ **SCARTATA** (firma R26) |
| 7 | **Filtro D1 sul segnale H1** (PZ/AW/G5) | 🔴 **PATCH** — filtro HTF opzionale | ❌ scartata (+ `/market/`, niente sorgente) |
| 8 | **Moltiplicatore ATR adattivo** su divergenza | 🔴 **PATCH** — parametro adattivo | ❌ scartata |
| 9 | **Parametri ottimizzati con Bayesian Optimization** | 🔴 **ne' l'una ne' l'altra** — e' ritaratura | ❌ scartata (Spearman 12/13 negative) |
| 10 | **ML che ritara 5 parametri barra per barra** | 🔴 **PATCH permanente e automatica** | ❌ scartata |
| 11 | **Ingresso sul flip** (Exp_SuperTrend, art. 20908, art. 23541) | ⚪ CELLA NUOVA ma **gia' nostra** | ❌ doppione di `ABTG_SupertrendInvert` |

> **5 celle nuove, 5 patch, 1 doppione.** E le patch le abbiamo buttate tutte
> — inclusa quella che sembrava la migliore.

---

## 8. ❓ LA DOMANDA A CUI IL PRIMO TEST DEVE RISPONDERE

> **"Ancorare la banda del Supertrend alla STRUTTURA di swing invece che al
> punto medio dell'ultima candela cambia il comportamento FUORI CAMPIONE
> della stessa identica meccanica di rimbalzo — su un simbolo dove abbiamo
> gia' una misura STREV di riferimento?"**

Non _"guadagna di piu'?"_. La domanda e' **se la geometria della base conta**,
e si risponde solo con un confronto testa-a-testa contro una cella misurata.

**Perche' 225JPY H2 come primo banco:** e' la cella STREV con la misura
migliore che abbiamo (**DD OOS 0,88% · PF 1,653**, `ROTTA_PROP` riga 1) ed e'
il candidato prop n.1 — quindi il paragone e' contro il metro piu' severo, non
il piu' comodo. Gira gia' **LONG + SHORT** (R52 cella 4), quindi non c'e' un
lato mancante che confonde il confronto.

⚠️ Il confronto e' **di backtest**. Se poi passasse, la regola di rotta del
§7-bis punto 3 vale intera: **mai due EA sullo stesso simbolo/segnale a
rischio pieno** — o sostituisce, o va su un simbolo diverso, non accanto.

**File prova:** `backtest_pipeline/prove/ABTG_PivotSupertrendReversal.txt`
(ipotesi e criteri congelati **prima** di qualunque numero).

---

## 9. 🛑 COSA NON HO FATTO — per contratto

- **Nessun comando git.**
- **Nessun EA nostro modificato o creato.** I tre candidati sono descritti
  perche' `mql5-ea-developer` possa scriverli; `ABTG_SupertrendReversal.mq5`
  e le sue varianti sono **intatti**.
- **Nessun parametro in forward toccato.** Le celle STREV vive girano come
  sono, e questa caccia non propone di cambiarne nessuna.
