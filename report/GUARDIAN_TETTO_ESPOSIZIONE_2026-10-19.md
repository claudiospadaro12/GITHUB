# Guardian v1.15 -- tetto di esposizione (E1), scritto il 19/10/2026 su richiesta di Claudio

**Stato: SORGENTE scritto, NON compilato (manca MetaEditor in questa sessione), NON provato, NON installato su nessun conto.** Il Guardian che gira sul reale e' la v1.12; questo file e' `mql5/Experts/ABTG_Guardian.mq5` v1.15 (HEAD, v1.14 + E1) e richiede l'include `ABTG_PausaGuardian.mqh` del repo. Prima di toccare il reale: compilare, `InpAutotest=true` su demo (8 casi nuovi del tetto), prova su demo con una griglia, poi decisione di Claudio. I VALORI dei tetti sono una scelta sua (taglia/rischio del conto): non ne propongo.

## Perche'
19/10: 15 BUY senza stop contro il calo (0,01 -> 0,17 lotti), netto lungo massimo **0,83 lotti alle 14:43:39**, lotti totali 0,87. Il lockdown giornaliero guarda l'equity e e' arrivato tardi (-838 realizzati). Un tetto sulla DIMENSIONE agisce prima.

## Input nuovi (tutti a 0 = spenti = comportamento IDENTICO alla v1.14)
| Input | Cosa fa |
|---|---|
| `InpMaxTotalLots` | lotti totali aperti insieme, massimo (include la parte coperta di una griglia a due lati) |
| `InpMaxOpenPositions` | numero di posizioni aperte insieme, massimo |
| `InpMaxNetLots` | esposizione **NETTA** massima su un simbolo, \|lotti buy - lotti sell\| (la direzione scoperta; per una griglia e' la misura giusta) |
| `InpExposureAction` | 0 = cancella i pendenti; **1 = cancella i pendenti E chiude le posizioni piu' recenti finche' rientra** (default); 2 = solo allarme |
`InpAction=1` (monitor) forza comunque "solo allarme".

## Come si comporta
- Ogni secondo (timer del Guardian) misura lotti totali, posizioni e netto per simbolo.
- Se un tetto e' superato: scrive `[GUARDIAN] # TETTO ESPOSIZIONE superato: ...` (una volta), **cancella tutti i pendenti** (nessuno stop/limit puo' scattare e far crescere l'esposizione) e, con azione 1, **chiude la posizione piu' recente** (per tempo in ms; se a sforare e' solo il netto, la piu' recente del lato scoperto di quel simbolo) finche' rientra. Poi `tetto esposizione rientrato`.
- Pannello e log periodico (5 min) mostrano lotti/posizioni/netto SOLO a tetto acceso.
- **Costo**: chiudere le piu' recenti realizza la loro perdita (di solito le piu' grandi). E la griglia puo' provare a riaprire: ogni ciclo costa spread + commissione (0,2-1,3 EUR), come il ricacciamento del 19/10 dopo le 14:46. Un EA che apre a **mercato** puo' superare il tetto di un passo entro 1 secondo.
- **Non** sostituisce il limite giornaliero e il totale: si aggiunge.

## Che cosa avrebbe fatto il 19/10 (dai dati del cronistorico, DERIVATO, con lo stesso comportamento dell'Arena: non e' una simulazione della griglia)
Netto massimo 0,83; tetti netti incrociati la prima volta: **0,10 alle 09:46, 0,20 alle 10:32, 0,30 alle 11:21 (flottante complessivo -155 EUR), 0,50 alle 11:42 (-235 EUR)**. Con totale: 0,30 lotti alle 10:40, 0,50 alle 11:42. Quindi un tetto basso taglia l'Arena presto, anche nelle fasi buone (alle 11:40 un cesto chiuse +23 EUR). Un tetto alto (0,50 netto) avrebbe fermato la pila a circa 0,5 lotti invece di 0,83-0,90: la perdita del cesto proporzionale, circa -480 invece di -838 [STIMA lineare sui lotti, non una simulazione]. La scelta del valore e' un compromesso fra due costi: perdere tutte le fasi buone o lasciar crescere la coda.

## Cosa NON fa
Non impedisce a un EA di aprire il primo passo oltre il tetto, non conosce la strategia dell'EA, non decide la taglia. Non e' provato.
