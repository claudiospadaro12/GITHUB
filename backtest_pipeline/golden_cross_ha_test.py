#!/usr/bin/env python3
"""Golden Cross HA (MASTERCLASS ABTG v1.0) sull'oro: test su barre M1 BCM con spread.
Criteri e regole: report/GOLDEN_CROSS_HA_TEST_CRITERI_2026-11-01.md (scritti prima dei numeri).
Uso: python3 -I golden_cross_ha_test.py <cartella con ABTG_M1_XAUUSD_2013.csv, _2018, _2020, ABTG_M1_XAUUSD.csv> [--json out.json]
Nessun parametro ottimizzato: 12 varianti decise in anticipo (TF H1/M15 x ADX 20/25 x target 1/1,5/2 R)."""
import sys, os, json, datetime, itertools, collections

FILES = [('2013', 'ABTG_M1_XAUUSD_2013.csv'), ('2018', 'ABTG_M1_XAUUSD_2018.csv'),
         ('2020', 'ABTG_M1_XAUUSD_2020.csv'), ('2025-26', 'ABTG_M1_XAUUSD.csv')]
PT = 0.01  # un punto di spread = 0,01 dollari (oro a 2 decimali)
_dc = {}
P = dict(wick=0.10, bodyf=0.9, crossw=6)  # parametri delle regole HA/incrocio: STRETTI = pre-registrati; RILASSATI = varianti successive, esplorative

def minuti(s):
    d = s[:10]
    o = _dc.get(d)
    if o is None:
        o = datetime.date(int(d[:4]), int(d[5:7]), int(d[8:10])).toordinal(); _dc[d] = o
    return o * 1440 + int(s[11:13]) * 60 + int(s[14:16])

def carica(path):
    t = []; o = []; h = []; l = []; c = []; sp = []
    for ln in open(path, encoding='utf-8'):
        if not ln[:2].isdigit() and not ln.startswith('20'): continue
        p = ln.rstrip().split(';')
        if len(p) < 7 or not p[0][:4].isdigit(): continue
        t.append(minuti(p[0])); o.append(float(p[1])); h.append(float(p[2])); l.append(float(p[3])); c.append(float(p[4])); sp.append(float(p[6]) * PT)
    return t, o, h, l, c, sp

def barre(m1, tf):
    t, o, h, l, c, sp = m1
    B = []; cur = None
    for i in range(len(t)):
        k = t[i] // tf
        if cur is None or k != cur[0]:
            if cur is not None: B.append(cur)
            cur = [k, o[i], h[i], l[i], c[i], i, i]  # chiave, O, H, L, C, primo M1, ultimo M1
        else:
            if h[i] > cur[2]: cur[2] = h[i]
            if l[i] < cur[3]: cur[3] = l[i]
            cur[4] = c[i]; cur[6] = i
    if cur is not None: B.append(cur)
    return B

def ema(x, n):
    a = 2.0 / (n + 1); r = [x[0]]
    for v in x[1:]: r.append(r[-1] + a * (v - r[-1]))
    return r

def indicatori(B):
    n = len(B); O = [b[1] for b in B]; H = [b[2] for b in B]; L = [b[3] for b in B]; C = [b[4] for b in B]
    e9, e21, e50 = ema(C, 9), ema(C, 21), ema(C, 50)
    # Heiken Ashi
    hc = [(O[i] + H[i] + L[i] + C[i]) / 4 for i in range(n)]
    ho = [0.0] * n; ho[0] = (O[0] + C[0]) / 2
    for i in range(1, n): ho[i] = (ho[i - 1] + hc[i - 1]) / 2
    hh = [max(H[i], ho[i], hc[i]) for i in range(n)]; hl = [min(L[i], ho[i], hc[i]) for i in range(n)]
    # ATR, ADX (Wilder, 14)
    tr = [H[0] - L[0]] + [max(H[i] - L[i], abs(H[i] - C[i - 1]), abs(L[i] - C[i - 1])) for i in range(1, n)]
    pdm = [0.0] + [(H[i] - H[i - 1]) if (H[i] - H[i - 1] > L[i - 1] - L[i] and H[i] - H[i - 1] > 0) else 0.0 for i in range(1, n)]
    mdm = [0.0] + [(L[i - 1] - L[i]) if (L[i - 1] - L[i] > H[i] - H[i - 1] and L[i - 1] - L[i] > 0) else 0.0 for i in range(1, n)]
    N = 14; atr = [0.0] * n; sp_ = [0.0] * n; sm_ = [0.0] * n; st_ = [0.0] * n
    pdi = [0.0] * n; mdi = [0.0] * n; dx = [0.0] * n; adx = [0.0] * n
    for i in range(n):
        if i < N:
            st_[i] = sum(tr[:i + 1]); sp_[i] = sum(pdm[:i + 1]); sm_[i] = sum(mdm[:i + 1])
        else:
            st_[i] = st_[i - 1] - st_[i - 1] / N + tr[i]; sp_[i] = sp_[i - 1] - sp_[i - 1] / N + pdm[i]; sm_[i] = sm_[i - 1] - sm_[i - 1] / N + mdm[i]
        atr[i] = st_[i] / min(i + 1, N)
        if st_[i] > 0:
            pdi[i] = 100 * sp_[i] / st_[i]; mdi[i] = 100 * sm_[i] / st_[i]
        s = pdi[i] + mdi[i]; dx[i] = 100 * abs(pdi[i] - mdi[i]) / s if s > 0 else 0.0
        adx[i] = (sum(dx[:i + 1]) / (i + 1)) if i < 2 * N else (adx[i - 1] * (N - 1) + dx[i]) / N
    return dict(O=O, H=H, L=L, C=C, e9=e9, e21=e21, e50=e50, ho=ho, hc=hc, hh=hh, hl=hl, atr=atr, adx=adx, pdi=pdi, mdi=mdi)

def segnale(I, i, dirz, adx_min):
    """True se alla chiusura della barra i il setup (long dirz=+1, short dirz=-1) e completo."""
    C, e9, e21, e50 = I['C'], I['e9'], I['e21'], I['e50']
    if i < 60: return False
    s = dirz
    if not (s * (C[i] - e9[i]) > 0 and s * (e9[i] - e21[i]) > 0 and s * (e21[i] - e50[i]) > 0): return False
    if not (s * (e50[i] - e50[i - 3]) >= 0 and s * (e9[i] - e9[i - 2]) > 0 and s * (e21[i] - e21[i - 2]) > 0): return False
    # incrocio EMA9/EMA21 nelle ultime 6 barre (da lato opposto a lato corretto)
    ok = False
    for j in range(i - P['crossw'] + 1, i + 1):
        if s * (e9[j - 1] - e21[j - 1]) <= 0 and s * (e9[j] - e21[j]) > 0: ok = True; break
    if not ok: return False
    atr = I['atr'][i]
    if atr <= 0 or s * (C[i] - e21[i]) > 1.0 * atr: return False
    # tre candele Heiken Ashi, senza stoppino contrario significativo, corpo non in riduzione
    ho, hc, hh, hl = I['ho'], I['hc'], I['hh'], I['hl']
    body = []
    for j in (i - 2, i - 1, i):
        b = s * (hc[j] - ho[j])
        if b <= 0: return False
        wick = (ho[j] - hl[j]) if s > 0 else (hh[j] - ho[j])
        if wick > P['wick'] * b: return False
        body.append(b)
    if not (body[2] >= P['bodyf'] * body[1] and body[1] >= P['bodyf'] * body[0]): return False
    # ADX
    adx = I['adx']
    if adx[i] < adx_min or adx[i] < adx[i - 1] - 0.5: return False
    if s * (I['pdi'][i] - I['mdi'][i]) <= 0: return False
    return True

def simula(m1, B, I, adx_min, k, tf):
    t, o, h, l, c, sp = m1
    trades = []; pos_until = -1; giorno = None; n_g = 0; perd_g = 0
    n = len(B)
    for i in range(60, n - 2):
        b1 = B[i + 1]
        if b1[5] <= pos_until: continue
        g = t[b1[5]] // 1440
        if g != giorno: giorno = g; n_g = 0; perd_g = 0
        if n_g >= 2 or perd_g >= 2: continue
        for s in (1, -1):
            if not segnale(I, i, s, adx_min): continue
            j0 = b1[5]; sprd = sp[j0]; atr = I['atr'][i]
            entry = o[j0] + (sprd if s > 0 else 0.0)  # long compra all'ask, short vende al bid
            if s > 0: sl = min(I['L'][i - 2:i + 1]) - 0.1 * atr
            else: sl = max(I['H'][i - 2:i + 1]) + 0.1 * atr
            ref = o[j0]  # bid di riferimento per lo stop (nei calcoli sul bid)
            R = (entry - sl) if s > 0 else (sl - entry)
            if R < 0.3 * atr or R > 2.0 * atr: continue
            tp = entry + s * k * R
            esito = None; j = j0
            lastj = len(t) - 1
            while j <= lastj:
                spj = sp[j]
                if s > 0:  # chiusura al bid
                    if o[j] <= sl and j > j0: esito = (sl if False else o[j], j); break
                    if l[j] <= sl: esito = (sl, j); break
                    if h[j] >= tp: esito = (tp, j); break
                else:  # chiusura short all'ask = bid + spread
                    if o[j] + spj >= sl and j > j0: esito = (o[j] + spj, j); break
                    if h[j] + spj >= sl: esito = (sl, j); break
                    if l[j] + spj <= tp: esito = (tp, j); break
                j += 1
            if esito is None: continue
            px, jx = esito
            r = ((px - entry) if s > 0 else (entry - px)) / R
            # costo dello spread in R: spread pagato all'ingresso (long) o all'uscita (short, incluso in px per stop/target ask)
            costo = sprd / R if s > 0 else sp[jx] / R
            trades.append(dict(t=t[j0], dir=s, R=r, costo=costo, rischio_usd=R))
            pos_until = jx; n_g += 1
            if r < 0: perd_g += 1
            break
    return trades

def stat(trs):
    if not trs: return dict(n=0)
    w = [x['R'] for x in trs if x['R'] > 0]; ls = [-x['R'] for x in trs if x['R'] <= 0]
    pf = (sum(w) / sum(ls)) if ls and sum(ls) > 0 else float('inf')
    eq = 100.0; pk = 100.0; mdd = 0.0; cum = 0.0; pkr = 0.0; mddr = 0.0
    for x in trs:
        eq *= 1 + 0.01 * x['R']; pk = max(pk, eq); mdd = max(mdd, (pk - eq) / pk * 100)
        cum += x['R']; pkr = max(pkr, cum); mddr = max(mddr, pkr - cum)
    return dict(n=len(trs), win=100 * len(w) / len(trs), mediaR=sum(x['R'] for x in trs) / len(trs), nettoR=sum(x['R'] for x in trs), pf=pf,
                ddR=mddr, rend1pct=eq - 100, ddpct=mdd, costoR=sum(x['costo'] for x in trs), lunghi=sum(1 for x in trs if x['dir'] > 0))

def main():
    cart = sys.argv[1]
    out = sys.argv[sys.argv.index('--json') + 1] if '--json' in sys.argv else None
    dati = {}
    for lab, f in FILES:
        m1 = carica(os.path.join(cart, f)); dati[lab] = m1
        print('caricato', lab, len(m1[0]), 'barre M1', flush=True)
    risultati = {}
    for set_nome, par in (('STRETTE', dict(wick=0.10, bodyf=0.9, crossw=6)), ('RILASSATE1', dict(wick=0.25, bodyf=0.5, crossw=10)), ('RILASSATE2', dict(wick=0.25, bodyf=0.0, crossw=10))):
      P.update(par)
      for tf_nome, tf in (('H1', 60), ('M15', 15)):
          prep = {}
          for lab in dati:
              B = barre(dati[lab], tf); prep[lab] = (B, indicatori(B))
          for adx_min, k in itertools.product((20, 25), (1.0, 1.5, 2.0)):
              nome = '%s_%s_ADX%d_%sR' % (set_nome, tf_nome, adx_min, str(k).replace('.', ','))
              per = {}; tutti = []
              for lab in dati:
                  B, I = prep[lab]
                  tr = simula(dati[lab], B, I, adx_min, k, tf)
                  per[lab] = stat(tr); tutti += tr
              risultati[nome] = dict(per_periodo=per, totale=stat(tutti))
              tt = risultati[nome]['totale']
              print('%-16s n=%4d  win %.1f%%  PF %.2f  netto %+.1fR  costoSpread %.1fR  ddR %.1f' % (nome, tt['n'], tt.get('win', 0), tt.get('pf', 0), tt.get('nettoR', 0), tt.get('costoR', 0), tt.get('ddR', 0)), flush=True)
    if out: json.dump(risultati, open(out, 'w'), indent=1)

if __name__ == '__main__':
    main()
