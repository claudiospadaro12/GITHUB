#!/usr/bin/env python3
"""Riga unica: The Gold Reaper col set prop (MaxAllowedDD 9, limite 4) con Randomization 75 e 100 (2013, 2018, 2020, 2025 a Modello 1, 80.000 EUR, piu 2013 e 2020 ripetute) e con TradeFrequency Auto (5) invece di moderate (2) a Randomization 0, piu un controllo 2013 a TradeFrequency 2. Uso: python3 gen_riga_reaper_random_80k.py <PIN40>"""
import sys, re, os, subprocess
PIN = sys.argv[1]; os.chdir(os.path.dirname(os.path.abspath(__file__)))
subprocess.check_call([sys.executable, 'gen_riga_tre_anni_80k.py', PIN])
t = open('righe/RIGA_LANCIA_TRE_ANNI_80K_3EA.txt', encoding='ascii').read()
def sost(a, b, tutte=False):
    global t
    assert t.count(a) >= 1, a[:70]
    t = t.replace(a, b) if tutte else t.replace(a, b, 1)
EX = 'The Gold Reaper MT5.ex5'
COM = 'FakeOutFilter=2:i;UseHL_TrailingSL=true:b;Risk=1234:i;StartLots=0.01:d;MaxRiskPerStrategy_=1.0:d;ManualBalance=0.0:d;UseWeightedLots=true:b;'
def GRI(ra, tf='2'): return 'TradeFrequency=%s:i;' % tf + COM + 'MaxAllowedDD=9.0:d;PropFirmMaxDailyDD=4.0:d;OnlyUp=false:b;Virtual_expiration=true:b;Randomization=%s:d' % ra
runs = []
for ra in ('75.0', '100.0'):
    r = ra.split('.')[0]
    for anno in ('2013', '2018', '2020', '2025'): runs.append((EX, anno, '1', 'H1', 'XAUUSD', GRI(ra), '', '%s_M1_GR_R%sA' % (anno, r)))
    for anno in ('2013', '2020'): runs.append((EX, anno, '1', 'H1', 'XAUUSD', GRI(ra), '', '%s_M1_GR_R%sB' % (anno, r)))
for anno in ('2013', '2018', '2020', '2025'): runs.append((EX, anno, '1', 'H1', 'XAUUSD', GRI('0.0', '5'), '', '%s_M1_GR_AUTO' % anno))
runs.append((EX, '2013', '1', 'H1', 'XAUUSD', GRI('0.0', '2'), '', '2013_M1_GR_MODCTRL'))
q = lambda L: ','.join("'" + x + "'" for x in L)
i = t.index("Write-Host 'TRE ANNI DELLO STORICO"); j = t.index("' -ForegroundColor Cyan;", i)
testa = ("THE GOLD REAPER CON RANDOMIZATION 75 E 100 (80.000 EUR, DEMO, SOLO TESTER): XAUUSD H1, set prop (MaxAllowedDD 9, limite giornaliero 4, OnlyUp spento), TUTTI gli input imposti. Wim consiglia per FTMO Randomization 75-100; noi abbiamo misurato solo 0 e 50. 17 PASSATE a Modello 1 (OHLC 1 minuto): 2013, 2018, 2020 e 2025 per Randomization 75 e per 100 (8) piu il 2013 e il 2020 RIPETUTI per ogni valore (4) per misurare quanto cambia da una corsa identica all altra; piu TradeFrequency AUTO (valore 5, quello che Wim scrive nel messaggio) invece di moderate (2), con Randomization 0, sui quattro anni (4), piu un controllo 2013 con moderate e gli stessi input (1). TEMPO: circa 1,5-2,5 ore in tutto (stima); timeout 420 minuti per passata. Criteri e previsioni scritti PRIMA dei numeri: report/REAPER_RANDOMIZATION_75_100_CRITERI_2026-10-30.md. Non giudica acquisti ne taglie. NON e collaudata da agenti: ha passato SOLO il cancello meccanico controlla_riga.py e il mio controllo. MT5 deve essere CHIUSO")
t = t[:i] + "Write-Host '" + testa + t[j:]
a = t.index('$fare=@('); b = t.index('$IMP=@{')
t = t[:a] + "$fare=@(" + q([r[0] for r in runs]) + "); $ANNI=@(" + q([r[1] for r in runs]) + "); $MOD=@(" + q([r[2] for r in runs]) + "); $PER=@(" + q([r[3] for r in runs]) + "); $SIMR=@(" + q([r[4] for r in runs]) + "); $IMPR=@(" + q([r[5] for r in runs]) + "); $FINR=@(" + q([r[6] for r in runs]) + "); $ETI=@(" + q([r[7] for r in runs]) + "); $vi=0; " + t[b:]
t, n = re.subn(r"if\(\$okl\.Count -lt \d+\)\{ throw '[^']*' \}", "if($okl.Count -lt 1){ throw 'Manca The Gold Reaper nel Market di questo terminale. Nessun tester e partito.' }", t, count=1); assert n == 1
sost("$TO=240;", "$TO=420;")
sost("$im=''; if($IMP.ContainsKey($n)){ $im=$IMP[$n] };", "$im=$IMPR[$vi]; $sy=$SIMR[$vi]; $ex=@(); if($FINR[$vi] -ne ''){ $ex=@('-Fine',$FINR[$vi]) };")
sost("$bs=Join-Path $OUT ($an + '_M' + $mo);", "$bs=Join-Path $OUT $ETI[$vi];")
sost("EUR, ' + $pdg + ', Modello ' + $mo)", "EUR, ' + $sy + ' ' + $pdg + ', Modello ' + $mo)")
sost("-Anno $an -Modello $mo -Periodo $pdg -Base $bs", "-Anno $an -Modello $mo -Periodo $pdg -Simbolo $sy -Base $bs @ex", True)
sost("ABTG_RISULTATI\\ANNO80K_TRE_EA_'", "ABTG_RISULTATI\\ANNO80K_REAPER_RANDOM_'")
sost("('ANNO80K_TRE_EA_' + (Get-Date)", "('ANNO80K_REAPER_RANDOM_' + (Get-Date)")
t = t.replace('gli EA indicati devono essere gia installati', 'The Gold Reaper deve essere gia installato')
open('righe/RIGA_LANCIA_REAPER_RANDOM_80K.txt', 'w', encoding='ascii').write(t)
print('scritta', len(t), 'passate', len(runs))
