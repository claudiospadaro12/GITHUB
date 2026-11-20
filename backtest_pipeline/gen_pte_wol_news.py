#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Genera righe/PTE_WOL_NEWS_BCM.ps1: PTE H4 e WOL D1 su 28 cross, 2013-2024. Criteri: report/PTE_WOL_NEWS_CRITERI_2026-11-20.md"""
import os, sys, re, subprocess
AQ = os.path.dirname(os.path.abspath(__file__))
src = open(os.path.join(AQ, "gen_controllo_14ea_oro.py"), encoding="utf-8").read().split("pin = subprocess")[0]
exec(src)
pin = subprocess.check_output(["git", "-C", REPO, "rev-parse", "HEAD"]).decode().strip()
EAL = ["ABTG_PTE", "ABTG_WOL"]
PER = {"ABTG_PTE": "H4", "ABTG_WOL": "D1"}
parts = []
for EA in EAL:
    inp, sha = leggi(EA)
    righe = ",\n".join("      '%s=%s'" % (a_, b_.replace("'", "''")) for a_, b_ in inp)
    parts.append("  @{ n='%s'; per='%s'; sha='%s'; inp=@(\n%s\n  ) }" % (EA, PER[EA], sha, righe))
eas_ps = ",\n".join(parts)
SIM = "AUDCAD AUDCHF AUDJPY AUDNZD AUDUSD CADCHF CADJPY CHFJPY EURAUD EURCAD EURCHF EURGBP EURJPY EURNZD EURUSD GBPAUD GBPCAD GBPCHF GBPJPY GBPNZD GBPUSD NZDCAD NZDCHF NZDJPY NZDUSD USDCAD USDCHF USDJPY".split()
assert len(SIM) == 28
NEWS = ['InpUseNewsFilter=true', 'InpNewsFile=abtg_news_hist_G8.csv', 'InpNewsCommon=true', 'InpNewsPairOnly=true', 'InpNewsMinImpact=3', 'InpNewsShiftMinutes=0']
VAR = [("PTE_V1","ABTG_PTE",NEWS+["InpNewsBeforeMin=120","InpNewsAfterMin=30"]),("WOL_W1","ABTG_WOL",NEWS+["InpNewsBeforeMin=1440","InpNewsAfterMin=30"])]
VARS = "$VARS=@( " + ", ".join("@{ v='%s_%s'; sym='%s'; per='%s'; ea='%s'; ov=@(%s) }" % (s_, nm, s_, PER[e_], e_, ",".join("'%s'" % o for o in ["InpVerbose=false"]+ov)) for s_ in SIM for (nm,e_,ov) in VAR) + " )\n"
RUNS = ("$RUNS=@(); foreach($v in $VARS){ $e=$null; foreach($x in $EAS){ if($x.n -eq $v.ea){ $e=$x } }; "
        "$ovn=@($v.ov | ForEach-Object { ($_ -split '=')[0] }); $iv=@($e.inp | Where-Object { $ovn -notcontains (($_ -split '=')[0]) }) + @($v.ov); "
        "$RUNS += @{ n=$e.n; per=$v.per; var=$v.v; sym=$v.sym; inpv=$iv } }\n")
t = open(os.path.join(AQ, "righe", "_modello_controllo_14ea_oro.ps1.txt"), encoding="utf-8").read()
def R(a, b, n=1):
    global t
    assert t.count(a) == n, (t.count(a), a[:100])
    t = t.replace(a, b)
t = t.replace("MARCATORE_CONTROLLO_14EA_ORO_BCM_v1", "MARCATORE_PTE_WOL_NEWS_BCM_v1")
t = re.sub(r"^# TEST FUORI CAMPIONE dei 4 EA.*$", "# ABTG_PTE (H4) e ABTG_WOL (D1), filtro notizie V1/W1, su 28 cross forex, 2013-01-01 -> 2024-12-31, Modello 1, BCM portabile, SOLO tester: 56 passate. Criteri: report/PTE_WOL_NEWS_CRITERI_2026-11-20.md", t, count=1, flags=re.M)
R("@@PIN@@", pin); R("@@EAS@@", eas_ps)
R("$FIN=@( @{ n='W2015_2023'; da='2015.01.01'; a='2023.12.31' }, @{ n='W2005_2014'; da='2005.01.01'; a='2014.12.31' } )\n",
  "$FIN=@( @{ n='W2013_2024'; da='2013.01.01'; a='2024.12.31' } )\n" + VARS + RUNS)
R("$EAS.Count * $FIN.Count", "$RUNS.Count * $FIN.Count", t.count("$EAS.Count * $FIN.Count"))
R(" foreach($ea in $EAS){\n  if($stopTutto){ break }", " foreach($ea in $RUNS){\n  if($stopTutto){ break }")
R("$rep='T14_' + $ea.n.Replace('ABTG_','').Replace('_Ottimizzato','') + '_' + $f.n", "$rep='PW_' + $ea.var + '_' + $f.n")
R("$r += $ea.inp", "$r += $ea.inpv")
R("'Symbol=XAUUSD'", "('Symbol=' + $ea.sym)")
R("$righe.Add($ea.n + ';' + $f.n + ';ERRORE", "$righe.Add($ea.var + ';' + $f.n + ';ERRORE")
R("$riga=($ea.n + ';' + $f.n + ';' + $nT", "$riga=($ea.var + ';' + $f.n + ';' + $nT")
R("'ea;finestra;operazioni;", "'variante;finestra;operazioni;")
R("TEST 4 EA ORO su BCM portabile", "TEST PTE e WOL FILTRO NOTIZIE (BCM portabile)")
R("Durata attesa 15-60 minuti (STIMA)", "Durata attesa 1-2 ore (STIMA, 56 passate H4/D1)")
R("# 2) test\n", "# 2) test\n$nf=Join-Path $env:APPDATA 'MetaQuotes\\Terminal\\Common\\Files\\abtg_news_hist_G8.csv'; if(-not (Test-Path -LiteralPath $nf)){ Write-Host ('MI FERMO: non trovo ' + $nf + ' (rilancia prima la riga NEWS_EXPORT_G8).') -ForegroundColor Red; return }; Write-Host ('Calendario trovato: ' + $nf + ' (' + [math]::Round((Get-Item -LiteralPath $nf).Length/1KB) + ' KB)') -ForegroundColor Green\n")
t = t.replace("CONTROLLO_14EA_ORO", "PTE_WOL_NEWS").replace("controllo_14ea_oro", "pte_wol_news")
open(os.path.join(AQ, "righe", "PTE_WOL_NEWS_BCM.ps1"), "w", encoding="utf-8", newline="").write(t)
print("scritto", len(t), "pin", pin, "input", len(inp), file=sys.stderr)
