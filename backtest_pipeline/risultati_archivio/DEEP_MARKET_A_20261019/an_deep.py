import sys,glob,os,csv,re,statistics,collections
sys.path.insert(0,'.')
from an_set import head,inputs,stats
def num(s):
    try: return float(str(s).replace(' ','').replace(',',''))
    except: return 0.0
res={}
for d in sorted(glob.glob('deep/DEEP_*')):
    nm=os.path.basename(d)[5:]
    man=list(csv.reader(open(d+'/MANIFEST_DEEP.csv'),delimiter=';'))[1:]
    ref=open(d+'/REFERTO_DEEP_TRANCHE.txt',encoding='ascii',errors='replace').read()
    ex_ok=len(re.findall(r'EX5_DOPO.*UGUALE',ref)); ex_tot=len(re.findall(r'EX5_DOPO',ref))
    mon=[m for m in man if m[0]!='TRANCHE22']; cont=[m for m in man if m[0]=='TRANCHE22']
    okm=[m for m in mon if m[7]=='OK']
    nets=[num(m[10]) for m in okm]; trades=[int(m[9]) for m in okm if m[9]]
    dd=[]
    for m in okm:
        mm=re.search(r'\(([\d.]+)%\)',m[12]); dd.append(float(mm.group(1)) if mm else 0)
    pos=sum(1 for x in nets if x>0)
    conf=all(m[14]=='100%ticksreali' and m[22]=='0' for m in man) 
    ko=[m[0]+':'+m[-1][:60] for m in man if m[7]!='OK']
    # input confronto con setaccio
    sdir=glob.glob('set/SCREEN_'+nm+'/report/*TRANCHE1_*.htm')
    ddir=sorted(glob.glob(d+'/report/*TRANCHE1_*.htm'))
    diff=[]
    if sdir and ddir:
        a=inputs(sdir[0]); b=inputs(ddir[0])
        for k in sorted(set(a)|set(b)):
            if a.get(k)!=b.get(k): diff.append((k,a.get(k),b.get(k)))
    # mesi: meta
    pf_all=[float(m[11]) for m in okm if m[11] not in ('','inf')]
    first=sum(nets[:17]); second=sum(nets[17:]); h1=sum(nets[:10]); h2=sum(nets[10:])
    r=dict(nome=nm,n_ok=len(okm),ko=ko,sum=sum(nets),pos=pos,ddmax=max(dd) if dd else 0,trades=sum(trades),f17=first,s4=second,h10=h1,h11=h2,conf=conf,ex=(ex_ok,ex_tot),diff=diff)
    if cont:
        c=cont[0]; r['c_stato']=c[7]; r['c_trades']=c[9]; r['c_net']=c[10]; r['c_pf']=c[11]; r['c_dd']=c[12]; r['c_dur']=c[5]
        f=glob.glob(d+'/report/*TRANCHE22_*.htm')
        if f:
            f=[x for x in f if x.endswith('.htm')][0]
            h=head(f); s=stats(f)
            r['c_head']={k:h.get(k) for k in ('Profitto Totale Netto','Equità Drawdown Assoluta','Equità Drawdown Massima','Bilancio Drawdown Massimo','Fattore di Profitto','Operazioni di Trading in Profitto (% del totale)') if k in h}
            r['c_lot']=(s['lmin'],s['lmax']); r['c_maxpos']=s['maxpos']; r['c_win']=s['win']; r['c_avg']=statistics.mean(s['res']) if s['res'] else 0; r['c_n']=s['n']
    res[nm]=r
for nm,r in res.items():
    print('=====',nm)
    print(' conforme(ticks100,no stopout):',r['conf'],'| EX5 uguale',r['ex'],'| tranche OK',r['n_ok'],'/21 | KO',r['ko'])
    print(' input diversi dal setaccio:',r['diff'][:6] if r['diff'] else 'NESSUNO')
    print(' MENSILI: somma %.0f | mesi positivi %d/21 | DD max mensile %.1f%% | operazioni %d | primi17 %.0f ultimi4 %.0f | meta10 %.0f meta11 %.0f'%(r['sum'],r['pos'],r['ddmax'],r['trades'],r['f17'],r['s4'],r['h10'],r['h11']))
    if 'c_stato' in r:
        print(' CONTINUA: stato',r['c_stato'],'op',r['c_trades'],'netto',r['c_net'],'PF',r['c_pf'],'DD',r['c_dd'],'durata s',r['c_dur'])
        print('   head',r.get('c_head'),'lotti',r.get('c_lot'),'maxpos',r.get('c_maxpos'),'win%%%.0f'%r.get('c_win',0),'media/op %.2f'%r.get('c_avg',0))
