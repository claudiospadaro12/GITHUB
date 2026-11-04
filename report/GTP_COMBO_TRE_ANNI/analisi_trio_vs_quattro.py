import re,glob,collections,datetime as dt,sys
def num(x): return float(x.replace(' ','').replace('\xa0','') or 0)
def load(p):
    b=open(p,'rb').read(); t=b.decode('utf-16') if b[:2] in (b'\xff\xfe',b'\xfe\xff') else b.decode('utf-8','ignore')
    ev=[]
    for r in re.findall(r'<tr[^>]*>(.*?)</tr>',t,flags=re.S|re.I):
        c=[re.sub(r'<[^>]+>','',x).replace('&nbsp;',' ').strip() for x in re.findall(r'<td[^>]*>(.*?)</td>',r,flags=re.S|re.I)]
        if len(c)>=12 and re.match(r'\d{4}\.\d\d\.\d\d \d\d:\d\d',c[0]) and c[3] in ('buy','sell'):
            ev.append((c[0],num(c[10])+num(c[8])+num(c[9])))
    return ev
def getS(y):
    return {'Reaper':load(glob.glob(f'tre_da074c39-ANNO80K_TRE_EA_20261026_1444/{y}_M1/ANNO80K_THEGOLDREAPERMT5/report/*.htm')[0]),
            'Goldbot':load(glob.glob(f'gb_setvend/{y}_M1_GB_PF525/**/*.htm',recursive=True)[0]),
            'Phantom':load(f'phantom_d4/ph_{y}.htm'),
            'GTP':load(glob.glob(f'gtp_anni/{y}_M1_GTP_COMBO/**/*.htm',recursive=True)[0])}
def daily(S,names,y):
    d=collections.defaultdict(float)
    for n in names:
        for t,v in S[n]: d[t[:10]]+=v
    return d
TRIO=['Reaper','Goldbot','Phantom']; QUAD=TRIO+['GTP']
res={}
for y in ('2013','2018','2020','2025'):
    S=getS(y); res[y]=S
    print('=======',y)
    for nm,names in (('Trio',TRIO),('Quattro',QUAD)):
        d=daily(S,names,y); days=sorted(d); v=[d[k] for k in days]
        cum=pk=dd=0
        for x in v: cum+=x;pk=max(pk,cum);dd=max(dd,pk-cum)
        # intraday running min
        ev=sorted(e for n in names for e in S[n]); bd=collections.defaultdict(list)
        for t,x in ev: bd[t[:10]].append((t[11:],x))
        mins=[]
        for k,l in bd.items():
            r=0;m=0;mt=None;cr=None
            for tm,x in l:
                r+=x
                if r<m:m=r;mt=tm
                if cr is None and r<=-0.043*80000: cr=tm
            mins.append((m,k,mt,r,cr))
        mins.sort()
        print(' %-8s netto %7.0f | peggior giorno %6.0f (%.2f%%) | DD saldo %6.0f (%.2f%%) | giorni >=2%%:%d >=3%%:%d >=4,3%%:%d >=5%%:%d'%(nm,sum(v),mins[0][0],100*mins[0][0]/80000,dd,100*dd/80000,*(sum(1 for x in mins if x[0]<=-th/100*80000) for th in (2,3,4.3,5))))
        if y=='2013' or y=='2018':
            for m,k,mt,r,cr in mins[:6]:
                print('     %s min %6.0f (%.2f%%) alle %s | fine %6.0f | -4,3%% alle %s'%(k,m,100*m/80000,mt,r,cr or '-'))
# rolling start windows (calendar)
print('\n=== finestre di partenza (realizzato, 80.000 di partenza): quota di finestre che toccano la soglia dall inizio')
for y in ('2013','2018','2020','2025'):
    S=res[y]; D0=dt.date(int(y),1,1); cal=[D0+dt.timedelta(i) for i in range(365)]
    for nm,names in (('Trio',TRIO),('Quattro',QUAD)):
        d=daily(S,names,y); s=[d.get(c.strftime('%Y.%m.%d'),0) for c in cal]
        for W in (14,30):
            lst=[]
            for i in range(365-W):
                c=0;m=0
                for j in range(i,i+W): c+=s[j];m=min(m,c)
                lst.append(m)
            n=len(lst)
            print(' %s %-7s %2dgg: peggiore %.2f%% | >=4,3%%: %4.1f%% | >=5%%: %4.1f%% | >=9,3%%: %4.1f%% | >=10%%: %4.1f%%'%(y,nm,W,100*min(lst)/80000,*(100*sum(1 for m in lst if m<=-th/100*80000)/n for th in (4.3,5,9.3,10))))
