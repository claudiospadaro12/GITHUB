"""hedging_demo_correlati.py -- sovrapposizioni FTMO 541452707 x conti BCM (25/09/2026).
Referto: report/HEDGING_DEMO_E_CORRELATI_2026-09-25.md.  SOLA LETTURA di file del repo.
OROLOGIO: tutto in UTC. trades_auto.csv / trades_100k.csv / ledger REALE sono in ora SERVER BCM
(UTC+1 fisso) -> -1h. Le 4 posizioni FTMO sono scritte a mano in UTC (server FTMO UTC+3 -3h):
fonti PRIMO_STOP_FTMO_2026-09-22 r.17-18, SECONDO_STOP_FTMO_2026-09-24 r.11-12,
CODA_09_20260925 r.97 (BUY LIMIT F4 15:17:03 IT) e CODA_12_20260925 r.21 (chiusura F4).
NON COPERTO: posizioni ancora APERTE (i CSV hanno solo le chiuse); conto 50503392 operato da
un altro terminale dopo il 23/09 19:35 IT (es. PC di backtest DESKTOP-H4D7CAJ); Tickmill,
Pepperstone, manuale 50503635; REALE prima del 04/09 (ledger avviato 04/09).
Uso: python3 hedging_demo_correlati.py [--autotest]
"""
import sys
import csv, math
from datetime import datetime, timedelta, date
F="%Y.%m.%d %H:%M:%S"
R="/home/user/GITHUB/"
IDX={"D30EUR":"DAX","GER40.cash":"DAX","U30USD":"DOW","US30.cash":"DOW","NASUSD":"NAS","US100.cash":"NAS","225JPY":"NIK"}
def load(path,conto):
    out=[]
    for r in csv.DictReader(open(path,encoding="utf-8",errors="replace"),delimiter=";"):
        o=datetime.strptime(r["open_time"],F)-timedelta(hours=1); c=datetime.strptime(r["close_time"],F)-timedelta(hours=1)
        out.append(dict(pid=r["pid"],conto=conto,sym=r["symbol"],side=r["side"],o=o,c=c,magic=r["magic"],strat=r["strategy"],vol=r["volume"]))
    return out
P=load(R+"data/statements/trades_auto.csv","piccolo 50503392")
K=load(R+"data/statements/trades_100k.csv","100k 50504263")
# REALE dal ledger SlippageLogger (CODA_10 25/09): posizioni ricostruite
import re
Rl=[]
led={}
for line in open(R+"backtest_pipeline/coda/referti/CODA_10_slippage_20260925_033004.log",encoding="utf-8",errors="replace"):
    m=re.match(r"\s*\|\s*(\d+);(\d+);(\d+);(\d{4}\.\d\d\.\d\d \d\d:\d\d:\d\d);\d+;10105439;REALE;([^;]+);(\d+);(IN|OUT);([^;]+);[^;]*;([\d.]+)",line)
    if m:
        d,o,pos,t,sym,mg,io,tipo,vol=m.groups()
        e=led.setdefault(pos,dict(pid=pos,conto="REALE 10105439",sym=sym,magic=mg,strat="",vol=None,o=None,c=None,side=None))
        tt=datetime.strptime(t,F)-timedelta(hours=1)
        if io=="IN": e["o"]=tt; e["side"]="buy" if tipo=="ACQUISTO" else "sell"; e["vol"]=vol
        else: e["c"]=tt if e["c"] is None or tt>e["c"] else e["c"]
Rl=[x for x in led.values() if x["o"] is not None and x["c"] is not None]
_inc=[x for x in led.values() if x["o"] is None or x["c"] is None]
if _inc: print("ATTENZIONE REALE: posizioni incomplete nel ledger (aperte o nate prima del 04/09), NON contate:",[x["pid"] for x in _inc])
FT=[dict(pid="F1",sym="US30.cash",side="sell",o=datetime(2026,9,22,9,52,1),c=datetime(2026,9,22,11,45,51),magic="771531",note="EMA200 S1"),
    dict(pid="F2",sym="US30.cash",side="sell",o=datetime(2026,9,22,9,52,31),c=datetime(2026,9,22,11,45,51),magic="771531",note="EMA200 S2"),
    dict(pid="F3",sym="GER40.cash",side="sell",o=datetime(2026,9,24,7,2,4),c=datetime(2026,9,24,7,14,49),magic="770411",note="MaxMin DAX short"),
    dict(pid="F4",sym="GER40.cash",side="buy",o=datetime(2026,9,24,13,17,3),c=datetime(2026,9,24,13,36,1),magic="770101",note="DAX Apertura RETEST (ingresso fra 13:17:03 e 13:35:18)")]
def cls(a,b):
    ia,ib=IDX.get(a),IDX.get(b)
    if ia and ib:
        if ia==ib: return "STESSO INDICE"
        if "NIK" in (ia,ib): return "INDICE CORRELATO Nikkei [INFERITO]"
        return "INDICE CORRELATO (DAX/Dow/Nasdaq, esempio FTMO)"
    return "zona grigia forex/oro [INFERITO]"

def _overlap(a,b):
    s=max(a["o"],b["o"]); e=min(a["c"],b["c"]); return (s,e) if s<e else None
def autotest():
    ok=True
    def chk(nome,cond):
        nonlocal ok
        print(("PASS " if cond else "FAIL ")+nome); ok=ok and cond
    t=lambda h,m,s=0: datetime(2026,9,22,h,m,s)
    f1=dict(sym="US30.cash",side="sell",o=t(9,52,1),c=t(11,45,51))
    dax=dict(sym="D30EUR",side="buy",o=t(8,56,41),c=t(10,13,45))
    # T1 l'episodio vero: opposto, correlato FTMO, 21:44
    ov=_overlap(f1,dax); chk("T1 22/09 trovato 21:44 e classe esempio FTMO", ov is not None and ov[1]-ov[0]==timedelta(minutes=21,seconds=44) and "esempio FTMO" in cls(f1["sym"],dax["sym"]))
    # T2 ipotesi alternativa dell'orologio (+1h invece di +2h): l'episodio sparisce -> il verdetto dipende dallo scarto, che e' ancorato dalla copia 771531 allo stesso secondo
    f1b=dict(f1,o=f1["o"]+timedelta(hours=1),c=f1["c"]+timedelta(hours=1)); chk("T2 con scarto sbagliato di 1h NON si sovrappone", _overlap(f1b,dax) is None)
    # T3 copia nello stesso verso: sovrapposta ma non opposta
    cp=dict(sym="U30USD",side="sell",o=t(9,52,1),c=t(11,45,51)); chk("T3 copia = stesso verso", _overlap(f1,cp) and cp["side"]==f1["side"])
    # T4 Nikkei resta [INFERITO], non entra nel conteggio FTMO
    chk("T4 Nikkei non e' 'esempio FTMO'", "esempio FTMO" not in cls("US30.cash","225JPY"))
    # T5 forex/oro -> zona grigia
    chk("T5 XAUUSD zona grigia", cls("GER40.cash","XAUUSD").startswith("zona grigia"))
    # T6 intervalli che si toccano soltanto (chiude = apre) non sono sovrapposizione
    chk("T6 bordo esatto non conta", _overlap(dict(o=t(10,0),c=t(11,0)),dict(o=t(11,0),c=t(12,0))) is None)
    print("AUTOTEST", "OK" if ok else "FALLITO"); return ok
if "--autotest" in sys.argv:
    sys.exit(0 if autotest() else 1)
print("=== Q2: posizioni FTMO x posizioni non-FTMO sovrapposte (UTC) ===")
for f in FT:
    for b in P+K+Rl:
        s=max(f["o"],b["o"]); e=min(f["c"],b["c"])
        if s<e:
            verso="OPPOSTO" if f["side"]!=b["side"] else "stesso verso"
            print(f'{f["pid"]} {f["sym"]} {f["side"]} | {b["conto"]} {b["sym"]} {b["side"]} {b["vol"]} magic {b["magic"]} {b["strat"]} | {b["o"]:%d/%m %H:%M:%S}-{b["c"]:%d/%m %H:%M:%S} | overlap {s:%H:%M:%S}-{e:%H:%M:%S} ({e-s}) | {verso} | {cls(f["sym"],b["sym"])}')
print("REALE posizioni ricostruite:",[(x["sym"],x["side"],x["o"].strftime("%d/%m %H:%M:%S"),x["c"].strftime("%H:%M:%S")) for x in Rl if x["o"]>=datetime(2026,9,20)])
# ===== Q3 forward proxy =====
FTMO_PROXY={"770101","770411","770202","770511","771531"}
ACT_P={"771321","772234","772235","772341","774101","770531","770101","770202","770411","770924","770511","970912","970913","770611","770250"}
ACT_K={"770901"}
def run(d0,d1,counter,label):
    prox=[p for p in P if p["magic"] in FTMO_PROXY and d0<=p["o"]<d1 and not (p["magic"]=="770101" and p["side"]=="sell")]
    cnt=[b for b in counter if b["o"]<d1 and b["c"]>d0]
    ep={}; same=0; raw=0
    for p in prox:
        for b in cnt:
            if p["pid"]==b["pid"] and p["conto"]==b["conto"]: continue
            if b["sym"] not in IDX: continue
            s=max(p["o"],b["o"]); e=min(p["c"],b["c"])
            if s>=e: continue
            if p["side"]==b["side"]: same+=1; continue
            raw+=1
            k=cls(p["sym"],b["sym"])
            key=(s.date(),p["magic"],b["magic"],b["conto"])
            if key not in ep or s<ep[key][0]: ep[key]=(s,e,k,p,b)
    days=sum(1 for i in range((d1-d0).days) if (d0+timedelta(i)).weekday()<5)
    print(f"\n=== {label}: finestra {d0:%d/%m}-{d1:%d/%m} giorni di borsa {days} | proxy FTMO {len(prox)} | controparti {len(cnt)} | coppie stesso verso {same} | opposte grezze {raw} | episodi {len(ep)}")
    bycl={}
    for (dd,pm,bm,co),(s,e,k,p,b) in sorted(ep.items()):
        print(f"  {dd:%d/%m} proxy {pm} {p['sym']} {p['side']} x {co} {bm} {b['sym']} {b['side']} {b['strat']} | {s:%d/%m %H:%M}-{e:%d/%m %H:%M} UTC ({e-s}) | {k}")
        bycl.setdefault(k,set()).add(dd)
    alld=set()
    for k,v in bycl.items():
        alld|=v
    def pr(n):
        lam=n/days; return f"{n} giornate/{days} = {100*lam:.1f}%/giorno, {lam*21:.2f}/mese, P(>=1 in 20gg)={100*(1-math.exp(-20*lam)):.0f}%"
    for k,v in sorted(bycl.items()): print("   ",k,":",pr(len(v)))
    corr=set().union(*[v for k,v in bycl.items() if k!="STESSO INDICE"]) if bycl else set()
    corrF=set().union(*[v for k,v in bycl.items() if "esempio FTMO" in k]) if bycl else set()
    print("    SOLO STESSO INDICE:",pr(len(bycl.get("STESSO INDICE",set()))))
    print("    STESSO + CORRELATI FTMO (DAX/Dow/Nas):",pr(len(bycl.get("STESSO INDICE",set())|corrF)))
    print("    TUTTO (anche Nikkei):",pr(len(alld)))
d0=datetime(2026,8,14); d1=datetime(2026,9,23)
run(d0,d1,[b for b in P if b["magic"] in ACT_P]+[b for b in K if b["magic"] in ACT_K],"B: piccolo RIACCESO (profilo ORO attuale) + 100k 770901")
run(d0,d1,[b for b in K if b["magic"] in ACT_K],"A: com'e' oggi (piccolo spento): solo 100k 770901")
run(d0,d1,[b for b in P if b["magic"] in ACT_P]+[b for b in K if b["magic"] in ACT_K]+[b for b in K if b["magic"] in {"770101","770202","770411","770611"}]+[b for b in Rl if b["magic"] in {"770101","770202","770411","770611"}],"C: controllo = perimetro del 24/09 (sedie BCM prima della sospensione; REALE solo dal 04/09)")

print("\n=== posizioni 100k 770901 e piccolo 770924/772235/774101 (Nikkei) nella finestra ===")
for b in K+P:
    if b["sym"]=="225JPY" and b["o"]>=d0: print("  ",b["conto"],b["magic"],b["side"],b["o"],b["c"],b["strat"])
# rotazione: sposta le controparti di k giorni di borsa (stessa ora), media degli episodi-giornata
def tdays(a,b):
    out=[];x=a
    while x<b:
        if x.weekday()<5: out.append(x.date())
        x+=timedelta(1)
    return out
TD=tdays(d0,d1); N=len(TD); pos={d:i for i,d in enumerate(TD)}
def shift(b,k):
    d=b["o"].date()
    if d not in pos: return None
    nd=TD[(pos[d]+k)%N]; delta=datetime.combine(nd,datetime.min.time())-datetime.combine(d,datetime.min.time())
    x=dict(b); x["o"]=b["o"]+delta; x["c"]=b["c"]+delta; x["pid"]=b["pid"]+"_r"; return x
def rot(counter,label):
    prox=[p for p in P if p["magic"] in FTMO_PROXY and d0<=p["o"]<d1 and not (p["magic"]=="770101" and p["side"]=="sell")]
    res={"S":[], "C":[], "T":[]}
    for k in range(1,N):
        cnt=[y for y in (shift(b,k) for b in counter if d0<=b["o"]<d1) if y]
        dS=set();dC=set();dT=set()
        for p in prox:
            for b in cnt:
                if b["sym"] not in IDX or p["side"]==b["side"]: continue
                s=max(p["o"],b["o"]); e=min(p["c"],b["c"])
                if s>=e: continue
                k2=cls(p["sym"],b["sym"])
                dT.add(s.date())
                if k2=="STESSO INDICE": dS.add(s.date())
                if k2=="STESSO INDICE" or "esempio FTMO" in k2: dC.add(s.date())
        res["S"].append(len(dS));res["C"].append(len(dC));res["T"].append(len(dT))
    for key,nm in (("S","stesso indice"),("C","stesso+correlati FTMO"),("T","tutto incl. Nikkei")):
        m=sum(res[key])/len(res[key]); lam=m/N
        print(f"  ROTAZIONE {label} {nm}: media {m:.2f} giornate/{N} (min {min(res[key])} max {max(res[key])}) -> {100*lam:.1f}%/giorno, P20={100*(1-math.exp(-20*lam)):.0f}%")
rot([b for b in K if b["magic"] in ACT_K],"A (100k 770901)")
rot([b for b in K if b["magic"] in ACT_K]+[b for b in P if b["magic"] in {"770924"}],"A' (Nikkei SupRev: 770901 + gemella 770924 come proxy)")
rot([b for b in P if b["magic"] in ACT_P]+[b for b in K if b["magic"] in ACT_K],"B")
