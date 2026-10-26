# Classifica degli EA con slippage, spread e commissioni: CRITERI (26/10/2026, scritti PRIMA dei numeri)
**Natura: CRITERI. Non controllata da agenti.** Richiesta di Claudio: rifare la classifica degli EA valutandoli con slippage, spread e commissioni.

## Cosa c'e GIA nei numeri del tester [MISURATO, vedi ARENA_REGGE_SUL_REALE_COSTI_2026-10-15.md e i report da 80K]
Tick reali BCM (quindi lo spread storico del feed c'e), commissione ~3,86 EUR a lotto a giro (letta dai deal: -1,93 per lato; la demo BCM 50503392 addebita 4,00), **slippage zero e latenza zero**. Il tester non puo dirci nulla sullo slippage.
## Cosa NON si puo misurare [NON MISURATO]
Lo slippage dell'oro: sulla demo il riempimento coincide ESATTAMENTE con il livello dell'ordine (misurato sul cronistorico del 26/10: 2.149 uscite a stop-loss, 3.121 a take-profit e 5.653 ingressi da ordini pendenti, tutti con scarto 0,000 USD): **la demo non simula slippage, quindi non e una fonte**. Il reale 10105439 non ha deal d'oro misurati. Quindi i valori sotto sono IPOTESI DICHIARATE (sensibilita), non misure: la misura vera richiede un registratore di slippage sul reale/prop.

## Scenari (costo EXTRA per giro, in USD per oncia, sopra il tester; 1 USD/oz = 86,4 EUR per lotto, 100 once per lotto, USD->EUR ~0,864)
| Scenario | Slippage per fill (entrata+uscita) | Spread allargato per giro | Extra totale | Commissione |
|---|---|---|---|---|
| C0 | 0 | 0 | 0 | quella del tester |
| C1 leggero | 0,05 x 2 | 0,05 | **0,15 USD** (13 EUR/lotto) | portata a 4,00 a lotto/giro se il tester ne ha meno |
| C2 medio | 0,10 x 2 | 0,10 | **0,30 USD** (26 EUR/lotto) | idem |
| C3 duro | 0,20 x 2 | 0,20 | **0,60 USD** (52 EUR/lotto) | idem |
Riferimento: lo spread che il tester gia paga e circa 0,20 USD (20 punti; S-COSTO inferito). Il costo e sottratto ai risultati della corsa a 80K (21 mesi, gen 2025-set 2026, tick reali, default del venditore, nessun guardiano): costo = lotti di ogni uscita x extra; **il lotto non viene ricalcolato** (l'auto-lotto reagirebbe al saldo piu basso: effetto di secondo ordine, dichiarato).

## Chi e in classifica
11 EA oro con corsa continua a 80K: Gold Snap, SomaGold, SixtyNine, Umbra Vault, Microedge, Rocket Breakout, Vortex Turbo, Entry Points Pro, ORB Revolution, Prop Firm Gold EA, Smart Gold Hunter. Arena esclusa (corse da 5K di 1 mese, gia in `ARENA_REGGE_SUL_REALE_COSTI`).

## Regola di classifica (nessun giudizio a posteriori)
**Chiave principale = margine di costo M**: l'extra per giro (USD/oz) che azzera il netto a 21 mesi dopo l'aggiustamento della commissione, M = netto_C0_corretto / (somma lotti delle uscite x 86,4). E indipendente dalla scala del conto (conta per lotto negoziato), quindi non premia chi compone di piu. Piu alto = meglio.
Fasce (scritte ora): **ROBUSTO** M >= 0,60 (tiene anche C3); **TIENE** 0,30 <= M < 0,60 (tiene C2); **FRAGILE** 0,15 <= M < 0,30 (tiene C1, non C2); **NON TIENE** M < 0,15.
Dentro la fascia: ordine per M decrescente. Colonne informative, NON nella chiave: PF a C0 e a C2, netto a C2, DD realizzato dal picco a C2, giorni con perdita realizzata >= 5% a C2, esito SOLIDO-ANNI dei tre anni (dove esiste), n operazioni. **Controllo di stabilita**: M calcolato separatamente su 2025 e su 2026: se differiscono di piu di 2x lo si scrive accanto (la classifica non cambia).

## Previsioni dichiarate ORA
- K1: almeno 3 degli 11 EA in FRAGILE o NON TIENE: 65%.
- K2: Gold Snap tra i primi 3 per M: 40%.
- K3: l'ordine per M differisce dall'ordine per netto a C0 (correlazione di rango sotto 0,8): 60%.
- K4: SixtyNine (molte operazioni) ha M sotto la mediana: 55%.
- K5: gli EA a lotto 0,01 (Prop Firm Gold, Smart Gold Hunter) finiscono in NON TIENE o FRAGILE: 45%.

## Cosa NON dice
Gli extra sono ipotesi, non misure; il tester e un solo passato; nessun merito d'acquisto, lotto o taglia. Un M alto non dice che l'EA sia sicuro, dice solo che il suo margine per lotto assorbe il costo.
