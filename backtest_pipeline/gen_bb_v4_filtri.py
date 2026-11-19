#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Genera righe/BB_V4_FILTRI_BCM.ps1 (modello 14ea): BreakingBand_MT5_v4, 28 cross x (H1, M30), 2013-2024, una passata per simbolo e timeframe. Criteri: report/BB_V4_FILTRI_LEONARDO_CRITERI_2026-11-19.md"""
import os, sys, re, subprocess
AQ = os.path.dirname(os.path.abspath(__file__))
src = open(os.path.join(AQ, "gen_controllo_14ea_oro.py"), encoding="utf-8").read().split("pin = subprocess")[0]
exec(src)
pin = subprocess.check_output(["git", "-C", REPO, "rev-parse", "HEAD"]).decode().strip()
EA = "BreakingBand_MT5_v4"
inp, sha = leggi(EA)
righe = ",\n".join("      '%s=%s'" % (a, b.replace("'", "''")) for a, b in inp)
eas_ps = "  @{ n='%s'; per='H1'; sha='%s'; inp=@(\n%s\n  ) }" % (EA, sha, righe)
SIM = "AUDCAD AUDCHF AUDJPY AUDNZD AUDUSD CADCHF CADJPY CHFJPY EURAUD EURCAD EURCHF EURGBP EURJPY EURNZD EURUSD GBPAUD GBPCAD GBPCHF GBPJPY GBPNZD GBPUSD NZDCAD NZDCHF NZDJPY NZDUSD USDCAD USDCHF USDJPY".split()
assert len(SIM) == 28
VARS = "$VARS=@( " + ", ".join("@{ v='%s_%s'; sym='%s'; per='%s'; ea='%s'; ov=@() }" % (s, tf, s, tf, EA) for s in SIM for tf in ("H1", "M30")) + " )\n"
RUNS = ("$RUNS=@(); foreach($v in $VARS){ $e=$null; foreach($x in $EAS){ if($x.n -eq $v.ea){ $e=$x } }; "
        "$RUNS += @{ n=$e.n; per=$v.per; var=$v.v; sym=$v.sym; inpv=@($e.inp) } }\n")
t = open(os.path.join(AQ, "righe", "_modello_controllo_14ea_oro.ps1.txt"), encoding="utf-8").read()
def R(a, b, n=1):
    global t
    assert t.count(a) == n, (t.count(a), a[:100])
    t = t.replace(a, b)
t = t.replace("MARCATORE_CONTROLLO_14EA_ORO_BCM_v1", "MARCATORE_BB_V4_FILTRI_BCM_v1")
t = re.sub(r"^# TEST FUORI CAMPIONE dei 4 EA.*$", "# BreakingBand_MT5_v4 (default) su 28 cross x H1 e M30, 2013-01-01 -> 2024-12-31, Modello 1, BCM portabile, SOLO tester: elenco operazioni per testare i filtri di Leonardo (mattina, notizie). Criteri: report/BB_V4_FILTRI_LEONARDO_CRITERI_2026-11-19.md", t, count=1, flags=re.M)
R("@@PIN@@", pin); R("@@EAS@@", eas_ps)
R("$FIN=@( @{ n='W2015_2023'; da='2015.01.01'; a='2023.12.31' }, @{ n='W2005_2014'; da='2005.01.01'; a='2014.12.31' } )\n",
  "$FIN=@( @{ n='W2013_2024'; da='2013.01.01'; a='2024.12.31' } )\n" + VARS + RUNS)
R("$EAS.Count * $FIN.Count", "$RUNS.Count * $FIN.Count", t.count("$EAS.Count * $FIN.Count"))
R(" foreach($ea in $EAS){\n  if($stopTutto){ break }", " foreach($ea in $RUNS){\n  if($stopTutto){ break }")
R("$rep='T14_' + $ea.n.Replace('ABTG_','').Replace('_Ottimizzato','') + '_' + $f.n", "$rep='BV_' + $ea.var + '_' + $f.n")
R("$r += $ea.inp", "$r += $ea.inpv")
R("'Symbol=XAUUSD'", "('Symbol=' + $ea.sym)")
R("$righe.Add($ea.n + ';' + $f.n + ';ERRORE", "$righe.Add($ea.var + ';' + $f.n + ';ERRORE")
R("$riga=($ea.n + ';' + $f.n + ';' + $nT", "$riga=($ea.var + ';' + $f.n + ';' + $nT")
R("'ea;finestra;operazioni;", "'variante;finestra;operazioni;")
R("TEST 4 EA ORO su BCM portabile", "TEST FILTRI LEONARDO su BreakingBand v4 (BCM portabile)")
R("Durata attesa 15-60 minuti (STIMA)", "Durata attesa 1-3 ore (STIMA, 56 passate)")
t = t.replace("CONTROLLO_14EA_ORO", "BB_V4_FILTRI").replace("controllo_14ea_oro", "bb_v4_filtri")
open(os.path.join(AQ, "righe", "BB_V4_FILTRI_BCM.ps1"), "w", encoding="utf-8", newline="").write(t)
print("scritto", len(t), "pin", pin, "input", len(inp), file=sys.stderr)
