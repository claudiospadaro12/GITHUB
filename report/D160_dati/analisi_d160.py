import json, re, collections, statistics as S
r160 = json.load(open('d160_oro.json'))
T = {}
for l in open('../ORO_GRADINI_dati/oro_table.txt'):
    m = re.match(r'(L\d)_(GB|PH|GR)_80000_(\d{4}) OK .*?ops(\d+) net(-?[\d.]+) PF([\d.]+) DDe([\d.]+)%/\S+ rel([\d.]+) fin\S+ SO(\d+) NM(\d+) q\d+ minlot(\d+)/\d+ max([\d.]+) wd(-?[\d.]+)', l)
    if m:
        T[(m[1], m[2], m[3])] = dict(ops=int(m[4]), net=float(m[5]), ddr=float(m[8]), maxlot=float(m[12]), wd=float(m[13]), minlot=int(m[11]))
NOISY = {('L1', 'PH'), ('L0', 'PH'), ('L3', 'GR')}
comp = [('L0', 'GB'), ('L3', 'GB'), ('L1', 'PH'), ('L0', 'PH'), ('L3', 'GR')]
out = []; cells = []
for lv, ea in comp:
    for y in ('2013', '2020', '2025'):
        b = T[(lv, ea, y)]
        reps = [r160[k] for k in sorted(r160) if k.startswith('D160_R') and ('_%s_%s_160000_%s' % (lv, ea, y)) in k and r160[k]['has_htm']]
        nets = [x['net'] for x in reps]
        mean = sum(nets) / len(nets)
        R = mean / b['net']
        ddr = sum(x['rel'] for x in reps) / len(reps); dd = ddr - b['ddr']
        ml = sum(x['maxlot'] for x in reps) / len(reps) / b['maxlot']
        opsr = sum(x['ops'] for x in reps) / len(reps) / b['ops']
        spread = (max(nets) - min(nets)) / mean if len(nets) > 1 else 0
        noisy = (lv, ea) in NOISY
        if noisy:
            band = max(0.10, 2 * spread)
            if abs(R - 2) <= band and abs(dd) <= 1 + 0: v = 'SCALA'
            elif abs(R - 2) <= 2 * band and abs(dd) <= 2: v = 'SCALA CON SCARTO'
            else: v = 'NON SCALA'
        else:
            if 1.90 <= R <= 2.10 and abs(dd) <= 1: v = 'SCALA'
            elif (1.80 <= R <= 2.20) and abs(dd) <= 2: v = 'SCALA CON SCARTO'
            else: v = 'NON SCALA'
        cells.append(dict(lv=lv, ea=ea, y=y, n=len(nets), net80=b['net'], net160=mean, nets=nets, R=R, dd80=b['ddr'], dd160=ddr, ddd=dd, mlr=ml, opsr=opsr, spread=spread, noisy=noisy, v=v, wd80=b['wd'], wd160=sum(x['worstday'] for x in reps) / len(reps), min80=b['minlot'], min160=sum(x['minlot'] for x in reps) / len(reps)))
for c in cells:
    print(f"{c['lv']}_{c['ea']}_{c['y']} n{c['n']} 80k {c['net80']:9.0f} 160k {c['net160']:9.0f} R {c['R']:.3f} DD {c['dd80']:.2f}->{c['dd160']:.2f} ({c['ddd']:+.2f}) maxlot x{c['mlr']:.2f} ops x{c['opsr']:.2f} spread {100*c['spread']:.1f}% 0.01lot {c['min80']}/{c['min160']:.0f} wd {c['wd80']:.0f}->{c['wd160']:.0f} {'rum' if c['noisy'] else 'det'} {c['v']}")
cnt = collections.Counter(c['v'] for c in cells); print(cnt)
det = [c for c in cells if not c['noisy']]; rum = [c for c in cells if c['noisy']]
print('det SCALA', sum(c['v'] == 'SCALA' for c in det), '/', len(det), ' rum SCALA', sum(c['v'] == 'SCALA' for c in rum), '/', len(rum))
print('R<2 in', sum(c['R'] < 2 for c in cells), '/', len(cells), ' |ddd|<=1 in', sum(abs(c['ddd']) <= 1 for c in cells), ' maxlot 1.9-2.1 in', sum(1.9 <= c['mlr'] <= 2.1 for c in cells))
print('rep spread>5% in', sum(c['spread'] > .05 for c in rum), '/', len(rum))
json.dump(cells, open('d160_celle.json', 'w'), default=float)
# per componente: R medio ponderato (somma netti)
for lv, ea in comp:
    cs = [c for c in cells if c['lv'] == lv and c['ea'] == ea]
    print(lv, ea, 'R aggregato (somma 3 anni)', round(sum(c['net160'] for c in cs) / sum(c['net80'] for c in cs), 3))
