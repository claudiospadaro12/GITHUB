# ea_triage_routine - triage rapido di un EA con PF < 1 (o marginale)
Obiettivo: dire in minuti "recuperabile" o "SCARTA", senza overfitting. Stato (27/11/2026): **STEP 1, 2 e 4 pronti e collaudati**; STEP 3 (generazione `.ini`/`.set` + ottimizzazione IS/OOS su MT5) da costruire al primo EA con esito PROCEDI.
## Formato di ingresso (log operazioni normalizzato, CSV)
Obbligatorie: `ts_open, ts_close, symbol, side (long/short), R_gross, cost_R` (R = multipli del rischio iniziale; cost_R = spread+commissioni in R). Opzionali: `tag, mae_R, mfe_R, atr_entry, entry`.
Adattatori: `adapters/bb_v42_trades.py <cartella_H1> <out.csv>` (replica Python di Breaking Band v4.2). Per un EA MT5: esportare i deal con `backtest_runner/Esporta_Operazioni.ps1` e scrivere l'adattatore (MAE/MFE richiedono le barre M1).
## Uso
```
python src/triage_analyzer.py trades.csv out/        # STEP 1: lato, tag, simbolo, ora, giorno, MAE/MFE, volatilita, costi, inversione
python src/kill_switch.py     trades.csv out/        # STEP 2: leve scelte su IS (60%), valutate su OOS (40%) -> PROCEDI / SCARTA
```
python src/verdetto.py       trades.csv cartella/ --plateau plateau.csv --nome NOME --archivia   # STEP 4: SALVATO / SCARTATO + sposta in SALVATI/ o SCARTATI/
```
Esiti STEP 2: SCARTA, PROCEDI (leva da ottimizzare, STEP 3), BASELINE_OK (EA gia sopra soglia: va dritto allo STEP 4). STEP 4 verifica PF IS/OOS, n trade, anni positivi, PF con costi x2 (swap/spread), plateau dei parametri vicini (file `plateau.csv` prodotto da un adattatore, es. `adapters/goldenzoe_plateau.py`: 27 combinazioni), DD totale e giornaliero per profilo di rischio (PROP 0,5% / MEDIO 0,9% / ALTO 1,3% a trade); scrive `verdict_report.md` con, se scartato, le 3 ragioni. Il DD e sul CHIUSO (additivo): il flottante intraday e peggiore.
```
Soglie in `config/soglie.json` (modificarle prima di vedere i risultati, mai dopo).
## Controllo con ingressi casuali (modifica confermata da Claudio il 28/11/2026)
`verdetto.py --null null.csv --tipo trend|pattern`: `null.csv` ha la colonna `pf_null` (PF di sistemi con ingressi casuali, stessa frequenza e stessa uscita). Per i sistemi TREND/long-only e una BANDIERA (rango atteso >= 90%, non blocca: se scende, il valore sta in uscite e crescita del mercato e il rischio va dichiarato); per i sistemi basati su PATTERN d'ingresso resta un CANCELLO DURO al 95 percentile. Fonti e motivazione: `report/FONTI_CRITERI_VALIDAZIONE_2026-11-28.md`. GoldenZoe: rango 97%, bandiera OK.
## Regole anti-overfitting incorporate
Ogni leva (solo Long, solo Short, solo segmento, finestra oraria contigua max 4 ore, simboli con PF IS >= 1, terzile di volatilita peggiore, TP da MAE/MFE) e SCELTA sull'IS e GIUDICATA sull'OOS; deve dare PF OOS >= 1,05, almeno 100 trade OOS, miglioramento OOS >= 0,05 e movimento lordo >= costi. Il numero di leve testate e stampato (piu leve = piu rischio di caso).
## Collaudi
- **Correzione trovata dal collaudo (27/11):** nella prima versione "solo Long" e "solo Short" erano valutate entrambe sull'OOS e bastava che una passasse: la scelta del lato avveniva sull'OOS. Ora le famiglie con piu varianti (lato, segmento) scelgono UNA variante sul solo IS; le altre sono mostrate come informative e non possono passare.
- Golden Cross HA H4 (ADX 25, dist 1,5, TP 1,5R, stop 1,5 ATR; 953 operazioni, 10 cross 2005-26; baseline PF IS 1,31 / OOS 0,91): SCARTA. Su IS vince il lato Long (1,38), che sull'OOS scende a 0,71; "solo Short" avrebbe PF OOS 1,12 ma non e stato scelto sull'IS (ipotesi post hoc, da non promuovere senza un nuovo test). Coerente con l'esito manuale del 25/11 (OOS 0,85-0,94).
- Breaking Band v4.2 (6.967 operazioni, 10 cross H1 2005-26): SCARTA, come la decisione manuale del 24/11. La leva "simboli con PF IS >= 1" sale a PF 1,13 su IS ma cade a 0,89 su OOS: il cancello IS/OOS ha preso l'overfitting. Risultati in `SCARTATI/BreakingBand_v42_20261127/`.
- GoldenZoe oro H4 long (replica da H1 FTMO 2004-26, 381 operazioni, costo 0,35 USD + swap 5,5% annuo): **BASELINE_OK** (nuovo esito dello STEP 2: PF IS 1,35 / OOS 1,74, non serve alcun recupero). Una leva (togliere il terzile di volatilita alta) darebbe OOS 1,80 contro 1,74: miglioramento troppo piccolo per giustificare un filtro, quindi non adottata. Va al verdetto (STEP 4, da costruire: plateau, anni positivi, DD prop). Cartella `IN_ANALISI/GoldenZoe_H4_oro_20261127/`.
- **STEP 4 su GoldenZoe: SALVATO** (PF IS 1,35 / OOS 1,74, 381 operazioni, 15/23 anni positivi, PF con costi x2 1,28, plateau 26/26 vicini con PF 1,42-1,56, DD totale al profilo PROP 4,8% e peggior giorno 0,5%; MEDIO 8,6% e ALTO 12,5% superano il limite totale del 8%). Archiviato in `SALVATI/GoldenZoe_H4_oro_20261127/`. Limiti: DD sul chiuso, costi non provati su tick reali, swap BCM (9,7% annuo) piu alto di quello simulato (5,5%) ma coperto dallo stress x2.
- Dati sintetici con un edge nei soli Long: PROCEDI (solo_long, tp). Il cancello non dice sempre no.
## Limiti noti
Il lever "cambio timeframe" non e calcolabile da un log: va provato a mano. MAE/MFE da barre H1 e approssimato (usare M1 dove possibile). Le ore sono quelle del server del log (BCM = GMT+1 fisso; dati importati NY: fare la diagnostica orari prima).
