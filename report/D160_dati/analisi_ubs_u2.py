#!/usr/bin/env python3
"""UBS U2: DD% con Risk=123 (use Max Risk Per Strategy), MaxRiskPerStrategy_Value=2, braccio A (HistoricalMaxDD dichiarato) e B (misurato in dollari).
Uso: python3 -I analisi_ubs_u2.py <cartella con UBSU2_*> <ubsu1b.json> <out.json>  (legge REFERTO + report .htm per i deal)"""
import re, glob, json, sys, collections, statistics as stt
W, U1B, OUT = sys.argv[1:4]
u1 = json.load(open(U1B))
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
for ref in sorted(glob.glob(W + '/UBSU2_*/*/REFERTO_ANNO80K_TRANCHE.txt')):
    folder = ref.split('/')[-3]
    mm = re.match(r'UBSU2_([AB])_(.+)_100000_2013-2025$', folder)
    arm, tag = mm.groups()
    base = ref.rsplit('/', 1)[0]
    t = open(ref, encoding='utf-8', errors='replace').read()
    m = re.search(r'operazioni (\d+)\s+netto (-?[\d.]+)\s+PF ([\d.]+|inf|-)\s+DD equita ([\d.]+)\(([\d.]+)%\)', t)
    q = re.search(r'qualita (\d+)%', t); so = re.search(r'righe stop out nei giornali (\d+), no money (\d+)', t)
    stato = re.search(r'STATO (\w+)', t).group(1)
    conf = re.search(r'input imposti confermati dal report: (\w+)', t).group(1)
    allin = re.search(r'TUTTI gli input del report: (.*)', t).group(1)
    rin = dict(x.split('=', 1) for x in allin.split(' ; ') if '=' in x)
    sf = glob.glob(base + '/ini/*.set')[0]; sd = parse_set(sf)
    imposti = {'Risk', 'MaxRiskPerStrategy_Value', 'AdjustLotsizeToVariableValues', 'HistoricalMaxDD'}
    diff = []
    for k, v in sd.items():
        if k in imposti or k not in rin: continue
        a, b2 = v.strip(), rin[k].strip()
        try:
            if abs(float(a) - float(b2)) < 1e-9: continue
        except: pass
        if a.lower() != b2.lower(): diff.append((k, a, b2))
    htm = glob.glob(base + '/report/*.htm')[0]
    dl = deals(htm)
    lots = [d['vol'] for d in dl if d['dr'] == 'in']
    day = collections.defaultdict(float)
    for d in dl: day[d['t'][:10]] += d['v']
    r = dict(arm=arm, tag=tag, stato=stato, ops=int(m.group(1)), net=float(m.group(2)), pf=m.group(3), dd=float(m.group(4)), ddp=float(m.group(4)) / 100000 * 100,
             ddp_rep=float(m.group(5)), q=int(q.group(1)), so=int(so.group(1)), nm=int(so.group(2)), conf=conf,
             Risk=rin.get('Risk'), MRS=rin.get('MaxRiskPerStrategy_Value'), HMD=float(rin.get('HistoricalMaxDD', 0)), StartLots=rin.get('StartLots'),
             lot_med=stt.mean(lots) if lots else None, lot_max=max(lots) if lots else None, lot_min=min(lots) if lots else None, nlots=len(lots),
             worst_day=min(day.values()) if day else None, diff=diff, dep='100000' )
    res['%s|%s' % (tag, arm)] = r
json.dump(res, open(OUT, 'w'), default=float, indent=1)
print(len(res), 'passate')
