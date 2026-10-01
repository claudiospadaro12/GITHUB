import sys, numpy as np
sys.path.insert(0, "/home/user/GITHUB/backtest_pipeline")
import h4_m3_confluenza as T, ema200_rimbalzo as ER
C = "/tmp/claude-0/-home-user-GITHUB/c2d73886-9ef2-5105-8937-d770bc36d6df/scratchpad/cache_m1"
m = ER.carica_dataset("DAX", C, "/home/user/GITHUB")
P = T.prepara(m, T.leggi_spread_orario(), None); S = T.sistema(m, P, 10, 3.5)
boot = T.Boot(P["giorno"], seed=777)
dec = T.analizza(m, P, S, boot, 4242 + 135, "x", "x", [])
for lato, sl in (("long", 1), ("short", -1)):
    d = dec[lato]; A = d["all_idx"]; B = d["B"]
    xa = T.segnati(P, A, sl, 60); xb = T.segnati(P, B, sl, 60)
    for ore in [(h,) for h in range(24)]:
        fa = np.isin(P["ora"][A], ore) & xa["ok"]; fb = np.isin(P["ora"][B], ore) & xb["ok"]
        e = xa["R"][fa].mean() - xb["R"][fb].mean()
        lo, hi = boot.diff(P["giorno"][A][fa], xa["R"][fa], P["giorno"][B][fb], xb["R"][fb])
        if fa.sum() < 100: continue
        print(("*" if lo > 0 or hi < 0 else " ") + "DAX %-5s ora UTC+1 %-7s n %4d  ALL %+.3f  B %+.3f  eff %+.3f [%+.3f;%+.3f]  netto ALL %+.3f" %
              (lato, ore, fa.sum(), xa["R"][fa].mean(), xb["R"][fb].mean(), e, lo, hi, xa["net"][fa].mean()))
