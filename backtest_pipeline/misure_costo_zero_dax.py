#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
misure_costo_zero_dax.py -- due misure a costo zero sul DAX Apertura (notte 28/29-09-2026)

MISURA 1: LONG 770101, vivo (InpTP1_ClosePct=50, magic 772501/772502, prova R47a) contro
          senza parziale (ClosePct=0, magic 772503/772504, prova R47b). SELEZIONE o ESPOSIZIONE?
MISURA 2: SHORT 770105 (R270, magic 786322/786324): quante giornate senza fill, e quante
          rotture ribassiste CERTE (stop pieno del long) restano senza retest.

Criteri congelati PRIMA dei numeri: report/MISURE_COSTO_ZERO_DAX_2026-09-29.md sezione 0
(commit 9b687172). Questo script NON cambia i criteri: li applica.

Uso:
    python3 backtest_pipeline/misure_costo_zero_dax.py            # misure sui file veri
    python3 backtest_pipeline/misure_costo_zero_dax.py --autotest # solo contro-esempi sintetici

Solo lettura: non scrive nessun file, stampa a video.
"""
import csv
import datetime as dt
import os
import sys
from collections import OrderedDict, defaultdict

RADICE = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
DIR_R47 = os.path.join(RADICE, "backtest_pipeline", "risultati_prove", "aperture_r47")
DIR_R270 = os.path.join(RADICE, "backtest_pipeline", "risultati_archivio",
                        "ROUND_R270_USCITA_DAX_2026-09-28", "PERTRADE")
PT = "abtg_trades_ABTG_DAX_Apertura_EU_D30EUR_%d.csv"

SALDO0 = 100000.0
RISCHIO = 0.01
SESSIONE_MIN = 570.0          # 08:00-17:30 server
GAMBA_DA = dt.date(2025, 6, 10)
GAMBA_A = dt.date(2026, 6, 30)
# chiusure Xetra nella gamba (dichiarate nei criteri, sezione 0.3)
FESTIVI_XETRA = {dt.date(2025, 12, 24), dt.date(2025, 12, 25), dt.date(2025, 12, 26),
                 dt.date(2025, 12, 31), dt.date(2026, 1, 1), dt.date(2026, 4, 3),
                 dt.date(2026, 4, 6), dt.date(2026, 5, 1)}
T2_A = dt.date(2025, 9, 30)   # T2 = 2025.06.10-2025.09.30, T3 = 2025.10.01-2026.06.30
OFFSET_SHORT_LONGSL = 7.0     # ingresso short (min+2) - stop long (min-5), in punti indice
# orologio BCM (CLAUDE.md 24/09): inverno = fuori dall'ora legale europea
INVERNO = (dt.date(2025, 10, 26), dt.date(2026, 3, 29))


# ----------------------------------------------------------------------------- lettura
def leggi_pertrade(path):
    """Deal di chiusura: lista di dict ordinati per ora."""
    out = []
    with open(path, newline="") as f:
        for r in csv.DictReader(f, delimiter=";"):
            out.append({
                "t": dt.datetime.strptime(r["close_time"], "%Y.%m.%d %H:%M:%S"),
                "magic": int(r["magic"]), "pid": int(r["position_id"]),
                "tipo": int(r["deal_type"]), "vol": float(r["volume"]),
                "px": float(r["price"]), "pnl": float(r["net_profit"]),
            })
    out.sort(key=lambda d: (d["t"], d["pid"]))
    return out


def per_giornata(deals):
    """date -> lista deal (una posizione al giorno per costruzione; si verifica)."""
    g = OrderedDict()
    for d in deals:
        g.setdefault(d["t"].date(), []).append(d)
    return g


def pos_per_giornata(giorni):
    """Numero di position_id distinti per giornata (deve essere 1)."""
    return {k: len({d["pid"] for d in v}) for k, v in giorni.items()}


def serie_R(giorni):
    """date -> (R della giornata, saldo prima, P/L giornata). Saldo composto dalla stessa cella."""
    saldo = SALDO0
    out = OrderedDict()
    for k in sorted(giorni):
        pnl = sum(d["pnl"] for d in giorni[k])
        out[k] = (pnl / (RISCHIO * saldo), saldo, pnl)
        saldo += pnl
    return out


def stima_k(giorni, lato_long=True):
    """EUR per punto per lotto, dai due deal della stessa posizione: mediana e dispersione."""
    ks = []
    for v in giorni.values():
        if len(v) >= 2 and abs(v[0]["px"] - v[-1]["px"]) >= 1.0:
            a, b = v[0], v[-1]
            num = a["pnl"] / a["vol"] - b["pnl"] / b["vol"]
            den = (a["px"] - b["px"]) if lato_long else (b["px"] - a["px"])
            ks.append(num / den)
    ks.sort()
    if not ks:
        return None, 0, (None, None)
    return ks[len(ks) // 2], len(ks), (ks[max(0, len(ks) // 20)], ks[min(len(ks) - 1, len(ks) * 19 // 20)])


def calendario_A(da=GAMBA_DA, a=GAMBA_A):
    out, d = [], da
    while d <= a:
        if d.weekday() < 5 and d not in FESTIVI_XETRA:
            out.append(d)
        d += dt.timedelta(days=1)
    return out


def direzione_mesi(prezzi):
    """prezzi: lista (datetime, prezzo). mese -> +1 su / -1 giu' / 0 pari (primo vs ultimo deal del mese)."""
    per_mese = defaultdict(list)
    for t, p in prezzi:
        per_mese[(t.year, t.month)].append((t, p))
    out = {}
    for m, v in per_mese.items():
        v.sort()
        diff = v[-1][1] - v[0][1]
        out[m] = 1 if diff > 0 else (-1 if diff < 0 else 0)
    return out


# ----------------------------------------------------------------------------- misura 1
def confronto_giornate(vivo, senza):
    """Controlli S2-S4 e le righe per giornata. vivo/senza: date -> deal."""
    rv, rs = serie_R(vivo), serie_R(senza)
    righe, s3_ok, s3_n, s4_ok, s4_n = [], 0, 0, 0, 0
    for g in sorted(set(vivo) & set(senza)):
        dv, ds = vivo[g], senza[g]
        P = len(dv) >= 2
        D = rs[g][0] - rv[g][0]
        riga = {"g": g, "P": P, "D": D, "Rv": rv[g][0], "Rs": rs[g][0],
                "saldo_s": rs[g][1], "V": sum(d["vol"] for d in ds),
                "t1": dv[0]["t"], "t2": dv[-1]["t"]}
        if P:
            s4_n += 1
            if abs(ds[-1]["px"] - dv[-1]["px"]) < 0.05 and ds[-1]["t"] == dv[-1]["t"]:
                s4_ok += 1
        else:
            s3_n += 1
            if abs(ds[-1]["px"] - dv[-1]["px"]) < 0.05 and abs(D) <= 0.02:
                s3_ok += 1
        righe.append(riga)
    return righe, (s3_ok, s3_n), (s4_ok, s4_n)


def verdetto_1(righe, mu, k, dir_mesi, is_senza_ge_vivo, s_ok=True):
    """Applica le regole della sezione 0.2. Ritorna (verdetto, dettagli)."""
    P = [r for r in righe if r["P"]]
    sumD = sum(r["D"] for r in P)
    dtetto = 0.0
    for r in P:
        minuti = (r["t2"] - r["t1"]).total_seconds() / 60.0
        dtetto += 0.5 * r["V"] * k * mu * minuti / (RISCHIO * r["saldo_s"])
    t2 = sum(r["D"] for r in P if r["g"] <= T2_A)
    t3 = sum(r["D"] for r in P if r["g"] > T2_A)
    giu = [r for r in P if dir_mesi.get((r["g"].year, r["g"].month), 0) < 0]
    su = [r for r in P if dir_mesi.get((r["g"].year, r["g"].month), 0) > 0]
    sum_giu, sum_su = sum(r["D"] for r in giu), sum(r["D"] for r in su)
    top5 = sorted((r["D"] for r in P), reverse=True)[:5]
    senza_top5 = sumD - sum(top5)
    Ds = sorted(r["D"] for r in P)
    med = Ds[len(Ds) // 2] if Ds else 0.0
    det = {"nP": len(P), "sumD": sumD, "dtetto": dtetto, "T2": t2, "T3": t3,
           "n_giu": len(giu), "sum_giu": sum_giu, "n_su": len(su), "sum_su": sum_su,
           "top5": top5, "senza_top5": senza_top5, "mediana": med,
           "quota_pos": (sum(1 for x in Ds if x > 0) / len(Ds)) if Ds else 0.0,
           "sumD_N": sum(r["D"] for r in righe if not r["P"])}
    if not s_ok:
        return "NON SEPARABILE con questi file", det
    # ESPOSIZIONE richiede un guadagno da spiegare (sumD > 0): con celle identiche (sumD = 0)
    # il verdetto congelato e' NON SEPARABILE (autotest 1 della sezione 0.2).
    espo = sumD > 0 and ((sumD <= dtetto) or (len(giu) >= 10 and sum_giu <= 0 and sum_su > 0))
    if espo:
        return "ESPOSIZIONE", det
    sele = (sumD > 0 and sumD >= 3 * dtetto and t2 > 0 and t3 > 0 and is_senza_ge_vivo
            and len(giu) >= 10 and sum_giu > 0 and senza_top5 > 0)
    return ("SELEZIONE" if sele else "NON SEPARABILE con questi file"), det


# ----------------------------------------------------------------------------- misura 2
def stop_pieni_long(giorni_long, soglia):
    """Giornate con UN solo deal, perdita >= soglia x R del saldo, chiusura prima delle 17:29."""
    rl = serie_R(giorni_long)
    out = {}
    for g, v in giorni_long.items():
        if len(v) == 1 and -rl[g][0] >= soglia and (v[0]["t"].hour, v[0]["t"].minute) < (17, 29):
            out[g] = v[0]
    return out


def ingresso_short(v, k):
    """Ingresso dello short ricostruito dal primo deal: entry = px + pnl/(vol*k)."""
    d = v[0]
    return d["px"] + d["pnl"] / (d["vol"] * k)


def quantili(xs, qs=(0.1, 0.25, 0.5, 0.75, 0.9)):
    s = sorted(xs)
    if not s:
        return {}
    return {q: s[min(len(s) - 1, int(q * len(s)))] for q in qs}


def verdetto_2(n_rotture_certe, n_con_fill):
    if n_rotture_certe == 0:
        return "NON MISURABILE dai per-trade"
    if n_con_fill / n_rotture_certe >= 0.90:
        return "tesi NON SOSTENUTA"
    return "NON MISURABILE dai per-trade"


# ----------------------------------------------------------------------------- autotest
def _sintetico(n=120, seme=7):
    """Cella vivo sintetica: giornate P/N, prezzi, tempi. Deterministica (LCG), niente random."""
    x = seme
    def rnd():
        nonlocal x
        x = (1103515245 * x + 12345) % (2 ** 31)
        return x / 2 ** 31
    giorni = OrderedDict()
    d = dt.date(2025, 6, 10)
    pid = 1
    px = 24000.0
    while len(giorni) < n:
        if d.weekday() < 5:
            u = rnd()
            V = 10.0
            if u < 0.4:     # P: parziale a 1R (=100 EUR su meta') + runner
                X = -0.2 + 3.0 * rnd()   # runner in R
                t1 = dt.datetime(d.year, d.month, d.day, 9, 30)
                t2 = t1 + dt.timedelta(minutes=30 + int(200 * rnd()))
                giorni[d] = [
                    {"t": t1, "magic": 1, "pid": pid, "tipo": 1, "vol": V / 2, "px": px + 10, "pnl": 500.0},
                    {"t": t2, "magic": 1, "pid": pid, "tipo": 1, "vol": V / 2, "px": px + 10 * X, "pnl": 500.0 * X}]
            else:           # N: stop o chiusura senza TP1
                y = -1.0 + 1.5 * rnd()
                t1 = dt.datetime(d.year, d.month, d.day, 10, 0)
                giorni[d] = [{"t": t1, "magic": 1, "pid": pid, "tipo": 1, "vol": V, "px": px + 10 * y,
                              "pnl": 1000.0 * y}]
            pid += 2
            px += 5 * (rnd() - 0.45)
        d += dt.timedelta(days=1)
    return giorni


def _senza_da_vivo(vivo, fn_runner):
    """Senza parziale: nelle P una posizione intera che esce al prezzo del runner; P/L = fn_runner."""
    out = OrderedDict()
    for g, v in vivo.items():
        if len(v) >= 2:
            d2 = dict(v[-1])
            d2["vol"] = sum(d["vol"] for d in v)
            d2["pnl"] = fn_runner(g, v)
            out[g] = [d2]
        else:
            out[g] = [dict(v[0])]
    return out


def autotest():
    ok = True
    vivo = _sintetico()
    prezzi = [(v[-1]["t"], v[-1]["px"]) for v in vivo.values()]
    dirm = direzione_mesi(prezzi)

    # 1) due celle IDENTICHE -> D = 0 ovunque -> NON SEPARABILE
    righe, s3, s4 = confronto_giornate(vivo, vivo)
    ver, det = verdetto_1(righe, mu=0.0, k=1.0, dir_mesi=dirm, is_senza_ge_vivo=True)
    t1 = all(abs(r["D"]) < 1e-12 for r in righe) and ver.startswith("NON SEPARABILE")
    print("AUTOTEST 1 celle identiche: D max %.2e, verdetto %s -> %s" %
          (max(abs(r["D"]) for r in righe), ver, "OK" if t1 else "FALLITO"))
    ok &= t1

    # 2) P/L RADDOPPIATO solo sulle giornate VINTE, runner lunghi e deriva sufficiente -> ESPOSIZIONE
    def raddoppia(g, v):
        tot = sum(d["pnl"] for d in v)
        return 2 * tot if tot > 0 else tot
    senza = _senza_da_vivo(vivo, raddoppia)
    righe, s3, s4 = confronto_giornate(vivo, senza)
    # deriva: il toro che basta da solo (mu grande: 2 punti al minuto)
    ver, det = verdetto_1(righe, mu=2.0, k=1.0, dir_mesi=dirm, is_senza_ge_vivo=True)
    t2 = ver == "ESPOSIZIONE" and det["sumD"] > 0
    print("AUTOTEST 2 raddoppio sulle vinte + deriva sufficiente: sumD %.2f tetto %.2f -> %s -> %s" %
          (det["sumD"], det["dtetto"], ver, "OK" if t2 else "FALLITO"))
    ok &= t2

    # 2b) raddoppio sulle vinte SOLO nei mesi SU, peggio nei mesi GIU' -> ESPOSIZIONE (regola del regime)
    def regime(g, v):
        tot = sum(d["pnl"] for d in v)
        if dirm.get((g.year, g.month), 0) > 0:
            return 2 * tot if tot > 0 else tot
        return tot - 300.0
    senza = _senza_da_vivo(vivo, regime)
    righe, s3, s4 = confronto_giornate(vivo, senza)
    ver, det = verdetto_1(righe, mu=0.0, k=1.0, dir_mesi=dirm, is_senza_ge_vivo=True)
    t2b = ver == "ESPOSIZIONE" and det["n_giu"] >= 10 and det["sum_giu"] <= 0 < det["sum_su"]
    print("AUTOTEST 2b guadagno solo nei mesi SU (n_giu %d, giu %.2f, su %.2f) -> %s -> %s" %
          (det["n_giu"], det["sum_giu"], det["sum_su"], ver, "OK" if t2b else "FALLITO"))
    ok &= t2b

    # 3) meglio ovunque, largo, senza deriva -> SELEZIONE
    senza = _senza_da_vivo(vivo, lambda g, v: sum(d["pnl"] for d in v) + 200.0)
    righe, s3, s4 = confronto_giornate(vivo, senza)
    ver, det = verdetto_1(righe, mu=0.0, k=1.0, dir_mesi=dirm, is_senza_ge_vivo=True)
    t3 = ver == "SELEZIONE"
    print("AUTOTEST 3 meglio in ogni giornata P, deriva 0 -> %s -> %s" % (ver, "OK" if t3 else "FALLITO"))
    ok &= t3

    # 4) code grasse: meglio SOLO in 3 giornate enormi, peggio nelle altre -> non SELEZIONE
    Pg = [g for g, v in vivo.items() if len(v) >= 2][:3]
    senza = _senza_da_vivo(vivo, lambda g, v: sum(d["pnl"] for d in v) + (5000.0 if g in Pg else -50.0))
    righe, s3, s4 = confronto_giornate(vivo, senza)
    ver, det = verdetto_1(righe, mu=0.0, k=1.0, dir_mesi=dirm, is_senza_ge_vivo=True)
    t4 = ver != "SELEZIONE" and det["senza_top5"] < 0 < det["sumD"]
    print("AUTOTEST 4 code grasse (3 giornate): sumD %.2f senza top5 %.2f -> %s -> %s" %
          (det["sumD"], det["senza_top5"], ver, "OK" if t4 else "FALLITO"))
    ok &= t4

    # 5) S3: se le giornate N differiscono, il controllo le deve vedere
    senza = _senza_da_vivo(vivo, lambda g, v: sum(d["pnl"] for d in v))
    gN = [g for g, v in vivo.items() if len(v) == 1][0]
    senza[gN] = [dict(senza[gN][0], pnl=senza[gN][0]["pnl"] - 400.0, px=senza[gN][0]["px"] - 4)]
    righe, s3, s4 = confronto_giornate(vivo, senza)
    t5 = s3[0] == s3[1] - 1
    print("AUTOTEST 5 S3 vede una giornata N diversa: %d/%d -> %s" % (s3[0], s3[1], "OK" if t5 else "FALLITO"))
    ok &= t5

    # 6) stop pieno: 1,00 R lo prende, 0,95 R no; dopo le 17:29 no
    g = OrderedDict()
    g[dt.date(2025, 6, 10)] = [{"t": dt.datetime(2025, 6, 10, 11, 0), "magic": 1, "pid": 1, "tipo": 1,
                                "vol": 10, "px": 1, "pnl": -1000.0}]
    g[dt.date(2025, 6, 11)] = [{"t": dt.datetime(2025, 6, 11, 11, 0), "magic": 1, "pid": 2, "tipo": 1,
                                "vol": 10, "px": 1, "pnl": -0.95 * 990.0}]
    g[dt.date(2025, 6, 12)] = [{"t": dt.datetime(2025, 6, 12, 17, 30), "magic": 1, "pid": 3, "tipo": 1,
                                "vol": 10, "px": 1, "pnl": -990.0}]
    sp = stop_pieni_long(g, 1.00)
    t6 = list(sp) == [dt.date(2025, 6, 10)]
    print("AUTOTEST 6 stop pieno (1,00R si', 0,95R no, 17:30 no): %s -> %s" % (sorted(sp), "OK" if t6 else "FALLITO"))
    ok &= t6

    # 7) verdetto 2
    t7 = (verdetto_2(10, 9) == "tesi NON SOSTENUTA" and verdetto_2(10, 8) == "NON MISURABILE dai per-trade"
          and verdetto_2(0, 0) == "NON MISURABILE dai per-trade")
    print("AUTOTEST 7 regole del verdetto 2 -> %s" % ("OK" if t7 else "FALLITO"))
    ok &= t7
    print("AUTOTEST: %s" % ("TUTTI OK" if ok else "FALLITO"))
    return ok


# ----------------------------------------------------------------------------- misure vere
def leggi_aggregato(path):
    with open(path, newline="") as f:
        r = list(csv.DictReader(f))
    return {k: float(r[0][k]) for k in ("Profit", "Profit Factor", "Equity DD %", "Trades")}


def f2(x):
    return ("%+.3f" % x).replace(".", ",")


def misure():
    # --- file
    p = {m: leggi_pertrade(os.path.join(DIR_R47, PT % m)) for m in (772501, 772502, 772503, 772504)}
    q = {m: leggi_pertrade(os.path.join(DIR_R270, PT % m)) for m in (786322, 786323, 786324, 786325)}

    print("=" * 100)
    print("MISURA 1 -- LONG 770101: vivo 772501 (ClosePct 50) contro senza parziale 772503 (ClosePct 0), gamba OOS")
    print("=" * 100)
    # S1 gemelli
    def firma(ds):
        return [(d["t"], d["pid"], d["tipo"], d["vol"], d["px"], d["pnl"]) for d in ds]
    s1 = firma(p[772501]) == firma(p[772502]) and firma(p[772503]) == firma(p[772504])
    print("S1 gemelli identici (772501=772502, 772503=772504): %s" % s1)
    for m in (772501, 772503):
        print("   %d: deal %d, somma %.2f, prima chiusura %s, ultima %s" %
              (m, len(p[m]), sum(d["pnl"] for d in p[m]), p[m][0]["t"], p[m][-1]["t"]))
    agg = {}
    for et in ("r47a", "r47b"):
        for leg in ("IS", "OOS"):
            agg[(et, leg)] = leggi_aggregato(os.path.join(DIR_R47, "ABTG_DAX_Apertura_EU_D30EUR_%s_%s.csv" % (leg, et)))
    print("C0 somma per-trade = Profit CSV OOS: vivo %.2f vs %.2f, senza %.2f vs %.2f" %
          (sum(d["pnl"] for d in p[772501]), agg[("r47a", "OOS")]["Profit"],
           sum(d["pnl"] for d in p[772503]), agg[("r47b", "OOS")]["Profit"]))
    gv, gs = per_giornata(p[772501]), per_giornata(p[772503])
    ppv, pps = pos_per_giornata(gv), pos_per_giornata(gs)
    s2 = set(gv) == set(gs) and all(v == 1 for v in ppv.values()) and all(v == 1 for v in pps.values())
    print("S2 stesse giornate, una posizione per giornata: %s (vivo %d giornate, senza %d)" % (s2, len(gv), len(gs)))
    vol_ok = sum(1 for g in gv if abs(sum(d["vol"] for d in gv[g]) - sum(d["vol"] for d in gs[g])) < 1e-9)
    print("   lotto totale identico nelle due celle: %d/%d giornate (il resto = composizione del saldo)" % (vol_ok, len(gv)))
    righe, s3, s4 = confronto_giornate(gv, gs)
    print("S3 giornate N (niente TP1): prezzo uguale e |D|<=0,02R: %d/%d" % s3)
    print("S4 giornate P (TP1 preso): uscita del senza = deal 2 del vivo (prezzo e ora): %d/%d" % s4)
    ndeal = defaultdict(int)
    for v in gv.values():
        ndeal[len(v)] += 1
    print("   deal per giornata nel vivo: %s" % dict(ndeal))
    s_ok = s1 and s2 and s3[0] >= 0.95 * s3[1] and s4[0] >= 0.95 * s4[1]

    k, nk, (k5, k95) = stima_k(gv, True)
    print("k (EUR per punto per lotto) dai deal del vivo: mediana %.4f su %d posizioni (p5 %.4f, p95 %.4f)" % (k, nk, k5, k95))

    # prezzi della gamba (unione dei file DAX) per deriva e direzione dei mesi
    prezzi = [(d["t"], d["px"]) for ds in list(p.values()) + list(q.values()) for d in ds]
    prezzi.sort()
    calA = calendario_A()
    mu = (prezzi[-1][1] - prezzi[0][1]) / (len(calA) * SESSIONE_MIN)
    print("Deriva: primo prezzo %.1f (%s), ultimo %.1f (%s); giorni di borsa A %d -> mu = %.5f punti/minuto di sessione (TETTO)" %
          (prezzi[0][1], prezzi[0][0], prezzi[-1][1], prezzi[-1][0], len(calA), mu))
    dirm = direzione_mesi(prezzi)
    print("Direzione dei mesi (primo vs ultimo deal del mese): %s" %
          ", ".join("%d-%02d:%s" % (m[0], m[1], {1: "SU", -1: "GIU", 0: "="}[s]) for m, s in sorted(dirm.items())))
    is_ge = agg[("r47b", "IS")]["Profit Factor"] >= agg[("r47a", "IS")]["Profit Factor"]
    print("IS aggregato: vivo PF %.5f DD %.4f Profit %.2f | senza PF %.5f DD %.4f Profit %.2f -> senza >= vivo: %s" %
          (agg[("r47a", "IS")]["Profit Factor"], agg[("r47a", "IS")]["Equity DD %"], agg[("r47a", "IS")]["Profit"],
           agg[("r47b", "IS")]["Profit Factor"], agg[("r47b", "IS")]["Equity DD %"], agg[("r47b", "IS")]["Profit"], is_ge))

    ver, det = verdetto_1(righe, mu, k, dirm, is_ge, s_ok)
    rv, rs = serie_R(gv), serie_R(gs)
    print("\nSomme in R (unita' = 1%% del saldo della cella): vivo %.3f  senza %.3f  -> differenza %.3f" %
          (sum(x[0] for x in rv.values()), sum(x[0] for x in rs.values()),
           sum(x[0] for x in rs.values()) - sum(x[0] for x in rv.values())))
    print("  di cui giornate N: %.4f   giornate P: %.3f (n P = %d)" % (det["sumD_N"], det["sumD"], det["nP"]))
    print("  EURO: vivo %.2f senza %.2f (differenza %.2f: include la composizione del saldo)" %
          (sum(x[2] for x in rv.values()), sum(x[2] for x in rs.values()),
           sum(x[2] for x in rs.values()) - sum(x[2] for x in rv.values())))
    P = [r for r in righe if r["P"]]
    Ds = [r["D"] for r in P]
    qd = quantili(Ds)
    print("Giornate P: D mediana %.3f, media %.3f, quota D>0 %.1f%%, quantili %s" %
          (det["mediana"], det["sumD"] / max(1, det["nP"]), 100 * det["quota_pos"],
           {k_: round(v, 3) for k_, v in qd.items()}))
    # livello REALE della parziale in R iniziali: T = 2 x P/L del deal 1 / (1% del saldo). Il bersaglio
    # di TP1 si misura dallo stop CORRENTE (InitialSL con partialDone=false), che il PREVBAR sposta: T < 1.
    T = [2 * gv[r["g"]][0]["pnl"] / (RISCHIO * rv[r["g"]][1]) for r in P]
    print("  livello REALE della parziale (R iniziali): quantili %s, min %.3f max %.3f, sotto 0,9R %d su %d" %
          ({k_: round(v, 3) for k_, v in quantili(T, (0.05, 0.25, 0.5, 0.75, 0.95)).items()}, min(T), max(T),
           sum(1 for t in T if t < 0.9), len(T)))
    print("  D<0 (runner uscito sotto il livello della parziale, in R) %d; a prezzo: deal 2 < deal 1 in %d; senza parziale a >= 2,9R (TP duro 3R) %d" %
          (sum(1 for d in Ds if d < 0), sum(1 for r in P if gv[r["g"]][-1]["px"] < gv[r["g"]][0]["px"]),
           sum(1 for r in P if rs[r["g"]][0] >= 2.9)))
    dur = [(r["t2"] - r["t1"]).total_seconds() / 60 for r in P]
    print("  durata del runner (t2-t1, minuti): %s" % {k_: round(v) for k_, v in quantili(dur).items()})
    print("  esposizione extra totale: %.0f lotti x minuti" % sum(0.5 * r["V"] * (r["t2"] - r["t1"]).total_seconds() / 60 for r in P))
    print("Tetto di deriva Dtetto = %.3f R  |  somma D = %.3f R  |  rapporto %.1fx" %
          (det["dtetto"], det["sumD"], det["sumD"] / det["dtetto"] if det["dtetto"] > 0 else float("inf")))
    print("Tratti: T2 (2025.06.10-09.30) somma D %.3f su %d P | T3 (2025.10.01-2026.06.30) %.3f su %d P" %
          (det["T2"], sum(1 for r in P if r["g"] <= T2_A), det["T3"], sum(1 for r in P if r["g"] > T2_A)))
    print("Mesi SU: %d giornate P, somma D %.3f | mesi GIU: %d giornate P, somma D %.3f" %
          (det["n_su"], det["sum_su"], det["n_giu"], det["sum_giu"]))
    print("Top 5 giornate P per D: %s -> somma senza top 5 = %.3f" %
          ([round(x, 3) for x in det["top5"]], det["senza_top5"]))
    # descrittivo: estate/inverno
    inv = [r for r in P if INVERNO[0] <= r["g"] < INVERNO[1]]
    est = [r for r in P if not (INVERNO[0] <= r["g"] < INVERNO[1])]
    print("Descrittivo (fuori verdetto) orologio: estate %d P somma D %.3f | inverno %d P somma D %.3f" %
          (len(est), sum(r["D"] for r in est), len(inv), sum(r["D"] for r in inv)))
    # tre tratti uguali per numero (robustezza, descrittivo)
    terzi = [P[i * len(P) // 3:(i + 1) * len(P) // 3] for i in range(3)]
    print("Descrittivo: tre terzi di giornate P: %s" %
          " | ".join("%s..%s somma %.3f" % (t[0]["g"], t[-1]["g"], sum(r["D"] for r in t)) for t in terzi))
    # le 5 migliori, con il mese
    migl = sorted(P, key=lambda r: -r["D"])[:5]
    print("Le 5 migliori: %s" % "; ".join("%s D %.3f (runner %.0f min)" %
                                          (r["g"], r["D"], (r["t2"] - r["t1"]).total_seconds() / 60) for r in migl))
    # DD in R sulla gamba (drawdown dal picco della curva in R, descrittivo)
    def dd_R(serie):
        c, pk, dd = 0.0, 0.0, 0.0
        for x in serie.values():
            c += x[0]
            pk = max(pk, c)
            dd = max(dd, pk - c)
        return dd
    print("DD della curva in R (dal picco, somma di R): vivo %.2f R, senza %.2f R" % (dd_R(rv), dd_R(rs)))
    # descrittivo: sensibilita' alle code e alle giornate divergenti (S4 KO = BE a TP1 inerte con ClosePct 0)
    Da = sorted((r["D"] for r in P), reverse=True)
    print("Descrittivo: somma senza le top-k (k=1..5): %s; quota delle top 5 sul totale %.0f%%" %
          ([round(sum(Da) - sum(Da[:kk]), 3) for kk in range(1, 6)], 100 * sum(Da[:5]) / sum(Da)))
    print("Descrittivo: D>0 %d giornate somma %.3f | D<0 %d giornate somma %.3f | D>=0,5 (runner >= 2R) %d" %
          (sum(1 for x in Da if x > 0), sum(x for x in Da if x > 0), sum(1 for x in Da if x < 0),
           sum(x for x in Da if x < 0), sum(1 for x in Da if x >= 0.5)))
    div = [r for r in P if not (abs(gs[r["g"]][-1]["px"] - gv[r["g"]][-1]["px"]) < 0.05
                                and gs[r["g"]][-1]["t"] == gv[r["g"]][-1]["t"])]
    for r in div:
        print("Giornata DIVERGENTE (S4 KO): %s vivo %s | senza %s | D %.3f" %
              (r["g"], [(d["t"].strftime("%H:%M:%S"), d["vol"], d["px"], d["pnl"]) for d in gv[r["g"]]],
               [(d["t"].strftime("%H:%M:%S"), d["vol"], d["px"], d["pnl"]) for d in gs[r["g"]]], r["D"]))
    Pc = sorted((r["D"] for r in P if r not in div), reverse=True)
    print("Descrittivo: senza le %d divergenti: n %d somma D %.3f; senza top-k: %s" %
          (len(div), len(Pc), sum(Pc), [round(sum(Pc) - sum(Pc[:kk]), 3) for kk in range(1, 6)]))
    print("\n>>> VERDETTO MISURA 1: %s" % ver)

    # ------------------------------------------------------------------ misura 2
    print("\n" + "=" * 100)
    print("MISURA 2 -- SHORT 770105 (R270): giornate senza fill e rotture certe senza retest, gamba OOS")
    print("=" * 100)
    g22, g24 = per_giornata(q[786322]), per_giornata(q[786324])
    pp22 = pos_per_giornata(g22)
    print("Fill short: 786322 %d giornate, 786324 %d giornate, stesse date: %s; una posizione per giornata: %s" %
          (len(g22), len(g24), set(g22) == set(g24), all(v == 1 for v in pp22.values())))
    for m in (786322, 786324):
        print("   %d: deal %d, somma %.2f, deal_type %s" % (m, len(q[m]), sum(d["pnl"] for d in q[m]),
                                                        sorted({d["tipo"] for d in q[m]})))
    F = set(g22)
    calB = sorted({d["t"].date() for ds in list(p.values()) + list(q.values()) for d in ds})
    calB = [g for g in calB if GAMBA_DA <= g <= GAMBA_A]
    fuoriA = [g for g in calB if g not in set(calA)]
    print("Calendario A (Xetra) %d giornate (%d senza il 30/06/2026); calendario B (deal in almeno un file) %d" %
          (len(calA), len([g for g in calA if g != GAMBA_A]), len(calB)))
    print("   date B fuori da A (CFD aperto in un festivo Xetra o weekend): %s" % fuoriA)
    print("   date A senza nessun deal in nessuno degli 8 file: %d" % len(set(calA) - set(calB)))
    Ffuori = sorted(F - set(calA))
    print("Fill short dentro A: %d; fuori A: %s" % (len(F & set(calA)), Ffuori))
    print("Giornate A senza fill short: %d su %d (%.1f%%); con fill %.1f%%" %
          (len(set(calA) - F), len(calA), 100 * len(set(calA) - F) / len(calA), 100 * len(F & set(calA)) / len(calA)))
    L = per_giornata(p[772501])
    both = F & set(L)
    print("Incrocio col long vivo (772501, %d fill): solo long %d, solo short %d, tutti e due %d, nessuno (in A) %d" %
          (len(L), len(set(L) - F), len(F - set(L)), len(both), len(set(calA) - F - set(L))))

    kl = k
    ks, nks, (ks5, ks95) = stima_k(g22, False)
    print("k short (786322): mediana %.4f su %d posizioni (p5 %.4f, p95 %.4f)" % (ks, nks, ks5, ks95))

    for nome_long, glong in (("772501 vivo (R47a)", L), ("786325 TP1 2R (R270, pin)", per_giornata(q[786325]))):
        for soglia in (1.00, 0.97):
            sp = stop_pieni_long(glong, soglia)
            cf = sorted(g for g in sp if g in F)
            sf = sorted(g for g in sp if g not in F)
            print("\nRotture ribassiste dal long %s, stop pieno >= %.2f R: %d giornate -> short CON fill %d, SENZA fill %d (%.0f%% senza)" %
                  (nome_long, soglia, len(sp), len(cf), len(sf), 100 * len(sf) / len(sp) if sp else 0))
            if soglia == 1.00:
                # contro-esempio della premessa
                sc = []
                for g in cf:
                    e_s = ingresso_short(g22[g], ks)
                    sc.append(sp[g]["px"] - (e_s - OFFSET_SHORT_LONGSL))
                if sc:
                    entro = sum(1 for x in sc if abs(x) <= 1.0)
                    print("   premessa (uscita long = ingresso short - 7): scarto entro 1 punto %d/%d; scarti %s" %
                          (entro, len(sc), [round(x, 2) for x in sorted(sc)]))
                print("   ora dello stop del long nelle SENZA fill (ultimo istante possibile della rottura): %s" %
                      [sp[g]["t"].strftime("%H:%M") for g in sf])
                print("   giornate SENZA fill: %s" % [str(g) for g in sf])
                if nome_long.startswith("772501"):
                    ver2 = verdetto_2(len(sp), len(cf))
                    n_certe, n_cf = len(sp), len(cf)
    # descrittivo, fuori verdetto: lo SPECCHIO. Stop pieno dello SHORT (>= 1 R) = rottura RIALZISTA certa
    # (stop iniziale short = massimo + 5 = grilletto del long, stessa condizione ask >=): il long ha preso il retest?
    for m_, gg in ((786322, g22), (786324, g24)):
        for soglia in (1.00, 0.97):
            sp = stop_pieni_long(gg, soglia)
            cf = [g for g in sp if g in L]
            print("Specchio %d, stop pieno short >= %.2f R: %d rotture rialziste certe -> long CON fill %d, SENZA %d" %
                  (m_, soglia, len(sp), len(cf), len(sp) - len(cf)))
    print("Date A senza nessun deal: %s" % [str(g) for g in sorted(set(calA) - set(calB))])
    # (b) distribuzione del P/L nelle giornate con fill
    for m, gg in ((786322, g22), (786324, g24)):
        rr = serie_R(gg)
        Rs = [x[0] for x in rr.values()]
        eur = [x[2] for x in rr.values()]
        vinte = sum(1 for x in eur if x > 0)
        ore = defaultdict(int)
        for v in gg.values():
            ore[v[-1]["t"].hour] += 1
        gp = sum(x for x in eur if x > 0)
        gl = -sum(x for x in eur if x < 0)
        print("\n(b) %d: %d giornate, vinte %d (%.1f%%), PF per giornata %.3f, R quantili %s" %
              (m, len(gg), vinte, 100 * vinte / len(gg), gp / gl if gl else float("inf"),
               {k_: round(v, 2) for k_, v in quantili(Rs).items()}))
        print("   somma R %.2f, peggiore %.2f R, migliore %.2f R; ora di chiusura (server) %s" %
              (sum(Rs), min(Rs), max(Rs), dict(sorted(ore.items()))))
    print("\n>>> VERDETTO MISURA 2: %s (rotture certe dal long vivo >= 1,00 R: %d, con fill %d)" % (ver2, n_certe, n_cf))


if __name__ == "__main__":
    ok = autotest()
    if not ok:
        print("AUTOTEST FALLITO: misure NON eseguite.")
        sys.exit(1)
    if "--autotest" in sys.argv:
        sys.exit(0)
    print()
    misure()
