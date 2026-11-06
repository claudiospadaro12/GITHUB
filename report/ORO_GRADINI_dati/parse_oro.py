import re,glob,json,collections,sys
sys.path.insert(0,'/home/user/GITHUB/report/UBS_PACCHETTO_WIM/analisi')
from wimlib import load_deals
import numpy as np
rows={}
def num(s): return float(s.replace('|','').replace(',','').replace(' ',''))
seen=set()
for ref in sorted(glob.glob('oro/z*/*/*/*/REFERTO_ANNO80K_TRANCHE.txt')):
    folder=ref.split('/')[3]
    if folder in seen: continue
    seen.add(folder)
    base=ref.rsplit('/',1)[0]
    t=open(ref,encoding='utf-8',errors='replace').read()
    m=re.search(r'operazioni (\d+)\s+netto (-?[\d.]+)\s+PF ([\d.]+|inf|-)\s+DD equita ([\d.]+)\(([\d.]+)%\)\s+DD saldo ([\d.]+)\(([\d.]+)%\)',t)
    fb=re.search(r'final balance (-?[\d.]+)',t)
    so=re.search(r'righe stop out nei giornali (\d+), no money (\d+)',t)
    st=re.search(r'STATO (\w+)',t); dep=re.search(r'deposito (\d+) EUR',t)
    htm=glob.glob('oro/z*/*/'+folder+'/*/report/*.htm')
    r=dict(folder=folder,stato=st and st.group(1),dep=dep and int(dep.group(1)),ops=m and int(m.group(1)),net=m and float(m.group(2)),pf=m and m.group(3),
      ddE=m and float(m.group(4)),ddEp=m and float(m.group(5)),final=fb and float(fb.group(1)),stopout=so and int(so.group(1)),nomoney=so and int(so.group(2)),
      q=(lambda x:x and int(x.group(1)))(re.search(r'qualita (\d+)%',t)),has_htm=bool(htm))
    if htm:
        raw=open(htm[0],'rb').read().decode('utf-16','replace')
        flat=re.sub(r'<[^>]+>','|',raw);flat=re.sub(r'[\s|]+','|',flat)
        rel=re.search(r'Equità\|Drawdown\|Relativa:\|([\d.]+)%\|\(([\d|,.]+)\)',flat)
        r['rel']=rel and float(rel.group(1));r['relAbs']=rel and num(rel.group(2))
        dep_h=re.search(r'Deposito\|Iniziale:\|([\d|,.]+)',flat);r['dep_htm']=dep_h and num(dep_h.group(1))
        ev=load_deals(htm[0])
        day=collections.defaultdict(float)
        nin=0;nmin=0;mx=0
        for e in ev:
            day[e[0][:10]]+=e[1]
            if e[3]=='in':
                nin+=1
        # volumes: need volume; load_deals lacks. parse rows
        vols=[]
        for rr in re.findall(r'<tr[^>]*>(.*?)</tr>',raw[raw.find('Affari'):],flags=re.S):
            c=[re.sub(r'<[^>]+>','',x).replace('&nbsp;',' ').strip() for x in re.findall(r'<td[^>]*>(.*?)</td>',rr,flags=re.S)]
            if len(c)>=12 and re.match(r'\d{4}\.\d\d\.\d\d \d\d:\d\d',c[0]) and c[3] in('buy','sell') and c[4]=='in':
                try: vols.append(float(c[5].replace(' ','')))
                except: pass
        r['nin']=len(vols);r['minlot']=sum(1 for v in vols if v<=0.0101);r['maxlot']=max(vols) if vols else 0
        r['worstday']=min(day.values()) if day else None
        r['daily']=dict(day)
    rows[folder]=r
json.dump(rows,open('oro_res.json','w'),default=float)
print(len(rows))
for k in sorted(rows):
    r=rows[k]
    print(f"{k:16s} {r['stato']} dep{r['dep']}/{r.get('dep_htm')} ops{r['ops']} net{r['net']} PF{r['pf']} DDe{r['ddEp']}%/{r['ddE']} rel{r.get('rel')} fin{r['final']} SO{r['stopout']} NM{r['nomoney']} q{r['q']} minlot{r.get('minlot')}/{r.get('nin')} max{r.get('maxlot')} wd{r.get('worstday') and round(r['worstday'])}")
