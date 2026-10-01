#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
audit_rischio_flotta.py -- 01/10/2026

Misure per report/AUDIT_RISCHIO_FLOTTA_2026-10-01.md (criteri congelati nel par. 0
di quel file, commit e1e5171a, PRIMA di questi numeri).

Legge SOLO file del repo:
  - Report Cronistorico MT5 (xlsx): challenge FTMO 541452707, trial 1514806751,
    piccolo BCM 50503392;
  - data/statements/trades_100k.csv (100k BCM, senza SL iniziale);
  - per-trade OOS dei contratti;
  - il Monte Carlo di casa (mc_challenge_ftmo.py), IMPORTATO e non modificato.

Non lancia niente, non scrive niente fuori dalla console.
USO:  python3 backtest_pipeline/audit_rischio_flotta.py [sezione]
      sezioni: q1 q2 q3 q4 tutto (default tutto)
"""
import collections, csv, datetime as dt, math, os, random, statistics, sys, warnings

warnings.filterwarnings("ignore")
QUI = os.path.dirname(os.path.abspath(__file__))
REPO = os.path.dirname(QUI)
sys.path.insert(0, QUI)

F_CHALL = os.path.join(REPO, "data/statements/FTMO_541452707_cronistorico_2026-09-30.xlsx")
F_TRIAL = os.path.join(REPO, "data/statements/ReportHistory_trial_1514806751_2026-10-01.xlsx")
F_PICC = os.path.join(REPO, "data/statements/ReportHistory_50503392_2026-10-01.xlsx")
F_100K = os.path.join(REPO, "data/statements/trades_100k.csv")

SOGLIA_STOP_R = -0.70          # RFWD_CRITERI.md, SOGLIA_STOP_R
# ora del report (intestazione "Data:") = chiusura convenzionale delle posizioni ancora aperte
T_REPORT = {"TRIAL": dt.datetime(2026, 10, 1, 16, 45), "CHALL": dt.datetime(2026, 9, 30, 9, 10),
            "PICC": dt.datetime(2026, 10, 1, 6, 38)}

UNDERLYING = {
    "GER40.cash": "DAX", "D30EUR": "DAX",
    "US30.cash": "DOW", "U30USD": "DOW",
    "US100.cash": "NASDAQ", "NASUSD": "NASDAQ",
    "XAUUSD": "ORO", "225JPY": "NIKKEI", "JP225.cash": "NIKKEI",
}


def und(sym):
    return UNDERLYING.get(sym, sym)


def ts(s):
    return dt.datetime.strptime(str(s).strip(), "%Y.%m.%d %H:%M:%S")


def num(x):
    if x is None or x == "":
        return None
    if isinstance(x, (int, float)):
        return float(x)
    s = str(x).strip().replace(" ", "")
    if "/" in s:
        s = s.split("/")[0]
    try:
        return float(s)
    except ValueError:
        return None


# ------------------------------------------------------------------ seat map
def sedia(comment, sym, conto):
    """Sedia dal commento dell'ordine d'apertura (par. 0.2 dei criteri)."""
    c = (comment or "").strip()
    if not c:
        return "MANUALE"
    u = c.upper()
    if u.startswith("MAXMIN DAX SHORT"):
        return "770411"
    if u.startswith("DAX APERTURA EU RETEST") and und(sym) == "DAX":
        if conto in ("CHALL", "TRIAL"):
            return "770101" if u.endswith("BUY") else "770105"
        return "770101/5_RETEST"
    if u.startswith("EMA200 DOW"):
        return "771531"
    if u.startswith("SUPERWAVE DOW H1") or u.startswith("SW DOW H1"):
        return "770511"
    if u.startswith("DOW APERTURA US") and und(sym) == "DOW":
        return "770202"
    if u.startswith("NASDAQ APERTURA US") and und(sym) == "NASDAQ":
        return "770260"
    if u.startswith("BULGE_V520_FT_"):
        return "BULGE_A"
    if u.startswith("BULGE_VIOLA_"):
        return "BULGE_B"
    if u.startswith("ORB OTT"):
        return "ORB"
    return "ALTRO:" + c.split(" ")[0][:20]


# ------------------------------------------------------------------ parser
def leggi_report(path, conto):
    import openpyxl
    wb = openpyxl.load_workbook(path, read_only=True, data_only=True)
    rows = list(wb.worksheets[0].iter_rows(values_only=True))
    sez = None
    pos, ordini, affari = [], {}, []
    for r in rows:
        if not r or r[0] is None:
            continue
        h = r[0]
        if h in ("Posizioni", "Ordini", "Affari", "Posizioni aperte", "Ordini attivi", "Risultati"):
            sez = h
            continue
        if h in ("Ora", "Orario di Apertura"):
            continue
        if sez == "Posizioni":
            try:
                t0 = ts(r[0])
            except Exception:
                continue
            pos.append(dict(id=int(r[1]), sym=r[2], side=r[3], vol=num(r[4]), t_open=t0,
                            p_open=num(r[5]), sl_pos=num(r[6]), tp_pos=num(r[7]),
                            t_close=ts(r[8]), p_close=num(r[9]), comm=num(r[10]) or 0.0,
                            swap=num(r[11]) or 0.0, profit=num(r[12]) or 0.0, conto=conto))
        elif sez == "Posizioni aperte":
            # posizione ancora aperta all'ora del report: chiusura = ora del report, netto = flottante
            try:
                t0 = ts(r[0])
            except Exception:
                continue
            pos.append(dict(id=int(r[1]), sym=r[2], side=r[3], vol=num(r[4]), t_open=t0,
                            p_open=num(r[5]), sl_pos=num(r[6]), tp_pos=num(r[7]),
                            t_close=T_REPORT.get(conto, t0), p_close=num(r[8]), comm=0.0,
                            swap=num(r[9]) or 0.0, profit=num(r[11]) or 0.0, conto=conto, aperta=True))
        elif sez == "Ordini":
            try:
                ts(r[0])
            except Exception:
                continue
            ordini[int(r[1])] = dict(tipo=r[3], prezzo=r[5], sl=num(r[6]), tp=num(r[7]),
                                     stato=r[9], comm=r[11], t=ts(r[0]))
        elif sez == "Affari":
            try:
                t = ts(r[0])
            except Exception:
                continue
            if r[4] not in ("in", "out", "in/out"):
                continue
            affari.append(dict(t=t, deal=r[1], sym=r[2], tipo=r[3], dir=r[4], vol=num(r[5]),
                               price=num(r[6]), order=r[7], comm=num(r[8]) or 0.0,
                               swap=num(r[10]) or 0.0, profit=num(r[11]) or 0.0,
                               bal=num(r[12]), commento=r[13]))
    # deal d'ingresso: commento, saldo
    din = {}
    for a in affari:
        if a["dir"] == "in":
            din[a["order"]] = a
    # deal d'uscita -> posizione (stesso simbolo, verso opposto, dentro [open, close], volume)
    outs = sorted([a for a in affari if a["dir"] == "out"], key=lambda a: a["t"])
    rest = {p["id"]: p["vol"] for p in pos}
    p_by = sorted(pos, key=lambda p: p["t_open"])
    for p in pos:
        p["outs"] = []
    for a in outs:
        cands = [p for p in p_by if p["sym"] == a["sym"] and
                 ((p["side"] == "buy" and a["tipo"] == "sell") or (p["side"] == "sell" and a["tipo"] == "buy")) and
                 p["t_open"] <= a["t"] <= p["t_close"] and rest[p["id"]] >= a["vol"] - 1e-9]
        if not cands:
            continue
        exact = [p for p in cands if p["t_close"] == a["t"] and abs(rest[p["id"]] - a["vol"]) < 1e-9]
        p = exact[0] if exact else cands[0]
        rest[p["id"]] -= a["vol"]
        p["outs"].append(a)
    for p in pos:
        o = ordini.get(p["id"], {})
        d = din.get(p["id"], {})
        p["comment"] = (o.get("comm") or d.get("commento") or "")
        p["order_type"] = o.get("tipo")
        p["sl0"] = o.get("sl")
        p["sl_src"] = "ORDINE"
        if not p["sl0"]:
            p["sl0"] = p["sl_pos"] if p["sl_pos"] else None
            p["sl_src"] = "SL_DA_POSIZIONE" if p["sl0"] else "SENZA_SL"
        p["bal_open"] = d.get("bal")
        p["net"] = p["profit"] + p["comm"] + p["swap"]
        p["dir"] = 1 if p["side"] == "buy" else -1
        p["und"] = und(p["sym"])
        p["sedia"] = sedia(p["comment"], p["sym"], conto)
        p["n_out"] = len(p["outs"])
        p["exit"] = ""
        if p["outs"]:
            c = (p["outs"][-1].get("commento") or "")
            p["exit"] = "sl" if c.startswith("[sl") else ("tp" if c.startswith("[tp") else "altro")
    # valore EUR per unita' di prezzo per lotto
    vpp = collections.defaultdict(list)
    for p in pos:
        dpx = (p["p_close"] - p["p_open"]) * p["dir"]
        if p["vol"] and abs(dpx) > 0 and p["profit"] != 0:
            v = p["profit"] / (dpx * p["vol"])
            if v > 0:
                p["vpp"] = v
                vpp[p["sym"]].append(v)
    med = {s: statistics.median(v) for s, v in vpp.items()}
    for p in pos:
        if "vpp" not in p or not _plaus(p, med):
            p["vpp"] = med.get(p["sym"])
        if p["sl0"] and p["vpp"]:
            p["risk"] = abs(p["p_open"] - p["sl0"]) * p["vol"] * p["vpp"]
        else:
            p["risk"] = None
        p["R"] = p["net"] / p["risk"] if p["risk"] else None
        p["aperta"] = p.get("aperta", False)
        p["stop"] = (not p["aperta"]) and (p["R"] is not None and p["R"] <= SOGLIA_STOP_R)
        p["day"] = p["t_close"].date()
    return pos, ordini, affari


def _plaus(p, med):
    m = med.get(p["sym"])
    if not m:
        return True
    return 0.5 * m <= p["vpp"] <= 2.0 * m


def leggi_100k():
    out = []
    with open(F_100K, newline="") as fh:
        for r in csv.DictReader(fh, delimiter=";"):
            out.append(dict(id=r["pid"], sym=r["symbol"], side=r["side"], vol=float(r["volume"]),
                            t_open=ts(r["open_time"]), t_close=ts(r["close_time"]),
                            net=float(r["profit"]) + float(r["commission"]) + float(r["swap"]),
                            magic=r["magic"], strategy=r["strategy"], reason=r["close_reason"],
                            und=und(r["symbol"]), dir=1 if r["side"] == "buy" else -1,
                            day=ts(r["close_time"]).date()))
    return out


# ------------------------------------------------------------------ taglie in campo (trial 01/10)
# indici 2,00% per sedia (HANDOFF 01/10, .chr CODA_08); EMA200 = due gambe da 1,00%;
# SuperWave = gambe 1/3 e 2/3 di 2,00%; Bulge A 0,80% (preset FT), Bulge B 1,00% (ricostruito
# dal trial: TRIAL_GIORNO1_ANALISI par. 2); ORB 0,30% (preset; valore vivo [NON MISURATO]).
TAGLIA = {"770101": 2.0, "770105": 2.0, "770101/5_RETEST": 2.0, "770202": 2.0, "770260": 2.0,
          "770411": 2.0, "771531": 1.0, "BULGE_A": 0.8, "BULGE_B": 1.0, "ORB": 0.3}


def taglia(p):
    s = p["sedia"]
    if s == "770511":
        c = p["comment"]
        return 2.0 / 3.0 if "1/3" in c else (4.0 / 3.0 if "2/3" in c else 2.0)
    return TAGLIA.get(s)


FLOTTA = set(TAGLIA) | {"770511"}


def fmt(x, d=2):
    return ("%." + str(d) + "f") % x if x is not None else "n/d"


# ------------------------------------------------------------------ Q1
def q1():
    print("=" * 100)
    print("Q1 -- DOVE NASCE LA PERDITA")
    print("=" * 100)
    ch, _, _ = leggi_report(F_CHALL, "CHALL")
    tr, _, _ = leggi_report(F_TRIAL, "TRIAL")
    for nome, pos in (("CHALLENGE 541452707 (fino 30/09 10:03)", ch), ("TRIAL 1514806751 (01/10 16:45)", tr)):
        print("\n--", nome)
        aperte = [p for p in pos if p["aperta"]]
        if aperte:
            print("   APERTE all'ora del report (fuori dai conti realizzati):",
                  [(p["sedia"], p["sym"], round(p["net"], 2)) for p in aperte])
        pos = [p for p in pos if not p["aperta"]]
        tot = sum(p["net"] for p in pos)
        fl = [p for p in pos if p["sedia"] != "MANUALE"]
        print("   totale netto %.2f | flotta %.2f (n=%d) | manuale %.2f" % (
            tot, sum(p["net"] for p in fl), len(fl), sum(p["net"] for p in pos if p["sedia"] == "MANUALE")))
        for chiave, f in (("sedia", lambda p: p["sedia"]), ("sottostante", lambda p: p["und"]),
                          ("giorno", lambda p: str(p["day"]))):
            g = collections.defaultdict(list)
            for p in pos:
                g[f(p)].append(p)
            print("   per %s:" % chiave)
            for k in sorted(g, key=lambda k: sum(p["net"] for p in g[k])):
                ps = g[k]
                Rs = [p["R"] for p in ps if p["R"] is not None]
                print("     %-18s n=%2d netto %+10.2f  sommaR %+6.2f  stop=%d  parziali=%d  vinte=%d" % (
                    k, len(ps), sum(p["net"] for p in ps), sum(Rs), sum(p["stop"] for p in ps),
                    sum(1 for p in ps if p["n_out"] > 1), sum(1 for p in ps if p["net"] > 0)))
        # distribuzione R della flotta
        Rs = sorted(round(p["R"], 3) for p in fl)
        print("   R flotta ordinati:", Rs)
        st = [p for p in fl if p["stop"]]
        print("   stop pieni flotta: %d su %d, perdita %.2f = %.1f%% della perdita lorda della flotta" % (
            len(st), len(fl), sum(p["net"] for p in st),
            100 * sum(p["net"] for p in st) / sum(p["net"] for p in fl if p["net"] < 0)))
        # correlazione: perdita in giorni con 2+ perdenti sullo stesso sottostante
        g = collections.defaultdict(list)
        for p in fl:
            if p["net"] < 0:
                g[(p["day"], p["und"])].append(p)
        loss = sum(p["net"] for p in fl if p["net"] < 0)
        multi = [(k, v) for k, v in g.items() if len(v) >= 2]
        same = [(k, v) for k, v in multi if len(set(p["dir"] for p in v)) == 1]
        print("   perdenti stesso giorno+sottostante (2+): %s -> %.2f = %.1f%% della perdita lorda; stessa direzione %.1f%%" % (
            [(str(k[0]), k[1], len(v)) for k, v in multi], sum(p["net"] for k, v in multi for p in v),
            100 * sum(p["net"] for k, v in multi for p in v) / loss,
            100 * sum(p["net"] for k, v in same for p in v) / loss))
    print()
    doppi_stop_storia()


def setups(ps):
    """Gambe della stessa sedia sullo stesso sottostante aperte entro 120 s = UN setup
    (EMA200 S1/S2, SuperWave 1/3-2/3, parziali del piccolo). Apertura = prima gamba,
    chiusura = ultima gamba."""
    ps = sorted(ps, key=lambda p: p["t_open"])
    out = []
    for p in ps:
        key = (p.get("sedia", p.get("magic")), p["und"], p["dir"])
        if out and out[-1]["key"] == key and (p["t_open"] - out[-1]["t_open"]).total_seconds() <= 120:
            out[-1]["t_close"] = max(out[-1]["t_close"], p["t_close"])
            out[-1]["legs"] += 1
            continue
        out.append(dict(key=key, sedia=key[0], und=p["und"], dir=p["dir"], t_open=p["t_open"],
                        t_close=p["t_close"], day=p["day"], legs=1))
    return out


def coppie_stop(pos, filtro=lambda p: True, usa_R=True):
    """Coppie di SETUP in stop sullo stesso sottostante e giorno: sequenziali o simultanee.
    Ritorna (seq, sim, episodi_seq) dove episodi = (giorno, sottostante) con almeno una coppia sequenziale."""
    g = collections.defaultdict(list)
    for p in pos:
        if not filtro(p):
            continue
        is_stop = p["stop"] if usa_R else (p.get("reason") == "sl" and p["net"] < 0)
        if is_stop:
            g[(p["day"], p["und"])].append(p)
    seq, sim = [], []
    for k, v in g.items():
        v = setups(v)
        if len(v) < 2:
            continue
        for i in range(len(v)):
            for j in range(i + 1, len(v)):
                a, b = v[i], v[j]
                rec = (str(k[0]), k[1], a["sedia"], b["sedia"],
                       "stessa dir" if a["dir"] == b["dir"] else "dir opposta",
                       a["t_open"].strftime("%H:%M"), a["t_close"].strftime("%H:%M"),
                       b["t_open"].strftime("%H:%M"), b["t_close"].strftime("%H:%M"))
                (seq if b["t_open"] >= a["t_close"] else sim).append(rec)
    return seq, sim


def giorni_attivi(pos, filtro):
    return len(set(p["day"] for p in pos if filtro(p)))


def doppi_stop_storia():
    print("-- STORIA FORWARD: due STOP PIENI sullo stesso sottostante nello stesso giorno")
    ch, _, _ = leggi_report(F_CHALL, "CHALL")
    tr, _, _ = leggi_report(F_TRIAL, "TRIAL")
    pc, _, _ = leggi_report(F_PICC, "PICC")
    ea = lambda p: p["sedia"] != "MANUALE" and p["sl_src"] == "ORDINE"
    fl = lambda p: p["sedia"] in FLOTTA and p["sl_src"] == "ORDINE"
    for nome, pos in (("CHALLENGE", ch), ("TRIAL", tr), ("PICCOLO 50503392", pc)):
        pos = [p for p in pos if not p["aperta"]]
        for etich, f in (("tutti gli EA (SL d'ordine)", ea), ("solo sedie della flotta FTMO", fl)):
            seq, sim = coppie_stop(pos, f)
            n_st = sum(1 for p in pos if f(p) and p["stop"])
            n = sum(1 for p in pos if f(p))
            ep = sorted(set((r[0], r[1]) for r in seq))
            print("   %-17s %-30s pos=%4d stop=%3d giorni-attivi=%3d | coppie SEQ %d in %d episodi (giorno x sottostante) | coppie SIM %d" % (
                nome, etich, n, n_st, giorni_attivi(pos, f), len(seq), len(ep), len(sim)))
            for r in seq:
                print("        SEQ", r)
            if etich.startswith("solo"):
                for r in sim:
                    print("        SIM", r)
    k = leggi_100k()
    seq, sim = coppie_stop(k, usa_R=False)
    print("   %-17s %-30s pos=%4d sl-in-perdita=%3d | SEQUENZIALI %d | SIMULTANEE %d  (R NON misurabile: proxy close_reason=sl)" % (
        "100k 50504263", "tutti", len(k), sum(1 for p in k if p["reason"] == "sl" and p["net"] < 0), len(seq), len(sim)))
    for r in seq:
        print("        SEQ", r)
    print("   periodo 100k: %s -> %s" % (min(p["t_open"] for p in k), max(p["t_close"] for p in k)))
    print("   periodo piccolo: %s -> %s" % (min(p["t_open"] for p in pc), max(p["t_close"] for p in pc)))
    print("   piccolo, stop per fonte SL:", collections.Counter((p["sl_src"], p["stop"]) for p in pc if p["sedia"] != "MANUALE"))


# ------------------------------------------------------------------ Q2
def rischio_aperto(pos, t, escludi=None, peso=None):
    """Somma dei rischi all'ingresso (SL iniziale) delle posizioni aperte all'istante t.
    Una posizione aperta nello STESSO secondo di t conta se e' gia' stata riempita prima
    (ordine di ID): e' cosi' che il Guardian, a giro di timer di 1 s, NON la vede."""
    tot = 0.0
    for p in pos:
        if p is escludi:
            continue
        if p["t_open"] <= t < p["t_close"] and (p["t_open"] < t or p["id"] < escludi["id"]):
            if peso is None:
                tot += p["risk"] or 0.0
            else:
                w = peso(p)
                tot += w if w else 0.0
    return tot


def saldo_inizio_giorno(affari, t, reset_ora):
    """Saldo all'ultimo deal prima del reset giornaliero che precede t."""
    r = t.replace(hour=reset_ora, minute=0, second=0)
    if t < r:
        r -= dt.timedelta(days=1)
    prima = [a for a in affari if a["t"] < r and a["bal"] is not None]
    return (prima[-1]["bal"] if prima else None), r


def q2():
    print("=" * 100)
    print("Q2 -- RISCHIO SIMULTANEO MISURATO IN CAMPO (SL iniziale; denominatore = saldo all'ingresso)")
    print("=" * 100)
    for nome, f, conto, reset, start in ((
            "CHALLENGE 541452707", F_CHALL, "CHALL", 1, 80000.0), ("TRIAL 1514806751", F_TRIAL, "TRIAL", 1, 160000.0)):
        pos, ordini, affari = leggi_report(f, conto)
        pos = [p for p in pos if p["risk"]]
        affari = sorted(affari, key=lambda a: a["t"])
        print("\n--", nome)
        print("   %-19s %-9s %-11s %8s %8s %8s | %7s %7s | %8s %8s" % (
            "ingresso", "sedia", "simbolo", "rischio", "prima%", "dopo%", "C1 4,00", "C1 3,25",
            "real.gg%", "potenz%"))
        for p in sorted(pos, key=lambda p: (p["t_open"], p["id"])):
            prima = rischio_aperto(pos, p["t_open"], escludi=p)
            bal = p["bal_open"]
            b0, r = saldo_inizio_giorno(affari, p["t_open"], reset)
            b0 = b0 if b0 is not None else start
            real = (b0 - bal) / b0 * 100
            dopo = (prima + p["risk"]) / bal * 100
            print("   %-19s %-9s %-11s %8.0f %8.2f %8.2f | %7s %7s | %8.2f %8.2f" % (
                p["t_open"], p["sedia"], p["sym"], p["risk"], prima / bal * 100, dopo,
                "SOPRA" if dopo >= 4.0 else "-", "SOPRA" if dopo >= 3.25 else "-",
                real, real + (prima + p["risk"]) / b0 * 100))
        # traiettoria minuto per minuto del rischio aperto e della perdita potenziale
        evs = sorted(set([p["t_open"] for p in pos] + [p["t_close"] for p in pos]))
        picco = (0, None)
        for t in evs:
            tot = sum(p["risk"] for p in pos if p["t_open"] <= t < p["t_close"])
            bal = [a["bal"] for a in affari if a["t"] <= t and a["bal"] is not None]
            bal = bal[-1] if bal else start
            if tot / bal > picco[0]:
                picco = (tot / bal, t, [p["sedia"] + ":" + p["sym"] for p in pos if p["t_open"] <= t < p["t_close"]])
        print("   PICCO rischio aperto: %.2f%% alle %s con %s" % (100 * picco[0], picco[1], picco[2]))

    # piccolo BCM: (i) % grezzo del saldo, tutti gli EA; (ii) sole sedie della flotta FTMO alla taglia FTMO
    pos, ordini, affari = leggi_report(F_PICC, "PICC")
    ea = [p for p in pos if p["sedia"] != "MANUALE" and p["sl_src"] == "ORDINE" and p["risk"] and p["bal_open"]]
    pre = [100 * (rischio_aperto(ea, p["t_open"], escludi=p) + p["risk"]) / p["bal_open"] for p in ea]
    pre.sort()
    def q(v, x):
        return v[min(len(v) - 1, int(x * len(v)))]
    print("\n-- PICCOLO 50503392, tutti gli EA con SL d'ordine (n ingressi=%d, taglie del piccolo, NON quelle FTMO)" % len(ea))
    print("   rischio aperto DOPO l'ingresso, %% saldo: mediana %.2f  p90 %.2f  p99 %.2f  max %.2f | >=3,25: %d  >=4,00: %d  >=5,00: %d" % (
        q(pre, .5), q(pre, .9), q(pre, .99), pre[-1], sum(x >= 3.25 for x in pre), sum(x >= 4 for x in pre), sum(x >= 5 for x in pre)))
    fl = [p for p in pos if p["sedia"] in FLOTTA and p["sedia"] != "770260"]
    w = [rischio_aperto(fl, p["t_open"], escludi=p, peso=taglia) + taglia(p) for p in fl]
    print("-- PICCOLO 50503392, sole sedie della flotta FTMO (770260 esclusa: modo diverso), rimesse alla taglia FTMO (n=%d)" % len(fl))
    c = collections.Counter(round(x, 2) for x in w)
    print("   rischio aperto DOPO l'ingresso, %% (taglia FTMO): distribuzione %s | max %.2f | >=4,00: %d su %d" % (
        sorted(c.items()), max(w), sum(x >= 4.0 - 1e-9 for x in w), len(w)))
    k = [(p["t_open"], p["sedia"], p["sym"], round(x, 2)) for p, x in zip(fl, w) if x >= 3.0]
    for r in sorted(k):
        print("     ", r)


# ------------------------------------------------------------------ contratti (per-trade OOS)
PT = {
    "770101": ("risultati_prove/aperture_r47/abtg_trades_ABTG_DAX_Apertura_EU_D30EUR_772501.csv", 1.0),
    "770202": ("risultati_prove/aperture_r47/abtg_trades_ABTG_Dow_Apertura_US_U30USD_772505.csv", 1.0),
    "770411": ("risultati_prove/trades_portafoglio/abtg_trades_ABTG_MaxMinNotte_DAX_Short_Ottimizzato_D30EUR_770413.csv", 1.0),
    "771531": ("risultati_prove/trades_candidati_r23/abtg_trades_ABTG_EMA200_U30USD_771521.csv", 0.5),
}
PT_CONTRATTO_EMA = ("risultati_archivio/R112_CORSA_20260826/pertrade_00_metro_763400.csv", 0.5)


def pertrade_pos(rel, quota, deposito=100000.0, rischio=1.0):
    """Posizioni del per-trade (solo uscite): netto sommato per position_id, R = netto /
    (rischio% x quota x saldo prima della posizione). Saldo ricostruito per data di chiusura."""
    rows = []
    with open(os.path.join(QUI, rel), newline="") as fh:
        for r in csv.DictReader(fh, delimiter=";"):
            rows.append((ts(r["close_time"]), r["position_id"], float(r["net_profit"]), r["symbol"]))
    rows.sort()
    agg = collections.OrderedDict()
    for t, pid, v, sym in rows:
        if pid not in agg:
            agg[pid] = dict(t_first=t, t_close=t, net=0.0, sym=sym, legs=0)
        agg[pid]["net"] += v
        agg[pid]["t_close"] = t
        agg[pid]["legs"] += 1
    bal = deposito
    out = []
    for pid, a in sorted(agg.items(), key=lambda kv: kv[1]["t_first"]):
        a["R"] = a["net"] / (rischio / 100.0 * quota * bal)
        a["bal0"] = bal
        a["day"] = a["t_close"].date()
        a["und"] = und(a["sym"])
        a["stop"] = a["R"] <= SOGLIA_STOP_R
        out.append(a)
        bal += a["net"]
    return out


TOLTE = []


def serie_giornaliera(posizioni, fattore_taglia, regola_o3=False):
    """posizioni: lista di dict con day, und, R, size(%), t_close, t_open(opzionale).
    Ritorna (giorni, rendimenti frazionali) alla taglia (size x fattore)."""
    by_day = collections.defaultdict(list)
    for p in posizioni:
        by_day[p["day"]].append(p)
    giorni, ret = [], []
    for d in sorted(by_day):
        ps = sorted(by_day[d], key=lambda p: p.get("t_open", p["t_close"]))
        tot = 0.0
        stop_und = {}
        for p in ps:
            if regola_o3:
                ts_stop = stop_und.get(p["und"])
                if "t_open" in p:          # forward: ora d'ingresso vera
                    via = ts_stop is not None and p["t_open"] >= ts_stop
                else:                      # per-trade: solo uscite -> chiude DOPO lo stop (per eccesso)
                    via = ts_stop is not None and p["t_close"] > ts_stop
                if via:
                    TOLTE.append(p)
                    continue
            tot += p["R"] * p["size"] * fattore_taglia / 100.0
            if p["stop"]:
                stop_und[p["und"]] = min(stop_und.get(p["und"], p["t_close"]), p["t_close"])
        giorni.append(d)
        ret.append(tot)
    return giorni, ret


def durate_morte(f, saldo_iniziale, guardian, n_sim=20000, seme=11, target=0.10, muro_stat=0.10,
                 muro_gior=0.05, min_giorni=4, max_giorni=800):
    """Copia riga per riga di mc_challenge_ftmo.simula (stesso generatore, stesso seme) che
    in piu' registra la durata degli esiti di MORTE. Verificata stampando gli esiti accanto."""
    rnd = random.Random(seme)
    esiti = collections.Counter(); dur = []
    for _ in range(n_sim):
        s = f[:]; rnd.shuffle(s)
        bal = saldo_iniziale; g = 0; esito = None; i = 0
        while esito is None:
            if i >= len(s):
                s2 = f[:]; rnd.shuffle(s2); s = s + s2
            r = s[i]; i += 1
            b0 = bal
            perdita = -r * b0
            if guardian is not None and perdita > guardian:
                perdita = guardian
                r = -perdita / b0
            bal = b0 + r * b0
            g += 1
            if (b0 - bal) > muro_gior:   esito = 'MORTE_GIORNALIERA'; break
            if bal < 1.0 - muro_stat:    esito = 'MORTE_STATICA';     break
            if bal >= 1.0 + target and g >= min_giorni: esito = 'PASS'; break
            if g >= max_giorni:          esito = 'TIMEOUT';           break
        esiti[esito] += 1
        if esito.startswith('MORTE'):
            dur.append(g)
    tot = sum(esiti.values())
    return {k: round(100.0 * v / tot, 1) for k, v in esiti.items()}, sorted(dur)


def q3():
    import mc_challenge_ftmo as m
    print("=" * 100)
    print("Q3 -- MONTE CARLO DI CASA (mc_challenge_ftmo.simula, NON modificato)")
    print("=" * 100)
    # 0. riproduzione del riferimento
    per = m.carica()
    g, base = m.serie(per)
    o, med = m.simula(base, 2.0, 76573.86 / 80000, guardian=0.045)
    print("RIPRODUZIONE (2,00%%, Guardian 4,5%%, saldo 76.573,86, seme 11, 20.000): PASS %.1f%% (atteso 74,6) | gg mediani %s" % (o.get("PASS", 0), med))
    if abs(o.get("PASS", 0) - 74.6) > 0.05:
        print("RIPRODUZIONE FALLITA: varianti NON stampate"); return
    # controesempi del motore
    o0, _ = m.simula([0.0] * 10 + [0.011], 1.0, 1.0, max_giorni=200)
    o1, _ = m.simula([-0.06] * 10, 1.0, 1.0)
    o2, _ = m.simula([-0.06] * 10, 1.0, 1.0, guardian=0.045)
    print("CONTROESEMPI motore: tutto +0 e un +1,1%% -> %s | tutti -6%% -> %s | tutti -6%% con Guardian -> %s" % (o0, o1, o2))

    # (a) contratto: 4 sedie, posizioni in R; taglia di misura 1% -> size 1 (771531: quota 0,5)
    pa = []
    for s, (rel, quota) in PT.items():
        for a in pertrade_pos(rel, quota):
            pa.append(dict(day=a["day"], und=a["und"], R=a["R"], size=1.0 * quota, t_close=a["t_close"],
                           stop=a["stop"], sedia=s))
    # controllo: la serie in R x 1% deve ritrovare la serie in EUR del motore (a meno della capitalizzazione)
    ga, ra = serie_giornaliera(pa, 1.0)
    print("\n(a) CONTRATTO: %d posizioni, %d giornate attive (motore di casa: %d giornate); somma rendimenti @1%%: %.4f (motore: %.4f)" % (
        len(pa), len(ga), len(g), sum(ra), sum(base)))
    # (b1) forward FTMO: challenge (flotta) + trial
    pb1 = []
    for f, c in ((F_CHALL, "CHALL"), (F_TRIAL, "TRIAL")):
        pos, _, _ = leggi_report(f, c)
        for p in pos:
            if p["sedia"] == "MANUALE" or p["aperta"] or p["R"] is None:
                continue
            pb1.append(dict(day=p["day"], und=p["und"], R=p["R"], size=taglia(p), t_close=p["t_close"],
                            t_open=p["t_open"], stop=p["stop"], sedia=p["sedia"]))
    # (b2) forward piccolo, sole sedie della flotta FTMO (770260 esclusa: modo diverso)
    pos, _, _ = leggi_report(F_PICC, "PICC")
    pb2 = []
    for p in pos:
        if p["sedia"] in FLOTTA and p["sedia"] != "770260" and not p["aperta"] and p["R"] is not None and p["sl_src"] == "ORDINE":
            pb2.append(dict(day=p["day"], und=p["und"], R=p["R"], size=taglia(p), t_close=p["t_close"],
                            t_open=p["t_open"], stop=p["stop"], sedia=p["sedia"]))
    gb1, rb1 = serie_giornaliera(pb1, 1.0)
    print("(b1) FORWARD FTMO: %d posizioni, %d giornate attive: %s" % (
        len(pb1), len(gb1), [(str(d), round(100 * r, 2)) for d, r in zip(gb1, rb1)]))
    gb2, rb2 = serie_giornaliera(pb2, 1.0)
    print("(b2) FORWARD PICCOLO (sedie flotta, taglia FTMO): %d posizioni, %d giornate attive, periodo %s -> %s" % (
        len(pb2), len(gb2), gb2[0], gb2[-1]))

    S_TRIAL = 153754.32 / 160000.0
    print("\nOpzioni: O0 taglia attuale | O1 indici x0,75 (2,00->1,50) | O2 x0,50 (2,00->1,00) | O3 dopo uno stop pieno sul sottostante niente altro quel giorno")
    print("Guardian = perdita del giorno tagliata a 4,5%% (ipotesi del motore: ottimistica, niente gap/flottante).")
    hdr = "  %-34s %-6s | %6s %6s %6s | %6s %6s %6s | %8s %6s | %s"
    print(hdr % ("campione / opzione", "Guard", "PASS", "gior", "stat", "PASS*", "gior*", "stat*", "media/gg", "gg<=-5", "gg mediani (da 1,000 / da trial)"))
    for nome, P in (("(a) CONTRATTO 4 sedie", pa), ("(b1) FORWARD FTMO 7 gg", pb1), ("(b2) FORWARD PICCOLO", pb2)):
        for onome, fatt, o3 in (("O0 attuale", 1.0, False), ("O1 x0,75", 0.75, False),
                                ("O2 x0,50", 0.5, False), ("O3 niente 2o dopo stop", 1.0, True)):
            fa = 2.0 * fatt if nome.startswith("(a)") else fatt
            gg, rr = serie_giornaliera(P, fa, regola_o3=o3)
            for gd in ((0.045, "4,5%"), (None, "no")):
                if gd[0] is None and onome != "O0 attuale":
                    continue
                oA, mA = m.simula(rr, 1.0, 1.0, guardian=gd[0])
                oB, mB = m.simula(rr, 1.0, S_TRIAL, guardian=gd[0])
                print(hdr % (nome[:20] + " " + onome, gd[1],
                             "%.1f" % oA.get("PASS", 0), "%.1f" % oA.get("MORTE_GIORNALIERA", 0), "%.1f" % oA.get("MORTE_STATICA", 0),
                             "%.1f" % oB.get("PASS", 0), "%.1f" % oB.get("MORTE_GIORNALIERA", 0), "%.1f" % oB.get("MORTE_STATICA", 0),
                             "%+.3f%%" % (100 * statistics.mean(rr)), sum(1 for x in rr if x <= -0.05),
                             "%s / %s" % (mA, mB)))
    # O3: che cosa toglie, per campione (posizioni tolte e loro somma in R x taglia)
    for nome, P, fa in (("(a)", pa, 2.0), ("(b1)", pb1, 1.0), ("(b2)", pb2, 1.0)):
        del TOLTE[:]
        serie_giornaliera(P, fa, regola_o3=True)
        print("O3 %s: posizioni tolte %d, somma %+.2f%% (in R x taglia), vinte tolte %d, stop tolti %d" % (
            nome, len(TOLTE), sum(p["R"] * p["size"] * fa for p in TOLTE), sum(1 for p in TOLTE if p["R"] > 0),
            sum(1 for p in TOLTE if p["stop"])))
    # durata alla morte (replica di simula per le sole durate, verificata sull'esito)
    for nome, P in (("(b1)", pb1),):
        gg, rr = serie_giornaliera(P, 1.0)
        for S0, et in ((1.0, "da 1,000"), (S_TRIAL, "da trial")):
            o_ref, _ = m.simula(rr, 1.0, S0, guardian=0.045)
            esiti, dur = durate_morte(rr, S0, 0.045)
            print("%s durata alla morte %s: mediana %s gg attivi, p10 %s, p90 %s | esiti replica %s = motore %s" % (
                nome, et, dur[len(dur) // 2], dur[len(dur) // 10], dur[9 * len(dur) // 10], esiti, o_ref))
    for nome, P in (("(b1)", pb1), ("(b2)", pb2)):
        gg, rr = serie_giornaliera(P, 1.0)
        print("%s giornata peggiore %.2f%%, migliore %.2f%%, giornate <= -3,5%%: %d su %d" % (
            nome, 100 * min(rr), 100 * max(rr), sum(r <= -0.035 for r in rr), len(rr)))
    # giornate peggiori del campione (a) alla taglia in campo
    ga2, ra2 = serie_giornaliera(pa, 2.0)
    worst = sorted(zip(ra2, ga2))[:5]
    print("\n(a) giornate peggiori @2,00%%: %s" % [(str(d), round(100 * r, 2)) for r, d in worst])
    print("(a) giornate <= -3,5%% / -4,5%% / -5%% @2,00%%: %d / %d / %d su %d" % (
        sum(r <= -0.035 for r in ra2), sum(r <= -0.045 for r in ra2), sum(r <= -0.05 for r in ra2), len(ra2)))
    # doppio stop DAX nello stesso giorno nel contratto (770101 + 770411)
    dax = collections.defaultdict(list)
    for p in pa:
        if p["und"] == "DAX" and p["stop"]:
            dax[p["day"]].append(p["sedia"])
    print("(a) giorni con 2+ stop pieni DAX (770101+770411) nel contratto: %d su %d giornate DAX; elenco %s" % (
        sum(1 for v in dax.values() if len(v) >= 2), len(set(p["day"] for p in pa if p["und"] == "DAX")),
        [(str(d), v) for d, v in sorted(dax.items()) if len(v) >= 2]))
    dow = collections.defaultdict(set)
    for p in pa:
        if p["und"] == "DOW" and p["stop"]:
            dow[p["day"]].add(p["sedia"])
    print("(a) giorni con stop pieni di 2 sedie DOW diverse (770202+771531): %d" % sum(1 for v in dow.values() if len(v) >= 2))


# ------------------------------------------------------------------ Q4
def binom_cdf(k, n, p):
    return sum(math.comb(n, i) * p ** i * (1 - p) ** (n - i) for i in range(0, k + 1))


def pois_cdf(k, lam):
    return sum(math.exp(-lam) * lam ** i / math.factorial(i) for i in range(0, k + 1))


def poisbin_ge(k, ps):
    """P(somma di Bernoulli indipendenti con probabilita' ps >= k), esatta per convoluzione."""
    dist = [1.0]
    for p in ps:
        new = [0.0] * (len(dist) + 1)
        for i, v in enumerate(dist):
            new[i] += v * (1 - p)
            new[i + 1] += v * p
        dist = new
    return sum(dist[k:])


FREQ = {"770101": 0.699, "770202": 0.348, "770260": 0.360, "771531": 0.931, "770511": 0.294,
        "770411": 0.051, "770105": None}       # CONTRATTI_DELLE_SEDIE_FTMO_2026-09-20.md par. 6
GIORNI = {"770105": 3}                         # nata il 28/09 (RFWD_CRITERI par. 2.3)


def q4():
    print("=" * 100)
    print("Q4 -- CONTRATTO CONTRO CAMPO, per sedia (finestra 22-30/09 = 7 giorni di borsa)")
    print("=" * 100)
    pstop = {}
    for s, (rel, quota) in list(PT.items()) + [("771531_R112", PT_CONTRATTO_EMA)]:
        pp = pertrade_pos(rel, quota)
        k = sum(p["stop"] for p in pp)
        pstop[s] = (k, len(pp))
        print("contratto %-12s posizioni %3d  stop pieni %3d  = %.1f%%  (R medio %+.3f, mediana R %+.3f) %s" % (
            s, len(pp), k, 100.0 * k / len(pp), statistics.mean(p["R"] for p in pp),
            statistics.median(p["R"] for p in pp), rel))
    pstop["771531"] = pstop.pop("771531_R112")     # il contratto della 771531 e' R112 (CONTRATTI par. 2)
    ch, _, _ = leggi_report(F_CHALL, "CHALL")
    da, a = dt.date(2026, 9, 22), dt.date(2026, 9, 30)
    obs = collections.defaultdict(list)
    for p in ch:
        if p["sedia"] != "MANUALE" and da <= p["t_open"].date() <= a:
            obs[p["sedia"]].append(p)
    print()
    print("  %-7s | %4s %6s %6s %8s %8s %-6s | %10s %6s %8s %8s %-6s" % (
        "sedia", "oss", "att", "freq", "P(X<=k)", "P(X>=k)", "esito", "stop oss", "p contr", "P(<=k)", "P(>=k)", "esito"))
    ps_pool = []
    for s in ("770101", "770105", "770202", "770260", "770411", "770511", "771531"):
        ps = obs.get(s, [])
        k = len(ps)
        lam = None
        if FREQ[s] is not None:
            lam = FREQ[s] * GIORNI.get(s, 7)
            lo, hi = pois_cdf(k, lam), 1 - pois_cdf(k - 1, lam) if k > 0 else 1.0
            ef = "FUORI" if min(lo, hi) < 0.025 else "dentro"
            fr = ("%4d %6.2f %6.3f %8.3f %8.3f %-6s" % (k, lam, FREQ[s], lo, hi, ef))
        else:
            fr = ("%4d %6s %6s %8s %8s %-6s" % (k, "n/d", "n/d", "-", "-", "N/MIS"))
        ks = sum(p["stop"] for p in ps)
        if s in pstop and ps:
            pc = pstop[s][0] / pstop[s][1]
            lo, hi = binom_cdf(ks, k, pc), 1 - binom_cdf(ks - 1, k, pc) if ks > 0 else 1.0
            es = "FUORI" if min(lo, hi) < 0.025 else "dentro"
            st = "%4d su %-3d %6.3f %8.3f %8.3f %-6s" % (ks, k, pc, lo, hi, es)
            ps_pool += [pc] * k
        else:
            st = "%4d su %-3d %6s %8s %8s %-6s" % (ks, k, "n/d" if s not in pstop else "%.3f" % (pstop[s][0] / pstop[s][1]), "-", "-",
                                                   "N/MIS" if s not in pstop else "n=0")
        print("  %-7s | %s | %s" % (s, fr, st))
    ks_pool = sum(p["stop"] for s in ("770101", "770411", "771531", "770202") for p in obs.get(s, []))
    print("\n  POOL delle sedie con contratto di stop (770101, 770411, 771531, 770202): %d stop su %d, atteso %.2f; P(>= %d) = %.3f (Poisson-binomiale esatta)" % (
        ks_pool, len(ps_pool), sum(ps_pool), ks_pool, poisbin_ge(ks_pool, ps_pool)))
    tot_att = sum(FREQ[s] * GIORNI.get(s, 7) for s in FREQ if FREQ[s] is not None)
    tot_oss = sum(len(obs.get(s, [])) for s in FREQ if FREQ[s] is not None)
    print("  FREQUENZA aggregata (6 sedie con promessa): osservate %d, attese %.2f, P(X<=%d) = %.3f, P(X>=%d) = %.3f" % (
        tot_oss, tot_att, tot_oss, pois_cdf(tot_oss, tot_att), tot_oss, 1 - pois_cdf(tot_oss - 1, tot_att)))
    # forward piccolo, stop-rate per sedia (altro feed, stessa logica), a confronto
    pc, _, _ = leggi_report(F_PICC, "PICC")
    print("\n  Riferimento forward PICCOLO 50503392 (feed BCM), stop pieni per sedia:")
    for s in ("770101/5_RETEST", "770411", "771531", "770511", "770202", "770260"):
        ps = [p for p in pc if p["sedia"] == s and not p["aperta"] and p["sl_src"] == "ORDINE"]
        ks = sum(p["stop"] for p in ps)
        ref = pstop.get(s.split("/")[0])
        extra = ""
        if ref and ps:
            pcn = ref[0] / ref[1]
            lo, hi = binom_cdf(ks, len(ps), pcn), (1 - binom_cdf(ks - 1, len(ps), pcn) if ks > 0 else 1.0)
            extra = "contratto %.3f: P(<=k) %.3f P(>=k) %.3f -> %s" % (pcn, lo, hi, "FUORI" if min(lo, hi) < 0.025 else "dentro")
        print("    %-16s %2d stop su %2d  %s" % (s, ks, len(ps), extra))


if __name__ == "__main__":
    sez = sys.argv[1] if len(sys.argv) > 1 else "tutto"
    if sez in ("q1", "tutto"):
        q1()
    if sez in ("q2", "tutto"):
        q2()
    if sez in ("q3", "tutto"):
        q3()
    if sez in ("q4", "tutto"):
        q4()
