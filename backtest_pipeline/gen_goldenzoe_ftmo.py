#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Genera righe/GOLDENZOE_FTMO_ORO.ps1 (modello 14ea adattato al terminale FTMO non portable). Criteri: report/GOLDENZOE_FTMO_ORO_CRITERI_2026-11-19.md"""
import os, sys, re, subprocess
AQ = os.path.dirname(os.path.abspath(__file__))
src = open(os.path.join(AQ, "gen_controllo_14ea_oro.py"), encoding="utf-8").read().split("pin = subprocess")[0]
exec(src)
pin = subprocess.check_output(["git", "-C", REPO, "rev-parse", "HEAD"]).decode().strip()
EA = "GoldenZoe_H4"
inp, sha = leggi(EA)
righe = ",\n".join("      '%s=%s'" % (a, b.replace("'", "''")) for a, b in inp)
eas_ps = "  @{ n='%s'; per='H4'; sha='%s'; inp=@(\n%s\n  ) }" % (EA, sha, righe)
t = open(os.path.join(AQ, "righe", "_modello_controllo_14ea_oro.ps1.txt"), encoding="utf-8").read()
def R(a, b, n=1):
    global t
    assert t.count(a) == n, (t.count(a), a[:100])
    t = t.replace(a, b)
t = t.replace("MARCATORE_CONTROLLO_14EA_ORO_BCM_v1", "MARCATORE_GOLDENZOE_FTMO_ORO_v1")
t = re.sub(r"^# TEST FUORI CAMPIONE dei 4 EA.*$", "# GoldenZoe_H4 su XAUUSD sul terminale FTMO di PROVA (Mt5_Ftmo_Prova, non portable, storico gia scaricato): solo LONG, 3 finestre, 160.000 EUR, Modello 1, SOLO tester. Criteri: report/GOLDENZOE_FTMO_ORO_CRITERI_2026-11-19.md", t, count=1, flags=re.M)
R("@@PIN@@", pin); R("@@EAS@@", eas_ps)
# terminale FTMO non portable: cartella dati da origin.txt
L6 = "$ROOT='C:\\MT5_BCM_Opt'; $TRM=Join-Path $ROOT 'terminal64.exe'; $MEE=Join-Path $ROOT 'metaeditor64.exe'; $MQL5=Join-Path $ROOT 'MQL5'"
NEW6 = ("$FT='C:\\MT5_Backtest\\Mt5_Ftmo_Prova'; $TRM=Join-Path $FT 'terminal64.exe'; $MEE=Join-Path $FT 'metaeditor64.exe'\n"
        "$DATI=$null; $baseT=Join-Path $env:APPDATA 'MetaQuotes\\Terminal'\n"
        "foreach($o in @(Get-ChildItem -LiteralPath $baseT -Directory -ErrorAction SilentlyContinue)){ $of=Join-Path $o.FullName 'origin.txt'; if(Test-Path -LiteralPath $of){ $c0=((Get-Content -LiteralPath $of -Raw -Encoding Unicode) -replace '[\\r\\n\\0]','').Trim(); if($c0 -eq $FT){ $DATI=$o.FullName } } }\n"
        "if(-not $DATI){ Write-Host 'MI FERMO: non trovo la cartella dati di Mt5_Ftmo_Prova.' -ForegroundColor Red; return }\n"
        "$ROOT=$DATI; $MQL5=Join-Path $DATI 'MQL5'")
R(L6, NEW6)
R("'/portable /compile:\"'", "'/compile:\"'")
R("'/portable /config:\"'", "'/config:\"'")
R("Deposit=100000", "Deposit=160000")
R("Symbol=XAUUSD", "Symbol=XAUUSD")
R("$FIN=@( @{ n='W2015_2023'; da='2015.01.01'; a='2023.12.31' }, @{ n='W2005_2014'; da='2005.01.01'; a='2014.12.31' } )\n",
  "$FIN=@( @{ n='W2005_2014'; da='2005.01.01'; a='2014.12.31' }, @{ n='W2015_2023'; da='2015.01.01'; a='2023.12.31' }, @{ n='W2024_2026'; da='2024.01.01'; a='2026.10.31' } )\n")
R("$rep='T14_' + $ea.n.Replace('ABTG_','').Replace('_Ottimizzato','') + '_' + $f.n", "$rep='GF_LONG_' + $f.n")
R("TEST 4 EA ORO su BCM portabile", "TEST GOLDENZOE ORO su terminale FTMO di prova (160.000 EUR)")
R("Durata attesa 15-60 minuti (STIMA)", "Durata attesa 10-30 minuti (STIMA, 3 passate)")
t = t.replace("CONTROLLO_14EA_ORO", "GOLDENZOE_FTMO").replace("controllo_14ea_oro", "goldenzoe_ftmo")
open(os.path.join(AQ, "righe", "GOLDENZOE_FTMO_ORO.ps1"), "w", encoding="utf-8", newline="").write(t)
print("scritto", len(t), "pin", pin, file=sys.stderr)
