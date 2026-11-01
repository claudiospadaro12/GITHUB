#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
autotest_reimpl.py - Auto-test della reimplementazione indipendente (A7). Solo dati SINTETICI.
Esegue: (1) test unitari a mano + armamento + pattern piantati (pattern_piantati.py);
        (2) controlli generici di verifica_generica.py applicati a reimpl_segnali.detect su una serie sintetica
            con molti episodi (troncamento, perturbazione, specchio, riproducibilita);
        (3) test di MUTAZIONE della reimplementazione: ogni mutante deve far FALLIRE almeno una verifica della
            batteria (altrimenti la batteria non ha i denti per quel difetto; il risultato e riportato).
Uso:  python3 -I autotest_reimpl.py
NON legge i CSV reali.
"""
import os
import sys
import time

import numpy as np

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import pattern_piantati as PP          # noqa: E402
R, VG = PP.R, PP.VG


def regime_series(n, seed):
    """Serie sintetica a regimi (calma / burst direzionale / deriva), quantizzata a 1/128 per specchio esatto."""
    rng = np.random.default_rng(seed)
    c = np.empty(n)
    c[0] = 2000.0
    left, drift, sig, mode = 0, 0.0, 0.5, "calm"
    for i in range(1, n):
        if left <= 0:
            r = rng.random()
            if r < 0.55:
                mode, left, drift, sig = "calm", int(rng.integers(20, 60)), 0.0, 0.5
            elif r < 0.80:
                mode, left, drift, sig = "burst", int(rng.integers(4, 12)), float(rng.choice([-1, 1]) * rng.uniform(1.5, 3.0)), 0.4
            else:
                mode, left, drift, sig = "drift", int(rng.integers(15, 40)), float(rng.normal(0, 0.3)), 0.7
        c[i] = c[i - 1] + (drift if mode != "calm" else 0.0) + rng.normal(0, sig)
        left -= 1
    o = np.r_[c[0], c[:-1]]
    h = np.maximum(o, c) + np.abs(rng.normal(0, 0.3, n))
    l = np.minimum(o, c) - np.abs(rng.normal(0, 0.3, n))
    q = lambda x: np.round(x * 128.0) / 128.0
    o, h, l, c = q(o), q(h), q(l), q(c)
    h = np.maximum.reduce([h, o, c]); l = np.minimum.reduce([l, o, c])
    return {"time": np.arange(n, dtype=np.int64) * 60, "open": o, "high": h, "low": l, "close": c, "spread": np.full(n, 20.0)}


def signal_fn(bars):
    res = R.detect(bars)
    n = len(bars["close"])
    sig = np.zeros(n, dtype=np.int8); cont = np.zeros(n, dtype=np.int8); inv = np.zeros(n, dtype=np.int8)
    for s in res["signals"]:
        sig[s["bar"]] = s["side"]
        (cont if s["tipo"] == "CONT" else inv)[s["bar"]] = s["side"]
    return {"signal": sig, "cont": cont, "inv": inv}


def main():
    t0 = time.time()
    allres = []
    print("=== (1) UNITARI + ARMAMENTO + PATTERN PIANTATI ===")
    allres += PP.unit_tests()
    allres += PP.run_arm(PP.arm_reimpl)
    allres += PP.run_scenari(PP.detect_reimpl)
    base_ok = all(ok for _, ok, _ in allres)
    print("\n=== (2) CONTROLLI GENERICI (verifica_generica) SU reimpl_segnali ===")
    bars = regime_series(6000, 3)
    nsig = int(np.sum(signal_fn(bars)["signal"] != 0))
    print("serie sintetica a regimi: %d barre, %d segnali" % (len(bars["close"]), nsig))
    checks = [VG.check_truncation_invariance(signal_fn, bars, n_cuts=150, min_signals=3),
              VG.check_future_perturbation(signal_fn, bars, n_trials=40, min_signals=3),
              VG.check_mirror_symmetry(signal_fn, bars, offset=PP.KMIRROR, flip_keys=("signal", "cont", "inv"), min_signals=3),
              VG.check_reproducibility(signal_fn, bars)]
    for r in checks:
        ok = r.status == VG.SUPERATO
        allres.append(("generico: " + r.name, ok, r.detail))
        print("%s  %s" % ("PASS" if ok else "FAIL", r))
    # troncamento esaustivo sui due pattern piantati (n ~ 260 barre)
    for nm in ("C_POS", "I_POS"):
        sc = [s for s in PP.scenari() if s["nome"] == nm][0]
        b = PP.build(list(sc["deltas"]) + PP.O(25), n_q=sc["n_q"])   # coda dopo il segnale: il taglio puo cadere sulla barra del segnale e oltre
        b["time"] = np.arange(len(b["close"]), dtype=np.int64); b["spread"] = np.zeros(len(b["close"]))
        # taglio esaustivo: il segnale alla barra k (ultima) non deve cambiare se si cancellano le barre dopo k
        r = VG.check_truncation_invariance(signal_fn, b, min_signals=1, min_cut=60)
        ok = r.status == VG.SUPERATO
        allres.append(("troncamento esaustivo su %s" % nm, ok, r.detail))
        print("%s  troncamento esaustivo su %s: %s" % ("PASS" if ok else "FAIL", nm, r.detail))
    # spostamento temporale / traslazione additiva (CK-15): segnali invarianti a +c sui prezzi
    shifted = dict(bars);
    for k in ("open", "high", "low", "close"):
        shifted[k] = bars[k] + 512.0
    same = np.array_equal(signal_fn(bars)["signal"], signal_fn(shifted)["signal"])
    allres.append(("invarianza a traslazione additiva dei prezzi (+512)", same, ""))
    print("%s  invarianza a traslazione additiva dei prezzi (+512)" % ("PASS" if same else "FAIL"))

    print("\n=== (3) TEST DI MUTAZIONE: la batteria deve accorgersi di ogni difetto iniettato ===")
    mutants = [
        ("SEQ disattivata", {"patch": ("_seq_present", lambda v, p, t: False)}),
        ("cancello sd spento (sd_gate=False)", {"cfg": {"sd_gate": False}}),
        ("soglia candela impulsiva 3,0 invece di 1,5 (CONT)", {"cfg": {"impulsiva": 3.0}}),
        ("soglia candela impulsiva INV 3,0", {"cfg": {"impulsiva_inv": 3.0}}),
        ("T_MAX 100 invece di 30 -> non rilevabile dai pattern? (vedi esito)", {"cfg": {"t_max": 100}}),
        ("MIN_RETR 0 (nessun tocco precoce)", {"cfg": {"min_retr": 0}}),
        ("tolleranza banda INV 5 ATR (banda inclinata ammessa)", {"cfg": {"band_tol": 5.0}}),
        ("B1 bande: soglia 0,5 invece di 2,0", {"cfg": {"b1_w": 0.5}}),
        ("B4 ER soglia 0", {"cfg": {"b4_er": 0.0}}),
        ("B5 mediana: soglia 0", {"cfg": {"b5_atr": 0.0}}),
        ("B3 impulsiva: soglia 0", {"cfg": {"b3_atr": 0.0}}),
        ("B6 impulso lungo: limite 1000", {"cfg": {"b6_barre": 1000}}),
        ("warm-up 0", {"cfg": {"warmup": 0}}),
        ("sd_lag 1 invece di 3", {"cfg": {"sd_lag": 1}}),
    ]
    killed = 0
    for desc, m in mutants:
        saved = None
        if "patch" in m:
            name, fn = m["patch"]
            saved = getattr(R, name)
            setattr(R, name, fn)
        cfgm = m.get("cfg", {})

        def det(bars_, cfgd, cfgm=cfgm):
            d = dict(cfgd); d.update(cfgm)
            return R.detect(bars_, R.Cfg(**d), trace=False)
        res = PP.run_scenari(det, verbose=False)
        res_arm = []
        for dsc, bb, t, exp, _ in PP.scenari_arm():
            cfg = R.Cfg(**cfgm)
            v = R.View(np.asarray(bb["open"], float), np.asarray(bb["high"], float), np.asarray(bb["low"], float), np.asarray(bb["close"], float), cfg)
            s_, fl, rd = R._arm_check(v, t, cfg)
            res_arm.append((dsc, rd and list(fl) == exp, ""))
        fails = [d for d, ok, _ in res + res_arm if not ok]
        if saved is not None:
            setattr(R, name, saved)
        dead = bool(fails)
        killed += dead
        print("%s  mutante '%s': %s" % ("UCCISO " if dead else "SOPRAVVISSUTO", desc, ("%d verifiche falliscono, es. '%s'" % (len(fails), fails[0][:90])) if dead else "nessuna verifica lo rileva"))
    n_surv = len(mutants) - killed
    print("mutanti uccisi: %d/%d (sopravvissuti: %d)" % (killed, len(mutants), n_surv))
    n_ok = sum(1 for _, ok, _ in allres if ok)
    print("\nAUTO-TEST REIMPL: %d/%d verifiche riuscite (batteria + generici); mutanti uccisi %d/%d; tempo %.1f s" %
          (n_ok, len(allres), killed, len(mutants), time.time() - t0))
    return 0 if (n_ok == len(allres)) else 1


if __name__ == "__main__":
    sys.exit(main())
