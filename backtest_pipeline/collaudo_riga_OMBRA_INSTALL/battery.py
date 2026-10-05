#!/usr/bin/env python3
# -*- coding: ascii -*-
"""
battery.py -- batteria di scenari per RIGA_OMBRA_INSTALL.ps1 su pwsh 7.4 con finto C: del VPS. Ogni scenario costruisce un disco finto da una SPECIFICA e controlla l'uscita contro le
ATTESE CALCOLATE DALLA SPECIFICA (fixture.attese + ATTESE.txt), mai contro un'uscita precedente. Controlli trasversali a ogni scenario: la riga ARRIVA in fondo (nessun `exit`), il finto
disco e' IDENTICO prima e dopo tranne l'UNICO file atteso (SCRITTURA MINIMA provata con l'hash di ogni file, e "STOP senza scrivere" = diff vuoto), referto + PRIMA + zip sul Desktop con i
file letti DALLO ZIP, uscita ASCII, "PROSSIMO PASSO" solo se installato (classe 22). Gli scenari non condividono stato globale (Get-Process e' sostituito: classe 1112): girano in parallelo.
Uso: python3 battery.py [--riga FILE] [--solo NOME] [--jobs N]   -> ultima riga "BATTERIA: n/m scenari verdi"
"""
import copy, hashlib, os, re, shutil, sys, tempfile, zipfile
from multiprocessing import Pool
import fixture as F
import run_one as R

QD = os.path.dirname(os.path.abspath(__file__))
TMP = os.environ.get("HARNESS_TMP") or tempfile.mkdtemp(prefix="ombat_")
ACC = F.ACC


def S(**kw):
    s = F.default_spec()
    s.update(kw)
    return s


def extra(hash_, profilo, eta=1.0):
    return dict(hash=hash_, profilo=profilo, eta=eta)


NOSTRO_V3 = dict(Id=4948, Name="terminal64", Title="V3", Path=F.TERM + " -V3\\terminal64.exe", Ws=2000000000, Pm=1500000000, Cpu=900.0, Delta=0.10)
NOSTRO = dict(Id=9452, Name="terminal64", Title="50503392", Path=F.TERM + "\\terminal64.exe", Ws=1234567890, Pm=987654321, Cpu=100.0, Delta=0.45)
DEF = F.procs_default(S())


def scenari():
    """(nome, spec, opzioni, atteso). atteso: esito OK|GIA|STOP|GUARDIA, stop (sottostringa del motivo), scrive (percorso relativo del file atteso nello snapshot, o None), extra: lista di funzioni."""
    sc = []
    pic = lambda prof=F.ADMIN, h=F.PICCOLO: "Users/%s/AppData/Roaming/MetaQuotes/Terminal/%s/MQL5/Experts/ABTG_EMA200_Ombra.mq5" % (prof, h)
    A = lambda **k: dict(k)
    sc.append(("01_base_tutto_ok", S(), dict(pin="a" * 40, sha="B" * 64), A(esito="OK", scrive=pic())))
    sc.append(("02_macchina_pc_backtest", S(macchina="DESKTOP-H4D7CAJ"), {}, A(esito="GUARDIA")))
    sc.append(("02b_macchina_quasi", S(macchina="VMI30477532"), {}, A(esito="GUARDIA")))
    # --- CE2/CE3: cartelle candidate
    sc.append(("03_due_vive_stesso_profilo", S(extra=[extra("AAAA1111BBBB2222CCCC3333DDDD4444", F.ADMIN)]), {}, A(esito="STOP", stop="DUE cartelle eleggibili", scrive=None)))
    sc.append(("03b_copia_morta_sotto_master", S(extra=[extra(F.PICCOLO, "Master", 700.0)]), {}, A(esito="OK", scrive=pic(), vedi=["copia NON toccata: ", "Master", "giornali vecchi di 700.0 ore"])))
    sc.append(("03c_viva_sotto_master_morta_nella_sessione", S(p_profilo="Master", extra=[extra(F.PICCOLO, F.ADMIN, 700.0)]), {},
               A(esito="OK", scrive=pic("Master"), vedi=["NON e il profilo di questa sessione", "ALTRO profilo utente", "copia NON toccata: "])))
    sc.append(("03d_due_vive_due_profili", S(extra=[extra(F.PICCOLO, "Master", 1.0)]), {}, A(esito="STOP", stop="DUE cartelle eleggibili", scrive=None)))
    sc.append(("03e_solo_copia_morta", S(p_logs=[(700.0, [ACC])], p_mql5logs_eta=700.0), {}, A(esito="STOP", stop="NESSUNA eleggibile", scrive=None, vedi=["giornali vecchi di 700.0 ore"])))
    # --- CE5/CE4: il conto
    sc.append(("04a_giornali_senza_login", S(p_logs=[(50.0, []), (1.0, [])]), {}, A(esito="STOP", stop="NESSUNA eleggibile", scrive=None, vedi=["conto NON trovato nei giornali"])))
    sc.append(("04b_logs_assenti", S(p_logs_dir=False, p_mql5logs_eta=None), {}, A(esito="STOP", stop="NESSUNA eleggibile", scrive=None, vedi=["conto NON trovato nei giornali (logs\\ assente)"])))
    sc.append(("04c_ultimo_altro_stesso_file", S(p_logs=[(1.0, [ACC, "10105439"])]), {}, A(esito="STOP", stop="NESSUNA eleggibile", scrive=None, vedi=["l ULTIMO login nei giornali e 10105439"])))
    sc.append(("04c2_ultimo_altro_file_diversi", S(p_logs=[(50.0, [ACC]), (1.0, ["10105439"])]), {}, A(esito="STOP", stop="NESSUNA eleggibile", scrive=None, vedi=["l ULTIMO login nei giornali e 10105439"])))
    sc.append(("04d_ultimo_nostro_stesso_file", S(p_logs=[(1.0, ["10105439", ACC])]), {}, A(esito="OK", scrive=pic())))
    sc.append(("04d2_ultimo_nostro_file_diversi", S(p_logs=[(50.0, ["10105439"]), (1.0, [ACC])]), {}, A(esito="OK", scrive=pic())))
    sc.append(("04e_ini_altro_login", S(p_ini="altro_login"), {}, A(esito="STOP", stop="NESSUNA eleggibile", scrive=None, vedi=["conti discordanti"])))
    # il tetto di lettura dei giornali (RAM libera ~1,8 GB sul VPS): patch DICHIARATA della costante a 0 -> il primo giornale non entra nel tetto
    sc.append(("04g_tetto_lettura_giornali", S(), dict(patch=[("$TettoLetturaMB = 100 ", "$TettoLetturaMB = 0 ")]), A(esito="STOP", stop="NESSUNA eleggibile", scrive=None, vedi=["tetto di lettura di 0 MB raggiunto dopo 0 giornali"])))
    sc.append(("04f_ini_assente", S(p_ini="assente"), {}, A(esito="OK", scrive=pic(), vedi=["profilo attivo NON determinato"])))
    # --- CE6: freschezza (soglia 72 h)
    sc.append(("05a_giornali_60_ore", S(p_logs=[(60.0, [ACC])], p_mql5logs_eta=60.0), {}, A(esito="OK", scrive=pic())))
    sc.append(("05b_giornali_200_ore", S(p_logs=[(200.0, [ACC])], p_mql5logs_eta=200.0), {}, A(esito="STOP", stop="NESSUNA eleggibile", scrive=None, vedi=["giornali vecchi di 200.0 ore"])))
    sc.append(("05c_solo_mql5logs_fresco", S(p_logs=[(200.0, [ACC])], p_mql5logs_eta=1.0), {}, A(esito="OK", scrive=pic())))
    # --- CE1/CE7: origin
    sc.append(("06a_solo_decoy_v3", S(piccolo=False, v3_conto_decoy=True), {}, A(esito="STOP", stop="nessuna cartella dati ha origin.txt", scrive=None)))
    sc.append(("06b_decoy_v3_col_piccolo", S(v3_conto_decoy=True), {}, A(esito="OK", scrive=pic())))
    sc.append(("06c_origin_utf8_bom", S(p_origin_enc="utf8bom"), {}, A(esito="OK", scrive=pic())))
    sc.append(("06d_origin_senza_bom", S(p_origin_enc="plain"), {}, A(esito="OK", scrive=pic())))
    sc.append(("06e_origin_maiuscole_e_barra", S(p_origin="c:\\PROGRAM FILES\\bcm markets mt5 terminal\\"), {}, A(esito="OK", scrive=pic())))
    # --- CE8: il file gia' presente
    sc.append(("07_gia_presente_uguale", S(existing="uguale"), {}, A(esito="GIA", scrive=None, mtime_uguale=True)))
    sc.append(("08_gia_presente_diverso", S(existing="diverso"), {}, A(esito="STOP", stop="DIVERSO", scrive=None, vedi=["versione dichiarata 1.02", "NON lo sovrascrivo e NON faccio copie con altro nome"])))
    sc.append(("08b_cartella_con_quel_nome", S(existing="cartella"), {}, A(esito="STOP", stop="CARTELLA", scrive=None)))
    # --- CE9: il download
    sc.append(("09a_sha_diverso", S(server="sha_diverso"), {}, A(esito="STOP", stop="IMPRONTA DIVERSA", scrive=None)))
    sc.append(("09b_sha_coerente_con_trading", S(server="coerente_trading"), {}, A(esito="STOP", stop="chiamate di trading o simili", scrive=None)))
    sc.append(("09c_versione_property", S(server="versione_property"), {}, A(esito="STOP", stop="manca #property version", scrive=None)))
    sc.append(("09d_versione_define", S(server="versione_define"), {}, A(esito="STOP", stop="manca #define OMBRA_VER", scrive=None)))
    sc.append(("09e_non_ascii", S(server="non_ascii"), {}, A(esito="STOP", stop="non e ASCII", scrive=None)))
    sc.append(("09f_server_404", S(server="404"), {}, A(esito="STOP", stop="404", scrive=None)))
    sc.append(("09g_server_giu", S(server="giu"), {}, A(esito="STOP", stop="STOP:", scrive=None)))
    # --- CE10: guasti iniettati (patch dichiarata sul testo dello script)
    P_OPEN = "        $fs = [IO.File]::Open($destNative, [IO.FileMode]::CreateNew,"
    P_WRITE = "$fs.Write($Bytes, 0, $Bytes.Length)"
    sc.append(("10a_race_file_creato_prima", S(), dict(patch=[(P_OPEN, "        [IO.File]::WriteAllBytes($destNative, [byte[]](1,2,3))\n" + P_OPEN)]),
               A(esito="STOP", stop="NON ha creato nessun file", scrive=pic(), contenuto=bytes([1, 2, 3]))))
    sc.append(("10b_scrittura_troncata", S(), dict(patch=[(P_WRITE, "$fs.Write($Bytes, 0, $Bytes.Length - 10)")]),
               A(esito="STOP", stop="lunghezza", scrive=None, vedi=["Il file parziale creato da questa corsa e stato TOLTO"])))
    sc.append(("10c_stessa_lunghezza_corrotta", S(), dict(patch=[(P_WRITE, "$Bytes[0] = [byte]88; " + P_WRITE)]),
               A(esito="STOP", stop="SHA256 riletto", scrive=None, vedi=["Il file parziale creato da questa corsa e stato TOLTO"])))
    # --- CE11: processi
    sc.append(("11a_nessun_terminale", S(procs=[]), {}, A(esito="OK", scrive=pic(), vedi=["RAM e CPU del terminale NON MISURATE", "working set: NON MISURATO"])))
    sc.append(("11b_path_negato", S(procs=[dict(NOSTRO, Path=None), DEF[1]]), {}, A(esito="OK", scrive=pic(), vedi=["cartella: ?"])))
    sc.append(("11c_solo_v3_in_esecuzione", S(procs=[NOSTRO_V3]), {}, A(esito="OK", scrive=pic(), vedi=["terminal64 con la cartella del piccolo (confronto sulla cartella INTERA, non sul prefisso): 0"])))
    sc.append(("11d_due_istanze_nostre", S(procs=[NOSTRO, dict(NOSTRO, Id=9999)]), {}, A(esito="OK", scrive=pic(), vedi=["PIU di un terminal64 col percorso del piccolo"])))
    sc.append(("11e_titolo_non_ascii", S(procs=[dict(NOSTRO, Title="caff\u00e8 \u20ac")]), {}, A(esito="OK", scrive=pic(), vedi=["titolo: caff? ?"])))
    sc.append(("11f_metaeditor_aperto", S(procs=DEF + [dict(Id=555, Name="metaeditor64", Title="MetaEditor", Path=F.TERM + "\\metaeditor64.exe", Ws=1, Pm=1, Cpu=1.0, Delta=0.0)]), {},
               A(esito="OK", scrive=pic(), vedi=["metaeditor64 in esecuzione: 1"])))
    # --- CE12 e RAM
    sc.append(("12_cim_fallisce", S(cim_ok=False), {}, A(esito="OK", scrive=pic(), vedi=["NON MISURATO (Get-CimInstance Win32_OperatingSystem non ha risposto)", "ROSSO se scende sotto 1024 MB"])))
    sc.append(("12b_ram_sotto_pavimento", S(libera_kb=900000), {}, A(esito="OK", scrive=pic(), vedi=["la RAM libera e GIA sotto il pavimento di 1024 MB"])))
    sc.append(("12c_ram_poco_margine", S(libera_kb=1650000), {}, A(esito="OK", scrive=pic(), vedi=["poco margine sopra il pavimento"])))
    # --- sedie
    sc.append(("13_profilo_attivo_non_determinato", S(p_profile_last=None), {}, A(esito="OK", scrive=pic(), vedi=["profilo attivo NON determinato"])))
    sc.append(("13b_ombra_gia_attaccata", S(ombra_attaccata=True), {}, A(esito="OK", scrive=pic(), vedi=["NEL PROFILO ATTIVO C E GIA UN GRAFICO CON L OMBRA"])))
    sc.append(("13c_chr_illeggibili", S(chr_vuoto=2), {}, A(esito="OK", scrive=pic())))
    # --- varie
    sc.append(("14_senza_desktop", S(senza_desktop=True), {}, A(esito="OK", scrive=pic())))
    sc.append(("15_senza_cartella_experts", S(p_experts=False), {}, A(esito="STOP", stop="NESSUNA eleggibile", scrive=None, vedi=["manca MQL5\\Experts"])))
    sc.append(("16_ex5_gia_presente", S(ex5=True), {}, A(esito="OK", scrive=pic(), vedi=["esiste GIA un ABTG_EMA200_Ombra.ex5"])))
    return sc


def esito_atteso_txt(a):
    return {"OK": "INSTALLATO", "GIA": "GIA PRESENTE UGUALE (non riscritto)", "STOP": "FERMATO -- ", "GUARDIA": None}[a["esito"]]


def valuta(nome, spec, opz, att, r, prima, dopo, zips, mtimes):
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

    if any(ord(ch) > 126 for ch in out):
        err.append("l'uscita non e' ASCII puro")
    # --- la guardia macchina: muore PRIMA di tutto
    if att["esito"] == "GUARDIA":
        must("QUESTA RIGA GIRA SOLO SUL VPS VMI3047753", out + r["stderr"])
        mustnot("FINE-HARNESS-ARRIVATO", None, "la guardia deve fermare prima di tutto")
        mustnot("=== 1. TERMINALI")
        if r["files"]:
            err.append("la guardia e' scattata MA ha scritto sul Desktop: %s" % r["files"])
        if r["hits"] != 0:
            err.append("la guardia macchina e' scattata DOPO una richiesta di rete (%d)" % r["hits"])
        if prima != dopo:
            err.append("la guardia macchina ha lasciato il disco cambiato")
        return err
    must("FINE-HARNESS-ARRIVATO", None, "la riga e' arrivata in fondo: nessun exit dentro Invoke-Expression")
    # --- la scrittura: SOLO il file atteso (A2)
    diff = sorted(set(prima) ^ set(dopo)) + sorted(k for k in prima if k in dopo and prima[k] != dopo[k])
    atteso_diff = [att["scrive"]] if att.get("scrive") else []
    if sorted(diff) != sorted(atteso_diff):
        err.append("DIFF DEL DISCO: atteso %s, trovato %s" % (atteso_diff, diff[:6]))
    if att.get("scrive") and att["esito"] == "OK" and not att.get("contenuto"):
        h = dopo.get(att["scrive"])
        if h is None or h.upper() != F.EA_SHA:
            err.append("il file scritto non ha lo SHA256 atteso: %s" % h)
    if att.get("contenuto") is not None:
        p = os.path.join(r["cdrive"], *att["scrive"].split("/"))
        if not os.path.exists(p) or open(p, "rb").read() != att["contenuto"]:
            err.append("il file ALTRUI creato prima della scrittura e' stato sovrascritto o cancellato")
    if att.get("mtime_uguale") and mtimes[0] != mtimes[1]:
        err.append("il file gia' presente e' stato RISCRITTO (data di modifica cambiata)")
    # --- raccolta (A3)
    if len(r["txt"]) != 1 or len(r["pri"]) != 1 or len(r["zips"]) != 1:
        err.append("attesi 1 referto, 1 PRIMA e 1 zip sul Desktop, trovati %s" % r["files"])
    else:
        zn, entries = zips
        if entries != sorted([r["txt"][0], r["pri"][0]]):
            err.append("contenuto dello zip diverso: %s" % entries)
        must("FILE PRESENTI NELLO ZIP (letti dallo zip, non dal piano): " + ", ".join(sorted([r["txt"][0], r["pri"][0]])))
        must("MANCANTI: nessuno")
        if zn != r["txt"][0][:-4] + ".zip":
            err.append("nome zip != nome referto")
    if spec["senza_desktop"] and r["desk"].endswith("Desktop"):
        err.append("senza Desktop la riga doveva ripiegare su USERPROFILE")
    if not spec["senza_desktop"] and not r["desk"].endswith("Desktop"):
        err.append("con il Desktop presente l'output doveva stare li'")
    # --- esito, coda "prossimo passo" (classe 22)
    et = esito_atteso_txt(att)
    must("ESITO OMBRA INSTALL: " + et)
    must("ESITO OMBRA INSTALL: " + et, ref, "l'esito deve stare anche nel referto")
    if att["esito"] in ("OK", "GIA"):
        must("PROSSIMO PASSO (a mano, DENTRO MT5 del conto 50503392")
        must("NON e stato compilato ne attaccato niente da questa riga")
        mustnot("STOP:")
    else:
        mustnot("PROSSIMO PASSO", None, "la coda del prossimo passo solo se il file c'e' (classe 22)")
        must("STOP: ")
        if att.get("stop"):
            i0 = out.find("STOP: ")
            if i0 >= 0 and att["stop"] not in out[i0:]:
                err.append("MANCA nel motivo dello STOP: " + att["stop"])
            # il motivo deve stare ANCHE nella riga d'esito (la riga che Claudio legge e manda)
            m = re.search(r"^ESITO OMBRA INSTALL: FERMATO -- (.*)$", out, re.M)
            if m is None or (att.get("stop") and att["stop"] != "STOP:" and att["stop"] not in m.group(1)):
                err.append("la riga ESITO non porta il motivo dello STOP: " + att.get("stop", ""))
    for v in att.get("vedi", []):
        must(v)
    # --- pin/sha del bootstrap
    if nome == "01_base_tutto_ok":
        must("pin riga ........ " + "a" * 40)
        must("sha256 riga ..... " + "B" * 64)
    else:
        must("pin riga ........ non dichiarato (script lanciato senza bootstrap)")
    # --- tabella dei processi, RAM, CPU, soglie (attese dalla specifica)
    nproc = len(F.procs_default(spec)) if spec["procs"] == "default" else len(spec["procs"] or [])
    nproc = len([p for p in (F.procs_default(spec) if spec["procs"] == "default" else spec["procs"]) if p["Name"] == "terminal64"])
    n_pid = len(re.findall(r"^   PID \d+  \| titolo: ", out, re.M))
    if n_pid != nproc:
        err.append("righe PID: %d, attese %d" % (n_pid, nproc))
    marche = out.count("<== IL NOSTRO (piccolo, conto 50503392)")
    if marche != a["nostri"]:
        err.append("marcatori IL NOSTRO: %d, attesi %d (il percorso del -V3 inizia come quello del piccolo: NON e' il piccolo)" % (marche, a["nostri"]))
    must("terminal64 in esecuzione: %d" % nproc)
    if a["nostri"] == 0:
        mustnot("PID del terminal64 del piccolo da guardare", None, "senza terminale del piccolo in esecuzione non c'e' nessun PID da indicare")
    must("terminal64 con la cartella del piccolo (confronto sulla cartella INTERA, non sul prefisso): %d" % a["nostri"])
    if a["libera_mb"] is not None:
        must("RAM del VPS: totale %d MB, libera %d MB [MISURATO]" % (a["totale_mb"], a["libera_mb"]))
        must("ROSSO se scende sotto %d MB (pavimento 1024 MB, oppure 800 MB meno del numero di partenza %d MB)" % (a["rosso_libera"], a["libera_mb"]))
    if a["nostri"] >= 1:
        must("terminal64 del piccolo, working set: %d MB [MISURATO]   memoria privata: %d MB [MISURATO]" % (a["ws_mb"], a["pm_mb"]))
        must("terminal64 del piccolo, CPU media su 5 secondi: %.1f %% di UN core = %.1f %% su 6 core" % (a["cpu_pct"], a["cpu_su_6"]))
        must("PID del terminal64 del piccolo da guardare nella Gestione attivita (scheda Dettagli, colonna PID): %s   (tasto destro sulla riga -> Apri percorso file: deve aprire C:\\Program Files\\BCM Markets MT5 Terminal)" % a["pids"])
        must("GIALLO oltre %d MB" % a["giallo"])
        must("ROSSO oltre %d MB (+800)" % a["rosso"])
    must("di piu di 5.0 punti percentuali su 6 core (= 30 % di UN core")
    # --- sedie (A4)
    if att["esito"] != "STOP" or att.get("scrive"):
        pass
    scelta_ok = att["esito"] in ("OK", "GIA") or (att["esito"] == "STOP" and att.get("scrive"))
    if scelta_ok and spec["p_profile_last"] and spec["p_ini"] != "assente":
        must("sedie nel profilo attivo ORO (grafici con un EA, dai .chr salvati): %d   su %d grafici, illeggibili %d" % (a["sedie"], a["grafici"], spec["chr_vuoto"]),
             None, "solo il profilo ATTIVO: contarli tutti darebbe %d" % (a["sedie"] + spec["chr_residuo"]))
    return err


def runna(args):
    nome, spec, opz, att, riga = args
    b = tempfile.mkdtemp(prefix="s_", dir=TMP)
    try:
        c = F.costruisci(b, spec)
        prima = F.snapshot(c, spec["utente"])
        dest = os.path.join(c, "Users", spec["p_profilo"], *F.APPREL, spec["p_hash"], "MQL5", "Experts", "ABTG_EMA200_Ombra.mq5")
        m0 = os.path.getmtime(dest) if os.path.exists(dest) and not os.path.isdir(dest) else None
        o = dict(opz)
        r = R.esegui(spec, c, riga=riga, **o)
        r["cdrive"] = c
        dopo = F.snapshot(c, spec["utente"])
        m1 = os.path.getmtime(dest) if os.path.exists(dest) and not os.path.isdir(dest) else None
        z = None
        if r["zips"]:
            p = os.path.join(r["desk"], r["zips"][0])
            z = (r["zips"][0], sorted(os.path.basename(n) for n in zipfile.ZipFile(p).namelist()))
        return nome, valuta(nome, spec, opz, att, r, prima, dopo, z, (m0, m1))
    finally:
        shutil.rmtree(b, ignore_errors=True)


def main():
    riga = R.RIGA_DEFAULT
    if "--riga" in sys.argv:
        riga = sys.argv[sys.argv.index("--riga") + 1]
    jobs = int(sys.argv[sys.argv.index("--jobs") + 1]) if "--jobs" in sys.argv else 4
    solo = sys.argv[sys.argv.index("--solo") + 1] if "--solo" in sys.argv else None
    sc = [s for s in scenari() if (solo is None or s[0].startswith(solo))]
    args = [(n, sp, op, at, riga) for (n, sp, op, at) in sc]
    with Pool(jobs) as p:
        res = p.map(runna, args)
    ko = 0
    for nome, err in res:
        if err:
            ko += 1
            print("  ROSSO %s" % nome)
            for e in err[:8]:
                print("       " + e)
    print("BATTERIA: %d/%d scenari verdi" % (len(res) - ko, len(res)))
    return 0 if ko == 0 else 1


if __name__ == "__main__":
    sys.exit(main())
