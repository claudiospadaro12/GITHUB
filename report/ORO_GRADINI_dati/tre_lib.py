# Da lanciare dalla cartella di lavoro con oro/, gtp_anni/, wim_risultati/, oro_res.json, gtp_res.json, exp_all/ (vedi README del 11/11/2026). Uso: python3 -I
import re,glob,json,collections,datetime as dt
import numpy as np
def num(x):
    x=x.replace('\xa0','').replace(' ','').replace(',','')
    try: return float(x)
    except: return 0.0
def deals(p):
    b=open(p,'rb').read(); t=b.decode('utf-16') if b[:2] in (b'\xff\xfe',b'\xfe\xff') else b.decode('utf-8','ignore')
    i=t.find('Affari'); t=t[i:] if i>=0 else t
    ev=[]
    for r in re.findall(r'<tr[^>]*>(.*?)</tr>',t,flags=re.S|re.I):
        c=[re.sub(r'<[^>]+>','',x).replace('&nbsp;',' ').strip() for x in re.findall(r'<td[^>]*>(.*?)</td>',r,flags=re.S|re.I)]
        if len(c)>=12 and re.match(r'\d{4}\.\d\d\.\d\d \d\d:\d\d',c[0]) and c[3] in ('buy','sell'):
            ev.append(dict(t=c[0],sym=c[2],ty=c[3],dr=c[4],vol=num(c[5]),v=num(c[10])+num(c[8])+num(c[9]),prof=num(c[10])))
    ev.sort(key=lambda e:e['t'])
    return ev
def path(e,lv,y):
    if e=='DTP': g=glob.glob(f'wim_risultati/ANNO80K_WIM_PACCHETTO_20261104_2139/DTP_DaytradeProMax9DDlowrisk_{y}/*/report/*.htm')
    elif e=='STAB': g=glob.glob(f'wim_risultati/ANNO80K_WIM_PACCHETTO_20261104_2139/STAB_stabilityprolowriskset_{y}/*/report/*.htm')
    elif e=='LUNA': g=glob.glob(f'wim_risultati/ANNO80K_WIM_PACCHETTO_20261104_2139/LUNA_Luna4DD_{y}/*/report/*.htm')
    elif e=='GTP': g=glob.glob(f'gtp_anni/{y}_M1_GTP_COMBO/*/report/*.htm')
    else: g=glob.glob(f'oro/z*/*/{lv}_{e}_80000_{y}/*/report/*.htm')
    return g[0] if g else None
