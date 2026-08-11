# REFERTO R24 — la soglia del trailing (famiglia Apertura)

## Lato DAX (analizzato l'11/08 — la griglia GIACEVA dall'8/08 non letta)

25 celle (TF trailing M1..M5 x soglia 0/0,25/0,5/0,75/1R), tick reali,
solo-long, rischio 1%, la config del 100k. Criteri congelati nel file di
prova PRIMA del lancio (07/08).

**VERDETTO: NON SI TOCCA NIENTE — la soglia 0 (quella che gira ORA sul
100k) e' la migliore fuori campione su TUTTI e 5 i TF.**

| Soglia | Media profitto IS | Media profitto OOS |
|---|---|---|
| **0 (attuale)** | +20 | **+1.767** |
| 0,25 | -84 | +1.516 |
| 0,50 | -339 | +792 |
| 0,75 | +335 | +566 |
| 1,00 | **+1.101** | +349 |

- **Spearman IS->OOS = -0,44 (NEGATIVO)** -> criterio 1 del file: con
  l'ordine rovesciato, scegliere sull'IS e' peggio che non scegliere.
- **La 17^ apparizione del fenomeno-ribaltamento**: in campione vinceva
  la soglia 1R (+1.101), fuori campione e' l'ULTIMA (+349). Chi avesse
  scelto "la migliore IS" avrebbe montato sul 100k la cella peggiore.
  Il criterio scritto prima l'ha parata da solo.
- Bonus di conferma: la cella live (M5, soglia 0) fa OOS +1.811 con
  PF 1,42 e DD 6,7% — il 100k monta gia' una cella d'altopiano.
- L'ipotesi del 07/08 ("il trailing arma troppo presto, alzare la soglia
  lo trasforma da uscita in protezione") era SBAGLIATA, e il file di
  prova lo aveva previsto come esito possibile, per iscritto: "se la
  colonna a 0 e' gia' la migliore, l'ipotesi di stasera e' sbagliata".

## Lato Nasdaq (griglia gemella, LANCIATA l'11/08 sera)
Prova: `prove/R24_trailing_nasdaq.txt` (config forward pinnata: volumi
1,5 AND, ATR off, rischio 1%). Attesa dichiarata: che anche qui la
soglia 0 regga; un'eventuale preferenza per soglie alte vale SOLO con
Spearman positivo e coerenza su 2+ TF. Esito al rientro dei CSV.
