#!/usr/bin/env python3
"""ADATTATORE ea_triage_routine: replica Python di GoldenZoe (oro H4 solo long: breakout di N barre, stop iniziale mi*ATR, chandelier mt*ATR)
da barre H1 oro FTMO 2004-2026 ricampionate a H4. Come simulatore/goldenzoe_griglia.py: costo 0,35 USD per operazione + swap long SW (default 5,5% annuo, FTMO).
Uso: python3 goldenzoe_trades.py <ABTG_H1_XAUUSD.csv> <out.csv> [N=55] [mi=3] [mt=3]"""
import sys, numpy as np, pandas as pd
SW = 0.055; COST = 0.35
COLS = ['ts_open', 'ts_close', 'symbol', 'side', 'tag', 'entry', 'exit_ref', 'risk_price', 'R_gross', 'cost_R', 'mae_R', 'mfe_R', 'atr_entry']
_cache = {}
def run(src, N=55, MI=3.0, MT=3.0):
    d = pd.read_csv(src, sep=';'); d['t'] = pd.to_datetime(d['date'], format='%Y.%m.%d %H:%M'); d = d.set_index('t').sort_index()[['open', 'high', 'low', 'close']]
    r = d.resample('4h', origin='start_day').agg({'open': 'first', 'high': 'max', 'low': 'min', 'close': 'last'}).dropna()
    O, H, L, C = [r[k].values for k in ('open', 'high', 'low', 'close')]; T = r.index
    pc = r.close.shift(1); tr = pd.concat([r.high - r.low, (r.high - pc).abs(), (r.low - pc).abs()], axis=1).max(axis=1); atr = tr.ewm(alpha=1 / 14, adjust=False).mean().values
    hh = pd.Series(H).rolling(N).max().shift(1).values
    rows = []; pos = 0; n = len(C)
    for i in range(120, n - 1):
        if pos == 0:
            if not (C[i] > hh[i]) or np.isnan(atr[i]): continue
            ent = O[i + 1]; risk = MI * atr[i]; pos = 1; stop = ent - risk; ext = ent; start = i + 1; a0 = atr[i]; mx = ent; mn = ent
        if pos == 1 and i >= start:
            mx = max(mx, H[i]); mn = min(mn, L[i])
            if L[i] <= stop:
                px = min(O[i], stop); days = (T[i] - T[start]).total_seconds() / 86400
                rows.append((T[start], T[i], 'XAUUSD', 'long', 'GZ', ent, px, risk, (px - ent) / risk, (COST + SW / 360 * days * ent) / risk, (ent - mn) / risk, (mx - ent) / risk, a0)); pos = 0; continue
            ext = max(ext, H[i]); stop = max(stop, ext - MT * atr[i])

    return pd.DataFrame(rows, columns=COLS)
if __name__ == '__main__':
    src, out = sys.argv[1], sys.argv[2]; N = int(sys.argv[3]) if len(sys.argv) > 3 else 55
    MI = float(sys.argv[4]) if len(sys.argv) > 4 else 3.0; MT = float(sys.argv[5]) if len(sys.argv) > 5 else 3.0
    df = run(src, N, MI, MT); df.to_csv(out, index=False); print('operazioni', len(df), '->', out, '| periodo', df.ts_open.min().date(), df.ts_open.max().date())
