#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""simmetria_motore_A4.py - V05: simmetria long/short del motore di A4 (engine.simula_trade) su M1 SINTETICI.
Con spread = 0 lo specchio dei prezzi (p' = K - p, High<->Low) deve dare, per lo stesso segnale con lato opposto,
stesso ingresso/uscita/motivo e R identico. (Con spread > 0 l'uguaglianza esatta non vale per costruzione:
il target SMA20 e calcolato sulle chiusure BID, che nello specchio bid/ask traslano di s; la contabilita dello spread
long/short e verificata dal ricalcolo indipendente, vedi ricalcolo_motore_A4_sintetico.py.)
Uso: python3 -I simmetria_motore_A4.py   (nessun CSV reale)"""
import os, sys
import numpy as np
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import confronto_con_A4 as C      # noqa
VG = C.VG
K = 4096.0

def quant(x): return np.round(x * 128.0) / 128.0

def main(n_trades=800):
    S, E = C.load_a4()
    ok_all = True
    for seed in (11, 12):
        ms = VG._synth_m1(seed=seed, weeks=6)
        o, h, l, c = quant(ms.o), quant(ms.h), quant(ms.l), quant(ms.c)
        h = np.maximum.reduce([h, o, c]); l = np.minimum.reduce([l, o, c])
        z = np.zeros(ms.n)
        m_a = E.costruisci_m1(ms.t, o, h, l, c, z)
        m_b = E.costruisci_m1(ms.t, K - o, K - l, K - h, K - c, z)
        for tf in (60, 30):
            ba, bb = E.costruisci_barre(m_a, tf), E.costruisci_barre(m_b, tf)
            ia, ib = E.indicatori(ba), E.indicatori(bb)
            rng = np.random.default_rng(seed * 100 + tf)
            n_eseg = n_diff = n_scarto_diverso = 0
            motivi = {}
            for j in rng.integers(200, ba.n - 5, n_trades):
                s = int(rng.choice([-1, 1]))
                ta = E.simula_trade(m_a, ba, ia, int(j), s)
                tb = E.simula_trade(m_b, bb, ib, int(j), -s)
                if ta["eseguito"] != tb["eseguito"]:
                    n_scarto_diverso += 1
                    continue
                if not ta["eseguito"]:
                    if ta["scarto"] != tb["scarto"]:
                        n_scarto_diverso += 1
                    continue
                n_eseg += 1
                motivi[ta["motivo"]] = motivi.get(ta["motivo"], 0) + 1
                same = (ta["entry_m1"] == tb["entry_m1"] and ta["exit_m1"] == tb["exit_m1"] and ta["motivo"] == tb["motivo"]
                        and abs(ta["R"] - tb["R"]) < 1e-9 and abs(ta["entry"] + tb["entry"] - K) < 1e-9
                        and abs(ta["exit"] + tb["exit"] - K) < 1e-9 and ta["sl_e_tp_stesso_minuto"] == tb["sl_e_tp_stesso_minuto"])
                n_diff += (not same)
            ok = (n_diff == 0 and n_scarto_diverso == 0 and n_eseg > 100)
            ok_all &= ok
            print("seed=%d TF=%d spread=0: eseguiti=%d, trade non speculari=%d, scarti diversi=%d, uscite=%s -> %s" %
                  (seed, tf, n_eseg, n_diff, n_scarto_diverso, motivi, "SUPERATO" if ok else "FALLITO"))
    print("\nESITO V05 simmetria del motore (spread 0): %s" % ("SUPERATO" if ok_all else "FALLITO"))
    return 0 if ok_all else 1

if __name__ == "__main__":
    sys.exit(main())
