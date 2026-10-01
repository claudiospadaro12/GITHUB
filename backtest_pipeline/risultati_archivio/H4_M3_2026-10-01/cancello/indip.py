# Reimplementazione INDIPENDENTE (cancello) della cella che decide H4/M3 e dello stop (a).
# Non importa h4_m3_confluenza.py, ema200_rimbalzo.py, collaudo_superwave_v41.py.
# Cicli espliciti; numpy solo per caricare l'npz e per il bootstrap.
import sys, csv, math, numpy as np

CACHE = "/tmp/claude-0/-home-user-GITHUB/c2d73886-9ef2-5105-8937-d770bc36d6df/scratchpad/cache_m1"
SPREAD_CSV = "/home/user/GITHUB/backtest_pipeline/risultati_archivio/spread_flotta/spread_orario_D30EUR.csv"
OFF = 60  # UTC+1

nome = sys.argv[1]
modi = sys.argv[2].split(",") if len(sys.argv) > 2 else ["0.1"]
fare_stop = (len(sys.argv) > 3 and sys.argv[3] == "stop")

z = np.load("%s/m1_%s.npz" % (CACHE, nome))
T = z["t"].tolist(); O = z["o"].tolist(); Hm = z["h"].tolist(); Lm = z["l"].tolist(); Cm = z["c"].tolist()
NT = len(T)


def barre(tf, shift=0):
    S = []; Ob = []; Hb = []; Lb = []; Cb = []
    cur = None
    for i in range(NT):
        b = (T[i] + OFF + shift) // tf
        if b != cur:
            cur = b; S.append(b * tf - OFF - shift); Ob.append(O[i]); Hb.append(Hm[i]); Lb.append(Lm[i]); Cb.append(Cm[i])
        else:
            if Hm[i] > Hb[-1]: Hb[-1] = Hm[i]
            if Lm[i] < Lb[-1]: Lb[-1] = Lm[i]
            Cb[-1] = Cm[i]
    return S, Ob, Hb, Lb, Cb


def supertrend(h, l, c, per, mult):
    # dal testo di SW_STCore (v4.1), riscritto a mano
    n = len(c)
    up = [0.0] * n; dn = [0.0] * n; d = [0.0] * n; v = [0.0] * n
    for i in range(per, n):
        s = 0.0
        for k in range(i - per + 1, i + 1):
            hk = h[k] if h[k] > c[k - 1] else c[k - 1]
            lk = l[k] if l[k] < c[k - 1] else c[k - 1]
            s += hk - lk
        a = s / per
        mid = (h[i] + l[i]) / 2.0
        ub = mid + mult * a; lb = mid - mult * a
        if i == per:
            up[i] = ub; dn[i] = lb; d[i] = 1.0 if c[i] >= mid else -1.0
        else:
            up[i] = ub if (ub < up[i - 1] or c[i - 1] > up[i - 1]) else up[i - 1]
            dn[i] = lb if (lb > dn[i - 1] or c[i - 1] < dn[i - 1]) else dn[i - 1]
            if c[i] > up[i - 1]:
                d[i] = 1.0
            elif c[i] < dn[i - 1]:
                d[i] = -1.0
            else:
                d[i] = d[i - 1]
        v[i] = dn[i] if d[i] > 0 else up[i]
    return d, v


S3, O3, H3, L3, C3 = barre(3)
S1, O1, H1, L1, C1 = barre(60)
S4, O4, H4, L4, C4 = barre(240)
d3, v3 = supertrend(H3, L3, C3, 10, 3.5)
d4, v4 = supertrend(H4, L4, C4, 10, 3.5)
# bs H4: inversioni contate solo per i >= per+2 (SW_BarsSinceFlip(dir,last,per+1))
bs4 = [-1] * len(C4); lf = -1
for i in range(len(C4)):
    if i >= 12 and d4[i] != d4[i - 1]:
        lf = i
    bs4[i] = (i - lf) if lf >= 0 else -1
# ATR(14) H1, TR della prima barra con l'apertura come chiusura precedente
tr = [0.0] * len(C1)
for i in range(len(C1)):
    pc = C1[i - 1] if i > 0 else O1[0]
    tr[i] = max(H1[i], pc) - min(L1[i], pc)
A1 = [float("nan")] * len(C1); flat14 = [0] * len(C1)
for i in range(13, len(C1)):
    A1[i] = sum(tr[i - 13:i + 1]) / 14.0
    flat14[i] = sum(1 for k in range(i - 13, i + 1) if H1[k] == L1[k])

sp_ora = None
if nome == "DAX":
    sp_ora = [None] * 24
    for r in csv.DictReader(open(SPREAD_CSV)):
        if r["ora_server"].isdigit(): sp_ora[int(r["ora_server"])] = float(r["mediana_idx"])
costo_fisso = {"XAU_A": 0.2003, "XAU_B": 0.2003}.get(nome)

# stato per ogni chiusura M3 (puntatori che avanzano)
N3 = len(C3)
rec = []   # (k, tE, j4, jh, A, ora, giorno, ok60, dC60, i0, i240, ok240)
j4 = -1; jh = -1; p0 = 0; p60 = 0; p240 = 0
for k in range(N3):
    tE = S3[k] + 3
    while j4 + 1 < len(S4) and S4[j4 + 1] + 240 <= tE: j4 += 1
    while jh + 1 < len(S1) and S1[jh + 1] + 60 <= tE: jh += 1
    while p0 < NT and T[p0] < tE: p0 += 1
    while p60 < NT and T[p60] < tE + 60: p60 += 1
    while p240 < NT and T[p240] < tE + 240: p240 += 1
    A = A1[jh] if jh >= 0 else float("nan")
    ok60 = (p60 - p0 >= 30) and (p60 < NT) and (p60 > p0)
    ok240 = (p240 - p0 >= 120) and (p240 < NT) and (p240 > p0)
    dC = (Cm[p60 - 1] - C3[k]) if p60 > 0 else 0.0
    rec.append((k, tE, j4, jh, A, ((tE + OFF) // 60) % 24, (tE + OFF) // 1440, ok60, dC, p0, p240, ok240))

Avals = [r[4] for r in rec if r[0] >= 300 and r[4] == r[4] and r[4] > 0]
amed = float(np.median(Avals))


def cella(modo, rng_seed=12345, nboot=2000, blocco=1):
    out = {}
    for lato in (1, -1):
        ALL = []; CON = []; cand = []
        for r in rec:
            k, tE, jj4, jjh, A, ora, g, ok60, dC, i0, i240, ok240 = r
            if k < 300 or jj4 < 300 or jjh < 300 or not (A == A and A > 0):
                continue
            if modo == "none":
                pass
            elif modo == "flat":
                if flat14[jjh] > 0: continue
            else:
                if A < float(modo) * amed: continue
            dH = int(d4[jj4]); b = bs4[jj4]
            stab = dH != 0 and not (0 <= b < 3)
            if not stab:
                continue
            if ok60 and dH == lato:
                cand.append((ora, g, lato * dC / A))
            if k >= 12 and d3[k] != d3[k - 1] and d3[k] != 0 and int(d3[k]) == lato:
                if dH == lato: ALL.append((ora, g, ok60, lato * dC / A, k))
                else: CON.append((ora, g, ok60, lato * dC / A, k))
        # attesa esatta di B (niente estrazione): media dei candidati della stessa ora, pesata sugli eventi
        per_ora = {}
        for ora, g, R in cand: per_ora.setdefault(ora, []).append((g, R))
        mora = {o: sum(x[1] for x in v) / len(v) for o, v in per_ora.items()}
        EB = sum(mora[e[0]] for e in ALL if e[0] in mora) / max(1, sum(1 for e in ALL if e[0] in mora))
        # 20 estrazioni con un RNG diverso dall'autore
        rng = np.random.default_rng(rng_seed + (1 if lato > 0 else 2))
        Bg = []; BR = []; mdraw = []
        for _ in range(20):
            sR = 0.0; nn = 0
            for e in ALL:
                lst = per_ora.get(e[0])
                if not lst: continue
                g, R = lst[int(rng.integers(0, len(lst)))]
                Bg.append(g); BR.append(R); sR += R; nn += 1
            mdraw.append(sR / nn)
        Av = [e for e in ALL if e[2]]
        mA = sum(e[3] for e in Av) / len(Av); mB = sum(BR) / len(BR)
        mC = sum(e[3] for e in CON if e[2]) / max(1, sum(1 for e in CON if e[2]))
        # bootstrap a blocchi (giorno o settimana)
        gA = np.array([e[1] // blocco for e in Av]); xA = np.array([e[3] for e in Av])
        gB = np.array(Bg) // blocco; xB = np.array(BR)
        ug = np.unique(np.concatenate([gA, gB, np.array([r[6] // blocco for r in rec])]))
        pa = np.searchsorted(ug, gA); pb = np.searchsorted(ug, gB)
        sA = np.bincount(pa, xA, len(ug)); nA = np.bincount(pa, minlength=len(ug))
        sB = np.bincount(pb, xB, len(ug)); nB = np.bincount(pb, minlength=len(ug))
        rb = np.random.default_rng(999)
        v = np.empty(nboot)
        for i in range(nboot):
            w = np.bincount(rb.integers(0, len(ug), len(ug)), minlength=len(ug)).astype(float)
            v[i] = (w @ sA) / (w @ nA) - (w @ sB) / (w @ nB)
        lo, hi = np.quantile(v, [0.025, 0.975])
        q025, q975 = np.quantile(mdraw, [0.025, 0.975])
        eff = mA - mB
        if len(Av) < 150: ver = "NON ANCORA MISURATO"
        elif eff >= 0.05 and lo > 0 and mA > q975: ver = "EFFETTO"
        elif eff <= -0.05 and hi < 0 and mA < q025: ver = "CONTRARIO"
        elif abs(eff) < 0.02 and lo >= -0.05 and hi <= 0.05: ver = "NULLO"
        else: ver = "ZONA GRIGIA"
        out[lato] = dict(n=len(Av), mA=mA, mB=mB, EB=EB, mC=mC, eff=eff, effE=mA - EB, lo=lo, hi=hi, q025=q025,
                         q975=q975, ver=ver, ALL=ALL)
        print("%-6s %-6s blocco %d %-5s n %5d ALL %+.4f B %+.4f (attesa esatta %+.4f) CON %+.4f eff %+.4f (vs attesa %+.4f) "
              "IC [%+.3f;%+.3f] banda [%+.3f;%+.3f] -> %s" % (nome, modo, blocco, "long" if lato > 0 else "short", len(Av), mA, mB,
                                                            EB, mC, eff, mA - EB, lo, hi, q025, q975, ver))
    return out


def stop_a(ALL, lato):
    tp = sl = amb = to = 0; vals = []; nets = []; rats = []
    for (ora, g, ok60, R, k) in ALL:
        r = rec[k]
        _, tE, jj4, jjh, A, ora_, g_, _, _, i0, i240, ok240 = r
        e = C3[k]; D = abs(e - v3[k])
        if not (lato * (e - v3[k]) > 0) or not ok240 or D <= 0:
            continue
        cost = sp_ora[ora_] if sp_ora else costo_fisso
        L = min(i240 - i0, 240)
        res = 3; last = i0
        for m in range(i0, i0 + L):
            last = m
            if lato > 0:
                t_ = Hm[m] >= e + D; s_ = Lm[m] <= e - D
            else:
                t_ = Lm[m] <= e - D; s_ = Hm[m] >= e + D
            if t_ and s_: res = 2; break
            if t_: res = 0; break
            if s_: res = 1; break
        if res == 0: tp += 1; val = 1.0
        elif res == 1: sl += 1; val = -1.0
        elif res == 2: amb += 1; val = -1.0
        else: to += 1; val = lato * (Cm[i0 + max(L, 1) - 1] - e) / D
        vals.append(val); nets.append(val - cost / D); rats.append(D / cost)
    n = len(vals)
    print("   STOP a %-5s n %5d TP %d SL %d AMB %d TO %d P1R %.3f E lordo %+.3f netto %+.3f D/costo med %.1fx >=40x %.1f%%" %
          ("long" if lato > 0 else "short", n, tp, sl, amb, to, tp / (tp + sl), sum(vals) / n, sum(nets) / n,
           float(np.median(rats)), 100 * float(np.mean(np.array(rats) >= 40))))


print("%s: M1 %d  M3 %d  H1 %d  H4 %d  ATR H1 mediano %.4f" % (nome, NT, N3, len(C1), len(C4), amed))
for modo in modi:
    blocchi = (1, 7) if modo == "0.1" else (1,)
    for bl in blocchi:
        o = cella(modo, blocco=bl)
    if fare_stop and modo == "0.1":
        for lato in (1, -1):
            stop_a(o[lato]["ALL"], lato)
