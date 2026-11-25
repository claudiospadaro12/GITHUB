# EA CPI M5, T2 (periodo indipendente 2018-2024), risultato (25/11/2026)

Fonte: Journal del tester (`journal_Tester_20261125.log`, sessione T2 delle 21:03). XAUUSD, **1 minuto OHLC**, 01/01/2018 -> 30/06/2024, preset B100 SL3000 (SL di sicurezza 30 USD), latenza zero, deposito 100.000 EUR. Test passato in 29 secondi, qualita' storico 98%. Il file report HTML non e' stato prodotto (nome del report nel `.ini`), i dati sono quelli del Journal (saldo finale e righe `[CpiM5]`).

| Misura | T2 (2018 -> 06/2024, M1 OHLC) | T1-bis (07/2024 -> 11/2026, tick reali) |
|---|---|---|
| Saldo finale | **99.603 EUR (-397)** | +1.077 USD |
| Eventi con operazione | 65 | 27 |
| Vincenti | 51% (33/32) | 70% |
| Profitto medio / perdita media (USD) | +35,4 / 48,5 | +121 / 153 (per 0,10 lotti) |
| **Profit factor** | **0,75** | **1,88** |
| Uscite per SL | 1 su 65 | 2 |
Per anno (somma USD): 2018 +26, 2019 +15, 2020 -287, 2021 -25, 2022 -175, **2023 +399**, 2024 (gen-giu) -339. Senza i 3 migliori eventi il netto di T2 e' -768 (PF 0,51).

## Lettura
- **Il vantaggio di T1-bis non si conferma nel periodo precedente.** La previsione scritta ("se T2 e' sotto 1,0 il vantaggio e' solo del 2024-26") si avvera: PF 0,75, netto negativo, e un solo anno su sette (2023) sopra +100.
- Unendo i due periodi (92 eventi): vincite 3.469, perdite 2.777, PF 1,25, ma **senza i tre eventi migliori di T1-bis (+655, +248, +240) il PF scende a 0,84**. Il risultato complessivo dipende da tre eventi del 2026.
- La simulazione Python su M1 (PF 1,05-1,71 per il 2018-22) era ottimista rispetto al tester M1 OHLC (che usa tick sintetici e spread della barra): il tester e' la misura piu' severa.
- **Conclusione:** l'EA CPI M5 NON e' un candidato per la flotta ne' per la prop. Se si vuole, resta un forward demo di osservazione (12 eventi l'anno, una posizione sola, magic 770801), senza aspettative: l'unico periodo positivo e' quello con candele CPI molto ampie (2026), e potrebbe essere regime e non vantaggio. Nessun consiglio su lotti.
