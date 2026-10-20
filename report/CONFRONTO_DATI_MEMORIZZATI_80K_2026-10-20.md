# Dati memorizzati per il confronto (corse continue 01/01/2025-01/10/2026, deposito 80.000 EUR, ticks reali) -- 20/10/2026

**Non controllata da agenti.** Fonti: `risultati_archivio/TEST80K_20261019/` (Prop Firm, Smart Gold Hunter), `risultati_archivio/GR80K_20261020/` (Gold Reaper). Serve per confrontare The ORB Master (e DayTrade Pro) quando arrivano.

| | Prop Firm Gold EA | Smart Gold Hunter | **The Gold Reaper (set Claudio)** | The ORB Master |
|---|---|---|---|---|
| netto | +34.129,71 (+42,7%) | +275,56 | **+59.796,28 (+74,7%)** | da misurare |
| PF | 1,25 | 1,74 | **2,89** | |
| operazioni | 673 | 237 | 791 | |
| DD equity dal picco | 9,72% | - | 2,97% | |
| **DD equity in % degli 80K iniziali** | **13,8%** (11.023) | - | **4,8%** (3.854) | |
| lotti | 0,16-0,31 | 0,01 fisso | 0,07-0,42 (rapporto 6,0) | |
| posizioni max | 3 | - | 11 | |
| mesi positivi | 14/21 | - | 18/21 (85,7%) | |
| netto/costo (K=1) | 11,9x | - | 27x | |
| peggior giorno | -2.502 | - | -1.514 (1,9%) | |
| S-NOSCALA | ok | ok | **NO** (lotti 6,0; 11 pos.) | |

Portafoglio Prop Firm + Gold Reaper a 80K: correlazione giornaliera 0,122 (IC95 0,022-0,221), mensile 0,450; netto +93.926; DD realizzi 10,13% di 80K; tetto (somma DD equity) 18,6% -> **S-PORT non passa**. Prop Firm + Smart Gold Hunter: DD realizzi 12,5%, tetto 13,8%.

Regola di lettura per ogni nuovo EA: DD SEMPRE sia dal picco sia in % degli 80.000 iniziali; correlazione con serie giornaliere dei realizzi (e mensile) contro Prop Firm e Gold Reaper; S-PORT sul tetto.
