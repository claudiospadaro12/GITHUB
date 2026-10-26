# Stability Pro, Luna AI Pro, Apex Trader: setaccio a 80K sull'oro e lettura degli input (26/10/2026)
**Natura: MISURA + LETTURA.** Setaccio 80.000 EUR, XAUUSD, 01/01-01/03/2026, H1 e M15, input di default, tick reali; lettore congelato `leggi_setaccio_nuovi.py`; archivio `risultati_archivio/SETACCIO80K_STABILITY_LUNA_APEX_20261026`. (La prima riga si era fermata per un mio errore di variabile; corretta.)

## Esito
Tutti e tre: **0 operazioni in H1 e in M15 -> R1 "non opera" -> SET NECESSARIO**. **NON MISURATI**: non sono EA da oro. Lo dicono gli input letti dai report:
| EA | Coppie negli input | Note dagli input (DICHIARATO dal report, non misurato) |
|---|---|---|
| Stability Pro | `OneChartSetup_Pairs=AUDCAD;AUDNZD;NZDCAD` | `RunOneChartSetup=false` di default: sul grafico dell'oro non apre; auto-lotto (`AutoLotMode=1`, `OnlyUp=true`), `HardSLDistance=2000`, `MaxAllowedDD=0` (spento) |
| Apex Trader | `AUDCAD;AUDNZD;NZDCAD` | ordini pendenti, `LotsizeVariation=1;3;5;...;41` (21 livelli di lotto: struttura a scala), `HardSLDistance=2000`, `EnableMaxPipsDD=true` |
| Luna AI Pro | `EURAUD;GBPAUD;AUDCAD;AUDUSD` | finestra di negoziazione 23:00-01:00 (GMT+2, ora legale), filtro news che nel tester non e simulabile, rischio per trade 0,5, `PerformanceBasedRisk` acceso |
Tutti hanno `AutoGMT=true` con offset 2/3 (come ORB Master): BCM e UTC+1 fisso, orologio da verificare. Gli input e i nomi sono della stessa famiglia di Gold Reaper/Goldbot One (OnlyUp, LotsizeStep, MaxAllowedDD): INFERITO.

## I backtest del venditore su Stability Pro (zip di Claudio, DICHIARATO, NON nostri; broker Alpari, EURUSD M1 con 3 coppie)
- "2007-2023 fixed lotsize": deposito 1.000.000 USD, lotto 0,01: netto +17.053 (+1,7% in 17 anni), PF 2,08, 17.741 operazioni, **82,9% vincenti, vincita media 2,23 contro perdita media -5,11**, permanenza media 12 h 14 min, **massima 597 h (25 giorni)**. DD equity 0,06% e senza significato (deposito 1M con lotto minimo).
- "2020-2023 very high risk": deposito **200 USD**, leva 1:500, `AutoLotMode=3`, `LotsizeStep=200`: netto +238.669, PF 1,69, 2.223 operazioni, 81% vincenti, vincita media 323 contro perdita media -803, **DD equity 59,6% (relativo 66%)**, perdita massima -8.770.
- MT4, AUDCAD / AUDNZD / NZDCAD 2012-2023 (M1): PF 1,79 / 1,55 / 1,92, 3.045 / 3.002 / 2.785 operazioni, DD 0,98% / 6,80% / 1,38% su depositi 25.000 / 5.000 / 25.000.
**Lettura:** profilo da "tante vincite piccole, perdite doppie, posizioni tenute fino a 25 giorni" (payoff 0,44): il flottante puo essere grande e lungo; il caso very high risk mostra un DD equity del 60% a 200 USD. Sono numeri del venditore: servono i nostri.

## Prossimo passo
Test con il set giusto: `RunOneChartSetup=true` e le coppie, su un grafico con il periodo che il venditore consiglia (da leggere dalla pagina del Market: DA RICEVERE da Claudio); tick reali sulle coppie BCM (AUDCAD, AUDNZD, NZDCAD, EURAUD, GBPAUD, AUDUSD: compaiono nello storico del demo 50503392, quindi esistono su BCM). Lo script del tester oggi ha il simbolo XAUUSD fisso: va esteso (-Simbolo) e collaudato prima di una riga nuova.
