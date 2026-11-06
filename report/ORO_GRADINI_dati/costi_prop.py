import re,glob,json,openpyxl,warnings
warnings.filterwarnings('ignore')
def lots_of(h):
    raw=open(h,'rb').read().decode('utf-16','replace');l=0
    for rr in re.findall(r'<tr[^>]*>(.*?)</tr>',raw[raw.find('Affari'):],flags=re.S):
        c=[re.sub(r'<[^>]+>','',x).replace('&nbsp;',' ').strip() for x in re.findall(r'<td[^>]*>(.*?)</td>',rr,flags=re.S)]
        if len(c)>=12 and re.match(r'\d{4}\.\d\d\.\d\d \d\d:\d\d',c[0]) and c[3] in('buy','sell') and c[4]=='in':
            try:l+=float(c[5].replace(' ',''))
            except:pass
    return l
R=json.load(open('oro_res.json'));G=json.load(open('gtp_res.json'))
Y=('2013','2020','2025')
def path(e,lv,y):
    if e=='DTP': return glob.glob(f'wim_risultati/ANNO80K_WIM_PACCHETTO_20261104_2139/DTP_DaytradeProMax9DDlowrisk_{y}/*/report/*.htm')[0]
    if e=='GTP': return glob.glob(f'gtp_anni/{y}_M1_GTP_COMBO/*/report/*.htm')[0]
    return glob.glob(f'oro/z*/*/{lv}_{e}_80000_{y}/*/report/*.htm')[0]
def net(e,lv,y):
    if e=='DTP':
        d80={x['name']:x for x in json.load(open('/home/user/GITHUB/report/UBS_PACCHETTO_WIM/analisi/wim_full_88_passate.json'))}
        return d80[f'DTP_DaytradeProMax9DDlowrisk_{y}']['net']
    if e=='GTP': return G[f'COMBO_{y}']['net']
    return R[f'{lv}_{e}_80000_{y}']['net']
COMBO={'P1':[('PH','L1'),('GB','L0'),('DTP','on')],'P2':[('GR','L3'),('PH','L3'),('GB','L0'),('DTP','on')],'P3':[('GB','L3'),('GTP','COMBO'),('DTP','on')],'P4':[('GR','L3'),('GB','L0'),('DTP','on')],'P5':[('PH','L0'),('GB','L0'),('DTP','on')]}
EXTRA={'ottimistico':(18,2.5),'centrale':(36,4),'prudente':(70,8)}  # EUR per lotto (round trip): (oro, forex)
out={}
for c,mem in COMBO.items():
    out[c]={}
    for y in Y:
        n=sum(net(e,lv,y) for e,lv in mem)
        lg=sum(lots_of(path(e,lv,y)) for e,lv in mem if e!='DTP');lf=sum(lots_of(path(e,lv,y)) for e,lv in mem if e=='DTP')
        adj={k:n-(lg*v[0]+lf*v[1]) for k,v in EXTRA.items()}
        out[c][y]=dict(tester=n,lots_gold=lg,lots_fx=lf,**adj)
json.dump(out,open('costi_prop.json','w'),default=float)
for c in out:
    print(c)
    for y in Y:
        o=out[c][y];print('  ',y,'tester',round(o['tester']),'lotti oro',round(o['lots_gold'],1),'lotti fx',round(o['lots_fx'],1),'-> ott',round(o['ottimistico']),'centr',round(o['centrale']),'prud',round(o['prudente']),f"(costo extra centrale {100*(o['tester']-o['centrale'])/o['tester']:.1f}% del netto)")
# slippage del reale BCM
ws=openpyxl.load_workbook('/root/.claude/uploads/c2d73886-9ef2-5105-8937-d770bc36d6df/989aa6a2-DFEES.xlsx',data_only=True).active
rows=[[x for x in r if x is not None] for r in ws.iter_rows(values_only=True)];rows=[r for r in rows if r]
sec=None;pos=[];ords=[]
for r in rows:
    if len(r)==1 and isinstance(r[0],str) and r[0] in('Posizioni','Ordini','Affari','Ordini attivi','Risultati'):sec=r[0];continue
    if not re.match(r'\d{4}\.',str(r[0])):continue
    if sec=='Posizioni':pos.append(r)
    elif sec=='Ordini':ords.append(r)
oc={o[1]:o for o in ords if o[-2]=='filled'}
sl=[p[5]-oc[p[1]][5] for p in pos if p[1] in oc]
print('\nREALE BCM 10105439: slippage entrata',[round(x,2) for x in sl],'media',round(sum(sl)/len(sl),2))
cm=[p[-3]/float(p[4]) for p in pos];print('commissione reale BCM in+out per lotto',round(sum(cm)/len(cm),2))
