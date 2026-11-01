#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""ricalcolo_motore_A4_sintetico.py - V05/V06/V07/V08/V12/V13 sul MOTORE di A4 (engine.simula_trade), SOLO su dati
M1 SINTETICI scritti in un CSV temporaneo e letti da entrambi i lati (A4: engine.carica; A7: verifica_generica.load_m1_csv).
Per ogni trade eseguito da A4 il ricalcolatore indipendente (verifica_generica.simulate_trade, scritto da zero) ricostruisce
ingresso, uscita e P&L partendo SOLO da: direzione, barra segnale, stop e schedule dei target registrati nel log di A4.
Uso: python3 -I ricalcolo_motore_A4_sintetico.py   (nessun CSV reale)"""
import os, sys, tempfile
import numpy as np
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import confronto_con_A4 as C      # noqa
import verifica_generica as VG    # noqa

MOT = {"SL": "stop", "TP": "target", "MKT": "mkt", "TF": "forced", "FINE_DATI": "end_of_data"}


def write_csv(m1, path):
    with open(path, "w") as f:
        f.write("time;open;high;low;close;tickvol;spread\n")
        for i in range(m1.n):
            f.write("%s;%.2f;%.2f;%.2f;%.2f;10;%d\n" % (VG.minutes_to_str(m1.t[i]).replace("-", ".")[:16], m1.o[i], m1.h[i], m1.l[i], m1.c[i], int(m1.sp_pts[i])))


def main(n_trades=600, seed=2026):
    S, E = C.load_a4()
    out = []
    ok_all = True
    for label, wk in (("M1 con spread variabile 10-40", 6), ("M1 con spread costante 25 (seme diverso)", 5)):
        m_syn = VG._synth_m1(seed=seed + wk, weeks=wk)
        if "costante" in label:
            m_syn = VG.M1(m_syn.t, m_syn.o, m_syn.h, m_syn.l, m_syn.c, np.full(m_syn.n, 25.0))
        with tempfile.TemporaryDirectory() as td:
            pth = os.path.join(td, "sint.csv")
            write_csv(m_syn, pth)
            m4 = E.carica(pth)
            m7 = VG.load_m1_csv(pth)
            for tf in (60, 30):
                br = E.costruisci_barre(m4, tf); ind = E.indicatori(br)
                bars7 = VG.aggregate_m1(m7, tf, min_m1=1)
                same_bars = (len(br.t) == len(bars7["time"]) and np.array_equal(br.c, bars7["close"]) and np.array_equal(br.h, bars7["high"])
                             and np.array_equal(br.l, bars7["low"]) and np.array_equal(br.o, bars7["open"]) and np.array_equal(br.t, bars7["time"]))
                rng = np.random.default_rng(seed + tf)
                js = rng.integers(200, br.n - 5, n_trades)
                eng, rec_, nd, nbl, cnt = [], [], 0, 0, {}
                for j in js:
                    side = int(rng.choice([-1, 1]))
                    t = E.simula_trade(m4, br, ind, int(j), side)
                    if not t["eseguito"]:
                        nd += 1
                        spec = None
                        cnt[t["scarto"]] = cnt.get(t["scarto"], 0) + 1
                        continue
                    spec = {"direction": side, "entry_time": int(br.t[j]) + tf, "stop": t["stop"], "targets": t["targets"]}
                    r = VG.simulate_trade(m7, spec, spread_model="executable", max_entry_gap_min=180)
                    pnl_eng = t["R"] * t["rischio"]
                    eng.append({"entry_time": t["entry_time"], "entry_price": t["entry"], "exit_time": t["exit_time"], "exit_price": t["exit"],
                                "exit_reason": MOT.get(t["motivo"], t["motivo"]), "pnl": pnl_eng, "both": t["sl_e_tp_stesso_minuto"]})
                    rec_.append(r)
                    nbl += int(r.get("both_touched", False))
                res = VG.compare_with_engine(eng, rec_, tol=1e-6)
                s_e = VG.summarize_pnls([e["pnl"] for e in eng]); s_r = VG.summarize_pnls([r["pnl"] for r in rec_])
                cs = VG.compare_summary(s_e, s_r)
                both_ok = all((e["both"] == r["both_touched"]) for e, r in zip(eng, rec_))
                motivi = {}
                for e in eng: motivi[e["exit_reason"]] = motivi.get(e["exit_reason"], 0) + 1
                print("[%s] TF=%d: barre identiche A4/A7=%s | eseguiti=%d scartati=%s | %s | %s | stop+target stesso minuto: %d (flag coerenti=%s) | uscite=%s" %
                      (label, tf, same_bars, len(eng), cnt, res.status + " " + res.detail[:150], cs.status, nbl, both_ok, motivi))
                ok_all &= (same_bars and res.passed and cs.passed and both_ok)
    # --- STOP PRIMA DEL TARGET (V07): iniezione di una M1 che tocca stop e target insieme ---
    m_syn = VG._synth_m1(seed=seed + 6, weeks=6)
    with tempfile.TemporaryDirectory() as td:
        pth = os.path.join(td, "sint.csv"); write_csv(m_syn, pth)
        m4 = E.carica(pth); m7 = VG.load_m1_csv(pth)
        br = E.costruisci_barre(m4, 60); ind = E.indicatori(br)
        rng = np.random.default_rng(77)
        n_ok = n_try = 0
        for j in rng.integers(200, br.n - 30, 200):
            if n_try >= 60:
                break
            side = int(rng.choice([-1, 1]))
            t = E.simula_trade(m4, br, ind, int(j), side)
            if not t["eseguito"] or t["exit_m1"] - t["entry_m1"] < 4:
                continue
            i = t["entry_m1"] + 2
            tg = [lv for _, lv in t["targets"]]
            hi = max([t["stop"]] + tg) + 1.0; lo = min([t["stop"]] + tg) - 1.0
            sv = (m4.h[i], m4.l[i], m7._h[i], m7._l[i], m7.h[i], m7.l[i])
            m4.h[i] = hi; m4.l[i] = lo; m7._h[i] = hi; m7._l[i] = lo; m7.h[i] = hi; m7.l[i] = lo
            t2 = E.simula_trade(m4, br, ind, int(j), side)
            r2 = VG.simulate_trade(m7, {"direction": side, "entry_time": int(br.t[j]) + 60, "stop": t2["stop"], "targets": t2["targets"]})
            n_try += 1
            good = (t2["motivo"] == "SL" and t2["sl_e_tp_stesso_minuto"] and r2["exit_reason"] == "stop" and r2["both_touched"]
                    and t2["exit_m1"] == r2["exit_idx"] and abs(t2["R"] * t2["rischio"] - r2["pnl"]) < 1e-6)
            n_ok += good
            m4.h[i], m4.l[i], m7._h[i], m7._l[i], m7.h[i], m7.l[i] = sv
        print("stop-first iniettato: %d/%d trade con M1 che tocca stop e target -> A4 e ricalcolo escono a STOP, stesso minuto e stesso pnl, flag stesso-minuto vero" % (n_ok, n_try))
        ok_all &= (n_try >= 30 and n_ok == n_try)
    print("\nESITO RICALCOLO INDIPENDENTE DEL MOTORE (sintetico): %s" % ("SUPERATO" if ok_all else "FALLITO"))
    return 0 if ok_all else 1


if __name__ == "__main__":
    sys.exit(main())
