#!/usr/bin/env python3
"""Riga unica: Gold Reaper D9, Goldbot One PF525 e The Gold Phantom D4 sul 2025 a TICK REALI (Modello 4, 80.000 EUR, XAUUSD): stesso anno e stessi input dei test a candele (Modello 1), per misurare la differenza. Uso: python3 gen_riga_tick_2025_80k.py <PIN40> (commit che contiene righe/ANNO80K_TESTER.ps1)"""
import sys, re, os, subprocess
PIN = sys.argv[1]; os.chdir(os.path.dirname(os.path.abspath(__file__)))
subprocess.check_call([sys.executable, 'gen_riga_tre_anni_80k.py', PIN])
t = open('righe/RIGA_LANCIA_TRE_ANNI_80K_3EA.txt', encoding='ascii').read()
def sost(a, b, tutte=False):
    global t
    assert t.count(a) >= 1, a[:70]
    t = t.replace(a, b) if tutte else t.replace(a, b, 1)
COMR = 'FakeOutFilter=2:i;UseHL_TrailingSL=true:b;Risk=1234:i;StartLots=0.01:d;MaxRiskPerStrategy_=1.0:d;ManualBalance=0.0:d;UseWeightedLots=true:b;'
REAPER = 'TradeFrequency=2:i;' + COMR + 'MaxAllowedDD=9.0:d;PropFirmMaxDailyDD=4.0:d;OnlyUp=false:b;Virtual_expiration=true:b;Randomization=0.0:d'
COMG = ('Risk=3:i;StartLots=0.01:d;LotPerBalance_step=1000:i;ManualBalance=0.0:d;UseEquity=false:b;CheckMargin=true:b;AdjustLotsizeToVariableValues=true:b;ResetHighestBalance=false:b;OnlyUp=false:b;'
        'Randomization=0.0:d;FakeOutFilter=1:i;FridayStopHour=25:i;Virtual_expiration=true:b;EnableVirtualSLTP=false:b;MaxSpread=500.0:d;AllowBuyTrades=true:b;AllowSellTrades=true:b;'
        'RunStrategyA=true:b;RunStrategyB=true:b;RunStrategyC=true:b;RunStrategyD=true:b;RunStrategyE=true:b;RunStrategyF=true:b;RunStrategyG=true:b;RunStrategyH=true:b;')
GOLDBOT = COMG + 'MaxRiskPerStrategy=1.0:d;PropFirmMaxDailyDD=2.0:d'
PHANTOM = 'TradeFrequency=5:i;MaxAllowedDD=4.0:d;OnlyUp=false:b;PropFirmMaxDailyDD=4.0:d;Randomization=0.0:d'
runs = [('The Gold Reaper MT5.ex5', '2025', '4', 'H1', 'XAUUSD', REAPER, '', '2025_M4_GR_D9'),
        ('Goldbot One MT5.ex5', '2025', '4', 'D1', 'XAUUSD', GOLDBOT, '', '2025_M4_GB_PF525'),
        ('The Gold Phantom.ex5', '2025', '4', 'H1', 'XAUUSD', PHANTOM, '', '2025_M4_PH_D4')]
q = lambda L: ','.join("'" + x + "'" for x in L)
i = t.index("Write-Host 'TRE ANNI DELLO STORICO"); j = t.index("' -ForegroundColor Cyan;", i)
testa = ("TICK REALI 2025 (80.000 EUR, DEMO, SOLO TESTER): The Gold Reaper (set prop D9, TradeFrequency 2, limite giornaliero 4), Goldbot One (PropFirm 5-2,5) e The Gold Phantom (prop combo D4), UNA corsa ciascuna sul 2025 (01/01/2025 - 01/01/2026), XAUUSD, Modello 4 (TICK REALI: i tick reali del tester BCM partono dal 10/07/2024, quindi il 2024 intero non e possibile), DEPOSITO 80000 EUR, STESSI input e STESSO anno dei test a candele da 1 minuto (Modello 1: Reaper +30.457, Goldbot +8.999, Phantom D4 +5.560) per misurare quanto cambiano i risultati con i tick reali. Criteri e previsioni scritti PRIMA dei numeri: report/TICK_2025_TRE_EA_CRITERI_2026-10-31.md. TEMPO: dalle corse a 3.745 (21 mesi a tick reali: Reaper 3,3 ore, Goldbot 2,5, Phantom 1,4) circa 12 mesi = 2 ore, 1,5 ore, 0,8 ore: **circa 4-5 ore in tutto**; timeout 420 minuti per EA. Non giudica acquisti ne taglie. NON e collaudata da agenti: ha passato SOLO il cancello meccanico controlla_riga.py. MT5 deve essere CHIUSO")
t = t[:i] + "Write-Host '" + testa + t[j:]
a = t.index('$fare=@('); b = t.index('$IMP=@{')
t = t[:a] + "$fare=@(" + q([r[0] for r in runs]) + "); $ANNI=@(" + q([r[1] for r in runs]) + "); $MOD=@(" + q([r[2] for r in runs]) + "); $PER=@(" + q([r[3] for r in runs]) + "); $SIMR=@(" + q([r[4] for r in runs]) + "); $IMPR=@(" + q([r[5] for r in runs]) + "); $FINR=@(" + q([r[6] for r in runs]) + "); $ETI=@(" + q([r[7] for r in runs]) + "); $vi=0; " + t[b:]
t, n = re.subn(r"if\(\$okl\.Count -lt \d+\)\{ throw '[^']*' \}", "if(@($okl | Select-Object -Unique).Count -lt 3){ throw ('Mancano nel Market di questo terminale: ' + ((@($fare | Select-Object -Unique) | Where-Object { $okl -notcontains $_ }) -join ', ') + '. Servono tutti e tre: nessun tester e partito.') }", t, count=1); assert n == 1
sost("$TO=240;", "$TO=420;")
sost("$im=''; if($IMP.ContainsKey($n)){ $im=$IMP[$n] };", "$im=$IMPR[$vi]; $sy=$SIMR[$vi]; $ex=@(); if($FINR[$vi] -ne ''){ $ex=@('-Fine',$FINR[$vi]) };")
sost("$bs=Join-Path $OUT ($an + '_M' + $mo);", "$bs=Join-Path $OUT $ETI[$vi];")
sost("EUR, ' + $pdg + ', Modello ' + $mo)", "EUR, ' + $sy + ' ' + $pdg + ', Modello ' + $mo)")
sost("-Anno $an -Modello $mo -Periodo $pdg -Base $bs", "-Anno $an -Modello $mo -Periodo $pdg -Simbolo $sy -Base $bs @ex", True)
sost("ABTG_RISULTATI\\ANNO80K_TRE_EA_'", "ABTG_RISULTATI\\ANNO80K_TICK_2025_'")
sost("('ANNO80K_TRE_EA_' + (Get-Date)", "('ANNO80K_TICK_2025_' + (Get-Date)")
t = t.replace('gli EA indicati devono essere gia installati', 'The Gold Reaper, Goldbot One e The Gold Phantom devono essere gia installati (Market)')
open('righe/RIGA_LANCIA_TICK_2025_80K.txt', 'w', encoding='ascii').write(t)
print('scritta', len(t), 'passate', len(runs))
