# Hold-out dei set US30 volatility M15 — risultati (22/11/2026)
Criteri e previsioni scritti prima: `UBS_HOLDOUT_CRITERI_2026-11-22.md`. Zip: `ANNO_ORO_GRADINI_UBSHO_20261122_1310.zip`. Dow clone a tick reali `U30USD_T`, 26/09-31/12/2024, Modello 4, M15, lotto 0,1, 100000 EUR. Flag "KO" e qualita 26% = formali (i tick reali partono dal 26/09, prima non ci sono dati: nessuna operazione possibile).

| Set | Operazioni | Netto | PF | DD equita |
|---|---|---|---|---|
| **g (vincolante)** | 14 | +35,34 | 4,50 | 36,66 (0,04%) |
| U3V12 | 15 | +91,33 | 3,22 | 166,60 |
| U3V08 | 14 | +70,42 | 2,31 | 57,01 |
| a | 9 | +51,08 | 2,31 | 56,80 |
| b | 4 | +16,92 | 20,45 | 21,51 (solo 4 operazioni: non interpretabile) |
| c | 15 | -14,52 | 0,75 | 74,96 |

**V4 per `g`: SUPERATO** (14 >= 8 operazioni, PF 4,50 > 1, netto > 0).
Previsioni: P-1 (g supera) si; P-2 (>= 12 operazioni) si, 14; P-3 (PF >= 1,5) si; P-4 (>= 4 set su 6 con PF > 1) si, 5 su 6. Tutte e quattro azzeccate (ero prudente).
`c` fallisce anche qui (PF 0,75), coerente con lo stress: e il set specifico del Dow e fragile.

**Limiti:** circa 3 mesi e 14 operazioni (potere statistico basso, un PF 4,5 su 14 operazioni ha un intervallo enorme); un solo regime (rialzo dopo le elezioni USA, non indipendente dal regime 2025-26); i set sono vicini tra loro (stessa famiglia, risultati correlati). Passare V4 = non e stato smentito sul periodo mai guardato, non e una prova di robustezza. Contatore di campagna +6.
**Stato di `US30_VOL_M15_g`:** M1 + tick + perturbazione + altro simbolo ("non orribile", vantaggio non confermato fuori dal Dow) + hold-out: candidato vivo, solo Dow. Prossimo cancello: correlazione con altri candidati (nessuno ancora) e forward demo.
