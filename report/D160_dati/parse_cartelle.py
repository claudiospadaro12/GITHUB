#!/usr/bin/env python3
"""D160 oro: legge le cartelle D160_* (argv[1] = cartella con le cartelle estratte dallo zip) e scrive d160_oro.json. Uso: python3 -I parse_d160.py <dir> <out.json>"""
import re, glob, json, sys, collections, os
sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'UBS_PACCHETTO_WIM', 'analisi'))
from wimlib import load_deals
W, OUT = sys.argv[1], sys.argv[2]
def num(s): return float(s.replace('|', '').replace(',', '').replace(' ', ''))
rows = {}
for ref in sorted(glob.glob(W + '/*/*/REFERTO_ANNO80K_TRANCHE.txt')):
    base = ref.rsplit('/', 1)[0]; folder = ref.split('/')[-3]
    t = open(ref, encoding='utf-8', errors='replace').read()
    m = re.search(r'operazioni (\d+)\s+netto (-?[\d.]+)\s+PF ([\d.]+|inf|-)\s+DD equita ([\d.]+)\(([\d.]+)%\)\s+DD saldo ([\d.]+)\(([\d.]+)%\)', t)
    fb = re.search(r'final balance (-?[\d.]+)', t); so = re.search(r'righe stop out nei giornali (\d+), no money (\d+)', t)
    st = re.search(r'STATO (\w+)', t); dep = re.search(r'deposito (\d+) EUR', t); q = re.search(r'qualita (\d+)%', t)
    r = dict(folder=folder, stato=st and st.group(1), dep=dep and int(dep.group(1)), ops=m and int(m.group(1)), net=m and float(m.group(2)),
             pf=m and m.group(3), ddE=m and float(m.group(4)), ddEp=m and float(m.group(5)), final=fb and float(fb.group(1)),
             stopout=so and int(so.group(1)), nomoney=so and int(so.group(2)), q=q and int(q.group(1)))
    htm = glob.glob(base + '/report/*.htm')
    if htm:
        raw = open(htm[0], 'rb').read().decode('utf-16', 'replace')
        flat = re.sub(r'<[^>]+>', '|', raw); flat = re.sub(r'[\s|]+', '|', flat)
        rel = re.search(r'Equità\|Drawdown\|Relativa:\|([\d.]+)%', flat); r['rel'] = rel and float(rel.group(1))
        dh = re.search(r'Deposito\|Iniziale:\|([\d|,.]+)', flat); r['dep_htm'] = dh and num(dh.group(1))
        day = collections.defaultdict(float)
        for e in load_deals(htm[0]): day[e[0][:10]] += e[1]
        vols = []
        for rr in re.findall(r'<tr[^>]*>(.*?)</tr>', raw[raw.find('Affari'):], flags=re.S):
            c = [re.sub(r'<[^>]+>', '', x).replace('&nbsp;', ' ').strip() for x in re.findall(r'<td[^>]*>(.*?)</td>', rr, flags=re.S)]
            if len(c) >= 12 and re.match(r'\d{4}\.\d\d\.\d\d \d\d:\d\d', c[0]) and c[3] in ('buy', 'sell') and c[4] == 'in':
                try: vols.append(float(c[5].replace(' ', '')))
                except: pass
        r['lots'] = sum(vols); r['nin'] = len(vols); r['minlot'] = sum(1 for v in vols if v <= 0.0101); r['maxlot'] = max(vols) if vols else 0
        r['worstday'] = min(day.values()) if day else None; r['has_htm'] = True
    else:
        r['has_htm'] = False
    rows[folder] = r
json.dump(rows, open(OUT, 'w'), default=float)
print(len(rows))
for k in sorted(rows):
    r = rows[k]
    print(f"{k:28s} {r['stato']} dep{r['dep']}/{r.get('dep_htm')} ops{r['ops']} net{r['net']} PF{r['pf']} DDe{r['ddEp']}% rel{r.get('rel')} fin{r['final']} SO{r['stopout']} NM{r['nomoney']} q{r['q']} lots{round(r.get('lots') or 0,1)} max{r.get('maxlot')} min{r.get('minlot')}/{r.get('nin')} wd{r.get('worstday')}")
