#!/usr/bin/env python3
"""placebo_A4.py - V23: esegue la funzione `placebo` di A4 (run_test.placebo) su M1 SINTETICI (nessun CSV reale) con
parametri PARAMS congelati e un numero di anni limitato; riporta n, lordo medio R, z, netto, costo. Uso:
python3 -I placebo_A4.py <target_segnali> <max_anni>"""
import os, sys, time, json
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, os.path.join(HERE, "..", "A4"))
import run_test as RT
from params import PARAMS
t0 = time.time()
target, max_anni = int(sys.argv[1]), int(sys.argv[2])
out = RT.placebo(PARAMS, (60, 30), target, max_anni, 20261101)
for k, v in out.items():
    print(k, json.dumps(v, sort_keys=True))
print("tempo %.0f s" % (time.time() - t0))
