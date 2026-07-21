# Pipeline di ottimizzazione MT5 (walk-forward)

Automatizza l'ottimizzazione di **più Expert Advisor** in serie sullo Strategy
Tester di MT5, con **protezione anti-overfitting** (walk-forward).

Pensata per chi ha **molti EA** (15+) dove l'ottimizzazione manuale uno-a-uno
diventa insostenibile.

## ⚠️ Leggi prima: cosa fa e cosa NON fa

- ✅ Lancia l'ottimizzatore **nativo** di MT5 (non lo reinventa) su tanti EA in fila.
- ✅ Divide lo storico in **In-Sample** (dove ottimizza) e **Out-of-Sample**
  (dove valida su dati mai visti) → tiene solo i parametri **robusti**.
- ❌ Non "trova i parametri migliori" nel senso di massimizzare il profitto passato:
  quello è **overfitting** e fa perdere soldi in reale. L'obiettivo è la **stabilità**.
- ❌ Non gira in cloud/qui: **gira sul TUO VPS** dove c'è MT5. Questi script sono la
  macchina; il VPS è l'officina.

## Dove sta ancora da completare (onesto)

| Componente | Stato |
|---|---|
| Logica walk-forward, finestre IS/OOS | ✅ solido |
| Generazione `.set` (range di ottimizzazione) | ✅ solido |
| Generazione `.ini` (avvio Tester) | ⚠️ i codici numerici MT5 (`Model`, `OptimizationCriterion`) vanno **verificati** sulla tua versione |
| Avvio MT5 + walk-forward loop | ✅ solido (Windows nativo o Linux+Wine) |
| **Lettura risultati** (`parse_report.py`) | ⛔ **da completare con un tuo report reale** — non invento il formato |

## Cosa mi serve da te per finalizzarla

1. **VPS Windows** (MT5 nativo) o **Linux + Wine**?
2. Un **`.ini` di ottimizzazione salvato dal tuo MT5** (così allineo i codici esatti).
3. Un **report di ottimizzazione esportato** (o un `.xml` da `Tester/cache/`),
   così scrivo il parser sui campi veri.
4. La **metrica** che vuoi massimizzare (di default: recovery factor, buon compromesso
   rischio/rendimento).

## Come funziona (una volta completa)

```
1. config.json         → elenchi i tuoi 15 EA + i range di parametri
2. python run_pipeline.py
      per ogni EA:
        per ogni finestra walk-forward:
          - ottimizza sull'IN-SAMPLE (ottimizzatore genetico MT5)
          - prende i migliori set
          - li RI-TESTA sull'OUT-OF-SAMPLE (dati mai visti)
          - tiene solo quelli che reggono anche lì
3. risultati_walk_forward.json → i parametri robusti per ogni EA
```

## File

- `config.example.json` — copia in `config.json` e adatta
- `generate_config.py` — genera `.ini`/`.set` per MT5
- `run_pipeline.py` — orchestratore walk-forward
- `parse_report.py` — lettura risultati (da completare col tuo formato)

## Dipendenze (sul VPS)

```
pip install python-dateutil
```

## Il concetto anti-overfitting in una frase

> Non cerchiamo i parametri che hanno guadagnato di più **ieri** (li trova sempre,
> ed è un'illusione). Cerchiamo quelli che hanno funzionato in modo **stabile** su
> periodi diversi, **compreso uno che l'ottimizzatore non ha mai visto**. Se reggono
> lì, hanno una possibilità di reggere in reale.
