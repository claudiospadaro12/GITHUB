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
