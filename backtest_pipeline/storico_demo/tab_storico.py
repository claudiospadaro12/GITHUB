import collections, re, csv
from an_storico import *
def gruppo(c):
    c=c or ''
    if re.match(r'^(FinlabX|CF |DZR)',c): return 'FinlabX (tutti i binari: R, F, CF, DZR)'
    if c.startswith('BULGE_MULTI_SIGNAL_BLU'): return 'BULGE MULTI SIGNAL BLU'
    if c.startswith('BULGE_MULTI_SIGNAL_VIOLA'): return 'BULGE MULTI SIGNAL VIOLA'
    if c.startswith('BULGE_MULTI_SIGNAL_ARANCIO'): return 'BULGE MULTI SIGNAL ARANCIO'
    if c.startswith('BULGE_V520_VIOLA'): return 'BULGE V520 VIOLA'
    if c.startswith('BULGE_V520_BLU'): return 'BULGE V520 BLU'
    if c.startswith('BULGE_AZZURRA'): return 'BULGE AZZURRA'
    if c.startswith('GZ '): return 'GZ (Gold Zone?) Buy+Sell'
    if 'marcalbrecht' in c: return 'marcalbrechttrading.com'
    if c.startswith('SNIPING'): return 'SNIPING EA'
    if c=='': return '(senza commento: EA non identificabili)'
    return fam(c)
g=collections.defaultdict(list)
for r in P:
    c=ent.get(r[1],O.get(r[1]))
    net=(r[10] or 0)+(r[11] or 0)+(r[12] or 0)
    g[gruppo(c)].append((r[0],r[8],r[2],net,r[12] or 0,r[10] or 0,r[11] or 0))
out=[]
for k,v in g.items():
    w=sum(x[3] for x in v if x[3]>0); l=-sum(x[3] for x in v if x[3]<0)
    gw=sum(x[4] for x in v if x[4]>0); gl=-sum(x[4] for x in v if x[4]<0)
    vinc=sum(1 for x in v if x[3]>0)
    out.append(dict(EA=k,n=len(v),netto=round(w-l,2),PF_netto=round(w/l,2) if l else None,PF_lordo=round(gw/gl,2) if gl else None,vincenti_pct=round(100*vinc/len(v),1),dal=min(x[0] for x in v)[:10],al=max(x[1] for x in v)[:10],simboli=' '.join(s for s,_ in collections.Counter(x[2] for x in v).most_common(3)),
      lotti_sim=len(set(x[2] for x in v))))
out.sort(key=lambda d:-d['n'])
with open('storico_per_ea_50503392.csv','w',newline='') as f:
    w=csv.DictWriter(f,fieldnames=list(out[0].keys()),delimiter=';'); w.writeheader(); w.writerows(out)
tot=sum(d['n'] for d in out); print('tot',tot, 'netto',round(sum(d['netto'] for d in out),2))
for d in out:
    if d['n']>=30: print(d)
rest=[d for d in out if d['n']<30]; print('altri',len(rest),'gruppi', sum(d['n'] for d in rest),'posizioni, netto',round(sum(d['netto'] for d in rest)))
