#!/usr/bin/env python3
# -*- coding: ascii -*-
"""
fixture.py -- costruisce un finto disco C: del VPS VMI3047753 (cartella vera su Linux, vista da pwsh come PSDrive C:) e calcola le ATTESE dalla stessa specifica,
in Python, SENZA leggere l'uscita dello script (ATTESE.txt, scritte prima dello script). Layout preso da quello MISURATO nei referti del VPS del 05/10/2026 (coda/referti CODA_01/03/04/05):
  C:\\Users\\Administrator\\AppData\\Roaming\\MetaQuotes\\Terminal\\<hash>\\{origin.txt, config\\common.ini, logs\\AAAAMMGG.log, MQL5\\{Experts,Logs,Profiles\\Charts\\<profilo>\\chartNN.chr}}
  piccolo = 215D85D767A1C39E22D242C8114BF9F5 (origin C:\\Program Files\\BCM Markets MT5 Terminal, ProfileLast=ORO), e gli altri sette terminali con i loro origin e conti veri.
Le righe di login hanno la forma vera: "'50503392': previous successful authorization performed from 161.97.172.19 on 2026.10.04 03:57:43" (CODA_03).
Il file EA servito e' quello VERO al commit pinnato (git show), cosi' la costante SHA256 dello script e' provata contro l'artefatto reale.
"""
import hashlib, os, shutil, subprocess, time

QD = os.path.dirname(os.path.abspath(__file__))
REPO = os.path.abspath(os.path.join(QD, "..", ".."))
EA_PIN = "81b4329fbc33af87957d89198a2a4af127693ecc"
EA_SHA = "FD7AACD694E3CE9E7D4F95C7A4C9881464A89B376AE1919B0A05C5241E0596F4"
EA_REL = "mql5/Experts/ABTG_EMA200_Ombra.mq5"
EA_BYTES = subprocess.run(["git", "show", "%s:%s" % (EA_PIN, EA_REL)], cwd=REPO, capture_output=True, check=True).stdout
assert hashlib.sha256(EA_BYTES).hexdigest().upper() == EA_SHA, "l'artefatto al pin non ha lo SHA256 dichiarato"

TERM = "C:\\Program Files\\BCM Markets MT5 Terminal"
PICCOLO = "215D85D767A1C39E22D242C8114BF9F5"
ACC = "50503392"
ADMIN = "Administrator"
APPREL = ("AppData", "Roaming", "MetaQuotes", "Terminal")
LOGIN_FMT = "'%s': previous successful authorization performed from 161.97.172.19 on 2026.10.04 03:57:43"

# gli altri terminali del VPS: (hash, origin, conto, eta' ore dell'ultimo log) -- eta' e conti dai referti CODA_03/CODA_05 del 05/10
ALTRI = [
    ("04C7A32B575E40027B4FF8724D14D702", "C:\\MT5_Backtest", "50504400", 324.0),
    ("46C9F8E9FF0C747B2B5E09BCC13D5237", "C:\\FTMO", "1514806751", 0.1),
    ("73B7A2420D6397DFF9014A20F1201F97", "C:\\Program Files\\Pepperstone MetaTrader 5", None, 2600.0),
    ("857385E4B0F2356AD99AA95CDF40FAE9", "C:\\Program Files\\Tickmill Europe MT5 Terminal", None, 1829.0),
    ("BCA8AD18563BF5B64A433C2662D0A104", "C:\\Program Files\\BCM Markets MT5 Terminal -V3", "50504263", 162.0),
    ("CF6C240A869369695913FB76DA84BD22", "C:\\MT5_MANUALE", "50503635", 0.5),
    ("E23E1504A8D02A22179395F0652B86B6", "C:\\BCM_Reale", "10105439", 0.5),
]


def default_spec():
    return dict(
        nome="base", macchina="VMI3047753", utente=ADMIN,
        # il piccolo
        piccolo=True, p_profilo=ADMIN, p_hash=PICCOLO, p_origin=TERM, p_origin_enc="utf16bom", p_experts=True,
        p_logs=[(50.0, [ACC]), (1.0, [])],        # (eta' ore, [conti di login nelle righe]) -- il piu' RECENTE non ha righe di login (connessione continua)
        p_logs_dir=True, p_mql5logs_eta=0.5,      # None = MQL5\Logs assente
        p_ini="on",                               # on | assente | altro_login
        p_ini_login=ACC, p_profile_last="ORO", chr_attivo=5, chr_senza_ea=1, chr_residuo=3, chr_vuoto=0, ombra_attaccata=False,
        existing=None,                            # None | uguale | diverso | cartella
        ex5=False,
        # copie e decoy
        extra=[],                                 # lista di dict(hash, profilo, origin, logs, ...) -> cartelle dati in piu'
        v3_conto_decoy=False,                     # il 100k col login 50503392 nei giornali, FRESCO
        users=[ADMIN, "Master", "Public"],
        # processi, RAM
        procs="default", cim_ok=True, libera_kb=1900000, totale_kb=12582912,
        senza_desktop=False,
        server="ok",                              # ok | sha_diverso | coerente_trading | versione_property | versione_define | non_ascii | 404 | giu
    )


def utf16(s):
    return b"\xff\xfe" + s.encode("utf-16-le")


def scrivi(p, b):
    os.makedirs(os.path.dirname(p), exist_ok=True)
    open(p, "wb").write(b)


def set_age(p, ore):
    t = time.time() - ore * 3600.0
    os.utime(p, (t, t))


def origin_bytes(testo, enc):
    if enc == "utf16bom":
        return utf16(testo)
    if enc == "utf8bom":
        return b"\xef\xbb\xbf" + testo.encode("ascii")
    if enc == "plain":
        return testo.encode("ascii")
    raise ValueError(enc)


def chr_text(nome_ea, simbolo="EURUSD"):
    t = "<chart>\r\nid=1\r\nsymbol=%s\r\nperiod_type=1\r\nperiod_size=1\r\n<window>\r\n<indicator>\r\nname=Main\r\n</indicator>\r\n</window>\r\n" % simbolo
    if nome_ea:
        t += "<expert>\r\nname=%s\r\npath=Experts\\%s.ex5\r\n</expert>\r\n" % (nome_ea, nome_ea)
    return t + "</chart>\r\n"


def costruisci_dati(root, hash_, origin, origin_enc, conto_logs, logs, logs_dir, mql5logs_eta, ini, ini_login, profile_last, experts, spec_chr=None, existing=None, ex5=False, sentinella=True):
    d = os.path.join(root, hash_)
    os.makedirs(os.path.join(d, "MQL5"), exist_ok=True)
    if experts:
        os.makedirs(os.path.join(d, "MQL5", "Experts"), exist_ok=True)
        if sentinella:
            scrivi(os.path.join(d, "MQL5", "Experts", "ABTG_SENTINELLA_%s.mq5" % hash_[:6]), ("// sentinella %s\n" % hash_).encode("ascii"))
    if origin is not None:
        scrivi(os.path.join(d, "origin.txt"), origin_bytes(origin, origin_enc))
    if ini != "assente":
        login = ini_login if ini == "on" else ini_login
        txt = "[Common]\r\nLogin=%s\r\nServer=BCMMarkets-Server\r\n" % login
        if profile_last:
            txt += "ProfileLast=%s\r\n" % profile_last
        scrivi(os.path.join(d, "config", "common.ini"), utf16(txt))
    if logs_dir:
        for i, (eta, conti) in enumerate(logs):
            p = os.path.join(d, "logs", "2026%04d.log" % (1000 + i))
            righe = ["FK\t0\t03:57:%02d.123\tNetwork\t%s" % (i, LOGIN_FMT % c) for c in conti]
            righe.append("KI\t0\t03:58:00.000\tTerminal\tMetaTrader 5 x64 build 5000 started")
            scrivi(p, utf16("\r\n".join(righe) + "\r\n"))
            set_age(p, eta)
    if mql5logs_eta is not None:
        p = os.path.join(d, "MQL5", "Logs", "20261005.log")
        scrivi(p, utf16("PS\t0\t03:28:00.000\tExperts\tABTG_PunteLarry (GBPJPY,H1) tutto bene\r\n"))
        set_age(p, mql5logs_eta)
    if spec_chr:
        att, senza, res, vuoto, ombra = spec_chr
        base = os.path.join(d, "MQL5", "Profiles", "Charts")
        n = 0
        for i in range(att):
            n += 1
            scrivi(os.path.join(base, "ORO", "chart%02d.chr" % n), utf16(chr_text("ABTG_PunteLarry", "GBPJPY")))
        if ombra:
            n += 1
            scrivi(os.path.join(base, "ORO", "chart%02d.chr" % n), utf16(chr_text("ABTG_EMA200_Ombra", "EURUSD")))
        for i in range(senza):
            n += 1
            scrivi(os.path.join(base, "ORO", "chart%02d.chr" % n), utf16(chr_text(None, "USDJPY")))
        for i in range(vuoto):
            n += 1
            scrivi(os.path.join(base, "ORO", "chart%02d.chr" % n), b"")
        for i in range(res):
            scrivi(os.path.join(base, "OLD", "chart%02d.chr" % (i + 1)), utf16(chr_text("ABTG_Residuo", "EURUSD")))
    if existing and experts:
        dest = os.path.join(d, "MQL5", "Experts", "ABTG_EMA200_Ombra.mq5")
        if existing == "uguale":
            scrivi(dest, EA_BYTES)
        elif existing == "diverso":
            scrivi(dest, EA_BYTES.replace(b'"1.03"', b'"1.02"'))
        elif existing == "cartella":
            os.makedirs(dest)
            open(os.path.join(dest, "x.txt"), "w").write("x")
        if existing in ("uguale", "diverso"):
            t = time.mktime((2026, 10, 1, 12, 0, 0, 0, 0, -1))
            os.utime(dest, (t, t))
    if ex5 and experts:
        scrivi(os.path.join(d, "MQL5", "Experts", "ABTG_EMA200_Ombra.ex5"), b"EX5")
    return d


def costruisci(base, spec):
    """crea <base>/cdrive e ritorna il percorso."""
    c = os.path.join(base, "cdrive")
    shutil.rmtree(c, ignore_errors=True)
    for u in spec["users"]:
        os.makedirs(os.path.join(c, "Users", u))
    os.makedirs(os.path.join(c, "Users", spec["utente"], "Desktop") if not spec["senza_desktop"] else os.path.join(c, "Users", spec["utente"]), exist_ok=True)

    def radice(profilo):
        r = os.path.join(c, "Users", profilo, *APPREL)
        os.makedirs(r, exist_ok=True)
        return r

    # gli altri sette terminali: SEMPRE presenti (devono restare intatti, provato dallo snapshot)
    r_adm = radice(ADMIN)
    for (h, o, conto, eta) in ALTRI:
        ini_login = conto or "0"
        logs = [(eta, [conto] if conto else [])]
        decoy = (h.startswith("BCA8AD18") and spec["v3_conto_decoy"])
        if decoy:
            logs = [(1.0, [ACC])]
            ini_login = ACC
        costruisci_dati(r_adm, h, o, "utf16bom", conto, logs, True, None if conto is None else eta, "on" if conto else "assente", ini_login, "Default", True,
                        spec_chr=(2, 0, 0, 0, False))
    # il piccolo e le copie
    if spec["piccolo"]:
        costruisci_dati(radice(spec["p_profilo"]), spec["p_hash"], spec["p_origin"], spec["p_origin_enc"], ACC, spec["p_logs"], spec["p_logs_dir"], spec["p_mql5logs_eta"],
                        spec["p_ini"], spec["p_ini_login"] if spec["p_ini"] != "altro_login" else "50504263", spec["p_profile_last"], spec["p_experts"],
                        spec_chr=(spec["chr_attivo"], spec["chr_senza_ea"], spec["chr_residuo"], spec["chr_vuoto"], spec["ombra_attaccata"]), existing=spec["existing"], ex5=spec["ex5"])
    for e in spec["extra"]:
        costruisci_dati(radice(e["profilo"]), e["hash"], e.get("origin", TERM), "utf16bom", ACC, e.get("logs", [(e.get("eta", 1.0), [ACC])]), True, e.get("eta", 1.0), "on", ACC, "ORO", True,
                        spec_chr=(2, 0, 0, 0, False))
    return c


def snapshot(c, utente=ADMIN):
    """percorso relativo -> sha256 per TUTTO il finto C: tranne il Desktop dell'utente della sessione (dove la riga PUO' scrivere)."""
    out = {}
    desk = ("Users/%s/Desktop" % utente)
    for rd, dirs, files in os.walk(c):
        rel = os.path.relpath(rd, c).replace(os.sep, "/")
        if rel.startswith(desk):
            continue
        for d in dirs:
            out[(rel + "/" + d + "/")] = "dir"
        for f in files:
            p = os.path.join(rd, f)
            if rel == "Users/%s" % utente and (f.startswith("ABTG_OMBRA_INSTALL_")):
                continue            # il ripiego del Desktop (senza Desktop) scrive sotto USERPROFILE
            out[rel + "/" + f] = hashlib.sha256(open(p, "rb").read()).hexdigest()
    return out


def procs_default(spec):
    """i terminal64 del VPS come li ha MISURATI il 03/09 e il 05/10: piccolo, 100k -V3, reale, FTMO. Valori scelti dalla specifica: WS 1234567890 B, PM 987654321 B."""
    return [
        dict(Id=9452, Name="terminal64", Title="50503392 - BCMMarkets-Server: Demo Account - Hedge", Path=TERM + "\\terminal64.exe", Ws=1234567890, Pm=987654321, Cpu=100.0, Delta=0.45),
        dict(Id=4948, Name="terminal64", Title="50504263 - BCMMarkets-Server: Demo Account - Hedge [-V3]", Path=TERM + " -V3\\terminal64.exe", Ws=2000000000, Pm=1500000000, Cpu=900.0, Delta=0.10),
        dict(Id=7001, Name="terminal64", Title="10105439 - BCMMarkets-Server: Real", Path="C:\\BCM_Reale\\terminal64.exe", Ws=800000000, Pm=700000000, Cpu=50.0, Delta=0.05),
        dict(Id=7002, Name="terminal64", Title="1514806751 - FTMO-Demo", Path="C:\\FTMO\\terminal64.exe", Ws=900000000, Pm=800000000, Cpu=60.0, Delta=0.05),
    ]


def ARROT(x):
    """arrotondamento a intero come [math]::Round (pari al .5): Python round() e' lo stesso."""
    return int(round(x))


def attese(spec):
    """ATTESE calcolate dalla SPECIFICA. Non leggono mai l'uscita."""
    a = {}
    a["libera_mb"] = ARROT(spec["libera_kb"] / 1024.0) if spec["cim_ok"] else None
    a["totale_mb"] = ARROT(spec["totale_kb"] / 1024.0) if spec["cim_ok"] else None
    a["sedie"] = spec["chr_attivo"] + (1 if spec["ombra_attaccata"] else 0)           # EA nel profilo ATTIVO (l'ombra gia' attaccata e' un EA anch'essa)
    a["grafici"] = spec["chr_attivo"] + (1 if spec["ombra_attaccata"] else 0) + spec["chr_senza_ea"] + spec["chr_vuoto"]
    ps = procs_default(spec) if spec["procs"] == "default" else (spec["procs"] or [])
    nostri = [p for p in ps if p["Name"] == "terminal64" and p.get("Path") and p["Path"].rsplit("\\", 1)[0].lower().rstrip("\\") == TERM.lower()]
    a["nostri"] = len(nostri)
    if nostri:
        n = nostri[0]
        a["ws_mb"] = ARROT(n["Ws"] / 1048576.0)
        a["pm_mb"] = ARROT(n["Pm"] / 1048576.0)
        a["cpu_pct"] = round(n["Delta"] / 5.0 * 100, 1)
        a["cpu_su_6"] = round(a["cpu_pct"] / 6.0, 1)
        a["giallo"] = ARROT(n["Ws"] / 1048576.0 + 500)
        a["rosso"] = ARROT(n["Ws"] / 1048576.0 + 800)
        a["pids"] = ", ".join(str(x["Id"]) for x in nostri)
    a["rosso_libera"] = max(1024, a["libera_mb"] - 800) if a["libera_mb"] is not None else 1024
    return a
