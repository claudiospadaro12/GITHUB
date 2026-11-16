# Analisi della griglia oro su dati FTMO (criteri: UBS_PILOTA_ORO_OTTIMIZZAZIONE_CRITERI sezione 18, scritti prima).
# Uso: python3 -I analisi_oro_ftmo.py file.xml [profitto_atteso operazioni_attese ddmax_euro]
# Controllo bloccante: il passaggio centrale (550/480/600/1700) deve coincidere con la passata singola (default 3573.72 / 139).
import sys, json
import xml.etree.ElementTree as ET
ns={'s':'urn:schemas-microsoft-com:office:spreadsheet'}
rows=[[c.find('s:Data',ns).text for c in r.findall('s:Cell',ns)] for r in ET.parse(sys.argv[1]).getroot().iter('{urn:schemas-microsoft-com:office:spreadsheet}Row')]
h=rows[0]; d=[]
for r in rows[1:]:
    x={h[i]:float(r[i]) for i in range(len(h))}; x['DDeur']=x['Equity DD %']*1000.0; x['cal']=x['Profit']/x['DDeur'] if x['DDeur']>0 else float('nan'); d.append(x)
P=['ST1_MinDist_to_HL','ST1_Expiration_hours','Exit_stop','Exit_limit']
EXP_PROF=float(sys.argv[2]) if len(sys.argv)>2 else 3573.72; EXP_OPS=int(sys.argv[3]) if len(sys.argv)>3 else 139; DDMAX=float(sys.argv[4]) if len(sys.argv)>4 else 585.0
print('righe',len(d),'| valori:',{p:sorted(set(x[p] for x in d)) for p in P})
idx={tuple(x[p] for p in P):x for x in d}
c0=idx.get((550.0,480.0,600.0,1700.0))
if not c0: print('CENTRO NON TROVATO: griglia diversa dall attesa'); sys.exit(1)
ok=abs(c0['Profit']-EXP_PROF)<=0.5 and int(c0['Trades'])==EXP_OPS
print('CONTROLLO CENTRO: atteso %.2f / %d, trovato %.2f / %d (DD %.0f EUR) -> %s'%(EXP_PROF,EXP_OPS,c0['Profit'],c0['Trades'],c0['DDeur'],'OK' if ok else 'GRIGLIA INVALIDA: NON LEGGERE'))
if not ok: sys.exit(1)
import statistics as S
for k,l in (('Profit','profitto'),('Profit Factor','PF'),('Trades','operazioni'),('DDeur','DD EUR')):
    v=[x[k] for x in d]; print('%-10s min %.2f mediana %.2f max %.2f'%(l,min(v),S.median(v),max(v)))
print('centro (Wim): rend/DD %.2f, rango per rend/DD: %d su %d'%(c0['cal'],1+sum(1 for x in d if x['cal']>c0['cal']),len(d)))
def pool(x): return x['Profit Factor']>=1.30 and x['Trades']>=100 and x['Recovery Factor']>=1.5 and x['Profit']>0 and x['DDeur']<=DDMAX
pl=[x for x in d if pool(x)]; print('pool (PF>=1.30, ops>=100, RF>=1.5, profitto>0, DD<=%.0f): %d su %d'%(DDMAX,len(pl),len(d)))
best={}
for x in pl:
    k=(x['ST1_MinDist_to_HL'],x['Exit_stop'],x['Exit_limit'])
    if k not in best or x['cal']>best[k]['cal']: best[k]=x
L=sorted(best.values(),key=lambda x:-x['cal'])[:10]
print('\nTOP 10 combinazioni distinte (senza scadenza) per rend/DD:')
for i,x in enumerate(L):
    print('C%d pass %d | MD %g Exp %g Stop %g Lim %g | prof %.0f PF %.2f ops %d DD %.0f rend/DD %.2f (x%.2f centro)'%(i+1,x['Pass'],x['ST1_MinDist_to_HL'],x['ST1_Expiration_hours'],x['Exit_stop'],x['Exit_limit'],x['Profit'],x['Profit Factor'],x['Trades'],x['DDeur'],x['cal'],x['cal']/c0['cal']))
print('\nEffetto medio dei parametri (rend/DD medio, profitto medio, DD medio EUR):')
for p in P:
    vs=sorted(set(x[p] for x in d)); print(p,[(v,round(S.mean(x['cal'] for x in d if x[p]==v),2),round(S.mean(x['Profit'] for x in d if x[p]==v)),round(S.mean(x['DDeur'] for x in d if x[p]==v))) for v in vs])
json.dump([{k:x[k] for k in ('Pass',)+tuple(P)+('Profit','Profit Factor','Trades','DDeur','cal')} for x in L],open('candidati_ftmo.json','w'))
