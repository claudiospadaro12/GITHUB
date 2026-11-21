# Criteri: report/CORRELAZIONE_EA_ORO_CRITERI_2026-11-21.md (sezione ESTENSIONE)
import sys,pickle,re; sys.path.insert(0,'/home/user/GITHUB/backtest_runner/simulatore')
src=open('/home/user/GITHUB/backtest_runner/simulatore/supertrend_correlazione.py',encoding='utf-8').read()
exec(src[:src.index("out=[]")])
Sx=S.rename(columns={'A_ST_H1':'ST_H1','B_ST_H4':'ST_H4','C_DON55_D1':'DON55','D_ORO_FERMO':'ORO'})
D=pickle.load(open('/tmp/claude-0/gr/deals.pkl','rb')); out=[]
def P(*a):
    s=' '.join(str(x) for x in a); out.append(s); print(s,flush=True)
def num(x): return float(re.sub(r'[\s ]','',x) or 0)
def pnl(rows):
    r=[(pd.to_datetime(c[0][:10],format='%Y.%m.%d'),num(c[8])+num(c[9])+num(c[10])) for c in rows if c[3]!='balance' and c[2]=='XAUUSD']
    return pd.DataFrame(r,columns=['d','n']).groupby('d').n.sum()
NAMES={'ANNO80K_THEGOLDPHANTOM_TRANCHE22_20261114_143431.htm':'PHANTOM26_5k','ANNO80K_THEGOLDPHANTOM_TRANCHE22_20261114_115550.htm':'PHANTOM26_80k','ANNO80K_GOLDBOTONEMT5_TRANCHE22_20261114_173829.htm':'GOLDBOT25','ANNO80K_GOLDTRADEPROMT5_TRANCHE22_20261114_184913.htm':'GTP25'}
E={NAMES[k]:pnl(v[1]) for k,v in D.items() if k in NAMES}
for k,v in E.items(): P(f'{k}: giorni con deal {len(v)}, P&L realizzato totale {v.sum():.0f} EUR, dal {v.index.min().date()} al {v.index.max().date()}')
def block(name,lo,hi):
    idx=pd.date_range(lo,hi,freq='B'); Z=Sx.reindex(idx).join(E[name].rename('EA').reindex(idx).fillna(0)).dropna(subset=['ORO'])
    res={}
    for lab,Y in (('giornaliera',Z),('settimanale',Z.groupby(Z.index.to_period('W')).sum()),('mensile',Z.groupby(Z.index.to_period('M')).sum())):
        c=Y.corr()['EA'].drop('EA'); res[lab]=(c,len(Y))
    P(f'\n== {name} ({lo}..{hi}) giorni lavorativi {len(Z)}, giorni con deal {int((Z.EA!=0).sum())}')
    P(pd.DataFrame({k:v[0] for k,v in res.items()}).round(2).to_string()); P('n osservazioni:',{k:v[1] for k,v in res.items()})
block('GOLDBOT25','2025-01-01','2025-12-31'); block('GTP25','2025-01-01','2025-12-31'); block('PHANTOM26_5k','2026-01-01','2026-11-12'); block('PHANTOM26_80k','2026-01-01','2026-11-12')
# EA fra loro 2025
idx=pd.date_range('2025-01-01','2025-12-31',freq='B'); Y=pd.DataFrame({'GOLDBOT':E['GOLDBOT25'].reindex(idx).fillna(0),'GTP':E['GTP25'].reindex(idx).fillna(0)})
for lab,f in (('giornaliera',lambda y:y),('settimanale',lambda y:y.groupby(y.index.to_period('W')).sum()),('mensile',lambda y:y.groupby(y.index.to_period('M')).sum())): P(f'Goldbot-GTP {lab}: {f(Y).corr().iloc[0,1]:.2f}')
open('/home/user/GITHUB/report/CORRELAZIONE_EA_ORO_REPORT_RISULTATI_2026-11-21.txt','w',encoding='utf-8').write('\n'.join(out)+'\n')
