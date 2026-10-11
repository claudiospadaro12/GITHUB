#!/usr/bin/env python3
# -*- coding: ascii -*-
"""
finestre_pausa_m5h24.py -- STRUMENTO DI ANALISI DESCRITTIVA, NON PASSATO DAL CANCELLO (11/10/2026), aggiunto dopo il FAIL di forma sul report.
Riscontro: (a) PF_V dell'insieme 07-22 (solo descrizione), (b) uscite delle attraversanti nel weekend, (c) orari delle righe 10018 nei giornali,
(d) le attraversanti con quattro finestre della pausa. Importa gba_ingressi_comuni.py (Bozza, NON passata dal cancello) senza modificarlo.
Uso: python3 -I finestre_pausa_m5h24.py <repo_worktree> <zip_M5H24>
"""
import sys, os, re, zipfile, datetime, collections, importlib.util
repo, zH = sys.argv[1], sys.argv[2]
spec = importlib.util.spec_from_file_location("ic", os.path.join(repo, "backtest_pipeline", "gba_ingressi_comuni.py"))
ic = importlib.util.module_from_spec(spec); spec.loader.exec_module(ic)
c, _ = ic.carica([zH]); H = [dict(v, key=k) for k, v in c["H24"].items()]
D = datetime.date; T = datetime.time; DT = datetime.datetime; TD = datetime.timedelta
def pf(v): return ic.pf(v)
def fmt(ps):
    v = [p["net"] for p in ps]
    return "n %4d  PF_V %6.3f  netto %10.2f" % (len(v), pf(v) if v else float("nan"), sum(v))
print("=== a. insieme 07-22 (ora d'ingresso 07:00-21:59): %s" % fmt([p for p in H if 7 <= p["tin"].hour < 22]))
print("    resto 07-24: %s | notte 00-07: %s" % (fmt([p for p in H if p["tin"].hour >= 7]), fmt([p for p in H if p["tin"].hour < 7])))
def mk(inv, est):
    def w(d):
        (a, b) = inv if d < D(2026, 3, 9) else est
        ad = d + TD(days=a[0]); bd = d + TD(days=b[0])
        return DT.combine(ad, a[1]), DT.combine(bd, b[1])
    return w
FIN = [
    ("repo (23:00-00:05 fino all'08/03; 22:00-23:00 dal 09/03)", mk(((0, T(23, 0)), (1, T(0, 5))), ((0, T(22, 0)), (0, T(23, 0))))),
    ("buco tick (22:55-00:04 prima del 09/03; 21:55-23:00 dopo)", mk(((0, T(22, 55)), (1, T(0, 4))), ((0, T(21, 55)), (0, T(23, 0))))),
    ("trading fermo (21:55-00:05 inverno; 21:55-23:05 estate)", mk(((0, T(21, 55)), (1, T(0, 5))), ((0, T(21, 55)), (0, T(23, 5))))),
    ("larga (22:00-00:05 sempre)", mk(((0, T(22, 0)), (1, T(0, 5))), ((0, T(22, 0)), (1, T(0, 5))))),
]
def attr(p, w):
    d0 = p["tin"].date()
    for k in (-1, 0, 1, 2):
        a, b = w(d0 + TD(days=k))
        if p["tin"] < b and p["tout"] > a:
            return True
    return False
print("=== d. quattro finestre")
sets = {}
for nm, w in FIN:
    s = [p for p in H if attr(p, w)]; r = [p for p in H if not attr(p, w)]
    sets[nm] = set(p["key"] for p in s)
    print("  %-60s attraversanti %s | senza: %s" % (nm, fmt(s), fmt(r)))
base = sets[FIN[0][0]]
for nm in sets:
    print("  stesso insieme delle 28 del repo? %-60s %s (diff: +%d -%d)" % (nm, sets[nm] == base, len(sets[nm] - base), len(base - sets[nm])))
print("=== b. le 28 (regola repo): uscite con giorno della settimana")
for p in sorted([p for p in H if p["key"] in base], key=lambda p: p["tin"]):
    gg = (p["tout"].date() - p["tin"].date()).days
    if gg >= 1 and (p["tout"].date().weekday() in (0, 6) and gg >= 2 or p["tout"].time() >= T(23, 0) and p["tout"].date().weekday() == 6) or gg >= 2:
        print("  %s %s -> %s (%s) %s %.2f" % (p["tranche"], p["tin"], p["tout"], ["lun", "mar", "mer", "gio", "ven", "sab", "dom"][p["tout"].weekday()], p["lato"], p["net"]))
print("  ultima uscita (max ora)/prima: ")
ex = sorted([p for p in H if p["key"] in base], key=lambda p: p["tout"].time())
print("  uscite: min ora %s  max ora %s" % (min(p["tout"].time() for p in H if p["key"] in base), max(p["tout"].time() for p in H if p["key"] in base)))
print("=== c. righe 10018 nei giornali: orario simulato min/max e conteggio per tranche")
z = zipfile.ZipFile(zH)
for nome in sorted(z.namelist()):
    nn = nome.replace("\\", "/")
    if nn.startswith("log/") and nn.endswith(".txt"):
        tr = nn.split("_")[-2]
        ts = []
        for ln in z.read(nome).decode("utf-8", "replace").splitlines():
            if "10018" in ln:
                m = re.search(r"(\d{4})\.(\d{2})\.(\d{2}) (\d{2}):(\d{2}):(\d{2})", ln)
                if m: ts.append(DT(*map(int, m.groups())))
        if ts:
            oraz = sorted(t.time() for t in ts)
            inv = [t for t in ts if t.date() < D(2026, 3, 9)]
            est = [t for t in ts if t.date() >= D(2026, 3, 9)]
            print("  %s: %d righe, %d giorni; ora min %s max %s; prima del 09/03 %d righe (min %s max %s); dal 09/03 %d righe (min %s max %s)" % (
                tr, len(ts), len(set(t.date() for t in ts)), oraz[0], oraz[-1], len(inv), min((t.time() for t in inv), default=None), max((t.time() for t in inv), default=None),
                len(est), min((t.time() for t in est), default=None), max((t.time() for t in est), default=None)))
