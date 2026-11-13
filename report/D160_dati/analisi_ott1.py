#!/usr/bin/env python3
"""OTT1 tappa 1: Goldbot One Prop, BASE e 'senza strategia X' per due periodi. Uso: python3 -I analisi_ott1.py <cartella ANNO_ORO_GRADINI_OTT1_*> <out.json>"""
import re, glob, json, sys, collections
W, OUT = sys.argv[1:3]
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
        if m and ',' not in m.group(1): d[m.group(1)] = m.group(2).split('||')[0]
    return d
res = {}
for ref in sorted(glob.glob(W + '/OTT1_*/*/REFERTO_ANNO80K_TRANCHE.txt')):
    folder = ref.split('/')[-3]
    mm = re.match(r'OTT1_(BASE|NO[A-H])_GB_80000_(2013-2018|2019-2025)$', folder)
    tag, per = mm.groups(); base = ref.rsplit('/', 1)[0]
    t = open(ref, encoding='utf-8', errors='replace').read()
    m = re.search(r'operazioni (\d+)\s+netto (-?[\d.]+)\s+PF ([\d.]+|inf|-)\s+DD equita ([\d.]+)\(([\d.]+)%\)', t)
    so = re.search(r'righe stop out nei giornali (\d+), no money (\d+)', t)
    allin = re.search(r'TUTTI gli input del report: (.*)', t).group(1); rin = dict(x.split('=', 1) for x in allin.split(' ; ') if '=' in x)
    sd = parse_set(glob.glob(base + '/ini/*.set')[0])
    dep = re.search(r'deposito (\d+) EUR', t)
    diff = []
    for k, v in sd.items():
        if k not in rin: continue
        a, b2 = v.strip(), rin[k].strip()
        try:
            if abs(float(a) - float(b2)) < 1e-9: continue
        except: pass
        if a.lower() != b2.lower(): diff.append((k, a, b2))
    off = [k for k, v in rin.items() if k.startswith('RunStrategy') and v.lower() == 'false']
    dl = deals(glob.glob(base + '/report/*.htm')[0]); day = collections.defaultdict(float)
    for d in dl: day[d['t'][:10]] += d['v']
    res['%s|%s' % (tag, per)] = dict(tag=tag, per=per, stato=re.search(r'STATO (\w+)', t).group(1), ops=int(m.group(1)), net=float(m.group(2)), pf=m.group(3), dd=float(m.group(4)), ddp=float(m.group(4)) / 800.0,
        q=int(re.search(r'qualita (\d+)%', t).group(1)), so=int(so.group(1)), nm=int(so.group(2)), dep=dep and dep.group(1), off=off, diff=diff, worst_day=min(day.values()) if day else None, ndays=len(day))
json.dump(res, open(OUT, 'w'), indent=1, default=float)
print(len(res))
