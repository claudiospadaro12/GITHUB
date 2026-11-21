# Correlazione del Supertrend long sull'oro con il trend D1 e con l'oro tenuto fermo (criteri PRIMA dei numeri, 21/11/2026)
**Domanda:** il Supertrend long (H1/H4) aggiunge qualcosa di diverso dal trend D1 long dell'oro (proxy di GoldenZoe: **Donchian 55 giorni, stop 3 ATR, Chandelier 3 ATR**, del test del 21/11) o e' lo stesso rischio? Oro FTMO M1 2004-2026. Script `backtest_runner/simulatore/supertrend_correlazione.py`.
## Misure
Serie giornaliere di rendimento % **pesate per l'esposizione** (rendimento orario dell'oro per ogni ora in cui la posizione e' aperta, sommato per giorno; **costi ignorati**): **A** Supertrend H1 long, **B** Supertrend H4 long (uscita al cambio di Supertrend, ingresso all'apertura dopo il segnale), **C** Donchian 55 D1 long, **D** oro tenuto fermo. **Correlazione di Pearson giornaliera e mensile** (somma dei rendimenti giornalieri del mese), periodo intero e dal 2015; quota dei giorni in cui due sistemi sono entrambi in posizione.
## Previsioni (prima dei numeri)
- Correlazione B-C giornaliera >= 0,6: **75%**; mensile >= 0,6: **75%**. A-C giornaliera >= 0,5: 70%. B vs D (oro fermo) >= 0,5: **70%**. Nei giorni in cui C e' in posizione, B lo e' nel 70% dei casi: **70%**.
## Lettura (fissata ora)
Correlazione >= 0,7 (giornaliera o mensile): **"non diversifica"**; 0,4-0,7: **"diversifica poco"**; < 0,4: "diversifica". Un valore alto non dice che il Supertrend sia inutile come uscita/filtro; dice solo che non e' un secondo EA scorrelato. Nessun consiglio di taglie.
