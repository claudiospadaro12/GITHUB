import sys, re, json
import xml.etree.ElementTree as ET
ns={'s':'urn:schemas-microsoft-com:office:spreadsheet'}
t=ET.parse(sys.argv[1]); rows=[]
for r in t.getroot().iter('{urn:schemas-microsoft-com:office:spreadsheet}Row'):
    rows.append([c.find('s:Data',ns).text for c in r.findall('s:Cell',ns)])
h=rows[0]; data=[]
for r in rows[1:]:
    d={h[i]:r[i] for i in range(len(h))}
    for k in h:
        d[k]=float(d[k])
    data.append(d)
print('righe',len(data),'colonne',h)
P=['ST1_MinDist_to_HL','ST1_Expiration_hours','Exit_stop','Exit_limit']
vals={p:sorted(set(d[p] for d in data)) for p in P}
print({p:vals[p] for p in P})
print('passaggi unici',len(set(tuple(d[p] for p in P) for d in data)),'pass id unici',len(set(d['Pass'] for d in data)))
DEP=100000.0
for d in data:
    d['DDeur']=d['Equity DD %']*DEP/100.0
    d['cal']=d['Profit']/d['DDeur'] if d['DDeur']>0 else float('nan')
idx={tuple(d[p] for p in P):d for d in data}
c0=idx.get((550.0,480.0,600.0,1700.0))
print('CONTROLLO CENTRO: atteso profit 4563.35, trades 253 (passata singola A); trovato',c0['Profit'],c0['Trades'],'->','OK' if abs(c0['Profit']-4563.35)<0.5 and c0['Trades']==253 else 'GRIGLIA INVALIDA: NON LEGGERE')
print('C0',{k:c0[k] for k in ['Pass','Profit','Trades','Profit Factor','Recovery Factor','Equity DD %','Expected Payoff','Result','cal']})
import statistics as S
pf=[d['Profit Factor'] for d in data]; tr=[d['Trades'] for d in data]; pr=[d['Profit'] for d in data]
print('profit min/med/max',min(pr),S.median(pr),max(pr),'PF min/med/max',min(pf),S.median(pf),max(pf),'trades min/med/max',min(tr),S.median(tr),max(tr))
print('passaggi con profit>0',sum(1 for x in pr if x>0),'trades>=150',sum(1 for x in tr if x>=150))
def ok(d): return d['Profit Factor']>=1.30 and d['Trades']>=150 and d['Recovery Factor']>=1.5 and d['Profit']>0
sel=[d for d in data if ok(d)]
print('selezione grezza (PF>=1.30, trades>=150, RF>=1.5, profit>0):',len(sel))
def nb(d):
    out=[]
    for p in P:
        v=vals[p]; i=v.index(d[p])
        for j in (i-1,i+1):
            if 0<=j<len(v):
                k=[d[q] for q in P]; k[P.index(p)]=v[j]; out.append(idx[tuple(k)])
    return out
cand=[]
for d in sel:
    n=nb(d); frac=sum(1 for x in n if ok(x))/len(n)
    d['nb']=len(n); d['nbfrac']=frac
    if frac>=0.70: cand.append(d)
print('centri di zona stabile (>=70% vicini):',len(cand))
cand.sort(key=lambda d:-d['cal'])
for d in cand[:12]:
    print('Pass %d prof %.0f PF %.2f RF %.2f DD%% %.2f trades %d cal %.2f vicini %d/%.0f%% | MinDist %g Exp %g Stop %g Limit %g'%(d['Pass'],d['Profit'],d['Profit Factor'],d['Recovery Factor'],d['Equity DD %'],d['Trades'],d['cal'],d['nb'],100*d['nbfrac'],d['ST1_MinDist_to_HL'],d['ST1_Expiration_hours'],d['Exit_stop'],d['Exit_limit']))
# C0 vicini
n0=nb(c0); print('C0 vicini ok:',sum(1 for x in n0 if ok(x)),'/',len(n0),'C0 ok:',ok(c0))
# classifica per calmar tra i passaggi con trades>=150
allc=sorted([d for d in data if d['Trades']>=150],key=lambda d:-d['cal'])
print('rango di C0 per Calmar (trades>=150):',[d['Pass'] for d in allc].index(c0['Pass'])+1,'su',len(allc))
print('TOP10 per Custom:')
for d in sorted(data,key=lambda d:-d['Result'])[:10]:
    print('  Pass %d res %.0f prof %.0f PF %.2f DD%% %.2f tr %d cal %.2f | %g %g %g %g'%(d['Pass'],d['Result'],d['Profit'],d['Profit Factor'],d['Equity DD %'],d['Trades'],d['cal'],d['ST1_MinDist_to_HL'],d['ST1_Expiration_hours'],d['Exit_stop'],d['Exit_limit']))
print('TOP10 per Calmar (trades>=150):')
for d in allc[:10]:
    print('  Pass %d prof %.0f PF %.2f RF %.2f DD%% %.2f tr %d cal %.2f | %g %g %g %g'%(d['Pass'],d['Profit'],d['Profit Factor'],d['Recovery Factor'],d['Equity DD %'],d['Trades'],d['cal'],d['ST1_MinDist_to_HL'],d['ST1_Expiration_hours'],d['Exit_stop'],d['Exit_limit']))
# effetto per parametro: media Calmar e profit per valore
for p in P:
    print(p,[(v,round(S.mean(d['cal'] for d in data if d[p]==v),2),round(S.mean(d['Profit'] for d in data if d[p]==v)),round(S.mean(d['Trades'] for d in data if d[p]==v))) for v in vals[p]])
json.dump(data,open('oro_griglia.json','w'))
