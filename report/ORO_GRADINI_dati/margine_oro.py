# Margine dell'oro a leva 1:100, 1:30 (Swing) e 1:9 (ipotesi della nota di Massimo, NON verificata) per conti solo oro a 80k, calcolato dai report esistenti (lotti aperti contemporaneamente x prezzo x 100 oz / leva) contro l'equity ricostruita.
# Da lanciare dalla cartella con oro_res.json, oro/, gtp_anni/, exp_all/. Uso: python3 -I margine_oro.py <out.json>
import sys, json, glob
src = open('/home/user/GITHUB/report/ORO_GRADINI_dati/equity_conti_oro.py').read()
exec(src[:src.index('res = {}')])
LEV = (100, 30, 9)
out = {}
for name, mem in ACC.items():
    out[name] = {}
    for y in ('2013', '2018', '2020', '2025'):
        T, hi, lo, cl = m1(y); n = len(T); cv = CONV[y]
        lots = np.zeros(n); adv = 0
        for e, lv in mem:
            dl = deals(path(e, lv, y)); pos, unm, left = positions(dl, y)
            def idx(ts):
                t = np.datetime64(ts.replace('.', '-', 2).replace(' ', 'T')[:16]); return min(int(np.searchsorted(T, t)), n - 1)
            for p in pos:
                if p['sym'].startswith('XAU'):
                    i0 = idx(p['t0']); i1 = idx(p['t1'])
                    if i1 > i0: lots[i0:i1] += p['vol']
            a, c, _T, info = ea_eq(e, lv, y); adv = adv + a
        eq = DEP + adv
        r = dict(lotti_max=float(lots.max()))
        notional_eur = lots * 100 * cl * cv     # valore nozionale in EUR
        for L in LEV:
            m = notional_eur / L
            used = np.where(m > 0, m / np.maximum(eq, 1), 0)
            lvl = np.where(m > 0, eq / np.maximum(m, 1e-9), np.inf)
            r['L%d' % L] = dict(margine_max_pct_equity=float(100 * used.max()), livello_min_pct=float(100 * np.min(lvl[m > 0])) if (m > 0).any() else None, margine_max_eur=float(m.max()))
        r['prezzo_alla_punta'] = float(cl[int(np.argmax(lots))])
        out[name][y] = r
json.dump(out, open(sys.argv[1], 'w'))
for name, v in out.items():
    print(name)
    for y, r in v.items():
        print('   ', y, 'lotti aperti max %.2f' % r['lotti_max'], '| margine max/equity: 1:100 %.0f%%, 1:30 %.0f%%, 1:9 %.0f%%' % (r['L100']['margine_max_pct_equity'], r['L30']['margine_max_pct_equity'], r['L9']['margine_max_pct_equity']), '| livello margine min 1:30 %.0f%%' % r['L30']['livello_min_pct'], '| margine max 1:30 EUR %.0f' % r['L30']['margine_max_eur'])
