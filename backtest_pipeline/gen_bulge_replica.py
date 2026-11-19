#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Genera righe/BULGE_REPLICA_BCM.ps1 (modello 14ea). Criteri: report/BULGE_REPLICA_MASSIMO_CRITERI_2026-11-19.md"""
import os, sys, re, subprocess
AQ = os.path.dirname(os.path.abspath(__file__))
src = open(os.path.join(AQ, "gen_controllo_14ea_oro.py"), encoding="utf-8").read().split("pin = subprocess")[0]
exec(src)
pin = subprocess.check_output(["git", "-C", REPO, "rev-parse", "HEAD"]).decode().strip()
EA = "BreakingBand_MT5_v4"
inp, sha = leggi(EA)
righe = ",\n".join("      '%s=%s'" % (a, b.replace("'", "''")) for a, b in inp)
eas_ps = "  @{ n='%s'; per='H1'; sha='%s'; inp=@(\n%s\n  ) }" % (EA, sha, righe)
SIM = ["EURUSD", "EURCHF", "EURCAD"]; RISK = [("0.5", "r05"), ("2.0", "r20")]
VARS = "$VARS=@( " + ", ".join("@{ v='%s_%s'; sym='%s'; ea='%s'; ov=@('RiskPercent=%s') }" % (s, tag, s, EA, r) for s in SIM for r, tag in RISK) + " )\n"
RUNS = ("$RUNS=@(); foreach($v in $VARS){ $e=$null; foreach($x in $EAS){ if($x.n -eq $v.ea){ $e=$x } }; "
        "$ovr=@{}; foreach($o in $v.ov){ $ovr[$o.Split('=')[0]]=$o }; "
        "$iv=@($e.inp | Where-Object { -not $ovr.ContainsKey($_.Split('=')[0]) }) + @($v.ov); "
        "$RUNS += @{ n=$e.n; per=$e.per; var=$v.v; sym=$v.sym; inpv=$iv } }\n")
t = open(os.path.join(AQ, "righe", "_modello_controllo_14ea_oro.ps1.txt"), encoding="utf-8").read()
def R(a, b, n=1):
    global t
    assert t.count(a) == n, (t.count(a), a[:100])
    t = t.replace(a, b)
t = t.replace("MARCATORE_CONTROLLO_14EA_ORO_BCM_v1", "MARCATORE_BULGE_REPLICA_BCM_v1")
t = re.sub(r"^# TEST FUORI CAMPIONE dei 4 EA.*$", "# REPLICA della verifica di Massimo: BreakingBand_MT5_v4 su EURUSD, EURCHF, EURCAD, H1, finestre 2013-20 e 2020-26, rischio 0,5% e 2%, 100.000 EUR, Modello 1, BCM portabile, SOLO tester. Criteri: report/BULGE_REPLICA_MASSIMO_CRITERI_2026-11-19.md", t, count=1, flags=re.M)
R("@@PIN@@", pin); R("@@EAS@@", eas_ps)
R("$FIN=@( @{ n='W2015_2023'; da='2015.01.01'; a='2023.12.31' }, @{ n='W2005_2014'; da='2005.01.01'; a='2014.12.31' } )\n",
  "$FIN=@( @{ n='W2013_2020'; da='2013.01.01'; a='2020.12.31' }, @{ n='W2020_2026'; da='2020.01.01'; a='2026.10.31' } )\n" + VARS + RUNS)
R("$EAS.Count * $FIN.Count", "$RUNS.Count * $FIN.Count", t.count("$EAS.Count * $FIN.Count"))
R(" foreach($ea in $EAS){\n  if($stopTutto){ break }", " foreach($ea in $RUNS){\n  if($stopTutto){ break }")
R("$rep='T14_' + $ea.n.Replace('ABTG_','').Replace('_Ottimizzato','') + '_' + $f.n", "$rep='BR_' + $ea.var + '_' + $f.n")
R("$r += $ea.inp", "$r += $ea.inpv")
R("'Symbol=XAUUSD',('Period=' + $ea.per)", "('Symbol=' + $ea.sym),('Period=' + $ea.per)")
R("$righe.Add($ea.n + ';' + $f.n + ';ERRORE", "$righe.Add($ea.var + ';' + $f.n + ';ERRORE")
R("$riga=($ea.n + ';' + $f.n + ';' + $nT", "$riga=($ea.var + ';' + $f.n + ';' + $nT")
R("'ea;finestra;operazioni;", "'variante;finestra;operazioni;")
R("TEST 4 EA ORO su BCM portabile", "REPLICA BULGE (Massimo) su BCM portabile")
R("Durata attesa 15-60 minuti (STIMA)", "Durata attesa 30-60 minuti (STIMA, 12 passate)")
t = t.replace("CONTROLLO_14EA_ORO", "BULGE_REPLICA").replace("controllo_14ea_oro", "bulge_replica")
open(os.path.join(AQ, "righe", "BULGE_REPLICA_BCM.ps1"), "w", encoding="utf-8", newline="").write(t)
print("scritto", len(t), "pin", pin, "input", len(inp), file=sys.stderr)
