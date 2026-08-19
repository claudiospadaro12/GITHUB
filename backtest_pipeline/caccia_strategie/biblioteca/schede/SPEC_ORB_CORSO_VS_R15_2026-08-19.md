# 📐 SPEC ORB DEL CORSO **vs** LA NOSTRA CELLA R15 — estrazione e confronto (19/08/2026)

_Materiale ORIGINALE caricato da Claudio il 19/08: (1) **ABTG ToolKit 05 — "ORB
Apertura America"**, 16 pagine, letto INTERO in sessione (blocchi 1-8 e 9-16);
(2) **ORB — Webinar Operativo 02.03.2026**, 18 slide, lette INTERE (blocchi 1-9 e
10-18). Autore dichiarato in calce a entrambi: **Emiliano Monza — Alfio Bardolla
Training Group**. (3) Input dell'indicatore **ORB_Indicator_V15 (v1.14)**
misurati da Claudio sugli screenshot della finestra parametri (NASUSD M15) e
passati alla sessione. (4) Il nostro `mql5/Experts/ABTG_ORB_Ottimizzato.mq5`
(letto per intero, 60 `input`) e i referti R7/R8/R14/R15/R16/R44/R54/R55._

> ⚠️ **Nota sulle date, prima di tutto.** Il frontespizio del ToolKit dice
> "WEBINAR OPERATIVO **2.3.2026**", ma il colophon di **entrambi** i documenti
> dice "Documento preparato per il Webinar Operativo del **02 Marzo 2025**".
> **[DICHIARATO, contraddittorio]** — è un refuso interno al materiale, non
> una nostra deduzione. Il titolo del file del webinar è `20260302`.

---

## 🔴 0. LA PRIMA COSA DA SAPERE: "IL CORSO" NON È UNA COSA SOLA

La premessa della missione ("il corso usa range 14:25-14:30, i 5 minuti
PRE-apertura") **è vera per l'INDICATORE e falsa per i due PDF**. Le tre fonti
del corso si contraddicono fra loro sulla regola più importante di tutte:

| fonte del corso | definizione del range | etichetta |
|---|---|---|
| **ToolKit 05, §2.1 + §6.2** | **30 minuti DOPO** l'apertura: 15:30 → 16:00 (= **14:30 → 15:00 server**) | [DICHIARATO] — "Non fate nulla tra le 15:30 e le 16:00. Questa mezz'ora serve solo per osservare. Il trading inizia DOPO." |
| **Webinar, slide 5 + 13** | **30 minuti DOPO** l'apertura: "S&P 500/NASDAQ: OR 15:30–16:00 CET" | [DICHIARATO] |
| **ORB_Indicator_V15 v1.14** (input misurati) | `InpTime1=14:25:00` → `InpTime2=14:29:59` = **5 minuti PRIMA** dell'apertura | [DICHIARATO da misura di Claudio sugli screenshot] |
| _(precedente storico)_ **ORB_Indicator_V05** | terza definizione ancora: 09:00–09:14:59, 15' a orari europei | [VERIFICATO] — annotato in `REFERTO_ROUND8_ORB_MANUALE.md` riga 15-16 |

> 🎯 **Conseguenza operativa.** Il default del nostro sorgente
> (`InpRangeStartMin=25`, `InpRangeEndMin=30`) combacia con **l'indicatore**,
> non con la didattica. E la didattica è l'unica delle tre che porta con sé una
> **tesi di mercato scritta** ("i primi 30 minuti filtrano il rumore iniziale").
> Quando in questo documento scrivo "il corso" senza specificare, intendo **i
> due PDF**; l'indicatore lo cito sempre per nome.

---

## A. OGNI REGOLA DEL CORSO, CON IL SUO VALORE

### A.1 Definizione del range

| voce | valore | fonte / etichetta |
|---|---|---|
| Durata OR | **30 minuti** (consigliata). Tabella alternative: 5' "bassa affidabilità, sconsigliato ai principianti" · 15' "media, trader con esperienza" · **30' "alta, CONSIGLIATO"** | ToolKit §2.1 · Webinar sl.5 [DICHIARATO] |
| Estremi | **massimo e minimo assoluti, OMBRE INCLUSE** ("Includete sempre le ombre (wick) delle candele, non solo i corpi") | ToolKit §2.2 punto 3 · Webinar sl.6 [DICHIARATO] |
| Timeframe del grafico | **M5** ("Impostate il grafico a 5 minuti") | ToolKit §2.2 punto 1 [DICHIARATO] |
| Operatività durante l'OR | **VIETATA** ("Non fate nulla tra le 15:30 e le 16:00") | ToolKit §2.2 [DICHIARATO] |
| Ampiezza del range: filtro? | **Nessuna soglia meccanica.** Il webinar dice solo che un OR che copre già il **70–80% dell'ATR** "suggerisce che gran parte del movimento è già avvenuto" (sl.12) e che "range troppo ampi riducono il R:R; range stretti possono mancare di slancio" (sl.17). Il case study chiama "molla compressa" un OR di 17 pt contro ATR medio 45 pt (sl.14) | [DICHIARATO come principio, **[BUCO]** come regola: nessun numero di taglio] |

### A.2 Orari e fuso — con il fuso DICHIARATO (lezione B3)

| voce | valore | etichetta |
|---|---|---|
| Apertura USA | **15:30 ora italiana / 9:30 EST**, esplicitamente scritto così | ToolKit §2.1 [DICHIARATO, fuso dichiarato dall'autore] |
| Webinar | "15:30 **CET** / 9:30 EST"; DAX "OR 09:00–09:30 CET"; Londra "08:00 CET" | sl.5, sl.13 [DICHIARATO] |
| **Conversione a ora server BCM** | ora italiana − 1 → **OR = 14:30 → 15:00 server**; DAX = 08:00–08:30 server; Londra = 07:00 server | [INFERITO] dalla regola di casa (CLAUDE.md, fuso BCM) |
| Fine giornata / orario di chiusura forzata | **[BUCO] nei due PDF.** Nessuna regola di chiusura a orario. Il ToolKit chiude il trade solo su TP/SL/trailing; l'esempio §6.6 chiude in TP alle 17:30 | [BUCO] |
| Fine giornata **nell'indicatore** | `InpTimeEnd = 22:59:59` server | [DICHIARATO da misura] |
| Finestra di caccia al breakout | **[BUCO]**: nessun limite dichiarato entro cui il breakout deve avvenire | [BUCO] |

### A.3 Ingresso

| voce | valore | etichetta |
|---|---|---|
| Trigger | **CHIUSURA di una candela M5 oltre il livello**, non il tocco. "Non basta che il prezzo tocchi il livello; la candela deve chiudersi al di sopra" | ToolKit §4.1/§4.2 [DICHIARATO] |
| Il tocco è un errore | Sì, **esplicito**: "Entrare prima della chiusura della candela" è **l'errore comune n. 1** (ToolKit §7.1) | [DICHIARATO] |
| Prezzo d'ingresso | **alla chiusura** della candela di rottura (esempio: rottura chiude 5.289 → ingresso 5.289) | ToolKit §6.4 [DICHIARATO] |
| Corpo della candela | "**corpo ampio**", "ombre contenute". **Nessuna percentuale** | ToolKit §4.1.3 · Webinar sl.7/sl.8 [DICHIARATO qualitativo, **[BUCO]** quantitativo] |
| Volume | **Webinar**: picco di volume **+50–100% rispetto alla media precedente** (sl.7); tabella sl.8: valido = "elevato, in aumento", falso = "basso o decrescente"; sul forex si usa il **Tick Volume** di MT4/5 come proxy | [DICHIARATO] — ⚠️ **il ToolKit NON menziona mai il volume** |
| Numero di ordini | **Nessun ordine pendente OCO.** L'ingresso è discrezionale a conferma avvenuta | [INFERITO] dall'assenza totale di pendenti nei due PDF + "Limit Orders Only" (sl.15) |
| Tipo d'ordine | **Webinar sl.15: "Limit Orders Only" — "esclusivamente ordini limite per l'ingresso. Gli ordini a mercato all'apertura espongono a slippage che distrugge il R:R calcolato"** | [DICHIARATO] ⚠️ e **contraddice** l'ingresso "alla chiusura della candela" del ToolKit: un limite si compila solo su ritracciamento. Coerente solo con la variante Fibonacci (A.7) |
| Buffer/distanza oltre il livello | **[BUCO] nei PDF.** Nell'**indicatore**: `InpEntryPoints = 10.0` moltiplicato per il coefficiente K dello strumento | [DICHIARATO da misura] |

### A.4 Stop loss

| voce | valore | etichetta |
|---|---|---|
| Regola base | **Long: appena SOTTO il Minimo del Range, 5–10 pip/punti sotto.** Short: appena SOPRA il Massimo del Range, 5–10 sopra | ToolKit §5.1 [DICHIARATO] |
| Esempio numerico | Ingresso 5.289, min OR 5.268, **SL 5.265 = 3 punti di margine**, distanza 24 punti | ToolKit §6.5 [DICHIARATO] ⚠️ 3 punti, non 5–10: **l'esempio non rispetta la propria regola** |
| Tesi dello stop | "se il prezzo torna dall'altra parte del range, il breakout non era reale e la nostra tesi è sbagliata" | ToolKit §5.1 [DICHIARATO] |
| Spostare lo stop | **VIETATO** in modo assoluto: "MAI SPOSTARE LO STOP LOSS!... Lo stop si imposta UNA volta e non si tocca più" (§5.1 e errore comune n.3). ⚠️ Il documento **non distingue** fra allargare (che condanna) e stringere: il trailing di §5.2/sl.12 lo contraddice formalmente | [DICHIARATO, internamente contraddittorio] |
| Variante Fibonacci | SL **oltre il 78,6% di Fibonacci** o sotto lo swing low/high recente | Webinar sl.12 [DICHIARATO] |
| Stop virtuale? | No: SL vero, ordine automatico ("Ordine automatico che chiude il trade in perdita") | Glossario [DICHIARATO] |

### A.5 Target, gestione, trailing, parziali

| voce | valore | etichetta |
|---|---|---|
| Target minimo | **R:R 1:1,5** ("Se rischiate 20 punti, target almeno 30") | ToolKit §5.2 [DICHIARATO] |
| Target ideale | **R:R 1:2** | ToolKit §5.2 · Webinar sl.12 ("minimo 1:2. Senza questa asimmetria la profittabilità a lungo termine non è sostenibile") [DICHIARATO] ⚠️ i due PDF **non concordano**: 1,5 minimo per il ToolKit, 1:2 minimo per il webinar |
| Target in multipli del RANGE | **[BUCO] — mai menzionato.** Il corso ragiona solo in R sullo stop | [BUCO] |
| Trailing | "**Alternativa semplice: usate la EMA 21 come trailing stop naturale.** Quando il prezzo chiude una candela dall'altra parte della EMA 21 rispetto alla vostra posizione, chiudete il trade" | ToolKit §5.2 [DICHIARATO] ⚠️ **EMA 21**, non 9 |
| Trailing (webinar) | Dopo TP1, trailing dinamico **sulle EMA. Uscita se una candela M5 chiude oltre la EMA 9 in direzione opposta; la EMA 21 come filtro secondario** | sl.12 [DICHIARATO] ⚠️ **EMA 9**, non 21 |
| Parziale | **Sì, ma solo nel webinar**: TP1 → poi runner col trailing. **Nessuna percentuale dichiarata** | sl.12 [DICHIARATO qualitativo, **[BUCO]** quantitativo] |
| Breakeven | **[BUCO] in entrambi i PDF ORB.** (Sta nella Masterclass Golden Cross cap.14, altro documento) | [BUCO] |
| TP1 della variante Fibonacci | **Livello 0% di Fibonacci** = il massimo/minimo raggiunto dopo il breakout, prima del pullback | sl.12 [DICHIARATO] |

### A.6 Filtri

| filtro | valore | etichetta |
|---|---|---|
| **Medie mobili — "REGOLA D'ORO"** | **EMA 9 ed EMA 21 sul grafico M5.** Long solo se EMA9 > EMA21 **E** prezzo sopra ENTRAMBE. Short solo se EMA9 < EMA21 **E** prezzo sotto entrambe. **Medie intrecciate o prezzo in mezzo → NESSUNA operazione** | ToolKit §3.2/§3.3 [DICHIARATO] — "Non operate MAI contro le medie... Questo singolo filtro vi risparmierà molte perdite" |
| **Volume** | +50–100% sulla media precedente (webinar); "Volume > Media 20 giorni" nella tabella sl.11 | Webinar sl.7/sl.11 [DICHIARATO] · assente nel ToolKit |
| **EMA lunga / 200** | **[BUCO]. Mai menzionata.** Il corso non ha nessun filtro di trend superiore alla EMA21 | [BUCO] |
| **Notizie** | "**se ci sono notizie rosse nel calendario economico nelle prossime 2 ore, non operate**" (errore comune n.6 e checklist FASE 1) | ToolKit §7.6/§8.1 [DICHIARATO] ⚠️ **ma il case study del webinar (sl.14) fa esattamente il contrario**: opera in una "giornata con rilascio dati CPI USA (alta volatilità attesa)" |
| **Trend superiore** | Checklist webinar O3: "H4/Daily coerente con direzione trade" | sl.16 [DICHIARATO qualitativo, **[BUCO]** meccanico] |
| **MACD** | "curl verso la linea mediana nella direzione del trade, oppure divergenza positiva col prezzo" — solo variante Fibonacci | sl.10/sl.11 [DICHIARATO qualitativo, **[BUCO]** meccanico] |
| **Catalizzatori stagionali** | **Triple/Quadruple Witching**: terzo venerdì di **marzo, giugno, settembre, dicembre** → "breakout particolarmente solidi". **MSCI Rebalance**: **febbraio, maggio, agosto, novembre** | sl.11 [DICHIARATO] |

### A.7 La variante avanzata: ORB + Fibonacci (solo webinar)

> _"Il breakout è il segnale. Il ritracciamento è l'entrata."_ (sl.9)

- **Fibonacci long**: tracciato dal **Session Low** al massimo raggiunto dopo il
  breakout rialzista. Short: dal Session High al minimo dopo il breakout. [DICHIARATO]
- **Golden Zone = 50%–61,8%.** Ingresso su ritracciamento in quella fascia. [DICHIARATO]
- **Tre condizioni simultanee** (sl.10): (1) test della Golden Zone — le wick che
  "pungono" la zona senza chiusure profonde oltre il 61,8% confermano il rispetto;
  (2) **candela di forza** che chiude attraversando il livello Fib del pullback;
  (3) **confluenza oscillatore**: MACD in curl o divergenza.
- **SL oltre il 78,6%** · **TP1 al livello 0%** · runner col trailing EMA. [DICHIARATO]
- **NO TRADE** se rottura del 61,8% senza recupero, o oscillatore piatto. (sl.11)
- **"No chasing"**: se il prezzo parte senza ritracciare nella Golden Zone,
  **il trade è perso e non si insegue**. (sl.15)

### A.8 Money management e regole di NON ingresso

| voce | valore | etichetta |
|---|---|---|
| Rischio per trade | **1–2% massimo del capitale totale**, "la regola più importante in assoluto" | ToolKit §5.3 [DICHIARATO] |
| Position sizing | dimensione = rischio€ ÷ distanza SL. Tabella: 10.000€ · 2% · SL 20 pt → 10€/punto; SL 40 pt → 5€/punto | ToolKit §5.3 [DICHIARATO] |
| Sizing (webinar) | "**rischio monetario costante indipendentemente dall'ampiezza dell'OR**. Range ampio → posizione ridotta" | sl.12 [DICHIARATO] |
| Numero di trade | **"Un trade alla volta — un solo setup per sessione"** | sl.15 [DICHIARATO] |
| Perdite consecutive / stop giornaliero | **[BUCO] nei due PDF ORB** | [BUCO] |
| **NON si entra se:** | (a) medie intrecciate o prezzo in mezzo · (b) la candela chiude DENTRO il range · (c) corpo piccolo con ombra lunga che attraversa il livello · (d) il breakout è contro le medie · (e) notizie rosse entro 2 ore · (f) [Fibo] niente pullback in Golden Zone · (g) "**Non tutti i giorni producono un segnale valido... Restare fuori è a costo zero**" | ToolKit §4.3/§7 · Webinar sl.15 [DICHIARATO] |

### A.9 Mercati e coefficienti

| voce | valore | etichetta |
|---|---|---|
| Mercati dichiarati | **Indici** (DAX, S&P 500, NASDAQ) — "candidati ideali, volume reale disponibile" · **Gold** · **coppie Forex majors** (EUR/USD, GBP/USD, USD/JPY) | Webinar sl.4/sl.13 [DICHIARATO] |
| Sessioni per mercato | DAX **09:00–09:30 CET** · S&P/NASDAQ **15:30–16:00 CET** · Gold: OR **dall'apertura di New York** · Forex: OR dall'apertura di **Londra (08:00 CET)** o New York | sl.13 [DICHIARATO] |
| Nota di correlazione | "correlazione inversa DAX/Euro (~70%)" | sl.13 [DICHIARATO dall'autore, **NON verificato da noi**] |
| **Coefficienti K** | **[BUCO] nei PDF.** Stanno solo nell'indicatore: indici/oro (D30EUR, SPXUSD, U30USD, NASUSD, XAUUSD) **K=1.0** · 225JPY **K=10.0** · coppie JPY **K=0.01** · forex majors/cross **K=0.0001** · USOIL/UKOIL **K=0.01** | [DICHIARATO da misura di Claudio] |
| Altri input indicatore | `InpEntryPoints=10.0` · `InpHistoricalDays=5` · box/linee/alert long-short attivi, cooldown 300 s · **licenza scadenza 2026.12.31, ID istanza ORB1** | [DICHIARATO da misura] |

### A.10 I numeri degli esempi — **dichiarati dall'autore, NON verificati**

- **ToolKit §6** (S&P 500): OR 5.268–5.285 = **17 punti**; ingresso long **5.289**;
  SL **5.265** (−24 pt); TP **5.337** (+48 pt); **R:R 1:2**; esito +48 punti.
- **Webinar sl.14** (E-mini S&P, giornata CPI): OR 17 pt **contro ATR medio 45 pt**;
  breakout 16:05 con **volume +80%**; pullback 16:20 al **56,7% Fib**; entry 16:25 a
  **5.289**; SL **5.274**; TP1 **5.298**; uscita **5.312**; **profitto 23 pt, rischio
  15 pt, R:R 1:1,53**.

> 🔴 Sono **esempi didattici a esito noto**, non un backtest. Zero peso nel
> punteggio, come da regola di casa. Notare che il webinar dichiara 1:1,53 su
> uno schema che a slide 12 pretende "minimo 1:2".

---

## B. TABELLA A TRE COLONNE — corso vs noi

Colonna "nostro": `ABTG_ORB_Ottimizzato.mq5` v1.01, magic **770611**, come pinnato
nella cella **R15** (`prove/R15_ORB_gestione_DD.txt` + `report/DEPLOY_GUARDIANO_100K.md`
riga 153) e in campo sul 100k a **0,3%**.

| # | regola | CORSO (PDF + indicatore) | NOSTRO EA / cella R15 | etichetta |
|---|---|---|---|---|
| 1 | **Durata OR** | **30'** (PDF) · **5' pre-apertura** (indicatore) | **15'** — 14:30→14:45 server | **DIVERSO** su tutte e tre le versioni |
| 2 | **Posizione OR** | **DOPO** l'apertura (PDF) · **PRIMA** (indicatore) | **DOPO** l'apertura | UGUALE al PDF · DIVERSO dall'indicatore |
| 3 | **Default del nostro sorgente** | 14:25→14:30 (indicatore) | `InpRangeStartMin=25 / EndMin=30` = **identico all'indicatore** | UGUALE all'indicatore — ma **NON è la cella viva** |
| 4 | Estremi con le ombre | sì | sì (`iHighest`/`iLowest` su M1, righe 259-263) | **UGUALE** |
| 5 | TF di esecuzione | M5 | M5 (`InpExecTF=PERIOD_M5`) | **UGUALE** |
| 6 | **Trigger d'ingresso** | **chiusura M5 confermata** oltre il livello; il tocco è "l'errore n.1" | **pendente STOP al tocco** (`InpUseCloseConfirm=0`), buffer 10×K | **DIVERSO — e siamo dalla parte che il corso condanna** |
| 7 | Ingresso a chiusura confermata: esiste? | — | **sì, implementato** (`TryCloseConfirmEntry`, righe 391-450) ma **spento** nella cella viva | SOLO-CORSO nel comportamento, presente nel codice |
| 8 | Corpo minimo della rottura | "ampio", nessun numero | `InpMinBodyPct=50` — **numero nostro**, attivo solo in close-confirm | **SOLO-NOSTRO** (quantificazione) |
| 9 | **Filtro EMA 9/21** ("regola d'oro") | **obbligatorio** | `InpUseEmaFilter=0` — **SPENTO** | **DIVERSO** |
| 10 | **Filtro EMA 200** | **inesistente nel corso** | `InpUseEma200Filter=1` — **è il cuore della cella R15** | **SOLO-NOSTRO** |
| 11 | **Filtro volume** | webinar: **+50%** sulla rottura | `InpUseVolumeFilter=0` — spento (esiste, `InpVolMult=1.5`, `InpVolAvgBars=20`) | **DIVERSO** |
| 12 | **Stop loss** | **estremo opposto del range + 5–10 punti** | **50% dell'ampiezza del range** (`InpSLMode=3`) — molto **più stretto** | **DIVERSO — differenza strutturale** |
| 13 | Buffer sullo stop | 5–10 punti | **non esiste l'input** nel lab (c'è in `ABTG_ORB_Fibo`: `InpSLBufferPts`) | **SOLO-CORSO** |
| 14 | **Target** | **R:R 1:1,5 minimo / 1:2 ideale, sempre in R sullo stop** | **1,5 × l'ampiezza del RANGE** (`InpTPMode=1`, `InpTPRangeMult=1.5`) | **DIVERSO — unità di misura diversa** |
| 15 | Parziale | webinar sì (TP1), % non dichiarata | **`InpTP1Pct=0` — nessun parziale** (R15: il parziale 50% a 1R "indebolisce l'IS ovunque") | **DIVERSO, e per misura nostra** |
| 16 | Breakeven | [BUCO] | `InpBreakeven=1`, ma **inerte** senza parziale | SOLO-NOSTRO |
| 17 | Trailing | ToolKit: **EMA 21** · webinar: **EMA 9** | **EMA 9** (`InpUseTrailEMA=1`, `InpEmaFast=9`) | **UGUALE al webinar** · diverso dal ToolKit |
| 18 | Uscita su chiusura oltre l'EMA | ToolKit: sì (EMA21) · webinar: sì (EMA9) | `InpExitOnEmaClose=0` — **spenta** | **DIVERSO** |
| 19 | **Lati** | **simmetrico** long+short | **SOLO LONG** (`InpAllowShort=0`) | **DIVERSO — e misurato**: R54b, short OOS PF **0,840** su n=73, bocciato per merito |
| 20 | **Filtro ampiezza del range** | principio ATR 70-80%, nessuna soglia | **tetto 0,8% del prezzo** (`InpMaxRangePct=0.8`); esiste anche il pavimento `InpMinRangePct` | **SOLO-NOSTRO** (quantificazione di un principio del corso) |
| 21 | **Fine giornata** | [BUCO] nei PDF · **22:59** nell'indicatore | **21:00** (`InpEndHour=21`) | **DIVERSO** |
| 22 | Un trade per sessione | sì ("un solo setup per sessione") | sì (`InpOneTradePerDay=1`, **fix 08/08**: cancella il pendente opposto) | **UGUALE** |
| 23 | Rischio | 1–2% | **% dell'equity**; R15 all'1%, in campo sul 100k a **0,3%** | UGUALE come forma, **più prudente** come taglia |
| 24 | Sizing su range ampio | "range ampio → posizione ridotta" | automatico: `lotto = rischio / distanza_stop` (riga 603) | **UGUALE nella sostanza** |
| 25 | **Filtro notizie** | "no trade se rosse entro 2 ore" | esiste (CSV, `InpNewsBeforeMin/AfterMin=30`) ma **`InpUseNewsFilter=0`** | **DIVERSO** — il corso lo pretende, noi lo teniamo spento |
| 26 | **Fibonacci / Golden Zone** | il cuore della variante avanzata | **assente** nel lab (esiste in `ABTG_ORB_Fibo.mq5`, 48 input, mai misurato sul Dow) | **SOLO-CORSO** per la sedia viva |
| 27 | "Limit orders only" | sl.15, esplicito | **pendenti STOP** — l'opposto | **DIVERSO** |
| 28 | Catalizzatori (witching, MSCI) | dichiarati | **assenti** | **SOLO-CORSO** |
| 29 | **Modello di slippage** | — | `InpSlippagePts` (R55), default 0 | **SOLO-NOSTRO** |
| 30 | **Guardian del conto** | — | `ABTG_GuardiaIngresso` (firme B1/C1 del 18/08) | **SOLO-NOSTRO** |
| 31 | Simbolo | S&P/NASDAQ/DAX/Gold/Forex | **U30USD** (Dow) — mai nominato dal corso | **SOLO-NOSTRO** |
| 32 | Export per-trade | — | `ExportTrades()` per il DD di portafoglio | **SOLO-NOSTRO** |

### B-bis. Il punto centrale, in due elenchi

**🔵 Cosa ha il corso che NOI NON ABBIAMO MAI MISURATO SUL DOW** (le dimensioni
inesplorate della cella R15 — tutte verificate una per una nei file prova):

1. **Ingresso a chiusura confermata** (`InpUseCloseConfirm=1`): misurato su
   NASUSD (R8), oro e forex (R10, R45a/b/c). **MAI su U30USD** — grep su tutti i
   file prova: le 8 prove Dow hanno `InpUseCloseConfirm=0`.
2. **Filtro EMA 9/21** (`InpUseEmaFilter=1`): **mai acceso in nessuna prova sul Dow**.
3. **Filtro volume** (`InpUseVolumeFilter=1`): misurato su NASUSD (R8: unico
   ingrediente che migliora tutti e 4 i confronti) e Londra. **Mai sul Dow.**
4. **OR da 30'** (14:30→15:00): mai sul lab ORB al Dow. R35 ha spazzolato 15-60'
   ma su un **altro EA** (`ABTG_Dow_Apertura_US`, motore **retest**, input
   `InpRangeMinutes`) — non è lo stesso esperimento.
5. **OR pre-apertura 14:25→14:30 sul Dow**: mai. Esiste solo su NASUSD (R7a).
6. **Fine giornata 22:59** invece di 21:00: **mai misurata da nessuna parte** —
   tutte e 8 le prove Dow hanno `InpEndHour=21`.
7. **Stop all'estremo opposto + buffer 5–10 punti**: l'input non esiste nel lab.
8. **Target in R** (1,5R / 2,0R) sulla cella R15 gestita: R15 e R44 hanno mosso
   solo `InpTPRangeMult` (multipli del range), non `InpTP_R`.
9. **Filtro notizie acceso**: mai, su nessun EA della famiglia.
10. **Golden Zone Fibonacci sul Dow**: `ABTG_ORB_Fibo` non ha mai visto U30USD.

**🟢 Cosa abbiamo NOI che il corso non prevede** (e che regge, per misura):

1. **EMA 200 come filtro direzionale** — il corso si ferma alla 21. In R14/R15 è
   il pilastro della pista: senza, la regione non passa il banco vergine.
2. **Solo long** — il corso è simmetrico; noi lo abbiamo **misurato** (R54b) e lo
   short è bocciato per merito, non per prudenza.
3. **Target in multipli del RANGE** invece che in R — R13/R15/R44.
4. **Tetto sull'ampiezza del range 0,8%** — quantifica il principio "molla
   compressa" che il corso enuncia senza numero.
5. **Niente parziale** — contro il webinar, e per misura (R15).
6. **Chiusura forzata alle 21:00**.
7. **Rischio 0,3%** invece di 1–2%: mezzo peso, per il doppio asterisco di R15.
8. **Modello di slippage** (R55), **export per-trade**, **Guardian**, e il fix
   `InpOneTradePerDay` — che l'EA del corso non aveva (bug del pendente
   superstite, costato il "si gira e ristoppato" visto live il 06/08).

---

## C. LE DIMENSIONI INESPLORATE — le celle candidate per un R88

⚠️ **Regola di casa da tenere in testa mentre si legge**: nel progetto il
**filtro aggiunto DOPO a un motore già tarato ha 0 successi su 5** (R20 ADX,
R12, R26, R45, R54), mentre il filtro **costitutivo** ha dato il miglior
risultato del progetto. Le celle 1 e 2 qui sotto **non sono filtri appiccicati**:
cambiano il trigger e la geometria del rischio. Le celle 5 e 6 **sono** filtri
appiccicati, e partono con quel precedente contro.

### 🥇 Cella 1 — LO STOP LARGO DEL CORSO (la più promettente, e non è un'opinione)

**Asse**: `InpSLMode` = 3 (50% range, cella viva) **vs** 0 (estremo opposto) —
più un **input nuovo** `InpSLBufferPts` per i "5–10 punti" del ToolKit (già
scritto in `ABTG_ORB_Fibo.mq5`, da portare nel lab: ~10 righe).

**Perché prima di tutte le altre, con tre fatti convergenti:**
- **R55** ha misurato che l'ORB *"non muore di PF, muore di drawdown"*: sfonda il
  10% con **1,5 punti indice** di slippage, con una sensibilità **11 volte** quella
  del PTE, **e la causa è nominata: lo stop al 50% del range è strettissimo**
  (`lotto = R / distanza_stop`).
- **`report/ORB_100K_CRITERI.md` punto D**, congelato il 15/08, indica già questa
  strada: _"la via coerente con R55 non è abbassare ancora il peso: è ALLARGARE
  LO STOP... ma è un cambio di parametro, e richiede il suo round"_. **Questo è
  quel round.**
- **R15 punto 3** ha già visto OPPRANGE + trailing + EMA200 fare **OOS +1.807,
  PF 1,68, DD 4,1%** — cioè **meno di metà del DD della cella promossa (9,92%)**
  con PF equivalente. Fu scartato perché *"lì l'IS è rosso o piatto"*. Ma per il
  **cancello prop** un DD del 4,1% è un mondo diverso, e l'**Emendamento della
  Finestra punto B** (16/08) dice che il vecchio giudica il rischio e il recente
  il merito. **Quella cella va riletta con la regola nuova.**

**Griglia proposta**: `InpSLMode` {0, 3} × `InpSLBufferPts` {0, 5, 10, 20} ×
`InpTPRangeMult` {1.0, 1.5} = 16 celle, tutto il resto pinnato R15.
**Stima**: è l'asse che può spostare il DD dal 9,92% a metà, cioè l'unico che
riporta l'ORB dentro il muro prop con margine invece che per 8 centesimi.

### 🥈 Cella 2 — LA RICETTA COMPLETA DEL CORSO SUL DOW

**Asse**: `InpUseCloseConfirm` {0,1} × `InpUseVolumeFilter` {0,1} ×
`InpUseEmaFilter` {0,1} = 8 celle, gestione R15 pinnata (SL 50% range, TP 1,5×,
trailing EMA9, EMA200, tetto 0,8%, solo long, 21:00).

**Perché**: R8 ha misurato questa ricetta su **NASUSD** e ha trovato che il
filtro volume *"migliora tutti e quattro i confronti, uniformemente, in entrambe
le finestre"* — portando l'ORB da −1.477 IS a DD 4-5%. Ma su NASUSD **non c'era
edge da amplificare** (PF OOS 1,02-1,03 = pareggio). **Sul Dow l'edge c'è**
(PF OOS 1,657) e l'ingrediente non è mai stato provato lì.
**Il rischio dichiarato**: la chiusura confermata **riduce il numero di trade**
(entra più tardi e salta i giorni deboli) — con n=119 OOS oggi, dimezzarlo porta
sotto la soglia dei 150 trade dell'Emendamento della Finestra. Da dichiarare
**prima**, non dopo.
**Bonus di segno opposto — e va detto**: entrare a mercato su chiusura confermata
invece che con un pendente STOP **cambia il profilo di slippage** che R55 ha
marcato come il punto debole di questa sedia.

### 🥉 Cella 3 — LA GEOMETRIA DEL RANGE SUL LAB, AL DOW, A PARITÀ DI GESTIONE

**Asse**: la finestra dell'OR, quattro valori mai confrontati fra loro su U30USD
a tick reali con la gestione R15 addosso:
- **14:25→14:30** (5' pre-apertura: indicatore + default del nostro sorgente)
- **14:30→14:45** (15': la cella viva)
- **14:30→15:00** (30': **la regola dei due PDF**)
- **14:30→15:05** (35': la durata validata sulla famiglia Apertura)

**Perché**: è il confronto che la missione chiedeva e che **non esiste in
archivio**. R7a/R7b lo hanno fatto su **NASUSD** e su un EA **senza gestione**,
concludendo che la geometria post-apertura *"ferma l'emorragia ma non crea un
edge"*. Su Dow, con EMA200 + trailing, la domanda è aperta.
**Stima**: promettente per capire *perché* funziona, meno per il DD. Attenzione:
il pre-apertura porta con sé uno stop strutturalmente più stretto (range di 5
minuti) → per R55 è la direzione **sbagliata** sul rischio. Da girare comunque,
perché è il default del nostro sorgente e sapere che è peggio ha valore.

### Cella 4 — FINE GIORNATA 21:00 vs 22:59 (asse più economico di tutti)

**Asse**: `InpEndHour/Min` {21:00, 22:00, 22:59}. **Mai misurato in nessun
round**, su nessun simbolo. Due input, zero codice.
**Perché conta per le prop**: allungare la giornata dà al runner col trailing
EMA9 due ore in più di corsa, ma espone alla chiusura USA. È un asse che tocca
**direttamente la peggior giornata**, che è il muro che butta fuori.
**Stima**: basso costo, effetto probabilmente piccolo sul PF e non nullo sul DD
giornaliero. Buon candidato da attaccare come asse secondario alla Cella 1.

### Cella 5 — TARGET IN R INVECE CHE IN MULTIPLI DEL RANGE

**Asse**: `InpTPMode` {0 (R), 1 (range)} × `InpTP_R` {1.5, 2.0} — l'unità di
misura del corso, mai messa contro la nostra sulla cella gestita.
**Nota onesta**: R44 ha già spazzolato i multipli del range fino a 3,0× e ha
trovato *"scia vera"* sul profitto (PF 1,955) **bocciata dal cancello DD**. Il
target in R sullo stop è un oggetto diverso (si adatta allo stop, non al range).
**Stima**: media. Più interessante se abbinato alla Cella 1, perché con lo stop
largo il TP in R si sposta in automatico.

### Cella 6 — I FILTRI DI CONTESTO (bassa priorità, precedente contro)

Notizie (`InpUseNewsFilter=1`, CSV mai usato), witching/MSCI, EMA21 come trailing
al posto della EMA9, `InpExitOnEmaClose=1`. **Sono esattamente la forma "filtro
aggiunto dopo" che ha 0 successi su 5.** Da fare solo dopo le celle 1-3, e solo
se il motore esce vivo.

### ❌ Fuori perimetro per un R88

- **Golden Zone Fibonacci sul Dow**: non è una cella, è un **EA diverso**
  (`ABTG_ORB_Fibo.mq5`, 48 input, mai portato a tick reali sul Dow). Merita il
  suo round, non un asse dentro questo.
- **Short e long+short**: già misurati e bocciati per merito (R54b).
- **Initial Balance 60'**: chiusa in R35 sulla famiglia Apertura.

### 📌 Ordine consigliato

**Cella 1 (stop largo) + Cella 4 (fine giornata) nello stesso lancio** — sono i
due assi che parlano al muro prop e costano poco. Poi **Cella 2** (la ricetta del
corso), che è la più ricca di contenuto ma anche quella che può mangiarsi il
campione. **Cella 3** come diagnosi, non come promozione.

---

## D. NOTA PROP — cosa serve per reggere, e cosa c'è già

**I muri** (`report/METRO_PROP.md`, su 100k): DD totale **10% = 90.000** ·
DD **giornaliero 5% = −5.000 in una sola seduta**. Il giornaliero butta fuori
anche col totale intatto.

### Confronto col **cap.14 della Masterclass Golden Cross** (il capitolo prop)

| protezione (cap.14) | c'è nell'ORB? | dove |
|---|---|---|
| Rischio 0,5% test / 1% ordinario / 1,5% max A / mai >2% | ✅ **sì, e più prudente**: in campo a **0,3%** (mezzo peso, per il doppio asterisco R15) | `DEPLOY_GUARDIANO_100K.md` riga 153 |
| Max 2 trade/giorno per strumento | ✅ **superato**: `InpOneTradePerDay=1` = **1 solo trade** | riga 61 + fix righe 203-204 |
| Max 3 trade complessivi/giorno | ⚠️ **non è dell'EA**: è di conto. Coperto in parte dal cap C1 sul rischio aperto (3,25% = 5 SL vivi) | firme 18/08 |
| **STOP dopo 2 perdite consecutive** | ❌ **NON C'È** — né nell'EA né nei PDF ORB (è un [BUCO] anche del corso) | — |
| **Stop giornaliero −2R/−3R** | ⚠️ solo a livello **conto** (Guardian: pausa 4,0%, emergenza 4,9/9,9), **non per-EA** | `ABTG_PausaGuardian.mqh` |
| Mai aumentare la size dopo una perdita | ✅ per costruzione: `lotto = equity × rischio% / distanza_stop`, nessuna dipendenza dall'esito precedente (riga 583) | — |
| Sizing in % dell'equity | ✅ sì | riga 583 |
| Stop loss vero (non virtuale) | ✅ sì, `sl` nell'ordine, mai 0 | righe 296/311/444 |

### Le tre cose che la sedia ORB deve ancora dimostrare, in ottica prop

1. **🔴 Il DD è di confine, non di sicurezza.** R15: **9,92%** contro un muro del
   10% — passato **per 8 centesimi**, e il vicino TP 1,0× è già a 11,2%. R44 ha
   confermato: 2×/3× porta a 10,8-11,0%. **Non è un altopiano.** È il motivo per
   cui gira a 0,3% e per cui la Cella 1 (stop largo) è la priorità.
2. **🔴 Vive solo a taglia piccola.** R55: perde il cancello prop con **1,5 punti
   indice** di slippage. Su una prop vera, con riempimenti veri, quel margine
   non c'è.
3. **⚠️ Il DD trailing non è mai stato calcolato** (`METRO_PROP.md` §1): tutte le
   nostre Monte Carlo sono su DD **statico dal deposito**. Una curva che, come
   questa, passa il muro per 8 centesimi su DD statico, **con un trailing non ha
   nessun margine dichiarato**.

### Il lato buono, misurato

- **Scorrelazione vera**: R16 ha misurato **Dow retest vs ORB breakout = +0,06**
  sulla **stessa apertura USA, sullo stesso simbolo**. Ingressi diversi (retest
  del livello vs rottura del range) bastano a scorrelarli. È esattamente ciò che
  serve a una prop: N sedie che non perdono insieme.
- **Peggior giornata di portafoglio** a 6 serie: −3,84% a rischio 1% → **~−2,5%
  a 0,65%**, contro un muro giornaliero del 5%.
- L'ORB pesa **+41.057 su +73.815** del portafoglio a 5 (R16). È il contributore
  principale **ed è il più giovane**: la ragione per cui il referto stesso
  raccomandava mezzo peso.

---

## E. ONESTÀ STATISTICA — i 3 stop di oggi

> ### 🔴 **TRE TRADE NON DICONO NIENTE. ZERO. NON SONO UN SEGNALE.**

- Il criterio è **congelato dal 15/08**, scritto **prima** di vedere questi
  numeri, in `report/ORB_100K_CRITERI.md`: *"Nessuna decisione sul RENDIMENTO
  prima di **15 trade**"*. Siamo a **3 su 15**.
- Quel documento aveva già fatto il conto a 2 trade: con un win rate atteso
  **55-60%**, perdere i primi due ha probabilità del **16-20%**. A **tre**:
  0,45³ = **9,1%** · 0,40³ = **6,4%** → **una volta su 11-16**. [INFERITO dal
  win rate atteso dichiarato in `ORB_100K_CRITERI.md`, che **non ho verificato
  sui CSV di R15** in questa sessione.]
- **L'unica ragione per uscire prima dei 15 è il RISCHIO**, e i tre cancelli
  sono numerici: (1) **−2.000 €** cumulati sul 100k; (2) una giornata da
  **peggio di −1,5%** del conto da sola; (3) DD della sua serie **oltre il 12%**.
  A 2 trade eravamo a −424,39. Il terzo (19/08, chiuso dal trailing) fa
  **−117,37** sul 100k → cumulato **≈ −541,76**, cioè **~27% del primo
  cancello** e ~0,54% del conto. **Nessuno dei tre cancelli è vicino.**
  [INFERITO: somma di −424,39 (`ORB_100K_CRITERI.md`) + −117,37
  (`CODA_PROSSIMA_SESSIONE.md`, 19/08); non ho riletto l'estratto conto.]
- ⚠️ **E il terzo trade ha un asterisco tecnico, non statistico.** Il verbale
  del 19/08 registra che i due gemelli **divergono nella gestione**: stesso
  ingresso al secondo (53600,5, SL 53506,5), ma sul 100k il **trailing EMA9**
  ha alzato lo stop a 53563,5 e ha chiuso a **−0,39R alle 15:15**, mentre sul
  conto piccolo lo stop non si è mosso. Ipotesi a verbale: **`.ex5` di build
  diverse**. Finché quella stringa di confronto non gira, il terzo trade
  **non è nemmeno una replica pulita del comportamento della cella R15** — e
  questo è un motivo in più per non leggerci dentro niente.
- **Correzione a una premessa della missione**: il "vecchio ORB del corso"
  (magic **770601**) non "ha perso anche lui" come EA concorrente in campo —
  è **SPENTO dal 10/08** (lista TIER 1 di `PULIZIA_VPS_10-08.md`, spento per un
  **difetto tecnico**, non per rendimento) e quel **−42,91** del 15/08 era il
  suo **ultimo trade in assoluto**. La `PAGELLA_SETT_2026-08-15.md` §4-bis lo
  verifica e corregge esplicitamente una lettura precedente sbagliata. Chiude
  con **+351,51 su 20 trade**, cioè **in utile**.

> 🎯 **Il round di miglioramento si fa sui backtest, non sull'emozione dei tre
> stop.** Le celle della sezione C esistono perché **R55 e R15 hanno nominato un
> difetto strutturale** (stop stretto → DD di confine → fragilità allo
> slippage), non perché la sedia ha perso tre volte. Se l'ORB avesse vinto tre
> volte su tre, la Cella 1 sarebbe **esattamente la stessa** — ed è questo il
> test per capire se un round è onesto.

---

## Attribuzione e limiti

- **Materiale del corso**: © Alfio Bardolla Training Group — Emiliano Monza.
  "Tutti i diritti riservati. Vietata la riproduzione senza autorizzazione."
  Qui è **estratta la meccanica per uso interno di ricerca**, non riprodotto il
  documento. Nessun numero di performance dell'autore è usato come criterio.
- **Cosa NON ho potuto vedere**: il **sorgente** di `ORB_Indicator_V15` (solo
  `.ex5`; gli input vengono dagli screenshot misurati da Claudio, non da me);
  i CSV di R15 (win rate reale della cella **non verificato in questa sessione**);
  la pagella del 19/08 col terzo trade.
- **File letti per intero in sessione**: i due PDF (16 + 18 pagine),
  `ABTG_ORB_Ottimizzato.mq5` (772 righe), `R15_ORB_gestione_DD.txt`, i referti
  R7/R8/R14-15/R16/R35/R44/R54/R55, `ORB_100K_CRITERI.md`,
  `PAGELLA_SETT_2026-08-15.md`, `BACKLOG_ORB_IDEE.md`, `METRO_PROP.md`,
  `GOLDEN_CROSS_MASTERCLASS_TRIANGOLAZIONE_2026-08-19.md`.
