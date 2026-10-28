#!/usr/bin/env python3
"""Portafoglio ORO sommato, solo REALIZZATO (2013, 2018, 2020, 2025): netto, DD di saldo, peggior giorno realizzato, giorni per +8.000 e +4.000. Uso: python3 -I leggi_portafoglio_prop_oro_realizzato.py"""
import os
import sys, datetime as dt
exec(open(os.path.join(os.path.dirname(os.path.abspath(__file__)), 'leggi_portafoglio_prop_oro.py')).read().split('def serie(')[0])
def day(x): return dt.datetime.strptime(x['t'][:10], '%Y.%m.%d').date()
def pf(d, tgt, mind=4):
    cum = 0; n = 0
    first = min(d)
    for k in sorted(d):
        cum += d[k]; n += 1
        if cum >= tgt and n >= mind: return (k - first).days + 1
    return None
for anno in ('2013', '2018', '2020', '2025'):
    Dm = {e: E.affari_p(p) for e, p in SRC[anno].items()}
    for lab, nomi in COMBI:
        d = {}
        for e in nomi:
            for x in Dm[e]:
                if anno == '2025' and day(x) > dt.date(2025, 12, 31): continue
                d[day(x)] = d.get(day(x), 0) + x['net']
        cum = 0; pk = 0; mdd = 0; base = DEP; worst = 0; bal = DEP
        for k in sorted(d):
            r = d[k]; worst = min(worst, 100 * r / bal); bal += r; cum += r; pk = max(pk, cum); mdd = max(mdd, pk - cum)
        a = pf(d, 8000); b = pf(d, 4000)
        print('%s | %-38s netto %+7.0f | DD saldo(realizzato) %5.0f (%.1f%%) | peggior giorno realizzato %.2f%% | +8.000: %s gg, +4.000: %s gg' % (anno, lab, cum, mdd, 100 * mdd / DEP, worst, a or 'no', b or 'no'))
