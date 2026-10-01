#!/usr/bin/env python3
# -*- coding: ascii -*-
"""
assembla.py -- costruisce backtest_pipeline/righe/RIGA_ROUND_DAXAP03.txt (UNA riga fisica) dal sorgente leggibile riga_src.txt.
Stessa forma di collaudo_riga_DAXAP02/assembla.py. Le righe del sorgente che cominciano con due # sono commenti e non entrano nella riga;
le altre si uniscono con uno spazio.
Segnaposto: __PIN__/__PIN8__ (il commit pinnato, che DEVE contenere la copia con la riprova del driver, i due file prova, la sorgente dell EA e
l include), __HP_A__/__HP_B__ (SHA256 dei file prova AL PIN), __NP_A__/__NP_B__ (righe di input), __SHA_EA__, __SHA_INC__, __SHA_WF__
(walkforward_generico_RETRY.ps1), __SHA_DRV__ (righe/RIGA_ROUND_VPS_RETRY.ps1). Tutto letto con `git show PIN:percorso`, MAI dal disco.
In piu' verifica a macchina, AL PIN:
  - che i due file prova siano R246i (gia' girato il 24/09 su questo PC) con SOLO le differenze dichiarate: InpPlaceMin diventa l'asse,
    InpPlaceHour 7 (03a) / 8 (03b), InpMagic 798103 / 798104 (era l'asse tecnico 794621||794671);
  - che R246i abbia girato con deposito 100000 e modello 4 (dal suo REFERTO archiviato): i file non hanno @DEPOSITO;
  - che i magic 798103 e 798104 compaiano (parola intera) SOLO nel proprio file prova e nel dossier che li ha scritti, al pin e su ogni ramo
    remoto (fuori dai file di questa riga);
  - che EA, include, driver e walk-forward siano quelli approvati (SHA256), con i marcatori.
Uso:  python3 backtest_pipeline/collaudo_riga_DAXAP03/assembla.py <PIN_40_hex> [--verifica] [--dest FILE]
"""
import hashlib, os, re, subprocess, sys
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

assert git("merge-base", "--is-ancestor", PIN, "origin/lavoro").returncode == 0, "il pin %s NON e' raggiungibile da origin/lavoro" % PIN[:8]
PA = "backtest_pipeline/prove/PRV_DAXAP_03a_ingresso_meno1_piu1_770411_D30EUR.txt"
PB = "backtest_pipeline/prove/PRV_DAXAP_03b_ritardo_5_15_770411_D30EUR.txt"
R246I = "backtest_pipeline/prove/R246i_orologio_MAXMINDAX_D30EUR_d0_B.txt"
pa, pb, rb = git_show(PA), git_show(PB), git_show(R246I)
for b in (pa, pb):
    b.decode("ascii")
    assert b"\r" not in b and b"\t" not in b
ia, ib, ir = inputs(pa), inputs(pb), inputs(rb)
da, db, dr = direttive(pa), direttive(pb), direttive(rb)
DIR = {"SIMBOLO": "D30EUR", "PERIODO": "M15", "DAQUANDO": "2024.09.26", "FINOA": "2026.06.30", "FRAZIONEIS": "0.40"}
assert da == DIR and db == DIR and dr == DIR, (da, db, dr)
# il gemello GIA GIRATO (R246i, 24/09, stesso PC, stesso EA): differenze attese e SOLO quelle
dfa = sorted(k for k in set(ia) | set(ir) if ia.get(k) != ir.get(k))
dfb = sorted(k for k in set(ib) | set(ir) if ib.get(k) != ir.get(k))
assert dfa == ["InpMagic", "InpPlaceMin"], dfa
assert dfb == ["InpMagic", "InpPlaceHour", "InpPlaceMin"], dfb
assert ir["InpPlaceHour"] == "7" and ir["InpPlaceMin"] == "59" and ir["InpMagic"] == "794621||794621||50||794671||Y"
assert ia["InpPlaceHour"] == "7" and ia["InpPlaceMin"] == "59||59||1||61||Y" and ia["InpMagic"] == "798103"
assert ib["InpPlaceHour"] == "8" and ib["InpPlaceMin"] == "0||0||5||15||Y" and ib["InpMagic"] == "798104"
assert ia["InpRiskPercent"] == "1" and ia["InpAllowShort"] == "true" and ia["InpAllowLong"] == "false" and ia["InpUsaGuardian"] == "false"
assert len(ia) == 51 and len(ib) == 51, (len(ia), len(ib))
for ii in (ia, ib):
    assi = [k for k, v in ii.items() if re.match(r"^[^|]*\|\|[^|]*\|\|[^|]*\|\|[^|]*\|\|Y\s*$", v)]
    assert assi == ["InpPlaceMin"], assi
    stringhe = sorted(k for k, v in ii.items() if k not in assi and v not in ("true", "false") and not re.match(r"^-?[0-9]+(\.[0-9]+)?$", v))
    assert stringhe == ["InpComment", "InpCorrSymbol", "InpNewsFile"], stringhe
assert b"#  EA: ABTG_MaxMinNotte_DAX_Short_Ottimizzato" in pa and b"#  EA: ABTG_MaxMinNotte_DAX_Short_Ottimizzato" in pb
# R246i ha girato con -Deposito 100000 -Modello 4: lo dice il SUO referto archiviato (i file prova non hanno @DEPOSITO)
ref = git_show("backtest_pipeline/risultati_archivio/R246/ROUND_R246i/REFERTO_ROUND_R246i.txt").decode("ascii")
assert re.search(r"^deposito\s+:\s+100000\s*$", ref, re.M) and re.search(r"^modello\s+:\s+4\s", ref, re.M), "il referto di R246i non dice deposito 100000 / modello 4"
assert re.search(r"^EA\s+:\s+ABTG_MaxMinNotte_DAX_Short_Ottimizzato\s*$", ref, re.M) and "DESKTOP-H4D7CAJ" in ref
assert "DEPOSITO" not in da and "DEPOSITO" not in db
# magic vergini: parola intera, al pin e su ogni ramo remoto, fuori dai file di questa riga
MIEI = re.compile(r"^(backtest_pipeline/collaudo_riga_DAXAP03/|backtest_pipeline/righe/RIGA_(ROUND|LANCIA)_DAXAP03\.txt$|backtest_pipeline/CHECKLIST_RIGA_DI_LANCIO\.md$)")
rami = [x.strip() for x in git("branch", "-r").stdout.decode().splitlines() if "->" not in x]
for mg, propria in (("798103", PA), ("798104", PB)):
    for rev in [PIN] + rami:
        r = git("grep", "-l", "-w", mg, rev)
        fl = sorted(set(l.split(":", 1)[1] for l in r.stdout.decode().splitlines() if l.strip()))
        fuori = [f for f in fl if f not in (propria, "report/PARAMETRI_DAX_APERTURA_2026-10-01.md") and not MIEI.match(f)]
        assert not fuori, "magic %s usato altrove in %s: %s" % (mg, rev, fuori)
src = open(os.path.join(QD, "riga_src.txt"), encoding="ascii").read().split("\n")
t = " ".join(l.strip() for l in src if l.strip() and not l.startswith("##"))
m = {"__PIN__": PIN, "__PIN8__": PIN[:8], "__HP_A__": sha(pa), "__HP_B__": sha(pb), "__NP_A__": str(len(ia)), "__NP_B__": str(len(ib))}
m["__SHA_EA__"] = sha(git_show("mql5/Experts/ABTG_MaxMinNotte_DAX_Short_Ottimizzato.mq5"))
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
# lo stesso motore di R246i (pin f824b2f4, 24/09) e lo stesso include
assert m["__SHA_EA__"] == sha(git_show("mql5/Experts/ABTG_MaxMinNotte_DAX_Short_Ottimizzato.mq5", "f824b2f408e89941847d020c59f6589647a53d2a")), "EA al pin diverso da quello di R246i"
assert m["__SHA_EA__"] == "CEAE27A807001C2BDFB6E084CA8CF0A21B0E202772531508ECCD2897CC7FC16A", m["__SHA_EA__"]
assert m["__SHA_INC__"] == "3EC971152E85E0082488CC4243FF45AE09948C191D52AB96050B48F94641A737"
for k, v in m.items():
    assert k in t, "segnaposto non usato nel sorgente: " + k
    t = t.replace(k, v)
resid = re.findall(r"__[A-Z0-9_]+__", t)
assert not resid, "segnaposto rimasti: %s" % resid
t.encode("ascii")
assert "\n" not in t and "\r" not in t and "\t" not in t
assert t.count("MARCATORE_RIGA_ROUND_DAXAP03_v1") == 1
dest = os.path.join(REPO, "backtest_pipeline", "righe", "RIGA_ROUND_DAXAP03.txt")
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
print("   03a/03b al pin = R246i salvo InpPlaceMin (asse), InpPlaceHour (solo 03b: 8), InpMagic (798103/798104); R246i girato a deposito 100000, modello 4")
