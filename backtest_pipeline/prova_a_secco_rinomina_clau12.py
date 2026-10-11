import subprocess,re,os,collections,hashlib,json
files=subprocess.check_output(['git','ls-files','-z']).decode('utf-8','surrogateescape').split('\0')[:-1]
ARCH=('backtest_pipeline/risultati_archivio/','backtest_pipeline/coda/referti/','backtest_pipeline/risultati_prove/','data/','report/','docs/','HANDOFF','REGISTRO')
LIVEEXT={'.mq5','.mqh','.ps1','.py','.sh','.set','.ini','.yml','.pine','.diff','.patch'}
def live(f):
    if f.startswith(ARCH): return False
    return os.path.splitext(f)[1].lower() in LIVEEXT or f.startswith('backtest_pipeline/righe/')
L=[f for f in files if live(f)]
print('file live:',len(L))
# mappa EA (basename .mq5 ABTG_*) -> upper
eas=sorted({os.path.basename(f)[:-4] for f in files if re.search(r'(^|/)ABTG_[^/]*\.mq5$',f)},key=len,reverse=True)
emap={e:'CLAU12_'+e[5:].upper() for e in eas}
inc=sorted({os.path.basename(f)[:-4] for f in files if re.search(r'ABTG[^/]*\.mqh$',f)},key=len,reverse=True)
imap={e:e.replace('ABTG','CLAU12',1) for e in inc}
def sub(t):
    for e,n in emap.items():
        t=t.replace(e,n)
    for e,n in imap.items():
        t=t.replace(e,n)
    t=t.replace('ABTG','CLAU12').replace('Abtg','Clau12').replace('abtg','clau12')
    return t
stats=collections.Counter(); skipped=[]
for f in L:
    b=open(f,'rb').read()
    if b'\x00' in b[:8000] or b[:2] in (b'\xff\xfe',b'\xfe\xff'):
        if re.search(rb'a\x00b\x00t\x00g\x00',b,re.I): skipped.append(f)
        continue
    try: t=b.decode('utf-8')
    except: 
        t=b.decode('latin-1'); enc='latin-1'
    else: enc='utf-8'
    n=sub(t)
    if n!=t:
        open(f,'wb').write(n.encode(enc)); stats['contenuti']+=1
# rinomina file
ren=[]
for f in L:
    d,b=os.path.split(f)
    if re.search('abtg',b,re.I):
        nb=b
        base,ext=os.path.splitext(b)
        if ext=='.mq5' and base in emap: nb=emap[base]+ext
        elif ext=='.mqh' and base in imap: nb=imap[base]+ext
        else: nb=sub(b)
        ren.append((f,os.path.join(d,nb)))
tgt=collections.Counter(n for _,n in ren)
coll=[n for n,v in tgt.items() if v>1 or os.path.exists(n)]
print('rinomine:',len(ren),'collisioni:',coll[:5])
for o,n in ren:
    os.makedirs(os.path.dirname(n) or '.',exist_ok=True)
    subprocess.check_call(['git','mv',o,n])
print(stats,'utf16 live saltati:',len(skipped),skipped[:5])
json.dump(ren,open('../secco_ren.json','w'))
