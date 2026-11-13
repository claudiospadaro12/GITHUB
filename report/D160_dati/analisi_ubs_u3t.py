#!/usr/bin/env python3
"""UBS U3 tappa 2: DD% fuori periodo. Uso: python3 -I analisi_ubs_u3t.py <cartella UBSU3T_*> <ubsu3m.json> <out.json>"""
import re, glob, json, sys, collections, statistics as stt
W, U3M, OUT = sys.argv[1:4]
M = json.load(open(U3M))
def num(x):
    x = x.replace('\xa0', '').replace(' ', '').replace(',', '')
    try: return float(x)
    except: return 0.0
def deals(p):
    b = open(p, 'rb').read(); t = b.decode('utf-16') if b[:2] in (b'\xff\xfe', b'\xfe\xff') else b.decode('utf-8', 'ignore')
    i = t.find('Affari'); t = t[i:] if i >= 0 else t
    ev = []
    for r in re.findall(r'<tr[^>]*>(.*?)</tr>', t, flags=re.S | re.I):
        c = [re.sub(r'<[^>]+>', '', x).replace('&nbsp;', ' ').strip() for x in re.findall(r'<td[^>]*>(.*?)</td>', r, flags=re.S | re.I)]
        if len(c) >= 12 and re.match(r'\d{4}\.\d\d\.\d\d \d\d:\d\d', c[0]) and c[3] in ('buy', 'sell'):
            ev.append(dict(t=c[0], dr=c[4], vol=num(c[5]), v=num(c[10]) + num(c[8]) + num(c[9])))
    return ev
def parse_set(p):
    b = open(p, 'rb').read(); t = b.decode('utf-16') if b[:2] in (b'\xff\xfe', b'\xfe\xff') else b.decode('utf-8', 'replace')
    d = {}
    for l in t.splitlines():
        m = re.match(r'^([A-Za-z0-9_]+)=(.*)$', l.strip())
        if m: d[m.group(1)] = m.group(2).split('||')[0]
    return d
res = {}
for ref in sorted(glob.glob(W + '/UBSU3T_*/*/REFERTO_ANNO80K_TRANCHE.txt')):
    folder = ref.split('/')[-3]
    mm = re.match(r'UBSU3T_([XY])_(.+)_100000_(2019-2025|2013-2018)$', folder)
    inc, tag, per = mm.groups(); base = ref.rsplit('/', 1)[0]
    t = open(ref, encoding='utf-8', errors='replace').read()
    m = re.search(r'operazioni (\d+)\s+netto (-?[\d.]+)\s+PF ([\d.]+|inf|-)\s+DD equita ([\d.]+)\(([\d.]+)%\)', t)
    so = re.search(r'righe stop out nei giornali (\d+), no money (\d+)', t)
    allin = re.search(r'TUTTI gli input del report: (.*)', t).group(1); rin = dict(x.split('=', 1) for x in allin.split(' ; ') if '=' in x)
    sd = parse_set(glob.glob(base + '/ini/*.set')[0]); imposti = {'Risk', 'MaxRiskPerStrategy_Value', 'AdjustLotsizeToVariableValues', 'HistoricalMaxDD'}
    diff = []
    for k, v in sd.items():
        if k in imposti or k not in rin: continue
        a, b2 = v.strip(), rin[k].strip()
        try:
            if abs(float(a) - float(b2)) < 1e-9: continue
        except: pass
        if a.lower() != b2.lower(): diff.append((k, a, b2))
    dl = deals(glob.glob(base + '/report/*.htm')[0]); lots = [d['vol'] for d in dl if d['dr'] == 'in']
    day = collections.defaultdict(float)
    for d in dl: day[d['t'][:10]] += d['v']
    dep = re.search(r'deposito (\d+) EUR', t)
    measured = M[tag]['dd01_P1'] if inc == 'X' else M[tag]['dd01_P2']
    test_dd01 = M[tag]['dd01_P2'] if inc == 'X' else M[tag]['dd01_P1']
    res['%s|%s' % (tag, inc)] = dict(inc=inc, tag=tag, per=per, stato=re.search(r'STATO (\w+)', t).group(1), ops=int(m.group(1)), net=float(m.group(2)), pf=m.group(3), dd=float(m.group(4)), ddp=float(m.group(4)) / 1000.0,
        q=int(re.search(r'qualita (\d+)%', t).group(1)), so=int(so.group(1)), nm=int(so.group(2)), Risk=rin.get('Risk'), MRS=rin.get('MaxRiskPerStrategy_Value'), Adj=rin.get('AdjustLotsizeToVariableValues'),
        HMD=float(rin.get('HistoricalMaxDD', 0)), dep=dep and dep.group(1), diff=diff, lot_med=stt.mean(lots) if lots else None, lot_max=max(lots) if lots else None,
        worst_day=min(day.values()) if day else None, dd01_misura=measured, dd01_prova=test_dd01, rapporto=test_dd01 / measured)
json.dump(res, open(OUT, 'w'), indent=1, default=float)
print(len(res), 'passate')
