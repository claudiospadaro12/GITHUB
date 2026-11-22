# ea_analyzer — analisi dei NOSTRI EA (non clonazione di EA di terzi)

Uso (python3 con numpy, senza `-I` se si usa `-m`):

    python -m ea_analyzer.cli struttura --report REPORT.htm --tf 240
    python -m ea_analyzer.cli fedelta  --report REPORT.htm --ohlcv "dati/ABTG_M1_XAUUSD_202*.csv" --modello goldenzoe --oro-ftmo --out OUT_DIR
    python -m ea_analyzer.cli set A.set B.set

- `parsers`: report tester MT5 (htm UTF-16) -> ordini, deal, trade accoppiati; file .set; dati OHLCV.
- `structure`: concorrenza, griglia/hedge, orari, SL/TP, lotti vs 1/SL, trailing.
- `fidelity`: abbina trade tester vs modello (tolleranze dichiarate), punteggio di fedelta, mancanti/extra.
- `models/goldenzoe_ref.py`: modello di riferimento di GoldenZoe_H4.

Nota lotti: con conto in EUR e simbolo in USD il rapporto lotti modello/tester ~ 1/EURUSD (mediana misurata 1,103); senza M1 EURUSD del periodo la conversione non e applicata.
