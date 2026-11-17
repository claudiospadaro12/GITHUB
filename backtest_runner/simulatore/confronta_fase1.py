#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""confronta_fase1.py - fase 1 della calibrazione: confronta il simulatore con il riferimento MT5 (2 set x gen-mar 2019, trade per trade).
Porte (criteri CLAU12_SIMULATORE_PYTHON_CRITERI, sezione 4): (a) 14/14 trade con stesso verso e tipo di uscita; (b) ordini identici al centesimo
>= 95%; (c) orari entro 1 minuto in >= 13/14 trade; (d) P&L per trade entro 2% o 0,30 EUR."""
import re, sys, importlib
sys.path.insert(0, __file__.rsplit('/', 1)[0])
import sim_wim as S

def parse_rif(path):
    txt = open(path, encoding='utf-8-sig').read().split('\n')
    sez = []; cur = None; mod = None
    for r in txt:
        if r.startswith('=== DISEGNO 3 riga'):
            cur = dict(titolo=r, ordini=[], deals=[]); sez.append(cur); mod = None; continue
        if cur is None: continue
        if r.startswith('--- ORDINI'): mod = 'o'; continue
        if r.startswith('--- OPERAZIONI'): mod = 'd'; continue
        if r.startswith('Righe ordini') or r.startswith('--- JOURNAL'): mod = None; continue
        if mod and ' | ' in r:
            f = [x.strip() for x in r.split(' | ')]
            if mod == 'o' and len(f) >= 10 and f[3] in ('buy stop', 'sell stop', 'buy', 'sell'):
                cur['ordini'].append(f)
            if mod == 'd' and len(f) >= 12 and f[3] in ('buy', 'sell') and f[4] in ('in', 'out'):
                cur['deals'].append(f)
    return sez

def num(s):
    return float(s.replace(' ', '').replace(' ', '')) if s not in ('', None) else 0.0

def t_ep(s):  # '2019.01.02 07:18:40'
    return S.epoch(s[:16]) + int(s[17:19])

def trade_rif(deals):
    out = []; ap = None
    for f in deals:
        d = dict(t=t_ep(f[0]), buy=(f[3] == 'buy'), dir=f[4], prezzo=num(f[6]), comm=num(f[8]), swap=num(f[9]), profit=num(f[10]), comm_txt=f[12] if len(f) > 12 else '')
        if d['dir'] == 'in': ap = d
        elif ap is not None:
            out.append(dict(t_in=ap['t'], t_out=d['t'], buy=ap['buy'], p_in=ap['prezzo'], p_out=d['prezzo'], profit=d['profit'], swap=d['swap'], motivo=d['comm_txt'] or 'fbf')); ap = None
    return out

def motivo_rif(m):
    m = m.lower()
    return 'sl' if m.startswith('sl') else 'tp' if m.startswith('tp') else 'fbf'

def esegui_set(sez, xau, eur, cb, tp, fbf, par_mod=None):
    p = S.Par(); p.countback, p.tp_pct, p.fbf = cb, tp, fbf
    if par_mod: par_mod(p)
    s = S.Sim(xau, eur, p)
    s.esegui(S.epoch('2019.01.01 00:00'), S.epoch('2019.04.01 00:00'))
    return s

def confronta(sez, s, nome, verboso=True):
    rif = trade_rif(sez['deals']); sim = s.trades
    print('=== %s: riferimento %d trade, simulatore %d trade; ordini rif %d, sim %d' % (nome, len(rif), len(sim), len(sez['ordini']), len(s.ordini)))
    ok_trade = ok_ora = ok_pnl = 0
    n = max(len(rif), len(sim))
    for i in range(n):
        r = rif[i] if i < len(rif) else None; q = sim[i] if i < len(sim) else None
        riga = ''
        if r: riga += 'RIF %s %s %.2f -> %s %.2f %s %.2f' % (S.fmt(r['t_in'])[5:], 'B' if r['buy'] else 'S', r['p_in'], S.fmt(r['t_out'])[5:], r['p_out'], motivo_rif(r['motivo']), r['profit'])
        if q: riga += '  | SIM %s %s %.2f -> %s %.2f %s %.2f' % (S.fmt(q['t_in'])[5:], 'B' if q['buy'] else 'S', q['p_in'], S.fmt(q['t_out'])[5:], q['p_out'], q['motivo'], q['profit'])
        if r and q:
            stesso = (r['buy'] == q['buy'] and motivo_rif(r['motivo']) == q['motivo'])
            ora = abs(r['t_in'] - q['t_in']) <= 60 and abs(r['t_out'] - q['t_out']) <= 60
            tol = max(0.02 * abs(r['profit']), 0.30)
            pnl = abs(r['profit'] - q['profit']) <= tol
            ok_trade += stesso; ok_ora += ora; ok_pnl += pnl
            riga += '   [%s%s%s]' % ('T' if stesso else '-', 'O' if ora else '-', 'P' if pnl else '-')
        if verboso: print(riga)
    return len(rif), ok_trade, ok_ora, ok_pnl

def ordini_match(sez, s):
    # ordini piazzati (non scadenza): confronta tempo di piazzamento e prezzi (ordine stop, sl, tp)
    rif = [(t_ep(f[0]), f[3], num(f[5]), num(f[6]), num(f[7])) for f in sez['ordini'] if 'stop' in f[3]]
    sim = [(o['t'], 'buy stop' if o['buy'] else 'sell stop', o['prezzo'], o['sl'], o['tp']) for o in s.ordini]
    ok = 0
    for r in rif:
        if any(abs(r[0] - q[0]) <= 60 and r[1] == q[1] and abs(r[2] - q[2]) < 0.005 and abs(r[3] - q[3]) < 0.005 and abs(r[4] - q[4]) < 0.005 for q in sim): ok += 1
    return ok, len(rif)

if __name__ == '__main__':
    base = sys.argv[1]; rif = sys.argv[2]
    xau = S.carica_m1(base + '/ABTG_M1_XAUUSD_2018.csv'); eur = S.carica_m1(base + '/ABTG_M1_EURUSD_2018.csv')
    sez = parse_rif(rif)
    cfg = [(10, 2.1, 1), (20, 3.1, 2)]
    tot = [0, 0, 0, 0]; tot_ord = [0, 0]
    for z, (cb, tp, fbf) in zip(sez, cfg):
        s = esegui_set(z, xau, eur, cb, tp, fbf)
        r = confronta(z, s, z['titolo'][:70])
        o = ordini_match(z, s)
        print('ordini identici (tempo +-1 min, prezzo/SL/TP al centesimo): %d su %d' % o)
        for a in range(4): tot[a] += r[a]
        tot_ord[0] += o[0]; tot_ord[1] += o[1]
    print('TOTALE trade rif %d: stesso verso/uscita %d, orari ok %d, P&L ok %d | ordini %d/%d' % (tot[0], tot[1], tot[2], tot[3], tot_ord[0], tot_ord[1]))
