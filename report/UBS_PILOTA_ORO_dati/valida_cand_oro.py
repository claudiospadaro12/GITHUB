# Applica V1 e V2 (criteri scritti prima: UBS_PILOTA_ORO_OTTIMIZZAZIONE_CRITERI + RISULTATI...GRIGLIA sezione "SECONDA GRIGLIA")
# Input: file di testo con righe  candidato;finestra;MinDist;Scadenza;Stop;Limit;profitto;operazioni;PF;DDmax(es. 380.06(0.37%));recupero
import sys,re
rows={}
for l in open(sys.argv[1],encoding='utf-8-sig',errors='ignore'):
    l=l.strip()
    if not l or l.startswith('['): 
        m=re.match(r'^\[[^\]]*\]\s*(.*)$',l)
        if not m: continue
        l=m.group(1)
    p=l.split(';')
    if len(p)<11 or p[0][:1]!='C': continue
    def f(x):
        try: return float(str(x).replace(',','.'))
        except: return float('nan')
    dd=re.match(r'([0-9.\-]+)\(([0-9.\-]+)%\)',p[9].replace(',','.')) 
    rows[(p[0],p[1])]=dict(par=tuple(p[2:6]),prof=f(p[6]),ops=f(p[7]),pf=f(p[8]),ddeur=float(dd.group(1)) if dd else float('nan'),ddpct=float(dd.group(2)) if dd else float('nan'),rec=f(p[10]))
cands=sorted({k[0] for k in rows},key=lambda c:int(c[1:]))
print('righe lette',len(rows),'candidati',len(cands))
def cal(r): return r['prof']/r['ddeur'] if r['ddeur'] and r['ddeur']>0 else float('nan')
c0=rows.get(('C0','OOS')); 
print('%-4s %-22s | OOS: prof ops PF DD$ cal (x C0) rec | H1: prof PF DD$ | H2: prof PF DD$ | V1 V2'%('cand','MD/Exp/Stop/Lim'))
for c in cands:
    o=rows.get((c,'OOS')); a=rows.get((c,'H1')); b=rows.get((c,'H2'))
    if not(o and a and b): print(c,'dati incompleti'); continue
    ratio=cal(o)/cal(c0) if c0 else float('nan')
    v1=(o['pf']>=1.20 and o['prof']>0 and o['rec']>=1 and ratio>=1.10) if c!='C0' else None
    ddr=max(a['ddeur'],b['ddeur'])/min(a['ddeur'],b['ddeur']) if min(a['ddeur'],b['ddeur'])>0 else float('nan')
    v2=(a['pf']>=1.15 and a['prof']>0 and b['pf']>=1.15 and b['prof']>0 and ddr<=2.5)
    print('%-4s %-22s | %7.0f %3.0f %5.2f %6.1f %5.2f (x%.2f) %5.2f | %6.0f %5.2f %6.1f | %6.0f %5.2f %6.1f | DDratio %.2f | V1 %s V2 %s'%(c,'/'.join(o['par']),o['prof'],o['ops'],o['pf'],o['ddeur'],cal(o),ratio,o['rec'],a['prof'],a['pf'],a['ddeur'],b['prof'],b['pf'],b['ddeur'],ddr,'-' if v1 is None else ('PASSA' if v1 else 'NO'),'PASSA' if v2 else 'NO'))
