import re,html,collections,glob,statistics as st,datetime,math,random
def load(f):
    t=open(f,'rb').read().decode('utf-16')
    rows=re.findall(r'<tr[^>]*>(.*?)</tr>',t,re.S)
    return [[html.unescape(re.sub(r'<[^>]+>','',c)).strip().replace('\xa0',' ') for c in re.findall(r'<t[dh][^>]*>(.*?)</t[dh]>',r,re.S)] for r in rows],t
def num(s):
    try: return float(s.replace(' ','').replace(',',''))
    except: return 0.0
def P(s): return datetime.datetime.strptime(s,'%Y.%m.%d %H:%M:%S')
EA={'RG3_GOLDBOTONEMT5':'GB','RG3_THEGOLDREAPERMT5':'GR','RG3_PROPFIRMGOLDEA':'PF'}
WIN={'RIALZO':('2024.01.01','2025.01.01',27.2),'LATERALE':('2022.06.01','2023.06.01',7.0),'RIBASSO':('2013.04.01','2014.04.01',-19.6)}
SPR={'RIALZO':5,'LATERALE':0,'RIBASSO':23}  # mediana spread in punti dalle barre D1
meta={}
for d,k in EA.items():
    for f in sorted(glob.glob(f'rg3z/{d}/report/*.htm')):
        n=int(re.search(r'TRANCHE(\d+)_',f).group(1)); meta[n]=(k,f)
def tr_info(n):
    k,f=meta[n]; R,t=load(f)
    txt=re.sub(r'<[^>]+>','|',t)
    per=re.search(r'Periodo:\|([^|]+)\|',txt).group(1)
    hi=[i for i,r in enumerate(R) if 'Affare' in r and 'Volume' in r][-1]; h=R[hi]
    D=[r for r in R[hi+1:] if r and re.match(r'\d{4}\.\d\d\.\d\d',r[0]) and len(r)>=len(h)-1]
    ci=h.index('Direzione');vi=h.index('Volume');pi=h.index('Profitto');ti=h.index('Tipo');cm=h.index('Commissioni');sw=h.index('Swap')
    ins=[d for d in D if d[ci].lower()=='in']; outs=[d for d in D if d[ci].lower()=='out']
    lots=[num(d[vi]) for d in ins]
    ev=sorted([(P(d[0]),1) for d in ins]+[(P(d[0]),-1) for d in outs],key=lambda x:(x[0],x[1])); c=mx=0
    for _,kk in ev: c+=kk; mx=max(mx,c)
    by=collections.defaultdict(lambda:[0,0.0])
    for d in outs:
        s='LONG' if d[ti].lower()=='sell' else 'SHORT'; by[s][0]+=1; by[s][1]+=num(d[pi])
    mon=collections.defaultdict(float)
    for d in outs: mon[d[0][:7]]+=num(d[pi])+num(d[cm])+num(d[sw])
    day=collections.defaultdict(float)
    for d in D:
        if d[2]!='' and d[3]!='balance': day[d[0][:10]]+=num(d[8])+num(d[9])+num(d[10])
    g=lambda l:(re.search(re.escape(l)+r'\|([^|]+)\|',txt) or [0,'?'])[1]
    return dict(per=per,n=len(outs),lots=lots,maxopen=mx,by=by,mon=mon,day=day,net=g('Profitto Totale Netto:'),pf=g('Fattore di Profitto:'),dde=g('Equità Drawdown Massima:'),ddb=g('Bilancio Drawdown Massimo:'),com=sum(num(d[cm])+num(d[sw]) for d in D))
def corr(a,b):
    n=len(a);ma=sum(a)/n;mb=sum(b)/n
    den=math.sqrt(sum((x-ma)**2 for x in a)*sum((y-mb)**2 for y in b))
    return sum((x-ma)*(y-mb) for x,y in zip(a,b))/den if den else float('nan')
def dd(s):
    c=pk=m=0
    for v in s: c+=v; pk=max(pk,c); m=max(m,pk-c)
    return m
I={n:tr_info(n) for n in meta}
tab=[(1,'RIALZO','GB3000'),(2,'RIALZO','GB6000'),(3,'LATERALE','GB3000'),(4,'LATERALE','GB6000'),(5,'RIBASSO','GB3000'),(6,'RIBASSO','GB6000'),(7,'RIALZO','GR'),(8,'LATERALE','GR'),(9,'RIBASSO','GR'),(10,'RIALZO','PF'),(11,'LATERALE','PF'),(12,'RIBASSO','PF')]
print('periodi report:',{n:I[n]['per'] for n in (1,3,5,7,8,9,10,11,12)})
for n,w,e in tab:
    x=I[n]; lots=x['lots']; L=x['by']['LONG'];S=x['by']['SHORT']
    mm=x['mon']; h1=sum(v for kk,v in sorted(mm.items())[:6]); h2=sum(v for kk,v in sorted(mm.items())[6:])
    sl=sum(lots)*(16-SPR[w])  # costo in USD in piu' se lo spread fosse 16 punti (1 lotto = 1 USD a punto)
    print(f'T{n} {e} {w}: n {x["n"]} netto {x["net"]} PF {x["pf"]} DDeq {x["dde"]} DDsal {x["ddb"]} | lotti {min(lots)}/{st.median(lots)}/{max(lots)} rapp {max(lots)/min(lots):.1f} maxaperte {x["maxopen"]} | L {L[0]} {L[1]:.0f} S {S[0]} {S[1]:.0f} | mesi>0 {sum(1 for v in mm.values() if v>0)}/{len(mm)} peggior {min(mm.values()):.0f} | meta1 {h1:.0f} meta2 {h2:.0f} | extra costo se spread 16pt: {sl:.0f} USD')
print('=== CORRELAZIONI DENTRO OGNI FINESTRA (realizzi giornalieri)')
for w,(ga,gb,gr,pf) in {'RIALZO':(1,2,7,10),'LATERALE':(3,4,8,11),'RIBASSO':(5,6,9,12)}.items():
    for nm,g in (('GB3000',ga),('GB6000',gb)):
        d={'GB':I[g]['day'],'GR':I[gr]['day'],'PF':I[pf]['day']}
        days=sorted(set(d['GB'])|set(d['GR'])|set(d['PF']))
        A={k:[d[k].get(x,0) for x in days] for k in d}
        rnd=random.Random(1); N=len(days); bs=[]
        for _ in range(500):
            idx=[rnd.randrange(N) for _ in range(N)]; bs.append(corr([A['GB'][i] for i in idx],[A['GR'][i] for i in idx]))
        bs.sort()
        mon=lambda S:[v for _,v in sorted(collections.defaultdict(float,{}).items())]
        def mo(S):
            m=collections.defaultdict(float)
            for x,v in zip(days,S): m[x[:7]]+=v
            return [m[k] for k in sorted(m)]
        print(f'{w} {nm}: giorni {N} | corr gg GB-GR {corr(A["GB"],A["GR"]):.3f} (IC95 {bs[12]:.2f}..{bs[487]:.2f}) GB-PF {corr(A["GB"],A["PF"]):.3f} GR-PF {corr(A["GR"],A["PF"]):.3f} | mensile GB-GR {corr(mo(A["GB"]),mo(A["GR"])):.2f} GB-PF {corr(mo(A["GB"]),mo(A["PF"])):.2f} GR-PF {corr(mo(A["GR"]),mo(A["PF"])):.2f}')
        for lab,ks in (('GB+GR',('GB','GR')),('GB+PF',('GB','PF')),('GR+PF',('GR','PF')),('GB+GR+PF',('GB','GR','PF'))):
            S=[sum(A[k][i] for k in ks) for i in range(N)]
            print(f'      {lab}: netto {sum(S):.0f} DD realizzi {dd(S):.0f} = {100*dd(S)/80000:.2f}% di 80K, peggior giorno {min(S):.0f}')
