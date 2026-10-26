import csv, math, datetime as dt, statistics as st
B="/tmp/claude-0/-home-user-GITHUB/c2d73886-9ef2-5105-8937-d770bc36d6df/scratchpad/lavoro_wt"
D=B+"/report/sala_bias/agents/A7/verifica_studio"
bars=[]
with open(D+"/D1_fuso_A7.csv") as f:
    r=csv.reader(f,delimiter=";"); next(r)
    for x in r: bars.append((dt.date.fromisoformat(x[0]),float(x[1]),float(x[2]),float(x[3]),float(x[4])))
date=[b[0] for b in bars]; op=[b[1] for b in bars]; cl=[b[4] for b in bars]
sc={}
with open(B+"/report/sala_bias/agents/A4/score_A4.csv") as f:
    r=csv.reader(f,delimiter=";"); next(r)
    for x in r: sc[dt.date.fromisoformat(x[0])]=float(x[1]) if x[1]!="" else None
print("date score non in barre:",len(set(sc)-set(date)),"barre senza score:",len(set(date)-set(sc)))
START=dt.date(2008,7,1); END=dt.date(2026,10,16)
def state(s):
    if s is None: return None
    return "BULL" if s>=15 else ("BEAR" if s<=-15 else "NEU")
n=len(bars)
idx0=next(i for i in range(n) if date[i]>=START)
out=[]
def P(*a):
    s=" ".join(str(x) for x in a); print(s); out.append(s)
P("MIEI NUMERI - A7 verifica T006 (lettura PRIMARIA dal 2008-07-01, definizione (a): BULL>=+15, BEAR<=-15)")
P("prima barra t primaria:",date[idx0],"indice",idx0,"; ultima barra dati:",date[-1],"; barre fuse totali:",n)
# score mancanti nel periodo
miss=[date[i] for i in range(idx0,n) if sc.get(date[i]) is None]
P("giorni senza score nel periodo primario:",len(miss),miss[:3])
# frequenze e episodi (tutti i giorni t>=2008-07-01 con score, fino a 2026-10-16)
days=[i for i in range(idx0,n) if sc.get(date[i]) is not None]
stt={i:state(sc[date[i]]) for i in days}
def freq_ep(ds,label):
    cnt={"BULL":0,"BEAR":0,"NEU":0}; ep={"BULL":0,"BEAR":0,"NEU":0}; prev=None;prevI=None
    for i in ds:
        s=stt[i]; cnt[s]+=1
        if s!=prev or (prevI is not None and i!=prevI+1): ep[s]+=1
        prev=s; prevI=i
    N=len(ds)
    P(label,"N giorni",N,"| freq:",{k:f"{cnt[k]} ({100*cnt[k]/N:.2f}%)" for k in cnt},"| episodi:",ep)
freq_ep(days,"[tutti i giorni t da 2008-07-01 a 2026-10-16]")
def mean(x): return sum(x)/len(x)
def var(x):
    m=mean(x); return sum((v-m)**2 for v in x)/(len(x)-1)
def welch(a,b):
    if len(a)<2 or len(b)<2: return float("nan")
    return (mean(a)-mean(b))/math.sqrt(var(a)/len(a)+var(b)/len(b))
for h in (20,5):
    P("")
    P(f"===== h = {h} =====")
    valid=[i for i in days if i+h<n and date[i+h]<=END and i+1<n]
    ret={i:(cl[i+h]/op[i+1]-1)*100 for i in valid}
    P("osservazioni valide:",len(valid),"primo t",date[valid[0]],"ultimo t",date[valid[-1]],"(close t+h",date[valid[-1]+h],")")
    freq_ep(valid,f"[giorni validi h={h}]")
    by={"BULL":[],"BEAR":[],"NEU":[]}
    for i in valid: by[stt[i]].append(ret[i])
    allr=[ret[i] for i in valid]
    mall=mean(allr)
    for k in by: P(f"  {k}: N={len(by[k])} media rendimento={mean(by[k]):.4f}%  (sd {math.sqrt(var(by[k])):.3f})")
    P(f"  TUTTI i giorni: N={len(allr)} media={mall:.4f}%")
    P(f"  spread BULL-BEAR = {mean(by['BULL'])-mean(by['BEAR']):.4f} punti %")
    P(f"  eccesso BULL sul drift (media tutti) = {mean(by['BULL'])-mall:.4f}% ; eccesso BEAR = {mean(by['BEAR'])-mall:.4f}% ; NEU = {mean(by['NEU'])-mall:.4f}%")
    ts=[]
    for off in range(h if h==5 else 17):
        if h==20 and off not in (0,4,8,12,16): continue
        if h==5 and off not in (0,1,2,3,4): continue
        sel=valid[off::h]
        b=[ret[i] for i in sel if stt[i]=="BULL"]; r_=[ret[i] for i in sel if stt[i]=="BEAR"]
        t=welch(b,r_); ts.append(t)
        P(f"  non sovrapposte offset {off}: n totale={len(sel)} nBULL={len(b)} nBEAR={len(r_)} mediaBULL={mean(b):.4f} mediaBEAR={mean(r_):.4f} spread={mean(b)-mean(r_):.4f} t Welch={t:.4f}")
    ts_s=sorted(ts)
    P(f"  t Welch offset (mediana, min, max) = {st.median(ts):.4f}, {min(ts):.4f}, {max(ts):.4f}")
open(D+"/MIEI_NUMERI.txt","w").write("\n".join(out)+"\n")
