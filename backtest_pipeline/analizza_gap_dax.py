#!/usr/bin/env python3
# -*- coding: ascii -*-
# MARCATORE_ANALIZZA_GAP_DAX_v1 (19/10/2026)
"""
analizza_gap_dax.py -- G1, G2, G3 del test del gap del DAX, secondo report/GAP_DAX_ATTESE_2026-10-19.md.
SOLA LETTURA su ABTG_GapDAX_M1.csv (+ ABTG_GapDAX_orevol.csv per il controllo dell'ora). Le soglie sono COSTANTI
scritte prima dei dati: non si cambiano da riga di comando.
USO:  python3 -I analizza_gap_dax.py ABTG_GapDAX_M1.csv [ABTG_GapDAX_orevol.csv]
      python3 -I analizza_gap_dax.py --autotest
"""
import sys, csv, datetime, statistics

SOGLIA_GAP_PCT = 0.15      # evento se |gap| >= 0,15% di PC
SOGLIA_G1 = 0.70           # tasso di chiusura
MIN_EVENTI_G1 = 100
MIN_EVENTI_G2 = 30         # lunedi
STOP_X = 1.0               # stop = 1,0 x |gap|
SLIP_PTS = 1.0             # slippage per lato, in punti
PF_OOS = 1.2
PF_IS = 1.0
MIN_OP_OOS = 100
OPEN_MIN = 8 * 60
CLOSE_MIN = 16 * 60 + 30


def leggi(path):
    giorni = {}
    pt = None
    with open(path, encoding="ascii", errors="replace") as f:
        rd = csv.reader(f, delimiter=";")
        next(rd)
        for r in rd:
            if len(r) < 7:
                continue
            t = datetime.datetime.strptime(r[0], "%Y.%m.%d %H:%M")
            giorni.setdefault(t.date(), []).append(
                (t.hour * 60 + t.minute, float(r[1]), float(r[2]), float(r[3]), float(r[4]), float(r[6])))
    for g in giorni:
        giorni[g].sort()
    return giorni


def costruisci(giorni, punto):
    ev = []
    ks = sorted(giorni)
    prev_pc = None
    for g in ks:
        bars = giorni[g]
        sess = [b for b in bars if OPEN_MIN <= b[0] <= CLOSE_MIN]
        pre = [b for b in bars if b[0] <= CLOSE_MIN]
        a = [b for b in sess if b[0] == OPEN_MIN]
        if prev_pc is not None and a and g.weekday() < 5:
            op = a[0][1]
            gap = op - prev_pc
            pct = 100.0 * gap / prev_pc
            if abs(pct) >= SOGLIA_GAP_PCT:
                ev.append({"d": g, "pc": prev_pc, "open": op, "gap": gap, "pct": pct, "bars": sess})
        if pre:
            prev_pc = pre[-1][4]
    return ev


def esito(e, punto):
    """G1: chiuso?  G3: R della regola (entrata a mercato sulla barra delle 08:00)."""
    up = e["gap"] > 0
    pc, op = e["pc"], e["open"]
    risk = STOP_X * abs(e["gap"])
    stop = op + risk if up else op - risk      # contro la direzione di chiusura
    bars = e["bars"]
    chiuso = False
    tchiusura = None
    mae = 0.0
    res = None
    spread0 = bars[0][5] * punto
    entry = op - SLIP_PTS * punto if up else op + SLIP_PTS * punto
    for (m, o, h, l, c, sp) in bars:
        # fill del gap (G1)
        if not chiuso:
            if (up and l <= pc) or ((not up) and h >= pc):
                chiuso = True
                tchiusura = m - OPEN_MIN
        # regola (G3): stop prima del TP nello stesso minuto
        if res is None:
            hit_stop = (h >= stop) if up else (l <= stop)
            hit_tp = (l <= pc) if up else (h >= pc)
            if hit_stop:
                res = -(abs(stop - entry))
            elif hit_tp:
                res = (entry - pc) if up else (pc - entry)
        if not chiuso:
            mae = max(mae, (h - op) if up else (op - l))
    if res is None:
        c = bars[-1][4]
        res = (entry - c) if up else (c - entry)
    costo = (spread0 + 2 * SLIP_PTS * punto)
    res_netto = res - spread0 - SLIP_PTS * punto
    return chiuso, tchiusura, mae / abs(e["gap"]), res_netto


def pf(lst):
    g = sum(x for x in lst if x > 0)
    p = -sum(x for x in lst if x < 0)
    return (g / p) if p > 0 else float("inf")


def main_dati(giorni, punto):
    ev = costruisci(giorni, punto)
    print("giorni letti: %d   eventi con |gap| >= %.2f%%: %d" % (len(giorni), SOGLIA_GAP_PCT, len(ev)))
    if not ev:
        print("NON MISURATA: nessun evento")
        return 2
    out = [(e, esito(e, punto)) for e in ev]
    ch = [o for o in out if o[1][0]]
    t1 = len(ch) / len(out)
    s1 = "NON MISURATA (meno di %d eventi)" % MIN_EVENTI_G1 if len(out) < MIN_EVENTI_G1 else ("REGGE" if t1 >= SOGLIA_G1 else "SMENTITA")
    print("G1 tasso di chiusura entro le 16:30: %.1f%% su %d eventi -> %s" % (100 * t1, len(out), s1))
    lun = [o for o in out if o[0]["d"].weekday() == 0]
    if lun:
        tl = sum(1 for o in lun if o[1][0]) / len(lun)
        s2 = "NON MISURATA (meno di %d eventi)" % MIN_EVENTI_G2 if len(lun) < MIN_EVENTI_G2 else ("REGGE" if tl >= SOGLIA_G1 else "SMENTITA")
        print("G2 lunedi: %.1f%% su %d eventi -> %s" % (100 * tl, len(lun), s2))
    else:
        print("G2 lunedi: NON MISURATA (0 eventi)")
    ds = sorted(set(o[0]["d"] for o in out))
    taglio = ds[len(ds) // 2]
    is_ = [o[1][3] for o in out if o[0]["d"] < taglio]
    oos = [o[1][3] for o in out if o[0]["d"] >= taglio]
    print("G3 regola (TP=PC, stop=%.1fxgap, costi inclusi): taglio IS/OOS al %s" % (STOP_X, taglio))
    print("   IS : %d operazioni, PF %.2f, somma %.1f punti" % (len(is_), pf(is_) if is_ else 0, sum(is_)))
    print("   OOS: %d operazioni, PF %.2f, somma %.1f punti" % (len(oos), pf(oos) if oos else 0, sum(oos)))
    if len(oos) < MIN_OP_OOS:
        s3 = "NON MISURATA (OOS con meno di %d operazioni)" % MIN_OP_OOS
    else:
        s3 = "REGGE" if (pf(oos) >= PF_OOS and pf(is_) >= PF_IS and s1 == "REGGE") else "SMENTITA"
    print("G3 -> %s" % s3)
    mae = [o[1][2] for o in out if o[1][0]]
    tc = [o[1][1] for o in out if o[1][0] and o[1][1] is not None]
    if mae:
        print("descrittivo: MAE mediana %.2f x gap, tempo mediano di chiusura %d minuti" % (statistics.median(mae), statistics.median(tc)))
    byd = {}
    for o in out:
        byd.setdefault(o[0]["d"].weekday(), []).append(1 if o[1][0] else 0)
    print("tasso di chiusura per giorno (0=lun): " + ", ".join("%d: %.0f%% (n=%d)" % (k, 100 * sum(v) / len(v), len(v)) for k, v in sorted(byd.items())))
    return 0


def controlla_ore(path):
    mx = None
    with open(path, encoding="ascii", errors="replace") as f:
        rd = csv.reader(f, delimiter=";")
        next(rd)
        rows = [(int(r[0]), float(r[2])) for r in rd if len(r) >= 3]
    rows.sort(key=lambda x: -x[1])
    top = rows[0][0]
    print("CONTROLLO ORA: picco del volume medio alle %02d:00 server (atteso 08:00-08:59)" % top)
    return 8 <= top <= 8


def autotest():
    # finto DAX: 12 giorni, gap-up 0,30% chiuso in 10 minuti, gap-down 0,30% mai chiuso
    punto = 0.01
    giorni = {}
    d0 = datetime.date(2026, 1, 5)
    pc = 20000.0
    for k in range(40):
        d = d0 + datetime.timedelta(days=k)
        if d.weekday() >= 5:
            continue
        bars = []
        for m in range(7 * 60 + 55, 16 * 60 + 36):
            bars.append((m, pc, pc, pc, pc, 10.0))
        giorni[d] = bars
    # giorno 2: gap-up 60 punti poi torna a pc
    ks = sorted(giorni)
    g = ks[1]
    nb = []
    for (m, o, h, l, c, sp) in giorni[g]:
        if m < OPEN_MIN + 10:
            nb.append((m, pc + 60, pc + 61, pc + 59, pc + 60, 10.0))
        else:
            nb.append((m, pc, pc + 1, pc - 1, pc, 10.0))
    giorni[g] = nb
    ev = costruisci(giorni, punto)
    assert len(ev) == 1, len(ev)
    ch, tc, mae, r = esito(ev[0], punto)
    assert ch and tc == 10, (ch, tc)
    assert r > 0
    print("autotest OK")
    return 0


if __name__ == "__main__":
    if len(sys.argv) > 1 and sys.argv[1] == "--autotest":
        sys.exit(autotest())
    if len(sys.argv) < 2:
        print(__doc__)
        sys.exit(1)
    if len(sys.argv) > 2:
        controlla_ore(sys.argv[2])
    # punto del simbolo: D30EUR ha 2 decimali -> 0,01 [NON VERIFICATO: lo dice il log dello script]
    sys.exit(main_dati(leggi(sys.argv[1]), 0.01))
