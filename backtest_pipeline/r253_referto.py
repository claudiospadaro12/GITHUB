#!/usr/bin/env python3
"""
r253_referto.py - la LETTURA di R253 (gap-down short DAX, ricerca) dai per-trade,
secondo il file di testa prove/R253a_gapcont_DAX_short_ora8.txt par. 4 e 6
(criteri congelati PRIMA dei numeri, PASS del cancello su abc1d9ed).

Cosa calcola (tutto dai per-trade dell'archivio, niente a memoria):
  - curva IN FASE = posizioni d'ESTATE del file a (ora 8) + posizioni d'INVERNO
    del file b (ora 9), per data di chiusura; inverno semiaperto
    2024.10.27 <= d < 2025.03.30 e 2025.10.26 <= d < 2026.03.29; le quattro
    sedute di confine (classe 805) escluse e riportate a parte;
  - metodo A (ribasato: r = net / saldo della SUA corsa prima della posizione,
    curva che riparte da 10000) e metodo B (denaro);
  - per la curva in fase e per le due gambe intere: posizioni, deal, Profit,
    PF per posizione e sui deal, EP per posizione, DD a saldo chiuso (EUR e %),
    peggior giornata a saldo chiuso, serie perdente piu' lunga;
  - K1: stop mediano delle uscite a stop pieno (posizioni con UN solo deal in
    perdita), |net|/volume a 1 EUR/pt/lotto; il valore del punto e' MISURATO
    dal per-trade (posizioni a due deal, ingresso eliminato: due equazioni, due incognite);
  - R1 DD <= 6,5% / R2 peggior giornata >= -1,10% / R3 serie <= 8, verdetto
    ASIMMETRICO (classe 804): ROSSO boccia a qualunque n, VERDE = "NON VIOLATO
    su n = X" con la probabilita' che un motore senza edge lo passi;
  - MERITO: sospeso; solo il SEGNO dell'EP per posizione in fase contro CE9
    (+0,230 R) e il P/L nella finestra del crollo 2025.03.31-2025.05.09;
  - k = DD_fisso del CSV _OOS (Profit / Recovery Factor) / DD_chiuso del
    per-trade, per gamba;
  - O1: quota delle giornate in fase con posizione di questo motore in cui
    770411 (per-trade R246: 794623 per d <= 2025.06.09, 794621 per d >=
    2025.06.10, per data di chiusura) ha una posizione lo stesso giorno;
  - O2: NON MISURABILE (per-trade R252 non in archivio).

Uso: python3 backtest_pipeline/r253_referto.py [--autotest]
"""
import sys, csv, os, argparse, statistics as st
from datetime import datetime, date
from collections import OrderedDict

ARCH = "backtest_pipeline/risultati_archivio"
PT_A = f"{ARCH}/R253/PERTRADE/abtg_trades_ABTG_GapContinuation_D30EUR_792701.csv"
PT_A2 = f"{ARCH}/R253/PERTRADE/abtg_trades_ABTG_GapContinuation_D30EUR_792751.csv"
PT_B = f"{ARCH}/R253/PERTRADE/abtg_trades_ABTG_GapContinuation_D30EUR_792702.csv"
PT_B2 = f"{ARCH}/R253/PERTRADE/abtg_trades_ABTG_GapContinuation_D30EUR_792752.csv"
OOS_A = f"{ARCH}/R253/ROUND_R253a/ABTG_GapContinuation_D30EUR_OOS_R253a.csv"
OOS_B = f"{ARCH}/R253/ROUND_R253b/ABTG_GapContinuation_D30EUR_OOS_R253b.csv"
PT_411_A = f"{ARCH}/R246/PERTRADE/abtg_trades_ABTG_MaxMinNotte_DAX_Short_Ottimizzato_D30EUR_794623.csv"   # finestra A, d <= 2025.06.09
PT_411_B = f"{ARCH}/R246/PERTRADE/abtg_trades_ABTG_MaxMinNotte_DAX_Short_Ottimizzato_D30EUR_794621.csv"   # finestra B, d >= 2025.06.10
CUCITURA = date(2025, 6, 10)

DEPOSITO = 10000.0
INVERNI = [(date(2024, 10, 27), date(2025, 3, 30)), (date(2025, 10, 26), date(2026, 3, 29))]   # semiaperti [a, b)
CONFINE_A = {date(2025, 3, 31), date(2026, 3, 30)}     # file a
CONFINE_B = {date(2024, 10, 28), date(2025, 10, 27)}   # file b
CROLLO = (date(2025, 3, 31), date(2025, 5, 9))
K1_OK, K1_MIN = 68.0, 22.6
R1_MAX, R2_MIN, R3_MAX = 6.5, -1.10, 8
CE9_EP_R = 0.230
# probabilita' che un motore SENZA edge passi R1 (e R3) a n posizioni (testa par. 6, seme 801)
P_NOEDGE = {10: 0.95, 20: 0.73, 30: 0.54, 40: 0.40}

def inverno(d):
    return any(a <= d < b for a, b in INVERNI)

def leggi_pertrade(path):
    deals = []
    with open(path, encoding="utf-8", errors="replace") as f:
        for r in csv.DictReader(f, delimiter=";"):
            deals.append({"t": datetime.strptime(r["close_time"], "%Y.%m.%d %H:%M:%S"), "pid": int(r["position_id"]),
                          "type": int(r["deal_type"]), "vol": float(r["volume"]), "price": float(r["price"]), "net": float(r["net_profit"])})
    deals.sort(key=lambda d: (d["t"], d["pid"]))
    return deals

def posizioni(deals):
    """raggruppa per position_id DENTRO la corsa; ordine per primo deal"""
    pos = OrderedDict()
    for d in deals:
        pos.setdefault(d["pid"], []).append(d)
    out = []
    for pid, ds in pos.items():
        out.append({"pid": pid, "deals": ds, "t0": ds[0]["t"], "t1": ds[-1]["t"], "net": sum(x["net"] for x in ds),
                    "vol": sum(x["vol"] for x in ds), "data": ds[-1]["t"].date()})
    out.sort(key=lambda p: p["t0"])
    return out

def ribasa(pos_corsa):
    """metodo A: per ogni posizione della corsa, saldo della corsa prima del suo primo deal e r per deal"""
    saldo = DEPOSITO
    # i deal della corsa in ordine di tempo: saldo prima del primo deal della posizione
    tutti = sorted((d for p in pos_corsa for d in p["deals"]), key=lambda d: d["t"])
    for p in pos_corsa:
        b = DEPOSITO + sum(d["net"] for d in tutti if d["t"] < p["t0"])
        p["B_corsa"] = b
        p["r"] = p["net"] / b
        p["r_deals"] = [d["net"] / b for d in p["deals"]]
    return pos_corsa

def curva(pos, metodo):
    """statistiche a saldo chiuso su una lista di posizioni (gia' ribasate se metodo A)"""
    saldo = DEPOSITO; picco = DEPOSITO; dd = 0.0; dd_pct = 0.0
    giorni = {}
    serie = 0; serie_max = 0
    profit = 0.0; gain = 0.0; loss = 0.0; gain_d = 0.0; loss_d = 0.0
    eq = []
    for p in pos:
        prima = saldo
        if metodo == "A":
            nets = [r * prima for r in p["r_deals"]]
        else:
            nets = [d["net"] for d in p["deals"]]
        pnet = sum(nets)
        p["net_curva"] = pnet
        for n in nets:
            saldo += n
            picco = max(picco, saldo)
            dd = min(dd, saldo - picco); dd_pct = min(dd_pct, (saldo - picco) / DEPOSITO * 100.0)
            if n > 0: gain_d += n
            else: loss_d += -n
        eq.append((p["t1"], saldo))
        profit += pnet
        if pnet > 0: gain += pnet
        elif pnet < 0: loss += -pnet
        giorni[p["data"]] = giorni.get(p["data"], 0.0) + pnet
        if pnet < 0: serie += 1; serie_max = max(serie_max, serie)
        else: serie = 0
    n = len(pos)
    pegg = min(giorni.values()) if giorni else 0.0
    return {"n": n, "deal": sum(len(p["deals"]) for p in pos), "profit": profit,
            "pf_pos": (gain / loss if loss > 0 else float("inf")), "pf_deal": (gain_d / loss_d if loss_d > 0 else float("inf")),
            "ep": (profit / n if n else 0.0), "dd_eur": -dd, "dd_pct": -dd_pct, "pegg_eur": pegg, "pegg_pct": pegg / DEPOSITO * 100.0,
            "serie": serie_max, "vinte": sum(1 for p in pos if p["net_curva"] > 0), "eq": eq}

def k1_stop(pos):
    """stop mediano delle uscite a stop pieno: posizioni con UN deal in perdita; |net|/vol a 1 EUR/pt/lotto"""
    stops = [abs(p["net"]) / p["vol"] for p in pos if len(p["deals"]) == 1 and p["net"] < 0 and p["vol"] > 0]
    return (st.median(stops) if stops else None), len(stops), (min(stops) if stops else None), (max(stops) if stops else None)

def valore_punto(pos):
    """EUR per punto per lotto MISURATO senza assumerlo e senza assumere dove sta l'ingresso:
    una posizione con DUE deal di uscita ha un solo ingresso E; per uno SHORT net_i = vol_i x (E - price_i) x V
    (per un LONG x (price_i - E)). Due equazioni, due incognite: V = s x (net_1/vol_1 - net_2/vol_2) / (price_2 - price_1),
    s = +1 short / -1 long. Vale per parziale + pari (anche con slittamento del pari) e per parziale + 2R;
    una commissione per lotto uguale sui due deal si cancella nella differenza."""
    v = []
    for p in pos:
        if len(p["deals"]) != 2: continue
        d1, d2 = p["deals"]
        dp = d2["price"] - d1["price"]
        if d1["type"] != d2["type"] or dp == 0 or d1["vol"] <= 0 or d2["vol"] <= 0: continue
        s = 1.0 if d1["type"] == 0 else -1.0   # deal_type 0 = BUY che chiude uno SHORT
        v.append(s * (d1["net"] / d1["vol"] - d2["net"] / d2["vol"]) / dp)
    return v

def dd_fisso_csv(path):
    with open(path) as f:
        rows = list(csv.DictReader(f))
    r = rows[0]
    profit = float(r["Profit"]); rf = float(r["Recovery Factor"])
    return (abs(profit / rf) if rf != 0 else None), profit, float(r["Equity DD %"]), int(r["Trades"]), float(r["Profit Factor"]), float(r["Peggior Giornata %"])

def p_noedge(n):
    ks = sorted(P_NOEDGE)
    if n <= ks[0]: return P_NOEDGE[ks[0]]
    if n >= ks[-1]: return P_NOEDGE[ks[-1]]
    for a, b in zip(ks, ks[1:]):
        if a <= n <= b:
            return P_NOEDGE[a] + (P_NOEDGE[b] - P_NOEDGE[a]) * (n - a) / (b - a)

def giorni_770411():
    g = set()
    for path, cond in ((PT_411_A, lambda d: d < CUCITURA), (PT_411_B, lambda d: d >= CUCITURA)):
        if not os.path.exists(path): return None
        for d in leggi_pertrade(path):
            dd = d["t"].date()
            if cond(dd): g.add(dd)
    return g

def analizza(pa, pb, verbose=True):
    """pa, pb = posizioni delle due corse (gia' ordinate)"""
    ribasa(pa); ribasa(pb)
    conf_a = [p for p in pa if p["data"] in CONFINE_A]
    conf_b = [p for p in pb if p["data"] in CONFINE_B]
    fase = [p for p in pa if not inverno(p["data"]) and p["data"] not in CONFINE_A] + \
           [p for p in pb if inverno(p["data"]) and p["data"] not in CONFINE_B]
    fase.sort(key=lambda p: p["t0"])
    fuori = [p for p in pa if inverno(p["data"])] + [p for p in pb if not inverno(p["data"])]
    out = {}
    out["fase_A"] = curva(fase, "A")
    out["fase_B"] = curva(fase, "B")
    out["a_int_B"] = curva(list(pa), "B")
    out["b_int_B"] = curva(list(pb), "B")
    out["fase_estate"] = curva([p for p in fase if not inverno(p["data"])], "B")
    out["fase_inverno"] = curva([p for p in fase if inverno(p["data"])], "B")
    out["n_fuori"] = len(fuori)
    out["confine"] = (len(conf_a), len(conf_b))
    # scarto di saldo massimo fra corsa e curva in fase (metodo A)
    saldo = DEPOSITO; scarti = []
    for p in fase:
        scarti.append(abs(p["B_corsa"] / saldo - 1.0))
        saldo += p["net_curva"] if "net_curva" in p else 0.0
    # net_curva e' quello dell'ULTIMA curva calcolata (fase_inverno/estate su B!): ricalcolo A per lo scarto
    curva(fase, "A"); saldo = DEPOSITO; scarti = []
    for p in fase:
        scarti.append(abs(p["B_corsa"] / saldo - 1.0)); saldo += p["net_curva"]
    out["scarto_max"] = max(scarti) if scarti else 0.0
    # K1 sulla curva in fase
    out["k1"] = k1_stop(fase)
    # EP in R (metodo A): r della posizione / 1%
    rs = [p["r"] / 0.01 for p in fase]
    out["ep_R"] = st.mean(rs) if rs else 0.0
    out["ep_R_med"] = st.median(rs) if rs else 0.0
    # crollo
    cr = [p for p in fase if CROLLO[0] <= p["data"] <= CROLLO[1]]
    out["crollo"] = (len(cr), sum(p["net"] for p in cr), sum(p["r"] / 0.01 for p in cr))
    # per anno (in fase, denaro)
    anni = {}
    for p in fase: anni.setdefault(p["data"].year, [0, 0.0]); anni[p["data"].year][0] += 1; anni[p["data"].year][1] += p["net"]
    out["anni"] = anni
    # O1
    g411 = giorni_770411()
    gf = sorted({p["data"] for p in fase})
    out["o1"] = (None if g411 is None else (sum(1 for d in gf if d in g411), len(gf)))
    out["fase"] = fase
    return out

def referto():
    pa = posizioni(leggi_pertrade(PT_A)); pb = posizioni(leggi_pertrade(PT_B))
    # G1 sui per-trade delle gemelle (righe identiche tranne il magic)
    for x, y in ((PT_A, PT_A2), (PT_B, PT_B2)):
        d1 = [(d["t"], d["pid"], d["vol"], d["price"], d["net"]) for d in leggi_pertrade(x)]
        d2 = [(d["t"], d["pid"], d["vol"], d["price"], d["net"]) for d in leggi_pertrade(y)]
        assert d1 == d2, f"G1: {x} e {y} diversi"
    o = analizza(pa, pb)
    L = []
    L.append("R253 - LETTURA DAI PER-TRADE (criteri: testa par. 4 e 6)")
    L.append(f"gamba intera a (ora 8): {o['a_int_B']['n']} posizioni, {o['a_int_B']['deal']} deal, Profit {o['a_int_B']['profit']:+.2f}, PF pos {o['a_int_B']['pf_pos']:.3f} / deal {o['a_int_B']['pf_deal']:.3f}, DD chiuso {o['a_int_B']['dd_eur']:.2f} EUR = {o['a_int_B']['dd_pct']:.2f}%, pegg. giorno {o['a_int_B']['pegg_pct']:+.2f}%, serie {o['a_int_B']['serie']}")
    L.append(f"gamba intera b (ora 9): {o['b_int_B']['n']} posizioni, {o['b_int_B']['deal']} deal, Profit {o['b_int_B']['profit']:+.2f}, PF pos {o['b_int_B']['pf_pos']:.3f} / deal {o['b_int_B']['pf_deal']:.3f}, DD chiuso {o['b_int_B']['dd_eur']:.2f} EUR = {o['b_int_B']['dd_pct']:.2f}%, pegg. giorno {o['b_int_B']['pegg_pct']:+.2f}%, serie {o['b_int_B']['serie']}")
    for lab, path in (("a", OOS_A), ("b", OOS_B)):
        ddf, profit, eqdd, trades, pf, pegg = dd_fisso_csv(path)
        ddc = o["a_int_B"]["dd_eur"] if lab == "a" else o["b_int_B"]["dd_eur"]
        L.append(f"  CSV _OOS {lab}: Trades {trades} Profit {profit:+.2f} PF {pf:.5f} EqDD {eqdd:.4f}% pegg {pegg:+.4f}% | DD_fisso = |Profit/RF| = {ddf:.2f} EUR = {ddf/100:.2f}%  -> k = DD_fisso / DD_chiuso = {ddf/ddc:.4f}")
    fA, fB = o["fase_A"], o["fase_B"]
    L.append(f"CURVA IN FASE: {fA['n']} posizioni ({o['fase_estate']['n']} estate da a + {o['fase_inverno']['n']} inverno da b), {fA['deal']} deal; fuori fase scartate {o['n_fuori']}; sedute di confine con posizione: a {o['confine'][0]}, b {o['confine'][1]}")
    L.append(f"  metodo A (ribasato): Profit {fA['profit']:+.2f} EUR, PF pos {fA['pf_pos']:.3f} / deal {fA['pf_deal']:.3f}, EP {fA['ep']:+.2f} EUR/pos, vinte {fA['vinte']}/{fA['n']}, DD chiuso {fA['dd_eur']:.2f} EUR = {fA['dd_pct']:.2f}%, pegg. giorno {fA['pegg_eur']:+.2f} EUR = {fA['pegg_pct']:+.2f}%, serie {fA['serie']}")
    L.append(f"  metodo B (denaro):   Profit {fB['profit']:+.2f} EUR, PF pos {fB['pf_pos']:.3f} / deal {fB['pf_deal']:.3f}, EP {fB['ep']:+.2f} EUR/pos, DD chiuso {fB['dd_eur']:.2f} EUR = {fB['dd_pct']:.2f}%, pegg. giorno {fB['pegg_pct']:+.2f}%, serie {fB['serie']}")
    L.append(f"  scarto di saldo massimo corsa/curva (metodo A): {o['scarto_max']*100:.2f}%  (regola: sopra il 10% R1/R2 con DD fra 0,8 e 1,2 volte la soglia sono NON RISOLTI)")
    L.append(f"  estate (a): {o['fase_estate']['n']} pos, Profit {o['fase_estate']['profit']:+.2f}, PF {o['fase_estate']['pf_pos']:.3f} | inverno (b): {o['fase_inverno']['n']} pos, Profit {o['fase_inverno']['profit']:+.2f}, PF {o['fase_inverno']['pf_pos']:.3f}")
    L.append("  per anno (in fase, denaro): " + " | ".join(f"{y}: n {v[0]} {v[1]:+.2f}" for y, v in sorted(o["anni"].items())))
    for lab, pp in (("gambe intere", list(pa) + list(pb)), ("in fase", o["fase"])):
        v = valore_punto(pp)
        if v: L.append(f"VALORE DEL PUNTO misurato dal per-trade ({lab}, tutte le posizioni a due deal, ingresso eliminato): n {len(v)}, min {min(v):.3f}, mediana {st.median(v):.3f}, max {max(v):.3f} EUR/pt/lotto")
    med, nst, mn, mx = o["k1"]
    if med is None: L.append("K1 COSTO: nessuna uscita a stop pieno nel campione -> [NON MISURABILE]")
    else:
        esito = "AMMESSO" if med >= K1_OK else ("FRAGILE" if med >= K1_MIN else "ESCLUSO PER COSTO")
        L.append(f"K1 COSTO: stop mediano {med:.1f} pti (n {nst} stop pieni, min {mn:.1f} max {mx:.1f}; 1 EUR/pt/lotto, misurato dal per-trade qui sopra) -> {esito} (soglie 68 / 22,6); vs spread 1,70: {med/1.70:.1f}x")
    n = fA["n"]
    pn = p_noedge(n)
    for tag, val, ok, soglia in (("R1 DD chiuso %", fA["dd_pct"], fA["dd_pct"] <= R1_MAX, f"<= {R1_MAX}"),
                                 ("R2 pegg. giorno %", fA["pegg_pct"], fA["pegg_pct"] >= R2_MIN, f">= {R2_MIN}"),
                                 ("R3 serie perdente", fA["serie"], fA["serie"] <= R3_MAX, f"<= {R3_MAX}")):
        pstr = f"P che un motore senza edge lo passi a n={n}: {pn:.2f}" if tag.startswith("R1") else "P senza edge: non data dal modello della classe 804 (misura R1)"
        if ok: L.append(f"{tag} {val:.2f} ({soglia}): NON VIOLATO su n = {n} posizioni in fase ({pstr})" + (" - oltre il peggio di CE9 (4,8 R)" if tag.startswith("R1") and val > 4.8 else ""))
        else: L.append(f"{tag} {val:.2f} ({soglia}): ROSSO -> BOCCIATO PER RISCHIO (vale a qualunque n)")
    L.append(f"MERITO: SOSPESO per aritmetica (n {n} << 150). EP per posizione in fase {o['ep_R']:+.3f} R (mediana {o['ep_R_med']:+.3f} R) -> segno {'CONCORDE' if o['ep_R'] > 0 else 'DISCORDE'} con la sonda CE9 (+0,230 R); attesa di toro CE9: fra -0,20 e +0,25 R")
    L.append(f"  crollo 2025.03.31-2025.05.09: {o['crollo'][0]} posizioni, {o['crollo'][1]:+.2f} EUR, {o['crollo'][2]:+.2f} R")
    if o["o1"] is None: L.append("O1 vs 770411: per-trade R246 non trovato -> [NON MISURABILE]")
    else:
        q, tot = o["o1"]
        L.append(f"O1 vs 770411 (per data di chiusura, 794623 fino al 2025.06.09 / 794621 dal 2025.06.10): {q} giornate su {tot} = {100*q/tot if tot else 0:.0f}%" + (" -> NON ADDITIVO A RISCHIO PIENO" if tot and q/tot > 0.5 else ""))
    L.append("O2 vs R252a/b (770105): [NON MISURABILE] (per-trade R252 non in archivio; classe 781)")
    L.append("CERTIFICATO: NON ANCORA MISURATO (mancano: gestione dell'uscita ad asse, gemelli E50EUR/F40EUR, InpOpeningRangeMinutes 5/10/15)")
    # elenco posizioni in fase
    L.append("POSIZIONI IN FASE (data, corsa, deal, lotto tot, net EUR, r in R):")
    for p in o["fase"]:
        L.append(f"  {p['data']} {'a' if not inverno(p['data']) else 'b'} d{len(p['deals'])} vol {p['vol']:.2f} net {p['net']:+8.2f} r {p['r']/0.01:+.3f}R")
    return "\n".join(L), o

def autotest():
    # corsa a: 3 posizioni (estate, inverno, estate); corsa b: 2 posizioni (inverno, estate)
    def mk(t, pid, vol, net): return {"t": datetime.strptime(t, "%Y.%m.%d %H:%M:%S"), "pid": pid, "type": 0, "vol": vol, "price": 1.0, "net": net}
    da = [mk("2024.10.10 10:00:00", 1, 1.0, -100.0), mk("2024.12.10 10:00:00", 2, 1.0, 50.0), mk("2025.06.10 10:00:00", 3, 1.0, 40.0), mk("2025.06.10 12:00:00", 3, 1.5, 60.0)]
    db = [mk("2024.12.12 10:00:00", 1, 2.0, -200.0), mk("2025.06.11 10:00:00", 2, 1.0, 30.0)]
    pa = posizioni(da); pb = posizioni(db)
    o = analizza(pa, pb)
    # in fase: a#1 (estate 2024.10.10: NON inverno perche' < 27/10), a#3 (estate), b#1 (inverno) -> 3 posizioni; a#2 fuori (inverno da a), b#2 fuori (estate da b)
    assert o["fase_B"]["n"] == 3 and o["n_fuori"] == 2, (o["fase_B"]["n"], o["n_fuori"])
    assert abs(o["fase_B"]["profit"] - (-100 - 200 + 100)) < 1e-9
    # metodo A: a#1 r=-100/10000=-1%; b#1: saldo corsa b prima = 10000 -> r=-2%; a#3: saldo corsa a prima = 10000-100+50=9950 -> r=100/9950
    # curva A: 10000 -> 9900 -> 9900*(1-0.02)=9702 -> 9702*(1+100/9950)=9799.51
    assert abs(o["fase_A"]["profit"] - (-200.49)) < 0.01, o["fase_A"]["profit"]
    assert o["fase_A"]["dd_pct"] > 2.97 and o["fase_A"]["dd_pct"] < 2.99, o["fase_A"]["dd_pct"]
    assert o["fase_A"]["serie"] == 2
    # K1: stop pieni = posizioni con 1 deal in perdita: a#1 (100/1.0=100), b#1 (200/2=100) -> mediana 100
    assert o["k1"][0] == 100.0 and o["k1"][1] == 2, o["k1"]
    # scarto di saldo: b#1 B_corsa 10000 vs curva 9900 -> 1,01%; a#3 B_corsa 9950 vs curva 9702 -> 2,56%
    assert 0.0255 < o["scarto_max"] < 0.0257, o["scarto_max"]
    assert p_noedge(25) == 0.635 and p_noedge(5) == 0.95 and p_noedge(60) == 0.40
    # valore del punto, contro-esempio: short ingresso 20000, parziale 0,4 a 19900 (+40), pari SLITTATO a 20005 su 0,6 (-3,00):
    # il vecchio stimatore (net_1 / (vol_1 x distanza)) dava 40/(0,4 x 105) = 0,952; quello a due equazioni deve dare 1,000
    def mkp(t, vol, price, net, typ=0): return {"t": datetime.strptime(t, "%Y.%m.%d %H:%M:%S"), "pid": 9, "type": typ, "vol": vol, "price": price, "net": net}
    vp = valore_punto(posizioni([mkp("2025.06.10 10:00:00", 0.4, 19900.0, 40.0), mkp("2025.06.10 11:00:00", 0.6, 20005.0, -3.0)]))
    assert len(vp) == 1 and abs(vp[0] - 1.0) < 1e-9, vp
    # stesso caso con uscita a 2R (19800 su 0,6 = +120) e caso LONG speculare (deal_type 1)
    vp = valore_punto(posizioni([mkp("2025.06.10 10:00:00", 0.4, 19900.0, 40.0), mkp("2025.06.10 11:00:00", 0.6, 19800.0, 120.0)]))
    assert abs(vp[0] - 1.0) < 1e-9, vp
    vp = valore_punto(posizioni([mkp("2025.06.10 10:00:00", 0.4, 20100.0, 40.0, 1), mkp("2025.06.10 11:00:00", 0.6, 19995.0, -3.0, 1)]))
    assert abs(vp[0] - 1.0) < 1e-9, vp
    print("AUTOTEST OK (curva in fase, metodo A, K1, scarto, P senza edge, valore del punto)")

if __name__ == "__main__":
    ap = argparse.ArgumentParser(); ap.add_argument("--autotest", action="store_true"); a = ap.parse_args()
    if a.autotest: autotest(); sys.exit(0)
    txt, _ = referto(); print(txt)
