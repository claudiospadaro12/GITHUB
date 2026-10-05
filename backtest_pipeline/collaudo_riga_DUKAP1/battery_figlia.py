#!/usr/bin/env python3
# -*- coding: ascii -*-
"""
battery_figlia.py -- collaudo DIFFERENZIALE della riga figlia RIGA_DUKA_IMPORT_SONDA.ps1 v2 (la condizione (1) della F2 PER NOME) contro il valutatore python leggi_f2_dk.py.
Due implementazioni indipendenti della stessa regola (PowerShell nella figlia, python nel valutatore) sullo STESSO file per giorno: devono dare lo stesso stato per ciascun giorno nominato.
In piu', per ogni caso, lo stato atteso di alcuni giorni e' scritto A MANO qui (cosi' non possono sbagliare insieme). La figlia gira DAVVERO in pwsh sul finto C: (terminale finto: sim_mt5.py).
Controlla anche: il codice d'uscita (0 solo se verdetto OK E tutti dentro per nome; 4 se verdetto OK ma no; 3 quasi; 1 chiuso o fermata), che -Maschera sbagliata fermi PRIMA di copiare, che -PulisciFiles tolga SOLO i copiati,
che un file estraneo che combacia con la maschera fermi la riga.
Uso: python3 battery_figlia.py [--jobs N]   -> ultima riga "FIGLIA: n/m casi verdi"
"""
import copy, os, re, shutil, sys, tempfile
from multiprocessing import Pool
import h1
sys.path.insert(0, h1.DUK)
import leggi_f2_dk as L

TMP = os.environ.get("HARNESS_TMP") or tempfile.mkdtemp(prefix="p1fig_")
G = h1.GIORNI9
V = "IMP-TICK-v1-GIORNI"
OKR = lambda g, med="0.03000000", cop="99.0000", **kw: L._riga_g("U30USD_DK", g, med, cop, **kw)


def righe_ok(over=None, tolti=(), extra=()):
    d = {g: OKR(g) for g in G}
    for g, r in (over or {}).items():
        d[g] = r
    return [r for g, r in d.items() if g not in tolti] + list(extra)


def casi():
    c = []
    # nome, spec, args extra (stringa PS), stati attesi A MANO {giorno: stato}, rc atteso, frasi attese nell'uscita
    c.append(("01_tutti_dentro", {}, "", {g: "DENTRO" for g in G}, 0, ["PER NOME: 9 su 9 giorni NOMINATI dentro per nome", "VERDETTO:    OK: CANCELLO PASSATO"]))
    c.append(("02_non_confrontabile_8_su_8", dict(scen_dk={**{g: ["MISURATO", "0.03", "99.0"] for g in G}, "2024.11.20": ["NON_CONFRONTABILE"]}), "", {"2024.11.20": "NON_CONFRONTABILE", "2025.06.10": "DENTRO"}, 4,
              ["8/8 giorni dentro soglia", "OK: CANCELLO PASSATO", "PER NOME: 8 su 9"]))
    c.append(("03_riga_assente_saltata_in_silenzio", dict(righe_grezze={"U30USD_DK": righe_ok(tolti=("2024.11.20",))}), "", {"2024.11.20": "ASSENTE"}, 4, ["OK: CANCELLO PASSATO"]))
    c.append(("04_giorno_ripetuto", dict(righe_grezze={"U30USD_DK": righe_ok(extra=(OKR("2025.03.25"),))}), "", {"2025.03.25": "RIPETUTO", "2025.03.12": "DENTRO"}, 4, []))
    c.append(("05_fuori_soglia", dict(scen_dk={**{g: ["MISURATO", "0.03", "99.0"] for g in G}, "2024.12.10": ["MISURATO", "0.07", "99.0"]}), "", {"2024.12.10": "FUORI"}, 3, ["QUASI"]))
    c.append(("06_copertura_79_99", dict(scen_dk={**{g: ["MISURATO", "0.03", "99.0"] for g in G}, "2024.10.31": ["MISURATO", "0.01", "79.99"]}), "", {"2024.10.31": "FUORI"}, 3, []))
    c.append(("07_bordo_esatto", dict(scen_dk={**{g: ["MISURATO", "0.03", "99.0"] for g in G}, "2024.12.10": ["MISURATO", "0.05", "80.0"]}), "", {"2024.12.10": "DENTRO"}, 0, []))
    c.append(("08_appena_sopra", dict(scen_dk={**{g: ["MISURATO", "0.03", "99.0"] for g in G}, "2024.12.10": ["MISURATO", "0.05000001", "99.0"]}), "", {"2024.12.10": "FUORI"}, 3, []))
    c.append(("09_passa_discorde", dict(righe_grezze={"U30USD_DK": righe_ok({"2024.12.10": OKR("2024.12.10", "0.07000000", "99.0000", passa="SI")})}), "", {"2024.12.10": "DISCORDANZA"}, 4, []))
    c.append(("10_soglie_diverse", dict(righe_grezze={"U30USD_DK": righe_ok({"2024.12.10": OKR("2024.12.10", sd="0.06000000")})}), "", {"2024.12.10": "SOGLIA_DIVERSA"}, 4, []))
    c.append(("11_mediana_non_numerica", dict(righe_grezze={"U30USD_DK": righe_ok({"2024.12.10": OKR("2024.12.10", "boh", "99.0000", passa="SI")})}), "", {"2024.12.10": "NON_VALIDO"}, 4, []))
    c.append(("12_data_malformata", dict(), "-GiorniSonda '2024.11.20;boh'", {"2024.11.20": "DENTRO", "boh": "DATA_MALFORMATA"}, 4, ["PER NOME: 1 su 2"]))
    c.append(("13_righe_di_altro_simbolo", dict(righe_grezze={"U30USD_DK": righe_ok(extra=(L._riga_g("U30USD_DKNEG", "2025.03.12", "0.09000000", "95.0000"),))}), "", {g: "DENTRO" for g in G}, 3, ["ATTRIBUZIONE INCOERENTE", "QUASI"]))
    c.append(("13b_altro_simbolo_con_verdetto_OK", dict(righe_grezze={"U30USD_DK": righe_ok(extra=(L._riga_g("U30USD_DKNEG", "2025.03.12", "0.03000000", "99.0000"),))}), "", {g: "DENTRO" for g in G}, 4, ["ATTRIBUZIONE INCOERENTE", "OK: CANCELLO PASSATO"]))
    c.append(("14_simbolo_swap_il_dk_ha_il_simbolo_neg", dict(righe_grezze={"U30USD_DK": righe_ok({"2025.03.12": L._riga_g("U30USD_DKNEG", "2025.03.12", "0.03000000", "99.0000")})}), "", {"2025.03.12": "ASSENTE"}, 4, ["ATTRIBUZIONE INCOERENTE"]))
    c.append(("15_esito_vuoto", dict(righe_grezze={"U30USD_DK": righe_ok({"2024.12.10": L._riga_g("U30USD_DK", "2024.12.10", "-", "-", esito="")})}), "", {"2024.12.10": "ESITO_VUOTO"}, 4, []))
    c.append(("16_verdetto_chiuso", dict(scen_dk={g: ["MISURATO", "0.30", "99.0"] for g in G}), "", {g: "FUORI" for g in G}, 1, ["CANCELLO CHIUSO"]))
    c.append(("17_maschera_larga_ferma_prima_di_copiare", {}, "-Maschera '*.csv'", {}, 1, ["MASCHERA '*.csv' non comincia con 'U30USD_DK_ticks_'"]))
    c.append(("18_giorni_vuoti", {}, "-GiorniSonda ''", {}, 1, ["-GiorniSonda vuoto"]))
    c.append(("19_file_estraneo_che_combacia", dict(files_stale=["U30USD_DK_ticks_2025-07.csv"]), "", {}, 1, ["FILE ESTRANEI in MQL5\\Files", "U30USD_DK_ticks_2025-07.csv"]))
    c.append(("21_work_stale_non_finisce_nello_zip", dict(non_scrive=["U30USD_DK"]), "", {}, 1, ["TIMEOUT: nessun segno di vita"]))
    c.append(("20_pulisci_files_toglie_solo_i_copiati", dict(files_stale=["ALTRO_tieni.csv"]), "-PulisciFiles", {g: "DENTRO" for g in G}, 0, ["pulizia MQL5\\Files: rimossi 9 di 9 CSV copiati da questa corsa"]))
    return c


def runna(nome, kw, extra, attesi, rc_att, frasi):
    b = tempfile.mkdtemp(prefix="f_", dir=TMP)
    srv = None
    err = []
    try:
        spec = h1.spec_base(**kw)
        c = h1.costruisci(b, spec)
        srv = h1.Srv(spec)
        rf = os.path.join(b, "figlia.ps1")
        open(rf, "wb").write(srv.files[h1.FILE_IMP])
        args = "-Pin %s -ShaMq5 %s -SimboloDK U30USD_DK -WorkDir '%s' %s" % (spec["pin"], srv.sha(h1.FILE_MQ5), os.path.join(b, "w"), extra)
        if "-GiorniSonda" not in extra:
            args += " -GiorniSonda '%s'" % ";".join(G)
        if nome.startswith("21_work_stale"):      # un file per giorno di una corsa PRECEDENTE nella cartella di lavoro: non deve finire nello zip di questa
            os.makedirs(os.path.join(b, "w"))
            open(os.path.join(b, "w", "ABTG_ImportTick_giorni_U30USD_DK.csv"), "w").write("STALE\n")
        fuori0 = h1.snapshot(c)
        p = h1.esegui(spec, c, rf, args, srv, b)
        fuori1 = h1.snapshot(c)
        out = p.stdout
        if fuori0 != fuori1:
            err.append("scritture fuori dal perimetro: %s" % sorted(set(fuori0) ^ set(fuori1))[:5])
        if any(ord(ch) > 126 for ch in out):
            err.append("uscita non ASCII")
        m = re.search(r"FINE-HARNESS rc=(\d+)", out)
        if not m or int(m.group(1)) != rc_att:
            err.append("codice d'uscita %s invece di %d" % (m.group(1) if m else "?", rc_att))
        for f in frasi:
            if f not in out:
                err.append("MANCA: " + f)
        # stati della figlia, parsati dall'uscita
        ps = {}
        for l in out.splitlines():
            mm = re.search(r"\]\s+(\S+)\s+(DENTRO|FUORI|NON_CONFRONTABILE|ASSENTE|RIPETUTO|NON_VALIDO|SOGLIA_DIVERSA|DISCORDANZA|DATA_MALFORMATA|ESITO_VUOTO)\s+(\S+)\s+(\S+)\s*$", l)
            if mm:
                ps[mm.group(1)] = mm.group(2)
        for g, s in attesi.items():
            if ps.get(g) != s:
                err.append("figlia: %s atteso %s, uscito %s" % (g, s, ps.get(g)))
        # confronto con il valutatore python sullo stesso file
        gcsv = os.path.join(c, "Users", "Master", "AppData", "Roaming", "MetaQuotes", "Terminal", "ABC123", "MQL5", "Files", "ABTG_ImportTick_giorni.csv")
        if os.path.exists(gcsv) and attesi:
            righe = L.leggi_csv(open(gcsv, newline="").read(), L.COL_GIORNI, "giorni")
            lista = [d for d in ps]
            for g in lista:
                stp = L.stato_giorno(righe, "U30USD_DK", g)[0]
                if stp != ps[g]:
                    err.append("DIFFERENZIALE: %s figlia %s, valutatore python %s" % (g, ps[g], stp))
        if nome.startswith("21_work_stale"):
            import zipfile
            zs = [x for x in os.listdir(os.path.join(c, "Users", "Master", "Desktop")) if x.endswith(".zip")]
            for zz in zs:
                nomi_z = zipfile.ZipFile(os.path.join(c, "Users", "Master", "Desktop", zz)).namelist()
                if any("giorni_U30USD_DK" in x for x in nomi_z):
                    err.append("il file per giorno STALE della cartella di lavoro e' finito nello zip: %s" % nomi_z)
        # pulizia
        files = os.path.join(c, "Users", "Master", "AppData", "Roaming", "MetaQuotes", "Terminal", "ABC123", "MQL5", "Files")
        nomi = sorted(os.listdir(files))
        if "-PulisciFiles" in extra:
            if any(n.startswith("U30USD_DK_ticks_") for n in nomi):
                err.append("-PulisciFiles non ha tolto i copiati: %s" % nomi)
            if "ALTRO_tieni.csv" not in nomi:
                err.append("-PulisciFiles ha tolto un file che non aveva copiato")
        if "Maschera" in extra and any(n.startswith("U30USD_DK_ticks_") for n in nomi):
            err.append("la maschera sbagliata ha fermato DOPO aver copiato")
        if "file_estraneo" in nome and any(n.startswith("U30USD_DK_ticks_2024") for n in nomi):
            err.append("il file estraneo ha fermato DOPO aver copiato")
        return nome, err
    finally:
        if srv: srv.chiudi()
        shutil.rmtree(b, ignore_errors=True)


def main():
    jobs = int(sys.argv[sys.argv.index("--jobs") + 1]) if "--jobs" in sys.argv else 4
    with Pool(jobs) as p:
        res = p.starmap(runna, casi())
    verdi = 0
    for nome, err in res:
        if not err:
            verdi += 1
        else:
            print("ROSSO " + nome)
            for e in err[:6]:
                print("     - " + e[:300])
    print("FIGLIA: %d/%d casi verdi" % (verdi, len(res)))
    return 0 if verdi == len(res) else 1


if __name__ == "__main__":
    sys.exit(main())
