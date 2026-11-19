#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Genera righe/BULGE_FASE0_BCM.ps1 (fase 0 del nuovo EA Bulge: report/SCHEDA_SALA_BULGE_NUOVO_EA_2026-11-19.md) dal modello righe/_modello_controllo_14ea_oro.ps1.txt (stessa struttura collaudata).
Criteri: report/BULGE_S_CRITERI_2026-11-18.md. Legge i DEFAULT degli input da mql5/Experts/ABTG_Bulge_S.mq5."""
import os, sys, re, hashlib, subprocess
AQ = os.path.dirname(os.path.abspath(__file__))
src = open(os.path.join(AQ, "gen_controllo_14ea_oro.py"), encoding="utf-8").read().split("pin = subprocess")[0]
src = src.replace('for part in m.group(2).split(","):', 'for part in re.sub(r"//[^\\n]*", "", m.group(2)).split(","):')
exec(src)                                    # definisce REPO, TF, leggi() (enum con commenti: ripuliti)
inp, sha = leggi("ABTG_Bulge_S")
inc_sha = hashlib.sha256(open(os.path.join(REPO, "mql5", "Include", "ABTG_PausaGuardian.mqh"), "rb").read()).hexdigest().upper()
pin = subprocess.check_output(["git", "-C", REPO, "rev-parse", "HEAD"]).decode().strip()
righe = ",\n".join("      '%s=%s'" % (a, b.replace("'", "''")) for a, b in inp)
eas = "  @{ n='ABTG_Bulge_S'; per='H1'; sha='%s'; inc=@( @{ n='ABTG_PausaGuardian.mqh'; sha='%s' } ); inp=@(\n%s\n  ) }" % (sha, inc_sha, righe)
t = open(os.path.join(AQ, "righe", "_modello_controllo_14ea_oro.ps1.txt"), encoding="utf-8").read()
def R(a, b, n=1):
    global t
    assert t.count(a) == n, (t.count(a), a[:90])
    t = t.replace(a, b)
t = t.replace("MARCATORE_CONTROLLO_14EA_ORO_BCM_v1", "@@MARC@@")
t = re.sub(r"^# TEST FUORI CAMPIONE dei 4 EA.*$", "# FASE 0 Bulge: ABTG_Bulge_S con Signal_Bar_Offset 0 (difetto R92, riproduce aprile) contro 1 (corretto), cestino GBPJPY/NZDJPY/AUDUSD/CADJPY/NZDCAD, grafico GBPUSD H1, 2022-01-01 -> 2026-03-30, 10.000 USD, Modello 1, BCM portabile, SOLO tester. Criteri: report/BULGE_S_CRITERI_2026-11-18.md. Non apre conti, non tocca VPS ne reale.", t, count=1, flags=re.M)
R("@@PIN@@", pin); R("@@EAS@@", eas)
R("'Experts\\TEST14'", "'Experts\\TESTBULGE'"); R("Expert=TEST14\\", "Expert=TESTBULGE\\")
R("$dst=Join-Path $dstDir ($ea.n + '.mq5'); Copy-Item -LiteralPath $src -Destination $dst -Force",
  "$dst=Join-Path $dstDir ($ea.n + '.mq5'); Copy-Item -LiteralPath $src -Destination $dst -Force\n"
  "  foreach($ic in $ea.inc){ $isrc=Join-Path $W $ic.n; Remove-Item -LiteralPath $isrc -Force -ErrorAction SilentlyContinue; irm ('https://raw.githubusercontent.com/claudiospadaro12/GITHUB/' + $PINSRC + '/mql5/Include/' + $ic.n + '?cb=' + [Guid]::NewGuid().ToString('N')) -OutFile $isrc; $ih=(Get-FileHash -LiteralPath $isrc -Algorithm SHA256).Hash.ToUpperInvariant(); if($ih -ne $ic.sha){ Write-Host ('MI FERMO: SHA256 diverso per ' + $ic.n + ': ' + $ih) -ForegroundColor Red; return }; Copy-Item -LiteralPath $isrc -Destination (Join-Path $dstDir $ic.n) -Force }")
R("$FIN=@( @{ n='W2015_2023'; da='2015.01.01'; a='2023.12.31' }, @{ n='W2005_2014'; da='2005.01.01'; a='2014.12.31' } )",
  "$FIN=@( @{ n='W2022_2026'; da='2022.01.01'; a='2026.03.30' } )\n"
  "$CESTINO='GBPJPY,NZDJPY,AUDUSD,CADJPY,NZDCAD'\n"
  "$APR=@('Use_ADX_Filter=false','Use_Kill_Switch=false','Max_Trades=10','Risk_Percent=1','Use_Blue=true','Use_Purple=true','Use_Orange=false','Blu_Entry_Mode=0','Use_ATR_Filter=true')\n"
  "$VARS=@( @{ v='A_OFF0_APRILE'; ov=($APR + @('Signal_Bar_Offset=0')) }, @{ v='B_OFF1_APRILE'; ov=($APR + @('Signal_Bar_Offset=1')) }, @{ v='C_OFF1_DEFAULT_S'; ov=@('Risk_Percent=1','Use_Blue=true','Use_Purple=true','Use_Orange=false','Blu_Entry_Mode=0','Signal_Bar_Offset=1') } )\n"
  "$RUNS=@(); foreach($vv in $VARS){ $ovr=@{}; foreach($o in (@('InpUsaGuardian=false','InpVerbose=false','InpAutoTest=false',('Symbols_List=' + $CESTINO)) + $vv.ov)){ $ovr[$o.Split('=')[0]]=$o }; $iv=@($EAS[0].inp | Where-Object { -not $ovr.ContainsKey($_.Split('=')[0]) }) + @($ovr.Values); $RUNS += ,@{ n=$EAS[0].n; per=$EAS[0].per; sym='GBPUSD'; var=$vv.v; inpv=$iv } }")
R("'ea;finestra;operazioni;", "'variante;coppia;anno;operazioni;")
R("TEST 4 EA ORO su BCM portabile", "FASE 0 BULGE su BCM portabile"); R("Durata attesa 15-60 minuti (STIMA)", "Durata attesa 20-60 minuti (STIMA, 3 passate)")
R("$EAS.Count * $FIN.Count", "$RUNS.Count * $FIN.Count", t.count("$EAS.Count * $FIN.Count"))
R(" foreach($ea in $EAS){\n  if($stopTutto){ break }", " foreach($ea in $RUNS){\n  if($stopTutto){ break }")
R("$rep='T14_' + $ea.n.Replace('ABTG_','').Replace('_Ottimizzato','') + '_' + $f.n", "$rep='BF0_' + $ea.var + '_' + $ea.sym + '_' + $f.n")
R("'Symbol=XAUUSD'", "('Symbol=' + $ea.sym)"); R("$r += $ea.inp", "$r += $ea.inpv"); R("'Deposit=100000'", "'Deposit=10000'"); R("'Currency=EUR'", "'Currency=USD'")
R("$ea.n + ';' + $f.n + ';ERRORE", "$ea.var + ';' + $ea.sym + ';' + $f.n + ';ERRORE")
R("$riga=($ea.n + ';' + $f.n + ';' + $nT", "$riga=($ea.var + ';' + $ea.sym + ';' + $f.n + ';' + $nT")
R("'controllo_14ea_oro'", "'bulge_fase0'")
t = t.replace("CONTROLLO_14EA_ORO", "BULGE_FASE0").replace("@@MARC@@", "MARCATORE_BULGE_FASE0_BCM_v1")
t = t.replace("TEST 4 EA ORO", "TEST BULGE_S")
open(os.path.join(AQ, "righe", "BULGE_FASE0_BCM.ps1"), "w", encoding="utf-8", newline="").write(t)
print("scritto", len(t), "pin", pin, "inp", len(inp), file=sys.stderr)
