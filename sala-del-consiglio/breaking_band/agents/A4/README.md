# A4 — Motore di simulazione (R003) — interfaccia per A1

File: `engine.py` (solo stdlib + numpy), `test_engine.py` (26 test su dati sintetici; `python3 -I test_engine.py`).
Il motore NON contiene le regole del pattern: A2 fornira le regole, qui si danno solo i segnali `(j, side)`.

## Uso minimo
```python
import sys; sys.path.insert(0, ".../breaking_band/agents/A4")
import engine as E
m1   = E.carica(path_csv)                  # M1: .t(min epoca) .o .h .l .c .tv .sp(punti) .info
h1   = E.costruisci_barre(m1, 60)          # 15 per M15. Barre: .t .o .h .l .c .tv .i0 .i1 (M1 inizio / fine ESCLUSA)
ind  = E.indicatori(h1)                    # Indicatori: sma20 std20 bb_up bb_lo std20_sma50 atr14 (array allineati, NaN all'inizio)
segnali = [(j, "long"), (j2, "short")]     # j = indice barra alla cui CHIUSURA scatta il segnale
trades, cont = E.esegui_segnali(m1, h1, ind, segnali)       # filtro 1 posizione alla volta + simulazione
st = E.statistiche(trades)
```
Le regole (A2/A1) devono calcolare i segnali usando solo `ind[...][i]`, `h1.*[i]` con i <= j (gli indicatori sono gia causali; il motore non puo controllare che le regole non guardino avanti).

## Funzioni
- `carica(path) -> M1`: CSV `time;open;high;low;close;tickvol;spread`. Righe malformate scartate, duplicati/disordine ripuliti; tutto contato in `m1.info`. Prezzi = BID, spread in punti.
- `costruisci_barre(m1, periodo_min) -> Barre`: bucket = `t // periodo` (allineato all'ora server del CSV). Esistono solo barre con almeno una M1; gli indici barra sono consecutivi sulle barre esistenti (nessuna barra vuota per buchi/weekend).
- `indicatori(barre, bb_n=20, bb_k=2.0, std_sma_n=50, atr_n=14, atr_metodo="wilder")`:
  Bollinger su chiusure con std di POPOLAZIONE (ddof=0); `std20_sma50` = SMA50 di std20 (primo valido a indice 68); `atr14` = **ATR di Wilder** (seme = media di TR[1..14] all'indice 14; TR[0] ignorato; poi `(ATR*13+TR)/14`), alternativa `atr_metodo="semplice"`. Il valore all'indice i usa solo barre <= i (test: troncamento e rimpiazzo del futuro, uguaglianza esatta).
- `simula_trade(m1, barre, ind, j, side, stop_atr=3.0, maxhold=150, ricalcolo_ogni=3, punto=0.01, max_gap_ingresso_min=None) -> dict`
- `esegui_segnali(m1, barre, ind, segnali, **kw) -> (trades, contatori)`: ordina i segnali per j, scarta quelli con posizione ancora aperta alla M1 di ingresso, simula gli altri. Un segnale puo avere un terzo elemento `dict` con override dei parametri di `simula_trade`.
- `statistiche(trades) -> dict`: `n, win_pct, pf_netto, pf_lordo, netto_R, lordo_R, costo_spread_R, attesa_R, media_vincita_R, media_perdita_R, dd_max_R, per_motivo`.
- `costruisci_m1(t,o,h,l,c,sp,tv=None)` per dati sintetici.

## Output di un trade (`eseguito=True`)
`j, side(+1/-1), entry_m1, entry_time, entry, stop, target0, target_finale, n_agg_target, rischio(USD), exit_m1, exit_time, exit, motivo ('SL'|'TP'|'TF'|'FINE_DATI'), R (netto), R_lordo, costo_spread_R, durata_barre, durata_minuti, bar_ingresso, bar_uscita, gap_ingresso_min`.
Non eseguito: `{'eseguito': False, 'scarto': CODICE}` con CODICE in `TARGET_OLTRE_INGRESSO`, `INDICATORI_NON_PRONTI`, `NO_BARRA_SUCCESSIVA`, `GAP_INGRESSO`. I contatori di `esegui_segnali`: `segnali, eseguiti, scartati_posizione_aperta, scartati_target_oltre_ingresso, scartati_indicatori_non_pronti, scartati_no_barra_successiva, scartati_gap_ingresso`.

## Convenzioni di esecuzione (interpretazioni DICHIARATE)
1. Ingresso: open della prima M1 della barra j+1. Long a ask = open + spread(M1 ingresso); short a bid = open. `gap_ingresso_min` = minuti tra la fine nominale della barra j e la M1 di ingresso (weekend/buchi); con `max_gap_ingresso_min` si possono scartare (default: nessun filtro, solo registrato).
2. Stop = `stop_atr * ATR(j)` dal prezzo di ingresso (fill, spread incluso); non si muove. Rischio iniziale D = tale distanza; `R = pnl/D`.
3. Target iniziale = SMA20(j); ricalcolato alla chiusura delle barre j+r, j+2r, ... (r=`ricalcolo_ogni`, default 3; `None` = fisso) e attivo dalla M1 successiva. Se un target aggiornato e gia superato dal prezzo, la posizione esce alla prima M1 successiva al prezzo di apertura (uscita a mercato).
4. "Target oltre il prezzo di ingresso": long se target <= ask di ingresso; short se target >= bid di ingresso -> nessun trade, contato.
5. Minuto per minuto dalla M1 di ingresso inclusa. Long (esce a bid): SL se low <= stop, TP se high >= target. Short (esce a ask = bid + spread della stessa M1): SL se high+spread >= stop, TP se low+spread <= target. **SL prima di TP nello stesso minuto.**
6. Fill: al livello; se l'apertura del minuto e gia oltre il livello (gap) al prezzo di apertura (per lo SL e peggiore di -1R; per il TP e un miglioramento). Nessuno slippage ulteriore.
7. `costo_spread_R`: long = spread all'ingresso / D; short = spread alla M1 di uscita / D. `R_lordo = R + costo_spread_R` (equivale a bid-su-bid). Lo spread di una M1 e quello riportato nella riga del CSV (non si sa se e di apertura o chiusura: DA_VERIFICARE).
8. Chiusura forzata: dopo `maxhold` barre (barra j+maxhold inclusa, default 150) all'ultima M1 di quella barra, motivo **`TF`**. Se i dati finiscono prima: motivo `FINE_DATI` (mai etichettato TF). Le barre sono contate sulle barre esistenti, non sul tempo di calendario (un weekend conta come una barra).
9. Una posizione alla volta: un segnale e scartato se l'uscita del trade precedente e alla M1 di ingresso o dopo.

## Limiti noti
- Non sono modellati commissioni, swap, slippage oltre il gap, variabilita dello spread entro il minuto, sessioni/orari di chiusura.
- Spread stimato dalla riga M1; spread alti a cavallo di rollover sono pagati cosi come registrati.
- L'ATR di Wilder dipende dall'inizio della serie (memoria esponenziale): i primi ~100 valori sono influenzati dal seme; per ogni file l'ATR riparte da zero.
- Il motore e testato su dati sintetici; nessun backtest su dati reali eseguito (solo controllo di fumo di caricamento/barre/indicatori).
