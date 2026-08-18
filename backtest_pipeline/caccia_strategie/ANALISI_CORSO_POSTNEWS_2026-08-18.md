# 📰 ANALISI TRASCRIZIONI — MODULO **STRATEGIA POST NEWS** (corso ABTG, capitolo 5)

**Data:** 18/08/2026 sera · **Ordine di Claudio:** _"con la nostra flotta di
agenti, fai esaminare anche questa cartella con la strategia post news"_.

**Fonte:** **9 trascrizioni**, lezioni **2-10**, in
`backtest_pipeline/caccia_strategie/trascrizioni_corso_2026-08-18/modulo_postnews/`
— **~78.500 caratteri, letti per intero, riga per riga.** Nessuna slide,
nessun PDF: **solo audio**.

**Consegna gemella** (la specifica per chi scrive il codice — qui NON si
duplica, si linka):
📐 `backtest_pipeline/prove/POSTNEWS_CORSO_SPEC.md` (911 righe)

> 🔒 **Nessuna modifica al forward. Nessun EA toccato. Nessun round lanciato.**
> Qui si misura e si propone. Decide Claudio.

**Etichette:** `[T]` testuale · `[I]` inferito (dico da dove) · `[?]` incerto ·
`[T-dubbio]` trascritto ma probabile errore di speech-to-text ·
`[dichiarato]` = numero del relatore, **NON verificato**.

---

# PARTE 1 — 🔥 LA SINTESI, PRIMA DI TUTTO

## 1.1 Le sei righe che contano

| | |
|---|---|
| 🥇 **Meccanizzabilita'** | **77% secco** (20 decisioni su 26 dettate con un numero), **92%** con 4 assunzioni. **La piu' alta dei sei moduli** — il precedente record era il Breakout al 55% |
| 🎙️ **Relatore** | **QUARTO relatore**, mai nominato in 9 lezioni. 🟢 **Certo: NON e' Leonardo Fasciano** `[T]`. 🟠 Il nostro EA lo attribuisce a **Christian Bertacchi**, ma **nessun documento in repo lo sostiene** |
| 🏛️ **Prop** | **DIPENDE**: ✅ FTMO (Standard e Swing), E8, Alpha Capital · 🔴 **di fatto vietata su FundingPips** · 🔴 **da sola non passa nessuna challenge** (giorni minimi + consistenza) |
| 🚨 **La scoperta** | **il verdetto "PostNews: nessun edge" del weekend 07/08 e' NULLO: quei backtest hanno ZERO TRADE** — il file eventi era vuoto |
| 🟢 **L'occasione** | e' **l'unico dei sei moduli i cui dati d'ingresso sono gia' in casa**: 70 eventi ECB/FOMC nel calendario di biblioteca, + ~250 altre conferenze stampa |
| 🔴 **Il buco** | **N non e' mai dichiarato**, il DD combinato nemmeno, e **lo strumento insegnato (MT4, "2-3 mesi di storico") non puo' produrre il backtest dal 2009** che viene mostrato |

## 1.2 🚨 IL FATTO PIU' PESANTE DELLA SERATA

> **Abbiamo in flotta un EA che implementa questa strategia dal 26/07. E' stato
> bocciato il 07/08 con la formula "nessun edge nemmeno in screening". Quel
> giudizio e' basato su quattro backtest che hanno prodotto ZERO OPERAZIONI.**

```
backtest_pipeline/risultati_prove/ABTG_PostNews/ABTG_PostNews_EURUSD_IS_ohlc.csv
Pass,Profit,...,Trades,InpMagic,...
0,0.00,0.00000,...,0,771201,...        <-- Trades = 0
1,0.00,0.00000,...,0,771202,...        <-- Trades = 0
```

Idem per EURJPY, idem in OOS. **Quattro file su quattro.**

🔎 **La causa, accertata leggendo il sorgente e i file:** l'EA opera solo se
trova l'evento nel calendario (`InpRestrictToNews=true`), e il calendario che
gli e' stato dato — `mql5/Files/abtg_news.csv` — contiene **17 righe, tutte
datate 2026 e 2027**. (Il gemello `data/abtg_news.csv` e' **vuoto, 0 byte**.)
Nel periodo testato **non esisteva un solo evento**: l'EA non ha piazzato
niente, il tester ha restituito zero, e lo zero e' finito in classifica sotto
la voce _"niente edge nemmeno in screening"_.

> ⚖️ **Cosa NON sto dicendo:** che la strategia funzioni. Sto dicendo che
> **non e' mai stata misurata**, che il verdetto in `CLASSIFICA_WEEKEND.md` e
> `REFERTO_WEEKEND_FASE0.md` **va ritirato** (non ribaltato: ritirato), e che
> oggi abbiamo **tutto il necessario** per farlo sul serio.

## 1.3 🥇 E l'occasione: questo modulo, unico fra i sei, ha GIA' I DATI in casa

| modulo | cosa serve per backtestarlo fedelmente | ce l'abbiamo? |
|---|---|---|
| Breakout | parametri del SuperTrend | ❌ mai dettati, rimando circolare |
| Fibo H4 | definizione operativa del pattern | ❌ ambigua |
| Media 200 | filtro "arrivo sulla media" | ❌ mai dettato |
| Mediazione | regola di aggiunta | ❌ scatola nera |
| Point Break | non e' una strategia | — |
| 🥇 **POST NEWS** | **una data e un'ora** | ✅ **70 eventi ECB/FOMC nel repo** |

`caccia_strategie/biblioteca/dati/CALENDARIO_news-*.csv` (37.799 righe)
contiene i titoli esatti **`ECB Press Conference`** e **`FOMC Press
Conference`**, impatto 3, con orario: **35 + 35 eventi dal 2021 al 2025**. Piu'
**BoJ (58), BoC (41), RBNZ (34), SNB (26)** per allargare la famiglia.

**Traduzione: e' l'unico dei sei che si puo' backtestare fedelmente questa
settimana, senza chiedere niente a nessuno.**

---

# PARTE 2 — 🧮 LA SINTESI INCROCIATA

## 2.1 TABELLA DEI VALORI CONVERGENTI

⚠️ **Avvertenza sull'indipendenza delle fonti**, che e' il cuore del metodo:
le 9 lezioni sono **UNA fonte sola** (un relatore, un corso), non nove. Le
uniche fonti realmente indipendenti sono: **(B)** la sintesi in repo di un live
di terzi ("Emiliano/De Marco", 29/07 — ⚠️ **trascrizione grezza ASSENTE dal
repo**, quindi non verificabile riga per riga) e **(C)** il nostro **calendario
eventi**, indipendente per gli orari.

| parametro | (A) corso, lez. | (B) live De Marco | (C) calendario di casa | convergenza |
|---|---|---|---|---|
| **range = 2 candele M5** | ✅ lez. 5, 8 | ✅ | — | 🟢 **2 fonti umane** |
| **BUY STOP = max + 3 pip** | ✅ lez. 5 | ✅ | — | 🟢 **2 fonti** |
| **SELL STOP = min − 2 pip** | ✅ lez. 5 **e** 6 | 🔴 **−3** | — | 🔴 **DISCORDI** |
| **TP 50 / SL 25** | ✅ lez. 5, 8 | ✅ | — | 🟢 **2 fonti** |
| **timeframe M5** | ✅ lez. 5 | ✅ | — | 🟢 |
| **FOMC su EUR/USD** | ✅ lez. 8 | ✅ (+USDJPY) | — | 🟢 |
| **ECB si trada?** | ✅ meta' del modulo | 🔴 _"non la trado"_ | — | 🔴 **DISCORDI** |
| **tenere fino a scadenza?** | 🔴 **NO** (esplicito ×2) | ✅ **SI, 21:45** | — | 🔴 **DISCORDI** |
| **ECB 14:30 → 14:45 a meta' 2022** | ✅ lez. 5 | — | ✅ **salto il 21/07/2022** | 🟢 **VERIFICATO su dato** |
| **FOMC 20/03/2024 alle 19:30 IT** | ✅ lez. 9 | — | ✅ **combacia al minuto** | 🟢 **VERIFICATO su dato** |
| **FOMC "ott-mar = 19:30"** | ✅ lez. 8 | — | 🔴 **falso in 11 casi su 17** | 🔴 **FALSIFICATO su dato** |
| **8 operazioni/anno per notizia** | ✅ lez. 5, 10 | — | ✅ per il FOMC 2021-2024; ECB ✅ | 🟢 (nel periodo coperto) |

> 🥇 **E' la prima volta in sei moduli che possiamo VERIFICARE una fonte del
> corso invece di crederle**: due affermazioni confermate e una falsificata,
> tutte e tre con dati che erano gia' nel repo.

## 2.2 CONTRADDIZIONI

### 🔴 Interne al modulo
1. **Lo strumento contro il backtest.** Lez. 3 e 6: MT4 va indietro _"2-3
   mesi"_ e _"non e' la piattaforma piu' efficace per analizzare il passato"_
   `[T]`. Lez. 7: il backtest parte dal **1° gennaio 2009** e ha bisogno di
   **massimi/minimi di candele M5**. 🔴 **Con lo strumento insegnato quella
   serie non e' producibile.**
2. **Le due date della prossima ECB.** Lez. 5: _"6 giugno 2024"_; lez. 7:
   _"l'ultima, che e' la prossima che ci sara', il **6 maggio 2024**"_
   `[T-dubbio]`. **Il nostro CSV arbitra: nessuna ECB in maggio 2024** (si passa
   dall'11/04 al 06/06). Errore di parlato o di trascrizione.
3. **Scadenze asimmetriche mai spiegate**: ECB **+3h30**, FOMC **+75 minuti**.
   Fattore ~3 senza una riga di giustificazione in 9 lezioni.
4. **La candela della notizia**: scartata sull'ECB, tenuta sul FOMC. **Il
   motivo non viene mai dato**, ed e' la differenza piu' sostanziale fra le due.
5. **"Strategia totalmente meccanica"** (ripetuto 6 volte) **ma il trailing e'
   discrezionale** `[T]`: _"non nel preciso istante … ma **se tu vedi** che li
   ha raggiunti"_, _"**se riesci** bene, se non riesci non muore nessuno"_.
6. **Il rischio "3%"** e' insieme _"quello che suggeriamo noi"_ e _"in ultimo
   sara' una scelta tua"_ — cioe' il numero su cui poggiano TUTTE le
   percentuali del backtest e' dichiarato **non vincolante**.

### 🔴 Fra il corso e l'altra fonte (live De Marco)
Tre divergenze secche: **offset del sell** (2 vs 3), **chiusura a scadenza**
(no vs si), **se tradare l'ECB** (si vs no). ⚠️ E il nostro EA **ha seguito il
live su tutte e tre**, senza che nessuno avesse letto il corso.

### 🔴 Fra il corso e il mondo reale
`[ANCORA ESTERNA — conoscenza generale, NON dalla trascrizione, da verificare]`
Il relatore lascia intendere **8 conferenze ECB/anno dal 2009** e **8 FOMC/anno
dal 2011**. Le conferenze BCE erano **mensili fino al 2014** e quelle FOMC
**4/anno fino al 2018**: se e' cosi', **il numero di operazioni del suo backtest
e' sbagliato in entrambe le serie** — e senza N dichiarato non e' controllabile.

## 2.3 🧮 L'ARITMETICA, FATTA SU OGNI NUMERO DICHIARATO

**(a) I due esempi operativi: 17 numeri su 17 tornano al centesimo** (prezzi,
SL, TP e **anche i lotti**: 9935 × 3% / (50 × 5,90) = **1,0103 → 1,01** ✅;
0,65 lotti su EUR/USD ✅). **Dettaglio in `POSTNEWS_CORSO_SPEC.md` §7.**
🟢 **E' il primo modulo dei sei in cui l'aritmetica operativa non si rompe.**

**(b) Il win rate implicito, che non viene mai pronunciato.** Con soli esiti
+50 / −25 la media per operazione e' `75p − 25`:

| serie | pips/op. impliciti | **win rate necessario** |
|---|---:|---:|
| ECB (~3000 pips / 124 op.) | 24,2 | 🔴 **65,6%** |
| FOMC (~1500 / 112 op.) | 13,4 | **51,2%** |

**Un 65% di operazioni vincenti a rapporto 1:2 e' un numero straordinario, e
non viene detto.**

**(c) Le percentuali non sono riproducibili dai pips dichiarati**, e sbagliano
in **due direzioni opposte** (3% su 50 pip = 0,06% di equity per pip,
capitalizzato):

| serie | attesa dai pips | dichiarata | scarto |
|---|---:|---:|---|
| ECB | ≈ +480% | +340/370% | dichiara **meno** |
| FOMC | ≈ +140% | oltre +200% | dichiara **piu'** |
| combinata | ≈ +1.290% | +1.000% | meno |

🔴 **Due file dello stesso autore sulla stessa strategia si comportano in modo
opposto rispetto alla stessa formula**: il metodo di calcolo non e' dichiarato,
quindi nessuna delle tre percentuali e' verificabile.

**(d) "+1000% con media del 20% l'anno"** → 11x in 15,5 anni = **16,5%
composto**. Il 20% e' la media **aritmetica** degli anni. Il numero da
ricordare e' **16,5%**.

**(e) "Un solo anno negativo su 15" e' COERENTE** col win rate implicito (con
16 op./anno al 60%, la probabilita' che un anno chiuda in rosso e' ~2% → ~0,3
anni su 15). **Coerente non significa vero: significa che non si contraddice.**

**(f) Il DD.** ECB: **15%** `[dichiarato]`. FOMC: _"bassissimo"_, **nessun
numero**. Combinata: **mai dichiarato**. 🔴 E il 15% al rischio del corso
**sfonda il muro totale del 10% di ogni prop censita**.

---

## 2.4 🔬 CONFRONTO COL REPO — cosa gia' facciamo, cosa no

### (a) L'EA esiste da tre settimane e diverge dal corso su 3 punti

`mql5/Experts/ABTG_PostNews.mq5` (458 righe, magic 771201/771202, in
`FLOTTA_ATTIVA.md` su EURJPY/EURUSD M5). **Tabella completa in
`POSTNEWS_CORSO_SPEC.md` §9.1.** I tre punti che contano:

| | corso | nostro EA | commento |
|---|---|---|---|
| **OCO** | 🔴 **NO**, e spiega perche' (la size e' calcolata proprio per finanziare il doppio stop) | `InpUseOCO=true` | l'EA **dimezza il rischio ma cambia strategia** |
| **chiusura della posizione a scadenza** | 🔴 **NO**, esplicito 2 volte | `InpCloseAtExpiry=true` | con questa regola **l'esempio-principe della lez. 9 (TP incassato la mattina dopo) non sarebbe mai esistito** |
| **orario d'azione** | relativo alla notizia | **fisso a orologio** | si rompe a luglio 2022 (ECB), a marzo/novembre (FOMC) e all'ora legale |

### (b) 🆚 Le nostre sedie "news-adjacent": sovrapposizione o buco vero?

La domanda posta: le nostre **Aperture DAX/Nasdaq** sono "news-adjacent"
(l'apertura E' un evento schedulato). C'e' sovrapposizione?

**Meccanicamente e' la STESSA MACCHINA.** Confronto sui sorgenti:

| | `ABTG_DAX/Nasdaq_Apertura` | **Post News** |
|---|---|---|
| innesco | orario schedulato (apertura) | orario schedulato (conferenza) |
| range | primi N minuti (`InpRangeMinutes`) | prime 2 candele M5 (**10 minuti**) |
| ingresso | rottura del range con pendenti | rottura del range con pendenti |
| stop | dal range / ATR | **fisso 25 pip** |
| target | in R (`InpTP1_R`) | **fisso 50 pip = 2R** |

> 🎯 **Verdetto: e' lo stesso ARCHETIPO (breakout di un range post-evento
> schedulato) applicato a un altro orologio e a un altro mercato.**
>
> - ❌ **Non e' un buco di portafoglio "di logica"**: la tesi (l'evento
>   comprime, poi il prezzo espande e prosegue) e' identica a quella delle
>   aperture. E su quel fronte **abbiamo gia' misure, e non tutte belle**:
>   `ORB@NASUSD` e `ORB_Fibo@NASUSD` sono fra i "nessun edge nemmeno in
>   screening" del weekend 07/08.
> - ✅ **E' un buco vero di CALENDARIO e di MERCATO**: 16 eventi l'anno, su
>   **cambi**, in orari (15:00 e 20:40 italiane) in cui **nessuna nostra sedia
>   apre posizioni**. La correlazione con le aperture indici e' **strutturalmente
>   bassa** (giorni diversi, strumenti diversi, sessioni diverse).
> - 🥇 **La vera novita' non e' la strategia: e' l'INNESCO.** Un motore di
>   ingresso su **evento macro schedulato** oggi in flotta **non esiste**
>   (`MAPPA_MOTORI_EA.md` cita `ABTG_PostNews` come unico "eventi macro", ed e'
>   proprio quello mai misurato). **Il pezzo riutilizzabile e' il lettore di
>   calendario**, che serve a tutta la flotta anche solo per STARE FUORI dalle
>   news (conformita' FundingPips/E8).

### (c) Cosa dice il metro di casa sul rischio

| | corso | casa | fattore |
|---|---:|---:|---:|
| per ORDINE | 1,50% | **0,65%** (A1) | **2,3x** |
| per EVENTO (doppio stop) | **3,00%** | 1,30% | **2,3x** |
| quota del cap C1 (3,25%) consumata da UN evento | **92%** | 40% | — |

🔧 **Riscalatura proposta:** `InpRiskPercent = 1,30` (con
`InpRiskRefSLpips=50`) → **0,65% per ordine**. Il DD dichiarato del 15%
scenderebbe proporzionalmente a **~6,5%**: sotto il muro prop, sopra la soglia
del fastidio.

---

## 2.5 🏛️ ATTRITI PROP — qui e' il cuore, non il contorno

**Regole dalle schede di `CONFIG_PROP_2026-08-18.md` §2A-2F**
(dichiarazioni raccolte, **nessuna confermata dal supporto**: regola D3).

L'ordine e' **piazzato** a notizia **+15 min** (ECB) / **+10 min** (FOMC) e puo'
scattare in qualunque istante successivo → il confronto giusto e' fra la
finestra di divieto e **+10 minuti**.

| prop | regola news | ECB | FOMC |
|---|---|---|---|
| **FTMO 2-Step Standard** | ±2 min aprire/chiudere | ✅ **eseguibile** | ✅ **eseguibile** |
| **FTMO Swing** | nessuna restrizione | ✅ **libera** | ✅ **libera** |
| **FTMO 1-Step** | ±2 min | ✅ news ok, 🔴 **daily 3%**: un doppio stop al 3% del corso = **breccia secca in un giorno** | idem |
| **The5ers High Stakes** | ±2 min per eseguire; _"i news trader scelgano Hyper Growth"_ | 🟠 **tecnicamente si, di categoria no** | 🟠 idem |
| **FundingPips** | ❌ **±10 min: aperta, chiusa O TENUTA** = hard breach | 🟠 5 min di margine | 🔴 **l'azione cade ESATTAMENTE sul bordo dei 10 minuti** |
| **E8 Markets** | ❌ ±5 min | ✅ | ✅ |
| **E8 Signature** | 🔴 tutto chiuso alle **23:00 server** | 🟠 ok (scadenza 18:15 IT) | 🔴 **incompatibile**: la lez. 9 **tiene la posizione tutta la notte** |
| **Alpha Capital** | ✅ permesse; ≥50% profitti da trade >2 min | ✅ **libera** | ✅ **libera** |

### 🔴 I due killer che NON dipendono dalla finestra news
Nascono dalla frequenza — **16 operazioni all'anno**:
1. **GIORNI MINIMI**: FTMO **4 giorni** di trading, The5ers **3 giorni
   profittevoli** (≥0,5%). A **1,3 eventi al mese**, servono **mesi** solo per
   sbloccare il requisito.
2. **CONSISTENZA**: FTMO **50% best-day**, E8 ~35-40%, FundedNext 40%. Con 2-3
   operazioni in una fase di challenge, **un singolo TP e' >50% del profitto**.

> 🎯 **Verdetto prop:** ✅ **eseguibile** su FTMO (Standard e Swing), E8 Markets,
> Alpha Capital · 🔴 **di fatto vietata su FundingPips** · 🔴 **impossibile DA
> SOLA** su qualunque prop. **La sua unica collocazione sensata e' da
> satellite** — che e' esattamente come il corso la vende `[T]`: _"perfetta
> anche da aggiungere a qualsiasi altra strategia"_.

### ✅ Setaccio bandiere rosse: **PULITO**
Martingala ❌ · griglia ❌ · recovery ❌ · hedging ❌ · assenza di stop ❌ ·
trucchi anti-rilevamento ❌. **Zero bandiere rosse in 9 lezioni: il modulo piu'
pulito dei sei.** Unica riserva di metodo: l'asserzione `[T]` che sulle
conferenze stampa _"lo stop loss a quel prezzo verra' eseguito"_ con certezza —
**lo slippage esiste anche li'**: e' un'affermazione commerciale su un rischio
reale, da misurare a tick.

---
