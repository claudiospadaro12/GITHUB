# Scheda EA "Apex Trader WSC V2.0" (pacchetto Wim) — 04/11/2026
Fonte: manuale v1.8 (maggio 2026) incollato da Claudio + 5 set file (Apex-Set-Files.zip). L'`.ex5` non è stato aperto (compilato, non si legge la logica) e **non è nel repository**; i set file originali restano fuori dal repo. Questa scheda riassume solo ciò che dichiarano manuale e set.

## Cosa dichiara di essere
- Griglia ("smart grid") con TP variabile, mean-reversion + trend, **solo AUDCAD, AUDNZD, NZDCAD su M15**, un grafico EURUSD M15 con OneChartSetup. MT5 (c'è anche MT4).
- Lotto automatico a gradini (`LotsizeStep`: lotti 0,01 ogni X di saldo), `OnlyUp` (il lotto non scende dopo le perdite), killswitch di drawdown basato su un valore storico in pips (2016–2023) e in valuta/%.
- Licenza: richiede URL abilitati in MT5 (forexeasolutions.org / .services, worldtimeserver.com, nfs.faireconomy.media). Fatti da verificare: se gira sul tester e sui conti demo/FTMO, e se è legata al conto.

## I 5 set (differenze)
| Set | LotsizeStep | Progressione griglia (`LotsizeVariation`) | Altro |
|---|---|---|---|
| Ultra_Conservative | 2000 | `1` | — |
| Conservative | 3000 | `1;1;2;` | — |
| Elevated | 5000 | `1;2;2;2;3;3;3;4;4;4;…;10` | — |
| extreme risk | 5000 | `1;3;5;7;9;…;41` (**cresce di 2 a ogni livello**) | — |
| highrisk live account | **300** | `1;1;2;` | `HardSLDistance=2000`, `CloseOnly=0`, `EADrawdownOnly` |
Comuni: coppie AUDCAD;AUDNZD;NZDCAD, magic 1999654, spread max 18 (cancella pendenti a 23), `UsePendingOrders=1`, `EnableMaxPipsDD=1` (killswitch storico attivo), `OnlyUp=1`, `AutoGMT=1`, filtro notizie attivo.

## Letture di C0 (non misurate)
1. **È una griglia**: profilo "tanti piccoli guadagni, perdita rara e grande". Il rischio vero è nella coda, non nel PF. Nel set "extreme risk" la progressione dei lotti è quasi martingala (1,3,5,…,41).
2. **Le tre coppie sono molto correlate tra loro** (stessi AUD, NZD, CAD): la diversificazione è verso l'oro, non dentro il pacchetto.
3. Il **killswitch è tarato sul peggior drawdown 2016–2023**: protegge solo da ciò che si è già visto; il peggio fuori campione è esattamente il caso che conta.
4. Lotti per 100/80k: i valori `LotsizeStep` del manuale (2.000–15.000) vanno scalati con calma; **taglie e rischio li decidi tu**, io misuro in % e in drawdown.
5. Probabile bassa correlazione con l'oro (classe diversa, meccanica diversa), ma **non è un fatto finché non lo misuriamo** sui P&L giornalieri.

## Cosa serve per un giudizio (piano, criteri da congelare prima di guardare i risultati)
- Backtest tick reali BCM, EURUSD M15 con OneChartSetup, 2016→oggi, set Ultra/Conservative/Elevated (gli altri due solo per capire la coda), costi e spread reali del broker.
- Misure: profit factor e drawdown massimo in % del saldo e in giorni, **peggior giorno e peggiore sequenza**, tempo di recupero, comportamento nei periodi stressati (2020, 2022), numero di livelli di griglia aperti al picco.
- Correlazione dei P&L giornalieri con Reaper, Goldbot, Phantom (e GTP) e **peggior giorno combinato col Guardian**, come già fatto per il GTP.
- Criterio di scarto in anticipo: se il peggior drawdown storico supera il tetto che accetti per l'insieme, o se il recupero oltre N mesi, l'EA non entra.
- Controlli: stesso test su un periodo non usato per scegliere il set; confronto lordo/netto di spread.
Stato: **nessun test eseguito**.
