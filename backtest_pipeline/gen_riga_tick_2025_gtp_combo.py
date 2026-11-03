#!/usr/bin/env python3
"""Riga unica: Gold Trade Pro (Profalgo, XAUUSD D1) con i set del venditore (cambiano solo MaxRiskPerStrategy e PropFirmMaxDailyDD, piu Risk=3 = lotto da rischio per strategia) sui tre anni 2013/2018/2020 e 2025 a Modello 1, poi tick reali. 80.000 EUR. Uso: python3 gen_riga_gtp_80k.py <PIN40>"""
import sys, re, os, subprocess
PIN = sys.argv[1]; os.chdir(os.path.dirname(os.path.abspath(__file__)))
subprocess.check_call([sys.executable, 'gen_riga_tre_anni_80k.py', PIN])
t = open('righe/RIGA_LANCIA_TRE_ANNI_80K_3EA.txt', encoding='ascii').read()
def sost(a, b, tutte=False):
    global t
    assert t.count(a) >= 1, a[:70]
    t = t.replace(a, b) if tutte else t.replace(a, b, 1)
EX = 'Gold Trade Pro MT5.ex5'
# (nome, etichetta breve, MaxRiskPerStrategy, PropFirmMaxDailyDD): i 4 set .set del venditore differiscono solo in questi due input
def imp(r, dd): return 'Risk=3:i;MaxRiskPerStrategy=%s:d;PropFirmMaxDailyDD=%s:d' % (r, dd)
runs = [(EX, '2025', '4', 'D1', 'XAUUSD', imp('0.5', '4.0'), '', '2025_M4_GTP_COMBO')]
q = lambda L: ','.join("'" + x + "'" for x in L)
i = t.index("Write-Host 'TRE ANNI DELLO STORICO"); j = t.index("' -ForegroundColor Cyan;", i)
testa = ("GOLD TRADE PRO COMBO A TICK REALI NEL 2025 (80.000 EUR, DEMO, SOLO TESTER): XAUUSD D1, UNA corsa 01/01/2025 - 01/01/2026, Modello 4 (TICK REALI), set COMBO (Risk=3, MaxRiskPerStrategy 0,5, PropFirmMaxDailyDD 4,0). Criteri e previsioni scritti prima: report/GTP_COMBO_TICK_2025_CRITERI_2026-11-03.md. TEMPO: circa 1-1,5 ore. Serve a misurare il COMBO a tick reali come gia fatto per Reaper, Goldbot e Phantom. Non giudica acquisti ne taglie.")
t = t[:i] + "Write-Host '" + testa + t[j:]
a = t.index('$fare=@('); b = t.index('$IMP=@{')
t = t[:a] + "$fare=@(" + q([r[0] for r in runs]) + "); $ANNI=@(" + q([r[1] for r in runs]) + "); $MOD=@(" + q([r[2] for r in runs]) + "); $PER=@(" + q([r[3] for r in runs]) + "); $SIMR=@(" + q([r[4] for r in runs]) + "); $IMPR=@(" + q([r[5] for r in runs]) + "); $FINR=@(" + q([r[6] for r in runs]) + "); $ETI=@(" + q([r[7] for r in runs]) + "); $vi=0; " + t[b:]
t, n = re.subn(r"if\(\$okl\.Count -lt \d+\)\{ throw '[^']*' \}", "if($okl.Count -lt 1){ throw 'Manca Goldtrade Pro nel Market di questo terminale. Nessun tester e partito.' }", t, count=1); assert n == 1
sost("$TO=240;", "$TO=420;")
sost("$im=''; if($IMP.ContainsKey($n)){ $im=$IMP[$n] };", "$im=$IMPR[$vi]; $sy=$SIMR[$vi]; $ex=@(); if($FINR[$vi] -ne ''){ $ex=@('-Fine',$FINR[$vi]) };")
sost("$bs=Join-Path $OUT ($an + '_M' + $mo);", "$bs=Join-Path $OUT $ETI[$vi];")
sost("EUR, ' + $pdg + ', Modello ' + $mo)", "EUR, ' + $sy + ' ' + $pdg + ', Modello ' + $mo)")
sost("-Anno $an -Modello $mo -Periodo $pdg -Base $bs", "-Anno $an -Modello $mo -Periodo $pdg -Simbolo $sy -Base $bs @ex", True)
sost("ABTG_RISULTATI\\ANNO80K_TRE_EA_'", "ABTG_RISULTATI\\ANNO80K_TICK_2025_GTP_'")
sost("('ANNO80K_TRE_EA_' + (Get-Date)", "('ANNO80K_TICK_2025_GTP_' + (Get-Date)")
t = t.replace('gli EA indicati devono essere gia installati', 'Gold Trade Pro deve essere gia installato')
open('righe/RIGA_LANCIA_TICK_2025_GTP_COMBO_80K.txt', 'w', encoding='ascii').write(t)
print('scritta', len(t), 'passate', len(runs))
