#!/usr/bin/env python3
# -*- coding: ascii -*-
"""
assembla.py -- costruisce backtest_pipeline/righe/RIGA_ROUND_R280.txt (UNA riga fisica) dal sorgente leggibile riga_src.txt.
Stessa forma di collaudo_riga_EMAGEM2/assembla.py (la riga EMAGEM2 consegnata il 04/10). Le righe del sorgente che cominciano con due # sono commenti e non
entrano nella riga; le altre si uniscono con uno spazio.
Segnaposto: __PIN__/__PIN8__ (il commit pinnato, che DEVE contenere la copia con la riprova del driver, i due file prova, i criteri, la sorgente dell EA e l include),
__HP_E__/__HP_A__ (SHA256 dei file prova AL PIN), __NP_E__/__NP_A__ (righe di input), __SHA_EA__, __SHA_INC__, __SHA_WF__ (walkforward_generico_RETRY.ps1),
__SHA_DRV__ (righe/RIGA_ROUND_VPS_RETRY.ps1). Tutto letto con `git show PIN:percorso`, MAI dal disco.
In piu' verifica a macchina, AL PIN:
  - che R280a e R280e siano la cella di R262b (prove/R262b_emaslow_oltre260_TP050_U30USD.txt, gia' girata il 27/09 con deposito 10000 e modello 4) con SOLO le
    differenze dichiarate: InpMagic (798701 pinnato in a, asse 798711||798711||10||798721 in e), InpEmaSlow (asse 220||220||220||1320 in a, 220 pinnato in e),
    InpFilterTF (H1 in a, H4 in e); direttive uguali; 97 input ciascuno; due lati e rischio 1 pinnati; nessuna @DEPOSITO;
  - che i numeri attesi del cancello G0 (IS 1249.94 / 1.25920 / 7.1736 / 157 e OOS 2974.09 / 1.48133 / 6.6241 / 199, piu' il Recovery Factor) siano quelli dei CSV VERI
    di R262b e di R245b (la riga InpEmaSlow=220), nel repo al pin, e quelli scritti nel lettore e nel sorgente della riga;
  - che R262b abbia girato con deposito 10000 e modello 4 (dal suo REFERTO archiviato): i file prova non hanno @DEPOSITO;
  - che le tolleranze del lettore (leggi_r280.py), del sorgente della riga e dei file prova (R280e) siano le stesse;
  - che i magic 798701, 798711 e 798721 compaiano (parola intera) solo nei file ammessi, al pin e su ogni ramo remoto (classe 1096: la verginita' e' DATATA);
  - che EA e include al pin siano BYTE PER BYTE quelli di 02c70e17 (il pin di R262b), e che il driver e il walk-forward siano quelli approvati (SHA256), con i marcatori.
Uso:  python3 backtest_pipeline/collaudo_riga_R280/assembla.py <PIN_40_hex> [--verifica] [--dest FILE]
"""
import csv, hashlib, io, os, re, subprocess, sys
QD = os.path.dirname(os.path.abspath(__file__))
REPO = os.path.abspath(os.path.join(QD, "..", ".."))
PIN = sys.argv[1]
assert re.match(r"^[0-9a-f]{40}$", PIN), "PIN non valido"
PIN_R262B = "02c70e17eef870c26ef47b81942a0eb23d82aba8"

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
PE = "backtest_pipeline/prove/R280e_ancora_g1_candidato_dow_U30USD.txt"
PA = "backtest_pipeline/prove/R280a_filtrotf_h1_memoria_candidato_dow_U30USD.txt"
P262 = "backtest_pipeline/prove/R262b_emaslow_oltre260_TP050_U30USD.txt"
CRI = "backtest_pipeline/prove/R280_CRITERI_LETTURA_2026-10-05.md"
pe, pa, pr = git_show(PE), git_show(PA), git_show(P262)
git_show(CRI)
for b in (pe, pa, pr):
    b.decode("ascii")
    assert b"\r" not in b and b"\t" not in b
ie, ia, ir = inputs(pe), inputs(pa), inputs(pr)
de, da, dr = direttive(pe), direttive(pa), direttive(pr)
DIR = {"SIMBOLO": "U30USD", "PERIODO": "M5", "DAQUANDO": "2024.09.26", "FINOA": "2026.06.30", "FRAZIONEIS": "0.4322"}
assert de == DIR and da == DIR and dr == DIR, (de, da, dr)
for d in (de, da, dr):
    assert "DEPOSITO" not in d
# (1) R280e e R280a sono R262b con SOLE le differenze dichiarate
dife = sorted(x for x in set(ie) | set(ir) if ie.get(x) != ir.get(x))
difa = sorted(x for x in set(ia) | set(ir) if ia.get(x) != ir.get(x))
assert dife == ["InpEmaSlow", "InpMagic"], dife
assert difa == ["InpEmaSlow", "InpFilterTF", "InpMagic"], difa
assert ir["InpEmaSlow"] == "200||160||20||320||Y" and ir["InpMagic"] == "766302" and ir["InpFilterTF"] == "16388"
assert ie["InpEmaSlow"] == "220" and ie["InpMagic"] == "798711||798711||10||798721||Y" and ie["InpFilterTF"] == "16388"
assert ia["InpEmaSlow"] == "880||220||220||1320||Y" and ia["InpMagic"] == "798701" and ia["InpFilterTF"] == "16385"
for k, i in (("e", ie), ("a", ia)):
    assert len(i) == 97, (k, len(i))
    assert i["InpAllowLong"] == "1" and i["InpAllowShort"] == "1" and i["InpRiskPercent"] == "1", k
    assi = [x for x, v in i.items() if re.match(r"^[^|]*\|\|[^|]*\|\|[^|]*\|\|[^|]*\|\|Y\s*$", v)]
    assert assi == [("InpMagic" if k == "e" else "InpEmaSlow")], (k, assi)
    stringhe = sorted(x for x, v in i.items() if x not in assi and not re.match(r"^-?[0-9]+(\.[0-9]+)?$", v))
    assert stringhe == ["InpCorrSymbol", "InpNewsFile"], (k, stringhe)
    assert b"#  EA: ABTG_Nasdaq_Apertura_US" in (pe if k == "e" else pa)
# l asse di a: 880 e' il valore di partenza scritto, ma l asse va da 220 a 1320 di 220 (sei valori)
assert [int(x) for x in range(220, 1321, 220)] == [220, 440, 660, 880, 1100, 1320]
# (2) i numeri attesi del cancello G0: i CSV VERI di R262b e di R245b (due corse indipendenti), riga EmaSlow=220, e il lettore e la riga
sys.path.insert(0, os.path.join(REPO, "backtest_pipeline"))
import leggi_r280 as LG
FONTI = {"R262b": "backtest_pipeline/risultati_archivio/ROUND_CORTI_B_2026-09-27/ROUND_R262b/ABTG_Nasdaq_Apertura_US_U30USD_%s_R262b.csv",
         "R245b": "backtest_pipeline/risultati_archivio/R245/ROUND_R245b/ABTG_Nasdaq_Apertura_US_U30USD_%s_R245b.csv"}
for nome, pat in FONTI.items():
    for fase in ("IS", "OOS"):
        rows = [r for r in csv.DictReader(io.StringIO(git_show(pat % fase).decode("ascii"))) if r["InpEmaSlow"] == "220"]
        assert len(rows) == 1, (nome, fase, len(rows))
        r = rows[0]
        assert r["InpFilterTF"] == "16388" and r["InpTP1_R"] == "0.5" and r["InpAllowLong"] == "1" and r["InpAllowShort"] == "1" and r["InpRiskPercent"] == "1", (nome, fase)
        for col in ("Profit", "Profit Factor", "Recovery Factor", "Equity DD %", "Trades"):
            assert r[col] == LG.G0_ATTESO[fase][col], (nome, fase, col, r[col], LG.G0_ATTESO[fase][col])
# R262b ha girato con -Deposito 10000 -Modello 4: lo dice il SUO referto archiviato
ref = git_show("backtest_pipeline/risultati_archivio/ROUND_CORTI_B_2026-09-27/ROUND_R262b/REFERTO_ROUND_R262b.txt").decode("utf-8-sig")
assert re.search(r"modello\s+:\s+4\s+\(tick reali\)", ref) and re.search(r"deposito\s+:\s+10000\b", ref), "il referto di R262b non dice modello 4 e deposito 10000"
assert "02c70e17" in ref and "ABTG_Nasdaq_Apertura_US" in ref
# (3) le tolleranze: lettore = riga = file prova R280e
src_ = open(os.path.join(QD, "riga_src.txt"), encoding="ascii").read()
assert (str(LG.TOL_PROFIT), str(LG.TOL_PF), str(LG.TOL_DD), str(LG.TOL_TRADES)) == ("0.05", "0.00005", "0.01", "0"), "il lettore ha tolleranze diverse da quelle dei file prova"
assert "$tolP=& $decF '0.05'; $tolF=& $decF '0.00005'; $tolD=& $decF '0.01';" in src_, "le tolleranze del sorgente della riga NON sono quelle del lettore"
te = " ".join(l.lstrip("# ").strip() for l in pe.decode("ascii").splitlines() if l.startswith("#"))
te = re.sub(r"\s+", " ", te)
for frase in ("Trades IDENTICO alla cifra; PF alla quarta decimale; |dProfit| <= 0,05; |dEqDD| <= 0,01", "la stessa di R250 par. 5.2", "il centesimo di conversione NON annulla",
              "IS Trades 157 Profit 1249.94 PF 1.25920 RF 1.70352 EqDD 7.1736", "OOS Trades 199 Profit 2974.09 PF 1.48133 RF 4.42850 EqDD 6.6241"):
    frase_n = re.sub(r"\s+", " ", frase)
    assert frase_n in te or re.sub(r"\s+", "", frase) in re.sub(r"\s+", "", te), "la frase '%s' non e nel file prova R280e" % frase
for fase, att in LG.G0_ATTESO.items():
    for col in ("Profit", "Profit Factor", "Equity DD %", "Trades"):
        k = {"Profit": "Profit", "Profit Factor": "PF", "Equity DD %": "DD", "Trades": "N"}[col]
        assert ("%s='%s'" % (k, att[col])) in src_, "numero atteso %s %s (%s) non scritto nel sorgente della riga" % (fase, col, att[col])
    assert ("RF='%s'" % att["Recovery Factor"]) in src_
# (4) magic vergini: parola intera, al pin e su ogni ramo remoto, fuori dai file di questa riga e dai documenti che li nominano (classe 1096: si CLASSIFICANO)
MIEI = re.compile(r"^(backtest_pipeline/collaudo_riga_R280/|backtest_pipeline/righe/RIGA_(ROUND|LANCIA)_R280\.txt$|backtest_pipeline/leggi_r280\.py$|backtest_pipeline/CHECKLIST_RIGA_DI_LANCIO\.md$|"
                  r"backtest_pipeline/prove/R280[ae]_.*\.txt$|backtest_pipeline/prove/R280_CRITERI_LETTURA_2026-10-05\.md$)")
RISERVA = ("report/APERTURE_DOW_MAPPA_2026-10-03.md",)       # menzione di riserva (non e' un file che gira)
rami = [x.strip() for x in git("branch", "-r").stdout.decode().splitlines() if "->" not in x]
for mg, proprio in (("798701", PA), ("798711", PE), ("798721", PE)):
    for rev in [PIN] + rami:
        r = git("grep", "-l", "-w", mg, rev)
        fl = sorted(set(l.split(":", 1)[1] for l in r.stdout.decode().splitlines() if l.strip()))
        assert proprio in fl or rev != PIN, "il magic %s non compare nel proprio file prova %s al pin" % (mg, proprio)
        fuori = [f for f in fl if f not in RISERVA and not MIEI.match(f)]
        assert not fuori, "magic %s usato altrove in %s: %s" % (mg, rev, fuori)
# (5) EA, include, driver, walk-forward: i byte approvati
m = {"__PIN__": PIN, "__PIN8__": PIN[:8], "__HP_E__": sha(pe), "__HP_A__": sha(pa), "__NP_E__": str(len(ie)), "__NP_A__": str(len(ia))}
EA = "mql5/Experts/ABTG_Nasdaq_Apertura_US.mq5"
INC = "mql5/Include/ABTG_PausaGuardian.mqh"
assert git_show(EA) == git_show(EA, PIN_R262B), "l EA al pin NON e' byte per byte quello di R262b (02c70e17)"
assert git_show(INC) == git_show(INC, PIN_R262B), "l include al pin NON e' byte per byte quello di R262b (02c70e17)"
m["__SHA_EA__"] = sha(git_show(EA))
m["__SHA_INC__"] = sha(git_show(INC))
wf = git_show("backtest_pipeline/walkforward_generico_RETRY.ps1")
m["__SHA_WF__"] = sha(wf)
drvb = git_show("backtest_pipeline/righe/RIGA_ROUND_VPS_RETRY.ps1")
m["__SHA_DRV__"] = sha(drvb)
assert m["__SHA_DRV__"] == "D0341CB42C88D00FD663A09B7D4FBFECAA6866051966C6E30B28916EB3B53A47", "la copia RETRY del driver al pin NON e' quella del PASS (d949f705): " + m["__SHA_DRV__"]
assert m["__SHA_WF__"] == "267F8B0571EED9475A809089206D2DF56395CF9B957BBE517239CA26D4473798", "walkforward_generico_RETRY al pin NON e' quello del PASS (d949f705): " + m["__SHA_WF__"]
assert b"MARCATORE_RIGA_ROUND_VPS_RETRY_v1" in drvb and b"MARCATORE_RIGA_ROUND_VPS_v2" in drvb
assert b'$NOME_DRV = "walkforward_generico_RETRY.ps1"' in drvb
assert b'macchina = "DESKTOP-H4D7CAJ"\n     perc     = "C:\\Program Files\\BCM Markets MT5 Terminal"' in drvb, "la tabella del driver al pin non porta DESKTOP-H4D7CAJ -> C:\\Program Files\\BCM Markets MT5 Terminal"
assert b"MARCATORE_WALKFORWARD_GENERICO_v7_RETRY" in wf and b"MARCATORE_WALKFORWARD_GENERICO_v5_INCLUDE" in wf
assert sha(git_show("backtest_pipeline/righe/RIGA_ROUND_VPS.ps1")) == "3341756FB37889DBD6E827A87BAC26893E01C85B6C18343918083B01B4DD3425"
assert m["__SHA_INC__"] == "3EC971152E85E0082488CC4243FF45AE09948C191D52AB96050B48F94641A737", m["__SHA_INC__"]
# le righe dell EA citate nel testo della riga (export a frame e per-trade)
ea = git_show(EA).decode("ascii", "replace").split("\n")
def riga_di(cosa):
    return [n + 1 for n, l in enumerate(ea) if cosa in l]
assert riga_di("void ExportTrades()") == [2564] and riga_di("double OnTester()") == [2591] and riga_di("ExportTrades();   //") == [2593] and riga_di("FrameAdd(OPTFRAME_NAME") == [2608] and riga_di("void OnTesterDeinit()") == [2614], \
    "le righe dell EA citate nel testo della riga (r.2564 / 2591 / 2593 / 2608 / 2614) NON tornano al pin"
t = " ".join(l.strip() for l in src_.split("\n") if l.strip() and not l.startswith("##"))
for k, v in m.items():
    assert k in t, "segnaposto non usato nel sorgente: " + k
    t = t.replace(k, v)
resid = re.findall(r"__[A-Z0-9_]+__", t)
assert not resid, "segnaposto rimasti: %s" % resid
t.encode("ascii")
assert "\n" not in t and "\r" not in t and "\t" not in t
assert t.count("MARCATORE_RIGA_ROUND_R280_v1") == 1
dest = os.path.join(REPO, "backtest_pipeline", "righe", "RIGA_ROUND_R280.txt")
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
print("   e/a al pin = R262b salvo i punti dichiarati (magic, EmaSlow, FilterTF); numeri G0 = CSV veri di R262b e R245b; EA e include = 02c70e17 byte per byte")
