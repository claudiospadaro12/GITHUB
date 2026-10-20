import re,html,collections,math,random
def read(p):
    b=open(p,'rb').read()
    for e in ('utf-16','utf-8'):
        try: return b.decode(e)
        except Exception: pass
def rows(t):
    return [[html.unescape(re.sub(r'<[^>]+>','',c)).strip().replace('\xa0',' ') for c in re.findall(r'<t[dh][^>]*>(.*?)</t[dh]>',tr,flags=re.S|re.I)] for tr in re.findall(r'<tr[^>]*>(.*?)</tr>',t,flags=re.S|re.I)]
def num(x):
    try: return float(x.replace(' ','').replace(',',''))
    except Exception: return 0.0
def day(p):
    R=rows(read(p)); i=[k for k,r in enumerate(R) if r and r[0] in('Affari','Deals')][0]
    d=collections.defaultdict(float); lots=[]
    for r in R[i+2:]:
        if len(r)>=12 and re.match(r'\d{4}\.\d\d\.\d\d',r[0]) and r[2]!='' and r[3]!='balance':
            d[r[0][:10]]+=num(r[8])+num(r[9])+num(r[10])
    return d
B='lavoro_wt/backtest_pipeline/risultati_archivio/TEST80K_20261019/'
pf=day(B+'DEEP80K_PROPFIRMGOLDEA/DEEP80K_PROPFIRMGOLDEA_TRANCHE22_20261019_230531.htm')
gr=day('gr80k_zip/report/GRSET80K_TRANCHE1_20261020_162333.htm')
days=sorted(set(pf)|set(gr))
a=[pf.get(x,0) for x in days]; b=[gr.get(x,0) for x in days]
def corr(a,b):
    n=len(a);ma=sum(a)/n;mb=sum(b)/n
    c=sum((x-ma)*(y-mb) for x,y in zip(a,b)); return c/math.sqrt(sum((x-ma)**2 for x in a)*sum((y-mb)**2 for y in b))
print('giorni',len(days),'corr giornaliera realizzi %.3f'%corr(a,b))
rnd=random.Random(12345); n=len(days); bs=[]
for _ in range(2000):
    idx=[rnd.randrange(n) for _ in range(n)]; bs.append(corr([a[i] for i in idx],[b[i] for i in idx]))
bs.sort(); print('IC95 bootstrap %.3f..%.3f'%(bs[50],bs[1949]))
# settimanale e mensile
def agg(f):
    A=collections.defaultdict(float);Bq=collections.defaultdict(float)
    for x in days: A[f(x)]+=pf.get(x,0); Bq[f(x)]+=gr.get(x,0)
    k=sorted(A); return corr([A[i] for i in k],[Bq[i] for i in k])
print('corr mensile %.3f'%agg(lambda x:x[:7]))
def dd(s):
    c=pk=m=0
    for v in s: c+=v; pk=max(pk,c); m=max(m,pk-c)
    return m
for nm,s in (('PF',a),('GR',b),('PF+GR',[x+y for x,y in zip(a,b)])):
    print(nm,'netto %.0f'%sum(s),'DD realizzi %.0f = %.2f%% di 80K'%(dd(s),100*dd(s)/80000),'peggior giorno %.0f'%min(s))
print('somma DD equity PF 11023 + GR 3854 =',11023+3854,'= %.2f%% di 80K'%(100*(11023+3854)/80000))
m=collections.defaultdict(float)
for x,y,d in zip(a,b,days): m[d[:7]]+=x+y
print('mesi pos portafoglio',sum(1 for v in m.values() if v>0),len(m))
