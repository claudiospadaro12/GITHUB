import subprocess,re,gzip,json,os,glob,sys
REPO='/home/user/GITHUB'
def num(x): return float(x.replace(' ','').replace('\xa0','') or 0)
def parse(b):
    t=b.decode('utf-16') if b[:2] in (b'\xff\xfe',b'\xfe\xff') else b.decode('utf-8','ignore')
    ev=[]
    for r in re.findall(r'<tr[^>]*>(.*?)</tr>',t,flags=re.S|re.I):
        c=[re.sub(r'<[^>]+>','',x).replace('&nbsp;',' ').strip() for x in re.findall(r'<td[^>]*>(.*?)</td>',r,flags=re.S|re.I)]
        if len(c)>=12 and re.match(r'\d{4}\.\d\d\.\d\d \d\d:\d\d',c[0]) and c[3] in ('buy','sell'):
            ev.append((c[0],num(c[10])+num(c[8])+num(c[9])))
    return ev
paths=subprocess.check_output(['git','-C',REPO,'ls-tree','-r','--name-only','origin/lavoro','backtest_pipeline/risultati_archivio']).decode().split('\n')
paths=[p for p in paths if re.search(r'/report/.*\.htm(\.gz)?$',p)]
YEARS=('2013','2018','2020','2025')
spec=[]  # (EA,variante, regex)
for v in ('DD6','DD9','DD12','DD15'): spec.append(('Reaper',v,r'ANNO80K_REAPER_MAXDD_[^/]*/@Y_M1_GR_%s/report'%v))
for v in ('LIVE30','LIVE9','R50A','R50B'): spec.append(('Reaper',v,r'ANNO80K_REAPER_SETLIVE_[^/]*/@Y_M1_GR_%s/report'%v))
for v in ('LOW3','PF105','PF525'): spec.append(('Goldbot',v,r'ANNO80K_GOLDBOT_SETVEND_[^/]*/@Y_M1_GB_%s/report'%v))
for v in ('PROPCOMBO_D4','PROPFIRM_D9','LOWRISK_D10','MEDIUM_D30','HIGHRISK_D60'): spec.append(('Phantom',v,r'ANNO80K_SUPER_[^/]*/PHANTOM/@Y_M1_PHANTOM_%s/report'%v))
for v in ('PROPFIRM_R1','LOWRISK_R15','MEDIUM_R3','HIGHRISK_R6'): spec.append(('GTP',v,r'ANNO80K_SUPER_[^/]*/GTP/@Y_M1_GTP_%s/report'%v))
out={}; miss=[]
for ea,v,rx in spec:
    for y in YEARS:
        pat=re.compile(rx.replace('@Y',y))
        m=[p for p in paths if pat.search(p)]
        if not m: miss.append((ea,v,y)); continue
        b=subprocess.check_output(['git','-C',REPO,'show','origin/lavoro:'+m[0]])
        if m[0].endswith('.gz'): b=gzip.decompress(b)
        out[f'{ea}|{v}|{y}']=parse(b)
# locali: Reaper D9, GTP COMBO
for y in YEARS:
    out[f'Reaper|D9|{y}']=parse(open(glob.glob(f'tre_da074c39-ANNO80K_TRE_EA_20261026_1444/{y}_M1/ANNO80K_THEGOLDREAPERMT5/report/*.htm')[0],'rb').read())
    out[f'GTP|COMBO|{y}']=parse(open(glob.glob(f'gtp_anni/{y}_M1_GTP_COMBO/**/*.htm',recursive=True)[0],'rb').read())
json.dump(out,open('ev/events.json','w'))
print('serie',len(out),'mancanti',miss)
for k in sorted(out)[:0]: pass
print({k:round(sum(v for _,v in e)) for k,e in out.items() if k.endswith('|2013')})
