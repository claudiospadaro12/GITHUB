#!/usr/bin/env python3
"""Seleziona i candidati dall'XML di un'ottimizzazione UBS (regole scritte il 22/11: 40% migliori per Result, 30% piu diversi, 30% a caso fra gli idonei) + gruppo di CONTROLLO casuale,
e scrive i file .set (base = set di ottimizzazione di Wim con i valori del passaggio), la lista JOBS e lo zip.
Uso: ott_candidati.py <XML> <base optimization.set> <etichetta> <outdir> [N=10] [seed=20261127]"""
import sys,os,re,json,csv,random,zipfile,math
import xml.etree.ElementTree as ET
xml,baseset,etich,outdir=sys.argv[1:5]; N=int(sys.argv[5]) if len(sys.argv)>5 else 10; seed=int(sys.argv[6]) if len(sys.argv)>6 else 20261127
S='{urn:schemas-microsoft-com:office:spreadsheet}'
rows=[[ (d.text or '') for d in r.iter(S+'Data')] for r in ET.parse(xml).getroot().iter(S+'Row')]
H=rows[0]
def f(x):
    try: return float(x)
    except: return float('nan')
D=[dict(zip(H,[f(x) for x in r])) for r in rows[1:]]
D=[d for d in D if not any(math.isnan(d[k]) for k in ('Profit','Profit Factor','Recovery Factor','Equity DD %','Trades','Result'))]
P=[k for k in H if k not in('Pass','Result','Profit','Expected Payoff','Profit Factor','Recovery Factor','Sharpe Ratio','Custom','Equity DD %','Trades')]
el=[d for d in D if d['Profit Factor']>=1.30 and d['Trades']>=100 and d['Profit']>0 and d['Profit Factor']<50]
print('passaggi',len(D),'idonei',len(el))
n_top=round(N*0.4); n_div=round(N*0.3); n_rnd=N-n_top-n_div
el.sort(key=lambda d:-d['Result']); sel=el[:n_top]
# diversita: massima distanza minima in (RF, DD, operazioni, PF) normalizzati
keys=['Recovery Factor','Equity DD %','Trades','Profit Factor']
rng={k:(min(d[k] for d in el),max(d[k] for d in el)) for k in keys}
def vec(d): return [(d[k]-rng[k][0])/((rng[k][1]-rng[k][0]) or 1) for k in keys]
rest=[d for d in el if d not in sel]
for _ in range(n_div):
    best=max(rest,key=lambda d:min(sum((a-b)**2 for a,b in zip(vec(d),vec(s))) for s in sel)); sel.append(best); rest.remove(best)
rnd=random.Random(seed); pick=rnd.sample(rest,n_rnd); sel+=pick
for d in pick: rest.remove(d)
ctrl=random.Random(seed+1).sample(rest,min(N,len(rest)))
gruppi=[('SEL',d) for d in sel]+[('CTRL',d) for d in ctrl]
b=open(baseset,'rb').read(); t=b.decode('utf-16') if b[:2] in (b'\xff\xfe',b'\xfe\xff') else b.decode('utf-8','ignore')
os.makedirs(outdir,exist_ok=True); jobs=[]; rowsout=[]
with zipfile.ZipFile(os.path.join(outdir,'UBS_OTT_SET.zip'),'w',zipfile.ZIP_DEFLATED) as z:
    for i,(g,d) in enumerate(gruppi,1):
        out=[]
        for l in t.replace('\r','').split('\n'):
            m=re.match(r'^([A-Za-z0-9_]+)=([^|]*)\|\|(.*)$',l)
            if m and m.group(1) in d: v=d[m.group(1)]; v=int(v) if abs(v-round(v))<1e-9 else v; l='%s=%s||%s'%(m.group(1),v,m.group(3))
            out.append(l)
        fn='O%02d_XAUUSD_D1_%s_%s_p%d.set'%(i,etich,g,int(d['Pass']))
        z.writestr(fn,'\r\n'.join(out).encode('utf-16')[0:])  # UTF-16 con BOM
        for tag,anno,fine,tf in (('A','2004','2013.01.01','D1'),('B','2025','2026.11.01','D1')):
            jobs.append(('RO%02d%s'%(i,tag),'UBS_OTT_SET.zip',fn,'XAUUSD',tf,anno,fine,'OTT_%s_%s'%(etich,'V1_2004_12_M1' if tag=='A' else 'V3_TICK_2025_26')))
        rowsout.append([i,g,int(d['Pass']),d['Result'],d['Profit Factor'],d['Recovery Factor'],d['Equity DD %'],int(d['Trades']),d['Profit']])
    z.writestr('JOBS.csv','\n'.join(';'.join(map(str,j)) for j in jobs))
open(os.path.join(outdir,'JOBS_OTT.csv'),'w').write('job;zip;file;simbolo;tf;anno;fine;gruppo\n'+'\n'.join(';'.join(map(str,j)) for j in jobs)+'\n')
with open(os.path.join(outdir,'CANDIDATI_OTT.csv'),'w',newline='') as fh:
    w=csv.writer(fh,delimiter=';'); w.writerow(['n','gruppo','passaggio','Result','PF','RF','DD_pct','operazioni','profitto']); w.writerows(rowsout)
print('candidati',len(sel),'controllo',len(ctrl),'job',len(jobs))
for r in rowsout: print(r)
