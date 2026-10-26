# Arena a 5.000 EUR, senza guardiano: maggio e giugno 2026 (26/10/2026)
**Natura: MISURA + LETTURA (parziale).** Criteri: `ARENA_5K_MESI_CRITERI_2026-10-26.md`. Lettore congelato `leggi_arena5k_mesi.py`. Archivio: `backtest_pipeline/risultati_archivio/ARENA5K_MESI_20261026_PARZIALE` (report compressi, senza log). Giro lento a tick reali (Modello 4), XAUUSD M1, 5.000 EUR a conto vuoto per mese, leva 1:100, 14 input imposti confermati dal report (maggio), `.ex5` identico (SHA B261E252...), nessun guardiano. Aprile non e finito (cartella senza manifest).

## Maggio 2026 (valido)
- 2.966 operazioni (1.512 sell e 1.454 buy, lotto massimo 0,11) in **soli 4 giorni di borsa**, **netto -3.050 EUR (-61%)**, PF 0,65, DD equity 5.055 (72,2%), saldo finale 1.949,83.
- Giorno per giorno (realizzato): 01/05 **+368**, 04/05 **+1.130**, 05/05 **+563**, poi **06/05 -5.112 (-72% del saldo)**. In tre giorni il conto era salito da 5.000 a 7.061 (+41%); in un giorno ha restituito tutto.
- **STOP OUT il 06/05 alle 09:53 (livello di margine 49,64%)**, a 17% dell'intervallo di test: 14 posizioni chiuse insieme, tutte **sell** a lotti crescenti (0,01, 0,02, 0,03, 0,04, 0,05, 0,08...) fra 4.547 e 4.572: una scala di vendite contro un rialzo dell'oro. Stesso meccanismo di agosto e settembre: tanti piccoli guadagni, poi un cesto profondo che porta il conto allo stop out.

## Giugno 2026 (NON valido: nessun numero)
La passata non ha scritto il report (periodo "1970", deposito 0, leva 1:0): il giornale dice `prepare for shutdown / tester forced to close` alle 07:04:24, dopo 36 minuti, al **6% del periodo** (`AutoTesting processing 6%`), con un buco nel giornale fra le 06:38 e le 07:04. **Causa non determinata [NON VERIFICATO]:** puo essere una chiusura a mano del terminale, una sospensione del PC o un blocco del tester. Il mese si rifa nella riga veloce.

## Quadro dei mesi a tick reali con Arena a 5.000 EUR (lotto base 0,01, nessun guardiano)
| Mese 2026 | Netto | DD equity | Stop out |
|---|---|---|---|
| Luglio | +4.800 | 45,9% | no |
| **Maggio** | **-3.050** | 72,2% | **si (06/05)** |
| Agosto | -3.063 | 67,8% | si (05/08) |
| Settembre | -2.505 | 75,2% | si (28/09) |
Tre mesi su quattro valutabili finiscono con stop out. Aprile (in corso) e giugno (invalido) mancano; **non e una frequenza**: sono quattro mesi.

## Cosa NON dice
Tester senza slippage ne latenza, margine del tester (circa 10.000 USD per lotto sull'oro, DERIVATO) piu severo o meno di quello reale: NON VISTO. Lo stop out del tester e a 5.000 EUR; sul reale e sul demo il flottante e stato chiuso dal Guardian. Nessuna decisione su Arena e mia.
