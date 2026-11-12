import openpyxl,re,collections,datetime as dt,json,sys
def num(x):
    if x is None or x=='': return 0.0
    if isinstance(x,(int,float)): return float(x)
    return float(str(x).replace(' ','').replace('\xa0','').replace(',','.'))
def carica(f):
    ws=openpyxl.load_workbook(f,data_only=True).active
    rows=list(ws.iter_rows(values_only=True))
    pos=[];deals=[];orders=[];sect='Posizioni'
    for r in rows[6:]:
        a=r[0]
        if a in ('Posizioni','Ordini','Affari','Posizioni aperte','Ordini attivi'): sect=a;continue
        if not (a and re.match(r'\d{4}\.\d\d\.\d\d \d\d:\d\d',str(a))): continue
        if sect=='Posizioni':
            pos.append(dict(t0=r[0],id=r[1],sym=r[2],ty=r[3],vol=num(r[4]),p0=num(r[5]),sl=(num(r[6]) if r[6] not in (None,'') else None),tp=(num(r[7]) if r[7] not in (None,'') else None),t1=r[8],p1=num(r[9]),comm=num(r[10]),swap=num(r[11]),prof=num(r[12])))
        elif sect=='Affari':
            deals.append(dict(ord=r[7],t=r[0],id=r[1],sym=r[2],ty=r[3],dr=r[4],vol=num(r[5]),px=r[6],comm=num(r[8]),fee=num(r[9]),swap=num(r[10]),prof=num(r[11]),bal=num(r[12])))
        elif sect=='Ordini': orders.append(r[:12])
    return pos,deals,orders
if __name__=='__main__':
    for f in ('live/reale.xlsx','live/trial.xlsx'):
        pos,deals,orders=carica(f)
        print(f,len(pos),len(deals),len(orders))
        print(collections.Counter(d['ty'] for d in deals))
        for d in deals[:6]: print(d)
        print([d for d in deals if d['ty'] not in ('buy','sell')][:20])
        print(orders[:3])
