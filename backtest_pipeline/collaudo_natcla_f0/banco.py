#!/usr/bin/env python3
# -*- coding: ascii -*-
"""
banco.py -- il BANCO di NATCLA_F0_PASSATE.ps1 (derivato da collaudo_riga_R290A/banco.py): costruisce un finto disco C: del PC di backtest (PSDrive in pwsh 7 su Linux) con il terminale BCM finto,
le due installazioni censite il 05/10 (C:\\MT5_Backtest, C:\\FundedNext_Manuale) con un EA sul loro grafico, un server HTTP locale che serve i file del repo "al pin" (l'URL di GitHub raw diventa
quello locale: UNICA differenza dal testo vero), e lancia lo script con le sostituzioni dei soli cmdlet che non esistono/non devono girare su Linux: Start-Process (terminale e MetaEditor ->
sim_mt5.py) e Start-Sleep (no-op, o 300 ms con sleep_reale). Sono VERI: Get-Process, Compress-Archive, Invoke-RestMethod, Get-FileHash, Select-String, Get-ChildItem, [IO.File]::Open, il Mutex, le regex.
NON COPERTO (dichiarato): Windows PowerShell 5.1 (qui pwsh 7.4), MT5 e MetaEditor veri, il formato esatto dei log oltre a quello letto nei file veri del repo, file bloccati da un altro processo, OneDrive sul Desktop.
"""
import hashlib, http.server, json, os, shutil, subprocess, sys, tempfile, threading, time

QD = os.path.dirname(os.path.abspath(__file__))
REPO = os.path.abspath(os.path.join(QD, "..", ".."))
SCRIPT = os.path.join(REPO, "backtest_pipeline", "righe", "NATCLA_F0_PASSATE.ps1")
RAW = "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/"
PIN = "a" * 40
TERM = "C:\\Program Files\\BCM Markets MT5 Terminal"
F_EA = "mql5/Experts/EA_NatCla.mq5"
F_INC = "mql5/Include/ABTG_PausaGuardian.mqh"
F_PROVA = "backtest_pipeline/prove/NATCLA_F0_conteggio_2026-10-07.txt"
F_SCRIPT = "backtest_pipeline/righe/NATCLA_F0_PASSATE.ps1"


def utf16(s):
    return b"\xff\xfe" + s.encode("utf-16-le")


def sha(b):
    return hashlib.sha256(b).hexdigest().upper()


def spec_base(**kw):
    s = dict(macchina="DESKTOP-H4D7CAJ", chr=[{}], mt5_vivo=False, doppio_dati=False, altra_inst=False, pin=PIN, lotto="PILOTA", timeout_min=20, args_extra="", scen={}, muta={}, desktop_vecchio=False,
             log_vecchio=False, sleep_reale=False, no_exit=False, senza_origin=False, censite=True, sha_override={}, muta_script=None, riga=None, mutex_occupato=False, prova_tetto=None)
    s.update(kw)
    return s


def costruisci(base, spec):
    c = os.path.join(base, "cdrive")
    shutil.rmtree(c, ignore_errors=True)
    user = os.path.join(c, "Users", "Master")
    os.makedirs(os.path.join(user, "Desktop"))
    tdir = os.path.join(c, "Program Files", "BCM Markets MT5 Terminal")
    os.makedirs(tdir)
    open(os.path.join(tdir, "terminal64.exe"), "wb").write(b"x")
    open(os.path.join(tdir, "metaeditor64.exe"), "wb").write(b"x")
    ap = os.path.join(user, "AppData", "Roaming", "MetaQuotes", "Terminal")
    dati = os.path.join(ap, "ABC123")
    for sub in ("Experts", "Include", "Files", "Logs", os.path.join("Profiles", "Charts", "Default")):
        os.makedirs(os.path.join(dati, "MQL5", sub))
    os.makedirs(os.path.join(ap, "Common", "Files"))
    if not spec["senza_origin"]:
        open(os.path.join(dati, "origin.txt"), "wb").write(utf16(TERM))
    if spec["doppio_dati"]:
        os.makedirs(os.path.join(ap, "DDD444", "MQL5"))
        open(os.path.join(ap, "DDD444", "origin.txt"), "wb").write(utf16(TERM))
    if spec["altra_inst"]:
        os.makedirs(os.path.join(ap, "ZZZ999", "MQL5"))
        open(os.path.join(ap, "ZZZ999", "origin.txt"), "wb").write(utf16("C:\\MT5_Altro"))
    if spec["censite"]:
        for dd, inst in (("04C7A32B575E40027B4FF8724D14D702", "C:\\MT5_Backtest"), ("2B8180C37317B90DC37E3BF8A8CBE715", "C:\\FundedNext_Manuale")):
            cc = os.path.join(ap, dd, "MQL5", "Profiles", "Charts", "Default")
            os.makedirs(cc); os.makedirs(os.path.join(ap, dd, "MQL5", "Experts")); os.makedirs(os.path.join(ap, dd, "logs"))
            open(os.path.join(ap, dd, "origin.txt"), "wb").write(utf16(inst))
            open(os.path.join(cc, "chart01.chr"), "wb").write(utf16("<chart>\nsymbol=EURUSD\n<window>\n<expert>\nname=QUALUNQUE\n</expert>\n</window>\n</chart>\n"))
            open(os.path.join(ap, dd, "MQL5", "Experts", "QUALUNQUE.ex5"), "wb").write(b"x")
    cd = os.path.join(dati, "MQL5", "Profiles", "Charts", "Default")
    for i, ch in enumerate(spec["chr"]):
        p = os.path.join(cd, "chart%02d.chr" % (i + 1))
        if ch.get("illeggibile"):
            os.symlink("/nonexistent/x.chr", p)
        elif ch.get("ea"):
            open(p, "wb").write(utf16("<chart>\nsymbol=EURUSD\n<window>\n<expert>\nname=%s\n</expert>\n</window>\n</chart>\n" % ch["ea"]))
        else:
            open(p, "wb").write(utf16("<chart>\nsymbol=EURUSD\n</chart>\n"))
    if spec["desktop_vecchio"]:
        os.makedirs(os.path.join(user, "Desktop", "NATCLA_F0_PILOTA"))
        open(os.path.join(user, "Desktop", "NATCLA_F0_PILOTA", "RESIDUO.txt"), "w").write("residuo di un giro vecchio\n")
        open(os.path.join(user, "Desktop", "NATCLA_F0_PILOTA.zip"), "w").write("zip vecchio\n")
    if spec["log_vecchio"]:
        # un log dell'agente GIA' presente prima del lotto, con un AVVIO FALSO: la fotografia deve escluderlo
        agent = os.path.join(user, "AppData", "Roaming", "MetaQuotes", "Tester", "AGENT1", "Agent-127.0.0.1-3000", "logs")
        os.makedirs(agent)
        vecchio = ("CS\t0\t09:00:00.001\tEA_NatCla (EURUSD,H1)\t2024.07.05 00:00:00   [NatCla] AVVIO v1.00 | modalita' PDF | EURUSD PERIOD_H4 | 1 u = 9 (x) | 1 pip = 9 | magic 778614 | linee ST35 | "
                   "ADX spento, iADX MetaQuotes, max 20.0, periodo 14 | ingresso MERCATO_PIU_PENDENTE | rischio setup 0.25% (SEGNAPOSTO DA FIRMARE DA CLAUDIO) | guardian ON | solo conta no | placebo 0.00 ATR | fonte x\r\n")
        open(os.path.join(agent, "20261008.log"), "wb").write(utf16(vecchio))
    return c


def snapshot(c, escludi=("Users/Master/Desktop", "Users/Master/abtg_passata", "Users/Master/AppData/Roaming/MetaQuotes/Terminal/ABC123/MQL5", "Users/Master/AppData/Roaming/MetaQuotes/Tester",
                         "Users/Master/AppData/Roaming/MetaQuotes/Terminal/ABC123/Tester", "Users/Master/AppData/Roaming/MetaQuotes/Terminal/Common", "Users/Master/.cache",
                         "Users/Master/.config", "Users/Master/.local")):
    out = {}
    for rd, dirs, files in os.walk(c):
        rel = os.path.relpath(rd, c).replace(os.sep, "/")
        if any(rel == e or rel.startswith(e + "/") for e in escludi):
            continue
        for f in files:
            p = os.path.join(rd, f)
            out[os.path.join(rel, f)] = ("link" if os.path.islink(p) else hashlib.sha256(open(p, "rb").read()).hexdigest())
    return out


class Srv:
    """serve /<pin>/<percorso> con i file del repo (working tree), mutati se richiesto"""
    def __init__(self, spec):
        self.hits = []
        s = self
        muta = spec["muta"]

        class H(http.server.BaseHTTPRequestHandler):
            def do_GET(self):
                s.hits.append(self.path)
                p = self.path.split("?")[0].split("/", 2)
                corpo = s.files.get(p[2]) if len(p) == 3 and p[1] == spec.get("pin_srv", spec["pin"]).lower() else None
                if corpo is None:
                    self.send_response(404); self.send_header("Content-Length", "0"); self.end_headers(); return
                self.send_response(200); self.send_header("Content-Length", str(len(corpo))); self.end_headers(); self.wfile.write(corpo)

            def log_message(self, *a):
                pass
        self.srv = http.server.ThreadingHTTPServer(("127.0.0.1", 0), H)
        self.base = "http://127.0.0.1:%d/" % self.srv.server_address[1]
        threading.Thread(target=self.srv.serve_forever, daemon=True).start()
        self.files = {}
        for rel in (F_EA, F_INC, F_PROVA, F_SCRIPT):
            b = open(os.path.join(REPO, rel), "rb").read()
            f = muta.get(rel)
            if f:
                b = f(b)
            self.files[rel] = b

    def chiudi(self):
        self.srv.shutdown(); self.srv.server_close()


SETUP = r'''
function Invoke-RestMethod { [CmdletBinding()] param([string]$Uri, [string]$OutFile)
  $u2 = $Uri.Replace('https://raw.githubusercontent.com/claudiospadaro12/GITHUB/', $env:LOCAL_RAW)
  Microsoft.PowerShell.Utility\Invoke-RestMethod -Uri $u2 -OutFile $OutFile }
function powershell.exe { $a = @($args); $file = $null; $h = @{}
  for($i = 0; $i -lt $a.Count; $i++){ if($a[$i] -eq '-File'){ $file = $a[$i+1]; $i++; continue }
    if(("$($a[$i])").StartsWith('-') -and ($i + 1) -lt $a.Count -and $a[$i] -notin @('-NoProfile','-ExecutionPolicy')){ $h[("$($a[$i])").Substring(1)] = $a[$i+1]; $i++ } }
  & $file @h }
$PSStyle.OutputRendering = 'PlainText'; $ErrorView = 'NormalView'
New-PSDrive -Name C -PSProvider FileSystem -Root $env:CDRIVE | Out-Null
function Start-Sleep { [CmdletBinding()] param([int]$Seconds, [int]$Milliseconds)
  if($env:SLEEP_REALE -eq '1'){ Microsoft.PowerShell.Utility\Start-Sleep -Milliseconds 300 } }
function Start-Process { [CmdletBinding()] param([string]$FilePath, [string[]]$ArgumentList, [switch]$PassThru)
  $env:SIM_ARGS = ($ArgumentList -join ' ')
  $env:SIM_ARGV_JSON = (ConvertTo-Json -InputObject @($ArgumentList) -Compress)
  $o = [pscustomobject]@{ chiuso = $false; marcatore = (Join-Path $env:SIM_LOG 'sim_closemainwindow.txt') }
  if($FilePath -like '*metaeditor64.exe'){ $env:SIM_KIND = 'editor'; & python3 $env:SIM_SCRIPT | Out-Host; $o.chiuso = $true }
  else {
    $env:SIM_KIND = 'terminal'
    Add-Content -LiteralPath (Join-Path $env:SIM_LOG 'sim_terminal_lanci.txt') -Value ('LANCIO ' + $FilePath + ' ' + $env:SIM_ARGS)
    & python3 $env:SIM_SCRIPT | Out-Host
    if($env:SIM_NOEXIT -ne '1'){ $o.chiuso = $true }
  }
  Add-Member -InputObject $o -MemberType ScriptProperty -Name HasExited -Value { $this.chiuso }
  Add-Member -InputObject $o -MemberType ScriptMethod -Name CloseMainWindow -Value { if($env:SIM_NOCLOSE -ne '1'){ $this.chiuso = $true }; Set-Content -LiteralPath $this.marcatore -Value 'close'; $true }
  Add-Member -InputObject $o -MemberType ScriptMethod -Name Kill -Value { $this.chiuso = $true }
  return $o }
'''


def esegui(spec, c, srv, scen_dir, timeout=900):
    env = dict(os.environ)
    scen = os.path.join(scen_dir, "scen.json")
    json.dump(spec["scen"], open(scen, "w"))
    tmp = os.path.join(scen_dir, "tmp"); os.makedirs(tmp, exist_ok=True)
    simlog = os.path.join(scen_dir, "simlog")
    user = os.path.join(c, "Users", "Master")
    env.update(COMPUTERNAME=spec["macchina"], USERNAME="Master", USERPROFILE="C:\\Users\\Master", APPDATA="C:\\Users\\Master\\AppData\\Roaming", TEMP=tmp, TMP=tmp,
               SystemRoot="C:\\Windows", POWERSHELL_TELEMETRY_OPTOUT="1", POWERSHELL_UPDATECHECK="Off", CDRIVE=c, HOME=user, SIM_SCEN=scen, SIM_LOG=simlog, SIM_CDRIVE=c,
               SIM_SCRIPT=os.path.join(QD, "sim_mt5.py"), SIM_REPO_BP=os.path.join(REPO, "backtest_pipeline"),
               SLEEP_REALE="1" if spec["sleep_reale"] else "0", SIM_NOEXIT="1" if spec["no_exit"] else "0", SIM_NOCLOSE="1" if spec.get("no_close") else "0", LOCAL_RAW=srv.base)
    os.makedirs(simlog, exist_ok=True)
    bindir = os.path.join(scen_dir, "bin"); os.makedirs(bindir, exist_ok=True)
    pid = None
    if spec["mt5_vivo"]:
        shutil.copy(shutil.which("sleep"), os.path.join(bindir, spec["mt5_vivo"]))
        pid = subprocess.Popen([os.path.join(bindir, spec["mt5_vivo"]), "300"])
        time.sleep(0.4)
    mx = None
    if spec["mutex_occupato"]:
        mx = subprocess.Popen(["pwsh", "-NoProfile", "-Command", "$m = New-Object System.Threading.Mutex($false, 'Global\\ABTG_NATCLA_F0'); [void]$m.WaitOne(); Start-Sleep -Seconds 120"], env=env)
        time.sleep(3)
    if spec.get("mutex_abbandonato"):
        # un giro che prende il blocco e muore (kill -9) senza rilasciarlo: il blocco resta ABBANDONATO
        ab = subprocess.Popen(["pwsh", "-NoProfile", "-Command", "$m = New-Object System.Threading.Mutex($false, 'Global\\ABTG_NATCLA_F0'); [void]$m.WaitOne(); Start-Sleep -Seconds 120"], env=env)
        time.sleep(3)
        ab.kill(); ab.wait()
        time.sleep(1)
    ea_b, inc_b, pr_b = srv.files[F_EA], srv.files[F_INC], srv.files[F_PROVA]
    sh = dict(ea=sha(ea_b), inc=sha(inc_b), prova=sha(pr_b))
    sh.update(spec["sha_override"])
    testo = open(SCRIPT, "rb").read()
    try:
        if spec.get("riga"):
            rt = spec["riga"].replace(RAW, srv.base)
            rf = os.path.join(scen_dir, "riga.ps1")
            open(rf, "w", newline="").write(rt)
            cmd = SETUP + "\n$ErrorActionPreference='Stop'; $t = Get-Content -Raw -LiteralPath '" + rf + "'; Invoke-Expression $t; 'FINE-HARNESS rc=' + $LASTEXITCODE\n"
            return subprocess.run(["pwsh", "-NoProfile", "-Command", cmd], env=env, capture_output=True, text=True, timeout=timeout)
        if spec.get("muta_script"):
            testo = spec["muta_script"](testo)
        testo = testo.replace(RAW.encode(), srv.base.encode())
        rf = os.path.join(scen_dir, "drv.ps1")
        open(rf, "wb").write(testo)
        args = "-Pin %s -Lotto %s -ShaEA %s -ShaInc %s -ShaProva %s -TimeoutRunMin %d %s" % (spec["pin"], spec["lotto"], sh["ea"], sh["inc"], sh["prova"], spec["timeout_min"], spec["args_extra"])
        cmd = SETUP + "\n$ErrorActionPreference='Stop'; & '" + rf + "' " + args + "; 'FINE-HARNESS rc=' + $LASTEXITCODE\n"
        return subprocess.run(["pwsh", "-NoProfile", "-Command", cmd], env=env, capture_output=True, text=True, timeout=timeout)
    finally:
        if pid:
            pid.kill(); pid.wait()
        if mx:
            mx.kill(); mx.wait()
