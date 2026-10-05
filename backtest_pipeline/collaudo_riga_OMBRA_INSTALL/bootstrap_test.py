#!/usr/bin/env python3
# -*- coding: ascii -*-
"""
bootstrap_test.py -- collaudo del bootstrap RIGA_LANCIA_OMBRA_INSTALL.txt: rigenerato dal suo generatore e confrontato byte per byte col file committato (classe 1093), poi eseguito
contro un server HTTP LOCALE che serve lo script al commit (l'URL di GitHub raw e' sostituito con http://127.0.0.1:PORTA, unica differenza dal testo vero) nel banco del finto C:.
DICHIARATO: lo script servito ha anch'esso l'URL dell'EA puntato al server locale, quindi il suo SHA256 NON e' quello vero: nel bootstrap provato la sola costante dell'impronta e' sostituita con
quella dello script servito. Cio' che si prova e' la MECCANICA del bootstrap (guardia macchina, confronto impronta, controllo marcatore, passaggio del pin); l'impronta VERA si controlla a parte
contro GitHub raw (HTTP 200 + SHA256 = git show).
Scenari: ok (impronta + marcatore + pin passati alla riga, file installato), script manomesso (IMPRONTA DIVERSA, niente eseguito), marcatore assente con impronta coerente, macchina sbagliata
(zero richieste al server), e quattro mutazioni del bootstrap (guardia macchina, controllo impronta, controllo marcatore, passaggio del pin) che devono far diventare rosso uno scenario.
Uso: python3 bootstrap_test.py <COMMIT_DELLA_RIGA>
"""
import hashlib, os, re, subprocess, sys, tempfile
import fixture as F
import run_one as R

QD = os.path.dirname(os.path.abspath(__file__))
REPO = os.path.abspath(os.path.join(QD, "..", ".."))
C = sys.argv[1]
TMP = os.environ.get("HARNESS_TMP") or tempfile.mkdtemp(prefix="ombo_")
RAW = R.RAW
PERCORSO = "/%s/backtest_pipeline/righe/RIGA_OMBRA_INSTALL.ps1" % C
GIT = subprocess.run(["git", "show", "%s:backtest_pipeline/righe/RIGA_OMBRA_INSTALL.ps1" % C], cwd=REPO, capture_output=True, check=True).stdout
H = hashlib.sha256(GIT).hexdigest().upper()
MARC = b"MARCATORE_RIGA_OMBRA_INSTALL_v1"
PIATTO = "base"


def genera(dest):
    subprocess.run([sys.executable, os.path.join(QD, "bootstrap.py"), C, "--dest", dest], check=True, capture_output=True)
    return open(dest, encoding="ascii", newline="").read()


def servito(port, modo):
    s = GIT.replace(RAW.encode(), ("http://127.0.0.1:%d/" % port).encode())
    if modo == "manomesso":
        s += b"\n# manomesso\n"
    if modo == "senza_marcatore":
        s = s.replace(MARC, b"MARCATORE_RIGA_OMBRA_INSTALL_vX")
    return s


def esegui(line, modo="ok", macchina="VMI3047753", coerente=True):
    b = tempfile.mkdtemp(prefix="b_", dir=TMP)
    spec = F.default_spec(); spec["macchina"] = macchina
    c = F.costruisci(b, spec)

    def rotte(port):
        return {PERCORSO: servito(port, modo)}

    def testo(port):
        t = line.replace(RAW, "http://127.0.0.1:%d/" % port)
        # l'impronta dello script SERVITO (patchato per la porta): per "manomesso" l'impronta e' quella dello script NON manomesso (il file cambia DOPO)
        base = hashlib.sha256(servito(port, "ok" if modo == "manomesso" else ("senza_marcatore" if (modo == "senza_marcatore" and coerente) else "ok"))).hexdigest().upper()
        return t.replace(H, base)

    prima = F.snapshot(c)
    r = R.esegui(spec, c, testo_fn=testo, rotte_fn=rotte)
    r["dopo"] = F.snapshot(c)
    r["prima"] = prima
    r["c"] = c
    return r


def main():
    err = []
    dest = os.path.join(TMP, "boot_gen.txt")
    line = genera(dest)
    if "\n" in line or "\r" in line: err.append("il bootstrap non e' UNA riga fisica")
    if any(ord(ch) > 126 for ch in line): err.append("il bootstrap non e' ASCII")
    if C not in line or H not in line: err.append("commit o impronta non sono nel bootstrap")
    committato = os.path.join(REPO, "backtest_pipeline", "righe", "RIGA_LANCIA_OMBRA_INSTALL.txt")
    if os.path.exists(committato):
        if open(committato, encoding="ascii", newline="").read() != line:
            err.append("il bootstrap COMMITTATO non e' identico a quello rigenerato dal generatore al commit %s (classe 1093)" % C[:8])
    else:
        print("  (bootstrap committato non ancora presente: confronto byte per byte saltato)")
    for frase in ("BERSAGLIO: SOLO una finestra PowerShell sul VPS VMI3047753", "NON compila", "NON attacca", "10105439", "50504263", "50503392", "C:\\FTMO", "C:\\BCM_Reale", "C:\\MT5_MANUALE",
                  "C:\\MT5_Backtest", "50503635", "50504400", "1514806751", "Pepperstone", "Tickmill", "DESKTOP-H4D7CAJ", "81b4329f", "FD7AACD6", C[:8]):
        if frase not in line: err.append("manca nel BERSAGLIO: " + frase)
    pcs = lambda r: [k for k in set(r["prima"]) ^ set(r["dopo"])]
    # (a) ok
    r = esegui(line)
    o = r["stdout"]
    Hs = None
    for s in ("Riga OMBRA scaricata, impronta OK: ", "pin riga ........ " + C, "ESITO OMBRA INSTALL: INSTALLATO", "FINE-HARNESS-ARRIVATO"):
        if s not in o: err.append("(a) manca: " + s)
    m = re.search(r"sha256 riga ..... ([0-9A-F]{64})", o)
    if not m: err.append("(a) manca lo sha256 della riga nel referto")
    if len(pcs(r)) != 1 or not pcs(r)[0].endswith("MQL5/Experts/ABTG_EMA200_Ombra.mq5"): err.append("(a) il disco deve cambiare per UN solo file, il .mq5: %s" % pcs(r)[:4])
    # (b) manomesso
    r = esegui(line, "manomesso")
    if "IMPRONTA DIVERSA" not in r["stdout"] or "ABTG OMBRA -- INSTALLAZIONE" in r["stdout"] or r["files"] or pcs(r):
        err.append("(b) il file manomesso NON e' stato fermato dall'impronta")
    # (c) marcatore assente (con impronta COERENTE col file senza marcatore: il solo controllo del marcatore deve fermarlo)
    r = esegui(line, "senza_marcatore")
    if "Marcatore della riga OMBRA assente" not in r["stdout"] or "ABTG OMBRA -- INSTALLAZIONE" in r["stdout"] or r["files"] or pcs(r):
        err.append("(c) il marcatore assente NON ha fermato la riga")
    # (d) macchina sbagliata: zero richieste
    r = esegui(line, macchina="DESKTOP-H4D7CAJ")
    if r["hits"] != 0 or "Nessun download e stato fatto" not in (r["stdout"] + r["stderr"]) or r["files"] or pcs(r):
        err.append("(d) la macchina sbagliata non e' stata fermata PRIMA del download (richieste al server: %d)" % r["hits"])

    def tutti(line_m):
        rossi = []
        ra = esegui(line_m)
        if ("pin riga ........ " + C) not in ra["stdout"] or "ESITO OMBRA INSTALL: INSTALLATO" not in ra["stdout"]: rossi.append("a")
        rb = esegui(line_m, "manomesso")
        if "IMPRONTA DIVERSA" not in rb["stdout"] or rb["files"] or pcs(rb): rossi.append("b")
        rc = esegui(line_m, "senza_marcatore")
        if "Marcatore della riga OMBRA assente" not in rc["stdout"] or rc["files"] or pcs(rc): rossi.append("c")
        rd = esegui(line_m, macchina="DESKTOP-H4D7CAJ")
        if rd["hits"] != 0 or rd["files"] or pcs(rd): rossi.append("d")
        return rossi
    muts = [
        ("guardia_macchina", "if($env:COMPUTERNAME -ne 'VMI3047753'){", "if($false){"),
        ("controllo_impronta", "if($h -ne '" + H + "'){", "if($false){"),
        ("controllo_marcatore", "if(-not ($t | Select-String -SimpleMatch -Quiet -Pattern 'MARCATORE_RIGA_OMBRA_INSTALL_v1')){", "if($false){"),
        ("pin_non_passato", "$OMBRA_PIN='" + C + "'; ", ""),
    ]
    for nome, old, new in muts:
        assert old in line, nome
        rossi = tutti(line.replace(old, new, 1))
        print("  mutazione bootstrap %-20s -> %s" % (nome, ("PRESA da " + ",".join(rossi)) if rossi else "SOPRAVVISSUTA"))
        if not rossi: err.append("mutazione del bootstrap sopravvissuta: " + nome)
    for e in err: print("  X " + e)
    print("BOOTSTRAP: " + ("OK (4 scenari + 4 mutazioni)" if not err else "%d problemi" % len(err)))
    return 0 if not err else 1


if __name__ == "__main__":
    sys.exit(main())
