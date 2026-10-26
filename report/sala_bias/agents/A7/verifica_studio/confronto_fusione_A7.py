import csv
B="/tmp/claude-0/-home-user-GITHUB/c2d73886-9ef2-5105-8937-d770bc36d6df/scratchpad/lavoro_wt"
def rd(p):
    with open(p) as f:
        r=csv.reader(f,delimiter=";"); h=next(r); return h,[x for x in r]
h1,a=rd(B+"/report/sala_bias/agents/A7/verifica_studio/D1_fuso_A7.csv")
h2,b=rd(B+"/report/sala_bias/agents/A4/D1_fuso.csv")
print(h1==h2,len(a),len(b))
da={x[0]:x for x in a}; db={x[0]:x for x in b}
print("solo A7",sorted(set(da)-set(db))[:10],"solo A4",sorted(set(db)-set(da))[:10])
print("stesso ordine",[x[0] for x in a]==[x[0] for x in b])
diff=[]
for k in sorted(set(da)&set(db)):
    for i,n in enumerate(h1[1:],1):
        x=da[k][i];y=db[k][i]
        if n in("tickvol","n_raw","domenica_fusa"): same=int(x)==int(y)
        else: same=abs(float(x)-float(y))<1e-9
        if not same: diff.append((k,n,x,y))
print("differenze",len(diff)); print(diff[:20])
print("domeniche fuse A7",sum(int(x[7]) for x in a),"A4",sum(int(x[7]) for x in b))
