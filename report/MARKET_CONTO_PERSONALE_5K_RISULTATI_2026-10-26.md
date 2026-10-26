# Conto personale da 5.000 EUR, senza guardiano: risultati dei 9 EA (26/10/2026)
**Natura: MISURA + LETTURA.** Criteri e previsioni scritti prima: `MARKET_CONTO_PERSONALE_5K_CRITERI_2026-10-25.md` (commit 32a0c06a); lettore congelato `leggi_deep5k_personale.py` (commit 9bbd2f73). Archivio: `backtest_pipeline/risultati_archivio/DEEP5K_PERSONALE_20261026` (report compressi .gz, log non archiviati). Corsa continua 01/01/2025-01/10/2026, XAUUSD H1, tick reali 100%, **5.000 EUR**, leva 1:100 (quella del tester; la leva del broker personale: NON VERIFICATA), nessun guardiano, input confermati dai report. **Correzione al lettore, dichiarata:** lettura dei report compressi dell'archivio (percorso), nessun criterio toccato; autotest e riepilogo identici a quelli della prima lettura.

## Risultati
Nessun EA ha avuto uno stop out. Etichette (ordinamento di lettura, non consigli):

| EA | Netto EUR | % deposito | PF | DD equity dal picco | Peggior giorno | Lotto min nei primi 3 mesi | Etichetta |
|---|---|---|---|---|---|---|---|
| Gold Snap | +64.037 | +1.281% | 3,09 | 7.391 (12,4%) | -6,1% | 0% | REGGE |
| SomaGold | +38.231 | +765% | 3,63 | 4.314 (20,3%) | -6,9% | **73%** | **SCOSSO** (84 ordini rifiutati per margine, 32 posizioni insieme, 16 perdite di fila) |
| SixtyNine | +19.230 | +385% | 1,99 | 2.708 (12,0%) | -4,6% | 0% | REGGE (fino a 7 posizioni insieme) |
| Umbra Vault | +12.249 | +245% | 6,27 | 1.323 (11,2%) | -8,3% | 0% | REGGE |
| Microedge | +6.956 | +139% | 2,78 | 1.733 (13,75%) | -8,1% | 0% | REGGE |
| Vortex Turbo | +3.585 | +72% | 1,50 | 3.048 (**29,5%**) | **-12,5%** | 0% | **SCOSSO** (peggior mese -18,1%, 4 posizioni insieme) |
| Rocket Breakout | +3.386 | +68% | 1,40 | 686 (7,9%) | -3,6% | 0% | REGGE |
| Entry Points Pro | +199 | +4,0% | 1,08 | 575 (10,2%) | -1,5% | **50%** | REGGE, ma quasi nessun guadagno |
| ORB Revolution | -477 | -9,5% | 0,86 | 626 (12,4%) | -2,4% | 0% | REGGE + **PERDE** (11 perdite di fila) |

- **Nessuno BRUCIATO** (nessuno stop out, saldo realizzato minimo >= 89% del deposito, DD relativo massimo 29,5%).
- **Quasi identico a 80.000, in percentuale:** netto % e DD relativo a 5.000 sono entro pochi punti da quelli a 80.000 per tutti (Gold Snap +1.281% contro +1.277%, Umbra +245% contro +244%, Microedge +139% contro +140%, SixtyNine +385% contro +378%). Gli EA dimensionano il lotto sul saldo e a 5.000 il lotto minimo 0,01 non morde, salvo Entry Points (80% degli ingressi a 0,01 in tutto il periodo) e SomaGold (73% nei primi tre mesi, poi cresce).
- **SomaGold a 5.000:** nei primi tre mesi il lotto medio e 0,026 e il 73% degli ingressi e al minimo; ha 84 righe di "no money" (80.000: 92) e 32 posizioni insieme: il margine e il tratto fragile, come a 80.000, e per operare ha richiesto di spegnere `MarginCallProtection`.
- **Gold Snap:** lotto medio 0,37 nei primi tre mesi, 2,83 negli ultimi tre; il rischio per operazione dichiarato dagli input e `InpRiskPct=2,0`: tre perdite di fila (la serie massima e 3) fanno circa -6%.

## Previsioni scritte prima
P1 corse valide: **SI** (9/9). P2 nessuno stop out in >= 7 EA: **SI** (9/9). P3 rendimento % a 5.000 diverso da quello a 80.000 di oltre 20% relativo in >= 5 EA: **NO** (0 su 9, le differenze vanno da 0,3% a 19%). P4 DD relativo piu alto a 5.000 in >= 6 EA: **NO** (2 su 9: Entry Points e Microedge; gli altri piu bassi o uguali). P5 >= 3 EA con >= 30% di ingressi al lotto minimo nei primi tre mesi: **NO** (2: Entry Points, SomaGold). P6 un EA sopra il deposito a 80.000 che finisce sotto a 5.000: **NO**. P7 >= 3 EA con righe no money: **NO** (solo SomaGold). P8 almeno un BRUCIATO: **NO**; Vortex e SomaGold fra i due peggiori per DD relativo: **SI**. Totale: 3 giuste su 8; avevo sopravvalutato quanto il capitale piccolo cambia il comportamento, sottovalutando che i lotti scalano linearmente.

## Cosa significa e cosa no
- Nel tester a 5.000 nessuno dei nove ti brucia il conto. Questo NON e una garanzia: 21 mesi, un solo percorso; il tester non ha slippage, gap, spread di news, liquidita ne il margine del tuo broker; alcuni parametri sono ottimizzati dal venditore su periodi non dichiarati (Umbra, v1.1).
- Le code che il tester non mostra bene sono quelle di **Vortex** (martingala e griglia dichiarate dal venditore, DD 29,5%, mese -18%) e di **SomaGold** (margine, 32 posizioni, protezione spenta).
- ORB Revolution perde e Entry Points non guadagna: nessun vantaggio visibile in 21 mesi.
- Acquisti, lotti e taglie sono decisioni di Claudio, non mie. La variante Umbra 21-23 a 5.000 e in attesa dello zip.
