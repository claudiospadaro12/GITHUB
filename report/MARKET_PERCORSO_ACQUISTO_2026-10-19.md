# Percorso di acquisto degli EA del Market: cosa manca, in che ordine, con quali criteri (19/10/2026)

**Non controllata da agenti. Scritto PRIMA dei numeri che mancano.** Claudio e' disposto a comprare "purche' li testiamo bene". La **spesa, il numero di EA e le taglie sono sue**; qui si scrive solo come si decide.

## Limite di tutto quello fatto finora (da dire chiaro)
I 21 mesi (gen 2025 - set 2026) sono serviti per **scegliere**: sono *in-sample*. Un EA che passa le soglie su quei mesi non ha dimostrato di funzionare domani. L'unica prova fuori campione e' **il tempo che passa dopo l'acquisto**: demo dal vivo. Inoltre i test sono stati fatti con la **versione demo del Market**, che gira nel tester: che la versione a pagamento sia identica NON e' verificato (si controlla dopo l'acquisto).

## Fase A -- misure ancora mancanti sul PC di backtest (nessuna spesa)
1. Continue di Gold Trade Pro e Goldbot One (riga pronta). 2. Smart Gold Hunter a 80K (test iniziato). 3. Quantum iGold e PolyGold (ripresa in corso).
4. **Prova di stress del costo** per i candidati (Prop Firm, Smart Gold Hunter e quelli che superano la fase A1-A3): lo stesso giro continuo con **esecuzione ritardata** del tester (ExecutionMode con latenza) e con **commissione/spread piu' alti**. Soglia scritta ora: l'EA resta candidato solo se, con costo per operazione **doppio**, il netto resta **> 0** e il PF **> 1,10**. Gia' noto: S-COSTO dice 12-13 volte lo spread per il Prop Firm, quindi attesa: passa; per Smart Gold Hunter (circa 6,6 volte) il margine e' piu' stretto: previsione dichiarata **passa ma con PF sotto 1,3**.
5. **Controllo S-CORR/S-PORT** per ogni nuovo candidato aggiunto (strumento congelato).

## Fase B -- acquisto (decisione di Claudio), uno alla volta
- Primo candidato (oggi): **Prop Firm Gold EA** (S-STAB passata su 4 corse, scalabile da solo col saldo, DD 9,7% a 80K).
- Prima di pagare, da leggere/chiedere **per iscritto**: termini di rimborso del Market per quel prodotto, che il prodotto funzioni su conto demo BCM, commissione BCM reale (ancora da avere per iscritto), regole della prop o del conto su cui girera'.
- **Dopo l'acquisto, prima di accenderlo**: SHA256 del .ex5 pagato; una corsa di controllo nel tester con la versione pagata (stessi input) che deve dare numeri uguali o entro le bande del test (netto +/-25%, stesse operazioni +/-10%).

## Fase C -- demo dal vivo (obbligatoria, prima di qualsiasi reale)
Almeno **4 settimane** su demo, un solo EA per volta, magic dedicato. Criteri scritti ora: nessuna perdita oltre il tetto S-DD del tester scalato alla taglia usata; operazioni per settimana dentro **0,5x-2x** di quelle del tester; slippage/spread reali medi (dal log) **<= 2x** quelli del tester; risultato non giudicato in euro (4 settimane sono poche) ma come **non-peggiore** del peggior mese del tester. Se anche uno solo viene violato: non si passa al reale e lo si scrive.

## Fase D -- secondo EA
Solo dopo che il primo ha superato C. Il secondo si sceglie fra quelli che passano A e che, insieme al primo, rispettano S-CORR (<= 0,5) e S-PORT (tetto <= 10%): oggi **Smart Gold Hunter** e' l'unico noto in questa condizione col Prop Firm.

## Cosa non verra' mai deciso dai backtest
Taglia sul reale, budget, quale conto, se fidarsi di un venditore. Le soglie non si toccano dopo aver visto i numeri.
