#!/usr/bin/env python3
# -*- coding: ascii -*-
"""
battery.py -- batteria di scenari per PASSATA_STOP_SUPREV_NAS.ps1 (banco.py: finto C:, terminale finto sim_mt5.py, server locale al pin; il parser, i decimali, le regex, Compress-Archive,
Get-Process sono VERI). Le attese sono scritte per scenario con grandezze INDIPENDENTI dall'uscita dello script: mediane e rapporti ricalcolati qui con Decimal e statistics a partire dagli
ingressi dello scenario e dal CSV dello spread LETTO COL MODULO csv (non con le funzioni dello script). I casi al bordo (G0: 168/169/175/176 operazioni, 4511.03/4511.04/4886.96/4886.97 di
profitto; C3: rapporto 44,0000 / 43,9941 / 36,0000 / 35,9941; mediana di due valori a cavallo del 44) sono costruiti a mano dalle soglie del piano, non dall'uscita.
Controlli trasversali (ogni scenario): codice d'uscita atteso (0 misura affidabile / 3 NON MISURATO / 1 guardia); tutto cio' che sta FUORI da Desktop / abtg_passata / MQL5 del terminale BCM e'
IDENTICO prima e dopo; l'uscita e' ASCII; nelle guardie di macchina/MT5/EA nessuna richiesta di rete e nessun file creato.
Uso: python3 battery.py [--solo NOME] [--jobs N] [--lenti]   -> ultima riga "BATTERIA R290A: n/m scenari verdi"
"""
import csv, os, re, shutil, statistics, sys, tempfile, zipfile
from decimal import Decimal as D
from multiprocessing import Pool
import banco

QD = os.path.dirname(os.path.abspath(__file__))
TMP = os.environ.get("HARNESS_TMP") or tempfile.mkdtemp(prefix="r290abat_")
SPREAD = {}
for r in csv.DictReader(open(os.path.join(banco.REPO, banco.F_SPREAD))):
    if r["ora_server"] != "TUTTO":
        SPREAD[int(r["ora_server"])] = D(r["mediana_idx"])
assert len(SPREAD) == 24
BUFFERS = [2253, 3003, 3378, 4503]


def mk(voci, base_prezzo=20000):
    """voci: (giorno 'AAAA.MM.GG', ora, lato, dist 'x.xx') -> righe 'mercato' dello scenario (prezzi univoci per voce)"""
    out = []
    for k, (g, h, lato, dist) in enumerate(voci):
        ing = D(base_prezzo) + D(k) * D("7.25")
        d = D(dist)
        sl = ing - d if lato == "LONG" else ing + d
        tp = ing + 3 * d if lato == "LONG" else ing - 3 * d
        out.append(["%s %02d:00:00" % (g, h), lato, "0.50", "%.2f" % ing, "%.2f" % sl, "%.2f" % tp])
    return out


def ripr(voci):
    return voci


def base_voci():
    ore = [8, 9, 10, 13, 14, 15, 16, 17, 18, 19, 20, 21]
    v = []
    for i in range(24):
        v.append(("2024.%02d.%02d" % (10 + i // 12, 1 + i % 12), ore[i % 12], "LONG" if i % 2 == 0 else "SHORT", "%d.%02d" % (85 + (i * 7) % 90, (i * 13) % 100)))
    return v


def att_c3(voci, buffers=BUFFERS):
    """attese INDIPENDENTI: mediana dello stop e del rapporto per buffer (Decimal esatto), per tutti e per lato"""
    res = {}
    for b in buffers:
        delta = D(b - 2253) / D(100)
        st = [D(d) + delta for (_, h, l, d) in voci]
        ra = [(D(d) + delta) / SPREAD[h] for (_, h, l, d) in voci]
        res[b] = dict(med_stop=D(statistics.median(st)), med_rap=D(statistics.median(ra)), sotto_pav=sum(1 for s in st if s < D("34.6")), n=len(st))
        for lat in ("LONG", "SHORT"):
            rl = [(D(d) + delta) / SPREAD[h] for (_, h, l, d) in voci if l == lat]
            res[b][lat] = D(statistics.median(rl)) if rl else None
    return res


def banda(r):
    return "PASSA" if r >= 44 else ("FRAGILE" if r >= 36 else "NON PASSA")


def q4(x):
    return str(D(x).quantize(D("0.0001"), rounding="ROUND_HALF_UP"))


def q2(x):
    return str(D(x).quantize(D("0.01"), rounding="ROUND_HALF_UP"))


def rep(**kw):
    return kw


def S(voci=None, report=None, **kw):
    voci = base_voci() if voci is None else voci
    scen = dict(entries=mk(voci), report=report or {})
    for k in ("avvio", "ini_ignorata", "imb_delta", "imb_simbolo", "senza_data", "giornale_duplicato", "per_trade", "compile_fallisce", "entries_raw"):
        if k in kw:
            scen[k] = kw.pop(k)
    if "entries_raw" in scen:
        scen["entries"] = scen.pop("entries_raw")
    s = banco.spec_base(scen=scen, **kw)
    s["voci"] = voci
    return s


# ---------------------------------------------------------------- mutazioni dei file serviti al pin
def del_riga(prefisso):
    def f(b):
        t = b.decode("ascii")
        righe = t.split("\n")
        n = [r for r in righe if not r.startswith(prefisso)]
        assert len(n) == len(righe) - 1, prefisso
        return "\n".join(n).encode("ascii")
    return f


def sost(a, b_, volte=1):
    def f(b):
        t = b.decode("ascii")
        assert t.count(a) >= 1, a
        return t.replace(a, b_, volte).encode("ascii")
    return f


def spread_senza_ora(h):
    def f(b):
        t = b.decode("ascii")
        righe = t.split("\n")
        n = [r for r in righe if not r.startswith("%d," % h)]
        assert len(n) == len(righe) - 1
        return "\n".join(n).encode("ascii")
    return f


def prova_riga_extra(riga):
    return lambda b: (b.decode("ascii").rstrip("\n") + "\n" + riga + "\n").encode("ascii")


def prova_tronca(b):
    t = b.decode("ascii").split("\n")
    out = []
    n = 0
    for r in t:
        if r.startswith("Inp") and n >= 20 and not r.startswith("InpUseTimeWindow"):
            continue
        if r.startswith("Inp"):
            n += 1
        out.append(r)
    return "\n".join(out).encode("ascii")


E_NAS = "mql5/Experts/ABTG_SupertrendReversal.mq5"
P_NAS = banco.F_PROVA
SP = banco.F_SPREAD

V17 = lambda d: [("2024.10.01", 17, "LONG", d), ("2024.10.02", 17, "SHORT", d), ("2024.10.03", 17, "LONG", d)]


def scenari():
    sc = []
    A = sc.append
    # ---------------------------------------------------------------- misura: casi verdi e il contro-esempio dei due lati
    A(("01_due_lati_insieme_verde", S(), dict(rc=0, c3=True, zip=["RIEPILOGO_PASSATA_NAS.txt", "STOP_NAS.csv", "passata_NAS.ini", "spread_orario_NASUSD.csv", "PASSATA_STOP_NAS.htm"], ini=True, lati=True,
                                                                                 testo=["input riletti dal report: 33 su 33 coincidono con l ancora; assenti nel report 0; DIVERSI 0", "stop minimo 85.00 > 22,53 OK"])))
    A(("01b_giornale_duplicato_senza_data", S(giornale_duplicato=True), dict(rc=0, c3=True)))
    A(("01c_log_vecchio_prima_della_fotografia", S(log_vecchio=True), dict(rc=0, c3=True, no_testo=["9.99"])))
    A(("01d_ore_di_confine_0_e_23", S(voci=[("2024.10.01", 0, "LONG", "90.00"), ("2024.10.02", 23, "SHORT", "95.50"), ("2024.10.03", 8, "LONG", "120.25"), ("2024.10.04", 9, "SHORT", "130.10")]), dict(rc=0, c3=True)))
    A(("01e_report_inglese", S(report=rep(lingua="en")), dict(rc=0, c3=True)))
    A(("01f_report_con_nbsp_nei_migliaia", S(report=rep(sep=chr(160))), dict(rc=0, c3=True)))
    A(("01g_per_trade_fresco", S(per_trade="fresco"), dict(rc=0, c3=True, testo=["per-trade raccolto: abtg_trades_ABTG_SupertrendReversal_NASUSD_799810.csv"], zip_extra=["abtg_trades_ABTG_SupertrendReversal_NASUSD_799810.csv"])))
    A(("01h_per_trade_vecchio", S(per_trade="vecchio"), dict(rc=0, c3=True, testo=["per-trade dell EA non trovato fresco"], zip_no=["abtg_trades_ABTG_SupertrendReversal_NASUSD_799810.csv"])))
    A(("01i_report_in_MQL5_Files", S(report=rep(dove="Users\\Master\\AppData\\Roaming\\MetaQuotes\\Terminal\\ABC123\\MQL5\\Files")), dict(rc=0, c3=True)))
    A(("01j_desktop_con_residui", S(desktop_vecchio=True), dict(rc=0, c3=True, desktop=True)))
    # ---------------------------------------------------------------- G0: bordi costruiti dalla soglia (172 +/- 3; 4699 +/- 4% = 4511.04 .. 4886.96)
    for nome, trades, ok in (("169", "169", True), ("175", "175", True), ("168", "168", False), ("176", "176", False)):
        A(("02_g0_trades_%s" % nome, S(report=rep(trades=trades)), dict(rc=0 if ok else 3, c3=ok, g0=ok)))
    for nome, prof, ok in (("4511.04", "4 511.04", True), ("4511.03", "4 511.03", False), ("4886.96", "4 886.96", True), ("4886.97", "4 886.97", False), ("meno_4699", "-4 699.03", False)):
        A(("03_g0_profitto_%s" % nome, S(report=rep(profitto=prof)), dict(rc=0 if ok else 3, c3=ok, g0=ok)))
    A(("04_g0_report_assente", S(report=rep(scrivi=False)), dict(rc=3, c3=False, g0=False, testo=["report .htm della passata NON trovato"])))
    A(("04b_g0_report_vecchio_non_si_usa", S(report=rep(vecchio=True)), dict(rc=3, c3=False, g0=False, testo=["report .htm della passata NON trovato"])))
    A(("04c_g0_report_vecchio_in_installazione_non_si_usa", S(report=rep(scrivi=False), report_vecchio_in_inst=True), dict(rc=3, c3=False, g0=False, testo=["report .htm della passata NON trovato"])))
    A(("04d_g0_report_illeggibile", S(report=rep(garbage=True)), dict(rc=3, c3=False, g0=False, testo=["report illeggibile"])))
    A(("04e_g0_report_senza_totale_operazioni", S(report=rep(senza_trades=True)), dict(rc=3, c3=False, g0=False, testo=["etichetta del totale operazioni"])))
    A(("04f_g0_report_di_altro_simbolo", S(report=rep(simbolo="U30USD")), dict(rc=3, c3=False, g0=False, testo=["altro simbolo"])))
    A(("04g_g0_report_di_altro_EA", S(report=rep(expert="ABTG_SupRev_NAS_H1_Ottimizzato")), dict(rc=3, c3=False, g0=False, testo=["altro EA"])))
    A(("04h_g0_report_di_altro_periodo", S(report=rep(periodo="H1 (2024.09.26 - 2026.08.21)")), dict(rc=3, c3=False, g0=False, testo=["il periodo del report"])))
    A(("04i_g0_input_del_report_diversi_non_blocca", S(report=rep(input_override={"InpStMult": "3.5"})), dict(rc=0, c3=True, testo=["DIVERSI 1 -> ATTENZIONE: InpStMult report=3.5 ini=3.0"])))
    # ---------------------------------------------------------------- configurazione e controllo incrociato
    A(("05_ini_ignorata_EA_gira_coi_default", S(ini_ignorata=True), dict(rc=3, c3=False, testo=["CONTROLLO CONFIGURAZIONE: ROTTO"])))
    A(("05d_pip_diverso_da_0_01", S(avvio="[STReversal] avviato su NASUSD PERIOD_H1. Supertrend(10,3.0). 1 pip=0.10000"), dict(rc=3, c3=False, testo=["CONTROLLO CONFIGURAZIONE: ROTTO", "1 pip=0.10000"])))
    A(("05e_avvio_senza_pip", S(avvio="[STReversal] avviato su NASUSD PERIOD_H1. Supertrend(10,3.0)."), dict(rc=3, c3=False, testo=["CONTROLLO CONFIGURAZIONE: ROTTO"])))
    A(("05b_riga_di_avvio_assente", S(avvio="[STReversal] niente di utile"), dict(rc=3, c3=False, testo=["riga di avvio dell EA NON trovata"])))
    A(("05c_imbuto_di_un_altro_simbolo", S(imb_simbolo="U30USD"), dict(rc=3, c3=False, testo=["righe IMBUTO non intestate NASUSD PERIOD_H1"])))
    A(("06_incrocio_somma_imbuto_piu_uno", S(imb_delta=1), dict(rc=3, c3=False, testo=["CONTROLLO INCROCIATO: ROTTO"])))
    A(("06b_incrocio_somma_imbuto_meno_uno", S(imb_delta=-1), dict(rc=3, c3=False, testo=["CONTROLLO INCROCIATO: ROTTO"])))
    sl_storto = mk(base_voci())
    assert sl_storto[4][1] == "LONG"
    sl_storto[4][4], sl_storto[4][5] = "%.2f" % (float(sl_storto[4][3]) + 90), "%.2f" % (float(sl_storto[4][3]) + 300)     # un LONG con SL SOPRA l'ingresso
    A(("07_sl_dal_lato_sbagliato", S(entries_raw=sl_storto), dict(rc=3, c3=False, testo=["1 ingressi con lo SL dal lato sbagliato"])))
    A(("07b_ingressi_senza_data_simulata", S(senza_data=True), dict(rc=3, c3=False, testo=["ingressi senza data simulata"], no_testo=["C3 -- mediana"])))
    A(("07c_un_lato_solo", S(voci=[("2024.10.%02d" % (i + 1), 14, "LONG", "%d.00" % (100 + i)) for i in range(8)]), dict(rc=0, c3=True, testo=["un lato ha ZERO ingressi", "lato SHORT: n 0, NON MISURATO"])))
    A(("07d_zero_ingressi", S(voci=[]), dict(rc=3, c3=False, testo=["CONTROLLO INCROCIATO: ROTTO"])))
    # ---------------------------------------------------------------- C3: bande (ora 17 = spread mediano 1,70): 44,0000 / 43,9941 / 36,0000 / 35,9941 a buffer 2253
    for nome, dist in (("44_esatto", "74.80"), ("43_9941", "74.79"), ("36_esatto", "61.20"), ("35_9941", "61.19")):
        A(("08_c3_banda_%s" % nome, S(voci=V17(dist)), dict(rc=0, c3=True)))
    A(("08e_c3_mediana_di_due_a_cavallo_del_44", S(voci=[("2024.10.01", 17, "LONG", "74.00"), ("2024.10.02", 17, "SHORT", "75.60")]), dict(rc=0, c3=True)))
    A(("08f_c3_pavimento_duro", S(voci=[("2024.10.%02d" % (i + 1), 17, "LONG" if i % 2 else "SHORT", "5.00") for i in range(6)]), dict(rc=0, c3=True, testo=["pavimento duro (mediana stop >= 34,6): NO | ingressi con stop < 34,6: 6 su 6"])))
    for nome, dist, pav in (("32_00", "32.00", "NO"), ("34_59", "34.59", "NO"), ("34_60", "34.60", "SI")):
        A(("08g_c3_pavimento_%s" % nome, S(voci=V17(dist)), dict(rc=0, c3=True, testo=["(mediana stop >= 34,6): %s |" % pav])))
    A(("08j_algebra_stop_minimo_sotto_22_53", S(voci=V17("10.00")), dict(rc=0, c3=True, testo=["ATTENZIONE COERENZA DELL ALGEBRA: stop minimo 10.00 NON supera 22,53"])))
    # attese scritte prima (piano 4.1): stop(2253) mediano 93-188 dentro l'attesa; sotto 65 l'ipotesi e' SMENTITA; 65-93 fuori attesa ma non smentita; sopra 188 fuori attesa
    for nome, dist, frase in (("64_99", "64.99", "SOTTO 65: l IPOTESI"), ("65_00", "65.00", "sotto l attesa 93-188 ma >= 65"), ("92_99", "92.99", "sotto l attesa 93-188 ma >= 65"),
                              ("93_00", "93.00", "DENTRO l attesa 93-188"), ("188_00", "188.00", "DENTRO l attesa 93-188"), ("188_01", "188.01", "SOPRA l attesa 93-188")):
        A(("09_attesa_%s" % nome, S(voci=V17(dist)), dict(rc=0, c3=True, testo=[frase])))
    # ---------------------------------------------------------------- guardie (prima di toccare qualunque cosa)
    A(("10_macchina_vps", S(macchina="VMI3047753"), dict(rc=1, fermata=True, msg="gira SOLO sul PC di backtest DESKTOP-H4D7CAJ")))
    A(("10b_mt5_aperto", S(mt5_vivo="terminal64"), dict(rc=1, fermata=True, msg="APERTO su questo PC")))
    A(("10c_metaeditor_aperto", S(mt5_vivo="metaeditor64"), dict(rc=1, fermata=True, msg="APERTO su questo PC")))
    A(("10d_ea_sul_grafico_salvato", S(chr=[{}, dict(ea="ABTG_EMA200")]), dict(rc=1, fermata=True, msg="SEDIE ATTACCATE")))
    A(("10e_zero_grafici_salvati", S(chr=[]), dict(rc=1, fermata=True, msg="ZERO grafici salvati")))
    A(("10f_grafico_illeggibile", S(chr=[{}, dict(illeggibile=True)]), dict(rc=1, fermata=True, msg="ILLEGGIBILE")))
    A(("10g_due_cartelle_dati", S(doppio_dati=True), dict(rc=1, fermata=True, msg="NON risolta in modo univoco")))
    A(("10h_altra_installazione_MT5", S(altra_inst=True), dict(rc=1, fermata=True, msg="installazioni MT5 NON censite")))
    # seconda lettura del cancello 06/10 (classe 1157): le due installazioni censite il 05/10 sono nel banco di DEFAULT (ogni scenario gira col PC com'e'); qui si pretende che siano dette per nome e non toccate (lo snapshot copre le loro cartelle)
    A(("10j_censite_presenti_dette_e_non_toccate", S(), dict(rc=0, c3=True, testo=["CHIUSA e NON TOCCATA: C:\\MT5_Backtest", "CHIUSA e NON TOCCATA: C:\\FundedNext_Manuale"])))
    A(("10k_censite_assenti_va_lo_stesso", S(censite=False), dict(rc=0, c3=True, no_testo=["CHIUSA e NON TOCCATA"])))
    A(("10i_nessuna_cartella_dati", S(senza_origin=True), dict(rc=1, fermata=True, msg="NON risolta in modo univoco")))
    A(("11_pin_malformato", S(pin="abc"), dict(rc=1, fermata=True, msg="-Pin obbligatorio e di 40 caratteri")))
    # ---------------------------------------------------------------- sorgenti al pin
    A(("12_EA_senza_firma", S(muta={E_NAS: sost("STREV-IMBUTO", "STREV-IMBUTX", 1000)}), dict(rc=1, msg='NON contiene "STREV-IMBUTO"', no_ini=True)))
    A(("12b_prova_senza_firma", S(muta={P_NAS: sost("InpUseTimeWindow", "InpUseTimeWindoX", 1000)}), dict(rc=1, msg='NON contiene "InpUseTimeWindow"', no_ini=True)))
    A(("12c_spread_senza_firma", S(muta={SP: sost("ora_server,tick_totali", "ora,tick", 1)}), dict(rc=1, msg='NON contiene "ora_server,tick_totali"', no_ini=True)))
    A(("12d_spread_con_23_ore", S(muta={SP: spread_senza_ora(11)}), dict(rc=1, msg="ore lette 23 invece di 24", no_ini=True)))
    A(("12e_spread_TUTTO_non_somma", S(muta={SP: sost("TUTTO,156146398", "TUTTO,156146399", 1)}), dict(rc=1, msg="non e la somma dei tick", no_ini=True)))
    A(("12f_spread_ora_ripetuta", S(muta={SP: sost("\n23,", "\n22,", 1)}), dict(rc=1, msg="ripetuta", no_ini=True)))
    A(("12g_spread_mediana_zero", S(muta={SP: sost("8,4573027,4573027,0,2.4173,2.5000,", "8,4573027,4573027,0,2.4173,0.0000,", 1)}), dict(rc=1, msg="spread mediano <= 0 all ora 8", no_ini=True)))
    A(("13_prova_con_buffer_diverso", S(muta={P_NAS: sost("InpSLBufferPips=2253", "InpSLBufferPips=3", 1)}), dict(rc=1, msg="NON contiene esattamente una volta InpSLBufferPips=2253", no_ini=True)))
    A(("13b_prova_con_parametro_doppio", S(muta={P_NAS: prova_riga_extra("InpStMult=3.5")}), dict(rc=1, msg="parametri DOPPI nel file prova: InpStMult", no_ini=True)))
    A(("13g_prova_con_riga_ancora_ripetuta_identica", S(muta={P_NAS: prova_riga_extra("InpStMult=3.0")}), dict(rc=1, msg="NON contiene esattamente una volta InpStMult=3.0", no_ini=True)))
    A(("13c_prova_con_finestra_accesa", S(muta={P_NAS: sost("InpUseTimeWindow=0||0||1||1||Y", "InpUseTimeWindow=1||0||1||1||Y", 1)}), dict(rc=1, msg="la finestra oraria NON risulta spenta", no_ini=True)))
    A(("13d_prova_tronca", S(muta={P_NAS: prova_tronca}), dict(rc=1, msg="file prova tronco", no_ini=True)))
    A(("13e_prova_un_solo_lato", S(muta={P_NAS: sost("InpAllowShort=true", "InpAllowShort=false", 1)}), dict(rc=1, msg="NON contiene esattamente una volta InpAllowShort=true", no_ini=True)))
    A(("13f_prova_senza_verbose", S(muta={P_NAS: sost("InpVerbose=true", "InpVerbose=false", 1)}), dict(rc=1, msg="NON contiene esattamente una volta InpVerbose=true", no_ini=True)))
    A(("14_compilazione_fallisce", S(compile_fallisce=True), dict(rc=1, msg=".ex5 NON prodotto", no_ini=True)))
    return sc


def scenari_lenti():
    return [("15_timeout_chiude_con_CloseMainWindow", S(no_exit=True, timeout_min=1, sleep_reale=True), dict(rc=0, c3=True, testo=["TIMEOUT: dopo 1 minuti"], close=True))]


# ---------------------------------------------------------------- esecuzione di UNO scenario
def runna(nome, spec, att, muta_script=None):
    b = tempfile.mkdtemp(prefix="s_", dir=TMP)
    srv = None
    prob = []
    try:
        if muta_script:
            spec = dict(spec); spec["muta_script"] = muta_script
        c = banco.costruisci(b, spec)
        srv = banco.Srv(spec)
        fuori0 = banco.snapshot(c)
        p = banco.esegui(spec, c, srv, b)
        fuori1 = banco.snapshot(c)
        out = re.sub(r"\x1b\[[0-9;]*m", "", p.stdout + "\n" + p.stderr)
        m = re.search(r"FINE-HARNESS rc=(\d+)", p.stdout)
        rc = int(m.group(1)) if m else p.returncode
        user = os.path.join(c, "Users", "Master")
        desk = os.path.join(user, "Desktop")
        if rc != att["rc"]:
            prob.append("rc %s invece di %s" % (rc, att["rc"]))
        if fuori0 != fuori1:
            prob.append("FILE FUORI dal perimetro cambiati: %s" % sorted(set(fuori0) ^ set(fuori1) | {k for k in fuori0 if k in fuori1 and fuori0[k] != fuori1[k]}))
        try:
            p.stdout.encode("ascii")
        except UnicodeEncodeError:
            prob.append("uscita non ASCII")
        if att.get("msg") and att["msg"] not in out:
            prob.append("manca il messaggio %r" % att["msg"])
        for t in att.get("testo", []):
            if t not in out:
                prob.append("manca %r" % t)
        for t in att.get("no_testo", []):
            if t in out:
                prob.append("c'e' %r" % t)
        if att.get("fermata"):
            if srv.hits:
                prob.append("richieste di rete PRIMA della guardia: %s" % srv.hits[:2])
            if os.path.exists(os.path.join(user, "abtg_passata")) or os.path.exists(os.path.join(desk, "PASSATA_STOP_SUPREV_NAS")):
                prob.append("file creati prima della guardia")
        if att.get("no_ini") and os.path.exists(os.path.join(user, "abtg_passata", "passata_NAS.ini")):
            prob.append("la .ini e' stata scritta nonostante il difetto a monte")
        if att.get("no_ini") and os.path.exists(os.path.join(b, "simlog", "sim_terminal_lanci.txt")):
            prob.append("il terminale e' stato LANCIATO nonostante il difetto a monte")
        if "c3" in att:
            ha = "C3 -- mediana di (stop_i / spread_h(i))" in out
            if ha != att["c3"]:
                prob.append("C3 stampato=%s, atteso %s" % (ha, att["c3"]))
        if att.get("g0") is not None:
            if att["g0"] and "): VERDE." not in out:
                prob.append("G0 atteso VERDE")
            if att["g0"] is False and "NON RAGGIUNTO" not in out:
                prob.append("G0 atteso NON RAGGIUNTO")
        if att["rc"] in (0, 3) and "zip" not in att:
            if not os.path.exists(os.path.join(desk, "PASSATA_STOP_SUPREV_NAS.zip")):
                prob.append("lo zip non esiste (deve esistere SEMPRE, anche NON MISURATO)")
        if att.get("zip"):
            z = os.path.join(desk, "PASSATA_STOP_SUPREV_NAS.zip")
            if not os.path.exists(z):
                prob.append("zip assente")
            else:
                nomi = sorted(zipfile.ZipFile(z).namelist())
                attesi = sorted(att["zip"] + att.get("zip_extra", []))
                if nomi != attesi:
                    prob.append("zip %s invece di %s" % (nomi, attesi))
        for ex in att.get("zip_extra", []):
            nomi = zipfile.ZipFile(os.path.join(desk, "PASSATA_STOP_SUPREV_NAS.zip")).namelist() if os.path.exists(os.path.join(desk, "PASSATA_STOP_SUPREV_NAS.zip")) else []
            if ex not in nomi:
                prob.append("nello zip manca %s" % ex)
        for ex in att.get("zip_no", []):
            nomi = zipfile.ZipFile(os.path.join(desk, "PASSATA_STOP_SUPREV_NAS.zip")).namelist() if os.path.exists(os.path.join(desk, "PASSATA_STOP_SUPREV_NAS.zip")) else []
            if ex in nomi:
                prob.append("nello zip c'e' %s" % ex)
        if att.get("ini"):
            prob += controlla_ini(b, user)
        if att.get("lati"):
            prob += controlla_lati(spec, out, desk)
        if att.get("c3") and att["rc"] == 0:
            prob += controlla_c3(spec, out)
        if att.get("desktop"):
            def leggi(*pp):
                try:
                    return open(os.path.join(desk, *pp), "rb").read().decode("latin-1")
                except OSError:
                    return None
            if leggi("PASSATA_STOP_SUPREV", "U30.txt") != "vecchia U30USD\n" or leggi("PASSATA_STOP_SUPREV.zip") != "zip vecchio U30USD\n":
                prob.append("i file della passata U30USD sono stati TOCCATI o cancellati")
            if os.path.exists(os.path.join(desk, "PASSATA_STOP_SUPREV_NAS", "RESIDUO.txt")):
                prob.append("il residuo NAS vecchio e' ancora nella cartella")
            zz = leggi("PASSATA_STOP_SUPREV_NAS.zip")
            if zz is None or "zip NAS vecchio" in zz:
                prob.append("lo zip NAS vecchio non e' stato sostituito")
        if att.get("close") and not os.path.exists(os.path.join(b, "simlog", "sim_closemainwindow.txt")):
            prob.append("CloseMainWindow non chiamato")
        # il compile: DUE argomenti (deviazione 8)
        if att["rc"] in (0, 3) and os.path.exists(os.path.join(b, "simlog", "sim_args_editor.txt")):
            import json
            av = json.loads(open(os.path.join(b, "simlog", "sim_args_editor.txt")).read())
            if len(av) != 2 or not av[0].startswith("/compile:") or not av[1].startswith("/log:"):
                prob.append("MetaEditor chiamato con argomenti %s invece di due (/compile: e /log:)" % av)
        return nome, prob, out
    finally:
        if srv:
            srv.chiudi()
        shutil.rmtree(b, ignore_errors=True)


def controlla_ini(b, user):
    prob = []
    p = os.path.join(user, "abtg_passata", "passata_NAS.ini")
    if not os.path.exists(p):
        return ["la .ini non c'e'"]
    t = open(p, "rb").read().decode("ascii")
    for k in ("AllowLiveTrading=false", "AllowDllImport=false", "Expert=ABTG_SupertrendReversal.ex5", "Symbol=NASUSD", "Period=H1", "Model=4", "Optimization=0", "FromDate=2024.09.26", "ToDate=2026.06.30",
              "ForwardMode=0", "Deposit=100000", "Currency=EUR", "Leverage=100", "ShutdownTerminal=1", "Report=PASSATA_STOP_NAS", "InpSLBufferPips=2253", "InpUseTimeWindow=0", "InpVerbose=true", "InpAllowLong=true",
              "InpAllowShort=true", "InpUsaGuardian=true", "InpStMult=3.0", "InpMagic=799810"):
        if re.search(r"^%s\r?$" % re.escape(k), t, re.M) is None:
            prob.append("ini senza la riga %s" % k)
    if "||" in t or "AllowLiveTrading=true" in t or "Optimization=1" in t:
        prob.append("ini con '||' o AllowLiveTrading=true o Optimization=1")
    if t.count("\r\n") < 20:
        prob.append("ini senza CRLF")
    sim = open(os.path.join(b, "simlog", "sim_ini.txt")).read()
    if sim.replace("\r\n", "\n") != t.replace("\r\n", "\n"):
        prob.append("la .ini che il terminale ha letto e' diversa da quella dello script")
    lanci = open(os.path.join(b, "simlog", "sim_terminal_lanci.txt")).read().strip().splitlines()
    if len(lanci) != 1 or "/config:" not in lanci[0]:
        prob.append("lanci del terminale: %s" % lanci)
    return prob


def controlla_lati(spec, out, desk):
    prob = []
    voci = spec["voci"]
    nl = sum(1 for v in voci if v[2] == "LONG")
    ns = sum(1 for v in voci if v[2] == "SHORT")
    if "(LONG %d / SHORT %d)" % (nl, ns) not in out:
        prob.append("conteggio per lato atteso LONG %d / SHORT %d" % (nl, ns))
    if "CONTROLLO CONFIGURAZIONE: OK" not in out or "CONTROLLO INCROCIATO: OK" not in out:
        prob.append("con DUE lati insieme i controlli devono essere OK (il vecchio controllo $altroLato li romperebbe)")
    if "ingressi del lato opposto" in out:
        prob.append("e' uscito il vecchio controllo del lato opposto")
    z = os.path.join(desk, "PASSATA_STOP_SUPREV_NAS.zip")
    if os.path.exists(z):
        cs = zipfile.ZipFile(z).read("STOP_NAS.csv").decode("ascii").strip().split("\r\n")
        if len(cs) != len(voci) + 1:
            prob.append("STOP_NAS.csv ha %d righe, attese %d" % (len(cs), len(voci) + 1))
        att = sorted((v[2], D(v[3])) for v in voci)
        got = sorted((r.split(";")[1], D(r.split(";")[6])) for r in cs[1:])
        if att != got:
            prob.append("le distanze del CSV non coincidono con quelle dello scenario")
    return prob


def controlla_c3(spec, out):
    prob = []
    voci = spec["voci"]
    if not voci:
        return prob
    ex = att_c3(voci)
    for b in BUFFERS:
        e = ex[b]
        tipo = "MISURA" if b == 2253 else "DERIVATO"
        frase = "buffer %d (%s)" % (b, tipo)
        righe = [r for r in out.split("\n") if frase in r and "stop mediano" in r]
        if len(righe) != 1:
            prob.append("riga C3 del buffer %d: %d trovate" % (b, len(righe)))
            continue
        r = righe[0]
        att = "stop mediano %s idx | rapporto mediano %s -> %s" % (q2(e["med_stop"]), q4(e["med_rap"]), banda(e["med_rap"]))
        if att not in r:
            prob.append("buffer %d: atteso %r, uscito %r" % (b, att, r.strip()[:230]))
        pav = "SI" if e["med_stop"] >= D("34.6") else "NO"
        if "(mediana stop >= 34,6): %s | ingressi con stop < 34,6: %d su %d" % (pav, e["sotto_pav"], e["n"]) not in r:
            prob.append("buffer %d: pavimento duro atteso %s / %d su %d" % (b, pav, e["sotto_pav"], e["n"]))
        if "stress (NON cancello): mediana stop/2,40 = %s, /2,70 = %s" % (q2(e["med_stop"] / D("2.40")), q2(e["med_stop"] / D("2.70"))) not in r:
            prob.append("buffer %d: stress atteso %s / %s" % (b, q2(e["med_stop"] / D("2.40")), q2(e["med_stop"] / D("2.70"))))
        for lat in ("LONG", "SHORT"):
            if e[lat] is None:
                continue
            ril = "lato %s (n %d): rapporto mediano %s -> %s" % (lat, sum(1 for v in voci if v[2] == lat), q4(e[lat]), banda(e[lat]))
            if ril not in out:
                prob.append("buffer %d: manca %r" % (b, ril))
    return prob


SC = {}
MUTA_SCRIPT = [None]


def lavora(nome):
    spec, att = SC[nome]
    return runna(nome, spec, att, MUTA_SCRIPT[0])


def main():
    solo = sys.argv[sys.argv.index("--solo") + 1] if "--solo" in sys.argv else None
    jobs = int(sys.argv[sys.argv.index("--jobs") + 1]) if "--jobs" in sys.argv else 4
    sc = scenari() + (scenari_lenti() if "--lenti" in sys.argv or (solo and solo.startswith("15")) else [])
    if solo:
        sc = [s for s in sc if s[0].startswith(solo)]
    SC.clear()
    SC.update({n: (s, a) for (n, s, a) in sc})
    # gli scenari con un FINTO terminal64/metaeditor64 vivo girano DA SOLI, uno alla volta: Get-Process vede i processi di tutta la macchina, e in parallelo
    # il finto terminale di uno scenario farebbe scattare la guardia "MT5 aperto" in tutti gli altri
    par = [n for (n, s, a) in sc if not s["mt5_vivo"]]
    ser = [n for (n, s, a) in sc if s["mt5_vivo"]]
    with Pool(jobs) as pool:                       # fork: i worker ereditano SC (le mutazioni sono funzioni, non si passano per pickle)
        ris = pool.map(lavora, par)
    ris = ris + [lavora(n) for n in ser]
    ok = 0
    for nome, prob, out in ris:
        if prob:
            print("ROSSO %s" % nome)
            for x in prob:
                print("      -", x)
            if "--verbose" in sys.argv:
                print(out[-3000:])
        else:
            ok += 1
            if "--elenco" in sys.argv:
                print("verde %s" % nome)
    print("BATTERIA R290A: %d/%d scenari verdi" % (ok, len(sc)))
    return 0 if ok == len(sc) else 1


if __name__ == "__main__":
    sys.exit(main())
