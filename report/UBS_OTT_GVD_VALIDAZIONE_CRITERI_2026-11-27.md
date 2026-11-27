# Ottimizzazione 1 (Gold Various daily): validazione dei candidati, criteri e previsioni scritti PRIMA dei numeri (27/11/2026)

**Fonte:** XML dell'istantanea esportata alle 19:00 del 27/11 (ottimizzazione in corso, XAUUSD D1, 2013-2022, 1 minuto, Custom max EP 0 / RF 3 / TR 100, set di Wim `Variable paramaters (daily)/optimization.set`). Tutti i passaggi esistenti all'istantanea sono contati nel contatore di campagna. Lo script `backtest_pipeline/ott_candidati.py` fa la selezione in modo deterministico (seed 20261127).

**Selezione (regole del 22/11):** idonei = PF >= 1,30 (e < 50), operazioni >= 100, profitto > 0 (gli anni positivi si controllano nella convalida). **10 candidati: 4 migliori per Result, 3 piu' diversi** (massima distanza minima in recovery factor, drawdown, operazioni, PF normalizzati), **3 a caso**. **Aggiunta (scritta prima dei numeri): 10 passaggi idonei a caso come gruppo di CONTROLLO**, non fra i selezionati, per misurare se l'ottimizzazione aggiunge qualcosa rispetto a un parametro qualunque.

**Convalide (stessi passi delle famiglie UBS gia' misurate):**
- **V1 (pre-campione), 1 minuto 2004-01-01 -> 2012-12-31**, lotto 0,1: PF >= 1,20, profitto > 0, >= 20 operazioni, anni negativi <= 40% (cancello della campagna).
- **V3 (tick reali), 2025-01-01 -> 2026-10-31:** PF tick >= 1,0 (e rapporto PF tick / PF 1 minuto >= 0,7: per la V3 serve anche la passata a 1 minuto dello stesso periodo, da fare sui finalisti).
- **Correlazione con GoldenZoe** (soglia 0,5) e con le altre famiglie UBS (oro D1 di R2, community H1 di R3), sui deal delle passate V1 (2004-2012) e V3.
- **V2 (perturbazione) e V4 (hold-out 2023-2024, aperto UNA volta) solo sui finalisti** che passano V1 e V3.

## Previsioni (scritte ora)
- **O1** Almeno 6 dei 10 selezionati passano V1: 60%. Almeno 6 dei 10 di controllo: 55%.
- **O2** Mediana del PF V1 dei selezionati maggiore di quella dei controlli di meno di 0,15: 60% (l'ottimizzazione aggiunge poco, coerente con il 93% di passaggi casuali in utile).
- **O3** Almeno 8 selezionati con PF tick >= 1,0 nel 2025-26: 80%.
- **O4** Correlazione mensile della somma dei selezionati con GoldenZoe: |r| < 0,5: 75%.
- **O5** Il piu' alto PF in campione (selezionati) non e' il migliore in V1: 70% (effetto del vincitore).

## Limiti
Set di Wim: ricerca, fuori dalla flotta prop. L'oro D1 2013-2022 e' un solo regime e un solo mercato: anche i candidati che passano V1 valgono la famiglia oro D1 (un posto, correlata con le altre famiglie oro di Wim). Istantanea parziale: la genetica non ha convergito (357 passaggi su 1,7e29 nelle prime 4 ore).
