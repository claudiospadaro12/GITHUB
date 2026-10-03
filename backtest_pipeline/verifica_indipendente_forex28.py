#!/usr/bin/env python3
# =====================================================================
#  verifica_indipendente_forex28.py
#  Ricalcolo INDIPENDENTE (cicli Python espliciti, nessuna funzione di
#  ema200_rimbalzo.py / ema200_forex28.py) degli eventi "primo tocco" di
#  UNA coppia a H4 o D1, per confrontarli con quelli dello strumento.
#  Criteri: report/EMA200_H4_D1_FOREX28_CRITERI_2026-10-03.md (sez. 3, 4).
#  Uso:  python3 verifica_indipendente_forex28.py <npz_m1_coppia> <H4|D1> <EVENTI_TF.npz> <NOMECOPPIA> [soglia_filtro]
#  Il confronto e' sulle 6 celle (B/P/AMB/TO) evento per evento, lati long e short.
#  File ASCII puro. Codici: 0 identico, 1 differenze.
# =====================================================================
import sys
import numpy as np

ALPHA = 2.0 / 201.0
WARMUP, NSEP, DMIN, HOR = 600, 20, 1.0, 20
XS = (0.25, 0.5, 1.0)
YS = (0.5, 1.0)
CELLE = [(x, y) for y in YS for x in XS]


def barre(t, o, h, l, c, tf):
    tfm = {"H4": 240, "D1": 1440}[tf]
    st, en, bid = [], [], []
    prev = None
    for i in range(len(t)):
        if tf == "H4":
            b = (int(t[i]) + 60) // 240
        else:
            d = (int(t[i]) + 60) // 1440
            wd = (d + 3) % 7                     # 0 = lunedi'
            b = d + (2 if wd == 5 else (1 if wd == 6 else 0))
        if b != prev:
            st.append(i)
            prev = b
    en = st[1:] + [len(t)]
    O = [float(o[s]) for s in st]
    C = [float(c[e - 1]) for e in en]
    H = [float(max(h[s:e])) for s, e in zip(st, en)]
    L = [float(min(l[s:e])) for s, e in zip(st, en)]
    return st, en, O, H, L, C


def main():
    npz, tf, ev_npz, nome = sys.argv[1:5]
    thr_mul = float(sys.argv[5]) if len(sys.argv) > 5 else 0.0
    z = np.load(npz)
    t, o, h, l, c = z["t"], z["o"], z["h"], z["l"], z["c"]
    st, en, O, H, L, C = barre(t, o, h, l, c, tf)
    nb = len(C)
    E = []
    e = C[0]
    for x in C:
        e = e + ALPHA * (x - e)
        E.append(e)
    TR = []
    for j in range(nb):
        pc = O[0] if j == 0 else C[j - 1]
        TR.append(max(H[j] - L[j], abs(H[j] - pc), abs(L[j] - pc)))
    A = [float("nan")] * nb
    for j in range(13, nb):
        A[j] = sum(TR[j - 13:j + 1]) / 14.0
    ok_a = [a == a for a in A]
    valsA = sorted(A[WARMUP:])
    amed = valsA[len(valsA) // 2] if len(valsA) % 2 else 0.5 * (valsA[len(valsA) // 2 - 1] + valsA[len(valsA) // 2])
    thr = thr_mul * amed
    dist = []
    for j in range(nb):
        dist.append((C[j] - E[j]) / A[j] if (A[j] == A[j] and A[j] > 0 and A[j] >= thr) else 0.0)
    ev = []
    for lato in (0, 1):
        for k in range(max(WARMUP, 1), nb):
            Ep = E[k - 1]
            Ap = A[k - 1]
            if not (Ap == Ap and Ap > 0 and Ap >= thr):
                continue
            finestra = range(k - NSEP, k)
            if k - NSEP < 1:
                continue
            if lato == 0:
                pulite = all(L[j] > E[j - 1] for j in finestra)
                lontano = max(dist[j] for j in finestra) >= DMIN
                tocco = L[k] <= Ep
            else:
                pulite = all(H[j] < E[j - 1] for j in finestra)
                lontano = min(dist[j] for j in finestra) <= -DMIN
                tocco = H[k] >= Ep
            if not (pulite and lontano and tocco):
                continue
            s0, e0 = st[k], en[k]
            eh = en[min(k + HOR - 1, nb - 1)]
            if lato == 0:
                hi = [float(x) for x in h[s0:eh]]
                lo = [float(x) for x in l[s0:eh]]
                Lx = Ep
            else:
                hi = [-float(x) for x in l[s0:eh]]
                lo = [-float(x) for x in h[s0:eh]]
                Lx = -Ep
            t0 = None
            for i in range(e0 - s0):
                if lo[i] <= Lx:
                    t0 = i
                    break
            if t0 is None:
                continue
            esiti = []
            for (X, Y) in CELLE:
                ip = None
                for i in range(t0, len(lo)):
                    if lo[i] <= Lx - Y * Ap:
                        ip = i
                        break
                ib = None
                for i in range(t0 + 1, len(hi)):
                    if hi[i] >= Lx + X * Ap:
                        ib = i
                        break
                if ib is None and ip is None:
                    r = 3
                elif ip is None:
                    r = 0
                elif ib is None:
                    r = 1
                elif ib < ip:
                    r = 0
                elif ip < ib:
                    r = 1
                else:
                    r = 2
                esiti.append(r)
            ev.append((lato, s0 + t0, tuple(esiti)))
    # G-DATI (errata 1): mesi con barre M1 < 50% della mediana dei mesi della coppia -> eventi di quei mesi scartati
    mm = np.asarray(t, dtype="int64").astype("datetime64[m]").astype("datetime64[M]").astype("int64")
    um = sorted(set(int(x) for x in mm))
    cnt = {k: 0 for k in um}
    for x in mm:
        cnt[int(x)] += 1
    cs = sorted(cnt.values())
    medm = cs[len(cs) // 2] if len(cs) % 2 else 0.5 * (cs[len(cs) // 2 - 1] + cs[len(cs) // 2])
    cattivi = set(k for k, v in cnt.items() if v < 0.5 * medm)
    ev = [(a, p, es) for (a, p, es) in ev if int(mm[p]) not in cattivi]
    print("mesi esclusi (G-DATI): %s" % (", ".join(str(np.datetime64(k, "M")) for k in sorted(cattivi)) or "nessuno"))
    # confronto con lo strumento
    zz = np.load(ev_npz)
    var = "PRIM" if thr_mul > 0 else "NOFILT"
    lato_t = zz["%s_%s_lato" % (nome, var)]
    es_t = zz["%s_%s_es" % (nome, var)]
    mie = [(a, es) for (a, pos, es) in ev]
    suoi = [(int(lato_t[i]), tuple(int(x) for x in es_t[i])) for i in range(len(lato_t))]
    tm = zz["%s_%s_tmin" % (nome, var)]
    pos_mie = [int(t[p]) for (a, p, es) in ev]
    uguale = mie == suoi and pos_mie == [int(x) for x in tm]
    print("verifica indipendente %s %s (%s, soglia %.1f x mediana ATR = %.6f): eventi indipendente %d, strumento %d -> %s" % (
        nome, tf, var, thr_mul, thr, len(mie), len(suoi), "IDENTICI (lato, minuto del tocco, 6 celle)" if uguale else "DIFFERENZE"))
    for cella_i, (X, Y) in enumerate(CELLE):
        if (X, Y) in ((1.0, 1.0), (0.25, 1.0)):
            for lato in (0, 1):
                B = sum(1 for (a, es) in mie if a == lato and es[cella_i] == 0)
                P = sum(1 for (a, es) in mie if a == lato and es[cella_i] == 1)
                AMB = sum(1 for (a, es) in mie if a == lato and es[cella_i] == 2)
                TO = sum(1 for (a, es) in mie if a == lato and es[cella_i] == 3)
                print("   cella X%.2f Y%.2f %s: B %d P %d AMB %d TO %d" % (X, Y, "long" if lato == 0 else "short", B, P, AMB, TO))
    # ---- etichetta di allineamento (criteri sez. 8): H4 -> contesto D1, D1 -> contesto H4 ----
    ctx_tf = "D1" if tf == "H4" else "H4"
    cst, cen, cO, cH, cL, cC = barre(t, o, h, l, c, ctx_tf)
    cE = []
    ee = cC[0]
    for x in cC:
        ee = ee + ALPHA * (x - ee)
        cE.append(ee)
    cstarts = np.array(cst)
    tag = []
    for (a, pos, es) in ev:
        j = int(np.searchsorted(cstarts, pos, side="right")) - 1
        jc = j - 1
        if jc < WARMUP:
            tag.append(2)
            continue
        # livello toccato L = EMA della barra chiusa precedente al tocco, ricostruita a mano
        kk = None
        for k2 in range(nb):
            if st[k2] <= pos < en[k2]:
                kk = k2
                break
        Lv = E[kk - 1]
        tag.append(int((cE[jc] < Lv) if a == 0 else (cE[jc] > Lv)))
    ali_t = zz["%s_%s_ali" % (nome, var)]
    tag_t = [int(x) for x in ali_t]
    # lo strumento ha gia' tolto i mesi esclusi: confrontiamo sulla stessa lista (ev e' gia' filtrata)
    print("   etichetta di allineamento (contesto %s): indipendente %s, strumento %s -> %s" % (
        ctx_tf, str(np.bincount(np.array(tag, dtype=int), minlength=3).tolist()), str(np.bincount(np.array(tag_t, dtype=int), minlength=3).tolist()),
        "IDENTICA" if tag == tag_t else "DIFFERENZE"))
    # distanza media (in ATR del TF) fra la EMA di contesto e il livello toccato, per lato
    for lato in (0, 1):
        d = []
        for (a, pos, es), tg in zip(ev, tag):
            if a != lato or tg == 2:
                continue
            j = int(np.searchsorted(cstarts, pos, side="right")) - 2
            kk = [k2 for k2 in range(nb) if st[k2] <= pos < en[k2]][0]
            d.append((cE[j] - E[kk - 1]) / A[kk - 1])
        if d:
            print("   lato %s: (EMA di contesto - livello toccato) in ATR del TF: mediana %+.2f, min %+.2f, max %+.2f (n %d)" % (
                "long" if lato == 0 else "short", sorted(d)[len(d) // 2], min(d), max(d), len(d)))
    sys.exit(0 if (uguale and tag == tag_t) else 1)


if __name__ == "__main__":
    main()
