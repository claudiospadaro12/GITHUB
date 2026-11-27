#!/usr/bin/env python3
"""ADATTATORE ea_triage_routine: Golden Cross HA (famiglia A, replica nostra) con la configurazione che ha passato il cancello IS dell'ottimizzazione 25/11
(H4, ADX>=25, distanza<=1,5 ATR, TP 1,5R, stop 1,5 ATR, senza uscita EMA21). Esporta il log operazioni normalizzato.
Uso: python3 -I gc_h4_trades.py <cartella_H1> <out.csv>"""
import sys, os
D_ARG, OUTP = sys.argv[1], sys.argv[2]; HERE = '/home/user/GITHUB/backtest_runner/simulatore'
sys.argv = [sys.argv[0], D_ARG]
src = open(os.path.join(HERE, 'golden_cross_fx.py')).read().split("PERI = [")[0]
src = src.replace("d.index < '2026-11-24'", "d.index < ENDD").replace("((c - e21) <= d.atr)", "((c - e21) <= DIST * d.atr)").replace("((e21 - c) <= d.atr)", "((e21 - c) <= DIST * d.atr)")
src = src.replace("sl = min(l[i - 2:i + 1]) - 0.1 * atr[i]; R = entry - sl", "sl = entry - STOP * atr[i]; R = entry - sl").replace("sl = max(h[i - 2:i + 1]) + 0.1 * atr[i]; R = sl - ref", "sl = ref + STOP * atr[i]; R = sl - ref")
src = src.replace("if not (0.3 * atr[i] <= R <= 2 * atr[i]): i += 1; continue", "pass")
src = src.replace("OUT = sys.argv[2] if len(sys.argv) > 2 else None", "OUT = None")
old = "r = pnl / R; res.append((idx[j], r))"
new = ("r = pnl / R; seg_h = h[j:exit_j + 1]; seg_l = l[j:exit_j + 1]; ref0 = entry if long_ else ref; "
       "mfe = ((seg_h.max() - ref0) if long_ else (ref0 - seg_l.min())) / R; mae = ((ref0 - seg_l.min()) if long_ else (seg_h.max() - ref0)) / R; "
       "res.append((idx[j], idx[exit_j], pair, 'long' if long_ else 'short', 'A', entry, ref, R, r + sp / R, sp / R, mae, mfe, atr[i]))")
assert old in src; src = src.replace(old, new)
DIST = 1.5; STOP = 1.5; ENDD = '2026-11-24'
exec(src)
rows = []
for p in SP:
    d = indicators(load(p, 'H4')); L, S = signals_A(d, 25); rows += trade_loop(d, p, L, S, 1.5, False)
df = pd.DataFrame(rows, columns=['ts_open', 'ts_close', 'symbol', 'side', 'tag', 'entry', 'exit_ref', 'risk_price', 'R_gross', 'cost_R', 'mae_R', 'mfe_R', 'atr_entry']).sort_values('ts_open')
df['entry'] = df['entry'].astype(float); df.to_csv(OUTP, index=False); print('operazioni', len(df), '->', OUTP)
