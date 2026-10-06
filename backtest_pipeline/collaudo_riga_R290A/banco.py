#!/usr/bin/env python3
# -*- coding: ascii -*-
"""
banco.py -- il BANCO di PASSATA_STOP_SUPREV_NAS.ps1: costruisce un finto disco C: del PC di backtest (PSDrive in pwsh 7 su Linux), con UN terminale BCM finto (cartella dati con origin.txt UTF-16,
un grafico salvato senza EA, metaeditor/terminal finti), un server HTTP locale che serve i file del repo "al pin" (l'URL di GitHub raw dello script diventa quello locale: UNICA differenza dal testo vero),
e lancia lo script con le sostituzioni dei soli cmdlet che non esistono/non devono girare su Linux: Start-Process (terminale e MetaEditor -> sim_mt5.py) e Start-Sleep (no-op, o 300 ms con SLEEP_REALE=1).
Sono VERI: Get-Process (cerca davvero un 'terminal64'), Compress-Archive, Invoke-RestMethod, Select-String, Get-ChildItem, [IO.File]::Open, tutte le regex e i decimali del parser.
NON COPERTO (dichiarato): Windows PowerShell 5.1 (qui gira pwsh 7.4), MT5 vero, il formato esatto dei log/report oltre a quello letto nei file VERI del repo, i file bloccati da un altro processo,
OneDrive sul Desktop.
"""
import hashlib, http.server, json, os, shutil, subprocess, sys, tempfile, threading, time

QD = os.path.dirname(os.path.abspath(__file__))
REPO = os.path.abspath(os.path.join(QD, "..", ".."))
SCRIPT = os.path.join(REPO, "backtest_pipeline", "righe", "PASSATA_STOP_SUPREV_NAS.ps1")
RAW = "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/"
PIN = "a" * 40
TERM = "C:\\Program Files\\BCM Markets MT5 Terminal"
F_EA = "mql5/Experts/ABTG_SupertrendReversal.mq5"
F_INC = "mql5/Include/ABTG_PausaGuardian.mqh"
F_PROVA = "backtest_pipeline/prove/R290a_stop_SUPREV_NASUSD_LS_ancora970913.txt"
F_SPREAD = "backtest_pipeline/risultati_archivio/spread_flotta/spread_orario_NASUSD.csv"
F_SCRIPT = "backtest_pipeline/righe/PASSATA_STOP_SUPREV_NAS.ps1"


def utf16(s):
    return b"\xff\xfe" + s.encode("utf-16-le")


def spec_base(**kw):
    s = dict(macchina="DESKTOP-H4D7CAJ", chr=[{}], mt5_vivo=False, doppio_dati=False, altra_inst=False, pin=PIN, timeout_min=60, args_extra="",
             scen=dict(entries=[], report={}), muta={}, desktop_vecchio=False, log_vecchio=False, report_vecchio_in_inst=False, sleep_reale=False, no_exit=False, senza_origin=False)
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
    if not spec["senza_origin"]:
        open(os.path.join(dati, "origin.txt"), "wb").write(utf16(TERM))
    if spec["doppio_dati"]:
        os.makedirs(os.path.join(ap, "DDD444", "MQL5"))
        open(os.path.join(ap, "DDD444", "origin.txt"), "wb").write(utf16(TERM))
    if spec["altra_inst"]:
        os.makedirs(os.path.join(ap, "ZZZ999", "MQL5"))
        open(os.path.join(ap, "ZZZ999", "origin.txt"), "wb").write(utf16("C:\\MT5_Backtest"))
    cd = os.path.join(dati, "MQL5", "Profiles", "Charts", "Default")
    for i, ch in enumerate(spec["chr"]):
        p = os.path.join(cd, "chart%02d.chr" % (i + 1))
        if ch.get("illeggibile"):
            os.symlink("/nonexistent/x.chr", p)
        elif ch.get("ea"):
            open(p, "wb").write(utf16("<chart>\nsymbol=NASUSD\n<window>\n<expert>\nname=%s\n</expert>\n</window>\n</chart>\n" % ch["ea"]))
        else:
            open(p, "wb").write(utf16("<chart>\nsymbol=NASUSD\n</chart>\n"))
    if spec["desktop_vecchio"]:
        # i file della passata U30USD e una cartella/zip NAS vecchi: la U30USD NON si tocca, la NAS si sostituisce
        os.makedirs(os.path.join(user, "Desktop", "PASSATA_STOP_SUPREV"))
        open(os.path.join(user, "Desktop", "PASSATA_STOP_SUPREV", "U30.txt"), "w").write("vecchia U30USD\n")
        open(os.path.join(user, "Desktop", "PASSATA_STOP_SUPREV.zip"), "w").write("zip vecchio U30USD\n")
        os.makedirs(os.path.join(user, "Desktop", "PASSATA_STOP_SUPREV_NAS"))
        open(os.path.join(user, "Desktop", "PASSATA_STOP_SUPREV_NAS", "RESIDUO.txt"), "w").write("residuo NAS vecchio\n")
        open(os.path.join(user, "Desktop", "PASSATA_STOP_SUPREV_NAS.zip"), "w").write("zip NAS vecchio\n")
    if spec["log_vecchio"]:
        # un log dell'agente GIA' presente prima della passata, con ingressi e IMBUTO FALSI: la fotografia deve escluderli
        agent = os.path.join(user, "AppData", "Roaming", "MetaQuotes", "Tester", "AGENT1", "Agent-127.0.0.1-3000", "logs")
        os.makedirs(agent)
        vecchio = ("CS\t0\t09:00:00.001\tABTG_SupertrendReversal (NASUSD,H1)\t2024.10.01 14:00:00   [STReversal] LONG mercato 9.99 lot @ 100.00 SL 99.00 TP 103.00\r\n"
                   "CS\t0\t09:00:00.002\tABTG_SupertrendReversal (NASUSD,H1)\t2024.10.01 23:00:00   [STREV-IMBUTO] NASUSD PERIOD_H1 giorno 2024.10.01 | valutate 1 | ENTRATE 1 | quadratura OK\r\n")
        open(os.path.join(agent, "20261006.log"), "wb").write(utf16(vecchio))
    if spec["report_vecchio_in_inst"]:
        p = os.path.join(tdir, "PASSATA_STOP_NAS.htm")
        open(p, "wb").write(utf16("<html><table><tr><td>Profitto Totale Netto:</td><td><b>4699.00</b></td></tr><tr><td>Numero di Operazioni di Trading Totali:</td><td><b>172</b></td></tr></table></html>"))
        t = time.time() - 86400
        os.utime(p, (t, t))
    return c


def snapshot(c, escludi=("Users/Master/Desktop", "Users/Master/abtg_passata", "Users/Master/AppData/Roaming/MetaQuotes/Terminal/ABC123/MQL5",
                         "Users/Master/AppData/Roaming/MetaQuotes/Tester", "Users/Master/AppData/Roaming/MetaQuotes/Terminal/ABC123/logs",
                         "Users/Master/AppData/Roaming/MetaQuotes/Terminal/Common", "Users/Master/.cache", "Users/Master/.config", "Users/Master/.local")):
    out = {}
    for rd, dirs, files in os.walk(c):
        rel = os.path.relpath(rd, c).replace(os.sep, "/")
        if any(rel == e or rel.startswith(e + "/") for e in escludi):
            continue
        for f in files:
            if f.startswith("PASSATA_STOP_NAS") and f.endswith(".htm"):
                continue          # il report lo scrive il TERMINALE (il finto), non lo script
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
                corpo = s.files.get(p[2]) if len(p) == 3 and p[1] == spec["pin"].lower() else None
                if corpo is None:
                    self.send_response(404); self.send_header("Content-Length", "0"); self.end_headers(); return
                self.send_response(200); self.send_header("Content-Length", str(len(corpo))); self.end_headers(); self.wfile.write(corpo)

            def log_message(self, *a):
                pass
        self.srv = http.server.ThreadingHTTPServer(("127.0.0.1", 0), H)
        self.base = "http://127.0.0.1:%d/" % self.srv.server_address[1]
        threading.Thread(target=self.srv.serve_forever, daemon=True).start()
        self.files = {}
        for rel in (F_EA, F_INC, F_PROVA, F_SPREAD, F_SCRIPT):
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
if($env:CORROMPI -eq '1'){ function Set-Content { [CmdletBinding()] param([string]$LiteralPath, $Value, $Encoding, [switch]$NoNewline)
  if($LiteralPath -like '*PASSATA_STOP_SUPREV_NAS.ps1'){ $Value = $Value + '#x' }
  Microsoft.PowerShell.Management\Set-Content -LiteralPath $LiteralPath -Value $Value -Encoding $Encoding -NoNewline:$NoNewline } }
function powershell.exe { $a = @($args); $file = $null; $pin = $null
  for($i = 0; $i -lt $a.Count; $i++){ if($a[$i] -eq '-File'){ $file = $a[$i+1] }; if($a[$i] -eq '-Pin'){ $pin = $a[$i+1] } }
  & $file -Pin $pin }
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
    Add-Content -LiteralPath (Join-Path $env:SIM_LOG 'sim_terminal_lanci.txt') -Value ($FilePath + ' ' + $env:SIM_ARGS)
    & python3 $env:SIM_SCRIPT | Out-Host
    if($env:SIM_NOEXIT -ne '1'){ $o.chiuso = $true }
  }
  Add-Member -InputObject $o -MemberType ScriptProperty -Name HasExited -Value { $this.chiuso }
  Add-Member -InputObject $o -MemberType ScriptMethod -Name CloseMainWindow -Value { $this.chiuso = $true; Set-Content -LiteralPath $this.marcatore -Value 'close'; $true }
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
               SystemRoot="C:\\Windows", POWERSHELL_TELEMETRY_OPTOUT="1", POWERSHELL_UPDATECHECK="Off", CDRIVE=c, HOME=user, SIM_SCEN=scen, SIM_LOG=simlog, SIM_CDRIVE=c, SIM_SCRIPT=os.path.join(QD, "sim_mt5.py"),
               SLEEP_REALE="1" if spec["sleep_reale"] else "0", CORROMPI="1" if spec.get("corrompi") else "0", SIM_NOEXIT="1" if spec["no_exit"] else "0")
    os.makedirs(simlog, exist_ok=True)
    bindir = os.path.join(scen_dir, "bin"); os.makedirs(bindir, exist_ok=True)
    pid = None
    if spec["mt5_vivo"]:
        shutil.copy(shutil.which("sleep"), os.path.join(bindir, spec["mt5_vivo"]))
        pid = subprocess.Popen([os.path.join(bindir, spec["mt5_vivo"]), "300"])
        time.sleep(0.4)
    testo = open(SCRIPT, "rb").read()
    if spec.get("riga"):
        # modo RIGA: si esegue il testo della riga (Invoke-Expression, come incolla Claudio) con il SOLO URL di download dello script sostituito; lo script e' servito INALTERATO
        rt = spec["riga"].replace(RAW, srv.base)
        rf = os.path.join(scen_dir, "riga.ps1")
        open(rf, "w", newline="").write(rt)
        env["LOCAL_RAW"] = srv.base
        cmd = SETUP + "\n$ErrorActionPreference='Stop'; $t = Get-Content -Raw -LiteralPath '" + rf + "'; Invoke-Expression $t; 'FINE-HARNESS rc=' + $LASTEXITCODE\n"
        try:
            return subprocess.run(["pwsh", "-NoProfile", "-Command", cmd], env=env, capture_output=True, text=True, timeout=timeout)
        finally:
            if pid:
                pid.kill(); pid.wait()
    if spec.get("muta_script"):
        testo = spec["muta_script"](testo)
    testo = testo.replace(RAW.encode(), srv.base.encode())
    env["LOCAL_RAW"] = srv.base
    rf = os.path.join(scen_dir, "drv.ps1")
    open(rf, "wb").write(testo)
    args = "-Pin %s -TimeoutMin %d %s" % (spec["pin"], spec["timeout_min"], spec["args_extra"])
    cmd = SETUP + "\n$ErrorActionPreference='Stop'; & '" + rf + "' " + args + "; 'FINE-HARNESS rc=' + $LASTEXITCODE\n"
    try:
        p = subprocess.run(["pwsh", "-NoProfile", "-Command", cmd], env=env, capture_output=True, text=True, timeout=timeout)
    finally:
        if pid:
            pid.kill(); pid.wait()
    return p
