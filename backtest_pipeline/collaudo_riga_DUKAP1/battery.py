#!/usr/bin/env python3
# -*- coding: ascii -*-
"""
battery.py -- batteria di scenari per RIGA_DUKA_P1_OROLOGIO.ps1 (con la figlia RIGA_DUKA_IMPORT_SONDA.ps1 v2 e il valutatore leggi_f2_dk.py DAVVERO eseguiti; il terminale e' il solo finto, sim_mt5.py).
Le attese sono scritte per scenario PRIMA di leggere l'uscita e usano grandezze indipendenti: gli HASH dei CSV "fisso" e "usa" sono prodotti da un'esecuzione SEPARATA del tool vero su una copia della cache,
mai riletti dall'uscita della riga. Controlli trasversali: la riga arriva in fondo con il codice d'uscita atteso; tutto cio' che sta FUORI da Desktop / abtg_duka_p1 / dukascopy_lavoro / MQL5 del terminale
BCM e' IDENTICO prima e dopo (altri terminali, Program Files, altre cartelle dati); l'uscita e' ASCII; la cartella DUKA_P1_* e il suo zip esistono SEMPRE (anche dopo un gate) e lo zip contiene il referto.
Uso: python3 battery.py [--solo NOME] [--jobs N] [--riga FILE]   -> ultima riga "BATTERIA P1: n/m scenari verdi"
"""
import hashlib, os, re, shutil, subprocess, sys, tempfile, zipfile
from multiprocessing import Pool
import h1

QD = os.path.dirname(os.path.abspath(__file__))
TMP = os.environ.get("HARNESS_TMP") or tempfile.mkdtemp(prefix="p1bat_")
RIGA_DEF = os.path.join(h1.REPO, "backtest_pipeline", "righe", "RIGA_DUKA_P1_OROLOGIO.ps1")


def hashes_tool(dst):
    """gli hash dei 9 CSV prodotti dal tool VERO con --dst <dst> sulla cache sintetica base (esecuzione separata, mai la riga sotto esame)"""
    b = tempfile.mkdtemp(prefix="ref_", dir=TMP)
    try:
        spec = h1.spec_base(stato_tick="usa" if dst == "usa" else "fisso")
        c = h1.costruisci(b, spec)
        return h1.tree_hash(os.path.join(c, "Users", "Master", "dukascopy_lavoro", "tick"), lambda f: f.endswith(".csv"))
    finally:
        shutil.rmtree(b, ignore_errors=True)


def S(**kw):
    return h1.spec_base(**kw)


def scenari():
    sc = []
    sc.append(("01_F2_passa", S(), dict(exit=0, esito="PASSA")))
    sc.append(("02_importer_8su8_con_2024_11_20_non_confrontabile", S(scen_dk={**{g: ["MISURATO", "0.03", "99.0"] for g in h1.GIORNI9}, "2024.11.20": ["NON_CONFRONTABILE"]}), dict(exit=0, esito="NON PASSA", figlia_dk_rc=4)))
    sc.append(("03_negativo_cieco_0_045", S(scen_neg={"2025.03.12": ["MISURATO", "0.045", "95.0"]}), dict(exit=0, esito="NON PASSA")))
    sc.append(("04_negativo_non_confrontabile", S(scen_neg={"2025.03.12": ["NON_CONFRONTABILE"]}), dict(exit=0, esito="NON PASSA")))
    sc.append(("05_giorno_fuori_soglia", S(scen_dk={**{g: ["MISURATO", "0.03", "99.0"] for g in h1.GIORNI9}, "2024.12.10": ["MISURATO", "0.07", "99.0"]}), dict(exit=0, esito="NON PASSA")))
    sc.append(("06_copertura_79_99", S(scen_dk={**{g: ["MISURATO", "0.03", "99.0"] for g in h1.GIORNI9}, "2024.10.31": ["MISURATO", "0.01", "79.99"]}), dict(exit=0, esito="NON PASSA")))
    sc.append(("07_neg_scritto_col_simbolo_DK", S(righe_grezze={"U30USD_DKNEG": [["IMP-TICK-v1-GIORNI", "U30USD_DK", "2025.03.12", "MISURATO", "0.09000000", "95.0000", "1", "1", "1", "1", "0.05000000", "80.0000", "NO"]]}), dict(exit=0, esito="NON PASSA")))
    sc.append(("08_giro_a_vuoto", S(solo_controllo=True), dict(exit=0, esito=None, vuoto=True)))
    sc.append(("09_macchina_vps", S(macchina="VMI3047753"), dict(exit=None, macchina=True)))
    sc.append(("10_mt5_vivo", S(mt5_vivo=True), dict(exit=1, fermata="A", prima_di_toccare=True)))
    sc.append(("11_EA_attaccato", S(chr=[{}, dict(ea="ABTG_EMA200")]), dict(exit=1, fermata="A", prima_di_toccare=True)))
    sc.append(("12_zero_grafici", S(chr=[]), dict(exit=1, fermata="A", prima_di_toccare=True)))
    sc.append(("13_grafico_illeggibile", S(chr=[{}, dict(illeggibile=True)]), dict(exit=1, fermata="A", prima_di_toccare=True)))
    sc.append(("14_due_cartelle_dati", S(doppio_dati=True), dict(exit=1, fermata="A", prima_di_toccare=True)))
    sc.append(("15_python_store", S(python="store"), dict(exit=1, fermata="A", prima_di_toccare=True)))
    sc.append(("16_python_assente", S(python="none"), dict(exit=1, fermata="A", prima_di_toccare=True)))
    sc.append(("17_impronta_py_sbagliata", S(sha_sbagliato="py"), dict(exit=1, fermata="B", prima_di_toccare=True)))
    sc.append(("17b_impronta_f2_sbagliata", S(sha_sbagliato="f2"), dict(exit=1, fermata="B", prima_di_toccare=True)))
    sc.append(("17c_impronta_imp_sbagliata", S(sha_sbagliato="imp"), dict(exit=1, fermata="B", prima_di_toccare=True)))
    sc.append(("17d_py_senza_marcatore", S(muta_py="py_senza_marcatore"), dict(exit=1, fermata="B", prima_di_toccare=True)))
    sc.append(("18_cache_con_un_buco", S(buchi=[("2025.03.12", 5)]), dict(exit=1, fermata="C", prima_di_toccare=True)))
    sc.append(("19_senza_cache", S(senza_cache_raw=True), dict(exit=1, fermata="C", prima_di_toccare=True, senza_tick=True)))
    sc.append(("20_manca_un_csv", S(tick_mancante="2025-02"), dict(exit=1, fermata="D", prima_di_toccare=True)))
    sc.append(("21_csv_in_piu", S(tick_extra="U30USD_DKNEG_ticks_2025-03.csv"), dict(exit=1, fermata="D", prima_di_toccare=True)))
    sc.append(("22_csv_gia_fisso_senza_backup", S(stato_tick="fisso"), dict(exit=1, fermata="D", prima_di_toccare=True)))
    sc.append(("23_senza_referto_py", S(stato_tick="senza_referto"), dict(exit=1, fermata="D", prima_di_toccare=True)))
    sc.append(("24_disco_pieno", S(dischi=[dict(id="C:", size=500 * 2**30, free=2 * 2**30)]), dict(exit=1, fermata="D", prima_di_toccare=True)))
    sc.append(("25_backup_esiste_e_valido", S(backup="valido"), dict(exit=0, esito="PASSA", backup_preesistente=True)))
    sc.append(("26_backup_alterato", S(backup="alterato"), dict(exit=1, fermata="E", tick_intatti=True)))
    sc.append(("27_backup_senza_manifest", S(backup="senza_manifest"), dict(exit=1, fermata="E", tick_intatti=True)))
    sc.append(("28_riconversione_fallisce", S(muta_py="py_riconversione_fallisce"), dict(exit=1, fermata="F", backup_fatto=True)))
    sc.append(("28b_py_scrive_solo_un_referto_fresco", S(muta_py="py_solo_referto_fresco"), dict(exit=1, fermata="F", backup_fatto=True)))
    sc.append(("28c_py_referto_dice_usa", S(muta_py="py_referto_dst_usa"), dict(exit=1, fermata="F", backup_fatto=True)))
    sc.append(("28d_copia_di_sicurezza_corrotta", S(copia_corrotta=True), dict(exit=1, fermata="E", tick_intatti=True)))
    sc.append(("29b_nome_uscita_ignorato_dal_py", S(muta_py="py_nome_uscita_ignorato"), dict(exit=1, fermata="I", backup_fatto=True, dk_fatto=True)))
    sc.append(("29c_il_negativo_tocca_tick", S(muta_py="py_negativo_scrive_in_tick"), dict(exit=1, fermata="J", backup_fatto=True, dk_fatto=True)))
    sc.append(("29_copia_cache_negativo_fallisce", S(muta_py="py_copia_cache_fallisce"), dict(exit=1, fermata="I", backup_fatto=True, dk_fatto=True)))
    sc.append(("30_import_dk_non_parte", S(non_scrive=["U30USD_DK"]), dict(exit=1, fermata="H", backup_fatto=True)))
    sc.append(("31_import_neg_non_parte", S(non_scrive=["U30USD_DKNEG"]), dict(exit=1, fermata="J", backup_fatto=True, dk_fatto=True)))
    sc.append(("32_compilazione_fallisce", S(compile_fallisce=True), dict(exit=1, fermata="H", backup_fatto=True)))
    sc.append(("33_mq5_sha_sbagliato", S(sha_sbagliato="mq5"), dict(exit=1, fermata="H", backup_fatto=True)))
    sc.append(("34_file_stale_DK_in_MQL5_Files", S(files_stale=["U30USD_DK_ticks_2025-07.csv"]), dict(exit=1, fermata="H", backup_fatto=True)))
    sc.append(("35_file_stale_DKNEG_in_MQL5_Files", S(files_stale=["U30USD_DKNEG_ticks_2024-12.csv"]), dict(exit=1, fermata="J", backup_fatto=True, dk_fatto=True)))
    sc.append(("36_neg_gia_in_MQL5_Files_stesso_nome", S(files_stale=["U30USD_DKNEG_ticks_2025-03.csv"]), dict(exit=0, esito="PASSA")))
    return sc


def runna(nome, spec, att, riga=None):
    riga = riga or RIGA_DEF
    b = tempfile.mkdtemp(prefix="s_", dir=TMP)
    srv = None
    try:
        c = h1.costruisci(b, spec)
        srv = h1.Srv(spec)
        drv = open(riga, "rb").read().replace(h1.RAW.encode(), srv.base.encode())
        rf = os.path.join(b, "drv.ps1"); open(rf, "wb").write(drv)
        sha = dict(py=srv.sha(h1.FILE_PY), f2=srv.sha(h1.FILE_F2), imp=srv.sha(h1.FILE_IMP), mq5=srv.sha(h1.FILE_MQ5))
        shaatt = dict(sha)
        if spec["sha_sbagliato"]:
            shaatt[spec["sha_sbagliato"]] = "0" * 64
        args = "-Pin %s -ShaPy %s -ShaF2 %s -ShaImp %s -ShaMq5 %s%s" % (spec["pin"], shaatt["py"], shaatt["f2"], shaatt["imp"], shaatt["mq5"], " -SoloControllo" if spec["solo_controllo"] else "")
        lavoro = os.path.join(c, "Users", "Master", "dukascopy_lavoro")
        tick = os.path.join(lavoro, "tick")
        fuori0 = h1.snapshot(c)
        tick0 = h1.tree_hash(tick) if os.path.isdir(tick) else {}
        p = h1.esegui(spec, c, rf, args, srv, b)
        fuori1 = h1.snapshot(c)
        tick1 = h1.tree_hash(tick) if os.path.isdir(tick) else {}
        out = p.stdout
        try:
            err = valuta(nome, spec, att, c, b, p, out, fuori0, fuori1, tick0, tick1, srv)
        except Exception as e:      # un comportamento imprevisto della riga (file che non nasce...) e' un ROSSO, non un crash del banco
            err = ["ECCEZIONE NELLA VALUTAZIONE (la riga si e' comportata in modo imprevisto): %s: %s" % (type(e).__name__, e)]
        return nome, err
    finally:
        if srv: srv.chiudi()
        shutil.rmtree(b, ignore_errors=True)


EXP_USA = None
EXP_FISSO = None


def valuta(nome, spec, att, c, b, p, out, fuori0, fuori1, tick0, tick1, srv):
    err = []
    desk = os.path.join(c, "Users", "Master", "Desktop")
    lavoro = os.path.join(c, "Users", "Master", "dukascopy_lavoro")
    tick = os.path.join(lavoro, "tick")
    bk = os.path.join(lavoro, "tick_0309_backup")
    neg = os.path.join(lavoro, "dukascopy_neg")
    p1work = os.path.join(c, "Users", "Master", "abtg_duka_p1")
    dati_files = os.path.join(c, "Users", "Master", "AppData", "Roaming", "MetaQuotes", "Terminal", "ABC123", "MQL5", "Files")

    def must(s, dove=None, perche=""):
        if s not in (out if dove is None else dove):
            err.append("MANCA: " + s + ("  (" + perche + ")" if perche else ""))

    def mustnot(s, dove=None, perche=""):
        if s in (out if dove is None else dove):
            err.append("NON DOVREBBE ESSERCI: " + s + ("  (" + perche + ")" if perche else ""))

    if any(ord(ch) > 126 for ch in out):
        err.append("uscita non ASCII")
    if fuori0 != fuori1:
        err.append("SCRITTURE FUORI DAL PERIMETRO (altri terminali / Program Files / altre cartelle): " + str(sorted(set(fuori0) ^ set(fuori1))[:6]))
    if att.get("macchina"):
        must("QUESTA RIGA GIRA SOLO SUL PC DI BACKTEST DESKTOP-H4D7CAJ", out + p.stderr)
        mustnot("FINE-HARNESS rc=")
        if os.listdir(desk) or os.path.exists(p1work):
            err.append("la guardia macchina e' scattata ma ha scritto: Desktop %s, abtg_duka_p1 %s" % (os.listdir(desk), os.path.exists(p1work)))
        if srv.hits:
            err.append("la guardia macchina e' scattata DOPO una richiesta di rete: %s" % srv.hits[:2])
        return err
    must("FINE-HARNESS rc=%d" % att["exit"], None, "codice d'uscita")
    # --- il Desktop: SEMPRE la cartella DUKA_P1 + zip, col referto dentro
    cart = sorted(x for x in os.listdir(desk) if x.startswith("DUKA_P1_") and not x.endswith(".zip"))
    zips = sorted(x for x in os.listdir(desk) if x.startswith("DUKA_P1_") and x.endswith(".zip"))
    if len(cart) != 1 or len(zips) != 1:
        err.append("attese 1 cartella DUKA_P1 e 1 zip, trovati %s / %s" % (cart, zips))
        return err
    entries = sorted(os.path.basename(n) for n in zipfile.ZipFile(os.path.join(desk, zips[0])).namelist())
    folder = sorted(os.listdir(os.path.join(desk, cart[0])))
    if entries != folder:
        err.append("zip != cartella: %s contro %s" % (entries, folder))
    if "REFERTO_DUKA_P1.txt" not in entries:
        err.append("il referto manca nello zip")
    must("FILE PRESENTI NELLO ZIP (letti dallo zip, non dal piano): " + ", ".join(sorted(entries, key=str.lower)))
    must("ATTESI MA MANCANTI: nessuno")
    ref = open(os.path.join(desk, cart[0], "REFERTO_DUKA_P1.txt")).read() if "REFERTO_DUKA_P1.txt" in entries else ""
    # --- le fasi
    if att.get("vuoto"):
        must("GIRO A VUOTO: TUTTE LE GUARDIE E TUTTI I GATE PRECEDENTI PASSATI")
        must("ESITO P1: GIRO A VUOTO VERDE")
        if os.path.exists(bk) or os.path.exists(neg):
            err.append("il giro a vuoto ha creato backup o cartella del negativo")
        if tick0 != tick1:
            err.append("il giro a vuoto ha TOCCATO tick\\")
        if os.path.exists(os.path.join(p1work, "import_dk")):
            err.append("il giro a vuoto ha lanciato la riga figlia")
        for f in ("FASE E:", "FASE F:", "FASE H:"):
            mustnot(f)
        for f in ("FASE A:", "FASE B:", "FASE C:", "FASE D:"):
            must(f)
        return err
    if att.get("fermata"):
        f = att["fermata"]
        must("!!! FERMATA: [%s]" % f)
        must("ESITO P1: FERMATA -- [%s]" % f)
        must(f + " FERMATA:", ref, "la fase fermata e' nel referto")
        for later in "ABCDEFGHIJK"[("ABCDEFGHIJK".index(f) + 1):]:
            mustnot("FASE %s:" % later)
        if att.get("prima_di_toccare"):
            if tick0 != tick1:
                err.append("la fase %s ha fermato MA tick\\ e' cambiato" % f)
            if os.path.exists(bk):
                err.append("la fase %s ha fermato MA la copia di sicurezza e' stata creata" % f)
        if att.get("tick_intatti") and tick0 != tick1:
            err.append("tick\\ cambiato nonostante il gate " + f)
        if att.get("backup_fatto") and not os.path.exists(os.path.join(bk, "MANIFEST_SHA256.txt")):
            err.append("la copia di sicurezza doveva esistere")
        if att.get("dk_fatto"):
            must("FASE H:")
        return err
    # --- corsa completa
    for f in "ABCDEFGHIJK":
        must("FASE %s:" % f)
    must("ESITO F2: %s" % att["esito"])
    must("ESITO P1: fasi eseguite, ESITO F2 = %s" % att["esito"])
    # i CSV nuovi sono ESATTAMENTE quelli del tool vero con --dst fisso (esecuzione separata); il backup e' ESATTAMENTE lo stato "usa"
    global EXP_USA, EXP_FISSO
    if {k: v for k, v in tick1.items() if k.endswith(".csv")} != EXP_FISSO:
        err.append("i CSV in tick\\ NON sono quelli attesi dal tool vero con --dst fisso")
    bk_csv = h1.tree_hash(bk, lambda f: f.endswith(".csv")) if os.path.isdir(bk) else {}
    if bk_csv != EXP_USA:
        err.append("la copia di sicurezza NON e' lo stato 'usa' del 03/09")
    man = open(os.path.join(bk, "MANIFEST_SHA256.txt")).read().splitlines()
    if len(man) != 10 or not all(re.match(r"^[0-9A-F]{64}  \S+$", m) for m in man):
        err.append("manifest malformato: %s" % man[:2])
    for m in man:
        sh, nm = m.split("  ")
        if hashlib.sha256(open(os.path.join(bk, nm), "rb").read()).hexdigest().upper() != sh:
            err.append("manifest: impronta sbagliata per " + nm)
    # --- confronto dei giorni: 5 estivi SI, 4 invernali NO (dal tool vero)
    conf = None
    for root, ds, fs in os.walk(os.path.join(p1work)):
        for f in fs:
            if f == "confronto_giorni.csv":
                conf = open(os.path.join(root, f)).read().splitlines()
    if not conf or len(conf) != 10:
        err.append("confronto_giorni.csv mancante o con righe sbagliate")
    else:
        d = {r.split(",")[0]: r.split(",") for r in conf[1:]}
        for g in h1.ESTIVI:
            if d[g][5] != "SI" or d[g][1] != "4" or d[g][2] != "4":
                err.append("confronto: %s atteso identico con 4 righe: %s" % (g, d[g]))
        for g in h1.INVERNO:
            if d[g][5] != "NO":
                err.append("confronto: %s (invernale) doveva essere DIVERSO: %s" % (g, d[g]))
    # --- il negativo: cartella e nome separati, mai dentro tick\
    negcsv = os.path.join(neg, "tick", "U30USD_DKNEG_ticks_2025-03.csv")
    if not os.path.exists(negcsv):
        err.append("manca il CSV del negativo")
    else:
        # UTC puro: la prima riga del 2025.03.12 ha l'orario UTC dell'ora 10 (10:00:00), non 11:00
        righe = [l for l in open(negcsv).read().splitlines() if l.startswith("2025.03.12")]
        if not righe or not righe[0].startswith("2025.03.12 10:00:00,250,"):
            err.append("il negativo non e' UTC puro: %s" % righe[:1])
    if os.path.exists(os.path.join(tick, "U30USD_DKNEG_ticks_2025-03.csv")):
        err.append("il CSV del negativo e' finito dentro tick\\")
    # --- cio' che il simulatore ha visto: il DKNEG legge SOLO file DKNEG, DK legge i 9 DK
    simlog = os.path.join(b, "simlog")
    letti_dk = open(os.path.join(simlog, "sim_letti_U30USD_DK.txt")).read().split()
    letti_neg = open(os.path.join(simlog, "sim_letti_U30USD_DKNEG.txt")).read().split()
    if letti_dk != ["U30USD_DK_ticks_%s.csv" % m for m in h1.MESI]:
        err.append("l'import DK ha letto: %s" % letti_dk)
    if letti_neg != ["U30USD_DKNEG_ticks_2025-03.csv"]:
        err.append("l'import DKNEG ha letto: %s" % letti_neg)
    for s in ("U30USD_DK", "U30USD_DKNEG"):
        if "AllowLiveTrading=false: True" not in open(os.path.join(simlog, "sim_lancio_%s.txt" % s)).read():
            err.append("%s: AllowLiveTrading=false non era nel config del terminale" % s)
    # --- MQL5\Files: i DK copiati restano (come il 03/09), i DKNEG sono stati TOLTI (-PulisciFiles); il referto/giorni del terminale non e' stato toccato dal driver
    nomi = sorted(os.listdir(dati_files))
    if any("DKNEG_ticks" in n for n in nomi):
        err.append("MQL5\\Files ha ancora un CSV DKNEG: %s" % nomi)
    for m in h1.MESI:
        if "U30USD_DK_ticks_%s.csv" % m not in nomi:
            err.append("MQL5\\Files non ha piu' il CSV DK %s" % m)
    # --- le righe figlie sul Desktop: due cartelle + due zip, con simbolo nel nome
    figli = sorted(x for x in os.listdir(desk) if x.startswith("DUKA_IMPORT_SONDA_"))
    if len(figli) != 4 or not any("_U30USD_DK_" in f for f in figli) or not any("_U30USD_DKNEG_" in f for f in figli):
        err.append("righe figlie sul Desktop: %s" % figli)
    # --- esito della figlia DK
    if "figlia_dk_rc" in att:
        must("riga figlia: rc %d" % att["figlia_dk_rc"])
        must("FASE H: import e sonda di U30USD_DK eseguiti (rc figlia %d)" % att["figlia_dk_rc"])
    if att["esito"] == "PASSA":
        must("PER NOME: 9 su 9 giorni NOMINATI dentro per nome")
        must("CANCELLO ZERO DEI _DK (serve (1) E (2) E (3)): PASSA")
    else:
        must("CANCELLO ZERO DEI _DK (serve (1) E (2) E (3)): NON PASSA")
        must("U30USD_DK RESTA IN FRIGO")
    if att.get("backup_preesistente"):
        must("la copia esiste gia'")
    else:
        must("copia fatta:")
    # il referto contiene le fasi
    for f in "ABCDEFGHIJK":
        if "FASE %s:" % f not in ref:
            err.append("referto senza la FASE %s" % f)
    return err


def main():
    global EXP_USA, EXP_FISSO
    av = sys.argv[1:]
    riga = os.path.abspath(av[av.index("--riga") + 1]) if "--riga" in av else None
    solo = av[av.index("--solo") + 1] if "--solo" in av else None
    jobs = int(av[av.index("--jobs") + 1]) if "--jobs" in av else 4
    EXP_USA = hashes_tool("usa"); EXP_FISSO = hashes_tool("fisso")
    assert EXP_USA != EXP_FISSO and len(EXP_USA) == 9, "le due conversioni di riferimento devono differire (9 CSV)"
    sc = [s for s in scenari() if (solo is None or solo in s[0])]
    par = [(n, s, a, riga) for (n, s, a) in sc if not s["mt5_vivo"]]
    ser = [(n, s, a, riga) for (n, s, a) in sc if s["mt5_vivo"]]
    with Pool(jobs, initializer=_init, initargs=(EXP_USA, EXP_FISSO)) as p:
        res = p.starmap(runna, par)
    _init(EXP_USA, EXP_FISSO)
    for x in ser:
        res.append(runna(*x))
    verdi = 0
    for nome, err in res:
        if not err:
            verdi += 1
        else:
            print("ROSSO " + nome)
            for e in err[:6]:
                print("     - " + e[:300])
    print("BATTERIA P1: %d/%d scenari verdi" % (verdi, len(res)))
    return 0 if verdi == len(res) else 1


def _init(u, f):
    global EXP_USA, EXP_FISSO
    EXP_USA, EXP_FISSO = u, f


if __name__ == "__main__":
    sys.exit(main())
