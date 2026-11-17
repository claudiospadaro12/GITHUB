#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""valida_fase3.py - FASE 3: i 36 set del batch 36 (disegni 1 e 2, livelli D1/H4) col simulatore, poi le porte V1-V5 (criteri sez. 10).
Uso: python3 -I valida_fase3.py DIR_DATI [DIR_DATI ...] --rif RISULTATI_BATCH36_DISEGNI_FTMO.csv"""
import argparse, csv, math, sys, time
from multiprocessing import Pool
sys.path.insert(0, __file__.rsplit('/', 1)[0])
import sim_wim as S, confronta_fase2 as C
L9 = [(0,0,0,0),(0,1,1,1),(0,2,2,2),(1,0,1,2),(1,1,2,0),(1,2,0,1),(2,0,2,1),(2,1,0,2),(2,2,1,0)]
TFS = {'D1': dict(sec=86400, cb=(10,20,40), ex1=(5,10,20), ex2=(1,3,6)), 'H4': dict(sec=14400, cb=(30,60,120), ex1=(30,60,120), ex2=(6,18,36))}
STP1 = (400,600,800); TGT1 = (1200,1700,2400); STA2 = (1.0,1.5,2.5); RR2 = (1.0,1.5,2.0)
COSTO = 3.6
XAU = EUR = None

def par_set(dis, tf, rw):
    p = S.Par(); T = TFS[tf]; p.lvl_sec = T['sec']; p.fbf = 0; p.max_trades_day = 1
    if dis == 1:
        p.entry = 'stop'; p.rearm = False; p.sl_mode = 'pts'; p.tp_mode = 'pts'
        p.sl_pts = STP1[rw[0]]; p.tp_pts = TGT1[rw[1]]; p.countback = T['cb'][rw[2]]; p.exp_bars = T['ex1'][rw[3]]
    else:
        p.entry = 'limit'; p.rearm = True; p.sl_mode = 'atr'; p.tp_mode = 'rr'
        p.countback = T['cb'][rw[0]]; p.sl_atr = STA2[rw[1]]; p.tp_rr = RR2[rw[2]]; p.exp_bars = T['ex2'][rw[3]]
    return p

def corri(args):
    dis, tf, ri = args
    p = par_set(dis, tf, L9[ri])
    t0 = time.time()
    s = S.Sim(XAU, EUR, p); s.esegui(S.epoch('2015.01.01 00:00'), S.epoch('2020.12.31 00:00'))
    n, prof, pf, _ = C.metriche(s)
    outs = [d['profit'] + d['comm'] + d['swap'] - COSTO for d in s.deals if d['dir'] == 'out']
    gp = sum(x for x in outs if x > 0); gl = -sum(x for x in outs if x < 0)
    pfn = gp / gl if gl > 0 else float('inf')
    gd = C.serie_sim(s, COSTO); v = list(gd.values()); nd = len(v); tst = float('nan')
    if nd >= 2:
        mu = sum(v) / nd; sd = math.sqrt(sum((x - mu) ** 2 for x in v) / (nd - 1))
        if sd > 0: tst = mu / (sd / math.sqrt(nd))
    return ('D%d_%s_R%d' % (dis, tf, ri + 1), n, prof, prof - COSTO * n, pfn, tst, round(time.time() - t0, 1))

def rank(v):
    o = sorted(range(len(v)), key=lambda i: v[i]); r = [0] * len(v)
    for k, i in enumerate(o): r[i] = k
    return r

def main():
    global XAU, EUR
    ap = argparse.ArgumentParser(); ap.add_argument('dirs', nargs='+'); ap.add_argument('--rif', required=True); ap.add_argument('--solo', type=int, default=0)
    a = ap.parse_args()
    XAU = C.carica_cartelle(a.dirs, 'XAUUSD'); EUR = C.carica_cartelle(a.dirs, 'EURUSD')
    lavori = [(d, tf, ri) for d in (1, 2) for tf in ('D1', 'H4') for ri in range(9)]
    if a.solo: lavori = lavori[:a.solo]
    with Pool(4) as pool: ris = pool.map(corri, lavori)
    rif = {r['id']: r for r in csv.DictReader(open(a.rif, encoding='utf-8-sig'), delimiter=';')}
    righe = []
    for (i, n, prof, net, pfn, tst, sec) in ris:
        r = rif[i]; righe.append(dict(id=i, opS=n, opM=int(r['operazioni']), netS=net, netM=float(r['profitto_netto']), pfS=pfn, pfM=float(r['PF_netto']), tS=tst, tM=float(r['t_giornaliera']), g1=r['G1'], sec=sec))
    print('%-9s %5s %5s | %9s %9s | %5s %5s | %6s %6s | %4s' % ('set', 'opM', 'opS', 'netM', 'netS', 'pfM', 'pfS', 'tM', 'tS', 'sec'))
    for r in righe: print('%-9s %5d %5d | %9.0f %9.0f | %5.2f %5.2f | %6.2f %6.2f | %4.0f' % (r['id'], r['opM'], r['opS'], r['netM'], r['netS'], r['pfM'], r['pfS'], r['tM'], r['tS'], r['sec']))
    n = len(righe)
    if n < 36: print('SOLO %d set: porte non valutabili' % n); return
    v1 = sum(1 for r in righe if (r['netM'] > 0) == (r['netS'] > 0))
    ra, rb = rank([r['netS'] for r in righe]), rank([r['netM'] for r in righe])
    sp = 1 - 6 * sum((x - y) ** 2 for x, y in zip(ra, rb)) / (n * (n * n - 1))
    topM = sorted(righe, key=lambda r: -r['netM'])[:10]; topS12 = {r['id'] for r in sorted(righe, key=lambda r: -r['netS'])[:12]}
    v3 = sum(1 for r in topM if r['id'] in topS12)
    topS_pf = [r['id'] for r in sorted(righe, key=lambda r: -r['pfS'])]
    g1ids = [r['id'] for r in righe if r['g1'] == 'OK']
    v4 = [i for i in g1ids if i in topS_pf[:8]]
    top10S = sorted(righe, key=lambda r: -r['pfS'])[:10]; v5 = sum(1 for r in top10S if r['netM'] <= 0)
    print('V1 segno uguale %d/36 (>=30): %s' % (v1, 'OK' if v1 >= 30 else 'NO'))
    print('V2 Spearman %.2f (>=0,85): %s' % (sp, 'OK' if sp >= 0.85 else 'NO'))
    print('V3 top10 MT5 nei top12 sim: %d/10 (>=7): %s' % (v3, 'OK' if v3 >= 7 else 'NO'))
    print('V4 G1-MT5 %s; nei primi 8 sim per PF: %s (tutti): %s' % (g1ids, v4, 'OK' if len(v4) == len(g1ids) and g1ids else 'NO'))
    print('V5 nei top10 sim per PF, perdenti in MT5: %d (<=2): %s' % (v5, 'OK' if v5 <= 2 else 'NO'))
    print('FILTRO VALIDO: %s' % ('SI' if (v1 >= 30 and sp >= 0.85 and v3 >= 7 and len(v4) == len(g1ids) and g1ids and v5 <= 2) else 'NO'))

if __name__ == '__main__':
    main()
