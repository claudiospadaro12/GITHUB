# 🎯 CACCIA UNGER — PILASTRI 4 e 5: SIZING E VALIDAZIONE (24/09/2026)

_Richiesta di Claudio del 24/09: parametri e metodi concreti di Andrea Unger per
migliorare i nostri EA MQL5, niente teoria generica. Questo dossier copre SOLO
il **pilastro 4 (money management)** e il **pilastro 5 (ottimizzazione e
validazione)**. Riparte da `CACCIA_ANDREA_UNGER_2026-09-14.md` e non rifà
quello che c'è già scritto (§2.2 sizing, §3.1 walk-forward, §7 lista della spesa)._

---

## 🔴 LA RIGA CHE CONTA

> **Su 43 host provati con WebFetch, 2 rispondono (`github.com`, `mql5.com`),
> 41 sono `EGRESS_BLOCKED`**: tutte le fonti primarie su Unger (sito, podcast,
> editori, librerie, forum, riviste) stanno dietro il blocco. **Nessuna pagina
> con parole di Unger è stata aperta davvero.**
>
> Quindi **quasi tutto ciò che segue è `[SNIPPET]`**: riassunti del motore di
> ricerca su pagine che NON ho aperto. Su 48 ricerche fatte, gli snippet però
> **si ripetono coerenti da URL diversi dello stesso autore**, e questo li rende
> un'ottima **lista di cose da verificare**. Da soli non sono una fonte.
>
> 🟢 **Il risultato che vale di più è un confronto, e regge anche così**: su
> **15 punti di metodo** attribuiti a Unger (tabella dei buchi, §4), **9 li
> abbiamo già** (in 4 siamo **più severi** di lui), **3 li abbiamo a metà**,
> **3 non li abbiamo** — e uno dei tre (Fixed Ratio) **non lo consiglierei** in
> prop. Nessuno dei mancanti avvicina una sedia al 1° ottobre.

### Etichette usate (una per affermazione)
- **[VERIFICATO: <URL>]** = pagina aperta davvero, contenuto letto.
- **[SNIPPET: <URL>]** = riassunto del motore di ricerca, pagina NON aperta.
  ⚠️ Il motore **mescola** le fonti del risultato: quando nello stesso elenco
  c'erano pagine non di Unger, scrivo **[SNIPPET, attribuzione incerta]**.
- **[TERZI: <URL>]** = fonte non di Unger (la formula di Ryan Jones, per esempio).
- **[INFERITO]** = dedotto da me, e dico da cosa.
- **[CASA: file r.N]** = letto nel nostro repo.

---

## 1. ✅ CONTROLLO POSITIVO E FONTI

| host | esito | cosa ha dato |
|---|---|---|
| **WebSearch** | ✅ funziona | 48 ricerche, EN + IT |
| `github.com` (ricerca repository) | ✅ PASS | `andrea unger` → **2 repo**: `ferranfont/Andrea_Unger_System` (Jupyter, "rotura de rango en velas de 5 min", dati ES 5 min 2024-2025, 4★, agg. **14/03/2025**, licenza **non visibile**) e un omonimo (simulatore SPICE, non c'entra). ⚠️ La **ricerca di CODICE** chiede il login: **nulla** |
| `github.com/ferranfont/Andrea_Unger_System` | ✅ aperta | 5 file (`.ipynb`, `.csv`, `.docx`, `.png`); **nessun** contenuto su sizing/OOS/WFA. È di un **ingresso**, fuori dal mio perimetro → la giro ai pilastri 1-3 |
| `mql5.com/en/articles/113` | ✅ aperta | ❌ **non contiene** Fixed Ratio (lo snippet lo diceva: **smentito dalla pagina**) |
| `mql5.com/en/articles/12550` | ✅ aperta | Poljakov, 07/06/2023: modelli di crescita lineare/esponenziale/iperbolica. **Niente Unger, niente Fixed Ratio** |
| `mql5.com/en/search` | 🟡 | restituisce il portale, **non i risultati** (motore JS): nullo |

### 🛑 Bloccati (`EGRESS_BLOCKED`, non 404, non 503 — "non da qui")
`ungeracademy.com` · `ungermethod.com` · `skilledacademy.teachable.com` ·
`onlinelibrary.wiley.com` · `www.wiley.com` · `books.google.com` ·
`catalog.libraries.psu.edu` · `www.amazon.com` · `www.abebooks.com` ·
`blackwells.co.uk` · `www.ecobook.com` · `www.barnesandnoble.com` ·
`www.booktopia.com.au` · `www.ebay.com` · `www.hoeplieditore.it` · `www.ibs.it` ·
`www.perlego.com` · `algoadvantage.substack.com` · `thealgorithmicadvantage.com` ·
`bettersystemtrader.libsyn.com` · `podcast24.co.uk` · `podcasts.apple.com` ·
`podtail.com` · `www.iheart.com` · `www.hvst.com` · `www.prorealcode.com` ·
`www.benzinga.com` · `www.multicharts.com` · `blog.ilgiornale.it` ·
`finanzaonline.com` · `www.tradingonlineguida.com` · `tradingstrategyguides.com` ·
`www.innovativeeducators.org` · `enlightenedstocktrading.com` ·
`learningcenter.fxstreet.com` · `tradingsuccess.com` (il PDF di Ryan Jones) ·
`www2.wealth-lab.com` · `www.tradingblox.com` · `fxdreema.com` ·
`www.straightforex.com` · `www.elitetrader.com` — **41 host**.

### 🚫 NON aperti di proposito (e perché)
- `scribd.com`, `pdfcoffee.com`, `silo.tips`, `gripsuccess.com`,
  `eforexstoore.com`, `coursehero.com`: offrono **copie o rivendite non
  autorizzate** del libro Wiley e dei corsi. Non si usano.
- `ungeracademy-com.translate.goog` (mirror via Google Traduttore) e
  `web.archive.org`: sarebbero un **aggiramento del blocco di rete**. Non si fa.
- `smtp.bardenay.com/free-minds/andrea-ungers-systematic-trading-a-deep-dive…`:
  🗑️ dominio incoerente col contenuto = **contenuto SEO generato**, stessa classe
  di `nutritionjobs.com` scartato il 14/09. ⚠️ Ed è sospettato di essere
  l'origine di alcuni snippet "troppo precisi" (v. §2.6): li declasso.

---

## 2. 💰 PILASTRO 4 — MONEY MANAGEMENT

### 2.0 Il libro: cosa sappiamo dell'indice
- Titolo esatto: **_The Successful Trader's Guide to Money Management: Proven
  Strategies, Applications, and Management Techniques_**, Wiley 2021, 320
  pagine, ISBN 9781119798804 **[SNIPPET: wiley.com, amazon.com]**. Il titolo
  "_The Successful Trader Foundation_" del mandato **non esiste** come libro nei
  risultati: è quasi certamente questo **[INFERITO]**.
- Capitoli: _Martingale and Anti-Martingale · The Kelly Formula · A Banal
  Trading System · Money Management Models · Refining the Techniques · The Monte
  Carlo Simulation · The Work Plan · Combining Forces · Money Management When
  Trading Stocks · Portfolio Management · Discretionary Trading · Questions and
  Answers_ + appendici **[SNIPPET: onlinelibrary.wiley.com/doi/book/10.1002/9781119798835]**.
- Sezioni: cap. 3 "A Banal Trading System" = sistema a medie mobili a cui
  applica Kelly; cap. 4 contiene **4.2 Optimal f** e **4.3 Secure f**
  **[SNIPPET: booktopia.com.au …/9781119798804.html]**.
- Il gemello italiano è il **_Trattato di Money Management_** (Hoepli, 2018):
  Fixed Fractional, Fixed Ratio, Percent Volatility; per il portafoglio **Core
  Equity, Total Equity, Reduced Total Equity** **[SNIPPET: hoeplieditore.it/…/9788820386412]**.

### 2.1 Tabella dei metodi, col confronto in casa

| # | metodo | formula / regola | numeri di Unger (etichettati) | già in casa? |
|---|---|---|---|---|
| **4.1** | **Fixed Fractional** | `lotti = equity × r / perdita_per_lotto_allo_SL` | "tipicamente **non più dell'1%** dell'equity per trade", "non più del **2%** per singolo trade" **[SNIPPET, attribuzione incerta: ungeracademy.com/posts/guide-to-position-sizing-…]** | ✅ **SÌ**. `ABTG_EMA200.mq5` r.467-495 `LotByRisk`: `risk = ACCOUNT_BALANCE × riskPct/100` (r.470), perdita per lotto da `OrderCalcProfit` (r.479). Rischio diviso fra gli ordini: `riskPct = InpRiskPercent/nOrders` (r.361). Noi **0,65%** (METRO_PROP r.53-72), lui ~1% → **noi più prudenti, e per un numero misurato** (p99 da 12,47% a ~8,1%) |
| **4.1b** | base del calcolo: **BALANCE** o **EQUITY**? | — | Unger dice "account **equity**" **[SNIPPET]** | 🟡 **diverso**: noi calcoliamo sul **saldo** (r.470), cioè ignoriamo il flottante. Con posizioni aperte in perdita, noi apriamo **più grande** di chi calcola sull'equity **[INFERITO dal codice]**. Non è un errore: è una scelta, e **non è dichiarata** da nessuna parte che io abbia trovato |
| **4.2** | **Percent Volatility** | `contratti = rischio_monetario_giornaliero / (ATR_giornaliero × Big_Point_Value)` | esempio di Unger Academy: con BTC che si muove **2.000 $/giorno** e rischio 2.000 $ → 1 BTC; se si muove **4.000 $** → mezzo **[SNIPPET: ungeracademy.com/blog/volatility-position-sizing-adapting-your-strategies-to-market-volatility]** | 🟡 **a metà, ed è una differenza che conta**. La nostra taglia normalizza sulla **distanza dello STOP**, la sua sulla **volatilità GIORNALIERA**. Coincidono **solo** se lo stop è `k × ATR` (EMA200: `InpSLatr=1.0` r.74 → sì). Per le sedie con stop da **range** o in **punti fissi** (aperture, ORB) **non coincidono**. 🟢 **Per una prop la nostra è quella giusta**: fissa la perdita allo SL, che è ciò che il muro misura; il Percent Volatility fissa la perdita **attesa in un giorno**, non quella **massima allo stop** **[INFERITO]** |
| **4.3** | **Fixed Ratio** (Ryan Jones) | si passa a **N** contratti quando il profitto cumulato `P ≥ Δ × N(N−1)/2`; inversa: `N = floor(0,5 + √(0,25 + 2P/Δ))` | Unger lo tratta nel libro **[SNIPPET: hoeplieditore.it, wiley.com]**; **nessun Δ di Unger trovato** `[INCERTO]` | ❌ **NO** in nessun EA **[INFERITO: nessun input "delta" letto nel vivaio che ho aperto]** |
| **4.4** | **Contratti fissi per gruppo di volatilità** | contratti per sistema scelti per fascia di "movimento medio giornaliero in dollari" | **1** contratto per sistema su DAX, crude, argento, oro, T-bond 30y; **2** su gas naturale, rame, soia, Euro FX; **3** sulla sterlina **[SNIPPET, attribuzione incerta: bettersystemtrader.com/016-andrea-unger/ e ungeracademy.com/blog/pyramiding-and-scaling-out]** | 🟢 **equivalente** al nostro rischio % costante: è il Percent Volatility **fatto a mano, a gradini interi** perché sui futures non esiste 0,37 contratti. Su CFD con lotto a passo 0,01-0,10 non serve **[INFERITO]** |
| **4.5** | **più sistemi sullo stesso mercato → taglia per sistema più bassa** | la taglia per sistema scende col numero di sistemi sullo strumento | nessun numero **[SNIPPET: bettersystemtrader.com/016-andrea-unger/]** | 🟡 **convergente, per un'altra strada**: noi non riduciamo la taglia, **capiamo il totale**: C1 al **3,25%** vivo (`ABTG_Guardian.mq5` r.153), C2 per cluster **firmato ma non attivo** (CLAUDE.md, 12/09), e la regola "mai due EA stesso segnale/simbolo/lato a rischio pieno". Misura di casa: `report/ORB_DOW_100K_COMPRESENZA_2026-09-13.md` |
| **4.6** | **Kelly / optimal f come TETTO, non come bersaglio** | `f* = W − (1−W)/b` (W = win rate, b = vincita media / perdita media) | "se l'optimal f è 27%, rischiare 30% non è più aggressivo: è oltre il precipizio" **[SNIPPET, attribuzione incerta — la stessa frase compare solo accanto al dominio SEO del §1]** | 🟢 **lo passiamo di un fattore 20-35, calcolato**: coi numeri di `report/AUDIT_USCITE_2026-09-09.md` r.101-104 → DAX con parziale `0,81 − 0,19/0,327` = **0,229**; DAX senza `0,74 − 0,26/0,525` = **0,245**; Dow con `0,729 − 0,271/0,473` = **0,156**; Dow senza `0,642 − 0,358/0,701` = **0,131**. Contro **0,0065** nostro **[INFERITO, aritmetica mia sui numeri di casa]**. ⚠️ Kelly presume trade indipendenti e edge stabile, e i nostri numeri sono **un solo regime**: è un tetto di un tetto, non una licenza |
| **4.7** | **Core / Total / Reduced Total Equity** (portafoglio) | quale "capitale" si usa per dimensionare il trade nuovo quando altri sono aperti | citati nel _Trattato_ **[SNIPPET: hoeplieditore.it]**; le **definizioni** non le ho lette da Unger: quelle standard (Van Tharp) sono *core* = capitale meno il rischio aperto, *total* = capitale + valore delle posizioni, *reduced total* = core + profitti bloccati dagli stop **[INFERITO: letteratura generale, NON verificato su Unger]** | 🟡 **a metà**: calcoliamo su **saldo** (≈ né core né total) e il C1 limita il rischio aperto **dall'esterno**. Un sizing su *core equity* farebbe da solo quello che il C1 fa col rifiuto: **restringe** i trade nuovi quando ce ne sono tanti aperti **[INFERITO]** |
| **4.8** | **Scaling out (uscite scaglionate)** | chiudere parte a un target, il resto dopo | "**l'uscita unica di solito rende di più**; i benefici dello scaling out sono **solo psicologici**" (ma accettabile se evita errori) **[SNIPPET: ungeracademy.com/blog/pyramiding-and-scaling-out e /it/blog/piramidare-e-scaglionare-uscite]** | ✅ **MISURATO, e il verdetto è misto**: `AUDIT_USCITE_2026-09-09.md` → R46a DAX PREVBAR **senza** parziale PF **1,49** contro **1,40** col parziale (r.59-60); R15 Dow: vince **parziale OFF** (r.136); R47: **pareggio**, "il parziale compra win rate vendendo payoff" (r.101-106); Fase F: vince la config **col** parziale, PF OOS **1,237** (r.133). 👉 **Unger ha ragione in 2 casi su 4 dei nostri**, non in tutti |
| **4.9** | **Piramidazione** | aggiungere unità sul movimento a favore | non gli piace; ha senso solo con controllo costante del rischio **[SNIPPET: ungeracademy.com/blog/pyramiding-and-scaling-out]** | ✅ **non la facciamo**. I 2 ordini di EMA200 sono pendenti **dall'inizio** con rischio **diviso** (r.361), non aggiunti sul movimento |

### 2.2 Le formule scritte per bene (con il contro-esempio)

**Fixed Ratio** [TERZI: Ryan Jones, _The Trading Game_; formula riportata da
`learningcenter.fxstreet.com/…/money-management-models/` — SNIPPET, pagina bloccata]

```
soglia(N)  = Δ × N × (N − 1) / 2          # profitto cumulato per poter usare N contratti
N(P)       = floor( 0,5 + sqrt(0,25 + 2 × P / Δ) )
in perdita : si scende di livello quando P torna sotto soglia(N)
```

🧪 **Contro-esempio fatto**: lo snippet di FXStreet riporta
`N = √(2 × P/Δ + 0,25)` **senza il +0,5**. Con Δ = 5.000 e P = 5.000 dà
`√2,25 = 1,5` → floor **1**, cioè **sbaglia** (a 5.000 di profitto i contratti
devono essere **2**). Con il +0,5: `0,5 + 1,5 = 2` ✅; e a P = 15.000:
`0,5 + √6,25 = 3` ✅, che è l'esempio "altri 10.000 per il terzo contratto"
riportato da un'altra fonte **[SNIPPET: collinseow.com/fixed-ratio]**.
**La formula senza +0,5 non va copiata.**

**Come si sceglie Δ**: "Δ = metà del max drawdown storico a 1 contratto" come
punto neutro, "75%" se aggressivi **[SNIPPET, attribuzione incerta — da una
pagina fra multicharts.com, trade2win.com, luxalgo.com, NON da Unger]**.

🏛️ **Riga prop** **[INFERITO]**: il Fixed Ratio sale a **gradini interi**
(1→2 contratti = ×2 la taglia in un colpo). FTMO voce 8 delle Forbidden
Practices: _"substantially larger … position sizes compared to other trades"_
(`report/METRO_PROP.md` r.534). Un raddoppio a gradino è esattamente il tipo di
salto che quella clausola discrezionale può leggere male. Il nostro rischio %
costante non ha salti.

**Percent Volatility** [SNIPPET: ungeracademy.com/blog/volatility-position-sizing-…]

```
lotti = rischio_monetario_giornaliero / (ATR_D1 × valore_monetario_di_1_punto_per_lotto)
```

Versione di casa, per confronto **[CASA: ABTG_EMA200.mq5 r.467-495]**:
```
lotti = (BALANCE × riskPct/100) / perdita_per_lotto(distanza_SL)
```
🧪 **Contro-esempio**: sedia con stop a **range** (apertura DAX), ATR_D1
invariato, range del giorno doppio → il Percent Volatility tiene **lo stesso
lotto** e la perdita allo stop **raddoppia**; la nostra **dimezza il lotto** e la
perdita allo stop resta **0,65%**. **Per il muro giornaliero conta la seconda.**
**[INFERITO, algebra delle due formule]**

### 2.3 Gestione del drawdown e "quando un sistema è rotto"

| # | regola Unger | fonte | già in casa? |
|---|---|---|---|
| **D1** | il **max DD storico è un riferimento, non una soglia assoluta**: sopra non si spegne in automatico, **si indaga** da dove viene la differenza | [SNIPPET: ungeracademy.com/blog/trading-strategies-in-drawdown-… e /posts/how-to-interpret-and-limit-the-drawdown-…] | ✅ **identico** al C3 corsia RISCHIO: _"DD forward > DD promesso → revisione IMMEDIATA; lo spegnimento resta parola di Claudio"_ (`report/FIRME_2026-08-18.md` r.30-32) |
| **D2** | la decisione va presa su **deviazione statisticamente significativa** dal backtest, non sul rumore | [SNIPPET, attribuzione incerta: ricerca "when to stop a trading system"] | 🟡 il C3 usa il DD promesso di **una sola sequenza** (quella del tester). In casa esiste già lo strumento per la banda: `backtest_pipeline/mc_dd_cella.py` (2000 rimescolamenti a blocchi di giorno, seme 42) — ma **non è agganciato** alla revisione C3 **[CASA]** |
| **D3** | 🔥 **il caso Benzina**: strategia in perdita/laterale per quasi **2 anni**; tre scenari: (1) sempre accesa, (2) **scartata** dopo **6 mesi consecutivi** in perdita/laterale, (3) **messa in pausa** dopo 6 mesi senza nuovi massimi e **riaccesa al primo nuovo massimo** della sua equity. Nel caso 3 il nuovo massimo arriva a **marzo 2022** e la riaccensione da **aprile** avrebbe dato risultati positivi | [SNIPPET: ungeracademy.com/blog/trading-strategies-in-drawdown-here-s-what-to-do-and-what-not-to-do-to-avoid-costly-mistakes] — ⚠️ **i numeri finali dei tre scenari NON li ho** `[INCERTO]` | 🟡 **a metà**: la nostra "porta di rientro" (_"rientra se una misura nuova le ridà una ragione"_, FIRME 18/08 r.44-45) è **qualitativa**. La sua è una **regola**: equity **ombra** + nuovo massimo. ⚠️ **Ma la finestra di 6 mesi è fuori scala per una challenge** che dura settimane |
| **D4** | tenere un **diario** e fissare prima il punto oltre il quale ci si ferma | [SNIPPET: ungeracademy.com/blog/when-to-stop-trading] | ✅ Guardian: pausa **4,0%**, emergenze **4,9 / 9,9%**, reset **23** (CLAUDE.md, firma 18/08; `ABTG_Guardian.mq5` r.130-153) + pagella serale |
| **D5** | **filtro sulla curva dell'equity** (sistema spento quando l'equity scende sotto la sua media) | ⚠️ **NON è di Unger**: lo snippet viene da `limituptrading.wordpress.com/2012/11/06/limiting-trading-strategy-drawdowns-with-an-equity-curve-filter/` **[TERZI]** | ❌ **non in casa**, e **non lo proporrei**: è un filtro **aggiunto dopo** a un motore già tarato, la classe che in casa ha fatto **0 su 5** (`report/ROBUSTEZZA.md` r.136-145) **[INFERITO]** |
| **D6** | **Monte Carlo** per vedere la **distribuzione** del DD, non il numero unico del backtest | [SNIPPET: ungeracademy.com/blog/monte-carlo-simulation-trading-system] — l'esempio "mediana 15%, p95 22%, peggiore 31%; dimensionare sul p90" è **[SNIPPET, attribuzione incerta]** (compare insieme a tradezella.com) | ✅ **più severi**: in casa si legge il **p99** (METRO_PROP r.23-25: p50 5,74 · p95 9,89 · **p99 12,47%** a rischio 1%), rimescolando **giorni interi** per tenere la correlazione dello stesso giorno (`mc_dd_cella.py` r.18-20), e con la versione trailing (`mc_trailing.py`) |
| **D7** | "sotto il 10% di DD di portafoglio = rischio gestito; sopra il 30% = sovraesposizione" | [SNIPPET: ungeracademy.com/posts/how-to-interpret-and-limit-the-drawdown-…] | ✅ il nostro muro **è** il 10% statico; la sua soglia "buona" è il nostro **pavimento duro** |

---

## 3. 🔬 PILASTRO 5 — OTTIMIZZAZIONE E VALIDAZIONE

### 3.1 🔎 La contraddizione del walk-forward (§3.1 del 14/09): **passo avanti, non chiusa**

- **Due pagine distinte** del suo sito, lette dal motore, dicono la stessa cosa:
  **Unger NON usa la walk-forward analysis**; la considera un buon metodo, ma
  **i sistemi del Metodo Unger usano condizioni di mercato (pattern) che non
  sono parametri adatti alla WFA** **[SNIPPET: ungeracademy.com/blog/walk-forward-analysis]**
  **[SNIPPET: ungeracademy.com/posts/how-to-use-walk-forward-analysis-you-may-be-doing-it-wrong — datata 15/10/2022]**.
- Al posto della WFA: **test di stabilità** (piccole variazioni attorno ai valori
  scelti) **+ out-of-sample** **[SNIPPET, attribuzione incerta: ricerca "Unger out of sample"]**.
- 👉 **Esito**: la frase del vecchio mandato (_"notoriamente un sostenitore del
  walk-forward"_) è **contraddetta da due snippet indipendenti del suo stesso
  sito**. Resta **[SNIPPET]**: si chiude solo aprendo la pagina 1 della lista
  del §7 del 14/09.
- **Noi**: facciamo **tutte e due** le cose (IS/OOS a finestre **e** altopiano).
  Su questo punto **siamo più larghi di lui**, non più stretti.

### 3.2 Tabella dei criteri di validazione

| # | criterio | Unger (etichettato) | casa | chi è più severo |
|---|---|---|---|---|
| **V1** | **scelta del valore sull'altopiano** | "cercare un'**area di stabilità** e prendere **il valore migliore dentro quell'area**"; un valore splendido circondato da valori molto peggiori **non è robusto** **[SNIPPET: ungeracademy.com/blog/how-to-optimize-stop-loss-in-a-trading-system — 21/09/2021]** | "**centro dell'altopiano, MAI il picco**" (CLAUDE.md, Emendamento A; `report/ROBUSTEZZA.md` r.56-60) | 🟢 **NOI**. Lui prende il **migliore dentro** l'altopiano, noi il **centro**. Ed è misurato che conta: in R70 i confronti fatti col picco **si sono ribaltati** rifatti con la regola del centro (CLAUDE.md, Emendamento A). ⚠️ **Differenza vera, da non confondere con una conferma** |
| **V2** | **a cosa serve l'ottimizzazione** | "non per trovare i valori migliori, ma per **capire il mercato**" (BST ep. 074, 10/02/2017) **[SNIPPET: bettersystemtrader.com/074-deeper-optimization-with-andrea-unger/]** | la griglia serve a leggere la **superficie**, e "non si allarga su un motore senza edge" (CLAUDE.md, Il limite) | 🤝 **stessa tesi** |
| **V3** | **numero minimo di trade** | "un minimo di **30 operazioni** per validare statisticamente" (intervista Radio 24) **[SNIPPET: ungeracademy.com/it/blog/trading-tante-operazioni-al-minuto-intervista-con-debora-rosciani-…]**; e altrove: "non c'è un numero valido per ogni sistema" **[SNIPPET: ungeracademy.com/blog/backtesting-in-trading-reliable-results]** | **≥ 150 in IS e ≥ 150 in OOS** (CLAUDE.md, Emendamento A; METRO_PROP r.335) | 🟢 **NOI, di 5 volte**. E in casa è misurato perché: con n = 75-159 la superficie di R70 era frastagliata |
| **V4** | **quota / collocazione dell'OOS** | l'OOS è **dato non usato per costruire**; il suo OOS più citato è il **tempo dopo lo sviluppo** (es. una strategia "out of sample da gennaio 2018") **[SNIPPET: ungeracademy.com/it/blog/migliori-strategie-di-trading-del-2022-…]**; **percentuale NON trovata** `[INCERTO]` | IS dimensionato su **operazioni**, collocazione **non decisa** e **dichiarata col regime** (Emendamento A) | 🤷 **non confrontabile**: il suo numero non c'è |
| **V5** | 🔴 **contaminazione dell'OOS** | "non basta che un periodo sia etichettato OOS: bisogna che **non abbia influenzato, nemmeno indirettamente**, lo sviluppo" **[SNIPPET: ungeracademy.com/blog/backtesting-in-trading-reliable-results e /it/blog/backtest-nel-trading-check-affidabile]** | ❌ **non c'è una regola**. E c'è un fatto **[CASA, contato oggi]**: su **981** file prova, **119** partono da `2025.06.10` (l'inizio della finestra OOS di casa) e **518** citano `2026.06.30`. **La stessa finestra OOS è stata guardata da centinaia di prove** | 🔴 **LUI**. È l'unico punto in cui la sua regola **morde su di noi** — v. Proposta 3 |
| **V6** | **numero massimo di parametri** | **nessun numero di Unger trovato** `[INCERTO]`. "Sotto 4, fino a 6 con esperienza" compare negli snippet ma **non è attribuibile a lui** (è accanto a fortraders.com / easylanguagemastery.com) **[SNIPPET, attribuzione incerta]**. Suo: l'esempio di un sistema sull'oro con **due sole regole** che è **puro overfitting** **[SNIPPET: ungeracademy.com/blog/overfitting-in-trading-systems-…]** | nessun tetto numerico; "poche regole, pochi parametri" (`ROBUSTEZZA.md` r.51-54) | 🤝 **pari**: nessuno dei due ha il numero, e il suo esempio dice che **il numero da solo non basta** |
| **V7** | **curva troppo liscia = allarme** | aggiungere filtro dopo filtro fino alla curva perfetta è un **segnale di overfitting** **[SNIPPET: ungeracademy.com/posts/how-to-avoid-overfitting-in-systematic-trading]** | "un filtro aggiunto dopo: **0 su 5**" (`ROBUSTEZZA.md` r.136-145, 185-188) | 🟢 **NOI**: lui lo dice, noi l'abbiamo **contato** |
| **V8** | **più mercati** | portafoglio di **30-40** futures, più tipi di strategia per mercato **[SNIPPET: ungeracademy.com/blog/trading-systems-robustness e il dossier del 14/09 §3.2]**; **se valida lo stesso sistema su mercati gemelli: NON trovato** `[INCERTO]` | i **simboli gemelli** sono il punto 4 del **certificato di morte** (CLAUDE.md, 09/09) | 🟢 **NOI** sulla regola scritta; lui sulla **larghezza** |
| **V9** | **Monte Carlo** | v. D6 | p99, giorni interi, statico e trailing | 🟢 **NOI** |
| **V10** | **ritiro in forward** | v. D1-D3: riferimento al DD storico + indagine; pausa e riaccensione su nuovo massimo | C3 a tre corsie (FIRME 18/08) | 🟡 **pari su D1**, **lui avanti** su D3 (la regola di rientro) |

---

## 4. 🧱 LA TABELLA DEI BUCHI (solo pilastri 4 e 5)

| meccanismo di Unger | noi | buco? | vale per il 1° ottobre? |
|---|---|---|---|
| Fixed Fractional ~1% | 0,65%, calcolato allo SL | ✅ no | — |
| Percent Volatility | rischio allo SL (coincide solo con stop ATR) | ✅ no, **la nostra è quella da prop** | — |
| Contratti per fascia di volatilità | rischio % continuo | ✅ no | — |
| Meno taglia con più sistemi sullo stesso mercato | C1 vivo, C2 firmato non attivo | 🟡 per altra via | no |
| Kelly come tetto | 0,65% contro Kelly 13-25% | ✅ no | — |
| Scaling out "solo psicologico" | misurato: 2 su 4 gli danno ragione | ✅ no | — |
| Max DD = riferimento, poi si indaga | C3 corsia RISCHIO | ✅ no | — |
| Monte Carlo del DD | p99 a giorni interi | ✅ no, **più severi** | — |
| ≥ 30 trade | ≥ 150 + 150 | ✅ no, **più severi** | — |
| Stabilità dei parametri | centro dell'altopiano | ✅ no, **più severi** | — |
| **Base del sizing: equity / core equity** | **saldo** | 🟡 **scelta non dichiarata** | no (è materia di taglia → Claudio) |
| **Banda statistica nella revisione C3** | DD di una sequenza sola | 🟡 lo strumento c'è, non è agganciato | marginale |
| **Regola di rientro (equity ombra + nuovo massimo)** | porta di rientro qualitativa | ❌ **manca** | **no** (finestra di mesi) |
| **Anti-contaminazione dell'OOS** | nessuna regola; la finestra OOS di casa è stata letta da centinaia di prove | ❌ **manca** | 🟠 **sì, indirettamente**: decide **quanto crediamo** ai numeri di contratto delle sedie |
| Fixed Ratio | assente | ❌ manca | **no**, e in prop ha il rischio della voce 8 FTMO |

---

## 5. 🛠️ LE PROPOSTE — solo METODO, mai taglia (max 3)

🔴 **Nessuna tocca un EA, un preset o un parametro in forward. Nessuna
raccomanda un valore di rischio: taglia e parametri di rischio sono di Claudio.**

### PROPOSTA 1 — l'OOS vergine: una finestra che nessuna prova ha mai guardato
```
COSA     Dichiarare "vergine" la finestra dal 01/07/2026 in poi (dopo la fine
         dell'OOS di casa, 2026.06.30) e usarla SOLO per il verdetto finale di
         una cella gia' scelta: una lettura sola, congelata prima, niente scelte
         dopo averla vista. Piu' un contatore: quante prove hanno letto ogni
         finestra OOS (dal REGISTRO_TEST / file prova).
DOVE     procedura (REGISTRO_TEST.md + una riga in CLAUDE.md se Claudio firma)
FONTE    V5 (Unger, "contaminazione dell'OOS") + conteggio di casa di oggi
COSTO    1-2 ore di script per il contatore. La finestra vergine esiste gia':
         ~3 mesi (luglio-settembre 2026), da scaricare sul PC di backtest.
         Round: 1 per sedia candidata, sul PC di backtest (MAI sul VPS, 21/09).
RISCHIO  (a) 3 mesi sono pochi: alla frequenza delle sedie di apertura
         (~0,6-0,84 op/g, CENSIMENTO_CONTRATTI_v2 r.215) sono ~40-55 operazioni,
         SOTTO il pavimento dei 150 -> giudica il RISCHIO, non il MERITO
         (regola B dell'Emendamento). (b) Gia' "sporcata" in parte: 18 file prova
         su 981 citano date luglio-settembre 2026 (almeno una volta solo in
         commento) -> il primo passo e' contarli bene, non dichiararla pulita.
```
🧪 **Contro-esempio che la proposta deve reggere**: se una cella scelta
guardando l'OOS di casa è **buona davvero**, sulla finestra vergine resta nella
sua banda di Monte Carlo; se era **fortunata**, esce dalla banda. Se le due
ipotesi dessero lo stesso numero, la finestra non misurerebbe niente — con
~40-55 operazioni la banda sarà **larga**, e va dichiarato prima.

### PROPOSTA 2 — misurare i modelli di sizing nel Monte Carlo della challenge, senza adottarne nessuno
```
COSA     Rendere intercambiabile la funzione di taglia in simula() di
         backtest_pipeline/mc_challenge_ftmo.py (oggi solo fisso-frazionale sul
         saldo, r.80-110) e confrontare, a PARITA' di sequenze e seme:
         (a) fisso-frazionale sul saldo (oggi), (b) taglia costante senza
         capitalizzazione, (c) Fixed Ratio con delta come multiplo del DD della
         cella, (d) base "core equity". Esce solo: % PASS / MORTE_GIORNALIERA /
         MORTE_STATICA / durata mediana.
DOVE     script Python sul PC o in sessione; zero EA, zero VPS
FONTE    §2.1 righe 4.1b, 4.3, 4.7
COSTO    2-4 ore di Python, zero tempo macchina del tester.
RISCHIO  eredita TUTTI i limiti dichiarati dello strumento (4 sedie su 6,
         P/L realizzato e non equity, un solo regime). Il numero e' un
         confronto FRA modelli, non una previsione. La scelta resta di Claudio.
```
🧪 **Contro-esempio obbligatorio prima di leggere un numero**: il modello (a)
deve **riprodurre al decimale** i numeri del 23/09 (stesso seme 11, stesse 20.000
sequenze); il Fixed Ratio con Δ → ∞ deve **coincidere** col modello (b). Se uno
dei due non torna, lo strumento è rotto e non si legge niente.

### PROPOSTA 3 — agganciare la banda di Monte Carlo alla revisione C3 (e scrivere la regola di rientro)
```
COSA     Quando una sedia fa scattare la corsia RISCHIO del C3, la revisione
         riceve accanto al DD promesso anche dove cade il DD forward nella
         distribuzione di mc_dd_cella.py (p50/p95/p99 della SUA cella). Il
         grilletto del C3 NON si sposta: cambia solo cosa si legge in revisione
         (la domanda di Unger: "dramma normale o edge cambiato?").
         Seconda meta', per la porta di rientro: equity OMBRA della sedia spenta
         (tester sul periodo di pausa, sul PC di backtest) e rientro solo a un
         suo nuovo massimo - il caso Benzina di Unger, con la finestra da
         ridefinire (6 mesi sono fuori scala per una challenge).
DOVE     procedura di revisione (FIRME 18/08) + script; nessun EA
FONTE    D2, D3
COSTO    meta' 1: 1-2 ore (lo strumento c'e'). Meta' 2: ~3 ore di script + 1
         corsa di tester per sedia spenta per mese.
RISCHIO  la tentazione di usare il p99 come NUOVO grilletto (= ammorbidire il
         C3): vietato, sarebbe abbassare l'asticella. La regola di rientro e'
         una firma nuova di Claudio.
```

📌 **Nessuna delle tre accende una sedia il 1° ottobre.** La 1 cambia **quanto
ci fidiamo** dei contratti; la 2 dà a Claudio un numero per decidere la taglia
(che resta sua); la 3 rende la revisione meno a occhio. Detto com'è: è
**ponteggio utile**, non avanzamento.

---

## 6. 📋 CONSUNTIVO

| misura | valore |
|---|---|
| ricerche WebSearch | **48** (EN + IT) |
| host provati con WebFetch | **43** |
| host raggiungibili | **2** (`github.com`, `mql5.com`) |
| host `EGRESS_BLOCKED` | **41** |
| host non aperti di proposito | **8** (6 copie/rivendite non autorizzate · 1 mirror di traduzione · 1 archivio) + 1 SEO scartato |
| pagine aperte con contenuto | **4** (2 GitHub, 2 MQL5) — **nessuna con parole di Unger** |
| snippet MQL5 smentiti dalla pagina aperta | **1** (art. 113: niente Fixed Ratio) |
| punti di metodo Unger censiti (righe del §4) | **15** |
| già in casa | **9** — di cui **4 più severi** noi (0,65% vs ~1%, p99 del MC, ≥150 vs 30 trade, centro vs migliore dell'altopiano); fuori tabella anche V7 (filtri **contati**: 0 su 5) |
| a metà | **3** (base equity/saldo, banda MC in revisione C3, più sistemi per mercato) |
| mancanti | **3** (anti-contaminazione OOS, regola di rientro, Fixed Ratio — quest'ultimo **non consigliato** in prop) |
| formule verificate con contro-esempio | **2** (Fixed Ratio: lo snippet senza +0,5 sbaglia; Percent Volatility vs stop a range) |
| proposte | **3**, solo metodo |
| contraddizioni aperte | **1** (WFA: due snippet del suo sito dicono "non la usa", il vecchio mandato diceva "sostenitore" → pende verso "non la usa", **non verificato**) |

### 📥 Cosa resta da aprire (per chi non ha il blocco — in aggiunta al §7 del 14/09)
| # | URL | cosa deve rispondere |
|---|---|---|
| 1 | `https://ungeracademy.com/blog/trading-strategies-in-drawdown-here-s-what-to-do-and-what-not-to-do-to-avoid-costly-mistakes` | 🔴 i **numeri** dei 3 scenari Benzina (sempre acceso / scartato / pausa+rientro) |
| 2 | `https://ungeracademy.com/blog/volatility-position-sizing-adapting-your-strategies-to-market-volatility` | la formula esatta: ATR di che periodo? giornaliero? |
| 3 | `https://ungeracademy.com/blog/how-to-optimize-stop-loss-in-a-trading-system` | "il migliore dentro l'area" o il centro? (V1) |
| 4 | `https://ungeracademy.com/blog/backtesting-in-trading-reliable-results` | la regola anti-contaminazione (V5) e se dà una **percentuale** di OOS |
| 5 | `https://bettersystemtrader.com/016-andrea-unger/` | la tabella contratti-per-sistema e la regola "più sistemi, meno contratti" verbatim |
| 6 | indice di _The Successful Trader's Guide to Money Management_ (Wiley) | "Refining the Techniques" e "Combining Forces": cosa c'è dentro |

---

_Nessun EA toccato. Nessun preset, nessun parametro in forward. Nessun acquisto.
Nessuna taglia raccomandata. Nessun commit (richiesta del chiamante)._
