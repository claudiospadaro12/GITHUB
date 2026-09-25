#!/usr/bin/env python3
# =====================================================================
#  r245_dd_vergine.py -- LA CAUSA DEL DD DI R245 NELLA FINESTRA VERGINE.
#  SOLA LETTURA, zero tempo macchina. Referto:
#  report/R245_IL_DD_DELLA_FINESTRA_VERGINE_2026-09-25.md
# ---------------------------------------------------------------------
#  LA DOMANDA: R248 (REFERTO_R248_2026-09-25) ha letto per la cella R245
#  (ABTG_Nasdaq_Apertura_US su U30USD M5, EmaSlow 200, TP1_R 0,50) un DD
#  del saldo chiuso 8,38% nella finestra vergine 2026.07.01 -> 09.18,
#  sopra il p95 della promessa (7,31%) e della banda solo-estate (7,44%).
#  La causa e' [NON MISURATA] (classe 790). Qui si SCOMPONE quel DD e si
#  confronta ogni sua componente con la stessa grandezza della sorgente
#  (R247b, per-trade 765273, feriali d'estate USA), con un bootstrap a
#  blocchi dallo STESSO generatore e dallo STESSO seme di r248 (248), cosi'
#  le finestre simulate sono le stesse che hanno fatto la banda congelata.
#
#  COSA SI LEGGE DAL PER-TRADE (e cosa NO):
#   - c'e': ora di chiusura, deal_type del deal d'uscita (1 = SELL = chiude
#     un LONG; 0 = BUY = chiude uno SHORT), volume, prezzo d'USCITA, netto.
#   - NON c'e': ora e prezzo d'ingresso, SL. Quindi:
#       * DURATA: solo un MAGGIORANTE, chiusura - 14:45 server (il range e'
#         14:30-14:45, InpRangeMinutes=15: nessun ingresso prima). [DERIVATO]
#       * TIPO D'USCITA: DEDOTTO, non letto (vedi tipo_uscita()).
#       * STOP: solo un PROXY dal volume (vedi proxy_stop()).
#
#  TIPO D'USCITA DEDOTTO (dalla logica dell'EA a HEAD, cella R248a):
#   ORA    chiusura alle 17:30 server (InpCloseHour/Min = 17:30, CloseAtEnd)
#   TP     rendimento >= +1,20% (TP = 3 x TP1_R = 1,5R, InpRunnerTP_R=0;
#          a 10000 il lotto arrotondato sotto lo porta a ~1,3%)
#   SL     rendimento <= -0,60% (stop iniziale = estremo opposto del range;
#          a 10000 l'arrotondamento del lotto lo porta fino a ~-0,67%)
#   TRAIL  rendimento >= -0,02% (il trailing PREVBAR M5 sposta lo stop
#          SOLO oltre il prezzo d'ingresso, r.2256-2260: esce in pari o in
#          utile; -0,02 = tolleranza sul netto)
#   ALTRO  tutto il resto (atteso: zero; l'autotest lo controlla)
#   Le soglie stanno nei VUOTI misurati della distribuzione (autotest T4).
#
#  USO
#    python3 backtest_pipeline/r245_dd_vergine.py            # la lettura
#    python3 backtest_pipeline/r245_dd_vergine.py --autotest # esce 1 se FAIL
# =====================================================================
from __future__ import annotations

import csv
import datetime as dt
import glob
import json
import math
import os
import random
import sys

QUI = os.path.dirname(os.path.abspath(__file__))
RADICE = os.path.dirname(QUI)
sys.path.insert(0, QUI)
import r248_bande_vergine as B  # noqa: E402  (stesse convenzioni, stesso estate_usa)

PT_VERGINE = os.path.join(QUI, "risultati_archivio", "R248", "PERTRADE",
                          "abtg_trades_ABTG_Nasdaq_Apertura_US_U30USD_765281.csv")
PT_GEMELLO = os.path.join(QUI, "risultati_archivio", "R248", "PERTRADE",
                          "abtg_trades_ABTG_Nasdaq_Apertura_US_U30USD_765282.csv")
PT_SORGENTE = B.CELLE["R245"]["pertrade"]            # R247b 765273, deposito 10000
DEP_VERGINE = 100000.0
DEP_SORGENTE = B.CELLE["R245"]["deposito"]           # 10000
SORG_DA, SORG_A = B.CELLE["R245"]["da"], B.CELLE["R245"]["a"]
CAL_DA, CAL_A = dt.date(2025, 7, 1), dt.date(2025, 9, 18)   # stessa finestra, un anno prima
# SECONDO NULLO (contro-esempio del primo): la tranche IS di R247a, stessa
# cella, stesso banco (deposito 10000), 2024.09.26 -> 2025.06.30 esclusiva.
# Lettura R247: 154 posizioni, somma 1180,94 (lettura.txt r.5).
PT_R247A = os.path.join(QUI, "risultati_archivio", "R247", "PERTRADE",
                        "abtg_trades_ABTG_Nasdaq_Apertura_US_U30USD_765271.csv")
R247A_DA, R247A_A = dt.date(2024, 9, 26), dt.date(2025, 6, 27)

SEME = B.SEME          # 248: stesso generatore e stesso seme della banda congelata
REPLICHE = B.REPLICHE  # 20000
BLOCCO = B.BLOCCO      # 5 feriali

INGRESSO_MIN = dt.time(14, 45)    # fine del range 14:30 + 15 min (ora server)
SOGLIA_TP, SOGLIA_SL, SOGLIA_TRAIL = 1.20, -0.60, -0.02

# Ancora del deposito (CSV d'archivio, NON il per-trade): stessa corsa
# 2025.07.01 -> 2026.06.30 a 10000 (R247b _OOS) e a 100000 (R248a _IS).
EQDD_10K = 6.8640      # risultati_archivio/R247/ROUND_R247b/..._OOS_R247b.csv
EQDD_100K = 7.0104     # risultati_archivio/R248/ROUND_R248a/..._IS_R248a.csv

# Numeri scritti da ALTRI, contro cui si controlla (autotest)
RIF_DD_VERGINE = 8.38          # REFERTO_R248 par. 2
RIF_NETTO_VERGINE = -5686.90   # REFERTO_R248 par. 2 (ricontato dal coordinatore)
RIF_P95_ESTATE = 7.44          # R248a par. 6 / REFERTO_R248 par. 3
RIF_SORG_ESTATE_N = 120        # R248a par. 7: "PF 0,94 su 120 posizioni"
RIF_SORG_ESTATE_PF = 0.94
RIF_CAL = (39, 3.11, 1.04)     # R248a par. 7: stessa finestra un anno prima: n, DD, PF


# ---------------------------------------------------------------------
#  lettura
# ---------------------------------------------------------------------
def leggi(percorso, deposito):
    """Una riga = una posizione (le celle R245 hanno ClosePct=0: 1 deal per
    posizione; controllato). ret in % del saldo prima della chiusura."""
    out = []
    saldo = deposito
    visti = set()
    with open(percorso, newline="", encoding="ascii", errors="replace") as fh:
        for r in csv.DictReader(fh, delimiter=";"):
            pid = r["position_id"]
            if pid in visti:
                raise SystemExit("piu' deal per posizione in " + percorso + ": l'unita' non regge")
            visti.add(pid)
            t = dt.datetime.strptime(r["close_time"], "%Y.%m.%d %H:%M:%S")
            net = float(r["net_profit"])
            out.append({"t": t, "giorno": t.date(), "lato": "L" if r["deal_type"] == "1" else "S",
                        "vol": float(r["volume"]), "px": float(r["price"]), "net": net,
                        "s0": saldo, "ret": net / saldo * 100.0})
            saldo += net
    out.sort(key=lambda x: x["t"])
    for p in out:
        p["tipo"] = tipo_uscita(p)
    return out


def tipo_uscita(p):
    if p["t"].hour == 17 and p["t"].minute == 30:
        return "ORA"
    if p["ret"] >= SOGLIA_TP:
        return "TP"
    if p["ret"] <= SOGLIA_SL:
        return "SL"
    if p["ret"] >= SOGLIA_TRAIL:
        return "TRAIL"
    return "ALTRO"


def durata_max_min(p):
    ing = dt.datetime.combine(p["giorno"], INGRESSO_MIN)
    return (p["t"] - ing).total_seconds() / 60.0


def proxy_stop(p, passo=0.1):
    """PROXY dello stop in % del prezzo, DIVISO per EURUSD (valore del punto
    U30USD = 1 USD/punto/lotto -> 0,857-0,863 EUR misurato in
    EMA200_I_DUE_REQUISITI_2026-09-12 punto 4; commissione e swap 0).
    Lotto = floor(rischio / (stop x valore punto)) a passo 0,1:
      stop_punti in [0,01 x s0 x fx / (vol + passo) ; 0,01 x s0 x fx / vol].
    Si restituisce (lo, hi) di stop% / fx. Il prezzo e' quello d'USCITA
    (entro ~1-2% dall'ingresso: errore trascurabile sulla % di prezzo)."""
    r = 0.01 * p["s0"]
    return (r / ((p["vol"] + passo) * p["px"]) * 100.0, r / (p["vol"] * p["px"]) * 100.0)


def lotto_pari(pos, h=0.05):
    """BANCO PARI [DERIVATO]: toglie l'arrotondamento del lotto (MathFloor a
    passo 0,1, EA r.2069) posizione per posizione. Il lotto esatto sta in
    [vol ; vol+0,1): stima centrale vol+h, h=0,05 (parte frazionaria uniforme).
    Vale per OGNI uscita (il rendimento e' proporzionale al lotto), non solo
    per gli SL. Tarata sugli SL (autotest T11): stesso R a banco pari."""
    return [dict(p, ret=p["ret"] * (p["vol"] + h) / p["vol"]) for p in pos]


# ---------------------------------------------------------------------
#  statistiche di una sequenza di posizioni
# ---------------------------------------------------------------------
def dd_saldo(rets):
    s = pk = 1.0
    dd = 0.0
    for r in rets:
        s *= 1.0 + r / 100.0
        pk = max(pk, s)
        dd = max(dd, (pk - s) / pk)
    return dd * 100.0


def tratto_peggiore(pos):
    """(indice del picco, indice del minimo, DD) sul saldo chiuso. Picco = -1
    se il DD parte dal deposito."""
    s = pk = 1.0
    ipk = -1
    best = (-1, -1, 0.0)
    for i, p in enumerate(pos):
        s *= 1.0 + p["ret"] / 100.0
        if s > pk:
            pk, ipk = s, i
        d = (pk - s) / pk
        if d > best[2]:
            best = (ipk, i, d)
    return best[0], best[1], best[2] * 100.0


def media(v):
    return sum(v) / len(v) if v else float("nan")


def serie_max(pos, cond):
    m = c = 0
    for p in pos:
        c = c + 1 if cond(p) else 0
        m = max(m, c)
    return m


STAT = [
    # chiave, etichetta, puo' SPIEGARE il DD se fuori norma nel verso del danno?
    ("n", "posizioni"),
    ("wr", "win rate (ret>0)"),
    ("perd_media", "perdita media % (ret<0)"),
    ("guad_medio", "guadagno medio % (ret>0)"),
    ("attesa", "rendimento medio % per posizione"),
    ("serie_perd", "serie perdente max (posizioni)"),
    ("serie_sl", "serie di SL consecutivi max"),
    ("quota_long", "quota LONG"),
    ("quota_sl", "quota uscite SL"),
    ("quota_ora", "quota uscite a ORA fissa (17:30)"),
    ("quota_tp", "quota uscite TP"),
    ("quota_trail", "quota uscite TRAIL"),
    ("media_sl", "perdita media delle uscite SL %"),
    ("media_ora", "rendimento medio delle uscite a ORA %"),
    ("media_trail", "rendimento medio delle uscite TRAIL %"),
    ("dd", "DD saldo chiuso %"),
]


def statistiche(pos):
    n = len(pos)
    if n == 0:
        return {k: float("nan") for k, _ in STAT}
    w = [p["ret"] for p in pos if p["ret"] > 0]
    l = [p["ret"] for p in pos if p["ret"] < 0]
    q = lambda t: sum(1 for p in pos if p["tipo"] == t) / float(n)  # noqa: E731
    mt = lambda t: media([p["ret"] for p in pos if p["tipo"] == t])  # noqa: E731
    return {
        "n": float(n), "wr": len(w) / float(n), "perd_media": media(l), "guad_medio": media(w),
        "attesa": media([p["ret"] for p in pos]),
        "serie_perd": float(serie_max(pos, lambda p: p["ret"] < 0)),
        "serie_sl": float(serie_max(pos, lambda p: p["tipo"] == "SL")),
        "quota_long": sum(1 for p in pos if p["lato"] == "L") / float(n),
        "quota_sl": q("SL"), "quota_ora": q("ORA"), "quota_tp": q("TP"), "quota_trail": q("TRAIL"),
        "media_sl": mt("SL"), "media_ora": mt("ORA"), "media_trail": mt("TRAIL"),
        "dd": dd_saldo([p["ret"] for p in pos]),
    }


# ---------------------------------------------------------------------
#  il nullo: bootstrap a blocchi dei feriali d'estate della sorgente,
#  STESSO generatore di r248_bande_vergine.bootstrap (stessa sequenza di
#  chiamate a randrange): con seme 248 le finestre sono quelle della banda.
# ---------------------------------------------------------------------
def feriali_estate_sorgente(sorg):
    per_giorno = {p["giorno"]: p for p in sorg}
    if len(per_giorno) != len(sorg):
        raise SystemExit("due posizioni lo stesso giorno nella sorgente")
    fer = [g for g in B.feriali(SORG_DA, SORG_A) if B.estate_usa(g)]
    return [per_giorno.get(g) for g in fer]


def feriali_estate_storia(sorg, prima):
    """Feriali d'estate USA di R247a (2024.09.26 -> 2025.06.27) + R247b
    (2025.07.01 -> 2026.06.29): tutta la storia di questa cella a questo banco.
    Il 2025.06.30 non sta in nessuna delle due tranche (fine esclusiva)."""
    per_giorno = {p["giorno"]: p for p in prima}
    if len(per_giorno) != len(prima):
        raise SystemExit("due posizioni lo stesso giorno in R247a")
    fer = [g for g in B.feriali(R247A_DA, R247A_A) if B.estate_usa(g)]
    return [per_giorno.get(g) for g in fer] + feriali_estate_sorgente(sorg)


def nullo(serie, lunghezza, repliche=REPLICHE, seme=SEME, blocco=BLOCCO, trasforma=None):
    rnd = random.Random(seme)
    L = len(serie)
    nb = int(math.ceil(lunghezza / float(blocco)))
    out = []
    for _ in range(repliche):
        perc = []
        for _b in range(nb):
            s = rnd.randrange(L)
            for k in range(blocco):
                perc.append(serie[(s + k) % L])
        pos = [p for p in perc[:lunghezza] if p is not None]
        if trasforma:
            pos = trasforma(pos)
        out.append(statistiche(pos))
    return out


def posizione_nel_nullo(boot, chiave, oss):
    v = [b[chiave] for b in boot if not math.isnan(b[chiave])]
    if not v or math.isnan(oss):
        return float("nan"), float("nan"), 0
    le = sum(1 for x in v if x <= oss) / float(len(v))
    ge = sum(1 for x in v if x >= oss) / float(len(v))
    return le, ge, len(v)


def giudizio(le, ge):
    if math.isnan(le):
        return "[NON MISURABILE]"
    if le < 0.025:
        return "FUORI (basso)"
    if ge < 0.025:
        return "FUORI (alto)"
    if le < 0.05 or ge < 0.05:
        return "al bordo"
    return "nella norma"


# ---------------------------------------------------------------------
#  EURUSD dalle foto di mercato del repo (data/snapshots, Yahoo EURUSD=X)
# ---------------------------------------------------------------------
def eurusd_foto():
    out = {}
    for f in sorted(glob.glob(os.path.join(RADICE, "data", "snapshots", "*.json"))):
        try:
            d = json.load(open(f))
            for gr in d["instruments"].values():
                for x in gr:
                    if x.get("ticker") == "EURUSD=X" and x.get("last_close"):
                        out[dt.date.fromisoformat(d["date"])] = float(x["last_close"])
        except Exception:
            continue
    return out


def fx_vicino(fx, giorno, tolleranza=3):
    best = None
    for g, v in fx.items():
        dd_ = abs((g - giorno).days)
        if dd_ <= tolleranza and (best is None or dd_ < best[0]):
            best = (dd_, v)
    return best[1] if best else None


# ---------------------------------------------------------------------
#  il feed del tester contro il feed VIVO BCM (sola lettura, zero tempo
#  macchina): deal d'uscita del backtest con la STESSA ora al secondo di una
#  chiusura viva U30USD nei rendiconti pubblicati dal VPS.
# ---------------------------------------------------------------------
STATEMENTS = [os.path.join(RADICE, "data", "statements", f) for f in ("trades_auto.csv", "trades_100k.csv")]


def chiusure_vive():
    out = {}
    for f in STATEMENTS:
        if not os.path.exists(f):
            continue
        with open(f, encoding="utf-8", errors="replace") as fh:
            for r in csv.DictReader(fh, delimiter=";"):
                if r.get("symbol") != "U30USD":
                    continue
                try:
                    t = dt.datetime.strptime(r["close_time"], "%Y.%m.%d %H:%M:%S")
                    out.setdefault(t, set()).add((float(r["close_price"]), r["magic"], r["close_reason"],
                                                  os.path.basename(f)))
                except (ValueError, KeyError):
                    continue
    return out


def leggi_deal_semplice(percorso):
    """Deal d'uscita (anche piu' d'uno per posizione): solo ora, giorno, prezzo."""
    out = []
    with open(percorso, newline="", encoding="ascii", errors="replace") as fh:
        for r in csv.DictReader(fh, delimiter=";"):
            t = dt.datetime.strptime(r["close_time"], "%Y.%m.%d %H:%M:%S")
            out.append({"t": t, "giorno": t.date(), "px": float(r["price"])})
    return out


def confronto_feed(pos):
    vive = chiusure_vive()
    righe = []
    for p in pos:
        if p["t"] in vive:
            for prezzo, magic, motivo, f in sorted(vive[p["t"]]):
                righe.append((p, prezzo, magic, motivo, f))
    return righe


# ---------------------------------------------------------------------
#  calendario news del repo
# ---------------------------------------------------------------------
CAL_FILE = {
    "abtg_news.csv (data/, attivo)": os.path.join(RADICE, "data", "abtg_news.csv"),
    "mql5/Files/abtg_news.csv (ora ITALIANA, dedotta: FOMC 20:00)": os.path.join(RADICE, "mql5", "Files", "abtg_news.csv"),
    "mql5/Files/abtg_news_live_2026-09-04.csv (UTC)": os.path.join(RADICE, "mql5", "Files", "abtg_news_live_2026-09-04.csv"),
    "mql5/Files/abtg_news_2021_2025_UTC.csv": os.path.join(RADICE, "mql5", "Files", "abtg_news_2021_2025_UTC.csv"),
}


def eventi_usd(da, a):
    out = []
    for nome, f in CAL_FILE.items():
        if not os.path.exists(f):
            continue
        with open(f, encoding="utf-8", errors="replace") as fh:
            for riga in fh:
                c = riga.strip().split(";")
                if len(c) < 4 or c[2] != "USD":
                    continue
                try:
                    t = dt.datetime.strptime(c[0], "%Y.%m.%d %H:%M")
                except ValueError:
                    continue
                if da <= t.date() <= a:
                    out.append((t, c[3], nome))
    return sorted(set(out))


def copertura_mensile(anno_mesi):
    f = CAL_FILE["mql5/Files/abtg_news_2021_2025_UTC.csv"]
    cnt = {m: 0 for m in anno_mesi}
    with open(f, encoding="utf-8", errors="replace") as fh:
        for riga in fh:
            c = riga.split(";")
            if len(c) >= 3 and c[2] == "USD" and c[0][:7] in cnt:
                cnt[c[0][:7]] += 1
    return cnt


# ---------------------------------------------------------------------
#  la lettura
# ---------------------------------------------------------------------
def fmt(x, k):
    if isinstance(x, float) and math.isnan(x):
        return "-"
    if k.startswith("quota") or k == "wr":
        return "%.1f%%" % (100 * x)
    if k in ("n", "serie_perd", "serie_sl"):
        return "%d" % x
    return "%+.3f" % x if k not in ("dd",) else "%.2f" % x


def lettura():
    V = leggi(PT_VERGINE, DEP_VERGINE)
    S = leggi(PT_SORGENTE, DEP_SORGENTE)
    Se = [p for p in S if B.estate_usa(p["giorno"])]
    Si = [p for p in S if not B.estate_usa(p["giorno"])]
    Sc = [p for p in S if CAL_DA <= p["giorno"] <= CAL_A]
    Lv = len(B.feriali(B.VERGINE_DA, B.VERGINE_A))

    print("=" * 78)
    print("R245 -- IL DD DELLA FINESTRA VERGINE (sola lettura, seme %d, %d repliche, blocchi %d)"
          % (SEME, REPLICHE, BLOCCO))
    print("=" * 78)

    # ---- 1. le posizioni
    ipk, imin, dd = tratto_peggiore(V)
    print("\n[1] LE 39 POSIZIONI (DD saldo chiuso progressivo; * = dentro il tratto peggiore)")
    print("  data        lato uscita    tipo   ret%     durata<=min  DD%")
    s = pk = 1.0
    for i, p in enumerate(V):
        s *= 1 + p["ret"] / 100
        pk = max(pk, s)
        dentro = "*" if ipk < i <= imin else " "
        print("  %s %s  %s  %s %-5s %+7.3f  %6.0f      %5.2f"
              % (dentro, p["giorno"], p["lato"], p["t"].strftime("%H:%M:%S"), p["tipo"], p["ret"],
                 durata_max_min(p), (pk - s) / pk * 100))
    tr = V[ipk + 1: imin + 1]
    g0 = V[ipk]["giorno"] if ipk >= 0 else B.VERGINE_DA
    g1 = V[imin]["giorno"]
    fer = len([g for g in B.feriali(g0, g1) if g > g0])
    print("\n  TRATTO PEGGIORE: picco %s -> minimo %s = %d giorni di calendario, %d feriali,"
          " %d posizioni, DD %.2f%%" % (g0, g1, (g1 - g0).days, fer, len(tr), dd))
    somma = {}
    for p in tr:
        somma.setdefault(p["tipo"], []).append(p["ret"])
    for t in ("SL", "ORA", "TRAIL", "TP", "ALTRO"):
        if t in somma:
            print("    %-5s %2d posizioni, somma %+6.2f%%, media %+.3f%%"
                  % (t, len(somma[t]), sum(somma[t]), media(somma[t])))
    lati = sum(1 for p in tr if p["lato"] == "L")
    print("    lati: LONG %d, SHORT %d | serie perdente max %d | SL consecutivi max %d"
          % (lati, len(tr) - lati, serie_max(tr, lambda p: p["ret"] < 0),
             serie_max(tr, lambda p: p["tipo"] == "SL")))
    perd = sorted([p["ret"] for p in tr if p["ret"] < 0])
    tot_perd = -sum(perd)
    print("    FORMA (criterio scritto QUI, dopo i numeri -- dichiarato): perdite lorde %.2f%%;"
          " le 2 peggiori ne fanno il %.0f%%; la serie di SL consecutivi piu' lunga %d."
          % (tot_perd, 100 * -sum(perd[:2]) / tot_perd, serie_max(tr, lambda p: p["tipo"] == "SL")))
    print("    guadagni lordi nel tratto %+.2f%% su %d vincenti (media %+.3f%%)"
          % (sum(p["ret"] for p in tr if p["ret"] > 0), sum(1 for p in tr if p["ret"] > 0),
             media([p["ret"] for p in tr if p["ret"] > 0])))

    # ---- 2. confronto
    print("\n[2] CONFRONTO -- nullo = bootstrap a blocchi dei %d feriali d'ESTATE della sorgente"
          " R247b (%d posizioni), finestre da %d feriali" % (len(feriali_estate_sorgente(S)), len(Se), Lv))
    boot = nullo(feriali_estate_sorgente(S), Lv)
    A = leggi(PT_R247A, DEP_SORGENTE)
    Ae = [p for p in A if B.estate_usa(p["giorno"])]
    boot2 = nullo(feriali_estate_storia(S, A), Lv)
    sv, se, sc, si = statistiche(V), statistiche(Se), statistiche(Sc), statistiche(Si)
    sa = statistiche(Ae)
    print("  secondo nullo = feriali d'estate di R247a + R247b (%d feriali, %d posizioni: TUTTA la"
          " storia della cella a questo banco, compreso l'aprile 2025)"
          % (len(feriali_estate_storia(S, A)), len(Ae) + len(Se)))
    print("  %-40s %9s %9s %9s %9s %9s | %-16s %-16s %-16s" % (
        "statistica", "VERGINE", "SORG.EST", "CAL-2025", "R247a-EST", "SORG.INV",
        "vergine/nullo1", "cal-2025/nullo1", "vergine/nullo2"))
    esiti = {}
    for k, et in STAT:
        le, ge, nv = posizione_nel_nullo(boot, k, sv[k])
        le2, ge2, _ = posizione_nel_nullo(boot, k, sc[k])
        le3, ge3, _ = posizione_nel_nullo(boot2, k, sv[k])
        esiti[k] = (giudizio(le, ge), le, ge, giudizio(le3, ge3), le3, ge3)
        print("  %-40s %9s %9s %9s %9s %9s | %-16s %-16s %-16s (n1: P<=%.4f P>=%.4f | n2: P<=%.4f P>=%.4f)"
              % (et, fmt(sv[k], k), fmt(se[k], k), fmt(sc[k], k), fmt(sa[k], k), fmt(si[k], k),
                 giudizio(le, ge), giudizio(le2, ge2), giudizio(le3, ge3), le, ge, le3, ge3))
    print("  uscite a ORA, valori: sorgente d'estate %s | R247a d'estate %s | vergine %s"
          % (sorted(round(p["ret"], 2) for p in Se if p["tipo"] == "ORA"),
             sorted(round(p["ret"], 2) for p in Ae if p["tipo"] == "ORA"),
             sorted(round(p["ret"], 2) for p in V if p["tipo"] == "ORA")))
    ddv = [b["dd"] for b in boot]
    print("  controllo: p95 del DD nel nullo d'estate %.2f%% (R248: %.2f%%); P(DD >= %.2f%%) = %.1f%%"
          % (B.quantile(ddv, 0.95), RIF_P95_ESTATE, sv["dd"],
             100 * sum(1 for x in ddv if x >= sv["dd"]) / len(ddv)))
    dd2 = [b["dd"] for b in boot2]
    print("  nullo 2 (storia intera d'estate): DD p95 %.2f%% | p99 %.2f%% | P(DD >= %.2f%%) = %.1f%%"
          % (B.quantile(dd2, 0.95), B.quantile(dd2, 0.99), sv["dd"],
             100 * sum(1 for x in dd2 if x >= sv["dd"]) / len(dd2)))

    # ---- 2b. il deposito (banco): lotto a passo 0,1 su 10000 vs 100000
    k_dep = EQDD_100K / EQDD_10K
    print("\n[2b] BANCO -- il deposito. Stessa corsa 2025.07.01-2026.06.30: Equity DD %.4f%% a 10000,"
          " %.4f%% a 100000 -> fattore %.3f" % (EQDD_10K, EQDD_100K, k_dep))
    boot_k = nullo(feriali_estate_sorgente(S), Lv, repliche=REPLICHE,
                   trasforma=lambda pos: [dict(p, ret=p["ret"] * k_dep) for p in pos])
    ddk = [b["dd"] for b in boot_k]
    print("  nullo d'estate con ogni rendimento x%.3f: p95 %.2f%% | P(DD >= %.2f%%) = %.1f%%"
          % (k_dep, B.quantile(ddk, 0.95), sv["dd"], 100 * sum(1 for x in ddk if x >= sv["dd"]) / len(ddk)))
    rsl = sv["media_sl"] / se["media_sl"]
    print("  perdita media SL: vergine %.3f%% / sorgente estate %.3f%% = %.3f (lotto piu' fine a 100000)"
          % (sv["media_sl"], se["media_sl"], rsl))

    # ---- 2c. attribuzione controfattuale [DERIVATO]
    print("\n[2c] CONTROFATTUALI sul percorso vergine [DERIVATO, non una misura della causa]:"
          " si riporta UNA componente alla media della sorgente d'estate e si ricalcola il DD")

    def cf(nome, f):
        rets = [f(p) for p in V]
        print("  %-68s DD %.2f%%  (p95 7,31 / 7,44)" % (nome, dd_saldo(rets)))

    cf("nessuna modifica", lambda p: p["ret"])
    cf("SL scalati x%.3f (perdita SL media della sorgente: effetto deposito)" % (1 / rsl),
       lambda p: p["ret"] / rsl if p["tipo"] == "SL" else p["ret"])
    cf("uscite a ORA alla media della sorgente (%+.3f%%)" % se["media_ora"],
       lambda p: se["media_ora"] if p["tipo"] == "ORA" else p["ret"])
    kt = se["media_trail"] / sv["media_trail"]
    cf("uscite TRAIL scalate x%.3f (media TRAIL della sorgente)" % kt,
       lambda p: p["ret"] * kt if p["tipo"] == "TRAIL" else p["ret"])
    cf("ORA alla media sorgente + TRAIL scalate",
       lambda p: se["media_ora"] if p["tipo"] == "ORA" else (p["ret"] * kt if p["tipo"] == "TRAIL" else p["ret"]))

    # ---- 2e. BANCO PARI su TUTTE le uscite [DERIVATO] (correzione del cancello)
    print("\n[2e] BANCO PARI -- lotto esatto stimato (vol+0,05) su vergine E nulli: l'arrotondamento"
          " tocca OGNI uscita, non solo gli SL")
    Vp = lotto_pari(V)
    svp = statistiche(Vp)
    for nome_n, ser in (("nullo 1", feriali_estate_sorgente(S)), ("nullo 2", feriali_estate_storia(S, A))):
        bp = nullo(ser, Lv, trasforma=lotto_pari)
        print("  %s: DD p95 %.2f%%" % (nome_n, B.quantile([b["dd"] for b in bp], 0.95)))
        for k in ("dd", "media_sl", "media_ora", "media_trail", "attesa"):
            le, ge, _ = posizione_nel_nullo(bp, k, svp[k])
            print("    %-40s vergine %s -> %s (P<=%.4f P>=%.4f)" % (dict(STAT)[k], fmt(svp[k], k), giudizio(le, ge), le, ge))
    sep = statistiche(lotto_pari(Se))
    print("  medie a banco pari, sorgente d'estate: SL %+.3f ORA %+.3f TRAIL %+.3f | vergine: SL %+.3f ORA %+.3f TRAIL %+.3f"
          % (sep["media_sl"], sep["media_ora"], sep["media_trail"], svp["media_sl"], svp["media_ora"], svp["media_trail"]))
    ktp = sep["media_trail"] / svp["media_trail"]
    for nome, f in (("ORA alla media della sorgente a banco pari", lambda p: sep["media_ora"] if p["tipo"] == "ORA" else p["ret"]),
                    ("TRAIL scalate x%.3f" % ktp, lambda p: p["ret"] * ktp if p["tipo"] == "TRAIL" else p["ret"]),
                    ("ORA + TRAIL", lambda p: sep["media_ora"] if p["tipo"] == "ORA" else (p["ret"] * ktp if p["tipo"] == "TRAIL" else p["ret"]))):
        print("  controfattuale a banco pari (scelto DOPO i numeri) %-44s DD %.2f%% (vergine a banco pari %.2f%%)"
              % (nome, dd_saldo([f(p) for p in Vp]), svp["dd"]))

    # ---- 2d. il feed
    print("\n[2d] FEED DEL TESTER contro FEED VIVO BCM (rendiconti del VPS, stessa ora al secondo)")
    rf = confronto_feed(V)
    for p, prezzo, magic, motivo, f in rf:
        print("  %s %-5s tester %.2f | vivo %.2f (magic %s, %s, %s) -> %s"
              % (p["t"], p["tipo"], p["px"], prezzo, magic, motivo, f,
                 "IDENTICO" if abs(prezzo - p["px"]) < 0.005 else "DIVERSO di %.2f" % (prezzo - p["px"])))
    ug = len(set(x[0]["t"] for x in rf if abs(x[1] - x[0]["px"]) < 0.005))
    print("  uscite R245 verificate sul vivo: %d su %d (ORA: %d su %d); le altre [NON VERIFICATE]:"
          " nessuna chiusura viva alla stessa ora"
          % (ug, len(V), len(set(x[0]["t"] for x in rf if x[0]["tipo"] == "ORA")),
             sum(1 for p in V if p["tipo"] == "ORA")))

    pt_b = os.path.join(QUI, "risultati_archivio", "R248", "PERTRADE",
                        "abtg_trades_ABTG_Dow_Apertura_US_U30USD_765283.csv")
    if os.path.exists(pt_b):
        rb = confronto_feed(leggi_deal_semplice(pt_b))
        print("  stesso controllo sul per-trade vergine di 770202 (R248b 765283, stesso tester e stesso"
              " simbolo): %d confronti, %d identici; date %s"
              % (len(rb), sum(1 for x in rb if abs(x[1] - x[0]["px"]) < 0.005),
                 sorted(set(str(x[0]["giorno"]) for x in rb))))

    # ---- 3. eventi macro
    print("\n[3] EVENTI USA NEL CALENDARIO DEL REPO")
    print("  tratto peggiore %s -> %s:" % (g0, g1))
    ev = eventi_usd(g0, g1)
    for t, tit, f in ev:
        print("    %s  %s  [%s]" % (t.strftime("%Y.%m.%d %H:%M"), tit, f))
    if not ev:
        print("    nessuno")
    print("  finestra vergine intera %s -> %s:" % (B.VERGINE_DA, B.VERGINE_A))
    for t, tit, f in eventi_usd(B.VERGINE_DA, B.VERGINE_A):
        print("    %s  %s  [%s]" % (t.strftime("%Y.%m.%d %H:%M"), tit, f))
    cop = copertura_mensile(["2025.0%d" % m for m in range(4, 10)])
    print("  COPERTURA del file 2021-2025 (eventi USD High per mese): "
          + ", ".join("%s %d" % (m, c) for m, c in cop.items()))
    print("  -> dal 2025.07.04 in poi il file ha solo le decisioni FOMC: calendario BUCATO in"
          " TUTTE E DUE le finestre estive (2025 e 2026) -> dati 8:30 e 10:00 ET [NON MISURATI]")

    # ---- 4. proxy dello stop
    print("\n[4] PROXY DELLO STOP (stop% del prezzo / EURUSD) dal volume -- [DERIVATO]")
    fx = eurusd_foto()
    for nome, X in (("VERGINE (100000)", V), ("SORGENTE ESTATE (10000)", Se),
                    ("CAL-2025 (10000)", Sc), ("SORGENTE INVERNO (10000)", Si)):
        lo = [proxy_stop(p)[0] for p in X]
        hi = [proxy_stop(p)[1] for p in X]
        print("  %-26s mediana [%.4f ; %.4f]  q25-q75 del maggiorante %.4f-%.4f"
              % (nome, B.quantile(lo, .5), B.quantile(hi, .5), B.quantile(hi, .25), B.quantile(hi, .75)))
    fxv = [fx_vicino(fx, p["giorno"]) for p in V]
    cop_fx = sum(1 for x in fxv if x)
    if cop_fx:
        stop_pct = [proxy_stop(p)[1] * f for p, f in zip(V, fxv) if f]
        stop_pt = [0.01 * p["s0"] * f / p["vol"] for p, f in zip(V, fxv) if f]
        print("  EURUSD 2026 dalle foto (data/snapshots, +-3 giorni): %d posizioni su %d; stop mediano"
              " ~%.3f%% del prezzo = ~%.0f punti indice" % (cop_fx, len(V), B.quantile(stop_pct, .5),
                                                             B.quantile(stop_pt, .5)))
    print("  EURUSD 2025: NON nel repo -> il confronto in % del prezzo porta un'incertezza del"
          " rapporto dei cambi [NON MISURATO]")
    # posizione della mediana del maggiorante vergine nel nullo del maggiorante sorgente
    boot_hi = []
    rnd = random.Random(SEME)
    serie = feriali_estate_sorgente(S)
    L = len(serie)
    for _ in range(4000):
        perc = []
        for _b in range(int(math.ceil(Lv / float(BLOCCO)))):
            s0 = rnd.randrange(L)
            perc.extend(serie[(s0 + k) % L] for k in range(BLOCCO))
        v = [proxy_stop(p) for p in perc[:Lv] if p is not None]
        boot_hi.append((B.quantile([x[0] for x in v], .5), B.quantile([x[1] for x in v], .5)))
    mv = B.quantile([proxy_stop(p)[1] for p in V], .5)
    lo_q = (B.quantile([b[0] for b in boot_hi], .025), B.quantile([b[1] for b in boot_hi], .975))
    print("  mediana vergine (maggiorante, lotto quasi esatto) %.4f; nullo d'estate della mediana,"
          " banda larga p2,5(minorante)-p97,5(maggiorante) = %.4f-%.4f -> %s"
          % (mv, lo_q[0], lo_q[1], "DENTRO" if lo_q[0] <= mv <= lo_q[1] else "FUORI"))
    return {"V": V, "S": S, "Se": Se, "Sc": Sc, "Si": Si, "boot": boot, "boot2": boot2, "esiti": esiti,
            "tratto": (g0, g1, dd, len(tr))}


# ---------------------------------------------------------------------
#  autotest: i contro-esempi
# ---------------------------------------------------------------------
def autotest():
    esiti = []

    def ok(nome, cond, det=""):
        esiti.append(bool(cond))
        print(("  PASS " if cond else "  FAIL ") + nome + ((" -- " + det) if det else ""))

    V = leggi(PT_VERGINE, DEP_VERGINE)
    G = leggi(PT_GEMELLO, DEP_VERGINE)
    S = leggi(PT_SORGENTE, DEP_SORGENTE)
    Se = [p for p in S if B.estate_usa(p["giorno"])]
    Sc = [p for p in S if CAL_DA <= p["giorno"] <= CAL_A]
    Lv = len(B.feriali(B.VERGINE_DA, B.VERGINE_A))

    # T1 numeri scritti da ALTRI
    ok("T1a vergine: 39 posizioni, netto -5686,90 (REFERTO_R248)",
       len(V) == 39 and abs(sum(p["net"] for p in V) - RIF_NETTO_VERGINE) < 0.01,
       "%d, %.2f" % (len(V), sum(p["net"] for p in V)))
    ok("T1b DD saldo chiuso vergine = 8,38% (REFERTO_R248)",
       abs(dd_saldo([p["ret"] for p in V]) - RIF_DD_VERGINE) < 0.005, "%.4f" % dd_saldo([p["ret"] for p in V]))
    ok("T1c gemella 765282 identica nei rendimenti", len(G) == len(V) and
       all(abs(a["net"] - b["net"]) <= 0.01 and a["t"] == b["t"] for a, b in zip(V, G)))
    ok("T1d sorgente: DD chiuso 5,9447% (lettura R247)",
       abs(dd_saldo([p["ret"] for p in S]) - 5.9447) < 0.001, "%.4f" % dd_saldo([p["ret"] for p in S]))
    w = sum(p["ret"] for p in Se if p["ret"] > 0)
    l = -sum(p["ret"] for p in Se if p["ret"] < 0)
    ok("T1e sorgente d'estate: 120 posizioni, PF 0,94 (R248a par. 7)",
       len(Se) == RIF_SORG_ESTATE_N and abs(w / l - RIF_SORG_ESTATE_PF) < 0.005, "%d, PF %.3f" % (len(Se), w / l))
    wc = sum(p["ret"] for p in Sc if p["ret"] > 0)
    lc = -sum(p["ret"] for p in Sc if p["ret"] < 0)
    ddc = dd_saldo([p["ret"] for p in Sc])
    ok("T1f stessa finestra un anno prima: 39 posizioni, DD 3,11%, PF 1,04 (R248a par. 7)",
       len(Sc) == RIF_CAL[0] and abs(ddc - RIF_CAL[1]) < 0.01 and abs(wc / lc - RIF_CAL[2]) < 0.01,
       "%d, DD %.2f, PF %.3f" % (len(Sc), ddc, wc / lc))
    boot = nullo(feriali_estate_sorgente(S), Lv)
    p95 = B.quantile([b["dd"] for b in boot], 0.95)
    ok("T1g stesso generatore e seme di r248: p95 DD d'estate = 7,44%", abs(p95 - RIF_P95_ESTATE) < 0.005,
       "%.4f" % p95)

    A = leggi(PT_R247A, DEP_SORGENTE)
    ok("T1h R247a: 154 posizioni, somma 1180,94 (lettura R247, r.5)",
       len(A) == 154 and abs(sum(p["net"] for p in A) - 1180.94) < 0.01,
       "%d, %.2f" % (len(A), sum(p["net"] for p in A)))
    ok("T1i R247a: chiusure dentro 2024.09.26 -> 2025.06.27",
       all(R247A_DA <= p["giorno"] <= R247A_A for p in A))

    # T2 una posizione al giorno, nessun ALTRO
    ok("T2 sorgente: una posizione per giorno", len(set(p["giorno"] for p in S)) == len(S))

    # T3 il tipo d'uscita: ogni posizione ha UNA classe, e non ALTRO
    tutte = V + S + A
    ok("T3a nessuna uscita ALTRO (vergine + R247b + R247a, 390 posizioni)",
       all(p["tipo"] != "ALTRO" for p in tutte), str(sum(p["tipo"] == "ALTRO" for p in tutte)))
    ok("T3b uscite ORA tutte fra 17:30:00 e 17:30:05 (una a :01, sorgente 2025-07-25)",
       all(p["t"].second <= 5 for p in tutte if p["tipo"] == "ORA"))
    # T4 le soglie stanno nei VUOTI: margine >= 0,10 punti da ogni posizione
    # non-ORA delle finestre che DECIDONO (vergine + sorgente d'estate).
    # D'INVERNO (solo informativo) il vuoto TP/TRAIL e' stretto: una TRAIL a
    # +1,152% e una TP a +1,264% (a 10000 il lotto arrotondato sotto fino al
    # 25% rende ambiguo 1,0-1,3%): si stampa, non decide.
    non_ora = [p["ret"] for p in V + Se if p["tipo"] != "ORA"]
    marg = min(min(abs(r - s) for r in non_ora) for s in (SOGLIA_TP, SOGLIA_SL))
    ok("T4 soglie TP/SL nei vuoti di vergine + sorgente d'estate (margine >= 0,10)", marg >= 0.10,
       "%.3f" % marg)
    amb = [p for p in S if not B.estate_usa(p["giorno"]) and p["tipo"] != "ORA" and 1.0 <= p["ret"] <= 1.3]
    print("  MISURA T4b inverno (non decide): posizioni con rendimento in [1,0 ; 1,3]%%, classe ambigua: %d"
          % len(amb))

    # T5 il tratto peggiore
    ipk, imin, dd = tratto_peggiore(V)
    ok("T5 tratto peggiore: picco 2026-07-09 -> minimo 2026-08-28",
       V[ipk]["giorno"] == dt.date(2026, 7, 9) and V[imin]["giorno"] == dt.date(2026, 8, 28))

    # T6 CALIBRAZIONE (contro-esempio del giudizio): finestre prese DAL NULLO
    # stesso devono risultare "FUORI" di rado (atteso ~5% per statistica).
    serie = feriali_estate_sorgente(S)
    rnd = random.Random(7)
    L = len(serie)
    falsi = {k: 0 for k, _ in STAT}
    prove = 200
    for _ in range(prove):
        perc = []
        for _b in range(int(math.ceil(Lv / float(BLOCCO)))):
            s0 = rnd.randrange(L)
            perc.extend(serie[(s0 + k) % L] for k in range(BLOCCO))
        st = statistiche([p for p in perc[:Lv] if p is not None])
        for k, _ in STAT:
            g = giudizio(*posizione_nel_nullo(boot, k, st[k])[:2])
            if g.startswith("FUORI"):
                falsi[k] += 1
    peggio = max(falsi.values()) / float(prove)
    ok("T6 calibrazione: finestre dal nullo giudicate FUORI <= 10% per statistica",
       peggio <= 0.10, "max %.1f%% (%s)" % (100 * peggio, max(falsi, key=falsi.get)))

    # T7 POTENZA del giudizio (contro-esempio che DEVE rompere): la vergine
    # con tutti i TRAIL dimezzati deve uscire FUORI (basso) sul TRAIL medio;
    # la vergine con le ORA alla media della sorgente NON deve uscire FUORI su ORA.
    se = statistiche(Se)
    Vh = [dict(p, ret=p["ret"] * 0.5) if p["tipo"] == "TRAIL" else p for p in V]
    g_h = giudizio(*posizione_nel_nullo(boot, "media_trail", statistiche(Vh)["media_trail"])[:2])
    ok("T7a TRAIL dimezzati -> FUORI (basso)", g_h == "FUORI (basso)", g_h)
    Vo = [dict(p, ret=se["media_ora"]) if p["tipo"] == "ORA" else p for p in V]
    g_o = giudizio(*posizione_nel_nullo(boot, "media_ora", statistiche(Vo)["media_ora"])[:2])
    ok("T7b ORA alla media della sorgente -> non FUORI", not g_o.startswith("FUORI"), g_o)

    # T8 il proxy dello stop ordina le stagioni come il meccanismo prevede:
    # d'inverno l'EA arma alle 14:30 server = un'ora PRIMA della cash (range
    # di pre-mercato, stretto) -> stop% piu' piccolo che d'estate. Se il
    # proxy non vedesse questa differenza nota, non misurerebbe lo stop.
    Si = [p for p in S if not B.estate_usa(p["giorno"])]
    ok("T8 proxy stop: inverno (pre-mercato) < estate, maggiorante inverno < minorante estate",
       B.quantile([proxy_stop(p)[1] for p in Si], .5) < B.quantile([proxy_stop(p)[0] for p in Se], .5),
       "%.4f < %.4f" % (B.quantile([proxy_stop(p)[1] for p in Si], .5),
                        B.quantile([proxy_stop(p)[0] for p in Se], .5)))

    # T9 il feed: le uscite che hanno una chiusura viva alla stessa ora al
    # secondo coincidono al centesimo (contro-esempio: se il tester avesse un
    # feed diverso, UNA sola differenza basterebbe a vederlo).
    rf = confronto_feed(V)
    ok("T9 feed tester = feed vivo su tutte le uscite confrontabili (>= 3)",
       len(rf) >= 3 and all(abs(x[1] - x[0]["px"]) < 0.005 for x in rf), "%d confronti" % len(rf))
    # T10 il LIMITE del primo nullo, misurato: la media delle ORA di una
    # finestra del bootstrap non puo' scendere sotto la ORA peggiore della
    # sorgente. Se la vergine sta sotto quel minimo, "FUORI" e' anche un
    # effetto del supporto (12 valori): per questo c'e' il secondo nullo.
    min_ora = min(p["ret"] for p in Se if p["tipo"] == "ORA")
    min_boot = min(b["media_ora"] for b in boot if not math.isnan(b["media_ora"]))
    ok("T10 supporto del nullo 1: media ORA simulata >= ORA peggiore della sorgente",
       min_boot >= min_ora - 1e-9, "min simulata %.3f, ORA peggiore %.3f, vergine %.3f"
       % (min_boot, min_ora, statistiche(V)["media_ora"]))

    # T11 TARATURA del banco pari (contro-esempio): a lotto esatto la perdita
    # media degli SL deve coincidere fra vergine (100000) e sorgente d'estate
    # (10000), perche' lo stop vale -1R a qualunque deposito; e h=0,10 deve
    # SOVRACORREGGERE (se no h non e' identificato dagli SL).
    sl_v = statistiche(lotto_pari(V))["media_sl"]
    sl_s = statistiche(lotto_pari(Se))["media_sl"]
    sl_s10 = statistiche(lotto_pari(Se, 0.10))["media_sl"]
    ok("T11 banco pari: SL medi vergine/sorgente entro 0,02 a h=0,05; h=0,10 li separa di piu'",
       abs(sl_v - sl_s) <= 0.02 and abs(statistiche(lotto_pari(V, 0.10))["media_sl"] - sl_s10) > abs(sl_v - sl_s),
       "vergine %.3f, sorgente %.3f" % (sl_v, sl_s))

    n_ok = sum(esiti)
    print("  AUTOTEST %d/%d %s" % (n_ok, len(esiti), "PASS" if n_ok == len(esiti) else "FAIL"))
    return 0 if n_ok == len(esiti) else 1


def main():
    if "--autotest" in sys.argv:
        sys.exit(autotest())
    lettura()


if __name__ == "__main__":
    main()
