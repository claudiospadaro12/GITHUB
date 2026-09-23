#!/usr/bin/env python3
# =====================================================================
#  censimento_entrymode.py -- CHE COSA E' GIA' STATO MISURATO, per
#                             SIMBOLO NEGOZIATO e per InpEntryMode
# ---------------------------------------------------------------------
#  PERCHE' ESISTE (18/09/2026, preparazione di R180)
#  Due volte nello stesso giorno era stato detto "mai provato" di cose
#  gia' misurate. Questo script non ricorda: LEGGE i CSV.
#
#  >>> E CHIUDE UN FALSO POSITIVO CHE COSTA CARO. <<<
#  Un `grep SPXUSD` sui CSV risponde SI' in decine di file: ma SPXUSD e'
#  quasi sempre il valore della colonna InpCorrSymbol (il simbolo del
#  FILTRO DI CORRELAZIONE, per giunta spento), NON il simbolo negoziato.
#  Qui il simbolo si ricava dal NOME DEL FILE, mai dal contenuto.
#
#  LIMITE DICHIARATO: i CSV senza il simbolo nel nome non vengono
#  attribuiti e restano fuori dal conteggio. Il numero di file letti e
#  quello dei file con la colonna InpEntryMode vengono stampati apposta,
#  cosi' la copertura e' un numero e non un'impressione.
#
#  ATTENZIONE AGLI ENUM: InpEntryMode NON ha la stessa numerazione in
#  tutti gli EA. ABTG_Dow_Apertura_US usa ENUM_ABTG_ENTRY (2 = RETEST);
#  ABTG_Apertura_3Ingressi usa ENUM_ABTG_STYLE (1 = RETEST). Questo
#  script stampa il NUMERO: la traduzione la fa chi legge.
#
#  USO:  python3 backtest_pipeline/censimento_entrymode.py [SIM1 SIM2 ...]
#        (senza argomenti: U30USD e SPXUSD)
# =====================================================================
import csv, os, re, sys, json
ROOTS = ["/home/user/GITHUB/backtest_pipeline/risultati_prove",
         "/home/user/GITHUB/backtest_pipeline/risultati_archivio"]
TARGETS = sys.argv[1:] or ["U30USD","SPXUSD"]
out = []
nfiles=0; nwith=0
for root in ROOTS:
    for dp,dnn,fns in os.walk(root):
        # CLASSE 621: senza questa potatura si leggono i CSV nei worktree degli agenti (8,9x)
        dnn[:] = [d for d in dnn if d not in ('.git', '.claude', 'worktrees', 'node_modules')]
        if '/.git' in dp or '/.claude/worktrees' in dp: continue
        for fn in fns:
            if not fn.lower().endswith(".csv"): continue
            p=os.path.join(dp,fn); nfiles+=1
            try:
                with open(p, newline='', encoding='utf-8', errors='replace') as f:
                    rd=csv.reader(f)
                    try: hdr=next(rd)
                    except StopIteration: continue
                    if "InpEntryMode" not in hdr: continue
                    nwith+=1
                    sym=None
                    for t in TARGETS+["NASUSD","D30EUR"]:
                        if t in fn: sym=t; break
                    if sym not in TARGETS: continue
                    iem=hdr.index("InpEntryMode")
                    def gi(n):
                        return hdr.index(n) if n in hdr else None
                    ipf,itr,idd,ipr,imag = gi("Profit Factor"),gi("Trades"),gi("Equity DD %"),gi("Profit"),gi("InpMagic")
                    agg={}
                    for row in rd:
                        if len(row)<=iem: continue
                        m=row[iem].strip()
                        d=agg.setdefault(m,{"n":0,"pf":[],"tr":[],"dd":[],"pr":[],"mag":set()})
                        d["n"]+=1
                        def fl(i):
                            try: return float(row[i])
                            except: return None
                        for k,i in (("pf",ipf),("tr",itr),("dd",idd),("pr",ipr)):
                            if i is not None:
                                v=fl(i)
                                if v is not None: d[k].append(v)
                        if imag is not None and len(row)>imag: d["mag"].add(row[imag])
                    for m,d in sorted(agg.items()):
                        def rng(l):
                            return (round(min(l),3),round(max(l),3)) if l else None
                        out.append({"file":p.replace("/home/user/GITHUB/",""),"sym":sym,"mode":m,"righe":d["n"],
                                    "PF":rng(d["pf"]),"Trades":rng(d["tr"]),"DD":rng(d["dd"]),"Profit":rng(d["pr"]),
                                    "magic":sorted(d["mag"])[:6]})
            except Exception as e:
                print("ERR",p,e, file=sys.stderr)
print(f"# csv totali: {nfiles} | con colonna InpEntryMode: {nwith} | righe censite sui target: {len(out)}")
for r in sorted(out,key=lambda x:(x["sym"],x["mode"],x["file"])):
    print(f'{r["sym"]}  mode={r["mode"]:>2}  n_celle={r["righe"]:>4}  PF={r["PF"]}  Trades={r["Trades"]}  DD={r["DD"]}  magic={r["magic"]}  <- {r["file"]}')
import csv, os, re, sys, json
ROOTS = ["/home/user/GITHUB/backtest_pipeline/risultati_prove",
         "/home/user/GITHUB/backtest_pipeline/risultati_archivio"]
TARGETS = sys.argv[1:] or ["U30USD","SPXUSD"]
out = []
nfiles=0; nwith=0
for root in ROOTS:
    for dp,dnn,fns in os.walk(root):
        # CLASSE 621: senza questa potatura si leggono i CSV nei worktree degli agenti (8,9x)
        dnn[:] = [d for d in dnn if d not in ('.git', '.claude', 'worktrees', 'node_modules')]
        if '/.git' in dp or '/.claude/worktrees' in dp: continue
        for fn in fns:
            if not fn.lower().endswith(".csv"): continue
            p=os.path.join(dp,fn); nfiles+=1
            try:
                with open(p, newline='', encoding='utf-8', errors='replace') as f:
                    rd=csv.reader(f)
                    try: hdr=next(rd)
                    except StopIteration: continue
                    if "InpEntryMode" not in hdr: continue
                    nwith+=1
                    sym=None
                    for t in TARGETS+["NASUSD","D30EUR"]:
                        if t in fn: sym=t; break
                    if sym not in TARGETS: continue
                    iem=hdr.index("InpEntryMode")
                    def gi(n):
                        return hdr.index(n) if n in hdr else None
                    ipf,itr,idd,ipr,imag = gi("Profit Factor"),gi("Trades"),gi("Equity DD %"),gi("Profit"),gi("InpMagic")
                    agg={}
                    for row in rd:
                        if len(row)<=iem: continue
                        m=row[iem].strip()
                        d=agg.setdefault(m,{"n":0,"pf":[],"tr":[],"dd":[],"pr":[],"mag":set()})
                        d["n"]+=1
                        def fl(i):
                            try: return float(row[i])
                            except: return None
                        for k,i in (("pf",ipf),("tr",itr),("dd",idd),("pr",ipr)):
                            if i is not None:
                                v=fl(i)
                                if v is not None: d[k].append(v)
                        if imag is not None and len(row)>imag: d["mag"].add(row[imag])
                    for m,d in sorted(agg.items()):
                        def rng(l):
                            return (round(min(l),3),round(max(l),3)) if l else None
                        out.append({"file":p.replace("/home/user/GITHUB/",""),"sym":sym,"mode":m,"righe":d["n"],
                                    "PF":rng(d["pf"]),"Trades":rng(d["tr"]),"DD":rng(d["dd"]),"Profit":rng(d["pr"]),
                                    "magic":sorted(d["mag"])[:6]})
            except Exception as e:
                print("ERR",p,e, file=sys.stderr)
print(f"# csv totali: {nfiles} | con colonna InpEntryMode: {nwith} | righe censite sui target: {len(out)}")
for r in sorted(out,key=lambda x:(x["sym"],x["mode"],x["file"])):
    print(f'{r["sym"]}  mode={r["mode"]:>2}  n_celle={r["righe"]:>4}  PF={r["PF"]}  Trades={r["Trades"]}  DD={r["DD"]}  magic={r["magic"]}  <- {r["file"]}')
