#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Genera righe/GOLDENZOE_EURJPY_BCM.ps1 (modello 14ea). Criteri: report/GOLDENZOE_EURJPY_CRITERI_2026-11-19.md"""
import os, sys, re, subprocess
AQ = os.path.dirname(os.path.abspath(__file__))
src = open(os.path.join(AQ, "gen_controllo_14ea_oro.py"), encoding="utf-8").read().split("pin = subprocess")[0]
exec(src)
pin = subprocess.check_output(["git", "-C", REPO, "rev-parse", "HEAD"]).decode().strip()
EA = "GoldenZoe_H4"
inp, sha = leggi(EA)
righe = ",\n".join("      '%s=%s'" % (a, b.replace("'", "''")) for a, b in inp)
eas_ps = "  @{ n='%s'; per='H4'; sha='%s'; inp=@(\n%s\n  ) }" % (EA, sha, righe)
V = [("LONG", ["InpAllowLong=true", "InpAllowShort=false"]),
     ("SHORT", ["InpAllowLong=false", "InpAllowShort=true"]),
     ("LONG_N40", ["InpAllowLong=true", "InpAllowShort=false", "InpDonchianN=40"]),
     ("LONG_N80", ["InpAllowLong=true", "InpAllowShort=false", "InpDonchianN=80"])]
VARS = "$VARS=@( " + ", ".join("@{ v='%s'; ea='%s'; ov=@(%s) }" % (n, EA, ",".join("'%s'" % o for o in ov)) for n, ov in V) + " )\n"
RUNS = ("$RUNS=@(); foreach($v in $VARS){ $e=$null; foreach($x in $EAS){ if($x.n -eq $v.ea){ $e=$x } }; "
        "$ovr=@{}; foreach($o in $v.ov){ $ovr[$o.Split('=')[0]]=$o }; "
        "$iv=@($e.inp | Where-Object { -not $ovr.ContainsKey($_.Split('=')[0]) }) + @($v.ov); "
        "$RUNS += @{ n=$e.n; per=$e.per; var=$v.v; inpv=$iv } }\n")
TF = [("H1", 16385), ("H2", 16386), ("H4", 16388), ("H6", 16390), ("H8", 16392)]
WIN = [("IS_2013_2020", "2013.01.01", "2020.12.31"), ("OOS_2021_2024", "2021.01.01", "2024.12.31")]
FIN = "$FIN=@( " + ", ".join("@{ n='%s_%s'; tf='%s'; tfv='%s'; da='%s'; a='%s' }" % (tf, w, tf, tv, da, a) for tf, tv in TF for w, da, a in WIN) + " )\n"
t = open(os.path.join(AQ, "righe", "_modello_controllo_14ea_oro.ps1.txt"), encoding="utf-8").read()
def R(a, b, n=1):
    global t
    assert t.count(a) == n, (t.count(a), a[:100])
    t = t.replace(a, b)
t = t.replace("MARCATORE_CONTROLLO_14EA_ORO_BCM_v1", "MARCATORE_GOLDENZOE_EURJPY_BCM_v1")
t = re.sub(r"^# TEST FUORI CAMPIONE dei 4 EA.*$", "# GoldenZoe su EURJPY: 5 TF (H1-H8) x IS 2013-20 / OOS 2021-24 x 4 varianti (LONG, SHORT, LONG_N40, LONG_N80), Modello 1, BCM portabile, SOLO tester. Criteri: report/GOLDENZOE_EURJPY_CRITERI_2026-11-19.md", t, count=1, flags=re.M)
R("@@PIN@@", pin); R("@@EAS@@", eas_ps)
R("$FIN=@( @{ n='W2015_2023'; da='2015.01.01'; a='2023.12.31' }, @{ n='W2005_2014'; da='2005.01.01'; a='2014.12.31' } )\n", FIN + VARS + RUNS)
R("$EAS.Count * $FIN.Count", "$RUNS.Count * $FIN.Count", t.count("$EAS.Count * $FIN.Count"))
R(" foreach($ea in $EAS){\n  if($stopTutto){ break }", " foreach($ea in $RUNS){\n  if($stopTutto){ break }")
R("$rep='T14_' + $ea.n.Replace('ABTG_','').Replace('_Ottimizzato','') + '_' + $f.n", "$rep='GE_' + $ea.var + '_' + $f.n")
R("$r += $ea.inp", "$r += (@($ea.inpv | Where-Object { $_ -notlike 'InpTF=*' }) + ('InpTF=' + $f.tfv))")
R("'Symbol=XAUUSD',('Period=' + $ea.per)", "'Symbol=EURJPY',('Period=' + $f.tf)")
R("$righe.Add($ea.n + ';' + $f.n + ';ERRORE", "$righe.Add($ea.var + ';' + $f.n + ';ERRORE")
R("$riga=($ea.n + ';' + $f.n + ';' + $nT", "$riga=($ea.var + ';' + $f.n + ';' + $nT")
R("'ea;finestra;operazioni;", "'variante;finestra;operazioni;")
R("TEST 4 EA ORO su BCM portabile", "TEST GOLDENZOE EURJPY su BCM portabile")
R("Durata attesa 15-60 minuti (STIMA)", "Durata attesa 1-2 ore (STIMA, 40 passate)")
t = t.replace("CONTROLLO_14EA_ORO", "GOLDENZOE_EURJPY").replace("controllo_14ea_oro", "goldenzoe_eurjpy")
open(os.path.join(AQ, "righe", "GOLDENZOE_EURJPY_BCM.ps1"), "w", encoding="utf-8", newline="").write(t)
print("scritto", len(t), "pin", pin, "input", len(inp), file=sys.stderr)
