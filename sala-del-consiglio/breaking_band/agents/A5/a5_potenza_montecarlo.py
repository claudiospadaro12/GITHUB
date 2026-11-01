#!/usr/bin/env python3
"""A5 - Potenza statistica: quante operazioni servono per distinguere PF 1.0 da PF 1.15
con win rate ~60%. Nessun dato di mercato: solo Monte Carlo su esiti ipotetici.
Uso: python3 -I a5_potenza_montecarlo.py [seed]
Modello: perdita = -1R (stop 3 ATR). Vincita = w R, scelto in modo che PF = (p*w)/((1-p)*1) = PF_target.
Variante 'rumorosa': vincite lognormali (CV 0.5), perdite 1R*(1+-10% uniforme) per spread/slippage/chiusure forzate.
Test: statistica = PF osservato. Soglia critica = 95 percentile del PF sotto H0 (PF vero 1.0). Potenza = P(PF_oss > soglia | H1).
"""
import sys
import numpy as np

seed = int(sys.argv[1]) if len(sys.argv) > 1 else 12345
rng = np.random.default_rng(seed)
P = 0.60
NSIM = 20000
Ns = [20, 30, 50, 80, 120, 200, 400, 800, 1300, 2000]

def w_for_pf(pf, p=P):
    return pf * (1 - p) / p

def sim_pf(n, pf_true, noisy):
    """ritorna array NSIM di PF osservati"""
    w = w_for_pf(pf_true)
    win = rng.random((NSIM, n)) < P
    if not noisy:
        gain = np.where(win, w, 0.0).sum(1)
        loss = np.where(~win, 1.0, 0.0).sum(1)
    else:
        sig = np.sqrt(np.log(1 + 0.5 ** 2))
        wv = w * np.exp(rng.normal(-sig ** 2 / 2, sig, (NSIM, n)))   # media w, CV 0.5
        lv = 1.0 + rng.uniform(-0.1, 0.1, (NSIM, n))
        gain = np.where(win, wv, 0.0).sum(1)
        loss = np.where(~win, lv, 0.0).sum(1)
    with np.errstate(divide='ignore', invalid='ignore'):
        pf = np.where(loss > 0, gain / loss, np.inf)
    return pf

out = []
def pr(s=""):
    print(s); out.append(s)

pr(f"# A5 Monte Carlo potenza  seed={seed} NSIM={NSIM} win rate={P}")
pr(f"Payoff medio vincita (in R, perdita=1R): PF1.00 -> {w_for_pf(1.0):.3f}R ; PF1.15 -> {w_for_pf(1.15):.3f}R ; PF1.30 -> {w_for_pf(1.30):.3f}R")
pr(f"Expectancy per trade: PF1.15 -> {P*w_for_pf(1.15)-(1-P):+.4f}R ; PF1.30 -> {P*w_for_pf(1.30)-(1-P):+.4f}R")
# formula chiusa
m = P * w_for_pf(1.15) - (1 - P)
sd = np.sqrt(P * w_for_pf(1.15) ** 2 + (1 - P) - m ** 2)
z = 1.645 + 0.8416
pr(f"Formula normale (1 coda 5%, potenza 80%, esiti binari): N ~ ((z*sd)/m)^2 = {((z*sd/m)**2):.0f} trade (sd per trade {sd:.3f}R)")
pr("")
for noisy in (False, True):
    tag = "RUMOROSO" if noisy else "BINARIO"
    pr(f"## Modello {tag}: potenza (alpha=5% 1 coda) per distinguere PF1.15 da PF1.0; e alpha effettivo")
    pr("| N trade | soglia PF (95% sotto H0) | potenza PF1.15 | potenza PF1.30 | potenza PF1.50 | P(PF_oss>1 | H0) |")
    pr("|---|---|---|---|---|---|")
    for n in Ns:
        h0 = sim_pf(n, 1.0, noisy)
        crit = np.quantile(h0[np.isfinite(h0)], 0.95)
        pw = []
        for pft in (1.15, 1.30, 1.50):
            h1 = sim_pf(n, pft, noisy)
            pw.append(np.mean(h1 > crit))
        pr(f"| {n} | {crit:.2f} | {pw[0]*100:.0f}% | {pw[1]*100:.0f}% | {pw[2]*100:.0f}% | {np.mean(h0>1)*100:.0f}% |")
    pr("")

pr("## Effetto minimo rilevabile (potenza 80%, alpha 5%), modello BINARIO, win rate 60%")
pr("| N trade totali | PF vero minimo rilevabile |")
pr("|---|---|")
for n in (28, 57, 114, 230, 340, 680, 1300):
    h0 = sim_pf(n, 1.0, False)
    crit = np.quantile(h0[np.isfinite(h0)], 0.95)
    found = None
    for pft in np.arange(1.05, 3.01, 0.05):
        if np.mean(sim_pf(n, pft, False) > crit) >= 0.80:
            found = pft; break
    pr(f"| {n} | {('%.2f' % found) if found else '>3.0'} |")
pr("")

pr("## Criterio '4 periodi su 4 con PF>1' (cosa dimostra?) - modello BINARIO, trade per periodo = n")
pr("| trade/periodo | P(4/4 periodi PF>1 | H0 PF=1.0) | P(4/4 | PF vero 1.15) | P(4/4 | PF vero 1.30) |")
pr("|---|---|---|---|---|")
for n in (7, 14, 28, 57, 85, 200):
    res = []
    for pft in (1.0, 1.15, 1.30):
        a = np.ones(NSIM, bool)
        for _ in range(4):
            a &= sim_pf(n, pft, False) > 1.0
        res.append(np.mean(a))
    pr(f"| {n} | {res[0]*100:.1f}% | {res[1]*100:.1f}% | {res[2]*100:.1f}% |")
pr("")

pr("## Intervallo di confidenza 90% del PF osservato quando il PF vero e 1.15 (binario, 5-95 percentile)")
pr("| N | PF 5% | PF mediano | PF 95% |")
pr("|---|---|---|---|")
for n in (28, 57, 114, 340, 1300):
    h1 = sim_pf(n, 1.15, False); h1 = h1[np.isfinite(h1)]
    q = np.quantile(h1, [0.05, 0.5, 0.95])
    pr(f"| {n} | {q[0]:.2f} | {q[1]:.2f} | {q[2]:.2f} |")

pr("")
pr("## MDE (potenza 80%, alpha 5%) agli N attesi dalle ipotesi di frequenza (binario, WR 60%)")
pr("| N | PF vero minimo rilevabile |")
pr("|---|---|")
for n in (6, 14, 17, 29, 43, 57, 71, 86, 143, 171, 214, 428):
    h0 = sim_pf(n, 1.0, False)
    crit = np.quantile(h0[np.isfinite(h0)], 0.95)
    found = None
    for pft in np.arange(1.05, 4.01, 0.05):
        if np.mean(sim_pf(n, pft, False) > crit) >= 0.80:
            found = pft; break
    pr(f"| {n} | {('%.2f' % found) if found else '>4.0'} |")

pr("")
pr("## Soglie di decisione: P(PF_oss >= 1.30) e P(PF_oss <= 1.00) per PF vero 1.0 / 1.15 / 1.30 (binario, WR 60%)")
pr("| N | P(>=1.30 | 1.0) | P(>=1.30 | 1.15) | P(>=1.30 | 1.30) | P(<=1.00 | 1.0) | P(<=1.00 | 1.15) | P(<=1.00 | 1.30) |")
pr("|---|---|---|---|---|---|---|---|")
for n in (30, 60, 100, 150, 300, 600):
    r = []
    sims = {pft: sim_pf(n, pft, False) for pft in (1.0, 1.15, 1.30)}
    for pft in (1.0, 1.15, 1.30): r.append(np.mean(sims[pft] >= 1.30))
    for pft in (1.0, 1.15, 1.30): r.append(np.mean(sims[pft] <= 1.00))
    pr(f"| {n} | " + " | ".join(f"{x*100:.0f}%" for x in r) + " |")

pr("")
pr("## Serie di perdite consecutive (WR 60% => p perdita 0.40): P(almeno una serie >= k in N trade)")
pr("| N trade | k=2 | k=3 | k=4 | k=5 | k=6 |")
pr("|---|---|---|---|---|---|")
for n in (12, 24, 57, 114):
    L = rng.random((NSIM, n)) < 0.40
    mx = np.zeros(NSIM, int); cur = np.zeros(NSIM, int)
    for j in range(n):
        cur = np.where(L[:, j], cur + 1, 0); mx = np.maximum(mx, cur)
    pr(f"| {n} | " + " | ".join(f"{np.mean(mx>=k)*100:.0f}%" for k in (2, 3, 4, 5, 6)) + " |")

open(sys.argv[2] if len(sys.argv) > 2 else "/dev/null", "w").write("\n".join(out) + "\n")
