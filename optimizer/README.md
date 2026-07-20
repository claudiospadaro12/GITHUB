# Analizzatore di ottimizzazioni MT5 (anti-overfitting)

Trova i set di parametri **robusti** da un'ottimizzazione dello Strategy Tester
di MetaTrader 5, invece del "picco" migliore (che quasi sempre è
sovraottimizzato e non regge in reale).

## Idea

Il miglior risultato assoluto di un'ottimizzazione è spesso un colpo di fortuna:
una combinazione di parametri che ha funzionato *solo* su quello storico. Un set
**robusto** invece sta su un **plateau**: anche i parametri vicini danno buoni
risultati. Questo strumento:

1. applica filtri di qualità minima (numero trade, profit factor, drawdown);
2. rileva i plateau (quanti set buoni hanno ogni parametro entro ~un passo);
3. ordina per **robustezza = qualità × stabilità del vicinato**.

## Come esportare il file da MT5

1. Strategy Tester → scheda **Impostazioni**: scegli l'EA, il simbolo, il periodo
   e imposta **Ottimizzazione** (es. "Algoritmo genetico lento" o "Completa").
2. Metti in ottimizzazione i parametri che ti interessano (spunta + min/passo/max).
3. Avvia. A fine ottimizzazione vai alla scheda **Ottimizzazione**.
4. **Tasto destro** sulla tabella dei risultati → **Esporta in XML** (oppure
   copia tutto e incolla in Excel salvando come `.xlsx`).

## Uso

```bash
python optimizer/analyze_optimization.py risultati.xlsx
python optimizer/analyze_optimization.py risultati.xml --min-trades 40 --min-profit-factor 1.2 --max-drawdown 25 --out best.set
```

Opzioni principali:

- `--min-trades` (default 30): scarta i set con pochi trade (poco significativi).
- `--min-profit-factor` (default 1.1): profit factor minimo.
- `--max-drawdown`: drawdown % massimo ammesso (se la colonna è nel file).
- `--steps` (default 1.5): ampiezza del vicinato in "passi di griglia" per il plateau.
- `--top` (default 5): quanti set mostrare.
- `--out best.set`: salva il `.set` del set #1, pronto da caricare in MT5.

## Formati supportati

`.xlsx` / `.xls` / `.csv` / `.tsv` e l'XML "SpreadsheetML" esportato da MT5.
Le intestazioni sono riconosciute sia in inglese sia in italiano.

## Onestà

Nessuna analisi rende profittevole un EA che non ha un edge reale. Questo
strumento **riduce** il rischio di illudersi con backtest sovraottimizzati; la
conferma vera resta il **forward test / demo** su un periodo **non usato** per
l'ottimizzazione (out-of-sample).
