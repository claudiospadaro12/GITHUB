import glob,re,collections
SETS={'L2':{'GR':'gold_reaper_default.set','PH':'GoldPhantom_MediumRisk.set','GB':'Goldbot_MediumRisk_Max30DD.set'},
'L0':{'GR':'Gold_reaper_propfirm.set','PH':'GoldPhantom_Propfirm_combo.set','GB':'Goldbot_PropFirm_5_2.5.set'},
'L1':{'GR':'gold_reaper_15%maxrisk.set','PH':'GoldPhantom_Propfirm.set','GB':'Goldbot_PropFirm_10_5.set'}}
S3={80000:{'GR':'Gold_reaper_propfirm_combo_3GOLD.set','PH':'GoldPhantom_Propfirm_combo_3GOLD.set','GB':'Goldbot_PropFirm_combo_3GOLD.set'},3745:{'GR':'gold_reaper_3GOLD.set','PH':'GoldPhantom_3GOLD.set','GB':'Goldbot_3GOLD.set'}}
def setfile(n):
    g=glob.glob('wim_zip_ufficiali/combodeal/**/'+n.replace('[','[[]'),recursive=True);assert len(g)==1,(n,g);return g[0]
def readset(p):
    b=open(p,'rb').read();t=b.decode('utf-16') if b[:2] in(b'\xff\xfe',b'\xfe\xff') else b.decode('utf-8','replace')
    d={}
    for l in t.splitlines():
        m=re.match(r'^([A-Za-z0-9_]+)=([^|]*)',l)
        if m: d[m.group(1)]=m.group(2).strip()
    return d
nb={'true':'1','false':'0'}
tot=collections.Counter();bad=[]
for h in sorted(glob.glob('r21/R21_*/*/report/*.htm')):
    folder=h.split('/')[1]
    _,mod,liv,ea=folder.split('_')
    sn=S3[3745][ea] if liv=='L3' else SETS[liv][ea]
    sv=readset(setfile(sn))
    t=open(h,'rb').read().decode('utf-16','replace');j=t.find('Società')
    kv={}
    for l in re.sub(r'<[^>]+>','\n',t[:j+10]).split('\n'):
        m=re.match(r'^([A-Za-z0-9_]+)=(.*)$',l.strip())
        if m: kv[m.group(1)]=m.group(2).strip()
    n=0;diff=[]
    for k,v in sv.items():
        if k in kv:
            n+=1;a,b=kv[k],v
            a=nb.get(a.lower(),a);b=nb.get(b.lower(),b)
            try:
                if abs(float(a)-float(b))<1e-6: continue
            except:
                if a.lower()==b.lower(): continue
            diff.append((k,kv[k],v))
    tot[(ea,len(sv),n,len(diff))]+=1
    if diff: print(folder,diff[:4])
    if diff: bad.append((folder,diff[:5]))
print(dict(tot));print(len(bad))
for b in bad[:12]: print(b)
