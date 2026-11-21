# Sensibilita' "lente tick" (INFORMATIVA, scritta dopo aver visto F5): costo extra per operazione dei soli scalper pari alla differenza M1 -> tick reali 2025
# misurata in RISULTATI_UBS_C_FOREX_TICK_2026-11-15.md (circa 1,4-2,0 EUR a operazione a 0,1 lotto): scalper 0,5 + 2,0 = 2,5 EUR; VOL 0,5 (invariato)
src=open('/home/user/GITHUB/backtest_runner/simulatore/ubs_non_oro.py',encoding='utf-8').read()
exec(src[:src.index("P('\\n=== F4")])
CT=lambda s:(2.5 if s.startswith('SCALP') else 0.5)
def ser2(s,p): return series(s,p,CT(s))
def tr2(s,p): return tradesnet(s,p,CT(s))
def ev(ch,m,pe):
    ser=sum(mi*ser2(s,pe) for mi,s in zip(m,ch)); tr=pd.concat([tr2(s,pe).assign(net=lambda x,mi=mi:x.net*mi) for mi,s in zip(m,ch)]).net.values
    pf=tr[tr>0].sum()/-tr[tr<0].sum() if (tr<0).any() else np.inf; x=ser.values; n=len(x); R={'ph2':0,'ph1':0,'fail':0,'tot':0}; days=[]
    for st in range(0,n-20,3):
        end=min(n,st+756); base=0.0; ph=1; tgt=10000.0; f=False; d1=None; R['tot']+=1; cum=0.0
        for i in range(st,end):
            cum+=x[i]
            if x[i]<=-5000 or cum-base<=-10000: f=True; break
            if cum-base>=tgt:
                if ph==1: ph=2; R['ph1']+=1; d1=i-st; base=cum; tgt=5000.0
                else: R['ph2']+=1; break
        if f: R['fail']+=1
        if d1 is not None: days.append(d1)
    t=R['tot']; return dict(pf=pf,net=x.sum(),dd=mdd(x),ph2=R['ph2']/t,ph1=R['ph1']/t,fail=R['fail']/t,med=np.median(days) if days else np.nan)
P('\n=== LENTE TICK (informativa, post hoc): scalper 2,5 EUR/operazione, VOL 0,5; stesse combinazioni costruite sopra')
for pname,pool in (('A',POOLA),('C',POOLC)):
    for pb,pe in (('P1','P2'),('P2','P1')):
        b=build(pool,pb); ch,m,_=b; e=ev(ch,m,pe)
        P(f'Pool {pname} {pb}->{pe} {ch}: PF {e["pf"]:.2f}, netto {e["net"]:.0f}, DD realizzato {e["dd"]:.0f}, 2 fasi {e["ph2"]*100:.0f}%, fase 1 {e["ph1"]*100:.0f}%, falliscono {e["fail"]*100:.0f}%')
# solo VOL (sopravvissuti a tick): combinazione impossibile per la regola un-set-per-simbolo-e-famiglia; mostra il miglior singolo
for s in ('VOL_f','VOL_o'):
    for p in ('P1','P2'):
        x=ser2(s,p).values; P(f'{s} {p} da solo, a 0,1 lotti: netto {x.sum():.0f} EUR, DD realizzato {mdd(x):.0f}, operazioni {int((D[(s,PER[p][0])].dir=="out").sum())}')
open('/home/user/GITHUB/report/UBS_NON_ORO_LENTE_TICK_2026-11-21.txt','w',encoding='utf-8').write('\n'.join(out)+'\n')
