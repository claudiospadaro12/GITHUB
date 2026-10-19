# Test a fondo EA Market gruppo A -- lettura PARZIALE (19/10/2026, 8 EA su 10)

**Non controllata da agenti.** Soglie e criteri: `MARKET_SELEZIONE_PER_ACQUISTO_ATTESE_2026-10-19.md`; previsioni: `MARKET_TEST_A_FONDO_ATTESE_2026-10-19.md`. Ricevuti 8 zip DEEP (manifest e referti archiviati in `backtest_pipeline/risultati_archivio/DEEP_MARKET_A_20261019/`); **mancano Quantum iGold e PolyGold** (il giro stava ancora lavorando). Strumenti: `an_deep.py`, `an_deep2.py`.

## Conformita' e input [LETTO]
Per tutti e 8: 21/21 tranche OK + corsa continua OK, ticks reali 100%, nessuno stop-out, `.ex5` con impronta uguale prima e dopo. **Input scritti nei report identici a quelli del setaccio per tutti** (controllo fatto per nome, valore per valore): il giro e' conforme.

## Numeri (5.000 EUR, XAUUSD H1, gen 2025 - set 2026)
| EA | mesi positivi | somma 21 mesi indip. | continua: netto | op. | DD mensile max | DD cont. dal picco | perdita max dal deposito | lotto min-max | pos. max |
|---|---|---|---|---|---|---|---|---|---|
| Prop Firm Gold EA | 14/21 | +1.570 | +1.591 (PF 1,26) | 673 | 6,6% | 7,8% | 0,0% | 0,01 | 3 |
| Smart Gold Hunter | 18/21 | +281 | +276 (PF 1,74) | 237 | 0,6% | 0,7% | 0,1% | 0,01 | 1 |
| Ghost Scalper | 15/21 | +1.214 | +1.215 (PF 1,46) | 2.651 | 3,3% | 4,9% | 4,7% | 0,01 | 5 |
| Quantum Titan | 17/21 | +6.088 | +10.987 (PF 2,19) | 462 | 10,0% | 10,1% | 3,7% | 0,08-0,53 | 2 |
| TitanForge | 18/21 | +9.471 | +23.883 (PF 1,91) | 339 | **16,1%** | 22,6% | 4,5% | 0,29-1,89 | 1 |
| Nebula Cartographer | 16/21 | +10.541 | +26.027 (PF 1,73) | 440 | **33,6%** | 43,4% | 4,8% | 0,30-2,32 | 1 |
| EA Super Trend XAUUSD | 20/21 | +42.841 | **+3.539.220** (PF 1,94) | 1.931 | **24,0%** | 21,5% | 3,6% | 0,05-**34,93** | 1 |
| AI Golden Life | **6/21** | **-181** | -165 (PF 0,96) | 1.746 | 2,2% | 4,1% | 3,8% | 0,01 | 1 |

## Soglie (lette alla lettera)
| EA | S-N (>=150) | S-M (>=60% mesi, somma>0) | S-H (somma>0 in gen25-mag26 e giu26-set26) | S-DD (mensile <=15,2%; perdita dal deposito <=10%) | S-NOSCALA (lotto max/min <=3, <=10 pos., no martingala) | S-COSTO (media/op >= 3x spread) |
|---|---|---|---|---|---|---|
| Prop Firm Gold EA | si | si | si | si | si | si (13,2x) |
| Smart Gold Hunter | si | si | si | si | si | si (6,6x) |
| Quantum Titan | si | si | si | si | **NO** (x6,6, lotto proporzionale al saldo) | si (6,3x) |
| Ghost Scalper | si | si | si* | si | si | **NO** (2,7x, per poco) |
| TitanForge | si | si | si (+76 negli ultimi 4 mesi) | **NO** (16,1%) | **NO** (x6,5) | si (4,0x) |
| EA Super Trend | si | si | si | **NO** (24,0%) | **NO** (x699) | si (17,8x) |
| Nebula Cartographer | si | si | **NO** (-385 negli ultimi 4 mesi) | **NO** (33,6%) | **NO** (x7,7) | **NO** (2,9x) |
| AI Golden Life | si | **NO** | **NO** | si | si | **NO** |
\* S-H: per **meta' vere** (10+11 mesi) Ghost Scalper avrebbe -35 nella prima meta': il testo scritto prima dice date (gen25-mag26 / giu26-set26) e la formula "meta' cronologiche" era imprecisa (17+4 mesi, non 10+11): **ho applicato le date scritte**, lo dichiaro; con le meta' vere Ghost avrebbe 1 criterio in piu' fallito.
S-COSTO usa uno spread di circa 20 punti (0,18 EUR per 0,01 lotto): approssimato.
**Nota su S-NOSCALA**: Quantum Titan, TitanForge, Nebula, EA Super Trend hanno **lotti proporzionali al saldo** (lotti per 1.000 EUR di saldo costanti, uguali dopo una perdita e dopo una vincita): **non e' martingala**, e' interesse composto. La soglia scritta (lotto max/min <= 3) li boccia lo stesso, e la lascio cosi': il rischio in euro cresce con il saldo.
**S-STAB** (Prop Firm Gold EA, randomizzazione dichiarata): non ancora fatto (3 ripetizioni della corsa continua).

## Gruppi per criteri (non per profitto)
1. **Passano tutte le soglie** (S-STAB da fare per il primo): Prop Firm Gold EA, Smart Gold Hunter.
2. **Falliscono una sola soglia**: Quantum Titan (solo S-NOSCALA, per il lotto composto), Ghost Scalper (solo S-COSTO, 2,7x contro 3x).
3. **Composto aggressivo, drawdown mensile oltre soglia**: TitanForge (2 soglie), EA Super Trend (2 soglie), Nebula (4 soglie).
4. **Scartato**: AI Golden Life (perde in 15 mesi su 21, somma negativa).

## EA Super Trend: i numeri non sono credibili come previsione
+42.841 EUR come somma di 21 mesi, **+3.539.220 EUR nella corsa continua** (da 5.000): il lotto sale da 0,05 a **34,93 lotti** perche' proporzionale al saldo (autolot: 0,01 per ogni 1.000 EUR). Un conto reale con 35 lotti sull'oro avrebbe slippage e spread che il tester non simula; il risultato mostra solo che con un autolot aggressivo e 21 mesi buoni l'interesse composto fa cifre irreali. Il drawdown mensile del 24% e' il dato prudente.

## Previsioni (scritte prima)
- **P2** (TitanForge e Nebula con PF < 10 su 21 mesi): **CONFERMATA** (PF continua 1,91 e 1,73).
- **P3** (EA Super Trend con DD mensile > 15,2%): **CONFERMATA** (24,0%).
- **P5** (la continua rende meno della somma dei mesi indipendenti per la maggioranza): **SBAGLIATA**: per i 4 EA con lotto composto la continua rende MOLTO di piu' (interesse composto); per i 3 a lotto fisso e' uguale (+1.215 contro +1.214, +1.591 contro +1.570, +276 contro +281). Il Gold Reaper era l'eccezione, non la regola.
- **P1** (al massimo 3 su 10 passano tutto) e **P4** (Quantum iGold e PolyGold in perdita): da verificare quando arrivano gli ultimi due.
