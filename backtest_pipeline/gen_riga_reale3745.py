#!/usr/bin/env python3
"""Riga unica: Gold Trade Pro (PROP e COMBO), Goldbot One PF525, Gold Reaper 9 e The Gold Phantom D4 sul conto reale personale: deposito 3.745 EUR, leva 1:500, corsa continua 01/01/2025-01/10/2026 a tick reali. Script ANNO3745L500. Uso: python3 gen_riga_reale3745.py <PIN40> (commit che contiene righe/ANNO3745L500_TESTER.ps1)"""
import sys, re, os, subprocess, hashlib
PIN = sys.argv[1]; os.chdir(os.path.dirname(os.path.abspath(__file__)))
subprocess.check_call([sys.executable, 'gen_riga_tre_anni_80k.py', PIN])
t = open('righe/RIGA_LANCIA_TRE_ANNI_80K_3EA.txt', encoding='ascii').read()
def sost(a, b, tutte=False):
    global t
    assert t.count(a) >= 1, a[:70]
    t = t.replace(a, b) if tutte else t.replace(a, b, 1)
SHA = hashlib.sha256(open('righe/ANNO3745L500_TESTER.ps1', 'rb').read()).hexdigest().upper()
m = re.search(r"\$SH='([0-9A-F]{64})'", t); assert m
sost("$SN='ANNO80K_TESTER.ps1'", "$SN='ANNO3745L500_TESTER.ps1'"); sost("$SH='" + m.group(1) + "'", "$SH='" + SHA + "'"); sost("MARCATORE_ANNO80K_TESTER_TRANCHE_v1", "MARCATORE_ANNO3745L500_TESTER_TRANCHE_v1")
COM = ('Risk=3:i;StartLots=0.01:d;LotPerBalance_step=1000:i;ManualBalance=0.0:d;UseEquity=false:b;CheckMargin=true:b;AdjustLotsizeToVariableValues=true:b;ResetHighestBalance=false:b;OnlyUp=false:b;'
       'Randomization=0.0:d;FakeOutFilter=1:i;FridayStopHour=25:i;Virtual_expiration=true:b;EnableVirtualSLTP=false:b;MaxSpread=500.0:d;AllowBuyTrades=true:b;AllowSellTrades=true:b;'
       'RunStrategyA=true:b;RunStrategyB=true:b;RunStrategyC=true:b;RunStrategyD=true:b;RunStrategyE=true:b;RunStrategyF=true:b;RunStrategyG=true:b;RunStrategyH=true:b;')
runs = [('Gold Trade Pro MT5.ex5', 'D1', 'Risk=3:i;MaxRiskPerStrategy=1.0:d;PropFirmMaxDailyDD=4.0:d', '21M_M4_GTP_PROP'),
        ('Gold Trade Pro MT5.ex5', 'D1', 'Risk=3:i;MaxRiskPerStrategy=0.5:d;PropFirmMaxDailyDD=4.0:d', '21M_M4_GTP_COMBO'),
        ('Goldbot One MT5.ex5', 'D1', COM + 'MaxRiskPerStrategy=1.0:d;PropFirmMaxDailyDD=2.0:d', '21M_M4_GOLDBOT_PF525'),
        ('The Gold Reaper MT5.ex5', 'H1', 'TradeFrequency=2:i;MaxAllowedDD=9.0:d;PropFirmMaxDailyDD=4.0:d;OnlyUp=false:b', '21M_M4_REAPER_D9'),
        ('The Gold Phantom.ex5', 'H1', 'TradeFrequency=5:i;MaxAllowedDD=4.0:d;OnlyUp=false:b;PropFirmMaxDailyDD=4.0:d;Randomization=0.0:d', '21M_M4_PHANTOM_D4')]
q = lambda L: ','.join("'" + x + "'" for x in L)
n = len(runs)
i = t.index("Write-Host 'TRE ANNI DELLO STORICO"); j = t.index("' -ForegroundColor Cyan;", i)
testa = ("CONTO REALE PERSONALE (DEMO, SOLO TESTER): Gold Trade Pro (set PROP e COMBO), Goldbot One (PropFirm 5-2,5), The Gold Reaper (MaxAllowedDD 9) e The Gold Phantom (prop combo, MaxAllowedDD 4), 5 corse CONTINUE 01/01/2025 - 01/10/2026, XAUUSD, tick reali (Modello 4), DEPOSITO 3745 EUR (il saldo reale di Claudio: 3.745,38; il bonus di 2.500 NON e simulato), LEVA 1:500 (quella del conto reale; il report deve confermarla), nessun guardiano. Serve a misurare cosa fa il lotto minimo 0,01 a un capitale piccolo: a 80.000 questi set aprono lotti molto piu piccoli di quanto il broker consenta qui. TEMPO: da pochi minuti a circa un ora per corsa (Reaper e Phantom H1 i piu lenti): 2-4 ore in tutto; timeout 420 minuti per corsa. Criteri e previsioni scritti PRIMA dei numeri: report/CONTO_REALE_3745_QUATTRO_EA_CRITERI_2026-10-30.md. Non giudica acquisti ne taglie. NON e collaudata da agenti: ha passato SOLO il cancello meccanico controlla_riga.py e il mio controllo. MT5 deve essere CHIUSO")
t = t[:i] + "Write-Host '" + testa + t[j:]
a = t.index('$fare=@('); b = t.index('$IMP=@{')
t = t[:a] + "$fare=@(" + q([r[0] for r in runs]) + "); $ANNI=@(" + q(['2025'] * n) + "); $MOD=@(" + q(['4'] * n) + "); $PER=@(" + q([r[1] for r in runs]) + "); $SIMR=@(" + q(['XAUUSD'] * n) + "); $IMPR=@(" + q([r[2] for r in runs]) + "); $FINR=@(" + q(['2026.10.01'] * n) + "); $ETI=@(" + q([r[3] for r in runs]) + "); $vi=0; " + t[b:]
t, nn = re.subn(r"if\(\$okl\.Count -lt \d+\)\{ throw '[^']*' \}", "if(@($okl | Select-Object -Unique).Count -lt 4){ throw ('Mancano nel Market di questo terminale: ' + ((@($fare | Select-Object -Unique) | Where-Object { $okl -notcontains $_ }) -join ', ') + '. Servono tutti e quattro: nessun tester e partito.') }", t, count=1); assert nn == 1
sost("$TO=240;", "$TO=420;")
sost("$im=''; if($IMP.ContainsKey($n)){ $im=$IMP[$n] };", "$im=$IMPR[$vi]; $sy=$SIMR[$vi]; $ex=@(); if($FINR[$vi] -ne ''){ $ex=@('-Fine',$FINR[$vi]) };")
sost("$bs=Join-Path $OUT ($an + '_M' + $mo);", "$bs=Join-Path $OUT $ETI[$vi];")
sost("EUR, ' + $pdg + ', Modello ' + $mo)", "EUR, ' + $sy + ' ' + $pdg + ', Modello ' + $mo)")
sost("-Anno $an -Modello $mo -Periodo $pdg -Base $bs", "-Anno $an -Modello $mo -Periodo $pdg -Simbolo $sy -Base $bs @ex", True)
sost("ABTG_RISULTATI\\ANNO80K_TRE_EA_'", "ABTG_RISULTATI\\ANNO3745L500_REALE_'")
sost("('ANNO80K_TRE_EA_' + (Get-Date)", "('ANNO3745L500_REALE_' + (Get-Date)")
t = t.replace('80000 EUR', '3745 EUR').replace('80.000 EUR', '3.745 EUR').replace('ANNO80K', 'ANNO3745L500')
t = t.replace('gli EA indicati devono essere gia installati', 'Gold Trade Pro, Goldbot One, Gold Reaper e The Gold Phantom devono essere gia installati (Market)')
assert '80000' not in t and 'ANNO80K' not in t
open('righe/RIGA_LANCIA_REALE3745.txt', 'w', encoding='ascii').write(t)
print('scritta', len(t), 'passate', n, 'sha script', SHA[:8])
