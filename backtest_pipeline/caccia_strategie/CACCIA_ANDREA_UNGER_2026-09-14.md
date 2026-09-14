# 🎯 CACCIA — ANDREA UNGER (14/09/2026)

_Richiesta di Claudio: «HO SENTITO PARLARE DI ANDREA UNGER COME PERSONA ESPERTA
SU EXPERT, MANDA GLI AGENTI A CACCIA PER TROVARE QUALSIASI COSA PARLI DI LUI E
DEGLI EXPERT.»_

**Caccia centrata su una PERSONA, non su uno script.** Adattamento del §6 del
mandato: stesso controllo positivo, stesso setaccio, ma il prodotto atteso non
e' per forza un `.mq5` — puo' essere un principio di metodo.

---

## 🔴 LA RIGA CHE CONTA, PRIMA DI TUTTO

> **Su 24 host provati, 4 sono raggiungibili da questa sessione, 16 sono
> bloccati dal proxy di rete, 1 risponde 403 e 2 non sono recuperabili dallo
> strumento. TUTTE le fonti primarie su Unger (il suo sito, il suo YouTube, i
> podcast che lo intervistano, la stampa italiana, Wikipedia, gli editori dei
> suoi libri) stanno fra i bloccati.**
>
> **Risultato: ZERO candidati con scheda. ZERO file prova. E ZERO parole di
> Unger che io abbia potuto leggere su una pagina aperta davvero.**

Cio' che segue e' diviso in tre parti, e la divisione e' la sostanza del
referto: **(1) cio' che ho VERIFICATO aprendo pagine**, **(2) cio' che ho solo
INTRAVISTO negli snippet dei motori di ricerca e che quindi NON e' una fonte**,
**(3) cio' che Unger ha gia' prodotto in casa nostra** — perche' non partiamo
da zero, e questa e' la notizia migliore della giornata.

---

## 1. ✅ CONTROLLO POSITIVO, FONTE PER FONTE

Regola §2: prima di cercare, verifico che il canale risponda su un bersaglio di
cui conosco gia' la risposta.

| fonte | URL provato | esito | cosa ha stampato |
|---|---|---|---|
| **MQL5 Code Base** | `mql5.com/en/code/mt5/experts` | 🟡 **PASS PARZIALE** | Titoli veri e correnti (`GDS Renko Bollinger 4-Mode Demo EA`, `GDS Renko ADX Demo EA`, `GDS Renko Dual MA Demo EA`, `ZetaBurst Scalper EA`, `EA AurumNeuro Vanguard`). ⚠️ **Autori e date NON resi** dalla conversione in markdown: il controllo positivo del mandato chiede "titoli, autori e date" e ne ho due su tre. Dichiarato. |
| **GitHub** | `github.com/search?q=mql5+expert+advisor&type=repositories` | ✅ **PASS PIENO** | `geraked/metatrader5` 637★ agg. 15/11/2025 · `EarnForex/PositionSizer` 594★ agg. 1 ora fa · `yulz008/GOLD_ORB` 291★ agg. 29/07/2023 · `EA31337/EA31337-classes` 266★ · `Joaopeuko/Mql5-Python-Integration` 212★ |
| **arXiv q-fin.TR** | `arxiv.org/list/q-fin.TR/recent` | ✅ **PASS PIENO** | 3 paper con data: *Deep Learning of Robust Market Making under Regime-Switching Order Flow* (11/09/2026), *The Privacy Subsidy in Market Microstructure* (11/09/2026), *dexamine* (10/09/2026) |
| **TradingView** | `tradingview.com/scripts/` | ✅ **PASS PIENO** | `CME Institutional Order Flow & AMT Lens` di GoofyFarmer · `Wyckoff [theUltimator5]` · `MOYA Sessions & Volume Profile` |
| **Quantpedia** | `quantpedia.com/?s=walk+forward` | 🟡 **PARZIALE** | Rende la paginazione (265 pagine) ma **nessun titolo**: inutilizzabile, trattata come nulla |

### 🛑 LE FONTI NULLE — e qui sta il problema di questa caccia

**Tutte `EGRESS_BLOCKED` = bloccate dalla politica di rete, non un 404 e non un
503.** Non sono "non esistono" e non sono "non adesso": sono "non da qui".
Distinzione del §2 rispettata: **nessuna di queste va cancellata dal catalogo**,
vanno riprovate da una postazione senza il blocco (per esempio Claudio stesso).

| dominio bloccato | perche' mi serviva |
|---|---|
| `ungeracademy.com` · `learn.ungeracademy.com` | 🔴 **la fonte primaria**: blog tecnico + lezioni |
| `skilledacademy.freshdesk.com` | helpdesk Unger Academy: risposta sulle piattaforme usate |
| `bettersystemtrader.com` | 🔴 **due interviste lunghe** (ep. 016 e 045, "Entry Techniques with Andrea Unger") |
| `algoadvantage.substack.com` | intervista/trascrizione ep. 038 |
| `youtube.com` | il suo canale + playlist "Automated Trading System Tips by Andrea Unger" |
| `it.wikipedia.org` | biografia e piattaforme |
| `money.it` · `tradingonline.me` · `samt-org.ch` · `medium.com` · `gandalfproject.com` · `forexdream.net` | articoli su di lui, recensioni del libro, forum italiani |
| `futures.io` · `elitetrader.com` | forum di trading algoritmico |
| `listennotes.com` | indice dei podcast |
| `wiley.com` · `goodreads.com` | editore e scheda dei libri (indice dei capitoli) |
| `forexfactory.com` | **HTTP 403** (non egress: rifiuto del sito) |
| `web.archive.org` · `reddit.com` | non recuperabili dallo strumento |

---

## 2. 🟢 COSA HO VERIFICATO DAVVERO (pagine aperte)

### 2.1 Unger NON esiste come codice sulle tre fonti-sorgente che possiamo leggere

Questa e' la risposta secca alla domanda (d) del mandato — *"si e' mai espresso
su MQL5/MT5, e c'e' roba sua tradotta li'?"*.

| fonte | ricerca | esito **[VERIFICATO]** |
|---|---|---|
| **MQL5** (Code Base, articoli, forum, blog) | `"Andrea Unger"` e `Unger Andrea trading champion strategy`, ricerca ristretta al dominio | **zero risultati su di lui.** Il motore restituisce omonimie e rumore: `Andrea Zani (sbraer)` dell'Automated Trading Championship 2011, `Sergey Gunko`, prodotti Market col nome "Champion" |
| **GitHub** | `"unger" trading strategy`, repositories | **"Your search did not match any repositories"** — zero repo |
| **TradingView** | `scripts/?search=unger` | 🟡 **[INCERTO], e lo declasso io**: nessun titolo contiene "unger", **ma i titoli restituiti sono gli stessi della lista popolare di default** (`CME Institutional Order Flow`, `Wyckoff`, `MOYA Sessions`). **Contro-esempio che non so escludere:** che il parametro di ricerca sia stato ignorato e io abbia riletto la home. Stesso output, due spiegazioni → **la misura non distingue, quindi non vale**. TradingView resta **NON verificata** su Unger |

**L'unica occorrenza reale trovata su MQL5 e' di terzi**, sulla scheda profilo
di un altro sviluppatore — `https://www.mql5.com/en/users/lucadeandrea`, pagina
aperta, citazione **verbatim**:

> _"I've studied the theories and strategies of leading systematic traders
> worldwide, including Andrea Unger, K. J. Davey, Scott Welsh, and many
> others."_

**[VERIFICATO]** che il profilo lo cita come influenza dichiarata. **[INCERTO]**
qualunque cosa sul valore del suo prodotto: e' **1 prodotto sul Market**, quindi
**fuori perimetro permanente** (§3B: niente sorgente = il setaccio non parte).

> 🎯 **Conclusione (d), e regge su MQL5 e GitHub** (su TradingView e' solo
> **non trovato**, non "assente": v. il declassamento qui sopra)**:** Unger e'
> **assente dall'ecosistema MQL5**. Non ha Code Base, non ha articoli, non ha repo. Il suo
> mondo e' un altro (linguaggio EasyLanguage/PowerLanguage su futures), e
> **nessuno ha portato il suo materiale dalla nostra parte del fiume**.
> Chiunque volesse usarlo in casa nostra **riscrive da zero**, senza un
> riferimento da confrontare.

### 2.2 Il *"Percent Volatility"* — l'unica meccanica sua concreta — CE L'ABBIAMO GIA'

Il modello di sizing piu' associato a Unger (v. §3 sotto per la fonte, che e'
snippet e quindi debole) e' il **Percent Volatility**: numero di contratti
calcolato dall'ATR invece che da un lotto fisso.

**Verificato nel nostro codice**, `mql5/Experts/ABTG_EMA200.mq5` r.467-495
(`LotByRisk`): il lotto esce da **rischio in percentuale diviso la perdita per
lotto alla distanza di stop**, con la perdita per lotto chiesta al broker e non
al tick value nudo (commento datato 08/08/2026, nato da un errore misurato su
225JPY).

E la distanza di stop, in gran parte del vivaio, **e' gia' ATR-based**:
`InpAtrSlMult`, `InpSLBufferATR`, `InpAtrPeriodD1` compaiono nelle celle vive
di `LARRY_GBPUSD`, `LARRY_ORO`, `COST_EURJPY`, `COST_GBPCAD`
(`backtest_pipeline/prove/CELLE_REGIME.txt`).

> ➡️ **rischio % costante su uno stop proporzionale alla volatilita' = Percent
> Volatility.** Nome diverso, stessa algebra. **[INFERITO]** dalle righe citate.
> **Non e' un buco da riempire: e' una convergenza.**

---

## 3. 🟡 COSA HO SOLO INTRAVISTO — e che per il mandato **NON E' UNA FONTE**

⚠️ **Tutto questo paragrafo e' `[INCERTO]`.** Viene dai riassunti generati dal
motore di ricerca su pagine che **non ho potuto aprire**. Non lo tratto come
vero, non lo metto in una scheda, non lo faccio pesare su nessun punteggio.
Lo scrivo per una ragione sola: **e' la lista della spesa per Claudio**, che
non ha il nostro blocco di rete e puo' aprire questi URL in trenta secondi.

### 🔴 3.1 LA CONTRADDIZIONE DA VERIFICARE PER PRIMA — il walk-forward

Il mandato con cui sono partito diceva: _"e' notoriamente un sostenitore del
walk-forward"_. **Lo snippet della sua stessa pagina dice il contrario:**

> _"Andrea Unger considers WFA a good analysis method, nevertheless he doesn't
> use it. The reason depends on the specific way in which he builds his trading
> systems."_
> — riassunto di ricerca su `ungeracademy.com/blog/walk-forward-analysis`
> **[INCERTO — pagina NON aperta]**

E la sostituzione che gli viene attribuita e' **test di stabilita' dei
parametri**: piccole variazioni attorno ai valori scelti, invece di
riottimizzare a finestre scorrevoli.

> 🎯 **Se fosse confermato, non e' una curiosita' biografica: e' esattamente la
> nostra regola del CENTRO DELL'ALTOPIANO.** `report/ROBUSTEZZA.md` §3B: _"La
> cella migliore e' quella che ha avuto piu' fortuna; il centro dell'altopiano
> e' quella che resta buona anche se il mercato si sposta di un po'."_
> Noi facciamo **tutte e due** le cose (walk-forward IS/OOS **e** centro
> dell'altopiano). Sarebbe una convalida esterna indipendente del pezzo di
> metodo su cui abbiamo **13 misure di Spearman IS→OOS, 12 negative**.
>
> **Ma finche' quella pagina non e' aperta, e' un sentito dire.** E il mandato
> su questo non si negozia.

### 3.2 Gli altri principi intravisti (tutti [INCERTO], tutti da aprire)

| tema | cosa dice lo snippet | URL da aprire | gia' in casa? |
|---|---|---|---|
| **ingressi** | parte dal **meccanismo d'ingresso** (stop order a un livello, limit su supporto/resistenza) e **poi** cerca il setup, invertendo l'ordine abituale | `bettersystemtrader.com/045-andrea-unger/` | 🟡 **forse nuovo**: interessante, e' un modo di generare varianti |
| **cosa e' una strategia** | ingresso + uscita (target e stop) + position size + filtri (ora del giorno, condizioni, vincoli di strumento) | `ungeracademy.com/blog/...` (varie) | ✅ identico al nostro schema |
| **money management** | Fixed Fractional, Fixed Ratio, **Percent Volatility** (ATR); libro Wiley 2021 | `wiley.com/...-p-9781119798835` | ✅ **gia' in casa**, v. §2.2 |
| **rischio per trade** | "tipicamente non piu' dell'1% dell'equity" | idem | ✅ noi a **0,65%** — piu' prudenti, e per un motivo misurato (p99 8,1% contro 12,47%) |
| **diversificazione** | 30-40 mercati futures, piu' strategie per mercato | idem | ✅ stessa tesi di `ROTTA_PROP.md`, scala diversa |
| **robustezza** | regole oggettive, test severi, difesa dall'overfitting; strumenti che mostrano come varia la performance al variare degli input | `ungeracademy.com/blog/trading-systems-robustness` | ✅ = altopiano |
| **breakeven stop** | uscita al pareggio, valore "ne' troppo stretto ne' troppo largo", tarato sull'orizzonte temporale della strategia; **codice in EasyLanguage nell'articolo** | `ungeracademy.com/blog/how-to-set-a-breakeven-stop-and-stop-profit-with-code-in-easylanguage` | ✅ gia' fatto: parziale 1R + breakeven + runner 2R |
| **piattaforme** | MultiCharts/TradeStation; **MetaTrader criticato** perche' copre solo forex/CFD e perche' _"the free data feed offered by Metatrader brokers generally have a very short history"_ | `ungeracademy.com/blog/metatrader-or-multicharts` | 😬 **ci riguarda**: e' il nostro difetto misurato — **110 file prova su 153 girano su 21 mesi** (`@DAQUANDO 2024.09.26`, CLAUDE.md) |

### 3.3 Fonti da NON aprire: rumore riconosciuto

- `web.nutritionjobs.com/strategic-field/andrea-unger-mastering-systematic-trading-...`
  — comparso in cerca. Un sito di annunci di lavoro nel settore nutrizione che
  pubblica un pezzo su trading sistematico e' **contenuto generato per SEO**.
  🔴 **Scartato a vista**, e segnalato perche' e' proprio il tipo di pagina che
  produce citazioni false e plausibili.

---

## 4. 🏠 UNGER E' GIA' PASSATO DAL NOSTRO IMBUTO — e abbiamo il referto

**Questa e' la parte che vale di piu', ed e' interamente `[VERIFICATO]` perche'
sta nel nostro repo.** Claudio aveva gia' portato materiale di Unger a mano
(§ SETACCIO_MANUALE: il materiale che porta lui in chat), e quel materiale **e'
diventato un round**.

**Fonte interna:** `backtest_pipeline/prove/SMASH_DAY_TESI.md`, fonti 2 e 6:

- **fonte 2** — _"Trascrizione Andrea Unger sull'OOPS (fornita da Claudio):
  definizione operativa completa: gap up oltre il massimo di ieri -> se il
  prezzo torna al massimo di ieri, SHORT su quel livello (specchio sul gap
  down) -> stop parametrico -> uscita first profitable open."_
- **fonte 6** — _"Video team Unger — BACKTEST dell'Oops su DAX future 2010-oggi
  (fornito da Claudio, il pezzo che vale di piu')"_. Verdetto **loro**:
  funzionava fino a **ottobre 2022**, poi declino; 2023/2024/2025 in forte
  perdita. Causa indiziata: sessione estesa ~23h dal 2019 → niente gap.
- **r.152**, nota nostra: _"MAI in euro fissi (i 1.500€ di Unger non scalano
  fra strumenti)"_ → 🎯 **rifinitura di casa gia' applicata al suo materiale**:
  il motore si tiene, la gestione si rifa' (§5F del mandato, alla lettera).

**Esito nel nostro imbuto** — `backtest_pipeline/risultati_archivio/REFERTO_ROUND38_PUNTE_LARRY.md`:

> _"OOPS (modo 2): **ZERO trade in 288 celle di scan**. Sul CFD quasi-24h il gap
> giornaliero non esiste: pattern strutturalmente muto sul nostro broker —
> esattamente come da fonte 6 (Unger) e attese di tesi. Capitolo Oops CHIUSO
> senza appello (e senza costo)."_

### 📌 Le due lezioni, e valgono per la caccia di oggi

1. ✅ **Il canale funziona quando e' Claudio a portare il materiale.** Le fonti
   Unger bloccate per me sono aperte per lui: e' gia' successo, ed e' costato
   zero tempo macchina perche' la tesi scritta prima aveva previsto lo zero.
2. 🔴 **La meccanica di Unger e' nata su FUTURES che CHIUDONO.** Il DAX future
   fa gap ogni notte; il nostro `D30EUR` e' un CFD che quota quasi 24h. **Un
   pezzo consistente del suo repertorio (tutto cio' che vive sul gap e sulla
   *first profitable open*) e' strutturalmente muto sul nostro broker** — non
   "non funziona": **non si presenta**. E l'abbiamo misurato, 288 celle a zero.

---

## 5. 🧮 SCHEDE — nessuna

**Non compilo nessuna scheda del §7, e la ragione e' esplicita nel mandato:**
la scheda chiede `RIGHE / INPUT <contati nel sorgente>` e `MECCANICA` letta nel
codice. **Non ho aperto nessun sorgente, perche' non ne esiste nessuno sulle
fonti raggiungibili** (§2.1: zero su MQL5, zero su GitHub, zero su TradingView).

Una scheda compilata su snippet sarebbe **esattamente l'allucinazione che il §1
squalifica**. Quindi: **zero promossi, zero in coda, e nessun file prova.**

### Tabella degli scarti — perche' non si ricerchino il giro prossimo

| cosa | motivo dello scarto |
|---|---|
| `mql5.com/en/users/lucadeandrea` (1 prodotto Market) | 🔴 **Market = fuori perimetro permanente** (§3B): niente sorgente, il setaccio non parte |
| Libri Unger (Wiley/Goodreads/AbeBooks) | 💰 a pagamento **e** pagine editore irraggiungibili: nessuna scheda minima possibile, quindi **non passa nemmeno per il `CANCELLO_ACQUISTI_EA.md`** |
| Corsi Unger Academy / Skilled Academy | 💰 a pagamento, contenuto non ispezionabile, **e in EasyLanguage**: costo di porting su un materiale che non si puo' vedere prima = valore atteso non calcolabile |
| Playlist YouTube "Automated Trading System Tips" | dominio bloccato: **non valutata**, non scartata nel merito |
| `web.nutritionjobs.com/...` | 🗑️ contenuto SEO generato: rumore |
| Pattern **OOPS** | ✅ **gia' misurato e chiuso in casa**: 0 trade su 288 celle (R38) — non si rifa' |

---

## 6. 🏛️ LA RIGA PROP — vale lo stesso, anche senza candidati

In ottica prop (`report/METRO_PROP.md`: muro DD totale **10% = 90.000 su 100k**,
muro **giornaliero 5% = −5.000**), il profilo Unger cosi' come emerge ha **due
disallineamenti strutturali con la nostra challenge del 1° ottobre**, e vanno
detti anche se sono sfavorevoli:

1. **Strumenti.** Il suo campo sono i **futures** (30-40 mercati). Noi siamo su
   **CFD BCM**. Il caso OOPS dimostra che la traduzione non e' neutra: lo stesso
   pattern e' **muto** da noi. Ogni sua meccanica va ri-verificata sull'esistenza
   dell'evento prima ancora che sull'edge.
2. **Orizzonte.** Un portafoglio a 30-40 mercati diluisce; una challenge con un
   **DD giornaliero di 5.000 euro** non diluisce niente. Il suo "1% per trade"
   citato negli snippet **e' piu' aggressivo del nostro 0,65%**, e il nostro
   0,65% non e' prudenza caratteriale: e' il numero che porta il p99 del DD
   Monte Carlo da **12,47% a ~8,1%**, cioe' da fuori a dentro il muro.

> ➡️ **Niente di quanto trovato oggi accorcia la strada verso una sedia
> schierabile il 1° ottobre.** Va scritto cosi': e' una giornata di
> **ricognizione**, non di avanzamento (CLAUDE.md, 10/09: _"una giornata che
> produce solo ponteggio va dichiarata come tale"_).

---

## 7. ❓ LA DOMANDA A CUI IL PRIMO PASSO DEVE RISPONDERE

Non e' una domanda da tester, perche' non c'e' niente da testare. **E' una
domanda da fonte**, ed e' una sola:

> ### 🔎 «Il walk-forward: Unger lo usa o no?»

Perche' e' **quella** e non un'altra:
- se **lo usa**, e' una conferma di quello che gia' facciamo, e la caccia Unger
  si chiude qui con un "nulla di nuovo" onesto;
- se **non lo usa** e si affida alla **stabilita' dei parametri** — come dice lo
  snippet — allora un campione del mondo, per strada indipendente, e' arrivato
  alla **nostra regola del centro dell'altopiano**, che e' il pezzo di metodo su
  cui abbiamo il campione piu' largo (**12 Spearman IS→OOS negative su 13**,
  l'ultima R58 a tick reali). Non cambierebbe un parametro — ma sarebbe la prima
  conferma esterna indipendente che abbiamo.

**Costo per rispondere: zero tempo macchina.** Serve che una postazione senza il
blocco apra **una** pagina.

### 📥 La lista della spesa, in ordine di resa (per chi non ha il blocco)

| # | URL | cosa deve rispondere |
|---|---|---|
| 1 | `https://ungeracademy.com/blog/walk-forward-analysis` | 🔴 **la domanda qui sopra**, verbatim |
| 2 | `https://ungeracademy.com/blog/metatrader-or-multicharts` | cosa dice **davvero** di MT4/MT5 (domanda (d) del mandato) |
| 3 | `https://bettersystemtrader.com/045-andrea-unger/` | **"Entry Techniques"**: l'ingresso prima del setup — l'unica cosa intravista che potrebbe essere **nuova** per noi |
| 4 | `https://ungeracademy.com/blog/trading-systems-robustness` | i suoi criteri di robustezza, contro i nostri |
| 5 | `https://ungeracademy.com/blog/how-to-set-a-breakeven-stop-and-stop-profit-with-code-in-easylanguage` | **contiene codice**: unica pagina intravista con meccanica leggibile |
| 6 | `https://ungeracademy.com/blog/volatility-position-sizing-adapting-your-strategies-to-market-volatility` | conferma o smentita del §2.2 (Percent Volatility = il nostro `LotByRisk`) |

⚠️ **Sono sei pagine pubbliche e gratuite. Nessun acquisto e' richiesto, e
nessuno e' raccomandato.** Il materiale a pagamento (libri, corsi) resta fuori:
non e' ispezionabile in anticipo, quindi non ha nemmeno la scheda minima che il
`CANCELLO_ACQUISTI_EA.md` pretende.

📌 **Il precedente che rende sensata questa richiesta**: l'unica volta che
Unger e' entrato in questo progetto, ci e' entrato **cosi'** — trascrizione
portata a mano da Claudio → `SMASH_DAY_TESI.md` → R38 → capitolo chiuso in un
round, **senza sprecare un'ora di macchina**.

---

## 8. 📋 IL CONSUNTIVO, coi numeri veri

| misura | valore |
|---|---|
| host provati | **24** |
| host raggiungibili | **4** (`mql5.com`, `github.com`, `arxiv.org`, `tradingview.com`) + 1 parziale (`quantpedia.com`) |
| host bloccati dal proxy (`EGRESS_BLOCKED`) | **16** |
| host che rifiutano (403) | **1** (`forexfactory.com`) |
| host non recuperabili dallo strumento | **2** (`web.archive.org`, `reddit.com`) |
| controlli positivi passati | **3 pieni + 1 parziale** |
| ricerche fatte | **11** |
| pagine **aperte davvero con contenuto** | **9** |
| pagine con contenuto Unger aperte davvero | **1** (un profilo di terzi che lo cita) |
| sorgenti letti | **0** — non ne esiste nessuno di suo sulle fonti raggiungibili |
| candidati con scheda | **0** |
| file prova prodotti | **0** |
| fatti nuovi verificati | **3** (§2.1 assenza da MQL5/GitHub/TradingView · §2.2 convergenza sul sizing · §4 precedente interno R38) |

**Non ho gonfiato il dossier.** Il §8 del mandato dice che una caccia a mani
vuote e' una risposta valida se si dice perche': qui il perche' e' che **le
fonti che servivano non erano raggiungibili**, non che il materiale non esista.

---

_Nessun EA toccato. Nessun parametro in forward toccato. Nessun acquisto fatto
ne' consigliato. Conto reale 10105439 mai nominato se non per dire che non e'
stato toccato._
