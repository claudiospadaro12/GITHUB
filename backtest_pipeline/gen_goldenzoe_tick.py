#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Genera righe/GOLDENZOE_TICK_BCM.ps1: GoldenZoe_H4 con Modello 1 contro tick reali (Modello 4) sulla stessa finestra. Criteri: report/GOLDENZOE_EA_CRITERI_2026-11-19.md"""
import os, sys, re, subprocess
AQ = os.path.dirname(os.path.abspath(__file__))
src = open(os.path.join(AQ, "gen_controllo_14ea_oro.py"), encoding="utf-8").read().split("pin = subprocess")[0]
exec(src)
pin = subprocess.check_output(["git", "-C", REPO, "rev-parse", "HEAD"]).decode().strip()
EA = "GoldenZoe_H4"
inp, sha = leggi(EA)
righe = ",\n".join("      '%s=%s'" % (a, b.replace("'", "''")) for a, b in inp)
eas_ps = "  @{ n='%s'; per='H4'; sha='%s'; inp=@(\n%s\n  ) }" % (EA, sha, righe)
VARS = ("$VARS=@( @{ v='LONG_M1'; ea='%s'; mod=1; ov=@('InpAllowLong=true','InpAllowShort=false') }, "
        "@{ v='LONG_M4'; ea='%s'; mod=4; ov=@('InpAllowLong=true','InpAllowShort=false') }, "
        "@{ v='LONGSHORT_M4'; ea='%s'; mod=4; ov=@('InpAllowLong=true','InpAllowShort=true') } )\n" % (EA, EA, EA))
RUNS = ("$RUNS=@(); foreach($v in $VARS){ $e=$null; foreach($x in $EAS){ if($x.n -eq $v.ea){ $e=$x } }; "
        "$ovr=@{}; foreach($o in $v.ov){ $ovr[$o.Split('=')[0]]=$o }; "
        "$iv=@($e.inp | Where-Object { -not $ovr.ContainsKey($_.Split('=')[0]) }) + @($v.ov); "
        "$RUNS += @{ n=$e.n; per=$e.per; var=$v.v; mod=$v.mod; inpv=$iv } }\n")
t = open(os.path.join(AQ, "righe", "_modello_controllo_14ea_oro.ps1.txt"), encoding="utf-8").read()
def R(a, b, n=1):
    global t
    assert t.count(a) == n, (t.count(a), a[:100])
    t = t.replace(a, b)
t = t.replace("MARCATORE_CONTROLLO_14EA_ORO_BCM_v1", "MARCATORE_GOLDENZOE_TICK_BCM_v1")
t = re.sub(r"^# TEST FUORI CAMPIONE dei 4 EA.*$", "# GoldenZoe_H4: LONG con Modello 1 contro LONG e LONGSHORT con TICK REALI (Modello 4) sulla stessa finestra (dal 2024-08 ai tick disponibili), XAUUSD H4, BCM portabile, SOLO tester. Criteri: report/GOLDENZOE_EA_CRITERI_2026-11-19.md", t, count=1, flags=re.M)
R("@@PIN@@", pin); R("@@EAS@@", eas_ps)
R("$FIN=@( @{ n='W2015_2023'; da='2015.01.01'; a='2023.12.31' }, @{ n='W2005_2014'; da='2005.01.01'; a='2014.12.31' } )\n",
  "$FIN=@( @{ n='WTICK'; da=$daT; a=$aT } )\n" + VARS + RUNS)
R("$EAS=@(\n", open(os.path.join(AQ, "blocchi_ps", "cop_block_ticks_xauusd.txt"), encoding="utf-8").read() + "$EAS=@(\n")
R("$EAS.Count * $FIN.Count", "$RUNS.Count * $FIN.Count", t.count("$EAS.Count * $FIN.Count"))
R(" foreach($ea in $EAS){\n  if($stopTutto){ break }", " foreach($ea in $RUNS){\n  if($stopTutto){ break }")
R("$rep='T14_' + $ea.n.Replace('ABTG_','').Replace('_Ottimizzato','') + '_' + $f.n", "$rep='GZT_' + $ea.var + '_' + $f.n")
R("$r += $ea.inp", "$r += $ea.inpv")
R("$righe.Add($ea.n + ';' + $f.n + ';ERRORE", "$righe.Add($ea.var + ';' + $f.n + ';ERRORE")
R("$riga=($ea.n + ';' + $f.n + ';' + $nT", "$riga=($ea.var + ';' + $f.n + ';' + $nT")
R("'ea;finestra;operazioni;", "'variante;finestra;operazioni;")
R("'Model=1'", "('Model=' + $ea.mod)"); R("AddMinutes(60)", "AddMinutes($(if($ea.mod -eq 4){ 300 } else { 60 }))")
R("TEST 4 EA ORO su BCM portabile", "TEST GOLDENZOE TICK su BCM portabile"); R("' passate, Modello 1. Avvio", "' passate (LONG a barre da 1 minuto; LONG e LONGSHORT a tick reali). Avvio")
R("Durata attesa 15-60 minuti (STIMA)", "Durata attesa 1-5 ore (STIMA: le passate a tick sono le piu' lunghe)")
t = t.replace("CONTROLLO_14EA_ORO", "GOLDENZOE_TICK").replace("controllo_14ea_oro", "goldenzoe_tick")
open(os.path.join(AQ, "righe", "GOLDENZOE_TICK_BCM.ps1"), "w", encoding="utf-8", newline="").write(t)
print("scritto", len(t), "pin", pin, file=sys.stderr)
