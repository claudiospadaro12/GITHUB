#!/usr/bin/env python3
# -*- coding: ascii -*-
"""
sim_mt5.py -- il TERMINALE e METAEDITOR FINTI del banco di NATCLA_F0_PASSATE.ps1. NON e' MT5: non fa nessun backtest. Fa solo quello che lo script deve poter OSSERVARE dall'esterno.
  KIND=editor  : se il .mq5 contiene 'NC_VER' e lo scenario non dice compile_fallisce produce l'.ex5 e scrive il log '/log:' nel formato VERO dei log di MetaEditor di questa casa
                 (UTF-16, '... .mq5 - 0 errors, 0 warnings, 1915 ms elapsed, cpu=...'), con gli avvisi dello scenario.
  KIND=terminal: legge la .ini data con /config: e si comporta come il tester ma SOLO a partire da cio' che trova nell'ini (Symbol, Period, FromDate, ToDate, Optimization, Model,
                 AllowLiveTrading, [TesterInputs] InpModalita/InpTF/InpSoloConta/...): scrive nel LOG dell'agente (UTF-16 con BOM, formato vero 'CS<TAB>0<TAB>HH:MM:SS.mmm<TAB>EA (SIM,TF)<TAB>data   [NatCla] ...')
                 la riga AVVIO (derivata dall'ini: se l'ini e' sbagliata l'AVVIO lo dice), la VERIFICA ADX, gli avvisi; nel giornale del tester la riga 'Tester<TAB>Experts\\EA_NatCla.ex5 on SIM,TF from .. to ..';
                 e il CSV dei setup in Terminal\\Common\\Files\\natcla_setup_<sim>_<magic>.csv (righe CONTA vere prodotte da leggi_natcla_f0.csv_finto). Lo scenario puo' iniettare difetti per passata.
"""
import datetime, json, os, re, sys, time

kind = os.environ["SIM_KIND"]
scen = json.load(open(os.environ["SIM_SCEN"]))
C = os.environ["SIM_CDRIVE"]
LOG = os.environ["SIM_LOG"]
args = os.environ.get("SIM_ARGS", "")
os.makedirs(LOG, exist_ok=True)
sys.path.insert(0, os.environ["SIM_REPO_BP"])


def lin(p):
    p = p.strip().strip('"')
    if p.startswith(C):
        return p
    if re.match(r"^[A-Za-z]:", p):
        p = p[2:]
    return os.path.join(C, *[x for x in re.split(r"[\\/]", p) if x])


def utf16(s):
    return b"\xff\xfe" + s.encode("utf-16-le")


if kind == "editor":
    open(os.path.join(LOG, "sim_args_editor.txt"), "w").write(os.environ.get("SIM_ARGV_JSON", ""))
    argv = json.loads(os.environ.get("SIM_ARGV_JSON", "[]"))
    comp = [a for a in argv if a.startswith("/compile:")]
    logp = [a for a in argv if a.startswith("/log:")]
    if len(argv) == 2 and len(comp) == 1 and len(logp) == 1:
        f = lin(comp[0][len("/compile:"):])
        ok = (b"NC_VER" in open(f, "rb").read()) and not scen.get("compile_fallisce")
        nerr = 0 if (ok or scen.get("compile_silenzioso")) else 3
        if scen.get("compile_errori_con_ex5"):
            ok, nerr = True, 2
        w = scen.get("compile_avvisi", 0)
        righe = ["0\t2026.10.08 09:00:00.000\tCompile\t%s - %d errors, %d warnings, 1915 ms elapsed, cpu='X64 Regular'" % (f, nerr, w)]
        for k in range(min(w, 3)):
            righe.insert(0, "1\t2026.10.08 09:00:00.000\tCompile\t%s(%d,5) : warning 43: possible loss of data due to type conversion" % (f, 100 + k))
        if scen.get("compile_senza_riga_result"):
            righe = ["niente"]
        lp = lin(logp[0][len("/log:"):])
        open(lp, "wb").write(utf16("\r\n".join(righe) + "\r\n"))
        if ok:
            open(f[:-4] + ".ex5", "wb").write(b"EX5")
    sys.exit(0)

# ---------------- terminale
m = re.search(r'/config:(\S+)', args)
ini = lin(m.group(1)) if m else ""
txt = open(ini, "rb").read().decode("ascii") if ini and os.path.exists(ini) else ""
open(os.path.join(LOG, "sim_ini_%d.txt" % len(os.listdir(LOG))), "w").write(txt)
sez = None
tester, inp = {}, {}
for l in txt.splitlines():
    l = l.strip()
    if l.startswith("["):
        sez = l; continue
    if "=" in l:
        k, v = l.split("=", 1)
        if sez == "[Tester]":
            tester[k] = v
        elif sez == "[TesterInputs]":
            inp[k] = v
        elif sez == "[Experts]":
            tester["EXP_" + k] = v
sym = tester.get("Symbol", "?")
per = tester.get("Period", "H1")
open(os.path.join(LOG, "sim_terminale_lanci.txt"), "a").write("%s %s Optimization=%s Model=%s Live=%s Dll=%s SoloConta=%s Modalita=%s TF=%s Magic=%s Report=%s\n" % (
    sym, per, tester.get("Optimization"), tester.get("Model"), tester.get("EXP_AllowLiveTrading"), tester.get("EXP_AllowDllImport"), inp.get("InpSoloConta"), inp.get("InpModalita"), inp.get("InpTF"), inp.get("InpMagic"), tester.get("Report")))
tag_scen = "%s_%s" % (sym, {"16385": "H1", "16388": "H4", "16396": "H12", "16408": "D1"}.get(inp.get("InpTF", ""), "?"))
fault = None
for k, v in scen.get("falli", {}).items():
    modal = {"0": "AUDIO", "2": "M2"}.get(inp.get("InpModalita", ""), "?")
    if k == "%s_%s_%s" % (sym, modal, {"16385": "H1", "16388": "H4", "16396": "H12", "16408": "D1"}.get(inp.get("InpTF", ""), "?")):
        fault = v
if scen.get("fault_tutti"):
    fault = scen["fault_tutti"]
modalita = int(inp.get("InpModalita", "0"))
tfn = int(inp.get("InpTF", "16385"))
cifra = {16385: 1, 16388: 4, 16396: 2, 16408: 8}.get(tfn, 0)
magic = 778600 + 10 * modalita + cifra
tfname = {16385: "H1", 16388: "H4", 16396: "H12", 16408: "D1"}.get(tfn, "H1")
solo = "SI" if (inp.get("InpSoloConta") == "true" and fault != "solo_no") else "no"
import leggi_natcla_f0 as L
prova = open(os.path.join(os.environ["SIM_REPO_BP"], "prove", "NATCLA_F0_conteggio_2026-10-07.txt"), encoding="ascii").read()
bl = L.leggi_blocchi(prova)
cl = bl["simboli"][sym]["classe"] if sym in bl["simboli"] else "FX"
u = float(scen.get("unita", {}).get(sym, bl["simboli"][sym]["u"] if sym in bl["simboli"] else "0.0001"))
mod = "AUDIO" if modalita == 0 else "EMA200"
linee = "ST25 ST30 ST35 " if modalita == 0 else "E200"
adx = "ACCESO" if modalita == 0 else "spento"
descr = {"FX": "AUTO_CLASSE forex: pip", "ORO": "AUTO_CLASSE metallo: 1,0 USD", "ARG": "AUTO_CLASSE metallo: 1,0 USD", "IDX": "AUTO_CLASSE indice/CFD: 1,0 punto"}[cl]
ver = "1.03" if fault == "avvio_ver" else "1.04"
avv = ("[NatCla] AVVIO v%s | modalita' %s | %s PERIOD_%s | 1 u = %s (%s) | 1 pip = %s | magic %s | linee %s | ADX %s, iADX MetaQuotes, max 20.0, periodo 14 | ingresso SCALA3_PENDENTI | "
       "rischio setup 0.25%% (SEGNAPOSTO DA FIRMARE DA CLAUDIO) | guardian ON (nel tester FAIL-OPEN) | solo conta %s | placebo 0.00 ATR | fonte SOLO AUDIO (PDF escluso 07/10)" % (
           ver, mod, sym, tfname, ("%.5f" % u), descr, ("%.5f" % u), magic, linee, adx, solo))
chi = "formula MetaQuotes (DI per barra, media esponenziale 2/(n+1))"
adx_t = 21.34
if fault == "wilder":
    chi = "formula di Wilder (1/n)"; adx_t = 18.10
if fault == "nessuna_adx":
    chi = "NESSUNA DELLE DUE: il filtro ADX va capito PRIMA di leggere i numeri"; adx_t = 25.0
barra_ver = scen.get("barra_verifica", "2024.07.08 10:00")
vrf = "[NatCla] VERIFICA ADX barra %s periodo 14: terminale NC_ADX_MT5 = %.2f | ricalcolo MetaQuotes = 21.30 | ricalcolo Wilder = 18.10 -> il terminale coincide con: %s" % (barra_ver, adx_t, chi)
ora = time.strftime("%H:%M:%S")
agent = os.path.join(C, "Users", "Master", "AppData", "Roaming", "MetaQuotes", "Tester", "AGENT1", "Agent-127.0.0.1-3000", "logs")
os.makedirs(agent, exist_ok=True)
lp = os.path.join(agent, "20261008.log")
nuovo = not os.path.exists(lp)
righe = []
mk = [0]


def riga(t, quando="2024.07.05 00:00:00"):
    mk[0] += 1
    return "CS\t0\t%s.%03d\tEA_NatCla (%s,%s)\t%s   %s" % (ora, mk[0] % 1000, sym, tfname, quando, t)


if fault != "no_avvio":
    righe.append(riga(avv))
    if fault == "doppio_avvio":
        righe.append(riga(avv.replace("magic %d" % magic, "magic %d" % (magic + 1))))
if fault == "rifiutato":
    righe.append(riga("[NatCla] AVVIO RIFIUTATO: InpMagic fuori dal blocco 778600-778699"))
else:
    righe.append(riga("[NatCla] AVVISO: SOLO CONTA: nessun ordine verra' inviato"))
    if fault != "no_verifica":
        righe.append(riga(vrf))
for g in range(3):
    righe.append(riga("[NATCLA-IMBUTO] %s PERIOD_%s parziale del 2024.07.0%d | valutate 24 | quadratura OK || ordini: | nessun ordine 0" % (sym, tfname, 5 + g)))
with open(lp, "ab") as f:
    if nuovo:
        f.write(b"\xff\xfe")
    f.write(("\r\n".join(righe) + "\r\n").encode("utf-16-le"))
# giornale del tester: la riga dell'intestazione (finestra), senza la data simulata
jd = os.path.join(C, "Users", "Master", "AppData", "Roaming", "MetaQuotes", "Terminal", "ABC123", "Tester", "logs")
os.makedirs(jd, exist_ok=True)
jp = os.path.join(jd, "20261008.log")
jnuovo = not os.path.exists(jp)
da = tester.get("FromDate")
a = tester.get("ToDate")
if fault == "finestra":
    a = "2025.12.31"
if fault != "no_giornale":
    jr = "RD\t0\t%s.100\tTester\tExperts\\EA_NatCla.ex5 on %s,%s from %s 00:00 to %s 00:00\r\n" % (ora, sym, {"D1": "Daily"}.get(per, per), da, a)
    if fault == "nocsv":
        jr += "XX\t0\t%s.200\tTester\t%s: no history data found, tester stopped\r\n" % (ora, sym)
    with open(jp, "ab") as f:
        if jnuovo:
            f.write(b"\xff\xfe")
        f.write(jr.encode("utf-16-le"))
# il CSV
if fault not in ("nocsv", "rifiutato"):
    base = datetime.datetime(2024, 7, 9, 10, 0)
    linea = "ST25" if modalita == 0 else "E200"
    nrip = scen.get("n_episodi", 5)
    piano = {linea: [(2, 1, 0, 0, 15.0, 0.5, base + datetime.timedelta(hours=7 * i)) for i in range(nrip)]}
    if modalita == 0:
        piano["ST35"] = [(1, 1, 0, 0, 15.0, 0.7, base + datetime.timedelta(hours=7 * i + 3)) for i in range(2)]
    cb = L.csv_finto(piano, u=u, spread=(0.25 if cl in ("ORO", "ARG", "IDX") else 0.00002), lv0=(2400.0 if cl in ("ORO", "ARG", "IDX") else 1.1))
    if fault == "csv_senza_header":
        cb = cb.replace(b"tipo;barra;linea;lato;", b"x;barra;linea;lato;")
    d = os.path.join(C, "Users", "Master", "AppData", "Roaming", "MetaQuotes", "Terminal", "Common", "Files")
    os.makedirs(d, exist_ok=True)
    p = os.path.join(d, "natcla_setup_%s_%d.csv" % (sym, magic))
    open(p, "wb").write(cb)
    if fault == "csv_vecchio":
        t = time.time() - 86400
        os.utime(p, (t, t))
    if fault == "csv_agente":
        # lo scrive l'agente, non Common: il driver lo cerca anche li
        os.remove(p)
        da_ = os.path.join(C, "Users", "Master", "AppData", "Roaming", "MetaQuotes", "Tester", "AGENT1", "Agent-127.0.0.1-3000", "MQL5", "Files")
        os.makedirs(da_, exist_ok=True)
        open(os.path.join(da_, "natcla_setup_%s_%d.csv" % (sym, magic)), "wb").write(cb)
