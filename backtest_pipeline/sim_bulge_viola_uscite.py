#!/usr/bin/env python3
# =====================================================================
#  sim_bulge_viola_uscite.py -- SOLA LETTURA. Simulatore OFFLINE delle uscite del Bulge VIOLA sul
#  CSV di telemetria (formato: report/BULGE_VIOLA_TELEMETRIA_SPEC_2026-10-08.md). Oggi il CSV NON
#  ESISTE (la copia di banco ABTG_Bulge_Telemetria non e' ancora scritta): l'autotest usa percorsi
#  FINTI a risposta nota. Non tocca EA, preset, forward; non propone taglie.
#
#  Regole simulate (entrata INVARIATA: stesso segnale, stesse aperture; cambia solo l'uscita):
#    BE(b, offset)            break-even a b R (come Enable_BE_1R/BE_At_R/BE_Offset_Points)
#    TRAIL(start, step)       formula ESATTA di TrailLockR dell'EA (lock = start + n*step - 1, minimo 0):
#                             con start < 1 e' un BE a `start` finche' r < 1 + (n*step): NON un vero trailing
#    PARZ(b, pct)             chiusura parziale a b R + BE sul residuo (come DoPartialCloseIfNeeded)
#    TSTOP(N ore, X R)        time-stop: all'ora N, se l'MTM < X R, esci
#    V1(m, x)                 invalidazione a T+m min: prezzo avverso di almeno x ATR dall'entrata
#    V2(m)                    candela d'entrata di colore opposto al trade a T+m E prezzo oltre il centro del
#                             range della candela del segnale (cnf)
#    V3(m, gap)               apertura con GAP contro (oltre il close della candela cnf di `gap` ATR) E a T+m il
#                             prezzo e' ancora sotto/sopra l'apertura (continua nel verso opposto)
#    V5                       a fine candela d'entrata (minuto 60), se chiude di colore opposto, esci
#    V4 = V1/V2/V3 a m = 15 e 45 (sensibilita' al momento)
#  Effetto sulla FREQUENZA: portafoglio rigiocato con Max_Trades e HasOpenTrade: l'uscita anticipata libera slot
#  e i segnali BLOCK_MAXTRADES/BLOCK_HASOPEN possono diventare aperture (solo cosi' si vede l'effetto vero).
#
#  KILL SWITCH NON SIMULATO nel rigioco del portafoglio: ma nell'EA un BE colpito e' un'uscita per SL (DEAL_REASON_SL) e conta come SL
#  (4 al giorno, 3 consecutivi): l'effetto delle regole BE/TRAIL/PARZ sulla FREQUENZA e' quindi SOTTOSTIMATO qui e va misurato nel tester (Trades(cella)/Trades(A)).
#
#  CONVENZIONI (dichiarate, non nascoste): percorso a BID; long entra ask / esce bid; short entra bid / esce ask
#  (= bid + spread di barra). Dentro una barra l'ordine e' PESSIMISTICO: prima il lato avverso (SL), poi il
#  favorevole (TP). BE/trailing/parziale scattano sull'estremo favorevole della barra e valgono dalla barra
#  successiva. STOPS_LEVEL ignorato. TP dinamico = mid1 (mediana BB barra 1) con le condizioni di UpdateAllTP.
#  Costo: commissione per trade in R (`comm_r`, dalla mediana commission/risk_money delle OPENED).
#
#  USO:
#     python3 backtest_pipeline/sim_bulge_viola_uscite.py --autotest
#     python3 backtest_pipeline/sim_bulge_viola_uscite.py --controlla <cartella con i 2 CSV>
#     python3 backtest_pipeline/sim_bulge_viola_uscite.py --analizza  <cartella con i 2 CSV>
#
#  ATTESE (scritte PRIMA di avere un solo dato vero; nel file prova e nel dossier):
#   - rigioco di base: >= 95% delle OPENED coincide con l'uscita reale, altrimenti la simulazione NON e' valida.
#   - BE/PARZ/TRAIL a trigger >= 0,75 R: effetto ~0 (nessuna vincita arriva a 1 R). A 0,3 R: l'effetto
#     netto e' fra -0,10 e +0,10 R per trade; il segno dipende dal rapporto perdenti salvate / vincitori tagliati
#     (pareggio: 0,27 perdenti salvate per ogni vincitore tagliato).
#   - V1/V2/V3/V5: quota di trade chiusi in anticipo 10-40%; la regola e' utile solo se il r medio dei chiusi in
#     anticipo (all'uscita anticipata) e' MEGLIO del loro r di base; ALTERNATIVA: i chiusi hanno r di base ~ -0,1 come tutti
#     e l'uscita anticipata costa lo spread -> delta ~ 0 o negativo.
#   - molte combinazioni: la migliore e' un PICCO DI RUMORE finche' non c'e' un altopiano di 3 celle e una replica fuori campione.
# =====================================================================
import collections
import csv
import datetime
import glob
import math
import os
import random
import statistics as st
import sys

FMT = "%Y.%m.%d %H:%M:%S"
SEME = 20261008


# ------------------------------------------------------------------ utilita'
def T(s):
    return datetime.datetime.strptime(s, FMT)


def pf(v):
    g = sum(x for x in v if x > 0)
    p = -sum(x for x in v if x <= 0)
    return g / p if p > 0 else (float("inf") if g > 0 else float("nan"))


def dd(seq):
    cum = pk = m = 0.0
    for x in seq:
        cum += x
        pk = max(pk, cum)
        m = max(m, pk - cum)
    return m


def trail_lock_r(r, start, step):
    """Copia aritmetica di TrailLockR (ABTG_Bulge.mq5): -1 = non attivo."""
    if step <= 0 or r < start:
        return -1.0
    steps = math.floor((r - start) / step)
    lock = (start + max(0, steps) * step) - 1.0
    return max(lock, 0.0)


# ------------------------------------------------------------------ caricamento
def carica(cartella):
    fs = glob.glob(os.path.join(cartella, "abtg_tel_segnali_*.csv"))
    fp = glob.glob(os.path.join(cartella, "abtg_tel_path_*.csv"))
    if len(fs) != 1 or len(fp) != 1:
        raise SystemExit("servono esattamente 1 file segnali e 1 file path in %s (trovati %d, %d)" % (cartella, len(fs), len(fp)))
    sig = {}
    for r in csv.DictReader(open(fs[0], encoding="ascii", errors="replace"), delimiter=";"):
        d = dict(r)
        for k in ("side", "sig_id", "atr_ok", "pos_id", "server_utc_offset_h"):
            if d.get(k, "") != "":
                d[k] = int(d[k])
        for k in ("entry_ref_price", "atr_sig", "risk_dist", "sl_price", "tp_ini", "spread_entry_pts", "point", "pip_size",
                  "cnf_open", "cnf_high", "cnf_low", "cnf_close", "atr_ratio", "adx", "commission", "risk_money", "net",
                  "exit_price", "mfe_r", "mae_r"):
            if d.get(k, "") not in ("", None):
                d[k] = float(d[k])
        d["t_bar"] = T(d["bar_open_time"])
        d["t_exit"] = T(d["exit_time"]) if d.get("exit_time") else None
        sig[d["sig_id"]] = d
    path = collections.defaultdict(list)
    for r in csv.DictReader(open(fp[0], encoding="ascii", errors="replace"), delimiter=";"):
        path[int(r["sig_id"])].append({"tf": r["tf"], "k": int(r["k"]), "t": T(r["t_open"]), "o": float(r["o"]), "h": float(r["h"]),
                                       "l": float(r["l"]), "c": float(r["c"]), "sp": float(r["spread_pts"]), "mid1": float(r["mid1"]), "atr1": float(r["atr1"])})
    return sig, path


# ------------------------------------------------------------------ motore: UNA posizione, UNA regola
def rigioca(s, rows, regola):
    """Ritorna dict(t_exit, r (netto di comm), motivo, early (bool)). `regola` = dict di parametri (vuoto = base)."""
    side = s["side"]
    pt = s["point"]
    risk = s["risk_dist"]
    entry = s["entry_ref_price"]
    sl = s["sl_price"]
    tp = s["tp_ini"]
    comm_r = s.get("comm_r", 0.0)
    bid0 = rows[0]["o"]
    atr = s["atr_sig"]
    peso = 1.0                    # frazione ancora aperta
    r_real = 0.0                  # R gia' incassati (parziale)
    be_done = False
    parz_done = False
    fav_max = 0.0

    def esci(prezzo_bid, sp_pts, t, motivo, early):
        # long vende al bid; short compra all'ask = bid + spread
        px = prezzo_bid if side > 0 else prezzo_bid + sp_pts * pt
        r = r_real + peso * (side * (px - entry) / risk) - comm_r
        return {"t": t, "r": r, "motivo": motivo, "early": early}

    for row in rows:
        k, tf = row["k"], row["tf"]
        sp = row["sp"]
        # --- TP dinamico (UpdateAllTP): mid1 se oltre l'entrata e a >= 10 punti dal prezzo, e cambia > 5 punti
        mid = row["mid1"]
        if side > 0:
            if mid > entry and mid > row["o"] + 10 * pt and abs(mid - tp) > 5 * pt:
                tp = mid
        else:
            ask_o = row["o"] + sp * pt
            if mid < entry and mid < ask_o - 10 * pt and abs(mid - tp) > 5 * pt:
                tp = mid
        # --- uscite anticipate a minuto fisso (solo righe M1)
        if tf == "M1":
            m1 = regola.get("v1")
            if m1 and k == m1[0]:
                x = m1[1] * atr
                if (side > 0 and row["o"] < bid0 - x) or (side < 0 and row["o"] > bid0 + x):
                    return esci(row["o"], sp, row["t"], "V1", True)
            m2 = regola.get("v2")
            if m2 and k == m2:
                centro = (s["cnf_high"] + s["cnf_low"]) / 2.0
                if (side > 0 and row["o"] < bid0 and row["o"] < centro) or (side < 0 and row["o"] > bid0 and row["o"] > centro):
                    return esci(row["o"], sp, row["t"], "V2", True)
            m3 = regola.get("v3")
            if m3 and k == m3[0]:
                g = m3[1] * atr
                gap_contro = (side > 0 and bid0 < s["cnf_close"] - g) or (side < 0 and bid0 > s["cnf_close"] + g)
                if gap_contro and ((side > 0 and row["o"] < bid0) or (side < 0 and row["o"] > bid0)):
                    return esci(row["o"], sp, row["t"], "V3", True)
        # --- time-stop: all'apertura della prima barra con ora trascorsa >= N
        ts = regola.get("tstop")
        if ts:
            ore = (row["t"] - rows[0]["t"]).total_seconds() / 3600.0
            if ore >= ts[0] and not row.get("_ts"):
                mtm = side * (row["o"] - entry) / risk
                if mtm < ts[1]:
                    return esci(row["o"], sp, row["t"], "TSTOP", True)
        # --- lato avverso prima (SL), poi favorevole (TP): ordine PESSIMISTICO
        if side > 0:
            if row["l"] <= sl:
                return {"t": row["t"], "r": r_real + peso * (side * (sl - entry) / risk) - comm_r, "motivo": "sl" if not be_done else "be", "early": False}
            if row["h"] >= tp:
                return {"t": row["t"], "r": r_real + peso * (side * (tp - entry) / risk) - comm_r, "motivo": "tp", "early": False}
            fav = (row["h"] - entry) / risk
        else:
            if row["h"] + sp * pt >= sl:
                return {"t": row["t"], "r": r_real + peso * (side * (sl - entry) / risk) - comm_r, "motivo": "sl" if not be_done else "be", "early": False}
            if row["l"] + sp * pt <= tp:
                return {"t": row["t"], "r": r_real + peso * (side * (tp - entry) / risk) - comm_r, "motivo": "tp", "early": False}
            fav = (entry - (row["l"] + sp * pt)) / risk
        fav_max = max(fav_max, fav)
        # --- gestione (vale dalla barra successiva)
        be = regola.get("be")
        if be and fav_max >= be[0]:
            nuovo = entry + side * be[1] * pt
            if (side > 0 and nuovo > sl) or (side < 0 and nuovo < sl):
                sl = nuovo
                be_done = True
        tr = regola.get("trail")
        if tr:
            lock = trail_lock_r(fav_max, tr[0], tr[1])
            if lock >= 0:
                nuovo = entry + side * lock * risk
                if (side > 0 and nuovo > sl + tr[2] * pt) or (side < 0 and nuovo < sl - tr[2] * pt):
                    sl = nuovo
                    be_done = True
        pz = regola.get("parz")
        if pz and not parz_done and fav_max >= pz[0]:
            parz_done = True
            r_real += pz[1] * pz[0]            # incassato a b R (ipotesi: al trigger, senza slippage)
            r_real -= pz[1] * comm_r           # seconda commissione sulla quota chiusa
            peso -= pz[1]
            if (side > 0 and entry > sl) or (side < 0 and entry < sl):
                sl = entry
                be_done = True
        # --- V5: a fine candela d'entrata (riga M1 k=59, chiusura)
        if tf == "M1" and regola.get("v5") and k == 59:
            if (side > 0 and row["c"] < bid0) or (side < 0 and row["c"] > bid0):
                return esci(row["c"], sp, row["t"], "V5", True)
    ult = rows[-1]
    return esci(ult["c"], ult["sp"], ult["t"], "fine", False)


# ------------------------------------------------------------------ insiemi di regole
def regole_standard():
    R = collections.OrderedDict()
    R["BASE"] = {}
    for b in (0.3, 0.5, 0.75):
        R["BE %.2f R" % b] = {"be": (b, 2)}
    for st_ in (0.5, 0.75):
        R["TRAIL start %.2f step 0.25" % st_] = {"trail": (st_, 0.25, 10)}
    R["PARZ 50% a 0.50 R"] = {"parz": (0.5, 0.5)}
    for m in (15, 30, 45):
        for x in (0.0, 0.25, 0.5):
            R["V1 T+%d adverso >= %.2f ATR" % (m, x)] = {"v1": (m, x)}
    for m in (15, 30, 45):
        R["V2 T+%d colore opposto e oltre centro cnf" % m] = {"v2": m}
    for m in (15, 30, 45):
        R["V3 T+%d gap contro + continua" % m] = {"v3": (m, 0.0)}
    R["V5 fine candela opposta"] = {"v5": True}
    for n in (6, 12):
        R["TSTOP %dh se MTM < 0" % n] = {"tstop": (n, 0.0)}
    return R


# ------------------------------------------------------------------ valutazione di un insieme di regole
def esiti(sig, path, regola, ids):
    out = {}
    for i in ids:
        out[i] = rigioca(sig[i], path[i], regola)
    return out


def bootstrap_delta(deltas, cluster, rng, B=2000):
    gr = collections.defaultdict(list)
    for d, c in zip(deltas, cluster):
        gr[c].append(d)
    cl = list(gr.values())
    n = sum(len(g) for g in cl)
    if len(cl) < 2 or n == 0:
        return float("nan"), float("nan")
    ms = []
    for _ in range(B):
        s = [rng.choice(cl) for _ in cl]
        tot = sum(len(g) for g in s)
        ms.append(sum(sum(g) for g in s) / tot if tot else 0.0)
    ms.sort()
    return ms[int(0.025 * B)], ms[int(0.975 * B) - 1]


def valuta_regola(nome, regola, sig, path, ids, base, rng):
    ris = esiti(sig, path, regola, ids)
    early = [i for i in ids if ris[i]["early"]]
    rb = [base[i]["r"] for i in ids]
    rr = [ris[i]["r"] for i in ids]
    order = sorted(ids, key=lambda i: ris[i]["t"])
    order_b = sorted(ids, key=lambda i: base[i]["t"])
    deltas = [ris[i]["r"] - base[i]["r"] for i in ids]
    lo, hi = bootstrap_delta(deltas, [sig[i]["t_bar"].date() for i in ids], rng)
    return {"nome": nome, "n": len(ids), "n_early": len(early),
            "r_early_rule": (sum(ris[i]["r"] for i in early) / len(early)) if early else float("nan"),
            "r_early_base": (sum(base[i]["r"] for i in early) / len(early)) if early else float("nan"),
            "r_resto": (sum(ris[i]["r"] for i in ids if i not in early) / max(1, len(ids) - len(early))),
            "sum_base": sum(rb), "sum_rule": sum(rr), "delta": sum(rr) - sum(rb), "d_lo": lo, "d_hi": hi,
            "pf_base": pf(rb), "pf_rule": pf(rr),
            "dd_base": dd([base[i]["r"] for i in order_b]), "dd_rule": dd([ris[i]["r"] for i in order])}


def portafoglio(sig, path, ids_candidati, regola, max_trades=4, usa_atr_ok=True):
    """Rigioca il portafoglio: i candidati sono OPENED/BLOCK_MAXTRADES/BLOCK_HASOPEN (e atr_ok==1) in ordine di tempo;
    un candidato entra se (aperte < max_trades) e non c'e' gia' la stessa (simbolo, lato). Le uscite dipendono da `regola`."""
    cand = [i for i in ids_candidati if sig[i]["outcome"] in ("OPENED", "BLOCK_MAXTRADES", "BLOCK_HASOPEN")
            and (not usa_atr_ok or sig[i]["atr_ok"] == 1)]
    cand.sort(key=lambda i: (sig[i]["t_bar"], i))
    aperte = []                    # (t_exit, sym, side)
    presi, r_tot = [], 0.0
    for i in cand:
        t = sig[i]["t_bar"]
        aperte = [a for a in aperte if a[0] > t]
        if len(aperte) >= max_trades:
            continue
        if any(a[1] == sig[i]["symbol"] and a[2] == sig[i]["side"] for a in aperte):
            continue
        e = rigioca(sig[i], path[i], regola)
        aperte.append((e["t"], sig[i]["symbol"], sig[i]["side"]))
        presi.append(i)
        r_tot += e["r"]
    return {"n": len(presi), "sum_r": r_tot, "ids": presi}


def controlla(sig, path):
    opened = [i for i in sig if sig[i]["outcome"] == "OPENED"]
    ok_ = 0
    dist = []
    for i in opened:
        s = sig[i]
        e = rigioca(s, path[i], {})
        mot_real = s["exit_reason"]
        if e["motivo"] == mot_real or (e["motivo"] in ("sl", "tp") and mot_real == e["motivo"]):
            ok_ += 1
        else:
            dist.append((i, e["motivo"], mot_real))
    return len(opened), ok_, dist


def prepara(sig):
    comm = [abs(s["commission"]) / s["risk_money"] for s in sig.values() if s["outcome"] == "OPENED" and s.get("risk_money")]
    cr = st.median(comm) if comm else 0.0
    for s in sig.values():
        s["comm_r"] = cr
    return cr


def analizza(sig, path):
    rng = random.Random(SEME)
    cr = prepara(sig)
    n, ok_, mism = controlla(sig, path)
    print("COMMISSIONE per trade: %.4f R (mediana OPENED)" % cr)
    print("RIGIOCO DI BASE: %d OPENED, uscita coincidente %d (%.1f%%)  [soglia di validita' 95%%]" % (n, ok_, 100.0 * ok_ / max(1, n)))
    if n and ok_ / float(n) < 0.95:
        print("  >>> SIMULAZIONE NON VALIDA per questa cella: nessun numero sotto si legge. Prime discordanze: %s" % mism[:5])
        return 1
    ids = [i for i in sig if sig[i]["outcome"] == "OPENED"]
    base = esiti(sig, path, {}, ids)
    print("\n%d regole x %d posizioni. Delta = somma(r regola - r base); IC95 = bootstrap per GIORNO sul delta MEDIO per posizione." % (len(regole_standard()) - 1, len(ids)))
    print("%-42s %4s %5s %8s %8s %8s %9s %17s %6s %6s %6s %6s" % ("regola", "n", "chius", "r chiusi", "r base", "r resto", "delta R", "IC95 delta medio", "PFb", "PFr", "DDb", "DDr"))
    for nome, rg in regole_standard().items():
        if nome == "BASE":
            continue
        v = valuta_regola(nome, rg, sig, path, ids, base, rng)
        print("%-42s %4d %5d %+8.3f %+8.3f %+8.3f %+9.2f [%+6.3f,%+6.3f] %6.2f %6.2f %6.1f %6.1f" % (
            nome, v["n"], v["n_early"], v["r_early_rule"], v["r_early_base"], v["r_resto"], v["delta"], v["d_lo"], v["d_hi"], v["pf_base"], v["pf_rule"], v["dd_base"], v["dd_rule"]))
    cand = [i for i in sig]
    pb = portafoglio(sig, path, cand, {})
    print("\nFREQUENZA (portafoglio rigiocato, Max_Trades=4): base %d aperture, somma r %+.2f" % (pb["n"], pb["sum_r"]))
    for nome in ("V1 T+30 adverso >= 0.00 ATR", "V2 T+30 colore opposto e oltre centro cnf", "V5 fine candela opposta", "BE 0.30 R"):
        rg = regole_standard()[nome]
        pr = portafoglio(sig, path, cand, rg)
        print("  %-42s aperture %d (%+d), somma r %+.2f (%+.2f)" % (nome, pr["n"], pr["n"] - pb["n"], pr["sum_r"], pr["sum_r"] - pb["sum_r"]))
    print("\nNOTA: %d regole provate; la migliore di molte e' un picco di rumore finche' non c'e' altopiano a 3 celle e replica fuori campione (regola 19/08)." % (len(regole_standard()) - 1))
    return 0


# ------------------------------------------------------------------ dati finti SENZA EDGE (random walk)
def genera_rumore(n, seed):
    """n segnali su percorsi di passeggiata aleatoria (nessun edge per costruzione): serve a misurare quante regole
    sembrano 'significative' per puro caso. Formato identico a quello caricato dai CSV."""
    rng = random.Random(seed)
    sig, path = {}, {}
    t0 = datetime.datetime(2026, 5, 4, 8)
    for i in range(1, n + 1):
        t = t0 + datetime.timedelta(hours=i * 5)
        side = rng.choice([1, -1])
        s = _sig(side=side)
        s.update({"sig_id": i, "t_bar": t, "exit_reason": "x", "risk_money": 100.0, "commission": -1.0})
        s["sl_price"] = 1.0 - side * 0.003
        s["tp_ini"] = 1.0 + side * 0.0007
        rows, p = [], 1.0
        for k in range(180):
            o = p
            p = p + rng.gauss(0, 0.00012)
            rows.append({"tf": "M1", "k": k, "t": t + datetime.timedelta(minutes=k), "o": o, "h": max(o, p) + 0.00003, "l": min(o, p) - 0.00003, "c": p, "sp": 0.0, "mid1": 0.99, "atr1": 0.001})
        for hh in range(3, 120):
            o = p
            p = p + rng.gauss(0, 0.0008)
            rows.append({"tf": "H1", "k": hh, "t": t + datetime.timedelta(hours=hh), "o": o, "h": max(o, p) + 0.0002, "l": min(o, p) - 0.0002, "c": p, "sp": 0.0, "mid1": 0.99, "atr1": 0.001})
        sig[i], path[i] = s, rows
    return sig, path


# ------------------------------------------------------------------ autotest con percorsi FINTI
def _sig(side=1, bid0=1.0, atr=0.001, sp=0, tp=1.0007, cnf=(1.0, 1.0004, 0.9990, 1.0002), comm_r=0.0):
    risk = 3 * atr
    sl = bid0 - side * risk
    return {"sig_id": 1, "symbol": "EURUSD", "side": side, "entry_ref_price": bid0 + (sp * 1e-5 if side > 0 else 0.0), "atr_sig": atr,
            "risk_dist": risk, "sl_price": sl, "tp_ini": tp, "point": 1e-5, "cnf_open": cnf[0], "cnf_high": cnf[1], "cnf_low": cnf[2],
            "cnf_close": cnf[3], "comm_r": comm_r, "t_bar": datetime.datetime(2026, 10, 1, 10), "outcome": "OPENED", "atr_ok": 1}


def _path(prezzi_m1, prezzi_h1=None, mid1=0.99, sp=0, t0=datetime.datetime(2026, 10, 1, 10)):
    """prezzi_m1: lista di 180 (o,h,l,c) oppure funzione minuto->(o,h,l,c); prezzi_h1: dict ora->(o,h,l,c)."""
    rows = []
    for k in range(180):
        o, h, l, c = prezzi_m1(k)
        rows.append({"tf": "M1", "k": k, "t": t0 + datetime.timedelta(minutes=k), "o": o, "h": h, "l": l, "c": c, "sp": sp, "mid1": mid1, "atr1": 0.001})
    if prezzi_h1:
        for hh in sorted(prezzi_h1):
            o, h, l, c = prezzi_h1[hh]
            rows.append({"tf": "H1", "k": hh, "t": t0 + datetime.timedelta(hours=hh), "o": o, "h": h, "l": l, "c": c, "sp": sp, "mid1": mid1, "atr1": 0.001})
    return rows


def flat(p):
    return (p, p, p, p)


def autotest():
    ko = []

    def ok(c, m):
        print("  [%s] %s" % ("OK" if c else "KO", m))
        if not c:
            ko.append(m)

    def near(a, b, e=1e-6):
        return abs(a - b) < e
    # T1: scende subito a 0.9985 e poi tocca lo SL (0.9970) all'ora 5
    def p1(k):
        return flat(1.0) if k < 10 else flat(0.9985)
    s1 = _sig()
    rows1 = _path(p1, {5: (0.9985, 0.9985, 0.9969, 0.9970)})
    b = rigioca(s1, rows1, {})
    ok(b["motivo"] == "sl" and near(b["r"], -1.0), "T1 base: SL, r = -1,000")
    v = rigioca(s1, rows1, {"v1": (30, 0.0)})
    ok(v["motivo"] == "V1" and near(v["r"], -0.5), "T1 V1 T+30 x=0: esce a 0.9985 -> r = -0,500 (risposta nota)")
    ok(near(rigioca(s1, rows1, {"v1": (30, 0.5)})["r"], -0.5), "T1 V1 con x=0,5 ATR: 0.9985 e' oltre 0.9995 -> esce comunque (-0,500)")
    # T2: CONTROESEMPIO -- scende un po' a 0.9996 e poi arriva al TP: V1 x=0 uccide un VINCITORE
    def p2(k):
        if k < 20:
            return flat(1.0)
        if k < 60:
            return flat(0.9996)
        return (0.9996, 1.0008, 0.9996, 1.0007)
    s2 = _sig()
    rows2 = _path(p2, mid1=0.99)
    b2 = rigioca(s2, rows2, {})
    ok(b2["motivo"] == "tp" and near(b2["r"], 0.0007 / 0.003), "T2 base: TP, r = +0,2333")
    ok(rigioca(s2, rows2, {"v1": (30, 0.0)})["motivo"] == "V1" and near(rigioca(s2, rows2, {"v1": (30, 0.0)})["r"], -0.0004 / 0.003),
       "T2 CONTROESEMPIO: V1 x=0 chiude un vincitore a -0,133 R (la regola costa 0,367 R)")
    ok(rigioca(s2, rows2, {"v1": (30, 0.5)})["motivo"] == "tp", "T2 V1 x=0,5 ATR (0.9995): 0.9996 non e' abbastanza avverso -> il vincitore resta")
    ok(rigioca(s2, rows2, {"v1": (15, 0.0)})["motivo"] == "tp", "T2 V1 a T+15: al minuto 15 il prezzo e' ancora 1.0 -> nessuna uscita (sensibilita' al momento)")
    # T3: BE a 0.3 R salva una perdita
    def p3(k):
        return flat(1.0) if k < 50 else (flat(1.0010) if k < 100 else flat(1.0009))
    s3 = _sig(tp=1.0015)
    rows3 = _path(p3, {4: (1.0009, 1.0009, 0.9969, 0.9970)})
    ok(near(rigioca(s3, rows3, {})["r"], -1.0), "T3 base: dopo aver toccato +0,33 R finisce a SL -> -1,000")
    be = rigioca(s3, rows3, {"be": (0.3, 2)})
    ok(be["motivo"] == "be" and near(be["r"], 0.00002 / 0.003, 1e-4), "T3 BE 0,3 R: la perdita diventa un pareggio (+0,007 R)")
    ok(near(rigioca(s3, rows3, {"be": (0.5, 2)})["r"], -1.0), "T3 BE 0,5 R: trigger mai raggiunto -> resta -1,000 (BE alto = inerte)")
    # T4: CONTROESEMPIO -- stesso picco, poi pullback a 1.0 e RIMBALZO al TP: il BE costa la vincita
    def p4(k):
        return flat(1.0) if k < 50 else (flat(1.0010) if k < 80 else flat(1.0))
    s4 = _sig(tp=1.0015)
    rows4 = _path(p4, {3: (1.0, 1.0016, 0.99999, 1.0015)})
    ok(rigioca(s4, rows4, {})["motivo"] == "tp" and near(rigioca(s4, rows4, {})["r"], 0.5), "T4 base: TP, r = +0,500")
    be4 = rigioca(s4, rows4, {"be": (0.3, 2)})
    ok(be4["motivo"] == "be" and be4["r"] < 0.01, "T4 CONTROESEMPIO: BE 0,3 R taglia il vincitore (da +0,500 a ~0): il BE basso ha un prezzo")
    # T5: TrailLockR -- start 0.5 e' un BE finche' r < 1.25 (aritmetica dell'EA)
    ok(trail_lock_r(0.4, 0.5, 0.25) == -1.0 and trail_lock_r(0.5, 0.5, 0.25) == 0.0 and trail_lock_r(1.0, 0.5, 0.25) == 0.0 and near(trail_lock_r(1.25, 0.5, 0.25), 0.25)
       and near(trail_lock_r(1.5, 1.5, 0.25), 0.5) and near(trail_lock_r(2.6, 1.5, 0.25), 1.5), "T5 TrailLockR: start 0,5 -> lock 0 fino a r=1,0; 0,25 a 1,25; start 1,5 -> 0,5 a 1,5 e 1,5 a 2,6 (come l'autotest dell'EA)")
    tr = rigioca(s3, rows3, {"trail": (0.5, 0.25, 10)})
    ok(near(rigioca(s3, rows3, {"be": (0.5, 0)})["r"], -1.0) and near(tr["r"], -1.0), "T5 trailing start 0,5 con picco 0,33 R: non scatta (come il BE a 0,5)")
    # T6: V5 colore: la candela chiude sotto l'apertura -> esce a fine candela
    def p6(k):
        return flat(1.0) if k < 30 else flat(0.9995)
    s6 = _sig(tp=1.0015)
    rows6 = _path(p6, {3: (0.9995, 0.9995, 0.9969, 0.9970)})
    v5 = rigioca(s6, rows6, {"v5": True})
    ok(v5["motivo"] == "V5" and near(v5["r"], -0.5 / 3.0), "T6 V5: chiude sotto l'apertura (-0,167 R) invece di finire a -1,000")
    # T7: V2 richiede ENTRAMBE le condizioni (colore opposto E oltre il centro della cnf)
    s7 = _sig(cnf=(1.0, 1.0004, 0.9990, 1.0002))     # centro 0.9997
    def p7a(k):
        return flat(1.0) if k < 30 else flat(0.9998)    # sotto l'apertura ma sopra il centro
    r7a = rigioca(s7, _path(p7a, {3: (0.9998, 0.9998, 0.9969, 0.9970)}), {"v2": 30})
    ok(r7a["motivo"] == "sl", "T7 V2: prezzo 0.9998 e' sotto l'apertura ma SOPRA il centro 0.9997 -> NON esce (controesempio della seconda condizione)")
    def p7b(k):
        return flat(1.0) if k < 30 else flat(0.9996)
    r7b = rigioca(s7, _path(p7b, {3: (0.9996, 0.9996, 0.9969, 0.9970)}), {"v2": 30})
    ok(r7b["motivo"] == "V2", "T7 V2: 0.9996 e' sotto apertura e centro -> esce")
    # T8: V3 gap contro
    s8 = _sig(cnf=(1.0010, 1.0012, 0.9998, 1.0006))    # close della cnf 1.0006: l'entrata a 1.0000 e' un gap di -0,0006 (0,6 ATR)
    def p8(k):
        return flat(1.0) if k < 30 else flat(0.9992)
    r8 = rigioca(s8, _path(p8, {3: (0.9992, 0.9992, 0.9969, 0.9970)}), {"v3": (30, 0.5)})
    ok(r8["motivo"] == "V3", "T8 V3: gap contro di 0,6 ATR (>= 0,5) e continua a scendere -> esce")
    r8b = rigioca(s8, _path(p8, {3: (0.9992, 0.9992, 0.9969, 0.9970)}), {"v3": (30, 0.8)})
    ok(r8b["motivo"] == "sl", "T8 V3 con gap minimo 0,8 ATR: il gap (0,6) non basta -> nessuna uscita")
    # T9: short speculare (V1) con spread
    s9 = _sig(side=-1)
    def p9(k):
        return flat(1.0) if k < 10 else flat(1.0015)
    r9 = rigioca(s9, _path(p9, {5: (1.0015, 1.0031, 1.0015, 1.0030)}, sp=10), {"v1": (30, 0.0)})
    ok(r9["motivo"] == "V1" and near(r9["r"], -(0.0015 + 0.0001) / 0.003, 1e-6), "T9 short V1: compra all'ask (bid + 10 punti): r = -0,533 (il costo dello spread e' dentro)")
    # T10: time-stop
    def p10(k):
        return flat(1.0) if k < 120 else flat(0.9990)
    r10 = rigioca(_sig(tp=1.0015), _path(p10, {3: (0.9990, 0.9990, 0.9969, 0.9970)}), {"tstop": (2, 0.0)})
    ok(r10["motivo"] == "TSTOP" and near(r10["r"], -0.001 / 0.003), "T10 time-stop a 2 ore con MTM < 0: esce a -0,333 R")
    # T11: portafoglio -- l'uscita anticipata libera uno slot e SALE la frequenza
    A = _sig()
    A["sig_id"] = 1
    Bs = _sig()
    Bs["sig_id"], Bs["symbol"] = 2, "GBPUSD"
    C = _sig()
    C["sig_id"], C["symbol"], C["t_bar"], C["outcome"] = 3, "AUDUSD", datetime.datetime(2026, 10, 1, 11), "BLOCK_MAXTRADES"
    sig = {1: A, 2: Bs, 3: C}
    t_c = datetime.datetime(2026, 10, 1, 11)
    path = {1: _path(p1, {5: (0.9985, 0.9985, 0.9969, 0.9970)}), 2: _path(p1, {5: (0.9985, 0.9985, 0.9969, 0.9970)}),
            3: _path(lambda k: flat(1.0), {3: (1.0, 1.0, 1.0, 1.0)}, t0=t_c)}
    pb = portafoglio(sig, path, list(sig), {}, max_trades=2)
    pr = portafoglio(sig, path, list(sig), {"v1": (30, 0.0)}, max_trades=2)
    ok(pb["n"] == 2 and pr["n"] == 3, "T11 frequenza: Max_Trades=2, base 2 aperture; con V1 (esce a T+30, prima delle 11:00) 3 aperture (slot liberato)")
    pn = portafoglio(sig, path, list(sig), {"be": (0.9, 2)}, max_trades=2)
    ok(pn["n"] == 2, "T11 CONTROESEMPIO: una regola che non chiude nulla (BE 0,9 R) NON cambia la frequenza")
    # T12: bootstrap per giorno
    rng = random.Random(1)
    lo, hi = bootstrap_delta([0.1] * 10 + [-0.1] * 10, list(range(20)), rng, 500)
    ok(lo < 0 < hi, "T12 bootstrap: delta medio 0 con 20 giorni -> l'intervallo contiene 0")
    lo2, hi2 = bootstrap_delta([0.2] * 30, list(range(30)), rng, 500)
    ok(lo2 > 0.19, "T12 bootstrap: delta costante +0,2 -> intervallo stretto sopra 0")
    # T13: validita' del rigioco: un'uscita reale diversa dal rigioco viene contata come discordanza
    s13 = _sig()
    s13.update({"outcome": "OPENED", "exit_reason": "tp"})
    n_, ok_, mism = controlla({1: s13}, {1: _path(p1, {5: (0.9985, 0.9985, 0.9969, 0.9970)})})
    ok(n_ == 1 and ok_ == 0 and len(mism) == 1, "T13 discordanza: rigioco dice SL, reale dice TP -> 0/1 coincidenti (simulazione NON valida)")
    # T14: SENZA EDGE, quante delle regole risultano 'significative' (IC95 del delta che esclude 0) per puro caso?
    frac = []
    for seed in range(6):
        sg, ph = genera_rumore(35, seed)
        ids = list(sg)
        base = esiti(sg, ph, {}, ids)
        rr = random.Random(seed)
        reg = [(n_, r_) for n_, r_ in regole_standard().items() if n_ != "BASE"]
        sig_ = 0
        for n_, r_ in reg:
            v = valuta_regola(n_, r_, sg, ph, ids, base, rr)
            if v["d_lo"] > 0 or v["d_hi"] < 0:
                sig_ += 1
        frac.append(sig_ / float(len(reg)))
    m = sum(frac) / len(frac)
    print("  [..] T14 su passeggiate aleatorie (nessun edge), n=35: regole con IC95 che esclude 0 = %.0f%% in media (nominale 5%%; le regole sono correlate e n e' piccolo)" % (100 * m))
    ok(m <= 0.30, "T14 il tasso di 'falsa scoperta' e' misurato e non esplode (%.0f%% <= 30%%): per questo serve altopiano + replica, non la regola migliore" % (100 * m))
    print("AUTOTEST: %s" % ("TUTTO OK" if not ko else "FALLITI: %d" % len(ko)))
    return not ko


def main():
    a = sys.argv[1:]
    if not autotest():
        return 1
    if "--autotest" in a or not a:
        if not a:
            print("\nNessun dato: oggi il CSV di telemetria NON esiste (copia di banco non ancora scritta).")
            print("Quando c'e': --controlla <cartella> poi --analizza <cartella>.")
        return 0
    if "--controlla" in a or "--analizza" in a:
        cart = a[a.index("--controlla") + 1] if "--controlla" in a else a[a.index("--analizza") + 1]
        sig, path = carica(cart)
        prepara(sig)
        if "--controlla" in a:
            n, ok_, mism = controlla(sig, path)
            print("OPENED %d, rigioco coincidente %d (%.1f%%)" % (n, ok_, 100.0 * ok_ / max(1, n)))
            return 0 if n and ok_ / float(n) >= 0.95 else 1
        return analizza(sig, path)
    return 0


if __name__ == "__main__":
    sys.exit(main())
