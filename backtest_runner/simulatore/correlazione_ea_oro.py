# Criteri: report/CORRELAZIONE_EA_ORO_CRITERI_2026-11-21.md
import sys; sys.path.insert(0,'/home/user/GITHUB/backtest_runner/simulatore')
src=open('/home/user/GITHUB/backtest_runner/simulatore/supertrend_correlazione.py',encoding='utf-8').read()
exec(src[:src.index("out=[]")])
k=pd.read_csv('/tmp/claude-0/k100.csv',sep=';'); k=k[k.symbol=='XAUUSD'].copy(); k['net']=k.profit+k.commission+k.swap
k['day']=pd.to_datetime(k.close_time.str[:10],format='%Y.%m.%d')
EA=pd.DataFrame({'EA_tot':k.groupby('day').net.sum(),'EA_sell':k[k.side=='sell'].groupby('day').net.sum(),'EA_buy':k[k.side=='buy'].groupby('day').net.sum()}).fillna(0)
Sx=S.rename(columns={'A_ST_H1':'ST_H1_long','B_ST_H4':'ST_H4_long','C_DON55_D1':'DON55_D1_long','D_ORO_FERMO':'ORO_FERMO'})
d0,d1_=EA.index.min(),EA.index.max(); idx=pd.date_range(d0,d1_,freq='B')
Z=Sx.reindex(idx).join(EA.reindex(idx).fillna(0)).dropna(subset=['ORO_FERMO'])
out=[]
def P(*a):
    s=' '.join(str(x) for x in a); out.append(s); print(s,flush=True)
P(f'XAUUSD operazioni {len(k)} (sell {int((k.side=="sell").sum())}, buy {int((k.side=="buy").sum())}), giorni lavorativi {len(Z)} dal {d0.date()} al {d1_.date()}, giorni con chiusure {int((Z.EA_tot!=0).sum())}')
P('P&L realizzato EA oro: totale %.0f EUR, sell %.0f, buy %.0f'%(EA.EA_tot.sum(),EA.EA_sell.sum(),EA.EA_buy.sum()))
cols=['EA_tot','EA_sell','EA_buy']; ref=['ST_H1_long','ST_H4_long','DON55_D1_long','ORO_FERMO']
P('\n--- correlazione GIORNALIERA (tutti i giorni lavorativi del periodo)'); P(Z.corr().loc[cols,ref].round(2).to_string())
m=Z[Z.EA_tot!=0]; P('\n--- solo i giorni con almeno una chiusura (n=%d)'%len(m)); P(m.corr().loc[cols,ref].round(2).to_string())
W=Z.groupby(Z.index.to_period('W')).sum(); P('\n--- correlazione SETTIMANALE (n=%d settimane)'%len(W)); P(W.corr().loc[cols,ref].round(2).to_string())
P('\nrendimento oro fermo nel periodo (somma giornaliera): %.1f%%; Supertrend H4 long %.1f%%; Donchian D1 long %.1f%%'%(Z.ORO_FERMO.sum()*100,Z.ST_H4_long.sum()*100,Z.DON55_D1_long.sum()*100))
open('/home/user/GITHUB/report/CORRELAZIONE_EA_ORO_RISULTATI_2026-11-21.txt','w',encoding='utf-8').write('\n'.join(out)+'\n')
