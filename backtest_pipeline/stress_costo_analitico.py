# Stress analitico del costo: toglie da OGNI operazione un costo extra = K x 0,18 EUR per 0,01 lotto (0,18 = stima dello spread, 20 punti, scritta
# prima in MARKET_SELEZIONE_PER_ACQUISTO_ATTESE_2026-10-19.md). Uso: python3 -I stress_costo_analitico.py ETICHETTA=report.htm ...
import sys,re,html
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
def trades(p):
    R=rows(read(p)); i=[k for k,r in enumerate(R) if r and r[0] in('Affari','Deals')][0]
    T=[]
    for r in R[i+2:]:
        if len(r)>=12 and re.match(r'\d{4}\.\d\d\.\d\d',r[0]) and r[2]!='' and r[3]!='balance' and r[4].lower().startswith('out'):
            T.append((num(r[10])+num(r[9])+2*num(r[8]), num(r[5])))   # netto per operazione (commissione di ingresso ~ uguale a quella di uscita), lotti
    return T
def pf(v):
    w=sum(x for x in v if x>0); l=-sum(x for x in v if x<0)
    return w/l if l>0 else float('inf')
if __name__=='__main__':
    print('%-28s %5s %9s | %s'%('EA','op','netto','netto / PF con costo extra K x spread per operazione (K=0 base; 1 = costo doppio; 2 = triplo; 4 = quintuplo) | K di pareggio'))
    for a in sys.argv[1:]:
        nm,p=a.split('=',1); T=trades(p)
        base=sum(t for t,_ in T); u=sum(v/0.01 for _,v in T)
        out=[]
        for K in (0,1,2,4):
            s=[t-K*0.18*v/0.01 for t,v in T]
            out.append('K%d %9.0f / %.2f'%(K,sum(s),pf(s)))
        print('%-28s %5d %9.0f | %s | pareggio K=%.1f'%(nm,len(T),base,'  '.join(out),base/(0.18*u)))
