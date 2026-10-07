#!/usr/bin/env python3
# -*- coding: ascii -*-
"""
bootstrap_test.py -- prova la RIGA di lancio da consegnare (dal 07/10 notte RIGA_LANCIA_NATCLA_F0_C0.txt, la verifica del rimedio v1.05; prima era la PILOTA) incollata com'e' (Invoke-Expression, come fa Claudio) nel banco di NATCLA_F0_PASSATE.ps1: il solo URL di
download diventa quello del server locale, lo script e' servito INALTERATO. Controlla che la riga lanci davvero lo script (con le impronte giuste), e che si fermi SENZA scrivere niente quando
l'impronta, il marcatore, la macchina, i processi MT5 o la scrittura su disco non tornano. Ricostruisce le righe di tutti gli altri lotti (PILOTA, A-D) con --dest in cartella temporanea e ne controlla il parser;
la riga del lotto C (quella che segue C0) la ESEGUE anche, una volta, nel banco (66 passate).
Uso: python3 -I backtest_pipeline/collaudo_natcla_f0/bootstrap_test.py <PIN_40_hex>
Il working tree DEVE essere uguale al commit PINNATO per i quattro file (script, prova, EA, include): se no, si ferma.
"""
import hashlib, os, re, shutil, subprocess, sys, tempfile

QD = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, QD)
import banco as B

REPO = B.REPO
ESITI = []


def chk(nome, cond, det=""):
    ESITI.append((nome, bool(cond), det))
    print("  %s %s%s" % ("OK  " if cond else "FAIL", nome, ("   [" + str(det)[:300] + "]") if (det and not cond) else ""), flush=True)


def main():
    pin = sys.argv[1]
    assert re.match(r"^[0-9a-f]{40}$", pin)
    for rel in (B.F_SCRIPT, B.F_PROVA, B.F_EA, B.F_INC):
        git = subprocess.run(["git", "show", "%s:%s" % (pin, rel)], cwd=REPO, capture_output=True, check=True).stdout
        disco = open(os.path.join(REPO, rel), "rb").read()
        assert git == disco, "il working tree NON e' uguale al pin per %s: commit prima, poi rifai il bootstrap e il test" % rel
    LOT = "C0"
    riga = open(os.path.join(REPO, "backtest_pipeline", "righe", "RIGA_LANCIA_NATCLA_F0_%s.txt" % LOT), encoding="ascii").read()
    chk("la riga contiene il pin", ("$PIN='" + pin + "'") in riga)
    chk("la riga e' UNA riga fisica ASCII", "\n" not in riga and "\r" not in riga and riga.isascii())
    chk("la riga imposta TLS 1.2, la guardia macchina, lo stesso lotto C0, il timeout 20", "Tls12" in riga and "DESKTOP-H4D7CAJ" in riga and "-Lotto C0 " in riga and "-TimeoutRunMin 20" in riga)
    chk("la riga C0 dice la versione 1.05, l'ATTESA scritta prima (VERIFICA ADX, righe CONTA > 0, 2024.10.16) e che il lotto C resta FERMO se non passa",
        "v1.05" in riga and "ATTESA SCRITTA PRIMA" in riga and "righe CONTA > 0" in riga and "2024.10.16" in riga and "resta FERMO" in riga and "NON SUPERATA" in riga)
    chk("la riga nomina per nome il bersaglio (50503392, BCM Markets MT5 Terminal) e i NON toccati (C:\\MT5_Backtest, C:\\FundedNext_Manuale, 541452707, 1514806751, 10105439, 50504263, 50503635, 50504400, Pepperstone, Tickmill)",
        all(x in riga for x in ("50503392", "BCM Markets MT5 Terminal", "C:\\MT5_Backtest", "C:\\FundedNext_Manuale", "541452707", "1514806751", "10105439", "50504263", "50503635", "50504400", "Pepperstone", "Tickmill")))
    chk("la riga dichiara la durata attesa, il tetto e il 'non fermarla prima di' calcolato (tetto 15 + 25)", "3-4 minuti" in riga and "15 minuti" in riga and "NON fermarla prima di 40 minuti" in riga)
    chk("la riga elenca i file attesi nello zip e il codice d'uscita", "FILE ATTESI NELLO ZIP" in riga and "rc 3" in riga)
    mh = re.search(r"-ShaEA ([0-9A-F]{64}) -ShaInc ([0-9A-F]{64}) -ShaProva ([0-9A-F]{64})", riga)
    chk("le tre impronte passate allo script sono quelle del commit (git show)", mh is not None and all(
        mh.group(i + 1) == hashlib.sha256(subprocess.run(["git", "show", "%s:%s" % (pin, rel)], cwd=REPO, capture_output=True, check=True).stdout).hexdigest().upper() for i, rel in enumerate((B.F_EA, B.F_INC, B.F_PROVA))))
    H = re.search(r"\$h -ne '([0-9A-F]{64})'", riga).group(1)
    chk("l'impronta dello script nella riga e' quella del commit", H == hashlib.sha256(subprocess.run(["git", "show", "%s:%s" % (pin, B.F_SCRIPT)], cwd=REPO, capture_output=True, check=True).stdout).hexdigest().upper())

    base = tempfile.mkdtemp(prefix="nc_boot_")
    try:
        import json, zipfile

        def scena(nome, **kw):
            spec = B.spec_base(pin=pin, riga=kw.pop("riga", riga), **kw)
            d = tempfile.mkdtemp(dir=base, prefix="b_")
            c = B.costruisci(d, spec)
            srv = B.Srv(spec)
            sd = os.path.join(d, "scen"); os.makedirs(sd)
            p = B.esegui(spec, c, srv, sd)
            srv.chiudi()
            return p, c, sd

        def rc(p):
            m = re.search(r"FINE-HARNESS rc=(\S+)", p.stdout)
            return m.group(1) if m else None

        def scritto(c):
            return os.path.exists(os.path.join(c, "Users", "Master", "abtg_passata", "NATCLA_F0_PASSATE.ps1"))

        def lanci(sd):
            f = os.path.join(sd, "simlog", "sim_terminale_lanci.txt")
            return [l for l in open(f).read().splitlines() if not l.startswith("LANCIO")] if os.path.exists(f) else []

        p, c, sd = scena("verde")
        z = os.path.join(c, "Users", "Master", "Desktop", "NATCLA_F0_C0.zip")
        chk("RIGA verde: lancia lo script, 4 passate OK sugli indici, rc 0, VERIFICA DEL RIMEDIO SUPERATA, zip sul Desktop", "F0 lotto C0 rc 0" in p.stdout and "TUTTE LE PASSATE OK" in p.stdout and
            "SUPERATA su 4 passate su 4" in p.stdout and os.path.exists(z) and len(lanci(sd)) == 4 and all(("U30USD " in x or "D30EUR " in x) for x in lanci(sd)), p.stdout[-800:] + p.stderr[-400:])
        chk("RIGA verde: stampa impronta OK, marcatore OK, il bersaglio e i NON toccati", "impronta script" in p.stdout and "marcatore OK" in p.stdout and "NON TOCCATI" in p.stdout and "DESKTOP-H4D7CAJ" in p.stdout)
        chk("RIGA verde: lo script scritto sul disco ha l'impronta della riga", hashlib.sha256(open(os.path.join(c, "Users", "Master", "abtg_passata", "NATCLA_F0_PASSATE.ps1"), "rb").read()).hexdigest().upper() == H)
        # script alterato di un byte in coda -> IMPRONTA DIVERSA, niente scritto, niente lanciato
        sorg = open(os.path.join(REPO, B.F_SCRIPT), "rb").read()
        p, c, sd = scena("impronta", muta={B.F_SCRIPT: lambda b: b + b"#x"})
        chk("RIGA: script con un byte in piu -> IMPRONTA DIVERSA, non scritto, nessun terminale", "IMPRONTA DIVERSA" in p.stdout and not scritto(c) and not lanci(sd), p.stdout[-300:])
        # stessa lunghezza, un byte cambiato
        p, c, sd = scena("impronta2", muta={B.F_SCRIPT: lambda b: b.replace(b"Dico", b"Dic0", 1)})
        chk("RIGA: script con un byte cambiato (stessa lunghezza) -> IMPRONTA DIVERSA", "IMPRONTA DIVERSA" in p.stdout and not scritto(c) and not lanci(sd))
        # marcatore assente (con l'impronta della riga ricalcolata sullo script senza marcatore: il marcatore e' un controllo a parte)
        senza = sorg.replace(b"MARCATORE_NATCLA_F0_PASSATE_v1", b"MARCATORE_ALTRO")
        riga2 = riga.replace(H, hashlib.sha256(senza).hexdigest().upper())
        p, c, sd = scena("marcatore", riga=riga2, muta={B.F_SCRIPT: lambda b: senza})
        chk("RIGA: marcatore assente nello script scaricato -> si ferma, non scritto, nessun terminale", "ASSENTE nello script scaricato" in p.stdout and not scritto(c) and not lanci(sd), p.stdout[-300:])
        # macchina sbagliata
        p, c, sd = scena("macchina", macchina="VMI3047753")
        chk("RIGA: sul VPS -> eccezione, niente scaricato, niente scritto", rc(p) != "0" and "SOLO SUL PC DI BACKTEST" in (p.stdout + p.stderr) and not scritto(c) and not lanci(sd), (p.stdout + p.stderr)[-300:])
        # MT5 vivo: stampa PID/titolo/cartella e si ferma
        p, c, sd = scena("mt5", mt5_vivo="terminal64")
        chk("RIGA: terminal64 vivo -> si ferma PRIMA di scaricare, niente scritto", "APERTO" in (p.stdout + p.stderr) and "PID" in p.stdout and not scritto(c) and not lanci(sd), (p.stdout + p.stderr)[-400:])
        p, c, sd = scena("meta", mt5_vivo="metaeditor64")
        chk("RIGA: metaeditor64 vivo -> si ferma PRIMA di scaricare", "APERTO" in (p.stdout + p.stderr) and not scritto(c) and not lanci(sd))
        # scrittura corrotta
        spec = None
        p, c, sd = scena("scrittura", riga=riga.replace("Set-Content -LiteralPath $S -Value $t -Encoding ASCII -NoNewline;", "Set-Content -LiteralPath $S -Value ($t + 'x') -Encoding ASCII -NoNewline;"))
        chk("RIGA: file scritto sul disco con un'altra impronta -> si ferma, nessun terminale", "altra impronta" in p.stdout and not lanci(sd), p.stdout[-300:])
        # lo script servito rifiuta se le impronte passate non tornano (EA diverso da quello della riga)
        p, c, sd = scena("ea", muta={B.F_EA: lambda b: b + b"\n//x\n"})
        chk("RIGA: EA diverso da quello pinnato (SHA256 della riga) -> lo script si ferma, nessun terminale", "SHA256" in (p.stdout + p.stderr) and not lanci(sd), (p.stdout + p.stderr)[-300:])
        # la riga del lotto C (quella che segue C0): eseguita UNA volta nel banco, 66 passate
        rigac = open(os.path.join(REPO, "backtest_pipeline", "righe", "RIGA_LANCIA_NATCLA_F0_C.txt"), encoding="ascii").read()
        chk("riga C: contiene il pin, -Lotto C, dice di lanciarla SOLO dopo C0 SUPERATA", ("$PIN='" + pin + "'") in rigac and "-Lotto C " in rigac and "SOLO DOPO che il lotto C0" in rigac)
        p, c, sd = scena("rigaC", riga=rigac)
        chk("riga C eseguita nel banco: 66 passate OK, rc 0, zip NATCLA_F0_C.zip", "F0 lotto C rc 0" in p.stdout and len(lanci(sd)) == 66 and
            os.path.exists(os.path.join(c, "Users", "Master", "Desktop", "NATCLA_F0_C.zip")), p.stdout[-600:] + p.stderr[-300:])
        # le righe degli altri lotti: si generano e il parser le compila
        for lot in ("PILOTA", "A", "B", "C", "D", "C0"):
            dest = os.path.join(base, "RIGA_%s.txt" % lot)
            out = subprocess.run([sys.executable, "-I", os.path.join(QD, "bootstrap.py"), pin, lot, "--dest", dest], capture_output=True, text=True)
            t = open(dest, encoding="ascii").read() if out.returncode == 0 else ""
            r2 = subprocess.run([sys.executable, os.path.join(REPO, "backtest_pipeline", "controlla_riga.py"), "--oggetto", "riga", "--riga", dest], capture_output=True, text=True)
            chk("lotto %s: la riga si genera, e' una riga ASCII, il parser la compila, il gate meccanico non trova difetti" % lot,
                out.returncode == 0 and "\n" not in t and ("-Lotto " + lot + " ") in t and "ESITO: nessun difetto meccanico" in r2.stdout, (out.stderr[-300:], r2.stdout[-400:]))
    finally:
        shutil.rmtree(base, ignore_errors=True)
    falliti = [e for e in ESITI if not e[1]]
    print("BOOTSTRAP NATCLA_F0: %d controlli, %d falliti" % (len(ESITI), len(falliti)))
    return 1 if falliti else 0


if __name__ == "__main__":
    sys.exit(main())
