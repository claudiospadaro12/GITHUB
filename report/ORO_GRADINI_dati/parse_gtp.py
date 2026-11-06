import re,glob,json,collections,sys
sys.path.insert(0,'/home/user/GITHUB/report/UBS_PACCHETTO_WIM/analisi')
from wimlib import load_deals
def num(s): return float(s.replace('|','').replace(',','').replace(' ',''))
out={}
paths=glob.glob('sup/GTP/20*_M1_GTP_*/ANNO80K_GOLDTRADEPROMT5/report/*.htm')+glob.glob('gtp_anni/20*_M1_GTP_COMBO/ANNO80K_GOLDTRADEPROMT5/report/*.htm')
for h in sorted(paths):
    folder=h.split('/')[-4] if 'sup' in h.split('/')[0] else h.split('/')[-4]
    m=re.match(r'(\d{4})_M1_GTP_(\w+?)(?:_R[\d.]+)?$',folder)
    yr=m.group(1);setn=m.group(2)
    raw=open(h,'rb').read().decode('utf-16','replace')
    flat=re.sub(r'<[^>]+>','|',raw);flat=re.sub(r'[\s|]+','|',flat)
    g=lambda p:(lambda x:x and x.group(1))(re.search(p,flat))
    net=num(g(r'Profitto\|Totale\|Netto:\|(-?[\d|,.]+)'))
    dep=num(g(r'Deposito\|Iniziale:\|([\d|,.]+)'))
    ddm=re.search(r'Equità\|Drawdown\|Massima:\|([\d|,.]+)\|\(([\d.]+)%\)',flat)
    rel=re.search(r'Equità\|Drawdown\|Relativa:\|([\d.]+)%\|\(([\d|,.]+)\)',flat)
    kv={}
    for l in re.sub(r'<[^>]+>','\n',raw[:raw.find('Società')+10]).split('\n'):
        mm=re.match(r'^([A-Za-z0-9_]+)=(.*)$',l.strip())
        if mm: kv[mm.group(1)]=mm.group(2).strip()
    ev=load_deals(h)
    day=collections.defaultdict(float)
    for e in ev: day[e[0][:10]]+=e[1]
    ops=int(g(r'Numero\|di\|Operazioni\|di\|Trading\|Totali:\|(\d+)') or 0)
    out[f'{setn}_{yr}']=dict(set=setn,yr=yr,dep=dep,net=net,ddE=num(ddm.group(1)),ddEp=float(ddm.group(2)),relAbs=num(rel.group(2)),rel=float(rel.group(1)),ops=ops,daily=dict(day),
      inp={k:kv.get(k) for k in ('MaxRiskPerStrategy','PropFirmMaxDailyDD','Risk','OnlyUp','TradeFrequency','Randomization','LotPerBalance_step','StartLots','Virtual_expiration','MaxAllowedDD')},
      folder=folder)
json.dump(out,open('gtp_res.json','w'),default=float)
for k in sorted(out):
    r=out[k];print(k,r['dep'],round(r['net']),round(r['ddE']),r['ddEp'],round(r['relAbs']),'worst',round(min(r['daily'].values())),r['inp'] if k.endswith('2013') else '')
