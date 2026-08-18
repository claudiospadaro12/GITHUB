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
