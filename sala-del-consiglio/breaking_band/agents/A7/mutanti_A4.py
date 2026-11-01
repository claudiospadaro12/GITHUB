#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""mutanti_A4.py - V19/V20: test di MUTAZIONE su COPIE del motore e dei segnali di A4 (cartella agents/A7/mutanti/<id>/).
Per ogni mutante: copia di agents/A4/*.py, una sostituzione di testo (deve occorrere ESATTAMENTE una volta), poi
  (1) test di A4: test_engine.py, test_signals.py (e test_run.py se --con-test-run);
  (2) la batteria dei pattern piantati di A7 (solo segnali).
Il mutante e UCCISO se almeno un test/verifica fallisce. Gli originali di A4 non vengono toccati. Solo dati sintetici.
Uso: python3 -I mutanti_A4.py [--con-test-run]"""
import os, shutil, subprocess, sys, time
HERE = os.path.dirname(os.path.abspath(__file__))
A4 = os.path.join(HERE, "..", "A4")
OUT = os.path.join(HERE, "mutanti")

M = [  # (id, file, vecchio, nuovo, descrizione)
 ("E01_stop_first", "engine.py", "if sl_hit[k]:                       # SL prima di TP nello stesso minuto", "if sl_hit[k] and not tp_hit[k]:", "TP prima di SL se nello stesso minuto"),
 ("E02_spread_long_ingresso", "engine.py", "entry = float(m1.o[e]) + (sp_e if s == 1 else 0.0)", "entry = float(m1.o[e]) + 0.0", "long entra al bid (spread omesso)"),
 ("E03_spread_short_stop", "engine.py", "sl_hit = (h_s + sp_s) >= stop", "sl_hit = h_s >= stop", "short: stop senza spread"),
 ("E04_spread_short_target", "engine.py", "tp_hit = (l_s + sp_s) <= target", "tp_hit = l_s <= target", "short: target senza spread"),
 ("E05_fill_target_migliorato", "engine.py", "fill = float(target)         # AL LIVELLO (sez. 6.7)", "fill = max(target, float(o_s[k])) if s == 1 else min(target, float(o_s[k] + sp_s[k]))", "fill del target con miglioramento di prezzo"),
 ("E06_fill_stop_senza_gap", "engine.py", "fill = min(stop, float(o_s[k])) if s == 1 else max(stop, float(o_s[k] + sp_s[k]))", "fill = stop", "stop sempre al livello (gap ignorato)"),
 ("E07_lookahead_sma_centrata", "engine.py", "out_m[n - 1:] = w.mean(axis=1)", "out_m[:x.size - n + 1] = w.mean(axis=1)", "LOOK-AHEAD: SMA calcolata sulle n barre SUCCESSIVE"),
 ("E08_lookahead_target_ricalcolato", "engine.py", "v = float(ind.sma20[j + r * m])", "v = float(ind.sma20[min(j + r * m + 1, barre.n - 1)])", "LOOK-AHEAD: target ricalcolato con la barra in corso"),
 ("E09_ingresso_stessa_barra", "engine.py", "e = int(barre.i0[j + 1])", "e = int(barre.i0[j])", "ingresso sulla barra del segnale"),
 ("E10_stop_distanza", "engine.py", "D = stop_atr * atr_j", "D = (stop_atr - 0.5) * atr_j", "stop a 2,5 ATR invece di 3"),
 ("E11_posizione_aperta", "engine.py", "int(barre.i0[j + 1]) <= ultima_uscita:", "int(barre.i0[j + 1]) <= -1:", "nessun filtro 'una posizione alla volta'"),
 ("E12_mkt_rimosso", "engine.py", "passato = (float(m1.o[a]) >= target) if s == 1 else (float(m1.o[a]) + sp_a <= target)", "passato = False", "uscita a mercato su target superato rimossa"),
 ("E13_target_oltre_ingresso", "engine.py", "if (s == 1 and sma_j <= entry) or (s == -1 and sma_j >= entry):", "if False:", "TARGET_OLTRE_INGRESSO non scartato"),
 ("S01_SEQ_off", "signals.py", "c3 = not ep.seq_viol", "c3 = True", "SEQ disattivata"),
 ("S02_cancello_sd_S50", "signals.py", 'g1 = bool(c.sd[u] < c.s50[u]) if prm["SD_GATE_S50"] else True', "g1 = True", "sd<S50 spento"),
 ("S03_lookahead_picco", "signals.py", "p = s + int(np.argmax(v.hi[s:t + 1]))", "p = s + int(np.argmax(v.hi[s:t + 6]))", "LOOK-AHEAD: picco calcolato con 5 barre future"),
 ("S04_I1_off", "signals.py", "i1 = not self._opp(ep)", "i1 = True", "INV: banda opposta mai toccata ignorata"),
 ("S05_impulsiva_ritracciamento", "signals.py", "c1a = ep.zmax <= self.z_imp", "c1a = True", "CONT: candela impulsiva nel ritracciamento ignorata"),
 ("S06_impulsiva_test", "signals.py", "c1b = zt <= self.z_imp", "c1b = True", "CONT: candela del test impulsiva ignorata"),
 ("S07_specchio_rotto", "signals.py", "self.hi, self.lo, self.op, self.cl = -barre.l, -barre.h, -barre.o, -barre.c", "self.hi, self.lo, self.op, self.cl = -barre.l, -barre.h, -barre.o, -barre.c * 1.001", "SIMMETRIA: close dello specchio alterata"),
 ("S08_banda_piatta", "signals.py", 'i3 = bool(pend <= prm["BANDA_TOL_ATR"] * c.atr[u - 1])', "i3 = True", "INV: banda inclinata contro ignorata"),
 ("S09_tocco_precoce", "signals.py", 'if self.var == "CONT" and not ep.consumato and c.tocco_opposta(v, u):', "if False:", "CONT: consumo per tocco precoce rimosso (ciclo di vita)"),
 ("S10_T_MAX", "signals.py", 'if u - ep.p > prm["T_MAX"]:', "if False:", "T_MAX non applicato"),
 ("S11_band_riding", "signals.py", 'if ep.p - ep.s > prm["B6_BARRE"]:', "if False:", "band riding (impulso > 20 barre) non disarma"),
 ("S12_un_segnale_per_episodio", "signals.py", "            ep.stadio = len(self.stadi) - 1\n            ep.consumato = True", "            ep.stadio = len(self.stadi) - 1", "episodio non consumato dopo il segnale"),
 ("S13_B1_soglia", "signals.py", 'b1 = self.W >= prm["B1_W"] * wref[sc]', 'b1 = self.W >= 0.5 * wref[sc]', "B1: bande 'molto aperte' con soglia 0,5"),
 ("S14_sd_lag", "signals.py", 'g2 = bool(c.sd[u] <= c.sd[u - prm["SD_LAG"]])', "g2 = True", "sd<=sd[-3] spento"),
]

def run(cmd, cwd, env, timeout=900):
    t0 = time.time()
    p = subprocess.run(cmd, cwd=cwd, env=env, capture_output=True, text=True, timeout=timeout)
    return p.returncode, (p.stdout + p.stderr)[-400:], time.time() - t0

def main():
    con_run = "--con-test-run" in sys.argv
    os.makedirs(OUT, exist_ok=True)
    env = dict(os.environ); env["PYTHONDONTWRITEBYTECODE"] = "1"
    # controllo di sanita: l'originale passa tutto
    killed = 0; righe = []
    for mid, fname, old, new, desc in M:
        d = os.path.join(OUT, mid)
        if os.path.exists(d):
            shutil.rmtree(d)
        os.makedirs(d)
        for f in os.listdir(A4):
            if f.endswith(".py"):
                shutil.copy(os.path.join(A4, f), d)
        pth = os.path.join(d, fname); src = open(pth).read()
        if src.count(old) != 1:
            righe.append((mid, "ERRORE_MUTAZIONE", "pattern trovato %d volte" % src.count(old), desc)); continue
        open(pth, "w").write(src.replace(old, new))
        res = []
        for t in ["test_engine.py", "test_signals.py"] + (["test_run.py"] if con_run else []):
            rc, tail, dt = run([sys.executable, "-I", t], d, env)
            res.append((t, rc))
        env2 = dict(env); env2["A7_A4DIR"] = d
        rc, tail, dt = run([sys.executable, "-I", os.path.join(HERE, "controlli_A4_sintetici.py"), "--solo-batteria"], HERE, env2)
        res.append(("batteria_A7", rc))
        fails = [t for t, rc in res if rc != 0]
        killed += bool(fails)
        righe.append((mid, "UCCISO" if fails else "SOPRAVVISSUTO", ",".join(fails) if fails else "nessun test lo rileva", desc))
        print("%-34s %-12s %-40s %s" % (mid, righe[-1][1], righe[-1][2], desc), flush=True)
    print("\nMUTANTI UCCISI: %d/%d" % (killed, len(M)))
    return 0

if __name__ == "__main__":
    sys.exit(main())
