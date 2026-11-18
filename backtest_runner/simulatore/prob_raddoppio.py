#!/usr/bin/env python3
# Probabilita storica di raddoppiare (+100% del deposito) prima di perdere il 50%, su finestre mobili, dalle serie giornaliere dei test archiviati.
import csv, sys, collections, datetime as dt, statistics as st, json
f = sys.argv[1]
rows = collections.defaultdict(lambda: collections.defaultdict(float)); dep = {}
src_pref = {}
with open(f, encoding="utf-8-sig") as fh:
    r = csv.reader(fh, delimiter=";"); next(r)
    for s, p, d, v, de in r:
        key = p.split("\\")[0]  # cartella del run
        src_pref.setdefault(key, s)
        if s != src_pref[key] and s < src_pref[key]: continue  # tiene la sorgente piu recente tra le due copie
        if s != src_pref[key]: src_pref[key] = s
        rows[(key, s)][d] += float(v); dep[key] = float(de)
# tieni per ogni run la sorgente piu recente
runs = {}
for (key, s), dd in rows.items():
    if key not in runs or s > runs[key][0]: runs[key] = (s, dd)
def serie(dd, a, b):
    d0 = dt.date.fromisoformat(a.replace(".", "-")); d1 = dt.date.fromisoformat(b.replace(".", "-")); n = (d1 - d0).days + 1
    arr = [0.0] * n
    for k, v in dd.items():
        x = (dt.date(int(k[:4]), int(k[5:7]), int(k[8:10])) - d0).days
        if 0 <= x < n: arr[x] += v
    return arr
def esiti(arr, D, S):
    n = len(arr); out = []
    for s0 in range(n):
        c = 0.0; res = ("nessuno", None)
        for i in range(s0, n):
            c += arr[i]
            if c >= D: res = ("raddoppio", i - s0 + 1); break
            if c <= -S: res = ("stop", i - s0 + 1); break
        out.append((res[0], res[1], n - s0))
    return out
def riepilogo(es):
    n = len(es); a = sum(1 for e in es if e[0] == "raddoppio"); b = sum(1 for e in es if e[0] == "stop")
    lun = [e for e in es if e[2] >= 180]; al = sum(1 for e in lun if e[0] == "raddoppio"); bl = sum(1 for e in lun if e[0] == "stop")
    gg = [e[1] for e in es if e[0] == "raddoppio"]
    return dict(n=n, dbl=a / n, stop=b / n, none=(n - a - b) / n, dbl180=(al / len(lun) if lun else float("nan")), stop180=(bl / len(lun) if lun else float("nan")), med=(st.median(gg) if gg else None))
# raggruppa forex per set e anno
setanni = collections.defaultdict(dict)
for key, (s, dd) in runs.items():
    if key.startswith("R21_"): continue
    parts = key.rsplit("_", 1); setn, y = parts[0], int(parts[1])
    setanni[setn][y] = (dd, dep[key])
RES = {}
for setn, ya in sorted(setanni.items()):
    tot = []; per = {}
    for y, (dd, D0) in sorted(ya.items()):
        es = esiti(serie(dd, "%d.01.01" % y, "%d.12.31" % y), D0, D0 / 2); tot += es; per[y] = riepilogo(es)
    RES[setn] = dict(tot=riepilogo(tot), per=per)
# oro: trio = somma dei tre EA per livello e modello
gold = collections.defaultdict(lambda: collections.defaultdict(float)); gd = {}
for key, (s, dd) in runs.items():
    if not key.startswith("R21_"): continue
    _, m, lv, ea = key.split("_"); 
    for k, v in dd.items(): gold[(m, lv)][k] += v
    gd[(m, lv)] = dep[key]
for (m, lv), dd in sorted(gold.items()):
    D0 = gd[(m, lv)]; es = esiti(serie(dd, "2025.01.01", "2026.10.01"), D0, D0 / 2)
    RES["TRIO_ORO_%s_%s" % (m, lv)] = dict(tot=riepilogo(es), per={})
json.dump(RES, open("prob_raddoppio.json", "w"), indent=1)
def pc(x): return "n.d." if x != x else "%.0f%%" % (100 * x)
print("| Set | Partenze | Raddoppio prima dello stop | Stop prima | Nessuno dei due | Raddoppio (solo partenze con >=180 gg davanti) | Giorni mediani al raddoppio |")
print("|---|---|---|---|---|---|---|")
for k, v in RES.items():
    t = v["tot"]; print("| %s | %d | %s | %s | %s | %s | %s |" % (k, t["n"], pc(t["dbl"]), pc(t["stop"]), pc(t["none"]), pc(t["dbl180"]), t["med"] if t["med"] is not None else "-"))
print()
print("Per anno (raddoppio / stop, tutte le partenze):")
for k, v in RES.items():
    if v["per"]: print(k, " ".join("%d:%s/%s" % (y, pc(p["dbl"]), pc(p["stop"])) for y, p in v["per"].items()))
