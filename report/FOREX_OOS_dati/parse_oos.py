#!/usr/bin/env python3
"""Giro A forex fuori campione: legge MANIFEST + report htm di ogni passata. Uso: python3 parse_oos.py <cartella con w01..wNN> -> oos_res.json"""
import sys,re,glob,json,os,csv,collections
root=sys.argv[1]
out={}
def fl(s):
    s=(s or '').replace(' ','').replace('\xa0','').replace(',','')
    try:return float(s)
    except:return 0.0
for man in glob.glob(os.path.join(root,'w*','*','*','*','MANIFEST_ANNO80K.csv')):
    parts=man.split(os.sep);folder=parts[-3]
    rows=list(csv.DictReader(open(man,encoding='utf-8-sig',errors='replace'),delimiter=';'))
    if not rows: continue
    m=rows[0]
    r=dict(folder=folder,stato=m.get('stato'),trades=int(m['trades']) if m.get('trades','').isdigit() else None,
           net=fl(m.get('profitto')) if m.get('profitto') else None,pf=m.get('pf'),qual=m.get('qualita'),
           input_ok=m.get('input_ok'),stopout=int(m.get('stop_out_log') or 0),nomoney=int(m.get('no_money_log') or 0),
           finestra=m.get('finestra'),report=m.get('report'),motivi=m.get('motivi'),test_s=m.get('test_s'))
    for key,col in(('ddE','dd_equita'),('ddS','dd_saldo')):
        mm=re.match(r'([\d.]+)\(([\d.]+)%\)',(m.get(col) or '').replace(' ',''))
        r[key]=float(mm.group(1)) if mm else None;r[key+'p']=float(mm.group(2)) if mm else None
    # referto per saldo finale e deposito
    ref=os.path.join(os.path.dirname(man),'REFERTO_ANNO80K_TRANCHE.txt')
    if os.path.exists(ref):
        t=open(ref,encoding='utf-8',errors='replace').read()
        fb=re.search(r'final balance (-?[\d.]+)',t);r['final']=float(fb.group(1)) if fb else None
        dep=re.search(r'deposito (\d+) EUR',t);r['dep']=int(dep.group(1)) if dep else None
    # report htm: peggior giorno, quota lotto minimo, max lotto
    h=glob.glob(os.path.join(os.path.dirname(man),'report','*.htm'))
    r['htm']=bool(h)
    if h:
        t=open(h[0],'rb').read().decode('utf-16','replace')
        rows_=re.findall(r'<tr[^>]*>(.*?)</tr>',t[t.find('Affari'):],re.S)
        hdr=None;deals=[]
        for rr in rows_:
            c=[re.sub(r'<[^>]+>','',x).strip() for x in re.findall(r'<t[dh][^>]*>(.*?)</t[dh]>',rr,re.S)]
            if hdr is None and 'Direzione' in c and 'Affare' in c: hdr=c;continue
            if hdr and len(c)>=len(hdr) and re.match(r'\d{4}\.\d\d\.\d\d',c[0]): deals.append(c)
        if hdr:
            ix={n.strip():i for i,n in enumerate(hdr)}
            day=collections.defaultdict(float);nin=nmin=0;maxlot=0.0;comm=0.0
            for c in deals:
                if c[ix['Tipo']]=='balance': continue
                d=c[ix['Direzione']]
                if d=='in':
                    v=fl(c[ix['Volume']]);nin+=1;maxlot=max(maxlot,v)
                    if v<=0.0101:nmin+=1
                if d in('out','in/out','out/in'):
                    day[c[0][:10]]+=fl(c[ix['Profitto']])+fl(c[ix['Commissioni']])+fl(c[ix['Swap']])
            r.update(worst=min(day.values()) if day else None,nin=nin,nmin=nmin,maxlot=maxlot,
                     days_le10=sum(1 for v in day.values() if v<=-400),days_le20=sum(1 for v in day.values() if v<=-800))
    out[folder]=r
json.dump(out,open('oos_res.json','w'),indent=1)
print(len(out),'passate;','con report htm:',sum(1 for r in out.values() if r['htm']))
for k in sorted(out):
    r=out[k];print(f"{k:42s} {str(r['stato']):8s} ops{r['trades']} net{r['net']} PF{r['pf']} DDe {r.get('ddEp')}% q{r['qual']} in_ok:{r['input_ok']} SO{r['stopout']} NM{r['nomoney']} htm:{r['htm']} fin{r.get('final')} worst{r.get('worst')}")
