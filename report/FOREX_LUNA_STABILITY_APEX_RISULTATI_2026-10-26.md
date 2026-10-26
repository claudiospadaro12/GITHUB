# Luna AI Pro, Stability Pro, Apex Trader a 80.000 EUR, anno 2025: RISULTATI (26/10/2026)
Criteri e previsioni: `FOREX_LUNA_STABILITY_TEST_CRITERI_2026-10-26.md`. Zip `ANNO80K_FOREX_20261026_2119` (10 passate, tutte stato OK, `input_ok = si`, qualita 99-100%); archivio `risultati_archivio/ANNO80K_FOREX_ZIP_2119`. EURUSD con OneChartSetup, 80.000 EUR, 01/01/2025-01/01/2026, leva 1:100; Luna e Apex a tick reali, Stability a Modello 1. Durata di ogni passata: 10-36 minuti (molto meno dei 10-30 ore stimati).

| Corsa | Netto / PF (manifest) | DD equity | DD saldo | Lotti | Pos. insieme | Permanenza max | Peggior giorno realizz. | stop out / no money |
|---|---|---|---|---|---|---|---|---|
| Apex Optimal LS15000 (consigliato oltre 15.000 USD) | +36.676 (+45,8%) / 4,96 | **30.483 (35,2%)** | 1,1% | 0,05-1,89 | 47 | 32,9 gg | -79 | 0 / 0 |
| Apex Elevated LS3000 | +52.431 / 2,77 | **48.198 (53,3%)** | 2,3% | 0,26-2,34 | 47 | 32,9 gg | -332 | 0 / 0 |
| Apex Optimal LS7500 | +91.787 / 4,92 | **76.898 (81,5%)** | 2,1% | 0,10-4,86 | 47 | 32,9 gg | -132 | 0 / 2.700 righe |
| Apex Conservative LS2000 | +40.426 / 2,13 | **40.476 (45,0%)** | 2,5% | 0,40-1,16 | 47 | 32,9 gg | -504 | 0 / 0 |
| Apex Ultra LS2000 | +19.180 / 1,72 | **21.339 (25,0%)** | 1,5% | 0,40-0,49 | 47 | 32,9 gg | -468 | 0 / 0 |
| Apex Extreme LS5000 | **-60.981** / 0,31 | **83.473 (81,4%)** | 81,4% | 0,16-5,40 | 33 | 32,9 gg | **-83.486 (-81,4%)** | **18 / 4** |
| Luna LS400 (manuale: basso) | +7.740 (+9,7%) / 1,45 | 6.586 (7,4%) | 5,6% | 1,10-2,21 | 4 | 4,2 gg | -2.563 (-3,0%) | 0 / 0 |
| Luna LS100 (set "medium"; manuale: alto) | +35.456 (+44,3%) / 1,38 | **35.558 (29,8%)** | 22,5% | 5,96-11,93 | 4 | 4,2 gg | **-13.838 (-12,7%)** | 0 / 0 |
| Stability Pro rischio 5 | +875 (+1,1%) / 1,83 | 1.182 (1,5%) | 0,2% | 0,03-0,32 | 15 | 13,6 gg | -22 | 0 / 0 |
| Stability Pro rischio 1 | **identica alla precedente** | | | | | | | |

## Lettura
- **Apex Trader e una griglia che paga con il flottante.** In tutte le configurazioni il drawdown del saldo (realizzato) e minuscolo (1-2,5%) mentre quello dell'equity va dal 25% all'81%: fino a 47 posizioni insieme, tenute fino a 33 giorni. FTMO misura l'equity: **anche la configurazione consigliata dal manuale per questo conto (Optimal, LotsizeStep 15000) ha un DD equity del 35%**, oltre tre volte il limite del 10%. La Extreme ha bruciato il conto (18 stop out, -81%); la Optimal con LotsizeStep 7500 ha chiuso a +115% ma con DD equity 81% e 2.700 righe "no money" (margine esaurito). Caveat di scala: i set Ultra/Conservative/Elevated sono pensati per conti da 2.000-15.000 USD; a 80.000 con LotsizeStep 2000-3000 i lotti sono 0,26-0,40 (cioe molto piu aggressivi di quanto il venditore intendesse): il confronto fra set e a pari LotsizeStep, non a pari rischio. Il killswitch sul DD storico in pip (acceso) e MaxAllowedDD spento non hanno evitato questi drawdown.
- **Luna AI Pro con LotsizeStep 400 (basso nel manuale) e il profilo piu contenuto:** +9,7% in un anno, DD equity 7,4% (6.586 EUR, dentro gli 8.000 della soglia del progetto), 340 operazioni (sopra le 150), massimo 4 posizioni, permanenza massima 4,2 giorni, peggior giorno realizzato -3,0%. Con LotsizeStep 100 (il valore del set "recommended medium" del venditore, che il manuale chiama rischio alto) il rendimento e +44% ma DD equity 29,8% e un giorno a -12,7%: non adatto a una prop. Un solo anno (2025), filtro news spento (non simulato), AutoGMT spento con offset 1/1: le conclusioni valgono per questi parametri.
- **Stability Pro: la misura NON e valida come test del rischio.** Le due corse (rischio 5 e rischio 1) sono identiche al centesimo: l'input `AutoLotsizeRisk` e stato applicato (il report lo conferma) ma non cambia nulla con `AutoLotMode=2`: la mappa dei modi di lotto (INFERITA) e sbagliata e con questo modo i lotti restano indipendenti dal rischio (0,03-0,32). Risultato +875 (+1,1% in un anno), DD equity 1,5%, 15 posizioni insieme, permanenza fino a 13,6 giorni. Per misurare il rischio serve il modo giusto: si legge dal menu a tendina `AutoLotMode` nella scheda Input del tester (screenshot di Claudio).

## Previsioni (scritte prima)
F1 (tutte e 4 le corse valide): centrata. F2 (Stability DD equity >= 2x quello realizzato): centrata (1,5% contro 0,2%) ma sulla corsa non valida. F3 (Luna >= 150 operazioni): centrata (340). **F4 (nessun giorno >= 5% in nessuna corsa): mancata** (Apex Extreme -81%, Luna LS100 -12,7%). F5 (Stability R1 DD equity < 10%): centrata, sulla corsa non valida. F6 (Apex LS7500 DD equity piu del doppio di LS15000): centrata (81,5% contro 35,2%). F7 (Apex posizione tenuta oltre 10 giorni): centrata (32,9). F8 (correlazione Apex-Stability > 0,5): non misurabile, Stability a lotto minimo. F9 (almeno 8 corse valide su 10): centrata sulle etichette, ma Stability conta come una.

## Cosa NON dice
Un solo anno (2025) a tick reali; Luna con filtro news spento; slippage non misurata; nessun merito d'acquisto, lotto o taglia. L'equity DD e quello del tester (picchi intrabarra a tick reali).
