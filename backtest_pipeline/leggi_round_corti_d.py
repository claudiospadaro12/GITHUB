#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
leggi_round_corti_d.py -- LA LETTURA del ROUND CORTI D (R268 + R269) dalla
raccolta ROUND_CORTI_D_<data>.zip estratta (riga RIGA_ROUND_CORTI_D_R268_R269,
PASS a1b4195e). La riga fa la PRE-LETTURA (cancelli di nullita', G0, r, curva,
anno per anno) e dichiara di NON fare: K1 (stop dal lotto, classe 846), la
PEGGIOR FINESTRA MOBILE di 12 mesi (b1/b2), K1 per anno, gli STOP PIENI
RIMASTI e il CONTO PER MESE di R269, il confronto per giornata di R269c.
Questo script fa TUTTA la lettura (rifa' anche i cancelli, in modo
indipendente dalla riga: due strati, il primo che fallisce blocca) coi
criteri CONGELATI nei file di testa:
  R268  prove/R268a_oro_long_TICK_testa.txt par. 0, 6, 7
        prove/R268c_oro_long_TICK_asse_rischio.txt (attesa e cancelli)
        prove/R268d_oro_long_OHLC_22anni.txt par. 2-4
  R269  prove/R269a_oro_770402_long_close13.txt par. 4-5 (R269a e R269b)
        prove/R269c_dax_long_meno1h.txt par. 4-5

SOLA LETTURA: non tocca EA, preset, prove, CSV, sedie, conti, taglie.
NESSUNA TAGLIA E' PROPOSTA (R4 di tutte le teste): ogni numero di taglia
e' [DERIVATO] contro un muro di RIFERIMENTO, e resta materiale per Claudio.

Regole di lettura (tutte applicate):
  - la FONTE accanto a ogni numero (file della raccolta, colonna o calcolo);
  - ETICHETTE: [MISURATO] dal CSV o dal per-trade, [DERIVATO] da una formula
    scritta nella testa, [STIMA] / [NON MISURATO] / [NON VERIFICATO];
  - le POSIZIONI si contano per position_id (una posizione = 1-3 deal);
  - sull'oro ogni saldo toglie k x volume (classe 844: commissione
    d'ingresso che il per-trade NON porta; k = (somma net - Profit)/lotti);
  - se il G0 di R268b e' ROSSO lo script stampa "R268 NON SI LEGGE" e si
    ferma su R268 (R269 si legge lo stesso: banco ancorato dal suo G0).

Uso:
  python3 backtest_pipeline/leggi_round_corti_d.py RACCOLTA_DIR [--md OUT.md]
        [--tick-da AAAA.MM.GG] [--archivi DIR_PERTRADE_CORTI_B]
  python3 backtest_pipeline/leggi_round_corti_d.py --autotest [--fixture-dir DIR]
RACCOLTA_DIR = la cartella ROUND_CORTI_D_<data> estratta dallo zip
(ROUND_R268a/.. PERTRADE/ archivio_CORTI_B_pertrade_*.csv
RIEPILOGO_ROUND_CORTI_D.txt LOG_TESTER/). Gli archivi 795301/795302/795401 si
prendono dalla raccolta; se mancano, da risultati_archivio/ROUND_CORTI_B_
2026-09-27/PERTRADE (--archivi per un'altra cartella).
"""
import argparse
import csv
import io
import math
import os
import re
import statistics
import sys
import tempfile
from bisect import bisect_left
from collections import OrderedDict, defaultdict
from datetime import datetime, timedelta

QUI = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, QUI)
import autopsia_pertrade as ap  # noqa: E402  (riusato come modulo: leggi_deal, aggrega, tabella, pf, ora_legale)

EA = "ABTG_MaxMinNotte"
DEPOSITO = 100000.0
C_ORO = 100.0            # oz per lotto
RISCHIO_ORO = 0.005      # InpRiskPercent 0,5 pinnato sull'oro
FRONTIERA_K1 = 18.00     # 40 x 0,45 $ (testa R268a par. 6.4)
K_BANDA = (1.00, 3.00)   # C0 oro, EUR/lotto
K_ARC = {"795301": 1.8113, "795302": 1.8039, "795401": 0.0}
ARCHIVI_REPO = os.path.join(QUI, "risultati_archivio", "ROUND_CORTI_B_2026-09-27", "PERTRADE")
DD_R260A = 4.5172        # Equity DD % CSV di R260a (base di D1 e di Q1/Q2/Q3 long)
MURO_22 = 10.0           # contratto R100 (riferimento, altra configurazione)
S3 = 8.0                 # R193b S3 (solo per la taglia 2,00 sulla sua sotto-finestra: qui riferimento)
TAGLIE = (0.5, 1.0, 1.5, 2.0)

# t, simbolo, suffisso modello, gamba letta, magic gemelle, magic informativo (asse), lato, kind, finestra, prova
JOBS = OrderedDict([
    ("R268b", dict(s="XAUUSD", sm="_ohlc", lg="OOS", pt=["797202", "797252"], pi=[], sd=1, kr="oro",
                   d0="2024.07.06", d1="2026.06.30", ax="InpMagic", p="R268b_oro_long_OHLC_stessa_finestra_G0.txt")),
    ("R268a", dict(s="XAUUSD", sm="", lg="OOS", pt=["797201", "797251"], pi=[], sd=1, kr="oro",
                   d0="2024.07.06", d1="2026.06.30", ax="InpMagic", p="R268a_oro_long_TICK_testa.txt")),
    ("R268c", dict(s="XAUUSD", sm="", lg="OOS", pt=[], pi=["797203"], sd=1, kr="oro",
                   d0="2024.07.06", d1="2026.06.30", ax="InpRiskPercent", p="R268c_oro_long_TICK_asse_rischio.txt")),
    ("R268d", dict(s="XAUUSD", sm="_ohlc", lg="OOS", pt=["797204", "797254"], pi=[], sd=1, kr="oro",
                   d0="2004.06.20", d1="2026.06.30", ax="InpMagic", p="R268d_oro_long_OHLC_22anni.txt")),
    ("R269a", dict(s="XAUUSD", sm="_ohlc", lg="OOS", pt=["797211", "797261"], pi=[], sd=1, kr="oro",
                   d0="2020.01.01", d1="2026.06.30", ax="InpMagic", p="R269a_oro_770402_long_close13.txt")),
    ("R269b", dict(s="XAUUSD", sm="_ohlc", lg="OOS", pt=["797212", "797262"], pi=[], sd=0, kr="oro",
                   d0="2020.01.01", d1="2026.06.30", ax="InpMagic", p="R269b_oro_770402_short_close13.txt")),
    ("R269c", dict(s="D30EUR", sm="", lg="IS", pt=["797213", "797263"], pi=[], sd=1, kr="dax",
                   d0="2024.09.26", d1="2026.06.30", ax="InpMagic", p="R269c_dax_long_meno1h.txt")),
])
# R269a / R269b: base, attese e soglie (testa R269a par. 4-5)
R269 = {
    "R269a": dict(mg="797211", arc="795301", lato="LONG", pos=279, pre=64, deal=306, p1=1.45, p2=1.25,
                  q1=3.39, q2=DD_R260A, base_pf=1.3357, stop_att=15),
    "R269b": dict(mg="797212", arc="795302", lato="SHORT", pos=232, pre=50, deal=257, p1=1.35, p2=1.15,
                  q1=3.06, q2=4.0755, base_pf=1.2545, stop_att=9),
}
R269C_BASE = dict(mg="797213", arc="795401", dd_d0=7.8243, pf_estate_d0=0.818, pf_inverno_d0=1.030,
                  n_estate_d0=45, n_inverno_d0=27, stop08_d0="24 su 33")


# ----------------------------------------------------------------------
#  Formattazione e piccole utilita'
# ----------------------------------------------------------------------
def f2(x):
    return "n.d." if x is None or (isinstance(x, float) and math.isnan(x)) else "%.2f" % x


def f3(x):
    return "n.d." if x is None or (isinstance(x, float) and math.isnan(x)) else "%.3f" % x


def f4(x):
    return "n.d." if x is None or (isinstance(x, float) and math.isnan(x)) else "%.4f" % x


def fpf(x):
    if x is None:
        return "n.d."
    return "inf" if x == float("inf") else "%.3f" % x


def num(s):
    try:
        return float(str(s).strip())
    except (TypeError, ValueError):
        return float("nan")


def ct(d):
    return d["t"].strftime("%Y.%m.%d %H:%M:%S")


def dstr(t):
    return t.strftime("%Y.%m.%d")


def leggi_pertrade(path):
    with open(path, encoding="utf-8-sig") as fh:
        deals = ap.leggi_deal(fh)
    deals.sort(key=lambda d: (d["t"], d["pid"]))
    return deals


def leggi_csv_round(path):
    with open(path, encoding="utf-8-sig", newline="") as fh:
        return list(csv.DictReader(fh))


def cella(rows, asse, val):
    hit = [r for r in rows if abs(num(r.get(asse)) - float(val)) <= 1e-6]
    return hit[0] if len(hit) == 1 else None


def riga_txt(r):
    if r is None:
        return "riga MANCANTE"
    return "Trades %s, Profit %s, PF %s, Equity DD %% %s" % (r["Trades"], r["Profit"], r["Profit Factor"], r["Equity DD %"])


def k_commissione(deals, profit_csv):
    """classe 844: k = (somma net - Profit del CSV) / somma volumi (EUR/lotto)."""
    v = sum(d["vol"] for d in deals)
    return (sum(d["net"] for d in deals) - profit_csv) / v if v > 0 else float("nan")


def n_pos(deals):
    return len(set(d["pid"] for d in deals))


# ----------------------------------------------------------------------
#  Saldo chiuso, PF in posizioni, finestra mobile, K1
# ----------------------------------------------------------------------
class Curva(list):
    """lista [(t, saldo)] che ricorda il saldo di PARTENZA (s0): il saldo vero prima del primo punto."""
    s0 = DEPOSITO


def curva_saldo(deals, k, dep=DEPOSITO, da=None):
    """[(t, saldo dopo il deal)] in ordine di chiusura; net - k x vol per deal (classe 844).
    da = data 'AAAA.MM.DD' da cui partire (P0-TICK caso ii): i deal prima di da NON entrano nella
    curva ma il saldo di partenza e' quello VERO a quella data (dep + netti con k prima), perche' i
    lotti dopo da sono stati calcolati su quel saldo (cancello 27/09: prima ripartiva da 100000,
    DD in % su un saldo che il conto non aveva, e K1 invece usava il saldo vero)."""
    out = Curva()
    s = dep
    for d in sorted(deals, key=lambda x: (x["t"], x["pid"])):
        if da and dstr(d["t"]) < da:
            s += d["net"] - k * d["vol"]
            continue
        if not out:
            out.s0 = s
        s += d["net"] - k * d["vol"]
        out.append((d["t"], s))
    if not out:
        out.s0 = s
    return out


def dd_chiuso(curva, dep=DEPOSITO):
    """DD massimo a saldo chiuso in % del picco, con date del picco e del fondo."""
    dep = getattr(curva, "s0", dep)
    pk, dpk, ddm, eur, d_pk, d_fo = dep, None, 0.0, 0.0, None, None
    for t, s in curva:
        if s > pk:
            pk, dpk = s, t
        dd = 100.0 * (pk - s) / pk
        if dd > ddm:
            ddm, eur, d_pk, d_fo = dd, pk - s, dpk, t
    return dict(dd=ddm, eur=eur, pk=d_pk, fo=d_fo, fin=(curva[-1][1] if curva else dep), n=len(curva))


def finestra_mobile(curva, dep=DEPOSITO, giorni=365):
    """(b1) DD massimo a saldo chiuso INTERNO a una finestra di 365 giorni (picco e fondo dentro,
    finestre che iniziano a ogni chiusura), in % del picco; (b2) peggior netto su 365 giorni
    in % del saldo d'inizio finestra. Testa R268d par. 3 (b)."""
    n = len(curva)
    b1 = dict(dd=0.0, pk=None, fo=None)
    b2 = dict(pct=0.0, da=None, a=None)
    for i in range(n):
        t0, s_prima = curva[i][0], (curva[i - 1][1] if i > 0 else getattr(curva, "s0", dep))
        pk, tpk = curva[i][1], t0      # il picco e' una CHIUSURA dentro la finestra (non il saldo prima di essa)
        for j in range(i, n):
            tj, sj = curva[j]
            if tj - t0 > timedelta(days=giorni):
                break
            if sj > pk:
                pk, tpk = sj, tj
            dd = 100.0 * (pk - sj) / pk
            if dd > b1["dd"]:
                b1 = dict(dd=dd, pk=tpk, fo=tj)
            pct = 100.0 * (sj - s_prima) / s_prima
            if pct < b2["pct"]:
                b2 = dict(pct=pct, da=t0, a=tj)
    return b1, b2


def pf_pos(pos):
    return ap.pf(pos)


def stat_pos(pos):
    g = sum(p["net"] for p in pos if p["net"] > 0)
    l = -sum(p["net"] for p in pos if p["net"] <= 0)
    return dict(n=len(pos), pf=(g / l if l > 0 else (float("inf") if g > 0 else 0.0)), gp=g, gl=l, net=g - l)


def ancore_q(deals):
    """q = EUR per USD, misurato dal file (COLLAUDO_ORO par. 4): due deal d'uscita della stessa
    posizione, pari volume, prezzi diversi: q = (net1 - net2) / ((p1 - p2) x vol x C)."""
    by = defaultdict(list)
    for d in deals:
        by[d["pid"]].append(d)
    out = []
    for pid, ds in by.items():
        for i in range(len(ds)):
            for j in range(i + 1, len(ds)):
                a, b = ds[i], ds[j]
                if abs(a["vol"] - b["vol"]) < 1e-9 and abs(a["price"] - b["price"]) > 1e-9 and a["vol"] > 0:
                    out.append((a["t"], pid, (a["net"] - b["net"]) / ((a["price"] - b["price"]) * a["vol"] * C_ORO)))
    return sorted(out)


AMPLI_MAX = 100.0   # [DIAGNOSTICA, soglia del cancello 27/09, NON congelata]: vedi ancore_cond


def ancore_cond(deals):
    """Le stesse ancore di ancore_q con il loro CONDIZIONAMENTO (classe 877): il metodo suppone lo
    STESSO cambio sulle due uscite. Se i due prezzi sono quasi uguali, la deriva del cambio fra le
    due uscite (sul P/L intero |p - p_ingresso|) si divide per |p1 - p2| e l'ancora esplode (795301:
    2021.05.25 prezzi 1893,74 / 1893,71 -> q 0,4348; 2020.05.15 1747,71 / 1747,74 -> q 1,1067).
    A = |p - p_ingresso| stimato (|net| max / (vol x C x q mediana)) / |p1 - p2|; A > AMPLI_MAX =
    MAL CONDIZIONATA. Ritorna [(t, pid, q, dp, A)]."""
    anc = []
    by = defaultdict(list)
    for d in deals:
        by[d["pid"]].append(d)
    for pid, ds in by.items():
        for i in range(len(ds)):
            for j in range(i + 1, len(ds)):
                a, b = ds[i], ds[j]
                if abs(a["vol"] - b["vol"]) < 1e-9 and abs(a["price"] - b["price"]) > 1e-9 and a["vol"] > 0:
                    anc.append((a["t"], pid, (a["net"] - b["net"]) / ((a["price"] - b["price"]) * a["vol"] * C_ORO), abs(a["price"] - b["price"]), a, b))
    if not anc:
        return []
    qm = statistics.median([x[2] for x in anc])
    out = []
    for t, pid, q, dp, a, b in anc:
        A = (max(abs(a["net"]), abs(b["net"])) / (a["vol"] * C_ORO * abs(qm)) / dp) if qm else float("inf")
        out.append((t, pid, q, dp, A))
    return sorted(out)


def k1_diagnostica(pos, saldo, anc):
    """K1 rifatto SENZA le ancore mal condizionate: [DIAGNOSTICA], NON decide (la testa congela [min ; max])."""
    buone = [q for _, _, q, _, A in anc if A <= AMPLI_MAX]
    male = [(dstr(t), pid, q, dp, A) for t, pid, q, dp, A in anc if A > AMPLI_MAX]
    if not male:
        return male, None
    if not buone:
        return male, dict(verdetto="NON LEGGIBILE (nessuna ancora ben condizionata)", smin=None, smax=None, quota=(0, 0), n=len(pos))
    return male, k1_lotto(pos, saldo, min(buone), max(buone))


class SaldoPrima:
    """saldo (con k) PRIMA di un istante: dep + somma (net - k vol) dei deal chiusi prima."""

    def __init__(self, deals, k, dep=DEPOSITO):
        ds = sorted(deals, key=lambda x: (x["t"], x["pid"]))
        self.ts = [d["t"] for d in ds]
        self.cum = []
        s = dep
        for d in ds:
            s += d["net"] - k * d["vol"]
            self.cum.append(s)
        self.dep = dep

    def prima(self, t):
        i = bisect_left(self.ts, t)
        return self.cum[i - 1] if i > 0 else self.dep


def k1_lotto(pos, saldo, q_lo, q_hi, rischio=RISCHIO_ORO, front=FRONTIERA_K1, n_min=30):
    """K1 (classe 846): stop in [ R / ((V+0,01) x C x q_alto) ; R / (V x C x q_basso) ],
    R = saldo prima della posizione x rischio, V = volume d'ingresso = somma dei volumi
    d'uscita, C = 100 oz/lotto, q = EUR per USD (banda [min;max] delle ancore).
    VERDE: mediana degli stop MINIMI >= 18 $; ROSSO: mediana dei MASSIMI < 18 $; altrimenti
    NON DECISO. n < 30 posizioni = NON LEGGIBILE. Quota sotto frontiera [max<18 ; min<18]."""
    if not (q_lo > 0 and q_hi > 0):
        return dict(n=len(pos), verdetto="NON LEGGIBILE (q NON MISURABILE: nessuna ancora)", smin=None, smax=None, quota=(0, 0))
    smin, smax = [], []
    for p in pos:
        B = saldo.prima(p["t_first"])
        R = B * rischio
        V = p["vol"]
        smin.append(R / ((V + 0.01) * C_ORO * q_hi))
        smax.append(R / (V * C_ORO * q_lo))
    n = len(pos)
    if n == 0:
        return dict(n=0, verdetto="NON LEGGIBILE (0 posizioni)", smin=None, smax=None, quota=(0, 0))
    mmin, mmax = statistics.median(smin), statistics.median(smax)
    quota = (sum(1 for x in smax if x < front), sum(1 for x in smin if x < front))
    if n < n_min:
        v = "NON LEGGIBILE (n %d < %d)" % (n, n_min)
    elif mmin >= front:
        v = "VERDE (mediana degli stop MINIMI %.2f $ >= %.2f)" % (mmin, front)
    elif mmax < front:
        v = "ROSSO (mediana degli stop MASSIMI %.2f $ < %.2f)" % (mmax, front)
    else:
        v = "NON DECISO (mediana minimi %.2f < %.2f <= mediana massimi %.2f)" % (mmin, front, mmax)
    return dict(n=n, verdetto=v, smin=mmin, smax=mmax, quota=quota)


def dd_taglia(d, f, base=0.5):
    """[DERIVATO] pavimento moltiplicativo 1-(1-d)^(f/base) (teorema) e tetto lineare (f/base) x d
    (indicativo, sole perdite); d e f in %."""
    e = f / base
    return 100.0 * (1.0 - (1.0 - d / 100.0) ** e), e * d


# ----------------------------------------------------------------------
#  G0: abbinamento per chiave (close_time, price) a molteplicita' (classe 849), lotto, soldi
# ----------------------------------------------------------------------
def abbina(new, arc):
    ix = defaultdict(list)
    for a in arc:
        ix[(ct(a), a["price"])].append(a)
    prs, no_arc, first_no, n_dt, first_dt, n_sol, first_sol = [], 0, "", 0, "", 0, ""
    for b in new:
        kk = (ct(b), b["price"])
        if ix.get(kk):
            a = ix[kk].pop(0)
            prs.append((a, b))
            if a["deal_type"] != b["deal_type"]:
                n_dt += 1
                first_dt = first_dt or ("%s deal_type %d contro archivio %d" % (ct(b), b["deal_type"], a["deal_type"]))
            if a["vol"] > 0 and b["vol"] > 0:
                tol = 0.01 / b["vol"] + 0.01 / a["vol"]
                if abs(b["net"] / b["vol"] - a["net"] / a["vol"]) > tol + 1e-9:
                    n_sol += 1
                    first_sol = first_sol or ("%s net/vol %.2f contro %.2f EUR/lotto, tolleranza %.2f"
                                              % (ct(b), b["net"] / b["vol"], a["net"] / a["vol"], tol))
            else:
                n_sol += 1
        else:
            no_arc += 1
            first_no = first_no or ("%s price %s" % (ct(b), b["price"]))
    no_new = sum(len(v) for v in ix.values())
    first_no_new = ""
    for kk, v in ix.items():
        if v:
            first_no_new = "%s price %s" % (ct(v[0]), v[0]["price"])
            break
    mapA, mapB, n_grp = {}, {}, 0
    for a, b in prs:
        if mapA.setdefault(a["pid"], b["pid"]) != b["pid"]:
            n_grp += 1
        if mapB.setdefault(b["pid"], a["pid"]) != a["pid"]:
            n_grp += 1
    return dict(prs=prs, nM=len(prs), nNoArc=no_arc, firstNo=first_no, nNoNew=no_new, firstNoNew=first_no_new,
                nDt=n_dt, firstDt=first_dt, nSol=n_sol, firstSol=first_sol, nGrp=n_grp)


def lotto_chk(prs, new, arc, k_new, k_arc, dep_new=DEPOSITO, dep_arc=DEPOSITO, da_arc=None):
    """G0-LOTTO: V' dentro [floor(V x B'/B) - 0,01 ; floor((V+0,01) x B'/B) + 0,01], B = saldo (con k)
    prima della posizione, dal deposito di OGNI gamba."""
    volA, volB, fcA, fcB = defaultdict(float), defaultdict(float), {}, {}
    for a in arc:
        volA[a["pid"]] += a["vol"]
        fcA[a["pid"]] = min(fcA.get(a["pid"], a["t"]), a["t"])
    for b in new:
        volB[b["pid"] ] += b["vol"]
        fcB[b["pid"]] = min(fcB.get(b["pid"], b["t"]), b["t"])
    arc_da = [a for a in arc if not da_arc or dstr(a["t"]) >= da_arc]
    sA, sB = SaldoPrima(arc_da, k_arc, dep_arc), SaldoPrima(new, k_new, dep_new)
    seen, n, ko, first = set(), 0, 0, ""
    for a, b in prs:
        key = (a["pid"], b["pid"])
        if key in seen:
            continue
        seen.add(key)
        n += 1
        bA, bB = sA.prima(fcA[a["pid"]]), sB.prima(fcB[b["pid"]])
        vA, vB = volA[a["pid"]], volB[b["pid"]]
        lo = math.floor(vA * bB / bA * 100.0 + 1e-7) / 100.0 - 0.01
        hi = math.floor((vA + 0.01) * bB / bA * 100.0 + 1e-7) / 100.0 + 0.01
        if vB < lo - 1e-6 or vB > hi + 1e-6:
            ko += 1
            first = first or ("posizione archivio %d (V %.2f, saldo %.2f) contro nuova %d (V %.2f, saldo %.2f): banda [%.2f ; %.2f]"
                              % (a["pid"], vA, bA, b["pid"], vB, bB, lo, hi))
    return dict(n=n, ko=ko, first=first)


# ----------------------------------------------------------------------
#  La raccolta
# ----------------------------------------------------------------------
class Raccolta:
    def __init__(self, root, archivi=None, tick_da=None):
        self.root = root
        self.archivi = archivi
        self.tick_da_forzata = tick_da
        self.note = []

    def p_csv(self, t):
        j = JOBS[t]
        return os.path.join(self.root, "ROUND_" + t, "%s_%s_%s%s_%s.csv" % (EA, j["s"], j["lg"], j["sm"], t))

    def p_pt(self, t, mg):
        return os.path.join(self.root, "PERTRADE", "abtg_trades_%s_%s_%s.csv" % (EA, JOBS[t]["s"], mg))

    def p_arc(self, mg):
        p = os.path.join(self.root, "archivio_CORTI_B_pertrade_%s.csv" % mg)
        if os.path.exists(p):
            return p
        sym = "D30EUR" if mg == "795401" else "XAUUSD"
        for base in [self.archivi, ARCHIVI_REPO]:
            if base:
                q = os.path.join(base, "abtg_trades_%s_%s_%s.csv" % (EA, sym, mg))
                if os.path.exists(q):
                    self.note.append("archivio %s NON nella raccolta: preso da %s" % (mg, q))
                    return q
        return p

    def lanciato(self, t):
        return os.path.isdir(os.path.join(self.root, "ROUND_" + t))

    def riepilogo(self):
        p = os.path.join(self.root, "RIEPILOGO_ROUND_CORTI_D.txt")
        if not os.path.exists(p):
            return []
        with open(p, encoding="utf-8", errors="replace") as fh:
            return fh.read().splitlines()

    def riga_riepilogo(self, prefisso):
        for ln in self.riepilogo():
            if ln.startswith(prefisso):
                return ln
        return ""

    def nulli_riga(self):
        """classe 873: i NULLI che SOLO la riga vede (rc 1, MOTORE DIVERSO DAL PIN / classe 166, prova diversa
        dal pin, CSV vecchio) si UNISCONO a quelli ricalcolati. Ritorna (dict t -> motivo, stato) con stato
        'ok' | 'RIEPILOGO ASSENTE' | 'riga FILE NULLI ASSENTE'."""
        if not self.riepilogo():
            return {}, "RIEPILOGO ASSENTE"
        ln = self.riga_riepilogo("FILE NULLI")
        if not ln:
            return {}, "riga FILE NULLI ASSENTE"
        coda = ln.split("conteggio): ", 1)[1] if "conteggio): " in ln else ln.split("): ", 1)[-1]
        out = {}
        ms = list(re.finditer(r"\b(R26[89][a-d]) \(", coda))
        for i, m in enumerate(ms):
            fine = ms[i + 1].start() if i + 1 < len(ms) else len(coda)
            mot = coda[m.end():fine].rstrip(" |")
            out[m.group(1)] = mot[:-1] if mot.endswith(")") else mot
        return out, "ok"

    def tick_da(self):
        """P0-TICK (testa R268a par. 0): la data 'XAUUSD: ticks data begins from' e il caso.
        Priorita': --tick-da > LOG_TESTER > RIEPILOGO_ROUND_CORTI_D.txt. Ritorna (caso, data, fonte)."""
        if self.tick_da_forzata:
            d = self.tick_da_forzata
            return ((1 if d <= "2024.07.06" else 2), d, "riga di comando --tick-da " + d)
        rex = re.compile(r"XAUUSD: ticks data begins from (\d{4}\.\d{2}\.\d{2})")
        found = set()
        lg = os.path.join(self.root, "LOG_TESTER")
        if os.path.isdir(lg):
            for fn in sorted(os.listdir(lg)):
                try:
                    raw = open(os.path.join(lg, fn), "rb").read()
                except OSError:
                    continue
                txt = raw.decode("utf-16", errors="replace") if b"\x00" in raw[:4000] else raw.decode("utf-8", errors="replace")
                for m in rex.finditer(txt):
                    found.add(m.group(1))
        fonte = "LOG_TESTER/*.log"
        if not found:
            ln = self.riga_riepilogo("P0-TICK (par. 0):")
            for m in rex.finditer(ln):
                found.add(m.group(1))
            fonte = "RIEPILOGO_ROUND_CORTI_D.txt riga P0-TICK"
        if not found:
            return (3, None, "riga 'ticks data begins from' NON TROVATA in LOG_TESTER ne' nel RIEPILOGO")
        d = max(found)
        return ((1 if d <= "2024.07.06" else 2), d, fonte + " (" + " / ".join(sorted(found)) + ")")


def trova_raccolta(path):
    """classe 872: si contano PRIMA le cartelle attese. Zero -> si scende di UN livello se la raccolta
    e' li' (dichiarato), altrimenti errore: un NULLO e' un fatto sul file, non sul percorso."""
    def conta(p):
        return sum(1 for t in JOBS if os.path.isdir(os.path.join(p, "ROUND_" + t)))
    if conta(path) > 0:
        return path, None
    sub = [os.path.join(path, x) for x in sorted(os.listdir(path)) if os.path.isdir(os.path.join(path, x)) and conta(os.path.join(path, x)) > 0]
    if len(sub) == 1:
        return sub[0], "raccolta trovata UN livello sotto la cartella data: %s" % sub[0]
    raise SystemExit("NESSUNA cartella ROUND_R268x/R269x in %s%s: non e' la raccolta, NESSUN referto (classe 872)"
                     % (path, (" (e %d sottocartelle candidate: ambiguo)" % len(sub)) if sub else ""))


class File:
    """Un file del round letto dalla raccolta con i suoi cancelli di nullita'."""

    def __init__(self, rac, t):
        self.t, self.j, self.rac = t, JOBS[t], rac
        self.nullo = []          # motivi di nullita' (vuoto = file NON nullo)
        self.rows = []
        self.pt = {}             # magic -> deals
        self.k = {}              # magic -> k (classe 844)
        self.riga = {}           # magic -> riga del CSV
        self.lanciato = rac.lanciato(t)
        if not self.lanciato:
            return
        p = rac.p_csv(t)
        if not os.path.exists(p) or os.path.getsize(p) == 0:
            self.nullo.append("E0: CSV atteso %s ASSENTE o 0 byte" % os.path.basename(p))
            return
        self.rows = leggi_csv_round(p)
        n_att = 4 if t == "R268c" else 2
        if len(self.rows) != n_att or any(not re.match(r"^[1-9][0-9]*$", str(r.get("Trades", "")).strip()) for r in self.rows):
            self.nullo.append("E0: CSV %s con %d righe (attese %d) o Trades non > 0" % (os.path.basename(p), len(self.rows), n_att))
            return
        for mg in self.j["pt"] + self.j["pi"]:
            q = rac.p_pt(t, mg)
            if not os.path.exists(q):
                if mg in self.j["pt"]:
                    self.nullo.append("C0: per-trade %s MANCANTE" % mg)
                continue
            try:
                self.pt[mg] = leggi_pertrade(q)
            except (ValueError, KeyError) as e:
                self.nullo.append("C0: per-trade %s illeggibile (%s)" % (mg, e))
        for mg in self.j["pt"]:
            if mg not in self.pt:
                continue
            ds = self.pt[mg]
            r = cella(self.rows, self.j["ax"], mg)
            self.riga[mg] = r
            if r is None:
                self.nullo.append("cella %s=%s non trovata nel CSV" % (self.j["ax"], mg))
                continue
            if not ds or len(ds) != int(num(r["Trades"])):
                self.nullo.append("C0: per-trade %s righe %d contro Trades %s" % (mg, len(ds), r["Trades"]))
                continue
            dmin, dmax = dstr(ds[0]["t"]), dstr(ds[-1]["t"])
            if dmin < self.j["d0"] or dmax > self.j["d1"]:
                self.nullo.append("C0: per-trade %s chiusure %s -> %s fuori da %s -> %s" % (mg, dmin, dmax, self.j["d0"], self.j["d1"]))
            kk = k_commissione(ds, num(r["Profit"]))
            self.k[mg] = kk
            if self.j["kr"] == "oro" and not (K_BANDA[0] <= kk <= K_BANDA[1]):
                self.nullo.append("C0: k %.4f EUR/lotto fuori da [1,00 ; 3,00] (classe 844) sul per-trade %s" % (kk, mg))
            if self.j["kr"] == "dax" and abs(sum(d["net"] for d in ds) - num(r["Profit"])) > 0.05:
                self.nullo.append("C0: D30EUR |somma net - Profit| > 0,05 sul per-trade %s (classe 855)" % mg)
            l0 = sum(1 for d in ds if d["deal_type"] != self.j["sd"])
            if l0:
                self.nullo.append("L0: %d deal con deal_type diverso da %d sul per-trade %s (pin di lato NON arrivato)" % (l0, self.j["sd"], mg))
        # G1 gemelle
        if len(self.j["pt"]) == 2 and all(m in self.pt and self.riga.get(m) for m in self.j["pt"]):
            a, b = (self.riga[m] for m in self.j["pt"])
            for cn, tol in (("Trades", 1e-6), ("Profit Factor", 0.00005), ("Profit", 0.01), ("Equity DD %", 0.01)):
                if abs(num(a[cn]) - num(b[cn])) > tol + 1e-9:
                    self.nullo.append("G1: gemelle diverse su %s (%s contro %s)" % (cn, a[cn], b[cn]))
            da, db = (self.pt[m] for m in self.j["pt"])
            if len(da) != len(db):
                self.nullo.append("G1: per-trade gemelli con righe diverse (%d contro %d)" % (len(da), len(db)))
            else:
                for i, (x, y) in enumerate(zip(da, db)):
                    if (ct(x), x["pid"], x["deal_type"], x["vol"], x["price"]) != (ct(y), y["pid"], y["deal_type"], y["vol"], y["price"]) or abs(x["net"] - y["net"]) > 0.01:
                        self.nullo.append("G1: per-trade gemelli diversi alla riga %d" % (i + 1))
                        break
            if self.j["kr"] == "oro" and all(m in self.k for m in self.j["pt"]) and abs(self.k[self.j["pt"][0]] - self.k[self.j["pt"][1]]) > 0.01:
                self.nullo.append("G1: k diverso fra le gemelle (classe 844)")

    @property
    def ok(self):
        return self.lanciato and not self.nullo

    def mg0(self):
        return self.j["pt"][0]

    def r0(self):
        return self.riga.get(self.mg0())

    def d0(self):
        return self.pt.get(self.mg0(), [])

    def k0(self):
        return self.k.get(self.mg0(), float("nan"))


# ----------------------------------------------------------------------
#  Referto
# ----------------------------------------------------------------------
class Referto:
    def __init__(self):
        self.L = []
        self.esiti = OrderedDict()   # chiavi lette dall'autotest

    def add(self, *ls):
        self.L.extend(ls)

    def testo(self):
        return "\n".join(self.L) + "\n"


def fonte(rac, t, cosa):
    return "fonte: `%s`" % os.path.relpath(cosa, rac.root) if os.path.isabs(cosa) else "fonte: %s" % cosa


def lettura(rac):
    R = Referto()
    F = OrderedDict((t, File(rac, t)) for t in JOBS)
    nr, stato_nr = rac.nulli_riga()
    for t, mot in nr.items():
        if t in F and F[t].lanciato:
            F[t].nullo.append("NULLO DELLA RIGA (RIEPILOGO, classe 873): %s" % mot)
    R.add("# LETTURA DEL ROUND CORTI D -- R268 (oro 770402 solo long: tick contro OHLC, K1, curva DD(taglia), 22 anni) + R269 (oro flat 13:00 long/short, DAX long -1h)",
          "",
          "Generato da `backtest_pipeline/leggi_round_corti_d.py` sulla raccolta `%s`." % rac.root,
          "Criteri congelati PRIMA dei numeri: `prove/R268a_oro_long_TICK_testa.txt` par. 0/6/7, `prove/R268c_*` , `prove/R268d_*` par. 2-4, "
          "`prove/R269a_oro_770402_long_close13.txt` par. 4-5, `prove/R269c_dax_long_meno1h.txt` par. 4-5. "
          "Etichette: [MISURATO] dal CSV/per-trade della raccolta; [DERIVATO] da una formula della testa; [STIMA]; [NON MISURATO]. "
          "Posizioni contate per position_id; sull'oro ogni saldo toglie k x volume (classe 844). "
          "**R4 di tutte le teste: NESSUNA cella si promuove, NESSUNA taglia si propone** -- ogni riga di taglia qui sotto e' un riferimento, non una proposta.",
          "")
    for n in rac.note:
        R.add("- nota: " + n)
    if stato_nr != "ok":
        R.add("- **%s: i NULLI della riga (rc 1, classe 166 MOTORE DIVERSO DAL PIN, prova diversa dal pin, CSV vecchio) NON sono uniti: classe 166 NON VERIFICATA** (classe 873)" % stato_nr)
    else:
        R.add("- NULLI della riga (RIEPILOGO) uniti a quelli ricalcolati: %s" % (", ".join(sorted(nr)) or "nessuno"))
    # --- 0. i cancelli di nullita' (secondo strato, indipendente dalla riga): la tabella si scrive
    # ALLA FINE e si inserisce qui, perche' E0, G1c, S-FLAT e S1 annullano DOPO (cancello 27/09)
    i0 = len(R.L)
    # E0 contro-esempio tick == OHLC
    fa, fb = F["R268a"], F["R268b"]
    if fa.ok and fb.ok:
        ra, rb = fa.r0(), fb.r0()
        same = all(abs(num(ra[c]) - num(rb[c])) <= 1e-6 for c in ("Trades", "Profit", "Profit Factor", "Equity DD %"))
        if same:
            fa.nullo.append("E0 CONTRO-ESEMPIO: CSV tick == CSV OHLC al centesimo, il -Modello non e' arrivato")
            fb.nullo.append("E0 CONTRO-ESEMPIO: CSV tick == CSV OHLC al centesimo, il -Modello non e' arrivato")
            R.add("- E0 CONTRO-ESEMPIO SCATTATO: R268a e R268b identici al centesimo su Trades/Profit/PF/Equity DD -> R268a e R268b NULLI", "")
        else:
            R.add("- E0 ok: tick (R268a) e OHLC (R268b) differiscono (%s contro %s)" % (riga_txt(ra), riga_txt(rb)), "")
    lettura_r268(rac, F, R)
    lettura_r269(rac, F, R)
    T0 = ["## 0. Cancelli di nullita' (rifatti qui, indipendenti dalla pre-lettura della riga; tabella scritta a lettura FINITA: comprende E0, G1c, S-FLAT, S1)", "",
          "| file | lanciato | esito | motivi |", "|---|---|---|---|"]
    for t, f in F.items():
        if not f.lanciato:
            sal = rac.riga_riepilogo("FILE SALTATI")
            T0.append("| %s | NO | SALTATO / non nella raccolta | %s |" % (t, sal.replace("|", "/") if sal else "cartella ROUND_%s assente" % t))
        else:
            T0.append("| %s | si | %s | %s |" % (t, "NON NULLO" if f.ok else "**NULLO**", ("; ".join(f.nullo) or "E0 CSV%s, C0, L0, G1 ok" % JOBS[t]["sm"]).replace("|", "/")))
    T0 += ["", "fonte: `ROUND_<t>/%s_<simbolo>_<gamba><_ohlc>_<t>.csv` e `PERTRADE/abtg_trades_%s_<simbolo>_<magic>.csv`" % (EA, EA)]
    for t, f in F.items():
        if f.ok and f.j["kr"] == "oro" and f.k:
            T0.append("- k (classe 844) %s: %s EUR/lotto [MISURATO: (somma net - Profit)/lotti]" % (t, " / ".join("%s %.4f" % (m, f.k[m]) for m in f.j["pt"] if m in f.k)))
    T0.append("")
    R.L[i0:i0] = T0
    R.esiti["nulli"] = [t for t, f in F.items() if f.lanciato and not f.ok]
    R.add("", "---", "",
          "**Cosa resta a mano (non e' in questo script):** la decisione sull'ora del flat (R269), sull'orologio d'inverno delle sedie (R269c, entro il 25/10) "
          "e su ogni taglia (R268c/d) sono FIRME di Claudio; il P0-TICK caso (iii) resta [NON VERIFICATO] finche' il giornale dell'agente non si legge a mano; "
          "la commissione FTMO sull'oro e' [NON MISURATA] (il tester usa BCM).")
    return R


# ----------------------------------------------------------------------
#  R268
# ----------------------------------------------------------------------
def lettura_r268(rac, F, R):
    fa, fb, fc, fd = F["R268a"], F["R268b"], F["R268c"], F["R268d"]
    arcL = leggi_pertrade(rac.p_arc("795301")) if os.path.exists(rac.p_arc("795301")) else []
    arcLt = [d for d in arcL if dstr(d["t"]) >= "2024.07.06"]
    R.add("## 1. R268 -- G0 DEL BANCO (R268b contro il per-trade 795301 di R260a ristretto alle chiusure >= 2024.07.06)", "")
    R.add("- archivio 795301: %d righe, %d posizioni; tratto >= 2024.07.06: %d righe, %d posizioni (attesi 375/279 e 119/92) [MISURATO] -- fonte: `%s`"
          % (len(arcL), n_pos(arcL), len(arcLt), n_pos(arcLt), os.path.basename(rac.p_arc("795301"))))
    g0 = "NON VERIFICABILE"
    if not fb.ok:
        R.add("- R268b NULLO o non lanciato (%s): G0 NON VERIFICABILE" % ("; ".join(fb.nullo) or "non lanciato"))
    elif not arcL:
        R.add("- archivio 795301 ASSENTE: G0 NON VERIFICABILE")
    else:
        rb, pb, kb = fb.r0(), fb.d0(), fb.k0()
        g0n = int(num(rb["Trades"])) == len(arcLt) == 119
        mk = abbina(pb, arcLt)
        strut = (len(pb) == len(arcLt) == 119 and mk["nM"] == 119 and mk["nNoArc"] == 0 and mk["nNoNew"] == 0 and mk["nDt"] == 0 and mk["nGrp"] == 0)
        lot = lotto_chk(mk["prs"], pb, arcL, kb, K_ARC["795301"])
        lot_ok = lot["ko"] == 0 and lot["n"] == 92
        sol_ok = mk["nSol"] == 0
        g0 = "VERDE" if (g0n and strut and lot_ok and sol_ok) else "ROSSO"
        R.add("- R268b gemella %s: %s [MISURATO] -- fonte: `%s`" % (fb.mg0(), riga_txt(rb), os.path.relpath(rac.p_csv("R268b"), rac.root)),
              "- G0-n Trades = 119: %s" % ("ok" if g0n else "**KO** (%s)" % rb["Trades"]),
              "- G0-STRUTTURA (chiave close_time+price a molteplicita', classe 849): righe %d contro %d, abbinate %d, nuove senza archivio %d%s, archivio senza nuova %d%s, deal_type diversi %d, raggruppamenti discordi %d -> %s"
              % (len(pb), len(arcLt), mk["nM"], mk["nNoArc"], (" (prima: %s)" % mk["firstNo"]) if mk["firstNo"] else "", mk["nNoNew"],
                 (" (prima: %s)" % mk["firstNoNew"]) if mk["firstNoNew"] else "", mk["nDt"], mk["nGrp"], "ok" if strut else "**KO**"),
              "- G0-LOTTO (V' in [floor(V B'/B) - 0,01 ; floor((V+0,01) B'/B) + 0,01], k archivio 1,8113 / nuovo %.4f): posizioni %d (attese 92), fuori banda %d%s -> %s"
              % (kb, lot["n"], lot["ko"], (" (prima: %s)" % lot["first"]) if lot["first"] else "", "ok" if lot_ok else "**KO**"),
              "- G0-SOLDI (|net'/vol' - net/vol| <= 0,01/vol' + 0,01/vol): fuori tolleranza %d%s -> %s"
              % (mk["nSol"], (" (prima: %s)" % mk["firstSol"]) if mk["firstSol"] else "", "ok" if sol_ok else "**KO**"),
              "- **G0 %s**" % g0)
        if g0 == "VERDE":
            ddb = dd_chiuso(curva_saldo(pb, kb))
            R.add("- R268b contro le bande [STIMA Monte Carlo della testa par. 6.3, NON cancello]: Profit %s (banda 5.480 -> 6.145), PF in posizioni %s (1,481 -> 1,561), DD saldo chiuso con k %.4f %% (1,877 -> 2,093; picco %s fondo %s), Equity DD %% CSV %s (attesa >= saldo chiuso)"
                  % (rb["Profit"], fpf(stat_pos(ap.aggrega(pb, k_lotto=kb))["pf"]), ddb["dd"], dstr(ddb["pk"]) if ddb["pk"] else "-", dstr(ddb["fo"]) if ddb["fo"] else "-", rb["Equity DD %"]))
    R.esiti["g0_R268b"] = g0
    riga_g0 = rac.riga_riepilogo("G0 DEL BANCO")
    if riga_g0:
        R.add("- pre-lettura della riga (per confronto, NON decide qui): %s" % (("VERDE" if "G0 VERDE" in riga_g0 else "ROSSO" if "G0 ROSSO" in riga_g0 else "non riconosciuta")))
    R.add("")
    if g0 != "VERDE":
        msg = "R268 NON SI LEGGE: il G0 di R268b e' %s (il banco e' cambiato o non e' verificabile). Ne' lo scarto r, ne' K1, ne' la curva di R268c, ne' R268d si leggono. Cause per nome da separare: (a) spread in memoria (classe 394, OHLC), (b) storico M1 XAUUSD del PC, (c) binario (classe 166), (d) deposito o rischio non arrivati (G0-LOTTO)." % g0
        R.add("## R268 NON SI LEGGE", "", "**" + msg + "**", "")
        print("R268 NON SI LEGGE (G0 di R268b %s)" % g0)
        return
    # --- P0-TICK
    caso, tick, fonte_t = rac.tick_da()
    da = tick if caso == 2 else None
    R.add("## 2. R268 -- P0-TICK (testa par. 0)", "",
          "- caso (%s): ticks data begins from %s -- %s" % ({1: "i", 2: "ii", 3: "iii"}[caso], tick or "[NON TROVATA]", fonte_t))
    if caso == 1:
        R.add("- la gamba 2024.07.06 -> 2026.06.30 e' TUTTA a tick reali: si legge come scritto nella testa; decide l'Equity DD % del CSV.")
    elif caso == 2:
        R.add("- prima del %s MT5 GENERA i tick dalle M1: ogni lettura di R268a/b/c si fa sul PER-TRADE ristretto alle chiusure >= %s; il DD del CSV di R268a/c e' MISTO e NON decide: decide il DD a saldo chiuso con k sul tratto ristretto." % (tick, tick))
    else:
        R.add("- copertura dei tick [NON VERIFICATA]: si legge come (i) ma OGNI numero di R268a/c porta l'asterisco (*).")
    ast = " (*)" if caso == 3 else ""
    R.esiti["tick_caso"] = caso
    R.add("")
    # --- r
    R.add("## 3. R268 -- LO SCARTO r = DD_tick / DD_OHLC (testa par. 6.2)", "")
    r_lv = None
    if not (fa.ok and fb.ok):
        R.add("- NON VERIFICABILE: R268a o R268b NULLO (%s | %s)" % ("; ".join(fa.nullo) or "ok", "; ".join(fb.nullo) or "ok"))
    else:
        ra, rb = fa.r0(), fb.r0()
        pa, pb, ka, kb = fa.d0(), fb.d0(), fa.k0(), fb.k0()
        ddA, ddB = num(ra["Equity DD %"]), num(rb["Equity DD %"])
        r_csv = ddA / ddB if ddB > 0 else float("nan")
        chA, chB = dd_chiuso(curva_saldo(pa, ka, da=da)), dd_chiuso(curva_saldo(pb, kb, da=da))
        r_ch = chA["dd"] / chB["dd"] if chB["dd"] > 0 else float("nan")
        r_dec = r_ch if caso == 2 else r_csv
        r_lv = partizione_r(r_dec)
        posA = ap.aggrega([d for d in pa if not da or dstr(d["t"]) >= da], k_lotto=ka)
        qa = stat_pos(posA)
        R.add("| misura | R268a tick (%s) | R268b OHLC (%s) | r | fonte |" % (fa.mg0(), fb.mg0()), "|---|---:|---:|---:|---|",
              "| Equity DD %% del CSV [MISURATO]%s | %.4f | %.4f | %s | `%s`, `%s` colonna Equity DD %% |" % (ast, ddA, ddB, f3(r_csv), os.path.relpath(rac.p_csv("R268a"), rac.root), os.path.relpath(rac.p_csv("R268b"), rac.root)),
              "| DD a saldo chiuso con k (per-trade%s) [MISURATO]%s | %.4f (picco %s, fondo %s) | %.4f (picco %s, fondo %s) | %s | `PERTRADE/*_%s.csv`, `*_%s.csv`, k %.4f / %.4f |"
              % ((" ristretti alle chiusure >= " + da) if da else " interi", ast, chA["dd"], dstr(chA["pk"]) if chA["pk"] else "-", dstr(chA["fo"]) if chA["fo"] else "-",
                 chB["dd"], dstr(chB["pk"]) if chB["pk"] else "-", dstr(chB["fo"]) if chB["fo"] else "-", f3(r_ch), fa.mg0(), fb.mg0(), ka, kb),
              "", "- scarto in punti (Equity DD): %+.4f (si scrive, NON decide)" % (ddA - ddB),
              "- DECIDE %s: **r = %s -> %s**%s" % ("il saldo chiuso ristretto (caso ii)" if caso == 2 else "il CSV (caso %s)" % ("i" if caso == 1 else "iii, con asterisco"), f3(r_dec), r_lv, ast),
              "- R268a: %s [MISURATO], posizioni %d (banda attesa 84-100; SOTTO 150: MERITO SOSPESO per costruzione), PF in posizioni con k %s (si riporta, NON decide)%s"
              % (riga_txt(ra), qa["n"], fpf(qa["pf"]), (" [sul per-trade ristretto >= %s]" % da) if da else ""),
              "- previsione della testa: H-AFF con r 1,00-1,10.", "")
        R.esiti["r"] = r_dec
        R.esiti["r_lv"] = r_lv
        # --- K1
        R.add("## 4. R268 -- K1: LO STOP DAL LOTTO (classe 846, testa par. 6.4) sul per-trade di R268a", "")
        anc = ancore_q([d for d in pa if not da or dstr(d["t"]) >= da])
        qs = [q for _, _, q in anc]
        q_lo, q_hi = (min(qs), max(qs)) if qs else (0.0, 0.0)
        k1 = k1_lotto(posA, SaldoPrima(pa, ka), q_lo, q_hi)
        anom = [(dstr(t), pid, q) for t, pid, q in anc if not (0.5 <= q <= 1.5)]
        male, k1d = k1_diagnostica(posA, SaldoPrima(pa, ka), ancore_cond([d for d in pa if not da or dstr(d["t"]) >= da]))
        R.add("- ancore q (due deal d'uscita di pari volume a prezzi diversi nella stessa posizione, q = (net1 - net2)/((p1 - p2) x vol x 100)): %d, banda [q_basso ; q_alto] = [%s ; %s], mediana %s [MISURATO] (tratto di R260a: 12 ancore, 0,8393 -> 0,9663)%s"
              % (len(anc), f4(q_lo) if qs else "n.d.", f4(q_hi) if qs else "n.d.", f4(statistics.median(qs)) if qs else "n.d.",
                 ("; ancore ANOMALE fuori da [0,5 ; 1,5] (net piccoli arrotondati al centesimo: allargano la banda, si scrivono, la regola della testa e' [min ; max]): %s"
                  % ", ".join("%s pos %d q %.4f" % x for x in anom)) if anom else ""),
              "- stop in [ R/((V+0,01) x 100 x q_alto) ; R/(V x 100 x q_basso) ], R = saldo prima della posizione x 0,005 (saldo con k), V = somma dei volumi d'uscita [DERIVATO dal per-trade]",
              "- n %d posizioni; mediana degli stop MINIMI %s $, dei MASSIMI %s $; quota sotto frontiera 18,00 $ [pavimento ; tetto] = [%d ; %d] su %d = [%s%% ; %s%%]"
              % (k1["n"], f2(k1["smin"]), f2(k1["smax"]), k1["quota"][0], k1["quota"][1], k1["n"],
                 f2(100.0 * k1["quota"][0] / max(1, k1["n"])), f2(100.0 * k1["quota"][1] / max(1, k1["n"]))),
              "- **K1 %s**%s (attesa della testa: VERDE, mediana minimi 23,32 / massimi 27,98, quota [21%% ; 40%%]). K1 VERDE NON cancella la quota sotto frontiera: si scrive accanto." % (k1["verdetto"], ast),
              "- fonte: `PERTRADE/abtg_trades_%s_XAUUSD_%s.csv` (volumi, prezzi, net), deposito 100000, k %.4f" % (EA, fa.mg0(), ka))
        if male:
            R.add("- **ANCORE MAL CONDIZIONATE (classe 877)**: %d con amplificazione A > %.0f (prezzi d'uscita quasi uguali: la deriva del cambio fra le due uscite domina): %s. "
                  "K1 SENZA di loro [DIAGNOSTICA, soglia NON congelata, NON decide]: %s%s"
                  % (len(male), AMPLI_MAX, ", ".join("%s pos %d q %.4f |p1-p2| %.2f $ A %.0f" % x for x in male), k1d["verdetto"],
                     (" -- **DIVERGE dal verdetto congelato: K1 va portato a Claudio come SENSIBILE ALLE ANCORE, non come %s**" % k1["verdetto"].split(" (")[0])
                     if k1d["verdetto"].split(" (")[0] != k1["verdetto"].split(" (")[0] else " (stesso verdetto del congelato)"))
        else:
            R.add("- ancore mal condizionate (classe 877, A > %.0f): nessuna" % AMPLI_MAX)
        R.add("")
        R.esiti["k1"] = k1
        R.esiti["k1_diag"] = k1d
    # --- R268c
    R.add("## 5. R268c -- LA CURVA DD(TAGLIA) A TICK (testa par. 6.5, R268c)", "")
    if not fc.lanciato:
        R.add("- SALTATO (non lanciato per costo, classe 854): %s" % (rac.riga_riepilogo("FILE SALTATI") or "cartella ROUND_R268c assente"), "")
    elif not fc.ok:
        R.add("- NULLO: %s" % "; ".join(fc.nullo), "")
    else:
        r05 = cella(fc.rows, "InpRiskPercent", 0.5)
        g1c = "NON VERIFICABILE (R268a NULLO)"
        if fa.ok and r05 is not None:
            dif = [c for c in ("Trades", "Profit", "Profit Factor", "Equity DD %") if abs(num(r05[c]) - num(fa.r0()[c])) > 1e-6]
            g1c = "ok (cella 0,5 == CSV di R268a al centesimo)" if not dif else "**KO** cella 0,5 diversa da R268a su %s -> R268c NULLO" % ", ".join(dif)
        dds = [num(cella(fc.rows, "InpRiskPercent", f)["Equity DD %"]) if cella(fc.rows, "InpRiskPercent", f) else float("nan") for f in TAGLIE]
        trs = [cella(fc.rows, "InpRiskPercent", f)["Trades"] if cella(fc.rows, "InpRiskPercent", f) else "?" for f in TAGLIE]
        piatto = len(set(f4(x) for x in dds)) == 1
        mono = all(dds[i] < dds[i + 1] for i in range(3))
        tr_ok = len(set(trs)) == 1
        if "KO" in g1c:
            fc.nullo.append("G1c: cella 0,5 diversa da R268a al centesimo")
        if piatto:
            fc.nullo.append("G1c: asse PIATTO (DD uguali sulle 4 celle) = pin InpRiskPercent non arrivato")
        R.add("- G1c: %s; Trades sulle 4 celle: %s -> %s; DD distinti %d su 4 -> %s; monotono crescente: %s"
              % (g1c, "/".join(trs), "IDENTICI (R193b B5) ok" if len(set(trs)) == 1 else "**DIVERSI: il DD non si legge finche' non si capisce**",
                 len(set(f4(x) for x in dds)), "**PIATTO = pin InpRiskPercent NON MORDE -> R268c NULLO**" if piatto else "il pin morde", "si" if mono else "**NO (S2 di R193b: si indaga prima di leggere)**"))
        if not tr_ok and not piatto and "KO" not in g1c:
            R.add("- **Trades DIVERSI fra le celle (R193b B5): il DD di R268c NON si legge finche' non si capisce** (pavimento del lotto, margine o rifiuti). Si scrivono i DD, senza banda: %s"
                  % " | ".join("%.1f -> %s" % (f, f4(x)) for f, x in zip(TAGLIE, dds)))
            R.esiti["c_trades_diversi"] = True
        if tr_ok and not piatto and "KO" not in g1c:
            d05 = dds[0]
            R.add("", "| InpRiskPercent | Equity DD %% CSV [MISURATO]%s | pavimento 1-(1-d)^(f/0,5) [DERIVATO] | tetto (f/0,5) x d [INDICATIVO] | posizione |" % ast, "|---:|---:|---:|---:|---|")
            for f, ddv in zip(TAGLIE, dds):
                pav, tet = dd_taglia(d05, f)
                pos = "misurato (d)" if f == 0.5 else ("**SOTTO IL PAVIMENTO (contro il teorema: da capire)**" if ddv < pav - 1e-4 else ("sopra il tetto di %.2f punti (ammesso, si scrive)" % (ddv - tet) if ddv > tet + 1e-4 else "dentro la banda"))
                R.add("| %.1f | %.4f | %.2f | %.2f | %s |" % (f, ddv, pav, tet, pos))
            R.add("", "fonte: `%s` colonne InpRiskPercent, Equity DD %%, Trades" % os.path.relpath(rac.p_csv("R268c"), rac.root))
            if caso == 2:
                R.add("- P0-TICK caso (ii): i DD del CSV sono MISTI, la curva NON decide nulla, si scrive.")
            # per-trade 797203 identificato (classi 850/855)
            pc = fc.pt.get("797203")
            if pc and fa.ok:
                # testa R268a par. 7 G1c: SOLO la regola del k. La "stretta" di classe 855 (|Profit - somma|
                # <= 0,05) sull'oro vuol dire k = 0, fuori dal C0 [1 ; 3]: se torna, torna la cella SBAGLIATA
                # (cancello 27/09, classe 878).
                vs = sum(d["vol"] for d in pc)
                cand = [r for r in fc.rows if int(num(r["Trades"])) == len(pc) and vs > 0 and abs((sum(d["net"] for d in pc) - num(r["Profit"])) / vs - fa.k0()) <= 0.01]
                regola = "della testa G1c (righe = Trades e k entro +-0,01 dal k di R268a %.4f)" % fa.k0()
                dist = set((r["Trades"], r["Profit"]) for r in cand)
                if len(dist) > 1:
                    R.add("- per-trade 797203 AMBIGUO (classe 850): tornano celle diverse (%s), regola %s: NON si legge, il file NON e' nullo" % (", ".join("InpRiskPercent=%s" % r["InpRiskPercent"] for r in cand), regola))
                elif not cand:
                    R.add("- per-trade 797203 NON IDENTIFICATO contro nessuna cella (regola %s): NON letto, il file NON e' nullo" % regola)
                elif sum(1 for d in pc if d["deal_type"] != 1):
                    fc.nullo.append("L0: per-trade 797203 identificato con %d deal di deal_type diverso da 1 (pin di lato NON arrivato)" % sum(1 for d in pc if d["deal_type"] != 1))
                    R.add("- per-trade 797203 IDENTIFICATO ma **L0 KO** (deal_type diverso da 1): R268c NULLO (testa R268c, CANCELLI: L0 sul per-trade identificato)")
                else:
                    rr = cand[0]
                    kc = (sum(d["net"] for d in pc) - num(rr["Profit"])) / sum(d["vol"] for d in pc)
                    chc = dd_chiuso(curva_saldo(pc, kc, da=da))
                    fcell = num(rr["InpRiskPercent"])
                    R.add("- per-trade 797203 IDENTIFICATO (classe 850): cella InpRiskPercent=%s, regola %s, k %.4f; %d deal, %d posizioni, DD a saldo chiuso con k %.4f %% (picco %s, fondo %s)%s [MISURATO] -- contro la cella 0,5 a saldo chiuso: [DERIVATO] pavimento %.2f / tetto %.2f"
                          % (rr["InpRiskPercent"], regola, kc, len(pc), n_pos(pc), chc["dd"], dstr(chc["pk"]) if chc["pk"] else "-", dstr(chc["fo"]) if chc["fo"] else "-",
                             (" [ristretto >= %s]" % da) if da else "", *dd_taglia(dd_chiuso(curva_saldo(fa.d0(), fa.k0(), da=da))["dd"], fcell)))
                    R.esiti["c_cella"] = fcell
            R.add("- 2 anni, UN SOLO REGIME (toro dell'oro 2024-2026), merito sospeso: nessun valore dell'asse e' consigliato (R268c, classe 860).")
        R.add("")
    # --- R268d
    lettura_r268d(rac, F, R, r_lv, arcL)


def partizione_r(r):
    if r is None or math.isnan(r):
        return "NON CALCOLABILE"
    if r < 0.90:
        return "H-CONS (r < 0,90): l'OHLC SOVRASTIMA il DD di questo motore; i DD OHLC della sedia sono CONSERVATIVI (tetto, non pavimento): la premessa OHLC = limite inferiore cade QUI"
    if r < 1.10:
        return "H-AFF (0,90 <= r < 1,10): OHLC AFFIDABILE per il rischio (dentro il prior di casa 0,864-1,094)"
    if r <= 1.50:
        return "H-CORR (1,10 <= r <= 1,50): OHLC DA CORREGGERE, ogni DD OHLC di questa sedia (R260a 6,5 anni, R268d 22 anni) si moltiplica per r PRIMA di ogni tabella di taglia [DERIVATO]"
    return "H-NO (r > 1,50): OHLC NON USABILE per il rischio, nessuna taglia da un DD OHLC di questa sedia; resta solo il tick (2 anni, un regime)"


def livello_d(dd):
    if dd <= DD_R260A:
        return "D1"
    return "D2" if dd <= MURO_22 else "D3"


def lettura_r268d(rac, F, R, r_lv, arcL):
    fd = F["R268d"]
    R.add("## 6. R268d -- IL SOLO LONG SUI 22 ANNI, OHLC (testa R268d par. 2-4)", "")
    if not fd.ok:
        R.add("- NULLO o non lanciato: %s" % ("; ".join(fd.nullo) or "cartella ROUND_R268d assente"), "")
        return
    rd, pd, kd = fd.r0(), fd.d0(), fd.k0()
    dmin = dstr(pd[0]["t"])
    d0ok = dmin <= "2004.07.31"
    R.add("- D0 STORICO: prima chiusura %s -> %s [MISURATO]" % (dmin, "ok (<= 2004.07.31)" if d0ok else "**NON SODDISFATTO**: lo storico M1 del PC non arriva al 2004, la finestra vera parte da %s e si dichiara accanto a ogni numero" % dmin))
    m1 = rac.riga_riepilogo("R268d I 22 ANNI")
    if "history begins from" in m1:
        R.add("- giornale (dal RIEPILOGO): %s" % re.search(r"XAUUSD,M1: history begins from [^ ]+", m1).group(0))
    # G0d
    newT = [d for d in pd if dstr(d["t"]) >= "2020.01.01"]
    if arcL:
        mk = abbina(newT, arcL)
        strut = (len(newT) == 375 and mk["nM"] == 375 and mk["nNoArc"] == 0 and mk["nNoNew"] == 0 and mk["nDt"] == 0 and mk["nGrp"] == 0)
        g0d = "VERDE" if strut and mk["nSol"] == 0 else "ROSSO"
        R.add("- G0d tratto 2020-2026 (per-trade %s ristretto alle chiusure >= 2020.01.01: %d righe) contro 795301 intero (%d): abbinate %d, nuove senza archivio %d%s, archivio senza nuova %d%s, deal_type diversi %d, raggruppamenti discordi %d -> %s; G0-SOLDI fuori tolleranza %d -> %s ==> **G0d %s** (%s)"
              % (fd.mg0(), len(newT), len(arcL), mk["nM"], mk["nNoArc"], (" (prima: %s)" % mk["firstNo"]) if mk["firstNo"] else "", mk["nNoNew"],
                 (" (prima: %s)" % mk["firstNoNew"]) if mk["firstNoNew"] else "", mk["nDt"], mk["nGrp"], "VERDE-STRUTTURA" if strut else "**ROSSO-STRUTTURA**",
                 mk["nSol"], "ok" if mk["nSol"] == 0 else "**KO**", g0d,
                 "R268d e' la stessa sedia sui 22 anni" if g0d == "VERDE" else "R268d NON e' la stessa sedia: non si legge contro R260a ne' contro il contratto (eccezione ammessa per nome: nessuna)"))
    else:
        g0d = "NON VERIFICABILE"
        R.add("- G0d NON VERIFICABILE: archivio 795301 assente")
    R.esiti["g0d"] = g0d
    if g0d != "VERDE":
        R.add("- **R268d NON SI LEGGE** (G0d %s): i numeri qui sotto si scrivono per completezza, non si leggono." % g0d)
    # rischio
    ddE = num(rd["Equity DD %"])
    cur = curva_saldo(pd, kd)
    ch = dd_chiuso(cur)
    lvE, lvC = livello_d(ddE), livello_d(ch["dd"])
    posD = ap.aggrega(pd, k_lotto=kd)
    qd = stat_pos(posD)
    R.add("- gemella %s gamba 2004.06.20 -> 2026.06.30: %s [MISURATO], posizioni %d (tetto atteso ~1.234, centro [STIMA] ~946), PF in posizioni con k %s (si riporta: il VECCHIO giudica il RISCHIO, non il merito) -- fonte: `%s`, `PERTRADE/*_%s.csv`"
          % (fd.mg0(), riga_txt(rd), qd["n"], fpf(qd["pf"]), os.path.relpath(rac.p_csv("R268d"), rac.root), fd.mg0()),
          "- RISCHIO a 0,5%%: Equity DD %% CSV **%.4f** contro 4,5172 (R260a) e 10,0 (contratto R100, altra configurazione) -> **%s**; DD a saldo chiuso con k %.4f %% (picco %s, fondo %s) -> %s%s"
          % (ddE, lvE, ch["dd"], dstr(ch["pk"]) if ch["pk"] else "-", dstr(ch["fo"]) if ch["fo"] else "-", lvC,
             " = DIPENDE DALLA MISURA: decide l'EQUITY (contratto R100 criterio A)" if lvC != lvE else " (stessa ipotesi)"))
    if g0d != "VERDE":
        R.add("- D1/D2/D3 **NON SI LEGGE** (G0d %s: R268d non si legge contro R260a ne' contro il contratto, testa R268d par. 4). Per completezza il numero cadrebbe in %s." % (g0d, lvE))
    R.add("- %s" % {"D1": "D1: i 6,5 anni sono la finestra peggiore o pari, la taglia si legge su R260a",
                    "D2": "D2: i 22 anni sono PEGGIORI dei 6,5 e dentro il contratto della sedia [riferimento, altra configurazione]: la taglia si legge sui 22 anni (R193b A3/C4)",
                    "D3": "D3: il solo long a 0,5% sta FUORI dal contratto gia' alla taglia di oggi -> corsia RISCHIO per Claudio (firma del 18/08); nessuna taglia sopra 0,5 da qui"}[lvE]
          if g0d == "VERDE" else "(testo dell'ipotesi omesso: G0d non VERDE)")
    R.add("- previsione della testa: D2, centro ~8,5%.")
    R.esiti["d_lv"] = lvE if g0d == "VERDE" else "NON SI LEGGE"
    R.esiti["dd22"] = ddE
    # anno per anno + K1 per anno
    anc_all = ancore_q(pd)
    q_all = [q for _, _, q in anc_all]
    cond_all = ancore_cond(pd)
    male_y = defaultdict(list)
    for t, pid, q, dp, A in cond_all:
        if A > AMPLI_MAX:
            male_y[t.year].append((dstr(t), pid, q, dp, A))
    saldo = SaldoPrima(pd, kd)
    R.add("", "### 6.1 Anno per anno (posizioni per data di chiusura, netto meno k x volume) e K1 per anno (q dalle ancore dell'anno; <2 ancore = banda dell'intero file, segnato ^)", "",
          "| anno | posizioni | netto EUR | PF | ancore q | banda q | K1 stop mediano min/max $ | quota <18 $ [max<18 ; min<18] | K1 | ancore mal condizionate (classe 877) / K1 senza [DIAGNOSTICA] |",
          "|---:|---:|---:|---:|---:|---|---|---|---|---|")
    neg = []
    for y in range(pd[0]["t"].year, pd[-1]["t"].year + 1):
        py = [p for p in posD if p["t_last"].year == y]
        if not py:
            continue
        s = stat_pos(py)
        if s["net"] < 0:
            neg.append(str(y))
        qy = [q for t, _, q in anc_all if t.year == y]
        seg = ""
        if len(qy) < 2:
            qy, seg = q_all, "^"
        lo, hi = (min(qy), max(qy)) if qy else (0.0, 0.0)
        k1 = k1_lotto(py, saldo, lo, hi)
        if seg:
            my = [x for v in male_y.values() for x in v]
            buone = [q for _, _, q, _, A in cond_all if A <= AMPLI_MAX]
        else:
            my = male_y.get(y, [])
            buone = [q for t, _, q, _, A in cond_all if t.year == y and A <= AMPLI_MAX]
            if len(buone) < 2:
                buone = [q for _, _, q, _, A in cond_all if A <= AMPLI_MAX]
        dg = "nessuna"
        if my:
            k1y = k1_lotto(py, saldo, min(buone), max(buone)) if buone else dict(verdetto="NON LEGGIBILE")
            dg = "**%d** (%s) -> %s" % (len(my), ", ".join("q %.4f dp %.2f $" % (x[2], x[3]) for x in my), k1y["verdetto"].split(" (")[0])
        R.add("| %d | %d | %+.2f | %s | %d%s | [%s ; %s] | %s / %s | [%d ; %d] | %s | %s |"
              % (y, s["n"], s["net"], fpf(s["pf"]), len([1 for t, _, _ in anc_all if t.year == y]), seg, f4(lo) if qy else "n.d.", f4(hi) if qy else "n.d.",
                 f2(k1["smin"]), f2(k1["smax"]), k1["quota"][0], k1["quota"][1], k1["verdetto"].split(" (")[0], dg))
    R.add("", "anni negativi: %s. Sull'oro vecchio (400-1000 $) lo spread in memoria (classe 394, OHLC) e' quello di oggi: gli anni con stop mediano sotto 40 x spread pagano un costo GONFIATO; se il DD massimo cade li' una parte del DD e' costo del modello, si scrive e NON lo si toglie. [MISURATO sul per-trade, K1 DERIVATO dalla formula 846]" % (", ".join(neg) or "nessuno"))
    R.esiti["anni_neg"] = neg
    # finestra mobile
    b1, b2 = finestra_mobile(cur)
    R.add("", "### 6.2 La peggior finestra mobile di 12 mesi (testa R268d par. 3 (b)) [MISURATO a saldo chiuso con k]", "",
          "- (b1) DD massimo INTERNO a una finestra di 365 giorni (picco e fondo dentro): **%.4f %%**, picco %s, fondo %s" % (b1["dd"], dstr(b1["pk"]) if b1["pk"] else "-", dstr(b1["fo"]) if b1["fo"] else "-"),
          "- (b2) peggior netto su 365 giorni in %% del saldo d'inizio finestra: **%.4f %%**, dal %s al %s" % (b2["pct"], dstr(b2["da"]) if b2["da"] else "-", dstr(b2["a"]) if b2["a"] else "-"),
          "- contro il muro statico 10%% x (0,5/f) come RIFERIMENTO (non cancello): a 0,5%% 10,00 | 1,0%% 5,00 | 1,5%% 3,33 | 2,0%% 2,50 -> (b1) %s" % " | ".join("%.1f%% %s" % (f, "sopra" if b1["dd"] > 10.0 * 0.5 / f else "sotto") for f in TAGLIE))
    R.esiti["b1"] = b1["dd"]
    R.esiti["b2"] = b2["pct"]
    # tabella DD(taglia)
    corr = None
    if r_lv and r_lv.startswith("H-CORR"):
        corr = R.esiti.get("r")
    if r_lv and r_lv.startswith("H-NO"):
        R.add("", "### 6.3 Tabella DD(taglia): NON SI SCRIVE -- con H-NO nessun DD OHLC di questa sedia entra in una tabella di taglia (testa par. 6.2).")
    elif g0d != "VERDE":
        R.add("", "### 6.3 Tabella DD(taglia): NON SI SCRIVE -- G0d %s: R268d non e' la stessa sedia sui 22 anni (testa R268d par. 4)." % g0d)
    else:
        if not r_lv or r_lv.startswith("NON CALCOLABILE"):
            R.add("", "- **r NON DISPONIBILE** (R268a o R268b nullo): la tabella qui sotto e' OHLC NON corretto, e H-NO (che la vieterebbe) NON e' escluso: [NON VERIFICATO].")
        d_tab = ddE * corr if corr else ddE
        R.add("", "### 6.3 DD alle taglie 0,5 / 1,0 / 1,5 / 2,0 [DERIVATO con le DUE formule] contro muro 10% e S3 8% -- RIFERIMENTI, NESSUNA PROPOSTA", "",
              "d = Equity DD %% CSV dei 22 anni %.4f%s. Moltiplicativa 1-(1-d)^f (teorema, pavimento), lineare f x d (indicativo, tetto), f = taglia/0,5. OHLC M1: ogni DD e' un LIMITE INFERIORE. 8%% = S3 di R193b, congelata SOLO per la taglia 2,00 sulla sua sotto-finestra: qui riferimento."
              % (ddE, (" x r %.3f (H-CORR) = %.4f [DERIVATO]" % (corr, d_tab)) if corr else ""), "",
              "| taglia | moltiplicativa | lineare | contro muro 10% | contro 8% (S3) |", "|---:|---:|---:|---|---|")
        for f in TAGLIE:
            m, l = dd_taglia(d_tab, f)
            R.add("| %.1f%% | %.2f%% | %.2f%% | %s | %s |" % (f, m, l, "sotto" if l < MURO_22 else ("**sopra**" if m > MURO_22 else "a cavallo (moltiplicativa sotto, lineare sopra)"),
                                                          ("sotto" if l < S3 else ("**sopra**" if m > S3 else "a cavallo")) if abs(f - 2.0) < 1e-9
                                                          else "- (S3 congelata SOLO a 2,00: classe 860 b)"))
        R.add("", "Seconda misura (saldo chiuso con k, minorante): d %.4f -> %s" % (ch["dd"], " | ".join("%.1f%% %.2f-%.2f" % (f, *dd_taglia(ch["dd"] * (corr or 1.0), f)) for f in TAGLIE)),
              "Il contratto (22 anni, R100, straddle geometria R17) e' un'altra configurazione; la taglia UNIFORME del preset FTMO e ogni scelta di taglia sono una firma di Claudio (R4).")
    R.add("")


# ----------------------------------------------------------------------
#  R269
# ----------------------------------------------------------------------
def lettura_r269(rac, F, R):
    R.add("## 7. R269 -- L'ORO ESCE PRIMA DI NEW YORK? (flat 13:00 BCM; testa R269a par. 4-5)", "")
    for t in ("R269a", "R269b"):
        f, P = F[t], R269[t]
        R.add("### %s (%s, gemella %s, base %s)" % (t, P["lato"], P["mg"], P["arc"]), "")
        if not f.ok:
            R.add("- NULLO o non lanciato: %s" % ("; ".join(f.nullo) or "cartella assente"), "")
            continue
        rq, pq, kq = f.r0(), f.d0(), f.k0()
        arc = leggi_pertrade(rac.p_arc(P["arc"])) if os.path.exists(rac.p_arc(P["arc"])) else []
        arc_pre = [d for d in arc if d["t"].strftime("%H:%M:%S") < "13:00:00"]
        n1730 = sum(1 for d in pq if d["t"].strftime("%H:%M") == "17:30")
        n_dopo = sum(1 for d in pq if d["t"].strftime("%H:%M:%S") > "13:59:59")
        sflat = n1730 == 0 and n_dopo == 0
        if not sflat:
            f.nullo.append("S-FLAT: %d deal alle 17:30 e %d dopo le 13:59:59 = pin dell'ora del flat NON arrivato" % (n1730, n_dopo))
        npq = n_pos(pq)
        gpos = npq == P["pos"]
        new_pre = [d for d in pq if d["t"].strftime("%H:%M:%S") < "13:00:00"]
        mk = abbina(new_pre, arc_pre)
        gpre = (len(new_pre) == P["pre"] and mk["nM"] == P["pre"] and mk["nNoArc"] == 0 and mk["nNoNew"] == 0 and mk["nDt"] == 0 and mk["nSol"] == 0)
        g0 = "VERDE" if (gpos and gpre) else "ROSSO"
        trq = int(num(rq["Trades"]))
        R.add("- S-FLAT (nessun deal alle 17:30, nessuno dopo le 13:59:59): %d / %d -> %s" % (n1730, n_dopo, "ok" if sflat else "**KO = pin NON arrivato -> FILE NULLO**"),
              "- G0-POS posizioni %d contro %d -> %s | G0-PRE deal chiusi prima delle 13:00 contro i %d di %s (chiave close_time+price, deal_type, net/vol entro 0,01/vol+0,01/vol): nuovi %d, abbinati %d, senza archivio %d%s, archivio senza nuovo %d, deal_type diversi %d, soldi fuori %d -> %s ==> **G0 %s**"
              % (npq, P["pos"], "ok" if gpos else "**KO**", P["pre"], P["arc"], len(new_pre), mk["nM"], mk["nNoArc"], (" (prima: %s)" % mk["firstNo"]) if mk["firstNo"] else "",
                 mk["nNoNew"], mk["nDt"], mk["nSol"], "ok" if gpre else "**KO**", g0),
              "- N0 Trades %d contro %d -> %s" % (trq, P["deal"], "ok" if trq == P["deal"] else ("GIALLO: un parziale preso sul primo tick delle 13:00 (ManagePos prima del flat), si conta e NON annulla" if g0 == "VERDE" else "diverso (e G0 non verde)")))
        R.esiti["g0_" + t] = g0
        if not sflat:
            R.add("")
            continue
        pos = ap.aggrega(pq, k_lotto=kq, close_hm=(13, 0))
        qf = stat_pos(pos)
        q1 = stat_pos([p for p in pos if dstr(p["t_last"]) < "2023.04.01"])
        q2 = stat_pos([p for p in pos if dstr(p["t_last"]) >= "2023.04.01"])
        pfv = qf["pf"]
        p_lv = ("P1 (PF_13 >= %.2f): la sessione USA e' il rischio da tagliare" % P["p1"]) if pfv >= P["p1"] else \
               ("P2 (%.2f <= PF_13 < %.2f): rischio SIMMETRICO, taglia vinti e persi (NON distinguibile dalla base %.4f +-0,1: bootstrap sd ~0,2)" % (P["p2"], P["p1"], P["base_pf"])) if pfv >= P["p2"] else \
               ("P3 (PF_13 < %.2f): il motore e' il timestop del pomeriggio, il flat alle 13 lo spegne (il contro-esempio)" % P["p2"])
        ddq = num(rq["Equity DD %"])
        q_lv = ("Q1 (DD_13 <= %.2f = 0,75 x base): il flat taglia il rischio di almeno un quarto" % P["q1"]) if ddq <= P["q1"] else \
               ("Q2 (%.2f < DD_13 <= %.4f): lo taglia meno di un quarto" % (P["q1"], P["q2"])) if ddq <= P["q2"] else \
               ("Q3 (DD_13 > %.4f): non lo taglia" % P["q2"])
        q_esatto = 0.75 * P["q2"]
        if q_esatto < ddq <= P["q1"]:
            q_lv = ("Q1/Q2 AMBIGUO DELLA TESTA (classe 861): DD_13 %.4f sta fra 0,75 x base = %.4f (Q2 per la formula) e il numero scritto %.2f (Q1): "
                    "la testa scrive tutti e due, e l'arrotondamento %.4f -> %.2f e' dalla parte che PASSA. Si scrive cosi', non si sceglie" % (ddq, q_esatto, P["q1"], q_esatto, P["q1"]))
        if g0 != "VERDE":
            p_lv, q_lv = "NON SI LEGGE (G0 ROSSO) -- per completezza " + p_lv, "NON SI LEGGE (G0 ROSSO) -- per completezza " + q_lv
        ch = dd_chiuso(curva_saldo(pq, kq))
        stop = [p for p in pos if p["motivo"] == "STOP_PIENO"]
        ts = [p for p in pos if p["motivo"] == "TIMESTOP"]
        R.add("- %s [MISURATO] -- fonte: `%s`; k %.4f" % (riga_txt(rq), os.path.relpath(rac.p_csv(t), rac.root), kq),
              "- MERITO (posizioni %d >= 150: LEGGIBILE): PF in posizioni con k **%s** contro base %.4f -> **%s**; meta' al 2023.04.01: prima %d pos PF %s, seconda %d pos PF %s"
              % (qf["n"], fpf(pfv), P["base_pf"], p_lv, q1["n"], fpf(q1["pf"]), q2["n"], fpf(q2["pf"])),
              "- RISCHIO: Equity DD %% **%.4f** contro base %.4f -> **%s**; DD a saldo chiuso con k %.4f %% (picco %s, fondo %s)" % (ddq, P["q2"], q_lv, ch["dd"], dstr(ch["pk"]) if ch["pk"] else "-", dstr(ch["fo"]) if ch["fo"] else "-"),
              "- STOP PIENI RIMASTI (1 deal in perdita prima delle 13:00, autopsia --close 13:00) [DERIVATO dalla forma dei deal]: **%d** (attesi %d ESATTI dalla testa), netto %+.2f EUR; TIMESTOP alle 13:00: %d posizioni, netto %+.2f EUR, PF %s"
              % (len(stop), P["stop_att"], sum(p["net"] for p in stop), len(ts), sum(p["net"] for p in ts), fpf(pf_pos(ts))),
              "- previsione della testa: P2 e Q1.%s" % ("" if g0 == "VERDE" else " [G0 ROSSO: si scrive, NON si legge contro la base]"))
        R.esiti["p_lv_" + t] = p_lv[:2] if g0 == "VERDE" else "NON SI LEGGE"
        R.esiti["q_lv_" + t] = (q_lv[:2] if not q_lv.startswith("Q1/Q2") else "Q1/Q2") if g0 == "VERDE" else "NON SI LEGGE"
        R.esiti["stop_" + t] = len(stop)
        R.L += ap.tabella("Per MOTIVO d'uscita [DERIVATO]", pos, lambda p: p["motivo"], ["STOP_PIENO", "TP1_BE", "TP1_RUN", "TIMESTOP", "ALTRO"])
        R.L += ap.tabella("Per ANNO (posizioni per data di chiusura, net con k)", pos, lambda p: p["t_last"].year)
        R.L += ap.tabella("Per MESE (anno-mese)", pos, lambda p: p["t_last"].strftime("%Y-%m"))
        R.add("", "fonte: `PERTRADE/abtg_trades_%s_XAUUSD_%s.csv` via autopsia_pertrade.aggrega(k=%.4f, close 13:00)" % (EA, P["mg"], kq), "")
    lettura_r269c(rac, F, R)


def lettura_r269c(rac, F, R):
    f, P = F["R269c"], R269C_BASE
    R.add("### R269c (DAX LONG -1h, tick, tranche unica 2024.09.26 -> 2026.06.30, gemella %s; testa R269c par. 4-5)" % P["mg"], "")
    if not f.ok:
        R.add("- NULLO o non lanciato: %s" % ("; ".join(f.nullo) or "cartella assente"), "")
        return
    rq, pq = f.r0(), f.d0()
    arc = leggi_pertrade(rac.p_arc(P["arc"])) if os.path.exists(rac.p_arc(P["arc"])) else []
    same = len(pq) == len(arc) and all((ct(a), a["deal_type"], a["price"]) == (ct(b), b["deal_type"], b["price"]) for a, b in zip(pq, arc))
    n_dopo = sum(1 for d in pq if d["t"].strftime("%H:%M:%S") > "16:31:00")
    n_prima8 = sum(1 for d in pq if d["t"].strftime("%H:%M:%S") < "08:00:00")
    s1 = (not same) and n_dopo == 0
    if not s1:
        f.nullo.append("S1 SENTINELLA: %s = pin d'orario NON arrivato" % ("per-trade IDENTICO a 795401 (orologio d0)" if same else "%d uscite dopo le 16:31" % n_dopo))
    R.add("- S1 SENTINELLA DELL'OROLOGIO: per-trade %s da 795401, uscite dopo le 16:31: %d, uscite prima delle 08:00: %d -> %s"
          % ("IDENTICO" if same else "DIVERSO", n_dopo, n_prima8, "**KO = pin d'orario NON arrivato -> FILE NULLO**" if not s1 else ("GIALLO (nessuna uscita prima delle 08:00: attese)" if n_prima8 == 0 else "ok")))
    R.esiti["s1_R269c"] = s1
    if not s1:
        R.add("")
        return
    pos = ap.aggrega(pq, k_lotto=0.0, close_hm=(16, 30))
    est = [p for p in pos if ap.ora_legale(p["day"])]
    inv = [p for p in pos if not ap.ora_legale(p["day"])]
    se, si = stat_pos(est), stat_pos(inv)
    pfe = se["pf"]
    h_lv = ("H-ASTA (PF_estate >= 1,00): togliere l'asta dalla finestra porta l'estate al livello dell'inverno d0 (%.2f)" % P["pf_inverno_d0"]) if pfe >= 1.00 else \
           ("H-CAL (0,65 <= PF_estate < 1,00): la stagione e' CALENDARIO, l'orologio non cambia il long d'estate (d0 %.3f)" % P["pf_estate_d0"]) if pfe >= 0.65 else \
           "H-PEGGIO (PF_estate < 0,65): il pre-mercato e' PEGGIO dell'asta"
    stop = [p for p in pos if p["motivo"] == "STOP_PIENO"]
    n08 = sum(1 for p in stop if p["t_last"].hour == 8)
    n07 = sum(1 for p in stop if p["t_last"].hour == 7)
    ch = dd_chiuso(curva_saldo(pq, 0.0))
    ddq = num(rq["Equity DD %"])
    R.add("- %s [MISURATO], posizioni %d (attese ~72, SOTTO 150: MERITO SOSPESO per costruzione -> INDIZIO DEBOLE: la distanza H-CAL/H-ASTA 0,818 -> 1,00 e' meno di una sd del bootstrap 0,290) -- fonte: `%s`"
          % (riga_txt(rq), len(pos), os.path.relpath(rac.p_csv("R269c"), rac.root)),
          "- PF per STAGIONE (ora legale UE per data di chiusura, net per posizione, commissione 0): ESTATE %d pos PF **%s** (d0: %d pos, %.3f) -> **%s**; INVERNO (controllo) %d pos PF %s contro %.3f d0"
          % (se["n"], fpf(pfe), P["n_estate_d0"], P["pf_estate_d0"], h_lv, si["n"], fpf(si["pf"]), P["pf_inverno_d0"]),
          "- STOP PIENI: %d; nell'ora 08: %d, nell'ora 07: %d (d0: %s nell'ora 08). Si scrive, NON decide (testa par. 3: a -1h la posizione d'estate e' ancora viva alle 08:00)" % (len(stop), n08, n07, P["stop08_d0"]),
          "- RISCHIO a 1%%: Equity DD %% **%.4f** contro base d0 %.4f; DD a saldo chiuso %.4f %% (picco %s, fondo %s); a 2,00%% [DERIVATO, due formule]: %.2f-%.2f (equity) / %.2f-%.2f (saldo chiuso)"
          % (ddq, P["dd_d0"], ch["dd"], dstr(ch["pk"]) if ch["pk"] else "-", dstr(ch["fo"]) if ch["fo"] else "-", *dd_taglia(ddq, 2.0, base=1.0), *dd_taglia(ch["dd"], 2.0, base=1.0)),
          "- previsione della testa: H-CAL.")
    R.esiti["h_lv_R269c"] = h_lv.split(" ")[0]
    R.L += ap.tabella("Per MESE (anno-mese), -1h", pos, lambda p: p["t_last"].strftime("%Y-%m"))
    R.L += ap.tabella("Per ANNO x STAGIONE, -1h", pos, lambda p: "%d-%s" % (p["t_last"].year, "L" if ap.ora_legale(p["day"]) else "S"))
    if arc:
        posB = ap.aggrega(arc, k_lotto=0.0, close_hm=(17, 30))
        dA, dB = set(p["day"] for p in pos), set(p["day"] for p in posB)
        R.add("", "**Filtro S&P spostato (CorrBias legge la barra H1 05:00-06:00 invece della 06:00-07:00) e confronto per GIORNATA con 795401 (d0)**", "",
              "- giornate con posizione: -1h %d, d0 %d, in comune %d, solo -1h %d, solo d0 %d -> le giornate che CAMBIANO (permesso del filtro O box non rotto: il per-trade non li separa) sono al piu' %d [MISURATO]"
              % (len(dA), len(dB), len(dA & dB), len(dA - dB), len(dB - dA), len(dA ^ dB)),
              "- solo -1h: %s" % (", ".join(str(d) for d in sorted(dA - dB)) or "nessuna"),
              "- solo d0: %s" % (", ".join(str(d) for d in sorted(dB - dA)) or "nessuna"))
        R.L += ap.confronto_giorni(pos, "DAX LONG -1h", posB, "DAX LONG d0")
        R.esiti["giorni_cambiati_R269c"] = len(dA ^ dB)
    R.add("", "fonte: `PERTRADE/abtg_trades_%s_D30EUR_%s.csv` via autopsia_pertrade.aggrega(k=0, close 16:30); base `%s`" % (EA, P["mg"], os.path.basename(rac.p_arc("795401"))), "")


# ----------------------------------------------------------------------
#  Autotest: fixture costruite dagli archivi veri con i lotti riscalati come il tester
# ----------------------------------------------------------------------
CSV_COLS = ["Pass", "Profit", "Expected Payoff", "Profit Factor", "Recovery Factor", "Sharpe Ratio", "Equity DD %", "Trades",
            "InpMagic", "InpCloseHour", "InpCloseMin", "InpAllowLong", "InpAllowShort", "InpUseCorrelation", "InpRiskPercent"]


def riscala(deals_src, k, dep_new=DEPOSITO, dep_src=DEPOSITO, da=None, a=None, fatt_net=1.0, pid_off=0, shift=None, dt_map=None):
    """Riproduce il lotto come LotByRisk: V' = floor((V + 0,005) x B'/B x 100)/100 con B (saldo con k prima
    della posizione, dal deposito della corsa sorgente) e B' (saldo della corsa nuova); parziali
    floor(V'/2) (NormVol); net' = net/vol x vol' x fatt_net (fatt_net puo' essere una funzione del deal)."""
    by = OrderedDict()
    for d in sorted(deals_src, key=lambda x: (x["t"], x["pid"])):
        by.setdefault(d["pid"], []).append(d)
    sp = SaldoPrima(deals_src, k, dep_src)
    out, B = [], dep_new
    for pid, ds in by.items():
        t0 = ds[0]["t"]
        if (da and dstr(t0) < da) or (a and dstr(t0) > a):
            continue
        Bsrc = sp.prima(t0)
        V = sum(d["vol"] for d in ds)
        Vn = math.floor((V + 0.005) * B / Bsrc * 100.0 + 1e-9) / 100.0
        vols = []
        rest = Vn
        for i, d in enumerate(ds):
            if i == len(ds) - 1:
                vols.append(round(rest, 2))
            else:
                v = math.floor(rest / 2.0 * 100.0 + 1e-9) / 100.0
                vols.append(v)
                rest = round(rest - v, 2)
        for d, v in zip(ds, vols):
            fn = fatt_net(d) if callable(fatt_net) else fatt_net
            nd = dict(d)
            nd["vol"] = v
            nd["net"] = round(d["net"] / d["vol"] * v * fn, 2) if d["vol"] > 0 else 0.0
            nd["pid"] = d["pid"] + pid_off
            if shift:
                nd["t"] = d["t"] + shift
            if dt_map:
                nd["deal_type"] = dt_map
            out.append(nd)
        B += sum(x["net"] for x in out[-len(ds):]) - k * Vn
    out.sort(key=lambda x: (x["t"], x["pid"]))
    return out


def scrivi_pt(path, deals, magic, sym):
    with open(path, "w", encoding="utf-8", newline="") as fh:
        fh.write("close_time;symbol;magic;position_id;deal_type;volume;price;net_profit\n")
        for d in deals:
            fh.write("%s;%s;%s;%d;%d;%.2f;%.2f;%.2f\n" % (ct(d), sym, magic, d["pid"], d["deal_type"], d["vol"], d["price"], d["net"]))


def csv_row(deals, k, magic, risk=0.5, dd_eq=None, close=(17, 30), lato=1, corr=0):
    g = sum(d["net"] for d in deals if d["net"] > 0)
    l = -sum(d["net"] for d in deals if d["net"] <= 0)
    prof = sum(d["net"] for d in deals) - k * sum(d["vol"] for d in deals)
    dd = dd_chiuso(curva_saldo(deals, k))["dd"] if dd_eq is None else dd_eq
    return dict(zip(CSV_COLS, ["0", "%.2f" % prof, "%.5f" % (prof / max(1, len(deals))), "%.5f" % (g / l if l > 0 else 0.0), "1", "1", "%.4f" % dd, str(len(deals)),
                               magic, str(close[0]), str(close[1]), str(lato), str(1 - lato), str(corr), "%g" % risk]))


def scrivi_csv(path, rows):
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, "w", encoding="utf-8", newline="") as fh:
        w = csv.DictWriter(fh, fieldnames=CSV_COLS)
        w.writeheader()
        for r in rows:
            w.writerow(r)


def costruisci_fixture(root, arcdir, variante):
    """variante: 'pulito' | 'r13' | 'd3' | 'g0rosso'. Ritorna root."""
    os.makedirs(os.path.join(root, "PERTRADE"), exist_ok=True)
    A = lambda mg, s="XAUUSD": os.path.join(arcdir, "abtg_trades_%s_%s_%s.csv" % (EA, s, mg))
    arcL, arcS, arcD = leggi_pertrade(A("795301")), leggi_pertrade(A("795302")), leggi_pertrade(A("795401", "D30EUR"))
    kL, kS = K_ARC["795301"], K_ARC["795302"]
    import shutil
    for mg, s in (("795301", "XAUUSD"), ("795302", "XAUUSD"), ("795401", "D30EUR")):
        shutil.copy(A(mg, s), os.path.join(root, "archivio_CORTI_B_pertrade_%s.csv" % mg))

    def job(t, deals, magics, k, risk=0.5, dd_eq=None, close=(17, 30), lato=1, corr=0, sym="XAUUSD"):
        rows = []
        for m in magics:
            scrivi_pt(os.path.join(root, "PERTRADE", "abtg_trades_%s_%s_%s.csv" % (EA, sym, m)), deals, m, sym)
            rows.append(csv_row(deals, k, m, risk, dd_eq, close, lato, corr))
        j = JOBS[t]
        scrivi_csv(os.path.join(root, "ROUND_" + t, "%s_%s_%s%s_%s.csv" % (EA, j["s"], j["lg"], j["sm"], t)), rows)
        return rows

    # R268b: 795301 ristretto >= 2024.07.06, lotti riscalati da 100000 (= la simulazione della testa par. 6.3)
    b = riscala(arcL, kL, da="2024.07.06")
    if variante == "g0rosso":
        b[5]["price"] += 0.01   # un prezzo diverso: G0-STRUTTURA salta
    job("R268b", b, ["797202", "797252"], kL)
    # R268a: stessi deal con un rumore deterministico sui net (tick != OHLC), r ~ 1,0 oppure 1,3
    def rumore(d):
        return 1.0 + 0.003 * math.sin(d["pid"] * 1.7)
    if variante == "r13":
        target = 1.3
        ddb = dd_chiuso(curva_saldo(b, kL))["dd"]
        lo, hi = 1.0, 3.0
        for _ in range(60):
            g = (lo + hi) / 2.0
            a = riscala(arcL, kL, da="2024.07.06", fatt_net=lambda d, g=g: (g if d["net"] < 0 else 1.0) * rumore(d))
            r = dd_chiuso(curva_saldo(a, kL))["dd"] / ddb
            lo, hi = (g, hi) if r < target else (lo, g)
        a = riscala(arcL, kL, da="2024.07.06", fatt_net=lambda d, g=hi: (g if d["net"] < 0 else 1.0) * rumore(d))
    else:
        a = riscala(arcL, kL, da="2024.07.06", fatt_net=rumore)
    rows_a = job("R268a", a, ["797201", "797251"], kL)
    # R268c: cella 0,5 == R268a; 1,0/1,5/2,0 con Trades identici, DD dentro la banda; per-trade = cella 2,0 (x4)
    d05 = num(rows_a[0]["Equity DD %"])
    rows_c = [dict(rows_a[0], InpMagic="797203", InpRiskPercent="0.5")]
    for f in (1.0, 1.5, 2.0):
        pav, tet = dd_taglia(d05, f)
        pr = num(rows_a[0]["Profit"]) * f / 0.5
        rows_c.append(dict(rows_a[0], InpMagic="797203", InpRiskPercent="%g" % f, Profit="%.2f" % pr, **{"Equity DD %": "%.4f" % ((pav + tet) / 2.0)}))
    scrivi_csv(os.path.join(root, "ROUND_R268c", "%s_XAUUSD_OOS_R268c.csv" % EA), rows_c)
    c4 = [dict(d, vol=round(d["vol"] * 4, 2), net=round(d["net"] * 4, 2)) for d in a]
    scrivi_pt(os.path.join(root, "PERTRADE", "abtg_trades_%s_XAUUSD_797203.csv" % EA), c4, "797203", "XAUUSD")
    # R268d: 22 anni = tre blocchi sintetici pre-2020 (795301 spostato di -16/-10/-6 anni, prezzi NON riscalati:
    # fixture STRUTTURALE) + il tratto 2020-2026 = 795301 con i lotti riscalati dal saldo raggiunto
    blocchi = []
    for anni, lo_d, hi_d, off in ((16, "2004.06.20", "2010.06.30", 100000), (10, "2010.07.01", "2016.06.30", 200000), (6, "2016.07.01", "2019.12.31", 300000)):
        for d in arcL:
            t2 = d["t"].replace(year=d["t"].year - anni)
            if lo_d <= dstr(t2) <= hi_d:
                blocchi.append(dict(d, t=t2, pid=d["pid"] + off))
    blocchi.sort(key=lambda x: (x["t"], x["pid"]))
    d22 = []
    B = DEPOSITO
    for blocco, off in ((blocchi, 0), (arcL, 0)):
        src_dep = DEPOSITO
        sp = SaldoPrima(blocco, kL, src_dep)
        by = OrderedDict()
        for d in blocco:
            by.setdefault(d["pid"], []).append(d)
        for pid, ds in by.items():
            fn = 1.0
            if variante == "d3" and ds[0]["t"].year == 2013:
                fn = "stop"   # tutto il 2013 a stop pieno: -0,5% a posizione
            Bsrc = sp.prima(ds[0]["t"])
            V = sum(d["vol"] for d in ds)
            Vn = math.floor((V + 0.005) * B / Bsrc * 100.0 + 1e-9) / 100.0
            if fn == "stop":
                nd = dict(ds[-1], vol=Vn, net=round(-B * RISCHIO_ORO, 2))
                d22.append(nd)
                B += nd["net"] - kL * Vn
                continue
            rest, vols = Vn, []
            for i in range(len(ds)):
                if i == len(ds) - 1:
                    vols.append(round(rest, 2))
                else:
                    v = math.floor(rest / 2.0 * 100.0 + 1e-9) / 100.0
                    vols.append(v)
                    rest = round(rest - v, 2)
            for d, v in zip(ds, vols):
                nd = dict(d, vol=v, net=round(d["net"] / d["vol"] * v, 2))
                d22.append(nd)
            B += sum(x["net"] for x in d22[-len(ds):]) - kL * Vn
    d22.sort(key=lambda x: (x["t"], x["pid"]))
    job("R268d", d22, ["797204", "797254"], kL)
    # R269a / R269b: deal prima delle 13:00 identici (lotti riscalati), le posizioni vive alle 13:00 chiuse
    # con UN deal di flat alle 13:00:00; i net dei flat in perdita x0,55 e quelli in utile x fw, con fw
    # cercato perche' il PF in posizioni cada in [1,30 ; 1,40] (P2) -- il DD che ne esce e' misurato (Q1 atteso)
    for t, arc, k, mags, dt in (("R269a", arcL, kL, ["797211", "797261"], 1), ("R269b", arcS, kS, ["797212", "797262"], 0)):
        by = OrderedDict()
        for d in arc:
            by.setdefault(d["pid"], []).append(d)

        def flat13(fw):
            src = []
            for pid, ds in by.items():
                pre = [d for d in ds if d["t"].strftime("%H:%M:%S") < "13:00:00"]
                post = [d for d in ds if d["t"].strftime("%H:%M:%S") >= "13:00:00"]
                src += pre
                if post:
                    vol = sum(d["vol"] for d in post)
                    net = sum(d["net"] for d in post)
                    net *= fw if net > 0 else 0.55
                    src.append(dict(post[0], t=post[0]["t"].replace(hour=13, minute=0, second=0), vol=vol, net=round(net, 2), price=round(post[0]["price"] - 0.5, 2)))
            src.sort(key=lambda x: (x["t"], x["pid"]))
            return riscala(src, k)
        dd = None
        for fw in [x / 100.0 for x in range(85, 20, -1)]:
            cand = flat13(fw)
            pfv = stat_pos(ap.aggrega(cand, k_lotto=k, close_hm=(13, 0)))["pf"]
            if 1.30 <= pfv <= 1.40:
                dd = cand
                break
        if dd is None:
            raise SystemExit("fixture %s: nessun fw porta il PF in [1,30 ; 1,40]" % t)
        job(t, dd, mags, k, close=(13, 0), lato=dt)
    # R269c: 795401 con l'orologio -1h (per-trade DIVERSO da 795401, nessuna uscita dopo le 16:31), net e prezzi uguali
    c = [dict(d, t=d["t"] - timedelta(hours=1)) for d in arcD]
    job("R269c", c, ["797213", "797263"], 0.0, risk=1.0, lato=1, corr=1, sym="D30EUR")
    for t in JOBS:
        os.makedirs(os.path.join(root, "ROUND_" + t), exist_ok=True)
    with open(os.path.join(root, "RIEPILOGO_ROUND_CORTI_D.txt"), "w") as fh:
        fh.write("RIEPILOGO ROUND CORTI D (FIXTURE dell'autotest, variante %s)\nP0-TICK (par. 0): P0-TICK caso (i): XAUUSD: ticks data begins from 2024.07.05 <= 2024.07.06\nFILE SALTATI (non lanciati, NON nulli di catena): nessuno\nFILE NULLI (rc 1, motore o prova diversi dal pin, E0 CSV atteso non buono o contro-esempio tick==OHLC, asse o P0 diversi, C0 non buono, G1 o L0 falliti, S-FLAT o S1 non arrivati, G1c asse piatto; escono da OGNI conteggio): nessuno\n" % variante)
    return root


def autotest(fixture_dir=None):
    ok = True

    def check(cond, msg):
        nonlocal ok
        print(("  ok   " if cond else "  FAIL ") + msg)
        ok = ok and cond
    # (0) contro-esempi unitari
    check(abs(500.0 / (0.22 * C_ORO * 0.8767) - 25.92) < 0.01, "K1 unita' (classe 846): R 500, V 0,22, q 0,8767 -> 25,9 $ (la rovesciata darebbe 19,9)")
    pav05, tet05 = dd_taglia(0.5025, 0.5)
    pav2, tet2 = dd_taglia(0.5025, 2.0)
    check(abs(tet2 - 2.0100) < 1e-4 and pav2 < 2.0392 < tet2 + 0.03, "curva DD(taglia): -1R,+1R,-1R -> 2,0392 a 2,0 sopra il tetto 2,0100 (contro-esempio della testa), pavimento sotto")
    cur = [(datetime(2020, 1, 1) + timedelta(days=i * 30), s) for i, s in enumerate([100, 110, 90, 95, 120, 100, 130])]
    cur = [(t, s * 1000.0) for t, s in cur]
    b1, b2 = finestra_mobile(cur)
    # curva 100,110,90,95,120,100,130 (x1000) a passi di 30 giorni: DD interni 110->90 = 18,18 %, 120->100 = 16,67 %
    check(abs(b1["dd"] - 100.0 * 20 / 110) < 1e-9 and b1["pk"] == cur[1][0] and b1["fo"] == cur[2][0],
          "finestra mobile b1 = 18,1818 %% (110->90), picco %s fondo %s (non il 120->100 = 16,67)" % (dstr(b1["pk"]), dstr(b1["fo"])))
    # b2: saldo PRIMA del deal i (110 dopo il 31/01) -> 90 dopo il deal del 01/03 = -18,18 %; da 100 -> 90 sarebbe -10
    check(abs(b2["pct"] - 100.0 * (90 - 110) / 110) < 1e-9 and b2["da"] == cur[2][0],
          "finestra mobile b2 = -18,1818 %% dal saldo 110 prima del deal del %s (non -10 dal 100)" % dstr(b2["da"]))
    cur2 = cur + [(datetime(2022, 1, 1), 60000.0)]
    b1b, _ = finestra_mobile(cur2)
    check(abs(b1b["dd"] - 100.0 * 20 / 110) < 1e-9, "b1 NON vede il crollo a 60 se il picco 130 sta fuori dai 365 giorni (picco e fondo dentro)")
    check(dd_chiuso(cur2)["dd"] > 50, "mentre il DD intero lo vede (%.2f %%)" % dd_chiuso(cur2)["dd"])
    # (0b) contro-esempi del cancello del 27/09 (classi 872 e caso ii di P0-TICK)
    d_a = dict(t=datetime(2024, 9, 25, 17, 30), pid=1, net=100.0, vol=0.1, price=1.0, deal_type=1)
    d_b = dict(t=datetime(2024, 9, 26, 0, 0, 1), pid=2, net=-50.0, vol=0.1, price=1.0, deal_type=1)
    cz = curva_saldo([d_a, d_b], 1.8, da="2024.09.26")
    check(len(cz) == 1 and abs(cz.s0 - 100099.82) < 1e-6 and abs(dd_chiuso(cz)["dd"] - 100.0 * 50.18 / 100099.82) < 1e-9,
          "caso (ii): la curva ristretta parte dal saldo VERO alla data (100099,82), la chiusura del giorno stesso e' dentro")
    if os.path.isdir(ARCHIVI_REPO):
        a795 = leggi_pertrade(os.path.join(ARCHIVI_REPO, "abtg_trades_%s_XAUUSD_795301.csv" % EA))
        p795, s795 = ap.aggrega(a795, k_lotto=K_ARC["795301"]), SaldoPrima(a795, K_ARC["795301"])
        q795 = [q for _, _, q in ancore_q(a795)]
        kc = k1_lotto(p795, s795, min(q795), max(q795))
        male, kd = k1_diagnostica(p795, s795, ancore_cond(a795))
        check(len(male) == 2 and kc["verdetto"].startswith("NON DECISO") and kd["verdetto"].startswith("ROSSO"),
              "classe 877 sul 795301 VERO (2020-2026): 2 ancore a prezzi distanti 0,03 $ (q 0,4348 e 1,1067) fanno NON DECISO un K1 che senza di loro e' ROSSO -> la diagnostica lo dice")
    # (1) fixture dagli archivi veri
    if not os.path.isdir(ARCHIVI_REPO):
        print("  SKIP archivi CORTI B non trovati in %s" % ARCHIVI_REPO)
        print("AUTOTEST " + ("PASS" if ok else "FAIL"))
        return 0 if ok else 1
    base = fixture_dir or tempfile.mkdtemp(prefix="lettori_d_")
    print("  fixture in %s" % base)
    esiti = {}
    for var in ("pulito", "r13", "d3", "g0rosso"):
        root = costruisci_fixture(os.path.join(base, "ROUND_CORTI_D_" + var), ARCHIVI_REPO, var)
        rac = Raccolta(root)
        R = lettura(rac)
        with open(os.path.join(root, "REFERTO_LETTURA.md"), "w", encoding="utf-8") as fh:
            fh.write(R.testo())
        esiti[var] = R.esiti
    E = esiti["pulito"]
    check(E.get("g0_R268b") == "VERDE", "pulito: G0 di R268b VERDE (lotti riscalati come il tester, 119 deal / 92 posizioni)")
    check(E.get("tick_caso") == 1, "pulito: P0-TICK caso (i) letto dal RIEPILOGO")
    check(0.95 <= E.get("r", 0) <= 1.05 and E.get("r_lv", "").startswith("H-AFF"), "pulito: r %.3f -> H-AFF" % E.get("r", 0))
    k1 = E.get("k1", {})
    check(k1.get("n") == 92 and k1.get("verdetto", "").startswith("VERDE") and 20 <= k1.get("smin", 0) <= 30, "pulito: K1 n 92, VERDE, mediana minimi %.2f (testa: 23,32 sui lotti di R260a)" % k1.get("smin", 0))
    check(E.get("c_cella") == 2.0, "pulito: per-trade 797203 IDENTIFICATO come cella 2,0 (regola della testa G1c sul k)")
    check(E.get("g0d") == "VERDE" and E.get("d_lv") in ("D1", "D2"), "pulito: G0d VERDE sul tratto 2020-2026 e D-livello %s" % E.get("d_lv"))
    check(E.get("g0_R269a") == "VERDE" and E.get("stop_R269a") == 15, "pulito: R269a G0 VERDE, stop pieni rimasti 15 (attesi 15 ESATTI)")
    check(E.get("p_lv_R269a") == "P2" and E.get("q_lv_R269a") == "Q1", "pulito: R269a P2 / Q1 (fixture: flat in perdita x0,55, in utile x fw cercato per PF in [1,30 ; 1,40])")
    check(E.get("g0_R269b") == "VERDE" and E.get("stop_R269b") == 9, "pulito: R269b G0 VERDE, stop pieni rimasti 9")
    check(E.get("s1_R269c") is True and E.get("h_lv_R269c") == "H-CAL", "pulito: R269c S1 ok (orologio -1h), H-CAL (PF estate d0 0,818 conservato)")
    check(E.get("giorni_cambiati_R269c") == 0, "pulito: confronto per giornata con 795401: 0 giornate cambiate (stessi giorni, -1h)")
    E = esiti["r13"]
    check(1.28 <= E.get("r", 0) <= 1.32 and E.get("r_lv", "").startswith("H-CORR"), "r13: r %.3f -> H-CORR (perdite gonfiate per bisezione)" % E.get("r", 0))
    E = esiti["d3"]
    check(E.get("b1", 0) > 10.0 and E.get("d_lv") == "D3" and "2013" in E.get("anni_neg", []), "d3: finestra mobile b1 %.2f %% > 10, D3, 2013 negativo" % E.get("b1", 0))
    E = esiti["g0rosso"]
    check(E.get("g0_R268b") == "ROSSO" and "r" not in E and "k1" not in E, "g0rosso: G0 ROSSO -> 'R268 NON SI LEGGE', niente r ne' K1")
    check(E.get("g0_R269a") == "VERDE", "g0rosso: R269 si legge lo stesso")
    # (1b) classe 873: un NULLO che solo la riga vede (MOTORE DIVERSO DAL PIN) si unisce; classe 872: cartella padre
    rp = os.path.join(base, "ROUND_CORTI_D_pulito", "RIEPILOGO_ROUND_CORTI_D.txt")
    orig = open(rp).read()
    with open(rp, "w") as fh:
        fh.write(orig.replace("conteggio): nessuno", "conteggio): R269c (MOTORE DIVERSO DAL PIN) | R268d (CSV VECCHIO (scritto prima del job))"))
    R = lettura(Raccolta(os.path.join(base, "ROUND_CORTI_D_pulito")))
    check(set(R.esiti.get("nulli", [])) == {"R269c", "R268d"} and "h_lv_R269c" not in R.esiti and "d_lv" not in R.esiti,
          "classe 873: R269c 'MOTORE DIVERSO DAL PIN' e R268d 'CSV VECCHIO' dal RIEPILOGO -> NULLI anche qui, niente H-* ne' D-*")
    with open(rp, "w") as fh:
        fh.write(orig)
    try:
        rr, nota = trova_raccolta(base)
        check(False, "classe 872: la cartella padre con 4 raccolte doveva fermarsi (ambigua), ha preso %s" % rr)
    except SystemExit:
        check(True, "classe 872: cartella padre con 4 raccolte candidate -> errore, NESSUN referto")
    solo = tempfile.mkdtemp(prefix="padre_")
    os.makedirs(os.path.join(solo, "ROUND_CORTI_D_x", "ROUND_R268b"))
    rr, nota = trova_raccolta(solo)
    check(rr.endswith("ROUND_CORTI_D_x") and nota, "classe 872: zip scompattato in una sottocartella -> si scende di UN livello e lo si dichiara")
    # (2) caso (ii): --tick-da sposta la lettura sul saldo chiuso ristretto
    rac = Raccolta(os.path.join(base, "ROUND_CORTI_D_pulito"), tick_da="2024.09.26")
    R = lettura(rac)
    check(R.esiti.get("tick_caso") == 2 and "r" in R.esiti, "caso (ii) con --tick-da 2024.09.26: r deciso dal saldo chiuso ristretto (%.3f)" % R.esiti.get("r", 0))
    print("AUTOTEST " + ("PASS" if ok else "FAIL"))
    return 0 if ok else 1


# ----------------------------------------------------------------------
def main():
    apr = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    apr.add_argument("raccolta", nargs="?", help="cartella ROUND_CORTI_D_<data> estratta dallo zip")
    apr.add_argument("--md", default=None, help="scrive il referto qui (default: stdout)")
    apr.add_argument("--tick-da", default=None, help="forza la data 'ticks data begins from' (P0-TICK)")
    apr.add_argument("--archivi", default=None, help="cartella con i per-trade 795301/795302/795401 se non nella raccolta")
    apr.add_argument("--autotest", action="store_true")
    apr.add_argument("--fixture-dir", default=None, help="dove costruire le fixture dell'autotest (default: cartella temporanea)")
    a = apr.parse_args()
    if a.tick_da and not re.match(r"^\d{4}\.\d{2}\.\d{2}$", a.tick_da):
        apr.error("--tick-da vuole AAAA.MM.GG con i PUNTI (es. 2024.09.26): il confronto e' fra stringhe, un altro formato leggerebbe una finestra sbagliata")
    if a.autotest:
        sys.exit(autotest(a.fixture_dir))
    if not a.raccolta or not os.path.isdir(a.raccolta):
        apr.error("serve la cartella della raccolta (o --autotest)")
    root, nota = trova_raccolta(a.raccolta)
    rac = Raccolta(root, a.archivi, a.tick_da)
    if nota:
        rac.note.append(nota)
    R = lettura(rac)
    if a.md:
        with open(a.md, "w", encoding="utf-8") as fh:
            fh.write(R.testo())
        print("scritto %s (%d righe)" % (a.md, len(R.L)))
    else:
        sys.stdout.write(R.testo())


if __name__ == "__main__":
    main()
