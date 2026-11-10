# Quanto profitto passa dalle posizioni aperte durante la pausa giornaliera dell'oro (BCM 23:00-24:00 ora server) e costo diretto stimato di chiuderle alle 22:55.
# Da lanciare dalla cartella con oro_res.json, oro/, gtp_anni/, exp_all/ (barre M1). Uso: python3 -I pausa_giornaliera_oro.py <out.json>
import sys, json, glob, datetime as dt
src = open('/home/user/GITHUB/report/ORO_GRADINI_dati/equity_conti_oro.py').read()
exec(src[:src.index('ACC = {')])
def P(ts): return dt.datetime.strptime(ts[:19], '%Y.%m.%d %H:%M:%S') if len(ts) >= 19 else dt.datetime.strptime(ts[:16], '%Y.%m.%d %H:%M')
LIST = [('GR', 'L0'), ('GR', 'L3'), ('PH', 'L0'), ('PH', 'L1'), ('PH', 'L3'), ('GB', 'L0'), ('GB', 'L3'), ('GTP', 'COMBO')]
out = {}
for e, lv in LIST:
    tot = dict(n=0, cross=0, net=0.0, gross_cross=0.0, forgo=0.0, hold_h=[])
    per = {}
    for y in ('2013', '2018', '2020', '2025'):
        T, hi, lo, cl = m1(y); cv = CONV[y]
        dl = deals(path(e, lv, y)); pos, unm, left = positions(dl, y)
        n = 0; cross = 0; net = 0.0; gc = 0.0; fg = 0.0
        for p in pos:
            if not p['sym'].startswith('XAU'): continue
            n += 1; net += p['pnl']
            a = P(p['t0']); b = P(p['t1'])
            # primo 22:55 dopo l'apertura
            d0 = a.replace(hour=22, minute=55, second=0)
            if a >= d0: d0 += dt.timedelta(days=1)
            if d0 < b:   # la posizione e aperta alle 22:55 di quel giorno
                cross += 1
                i = int(np.searchsorted(T, np.datetime64(d0.strftime('%Y-%m-%dT%H:%M')))); i = min(i, len(T) - 1)
                sgn = 1 if p['side'] == 'buy' else -1
                partial = sgn * p['vol'] * 100 * cv * (cl[i] - p['entry'])
                gc += p['gross']; fg += p['gross'] - partial
        per[y] = dict(n=n, cross=cross, net=net, gross_cross=gc, forgo=fg)
        tot['n'] += n; tot['cross'] += cross; tot['net'] += net; tot['gross_cross'] += gc; tot['forgo'] += fg
    tot['per'] = per; del tot['hold_h']
    out['%s_%s' % (e, lv)] = tot
json.dump(out, open(sys.argv[1], 'w'), default=float)
for k, v in out.items():
    print(k, '| posizioni', v['n'], '| aperte alle 22:55', v['cross'], '(%.0f%%)' % (100 * v['cross'] / v['n']), '| netto 4 anni %.0f' % v['net'], '| profitto lordo di quelle %.0f (%.0f%% del netto)' % (v['gross_cross'], 100 * v['gross_cross'] / v['net']), '| rinuncia stimata chiudendo alle 22:55 %.0f (%.0f%% del netto)' % (v['forgo'], 100 * v['forgo'] / v['net']))
    print('     per anno:', {y: (d['cross'], round(d['forgo']), '%.0f%%' % (100 * d['forgo'] / d['net'])) for y, d in v['per'].items()})
