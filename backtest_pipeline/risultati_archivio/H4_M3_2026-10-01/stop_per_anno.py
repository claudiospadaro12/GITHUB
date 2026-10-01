import sys, numpy as np
sys.path.insert(0, "/home/user/GITHUB/backtest_pipeline")
import h4_m3_confluenza as T, ema200_rimbalzo as ER
C="/tmp/claude-0/-home-user-GITHUB/c2d73886-9ef2-5105-8937-d770bc36d6df/scratchpad/cache_m1"
for nome in ("DAX","XAU_B","XAU_A"):
    m = ER.carica_dataset(nome, C, "/home/user/GITHUB")
    sp = T.leggi_spread_orario() if nome=="DAX" else None
    P = T.prepara(m, sp, T.SPREAD_FISSO[nome]); S = T.sistema(m, P, 10, 3.5)
    ev = np.flatnonzero(S["ALL"])
    D = np.abs(P["entry"][ev]-S["v3"][ev]); ok = S["s"][ev]*(P["entry"][ev]-S["v3"][ev])>0
    rat = D/P["spread"][ev]
    for y in np.unique(P["anno"][ev]):
        sel = ok & (P["anno"][ev]==y)
        if sel.sum()<50: continue
        print(nome, y, "n %4d  ATR H1 med %7.3f  D_a med %7.3f (%.2f ATR)  D_a/spread med %5.1fx  >=40x %4.1f%%" % (sel.sum(), np.median(P["A"][ev][sel]), np.median(D[sel]), np.median(D[sel]/P["A"][ev][sel]), np.median(rat[sel]), 100*np.mean(rat[sel]>=40)))
