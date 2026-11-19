#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Genera righe/STADIO1_ATR_BCM.ps1 dal modello righe/_modello_controllo_14ea_oro.ps1.txt (struttura collaudata).
Criteri: report/STADIO1_ATR_CRITERI_2026-11-19.md. Legge i DEFAULT degli input dai sorgenti nel repository."""
import os, sys, re, subprocess
AQ = os.path.dirname(os.path.abspath(__file__))
src = open(os.path.join(AQ, "gen_controllo_14ea_oro.py"), encoding="utf-8").read().split("pin = subprocess")[0]
exec(src)
pin = subprocess.check_output(["git", "-C", REPO, "rev-parse", "HEAD"]).decode().strip()
A = "ABTG_SupertrendReversal_Ottimizzato"; M = "ABTG_SupertrendReversal_Multi_Ottimizzato"
blocchi = []
for nome in (A, M):
    inp, sha = leggi(nome)
    righe = ",\n".join("      '%s=%s'" % (a, b.replace("'", "''")) for a, b in inp)
    blocchi.append("  @{ n='%s'; per='H4'; sha='%s'; inp=@(\n%s\n  ) }" % (nome, sha, righe))
eas_ps = ",\n".join(blocchi)
VARS = ("$VARS=@( @{ v='PIPS'; ea='%s'; ov=@() }, "
        "@{ v='ATR_EQ'; ea='%s'; ov=@('InpStAtrPeriod=7','InpTP_RR=2.5','InpPendingAtr=0.013','InpSLBufferAtr=0.002') }, "
        "@{ v='ATR_DEF'; ea='%s'; ov=@('InpStAtrPeriod=7','InpTP_RR=2.5') }, "
        "@{ v='MULTI_DEF'; ea='%s'; ov=@() } )\n" % (A, M, M, M))
RUNS = ("$RUNS=@(); foreach($v in $VARS){ $e=$null; foreach($x in $EAS){ if($x.n -eq $v.ea){ $e=$x } }; "
        "$ovr=@{}; foreach($o in $v.ov){ $ovr[$o.Split('=')[0]]=$o }; "
        "$iv=@($e.inp | Where-Object { -not $ovr.ContainsKey($_.Split('=')[0]) }) + @($v.ov); "
        "$RUNS += @{ n=$e.n; per=$e.per; var=$v.v; inpv=$iv } }\n")
t = open(os.path.join(AQ, "righe", "_modello_controllo_14ea_oro.ps1.txt"), encoding="utf-8").read()
def R(a, b, n=1):
    global t
    assert t.count(a) == n, (t.count(a), a[:100])
    t = t.replace(a, b)
t = t.replace("MARCATORE_CONTROLLO_14EA_ORO_BCM_v1", "MARCATORE_STADIO1_ATR_BCM_v1")
t = re.sub(r"^# TEST FUORI CAMPIONE dei 4 EA.*$", "# STADIO 1 (versione onesta): effetto isolato di pip fissi contro distanze in ATR sull'oro. SupertrendReversal_Ottimizzato (pip) contro il gemello _Multi (ATR) in 4 varianti (PIPS, ATR_EQ, ATR_DEF, MULTI_DEF), XAUUSD H4, Modello 1, finestre 2015-2023 e 2005-2014. SOLO tester BCM portabile. Criteri: report/STADIO1_ATR_CRITERI_2026-11-19.md", t, count=1, flags=re.M)
R("@@PIN@@", pin); R("@@EAS@@", eas_ps)
R("$FIN=@( @{ n='W2015_2023'; da='2015.01.01'; a='2023.12.31' }, @{ n='W2005_2014'; da='2005.01.01'; a='2014.12.31' } )\n",
  "$FIN=@( @{ n='W2015_2023'; da='2015.01.01'; a='2023.12.31' }, @{ n='W2005_2014'; da='2005.01.01'; a='2014.12.31' } )\n" + VARS + RUNS)
R("$EAS.Count * $FIN.Count", "$RUNS.Count * $FIN.Count", t.count("$EAS.Count * $FIN.Count"))
R(" foreach($ea in $EAS){\n  if($stopTutto){ break }", " foreach($ea in $RUNS){\n  if($stopTutto){ break }")
R("$rep='T14_' + $ea.n.Replace('ABTG_','').Replace('_Ottimizzato','') + '_' + $f.n", "$rep='S1_' + $ea.var + '_' + $f.n")
R("$r += $ea.inp", "$r += $ea.inpv")
R("$righe.Add($ea.n + ';' + $f.n + ';ERRORE", "$righe.Add($ea.var + ';' + $f.n + ';ERRORE")
R("$riga=($ea.n + ';' + $f.n + ';' + $nT", "$riga=($ea.var + ';' + $f.n + ';' + $nT")
R("'ea;finestra;operazioni;", "'variante;finestra;operazioni;")
R("TEST 4 EA ORO su BCM portabile", "STADIO 1 ATR su BCM portabile"); R("Durata attesa 15-60 minuti (STIMA)", "Durata attesa 1-2 ore (STIMA, 8 passate)")
t = t.replace("CONTROLLO_14EA_ORO", "STADIO1_ATR").replace("controllo_14ea_oro", "stadio1_atr")
open(os.path.join(AQ, "righe", "STADIO1_ATR_BCM.ps1"), "w", encoding="utf-8", newline="").write(t)
print("scritto", len(t), "pin", pin, file=sys.stderr)
