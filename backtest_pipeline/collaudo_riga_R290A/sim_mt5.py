#!/usr/bin/env python3
# -*- coding: ascii -*-
"""
sim_mt5.py -- il TERMINALE e METAEDITOR FINTI del banco di PASSATA_STOP_SUPREV_NAS.ps1. NON e' MT5: non fa nessun backtest. Fa solo quello che lo script deve poter
OSSERVARE dall'esterno, secondo uno SCENARIO scritto dal collaudo (JSON in SIM_SCEN):
  - KIND=editor : produce l'.ex5 accanto al .mq5 se il .mq5 contiene la firma e lo scenario non dice "compile_fallisce"; registra gli ARGOMENTI ricevuti (sim_args_editor.txt).
  - KIND=terminal: legge la .ini data con /config: (la copia in sim_ini.txt, registra se c'e' AllowLiveTrading=false), poi scrive
        * il LOG dell'agente (UTF-16 LE con BOM, formato VERO letto in risultati_archivio/ROUND_ORB_R271_2026-09-29/LOG_TESTER/0003_Agent-...log:
          "XX<TAB>0<TAB>HH:MM:SS.mmm<TAB>EA (SIM,TF)<TAB>AAAA.MM.GG HH:MM:SS   [STReversal] ...") con la riga d'avvio derivata dagli input DELLA INI (o forzata dallo scenario),
          le righe "mercato" dello scenario e le righe [STREV-IMBUTO] per giornata (la somma degli ENTRATE e' quella delle righe, o sbagliata se lo scenario lo chiede);
        * il REPORT .htm (UTF-16 LE, stessa struttura delle celle del report VERO di R109/R258: <td>Etichetta:</td><td><b>valore</b></td>) dove lo scenario dice;
        * facoltativamente il per-trade in Common\\Files.
  Variabili d'ambiente: SIM_KIND, SIM_ARGS, SIM_SCEN, SIM_CDRIVE (radice del finto C:), SIM_LOG (dove registrare cio' che ha visto).
"""
import json, os, re, sys, time, shutil

kind = os.environ["SIM_KIND"]
scen = json.load(open(os.environ["SIM_SCEN"]))
C = os.environ["SIM_CDRIVE"]
LOG = os.environ["SIM_LOG"]
args = os.environ.get("SIM_ARGS", "")
os.makedirs(LOG, exist_ok=True)


def lin(p):
    """percorso Windows 'C:\\a\\b' -> percorso del finto disco"""
    p = p.strip().strip('"')
    if p.startswith(C):
        return p                      # percorso gia' del finto disco (Get-ChildItem restituisce percorsi Linux veri)
    if re.match(r"^[A-Za-z]:", p):
        p = p[2:]
    return os.path.join(C, *[x for x in re.split(r"[\\/]", p) if x])


if kind == "editor":
    open(os.path.join(LOG, "sim_args_editor.txt"), "w").write(os.environ.get("SIM_ARGV_JSON", ""))
    argv = json.loads(os.environ.get("SIM_ARGV_JSON", "[]"))
    comp = [a for a in argv if a.startswith("/compile:")]
    if len(argv) == 2 and len(comp) == 1 and not scen.get("compile_fallisce"):
        f = lin(comp[0][len("/compile:"):])
        if b"STREV-IMBUTO" in open(f, "rb").read():
            shutil.copy(f, f[:-4] + ".ex5")
    sys.exit(0)

# ---------------- terminale
m = re.search(r'/config:(\S+)', args)
ini = lin(m.group(1)) if m else ""
txt = open(ini, "rb").read().decode("ascii") if ini and os.path.exists(ini) else ""
open(os.path.join(LOG, "sim_ini.txt"), "w").write(txt)
inp = {}
sezione = None
for l in txt.splitlines():
    l = l.strip()
    if l.startswith("["):
        sezione = l; continue
    if sezione == "[TesterInputs]" and "=" in l:
        k, v = l.split("=", 1); inp[k] = v
sym = "NASUSD"
mm = re.search(r"^Symbol=(\S+)", txt, re.M)
if mm:
    sym = mm.group(1)
tf = {"16385": "PERIOD_H1", "16388": "PERIOD_H4"}.get(inp.get("InpTF", ""), "PERIOD_H4")
if scen.get("avvio") is not None:
    avvio = scen["avvio"]
else:
    avvio = "[STReversal] avviato su %s %s. Supertrend(%s,%s). 1 pip=0.01000" % (sym, tf, inp.get("InpStAtrPeriod", "10"), inp.get("InpStMult", "3.5"))
if scen.get("ini_ignorata"):
    avvio = "[STReversal] avviato su %s PERIOD_H4. Supertrend(10,3.5). 1 pip=0.01000" % sym
entries = scen.get("entries", [])
ora = time.strftime("%H:%M:%S")
agent = os.path.join(C, "Users", "Master", "AppData", "Roaming", "MetaQuotes", "Tester", "AGENT1", "Agent-127.0.0.1-3000", "logs")
os.makedirs(agent, exist_ok=True)
lp = os.path.join(agent, "20261006.log")
nuovo = not os.path.exists(lp)
righe = []
mk = [0]


def riga(testo, quando="2024.09.26 00:00:00"):
    mk[0] += 1
    pre = "CS\t0\t%s.%03d\tABTG_SupertrendReversal (%s,H1)\t" % (ora, mk[0] % 1000, sym)
    return pre + (quando + "   " if quando else "") + testo


righe.append(riga(avvio))
for e in entries:
    quando, lato, lotti, ing, sl, tp = e
    t = "[STReversal] %s mercato %s lot @ %s SL %s TP %s" % (lato, lotti, ing, sl, tp)
    righe.append(riga(t, None if scen.get("senza_data") else quando))
giorni = {}
for e in entries:
    giorni.setdefault(e[0][:10], []).append(e)
tot_imb = 0
for g in sorted(giorni):
    k = len(giorni[g])
    tot_imb += k
    kk = k + (scen.get("imb_delta", 0) if g == sorted(giorni)[0] else 0)
    righe.append(riga("[STREV-IMBUTO] %s %s giorno %s | valutate %d | supertrend n/d 0 | occupata 0 | pendente in attesa 0 | tetto giornaliero 0 | fuori orario 0 | news 0 | spread 0 | "
                      "supertrend girato 0 | niente pattern 0 | confluenza EMA assente 0 | lato spento 0 | ATR n/d 0 | SL troppo vicino 0 | lotto nullo 0 | guardian 0 | invio fallito 0 | "
                      "ENTRATE %d | quadratura %s" % (scen.get("imb_simbolo", sym), tf if not scen.get("imb_tf") else scen["imb_tf"], g, k, kk, "OK" if k == kk else "ROTTA: somma x contro valutate y"), None if scen.get("senza_data") else g + " 23:00:00"))
corpo = "\r\n".join(righe) + "\r\n"
with open(lp, "ab") as f:
    if nuovo:
        f.write(b"\xff\xfe")
    f.write(corpo.encode("utf-16-le"))
# un secondo log (giornale del tester): le stesse righe SENZA data simulata -> deve essere deduplicato
if scen.get("giornale_duplicato"):
    jd = os.path.join(C, "Users", "Master", "AppData", "Roaming", "MetaQuotes", "Terminal", "ABC123", "logs")
    os.makedirs(jd, exist_ok=True)
    cj = "\r\n".join(re.sub(r"\t(\d{4}\.\d\d\.\d\d \d\d:\d\d:\d\d)   ", "\t", r) for r in righe) + "\r\n"
    with open(os.path.join(jd, "20261006.log"), "wb") as f:
        f.write(b"\xff\xfe" + cj.encode("utf-16-le"))
# ---------------- il report
rp = scen.get("report", {})
if rp.get("scrivi", True):
    def cella(lab, val):
        return '   <tr align="right">\r\n      <td nowrap colspan="3">%s:</td>\r\n      <td nowrap><b>%s</b></td>\r\n   </tr>\r\n' % (lab, val)
    L = rp.get("lingua", "it")
    et = {"it": dict(exp="Expert", sim="Simbolo", per="Periodo", prof="Profitto Totale Netto", pf="Fattore di Profitto", tr="Numero di Operazioni di Trading Totali", de="Affari Totali"),
          "en": dict(exp="Expert", sim="Symbol", per="Period", prof="Total Net Profit", pf="Profit Factor", tr="Total Trades", de="Total Deals")}[L]
    h = '<html><head><title>Report Strategy Tester</title></head><body>\r\n<table>\r\n'
    h += cella(et["exp"], rp.get("expert", "ABTG_SupertrendReversal"))
    h += cella(et["sim"], rp.get("simbolo", sym))
    h += cella(et["per"], rp.get("periodo", "H1 (%s - %s)" % ("2024.09.26", "2026.06.30")))
    for k, v in inp.items():
        if k in rp.get("input_override", {}):
            v = rp["input_override"][k]
        if k in rp.get("input_manca", []):
            continue
        h += '   <tr>\r\n      <td nowrap colspan="3"></td>\r\n      <td nowrap>%s=%s</td>\r\n   </tr>\r\n' % (k, v)
    h += cella(et["prof"], rp.get("profitto", "4 699.03").replace(" ", rp.get("sep", " ")))
    h += cella(et["pf"], rp.get("pfv", "1.57"))
    if not rp.get("senza_trades"):
        h += cella(et["tr"], rp.get("trades", "172"))
    h += cella(et["de"], rp.get("deals", "260"))
    h += "</table></body></html>\r\n"
    if rp.get("garbage"):
        h = "<html><body>niente di MT5</body></html>"
    dove = rp.get("dove", "Program Files\\BCM Markets MT5 Terminal")
    d = lin(dove)
    os.makedirs(d, exist_ok=True)
    nome = rp.get("nome", "PASSATA_STOP_NAS.htm")
    p = os.path.join(d, nome)
    with open(p, "wb") as f:
        f.write(b"\xff\xfe" + h.encode("utf-16-le"))
    if rp.get("vecchio"):
        t = time.time() - 86400
        os.utime(p, (t, t))
# per-trade
if scen.get("per_trade"):
    d = os.path.join(C, "Users", "Master", "AppData", "Roaming", "MetaQuotes", "Terminal", "Common", "Files")
    os.makedirs(d, exist_ok=True)
    p = os.path.join(d, "abtg_trades_ABTG_SupertrendReversal_NASUSD_799810.csv")
    open(p, "w").write("ticket;pos\n1;1\n")
    if scen["per_trade"] == "vecchio":
        t = time.time() - 86400
        os.utime(p, (t, t))
