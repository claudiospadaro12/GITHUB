#!/usr/bin/env python3
# -*- coding: ascii -*-
"""
assembla.py -- costruisce backtest_pipeline/righe/RIGA_ROUND_LATI.txt (UNA riga fisica) dal sorgente leggibile riga_src.txt.
Stessa forma di collaudo_riga_EMAGEM2/assembla.py (la riga EMAGEM2, passata dal cancello il 03/10). Le righe del sorgente che cominciano con due # sono commenti e non entrano nella
riga; le altre si uniscono con uno spazio.
Segnaposto: __PIN__/__PIN8__ (il commit pinnato, che DEVE contenere i quattro file prova LATI, la copia con la riprova del driver, la sorgente dell EA e l include),
__HP_A2L__/__HP_A2S__/__HP_A1L__/__HP_A1S__ (SHA256 dei file prova AL PIN), __NP_..__ (righe di input), __SHA_EA__, __SHA_INC__, __SHA_WF__, __SHA_DRV__. Tutto letto con
`git show PIN:percorso`, MAI dal disco.
In piu' verifica a macchina, AL PIN:
  - che i quattro file prova siano la cella R110 00_metro (prove/R110_EMADOW_00_metro.txt, gia girata il 26/08 con deposito 100000 e modello 4) con SOLO le differenze dichiarate:
    InpMagic, InpComment, InpNewsCurrencies (non pinnata) e il flag di lato che e l ASSE (InpAllowShort nei file long, InpAllowLong nei file short, '1||0||1||1||Y'); il lato
    opposto pinnato true; rischio 1; direttive SIMBOLO U30USD, PERIODO H1, DAQUANDO/FINOA della finestra, FRAZIONEIS 1.0 e NESSUNA @DEPOSITO;
  - che le celle pure di R110 (01_long, 02_short) siano la 00_metro con il solo lato spento (stessi input) e che i numeri attesi dalla sentinella (OOS: L+S 23321.47 / 1.52365 /
    7.8323 / 517; LONG puro 5670.52 / 1.24103 / 8.8973 / 241; SHORT puro 16948.35 / 1.89147 / 2.6628 / 302) siano quelli dei CSV VERI di R110 (due righe gemelle ciascuno) e di R112
    per la L+S, e quelli scritti nel sorgente della riga;
  - che R110 abbia girato con deposito 100000 e modello 4 e con OOS 2025.06.10 - 2026.06.30 (dal suo REFERTO archiviato);
  - che le tolleranze scritte nel sorgente della riga siano quelle di leggi_lati.py e quelle dichiarate nei file prova (EMENDAMENTO del 04/10);
  - che i magic 764100-764103 compaiano (parola intera) solo nei file prova LATI, nelle menzioni di RISERVA (righe di commento) dei file COLLAUDO_EMADOW_*, e nei file di questa
    riga, al pin e su ogni ramo remoto; e che EA, include, driver e walk-forward siano quelli approvati (SHA256), con i marcatori; e che l EA sia lo STESSO dei pin di EMAGEM2.
Uso:  python3 backtest_pipeline/collaudo_riga_LATI/assembla.py <PIN_40_hex> [--verifica] [--dest FILE]
"""
import csv, hashlib, io, os, re, subprocess, sys
QD = os.path.dirname(os.path.abspath(__file__))
REPO = os.path.abspath(os.path.join(QD, "..", ".."))
PIN = sys.argv[1]
assert re.match(r"^[0-9a-f]{40}$", PIN), "PIN non valido"
PIN_EMAGEM2 = "bda3c3641c9c61ff5d1499eff601ab80c62a6fd8"

def git(*a):
    return subprocess.run(["git"] + list(a), cwd=REPO, capture_output=True)

def git_show(path, rev=None):
    r = git("show", "%s:%s" % (rev or PIN, path))
    if r.returncode != 0:
        sys.exit("git show %s:%s fallito: %s" % ((rev or PIN)[:8], path, r.stderr.decode()[:200]))
    return r.stdout

def sha(b):
    return hashlib.sha256(b).hexdigest().upper()

def inputs(b):
    d = {}
    for l in b.decode("ascii").splitlines():
        m = re.match(r"^([A-Za-z][A-Za-z0-9_]*)=(.*)$", l.strip())
        if m:
            assert m.group(1) not in d, "input doppio: " + m.group(1)
            d[m.group(1)] = m.group(2)
    return d

def direttive(b):
    d = {}
    for l in b.decode("ascii").splitlines():
        m = re.match(r"^@(\w+)\s+(.+)$", l.strip())
        if m:
            d[m.group(1).upper()] = m.group(2).strip()
    return d

def norm(v):
    # R110 scrive ogni input non-asse come v||v||0||v||N: il valore e il primo campo
    p = v.split("||")
    return p[0] if len(p) == 5 and p[4] == "N" else v

assert git("merge-base", "--is-ancestor", PIN, "origin/lavoro").returncode == 0, "il pin %s NON e' raggiungibile da origin/lavoro" % PIN[:8]
# etichetta (job) -> (file prova, magic, flag ASSE, flag PINNATO true, finestra IS=intera, inizio gamba OOS degenere)
JOBS = [("A2L", "backtest_pipeline/prove/LATI_A2_EMA200_U30USD_TORO_long.txt", "764102", "InpAllowShort", "InpAllowLong", "2025.06.10", "2026.06.30"),
        ("A2S", "backtest_pipeline/prove/LATI_A2_EMA200_U30USD_TORO_short.txt", "764103", "InpAllowLong", "InpAllowShort", "2025.06.10", "2026.06.30"),
        ("A1L", "backtest_pipeline/prove/LATI_A1_EMA200_U30USD_DISCESA_long.txt", "764100", "InpAllowShort", "InpAllowLong", "2025.02.01", "2025.04.30"),
        ("A1S", "backtest_pipeline/prove/LATI_A1_EMA200_U30USD_DISCESA_short.txt", "764101", "InpAllowLong", "InpAllowShort", "2025.02.01", "2025.04.30")]
R110 = {"metro": "backtest_pipeline/prove/R110_EMADOW_00_metro.txt", "long": "backtest_pipeline/prove/R110_EMADOW_01_long.txt", "short": "backtest_pipeline/prove/R110_EMADOW_02_short.txt"}
pr = {k: git_show(f) for k, f, *_ in JOBS}
rb = {k: git_show(v) for k, v in R110.items()}
for b in list(pr.values()) + list(rb.values()):
    b.decode("ascii")
    assert b"\r" not in b and b"\t" not in b
ii = {k: inputs(b) for k, b in pr.items()}
dd = {k: direttive(b) for k, b in pr.items()}
ir = {k: {a: norm(v) for a, v in inputs(b).items()} for k, b in rb.items()}
EXP_R110 = {"long": ["InpAllowShort", "InpMagic"], "short": ["InpAllowLong", "InpMagic"]}
for k in ("long", "short"):
    df = sorted(x for x in set(ir["metro"]) | set(ir[k]) if ir["metro"].get(x) != ir[k].get(x))
    assert df == EXP_R110[k], (k, df)
assert ir["long"]["InpAllowLong"] == "true" and ir["long"]["InpAllowShort"] == "false" and ir["short"]["InpAllowLong"] == "false" and ir["short"]["InpAllowShort"] == "true", "le celle pure di R110 non sono long-only / short-only"
assert ir["metro"]["InpAllowLong"] == "true" and ir["metro"]["InpAllowShort"] == "true"
assert ir["metro"]["InpMagic"] == "763300||763300||1||763301||Y"
ATT_DIFF = lambda ax: sorted([ax, "InpComment", "InpMagic", "InpNewsCurrencies"])
for k, f, mg, ax, fx, d0, d1 in JOBS:
    i = ii[k]
    df = sorted(x for x in set(ir["metro"]) | set(i) if ir["metro"].get(x) != i.get(x))
    assert df == ATT_DIFF(ax), (k, df)
    assert i["InpMagic"] == mg and i[ax] == "1||0||1||1||Y" and i[fx] == "true" and i["InpRiskPercent"] == "1.0" and i["InpUsaGuardian"] == "true" and i["InpTF"] == "16385", k
    assert len(i) == 42, (k, len(i))
    assi = [x for x, v in i.items() if re.match(r"^[^|]*\|\|[^|]*\|\|[^|]*\|\|[^|]*\|\|Y\s*$", v)]
    assert assi == [ax], (k, assi)
    stringhe = sorted(x for x, v in i.items() if x not in assi and v not in ("true", "false") and not re.match(r"^-?[0-9]+(\.[0-9]+)?$", v))
    assert stringhe == ["InpComment", "InpNewsFile"], (k, stringhe)
    assert dd[k] == {"SIMBOLO": "U30USD", "PERIODO": "H1", "DAQUANDO": d0, "FINOA": d1, "FRAZIONEIS": "1.0"}, (k, dd[k])
    assert b"#  EA: ABTG_EMA200" in pr[k]
    # l EMENDAMENTO del 04/10 e nel file al pin (la tolleranza di banco e scritta PRIMA dei numeri)
    assert b"EMENDAMENTO DEL 04/10/2026" in pr[k] and b"TOLLERANZA DI BANCO" in pr[k]
    # le tolleranze dichiarate nel file (colonna per colonna)
    for frase in (b"Trades                 ESATTO.", b"Profit                 |diff| <= 1,00 EUR.", b"Profit Factor      |diff| <= 0,0002.", b"Recovery Factor        |diff| <= 0,0002.",
                  b"Expected Payoff    |diff| x Trades <= 1,00.", b"Sharpe Ratio           |diff| x |Profit| <= |Sharpe| x 1,00."):
        assert frase in pr[k], "la tolleranza '%s' non e nel file prova %s" % (frase.decode(), k)
# i numeri attesi dalla sentinella: i CSV VERI di R110 (e R112 per la L+S), due righe gemelle ciascuno, OOS
CSVS = {"metro": ("23321.47", "1.52365", "7.8323", "517", "1", "1"), "long": ("5670.52", "1.24103", "8.8973", "241", "1", "0"), "short": ("16948.35", "1.89147", "2.6628", "302", "0", "1")}
FONTI = [("R110", "backtest_pipeline/prove/R110_CSV_EMADOW/ABTG_EMA200_U30USD_OOS_%s.csv", {"metro": "00_metro", "long": "01_long", "short": "02_short"}),
         ("R112", "backtest_pipeline/risultati_archivio/R112_CORSA_20260826/ABTG_EMA200_U30USD_OOS_%s.csv", {"metro": "00_metro"})]
for nome, pat, cells in FONTI:
    for cella, sfx in cells.items():
        rows = list(csv.DictReader(io.StringIO(git_show(pat % sfx).decode("ascii"))))
        assert len(rows) == 2, (nome, cella, len(rows))
        for r in rows:
            got = (r["Profit"], r["Profit Factor"], r["Equity DD %"], r["Trades"], r["InpAllowLong"], r["InpAllowShort"])
            assert got == CSVS[cella], (nome, cella, r["InpMagic"], got, CSVS[cella])
        cols = ["Profit", "Expected Payoff", "Profit Factor", "Recovery Factor", "Sharpe Ratio", "Equity DD %", "Trades"]
        assert all(rows[0][c] == rows[1][c] for c in cols), (nome, cella, "gemelle diverse")
# R110 ha girato con -Deposito 100000 -Modello 4 e OOS 2025.06.10 - 2026.06.30: lo dice il SUO referto archiviato (i file prova non hanno @DEPOSITO)
ref = git_show("backtest_pipeline/risultati_archivio/REFERTO_DRIVER_R110_20260826.txt").decode("utf-8-sig")
assert re.search(r"modello 4 \(tick reali\)\s+deposito 100000", ref), "il referto di R110 non dice modello 4 e deposito 100000"
assert "2024.09.26 -> 2026.06.30" in ref and "split 40/60" in ref and "OOS 2025.06.10 - 2026.06.30" in ref
src_ = open(os.path.join(QD, "riga_src.txt"), encoding="ascii").read()
sys.path.insert(0, os.path.join(REPO, "backtest_pipeline"))
import leggi_lati as LG
assert (str(LG.TOL_PROFIT), str(LG.TOL_PF), str(LG.TOL_RF), str(LG.TOL_EP_X_TRADES), str(LG.TOL_SHARPE_X), str(LG.TOL_TRADES), str(LG.TOL_DD), str(LG.TOL_N_PURA), str(LG.TOL_PF_PURA)) == ("1.00", "0.0002", "0.0002", "1.00", "1.00", "0", "0", "0.02", "0.05"), "il lettore ha tolleranze diverse da quelle dei file prova"
assert "$tolP=& $decF '1.00'; $tolF=& $decF '0.0002'; $tolK=& $decF '1.00'; $tolN=& $decF '0.02'; $tolB=& $decF '0.05';" in src_, "le tolleranze del sorgente della riga NON sono quelle del lettore"
for x in ("23321.47", "1.52365", "7.8323", "517", "5670.52", "1.24103", "8.8973", "241", "16948.35", "1.89147", "2.6628", "302"):
    assert x in src_, "numero atteso %s non scritto nel sorgente della riga" % x
assert LG.S1_ATTESO == {"Profit": "23321.47", "Profit Factor": "1.52365", "Equity DD %": "7.8323", "Trades": "517"} and LG.S2_ATTESO["L"] == {"Trades": "241", "Profit Factor": "1.24103", "Profit": "5670.52", "Equity DD %": "8.8973"} and LG.S2_ATTESO["S"] == {"Trades": "302", "Profit Factor": "1.89147", "Profit": "16948.35", "Equity DD %": "2.6628"}
# magic vergini: parola intera, al pin e su ogni ramo remoto, fuori dai file di questa riga; le menzioni di RISERVA dei COLLAUDO_EMADOW devono essere righe di commento
MIEI = re.compile(r"^(backtest_pipeline/collaudo_riga_LATI/|backtest_pipeline/righe/RIGA_(ROUND|LANCIA)_LATI\.txt$|backtest_pipeline/leggi_lati\.py$|backtest_pipeline/CHECKLIST_RIGA_DI_LANCIO\.md$)")
RISERVA = re.compile(r"^backtest_pipeline/prove/COLLAUDO_EMADOW_[0-9A-Za-z_]+\.(txt|py)$")
rami = [x.strip() for x in git("branch", "-r").stdout.decode().splitlines() if "->" not in x]
PROVE_NUOVE = set(f for _, f, *_ in JOBS)
for k, f, mg, *_ in JOBS:
    for rev in [PIN] + rami:
        r = git("grep", "-n", "-w", mg, rev)
        righe = [l for l in r.stdout.decode().splitlines() if l.strip()]
        fl = sorted(set(l.split(":", 2)[1] for l in righe))
        assert f in fl or rev != PIN, "il magic %s non compare nel proprio file prova %s al pin" % (mg, f)
        for l in righe:
            parts = l.split(":", 3)
            fn = parts[1]
            if fn in PROVE_NUOVE or MIEI.match(fn):
                continue
            if RISERVA.match(fn):
                lt = parts[3].lstrip() if len(parts) > 3 else ""
                assert lt.startswith("#"), "magic %s in %s NON in una riga di commento (%s): %s" % (mg, rev, fn, lt[:80])
                continue
            sys.exit("magic %s usato altrove in %s: %s" % (mg, rev, fn))
src = open(os.path.join(QD, "riga_src.txt"), encoding="ascii").read().split("\n")
t = " ".join(l.strip() for l in src if l.strip() and not l.startswith("##"))
m = {"__PIN__": PIN, "__PIN8__": PIN[:8]}
for k, f, *_ in JOBS:
    m["__HP_%s__" % k] = sha(pr[k]); m["__NP_%s__" % k] = str(len(ii[k]))
m["__SHA_EA__"] = sha(git_show("mql5/Experts/ABTG_EMA200.mq5"))
m["__SHA_INC__"] = sha(git_show("mql5/Include/ABTG_PausaGuardian.mqh"))
assert m["__SHA_EA__"] == sha(git_show("mql5/Experts/ABTG_EMA200.mq5", PIN_EMAGEM2)), "l EA al pin NON e quello del pin di EMAGEM2 (bda3c364): il banco di EMAGEM non lo copre piu"
wf = git_show("backtest_pipeline/walkforward_generico_RETRY.ps1")
m["__SHA_WF__"] = sha(wf)
drvb = git_show("backtest_pipeline/righe/RIGA_ROUND_VPS_RETRY.ps1")
m["__SHA_DRV__"] = sha(drvb)
assert m["__SHA_DRV__"] == "D0341CB42C88D00FD663A09B7D4FBFECAA6866051966C6E30B28916EB3B53A47", "la copia RETRY del driver al pin NON e quella del PASS (d949f705): " + m["__SHA_DRV__"]
assert m["__SHA_WF__"] == "267F8B0571EED9475A809089206D2DF56395CF9B957BBE517239CA26D4473798", "walkforward_generico_RETRY al pin NON e quello del PASS (d949f705): " + m["__SHA_WF__"]
assert b"MARCATORE_RIGA_ROUND_VPS_RETRY_v1" in drvb and b"MARCATORE_RIGA_ROUND_VPS_v2" in drvb
assert b'$NOME_DRV = "walkforward_generico_RETRY.ps1"' in drvb
assert b'macchina = "DESKTOP-H4D7CAJ"\n     perc     = "C:\\Program Files\\BCM Markets MT5 Terminal"' in drvb, "la tabella del driver al pin non porta DESKTOP-H4D7CAJ -> C:\\Program Files\\BCM Markets MT5 Terminal"
assert b"MARCATORE_WALKFORWARD_GENERICO_v7_RETRY" in wf and b"MARCATORE_WALKFORWARD_GENERICO_v5_INCLUDE" in wf
assert b'1.0 = UNA SOLA TRANCHE (gamba OOS degenere, si dichiara).' in wf, "il driver al pin non ammette @FRAZIONEIS 1.0"
assert sha(git_show("backtest_pipeline/righe/RIGA_ROUND_VPS.ps1")) == "3341756FB37889DBD6E827A87BAC26893E01C85B6C18343918083B01B4DD3425"
assert m["__SHA_INC__"] == "3EC971152E85E0082488CC4243FF45AE09948C191D52AB96050B48F94641A737", m["__SHA_INC__"]
ea = git_show("mql5/Experts/ABTG_EMA200.mq5").decode("ascii", "replace").split("\n")
def riga_di(cosa):
    return [n + 1 for n, l in enumerate(ea) if cosa in l]
assert riga_di("void ExportTrades()") == [616] and riga_di("double OnTester()") == [643] and riga_di("ExportTrades();   //") == [645] and riga_di("FrameAdd(OPTFRAME_NAME") == [655] and riga_di("void OnTesterDeinit()") == [661], \
    "le righe dell EA citate nel testo della riga (r.616 / 643 / 645 / 655 / 661) NON tornano al pin"
for k, v in m.items():
    assert k in t, "segnaposto non usato nel sorgente: " + k
    t = t.replace(k, v)
resid = re.findall(r"__[A-Z0-9_]+__", t)
assert not resid, "segnaposto rimasti: %s" % resid
t.encode("ascii")
assert "\n" not in t and "\r" not in t and "\t" not in t
assert t.count("MARCATORE_RIGA_ROUND_LATI_v1") == 1
dest = os.path.join(REPO, "backtest_pipeline", "righe", "RIGA_ROUND_LATI.txt")
if "--dest" in sys.argv:
    dest = sys.argv[sys.argv.index("--dest") + 1]
if "--verifica" in sys.argv:
    cur = open(dest, encoding="ascii", newline="").read()
    print("IDENTICA byte per byte" if cur == t else "DIVERSA dalla riga in repo")
    sys.exit(0 if cur == t else 1)
open(dest, "w", newline="").write(t)
print(len(t), "byte,", t.count("\n"), "newline, SHA256", sha(t.encode("ascii")))
for k in sorted(m):
    print("  ", k, m[k][:16])
print("   i quattro file al pin = R110 00_metro salvo i punti dichiarati (asse del lato, magic, commento, FINOA/FRAZIONEIS); numeri della sentinella = CSV veri di R110 e R112")
