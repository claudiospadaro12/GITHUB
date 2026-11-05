"""Libreria di lettura dei report del tester (88 passate Wim + trio oro). Uso: python3 -I, percorsi passati come argomenti/variabili."""
import re,glob,collections,datetime as dt,os
import numpy as np
def num(x):
    x=x.replace('\xa0','').replace(' ','').replace(',','')
    try: return float(x)
    except: return 0.0
def load_deals(p):
    b=open(p,'rb').read(); t=b.decode('utf-16') if b[:2] in (b'\xff\xfe',b'\xfe\xff') else b.decode('utf-8','ignore')
    ev=[]   # (tempo, valore netto, simbolo, direzione in/out, prezzo, tipo buy/sell)
    for r in re.findall(r'<tr[^>]*>(.*?)</tr>',t,flags=re.S|re.I):
        c=[re.sub(r'<[^>]+>','',x).replace('&nbsp;',' ').strip() for x in re.findall(r'<td[^>]*>(.*?)</td>',r,flags=re.S|re.I)]
        if len(c)>=12 and re.match(r'\d{4}\.\d\d\.\d\d \d\d:\d\d',c[0]) and c[3] in ('buy','sell'):
            ev.append((c[0],num(c[10])+num(c[8])+num(c[9]),c[2],c[4],num(c[6]),c[3]))
    ev.sort(key=lambda x:x[0])
    return ev
def report_path(W,ea,s,y,fine=False):
    g=glob.glob(f'{W}/{ea}_{s}_{y}{"_21m" if fine else ""}/*/report/*.htm')
    return g[0] if g else None
BAL=80000.0; DAYLIM=0.043*BAL; TOTLIM=0.093*BAL
def daily_series(ev,year,model,daylim=DAYLIM):
    """Serie giornaliera realizzata dell'anno con il Guardian simulato: none / A (si ferma esattamente a -4,3%) / B (si ferma al deal che supera)."""
    d0=dt.date(year,1,1); n=366 if (year%4==0) else 365
    s=np.zeros(n); cur=None; run=0.0; stopped=False; ntrig=0
    def flush():
        if cur is not None:
            idx=(dt.date(int(cur[:4]),int(cur[5:7]),int(cur[8:10]))-d0).days
            if 0<=idx<n: s[idx]=run
    for e in ev:
        t,v=e[0],e[1]
        d=t[:10]
        if d!=cur: flush(); cur=d; run=0.0; stopped=False
        if stopped: continue
        run+=v
        if model!='none' and run<=-daylim:
            ntrig+=1
            if model=='A': run=-daylim
            stopped=True
    flush()
    return s,ntrig
def windows(s,W):
    n=len(s)-W
    idx=np.arange(n)[:,None]+np.arange(W)[None,:]
    return s[idx]
def outcome(win,model,target,dlim=0.05*BAL,tlim=0.10*BAL,tot=TOTLIM):
    cum=np.cumsum(win,axis=1); pas=cum>=target
    if model=='none': fail=(win<=-dlim)|(cum<=-tlim); stop=np.zeros(win.shape,bool)
    else: fail=(win<=-dlim); stop=cum<=-tot
    big=10**9
    first=lambda m: np.where(m.any(axis=1),m.argmax(axis=1),big)
    f,st,p=first(fail),first(stop),first(pas)
    e=np.minimum(f,st)
    pa=(p<big)&(p<e); fa=((f<big)&(f<=p)&(f<=st))|((st<big)&(st<p)&(st<f))
    return int(pa.sum()),int(fa.sum()),len(win)
