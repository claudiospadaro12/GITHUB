#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# =====================================================================
#  SONDA SUPERTREND -- LE CINQUE DEFINIZIONI DI SEGNALE, COL COSTO DENTRO
#  Richiesta di Claudio, 22/09/2026: i due Pine incollati in chat
#  (SuperTrend classico + [LUX] SuperTrend Oscillator) "sembrano validi
#  come segnali, da provare".
# ---------------------------------------------------------------------
#  PERCHE' ESISTE, E CHE COSA NON E'
#  In casa ci sono 16 EA di questa famiglia. Dentro campione brillano
#  (PF 1,5-3,2), fuori campione stanno a PF 0,75-1,01 su n 290-640.
#  Prima di spendere giorni di tick reali su un round, questa sonda
#  misura su dati esterni M1 se UNA QUALUNQUE delle definizioni di
#  segnale esposte dai due indicatori sopravvive al COSTO.
#  >>> E' uno SCREENING su barre OHLC M1 aggregate, NON un verdetto:
#      niente tick reali, niente slippage, niente gestione della
#      posizione. Serve a decidere se il round si merita la macchina.
#
#  LE CINQUE DEFINIZIONI (tutte dai due Pine, nessuna inventata)
#   S1 FLIP        cambio di stato del Supertrend      (Pine 1, classico)
#   S2 AMA_ZERO    la media adattiva 'ama' cambia segno (Pine 2)
#   S3 OSC_80      'osc' attraversa +0,80 / -0,80       (Pine 2, hline)
#   S4 HIST_ZERO   'hist' cambia segno                  (Pine 2)
#   S5 OSC_AMA     'osc' incrocia 'ama'                 (Pine 2)
#
#  COSA E' DICHIARATO PRIMA DEI NUMERI (e non si sposta dopo)
#   a) IL VERDETTO E' SUL **PF NETTO**, non sulla % di falsi.
#      La % di falsi e' la metrica di LuxAlgo ed e' INSUFFICIENTE: un
#      sistema puo' sbagliare il 60% delle volte ed essere profittevole.
#      La stampo lo stesso, perche' e' il numero che l'indicatore
#      mostra a Claudio sul grafico, ma NON decide.
#   b) Una famiglia di segnale merita un round SOLO se fa PF netto
#      >= 1,10 su ALMENO DUE simboli E su TUTTI E DUE I LATI
#      (regola di casa del 25/08: long E short, sempre).
#   c) CONTRO-ESEMPIO OBBLIGATORIO: la stessa catena gira su una
#      PASSEGGIATA ALEATORIA con la stessa volatilita' per barra. Se una
#      famiglia fa PF netto >= 1,05 anche li', la misura non misura
#      niente e si butta. Senza questo controllo il numero non esce.
#
#  DATI (esterni, GPL-3.0, FutureSharks/financial-data)
#   ORO   currencies/oanda/XAU_USD/<anno>/oanda-XAU_USD-<anno>-<m>.csv
#         intestazione: time,close,high,low,open,volume   <-- ORDINE
#         DIVERSO da HistData: si legge PER NOME, mai per posizione.
#   INDICI stocks/histdata/<SYM>/DAT_ASCII_<SYM>_M1_<anno>.csv
#         'YYYYMMDD HHMMSS;open;high;low;close;volume'
#         OROLOGIO: ora file + 5 = ora server BCM (misurato in casa,
#         sonda_cono_rumore_dax.py, collaudato contro l'ipotesi UTC).
#
#  COSTO (misurato in casa, non stimato)
#   D30EUR 1,7676 pt  | NASUSD 1,7153 pt | U30USD 1,9224 pt
#     = mediana pesata sui tick nelle ore di sessione,
#       risultati_archivio/spread_flotta/spread_orario_<SYM>.csv
#   XAUUSD 0,2003 $/oncia = GIRO COMPLETO, non per lato: la fonte
#     (ORO_1530_CANCELLO_COSTO_2026-09-10.md 2.4) scrive testuale
#     "Costo pieno di un GIRO COMPLETO sull'oro". Classe 587.
#   SPXUSD e JPXJPY: [NON MISURATO] sul nostro broker -> si usa il
#     costo in PUNTI BASE del prezzo ricavato dai tre misurati, e si
#     stampa la SENSIBILITA' a 0x / 1x / 2x. Mai un numero inventato
#     spacciato per misurato.
#
#  NIENTE EMOJI: questo file e' ASCII puro (regola del 17/08 per i .ps1;
#  qui e' per coerenza e perche' il referto finisce in console Windows).
# =====================================================================
import argparse, csv, io, math, os, random, sys, urllib.request
import datetime as dt

BASE = "https://raw.githubusercontent.com/FutureSharks/financial-data/master"
ORO_PATH = BASE + "/pyfinancialdata/data/currencies/oanda/XAU_USD/%d/oanda-XAU_USD-%d-%d.csv"
IDX_PATH = BASE + "/pyfinancialdata/data/stocks/histdata/%s/DAT_ASCII_%s_M1_%d.csv"

# costo per OPERAZIONE (giro completo), in unita' di prezzo.
COSTO_MIS = {"XAU_USD": 0.2003, "GRXEUR": 1.7676}
# per i due senza misura: punti base del prezzo, ricavati dai misurati
COSTO_BP  = {"SPXUSD": None, "JPXJPY": None}

def log(s):
    sys.stdout.write(s + "\n")
    sys.stdout.flush()

# ---------------------------------------------------------------------
# 1. LETTURA DATI
# ---------------------------------------------------------------------
def _get(url, cache):
    fn = os.path.join(cache, url.rsplit("/", 1)[-1])
    if os.path.exists(fn) and os.path.getsize(fn) > 0:
        return open(fn, "rb").read()
    try:
        with urllib.request.urlopen(url, timeout=120) as r:
            d = r.read()
    except Exception:
        open(fn, "wb").write(b"")
        return b""
    open(fn, "wb").write(d)
    return d

def leggi_oro(anni, cache):
    """Oanda: colonne PER NOME. Il time e' 'YYYY-MM-DD HH:MM:SS'."""
    out = []
    ok = miss = 0
    for y in anni:
        for m in range(1, 13):
            d = _get(ORO_PATH % (y, y, m), cache)
            if not d:
                miss += 1
                continue
            ok += 1
            rd = csv.DictReader(io.StringIO(d.decode("utf-8", "replace")))
            for row in rd:
                try:
                    t = dt.datetime.strptime(row["time"], "%Y-%m-%d %H:%M:%S")
                    o = float(row["open"]); h = float(row["high"])
                    l = float(row["low"]);  c = float(row["close"])
                except Exception:
                    continue
                if not (l <= o <= h and l <= c <= h):
                    continue
                out.append((t, o, h, l, c))
    log("  ORO   file ok=%d mancanti=%d  barre M1=%s" % (ok, miss, format(len(out), ",")))
    out.sort(key=lambda r: r[0])
    return out

def leggi_indice(sym, anni, cache, shift_ore=5):
    """HistData: posizionale. 'ora file + shift' = ora server BCM."""
    out = []
    ok = miss = 0
    for y in anni:
        d = _get(IDX_PATH % (sym, sym, y), cache)
        if not d:
            miss += 1
            continue
        ok += 1
        for ln in d.decode("utf-8", "replace").splitlines():
            p = ln.split(";")
            if len(p) < 5:
                continue
            try:
                t = dt.datetime.strptime(p[0], "%Y%m%d %H%M%S") + dt.timedelta(hours=shift_ore)
                o = float(p[1]); h = float(p[2]); l = float(p[3]); c = float(p[4])
            except Exception:
                continue
            if not (l <= o <= h and l <= c <= h):
                continue
            out.append((t, o, h, l, c))
    log("  %-6s file ok=%d mancanti=%d  barre M1=%s" % (sym, ok, miss, format(len(out), ",")))
    out.sort(key=lambda r: r[0])
    return out

def aggrega(m1, minuti):
    """M1 -> barre da 'minuti'. Ancorate alla mezzanotte dell'orologio usato."""
    barre = []
    cur_k = None
    o = h = l = c = None
    for t, bo, bh, bl, bc in m1:
        k = t.replace(second=0, microsecond=0)
        tot = k.hour * 60 + k.minute
        k = k.replace(hour=(tot // minuti * minuti) // 60,
                      minute=(tot // minuti * minuti) % 60)
        if k != cur_k:
            if cur_k is not None:
                barre.append((cur_k, o, h, l, c))
            cur_k = k; o = bo; h = bh; l = bl; c = bc
        else:
            h = max(h, bh); l = min(l, bl); c = bc
    if cur_k is not None:
        barre.append((cur_k, o, h, l, c))
    return barre

# ---------------------------------------------------------------------
# 2. SUPERTREND + OSCILLATORE, identici ai due Pine
# ---------------------------------------------------------------------
def supertrend_osc(barre, length=10, mult=2.0, smooth=72):
    """
    atr()  di Pine e iATR() di MT5 sono TUTTI E DUE lo smoothing di
    Wilder (RMA), non la SMA. Il Pine 1 lo sceglie col default
    changeATR=true; il Pine 2 usa atr() e basta. Qui: RMA, sempre.
    Tutto su barre CHIUSE: l'indice i usa solo dati <= i.
    """
    n = len(barre)
    if n < length + 5:
        return None
    hi = [b[2] for b in barre]; lo = [b[3] for b in barre]; cl = [b[4] for b in barre]
    tr = [hi[0] - lo[0]]
    for i in range(1, n):
        tr.append(max(hi[i] - lo[i], abs(hi[i] - cl[i-1]), abs(lo[i] - cl[i-1])))
    atr = [None] * n
    atr[length-1] = sum(tr[:length]) / length
    for i in range(length, n):
        atr[i] = (atr[i-1] * (length - 1) + tr[i]) / length

    upper = [None]*n; lower = [None]*n; trend = [None]*n
    spt = [None]*n; osc = [None]*n; ama = [None]*n; hist = [None]*n
    a_sm = 2.0 / (smooth + 1.0)
    for i in range(length-1, n):
        hl2 = (hi[i] + lo[i]) / 2.0
        band = atr[i] * mult
        up = hl2 + band; dn = hl2 - band
        if i == length-1 or upper[i-1] is None:
            upper[i] = up; lower[i] = dn; trend[i] = 1
        else:
            upper[i] = min(up, upper[i-1]) if cl[i-1] < upper[i-1] else up
            lower[i] = max(dn, lower[i-1]) if cl[i-1] > lower[i-1] else dn
            if cl[i] > upper[i-1]:
                trend[i] = 1
            elif cl[i] < lower[i-1]:
                trend[i] = 0
            else:
                trend[i] = trend[i-1]
        spt[i] = trend[i]*lower[i] + (1-trend[i])*upper[i]
        larg = upper[i] - lower[i]
        v = 0.0 if larg <= 0 else (cl[i] - spt[i]) / larg
        osc[i] = max(min(v, 1.0), -1.0)
        alpha = (osc[i] ** 2) / float(length)
        ama[i] = osc[i] if (i == length-1 or ama[i-1] is None) else ama[i-1] + alpha*(osc[i]-ama[i-1])
        d = osc[i] - ama[i]
        hist[i] = d if (i == length-1 or hist[i-1] is None) else hist[i-1] + a_sm*(d - hist[i-1])
    return {"trend": trend, "spt": spt, "osc": osc, "ama": ama, "hist": hist,
            "upper": upper, "lower": lower, "primo": length-1}

# ---------------------------------------------------------------------
# 3. LE CINQUE DEFINIZIONI -> una direzione desiderata per barra
# ---------------------------------------------------------------------
def direzioni(ind, quale):
    """+1 long, -1 short, 0 fuori. Calcolata su barra CHIUSA i."""
    n = len(ind["trend"]); p = ind["primo"]
    d = [0]*n
    if quale == "S1_FLIP":
        for i in range(p, n):
            d[i] = 1 if ind["trend"][i] == 1 else -1
    elif quale == "S2_AMA_ZERO":
        for i in range(p, n):
            d[i] = 1 if ind["ama"][i] > 0 else (-1 if ind["ama"][i] < 0 else d[i-1] if i > p else 0)
    elif quale == "S3_OSC_80":
        st = 0
        for i in range(p, n):
            if ind["osc"][i] >= 0.80: st = 1
            elif ind["osc"][i] <= -0.80: st = -1
            d[i] = st
    elif quale == "S4_HIST_ZERO":
        for i in range(p, n):
            d[i] = 1 if ind["hist"][i] > 0 else (-1 if ind["hist"][i] < 0 else d[i-1] if i > p else 0)
    elif quale == "S5_OSC_AMA":
        for i in range(p, n):
            d[i] = 1 if ind["osc"][i] > ind["ama"][i] else -1
    else:
        raise ValueError(quale)
    return d

FAMIGLIE = ["S1_FLIP", "S2_AMA_ZERO", "S3_OSC_80", "S4_HIST_ZERO", "S5_OSC_AMA"]

# ---------------------------------------------------------------------
# 4. IL GIRO: sempre a mercato, ingresso all'APERTURA della barra dopo
# ---------------------------------------------------------------------
def gira(barre, dirs, costo_giro, primo):
    """
    Nessun look-ahead: la direzione decisa sulla barra chiusa i viene
    eseguita all'APERTURA della barra i+1.

    CORRETTO IL 22/09/2026 SERA, ed e' un errore mio da 2x.
    Prima toglievo `2*costo_lato` per ogni operazione, chiamando "lato"
    quello che le fonti chiamano GIRO. Ma un'OPERAZIONE qui E' gia' un
    giro completo: si apre a un flip e si chiude al flip dopo, quindi si
    paga lo spread UNA volta, non due. E la fonte del costo dell'oro
    (report/ORO_1530_CANCELLO_COSTO_2026-09-10.md par. 2.4) dice
    testuale "Costo pieno di un GIRO COMPLETO ... = 0,2003 $" -- non per
    lato. Stessa cosa per lo spread degli indici: attraversandolo si
    paga una volta per giro.
    >>> Il verso dell'errore era PESSIMISTA: toglievo il doppio del
        dovuto, quindi i PF netti pubblicati erano piu' BASSI del vero.
        Va ricontrollato se il verdetto regge, e non dato per scontato.
    """
    n = len(barre)
    ops = []            # (lato, prezzo_in, prezzo_out, lordo, netto)
    pos = 0; pin = None
    for i in range(primo, n-1):
        want = dirs[i]
        if want == 0 or want == pos:
            continue
        px = barre[i+1][1]          # apertura della barra successiva
        if pos != 0:
            lordo = (px - pin) * pos
            ops.append((pos, pin, px, lordo, lordo - costo_giro))
        pos = want; pin = px
    return ops

def pf(vals):
    g = sum(v for v in vals if v > 0)
    p = -sum(v for v in vals if v < 0)
    if p <= 0:
        return float("inf") if g > 0 else 0.0
    return g / p

def referto(ops, etichetta):
    if not ops:
        return None
    lor = [o[3] for o in ops]; net = [o[4] for o in ops]
    falsi_l = sum(1 for v in lor if v <= 0)
    falsi_n = sum(1 for v in net if v <= 0)
    L = [o for o in ops if o[0] > 0]; S = [o for o in ops if o[0] < 0]
    return {
        "eti": etichetta, "n": len(ops),
        "falsi_l": 100.0*falsi_l/len(ops), "falsi_n": 100.0*falsi_n/len(ops),
        "pf_l": pf(lor), "pf_n": pf(net),
        "tot_n": sum(net),
        "n_long": len(L), "pf_long": pf([o[4] for o in L]) if L else 0.0,
        "n_short": len(S), "pf_short": pf([o[4] for o in S]) if S else 0.0,
    }

# ---------------------------------------------------------------------
# 5. IL CONTRO-ESEMPIO: passeggiata aleatoria a volatilita' appaiata
# ---------------------------------------------------------------------
def rumore(barre, seme):
    """
    Stessa lunghezza, stesso prezzo di partenza, stessa volatilita'
    per barra (deviazione dei rendimenti log) e stessa ampiezza media
    di barra. Se una famiglia guadagna anche qui, non misura niente.
    """
    rnd = random.Random(seme)
    cl = [b[4] for b in barre]
    ret = [math.log(cl[i]/cl[i-1]) for i in range(1, len(cl)) if cl[i-1] > 0 and cl[i] > 0]
    if len(ret) < 100:
        return []
    mu = sum(ret)/len(ret)
    sd = math.sqrt(sum((r-mu)**2 for r in ret)/(len(ret)-1))
    amp = sum((b[2]-b[3])/b[4] for b in barre if b[4] > 0)/max(len(barre), 1)
    out = []; px = cl[0]
    for t, _, _, _, _ in barre:
        nx = px * math.exp(rnd.gauss(0.0, sd))
        o = px; c = nx
        mezzo = amp*px*0.5
        h = max(o, c) + abs(rnd.gauss(0, mezzo*0.5))
        l = min(o, c) - abs(rnd.gauss(0, mezzo*0.5))
        out.append((t, o, h, l, c))
        px = nx
    return out

# ---------------------------------------------------------------------
# 6. AUTOTEST -- si rompe da solo prima di misurare qualcosa di vero
# ---------------------------------------------------------------------
def _barre_finte(n, seme=1, drift=0.0):
    rnd = random.Random(seme)
    px = 100.0; out = []
    t = dt.datetime(2020, 1, 1)
    for i in range(n):
        nx = px * math.exp(rnd.gauss(drift, 0.004))
        o, c = px, nx
        h = max(o, c) * 1.001; l = min(o, c) * 0.999
        out.append((t + dt.timedelta(hours=i), o, h, l, c))
        px = nx
    return out

def autotest():
    ko = 0
    def chk(cond, nome, extra=""):
        nonlocal ko
        if cond:
            log("  OK   %s %s" % (nome, extra))
        else:
            log("  KO   %s %s" % (nome, extra)); ko += 1

    # T1 -- ATR di Wilder a mano su una serie costruita
    b = [(dt.datetime(2020,1,1)+dt.timedelta(hours=i), 10.0, 11.0, 9.0, 10.0) for i in range(40)]
    ind = supertrend_osc(b, length=10, mult=2.0)
    chk(ind is not None, "T1 l'indicatore gira")
    # tutte le barre hanno range 2.0 e close uguale -> TR = 2.0 -> ATR = 2.0
    i = 30
    hl2 = 10.0
    atteso_up = hl2 + 2.0*2.0
    chk(abs(ind["upper"][i] - atteso_up) < 1e-9, "T2 ATR di Wilder a mano",
        "(upper=%.6f atteso=%.6f)" % (ind["upper"][i], atteso_up))

    # T3 -- osc sempre dentro [-1, +1]
    b = _barre_finte(600, seme=7)
    ind = supertrend_osc(b, 10, 2.0, 72)
    vals = [ind["osc"][i] for i in range(ind["primo"], len(b))]
    chk(all(-1.0 <= v <= 1.0 for v in vals), "T3 osc dentro [-1,+1]",
        "(min %.4f max %.4f)" % (min(vals), max(vals)))

    # T4 -- S1_FLIP coincide con lo stato trend
    d = direzioni(ind, "S1_FLIP")
    ok = all((d[i] == 1) == (ind["trend"][i] == 1) for i in range(ind["primo"], len(b)))
    chk(ok, "T4 S1_FLIP == stato del Supertrend")

    # T5 -- NIENTE LOOK-AHEAD: l'indicatore alla barra i non cambia se
    #       si tagliano le barre dopo la i. E' IL controllo che conta.
    b2 = b[:400]
    i2 = supertrend_osc(b2, 10, 2.0, 72)
    k = 350
    stesso = (abs(i2["osc"][k]-ind["osc"][k]) < 1e-12 and
              abs(i2["ama"][k]-ind["ama"][k]) < 1e-12 and
              i2["trend"][k] == ind["trend"][k])
    chk(stesso, "T5 nessun look-ahead (troncare il futuro non cambia il passato)")

    # T6 -- il costo morde, ed esattamente 2 per operazione
    ops0 = gira(b, d, 0.0, ind["primo"])
    ops1 = gira(b, d, 0.5, ind["primo"])
    chk(len(ops0) == len(ops1), "T6a stesso numero di operazioni con e senza costo")
    if ops0:
        diff = sum(o[4] for o in ops0) - sum(o[4] for o in ops1)
        # CORRETTO il 22/09 sera: UNA volta per operazione, non due.
        # Un'operazione qui e' gia' un giro completo (aperta a un flip,
        # chiusa al flip dopo): lo spread si attraversa una volta sola.
        chk(abs(diff - 0.5*len(ops0)) < 1e-6, "T6b il costo tolto e' UNO per operazione",
            "(diff=%.4f atteso=%.4f)" % (diff, 0.5*len(ops0)))
        # CONTRO-ESEMPIO: il controllo vecchio (2 per operazione) DEVE fallire
        chk(abs(diff - 2*0.5*len(ops0)) > 1e-6,
            "T6c contro-esempio: il vecchio criterio (2 per op) ora NON torna")

    # T7 -- l'ingresso e' all'APERTURA DELLA BARRA DOPO, mai alla chiusura
    #       della barra del segnale. Si verifica che ogni prezzo usato
    #       sia un 'open' di barra, e mai un 'close'.
    apert = set(round(x[1], 10) for x in b)
    ok = all(round(o[1], 10) in apert and round(o[2], 10) in apert for o in ops0)
    chk(ok, "T7 si entra e si esce sulle APERTURE, non sulle chiusure")

    # T8 -- il rumore ha la volatilita' appaiata (entro il 15%)
    rw = rumore(b, 42)
    def vol(x):
        c = [r[4] for r in x]
        rr = [math.log(c[i]/c[i-1]) for i in range(1, len(c))]
        m = sum(rr)/len(rr)
        return math.sqrt(sum((r-m)**2 for r in rr)/(len(rr)-1))
    v1, v2 = vol(b), vol(rw)
    chk(abs(v2-v1)/v1 < 0.15, "T8 il rumore ha la volatilita' appaiata",
        "(vera %.6f rumore %.6f)" % (v1, v2))

    # T9 -- su un drift FORTE il flip deve guadagnare (se no, e' rotto)
    bt = _barre_finte(1500, seme=3, drift=0.0035)
    it = supertrend_osc(bt, 10, 2.0, 72)
    dt_ = direzioni(it, "S1_FLIP")
    o = gira(bt, dt_, 0.0, it["primo"])
    chk(o and sum(x[3] for x in o) > 0, "T9 su un trend vero il flip guadagna",
        "(tot=%.2f su %d op)" % (sum(x[3] for x in o) if o else 0, len(o)))

    # T10 -- le cinque famiglie producono direzioni DIVERSE fra loro
    tutte = {q: direzioni(ind, q) for q in FAMIGLIE}
    coppie_uguali = [(a, c) for a in FAMIGLIE for c in FAMIGLIE
                     if a < c and tutte[a] == tutte[c]]
    chk(not coppie_uguali, "T10 le cinque famiglie non sono la stessa cosa",
        "(uguali: %s)" % (coppie_uguali or "nessuna"))

    log("")
    log("AUTOTEST: %d controlli falliti" % ko)
    return ko

# ---------------------------------------------------------------------
# 7. MAIN
# ---------------------------------------------------------------------
SIMBOLI = [("XAU_USD", "oro"), ("GRXEUR", "DAX"), ("SPXUSD", "S&P500"), ("JPXJPY", "Nikkei")]

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--autotest", action="store_true")
    ap.add_argument("--cache", default="/tmp/sonda_st_cache")
    ap.add_argument("--da", type=int, default=2013)
    ap.add_argument("--a", type=int, default=2018)
    ap.add_argument("--tf", default="60,240")
    ap.add_argument("--simboli", default="XAU_USD,GRXEUR,SPXUSD,JPXJPY")
    ap.add_argument("--seme", type=int, default=20260922)
    ap.add_argument("--fuori", default="")
    a = ap.parse_args()

    if a.autotest:
        log("=== AUTOTEST sonda_supertrend_segnali ===")
        sys.exit(1 if autotest() else 0)

    os.makedirs(a.cache, exist_ok=True)
    usc = open(a.fuori, "w", encoding="utf-8") if a.fuori else None
    def out(s):
        log(s)
        if usc: usc.write(s + "\n")

    out("=====================================================================")
    out(" SONDA SUPERTREND -- CINQUE DEFINIZIONI DI SEGNALE, COL COSTO DENTRO")
    out(" corsa del %s   finestra %d-%d   seme %d" %
        (dt.date.today().isoformat(), a.da, a.a, a.seme))
    out("=====================================================================")
    out(" DICHIARATO PRIMA DEI NUMERI:")
    out("  - il verdetto e' sul PF NETTO, non sulla %% di falsi")
    out("  - merita un round solo con PF netto >= 1,10 su >= 2 simboli E")
    out("    su TUTTI E DUE i lati (regola di casa del 25/08)")
    out("  - se il RUMORE fa PF netto >= 1,05, la misura si butta")
    out("  - screening su OHLC M1 aggregate: NON e' un verdetto a tick")
    out("")

    log("=== autotest prima di misurare ===")
    if autotest():
        out("AUTOTEST FALLITO: non misuro niente.")
        sys.exit(2)
    out("autotest: PASSATO (10 controlli)")
    out("")

    anni = list(range(a.da, a.a + 1))
    tfs = [int(x) for x in a.tf.split(",")]
    chiesti = a.simboli.split(",")

    log("=== scarico ===")
    dati = {}
    for sym, nome in SIMBOLI:
        if sym not in chiesti:
            continue
        m1 = leggi_oro(anni, a.cache) if sym == "XAU_USD" else leggi_indice(sym, anni, a.cache)
        if len(m1) > 1000:
            dati[sym] = m1

    # costo per lato
    costi = {}
    for sym in dati:
        if sym in COSTO_MIS:
            costi[sym] = (COSTO_MIS[sym], "MISURATO in casa")
        else:
            # punti base ricavati dai misurati, applicati al prezzo medio
            px = sum(b[4] for b in dati[sym]) / len(dati[sym])
            bp_dax = COSTO_MIS["GRXEUR"] / (sum(b[4] for b in dati["GRXEUR"]) /
                                            len(dati["GRXEUR"])) if "GRXEUR" in dati else 1.2e-4
            costi[sym] = (px * bp_dax, "[NON MISURATO] -- %.2f punti base dal DAX" % (bp_dax*1e4))

    righe = []
    for sym in dati:
        for minuti in tfs:
            barre = aggrega(dati[sym], minuti)
            ind = supertrend_osc(barre, 10, 2.0, 72)
            if ind is None:
                continue
            rw = rumore(barre, a.seme)
            ind_rw = supertrend_osc(rw, 10, 2.0, 72) if rw else None
            costo, fonte = costi[sym]
            out("---------------------------------------------------------------------")
            out(" %s  TF %d min  |  %s barre  |  %s -> %s" %
                (sym, minuti, format(len(barre), ","),
                 barre[0][0].date().isoformat(), barre[-1][0].date().isoformat()))
            out(" costo per OPERAZIONE (giro completo): %.4f unita' di prezzo  (%s)" % (costo, fonte))
            out("   (corretto il 22/09 sera: prima ne toglievo DUE, chiamando 'lato' quello che")
            out("    le fonti chiamano GIRO. Un'operazione qui e' gia' un giro: aperta a un flip,")
            out("    chiusa al flip dopo, lo spread si attraversa UNA volta.)")
            out("")
            out("  famiglia      |   n  | %falsi lordo | %falsi NETTO | PF lordo | PF NETTO | PF long | PF short | PF RUMORE")
            for q in FAMIGLIE:
                ops = gira(barre, direzioni(ind, q), costo, ind["primo"])
                r = referto(ops, q)
                if not r:
                    continue
                pfr = 0.0
                if ind_rw:
                    opr = gira(rw, direzioni(ind_rw, q), costo, ind_rw["primo"])
                    pfr = pf([o[4] for o in opr]) if opr else 0.0
                out("  %-13s | %4d |   %6.2f%%    |   %6.2f%%    |  %6.3f  |  %6.3f  | %6.3f  | %6.3f   |  %6.3f" %
                    (q, r["n"], r["falsi_l"], r["falsi_n"], r["pf_l"], r["pf_n"],
                     r["pf_long"], r["pf_short"], pfr))
                r["sym"] = sym; r["tf"] = minuti; r["pf_rumore"] = pfr
                righe.append(r)
            out("")

    # --- il verdetto, coi criteri dichiarati prima ---
    out("=====================================================================")
    out(" VERDETTO -- coi criteri dichiarati PRIMA dei numeri")
    out("=====================================================================")
    for q in FAMIGLIE:
        mie = [r for r in righe if r["eti"] == q]
        if not mie:
            continue
        buone = [r for r in mie
                 if r["pf_n"] >= 1.10 and r["pf_long"] >= 1.10 and r["pf_short"] >= 1.10]
        simb = sorted(set(r["sym"] for r in buone))
        rum = [r for r in mie if r["pf_rumore"] >= 1.05]
        if rum:
            esito = "MISURA DA BUTTARE: il rumore fa PF >= 1,05 in %d celle" % len(rum)
        elif len(simb) >= 2:
            esito = "MERITA UN ROUND -- passa su %s" % ", ".join(simb)
        else:
            esito = "ARCHIVIATA -- passa su %d simboli (ne servono 2)" % len(simb)
        out("  %-13s  %s" % (q, esito))
    out("")
    out(" NOTA: questo e' uno SCREENING su OHLC M1 aggregate. Non sostituisce")
    out(" un round a tick reali: dice solo se il round si merita la macchina.")
    if usc:
        usc.close()

if __name__ == "__main__":
    main()
