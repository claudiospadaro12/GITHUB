#!/usr/bin/env python3
"""Breaking Band (Alfio Bardolla Training Group, Checklist 15/02/2026) sull'oro: test su barre M1 BCM con spread.
Criteri e regole: report/BREAKING_BAND_TEST_CRITERI_2026-11-01.md (scritti prima dei numeri).
Uso: python3 -I breaking_band_test.py <cartella con ABTG_M1_XAUUSD_2013.csv, _2018, _2020, ABTG_M1_XAUUSD.csv> [--json out.json]
Nessun parametro ottimizzato: 4 varianti (continuazione/inversione x H1/M15)."""
import sys, os, json, math, collections
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from golden_cross_ha_test import FILES, carica, barre  # stessa lettura dati del test Golden Cross

MAXHOLD = 150  # barre: chiusura forzata (regola mia, non del metodo)
FUNNEL = collections.Counter()

def sma(x, n):
    r = [None] * len(x); s = 0.0
    for i, v in enumerate(x):
        s += v
        if i >= n: s -= x[i - n]
        if i >= n - 1: r[i] = s / n
    return r

def indic(B):
    n = len(B); O = [b[1] for b in B]; H = [b[2] for b in B]; L = [b[3] for b in B]; C = [b[4] for b in B]
    m = sma(C, 20); sd = [None] * n
    for i in range(19, n):
        mu = m[i]; sd[i] = math.sqrt(sum((C[j] - mu) ** 2 for j in range(i - 19, i + 1)) / 20)
    up = [None if sd[i] is None else m[i] + 2 * sd[i] for i in range(n)]
    lo = [None if sd[i] is None else m[i] - 2 * sd[i] for i in range(n)]
    w = [None if sd[i] is None else 4 * sd[i] for i in range(n)]
    sdv = [v if v is not None else 0.0 for v in sd]
    sdsma = [None] * n; s = 0.0
    for i in range(n):
        s += sdv[i]
        if i >= 50: s -= sdv[i - 50]
        if i >= 19 + 49: sdsma[i] = s / 50
    tr = [H[0] - L[0]] + [max(H[i] - L[i], abs(H[i] - C[i - 1]), abs(L[i] - C[i - 1])) for i in range(1, n)]
    atr = [0.0] * n
    for i in range(n):
        atr[i] = sum(tr[max(0, i - 13):i + 1]) / min(i + 1, 14)
    sma50 = sma(C, 50)
    return dict(O=O, H=H, L=L, C=C, m=m, sd=sd, up=up, lo=lo, w=w, sdsma=sdsma, atr=atr, sma50=sma50, n=n)

def r2(y):
    n = len(y); x = list(range(n)); mx = (n - 1) / 2; my = sum(y) / n
    sxx = sum((a - mx) ** 2 for a in x); sxy = sum((a - mx) * (b - my) for a, b in zip(x, y)); syy = sum((b - my) ** 2 for b in y)
    return 0.0 if sxx == 0 or syy == 0 else (sxy * sxy) / (sxx * syy)

def mirror(I, d):
    """per d=-1 specchia i prezzi (per trattare ribasso come rialzo): ritorna una vista con O,H,L,C, m, up, lo invertiti."""
    if d == 1: return I
    J = dict(I)
    J['O'] = [-v for v in I['O']]; J['C'] = [-v for v in I['C']]
    J['H'] = [-v for v in I['L']]; J['L'] = [-v for v in I['H']]
    J['m'] = [None if v is None else -v for v in I['m']]
    J['up'] = [None if v is None else -v for v in I['lo']]
    J['lo'] = [None if v is None else -v for v in I['up']]
    J['sma50'] = [None if v is None else -v for v in I['sma50']]
    return J

def bulge(J, i):
    """bulge rialzista che finisce alla barra i. ritorna s oppure None."""
    if i < 130 or J['w'][i] is None: return None
    C, H, L = J['C'], J['H'], J['L']
    lo20 = max(0, i - 19)
    s = min(range(lo20, i), key=lambda k: C[k])
    if s >= i - 1: return None
    atr = J['atr'][s]
    if atr <= 0 or J['w'][s] is None or J['w'][s] <= 0: return None
    FUNNEL['bulge_prova'] += 1
    if not (J['w'][i] >= 2.0 * J['w'][s]): return None
    FUNNEL['b1_bande_aperte'] += 1
    if J['sdsma'][i] is None or not (J['sd'][i] > J['sdsma'][i]): return None
    FUNNEL['b2_sd_sopra_sma50'] += 1
    if not any(1.5 * atr <= H[k] - L[k] <= 3.0 * atr for k in range(s + 1, i + 1)): return None
    FUNNEL['b3_candela_impulsiva'] += 1
    net = C[i] - C[s]; path = sum(abs(C[k] - C[k - 1]) for k in range(s + 1, i + 1))
    if not (net >= 2.5 * atr and path > 0 and net / path >= 0.5): return None
    FUNNEL['b4_netto'] += 1
    if not (C[i] - J['m'][i] >= 1.5 * atr): return None
    FUNNEL['b5_mediana_lontana'] += 1
    return s

def congestione(J, s):
    """ritorna (tipo, frazione criteri SI) con tipo 'CS','CDA' o None."""
    C, H, L = J['C'], J['H'], J['L']; w = J['w']; atr = J['atr'][s]
    if s < 60 or w[s - 20] is None: return None, 0.0
    rng = [H[k] - L[k] for k in range(s - 39, s + 1)]
    cs = [w[s] <= 0.8 * w[s - 20],
          sum(rng[20:]) / 20 <= sum(rng[:20]) / 20,
          abs(C[s] - C[s - 20]) <= 1.5 * atr,
          all(r <= 1.5 * atr for r in rng[20:]),
          J['sdsma'][s] is not None and J['sd'][s] < J['sdsma'][s]]
    if sum(cs) >= 4: return 'CS', sum(cs) / 5
    sd = J['sd']
    cda = [sum(1 for k in range(s - 9, s + 1) if sd[k] < sd[k - 1]) >= 7 and sd[s] < sd[s - 10],
           J['sdsma'][s] is not None and sd[s] < J['sdsma'][s],
           w[s - 15] is not None and w[s] <= 0.85 * w[s - 15],
           all((H[k] - L[k]) <= 1.5 * atr for k in range(s - 14, s + 1)),
           r2(C[s - 14:s + 1]) >= 0.5]
    if all(cda): return 'CDA', 1.0
    return None, sum(cda) / 5

def solid(parti):
    pesi = dict(cong=25, bulge=25, rientro=20, bande=15, test=10, conferme=5)
    return sum(pesi[k] * parti[k] for k in pesi)

def cerca(J, tipo, I_orig):
    """ritorna lista di segnali (j = barra del test/retest, solidita) per bulge rialzista nella vista J. tipo 'CONT' o 'INV'."""
    n = J['n']; C, H, L, O = J['C'], J['H'], J['L'], J['O']; sig = []; ultimo = -99
    for i in range(130, n - 25):
        if i - ultimo < 30: continue
        s = bulge(J, i)
        if s is None: continue
        FUNNEL['bulge_ok'] += 1
        ultimo = i
        p = max(range(i, i + 4), key=lambda k: H[k])
        tcong, fcong = congestione(J, s)
        if tcong is None: FUNNEL['congestione_no'] += 1; continue
        FUNNEL['congestione_ok'] += 1
        atr = J['atr'][i]; imp_rng = sum(H[k] - L[k] for k in range(s + 1, i + 1)) / (i - s)
        toccato_mediana = False; trovato = None
        for j in range(p + 1, min(p + 16, n - 2)):
            rj = H[j] - L[j]
            if tipo == 'CONT' and rj > 1.5 * atr: FUNNEL[tipo + '_invalid_candela'] += 1; break
            if tipo == 'INV' and rj > 1.0 * atr: FUNNEL[tipo + '_invalid_candela'] += 1; break
            if tipo == 'INV' and L[j] <= J['lo'][j]: FUNNEL[tipo + '_invalid_banda_opposta'] += 1; break
            if L[j] <= J['m'][j]: toccato_mediana = True
            if tipo == 'CONT' and j - p >= 3 and L[j] <= J['lo'][j]: trovato = j; break
            if tipo == 'INV' and toccato_mediana and H[j] >= J['up'][j] and j - p >= 3: trovato = j; break
        if trovato is None: FUNNEL[tipo + '_nessun_test'] += 1; continue
        j = trovato; FUNNEL[tipo + '_test_trovato'] += 1
        if any(L[k] <= J['lo'][k] for k in range(s, p + 1)) and tipo == 'INV': FUNNEL['INV_contatto_precedente'] += 1; continue
        # ritracciamento: criteri
        rt = range(p + 1, j + 1)
        ombre_ok = sum(1 for k in rt if (H[k] - max(O[k], C[k])) <= 1.5 * max(abs(C[k] - O[k]), 1e-9) and (min(O[k], C[k]) - L[k]) <= 1.5 * max(abs(C[k] - O[k]), 1e-9)) / len(rt)
        crit = [sum(H[k] - L[k] for k in rt) / len(rt) <= 0.7 * imp_rng,
                all(H[k] - L[k] <= 1.5 * atr for k in rt),
                ombre_ok >= 0.8,
                max(H[k] for k in rt) <= H[p],
                J['w'][j] < J['w'][p]]
        frie = sum(crit) / len(crit)
        if frie < 0.8: FUNNEL[tipo + '_rientro_no'] += 1; continue
        FUNNEL[tipo + '_rientro_ok'] += 1
        # banda al test
        if tipo == 'CONT':
            lo3 = J['lo'][j] - J['lo'][j - 3]  # banda opposta (inferiore) non richiede nulla; invalidazioni: inclinata contro (cioe scende molto) / si gonfia
            gonfia = J['w'][j] > 1.1 * J['w'][j - 3]
            inclin = (J['up'][j] - J['up'][j - 3]) > 0.3 * atr   # banda del bulge ancora in salita forte = contro
            bande = [not gonfia, J['w'][j] < J['w'][p]]
            test = [True, (H[j] - L[j]) <= 1.5 * atr]
            inval = gonfia or inclin or not (J['sdsma'][j] is not None and J['sd'][j] < J['sdsma'][j])
        else:
            gonfia = J['w'][j] > 1.1 * J['w'][j - 3]
            piatta = (J['up'][j] - J['up'][j - 3]) <= 0.1 * atr
            inclin = (J['up'][j] - J['up'][j - 3]) > 0.3 * atr
            bande = [not gonfia, piatta]
            test = [True, not any(L[k] <= J['lo'][k] for k in range(s, j + 1)), piatta]
            inval = gonfia or inclin or not (J['sdsma'][j] is not None and J['sd'][j] < J['sdsma'][j])
        if inval: FUNNEL[tipo + '_invalidazione_banda_sd'] += 1; continue
        if not all(test): FUNNEL[tipo + '_test_no'] += 1; continue
        FUNNEL[tipo + '_VALIDO'] += 1
        conf = [J['sd'][j] < J['sd'][j - 1], J['sdsma'][j] is not None and J['sd'][j] < J['sdsma'][j],
                (J['sma50'][j] - J['sma50'][j - 3]) >= 0, True]
        parti = dict(cong=fcong, bulge=1.0, rientro=frie, bande=sum(bande) / len(bande), test=sum(test) / len(test), conferme=sum(conf) / len(conf))
        sig.append((j, solid(parti), tcong))
    return sig

def simula(m1, B, I, d, tipo, sig, tf):
    """d=+1: bulge rialzista. CONT: long; INV: short. d=-1 specchiato: CONT short, INV long."""
    t, o, h, l, c, sp = m1; n = len(B)
    side = (1 if tipo == 'CONT' else -1) * d
    out = []; libero = -1
    for (j, sol, tc) in sig:
        if j <= libero or j + 1 >= n: continue
        i0 = B[j + 1][5]; px = o[i0]; spr = sp[i0]
        atr = I['atr'][j]
        entry = px + spr if side == 1 else px
        risk = 3 * atr
        stop = entry - risk if side == 1 else entry + risk
        target = I['m'][j]
        if (side == 1 and target <= entry) or (side == -1 and target >= entry): FUNNEL['target_gia_superato'] += 1; continue
        k = j + 1; res = None; usc_barre = 0
        while k < n and k <= j + MAXHOLD:
            for q in range(B[k][5], B[k][6] + 1):
                if side == 1:
                    if l[q] <= stop: res = ('SL', stop); break
                    if h[q] >= target: res = ('TP', target); break
                else:
                    if h[q] + sp[q] >= stop: res = ('SL', stop); break
                    if l[q] + sp[q] <= target: res = ('TP', target); break
            if res: break
            if (k - j) % 3 == 0 and k + 1 < n:
                target = I['m'][k]
                if (side == 1 and target <= c[B[k][6]]) or (side == -1 and target >= c[B[k][6]]): pass
            k += 1
        if not res:
            kk = min(k, n - 1); q = B[kk][6]
            res = ('TF', c[q] if side == 1 else c[q] + sp[q]); FUNNEL['chiusura_forzata_%d' % MAXHOLD] += 1
        pnl = (res[1] - entry) if side == 1 else (entry - res[1])
        out.append(dict(j=j, esito=res[0], R=pnl / risk, costoR=spr / risk if side == 1 else sp[B[j + 1][5]] / risk, sol=sol, side=side, barre=min(k, n - 1) - j))
        libero = min(k, n - 1)
    return out

def stat(tr):
    if not tr: return dict(n=0)
    w = [x['R'] for x in tr if x['R'] > 0]; ls = [-x['R'] for x in tr if x['R'] <= 0]
    pf = (sum(w) / sum(ls)) if ls and sum(ls) > 0 else float('inf')
    return dict(n=len(tr), win=100.0 * len(w) / len(tr), pf=pf, nettoR=sum(x['R'] for x in tr), costoR=sum(x['costoR'] for x in tr),
                avgW=(sum(w) / len(w) if w else 0), avgL=(sum(ls) / len(ls) if ls else 0), sl=sum(1 for x in tr if x['esito'] == 'SL'), tf=sum(1 for x in tr if x['esito'] == 'TF'))

def main():
    if len(sys.argv) < 2: print(__doc__); sys.exit(1)
    cart = sys.argv[1]; out = sys.argv[sys.argv.index('--json') + 1] if '--json' in sys.argv else None
    dati = {lab: carica(os.path.join(cart, f)) for lab, f in FILES}
    ris = {}
    for tf_nome, tf in (('H1', 60), ('M15', 15)):
        prep = {}
        for lab in dati:
            B = barre(dati[lab], tf); prep[lab] = (B, indic(B))
        for tipo in ('CONT', 'INV'):
            nome = '%s_%s' % (tipo, tf_nome); per = {}; tutti = []
            for lab in dati:
                B, I = prep[lab]
                tr = []
                for d in (1, -1):
                    J = mirror(I, d)
                    sig = cerca(J, tipo, I)
                    tr += simula(dati[lab], B, I if d == 1 else J if False else I, d, tipo, sig, tf) if d == 1 else simula_spec(dati[lab], B, I, d, tipo, sig)
                per[lab] = stat(tr); tutti += tr
            tt = stat(tutti)
            fasce = {'70-84': stat([x for x in tutti if 70 <= x['sol'] < 85]), '85-100': stat([x for x in tutti if x['sol'] >= 85]), '<70': stat([x for x in tutti if x['sol'] < 70])}
            ris[nome] = dict(per_periodo=per, totale=tt, fasce=fasce)
            print('%-9s n=%4d win %.1f%% PF %.2f netto %+.1fR costoSpread %.1fR mediaW %.2fR mediaL %.2fR SL=%d TF=%d' % (nome, tt['n'], tt.get('win', 0), tt.get('pf', 0), tt.get('nettoR', 0), tt.get('costoR', 0), tt.get('avgW', 0), tt.get('avgL', 0), tt.get('sl', 0), tt.get('tf', 0)), flush=True)
            for lab in dati: print('   %-8s %s' % (lab, per[lab]))
            for k, v in fasce.items(): print('   solidita %-7s %s' % (k, v))
    print('\nIMBUTO (conteggi cumulati su H1+M15, 4 periodi, 2 direzioni, CONT+INV):')
    for k in sorted(FUNNEL): print('  %-34s %d' % (k, FUNNEL[k]))
    if out: json.dump(ris, open(out, 'w'), indent=1, default=str)

def simula_spec(m1, B, I, d, tipo, sig):
    return simula(m1, B, I, d, tipo, sig, 0)

if __name__ == '__main__':
    main()
