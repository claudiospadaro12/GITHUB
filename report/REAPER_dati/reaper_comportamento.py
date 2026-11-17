import re,sys,collections,statistics as st
from datetime import datetime
def leggi(p):
    t=open(p,'rb').read()
    s=t.decode('utf-16') if t[:2] in (b'\xff\xfe',b'\xfe\xff') else t.decode('utf-8','ignore')
    out=[]
    for rg in re.split(r'(?i)<tr',s):
        c=[re.sub(r'\s+',' ',re.sub(r'&nbsp;',' ',re.sub(r'<[^>]*>','',m))).strip() for m in re.findall(r'(?is)<t[dh][^>]*>(.*?)</t[dh]>',rg)]
        if len(c)>=11 and re.match(r'\d{4}\.\d\d\.\d\d \d\d:\d\d:\d\d$',c[0]): out.append(c)
    return out
def num(x):
    try: return float(x.replace(' ',''))
    except: return None
def dt(x): return datetime.strptime(x,'%Y.%m.%d %H:%M:%S')
for p in sys.argv[1:]:
    rows=leggi(p); S=collections.defaultdict(list)
    for c in rows:
        m=re.search(r'Gold Reaper_XAUUSD_(\d+)',c[10])
        if not m or 'stop' not in c[3] and 'limit' not in c[3]: continue
        S[int(m.group(1))].append(c)
    print('=== ',p.split('/')[-1],' ordini totali con commento Reaper:',sum(len(v) for v in S.values()))
    for n in sorted(S):
        v=S[n]; tipi=collections.Counter(c[3] for c in v)
        stati=collections.Counter(c[9].split(' ')[0] for c in v)
        ore=collections.Counter(dt(c[0]).hour for c in v); gg=collections.Counter(dt(c[0]).weekday() for c in v)
        sld=[];tpd=[];vita=[]
        for c in v:
            pr,sl,tp=num(c[5]),num(c[6]),num(c[7])
            if pr and sl: sld.append(abs(pr-sl))
            if pr and tp: tpd.append(abs(tp-pr))
            try: vita.append((dt(c[8])-dt(c[0])).total_seconds()/3600)
            except: pass
        f=lambda L: ('%.1f/%.1f/%.1f'%(st.quantiles(L,n=4)[0],st.median(L),st.quantiles(L,n=4)[2])) if len(L)>=4 else 'n/d'
        print('--- strategia %d: ordini %d  tipi %s  stati %s'%(n,len(v),dict(tipi),dict(stati)))
        print('   ore di piazzamento (server) top5:',ore.most_common(5),' giorni (0=lun):',dict(sorted(gg.items())))
        print('   stop $ (q1/med/q3): %s   target $: %s   rapporto TP/SL med: %s   vita ordine ore (q1/med/q3): %s'%(f(sld),f(tpd),('%.2f'%st.median([a/b for a,b in zip(tpd,sld) if b])) if sld and tpd else 'n/d',f(vita)))
