# Lettura S-STAB del Prop Firm Gold EA: 4 corse continue (fondo + run1..3). Uso: python3 -I analizza_stab_propfirm.py <cartella_fondo> <cartella_STAB>
import sys,glob,collections,re,html
def read(p):
    b=open(p,'rb').read()
    for e in ('utf-16','utf-8'):
        try: return b.decode(e)
        except Exception: pass
def rows(t):
    return [[html.unescape(re.sub(r'<[^>]+>','',c)).strip().replace('\xa0',' ') for c in re.findall(r'<t[dh][^>]*>(.*?)</t[dh]>',tr,flags=re.S|re.I)] for tr in re.findall(r'<tr[^>]*>(.*?)</tr>',t,flags=re.S|re.I)]
def num(x):
    try: return float(x.replace(' ','').replace(',',''))
    except Exception: return 0.0
def deals(p):
    R=rows(read(p)); i=[k for k,r in enumerate(R) if r and r[0] in('Affari','Deals')][0]
    D=[]
    for r in R[i+2:]:
        if len(r)>=12 and re.match(r'\d{4}\.\d\d\.\d\d',r[0]) and r[2]!='' and r[3]!='balance':
            D.append(dict(t=r[0],sym=r[2],dir=r[4].lower(),vol=num(r[5]),net=num(r[8])+num(r[9])+num(r[10])))
    return D
fondo,stab=sys.argv[1],sys.argv[2]
runs={'fondo':fondo,'run1':stab+'/run1','run2':stab+'/run2','run3':stab+'/run3'}
ref=None
for k,d in runs.items():
    f=glob.glob(d+'/report/*TRANCHE22_*.htm')[0]
    inp=[r[1] for r in rows(read(f)) if len(r)==2 and r[0]=='' and '=' in r[1]]
    ref=ref or inp
    D=deals(f); ins=[x for x in D if x['dir'].startswith('in')]; outs=[x for x in D if x['dir'].startswith('out')]
    mon=collections.OrderedDict()
    for x in D: mon[x['t'][:7]]=mon.get(x['t'][:7],0)+x['net']
    ev=sorted([(x['t'],1 if x['dir'].startswith('in') else -1) for x in D],key=lambda z:(z[0],-z[1])); c=mx=0
    for t,e in ev: c+=e; mx=max(mx,c)
    tot=sum(x['net'] for x in D); pos=sum(1 for v in mon.values() if v>0)
    print('%-5s input_identici=%s n=%d net=%.2f mesi_pos=%d/%d (%.1f%%) gen25-mag26=%.1f giu-set26=%.1f lotti=%.2f-%.2f max_pos=%d media_op=%.2f rapporto_costo=%.1f'%(k,inp==ref,len(outs),tot,pos,len(mon),100*pos/len(mon),sum(v for m,v in mon.items() if m<='2026.05'),sum(v for m,v in mon.items() if m>='2026.06'),min(x['vol'] for x in ins),max(x['vol'] for x in ins),mx,tot/len(outs),tot/len(outs)/0.18))
