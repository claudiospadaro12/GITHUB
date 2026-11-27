# UBS R2: risultati (26/11/2026), fuori campione pre-2020 e calibrazione oro. Criteri: `UBS_R2_CRITERI_2026-11-26.md`

52 passate a 1 minuto, set cosi' come sono, deposito 100.000, Risk=0, StartLots=0,1. Dati: `UBS_NOTTE/RISULTATI_R2_2026-11-26.csv`.

| Gruppo | Set | Reggono (PF >= 1,10 e >= 30 op) | Reggono forte (PF >= 1,20 e rendimento > 0 in entrambe le meta') | PF mediano |
|---|---|---|---|---|
| Oro D1 2004-2019 | 13 | **13** | **13** | 1,74 (anni positivi: mediana 14 su 16) |
| Forex D1 2013-2019 | 29 | **25** | 20 | 1,59 |
Non reggono (forex): EURUSD RJ005 (0,80), RJ009 (1,02), AUDJPY RK001 (0,81), CHFJPY RK002 (0,86). Una sola meta' positiva: RJ005, RJ009, RJ010, RJ011, RJ029, RK001, RK002.

## Previsioni contro risultati
- P1 oro D1 regge >= 60%: **65% -> 100%** (vera). Regge forte >= 40%: vera (100%).
- P2 forex D1 regge <= 40%: **sbagliata**: regge l'86% (25/29), mediana PF 1,59 (nel 2020-26: rapporto 0,80 sull'Excel).
- P3 calibrazione oro H1/H4: rapporto PF(1 minuto)/PF(tick) mediano **1,24** (nella banda 1,05-1,5, vera), ma con code: 0,98 - 3,08 (K057: 5,33 contro 1,73; K035: 5,42 contro 3,04). Un set veloce a 1 minuto puo' essere gonfiato fino a 3 volte; il tick resta la misura.
- P4 correlazione con GoldenZoe > 0,5: non misurata.

## Perche' NON e' una prova indipendente (limiti dichiarati)
1. **Non sappiamo su quale periodo Wim e gli utenti hanno ottimizzato questi set.** Se l'hanno fatto sulla storia lunga (il metodo di Wim usa circa 10 anni), il 2004-2019 per l'oro e il 2013-2019 per il forex sono IN CAMPIONE per loro: R2 misura la coerenza, non il fuori campione. Il solo vero fuori campione e' il forward o un secondo feed.
2. Selezione: i set provati sono quelli gia' CONFERMATI in R1/R1b (effetto del vincitore).
3. Regime: oro in rialzo 2004-2011 (e di nuovo dopo il 2019); USDJPY con la svalutazione dello yen 2013-2015. Trend-following in periodi di trend.
4. Un solo feed (BCM), 1 minuto: D1 affidabile (rapporto tick/1 min 0,92), ma lotti non fissi 0,1 su alcune famiglie (USDJPY 3,67 lotti): netto e DD non confrontabili.
5. 13 set oro = una sola famiglia (stesso motore, stesso mercato): UN posto in portafoglio, probabile correlazione > 0,5 con GoldenZoe. Set di Wim e utenti: fuori dalla flotta prop per ora (decisione 21/11).
6. Il Donchian 20/55 D1 su 17 mercati era 0/34: il motore UBS (breakout con stop e target) non e' lo stesso sistema, ma il contrasto va spiegato prima di fidarsi.

## Passo successivo (per i criteri, fase O)
Passano alla Fase O le famiglie con almeno un set CONFERMATO in R1/R1b e che REGGE in R2: oro D1, USDJPY D1 (14 set), EURUSD D1 (alcuni), GBPUSD D1, NZDUSD D1, AUDUSD D1, GBPJPY D1. Prima della Fase O: correlazione con GoldenZoe e fra le famiglie (soglia 0,5), per non ottimizzare 13 copie dello stesso set.
