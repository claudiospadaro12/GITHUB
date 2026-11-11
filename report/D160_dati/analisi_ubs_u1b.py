#!/usr/bin/env python3
"""UBS U1b: R = DD equity BCM a 0,01 lotti / HistoricalMaxDD dichiarato, per set e per periodo. Legge SOLO i REFERTO_ANNO80K_TRANCHE.txt (non i report .htm, fino a 85 MB).
Uso: python3 -I analisi_ubs_u1b.py <cartella ANNO_ORO_GRADINI_UBSU1B_*> <zip dei set> <ubsu1.json del pilota> <out.json>"""
import re, glob, json, sys, zipfile, statistics as stt
W, ZSET, PIL, OUT = sys.argv[1:5]
SETS = {'PHd_a':'Gold_a.set','PHd_b':'Gold_b.set','PHd_c':'Gold_c.set','GR_s1_D1':'strategy1_Daily.set','GR_s2_D1':'strategy2_Daily.set','GR_s3_D1':'strategy3_Daily.set','GR_s4_H4':'strategy4_H4.set','GR_s5_H1':'strategy5_H1.set','GR_s6_H1':'strategy6_H1.set','GR_s7_H1':'strategy7_H1.set','GR_s8_H1':'strategy8_H1.set','GR_s9_H1':'strategy9_H1.set'}
for i in range(1, 10): SETS['PH_strat%d' % i] = 'Gold_Phantom_strat%d.set' % i
for x in 'ABCDEHIK': SETS['GB_daily' + x] = 'daily%s.set' % x
SETS.update({'GTP_H4b':'GOLDTRADEPROH4_b.set','GTP_E':'GOLDTRADEPRO_E.set','GTP_F':'GOLDTRADEPRO_F.set','GTP_G':'GOLDTRADEPRO_G.set','GTP_H':'GOLDTRADEPRO_H.set','GTP_a':'GOLDTRADEPRO_a.set','GTP_c':'GOLDTRADEPRO_c.set','GTP_d':'GOLDTRADEPRO_d.set'})
z = zipfile.ZipFile(ZSET); decl = {}
for n in z.namelist():
    b = z.read(n) if n.lower().endswith('.set') else None
    if b is None: continue
    t = b.decode('utf-16') if b[:2] in (b'\xff\xfe', b'\xfe\xff') else b.decode('utf-8', 'replace')
    m = re.search(r'^HistoricalMaxDD=([\d.]+)', t, re.M)
    if m and '/GOLD/' in '/' + n: decl[n.split('/')[-1]] = float(m.group(1))
rows = {}
for ref in sorted(glob.glob(W + '/*/*/REFERTO_ANNO80K_TRANCHE.txt')):
    folder = ref.split('/')[-3]
    mm = re.match(r'UBSU1B_(.+)_100000_(\d{4}-\d{4})$', folder)
    if not mm: continue
    tag, per = mm.groups()
    t = open(ref, encoding='utf-8', errors='replace').read()
    m = re.search(r'operazioni (\d+)\s+netto (-?[\d.]+)\s+PF ([\d.]+|inf|-)\s+DD equita ([\d.]+)\(([\d.]+)%\)', t)
    st = re.search(r'STATO (\w+)', t); q = re.search(r'qualita (\d+)%', t); so = re.search(r'righe stop out nei giornali (\d+), no money (\d+)', t)
    dur = re.search(r'durata (\d+) s', t); lic = 'License found' in t
    rows[(tag, per)] = dict(stato=st and st.group(1), ops=m and int(m.group(1)), net=m and float(m.group(2)), pf=m and m.group(3), dd=m and float(m.group(4)), ddp=m and float(m.group(5)), q=q and int(q.group(1)), so=so and int(so.group(1)), nm=so and int(so.group(2)), dur=dur and int(dur.group(1)), lic=lic)
# pilota 2013-2025 per i 6 gia fatti
pil = json.load(open(PIL)); PMAP = {'GB_dailyA':'GB_dailyA','GTP_a':'GTP_a','PH_strat1':'PH_strat1','GR_s1_D1':'GR_strategy1_D1','GR_s4_H4':'GR_strategy4_H4','GR_s5_H1':'GR_strategy5_H1'}
for tag, p in PMAP.items():
    for k, r in pil.items():
        if p in k and r.get('ddE') is not None:
            rows[(tag, '2013-2025')] = dict(stato=r['stato'], ops=r['ops'], net=r['net'], pf=r['pf'], dd=r['ddE'], ddp=r['ddEp'], q=r['q'], so=r['stopout'], nm=r['nomoney'], dur=None, lic=True, pilota=True)
USD = 1.15
def cl(R): return 'CONFERMA' if abs(R-1) <= .25 else ('DIFFERENTE' if abs(R-1) <= .5 else 'DIVERSO')
out = {}; tags = list(SETS)
print('%-11s %5s | %-24s | %-24s | %6s %s' % ('set', 'dich', 'A 2005-2025: DD0.01 R(EUR/USD) classe', 'B 2013-2025: DD0.01 R(EUR/USD) classe', 'A/B', 'stab'))
for tag in tags:
    d = decl.get(SETS[tag]); rec = dict(dich=d); cells = []
    for per in ('2005-2025', '2013-2025'):
        r = rows.get((tag, per))
        if r and r['dd'] is not None and r['stato'] == 'OK' and d:
            dd01 = r['dd'] / 10; R = dd01 / d; Ru = dd01 * USD / d
            rec[per] = dict(dd01=dd01, R=R, Ru=Ru, cls=cl(R), clsu=cl(Ru), net=r['net'], ops=r['ops'], q=r['q'], so=r['so'], nm=r['nm'], dur=r['dur'], ddp=r['ddp'])
            cells.append('%7.1f %.2f/%.2f %-10s' % (dd01, R, Ru, cl(R)))
        else:
            rec[per] = dict(mancante=True, stato=r and r['stato']); cells.append('%-24s' % ('-' if not r else 'NON OK ' + str(r['stato'])))
    a, b = rec['2005-2025'], rec['2013-2025']
    if 'R' in a and 'R' in b:
        ratio = a['R'] / b['R']; rec['ratio'] = ratio; rec['stab'] = 'STABILE' if abs(ratio - 1) < .5 else 'INSTABILE'
        rs = '%.2f %s' % (ratio, rec['stab'])
    else: rs = ''
    out[tag] = rec
    print('%-11s %5s | %s | %s | %s' % (tag, d, cells[0], cells[1], rs))
Ra = [v['2005-2025']['R'] for v in out.values() if 'R' in v['2005-2025']]
if Ra: print('\nN(A)=%d  R(A) mediano %.2f  min %.2f  max %.2f   R>1: %d   CONFERMA/DIFFERENTE: %d' % (len(Ra), stt.median(Ra), min(Ra), max(Ra), sum(1 for x in Ra if x > 1), sum(1 for x in Ra if abs(x-1) <= .5)))
json.dump({'|'.join(k): v for k, v in rows.items()}, open(OUT.replace('.json', '_righe.json'), 'w'), default=float)
json.dump(out, open(OUT, 'w'), default=float)
