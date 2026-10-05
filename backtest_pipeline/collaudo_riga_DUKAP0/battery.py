#!/usr/bin/env python3
# -*- coding: ascii -*-
"""
battery.py -- batteria di scenari per RIGA_DUKA_P0_CENSIMENTO.ps1 su pwsh 7.4 con finto C:. Ogni scenario costruisce un disco finto da una SPECIFICA e controlla l'uscita
contro le ATTESE CALCOLATE DALLA SPECIFICA (fixture.attese), mai contro un'uscita precedente. Controlli trasversali a ogni scenario: la riga ARRIVA in fondo (nessun `exit`
dentro Invoke-Expression), il finto disco e' IDENTICO prima e dopo fuori dal Desktop (SOLA LETTURA provata, non promessa), nessuna riga di lancio scrive altro, ASCII puro.
Uso: python3 battery.py [--riga FILE] [--solo NOME] [--jobs N] [--primo-rosso]   -> ultima riga "BATTERIA: n/m scenari verdi"
"""
import copy, fcntl, os, re, shutil, sys, tempfile, zipfile
from multiprocessing import Pool
import fixture as F
import run_one as R

QD = os.path.dirname(os.path.abspath(__file__))
TMP = os.environ.get("HARNESS_TMP") or tempfile.mkdtemp(prefix="p0bat_")


def S(**kw):
    s = F.default_spec()
    s.update(kw)
    return s


def scenari():
    sc = []
    sc.append(("01_base_tutto_ok", S(), dict(pin="a" * 40, sha="B" * 64)))
    sc.append(("02_macchina_vps", S(macchina="VMI3047753"), {}))
    sc.append(("02b_macchina_minuscola", S(macchina="desktop-h4d7caj"), {}))
    sc.append(("02c_macchina_quasi", S(macchina="DESKTOP-H4D7CAJ2"), {}))
    sc.append(("03_cache_assente", S(cache="senza_sim"), {}))
    sc.append(("03b_nessuna_cartella_lavoro", S(cache="nessuna_lavoro"), {}))
    sc.append(("04_buchi_zeri_doppi", S(buchi={"2025.03.12": [3, 4], "2024.11.20": [0], "2025.03.25": [5]}, zeri={"2024.12.10": [6]}, doppi={"2025.01.14": [7]},
                                         tmp={"2024.11.20": [8]}, giorno_senza_cartella=["2025.02.11"]), {}))
    sc.append(("05_disco_pieno", S(dischi=[dict(id="C:", size=500 * 2**30, free=5 * 2**30), dict(id="D:", size=900 * 2**30, free=800 * 2**30)]), {}))
    sc.append(("05b_senza_disco_C", S(dischi=[dict(id="D:", size=900 * 2**30, free=800 * 2**30)]), {}))
    sc.append(("05c_cim_fallisce", S(), dict(extra_env={"CIM_FALLISCE": "1"})))
    sc.append(("06_mt5_vivo", S(mt5_vivo=True), {}))
    sc.append(("07_sedie_attaccate", S(chr=[dict(ea=True, symbol="U30USD", expert="ABTG_EMA200_\u00e8", magic="771531"), dict(ea=True, symbol="EURUSD", expert="ABTG_PTE", magic="770999"),
                                              dict(), dict(illeggibile=True)]), {}))
    sc.append(("07b_grafici_senza_ea", S(chr=[dict()]), {}))
    sc.append(("08_decoy_v3", S(decoy_v3=True), {}))
    sc.append(("09_due_cartelle_dati", S(doppio_dati=True), {}))
    sc.append(("10_origin_altro_terminale", S(origin_testo="C:\\MT5_Backtest"), {}))
    sc.append(("11_senza_ini_senza_log", S(common_ini=None, logs=False), {}))
    sc.append(("11b_conti_discordanti", S(common_ini="Login=50504263\r\nServer=X\r\n"), {}))
    sc.append(("11c_log_senza_conto", S(logs_conto=False), {}))
    sc.append(("12_residuo_dkneg", S(residuo_neg=True, backup_dir=True), {}))
    sc.append(("13_python_store", S(python="store"), {}))
    sc.append(("13b_python_assente", S(python="none", curl=False), {}))
    sc.append(("14_senza_desktop", S(senza_desktop=True), {}))
    sc.append(("15_csv_crlf", S(csv_stile="crlf"), {}))
    sc.append(("15b_csv_senza_finale", S(csv_stile="lf_senza_finale"), {}))
    sc.append(("15c_zero_csv", S(csv_mesi=[]), {}))
    sc.append(("16_senza_nativi_ne_custom", S(nativi_cartella=False, custom_dk=False, referto_py=False, referto_import=False), {}))
    sc.append(("16b_nativi_parziali", S(nativi_mesi=["202411", "202503"]), {}))
    # classe 1119: history\U30USD (barre M1) c'e' sempre su un MT5 vero; non deve passare per la cartella dei tick nativi, ne' history\U30USD_DK per il custom con tick
    sc.append(("16c_solo_history_nativa", S(nativi_cartella=False, custom_dk=True), {}))
    sc.append(("16d_custom_solo_history", S(custom_dk=False, custom_solo_history=True), {}))
    # .tkc a ZERO BYTE (vuoto o troncato, checklist 16): elencato ma NON contato come mese presente (contro-esempio del verificatore-stringhe, 05/10)
    sc.append(("16e_tkc_zero_byte", S(nativi_zero=["202411", "202503"]), {}))
    # MaxBars: tetto basso (classe 160 / checklist 36) e chiave assente
    sc.append(("17_maxbars_basso", S(common_ini="Login=50503392\r\nServer=BCMMarkets-Demo\r\n[Charts]\r\nMaxBars=100000\r\n"), {}))
    # CSV bloccato da un altro processo (contro-esempio del verificatore-stringhe, 05/10, terza lettura): prima il passo moriva a meta' e la sintesi diceva
    # "2 file, 7 righe [MISURATO]" su 9 file. Ora: il file si conta, le righe no, gli altri si contano, la sintesi dice PARZIALE. Anche la copia in MQL5\Files.
    sc.append(("18_csv_bloccato", S(csv_bloccati=["2024-12"], files_bloccati=["2024-10"]), {}))
    sc.append(("17b_maxbars_alto", S(common_ini="Login=50503392\r\nServer=BCMMarkets-Demo\r\n[Charts]\r\nMaxBars=2000000000\r\n"), {}))
    return sc


def runna(nome, spec, opz, riga):
    b = tempfile.mkdtemp(prefix="s_", dir=TMP)
    try:
        c = F.costruisci(b, spec)
        prima = F.snapshot(c)
        # file tenuti aperti in ESCLUSIVA durante la corsa (flock LOCK_EX: .NET su Linux lo rispetta e FileShare.ReadWrite fallisce come su Windows)
        blocchi = []
        for m in spec.get("csv_bloccati", []):
            blocchi.append(os.open(os.path.join(c, "Users", "Master", "dukascopy_lavoro", "tick", "U30USD_DK_ticks_%s.csv" % m), os.O_RDONLY))
        for m in spec.get("files_bloccati", []):
            blocchi.append(os.open(os.path.join(c, "Users", "Master", "AppData", "Roaming", "MetaQuotes", "Terminal", "ABC123", "MQL5", "Files", "U30USD_DK_ticks_%s.csv" % m), os.O_RDONLY))
        for fd in blocchi:
            fcntl.flock(fd, fcntl.LOCK_EX)
        try:
            r = R.esegui(spec, c, riga=riga, **opz)
        finally:
            for fd in blocchi:
                os.close(fd)
        dopo = F.snapshot(c)
        z = []
        for zz in r["zips"]:
            p = os.path.join(r["desk"], zz)
            z.append((zz, sorted(os.path.basename(n) for n in zipfile.ZipFile(p).namelist()), os.path.getmtime(p)))
        cache_csv = ""
        for cd in r["cartelle"]:
            f = os.path.join(r["desk"], cd, "P0_CACHE_PER_GIORNO.csv")
            if os.path.exists(f):
                cache_csv = open(f).read()
        tick_csv = ""
        for cd in r["cartelle"]:
            f = os.path.join(r["desk"], cd, "P0_CSV_TICK.csv")
            if os.path.exists(f):
                tick_csv = open(f).read()
        return nome, valuta(nome, spec, r, prima, dopo, z, cache_csv, tick_csv)
    finally:
        shutil.rmtree(b, ignore_errors=True)


def valuta(nome, spec, r, prima, dopo, zips, cache_csv, tick_csv):
    out = r["stdout"]
    ref = r["referto"]
    err = []
    a = F.attese(spec)

    def must(s, dove=None, perche=""):
        t = out if dove is None else dove
        if s not in t:
            err.append("MANCA: " + s + ("  (" + perche + ")" if perche else ""))

    def mustnot(s, dove=None, perche=""):
        t = out if dove is None else dove
        if s in t:
            err.append("NON DOVREBBE ESSERCI: " + s + ("  (" + perche + ")" if perche else ""))

    def rx(p, perche=""):
        if not re.search(p, out):
            err.append("REGEX NON TROVATA: " + p + ("  (" + perche + ")" if perche else ""))

    # --- trasversali -----------------------------------------------------
    if prima != dopo:
        dif = sorted(set(prima) ^ set(dopo))[:5] + [k for k in prima if k in dopo and prima[k] != dopo[k]][:5]
        err.append("SOLA LETTURA VIOLATA: il disco finto e' cambiato fuori dal Desktop: " + str(dif))
    if any(ord(ch) > 126 for ch in out):
        err.append("l'uscita non e' ASCII puro")
    blocco = nome.startswith("02")
    stop_macchina = nome in ("02_macchina_vps", "02c_macchina_quasi")
    if stop_macchina:
        must("QUESTA RIGA GIRA SOLO SUL PC DI BACKTEST DESKTOP-H4D7CAJ", out + r["stderr"])
        if r["cartelle"] or r["zips"]:
            err.append("la guardia macchina e' scattata MA ha scritto sul Desktop: " + str(r["cartelle"] + r["zips"]))
        mustnot("=== 1. MACCHINA E UTENTE", None, "la guardia deve fermare PRIMA di leggere")
        mustnot("FINE-HARNESS-ARRIVATO")
        return err
    must("FINE-HARNESS-ARRIVATO", None, "la riga e' arrivata in fondo: nessun exit dentro Invoke-Expression")
    if spec["senza_desktop"] and r["desk"].endswith("Desktop"):
        err.append("senza Desktop la riga doveva ripiegare su USERPROFILE, non crearsi un Desktop")
    if not spec["senza_desktop"] and not r["desk"].endswith("Desktop"):
        err.append("con il Desktop presente l'output doveva stare li'")
    # raccolta
    if len(r["cartelle"]) != 1 or len(r["zips"]) != 1:
        err.append("attesi 1 cartella e 1 zip, trovati %s / %s" % (r["cartelle"], r["zips"]))
    else:
        zn, entries, mt = zips[0]
        if entries != sorted(["REFERTO_DUKA_P0.txt", "P0_CACHE_PER_GIORNO.csv", "P0_CSV_TICK.csv"]):
            err.append("contenuto dello zip diverso: %s" % entries)
        must("FILE PRESENTI NELLO ZIP (letti dallo zip, non dal piano): P0_CACHE_PER_GIORNO.csv, P0_CSV_TICK.csv, REFERTO_DUKA_P0.txt")
        must("MANCANTI: nessuno   (lo zip porta nel nome l ora di avvio al secondo")
        if zn != r["cartelle"][0] + ".zip":
            err.append("nome zip != nome cartella")
    if not ref:
        err.append("referto assente nella cartella")
    else:
        if "SINTESI DI P0" not in ref or "FILE ATTESI" in ref:
            err.append("il referto deve contenere la SINTESI (la raccolta sta solo in console)")
    # --- pin / sha --------------------------------------------------------
    if nome == "01_base_tutto_ok":
        must("pin riga ..... " + "a" * 40)
        must("sha256 riga .. " + "B" * 64)
    else:
        must("pin riga ..... non dichiarato (script lanciato senza bootstrap)")
        must("sha256 riga .. non dichiarata")
    # --- macchina ---------------------------------------------------------
    must("nome macchina ..... " + spec["macchina"] + "   (ammessa: DESKTOP-H4D7CAJ)")
    # --- cache ------------------------------------------------------------
    t = a["tot"]
    if spec["cache"] == "completa":
        must("giorni attesi (sabati esclusi): %d   (il piano dice 222)   slot orari attesi: %d" % (a["giorni"], a["slot_attesi"]))
        must("giorni con cartella: %d   senza cartella: %d" % (a["giorni"] - t["senza_cartella"], t["senza_cartella"]))
        must("giorni COMPLETI (24 slot ciascuno col suo file, nessun buco, nessun doppio; gli zero byte NON sono buchi): %d su %d" % (t["completi"], a["giorni"]))
        must("slot: bi5 con byte %d | .assente %d | bi5 a ZERO BYTE (ora vuota o troncata: indistinguibili) %d | BUCHI (ne bi5 ne .assente) %d | DOPPI (bi5 e .assente) %d | .tmp residui %d"
             % (t["bi5"], t["ass"], t["zero"], t["buchi"], t["doppi"], t["tmp"]))
        must("byte dei .bi5 nella finestra: %d  (" % t["byte"])
        # albero: tutti i file sotto USA30IDXUSD = bi5 + zeri + assenti + .assente dei doppi + tmp + 4 fuori finestra
        n_alb = t["bi5"] + t["zero"] + t["ass"] + t["doppi"] + t["tmp"] + (4 if spec["fuori_finestra"] else 0)
        b_alb = t["byte"] + (44 if spec["fuori_finestra"] else 0) + t["tmp"]
        must("albero USA30IDXUSD: %d file, %d byte" % (n_alb, b_alb))
        must("fuori dai 222 giorni: %d file" % (4 if spec["fuori_finestra"] else 0))
        must("cache 222 giorni : completi %d su %d  (buchi %d, doppi %d; ore a zero byte %d: vuote o troncate, indistinguibili) [MISURATO]" % (t["completi"], a["giorni"], t["buchi"], t["doppi"], t["zero"]))
        rx(r"esempi di percorso nell albero \(primi 5, relativi a USA30IDXUSD[^)]*\): (\d{4}\\\d{2}\\\d{2}\\\d{2}h_ticks\.bi5(\.assente)?( \| )?){5}", "5 percorsi di esempio col layout vero")
        for k in F.SONDA:
            c = a["per"][k]
            ok = c["buchi"] == 0 and c["doppi"] == 0
            mark = "*" if k in F.NUOVI else " "
            must("  %s %s  bi5 %d  assenti %d  zero %d  buchi %d  doppi %d   -> %s" % (mark, k, c["bi5"], c["ass"], c["zero"], c["buchi"], c["doppi"], "COMPLETO in cache" if ok else "NON COMPLETO"))
        must("giorni della sonda completi in cache : %d su 9 [MISURATO]" % len(a["sonda_completi"]))
        manc = [k for k in F.SONDA if k not in a["sonda_completi"]]
        must("mancanti: " + (" ".join(manc) if manc else "nessuno"))
        # CSV per giorno: una riga per ciascuno dei 222 giorni, valori dalla specifica
        righe = cache_csv.strip().splitlines()
        if len(righe) != a["giorni"] + 1:
            err.append("P0_CACHE_PER_GIORNO.csv: %d righe invece di %d" % (len(righe), a["giorni"] + 1))
        else:
            d = {x.split(",")[0]: x.split(",") for x in righe[1:]}
            for k, c in a["per"].items():
                v = d.get(k)
                exp = [k, str(spec["giorno_senza_cartella"].count(k) == 0), str(c["bi5"]), str(c["zero"]), str(c["ass"]), str(c["buchi"]), str(c["doppi"]), str(c["tmp"]), str(c["byte"])]
                if v != exp:
                    err.append("riga CSV cache %s: %s invece di %s" % (k, v, exp)); break
        if spec["zeri"]:
            must("giorni con ore a ZERO BYTE: %d" % len(spec["zeri"]))
            for k, ore in spec["zeri"].items():
                must("   " + k + " [" + " ".join("%02dh" % h for h in ore) + "]")
        else:
            mustnot("giorni con ore a ZERO BYTE")
        if t["completi"] != a["giorni"]:
            must("giorni NON completi: %d" % (a["giorni"] - t["completi"]))
            for k, ore in list(spec["buchi"].items()):
                must(k + " [" + " ".join("%02dh" % h for h in ore))
            for k, ore in spec["zeri"].items():
                must(k + " [" + " ".join("%02dh" % h for h in ore) + "]", None, "gli zero byte stanno nella lista a parte")
            for k in spec["giorno_senza_cartella"]:
                must(k + " [" + " ".join("%02dh" % h for h in range(24)) + "]")
            for k, ore in spec["doppi"].items():
                must(k + " [" + " ".join("%02dh=DOPPIO" % h for h in ore) + "] DOPPI=%d" % len(ore))
        else:
            mustnot("giorni NON completi")
    else:
        if spec["cache"] in ("senza_sim", "nessuna_lavoro"):
            must("CACHE ASSENTE: se la cache non c e, P1 diventa un RISCARICO")
            if spec["cache"] == "senza_sim":
                must("cartelle in dukascopy_lavoro (dove sta la cache, se non e qui?): raw, tick")
            must("cache raw\\USA30IDXUSD : ASSENTE [MISURATO]  -> STOP di P0")
            mustnot("giorni COMPLETI")
    # --- dischi -----------------------------------------------------------
    if nome == "05c_cim_fallisce":
        must('passo "dischi" FALLITO: CIM non disponibile (banco)')
        must("spazio libero su dukascopy_lavoro : [NON MISURATO]")
        must("ESITO P0: CENSIMENTO PARZIALE (1 passi falliti")
        must("PASSI FALLITI: 1")
    else:
        for d in spec["dischi"]:
            must("  %s  totale %.2f GB   LIBERO %.2f GB   (%d byte)" % (d["id"], d["size"] / 2**30, d["free"] / 2**30, d["free"]))
        cdisk = [d for d in spec["dischi"] if d["id"] == "C:"]
        if cdisk:
            g = cdisk[0]["free"] / 2**30
            must("disco di dukascopy_lavoro (C:): LIBERO %.2f GB" % g)
            must("spazio libero su dukascopy_lavoro : %.2f GB [MISURATO]   (soglia F1 non firmata 12 GB: %s)" % (g, "raggiunta" if g >= 12 else "NON raggiunta"))
            must("-> per F1: la condizione di disco di F1 %s" % ("(almeno 12 GB liberi) e soddisfatta" if g >= 12 else "NON e soddisfatta"))
            must("disco dei dati MT5 (APPDATA, dove finisce la base tick del custom, ~2,6 GB del nucleo): lo STESSO di dukascopy_lavoro (C:)")
        else:
            must("disco di dukascopy_lavoro: lettera \"C:\" NON trovata fra i dischi letti -> NON MISURATO")
            must("spazio libero su dukascopy_lavoro : [NON MISURATO]   -> per F1: senza questo numero il tetto di 12 GB non si firma")
            must("disco dei dati MT5 (APPDATA, dove finisce la base tick del custom, ~2,6 GB del nucleo): C: NON trovato fra i dischi letti -> NON MISURATO")
    must("tetto di 250 ore di F1 : NON lo misura P0")
    # --- csv --------------------------------------------------------------
    bcm_n = 2 if spec["doppio_dati"] else (1 if spec["origin_testo"] == F.TERM else 0)
    if spec["cache"] != "nessuna_lavoro":
        must("CSV in tick\\ : %d" % a["csv_n"])
        blo = spec.get("csv_bloccati", [])
        for (m, n) in a["csv"]:
            giorno_ult = 1 + n - 1
            primo = m.replace("-", ".") + ".01 10:00:00"
            ult = "%s.%02d 10:%02d:00" % (m.replace("-", "."), giorno_ult, n - 1)
            if m in blo:
                rx(r"U30USD_DK_ticks_%s\.csv  \d+ byte \([\d.]+ MB\)  scritto [\d\- :]+  righe NON MISURATE \(file non apribile: " % re.escape(m), "CSV bloccato %s: contato, righe NON MISURATE" % m)
                must("csv tick, U30USD_DK_ticks_%s.csv: righe NON MISURATE (file non apribile)" % m)
                continue
            rx(r"U30USD_DK_ticks_%s\.csv  \d+ byte \([\d.]+ MB\)  scritto [\d\- :]+  righe %d  primo %s  ultimo %s" % (re.escape(m), n, re.escape(primo), re.escape(ult)), "righe/primo/ultimo del CSV %s" % m)
        if blo:
            must("totale tick\\ : %d file, %d righe (SENZA le righe di %d file non apribili), " % (a["csv_n"], a["csv_righe"], len(blo)))
            must("CSV U30USD_DK in tick\\ : %d file, %d righe [PARZIALE: righe di %d file NON contate, file non apribili]" % (a["csv_n"], a["csv_righe"], len(blo)))
            mustnot("CSV U30USD_DK in tick\\ : %d file, %d righe [MISURATO]" % (a["csv_n"], a["csv_righe"]), None, "un CSV non letto NON e' una misura completa")
            # i CSV DOPO quello bloccato sono stati contati (il passo non muore a meta')
            mustnot('passo "csv tick" FALLITO')
        else:
            must("totale tick\\ : %d file, %d righe, " % (a["csv_n"], a["csv_righe"]))
            must("CSV U30USD_DK in tick\\ : %d file, %d righe [MISURATO]" % (a["csv_n"], a["csv_righe"]))
        if spec["referto_py"] and spec["csv_mesi"] is not None:
            must("   | comando : --dst usa")
        if spec["csv_mesi"] is not None and not spec["referto_py"]:
            must("referto_dukascopy_tick.txt: NON presente in tick\\")
        if spec["residuo_neg"]:
            must("residui DKNEG in tick\\ : U30USD_DKNEG_ticks_2025-03.csv")
        else:
            must("residui DKNEG in tick\\ : nessuno")
        if spec["backup_dir"]:
            must("cartelle di backup / tick_* in dukascopy_lavoro : tick_0309_backup")
        else:
            must("cartelle di backup / tick_* in dukascopy_lavoro : nessuna")
        # CSV del P0_CSV_TICK: una riga per CSV di tick\ + una per ogni copia in MQL5\Files
        rr = tick_csv.strip().splitlines()
        n_f = min(spec["csv_in_files"], a["csv_n"]) if bcm_n >= 1 else 0
        if len(rr) != 1 + a["csv_n"] + n_f:
            err.append("P0_CSV_TICK.csv: %d righe invece di %d" % (len(rr), 1 + a["csv_n"] + n_f))
        else:
            for k, (m, n) in enumerate(a["csv"]):
                atteso_r = "NON_MISURATO" if m in spec.get("csv_bloccati", []) else str(n)
                if not rr[1 + k].startswith("tick,U30USD_DK_ticks_%s.csv," % m) or ("," + atteso_r + ",") not in rr[1 + k]:
                    err.append("riga CSV tick %s: %s" % (m, rr[1 + k])); break
    else:
        must("cartella " )
        mustnot("CSV in tick\\ :")
    # --- terminale e dati -------------------------------------------------
    bcm = 1 if spec["origin_testo"] == F.TERM else 0
    if spec["doppio_dati"]:
        bcm = 2
    must("cartelle dati del terminale C:\\Program Files\\BCM Markets MT5 Terminal : %d" % bcm)
    if bcm != 1:
        must("ATTESA UNA SOLA cartella dati per il terminale BCM")
    if bcm >= 1:
        must("   dati ABC123   programma: C:\\Program Files\\BCM Markets MT5 Terminal\n", None, "senza il BOM (U+FEFF) davanti: Pulisci lo mostrerebbe come ?")
    mustnot("ABTG_MANUALE_X", None, "l'EA del terminale MANUALE non e' del BCM")
    mustnot("ABTG_ORB_V3_DECOY", None, "il 100k -V3 non e' il terminale ammesso")
    if bcm == 0:
        must("nessuna cartella dati del terminale BCM: tick nativi e custom NON MISURATI")
    # conto
    if bcm >= 1:
        if spec["common_ini"] is None:
            must("config\\common.ini : assente")
        else:
            lg = re.search(r"Login=(\d+)", spec["common_ini"]).group(1)
            must("conto da config\\common.ini : " + lg)
            mb = re.search(r"MaxBars=(\d+)", spec["common_ini"])
            if mb:
                must("MaxBars da config\\common.ini : " + mb.group(1))
                must("MaxBars (config\\common.ini) : " + mb.group(1) + " [MISURATO]")
                if int(mb.group(1)) < 200000:
                    must("tetto BASSO, il tester girerebbe su meno storico")
                else:
                    mustnot("tetto BASSO")
            else:
                must("MaxBars da config\\common.ini : chiave NON trovata")
                must("MaxBars : [NON MISURATO]")
        if not spec["logs"]:
            must("logs\\ : assente")
        elif spec["logs_conto"]:
            must("conto dal giornale (logs\\) : 50503392")
        else:
            must("conto dal giornale (logs\\) : NON TROVATO")
        if spec["common_ini"] and "50504263" in spec["common_ini"] and spec["logs"] and spec["logs_conto"]:
            must("ATTENZIONE: il Login di common.ini NON e fra i conti dei giornali")
    # chr
    if bcm == 1:
        must("grafici .chr letti: %d   con un EA attaccato: %d   illeggibili: %d" % (a["chr_letti"], a["chr_ea"], a["chr_illeggibili"]))
        if a["chr_letti"] == 0:
            must("ZERO grafici letti: NON VERIFICABILE")
            must("sedie attaccate (dai .chr salvati) : NON VERIFICABILE (zero grafici letti) [NON MISURATO]")
        else:
            must("sedie attaccate (dai .chr salvati) : %d grafici con EA, %d illeggibili [MISURATO]" % (a["chr_ea"], a["chr_illeggibili"]))
            mustnot("ZERO grafici letti")
        for ch in spec["chr"]:
            if ch.get("ea"):
                rx(r"EA ATTACCATO: Default\\chart\d\d\.chr   %s   %s   magic %s" % (re.escape(ch["expert"].encode("ascii", "replace").decode()), ch["symbol"], ch["magic"]), "il nome non-ASCII esce come ? (Pulisci)")
        if a["chr_illeggibili"]:
            must("ILLEGGIBILE: non verificabile, conta come EA possibile")
    # nativi
    if bcm == 1:
        if spec["nativi_cartella"]:
            zz = [m for m in spec["nativi_mesi"] if m in ("202410", "202411", "202412", "202501", "202502", "202503", "202506") and m in spec.get("nativi_zero", [])]
            gi = [m for m in spec["nativi_mesi"] if m in ("202410", "202411", "202412", "202501", "202502", "202503", "202506") and m not in zz]
            must("tick nativi U30USD sotto bases\\ : cartelle 1, mesi della sonda con file %d su 7 (presenza del mese, NON del giorno 2024.11.20; file a zero byte NON contati: %d)" % (len(gi), len(zz)))
            for m in gi:
                must("        %s.tkc  %d byte" % (m, 100 + int(m[-2:])))
            for m in zz:
                must("        %s.tkc  0 byte" % m)
            if out.count("file a ZERO BYTE (vuoto o troncato): NON contato come presente") != len(zz):
                err.append("mesi a zero byte marcati %d invece di %d" % (out.count("file a ZERO BYTE (vuoto o troncato): NON contato come presente"), len(zz)))
            n_marc = len(re.findall(r"<-- mese di un giorno della sonda\r?$", out, re.M))
            if n_marc != len(gi):
                err.append("mesi marcati %d invece di %d" % (n_marc, len(gi)))
        elif spec["custom_dk"] or spec["residuo_neg"]:
            must("cartella dei tick NATIVI U30USD: NON TROVATA sotto bases\\")
        if spec["nativi_cartella"] or spec["custom_dk"] or spec["residuo_neg"] or spec.get("custom_solo_history"):
            must("custom U30USD_DK presente: %s" % ("True" if spec["custom_dk"] else "False"))
            if spec["residuo_neg"]:
                must("residui U30USD_DKNEG: PRESENTI")
            else:
                must("residui U30USD_DKNEG: nessuno")
        else:
            must("bases\\ ASSENTE: tick nativi di U30USD e custom U30USD_DK NON MISURATI")
            must("tick nativi U30USD : [NON MISURATO]")
        # MQL5\Files
        nff = (min(spec["csv_in_files"], len(spec["csv_mesi"])) if (spec["csv_mesi"] and spec["cache"] != "nessuna_lavoro") else 0) + (1 if spec["referto_import"] else 0)
        must("MQL5\\Files: %d file U30USD_DK* / ABTG_ImportTick*" % nff)
        for m in spec.get("files_bloccati", []):
            must("MQL5 Files, U30USD_DK_ticks_%s.csv: righe NON MISURATE (file non apribile)" % m)
            rx(r"U30USD_DK_ticks_%s\.csv  \d+ byte  scritto [\d\- :]+  righe NON MISURATE \(file non apribile: " % re.escape(m), "copia in MQL5\\Files bloccata")
            if "MQL5Files,U30USD_DK_ticks_%s.csv," % m not in tick_csv or ",NON_MISURATO," not in tick_csv:
                err.append("P0_CSV_TICK.csv: manca la riga NON_MISURATO della copia bloccata %s" % m)
        for m in [x for x in (spec["csv_mesi"] or [])[:spec["csv_in_files"]] if x not in spec.get("files_bloccati", [])]:
            if spec.get("files_bloccati"):
                rx(r"U30USD_DK_ticks_%s\.csv  \d+ byte  scritto [\d\- :]+  righe \d+\n" % re.escape(m), "le copie NON bloccate in MQL5\\Files si contano lo stesso")
        mustnot('passo "MQL5 Files" FALLITO')
    # processi
    if spec["mt5_vivo"]:
        must("MT5 (terminal64) APERTO: True")
        must("MT5 aperto : True [MISURATO]")
        rx(r"PID \d+  terminal64")
    else:
        must("MT5 (terminal64) APERTO: False")
    # python / curl
    if spec["python"] == "real":
        must("   python.exe  C:\\Users\\Master\\AppData\\Local\\Programs\\Python\\Python312\\python.exe")
        mustnot("ALIAS DELLO STORE")
    elif spec["python"] == "store":
        must("<-- ALIAS DELLO STORE: non e un python vero")
    else:
        must("python / py: NON trovati nel PATH")
    must("curl.exe in System32: %s" % ("True" if spec.get("curl", True) else "False"))
    # esito
    nblo = len(spec.get("csv_bloccati", [])) + len(spec.get("files_bloccati", []))
    if nblo:
        must("ESITO P0: CENSIMENTO PARZIALE (%d passi falliti, vedi sopra)" % nblo)
        must("PASSI FALLITI: %d" % nblo)
    elif nome != "05c_cim_fallisce":
        must("ESITO P0: CENSIMENTO COMPLETO (solo lettura)")
        mustnot("PASSI FALLITI")
    return err


def main():
    riga = None; solo = None; jobs = 4; primo = False
    av = sys.argv[1:]
    if "--riga" in av: riga = os.path.abspath(av[av.index("--riga") + 1])
    if "--solo" in av: solo = av[av.index("--solo") + 1]
    if "--jobs" in av: jobs = int(av[av.index("--jobs") + 1])
    primo = "--primo-rosso" in av
    sc = [s for s in scenari() if (solo is None or solo in s[0])]
    par = [(n, s, o, riga) for (n, s, o) in sc if not s["mt5_vivo"]]
    ser = [(n, s, o, riga) for (n, s, o) in sc if s["mt5_vivo"]]
    with Pool(jobs) as p:
        res = p.starmap(runna, par)
    for x in ser:      # DOPO il pool: il terminal64 finto e' visibile a tutta la macchina
        res.append(runna(*x))
    verdi = 0
    for nome, err in res:
        if not err:
            verdi += 1
        else:
            print("ROSSO %s" % nome)
            for e in err[:6]:
                print("     - " + e[:300])
            if primo: break
    print("BATTERIA: %d/%d scenari verdi" % (verdi, len(res)))
    return 0 if verdi == len(res) else 1


if __name__ == "__main__":
    sys.exit(main())
