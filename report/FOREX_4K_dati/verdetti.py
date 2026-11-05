import json,collections
a=json.load(open('forex4k_res.json'));h=json.load(open('forex4k_htm.json'))
d80={x['name']:x for x in json.load(open('/home/user/GITHUB/report/UBS_PACCHETTO_WIM/analisi/wim_full_88_passate.json'))}
sets=collections.OrderedDict()
for k in sorted(a):
    s=k.rsplit('_',1)[0];sets.setdefault(s,{})[k.rsplit('_',1)[1]]=k
yrs=['2013','2017','2020','2022','2025']
out=[];S2=[]
for s,ys in sets.items():
    rel=[];net=[];fin=[];so=0;nm=0;worst=[];nmin=[];dd80=[]
    for y in yrs:
        k=ys[y];r=a[k];x=h[k]
        rel.append(max(x['rel'] or 0,r['ddEp'] or 0));net.append(r['net']);fin.append(r['final']);so+=r['stopout'];nm+=r['nomoney']
        worst.append(x['worstday_pct']);nmin.append(100*x['nmin']/x['nin'] if x['nin'] else 0)
        dd80.append(d80[k]['eqDDpct'] if k in d80 else None)
    pos=sum(1 for n in net if n>0)
    if max(rel)>50 or min(fin)<2000 or so>0: v='SCARTATO'
    elif max(rel)>35: v='ZONA GRIGIA'
    elif pos>=4: v='CANDIDATO'
    else: v='NON CLASSIFICATO (positivi <4/5)'
    out.append((s,v,rel,net,fin,so,nm,worst,nmin,dd80,pos))
    S2.append((s,[ (r4,r80) for r4,r80 in zip(rel,dd80)]))
for s,v,rel,net,fin,so,nm,worst,nmin,dd80,pos in out:
    print(f"\n{s}: {v}  (positivi {pos}/5, stop-out {so}, no-money {nm})")
    print('  DD rel% 4k :',[round(x,1) for x in rel])
    print('  DD % 80k   :',[None if x is None else round(x,1) for x in dd80])
    print('  netto 4k   :',[round(x) for x in net])
    print('  finale     :',[round(x) for x in fin])
    print('  peggior gg%:',[round(x,1) for x in worst],' quota 0.01 %:',[round(x) for x in nmin])
# S2: 4k DD > 80k DD per EA
ea=collections.defaultdict(lambda:[0,0])
for s,l in S2:
    e=s.split('_')[0]
    for r4,r80 in l:
        if r80 is None: continue
        ea[e][1]+=1
        if r4>r80+0.01: ea[e][0]+=1
print('\nS2 (4k DD > 80k DD) per EA:',dict(ea))
json.dump([(s,v) for s,v,*_ in out],open('verdetti.json','w'))
