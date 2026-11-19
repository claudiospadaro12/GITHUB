#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Genera righe/GOLDENZOE_NEWS_BCM.ps1 dal modello 14ea. Criteri: report/GOLDENZOE_FILTRO_NEWS_CRITERI_2026-11-19.md"""
import os, sys, re, subprocess
AQ = os.path.dirname(os.path.abspath(__file__))
src = open(os.path.join(AQ, "gen_controllo_14ea_oro.py"), encoding="utf-8").read().split("pin = subprocess")[0]
exec(src)
pin = subprocess.check_output(["git", "-C", REPO, "rev-parse", "HEAD"]).decode().strip()
EA = "GoldenZoe_H4"
inp, sha = leggi(EA)
righe = ",\n".join("      '%s=%s'" % (a, b.replace("'", "''")) for a, b in inp)
eas_ps = "  @{ n='%s'; per='H4'; sha='%s'; inp=@(\n%s\n  ) }" % (EA, sha, righe)
MAIN = "Libri Paga Non Agricoli|Decisione del Tasso di Interesse della Fed|Conferenza Stampa del FOMC|IPC a/a"
V = [("OFF", ["InpNewsFilter=false"]), ("ALL_120", ["InpNewsFilter=true"]), ("MAIN_120", ["InpNewsFilter=true", "InpNewsTitleMatch=" + MAIN])]
VARS = "$VARS=@( " + ", ".join("@{ v='%s'; ea='%s'; ov=@(%s) }" % (n, EA, ",".join("'%s'" % o for o in ov)) for n, ov in V) + " )\n"
RUNS = ("$RUNS=@(); foreach($v in $VARS){ $e=$null; foreach($x in $EAS){ if($x.n -eq $v.ea){ $e=$x } }; "
        "$ovr=@{}; foreach($o in $v.ov){ $ovr[$o.Split('=')[0]]=$o }; "
        "$iv=@($e.inp | Where-Object { -not $ovr.ContainsKey($_.Split('=')[0]) }) + @($v.ov); "
        "$RUNS += @{ n=$e.n; per=$e.per; var=$v.v; inpv=$iv } }\n")
t = open(os.path.join(AQ, "righe", "_modello_controllo_14ea_oro.ps1.txt"), encoding="utf-8").read()
def R(a, b, n=1):
    global t
    assert t.count(a) == n, (t.count(a), a[:100])
    t = t.replace(a, b)
t = t.replace("MARCATORE_CONTROLLO_14EA_ORO_BCM_v1", "MARCATORE_GOLDENZOE_NEWS_BCM_v1")
t = re.sub(r"^# TEST FUORI CAMPIONE dei 4 EA.*$", "# GoldenZoe_H4 v1.10 filtro news: OFF, ALL_120, MAIN_120 su XAUUSD H4 LONG, finestre 2015-2023 e 2024-2026, Modello 1, BCM portabile, SOLO tester. Richiede Common\\\\Files\\\\abtg_news_hist.csv (export gia fatto). Criteri: report/GOLDENZOE_FILTRO_NEWS_CRITERI_2026-11-19.md", t, count=1, flags=re.M)
R("@@PIN@@", pin); R("@@EAS@@", eas_ps)
R("$FIN=@( @{ n='W2015_2023'; da='2015.01.01'; a='2023.12.31' }, @{ n='W2005_2014'; da='2005.01.01'; a='2014.12.31' } )\n",
  "$FIN=@( @{ n='W2015_2023'; da='2015.01.01'; a='2023.12.31' }, @{ n='W2024_2026'; da='2024.01.01'; a='2026.10.31' } )\n" + VARS + RUNS)
R("$EAS.Count * $FIN.Count", "$RUNS.Count * $FIN.Count", t.count("$EAS.Count * $FIN.Count"))
R(" foreach($ea in $EAS){\n  if($stopTutto){ break }", " foreach($ea in $RUNS){\n  if($stopTutto){ break }")
R("$rep='T14_' + $ea.n.Replace('ABTG_','').Replace('_Ottimizzato','') + '_' + $f.n", "$rep='GN_' + $ea.var + '_' + $f.n")
R("$r += $ea.inp", "$r += $ea.inpv")
R("$righe.Add($ea.n + ';' + $f.n + ';ERRORE", "$righe.Add($ea.var + ';' + $f.n + ';ERRORE")
R("$riga=($ea.n + ';' + $f.n + ';' + $nT", "$riga=($ea.var + ';' + $f.n + ';' + $nT")
R("'ea;finestra;operazioni;", "'variante;finestra;operazioni;")
R("TEST 4 EA ORO su BCM portabile", "TEST GOLDENZOE FILTRO NEWS su BCM portabile")
R("Durata attesa 15-60 minuti (STIMA)", "Durata attesa 15-40 minuti (STIMA, 6 passate)")
# prima di partire: il file notizie deve esistere in Common\Files
R("# 2) test\n", "# 2) test\n$nf=Join-Path $env:APPDATA 'MetaQuotes\\Terminal\\Common\\Files\\abtg_news_hist.csv'; if(-not (Test-Path -LiteralPath $nf)){ Write-Host ('MI FERMO: non trovo ' + $nf + ' (rilancia prima la riga di esportazione notizie).') -ForegroundColor Red; return }\n")
t = t.replace("CONTROLLO_14EA_ORO", "GOLDENZOE_NEWS").replace("controllo_14ea_oro", "goldenzoe_news")
open(os.path.join(AQ, "righe", "GOLDENZOE_NEWS_BCM.ps1"), "w", encoding="utf-8", newline="").write(t)
print("scritto", len(t), "pin", pin, "input", len(inp), file=sys.stderr)
