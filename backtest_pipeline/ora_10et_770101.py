#!/usr/bin/env python3
# =====================================================================
#  ora_10et_770101.py -- LA SEDIA 770101 (DAX Apertura EU, long RETEST)
#  PERDE DI PIU' ATTORNO ALLE 10:00 DI NEW YORK?
#  SOLA LETTURA, zero tempo macchina. Referto:
#  report/ORA_10ET_SULLA_770101_2026-09-25.md
# ---------------------------------------------------------------------
#  LA DOMANDA (25/09/2026): sulla challenge FTMO la 770101 e' stata
#  stoppata da UNA candela M5, quella delle 16:00 IT = 10:00 ET
#  (report/TERZO_STOP_FTMO_2026-09-25.md). E' un caso o la sedia perde
#  in modo SPROPORZIONATO attorno alle 10:00 ET (dati USA delle 10)?
#
#  L'OROLOGIO (report/OROLOGIO_BCM_2026-09-24.md par. 3.2):
#   - lo storico INDICI BCM (dal 2024.09.26) e' UTC+1 FISSO;
#   - 10:00 ET = 15:00 BCM con l'ora legale USA (2a dom. marzo -> 1a dom.
#     novembre), 16:00 BCM con l'ora solare USA. Solo il calendario USA
#     conta: BCM non ha ora legale. Le settimane "sfasate" (USA legale, UE
#     solare) cadono quindi a 15:00, come l'estate.
#   - close_time del per-trade = ora server BCM.
#
#  I DATI
#   * sedia (backtest, geometria viva 770101 a parte la taglia):
#     R246g magic 794613 (2024.09.27 -> 2025.06.09) + R246e magic 794611
#     (2025.06.10 -> 2026.06.30), tick reali, deposito 100000, rischio 1%.
#     Stessa cella del per-trade del Monte Carlo (772501, G0 VERDE in
#     REFERTO_R246 par. 2). Gemelle 794663/794661 per il determinismo.
#   * forward: data/statements/trades_100k.csv (50504263) e trades_auto.csv
#     (50503392), righe 770101 "RETEST BUY" (hanno ORA D'INGRESSO); FTMO:
#     il solo stop del 25/09 (report TERZO_STOP), nessun per-trade FTMO nel
#     repo (IL_PERTRADE_FTMO_ESISTE_2026-09-23: mai pubblicato).
#   * CONTROLLO di mercato (contro-esempio): R109 ABTG_AtrExhaustVol D30EUR
#     M15 long, report HTML del tester con ingresso, uscita e commento "sl"
#     di OGNI posizione -> l'insieme a rischio e' ESATTO.
#   * i DUE LATI (regola 25/08): R251 magic 792520 = short "identico al
#     long" (ancora), OOS 2025.07.01 -> 2026.06.29, deposito 10000.
#
#  COSA IL PER-TRADE DELLA SEDIA NON HA: ora e prezzo d'INGRESSO, SL.
#  Quindi:
#   * TIPO D'USCITA dedotto (logica EA a HEAD, ManageOneTicket r.2344ss):
#       ORA    ultimo deal alle 17:30 server (InpCloseAtEnd)
#       SL     posizione a UN deal con R <= -0,5 (stop pieno; misurato: i 69
#              stop stanno fra -1,078 e -0,922, il vuoto va da -0,92 a -0,17)
#       TRAIL  posizione a UN deal con R > -0,5 (il trailing PREVBAR sposta
#              lo stop SOLO oltre l'ingresso, r.2446: esce ~in pari o sopra)
#       TP1+   posizione a DUE deal: parziale al 1o obiettivo, poi pari /
#              trailing / TP 3R / ora
#   * R = somma netto della posizione / (1% del saldo prima della posizione)
#     (una posizione al giorno, niente sovrapposizioni: controllato).
#   * INSIEME A RISCHIO di stop pieno all'istante t = posizioni del giorno il
#     cui PRIMO deal e' dopo t (non ancora parziale, non ancora chiuse).
#     E' un MAGGIORANTE: contiene anche chi non era ancora entrato (il RETEST
#     puo' armarsi a qualunque ora fino alle 17:30, MonitorRetest non ha
#     limite orario). Il forward misura quanti entrano dopo le 10 ET.
#
#  USO
#    python3 backtest_pipeline/ora_10et_770101.py            # la lettura
#    python3 backtest_pipeline/ora_10et_770101.py --autotest # esce 1 se FAIL
# =====================================================================
from __future__ import annotations

import csv
import datetime as dt
import math
import os
import random
import re
import sys

QUI = os.path.dirname(os.path.abspath(__file__))
RADICE = os.path.dirname(QUI)
ARCH = os.path.join(QUI, "risultati_archivio")

PT = os.path.join(ARCH, "R246", "PERTRADE", "abtg_trades_ABTG_DAX_Apertura_EU_D30EUR_%s.csv")
CSV_OOS = os.path.join(ARCH, "R246", "ROUND_%s", "ABTG_DAX_Apertura_EU_D30EUR_OOS_%s.csv")
# (etichetta round, magic, gemella, deposito)
SEDIA = [("R246g", "794613", "794663", 100000.0),
         ("R246e", "794611", "794661", 100000.0)]
PT_SHORT = os.path.join(ARCH, "R251", "PERTRADE", "abtg_trades_ABTG_DAX_Apertura_EU_D30EUR_792520.csv")
CSV_SHORT = os.path.join(ARCH, "R251", "ROUND_R251b", "ABTG_DAX_Apertura_EU_D30EUR_OOS_R251b.csv")
DEP_SHORT = 10000.0
HTML_R109 = os.path.join(ARCH, "R109_deal_anomali", "D30EUR_00_long_report_singola.htm")
ST_100K = os.path.join(RADICE, "data", "statements", "trades_100k.csv")
ST_PICC = os.path.join(RADICE, "data", "statements", "trades_auto.csv")

# Numeri scritti da ALTRI, contro cui si controlla
RIF_B = (270, 193, 18029.58)   # REFERTO_R246 par. 2: R246e 270 righe, 193 posizioni, somma
RIF_A = (175, 3789.36)         # REFERTO_R246 par. 3 (G2): R246g 175 deal, somma
RIF_SHORT = (243, 254.74)      # RIEPILOGO_R251: 792520 243 righe, somma 254.74
RIF_R109 = (818, -43608.40)    # intestazione dell'HTML R109: 818 operazioni, netto

# Lo stop FTMO del 25/09 (report/TERZO_STOP_FTMO_2026-09-25.md par. 1-2).
# Ora FTMO = ora BCM + 2 d'estate (PRESET_FTMO: FTMO = IT+1, BCM = IT-1).
FTMO_EVENTO = dict(ing_ftmo=dt.datetime(2026, 9, 25, 12, 27, 10),
                   usc_ftmo=dt.datetime(2026, 9, 25, 17, 2, 18),
                   netto=-1552.80, saldo0=76643.52, rischio=0.02)

FUOCO = (0, 10)        # la finestra della domanda: 10:00-10:10 ET
FINESTRA = (-60, 60)   # i vicini: un'ora prima, un'ora dopo
PASSO = 5              # secchielli da 5 minuti


# ---------------------------------------------------------------------
#  orologio
# ---------------------------------------------------------------------
def domenica_n(anno, mese, n):
    d = dt.date(anno, mese, 1)
    d += dt.timedelta(days=(6 - d.weekday()) % 7)
    return d + dt.timedelta(weeks=n - 1)


def ultima_domenica(anno, mese):
    d = dt.date(anno + (mese == 12), mese % 12 + 1, 1) - dt.timedelta(days=1)
    return d - dt.timedelta(days=(d.weekday() + 1) % 7)


def usa_legale(d):
    """Ora legale USA: 2a domenica di marzo -> 1a domenica di novembre."""
    return domenica_n(d.year, 3, 2) <= d < domenica_n(d.year, 11, 1)


def ue_legale(d):
    return ultima_domenica(d.year, 3) <= d < ultima_domenica(d.year, 10)


def t10(d):
    """10:00 di New York in ora server BCM (UTC+1 fisso)."""
    return dt.datetime.combine(d, dt.time(15 if usa_legale(d) else 16, 0))


def rel10(t):
    """minuti fra t (ora BCM) e le 10:00 ET dello stesso giorno."""
    return (t - t10(t.date())).total_seconds() / 60.0


# ---------------------------------------------------------------------
#  lettura e verifica
# ---------------------------------------------------------------------
def leggi_deal(percorso):
    out = []
    with open(percorso, newline="", encoding="ascii", errors="replace") as fh:
        for r in csv.DictReader(fh, delimiter=";"):
            out.append(dict(t=dt.datetime.strptime(r["close_time"], "%Y.%m.%d %H:%M:%S"),
                            pid=r["position_id"], tipo_deal=r["deal_type"], vol=float(r["volume"]),
                            px=float(r["price"]), net=float(r["net_profit"]), magic=r["magic"]))
    return out


def csv_oos(percorso, filtro=None):
    """Profit e Trades (deal) della riga del CSV d'ottimizzazione: la prima,
    o la prima che rispetta filtro = {colonna: valore} (classe: la riga
    giusta si SCEGLIE per parametro, non per posizione)."""
    with open(percorso, newline="", encoding="utf-8", errors="replace") as fh:
        for r in csv.DictReader(fh):
            if filtro is None or all(r[k] == v for k, v in filtro.items()):
                return float(r["Profit"]), int(r["Trades"])
    raise SystemExit("nessuna riga con " + repr(filtro) + " in " + percorso)


def verifica_file(deal, profit, trades):
    """(ok, messaggio): righe = Trades e somma netto = Profit al centesimo."""
    s = round(sum(x["net"] for x in deal), 2)
    ok = len(deal) == trades and abs(s - profit) < 0.005
    return ok, "righe %d / Trades %d, somma %.2f / Profit %.2f" % (len(deal), trades, s, profit)


def gemelle_identiche(a, b):
    if len(a) != len(b):
        return False
    campi = ("t", "pid", "tipo_deal", "vol", "px", "net")
    return all(all(x[c] == y[c] for c in campi) for x, y in zip(a, b))


def posizioni(deal, deposito, soglia_sl=-0.5):
    """Raggruppa per position_id, R sul saldo prima della posizione."""
    deal = sorted(deal, key=lambda x: x["t"])
    per, ordine, saldo = {}, [], deposito
    for x in deal:
        if x["pid"] not in per:
            per[x["pid"]] = dict(deals=[], s0=saldo)
            ordine.append(x["pid"])
        per[x["pid"]]["deals"].append(x)
        saldo += x["net"]
    out = []
    for pid in ordine:
        p = per[pid]
        d = p["deals"]
        R = sum(x["net"] for x in d) / (0.01 * p["s0"])
        out.append(dict(pid=pid, f=d[0]["t"], l=d[-1]["t"], n=len(d), R=R,
                        R1=d[0]["net"] / (0.01 * p["s0"]), giorno=d[0]["t"].date(),
                        lato="L" if d[0]["tipo_deal"] == "1" else "S"))
    for p in out:
        p["tipo"] = tipo_uscita(p, soglia_sl)
    return out


def tipo_uscita(p, soglia_sl=-0.5):
    if p["l"].hour == 17 and p["l"].minute == 30:
        return "ORA"
    if p["n"] >= 2:
        return "TP1+"
    return "SL" if p["R"] <= soglia_sl else "TRAIL"


def sovrapposte(pos):
    s = sorted(pos, key=lambda p: p["f"])
    return sum(1 for a, b in zip(s, s[1:]) if b["f"] < a["l"])


# ---------------------------------------------------------------------
#  tassi con l'insieme a rischio (sedia: maggiorante; controllo: esatto)
# ---------------------------------------------------------------------
def secchielli(lo, hi, passo=PASSO):
    return [(a, a + passo) for a in range(lo, hi, passo)]


def esposizione_sedia(pos, a, b):
    """minuti-posizione "a rischio pieno" dentro [a,b) minuti dalle 10 ET:
    dall'inizio del secchiello (ingresso ignoto: si assume gia' dentro) al
    PRIMO deal. Maggiorante."""
    e = 0.0
    for p in pos:
        rf = rel10(p["f"])
        if rf > a:
            e += min(rf, b) - a
    return e


def eventi_sedia(pos, a, b, tipi=("SL",)):
    return sum(1 for p in pos if p["tipo"] in tipi and a <= rel10(p["f"]) < b)


def esposizione_esatta(intervalli, a, b, orologio="ET", stagione=None):
    """intervalli = [(ingresso, uscita)] in ora BCM. Minuti-posizione dentro
    la finestra [a,b) minuti relativi a: 'ET' -> 10:00 ET del giorno;
    'BCM15' -> 15:00 BCM del giorno. stagione: None, 'legale', 'solare'."""
    e = 0.0
    for i, u in intervalli:
        d = i.date()
        while d <= u.date():
            if stagione is None or (stagione == "legale") == usa_legale(d):
                base = t10(d) if orologio == "ET" else dt.datetime.combine(d, dt.time(15, 0))
                s0, s1 = base + dt.timedelta(minutes=a), base + dt.timedelta(minutes=b)
                lo, hi = max(i, s0), min(u, s1)
                if hi > lo:
                    e += (hi - lo).total_seconds() / 60.0
            d += dt.timedelta(days=1)
    return e


def invecchiate(pos, eta_min):
    """Il contro-esempio dell'INGRESSO FRESCO: si tiene di ogni posizione solo
    la vita DOPO i primi eta_min minuti (numeratore e denominatore). Una
    posizione appena aperta ha lo stop vicino e muore presto: se gli ingressi
    si ammassano alle 10 ET, il picco puo' essere loro e non dell'ora. Il
    profilo dello stop FTMO del 25/09 e' una posizione aperta da 4,5 ore."""
    out = []
    for p in pos:
        if eta_min == 0 or (p["u"] - p["i"]).total_seconds() / 60.0 > eta_min:
            out.append(dict(p, i=p["i"] + dt.timedelta(minutes=eta_min)))
    return out


def rel_orologio(t, orologio):
    if orologio == "ET":
        return rel10(t)
    return (t - dt.datetime.combine(t.date(), dt.time(15, 0))).total_seconds() / 60.0


# ---------------------------------------------------------------------
#  statistica
# ---------------------------------------------------------------------
def coda_binomiale(k, n, p):
    """P(X >= k), X ~ Bin(n, p)."""
    if k <= 0:
        return 1.0
    return sum(math.comb(n, j) * p ** j * (1 - p) ** (n - j) for j in range(k, n + 1))


def coda_poisson(k, mu):
    """P(X >= k), X ~ Poisson(mu)."""
    if k <= 0:
        return 1.0
    return 1.0 - sum(math.exp(-mu) * mu ** j / math.factorial(j) for j in range(k))


def test_locale(ev_fuoco, ev_fin, esp_fuoco, esp_fin):
    """Il nullo GIUSTO: dato il numero di stop nella finestra, la quota
    attesa nel fuoco e' la quota di ESPOSIZIONE (posizioni aperte x minuti),
    non la quota di TEMPO. Restituisce (p0, P(X>=k))."""
    if esp_fin <= 0 or ev_fin == 0:
        return (esp_fuoco / esp_fin if esp_fin > 0 else float("nan")), 1.0
    p0 = esp_fuoco / esp_fin
    return p0, coda_binomiale(ev_fuoco, ev_fin, p0)


def test_ingenuo(ev_fuoco, ev_fin, lung_fuoco, lung_fin):
    """Il nullo SBAGLIATO (tempo uniforme): per il contro-esempio."""
    p0 = lung_fuoco / lung_fin
    return p0, coda_binomiale(ev_fuoco, ev_fin, p0)


def statistica_fuoco(eventi_rel, esp_fn, fuoco=FUOCO, finestra=FINESTRA):
    """eventi_rel: minuti degli eventi dalle 10 ET; esp_fn(a,b) -> esposizione.
    Ritorna dict con conteggi, quote, p-value locale e ingenuo."""
    k = sum(1 for r in eventi_rel if fuoco[0] <= r < fuoco[1])
    K = sum(1 for r in eventi_rel if finestra[0] <= r < finestra[1])
    ef, eW = esp_fn(*fuoco), esp_fn(*finestra)
    p0, p = test_locale(k, K, ef, eW)
    q0, q = test_ingenuo(k, K, fuoco[1] - fuoco[0], finestra[1] - finestra[0])
    return dict(k=k, K=K, esp_f=ef, esp_W=eW, p0=p0, p=p, p0_ing=q0, p_ing=q)


# ---------------------------------------------------------------------
#  controllo di mercato: R109 (HTML del tester)
# ---------------------------------------------------------------------
def leggi_r109(percorso=HTML_R109):
    t = open(percorso, "rb").read().decode("utf-16")
    righe = re.findall(r"<tr[^>]*>(.*?)</tr>", t, re.S)
    deal = []
    for r in righe:
        c = [re.sub(r"<[^>]+>", "", x).strip() for x in re.findall(r"<td[^>]*>(.*?)</td>", r, re.S)]
        if len(c) == 13 and re.match(r"\d{4}\.\d\d\.\d\d \d\d:\d\d:\d\d", c[0]) and c[4] in ("in", "out"):
            num = lambda s: float(s.replace(" ", "").replace("\xa0", "") or 0)
            # netto = commissione + swap + profitto (colonne 8, 9, 10 dell'HTML)
            deal.append(dict(t=dt.datetime.strptime(c[0], "%Y.%m.%d %H:%M:%S"), verso=c[4],
                             net=num(c[8]) + num(c[9]) + num(c[10]), commento=c[12]))
    pos, aperta = [], None
    for x in deal:
        if x["verso"] == "in":
            if aperta is not None:
                raise SystemExit("R109: due ingressi di fila, l'accoppiamento non regge")
            aperta = x
        else:
            if aperta is None:
                raise SystemExit("R109: uscita senza ingresso")
            pos.append(dict(i=aperta["t"], u=x["t"], net=x["net"],
                            motivo=x["commento"].split(" ")[0]))
            aperta = None
    return pos


def tabella_esatta(pos, lo, hi, motivo="sl", orologio="ET", stagione=None, passo=PASSO):
    inter = [(p["i"], p["u"]) for p in pos]
    out = []
    for a, b in secchielli(lo, hi, passo):
        e = esposizione_esatta(inter, a, b, orologio, stagione)
        k = sum(1 for p in pos if p["motivo"] == motivo and a <= rel_orologio(p["u"], orologio) < b
                and (stagione is None or (stagione == "legale") == usa_legale(p["u"].date())))
        out.append((a, b, e, k))
    return out


# ---------------------------------------------------------------------
#  forward
# ---------------------------------------------------------------------
def leggi_forward():
    """Righe 770101 'RETEST BUY' dai due estratti BCM (stessa sedia
    specchiata: si tiene un'operazione per ora d'ingresso; R dal 100k,
    rischio 0,65% del ~100.000 = 650 EUR [DERIVATO])."""
    visti = {}
    for percorso, conto in ((ST_100K, "50504263"), (ST_PICC, "50503392")):
        with open(percorso, newline="", encoding="utf-8", errors="replace") as fh:
            for r in csv.DictReader(fh, delimiter=";"):
                if r["magic"] != "770101" or "RETEST BUY" not in r["strategy"]:
                    continue
                ing = dt.datetime.strptime(r["open_time"], "%Y.%m.%d %H:%M:%S")
                usc = dt.datetime.strptime(r["close_time"], "%Y.%m.%d %H:%M:%S")
                R = float(r["profit"]) / 650.0 if conto == "50504263" else None
                if ing not in visti or (visti[ing]["R"] is None and R is not None):
                    visti[ing] = dict(i=ing, u=usc, R=R, conto=conto, motivo=r["close_reason"])
    return [visti[k] for k in sorted(visti)]


def evento_ftmo():
    e = FTMO_EVENTO
    i = e["ing_ftmo"] - dt.timedelta(hours=2)
    u = e["usc_ftmo"] - dt.timedelta(hours=2)
    return dict(i=i, u=u, R=e["netto"] / (e["rischio"] * e["saldo0"]))


# ---------------------------------------------------------------------
#  gruppi alle 10 ET e controfattuale
# ---------------------------------------------------------------------
def gruppi_a(pos, scarto_min=0):
    """A: chiuse prima di T; B: parziale prima di T, resto aperto a T;
    C: primo deal dopo T (a rischio pieno a T, o non ancora entrate).
    T = 10:00 ET + scarto_min."""
    g = {"A": [], "B": [], "C": []}
    for p in pos:
        T = t10(p["giorno"]) + dt.timedelta(minutes=scarto_min)
        if p["l"] < T:
            g["A"].append(p)
        elif p["f"] < T:
            g["B"].append(p)
        else:
            g["C"].append(p)
    return g


def riassunto(ps):
    if not ps:
        return dict(n=0, somma=0.0, media=float("nan"), vinc=float("nan"), pf=float("nan"), tipi={})
    g = sum(p["R"] for p in ps if p["R"] > 0)
    l = -sum(p["R"] for p in ps if p["R"] < 0)
    tipi = {}
    for p in ps:
        tipi[p["tipo"]] = tipi.get(p["tipo"], 0) + 1
    return dict(n=len(ps), somma=sum(p["R"] for p in ps), media=sum(p["R"] for p in ps) / len(ps),
                vinc=sum(1 for p in ps if p["R"] > 0) / len(ps), pf=(g / l if l > 0 else float("inf")), tipi=tipi)


def controfattuale(pos, scarto_min=-5):
    """"PIATTI alle 9:55 ET" (scelto DOPO aver visto la domanda).
    Limiti DURI, per posizione, in R:
      A (chiusa prima di T): identica.
      B (parziale fatta, meta' aperta con stop >= ingresso, TP a 3R):
        R1 + [0 ; 1,5).
      C (primo deal dopo T): o non ancora entrata (niente trade: 0) o a
        rischio pieno col prezzo fra lo stop (> -1R) e il TP finale (< 3R):
        (-1 ; 3). Il punto e' [NON MISURATO]: serve il prezzo alle 9:55 ET."""
    g = gruppi_a(pos, scarto_min)
    reale = sum(p["R"] for p in pos)
    fisso = sum(p["R"] for p in g["A"])
    lo = fisso + sum(p["R1"] for p in g["B"]) - 1.0 * len(g["C"])
    hi = fisso + sum(p["R1"] + 1.5 for p in g["B"]) + 3.0 * len(g["C"])
    return dict(reale=reale, fisso=fisso, lo=lo, hi=hi, g=g,
                reale_BC=sum(p["R"] for p in g["B"] + g["C"]))


# ---------------------------------------------------------------------
#  la lettura
# ---------------------------------------------------------------------
def carica_sedia(stampa=True):
    tutte, esiti = [], []
    for eti, m, gem, dep in SEDIA:
        d = leggi_deal(PT % m)
        dg = leggi_deal(PT % gem)
        prof, tr = csv_oos(CSV_OOS % (eti, eti))
        ok, msg = verifica_file(d, prof, tr)
        g = gemelle_identiche(d, dg)
        esiti.append((eti, m, ok, g, msg))
        tutte += posizioni(d, dep)
    if stampa:
        for eti, m, ok, g, msg in esiti:
            print("  %s magic %s: %s -> %s | gemella identica: %s" % (eti, m, msg, "OK" if ok else "FALLITO",
                                                                      "si" if g else "NO"))
    if not all(e[2] and e[3] for e in esiti):
        raise SystemExit("verifica dei file FALLITA: niente lettura")
    return tutte


def f2(x):
    return ("%.2f" % x).replace(".", ",")


def f3(x):
    return ("%.3f" % x).replace(".", ",")


def lettura():
    print("=" * 72)
    print("ORA 10 ET SULLA 770101 -- sola lettura, zero tempo macchina")
    print("=" * 72)
    print("\n[0] I FILE, verificati contro il loro CSV e contro la gemella")
    pos = carica_sedia()
    tipi = {}
    for p in pos:
        tipi[p["tipo"]] = tipi.get(p["tipo"], 0) + 1
    print("  posizioni %d (giorni %d, sovrapposte %d) | tipi %s" % (
        len(pos), len(set(p["giorno"] for p in pos)), sovrapposte(pos), dict(sorted(tipi.items()))))
    print("  lato: %s" % sorted(set(p["lato"] for p in pos)))
    sl = [p for p in pos if p["tipo"] == "SL"]
    print("  stop pieni: R da %s a %s" % (f3(min(p["R"] for p in sl)), f3(max(p["R"] for p in sl))))
    print("  controllo con numeri scritti da altri: R246e %d righe / %d posizioni (rif. %d / %d), R246g %d deal (rif. %d)"
          % (len(leggi_deal(PT % "794611")), len(posizioni(leggi_deal(PT % "794611"), 1e5)), RIF_B[0], RIF_B[1],
             len(leggi_deal(PT % "794613")), RIF_A[0]))

    # ---- [1] stop pieni per secchiello
    print("\n[1] STOP PIENI per secchiello di 5' dalle 10:00 ET (insieme a rischio = MAGGIORANTE)")
    print("  %-11s %9s %8s %4s %4s %6s %14s" % ("minuti", "N inizio", "esp.min", "SL", "TP1", "TRAIL", "SL/100 pos-ora"))
    for a, b in secchielli(-120, 150):
        e = esposizione_sedia(pos, a, b)
        N = sum(1 for p in pos if rel10(p["f"]) > a)
        k = eventi_sedia(pos, a, b, ("SL",))
        k1 = eventi_sedia(pos, a, b, ("TP1+",))
        kt = eventi_sedia(pos, a, b, ("TRAIL",))
        tasso = (k / e * 6000.0) if e > 0 else float("nan")
        print("  [%+4d,%+4d) %9d %8.0f %4d %4d %6d %14s" % (a, b, N, e, k, k1, kt, f2(tasso) if e > 0 else "-"))
    rel_sl = [rel10(p["f"]) for p in sl]
    st = statistica_fuoco(rel_sl, lambda a, b: esposizione_sedia(pos, a, b))
    print("  FUOCO [0,10) contro FINESTRA [-60,60): stop nel fuoco %d su %d nella finestra" % (st["k"], st["K"]))
    print("    nullo GIUSTO (quota di esposizione) p0 = %s -> P(X>=k) = %s" % (f3(st["p0"]), f3(st["p"])))
    print("    nullo INGENUO (quota di tempo)      p0 = %s -> P(X>=k) = %s" % (f3(st["p0_ing"]), f3(st["p_ing"])))
    # base del pomeriggio e limite superiore del rapporto
    pom = [(a, b) for a, b in secchielli(-180, 150) if not (FUOCO[0] <= a < FUOCO[1])]
    k_pom = sum(eventi_sedia(pos, a, b) for a, b in pom)
    e_pom = sum(esposizione_sedia(pos, a, b) for a, b in pom)
    e_f = esposizione_sedia(pos, *FUOCO)
    lam = k_pom / e_pom if e_pom > 0 else float("nan")
    atteso = lam * e_f
    print("  base pomeriggio [-180,+150) senza il fuoco: %d stop su %.0f min-posizione -> attesi nel fuoco %s"
          % (k_pom, e_pom, f3(atteso)))
    if st["k"] == 0 and atteso > 0:
        print("    zero osservati: limite superiore 95%% del rapporto di tassi ~ %s (Poisson, 3,0/atteso) [DERIVATO]"
              % f2(2.996 / atteso))
    matt = [(a, b) for a, b in secchielli(-420, -300)]
    k_m = sum(eventi_sedia(pos, a, b) for a, b in matt)
    e_m = sum(esposizione_sedia(pos, a, b) for a, b in matt)
    print("  per confronto, mattina [-420,-300) (= 08:00-10:00 BCM d'estate): %d stop su %.0f min-posizione"
          " -> %s stop/100 pos-ora (maggiorante del denominatore: tasso MINORANTE)" % (k_m, e_m, f2(k_m / e_m * 6000)))
    print("  stop pieni dopo le 10:00 ET: %d su %d; dopo le 9:00 ET: %d" % (
        sum(1 for r in rel_sl if r >= 0), len(sl), sum(1 for r in rel_sl if r >= -60)))
    for p in sl:
        if rel10(p["f"]) >= -120:
            print("    %s  %s  %+.1f min dalle 10 ET  R %s" % (p["f"], "USA legale" if usa_legale(p["giorno"]) else "USA solare",
                                                               rel10(p["f"]), f3(p["R"])))

    # ---- [2] P/L di chi e' aperto alle 10 ET
    print("\n[2] P/L (in R) di chi e' ancora aperto alle 10:00 ET contro chi ha chiuso prima")
    g = gruppi_a(pos, 0)
    for chiave, nome in (("A", "chiuse prima delle 10 ET"), ("B", "parziale fatta, resto aperto"),
                         ("C", "primo deal dopo le 10 ET")):
        r = riassunto(g[chiave])
        print("  %s %-30s n %3d  somma %8s  media %7s  vinc. %5s  PF %6s  %s" % (
            chiave, nome, r["n"], f2(r["somma"]), f3(r["media"]), f2(100 * r["vinc"]) + "%",
            f2(r["pf"]) if r["pf"] != float("inf") else "inf", r["tipi"]))
    for stag in ("legale", "solare"):
        gg = gruppi_a([p for p in pos if (stag == "legale") == usa_legale(p["giorno"])], 0)
        rc = riassunto(gg["C"])
        print("  stagione USA %s: C n %d somma %s | A+B+C n %d" % (stag, rc["n"], f2(rc["somma"]),
                                                                  sum(len(v) for v in gg.values())))

    # ---- [3] controfattuale
    print("\n[3] CONTROFATTUALE 'piatti alle 9:55 ET' (scelto DOPO la domanda) -- limiti DURI")
    cf = controfattuale(pos, -5)
    print("  reale: somma R %s su %d posizioni | parte identica (chiuse prima): %s su %d" % (
        f2(cf["reale"]), len(pos), f2(cf["fisso"]), len(cf["g"]["A"])))
    print("  B (parziale fatta): %d, reale %s | C (primo deal dopo 9:55 ET): %d, reale %s" % (
        len(cf["g"]["B"]), f2(sum(p["R"] for p in cf["g"]["B"])), len(cf["g"]["C"]),
        f2(sum(p["R"] for p in cf["g"]["C"]))))
    print("  controfattuale in [%s ; %s] R contro il reale %s: il punto e' [NON MISURATO]" % (
        f2(cf["lo"]), f2(cf["hi"]), f2(cf["reale"])))
    stC = [p for p in cf["g"]["C"] if p["tipo"] == "SL"]
    print("  stop pieni dentro C: %d (reale %s R): e' tutto il 'danno' che la regola puo' togliere" % (
        len(stC), f2(sum(p["R"] for p in stC))))

    # ---- [4] forward
    print("\n[4] FORWARD con ORA D'INGRESSO (BCM 770101 RETEST BUY + FTMO 25/09)")
    fw = leggi_forward()
    ft = evento_ftmo()
    print("  BCM: %d operazioni distinte (%s -> %s)" % (len(fw), fw[0]["i"].date(), fw[-1]["i"].date()))
    dopo = [x for x in fw if rel10(x["i"]) >= 0]
    aperte = [x for x in fw if rel10(x["i"]) < 0 <= rel10(x["u"])]
    print("  entrate DOPO le 10 ET: %d su %d | entrate prima e ancora aperte alle 10 ET: %d" % (
        len(dopo), len(fw), len(aperte)))
    for x in fw:
        print("    ing %s  usc %s  (%+.0f / %+.0f min dalle 10 ET)  %s  R %s" % (
            x["i"].strftime("%m-%d %H:%M"), x["u"].strftime("%H:%M"), rel10(x["i"]), rel10(x["u"]), x["motivo"],
            f2(x["R"]) if x["R"] is not None else "-"))
    print("  FTMO 25/09: ingresso %s BCM (%+.0f min), uscita %s BCM (%+.1f min dalle 10 ET), R %s" % (
        ft["i"].strftime("%H:%M:%S"), rel10(ft["i"]), ft["u"].strftime("%H:%M:%S"), rel10(ft["u"]), f3(ft["R"])))
    esp_fw = sum(max(0.0, min(rel10(x["u"]), 150) - max(rel10(x["i"]), 0)) for x in fw) / 60.0
    print("  esposizione BCM dopo le 10 ET: %s ore-posizione in tutto il forward" % f2(esp_fw))

    # ---- [5] controllo di mercato
    print("\n[5] CONTROLLO DI MERCATO: R109 AtrExhaustVol D30EUR M15 long (insieme a rischio ESATTO)")
    r1 = leggi_r109()
    print("  posizioni %d, sl %d, tp %d, netto %s (rif. %d / %s)" % (
        len(r1), sum(1 for p in r1 if p["motivo"] == "sl"), sum(1 for p in r1 if p["motivo"] == "tp"),
        f2(sum(p["net"] for p in r1)), RIF_R109[0], f2(RIF_R109[1])))
    tab = tabella_esatta(r1, -120, 150)
    tabtp = tabella_esatta(r1, -120, 150, motivo="tp")
    print("  %-11s %8s %4s %4s %10s %10s" % ("min da 10ET", "esp.min", "SL", "TP", "SL/100p-h", "TP/100p-h"))
    for (a, b, e, k), (_, _, _, kt) in zip(tab, tabtp):
        print("  [%+4d,%+4d) %8.0f %4d %4d %10s %10s" % (a, b, e, k, kt, f2(k / e * 6000) if e else "-",
                                                         f2(kt / e * 6000) if e else "-"))
    for eta in (0, 15, 60):
        rr = invecchiate(r1, eta)
        inter = [(p["i"], p["u"]) for p in rr]
        print("  --- eta' minima della posizione %d min (%d posizioni, %d sl)" % (
            eta, len(rr), sum(1 for p in rr if p["motivo"] == "sl")))
        for motivo in ("sl", "tp"):
            ev = [rel10(p["u"]) for p in rr if p["motivo"] == motivo]
            s = statistica_fuoco(ev, lambda a, b: esposizione_esatta(inter, a, b))
            s2 = statistica_fuoco(ev, lambda a, b: esposizione_esatta(inter, a, b), fuoco=(-30, -20))
            print("  %s: fuoco [0,10) %d su %d in [-60,60), attesi %s; p0 esposizione %s -> P %s | ingenuo p0 %s -> P %s"
                  " | 9:30-9:40 ET %d, P %s" % (
                      motivo.upper(), s["k"], s["K"], f2(s["p0"] * s["K"]), f3(s["p0"]), f3(s["p"]),
                      f3(s["p0_ing"]), f3(s["p_ing"]), s2["k"], f3(s2["p"])))
        print("  il contro-esempio dell'OROLOGIO (sl per 100 posizioni-ora, 10 minuti):")
        for stag in ("legale", "solare"):
            for hh in (0, 60):
                e = esposizione_esatta(inter, hh, hh + 10, "BCM15", stag)
                k = sum(1 for p in rr if p["motivo"] == "sl" and hh <= rel_orologio(p["u"], "BCM15") < hh + 10
                        and (stag == "legale") == usa_legale(p["u"].date()))
                et = "10:00 ET" if (stag == "legale") == (hh == 0) else ("09:00 ET" if stag == "solare" else "11:00 ET")
                print("    USA %-7s %02d:00-%02d:10 BCM (= %s): %3d sl su %6.0f min -> %s" % (
                    stag, 15 + hh // 60, 15 + hh // 60, et, k, e, f2(k / e * 6000) if e else "-"))

    # ---- [6] il lato short
    print("\n[6] I DUE LATI: R251 792520 short 'identico al long' (OOS 2025.07.01 -> 2026.06.29)")
    ds = leggi_deal(PT_SHORT)
    prof, tr = csv_oos(CSV_SHORT, {"InpTP1_ClosePct": "50"})   # la cella 50 = l'ancora
    ok, msg = verifica_file(ds, prof, tr)
    print("  %s -> %s (rif. %d / %s)" % (msg, "OK" if ok else "FALLITO", RIF_SHORT[0], f2(RIF_SHORT[1])))
    ps = posizioni(ds, DEP_SHORT)
    tipi_s = {}
    for p in ps:
        tipi_s[p["tipo"]] = tipi_s.get(p["tipo"], 0) + 1
    sls = [p for p in ps if p["tipo"] == "SL"]
    print("  posizioni %d, tipi %s, lato %s; stop pieni R da %s a %s" % (
        len(ps), dict(sorted(tipi_s.items())), sorted(set(p["lato"] for p in ps)),
        f3(min(p["R"] for p in sls)), f3(max(p["R"] for p in sls))))
    sts = statistica_fuoco([rel10(p["f"]) for p in sls], lambda a, b: esposizione_sedia(ps, a, b))
    print("  fuoco [0,10): %d su %d in [-60,60), p0 %s -> P %s; stop dopo le 10 ET %d su %d" % (
        sts["k"], sts["K"], f3(sts["p0"]), f3(sts["p"]), sum(1 for p in sls if rel10(p["f"]) >= 0), len(sls)))
    print("  a rischio pieno alle 10 ET (primo deal dopo): %d su %d" % (
        sum(1 for p in ps if rel10(p["f"]) >= 0), len(ps)))
    print("\nFine. Nessun EA, preset, taglia o conto toccato.")


# ---------------------------------------------------------------------
#  autotest: i contro-esempi
# ---------------------------------------------------------------------
def sintetiche(seme, n_giorni=400, picco=0.0, rampa_bcm=0.0, ingressi_945=False, base=0.004, fresco=False):
    """Posizioni sintetiche 'esatte' (ingresso e uscita noti), un giorno =
    una posizione aperta alle 09:00 BCM (o alle 10 ET - 15' se ingressi_945),
    rischio di stop ogni minuto fino alle 17:30 BCM:
      hazard = base * (1 + picco se 10:00-10:10 ET) * (1 + rampa_bcm*(h-12)/5.5 se BCM >= 12)."""
    rnd = random.Random(seme)
    pos = []
    d = dt.date(2025, 1, 6)
    while len(pos) < n_giorni:
        if d.weekday() < 5:
            T = t10(d)
            ing = (T - dt.timedelta(minutes=15)) if ingressi_945 and rnd.random() < 0.5 else \
                dt.datetime.combine(d, dt.time(9, 0))
            if fresco and rnd.random() < 0.5:
                ing = T      # ingresso ALLE 10 ET, stop vicino: muore presto per eta', non per ora
            fine = dt.datetime.combine(d, dt.time(17, 30))
            t = ing
            uscita, motivo = fine, "ora"
            while t < fine:
                h = base
                r = (t - T).total_seconds() / 60.0
                if FUOCO[0] <= r < FUOCO[1]:
                    h *= 1.0 + picco
                if fresco and (t - ing).total_seconds() < 600:
                    h *= 10.0
                ore = t.hour + t.minute / 60.0
                if ore >= 12:
                    h *= 1.0 + rampa_bcm * (ore - 12) / 5.5
                if rnd.random() < h:
                    uscita, motivo = t, "sl"
                    break
                t += dt.timedelta(minutes=1)
            pos.append(dict(i=ing, u=uscita, net=-1.0 if motivo == "sl" else 0.0, motivo=motivo))
        d += dt.timedelta(days=1)
    return pos


def p_fuoco_esatto(pos, fuoco=FUOCO, eta=0):
    pos = invecchiate(pos, eta)
    inter = [(p["i"], p["u"]) for p in pos]
    ev = [rel10(p["u"]) for p in pos if p["motivo"] == "sl"]
    return statistica_fuoco(ev, lambda a, b: esposizione_esatta(inter, a, b), fuoco=fuoco)


def autotest():
    esiti = []

    def chk(nome, cond, info=""):
        esiti.append(bool(cond))
        print("  %-4s %s %s" % ("OK" if cond else "FAIL", nome, info))

    print("AUTOTEST ora_10et_770101")
    # T1 orologio
    chk("T1a ora legale USA 2025: 09/03 -> 02/11", usa_legale(dt.date(2025, 3, 10)) and not usa_legale(dt.date(2025, 3, 7))
        and usa_legale(dt.date(2025, 10, 31)) and not usa_legale(dt.date(2025, 11, 3)))
    chk("T1b 2024: fine 03/11; 2026: inizio 08/03", usa_legale(dt.date(2024, 11, 1)) and not usa_legale(dt.date(2024, 11, 4))
        and usa_legale(dt.date(2026, 3, 9)) and not usa_legale(dt.date(2026, 3, 6)))
    chk("T1c 10 ET = 15:00 BCM d'estate, 16:00 d'inverno", t10(dt.date(2025, 7, 15)).hour == 15 and t10(dt.date(2025, 12, 10)).hour == 16)
    chk("T1d settimana SFASATA (12/03/2025: USA legale, UE no) -> 15:00", t10(dt.date(2025, 3, 12)).hour == 15
        and not ue_legale(dt.date(2025, 3, 12)))
    chk("T1e UE: 30/03/2025 -> 26/10/2025", ue_legale(dt.date(2025, 3, 31)) and not ue_legale(dt.date(2025, 3, 28))
        and not ue_legale(dt.date(2025, 10, 27)))
    # T2 l'evento FTMO cade nel fuoco
    ft = evento_ftmo()
    chk("T2 stop FTMO 25/09 17:02:18 FTMO = 15:02:18 BCM = +2,3 min dalle 10 ET", FUOCO[0] <= rel10(ft["u"]) < FUOCO[1],
        "(%+.1f)" % rel10(ft["u"]))
    chk("T2b R dello stop FTMO ~ -1 (rischio 2%)", -1.05 < ft["R"] < -0.97, f3(ft["R"]))
    # T3 classificatore
    base = dict(f=dt.datetime(2025, 7, 1, 9, 30), n=1, R=-1.0)
    chk("T3a un deal a -1R -> SL", tipo_uscita(dict(base, l=dt.datetime(2025, 7, 1, 9, 30))) == "SL")
    chk("T3b un deal alle 17:30 -> ORA (anche se in perdita)", tipo_uscita(dict(base, l=dt.datetime(2025, 7, 1, 17, 30), R=-0.6)) == "ORA")
    chk("T3c due deal -> TP1+", tipo_uscita(dict(base, l=dt.datetime(2025, 7, 1, 11, 0), n=2, R=0.6)) == "TP1+")
    chk("T3d un deal a +0,02 -> TRAIL", tipo_uscita(dict(base, l=dt.datetime(2025, 7, 1, 11, 0), R=0.02)) == "TRAIL")
    # T4 file: verifica, gemelle, e il file manomesso DEVE fallire
    pos = carica_sedia(stampa=False)
    d = leggi_deal(PT % "794611")
    prof, tr = csv_oos(CSV_OOS % ("R246e", "R246e"))
    ok, _ = verifica_file(d, prof, tr)
    chk("T4a R246e: righe e somma = CSV", ok)
    chk("T4b R246e = numeri scritti in REFERTO_R246 (270 / 193 / 18029,58)",
        len(d) == RIF_B[0] and len(posizioni(d, 1e5)) == RIF_B[1] and abs(sum(x["net"] for x in d) - RIF_B[2]) < 0.005)
    da = leggi_deal(PT % "794613")
    chk("T4c R246g = REFERTO_R246 G2 (175 deal, 3789,36)", len(da) == RIF_A[0] and abs(sum(x["net"] for x in da) - RIF_A[1]) < 0.005)
    manom = [dict(x) for x in d]
    manom[5]["net"] += 0.01
    chk("T4d CONTRO-ESEMPIO: +0,01 su un deal -> la verifica FALLISCE", not verifica_file(manom, prof, tr)[0])
    chk("T4e CONTRO-ESEMPIO: gemella manomessa -> NON identica", not gemelle_identiche(d, manom))
    chk("T4f una posizione al giorno, nessuna sovrapposizione", sovrapposte(pos) == 0
        and len(pos) == len(set(p["giorno"] for p in pos)))
    chk("T4g il vuoto del classificatore: nessun R a un deal fra -0,9 e -0,2",
        not any(-0.9 < p["R"] < -0.2 for p in pos if p["n"] == 1 and p["tipo"] != "ORA"))
    chk("T4h solo LONG", set(p["lato"] for p in pos) == {"L"})
    # T5 il test vede un picco VERO legato alle 10 ET
    hit = sum(1 for s in range(20) if p_fuoco_esatto(sintetiche(100 + s, picco=4.0))["p"] < 0.05)
    chk("T5 picco x5 alle 10:00-10:10 ET -> il test lo trova (>=16 su 20)", hit >= 16, "(%d/20)" % hit)
    # T6 rampa pomeridiana liscia in ora BCM, NESSUN picco -> falsi allarmi rari
    fa = sum(1 for s in range(60) if p_fuoco_esatto(sintetiche(300 + s, rampa_bcm=3.0))["p"] < 0.05)
    chk("T6 CONTRO-ESEMPIO 'pomeriggio piu' volatile' (rampa x4 in ora BCM): falsi allarmi <= 10%", fa <= 6, "(%d/60)" % fa)
    # T7 il nullo INGENUO sbaglia dove il GIUSTO no: ingressi ammassati alle 9:45 ET
    fa_g = fa_i = 0
    for s in range(40):
        st = p_fuoco_esatto(sintetiche(500 + s, ingressi_945=True, base=0.002))
        fa_g += st["p"] < 0.05
        fa_i += st["p_ing"] < 0.05
    chk("T7 CONTRO-ESEMPIO: insieme a rischio che SALE alle 9:45 ET, hazard costante -> il nullo di tempo "
        "grida al picco, quello di esposizione no", fa_i >= 3 * max(fa_g, 1) and fa_g <= 4, "(ingenuo %d/40, giusto %d/40)" % (fa_i, fa_g))
    # T8 contro-esempio dell'orologio: picco alle 15:00 BCM TUTTO l'anno (non ET)
    #    -> d'inverno il fuoco ET (16:00 BCM) resta vuoto, la 15:00 BCM no
    rnd_pos = sintetiche(700, n_giorni=600, base=0.003)
    rnd = random.Random(7)
    for p in rnd_pos:
        s15 = dt.datetime.combine(p["i"].date(), dt.time(15, 2))
        if p["u"] > s15 and rnd.random() < 0.25:
            p["u"], p["motivo"] = s15, "sl"
    inv = [p for p in rnd_pos if not usa_legale(p["i"].date())]
    k15 = sum(1 for p in inv if p["motivo"] == "sl" and 0 <= rel_orologio(p["u"], "BCM15") < 10)
    k16 = sum(1 for p in inv if p["motivo"] == "sl" and 60 <= rel_orologio(p["u"], "BCM15") < 70)
    chk("T8 CONTRO-ESEMPIO: effetto d'OROLOGIO BCM (15:00 fisse) -> d'inverno 15:00 BCM >> 16:00 BCM (= 10 ET)",
        k15 >= 5 * max(k16, 1), "(15:00 %d, 16:00 %d)" % (k15, k16))
    # T8b ingresso FRESCO: ingressi ammassati alle 10 ET con stop vicino, nessun
    #     effetto d'ora -> a eta' 0 il test grida, a eta' >= 15' no
    h0 = h15 = 0
    for s in range(30):
        ps = sintetiche(900 + s, fresco=True)
        h0 += p_fuoco_esatto(ps)["p"] < 0.05
        h15 += p_fuoco_esatto(ps, eta=15)["p"] < 0.05
    chk("T8b CONTRO-ESEMPIO 'ingresso fresco': eta' 0 grida al picco, eta' 15' no (<= 10%)",
        h0 >= 20 and h15 <= 3, "(eta' 0: %d/30, eta' 15: %d/30)" % (h0, h15))
    # T9 limiti del controfattuale
    P = lambda f, l, n, R, R1: dict(f=f, l=l, n=n, R=R, R1=R1, giorno=f.date(), tipo="SL" if n == 1 and R < -0.5 else "X")
    g0 = dt.date(2025, 7, 15)
    A = P(dt.datetime(2025, 7, 15, 10, 0), dt.datetime(2025, 7, 15, 10, 0), 1, -1.0, -1.0)
    B = P(dt.datetime(2025, 7, 15, 11, 0), dt.datetime(2025, 7, 15, 16, 0), 2, 1.2, 0.5)
    C = P(dt.datetime(2025, 7, 15, 15, 5), dt.datetime(2025, 7, 15, 15, 5), 1, -1.0, -1.0)
    cf = controfattuale([A, B, C], -5)
    chk("T9 controfattuale: A fissa (-1), B in [0,5;2,0), C in (-1;3) -> [-1,5 ; 4,5]",
        abs(cf["lo"] - (-1.0 + 0.5 - 1.0)) < 1e-9 and abs(cf["hi"] - (-1.0 + 2.0 + 3.0)) < 1e-9 and t10(g0).hour == 15)
    # T10 controllo di mercato: file letto e numeri scritti dal tester
    r1 = leggi_r109()
    chk("T10 R109: 818 posizioni, netto -43.608,40 (intestazione HTML)", len(r1) == RIF_R109[0]
        and abs(sum(p["net"] for p in r1) - RIF_R109[1]) < 0.01)
    # T11 short R251
    ds = leggi_deal(PT_SHORT)
    chk("T11 R251 792520: 243 righe, somma 254,74 (RIEPILOGO_R251)", len(ds) == RIF_SHORT[0]
        and abs(sum(x["net"] for x in ds) - RIF_SHORT[1]) < 0.005)
    pr50 = csv_oos(CSV_SHORT, {"InpTP1_ClosePct": "50"})
    pr0 = csv_oos(CSV_SHORT, {"InpTP1_ClosePct": "0"})
    chk("T11b CONTRO-ESEMPIO: il per-trade torna con la riga ClosePct 50 e NON con la riga 0",
        verifica_file(ds, *pr50)[0] and not verifica_file(ds, *pr0)[0])
    n_ok = sum(esiti)
    print("AUTOTEST: %d/%d %s" % (n_ok, len(esiti), "PASS" if n_ok == len(esiti) else "FAIL"))
    return 0 if n_ok == len(esiti) else 1


if __name__ == "__main__":
    if "--autotest" in sys.argv:
        sys.exit(autotest())
    lettura()
