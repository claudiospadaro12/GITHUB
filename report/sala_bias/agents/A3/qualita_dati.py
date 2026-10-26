#!/usr/bin/env python3
"""Controllo qualita' dati XAUUSD D1 BCM (SALA-BIAS-001, agente A3).
Uso: python3 qualita_dati.py [csv_input] [cartella_output]
Stampa tutto su stdout; scrive weekly_W1.csv e anni_regimi.csv nella cartella output.
Solo libreria standard (nessun numpy)."""
import csv, os, sys, datetime as dt
from collections import defaultdict, Counter

HERE = os.path.dirname(os.path.abspath(__file__))
DEF = "/tmp/claude-0/-home-user-GITHUB/c2d73886-9ef2-5105-8937-d770bc36d6df/scratchpad/lavoro_wt/data/prezzi/XAUUSD_D1_BCM_2004-06-11_2026-10-21.csv"
SRC = sys.argv[1] if len(sys.argv) > 1 else DEF
OUT = sys.argv[2] if len(sys.argv) > 2 else HERE
WD = ["Lun", "Mar", "Mer", "Gio", "Ven", "Sab", "Dom"]

def med(a): a = sorted(a); return a[len(a) // 2]

def sec(t): print("\n" + "=" * 78 + "\n" + t + "\n" + "=" * 78)

# ---------------------------------------------------------------- lettura
rows = []; bad_lines = []
with open(SRC, newline="") as f:
    rd = csv.reader(f, delimiter="\t")
    header = next(rd)
    for n, r in enumerate(rd, start=2):
        try:
            d = dt.datetime.strptime(r[0], "%Y.%m.%d").date()
            o, h, l, c = (float(x) for x in r[1:5])
            tv, v, sp = int(r[5]), int(r[6]), int(r[7])
            rows.append(dict(n=n, d=d, o=o, h=h, l=l, c=c, tv=tv, v=v, sp=sp))
        except Exception as e:
            bad_lines.append((n, r, str(e)))

sec("0. FILE")
print("file:", SRC); print("header:", header); print("righe dati lette:", len(rows), "| righe non parsabili:", len(bad_lines))
for b in bad_lines[:10]: print("  riga non valida", b)

# ---------------------------------------------------------------- 1
sec("1. STRUTTURA: righe, date, duplicati, ordine")
print("righe totali:", len(rows))
print("prima data:", rows[0]["d"], WD[rows[0]["d"].weekday()], "| ultima data:", rows[-1]["d"], WD[rows[-1]["d"].weekday()])
cnt = Counter(r["d"] for r in rows)
dups = [d for d, k in cnt.items() if k > 1]
print("date duplicate:", len(dups), [str(d) for d in sorted(dups)][:20])
unord = [(rows[i - 1]["d"], rows[i]["d"]) for i in range(1, len(rows)) if rows[i]["d"] <= rows[i - 1]["d"]]
print("coppie non in ordine crescente stretto:", len(unord), unord[:10])
print("giorni della settimana (conteggio barre):", {WD[k]: v for k, v in sorted(Counter(r["d"].weekday() for r in rows).items())})

# ---------------------------------------------------------------- 2
sec("2. COERENZA OHLC")
inc = []
for r in rows:
    pr = []
    if min(r["o"], r["h"], r["l"], r["c"]) <= 0: pr.append("prezzo<=0")
    if r["h"] < max(r["o"], r["c"]) - 1e-9: pr.append("high<max(o,c)")
    if r["l"] > min(r["o"], r["c"]) + 1e-9: pr.append("low>min(o,c)")
    if r["h"] < r["l"]: pr.append("high<low")
    if pr: inc.append((r, pr))
print("barre con OHLC incoerente:", len(inc))
for r, pr in inc[:40]: print("  ", r["d"], r["o"], r["h"], r["l"], r["c"], pr)
flat = [r for r in rows if r["h"] == r["l"]]
print("barre piatte (high==low):", len(flat), [str(r["d"]) for r in flat[:10]])
# range anomali (high-low)/close
rg = sorted(((r["h"] - r["l"]) / r["c"], r["d"], r["h"] - r["l"]) for r in rows)
print("range giornaliero (H-L)/C: mediana %.3f%%, p99 %.2f%%" % (100 * rg[len(rg) // 2][0], 100 * rg[int(len(rg) * .99)][0]))
print("5 range piu' ampi:", [(str(d), "%.1f%%" % (100 * x), round(a, 2)) for x, d, a in rg[-5:]])
# decimali
# open vs close precedente (gap)
gaps = []
for i in range(1, len(rows)):
    g = rows[i]["o"] / rows[i - 1]["c"] - 1
    gaps.append((abs(g), g, rows[i]["d"]))
gaps.sort()
print("gap open/close precedente: mediana |g| %.3f%%; top5:" % (100 * gaps[len(gaps) // 2][0]), [(str(d), "%+.2f%%" % (100 * g)) for _, g, d in gaps[-5:]])

# ---------------------------------------------------------------- 3
sec("3. SALTI DI CHIUSURA GIORNO SU GIORNO > 8%")
big = []
for i in range(1, len(rows)):
    ch = rows[i]["c"] / rows[i - 1]["c"] - 1
    if abs(ch) > 0.08: big.append((rows[i]["d"], rows[i - 1]["d"], rows[i - 1]["c"], rows[i]["c"], ch, rows[i]))
print("salti > 8%:", len(big))
for d, pd_, pc, c, ch, r in big:
    print("  %s (prec %s) close %.2f -> %.2f  %+.2f%%  | O %.2f H %.2f L %.2f tickvol %d" % (d, pd_, pc, c, 100 * ch, r["o"], r["h"], r["l"], r["tv"]))
ch_all = sorted((abs(rows[i]["c"] / rows[i - 1]["c"] - 1), rows[i]["d"], rows[i]["c"] / rows[i - 1]["c"] - 1) for i in range(1, len(rows)))
print("per riferimento, i 12 maggiori |var| giornaliere:")
for a, d, s in ch_all[-12:]: print("   ", d, "%+.2f%%" % (100 * s))
print("var >5%:", sum(1 for a, _, _ in ch_all if a > 0.05), " var >4%:", sum(1 for a, _, _ in ch_all if a > 0.04))

# ---------------------------------------------------------------- 4
sec("4. GIORNI MANCANTI, GAP DI CALENDARIO, DOMENICHE")
cal = []
for i in range(1, len(rows)):
    k = (rows[i]["d"] - rows[i - 1]["d"]).days
    if k > 4: cal.append((rows[i - 1]["d"], rows[i]["d"], k))
print("gap di calendario > 4 giorni:", len(cal))
for a, b, k in cal: print("  da %s (%s) a %s (%s): %d giorni" % (a, WD[a.weekday()], b, WD[b.weekday()], k))
dset = set(r["d"] for r in rows)
first, last = rows[0]["d"], rows[-1]["d"]
miss_y = defaultdict(list)
x = first
while x <= last:
    if x.weekday() < 5 and x not in dset: miss_y[x.year].append(x)
    x += dt.timedelta(days=1)
sun_y = Counter(r["d"].year for r in rows if r["d"].weekday() == 6)
sat_y = Counter(r["d"].year for r in rows if r["d"].weekday() == 5)
bar_y = Counter(r["d"].year for r in rows)
wk_y = Counter(r["d"].year for r in rows if r["d"].weekday() < 5)
print("\nanno | barre | feriali(L-V) presenti | feriali mancanti | barre domenica | barre sabato")
for y in range(first.year, last.year + 1):
    print(" %d | %5d | %5d | %4d | %4d | %d" % (y, bar_y[y], wk_y[y], len(miss_y[y]), sun_y[y], sat_y[y]))
print("TOTALE feriali mancanti:", sum(len(v) for v in miss_y.values()), "| barre domenica:", sum(sun_y.values()), "| barre sabato:", sum(sat_y.values()))
print("\nferiali mancanti per anno (date; ricorrenze tipo 25/12 e 1/1 evidenziate):")
fest = Counter()
for y in sorted(miss_y):
    ds = miss_y[y]
    fe = [d for d in ds if (d.month, d.day) in ((12, 25), (1, 1))]
    for d in fe: fest[(d.month, d.day)] += 1
    print(" %d: %d  %s" % (y, len(ds), ", ".join(d.strftime("%m-%d") for d in ds)))
print("mancanze su 25/12 e 1/1 (feste: normali):", dict(fest))
# domeniche: confronto tickvol
sun = [r for r in rows if r["d"].weekday() == 6]
if sun:
    tvs = sorted(r["tv"] for r in sun)
    print("\ndomeniche: n=%d, tickvol mediana %d, min %d, max %d" % (len(sun), tvs[len(tvs) // 2], tvs[0], tvs[-1]))
    wkd = sorted(r["tv"] for r in rows if r["d"].weekday() < 5 and r["d"].year >= 2010)
    print("feriali>=2010 tickvol mediana:", wkd[len(wkd) // 2])
    # ultima/prima domenica
    print("prima domenica:", sun[0]["d"], "| ultima domenica:", sun[-1]["d"])
    print("domeniche per anno:", dict(sorted(sun_y.items())))
    # domenica con lunedi' successivo mancante / venerdi' precedente mancante
    sun_alone = [r["d"] for r in sun if (r["d"] + dt.timedelta(days=1)) not in dset]
    print("domeniche senza barra del lunedi' successivo:", len(sun_alone), [str(d) for d in sun_alone[:15]])
    # range domenica rispetto al lunedi
    rr = []
    for r in sun:
        m = next((q for q in rows if q["d"] == r["d"] + dt.timedelta(days=1)), None)
        if m: rr.append(((r["h"] - r["l"]) / r["c"], (m["h"] - m["l"]) / m["c"]))
    if rr:
        a = sorted(x for x, _ in rr); b = sorted(y for _, y in rr)
        print("range medio domenica %.3f%% vs lunedi' seguente %.3f%%" % (100 * a[len(a) // 2], 100 * b[len(b) // 2]))
sat = [r for r in rows if r["d"].weekday() == 5]
print("barre di sabato:", [str(r["d"]) for r in sat][:20])

# --- 4b. classificazione dei feriali mancanti
def easter(y):
    a = y % 19; b = y // 100; c = y % 100; d_ = b // 4; e = b % 4; f = (b + 8) // 25; g = (b - f + 1) // 3
    h = (19 * a + b - d_ - g + 15) % 30; i = c // 4; k = c % 4; l = (32 + 2 * e + 2 * i - h - k) % 7
    m = (a + 11 * h + 22 * l) // 451; mo = (h + l - 7 * m + 114) // 31; da = (h + l - 7 * m + 114) % 31 + 1
    return dt.date(y, mo, da)
allmiss = sorted(d for v in miss_y.values() for d in v)
cls = defaultdict(list)
for d in allmiss:
    if (d.month, d.day) in ((12, 25), (1, 1)): cls["Natale/Capodanno"].append(d)
    elif d == easter(d.year) - dt.timedelta(days=2): cls["Venerdi Santo"].append(d)
    else: cls["altro"].append(d)
print("\nclassificazione dei %d feriali mancanti:" % len(allmiss), {k: len(v) for k, v in cls.items()})
alt = cls["altro"]
print("  'altro' fino al 2006 (%d; quasi tutte festivita' USA: Thanksgiving, Presidents/Memorial/Labor Day, 4 luglio...):" % sum(1 for d in alt if d.year <= 2006), [str(d) for d in alt if d.year <= 2006])
print("  'altro' dal 2007 (%d, da considerare buchi/chiusure non spiegate):" % sum(1 for d in alt if d.year >= 2007), [str(d) for d in alt if d.year >= 2007])

# --- 4c. regime delle barre di domenica
print("\nBARRE DI DOMENICA, struttura nel tempo")
ghost = [r for r in sun if r["tv"] <= 50]
print("domeniche 'fantasma' (tickvol<=50, quasi sempre piatte H=L): %d per anno %s" % (len(ghost), dict(sorted(Counter(r["d"].year for r in ghost).items()))))
gh_gap = []
for r in ghost:
    i = next(k for k, q in enumerate(rows) if q["d"] == r["d"])
    if i > 0 and i + 1 < len(rows):
        gh_gap.append((abs(r["o"] / rows[i - 1]["c"] - 1), abs(rows[i + 1]["o"] / r["c"] - 1)))
if gh_gap:
    print("   su queste: |open domenica / close venerdi' -1| mediano %.3f%% ; |open lunedi' / close domenica -1| mediano %.3f%%"
          % (100 * med([a for a, _ in gh_gap]), 100 * med([b for _, b in gh_gap])))
    print("   => il gap del weekend sta nel LUNEDI' (non nella domenica): per quegli anni 'open della settimana' = prezzo del venerdi', non il vero open di lunedi'")
sun_dates = set(r["d"] for r in sun)
absent = []
x = date0 = dt.date(2007, 1, 7)
while x <= rows[-1]["d"]:
    if x.weekday() == 6 and x not in sun_dates and (x + dt.timedelta(days=1)) in dset: absent.append(x)
    x += dt.timedelta(days=1)
blocks = []
for d in absent:
    if blocks and (d - blocks[-1][1]).days <= 7 * 2: blocks[-1][1] = d; blocks[-1][2] += 1
    else: blocks.append([d, d, 1])
print("domeniche ASSENTI (con lunedi' presente) dal 2007: %d, raggruppate in blocchi (inizio, fine, n):" % len(absent))
for a, b, n in blocks: print("   %s -> %s  n=%d" % (a, b, n))
print("   (blocchi corti = per lo piu festivita (Natale/Capodanno/Pasqua) ma anche buchi isolati (2007-05-20, 2012-03-11/18, 2015-01-18); blocco 2010-12-19..2011-01-09 = 4 domeniche; i due blocchi lunghi 2024-10..2025-03 e 2025-11..2026-03 sono invernali: ROTTURA STRUTTURALE")
print("    compatibile con server UTC+1 fisso: riapertura oro 22:00 UTC (estate) = 23:00 server domenica -> barra domenica; 23:00 UTC (inverno) = 00:00 lunedi' -> nessuna barra.")
print("    Prima di ott-2024 la domenica c'era tutto l'anno => in quel periodo il feed/orario del server era diverso. Ipotesi non verificabile dal solo file.)")
# gap venerdi' -> prima barra dopo il weekend
print("gap |open prima barra post-weekend / close venerdi' -1| per periodo:")
for y0, y1 in ((2004, 2009), (2010, 2019), (2020, 2023), (2024, 2026)):
    g = sorted(abs(rows[i]["o"] / rows[i - 1]["c"] - 1) for i in range(1, len(rows))
               if rows[i - 1]["d"].weekday() == 4 and rows[i]["d"].weekday() in (6, 0) and y0 <= rows[i]["d"].year <= y1)
    print("   %d-%d: n=%d mediana %.3f%% p90 %.3f%%" % (y0, y1, len(g), 100 * g[len(g) // 2], 100 * g[int(len(g) * .9)]))
print("last bar:", rows[-1]["d"], "| il file e' stato salvato il", dt.datetime.fromtimestamp(os.path.getmtime(SRC)).strftime("%Y-%m-%d %H:%M"), "(ora locale macchina): se la barra dell'ultimo giorno e' stata scaricata prima della chiusura D1 del server, e' PARZIALE.")
# giorni feriali con barra ma tickvol molto basso (barre parziali/festive)
low_tv = [r for r in rows if r["d"].weekday() < 5 and r["tv"] < 100]
print("feriali con tickvol < 100:", len(low_tv), [(str(r["d"]), r["tv"]) for r in low_tv[:15]])

# ---------------------------------------------------------------- 5
sec("5. TICKVOL")
z = [r for r in rows if r["tv"] == 0]
print("tickvol == 0:", len(z), [str(r["d"]) for r in z[:20]])
neg = [r for r in rows if r["tv"] < 0]; print("tickvol < 0:", len(neg))
print("colonna VOL: valori distinti", sorted(set(r["v"] for r in rows))[:10])
print("anno | mediana tickvol | min | max  (solo L-V)")
for y in range(first.year, last.year + 1):
    t = [r["tv"] for r in rows if r["d"].year == y and r["d"].weekday() < 5]
    if t: print(" %d | %8d | %7d | %8d" % (y, med(t), min(t), max(t)))
mt = med([r["tv"] for r in rows])
print("barre con tickvol < 5% della mediana annua (feriali):")
byyear = defaultdict(list)
for r in rows:
    if r["d"].weekday() < 5: byyear[r["d"].year].append(r["tv"])
medy = {y: med(v) for y, v in byyear.items()}
low = [r for r in rows if r["d"].weekday() < 5 and r["tv"] < 0.05 * medy[r["d"].year]]
print("  n =", len(low), [(str(r["d"]), r["tv"]) for r in low[:20]])
# rapporto tickvol/range: barre con range>0 ma tickvol minimo
sus = [r for r in rows if r["tv"] <= 3]
print("barre con tickvol <= 3:", len(sus), [(str(r["d"]), r["tv"]) for r in sus[:10]])

# ---------------------------------------------------------------- 6
sec("6. SPREAD DEL FILE")
sc = Counter(r["sp"] for r in rows)
print("valori distinti di spread:", len(sc), "| top 15 (valore:conteggio):", sc.most_common(15))
print("anno | n | spread min | mediana | max | n con spread=0")
for y in range(first.year, last.year + 1):
    s = [r["sp"] for r in rows if r["d"].year == y]
    if s: print(" %d | %3d | %3d | %3d | %4d | %d" % (y, len(s), min(s), med(s), max(s), sum(1 for v in s if v == 0)))
zs = [r for r in rows if r["sp"] == 0]
print("barre con spread == 0:", len(zs), "| ultima:", zs[-1]["d"] if zs else None)
chg = [(rows[i]["d"], rows[i - 1]["sp"], rows[i]["sp"]) for i in range(1, len(rows)) if rows[i]["sp"] != rows[i - 1]["sp"]]
print("cambi di valore dello spread tra barre consecutive:", len(chg))
print("unita': spread in 'points' MT5; XAUUSD 2 decimali -> 16 = 0.16 USD se point=0.01 (da confermare sul broker)")
print("NB: e' lo spread dell'ULTIMA barra/ora di chiusura, non uno spread medio storico: non usarlo per costi di backtest storici.")

# ---------------------------------------------------------------- 7
sec("7. COSTRUZIONE W1 DA D1")
print("""REGOLA: settimana ISO-like = barre con data da lunedi a venerdi della stessa settimana;
una barra di DOMENICA (D1 del server UTC+1 con la sera di domenica) e' attribuita alla settimana
che INIZIA il lunedi' successivo (data +1 giorno). Motivo: la sessione dell'oro riapre la domenica sera
(~22:00 UTC = 23:00 server), quindi quelle ore sono l'inizio della settimana di trading successiva;
la barra di domenica contiene solo il gap/apertura (ore), non appartiene alla settimana precedente che
si e' chiusa venerdi'. Una barra di SABATO (se esistesse) sarebbe attribuita al lunedi' successivo come
la domenica. Etichetta della settimana = data del lunedi' (week_start).
Open = open della prima barra, close = close dell'ultima, high/low = estremi, tickvol = somma.""")
def wstart(d):
    if d.weekday() >= 5: d = d + dt.timedelta(days=7 - d.weekday())   # sab/dom -> lunedi' dopo
    return d - dt.timedelta(days=d.weekday())
weeks = defaultdict(list)
for r in rows: weeks[wstart(r["d"])].append(r)
W = []
for ws in sorted(weeks):
    g = weeks[ws]
    W.append(dict(ws=ws, o=g[0]["o"], h=max(x["h"] for x in g), l=min(x["l"] for x in g), c=g[-1]["c"],
                  tv=sum(x["tv"] for x in g), nb=len(g), first=g[0]["d"], last=g[-1]["d"],
                  sun=sum(1 for x in g if x["d"].weekday() == 6), nwk=sum(1 for x in g if x["d"].weekday() < 5)))
os.makedirs(OUT, exist_ok=True)
with open(os.path.join(OUT, "weekly_W1.csv"), "w", newline="") as f:
    w = csv.writer(f, delimiter=",", lineterminator="\n")
    w.writerow(["week_start", "open", "high", "low", "close", "tickvol", "n_barre_D1", "n_feriali", "ha_domenica", "prima_barra", "ultima_barra"])
    for x in W:
        w.writerow([x["ws"], "%.2f" % x["o"], "%.2f" % x["h"], "%.2f" % x["l"], "%.2f" % x["c"], x["tv"], x["nb"], x["nwk"], x["sun"], x["first"], x["last"]])
print("settimane scritte in weekly_W1.csv:", len(W))
print("prima settimana:", W[0]["ws"], "(n_barre %d)" % W[0]["nb"], "| ultima:", W[-1]["ws"], "(n_barre %d, ultima barra %s)" % (W[-1]["nb"], W[-1]["last"]))
print("distribuzione n. feriali per settimana:", dict(sorted(Counter(x["nwk"] for x in W).items())))
print("settimane con 5 feriali:", sum(1 for x in W if x["nwk"] == 5), "| con <5:", sum(1 for x in W if x["nwk"] < 5), "| con 0 feriali:", sum(1 for x in W if x["nwk"] == 0))
print("settimane con barra di domenica:", sum(1 for x in W if x["sun"]))
print("settimane con 0 domeniche per anno (post-2010 per capire il regime):", dict(sorted(Counter(x["ws"].year for x in W if not x["sun"]).items())))
inc_w = [x for x in W if x["h"] < max(x["o"], x["c"]) or x["l"] > min(x["o"], x["c"])]
print("W1 con OHLC incoerente:", len(inc_w))
short = [x for x in W if x["nwk"] < 5]
print("settimane con meno di 5 feriali (elenco primi 25):", [(str(x["ws"]), x["nwk"]) for x in short[:25]])
cw = sorted((abs(W[i]["c"] / W[i - 1]["c"] - 1), W[i]["ws"], W[i]["c"] / W[i - 1]["c"] - 1) for i in range(1, len(W)))
print("5 maggiori |var| settimanali di chiusura:", [(str(d), "%+.1f%%" % (100 * s)) for _, d, s in cw[-5:]])
last_w = W[-1]
print("ULTIMA settimana (%s) puo' essere incompleta: ultima barra %s (%s)" % (last_w["ws"], last_w["last"], WD[last_w["last"].weekday()]))
# W1 completa: settimane ove 5 feriali
# ---------------------------------------------------------------- 8
sec("8. RENDIMENTI ANNUALI 2005-2025 E REGIME")
print("rendimento = close ultima barra dell'anno / close ultima barra anno precedente - 1")
print("regime: LONG se >= +10%; SHORT se <= -5%; altrimenti LATERALE\n")
lastbar = {}
for r in rows: lastbar[r["d"].year] = r
res = []
for y in range(2005, 2026):
    a, b = lastbar[y - 1], lastbar[y]
    ret = b["c"] / a["c"] - 1
    reg = "LONG" if ret >= 0.10 else ("SHORT" if ret <= -0.05 else "LATERALE")
    res.append((y, a["d"], a["c"], b["d"], b["c"], ret, reg))
with open(os.path.join(OUT, "anni_regimi.csv"), "w", newline="") as f:
    w = csv.writer(f, lineterminator="\n")
    w.writerow(["anno", "data_close_prec", "close_prec", "data_close_fine", "close_fine", "rendimento_pct", "regime", "ultima_barra_e_domenica"])
    for y, da, ca, db, cb, ret, reg in res:
        w.writerow([y, da, "%.2f" % ca, db, "%.2f" % cb, "%.2f" % (100 * ret), reg, int(db.weekday() == 6)])
print("anno | close prec (data)         | close fine (data)         | rend %  | regime")
for y, da, ca, db, cb, ret, reg in res:
    print(" %d | %9.2f (%s %s) | %9.2f (%s %s) | %+7.2f | %s" % (y, ca, da, WD[da.weekday()], cb, db, WD[db.weekday()], 100 * ret, reg))
print("conteggio regimi:", dict(Counter(r[6] for r in res)))
print("anni con ultima barra non-feriale o prima del 28/12 (data di fine anno 'anomala'):", [(r[0], str(r[3])) for r in res if r[3].weekday() >= 5 or r[3] < dt.date(r[0], 12, 27)])
print("anni con rendimento entro 1.5 pt% da una soglia (sensibili a +/-1 barra):", [(r[0], "%+.2f" % (100 * r[5])) for r in res if abs(r[5] - .10) < .015 or abs(r[5] + .05) < .015])
print("ultimo anno disponibile nel file:", rows[-1]["d"].year, "(parziale: 2026 non e' classificato; close fine 2025 =", "%.2f" % lastbar[2025]["c"], ", ultimo close =", "%.2f" % rows[-1]["c"], ", YTD %+.1f%%)" % (100 * (rows[-1]["c"] / lastbar[2025]["c"] - 1)))
# sensibilita': usare solo barre L-V per la chiusura di fine anno
print("\nSensibilita' del regime alla scelta della barra di fine anno (stessa soglia):")
idx = {r["d"]: i for i, r in enumerate(rows)}
def cl(ret): return "LONG" if ret >= 0.10 else ("SHORT" if ret <= -0.05 else "LATERALE")
flips = []
for y, da, ca, db, cb, ret, reg in res:
    ia, ib = idx[da], idx[db]
    alts = {}
    for sa in (-1, 0, 1):
        for sb in (-1, 0, 1):
            if sa == 0 and sb == 0: continue
            alts[(sa, sb)] = rows[ib + sb]["c"] / rows[ia + sa]["c"] - 1
    rg = sorted(set(cl(v) for v in alts.values()) | {reg})
    mn, mx = min(alts.values()), max(alts.values())
    if len(rg) > 1: flips.append(y)
    print("   %d: base %+.2f%% %s | spostando di +/-1 barra fine/inizio: da %+.2f%% a %+.2f%% -> regimi possibili %s" % (y, 100 * ret, reg, 100 * mn, 100 * mx, rg))
print("anni il cui regime cambia con +/-1 barra:", flips)
print("anni 'LONG' per soglia: la soglia +10%% e' superata da %d anni su 21; mediana rendimento %+.1f%%" % (sum(1 for r in res if r[5] >= .10), 100 * med([r[5] for r in res])))
print("\nFINE")
