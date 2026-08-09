# 🎯 ROTTA PROP — l'obiettivo dichiarato e la strada misurata

_Scritto il 09/08/2026 su dichiarazione di Claudio: «Il mio obiettivo principale
sono le prop. Devo trovare più EA possibili con DD bassi per accenderli
simultaneamente col guardiano.» Questo file è la mappa: cosa c'è, cosa manca,
in che ordine._

## L'arsenale a oggi (tick reali, OOS, rischio 1%)

| # | EA | dove | quando lavora | DD OOS | PF OOS | stato |
|---|---|---|---|---:|---:|---|
| 1 | SupertrendReversal | 225JPY H2 | Asia (swing) | **0,88%** | 1,653 | 🥇 candidato, forward allineato 08/08 |
| 2 | MaxMinNotte DAX Short | D30EUR M15 | notte EU | **1,88%** | 2,192 | 🥇 candidato (n~20: colma il forward) |
| 3 | Dow Apertura (ricetta) | U30USD M5 | 15:30-19:30 IT | **4,18%** | 1,275 | 🥇 candidato, deployato 08/08 |
| 4 | DAX Apertura EU | D30EUR M5 | 9:00-13:00 IT | **6,7%** | 1,423 | ✅ VALIDATO, live |
| 5 | SupRev_NAS_H1_Ott | NASUSD H1 | USA (swing) | **0,86%** | 1,688 | 🥈 creste strette, giudica il forward |
| 6 | EMA200 | SPXUSD H4 | swing | **2,22%** | 1,595 | 🥈 asse periodo non passato |
| 7 | SuperWave_DOW_H1_Ott | U30USD H1 | USA (swing) | **3,91%** | 1,328 | 🥈 il piu' vicino dei quasi |
| 8 | ORB-EMA200 (lab) | U30USD/NASUSD M5 | pomeriggio USA | 14-17% ⚠️ | 1,10-1,23 | 🌿 pista confermata, R15 sul DD |

**Quattro candidati/validati + quattro quasi.** E la diversificazione c'è per
costruzione: notte (2), mattina EU (1), pomeriggio USA (2-3), swing multi-day
(3) - simboli e meccanismi diversi.

## La verita' di portafoglio (quella che decide tutto)

**Il DD della prop e' UNO: quello del conto.** Accendere N EA "a DD basso"
aiuta solo se NON perdono insieme. La flotta l'ha gia' imparato a sue spese:
i rilevatori hanno beccato 2%+2% sullo stesso segnale (Apertura Marco + DAX
EU) e 2%+1% sui gemelli Live5m. Regole di rotta:

1. **Mai due EA sullo stesso segnale/simbolo/lato allo stesso rischio pieno.**
2. Il DD di portafoglio si MISURA, non si spera: serve l'**export per-trade**
   nell'OnTester (oggi esporta solo il riepilogo) -> con le serie per-trade
   si calcola il DD COMBINATO storico + Monte Carlo. E' la versione backtest
   del guardiano, e va fatta PRIMA di accendere simultaneamente.
3. Il guardiano (`ABTG_Guardian.mq5` + preset FTMO 2-step) e' l'ultima rete,
   non la strategia: se scatta spesso, il portafoglio e' sbagliato a monte.

## La sequenza (decisa il 30/07, oggi riempita di contenuti)

1. **Forward sui candidati** (gia' acceso: Nikkei, Dow, DAX, MaxMinNotte) -
   il tempo lavora da solo; 30 trade OOS-forward per verdetto.
2. **R15**: domare il DD della pista ORB (in coda sul PC backtest).
3. **Ricompilazione VPS weekend** (sizing Nikkei a lotto vero + fix ORB corso).
4. ✅ **FATTO il 09/08 sera** -- Export per-trade -> DD di portafoglio + Monte
   Carlo. Primo referto: `risultati_archivio/REFERTO_PORTAFOGLIO_R16.md`.
   4 serie OOS a 100k: netto +32.758, DD storico 5,51%, correlazioni ~zero,
   MC p95 10,56% / p99 12,66% -> per FTMO 10% il rischio a taglia prop va
   a ~0,7% per trade. Manca la 5a serie (ORB-EMA200, R16e).
5. **Binario D**: OnTester per HARSI/SuperWave_EA -> allargare il misurabile.
6. **Un motore a settimana dal binario B** (prossimi: ORB_Fibo, PTE, Nightly).
7. Quando 2-3 candidati hanno il forward maturo: **demo 100k dry-run col
   guardiano** (la sequenza del 30/07), poi la decisione prop vera.

## La regola che non si vende nemmeno per l'ambizione

"A qualsiasi costo" vale per le ORE, mai per le REGOLE: criteri scritti prima,
verdetti solo OOS a tick reali, banco vergine, 30 trade minimi, mai scegliere
dall'IS (12 ribaltamenti misurati). E' esattamente questa disciplina che in
due giorni ha prodotto 3 candidati e una pista nuova - la scorciatoia e' lei.
