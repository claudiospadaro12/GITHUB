#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Genera righe/BREAKOUT_CORSO_BCM.ps1 (modello 14ea): ABTG_BreakoutCorso, 28 cross x (H1, M30), 2013-2024, una passata per simbolo e timeframe. Criteri: report/BREAKOUT_CORSO_CRITERI_2026-11-19.md"""
import os, sys, re, subprocess
AQ = os.path.dirname(os.path.abspath(__file__))
src = open(os.path.join(AQ, "gen_controllo_14ea_oro.py"), encoding="utf-8").read().split("pin = subprocess")[0]
exec(src)
pin = subprocess.check_output(["git", "-C", REPO, "rev-parse", "HEAD"]).decode().strip()
EA = "ABTG_BreakoutCorso"
inp, sha = leggi(EA)
righe = ",\n".join("      '%s=%s'" % (a, b.replace("'", "''")) for a, b in inp)
eas_ps = "  @{ n='%s'; per='H1'; sha='%s'; inp=@(\n%s\n  ) }" % (EA, sha, righe)
SIM = "USDJPY EURJPY GBPJPY CHFJPY NZDJPY AUDJPY CADJPY XAUUSD".split()
assert len(SIM) == 8
VARS = "$VARS=@( " + ", ".join("@{ v='%s_M%d'; sym='%s'; per='M15'; ea='%s'; ov=@(%s) }" % (s_, m, s_, EA, "'InpRectMode=0'" if m == 0 else "") for s_ in SIM for m in (1, 0)) + " )\n"
RUNS = ("$RUNS=@(); foreach($v in $VARS){ $e=$null; foreach($x in $EAS){ if($x.n -eq $v.ea){ $e=$x } }; "
        "$ovn=@($v.ov | ForEach-Object { ($_ -split '=')[0] }); $iv=@($e.inp | Where-Object { $ovn -notcontains (($_ -split '=')[0]) }) + @($v.ov); "
        "$RUNS += @{ n=$e.n; per=$v.per; var=$v.v; sym=$v.sym; inpv=$iv } }\n")
t = open(os.path.join(AQ, "righe", "_modello_controllo_14ea_oro.ps1.txt"), encoding="utf-8").read()
def R(a, b, n=1):
    global t
    assert t.count(a) == n, (t.count(a), a[:100])
    t = t.replace(a, b)
t = t.replace("MARCATORE_CONTROLLO_14EA_ORO_BCM_v1", "MARCATORE_BREAKOUT_CORSO_BCM_v1")
t = re.sub(r"^# TEST FUORI CAMPIONE dei 4 EA.*$", "# ABTG_BreakoutCorso (strategia Breakout del corso, default) su 7 cross JPY + XAUUSD, M15, 2013-01-01 -> 2024-12-31, Modello 1, BCM portabile, SOLO tester: 16 passate (modo rettangolo 1 e 0). Criteri: report/BREAKOUT_CORSO_CRITERI_2026-11-19.md", t, count=1, flags=re.M)
R("@@PIN@@", pin); R("@@EAS@@", eas_ps)
R("$FIN=@( @{ n='W2015_2023'; da='2015.01.01'; a='2023.12.31' }, @{ n='W2005_2014'; da='2005.01.01'; a='2014.12.31' } )\n",
  "$FIN=@( @{ n='W2013_2024'; da='2013.01.01'; a='2024.12.31' } )\n" + VARS + RUNS)
R("$EAS.Count * $FIN.Count", "$RUNS.Count * $FIN.Count", t.count("$EAS.Count * $FIN.Count"))
R(" foreach($ea in $EAS){\n  if($stopTutto){ break }", " foreach($ea in $RUNS){\n  if($stopTutto){ break }")
R("$rep='T14_' + $ea.n.Replace('ABTG_','').Replace('_Ottimizzato','') + '_' + $f.n", "$rep='BC_' + $ea.var + '_' + $f.n")
R("$r += $ea.inp", "$r += $ea.inpv")
R("'Symbol=XAUUSD'", "('Symbol=' + $ea.sym)")
R("$righe.Add($ea.n + ';' + $f.n + ';ERRORE", "$righe.Add($ea.var + ';' + $f.n + ';ERRORE")
R("$riga=($ea.n + ';' + $f.n + ';' + $nT", "$riga=($ea.var + ';' + $f.n + ';' + $nT")
R("'ea;finestra;operazioni;", "'variante;finestra;operazioni;")
R("TEST 4 EA ORO su BCM portabile", "TEST BREAKOUT CORSO (BCM portabile)")
R("Durata attesa 15-60 minuti (STIMA)", "Durata attesa 1-3 ore (STIMA, 16 passate M15)")
t = t.replace("CONTROLLO_14EA_ORO", "BREAKOUT_CORSO").replace("controllo_14ea_oro", "breakout_corso")
open(os.path.join(AQ, "righe", "BREAKOUT_CORSO_BCM.ps1"), "w", encoding="utf-8", newline="").write(t)
print("scritto", len(t), "pin", pin, "input", len(inp), file=sys.stderr)
