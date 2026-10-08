#!/usr/bin/env python3
# =====================================================================
#  sim_bulge_viola_simboli.py -- SOLA LETTURA. Domanda di Claudio (08/10/2026):
#  "fra i 22 cross del Bulge ci sono simboli che profittano PIU' degli altri sul
#   VIOLA, e quel vantaggio e' spiegato da una volatilita' piu' adatta al motore
#   (mean-reversion su bande di Bollinger, SL 3 ATR, TP mediana)?"
#  NON restringe l'entrata del VIOLA (decisione di Claudio): l'uso possibile e'
#  scegliere/pesare i simboli (lista simboli, rischio per cluster).
#  Nessuna taglia, nessun parametro in forward, nessun EA toccato.
#
#  Uso (dalla radice del repo):
#      python3 backtest_pipeline/sim_bulge_viola_simboli.py            # tutto
#      python3 backtest_pipeline/sim_bulge_viola_simboli.py --autotest # solo autotest
#  ASCII puro. Seme fisso 20261008.
#
#  --- ATTESE SCRITTE PRIMA DEI NUMERI (08/10/2026; viste solo le tabelle gia' nei
#      dossier del 03/10 e le 19 righe del trial, MAI il risultato di questo test) ---
#  H0 (la volatilita' non spiega niente): i simboli differiscono per r medio solo per
#      rumore di campione. Con ~10 segnali per simbolo, il rumore di un r medio e' ~0.17 R
#      (sigma del singolo trade ~0.55 R) -> differenze di +-0.3 R fra simboli sono ATTESE.
#  H1 (la volatilita' spiega): rho di Spearman fra volatilita' relativa (ATR14/prezzo al
#      segnale) e r medio per simbolo con |rho| >= 0.50, p(permutazione) < 0.05, STESSO
#      SEGNO sul campione di replica (antenato, periodo disgiunto), e che resta dopo aver
#      tolto il confondente (cluster NZD; costo).
#  ALTRE SPIEGAZIONI da separare: (1) valuta/regime (cross NZD/AUD concentrano la
#      perdita o il guadagno: test per stratificazione); (2) costo: commissione e spread
#      relativi allo stop.
#  ATTESA (banda): |rho| < 0.35, p > 0.10 per la volatilita'; il numero di simboli con
#      PF >= 1.30 (n >= 5) per puro caso: 2-4 su 22; simboli con r medio > 0 e t > 1.96:
#      0-2 per caso; la commissione spiega al massimo ~0.03 R di differenza fra simboli.
#      Numero minimo di segnali per simbolo per vedere +0.10 R (Bonferroni su 22,
#      potenza 80%): ~400-600; per +0.25 R: ~65-100.
#  SOGLIE CONGELATE: "simbolo migliore" = n >= N_MIN(5) E p(caso) < 0.05/22 (la media r del
#      simbolo contro n estrazioni a caso dal POOL) E intervallo bootstrap 95% (per segnale) tutto
#      sopra 0. Il bootstrap da solo NON basta: con 0 perdite nel campione (es. 6 vinte su 6) e'
#      degenerato (non puo' ricampionare una perdita che non c'e'). "volatilita' spiega" = H1 sopra.
#      Tutto il resto = "e' il caso".
#  LIMITI DICHIARATI:
#   - PREZZI NON NEL REPO: per i 22 cross non ci sono barre, ATR, larghezza delle bande,
#     spread. La volatilita' qui e' misurata SOLO al segnale, dalle uscite a SL
#     (SL = 3 ATR -> ATR = |entrata - uscita| / 3) e dallo SL del trial. Selezione: solo
#     i trade stoppati hanno la misura (il campione e' piccolo e non casuale).
#   - spread: solo EURUSD, GBPUSD, USDJPY (data/spread_vivo/); per i cross [NON MISURATO].
#   - R92 (v5.10, 106 operazioni) non ha il per-trade nel repo; il backtest di Claudio
#     (268) non ha l'xlsx nel repo: [NON LEGGIBILI].
#   - R92BAB e' Modello 1 (screening) su 2 mesi e un solo regime.
# =====================================================================
import collections
import math
import random
import statistics as st
import sys

import sim_bulge_viola_dati as D

SEME = 20261008
N_MIN = 5
N_PERM = 20000
N_BOOT = 3000


# ------------------------------------------------------------------ statistica di base
def ranghi(x):
    idx = sorted(range(len(x)), key=lambda i: x[i])
    rk = [0.0] * len(x)
    i = 0
    while i < len(idx):
        j = i
        while j + 1 < len(idx) and x[idx[j + 1]] == x[idx[i]]:
            j += 1
        for k in range(i, j + 1):
            rk[idx[k]] = (i + j) / 2.0 + 1.0
        i = j + 1
    return rk


def pearson(a, b):
    ma, mb = sum(a) / len(a), sum(b) / len(b)
    sa = math.sqrt(sum((v - ma) ** 2 for v in a))
    sb = math.sqrt(sum((v - mb) ** 2 for v in b))
    if sa == 0 or sb == 0:
        return float("nan")
    return sum((u - ma) * (v - mb) for u, v in zip(a, b)) / (sa * sb)


def spearman(x, y):
    return pearson(ranghi(x), ranghi(y))


def spearman_perm(x, y, rng, n_perm=N_PERM, strati=None):
    """rho e p a due code per permutazione di x; se `strati` e' dato si permuta DENTRO ogni stratum
    (toglie il confondente discreto: l'effetto che resta e' quello a parita' di stratum)."""
    rho = spearman(x, y)
    if len(x) < 4 or rho != rho:
        return rho, float("nan")
    gruppi = collections.defaultdict(list)
    for i in range(len(x)):
        gruppi[strati[i] if strati else 0].append(i)
    ge = 0
    xs = list(x)
    for _ in range(n_perm):
        for g in gruppi.values():
            vals = [x[i] for i in g]
            rng.shuffle(vals)
            for i, v in zip(g, vals):
                xs[i] = v
        if abs(spearman(xs, y)) >= abs(rho) - 1e-12:
            ge += 1
    return rho, (ge + 1) / (n_perm + 1.0)


def spearman_parziale(x, y, z):
    rxy, rxz, ryz = spearman(x, y), spearman(x, z), spearman(y, z)
    den = math.sqrt(max(1e-12, (1 - rxz ** 2) * (1 - ryz ** 2)))
    return (rxy - rxz * ryz) / den


def spearman_parziale_perm(x, y, z, rng, n_perm=5000):
    obs = spearman_parziale(x, y, z)
    xs = list(x)
    ge = 0
    for _ in range(n_perm):
        rng.shuffle(xs)
        if abs(spearman_parziale(xs, y, z)) >= abs(obs) - 1e-12:
            ge += 1
    return obs, (ge + 1) / (n_perm + 1.0)


def boot_media(valori, cluster, rng, B=N_BOOT):
    """Intervallo 95% della media di r, ricampionando i SEGNALI (cluster) e non le posizioni."""
    gr = collections.defaultdict(list)
    for v, c in zip(valori, cluster):
        gr[c].append(v)
    cl = list(gr.values())
    if len(cl) < 2:
        return float("nan"), float("nan")
    medie = []
    for _ in range(B):
        s = [rng.choice(cl) for _ in cl]
        tot = sum(len(g) for g in s)
        medie.append(sum(sum(g) for g in s) / tot)
    medie.sort()
    return medie[int(0.025 * B)], medie[int(0.975 * B) - 1]


def n_minimo(sigma, delta, alpha, potenza=0.80):
    """Segnali per simbolo per distinguere una media di `delta` R da 0 (z-test a due code, sigma nota)."""
    z = NormalInv(1 - alpha / 2.0) + NormalInv(potenza)
    return int(math.ceil((sigma * z / delta) ** 2))


def NormalInv(p):
    # Acklam, errore relativo < 1.2e-9
    a = [-3.969683028665376e+01, 2.209460984245205e+02, -2.759285104469687e+02, 1.383577518672690e+02, -3.066479806614716e+01, 2.506628277459239e+00]
    b = [-5.447609879822406e+01, 1.615858368580409e+02, -1.556989798598866e+02, 6.680131188771972e+01, -1.328068155288572e+01]
    c = [-7.784894002430293e-03, -3.223964580411365e-01, -2.400758277161838e+00, -2.549732539343734e+00, 4.374664141464968e+00, 2.938163982698783e+00]
    d = [7.784695709041462e-03, 3.224671290700398e-01, 2.445134137142996e+00, 3.754408661907416e+00]
    pl = 0.02425
    if p < pl:
        q = math.sqrt(-2 * math.log(p))
        return (((((c[0] * q + c[1]) * q + c[2]) * q + c[3]) * q + c[4]) * q + c[5]) / ((((d[0] * q + d[1]) * q + d[2]) * q + d[3]) * q + 1)
    if p > 1 - pl:
        q = math.sqrt(-2 * math.log(1 - p))
        return -(((((c[0] * q + c[1]) * q + c[2]) * q + c[3]) * q + c[4]) * q + c[5]) / ((((d[0] * q + d[1]) * q + d[2]) * q + d[3]) * q + 1)
    q = p - 0.5
    r = q * q
    return (((((a[0] * r + a[1]) * r + a[2]) * r + a[3]) * r + a[4]) * r + a[5]) * q / (((((b[0] * r + b[1]) * r + b[2]) * r + b[3]) * r + b[4]) * r + 1)


# ------------------------------------------------------------------ raggruppamenti
def per_simbolo(pos):
    gr = collections.defaultdict(list)
    for p in pos:
        gr[p["sym"]].append(p)
    return gr


def stat_simboli(pos, rng, boot=True):
    out = {}
    for s, l in per_simbolo(pos).items():
        rs = [p["r"] for p in l]
        riga = D.riga_stat(rs)
        riga["sigma"] = st.pstdev(rs) if len(rs) > 1 else float("nan")
        if boot:
            riga["lo"], riga["hi"] = boot_media(rs, [p["sig"] for p in l], rng)
        out[s] = riga
    return out


def nzd(sym):
    return "NZD" in D.valute(sym)


def conteggio_per_caso(pos, rng, n_sim=2000):
    """Quanti simboli 'sembrano migliori' per PURO CASO: si rimescola r fra le posizioni (n per simbolo fisso)."""
    sims = list(per_simbolo(pos).items())
    rs = [p["r"] for p in pos]
    cnt_pf, cnt_t, mx = [], [], []
    for _ in range(n_sim):
        rng.shuffle(rs)
        i = 0
        a = b = 0
        best = -9.0
        for s, l in sims:
            v = rs[i:i + len(l)]
            i += len(l)
            if len(v) < N_MIN:
                continue
            m = sum(v) / len(v)
            sd = st.pstdev(v)
            if D.pf(v) >= 1.30:
                a += 1
            if sd > 0 and m / (sd / math.sqrt(len(v))) > 1.96:
                b += 1
            best = max(best, m)
        cnt_pf.append(a)
        cnt_t.append(b)
        mx.append(best)
    return cnt_pf, cnt_t, mx


def p_media_caso(rs_pool, n, obs, rng, N=20000):
    """P(media di n r estratti a caso dal pool >= obs): una coda. E' il 'p del simbolo' contro il caso."""
    ge = 0
    for _ in range(N):
        if sum(rng.sample(rs_pool, n)) / n >= obs - 1e-12:
            ge += 1
    return (ge + 1) / (N + 1.0)


def q(l, f):
    s = sorted(l)
    return s[min(len(s) - 1, int(f * len(s)))]


# ------------------------------------------------------------------ autotest
def autotest():
    ko = []

    def ok(cond, msg):
        print("  [%s] %s" % ("OK" if cond else "KO", msg))
        if not cond:
            ko.append(msg)

    rng = random.Random(SEME)
    ok(abs(spearman([1, 2, 3, 4], [10, 20, 30, 40]) - 1) < 1e-12, "spearman monotona = +1")
    ok(abs(spearman([1, 2, 3, 4], [40, 30, 20, 10]) + 1) < 1e-12, "spearman inversa = -1")
    ok(abs(spearman([1, 2, 2, 4], [1, 2, 3, 4]) - 0.9486832980505138) < 1e-9, "spearman con parimerito (ranghi medi) = 0.94868")
    ok(abs(NormalInv(0.975) - 1.959964) < 1e-5 and abs(NormalInv(0.8) - 0.841621) < 1e-5, "inversa normale: z(0.975)=1.95996, z(0.8)=0.84162")
    # n minimo: sigma 0.6, delta 0.1, alpha 0.05 -> (0.6*(1.95996+0.84162)/0.1)^2 = 282.5 -> 283
    ok(n_minimo(0.6, 0.1, 0.05) == 283, "n minimo sigma 0.6 delta 0.1 alpha 0.05 = 283 (a mano 282.5)")
    ok(n_minimo(0.6, 0.1, 0.05 / 22) > 2 * n_minimo(0.6, 0.1, 0.05) * 0.95, "Bonferroni su 22 raddoppia (circa) il campione richiesto")
    # --- dati finti: 22 simboli, 12 'NZD' ; r = rumore. Controesempi sulla PERMUTAZIONE
    simboli = D.SYM22
    vol = [1.0 + 0.05 * i for i in range(len(simboli))]
    # (i) rumore puro: il test deve dare p<0.05 solo ~5% delle volte
    falsi = 0
    rip = 120
    for _ in range(rip):
        y = [rng.gauss(0, 0.17) for _ in simboli]
        if spearman_perm(vol, y, rng, 300)[1] < 0.05:
            falsi += 1
    ok(0.0 <= falsi / float(rip) <= 0.13, "rumore puro: falsi positivi %d/%d (atteso ~5%%, tetto 13%%)" % (falsi, rip))
    # (ii) effetto vero GRANDE: media = 0.60*(rango vol normalizzato), rumore di campione 0.17 (n~10) -> deve trovarlo
    trov = 0
    for _ in range(rip):
        y = [0.60 * i / 21.0 + rng.gauss(0, 0.17) for i in range(22)]
        if spearman_perm(vol, y, rng, 300)[1] < 0.05:
            trov += 1
    ok(trov / float(rip) >= 0.85, "effetto vero GRANDE (range +0.60 R, n~10/simbolo): trovato %d/%d (atteso >=85%%)" % (trov, rip))
    # (ii-bis) effetto MODESTO (range 0.25 R): la potenza e' una MISURA da riportare, non un'attesa: deve stare sotto quella del grande
    trovm = 0
    for _ in range(rip):
        y = [0.25 * i / 21.0 + rng.gauss(0, 0.17) for i in range(22)]
        if spearman_perm(vol, y, rng, 300)[1] < 0.05:
            trovm += 1
    ok(trovm < trov, "effetto MODESTO (range +0.25 R, n~10/simbolo): trovato solo %d/%d = potenza misurata, sotto quella dell'effetto grande" % (trovm, rip))
    # (iii) stesso effetto con n~2/simbolo (sigma 0.39): la potenza crolla -> 'non trovato' NON significa 'non c'e''
    trov2 = 0
    for _ in range(rip):
        y = [0.25 * i / 21.0 + rng.gauss(0, 0.39) for i in range(22)]
        if spearman_perm(vol, y, rng, 300)[1] < 0.05:
            trov2 += 1
    ok(trov2 / float(rip) < 0.70, "effetto 0.25 R con n~2/simbolo: trovato solo %d/%d (potenza bassa, il 'nulla' non vale come prova)" % (trov2, rip))
    # (iv) CONFONDENTE valuta: i simboli NZD hanno vol alta E r basso; dentro ogni stratum non c'e' relazione
    nz = [nzd(s) for s in simboli]
    vol_c = [(2.0 if n else 1.0) + rng.gauss(0, 0.05) for n in nz]
    y_c = [(-0.3 if n else 0.0) + rng.gauss(0, 0.05) for n in nz]
    r_gl, p_gl = spearman_perm(vol_c, y_c, rng, 2000)
    r_st, p_st = spearman_perm(vol_c, y_c, rng, 2000, strati=nz)
    ok(p_gl < 0.01 and p_st > 0.10, "confondente NZD: globale rho %+.2f p %.4f (sembra 'la volatilita''), stratificato p %.3f (sparisce)" % (r_gl, p_gl, p_st))
    # (v) CONFONDENTE costo: il guadagno dipende solo dal costo; la vol e' correlata al costo
    cst = [0.5 + 0.1 * i for i in range(22)]
    vol_k = [c + rng.gauss(0, 0.25) for c in cst]
    y_k = [-0.1 * c + rng.gauss(0, 0.01) for c in cst]
    ok(abs(spearman(vol_k, y_k)) > 0.5, "costo: vol e r correlati in apparenza (rho %+.2f)" % spearman(vol_k, y_k))
    pp, pv = spearman_parziale_perm(vol_k, y_k, cst, rng, 2000)
    ok(abs(pp) < 0.45 and pv > 0.05, "costo: tolto il costo, la correlazione della vol sparisce (parziale %+.2f p %.3f)" % (pp, pv))
    # (vi) bootstrap per segnale: due gambe dello stesso segnale non devono gonfiare la precisione
    v = [0.3, 0.3, -1.0, -1.0, 0.3, 0.3]
    lo1, hi1 = boot_media(v, [1, 1, 2, 2, 3, 3], rng, 2000)
    lo2, hi2 = boot_media(v, [1, 2, 3, 4, 5, 6], rng, 2000)
    ok((hi1 - lo1) >= (hi2 - lo2) - 1e-9, "bootstrap per segnale: intervallo (%.2f) >= bootstrap per posizione (%.2f) con gambe doppie" % (hi1 - lo1, hi2 - lo2))
    # (vii) 'per puro caso' su dati senza edge: ~1-4 simboli con PF>=1.3 su 22 con n~10
    pos = []
    for s in simboli:
        for i in range(10):
            pos.append(D.nuova("fin", (s, i), s, 1, None, None, 1, 0.0, 1.0, "tp", "VIOLA", "x"))
    for p in pos:
        p["r"] = -1.0 if rng.random() < 0.26 else 0.3
    a, b, mx = conteggio_per_caso(pos, rng, 300)
    ok(1.0 <= sum(a) / 300.0 <= 8.0, "edge assente: simboli con PF>=1.30 per caso in media %.1f su 22 (n 10 ciascuno)" % (sum(a) / 300.0))
    print("AUTOTEST: %s" % ("TUTTO OK" if not ko else "FALLITI: %d" % len(ko)))
    return not ko


# ------------------------------------------------------------------ main
def mediana(l):
    l = [v for v in l if v is not None]
    return st.median(l) if l else float("nan")


def main():
    if not autotest():
        print("autotest fallito: non leggo nessun dato")
        return 1
    if "--autotest" in sys.argv:
        return 0
    rng = random.Random(SEME)
    v520, ant = D.carica_bcm()
    trial = D.carica_trial()
    r92 = D.carica_r92bab()
    spread = D.carica_spread()
    v520_v = [p for p in v520 if p["segnale"] == "VIOLA" and p["sym"] in D.SYM22]
    fuori = [p["sym"] for p in v520 if p["segnale"] == "VIOLA" and p["sym"] not in D.SYM22]
    ant_v = [p for p in ant if p["segnale"] == "VIOLA" and p["sym"] in D.SYM22]
    pool = r92 + v520_v
    print("\n=== CAMPIONI ===")
    print("  POOL (test principale) = R92BAB VIOLA %d + v520 piccolo VIOLA %d (fuori lista scartati: %s) = %d" % (len(r92), len(v520_v), fuori, len(pool)))
    print("    periodi disgiunti (maggio-giugno / 30-09..07-10), stessa versione v5.20; R92BAB e' Modello 1, il piccolo e' forward reale")
    print("  REPLICA = antenato VIOLA %d (aprile-giugno, versione col primo tick; si sovrappone a R92BAB nel tempo: NON indipendente nel regime)" % len(ant_v))
    print("  TRIAL FTMO %d: stesse operazioni del piccolo sui cross comuni -> usato solo per l'ATR al segnale, non come campione." % len(trial))
    print("  NON NEL REPO: R92 per-trade (v5.10, 106 op.), xlsx del backtest di Claudio (268 op.): [NON LEGGIBILI]")
    rs = [p["r"] for p in pool]
    sigma = st.pstdev(rs)
    print("  POOL: n %d, somma r %+.2f, PF(r) %.2f, media r %+.3f, sigma del singolo trade %.3f R" % (len(pool), sum(rs), D.pf(rs), sum(rs) / len(rs), sigma))

    # ---------- (a) tabella per simbolo
    S = stat_simboli(pool, rng)
    print("\n=== (a) PER SIMBOLO (POOL). r = multiplo del rischio. IC95 = bootstrap per SEGNALE ===")
    rs_pool = [p["r"] for p in pool]
    for s_, r_ in S.items():
        r_["pcaso"] = p_media_caso(rs_pool, r_["n"], r_["media"], rng) if r_["n"] >= N_MIN else float("nan")
    print("%-7s %4s %5s %6s %8s %8s %7s %7s  %-17s %8s %s" % ("simbolo", "n", "wr%", "PF(r)", "somma r", "media r", "v.med", "p.med", "IC95 media r", "p caso", "nota"))
    ordine = sorted(S, key=lambda s: -S[s]["media"])
    for s in ordine:
        r_ = S[s]
        nota = "n<%d: non leggibile" % N_MIN if r_["n"] < N_MIN else ("IC DEGENERE (0 perdite)" if r_["pm"] == 0 else "")
        ic = "[%+.2f, %+.2f]" % (r_["lo"], r_["hi"]) if r_["lo"] == r_["lo"] else "n/d"
        pc = ("%.3f" % r_["pcaso"]) if r_["pcaso"] == r_["pcaso"] else "n/d"
        print("%-7s %4d %5.0f %6.2f %+8.2f %+8.3f %7.2f %7.2f  %-17s %8s %s" % (s, r_["n"], r_["wr"], r_["pf"], r_["somma"], r_["media"], r_["vm"], r_["pm"], ic, pc, nota))
    mancanti = [s for s in D.SYM22 if s not in S]
    if mancanti:
        print("  simboli senza nessuna operazione nel POOL: %s" % mancanti)
    leggibili = [s for s in S if S[s]["n"] >= N_MIN]
    sopra_ic = [s for s in leggibili if S[s]["lo"] > 0]
    sopra = [s for s in leggibili if S[s]["lo"] > 0 and S[s]["pcaso"] < 0.05 / 22]
    print("  simboli con n>=%d: %d; con IC95 tutto sopra 0: %s; che passano ANCHE p caso < 0.05/22 (soglia congelata): %s"
          % (N_MIN, len(leggibili), sopra_ic if sopra_ic else "NESSUNO", sopra if sopra else "NESSUNO"))
    sotto = [s for s in leggibili if S[s]["hi"] < 0]
    print("  simboli con IC95 tutto SOTTO 0: %s" % (sotto if sotto else "NESSUNO"))

    # ---------- (a-bis) quanti 'migliori' per puro caso
    cpf, ct, mx = conteggio_per_caso([p for p in pool if p["sym"] in leggibili], rng)
    obs_pf = sum(1 for s in leggibili if S[s]["pf"] >= 1.30)
    obs_t = sum(1 for s in leggibili if S[s]["sigma"] > 0 and S[s]["media"] / (S[s]["sigma"] / math.sqrt(S[s]["n"])) > 1.96)
    obs_mx = max(S[s]["media"] for s in leggibili)
    print("\n=== (a-bis) CONFRONTI MULTIPLI: quanti simboli 'migliori' ti aspetti per puro caso (r rimescolato fra le posizioni, n per simbolo fisso) ===")
    print("  simboli con PF(r)>=1.30: osservati %d | per caso: media %.1f, 95%% fino a %d" % (obs_pf, sum(cpf) / len(cpf), q(cpf, 0.95)))
    print("  simboli con media r>0 e t>1.96: osservati %d | per caso: media %.1f, 95%% fino a %d" % (obs_t, sum(ct) / len(ct), q(ct, 0.95)))
    print("  migliore media r: osservata %+.3f | per caso: mediana %+.3f, 95%% fino a %+.3f" % (obs_mx, q(mx, 0.5), q(mx, 0.95)))

    # ---------- dispersione fra simboli e fra valute
    tot = [p["r"] for p in pool if p["sym"] in leggibili]
    sym_l = [p["sym"] for p in pool if p["sym"] in leggibili]

    def disp(etichette):
        gr = collections.defaultdict(list)
        for e, v in zip(etichette, tot):
            gr[e].append(v)
        m = sum(tot) / len(tot)
        return sum(len(g) * (sum(g) / len(g) - m) ** 2 for g in gr.values())

    obs = disp(sym_l)
    lab = list(sym_l)
    ge = 0
    for _ in range(N_PERM // 4):
        rng.shuffle(lab)
        if disp(lab) >= obs - 1e-12:
            ge += 1
    print("  dispersione fra simboli (permutazione delle etichette): p = %.3f  (alto = i simboli non sono distinguibili)" % ((ge + 1) / (N_PERM // 4 + 1.0)))

    # ---------- valuta / regime: esposizione NON firmata a ciascuna valuta
    cur = collections.defaultdict(list)
    for p in pool:
        for c in D.valute(p["sym"]):
            cur[c].append(p["r"])
    print("\n=== (d) VALUTA/REGIME: r per valuta contenuta nel cross (non firmata; ogni posizione conta in due valute) ===")
    for c in sorted(cur, key=lambda c: sum(cur[c])):
        print("  %-4s n %3d  somma r %+7.2f  media r %+.3f  PF %.2f" % (c, len(cur[c]), sum(cur[c]), sum(cur[c]) / len(cur[c]), D.pf(cur[c])))
    obs_min = min(sum(v) for v in cur.values())
    obs_max = max(sum(v) for v in cur.values())
    simbs = [p["sym"] for p in pool]
    rsx = [p["r"] for p in pool]
    lab = list(simbs)
    g_min = g_max = 0
    nperm = 5000
    for _ in range(nperm):
        rng.shuffle(lab)
        cc = collections.defaultdict(float)
        for l_, r_ in zip(lab, rsx):
            for c in D.valute(l_):
                cc[c] += r_
        if min(cc.values()) <= obs_min + 1e-12:
            g_min += 1
        if max(cc.values()) >= obs_max - 1e-12:
            g_max += 1
    print("  valuta PEGGIORE %+.2f R: p(permutazione delle etichette) = %.3f | valuta MIGLIORE %+.2f R: p = %.3f   (la statistica e' il minimo/massimo fra le 8 valute: la molteplicita' e' GIA' dentro il p)"
          % (obs_min, (g_min + 1) / (nperm + 1.0), obs_max, (g_max + 1) / (nperm + 1.0)))

    # ---------- (b) volatilita' al segnale
    # cancello 08/10 (classe 1179): due segnali aperti allo STESSO tick con lo stesso SL (antenato
    # USDCHF 2026.04.01 03:00:55, ARANCIO_L + BLU_L) sono UNA misura di ATR, non due: si conta una volta.
    vol_rel, vol_pip = collections.defaultdict(list), collections.defaultdict(list)
    visti_vol = set()
    for p in v520 + ant + trial:
        if p["atr_rel"] is not None and p["sym"] in D.SYM22:
            k_vol = (p["sym"], p["apre"], round(p["atr_rel"], 12))
            if k_vol in visti_vol:
                continue
            visti_vol.add(k_vol)
            vol_rel[p["sym"]].append(p["atr_rel"])
            vol_pip[p["sym"]].append(p["atr_pip"])
    print("\n=== (b) VOLATILITA' AL SEGNALE (ATR H1 / prezzo), misurata da SL = 3 ATR (uscite a SL del piccolo + SL del trial) ===")
    print("  NON ci sono barre dei 22 cross nel repo: questo e' un PROXY con n piccolo e selezionato (solo i trade stoppati). Vedi la SONDA nel dossier.")
    print("%-7s %5s %12s %10s %9s %9s %9s %10s %10s" % ("simbolo", "n_vol", "ATR/prezzo%", "ATR pip", "n pool", "TP/ATR", "freq R92", "comm/R %", "spr/ATR"))
    tp_atr, cmm = {}, {}
    for s in D.SYM22:
        tps = [3.0 * p["r"] for p in pool if p["sym"] == s and p["motivo"] == "tp" and p["r"] > 0]
        tp_atr[s] = mediana(tps) if tps else float("nan")
        cm = [abs(p["comm"]) / p["R"] for p in v520 + trial + ant if p["sym"] == s and p["R"] and p["comm"]]
        cmm[s] = mediana(cm) if cm else float("nan")
    vr = {s: mediana(vol_rel[s]) for s in D.SYM22 if vol_rel[s]}
    for s in D.SYM22:
        nvol = len(vol_rel[s])
        sp = spread.get(s)
        rapp = ("%.3f" % (sp / mediana(vol_pip[s]))) if (sp is not None and vol_pip[s]) else "n/d"
        print("%-7s %5d %12s %10s %9d %9s %9d %10s %10s" % (
            s, nvol, ("%.3f" % (100 * vr[s])) if s in vr else "n/d", ("%.1f" % mediana(vol_pip[s])) if nvol else "n/d",
            S[s]["n"] if s in S else 0, ("%.2f" % tp_atr[s]) if tp_atr[s] == tp_atr[s] else "n/d",
            sum(1 for p in r92 if p["sym"] == s), ("%.2f" % (100 * cmm[s])) if cmm[s] == cmm[s] else "n/d", rapp))
    print("  spread vivo disponibile solo per: %s (pip, mediana sulle ore); per gli altri cross [NON MISURATO]" % {k: v for k, v in spread.items() if k in D.SYM22})
    tp_ok = [v for v in tp_atr.values() if v == v]
    print("  TP/ATR = 3 x vincita mediana in R = distanza della mediana BB dall'entrata in ATR (mean-reversion): mediana fra simboli %.2f ATR" % (mediana(tp_ok) if tp_ok else float('nan')))
    cm_ok = [v for v in cmm.values() if v == v]
    if cm_ok:
        print("  commissione / R: da %.2f%% a %.2f%% (mediana per simbolo): e' il tetto di quanto la SOLA commissione puo' spiegare della differenza di r medio fra simboli" % (100 * min(cm_ok), 100 * max(cm_ok)))

    # ---------- (c) il test
    comuni = [s for s in leggibili if s in vr]
    print("\n=== (c) IL TEST: Spearman fra volatilita' relativa e r medio per simbolo (permutazione, %d perm.) ===" % N_PERM)
    print("  simboli con n_pool>=%d E una misura di volatilita': %d su 22" % (N_MIN, len(comuni)))
    if len(comuni) >= 6:
        x = [vr[s] for s in comuni]
        y = [S[s]["media"] for s in comuni]
        strato = [("NZD" if nzd(s) else "altro") for s in comuni]
        rho, pv = spearman_perm(x, y, rng)
        rho_s, pv_s = spearman_perm(x, y, rng, strati=strato)
        print("  H: vol -> media r : rho %+.2f p %.3f | stratificato per NZD/altro: rho %+.2f p %.3f" % (rho, pv, rho_s, pv_s))
        c3 = [s for s in comuni if len(vol_rel[s]) >= 3]
        if len(c3) >= 6:
            r3v, p3v = spearman_perm([vr[s] for s in c3], [S[s]["media"] for s in c3], rng)
            print("  sensibilita': solo simboli con >=3 misure di volatilita' (%d simboli): rho %+.2f p %.3f" % (len(c3), r3v, p3v))
        xs2 = [tp_atr[s] for s in comuni if tp_atr[s] == tp_atr[s]]
        ys2 = [S[s]["media"] for s in comuni if tp_atr[s] == tp_atr[s]]
        if len(xs2) >= 6:
            r2, p2 = spearman_perm(xs2, ys2, rng)
            print("  H: TP/ATR (distanza della mediana) -> media r : rho %+.2f p %.3f (n simboli %d)  [PARZIALMENTE CIRCOLARE: la vincita fa parte del r medio]" % (r2, p2, len(xs2)))
        cc = [s for s in comuni if cmm[s] == cmm[s]]
        if len(cc) >= 6:
            xc = [vr[s] for s in cc]
            yc = [S[s]["media"] for s in cc]
            zc = [cmm[s] for s in cc]
            r3, p3 = spearman_perm(zc, yc, rng)
            rp, pp = spearman_parziale_perm(xc, yc, zc, rng)
            print("  H: costo (commissione/R) -> media r : rho %+.2f p %.3f | vol -> media r a parita' di costo: parziale %+.2f p %.3f (n simboli %d)" % (r3, p3, rp, pp, len(cc)))
        print("  correzione per confronti multipli: 3 ipotesi di volatilita'/costo -> soglia 0.05/3 = 0.017")
        # replica sull'antenato
        Sa = stat_simboli(ant_v, rng, boot=False)
        cr = [s for s in comuni if s in Sa and Sa[s]["n"] >= 3]
        if len(cr) >= 6:
            ra, pa = spearman_perm([vr[s] for s in cr], [Sa[s]["media"] for s in cr], rng)
            print("  REPLICA antenato (simboli con n>=3: %d): vol -> media r : rho %+.2f p %.3f" % (len(cr), ra, pa))
        else:
            print("  REPLICA antenato: solo %d simboli con n>=3 e volatilita': non eseguibile (soglia 6)" % len(cr))
    else:
        print("  troppo pochi simboli con volatilita' misurata: test non eseguibile con i dati del repo")
    # frequenza dei segnali contro volatilita'
    fr = [(vr[s], sum(1 for p in r92 if p["sym"] == s)) for s in D.SYM22 if s in vr]
    if len(fr) >= 6:
        rf, pf_ = spearman_perm([a for a, _ in fr], [b for _, b in fr], rng)
        print("  frequenza dei segnali VIOLA (R92BAB, 2 mesi, ATR spento) vs volatilita': rho %+.2f p %.3f (n simboli %d)" % (rf, pf_, len(fr)))

    # ---------- (e) quanti segnali servono
    print("\n=== (e) QUANTI SEGNALI PER SIMBOLO per distinguere un simbolo migliore dal caso (sigma del trade = %.3f R misurata sul POOL) ===" % sigma)
    print("  %-10s %-14s %-18s %s" % ("vantaggio", "alpha 0.05", "alpha 0.05/22", "anni a ~%d segnali/simbolo/anno (R92BAB: %d VIOLA / 22 simboli / 1,85 mesi)" % (round(len(r92) / 22.0 / (1.85 / 12.0)), len(r92))))
    freq_anno = len(r92) / 22.0 / (1.85 / 12.0)
    for dlt in (0.05, 0.10, 0.15, 0.25, 0.40):
        n1, n2 = n_minimo(sigma, dlt, 0.05), n_minimo(sigma, dlt, 0.05 / 22)
        print("  +%.2f R     %-14d %-18d %.1f anni (Bonferroni)" % (dlt, n1, n2, n2 / freq_anno))
    print("  oggi: %d..%d segnali per simbolo nel POOL (mediana %d)" % (min(S[s]["n"] for s in S), max(S[s]["n"] for s in S), st.median([S[s]["n"] for s in S])))
    print("\nNON SI PUO' DIRE con questi dati: l'ATR/prezzo e' misurato su trade stoppati; la larghezza delle bande, il range medio H1 e lo spread dei cross non sono nel repo.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
