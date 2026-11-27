# ea_triage_routine - triage rapido di un EA con PF < 1 (o marginale)
Obiettivo: dire in minuti "recuperabile" o "SCARTA", senza overfitting. Stato (27/11/2026): **STEP 1 e STEP 2 pronti e collaudati**; STEP 3 (generazione `.ini`/`.set` + ottimizzazione IS/OOS su MT5) e STEP 4 (verdetto, archiviazione) da costruire al primo EA che passa lo STEP 2.
## Formato di ingresso (log operazioni normalizzato, CSV)
Obbligatorie: `ts_open, ts_close, symbol, side (long/short), R_gross, cost_R` (R = multipli del rischio iniziale; cost_R = spread+commissioni in R). Opzionali: `tag, mae_R, mfe_R, atr_entry, entry`.
Adattatori: `adapters/bb_v42_trades.py <cartella_H1> <out.csv>` (replica Python di Breaking Band v4.2). Per un EA MT5: esportare i deal con `backtest_runner/Esporta_Operazioni.ps1` e scrivere l'adattatore (MAE/MFE richiedono le barre M1).
## Uso
```
python src/triage_analyzer.py trades.csv out/        # STEP 1: lato, tag, simbolo, ora, giorno, MAE/MFE, volatilita, costi, inversione
python src/kill_switch.py     trades.csv out/        # STEP 2: leve scelte su IS (60%), valutate su OOS (40%) -> PROCEDI / SCARTA
```
Soglie in `config/soglie.json` (modificarle prima di vedere i risultati, mai dopo).
## Regole anti-overfitting incorporate
Ogni leva (solo Long, solo Short, solo segmento, finestra oraria contigua max 4 ore, simboli con PF IS >= 1, terzile di volatilita peggiore, TP da MAE/MFE) e SCELTA sull'IS e GIUDICATA sull'OOS; deve dare PF OOS >= 1,05, almeno 100 trade OOS, miglioramento OOS >= 0,05 e movimento lordo >= costi. Il numero di leve testate e stampato (piu leve = piu rischio di caso).
## Collaudi
- **Correzione trovata dal collaudo (27/11):** nella prima versione "solo Long" e "solo Short" erano valutate entrambe sull'OOS e bastava che una passasse: la scelta del lato avveniva sull'OOS. Ora le famiglie con piu varianti (lato, segmento) scelgono UNA variante sul solo IS; le altre sono mostrate come informative e non possono passare.
- Golden Cross HA H4 (ADX 25, dist 1,5, TP 1,5R, stop 1,5 ATR; 953 operazioni, 10 cross 2005-26; baseline PF IS 1,31 / OOS 0,91): SCARTA. Su IS vince il lato Long (1,38), che sull'OOS scende a 0,71; "solo Short" avrebbe PF OOS 1,12 ma non e stato scelto sull'IS (ipotesi post hoc, da non promuovere senza un nuovo test). Coerente con l'esito manuale del 25/11 (OOS 0,85-0,94).
- Breaking Band v4.2 (6.967 operazioni, 10 cross H1 2005-26): SCARTA, come la decisione manuale del 24/11. La leva "simboli con PF IS >= 1" sale a PF 1,13 su IS ma cade a 0,89 su OOS: il cancello IS/OOS ha preso l'overfitting. Risultati in `SCARTATI/BreakingBand_v42_20261127/`.
- Dati sintetici con un edge nei soli Long: PROCEDI (solo_long, tp). Il cancello non dice sempre no.
## Limiti noti
Il lever "cambio timeframe" non e calcolabile da un log: va provato a mano. MAE/MFE da barre H1 e approssimato (usare M1 dove possibile). Le ore sono quelle del server del log (BCM = GMT+1 fisso; dati importati NY: fare la diagnostica orari prima).
