#!/usr/bin/env python3
# -*- coding: ascii -*-
"""
bootstrap_test.py -- prova la RIGA RIGA_LANCIA_R290A.txt (quella che Claudio incolla) nel banco: il testo della riga e' eseguito con Invoke-Expression come fa lui; cambia SOLO l'URL di download
(-> server locale) e il fatto che `powershell.exe` e' una funzione che lancia lo script nello stesso processo (cosi' valgono i finti terminale/MetaEditor del banco). Lo script e' servito INALTERATO:
la sua impronta deve combaciare con quella scritta nella riga. Scenari: riga verde da cima a fondo; script servito con UN byte diverso (si ferma a "IMPRONTA DIVERSA", nessuna scrittura);
script senza marcatore ma con l'impronta rifatta (si ferma al marcatore); macchina sbagliata; MT5 aperto; il PIN nella riga e' il commit; la riga e' UNA riga ASCII; dichiara bersaglio e NON toccati.
Uso: python3 bootstrap_test.py [COMMIT]   (default HEAD; il commit deve contenere gli stessi byte dello script nell'albero di lavoro)
"""
import hashlib, os, re, shutil, subprocess, sys, tempfile
import banco

REPO = banco.REPO
C = sys.argv[1] if len(sys.argv) > 1 else subprocess.run(["git", "rev-parse", "HEAD"], cwd=REPO, capture_output=True, text=True).stdout.strip()
C = subprocess.run(["git", "rev-parse", C], cwd=REPO, capture_output=True, text=True).stdout.strip()
tmpd = tempfile.mkdtemp(prefix="rigatest_")
dest = os.path.join(tmpd, "riga.txt")
r = subprocess.run([sys.executable, os.path.join(banco.QD, "bootstrap.py"), C, "--dest", dest, "--senza-origin"], capture_output=True, text=True)
assert r.returncode == 0, r.stdout + r.stderr
riga = open(dest, "rb").read().decode("ascii")
blob = subprocess.run(["git", "show", "%s:%s" % (C, banco.F_SCRIPT)], cwd=REPO, capture_output=True, check=True).stdout
assert blob == open(banco.SCRIPT, "rb").read(), "lo script nell'albero di lavoro NON e' quello del commit: committare prima"
H = hashlib.sha256(blob).hexdigest().upper()
bad = []
ok = [0]


def chk(c, m):
    if c:
        ok[0] += 1
    else:
        bad.append(m)


chk("\n" not in riga and "\r" not in riga, "la riga non e' UNA riga fisica")
chk(("$PIN='" + C + "'") in riga and H in riga and riga.count(H) == 2, "pin/impronta nella riga")
for tok in ("DESKTOP-H4D7CAJ", "50503392", "BCM Markets MT5 Terminal", "FTMO 541452707", "REALE 10105439", "50504263", "50503635", "50504400", "Pepperstone", "Tickmill", "VMI3047753",
            "AllowLiveTrading=false", "TEMPO ATTESO 10-17 MINUTI", "NON fermarla prima di 45 minuti", "PASSATA_STOP_SUPREV_NAS.zip", "MARCATORE_PASSATA_STOP_SUPREV_NAS_v1", "ESITO PASSATA"):
    chk(tok in riga, "la riga non nomina %r" % tok)
chk("irm " not in riga and "Invoke-RestMethod" not in riga and "DownloadData" in riga, "scaricamento")


def prova(nome, spec, atteso, no_testo=(), hits_zero=False, dopo=None):
    n0 = len(bad)
    _prova(nome, spec, atteso, no_testo, hits_zero, dopo)
    return len(bad) - n0


def _prova(nome, spec, atteso, no_testo=(), hits_zero=False, dopo=None):
    b = tempfile.mkdtemp(prefix="rg_", dir=tmpd)
    srv = None
    spec = dict(spec); spec["pin"] = C                  # il server serve sotto il PIN della riga (= il commit)
    try:
        c = banco.costruisci(b, spec)
        srv = banco.Srv(spec)
        spec = dict(spec); spec["riga"] = riga
        fuori0 = banco.snapshot(c)
        p = banco.esegui(spec, c, srv, b)
        out = re.sub(r"\x1b\[[0-9;]*m", "", p.stdout + "\n" + p.stderr)
        fuori1 = banco.snapshot(c)
        user = os.path.join(c, "Users", "Master")
        for t in atteso:
            chk(t in out, "%s: manca %r" % (nome, t))
        for t in no_testo:
            chk(t not in out, "%s: c'e' %r" % (nome, t))
        if hits_zero:
            chk(srv.hits == [], "%s: richieste di rete %s" % (nome, srv.hits[:2]))
            chk(not os.path.exists(os.path.join(user, "abtg_passata")), "%s: file creati" % nome)
        chk(fuori0 == fuori1, "%s: file fuori perimetro cambiati" % nome)
        if dopo:
            dopo(c, user, out, b, nome)
        return out
    finally:
        if srv:
            srv.chiudi()


def voci():
    ore = [8, 9, 10, 13, 14, 15, 16, 17]
    v = []
    for i in range(16):
        d = 85 + (i * 11) % 80
        v.append(("2024.10.%02d" % (1 + i), ore[i % 8], "LONG" if i % 2 == 0 else "SHORT", "%d.50" % d))
    return v


import battery


def S2(**kw):
    return battery.S(voci=voci(), **kw)


def dopo_verde(c, user, out, b, nome):
    s = os.path.join(user, "abtg_passata", "PASSATA_STOP_SUPREV_NAS.ps1")
    chk(os.path.exists(s) and hashlib.sha256(open(s, "rb").read()).hexdigest().upper() == H, "%s: il file scritto sul disco non ha l'impronta dichiarata" % nome)
    chk(os.path.exists(os.path.join(user, "Desktop", "PASSATA_STOP_SUPREV_NAS.zip")), "%s: zip assente" % nome)
    chk("passata rc 0" in out, "%s: la riga non stampa 'passata rc 0'" % nome)
    chk("FILE ATTESI NELLO ZIP" in out and "durata totale minuti" in out, "%s: raccolta/durata non stampate" % nome)


prova("B1_verde_da_cima_a_fondo", S2(), ["impronta script: " + H[:8] + " OK, marcatore OK", "ESITO PASSATA: AFFIDABILE e C3 CALCOLATO (rc 0)", "BERSAGLIO: SOLO una finestra PowerShell"], dopo=dopo_verde)
prova("B2_g0_non_raggiunto_rc3", S2(report=dict(trades="176")), ["passata rc 3", "ESITO PASSATA: NON MISURATO (rc 3)"], no_testo=["C3 -- mediana"])


def serve_alterato(spec):
    spec["muta"] = dict(spec["muta"])
    spec["muta"][banco.F_SCRIPT] = lambda b: b + b"# x\n"
    return spec


prova("B3_script_con_un_byte_in_piu", serve_alterato(S2()), ["IMPRONTA DIVERSA"], no_testo=["impronta script:", "=== 0 - MACCHINA"],
      dopo=lambda c, u, o, b, n: chk(not os.path.exists(os.path.join(u, "abtg_passata", "PASSATA_STOP_SUPREV_NAS.ps1")), "B3: lo script alterato e' stato scritto"))
prova("B3b_script_alterato_stessa_lunghezza", dict(S2(), muta={banco.F_SCRIPT: lambda b: b.replace(b"AllowLiveTrading=false", b"AllowLiveTrading=truee", 1)}), ["IMPRONTA DIVERSA"], no_testo=["=== 0 - MACCHINA"])


def serve_senza_marcatore():
    sp = S2()
    nuovo = blob.replace(b"MARCATORE_PASSATA_STOP_SUPREV_NAS_v1", b"MARCATORE_PASSATA_STOP_SUPREV_NAS_vX")
    sp["muta"] = {banco.F_SCRIPT: lambda b: nuovo}
    return sp, hashlib.sha256(nuovo).hexdigest().upper()


sp, h2 = serve_senza_marcatore()
riga_orig = riga
riga = riga.replace(H, h2)
prova("B4_marcatore_assente_impronta_rifatta", sp, ["ASSENTE nello script scaricato"], no_testo=["=== 0 - MACCHINA"])
riga = riga_orig
prova("B5_macchina_vps", S2(macchina="VMI3047753"), ["QUESTA RIGA GIRA SOLO SUL PC DI BACKTEST"], hits_zero=True, no_testo=["impronta script:"])
prova("B7_scrittura_su_disco_corrotta", dict(S2(), corrompi=True), ["file scritto sul disco ha un altra impronta"], no_testo=["=== 0 - MACCHINA"])
prova("B6_mt5_aperto", S2(mt5_vivo="terminal64"), ["MT5 o MetaEditor risulta APERTO"], hits_zero=True, no_testo=["impronta script:"])
# ---- mutazioni della RIGA: ognuna spegne un controllo; lo scenario che lo prova DEVE diventare rosso
riga_orig = riga
H_ = H
def rm(a, b_=""):
    assert riga_orig.count(a) == 1, a
    return riga_orig.replace(a, b_)
MUTR = [
    ("riga_senza_controllo_impronta", rm("if($h -ne '" + H_ + "'){ Write-Host ('IMPRONTA DIVERSA (' + $h + '): copia vecchia o cache di GitHub. Mi fermo, non lancio niente.') -ForegroundColor Red; return }; "), "B3_script_con_un_byte_in_piu", serve_alterato(S2()), ["IMPRONTA DIVERSA"], ["=== 0 - MACCHINA"]),
    ("riga_senza_marcatore", rm("if(-not ($t | Select-String -SimpleMatch -Quiet -Pattern 'MARCATORE_PASSATA_STOP_SUPREV_NAS_v1')){ Write-Host 'Marcatore MARCATORE_PASSATA_STOP_SUPREV_NAS_v1 ASSENTE nello script scaricato: mi fermo.' -ForegroundColor Red; return }; ").replace(H_, h2), "B4_marcatore_assente", sp, ["ASSENTE nello script scaricato"], ["=== 0 - MACCHINA"]),
    ("riga_senza_guardia_macchina", rm("if($env:COMPUTERNAME -ne 'DESKTOP-H4D7CAJ'){ throw ('QUESTA RIGA GIRA SOLO SUL PC DI BACKTEST DESKTOP-H4D7CAJ. Qui la macchina si chiama: ' + $env:COMPUTERNAME + '. Sul VPS VMI3047753 non si lancia: la challenge FTMO 541452707 sta operando.') }; "), "B5_macchina_vps", S2(macchina="VMI3047753"), ["QUESTA RIGA GIRA SOLO SUL PC DI BACKTEST"], ["impronta script:"]),
    ("riga_senza_guardia_mt5", rm("if((@(Get-Process -Name terminal64,metaeditor64 -ErrorAction SilentlyContinue)).Count -gt 0){ throw "), "B6_mt5_aperto", S2(mt5_vivo="terminal64"), ["MT5 o MetaEditor risulta APERTO"], ["impronta script:"]),
    ("riga_senza_riverifica_su_disco", rm("$h2=(Get-FileHash -LiteralPath $S -Algorithm SHA256).Hash; if($h2 -ne '" + H_ + "'){ Write-Host ('Il file scritto sul disco ha un altra impronta (' + $h2 + '): mi fermo.') -ForegroundColor Red; return }; "), "B7_scrittura_corrotta", dict(S2(), corrompi=True), ["file scritto sul disco ha un altra impronta"], ["=== 0 - MACCHINA"]),
]
def muta_riga(mutata, nome, sp_, att, no):
    global riga
    riga = mutata
    ok0 = ok[0]
    n = prova("M_" + nome, sp_, att, no_testo=no)
    riga = riga_orig
    del bad[len(bad) - n:]
    ok[0] = ok0
    return n
prese = 0
for (nome, mutata, sn, sp_, att, no) in MUTR:
    if "--senza-mutazioni" in sys.argv:
        break
    if "ASSENTE nello script scaricato" in att:
        pass
    n = muta_riga(mutata, nome, sp_, att, no)
    if n > 0:
        prese += 1
        print("   riga mutata PRESA: %s (%d controlli rossi)" % (nome, n))
    else:
        bad.append("MUTAZIONE DELLA RIGA SOPRAVVISSUTA: " + nome)
print("MUTAZIONI DELLA RIGA: %d prese su %d" % (prese, len(MUTR)))
print("RIGA R290A (bootstrap %s): %d controlli verdi, %d rossi" % (C[:8], ok[0], len(bad)))
for b in bad:
    print("   ROSSO", b)
shutil.rmtree(tmpd, ignore_errors=True)
sys.exit(0 if not bad else 1)
