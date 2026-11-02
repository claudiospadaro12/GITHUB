import sys; sys.path.insert(0, '.')
import numpy as np, bb

def mk(n, f, t0=24*60*10):  # n minuti M1 consecutivi, prezzo f(i)
    t = t0 + np.arange(n); c = np.array([f(i) for i in range(n)], float)
    o = np.concatenate([[c[0]], c[:-1]]); h = np.maximum(o, c) + 0.0; l = np.minimum(o, c) - 0.0
    return dict(t=t.astype(np.int64), o=o, h=h, l=l, c=c)

def test_barre_indicatori():
    m = mk(60 * 60, lambda i: 100 + (i // 60) * 1.0 + (i % 60) * 0.001)
    b = bb.barre(m, 60)
    assert b["c"].size == 60 and b["st"][1] == 60
    P = dict(bb.DEF); sma, sd, atr = bb.indicatori(b, P)
    c = b["c"]
    assert np.isnan(sma[35]) and abs(sma[36] - c[:37].mean()) < 1e-9 and abs(sd[36] - c[:37].std()) < 1e-9
    j = 20
    tr = [max(b["h"][k] - b["l"][k], abs(b["h"][k] - c[k - 1]), abs(b["l"][k] - c[k - 1])) for k in range(j - 13, j + 1)]
    assert abs(atr[j] - np.mean(tr)) < 1e-9 and np.isnan(atr[13])

def test_sim_long_tp_e_sl():
    P = dict(bb.DEF); P["SPREAD_BP"] = 0.0
    # 5 barre da 60 minuti; barra 0 segnale, ingresso a barra 1
    n = 5 * 60
    t = np.arange(n, dtype=np.int64); o = np.full(n, 100.0); h = o + 0.1; l = o - 0.1; c = o.copy()
    m = dict(t=t, o=o, h=h, l=l, c=c); b = bb.barre(m, 60)
    sma = np.full(5, 103.0); atr = np.full(5, 1.0)
    # sl = low_0 - 1.5 = 98.4 ; entry 100 ; r0=1.6 ; target 103 -> R=3/1.6
    h2 = h.copy(); h2[130] = 103.5; m2 = dict(t=t, o=o, h=h2, l=l, c=c); b2 = bb.barre(m2, 60)
    r = bb.simula(m2, b2, sma, atr, 0, 1, P)
    assert r["motivo"] == "TP" and abs(r["R"] - 3 / 1.6) < 1e-9, r
    l3 = l.copy(); l3[100] = 98.0; m3 = dict(t=t, o=o, h=h, l=l3, c=c); b3 = bb.barre(m3, 60)
    r = bb.simula(m3, b3, sma, atr, 0, 1, P)
    assert r["motivo"] == "SL" and abs(r["R"] + 1) < 1e-9, r
    # stop prima del target nello stesso minuto
    h4 = h.copy(); l4 = l.copy(); h4[100] = 104; l4[100] = 98.0
    m4 = dict(t=t, o=o, h=h4, l=l4, c=c); b4 = bb.barre(m4, 60)
    assert bb.simula(m4, b4, sma, atr, 0, 1, P)["motivo"] == "SL"

def test_sim_short_spread():
    P = dict(bb.DEF); P["SPREAD_BP"] = 100.0  # 1% per rendere visibile
    n = 5 * 60
    t = np.arange(n, dtype=np.int64); o = np.full(n, 100.0); h = o + 0.1; l = o - 0.1; c = o.copy()
    l[130] = 96.0
    m = dict(t=t, o=o, h=h, l=l, c=c); b = bb.barre(m, 60)
    sma = np.full(5, 97.0); atr = np.full(5, 1.0)
    # short: entry bid=100; sl = high_0 + 1.5 = 101.6; r0=1.6; target ask_low = 96+1=97 <= 97 -> TP a 97
    r = bb.simula(m, b, sma, atr, 0, -1, P)
    assert r["motivo"] == "TP" and abs(r["R"] - 3 / 1.6) < 1e-9, r
    # long con spread: entry ask 101
    sma2 = np.full(5, 110.0); h2 = h.copy(); h2[130] = 111
    m2 = dict(t=t, o=o, h=h2, l=l * 0 + 99.9, c=c); b2 = bb.barre(m2, 60)
    r = bb.simula(m2, b2, sma2, atr, 0, 1, P)
    assert abs(r["entry"] - 101.0) < 1e-9 and abs(r["R"] - (110 - 101) / (101 - (99.9 - 1.5))) < 1e-9, r

def test_livelli_precedenti():
    # 3 giorni: la barra del giorno 3 deve vedere high/low del giorno 2 (non del proprio)
    d = 1440; n = 3 * d
    t = np.arange(n, dtype=np.int64) + 20000 * d
    c = np.concatenate([np.full(d, 10.0), np.full(d, 20.0), np.full(d, 30.0)])
    m = dict(t=t, o=c.copy(), h=c + 1, l=c - 1, c=c); b = bb.barre(m, 60)
    sup, res = bb.livelli(m, b["t"])
    k = np.flatnonzero(b["t"] >= t[2 * d])[0]
    assert res[k, 0] == 21 and sup[k, 0] == 19
    assert np.isnan(res[0, 0])

if __name__ == "__main__":
    for k, v in list(globals().items()):
        if k.startswith("test_"):
            v(); print("ok", k)
