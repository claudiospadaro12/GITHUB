#!/usr/bin/env python3
# -*- coding: ascii -*-
"""
assembla.py -- costruisce backtest_pipeline/righe/RIGA_ROUND_EMAGEM.txt (UNA riga fisica) dal sorgente leggibile riga_src.txt.
Stessa forma di collaudo_riga_DAXAP03/assembla.py. Le righe del sorgente che cominciano con due # sono commenti e non entrano nella riga;
le altre si uniscono con uno spazio.
Segnaposto: __PIN__/__PIN8__ (il commit pinnato, che DEVE contenere la copia con la riprova del driver, i tre file prova, la sorgente dell EA e
l include), __HP_A__/__HP_B__/__HP_C__ (SHA256 dei file prova AL PIN), __NP_A__/__NP_B__/__NP_C__ (righe di input), __SHA_EA__, __SHA_INC__,
__SHA_WF__ (walkforward_generico_RETRY.ps1), __SHA_DRV__ (righe/RIGA_ROUND_VPS_RETRY.ps1). Tutto letto con `git show PIN:percorso`, MAI dal disco.
In piu' verifica a macchina, AL PIN:
  - che i tre file prova siano la cella R110 00_metro (prove/R110_EMADOW_00_metro.txt, gia girata il 26/08 con deposito 100000 e modello 4) con SOLO le
    differenze dichiarate: InpMagic (asse tecnico 766801||766802 in a, pinnato 766811 / 766821 in b e c), InpTF (asse in b e c), InpComment, il simbolo
    (b e c) e le direttive FINOA / FRAZIONEIS; due lati e rischio 1 pinnati;
  - che i numeri attesi dal cancello T1 (IS 4585.40 / 1.20110 / 5.7325 / 237 e OOS 23321.47 / 1.52365 / 7.8323 / 517) siano quelli dei CSV VERI di R110 e di
    R112 (00_metro, due celle gemelle ciascuno), nel repo al pin, e quelli scritti nel sorgente della riga;
  - che R110 abbia girato con deposito 100000 e modello 4 (dal suo REFERTO archiviato): i file non hanno @DEPOSITO;
  - che i magic 766801, 766802, 766811 e 766821 compaiano (parola intera) SOLO nel proprio file prova e nei dossier che li hanno scritti, al pin e su ogni
    ramo remoto (fuori dai file di questa riga);
  - che EA, include, driver e walk-forward siano quelli approvati (SHA256), con i marcatori.
Uso:  python3 backtest_pipeline/collaudo_riga_EMAGEM/assembla.py <PIN_40_hex> [--verifica] [--dest FILE]
"""
import csv, hashlib, io, os, re, subprocess, sys
QD = os.path.dirname(os.path.abspath(__file__))
REPO = os.path.abspath(os.path.join(QD, "..", ".."))
PIN = sys.argv[1]
assert re.match(r"^[0-9a-f]{40}$", PIN), "PIN non valido"

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
    return p[0] if len(p) == 5 and p[4] in ("N", "Y") and p[4] == "N" else v

assert git("merge-base", "--is-ancestor", PIN, "origin/lavoro").returncode == 0, "il pin %s NON e' raggiungibile da origin/lavoro" % PIN[:8]
PROVE = {
    "A": "backtest_pipeline/prove/EMAGEM_a_ancora_U30USD_H1_LS.txt",
    "B": "backtest_pipeline/prove/EMAGEM_b_D30EUR_LS_tf.txt",
    "C": "backtest_pipeline/prove/EMAGEM_c_NASUSD_LS_tf.txt",
}
R110 = "backtest_pipeline/prove/R110_EMADOW_00_metro.txt"
pr = {k: git_show(v) for k, v in PROVE.items()}
rb = git_show(R110)
for b in list(pr.values()) + [rb]:
    b.decode("ascii")
    assert b"\r" not in b and b"\t" not in b
ii = {k: inputs(b) for k, b in pr.items()}
dd = {k: direttive(b) for k, b in pr.items()}
ir, dr = inputs(rb), direttive(rb)
DIR = {"PERIODO": "H1", "DAQUANDO": "2024.09.26", "FINOA": "2026.06.30", "FRAZIONEIS": "0.40"}
SIMB = {"A": "U30USD", "B": "D30EUR", "C": "NASUSD"}
for k in "ABC":
    assert dd[k] == dict(DIR, SIMBOLO=SIMB[k]), (k, dd[k])
    assert "DEPOSITO" not in dd[k]
assert dr["SIMBOLO"] == "U30USD" and dr["PERIODO"] == "H1" and dr["DAQUANDO"] == "2024.09.26", dr
assert "DEPOSITO" not in dr
# la cella R110 00_metro (gia girata il 26/08, referto archiviato) con SOLO le differenze dichiarate
irn = {k: norm(v) for k, v in ir.items()}
ATT = {"A": ["InpComment", "InpMagic", "InpNewsCurrencies"], "B": ["InpComment", "InpMagic", "InpNewsCurrencies", "InpTF"], "C": ["InpComment", "InpMagic", "InpNewsCurrencies", "InpTF"]}
for k in "ABC":
    df = sorted(x for x in set(irn) | set(ii[k]) if irn.get(x) != ii[k].get(x))
    assert df == ATT[k], (k, df)
assert irn["InpMagic"] == "763300||763300||1||763301||Y"
assert ii["A"]["InpMagic"] == "766801||766801||1||766802||Y" and ii["A"]["InpTF"] == "16385"
assert ii["B"]["InpMagic"] == "766811" and ii["C"]["InpMagic"] == "766821"
assert ii["B"]["InpTF"] == "16385||30||1||16388||Y" and ii["C"]["InpTF"] == "16385||30||1||16388||Y"
for k in "ABC":
    i = ii[k]
    assert i["InpAllowLong"] == "true" and i["InpAllowShort"] == "true" and i["InpRiskPercent"] == "1.0" and i["InpUsaGuardian"] == "true", k
    assert len(i) == 42, (k, len(i))
    assi = [x for x, v in i.items() if re.match(r"^[^|]*\|\|[^|]*\|\|[^|]*\|\|[^|]*\|\|Y\s*$", v)]
    assert assi == [("InpMagic" if k == "A" else "InpTF")], (k, assi)
    stringhe = sorted(x for x, v in i.items() if x not in assi and v not in ("true", "false") and not re.match(r"^-?[0-9]+(\.[0-9]+)?$", v))
    assert stringhe == ["InpComment", "InpNewsFile"], (k, stringhe)
    assert b"#  EA: ABTG_EMA200" in pr[k]
# i numeri attesi del cancello T1: i CSV VERI di R110 e di R112 (00_metro, due gemelle ciascuno), non il testo di un file prova
ATTESO = {"IS": ("4585.40", "1.20110", "5.7325", "237"), "OOS": ("23321.47", "1.52365", "7.8323", "517")}
FONTI = {"R110": "backtest_pipeline/prove/R110_CSV_EMADOW/ABTG_EMA200_U30USD_%s_00_metro.csv",
         "R112": "backtest_pipeline/risultati_archivio/R112_CORSA_20260826/ABTG_EMA200_U30USD_%s_00_metro.csv"}
for nome, pat in FONTI.items():
    for fase in ("IS", "OOS"):
        rows = list(csv.DictReader(io.StringIO(git_show(pat % fase).decode("ascii"))))
        assert len(rows) == 2, (nome, fase, len(rows))
        for r in rows:
            got = (r["Profit"], r["Profit Factor"], r["Equity DD %"], r["Trades"])
            assert got == ATTESO[fase], (nome, fase, r["InpMagic"], got, ATTESO[fase])
        cols = ["Profit", "Expected Payoff", "Profit Factor", "Recovery Factor", "Sharpe Ratio", "Equity DD %", "Trades"]
        assert all(rows[0][c] == rows[1][c] for c in cols), (nome, fase, "gemelle diverse")
# R110 ha girato con -Deposito 100000 -Modello 4: lo dice il SUO referto archiviato (i file prova non hanno @DEPOSITO)
ref = git_show("backtest_pipeline/risultati_archivio/REFERTO_DRIVER_R110_20260826.txt").decode("utf-8-sig")
assert re.search(r"modello 4 \(tick reali\)\s+deposito 100000", ref), "il referto di R110 non dice modello 4 e deposito 100000"
assert "2024.09.26 -> 2026.06.30" in ref and "split 40/60" in ref
src_ = open(os.path.join(QD, "riga_src.txt"), encoding="ascii").read()
for fase, (p_, pf, dd_, n_) in ATTESO.items():
    for x in (p_, pf, dd_, n_):
        assert x in src_, "numero atteso %s (%s) non scritto nel sorgente della riga" % (x, fase)
# magic vergini: parola intera, al pin e su ogni ramo remoto, fuori dai file di questa riga e dai dossier che li hanno scelti
MIEI = re.compile(r"^(backtest_pipeline/collaudo_riga_EMAGEM/|backtest_pipeline/righe/RIGA_(ROUND|LANCIA)_EMAGEM\.txt$|backtest_pipeline/CHECKLIST_RIGA_DI_LANCIO\.md$)")
DOSSIER = ("report/EMA200_GEMELLI_STATO_2026-10-03.md", "report/PIANO_SEDIE_VIA_PIU_CORTA_2026-10-03.md")
rami = [x.strip() for x in git("branch", "-r").stdout.decode().splitlines() if "->" not in x]
for mg, propria in (("766801", PROVE["A"]), ("766802", PROVE["A"]), ("766811", PROVE["B"]), ("766821", PROVE["C"])):
    for rev in [PIN] + rami:
        r = git("grep", "-l", "-w", mg, rev)
        fl = sorted(set(l.split(":", 1)[1] for l in r.stdout.decode().splitlines() if l.strip()))
        fuori = [f for f in fl if f != propria and f not in DOSSIER and not MIEI.match(f)]
        assert not fuori, "magic %s usato altrove in %s: %s" % (mg, rev, fuori)
src = open(os.path.join(QD, "riga_src.txt"), encoding="ascii").read().split("\n")
t = " ".join(l.strip() for l in src if l.strip() and not l.startswith("##"))
m = {"__PIN__": PIN, "__PIN8__": PIN[:8],
     "__HP_A__": sha(pr["A"]), "__HP_B__": sha(pr["B"]), "__HP_C__": sha(pr["C"]),
     "__NP_A__": str(len(ii["A"])), "__NP_B__": str(len(ii["B"])), "__NP_C__": str(len(ii["C"]))}
m["__SHA_EA__"] = sha(git_show("mql5/Experts/ABTG_EMA200.mq5"))
m["__SHA_INC__"] = sha(git_show("mql5/Include/ABTG_PausaGuardian.mqh"))
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
# gli originali al pin restano quelli approvati (le righe vecchie li usano): non si toccano, si controlla solo che non siano cambiati
assert sha(git_show("backtest_pipeline/righe/RIGA_ROUND_VPS.ps1")) == "3341756FB37889DBD6E827A87BAC26893E01C85B6C18343918083B01B4DD3425"
# lo stesso include del PASS di DAXAP03 (d949f705)
assert m["__SHA_INC__"] == "3EC971152E85E0082488CC4243FF45AE09948C191D52AB96050B48F94641A737", m["__SHA_INC__"]
# l EA al pin: il sorgente di HEAD, con il suo export a frame e per-trade (le righe citate nel testo della riga)
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
assert t.count("MARCATORE_RIGA_ROUND_EMAGEM_v1") == 1
dest = os.path.join(REPO, "backtest_pipeline", "righe", "RIGA_ROUND_EMAGEM.txt")
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
print("   a/b/c al pin = R110 00_metro salvo i punti dichiarati (magic, TF, commento, simbolo, FINOA/FRAZIONEIS); numeri T1 = CSV veri di R110 e R112")
