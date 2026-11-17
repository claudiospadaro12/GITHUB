#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""confronta_fase2.py - FASE 2 della calibrazione: 9 set del disegno 3 sul 2015-2020 contro i risultati MT5 (RISULTATI_BATCH9_DISEGNO3_FTMO.csv).
Porte (criteri CLAU12_SIMULATORE_PYTHON_CRITERI, sez. 4), per OGNI set: operazioni +-2%, profitto del tester +-3%, PF del tester +-0,05,
correlazione dei profitti giornalieri >= 0,98 (serie MT5 'data;profitto_netto' nella cartella serie, se fornita).
DEFINIZIONI (fissate prima dei numeri): operazioni = posizioni chiuse; profitto del tester = somma su ogni posizione di profitto + swap + 2 commissioni;
PF del tester = utili lordi / perdite lorde delle posizioni, ciascuna con swap e commissioni (net = gross profit + gross loss come nel report MT5);
serie giornaliera = per ogni uscita: profitto + commissione dell'uscita + swap - 3,6 EUR (come lo script del batch), sommata per giorno; correlazione di Pearson
su tutti i giorni di calendario tra il primo e l'ultimo (zero nei giorni senza uscite). Periodo: 2015-01-01 -> 2020-12-31 ESCLUSA (come ToDate del tester).
Uso: python3 -I confronta_fase2.py DIR_DATI [DIR_DATI ...] --rif RISULTATI_BATCH9.csv [--serie DIR_SERIE] [--fine 2020.12.31]"""
import argparse, csv, glob, math, re, sys
sys.path.insert(0, __file__.rsplit('/', 1)[0])
import sim_wim as S

def carica_cartelle(dirs, simbolo):
    d = {}
    for dd in dirs:
        for f in sorted(glob.glob(dd + '/ABTG_M1_%s_*.csv' % simbolo)):
            m = S.carica_m1(f)
            for i, t in enumerate(m['t']):
                d[t] = (m['o'][i], m['h'][i], m['l'][i], m['c'][i], m['s'][i])
    ks = sorted(d)
    return dict(t=ks, o=[d[k][0] for k in ks], h=[d[k][1] for k in ks], l=[d[k][2] for k in ks], c=[d[k][3] for k in ks], s=[d[k][4] for k in ks])

def leggi_rif(path):
    out = []
    for r in csv.DictReader(open(path, encoding='utf-8-sig'), delimiter=';'):
        m = re.match(r'stop ([\d.]+)% target ([\d.]+)% cb (\d+) FBF (\w+)', r['fattori'])
        fbf = {'spento': 0, 'H1': 1, 'H4': 2}[m.group(4)]
        out.append(dict(id=r['id'], sl=float(m.group(1)), tp=float(m.group(2)), cb=int(m.group(3)), fbf=fbf,
                        ops=int(r['operazioni']), prof=float(r['profitto_tester']), pf=float(r['PF_tester'])))
    return out

def metriche(s):
    pos = []
    for tr in s.trades:
        pos.append(tr['profit'] + tr['swap'] + tr['comm'])
    gp = sum(x for x in pos if x > 0); gl = -sum(x for x in pos if x < 0)
    pf = gp / gl if gl > 0 else float('inf')
    pf_alt = (sum(t['profit'] for t in s.trades if t['profit'] > 0) / max(-sum(t['profit'] for t in s.trades if t['profit'] < 0), 1e-9))
    return len(pos), sum(pos), pf, pf_alt

def serie_sim(s, costo=3.6):
    g = {}
    for d in s.deals:
        if d['dir'] != 'out': continue
        k = S.fmt(d['t'])[:10]
        g[k] = g.get(k, 0.0) + d['profit'] + d['comm'] + d['swap'] - costo
    return g

def leggi_serie(path):
    g = {}
    for r in csv.reader(open(path, encoding='utf-8-sig'), delimiter=';'):
        if r and r[0][:1].isdigit(): g[r[0]] = float(r[1].replace(',', '.'))
    return g

def correlazione(a, b, d0, d1):
    from datetime import date, timedelta
    x = []; y = []
    dd = date(d0[0], d0[1], d0[2])
    while dd <= date(d1[0], d1[1], d1[2]):
        k = dd.strftime('%Y.%m.%d'); x.append(a.get(k, 0.0)); y.append(b.get(k, 0.0)); dd += timedelta(days=1)
    n = len(x); mx = sum(x) / n; my = sum(y) / n
    sxy = sum((p - mx) * (q - my) for p, q in zip(x, y)); sxx = sum((p - mx) ** 2 for p in x); syy = sum((q - my) ** 2 for q in y)
    return sxy / math.sqrt(sxx * syy) if sxx > 0 and syy > 0 else float('nan')

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('dirs', nargs='+'); ap.add_argument('--rif', required=True); ap.add_argument('--serie', default=None)
    ap.add_argument('--da', default='2015.01.01'); ap.add_argument('--fine', default='2020.12.31')
    ap.add_argument('--solo', default=None, help='solo questi id (es. D3_R1,D3_R2)')
    ap.add_argument('--parametri', default=None, help='JSON o chiave=valore,... per Par (solo per le correzioni dichiarate)')
    a = ap.parse_args()
    xau = carica_cartelle(a.dirs, 'XAUUSD'); eur = carica_cartelle(a.dirs, 'EURUSD')
    print('barre XAUUSD %d (%s .. %s), EURUSD %d' % (len(xau['t']), S.fmt(xau['t'][0]), S.fmt(xau['t'][-1]), len(eur['t'])))
    rif = leggi_rif(a.rif)
    if a.solo: rif = [r for r in rif if r['id'] in a.solo.split(',')]
    t0 = S.epoch(a.da + ' 00:00'); t1 = S.epoch(a.fine + ' 00:00')
    ok_tot = 0
    print('%-6s %5s %5s %7s | %9s %9s %7s | %5s %5s %7s | %6s | esito' % ('set', 'opR', 'opS', 'd_ops%', 'profR', 'profS', 'd_pr%', 'pfR', 'pfS', 'd_pf', 'corr'))
    for r in rif:
        p = S.Par(); p.sl_pct, p.tp_pct, p.countback, p.fbf = r['sl'], r['tp'], r['cb'], r['fbf']
        if a.parametri:
            for kv in a.parametri.split(','):
                k, v = kv.split('='); setattr(p, k, type(getattr(p, k))(v))
        s = S.Sim(xau, eur, p); s.esegui(t0, t1)
        n, prof, pf, pf_alt = metriche(s)
        d_ops = (n - r['ops']) / r['ops'] * 100; d_pr = (prof - r['prof']) / abs(r['prof']) * 100 if r['prof'] else float('nan'); d_pf = pf - r['pf']
        corr = float('nan')
        if a.serie:
            try:
                ms = leggi_serie('%s/%s.csv' % (a.serie, r['id']))
                y0, y1 = a.da.split('.'), a.fine.split('.')
                corr = correlazione(serie_sim(s), ms, tuple(map(int, y0)), tuple(map(int, y1)))
            except FileNotFoundError:
                pass
        g_ops = abs(d_ops) <= 2.0; g_pr = abs(d_pr) <= 3.0; g_pf = abs(d_pf) <= 0.05; g_co = (corr >= 0.98) if not math.isnan(corr) else None
        ok = g_ops and g_pr and g_pf and (g_co is not False)
        ok_tot += 1 if (ok and g_co) else 0
        print('%-6s %5d %5d %+6.1f%% | %9.2f %9.2f %+6.1f%% | %5.2f %5.2f %+6.2f | %6s | ops %s prof %s pf %s corr %s (PF alt %.2f)' % (
            r['id'], r['ops'], n, d_ops, r['prof'], prof, d_pr, r['pf'], pf, d_pf, ('%.3f' % corr) if not math.isnan(corr) else 'n.d.',
            'OK' if g_ops else 'NO', 'OK' if g_pr else 'NO', 'OK' if g_pf else 'NO', {True: 'OK', False: 'NO', None: 'n.d.'}[g_co], pf_alt))
    print('SET CHE PASSANO TUTTE LE PORTE (correlazione inclusa): %d su %d' % (ok_tot, len(rif)))

if __name__ == '__main__':
    main()
