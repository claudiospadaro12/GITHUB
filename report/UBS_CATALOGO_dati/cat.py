import os,hashlib,csv,collections,json,re
def rd(p):
    b=open(p,'rb').read()
    for enc in ('utf-16','utf-8-sig','latin1'):
        try:
            t=b.decode(enc)
            if '=' in t: return t,hashlib.sha256(b).hexdigest()
        except: pass
    return b.decode('latin1'),hashlib.sha256(b).hexdigest()
def parse(t):
    d={}
    for l in t.splitlines():
        if l.startswith(';') or '=' not in l: continue
        k,v=l.split('=',1); d[k.strip()]=v.split('||')[0].strip()
    return d
def catalog(root):
    rows=[]
    for dp,dn,fn in os.walk(root):
        for f in fn:
            if f.lower().endswith('.set'):
                p=os.path.join(dp,f); t,h=rd(p); d=parse(t)
                hdr=next((l for l in t.splitlines() if l.startswith(';')),'')
                rows.append(dict(rel=os.path.relpath(p,root).replace('\\','/'),name=f,hash=h,
                  header=hdr[:80],sym=d.get('ForceSymbol',''),tf=d.get('ST1_Timeframe',''),entry=d.get('ST1_Entry',''),
                  risk=d.get('Risk',''),lots=d.get('StartLots',''),hmdd=d.get('HistoricalMaxDD',''),mrps=d.get('MaxRiskPerStrategy_Value',''),
                  magic=d.get('EA_MagicNumber',''),nfp=d.get('EnableNFP_Filter',''),tz=d.get('UseTradingTimeZones',''),spread=d.get('SpreadFilter',d.get('spreadfilter','')),
                  keys=len(d),autoload=d.get('UseAutoLoader','')))
    return rows
new=catalog('new'); old=catalog('old')
for n,rs in (('new',new),('old',old)):
    with open(f'cat_{n}.csv','w',newline='',encoding='utf-8') as f:
        w=csv.DictWriter(f,fieldnames=list(rs[0].keys())); w.writeheader(); w.writerows(rs)
print(len(new),len(old))
oh={r['hash']:r for r in old}; nh={r['hash']:r for r in new}
same=[r for r in new if r['hash'] in oh]
print('stessi byte in entrambi:',len(same),'| solo nel nuovo:',len(new)-len(same),'| solo nel vecchio:',len([r for r in old if r['hash'] not in nh]))
# per cartella principale
def top(rel,n=2): return '/'.join(rel.split('/')[:n])
c=collections.Counter(top(r['rel'],2) if r['rel'].startswith('Breakout_Support_Resistance') else top(r['rel'],1) for r in new)
for k,v in c.most_common(): print(f'{v:4d} {k}')
sy=collections.Counter(r['sym'] or '(nessuno)' for r in new); print(sy.most_common(14))
print('XAUUSD:',sum(1 for r in new if r['sym'].upper().startswith(('XAU','GOLD'))))
print('con HistoricalMaxDD:',sum(1 for r in new if r['hmdd'] not in('','0','0.0')),' Risk valori:',collections.Counter(r['risk'] for r in new).most_common(6),' lots:',collections.Counter(r['lots'] for r in new).most_common(4))
print('NFP on/off:',collections.Counter(r['nfp'] for r in new))
# nomi duplicati con contenuto diverso tra vecchio e nuovo
on={}
for r in old: on.setdefault(r['name'],[]).append(r['hash'])
diffn=[r for r in new if r['name'] in on and r['hash'] not in on[r['name']]]
print('stesso nome ma contenuto diverso (nuovo vs vecchio):',len(diffn))
E
