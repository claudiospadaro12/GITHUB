#!/usr/bin/env python3
# =====================================================================
# SONDA ORO <- TASSI, secondo passo (06/09/2026)
# Tre domande, decise PRIMA di guardare i numeri:
#  Q1 l'effetto sopravvive alla DEDUPLICA (un evento per finestra, come
#     farebbe un EA che non sovrappone posizioni)?
#  Q2 l'effetto e' del BOND o e' solo MOMENTUM DELL'ORO? Controllo:
#     stesso disegno con il segnale preso dall'oro stesso, e disegno
#     "bond forte MA oro fermo" (l'unico caso in cui il bond aggiunge).
#  Q3 quanto costa? L'edge si misura in DOLLARI ORO e si confronta con
#     il costo di andata+ritorno, che va DICHIARATO (spread BCM oro
#     [NON MISURATO IN REPO] - qui uso tre scenari).
# =====================================================================
import pickle, os, random
import numpy as np
from collections import defaultdict

random.seed(20260906)
D = os.path.dirname(os.path.abspath(__file__))
M = pickle.load(open(os.path.join(D, "cache", "m5.pkl"), "rb"))

def arr(d):
    ks = sorted(d)
    return (np.array([k.timestamp() for k in ks]), np.array([d[k][3] for k in ks]),
            np.array([k.year for k in ks]), np.array([k.hour for k in ks]), ks)

TO, CO, YO, HO, KO = arr(M["XAU_USD"])
TB, CB, YB, HB, KB = arr(M["USB10Y_USD"])
pos_oro = {t: i for i, t in enumerate(TO)}

def roll_std(x, w):
    c1 = np.concatenate(([0.0], np.cumsum(x))); c2 = np.concatenate(([0.0], np.cumsum(x * x)))
    n = len(x); out = np.full(n, np.nan); i = np.arange(w, n)
    s = c1[i] - c1[i - w]; ss = c2[i] - c2[i - w]
    out[i] = np.sqrt(np.maximum(ss / w - (s / w) ** 2, 0)); return out

def z_of(C, T, K, w=500):
    r = np.full(len(C), np.nan); r[K:] = C[K:] / C[:-K] - 1.0
    sd = roll_std(np.nan_to_num(r), w)
    z = r / sd
    ok = np.full(len(C), False); ok[K:] = (T[K:] - T[:-K]) <= K * 300 * 3
    z[~ok] = np.nan
    return z

def rapporto(nome, val, anni, costo=0.0):
    if len(val) < 20:
        print(f"{nome:60s} n={len(val):5d} (campione insufficiente)"); return None
    v = np.asarray(val, float) - costo
    m = v.mean(); t = m / (v.std() / np.sqrt(len(v)))
    pa = defaultdict(float)
    for x, a in zip(v, anni): pa[a] += x
    pos = sum(1 for a in pa if pa[a] > 0)
    gw = v[v > 0].sum(); gl = -v[v < 0].sum(); pf = gw / gl if gl > 0 else float("inf")
    print(f"{nome:60s} n={len(v):5d} media={m:+7.4f}$ t={t:+5.2f} PF={pf:5.3f} anni+={pos}/{len(pa)} tot={v.sum():+8.0f}$")
    return dict(n=len(v), m=m, t=t, pf=pf, pos=pos, anni=len(pa),
                per_anno={a: round(pa[a], 1) for a in sorted(pa)})

K, H, W = 6, 12, 500          # segnale 30', avanti 60'
ZB = z_of(CB, TB, K); ZO_ = z_of(CO, TO, K)

def raccogli(cond_idx, segno_src, H=H, dedup=True):
    """cond_idx = indici BOND selezionati; segno_src = 'bond' | 'oro'."""
    val, anni, ore = [], [], []
    ultimo = -1e18
    for ib in cond_idx:
        t = TB[ib]
        io_ = pos_oro.get(t)
        if io_ is None or io_ + H >= len(CO): continue
        if TO[io_ + H] - TO[io_] > H * 300 * 3: continue
        if dedup and t < ultimo + H * 300: continue      # niente sovrapposizione
        s = int(np.sign(ZB[ib])) if segno_src == "bond" else int(np.sign(ZO_[io_])) if not np.isnan(ZO_[io_]) else 0
        if s == 0: continue
        val.append(s * (CO[io_ + H] - CO[io_])); anni.append(int(YO[io_])); ore.append(int(HO[io_]))
        ultimo = t
    return val, anni, ore

print("=" * 122)
print("Q1 — DEDUPLICA: un solo evento per finestra di 60'. Segnale bond 30', |z| crescente.")
print("=" * 122)
for zmin in (2.0, 2.5, 3.0, 4.0):
    sel = np.where(np.abs(ZB) >= zmin)[0]
    v, a, o = raccogli(sel, "bond")
    rapporto(f"  |z_bond|>={zmin}  verso della tesi", v, a)

print("\n" + "=" * 122)
print("Q2 — E' IL BOND O E' L'ORO? tre disegni sugli STESSI istanti (|z_bond|>=2.5, dedup)")
print("=" * 122)
sel = np.where(np.abs(ZB) >= 2.5)[0]
v1, a1, o1 = raccogli(sel, "bond"); rapporto("  A) segno preso dal BOND", v1, a1)
v2, a2, _ = raccogli(sel, "oro");  rapporto("  B) segno preso dall'ORO (momentum proprio)", v2, a2)

# C) bond forte MA oro fermo: e' l'unico caso in cui il bond AGGIUNGE informazione
sel_c = [ib for ib in sel if (pos_oro.get(TB[ib]) is not None
                              and not np.isnan(ZO_[pos_oro[TB[ib]]])
                              and abs(ZO_[pos_oro[TB[ib]]]) < 1.0)]
v3, a3, o3 = raccogli(np.array(sel_c, int), "bond"); rapporto("  C) bond FORTE ma oro FERMO (|z_oro|<1) -> segno bond", v3, a3)

# D) momentum dell'oro DA SOLO, senza guardare il bond (stessa densita')
sel_d = np.where(np.abs(ZO_) >= 2.5)[0]
val, anni = [], []; ultimo = -1e18
for io_ in sel_d:
    if io_ + H >= len(CO): continue
    if TO[io_ + H] - TO[io_] > H * 300 * 3: continue
    if TO[io_] < ultimo + H * 300: continue
    val.append(np.sign(ZO_[io_]) * (CO[io_ + H] - CO[io_])); anni.append(int(YO[io_])); ultimo = TO[io_]
rapporto("  D) SOLO momentum dell'oro, il bond non si guarda", val, anni)

print("\n" + "=" * 122)
print("Q3 — IL COSTO. Stesso disegno A) al netto di tre scenari di costo andata+ritorno (dollari oro).")
print("  Lo spread BCM sull'oro NON E' MISURATO IN REPO: gli scenari sono DICHIARATI, non misurati.")
print("=" * 122)
for costo in (0.0, 0.20, 0.35, 0.50):
    rapporto(f"  A) |z_bond|>=2.5, costo A/R = {costo:.2f}$", v1, a1, costo)

print("\n" + "=" * 122)
print("Q4 — DOVE STA L'EFFETTO: per ora UTC (disegno A, |z_bond|>=2.0, dedup)")
print("=" * 122)
sel2 = np.where(np.abs(ZB) >= 2.0)[0]
v4, a4, o4 = raccogli(sel2, "bond")
per = defaultdict(list); pan = defaultdict(lambda: defaultdict(float))
for x, y, h in zip(v4, a4, o4): per[h].append(x); pan[h][y] += x
for h in range(24):
    vv = np.asarray(per.get(h, []), float)
    if len(vv) < 60: continue
    m = vv.mean(); t = m / (vv.std() / np.sqrt(len(vv)))
    pos = sum(1 for a in pan[h] if pan[h][a] > 0)
    print(f"  {h:02d}:00 UTC n={len(vv):5d} media={m:+7.4f}$ t={t:+5.2f} anni+={pos}/{len(pan[h])} tot={vv.sum():+8.1f}$")

print("\n" + "=" * 122)
print("Q5 — TENUTA D'EPOCA: disegno A |z_bond|>=2.5, anno per anno")
print("=" * 122)
pa = defaultdict(list)
for x, y in zip(v1, a1): pa[y].append(x)
for y in sorted(pa):
    vv = np.asarray(pa[y], float)
    print(f"  {y}  n={len(vv):4d}  media={vv.mean():+7.4f}$  tot={vv.sum():+8.1f}$")
