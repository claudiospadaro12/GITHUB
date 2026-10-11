#!/usr/bin/env python3
# -*- coding: ascii -*-
"""
analisi_m5h24.py -- STRUMENTO DI ANALISI DESCRITTIVA, NON PASSATO DAL CANCELLO (11/10/2026).
Lotto GBA R2M5H24 (M5 a 24 ore). NON produce esiti: gli esiti E1/E2/E3 sono quelli di leggi_gba_r0.py (9CD02D2A) applicati alla lettera.
Riusa SENZA MODIFICARLE le funzioni di backtest_pipeline/gba_ingressi_comuni.py (parser indipendente dei report .htm).
Uso: python3 -I analisi_m5h24.py <repo_worktree> <zip_M5H24> <zip_NOTTEM5>
"""
import sys, os, re, zipfile, random, datetime, importlib.util, collections

repo, zH, zN = sys.argv[1], sys.argv[2], sys.argv[3]
spec = importlib.util.spec_from_file_location("ic", os.path.join(repo, "backtest_pipeline", "gba_ingressi_comuni.py"))
ic = importlib.util.module_from_spec(spec)
spec.loader.exec_module(ic)

cH, infoH = ic.carica([zH])
cN, infoN = ic.carica([zN])
H = cH["H24"]
N = cN["M5"]
TR = ["T1", "T2", "T3"]
W = print


def pf(v):
    return ic.pf(v)


def st(pos):
    v = [p["net"] for p in pos]
    n = len(v)
    return n, (pf(v) if n else float("nan")), sum(v), (sum(v) / n if n else float("nan"))


def fmt(pos):
    n, p, s, m = st(pos)
    return "n %4d  PF_V %6.3f  netto %10.2f  medio %8.2f" % (n, p, s, m)


Hl = [dict(v, key=k) for k, v in H.items()]
Nl = [dict(v, key=k) for k, v in N.items()]

W("=== A. COERENZA col lettore: n, netto, PF_V per tranche e totale (parser indipendente del tool ingressi_comuni)")
for r in infoH:
    W("  passata H24 %s: deal %d posizioni %d aperte a fine %d costo imputato %s chiavi duplicate %d" % (r[1], r[2], r[3], r[4], r[5], r[6]))
for t in TR:
    W("  H24 %s  %s" % (t, fmt([p for p in Hl if p["tranche"] == t])))
W("  H24 TOT %s" % fmt(Hl))
W("  (lettore: T1 336 PF_V 0.90 | T2 343 0.87 | T3 381 0.95 | tot 1060 PF_V 0.918 netto -40072)")
for t in TR:
    W("  NOTTEM5 %s  %s" % (t, fmt([p for p in Nl if p["tranche"] == t])))
W("  NOTTEM5 TOT %s" % fmt(Nl))
W("  (lettore ancora: 93 / 97 / 113 ; tot 303 PF_V 1.325 netto 37319)")

W("")
W("=== B. FASCE (ora server del deal d'ingresso) - controllo contro la tabella S6 del lettore")
FASCE = [(0, 7, "asia"), (7, 12, "europa"), (12, 14, "pausa"), (14, 17, "USA apertura"), (17, 22, "USA pomeriggio"), (22, 24, "rollover")]
for a, b, nm in FASCE:
    sel = [p for p in Hl if a <= p["tin"].hour < b]
    per = " | ".join("%s n %3d PF %5.2f netto %9.0f" % (t, *[st([p for p in sel if p["tranche"] == t])[i] for i in (0, 1, 2)]) for t in TR)
    W("  %-15s %02d-%02d  %s  || %s" % (nm, a, b, fmt(sel), per))

W("")
W("=== C. NOTTE (00-07) CONTRO RESTO (07-24): SOLO DESCRIZIONE (il resto 07-24 NON e' l'unione 07-22 della prova: include 12 op. rollover)")
for lab, f in (("notte 00-07", lambda p: p["tin"].hour < 7), ("resto 07-24", lambda p: p["tin"].hour >= 7), ("giorno 07-22 [solo conteggio n/netto]", lambda p: 7 <= p["tin"].hour < 22)):
    for t in ["TOT"] + TR:
        sel = [p for p in Hl if f(p) and (t == "TOT" or p["tranche"] == t)]
        n, p_, s, m = st(sel)
        if lab.startswith("giorno"):
            W("  %-38s %-3s n %4d  netto %10.2f  medio %8.2f" % (lab, t, n, s, m))
        else:
            W("  %-38s %-3s %s" % (lab, t, fmt(sel)))
tot = sum(p["net"] for p in Hl)
W("  somma netto notte + resto = %.2f (totale H24 %.2f)" % (sum(p["net"] for p in Hl if p["tin"].hour < 7) + sum(p["net"] for p in Hl if p["tin"].hour >= 7), tot))

W("")
W("=== D. INGRESSI COMUNI con R2NOTTEM5 (chiave = tranche, data-ora server del deal d'ingresso, lato) - per le sole barre NOTTE (ingresso 00:00-06:59) di H24")
Hn = {k: v for k, v in H.items() if k[1].hour < 7}
com, sA, sB = ic.confronta("R2NOTTEM5", "H24_notte", N, Hn, TR)
ND = len(Hn)
W("  notte di H24: %d ingressi (R2NOTTEM5: %d)" % (ND, len(N)))
# ingressi di H24 prima delle 07 ma NON in R2NOTTEM5 - e viceversa: spiegazione descrittiva (posizione aperta da ore diurne?)
W("  --- solo-R2NOTTEM5 (REMOVED in H24): per ogni caso, c'era in H24 una posizione aperta (entrata prima) che occupava la finestra? ")
Hall = sorted(Hl, key=lambda p: (p["tranche"], p["tin"]))
def aperta_h24(tr, t):
    for p in Hall:
        if p["tranche"] == tr and p["tin"] < t < p["tout"]:
            return p
    return None
spieg = collections.Counter()
for k in sorted(sA):
    tr, t, lato = k
    q = aperta_h24(tr, t)
    if q is None:
        spieg["nessuna posizione H24 aperta a quell'istante (sequenza divergente prima)"] += 1
    else:
        spieg["posizione H24 aperta, entrata alle %02d" % q["tin"].hour if q["tin"].hour >= 7 else "posizione H24 aperta, entrata di notte (%02d)" % q["tin"].hour] += 0
        spieg["occupata da posizione H24 entrata %s" % ("di giorno/sera (>=07)" if q["tin"].hour >= 7 else "di notte (<07)")] += 1
for kk, vv in sorted(spieg.items()):
    if vv:
        W("    %-80s %d" % (kk, vv))
W("  --- bootstrap per GIORNO (5.000, seed 12345) del delta PF_V sugli ingressi COMUNI (H24_notte - R2NOTTEM5, appaiato)")
if len(com) >= 2:
    r = ic.boot_delta(N, Hn, com)
    W("  comuni %d giorni %d delta %+.4f sd %.4f [p2,5 %+.4f ; p97,5 %+.4f] P(delta<=0) %.3f" % (len(com), r["giorni"], r["oss"], r["sd"], r["p025"], r["p975"], r["p_le0"]))

W("")
W("=== E. POSIZIONI APERTE DURANTE LA PAUSA GIORNALIERA DEI PREZZI (regola del repo: buco 23:00-00:05 server fino all'08/03/2026, 22:00-23:00 dal 09/03)")
def buco(d):
    # il buco che riguarda la sera del giorno d (data di calendario di d, ora server)
    if d < datetime.date(2026, 3, 9):
        return (datetime.datetime.combine(d, datetime.time(23, 0)), datetime.datetime.combine(d + datetime.timedelta(days=1), datetime.time(0, 5)))
    return (datetime.datetime.combine(d, datetime.time(22, 0)), datetime.datetime.combine(d, datetime.time(23, 0)))
def attraversa(p):
    d0 = p["tin"].date()
    for d in (d0 - datetime.timedelta(days=1), d0, d0 + datetime.timedelta(days=1), d0 + datetime.timedelta(days=2)):
        a, b = buco(d)
        if p["tin"] < b and p["tout"] > a:
            return True
    return False
def attraversa_largo(p):
    # contro-esempio sulla regola: UNA qualunque delle due finestre (22:00-23:00 o 23:00-00:05) in OGNI data
    d0 = p["tin"].date()
    for d in (d0 - datetime.timedelta(days=1), d0, d0 + datetime.timedelta(days=1), d0 + datetime.timedelta(days=2)):
        for (a, b) in ((datetime.datetime.combine(d, datetime.time(22, 0)), datetime.datetime.combine(d, datetime.time(23, 0))),
                       (datetime.datetime.combine(d, datetime.time(23, 0)), datetime.datetime.combine(d + datetime.timedelta(days=1), datetime.time(0, 5)))):
            if p["tin"] < b and p["tout"] > a:
                return True
    return False
for lab, fn in (("regola del repo", attraversa), ("finestra LARGA 22:00-00:05 sempre (contro-esempio)", attraversa_largo)):
    W("  [%s]" % lab)
    for t in ["TOT"] + TR:
        sel = [p for p in Hl if fn(p) and (t == "TOT" or p["tranche"] == t)]
        rest = [p for p in Hl if (not fn(p)) and (t == "TOT" or p["tranche"] == t)]
        W("    %-3s attraversano: %s | senza di loro: %s" % (t, fmt(sel) if sel else "n 0", fmt(rest)))
sel = sorted([p for p in Hl if attraversa(p)], key=lambda p: p["tin"])
W("  posizioni attraversanti (regola del repo), una per riga:")
for p in sel:
    W("      %s %s -> %s %-4s netto %10.2f  uscita '%s'  durata %s" % (p["tranche"], p["tin"], p["tout"], p["lato"], p["net"], p["cmt_out"], p["tout"] - p["tin"]))
# giorni con retcode 10018 nei giornali
def log_giorni(zp, pref):
    z = zipfile.ZipFile(zp)
    out = {}
    for nome in z.namelist():
        nn = nome.replace("\\", "/")
        if nn.startswith("log/") and nn.endswith(".txt"):
            tr = nn.split("_")[-2]
            txt = z.read(nn).decode("utf-8", "replace") if False else z.read(nome).decode("utf-8", "replace")
            gg = collections.Counter()
            for ln in txt.splitlines():
                if "10018" in ln:
                    m = re.search(r"(\d{4})\.(\d{2})\.(\d{2}) (\d{2}):\d{2}:\d{2}", ln)
                    if m:
                        gg[(m.group(1) + "-" + m.group(2) + "-" + m.group(3))] += 1
            out[tr] = gg
    return out
lg = log_giorni(zH, "H24")
for tr in TR:
    W("  giornale %s: righe con retcode 10018: %d in %d giorni: %s" % (tr, sum(lg[tr].values()), len(lg[tr]), dict(sorted(lg[tr].items()))))
dd_att = set(str(p["tin"].date()) for p in sel)
W("  contro-esempio: giorni con 10018 nel giornale che NON hanno una posizione 'attraversante' per la regola (data d'ingresso o d'uscita nel giorno/seguente):")
for tr in TR:
    for g in sorted(lg[tr]):
        gd = datetime.date.fromisoformat(g)
        hit = any((p["tranche"] == tr and attraversa(p) and (p["tin"].date() in (gd, gd - datetime.timedelta(days=1)) or p["tout"].date() in (gd, gd + datetime.timedelta(days=1)))) for p in Hl)
        W("    %s %s: %s" % (tr, g, "coperto da posizione attraversante" if hit else "NON coperto (ordine rifiutato / altro)"))

W("")
W("=== F. BOOTSTRAP PER GIORNO del PF_V (5.000, seed 12345; giorno = giorno server dell'ingresso). DESCRITTIVO: leggi_gba_r0.py non lo stampa")
def boot_pf(pos, nb=5000, seed=12345):
    per = collections.OrderedDict()
    for p in sorted(pos, key=lambda p: p["tin"]):
        per.setdefault((p["tranche"], p["tin"].date()), []).append(p["net"])
    gs = list(per)
    rng = random.Random(seed)
    rs = []
    for _ in range(nb):
        v = []
        for _i in gs:
            v += per[gs[rng.randrange(len(gs))]]
        rs.append(pf(v))
    rs.sort()
    return len(gs), rs[int(0.025 * nb)], rs[int(0.975 * nb) - 1], sum(1 for x in rs if x >= 1.0) / nb
for lab, pos in (("H24 totale", Hl), ("H24 senza attraversanti(regola repo)", [p for p in Hl if not attraversa(p)]), ("H24 fascia asia 00-07", [p for p in Hl if p["tin"].hour < 7]),
                 ("H24 resto 07-24", [p for p in Hl if p["tin"].hour >= 7]), ("R2NOTTEM5 totale (ancora)", Nl)):
    g, lo, hi, pg = boot_pf(pos)
    n, p_, s, m = st(pos)
    W("  %-40s n %4d PF_V %.3f giorni con ingressi %3d  IC95 [%.3f ; %.3f]  P(PF>=1) %.3f" % (lab, n, p_, g, lo, hi, pg))
for t in TR:
    pos = [p for p in Hl if p["tranche"] == t]
    g, lo, hi, pg = boot_pf(pos)
    W("  H24 %-35s n %4d PF_V %.3f giorni %3d  IC95 [%.3f ; %.3f]" % (t, len(pos), st(pos)[1], g, lo, hi))

W("")
W("=== G. CONCENTRAZIONE (descrizione): migliori/peggiori operazioni, vita, SL")
v = sorted([p["net"] for p in Hl], reverse=True)
W("  5 migliori: %s | somma %.0f | netto senza le 5 migliori %.0f | gross profit %.0f gross loss %.0f" % ([round(x) for x in v[:5]], sum(v[:5]), sum(v) - sum(v[:5]), sum(x for x in v if x > 0), sum(x for x in v if x < 0)))
W("  5 peggiori: %s" % [round(x) for x in v[-5:]])

W("")
W("=== H. MOTIVO D'USCITA (commento deal out) per H24")
mot = lambda c: "sl" if c.lower().startswith("sl") else ("tp" if c.lower().startswith("tp") else (c or "a mercato(commento vuoto)"))
cm = collections.defaultdict(list)
for p in Hl:
    cm[mot(p["cmt_out"])].append(p["net"])
for k_, v_ in sorted(cm.items(), key=lambda x: -len(x[1])):
    W("  %-30s n %4d  netto %10.2f  PF %6.3f" % (k_, len(v_), sum(v_), pf(v_)))

W("")
W("=== I. I 7 INGRESSI DI R2NOTTEM5 CHE H24 NON HA (solo-R2NOTTEM5): chi li occupa, che rango hanno, e CONTRO-ESEMPIO (sorteggio casuale di 7 su 303)")
com_, sA_, sB_ = ic.scomponi(N, Hn)
Nrank = sorted(Nl, key=lambda p: -p["net"])
rk = {p["key"]: i + 1 for i, p in enumerate(Nrank)}
for k in sorted(sA_):
    tr, t, lato = k
    q = None
    for p in Hall:
        if p["tranche"] == tr and p["tin"] < t < p["tout"]:
            q = p
    W("  %s %s %-4s netto in R2NOTTEM5 %9.2f (rango %3d su 303) | in H24 occupata da posizione %s -> %s %s netto %.2f attraversante-pausa %s" % (
        tr, t, lato, N[k]["net"], rk[k], q["tin"] if q else None, q["tout"] if q else None, q["lato"] if q else None, q["net"] if q else float("nan"), attraversa(q) if q else None))
W("  top 10 di R2NOTTEM5 per netto: %s" % [(p["key"][0], str(p["key"][1]), round(p["net"])) for p in Nrank[:10]])
rng = random.Random(777)
netN = [p["net"] for p in Nl]
rim = 24587.09
cnt = 0; B = 20000
for _ in range(B):
    if sum(rng.sample(netN, 7)) >= rim:
        cnt += 1
W("  sorteggio casuale di 7 su 303 (20.000 estrazioni, seed 777): P(netto rimosso >= %.0f) = %.4f" % (rim, cnt / B))
W("  R2NOTTEM5 senza questi 7: n %d PF_V %.4f netto %.2f (= i 296 comuni)" % (len(com_), st([N[k] for k in com_])[1], st([N[k] for k in com_])[2]))
W("")
W("=== J. ANCORA: posizioni di R2NOTTEM5 che attraversano la pausa")
W("  R2NOTTEM5 attraversanti (regola repo): %d ; (finestra larga): %d" % (sum(1 for p in Nl if attraversa(p)), sum(1 for p in Nl if attraversa_largo(p))))
W("")
W("=== K. DD: rapporto H24 / R2NOTTEM5 per tranche (equity, dal lettore: H24 22801.9 / 34924.97 / 47781.48 ; N5 11534.23 / 21663.21 / 11548.58)")
for a, b, t in ((22801.9, 11534.23, "T1"), (34924.97, 21663.21, "T2"), (47781.48, 11548.58, "T3")):
    W("  %s %.2fx" % (t, a / b))
W("")
W("=== L. Senza le attraversanti, per fascia (descrizione): n, netto, PF_V")
for a, b, nm in FASCE:
    sl = [p for p in Hl if a <= p["tin"].hour < b and not attraversa(p)]
    at = [p for p in Hl if a <= p["tin"].hour < b and attraversa(p)]
    W("  %-15s senza: %s | attraversanti n %d netto %.0f" % (nm, fmt(sl), len(at), sum(p["net"] for p in at)))
