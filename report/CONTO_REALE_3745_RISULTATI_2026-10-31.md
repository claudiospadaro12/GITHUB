# Conto reale 3.745 EUR: le cinque corse lette (31/10/2026)
Zip `ANNO3745L500_REALE_20261031_1037` (Goldbot One PF525, Gold Trade Pro PROP e COMBO, Reaper D9, Phantom D4). Criteri e previsioni scritti prima: `CONTO_REALE_3745_QUATTRO_EA_CRITERI_2026-10-30.md`. Lettura: `backtest_pipeline/leggi_reale3745.py`. Non controllata da agenti.

**Etichetta KO (tutte e 5):** il report stampa leva 1:100 invece di 1:500. Gli altri controlli passano (`input_ok = si`, nessuno stop out, nessun "no money", tick reali 100%, finestra 01/01/2025-01/10/2026, deposito 3.745). Margine oro del tester fisso, quindi la leva stampata non cambia i numeri [DERIVATO]. Numeri leggibili.

## Per EA (21 mesi, XAUUSD, 3.745 EUR, bonus 2.500 NON simulato)
| EA | operazioni | netto | netto % | DD equity (report) | DD saldo giornaliero | peggior giorno realizzato | lotti | lotti aperti insieme (max) |
|---|---|---|---|---|---|---|---|---|
| Reaper D9 (H1) | 969 | +4.066 | **+108,6%** | 327 (8,7% di 3.745) | 6,7% | -125 (-3,3%) 12/08/2026 | 955 a 0,01, 14 a 0,02 | 0,15 |
| Gold Trade Pro PROP (D1) | 472 | +2.914 | +77,8% | **840 (22,4%)** | 17,8% | -246 (-6,6%) 15/04/2026 | 458 a 0,01, 14 a 0,02 | 0,10 |
| Gold Trade Pro COMBO | 472 | +2.875 | +76,8% | 840 (22,4%) | 17,8% | -245 (-6,5%) | tutte a 0,01 | 0,10 |
| Goldbot PF525 (D1) | 441 | +1.739 | +46,4% | 460 (12,3%) | 9,9% | -103 (-2,8%) | tutte a 0,01 | 0,08 |
| Phantom D4 (H1) | 173 | +1.676 | +44,8% | 323 (8,6%) | 5,6% | -107 (-2,9%) | tutte a 0,01 | 0,03 |

Il DD equity in % e quello del report rapportato al deposito (il report lo rapporta al picco, per questo i suoi % sono piu bassi). "Peggior giorno realizzato" = somma dei chiusi del giorno, senza il flottante.
**Quasi tutto e a 0,01 lotti (il minimo): il lotto non cresce col saldo, la crescita e lineare**, e il rischio effettivo e molto sopra a quello del nome del set.

## Somme (corse indipendenti: poiche i lotti sono al minimo e non dipendono dal saldo, la somma dei guadagni in euro e una buona stima di un conto unico; DD equity combinata NON ricostruita: limite massimo = somma dei DD singoli)
| Combinazione | netto 21 mesi | quando raddoppia (+3.745) | DD saldo giornaliero | peggior giorno realizzato | lotti aperti insieme | mese peggiore |
|---|---|---|---|---|---|---|
| Reaper | +4.066 | 28/09/2026 (20,9 mesi) | 6,7% | -3,3% | 0,15 | -161 |
| Reaper + Goldbot | +5.805 | 28/01/2026 (13 mesi) | 7,4% | -4,0% | 0,23 | -217 |
| Reaper + Phantom | +5.742 | 10/03/2026 (14,3 mesi) | 6,7% | -3,3% | 0,18 | -172 |
| Reaper + Goldbot + Phantom | +7.481 | 18/12/2025 (11,6 mesi) | 10,7% | -6,0% | 0,26 | -371 |
| Reaper + Goldbot + GTP PROP | +8.719 | 22/12/2025 | 18,6% | -9,1% | n.c. | n.c. |
| 4 EA (con GTP PROP) | +10.395 | 23/09/2025 (8,7 mesi) | 19,0% | -10,4% | 0,34 | -393 |
Il momento del raddoppio e quello del percorso storico unico: dipende dalla partenza (i primi mesi del 2025 sono molto favorevoli all oro).

## Previsioni (scritte il 30/10)
- **V1** (5/5 valide con leva 1:500 nel report): **NO**, per la sola etichetta; i dati sono validi. **V2** nessuno stop out: SI. **V3** nessun "no money": SI.
- **M1** netto % >= 1,2 volte quello a 80.000: GTP PROP 77,8 contro 47,5 (1,64x) SI; Reaper 108,6 contro 74,7 (1,45x) SI; Goldbot 46,4 contro 18,0 (2,6x) SI.
- **M2** Phantom D4 >= 2 volte netto % e DD %: SI (44,8% in 21 mesi contro 6,95% nel 2025 a 80.000 con 707 posizioni, DD equity 1,0%; qui 6,4% del report). Confronto non omogeneo (finestre diverse, Randomization 0 contro 50).
- **M3** GTP COMBO simile al PROP (rapporto 0,7-1,4): **SI** (netto 0,99x, DD identico): a questo capitale il combo NON dimezza il rischio.
- **M4** DD % del GTP PROP >= 1,3 volte quello a 80.000 (7,0%): SI (13,6% del report, 1,9x).
- **M5** nessun EA perde in 21 mesi: SI.

## Anomalia da non ignorare
Il Phantom D4 apre 173 posizioni in 21 mesi a 3.745 contro 707 nel solo 2025 a 80.000. Possibile effetto del lotto calcolato sotto 0,01 (scarta le operazioni invece di arrotondare) [IPOTESI, non verificata nei log]. Non confrontare le sue operazioni con quelle di 80.000.

## Cosa NON dice
21 mesi di oro in forte rialzo (possibile periodo di ottimizzazione di Wim), un percorso, tester senza slippage e gap, spread del tester diverso da quello reale, bonus non simulato (conta su equity e margine, non sul lotto), flottante delle combinazioni non ricostruito, margine/stop out del broker reale non verificato, swap non confrontato col reale. Nessun giudizio su acquisti, lotti o taglie: scegli tu.
