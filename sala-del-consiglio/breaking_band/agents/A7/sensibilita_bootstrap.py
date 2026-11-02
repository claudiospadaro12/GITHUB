#!/usr/bin/env python3
"""sensibilita_bootstrap.py - (5) scelte NON dichiarate dal documento dei criteri che potrebbero spostare il limite inferiore dell'IC90:
seme, definizione della statistica del replicato, blocco (settimana condivisa / per coppia / 2 settimane), metodo del quantile.
Dati: i 4 JSON dei vecchi anni (final/run_forex, ammessi) = pooled H1 reale in-sample, N=64, e lo scenario sintetico 13. Nessun CSV."""
import json, os, sys
import numpy as np
HERE = os.path.dirname(os.path.abspath(__file__)); sys.path.insert(0, HERE)
import agg_indipendente as AI
BB = os.path.abspath(os.path.join(HERE, "..", ".."))
runs = {s: json.load(open(os.path.join(BB, "final/run_forex/%s.json" % s))) for s in AI.COPPIE}
tr = [dict(t, _sym=s) for s, j in runs.items() for t in AI.trade_h1(j)]
R = np.array([t["R"] for t in tr]); wk = np.array([AI.settimana(t) for t in tr]); sym = np.array([t["_sym"] for t in tr])
print("N=%d media=%.4f" % (len(R), R.mean()))
def boot(keys, stat="ratio", seed=AI.SEED, n=10000, method="linear"):
    u, inv = np.unique(keys, return_inverse=True); K = len(u)
    s = np.bincount(inv, weights=R, minlength=K); c = np.bincount(inv, minlength=K).astype(float)
    rng = np.random.default_rng(seed); sel = rng.integers(0, K, size=(n, K))
    m = s[sel].sum(axis=1) / c[sel].sum(axis=1) if stat == "ratio" else (s / c)[sel].mean(axis=1)
    return K, np.quantile(m, [0.05, 0.95], method=method)
rows = [("A4/A7 base: settimana condivisa, rapporto somme, seme 20261101, linear", boot(wk)),
        ("statistica = media delle medie settimanali", boot(wk, "media_medie")),
        ("blocco = coppia x settimana (non condiviso)", boot(np.array(["%s_%d" % (s, w) for s, w in zip(sym, wk)]))),
        ("blocco = 2 settimane condivise", boot(wk // 2)),
        ("quantile 'lower'/'higher' (stesso seme)", boot(wk, method="lower")),
        ("blocco = singolo trade (nessun blocco)", boot(np.arange(len(R))))]
for nome, (K, (lo, hi)) in rows: print("  %-70s blocchi=%2d  IC90 [%.4f, %.4f]  lo>0: %s" % (nome, K, lo, hi, lo > 0))
los = [boot(wk, seed=s, n=10000)[1][0] for s in range(1, 201)]
print("  200 semi diversi (base): lo min %.4f  max %.4f  | semi con lo<=0: %d" % (min(los), max(los), sum(1 for x in los if x <= 0)))
