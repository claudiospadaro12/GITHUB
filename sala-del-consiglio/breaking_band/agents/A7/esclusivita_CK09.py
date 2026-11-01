#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""esclusivita_CK09.py - CK-09: un solo segnale per episodio e per variante, esclusivita CONT/INV, una posizione per variante.
Solo dati SINTETICI. Uso: python3 -I esclusivita_CK09.py"""
import os, sys, tempfile
import numpy as np
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import confronto_con_A4 as C      # noqa
PP, AT, VG, R = C.PP, C.AT, C.VG, C.R

def expand_m1(bars, tf=60, spread_pts=20.0):
    """H1 -> M1 (60 per barra) che riaggrega ESATTAMENTE nelle stesse barre (open, high, low, close)."""
    n = len(bars["close"]); k = tf
    t = (np.arange(n)[:, None] * tf + np.arange(k)[None, :]).reshape(-1).astype(np.int64) + 60 * 24 * 1000
    o = np.empty((n, k)); c = np.empty((n, k)); h = np.empty((n, k)); l = np.empty((n, k))
    for i in range(n):
        path = np.linspace(bars["open"][i], bars["close"][i], k + 1)
        o[i] = path[:-1]; c[i] = path[1:]
        h[i] = np.maximum(o[i], c[i]); l[i] = np.minimum(o[i], c[i])
        h[i, 20] = bars["high"][i]; l[i, 40] = bars["low"][i]
    return t, o.reshape(-1), h.reshape(-1), l.reshape(-1), c.reshape(-1), np.full(n * k, spread_pts)

def main():
    S, E = C.load_a4()
    ok_all = True
    # (a) un solo segnale per episodio e variante: 40 serie, A4 e A7
    viol4 = viol7 = n_sig4 = both = 0
    for seed in range(1, 41):
        bars = AT.regime_series(6000, seed)
        br = S.barre_da_dict(dict(bars, time=np.arange(6000, dtype=np.int64) * 60), 60); ind = E.indicatori(br)
        per_var = {}
        for var in ("CONT", "INV"):
            r = S.rileva(br, ind, var)
            n_sig4 += len(r["segnali"])
            cnt = {}
            for s in r["segnali"]:
                cnt[(s["d"], s["s"])] = cnt.get((s["d"], s["s"]), 0) + 1
            viol4 += sum(1 for v in cnt.values() if v > 1)
            per_var[var] = set(cnt)
        both += len(per_var["CONT"] & per_var["INV"])
        res = R.detect(bars)
        for e in res["episodes"]:
            for var in ("CONT", "INV"):
                if sum(1 for _, tp in e["segnali"] if tp == var) > 1:
                    viol7 += 1
    print("(a) 40 serie a regimi: %d segnali A4; episodi con >1 segnale per variante: A4=%d, A7=%d; episodi con CONT e INV insieme=%d" % (n_sig4, viol4, viol7, both))
    ok_all &= (viol4 == 0 and viol7 == 0)
    # (a2) scenario: dopo il segnale i tocchi successivi non generano un secondo segnale
    sc = [s for s in PP.scenari() if s["nome"] == "C_POS"][0]
    b = PP.build(list(sc["deltas"]) + [-0.8, -0.8, -0.8, -0.8] + PP.O(6) + [-0.8, -0.8], n_q=sc["n_q"])
    b["time"] = np.arange(len(b["close"]), dtype=np.int64) * 60
    br = S.barre_da_dict(b, 60); ind = E.indicatori(br)
    r4 = S.rileva(br, ind, "CONT"); r7 = R.detect(b)
    n_touch = int(np.sum(br.l <= ind.bb_lo)); 
    s4 = [(s["j"]) for s in r4["segnali"]]; s7 = [s["bar"] for s in r7["signals"] if s["tipo"] == "CONT"]
    print("(a2) scenario con 7 barre di tocco consecutive della banda opposta dopo il segnale: segnali CONT A4=%s A7=%s" % (s4, s7))
    ok_all &= (len(s4) == 1 and len(s7) == 1 and s4 == s7)
    # (c) una posizione per variante: segnali densi artificiali + reali su M1 espansi
    bars = AT.regime_series(6000, 3)
    t, o, h, l, c, sp = expand_m1(bars)
    m4 = E.costruisci_m1(t, o, h, l, c, sp)
    br = E.costruisci_barre(m4, 60); ind = E.indicatori(br)
    same = np.array_equal(br.o, bars["open"]) and np.array_equal(br.h, bars["high"]) and np.array_equal(br.l, bars["low"]) and np.allclose(br.c, bars["close"], atol=1e-9)
    print("(c0) M1 espansi riaggregano nelle barre originali: %s" % same)
    real = []
    for var in ("CONT", "INV"):
        real += [(s["j"], s["side"]) for s in S.rileva(br, ind, var)["segnali"]]
    rng = np.random.default_rng(5)
    dense = [(int(j), int(rng.choice([-1, 1]))) for j in range(300, 1500, 3)]
    for label, sigs in (("reali", sorted(real)), ("densi artificiali + reali", sorted(set(real) | set(dense)))):
        trades, cont = E.esegui_segnali(m4, br, ind, sigs)
        # ricostruzione indipendente con il mio simulatore
        m7 = VG.M1(t, o, h, l, c, sp)
        last_exit = -1; ex7 = []; disc7 = 0
        for j, side in sorted(sigs, key=lambda z: z[0]):
            e_t = int(br.t[j]) + 60
            i0 = m7.first_index_at_or_after(e_t)
            if i0 <= last_exit:
                disc7 += 1; continue
            tr = E.simula_trade(m4, br, ind, j, side)         # solo per ottenere livelli e schedule (log di A4)
            if not tr["eseguito"]:
                continue
            r = VG.simulate_trade(m7, {"direction": side, "entry_time": e_t, "stop": tr["stop"], "targets": tr["targets"]}, max_entry_gap_min=180)
            if r.get("status") != "ok":
                continue
            ex7.append((j, r["exit_idx"])); last_exit = r["exit_idx"]
        ex4 = [(tr["j"], tr["exit_m1"]) for tr in trades]
        sovr = sum(1 for a, b2 in zip(trades[:-1], trades[1:]) if b2["entry_m1"] <= a["exit_m1"])
        rec = cont["segnali"] == cont["eseguiti"] + cont["scartati_posizione_aperta"] + cont["scartati_target_oltre_ingresso"] + cont["scartati_indicatori_non_pronti"] + cont["scartati_no_barra_successiva"] + cont["scartati_gap_ingresso"]
        ok = (ex4 == ex7 and disc7 == cont["scartati_posizione_aperta"] and sovr == 0 and rec)
        ok_all &= ok
        print("(c) segnali %s: %d segnali, eseguiti=%d, scartati per posizione aperta A4=%d / ricostruzione A7=%d, sovrapposizioni=%d, contatori riconciliati=%s, stessi trade (barra, uscita)=%s -> %s" %
              (label, cont["segnali"], cont["eseguiti"], cont["scartati_posizione_aperta"], disc7, sovr, rec, ex4 == ex7, "SUPERATO" if ok else "FALLITO"))
    print("\nESITO CK-09: %s" % ("SUPERATO" if ok_all else "FALLITO"))
    return 0 if ok_all else 1

if __name__ == "__main__":
    sys.exit(main())
