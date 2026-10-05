#!/usr/bin/env python3
# -*- coding: ascii -*-
"""
run_one.py -- esegue RIGA_OMBRA_INSTALL.ps1 (o una copia mutata/iniettata) dentro pwsh 7 su un finto C: (PSDrive C:), con Invoke-Expression come fa il bootstrap.
Funzioni del banco che SOSTITUISCONO i cmdlet assenti o globali su Linux (hanno la precedenza sul cmdlet, come nei banchi di R280/DUKAP0): Get-CimInstance (RAM, da env),
Get-Process (la lista dei terminal64 della specifica: Get-Process vero guarda la MACCHINA, non lo scenario: classe 1112), Start-Sleep (nessuna attesa: il campione di CPU usa
l'intervallo nominale). Tutto il resto e' il cmdlet vero: Get-ChildItem, Test-Path, Set-Content, Compress-Archive, .NET FileStream, WebClient.
Il download dell'EA va contro un server HTTP LOCALE: l'unica differenza dal testo vero e' la sostituzione dell'URL di GitHub raw (dichiarata).
"""
import http.server, json, os, shutil, subprocess, tempfile, threading
import fixture as F

QD = os.path.dirname(os.path.abspath(__file__))
RIGA_DEFAULT = os.path.abspath(os.path.join(QD, "..", "righe", "RIGA_OMBRA_INSTALL.ps1"))
RAW = "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/"

SETUP = r'''
New-PSDrive -Name C -PSProvider FileSystem -Root $env:CDRIVE | Out-Null
function Get-CimInstance { [CmdletBinding()] param([Parameter(Position=0)][string]$ClassName, [string]$Filter)
  if($env:CIM_FALLISCE -eq "1"){ throw "CIM non disponibile (banco)" }
  if($ClassName -eq "Win32_OperatingSystem"){ [pscustomobject]@{ FreePhysicalMemory=[double]$env:RAM_LIBERA_KB; TotalVisibleMemorySize=[double]$env:RAM_TOTALE_KB } } }
$script:chiamate = @{}
function Get-Process { [CmdletBinding()] param([string[]]$Name, [int]$Id)
  foreach($p in @($env:PROCS_JSON | ConvertFrom-Json)){
    if($null -eq $p){ continue }
    if($Name -and ($Name -notcontains $p.Name)){ continue }
    if($PSBoundParameters.ContainsKey("Id") -and $p.Id -ne $Id){ continue }
    $k = "" + $p.Id
    $n = 0; if($script:chiamate.ContainsKey($k)){ $n = $script:chiamate[$k] }
    $script:chiamate[$k] = $n + 1
    $cpu = [double]$p.Cpu + $(if($n -ge 1){ [double]$p.Delta }else{ 0 })
    $o = [pscustomobject]@{ Id=[int]$p.Id; ProcessName=$p.Name; MainWindowTitle=$p.Title; Path=$p.Path; WorkingSet64=[int64]$p.Ws; PrivateMemorySize64=[int64]$p.Pm; CPU=$cpu }
    $o
  } }
function Start-Sleep { [CmdletBinding()] param([int]$Seconds, [int]$Milliseconds) }
'''


class Srv:
    def __init__(self, corpo, codice=200):
        self.corpo = corpo; self.codice = codice; self.hits = 0
        s = self
        class H_(http.server.BaseHTTPRequestHandler):
            def do_GET(self):
                s.hits += 1
                if self.path == "/%s/%s" % (F.EA_PIN, F.EA_REL) and s.codice == 200:
                    self.send_response(200); self.send_header("Content-Length", str(len(s.corpo))); self.end_headers(); self.wfile.write(s.corpo)
                else:
                    self.send_response(404); self.send_header("Content-Length", "0"); self.end_headers()
            def log_message(self, *a): pass
        self.srv = http.server.ThreadingHTTPServer(("127.0.0.1", 0), H_)
        self.porta = self.srv.server_address[1]
        threading.Thread(target=self.srv.serve_forever, daemon=True).start()
    def chiudi(self):
        self.srv.shutdown(); self.srv.server_close()


def corpo_server(modo):
    """ritorna (bytes serviti, nuovo sha da mettere nella costante dello script o None, codice HTTP)"""
    import hashlib
    b = F.EA_BYTES
    def sha(x): return hashlib.sha256(x).hexdigest().upper()
    if modo == "ok":
        return b, None, 200
    if modo == "sha_diverso":
        return b + b"\n// x\n", None, 200
    if modo == "coerente_trading":
        x = b + b"\nvoid f(){ OrderSend(a,b); }\n"
        return x, sha(x), 200
    if modo == "versione_property":
        x = b.replace(b'#property version   "1.03"', b'#property version   "1.02"'); assert x != b
        return x, sha(x), 200
    if modo == "versione_define":
        x = b.replace(b'#define OMBRA_VER     "1.03"', b'#define OMBRA_VER     "1.02"'); assert x != b
        return x, sha(x), 200
    if modo == "non_ascii":
        x = b + b"\n// \xc3\xa8\n"
        return x, sha(x), 200
    if modo == "404":
        return b, None, 404
    if modo == "giu":
        return b, None, 200
    raise ValueError(modo)


def esegui(spec, c, riga=None, patch=None, pin=None, sha=None, timeout=300, testo=None):
    """patch: lista di (vecchio, nuovo) sul testo dello script (mutanti e iniezioni di guasto: DICHIARATI dal chiamante). testo: script gia' pronto (bootstrap_test)."""
    riga = riga or RIGA_DEFAULT
    corpo, nuovo_sha, codice = corpo_server(spec["server"])
    srv = Srv(corpo, codice)
    if spec["server"] == "giu":
        srv.chiudi()
    out = tempfile.mkdtemp(prefix="omrun_", dir=os.environ.get("HARNESS_TMP", None))
    try:
        t = testo if testo is not None else open(riga, encoding="ascii", newline="").read()
        assert RAW in t
        t = t.replace(RAW, "http://127.0.0.1:%d/" % srv.porta)
        if nuovo_sha:
            assert F.EA_SHA in t
            t = t.replace(F.EA_SHA, nuovo_sha)
        for (old, new) in (patch or []):
            assert old in t, "patch: testo non trovato: " + old[:60]
            t = t.replace(old, new, 1)
        rf = os.path.join(out, "riga.ps1")
        open(rf, "w", newline="", encoding="ascii").write(t)
        ps = F.procs_default(spec) if spec["procs"] == "default" else (spec["procs"] or [])
        env = dict(os.environ)
        env.update(COMPUTERNAME=spec["macchina"], USERNAME=spec["utente"], USERPROFILE="C:\\Users\\" + spec["utente"], APPDATA="C:\\Users\\%s\\AppData\\Roaming" % spec["utente"],
                   SystemRoot="C:\\Windows", SystemDrive="C:", NUMBER_OF_PROCESSORS="6", CDRIVE=c, RAM_LIBERA_KB=str(spec["libera_kb"]), RAM_TOTALE_KB=str(spec["totale_kb"]),
                   CIM_FALLISCE="0" if spec["cim_ok"] else "1", PROCS_JSON=json.dumps(ps), RIGA_FILE=rf)
        pre = ""
        if pin:
            pre += "$OMBRA_PIN='%s'; " % pin
        if sha:
            pre += "$OMBRA_SHA='%s'; " % sha
        cmd = SETUP + "\n" + pre + "\n$ErrorActionPreference='Stop'; $t = Get-Content -Raw -LiteralPath $env:RIGA_FILE; Invoke-Expression $t; 'FINE-HARNESS-ARRIVATO'\n"
        p = subprocess.run(["pwsh", "-NoProfile", "-Command", cmd], env=env, capture_output=True, text=True, timeout=timeout)
        desk = os.path.join(c, "Users", spec["utente"], "Desktop")
        if not os.path.isdir(desk):
            desk = os.path.join(c, "Users", spec["utente"])
        fl = sorted(x for x in os.listdir(desk) if x.startswith("ABTG_OMBRA_INSTALL_"))
        r = dict(stdout=p.stdout, stderr=p.stderr, rc=p.returncode, desk=desk, files=fl, hits=srv.hits, out=out)
        r["txt"] = [x for x in fl if x.endswith(".txt") and not x.endswith("_PRIMA.txt")]
        r["pri"] = [x for x in fl if x.endswith("_PRIMA.txt")]
        r["zips"] = [x for x in fl if x.endswith(".zip")]
        r["referto"] = open(os.path.join(desk, r["txt"][-1]), encoding="ascii", errors="replace").read() if r["txt"] else ""
        r["prima"] = open(os.path.join(desk, r["pri"][-1]), encoding="ascii", errors="replace").read() if r["pri"] else ""
        return r
    finally:
        if spec["server"] != "giu":
            srv.chiudi()
        shutil.rmtree(out, ignore_errors=True)
