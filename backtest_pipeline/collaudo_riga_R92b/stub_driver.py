#!/usr/bin/env python3
# -*- coding: ascii -*-
# Stub di powershell.exe -File RIGA_ROUND_VPS.ps1: scrive gli stessi artefatti del driver vero, con numeri da scenario.
import sys, os, re, csv, json, shutil, time, hashlib
REPO=os.environ.get('REPO_ROOT','/home/user/GITHUB')
a=sys.argv[1:]
def J(base,rel):
    q=os.path.join(base,*rel.split('\\'))
    os.makedirs(os.path.dirname(q),exist_ok=True)
    return q
def arg(n):
    return a[a.index(n)+1] if n in a else None
EA=arg('-Expert'); PROVA=arg('-Prova'); LBL=arg('-Etichetta'); PIN=arg('-Pin'); MOD=arg('-Modello'); DEP=arg('-Deposito')
UP=os.environ['USERPROFILE']; AP=os.environ['APPDATA']; DSK=os.environ['DESKTOP_DIR']
SCEN=json.load(open(os.environ['SCENARIO']))
wdir=os.path.join(UP,'abtg_round')
log=open(os.path.join(os.environ['HARNESS_LOG']),'a'); log.write('STUB %s %s modello=%s dep=%s\n'%(LBL,PROVA,MOD,DEP)); log.close()
sc=SCEN.get(LBL,{})
if sc.get('rc1'):
    sys.exit(1)
# prova dal pin (o variante)
src=os.path.join(REPO,'backtest_pipeline','prove',PROVA)
txt=open(src,'rb').read()
if sc.get('mut_prova'): txt=txt.replace(b'Risk_Percent=0.8',b'Risk_Percent=0.9')
if sc.get('mut_window'): txt=txt.replace(b'@FRAZIONEIS 0.7275',b'@FRAZIONEIS 0.7274')
os.makedirs(wdir,exist_ok=True)
open(J(wdir,'prove\\'+PROVA),'wb').write(txt)
eatxt=open(os.path.join(REPO,'mql5/Experts/ABTG_Bulge.mq5'),'rb').read()
if sc.get('mut_ea'): eatxt+=b'\n//x'
open(J(wdir,'src_prove\\'+EA+'.mq5'),'wb').write(eatxt)
open(J(wdir,'src_include\\ABTG_PausaGuardian.mqh'),'wb').write(open(os.path.join(REPO,'mql5/Include/ABTG_PausaGuardian.mqh'),'rb').read())
# leggi la prova
pins=[]; axis=None; dirs={}
for l in txt.decode().splitlines():
    t=l.strip()
    if not t or t.startswith('#'): continue
    if t.startswith('@'):
        m=re.match(r'@(\w+)\s+(.+)',t); dirs[m.group(1).upper()]=m.group(2).strip(); continue
    k,v=t.split('=',1)
    if '||' in v and v.split('||')[-1] in ('Y','N'):
        p=v.split('||')
        if p[-1]=='Y': axis=(k,p); pins.append((k,None)); continue
        v=p[0]
    pins.append((k,v))
ak,ap=axis
start,stop,step=float(ap[1]),float(ap[3]),float(ap[2])
# valori dell'asse
vals=[]; x=start; n=0
while x<=stop+1e-9 and n<50:
    vals.append(round(x,10)); x+=step; n+=1
if 'axis_vals' in sc: vals=sc['axis_vals']
def cellrows(fase):
    rows=[]
    for i,v in enumerate(vals):
        c=sc.get(fase,{})
        key='%g'%v
        d=c.get(key) or c.get('*') or {'Trades':100,'Profit':500.0,'PF':1.3,'DD':4.0}
        rows.append((i,v,d))
    return rows
hdr=['Pass','Profit','Expected Payoff','Profit Factor','Recovery Factor','Sharpe Ratio','Equity DD %','Trades','Peggior Giornata %','Perdite Consecutive Max','Serie Perdente Peggiore']+[k for k,_ in pins]
def valfmt(k,v,axv):
    if k==ak:
        return ('%g'%axv)
    if v in ('true','false'): return '1' if v=='true' else '0'
    return v
rdir=os.path.join(wdir,'risultati_prove\\'+EA+'\\')
os.makedirs(os.path.join(wdir),exist_ok=True)
sm='_ohlc' if MOD!='4' else ''
def write_csv(fase):
    fn=J(wdir,'risultati_prove\\'+EA+'\\'+EA+'_GBPUSD_'+fase+sm+'_'+LBL+'.csv')
    if sc.get('no_%s'%fase): return None
    with open(fn,'w',newline='',encoding='ascii') as f:
        w=csv.writer(f,lineterminator='\r\n')
        w.writerow(hdr)
        for i,v,d in cellrows(fase):
            if sc.get('empty_%s'%fase): continue
            row=[str(i),'%.2f'%d['Profit'],'1.00000','%.5f'%d['PF'],'0.50000','1.00000','%.4f'%d['DD'],str(d['Trades']),'-1.0000','3','-100.00']
            for k,pv in pins:
                vv=valfmt(k,pv,v)
                if sc.get('bad_offset') and k=='Signal_Bar_Offset': vv=sc['bad_offset']
                row.append(vv)
            w.writerow(row)
    return fn
time.sleep(float(sc.get('sleep',0)))
f1=write_csv('IS'); f2=write_csv('OOS')
# per-trade: sopravvive l'ultima cella OOS (o quella indicata)
mags=[]
for k,pv in pins:
    if k=='InpMagic': mags=[pv]
if axis[0]=='InpMagic':
    mags=[str(int(vals[0])),str(int(vals[-1]))]
if not sc.get('no_pertrade'):
    surv=sc.get('surv_idx',len(vals)-1)
    oosrows=cellrows('OOS'); d=oosrows[surv][2]
    for mg in mags:
        fn=J(AP,'MetaQuotes\\Terminal\\Common\\Files\\abtg_trades_'+EA+'_GBPUSD_'+mg+'_violaEA.csv')
        os.makedirs(os.path.dirname(fn) if os.path.dirname(fn) else '.',exist_ok=True)
        n=d['Trades']; tot=d['Profit']
        if n<=0: continue
        rows=[]; sig=['VIOLA','BLU','ARANCIO']; syms=['EURUSD','GBPJPY','AUDNZD','GBPUSD','USDCHF']
        wins=int(n*0.7)
        vs=[]
        for i in range(n):
            vs.append(20.0 if i<wins else -30.0)
        adj=round(tot-sum(vs[:-1]),2); vs[-1]=adj
        for i in range(n):
            rows.append(['2025.%02d.%02d 10:00:00'%(4+(i%9),1+(i%27)),syms[i%5],mg,str(1000+i),'1','0.10','1.23456','%.2f'%vs[i],sig[i%3] if not sc.get('sig_only_viola') else 'VIOLA','BULGE_%s_L'%sig[i%3],'sl'])
        with open(fn,'w',newline='',encoding='ascii') as f:
            f.write('close_time;symbol;magic;position_id;deal_type;volume;price;net_profit;signal;entry_comment;exit_comment\n')
            for r in rows: f.write(';'.join(r)+'\n')
# cartella del driver sul Desktop
d=os.path.join(DSK,'ROUND_'+LBL); os.makedirs(d,exist_ok=True)
open(os.path.join(d,'REFERTO_ROUND_'+LBL+'.txt'),'w').write('referto finto\n')
for f_ in (f1,f2):
    if f_ and os.path.exists(f_): shutil.copy(f_,os.path.join(d,os.path.basename(f_)))
shutil.copy(J(wdir,'prove\\'+PROVA),os.path.join(d,PROVA))
sys.exit(int(sc.get('rc',3)))
