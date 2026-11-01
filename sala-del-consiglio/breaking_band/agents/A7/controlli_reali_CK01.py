#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""controlli_reali_CK01.py - CK-01/CK-03/V11 su un ESTRATTO REALE (autorizzato da C0): H1 e M30 dei periodi 2013 e 2020,
signal_fn di A4 (CONT/INV) e reimplementazione A7: troncamento (tagli casuali + intorno ai segnali), perturbazione del
futuro, riproducibilita, specchio. Uso: python3 -I controlli_reali_CK01.py <cartella_csv>"""
import os, sys
import numpy as np
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import confronto_con_A4 as C
VG, R, AT = C.VG, C.R, C.AT
FILES = {"2013": "ABTG_M1_XAUUSD_2013.csv", "2020": "ABTG_M1_XAUUSD_2020.csv"}

def main():
    folder = sys.argv[1]; S, E = C.load_a4(); ok_all = True
    for per, fn in FILES.items():
        m1 = VG.load_m1_csv(os.path.join(folder, fn))
        for tf in (60, 30):
            bars = VG.aggregate_m1(m1, tf, min_m1=1)
            bars.pop("n_m1", None)
            for var in ("CONT", "INV"):
                f4 = S.signal_fn_factory(var, tf)
                def f7(b, var=var):
                    r = R.detect(b); sg = np.zeros(len(b["close"]), dtype=np.int8)
                    for s in r["signals"]:
                        if s["tipo"] == var: sg[s["bar"]] = s["side"]
                    return {"signal": sg}
                for nome, fn_ in (("A4", f4), ("A7", f7)):
                    n_sig = int(np.sum(fn_(bars)["signal"] != 0))
                    if n_sig == 0:
                        print("%s %s TF=%d %s: 0 segnali -> NON_CONCLUSIVO" % (per, var, tf, nome)); ok_all = False; continue
                    ms = min(n_sig, 3)
                    res = [VG.check_truncation_invariance(fn_, bars, n_cuts=120, min_signals=ms, exhaustive_max=0),
                           VG.check_future_perturbation(fn_, bars, n_trials=20, min_signals=ms),
                           VG.check_reproducibility(fn_, bars)]
                    if nome == "A7":
                        res.append(VG.check_mirror_symmetry(fn_, bars, offset=8192.0, flip_keys=("signal",), min_signals=ms, min_each_side=0))
                    st = [r.status for r in res]
                    print("%-8s %-4s TF=%d %s: segnali=%d  troncamento=%s perturbazione=%s riprod=%s%s" % (per, var, tf, nome, n_sig, st[0], st[1], st[2], (" specchio=" + st[3]) if len(st) > 3 else ""), flush=True)
                    ok_all &= all(r.passed for r in res)
    print("\nESITO CK-01/CK-03/V11 su estratto reale: %s" % ("SUPERATO" if ok_all else "NON TUTTI SUPERATI"))
    return 0 if ok_all else 1

if __name__ == "__main__":
    sys.exit(main())
