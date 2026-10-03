#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
trial_sfortuna_o_ea.py -- 03/10/2026
Misure per report/TRIAL_SFORTUNA_O_EA_2026-10-03.md (criteri congelati nella sezione 0 di quel file, commit 15d9bc23,
PRIMA di questi numeri). SOLA LETTURA: legge file del repo, stampa in console, non scrive niente.
Importa (senza modificarli): lettura_trial_senza_aperte.leggi, audit_rischio_flotta.pertrade_pos / leggi_report.
USO: python3 backtest_pipeline/trial_sfortuna_o_ea.py
"""
import collections, datetime as dt, math, os, random, sys, warnings
warnings.filterwarnings("ignore")
QUI = os.path.dirname(os.path.abspath(__file__)); REPO = os.path.dirname(QUI)
sys.path.insert(0, QUI)
import numpy as np
import lettura_trial_senza_aperte as LT
import audit_rischio_flotta as AU

SEME = 20261003
N_SIM = 200_000
N_BANDA = 2_000
F_TRIAL = os.path.join(REPO, "data/statements/ReportHistory_trial_1514806751_2026-10-03.xlsx")
SALDO0 = 160000.0
GIORNO_FTMO = -0.0436           # peggior giorno pannello FTMO (equity)
TOT_2G = -8811.59 / SALDO0       # -5,51%
SOGLIA_STOP = -0.70
CAL_DA, CAL_A = dt.date(2025, 7, 1), dt.date(2026, 6, 29)

CONTRATTI = {   # sedia: (per-trade, quota, deposito, taglia in campo %)
    "770411": ("risultati_prove/trades_portafoglio/abtg_trades_ABTG_MaxMinNotte_DAX_Short_Ottimizzato_D30EUR_770413.csv", 1.0, 100000.0, 2.0),
    "770105": ("risultati_archivio/R251/PERTRADE/abtg_trades_ABTG_DAX_Apertura_EU_D30EUR_792520.csv", 1.0, 10000.0, 2.0),
    "770621": ("risultati_prove/trades_portafoglio/abtg_trades_ABTG_ORB_Ottimizzato_U30USD_770612.csv", 1.0, 100000.0, 0.3),
    "770101": ("risultati_prove/aperture_r47/abtg_trades_ABTG_DAX_Apertura_EU_D30EUR_772501.csv", 1.0, 100000.0, 2.0),
    "770202": ("risultati_prove/aperture_r47/abtg_trades_ABTG_Dow_Apertura_US_U30USD_772505.csv", 1.0, 100000.0, 2.0),
    "771531": ("risultati_archivio/R112_CORSA_20260826/pertrade_00_metro_763400.csv", 0.5, 100000.0, 2.0),
}
DAX = ("770101", "770105", "770411")


def sedia_trial(c):
    u = (c or "").upper()
    if u.startswith("MAXMIN DAX SHORT"): return "770411"
    if u.startswith("DAX APERTURA EU RETEST"): return "770105" if u.endswith("SELL") else "770101"
    if u.startswith("ORB OTT"): return "770621"
    if u.startswith("BULGE_V520_FT_"): return "BULGE_A"
    if u.startswith("BULGE_VIOLA_"): return "BULGE_B"
    if u.startswith("BULGE VIOLA"): return "BULGE_C"
    return "ALTRO"


def trial():
    pos, info = LT.leggi(F_TRIAL)
    vpp = collections.defaultdict(list)
    for p in pos:
        d = (p["p1"] - p["p0"]) * (1 if p["lato"] == "buy" else -1)
        p["vpp"] = p["prof"] / (d * p["vol"]) if d else None
        if p["vpp"]: vpp[p["sim"]].append(p["vpp"])
    for p in pos:
        if not p["vpp"]: p["vpp"] = sorted(vpp[p["sim"]])[len(vpp[p["sim"]]) // 2]
        p["rischio"] = abs(p["p0"] - p["sl0"]) * p["vol"] * p["vpp"]
        p["R"] = p["net"] / p["rischio"]
        p["sedia"] = sedia_trial(p["com_in"])
        p["bal0"] = (p["bal_dopo_in"] or 0) - 0  # saldo dopo il deal d'ingresso (commissione d'ingresso gia' dentro)
        p["taglia_mis"] = 100.0 * p["rischio"] / p["bal0"] if p["bal0"] else None
    return pos, info


def contratto(s):
    rel, quota, dep, _ = CONTRATTI[s]
    return AU.pertrade_pos(rel, quota, deposito=dep)


def binom_le(k, n, p):
    return sum(math.comb(n, i) * p ** i * (1 - p) ** (n - i) for i in range(0, k + 1))


def p_net_mc(Rc, n, obs, sims=N_SIM, seme=SEME):
    rnd = random.Random(seme); m = len(Rc); c = 0
    for _ in range(sims):
        if sum(Rc[rnd.randrange(m)] for _ in range(n)) <= obs + 1e-12: c += 1
    return c / sims


def p_net_esatto(Rc, n, obs):
    """Convoluzione esatta della somma di n estrazioni i.i.d. (distribuzione empirica): con valori arrotondati a 1e-6."""
    dist = {0.0: 1.0}
    m = len(Rc)
    vals = collections.Counter(round(r, 6) for r in Rc)
    for _ in range(n):
        nd = collections.defaultdict(float)
        for a, pa in dist.items():
            for v, cv in vals.items():
                nd[round(a + v, 6)] += pa * cv / m
        dist = nd
        if len(dist) > 3_000_000: return None
    return sum(pv for v, pv in dist.items() if v <= obs + 1e-9)


def clip(R):
    """Deviazione dichiarata DOPO i numeri (difetto d'unita' trovato leggendo i risultati): ogni R <= -0,70 (stop pieno)
    vale -1,0 sia nel trial sia nel contratto. Toglie dal confronto la sola 'taglia dello stop' (pavimento del lotto del banco,
    slippage dello stop in campo), che con n piccolo domina p_net."""
    return [-1.0 if r <= SOGLIA_STOP else r for r in R]


def banda(Rc, n, obs, rng):
    """5-95% di p_net su N_BANDA ricampionamenti del contratto (numpy PCG64, seme SEME), 4.000 sim ciascuno."""
    Rc = np.array(Rc); m = len(Rc); ps = []
    for _ in range(N_BANDA):
        Rb = Rc[rng.integers(0, m, m)]
        draws = Rb[rng.integers(0, m, (4000, n))].sum(axis=1)
        ps.append(float((draws <= obs + 1e-12).mean()))
    ps.sort()
    return ps[int(0.05 * N_BANDA)], ps[int(0.95 * N_BANDA) - 1]


def verdetto(p, pmin, contratto_ok=True):
    if not contratto_ok: return "NON ANCORA MISURATO (contratto assente)"
    if pmin >= 0.05: return "NON ANCORA MISURATO (senza potenza: p_min %.3f >= 0,05)" % pmin
    return "EFFETTO" if p < 0.05 else ("ZONA GRIGIA" if p < 0.20 else "NULLO")


def stat_contratto(pc):
    R = [a["R"] for a in pc]
    w = [r for r in R if r > 0]; l = [r for r in R if r <= 0]
    gp = sum(a["net"] for a in pc if a["net"] > 0); gl = -sum(a["net"] for a in pc if a["net"] <= 0)
    return dict(n=len(R), wr=sum(1 for a in pc if a["net"] > 0) / len(R), wmed=sum(w) / len(w), lmed=sum(l) / len(l),
                stop=sum(1 for r in R if r <= SOGLIA_STOP) / len(R), Rmed=sum(R) / len(R), Rmin=min(R), pf=gp / gl if gl else float("inf"),
                med=sorted(R)[len(R) // 2])


def prova(nome, Rc, Robs, wr, rng, ok=True):
    n = len(Robs); k = sum(1 for r in Robs if r > 0); obs = sum(Robs)
    pw = binom_le(k, n, wr)
    pn = p_net_mc(Rc, n, obs)
    pe = p_net_esatto(Rc, n, obs) if len(Rc) ** min(n, 3) < 5e6 else None
    pmin_b = (1 - wr) ** n
    pmin_n = p_net_esatto(Rc, n, n * min(Rc)) if pe is not None else p_net_mc(Rc, n, n * min(Rc), sims=50000)
    pmin = max(pmin_b, pmin_n)
    lo, hi = banda(Rc, n, obs, rng) if not os.environ.get("VELOCE") else (float("nan"), float("nan"))
    err = 1.96 * math.sqrt(max(pn * (1 - pn), 1e-12) / N_SIM)
    Rcc, oc = clip(Rc), sum(clip(Robs))
    pr = p_net_esatto(Rcc, n, oc) if len(Rc) ** min(n, 3) < 5e6 else p_net_mc(Rcc, n, oc)
    lo_r, hi_r = banda(Rcc, n, oc, rng) if not os.environ.get("VELOCE") else (float("nan"), float("nan"))
    print(f"  {nome}: n={n} vinte={k} sommaR={obs:+.3f} | p_win={pw:.4f} | p_net(MC)={pn:.4f} +-{err:.4f}"
          f" | p_net(esatto)={'n/d' if pe is None else '%.4f' % pe} | banda5-95 contratto [{lo:.4f}, {hi:.4f}]"
          f" | p_min binom {pmin_b:.4f} netto {pmin_n:.4f} | VERDETTO: {verdetto(pn, pmin, ok)}"
          f"\n      ROBUSTO (stop=-1): sommaR {oc:+.3f} p_net {pr:.4f} banda [{lo_r:.4f}, {hi_r:.4f}] -> {verdetto(pr, pmin, ok)}")
    return dict(n=n, k=k, obs=obs, pw=pw, pn=pn, pe=pe, lo=lo, hi=hi, pmin=pmin, v=verdetto(pn, pmin, ok), pr=pr, vr=verdetto(pr, pmin, ok))


def giorni_lav():
    d, out = CAL_DA, []
    while d <= CAL_A:
        if d.weekday() < 5: out.append(d)
        d += dt.timedelta(days=1)
    return out


def serie_sedie():
    cal = giorni_lav(); idx = {d: i for i, d in enumerate(cal)}
    ser, stp = {}, {}
    for s, (rel, quota, dep, tg) in CONTRATTI.items():
        v = np.zeros(len(cal)); st = np.zeros(len(cal), dtype=int)
        size = tg * quota      # EMA200: 2% x 0,5 = 1% per gamba
        for a in contratto(s):
            i = idx.get(a["day"])
            if i is None: continue
            v[i] += a["R"] * size / 100.0
            if a["R"] <= SOGLIA_STOP: st[i] += 1
        ser[s] = v; stp[s] = st
    return cal, ser, stp


def statistiche(M, oss_p6):
    """M: matrice sedie x giorni -> S1..S4 sul calendario (finestre consecutive)."""
    g = M.sum(axis=0); due = g[:-1] + g[1:]
    return dict(S1_436=float((g <= GIORNO_FTMO).mean()), S1_real=float((g <= REAL_G1).mean()),
                S2=float((due <= TOT_2G).mean()), S3=float(((g[:-1] <= GIORNO_FTMO) | (g[1:] <= GIORNO_FTMO)).mean()),
                S4=float((due <= oss_p6 + 1e-12).mean()), n_g=len(g), n_2=len(due),
                c_S1_436=int((g <= GIORNO_FTMO).sum()), c_S1_real=int((g <= REAL_G1).sum()), c_S2=int((due <= TOT_2G).sum()),
                c_S3=int(((g[:-1] <= GIORNO_FTMO) | (g[1:] <= GIORNO_FTMO)).sum()), c_S4=int((due <= oss_p6 + 1e-12).sum()))


def permutate(M, rng, reps=N_BANDA, oss=None):
    acc = collections.defaultdict(float)
    for _ in range(reps):
        Mp = np.array([rng.permutation(r) for r in M])
        for k, v in statistiche(Mp, oss).items():
            if not k.startswith(("n_", "c_")): acc[k] += v / reps
    return dict(acc)


REAL_G1 = None


def main():
    global REAL_G1
    rng = np.random.Generator(np.random.PCG64(SEME))
    print("=" * 110); print("TRIAL 1514806751 -- sfortuna o EA (criteri: report/TRIAL_SFORTUNA_O_EA_2026-10-03.md sez. 0, commit 15d9bc23)"); print("=" * 110)
    pos, info = trial()
    # CE4 parser
    net = sum(p["net"] for p in pos)
    print(f"CE4 parser: posizioni {len(pos)} (attese 13) | netto {net:.2f} (atteso -8811.59) | commissioni {info['comm_tot']:.2f} (attese -204.04) | saldo {info['saldo']:.2f} (atteso 151188.41)")
    assert len(pos) == 13 and abs(net + 8811.59) < 0.005 and abs(info['comm_tot'] + 204.04) < 0.005 and abs(info['saldo'] - 151188.41) < 0.005
    for p in pos:
        print(f"   {p['t0']} {p['sedia']:8s} {p['sim']:10s} {p['lato']:4s} vol {p['vol']:6.2f} rischio {p['rischio']:8.1f} EUR ({p['taglia_mis']:.2f}% del saldo) netto {p['net']:9.2f} R {p['R']:+.3f} uscita {p['uscita']}")
    r411 = [p for p in pos if p["sedia"] == "770411"][0]["rischio"]; r105 = [p for p in pos if p["sedia"] == "770105"][0]["rischio"]
    print(f"CE4 rischio: 770411 {r411:.0f} (banda 3199-3237) | 770105 {r105:.0f} (~3106)")
    assert 3150 <= r411 <= 3260 and 3050 <= r105 <= 3160
    gg = collections.defaultdict(float)
    for p in pos: gg[p["t1"][:10]] += p["net"]
    REAL_G1 = gg["2026.10.01"] / SALDO0
    print("giorni (realizzato, % di 160.000):", {k: round(100 * v / SALDO0, 3) for k, v in gg.items()})

    # ---------------- per sedia
    print("\n--- CONTRATTI (ricalcolati dal per-trade) ---")
    SC = {}
    for s in ("770411", "770105", "770621"):
        pc = contratto(s); st = stat_contratto(pc); SC[s] = (pc, st)
        print(f"  {s}: n {st['n']} | WR {st['wr']:.4f} | R medio vinte {st['wmed']:+.3f} perse {st['lmed']:+.3f} payoff {st['wmed'] / -st['lmed']:.3f} | stop-rate {st['stop']:.3f} | R medio {st['Rmed']:+.3f} | R min {st['Rmin']:+.3f} | PF {st['pf']:.3f} | mediana R {st['med']:+.3f}")
    print("\n--- PROVE PER SEDIA (trial 01-02/10) ---")
    RIS = {}
    for s in ("770411", "770105", "770621"):
        pc, st = SC[s]
        Robs = [p["R"] for p in pos if p["sedia"] == s]
        RIS[s] = prova(s, [a["R"] for a in pc], Robs, st["wr"], rng)

    # estensione: challenge + trial
    print("\n--- ESTENSIONE SECONDARIA: challenge 541452707 (22-30/09) + trial ---")
    ch, _, _ = AU.leggi_report(AU.F_CHALL, "CHALL")
    for s in ("770411", "770105"):
        pc, st = SC[s]
        Rch = [p["R"] for p in ch if p["sedia"] == s and not p.get("aperta")]
        Robs = Rch + [p["R"] for p in pos if p["sedia"] == s]
        print(f"  {s}: challenge R = {[round(r, 3) for r in Rch]}")
        RIS[s + "_ct"] = prova(s + " challenge+trial", [a["R"] for a in pc], Robs, st["wr"], rng)

    # frequenza 770411 (contesto)
    lam2, lam9 = 0.051 * 2, 0.051 * 9
    pge = lambda k, lam: 1 - sum(math.exp(-lam) * lam ** i / math.factorial(i) for i in range(k))
    print(f"\n  frequenza 770411: trial 1 posizione in 2 g (attese {lam2:.3f}, P(>=1)={pge(1, lam2):.4f}); FTMO 4 posizioni in 9 g (attese {lam9:.3f}, P(>=4)={pge(4, lam9):.6f})")

    # ---------------- Bulge
    print("\n--- BULGE (contratto [NON MISURATO]) ---")
    B = [p for p in pos if p["sedia"].startswith("BULGE")]
    Rb = [p["R"] for p in B]
    for p in B: print(f"   {p['sedia']} {p['sim']} R {p['R']:+.3f} taglia misurata {p['taglia_mis']:.2f}% uscita {p['uscita']}")
    w = [r for r in Rb if r > 0]; l = [r for r in Rb if r <= 0]
    be = -(sum(l) / len(l)) / (-(sum(l) / len(l)) + sum(w) / len(w))
    print(f"  osservato: n {len(Rb)} vinte {len(w)} sommaR {sum(Rb):+.3f} netto {sum(p['net'] for p in B):.2f} | R medio vinte {sum(w) / len(w):+.3f} perse {sum(l) / len(l):+.3f} -> WR di pareggio coi payoff del trial {be:.3f}")
    # payoff d'ingresso (TP0/SL0)
    rr = [abs(p['tp0'] - p['p0']) / abs(p['p0'] - p['sl0']) for p in B]
    print(f"  TP/SL all'ingresso (ordine): {[round(x, 3) for x in rr]} -> WR di pareggio all'ingresso (senza costi) media {sum(1 / (1 + x) for x in rr) / len(rr):.3f}")
    # Rif-1: due punti
    rif1 = [0.4045] * 8022 + [-1.0] * 1978
    print("  Rif-1 (backtest dichiarato di Claudio, modello a 2 punti, NON contratto):")
    RIS["B_rif1"] = prova("Bulge sotto Rif-1", rif1, Rb, 0.8022, rng, ok=False)
    # Rif-2: antenato solo viola sul piccolo (trades_auto.csv, magic 20250001: e' la fonte del n=50 di giornata_2026-09-30)
    import csv, statistics
    av = [r for r in csv.DictReader(open(os.path.join(REPO, "data/statements/trades_auto.csv")), delimiter=";") if r["strategy"].startswith("BULGE_MULTI_SIGNAL_VIOLA")]
    avn = [float(r["profit"]) + float(r["commission"]) + float(r["swap"]) for r in av]
    gp = sum(x for x in avn if x > 0); gl = -sum(x for x in avn if x <= 0)
    stop_med = -statistics.median([x for x, r in zip(avn, av) if r["close_reason"] == "sl"])
    avR = [x / stop_med for x in avn]
    print(f"  Rif-2 antenato solo VIOLA (trades_auto.csv): n {len(av)} (atteso 50) PF {gp / gl:.4f} (atteso 0,6949) netto {sum(avn):.2f} (atteso -438,04) | WR {sum(1 for x in avn if x > 0) / len(avn):.4f} | R = netto / mediana degli stop ({stop_med:.2f} EUR) [DERIVATO] | R medio vinte {statistics.mean([r for r in avR if r > 0]):+.3f}")
    assert len(av) == 50 and abs(gp / gl - 0.6949) < 5e-5 and abs(sum(avn) + 438.04) < 0.005
    RIS["B_rif2"] = prova("Bulge sotto Rif-2", avR, Rb, sum(1 for x in avn if x > 0) / len(avn), rng, ok=False)

    # ---------------- contro-esempi CE1, CE2
    print("\n--- CONTRO-ESEMPI ---")
    pc, st = SC["770411"]; Rc = [a["R"] for a in pc]
    ce1 = p_net_mc(Rc, 10, -10.0); print(f"  CE1 10 stop pieni 770411: p_net {ce1:.5f} -> {'EFFETTO, ok' if ce1 < 0.05 else 'FALLITO'}")
    med = st["med"]; ce2 = p_net_mc(Rc, 3, 3 * med); print(f"  CE2 3 posizioni alla mediana ({med:+.3f}) 770411: p_net {ce2:.4f} -> {'NULLO, ok' if ce2 >= 0.20 else 'FALLITO'}")
    assert ce1 < 0.05 and ce2 >= 0.20

    # ---------------- portafoglio
    print("\n--- PORTAFOGLIO P6 (calendario %s -> %s, giorni lavorativi) ---" % (CAL_DA, CAL_A))
    cal, ser, stp = serie_sedie()
    nomi = list(ser); M = np.array([ser[s] for s in nomi])
    oss_p6 = sum(p["net"] for p in pos if p["sedia"] in ("770411", "770105", "770621")) / SALDO0
    print(f"  osservato P6 nel trial (2 g): {100 * oss_p6:.3f}% | realizzato giorno 1 tutto il conto {100 * REAL_G1:.3f}%")
    for s in nomi: print(f"   {s}: giorni con posizioni {int((ser[s] != 0).sum())} | peggior giorno {100 * ser[s].min():.3f}% | somma {100 * ser[s].sum():.2f}%")
    g = M.sum(axis=0)
    print(f"  giorni {len(g)} | giorni attivi {int((g != 0).sum())} | peggiori 6: {[round(100 * x, 3) for x in sorted(g)[:6]]}")
    due = g[:-1] + g[1:]
    print(f"  peggiori 6 coppie consecutive: {[round(100 * x, 3) for x in sorted(due)[:6]]} | 5o percentile coppie {100 * np.percentile(due, 5):.3f}%")
    S = statistiche(M, oss_p6); print("  CALENDARIO:", {k: (round(v, 5) if isinstance(v, float) else v) for k, v in S.items()})
    # bootstrap i.i.d. di 2 giorni
    rnd = random.Random(SEME); n = len(g); c2 = c3 = c4 = 0
    gl_ = list(g)
    for _ in range(N_SIM):
        a = gl_[rnd.randrange(n)]; b = gl_[rnd.randrange(n)]
        c2 += (a + b) <= TOT_2G; c3 += (a <= GIORNO_FTMO or b <= GIORNO_FTMO); c4 += (a + b) <= oss_p6 + 1e-12
    print(f"  BOOTSTRAP 2 giorni i.i.d. ({N_SIM}, seme {SEME}): S2 {c2 / N_SIM:.5f} | S3 {c3 / N_SIM:.5f} | S4 {c4 / N_SIM:.5f}")
    P = permutate(M, rng, oss=oss_p6)
    print("  PERMUTATO (sedie indipendenti, %d perm.):" % N_BANDA, {k: round(v, 5) for k, v in P.items()})
    print("  CONTRIBUTO CORRELAZIONE (cal - indip):", {k: round(S[k] - P[k], 5) for k in P})
    # stesso indice: doppi stop DAX
    st_dax = np.array([stp[s] > 0 for s in DAX])
    pr = st_dax.mean(axis=1)
    dd = int((st_dax.sum(axis=0) >= 2).sum())
    att = len(cal) * (1 - np.prod(1 - pr) - sum(pr[i] * np.prod([1 - pr[j] for j in range(3) if j != i]) for i in range(3)))
    print(f"  DAX: frequenza giornaliera di stop {dict(zip(DAX, [round(float(x), 4) for x in pr]))} | giorni con >=2 sedie DAX in stop: {dd} su {len(cal)} | atteso se indipendenti {att:.3f} | lift {dd / att if att else float('nan'):.2f}")
    # 770411 e 770105 nello stesso giorno
    both = int(((stp['770411'] > 0) & (stp['770105'] > 0)).sum()); co = int(((ser['770411'] != 0) & (ser['770105'] != 0)).sum())
    print(f"  770411 e 770105: giorni con posizioni di entrambe {co}, con stop di entrambe {both}")

    # intervalli di Clopper-Pearson (95%) dei conteggi esatti del calendario
    def cp(kk, nn):
        def cdf_le(x, p_): return sum(math.comb(nn, i) * p_ ** i * (1 - p_) ** (nn - i) for i in range(0, x + 1))
        def bis(f):
            a, b = 0.0, 1.0
            for _ in range(60):
                m_ = (a + b) / 2
                if f(m_): b = m_
                else: a = m_
            return (a + b) / 2
        lo_ = 0.0 if kk == 0 else bis(lambda p_: 1 - cdf_le(kk - 1, p_) >= 0.025)
        hi_ = 1.0 if kk == nn else bis(lambda p_: cdf_le(kk, p_) <= 0.025)
        return lo_, hi_
    for nome_, c_, n_ in (("S1 <=-4,36%", S["c_S1_436"], S["n_g"]), ("S1 <=realizzato g1", S["c_S1_real"], S["n_g"]), ("S2", S["c_S2"], S["n_2"]), ("S3", S["c_S3"], S["n_2"]), ("S4", S["c_S4"], S["n_2"])):
        a_, b_ = cp(c_, n_); print(f"  CP95 {nome_}: {c_}/{n_} = {c_ / n_:.4f} [{a_:.4f}, {b_:.4f}]")
    # scomposizione della correlazione: stesso indice contro indici diversi
    blocchi = {"DAX": [nomi.index(x) for x in ("770101", "770105", "770411")], "DOW": [nomi.index(x) for x in ("770202", "771531", "770621")]}
    acc = collections.defaultdict(float)
    for _ in range(N_BANDA):
        Mb = np.empty_like(M)
        for rows_ in blocchi.values():
            perm = rng.permutation(M.shape[1])
            for r_ in rows_: Mb[r_] = M[r_][perm]
        for kk, v in statistiche(Mb, oss_p6).items():
            if not kk.startswith(("n_", "c_")): acc[kk] += v / N_BANDA
    print("  BLOCCHI PER INDICE (stesso indice allineato, indici diversi indipendenti):", {kk: round(v, 5) for kk, v in acc.items()})
    print("  -> contributo STESSO INDICE (blocchi - indip):", {kk: round(acc[kk] - P[kk], 5) for kk in P}, "| contributo FRA INDICI (cal - blocchi):", {kk: round(S[kk] - acc[kk], 5) for kk in P})
    # sensibilita' sulla presenza: 770101 e 771531 [NON VERIFICATE sul trial]
    M4 = np.array([ser[s_] for s_ in nomi if s_ not in ("770101", "771531")])
    S4v = statistiche(M4, oss_p6)
    print("  PRESENZA: P4 senza 770101 e 771531:", {kk: (round(v, 5) if isinstance(v, float) else v) for kk, v in S4v.items()})
    M3 = np.array([ser[s_] for s_ in ("770411", "770105", "770621")])
    print("  PRESENZA: P3 solo le tre che hanno operato:", {kk: (round(v, 5) if isinstance(v, float) else v) for kk, v in statistiche(M3, oss_p6).items()})

    # ---------------- P4: le sedie con per-trade che il PROFILO SALVATO di C:\FTMO porta davvero (CODA_08 03/10 03:30:
    # 770202, 770260, 770511, 770411, 770105, 770621, 772720; NON 770101 ne' 771531). 770260 e 770511 non hanno per-trade.
    print("\n--- P4 = 770105, 770202, 770411, 770621 (presenza dal profilo salvato; 770260 e 770511 senza per-trade) ---")
    n4 = [s_ for s_ in nomi if s_ not in ("770101", "771531")]
    S4v = statistiche(M4, oss_p6)
    for nome_, c_, n_ in (("S1 <=-4,36%", S4v["c_S1_436"], S4v["n_g"]), ("S1 <=realizzato g1", S4v["c_S1_real"], S4v["n_g"]), ("S2", S4v["c_S2"], S4v["n_2"]), ("S3", S4v["c_S3"], S4v["n_2"]), ("S4", S4v["c_S4"], S4v["n_2"])):
        a_, b_ = cp(c_, n_); print(f"  P4 CP95 {nome_}: {c_}/{n_} = {c_ / n_:.4f} [{a_:.4f}, {b_:.4f}]")
    g4 = M4.sum(axis=0); due4 = g4[:-1] + g4[1:]
    print(f"  P4 peggiori 6 giorni {[round(100 * x, 3) for x in sorted(g4)[:6]]} | peggiori 6 coppie {[round(100 * x, 3) for x in sorted(due4)[:6]]} | 5o percentile coppie {100 * np.percentile(due4, 5):.3f}%")
    rnd = random.Random(SEME); gl4 = list(g4); n_ = len(gl4); c2 = c3 = c4 = 0
    for _ in range(N_SIM):
        a = gl4[rnd.randrange(n_)]; b = gl4[rnd.randrange(n_)]
        c2 += (a + b) <= TOT_2G; c3 += (a <= GIORNO_FTMO or b <= GIORNO_FTMO); c4 += (a + b) <= oss_p6 + 1e-12
    print(f"  P4 BOOTSTRAP i.i.d.: S2 {c2 / N_SIM:.5f} | S3 {c3 / N_SIM:.5f} | S4 {c4 / N_SIM:.5f}")
    P4p = permutate(M4, rng, oss=oss_p6)
    print("  P4 PERMUTATO:", {kk: round(v, 5) for kk, v in P4p.items()}, "| CONTRIBUTO CORRELAZIONE:", {kk: round(S4v[kk] - P4p[kk], 5) for kk in P4p})
    i202 = nomi.index("770202"); acc = collections.defaultdict(float)
    for _ in range(N_BANDA):
        Mx = np.vstack([M4, rng.permutation(M[i202]), rng.permutation(M[i202])])
        for kk, v in statistiche(Mx, oss_p6).items():
            if not kk.startswith(("n_", "c_")): acc[kk] += v / N_BANDA
    print("  P4 + 2 SEDIE-OMBRA per 770260/770511 (serie 770202 permutata, indipendente; PROXY [DERIVATO], non contratto):", {kk: round(v, 5) for kk, v in acc.items()})

    # ---------------- sensibilita': (a) taglia dello stop del banco portata a -1,0; (b) Guardian approssimato
    import statistics
    k = {}
    for s_ in nomi:
        stp_R = [a["R"] for a in contratto(s_) if a["R"] <= SOGLIA_STOP]
        k[s_] = 1.0 / -statistics.median(stp_R)
    Ms = np.array([ser[s_] * k[s_] for s_ in nomi])
    print("  SENS. (a) fattori stop->-1,0:", {s_: round(v, 4) for s_, v in k.items()})
    print("  SENS. (a) CALENDARIO scalato:", {kk: round(v, 5) for kk, v in statistiche(Ms, oss_p6).items() if not kk.startswith(("n_", "c_"))})
    idx = {d: i for i, d in enumerate(cal)}
    for etichetta, insieme in (("P6", set(CONTRATTI)), ("P4", {"770105", "770202", "770411", "770621"})):
        ev = collections.defaultdict(list)
        for s_, (rel, quota, dep, tg) in CONTRATTI.items():
            if s_ not in insieme: continue
            for a in contratto(s_):
                if a["day"] in idx: ev[a["day"]].append((a["t_close"], a["R"] * tg * quota / 100.0))
        gG = np.zeros(len(cal)); tagliati = 0
        for d, L in ev.items():
            cum = 0.0
            for t, v in sorted(L):
                if cum <= -0.035: tagliati += 1; continue
                cum += v
            gG[idx[d]] = cum
        print(f"  SENS. (b) {etichetta} Guardian approssimato (dopo -3,5% realizzato nel giorno nessuna posizione che chiude dopo; per eccesso): posizioni tolte {tagliati}")
        print(f"  SENS. (b) {etichetta} CALENDARIO col Guardian:", {kk: (round(v, 5) if isinstance(v, float) else v) for kk, v in statistiche(gG[None, :], oss_p6).items()})
        print(f"  SENS. (b) {etichetta} peggiori 6 giorni col Guardian: {[round(100 * x, 3) for x in sorted(gG)[:6]]}")

    # ---------------- CE3
    print("\n--- CE3 (la correlazione si vede) ---")
    twin = np.array([ser["770411"], ser["770411"]])
    soglia = -0.035
    cal_t = float((twin.sum(axis=0) <= soglia).mean())
    perm_t = np.mean([float((np.array([rng.permutation(r) for r in twin]).sum(axis=0) <= soglia).mean()) for _ in range(N_BANDA)])
    ind = np.array([ser["770411"], ser["770202"]])
    cal_i = float((ind.sum(axis=0) <= soglia).mean())
    perm_i = np.mean([float((np.array([rng.permutation(r) for r in ind]).sum(axis=0) <= soglia).mean()) for _ in range(N_BANDA)])
    print(f"  gemelle sincrone (770411 x2) P(g<=-3,5%): calendario {cal_t:.5f} permutato {perm_t:.5f} contributo {cal_t - perm_t:+.5f}")
    print(f"  coppia 770411+770202 (gia' indip.) : calendario {cal_i:.5f} permutato {perm_i:.5f} contributo {cal_i - perm_i:+.5f}")
    assert cal_t - perm_t > 0.003
    # CE5: soglia che avrebbe dato EFFETTO
    print(f"\n--- CE5 --- 5o percentile delle coppie consecutive P6: {100 * np.percentile(due, 5):.3f}% (sotto questa perdita in 2 g, S4 < 0,05)")
    print(f"  osservato P6 {100 * oss_p6:.3f}% -> quantile empirico {float((due <= oss_p6).mean()):.5f}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
