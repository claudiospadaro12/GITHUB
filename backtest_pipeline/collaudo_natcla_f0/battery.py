#!/usr/bin/env python3
# -*- coding: ascii -*-
"""
battery.py -- la BATTERIA di scenari del banco di NATCLA_F0_PASSATE.ps1. Ogni scenario costruisce un finto PC di backtest, lancia lo script VERO (pwsh 7) con terminale e MetaEditor finti
(sim_mt5.py) e controlla: codice d'uscita, messaggi, cosa e' stato lanciato (ini vere lette dal finto terminale), cosa e' finito nello zip, e che i file FUORI dal perimetro dichiarato (le due
installazioni censite, i grafici, il resto del disco) non siano cambiati di un byte. E' il collaudo FUNZIONALE: lo strato statico (controlla_riga) non sa se lo script fa quello che promette.
Uso: python3 -I backtest_pipeline/collaudo_natcla_f0/battery.py [--rapido]   (--rapido salta i lotti A, C, D e il timeout reale)
"""
import io, json, os, re, shutil, sys, tempfile, time, zipfile

QD = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, QD)
import banco as B

REPO = B.REPO
ESITI = []


def chk(nome, cond, det=""):
    ESITI.append((nome, bool(cond), det))
    print("  %s %s%s" % ("OK  " if cond else "FAIL", nome, ("   [" + str(det)[:300] + "]") if (det and not cond) else ""), flush=True)


def rc_di(p):
    m = re.search(r"FINE-HARNESS rc=(\S+)", p.stdout)
    return m.group(1) if m else None


def lanci(scen_dir):
    f = os.path.join(scen_dir, "simlog", "sim_terminale_lanci.txt")
    return [l for l in open(f).read().splitlines() if not l.startswith("LANCIO")] if os.path.exists(f) else []


def zip_di(c, lotto="PILOTA"):
    z = os.path.join(c, "Users", "Master", "Desktop", "NATCLA_F0_%s.zip" % lotto)
    return zipfile.ZipFile(z) if os.path.exists(z) else None


def manifest(z):
    import csv
    return list(csv.DictReader(io.StringIO(z.read("MANIFEST_F0.csv").decode("ascii")), delimiter=";"))


def scenario(nome, base, **kw):
    spec = B.spec_base(**kw)
    d = tempfile.mkdtemp(dir=base, prefix="s_")
    c = B.costruisci(d, spec)
    prima = B.snapshot(c)
    srv = B.Srv(spec)
    sd = os.path.join(d, "scen"); os.makedirs(sd)
    t0 = time.time()
    p = B.esegui(spec, c, srv, sd)
    dopo = B.snapshot(c)
    srv.chiudi()
    return dict(p=p, c=c, sd=sd, prima=prima, dopo=dopo, srv=srv, dur=time.time() - t0, spec=spec)


def tocca_perimetro(r):
    """il disco FUORI dal perimetro dichiarato e' identico prima e dopo?"""
    return r["prima"] == r["dopo"]


def prova_mut(f):
    return lambda b: f(b.decode("ascii")).encode("ascii")


def main():
    rapido = "--rapido" in sys.argv
    base = tempfile.mkdtemp(prefix="nc_battery_")
    try:
        # ---------------------------------------------------------------- S01 il pilota, tutto verde
        print("S01 PILOTA verde")
        r = scenario("S01", base)
        p = r["p"]
        chk("S01 rc 0 e esito 'TUTTE LE PASSATE OK'", rc_di(p) == "0" and "ESITO F0: TUTTE LE PASSATE OK" in p.stdout, p.stdout[-800:] + p.stderr[-500:])
        z = zip_di(r["c"])
        chk("S01 zip sul Desktop", z is not None)
        m = manifest(z)
        chk("S01 MANIFEST: 8 passate, tutte OK, ordine simbolo x config", len(m) == 8 and all(x["stato"] == "OK" for x in m) and [(x["simbolo"], x["config"]) for x in m][:4] == [("EURUSD", "AUDIO_H1"), ("EURUSD", "M2_H1"), ("GBPUSD", "AUDIO_H1"), ("GBPUSD", "M2_H1")])
        nomi = z.namelist()
        chk("S01 zip: 8 CSV, 8 log, 8 ini, compile log, prova, riepilogo, manifest",
            sum(n.startswith("csv/") for n in nomi) == 8 and sum(n.startswith("log/") for n in nomi) == 8 and sum(n.startswith("ini/") for n in nomi) == 8 and
            all(x in nomi for x in ("compile_natcla.log", "NATCLA_F0_conteggio_2026-10-07.txt", "RIEPILOGO_F0.txt", "MANIFEST_F0.csv")), nomi)
        la = lanci(r["sd"])
        chk("S01 terminale lanciato 8 volte, sempre Optimization=0 Model=1 Live=false Dll=false SoloConta=true",
            len(la) == 8 and all("Optimization=0 Model=1 Live=false Dll=false SoloConta=true" in x for x in la), la)
        chk("S01 modalita/TF delle 8 passate: AUDIO H1 e EMA200 H1 alternate", [re.search(r"Modalita=(\d) TF=(\d+)", x).groups() for x in la] == [("0", "16385"), ("2", "16385")] * 4, la)
        chk("S01 InpMagic=0 nell'ini (magic automatico)", all(re.search(r"Magic=0 ", x) for x in la))
        ini1 = z.read("ini/f0_XAUUSD_M2_H1.ini").decode("ascii")
        chk("S01 ini: una sola InpModalita, una sola InpTF, InpSoloConta=true, nessun InpMagic doppio, 72 input",
            ini1.count("InpModalita=") == 1 and ini1.count("InpTF=") == 1 and "InpSoloConta=true" in ini1 and ini1.count("InpMagic=") == 1 and ini1.split("[TesterInputs]")[1].strip().count("\n") + 1 == 72 and
            "Symbol=XAUUSD" in ini1 and "FromDate=2024.07.10" in ini1 and "ToDate=2026.06.30" in ini1 and "Model=1" in ini1 and "Optimization=0" in ini1 and "AllowLiveTrading=false" in ini1, ini1)
        chk("S01 ini senza Report= (nessun .htm da raccogliere) e senza Spread= (come tutti i round di casa)", "Report=" not in ini1 and "Spread=" not in ini1)
        ea = open(os.path.join(r["sd"], "simlog", "sim_args_editor.txt")).read()
        chk("S01 MetaEditor chiamato con DUE argomenti (/compile e /log), classe 1152", len(json.loads(ea)) == 2)
        chk("S01 scaricati al pin: EA, include, prova", sorted(set(x.split("?")[0].split("/", 2)[2] for x in r["srv"].hits)) == sorted([B.F_EA, B.F_INC, B.F_PROVA]), r["srv"].hits)
        chk("S01 il disco fuori dal perimetro non e' cambiato (censite, grafici, origin.txt)", tocca_perimetro(r))
        ds = os.path.join(r["c"], "Users", "Master", "Desktop")
        chk("S01 stampa la stima da misura ('STIMA F0 INTERA') e il tempo", "STIMA F0 INTERA" in z.read("RIEPILOGO_F0.txt").decode("ascii"))
        # il lettore sul zip prodotto: il giro driver -> lettore
        import subprocess
        zpath = os.path.join(ds, "NATCLA_F0_PILOTA.zip")
        out = subprocess.run([sys.executable, "-I", os.path.join(REPO, "backtest_pipeline", "leggi_natcla_f0.py"), zpath], capture_output=True, text=True)
        chk("S01 il LETTORE legge lo zip del driver: 8 passate OK, VERIFICA ADX MetaQuotes x8, nessun KO", out.returncode == 0 and "PASSATE LETTE: 8    stato OK dopo i controlli del lettore: 8" in out.stdout and "MetaQuotes 8" in out.stdout, out.stdout[:600] + out.stderr[-400:])

        # ---------------------------------------------------------------- guardie: si ferma PRIMA di toccare
        print("S02-S09 guardie")
        def ferma(nome, msg, **kw):
            rr = scenario(nome, base, **kw)
            pp = rr["p"]
            chk("%s: si ferma (rc diverso da 0), messaggio '%s', nessun terminale lanciato, niente sul Desktop" % (nome, msg), rc_di(pp) != "0" and msg in (pp.stdout + pp.stderr) and not lanci(rr["sd"]) and
                zip_di(rr["c"]) is None and not os.path.exists(os.path.join(rr["c"], "Users", "Master", "Desktop", "NATCLA_F0_PILOTA")), (pp.stdout + pp.stderr)[-700:])
            return rr
        ferma("S02 macchina diversa (VPS)", "gira SOLO sul PC di backtest", macchina="VMI3047753")
        ferma("S03 terminal64 vivo", "APERTO", mt5_vivo="terminal64")
        ferma("S04 metaeditor64 vivo", "APERTO", mt5_vivo="metaeditor64")
        ferma("S05 sedia attaccata a un grafico", "SEDIE ATTACCATE", chr=[{}, {"ea": "ABTG_Qualcosa"}])
        ferma("S06 grafico illeggibile", "ILLEGGIBILE", chr=[{"illeggibile": True}])
        ferma("S07 installazione non censita", "NON censite", altra_inst=True)
        ferma("S08 due cartelle dati per il BCM", "NON risolta in modo univoco", doppio_dati=True)
        ferma("S09 zero grafici letti", "ZERO grafici", chr=[])
        ferma("S10 mutex occupato da un altro giro", "ALTRO giro", mutex_occupato=True)
        rab = scenario("S10b", base, mutex_abbandonato=True)
        chk("S10b blocco lasciato da un giro MORTO (kill -9): il giro successivo non resta bloccato per sempre, gira (8 passate OK, rc 0). Su Linux .NET non solleva l'eccezione di mutex abbandonato: il ramo catch AbandonedMutexException e' NON PROVATO qui", rc_di(rab["p"]) == "0" and "TUTTE LE PASSATE OK" in rab["p"].stdout, rab["p"].stdout[:600] + rab["p"].stderr[-300:])
        ferma("S11 SHA256 dell'EA diverso da quello della riga", "SHA256", sha_override={"ea": "0" * 64})
        ferma("S12 SHA256 della prova diverso", "SHA256", sha_override={"prova": "1" * 64})
        ferma("S13 SHA256 dell'include diverso", "SHA256", sha_override={"inc": "2" * 64})
        ferma("S14 EA servito con NC_VER 1.03 (SHA coerente con quello servito)", "NC_VER", muta={B.F_EA: lambda b: b.replace(b'#define NC_VER "1.04"', b'#define NC_VER "1.03"')})
        ferma("S15 prova con InpSoloConta=false (mandera' ordini)", "InpSoloConta=true", muta={B.F_PROVA: prova_mut(lambda t: t.replace("InpSoloConta=true", "InpSoloConta=false"))})
        ferma("S16 prova con un pin in meno", "pin letti dal file prova", muta={B.F_PROVA: prova_mut(lambda t: t.replace("InpPlaceboAtr=0\n", ""))})
        ferma("S17 prova con asse tecnico diverso", "asse del file prova", muta={B.F_PROVA: prova_mut(lambda t: t.replace("InpMagic=0||0||1||1||Y", "InpMagic=0||0||2||2||Y"))})
        ferma("S18 prova con pin doppio (stesso numero di righe: InpPlaceboAtr diventa un secondo InpSoloConta)", "DOPPI", muta={B.F_PROVA: prova_mut(lambda t: t.replace("InpPlaceboAtr=0\n", "InpSoloConta=true\n"))})
        ferma("S19 lotto con un simbolo senza blocco @F0-SIMBOLO", "non ha il blocco", muta={B.F_PROVA: prova_mut(lambda t: t.replace("simboli=EURUSD,GBPUSD,XAUUSD,U30USD", "simboli=EURUSD,GBPUSD,XAUUSD,ZZZUSD", 1))})
        r = scenario("S20", base, pin="b" * 40, pin_srv="a" * 40)
        chk("S20 pin senza file sul server (404): si ferma, nessun terminale, niente sul Desktop", rc_di(r["p"]) != "0" and not lanci(r["sd"]) and zip_di(r["c"]) is None and "ESITO F0" not in r["p"].stdout, r["p"].stdout[-300:] + r["p"].stderr[-300:])
        rr = scenario("S21", base, lotto="Z")
        chk("S21 lotto sconosciuto rifiutato", rc_di(rr["p"]) != "0" and "PILOTA, A, B, C o D" in (rr["p"].stdout + rr["p"].stderr))

        # ---------------------------------------------------------------- compilazione
        print("S22-S24 compilazione")
        r = scenario("S22", base, scen=dict(compile_fallisce=True))
        chk("S22 compilazione fallita: si ferma con '.ex5 NON prodotto', nessun terminale lanciato", rc_di(r["p"]) != "0" and ".ex5 NON prodotto" in (r["p"].stdout + r["p"].stderr) and not lanci(r["sd"]), (r["p"].stdout + r["p"].stderr)[-400:])
        r = scenario("S23", base, scen=dict(compile_avvisi=3))
        chk("S23 compilazione con 3 avvisi: li STAMPA (prima compilazione vera) e prosegue", rc_di(r["p"]) == "0" and "0 errori, 3 avvisi" in r["p"].stdout and "possible loss of data" in r["p"].stdout, r["p"].stdout[:1500])
        chk("S23 il riepilogo dice 3 avvisi", "3 avvisi" in zip_di(r["c"]).read("RIEPILOGO_F0.txt").decode("ascii"))
        r = scenario("S24", base, scen=dict(compile_senza_riga_result=True))
        chk("S24 log di compilazione senza la riga Result: prosegue (il verdetto e' l'.ex5) ma lo DICE", rc_di(r["p"]) == "0" and "NON letta" in r["p"].stdout)

        # ---------------------------------------------------------------- difetti per passata
        print("S25 difetti per passata (uno alla volta su EURUSD AUDIO_H1)")
        casi = [("nocsv", "KO", "CSV natcla_setup_EURUSD_778601.csv NON trovato"), ("csv_vecchio", "KO", "NON trovato fresco"), ("avvio_ver", "KO", "versione EA 1.03"), ("wilder", "KO", "Wilder"),
                ("nessuna_adx", "KO", "NESSUNA"), ("finestra", "KO", "finestra girata DIVERSA"), ("no_avvio", "KO", "riga AVVIO dell EA NON trovata"), ("doppio_avvio", "KO", "PIU righe AVVIO"),
                ("rifiutato", "KO", "AVVIO RIFIUTATO"), ("csv_senza_header", "KO", "senza intestazione"), ("no_verifica", "KO", "VERIFICA ADX NON trovata"),
                ("no_giornale", "OK_FINESTRA_NON_LETTA", ""), ("csv_agente", "OK", "")]
        for fault, stato_atteso, msg in casi:
            r = scenario("S25" + fault, base, scen=dict(falli={"EURUSD_AUDIO_H1": fault}))
            z = zip_di(r["c"])
            m = manifest(z) if z else []
            uno = [x for x in m if x["simbolo"] == "EURUSD" and x["config"] == "AUDIO_H1"]
            altri_ok = all(x["stato"] == "OK" for x in m if not (x["simbolo"] == "EURUSD" and x["config"] == "AUDIO_H1"))
            atteso_rc = "0" if stato_atteso.startswith("OK") else "3"
            chk("S25 %s: passata %s, le altre 7 OK, rc %s%s" % (fault, stato_atteso, atteso_rc, (", motivo '" + msg + "'") if msg else ""),
                len(m) == 8 and len(uno) == 1 and uno[0]["stato"] == stato_atteso and altri_ok and rc_di(r["p"]) == atteso_rc and (not msg or msg in uno[0]["motivi"]), (m[0] if m else r["p"].stdout[-500:]))
        r = scenario("S25ev", base, scen=dict(falli={"EURUSD_AUDIO_H1": "nocsv"}))
        z = zip_di(r["c"])
        chk("S25 nocsv: la riga del tester 'no history data' finisce nel log della passata (TESTER-EVENTO) e a console", "TESTER-EVENTO" in z.read("log/EA_EURUSD_AUDIO_H1.txt").decode("ascii") and "no history data" in r["p"].stdout, z.read("log/EA_EURUSD_AUDIO_H1.txt").decode("ascii")[-300:])
        r = scenario("S26", base, scen=dict(fault_tutti="wilder"))
        m = manifest(zip_di(r["c"]))
        chk("S26 VERIFICA ADX 'Wilder' su tutte: 8 KO, rc 3", all(x["stato"] == "KO" for x in m) and rc_di(r["p"]) == "3")
        r = scenario("S27", base, scen=dict(unita={"EURUSD": "1.0"}))
        m = manifest(zip_di(r["c"]))
        chk("S27 EURUSD con 1 u = 1.0 (unita sbagliata per la classe): quelle passate KO", [x["stato"] for x in m if x["simbolo"] == "EURUSD"] == ["KO", "KO"] and "1 u" in m[0]["motivi"])
        r = scenario("S28", base, log_vecchio=True)
        m = manifest(zip_di(r["c"]))
        chk("S28 log dell'agente GIA' presente prima del lotto (AVVIO falso v1.00 PDF): la fotografia lo esclude, 8 OK", all(x["stato"] == "OK" for x in m) and len(m) == 8, m[0])
        r = scenario("S29", base, desktop_vecchio=True)
        ds = os.path.join(r["c"], "Users", "Master", "Desktop")
        elenco = os.listdir(ds)
        chk("S29 cartella e zip di un giro precedente RINOMINATI con la data, non cancellati", any(x.startswith("NATCLA_F0_PILOTA_VECCHIA_") for x in elenco) and any(x.startswith("NATCLA_F0_PILOTA_VECCHIO_") and x.endswith(".zip") for x in elenco) and "NATCLA_F0_PILOTA.zip" in elenco, elenco)
        vecchia = [x for x in elenco if x.startswith("NATCLA_F0_PILOTA_VECCHIA_")][0]
        chk("S29 il residuo vecchio e' ancora dentro la cartella rinominata", os.path.exists(os.path.join(ds, vecchia, "RESIDUO.txt")))

        # ---------------------------------------------------------------- tetto
        print("S30 tetto di minuti")
        r = scenario("S30", base, muta={B.F_PROVA: prova_mut(lambda t: t.replace("@F0-LOTTO nome=PILOTA tetto_min=40", "@F0-LOTTO nome=PILOTA tetto_min=0"))})
        m = manifest(zip_di(r["c"]))
        chk("S30 tetto 0: 8 NON_LANCIATA, nessun terminale, rc 3, lo zip esce lo stesso", len(m) == 8 and all(x["stato"] == "NON_LANCIATA" for x in m) and not lanci(r["sd"]) and rc_di(r["p"]) == "3", r["p"].stdout[-400:])

        # ---------------------------------------------------------------- timeout e terminale che non si chiude
        if not rapido:
            print("S31-S32 timeout (reale: ~1 minuto ciascuno)")
            solo1 = lambda t: t.replace("simboli=EURUSD,GBPUSD,XAUUSD,U30USD configs=AUDIO_H1,M2_H1", "simboli=EURUSD,GBPUSD configs=AUDIO_H1")
            r = scenario("S31", base, timeout_min=1, no_exit=True, sleep_reale=True, muta={B.F_PROVA: prova_mut(solo1)})
            m = manifest(zip_di(r["c"]))
            chk("S31 timeout: CloseMainWindow, passata KO 'timeout', il lotto prosegue con la seconda (anch'essa timeout)", len(m) == 2 and all(x["stato"] == "KO" and "timeout" in x["motivi"] for x in m) and os.path.exists(os.path.join(r["sd"], "simlog", "sim_closemainwindow.txt")) and rc_di(r["p"]) == "3", (m, r["p"].stdout[-500:]))
            r = scenario("S32", base, timeout_min=1, no_exit=True, no_close=True, sleep_reale=True, muta={B.F_PROVA: prova_mut(solo1)})
            m = manifest(zip_di(r["c"]))
            chk("S32 il terminale NON si chiude nemmeno con CloseMainWindow: la prima KO, la seconda NON_LANCIATA 'lotto fermato', nessun Kill", len(m) == 2 and m[0]["stato"] == "KO" and m[1]["stato"] == "NON_LANCIATA" and "lotto fermato" in m[1]["motivi"] and "NON si e chiuso" in r["p"].stdout and len(lanci(r["sd"])) == 1, (m, r["p"].stdout[-600:]))

        # ---------------------------------------------------------------- i lotti veri: A (forex con JPY, D1 'Daily'), C (oro e indici), D
        if not rapido:
            for lot, nrun in (("A", 66), ("C", 66), ("D", 18)):
                print("S4x lotto %s (%d passate)" % (lot, nrun))
                r = scenario("S4" + lot, base, lotto=lot)
                z = zip_di(r["c"], lot)
                m = manifest(z) if z else []
                chk("S4x lotto %s: %d passate, tutte OK, rc 0 (unita per classe, JPY a 0.01, D1 'Daily', H12, M2_H4)" % (lot, nrun), len(m) == nrun and all(x["stato"] == "OK" for x in m) and rc_di(r["p"]) == "0", (len(m), [x for x in m if x["stato"] != "OK"][:2], r["p"].stdout[-500:]))
                if z:
                    out = os.popen("%s -I %s %s 2>&1" % (sys.executable, os.path.join(REPO, "backtest_pipeline", "leggi_natcla_f0.py"), os.path.join(r["c"], "Users", "Master", "Desktop", "NATCLA_F0_%s.zip" % lot))).read()
                    chk("S4x lotto %s: il lettore legge tutte le passate OK" % lot, ("PASSATE LETTE: %d    stato OK dopo i controlli del lettore: %d" % (nrun, nrun)) in out, out[:400])
    finally:
        shutil.rmtree(base, ignore_errors=True)
    falliti = [e for e in ESITI if not e[1]]
    print("BATTERIA NATCLA_F0_PASSATE: %d controlli, %d falliti" % (len(ESITI), len(falliti)))
    return 1 if falliti else 0


if __name__ == "__main__":
    sys.exit(main())
