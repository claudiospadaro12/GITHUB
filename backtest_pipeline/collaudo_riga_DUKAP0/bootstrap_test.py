#!/usr/bin/env python3
# -*- coding: ascii -*-
"""
bootstrap_test.py -- collaudo del bootstrap RIGA_LANCIA_DUKA_P0.txt: rigenerato dal suo generatore e confrontato byte per byte col file committato (classe 1093), poi eseguito
contro un server HTTP LOCALE che serve il file al commit (l'URL di GitHub raw e' sostituito con http://127.0.0.1:PORTA, unica differenza dal testo vero), nel banco del finto C:.
Scenari: ok (impronta + marcatore + pin passati alla riga), file manomesso (IMPRONTA DIVERSA, niente eseguito), marcatore assente, macchina sbagliata (zero richieste al server),
e quattro mutazioni del bootstrap (guardia macchina, controllo impronta, controllo marcatore, passaggio del pin) che devono far diventare rosso uno scenario.
Uso: python3 bootstrap_test.py <COMMIT_DELLA_RIGA>
"""
import hashlib, http.server, os, re, subprocess, sys, tempfile, threading
import fixture as F
import run_one as R

QD = os.path.dirname(os.path.abspath(__file__))
REPO = os.path.abspath(os.path.join(QD, "..", ".."))
C = sys.argv[1]
TMP = os.environ.get("HARNESS_TMP") or tempfile.mkdtemp(prefix="p0boot_")
RAW = "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/"
PERCORSO = "/%s/backtest_pipeline/righe/RIGA_DUKA_P0_CENSIMENTO.ps1" % C
GIT = subprocess.run(["git", "show", "%s:backtest_pipeline/righe/RIGA_DUKA_P0_CENSIMENTO.ps1" % C], cwd=REPO, capture_output=True, check=True).stdout
H = hashlib.sha256(GIT).hexdigest().upper()


class Srv:
    def __init__(self, corpo):
        self.corpo = corpo; self.hits = 0
        s = self
        class H_(http.server.BaseHTTPRequestHandler):
            def do_GET(self):
                s.hits += 1
                if self.path == PERCORSO:
                    self.send_response(200); self.send_header("Content-Length", str(len(s.corpo))); self.end_headers(); self.wfile.write(s.corpo)
                else:
                    self.send_response(404); self.send_header("Content-Length", "0"); self.end_headers()
            def log_message(self, *a): pass
        self.srv = http.server.ThreadingHTTPServer(("127.0.0.1", 0), H_)
        self.porta = self.srv.server_address[1]
        threading.Thread(target=self.srv.serve_forever, daemon=True).start()
    def chiudi(self):
        self.srv.shutdown(); self.srv.server_close()


def genera(dest):
    subprocess.run([sys.executable, os.path.join(QD, "bootstrap.py"), C, "--dest", dest], check=True, capture_output=True)
    return open(dest, encoding="ascii", newline="").read()


def esegui(line, corpo, macchina="DESKTOP-H4D7CAJ"):
    srv = Srv(corpo)
    b = tempfile.mkdtemp(prefix="b_", dir=TMP)
    try:
        spec = F.default_spec(); spec["macchina"] = macchina
        c = F.costruisci(b, spec)
        f = os.path.join(b, "boot.txt")
        open(f, "w", newline="").write(line.replace(RAW, "http://127.0.0.1:%d/" % srv.porta))
        r = R.esegui(spec, c, riga=f)
        r["hits"] = srv.hits
        return r
    finally:
        srv.chiudi()


def main():
    err = []
    dest = os.path.join(TMP, "boot_gen.txt")
    line = genera(dest)
    if "\n" in line or "\r" in line: err.append("il bootstrap non e' UNA riga fisica")
    if any(ord(ch) > 126 for ch in line): err.append("il bootstrap non e' ASCII")
    if C not in line or H not in line: err.append("commit o impronta non sono nel bootstrap")
    committato = os.path.join(REPO, "backtest_pipeline", "righe", "RIGA_LANCIA_DUKA_P0.txt")
    if os.path.exists(committato):
        if open(committato, encoding="ascii", newline="").read() != line:
            err.append("il bootstrap COMMITTATO non e' identico a quello rigenerato dal generatore al commit %s (classe 1093)" % C[:8])
    else:
        print("  (bootstrap committato non ancora presente: confronto byte per byte saltato)")
    for frase in ("BERSAGLIO: SOLO una finestra PowerShell sul PC di backtest DESKTOP-H4D7CAJ", "NON apre MT5", "10105439", "50504263", "50503392", "C:\\\\FTMO".replace("\\\\", "\\")):
        if frase not in line: err.append("manca nel BERSAGLIO: " + frase)
    # (a) ok
    r = esegui(line, GIT)
    o = r["stdout"]
    for s in ("Riga P0 scaricata, impronta OK: " + H[:8], "pin riga ..... " + C, "sha256 riga .. " + H, "ESITO P0: CENSIMENTO COMPLETO (solo lettura)", "FINE-HARNESS-ARRIVATO"):
        if s not in o: err.append("(a) manca: " + s)
    if len(r["zips"]) != 1: err.append("(a) zip: %s" % r["zips"])
    # (b) manomesso
    r = esegui(line, GIT + b"\n# manomesso\n")
    if "IMPRONTA DIVERSA" not in r["stdout"] or "DUKA P0 -- CENSIMENTO" in r["stdout"] or r["cartelle"] or r["zips"]:
        err.append("(b) il file manomesso NON e' stato fermato dall'impronta")
    # (c) marcatore assente (con impronta COERENTE col file senza marcatore: il solo controllo del marcatore deve fermarlo)
    senza = GIT.replace(b"MARCATORE_RIGA_DUKA_P0_v1", b"MARCATORE_RIGA_DUKA_P0_vX")
    line_c = line.replace(H, hashlib.sha256(senza).hexdigest().upper())
    r = esegui(line_c, senza)
    if "Marcatore della riga P0 assente" not in r["stdout"] or "DUKA P0 -- CENSIMENTO" in r["stdout"] or r["cartelle"]:
        err.append("(c) il marcatore assente NON ha fermato la riga")
    # (d) macchina sbagliata: zero richieste
    r = esegui(line, GIT, macchina="VMI3047753")
    if r["hits"] != 0 or "Nessun download e stato fatto" not in (r["stdout"] + r["stderr"]) or r["cartelle"]:
        err.append("(d) la macchina sbagliata non e' stata fermata PRIMA del download (richieste al server: %d)" % r["hits"])
    # mutazioni del bootstrap: ognuna deve far rosso uno degli scenari a-d
    def tutti(line_m, ok_h=None):
        rossi = []
        ra = esegui(line_m, GIT)
        if "pin riga ..... " + C not in ra["stdout"] or "ESITO P0: CENSIMENTO COMPLETO" not in ra["stdout"]: rossi.append("a")
        rb = esegui(line_m, GIT + b"\n# manomesso\n")
        if "IMPRONTA DIVERSA" not in rb["stdout"] or rb["cartelle"]: rossi.append("b")
        rc = esegui(line_m.replace(H, hashlib.sha256(senza).hexdigest().upper()), senza)
        if "Marcatore della riga P0 assente" not in rc["stdout"] or rc["cartelle"]: rossi.append("c")
        rd = esegui(line_m, GIT, macchina="VMI3047753")
        if rd["hits"] != 0 or rd["cartelle"]: rossi.append("d")
        return rossi
    muts = [
        ("guardia_macchina", "if($env:COMPUTERNAME -ne 'DESKTOP-H4D7CAJ'){", "if($false){"),
        ("controllo_impronta", "if($h -ne '" + H + "'){", "if($false){"),
        ("controllo_marcatore", "if(-not ($t | Select-String -SimpleMatch -Quiet -Pattern 'MARCATORE_RIGA_DUKA_P0_v1')){", "if($false){"),
        ("pin_non_passato", "$DUKA_P0_PIN='" + C + "'; ", ""),
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
