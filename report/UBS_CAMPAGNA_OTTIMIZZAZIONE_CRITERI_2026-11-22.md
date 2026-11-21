# Campagna di ottimizzazione UBS su TUTTI i modelli di Wim: criteri e previsioni (scritti il 22/11/2026, PRIMA di qualunque numero della campagna)
**Natura: CRITERI.** Richiesta di Claudio (21/11): "voglio testare tutto, non solo quello che ti sembra vada bene". Nessuna selezione per aspettativa: l'ordine segue la disponibilita dei dati. Solo tester/demo; VPS e reale 10105439 non toccati; nessun consiglio su lotti/taglie/acquisti. Soglie non si abbassano dopo i numeri. Ogni ottimizzazione e un tentativo: si riporta il numero REALE di passaggi (scheda Ottimizzazione di MT5) e si somma al contatore di campagna (2.027 + 625 + 625 + 15 volatility M15 + ...).
Metodo: manuale UBS di Wim (`UBS_MANUALE_PROCEDURA_2026-11-21.md`) con le correzioni nostre: tutti gli input nel [TesterInputs] (lezione del pilota oro), passata di controllo prima, lotto fisso 0,1, deposito 100000 EUR, genetica veloce, criterio Custom max (6), Modello 1 per l'ottimizzazione, agenti locali, no forward, no cloud. Strumento: `AVVIA_OTT_GEN.ps1` (v1: MT5 portable; indici `_EXT` e Bitcoin FTMO richiedono altre varianti).

## 1. Coda (11 modelli di ottimizzazione di Wim) e dati
| # | Modello (set di ottimizzazione) | Simbolo/periodo | Terminale | Minimi Custom max |
|---|---|---|---|---|
| 1 | Goldtrade Pro (`optimization_gold.set`) | XAUUSD D1 | portable | TR 100, RF 3, EP 0 |
| 2 | Goldbot One (`Optimization.set`) | XAUUSD D1 | portable | come il set (RF 3, TR 200) |
| 3 | Gold Various daily (`Variable paramaters (daily)`) | XAUUSD D1 | portable | TR 100, RF 3 |
| 4 | Gold Various H4 (`old optimizations XAUUSD H4`) | XAUUSD H4 | portable | TR 150, RF 3 |
| 5 | Gold Reaper (`optimization.set`) | XAUUSD H1 | portable | come il set (EP 1,5, RF 8, TR 800) |
| 6 | Daytrade 2 D1 (`optimization.set`) | EURUSD D1 e GBPUSD D1 (due ottimizzazioni) | portable | come il set (TR 100) + RF 3 |
| 7 | Advanced Scalper (`Optimization_set.set`) | EURUSD H1 | portable | **EP 3, RF 3, TR 400** |
| 8 | Indicement US500 | SPXUSD_EXT H1 | principale (variante da fare) | come il set (RF 3, TR 400) |
| 9 | Indicement USTEC | NASUSD_EXT H1 | principale (variante da fare) | come il set (RF 3, TR 300) |
| 10 | Indicement US30 | U30USD nativo | portable | come il set (RF 3, TR 200); storico solo dal 2024: esplorativo |
| 11 | Bitcoin Scalp Pro | BTCUSD H1 (dati FTMO 2016-2026) | FTMO (variante da fare) | TR 300, RF 3 |
Seconda ondata: le ~40 "old optimizations" per set singoli (oro D1, H1, H4). **EP 3 sullo scalper** = costo a tick misurato il 21/11 (circa 1,4-2,0 EUR a operazione a 0,1 lotti) piu margine; vale anche per ogni altro gruppo forex H1/M15.

## 2. Finestre (fisse)
- **Oro (1-5):** IS 2013-01-01 -> 2022-12-31 (come il pilota). **V1 OOS pre-campione: 2004-01-01 -> 2012-12-31** (storico oro BCM 2004-2026, 23 file anno; Modello 1). **V3 tick: 2025-01-01 -> 2026-11-13**, Modello 4 e Modello 1. **V4 hold-out: 2023-01-01 -> 2024-12-31**, aperto UNA volta.
- **Forex (6, 7):** IS 2013-01-01 -> 2020-12-31 se lo storico BCM parte dal 2013 (la copertura va controllata con una riga di sola lettura prima), V1 OOS 2021-2022, V4 hold-out 2023-2024, V3 tick 2025-2026 (tick BCM dal 07/2024).
- **Indici EXT (8, 9):** IS 2010-2019, V1 OOS 2020-2023, V4 hold-out 2024, V3 tick sui simboli nativi 2025-01-01 -> 2026-10-31. Limite dichiarato: orologio `_EXT` verificato solo in 3 blocchi.
- **US30 (10):** IS 2024-09-01 -> 2025-08-31, V1 OOS 2025-09-01 -> 2026-11-13 (tick): campione piccolo, dichiarato esplorativo.
- **Bitcoin (11):** IS 2017-2022, V1 OOS 2023-2024, V4 hold-out/tick 2025-2026 (se i tick FTMO mancano: solo Modello 1, dichiarato).
- Tetto 12 ore per ottimizzazione; se non converge, si riporta com'e.

## 3. Selezione e cancelli (identici per tutti i gruppi)
- **Selezione:** dalla tabella finale si prendono fino a **10 candidati distinti**: 40% migliori per Result, 30% piu diversi (curve diverse, per recovery e DD), 30% a caso fra gli idonei (regola dell'app di Wim). Idoneo IS: PF >= 1,30, operazioni >= TR, profitto > 0, anni positivi >= 60%.
- **V1 (OOS pre-campione):** PF >= 1,20, profitto > 0, operazioni >= 30 (>= 20 per D1), anni non negativi >= 60%.
- **V2 (perturbazione):** variando di un passo ciascun parametro libero, >= 70% delle varianti con PF > 1,0 sia in IS sia in V1.
- **V3 (tick):** PF tick/1 minuto >= 0,7, PF tick >= 1,0, DD tick <= 1,5 x DD a 1 minuto; sotto 0,5 = bocciato.
- **V4 (hold-out):** PF > 1,0 se operazioni >= 8, una sola volta, solo sui finalisti.
- **Candidato** = V1+V2+V3+V4. Poi: correlazione dei P&L giornalieri fra candidati (> 0,7: se ne tiene uno) e con la deriva dell'oro (correlazione con il trend D1 dell'oro <= 0,5, come nei test del 20-21/11).
- **Un gruppo con 0 candidati si scrive "nessun candidato":** nessun cambio di soglia, nessuna seconda ottimizzazione con intervalli modificati dopo aver visto i numeri.

## 4. Previsioni (scritte ora)
- **C-1** Almeno un candidato (V1+V2) per i modelli oro 1-5 presi insieme: 40%; per l'oro H1 (Gold Reaper) da solo: 20%.
- **C-2** Daytrade 2 D1 (EURUSD/GBPUSD): almeno un candidato V1+V2: 15%. Advanced Scalper: 5%.
- **C-3** Indici EXT (8, 9): almeno un candidato V1+V2: 15%; US30 nativo: 10%. Bitcoin: 15%.
- **C-4** Almeno un candidato che passa TUTTO (V1-V4) nell'intera campagna: 30%; almeno tre non correlati (> 0,7): 8%.
- **C-5** Fra i candidati dell'oro, PF V1 (2004-2012) mediano minore del PF IS di almeno il 25%: 75%.
- **C-6** Rapporto PF tick/1 minuto >= 0,7 per i candidati non-scalper: 70%; per ogni candidato scalper: 15%.
- **C-7** Il numero reale di passaggi di una genetica e inferiore a 10.000: 60%.

## 5. Cosa NON sappiamo
Durata reale di una genetica (stima 4-8 ore, mai misurata); copertura BCM del forex prima del 2013; se la genetica converge; il costo a tick sull'oro (tick BCM dell'oro: presenza da verificare); la sovrapposizione del campione di Wim con le nostre finestre (i suoi IS: oro/forex 2012-2023, indici 2020-2023: le nostre ottimizzazioni ripartono da zero con i suoi intervalli, quindi i suoi IS non contano come campione nostro, ma i suoi set pubblicati si).
**Peso:** 11-13 ottimizzazioni (circa 2-4 giorni di PC) + convalide (circa 40 passate per candidato).
