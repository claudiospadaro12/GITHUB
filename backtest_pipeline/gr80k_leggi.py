import sys,re,html,collections,statistics
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
R=rows(read(sys.argv[1])); i=[k for k,r in enumerate(R) if r and r[0] in('Affari','Deals')][0]
print(R[i+1])
D=[]
for r in R[i+2:]:
    if len(r)>=12 and re.match(r'\d{4}\.\d\d\.\d\d',r[0]) and r[2]!='' and r[3]!='balance':
        D.append(dict(t=r[0],dir=r[4].lower(),vol=num(r[5]),net=num(r[8])+num(r[9])+num(r[10]),bal=num(r[11]) if len(r)>11 else 0))
ins=[x for x in D if x['dir'].startswith('in')]; outs=[x for x in D if x['dir'].startswith('out')]
mon=collections.OrderedDict()
for x in D: mon[x['t'][:7]]=mon.get(x['t'][:7],0)+x['net']
for m,v in mon.items(): print(m,'%.2f'%v)
pos=sum(1 for v in mon.values() if v>0)
print('ops',len(outs),'tot %.2f'%sum(x['net'] for x in D),'mesi pos',pos,len(mon),'%.1f%%'%(100*pos/len(mon)))
print('H1 gen25-mag26 %.2f  giu-set26 %.2f'%(sum(v for m,v in mon.items() if m<='2026.05'),sum(v for m,v in mon.items() if m>='2026.06')))
vols=[x['vol'] for x in ins]; print('lotti min %.2f max %.2f med %.2f ratio %.2f'%(min(vols),max(vols),statistics.median(vols),max(vols)/min(vols)))
c=collections.Counter(round(v,2) for v in vols); print(sorted(c.items()))
ev=sorted([(x['t'],1 if x['dir'].startswith('in') else -1) for x in D],key=lambda z:(z[0],-z[1])); k=mx=0
for t,e in ev: k+=e; mx=max(mx,k)
print('max pos',mx)
# lotto per trimestre
q=collections.defaultdict(list)
for x in ins: q[x['t'][:4]+'Q'+str((int(x['t'][5:7])-1)//3+1)].append(x['vol'])
for k2 in sorted(q): print(k2,'n',len(q[k2]),'lotto med %.3f max %.2f'%(statistics.mean(q[k2]),max(q[k2])))
# giorni con >=1 chiusura: max perdita giornaliera
day=collections.defaultdict(float)
for x in D: day[x['t'][:10]]+=x['net']
w=min(day.items(),key=lambda z:z[1]); print('peggior giorno',w, 'pct80K %.2f'%(100*w[1]/80000))
print('media op %.2f'%(sum(x['net'] for x in D)/len(outs)),'costo x %.1f'%(sum(x['net'] for x in D)/len(outs)/0.18))
