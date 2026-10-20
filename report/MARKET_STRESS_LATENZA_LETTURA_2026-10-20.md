# Stress del costo, parte 2: esecuzione ritardata -- lettura (20/10/2026)

**Non controllata da agenti.** Previsioni scritte prima: `MARKET_STRESS_LATENZA_ATTESE_2026-10-20.md`. Dati in `backtest_pipeline/risultati_archivio/STRESS_LATENZA_20261020/`. Corse continue 01/01/2025 - 01/10/2026, XAUUSD H1, 5.000 EUR, ticks reali, `ExecutionMode` 200 e 1000 ms nei .ini (verificato nei file).

| corsa | netto | PF | operazioni | DD equity | stato |
|---|---|---|---|---|---|
| Prop Firm, 0 ms (base) | +1.590,96 | 1,26 | 673 | 7,80% | OK |
| Prop Firm, 200 ms | **+1.420,95** (-10,7%) | 1,23 | 673 | 7,94% | OK |
| Prop Firm, 1000 ms | **+1.354,79** (-14,8%) | 1,22 | 673 | 8,48% | OK |
| Smart Gold Hunter, 0 ms (base) | +275,56 | 1,74 | 237 | 0,73% | OK |
| Smart Gold Hunter, 200 ms | **MISURA MANCANTE** | - | 0 | - | KO: timeout di 360 minuti, report non scritto |
| Smart Gold Hunter, 1000 ms | **+269,82** (-2,1%) | 1,72 | 237 | 0,74% | OK |
Input dei report identici a quelli della base (Prop Firm 24 righe, Smart Gold Hunter 94) per le tre corse valide; la corsa KO non ha report leggibile.

## Previsioni
- **L1** (Prop Firm a 1000 ms entro -20%/+10%, PF > 1,10, stesse operazioni +/-5%): **CONFERMATA** (-14,8%, PF 1,22, 673 = 673).
- **L2** (Smart Gold Hunter a 1000 ms positivo ma almeno -15%): **SBAGLIATA**: -2,1%, quasi insensibile.
- **L3** (a 200 ms entrambi entro il 10%): **Prop Firm SBAGLIATA di poco** (-10,7%, fuori di 0,7 punti); Smart Gold Hunter **non misurata** (KO).
- **L4** (nessuno stop-out): confermata sulle tre corse valide.
- Il ritardo viene applicato: i numeri cambiano rispetto alla base per tutte le corse valide (nessuna identica al centesimo).
## Verdetto alla soglia (netto > 0 e PF > 1,10 con costo stressato)
Prop Firm **PASSA** a 200 e a 1000 ms; Smart Gold Hunter **PASSA** a 1000 ms (a 200 ms non misurato).
## Cose da dire
- Il Prop Firm perde circa il 15% del netto con un secondo di ritardo: sensibilita' piccola ma non nulla, in coerenza con il costo analitico.
- **La mia stima di tempo era sbagliata**: avevo scritto "10-20 minuti in tutto" per le quattro corse; Smart Gold Hunter impiega circa un'ora a corsa (3.663 s a 1000 ms) e la corsa a 200 ms e' andata in timeout dopo 360 minuti (32.162 s di orologio). Non e' un risultato dell'EA: e' una misura mancante (come le altre corse lunghe bloccate sul PC di backtest); non concludo che Smart Gold Hunter "non regge" 200 ms.
