import glob,re,sys,csv,collections
import pandas as pd
B=sys.argv[1]; J='report/UBS_NOTTE/JOBS_R4.csv'; C='report/UBS_NOTTE/CANDIDATI_OTT_A0.csv'
def num(x): return float(x.replace(' ','').replace('\xa0','').replace('%',''))
rx=re.compile(r'<td>(\d{4}\.\d\d\.\d\d) \d\d:\d\d:\d\d</td><td>\d+</td><td>[A-Z]+</td><td>(?:buy|sell)</td><td>out</td><td>[\d.]+</td><td>[\d.]+</td><td>\d+</td><td>(-?[\d. ]+)</td><td>(-?[\d. ]+)</td><td>(-?[\d. ]+)</td>')
def rd(h):
    t=open(h,'rb').read().decode('utf-16'); s=re.sub(r'<[^>]+>','|',t); s=re.sub(r'[\s|]*\|[\s|]*','|',s)
    g=lambda k: re.search(re.escape(k)+r'\|([^|]*)\|',s).group(1)
    ann=collections.defaultdict(float)
    for m in rx.finditer(t): ann[m.group(1)[:4]]+=sum(num(x) for x in m.groups()[1:])
    return dict(pf=num(g('Fattore di Profitto:')),op=int(g('Numero di Operazioni di Trading Totali:')),netto=num(g('Profitto Totale Netto:')),
      dd=num(g('Equità Drawdown Massima:').split('(')[1].rstrip(')')),qual=g('Qualità dello Storico:'),
      ann_pos=sum(v>0 for v in ann.values()),ann=len(ann))
J=pd.read_csv(J,sep=';'); C=pd.read_csv(C,sep=';'); rows=[]
for _,r in J.iterrows():
    d=glob.glob(B+'UBSR4_%s_*'%r.job); h=glob.glob(d[0]+'/*/report/*.htm')
    x=rd(h[0]) if h else {}; x.update(job=r.job,set=r.file,gruppo=r.gruppo); rows.append(x)
R=pd.DataFrame(rows); R['n']=R.job.str[2:4].astype(int); R['per']=R.job.str[4]
R=R.merge(C[['n','gruppo','PF','operazioni']].rename(columns={'gruppo':'g','PF':'pf_ott','operazioni':'op_ott'}),on='n')
R.to_csv('report/UBS_NOTTE/RISULTATI_R4_2026-11-28.csv',sep=';',index=False)
print(R[['job','g','pf_ott','pf','op','netto','dd','ann_pos','ann','qual']].to_string())
