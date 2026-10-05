#!/usr/bin/env python3
# -*- coding: ascii -*-
"""
fixture.py -- costruisce un finto disco C: del PC di backtest (cartella vera su Linux, vista da pwsh come PSDrive C:) e calcola le ATTESE
dalla stessa specifica, in Python, SENZA leggere l'uscita dello script. Usato da battery.py e mutazioni.py (collaudo di RIGA_DUKA_P0_CENSIMENTO.ps1).
Le attese sono scritte PRIMA di guardare l'uscita: contano gli slot, i byte e le righe che la specifica ha messo, non quelli che lo script dice.
Il PERCORSO della cache lo costruisce dukascopy_tick.percorso_cache (la funzione che lo scrive davvero: mese di CALENDARIO, ottobre = 10; solo l'URL e' zero-based).
La prima stesura di questo banco aveva il mese zero-based "a memoria", come lo script: i due sbagliavano INSIEME e il banco era verde (trovato dall'autotest 15 di dukascopy_tick.py, classe 1114).
I byte di ogni file codificano il giorno, cosi' una lettura del mese sbagliato NON torna per caso su una cache completa.
"""
import datetime, hashlib, os, shutil, sys

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "dukascopy")))
import dukascopy_tick as DT      # il LAYOUT della cache lo decide il codice che la scrive, non la memoria di chi scrive il banco (classe 1114)

D0, D1 = datetime.date(2024, 10, 1), datetime.date(2025, 6, 16)
SONDA = ["2024.11.20", "2025.06.10", "2024.10.29", "2024.10.31", "2025.03.12", "2025.03.25", "2024.12.10", "2025.01.14", "2025.02.11"]
NUOVI = ["2024.12.10", "2025.01.14", "2025.02.11", "2025.03.12"]
TERM = "C:\\Program Files\\BCM Markets MT5 Terminal"


def giorni():
    d = D0
    while d <= D1:
        if d.weekday() != 5:
            yield d
        d += datetime.timedelta(days=1)


def chiave(d):
    return d.strftime("%Y.%m.%d")


def size_bi5(d, h):
    # codifica il giorno nei byte: nessuna lettura di un altro giorno puo' dare la stessa somma per caso
    return 1000 + (d - D0).days * 7 + h


def slot_tipo(h):
    return "assente" if h % 6 == 5 else "bi5"       # ore 5, 11, 17, 23 = .assente (mercato chiuso)


def utf16(s):
    return b"\xff\xfe" + s.encode("utf-16-le")


def default_spec():
    return dict(
        nome="base", macchina="DESKTOP-H4D7CAJ",
        cache="completa",            # completa | assente (nessuna cartella raw) | senza_sim (raw\ senza USA30IDXUSD) | nessuna_lavoro
        buchi={},                    # {"2025.03.12": [3, 4]}  slot senza ne' bi5 ne' .assente
        zeri={},                     # {"2024.12.10": [6]}     bi5 a zero byte
        doppi={},                    # {"2025.01.14": [7]}     bi5 e .assente insieme (h con bi5)
        tmp={},                      # {"2024.11.20": [8]}     file .tmp residuo
        giorno_senza_cartella=[],    # giorni di cui manca la cartella intera
        csv_mesi=["2024-10", "2024-11", "2024-12", "2025-01", "2025-02", "2025-03", "2025-04", "2025-05", "2025-06"],
        csv_righe_base=3,            # righe del primo file; il k-esimo ne ha base + k
        referto_py=True, backup_dir=False, residuo_neg=False, csv_in_files=2, referto_import=True,
        terminale=True, doppio_dati=False, origin_testo=TERM,
        chr=[],                      # lista di dict: nome, ea(bool), illeggibile(bool), expert, symbol, magic
        common_ini="Login=50503392\r\nServer=BCMMarkets-Demo\r\n", logs_conto=True, logs=True,
        nativi_mesi=["202410", "202411", "202412", "202501", "202502", "202503", "202506"], nativi_cartella=True,
        custom_dk=True,
        dischi=[dict(id="C:", size=500 * 2**30, free=250 * 2**30), dict(id="D:", size=900 * 2**30, free=800 * 2**30)],
        python="real",               # real | store | none
        mt5_vivo=False, pin="", sha="",
        altri_simboli=["EURUSD"], fuori_finestra=True, senza_desktop=False,
        decoy_v3=False, csv_stile="lf",   # lf | crlf | lf_senza_finale
    )


def costruisci(base, spec):
    """crea <base>/cdrive e ritorna il percorso. Tutto sotto C:\\Users\\Master e C:\\Program Files (per il terminale)."""
    c = os.path.join(base, "cdrive")
    shutil.rmtree(c, ignore_errors=True)
    os.makedirs(os.path.join(c, "Users", "Master", "Desktop"))
    lavoro = os.path.join(c, "Users", "Master", "dukascopy_lavoro")
    if spec["cache"] != "nessuna_lavoro":
        os.makedirs(lavoro)
    # --- cache raw
    if spec["cache"] in ("completa", "senza_sim"):
        raw = os.path.join(lavoro, "raw")
        os.makedirs(raw, exist_ok=True)
        for s in spec["altri_simboli"]:
            dd, f_ok, _ = DT.percorso_cache(raw, s, datetime.datetime(2025, 6, 16, 15, tzinfo=datetime.timezone.utc))
            os.makedirs(dd, exist_ok=True)
            open(f_ok, "wb").write(b"x" * 50)
    if spec["cache"] == "completa":
        rs = os.path.join(lavoro, "raw", "USA30IDXUSD")
        for d in giorni():
            k = chiave(d)
            if k in spec["giorno_senza_cartella"]:
                continue
            raw_dir = os.path.join(lavoro, "raw")
            dd, _, _ = DT.percorso_cache(raw_dir, "USA30IDXUSD", datetime.datetime(d.year, d.month, d.day, 0, tzinfo=datetime.timezone.utc))
            os.makedirs(dd, exist_ok=True)
            for h in range(24):
                if h in spec["buchi"].get(k, []):
                    continue
                _, f_ok, f_no = DT.percorso_cache(raw_dir, "USA30IDXUSD", datetime.datetime(d.year, d.month, d.day, h, tzinfo=datetime.timezone.utc))
                if h in spec["zeri"].get(k, []):
                    open(f_ok, "wb").close()
                elif slot_tipo(h) == "bi5" or h in spec["doppi"].get(k, []):
                    open(f_ok, "wb").write(b"b" * size_bi5(d, h))
                    if h in spec["doppi"].get(k, []):
                        open(f_no, "wb").close()
                else:
                    open(f_no, "wb").close()
            for h in spec["tmp"].get(k, []):
                open(f_ok.replace("%02dh_" % h, "%02dh_" % h) if False else os.path.join(dd, "%02dh_ticks.bi5.tmp" % h), "wb").write(b"t")
        if spec["fuori_finestra"]:
            for (y, m, g) in ((2024, 9, 30), (2025, 6, 17)):
                for h in (1, 2):
                    dd, f_ok, _ = DT.percorso_cache(os.path.join(lavoro, "raw"), "USA30IDXUSD", datetime.datetime(y, m, g, h, tzinfo=datetime.timezone.utc))
                    os.makedirs(dd, exist_ok=True)
                    open(f_ok, "wb").write(b"f" * 11)
    # --- csv tick
    tick = os.path.join(lavoro, "tick")
    if spec["cache"] != "nessuna_lavoro" and spec["csv_mesi"] is not None:
        os.makedirs(tick, exist_ok=True)
        for k, m in enumerate(spec["csv_mesi"]):
            n = spec["csv_righe_base"] + k
            righe = ["Time,Msec,Bid,Ask"]
            for i in range(n):
                righe.append("%s.%02d 10:%02d:00,%03d,32000.%d,32002.5" % (m.replace("-", "."), 1 + i, i, i, i))
            eol = "\r\n" if spec["csv_stile"] == "crlf" else "\n"
            fine = "" if spec["csv_stile"] == "lf_senza_finale" else eol
            open(os.path.join(tick, "U30USD_DK_ticks_%s.csv" % m), "wb").write((eol.join(righe) + fine).encode("ascii"))
        if spec["referto_py"]:
            open(os.path.join(tick, "referto_dukascopy_tick.txt"), "w").write(
                "=== DUKASCOPY -> TICK CSV: referto ===\nversione: DUKA-TICK-v2\ncomando : --dst usa\nESITO   : OK\nfuso timestamp: server (calendario DST usa -- la sonda decide, criterio congelato)\n")
        if spec["residuo_neg"]:
            open(os.path.join(tick, "U30USD_DKNEG_ticks_2025-03.csv"), "wb").write(b"Time,Msec,Bid,Ask\n")
    if spec["backup_dir"]:
        os.makedirs(os.path.join(lavoro, "tick_0309_backup"))
    # --- terminale e cartella dati
    if spec["terminale"]:
        os.makedirs(os.path.join(c, "Program Files", "BCM Markets MT5 Terminal"))
        open(os.path.join(c, "Program Files", "BCM Markets MT5 Terminal", "terminal64.exe"), "wb").write(b"x")
    ap = os.path.join(c, "Users", "Master", "AppData", "Roaming", "MetaQuotes", "Terminal")
    dati = os.path.join(ap, "ABC123")
    os.makedirs(os.path.join(dati, "MQL5", "Files"))
    open(os.path.join(dati, "origin.txt"), "wb").write(utf16(spec["origin_testo"]))
    other = os.path.join(ap, "ZZZ999", "MQL5")                 # un'altra cartella dati (MANUALE), NON del terminale BCM
    os.makedirs(other)
    open(os.path.join(ap, "ZZZ999", "origin.txt"), "wb").write(utf16("C:\\MT5_MANUALE"))
    if spec["doppio_dati"]:
        os.makedirs(os.path.join(ap, "DDD444", "MQL5"))
        open(os.path.join(ap, "DDD444", "origin.txt"), "wb").write(utf16(spec["origin_testo"]))
    if spec["decoy_v3"]:      # il 100k -V3 (50504263): stesso prefisso, NON e' il terminale ammesso; ha un EA attaccato
        v3 = os.path.join(ap, "VVV555")
        os.makedirs(os.path.join(v3, "MQL5", "Profiles", "Charts", "Default"))
        open(os.path.join(v3, "origin.txt"), "wb").write(utf16(TERM + " -V3"))
        open(os.path.join(v3, "MQL5", "Profiles", "Charts", "Default", "chart01.chr"), "wb").write(
            utf16("<chart>\nsymbol=U30USD\n<window>\n<expert>\nname=ABTG_ORB_V3_DECOY\ninputs\nInpMagic=770202\n</expert>\n</window>\n</chart>\n"))
    cd = os.path.join(dati, "MQL5", "Profiles", "Charts", "Default")
    # un EA attaccato nel terminale MANUALE non deve contare per il BCM
    mcd = os.path.join(ap, "ZZZ999", "MQL5", "Profiles", "Charts", "Default")
    os.makedirs(mcd)
    open(os.path.join(mcd, "chart01.chr"), "wb").write(utf16("<chart>\nsymbol=EURUSD\n<window>\n<expert>\nname=ABTG_MANUALE_X\n</expert>\n</window>\n</chart>\n"))
    if spec["chr"] is not None and len(spec["chr"]) > 0:
        os.makedirs(cd)
        for i, ch in enumerate(spec["chr"]):
            p = os.path.join(cd, "chart%02d.chr" % (i + 1))
            if ch.get("illeggibile"):
                os.symlink("/nonexistent/x.chr", p)
            elif ch.get("ea"):
                open(p, "wb").write(utf16("<chart>\nsymbol=%s\n<window>\n<expert>\nname=%s\ninputs\nInpMagic=%s\n</expert>\n</window>\n</chart>\n" % (ch["symbol"], ch["expert"], ch["magic"])))
            else:
                open(p, "wb").write(utf16("<chart>\nsymbol=U30USD\n</chart>\n"))
    if spec["common_ini"] is not None:
        os.makedirs(os.path.join(dati, "config"))
        open(os.path.join(dati, "config", "common.ini"), "wb").write(utf16("[Common]\r\n" + spec["common_ini"]))
    if spec["logs"]:
        os.makedirs(os.path.join(dati, "logs"))
        t = "0\t10:00:00.000\tNetwork\t'50503392': authorized on BCMMarkets-Demo\r\n" if spec["logs_conto"] else "0\t10:00:00.000\tTerminal\tMetaTrader 5 x64 build\r\n"
        open(os.path.join(dati, "logs", "20261004.log"), "wb").write(utf16(t))
    # --- tick nativi e custom
    if spec["nativi_cartella"]:
        nd = os.path.join(dati, "bases", "BCMMarkets-Demo", "ticks", "U30USD")
        os.makedirs(nd)
        for m in spec["nativi_mesi"]:
            open(os.path.join(nd, m + ".tkc"), "wb").write(b"" if m in spec.get("nativi_zero", []) else b"n" * (100 + int(m[-2:])))   # nativi_zero: .tkc a ZERO BYTE (vuoto o troncato)
    if spec["custom_dk"]:
        cdk = os.path.join(dati, "bases", "Custom", "ticks", "U30USD_DK")
        os.makedirs(cdk)
        open(os.path.join(cdk, "202410.tkc"), "wb").write(b"c" * 77)
    if spec["residuo_neg"]:
        cn = os.path.join(dati, "bases", "Custom", "ticks", "U30USD_DKNEG")
        os.makedirs(cn)
        open(os.path.join(cn, "202503.tkc"), "wb").write(b"z" * 5)
    # MT5 VERO: accanto a ticks\ c'e' SEMPRE history\<SIMBOLO>\AAAA.hcc (barre M1), con lo STESSO nome di cartella.
    # Senza questo il banco non vede la cartella omonima che su un PC vero c'e' (controllo preventivo 05/10, classe 1119).
    if spec.get("history", True) and (spec["nativi_cartella"] or spec["custom_dk"] or spec["residuo_neg"] or spec.get("custom_solo_history")):
        hn = os.path.join(dati, "bases", "BCMMarkets-Demo", "history", "U30USD")
        os.makedirs(hn, exist_ok=True)
        for y in ("2024", "2025"):
            open(os.path.join(hn, y + ".hcc"), "wb").write(b"h" * 33)
        if spec["custom_dk"] or spec.get("custom_solo_history"):
            hc = os.path.join(dati, "bases", "Custom", "history", "U30USD_DK")
            os.makedirs(hc, exist_ok=True)
            open(os.path.join(hc, "2024.hcc"), "wb").write(b"k" * 21)
    ff = os.path.join(dati, "MQL5", "Files")
    for m in (spec["csv_mesi"][:spec["csv_in_files"]] if (spec["csv_mesi"] and spec["cache"] != "nessuna_lavoro") else []):
        shutil.copy(os.path.join(tick, "U30USD_DK_ticks_%s.csv" % m), ff)
    if spec["referto_import"]:
        open(os.path.join(ff, "ABTG_ImportTick_referto.csv"), "w").write("Versione,SimboloDK\nIMP-TICK-v0-BOZZA,U30USD_DK\n")
    os.makedirs(os.path.join(c, "Windows", "System32"), exist_ok=True)
    if spec.get("curl", True):
        open(os.path.join(c, "Windows", "System32", "curl.exe"), "wb").write(b"x")
    if spec["senza_desktop"]:
        shutil.rmtree(os.path.join(c, "Users", "Master", "Desktop"))
    return c


def snapshot(c):
    """percorso relativo -> sha256 per TUTTO il finto C: tranne il Desktop (dove la riga PUO' scrivere)."""
    out = {}
    for rd, dirs, files in os.walk(c):
        rel = os.path.relpath(rd, c)
        if rel.replace(os.sep, "/").startswith("Users/Master/Desktop") or rel.replace(os.sep, "/").startswith("Users/Master/DUKA_P0_"):
            continue
        for d in dirs:
            if rel.replace(os.sep, "/") == "Users/Master" and d.startswith("DUKA_P0_"):
                continue
            out[os.path.join(rel, d) + "/"] = "dir"
        for f in files:
            if rel.replace(os.sep, "/") == "Users/Master" and f.startswith("DUKA_P0_"):
                continue
            p = os.path.join(rd, f)
            if os.path.islink(p):
                out[os.path.join(rel, f)] = "link:" + os.readlink(p)
            else:
                out[os.path.join(rel, f)] = hashlib.sha256(open(p, "rb").read()).hexdigest()
    return out


def attese(spec):
    """tutte le attese, calcolate DALLA SPECIFICA."""
    a = {}
    gg = list(giorni())
    a["giorni"] = len(gg)
    a["slot_attesi"] = len(gg) * 24
    per = {}
    tot = dict(bi5=0, ass=0, zero=0, buchi=0, doppi=0, tmp=0, byte=0, completi=0, senza_cartella=0)
    for d in gg:
        k = chiave(d)
        c = dict(bi5=0, ass=0, zero=0, buchi=0, doppi=0, tmp=0, byte=0)
        if spec["cache"] != "completa" or k in spec["giorno_senza_cartella"]:
            c["buchi"] = 24
            tot["senza_cartella"] += 1
        else:
            for h in range(24):
                if h in spec["buchi"].get(k, []):
                    c["buchi"] += 1
                elif h in spec["zeri"].get(k, []):
                    c["zero"] += 1
                elif h in spec["doppi"].get(k, []):
                    c["bi5"] += 1; c["doppi"] += 1; c["byte"] += size_bi5(d, h)
                elif slot_tipo(h) == "bi5":
                    c["bi5"] += 1; c["byte"] += size_bi5(d, h)
                else:
                    c["ass"] += 1
            c["tmp"] = len(spec["tmp"].get(k, []))
        per[k] = c
        for x in ("bi5", "ass", "zero", "buchi", "doppi", "tmp", "byte"):
            tot[x] += c[x]
        if c["buchi"] == 0 and c["doppi"] == 0:          # gli zero byte NON sono buchi (ora vuota o troncata: indistinguibili)
            tot["completi"] += 1
    a["per"] = per
    a["tot"] = tot
    a["sonda_completi"] = [k for k in SONDA if per[k]["buchi"] == 0 and per[k]["doppi"] == 0]
    csv = []
    tot_r = 0
    for k, m in enumerate(spec["csv_mesi"] or []):
        n = spec["csv_righe_base"] + k
        csv.append((m, n))
        if m not in spec.get("csv_bloccati", []):      # csv_bloccati: CSV di tick\ tenuti aperti in esclusiva da un altro processo (righe NON contate)
            tot_r += n
    a["csv"] = csv
    a["csv_righe"] = tot_r
    a["csv_n"] = len(csv)
    a["chr_letti"] = len(spec["chr"] or [])
    a["chr_ea"] = sum(1 for c in (spec["chr"] or []) if c.get("ea"))
    a["chr_illeggibili"] = sum(1 for c in (spec["chr"] or []) if c.get("illeggibile"))
    return a
