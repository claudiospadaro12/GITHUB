import glob,re,collections
bad=collections.OrderedDict();seen=set()
for f in sorted(glob.glob('forex4k/z*/*/*/*/report/*.htm')):
    folder=f.split('/')[3]
    base=f.rsplit('/report/',1)[0]
    sets=glob.glob('forex4k/z*/*/'+folder+'/*/ini/*.set')
    if folder in seen or not sets: continue
    seen.add(folder)
    t=open(f,'rb').read().decode('utf-16','replace')
    i=t.find('Parametri');j=t.find('Società')
    blk=re.sub(r'<[^>]+>','\n',t[:j+10])
    kv={}
    for line in blk.split('\n'):
        line=line.strip()
        m=re.match(r'^([A-Za-z0-9_]+)=(.*)$',line)
        if m: kv[m.group(1)]=m.group(2).strip()
    sv={}
    for line in (lambda b: b.decode('utf-16') if b[:2] in (b'\xff\xfe',b'\xfe\xff') else b.decode('utf-8','replace'))(open(sets[0],'rb').read()).splitlines():
        m=re.match(r'^([A-Za-z0-9_]+)=([^|]*)',line)
        if m: sv[m.group(1)]=m.group(2).strip()
    n=0;diff=[]
    for k,v in sv.items():
        if k in kv:
            n+=1
            a,b=kv[k],v
            nb={'true':'1','false':'0'}
            a=nb.get(a.lower(),a);b=nb.get(b.lower(),b)
            try:
                if abs(float(a)-float(b))<1e-6: continue
            except: 
                if a.lower()==b.lower(): continue
            diff.append((k,a,b))
    bad[folder]=(len(sv),n,diff)
for k,(ns,n,d) in bad.items():
    print(f'{k:50s} set {ns} confrontati {n} diversi {len(d)}', d[:4])
