#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
autopsia_pertrade.py -- AUTOPSIA DEI TRADE PERSI sui per-trade del tester
(formato abtg_trades_<EA>_<simbolo>_<magic>.csv, SOLO deal d'uscita:
 close_time;symbol;magic;position_id;deal_type;volume;price;net_profit).

SOLA LETTURA. Non tocca EA, preset, file prova, CSV.

Cosa fa:
  1. aggrega i deal per position_id (una POSIZIONE = un trade del motore:
     con InpTP1Pct=50 una posizione lascia 1-3 deal d'uscita);
  2. sottrae la commissione d'INGRESSO che il per-trade NON porta
     (classe 844: k EUR/lotto x volume della posizione; k = 1,81 oro, 0 DAX);
  3. classifica l'USCITA con le sole informazioni che il per-trade ha
     (ora di chiusura dell'ultimo deal, numero di deal, segno dei deal):
       STOP_PIENO   = 1 deal, in perdita, prima dell'ora di flat
       TIMESTOP     = ultimo deal all'ora di flat (InpCloseHour:InpCloseMin)
       TP1_BE       = 2+ deal, primo deal positivo, ultimo deal ~0 o negativo
                      (breakeven / trailing tornato indietro)
       TP1_RUN      = 2+ deal, tutti positivi (TP1 + TP2/EMA200/trailing)
       ALTRO        = tutto il resto (1 deal positivo prima del flat = trailing
                      o TPfinal sull'ordine)
  4. tabella dei persi contro i vinti per: ora di chiusura, giorno della
     settimana, mese, anno, stagione (ORA LEGALE europea si/no: sul server
     BCM UTC+1 FISSO l'apertura cash Xetra cade alle 08:00 server d'estate e
     alle 09:00 server d'inverno -> report/OROLOGIO_BCM_2026-09-24.md),
     motivo d'uscita, ampiezza (net/volume in EUR per lotto, quartili),
     sequenze (serie di perdite consecutive).

Etichette: tutto cio' che esce da qui e' [MISURATO] sul per-trade; i motivi
d'uscita sono [DERIVATO] (dedotti dall'ora e dalla forma dei deal, il
per-trade non porta il commento del deal).

Uso:
  python3 backtest_pipeline/autopsia_pertrade.py FILE.csv [FILE2.csv ...]
        [--k 1.81] [--close 17:30] [--label "DAX long corr=1"] [--md OUT.md]
  python3 backtest_pipeline/autopsia_pertrade.py --autotest
Piu' file = si concatenano (per unire due gambe contigue dello stesso
motore, es. short 794623 + 795404). Le date devono essere disgiunte:
lo script lo verifica e si ferma se si sovrappongono.
"""
import argparse
import csv
import io
import os
import sys
from collections import Counter, OrderedDict, defaultdict
from datetime import date, datetime, timedelta

WD = ["Lun", "Mar", "Mer", "Gio", "Ven", "Sab", "Dom"]


# ----------------------------------------------------------------------
#  Orologio: ora legale europea (ultima domenica di marzo -> ultima di ottobre)
# ----------------------------------------------------------------------
def _last_sunday(y, m):
    d = date(y, m + 1, 1) - timedelta(days=1) if m < 12 else date(y, 12, 31)
    return d - timedelta(days=(d.weekday() + 1) % 7)


def ora_legale(d):
    """True se in Europa vige l'ora legale (CEST) nel giorno d.
    Sul server BCM (UTC+1 fisso) => Xetra apre alle 08:00 server (allineato
    con InpPlaceHour 7:59 / cutoff 8:30). False => Xetra apre alle 09:00
    server: il pendente vive 07:59-08:30 PRIMA dell'apertura cash."""
    return _last_sunday(d.year, 3) <= d < _last_sunday(d.year, 10)


# ----------------------------------------------------------------------
#  Lettura e aggregazione
# ----------------------------------------------------------------------
def leggi_deal(fh):
    r = csv.DictReader(fh, delimiter=";")
    need = {"close_time", "symbol", "magic", "position_id", "deal_type",
            "volume", "price", "net_profit"}
    if not need.issubset(set(r.fieldnames or [])):
        raise ValueError("intestazione inattesa: %s" % r.fieldnames)
    out = []
    for row in r:
        if not row["close_time"]:
            continue
        out.append({
            "t": datetime.strptime(row["close_time"], "%Y.%m.%d %H:%M:%S"),
            "symbol": row["symbol"],
            "magic": int(row["magic"]),
            "pid": int(row["position_id"]),
            "deal_type": int(row["deal_type"]),
            "vol": float(row["volume"]),
            "price": float(row["price"]),
            "net": float(row["net_profit"]),
        })
    return out


def aggrega(deals, k_lotto=0.0, close_hm=(17, 30)):
    """Una riga per posizione. net_pos = somma net - k * volume (classe 844)."""
    by = OrderedDict()
    for d in sorted(deals, key=lambda x: (x["t"], x["pid"])):
        by.setdefault((d["magic"], d["pid"]), []).append(d)
    pos = []
    for (magic, pid), ds in by.items():
        ds.sort(key=lambda x: x["t"])
        vol = sum(x["vol"] for x in ds)
        net_deal = sum(x["net"] for x in ds)
        comm = k_lotto * vol
        net = net_deal - comm
        last = ds[-1]
        side = "LONG" if last["deal_type"] == 1 else "SHORT"
        tipi = set(x["deal_type"] for x in ds)
        if len(tipi) != 1:
            raise ValueError("posizione %s con deal_type misti %s" % (pid, tipi))
        motivo = classifica(ds, close_hm)
        pos.append({
            "magic": magic, "pid": pid, "side": side, "n_deal": len(ds),
            "t_first": ds[0]["t"], "t_last": last["t"], "vol": vol,
            "net_deal": net_deal, "comm": comm, "net": net,
            "per_lotto": net / vol if vol else 0.0,
            "motivo": motivo, "day": last["t"].date(),
            "p_first": ds[0]["price"], "p_last": last["price"],
        })
    return pos


def classifica(ds, close_hm):
    last = ds[-1]
    at_close = (last["t"].hour, last["t"].minute) == close_hm
    if len(ds) == 1:
        if at_close:
            return "TIMESTOP"
        return "STOP_PIENO" if ds[0]["net"] < 0 else "ALTRO"
    # 2+ deal
    if at_close:
        return "TIMESTOP"
    if ds[0]["net"] > 0 and all(x["net"] > 0 for x in ds[1:]):
        return "TP1_RUN"
    if ds[0]["net"] > 0:
        return "TP1_BE"
    return "ALTRO"


# ----------------------------------------------------------------------
#  Tabelle
# ----------------------------------------------------------------------
def pf(pos):
    g = sum(p["net"] for p in pos if p["net"] > 0)
    l = -sum(p["net"] for p in pos if p["net"] <= 0)
    if l == 0:
        return float("inf") if g > 0 else 0.0
    return g / l


def riga_bucket(nome, sub):
    n = len(sub)
    v = sum(1 for p in sub if p["net"] > 0)
    pe = n - v
    net = sum(p["net"] for p in sub)
    perl = sum(p["net"] for p in sub) / sum(p["vol"] for p in sub) if sub else 0.0
    return "| %s | %d | %d | %d | %s | %+.0f | %+.1f |" % (
        nome, n, v, pe, ("%.2f" % pf(sub)) if pf(sub) != float("inf") else "inf",
        net, perl)


def tabella(titolo, pos, keyf, ordine=None):
    g = defaultdict(list)
    for p in pos:
        g[keyf(p)].append(p)
    keys = ordine if ordine is not None else sorted(g.keys())
    out = ["", "**%s**" % titolo, "",
           "| chiave | n | vinti | persi | PF | net EUR | EUR/lotto |",
           "|---|---:|---:|---:|---:|---:|---:|"]
    for kk in keys:
        if kk in g:
            out.append(riga_bucket(str(kk), g[kk]))
    out.append(riga_bucket("TOTALE", pos))
    return out


def quartili(vals):
    if not vals:
        return []
    s = sorted(vals)
    n = len(s)

    def q(f):
        i = f * (n - 1)
        lo, hi = int(i), min(int(i) + 1, n - 1)
        return s[lo] + (s[hi] - s[lo]) * (i - lo)
    return [s[0], q(0.25), q(0.5), q(0.75), s[-1]]


def sequenze(pos):
    """Serie di perdite/vincite consecutive in ordine cronologico."""
    seq = sorted(pos, key=lambda p: p["t_last"])
    best = worst = cur = 0
    cur_sign = 0
    run_lengths_l = []
    for p in seq:
        s = 1 if p["net"] > 0 else -1
        if s == cur_sign:
            cur += 1
        else:
            if cur_sign == -1:
                run_lengths_l.append(cur)
            cur, cur_sign = 1, s
        if s == 1:
            best = max(best, cur)
        else:
            worst = max(worst, cur)
    if cur_sign == -1:
        run_lengths_l.append(cur)
    return best, worst, Counter(run_lengths_l)


def autopsia(pos, label, close_hm):
    L = []
    n = len(pos)
    vin = [p for p in pos if p["net"] > 0]
    per = [p for p in pos if p["net"] <= 0]
    L.append("### %s" % label)
    L.append("")
    L.append("- posizioni **%d** (deal %d), vinte %d, perse %d, PF in posizioni **%.3f**, "
             "net **%+.2f EUR** (commissione d'ingresso sottratta: %.2f EUR)"
             % (n, sum(p["n_deal"] for p in pos), len(vin), len(per), pf(pos),
                sum(p["net"] for p in pos), sum(p["comm"] for p in pos)))
    if pos:
        L.append("- chiusure dal %s al %s; lati: %s" % (
            min(p["t_last"] for p in pos).date(), max(p["t_last"] for p in pos).date(),
            dict(Counter(p["side"] for p in pos))))
        L.append("- media vinta %+.0f EUR, media persa %+.0f EUR, rapporto |media persa|/media vinta = %.2f"
                 % (sum(p["net"] for p in vin) / max(1, len(vin)),
                    sum(p["net"] for p in per) / max(1, len(per)),
                    (abs(sum(p["net"] for p in per) / max(1, len(per))) /
                     max(1e-9, sum(p["net"] for p in vin) / max(1, len(vin))))))
        qv = quartili([p["per_lotto"] for p in vin])
        qp = quartili([p["per_lotto"] for p in per])
        if qv:
            L.append("- EUR/lotto vinti (min/Q1/med/Q3/max): %s" % " / ".join("%.0f" % x for x in qv))
        if qp:
            L.append("- EUR/lotto persi  (min/Q1/med/Q3/max): %s" % " / ".join("%.0f" % x for x in qp))
        b, w, runs = sequenze(pos)
        L.append("- sequenze: max vincite consecutive %d, max perdite consecutive %d; "
                 "serie di perdite per lunghezza: %s" % (b, w, dict(sorted(runs.items()))))
    L += tabella("Per MOTIVO d'uscita [DERIVATO dall'ora e dalla forma dei deal]", pos,
                 lambda p: p["motivo"],
                 ["STOP_PIENO", "TP1_BE", "TP1_RUN", "TIMESTOP", "ALTRO"])
    L += tabella("Per ORA di chiusura dell'ultimo deal (ora server BCM)", pos,
                 lambda p: "%02d" % p["t_last"].hour)
    L += tabella("Per GIORNO della settimana", pos,
                 lambda p: WD[p["t_last"].weekday()], WD)
    L += tabella("Per ANNO", pos, lambda p: p["t_last"].year)
    L += tabella("Per MESE (tutti gli anni insieme)", pos, lambda p: "%02d" % p["t_last"].month)
    L += tabella("Per STAGIONE dell'orologio (ora legale = Xetra/US allineati al preset; solare = un'ora sfasati)",
                 pos, lambda p: "ORA_LEGALE" if ora_legale(p["day"]) else "ORA_SOLARE",
                 ["ORA_LEGALE", "ORA_SOLARE"])
    L += tabella("Per ANNO x STAGIONE", pos,
                 lambda p: "%d-%s" % (p["t_last"].year, "L" if ora_legale(p["day"]) else "S"))
    # Persi: ora di chiusura x motivo
    L.append("")
    L.append("**Persi: ora di chiusura x motivo** (quante posizioni perse chiudono a che ora e perche')")
    L.append("")
    g = defaultdict(Counter)
    for p in per:
        g["%02d" % p["t_last"].hour][p["motivo"]] += 1
    motivi = ["STOP_PIENO", "TP1_BE", "TIMESTOP", "ALTRO"]
    L.append("| ora | " + " | ".join(motivi) + " | tot |")
    L.append("|---|" + "---:|" * (len(motivi) + 1))
    for h in sorted(g):
        L.append("| %s | %s | %d |" % (h, " | ".join(str(g[h][m]) for m in motivi), sum(g[h].values())))
    # minuti dallo start delle 08:00 per gli STOP_PIENO
    sp = [p for p in per if p["motivo"] == "STOP_PIENO"]
    if sp:
        mins = sorted((p["t_last"].hour * 60 + p["t_last"].minute) for p in sp)
        L.append("")
        L.append("- STOP_PIENO: %d posizioni; ora di chiusura min/med/max = %02d:%02d / %02d:%02d / %02d:%02d"
                 % (len(sp), mins[0] // 60, mins[0] % 60, mins[len(mins) // 2] // 60,
                    mins[len(mins) // 2] % 60, mins[-1] // 60, mins[-1] % 60))
        entro = sum(1 for m in mins if m <= 9 * 60)
        L.append("- di cui chiusi ENTRO le 09:00 server (stop preso nella prima ora dopo il piazzamento delle 07:59): %d su %d"
                 % (entro, len(sp)))
    return L


# ----------------------------------------------------------------------
#  Confronto per giorno fra due motori (specchio o asimmetria)
# ----------------------------------------------------------------------
def confronto_giorni(posA, labA, posB, labB):
    dA = {p["day"]: p for p in posA}
    dB = {p["day"]: p for p in posB}
    comuni = sorted(set(dA) & set(dB))
    L = ["", "**Giorni in cui hanno operato ENTRAMBI (%s e %s): %d**" % (labA, labB, len(comuni))]
    if comuni:
        L.append("")
        L.append("| giorno | %s net | %s motivo | %s net | %s motivo |" % (labA, labA, labB, labB))
        L.append("|---|---:|---|---:|---|")
        for d in comuni:
            L.append("| %s | %+.0f | %s | %+.0f | %s |" % (d, dA[d]["net"], dA[d]["motivo"],
                                                     dB[d]["net"], dB[d]["motivo"]))
    soloA = len(set(dA) - set(dB))
    soloB = len(set(dB) - set(dA))
    L.append("")
    L.append("- giorni solo %s: %d; giorni solo %s: %d" % (labA, soloA, labB, soloB))
    return L


# ----------------------------------------------------------------------
#  Autotest (contro-esempi costruiti a mano)
# ----------------------------------------------------------------------
def _csv(rows):
    s = "close_time;symbol;magic;position_id;deal_type;volume;price;net_profit\n"
    for r in rows:
        s += ";".join(str(x) for x in r) + "\n"
    return s


def autotest():
    ok = True

    def check(cond, msg):
        nonlocal ok
        print(("  ok   " if cond else "  FAIL ") + msg)
        ok = ok and cond

    # 1) aggregazione: 3 deal su 2 posizioni; commissione k=2 su 1.5 lotti
    txt = _csv([
        ("2025.01.06 08:05:00", "XAUUSD", "1", "3", "1", "0.50", "2000", "-100.00"),
        ("2025.01.07 10:00:00", "XAUUSD", "1", "6", "1", "0.50", "2000", "50.00"),
        ("2025.01.07 17:30:00", "XAUUSD", "1", "6", "1", "0.50", "2010", "80.00"),
    ])
    pos = aggrega(leggi_deal(io.StringIO(txt)), k_lotto=2.0)
    check(len(pos) == 2, "2 posizioni da 3 deal")
    check(abs(pos[0]["net"] - (-100 - 1.0)) < 1e-9, "commissione k*vol sottratta (0.5 lotti x 2 = 1)")
    check(abs(pos[1]["net"] - (130 - 2.0)) < 1e-9, "posizione a 2 deal: somma 130 - 2 di commissione")
    check(abs(sum(p["net_deal"] for p in pos) - 30.0) < 1e-9, "somma dei deal conservata (30)")
    check(pos[0]["motivo"] == "STOP_PIENO", "1 deal negativo alle 08:05 -> STOP_PIENO")
    check(pos[1]["motivo"] == "TIMESTOP", "ultimo deal alle 17:30 -> TIMESTOP anche con TP1 preso")
    # 2) contro-esempio: 2 deal, secondo ~0 -> TP1_BE, non TP1_RUN
    txt = _csv([
        ("2025.02.03 08:40:00", "D30EUR", "1", "9", "0", "10", "20000", "500.00"),
        ("2025.02.03 09:10:00", "D30EUR", "1", "9", "0", "10", "20050", "-4.00"),
    ])
    pos = aggrega(leggi_deal(io.StringIO(txt)))
    check(pos[0]["motivo"] == "TP1_BE" and pos[0]["side"] == "SHORT", "TP1 poi breakeven -> TP1_BE, lato SHORT da deal_type 0")
    # 3) contro-esempio: deal_type misti sulla stessa posizione -> errore
    txt = _csv([
        ("2025.02.03 08:40:00", "D30EUR", "1", "9", "0", "10", "20000", "500.00"),
        ("2025.02.03 09:10:00", "D30EUR", "1", "9", "1", "10", "20050", "-4.00"),
    ])
    try:
        aggrega(leggi_deal(io.StringIO(txt)))
        check(False, "deal_type misti devono fermare")
    except ValueError:
        check(True, "deal_type misti fermano lo script")
    # 4) orologio: 2025 ora legale dal 30/03 al 26/10 (esclusa)
    check(not ora_legale(date(2025, 3, 29)) and ora_legale(date(2025, 3, 30)),
          "ora legale 2025 parte il 30/03")
    check(ora_legale(date(2025, 10, 25)) and not ora_legale(date(2025, 10, 26)),
          "ora legale 2025 finisce il 26/10")
    check(ora_legale(date(2024, 10, 26)) and not ora_legale(date(2024, 10, 27)),
          "ora legale 2024 finisce il 27/10")
    check(not ora_legale(date(2026, 3, 28)) and ora_legale(date(2026, 3, 29)),
          "ora legale 2026 parte il 29/03")
    # 5) PF: contro-esempio con zero perdite -> inf, con zero vincite -> 0
    check(pf([{"net": 10}]) == float("inf") and pf([{"net": -10}]) == 0.0, "PF ai bordi")
    # 6) sequenze: V P P V P P P -> max vincite 1, max perdite 3, serie {2:1,3:1}
    seq = [{"net": s, "t_last": datetime(2025, 1, 1) + timedelta(days=i)}
           for i, s in enumerate([1, -1, -1, 1, -1, -1, -1])]
    b, w, runs = sequenze(seq)
    check(b == 1 and w == 3 and runs == Counter({2: 1, 3: 1}), "sequenze V P P V P P P")
    # 7) quartili su 5 valori
    check(quartili([1, 2, 3, 4, 5]) == [1, 2, 3, 4, 5], "quartili 1..5")
    # 8) sovrapposizione di date fra due file deve fermare (vedi main)
    print("AUTOTEST " + ("PASS" if ok else "FAIL"))
    return 0 if ok else 1


# ----------------------------------------------------------------------
def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("files", nargs="*")
    ap.add_argument("--k", type=float, default=0.0, help="commissione d'ingresso EUR/lotto (classe 844)")
    ap.add_argument("--close", default="17:30", help="ora di flat del preset (InpCloseHour:InpCloseMin, server)")
    ap.add_argument("--label", default=None)
    ap.add_argument("--md", default=None, help="scrive il referto markdown qui (altrimenti stdout)")
    ap.add_argument("--confronta", nargs="*", default=None,
                    help="secondo gruppo di file per il confronto giorno per giorno")
    ap.add_argument("--label2", default="B")
    ap.add_argument("--k2", type=float, default=0.0)
    ap.add_argument("--autotest", action="store_true")
    a = ap.parse_args()
    if a.autotest:
        sys.exit(autotest())
    if not a.files:
        ap.error("servono file per-trade (o --autotest)")
    hh, mm = (int(x) for x in a.close.split(":"))

    def carica(files, k):
        deals = []
        spans = []
        for f in files:
            with open(f, encoding="utf-8-sig") as fh:
                d = leggi_deal(fh)
            if not d:
                raise SystemExit("file vuoto: %s" % f)
            spans.append((min(x["t"] for x in d), max(x["t"] for x in d), f))
            deals += d
        spans.sort()
        for (s1, e1, f1), (s2, e2, f2) in zip(spans, spans[1:]):
            if s2 <= e1:
                raise SystemExit("finestre sovrapposte: %s (fino %s) e %s (da %s)" % (f1, e1, f2, s2))
        return aggrega(deals, k_lotto=k, close_hm=(hh, mm))

    posA = carica(a.files, a.k)
    labA = a.label or os.path.basename(a.files[0])
    out = ["<!-- generato da backtest_pipeline/autopsia_pertrade.py -->",
           "file: " + ", ".join(a.files) + " (k=%.2f EUR/lotto, flat %s)" % (a.k, a.close), ""]
    out += autopsia(posA, labA, (hh, mm))
    if a.confronta:
        posB = carica(a.confronta, a.k2)
        out += ["", "file confronto: " + ", ".join(a.confronta) + " (k=%.2f)" % a.k2]
        out += autopsia(posB, a.label2, (hh, mm))
        out += confronto_giorni(posA, labA, posB, a.label2)
    txt = "\n".join(out) + "\n"
    if a.md:
        with open(a.md, "w", encoding="utf-8") as fh:
            fh.write(txt)
        print("scritto %s (%d righe)" % (a.md, len(out)))
    else:
        sys.stdout.write(txt)


if __name__ == "__main__":
    main()
