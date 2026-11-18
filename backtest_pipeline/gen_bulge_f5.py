#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Genera righe/BULGE_F5_BCM.ps1 dal modello righe/_modello_controllo_14ea_oro.ps1.txt (stessa struttura collaudata).
Criteri: report/BULGE_F5_CRITERI_2026-11-18.md. Legge i DEFAULT degli input da mql5/Experts/ABTG_Bulge_F5.mq5."""
import os, sys, re, hashlib, subprocess
AQ = os.path.dirname(os.path.abspath(__file__))
src = open(os.path.join(AQ, "gen_controllo_14ea_oro.py"), encoding="utf-8").read().split("pin = subprocess")[0]
src = src.replace('for part in m.group(2).split(","):', 'for part in re.sub(r"//[^\\n]*", "", m.group(2)).split(","):')
exec(src)                                    # definisce REPO, TF, leggi() (enum con commenti: ripuliti)
inp, sha = leggi("ABTG_Bulge_F5")
inc_sha = hashlib.sha256(open(os.path.join(REPO, "mql5", "Include", "ABTG_PausaGuardian.mqh"), "rb").read()).hexdigest().upper()
pin = subprocess.check_output(["git", "-C", REPO, "rev-parse", "HEAD"]).decode().strip()
righe = ",\n".join("      '%s=%s'" % (a, b.replace("'", "''")) for a, b in inp)
eas = "  @{ n='ABTG_Bulge_F5'; per='H1'; sha='%s'; inc=@( @{ n='ABTG_PausaGuardian.mqh'; sha='%s' } ); inp=@(\n%s\n  ) }" % (sha, inc_sha, righe)
t = open(os.path.join(AQ, "righe", "_modello_controllo_14ea_oro.ps1.txt"), encoding="utf-8").read()
def R(a, b, n=1):
    global t
    assert t.count(a) == n, (t.count(a), a[:90])
    t = t.replace(a, b)
t = t.replace("MARCATORE_CONTROLLO_14EA_ORO_BCM_v1", "@@MARC@@")
t = re.sub(r"^# TEST FUORI CAMPIONE dei 4 EA.*$", "# BULGE_F5: Blu con filtro F5 (bulge simmetrico), 22 cross x 4 anni x 2 varianti, H1, Modello 1, BCM portabile, SOLO tester. Criteri: report/BULGE_F5_CRITERI_2026-11-18.md. Non apre conti, non tocca VPS ne reale.", t, count=1, flags=re.M)
R("@@PIN@@", pin); R("@@EAS@@", eas)
R("'Experts\\TEST14'", "'Experts\\TESTBULGE'"); R("Expert=TEST14\\", "Expert=TESTBULGE\\")
R("$dst=Join-Path $dstDir ($ea.n + '.mq5'); Copy-Item -LiteralPath $src -Destination $dst -Force",
  "$dst=Join-Path $dstDir ($ea.n + '.mq5'); Copy-Item -LiteralPath $src -Destination $dst -Force\n"
  "  foreach($ic in $ea.inc){ $isrc=Join-Path $W $ic.n; Remove-Item -LiteralPath $isrc -Force -ErrorAction SilentlyContinue; irm ('https://raw.githubusercontent.com/claudiospadaro12/GITHUB/' + $PINSRC + '/mql5/Include/' + $ic.n + '?cb=' + [Guid]::NewGuid().ToString('N')) -OutFile $isrc; $ih=(Get-FileHash -LiteralPath $isrc -Algorithm SHA256).Hash.ToUpperInvariant(); if($ih -ne $ic.sha){ Write-Host ('MI FERMO: SHA256 diverso per ' + $ic.n + ': ' + $ih) -ForegroundColor Red; return }; Copy-Item -LiteralPath $isrc -Destination (Join-Path $dstDir $ic.n) -Force }")
R("$FIN=@( @{ n='W2015_2023'; da='2015.01.01'; a='2023.12.31' }, @{ n='W2005_2014'; da='2005.01.01'; a='2014.12.31' } )",
  "$FIN=@( @{ n='2022'; da='2022.01.01'; a='2022.12.31' }, @{ n='2023'; da='2023.01.01'; a='2023.12.31' }, @{ n='2024'; da='2024.01.01'; a='2024.12.31' }, @{ n='2025'; da='2025.01.01'; a='2025.12.31' } )\n"
  "$PAIRS=@('EURUSD','GBPUSD','AUDUSD','NZDUSD','USDCAD','USDCHF','USDJPY','EURGBP','EURNZD','GBPJPY','GBPAUD','GBPCAD','GBPNZD','AUDJPY','AUDCAD','AUDNZD','NZDJPY','NZDCAD','NZDCHF','CADJPY','CADCHF','CHFJPY')\n"
  "$VARS=@( @{ v='BLUC_F5'; ov=@('Use_Purple=false','Blu_Entry_Mode=0','Blu_F5_Filter=true') }, @{ v='BLUS_F5'; ov=@('Use_Purple=false','Blu_Entry_Mode=1','Blu_F5_Filter=true') } )\n"
  "$RUNS=@(); foreach($vv in $VARS){ foreach($pp in $PAIRS){ $ovr=@{}; foreach($o in (@('InpUsaGuardian=false','InpVerbose=false','InpAutoTest=false',('Symbols_List=' + $pp)) + $vv.ov)){ $ovr[$o.Split('=')[0]]=$o }; $iv=@($EAS[0].inp | Where-Object { -not $ovr.ContainsKey($_.Split('=')[0]) }) + @($ovr.Values); $RUNS += ,@{ n=$EAS[0].n; per=$EAS[0].per; sym=$pp; var=$vv.v; inpv=$iv } } }")
R("'ea;finestra;operazioni;", "'variante;coppia;anno;operazioni;")
R("TEST 4 EA ORO su BCM portabile", "TEST BULGE_F5 (22 cross) su BCM portabile"); R("Durata attesa 15-60 minuti (STIMA)", "Durata attesa 4-8 ore (STIMA, 176 passate)")
R("$EAS.Count * $FIN.Count", "$RUNS.Count * $FIN.Count", t.count("$EAS.Count * $FIN.Count"))
R(" foreach($ea in $EAS){\n  if($stopTutto){ break }", " foreach($ea in $RUNS){\n  if($stopTutto){ break }")
R("$rep='T14_' + $ea.n.Replace('ABTG_','').Replace('_Ottimizzato','') + '_' + $f.n", "$rep='BF5_' + $ea.var + '_' + $ea.sym + '_' + $f.n")
R("'Symbol=XAUUSD'", "('Symbol=' + $ea.sym)"); R("$r += $ea.inp", "$r += $ea.inpv"); R("'Deposit=100000'", "'Deposit=10000'")
R("$ea.n + ';' + $f.n + ';ERRORE", "$ea.var + ';' + $ea.sym + ';' + $f.n + ';ERRORE")
R("$riga=($ea.n + ';' + $f.n + ';' + $nT", "$riga=($ea.var + ';' + $ea.sym + ';' + $f.n + ';' + $nT")
R("'controllo_14ea_oro'", "'bulge_f5'")
t = t.replace("CONTROLLO_14EA_ORO", "BULGE_F5").replace("@@MARC@@", "MARCATORE_BULGE_F5_BCM_v1")
t = t.replace("TEST 4 EA ORO", "TEST BULGE_S")
open(os.path.join(AQ, "righe", "BULGE_F5_BCM.ps1"), "w", encoding="utf-8", newline="").write(t)
print("scritto", len(t), "pin", pin, "inp", len(inp), file=sys.stderr)
