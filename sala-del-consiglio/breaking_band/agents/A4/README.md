# A4 — Motore, segnali e esecuzione del test (R003, R006) — interfaccia per A1/A7/C0

Solo libreria standard + numpy. Esecuzione di tutto con `python3 -I <file>` (i file aggiungono la propria cartella al path).

| File | Contenuto |
|---|---|
| `params.py` | UNICA fonte dei valori: `PARAMS` (= tabella di specifica_v1.md sez. 9), `SENSIBILITA` (Sa-Sf), `DESCRITTORI_A2` (soglie A2 dei soli descrittori), `DISEGNO` (linee di base, bootstrap, verdetto, placebo) |
| `engine.py` | dati M1, barre H1/M30, indicatori, simulazione del trade, filtro una posizione, statistiche |
| `signals.py` | macchina a stati CONT / INV (`rileva`), imbuto per stadi, descrittori, `signal_fn_factory` per A7 |
| `run_test.py` | produce T1-T9 + verdetto (JSON + markdown) con parametri e sha256 dei file letti nell'intestazione |
| `test_engine.py` (30 test), `test_signals.py` (30), `test_run.py` (11) | test su dati SINTETICI |
| `domande.md` | punti ambigui della specifica e letture implementate (da leggere PRIMA dell'hash) |

## Uso
```
python3 -I test_engine.py ; python3 -I test_signals.py ; python3 -I test_run.py     # correttezza (sintetici)
python3 -I run_test.py --dir <cartella 4 CSV> --out <prefisso> --congelati <.../congelati> \
        --hash-dati <.../congelati/HASH_DATI.txt> [--parte-a NON_VALUTATA|VERIFICATO|NON_VERIFICATO] \
        [--placebo-blocchi N]
```
`--solo-h1`, `--placebo-target`, `--placebo-max-anni`, `--prova` sono SOLO per prove e segnano l'intestazione `PARAMETRI_NON_CONGELATI_PROVA=true`. Output: `<prefisso>.json` (senza timestamp: due esecuzioni identiche hanno lo stesso `sha256_risultati`) e `<prefisso>.md`.

## Motore (engine.py)
- `carica(path) -> M1` (t in minuti, o/h/l/c bid, `sp` in PUNTI); `sostituisci_spread_zero(m1)` (sez. 6.9: spread 0 -> mediana degli spread non nulli dello stesso periodo e ora server; maschera `sp_sost`); `scala_spread(m1, k)` (Sd).
- `costruisci_barre(m1, periodo_min)` (60 = H1, 30 = M30), `indicatori(barre)`: Bollinger(20,2) con std di popolazione, SMA20, std20, SMA50 della std20, ATR di Wilder(14). Valore all'indice i = solo barre <= i.
- `simula_trade(m1, barre, ind, j, side, ...)`: ingresso all'apertura della prima M1 della barra j+1 (long ask = open+spread, short bid = open); stop = 3 ATR(j) dal fill; target SMA20(j) ricalcolato alla chiusura delle barre j+r, j+2r, ... (`ricalcolo_ogni='auto'` = 3 ore: H1 3 barre, M30 6) e valido dalla M1 successiva; controllo minuto per minuto, **SL prima di TP**, long esce a bid (SL se Low<=stop, TP se High>=target), short esce ad ask (SL se High+spread>=stop, TP se Low+spread<=target); **stop all'apertura se in gap peggiore, target SEMPRE AL LIVELLO**; target ricalcolato gia superato all'apertura della M1 successiva -> uscita a mercato `MKT`; `maxhold=1000` (Sc: 150 -> `TF`); dati finiti -> `FINE_DATI`; `max_gap_ingresso_min=180`; nessun trade se il target e gia oltre il prezzo d'ingresso (`TARGET_OLTRE_INGRESSO`, contato).
- Log del trade: `targets` = SCHEDULE COMPLETA `[(minuto da cui vale, livello), ...]` (la prima voce e il target iniziale valido dalla M1 di ingresso), `R`, `R_lordo`, `costo_spread_R`, `motivo` (SL/TP/MKT/TF/FINE_DATI), `sl_e_tp_stesso_minuto`, `spread0_ingresso/uscita`, `gap_ingresso_min`, `durata_barre`, ecc.
- `esegui_segnali(m1, barre, ind, [(j, side)], **kw) -> (trades, contatori)`: una posizione alla volta (segnali durante una posizione aperta scartati e contati), contatori per ogni causa di scarto. `statistiche(trades)`.
- Convenzione di spread: `executable` come in A7 (prezzi dati = BID, ask = bid + spread della stessa M1).

## Segnali (signals.py)
`rileva(barre, ind, variante, prm=PARAMS, sp_bar=None)` -> dict con `segnali` (lista di dict: `j`, `side`, `d`, `s`, `p`, `dp`, `n_prev`, `solidita`, `fascia`, `congestione`, `checklist_stretta`, `bonus`, `invalidazioni_A2`, `contatto`, `ora`, `livello_banda`, ...), `imbuto_barre` (criteri B1..B6 marginali e cumulativi per direzione), `imbuto_episodi` (stadi cumulativi, `morti` per causa), `armati`, `fine_episodi`, `extra` (SEQ, ritorno alla banda senza mediana, segnali con impulsiva 1,0, tocchi precoci, ...), `episodi` (con le barre valutabili per B2).
- Un solo percorso di codice: il caso d=-1 e lo SPECCHIO dei prezzi (`_Vista`). Causale: picco `p` = massimo corrente, nessun pivot a destra.
- Stadi CONT: armati, finestra (tau-p >= 3), C0 tocco banda opposta, C3 sequenza (SEQ), C1a ritracciamento non impulsivo, C1b candela test non impulsiva, sd<S50, sd<=sd[-3], SEGNALE. Stadi INV: armati, finestra, I0 mediana toccata, I1 banda opposta mai toccata, retest banda dell'impulso, I2, I3 banda piatta, sd<S50, sd<=sd[-3], SEGNALE.
- Per A7: `signal_fn_factory("CONT"|"INV", 60|30)` -> `fn(bars) -> {'signal','atr','sma20'}`.
- Test automatico: nessun numero di soglia sparso in `signals.py` (scansione AST).

## Tabelle di run_test.py
T1 imbuto (per variante x TF x periodo + TOTALE, con causa di morte e segnalazione >90%), T2 risultati (16 celle + totali + pooled), T3 fasce (solidita, n_prev, congestione, Checklist-stretta, lato, periodo, ora; sotto-gruppi: n<10 solo n, n<30 solo descrittivo, n>=30 Wilson 90% e PF), T4 linee di base B1 (primaria), B0, B2 (H1), T5 robustezza (bootstrap per settimane, PF senza i 3 migliori, leave-one-period-out, quota di profitto, spread x1,5, senza spread 0), T6 sensibilita Sa-Sf (H1 pooled), T7 placebo, T8 deriva, T9 dati/esecuzione, VERDETTO (criteri_previsioni_v1.md Parte B + clausole Parte C), LOG_TRADE (schedule completa dei target).

## Limiti noti
Non modellati commissioni, swap, slippage oltre il gap. Lo spread di una M1 e quello della riga CSV (non si sa se di apertura o chiusura: DA_VERIFICARE). Il motore e le regole sono verificati solo su dati sintetici; nessuna esecuzione sui 4 CSV reali. La Parte A del verdetto (controlli A7) non e valutata da `run_test.py`. Punti ambigui della specifica: `domande.md`.
