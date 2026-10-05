#!/usr/bin/env python3
# -*- coding: ascii -*-
"""
run_one.py -- esegue RIGA_DUKA_P0_CENSIMENTO.ps1 (o una sua copia mutata) dentro pwsh 7 su un finto C: (PSDrive C:), con Invoke-Expression come fa il bootstrap.
Funzioni del banco che SOSTITUISCONO i cmdlet assenti su Linux (hanno la precedenza sul cmdlet, come nei banchi di R280/EMAGEM2): Get-CimInstance
(i dischi, da env DISCHI_JSON), Get-Command (python reale / alias dello Store / assente, da env PYSCEN). Tutto il resto e' il cmdlet vero:
Get-ChildItem, Test-Path, Set-Content, Compress-Archive, Get-Process (con un finto terminal64 = copia di sleep).
"""
import json, os, shutil, subprocess, sys, tempfile

QD = os.path.dirname(os.path.abspath(__file__))
RIGA_DEFAULT = os.path.abspath(os.path.join(QD, "..", "righe", "RIGA_DUKA_P0_CENSIMENTO.ps1"))

SETUP = r'''
New-PSDrive -Name C -PSProvider FileSystem -Root $env:CDRIVE | Out-Null
function Get-CimInstance { [CmdletBinding()] param([Parameter(Position=0)][string]$ClassName, [string]$Filter)
  if($env:CIM_FALLISCE -eq "1"){ throw "CIM non disponibile (banco)" }
  foreach($d in @($env:DISCHI_JSON | ConvertFrom-Json)){ [pscustomobject]@{ DeviceID=$d.id; Size=[double]$d.size; FreeSpace=[double]$d.free } } }
function Get-Command { [CmdletBinding()] param([Parameter(Position=0)][string[]]$Name)
  if($env:PYSCEN -eq "real"){ [pscustomobject]@{ Name="python.exe"; Source="C:\Users\Master\AppData\Local\Programs\Python\Python312\python.exe" } }
  if($env:PYSCEN -eq "store"){ [pscustomobject]@{ Name="python.exe"; Source="C:\Users\Master\AppData\Local\Microsoft\WindowsApps\python.exe" } } }
'''


def esegui(spec, c, riga=None, extra_env=None, pin=None, sha=None, timeout=300):
    riga = riga or RIGA_DEFAULT
    out = tempfile.mkdtemp(prefix="p0run_", dir=os.environ.get("HARNESS_TMP", None))
    env = dict(os.environ)
    env.update(COMPUTERNAME=spec["macchina"], USERNAME="Master", USERPROFILE="C:\\Users\\Master",
               APPDATA="C:\\Users\\Master\\AppData\\Roaming", SystemRoot="C:\\Windows", CDRIVE=c,
               DISCHI_JSON=json.dumps(spec["dischi"]), PYSCEN=spec["python"])
    if extra_env:
        env.update(extra_env)
    bindir = os.path.join(out, "bin")
    os.makedirs(bindir)
    pid = None
    if spec["mt5_vivo"]:
        shutil.copy(shutil.which("sleep"), os.path.join(bindir, "terminal64"))
        pid = subprocess.Popen([os.path.join(bindir, "terminal64"), "120"])
    pre = ""
    if pin:
        pre += "$DUKA_P0_PIN='%s'; " % pin
    if sha:
        pre += "$DUKA_P0_SHA='%s'; " % sha
    cmd = SETUP + "\n" + pre + "\n$ErrorActionPreference='Stop'; $t = Get-Content -Raw -LiteralPath $env:RIGA_FILE; Invoke-Expression $t; 'FINE-HARNESS-ARRIVATO'\n"
    env["RIGA_FILE"] = riga
    try:
        p = subprocess.run(["pwsh", "-NoProfile", "-Command", cmd], env=env, capture_output=True, text=True, timeout=timeout)
    finally:
        if pid:
            pid.kill(); pid.wait()
    desk = os.path.join(c, "Users", "Master", "Desktop")
    if not os.path.isdir(desk):
        desk = os.path.join(c, "Users", "Master")        # il ripiego di USERPROFILE quando manca il Desktop
    cart = sorted(x for x in os.listdir(desk) if x.startswith("DUKA_P0_") and not x.endswith(".zip"))
    zips = sorted(x for x in os.listdir(desk) if x.endswith(".zip"))
    r = dict(stdout=p.stdout, stderr=p.stderr, rc=p.returncode, desk=desk, cartelle=cart, zips=zips, out=out)
    r["referto"] = ""
    if cart:
        f = os.path.join(desk, cart[-1], "REFERTO_DUKA_P0.txt")
        if os.path.exists(f):
            r["referto"] = open(f, encoding="ascii", errors="replace").read()
    shutil.rmtree(out, ignore_errors=True)
    return r
