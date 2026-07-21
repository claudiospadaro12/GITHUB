# OptFrame.mqh — auto-export dei risultati di ottimizzazione

Raccoglie in **automatico** i risultati di ogni ottimizzazione MT5 in un CSV,
usando le *frame functions* native. Niente click, niente export manuale.
Il CSV è già nel formato che legge `optimizer/batch_analyze.py`.

## Integrazione (una riga per EA)

In cima al file `.mq5` di ogni EA:

```mql5
#include <OptFrame.mqh>
```

Copia `OptFrame.mqh` in `MQL5/Include/` (cartella dati MT5), poi ricompila l'EA.

> ⚠️ **Se l'EA definisce già** `OnTester`, `OnTesterInit`, `OnTesterPass` o
> `OnTesterDeinit`, **non** usare l'include così com'è: avresti l'errore
> "function already defined". In quel caso integriamo il codice a mano
> (mandami quell'EA e lo faccio io).

## Cosa serve verificare al primo compile (non posso compilarlo io qui)

Compila un EA con l'include in MetaEditor e controlla:
1. Nessun errore di firma su `OnTesterInit` / `FrameNext` / `FrameInputs`
   (variano di poco tra build MT5). Se ci sono, **mandami il messaggio esatto**
   e lo allineo alla tua build.
2. Lancia una micro-ottimizzazione (2-3 parametri, poche combinazioni).
3. Controlla che in `MQL5/Files/` compaia `OptResults_<EA>_<simbolo>.csv`.

## Il flusso completo (end-to-end)

```
[1] EA con #include <OptFrame.mqh>
        │  (ottimizzazione nativa MT5, o lanciata dalla pipeline via .ini)
        ▼
[2] MQL5\Files\OptResults_<EA>_<simbolo>.csv   ← scritto in automatico
        │
        ▼
[3] python optimizer/batch_analyze.py cartella_csv/ --out-dir best_sets/
        │  (seleziona i parametri ROBUSTI = plateau, non il picco)
        ▼
[4] best_sets/<EA>.set   ← pronti da caricare in MT5
        │
        ▼
[5] WALK-FORWARD: ri-testi i .set su un periodo NON usato (out-of-sample)
                  → tieni solo quelli che reggono anche lì
```

## Colonne del CSV prodotto

`Pass, Profit, Expected Payoff, Profit Factor, Recovery Factor, Sharpe Ratio,
Equity DD %, Trades` + una colonna per ogni parametro ottimizzato.

Sono gli stessi nomi dell'export XML del Tester, quindi l'analizzatore li
riconosce senza modifiche.
