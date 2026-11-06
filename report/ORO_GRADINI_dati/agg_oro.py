import json,collections,numpy as np
R=json.load(open('oro_res.json'))
agg={}
for lv in ('L0','L1','L2','L3'):
  for dep in (80000,3745):
    for y in ('2013','2018','2020','2025'):
      eas={e:R[f'{lv}_{e}_{dep}_{y}'] for e in ('GR','PH','GB')}
      net=sum(r['net'] for r in eas.values())
      bound=sum(max(r['ddE'],r.get('relAbs') or 0) for r in eas.values())
      day=collections.defaultdict(float)
      for r in eas.values():
        for d,v in r['daily'].items(): day[d]+=v
      worst=min(day.values())
      so=sum(r['stopout'] for r in eas.values());nm=sum(r['nomoney'] for r in eas.values())
      agg[(lv,dep,y)]=dict(net=net,bound=bound,worst=worst,so=so,nm=nm,ratio=net/bound,
         net_e={e:r['net'] for e,r in eas.items()},dd_e={e:max(r['ddE'],r.get('relAbs') or 0) for e,r in eas.items()},
         minlot={e:(r['minlot'],r['nin']) for e,r in eas.items()},maxlot={e:r['maxlot'] for e,r in eas.items()},
         ops={e:r['ops'] for e,r in eas.items()},ddp={e:r['rel'] for e,r in eas.items()})
json.dump({'|'.join(map(str,k)):v for k,v in agg.items()},open('oro_agg.json','w'),indent=1,default=float)
for dep in (80000,3745):
  print('\n=== DEPOSITO',dep)
  for lv in ('L2','L0','L1','L3'):
    print(lv)
    for y in ('2013','2018','2020','2025'):
      a=agg[(lv,dep,y)]
      print(f"  {y} net {a['net']:9.0f} ({100*a['net']/dep:6.1f}%) boundDD {a['bound']:8.0f} ({100*a['bound']/dep:5.1f}%) worstday {a['worst']:8.0f} ({100*a['worst']/dep:5.1f}%) SO{a['so']} NM{a['nm']} net/bound {a['ratio']:.2f} | GR {a['net_e']['GR']:.0f} PH {a['net_e']['PH']:.0f} GB {a['net_e']['GB']:.0f}")
