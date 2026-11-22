import sys,os,datetime as dt
import numpy as np,pandas as pd
sys.path.insert(0,'/home/user/GITHUB/backtest_runner/simulatore')
from universal_scalper_all import load_m1,resample,prep
from tre_leve import entries_breakout
d=load_m1(['/tmp/claude-0/dati_ftmo*/ABTG_M1_XAUUSD_*.csv'],';')
r=resample(d,'4h'); O,H,L,C,atr,sig,ha,ks=prep(r); idx4=r.index; n=len(C)
e55=np.where(entries_breakout(C,H,L,55)==1,1,0)
D_START=pd.Timestamp('2014-12-01')
m=d.loc[d.index>=D_START]; mi=m.index.values; lo=m['low'].values; cl=m['close'].values; op=m['open'].values
mday=mi.astype('datetime64[D]')
SW=0.055/360.0
trades={}   # i_signal -> dict
def build(i):
    ent=O[i+1]; risk=3*atr[i]
    if risk<=0 or np.isnan(atr[i]): return None
    stop=ent-risk; ext=ent; start=i+1; j=None; px=None
    for k in range(start,n):
        if L[k]<=stop: px=min(O[k],stop); j=k; break
        ext=max(ext,H[k]); stop=max(stop,ext-3*atr[k])
    if j is None: return None
    ts=idx4[start]; te=idx4[j]
    if ts<D_START: return None
    a=np.searchsorted(mi,np.datetime64(ts)); b=np.searchsorted(mi,np.datetime64(te)); end=min(b+240,len(m)); k=b
    while k<end and lo[k]>px+1e-9 and not (op[k]<=px): k+=1
    k=min(k,len(m)-1)
    if k<=a: return None
    dd_=(mi[a:k+1]-mi[a]).astype('timedelta64[s]').astype(float)/86400.0
    swap=ent*SW*dd_
    fl_lo=(lo[a:k+1]-ent)-0.35-swap; fl_cl=(cl[a:k+1]-ent)-0.35-swap
    freal=(px-ent)-0.35-swap[-1]; fl_lo[-1]=freal; fl_cl[-1]=freal
    days=mday[a:k+1]; ud,first=np.unique(days,return_index=True)
    rows=[]
    for q,u in enumerate(ud):
        s=first[q]; e_=(first[q+1] if q+1<len(ud) else len(days))
        rows.append((u,fl_lo[s:e_].min(),fl_cl[e_-1]))
    return dict(i=i,j=j,risk=risk,rows=rows,freal=freal,tentry=pd.Timestamp(ts),texit=pd.Timestamp(mi[k]))
sigs=[i for i in range(120,n-1) if e55[i]==1 and idx4[i+1]>=D_START]
for i in sigs:
    t=build(i)
    if t: trades[i]=t
sig_arr=np.array(sorted(trades))
print('segnali',len(sig_arr),flush=True)
def nextsig(minidx):
    p=np.searchsorted(sig_arr,minidx); return sig_arr[p] if p<len(sig_arr) else None
B0=80000.0
def run(start,risk,target):
    B=B0; i=nextsig(0)
    # primo segnale con ingresso >= start
    ts_arr=[trades[k]['tentry'] for k in sig_arr]
    p=0
    while p<len(sig_arr) and trades[sig_arr[p]]['tentry']<start: p+=1
    while p<len(sig_arr):
        t=trades[sig_arr[p]]; oz=B*risk/100.0/t['risk']; eq_prev=B
        for (u,fmin,fend) in t['rows']:
            emin=B+oz*fmin
            if (eq_prev-emin)/B0>=0.05: return ('daily',pd.Timestamp(u))
            if emin<=B0*0.90: return ('total',pd.Timestamp(u))
            eq_prev=B+oz*fend
        B+=oz*t['freal']
        if B>=B0*(1+target): return ('pass',t['texit'])
        # prossimo segnale con indice >= j
        jn=t['j']; q=np.searchsorted(sig_arr,jn)
        p=q
    return ('open',None)

import re,glob
# ---- trade Dow Raptor (tester a tick, 0,1 lotti): CT4 g (2025-01-01 -> 2026-11-13) + hold-out g (2024-09-26 -> 2024-12-31)
def parse(f):
    b=open(f,'rb').read(); t=b.decode('utf-16' if b[:2] in (b'\xff\xfe',b'\xfe\xff') else 'utf-8','replace')
    t=re.sub(r'<[^>]*>','|',t); t=re.sub(r'\s*\|[\s|]*','|',t)
    j=t.find('|Affari|'); s=t[j:].split('|'); out=[]; k=0
    # righe: Ora|Affare|Simbolo|Tipo|Direzione|Volume|Prezzo|Ordine|Commissioni|Swap|Profitto|Bilancio|Commento
    ent={}
    for q in range(len(s)-12):
        if re.match(r'\d{4}\.\d\d\.\d\d \d\d:\d\d:\d\d$',s[q]) and s[q+2].startswith('U30USD') and s[q+4] in ('in','out'):
            tt=pd.Timestamp(s[q].replace('.','-',2))
            if s[q+4]=='in': ent=tt
            else:
                pr=float(s[q+10].replace(' ','')); sw=float(s[q+9].replace(' ','')); cm=float(s[q+8].replace(' ',''))
                out.append((ent,tt,pr+sw+cm))
    return out
files=[glob.glob('/tmp/claude-0/ct4/UBSCT4_CLV_US30_g_M4_100000_2025/*/report/*.htm')[0],glob.glob('/tmp/claude-0/ho/x/UBSHO_CLV_US30_g_M4_100000_2024/*/report/*.htm')[0]]
dow=sorted(sum([parse(f) for f in files],[]),key=lambda x:x[1])
print('Dow trade',len(dow),'netto a 0,1 lotti',round(sum(x[2] for x in dow),2),'primo',dow[0][0],'ultimo',dow[-1][1],flush=True)
DOWD={}
for a,b_,p in dow:
    dd=np.datetime64(b_.normalize()); x=DOWD.setdefault(dd,[0.0,0.0]); x[0]+=p; x[1]+=min(p,0.0)
W0=np.datetime64('2024-09-26'); T_END=pd.Timestamp('2026-11-13')
# correlazione giornaliera Dow (0,1 lotti) vs oro a rischio 1% fra W0 e T_END
def gold_chain(start,risk=1.0):
    p=0
    while p<len(sig_arr) and trades[sig_arr[p]]['tentry']<start: p+=1
    ch=[]
    while p<len(sig_arr):
        t=trades[sig_arr[p]]; ch.append(t); p=np.searchsorted(sig_arr,t['j'])
    return ch

def run3(start,rg,kd,dd,target,inact):
    # regole Concept: DD statico dal saldo iniziale (equity al minuto), nessun limite giornaliero, obiettivo a saldo chiuso;
    # inact: None, 'A' (posizione aperta = attivita), 'B' (attivita solo ingressi/uscite); chiusura dopo 42 giorni senza attivita
    ch=[t for t in gold_chain(start) if t['texit']<=T_END+pd.Timedelta(days=1)]
    gd={}
    for ti,t in enumerate(ch):
        for ri,row in enumerate(t['rows']): gd[row[0]]=(ti,ri)
    days=sorted(set(gd)|set(k for k in DOWD if k>=np.datetime64(start.normalize()) and kd>0))
    days=[x for x in days if np.datetime64(x)<=np.datetime64(T_END)]
    Bc=B0; oz=0.0; lastact=None
    for dday in days:
        dday=np.datetime64(dday)
        emin_g=Bc; act=False; exit_after=None
        if dday in gd:
            ti,ri=gd[dday]; t=ch[ti]; u,fmin,fend=t['rows'][ri]
            if ri==0: oz=Bc*rg/100.0/t['risk']
            emin_g=Bc+oz*fmin
            if ri==len(t['rows'])-1: exit_after=oz*t['freal']
            act = True if inact=='A' else (ri==0 or ri==len(t['rows'])-1)
        dp,dn=DOWD.get(dday,(0.0,0.0))
        if kd>0 and dday in DOWD: act=True
        if inact and act:
            if lastact is not None and (dday-lastact).astype(int)>42: return ('inatt',dday)
            lastact=dday
        elif inact and lastact is None and act is False: pass
        emin=emin_g+kd*dn
        if emin<=B0*(1-dd): return ('total',dday)
        if exit_after is not None: Bc+=exit_after
        Bc+=kd*dp
        if Bc>=B0*(1+target): return ('pass',dday)
    return ('open',None)
KD={'PROP':2400/155.0,'MEDIO':4800/155.0,'ALTO':8000/155.0}; RG={'PROP':0.5,'MEDIO':0.9,'ALTO':1.3}
PROG=[('Premier 5%/7%',0.05,0.07),('Empire 10%/10%',0.10,0.10),('Foundation fase1 6%/10%',0.06,0.10),('Foundation fase2 6%/5%',0.06,0.05)]
def summ(out,starts,hor=(90,180,365)):
    n=len(out); pas=[(np.datetime64(o[1],'D')-np.datetime64(s.normalize(),'D')).astype(int) for o,s in zip(out,starts) if o[0]=='pass']
    fl=sum(1 for o in out if o[0] in ('total',)); ina=sum(1 for o in out if o[0]=='inatt'); op=sum(1 for o in out if o[0]=='open')
    hs=[]
    for H in hor:
        ok=[(o,s) for o,s in zip(out,starts) if (T_END-s).days>=H]
        if not ok: hs.append('-'); continue
        pp=sum(1 for o,s in ok if o[0]=='pass' and (np.datetime64(o[1],'D')-np.datetime64(s.normalize(),'D')).astype(int)<=H)
        ff=sum(1 for o,s in ok if o[0] in ('total','inatt') and (np.datetime64(o[1],'D')-np.datetime64(s.normalize(),'D')).astype(int)<=H)
        hs.append('%d/%d'%(round(100*pp/len(ok)),round(100*ff/len(ok))))
    return 'n%d passate %d%% | 3/6/12 mesi pass/fall: %s | fall DD %d, inatt %d, aperte %d | mediana gg %s'%(n,round(100*len(pas)/n),' '.join(hs),fl,ina,op,int(np.median(pas)) if pas else '-')
W1=pd.date_range('2015-01-01',T_END-pd.Timedelta(days=120),freq='7D')
W4=pd.date_range('2022-11-22',T_END-pd.Timedelta(days=120),freq='7D')
WD=pd.date_range('2024-09-26',T_END-pd.Timedelta(days=150),freq='7D')
for pname,dd,tg in PROG:
    print('######',pname)
    for gname in ('PROP','MEDIO','ALTO'):
        for inact in (None,'A','B'):
            lab='nessuna' if inact is None else 'inatt.'+inact
            print(' oro %-5s solo, dal 2015, %-8s :'%(gname,lab),summ([run3(s,RG[gname],0.0,dd,tg,inact) for s in W1],W1),flush=True)
            if inact is None:
                print(' oro %-5s solo, ult.4 anni      :'%gname,summ([run3(s,RG[gname],0.0,dd,tg,None) for s in W4],W4),flush=True)
    for gname,dname in (('PROP','PROP'),('MEDIO','MEDIO'),('ALTO','MEDIO'),('ALTO','ALTO'),('MEDIO','PROP')):
        print(' oro %-5s + Dow %-5s (26 mesi)      :'%(gname,dname),summ([run3(s,RG[gname],KD[dname],dd,tg,None) for s in WD],WD),flush=True)
    print(' [Dow in finestra: solo oro per confronto] oro ALTO solo (26 mesi):',summ([run3(s,RG['ALTO'],0.0,dd,tg,None) for s in WD],WD),flush=True)
