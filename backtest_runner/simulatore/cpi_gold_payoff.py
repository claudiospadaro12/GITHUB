import pandas as pd, numpy as np, sys
src=open('/home/user/GITHUB/backtest_runner/simulatore/cpi_gold_target.py').read().split("# passo 0: tester reale")[0]
sys.argv=['x','/tmp/claude-0/cpi_ev2.pkl','/tmp/claude-0/gold_m1.pkl','x']; exec(src)
A=pd.read_pickle('/tmp/claude-0/cpi_a.pkl').set_index('e'); PX={e:m.close.asof(e) for e in A.index}
def stats(x,amp,nome):
    x=np.array(x); w=x[x>0]; l=x[x<0]
    if len(w)==0 or len(l)==0: print(nome,'dati insufficienti'); return
    wr=len(w)/len(x); aw=w.mean(); al=-l.mean(); pf=(w.sum())/(-l.sum()); be=al/(aw+al)
    print('%-34s n=%3d | vincenti %2.0f%% | profitto medio %+6.2f | perdita media %6.2f | rapporto %.2f | PF %.2f | pareggio a %2.0f%% | profitto medio = %.2f x ampiezza media, perdita = %.2f x'%(nome,len(x),wr*100,aw,al,aw/al,pf,be*100,aw/amp,al/amp))
# 27 eventi reali del tester (USD/oz)
d=pd.read_csv('/root/.claude/uploads/c2d73886-9ef2-5105-8937-d770bc36d6df/7e07ceb6-testergraph.report.2026.11.25.csv',sep='\t',encoding='utf-16'); d.columns=['t','bal','eq','load']; d['t']=pd.to_datetime(d.t,format='%Y.%m.%d %H:%M')
ch=pd.DataFrame({'t':d.t.values[1:],'d':np.diff(d.bal.values)}); ch=ch[ch.d.abs()>0.005]; ch['day']=pd.to_datetime(ch.t).dt.date; real=(ch.groupby('day').d.sum()/10.0)
evs=[e for e in ev.exp if e in A.index]
amp_all=A.r.loc[[e for e in evs if e.year>=2023]].mean()
print('AMPIEZZA media candela CPI M5 2023-2026: %.2f USD/oz (mediana %.2f) | 2018-2022: %.2f'%(amp_all,A.r.loc[[e for e in evs if e.year>=2023]].median(),A.r.loc[[e for e in evs if 2018<=e.year<=2022]].mean()))
print('\nREALE (tester, tick reali) 2024-07..2026-11:'); stats(real.values,amp_all,'tester B100, 27 eventi')
for lab,y0,y1,amp in (('2018-2022',2018,2022,A.r.loc[[e for e in evs if 2018<=e.year<=2022]].mean()),('2023-2026',2023,2026,amp_all)):
    for nm,pen in (('M1 senza penalita',0.0),('M1 penalita 2,63',2.63)):
        x=[sim(e,pen=pen) for e in evs if y0<=e.year<=y1]; x=[v for v in x if v is not None and v!=0.0]
        stats(x,amp,'%s %s'%(lab,nm))

print('\nESPLORATIVO (POST HOC, dopo aver visto che la perdita reale e il doppio della simulata): variante di stop, M1, penalita 0 / 1,0 USD/oz per ingresso')
def sim2(e, sl_mode, pen=0.0, buf=1.0):
    pl = m.loc[e - pd.Timedelta(minutes=10):e - pd.Timedelta(minutes=5, seconds=1)]
    if len(pl) < 4: return None
    ph, pl_ = pl.high.max(), pl.low.min(); up, dn = ph + buf, pl_ - buf; rng = up - dn
    bars = m.loc[e - pd.Timedelta(minutes=5):e + pd.Timedelta(minutes=4)]
    if len(bars) < 8: return None
    pos = None
    for t, b in bars.iterrows():
        sp = b['spread'] * 0.01 if b['spread'] > 0 else 0.30
        hu = b.high + sp >= up; hd = b.low <= dn
        if pos is None:
            if hu and hd: return -(rng) - sp - pen if sl_mode == 'opp' else -(rng / 2) - sp - pen
            if hu: pos = 'L'; ent = up; slv = {'opp': dn, 'none': -1e9, 'half': up - rng / 2}[sl_mode]; continue
            if hd: pos = 'S'; ent = dn; slv = {'opp': up, 'none': 1e9, 'half': dn + rng / 2}[sl_mode]; continue
        else:
            if pos == 'L' and b.low <= slv: return (slv - ent) - sp - pen
            if pos == 'S' and b.high + sp >= slv: return (ent - slv) - sp - pen
    if pos is None: return 0.0
    last = bars.iloc[-1].close; return ((last - ent) if pos == 'L' else (ent - last)) - sp - pen
for lab, y0, y1 in (('2018-2022', 2018, 2022), ('2023-2026', 2023, 2026)):
    amp = A.r.loc[[e for e in evs if y0 <= e.year <= y1]].mean()
    for mode in ('opp', 'half', 'none'):
        for pen in (0.0, 1.0):
            x = [sim2(e, mode, pen) for e in evs if y0 <= e.year <= y1]; x = [v for v in x if v is not None and v != 0.0]
            stats(x, amp, '%s SL %s pen %.0f' % (lab, mode, pen))
