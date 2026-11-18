#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Genera righe/CONTROLLO_PUNTELARRY_MODI_BCM.ps1 (controllo pulito 2024-2026) dal modello righe/_modello_controllo_14ea_oro.ps1.txt. Criteri: report/PUNTELARRY_ORO_MODI_CRITERI_2026-11-18.md. Default degli input letti dai sorgenti *_F1."""
import os, sys, re, hashlib, subprocess
AQ = os.path.dirname(os.path.abspath(__file__))
src = open(os.path.join(AQ, "gen_controllo_14ea_oro.py"), encoding="utf-8").read().split("pin = subprocess")[0]
src = src.replace('for part in m.group(2).split(","):', 'for part in re.sub(r"//[^\\n]*", "", m.group(2)).split(","):')
exec(src)
EAF = [("PunteLarry", "H1")]
OVR = {"InpUsaGuardian": "false", "InpVerbose": "false", "InpAutoTest": "false"}
inc_sha = hashlib.sha256(open(os.path.join(REPO, "mql5", "Include", "ABTG_PausaGuardian.mqh"), "rb").read()).hexdigest().upper()
pin = subprocess.check_output(["git", "-C", REPO, "rev-parse", "HEAD"]).decode().strip()
blocchi = []
for mode, tag in ((1, "SmashPunta"), (2, "Oops")):
    nome, per = "PunteLarry", "H1"
    inp, sha = leggi("ABTG_%s_F1" % nome)
    OV = dict(OVR); OV["InpPatternMode"] = str(mode)
    inp = [(a, OV.get(a, b)) for a, b in inp]
    assert dict(inp)["InpPatternMode"] == str(mode)
    righe = ",\n".join("      '%s=%s'" % (a, b.replace("'", "''")) for a, b in inp)
    blocchi.append("  @{ n='ABTG_%s_F1'; tag='%s'; per='%s'; sha='%s'; inc=@( @{ n='ABTG_PausaGuardian.mqh'; sha='%s' } ); inp=@(\n%s\n  ) }" % (nome, tag, per, sha, inc_sha, righe))
    print(tag, len(inp), "input", sha[:12], file=sys.stderr)
t = open(os.path.join(AQ, "righe", "_modello_controllo_14ea_oro.ps1.txt"), encoding="utf-8").read()
def R(a, b, n=1):
    global t
    assert t.count(a) == n, (t.count(a), a[:90])
    t = t.replace(a, b)
t = t.replace("MARCATORE_CONTROLLO_14EA_ORO_BCM_v1", "@@MARC@@")
t = re.sub(r"^# TEST FUORI CAMPIONE dei 4 EA.*$", "# PUNTELARRY ORO: modalita 1 (Smash punta) e 2 (Oops) dell EA ABTG PunteLarry (copia *_F1), DEFAULT, XAUUSD, Modello 1, 3 finestre, SOLO tester. Criteri: report/PUNTELARRY_ORO_MODI_CRITERI_2026-11-18.md.", t, count=1, flags=re.M)
R("@@PIN@@", pin); R("@@EAS@@", ",\n".join(blocchi))
R("'Experts\\TEST14'", "'Experts\\TESTF1'"); R("Expert=TEST14\\", "Expert=TESTF1\\")
R("$dst=Join-Path $dstDir ($ea.n + '.mq5'); Copy-Item -LiteralPath $src -Destination $dst -Force",
  "$dst=Join-Path $dstDir ($ea.n + '.mq5'); Copy-Item -LiteralPath $src -Destination $dst -Force\n"
  "  foreach($ic in $ea.inc){ $isrc=Join-Path $W $ic.n; Remove-Item -LiteralPath $isrc -Force -ErrorAction SilentlyContinue; irm ('https://raw.githubusercontent.com/claudiospadaro12/GITHUB/' + $PINSRC + '/mql5/Include/' + $ic.n + '?cb=' + [Guid]::NewGuid().ToString('N')) -OutFile $isrc; $ih=(Get-FileHash -LiteralPath $isrc -Algorithm SHA256).Hash.ToUpperInvariant(); if($ih -ne $ic.sha){ Write-Host ('MI FERMO: SHA256 diverso per ' + $ic.n + ': ' + $ih) -ForegroundColor Red; return }; Copy-Item -LiteralPath $isrc -Destination (Join-Path $dstDir $ic.n) -Force }")
R("$rep='T14_' + $ea.n.Replace('ABTG_','').Replace('_Ottimizzato','') + '_' + $f.n", "$rep='F1_' + $ea.n.Replace('ABTG_','').Replace('_F1','') + '_' + $ea.tag + '_' + $f.n")
R("$ea.n + ';' + $f.n + ';' + $nT", "$ea.n + ';' + $f.n + '_' + $ea.tag + ';' + $nT")
R("TEST 4 EA ORO su BCM portabile", "TEST PUNTELARRY MODALITA 1 E 2 su BCM portabile"); R("Durata attesa 15-60 minuti (STIMA)", "Durata attesa 30-90 minuti (STIMA)")
R("'controllo_14ea_oro'", "'puntelarry_modi'")
R("$FIN=@( @{ n='W2015_2023'; da='2015.01.01'; a='2023.12.31' }, @{ n='W2005_2014'; da='2005.01.01'; a='2014.12.31' } )", "$FIN=@( @{ n='W2024_2026'; da='2024.01.01'; a='2026.10.01' }, @{ n='W2015_2023'; da='2015.01.01'; a='2023.12.31' }, @{ n='W2005_2014'; da='2005.01.01'; a='2014.12.31' } )")
t = t.replace("CONTROLLO_14EA_ORO", "CONTROLLO_PUNTELARRY_MODI").replace("@@MARC@@", "MARCATORE_CONTROLLO_PUNTELARRY_MODI_BCM_v1")
open(os.path.join(AQ, "righe", "CONTROLLO_PUNTELARRY_MODI_BCM.ps1"), "w", encoding="utf-8", newline="").write(t)
print("scritto", len(t), "pin", pin, file=sys.stderr)
