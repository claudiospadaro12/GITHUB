# 🎯 CACCIA L — MIGLIORIE A `ABTG_PTE` e `ABTG_EMA200`

_16/08/2026 · cacciatore-strategie · branch `lavoro`_
_Bersaglio: le due sedie piu' collaudate del progetto. Barra la piu' alta._

---

## 🔴 LA RIGA DEL §8.3 — leggila prima di tutto il resto

> **Su ~280 EA sfogliati sul Code Base MQL5 (7 pagine) e ~50 titoli su arXiv,
> **4 sorgenti `.mq5` scaricati e letti**, 7 abstract letti per intero.
> ZERO EA esterni promossi. Nessuno regge il confronto con un motore che ha
> fatto 30 celle su 30.**
>
> **Ma la caccia NON torna a mani vuote**, e non per riempimento: arXiv ha
> reso **cinque paper verificati** che colpiscono esattamente l'asse chiesto
> (uscite e geometrie di stop). Di questi:
>
> - **uno (Leung & Li 2014) identifica un difetto STRUTTURALE nell'uscita di
>   `ABTG_PTE` che si legge nel nostro sorgente alle righe 329-338**, e
>   suggerisce una correzione che **toglie** una manopola invece di aggiungerla;
> - **due giustificano meccaniche che abbiamo GIA'** e che nessuno aveva mai
>   motivato per iscritto (il tetto `InpMaxDistAtr` dell'EMA200; l'accoppiata
>   trailing + TP limite);
> - **uno smonta un metro che usiamo** (il win rate come segnale di qualita').
>
> **Il candidato numero uno non e' un EA esterno: e' un esperimento a COSTO
> ZERO DI CODICE sulla PTE esistente**, che decide *prima* di scrivere una riga
> se la variante strutturale vale la pena. Se risponde "no", si e' risparmiato
> un round intero.

### I tre motivi ricorrenti per cui il Code Base non ha prodotto nulla

1. **Lotto fisso.** 4 candidati su 5 letti nel sorgente (`InpLotSize=0.01`,
   `InpLots=1.0`, `Lots=0.1`). Non scalabile a 100k, non confrontabile con le
   nostre serie. E' gia' il motivo di scarto piu' frequente del `SETACCIO_MANUALE.md`.
2. **Uscite piu' povere delle nostre.** Nessuno dei candidati letti ha
   parziale + breakeven + trailing. Tutti si fermano a "SL in ATR, TP in RR
   fisso". Noi quella gestione ce l'abbiamo gia' e sappiamo che vale.
3. **Il filtro appiccicato.** Il candidato piu' vicino al nostro EMA200
   (`ADX Trend Pullback EA`) usa **ADX 25** come cancello di direzione — cioe'
   esattamente il filtro di **R20**, l'unica cella IS verde che e' risultata
   la **peggiore OOS**. Il Code Base vende come novita' l'errore che noi
   abbiamo gia' pagato cinque volte.

---

## ⚠️ L'AVVERTENZA ONESTA, come richiesta dal mandato

Su motori con questi numeri — **R29: 30 celle su 30 a PASS pieno, PF OOS
1,44-1,61, DD OOS 5,97-8,50%; R31: +23% di netto abbassando il DD storico da
10,08% a 9,50%** — **la probabilita' a priori che roba gratuita del Code Base
li migliori e' bassa.** Questa caccia lo conferma sul campo, non per prudenza.

Il valore che il Code Base *puo'* dare su questo bersaglio non e' un EA da
adottare: e' **un pezzo di meccanica isolata** (una geometria di trail) che
noi rivestiamo con la nostra gestione. E' l'unica voce promossa piu' avanti,
ed e' promossa **come meccanica**, non come EA.

---

## 0. 🧭 IL BERSAGLIO, LETTO NEL NOSTRO SORGENTE PRIMA DI USCIRE

Correzione importante prima di qualunque confronto esterno, perche' cambia
quali candidati sono pertinenti:

### `ABTG_EMA200` NON e' un incrocio di medie. E' un RIMBALZO con due LIMITE.
[VERIFICATO — `mql5/Experts/ABTG_EMA200.mq5`]

| pezzo | riga | cosa fa davvero |
|---|---|---|
| direzione | `:189` `bool up=(close1>ema)` | il lato del prezzo rispetto alla EMA200 — **costitutivo**, e' il motore |
| fascia utile | `:182` | opera solo se `0.3*ATR <= dist <= 1.5*ATR`: **ne' sulla media, ne' troppo lontano** |
| ingresso | `:206-207` | **due ordini LIMITE**: 1o appena oltre la EMA verso il prezzo (0.10 ATR), 2o in overshoot oltre la EMA (0.35 ATR) |
| stop | `:208` | **unico, condiviso**: 1 ATR oltre il 2o ordine |
| target | `:224` | **TP = rischio proprio dell'ordine × 2R, fisso** |
| gestione | `:257-289` | parziale 50% su EMA14 → breakeven → trailing su EMA14 |
| ri-armo | `:173` | `if(HasPosition() \|\| HasPending()) return;` — **un setup alla volta, niente ri-armo** |

> 🔴 **Conseguenza per la caccia:** l'EMA200 e' un **mean-reversion DENTRO il
> trend**, non un trend-follower da incrocio. Tutti gli EA "MA crossover" del
> Code Base sono **fuori bersaglio per costruzione**, non solo mediocri.
> E l'avvertimento del mandato regge in pieno: **la direzione E' gia' il
> motore**, quindi ogni filtro di direzione aggiunto sarebbe l'errore di R20.

### `ABTG_PTE` — e il punto dove l'uscita si scolla dallo stop
[VERIFICATO — `mql5/Experts/ABTG_PTE.mq5`]

| pezzo | riga | cosa fa |
|---|---|---|
| struttura | `:271-272` | canale TMA **non-repaint** lento (56/ATR100) + veloce (14/ATR30) |
| segnale | `:277-278` | **Doji col CORPO fuori dal canale veloce** — sopra = short, sotto = long |
| conferma | `:286-290` | cambio colore della candela successiva (Heikin Ashi) |
| stop | `:329-330` | `ATR + buffer` **oppure** (opt-in `InpSLfromDoji`) l'estremo della Doji |
| target | `:338` | **`tp = entry ± atr*InpTP2_ATRmult`** — fisso a 2 ATR |
| gestione | `:387-420` | parziale 50% su EMA14 → breakeven → trailing su EMA14 |

> 🎯 **IL REPERTO PIU' IMPORTANTE DI QUESTA CACCIA.** Alle righe `:329-338` lo
> **stop e il target sono calcolati in modo INDIPENDENTE l'uno dall'altro**.
> Nel modo di default (`InpSLfromDoji=false`) tutti e due scalano con l'ATR,
> quindi il rapporto R resta ~stabile **per caso, non per costruzione**.
> Nel modo `InpSLfromDoji=true` lo stop viene dall'ampiezza della Doji mentre
> il target resta 2×ATR: **il target non e' piu' espresso in R affatto**, e
> il rapporto rischio/rendimento reale oscilla con la larghezza della Doji.
> [INFERITO dalle righe 329, 333, 338 — nessun accoppiamento fra `risk` e `tp`.]
>
> **Questo e' esattamente il difetto che il paper Leung & Li dimostra essere
> strutturale** (§2.A). E' la prima volta che qualcuno da' un motivo teorico
> al fatto che il default `InpSLfromDoji=false` sia quello sopravvissuto.

### Cosa NON manca (verificato, per non riproporlo)
[VERIFICATO — `backtest_pipeline/prove/R52_CENSIMENTO_LATI.md`]
Celle **7-9 (PTE Dow/GBPUSD/USDJPY)** e **12 (EMA200 Dow)** girano gia'
**LONG + SHORT**, default `true/true`, prove R29/R31 pinnano 1/1.
**Nessun lato mancante.** Qualunque candidato venduto come "il lato short che
vi manca" e' fuori bersaglio: non ci manca.

---

## 1. 🔍 CONTROLLO POSITIVO, fonte per fonte

| fonte | esito | dettaglio |
|---|---|---|
| **MQL5 Code Base** `/en/code/mt5/experts` | ✅ **PASSA** | pagine 1-7 sfogliate, titoli + ID veri e coerenti; ID verificati poi con download HTTP 200 |
| **arXiv API** `export.arxiv.org` | ✅ **PASSA** | ⚠️ **solo su HTTPS**: su `http://` risponde **301 con 0 byte** e sembra una fonte morta. Su `https://` 7 query, entry veri |
| **Quantpedia** `quantpedia.com/strategies` | ⚠️ **RAGGIUNTA MA FUORI PERIMETRO** | i titoli si vedono ("Asset Class Trend-Following", "Short Term Reversal Effect in Stocks", …) ma il contenuto e' dietro _"Unlock 1000+ strategies / Get subscription"_ → **§1.3: materiale a pagamento, non entra** |
| **SSRN** `papers.ssrn.com` | 🔴 **NON RAGGIUNTA** | 403 Cloudflare misurato oggi nel briefing. **Non tentata**, dichiarata nulla |
| **Forex Factory** | 🔴 **NON RAGGIUNTA** | 403 Cloudflare misurato oggi. **Non tentata**, dichiarata nulla |
| **Ricerca interna MQL5** | 🔴 **INUTILIZZABILE** | confermato dal briefing; ha funzionato **solo** lo sfoglio diretto dell'elenco |

📌 **Nota tecnica da tenere:** l'`http://export.arxiv.org` che restituisce
**301 / 0 byte** e' una trappola da §2 — sembra una fonte caduta e invece e'
solo un redirect non seguito. **Su arXiv si va sempre in HTTPS.**

---

## 2. 🥇 I PROMOSSI

Nessun **EA** promosso. Promosse **una tesi** (che diventa il candidato n.1) e
**una meccanica** (che diventa il n.2).

---

### 2.A — 🥇 CANDIDATO N.1 — la tesi che tocca il nostro sorgente

```
NOME            Optimal Mean Reversion Trading with Transaction Costs
                and Stop-Loss Exit
FONTE / URL     arXiv  https://arxiv.org/abs/1411.5062        [VERIFICATO via API]
AUTORE / DATA   Tim Leung, Xin Li — pubblicato 2014-11-18 (v3)
LICENZA         arXiv, PDF scaricabile liberamente
RIGHE / INPUT   n/a (paper). Traduzione: ZERO righe nuove per lo screening

TESI IN UNA RIGA
  "Su un processo che torna alla media, il target ottimo NON e' un livello
   fisso: si muove INSIEME allo stop — stop piu' largo, target piu' lontano."

CITAZIONE VERIFICATA (abstract, verbatim)
  "We show that the entry region is characterized by a bounded price interval
   that lies strictly above the stop-loss level. As for the exit timing,
   a higher stop-loss level always implies a lower optimal take-profit level."

MECCANICA        problema di doppio arresto ottimo su processo Ornstein-Uhlenbeck,
                 con COSTI DI TRANSAZIONE e vincolo di stop-loss.
                 Ingresso: intervallo LIMITATO di prezzo (non "piu' lontano e'
                 meglio") — e sta STRETTAMENTE SOPRA il livello di stop.
                 Uscita:   il take-profit e' funzione MONOTONA dello stop.
GESTIONE RISCHIO n/a — e' teoria dell'uscita, non money management
BANDIERE ROSSE   nessuna
COSTO DI PORTING 0 ore per lo SCREENING (si misura con la PTE che gia' abbiamo,
                 vedi §4). ~4-6 ore per la variante EA, SOLO SE lo screening passa.

PUNTEGGIO
  [2] semplicita'          -> TOGLIE una manopola (accoppia SL e TP), non ne aggiunge
  [2] il filtro E' il motore -> non e' un filtro: e' la GEOMETRIA DELL'USCITA
  [2] tesi di mercato       -> si', ed e' dimostrata, non asserita
  [1] riempie un BUCO       -> non un buco di portafoglio: un buco STRUTTURALE
                               in una sedia viva. Vale, ma non diversifica
  [2] testabile senza riscritture -> SI', lo screening gira sull'EA attuale
  TOTALE 9/10

VERDETTO   🥇 PROVA SUBITO
PERCHE'    E' l'unica cosa trovata oggi che si aggancia a una riga precisa del
           nostro codice (:329-338), spiega perche' il default che gira e'
           quello giusto, e si misura senza scrivere codice.
```

**🏛️ In ottica prop:** favorevole, e per un motivo preciso. Un target
disaccoppiato dallo stop produce **R realizzati variabili**: giornate in cui
un trade vale 0,7R e altre in cui ne vale 3. E' rumore che **allarga la coda
giornaliera**, che e' il muro che ci butta fuori (−5.000 su 100k, e la nostra
peggior giornata misurata e' gia' **−2,06%** in R51). Accoppiare TP e SL
**stabilizza l'R per trade**, cioe' comprime proprio la distribuzione che il
cap giornaliero misura. ⚠️ Ma va **misurato**, non assunto: e' un'ipotesi.

---

### 2.B — 🥈 CANDIDATO N.2 — la meccanica (non l'EA)

```
NOME            Trailing Stop by Fixed Parabolic SAR
FONTE / URL     https://www.mql5.com/en/code/39931          [VERIFICATO]
                sorgente: /en/code/download/39931/EA_MACD_FixedPSAR.mq5
                          (scaricato, HTTP 200, 22.513 byte)
AUTORE / DATA   Yoshihiro Nakata (yossy_nkt) — 8 luglio 2022
POPOLARITA'     11.674 visualizzazioni
LICENZA         Code Base MQL5 (sorgente pubblico e leggibile)
RIGHE / INPUT   ~470 righe. `InpLots=1.0` alla riga :25

TESI IN UNA RIGA
  "Un trail ancorato al MASSIMO RAGGIUNTO che ACCELERA col profitto lascia
   correre l'inizio del movimento e stringe quando il movimento e' maturo."

MECCANICA        segue il massimo corrente dalla barra d'ingresso; a ogni nuovo
                 massimo alza il passo di InpPSAR_Step fino a InpPSAR_Maximum;
                 stop = sl + (max_corrente - sl) * passo.
                 Punto d'inizio SPECIFICABILE (non il SAR canonico).
GESTIONE RISCHIO 🔴 LOTTO FISSO (`InpLots=1.0`, :25). SL/TP veri, nessuna griglia.
BANDIERE ROSSE   lotto fisso (:25). ❌ NIENTE martingala, NIENTE griglia,
                 NIENTE recovery, NIENTE DLL, NIENTE repaint (verificato con
                 grep su `multiplier|grid|martingal|\*=` -> solo occorrenze
                 legittime di calcolo lotto)
COSTO DI PORTING ~3-4 ore: si prende SOLO la formula del trail. La gestione
                 (rischio %, parziale, BE) e' gia' nostra e resta nostra.

PUNTEGGIO
  [2] semplicita'          -> due parametri (passo, massimo)
  [1] il filtro E' il motore -> e' un'USCITA, non un filtro. Neutro
  [2] tesi di mercato       -> si', e ha un paper dietro (Leung & Zhang, §3)
  [1] riempie un BUCO       -> geometria di trail che non abbiamo: oggi
                               trailiamo SOLO su EMA14, su tutte le sedie
  [1] testabile senza riscritture -> no: serve una variante EA
  TOTALE 7/10

VERDETTO   🥈 IN CODA — dietro il n.1, e SOLO se il n.1 passa
PERCHE'    E' l'unica geometria di uscita nuova vista in 280 EA. Ma e' un
           secondo round di codice, e va dopo l'esperimento a costo zero.
```

> ✅ **§5.F applicato alla rovescia, e va detto chiaro:** qui **il motore lo
> buttiamo** (MACD crossover, banale) e **teniamo la gestione** — l'opposto
> del caso solito. Cosa terrei: la **formula del trail accelerante ancorato al
> massimo**. Cosa rifarei: **tutto il resto**, a partire dal lotto fisso.

**🏛️ In ottica prop:** ⚠️ **segnalazione sfavorevole, come impone il §7-bis.4.**
Un trail che si allarga all'inizio del movimento produce **ritorni lunghi dal
picco** prima di stringere — ed e' **esattamente la forma che il DD trailing
delle prop punisce**. Le nostre Monte Carlo sono tutte su **DD statico dal
deposito**; col trailing quei numeri **non valgono** e non li abbiamo mai
ricalcolati. Va misurato con questa avvertenza scritta accanto.

---

## 3. 📚 CULTURA VERIFICATA — non candidati, ma cambia cosa scriviamo nei referti

Quattro paper letti nell'abstract che **non** producono una cella, e che sarebbe
disonesto spacciare per candidati. Valgono lo stesso, e vanno nel dossier.

### 3.A — 🎯 Il tetto `InpMaxDistAtr` dell'EMA200 ha un motivo, e non l'avevamo scritto
**"Two centuries of trend following"** — Lempérière, Deremble, Seager, Potters,
Bouchaud · `https://arxiv.org/abs/1404.3274` · 2014-04-12 [VERIFICATO via API]

> _verbatim:_ "we find a clear **saturation effect for large signals**,
> suggesting that fundamentalist traders do not attempt to resist 'weak
> trends', but **step in when their own signal becomes strong enough**."

Su 4 classi di attivo, dal **1800**, t-stat ≈ **10**. E dice che oltre una certa
forza il segnale di trend **satura**: piu' distanza NON da' piu' rendimento
atteso, perche' i fondamentalisti entrano contro.

> 🎯 **`ABTG_EMA200` ha gia' questo tetto**: `:182`, `dist > InpMaxDistAtr*atr
> → return`, default **1,5 ATR**. Non era motivato da nessuna parte: era un
> parametro. **Adesso ha una tesi con duecento anni di dati dietro.**
> **Non si tocca. Si documenta.**

Seconda riga utile: _"no sign of a statistical degradation of long trends,
whereas **shorter trends have significantly withered**"_ → argomento contro
qualunque tentazione di **accorciare** l'EMA200 o scendere di TF.

### 3.B — ⚠️ Il win rate non misura la qualita' di un trend-follower
**"Trend followers lose more often than they gain"** — Potters, Bouchaud ·
`https://arxiv.org/abs/physics/0508104` · 2005-08-16 [VERIFICATO via API]

> _verbatim:_ "the average gain per trade is always exactly zero, the fraction
> f of winning trades decreases from f=1/2 for small volatility to f=0 for high
> volatility, showing that **this winning probability does not give any
> information on the reliability of the strategy** but is indicative of the
> trading style."

> ⚠️ **Ci riguarda direttamente.** Nel confronto fra varianti di uscita, il win
> rate cambia **per costruzione geometrica**: un target piu' vicino alza il win
> rate senza aggiungere un centesimo di edge. Il DAX Apertura ha **81,0%** di
> win rate ed e' una sedia ottima — ma quel numero misura **lo stile**, non la
> bonta'. **Nel round del §4 le varianti si giudicano su PF, DD e peggior
> giornata. Il win rate si riporta e non si usa per decidere.**

### 3.C — L'accoppiata "trailing + TP limite" e' provata ottima, non ridondante
**"Optimal Trading with a Trailing Stop"** — Tim Leung, Hongzhong Zhang ·
`https://arxiv.org/abs/1701.03960` · 2017-01-14 [VERIFICATO via API]

> _verbatim:_ "we first derive the optimal liquidation strategy prior to a given
> trailing stop, and **prove the optimality of using a sell limit order in
> conjunction with the trailing stop**."

PTE ed EMA200 fanno **gia'** esattamente questo: TP limite (2 ATR / 2R) **piu'**
trailing su EMA14. Uno potrebbe pensare che il TP renda inutile il trailing (o
viceversa): il paper dice che **la coppia e' la forma ottima**. ✅ Conferma di
una scelta esistente. **Da non toccare** — e da citare quando qualcuno proporra'
di togliere l'uno o l'altro.

⚠️ **Ma con una differenza che genera il candidato n.2:** il trailing del paper
e' un **drawdown percentuale dal massimo corrente**. Il nostro e' una **media
mobile del prezzo (EMA14)**. Sono **due geometrie diverse**, e la teoria parla
della prima. Ecco perche' §2.B ha un razionale e non e' moda.

### 3.D — Il gemello per la PTE, sul processo che torna alla media
**"Analysis of Ornstein-Uhlenbeck process stopped at maximum drawdown and
application to trading strategies with trailing stops"** — Grigory Temnov ·
`https://arxiv.org/abs/1507.01610` · 2015-07-06 [VERIFICATO via API]

Deriva l'espressione esplicita del **massimo corrente di un processo OU fermato
al massimo drawdown**. E' la macchina matematica per dimensionare un trail su un
motore **mean-reverting** — cioe' la PTE. **Non e' un candidato**: e' lo
strumento con cui si sceglie il parametro del n.2 **se** si arriva a scriverlo.

**Anche letto e scartato come non pertinente:** _"Following a Trend with an
Exponential Moving Average"_ (Grebenkov & Serror, `arxiv.org/abs/1308.5658`,
2013-08-26) — deriva il **timescale ottimo** di un trend-follower e lo illustra
**sul Dow Jones**, il nostro simbolo. Tentante. **Ma modella una posizione
tenuta in continuo e dimensionata dal segnale della media**, non un rimbalzo con
due limite: e' un'altra macchina. E il periodo della media da noi si sceglie dal
**centro dell'altopiano** del nostro walk-forward, **mai da un paper**
(12 Spearman IS→OOS negative su 13). **Cultura, non candidato.**

---

## 4. 🎯 LA DOMANDA A CUI IL PRIMO TEST DEVE RISPONDERE

> **"Nella PTE, il target ottimo si muove insieme allo stop — oppure i due sono
> davvero indipendenti come li abbiamo scritti?"**

E' una domanda **binaria, misurabile sull'EA che gia' abbiamo, senza scrivere
una riga di codice**, e la risposta decide se esiste un round successivo.

**Come si legge il risultato — dichiarato PRIMA dei numeri:**

| se il CSV mostra… | conclusione |
|---|---|
| il `InpTP2_ATRmult` migliore **si sposta** al variare di `InpSLbufferPips` / `InpSLfromDoji` | 🟢 Leung & Li regge sui nostri dati → **si scrive la variante a target in R** (round successivo) |
| il `InpTP2_ATRmult` migliore **resta lo stesso** | 🔴 **l'idea muore qui, a costo zero.** Nessuna variante EA, nessun round sprecato |

> 🛑 **Questo NON tocca il forward.** E' un round di backtest sul PC di
> backtest. La PTE viva gira come gira (§9). Se lo screening passa, l'esito e'
> un **EA nuovo che gira in PARALLELO** con magic diverso, mai una modifica
> alla sedia viva (regola `_Ottimizzato`).

File prova: **`backtest_pipeline/prove/PTE_ACCOPPIAMENTO_TP_SL.txt`**

---

## 5. 🧾 LA TABELLA CHE IL MANDATO CHIEDE — "CELLA NUOVA" vs "PATCH SU SEDIA VIVA"

**Le patch si scartano, anche quando sembrano buone.** Ecco tutte le idee
emerse oggi, etichettate. Nessuna esclusa per comodita'.

| # | idea | bersaglio | etichetta | esito |
|---|---|---|---|---|
| 1 | **Target espresso in R (funzione dello stop) invece che in ATR fisso** | PTE | 🟢 **CELLA NUOVA** — EA parallelo, magic diverso | 🥇 **PROVA SUBITO** (screening a costo zero, §4) |
| 2 | **Trail accelerante ancorato al massimo corrente** al posto del trail su EMA14 | PTE + EMA200 | 🟢 **CELLA NUOVA** — EA parallelo | 🥈 **IN CODA**, dopo il n.1 |
| 3 | Filtro **ADX 25 + DI** per la direzione (da `ADX Trend Pullback EA`) | EMA200 | 🔴 **PATCH SU SEDIA VIVA** | ❌ **SCARTO.** E' letteralmente **R20**: unica cella IS verde = **peggiore OOS** |
| 4 | Cambiare il **periodo della EMA200** col timescale ottimo di Grebenkov | EMA200 | 🔴 **PATCH SU SEDIA VIVA** | ❌ **SCARTO.** Il periodo si sceglie dal centro dell'altopiano nostro, mai da un paper |
| 5 | Abbassare `InpMaxDistAtr` per "prendere piu' trade" | EMA200 | 🔴 **PATCH SU SEDIA VIVA** | ❌ **SCARTO** — e ora c'e' pure la ragione contraria: la **saturazione** di §3.A dice che quel tetto e' giusto |
| 6 | Togliere il TP fisso e lasciare **solo** il trailing | PTE + EMA200 | 🔴 **PATCH SU SEDIA VIVA** | ❌ **SCARTO.** Leung & Zhang (§3.C) **prova che la coppia limite+trailing e' ottima** |
| 7 | **Trailing Take Profit** (target che insegue il prezzo mentre si perde) | PTE | 🔴 **PATCH SU SEDIA VIVA** | ❌ **SCARTO.** Su un motore mean-reverting chiude proprio i trade la cui tesi e' che il prezzo torni |
| 8 | Aggiungere un **filtro di regime** a una delle due sedie | entrambe | 🔴 **PATCH SU SEDIA VIVA** | ❌ **SCARTO in partenza.** `ROBUSTEZZA.md`: **0 successi su 5** (R20, R12, R26, R45, R54) |
| 9 | **Ri-armo dei pendenti** dopo un setup non eseguito (`EMA200:173`) | EMA200 | 🟢 **CELLA NUOVA** (cambia la frequenza, non un filtro) | ⚠️ **NON PROPOSTO** — vedi §6, alza il rischio giornaliero prop |
| 10 | Correggere il **seed a 2 barre dell'Heikin Ashi** (`PTE:243-245`) | PTE | 🟡 **CELLA NUOVA** se testata in parallelo | ⚠️ **NON PROPOSTO OGGI** — vedi §6 |

**Bilancio: 3 CELLA NUOVA proposte o segnalate · 6 PATCH, tutte scartate ·
1 cella nuova tenuta ferma per motivi prop.**

---

## 6. 🔎 DUE COSE VISTE NEL NOSTRO CODICE CHE NON PROPONGO — e perche'

Onesta' di mestiere: le ho trovate, non le propongo, e dico il motivo invece di
gonfiare il dossier con esse.

**A. `ABTG_PTE:243-245` — l'Heikin Ashi non e' un Heikin Ashi.**
L'apertura HA e' ricorsiva da inizio storico; il nostro codice la **approssima
con un seed di 2 barre**, e il commento lo ammette (`"haOpen ricorsivo:
approssimo con 2 barre di seed"`). Quindi la **conferma di cambio colore** —
che e' un pezzo del motore, non un accessorio — lavora su candele che **non
sono** quelle che vedrebbe un HA standard. [VERIFICATO nel sorgente.]
🛑 **Non lo propongo perche'** e' il motore di una sedia con **PTE positiva in
tutti e quattro i regimi di R50** (ORSO +1.245 · CROLLO +70 · TORO +1.362 ·
LATERALE +5.284). Quel risultato e' stato ottenuto **con questo HA qui**.
"Correggerlo" significherebbe testare un motore diverso e sperare che il
miracolo si ripeta. **Se mai si tocca, e' una cella nuova in parallelo — e
dopo il candidato n.1**, non prima.

**B. `ABTG_EMA200:173` — nessun ri-armo.** Un setup che scade senza essere
eseguito non viene ripiazzato finche' non cambia la fascia. Si potrebbe.
🛑 **Non lo propongo perche'** aumenta i trade **nella stessa giornata e sullo
stesso segnale** — cioe' peggiora esattamente la metrica che ci butta fuori da
una prop (§7-bis.2: _"un EA che spara 5 trade correlati la stessa mattina e' un
rischio giornaliero, non un edge diversificato"_). Piu' trade qui non e' piu'
edge: e' **piu' concentrazione**.

---

## 7. 🗑️ GLI SCARTATI — uno per riga, col motivo

Registrati perche' non si ricerchino il giro dopo.

| EA / fonte | ID | letto | motivo dello scarto |
|---|---|---|---|
| **ADX Trend Pullback EA** (Duy Van Nguy, 14/06/2026, 6.503 viste) | [73958](https://www.mql5.com/en/code/73958) | ✅ **SORGENTE** (11.738 byte, 295 righe) | **Triplo scarto.** `InpLotSize=0.01` **lotto fisso** (:24) · direzione da **ADX 25 + DI** (:35) = il filtro di **R20** · uscita **piu' povera della nostra** (SL ATR + TP RR fisso, **niente parziale, niente BE, niente trailing**). E' il nostro EMA200 con una direzione peggiore |
| **Smart Trend Follower** (Yulianto Hiu, 04/02/2025, 20.982 viste) | [53022](https://www.mql5.com/en/code/53022) | pagina | **§4: griglia + moltiplicatore.** _"grid-layering approach opens additional trades at specified pip intervals, with lot sizes escalating via a multiplier"_ — **dichiarato dall'autore stesso**. Scarto immediato |
| **Trailing Stop by Fixed Parabolic SAR** | [39931](https://www.mql5.com/en/code/39931) | ✅ **SORGENTE** (22.513 byte) | ⚠️ **NON scartato come meccanica** → §2.B. Scartato **come EA**: lotto fisso (:25) e motore MACD banale |
| **New Concept: Trailing Take Profit** (ManiABLS, 11/07/2023, 15.548 viste) | [45379](https://www.mql5.com/en/code/45379) | ✅ **SORGENTE** (3.817 byte, 105 righe, 4 input) | **Non e' un EA**: e' un'utility che sposta il TP su posizioni altrui, col simbolo **cablato** (`Symbol_Name="GBPUSD"`, :16). E la logica — inseguire il prezzo col target **mentre si perde** — su un mean-reverting chiude i trade la cui tesi e' che il prezzo torni. Nessuna gestione del rischio |
| **Bands R-squared** (Korollkov, 16/05/2025, 4.525 viste, 5/5) | [58268](https://www.mql5.com/en/code/58268) | ✅ **SORGENTE** (29.644 byte, 351 righe, UTF-16, 10 input) | Codice **pulito**, nessuna bandiera rossa a parte `Lots=0.1` **fisso** (:14). Ma: **doppione** — rientro nella banda di Bollinger = famiglia `ABTG_BreakingBand`, gia' viva su GBPUSD/EURUSD/AUDUSD (celle 13-15). E SL 4 ATR / TP 4 ATR = **1:1 secco**, piu' povero del nostro |
| ~230 EA su 7 pagine di elenco | — | titolo | **Primo taglio §6.4**: martingala/griglia dichiarati nel titolo (`Sideways Martingale`, `RSI Grid EA Pro`, `BGC Grid EA`, `Martingale Pulse EA`, `XANDER Grid XAUUSD`, `MA Grid Trade`, `Breakout Martin Gale`, `VIDYA N Bars Borders Martingale`, `Martingale Levels For Money Management`…) · pannelli/utility/copier · esempi didattici · roba ONNX/AI. **Nessuno pertinente a un rimbalzo su media o a un canale di regressione** |

---

## 8. 🕳️ COSA NON HO POTUTO VEDERE — dichiarato, non taciuto

1. 🔴 **SSRN** (`papers.ssrn.com`) — **403 Cloudflare** misurato oggi. Non
   tentata. E' la fonte dove sta la letteratura sui **costi di esecuzione delle
   regole tecniche**, che e' proprio quello che serve al candidato n.2.
   **Buco reale.**
2. 🔴 **Forex Factory** — **403 Cloudflare**. Non tentata. E' l'**unico posto**
   dove si legge come una strategia **e' invecchiata** (§3.E del mandato).
   Su un motore che deve reggere in forward, e' il buco che pesa di piu'.
3. ⚠️ **Quantpedia** — raggiunta, titoli visibili, **contenuto a pagamento**.
   Fuori perimetro §1.3. Non ho aperto nulla.
4. ⚠️ **TradingView** — **non sfogliata oggi.** Scelta deliberata, e la dichiaro:
   Pine→MQL5 e' una **riscrittura**, e su un bersaglio dove il metro e' un EA a
   30/30 il costo di validazione supera il valore atteso. Non e' "non c'era
   niente": **non ho guardato**.
5. ⚠️ **GitHub** — **non sfogliata oggi**, stessa ragione di budget. Dichiarato.
6. ⚠️ **arXiv, i PDF** — ho letto **gli abstract via API**, non i PDF completi.
   I risultati citati sono verbatim dagli abstract. Le **formule** dei paper
   §2.A e §3.D **non le ho lette**: servirebbero per tarare i parametri, non
   per lo screening di §4. **Da fare prima di scrivere la variante EA.**
7. 🔴 **`@DAQUANDO` non misurato** per GBPUSD su BCM → il file prova esce
   **senza quella riga**, per scelta, come gia' fa `prove/ABTG_PTE.txt`.

---

## 8-bis. 🚀 LA RIGA DI LANCIO — passata dalla `CHECKLIST_RIGA_DI_LANCIO.md`

**I quattro controlli, eseguiti (non promessi):**

1. ✅ **Ho aperto lo script.** `walkforward_generico.ps1`, righe 60-75 (i
   parametri) e 260-264 (come risolve il file prova). Da li' vengono i due
   flag che seguono, non dalla memoria.
2. ✅ **Difetti gemelli.** Nessuna correzione fatta oggi da propagare: questa
   caccia non ha toccato nessuno script.
3. 🎯 **CERCA o VERIFICA? → CERCA.** E' una griglia da **32 celle**, quindi
   **`-Modello 1` (OHLC M1, SOLO screening)**. E' esattamente l'errore di R58
   evitato: quella riga puntava a una griglia mentre serviva la cella
   congelata. Qui la griglia e' voluta — **e per la stessa ragione il verdetto
   NON si legge da qui** (§9: verdetti solo a tick reali).
4. ✅ **SHA.** Nessun SHA da pinnare: non propongo operazioni git.

```
# 0. PREREQUISITO — @DAQUANDO NON ESISTE ANCORA. Prima si MISURA:
powershell -ExecutionPolicy Bypass -File .\scarica_storico.ps1 -Simboli "GBPUSD" -SoloReferto

# 1. GIRO A VUOTO (non apre MT5, dice quante celle sono: devono uscire 32)
powershell -ExecutionPolicy Bypass -File .\walkforward_generico.ps1 -Expert ABTG_PTE `
  -Prova "prove\PTE_ACCOPPIAMENTO_TP_SL.txt" -Modello 1 -Etichetta "R_TPSL" -SoloControllo

# 2. SOLO SE il conteggio torna 32 e @DaQuando e' la data MISURATA al passo 0
powershell -ExecutionPolicy Bypass -File .\walkforward_generico.ps1 -Expert ABTG_PTE `
  -Prova "prove\PTE_ACCOPPIAMENTO_TP_SL.txt" -Modello 1 -Etichetta "R_TPSL" -DaQuando <DATA_MISURATA>
```

- **`-Prova`** serve perche' il file **non** si chiama come l'EA: il default e'
  `prove\<EA>.txt` (riga 260), e senza questo flag il driver prenderebbe la
  **vecchia griglia della PTE** — di nuovo l'errore di R58.
- **`-Etichetta "R_TPSL"`** perche' i CSV non sovrascrivano quelli PTE esistenti.
- ⚠️ **UNA MACCHINA, UN LAVORO.** Apre MT5 sul PC di backtest: prima deve
  essere finito **tutto** quello che ci gira adesso.
- ⚠️ **Il file prova esiste su QUESTA macchina.** Il driver, se non lo trova in
  locale, lo scarica da `raw.githubusercontent` sul branch **`lavoro`**
  (righe 77-78, 264). **Non ho eseguito nessun comando git** (vincolo del
  mandato): sul PC di backtest il file va portato li' da te.

---

## 9. 📌 IN UNA RIGA

> Il Code Base non ha niente per due motori a 30/30 — **e questa e' la
> risposta, non un fallimento**. arXiv invece ha consegnato la cosa piu' utile
> della giornata: **un difetto strutturale nell'uscita della PTE, visibile alle
> righe 329-338 del nostro sorgente, misurabile domani senza scrivere codice.**

---
_Fonti aperte davvero: 7 pagine di elenco MQL5 (~280 titoli) · 5 schede EA ·
**4 sorgenti `.mq5` scaricati** (HTTP 200 verificato: 73958, 39931, 45379,
58268) · 7 query arXiv · 7 abstract · 1 pagina Quantpedia.
Il quinto EA (53022) e' stato letto **solo sulla scheda**, ed e' scartato su
una frase dell'autore, non su una riga di codice: e' etichettato cosi' in §7.
Nessuna riga di questo dossier viene dalla memoria._
