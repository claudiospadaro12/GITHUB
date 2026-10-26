import pickle, collections, re, sys
rows=pickle.load(open('rep50503392.pkl','rb'))
P=[r for r in rows[7:8609] if r[1]]
D=rows[30911:48384]
# commento d'ingresso per posizione: deal 'in' con Ordine == Posizione
ent={}
for r in D:
    if r[4]=='in' and r[7]: ent[r[7]]=r[13]
# commenti ordini (market) come riserva
O={r[1]:r[11] for r in rows[8611:30909] if r[1]}
def fam(c):
    if c is None: return '(senza commento)'
    c=str(c)
    for pat,nome in [(r'^FinlabX',"FinlabX"),(r'^CF [BS]',"FinlabX (CF)"),(r'^DZR',"FinlabX (DZR)"),(r'^SNIPING',"SNIPING EA"),(r'^GZ ',"GZ"),(r'marcalbrecht',"marcalbrecht"),(r'^BULGE_MULTI_SIGNAL_BLU',"BULGE MULTI BLU"),(r'^BULGE_MULTI_SIGNAL_VIOLA',"BULGE MULTI VIOLA"),(r'^BULGE_V\d*_VIOLA',"BULGE V VIOLA"),(r'^BULGE_V\d*_BLU',"BULGE V BLU"),(r'^BULGE_AZZURRA',"BULGE AZZURRA"),(r'^Dark Venus',"Dark Venus"),(r'^Sample',"Sample Comment"),(r'^Hedging',"HedgingMartingale"),(r'^SSP',"SSP scalp"),(r'^EMA\d+ OTT',"EMA OTT"),(r'^DAX Apertura',"DAX Apertura EU RETEST"),(r'^Nang',"Nang Kwak"),(r'^\[so',"stop out")]:
        if re.search(pat,c): return nome
    return re.sub(r'[\d.]+','#',c)[:40]
if __name__=='__main__':
    g=collections.defaultdict(list)
    for r in P:
        c=ent.get(r[1], O.get(r[1]))
        net=(r[10] or 0)+(r[11] or 0)+(r[12] or 0)
        g[fam(c)].append((r[0],r[8],r[2],net,r[12] or 0))
    print('posizioni',len(P),'raggruppate',sum(len(v) for v in g.values()))
    for k,v in sorted(g.items(), key=lambda kv:-len(kv[1])):
        w=sum(x[3] for x in v if x[3]>0); l=-sum(x[3] for x in v if x[3]<0)
        gw=sum(x[4] for x in v if x[4]>0); gl=-sum(x[4] for x in v if x[4]<0)
        sy=collections.Counter(x[2] for x in v).most_common(2)
        print('%-28s n=%5d  netto=%9.0f  PF=%s PFlordo=%s  %s..%s %s'%(k,len(v),w-l,('%.2f'%(w/l) if l else 'inf'),('%.2f'%(gw/gl) if gl else 'inf'),min(x[0] for x in v)[:10],max(x[1] for x in v)[:10],sy))
