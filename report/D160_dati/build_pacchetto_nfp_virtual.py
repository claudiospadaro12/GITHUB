import json,csv,re,glob,os,sys
SP='/tmp/claude-0/-home-user-GITHUB/c2d73886-9ef2-5105-8937-d770bc36d6df/scratchpad'
sys.path.insert(0,SP)
OUT=SP+'/pacchetto'
# --- Virtual SL/TP oro (33) + riferimento D160 oro
R=json.load(open(SP+'/vsltp_oro_res.json'))
rows=[]
for k,v in sorted(R.items()):
    if not v or v.get('net') is None: continue
    m=re.match(r'VSLTP_(V99|V0|C0)_R(\d)_(L\d)_(\w\w)_160000_(\d{4})',k)
    if m: arm,rep,liv,ea,y=m.groups(); tipo='TEST'
    else:
        m=re.match(r'D160_R(\d)_(L\d)_(\w\w)_160000_(\d{4})',k)
        if not m: continue
        rep,liv,ea,y=m.groups(); arm='BASE'; tipo='RIFERIMENTO'
    if tipo=='RIFERIMENTO' and (ea,liv) not in (('GB','L0'),('PH','L1'),('GR','L3')): continue
    rows.append(dict(test='VIRTUAL_SLTP',etichetta=k,tipo=tipo,EA={'GB':'Goldbot One','PH':'Gold Phantom','GR':'Gold Reaper'}[ea],livello=liv,anno=y,ripetizione=rep,braccio=arm,stato=v['stato'],qualita_pct=v['q'],operazioni=v['ops'],netto_EUR=v['net'],PF=v['pf'],DD_equity_pct=v['ddp'],peggior_giorno_EUR=round(v['wd'],2) if v.get('wd') is not None else '',righe_giornale=v.get('righe',''),stop_out=v.get('so',''),no_money=v.get('nm','')))
G=json.load(open(SP+'/vsltp_gtp2_res.json'))
for k,v in sorted(G.items()):
    arm,y=k.split('|')
    rows.append(dict(test='VIRTUAL_SLTP',etichetta='GTP_%s_%s'%(arm,y),tipo='RIFERIMENTO' if arm=='BASE' else 'TEST',EA='Gold Trade Pro',livello='COMBO',anno=y,ripetizione='1',braccio=arm,stato=v['stato'],qualita_pct=v['q'],operazioni=v['ops'],netto_EUR=v['net'],PF=v['pf'],DD_equity_pct=v['ddp'],peggior_giorno_EUR=round(v['wd'],2),righe_giornale=v['righe'],stop_out=v['so'][0],no_money=v['so'][1]))
cols=['test','etichetta','tipo','EA','livello','anno','ripetizione','braccio','stato','qualita_pct','operazioni','netto_EUR','PF','DD_equity_pct','peggior_giorno_EUR','righe_giornale','stop_out','no_money']
with open(OUT+'/01_virtual_sltp_passate.csv','w',newline='',encoding='utf-8') as f:
    w=csv.DictWriter(f,fieldnames=cols); w.writeheader(); [w.writerow(r) for r in rows]
print('virtual',len(rows))
# --- NFP spento oro
N=json.load(open(SP+'/nfpoff_oro_res.json'))
rows=[]
for k,v in sorted(N.items()):
    m=re.match(r'NFPOFF_N0_R(\d)_(L\d)_(\w\w)_160000_(\d{4})',k); rep,liv,ea,y=m.groups()
    nm={'GB':'Goldbot One','PH':'Gold Phantom','GR':'Gold Reaper'}[ea]
    for tipo,d in (('TEST_NFP_SPENTO',v['r']),('RIFERIMENTO_NFP_ACCESO',v['b'])):
        if not d or d.get('net') is None: continue
        rows.append(dict(test='NFP',etichetta=k,tipo=tipo,EA=nm,livello=liv,anno=y,ripetizione=rep,stato=d['stato'],qualita_pct=d['q'],operazioni=d['ops'],netto_EUR=d['net'],PF=d['pf'],DD_equity_pct=d['ddp'],peggior_giorno_EUR=round(d['wd'],2),posizioni_attraverso_NFP=d['thru']))
# GTP NFP off (valido)
import subprocess
exec(open(SP+'/nfpoff_gtp2_an.py').read().split('tn=tb=0')[0])
for y in ('2013','2020','2025'):
    for tipo,d in (('TEST_NFP_SPENTO',SP+'/nfpoff_gtp2/NFPOFF_N0_R1_COMBO_GTP_160000_'+y),('RIFERIMENTO_NFP_ACCESO',SP+'/d160gtp/D160_GTP_COMBO_160000_'+y)):
        r=refer(d); n,_=thru(d,y)
        rows.append(dict(test='NFP',etichetta='GTP_'+y,tipo=tipo,EA='Gold Trade Pro',livello='COMBO',anno=y,ripetizione='1',stato=r['stato'],qualita_pct=r['q'],operazioni=r['ops'],netto_EUR=r['net'],PF=r['pf'],DD_equity_pct=r['ddp'],peggior_giorno_EUR=round(wd(d),2),posizioni_attraverso_NFP=n))
cols=['test','etichetta','tipo','EA','livello','anno','ripetizione','stato','qualita_pct','operazioni','netto_EUR','PF','DD_equity_pct','peggior_giorno_EUR','posizioni_attraverso_NFP']
with open(OUT+'/02_nfp_filtro_passate.csv','w',newline='',encoding='utf-8') as f:
    w=csv.DictWriter(f,fieldnames=cols); w.writeheader(); [w.writerow(r) for r in rows]
print('nfp',len(rows))
