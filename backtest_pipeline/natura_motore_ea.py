import sys,glob,re,gzip,datetime,statistics,collections,tempfile
sys.path.insert(0,'.')
import leggi_deep80k_nuovi as B
A='risultati_archivio/'
SRC={'Umbra Vault':A+'DEEP80K_MARKET_NUOVI_20261025/DEEP80K_UMBRAVAULTAIEA','Vortex Turbo':A+'DEEP80K_MARKET_NUOVI_20261025/DEEP80K_VORTEXTURBOEA','Microedge':A+'DEEP80K_MARKET_NUOVI_20261025/DEEP80K_MICROEDGENEURALMATRIXEA','Gold Snap':A+'DEEP80K_MARKET_NUOVI_20261025/DEEP80K_GOLDSNAP','SomaGold':A+'DEEP80K_SOMAGOLD_20261025'}
def load(c):
    f=glob.glob(c+'/report/*.htm')+glob.glob(c+'/report/*.htm.gz')
    p=f[0]
    if p.endswith('.gz'):
        t=tempfile.NamedTemporaryFile(delete=False); t.write(gzip.open(p,'rb').read()); t.close(); p=t.name
    return B.righe(B.leggi(p))
def T(s): return datetime.datetime.strptime(s[:19],'%Y.%m.%d %H:%M:%S')
for nome,c in SRC.items():
    R=load(c)
    # input
    ini=[i for i,r in enumerate(R) if r and r[0] in ('Parametri','Inputs','Parametri:')]
    par=[]
    for r in R[:ini[0]+80] if ini else R[:120]:
        if len(r)>=1 and re.match(r'^[A-Za-z_][\w]*=',r[0]): par.append(r[0])
    ii=[k for k,r in enumerate(R) if r and r[0] in ('Affari','Deals')][0]
    D=[]
    for r in R[ii+2:]:
        if len(r)>=12 and re.match(r'\d{4}\.\d\d',r[0]) and r[3]!='balance' and r[2]:
            D.append(dict(t=T(r[0]),tipo=r[3].lower(),dir=r[4].lower(),vol=B.num(r[5]),px=B.num(r[6]),ordine=r[7],net=B.num(r[8])+B.num(r[9])+B.num(r[10]),com=r[-1] if len(r)>12 else ''))
    ins=[x for x in D if x['dir'].startswith('in')]; outs=[x for x in D if x['dir'].startswith('out')]
    # posizioni: FIFO per tipo non possibile senza id; stima durata con evento
    ev=sorted([(x['t'],1,x) for x in ins]+[(x['t'],-1,x) for x in outs],key=lambda z:(z[0],-z[1]))
    k=mx=0; conc=[]; last=None; tw=0.0; tot=0.0
    for t,e,x in ev:
        if last is not None:
            dt=(t-last).total_seconds(); tw+=k*dt; tot+=dt
        k+=e; mx=max(mx,k); last=t
    # holding: abbina con volume e tipo (long: buy in / sell out) FIFO
    q={'buy':[], 'sell':[]}; hold=[]
    for t,e,x in ev:
        if e==1: q[x['tipo']].append(x)
        else:
            opp='buy' if x['tipo']=='sell' else 'sell'
            if q[opp]: y=q[opp].pop(0); hold.append((x['t']-y['t']).total_seconds()/60)
    w=[x['net'] for x in outs if x['net']>0]; l=[x['net'] for x in outs if x['net']<0]
    # averaging: entrata consecutiva nella stessa direzione mentre ce n'e una aperta a prezzo peggiore
    avg=0; ent=0; openb=[];opens=[]
    for t,e,x in ev:
        if e==1:
            ent+=1
            if x['tipo']=='buy':
                if openb and x['px']<min(y['px'] for y in openb): avg+=1
                openb.append(x)
            else:
                if opens and x['px']>max(y['px'] for y in opens): avg+=1
                opens.append(x)
        else:
            L=openb if x['tipo']=='sell' else opens
            if L: L.pop(0)
    both=0
    print('=====',nome,'| ingressi',len(ins),'uscite',len(outs))
    print('  vinc %.0f%%  media vinc %.1f  media perd %.1f  payoff %.2f  perdita max %.0f  vincita max %.0f'%(100*len(w)/max(1,len(w)+len(l)),sum(w)/max(1,len(w)),sum(l)/max(1,len(l)),(sum(w)/max(1,len(w)))/abs(sum(l)/max(1,len(l))) if l else 0,min(l) if l else 0,max(w) if w else 0))
    print('  posizioni aperte contemporaneamente: max %d, media pesata nel tempo %.2f'%(mx,tw/tot if tot else 0))
    if hold: print('  durata (min): mediana %.0f  p90 %.0f  max %.0f'%(statistics.median(hold),sorted(hold)[int(.9*len(hold))],max(hold)))
    print('  ingressi che AGGIUNGONO nella stessa direzione a prezzo peggiore di una posizione gia aperta: %d su %d (%.0f%%)'%(avg,ent,100*avg/max(1,ent)))
    print('  lotto min/max %.2f/%.2f ; buy %d sell %d'%(min(x['vol'] for x in ins),max(x['vol'] for x in ins),sum(1 for x in ins if x['tipo']=='buy'),sum(1 for x in ins if x['tipo']=='sell')))
    print('  commenti ingresso:',collections.Counter(re.sub(r'[\d.]+','#',x['com']) for x in ins).most_common(5))
    print('  input:',' | '.join(par)[:1500])
