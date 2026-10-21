import re,html,collections,math,random,glob,sys
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
    d=collections.defaultdict(float)
    for r in R[i+2:]:
        if len(r)>=12 and re.match(r'\d{4}\.\d\d\.\d\d',r[0]) and r[2]!='' and r[3]!='balance':
            d[r[0][:10]]+=num(r[8])+num(r[9])+num(r[10])
    return d
W='lavoro_wt/backtest_pipeline/risultati_archivio/'
pf=day(W+'TEST80K_20261019/DEEP80K_PROPFIRMGOLDEA/DEEP80K_PROPFIRMGOLDEA_TRANCHE22_20261019_230531.htm')
gr=day(W+'GR80K_20261020/GRSET80K_TRANCHE1_20261020_162333.htm')
def corr(a,b):
    n=len(a);ma=sum(a)/n;mb=sum(b)/n
    c=sum((x-ma)*(y-mb) for x,y in zip(a,b)); return c/math.sqrt(sum((x-ma)**2 for x in a)*sum((y-mb)**2 for y in b))
def dd(s):
    c=pk=m=0
    for v in s: c+=v; pk=max(pk,c); m=max(m,pk-c)
    return m
print('PF giorni',len(pf),min(pf),max(pf),'GR giorni',len(gr),min(gr),max(gr))
for n,nm in ((1,'step3000'),(5,'step6000'),(3,'step4000'),(6,'step7500')):
    f=glob.glob(f'gb4z/GB4_GOLDBOTONEMT5/report/GB4_GOLDBOTONEMT5_TRANCHE{n}_*.htm')[0]
    gb=day(f)
    days=sorted(set(pf)|set(gr)|set(gb))
    A=[pf.get(x,0) for x in days];B=[gr.get(x,0) for x in days];C=[gb.get(x,0) for x in days]
    def mon(S):
        m=collections.defaultdict(float)
        for x,v in zip(days,S): m[x[:7]]+=v
        k=sorted(m); return [m[i] for i in k]
    rnd=random.Random(12345); N=len(days); bs=[]
    for _ in range(1000):
        idx=[rnd.randrange(N) for _ in range(N)]; bs.append(corr([C[i] for i in idx],[B[i] for i in idx]))
    bs.sort()
    print(f'--- GB T{n} {nm}: giorni {len(days)} netto {sum(C):.0f} DD realizzi {dd(C):.0f} = {100*dd(C)/80000:.2f}% di 80K')
    print(f'   corr giornaliera: GB-GR {corr(C,B):.3f} (IC95 {bs[25]:.3f}..{bs[974]:.3f}) GB-PF {corr(C,A):.3f} | mensile GB-GR {corr(mon(C),mon(B)):.3f} GB-PF {corr(mon(C),mon(A)):.3f}')
    for nmm,S in (('GB+GR',[x+z for x,z in zip(C,B)]),('GB+PF',[x+z for x,z in zip(C,A)]),('PF+GR+GB',[x+y+z for x,y,z in zip(A,B,C)]),('PF+GR',[x+y for x,y in zip(A,B)])):
        print(f'   {nmm}: netto {sum(S):.0f} DD realizzi {dd(S):.0f} = {100*dd(S)/80000:.2f}% di 80K, peggior giorno {min(S):.0f}')
