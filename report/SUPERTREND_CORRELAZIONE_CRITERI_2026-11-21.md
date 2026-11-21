# Correlazione del Supertrend long sull'oro con il trend D1 e con l'oro tenuto fermo (criteri PRIMA dei numeri, 21/11/2026)
**Domanda:** il Supertrend long (H1/H4) aggiunge qualcosa di diverso dal trend D1 long dell'oro (proxy di GoldenZoe: **Donchian 55 giorni, stop 3 ATR, Chandelier 3 ATR**, del test del 21/11) o e' lo stesso rischio? Oro FTMO M1 2004-2026. Script `backtest_runner/simulatore/supertrend_correlazione.py`.
## Misure
Serie giornaliere di rendimento % **pesate per l'esposizione** (rendimento orario dell'oro per ogni ora in cui la posizione e' aperta, sommato per giorno; **costi ignorati**): **A** Supertrend H1 long, **B** Supertrend H4 long (uscita al cambio di Supertrend, ingresso all'apertura dopo il segnale), **C** Donchian 55 D1 long, **D** oro tenuto fermo. **Correlazione di Pearson giornaliera e mensile** (somma dei rendimenti giornalieri del mese), periodo intero e dal 2015; quota dei giorni in cui due sistemi sono entrambi in posizione.
## Previsioni (prima dei numeri)
- Correlazione B-C giornaliera >= 0,6: **75%**; mensile >= 0,6: **75%**. A-C giornaliera >= 0,5: 70%. B vs D (oro fermo) >= 0,5: **70%**. Nei giorni in cui C e' in posizione, B lo e' nel 70% dei casi: **70%**.
## Lettura (fissata ora)
Correlazione >= 0,7 (giornaliera o mensile): **"non diversifica"**; 0,4-0,7: **"diversifica poco"**; < 0,4: "diversifica". Un valore alto non dice che il Supertrend sia inutile come uscita/filtro; dice solo che non e' un secondo EA scorrelato. Nessun consiglio di taglie.

## RISULTATI (script `supertrend_correlazione.py`; output `SUPERTREND_CORRELAZIONE_RISULTATI_2026-11-21.txt`; 5.773 giorni, 2004-06-11 / 2026-11-18)
- **Esposizione (quota di ore in posizione):** Supertrend H1 52%, Supertrend H4 53%, Donchian 55 D1 24%, oro fermo 100%.
- **Correlazione giornaliera / mensile:**

| Coppia | Intero | Dal 2015 | Dal 2020 |
|---|---|---|---|
| **B Supertrend H4 - C Donchian D1** | **0,44 / 0,58** | 0,48 / 0,64 | 0,47 / 0,63 |
| A Supertrend H1 - C Donchian D1 | 0,35 / 0,52 | 0,40 / 0,52 | 0,37 / 0,45 |
| A - B (H1 con H4) | 0,65 / 0,69 | 0,65 / 0,72 | 0,66 / 0,71 |
| B Supertrend H4 - oro fermo | 0,69 / 0,75 | 0,69 / 0,75 | 0,69 / 0,75 |
| A Supertrend H1 - oro fermo | 0,69 / 0,78 | 0,69 / 0,81 | 0,68 / 0,80 |
| C Donchian D1 - oro fermo | 0,48 / 0,54 | 0,51 / 0,57 | 0,49 / 0,55 |
- **Sovrapposizione:** nei giorni in cui il Donchian D1 e' in posizione, il Supertrend H4 lo e' nel **76%** dei casi; nei giorni in cui il Supertrend H4 e' in posizione, il Donchian lo e' nel **30%**.
- **Lettura (regola scritta): "diversifica poco"** (B-C giornaliera 0,44, mensile 0,58-0,64: nella fascia 0,4-0,7; nessun valore >= 0,7 fra B e C). **Il Supertrend long e' piu' vicino all'oro fermo (0,69 giornaliera, 0,75 mensile) del trend D1 (0,48 / 0,54)**: e' soprattutto esposizione all'oro per meta' del tempo.
- **Previsioni:** B-C giornaliera >= 0,6 (75%): **no (0,44)**; mensile >= 0,6 (75%): **sul filo (0,58 intero, 0,64 dal 2015)**; A-C giornaliera >= 0,5 (70%): **no (0,35)**; B contro oro fermo >= 0,5 (70%): **si' (0,69)**; B in posizione quando C lo e' (70%): **si' (76%)**.
- **Limiti:** proxy di GoldenZoe = Donchian 55 D1 (non il suo codice H4); rendimenti senza costi; esposizione oraria approssimata (Donchian: giorni interi); il rendimento cumulato non e' stato riportato (il riepilogo stampato era arrotondato e non leggibile). Altre coppie con gli EA oro della flotta (Reaper, Phantom ecc.) non misurate.
