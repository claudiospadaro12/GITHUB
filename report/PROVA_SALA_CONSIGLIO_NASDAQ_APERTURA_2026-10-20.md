# Prova del metodo "sala del consiglio" su ABTG_Nasdaq_Apertura_US.mq5 v1.02 (20/10/2026)

**Natura: analisi per LETTURA, nessuna compilazione, nessun backtest eseguito, nessun file modificato.** Modalita': **agenti REALI** (3 sottoagenti indipendenti, mandati scritti prima: A6 revisore critico, A3 evidenze, A7 verificatore) + coordinatore (io). Un sottoagente che legge lo stesso file non e' una conferma indipendente della fonte; ho **riverificato io** alla fonte i punti marcati [RIVERIFICATO]. Nessun punteggio di qualita': non e' una prova. L'EA e' il nostro (identico al repo, 2.644 righe, controllato con cmp).

## 0. Correzione a un'affermazione dei sottoagenti
A6 ha scritto che nelle settimane in cui USA e UE cambiano ora in date diverse l'apertura reale cadrebbe alle 13:30 server. **Non regge** con quanto il repo ha misurato (`DECISIONE_OROLOGIO_INVERNALE_BCM_2026-10-11.md`, `OROLOGIO_BCM_2026-09-24.md`): **BCM e' UTC+1 FISSO, senza ora legale.** Quindi: la cash USA apre alle 14:30 server finche' gli USA sono in ora legale (fino a domenica 01/11) e alle **15:30 server dal lunedi' 02/11**; l'EA arma ad ora fissa 14:30 server (r.39-40): **da 02/11 arma un'ora PRIMA della cash** (stesso problema documentato per DAX dal 26/10, Xetra 09:00 server contro `InpSessionHour=8`). Da ricordare: la regola "server = ora italiana meno 1" scritta in CLAUDE.md vale fino al 25/10 compreso; dal 26/10 BCM = ora italiana. Il flat a 21:45 server cade 45 minuti dopo la chiusura cash d'estate (21:00 server) e 15 minuti PRIMA d'inverno (22:00 server).

## 1. Verificato pulito (A7, con riverifica mia dove indicato)
- Orario in ora server, nessuna conversione `TimeGMT/TimeLocal` [RIVERIFICATO: grep vuota]. Leve R30 spente di default [RIVERIFICATO r.343]. Graffe 264/264, tonde 1419/1419 (conteggio senza stringhe e commenti): non prova che compili. Ogni ordine passa uno `sl` e richiede `dist > 0`. Divisioni per zero sul lotto protette.

## 2. Problemi trovati (A6, ordinati; [RIVERIFICATO] = visto io nel codice)
**Alti**
1. **Orologio** (sopra, gia' noto al repo; R274a-d scritti, mai girati).
2. **Nessun limite superiore all'orario di armo** (r.715-717, 771-781): dopo un riavvio/ricompilazione tardo o se il Guardian blocca e poi libera, gli ordini partono con livelli nuovi a ora tarda. [da verificare nel tester/log]
3. **Piazzamento one-shot**: se un lato viene rifiutato il codice registra "fallito" e non riprova (r.1010-1014 [RIVERIFICATO: solo log]); resta un solo lato senza avviso di OCO incompleto. Giornata persa.
4. **Stato di parziale e break-even in memoria** (`gPartialTk[]`, `gBETk[]`, r.416-417 [RIVERIFICATO]): dopo riavvio del terminale, ricarica o cambio input una posizione gia' al BE puo' subire una seconda parziale con rischio ricalcolato sull'ATR (A6, da verificare riavviando con una posizione aperta).
**Medi**
5. **Lotto forzato al minimo senza tetto** (`MathMax(minLot, ...)` r.2069-2070 [RIVERIFICATO]): se il rischio supera il 2% si apre comunque il minimo; rischio sul balance, non sull'equity; due lati insieme = doppio rischio; `InpMaxRangePts=0` (nessun cap sulla distanza dello stop).
6. Definizione di R incoerente con `InpTrailStartR=0`; esiti di BE/trailing non controllati (se `PositionModify` fallisce il BE non viene piu' riprovato; trailing senza controllo stops/freeze level).
7. Chiusura serale dipende dai tick (se il CFD smette di quotare prima di 21:45, la posizione supera la mezzanotte); **nessun filtro per sabato/domenica/festivi USA/mezze sessioni** [A7: grep vuota]: nei festivi USA con CFD aperto l'EA arma e opera comunque.
**Basse**: OCO: doppia esecuzione possibile nel tick dopo un fill; `ABTG_PausaGuardian.mqh` richiesto in `MQL5/Include` mentre l'intestazione dice "non serve nessun .mqh" (r.43-45 contro r.77); **il magic 770201 compare come default in altri 4 file varianti** (`_Pin9fca`, `_TrailFix`, `standalone/`, `CLAU12_`: se girassero insieme sullo stesso simbolo i trade sarebbero indistinguibili; la sedia in campo usa 770260).

## 3. Cosa gia' sapevamo e cosa e' nuovo
Gia' noto: merito sospeso (102 posizioni contro la soglia di 150), due contratti per la stessa sedia (PF OOS 1,109 su 94 / 1,215 su 102, rischi e banchi diversi), orologio e ora legale mai misurati, slippage non trovato, backtest su un solo regime. **Nuovo da questa prova**: i punti 2, 3, 4, 5, 6, 7 e la discrepanza dei magic: sono rischi di ESECUZIONE del codice, non della strategia, e nessuno e' stato misurato nel tester.

## 4. Limiti della prova
Niente compilazione ne' esecuzione; A6 ha lavorato per lettura e le sue righe non sono state riverificate tutte; il punto 1 di A6 e' stato corretto da me sul repo; nessun punteggio assegnato.
