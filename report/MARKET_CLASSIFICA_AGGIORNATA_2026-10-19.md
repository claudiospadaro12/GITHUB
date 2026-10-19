# Classifica aggiornata degli EA oro (con Prop Firm Gold EA dopo S-STAB) -- 19/10/2026

**Non controllata da agenti.** Ordine per FASCE di soglie S-* (scritte prima, `MARKET_SELEZIONE_PER_ACQUISTO_ATTESE_2026-10-19.md`), NON per profitto. Dentro la fascia l'ordine e' un mio giudizio su quanto e' grande lo sforamento e su quanta evidenza c'e'. Prova "piena" = 21 mesi indipendenti + corsa continua (gli 8 EA del test a fondo, Prop Firm anche S-STAB, 4 corse); prova "mesi indipendenti" = solo 21 tranche mensili da 5.000 (GTP, Goldbot, Phantom); Gold Reaper = corsa continua col set di Claudio. Per i 4 EA gia' misurati ho ricalcolato S-H, S-NOSCALA, S-COSTO dai loro report (posizioni contemporanee contate con le uscite prima delle entrate nello stesso secondo): non e' la stessa prova degli altri.

| # | EA | fascia | soglie fallite | op. | mesi pos. | netto 21 mesi | DD peggiore | note |
|---|---|---|---|---|---|---|---|---|
| 1 | Prop Firm Gold EA | 1 | nessuna (S-STAB ok su 4 corse) | 673 | 14/21 (peggiore 13/21 = 61,9%) | +1.531..+1.655 (continua) | 8,09% equity | S-M margine di 1 mese; lotto 0,01 (qualche 0,02) |
| 2 | Smart Gold Hunter | 1 | nessuna | 237 | 18/21 | +276 (PF 1,74) | 0,7% | poche operazioni, utile piccolo (+5,5%) |
| 3 | Gold Trade Pro (D1 ipotesi) | 1* | nessuna misurabile | 473 | 16/21 | +2.554 | 11,02% mensile | mesi indip.; S-H +1.286/+1.267; 10 pos.; costo 30x; periodo non confermato |
| 4 | Goldbot One (H1 ipotesi) | 1* | nessuna misurabile | 448 | 16/21 | +1.300 | 6,96% mensile | mesi indip.; S-H +636/+664; 8 pos.; costo 16x; periodo non confermato |
| 5 | Gold Reaper, set di Claudio | 2 | S-NOSCALA (11 pos. contro 10) | 791 | 18/21 | +3.970 (continua) | 4,77% (2,67% dal deposito) | S-H +3.126/+844; lotti 0,01-0,02; NON e' il prodotto "as is" |
| 6 | Ghost Scalper | 2 | S-COSTO (2,7x contro 3x) | 2.651 | 15/21 | +1.215 | 4,9% | |
| 7 | Quantum Titan | 2 | S-NOSCALA (lotto x6,6, composto) | 462 | 17/21 | +10.987 | 10,1% | lotto proporzionale al saldo, non martingala |
| 8 | The Gold Phantom (H1 ipotesi) | 2* | S-NOSCALA (17 pos. contemporanee) | 1.199 | 17/21 | +5.293 | 7,71% mensile | mesi indip.; S-H +4.138/+1.155; lotto 0,01-0,03 |
| 9 | TitanForge | 3 | S-DD (16,1%), S-NOSCALA | 339 | 18/21 | +23.883 | 22,6% | composto aggressivo |
| 10 | EA Super Trend XAUUSD | 3 | S-DD (24,0%), S-NOSCALA (x699) | 1.931 | 20/21 | +3.539.220 (irreale) | 21,5% | lotto fino a 34,93 |
| 11 | Nebula Cartographer | 3 | S-H, S-DD, S-NOSCALA, S-COSTO | 440 | 16/21 | +26.027 | 43,4% | -385 negli ultimi 4 mesi |
| -- | AI Golden Life | scartato | S-M, S-H, S-COSTO | 1.746 | 6/21 | -165 | 4,1% | |
| -- | The Impossible Gold (TIG) | scartato | (non S: -28.558, 4/21 mesi) | | | | 53% | |

\* Fascia con asterisco: prova a mesi indipendenti, nessuna corsa continua -> S-DD sulla perdita dal deposito non misurata.

## Non classificati
Quantum iGold e PolyGold (test a fondo in ripresa), Arena e gruppo B (griglia/recupero: classe di rischio diversa, tetti di esposizione), gruppo C (misura mancante).

## Cosa NON dice la classifica
- S-CORR e S-PORT (correlazione e drawdown combinato) NON sono stati calcolati per i nuovi EA: i 4 EA oro gia' misurati stavano a r 0,42-0,60 tra loro. Non si sa se Prop Firm o Smart Gold Hunter sono scorrelati da Gold Reaper & C.
- Il tester non simula slippage e spread allargato; la fase 3 (demo dal vivo) manca per tutti.
- La spesa e le taglie sono decisioni di Claudio.
