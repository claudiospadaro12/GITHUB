#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""controlli_A4_sintetici.py - V01 (troncamento), V02 (perturbazione), V04 (specchio), V11 (riproducibilita) sulla
signal_fn di A4 (signals.signal_fn_factory), SOLO su dati SINTETICI (serie a regimi + pattern piantati).
NON legge i CSV reali. Uso: python3 -I controlli_A4_sintetici.py"""
import os, sys
import numpy as np
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import confronto_con_A4 as C     # noqa
PP, AT, VG = C.PP, C.AT, C.VG

def main():
    S, E = C.load_a4()
    allok = True
    for var in ("CONT", "INV"):
        for tf in (60, 30):
            fn = S.signal_fn_factory(var, tf)
            bars = AT.regime_series(6000, 3 if var == "CONT" else 7)   # seme 7: la serie ha 2 segnali INV (e 7 CONT)
            bars["time"] = np.arange(6000, dtype=np.int64) * tf
            n_sig = int(np.sum(fn(bars)["signal"] != 0))
            res = [VG.check_truncation_invariance(fn, bars, n_cuts=150, min_signals=2),
                   VG.check_future_perturbation(fn, bars, n_trials=40, min_signals=2),
                   VG.check_mirror_symmetry(fn, bars, offset=PP.KMIRROR, flip_keys=("signal",), price_keys=("sma20",), min_signals=2, min_each_side=0, atol=1e-9),
                   VG.check_reproducibility(fn, bars)]
            print("--- A4 %s TF=%d: serie a regimi 6000 barre, %d segnali" % (var, tf, n_sig))
            for r in res:
                print("   ", r); allok &= r.passed
    # pattern piantati: troncamento esaustivo con coda
    for nm, var in (("C_POS", "CONT"), ("I_POS", "INV")):
        sc = [s for s in PP.scenari() if s["nome"] == nm][0]
        b = PP.build(list(sc["deltas"]) + PP.O(25), n_q=sc["n_q"]); b["time"] = np.arange(len(b["close"]), dtype=np.int64) * 60
        r = VG.check_truncation_invariance(S.signal_fn_factory(var, 60), b, min_signals=1, min_cut=60)
        print("--- A4 %s su %s con coda:" % (var, nm), r); allok &= r.passed
    print("\nESITO controlli A4 su sintetici: %s" % ("TUTTI SUPERATI" if allok else "ALMENO UNO NON SUPERATO"))
    return 0 if allok else 1



def batteria_su_A4():
    """Esegue i pattern piantati (attese scritte a mano da A7) sul codice dei segnali di A4. Confronta SOLO i segnali
    (i contatori sono di A7). I meccanismi con parametro alterato usano i nomi di params.PARAMS di A4."""
    S, E = C.load_a4()
    from params import PARAMS
    mapcfg = {"min_retr": "MIN_RETR", "t_max": "T_MAX"}
    res = []
    for sc in PP.scenari():
        b = PP.build(sc["deltas"], wick=sc["wick"], n_q=sc["n_q"], dip=sc.get("dip", 0.0))
        n = len(b["close"])
        for tag, bars, mir in (("LONG", b, False), ("SHORT", PP.mirror(b), True)):
            if sc.get("solo_long") and mir:
                continue
            if any(k not in mapcfg for k in sc["cfg"]):
                continue            # meccanismi di sola reimplementazione A7 (alt_*)
            prm = dict(PARAMS)
            for k, v in sc["cfg"].items():
                prm[mapcfg[k]] = v
            bb = dict(bars); bb["time"] = np.arange(n, dtype=np.int64) * 60
            br = S.barre_da_dict(bb, 60); ind = E.indicatori(br)
            got = []
            for var in ("CONT", "INV"):
                r = S.rileva(br, ind, var, prm)
                got += [(int(s["j"]), int(s["side"]), var) for s in r["segnali"]]
            got = sorted(got)
            exp = PP._expected_signals(sc, n, mir)
            ok = got == exp
            res.append(ok)
            print("%s  A4 su %s [%s]: attesi=%s ottenuti=%s" % ("PASS" if ok else "FAIL", sc["nome"], tag, exp, got))
    print("\nBATTERIA PATTERN PIANTATI SU A4: %d/%d" % (sum(res), len(res)))
    return all(res)


if __name__ == "__main__":
    rc = main()
    ok = batteria_su_A4()
    sys.exit(0 if (rc == 0 and ok) else 1)
