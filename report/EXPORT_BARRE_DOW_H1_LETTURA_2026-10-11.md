# Export barre H1 del Dow (U30USD BCM): lettura dello zip dell'11/10/2026

**11/10/2026 (sera)** · riga passata dal cancello (commit PASS `7d3e1d03`, riga `ae0e747e` SHA256 `69F89F34…9391`, pin `031c921d`) · lanciata sul PC di backtest, run `91fbb7cf1900`.

## Cosa e' tornato (FATTO, dal RIEPILOGO e dal giornale del tester)
- Compilazione dell'EA `CLAU12_EXPORT_BARRE_H1`: **0 errori, 0 avvisi** (prima compilazione di sempre).
- Passata del tester `successfully finished` in 0,8 s; qualita' della storia **100%**; finestra 2024.09.26 -> 2026.10.11.
- CSV: **11.755 barre**, prima `2024.09.26 16:00`, ultima `2026.10.09 20:00`, `errori_copia=0`, `scartate=0`; SHA256 `FAE044F5…DC57`. Archivio: `backtest_pipeline/risultati_archivio/EXPORT_BARRE_DOW_H1_20261011/`.
- Il giornale del terminale dice, di passaggio, che il conto demo alla sincronizzazione aveva **5 posizioni e 0 ordini** aperti (riga `terminal synchronized ... 5 positions, 0 orders`): FATTO dal log, da non confondere con lo stato delle sedie.

## Collaudo `collaudo_export_barre_h1.py` (SHA256 `7AFC123B…`, quello approvato): **VERDETTO PASS**
- **Ancora A2**: barre in [2024.09.26 00:00 ; 2026.08.17 17:00] = **10.859 contro 10.859** della sonda del 17/08 (+0,00%): l'insieme dei dati del tester e' quello del terminale. 
- **Barre per anno** (A3): 2025 intero = **5.744** (attese 5.455-6.029): OK.
- **Chiusure** (A5): 20, tetto 30,5; le piu' grandi sono feste (Natale 2024 31 h, Capodanno 26 h, Venerdi' Santo 2025 73 h).
- **Orologio** (A4, la misura che conta): il salto della mediana di (high-low)/open all'apertura cash e' alla barra **15 d'INVERNO** (2024/25 x2,28; 2025/26 x2,67) e alla barra **14 d'ESTATE** (2025 x2,36; 2026 x1,87). Scritto prima: UTC+1 fisso = 15 d'inverno / 14 d'estate; il vecchio orologio (IT-1 tutto l'anno) darebbe 14 sempre; un feed spostato di +1 h darebbe 15/16. **Esito: UTC+1 FISSO, confermato su una fonte indipendente dal referto del 24/09** (le barre, non i deal): d'inverno BCM = ora italiana.
- **Inverni H3**: in questo feed sono **COPERTI solo 2024/25 e 2025/26** (98% dei giorni feriali); 2012/13-2023/24 **ASSENTI** (0%): il feed BCM del Dow parte dal 26/09/2024. Gli altri inverni restano solo in Dukascopy.

## Cosa ne consegue (e cosa NO)
- Il regime dell'IS 2024/25 della scheda EMA200 (sez. 1.8: oggi `[NON MISURATO]`) **si puo' ora etichettare**: serve uno script con la regola DK scritta prima (non fatto).
- **Nessun inverno in piu' per H3**: il numero di inverni valutabili non cambia da questo export.
- L'orologio d'inverno BCM e' confermato da una seconda misura: peso per la decisione sull'orologio (`report/DECISIONE_OROLOGIO_INVERNALE_BCM_2026-10-11.md`, scadenze DAX 25/10 e USA 01/11): la domanda (D) «ri-misurare prima» ha ora una risposta sui prezzi per i dati dal 2024.09.26.

## Limiti
- L'ora delle barre e' l'ora server del feed; il collaudo verifica l'offset solo per i segmenti con salto misurabile (l'estate 2024 e' NON VALUTABILE: 8 salti).
- Il passaggio dei 5 file (RIEPILOGO, CSV, giornale, ini, compile.log) e' coerente col run id; la data del RIEPILOGO e' quella di oggi.
- Nessuna decisione presa.
