#!/usr/bin/env python3
# -*- coding: ascii -*-
# Prova di POTENZA dell'autotest di scheda_simbolo.py: si rompe il codice di proposito (un mutante alla volta)
# e si verifica che l'autotest FALLISCA. Un mutante che sopravvive = un buco nell'autotest.
# Uso: python3 mutazioni_autotest.py  (dalla cartella backtest_pipeline, scrive un file temporaneo accanto)
import os, subprocess, sys
QUI = os.path.dirname(os.path.abspath(__file__))
SRC = os.path.join(QUI, "..", "..", "scheda_simbolo.py")
src = open(SRC).read()
MUT = [
    ("DST NY ignorata", "        out[m] -= 60\n    return out\n\n\ndef verso_utc", "        out[m] -= 0\n    return out\n\n\ndef verso_utc"),
    ("giorno della settimana sfasato", "    wd = (d + 3) % 7                     # 0 = lunedi'", "    wd = (d + 2) % 7                     # 0 = lunedi'"),
    ("true range senza gap", "    pc = np.insert(c[:-1], 0, o[0])\n    return np.maximum(h - l, np.maximum(np.abs(h - pc), np.abs(l - pc)))", "    return h - l"),
    ("server UTC+2", "        return t + 60\n    if orologio == \"vecchio\":", "        return t + 120\n    if orologio == \"vecchio\":"),
    ("zigzag senza soglia", "        thr = rho * av[i]\n        if d == 0:", "        thr = 0.0 * av[i]\n        if d == 0:"),
    ("soglia weekend sbagliata", "SOGLIA_BUCO_WEEKEND = 36 * 60", "SOGLIA_BUCO_WEEKEND = 6 * 60"),
    ("ER non normalizzato", "        er = np.where(path > 0, net / path, np.nan)", "        er = np.where(path > 0, net / (path * 2), np.nan)"),
    ("doppi non tolti", "    keep[1:] = t[1:] != t[:-1]\n    info[\"doppi\"]", "    keep[1:] = True\n    info[\"doppi\"]"),
    ("sessione NY d'estate = inverno", "(\"NY\", (870, 1260), (810, 1200)", "(\"NY\", (870, 1260), (870, 1260)"),
    ("correlazione per posizione", "    comuni, ia, ib = np.intersect1d(ka, kb, return_indices=True)", "    n_ = min(len(ka), len(kb)); comuni = ka[:n_]; ia = np.arange(n_); ib = np.arange(n_)"),
    ("ancora assoluta ignorata", "    q[\"orologio_ok\"] = bool(q[\"orologio_dst_ok\"] and q[\"ancora_inverno\"] and not q[\"orologio_indeciso\"])", "    q[\"orologio_ok\"] = bool(q[\"orologio_dst_ok\"] and not q[\"orologio_indeciso\"])"),
    ("campione corto non indeciso", "    q[\"orologio_indeciso\"] = bool(nw < 40 or ne < 40 or dw < 1.5 or de < 1.5)", "    q[\"orologio_indeciso\"] = False"),
    ("ranking senza finestra comune", "        r[\"finestra_comune\"] = \"SI\" if finestra else \"NO\"", "        r[\"finestra_comune\"] = \"SI\""),
    ("finestra dubbia del cambio orologio non scartata", "        tf_, a = tf_[~dubbia], a[:, ~dubbia]", "        pass"),
    ("cluster a catena (collegamento singolo)", "                v = float(np.mean([M[a, b] for a in gruppi[i] for b in gruppi[j]]))", "                v = float(np.max([M[a, b] for a in gruppi[i] for b in gruppi[j]]))"),
    ("Tokyo trattato come evento con ora legale", "(abs(w - e) <= 5) if ancora_senza_dst(q[\"ancora_inverno\"]) else (abs((w - 60) - e) <= 5)", "(abs((w - 60) - e) <= 5)"),
    ("percentile sbagliato", "        d[\"p%d\" % q] = float(np.percentile(x, q))", "        d[\"p%d\" % q] = float(np.percentile(x, 100 - q))"),
    ("quota di rimbalzo invertita", "rimbalzo_quota=(B / (B + P) if (B + P) else float(\"nan\"))", "rimbalzo_quota=(P / (B + P) if (B + P) else float(\"nan\"))"),
]
tmp = os.path.join(QUI, "_mutante_tmp.py")
vivi, morti = [], []
for nome, a, b in MUT:
    if a not in src:
        print("NON APPLICABILE: %s" % nome); vivi.append(nome + " (non applicabile)"); continue
    open(tmp, "w").write(src.replace(a, b, 1))
    r = subprocess.run([sys.executable, tmp, "--autotest"], capture_output=True, text=True)
    ult = [l for l in r.stdout.splitlines() if "FALLITO" in l]
    if r.returncode == 2 and ult:
        morti.append(nome); print("UCCISO       %-52s %s" % (nome, ult[0][:90]))
    else:
        vivi.append(nome); print("SOPRAVVISSUTO %-51s rc=%d" % (nome, r.returncode))
os.remove(tmp)
print("mutanti uccisi %d su %d; sopravvissuti: %s" % (len(morti), len(MUT), vivi or "nessuno"))
sys.exit(0 if not vivi else 2)
