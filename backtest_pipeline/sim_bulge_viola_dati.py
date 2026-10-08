#!/usr/bin/env python3
# =====================================================================
#  sim_bulge_viola_dati.py -- SOLA LETTURA. Modulo comune dei due script
#  sim_bulge_viola_portafoglio.py e sim_bulge_viola_simboli.py.
#  Carica i per-trade del Bulge VIOLA dai file del repo e li porta in un
#  formato unico. Non scrive niente, non tocca MT5, non propone taglie.
#
#  FONTI (tutte nel repo):
#   trial   data/statements/ReportHistory_trial_1514806751_2026-10-08.xlsx
#           (19 posizioni Bulge: apertura e chiusura, SL, TP, commissioni;
#            ora FTMO = UTC+3 d'estate [ancora da verificare per l'inverno])
#   bcm     data/statements/trades_auto.csv (piccolo 50503392, BCM = UTC+1 fisso
#           dal 24/09/2026): v520 = magic 772700, antenato = magic 20250001
#   r92bab  backtest_pipeline/risultati_archivio/ROUND_R92BAB_20261001_2201/PERTRADE/
#           (Modello 1, gamba OOS 2026.05.04-06.29): SOLO ORA DI CHIUSURA, niente
#            apertura, niente SL/TP.
#
#  UNITA' DI MISURA: il multiplo di rischio r = netto / R. Il rischio R e' una
#  somma in valuta, quindi i lotti diversi fra istanze/conti non contano:
#   - trial: R esatto per posizione = fattore(EUR per unita' di prezzo, ricavato dal
#     P/L lordo della posizione) x |entrata - SL|
#   - bcm / r92bab: R unico per fonte = mediana della perdita sulle uscite a SL
#     (il rischio e' una % fissa del saldo; l'arrotondamento dei lotti lo sporca di
#     qualche punto: la dispersione e' stampata dall'autotest/dal main).
#  Questo modulo NON ricostruisce nessun segnale: legge posizioni gia' accadute.
# =====================================================================
import csv
import datetime
import os
import re
import statistics as st
import warnings

RADICE = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
FMT = "%Y.%m.%d %H:%M:%S"
TRADES_AUTO = os.path.join(RADICE, "data", "statements", "trades_auto.csv")
TRIAL_XLSX = os.path.join(RADICE, "data", "statements", "ReportHistory_trial_1514806751_2026-10-08.xlsx")
PERTRADE = os.path.join(RADICE, "backtest_pipeline", "risultati_archivio", "ROUND_R92BAB_20261001_2201", "PERTRADE")
R92BAB_FILE = "abtg_trades_ABTG_Bulge_GBPUSD_799401_violaEA.csv"
SPREAD_REF = os.path.join(RADICE, "data", "spread_vivo", "SPREAD_VIVO_2026-09-12_referto.txt")

SYM22 = ("EURUSD,GBPUSD,AUDUSD,NZDUSD,USDCAD,USDCHF,USDJPY,EURGBP,EURNZD,GBPJPY,GBPAUD,GBPCAD,"
         "GBPNZD,AUDJPY,AUDCAD,AUDNZD,NZDJPY,NZDCAD,NZDCHF,CADJPY,CADCHF,CHFJPY").split(",")
SYM15 = "NZDUSD,USDCAD,USDCHF,EURGBP,EURNZD,GBPAUD,GBPNZD,AUDJPY,AUDCAD,AUDNZD,NZDJPY,NZDCAD,NZDCHF,CADJPY,CADCHF".split(",")


def dt(s):
    return datetime.datetime.strptime(s, FMT)


def pip_size(sym):
    return 0.01 if sym.endswith("JPY") else 0.0001


def valute(sym):
    return sym[:3], sym[3:6]


def esposizione(sym, lato):
    """Esposizione FIRMATA per valuta: long EURNZD = +EUR, -NZD. lato +1/-1."""
    b, q = valute(sym)
    return {b: lato, q: -lato}


def ordine_simbolo(sym):
    return SYM22.index(sym) if sym in SYM22 else 99


def nuova(src, sig, sym, lato, apre, chiude, off_utc, netto, R, motivo, segnale, istanza,
          comm=0.0, atr_rel=None, atr_pip=None, swap=0.0):
    return {"src": src, "sig": sig, "sym": sym, "lato": lato, "apre": apre, "chiude": chiude,
            "off_utc": off_utc, "netto": netto, "R": R, "r": (netto / R if R else None),
            "motivo": motivo, "segnale": segnale, "istanza": istanza, "comm": comm, "swap": swap,
            "atr_rel": atr_rel, "atr_pip": atr_pip}


# ---------------------------------------------------------------- BCM (trades_auto.csv)
def carica_bcm(percorso=TRADES_AUTO):
    """Ritorna (v520, antenato): liste di posizioni Bulge (VIOLA e BLU/ARANCIO insieme;
    il filtro sul segnale si fa fuori). R = mediana |netto| delle uscite a SL, per ciascun insieme."""
    righe = list(csv.DictReader(open(percorso, encoding="utf-8"), delimiter=";"))
    out = {"v520": [], "antenato": []}
    for r in righe:
        s = r["strategy"]
        if "V520" in s and r["magic"] == "772700":
            chiave = "v520"
        elif "BULGE_MULTI" in s:
            chiave = "antenato"
        else:
            continue
        seg = "VIOLA" if "VIOLA" in s else ("BLU" if "BLU" in s else ("ARANCIO" if "ARANCIO" in s else "ALTRO"))
        lato = 1 if r["side"] == "buy" else -1
        netto = float(r["profit"]) + float(r["commission"]) + float(r["swap"])
        apre, chiude = dt(r["open_time"]), dt(r["close_time"])
        o, c = float(r["open_price"]), float(r["close_price"])
        motivo = r["close_reason"] if r["close_reason"] in ("sl", "tp") else "altro"
        atr_rel = atr_pip = None
        if motivo == "sl" and o > 0:   # SL = 3 ATR: la distanza entrata-uscita a SL e' 3 ATR (slippage a parte)
            d = abs(o - c) / 3.0
            atr_rel, atr_pip = d / o, d / pip_size(r["symbol"])
        pos_ = nuova(chiave, (chiave, r["symbol"], lato, apre), r["symbol"], lato, apre, chiude,
                     1, netto, None, motivo, seg, chiave, comm=float(r["commission"]), swap=float(r["swap"]),
                     atr_rel=atr_rel, atr_pip=atr_pip)
        # banda M5 dall'ingresso a fine GIORNO d'ingresso (ABTG_TradeExporter): proxy di MFE/MAE, vedi sim_bulge_viola_mfe_limite.py
        pos_.update({"o": o, "c": c, "hi": float(r["session_high"] or 0), "lo": float(r["session_low"] or 0)})
        out[chiave].append(pos_)
    for chiave, lst in out.items():
        sl = [-p["netto"] for p in lst if p["motivo"] == "sl" and p["netto"] < 0]
        R = st.median(sl) if sl else None
        # il saldo (e quindi il rischio in valuta) deriva nei mesi: R = mediana mensile delle perdite a SL
        # (si scartano le uscite a SL con perdita < meta' della mediana globale: stop parziali/anomalie)
        mensile = {}
        for p in lst:
            if p["motivo"] == "sl" and p["netto"] < 0 and -p["netto"] >= 0.5 * R:
                mensile.setdefault(p["apre"].strftime("%Y-%m"), []).append(-p["netto"])
        mensile = {k: st.median(v) for k, v in mensile.items() if len(v) >= 3}
        for p in lst:
            p["R"] = mensile.get(p["apre"].strftime("%Y-%m"), R)
            p["r"] = p["netto"] / p["R"] if p["R"] else None
    return out["v520"], out["antenato"]


# ---------------------------------------------------------------- R92BAB (per-trade, solo chiusura)
def carica_r92bab(percorso=None, solo_viola=True):
    percorso = percorso or os.path.join(PERTRADE, R92BAB_FILE)
    righe = list(csv.DictReader(open(percorso, encoding="utf-8"), delimiter=";"))
    sl = [-float(r["net_profit"]) for r in righe if r["exit_comment"].startswith("sl") and float(r["net_profit"]) < 0]
    R = st.median(sl) if sl else None
    out = []
    for r in righe:
        if solo_viola and r["signal"] != "VIOLA":
            continue
        lato = 1 if r["entry_comment"].endswith("_L") else -1
        mot = "sl" if r["exit_comment"].startswith("sl") else ("tp" if r["exit_comment"].startswith("tp") else "altro")
        net = float(r["net_profit"])
        out.append(nuova("r92bab", ("r92bab", r["position_id"], r["symbol"]), r["symbol"], lato, None, dt(r["close_time"]),
                         1, net, R, mot, r["signal"], "A"))
    return out


# ---------------------------------------------------------------- TRIAL (xlsx FTMO)
def carica_trial(percorso=TRIAL_XLSX, off_utc=3):
    try:
        import openpyxl
    except ImportError:
        return []
    warnings.filterwarnings("ignore")
    ws = openpyxl.load_workbook(percorso, read_only=True).active
    righe = list(ws.iter_rows(values_only=True))
    sezione, pos, commenti, tp_ordine = None, [], {}, {}
    for r in righe:
        a = r[0]
        if a in ("Posizioni", "Ordini", "Affari", "Risultati"):
            sezione = a
            continue
        if not (isinstance(a, str) and re.match(r"20\d\d\.\d\d\.\d\d ", a)):
            continue
        if sezione == "Posizioni":
            pos.append(r)
        elif sezione == "Ordini":
            commenti[r[1]] = r[11]
            tp_ordine[r[1]] = r[7]
    out = []
    for r in pos:
        com = commenti.get(r[1]) or ""
        if "BULGE" not in com.upper():
            continue
        sym, tipo = r[2], r[3]
        lato = 1 if tipo == "buy" else -1
        o, sl, c = float(r[5]), float(r[6]), float(r[9])
        comm, swap, prof = float(r[10]), float(r[11]), float(r[12])
        netto = prof + comm + swap
        mossa = lato * (c - o)
        R = None
        if abs(mossa) > 1e-12:
            R = abs(prof / mossa) * abs(o - sl)          # EUR per unita' di prezzo x distanza dello SL
        dist = abs(o - sl)
        motivo = "sl" if (prof < 0 and abs(c - sl) <= 0.25 * dist) else ("tp" if prof > 0 else "altro")
        seg = "VIOLA" if "VIOLA" in com.upper() else "ALTRO"
        ist = "V520_FT" if "V520_FT" in com else ("BULGE VIOLA" if "BULGE VIOLA" in com else "BULGE_VIOLA")
        apre, chiude = dt(r[0]), dt(r[8])
        p = nuova("trial", ("trial", sym, lato, apre), sym, lato, apre, chiude, off_utc, netto, R, motivo, seg, ist,
                  comm=comm, swap=swap, atr_rel=dist / 3.0 / o, atr_pip=dist / 3.0 / pip_size(sym))
        tp0 = tp_ordine.get(r[1])
        p.update({"o": o, "c": c, "sl": sl, "tp_ini": (float(tp0) if isinstance(tp0, (int, float)) else None)})
        out.append(p)
    return out


# ---------------------------------------------------------------- spread vivo (solo 3 maggiori forex)
def carica_spread(percorso=SPREAD_REF):
    """Mediana (sulle ore) delle mediane orarie di spread, in pip. Solo i simboli presenti nel referto."""
    if not os.path.exists(percorso):
        return {}
    sym, vals, out = None, [], {}
    for riga in open(percorso, encoding="utf-8", errors="replace"):
        m = re.match(r"\s+([A-Z0-9]{5,8})\s+\(vivo", riga)
        if m:
            if sym and vals:
                out[sym] = st.median(vals)
            sym, vals = m.group(1), []
            continue
        m = re.match(r"\s+(\d\d) \|\s*(\d+) \|\s*(\d+) \|\s*([\d.]+) \|", riga)
        if m and sym and int(m.group(3)) >= 3:
            vals.append(float(m.group(4)))
    if sym and vals:
        out[sym] = st.median(vals)
    return {k: v for k, v in out.items() if len(k) == 6 and k.isalpha()}


# ---------------------------------------------------------------- statistiche
def pf(vals):
    g = sum(v for v in vals if v > 0)
    p = -sum(v for v in vals if v <= 0)
    return (g / p) if p > 0 else float("inf") if g > 0 else float("nan")


def riga_stat(vals):
    n = len(vals)
    w = [v for v in vals if v > 0]
    l = [v for v in vals if v <= 0]
    return {"n": n, "vinte": len(w), "wr": (100.0 * len(w) / n if n else float("nan")), "somma": sum(vals),
            "media": (sum(vals) / n if n else float("nan")), "pf": pf(vals),
            "vm": (sum(w) / len(w) if w else 0.0), "pm": (sum(l) / len(l) if l else 0.0)}
