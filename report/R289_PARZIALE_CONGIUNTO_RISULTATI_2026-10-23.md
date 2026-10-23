# R289 -- round congiunto sul parziale (23/10/2026)
Fonte: `ROUND_R289_2026-10-23.zip` (pin 17d6e0cb, motore = pin SHA256, 6 round rc 0, catena completa, per-trade 12 su 12). Archivio `backtest_pipeline/risultati_archivio/R289_20261023/`. Lettore congelato `r289_giudizio.py`. Senza parziale = `InpTP1_ClosePct=0` (toglie anche il pareggio a TP1, annidato nel parziale).

**G0: le tre basi riproducono la misura storica al centesimo** (Dow = R246a, Nasdaq 770260 = R274a, Nasdaq 770250 = R286a). Gemelle coerenti.

| Cella | Base: PF IS / OOS | Senza parziale: PF IS / OOS | dPF IS / OOS | Profit IS / OOS (base -> senza) | DD IS / OOS (base -> senza) | Esito |
|---|---|---|---|---|---|---|
| Dow Apertura 770202 | 1,222 / 1,270 | 1,328 / 1,258 | +0,106 / -0,012 | 2812 -> 4174 / 6722 -> 7343 | 5,67 -> 5,67 / 4,39 -> 5,43 | DESCRITTIVO (56 deal IS); segno NON concorde |
| Nasdaq 770260 (retest, TP1 a 0,5R) | 1,221 / 1,215 | 1,116 / 1,149 | **-0,105 / -0,067** | 7014 -> 4550 / 8497 -> 7689 | **7,31 -> 12,36** / 7,86 -> 9,12 | DESCRITTIVO (82 deal IS); segno **negativo** in entrambe |
| Nasdaq 770250 (breakdown short) | 1,253 / 0,955 | 1,261 / 1,068 | +0,007 / +0,113 | 1052 -> 1155 / -193 -> 295 | 2,45 -> 3,03 / 1,94 -> 1,52 | DESCRITTIVO (39 e 36 deal); segno concorde positivo |
| DAX Apertura 770101 (da R288) | 1,126 / 1,397 | 1,183 / 1,491 | +0,057 / +0,094 | 3789 -> 5569 / 18030 -> 23607 | 5,44 -> 4,96 / 7,23 -> 6,27 | NON DISTINGUIBILE; segno concorde positivo |

## Verdetto congiunto (congelato): **MISTO**
2 celle su 4 con segno concorde positivo (DAX e Nasdaq 770250), 0 PEGGIO secondo il criterio (il Nasdaq 770260 e' negativo in entrambe le gambe ma sotto 0,10 in OOS). **Non c'e' un indizio coerente che il parziale non aiuti.**
- **Nasdaq 770260:** senza parziale peggiora PF e drawdown (IS 7,31% -> 12,36%). Qui il parziale (TP1 a 0,5R, molto precoce) sembra proteggere. E' l'unica cella con segno negativo concorde.
- **Dow Apertura:** misto (IS +0,106, OOS -0,012); il DD OOS peggiora.
- **Nasdaq 770250 e DAX:** segno positivo, ma il 770250 ha 36-39 deal e un OOS a pareggio (PF 0,955 -> 1,068): troppo poco per leggerlo.
- **Il "toro favorisce il senza-parziale" non si e' visto come atteso**: in due celle su quattro e' il contrario o neutro.
- Nota di metodo: senza parziale i deal calano (niente uscite parziali), quindi il filtro "almeno 100 deal per gamba" penalizza i bracci senza parziale; il numero di posizioni e' lo stesso. Il verdetto congelato resta quello scritto; i segni riportati qui sopra sono comunque dai numeri.
- Attese dichiarate: P1 si', P2 si', P3 NO (Dow non concorde), P4 NO (770260 negativo), P5 si' (770250), P6 NO (misto), P7 si'.
**Cosa NON dice:** niente sull'orso; le quattro celle non sono indipendenti; nessuna promozione e nessuna modifica ai set. Il parziale **non va tolto** sulla base di questi dati (e non e' un risultato per toglierlo da nessuna sedia): il segno dipende dalla cella.
